CREATE OR REPLACE PROCEDURE SP_MESA_ADDVEICNOCARREG(P_COD_VEIC         IN TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                                                           P_SEQ_VEIC         IN TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                                                           P_COD_CARREGAMENTO IN TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,
                                                           P_COD_USUARIO      IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE) IS

  /*ARMAZENA O CODIGO DO VEICULO VIRTUAL QUE ATUALMENTE SE ENCONTRA NO VEICULO*/
  V_COD_VEIC_OLDVIRTUAL TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE;
  V_SEQ_VEIC_OLDVIRTUAL TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE;

  /*VERIFICA SE FOI IMPRESSO ALGUM CONHECIMENTO SEM PLACA PARA OBRIGAR GERAR MANIFESTO*/
  V_IS_MANIFESTO BOOLEAN := FALSE;

  /*VARIAVEL CONTADORA*/
  V_CONTADOR INTEGER;

  /*CURSOR COM TODOS OS CONHECIMENTOS DO CARREGAMENTO*/
  CURSOR C_CONHECIMENTOS IS
    SELECT *
      FROM T_CON_CONHECIMENTO CO
     WHERE CO.ARM_CARREGAMENTO_CODIGO IN
           (SELECT CA.ARM_CARREGAMENTO_CODIGO
              FROM T_ARM_CARREGAMENTO CA
             WHERE CA.FCF_VEICULODISP_CODIGO = P_COD_VEIC
               AND CA.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC)
       
       -- klayton em 14/01/2005
       -- Desabilitei essa Clausula pois ele não estava atualizando as informações na t_con_viagem
       --And co.con_conhecimento_serie = 'XXX'
       ;        

  /*VARIAVEIS COM OS DADOS DOS MOTORISTAS*/
  V_PROPRIETARIO  VARCHAR2(100);
  V_MARCA         VARCHAR2(100);
  V_PLACA         VARCHAR2(100);
  V_LOCAL         VARCHAR2(100);
  V_UF_VEICULO    VARCHAR2(100);
  V_NOMEMOTORISTA VARCHAR2(100);
  V_RG            VARCHAR2(100);
  V_CPF           VARCHAR2(100);
  V_UF_MOTORISTA  VARCHAR2(100);
  V_CNH           VARCHAR2(100);
  V_TPMOTORISTA   VARCHAR2(100);
  V_PLACA_SAQUE   VARCHAR2(100);
  V_CONTAVEICCARREG  NUMBER;
  V_CARRETEIRO_SAQUE T_FCF_VEICULODISP.CAR_CARRETEIRO_SAQUE%Type;
  vPlacaVeicAtual    tdvadm.t_fcf_veiculodisp.car_veiculo_placa%type;
  vSaqueVeicAtual    tdvadm.t_fcf_veiculodisp.car_veiculo_saque%type;
  vFlagVeiculoAtual  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_flagvirtual%type;
  VeicOutroArmazem   number;
  vCodVeicVirtual tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
  vxmlin varchar2(1000);
  vxmlout varchar2(30000);
  vpstatus char;
  vpmessage varchar2(30000);
