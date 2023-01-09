CREATE OR REPLACE PROCEDURE SP_VEICDISP_ADDSOLVEIC(P_CODVEIC IN TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                                                   P_SEQVEIC IN TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                                                   P_CODSOL  IN TDVADM.T_FCF_SOLVEIC.FCF_SOLVEIC_COD%TYPE,
                                                   P_USUARIO IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                                   P_ROTA    IN TDVADM.T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE  DEFAULT '000') IS
                                                   --Dia 20/12/2012, criei um paramentro novo, "P_Rota", estou deixando valor default
                                                   --para garantir que a Mesa continue funcionando até que todas as filiais esteja com 
                                                   --a versão atualizada.


                                                   
  v_contador INTEGER;
  v_SQL      varchar2(3000);
  type tpCursor is REF CURSOR; 
  c_Cursor tpCursor;
  
  v_uf     tdvadm.t_glb_localidade.glb_estado_codigo%type;
  v_cidade tdvadm.t_glb_localidade.glb_localidade_descricao%type;

  vLocalidadeAnt              tdvadm.t_fcf_solveicdest.glb_localidade_codigo%type;
  v_FCF_SOLVEICDEST_COD       tdvadm.t_fcf_solveicdest.fcf_solveicdest_cod%type;
  cMsg                        varchar(4000);
  cTexto                      tdvadm.t_con_loggeracao.con_loggeracao_obsgeracao%Type;
  v_FCF_SOLVEICDEST_ORDEM     tdvadm.t_fcf_solveicdest.FCF_SOLVEICDEST_ORDEM%type;
  v_GLB_LOCALIDADE_CODIGO     tdvadm.t_fcf_solveicdest.GLB_LOCALIDADE_CODIGO%type;
  v_GLB_LOCALIDADE_CODIGOIBGE tdvadm.t_fcf_solveicdest.GLB_LOCALIDADE_CODIGOIBGE%type;
  v_FCF_SOLVEIC_COD           tdvadm.t_fcf_solveicdest.FCF_SOLVEIC_COD%type;
  V_FCF_ROWID                 TDVADM.T_FCF_SOLVEIC.fcf_fretecar_rowid%type;
  V_FCF_QTDECOLETAS           TDVADM.T_FCF_SOLVEIC.fcf_solveic_qtdecoletas%type;
  V_FCF_KMCOLETAS             TDVADM.T_FCF_SOLVEIC.fcf_solveic_kmcoletas%type;
  V_FCF_ACRESCIMO             TDVADM.T_FCF_SOLVEIC.fcf_solveic_acrescimo%type;
  V_FCF_PEDAGIO               TDVADM.T_FCF_SOLVEIC.FCF_SOLVEIC_PEDAGIO%type;
  V_FCF_PEDNOFRETE            TDVADM.T_FCF_SOLVEIC.FCF_SOLVEIC_PEDNOFRETE%type;
  V_FCF_TPFRETE               TDVADM.T_FCF_SOLVEIC.fcf_solveic_tpfrete%type;
  V_FCF_VALORFRETE            TDVADM.T_FCF_SOLVEIC.fcf_solveic_valorfrete%type;
  V_FCF_desinencia            TDVADM.T_FCF_SOLVEIC.fcf_solveic_desinencia%type;
  V_FCF_VALOREXCECAO          TDVADM.T_FCF_SOLVEIC.FCF_SOLVEIC_VALOREXCECAO%Type;
  V_FCF_QTDEENTREGAS          TDVADM.T_FCF_SOLVEIC.fcf_solveic_qtdeentregas%type;
  V_FCF_DESCONTO              TDVADM.T_FCF_SOLVEIC.fcf_solveic_desconto%type;
  V_FCF_TPDESCONTO            TDVADM.T_FCF_SOLVEIC.fcf_solveic_tpdesconto%type;
  V_FCF_OBSVF                 TDVADM.T_FCF_SOLVEIC.fcf_solveic_obsvalefrete%type;
  V_FCF_OBSACRES              TDVADM.T_FCF_SOLVEIC.fcf_solveic_obsacrescimo%type;
  vVeicSolCod                 tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%type;
  vVeicSolDesc                tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_descricao%type;
  vVeicCarCodFicha            tdvadm.t_car_tpveiculo.car_tpveiculo_codigo%type;
  vVeicSolDescFicha           tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_descricao%type;
  vVeicCarCod                 tdvadm.t_car_tpveiculo.car_tpveiculo_codigo%type;
  vVeicCarDesc                tdvadm.t_car_tpveiculo.car_tpveiculo_descricao%type;
  vPlaca                      tdvadm.t_fcf_veiculodisp.car_veiculo_placa%type;
  --Variavel utilizada para carregar um paramentro.
  vParams  glbadm.pkg_glb_auxiliar.tParametros;
  --variável utilizada para recuperar o Status do ID de operação
  vId     tdvadm.t_con_freteoper.con_freteoper_id%type;
  vRotaID tdvadm.t_con_freteoper.con_freteoper_rota%type; 
  vCODSOL TDVADM.T_FCF_SOLVEIC.FCF_SOLVEIC_COD%TYPE;
  tpFretecarMemo tdvadm.t_fcf_fretecarmemo%rowtype;
  vAcao             varchar2(15);
  vStatus           char(1);
  vMessage          varchar2(1000);
