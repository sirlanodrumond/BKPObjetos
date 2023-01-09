CREATE OR REPLACE PROCEDURE SP_VALIDA_VEICULO(VS_PLACA        IN CHAR,
                                              VS_TIPO         IN CHAR,
                                              VS_ERRO         OUT VARCHAR2,
                                              VS_PLACACARRETA OUT VARCHAR2,
                                              VS_CONJUNTO     OUT VARCHAR2,
                                              vs_MOTORISTA    OUT VARCHAR2,
                                              VS_ODOMETRO     OUT VARCHAR2) IS
  VS_CONTAANTENA        INTEGER;
  VS_CONTADOR           integer;
  VS_CPFMOTORISTA       T_FRT_MOTORISTA.FRT_MOTORISTA_CPF%TYPE;
  VS_DTRISCO            DATE;
  VS_TOTAL              integer;
  VS_DEBITO             integer;
  VS_MANUABERTA         integer;
  VS_CALIBRAGEM         integer;
  VS_MANUTCARRETA       integer;
  VS_DTRECEBTACOGRAFO   DATE;
  VS_CODIGOBLOQEVENTUAL VARCHAR2(100);
  VS_VENCTO_CHECKLIST   DATE;
  VS_PROGRAM            VARCHAR2(100);
  vs_ip                 v_glb_ambiente.ip_address%type;
  vs_terminal           v_glb_ambiente.terminal%type;
  vs_osuser             v_glb_ambiente.os_user%type;
  vs_hora               integer;
  --V_VEICULO             T_FRT_VEICULO.FRT_VEICULO_CODIGO%TYPE;
  v_achou               boolean;
  vs_codigomotorista    tdvadm.t_frt_motorista.frt_motorista_codigo%type;
  vs_recibo              integer;  
  vPrazo                number;
  VS_ERRO_AUX           VARCHAR2(4000);
  v_UsaPesqCons         char(1);
  vValeFrete            varchar2(20);
  vPlaca                varchar2(10) ;
  vTipo                 char(1);
  vPonteiro             number;
  vAuxiliar             integer;
  -- ALTERAÇÃO NA LINHA 817 - DANIEL - (TRAVA VEÍCULOS PELO NOVO SISTEMA) : 17/12/2009

BEGIN
  vPonteiro := 0;
  VS_CONTADOR := 0;

  BEGIN
    
-- If VS_PLACA in ('A006381','KMV8207') Then
--     raise_application_error(-20111,'PASSANDO AQUI ' || VS_PLACA || '-' || VS_TIPO );
--  End If;

  select t.ip_address, to_number(to_char(sysdate, 'hh24')),lower(t.PROGRAM),t.terminal,t.os_user
    into vs_ip, vs_hora , VS_PROGRAM,vs_terminal,vs_osuser
    from v_glb_ambiente t;
  
  vTipo :=  trim(substr(VS_TIPO,1,1));
    
/*  If SUBSTr(VS_PLACA,1,3) = '000' THen
     vTipo := 'F';
  Elsif SUBSTr(VS_PLACA,1,3) = 'A00' Then   
     vTipo := 'A';
  Else
     vTipo :=  VS_TIPO;
  End If;*/

  if ( vs_program = 'projetovalefrete.exe')  and 
     ( tdvadm.pkg_con_valefrete.vProcValidaValeFrete = 'N' )  Then
    return;
  End If;  
   
  insert into tdvadm.t_glb_sql values (null,sysdate,'TESTE BLOQUEIO-SP_VALIDA_VEICULO-'||vs_osuser,VS_PROGRAM||'-'||vTIPO || '-' || VS_PLACA || '-' || VS_CPFMOTORISTA);
 -- commit;
  
  vPonteiro := 1;
  If SUBSTr(VS_PLACA,1,3) IN ('000','A00') Then
    vPlaca := TDVADM.PKG_FRTCAR_VEICULO.FN_GET_PLACA(VS_PLACA) ;
  Else
    vPlaca := VS_PLACA;
  End If; 


  
  



    vPonteiro := 2;

    if TRIM(VS_PROGRAM) in ('valefrete.exe','prj_cadidvalidacao.exe') Then
       SP_CAR_BLOQUEIOS(vPlaca ,
                        vTIPO,
                        sysdate,
                        'SP_VALIDA_VEICULO',
                        'SP_VALIDA_VEICULO',
                        'SP_VALIDA_VEICULO',
                        VS_ERRO_AUX,
                        VS_CONTADOR);
       VS_CONTADOR := 0;
    end if;                    
   vPonteiro := 3;