BEGIN

  /***************************************************************************************** 
  * ROTINA           : SP_MESA_ADDVEICNOCARREG                                             *
  * PROGRAMA         : MESA DE CONTRATAC?O                                                 *
  * ANALISTA         : PORPETA                                                             *
  * DESENVOLVEDOR    : PORPETA                                                             *
  * DATA DE CRIACAO  : 19/10/2009                                                          *
  * BANCO            : ORACLE-TDP                                                          *
  * EXECUTADO POR    : PRJ_VEICULODISP.EXE                                                 *
  * FUNCINALIDADE    : RESPONSAVEL EM ATRIBUIR O CARREGAMENTO COM OS CONHECIMANTOS GERADOS *
  *                    A UM VEICULO.                                                       *
  * ATUALIZA         :                                                                     *
  * PARAM. OBRIGAT.  : TODOS                                                               *                           *
  ******************************************************************************************/


  /*
    PEGANDO O SAQUE DO MOTORISTA QUE ESTA NA MESA
  */
   Begin
     Select vd.car_carreteiro_saque
       Into V_CARRETEIRO_SAQUE
     From t_fcf_veiculodisp vd
     Where vd.fcf_veiculodisp_codigo = P_COD_VEIC
       And vd.fcf_veiculodisp_sequencia = P_SEQ_VEIC;
   Exception
     When NO_DATA_FOUND Then
       V_CARRETEIRO_SAQUE := Null;
   End;  


  /*BUSCA O CODIGO DO VEICULO VIRTUAL QUE ESTA ATUALMENTE NO CARREGAMENTO 
  PARA SER EXCLUIDO E ALTERADO PELO CODIGO DO VEICULO REAL*/
  BEGIN
    SELECT CA.FCF_VEICULODISP_CODIGO, CA.FCF_VEICULODISP_SEQUENCIA
      INTO V_COD_VEIC_OLDVIRTUAL, V_SEQ_VEIC_OLDVIRTUAL
      FROM T_ARM_CARREGAMENTO CA
     WHERE CA.ARM_CARREGAMENTO_CODIGO = P_COD_CARREGAMENTO;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_COD_VEIC_OLDVIRTUAL := NULL;
      V_SEQ_VEIC_OLDVIRTUAL := NULL;
  END;
  
      --RAFAEL AITI 19/10/2018
      --Verifico se o veículo que está no carregamento da filial onde está a embalagem é uma contratação do mesmo armazém ou armazém incorreto.
     select count (*)
      into  VeicOutroArmazem
      from  tdvadm.t_arm_carregamento ca,
            tdvadm.t_fcf_veiculodisp veic
      where ca.fcf_veiculodisp_codigo    = veic.fcf_veiculodisp_codigo 
      and   ca.fcf_veiculodisp_sequencia = veic.fcf_veiculodisp_sequencia
      and   ca.arm_carregamento_codigo   = P_COD_CARREGAMENTO
      and   ca.arm_armazem_codigo        = veic.arm_armazem_codigo;
      
      vCodVeicVirtual:= tdvadm.pkg_fifo.fn_CriaVeicVirtual(P_COD_CARREGAMENTO);
      
  if (VeicOutroArmazem = 0) then
    
      UPDATE TDVADM.T_ARM_CARREGAMENTO                                          
         SET FCF_VEICULODISP_CODIGO = vCodVeicVirtual,
             FCF_VEICULODISP_SEQUENCIA = '0'  --Veiculo virtual sempre estará na sequencia zero '0'                          
       WHERE ARM_CARREGAMENTO_CODIGO = P_COD_CARREGAMENTO;
    
    COMMIT;
    
  end if;
  
    
  /***************************************************************************************/ 
  /**   Klayton em 03/05/2018 bloqueio para impedir a troca do veiculo real por outro   **/
  /***************************************************************************************/
  select nvl(trim(vec.car_veiculo_placa),vec.frt_conjveiculo_codigo),
         trim(vec.car_veiculo_saque),
         nvl(vec.fcf_veiculodisp_flagvirtual,'S')
    into vPlacaVeicAtual,
         vSaqueVeicAtual,  
         vFlagVeiculoAtual
    from tdvadm.t_arm_carregamento ca,
         tdvadm.t_fcf_veiculodisp vec
   where ca.arm_carregamento_codigo   = P_COD_CARREGAMENTO
     and ca.fcf_veiculodisp_codigo    = vec.fcf_veiculodisp_codigo
     and ca.fcf_veiculodisp_sequencia = vec.fcf_veiculodisp_sequencia; 	
 
  if ((vPlacaVeicAtual is not null) or (vSaqueVeicAtual is not null) or (vFlagVeiculoAtual != 'S')) then
    
    raise_application_error(-20001, 'Erro ao vincular o carregamento.: '||P_COD_CARREGAMENTO||' ao veiculo disponivel real.: '||P_COD_VEIC||', pois essa nota ja possui veiculo real vinculado!');
    
    
  end if;       
  

  /*EXECUTA A PROCEDURE QUE RETORNA TODOS OS DADOS NECESSARIO DO MOTORISTA DE ACORDO COM O CODIGO DO VEICULO*/
  SP_BUSCA_FCFVEICULODISP(P_COD_VEIC,
                          V_PROPRIETARIO,
                          V_MARCA,
                          V_PLACA,
                          V_LOCAL,
                          V_UF_VEICULO,
                          V_NOMEMOTORISTA,
                          V_RG,
                          V_CPF,
                          V_UF_MOTORISTA,
                          V_CNH,
                          V_TPMOTORISTA,
                          V_PLACA_SAQUE);


  vxmlin := '<Parametros>' ||
            '    <Input>' ||
            '        <Manifesto></Manifesto>' ||
            '        <Serie></Serie>' ||
            '        <Rota></Rota>' ||
            '        <Placa>' || trim(V_PLACA) || '</Placa>' ||
            '    </Input>' ||
            '</Parametros>';