BEGIN

  /******************************************************************************** 
  * ROTINA           : SP_VEICDISP_ADDSOLVEIC                                     *
  * PROGRAMA         : Mesa de contratacão                                        *
  * ANALISTA         : Porpeta                                                    *
  * DESENVOLVEDOR    : Porpeta                                                    *
  * DATA DE CRIACAO  : 16/10/2009                                                 *
  * BANCO            : ORACLE-TDP                                                 *
  * EXECUTADO POR    : prj_veiculodisp.exe                                        *
  * FUNCINALIDADE    : Integra a solicitacão de carga feita com um veiculo real,  *
  *                    contratando o mesmo para aquela entrega                    *
  * PARAM. OBRIGAT.  : Todos                                                      *
  *********************************************************************************
  begi
   /*********************************/
  /*** Faz as Devidas validações ****/
  /*********************************/
  Begin
    
  begin
    -- Roto a pocedure para trazer um paramentro
    glbadm.pkg_glb_auxiliar.sp_Espec_Params( P_USUARIO, 'veicdisp', P_ROTA, 'UTILIZA_IDOPER', vParams  );
  exception
    --caso ocorra algum erro durante o processo de busca da lista de paramentro, caso ocorra algum erro, lanço raise de erro
    when others then
      cMsg := 'Erro ao buscar paramentros de permissões';
      Raise_application_error(-20001,cMsg);
  end; 
  
/*  If P_USUARIO = 'vsaraiva' Then
     return;
  End If;*/ 
 
  if nvl(P_CODSOL,-9) = -9 then 
     vAcao := 'Descontratar';
     select sv.fcf_solveic_cod
       into vCODSOL
     from t_fcf_solveic sv
     where sv.fcf_veiculodisp_codigo = P_CODVEIC
       and sv.fcf_veiculodisp_sequencia =  P_SEQVEIC ;
  Else
    vAcao := 'Contratar'; 
    vCODSOL := P_CODSOL;     
  End If;
  
   Begin
   tdvadm.pkg_fcf_veiculodisp.sp_set_fretememo(vCODSOL,
                                               P_CODVEIC,
                                               P_SEQVEIC,
                                               vAcao,
                                               vStatus,
                                               vMessage);
   exception
     When OTHERS Then
