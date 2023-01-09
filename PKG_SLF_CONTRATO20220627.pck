CREATE OR REPLACE PACKAGE PKG_SLF_CONTRATO IS

  /***************************************************************************************************
  * ROTINA           :
  * PROGRAMA         :
  * ANALISTA         :
  * DESENVOLVEDOR    :
  * DATA DE CRIACAO  :
  * BANCO            :
  * EXECUTADO POR    :
  * ALIMENTA         :
  * FUNCINALIDADE    :
  * ATUALIZA         :
  * PARTICULARIDADES :                                           
  * PARAM. OBRIGAT.  :
  *                                                                                                  *
  ****************************************************************************************************/
  -- Constantes

  QualquerContrato CONSTANT char(15) := '999999999999999';
  QualquerGrupo    CONSTANT char(4) := '9999';
  QualquerCliente  CONSTANT char(20) := '99999999999999';

  TYPE T_CURSOR IS REF CURSOR;
  STATUS_NORMAL CONSTANT CHAR(1) := 'N';
  STATUS_ERRO   CONSTANT CHAR(1) := 'E';

  /* Typo utilizado como base para utilizac?o dos Paramentros                                                                 */
  Type TpMODELO is RECORD(
    CAMPO1 char(10),
    CAMPO2 number(6));

  vCNPJRegra     tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vGRUPORegra    tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
  vCONTRATORegra tdvadm.t_slf_contrato.slf_contrato_codigo%type;

  /*
  
  FOR R_CURSORCTE In (select *
                     from t_glb_rota)                              
  Loop
                     
  End Loop;
  
  
  */

  /*
  BEGIN
     BLOCO DE INSTRUCOES
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX  THEN       -- ORA-00001   You attempted to create a duplicate value in a field restricted by a unique index.
    WHEN TIMEOUT_ON_RESOURCE  THEN    -- ORA-00051  A resource timed out, took too long.
    WHEN TRANSACTION_BACKED_OUT  THEN -- ORA-00061  The remote portion of a transaction has rolled back.
    WHEN INVALID_CURSOR  THEN         -- ORA-01001  The cursor does not yet exist. The cursor must be OPENed before any FETCH cursor or CLOSE cursor operation.
    WHEN NOT_LOGGED_ON  THEN          -- ORA-01012  You are not logged on.
    WHEN LOGIN_DENIED  THEN           -- ORA-01017  Invalid username/password.
    WHEN NO_DATA_FOUND  THEN          -- ORA-01403  No data was returned
    WHEN TOO_MANY_ROWS  THEN          -- ORA-01422  You tried to execute a SELECT INTO statement and more than one row was returned.
    WHEN ZERO_DIVIDE  THEN            -- ORA-01476  Divide by zero error.
    WHEN INVALID_NUMBER  THEN         -- ORA-01722  Converting a string to a number was unsuccessful.
    WHEN STORAGE_ERROR  THEN          -- ORA-06500  Out of memory.
    WHEN PROGRAM_ERROR  THEN          -- ORA-06501  
    WHEN VALUE_ERROR  THEN            -- ORA-06502  You tried to perform an operation and there was a error on a conversion, truncation, or invalid constraining of numeric or character data.
    WHEN ROWTYPE_MISMATCH  THEN       -- ORA-06504   
    WHEN CURSOR_ALREADY_OPEN  THEN    -- ORA-06511  The cursor is already open.
    WHEN ACCESS_INTO_NULL  THEN       -- ORA-06530   
    WHEN COLLECTION_IS_NULL  THEN     -- ORA-06531    
    WHEN OTHERS THEN
  END;
  
  */

  FUNCTION FN_VALIDACONTRATO(pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                             pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
                             pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pCNPJSac   in tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,
                             pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                             pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                             pContrato  in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                             pStatus    out char,
                             pMessage   out varchar2) RETURN VARCHAR2;

  FUNCTION FN_VALIDACONTRATO2(pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                              pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
                              pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                              pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                              pCNPJSac   in tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,
                              pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                              pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                              pContrato  in tdvadm.t_slf_contrato.slf_contrato_codigo%type)
    RETURN VARCHAR2;

  FUNCTION FN_RETORNOTPCARGA(pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                             pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
                             pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                             pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type)
    RETURN VARCHAR2;

  PROCEDURE SP_INFORMACLIENTE(pNota    in tdvadm.t_arm_nota.arm_nota_numero%type,
                              pCNPJ    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                              pSerie   in tdvadm.t_arm_nota.arm_nota_serie%type,
                              pArmazem in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                              pUsuario in tdvadm.t_arm_nota.usu_usuario_codigo%type,
                              pOrigem  in char, -- Acao pode Sedr E Etiqueta ou P Pesagem
                              pStatus  out char,
                              pMessage out varchar2);

  PROCEDURE SP_INFORMACLIENTE2(pNota    in tdvadm.t_arm_nota.arm_nota_numero%type,
                               pCNPJ    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pSerie   in tdvadm.t_arm_nota.arm_nota_serie%type,
                               pArmazem in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                               pUsuario in tdvadm.t_arm_nota.usu_usuario_codigo%type,
                               pOrigem  in char); -- Acao pode Sedr E Etiqueta ou P Pesagem

  PROCEDURE SP_SETPARTCONTRATO(pNota    in tdvadm.t_arm_nota.arm_nota_numero%type,
                               pCNPJ    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pSerie   in tdvadm.t_arm_nota.arm_nota_serie%type,
                               pStatus  out char,
                               pMessage out varchar2);

  PROCEDURE SP_SETPARTCONTRATO2(pNota  in tdvadm.t_arm_nota.arm_nota_numero%type,
                                pCNPJ  in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                                pSerie in tdvadm.t_arm_nota.arm_nota_serie%type);

  FUNCTION FN_SLF_CLIENTEREGRACARGA(P_CNPJ     IN T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                    P_CONTRATO IN T_ARM_NOTA.SLF_CONTRATO_CODIGO%TYPE DEFAULT QualquerContrato,
                                    P_GRUPO    IN T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE DEFAULT QualquerGrupo)
    RETURN CHAR;

  Procedure SP_GETREGRANOTA(pNota        in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCNPJ        in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pSerie       in tdvadm.t_arm_nota.arm_nota_serie%type,
                            pSACADO      out tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type,
                            pGrupo       out tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type,
                            pContrato    out tdvadm.t_slf_clientecargas.slf_contrato_codigo%type,
                            pAgrupamento out tdvadm.t_slf_tpagrupa.slf_tpagrupa_codigo%type);

  Procedure SP_GETJANELANOTA(pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJ      in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pSerie     in tdvadm.t_arm_nota.arm_nota_serie%type,
                             pJanelaINI out date,
                             pJanelaFIM out date,
                             pGeraCte   out tdvadm.t_arm_janela.arm_janela_geracte%type);

  Function FN_TEMJANELANOTA(pNota  in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCNPJ  in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pSerie in tdvadm.t_arm_nota.arm_nota_serie%type)
    Return VARCHAR2;

  PROCEDURE SP_SETCRIAJANELA(pNota     in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJ     in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pSerie    in tdvadm.t_arm_nota.arm_nota_serie%type,
                             pSequence in tdvadm.t_arm_nota.arm_nota_sequencia%type,
                             pOrigem   in tdvadm.t_arm_janelacons.arm_janelacons_origem%type,
                             pStatus   out char,
                             pMessage  out varchar2);

function fn_buscadecpesagem(pRota    in  tdvadm.t_arm_nota.glb_rota_codigo%type,
                            pnota    in  tdvadm.t_arm_nota.arm_nota_numero%type,
                            pcnpj    in  tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pserie   in  tdvadm.t_arm_nota.arm_nota_serie%type,
                            pSAP     in  char) 
 return char;   
 
 
FUNCTION FN_VALIDAVALEPEDAGIO(P_CNPJ     IN T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                              P_CONTRATO IN T_ARM_NOTA.SLF_CONTRATO_CODIGO%TYPE DEFAULT QualquerContrato,
                              P_GRUPO    IN T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE DEFAULT QualquerGrupo)
 Return char;                                   
                           