--  raise_application_error(-20001, V_PLACA);
  tdvadm.pkg_fifo_manifesto.Sp_Get_StatusAutorizacaoPlaca(pxmlin => vxmlin,
                                                          pxmlout => vxmlout,
                                                          pstatus => vpstatus,
                                                          pmessage => vpmessage);

  If vxmlout <>  '' Then

     vpmessage := '';
     for c_msg in (Select extractvalue(value(field), 'row/Status_Atual_TDV') Status_Atual_TDV,
                          extractvalue(value(field), 'row/Encerramento') Encerramento
                   From Table(xmlsequence( Extract(xmltype.createXml(vxmlout) , '/Parametros/OutPut/Tables/Table[@name="Status"]/RowSet/row'))) field )
     Loop
     
       vpmessage := vpmessage || substr(c_msg.status_atual_tdv,37,15) || chr(10);
     
     End Loop;
     
     If vpmessage <> '' Then
        raise_application_error(-20001, '**********************************' || chr(10) ||
                                        'MANIFESTOS PENDENTES DE FECHAMENTO'|| chr(10) ||
                                        vpmessage || 
                                        '**********************************' || chr(10));
     End If;  
  
  End If;



  /***************************************************************************************/
  
  /*LIMPA O CARREGAMENTO COM O CÓDIGO DO VEÍCULO VIRTUAL*/
  UPDATE T_ARM_CARREGAMENTO CA
     SET CA.FCF_VEICULODISP_CODIGO    = NULL,
         CA.FCF_VEICULODISP_SEQUENCIA = NULL
   WHERE CA.ARM_CARREGAMENTO_CODIGO = P_COD_CARREGAMENTO;

/* VERIFICA SE ESTE VEICULKO DISPONIVEL EXISTE EN OUTRO CARREGAMENTO */
   V_CONTAVEICCARREG := 0;
   SELECT COUNT(*)
      INTO V_CONTAVEICCARREG
   FROM T_ARM_CARREGAMENTO CA
   WHERE CA.FCF_VEICULODISP_CODIGO = V_COD_VEIC_OLDVIRTUAL
     AND CA.FCF_VEICULODISP_SEQUENCIA = V_SEQ_VEIC_OLDVIRTUAL;
        

  /*VERIFICA SE ENCONTROU O CODIGO DE CARREGAMENTO VIRTUAL E DEPOIS DELETA*/
  /* SE NÃO ENCONTROU O MESMO EM OUTRO CARREGAMENTO */
  
  IF ( V_COD_VEIC_OLDVIRTUAL IS NOT NULL) AND 
     ( V_CONTAVEICCARREG = 0 ) THEN
    DELETE FROM T_FCF_VEICULODISPDEST DDD
     WHERE DDD.FCF_VEICULODISP_CODIGO = V_COD_VEIC_OLDVIRTUAL
       AND DDD.FCF_VEICULODISP_SEQUENCIA = V_SEQ_VEIC_OLDVIRTUAL;
    DELETE FROM t_Fcf_Veiculodispseqsenha DDD
     WHERE DDD.FCF_VEICULODISP_CODIGO = V_COD_VEIC_OLDVIRTUAL
       AND DDD.FCF_VEICULODISP_SEQUENCIA = V_SEQ_VEIC_OLDVIRTUAL;

    UPDATE T_FCF_SOLVEIC SV
      SET SV.FCF_VEICULODISP_CODIGO = NULL,
          SV.FCF_VEICULODISP_SEQUENCIA = NULL
    WHERE SV.FCF_VEICULODISP_CODIGO = V_COD_VEIC_OLDVIRTUAL
      AND SV.FCF_VEICULODISP_SEQUENCIA = V_SEQ_VEIC_OLDVIRTUAL;
      
    DELETE FROM T_FCF_VEICULODISP DD
     WHERE DD.FCF_VEICULODISP_CODIGO = V_COD_VEIC_OLDVIRTUAL
       AND DD.FCF_VEICULODISP_SEQUENCIA = V_SEQ_VEIC_OLDVIRTUAL;
  END IF;

  /*REGISTRA NA TABELA DE VEICULO O USUARIO QUE VINCULOU, CODIGO DO CARREGAMENTO E A DATA*/
  UPDATE T_FCF_VEICULODISP
     SET USU_USUARIO_UTILIZOU        = P_COD_USUARIO,
         ARM_CARREGAMENTO_CODIGO     = P_COD_CARREGAMENTO,
         FCF_VEICULODISP_DTUTILIZADO = SYSDATE
   WHERE FCF_VEICULODISP_CODIGO = P_COD_VEIC
     AND FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC;

  /*ATUALIZA NO CARREGAMENTO COLOCANDO O NOVO CODIGO DE VEICULO POREM AGORA O 
  CODIGO DO VEICULO REAL E N?O O VIRTUAL*/
  UPDATE T_ARM_CARREGAMENTO
     SET FCF_VEICULODISP_CODIGO    = P_COD_VEIC,
         FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC
   WHERE ARM_CARREGAMENTO_CODIGO = P_COD_CARREGAMENTO;

  /*DELETA DA TABELA DOS DESTINOS DO VEICULO TUDO QUE A FLAG FOR = 'S'  
  DIZENDO QUE FOI INSERIDA PELA SOLICITAC?O*/
  DELETE FROM T_FCF_VEICULODISPDEST VD
   WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEIC
     AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC
     AND NVL(VD.FCF_VEICULODISPDEST_SOLICI, 'N') = 'S';

  /*EXECUTA A PROCEDURE QUE INSERI OS DESTINOS NO VEICULO*/
  SP_INSERE_DESTINOS_VEIC(P_COD_VEIC, P_SEQ_VEIC, P_COD_CARREGAMENTO);


  /*COLOCA A PLACA NOS CONHECIMENTOS DO CARREGAMENTO*/
  UPDATE T_CON_CONHECIMENTO CO
     SET CON_CONHECIMENTO_PLACA = v_placa
   WHERE CO.ARM_CARREGAMENTO_CODIGO In  ( SELECT C.ARM_CARREGAMENTO_CODIGO
                                          FROM T_ARM_CARREGAMENTO C
                                          WHERE C.FCF_VEICULODISP_CODIGO = P_COD_VEIC
                                          AND C.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC
                                        )
       And co.con_conhecimento_serie = 'XXX';
       