--       Raise_application_error(-20007,'Erro MEMO ' || vCODSOL || '-' || P_CODVEIC || '-' || P_SEQVEIC || '-' || sqlerrm);
       vStatus := vStatus;
     End; 
  If vStatus <> 'N' Then
      cMsg := 'APos MEMO ' || vMessage;
      Raise_application_error(-20001,cMsg);
  End If;
  --caso o usuario passado seja obrigado a utilizar um ID
  --if Trim(vParams.TEXTO) = 'S' then
    --pego o codigo e a rota do ID, já que não são passados por paramentros.
    begin
      select
       distinct
        freteoper.con_freteoper_id,
        freteoper.con_freteoper_rota
      into 
        vId,
        vRotaID  
      from 
        t_con_freteoper  freteOper
      where
       1 = ( Select count(*) 
             from t_fcf_veiculodisp veic
             where 0=0
               and veic.fcf_veiculodisp_codigo = P_CODVEIC
               and veic.fcf_veiculodisp_sequencia = P_SEQVEIC
               and veic.con_freteoper_id = freteOper.Con_Freteoper_Id
               and veic.glb_rota_codigo = freteoper.con_freteoper_rota
            );   
    exception 
      when others then
        cMsg := 'ID DE VALIDAÇÃO NÃO VALIDADO' || CHR(13) || CHR(13) ||
                'Não foi possível verificar a validade do ID.' ||chr(13)||chr(13) ||
                P_CODVEIC ||'-'||P_SEQVEIC || ' -erro : ' || sqlerrm;
        Raise_application_error(-20001,cMsg);
                                      
        
        
      end;        
             
    --executo a função responsável por retornar o Status do ID, passando como paramentro o numero e rota do ID de Operação
    if ( Trim(pkg_cfe_frete.FN_GET_IDVALIDO(vid, vRotaID)) <> 'OK' ) and ( P_CODSOL <> -9 )  then
      cMsg := 'ID DE VALIDAÇÃO NÃO VALIDADO' || CHR(13) || CHR(13) ||
              'Veiculo não pode ser Vinculado a uma solicitação neste momento'|| chr(13) ||
              'Id de Operação: '|| vid || 'da rota: ' || vRotaID  ||chr(13)||chr(13);
      Raise_application_error(-20001,cMsg);
    end if;


  If  P_CODSOL <> -9 Then
   /* VERIFICA SE NÃO EXISTE A MESMA PLACA SEM OCORRENCIA E VALE DE FRETE */
    open c_cursor for 
      Select  TO_CHAR(S.FCF_VEICULODISP_DATA,'DD/MM/YYYY HH24:MI') || LPAD(S.ARM_ARMAZEM_CODIGO,3) || S.USU_USUARIO_CADASTRO,
              tv.fcf_tpveiculo_codigo,
              tv.fcf_tpveiculo_codigo tipoVeicFicha,
              tv.car_tpveiculo_descricao descricaoveicficha,
              S.Car_Veiculo_Placa
      From T_FCF_VEICULODISP S,
           t_car_veiculo v,
           t_car_tpveiculo tv
      Where S.FCF_VEICULODISP_CODIGO = P_CODVEIC 
        And S.FCF_VEICULODISP_SEQUENCIA = P_SEQVEIC
  --
  --    Where S.CAR_VEICULO_PLACA = (Select S1.CAR_VEICULO_PLACA
  --                                 From T_FCF_VEICULODISP S1
  --                                Where S1.FCF_VEICULODISP_CODIGO = P_CODVEIC 
  --                                   And S1.FCF_VEICULODISP_SEQUENCIA = P_SEQVEIC)
        and s.car_veiculo_placa = v.car_veiculo_placa
        and s.car_veiculo_saque = v.car_veiculo_saque                             
        and v.car_tpveiculo_codigo = tv.car_tpveiculo_codigo (+)
        And S.Fcf_Ocorrencia_Codigo Is Null
        And S.Fcf_Veiculodisp_Flagvalefrete Is Null
  --      and s.fcf_veiculodisp_data >= sysdate -3
      union
        select TO_CHAR(S.FCF_VEICULODISP_DATA,'DD/MM/YYYY HH24:MI') || LPAD(S.ARM_ARMAZEM_CODIGO,3) || S.USU_USUARIO_CADASTRO,
               rpad(tdvadm.pkg_frtcar_veiculo.FN_RETFCFTPVEICULO(s.frt_conjveiculo_codigo),3) fcf_tpveiculo_codigo,
               rpad(tdvadm.pkg_frtcar_veiculo.FN_RETFCFTPVEICULO(s.frt_conjveiculo_codigo),3) tipoVeicFicha,
               (select tp.fcf_tpveiculo_descricao
                from tdvadm.t_fcf_tpveiculo tp
                where tp.fcf_tpveiculo_codigo = rpad(tdvadm.pkg_frtcar_veiculo.FN_RETFCFTPVEICULO(s.frt_conjveiculo_codigo),3)) descricaoveicficha,
               v.frt_veiculo_placa
        From tdvadm.T_FCF_VEICULODISP S,
             tdvadm.t_frt_conteng ce,
             tdvadm.t_frt_veiculo v,
             tdvadm.t_frt_marmodveic mm,
             tdvadm.t_frt_tpveiculo tpv
        Where S.FCF_VEICULODISP_CODIGO = P_CODVEIC 
          And S.FCF_VEICULODISP_SEQUENCIA = P_SEQVEIC
          and s.frt_conjveiculo_codigo = ce.frt_conjveiculo_codigo
          and ce.frt_veiculo_codigo = v.frt_veiculo_codigo
          and v.frt_marmodveic_codigo = mm.frt_marmodveic_codigo
          and mm.frt_tpveiculo_codigo = tpv.frt_tpveiculo_codigo
          and tpv.frt_tpveiculo_tracao = 'S'      
         Order By 1 DESC;

    
    cMsg := CHR(10) ||
            '   PLACA DUPLICADA NA MESA' || CHR(10) ||
            '  DATA     HORA  ARM USUARIO   ' || CHR(10);
  --        '10/12/2011 13:33  06 jsantosccc
    vPlaca := null;
    loop
      fetch C_CURSOR
        into cTexto,vVeicCarCod,vVeicCarCodFicha,vVeicSolDescFicha,vPlaca ;
      exit when C_CURSOR%notfound;
        cMsg := cMsg || cTexto || chr(10);
    End Loop;
    cMsg := cMsg || CHR(10);
    
  --if ( P_USUARIO = 'jsantos' ) Then
  --  if c_Cursor%Rowcount > 1 Then
  --    Raise_application_error(-20001,cMsg);
  --  end if;

    if nvl(vVeicCarCod,'XX') <> 'XX' Then
       select tv.fcf_tpveiculo_descricao
         into vVeicCarDesc
        from t_fcf_tpveiculo tv
       where tv.fcf_tpveiculo_codigo = vVeicCarCod; 
    End If;



    /*Verifica se ja não foi vinculado um veiculo para essa solicitação*/
    begin
      select count(*)
        INTO V_CONTADOR
        FROM T_FCF_SOLVEIC S
       WHERE S.FCF_SOLVEIC_COD = vCODSOL
         AND S.FCF_VEICULODISP_CODIGO <> P_CODVEIC;
    exception
      when no_data_found then
        v_contador := 0;
    end;
    if v_contador > 0 then
      cMsg := chr(13) ||
              'Ja foi contratado um veiculo para essa solicitac?o!';
      Raise_application_error(-20001,cMsg);
    end if;

  /*  \*Verifica se ja tem frete vinculado*\
    begin
      select count(*)
        INTO V_CONTADOR
        FROM T_FCF_SOLVEIC S
       WHERE S.FCF_SOLVEIC_COD = vCODSOL
         AND S.FCF_SOLVEIC_VALORFRETE = 0;
    exception
      when no_data_found then
        v_contador := 0;
    end;
    if v_contador > 0 then
      Raise_application_error(-20001,chr(13) || 'Solicitacão não tem Frete Vinculado!');
    end if;

  */


    /*Verifica se o veiculo ja não esta vinculado a um carregamento*/
    begin
      select count(*)
        into v_contador
        from t_arm_carregamento ca
       where ca.fcf_veiculodisp_codigo = P_CODVEIC
         and ca.fcf_veiculodisp_sequencia = P_SEQVEIC;
    exception
      when no_data_found then
        v_contador := 0;
    end;
    if v_contador > 0 then
      cMsg := chr(13) || 'Esteve veiculo ja esta vinculado a um caregamento!';
      Raise_application_error(-20001,cMsg);
    end if;
    
    /*Verifica se a solicitação ja não foi cancelada*/
    begin
      select count(*)
        into v_contador
        from t_fcf_solveic s
       where s.fcf_solveic_cod = vCODSOL
         and s.usu_usuario_cancel is not null;
    exception
      when no_data_found then
        v_contador := 0;
    end;
    if v_contador > 0 then
      cMsg := chr(13) || ' Esta solicitac?o esta cancelada n?o pode ser vinculada no veiculo!';
      Raise_application_error(-20001,cMsg);
    end if;
    
    -- verifica se o veiculo solicitado bate com o Contratado
    
    if nvl(vPlaca,'XXX') <> 'XXX' Then
      begin 
            select tv.fcf_tpveiculo_codigo,
                   tv.fcf_tpveiculo_descricao
              into vVeicSolCod,
                   vVeicSolDesc
            from t_fcf_solveic sv,
                 t_fcf_tpveiculo tv
            where 0 = 0
              and sv.fcf_solveic_cod = vCODSOL
              and sv.fcf_tpveiculo_codigo = tv.fcf_tpveiculo_codigo;
       
       exception
      --caso ocorra algum erro durante o processo de busca da lista de paramentro, caso ocorra algum erro, lanço raise de erro
      when others then
        cMsg := 'Erro ao buscar Veiculo disponivel. vCODSOL : '|| vCODSOL ||sqlerrm;
        Raise_application_error(-20001,cMsg);
    end; 
              
    
    -- sirlano 30/09/2021    
    -- Sera validado se o Veiculo da Solicitacao e Igual ao Veiculo da Placa, pesquisando na ficha carreteiro
    -- vVeicSolCod Tipo da Solicitacao
    --   vVeicCarCodFicha Veiculo da Ficha
    If      ( vVeicSolCod <>  vVeicCarCodFicha ) and 
       -- Solicitou uma carreta SIMPLES e aceita uma CAREETE Ate 27 TON
       -- Email autorizado por Gilberto Jose e  enviado por Dantas
       -- 05/10/2021 
       not  ( vVeicSolCod = '1  ' and vVeicCarCodFicha = '12  ' ) Then
       cMsg := '*********************************************************' || chr(10) ||
               'Voce Solicitou o Veiculo    ' || vVeicSolCod || '- ' || trim(vVeicSolDesc) || chr(10) || 
               'Tentou Vincular o Veiculo ' || vVeicCarCodFicha || '- ' || trim(vVeicSolDescFicha) || chr(10) ||
               '*********************************************************' || chr(10);
       Raise_application_error(-20001,cMsg);
    End If;     
          
  /*        if trim(nvl(vVeicCarCod,'XX')) <> trim(nvl(vVeicSolCod,'YY')) Then
             cMsg := chr(13) ||
                     '***********************************************' || chr(13) ||
                     '                 ISTO NÃO É ERRO               ' || chr(13) ||  
                     'Codigo da Solicitacao ' || vCODSOL || chr(13) ||
                     'Codigo Veiculo Disponivel ' || P_CODVEIC || chr(13) ||          
                     'Voce Solicitou um Veiculo ' || vVeicSolCod || '-' || vVeicSolDesc || chr(13) ||
                     'Esta Tentando contratando um Veiculo ' || vVeicCarCod || '-' || nvl(vVeicCarDesc,'SEM CLASSIFICAÇÃO, vide Ficha do Veiculo') || chr(13) ||
                     'Diferente da Solicitacao, VINCULAÇÃO NÃO AUTORIZADA' || chr(13) ||
                     '***********************************************' || chr(13);
             Raise_application_error(-20001,cMsg);
          End If;   */
    End If;        


    /*****************************************************************************/
    /*** Apos passar pelos validadores ele vincula a solicitação com o veiculo ***/
    /*****************************************************************************/

  /* pega os valores de fretes contratados */
  Begin

    select sol.fcf_fretecar_rowid,
           sol.fcf_solveic_qtdecoletas,
           sol.fcf_solveic_kmcoletas,
           sol.fcf_solveic_acrescimo,
           sol.fcf_solveic_tpfrete,
           sol.fcf_solveic_valorfrete,
           sol.fcf_solveic_desinencia ,
           sol.fcf_solveic_valorexcecao,
           sol.fcf_solveic_qtdeentregas,
           sol.fcf_solveic_desconto,
           sol.fcf_solveic_tpdesconto,
           sol.fcf_solveic_obsvalefrete,
           sol.fcf_solveic_obsacrescimo,
           sol.fcf_solveic_pedagio,
           sol.fcf_solveic_pednofrete
      into V_FCF_ROWID        ,
           V_FCF_QTDECOLETAS  ,
           V_FCF_KMCOLETAS    ,
           V_FCF_ACRESCIMO    ,
           V_FCF_TPFRETE      ,
           V_FCF_VALORFRETE   ,
           V_FCF_desinencia   ,
           V_FCF_VALOREXCECAO ,
           V_FCF_QTDEENTREGAS ,
           V_FCF_DESCONTO     ,
           V_FCF_TPDESCONTO   ,
           V_FCF_OBSVF        ,
           V_FCF_OBSACRES     ,
           V_FCF_PEDAGIO      ,
           V_FCF_PEDNOFRETE   
    from tdvadm.t_fcf_solveic sol
    where sol.fcf_solveic_cod = vCODSOL;
    
    
    exception
      --caso ocorra algum erro durante o processo de busca da lista de paramentro, caso ocorra algum erro, lanço raise de erro
      when others then
        cMsg := 'Erro ao buscar Veiculo disponivel. vCODSOL : '|| vCODSOL ||sqlerrm ;
        Raise_application_error(-20001,cMsg);
    end; 
    
   
    

     update tdvadm.t_fcf_veiculodisp vd
       set vd.fcf_fretecar_rowid           = V_FCF_ROWID,
           vd.fcf_veiculodisp_qtdecoletas  = V_FCF_QTDECOLETAS,
           vd.fcf_veiculodisp_kmcoletas    = V_FCF_KMCOLETAS,
           vd.fcf_veiculodisp_acrescimo    = V_FCF_ACRESCIMO,
           vd.fcf_veiculodisp_tpfrete      = V_FCF_TPFRETE,
           vd.fcf_veiculodisp_valorfrete   = V_FCF_VALORFRETE,
           --vd.fcf_veiculodisp_desinencia   = V_FCF_desinencia,
           vd.fcf_veiculodisp_valorexcecao = V_FCF_VALOREXCECAO,
           vd.fcf_veiculodisp_qtdeentregas = V_FCF_QTDEENTREGAS,
           vd.fcf_veiculodisp_desconto     = V_FCF_DESCONTO,
           vd.fcf_veiculodisp_tpdesconto   = V_FCF_TPDESCONTO,
           vd.fcf_veiculodisp_obsvalefrete = V_FCF_OBSVF,
           vd.fcf_veiculodisp_obsacrescimo = V_FCF_OBSACRES,
           vd.fcf_veiculodisp_pedagio      = V_FCF_PEDAGIO,
           vd.fcf_veiculodisp_pednofrete   = V_FCF_PEDNOFRETE
     where vd.fcf_veiculodisp_codigo       = P_CODVEIC
       and vd.fcf_veiculodisp_sequencia    = P_SEQVEIC;
     Commit;

    /*Faz o update na tabela de solicitação colocando o codigo do veiculo que esta sendo 
      contratado e data e hora de contratação*/
    update t_fcf_solveic sol
       set sol.fcf_veiculodisp_codigo    = P_CODVEIC,
           sol.fcf_veiculodisp_sequencia = P_SEQVEIC,
           sol.usu_usuario_contr = P_USUARIO,
           sol.fcf_solveic_dtcontr = sysdate
     where sol.fcf_solveic_cod = vCODSOL;


    /*Pega os destino que sera feito definidos na solicitação, e vincula pro veiculo*/
    v_SQL := '';
    v_SQL := v_SQL ||'  Select FCF_SOLVEICDEST_COD,                          ';
    v_SQL := v_SQL ||'         FCF_SOLVEICDEST_ORDEM,                        ';
    v_SQL := v_SQL ||'         GLB_LOCALIDADE_CODIGO,                        ';
    v_SQL := v_SQL ||'         GLB_LOCALIDADE_CODIGOIBGE,                    ';
    v_SQL := v_SQL ||'         FCF_SOLVEIC_COD                               ';
    v_SQL := v_SQL ||'    from t_fcf_solveicdest                             ';
    v_SQL := v_SQL ||'   where fcf_solveic_cod = ''' || trim(vCODSOL) || '''';
    v_SQL := v_SQL ||'   order by GLB_LOCALIDADE_CODIGO ';

    /*Abre o cursor*/
    open c_cursor for v_SQL;

    /*Navega pelo cursor com os destinos da solicitação*/
    vLocalidadeAnt := 'sirlano';
    loop
      fetch c_Cursor
        into v_FCF_SOLVEICDEST_COD, v_FCF_SOLVEICDEST_ORDEM, v_GLB_LOCALIDADE_CODIGO, v_GLB_LOCALIDADE_CODIGOIBGE, v_FCF_SOLVEIC_COD;
      exit when c_Cursor%notfound;
    
      select lo.glb_estado_codigo, lo.glb_localidade_descricao
        into v_uf, v_cidade
        from t_glb_localidade lo
       where lo.glb_localidade_codigo = v_GLB_LOCALIDADE_CODIGO;
    
      if trim(vLocalidadeAnt) <> trim(v_GLB_LOCALIDADE_CODIGO) Then
         vLocalidadeAnt := v_GLB_LOCALIDADE_CODIGO;
          /*Inseri os destino da solicitação na tabela dos destino do veiculo*/
          insert into t_fcf_veiculodispdest
            (FCF_VEICULODISPDEST_COD,
             FCF_VEICULODISP_CODIGO,
             FCF_VEICULODISP_SEQUENCIA,
             GLB_ESTADO_CODIGO,
             GLB_LOCALIDADE_DESCRICAO,
             FCF_VEICULODISPDEST_ORDEM,
             FCF_VEICULODISPDEST_DATA,
             GLB_LOCALIDADE_CODIGO,
             ARM_CARREGAMENTO_CODIGO,
             FCF_VEICULODISPDEST_DTENTREGA,
             FCF_VEICULODISPDEST_SOLICI)
          values
            ((select nvl(max(to_number(h.fcf_veiculodispdest_cod)) + 1, 1)
               from t_fcf_veiculodispdest h),
             P_CODVEIC,
             P_SEQVEIC,
             v_uf,
             v_cidade,
             v_FCF_SOLVEICDEST_ORDEM,
             sysdate,
             v_GLB_LOCALIDADE_CODIGO,
             null,
             null,
             'S');
      Else
         rollback;
         cMsg := chr(10) ||
                '*****************************************************************************' || chr(10) ||
                'DESTINO Duplicado na SOLICITACAO - SOL-' || trim(vCODSOL ) || 'LOC-' || trim(v_GLB_LOCALIDADE_CODIGO) || '-' || trim(v_uf) || '-' || trim(v_cidade) || chr(10) ||
                'Entrar em contato com BRUNO' || chr(10) ||
                'Veiculo     ' || P_CODVEIC || chr(10) ||
                'Sequencia   ' || P_SEQVEIC || chr(10) ||
                'Solicitacao ' || P_CODSOL || chr(10) ||
                'Usuario     ' || P_USUARIO || chr(10) ||
                'Rota        ' || P_ROTA || chr(10) ||
                '*****************************************************************************' || chr(10);
         Raise_application_error(-20001,cMsg);
      End If;
      
    end loop;
  Else

     update tdvadm.t_fcf_veiculodisp vd
       set vd.fcf_fretecar_rowid = Null,
           vd.fcf_veiculodisp_qtdecoletas  = Null,
           vd.fcf_veiculodisp_kmcoletas    = Null,
           vd.fcf_veiculodisp_acrescimo    = Null,
           vd.fcf_veiculodisp_tpfrete      = Null,
           vd.fcf_veiculodisp_valorfrete   = Null,
           vd.fcf_veiculodisp_valorexcecao = Null,
           vd.fcf_veiculodisp_qtdeentregas = Null,
           vd.fcf_veiculodisp_desconto     = Null,
           vd.fcf_veiculodisp_tpdesconto   = Null,
           vd.fcf_veiculodisp_obsvalefrete = Null,
           vd.fcf_veiculodisp_obsacrescimo = Null,
           vd.fcf_veiculodisp_pedagio      = null,
           vd.fcf_veiculodisp_pednofrete   = null
     where vd.fcf_veiculodisp_codigo       = P_CODVEIC
       and vd.fcf_veiculodisp_sequencia    = P_SEQVEIC;

    update t_fcf_solveic sol
       set sol.fcf_veiculodisp_codigo    = Null,
           sol.fcf_veiculodisp_sequencia = Null,
           sol.usu_usuario_contr = Null,
           sol.fcf_solveic_dtcontr = Null
     where sol.fcf_veiculodisp_codigo    = P_CODVEIC
       And sol.fcf_veiculodisp_sequencia = P_SEQVEIC;

      Delete t_fcf_veiculodispdest vdd
      where vdd.fcf_veiculodisp_codigo    = P_CODVEIC
        And vdd.fcf_veiculodisp_sequencia = P_SEQVEIC;

    
  End If;


  Exception when others then
     If cMsg is not null Then
        Raise_application_error(-20009, chr(10) || 'ERR.: ' || chr(10) || cMsg || chr(10) || chr(10));
     Else
        Raise_application_error(-20009, 'Erro.: '||dbms_utility.format_error_backtrace||'-'||vCODSOL);
     end If;
  End;

Commit;
  
END;

 
/