/*  if(substr(vs_ip, 1, 10) = '192.9.200.' )
   or (vs_hora >= 8 and vs_hora <= 18) then
*/  
    
    
    --TIPOANTENA (TABELA T_ATR_TERMINAL) ESTA CORRETO -> A - AGREGADO, F - FROTA, D-DEDICADO
  
    --/******************************************************   
    ---- VERIFICA DADOS DO MOTORISTA SE FOR FROTA ***********
    --/*****************************************************
    vs_codigomotorista := '';
    vPonteiro := 4;

    IF (vTIPO = 'F' OR vTIPO = 'P') THEN
      FOR X IN (SELECT
                --Calibragem ( > 0 esta vencido)
                 trunc(sysdate) -
                 (trunc(nvl(a.frt_veiculo_dtcalibragem, '01/01/1900'))) - 60 calibragem,
                 /* select INT_PARAMETROS_STRING 
                                                                                                                                                                                                                                                                                                                                                                                              FROM T_INT_PARAMETROS
                                                                                                                                                                                                                                                                                                                                                                                             WHERE INT_PARAMETROS_SISTEMA = 'FRT'
                                                                                                                                                                                                                                                                                                                                                                                               AND INT_PARAMETROS_CODIGO = 'CALIBRAGEM'
                                                                                                                                                                                                                                                                                                                                                                                         */
                 --Manutenc?o ( > 30.000 esta vencido)         
                 nvl(a.frt_veiculo_odomult, 0) -
                 NVL(a.frt_veiculo_kminicialmanut, 0) manutencao,
                 SUBSTR(FN_RETCONJUNTO(A.FRT_VEICULO_PLACA), 1, 7) CONJUNTO,
                 SUBSTR(pkg_frtcar_veiculo.fn_get_placa(SUBSTR(FN_RETCODVEIC(FN_RETCONJUNTO(A.FRT_VEICULO_PLACA),
                                                          'N'),
                                            1,
                                            7)),
                        1,
                        8) CARRETA,
                 F.FRT_MOTORISTA_CNHCODIGO REGISTRO,
                 SUBSTR(TRIM(A.FRT_VEICULO_ANOFABRICACAO), 1, 4) ANOFAB,
                 '00248440' RNTRC,
                 A.frt_veiculo_certificadocodigo certprop,
                 F.FRT_MOTORISTA_INPS_CODIGO INSS,
                 F.FRT_MOTORISTA_CNHVECTO CNH,
                 FRT_MOTORISTA_MOB MOPE,
                 FRT_MOTORISTA_EXMEDICO EXMEDICO,
                 FRT_MOTORISTA_INTEGRACAO INTEGRACAO,
                 FRT_MOTORISTA_DTADMISSAO CONTRATO,
                 frt_motorista_cpf || '-' || FRT_MOTORISTA_NOME MOTORISTA,
                 FRT_MOTORISTA_CPF CPF,
                 F.FRT_MOTORISTA_DATANASC DATANASC,
                 F.FRT_MOTORISTA_CIDADENASC CIDADENASC,
                 F.GLB_ESTADONASC_CODIGO UFNASC,
                 F.FRT_MOTORISTA_RGCODIGO RG,
                 F.FRT_MOTORISTA_RGCIDADE RGCIDADE,
                 F.GLB_ESTADORG_CODIGO UFRG,
                 F.FRT_MOTORISTA_FILIACAO_MAE MAE,
                 A.FRT_VEICULO_ODOMULT ODOMETRO,
                 TRUNC(SYSDATE) - A.FRT_VEICULO_DTCALIBRAGEM DIAS_CALIBRAGEM,
                 TRIM(fn_get_bloqueio(A.FRT_VEICULO_PLACA)) BLQ_EVENTUAL,
                 d.frt_motorista_codigo,
                 frt_veiculo_tacografo,
                 '61139432000172' cpfprop,
                 (select at.afvalor
                  from fpw.atribfun at
                  where 0 = 0
                    and at.afcodemp = 1
                    and at.afcodatrib = 27
                    and at.afmatfunc = (select fp.fumatfunc
                                        from fpw.funciona fp
                                        where fp.fucpf = f.frt_motorista_cpf
                                          and fp.fudtadmis = (select max(fp1.fudtadmis)
                                                              from fpw.funciona fp1
                                                              where fp1.fucpf = fp.fucpf))) tpmot 
                  FROM T_FRT_VEICULO    A,
                       T_FRT_MARMODVEIC B,
                       T_FRT_TPVEICULO  C,
                       T_FRT_CONJUNTO   D,
                       T_FRT_CONTENG    E,
                       T_FRT_MOTORISTA  F
                 WHERE A.FRT_VEICULO_DATAVENDA IS NULL
                   AND A.FRT_MARMODVEIC_CODIGO = B.FRT_MARMODVEIC_CODIGO
                   AND B.FRT_TPVEICULO_CODIGO = C.FRT_TPVEICULO_CODIGO
                   AND A.FRT_VEICULO_CODIGO = E.FRT_VEICULO_CODIGO
                   AND E.FRT_CONJVEICULO_CODIGO =
                       D.FRT_CONJVEICULO_CODIGO(+)
                   AND D.FRT_MOTORISTA_CODIGO = F.FRT_MOTORISTA_CODIGO
                   and A.FRT_VEICULO_PLACA = vPlaca) LOOP
      
        vPonteiro := 5;
        VS_CODIGOBLOQEVENTUAL := X.BLQ_EVENTUAL;
        vPonteiro := 6;
        Begin
           VS_MOTORISTA          := substr(X.MOTORISTA,1,99);
        exception
          When OTHERS Then
             VS_MOTORISTA := '';
          end;
        vPonteiro := 7;
        VS_CONJUNTO           := X.CONJUNTO;
        vPonteiro := 8;
        vS_PlacaCARRETA       := X.CARRETA;
        VS_ODOMETRO           := X.ODOMETRO;
        VS_CPFMOTORISTA       := x.cpf;
        VS_CALIBRAGEM         := x.dias_Calibragem;
        vs_codigomotorista    := x.frt_motorista_codigo; 
        IF (vTIPO = 'F') THEN
        
          -- Calibragem Vencida      
          if x.calibragem > 0 then
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000018#';
          else
            if (x.dias_calibragem > 50) then
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000023#';
            end if;
          end if;
        
          if (x.BLQ_EVENTUAL IS NOT NULL) AND
             (TRIM(VS_PROGRAM) = 'valefrete.exe') THEN
            VS_ERRO_AUX := VS_ERRO_AUX || VS_CODIGOBLOQEVENTUAL;
          end if;
        
          --Manutenc?o Vencida
          if x.manutencao > 30000 then
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000019#';
          end if;
        
          ---------- VERIFICAR DATA DO ULTIMO RECEBIMENTO DE DISCOS DE TACOGRAFO --------------
        
          SELECT NVL(MAX(FRT_TACOGRAFO_DTTROCA), '01/01/1901')
            INTO VS_DTRECEBTACOGRAFO
            FROM T_FRT_TACOGRAFO
           WHERE FRT_CONJVEICULO_CODIGO = VS_CONJUNTO;
           
           IF (VS_CONJUNTO = 'JWC1934') AND (TRUNC(SYSDATE) = '30/07/2011') THEN
              VS_DTRECEBTACOGRAFO := TRUNC(SYSDATE);  
           END IF;
        
          --IF VS_DTRECEBTACOGRAFO <> '01/01/1901' THEN
          IF (TRUNC(SYSDATE) - TRUNC(VS_DTRECEBTACOGRAFO) >= 10) OR
             (VS_DTRECEBTACOGRAFO = '01/01/1901') THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000024#';
          END IF;
          --END IF;
        
        
          -- verifica a avericao do TACOGRAFO
          -- se faltar menos de 30 dias envia alerta
          If trunc(x.frt_veiculo_tacografo) < trunc(Sysdate + 30 ) Then
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000042#';
          End If;
        
          -------- N?O POSSUI CONTRATO ------------      
          /*                                Junior - Desabilitei pelo fato de ser frota
          IF (X.CONTRATO IS NULL ) THEN
             VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000017#';
          END IF; 
          */
        
          -------- VERIFICA INSS            
          --             IF X.INSS IS NULL THEN
          --                VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000016#';
          --             END IF;
        
          /*
             
              -------- VERIFICA CERTIFICADO DE PROP            
             IF X.certprop IS NULL THEN
                 VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000015#';
             END IF;
          
          */
          -------- VERIFICA RNTRC  
          
          
          
                    
          IF X.RNTRC IS NULL THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000013#';
          Else
            select count(*)
              into VS_CONTADOR
            from t_gsr_movimento m
            where m.gsr_gerrisco_codigo = '02'
              and m.gsr_gerriscoprod_codigo = '04'
              and m.gsr_movimento_codliberacao like '%BLQ%'
              and trim(m.car_carreteiro_cpfcodigo) = trim(x.cpfprop);
              if VS_CONTADOR > 0 then
                 VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000013#';
              end if;  
          END IF;
          
       
          -------- VERIFICA MOPE
          IF (VS_CONJUNTO = 'A003827') AND (TRUNC(SYSDATE) = '30/07/2011') THEN
           
          if f_valida(X.MOPE,'D') = 'S' then 
               if (to_date(X.MOPE,'dd/mm/yyyy') - sysdate ) <= 0 then 
                   VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000035#';
               elsif (to_date(X.MOPE,'dd/mm/yyyy') - sysdate  ) < 30 then
                   VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000031#';
               end if;    
          else
                VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000012#';
          end if;
          END IF;
          
          IF (VS_CONJUNTO = 'A003827') AND (TRUNC(SYSDATE) = '30/07/2011') THEN
              VS_DTRECEBTACOGRAFO := TRUNC(SYSDATE);  
           END IF;
          ------- N?O EXITE INTEGRAC?O PARA O MOTORISTA ------------      
          IF (X.INTEGRACAO IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000010#';
          END IF;
        
          IF X.TPMOT = 'TANQUE' THEN
             vPrazo := 180;
          Else
             vPrazo := 365;
          End if;     
          -------- EXAME MEDICO VENCIDO OU ESTA PARA VENCER ------------      
          IF (TRUNC(SYSDATE - X.EXMEDICO) > vPrazo OR X.EXMEDICO IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000020#';
          else
            -- alterado para 10 dias antes do vencimento
            IF (TRUNC(SYSDATE - X.EXMEDICO) > vPrazo - 10) THEN
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000009#';
            END IF;
          end if;
        
          -------- CNH VENCIDO OU ESTA PARA VENCER frota------------
          IF (TRUNC(SYSDATE - X.CNH) > 28 OR X.CNH IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000008#';
          END IF;
        
          -------- ANO DE FABRICACAO ACIMA DE 10 ANOS
          --           IF ((SUBSTR(SYSDATE,7,10)- X.ANOFAB) > 10) THEN
          --               VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000007#';
          --          END IF; 
        
          -------VERIFICA POSSIVEIS DEBITOS PARA O MOTORISTA/VEICULO
        
          SELECT COUNT(*) DEBITO
            INTO VS_DEBITO
            FROM T_FRT_MULTAS A, T_FRT_VEICULO B
           WHERE A.FRT_MOTORISTA_CPF = VS_CPFMOTORISTA
             AND A.FRT_MULTAS_STATUS = 'N'
             -- ******** Diego Lirio ***************************
             -- * Alteracão verifica se multa foi paga 
             --And A.FRT_MULTAS_SITUACAO = 'PG'
             And A.Frt_Multas_Dtenvbco is Null
             -- quando não houver Recurso, ou se houve recurso mas nao foi concedido...
             And (A.FRT_MULTAS_FLGRECURSO = 'N' or (A.FRT_MULTAS_FLGRECURSO = 'S' AND A.FRT_MULTAS_RECURSOINDEREFIDO = 'S'))
             -- ************************************************
             AND A.FRT_VEICULO_CODIGO = B.FRT_VEICULO_CODIGO;
        
          IF (VS_DEBITO > 0) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000022#';
          END IF;
        
          -------- REGISTRO CNH INVALIDO
          if (replace(X.REGISTRO, substr(X.REGISTRO, 1, 1), '') = '') then
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000006#';
          end if;
        END IF;
        -------- VERIFICA SE EXISTE CONJUNTO
        IF (FN_RETCONJUNTO(vPlaca) IS NULL) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000005';
        END IF;
      
      END LOOP;
    
      --VS_CODIGOBLOQEVENTUAL := TRIM(fn_get_bloqueio(vPlaca));
    
      --VS_ERRO_AUX := VS_ERRO_AUX || TRIM(VS_CODIGOBLOQEVENTUAL) || '#';
    
      /*      
        FOR Y 
           IN(SELECT POR_EVENTUALMSG_CODIGO CODIGO_BLQ
                FROM T_POR_EVENTUALMSG 
               WHERE POR_EVENTUALMSG_PLACA = vPlaca
                 AND POR_EVENTUALMSG_BLOQUEIA = 'N')
           LOOP
           
           VS_CODIGOBLOQEVENTUAL := Y.CODIGO_BLQ;
           
            if Y.CODIGO_BLQ IS NOT NULL THEN
               VS_ERRO_AUX := VS_ERRO_AUX || VS_CODIGOBLOQEVENTUAL || '#';
            end if;
        END LOOP;
       
      */
    END IF;
  
    --/******************************************************   
    ---- VERIFICA DADOS DO MOTORISTA SE FOR AGREGADO ***********
    --/*****************************************************
    vs_contador := 0;
    IF vTIPO = 'A' THEN
      FOR X IN (SELECT DISTINCT trunc(sysdate) -
                                (trunc(nvl(a.frt_veiculo_dtcalibragem,
                                           '01/01/1900'))) - 60 calibragem,
                                trunc(sysdate) -
                                (trunc(nvl(a.frt_veiculo_dtultmanut,
                                           '01/01/1900'))) - 60 manut,
                                SUBSTR(FN_RETCONJUNTO(A.FRT_VEICULO_PLACA),
                                       1,
                                       7) CONJUNTO,
                                A.FRT_VEICULO_ODOMULT ODOMETRO,
                                G.CAR_CARRETEIRO_INPS_CODIGO INSS,
                                H.CAR_PROPRIETARIO_INPS_CODIGO INSSPROP,
                                A.FRT_VEICULO_CERTIFICADOCODIGO CERTPROP,
                                A.FRT_VEICULO_PLACA PLACA,
                                SUBSTR(pkg_frtcar_veiculo.fn_get_placa(SUBSTR(FN_RETCODVEIC(FN_RETCONJUNTO(A.FRT_VEICULO_PLACA),
                                                                         'N'),
                                                           1,
                                                           7)),
                                       1,
                                       7) CARRETA,
                                G.CAR_CARRETEIRO_CNHCODIGO REGISTRO,
                                SUBSTR(TRIM(A.FRT_VEICULO_ANOFABRICACAO),
                                       1,
                                       4) ANOFAB,
                                G.CAR_CARRETEIRO_CNHVECTO CNH,
                                G.CAR_CARRETEIRO_MOP MOPE,
                                G.CAR_CARRETEIRO_EXMEDICO EXMEDICO,
                                G.CAR_CARRETEIRO_INTEGRACAO INTEGRACAO,
                                F.CAR_VEICULO_CONTRATO CONTRATO,
                                H.CAR_PROPRIETARIO_RNTRC RNTRC,
                                H.CAR_PROPRIETARIO_RAZAOSOCIAL PROPRIETARIO,
                                H.CAR_PROPRIETARIO_CGCCPFCODIGO CPFCGC,
                                G.CAR_CARRETEIRO_NOME MOTORISTA,
                                G.CAR_CARRETEIRO_CPFCODIGO CPF,
                                G.CAR_CARRETEIRO_DATANASC DATANASC,
                                G.CAR_CARRETEIRO_CIDADENASC CIDADENASC,
                                G.GLB_ESTADONASC_CODIGO UFNASC,
                                G.CAR_CARRETEIRO_RGCODIGO RG,
                                G.CAR_CARRETEIRO_RGCIDADE RGCIDADE,
                                G.GLB_ESTADORG_CODIGO UFRG,
                                G.CAR_CARRETEIRO_FILIACAO_MAE MAE,
                                TRUNC(SYSDATE) - A.FRT_VEICULO_DTCALIBRAGEM DIAS_CALIBRAGEM,
                                TRUNC(SYSDATE) - A.FRT_VEICULO_DTULTMANUT DIAS_MANUT,
                                TRIM(fn_get_bloqueio(A.FRT_VEICULO_PLACA)) BLQ_EVENTUAL,
                                A.FRT_VEICULO_CHECKLIST VENCTO_CHEKLIST,
                                h.car_proprietario_ie
                  FROM T_FRT_VEICULO      A,
                       T_FRT_MARMODVEIC   B,
                       T_FRT_TPVEICULO    C,
                       T_FRT_CONTENG      E,
                       T_CAR_VEICULO      F,
                       T_CAR_CARRETEIRO   G,
                       T_CAR_PROPRIETARIO H
                
                 WHERE A.FRT_MARMODVEIC_CODIGO = B.FRT_MARMODVEIC_CODIGO
                   AND B.FRT_TPVEICULO_CODIGO = C.FRT_TPVEICULO_CODIGO
                   AND A.FRT_VEICULO_CODIGO = E.FRT_VEICULO_CODIGO
                      
                   AND f.CAR_VEICULO_SAQUE =
                       (SELECT MAX(CAR_VEICULO_SAQUE)
                          FROM T_CAR_VEICULO A
                         where F.CAR_VEICULO_PLACA = a.car_veiculo_placa(+))
                      
                   AND G.car_carreteiro_saque =
                       (SELECT MAX(car_carreteiro_saque)
                          FROM T_CAR_CARRETEIRO Y
                         where G.CAR_CARRETEIRO_CPFCODIGO =
                               Y.CAR_CARRETEIRO_CPFCODIGO(+))
                      
                   AND B.FRT_TPVEICULO_CODIGO IN ('001', '002')
                   AND C.FRT_TPVEICULO_TRACAO = 'S'
                   AND A.FRT_VEICULO_DATAVENDA IS NULL
                   AND SUBSTR(FN_RETCONJUNTO(A.FRT_VEICULO_PLACA), 1, 2) = 'A0'
                   AND A.FRT_VEICULO_PLACA = F.CAR_VEICULO_PLACA(+)
                   AND F.CAR_VEICULO_PLACA = G.CAR_VEICULO_PLACA(+)
                   AND F.CAR_VEICULO_SAQUE = G.CAR_VEICULO_SAQUE(+)
                   AND F.CAR_PROPRIETARIO_CGCCPFCODIGO =
                       H.CAR_PROPRIETARIO_CGCCPFCODIGO
                   and A.FRT_VEICULO_PLACA = vPlaca) LOOP
      
        VS_CPFMOTORISTA       := TRIM(X.CPF);
        VS_CONTADOR           := VS_CONTADOR + 1;
        VS_MOTORISTA          := trim(substr(X.MOTORISTA,1,100));
        VS_CONJUNTO           := X.CONJUNTO;
        VS_PlacaCARRETA       := X.CARRETA;
        VS_ODOMETRO           := X.ODOMETRO;
        VS_CALIBRAGEM         := X.DIAS_CALIBRAGEM;
        VS_MANUTCARRETA       := X.MANUT;
        VS_CODIGOBLOQEVENTUAL := X.BLQ_EVENTUAL;
        VS_VENCTO_CHECKLIST   := X.VENCTO_CHEKLIST;
      
--        raise_application_error(-20001,'sirlano ' || vPlaca || VS_CONJUNTO);
        IF (vTIPO = 'A') Then
          SELECT NVL(SUM(CAR_CONTACORRENTE_VALOR), 0) TOTAL
            INTO VS_TOTAL
            FROM T_CAR_CONTACORRENTE
           WHERE CAR_VEICULO_PLACA = vPlaca
--             AND CAR_CONTACORRENTE_TPLANCAMENTO = 'D'
             AND CAR_CONTACORRENTE_SALDO > 0
             AND CAR_CONTACORRENTE_DTFECHA IS NULL
             AND TRUNC(CAR_CONTACORRENTE_DTVENC) <= TRUNC(SYSDATE);
          IF (VS_TOTAL > 0) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000021#';
          END IF;
        
        END IF;
      
        ------ VEICULO NAO POSSUI CHECK-LIST OU CHECK-LIST ESTA VENCIDO -----
      
        IF VS_VENCTO_CHECKLIST IS NULL THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000025#';
        ELSIF (TRUNC(SYSDATE) - VS_VENCTO_CHECKLIST > 365) THEN
        --rotina que cria pre os checlist  Alexandre Shiaraiwa 05/02/2012
         -- tdvadm.pkg_cadastraos.sp_criaCheckList(vPlaca,vs_odometro,'');
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000026#';
        END IF;
      
        if (x.BLQ_EVENTUAL IS NOT NULL) AND
           (TRIM(VS_PROGRAM) = 'valefrete.exe') THEN
          VS_ERRO_AUX := VS_ERRO_AUX || VS_CODIGOBLOQEVENTUAL;
        end if;
      
        --------------- VERIFICA DEBITO DE MULTAS ----------- JUNIOR 01/08/2005
      
        SELECT COUNT(*) DEBITO
          INTO VS_DEBITO
          FROM T_FRT_MULTAS A, T_FRT_VEICULO B
         WHERE A.FRT_MOTORISTA_CPF = VS_CPFMOTORISTA
           AND A.FRT_MULTAS_STATUS = 'N'
           AND A.FRT_VEICULO_CODIGO = B.FRT_VEICULO_CODIGO;
      
        IF (VS_DEBITO > 0) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000022#';
        END IF;
      
        ---------- VERIFICAR DATA DO ULTIMO RECEBIMENTO DE DISCOS DE TACOGRAFO --------------
      
        SELECT NVL(MAX(FRT_TACOGRAFO_DTTROCA), '01/01/1901')
          INTO VS_DTRECEBTACOGRAFO
          FROM T_FRT_TACOGRAFO
         WHERE FRT_CONJVEICULO_CODIGO = VS_CONJUNTO;
       
       
       IF (VS_CONJUNTO = 'A003827') AND (TRUNC(SYSDATE) = '30/07/2011') THEN
              VS_DTRECEBTACOGRAFO := TRUNC(SYSDATE);  
           END IF;
      
        --IF VS_DTRECEBTACOGRAFO <> '01/01/1901' THEN
        IF (TRUNC(SYSDATE) - TRUNC(VS_DTRECEBTACOGRAFO) >= 10) OR
           (VS_DTRECEBTACOGRAFO = '01/01/1901') THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000024#';
        END IF;
        --END IF;
      
        -------- CALIBRAGEM ------------                  
        if x.calibragem > 0 then
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000038#';
        else
          if (x.dias_calibragem > 50) then
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000039#';
          end if;
        end if;
      
        -------- MANUTENCAO CARRETA ------------                  
        /*
        
        Conceito de Controle da Manutenc?o da Carreta
        
        if x.manut > 0 then   
               VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000027#';
        else
            if (x.Dias_Manut > 50) then
              VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000028#';     
           end if;         
        end if;
        */
      
        -------- N?O POSSUI CONTRATO ------------      
        IF (X.CONTRATO IS NULL) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000017#';
        END IF;
      
        -------- VERIFICA INSS MOTORISTA
        IF (X.INSS IS NULL) and (length(trim(x.CPFCGC)) < 13) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000016#';
        END IF;
      
        -------- VERIFICA INSS PROPRIETARIO
        IF (X.INSSPROP IS NULL) and (length(trim(x.CPFCGC)) < 13) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000037#';
        END IF;
        /*  
        
        -------- VERIFICA CERTIFICADO DE PROP            
        IF X.certprop IS NULL THEN
              VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000015#';
        END IF;
        
        */
      
        -------- VERIFICA INSCRICAO ESTADUAL DO PROPRIETARIO
        IF LENGTH(TRIM(X.CPFCGC)) > 11 THEN
           IF X.car_proprietario_ie IS NULL THEN
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000036#';
           END IF;           
        END IF; 
        
      
      
        -------- VERIFICA RNTRC            
        IF (X.RNTRC IS NULL) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000013#';
        ELSE
          -- TROCAR O TIPO PARA NIVEL 1 NO FINAL DE DEZEMBRO/2009
          -- SIRLANO
          IF f_enumerico(TRIM(X.RNTRC)) = 'N' THEN
             VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000013#';
          ELSE
            IF (LENGTH(TRIM(X.RNTRC)) <> 8)  THEN
               VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000013#';
            Else

                select count(*)
                  into VS_CONTADOR
                from t_gsr_movimento m
                where m.gsr_gerrisco_codigo = '02'
                  and m.gsr_gerriscoprod_codigo = '04'
                  and m.gsr_movimento_codliberacao like '%BLQ%'
                  and trim(m.car_carreteiro_cpfcodigo) = trim(x.cpf);
                  if VS_CONTADOR > 0 then
                     VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000013#';
                  end if;  

                 
            END IF;             
          END IF;   
        END IF;
      
        IF (VS_CONJUNTO <> 'A003827') AND (TRUNC(SYSDATE) = '30/07/2011') THEN
              
           
        -------- VERIFICA MOPE
          if f_valida(X.MOPE,'D') = 'S' then 
               if (to_date(X.MOPE,'dd/mm/yyyy') - sysdate ) <= 0 then 
                   VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000012#';
               elsif (to_date(X.MOPE,'dd/mm/yyyy') - sysdate  ) < 30 then
                   VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000031#';
               end if;    
          else
                VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000012#';
          end if;
      END IF;
        ------- N?O EXITE INTEGRAC?O PARA O MOTORISTA ------------      
        IF (X.INTEGRACAO IS NULL) THEN
           VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000010#';
        END IF;
      
        -------- EXAME MEDICO VENCIDO OU ESTA PARA VENCER ------------ 
        IF (TRUNC(SYSDATE - X.EXMEDICO) > 365 OR X.EXMEDICO IS NULL) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000033#'; -- VENCIDO
        else
          IF (TRUNC(SYSDATE - X.EXMEDICO) > 355 OR X.EXMEDICO IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000034#'; -- A VENCER
          END IF;
        end if;
      
        -------- CNH VENCIDO OU ESTA PARA VENCER Agregado ------------
        IF (TRUNC(SYSDATE - X.CNH) > 28 OR X.CNH IS NULL) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000008#';
        END IF;
      
        -------- ANO DE FABRICACAO ACIMA DE 10 ANOS
        ---         IF ((SUBSTR(SYSDATE,7,10)- X.ANOFAB) > 10) THEN
        --               VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000007#';
        --         END IF; 
      
        -------- REGISTRO CNH INVALIDO
        if (replace(X.REGISTRO, substr(x.REGISTRO, 1, 1), '') = '') then
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000006#';
        end if;
      
        -------- VERIFICA SE EXISTE CONJUNTO
        IF (FN_RETCONJUNTO(vPlaca) IS NULL) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000005';
        END IF;
      
      END LOOP;
    
      /*
      
      FOR X 
           IN(SELECT POR_EVENTUALMSG_CODIGO CODIGO_BLQ
                FROM T_POR_EVENTUALMSG 
               WHERE POR_EVENTUALMSG_PLACA = vPlaca
                 AND POR_EVENTUALMSG_BLOQUEIA = 'N')
           LOOP
           
           VS_CODIGOBLOQEVENTUAL := X.CODIGO_BLQ;
           
            if x.CODIGO_BLQ IS NOT NULL THEN
               VS_ERRO_AUX := VS_ERRO_AUX || VS_CODIGOBLOQEVENTUAL || '#';
            end if;       
        END LOOP;
        */
    END IF;
  
    v_achou :=  false; 
    IF (vTIPO = 'D') or (vTIPO = 'C') THEN
      for x in (SELECT SUBSTR(DECODE(A.CAR_VEICULO_CARRETA_PLACA,
                                     NULL,
                                     'TT',
                                     'TC') ||
                              SUBSTR(A.CAR_VEICULO_PLACA, 4, 4),
                              1,
                              7) CONJUNTO,
                       ' ' CAVALO,
                       A.CAR_VEICULO_CERTIFICADO_CODIGO CERTPROP,
                       A.CAR_VEICULO_MARCA MARCAMOD,
                       A.CAR_VEICULO_ANOFABRIC ANOFAB,
                       A.CAR_VEICULO_CARRETA_PLACA CARRETA,
                       G.CAR_CARRETEIRO_CNHCODIGO REGISTRO,
                       G.CAR_CARRETEIRO_CNHVECTO CNH,
                       G.CAR_CARRETEIRO_MOP MOPE,
                       G.CAR_CARRETEIRO_EXMEDICO EXMEDICO,
                       G.CAR_CARRETEIRO_INTEGRACAO INTEGRACAO,
                       A.CAR_VEICULO_CONTRATO CONTRATO,
                       H.CAR_PROPRIETARIO_RNTRC RNTRC,
                       H.CAR_PROPRIETARIO_RAZAOSOCIAL PROPRIETARIO,
                       H.CAR_PROPRIETARIO_CGCCPFCODIGO CPFCGC,
                       G.CAR_CARRETEIRO_NOME MOTORISTA,
                       G.CAR_CARRETEIRO_CPFCODIGO CPF,
                       A.CAR_VEICULO_PLACA placa,
                       ' ' FCARRETA,
                       G.CAR_CARRETEIRO_INPS_CODIGO INSS,
                       H.CAR_PROPRIETARIO_INPS_CODIGO INSSPROP,
                       G.CAR_CARRETEIRO_DATANASC DATANASC,
                       G.CAR_CARRETEIRO_CIDADENASC CIDADENASC,
                       G.GLB_ESTADONASC_CODIGO UFNASC,
                       G.CAR_CARRETEIRO_RGCODIGO RG,
                       G.CAR_CARRETEIRO_RGCIDADE RGCIDADE,
                       G.GLB_ESTADORG_CODIGO UFRG,
                       G.CAR_CARRETEIRO_FILIACAO_MAE MAE,
                       TRIM(fn_get_bloqueio(vPlaca)) BLQ_EVENTUAL,
                       h.car_proprietario_ie,
                       h.car_proprietario_cgccpfcodigo CPFPROP
                  FROM T_CAR_VEICULO      A,
                       T_CAR_CARRETEIRO   G,
                       T_CAR_PROPRIETARIO H
                 WHERE A.CAR_VEICULO_PLACA <> 'SLT0001'
                   AND A.CAR_VEICULO_SAQUE =
                       (SELECT MAX(Z.CAR_VEICULO_SAQUE)
                          FROM T_CAR_VEICULO Z
                         where A.car_veiculo_placa = Z.CAR_VEICULO_PLACA(+))
                   AND G.car_carreteiro_saque =
                       (SELECT MAX(car_carreteiro_saque)
                          FROM T_CAR_CARRETEIRO Y
                         where G.CAR_CARRETEIRO_CPFCODIGO =
                               Y.CAR_CARRETEIRO_CPFCODIGO(+))
                   AND A.CAR_VEICULO_PLACA = G.CAR_VEICULO_PLACA(+)
                   AND A.CAR_VEICULO_SAQUE = G.CAR_VEICULO_SAQUE(+)
                   AND A.CAR_PROPRIETARIO_CGCCPFCODIGO =
                       H.CAR_PROPRIETARIO_CGCCPFCODIGO
                   and A.CAR_VEICULO_PLACA = vPlaca
                   AND 0 =
                       (SELECT COUNT(*)
                          FROM T_FRT_VEICULO D
                         WHERE D.FRT_VEICULO_DATAVENDA IS NULL
                           AND D.GLB_ROTA_CODIGO = '010'
                           AND SUBSTR(D.FRT_VEICULO_CODIGO, 1, 2) = 'A0'
                           AND D.FRT_VEICULO_PLACA = A.CAR_VEICULO_PLACA)
                          
                           /*AND G.CAR_CARRETEIRO_DTCADASTRO =(SELECT MAX(CA.CAR_CARRETEIRO_DTCADASTRO)
                                                     FROM T_CAR_CARRETEIRO CA 
                                                     WHERE CA.CAR_VEICULO_PLACA =vPlaca )  */  ) LOOP
      
        VS_CPFMOTORISTA := TRIM(x.cpf);
        VS_CONTADOR     := VS_CONTADOR + 1;
        VS_MOTORISTA    := X.MOTORISTA;
--        IF vTIPO = 'D' Then
--           VS_CONJUNTO     := X.CONJUNTO;
--        Else
           VS_CONJUNTO     := X.PLACA;
--        End If;   
        VS_PlacaCARRETA := X.CARRETA;
        v_achou := True;
      
        if (vTIPO = 'D')  then
          -------- N?O POSSUI CONTRATO ------------      
          IF (X.CONTRATO IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000017#';
          END IF;
        
          -------- VERIFICA MOPE
          if f_valida(X.MOPE,'D') = 'S' then 
               if (to_date(X.MOPE,'dd/mm/yyyy') - sysdate ) <= 0 then 
                   VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000012#';
               elsif (to_date(X.MOPE,'dd/mm/yyyy') - sysdate  ) < 30 then
                   VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000031#';
               end if;    
          else
                VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000012#';
          end if;
        
          ------- N?O EXITE INTEGRAC?O PARA O MOTORISTA ------------      
          IF (X.INTEGRACAO IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000010#';
          END IF;
        
          -------- EXAME MEDICO VENCIDO OU ESTA PARA VENCER ------------      
          IF (TRUNC(SYSDATE - X.EXMEDICO) > 365 OR X.EXMEDICO IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000033#';
          else
            IF (TRUNC(SYSDATE - X.EXMEDICO) > 355 OR X.EXMEDICO IS NULL) THEN
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000034#';
            END IF;
          end if;

       END IF;



        
          if (x.BLQ_EVENTUAL IS NOT NULL) AND
             (TRIM(VS_PROGRAM) = 'valefrete.exe') THEN
            VS_ERRO_AUX := VS_ERRO_AUX || VS_CODIGOBLOQEVENTUAL;
          end if;
        
          /* 
          
          -------- VERIFICA CERTIFICADO DE PROP            
          IF X.CERTPROP IS NULL THEN
                VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000015#';
          END IF;
          
          */
        
          -------- VERIFICA INSS MOTORISTA
          IF X.INSS IS NULL THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000016#';
          END IF;
        -------- VERIFICA INSS PROPRIETARIO
        IF (X.INSSPROP IS NULL) and (length(trim(x.CPFCGC)) < 13) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000037#';
        END IF;
        
          VS_CODIGOBLOQEVENTUAL := X.BLQ_EVENTUAL;
        -------- VERIFICA INSCRICAO ESTADUAL DO PROPRIETARIO
        IF LENGTH(TRIM(X.CPFCGC)) > 11 THEN
           IF X.car_proprietario_ie IS NULL THEN
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000036#';
           END IF;           
        END IF; 

          -------- VERIFICA RNTRC            
        IF (X.RNTRC IS NULL) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000030#';
        ELSE
          -- TROCAR O TIPO PARA NIVEL 1 NO FINAL DE DEZEMBRO/2009
          -- SIRLANO
          IF f_enumerico(TRIM(X.RNTRC)) = 'N' THEN
             VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000030#';
          ELSE
            IF (LENGTH(TRIM(X.RNTRC)) <> 8) THEN --OR TO_NUMBER(SUBSTR(X.RNTRC,5,4)) <= 1999  THEN
               VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000030#';
            ELSE
              
                select count(*)
                  into VS_CONTADOR
                from t_gsr_movimento m
                where m.gsr_gerrisco_codigo = '02'
                  and m.gsr_gerriscoprod_codigo = '04'
                  and m.gsr_movimento_codliberacao like '%BLQ%'
                  and trim(m.car_carreteiro_cpfcodigo) = trim(x.cpfprop);
                  if VS_CONTADOR > 0 then
                     VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000030#';
                  end if;  
            
               
            END IF;             
          END IF;   
        END IF;
        
        
          -------- CNH VENCIDO OU ESTA PARA VENCER Carreteiro------------
          IF (TRUNC(SYSDATE - X.CNH) > 28 OR X.CNH IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000008#';
          END IF;
        
          -------- ANO DE FABRICACAO ACIMA DE 10 ANOS
          --         IF ((SUBSTR(SYSDATE,7,10)- X.ANOFAB) > 10) THEN
          --               VS_ERRO_AUX:=VS_ERRO_AUX||'ADM0000007#';
          --         END IF; 
        
          -------- REGISTRO CNH INVALIDO
          if (replace(X.REGISTRO, SUBSTR(x.REGISTRO, 1, 1), '') = '') then
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000006#';
          end if;
      
      end loop;
      IF NOT v_achou THEN
         -- SAIDA DA CONSISTENCIA DE DEDICADO E CARRETEIRO.
         -- SE FOR AGREGADO LIBERA MUDANDO A VARIAVEL PARA TRUE
         -- VERIFICA SE ELE NÃO É AGRAGADO  
         SELECT COUNT(*) 
           INTO VS_CONTADOR
         FROM T_FRT_VEICULO D
         WHERE D.FRT_VEICULO_DATAVENDA IS NULL
           AND D.GLB_ROTA_CODIGO = '010'
           AND SUBSTR(D.FRT_VEICULO_CODIGO, 1, 2) = 'A0'
           AND D.FRT_VEICULO_PLACA = vPlaca;
         IF VS_CONTADOR > 0 THEN
            v_achou := TRUE;
         END IF;
      END IF;      

      IF ( not v_achou ) and (vPlaca <> 'SLT0001' ) THEN
        VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000099#';
      END IF;  
      
      /*
         FOR X 
              IN(SELECT POR_EVENTUALMSG_CODIGO CODIGO_BLQ
                   FROM T_POR_EVENTUALMSG 
                  WHERE POR_EVENTUALMSG_PLACA = vPlaca
                    AND POR_EVENTUALMSG_BLOQUEIA = 'N')
              LOOP
              
              VS_CODIGOBLOQEVENTUAL := X.CODIGO_BLQ;
              
               if x.CODIGO_BLQ IS NOT NULL THEN
                  VS_ERRO_AUX := VS_ERRO_AUX || VS_CODIGOBLOQEVENTUAL || '#';
               end if;       
           END LOOP;
      */
    
      VS_CONTAANTENA := 0;
      IF (vTIPO = 'F' OR vTIPO = 'A' OR vTIPO = 'D') THEN
      
        ----- ******************     CHECA ANTENA   ****************************************  
        FOR X IN (select *
                    from t_atr_terminal a
                   where a.atr_terminal_status = 'S'
                     AND a.ATR_TERMINAL_ATIVO = 'S'
                     and a.atr_terminal_mct =
                         (select b.atr_terminal_mct
                            from t_atr_terminal b
                           where b.atr_terminal_status = 'S'
                             AND b.ATR_TERMINAL_ATIVO = 'S'
                             AND b.ATR_TERMINAL_PLACA = vPlaca
                             AND ROWNUM  = 1)) LOOP
        
          vs_contaantena := vs_contaantena + 1;
          --- VERIFICA TIPO DE ANTENA  ---------------------------      
          IF vTIPO = 'F' THEN
            IF (X.ATR_TERMINAL_TIPO <> 'F') THEN
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000002#';
            END IF;
          end if;
        
          IF vTIPO = 'A' THEN
            IF (X.ATR_TERMINAL_TIPO <> 'A') THEN
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000002#';
            END IF;
          END IF;
        
          IF vTIPO = 'D' THEN
            IF (X.ATR_TERMINAL_TIPO <> 'D') THEN
              VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000002#';
            END IF;
          END IF;
        
          IF (X.ATR_TPTERMINAL_CODIGO IS NULL) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000004#';
          END IF;
          --- FIM - VERIFICA TIPO DE ANTENA -----------------------
        END LOOP;
      
        -- VERIFICA A QUANTIDADE DE ANTENA INSTALADA
        IF (VS_CONTAANTENA <> 1) THEN
          IF (VS_CONTAANTENA = 0) THEN
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000001#';
          ELSE
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000003#';
          END IF;
        END IF;
      END IF;
      ----- ******************   FIM  CHECA ANTENA   ****************************************  

      IF (vTIPO = 'D' or vTIPO = 'A') then

        SELECT NVL(SUM(CAR_CONTACORRENTE_VALOR), 0) TOTAL
          INTO VS_TOTAL
          FROM T_CAR_CONTACORRENTE
         WHERE CAR_VEICULO_PLACA = vPlaca
--           AND CAR_CONTACORRENTE_TPLANCAMENTO = 'D'
           AND CAR_CONTACORRENTE_SALDO > 0
           AND CAR_CONTACORRENTE_DTFECHA IS NULL
           AND TRUNC(CAR_CONTACORRENTE_DTVENC) <= TRUNC(SYSDATE);
        IF (VS_TOTAL > 0) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000021#';
        END IF;
      
      END IF;
    
      -- VERIFICA O TELE-RISCO
      if (vTIPO = 'F' or vTIPO = 'D' or vTIPO = 'A') then
      
        SELECT NVL(MAX(B.GSR_MOVIMENTO_DTVALIDADE), '01/01/1901')
          INTO VS_DTRISCO
          FROM T_GSR_MOVIMENTO B, T_GSR_GERRISCOPROD A
         WHERE B.GSR_GERRISCOPROD_CODIGO = B.GSR_GERRISCOPROD_CODIGO
           AND A.GSR_GERRISCO_CODIGO = B.GSR_GERRISCO_CODIGO
           AND A.GSR_GERRISCOPROD_TIPO = 'P'
           AND B.GSR_MOVIMENTO_CPFCODIGO = VS_CPFMOTORISTA;
      
        IF (TRUNC(VS_DTRISCO) < TRUNC(SYSDATE)) THEN
          VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000014#';
        END IF;
      
      end if;
    
    end if;
  
    -- VERIFICA SE TEM ALGUMA OS ABERTA    (ALTERADO POR DANIEL - 17/12/2009 -  BLOQUEIO NO SISTEMA NOVO )
    -- INCLUSO A CONDIÇÃO PARA VERIFICAR SOMENTE SE FOR FROTA - 11/01/2010 -KARINA
--    IF (vTIPO = 'F') THEN
    -- validando Frota e Agregado 
    -- 06/09/2011
    -- conceito NOVO da manutenção
    -- 13/12/2011
    -- foram criados mais dois status de finalização para Os do tipo CheckList
    -- V de Aprovado e I de Reprovado
    -- Nao devera bloquear caso esteja os status acima
    SELECT COUNT(*)
      INTO VS_MANUABERTA
    FROM MNTADM.T_MNT_OSM OS
    WHERE trim(OS.MNT_EQUIPAMENTO_CODIGO) IN (SELECT trim(CE.FRT_VEICULO_CODIGO)
                                              FROM T_FRT_CONTENG CE,
                                                   T_FRT_VEICULO V,
                                                   T_FRT_MARMODVEIC MM,
                                                   T_FRT_TPVEICULO TV
                                              WHERE CE.FRT_CONJVEICULO_CODIGO = VS_CONJUNTO
                                                AND CE.FRT_VEICULO_CODIGO = V.FRT_VEICULO_CODIGO
                                                AND V.FRT_MARMODVEIC_CODIGO = MM.FRT_MARMODVEIC_CODIGO
                                                AND MM.FRT_TPVEICULO_CODIGO = TV.FRT_TPVEICULO_CODIGO
                                                AND TV.FRT_TPVEICULO_TRACAO = 'S')
      AND OS.MNT_OSM_STATUS <> 'F'
      and os.mnt_osm_status <> 'V'
      and os.mnt_osm_status <> 'I';
      
    -- liberado somente hoje porque a manutenção esqueceu de liberar      

    if VS_CONJUNTO = 'A004537'  and trunc(sysdate) = '13/07/2013' then
       VS_MANUABERTA := 0;
    End if; 
                                            

   -- IF VS_MANUABERTA <> 0 THEN
        -- conceito antigo da manutenção
      /*  SELECT COUNT(*)
          INTO VS_MANUABERTA
          FROM T_FRT_ENTSAIDAFROTA OS
         WHERE OS.FRT_CONJVEICULO_CODIGO = VS_CONJUNTO
           AND os.frt_entsaidafrota_dtinicial > SYSDATE - 180
           AND OS.FRT_ENTSAIDAFROTA_DTFINAL IS NULL;*/
    --END IF;           
    --If ( VS_CONJUNTO = 'A003981')  And ( trunc(Sysdate) < '20/07/2012' ) Then
    -- Alterado 
    if (vs_program='comdigconh')or (vs_program='projeto_digitacaoconhecimento.exe') then
        VS_MANUABERTA := 0;
    End If;    

    --IF VS_MANUABERTA > 0 THEN
      --VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000043#';
    --END IF;

    SELECT COUNT(*)
      INTO VS_MANUABERTA
    FROM MNTADM.T_MNT_OSM OS
    WHERE trim(OS.MNT_EQUIPAMENTO_CODIGO) IN (SELECT trim(CE.FRT_VEICULO_CODIGO)
                                              FROM T_FRT_CONTENG CE,
                                                   T_FRT_VEICULO V,
                                                   T_FRT_MARMODVEIC MM,
                                                   T_FRT_TPVEICULO TV
                                              WHERE CE.FRT_CONJVEICULO_CODIGO = VS_CONJUNTO
                                                AND CE.FRT_VEICULO_CODIGO = V.FRT_VEICULO_CODIGO
                                                AND V.FRT_MARMODVEIC_CODIGO = MM.FRT_MARMODVEIC_CODIGO
                                                AND MM.FRT_TPVEICULO_CODIGO = TV.FRT_TPVEICULO_CODIGO
                                                AND TV.FRT_TPVEICULO_TRACAO = 'N')
      AND OS.MNT_OSM_STATUS <> 'F'
      and os.mnt_osm_status <> 'V'
      and os.mnt_osm_status <> 'I';
    --Não é mais considerada a manutenção devida a implantação do GLOBUS a pedido do CHAVES 05/04/2016
      VS_MANUABERTA := 0;
    IF VS_MANUABERTA > 0 THEN
      VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000044#';
    END IF;




--  END IF;
     select 
         count(*) into vs_recibo
     from 
         mntadm.t_mnt_movimento mo,
         mntadm.t_mnt_osm os
     where
         mo.mnt_osm_codigo=os.mnt_osm_codigo
         and mo.mnt_movimento_status='A'
         and mo.mnt_servico_codigo='1000000025'
         and  trim(OS.MNT_EQUIPAMENTO_CODIGO) IN (SELECT trim(CE.FRT_VEICULO_CODIGO)
                                              FROM T_FRT_CONTENG CE
                                              WHERE CE.FRT_CONJVEICULO_CODIGO = vs_conjunto
                                              AND CE.FRT_CONJVEICULO_CODIGO LIKE'A00%');
    if vs_recibo<>0 then
      VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000041#';
    END IF;                                                
     -- faz esta validadcao se for FROTA
    IF (vTIPO = 'F' OR vTIPO = 'P') THEN
        If Tdvadm.Pkg_Glb_Common.ChamadaIntenoTDV = 'S' Then
            select count(*)
              into VS_CONTADOR
              from t_acc_acontas ac
            where ac.acc_acontas_fechou IS NOT NULL
              and ac.frt_motorista_codigo =  vs_codigomotorista
              --and nvl(trim(ac.acc_acontas_assinou),'') = '';
              and nvl(ac.acc_acontas_assinou,'01/01/1900') = '01/01/1900';
            if VS_CONTADOR > 0 then
               VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000040#';
            end if;        
        end if;                 
     end if;    
   
  
   if ( (vPlaca = 'JZC4821') AND (TRUNC(SYSDATE) < '24/12/2009') ) or
      ( (vPlaca = 'KXU3569') and (trunc(sysdate) = '07/06/2012') ) 
      --OR(vPlaca = 'OCW4909')
     THEN
       VS_ERRO_AUX := '';
   END IF;    

   v_UsaPesqCons := null;



   If  nvl(vTIPO,'NULO') in ('F','A') Then 
       v_UsaPesqCons := 'P';
   Else
       -- 18/12/2020
       -- Sirlano
       -- Caso a placa Veiculo estaja cadastro na Tabela de Dedicado, sera pesquisado se existe uma Pesquisa Valida e não uma Consulta.
       select count(*) 
          into vAuxiliar
       from tdvadm.t_car_dedicado d
       where upper(d.car_veiculo_placa) = upper(vPlaca)
--         and d.car_carreteiro_cpfcodigo = lpad(VS_CPFMOTORISTA,20)
         and nvl(d.car_dedicado_ativo,'S') = 'S'
         and trunc(d.car_dedicado_validade) >= trunc(sysdate);
       If vAuxiliar = 0 Then
          v_UsaPesqCons := 'C';
       Else
          v_UsaPesqCons := 'P';
       End If;
   End If;    
   
   
   vValeFrete := null;
   if TRIM(VS_PROGRAM) = 'valefrete.exe' Then
     Begin
       Select max(vf.con_conhecimento_codigo || vf.con_conhecimento_serie || vf.glb_rota_codigo || vf.con_valefrete_saque)
          into vValeFrete
       From tdvadm.t_con_valefrete vf
       where vf.con_valefrete_datacadastro >= sysdate -1
         and vf.con_valefrete_placa = vPlaca
         and vf.con_valefrete_carreteiro = lpad(VS_CPFMOTORISTA,20);
     exception
       When OTHERS Then
          vValeFrete := 'ERRO';
       End;
   End If;

    select count(*)
      into VS_CONTADOR
    from tdvadm.t_gsr_movimento m,
         tdvadm.t_gsr_gerriscoprod p,
         tdvadm.v_gsr_gerriscoproddet d
    where m.gsr_gerrisco_codigo = p.gsr_gerrisco_codigo
      and m.gsr_gerriscoprod_codigo = p.gsr_gerriscoprod_codigo
      and p.gsr_gerrisco_codigo = d.gsr_gerrisco_codigo
      and p.gsr_gerriscoprod_codigo = d.gsr_gerriscoprod_codigo
      and p.gsr_gerriscoprod_tipo = v_UsaPesqCons
      and trunc(m.gsr_movimento_dtconsulta) <= trunc(sysdate)
      and trunc(nvl(m.gsr_movimento_dtvalidade,to_date('01/01/1900','dd/mm/yyyy'))) > trunc(sysdate)
      and instr(m.gsr_movimento_codliberacao,'BLQ') = 0 
      and length(trim(m.gsr_movimento_codliberacao)) > 5
      and upper(trim(m.car_veiculo_placa)) = upper(trim(VS_PLACA))
--      and trim(m.gsr_movimento_cpfcodigo) = nvl(VS_CPFMOTORISTA,trim(VS_CPFMOTORISTA);
;
      insert into tdvadm.t_glb_sql values (VS_CONTADOR||';'||vTIPO||';'||v_UsaPesqCons || ';' ||VS_PLACA||';'||VS_CPFMOTORISTA||';'||vs_osuser||';',sysdate,'SP_VALIDA_VEICULO','SP_VALIDA_VEICULO');
--      VS_CONTADOR := 1;
/*      If ( VS_CPFMOTORISTA is null ) or ( TRIM(lower(VS_PROGRAM)) = 'projetovalefrete.exe' ) Then
--               If instr(dbms_utility.format_call_stack,'SP_GET_IDOPERACAOROTA') = 0 Then
            wservice.pkg_glb_email.SP_ENVIAEMAIL('BLOQUEIO PESQUISA <> C',
                                                 'Placa ' || vPlaca || chr(10) ||
                                                 'Motorista ' || VS_CPFMOTORISTA || chr(10) ||
                                                 'Tipo  ' || nvl(vTIPO,'NULO')  || chr(10) ||
                                                 'Erro  ' || VS_ERRO  || chr(10) ||
                                                 'Tamanho ' || to_char(length(dbms_utility.format_call_stack)) || chr(10) ||
                                                 'IP ' || vs_ip || chr(10) ||
                                                 'Hora ' || vs_hora || chr(10) ||
                                                 'Programa ' || VS_PROGRAM || chr(10) ||
                                                 'Vale Frete ' || vValeFrete || chr(10) ||
                                                 'Terminal ' || vs_terminal || chr(10) ||
                                                 'call_stack ' || chr(10) || 
                                                 '************************************************' || chr(10) ||
                                                 dbms_utility.format_call_stack || chr(10) || 
                                                 '************************************************' || chr(10) ||
                                                 'error_backtrace ' || chr(10) || 
                                                 '************************************************' || chr(10) ||
                                                 dbms_utility.format_error_backtrace || chr(10) ||
                                                 '************************************************' || chr(10),
                                                 'aut-e@dellavolpe.com.br',
                                                 'sirlano.drumond@gmail.com');
--               End If;                
      End If;
*/
      if ( VS_CONTADOR = 0 ) and ( VS_CPFMOTORISTA is not null) then
         If v_UsaPesqCons = 'P' Then
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000045#';
         Else
            VS_ERRO_AUX := VS_ERRO_AUX || 'ADM0000046#';
         End If;  
     end if;  



   --Raise_application_error(-20001,LENGTH(TRIM(VS_ERRO_AUX)));

   VS_ERRO := VS_ERRO_AUX;
   
  Exception
    When Others Then
      Raise_application_error(-20001,'Ponteiro [' || to_char(vPonteiro) || '] Programa [' || VS_PROGRAM || '] Placa [' || VS_PLACA || '] TpMot [' || VS_TIPO || '] Tipo Pesq [' || v_UsaPesqCons || '] CPF [' || VS_CPFMOTORISTA || '] Valida VF variavel ' ||  tdvadm.pkg_con_valefrete.vProcValidaValeFrete || ' ERRO - ' || sqlerrm || ' - STACKTRACE= ' || dbms_utility.format_error_backtrace);
      VS_ERRO := '';
  End;    
  
--  end if;

END SP_VALIDA_VEICULO;

 
/