/*VERIFICA SE FOI IMPRESSO ALGUM CONHECIMENTO SEM PLACA PARA OBRIGAR A GERAR UM MANIFESTO*/
  BEGIN
    SELECT 
      Count(*) Into V_CONTADOR
      FROM T_CON_CONHECIMENTO CO
     WHERE CO.ARM_CARREGAMENTO_CODIGO IN
           (SELECT CA.ARM_CARREGAMENTO_CODIGO
              FROM T_ARM_CARREGAMENTO CA
             WHERE CA.FCF_VEICULODISP_CODIGO = P_COD_VEIC
               AND CA.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC)
       And CO.CON_CONHECIMENTO_SERIE <> 'XXX';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_CONTADOR := 0;
  END;
  V_IS_MANIFESTO := (V_CONTADOR > 0);       
                                        

  /*CASO ALGUM CONHECIMENTO TENHA SIDO IMPRESSO SEM PLACA*/
  IF V_IS_MANIFESTO THEN
  
    /*DEIXA TODOS OS CARREGAMENTOS CONTIDO NESTE VEICULO COM FLAG DE MANIFESTO*/
    UPDATE T_ARM_CARREGAMENTO C
       SET C.ARM_CARREGAMENTO_FLAGMANIFESTO = 'S'
     WHERE C.FCF_VEICULODISP_CODIGO = P_COD_VEIC
       AND C.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC;
  
  Begin
    /*COLOCA A PLACA NO MANIFESTO*/
    UPDATE T_CON_MANIFESTO M
       SET M.CON_MANIFESTO_CPFMOTORISTA = Trim(V_CPF),
           M.CON_MANIFESTO_PLACA        = Trim(V_PLACA),
           M.CON_MANIFESTO_PLACASAQUE   = Trim(V_PLACA_SAQUE),
           M.GLB_TPMOTORISTA_CODIGO     = Trim(V_TPMOTORISTA)
     WHERE M.ARM_CARREGAMENTO_CODIGO IN
           (SELECT C.ARM_CARREGAMENTO_CODIGO
              FROM T_ARM_CARREGAMENTO C
             WHERE C.FCF_VEICULODISP_CODIGO = P_COD_VEIC
               AND C.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEIC);
   Exception
     When Others Then
       raise_application_error(-20001, 'Erro ao tentar efetuar vinculação: ' || chr(13) ||
                                       'CPF MOTORISTA : ' || V_CPF || CHR(13)  ||
                                       'PLACA: '          || v_placa || CHR(13) ||
                                       'PLACA SAQUE: '    || V_PLACA_SAQUE || CHR(13) ||
                                       'TIPO MOTORISTA: ' || V_TPMOTORISTA
                                );           
   End;            
  
  End If;
  -- eu matei esse else por que sempre que um carregamento tivesse um
  --  Else 
  
    /*NAVEGA PELOS CONHECIMENTOS DO VEICULO COLOCANDO A PLACA E O RESTANTE DOS DADOS DO MOTORISTA*/
    FOR R_CONHECIMENTO IN C_CONHECIMENTOS Loop
      
      --Caso o Motorista seja um Frota
      If Trim(V_TPMOTORISTA) = 'F' Then
        Update t_con_viagem viag
          Set viag.frt_conjveiculo_codigo = Trim(v_placa),
              viag.frt_motorista_codigo = (select m.frt_motorista_codigo 
                                                   from t_frt_motorista m  
                                                   where Trim(m.frt_motorista_cpf) = trim(V_CPF)
                                                   and m.frt_motorista_comissao = 'S'
                                                   and m.frt_motorista_dtdesligamento is null ),
              viag.car_carreteiro_cpfcodigo = Null,
              viag.car_carreteiro_saque = Null,
              viag.con_viagem_placa = Null,
              viag.con_viagem_placasaque = Null

         WHERE viag.CON_VIAGEM_NUMERO = R_CONHECIMENTO.CON_VIAGEM_NUMERO
         AND viag.GLB_ROTA_CODIGOVIAGEM = R_CONHECIMENTO.GLB_ROTA_CODIGOVIAGEM;
      Else
        --Caso não seja um frota.
        Update t_con_viagem viag
          Set viag.frt_conjveiculo_codigo = Null,
              viag.frt_motorista_codigo = Null,

              viag.car_carreteiro_cpfcodigo = V_CPF,
              viag.car_carreteiro_saque = substr(Trim(V_CARRETEIRO_SAQUE) , 1, 4),
              viag.con_viagem_placa = substr(Trim(v_placa) , 1, 7),
              viag.con_viagem_placasaque = substr(Trim(V_PLACA_SAQUE), 1, 4)

         WHERE viag.CON_VIAGEM_NUMERO = R_CONHECIMENTO.CON_VIAGEM_NUMERO
         AND viag.GLB_ROTA_CODIGOVIAGEM = R_CONHECIMENTO.GLB_ROTA_CODIGOVIAGEM;

        
                
      End If;
        
    
      /*O DECODE NO UPDATE FOI COLCADO DEVIDO ELE ESTAR VERIFICANDO SE E FROTA OU CARRETEIRO*/
      /*
      UPDATE T_CON_VIAGEM VV
         SET VV.FRT_MOTORISTA_CODIGO   = DECODE(Trim(V_TPMOTORISTA),
                                                'F',
                                                  (select m.frt_motorista_codigo 
                                                   from t_frt_motorista m  
                                                   where Trim(m.frt_motorista_cpf) = trim(V_CPF)
                                                   and m.frt_motorista_comissao = 'S'
                                                   and m.frt_motorista_dtdesligamento is null ),
                                                NULL),
                                                
             VV.FRT_CONJVEICULO_CODIGO = DECODE(Trim(V_TPMOTORISTA), 'F',  Trim(v_placa), NULL),                                                

             
             VV.CAR_CARRETEIRO_CPFCODIGO = DECODE(Trim(V_TPMOTORISTA),
                                                  'F',
                                                  NULL,
                                                  V_CPF),
             VV.CAR_CARRETEIRO_SAQUE     = DECODE(Trim(V_TPMOTORISTA),
                                                  'F',
                                                  NULL,
                                                  substr(V_CARRETEIRO_SAQUE , 1, 4)),
             vv.con_viagem_placa         =  DECODE(Trim(V_TPMOTORISTA),
                                                  'F',
                                                  NULL,
                                                  substr(v_placa , 1, 7)),
                                                  
             vv.con_viagem_placasaque    =  DECODE(Trim(V_TPMOTORISTA),
                                                  'F',
                                                  NULL,
                                                  substr(V_PLACA_SAQUE , 1, 4))

                                                  
       WHERE VV.CON_VIAGEM_NUMERO = R_CONHECIMENTO.CON_VIAGEM_NUMERO
         AND VV.GLB_ROTA_CODIGOVIAGEM = R_CONHECIMENTO.GLB_ROTA_CODIGOVIAGEM;
         */
    END LOOP;
  

  --COMMIT;
END;

 
/