END PKG_SLF_CONTRATO;
/
CREATE OR REPLACE PACKAGE BODY PKG_SLF_CONTRATO AS

  FUNCTION FN_VALIDACONTRATO(pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                             pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
                             pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pCNPJSac   in tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,
                             pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                             pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                             pContrato  in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                             pStatus    out char,
                             pMessage   out varchar2) RETURN VARCHAR2 As
    vAuxiliar number := 0;
    vContrato tdvadm.t_slf_contrato.slf_contrato_codigo%type;
    --      vSacado         tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type;
    vTabSolCod      tdvadm.t_Arm_Nota.arm_nota_tabsolcod%type;
    vTabSolSq       tdvadm.t_Arm_Nota.arm_nota_tabsolsq%type;
    vTabSolTP       tdvadm.t_Arm_Nota.arm_nota_tabsol%type;
    vDtVencContrato tdvadm.t_slf_contrato.slf_contrato_dtfinal%type;
    vDescContrato   tdvadm.t_slf_contrato.slf_contrato_descricao%type;
    --      vVeiculoASN     tdvadm.t_xml_coleta.xml_coleta_tipotransporte%type;
    vVeiculoASN tdvadm.t_arm_coletapart.arm_coletapart_veiculo%type;
    vCNPJPesq   tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
    vGrupoREM   tdvadm.t_glb_cliente.glb_grupoeconomico_codigo%type;
    vGrupoDEST  tdvadm.t_glb_cliente.glb_grupoeconomico_codigo%type;
    PRAGMA AUTONOMOUS_TRANSACTION;
  Begin
    /*
    contrato  regra  VEICULO
    */
  
    /***********************************************************************************************************************/
    pStatus   := 'N';
    pMessage  := '';
    vAuxiliar := 0;
    vContrato := pContrato;
  
    -- Inicio do Processo COM ASN
    for c_msg in (SELECT D.ARM_COLETAPART_TIPOCARGA,
                         D.ARM_COLETAPART_VEICULO,
                         D.ARM_COLETAPART_CODIGO,
                         D.ARM_COLETAPART_REMETENTE,
                         CO.GLB_GRUPOECONOMICO_CODIGO GRUPOREM,
                         CD.GLB_GRUPOECONOMICO_CODIGO GRUPODES
                  --                    FROM T_XML_COLETA D,
                    FROM TDVADM.T_ARM_COLETAPART D,
                         TDVADM.T_ARM_COLETA     CP,
                         --                         TDVADM.t_Xml_Coletaparceiro po,
                         --                         TDVADM.t_xml_coletaparceiro pd,
                         TDVADM.t_glb_cliente co,
                         TDVADM.t_glb_cliente cd
                   WHERE 0 = 0
                     AND D.ARM_COLETA_NCOMPRA = pArmColeta
                     AND D.ARM_COLETA_CICLO = pArmCiclo
                     AND D.ARM_COLETA_NCOMPRA = CP.ARM_COLETA_NCOMPRA
                     AND D.ARM_COLETA_CICLO = CP.ARM_COLETA_CICLO
                        --                      AND D.XML_COLETA_TIPODOC = 'ASN'
                        --                      AND D.XML_COLETA_GRAVADO = 'CVRD' 
                        --                      AND D.ARM_COLETAPART_STATUS in ('OK','AR','1','3')
                        --                      and D.xml_coleta_numero     = po.xml_coleta_numero
                        --                      and D.xml_coleta_tipodoc    = po.xml_coleta_tipodoc
                        --                      and D.xml_coleta_sequencia  = po.xml_coleta_sequencia
                        --                      and po.xml_tipoparceiro_codigo = 'OR'
                        --                      and D.xml_coleta_numero     = pd.xml_coleta_numero
                        --                      and D.xml_coleta_tipodoc    = pd.xml_coleta_tipodoc
                        --                      and D.xml_coleta_sequencia  = pd.xml_coleta_sequencia
                        --                      and pd.xml_tipoparceiro_codigo = 'DS'
                     and CP.GLB_CLIENTE_CGCCPFCODIGOCOLETA =
                         co.glb_cliente_cgccpfcodigo
                     and CP.GLB_CLIENTE_CGCCPFCODIGOENTREG =
                         cd.Glb_Cliente_Cgccpfcodigo
                  
                  --                      AND D.glb_cliente_cgccpfremetente IS NOT NULL
                  ) Loop
    
      Begin
        vVeiculoASN := c_msg.arm_coletapart_veiculo;
        vCNPJPesq   := c_msg.arm_coletapart_remetente;
      
        --            if c_msg.gruporem = c_msg.grupodes and c_msg.gruporem = '0020' Then
        --               vCNPJPesq := '99999999999999';
        --            end If;
      
        select cv.slf_contrato_codigo
          into vContrato
          from tdvadm.t_slf_contratoveic cv
        --            Mudado em 15/07 a pedido do Tiago
        --            where cv.glb_cliente_cgccpfcodigo = rpad(trim(pCNPJRem),20)
         where cv.glb_cliente_cgccpfcodigo = rpad(trim(vCNPJPesq), 20)
           and trim(cv.slf_contratoveic_ibgeo) =
               trim(fn_busca_codigoibge(pORIGEM, 'IBC'))
           and trim(cv.slf_contratoveic_ibged) =
               trim(fn_busca_codigoibge(pDESTINO, 'IBC'))
           and trim(upper(cv.slf_contratoveic_veiculo)) =
               trim(upper(vVeiculoASN))
           and cv.slf_contratoveic_ativo = 'S';
        /*              and cv.slf_contratoveic_vigencia = (select max(cv1.slf_contratoveic_vigencia)
                                                          from t_slf_contratoveic cv1
                                                          where cv1.glb_cliente_cgccpfcodigo = cv.glb_cliente_cgccpfcodigo
                                                            and cv1.slf_contrato_codigo = cv.slf_contrato_codigo
                                                            and cv1.slf_contratoveic_veiculo = cv.slf_contratoveic_veiculo
                                                            and cv1.slf_contratoveic_ibgeo = cv.slf_contratoveic_ibged
                                                            and cv1.slf_contratoveic_ativo = 'S');
        */
        -- Conceito antigo usando a tabela que o Klayton 
        -- Mudando em 02/05/2016
        -- SE NAO DER CERTO VOLTA ESTE E DESABILITAR O SELECT ACIMA
        /*            select ct.slf_contrato_codigo
                      into vContrato
                    from t_xml_clientetransp ct,
                         t_xml_tipotransp tp
                    where ct.xml_tipotransp_id = tp.xml_tipotransp_id
                      and ct.glb_cliente_cgccpfcodigo = trim(vCNPJPesq)
                      and ct.xml_clientetransp_ibgeo = trim(fn_busca_codigoibge(pORIGEM,'IBC'))
                      and ct.xml_clientetransp_ibged = trim(fn_busca_codigoibge(pDESTINO,'IBC'))
                      and trim(upper(tp.xml_tipotransp_cod)) = trim(upper(c_msg.xml_coleta_tipotransporte));
        */
      Exception
        When NO_DATA_FOUND Then
          vContrato := null;
        When TOO_MANY_ROWS Then
          pStatus  := 'E';
          pMessage := pMessage ||
                      'Verifique tabela t_slf_contratoveic para os Contratos C5900307551/C5900307552/C5900347813/C5900347814/C5900039888' ||
                      chr(10);
      end;
      vAuxiliar := vAuxiliar + 1;
    End Loop;
  
    -- Se n?o achou nada nas ASN
    -- Volta o Contrato para o Passado pela FUNCAO
    --      If vContrato is null Then
    --         vAuxiliar := 0;
    --      End If;
  
    if vAuxiliar = 0 Then
      vContrato := pContrato;
    Else
      -- caso o Veiculo seja Cavalo .... tem que esta na tabela de particularidades dos contratos
      -- alterado em 02/05/2016 
    
      if vVeiculoASN in ('BR00000007', --Cavalo 4x2
                         'Cavalo 4x2',
                         'BR00000008', --Cavalo 6x2
                         'Cavalo 6x2',
                         'BR00000009', --Cavalo 6x4
                         'Cavalo 6x4',
                         'BR00000010', --Cavalo 6x6 
                         'Cavalo 6x6',
                         'BR00000011', --Cavalo 8x4
                         'Cavalo 8x4') then
        If vContrato is not null then
          select count(*)
            into vAuxiliar
            from tdvadm.t_glb_clientecontrato cc
           where cc.glb_cliente_cgccpfcodigo = rpad(trim(pCNPJSac), 20)
             and cc.slf_contrato_codigo = vContrato;
          If vAuxiliar = 0 then
            insert into t_glb_clientecontrato
            values
              (pCNPJSac, vContrato, 'S', sysdate, 'sistema');
            commit;
          end If;
        Else
          pStatus  := 'E';
          pMessage := pMessage ||
                      'Verifique tabela clientetrans para os Contratos C5900307551/C5900307552/C5900347813/C5900347814/C5900039888' ||
                      chr(10) || 'Veiculo ASN - ' || vVeiculoASN || chr(10) ||
                      'CNPJ - ' || pCNPJRem || chr(10) || 'ORIGEM - ' ||
                      fn_busca_codigoibge(pORIGEM, 'IBC') || '-' ||
                      fn_busca_codigoibge(pORIGEM, 'IBD') || chr(10) ||
                      'DESTINO - ' || fn_busca_codigoibge(pDESTINO, 'IBC') || '-' ||
                      fn_busca_codigoibge(pDESTINO, 'IBD') || chr(10);
        End If;
      
        return vContrato;
      Else
        -- Procura pelco contrato no Baixo FLUXO
      
        for c_msg in (SELECT cp.fcf_tpcarga_codigo
                        FROM TDVADM.T_ARM_COLETA CP
                       WHERE 0 = 0
                         and cp.slf_contrato_codigo is null
                         AND cp.ARM_COLETA_NCOMPRA = pArmColeta
                         AND cp.ARM_COLETA_CICLO = pArmCiclo
                         and cp.xml_coleta_numero is not null) loop
        
          select count(*)
            into vAuxiliar
            From tdvadm.t_xml_clientelib cl
           where cl.glb_cliente_cgccpfcodigo = rpad(trim(pCNPJRem), 20)
             and cl.xml_clientelib_ativo = 'S'
             and cl.xml_clientelib_flaggf = 'N'
             and cl.xml_clientelib_flagbf = 'S'
             and cl.fcf_tpcarga_codigo = c_msg.fcf_tpcarga_codigo
             and trim(cl.glb_localidade_codigoori) =
                 trim(decode(trim(cl.glb_localidade_codigoori),
                             '99999',
                             '99999',
                             fn_busca_codigoibge1(pORIGEM,
                                                  cl.xml_clientelib_tpcodori)))
             and trim(cl.glb_localidade_codigodes) =
                 trim(decode(trim(cl.glb_localidade_codigodes),
                             '99999',
                             '99999',
                             fn_busca_codigoibge1(pDESTINO,
                                                  cl.xml_clientelib_tpcoddes)))
             and cl.xml_clientelib_dtvigencia =
                 (select max(cl1.xml_clientelib_dtvigencia)
                    from t_xml_clientelib cl1
                   where cl1.glb_cliente_cgccpfcodigo =
                         cl.glb_cliente_cgccpfcodigo
                     and cl1.xml_clientelib_ativo = cl.xml_clientelib_ativo
                     and cl1.xml_clientelib_flagporto =
                         cl.xml_clientelib_flagporto
                     and cl1.xml_clientelib_flaggf =
                         cl.xml_clientelib_flaggf
                     and cl1.xml_clientelib_flagaeroporto =
                         cl.xml_clientelib_flagaeroporto
                     and cl1.glb_localidade_codigoori =
                         cl.glb_localidade_codigoori
                     and cl1.xml_clientelib_tpcodori =
                         cl.xml_clientelib_tpcodori
                     and cl1.glb_localidade_codigodes =
                         cl.glb_localidade_codigodes
                     and cl1.xml_clientelib_tpcoddes =
                         cl.xml_clientelib_tpcoddes
                     and cl1.fcf_tpcarga_codigo = cl.fcf_tpcarga_codigo);
        
          If vAuxiliar <> 0 Then
            return 'C5900011012/2';
          Else
            return pContrato;
          End If;
          return pContrato;
        End Loop;
      end If;
    End If;
  
    Begin
      Select an.arm_nota_tabsolcod,
             an.arm_nota_tabsolsq,
             an.arm_nota_tabsol
        into vTabSolCod, vTabSolSq, vTabSolTP
        From t_arm_nota an
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJRem)
         and an.arm_coleta_ncompra = pArmColeta
         and an.arm_coleta_ciclo = pArmCiclo;
    exception
      When NO_DATA_FOUND Then
        vTabSolCod := null;
        vTabSolSq  := null;
        vTabSolTP  := null;
      When TOO_MANY_ROWS Then
        pStatus  := 'E';
        pMessage := 'Nota ' || pNota || ' CNPJ ' || pCNPJRem ||
                    ' Duplicada, exclua uma delas.';
    End;
  
    If vContrato Is Null OR vTabSolCod Is not Null Then
    
      If nvl(vTabSolTP, 'X') = 'X' Then
        Begin
          select cc.slf_contrato_codigo
            into vContrato
            from t_glb_clientecontrato cc
           where trim(cc.glb_cliente_cgccpfcodigo) = trim(pCNPJSac)
             and cc.glb_clientecontrato_ativo = 'S'
             and cc.glb_clientecontrato_dtcadastro =
                 (select min(cc1.glb_clientecontrato_dtcadastro)
                    from t_glb_clientecontrato cc1
                   where cc1.glb_cliente_cgccpfcodigo =
                         cc.glb_cliente_cgccpfcodigo
                     and cc1.glb_clientecontrato_ativo = 'S');
        exception
          When OTHERS Then
            vContrato := null;
        End;
      ElsIf nvl(vTabSolTP, 'X') = 'T' Then
        Begin
          select sf.slf_tabela_contrato
            into vContrato
            from t_slf_tabela sf
           where sf.slf_tabela_codigo = lpad(trim(vTabSolCod), 8, '0')
             and sf.slf_tabela_saque = lpad(trim(vTabSolSq), 4, '0');
        Exception
          When NO_DATA_FOUND Then
            vContrato := null;
        End;
      ElsIf nvl(vTabSolTP, 'X') = 'S' Then
        Begin
          select sf.slf_solfrete_contrato
            into vContrato
            from t_slf_solfrete sf
           where sf.slf_solfrete_codigo = lpad(trim(vTabSolCod), 8, '0')
             and sf.slf_solfrete_saque = lpad(trim(vTabSolSq), 4, '0');
        exception
          When NO_DATA_FOUND Then
            vContrato := null;
        End;
      End If;
    End If;
  
    If vContrato is not null Then
    
      Begin
        select nvl(c.slf_contrato_dtfinal, trunc(sysdate)),
               c.slf_contrato_descricao
          into vDtVencContrato, vDescContrato
          from t_slf_contrato c
         where c.slf_contrato_codigo = vContrato
           and c.slf_contrato_dtinicio <= trunc(sysdate);
      
        if vDtVencContrato < trunc(sysdate) Then
          pMessage := pMessage || 'CONTRATO ' || vContrato || '-' ||
                      vDescContrato || ' VENCIDO DESDE ' ||
                      TO_CHAR(vDtVencContrato, 'DD/MM/YYYY') || chr(10);
          pStatus  := 'E';
        End If;
      exception
        WHEN NO_DATA_FOUND Then
          pMessage := 'CONTRATO ' || vContrato || '- NAO EXISTE' || chr(10);
          pStatus  := 'E';
      End;
    Else
      pStatus  := 'N';
      pMessage := pMessage ||
                  'Obrigatorio ter um CONTRATO VALIDO Solicitacao - ' ||
                  lpad(trim(vTabSolCod), 8, '0') || '-' ||
                  lpad(trim(vTabSolSq), 4, '0') || chr(10);
    End If;
  
    If vContrato = '999999' Then
      --         pStatus := 'W';
      pMessage := pMessage ||
                  'Entre em Contato com o COMERCIAL para ATUALIZAR O CONTRATO [' ||
                  vContrato || ']. Ele sera travado em breve.' || chr(10);
    End If;
  
    return vContrato;
  
  End FN_VALIDACONTRATO;

  FUNCTION FN_VALIDACONTRATO2(pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                              pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
                              pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                              pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                              pCNPJSac   in tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,
                              pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                              pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                              pContrato  in tdvadm.t_slf_contrato.slf_contrato_codigo%type)
    RETURN VARCHAR2 As
    vStatus  char(1);
    vMessage varchar2(1000);
  Begin
    return FN_VALIDACONTRATO(pArmColeta,
                             pArmCiclo,
                             pNota,
                             pCNPJRem,
                             pCNPJSac,
                             pORIGEM,
                             pDESTINO,
                             pContrato,
                             vStatus,
                             vMessage);
  
  End FN_VALIDACONTRATO2;

  function FN_RETORNOTPCARGA(pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                             pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
                             pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                             pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type)
    Return varchar2 As
    vAuxiliar      number;
    vAuxiliar2     number;
    vTpCarga       tdvadm.t_arm_coleta.arm_coleta_tpcargacalc%Type;
    vTpColeta      tdvadm.t_arm_coleta.arm_coleta_tpcoleta%type;
    vCodTpcarga    tdvadm.t_fcf_tpcarga.fcf_tpcarga_codigo%type;
    vEntCol        tdvadm.t_arm_coleta.arm_coleta_entcoleta%type;
    vFlagQuimico   tdvadm.t_arm_coleta.arm_coleta_flagquimico%type;
    vFracionado    char(1) := 'N';
    vLotacao       char(1) := 'N';
    vColeta        char(1) := 'N';
    vExpresso      char(1) := 'N';
    vQuimico       char(1) := 'N';
    vEPorto        Char(1) := 'N';
    vEAeroPorto    char(1) := 'N';
    vEGFluxo       Char(1) := 'N';
    vEGFluxoL      number := 0;
    vEGFluxoF      number := 0;
    vContratoNovo  char(1) := 'N';
    vGrupo         tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
    vTpCargaNota   char(2);
    vXMLColeta     tdvadm.t_xml_coleta.xml_coleta_numero%type;
    vXMLColetaSeq  t_xml_coleta.xml_coleta_sequencia%type;
    vCNPJRemetente tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
    vCNPJPagador   tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
    vORIGEM        tdvadm.t_glb_localidade.glb_localidade_codigo%type;
    vDESTINO       tdvadm.t_glb_localidade.glb_localidade_codigo%type;
    vContrato      tdvadm.t_arm_nota.slf_contrato_codigo%type;
    vGRPSacado     tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
    vTabSol        tdvadm.t_arm_nota.arm_nota_tabsol%type;
    vTabSolCod     tdvadm.t_arm_nota.arm_nota_tabsolcod%type;
    vTabSolSq      tdvadm.t_arm_nota.arm_nota_tabsolsq%type;
    PRAGMA AUTONOMOUS_TRANSACTION;
  Begin
  
    vFracionado   := 'N';
    vExpresso     := 'N';
    vLotacao      := 'N';
    vQuimico      := 'N';
    vEPorto       := 'N';
    vEAeroPorto   := 'N';
    vEGFluxo      := 'N';
    vColeta       := 'N';
    vAuxiliar     := 0;
    vXMLColeta    := null;
    vContratoNovo := 'N';
  
    /***********************************************************************************************************************/
    -- Inicio do Processo COM ASN
    for c_msg in (SELECT D.arm_coletapart_tipocarga XML_COLETA_TIPOCARGA,
                         D.arm_coletapart_veiculo xml_coleta_tipotransporte,
                         D.arm_coletapart_codigo xml_coleta_numero,
                         1 xml_coleta_sequencia,
                         co.fcf_tpcarga_codigo,
                         decode(nvl(d.slf_contrato_codigo, 'N'),
                                'N',
                                'N',
                                'S') ContratoNovo
                  --                    FROM T_XML_COLETA D
                    FROM tdvadm.t_Arm_Coletapart D, tdvadm.t_arm_coleta co
                   WHERE 0 = 0
                     AND D.ARM_COLETA_NCOMPRA = pArmColeta
                     AND D.ARM_COLETA_CICLO = pArmCiclo
                     AND D.ARM_COLETA_NCOMPRA = co.arm_coleta_ncompra
                     AND D.ARM_COLETA_CICLO = co.arm_coleta_ciclo
                  --                      AND D.XML_COLETA_TIPODOC = 'ASN'
                  --                      AND D.XML_COLETA_GRAVADO = 'CVRD' 
                  --                      AND D.XML_COLETA_STATUS in ('OK','AR')
                  --                      AND D.glb_cliente_cgccpfremetente IS NOT NULL
                  ) Loop
      vContratoNovo := c_msg.ContratoNovo;
      vXMLColeta    := c_msg.xml_coleta_numero;
      vXMLColetaSeq := c_msg.xml_coleta_sequencia;
      -- Coloquei oTipo A para Fracionado so para a Coleta ser classificada
      -- 21/09/2020 Sirlano
      if c_msg.xml_coleta_tipocarga in ('FRACIONADO', 'FRACIONADA', '5','A') Then
        vFracionado := 'S';
      ElsIf c_msg.xml_coleta_tipocarga in ('LOTACAO', '7') Then
        vLotacao := 'S';
      ElsIf c_msg.xml_coleta_tipocarga in ('EXPRESSO', 'EXPRESSA', '4') Then
        vExpresso := 'S';
        If c_msg.fcf_tpcarga_codigo = '12' Then
          vFracionado := 'S';
        Else
          If c_msg.fcf_tpcarga_codigo = '11' Then
            vLotacao := 'S';
          End If;
        End If;
      ElsIf c_msg.xml_coleta_tipocarga in
            ('QUIMICA/PERIGOSA', 'QUIMICO/PERIGOSO', '6') Then
        vQuimico := 'S';
        If c_msg.fcf_tpcarga_codigo = '12' Then
          vFracionado := 'S';
        Else
          If c_msg.fcf_tpcarga_codigo = '11' Then
            vLotacao := 'S';
          End If;
        End If;
      
      End If;
      vAuxiliar := vAuxiliar + 1;
    End Loop;
    -- Se Achou alguma ASN
    if vAuxiliar > 0 Then
    
      Begin
        -- Verifico se e PORTO
        select distinct cl.xml_clientelib_flagporto,
                        cl.xml_clientelib_flagaeroporto
          into vEPorto, vEAeroPorto
          from tdvadm.t_xml_clientelib cl, tdvadm.t_arm_coletapart cp
        --                   T_XML_COLETAPARCEIRO CP
         where cl.xml_clientelib_ativo = 'S'
           and trunc(cl.xml_clientelib_dtvigencia) <= trunc(sysdate)
           AND CP.ARM_COLETA_NCOMPRA = pArmColeta
           AND CP.ARM_COLETA_CICLO = pArmCiclo
           and cp.slf_contrato_codigo is null
              --                AND CP.XML_TIPOPARCEIRO_CODIGO = 'OR'
           and cl.glb_cliente_cgccpfcodigo =
               RPAD(cp.arm_coletapart_remetente, 20)
        --                AND CP.XML_COLETA_TIPODOC = 'ASN'
        ;
      exception
        When NO_DATA_FOUND Then
          vEPorto     := 'N';
          vEAeroPorto := 'N';
        When OTHERS Then
          raise_application_error(-20014,
                                  'Veirificando Porto ' || vXMLColeta || '-' ||
                                  vXMLColetaSeq);
      End;
    
      if (vLotacao = 'N' and (vExpresso = 'S' or vQuimico = 'S') and
         (vContratoNovo = 'N')) Then
      
        if vEPorto = 'N' Then
          -- Verifico se e GRANDE FLUXO
          Begin
            --            pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
            --            pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
            --            pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
            --            pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
            --            pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
            --            pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type            
          
            select sum(decode(cl.fcf_tpcarga_codigo, 11, 1, 0)),
                   sum(decode(cl.fcf_tpcarga_codigo, 12, 0, 1))
              into vEGFluxoL, vEGFluxoF
              From t_xml_clientelib cl
             where cl.glb_cliente_cgccpfcodigo = rpad(trim(pCNPJRem), 20)
               and cl.xml_clientelib_ativo = 'S'
               and cl.xml_clientelib_flaggf = 'S'
                  --                  and cl.fcf_tpcarga_codigo = '12'
               and trim(cl.glb_localidade_codigoori) =
                   trim(decode(trim(cl.glb_localidade_codigoori),
                               '99999',
                               '99999',
                               fn_busca_codigoibge1(pORIGEM,
                                                    cl.xml_clientelib_tpcodori)))
               and trim(cl.glb_localidade_codigodes) =
                   trim(decode(trim(cl.glb_localidade_codigodes),
                               '99999',
                               '99999',
                               fn_busca_codigoibge1(pDESTINO,
                                                    cl.xml_clientelib_tpcoddes)))
               and cl.xml_clientelib_dtvigencia =
                   (select max(cl1.xml_clientelib_dtvigencia)
                      from t_xml_clientelib cl1
                     where cl1.glb_cliente_cgccpfcodigo =
                           cl.glb_cliente_cgccpfcodigo
                       and cl1.xml_clientelib_ativo =
                           cl.xml_clientelib_ativo
                       and cl1.xml_clientelib_flagporto =
                           cl.xml_clientelib_flagporto
                       and cl1.xml_clientelib_flaggf =
                           cl.xml_clientelib_flaggf
                       and cl1.xml_clientelib_flagaeroporto =
                           cl.xml_clientelib_flagaeroporto
                       and cl1.glb_localidade_codigoori =
                           cl.glb_localidade_codigoori
                       and cl1.xml_clientelib_tpcodori =
                           cl.xml_clientelib_tpcodori
                       and cl1.glb_localidade_codigodes =
                           cl.glb_localidade_codigodes
                       and cl1.xml_clientelib_tpcoddes =
                           cl.xml_clientelib_tpcoddes
                       and cl1.fcf_tpcarga_codigo = cl.fcf_tpcarga_codigo);
            --                 vAuxiliar := nvl(vEGFluxoL,0) + nvl(vEGFluxoF,0);
            if vEGFluxoL + vEGFluxoF > 0 Then
              vEGFluxo := 'S';
            End If;
          Exception
            When NO_DATA_FOUND Then
              vEGFluxo := 'N';
            When OTHERS Then
              vEGFluxo := 'N';
          End;
        End If;
      ElsIf vLotacao = 'S' Then
      
        if ((vEPorto = 'N') and (vEAeroPorto = 'N') and
           (vContratoNovo = 'N')) Then
          -- Verifico se e GRANDE FLUXO
          Begin
            --            pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
            --            pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
            --            pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
            --            pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
            --            pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
            --            pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type            
          
            select sum(decode(cl.fcf_tpcarga_codigo, 11, 1, 0)),
                   sum(decode(cl.fcf_tpcarga_codigo, 12, 0, 1))
              into vEGFluxoL, vEGFluxoF
              From t_xml_clientelib cl
             where cl.glb_cliente_cgccpfcodigo = rpad(trim(pCNPJRem), 20)
               and cl.xml_clientelib_ativo = 'S'
               and cl.xml_clientelib_flaggf = 'S'
                  --                  and cl.fcf_tpcarga_codigo = '12'
               and trim(cl.glb_localidade_codigoori) =
                   trim(decode(trim(cl.glb_localidade_codigoori),
                               '99999',
                               '99999',
                               fn_busca_codigoibge1(pORIGEM,
                                                    cl.xml_clientelib_tpcodori)))
               and trim(cl.glb_localidade_codigodes) =
                   trim(decode(trim(cl.glb_localidade_codigodes),
                               '99999',
                               '99999',
                               fn_busca_codigoibge1(pDESTINO,
                                                    cl.xml_clientelib_tpcoddes)))
               and cl.xml_clientelib_dtvigencia =
                   (select max(cl1.xml_clientelib_dtvigencia)
                      from t_xml_clientelib cl1
                     where cl1.glb_cliente_cgccpfcodigo =
                           cl.glb_cliente_cgccpfcodigo
                       and cl1.xml_clientelib_ativo =
                           cl.xml_clientelib_ativo
                       and cl1.xml_clientelib_flagporto =
                           cl.xml_clientelib_flagporto
                       and cl1.xml_clientelib_flaggf =
                           cl.xml_clientelib_flaggf
                       and cl1.xml_clientelib_flagaeroporto =
                           cl.xml_clientelib_flagaeroporto
                       and cl1.glb_localidade_codigoori =
                           cl.glb_localidade_codigoori
                       and cl1.xml_clientelib_tpcodori =
                           cl.xml_clientelib_tpcodori
                       and cl1.glb_localidade_codigodes =
                           cl.glb_localidade_codigodes
                       and cl1.xml_clientelib_tpcoddes =
                           cl.xml_clientelib_tpcoddes
                       and cl1.fcf_tpcarga_codigo = cl.fcf_tpcarga_codigo);
            --                 vAuxiliar := nvl(vEGFluxoL,0) + nvl(vEGFluxoF,0);
            if vEGFluxoL + vEGFluxoF > 0 Then
              vEGFluxo := 'S';
            End If;
          Exception
            When NO_DATA_FOUND Then
              vEGFluxo := 'N';
            When OTHERS Then
              vEGFluxo := 'N';
          End;
          -- Verificar na proxima
          --            Elsif ( vEAeroPorto = 'S' ) Then
        End If;
      
      End If;
      If (vEPorto = 'S') or (vEGFluxo = 'S') and (vAuxiliar = 1) Then
        if vEGFluxoL > 0 Then
          vLotacao := 'S';
        ElsIf vEGFluxoF > 0 Then
          vFracionado := 'S';
        Else
          vLotacao    := 'N';
          vFracionado := 'N';
        End If;
      End If;
    
      If vLotacao = 'S' Then
        vTpCarga := replace(vTpCarga, 'FRACIONADO', 'LOTACAO');
      ElsIf vFracionado = 'S' Then
        vTpCarga := replace(vTpCarga, 'LOTACAO', 'FRACIONADO');
      End If;
    
    End If;
    -- FIM DO PROCESSO COM ASN
    -- Se n?o Achou nenhuma ASN
    --      vAuxiliar := 0;
    if vXMLColeta is null Then
      vFracionado := 'N';
      vExpresso   := 'N';
      vLotacao    := 'N';
      vQuimico    := 'N';
      Begin
        select C.GLB_TPCARGA_CODIGO,
               C.ARM_COLETA_TPCOLETA,
               c.fcf_tpcarga_codigo,
               c.arm_coleta_flagquimico,
               c.arm_coleta_entcoleta
          INTO vTpCarga, vTpColeta, vCodTpcarga, vFlagQuimico, vEntCol
          from tdvadm.t_arm_coleta c
         where c.arm_coleta_ncompra = pArmColeta
           and c.arm_coleta_ciclo = pArmCiclo;
        vAuxiliar := 1;
      Exception
        When NO_DATA_FOUND Then
          vAuxiliar    := 0;
          vTpCarga     := '';
          vTpColeta    := '';
          vCodTpcarga  := '';
          vFlagQuimico := '';
          vEntCol      := '';
      End;
      If vCodTpcarga in ('01', '11', '38') Then
        vLotacao := 'S';
      ElsIf vCodTpcarga in ('02', '12', '10', '31', '32', '37') Then
        vFracionado := 'S';
      ElsIf vCodTpcarga in ('20') Then
        vColeta := 'S';
      Elsif nvl(substr(vTpCarga, 1, 1), 'F') = 'F' Then
        vFracionado := 'S';
      Elsif substr(vTpCarga, 1, 1) = 'L' Then
        vLotacao := 'S';
      Elsif (substr(vTpCarga, 1, 1) = 'E') Then
        vExpresso := 'S';
      End If;
      if vFlagQuimico = 'S' Then
        vQuimico := 'S';
      End If;
      if (vTpColeta = 'E') Then
        vExpresso := 'S';
      End If;
    
    End If;
  
    vTpCarga := null;
  
    /***********************************************************************************************************************/
    -- Montagem do NOME da CARGA
    if vAuxiliar > 0 Then
    
      If vTpCarga is null Then
        Begin
          select an.arm_nota_tabsol,
                 an.arm_nota_tabsolcod,
                 an.arm_nota_tabsolsq
            into vTabSol, vTabSolCod, vTabSolSq
            from t_arm_nota an, t_glb_cliente cl
           where an.arm_nota_numero = pNota
             and an.glb_cliente_cgccpfsacado =
                 trim(cl.glb_cliente_cgccpfcodigo)
             and an.glb_cliente_cgccpfremetente = trim(pCNPJRem)
             and an.arm_coleta_ncompra = pArmColeta
             and an.arm_coleta_ciclo = pArmCiclo;
        exception
          When OTHERS Then
            vGRPSacado := '0000';
        End;
      
        If vTabSolCod is not null Then
          Begin
            If vTabSol = 'T' Then
              Select ta.fcf_tpcarga_codigo
                into vTpCarga
                From t_slf_tabela ta
               where ta.slf_tabela_codigo = lpad(trim(vTabSolCod), 8, '0')
                 and ta.slf_tabela_saque = lpad(trim(vTabSolSq), 4, '0');
            ElsIf vTabSol = 'S' Then
              Select ta.fcf_tpcarga_codigo
                into vTpCarga
                From t_slf_solfrete ta
               where ta.slf_solfrete_codigo =
                     lpad(trim(vTabSolCod), 8, '0')
                 and ta.slf_solfrete_saque = lpad(trim(vTabSolSq), 4, '0');
            End If;
            update t_arm_coleta an
               set an.fcf_tpcarga_codigo = vTpCarga
             where an.arm_coleta_ncompra = pArmColeta
               and an.arm_coleta_ciclo = pArmCiclo;
            commit;
          Exception
            When OTHERS Then
              vTpCarga := null;
          End;
        End If;
      
      End If;
    
      if vFracionado = 'S' Then
        if vTpCarga is not null Then
          vTpCarga := vTpCarga || '/';
        End If;
        vTpCarga := vTpCarga || 'FRACIONADO';
      End If;
    
      If vLotacao = 'S' Then
        if vTpCarga is not null Then
          vTpCarga := vTpCarga || '/';
        End If;
        vTpCarga := vTpCarga || 'LOTACAO';
      End If;
    
      If vColeta = 'S' Then
        if vTpCarga is not null Then
          vTpCarga := vTpCarga || '/';
        End If;
        vTpCarga := vTpCarga || 'COLETA';
      End If;
    
      If vExpresso = 'S' Then
        if vTpCarga is not null Then
          vTpCarga := vTpCarga || '/';
        Else
          vTpCarga := 'FRACIONADO/';
        End If;
        vTpCarga := vTpCarga || 'EXPRESSO';
      End If;
    
      If vQuimico = 'S' Then
        if vTpCarga is not null Then
          vTpCarga := vTpCarga || '/';
        End If;
        vTpCarga := vTpCarga || 'QUIMICO';
      End If;
    Else
      -- Se N?o Achou nada
      Begin
        select C.GLB_TPCARGA_CODIGO
          INTO vTpCarga
          from t_arm_coleta c, t_fcf_tpcarga tc
         where c.arm_coleta_ncompra = pArmColeta
           and c.arm_coleta_ciclo = pArmCiclo
           and c.fcf_tpcarga_codigo = tc.fcf_tpcarga_codigo;
      Exception
        When NO_DATA_FOUND Then
          vTpCarga := '';
      End;
    End If;
  
    If vTpCarga = 'EXPRESSO' Then
      vTpCarga := 'FRACIONADO/EXPRESSO';
    End If;
  
    if (vXMLColeta is not Null) and (vQuimico = 'S') Then
      -- Verificar se a ASN autoriza comom Formulario de Quimico
      vXMLColeta := vXMLColeta;
    
    End If;
  
    if (vXMLColeta is Null) Then
      -- Verifica se e Vale.
      -- Procura Parceiro PORTO
      -- Procura Grande Fluxo
      Begin
        select cl.glb_grupoeconomico_codigo, an.slf_contrato_codigo
          into vGRPSacado, vContrato
          from t_arm_nota an, t_glb_cliente cl
         where an.arm_nota_numero = pNota
           and an.glb_cliente_cgccpfsacado =
               trim(cl.glb_cliente_cgccpfcodigo)
           and an.glb_cliente_cgccpfremetente = trim(pCNPJRem)
           and an.arm_coleta_ncompra = pArmColeta
           and an.arm_coleta_ciclo = pArmCiclo;
      exception
        When OTHERS Then
          vGRPSacado := '0000';
      End;
    
      if vGRPSacado = '0020' Then
        --            pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
        --            pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
        --            pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
        --            pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
        --            pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
        --            pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type            
        -- Verifico se e PORTO
        -- N?O TENHO COMO VERIFICAR SE E PORTO PORQUE A FILIAL OU WEB N?O DIDIGTA O PARCEIRO
        vEPorto     := 'N';
        vLotacao    := 'N';
        vFracionado := 'N';
        if vEPorto = 'N' Then
          -- Verifico se e GRANDE FLUXO
          Begin
            --            pArmColeta in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
            --            pArmCiclo  in Tdvadm.t_Arm_Coleta.Arm_Coleta_Ciclo%type,
            --            pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
            --            pCNPJRem   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
            --            pORIGEM    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
            --            pDESTINO   in tdvadm.t_glb_localidade.glb_localidade_codigo%type            
          
            select sum(decode(cl.fcf_tpcarga_codigo, 11, 1, 0)),
                   sum(decode(cl.fcf_tpcarga_codigo, 12, 0, 1))
              into vEGFluxoL, vEGFluxoF
              From t_xml_clientelib cl
             where cl.glb_cliente_cgccpfcodigo = rpad(trim(pCNPJRem), 20)
               and cl.xml_clientelib_ativo = 'S'
               and cl.xml_clientelib_flaggf = 'S'
                  --                      and cl.fcf_tpcarga_codigo = decode(vLotacao,'S','11','12')
               and trim(cl.glb_localidade_codigoori) =
                   trim(decode(trim(cl.glb_localidade_codigoori),
                               '99999',
                               '99999',
                               fn_busca_codigoibge1(pORIGEM,
                                                    cl.xml_clientelib_tpcodori)))
               and trim(cl.glb_localidade_codigodes) =
                   trim(decode(trim(cl.glb_localidade_codigodes),
                               '99999',
                               '99999',
                               fn_busca_codigoibge1(pDESTINO,
                                                    cl.xml_clientelib_tpcoddes)))
               and cl.xml_clientelib_dtvigencia =
                   (select max(cl1.xml_clientelib_dtvigencia)
                      from t_xml_clientelib cl1
                     where cl1.glb_cliente_cgccpfcodigo =
                           cl.glb_cliente_cgccpfcodigo
                       and cl1.xml_clientelib_ativo =
                           cl.xml_clientelib_ativo
                       and cl1.xml_clientelib_flagporto =
                           cl.xml_clientelib_flagporto
                       and cl1.xml_clientelib_flaggf =
                           cl.xml_clientelib_flaggf
                       and cl1.xml_clientelib_flagaeroporto =
                           cl.xml_clientelib_flagaeroporto
                       and cl1.glb_localidade_codigoori =
                           cl.glb_localidade_codigoori
                       and cl1.xml_clientelib_tpcodori =
                           cl.xml_clientelib_tpcodori
                       and cl1.glb_localidade_codigodes =
                           cl.glb_localidade_codigodes
                       and cl1.xml_clientelib_tpcoddes =
                           cl.xml_clientelib_tpcoddes
                       and cl1.fcf_tpcarga_codigo = cl.fcf_tpcarga_codigo);
            vAuxiliar := vEGFluxoL + vEGFluxoF;
            if vEGFluxoL + vEGFluxoF > 0 Then
              vEGFluxo := 'S';
            End If;
          Exception
            When NO_DATA_FOUND Then
              vEGFluxo := 'N';
            When OTHERS Then
              vEGFluxo := 'N';
          End;
        End If;
      
        If (vEPorto = 'S') or (vEGFluxo = 'S') and (vAuxiliar = 1) Then
          if vEGFluxoL > 0 Then
            vLotacao := 'S';
          ElsIf vEGFluxoF > 0 Then
            vFracionado := 'S';
          Else
            vLotacao    := 'N';
            vFracionado := 'N';
          End If;
        End If;
      
        If vLotacao = 'S' Then
          vTpCarga := replace(vTpCarga, 'FRACIONADO', 'LOTACAO');
        ElsIf vFracionado = 'S' Then
          vTpCarga := replace(vTpCarga, 'LOTACAO', 'FRACIONADO');
        End If;
      
      ElsIf vContrato in ('C1041226000') Then
        -- MRO-THYSSENKRUPP-1115-XXX
        If vEntCol = 'C' Then
          vTpCarga := 'LOTACAO';
        ElsIf vEntCol = 'E' Then
          vTpCarga := 'FRACIONADO';
        End If;
      End If;
    
    End If;
  
    return vTpCarga;
  
  End FN_RETORNOTPCARGA;

  PROCEDURE SP_INFORMACLIENTE(pNota    in tdvadm.t_arm_nota.arm_nota_numero%type,
                              pCNPJ    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                              pSerie   in tdvadm.t_arm_nota.arm_nota_serie%type,
                              pArmazem in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                              pUsuario in tdvadm.t_arm_nota.usu_usuario_codigo%type,
                              pOrigem  in char, -- Acao pode Sedr E Etiqueta ou P Pesagem
                              pStatus  out char,
                              pMessage out varchar2)
  
   As
    vSACADO             tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type;
    vGrupo              tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type;
    vContrato           tdvadm.t_slf_clientecargas.slf_contrato_codigo%type;
    vAgrupamento        tdvadm.t_slf_tpagrupa.slf_tpagrupa_codigo%type;
    vColeta             tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
    vCiclo              tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
    vTemQuimico         tdvadm.t_arm_coleta.arm_coleta_flagquimico%type;
    vTemExpresso        tdvadm.t_arm_coleta.arm_coleta_tpcoleta%type;
    vTemCD              tdvadm.t_arm_nota.glb_tpcarga_codigo%type;
    vSequencia          tdvadm.t_arm_nota.arm_nota_sequencia%type;
    vPesoNota           number;
    vPesoPesagem        number;
    vAuxiliar           number;
    vPesoBal            number;
    vInformaCli         char(1) := 'N';
    vDtInclusao         date;
    vChave              tdvadm.t_arm_nota.arm_janelacons_sequencia%type;
    vStatus             char(1);
    vMessage            varchar2(1000);
    vLimiteBalanca      number := 3000;
    vTabSol             tdvadm.t_arm_nota.arm_nota_tabsolcod%type;
    vCodJanela          tdvadm.t_arm_janelacons.arm_janelacons_sequencia%type;
    vJanelaCons         tdvadm.t_arm_janelacons%rowtype;
    vTemBalanca         char(1) := 'S';
    vPesagemObrigatoria char(1) := 'N';
    vRota               tdvadm.t_arm_armazem.glb_rota_codigo%type;
    plistaparams        glbadm.pkg_listas.tlistausuparametros;
    tpNotaPesagem       tdvadm.t_arm_notapesagem%rowtype;
    vAcrescentaHora     number;
    vClienteInformado   char(1);
    vLocOrigem          tdvadm.t_arm_nota.arm_nota_localcoletal%type;
    vLocOrigemiI        tdvadm.t_arm_nota.arm_nota_localcoletal%type;
    vChavenota          tdvadm.t_arm_nota.arm_nota_chavenfe%type;
    vDataCol            date;
  Begin
    pStatus     := 'N'; -- Normal
    vStatus     := 'N'; -- Normal
    vInformaCli := 'N';
  
    Select a.glb_rota_codigo
      into vRota
      From t_arm_armazem a
     where a.arm_armazem_codigo = pArmazem;
  
    if Not glbadm.pkg_listas.fn_get_usuparamtros('carreg',
                                                 pUsuario,
                                                 vRota,
                                                 plistaparams) Then
      pStatus  := 'E';
      pMessage := 'Erro Buscando Parametros';
    End If;
  
    begin
      vPesagemObrigatoria := nvl(plistaparams('PESAGEMOBRIGATORIA').texto, 'S');
    exception
      When NO_DATA_FOUND Then
        vPesagemObrigatoria := 'S';
    End;
  
    Begin
      select nvl(max(nvl(fb.glb_filialbalanca_capacidade, 0)), 0)
        into vLimiteBalanca
        from tdvadm.t_glb_filialbalanca fb, tdvadm.t_arm_armazem an
       where fb.glb_rota_codigo = an.glb_rota_codigo
         and fb.glb_filialbalanca_ativa = 'S'
         and an.arm_armazem_codigo = pArmazem;
      If nvl(vLimiteBalanca, 0) <> 0 then
        vTemBalanca := 'S';
      Else
        vTemBalanca         := 'N';
        vPesagemObrigatoria := 'N';
      End If;
    exception
      When NO_DATA_FOUND Then
        vLimiteBalanca := 3000;
        vTemBalanca    := 'N';
    End;
  
    Begin
      Select an.arm_nota_chavenfe,
             an.arm_coleta_ncompra,
             an.arm_coleta_ciclo,
             decode(an.glb_tpcarga_codigo, 'CD', 'S', 'N'),
             decode(co.arm_coleta_tpcoleta, 'E', 'S', 'N'),
             decode(nvl(an.arm_nota_onu, 9999), 9999, 'N', 'S'),
             an.arm_nota_sequencia,
             an.arm_nota_pesobalanca,
             (select sum(p.arm_nota_peso)
                from tdvadm.t_arm_notapesagem p
               where p.arm_nota_sequencia = an.arm_nota_sequencia) pesagem,
             an.arm_nota_dtinclusao,
             an.arm_janelacons_sequencia,
             cl.glb_grupoeconomico_codigo,
             an.glb_cliente_cgccpfsacado,
             an.slf_contrato_codigo,
             an.arm_janelacons_sequencia,
             an.arm_nota_tabsolcod,
             co.arm_coleta_clienteinformado
        into vChavenota,
             vColeta,
             vCiclo,
             vTemCD,
             vTemExpresso,
             vTemQuimico,
             vSequencia,
             vPesoNota,
             vPesoPesagem,
             vDtInclusao,
             vChave,
             vGrupo,
             vSACADO,
             vContrato,
             vCodJanela,
             vTabSol,
             vClienteInformado
        From tdvadm.t_arm_nota    an,
             tdvadm.t_arm_coleta  co,
             tdvadm.t_glb_cliente cl
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and trim(an.arm_nota_serie) = trim(pSerie)
         and an.arm_coleta_ncompra = co.arm_coleta_ncompra
         and an.arm_coleta_ciclo = co.arm_coleta_ciclo
         and rpad(an.glb_cliente_cgccpfsacado, 20) =
             cl.glb_cliente_cgccpfcodigo(+)
         and an.arm_nota_sequencia =
             (select max(an1.arm_nota_sequencia)
                from t_arm_nota an1
               where an1.arm_nota_numero = an.arm_nota_numero
                 and an1.glb_cliente_cgccpfremetente =
                     an.glb_cliente_cgccpfremetente
                 and an1.arm_nota_serie = an.arm_nota_serie);
      -- Caso ja possua uma Janela
      -- esta opcao somente quando Sirlano Voltar de Ferias
      --           If ( nvl(vCodJanela,0) <> 0 ) and ( vClienteInformado = 'S' ) Then
      If (nvl(vCodJanela, 0) <> 0) Then
        pStatus := 'N';
        return;
      End If;
      vPesoPesagem := nvl(vPesoPesagem, 0);
      vPesoNota    := nvl(vPesoNota, 0);
    exception
      When NO_DATA_FOUND Then
        pStatus  := 'E';
        pMessage := 'Nota n?o Existe ou n?o esta vinculada a uma coleta. ';
        return;
    End;
  
    vLocOrigem := trim(tdvadm.pkg_fifo_carregctrc.fn_RetOrigDestNota('C',
                                                                     pNota,
                                                                     pCNPJ,
                                                                     pSerie,
                                                                     vColeta,
                                                                     vCiclo,
                                                                     vChavenota,
                                                                     60));
  
    If substr(vLocOrigem, 1, 5) = '00000' Then
      pStatus  := 'E';
      pMessage := 'Erro localizando origem da Nota [' || pNota || '-' ||
                  pSerie || '-' || pCNPJ || ']';
    End If;
    vLocOrigemiI := trim(fn_busca_codigoibge(trim(vLocOrigem), 'IBC'));
  
    update tdvadm.t_arm_nota no
       set no.arm_nota_localcoletal = vLocOrigem,
           no.arm_nota_localcoletai = vLocOrigemiI
     where no.arm_nota_numero = pNota
       and trim(no.glb_cliente_cgccpfremetente) = trim(pCNPJ)
       and trim(no.arm_nota_serie) = trim(pSerie);
  
    -- Se a Nota teve uma tabela ou solicitac?o indicada, passa direto
    if (vCodJanela is null) and (vTabSol is not null) Then
      vPesagemObrigatoria := 'N';
    End If;
  
    If vPesoNota > vLimiteBalanca Then
      vPesagemObrigatoria := 'N';
    End If;
  
    SP_GETREGRANOTA(pNota,
                    pCNPJ,
                    pSerie,
                    vSACADO,
                    vGrupo,
                    vContrato,
                    vAgrupamento);
    If vPesagemObrigatoria = 'S' Then
      select count(*)
        into vAuxiliar
        from tdvadm.t_slf_clienteregras cc
       where cc.glb_grupoeconomico_codigo = vGrupo
         and cc.glb_cliente_cgccpfcodigo = vSACADO
         and cc.slf_contrato_codigo = vContrato
         and cc.slf_clienteregras_ativo = 'S'
         and cc.slf_clienteregras_pcobranca = 'PB';
      If vAuxiliar = 0 Then
        vPesagemObrigatoria := 'N';
      End If;
    
    End If;
  
    If pStatus = 'N' Then
    
      If pOrigem = 'E' Then
        If vPesoNota > vLimiteBalanca Then
          vInformaCli := 'S';
        Else
          if vPesoPesagem <> 0 Then
            vInformaCli := 'S';
          ElsIf vPesoPesagem = 0 and (vPesagemObrigatoria = 'N') Then
            vInformaCli := 'S';
          End If;
        End If;
      ElsIf pOrigem = 'P' then
        If vPesoPesagem <> 0 Then
          vInformaCli := 'S';
        End If;
      Else
        vInformaCli := 'N';
        pStatus     := 'E';
        pMessage    := 'Origem Informada Esta Invalida. Somnete (E)tiqueta ou (P)esagem - [' ||
                       pStatus || ']';
        return;
      End If;
    
    End If;
  
    Begin
      select *
        into tpNotaPesagem
        from tdvadm.t_arm_notapesagem an
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and an.arm_nota_sequencia = vSequencia
         and nvl(an.arm_notapesagem_finalizou, 'N') = 'S';
      vAuxiliar := 1;
    Exception
      When NO_DATA_FOUND Then
        vAuxiliar := 0;
    End;
  
    If pOrigem = 'E' and vPesagemObrigatoria = 'N' Then
    
      -- Se n?o existir pesagem finalizada
      If vAuxiliar = 0 Then
        -- Excluindo pois tinham pessagem antigas
        delete t_arm_notapesagem an
         where an.arm_nota_numero = pNota
           and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
           and an.arm_nota_sequencia = vSequencia;
      End If;
      if vAuxiliar = 0 Then
        select an.arm_nota_numero,
               an.glb_cliente_cgccpfremetente,
               an.arm_nota_qtdvolume,
               an.arm_nota_pesobalanca,
               an.arm_nota_qtdvolume,
               an.arm_nota_pesobalanca,
               sysdate,
               an.arm_nota_sequencia,
               an.arm_nota_sequencia,
               an.arm_nota_chavenfe
          into tpNotaPesagem.Arm_Nota_Numero,
               tpNotaPesagem.Glb_Cliente_Cgccpfremetente,
               tpNotaPesagem.Arm_Nota_Qtdvolume,
               tpNotaPesagem.Arm_Nota_Peso,
               tpNotaPesagem.Arm_Notapesagem_Qtdvolume,
               tpNotaPesagem.Arm_Notapesagem_Pesototal,
               tpNotaPesagem.Arm_Notapesagem_Dtimprimiu,
               tpNotaPesagem.Arm_Notapesagem_Cod,
               tpNotaPesagem.Arm_Nota_Sequencia,
               tpNotaPesagem.Arm_Nota_Chavenfe
          From t_arm_nota an
         where an.arm_nota_numero = pNota
           and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
           and trim(an.arm_nota_serie) = trim(pSerie)
           and an.arm_nota_sequencia = vSequencia;
      
        tpNotaPesagem.Arm_Notapesagem_Status := 'NL';
        If vPesoNota <= vLimiteBalanca Then
          tpNotaPesagem.Arm_Notapesagem_Obs := 'USUARIO LIBERADO DE PESAGEM';
        Else
          tpNotaPesagem.Arm_Notapesagem_Obs := 'NOTA LIBERADA DE PESAGEM';
        End If;
        tpNotaPesagem.Arm_Notapesagem_Finalizou   := 'S';
        tpNotaPesagem.Arm_Notapesagem_Dtfinalizou := sysdate;
        tpNotaPesagem.Usu_Usuario_Codigoimprimiu  := pUsuario;
        insert into t_arm_notapesagem values tpNotaPesagem;
      
      end If;
    End If;
  
    vAuxiliar := 0;
    -- Verifica se ja tem CTe Gerado
    If vInformaCli = 'S' Then
      select count(*)
        into vAuxiliar
        from t_arm_nota an
       where an.arm_janelacons_sequencia = vChave
         and an.con_conhecimento_codigo is not null;
    End If;
  
    SP_GETJANELANOTA(pNota,
                     pCNPJ,
                     pSerie,
                     vJanelaCons.Arm_Janelacons_Dtinicio,
                     vJanelacons.Arm_Janelacons_Dtfim,
                     vJanelaCons.Arm_Janelacons_Geracte);
  
    -- N?o Tem Janela Informa o Cliente
    If (vJanelaCons.Arm_Janelacons_Dtinicio =
       vJanelacons.Arm_Janelacons_Dtfim) and
       (vJanelaCons.Arm_Janelacons_Dtinicio <>
       to_date('01/01/1900', 'dd/mm/yyyy')) Then
      vInformaCli := 'S';
    End If;
  
    If (vInformaCli = 'S') and (vAuxiliar = 0) Then
      SP_SETCRIAJANELA(pNota,
                       pCNPJ,
                       pSerie,
                       vSequencia,
                       'N',
                       vStatus,
                       vMessage);
      If vMessage is not null Then
        pMessage := pMessage || chr(10) || vMessage;
      End If;
      If vStatus = 'N' Then
      
        /********** SIRLANO JANELA *************/
        If trunc(sysdate) < to_date('08/05/2016', 'dd/mm/yyyy') then
          If pArmazem = '07' then
          
            vAcrescentaHora := 0.0416666667; -- equivalente a 1 Hora
            vDataCol        := sysdate;
            If (vGrupo = '0020') and (to_char(vDataCol, 'hh24') < 23) Then
              -- Se for antes das 23:00 horas Zera o acrescimo
              vAcrescentaHora := 0;
            End If;
          
            --tdvadm.pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,vCiclo,'01',pStatus,pMessage);
            --If pStatus = 'N' then
            vDataCol := sysdate + nvl(vAcrescentaHora, 0);
            update t_arm_coleta co
               set co.arm_coleta_dtfechamento = nvl(co.arm_coleta_dtfechamento,
                                                    vDataCol),
                   co.arm_coletaocor_codigo   = '01'
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo
               and trim(nvl(co.arm_coletaocor_codigo, 'XX')) <> '55';
            If sql%rowcount > 0 Then
              update tdvadm.t_col_asn a
                 set a.col_asn_dtrealcoleta = nvl(a.col_asn_dtrealcoleta,
                                                  vDataCol)
               where a.arm_coleta_ncompra = vColeta
                 and a.arm_coleta_ciclo = vCiclo;
            End If;
            --End If;
            commit;
          End If;
        Else
          vAcrescentaHora := 0.0833333334; -- equivalente a 2 Hora
          vDataCol        := sysdate;
          If (NVL(TRIM(vGrupo), '0020') = '0020') and
             (to_char(vDataCol, 'hh24') < 22) Then
            -- Se for antes das 23:00 horas Zera o acrescimo
            vAcrescentaHora := 0;
          End If;
          select count(*)
            into vAuxiliar
            From tdvadm.t_slf_clienteregras c
           where c.glb_grupoeconomico_codigo = vGrupo
             and c.glb_cliente_cgccpfcodigo = vSACADO
             and c.slf_contrato_codigo = vContrato
             and c.slf_clienteregras_ativo = 'S'
             AND c.slf_clienteregras_fimdigitnota = 'S';
          
          
          -------------------------------------------------------------------------
          -----------------------Thiago 03/10/2019---------------------------------
          --Inclus?o de log para identificar erro de criac?o de Janela Vale      --
          -------------------------------------------------------------------------   
          INSERT INTO TDVADM.T_ARM_NOTALOGPES
            (ARM_NOTALOGPES_NOTA,
             ARM_NOTALOGPES_CNPJ,
             ARM_NOTALOGPES_SERIE,
             ARM_NOTALOGPES_ARMAZEM,
             ARM_NOTALOGPES_USUARIO,
             ARM_NOTALOGPES_GRUPO,
             ARM_NOTALOGPES_SACADO,
             ARM_NOTALOGPES_CONTRATO,
             ARM_NOTALOGPES_AUXILIAR,
             ARM_NOTALOGPES_DTCADASTRO,
             ARM_NOTALOGPES_INFCLI,
             ARM_NOTALOGPES_STATUS,
             ARM_NOTALOGPES_MENSAGEM)
          VALUES
            (pNota,
             pCNPJ,
             PSerie,
             pArmazem,
             pUsuario,
             vGrupo,
             vSACADO,
             vContrato,
             vAuxiliar,
             sysdate,
             vInformaCli,
             vStatus,
             substr(vMessage,1,2000));

             
          If vAuxiliar > 0 Then
            -- Antes era usando sem ver se informava o Cliente
            -- Retirado em 16/10/2018 as 09:10
            --                   tdvadm.pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,vCiclo,'99',pStatus,pMessage);
            -- Proposta colocada em 16/10/2018 09:10
          
            -- Verifica se e obrigatorio a pesagem
            select count(*)
              into vPesoBal
              From tdvadm.t_slf_clienteregras c
             where c.glb_grupoeconomico_codigo = vGrupo
               and c.glb_cliente_cgccpfcodigo = vSACADO
               and c.slf_contrato_codigo = vContrato
               and c.slf_clienteregras_ativo = 'S'
               AND c.slf_clienteregras_pcobranca = 'PB';
          
            If ((vInformaCli = 'S') and (vPesoBal = 0)) or
               ((vPesoBal > 0) and
               (tpNotaPesagem.Arm_Notapesagem_Finalizou = 'S')) Then
              tdvadm.pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,
                                                                    vCiclo,
                                                                    '01',
                                                                    pStatus,
                                                                    pMessage);
            Else
              tdvadm.pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,
                                                                    vCiclo,
                                                                    '99',
                                                                    pStatus,
                                                                    pMessage);
            End If;
            -- Fim
          End If;
          If pStatus = 'N' then
            If vAuxiliar > 0 and tpNotaPesagem.Arm_Notapesagem_Finalizou = 'S' Then
              --                      tdvadm.pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,vCiclo,'01',pStatus,pMessage);
              vDataCol := vDataCol + nvl(vAcrescentaHora, 0);
              update tdvadm.t_arm_coleta co
                 set co.arm_coleta_dtfechamento = nvl(co.arm_coleta_dtfechamento,
                                                      vDataCol)
              --                            ,co.arm_coletaocor_codigo   = '01'
               where co.arm_coleta_ncompra = vColeta
                 and co.arm_coleta_ciclo = vCiclo
                 and trim(nvl(co.arm_coletaocor_codigo, 'XX')) <> '55';
            
              If sql%rowcount > 0 Then
                update tdvadm.t_col_asn a
                   set a.col_asn_dtrealcoleta = nvl(a.col_asn_dtrealcoleta,
                                                    vDataCol)
                 where a.arm_coleta_ncompra = vColeta
                   and a.arm_coleta_ciclo = vCiclo;
              End If;
            End If;
          End If;
          commit;
        
        End If;
      End If;
    ElsIf (vInformaCli = 'S') and (vAuxiliar <> 0) Then
      pStatus  := 'E';
      pMessage := 'Ja Existem CTe/NFSe emitidos para esta Janela. Impossivel alterar.';
    End If;
  
  End SP_INFORMACLIENTE;

  PROCEDURE SP_INFORMACLIENTE2(pNota    in tdvadm.t_arm_nota.arm_nota_numero%type,
                               pCNPJ    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pSerie   in tdvadm.t_arm_nota.arm_nota_serie%type,
                               pArmazem in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                               pUsuario in tdvadm.t_arm_nota.usu_usuario_codigo%type,
                               pOrigem  in char) -- Acao pode Sedr E Etiqueta ou P Pesagem
   As
    vStatus       char(1);
    vMessage      varchar2(2000);
    vAuxiliar     number;
    tpNotaPesagem tdvadm.t_arm_notapesagem%Rowtype;
  Begin
    If pOrigem = 'E' Then
      update t_arm_nota an
         set an.arm_nota_dtetiqueta = to_char(sysdate,
                                              'dd/mm/yyyy hh24:mi:ss')
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and trim(an.arm_nota_serie) = trim(pSerie)
         and an.arm_nota_dtetiqueta is null
         and an.arm_nota_sequencia =
             (select max(an1.arm_nota_sequencia)
                from t_arm_nota an1
               where an1.arm_nota_numero = an.arm_nota_numero
                 and an1.glb_cliente_cgccpfremetente =
                     an.glb_cliente_cgccpfremetente
                 and an1.arm_nota_serie = an.arm_nota_serie
                 and an1.arm_nota_dtetiqueta is null);
    ElsIf pOrigem = 'P' Then
      select count(*)
        into vAuxiliar
        from t_arm_notapesagem an
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and an.arm_nota_sequencia =
             (select max(an1.arm_nota_sequencia)
                from t_arm_nota an1
               where an1.arm_nota_numero = an.arm_nota_numero
                 and an1.glb_cliente_cgccpfremetente =
                     an.glb_cliente_cgccpfremetente
                 and an1.arm_nota_chavenfe = an.arm_nota_chavenfe);
      if vAuxiliar = 0 Then
        select an.arm_nota_numero,
               an.glb_cliente_cgccpfremetente,
               an.arm_nota_qtdvolume,
               an.arm_nota_pesobalanca,
               an.arm_nota_qtdvolume,
               an.arm_nota_pesobalanca,
               sysdate,
               an.arm_nota_sequencia,
               an.arm_nota_sequencia,
               an.arm_nota_chavenfe
          into tpNotaPesagem.Arm_Nota_Numero,
               tpNotaPesagem.Glb_Cliente_Cgccpfremetente,
               tpNotaPesagem.Arm_Nota_Qtdvolume,
               tpNotaPesagem.Arm_Nota_Peso,
               tpNotaPesagem.Arm_Notapesagem_Qtdvolume,
               tpNotaPesagem.Arm_Notapesagem_Pesototal,
               tpNotaPesagem.Arm_Notapesagem_Dtimprimiu,
               tpNotaPesagem.Arm_Notapesagem_Cod,
               tpNotaPesagem.Arm_Nota_Sequencia,
               tpNotaPesagem.Arm_Nota_Chavenfe
          From t_arm_nota an
         where an.arm_nota_numero = pNota
           and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
           and trim(an.arm_nota_serie) = trim(pSerie)
           and an.arm_nota_sequencia =
               (select max(an1.arm_nota_sequencia)
                  from t_arm_nota an1
                 where an1.arm_nota_numero = an.arm_nota_numero
                   and an1.glb_cliente_cgccpfremetente =
                       an.glb_cliente_cgccpfremetente
                   and an1.arm_nota_serie = an.arm_nota_serie);
      
        tpNotaPesagem.Usu_Usuario_Codigoimprimiu := pUsuario;
        insert into t_arm_notapesagem values tpNotaPesagem;
      end If;
    End If;
    SP_INFORMACLIENTE(pNota,
                      pCNPJ,
                      pSerie,
                      pArmazem,
                      pUsuario,
                      pOrigem,
                      vStatus,
                      vMessage);
  
  End SP_INFORMACLIENTE2;

  -- Procedure usada para fixar e ajustar particularidades do CONTRATO
  PROCEDURE SP_SETPARTCONTRATO(pNota    in tdvadm.t_arm_nota.arm_nota_numero%type,
                               pCNPJ    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pSerie   in tdvadm.t_arm_nota.arm_nota_serie%type,
                               pStatus  out char,
                               pMessage out varchar2) As
    vArmazem       tdvadm.t_arm_nota.arm_armazem_codigo%type;
    vSACADO        tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type;
    vCNPJRem       tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
    vCNPJDest      tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
    vGrupo         tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type;
    vGrupoRem      tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
    vGrupoDest     tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
    vGrupoSac      tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
    vContrato      tdvadm.t_slf_clientecargas.slf_contrato_codigo%type;
    vContratoC     tdvadm.t_slf_clientecargas.slf_contrato_codigo%type;
    vCTe           tdvadm.t_arm_nota.con_conhecimento_codigo%type;
    vEntCol        tdvadm.t_arm_coleta.arm_coleta_entcoleta%type;
    vOrigemCol     tdvadm.t_arm_coleta.arm_coletaorigem_cod%type;
    vASN           tdvadm.t_arm_coleta.xml_coleta_numero%type;
    vVeiculoASN    tdvadm.t_col_asn.col_asn_tipoveiculo%type;
    vXMLIncoterms  tdvadm.t_xml_coleta.xml_coleta_incoterms%type;
    vAgrupamento   tdvadm.t_slf_tpagrupa.slf_tpagrupa_codigo%type;
    vColeta        tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
    vCiclo         tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
    vTemQuimico    tdvadm.t_arm_coleta.arm_coleta_flagquimico%type;
    vTemExpresso   tdvadm.t_arm_coleta.arm_coleta_tpcoleta%type;
    vTemReparo     tdvadm.t_arm_nota.glb_tpcarga_codigo%type;
    vTemCD         tdvadm.t_arm_nota.glb_tpcarga_codigo%type;
    vtemCA         tdvadm.t_arm_nota.glb_tpcarga_codigo%type;
    vTipoCarga     tdvadm.t_arm_nota.glb_tpcarga_codigo%type;
    vTipoCargaCol  tdvadm.t_arm_coleta.fcf_tpcarga_codigo%type;
    vSequencia     tdvadm.t_arm_nota.arm_nota_sequencia%type;
    vChave         tdvadm.t_arm_nota.arm_nota_chavenfe%type;
    vLocOrigem     tdvadm.t_arm_nota.arm_nota_localcoletal%type;
    vLocDestino    tdvadm.t_arm_nota.arm_nota_localentregal%type;
    vLocOrigemiI   tdvadm.t_arm_nota.arm_nota_localcoletal%type;
    vLocDestinoI   tdvadm.t_arm_nota.arm_nota_localentregal%type;
    vLocOutraCol   tdvadm.t_arm_nota.arm_nota_localoutracoletal%type;
    vLocOutraEnt   tdvadm.t_arm_nota.arm_nota_localoutraentregal%type;
    vLocOutraColI  tdvadm.t_arm_nota.arm_nota_localoutracoletai%type;
    vLocOutraEntI  tdvadm.t_arm_nota.arm_nota_localoutraentregai%type;
    vJanela        tdvadm.t_arm_nota.arm_janelacons_sequencia%type;
    vAuxiliar      number;
    vAuxiliar1     number;
    vCNPJSac       tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type;
    vAuxiliarT     varchar2(40);
    tpArmNota      tdvadm.t_arm_nota%rowtype;
    vTipoVeiculo   tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%type;
    vStatus        char(1);
    vMessage       varchar2(1000);
    vDtEmi         Date;
    vDtEntSai      Date;
    vDtEmiXML      Date;
    vDtEntSaiXML   Date;
    vLinha         char(2);
    vTabSol        t_arm_nota.arm_nota_tabsolcod%type;
    vUsuario       tdvadm.t_arm_nota.usu_usuario_codigo%type;
    vNumeroNotaASN tdvadm.t_arm_coletapart.arm_coletapart_nfe%type;
    vCentroCusto   tdvadm.t_arm_coleta.arm_coleta_centrodecusto%type;
    vDtColeta      tdvadm.t_arm_coleta.arm_coleta_dt%type;
    vPedidoColeta  tdvadm.t_arm_coleta.arm_coleta_pedido%type;
    vCodCliViagem  tdvadm.t_arm_nota.arm_nota_codcliviagem%type;
    vTpVeiculo     tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%type;
    Colpedido      tdvadm.t_arm_coleta.arm_coleta_pedido%type;
    vPedidonota    tdvadm.t_arm_nota.xml_notalinha_numdoc%type;
    vCarregamento  tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
    vPbArrend      tdvadm.t_slf_clienteregras.slf_clienteregras_pbarrend%type;
    vPbDecGramas   tdvadm.t_slf_clienteregras.slf_clienteregras_pbdecgramas%type;
    vPesoNota      tdvadm.t_arm_nota.arm_nota_peso%type;
    vDB_NAME       tdvadm.v_glb_ambiente.db_name%type;
    vUFOrigem      tdvadm.t_glb_estado.glb_estado_codigo%type;
  Begin
    pStatus := 'N'; -- Normal
    -- Sirlano
    -- 14/12/2020 -- Pegando qual o Banco de Dados que estamos trabalhando
    select upper(a.db_name)
      into vDB_NAME
    from tdvadm.v_glb_ambiente a;
  
    Begin
      vLinha := '01';
      Select an.arm_armazem_codigo,
             an.arm_coleta_ncompra,
             an.arm_coleta_ciclo,
             decode(trim(an.glb_tpcarga_codigo), 'RP', 'S', 'N'), -- Se tem Reparo 
             decode(trim(an.glb_tpcarga_codigo), 'CD', 'S', 'N'), -- Se tem Carga Direta
             decode(trim(an.glb_tpcarga_codigo), 'FF', 'S', 'N'), -- Se tem Carga Direta
             decode(trim(co.arm_coleta_tpcoleta), 'E', 'S', 'N'), -- Se coleta expressa
             decode(nvl(an.arm_nota_onu, 9999), 9999, 'N', 'S'),
             an.glb_tpcarga_codigo,
             co.fcf_tpcarga_codigo,
             an.arm_nota_sequencia,
             an.arm_nota_chavenfe,
             an.slf_contrato_codigo,
             co.slf_contrato_codigo,
             an.con_conhecimento_codigo,
             co.arm_coleta_entcoleta,
             co.arm_coletaorigem_cod,
             co.xml_coleta_numero,
             an.glb_cliente_cgccpfsacado,
             co.glb_cliente_cgccpfcodigocoleta,
             co.glb_cliente_cgccpfcodigoentreg,
             an.arm_nota_tabsolcod,
             an.arm_janelacons_sequencia,
             an.usu_usuario_codigo,
             co.arm_coleta_centrodecusto,
             co.arm_coleta_pedido,
             an.arm_nota_codcliviagem,
             cl.glb_grupoeconomico_codigo,
             cls.glb_grupoeconomico_codigo,
             cld.glb_grupoeconomico_codigo,
             an.arm_nota_peso,
             an.xml_notalinha_numdoc,
             co.arm_coleta_dt
        into vArmazem,
             vColeta,
             vCiclo,
             vTemReparo,
             vTemCD,
             vtemCA,
             vTemExpresso,
             vTemQuimico,
             vTipoCarga,
             vTipoCargaCol,
             vSequencia,
             vChave,
             vContrato,
             vContratoC,
             vCTe,
             vEntCol,
             vOrigemCol,
             vASN,
             vCNPJSac,
             vCNPJRem,
             vCNPJDest,
             vTabSol,
             vJanela,
             vUsuario,
             vCentroCusto,
             vPedidoColeta,
             vCodCliViagem,
             vGrupoRem,
             vGrupoSac,
             vGrupoDest,
             vPesoNota,
             vPedidonota,
             vDtColeta
        From tdvadm.t_arm_nota    an,
             tdvadm.t_arm_coleta  co,
             tdvadm.t_glb_cliente cl,
             tdvadm.t_glb_cliente cls,
             tdvadm.t_glb_cliente cld
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and trim(an.arm_nota_serie) = trim(pSerie)
         and trim(an.glb_cliente_cgccpfsacado) =
             trim(cls.glb_cliente_cgccpfcodigo)
         and an.arm_coleta_ncompra = co.arm_coleta_ncompra
         and an.arm_coleta_ciclo = co.arm_coleta_ciclo
         and rpad(an.glb_cliente_cgccpfremetente, 20) =
             cl.glb_cliente_cgccpfcodigo
         and rpad(an.glb_cliente_cgccpfdestinatario, 20) =
             cld.glb_cliente_cgccpfcodigo
         and an.arm_nota_sequencia =
             (select max(an1.arm_nota_sequencia)
                from t_arm_nota an1
               where an1.arm_nota_numero = an.arm_nota_numero
                 and an1.glb_cliente_cgccpfremetente =
                     an.glb_cliente_cgccpfremetente
                 and an1.arm_nota_serie = an.arm_nota_serie);
      If ( vContratoC is not null ) then
        vContrato := vContratoC;
      End If;
      
      vTipoCargaCol := trim(vTipoCargaCol);
      -- 14/12/2020
      -- Sirlano - Toda Tipo de Carga 03 muda a coleta para tipo EXPRESSO
      If ( vTipoCargaCol = '03' ) Then
         update tdvadm.t_arm_coleta co
           set co.arm_coleta_tpcoleta = 'E'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo =  vCiclo
           and co.arm_coleta_tpcoleta != 'E'; 
         vTemExpresso := 'S';
      End If; 
      
    
      vLinha := '02';
      Select an.*
        into tpArmNota
        from t_Arm_nota an
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and trim(an.arm_nota_serie) = trim(pSerie)
         and an.arm_nota_sequencia = vSequencia;
    
    exception
      When NO_DATA_FOUND Then
        pStatus  := 'E';
        pMessage := 'Nota n?o Existe ou n?o esta vinculada a uma coleta. ';
        return;
    End;
  
    If vCTe is not null Then
      pStatus  := 'E';
      pMessage := pMessage || chr(10) || 'Nota Ja Tem Comnhecimento [' || vCTe || ']';
    End If;
  
    select count(*)
      into vAuxiliar
      from t_arm_nota an
     where an.arm_janelacons_sequencia = vJanela
       and an.con_conhecimento_codigo is not null;
  
    If ( vAuxiliar > 0 ) and ( vTipoCargaCol not in ('13','14') ) then
      pStatus  := 'E';
      pMessage := pMessage || chr(10) ||
                  'Janela Ja tem Cte emitido, nota nao pode ser alterada Janela => [' ||
                  vJanela || ']';
    End If;
  
    Begin
    
      vLinha := '03';
      select distinct i.dEmi,
                      i.dSaiEnt,
                      an.arm_movimento_datanfentrada datanfentrada,
                      an.arm_nota_dtrecebimento      dtrecebimento
        into vDtEmiXML, vDtEntSaiXML, vDtEmi, vDtEntSai
        from tdvadm.v_xml_idenota i, tdvadm.t_arm_nota an
       where 0 = 0
         and i.XML_NFE_ID = an.arm_nota_chavenfe
         and an.arm_nota_dtinclusao >= to_date('01/04/2016', 'dd/mm/yyyy')
         and i.XML_NFE_ID = vChave
         and an.glb_cliente_cgccpfsacado = vCNPJSac
         and an.glb_tpcarga_codigo not in ('CO', 'RP');
      -- Validando as Datas da nota
    
      if (vDtEmi <> vDtEmiXML) Then
        pStatus  := 'E';
        pMessage := pMessage || chr(10) ||
                    'Datas de Emissao DIVERGENTES: Digitada [' ||
                    to_char(vDtEmi, 'dd/mm/yyyy') || '] XML [' ||
                    to_char(vDtEmiXML, 'dd/mm/yyyy') || ']';
      End If;
    
      if (vDtEntSai <> nvl(vDtEntSaiXML, vDtEmiXML)) Then
        pStatus  := 'E';
        pMessage := pMessage || chr(10) ||
                    'Datas de Saida DIVERGENTES: Digitada [' ||
                    to_char(vDtEntSai, 'dd/mm/yyyy') || '] XML [' ||
                    to_char(nvl(vDtEntSaiXML, vDtEmiXML), 'dd/mm/yyyy') || ']';
      End If;
    
    Exception
      When NO_DATA_FOUND then
        vDtEmi := vDtEmi;
    End;
  
    -- Ajusta as localidades da Nota
  
    vLinha := '04';
  
    vLocOrigem := trim(PKG_FIFO_CARREGCTRC.fn_RetOrigDestNota('C',
                                                              pNota,
                                                              pCNPJ,
                                                              pSerie,
                                                              vColeta,
                                                              vCiclo,
                                                              vChave,
                                                              90));
    if vLocOrigem = '00000' Then
      pStatus  := 'E';
      pMessage := pMessage || chr(10) ||
                  'Localidade de Coleta n?o calculada' || chr(10);
    End If;
  
    vLinha      := '05';
    vLocDestino := trim(PKG_FIFO_CARREGCTRC.fn_RetOrigDestNota('E',
                                                               pNota,
                                                               pCNPJ,
                                                               pSerie,
                                                               vColeta,
                                                               vCiclo,
                                                               vChave,
                                                               90));
  
    if vLocDestino = '00000' Then
      pStatus  := 'E';
      pMessage := pMessage || chr(10) ||
                  'Localidade de Entrega n?o calculada';
    End If;
  
    vLocOrigemiI := trim(fn_busca_codigoibge(trim(vLocOrigem), 'IBC'));
    If vLocOrigemiI = 'SIBGE' Then
      pStatus  := 'E';
      pMessage := pMessage || chr(10) || 'Localidade de Coleta - ' ||
                  vLocOrigem || ' sem IBGE';
    End If;
  
    vLocDestinoI := trim(fn_busca_codigoibge(trim(vLocDestino), 'IBC'));
    If vLocDestinoI = 'SIBGE' Then
      pStatus  := 'E';
      pMessage := pMessage || chr(10) || 'Localidade de Entrega - ' ||
                  vLocDestino || ' sem IBGE';
    End If;
  
    Begin
      SELECT CEC.GLB_LOCALIDADE_CODIGO OUTRACOLETA,
             CEE.GLB_LOCALIDADE_CODIGO OUTRAENTREGA
        INTO vLocOutraCol, vLocOutraEnt
        FROM TDVADM.T_ARM_COLETAIMPEXP X,
             TDVADM.T_GLB_CLIEND       CEC,
             TDVADM.T_GLB_CLIEND       CEE
       WHERE X.ARM_COLETA_NCOMPRA = vColeta
         AND X.ARM_COLETA_CICLO = vCiclo
         AND X.GLB_CLIENTE_CGCCPFCOLETA = CEC.GLB_CLIENTE_CGCCPFCODIGO(+)
         AND X.GLB_TPCLIEND_CODIGOCOLETA = CEC.GLB_TPCLIEND_CODIGO(+)
         AND X.GLB_CLIENTE_CGCCPFENTREGA = CEE.GLB_CLIENTE_CGCCPFCODIGO(+)
         AND X.GLB_TPCLIEND_CODIGOENTREGA = CEE.GLB_TPCLIEND_CODIGO(+);
    
      vLocOutraColI := tdvadm.fn_busca_codigoibge1(vLocOutraCol, 'IBC');
      vLocOutraEntI := tdvadm.fn_busca_codigoibge1(vLocOutraEnt, 'IBC');
    Exception
      When NO_DATA_FOUND Then
        vLocOutraCol  := null;
        vLocOutraEnt  := null;
        vLocOutraColI := null;
        vLocOutraEntI := null;
    end;
  
    if vLocOutraCol is not null Then
      If vLocOutraColI = 'SIBGE' Then
        pStatus  := 'E';
        pMessage := pMessage || chr(10) || 'Localidade de Outra Coleta - ' ||
                    vLocOutraCol || ' sem IBGE';
      End If;
    End If;
  
    if vLocOutraEnt is not null Then
      If vLocOutraEntI = 'SIBGE' Then
        pStatus  := 'E';
        pMessage := pMessage || chr(10) || 'Localidade de Outra Emtrega - ' ||
                    vLocOutraEnt || ' sem IBGE';
      End If;
    End If;
    
    
    Begin 
        -- Verifica a UF de origem p
        select lo.glb_estado_codigo
          into vUFOrigem
        from tdvadm.t_glb_localidade lo
        where lo.glb_localidade_codigo = vLocOrigem; 
        If vUFOrigem = 'MS' Then
            select count(*)
              into vAuxiliar
            from tdvadm.t_usu_perfil p
            where p.usu_aplicacao_codigo = '0000000000'
              and p.usu_perfil_codigo = 'UFERMS'
              and p.usu_perfil_ativo = 'S'
              and p.usu_perfil_vigencia >= to_date('01' || to_char(sysdate,'/mm/yyyy'),'dd/mm/yyyy');
            If vAuxiliar <= 0 Then
               pStatus  := 'E';
               pMessage := pMessage || chr(10) || 'N¿o Encontrado a UFERMS para calculo da BASE MINIMA.' || chr(10) || 
                                                  'Ligue para o FATURAMENTO, solicitando o Cadastramento' || chr(10);
            End If;
        End If;    
    exception
      When Others Then
          vUFOrigem := 'XX';
      End ;    
  
    If pStatus = 'N' then
      vStatus  := 'N';
      vMessage := '';
      vLinha   := '06';
      If vContratoC is null Then
        vContrato := fn_ValidaContrato(vColeta,
                                       vCiclo,
                                       pNota,
                                       pCNPJ,
                                       vCNPJSac,
                                       vLocOrigemiI,
                                       vLocDestinoI,
                                       vContrato,
                                       vStatus,
                                       vMessage);
      Else
        vContrato := vContratoC;
      end If;
      If length(trim(vMessage)) <> 0 then
        pMessage := pMessage || chr(10) || vMessage;
      End If;
    
      If nvl(vStatus, 'N') = 'E' Then
        pStatus := 'E';
        Return;
      End If;
    
      vLinha := '61';
    
      update tdvadm.t_arm_nota an
         set an.arm_nota_localcoletal       = vLocOrigem,
             an.arm_nota_localentregal      = vLocDestino,
             an.arm_nota_localcoletai       = vLocOrigemiI,
             an.arm_nota_localentregai      = vLocDestinoI,
             an.arm_nota_localoutracoletal  = vLocOutraCol,
             an.arm_nota_localoutraentregal = vLocOutraEnt,
             an.arm_nota_localoutracoletai  = vLocOutraColI,
             an.arm_nota_localoutraentregai = vLocOutraEntI,
             an.slf_contrato_codigo         = vContrato
       where an.arm_nota_sequencia = vSequencia;
       vAuxiliar := sql%rowcount;
       
      vLinha := '62';
      --          if vAuxiliar = 0 Then
      If vOrigemCol in (
                        --                                1, -- Coleta gerada pelo gerenciador de coleta
                        --                                2, -- Coleta gerada pela Integrac?o Quadrem X  TDV
                        --                                3, -- Coleta gerada pela WEB app ASP
                        --                                4, -- Coleta gerada pela WEB App JAVA
                        --                                5, -- Coleta gerada pelo integrac?o AUT-e
                        6, -- Coleta gerada pelo FIFO
                        7 -- Coleta gerada pelo Cadastro de Coleta Delphi
                        ) Then
        SELECT decode(vTipoCarga,
                      'FF',
                      '02', -- FRACIONADO
                      'OC',
                      '22', -- OP.CASADA
                      'OS',
                      '23', -- OP.SIMPLES
                      'OR',
                      '24', -- OP.REDONDA
                      'CU',
                      '27', -- CUBADA
                      'CO',
                      '20', -- COLETA
                      'RP',
                      '06', -- REPARO
                      'CD',
                      '01', -- LOTACAO
                      co.fcf_tpcarga_codigo)
          INTO vAuxiliarT
          FROM tdvadm.t_arm_coleta co
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
      
        update tdvadm.t_arm_coleta co
           set co.fcf_tpcarga_codigo = trim(vAuxiliarT)
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
      
      End If;
      --       End If;
    
      -- Pega o Tipo de Carga para gravar na coleta
      vLinha     := '07';
      vAuxiliarT := FN_RETORNOTPCARGA(vColeta,
                                      vCiclo,
                                      pNota,
                                      pCNPJ,
                                      vLocOrigemiI,
                                      vLocDestinoI);
    
      UPDATE T_ARM_COLETA C
         SET C.ARM_COLETA_TPCARGACALC = vAuxiliarT
       WHERE C.ARM_COLETA_NCOMPRA = vColeta
         AND C.ARM_COLETA_CICLO = vCiclo;
      If vColeta = '634235' Then
        COMMIT;
      End If;
      -- Pega qual regra sera usada
      vLinha := '08';
      SP_GETREGRANOTA(pNota,
                      pCNPJ,
                      pSerie,
                      vSACADO,
                      vGrupo,
                      vContrato,
                      vAgrupamento);
                      
                      
      -------------Victor e Sirlano-----------------
      ---------Alterado dia 23/09/2019--------------
      ----Verificar as regras de arredoindamento----
      Begin
          select cr.slf_clienteregras_pbarrend,
                 cr.slf_clienteregras_pbdecgramas
             into vPbArrend,
                  vPbDecGramas         
          from tdvadm.t_slf_clienteregras cr
          where cr.glb_grupoeconomico_codigo = vGrupo
            and cr.glb_cliente_cgccpfcodigo = vSACADO
            and cr.slf_contrato_codigo = vContrato
            and cr.slf_clienteregras_ativo = 'S'
            and cr.slf_clienteregras_vigencia = ( Select Max(cr1.slf_clienteregras_vigencia)
                                                  from tdvadm.t_slf_clienteregras cr1
                                                  where cr1.glb_grupoeconomico_codigo = cr.glb_grupoeconomico_codigo
                                                    and cr1.glb_cliente_cgccpfcodigo = cr.glb_cliente_cgccpfcodigo
                                                    and cr1.slf_contrato_codigo = cr.slf_contrato_codigo  
                                                    and cr1.slf_clienteregras_ativo = cr.slf_clienteregras_ativo ) ;             
       Exception
         when NO_DATA_FOUND Then
           vPbArrend    := 'S';
           vPbDecGramas := 0;
         End;  
         
         If vPbArrend = 'S' Then
            vPesoNota := ROUND(vPesoNota,vPbDecGramas);
            update tdvadm.t_arm_nota an
               set an.arm_nota_peso = vPesoNota
            where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia
             and an.con_conhecimento_codigo is null;
         End If;
                    
    
      -- Aplica as particularidades dos contratos
      If (vContrato = 'Sirlano') Then
        --- So para facilitar a identac?o 
        vContrato := vContrato;
      
      ElsIf (vContrato = 'C2015080004') Then
        -- 0563 - FRA-NOVA PONTOCOM-0913-XXX
        Begin
          select nvl(nf.edi_nf_pesototal, 0), nvl(nf.edi_nf_pesocubado, 0)
            into vAuxiliar, vAuxiliar1
            from tdvadm.t_edi_nf nf
           where nf.edi_nf_numero = lpad(pNota, 9, '0')
             and nf.edi_emb_cnpj = rpad(pCNPJ, 20);
        exception
          When NO_DATA_FOUND Then
            vAuxiliar  := 0;
            vAuxiliar1 := 0;
          When OTHERS then
            vAuxiliar  := 0;
            vAuxiliar1 := 0;
        End;
      
        if vAuxiliar = 0 Then
          pMessage := PMessage ||
                      'N?o Foi encontrada a INTEGRAC?O EDI com a NOVA PONTO COM' ||
                      chr(10);
          pStatus  := 'E';
        Else
          -- para a CNOVA vamos colocar o Maior entre coborado e cubado
          update tdvadm.t_arm_nota an
             set an.Arm_Nota_Peso            = vAuxiliar,
                 an.ARM_MOVIMENTO_PESOCUBADO = NVL(vAuxiliar1, 0.001),
                 an.arm_coleta_pesocobrado   = greatest(vAuxiliar,
                                                        nvl(vAuxiliar1, 0.001)),
                 an.arm_nota_pesobalanca     = greatest(vAuxiliar,
                                                        nvl(vAuxiliar1, 0.001))
           where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia;
        End If;
      
      ElsIf (vContrato = 'C4184150000') Then
        --  0535 - MRO-SUNCOKE-0915-XXX
        update t_arm_coleta co
           set co.fcf_tpcarga_codigo = '01'
         Where 0 = 0
           and co.ARM_COLETA_NCOMPRA = vColeta
           and co.ARM_COLETA_CICLO = vCiclo;
      
      ElsIf (vContrato = 'C5800000563') Then
        --  0535 - LOT-ARCELORMITTAL-0116-CONTAGEM 
        update t_arm_coleta co
           set co.fcf_tpcarga_codigo = '11'
         Where 0 = 0
           and co.ARM_COLETA_NCOMPRA = vColeta
           and co.ARM_COLETA_CICLO = vCiclo
           and co.fcf_tpcarga_codigo = '01';
      
      ElsIf (vContrato = 'C2019021131') Then
        -- 0639 - MRO-NOVELIS-0218-XXX
        update t_arm_coleta co
           set co.fcf_tpcarga_codigo = '01'
         where 0 = 0
           and co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo
           and co.arm_coleta_tpcoleta = 'E';
      
      ElsIf (vContrato = 'C2016080027') Then
        -- 0006 - MRO-AMSTED-0816-CRUZEIRO E HORTOLANDIA
      
        update t_arm_coleta co
           set co.arm_coleta_tpcargacalc = 'FRACIONADO',
               co.fcf_tpcarga_codigo     = '12'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo
           and co.fcf_tpcarga_codigo = '02';
      
      ElsIf (vContrato = 'C5100006176') Then
        --  0535 - MRO-ARCELORMITTAL-0415-ITAUNA
        update t_arm_coleta co
           set co.fcf_tpcarga_codigo = '11'
         Where 0 = 0
           and co.ARM_COLETA_NCOMPRA = vColeta
           and co.ARM_COLETA_CICLO = vCiclo
           and co.fcf_tpcarga_codigo = '01';
      
        If (vTemExpresso = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO/EXPRESSO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Elsif (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      ElsiF (vContrato in ('C5900011012', -- 0020 - MRO-VALE-0314-CS2781910
                           'C2014030105', -- 0020 - MRO-VALE MANGANES-0314-CS2781910/M
                           'C5900307551', -- 0020 - LOT-VALE-0915-LOTE 1
                           'C5900307552', -- 0020 - LOT-VALE-0915-LOTE 2
                           'C5900347813', -- 0020 - LOT-VALE-1215-LOTE 3
                           'C5900347814', -- 0020 - LOT-VALE-1215-LOTE 4
                           'C590030755/2',
                           'C590030755/3') or (vGrupo = '0020')) Then
      
        If vContrato in
           ('C5900347813', 'C5900347814', 'C5900307551', 'C5900307552') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = decode(vTemExpresso,
                                                    'N',
                                                    'LOTACAO',
                                                    'LOTACAO/EXPRESSO'),
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo in ('01', '11');
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = decode(vTemExpresso,
                                                    'N',
                                                    'LOTACAO',
                                                    'LOTACAO/EXPRESSO'),
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo in ('01', '11');
        
        End If;
        vAuxiliar := sql%rowcount;
      
        update t_arm_coleta co
           set co.arm_coleta_tpcargacalc = decode(vTemExpresso,
                                                  'N',
                                                  'FRACIONADO',
                                                  'FRACIONADO/EXPRESSO'),
               co.fcf_tpcarga_codigo     = '12'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo
           and trim(nvl(co.fcf_tpcarga_codigo, '02')) not in
               ('01', '11', '10', '03');
      
        vAuxiliar := sql%rowcount;
      
        -- Iguala os Pesos para Cargas Acima de 3.000 Quilos      
        update t_arm_nota an
           set an.arm_coleta_pesocobrado = an.arm_nota_peso,
               an.arm_nota_pesobalanca   = an.arm_nota_peso
         where an.arm_nota_numero = pNota
           and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
           and trim(an.arm_nota_serie) = trim(pSerie)
           and an.arm_nota_sequencia = vSequencia
           and an.con_conhecimento_codigo is null
           and an.arm_nota_peso > 3000;
      
        If vContrato = 'C590030755/2' Then
        
          Begin
            select casn.col_asn_tipoveiculo
              into vVeiculoASN
              from tdvadm.t_col_asn casn
             where casn.col_asn_numero = vASN;
          exception
            When NO_DATA_FOUND Then
              vVeiculoASN := '';
              vTpVeiculo  := '9  ';
          End;
        
          If vVeiculoASN in ('TRUCK',
                             'BR00000009', -- Cavalo 6x4
                             'Cavalo 6x4') Then
            vTpVeiculo := '3  ';
          ElsIf vVeiculoASN in ('CARRETA',
                                'BR00000010', -- Cavalo 6x6
                                'Cavalo 6x6') Then
            vTpVeiculo := '1  ';
          ElsIf vVeiculoASN in ('BITREM',
                                'BR00000011', -- Cavalo 8x4
                                'Cavalo 8x4') Then
            vTpVeiculo := '2  ';
          End If;
        
          update tdvadm.t_arm_nota an
             set an.glb_mercadoria_codigo = 'FS'
           where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia
             and an.con_conhecimento_codigo is null;
        
          Update tdvadm.t_arm_coleta co
             set co.fcf_tpveiculo_codigo = vTpVeiculo
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
        ElsIf vContrato = 'C590030755/3' Then
        
          Begin
            select casn.col_asn_tipoveiculo
              into vVeiculoASN
              from tdvadm.t_col_asn casn
             where casn.col_asn_numero = vASN;
          exception
            When NO_DATA_FOUND Then
              vVeiculoASN := '';
              vTpVeiculo  := '9  ';
          End;
        
          If vVeiculoASN in ('CARRETA',
                             'BR00000007', -- Cavalo 4x2
                             'Cavalo 4x2') Then
            vTpVeiculo := '1  ';
          ElsIf vVeiculoASN in ('BITREM',
                                'BR00000008', -- Cavalo 6x2
                                'Cavalo 6x2') Then
            vTpVeiculo := '2  ';
          End If;
        
          update tdvadm.t_arm_nota an
             set an.glb_mercadoria_codigo = '16'
           where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia
             and an.con_conhecimento_codigo is null;
        
          Update tdvadm.t_arm_coleta co
             set co.fcf_tpveiculo_codigo = vTpVeiculo
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
        End If;
      
        If vContrato in
           ('2781910', 'C5900011012', '2781910/M', 'C2014030105') or
           (vGrupo = '0020') Then
        
          -- Verificac?o para a vale, validar nfe
          IF (vGrupo = '0020') THEN
          
            -- Nova Critica para a Vale o Numero da Nota tem que ser igual o que veio na Coleta.
            Begin
              select x.arm_coletapart_nfe
                into vNumeroNotaASN
                from tdvadm.t_arm_coletapart x
               where x.arm_coleta_ncompra = vColeta
                 and x.arm_coleta_ciclo = vCiclo
                 and x.arm_coletapart_nfe is not null;
            exception
              When NO_DATA_FOUND Then
                vNumeroNotaASN := null;
            End;
          
            -- Se Parametro Estiver Ativo.
            If vNumeroNotaASN is not null Then
              select count(*)
                into vAuxiliar
                from tdvadm.t_usu_perfil p
               where p.usu_perfil_codigo = 'COMPARANOTAASN'
                 and (instr(p.usu_perfil_parat, TRIM(vUsuario)) > 0 or
                     p.usu_perfil_parat = 'TODOS');
            Else
              vAuxiliar := 0;
            End If;
          
            -- Se tiver preenchida o nuemro da nota na coleta, validamos. 
            If (vAuxiliar <> 0) Then
            
              If length(trim(nvl(vNumeroNotaASN, ''))) > 0 then
                If (length(trim(nvl(vNumeroNotaASN, ''))) >= 44) and
                   (trim(vNumeroNotaASN) <> trim(vChave)) Then
                  pMessage := PMessage || 'Coleta ' || vColeta ||
                              ' somente podera ser usando com a Nota ' ||
                              substr(vNumeroNotaASN, 26, 9) || chr(10);
                  pStatus  := 'E';
                ElsIf substr(vNumeroNotaASN, 1, 9) <> lpad(pNota, 9, '0') Then
                  pMessage := PMessage || 'Coleta ' || vColeta ||
                              ' somente podera ser usando com a Nota ASN ' ||
                              substr(vNumeroNotaASN, 1, 9) ||
                              ' Nota DIGITADA ' || lpad(pNota, 9, '0');
                  pStatus  := 'E';
                End If;
              End If;
            
            End If;
          
          END IF;
        
          Begin
            vLinha := '09';
            select distinct co.arm_coletapart_tipofrete
              into vXMLIncoterms
            --                   from t_xml_coleta co
              from tdvadm.t_arm_coletapart co
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo
            --                     and co.xml_coleta_numero = vASN
            --                     and co.xml_coleta_tipodoc = 'ASN'
            --                     and co.xml_coleta_gravado = 'CVRD'
            --                     and co.xml_coleta_status in ('OK','AR')
            ;
          Exception
            When NO_DATA_FOUND Then
              vXMLIncoterms := null;
          End;
        
          If (vCTe IS NULL) and (vXMLIncoterms is not null) Then
          
            if (vEntCol = 'C') and (nvl(vXMLIncoterms, 'FCA') = 'FCA') and
               (vASN is not null) Then
              -- Ocorreu uma Solicitac?o errada da Vale onde as ASN sairam como entrega mais era PORTO ou AEROPORTO
              select count(*)
                into vAuxiliar
                From t_xml_clientelib cl,
                     --                           T_XML_COLETAPARCEIRO CP,
                     --                           T_XML_COLETA CX
                     tdvadm.t_arm_coletapart cp
               where Cp.ARM_COLETA_NCOMPRA = vColeta
                 AND Cp.ARM_COLETA_CICLO = vCiclo
                 and cl.xml_clientelib_ativo = 'S'
                 and (cl.xml_clientelib_flagporto = 'S' or
                     cl.xml_clientelib_flagaeroporto = 'S')
                    --                        AND CX.XML_COLETA_NUMERO = CP.XML_COLETA_NUMERO
                    --                        AND CX.XML_COLETA_TIPOCOLETA = CP.XML_TIPOPARCEIRO_CODIGO
                    --                        AND CX.XML_COLETA_TIPODOC = CP.XML_COLETA_TIPODOC
                    --                        AND CX.XML_COLETA_SEQUENCIA = CP.XML_COLETA_SEQUENCIA
                 and cl.glb_cliente_cgccpfcodigo =
                     RPAD(CP.ARM_COLETAPART_REMETENTE, 20)
                    --                        AND CP.XML_TIPOPARCEIRO_CODIGO = 'OR'
                    --                        AND CP.XML_COLETA_TIPODOC = 'ASN'
                    --                        and cl.fcf_tpcarga_codigo = ListaCargaCli.ccTPCARGACLIPESQ
                    -- Alterado em 09/10/2015 Sirlano
                    --                        and trim(cl.glb_localidade_codigoori) = trim(decode(trim(cl.glb_localidade_codigoori),'99999','99999',fn_busca_codigoibge1(ListaNotas.cnORIGEM,cl.xml_clientelib_tpcodori)))
                    --                        and trim(cl.glb_localidade_codigodes) = trim(decode(trim(cl.glb_localidade_codigodes),'99999','99999',fn_busca_codigoibge1(ListaNotas.cnDESTINO,cl.xml_clientelib_tpcoddes)))
                 and trim(cl.glb_localidade_codigoori) =
                     trim(decode(trim(cl.glb_localidade_codigoori),
                                 '99999',
                                 '99999',
                                 fn_busca_codigoibge1(vLocOrigemiI,
                                                      cl.xml_clientelib_tpcodori)))
                 and trim(cl.glb_localidade_codigodes) =
                     trim(decode(trim(cl.glb_localidade_codigodes),
                                 '99999',
                                 '99999',
                                 fn_busca_codigoibge1(vLocDestinoI,
                                                      cl.xml_clientelib_tpcoddes)))
                 and cl.xml_clientelib_dtvigencia =
                     (select max(cl1.xml_clientelib_dtvigencia)
                        from t_xml_clientelib cl1
                       where cl1.glb_cliente_cgccpfcodigo =
                             cl.glb_cliente_cgccpfcodigo
                         and cl1.xml_clientelib_ativo =
                             cl.xml_clientelib_ativo
                         and cl1.xml_clientelib_flagporto =
                             cl.xml_clientelib_flagporto
                         and cl1.xml_clientelib_flaggf =
                             cl.xml_clientelib_flaggf
                         and cl1.xml_clientelib_flagaeroporto =
                             cl.xml_clientelib_flagaeroporto
                         and cl1.glb_localidade_codigoori =
                             cl.glb_localidade_codigoori
                         and cl1.xml_clientelib_tpcodori =
                             cl.xml_clientelib_tpcodori
                         and cl1.glb_localidade_codigodes =
                             cl.glb_localidade_codigodes
                         and cl1.xml_clientelib_tpcoddes =
                             cl.xml_clientelib_tpcoddes
                         and cl1.fcf_tpcarga_codigo = cl.fcf_tpcarga_codigo);
              If vAuxiliar = 0 and vArmazem not in ('15', '08') Then
                pMessage := PMessage ||
                            'VALE Informou ENTREGA de Mercadoria. E NOSSA Coleta esta como IR BUSCAR NO CLIENTE' ||
                            chr(10) || 'Coleta    ' || vColeta || chr(10) ||
                            'Coleta TP ' || vEntCol || chr(10) ||
                            'ASN       ' || vASN || chr(10) || 'INCOTERM  ' ||
                            vXMLIncoterms || chr(10);
                pStatus  := 'E';
              End If;
            End If;
            if (vEntCol = 'E') and (nvl(vXMLIncoterms, 'FCA') <> 'FCA') and
               (vASN is not null) Then
              pMessage := PMessage ||
                          'VALE Solicitou para COLETAR Mercadoria. ASN n?o e do TIPO FCA ' ||
                          chr(10) || 'Coleta    ' || vColeta || chr(10) ||
                          'Coleta TP ' || vEntCol || chr(10) ||
                          'ASN       ' || vASN || chr(10) || 'INCOTERM  ' ||
                          vXMLIncoterms || chr(10);
              pStatus  := 'E';
            End If;
          End If;
        End If;
      
      ElsiF (vContrato in ('C2015120020')) Then
        -- MRO-CBA-1215-XXX
/***************************************************************************************************
* DESENVOLVEDOR     : FELIPE DE SOUSA                                                               *
* FUNCIONALIDADE    : Alterado as particularidades conforme solicitado no chamado 92771             *
***************************************************************************************************/
      
        If (vTemExpresso = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO/EXPRESSO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
          update t_arm_nota an
             set an.glb_tpcarga_codigo = 'CD'
           where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia;
      Elsif (trim(vCNPJDest) = trim(vCNPJSac) and vTipoCargaCol not in ('01','14')) Then
           update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
      ElsIF (vContrato = 'C1041226000') Then
        -- 0570 - MRO-TERNIUM-1115-XXX 
      
        -- Se foi solicitado como EXPRESSO, mudo para 01 e Carga Direta
        If (vTemExpresso = 'S') and (vEntCol = 'C') Then
          update tdvadm.t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO/EXPRESSO',
                 co.arm_coleta_entcoleta   = 'C',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
          update t_arm_nota an
             set an.glb_tpcarga_codigo = 'CD'
           where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia;
        
        ElsIf (vTemExpresso = 'S') and (vEntCol = 'E') Then
          update tdvadm.t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO/EXPRESSO',
                 co.arm_coleta_entcoleta   = 'E',
                 co.fcf_tpcarga_codigo     = '12'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
        ElsIf (instr(vAuxiliarT, 'FRACIONADO') > 0) Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO',
                 co.fcf_tpcarga_codigo     = '12'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
        Elsif (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
          update t_arm_nota an
             set an.glb_tpcarga_codigo = 'CD'
           where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia;
        
        ElsIf (vTipoCargaCol = '01') and (vEntCol = 'C') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
          update t_arm_nota an
             set an.glb_tpcarga_codigo = 'CD'
           where an.arm_nota_numero = pNota
             and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
             and trim(an.arm_nota_serie) = trim(pSerie)
             and an.arm_nota_sequencia = vSequencia;
        
        ElsIf (vTipoCargaCol = '20') and (vEntCol = 'E') Then
        
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '39'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
        ElsIf (vTipoCargaCol = '20') Then
        
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO',
                 co.fcf_tpcarga_codigo     = '12'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        
          -- Se foi solicitado como LOTACAO, mudo para 01 e Carga Direta
          -- Se o Usuario Colocou a nota como Carga Direta
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO',
                 co.fcf_tpcarga_codigo     = '12'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
      ElsIF (vContrato in ('RC633618')) Then
        -- '0074' - MRO-VLI-0116-XXX 
        --             Se ja tinha uma Janela muda a mesma.
        If (vTemCD = 'S') Then
          select count(*)
            into vAuxiliar
            from t_arm_coleta co
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '01';
          -- Carga n?o era Carga Direta
          -- Limpa a Janela
        
          If vAuxiliar > 0 Then
          
            update t_arm_nota an
               set an.arm_janelacons_sequencia = null
             where an.arm_nota_numero = pNota
               and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
               and trim(an.arm_nota_serie) = trim(pSerie)
               and an.arm_nota_sequencia = vSequencia;
          
          ElsIf (vContrato in ('RC633618')) Then
            --Insere pedido da coleta na entrada da nota VLI (05/11/2018)
          
            Begin
              select distinct (co.arm_coleta_pedido)
                into Colpedido
                from tdvadm.t_arm_coleta co, tdvadm.t_arm_nota no
               where co.arm_coleta_ncompra = no.arm_coleta_ncompra
                 and co.arm_coleta_ciclo = no.arm_coleta_ciclo
                 and co.arm_coleta_ncompra = vColeta
                 and co.arm_coleta_ciclo = vCiclo
                 and no.xml_notalinha_numdoc is null
                 and rownum = 1;
            
              update tdvadm.t_arm_nota an
                 set an.xml_notalinha_numdoc = Colpedido
               where an.arm_nota_numero = pNota
                 and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
                 and trim(an.arm_nota_serie) = trim(pSerie)
                 and an.arm_nota_sequencia = vSequencia;
            exception
              When NO_DATA_FOUND Then
                Colpedido := null;
            End;
          
          End If;
        
        End If;

/*          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '41'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;*/

          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO/LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo = '01';

      
        If vTipoCargaCol = '02' Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO/LOTACAO',
                 co.fcf_tpcarga_codigo     = '02'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo = '02';
        End If;
      
        -- Testa Se pode ser Dedicao
        -- Procura na Faixa Peso se encontra um Veiculo
        Begin
          vLinha := '10';
          select crv.fcf_tpveiculo_codigo
            into vTipoVeiculo
            from t_slf_cliregrasveic crv
           where crv.glb_cliente_cgccpfcodigo = vSACADO
             and crv.glb_grupoeconomico_codigo = vGrupo
             and crv.slf_contrato_codigo = vContrato
             and crv.fcf_tpcarga_codigo = '15'
             and crv.slf_cliregrasveic_ativo = 'S'
             and tpArmNota.Arm_Nota_Pesobalanca between
                 crv.slf_cliregrasveic_faixai and
                 crv.slf_cliregrasveic_faixaf;
        exception
          When NO_DATA_FOUND Then
            vTipoVeiculo := null;
        End;
      
        -- Achei Veiculo para o Peso
        If (vTipoVeiculo IS NOT NULL) Then
          -- Verifico se e uma transferencia
          select count(*)
            into vAuxiliar
            from t_arm_nota an, t_glb_cliente clr, t_glb_cliente cld
           where trim(an.glb_cliente_cgccpfremetente) =
                 trim(clr.glb_cliente_cgccpfcodigo)
             and trim(an.glb_cliente_cgccpfdestinatario) =
                 trim(cld.glb_cliente_cgccpfcodigo)
             and clr.glb_grupoeconomico_codigo =
                 cld.glb_grupoeconomico_codigo
             and an.arm_nota_sequencia = vSequencia;
          -- E Transferencia do mesmo Grupo rementete e destinatario
          If vAuxiliar > 0 Then
            -- Procura para achar se encontra origem e destino
            select count(*)
              into vAuxiliar
              from t_slf_tabela ta, t_slf_calcfretekm km
             where ta.slf_tabela_codigo = km.slf_tabela_codigo
               and ta.slf_tabela_saque = km.slf_tabela_saque
               and nvl(ta.slf_tabela_status, 'N') = 'N'
                  --                     and ta.fcf_tpveiculo_codigo = vTipoVeiculo
               and ta.fcf_tpcarga_codigo = '15'
               and ta.glb_cliente_cgccpfcodigo = vSACADO
               and ta.glb_grupoeconomico_codigo = vGrupo
               and ta.slf_tabela_contrato = vContrato
               and km.slf_calcfretekm_origemi =
                   tpArmNota.Arm_Nota_Localcoletai
               and km.slf_calcfretekm_destinoi =
                   tpArmNota.Arm_Nota_Localentregai
               and km.slf_reccust_codigo = 'D_FRPSVO';
          
            -- Achei localidade de origem e Destino
            If vAuxiliar > 0 Then
              update t_arm_coleta co
                 set co.arm_coleta_tpcargacalc = 'DEDICADO',
                     co.fcf_tpcarga_codigo     = '15'
               where co.arm_coleta_ncompra = vColeta
                 and co.arm_coleta_ciclo = vCiclo;
              If vTemCD = 'S' Then
                update tdvadm.t_arm_nota an
                   set an.glb_tpcarga_codigo = 'FF'
                 where an.arm_nota_sequencia = vSequencia;
              End If;
            End If;
          End If;
        
        End If;
      ElsIF (vContrato in ('COC91566000')) Then
        -- '0074' - MRO-VLI-0116-XXX 
        --             Se ja tinha uma Janela muda a mesma.
        If (vTemCD = 'S') Then
          select count(*)
            into vAuxiliar
            from t_arm_coleta co
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '01';
          -- Carga n?o era Carga Direta
          -- Limpa a Janela
        
          If vAuxiliar > 0 Then
          
            update t_arm_nota an
               set an.arm_janelacons_sequencia = null
             where an.arm_nota_numero = pNota
               and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
               and trim(an.arm_nota_serie) = trim(pSerie)
               and an.arm_nota_sequencia = vSequencia;
          
          ElsIf (vContrato in ('RC633618')) Then
            --Insere pedido da coleta na entrada da nota VLI (05/11/2018)
          
            Begin
              select distinct (co.arm_coleta_pedido)
                into Colpedido
                from tdvadm.t_arm_coleta co, tdvadm.t_arm_nota no
               where co.arm_coleta_ncompra = no.arm_coleta_ncompra
                 and co.arm_coleta_ciclo = no.arm_coleta_ciclo
                 and co.arm_coleta_ncompra = vColeta
                 and co.arm_coleta_ciclo = vCiclo
                 and no.xml_notalinha_numdoc is null
                 and rownum = 1;
            
              update tdvadm.t_arm_nota an
                 set an.xml_notalinha_numdoc = Colpedido
               where an.arm_nota_numero = pNota
                 and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
                 and trim(an.arm_nota_serie) = trim(pSerie)
                 and an.arm_nota_sequencia = vSequencia;
            exception
              When NO_DATA_FOUND Then
                Colpedido := null;
            End;
          
          End If;
        
        End If;
        If (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO/LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo = '01';
        End IF;
      
        If vTipoCargaCol = '02' Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO/LOTACAO',
                 co.fcf_tpcarga_codigo     = '02'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo = '02';
        End If;
      
        -- Testa Se pode ser Dedicao
        -- Procura na Faixa Peso se encontra um Veiculo
        Begin
          vLinha := '10';
          select crv.fcf_tpveiculo_codigo
            into vTipoVeiculo
            from t_slf_cliregrasveic crv
           where crv.glb_cliente_cgccpfcodigo = vSACADO
             and crv.glb_grupoeconomico_codigo = vGrupo
             and crv.slf_contrato_codigo = vContrato
             and crv.fcf_tpcarga_codigo = '15'
             and crv.slf_cliregrasveic_ativo = 'S'
             and tpArmNota.Arm_Nota_Pesobalanca between
                 crv.slf_cliregrasveic_faixai and
                 crv.slf_cliregrasveic_faixaf;
        exception
          When NO_DATA_FOUND Then
            vTipoVeiculo := null;
        End;
      
        -- Achei Veiculo para o Peso
        If (vTipoVeiculo IS NOT NULL) Then
          -- Verifico se e uma transferencia
          select count(*)
            into vAuxiliar
            from t_arm_nota an, t_glb_cliente clr, t_glb_cliente cld
           where trim(an.glb_cliente_cgccpfremetente) =
                 trim(clr.glb_cliente_cgccpfcodigo)
             and trim(an.glb_cliente_cgccpfdestinatario) =
                 trim(cld.glb_cliente_cgccpfcodigo)
             and clr.glb_grupoeconomico_codigo =
                 cld.glb_grupoeconomico_codigo
             and an.arm_nota_sequencia = vSequencia;
          -- E Transferencia do mesmo Grupo rementete e destinatario
          If vAuxiliar > 0 Then
            -- Procura para achar se encontra origem e destino
            select count(*)
              into vAuxiliar
              from t_slf_tabela ta, t_slf_calcfretekm km
             where ta.slf_tabela_codigo = km.slf_tabela_codigo
               and ta.slf_tabela_saque = km.slf_tabela_saque
               and nvl(ta.slf_tabela_status, 'N') = 'N'
                  --                     and ta.fcf_tpveiculo_codigo = vTipoVeiculo
               and ta.fcf_tpcarga_codigo = '15'
               and ta.glb_cliente_cgccpfcodigo = vSACADO
               and ta.glb_grupoeconomico_codigo = vGrupo
               and ta.slf_tabela_contrato = vContrato
               and km.slf_calcfretekm_origemi =
                   tpArmNota.Arm_Nota_Localcoletai
               and km.slf_calcfretekm_destinoi =
                   tpArmNota.Arm_Nota_Localentregai
               and km.slf_reccust_codigo = 'D_FRPSVO';
          
            -- Achei localidade de origem e Destino
            If vAuxiliar > 0 Then
              update t_arm_coleta co
                 set co.arm_coleta_tpcargacalc = 'DEDICADO',
                     co.fcf_tpcarga_codigo     = '15'
               where co.arm_coleta_ncompra = vColeta
                 and co.arm_coleta_ciclo = vCiclo;
              If vTemCD = 'S' Then
                update tdvadm.t_arm_nota an
                   set an.glb_tpcarga_codigo = 'FF'
                 where an.arm_nota_sequencia = vSequencia;
              End If;
            End If;
          End If;
        
        End If;
      
        --------------------------------------------------------------
        ----Particularidades abaixo alteradas 04/06/2019--------------
        ----------Conforme solicitac?o do faturamento-----------------
        ------------Rafael Aiti e Victor Casagrandi-------------------
        --------------------------------------------------------------
      
      ElsIf (vContrato in ('C4600005946', -- MRO-ALUNORTE-1116-XXX
                           'C2017010106', -- MRO-ALBRAS-0117-XXX
                           'C4600005947') -- -- MRO-HYDRO-1216-XXX 
            ) Then
      
        if (vTemExpresso = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'EXPRESSO',
                 co.fcf_tpcarga_codigo     = '03'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Elsif (vTemQuimico = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'QUIMICO',
                 co.fcf_tpcarga_codigo     = '04'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
        ---------Negado conforme solicitac?o do faturamento----
        ------------------Rafael Aiti 09/07/2019---------------
      
        /*             ElsIf   (vContrato = 'C4600005947') -- MRO-HYDRO-1216-XXX 
                                            Then
        
        If ( vTemCD = 'S' ) and ( vTemExpresso = 'N' ) Then
           update t_arm_coleta co
              set co.arm_coleta_tpcargacalc = 'LOTACAO',
                  co.fcf_tpcarga_codigo = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        ElsIf ( vTemExpresso = 'S' ) Then
           update t_arm_coleta co
              set co.arm_coleta_tpcargacalc = 'EXPRESSO',
                  co.fcf_tpcarga_codigo = '03'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Elsif ( vTemQuimico = 'S' ) Then
           update t_arm_coleta co
              set co.arm_coleta_tpcargacalc = 'QUIMICO',
                  co.fcf_tpcarga_codigo = '04'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        ElsIf ( vTipoCarga = 'CU' ) Then
           update t_arm_coleta co
              set co.arm_coleta_tpcargacalc = 'CUBADA',
                  co.fcf_tpcarga_codigo = '27'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        ElsIf ( vTipoCarga = 'FF' ) Then
           update t_arm_coleta co
              set co.arm_coleta_tpcargacalc = 'FRACIONADO',
                  co.fcf_tpcarga_codigo = '02'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If; */
      
      ElsIf (vContrato in ('C4500354042', -- MRO-USIMINAS-MA-0916-XXX
                           'C4600005185') -- MRO-USIMINAS-PA-0516-XXX
            ) Then
      
        If (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
      ElsIF (vContrato in ('C2013060061', -- LOT-VOTORANTIM-0613-SULFATO
                         --'C2016020026', -- MRO-VOTORANTIM-0216-ENERGIA (Retirado por Vinicius Dantas 07/02/2022 Solicitado pela Ingred.)
                           'C2015120024', -- LOT-VOTORANTIM-1215-CIMENTOS
                           'C2016080025') -- MRO-VOTORANTIM-0816-ZINCO
            ) Then
      
        If (vTemExpresso = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        end if;
      
      -- Condic?es abaixo negadas conforme ticket 114835 a pedido do faturamento.
      
/*        If (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO',
                 co.fcf_tpcarga_codigo     = '02'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
*/      ElsIF (vContrato in ('C2017020107')) Then
        -- MRO-PRADA-0317-XXX
        update t_arm_coleta co
           set co.arm_coleta_tpcargacalc = 'LOTACAO',
               co.fcf_tpcarga_codigo     = '01'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
      
/*  Vinicius Dantas Retirado por solicitação da barbara 04/02/2022  
   Elsif (vContrato in ('C2017070112')) Then
        -- NESTLE
        update t_arm_coleta co
           set co.arm_coleta_tpcargacalc = 'FACIONADO',
               co.fcf_tpcarga_codigo     = '24',
               co.fcf_tpveiculo_codigo   = '9'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;*/
      Elsif (vContrato in ('C2017080112')) Then
        -- ARLANXEO
      
        if (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
      ElsIf (vContrato = 'C2017110116') Then
        --  0626 - ALCOA WORLD ALUMINA BRASIL LTDA
      
        If vLocDestino in ('05571' -- Armazem SP
                           ) Then
          If (vGrupoSac = vGrupoRem) and (vGrupoSac <> vGrupoDest) Then
            Update tdvadm.t_arm_nota an
               set an.glb_tpcarga_codigo = 'RP'
             where an.arm_nota_sequencia = vSequencia;
            vTemReparo := 'S';
          Else
            Update tdvadm.t_arm_nota an
               set an.glb_tpcarga_codigo = 'CO'
             where an.arm_nota_sequencia = vSequencia;
            vTipoCArga := 'CO';
          
          End If;
        End If;
      
        If (vTemExpresso = 'S') and (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO/EXPRESSO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        ElsIf (vTemExpresso = 'S') and (vTemCD <> 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO/EXPRESSO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.fcf_tpcarga_codigo <> '01'
             and co.arm_coleta_ciclo = vCiclo;
        
        ElsIf (vTemReparo = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'REPARO',
                 co.fcf_tpcarga_codigo     = '06'
           where co.arm_coleta_ncompra = vColeta
             and co.fcf_tpcarga_codigo <> '01'
             and co.arm_coleta_ciclo = vCiclo;
        
        ElsIF vTipoCarga = 'CO' Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'COLETA',
                 co.fcf_tpcarga_codigo     = '20'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '01';
        ElsIf (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO/LOTACAO',
                 co.fcf_tpcarga_codigo     = '02'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo not in ('20', '01');
        End If;
        
        --Particularidades abaixo da Suzano negadas a pedido do faturamento dia 16/12
        --Teste sera realizado para entrar em produc?o dia 06/01/2020
        --Rafael Aiti 16/12/2019
      
/*      ElsIf (vContrato = 'C2018010117') Then
        --  0541 - MRO-SUZANO IMPERATRIZ-0118-XXX
        If vLocDestino in ('05571' -- Armazem SP
                           ) Then
          Update tdvadm.t_arm_nota an
             set an.glb_tpcarga_codigo = 'CO'
           where an.arm_nota_sequencia = vSequencia;
          vTipoCArga := 'CO';
        End If;
      
        Begin
          select distinct cd.arm_carregamento_codigo
            into vCarregamento
            from tdvadm.t_arm_nota an, tdvadm.t_arm_carregamentodet cd
           where an.arm_embalagem_numero = cd.arm_embalagem_numero
             and an.arm_embalagem_flag = cd.arm_embalagem_flag
             and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
             and an.arm_nota_sequencia = vSequencia;
        exception
          When NO_DATA_FOUND Then
            vCarregamento := null;
        End;
      
        select count(distinct an.arm_nota_localentregai)
          into vAuxiliar
          from tdvadm.t_arm_nota an, tdvadm.t_arm_carregamentodet cd
         where an.arm_embalagem_numero = cd.arm_embalagem_numero
           and an.arm_embalagem_flag = cd.arm_embalagem_flag
           and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
           and an.slf_contrato_codigo = vContrato
           and cd.arm_carregamento_codigo = vCarregamento;
      
        If vAuxiliar > 1 Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADO RE',
                 co.fcf_tpcarga_codigo     = '12'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '20';
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '20';
        End If;
      
        IF vTipoCarga = 'CO' Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'COLETA',
                 co.fcf_tpcarga_codigo     = '20'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
      ElsIf (vContrato = 'C2018010117/4') Then
        --  0634 - MRO-SUZANO LIMEIRA-XXX
        If vLocDestino in ('05571' -- Armazem SP
                           ) Then
          Update tdvadm.t_arm_nota an
             set an.glb_tpcarga_codigo = 'CO'
           where an.arm_nota_sequencia = vSequencia;
          vTipoCArga := 'CO';
        End If;
      
        IF vTipoCarga <> 'CO' Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '20';
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'COLETA',
                 co.fcf_tpcarga_codigo     = '20'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
        --              If nvl(vPedido,'X') = 'X' Then
        --                 pStatus := 'E';
        --                 pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
        --              End If;
      
      ElsIf (vContrato = 'C2018010117/2') Then
        --  0541-MRO-SUZANO MUCURI-0118-XXX
        \*  desativado em 09/11/2018 Sirlano
                      IF vTipoCarga <> 'CO' Then  
                         update t_arm_coleta co
                             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                                 co.fcf_tpcarga_codigo = '11'
                         where co.arm_coleta_ncompra = vColeta
                           and co.arm_coleta_ciclo = vCiclo
                           and co.fcf_tpcarga_codigo <> '20';
                      Else
                        update t_arm_coleta co
                            set co.arm_coleta_tpcargacalc = 'COLETA',
                                co.fcf_tpcarga_codigo = '20'
                        where co.arm_coleta_ncompra = vColeta
                          and co.arm_coleta_ciclo = vCiclo;
                      End If;
        *\
        If vLocDestino in ('05571', -- Armazem SP
                           '29132' -- Armazem ES - Viana
                           ) Then
          Update tdvadm.t_arm_nota an
             set an.glb_tpcarga_codigo = 'CO'
           where an.arm_nota_sequencia = vSequencia;
          vTipoCArga := 'CO';
        End If;
      
        IF vTipoCarga = 'CO' Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'COLETA',
                 co.fcf_tpcarga_codigo     = '20'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Else
          Begin
            select distinct cd.arm_carregamento_codigo
              into vCarregamento
              from tdvadm.t_arm_nota an, tdvadm.t_arm_carregamentodet cd
             where an.arm_embalagem_numero = cd.arm_embalagem_numero
               and an.arm_embalagem_flag = cd.arm_embalagem_flag
               and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
               and an.arm_nota_sequencia = vSequencia;
          
            select count(distinct an.arm_nota_localentregai)
              into vAuxiliar
              from tdvadm.t_arm_nota an, tdvadm.t_arm_carregamentodet cd
             where an.arm_embalagem_numero = cd.arm_embalagem_numero
               and an.arm_embalagem_flag = cd.arm_embalagem_flag
               and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
               and an.slf_contrato_codigo = vContrato
               and cd.arm_carregamento_codigo = vCarregamento;
          
            If vAuxiliar > 1 Then
              update t_arm_coleta co
                 set co.arm_coleta_tpcargacalc = 'FRACIONADO RE',
                     co.fcf_tpcarga_codigo     = '12'
               where co.arm_coleta_ncompra = vColeta
                 and co.arm_coleta_ciclo = vCiclo
                 and co.fcf_tpcarga_codigo <> '20';
            Else
              update t_arm_coleta co
                 set co.arm_coleta_tpcargacalc = 'LOTACAO',
                     co.fcf_tpcarga_codigo     = '11'
               where co.arm_coleta_ncompra = vColeta
                 and co.arm_coleta_ciclo = vCiclo
                 and co.fcf_tpcarga_codigo <> '20';
            End If;
          exception
            When NO_DATA_FOUND Then
              -- pode n?o achar o carregamento durante a digitacao da nota
              vCarregamento := '';
          end;
        End If;
      
        select count(*)
          into vAuxiliar
          from tdvadm.t_arm_nota an, tdvadm.t_arm_carregamentodet cd
         where an.arm_embalagem_numero = cd.arm_embalagem_numero
           and an.arm_embalagem_flag = cd.arm_embalagem_flag
           and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
           and an.arm_nota_sequencia = vSequencia;
      
        --              If ( nvl(vCodCliViagem,'X') = 'X' ) and ( vAuxiliar > 0 ) Then
        --                 pStatus := 'E';
        --                 pMessage := pMessage || chr(10) || 'Codigo da DT para a VIAGEM, n?o informado para a NOTA [' || pNota || '-' || pCNPJ || '] !';
        --              End If;
      
        If vEntCol = 'C' and nvl(vCentroCusto, 'X') <> 'X' Then
          update tdvadm.t_arm_nota an
             set an.arm_nota_codclicoleta = vCentroCusto
           where an.arm_coleta_ncompra = vColeta
             and an.arm_coleta_ciclo = vCiclo;
          --              ElsIf vEntCol = 'C' and nvl(vCentroCusto,'X') = 'X' Then
          --                 pStatus := 'E';
          --                 pMessage := pMessage || chr(10) || 'Codigo da DT no campo CENTRO DE CUSTO, n?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
        ElsIf vEntCol = 'E' Then
          update tdvadm.t_arm_nota an
             set an.arm_nota_codclicoleta = null
           where an.arm_coleta_ncompra = vColeta
             and an.arm_coleta_ciclo = vCiclo;
        End If;
      
      ElsIf (vContrato = 'C2018010117/3') Then
        --  0541-MRO-SUZANO SP-0118-XXX
        If vLocDestino in ('05571' -- Armazem SP
                           ) Then
          Update tdvadm.t_arm_nota an
             set an.glb_tpcarga_codigo = 'CO'
           where an.arm_nota_sequencia = vSequencia;
          vTipoCArga := 'CO';
        End If;
      
        IF vTipoCarga <> 'CO' Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '20';
        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'COLETA',
                 co.fcf_tpcarga_codigo     = '20'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
      
        select count(*)
          into vAuxiliar
          from tdvadm.t_arm_nota an, tdvadm.t_arm_carregamentodet cd
         where an.arm_embalagem_numero = cd.arm_embalagem_numero
           and an.arm_embalagem_flag = cd.arm_embalagem_flag
           and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
           and an.arm_nota_sequencia = vSequencia;
      
        --              If ( nvl(vCodCliViagem,'X') = 'X' ) and ( vAuxiliar > 0 ) Then
        --                 pStatus := 'E';
        --                 pMessage := pMessage || chr(10) || 'Codigo da DT para a VIAGEM, n?o informado para a NOTA [' || pNota || '-' || pCNPJ || '] !';
        --              End If;
      
        If vEntCol = 'C' and nvl(vCentroCusto, 'X') <> 'X' Then
          update tdvadm.t_arm_nota an
             set an.arm_nota_codclicoleta = vCentroCusto
           where an.arm_coleta_ncompra = vColeta
             and an.arm_coleta_ciclo = vCiclo;
          --              ElsIf vEntCol = 'C' and nvl(vCentroCusto,'X') = 'X' Then
          --                 pStatus := 'E';
          --                 pMessage := pMessage || chr(10) || 'Codigo da DT no campo CENTRO DE CUSTO, n?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
        ElsIf vEntCol = 'E' Then
          update tdvadm.t_arm_nota an
             set an.arm_nota_codclicoleta = null
           where an.arm_coleta_ncompra = vColeta
             and an.arm_coleta_ciclo = vCiclo;
        End If;*/
      
      ElsIf (vContrato in ('C46000006358') -- MRO-CAP-0817-XXX
            ) Then
      
        If (vTemCD = 'S') and (vTemExpresso = 'N') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        ElsIf (vTemExpresso = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'EXPRESSO',
                 co.fcf_tpcarga_codigo     = '03'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        Elsif (vTemQuimico = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'QUIMICO',
                 co.fcf_tpcarga_codigo     = '04'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        ElsIf (vTipoCarga = 'CU') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'CUBADA',
                 co.fcf_tpcarga_codigo     = '27'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        ElsIf (vTipoCarga = 'FF') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'FRACIONADA',
                 co.fcf_tpcarga_codigo     = '02'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;
        End If;
        
      ElsIf vContrato = 'C4600005631' then  -- MRO-PARANAPANEMA-0820-XXX


       If nvl(vPedidoColeta,'X') = 'X' Then       
          pStatus := 'E';
          pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
       End If;      
        
    
      
      ElsIf (vContrato in ('C4600006653','C7000067442') -- MRO-USI MECANICA-0318-XXX
            ) Then
        If vLocDestino in ('05571', -- Armazem SP
                           '32001', -- Armazem MG
                           '20001' -- Armazem RJ
                           ) Then
                           
        if vTemReparo = 'N' then  
          
            Update tdvadm.t_arm_nota an
               set an.glb_tpcarga_codigo = 'CO'
             where an.arm_nota_sequencia = vSequencia;
             
            update t_arm_coleta co
               set co.arm_coleta_tpcargacalc = 'COLETA',
                   co.fcf_tpcarga_codigo     = '20'
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo
               and co.fcf_tpcarga_Codigo <> '01';
        else
          
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'REPARO',
                 co.fcf_tpcarga_codigo     = '06'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo <> '01';  
               
        end if;    

        End If;
      
        If (vTemCD = 'S') Then
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '01'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo;

        Else
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo NOT IN
                 ('06', -- REPARO
                  '20',
                  '01'); -- COLETA
        End If;
      
        IF (vGrupoRem = vGrupo) and (nvl(vDtColeta, 'X') = 'X') Then
          pStatus  := 'W';
          pMessage := pMessage || chr(10) ||
                      'Codigo da DT não informado na COLETA [' ||
                      vColeta || '-' || vCiclo || '] !';
        Else
          update tdvadm.t_arm_nota an
             set an.arm_nota_codclicoleta = vDtColeta --campo anterior vCentroCusto 18/01/2022 Rezende
           where an.arm_coleta_ncompra = vColeta
             and an.arm_coleta_ciclo = vCiclo;
        End If;
        
          -- Sirlano
          -- 14/12/2020 - Para n?o rodar sem querer no TDP
          If vDB_NAME = 'TDH' Then
                -- Alterado somente no TDX a pedido do faturamento 05/10/2020 - chamado 166060
          update t_arm_coleta co
             set co.arm_coleta_tpcargacalc = 'LOTACAO',
                 co.fcf_tpcarga_codigo     = '11'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo = '12';
         End If; 
        
      Elsif vContrato in ('C2019071135') --BIOSEV || Rafael Aiti || 14/10/2019
                                         Then  
            
       if (vTemQuimico = 'S') and (vTipoCargaCol in ('34','33')) Then
         
         update tdvadm.t_arm_coleta co
            set co.arm_coleta_tpcargacalc = 'LOTACAO/QUIMICO'
          where co.arm_coleta_ncompra = vColeta
            and co.arm_coleta_ciclo = vCiclo;
            
         update tdvadm.t_arm_coleta co
            set co.arm_coleta_tpcargacalc = 'LOTACAO/QUIMICO'
          where co.arm_coleta_ncompra = vColeta
            and co.arm_coleta_ciclo = vCiclo;
       
       end if;
       
       if (vTemQuimico = 'N') and (vTipoCargaCol in ('34','33')) Then
       
         update tdvadm.t_arm_coleta co
            set co.arm_coleta_tpcargacalc = 'LOTACAO/EXPRESSO'
          where co.arm_coleta_ncompra = vColeta
            and co.arm_coleta_ciclo = vCiclo
            and co.fcf_tpcarga_codigo = '34';
            
         update tdvadm.t_arm_coleta co
            set co.arm_coleta_tpcargacalc = 'LOTACAO/EXPRESSO'
          where co.arm_coleta_ncompra = vColeta
            and co.arm_coleta_ciclo = vCiclo
            and co.fcf_tpcarga_codigo = '33';  
       
       end if;
       If ( nvl(vPedidoColeta,'X') = 'X' ) and  -- N?o tenho pedido na Coleta
          ( nvl(vPedidoNota,'X') <> 'X' ) Then  -- Tenho pedido na Nota
        -- Atualizao o Pedido da Nota no Banco
        update tdvadm.t_arm_coleta co
           set co.arm_coleta_pedido = vPedidoNota
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
        -- Atualizo a variavel de Pedido da Coleta com Variavel de3 Pedido da Nota 
         vPedidoColeta := vPedidoNota;
        end if;
        
       If nvl(vPedidoColeta,'X') = 'X' Then       
          pStatus := 'E';
          pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
       End If;
       
      Elsif vContrato in ('C2020030005', -- LOT-CARAIBA-0320-XXX
                          'C2020020004', -- MRO-VALMET-0220-XXX
                          'C2020050006', -- Anglo
                          'C2019120027', -- Anglo
                          'C2020110001', -- NOURYON Adicionado conforme chamado 172932 - Alexandre Malcar 09/11/2020
                          'C2020020002', -- PRADA - PARTICULARIDADE CRIADA DE ACORDO COM O CHAMADO 177105 - ALEXANDRE
                          'C2021020001', -- Adicionado conforme chamado 187683
                          'C2021030006') Then --Contrato Adicionado Conforme Chamado 263799 - 07/02/2022 - Renata Ferreira.  
                                              -- Alexandre Malcar 18/01/2021        

       If ( nvl(vPedidoColeta,'X') = 'X' ) and  -- N?o tenho pedido na Coleta
          ( nvl(vPedidoNota,'X') <> 'X' ) Then  -- Tenho pedido na Nota
        -- Atualizao o Pedido da Nota no Banco
        update tdvadm.t_arm_coleta co
           set co.arm_coleta_pedido = vPedidoNota
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
        -- Atualizo a variavel de Pedido da Coleta com Variavel de3 Pedido da Nota 
         vPedidoColeta := vPedidoNota;
        end if;
        
       If nvl(vPedidoColeta,'X') = 'X' Then       
          pStatus := 'E';
          pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
       End If;
       
       If (vPedidoColeta <> 'X' and length(vPedidoColeta) <> 10 and vContrato = 'C2021020001') Then
         pStatus := 'E';
         pMessage := pMessage || chr(10) || 'O pedido da coleta [' || vColeta || '-' || vCiclo || '] deve conter 10 caracteres!';
       End if;
       
      Elsif vContrato in ('C2019121134')  Then-- MRO-PETROPOLIS-1219-XXX
        
        
       If ( nvl(vPedidoColeta,'X') = 'X' ) and  -- N?o tenho pedido na Coleta
          ( nvl(vPedidoNota,'X') <> 'X' ) Then  -- Tenho pedido na Nota
        -- Atualizao o Pedido da Nota no Banco
        update tdvadm.t_arm_coleta co
           set co.arm_coleta_pedido = vPedidoNota
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
        -- Atualizo a variavel de Pedido da Coleta com Variavel de3 Pedido da Nota 
         vPedidoColeta := vPedidoNota;
        end if;
        
       If nvl(vPedidoColeta,'X') = 'X' Then       
          pStatus := 'E';
          pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
       End If;
       
           
       update tdvadm.t_arm_nota an
          set an.glb_tpcarga_codigo = 'FF'
        where an.arm_nota_numero = pNota
          and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
          and trim(an.arm_nota_serie) = trim(pSerie)
          and an.arm_nota_sequencia = vSequencia;

       --Chamado 120376, 03/02/2020
       
       If vTemExpresso = 'S' Then
         
        update tdvadm.t_arm_coleta co
           set co.arm_coleta_tpcoleta = 'N'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
           
       End If;
       
        /*
       Feito por: Joao Henrique
       Data:17/09/2021
       Para o contrato C2019121134 (Petropolis) na emissao da nota nao ter a opção
       do tipo de carga 41(CARGA DIRETA).
       
       */
      Elsif vContrato in('C2019121134') Then
     if trim(vtemCA) not in('41')Then
             vtemCA := 'FF';
     End if;
    
     update tdvadm.t_arm_nota nf
            set nf.glb_tpcarga_codigo = vTemCA
         where nf.arm_nota_sequencia = vSequencia;
       
          
      ElsIf vContrato in ('C2017060100') Then
        --LOT-BeA-0617-BeA MINERACAO
      
        update tdvadm.t_arm_coleta co
           set co.fcf_tpcarga_codigo = '02'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;

   /*
    FEITO POR: Joao Henrique 
    Data: 04/08/2021 
    Para o contrato abaixo, quando derem entrada na nota para o tipo de carga Avulsa,
     vai ser mudado para  tipo de Carga 42 MILKRUN     
   */
      Elsif vContrato in('C2018010119/2') then -- MR0-RAIZEN-MILKRUN
         -- Testa se a carga da NOTA é AVULSA
         if trim(vTemCA) = 'S' Then
            UPDATE TDVADM.T_ARM_COLETA CO
              SET CO.FCF_TPCARGA_CODIGO = '42', -- MILKRUN
                  co.arm_coleta_tpcargacalc = 'MILK RUN'
            WHERE CO.ARM_COLETA_NCOMPRA = vColeta
              AND CO.ARM_COLETA_CICLO = vCiclo;
         End if;
          
     
      ElsIf vContrato in ('C2018010119') Then -- MRO-RAIZEN-0119-XXX
        -- MRO-RAIZEN-0119-XXX
      
        select count(*)
          into vAuxiliar
          from tdvadm.t_slf_cargascliente cc
         where cc.glb_grupoeconomico_codigo = vGrupo
           and cc.glb_cliente_cgccpfcodigo = rpad(trim(vSACADO), 20)
           and cc.slf_contrato_codigo = vContrato
           and cc.glb_cliente_cgccpfcodigofor = rpad(trim(pCNPJ), 20)
           and cc.slf_cargascliente_vigencia <= trunc(sysdate)
           and cc.slf_cargascliente_ativo = 'S';
      
        If vAuxiliar > 0 Then
          update tdvadm.t_arm_coleta co
             set co.fcf_tpcarga_codigo = '31'
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo = vCiclo
             and co.fcf_tpcarga_codigo = '02';
        Else
          If vTipoCargaCol = '31' Then
            update tdvadm.t_arm_coleta co
               set co.fcf_tpcarga_codigo = '02'
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo;
          End If;
        End If;
      
        If vTemQuimico = 'S' Then
          If vTipoCargaCol = '31' Then
            update tdvadm.t_arm_coleta co
               set co.fcf_tpcarga_codigo = '04'
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo;
          ElsIf vTipoCargaCol = '02' Then
            update tdvadm.t_arm_coleta co
               set co.fcf_tpcarga_codigo = '04'
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo;
          ElsIf vTipoCargaCol = '37' Then
            update tdvadm.t_arm_coleta co
               set co.fcf_tpcarga_codigo = '35'
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo;
          ElsIf vTipoCargaCol = '32' Then
            update tdvadm.t_arm_coleta co
               set co.fcf_tpcarga_codigo = '36'
             where co.arm_coleta_ncompra = vColeta
               and co.arm_coleta_ciclo = vCiclo;
          End If;
        End If;
      
        update tdvadm.t_arm_coleta co
           set co.arm_coleta_tpcargacalc = decode(TRIM(co.fcf_tpcarga_codigo),
                                                  '02',
                                                  'FRACIONADO',
                                                  '04',
                                                  'QUIMICO',
                                                  '31',
                                                  'FRACIONADO',
                                                  '32',
                                                  'FRACIONADO/EXPRESSO',
                                                  '33',
                                                  'LOTACAO/EXPRESSO',
                                                  '34',
                                                  'LOTACAO/EXPRESSO',
                                                  '35',
                                                  'QUIMICO/EXPRESSO',
                                                  '36',
                                                  'QUIMICO/EXPRESSO',
                                                  '37',
                                                  'FRACIONADO/EXPRESSO',
                                                  '38',
                                                  'LOTACAO',
                                                  co.arm_coleta_tpcargacalc)
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
          
/*      Elsif vContrato in ('C2020070004') Then --LOT-GE-0720-XXX
        \*
          Alexandre Malcar 28/07/2020
        *\        
        If nvl(vPedido,'X') = 'X' Then
       
             select an.xml_notalinha_numdoc
               into vPedidonota
               from tdvadm.t_arm_nota an
               where an.arm_nota_numero = pNota
                 and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
                 and trim(an.arm_nota_serie) = trim(pSerie)
                 and an.arm_nota_sequencia = vSequencia;
                 
           vPedido := vPedidonota;
           
        update tdvadm.t_arm_coleta co
           set co.arm_coleta_pedido = vPedido
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
           
        end if;
        
       If nvl(vPedido,'X') = 'X' Then       
          pStatus := 'E';
          pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na COLETA [' || vColeta || '-' || vCiclo || '] !';
       End If;*/
       
           -- Sirlano
           -- 22/03/2021
           -- Chamado  #198416 criacao da particularidade
      Elsif vContrato in ('C2021030006') Then --MRO-ULTRACARGO-0321-XXX
         If nvl(vPedidoColeta,'X') = 'X' Then
            Select co.arm_coleta_pedido
              into vPedidoColeta
            from tdvadm.t_arm_coleta co
            where co.arm_coleta_ncompra = vColeta
              and co.arm_coleta_ciclo = vCiclo;
         End If;
            
         If vCentroCusto is Null Then
            update tdvadm.t_arm_nota an
              set an.xml_notalinha_numdoc = vPedidoColeta
            where an.arm_nota_sequencia = vSequencia;
         Else
            update tdvadm.t_arm_nota an
              set an.xml_notalinha_numdoc = trim(vPedidoColeta)  || ' / ' || trim(vCentroCusto)
            where an.arm_nota_sequencia = vSequencia;
         End If;
      
      /***********************************************
       Data 12/04/2021 feito por Jo?o Henrique Pacheco dos Reis
       
       Para esse grupo 0709 com as determinadas localidades usa-se C2021010007/2.
       Caso contrario usa-se o contrato C2021010007
      
       Data 16/06/2021 Vinicius Dantas
       
       Alterei de localidade Origem para destino conforme solicitado pelo Andre
       
       Rezende - Retirei esta particularidade #292942
      ***********************************************/
      /*
      Elsif vGrupoSac = '0709' Then  -- Grupo economico NORTEL
         if vLocDestino in ('25600', -- RJ-PETROPOLIS
                           '25950', -- RJ-TERESOPOLIS
                           '48100' -- BA-ALAGOINHAS
                           --'53700' -- PE-ITAPISSUMA / Rezende - Tirei o destino #288168
                            ) Then
            vContrato := 'C2021010007/2';
         else
           vContrato := 'C2021010007';
         end if ;
         
         update tdvadm.t_arm_nota nf
            set nf.slf_contrato_codigo = vContrato
         where nf.arm_nota_sequencia = vSequencia;
         
         update tdvadm.t_arm_coleta co
            set co.slf_contrato_codigo = vContrato
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo;
        */
     --Vinicius Dantas C2021060003 08/07/2021 obrigatoriedade pedido nota
     
      ElsIf vContrato in ('C2021060003') Then-- SOLTEC
        
         If nvl(vPedidonota,'X') = 'X' Then       
            pStatus := 'E';
            pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na NOTA [' || pNota || '-' || pCNPJ || '-' || pSerie ||'] !';
         End If;
       
         If nvl(vPedidoColeta,'X') = 'X' Then       
            pStatus := 'E';
            pMessage := pMessage || chr(10) || 'Pedido Obrigatorio para este Contrato. N?o informado na Coleta [' || vColeta || '-' || vCiclo || '] !';
         End If;     
      

  
      Else
        -- Demais contratos vContrato = '999999' Then
        update t_arm_coleta co
           set co.arm_coleta_tpcargacalc = 'FRACIONADO',
               co.fcf_tpcarga_codigo     = '02',
               co.fcf_tpveiculo_codigo   = '9'
         where co.arm_coleta_ncompra = vColeta
           and co.arm_coleta_ciclo = vCiclo
           and co.fcf_tpcarga_codigo is null;
      End If;
    
      update tdvadm.t_arm_coleta co
         set co.arm_coleta_flagquimico = vTemQuimico
       where co.arm_coleta_ncompra = vColeta
         and co.arm_coleta_ciclo = vCiclo
         and nvl(co.arm_coletaorigem_cod, 0) <> 8;
    End If;
  
    if ((vJanela is null) and (vTabSol is not null)) OR
       (vContrato in ('C5900011012', 'C2014030105') AND
       (vTemExpresso = 'S')) or -- MRO-VALE-0314-CS2781910 e MRO-VALE MANGANES-0314-CS2781910/M
       (vContrato in ('C5900011012', 'C2014030105') AND
       (instr(vAuxiliarT, 'LOTACAO') > 0)) Then
      -- MRO-VALE-0314-CS2781910 e MRO-VALE MANGANES-0314-CS2781910/M
      SP_INFORMACLIENTE(pNota,
                        pCNPJ,
                        pSerie,
                        vArmazem,
                        vUsuario,
                        'E',
                        pStatus,
                        pMessage);
    End If;
  
  exception
    WHEN OTHERS Then
    
      pStatus  := 'E';
      pMessage := vLinha || '-' || vTipoCarga || '-' || pMessage || '-' ||
                  sqlerrm;
    
  End SP_SETPARTCONTRATO;

  PROCEDURE SP_SETPARTCONTRATO2(pNota  in tdvadm.t_arm_nota.arm_nota_numero%type,
                                pCNPJ  in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                                pSerie in tdvadm.t_arm_nota.arm_nota_serie%type) As
    vStatus  char(1);
    vMessage varchar2(1000);
  Begin
    SP_SETPARTCONTRATO(pNota, pCNPJ, pSerie, vStatus, vMessage);
  
  End SP_SETPARTCONTRATO2;

  -- Funcao usada para achar uma regra de contrato
  FUNCTION FN_SLF_CLIENTEREGRACARGA(P_CNPJ     IN T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                    P_CONTRATO IN T_ARM_NOTA.SLF_CONTRATO_CODIGO%TYPE DEFAULT QualquerContrato,
                                    P_GRUPO    IN T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE DEFAULT QualquerGrupo)
    RETURN CHAR IS
  
    V_TIPOACHADO varCHAR2(3) := null;
    V_ACHOU      INTEGER := 0;
    v_CNPJ       t_glb_cliente.glb_cliente_cgccpfcodigo%type;
    V_CONTRATO   T_ARM_NOTA.SLF_CONTRATO_CODIGO%TYPE;
    V_GRUPO      T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE;
  BEGIN
  
    v_CNPJ     := nvl(trim(P_CNPJ), QualquerCliente);
    V_CONTRATO := NVL(trim(P_CONTRATO), QualquerContrato);
  
    If nvl(P_GRUPO, QualquerGrupo) = QualquerGrupo Then
      begin
        if length(trim(v_CNPJ)) = 8 Then
          SELECT min(C.GLB_GRUPOECONOMICO_CODIGO)
            INTO V_GRUPO
            FROM T_GLB_CLIENTE C
           WHERE substr(C.GLB_CLIENTE_CGCCPFCODIGO, 1, 8) = v_CNPJ;
        Else
          SELECT C.GLB_GRUPOECONOMICO_CODIGO
            INTO V_GRUPO
            FROM T_GLB_CLIENTE C
           WHERE C.GLB_CLIENTE_CGCCPFCODIGO = v_CNPJ;
        End If;
      exception
        when NO_DATA_FOUND Then
          V_GRUPO := QualquerGrupo;
      End;
    Else
      V_GRUPO := P_GRUPO;
    End If;
  
    If (V_GRUPO <> QualquerGrupo) and (v_CNPJ <> QualquerCliente) and
       (V_CONTRATO <> QualquerContrato) Then
      SELECT COUNT(*)
        INTO V_ACHOU
        FROM tdvadm.T_SLF_CLIENTEregras CC
       WHERE cc.glb_cliente_cgccpfcodigo = v_CNPJ
         AND CC.SLF_CONTRATO_CODIGO = V_CONTRATO
         AND CC.GLB_GRUPOECONOMICO_CODIGO = V_GRUPO
         and cc.slf_clienteregras_ativo = 'S'
         and cc.slf_clienteregras_vigencia =
             (select max(cc1.slf_clienteregras_vigencia)
                from T_SLF_CLIENTEregras CC1
               where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                 and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
--                 and cc1.fcf_tpcarga_codigo = cc.fcf_tpcarga_codigo
                 and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
--                 and cc1.slf_tpfrete_codigo = cc.slf_tpfrete_codigo
--                 and cc1.fcf_tpcarga_codigopesq = cc.fcf_tpcarga_codigopesq
                 and cc1.slf_clienteregras_pcobranca = cc.slf_clienteregras_pcobranca
                    --                                                    and cc1.slf_clientecargas_fixaorigem  = cc.slf_clientecargas_fixaorigem
                    --                                                    and cc1.slf_clientecargas_fixadestino = cc.slf_clientecargas_fixadestino
                 and cc1.slf_clienteregras_ativo = 'S');
    End If;
  
    If V_ACHOU = 0 Then
    
      If /*( V_GRUPO <> QualquerGrupo) and */
       (v_CNPJ <> QualquerCliente) and (V_CONTRATO <> QualquerContrato) Then
        SELECT COUNT(*)
          INTO V_ACHOU
          FROM tdvadm.T_SLF_CLIENTEregras CC
         WHERE cc.glb_cliente_cgccpfcodigo = v_CNPJ
           AND CC.SLF_CONTRATO_CODIGO = V_CONTRATO
           AND CC.GLB_GRUPOECONOMICO_CODIGO = QualquerGrupo
           and cc.slf_clienteregras_ativo = 'S'
           and cc.slf_clienteregras_vigencia =
             (select max(cc1.slf_clienteregras_vigencia)
                from T_SLF_CLIENTEregras CC1
               where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                 and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
--                 and cc1.fcf_tpcarga_codigo = cc.fcf_tpcarga_codigo
                 and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
--                 and cc1.slf_tpfrete_codigo = cc.slf_tpfrete_codigo
--                 and cc1.fcf_tpcarga_codigopesq = cc.fcf_tpcarga_codigopesq
                 and cc1.slf_clienteregras_pcobranca = cc.slf_clienteregras_pcobranca
                    --                                                    and cc1.slf_clientecargas_fixaorigem  = cc.slf_clientecargas_fixaorigem
                    --                                                    and cc1.slf_clientecargas_fixadestino = cc.slf_clientecargas_fixadestino
                 and cc1.slf_clienteregras_ativo = 'S');
      
        if V_ACHOU > 0 Then
          v_grupo := QualquerGrupo;
        End If;
      End IF;
    
    End If;
  
    If V_ACHOU = 0 Then
    
      If (V_GRUPO <> QualquerGrupo) /*and  ( v_CNPJ <> QualquerCliente)*/
         and (V_CONTRATO <> QualquerContrato) Then
        SELECT COUNT(*)
          INTO V_ACHOU
          FROM T_SLF_CLIENTEregras CC
         WHERE cc.glb_cliente_cgccpfcodigo = QualquerCliente
           AND CC.SLF_CONTRATO_CODIGO = V_CONTRATO
           AND CC.GLB_GRUPOECONOMICO_CODIGO = V_GRUPO
           and cc.slf_clienteregras_ativo = 'S'
           and cc.slf_clienteregras_vigencia =
             (select max(cc1.slf_clienteregras_vigencia)
                from T_SLF_CLIENTEregras CC1
               where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                 and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
--                 and cc1.fcf_tpcarga_codigo = cc.fcf_tpcarga_codigo
                 and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
--                 and cc1.slf_tpfrete_codigo = cc.slf_tpfrete_codigo
--                 and cc1.fcf_tpcarga_codigopesq = cc.fcf_tpcarga_codigopesq
                 and cc1.slf_clienteregras_pcobranca = cc.slf_clienteregras_pcobranca
                    --                                                    and cc1.slf_clientecargas_fixaorigem  = cc.slf_clientecargas_fixaorigem
                    --                                                    and cc1.slf_clientecargas_fixadestino = cc.slf_clientecargas_fixadestino
                 and cc1.slf_clienteregras_ativo = 'S');
      
        if V_ACHOU > 0 Then
          v_CNPJ := QualquerCliente;
        End If;
      End IF;
    
    End If;
  
    If V_ACHOU = 0 Then
    
      If (V_GRUPO <> QualquerGrupo) and (v_CNPJ <> QualquerCliente) /*and ( V_CONTRATO <> QualquerContrato )*/
       Then
        SELECT COUNT(*)
          INTO V_ACHOU
          FROM tdvadm.T_SLF_CLIENTEregras CC
         WHERE cc.glb_cliente_cgccpfcodigo = v_CNPJ
           AND CC.SLF_CONTRATO_CODIGO = QualquerContrato
           AND CC.GLB_GRUPOECONOMICO_CODIGO = V_GRUPO
           and cc.slf_clienteregras_ativo = 'S'
           and cc.slf_clienteregras_vigencia =
             (select max(cc1.slf_clienteregras_vigencia)
                from T_SLF_CLIENTEregras CC1
               where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                 and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
--                 and cc1.fcf_tpcarga_codigo = cc.fcf_tpcarga_codigo
                 and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
--                 and cc1.slf_tpfrete_codigo = cc.slf_tpfrete_codigo
--                 and cc1.fcf_tpcarga_codigopesq = cc.fcf_tpcarga_codigopesq
                 and cc1.slf_clienteregras_pcobranca = cc.slf_clienteregras_pcobranca
                    --                                                    and cc1.slf_clientecargas_fixaorigem  = cc.slf_clientecargas_fixaorigem
                    --                                                    and cc1.slf_clientecargas_fixadestino = cc.slf_clientecargas_fixadestino
                 and cc1.slf_clienteregras_ativo = 'S');
      
        if V_ACHOU > 0 Then
          V_CONTRATO := QualquerContrato;
        End If;
      End IF;
    
    End If;
  
    If V_ACHOU = 0 Then
    
      If (V_GRUPO <> QualquerGrupo) /*and  ( v_CNPJ <> QualquerCliente)  and ( V_CONTRATO <> QualquerContrato )*/
       Then
        SELECT COUNT(*)
          INTO V_ACHOU
          FROM tdvadm.T_SLF_CLIENTEregras CC
         WHERE cc.glb_cliente_cgccpfcodigo = QualquerCliente
           AND CC.SLF_CONTRATO_CODIGO = QualquerContrato
           AND CC.GLB_GRUPOECONOMICO_CODIGO = V_GRUPO --QualquerGrupo
           and cc.slf_clienteregras_ativo = 'S'
           and cc.slf_clienteregras_vigencia =
             (select max(cc1.slf_clienteregras_vigencia)
                from T_SLF_CLIENTEregras CC1
               where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                 and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
--                 and cc1.fcf_tpcarga_codigo = cc.fcf_tpcarga_codigo
                 and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
--                 and cc1.slf_tpfrete_codigo = cc.slf_tpfrete_codigo
--                 and cc1.fcf_tpcarga_codigopesq = cc.fcf_tpcarga_codigopesq
                 and cc1.slf_clienteregras_pcobranca = cc.slf_clienteregras_pcobranca
                    --                                                    and cc1.slf_clientecargas_fixaorigem  = cc.slf_clientecargas_fixaorigem
                    --                                                    and cc1.slf_clientecargas_fixadestino = cc.slf_clientecargas_fixadestino
                 and cc1.slf_clienteregras_ativo = 'S');
      
        if V_ACHOU > 0 Then
          --               V_GRUPO    := QualquerGrupo ;
          v_CNPJ     := QualquerCliente;
          V_CONTRATO := QualquerContrato;
        End If;
      End IF;
    
    End If;
  
    If V_ACHOU = 0 Then
    
      If /*( V_GRUPO <> QualquerGrupo) and*/
       (v_CNPJ <> QualquerCliente) /*and ( V_CONTRATO <> QualquerContrato )*/
       Then
        SELECT COUNT(*)
          INTO V_ACHOU
          FROM tdvadm.T_SLF_CLIENTEregras CC
         WHERE cc.glb_cliente_cgccpfcodigo = v_CNPJ --QualquerCliente
           AND CC.SLF_CONTRATO_CODIGO = QualquerContrato
           AND CC.GLB_GRUPOECONOMICO_CODIGO = QualquerGrupo
           and cc.slf_clienteregras_ativo = 'S'
           and cc.slf_clienteregras_vigencia =
             (select max(cc1.slf_clienteregras_vigencia)
                from T_SLF_CLIENTEregras CC1
               where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                 and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
--                 and cc1.fcf_tpcarga_codigo = cc.fcf_tpcarga_codigo
                 and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
--                 and cc1.slf_tpfrete_codigo = cc.slf_tpfrete_codigo
--                 and cc1.fcf_tpcarga_codigopesq = cc.fcf_tpcarga_codigopesq
                 and cc1.slf_clienteregras_pcobranca = cc.slf_clienteregras_pcobranca
                    --                                                    and cc1.slf_clientecargas_fixaorigem  = cc.slf_clientecargas_fixaorigem
                    --                                                    and cc1.slf_clientecargas_fixadestino = cc.slf_clientecargas_fixadestino
                 and cc1.slf_clienteregras_ativo = 'S');
      
        if V_ACHOU > 0 Then
          V_GRUPO := QualquerGrupo;
          --               v_CNPJ     := QualquerCliente;
          V_CONTRATO := QualquerContrato;
        End If;
      End IF;
    
    End If;
  
    If V_ACHOU = 0 Then
    
      If /*( V_GRUPO <> QualquerGrupo) and  ( v_CNPJ <> QualquerCliente)  and*/
       (V_CONTRATO <> QualquerContrato) Then
        SELECT COUNT(*)
          INTO V_ACHOU
          FROM tdvadm.T_SLF_CLIENTEregras CC
         WHERE cc.glb_cliente_cgccpfcodigo = QualquerCliente
           AND CC.SLF_CONTRATO_CODIGO = V_CONTRATO --QualquerContrato
           AND CC.GLB_GRUPOECONOMICO_CODIGO = QualquerGrupo
           and cc.slf_clienteregras_ativo = 'S'
           and cc.slf_clienteregras_vigencia =
             (select max(cc1.slf_clienteregras_vigencia)
                from T_SLF_CLIENTEregras CC1
               where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                 and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
--                 and cc1.fcf_tpcarga_codigo = cc.fcf_tpcarga_codigo
                 and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
--                 and cc1.slf_tpfrete_codigo = cc.slf_tpfrete_codigo
--                 and cc1.fcf_tpcarga_codigopesq = cc.fcf_tpcarga_codigopesq
                 and cc1.slf_clienteregras_pcobranca = cc.slf_clienteregras_pcobranca
                    --                                                    and cc1.slf_clientecargas_fixaorigem  = cc.slf_clientecargas_fixaorigem
                    --                                                    and cc1.slf_clientecargas_fixadestino = cc.slf_clientecargas_fixadestino
                 and cc1.slf_clienteregras_ativo = 'S');
      
        if V_ACHOU > 0 Then
          V_GRUPO := QualquerGrupo;
          v_CNPJ  := QualquerCliente;
          --               V_CONTRATO := QualquerContrato;
        End If;
      End IF;
    
    End If;
  
    V_TIPOACHADO := NULL;
  
    -- SE ACHOU E CONTRATO DIFERENTE DE CONTRATO GERAL
    If (V_ACHOU = 0) or
       ((V_CONTRATO = QualquerContrato) AND (V_GRUPO = QualquerGrupo) and
       (v_CNPJ = QualquerCliente)) THEN
      V_TIPOACHADO := 'QQQ';
    ELSIF (V_ACHOU > 0) AND (V_CONTRATO <> QualquerContrato) AND
          (V_GRUPO <> QualquerGrupo) and (v_CNPJ <> QualquerCliente) THEN
      V_TIPOACHADO := 'GCT'; -- ACHOU POR GRUPO/CNPJ/CONTRATO
    Elsif (V_ACHOU > 0) AND (V_CONTRATO <> QualquerContrato) AND
          (V_GRUPO <> QualquerGrupo) and (v_CNPJ = QualquerCliente) THEN
      V_TIPOACHADO := 'GT'; -- GRUPO/CONTRATO 
    Elsif (V_ACHOU > 0) AND (V_CONTRATO = QualquerContrato) AND
          (V_GRUPO <> QualquerGrupo) and (v_CNPJ <> QualquerCliente) THEN
      V_TIPOACHADO := 'GC'; -- ACHOU POR GRUPO/CNPJ
    Elsif (V_ACHOU > 0) AND (V_CONTRATO <> QualquerContrato) AND
          (V_GRUPO = QualquerGrupo) and (v_CNPJ <> QualquerCliente) THEN
      V_TIPOACHADO := 'CT'; -- ACHOU POR CNPJ/CONTRATO
    Elsif (V_ACHOU > 0) AND (V_CONTRATO <> QualquerContrato) AND
          (V_GRUPO = QualquerGrupo) and (v_CNPJ = QualquerCliente) THEN
      V_TIPOACHADO := 'T'; -- ACHOU POR CONTRATO
    ELSIF (V_ACHOU > 0) AND (V_CONTRATO = QualquerContrato) AND
          (V_GRUPO <> QualquerGrupo) and (v_CNPJ = QualquerCliente) THEN
      V_TIPOACHADO := 'G'; -- ACHOU POR GRUPO
    ELSIF (V_ACHOU > 0) AND (V_CONTRATO = QualquerContrato) AND
          (V_GRUPO = QualquerGrupo) and (v_CNPJ <> QualquerCliente) THEN
      V_TIPOACHADO := 'C'; -- ACHOU POR CLINETE
    ELSE
      V_TIPOACHADO := 'N'; -- USA O TIPO NORMAL PARA TODOS
    END IF;
    RETURN TRIM(V_TIPOACHADO);
  
  END FN_SLF_CLIENTEREGRACARGA;

  -- Procedure para retornar a Chave das Regras a partir de uma NOTA
  Procedure SP_GETREGRANOTA(pNota        in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCNPJ        in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pSerie       in tdvadm.t_arm_nota.arm_nota_serie%type,
                            pSACADO      out tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type,
                            pGrupo       out tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type,
                            pContrato    out tdvadm.t_slf_clientecargas.slf_contrato_codigo%type,
                            pAgrupamento out tdvadm.t_slf_tpagrupa.slf_tpagrupa_codigo%type)
  
   As
    vRegra    varchar2(10);
    vSACADO   tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type;
    vGrupo    tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type;
    vContrato tdvadm.t_slf_clientecargas.slf_contrato_codigo%type;
  Begin
    Begin
      pSACADO   := '99999999999999';
      pGrupo    := '9999';
      pContrato := '999999999999999';
    
      Select an.glb_cliente_cgccpfsacado,
             cl.glb_grupoeconomico_codigo,
             an.slf_contrato_codigo
        into vSACADO, vGrupo, vContrato
        From t_arm_nota an, t_glb_cliente cl
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and trim(an.arm_nota_serie) = trim(pSerie)
         and rpad(an.glb_cliente_cgccpfsacado, 20) =
             cl.glb_cliente_cgccpfcodigo
         and an.arm_nota_sequencia =
             (select max(an1.arm_nota_sequencia)
                from t_arm_nota an1
               where an1.arm_nota_numero = an.arm_nota_numero
                 and an1.glb_cliente_cgccpfremetente =
                     an.glb_cliente_cgccpfremetente
                 and an1.arm_nota_serie = an.arm_nota_serie);
    Exception
      When OTHERS Then
        pSACADO   := null;
        pGrupo    := null;
        pContrato := null;
    End;
    vRegra := FN_SLF_CLIENTEREGRACARGA(vSACADO, vContrato, vGrupo);
  
    IF vRegra = 'GCT' THEN
      -- ACHOU POR GRUPO/CNPJ/CONTRADO
      pSacado   := vSACADO;
      pGrupo    := vGrupo;
      pContrato := vContrato;
    ELSIF vRegra = 'GC' THEN
      -- ACHOU POR GRUPO/CNPJ
      pSacado   := vSACADO;
      pGrupo    := vGrupo;
      pContrato := QualquerContrato;
    ELSIF vRegra = 'GT' THEN
      -- ACHOU GRUPO/CONTRATO
      pSacado   := QualquerCliente;
      pGrupo    := vGrupo;
      pContrato := vContrato;
    ELSIF vRegra = 'G' THEN
      --ACHOU POR GRUPO
      pSacado   := QualquerCliente;
      pGrupo    := vGrupo;
      pContrato := QualquerContrato;
    ELSIF vRegra = 'C' THEN
      --ACHOU POR CLIENTE
      pSacado   := vSACADO;
      pGrupo    := QualquerGrupo;
      pContrato := QualquerContrato;
    ELSIF vRegra = 'T' THEN
      --ACHOU POR CONTRATO
      pSacado   := QualquerCliente;
      pGrupo    := QualquerGrupo;
      pContrato := vContrato;
    ELSIF vRegra = 'QQQ' THEN
      --POR QUALQUER COISA
      pSacado   := QualquerCliente;
      pGrupo    := QualquerGrupo;
      pContrato := QualquerContrato;
    ELSE
      pSacado   := QualquerCliente;
      pGrupo    := QualquerGrupo;
      pContrato := QualquerContrato;
    END IF;
  
    Begin
      select distinct cc.slf_tpagrupa_codigo
        into pAgrupamento
        from tdvadm.t_slf_clientecargas cc
       where cc.glb_grupoeconomico_codigo = pGrupo
         and cc.glb_cliente_cgccpfcodigo = pSacado
         and cc.slf_contrato_codigo = pContrato
         and cc.slf_clientecargas_ativo = 'S';
    exception
      When OTHERS Then
        pAgrupamento := '00';
    End;
  
  End SP_GETREGRANOTA;

  -- Procedure usada para retornar a qual janela pertence esta nota
  Procedure SP_GETJANELANOTA(pNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJ      in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pSerie     in tdvadm.t_arm_nota.arm_nota_serie%type,
                             pJanelaINI out date,
                             pJanelaFIM out date,
                             pGeraCte   out tdvadm.t_arm_janela.arm_janela_geracte%type) As
    vCarga              tdvadm.t_fcf_tpcarga.fcf_tpcarga_codigo%type;
    vSACADO             tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type;
    vGrupo              tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type;
    vAgrupamento        tdvadm.t_slf_tpagrupa.slf_tpagrupa_codigo%type;
    vContrato           tdvadm.t_slf_clientecargas.slf_contrato_codigo%type;
    vAuxiliar           number;
    vHoraJanela         date;
    vDtBalanca          date;
    vDtEtiqueta         date;
    vDtEtiquetach       varchar2(25);
    vPesoNota           number;
    vControlaJanela     number;
    vExpressa           tdvadm.t_arm_coleta.arm_coleta_tpcoleta%type;
    vErro               varchar2(20000);
    vPesagemObrigatoria Char(1);
    vHoraJanelaTexto    varchar2(100);
    vTabSol             tdvadm.t_arm_nota.arm_nota_tabsolcod%type;
    vCteNota            tdvadm.t_arm_nota.con_conhecimento_codigo%type;
    vDtFechamento       tdvadm.t_arm_coleta.arm_coleta_dtfechamento%type;
    vPesagemFinaliz     tdvadm.t_arm_notapesagem.arm_notapesagem_dtfinalizou%type;
  
  Begin
  
    -- Busca o Tipo da Carga para verificar as Janelas
    Begin
      Select distinct co.fcf_tpcarga_codigo,
                      substr(an.arm_nota_dtetiqueta, 1, 19),
                      nvl(p.arm_notapesagem_dtimprimiu,
                          to_date('01/01/1900', 'dd/mm/yyyy')),
                      an.arm_nota_pesobalanca,
                      co.arm_coleta_tpcoleta,
                      an.arm_nota_tabsolcod,
                      an.con_conhecimento_codigo,
                      co.arm_coleta_dtfechamento,
                      p.arm_notapesagem_dtfinalizou
        into vCarga,
             vDtEtiquetach,
             vDtBalanca,
             vPesoNota,
             vExpressa,
             vTabSol,
             vCteNota,
             vDtFechamento,
             vPesagemFinaliz
        From tdvadm.t_arm_nota        an,
             tdvadm.t_arm_coleta      co,
             tdvadm.t_arm_notapesagem p
       where an.arm_nota_numero = pNota
         and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
         and trim(an.arm_nota_serie) = trim(pSerie)
         and an.arm_coleta_ncompra = co.arm_coleta_ncompra
         and an.arm_coleta_ciclo = co.arm_coleta_ciclo
         and an.arm_nota_chavenfe = p.arm_nota_chavenfe(+)
         and an.arm_nota_sequencia = p.arm_nota_sequencia(+)
         and an.arm_nota_sequencia =
             (select max(an1.arm_nota_sequencia)
                from tdvadm.t_arm_nota an1
               where an1.arm_nota_numero = an.arm_nota_numero
                 and an1.glb_cliente_cgccpfremetente =
                     an.glb_cliente_cgccpfremetente
                    --                                          and an1.arm_coleta_ncompra = an.arm_coleta_ncompra
                    --                                          and an1.arm_coleta_ciclo = an.arm_coleta_ciclo
                 and an1.arm_nota_serie = an.arm_nota_serie
                 and an1.glb_tpcarga_codigo <> 'CO');
      Begin
        if Length(trim(vDtEtiquetach)) > 10 Then
          vDtEtiqueta := to_date(trim(vDtEtiquetach),
                                 'dd/mm/yyyy hh24:mi:ss');
        Else
          vDtEtiqueta := to_date(trim(vDtEtiquetach), 'dd/mm/yyyy');
        End If;
      Exception
        When OTHERS Then
          vDtEtiqueta := to_date('01/01/1900', 'dd/mm/yyyy');
      End;
    
      -- Ajuste para recalcular data de janela do passado
      -- Sirlano 17/05/2019 08:26
      If vDtFechamento is not null Then
        vDtEtiqueta := vDtFechamento;
        vDtBalanca  := vDtFechamento;
      end If;
    
      SP_GETREGRANOTA(pNota,
                      pCNPJ,
                      pSerie,
                      vSACADO,
                      vGrupo,
                      vContrato,
                      vAgrupamento);
    
      If vPesoNota < 3000 Then
        -- Pega qual regra sera usada
      
        select count(*)
          into vAuxiliar
          from tdvadm.t_slf_clienteregras cc
         where cc.glb_grupoeconomico_codigo = vGrupo
           and cc.glb_cliente_cgccpfcodigo = vSACADO
           and cc.slf_contrato_codigo = vContrato
           and cc.slf_clienteregras_pcobranca = 'PB'
           and cc.slf_clienteregras_ativo = 'S';
      
        vPesagemObrigatoria := 'S';
        If vAuxiliar = 0 Then
          vPesagemObrigatoria := 'N';
        End If;
      
      End If;
      vHoraJanela := to_date('01/01/1900', 'dd/mm/yyyy');
   
   
      If vPesoNota > 3000 Then 
        
       -------------------------------------------------------------------------
       -----------------------Rafael Aiti 07/10/2019----------------------------
       --Se foi finalizada pesagem, n?o usa data etiqueta e sim da finalizac?o--
       -------------------------------------------------------------------------
        
        If vDtEtiqueta <> to_date('01/01/1900', 'dd/mm/yyyy') and vPesagemFinaliz is null Then
          vHoraJanela := vDtEtiqueta;
        else
          vHoraJanela := vPesagemFinaliz;
        End If;
      Else
        If (trunc(vDtBalanca) <> to_date('01/01/1900', 'dd/mm/yyyy')) and
           (vPesagemObrigatoria = 'S') Then
          vHoraJanela := vDtBalanca;
          -- erro na pesagem
          If trunc(vHoraJanela) = to_date('30/12/1899', 'dd/mm/yyyy') Then
            pJanelaINI := null;
            pJanelaFIM := null;
            Return;
          End If;
        Else
          If trunc(vDtBalanca) <> to_date('01/01/1900', 'dd/mm/yyyy') Then
            vHoraJanela := vDtBalanca;
          else
            vHoraJanela := sysdate;
          end If;
        End If;
      End If;
    
      iF (vContrato in ('C5900011012', -- 0020 - MRO-VALE-0314-CS2781910
                        'C2014030105', -- 0020 - MRO-VALE MANGANES-0314-CS2781910/M
                        'C5900307551', -- 0020 - LOT-VALE-0915-LOTE 1
                        'C5900307552', -- 0020 - LOT-VALE-0915-LOTE 2
                        '5500057877-RMF',
                        '5500057880-INS',
                        '5500057902-DX',
                        '5500057870-RT',
                        '5500057880-ISO',
                        '55000057895-BM',
                        '55000057896-DOR',
                        '5500057918-V-NN',
                        '5500057918-V-EE',
                        '5500057918-V-SS',
                        '5500058294-V-NO',
                        '5500058294-V-SP',
                        '5500058294-V-MG',
                        '5500057918-M-NN',
                        '5500057918-M-EE',
                        '5500057918-M-SS',
                        '5500058294-M-NO',
                        '5500058294-M-SP',
                        '5500058294-M-MG'))
        
         and (vExpressa = 'E') Then
        vCarga := '03';
      End If;
    
      -- Se foi colocado uma Tabela ou Solicitac?o
      -- Sem que o CTe esteja emitido
      -- Cria janela ja fechada
      if vTabSol is not null and vCteNota is null Then
        pJanelaINI := sysdate;
        pJanelaFIM := sysdate;
        Return;
      End If;
    
      Select count(*)
        into vControlaJanela
        From t_arm_janela cc
       Where 0 = 0
         and trim(CC.GLB_GRUPOECONOMICO_CODIGO) = trim(vGrupo)
         and trim(cc.glb_cliente_cgccpfcodigo) = trim(vSACADO)
         and trim(CC.SLF_CONTRATO_CODIGO) = trim(vContrato)
         and CC.Arm_Janela_Ativo = 'S'
         and TRUNC(CC.ARM_Janela_DATAINICIO) =
             (select max(CC1.ARM_JANELA_DATAINICIO)
                FROM t_arm_janela cc1
               WHERE CC1.GLB_GRUPOECONOMICO_CODIGO =
                     CC.GLB_GRUPOECONOMICO_CODIGO
                 AND CC1.GLB_CLIENTE_CGCCPFCODIGO =
                     CC.GLB_CLIENTE_CGCCPFCODIGO
                 AND CC1.FCF_TPCARGA_CODIGO = CC.FCF_TPCARGA_CODIGO
                 AND CC1.SLF_CONTRATO_CODIGO = CC.SLF_CONTRATO_CODIGO
                 AND CC1.ARM_JANELA_ATIVO = 'S'
                 AND CC1.ARM_JANELA_DATAINICIO <= TRUNC(SYSDATE))
         and TRUNC(CC.arm_Janela_DATAFIM) >= TRUNC(SYSDATE)
         and trim(CC.FCF_TPCARGA_CODIGO) = trim(vCarga);
    
      -- Se n?o Controlar Janela coloca a Data de Hoje e passa.
      if vControlaJanela = 0 Then
        pJanelaINI := sysdate;
        pJanelaFIM := sysdate;
        Return;
      End If;
    
      If trunc(vHoraJanela) <> to_date('01/01/1900', 'dd/mm/yyyy') Then
      
        vHoraJanelaTexto := to_char(vHoraJanela, 'dd/mm/yyyy hh24:mi:ss');
      
        -- Busca a qual janela pertence esta Nota
        Select
        --                 cc.arm_janela_sequencia,
        --                 cc.glb_grupoeconomico_codigo,
        --                 cc.glb_cliente_cgccpfcodigo,
        --                 cc.slf_contrato_codigo,
        --                 cc.fcf_tpcarga_codigo,
        --                 cc.arm_janela_qtde qtde,
        --                 cc.slf_tprateio_codigo rateio,
         TO_DATE(to_char(TRUNC(vHoraJanela) + cc.arm_Janela_diai,
                         'DD/MM/YYYY') || ' ' || trim(cc.arm_Janela_horai),
                 'DD/MM/YYYY HH24:MI:SS') JANELAINI,
         TO_DATE(to_char(TRUNC(vHoraJanela) + cc.arm_Janela_diaF,
                         'DD/MM/YYYY') || ' ' || trim(cc.arm_Janela_horaF),
                 'DD/MM/YYYY HH24:MI:SS') JANELAFIM,
         cc.arm_janela_qtde,
         cc.arm_janela_geracte
          into pJanelaINI, pJanelaFIM, vAuxiliar, pGeraCte
          From tdvadm.t_arm_janela cc
         Where 0 = 0
           and trim(CC.GLB_GRUPOECONOMICO_CODIGO) = trim(vGrupo)
           and trim(cc.glb_cliente_cgccpfcodigo) = trim(vSACADO)
           and trim(CC.SLF_CONTRATO_CODIGO) = trim(vContrato)
           and CC.Arm_Janela_Ativo = 'S'
           and TRUNC(CC.ARM_Janela_DATAINICIO) =
               (select max(CC1.ARM_JANELA_DATAINICIO)
                  FROM t_arm_janela cc1
                 WHERE CC1.GLB_GRUPOECONOMICO_CODIGO =
                       CC.GLB_GRUPOECONOMICO_CODIGO
                   AND CC1.GLB_CLIENTE_CGCCPFCODIGO =
                       CC.GLB_CLIENTE_CGCCPFCODIGO
                   AND CC1.FCF_TPCARGA_CODIGO = CC.FCF_TPCARGA_CODIGO
                   AND CC1.SLF_CONTRATO_CODIGO = CC.SLF_CONTRATO_CODIGO
                   AND CC1.ARM_JANELA_ATIVO = 'S'
                   AND CC1.ARM_JANELA_DATAINICIO <= TRUNC(SYSDATE))
           and TRUNC(CC.arm_Janela_DATAFIM) >= TRUNC(SYSDATE)
           and trim(CC.FCF_TPCARGA_CODIGO) = trim(vCarga)
           and TO_CHAR(vHoraJanela, 'YYYYMMDDHH24MISS') between
               TO_CHAR(TO_DATE(to_char(TRUNC(vHoraJanela) +
                                       cc.arm_Janela_diai,
                                       'DD/MM/YYYY') || ' ' ||
                               trim(cc.arm_Janela_horai),
                               'DD/MM/YYYY HH24:MI:SS'),
                       'YYYYMMDDHH24MISS') and
               TO_CHAR(TO_DATE(to_char(TRUNC(vHoraJanela) +
                                       cc.arm_Janela_diaF,
                                       'DD/MM/YYYY') || ' ' ||
                               trim(cc.arm_Janela_horaF),
                               'DD/MM/YYYY HH24:MI:SS'),
                       'YYYYMMDDHH24MISS');
      Else
        pJanelaINI := vHoraJanela;
        pJanelaFIM := vHoraJanela;
      End If;
    
      --           If vAuxiliar >                                                       
    Exception
      When NO_DATA_FOUND Then
        -- Se n?o achou e porque nao tem janela 
        pJanelaINI := sysdate;
        pJanelaFIM := sysdate;
      When TOO_MANY_ROWS Then
        vCarga     := null;
        pJanelaINI := '01/01/2200';
        pJanelaFIM := '01/01/2200';
      When OTHERS Then
        vErro      := sqlerrm;
        vCarga     := null;
        pJanelaINI := '01/01/2900';
        pJanelaFIM := '01/01/2900';
        raise_application_error(-20001,
                                'Erro pegando janela Carga [' || vCarga ||
                                '] Grupo [' || vGrupo || '] Contrato [' ||
                                vContrato || ']' || chr(10) || 'Erro : ' ||
                                vErro);
      
    End;
  End SP_GETJANELANOTA;

  Function FN_TEMJANELANOTA(pNota  in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCNPJ  in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pSerie in tdvadm.t_arm_nota.arm_nota_serie%type)
    Return VARCHAR2 As
    vControlaJanela integer;
    vSACADO         tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type;
    vGrupo          tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type;
    vContrato       tdvadm.t_slf_clientecargas.slf_contrato_codigo%type;
    vCarga          tdvadm.t_fcf_tpcarga.fcf_tpcarga_codigo%type;
    vDtBalanca      date;
    --    vDtEtiqueta  date;
    vDtEtiquetach varchar2(25);
    vPesoNota     number;
    vExpressa     tdvadm.t_arm_coleta.arm_coleta_tpcoleta%type;
    vAgrupamento  tdvadm.t_slf_tpagrupa.slf_tpagrupa_codigo%type;
  
  Begin
  
    Select distinct co.fcf_tpcarga_codigo,
                    substr(an.arm_nota_dtetiqueta, 1, 19),
                    nvl(p.arm_notapesagem_dtimprimiu,
                        to_date('01/01/1900', 'dd/mm/yyyy')),
                    an.arm_nota_pesobalanca,
                    co.arm_coleta_tpcoleta
      into vCarga, vDtEtiquetach, vDtBalanca, vPesoNota, vExpressa
      From t_arm_nota an, t_arm_coleta co, t_arm_notapesagem p
     where an.arm_nota_numero = pNota
       and trim(an.glb_cliente_cgccpfremetente) = trim(pCNPJ)
       and trim(an.arm_nota_serie) = trim(pSerie)
       and an.arm_coleta_ncompra = co.arm_coleta_ncompra
       and an.arm_coleta_ciclo = co.arm_coleta_ciclo
       and an.arm_nota_chavenfe = p.arm_nota_chavenfe(+)
       and an.arm_nota_sequencia =
           (select max(an1.arm_nota_sequencia)
              from t_arm_nota an1
             where an1.arm_nota_numero = an.arm_nota_numero
               and an1.glb_cliente_cgccpfremetente =
                   an.glb_cliente_cgccpfremetente
                  --                                          and an1.arm_coleta_ncompra = an.arm_coleta_ncompra
                  --                                          and an1.arm_coleta_ciclo = an.arm_coleta_ciclo
               and an1.arm_nota_serie = an.arm_nota_serie);
  
    SP_GETREGRANOTA(pNota,
                    pCNPJ,
                    pSerie,
                    vSACADO,
                    vGrupo,
                    vContrato,
                    vAgrupamento);
  
    Select count(*)
      into vControlaJanela
      From t_arm_janela cc
     Where 0 = 0
       and trim(CC.GLB_GRUPOECONOMICO_CODIGO) = trim(vGrupo)
       and trim(cc.glb_cliente_cgccpfcodigo) = trim(vSACADO)
       and trim(CC.SLF_CONTRATO_CODIGO) = trim(vContrato)
       and CC.Arm_Janela_Ativo = 'S'
       and TRUNC(CC.ARM_Janela_DATAINICIO) =
           (select max(CC1.ARM_JANELA_DATAINICIO)
              FROM t_arm_janela cc1
             WHERE CC1.GLB_GRUPOECONOMICO_CODIGO =
                   CC.GLB_GRUPOECONOMICO_CODIGO
               AND CC1.GLB_CLIENTE_CGCCPFCODIGO =
                   CC.GLB_CLIENTE_CGCCPFCODIGO
               AND CC1.FCF_TPCARGA_CODIGO = CC.FCF_TPCARGA_CODIGO
               AND CC1.SLF_CONTRATO_CODIGO = CC.SLF_CONTRATO_CODIGO
               AND CC1.ARM_JANELA_ATIVO = 'S'
               AND CC1.ARM_JANELA_DATAINICIO <= TRUNC(SYSDATE))
       and TRUNC(CC.arm_Janela_DATAFIM) >= TRUNC(SYSDATE)
       and trim(CC.FCF_TPCARGA_CODIGO) = trim(vCarga);
  
    -- Se n?o Controlar Janela coloca a Data de Hoje e passa.
    if vControlaJanela = 0 Then
      return 'N';
    End If;
    If vPesoNota < 3000 Then
      if vDtBalanca is null Then
        Return 'Nota n?o pesada';
      ElsIf trunc(vDtBalanca) < trunc(sysdate) Then
        Return 'Pesagem com Data muito antiga, impossivel pegar Janela';
      End If;
    Else
      if vDtEtiquetach is null Then
        Return 'Etiqueta n?o Impressa';
      ElsIf trunc(to_date(vDtEtiquetach, 'dd/mm/yyyy hh24:mi:ss')) <
            trunc(sysdate) Then
        Return 'Etiqueta com Data muito antiga, impossivel pegar Janela';
      End If;
    
    End If;
    Return 'S';
  
  End FN_TEMJANELANOTA;

  PROCEDURE SP_SETCRIAJANELA(pNota     in tdvadm.t_arm_nota.arm_nota_numero%type,
                             pCNPJ     in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                             pSerie    in tdvadm.t_arm_nota.arm_nota_serie%type,
                             pSequence in tdvadm.t_arm_nota.arm_nota_sequencia%type,
                             pOrigem   in tdvadm.t_arm_janelacons.arm_janelacons_origem%type, -- (N) Nota ou (C) Carregamento
                             pStatus   out char,
                             pMessage  out varchar2) As
    vLinha           tdvadm.t_arm_nota%rowtype;
    vJanelaCons      tdvadm.t_arm_janelacons%rowtype;
    vContaCteJanela  number;
    vSomaPeso        number;
    vSomaMerc        number;
    vContaNota       number;
    vCargaExpressa   tdvadm.t_arm_coleta.arm_coleta_tpcoleta%type;
    vPortoAeroporto  tdvadm.t_arm_coletapart.arm_coletapart_remetente%type;
    vErro            varchar2(10000);
    vOrigJanela      tdvadm.t_arm_janelacons.arm_janelacons_origem%type;
    ListaAgrupamento tdvadm.pkg_fifo_carregctrc.TpAgrupaCli;
    vColeta          tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
    vCiclo           tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
    vDataInf         tdvadm.t_arm_coletapart.arm_coletapart_dtenvcli%type;
  Begin
    /*****************************************************************************/
    pStatus  := 'N';
    pMessage := '';
  
    select *
      into vLinha
      from tdvadm.t_arm_nota an
     where an.arm_nota_numero = pNota
       and an.glb_cliente_cgccpfremetente = trim(pCNPJ)
       and an.arm_nota_serie = pSerie
       and an.arm_nota_sequencia =
           (select max(an1.arm_nota_sequencia)
              from tdvadm.t_arm_nota an1
             where an1.arm_nota_numero = an.arm_nota_numero
               and an1.glb_cliente_cgccpfremetente = an.glb_cliente_cgccpfremetente
               and an1.arm_nota_serie = an.arm_nota_serie);
  
    If vLinha.Arm_Janelacons_Sequencia is not null Then
      
    select jc.arm_janelacons_origem
      into vOrigJanela
      from tdvadm.t_arm_janelacons jc
     where jc.arm_janelacons_sequencia = vLinha.Arm_Janelacons_Sequencia;
       
    select an.arm_coleta_ncompra,
           an.arm_coleta_ciclo
      into vColeta,
           vCiclo
      from tdvadm.t_arm_nota an
     where an.arm_nota_numero = pNota
       and an.glb_cliente_cgccpfremetente = trim(pCNPJ)
       and an.arm_nota_serie = pSerie;
       
     select cp.arm_coletapart_dtenvcli
       into vDataInf
       from tdvadm.t_arm_coletapart cp
      where cp.arm_coleta_ncompra = vColeta
        and cp.arm_coleta_ciclo = vCiclo;
       
       -------------------------------------------------------
       ---------------Rafael Aiti 07/10/2019------------------
       --Se o Cliente ja foi informado, n?o cria mais janela--
       -------------------------------------------------------
       
       if vDataInf is not null then
         return; 
       end if;
    
      if pOrigem = 'C' and vOrigJanela = 'N' Then
        return;
      End If;
    
    end If;
  
    If nvl(pOrigem, 'N') = 'N' Then
      -- Somete Iremos criar Janela Depois da Etiqueta ou Balanca
      PKG_SLF_CONTRATO.SP_GETJANELANOTA(vlinha.arm_nota_numero,
                                        vlinha.glb_cliente_cgccpfremetente,
                                        vlinha.arm_nota_serie,
                                        vJanelaCons.Arm_Janelacons_Dtinicio,
                                        vJanelacons.Arm_Janelacons_Dtfim,
                                        vJanelaCons.Arm_Janelacons_Geracte);
    Else
      -- Pega a Data de Fechamento do Carregamento
      select c.arm_carregamento_dtcria
        into vJanelaCons.Arm_Janelacons_Dtinicio
        From tdvadm.t_arm_carregamento c, tdvadm.t_arm_carregamentodet cd
       where c.arm_carregamento_codigo = cd.arm_carregamento_codigo
         and cd.arm_embalagem_numero = vLinha.Arm_Embalagem_Numero
         and cd.arm_embalagem_flag = vLinha.Arm_Embalagem_Flag
         and cd.arm_embalagem_sequencia = vLinha.Arm_Embalagem_Sequencia;
    
      vJanelacons.Arm_Janelacons_Dtfim := vJanelaCons.Arm_Janelacons_Dtinicio;
    End If;
  
    If /*( vJanelaCons.Arm_Janelacons_Dtinicio = vJanelacons.Arm_Janelacons_Dtfim ) and */
     (vJanelaCons.Arm_Janelacons_Dtinicio <>
     to_date('01/01/1900', 'dd/mm/yyyy')) and
     (vLinha.Con_Conhecimento_Codigo is null) Then
    
      -- codigo Sirlano
      -- Para n?o dar erro na produc?o
      -- retirar o Begin exception depois de estabilizar
      Begin
      
        -- Consulto Cliente, Grupo Economico e Contrato.
        PKG_SLF_CONTRATO.SP_GETREGRANOTA(vLinha.Arm_Nota_Numero,
                                         vLinha.Glb_Cliente_Cgccpfremetente,
                                         vLinha.Arm_Nota_Serie,
                                         vJanelacons.Glb_Cliente_Cgccpfcodigo,
                                         vJanelacons.Glb_Grupoeconomico_Codigo,
                                         vJanelacons.Slf_Contrato_Codigo,
                                         vJanelaCons.Slf_Tpagrupa_Codigo);
      
        ListaAgrupamento := tdvadm.pkg_fifo_carregctrc.fn_RetornaAgrupamento(vJanelaCons.Slf_Tpagrupa_Codigo);
      
        -- Pego Informac?es da Coleta
        select c.fcf_tpcarga_codigo,
               c.arm_coleta_entcoleta,
               c.arm_coleta_tpcoleta
          into vJanelacons.Fcf_Tpcarga_Codigo,
               vJanelaCons.Arm_Janelacons_Entcol,
               vCargaExpressa
          from t_arm_coleta c
         where c.arm_coleta_ncompra = vLinha.Arm_Coleta_Ncompra
           and c.arm_coleta_ciclo = vLinha.Arm_Coleta_Ciclo;
      
-- Retirado em 28/09/2021
-- Chamado #230762
-- sirlano 
/*
        Begin
          vPortoAeroporto := null;
          select cl.glb_cliente_cgccpfcodigo
            into vPortoAeroporto
          from tdvadm.t_arm_coletapart cp,
               tdvadm.t_glb_cliente cl
          where cp.arm_coletapart_remetente = cl.glb_cliente_cgccpfcodigo
            and cp.arm_coleta_ncompra = vLinha.Arm_Coleta_Ncompra
            and cp.arm_coleta_ciclo = vLinha.Arm_Coleta_Ciclo
            and cl.glb_ramoatividade_codigo = '50'; -- AQUAVIARIO, TRANSPORTE
          vLinha.Glb_Cliente_Cgccpfremetente := vPortoAeroporto;
        exception
          When NO_DATA_FOUND Then
             vPortoAeroporto := null;
          End;
*/          

        If (vJanelacons.Slf_Contrato_Codigo in
           ('C5900011012', -- 0020 - MRO-VALE-0314-CS2781910
             'C2014030105', -- 0020 - MRO-VALE MANGANES-0314-CS2781910/M
             'C5900307551', -- 0020 - LOT-VALE-0915-LOTE 1
             'C5900307552') -- 0020 - LOT-VALE-0915-LOTE 2) 
           ) and (vCargaExpressa = 'E') Then
          vJanelacons.Fcf_Tpcarga_Codigo := '03';
        End If;
      
        if vJanelacons.Fcf_Tpcarga_Codigo is null Then
          pStatus  := 'W';
          pMessage := 'Carga n?o Definida na COLETA - ' ||
                      vLinha.Arm_Coleta_Ncompra || ' Ciclo ' ||
                      vLinha.Arm_Coleta_Ciclo;
        End If;
      
        vJanelaCons.Arm_Janelacons_Origem  := nvl(pOrigem, 'N');
        vJanelaCons.Glb_Cliente_Cgccpfsac  := vLinha.Glb_Cliente_Cgccpfsacado;
        vJanelaCons.Glb_Cliente_Cgccpfrem  := vLinha.Glb_Cliente_Cgccpfremetente;
        vJanelacons.Glb_Tpcliend_Codigorem := vLinha.Glb_Tpcliend_Codremetente;
        vJanelacons.Glb_Cliente_Cgccpfdes  := vLinha.Glb_Cliente_Cgccpfdestinatario;
        vJanelacons.Glb_Tpcliend_Codigodes := vLinha.Glb_Tpcliend_Coddestinatario;
      
        vJanelacons.Arm_Janelacons_Coleta := '99999';
      
        vJanelaCons.Arm_Janelacons_Entrega := '99999';
      
        PKG_SLF_CONTRATO.SP_GETJANELANOTA(vlinha.arm_nota_numero,
                                          vlinha.glb_cliente_cgccpfremetente,
                                          vlinha.arm_nota_serie,
                                          vJanelaCons.Arm_Janelacons_Dtinicio,
                                          vJanelacons.Arm_Janelacons_Dtfim,
                                          vJanelaCons.Arm_Janelacons_Geracte);
        -- Se for PORTO MUDA O CNPJ PARA MONTA A JANELA
        
        -- Mudei para este ponto somente para alterar o CNPJ da JANELA e nao da NOTA em 28/09/2021
        -- Chamado #230762
        -- sirlano 
        Begin
          vPortoAeroporto := null;
          select cl.glb_cliente_cgccpfcodigo
            into vPortoAeroporto
          from tdvadm.t_arm_coletapart cp,
               tdvadm.t_glb_cliente cl
          where cp.arm_coletapart_remetente = cl.glb_cliente_cgccpfcodigo
            and cp.arm_coleta_ncompra = vLinha.Arm_Coleta_Ncompra
            and cp.arm_coleta_ciclo = vLinha.Arm_Coleta_Ciclo
            and cl.glb_ramoatividade_codigo = '50'; -- AQUAVIARIO, TRANSPORTE
          vLinha.Glb_Cliente_Cgccpfremetente := vPortoAeroporto;
        exception
          When NO_DATA_FOUND Then
             vPortoAeroporto := null;
          End;
      
        vJanelacons.Arm_Janelacons_Qtdenf     := 1;
        vJanelacons.Arm_Janelacons_Pesocons   := vLinha.Arm_Nota_Peso;
        vJanelaCons.Arm_Janelacons_Merccons   := vLinha.Arm_Nota_Valormerc;
        vJanelacons.Arm_Janelacons_Qtdectenfs := 0;
        vJanelacons.Arm_Janelacons_Dtcriou    := sysdate;
      
        If ListaAgrupamento.acContrato = 'S' Then
          vJanelacons.SLF_CONTRATO_CODIGO := vJanelacons.SLF_CONTRATO_CODIGO;
        End If;
      
        If ListaAgrupamento.acSacado = 'S' Then
          vJanelacons.GLB_CLIENTE_CGCCPFSAC := vJanelacons.Glb_Cliente_Cgccpfsac;
        Else
          vJanelacons.GLB_CLIENTE_CGCCPFSAC := '99999999999999';
        End If;
      
        If ListaAgrupamento.acRemetente = 'S' Then
          if vJanelacons.ARM_JANELACONS_ENTCOL = 'E' Then
            vJanelacons.GLB_CLIENTE_CGCCPFREM  := vLinha.Arm_Armazem_Codigo;
            vJanelaCons.Glb_Tpcliend_Codigorem := 'X';
          -- Chamado #230762
          Elsif vPortoAeroporto is not null Then
            vJanelacons.GLB_CLIENTE_CGCCPFREM := vPortoAeroporto;
            vJanelaCons.Glb_Tpcliend_Codigorem := 'X';
          Else
            vJanelacons.GLB_CLIENTE_CGCCPFREM := vJanelacons.GLB_CLIENTE_CGCCPFREM;
          End If;
        Else
          vJanelacons.GLB_CLIENTE_CGCCPFREM  := '99999999999999';
          vJanelacons.GLB_TPCLIEND_CODIGOREM := 'X';
        End If;
      
        If ListaAgrupamento.acDestinatario = 'S' Then
          vJanelacons.GLB_CLIENTE_CGCCPFDES := vJanelaCons.Glb_Cliente_Cgccpfdes;
        Else
          vJanelacons.GLB_CLIENTE_CGCCPFDES  := '99999999999999';
          vJanelacons.GLB_TPCLIEND_CODIGODES := 'X';
        End If;
      
        If ListaAgrupamento.acTpEndRemetente = 'S' Then
          vJanelacons.Glb_Tpcliend_Codigorem := vLinha.Glb_Tpcliend_Codremetente;
        else
          vJanelacons.Glb_Tpcliend_Codigorem := 'X';
        End If;
      
        If ListaAgrupamento.acTpEndDestino = 'S' Then
          vJanelacons.Glb_Tpcliend_Codigodes := vLinha.Glb_Tpcliend_Coddestinatario;
        Else
          vJanelacons.Glb_Tpcliend_Codigodes := 'C';
        End If;
      
        If ListaAgrupamento.acLocalidadeColeta = 'S' Then
          vJanelacons.ARM_JANELACONS_COLETA := vLinha.Arm_Nota_Localcoletal;
        Else
          vJanelacons.ARM_JANELACONS_COLETA := '999999';
        End If;
      
        If ListaAgrupamento.acLocalidadeEntrega = 'S' Then
          vJanelacons.ARM_JANELACONS_ENTREGA := vLinha.Arm_Nota_Localentregal;
        Else
          vJanelacons.ARM_JANELACONS_ENTREGA := '999999';
        End If;
      
        If ListaAgrupamento.acIBGEColeta = 'S' Then
          vJanelacons.ARM_JANELACONS_COLETA := vLinha.Arm_Nota_Localcoletai;
        Else
          vJanelacons.ARM_JANELACONS_COLETA := '999999';
        End If;
      
        If ListaAgrupamento.acIBGEEntrega = 'S' Then
          vJanelacons.ARM_JANELACONS_ENTREGA := vLinha.Arm_Nota_Localentregai;
        Else
          vJanelacons.ARM_JANELACONS_ENTREGA := '999999';
        End If;
      
        If ListaAgrupamento.acColetaEntrega = 'S' Then
          vJanelacons.ARM_JANELACONS_ENTCOL := vJanelacons.ARM_JANELACONS_ENTCOL;
        Else
          vJanelacons.ARM_JANELACONS_ENTCOL := 'A';
        End If;
      
        If ListaAgrupamento.acTPCarga = 'S' then
          vJanelacons.FCF_TPCARGA_CODIGO := vJanelacons.FCF_TPCARGA_CODIGO;
        Else
          vJanelacons.FCF_TPCARGA_CODIGO := '00';
        End If;
      
        If ListaAgrupamento.acNrColeta = 'S' Then
          vJanelaCons.Arm_Janelacons_Nrcoleta := vLinha.Arm_Coleta_Ncompra;
        Else
          vJanelaCons.Arm_Janelacons_Nrcoleta := '000000';
        End If;
      
        -- N?o tem agrupamento por numero de nota
        --               If ListaAgrupamento.acNrNota = 'S' Then
        --               End If;
      
        If vJanelacons.Slf_Tpagrupa_Codigo = 'XX' Then
          -- Monto a Chave do Agrupamento             
          If vJanelacons.Slf_Tpagrupa_Codigo = '01' Then
            --CONTRATO
            --SACADO
            --DESTINO
            --TpEndDestino
            --Localidade da Coleta
            --Localidade da Entrega
            --COL / ENTREGA 
            vJanelacons.SLF_CONTRATO_CODIGO    := vJanelacons.SLF_CONTRATO_CODIGO;
            vJanelacons.FCF_TPCARGA_CODIGO     := vJanelacons.FCF_TPCARGA_CODIGO;
            vJanelacons.GLB_CLIENTE_CGCCPFSAC  := vJanelacons.Glb_Cliente_Cgccpfsac;
            vJanelacons.GLB_CLIENTE_CGCCPFREM  := '99999999999999';
            vJanelacons.GLB_TPCLIEND_CODIGOREM := 'X';
            vJanelacons.GLB_CLIENTE_CGCCPFDES  := vJanelaCons.Glb_Cliente_Cgccpfdes;
            vJanelacons.GLB_TPCLIEND_CODIGODES := vJanelaCons.Glb_Tpcliend_Codigodes;
            vJanelacons.ARM_JANELACONS_COLETA  := vLinha.Arm_Nota_Localcoletal;
            vJanelacons.ARM_JANELACONS_ENTREGA := vLinha.Arm_Nota_Localentregal;
            vJanelacons.ARM_JANELACONS_ENTCOL  := vJanelacons.ARM_JANELACONS_ENTCOL;
          
          ElsIf vJanelacons.Slf_Tpagrupa_Codigo = '02' Then
          
            --CONTRATO
            --REMETENTE
            --IBGE Coleta
            --IBGE Entrega
            --TPCarga
            --COL / ENTREGA
            vJanelacons.SLF_CONTRATO_CODIGO   := vJanelacons.SLF_CONTRATO_CODIGO;
            vJanelacons.FCF_TPCARGA_CODIGO    := vJanelacons.FCF_TPCARGA_CODIGO;
            vJanelacons.GLB_CLIENTE_CGCCPFSAC := '99999999999999';
            if vJanelacons.ARM_JANELACONS_ENTCOL = 'E' Then
              vJanelacons.GLB_CLIENTE_CGCCPFREM := vLinha.Arm_Armazem_Codigo;
            else
              vJanelacons.GLB_CLIENTE_CGCCPFREM := vJanelacons.GLB_CLIENTE_CGCCPFREM;
            End If;
            vJanelacons.GLB_TPCLIEND_CODIGOREM := 'X';
            vJanelacons.GLB_CLIENTE_CGCCPFDES  := '99999999999999';
            vJanelacons.GLB_TPCLIEND_CODIGODES := 'X';
            vJanelacons.ARM_JANELACONS_COLETA  := vLinha.Arm_Nota_Localcoletai;
            vJanelacons.ARM_JANELACONS_ENTREGA := vLinha.Arm_Nota_Localentregai;
            vJanelacons.ARM_JANELACONS_ENTCOL  := vJanelacons.ARM_JANELACONS_ENTCOL;
          
          ElsIf vJanelacons.Slf_Tpagrupa_Codigo = '03' Then
            --CONTRATO
            --SACADO
            --DESTINO
            --TpEndDestino
            --Localidade da Coleta
            --Localidade da Entrega
            --COL / ENTREGA
            vJanelacons.SLF_CONTRATO_CODIGO    := vJanelacons.SLF_CONTRATO_CODIGO;
            vJanelacons.FCF_TPCARGA_CODIGO     := vJanelacons.FCF_TPCARGA_CODIGO;
            vJanelacons.GLB_CLIENTE_CGCCPFSAC  := vJanelacons.Glb_Cliente_Cgccpfsac;
            vJanelacons.GLB_CLIENTE_CGCCPFREM  := '99999999999999';
            vJanelacons.GLB_TPCLIEND_CODIGOREM := 'X';
            vJanelacons.GLB_CLIENTE_CGCCPFDES  := vJanelaCons.Glb_Cliente_Cgccpfdes;
            vJanelacons.GLB_TPCLIEND_CODIGODES := vJanelaCons.Glb_Tpcliend_Codigodes;
            vJanelacons.ARM_JANELACONS_COLETA  := vLinha.Arm_Nota_Localcoletal;
            vJanelacons.ARM_JANELACONS_ENTREGA := vLinha.Arm_Nota_Localentregal;
            vJanelacons.ARM_JANELACONS_ENTCOL  := vJanelacons.ARM_JANELACONS_ENTCOL;
          
          ElsIf vJanelacons.Slf_Tpagrupa_Codigo = '04' Then
            --CONTRATO
            --IBGE Coleta,
            --IBGE Entrega
            --TPCarga
            vJanelacons.SLF_CONTRATO_CODIGO    := vJanelacons.SLF_CONTRATO_CODIGO;
            vJanelacons.FCF_TPCARGA_CODIGO     := vJanelacons.FCF_TPCARGA_CODIGO;
            vJanelacons.GLB_CLIENTE_CGCCPFSAC  := '99999999999999';
            vJanelacons.GLB_CLIENTE_CGCCPFREM  := '99999999999999';
            vJanelacons.GLB_TPCLIEND_CODIGOREM := 'X';
            vJanelacons.GLB_CLIENTE_CGCCPFDES  := '99999999999999';
            vJanelacons.GLB_TPCLIEND_CODIGODES := 'X';
            vJanelacons.ARM_JANELACONS_COLETA  := vLinha.Arm_Nota_Localcoletai;
            vJanelacons.ARM_JANELACONS_ENTREGA := vLinha.Arm_Nota_Localentregai;
            vJanelacons.ARM_JANELACONS_ENTCOL  := 'A';
          ElsIf vJanelacons.Slf_Tpagrupa_Codigo = '05' Then
            --CONTRATO
            --REMETENTE
            --DESTINO
            --IBGE Coleta
            --IBGE Entrega
            --TPCarga
            --COL / ENTREGA
          
            vJanelacons.SLF_CONTRATO_CODIGO    := vJanelacons.SLF_CONTRATO_CODIGO;
            vJanelacons.FCF_TPCARGA_CODIGO     := vJanelacons.FCF_TPCARGA_CODIGO;
            vJanelacons.GLB_CLIENTE_CGCCPFSAC  := '99999999999999';
            if vJanelacons.ARM_JANELACONS_ENTCOL = 'E' Then
              vJanelacons.GLB_CLIENTE_CGCCPFREM := vLinha.Arm_Armazem_Codigo;
            else
              vJanelacons.GLB_CLIENTE_CGCCPFREM := vJanelacons.GLB_CLIENTE_CGCCPFREM;
            End If;
            vJanelacons.GLB_TPCLIEND_CODIGOREM := 'X';
            vJanelacons.GLB_CLIENTE_CGCCPFDES  := vJanelaCons.Glb_Cliente_Cgccpfdes;
            vJanelacons.GLB_TPCLIEND_CODIGODES := 'X';
            vJanelacons.ARM_JANELACONS_COLETA  := vLinha.Arm_Nota_Localcoletai;
            vJanelacons.ARM_JANELACONS_ENTREGA := vLinha.Arm_Nota_Localentregai;
            vJanelacons.ARM_JANELACONS_ENTCOL  := vJanelacons.ARM_JANELACONS_ENTCOL;
          
          ElsIf vJanelacons.Slf_Tpagrupa_Codigo = '06' Then
            --CONTRATO
            --SACADO
            --Localidade da Coleta     
            vJanelacons.SLF_CONTRATO_CODIGO    := vJanelacons.SLF_CONTRATO_CODIGO;
            vJanelacons.FCF_TPCARGA_CODIGO     := vJanelacons.FCF_TPCARGA_CODIGO;
            vJanelacons.GLB_CLIENTE_CGCCPFSAC  := vJanelaCons.Glb_Cliente_Cgccpfsac;
            vJanelacons.GLB_CLIENTE_CGCCPFREM  := '99999999999999';
            vJanelacons.GLB_TPCLIEND_CODIGOREM := 'X';
            vJanelacons.GLB_CLIENTE_CGCCPFDES  := '99999999999999';
            vJanelacons.GLB_TPCLIEND_CODIGODES := 'X';
            vJanelacons.ARM_JANELACONS_COLETA  := vLinha.Arm_Nota_Localcoletal;
            vJanelacons.ARM_JANELACONS_ENTREGA := vJanelaCons.Arm_Janelacons_Entrega;
            vJanelacons.ARM_JANELACONS_ENTCOL  := 'A';
          
          End If;
        End If;
      
        -- Procura se ja existe uma chave igual para este agrupamento janela
        Begin
          select j.arm_janelacons_sequencia, j.arm_janelacons_qtdectenfs
            into vJanelaCons.Arm_Janelacons_Sequencia,
                 vJanelaCons.Arm_Janelacons_Qtdectenfs
            from tdvadm.t_arm_janelacons j
           where j.GLB_GRUPOECONOMICO_CODIGO =  vJanelacons.Glb_Grupoeconomico_Codigo
             and j.GLB_CLIENTE_CGCCPFCODIGO = vJanelacons.Glb_Cliente_Cgccpfcodigo
             and j.SLF_CONTRATO_CODIGO = vJanelacons.Slf_Contrato_Codigo
             and j.FCF_TPCARGA_CODIGO = vJanelacons.Fcf_Tpcarga_Codigo
             and j.SLF_TPAGRUPA_CODIGO = vJanelacons.Slf_Tpagrupa_Codigo
             and j.GLB_CLIENTE_CGCCPFSAC = vJanelacons.Glb_Cliente_Cgccpfsac
             and j.GLB_CLIENTE_CGCCPFREM = vJanelacons.Glb_Cliente_Cgccpfrem
             and j.GLB_TPCLIEND_CODIGOREM = vJanelacons.Glb_Tpcliend_Codigorem
             and j.GLB_CLIENTE_CGCCPFDES = vJanelacons.Glb_Cliente_Cgccpfdes
             and j.GLB_TPCLIEND_CODIGODES = vJanelacons.Glb_Tpcliend_Codigodes
             and j.ARM_JANELACONS_COLETA = vJanelacons.Arm_Janelacons_Coleta
             and j.ARM_JANELACONS_ENTREGA = vJanelacons.Arm_Janelacons_Entrega
             and j.ARM_JANELACONS_ENTCOL = vJanelacons.Arm_Janelacons_Entcol
             and j.ARM_JANELACONS_DTINICIO = vJanelacons.Arm_Janelacons_Dtinicio
             and j.ARM_JANELACONS_DTFIM = vJanelacons.Arm_Janelacons_Dtfim
             and j.arm_janelacons_origem = vJanelaCons.Arm_Janelacons_Origem;
        
          If vJanelaCons.Arm_Janelacons_Qtdectenfs = 0 Then
            -- Se A quantidade de Cte for zerada conta novamente
            -- TIRAR CONTAGEM
          
            vContaCteJanela := 0;
            /********** SIRLANO JANELA *************/
            If trunc(sysdate) > to_date('08/05/2016', 'DD/MM/YYYY') Then
              select count(*)
                into vContaCteJanela
                from t_arm_nota an
               where an.arm_janelacons_sequencia =
                     vJanelaCons.Arm_Janelacons_Sequencia
                 and an.con_conhecimento_codigo is not null;
            
            Else
              select count(*)
                into vContaCteJanela
                from t_arm_nota an
               where an.arm_janelacons_sequencia =
                     vJanelaCons.Arm_Janelacons_Sequencia
                 and an.con_conhecimento_codigo is not null
                 AND AN.ARM_ARMAZEM_CODIGO = '07';
            End If;
          
            -- Atualiza o controle de Janela  
            If vContaCteJanela > 0 Then
              update t_arm_janelacons j
                 set j.arm_janelacons_qtdectenfs = vContaCteJanela
               where j.arm_janelacons_sequencia = vJanelaCons.Arm_Janelacons_Sequencia;
              vJanelaCons.Arm_Janelacons_Qtdectenfs := vContaCteJanela;
            End If;
          End If;
        
          vJanelaCons.Arm_Janelacons_Qtdectenfs := 0;
        
          If vJanelaCons.Arm_Janelacons_Qtdectenfs > 0 Then
            pStatus  := pkg_fifo.Status_Erro;
            pMessage := 'Janela Ja Tem CTe/NFSe emitido. Aguardar FIM da Janela JANELA - ' ||
                        to_char(vJanelacons.Arm_Janelacons_Dtfim,
                                'dd/mm/yyyy hh24:mi:ss');
          End If;
        
        exception
          When NO_DATA_FOUND Then
            vJanelaCons.Arm_Janelacons_Sequencia := null;
        End;
      
        If pStatus = pkg_fifo.Status_Normal Then
          -- Atualiza dados da Janela
          -- Soma Pesos da Notas
        
          If vJanelaCons.Arm_Janelacons_Sequencia is not null Then
          
            select sum(nvl(an.arm_nota_pesobalanca, an.arm_nota_peso)),
                   sum(nvl(an.arm_nota_valormerc, 0)),
                   count(*)
              into vSomaPeso, vSomaMerc, vContaNota
              from tdvadm.t_arm_nota an
             where an.arm_janelacons_sequencia =
                   vJanelaCons.Arm_Janelacons_Sequencia;
          
            If vContaNota = 0 Then
-- tocado em 1/08/2019
-- Sirlano.
-- Na primeira nota usa peso real depois balanca
--              vSomaPeso  := vLinha.Arm_Nota_Peso;
              vSomaPeso  := nvl(vLinha.Arm_Nota_Pesobalanca,vlinha.arm_nota_peso);
              vSomaMerc  := vLinha.Arm_Nota_Valormerc;
              vContaNota := 1;
            End If;
          
            update t_arm_janelacons j
               set j.arm_janelacons_qtdenf = vContaNota,
                   --                           j.arm_janelacons_pesocons = j.arm_janelacons_pesocons + vJanelacons.Arm_Janelacons_Pesocons,
                   j.arm_janelacons_pesocons = vSomaPeso,
                   j.arm_janelacons_merccons = vSomaMerc
             where j.arm_janelacons_sequencia =
                   vJanelaCons.Arm_Janelacons_Sequencia;
          Else
            vJanelaCons.Arm_Janelacons_Sequencia := SEQ_ARM_JANELACONS.NEXTVAL;
            insert into tdvadm.t_arm_janelacons values vJanelaCons;
          End If;
        
          -- Atualiza a Chave da Janela na Nota
          update tdvadm.t_arm_nota an
             set an.arm_janelacons_sequencia = vJanelaCons.Arm_Janelacons_Sequencia
           where an.arm_nota_sequencia = vLinha.Arm_Nota_Sequencia;
        
          Commit;
        Else
          rollback;
        End If;
      
        -- retirar o exception depois de estabilizar
      exception
        When OTHERS Then
          vErro := sqlerrm;
          commit;
      End;
    End If;
  
    /*****************************************************************************/
  End SP_SETCRIAJANELA;

function fn_buscadecpesagem(pRota    in  tdvadm.t_arm_nota.glb_rota_codigo%type,
                            pnota    in  tdvadm.t_arm_nota.arm_nota_numero%type,
                            pcnpj    in  tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pserie   in  tdvadm.t_arm_nota.arm_nota_serie%type,
                            pSAP     in  char) 
 return char as
   vpsacado      tdvadm.t_slf_clienteregras.glb_cliente_cgccpfcodigo%type;
   vpgrupo       tdvadm.t_slf_clienteregras.glb_grupoeconomico_codigo%type;
   vpcontrato    tdvadm.t_slf_clienteregras.slf_contrato_codigo%type;
   vpagrupamento tdvadm.t_slf_clientecargas.slf_tpagrupa_codigo%type;
   vSerie        tdvadm.t_arm_nota.arm_nota_serie%type;
   vDecimal      char(1);
   vPesaDecimal  tdvadm.t_usu_perfil.usu_perfil_parat%type;
begin

  If pserie is null Then
     select an.arm_nota_serie
       into vserie
     from tdvadm.t_arm_nota an
     where an.arm_nota_numero =  pnota
       and an.glb_cliente_cgccpfremetente = pcnpj
       and an.arm_armazem_codigo in (select a.arm_armazem_codigo
                                     from tdvadm.t_arm_armazem a
                                     where a.glb_rota_codigo = pRota); 
  Else
    vSerie := pserie;
  End If;

  pkg_slf_contrato.sp_getregranota(pnota => pnota,
                                   pcnpj => pcnpj,
                                   pserie => vSerie,
                                   psacado => vpsacado,
                                   pgrupo => vpgrupo,
                                   pcontrato => vpcontrato,
                                   pagrupamento => vpagrupamento);
  
  -- Verifica se a rota esta para pesar decimal
  Begin
    select ap.usu_aplicacaoperfil_parat pesagramas
      into vPesaDecimal
    from tdvadm.t_usu_aplicacaoperfil ap
    where ap.usu_aplicacao_codigo = 'pesonota'
      and ap.usu_perfil_codigo = 'PESAGRAMAS'
      and ap.usu_aplicacaoperfil_ativo = 'S'
      and trunc(ap.usu_aplicacaoperfil_vigencia) <= trunc(sysdate)
      and trunc(ap.usu_aplicacaoperfil_validade) >= trunc(sysdate)
      and ap.glb_rota_codigo = pRota;
  exception
     When NO_DATA_FOUND Then
        Begin
           select p.usu_perfil_parat pesagramas
              into vPesaDecimal
           from tdvadm.t_usu_perfil p
           where 0 = 0
             and p.usu_aplicacao_codigo = 'pesonota'
             and p.usu_perfil_codigo = 'PESAGRAMAS'
             and trunc(p.usu_perfil_vigencia) <= trunc(sysdate);
        Exception
           When NO_DATA_FOUND Then
              vPesaDecimal := 'N';
     End;    
  End;

  If vPesaDecimal = 'S' Then
     Begin
        select distinct s.slf_clienteregras_pbdecgramas
          into vDecimal
        from tdvadm.t_slf_clienteregras s
        where s.glb_grupoeconomico_codigo = vpgrupo
          and s.glb_cliente_cgccpfcodigo = vpsacado
          and s.slf_contrato_codigo = vpcontrato;
     Exception
        When NO_DATA_FOUND Then
           vDecimal := 0;
     End; 
  Else
    vDecimal := 0;
  End If;     
    
  return vDecimal;

end fn_buscadecpesagem;

FUNCTION FN_VALIDAVALEPEDAGIO(P_CNPJ     IN T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                              P_CONTRATO IN T_ARM_NOTA.SLF_CONTRATO_CODIGO%TYPE DEFAULT QualquerContrato,
                              P_GRUPO    IN T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE DEFAULT QualquerGrupo)
 Return char
As
 vAchouVP integer;
 vTipoRet varchar2(5);
 vPagador  tdvadm.t_con_conhecimento.glb_cliente_cgccpfsacado%type; 
 vGrupo    tdvadm.t_glb_cliente.glb_grupoeconomico_codigo%type;
 vContrato tdvadm.t_slf_contrato.slf_contrato_codigo%type;
 
Begin 
  vPagador  := P_CNPJ;
  vGrupo    := P_GRUPO;
  vContrato := P_CONTRATO;
  
  vTipoRet := tdvadm.pkg_slf_contrato.FN_SLF_CLIENTEREGRACARGA(vPagador,
                                                               vContrato,
                                                               vGrupo);
                                                                
  IF vTipoRet = 'GCT' Then -- ACHOU POR GRUPO/CNPJ/CONTRADO
     vPagador  := vPagador ; 
     vGrupo    := vGrupo   ;
     vContrato := vContrato; 
  ElsIf vTipoRet = 'GC' Then -- ACHOU POR GRUPO/CNPJ
     vContrato := tdvadm.pkg_slf_contrato.QualquerContrato;
  ElsIf vTipoRet = 'GT' Then -- ACHOU GRUPO/CONTRATO
     vPagador  := tdvadm.pkg_slf_contrato.QualquerCliente;
  ElsIf vTipoRet = 'G' Then --ACHOU POR GRUPO
     vPagador  := tdvadm.pkg_slf_contrato.QualquerCliente;
     vContrato := tdvadm.pkg_slf_contrato.QualquerContrato;
  ElsIf vTipoRet = 'C' Then --ACHOU POR CLIENTE
     vGrupo    := tdvadm.pkg_slf_contrato.QualquerGrupo;
     vContrato := tdvadm.pkg_slf_contrato.QualquerContrato;
  ElsIf vTipoRet = 'T' Then --ACHOU POR CONTRATO
     vContrato := tdvadm.pkg_slf_contrato.QualquerContrato;
  ElsIf vTipoRet = 'QQQ' Then --POR QUALQUER COISA
     vPagador  := tdvadm.pkg_slf_contrato.QualquerCliente;
     vGrupo    := tdvadm.pkg_slf_contrato.QualquerGrupo;
     vContrato := tdvadm.pkg_slf_contrato.QualquerContrato;
  Else
     vPagador  := tdvadm.pkg_slf_contrato.QualquerCliente;
     vGrupo    := tdvadm.pkg_slf_contrato.QualquerGrupo;
     vContrato := tdvadm.pkg_slf_contrato.QualquerContrato;
  End If;
  
  Select count(*)
    into vAchouVP
  from tdvadm.t_slf_clienteregras cc
  where cc.glb_grupoeconomico_codigo = vGrupo
    and cc.glb_cliente_cgccpfcodigo = vPagador
    and cc.slf_contrato_codigo = vContrato
    and cc.slf_clienteregras_ativo = 'S'
    and cc.slf_clienteregras_valeped = 'S'
    and cc.slf_clienteregras_vigencia = (select max(cc1.slf_clienteregras_vigencia)
                                         from tdvadm.t_slf_clienteregras cc1
                                         where cc1.glb_grupoeconomico_codigo = cc.glb_grupoeconomico_codigo
                                           and cc1.glb_cliente_cgccpfcodigo = cc.glb_cliente_cgccpfcodigo
                                           and cc1.slf_contrato_codigo = cc.slf_contrato_codigo
                                           and cc1.slf_clienteregras_ativo = 'S');
  
  If vAchouVP > 0 then
     Return 'S';
  Else
     Return 'N';
  End IF;



End FN_VALIDAVALEPEDAGIO;                                   


END PKG_SLF_CONTRATO;
/
