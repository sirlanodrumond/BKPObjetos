create or replace package PKG_ARM_EMBALAGEM is
  
  TYPE T_CURSOR IS REF CURSOR;
  
  CARREGAMENTO_DEVOLVE_NOTA CONSTANT CHAR(7) := '0000000';
 
  isEmpty     CONSTANT CHAR(1) := '';
  
  -- STATUS USADO COMO RETORNO EM TODAS AS PROCEDURES
  Status_Normal CONSTANT CHAR(1) := 'N';
  Status_Erro   CONSTANT CHAR(1) := 'E';
  Status_Warning Constant Char(1) := 'W';
  
  -- BOOLEANO COMO CHAR
  BOOLEAN_SIM CONSTANT CHAR(1) := 'S';
  BOOLEAN_NAO CONSTANT CHAR(1) := 'N'; 
  
 TYPE DevolucaoData IS RECORD(Nota t_arm_nota.arm_nota_numero%Type,
                              CNPJ t_arm_nota.glb_cliente_cgccpfremetente%Type,
                              Seq t_arm_nota.arm_nota_sequencia%Type,  
                              Chave t_arm_nota.arm_nota_chavenfe%Type,  
                              TipoDevolucao Char(1), -- 'F'=Fornecedor, 'D'=Devolucao(com conhecimento), 'R'=Reentrega(com recusa do destinatario), 'N'=Recuperar Nf devolvida ao fornecedor
                              PagtoFrete Char(1), -- 'D'=Destinatario, 'R'=Remetente, 'S'=Sacado
                              LocalRecusa Char(2), -- 'NF'=Nota, 'CT'=CTe, 'DP'=Doc a parte);
                              Ref         char(1),  -- (T) Tabela ou (S) Solicitacao
                              CodigoRef   char(8), -- Codigo da Tabela ou da solicitação
                              IDOcorrencia number, -- Codigo da Ocorrencia
                              Entrega      char(2), -- Codigo do Aramzem ou nulo se for o Fornecedor
                              ColetaOrig   tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                              Coleta       tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                              Ciclo        tdvadm.t_arm_coleta.arm_coleta_ciclo%type,
                              Observacao   varchar2(300), -- Observacao complementar
                              Motivo       number,
                              Usuario      tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                              RotaUSU      tdvadm.t_usu_usuario.glb_rota_codigo%type,
                              ArmazemUSU   tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                              Aplicacao    tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                              Versao       tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type,
                              Cte          tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                              SrCte        tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                              RtCte        tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                              Valor        tdvadm.t_arm_notacte.arm_notacte_valor%type
                              ); 


 
  TYPE tpValidaEmbalagem IS RECORD(Carregamento     TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,
                                   ArmazemCarreg    TDVADM.T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%TYPE,
                                   ArmazemEmbalagem TDVADM.T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%TYPE,
                                   Embalagem        TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                   CTRC             TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                   Serie            TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,  
                                   Rota             TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,  
                                   Destino          TDVADM.T_GLB_LOCALIDADE.GLB_LOCALIDADE_DESCRICAO%TYPE,
                                   Veiculo          tdvadm.t_arm_carregamentoveic.arm_carregamentoveic_placa%type,
                                   VolumesDaNota    number);
                                   
 TYPE Barcode IS RECORD( Nota        tdvadm.t_arm_nota.arm_nota_numero%type,
                         CNPJ        tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                         Volume      tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                         VolumeTotal tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                         Embalagem   tdvadm.t_arm_embalagem.arm_embalagem_numero%type);
  
  PROCEDURE SP_GET_VALIDADESTINOSEMB(P_SOL_COD  IN TDVADM.T_FCF_SOLVEIC.FCF_SOLVEIC_COD%TYPE,
                                     P_EMB_NUM  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                     P_EMB_FLAG IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                     P_EMB_SEQ  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,
                                     P_ISTRANSF OUT CHAR,
                                     P_STATUS   OUT CHAR,
                                     P_MESSAGE  OUT VARCHAR2);     

  PROCEDURE SP_GET_EMBALAGEMNOTA(P_NOTA_NUM  IN TDVADM.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                                 P_NOTA_CNPJ IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                                 P_EMB_NUM   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,                                  
                                 P_EMB_FLAG  OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                 P_EMB_SEQ   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,                                  
                                 P_STATUS    OUT CHAR,
                                 P_MESSAGE   OUT VARCHAR2);
                                 
  PROCEDURE SP_GET_EMBALAGEMNOTA(P_NOTA_NUM  IN TDVADM.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                                 P_NOTA_CNPJ IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                                 P_NOTA_VOLUME IN TDVADM.T_ARM_NOTA.ARM_NOTA_QTDVOLUME%TYPE,
                                 P_USUARIO IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                 P_EMB_NUM   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,                                  
                                 P_EMB_FLAG  OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                 P_EMB_SEQ   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,                                  
                                 P_STATUS    OUT CHAR,
                                 P_MESSAGE   OUT VARCHAR2);                                 

  PROCEDURE SP_GET_DESTINOEMBALAGEM(P_EMB_NUM  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                    P_EMB_FLAG IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                    P_EMB_SEQ  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,
                                    P_LOC_DESC OUT TDVADM.T_GLB_LOCALIDADE.GLB_LOCALIDADE_DESCRICAO%TYPE,
                                    P_STATUS   OUT CHAR,
                                    P_MESSAGE  OUT VARCHAR2);

  PROCEDURE SP_ASSOCIACARREGAMENTO(P_CARREGAMENTO IN TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,
                                    P_EMBALAGEM_COD IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                    P_EMBALAGEM_FLAG IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                    P_EMBALAGEM_SEQ IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,
                                    P_STATUS OUT CHAR,
                                    P_MESSAGE OUT VARCHAR2);
                                    
  Procedure Sp_ValidaEmbalagem_Veic(pEmbalagem In Tdvadm.t_Arm_Embalagem.Arm_Embalagem_Numero%Type,
                                    pArmazem In Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type,   
                                    pCarreg    Out TdvAdm.t_Arm_Embalagem.Arm_Carregamento_Codigo%Type, 
                                    pDestino   Out Tdvadm.t_Glb_Localidade.Glb_Localidade_Descricao%Type,                                    
                                    pIsValid   Out Char,
                                    pStatus    Out Char,
                                    pMessage   Out Varchar2);  
                                    
  Procedure Sp_ValidaEmbalagem_Veic3(pXmlIn     In Varchar2,
                                    pCarreg    Out TdvAdm.t_Arm_Embalagem.Arm_Carregamento_Codigo%Type,
                                    pDestino   Out Tdvadm.t_Glb_Localidade.Glb_Localidade_Descricao%Type,
                                    pIsValid   Out Char,
                                    pStatus    Out Char,
                                    pMessage   Out Varchar2);                                                                    
                                                                        
  Procedure Sp_ValidaEmbalagem_Veic(pXmlIn     In Varchar2,
                                    pCarreg    Out TdvAdm.t_Arm_Embalagem.Arm_Carregamento_Codigo%Type,
                                    pDestino   Out Tdvadm.t_Glb_Localidade.Glb_Localidade_Descricao%Type,
                                    pIsValid   Out Char,
                                    pStatus    Out Char,
                                    pMessage   Out Varchar2);
                                    
  Procedure Sp_Get_EmbNotasNaoCarregadas(pArmazem in t_arm_embalagem.arm_armazem_codigo%type,
                                         pCursor  Out Types.cursorType);

  -- New 06/02/2014
  Procedure Sp_Devolver_EmbalagemNF(pXmlIn   in  Varchar2,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2);    
                                    
  Procedure Sp_GetMotivoDevolucao(pXmlOut  Out Clob,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2);                                    
                                    
  Procedure Sp_Devolver_EmbNF_Fornecedor(pNota      in t_arm_nota.arm_nota_numero%Type,
                                         pCNPJ      In t_arm_nota.glb_cliente_cgccpfremetente%type,
                                         pSequencia In t_arm_nota.arm_nota_sequencia%Type,
                                         pMotivo    In Number,
                                         pStatus    Out Char,
                                         pMessage   Out Varchar2);
                                         
  Procedure Sp_Recup_EmbNF_Fornecedor(pNota      in t_arm_nota.arm_nota_numero%Type,
                                      pCNPJ      In t_arm_nota.glb_cliente_cgccpfremetente%type,
                                      pSequencia In t_arm_nota.arm_nota_sequencia%Type,
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2);                                         


end PKG_ARM_EMBALAGEM;

 
/
create or replace package body PKG_ARM_EMBALAGEM is

  PROCEDURE SP_GET_VALIDADESTINOSEMB(P_SOL_COD  IN TDVADM.T_FCF_SOLVEIC.FCF_SOLVEIC_COD%TYPE,
                                     P_EMB_NUM  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                     P_EMB_FLAG IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                     P_EMB_SEQ  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,                                     
                                     P_ISTRANSF OUT CHAR,
                                     P_STATUS   OUT CHAR,
                                     P_MESSAGE  OUT VARCHAR2)
  /*************************************************************************************************
   * ROTINA           : SP_GET_VALIDADESTINOSEMB                                                   *
   * PROGRAMA         : VALIDA OS DESTINOS DA EMBALAGEM COM A SOLICITAÇÃO                          *
   * ANALISTA         : Fabiano Góes                                                               *
   * DESENVOLVEDOR    : Fabiano Góes                                                               *
   * DATA DE CRIACAO  : 09/09/2010                                                                 *
   * ALTERADO POR     :                                                                            *
   * DATA ALTERAÇÃO   :  /  /                                                                      *
   * BANCO            : ORACLE-TDP                                                                 *
   * EXECUTADO POR    :                                                                            *
   * ALIMENTA         :                                                                            *
   * FUNCINALIDADE    : VERIFICAR SE OS DESTINOS DA EMBALAGEM SÃO VALIDOS PARA A SOLICITAÇÃO       *
   * PARTICULARIDADES :                                                                            *
   * PARAM. OBRIGAT.  : CHAVE DA SOLICITAÇÃO E CHAVES DA EMBALAGEM                                 *
   ************************************************************************************************/                                     
   IS
   V_DESTINOS_SOL VARCHAR2(1000);
   V_DESTINO_EMB  VARCHAR2(100);  
   BEGIN
      BEGIN
         -- I=TIPO DE RETORNO CODIGO DE IBGE
         WSERVICE.PKG_WSD_CARREGAMENTO.SP_GET_DESTINOSOLITACAO(P_SOL_COD, 'I', V_DESTINOS_SOL, P_STATUS, P_MESSAGE); 
         IF P_STATUS = 'N' THEN                
           SP_GET_DESTINOEMBALAGEM(P_EMB_NUM, P_EMB_FLAG, P_EMB_SEQ, V_DESTINO_EMB, P_STATUS, P_MESSAGE);        
           IF P_STATUS = 'N' THEN
                       
             -- CASO NÃO SEJA ENCONTRADO O DESTINO DA EMBALAGEM DENTRO DOS DESTINOS DA SOLICITAÇÃO
             -- DEVOLVO A LISTA DE DESTINOS POSSIVEIS PARA TRANSFERENCIA
             IF (INSTR(V_DESTINOS_SOL, V_DESTINO_EMB) = 0) THEN
               WSERVICE.PKG_WSD_CARREGAMENTO.SP_GET_DESTINOSOLITACAO(P_SOL_COD, 'A', V_DESTINOS_SOL, P_STATUS, P_MESSAGE);
               P_ISTRANSF:= BOOLEAN_SIM;
               P_STATUS  := Status_Normal;
               P_MESSAGE := V_DESTINOS_SOL;   
             ELSE
               P_ISTRANSF:= BOOLEAN_NAO;          
               P_STATUS := Status_Normal; 
               P_MESSAGE:= 'DESTINOS DA EMBALAGEM VALIDADOS COM SUCESSO!';
             END IF;           
             
           END IF;
           
         END IF;
              
      EXCEPTION
         WHEN OTHERS THEN
         BEGIN
            P_STATUS := Status_Erro; -- ERRO
            P_MESSAGE:= 'ERRO AO TENTAR VALIDAR OS DESTINOS DA EMBALAGEM!';
         END;  
      END;      
   END SP_GET_VALIDADESTINOSEMB;                                      

  PROCEDURE SP_GET_EMBALAGEMNOTA(P_NOTA_NUM  IN TDVADM.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                                 P_NOTA_CNPJ IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                                 P_EMB_NUM   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,                                  
                                 P_EMB_FLAG  OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                 P_EMB_SEQ   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,                                  
                                 P_STATUS    OUT CHAR,
                                 P_MESSAGE   OUT VARCHAR2)
  /************************************************************************************************
   * ROTINA           : SP_GET_EMBALAGEMNOTA                                                        *
   * PROGRAMA         : LISTA A EMBALAGEM QUE A NOTA ESTÁ VINCULADA
   * ANALISTA         : Fabiano Góes                                                               *
   * DESENVOLVEDOR    : Fabiano Góes                                                               *
   * DATA DE CRIACAO  : 09/09/2010                                                                 *
   * ALTERADO POR     :                                                                            *
   * DATA ALTERAÇÃO   :  /  /                                                                      *
   * BANCO            : ORACLE-TDP                                                                 *
   * EXECUTADO POR    : 
   * ALIMENTA         :                                                                            *
   * FUNCINALIDADE    : LISTA A EMBALAGEM QUE A NOTA ESTÁ VINCULADA
   * PARTICULARIDADES : 
   * PARAM. OBRIGAT.  : CHAVE DA NOTA
   ************************************************************************************************/                                 
   IS 
   BEGIN
      
      Begin
       /* If P_NOTA_NUM = '26759'   Then
          p_message:= 'DIOGO... A COCA-COLA... ';
          Return;
        End If;*/
      
         SELECT N.ARM_EMBALAGEM_NUMERO,
                N.ARM_EMBALAGEM_FLAG,
                N.ARM_EMBALAGEM_SEQUENCIA
           INTO P_EMB_NUM,
                P_EMB_FLAG,
                P_EMB_SEQ
           FROM TDVADM.T_ARM_NOTA N
          Where N.ARM_NOTA_NUMERO = P_NOTA_NUM
            AND tRIM(N.GLB_CLIENTE_CGCCPFREMETENTE) = Trim(P_NOTA_CNPJ)
            And TRUNC(N.ARM_NOTA_DTINCLUSAO) > TRUNC(Sysdate - 180)
            -- fabiano 09/03/2011 - deve ser melhor avaliado
            And N.ARM_EMBALAGEM_SEQUENCIA = (Select MAX(NN.ARM_EMBALAGEM_SEQUENCIA)
                                             From TDVADM.T_ARM_NOTA NN
                                             Where NN.ARM_NOTA_NUMERO = N.ARM_NOTA_NUMERO
                                             And NN.GLB_CLIENTE_CGCCPFREMETENTE = N.GLB_CLIENTE_CGCCPFREMETENTE);
            
         P_STATUS  := Status_Normal; -- NORMAL
         P_MESSAGE := 'TDVADM.PKG_WSD_CARREGAMENTOMOBILE.SP_GET_EMBALAGEMNOTA -> EXECUTADO COM SUCESSO!';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           BEGIN
           P_STATUS  := Status_Erro; -- ERRO
           P_MESSAGE := 'REGISTRO NÃO LOCALIZADO, '||
                        'PARAMETROS: P_NOTA_NUM = '||P_NOTA_NUM||', P_NOTA_CNPJ = '||P_NOTA_CNPJ; 
           END;
           
         WHEN OTHERS THEN
           BEGIN
           P_STATUS  := Status_Erro; -- ERRO
           P_MESSAGE := 'ERRO AO TENTAR EXECUTAR: TDVADM.PKG_WSD_CARREGAMENTOMOBILE.SP_GET_EMBALAGEMNOTA, '||
                        'PARAMETROS: P_NOTA_NUM = '||P_NOTA_NUM||', P_NOTA_CNPJ = '||P_NOTA_CNPJ||SQLERRM;  
           END;
      END;
                    
   END SP_GET_EMBALAGEMNOTA;      
   
  PROCEDURE SP_GET_EMBALAGEMNOTA(P_NOTA_NUM  IN TDVADM.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                                 P_NOTA_CNPJ IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                                 P_NOTA_VOLUME IN TDVADM.T_ARM_NOTA.ARM_NOTA_QTDVOLUME%TYPE,
                                 P_USUARIO IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                 P_EMB_NUM   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,                                  
                                 P_EMB_FLAG  OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                 P_EMB_SEQ   OUT TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,                                  
                                 P_STATUS    OUT CHAR,
                                 P_MESSAGE   OUT VARCHAR2)
  /************************************************************************************************
   * ROTINA           : SP_GET_EMBALAGEMNOTA                                                        *
   * PROGRAMA         : LISTA A EMBALAGEM QUE A NOTA ESTÁ VINCULADA
   * ANALISTA         : Fabiano Góes                                                               *
   * DESENVOLVEDOR    : Fabiano Góes                                                               *
   * DATA DE CRIACAO  : 09/09/2010                                                                 *
   * ALTERADO POR     :                                                                            *
   * DATA ALTERAÇÃO   :  /  /                                                                      *
   * BANCO            : ORACLE-TDP                                                                 *
   * EXECUTADO POR    : 
   * ALIMENTA         :                                                                            *
   * FUNCINALIDADE    : LISTA A EMBALAGEM QUE A NOTA ESTÁ VINCULADA
   * PARTICULARIDADES : 
   * PARAM. OBRIGAT.  : CHAVE DA NOTA
   ************************************************************************************************/                                 
   IS 
     vQtdeVol tdvadm.t_arm_nota.arm_nota_qtdvolume%type;
     vNomeUsuario tdvadm.t_usu_usuario.usu_usuario_nome%type;
   BEGIN
      
      Begin
       /* If P_NOTA_NUM = '26759'   Then
          p_message:= 'DIOGO... A COCA-COLA... ';
          Return;
        End If;*/
          
           SELECT N.ARM_EMBALAGEM_NUMERO,
                  N.ARM_EMBALAGEM_FLAG,
                  N.ARM_EMBALAGEM_SEQUENCIA,
                  n.arm_nota_qtdvolume
             INTO P_EMB_NUM,
                  P_EMB_FLAG,
                  P_EMB_SEQ,
                  vQtdeVol
             FROM TDVADM.T_ARM_NOTA N
            Where N.ARM_NOTA_NUMERO = P_NOTA_NUM
              AND tRIM(N.GLB_CLIENTE_CGCCPFREMETENTE) = Trim(P_NOTA_CNPJ)
              And TRUNC(N.ARM_NOTA_DTINCLUSAO) > TRUNC(Sysdate - 180)
              -- fabiano 09/03/2011 - deve ser melhor avaliado
              And N.ARM_EMBALAGEM_SEQUENCIA = (Select MAX(NN.ARM_EMBALAGEM_SEQUENCIA)
                                               From TDVADM.T_ARM_NOTA NN
                                               Where NN.ARM_NOTA_NUMERO = N.ARM_NOTA_NUMERO
                                               And NN.GLB_CLIENTE_CGCCPFREMETENTE = N.GLB_CLIENTE_CGCCPFREMETENTE);
          IF vQtdeVol = P_NOTA_VOLUME THEN         
               P_STATUS  := Status_Normal; -- NORMAL
               P_MESSAGE := 'TDVADM.PKG_WSD_CARREGAMENTOMOBILE.SP_GET_EMBALAGEMNOTA -> EXECUTADO COM SUCESSO!';
          ELSE
               begin
                 select u.usu_usuario_nome
                   into vNomeUsuario
                   from tdvadm.t_usu_usuario u
                  where 0=0
                    and lower(trim(u.usu_usuario_codigo)) = lower(trim(p_usuario));
               exception when no_data_found then
                 vNomeUsuario := 'Usuario';    
               end;
                                        
               P_STATUS  := Status_Erro; -- Erro
               P_MESSAGE := vNomeUsuario||', você executou uma operação ilegal e apartir de agora será monitorado, '||
                            'Nota ['||P_NOTA_NUM||'] contém ' || vQtdeVol || ' volumes, favor realizar carregamento de forma correta!';            
               
               tdvadm.pkg_glb_log.sp_GravaLog(P_MESSAGE, 
                                              'carregmob', 
                                              'W', 
                                              'Default', 
                                              P_NOTA_NUM||';'||P_NOTA_CNPJ||';'||P_NOTA_VOLUME||';'||P_USUARIO);
 
          END IF;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           BEGIN
           P_STATUS  := Status_Erro; -- ERRO
           P_MESSAGE := 'REGISTRO NÃO LOCALIZADO, '||
                        'PARAMETROS: P_NOTA_NUM = '||P_NOTA_NUM||', P_NOTA_CNPJ = '||P_NOTA_CNPJ; 
           END;
           
         WHEN OTHERS THEN
           BEGIN
           P_STATUS  := Status_Erro; -- ERRO
           P_MESSAGE := 'ERRO AO TENTAR EXECUTAR: TDVADM.PKG_WSD_CARREGAMENTOMOBILE.SP_GET_EMBALAGEMNOTA, '||
                        'PARAMETROS: P_NOTA_NUM = '||P_NOTA_NUM||', P_NOTA_CNPJ = '||P_NOTA_CNPJ||SQLERRM;  
           END;
      END;
                    
   END SP_GET_EMBALAGEMNOTA;                                 

  PROCEDURE SP_GET_DESTINOEMBALAGEM(P_EMB_NUM  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                    P_EMB_FLAG IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                    P_EMB_SEQ  IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,
                                    P_LOC_DESC OUT TDVADM.T_GLB_LOCALIDADE.GLB_LOCALIDADE_DESCRICAO%TYPE,
                                    P_STATUS   OUT CHAR,
                                    P_MESSAGE  OUT VARCHAR2)
  IS
  BEGIN
    
    BEGIN
      
      -- VALIDO O DESTINO DA EMBALAGEM COM O CODIGO DE IBGE       
      SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
        INTO P_LOC_DESC
        FROM TDVADM.T_ARM_EMBALAGEM E,
             TDVADM.T_ARM_CARGADET CD,
             TDVADM.T_ARM_NOTA NT,
             TDVADM.T_GLB_CLIEND CE,
             TDVADM.T_GLB_LOCALIDADE LO,
             TDVADM.T_ARM_ARMAZEM A     
       WHERE E.ARM_EMBALAGEM_NUMERO    = CD.ARM_EMBALAGEM_NUMERO
         AND E.ARM_EMBALAGEM_FLAG      = CD.ARM_EMBALAGEM_FLAG
         AND E.ARM_EMBALAGEM_SEQUENCIA = CD.ARM_EMBALAGEM_SEQUENCIA           
         AND CD.ARM_NOTA_NUMERO        = NT.ARM_NOTA_NUMERO    
         AND CD.ARM_NOTA_SEQUENCIA     = NT.ARM_NOTA_SEQUENCIA          
         AND RPAD(NT.GLB_CLIENTE_CGCCPFDESTINATARIO,20) = CE.GLB_CLIENTE_CGCCPFCODIGO
         AND NT.GLB_TPCLIEND_CODDESTINATARIO = CE.GLB_TPCLIEND_CODIGO           
         AND CE.GLB_LOCALIDADE_CODIGO = LO.GLB_LOCALIDADE_CODIGO
         AND NT.ARM_ARMAZEM_CODIGO = A.ARM_ARMAZEM_CODIGO
         AND E.ARM_EMBALAGEM_NUMERO    = P_EMB_NUM
         AND E.ARM_EMBALAGEM_SEQUENCIA = P_EMB_SEQ
         AND E.ARM_EMBALAGEM_FLAG      = P_EMB_FLAG;
      
      P_STATUS  := Status_Normal;
      P_MESSAGE := 'DESTINO DA EMBALAGEM ENCONTRADO!';     
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
        P_STATUS  := Status_Erro;
        P_MESSAGE := 'ERRO AO TENTAR BUSCAR O DESTINO PARA A EMBALAGEM:'||CHR(13)||
                     'NUM: '||TO_CHAR(P_EMB_NUM)||', FLAG: '||P_EMB_FLAG||', SEQ: '||TO_CHAR(P_EMB_SEQ)||CHR(13)||
                     'PKG_ARM_EMBALAGEM.SP_GET_DESTINOEMBALAGEM'||Sqlerrm ;
        END;
    END; -- EXCEPTION  
        
  END SP_GET_DESTINOEMBALAGEM;                                                                    
                                                                  
  PROCEDURE SP_ASSOCIACARREGAMENTO(P_CARREGAMENTO IN TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,
                                    P_EMBALAGEM_COD IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                    P_EMBALAGEM_FLAG IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_FLAG%TYPE,
                                    P_EMBALAGEM_SEQ IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_SEQUENCIA%TYPE,
                                    P_STATUS OUT CHAR,
                                    P_MESSAGE OUT VARCHAR2)
  Is
  vCarreg tdvadm.t_arm_embalagem.arm_carregamento_codigo%Type;
  vArmazemCarreg tdvadm.t_arm_carregamento.arm_armazem_codigo%Type;
  vArmazemEmbalagem tdvadm.t_arm_embalagem.arm_armazem_codigo%Type;
  BEGIN
       Begin
         
         Begin 
           Select c.Arm_Armazem_Codigo
           Into vArmazemCarreg
           From tdvadm.t_arm_carregamento c
           Where c.arm_carregamento_codigo = P_CARREGAMENTO;
         Exception When no_data_found Then
           vArmazemCarreg := Null; 
         End;
         
         Begin 
           Select trim(e.arm_carregamento_codigo),
                  e.Arm_Armazem_Codigo
           Into vCarreg,
                vArmazemEmbalagem
           From tdvadm.t_arm_embalagem e
           Where e.arm_embalagem_numero = P_EMBALAGEM_COD
           And e.arm_embalagem_flag = trim(P_EMBALAGEM_FLAG)
           And e.arm_embalagem_sequencia = P_EMBALAGEM_SEQ;
         Exception When no_data_found Then
           vCarreg := Null; 
           vArmazemEmbalagem := null;
         End;
         /************************************************************************************************
         * Alteração: Não deixar vincular uma embalagem com o armazem diferente do carregamento
         ************************************************************************************************/         
          If(vArmazemCarreg <> vArmazemEmbalagem) Then
             P_STATUS  := Status_Erro;
             P_MESSAGE := 'Esta embalagem esta no armazem ' || vArmazemEmbalagem || 
                ' e o carregamento esta no armazem ' || vArmazemCarreg || ' não pode ser vinculado' ;           
             return;          
          End If;
         
         
         If(vCarreg <> 0) Then
                 
               If (vCarreg Is Not Null) And (trim(vCarreg) <> Trim(P_CARREGAMENTO)) Then
                  P_STATUS  := Status_Erro;
                  P_MESSAGE := 'Esta embalagem não pode ser associada a este carregamento '||
                               'porque já está associado ao carregamento: '||vCarreg;             
               Else
                 UPDATE TDVADM.T_ARM_EMBALAGEM EM
                    SET EM.ARM_CARREGAMENTO_CODIGO = trim(P_CARREGAMENTO)
                  WHERE EM.ARM_EMBALAGEM_NUMERO    = P_EMBALAGEM_COD
                    AND EM.ARM_EMBALAGEM_FLAG      = trim(P_EMBALAGEM_FLAG)
                    AND EM.ARM_EMBALAGEM_SEQUENCIA = P_EMBALAGEM_SEQ;               
                     
                 Commit;
                         
                 P_STATUS  := Status_Normal;
                 P_MESSAGE := 'Embalagem Associada ao carregamento:'||P_CARREGAMENTO||' COM SUCESSO!';  
               End If;
               
         else
                 UPDATE TDVADM.T_ARM_EMBALAGEM EM
                    SET EM.ARM_CARREGAMENTO_CODIGO = trim(P_CARREGAMENTO)
                  WHERE EM.ARM_EMBALAGEM_NUMERO    = P_EMBALAGEM_COD
                    AND EM.ARM_EMBALAGEM_FLAG      = trim(P_EMBALAGEM_FLAG)
                    AND EM.ARM_EMBALAGEM_SEQUENCIA = P_EMBALAGEM_SEQ;               
                     
                 Commit;
                         
                 P_STATUS  := Status_Normal;
                 P_MESSAGE := 'Embalagem Associada ao carregamento:'||P_CARREGAMENTO||' COM SUCESSO!';          
         end if;      
                    
       Exception WHEN OTHERS THEN
         P_STATUS  := Status_Erro;
         P_MESSAGE := 'Erro ao tentar associar a embalagem ao carregamento, '||Sqlerrm; 
       END; 
          
  END SP_ASSOCIACARREGAMENTO;    
    
  Procedure Sp_ValidaEmbalagem_Veic(pEmbalagem In Tdvadm.t_Arm_Embalagem.Arm_Embalagem_Numero%Type,
                                    pArmazem   In Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type,
                                    pCarreg    Out TdvAdm.t_Arm_Embalagem.Arm_Carregamento_Codigo%Type,
                                    pDestino   Out Tdvadm.t_Glb_Localidade.Glb_Localidade_Descricao%Type,
                                    pIsValid   Out Char,
                                    pStatus    Out Char,
                                    pMessage   Out Varchar2)
  /************************************************************************************************
   * ROTINA           : Sp_ValidaEmbalagem_Veic                                                   *
   * PROGRAMA         : Carregamento Mobile: Carregar Veículo                                     *
   * ANALISTA         : Diego Lírio                                                               *
   * DESENVOLVEDOR    : Diego Lírio                                                               *
   * DATA DE CRIACAO  : 03/10/2011                                                                *
   * ALTERADO POR     :                                                                           *
   * DATA ALTERAÇÃO   :  /  /                                                                     *
   * BANCO            : ORACLE-TDP                                                                *
   * EXECUTADO POR    :                                                                           *
   * ALIMENTA         :                                                                           *
   * FUNCINALIDADE    : Válida Emb, e retorna o carrega vinculado do mesmo... p/ vinculo com veic.*
   * PARTICULARIDADES :                                                                           *
   * PARAM. OBRIGAT.  : pEmbalagem, pArmazem.                                                     *
   ************************************************************************************************/                                      
  Is
  vCount Number;
  vCarreg Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type;
  Begin
    Begin
        
      pIsValid := 'N';
      
       -- Pega o Ultimo Carreg feito para esta Embalagem...
       -- Em caso de Tranferencia Emb poderá ter mais de 1 carregamento na CarregamentoDet!
       Select Max(To_Number(cf.arm_carregamento_codigo))
           Into vCarreg
           from tdvadm.t_arm_carregamentodet cf
           where cf.arm_embalagem_numero = pEmbalagem;      
      
      -- valida se Embalagem é de Origem a ao Armazem selecionado...
      Select Count(*)
         Into vCount
         From tdvadm.t_arm_embalagem emb,
              tdvadm.t_arm_carregamentodet cd,
              tdvadm.t_arm_carregamento c
         Where emb.arm_embalagem_numero    = cd.arm_embalagem_numero
           And emb.arm_embalagem_flag      = cd.arm_embalagem_flag
           And emb.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
           And c.arm_carregamento_codigo   = cd.arm_carregamento_codigo
           and emb.arm_embalagem_numero = pEmbalagem
           And c.arm_carregamento_codigo  = vCarreg
           And c.arm_armazem_codigo        = pArmazem;
  
      If vCount > 0 Then       
      
            -- valida se Embalagem tem Carregamento...
            Select Count(*)
               Into vCount
               From 
                 tdvadm.t_arm_embalagem e,
                 tdvadm.t_arm_carregamentodet det
               Where 
                 0=0
                 And e.arm_embalagem_numero = det.arm_embalagem_numero
                 And e.arm_embalagem_flag   = det.arm_embalagem_flag
                 And e.arm_embalagem_sequencia = det.arm_embalagem_sequencia
                 And nvl(Trim(det.arm_carregamento_codigo), 'R') <> 'R'
                 And det.arm_carregamento_codigo = vCarreg 
                 And e.arm_embalagem_numero = pEmbalagem;
            
              If vCount > 0 Then
                
              -- valida se Embalagem tem conhecimento na série 'X'
               Select 
                 Count(*)
               Into 
                 vCount
                From 
                    tdvadm.t_arm_embalagem   emb,
                    tdvadm.t_arm_carregamentodet  carregdet,
                    tdvadm.t_arm_carregamento ca,
                    Tdvadm.t_Con_Conhecimento co
                 Where 
                    0=0
                    And emb.arm_embalagem_numero = carregdet.arm_embalagem_numero
                    And emb.arm_embalagem_flag   = carregdet.arm_embalagem_flag
                    And emb.arm_embalagem_sequencia = carregdet.arm_embalagem_sequencia
                    And carregdet.arm_carregamento_codigo = ca.arm_carregamento_codigo
                    And co.arm_carregamento_codigo = ca.arm_carregamento_codigo 
                    And co.con_conhecimento_serie <> 'XXX'
                    and ca.arm_carregamento_codigo = vCarreg
                   And emb.arm_embalagem_numero = pEmbalagem;
               
               If vCount > 0 Then
                    -- ToDO...: valida se Embalagem tem carregamento criado no modo Automatico...
                    
                    -- Retona o Carreg Vinculado...!
                    begin
                         Select 
                           trim(det.arm_carregamento_codigo),
                           lo.glb_localidade_descricao
                         Into 
                           pCarreg,
                           pDestino       
                          From 
                             TdvAdm.t_Arm_Embalagem        emb,
                             tdvadm.t_arm_carregamentodet  det,
                             tdvadm.t_arm_cargadet         cargaDet,
                             tdvadm.t_arm_carga            carga,
                             tdvadm.t_glb_localidade       lo
                           Where 
                             0=0
                             And emb.arm_embalagem_numero    = det.arm_embalagem_numero
                             And emb.arm_embalagem_flag      = det.arm_embalagem_flag
                             And emb.arm_embalagem_sequencia = det.arm_embalagem_sequencia
                             And emb.arm_embalagem_numero    = cargaDet.Arm_Embalagem_Numero
                             And emb.arm_embalagem_flag      = cargaDet.Arm_Embalagem_Flag
                             And emb.arm_embalagem_sequencia = cargaDet.Arm_Embalagem_Sequencia 
                             And carga.arm_carga_codigo      = cargaDet.Arm_Carga_Codigo                        
                             And carga.glb_localidade_codigodestino = lo.glb_localidade_codigo
                             and det.arm_carregamento_codigo = vCarreg
                             And emb.arm_embalagem_numero    = pEmbalagem;                       
                     Exception
                       When No_Data_Found Then
                              Begin
                                 Select 
                                     ca.arm_carregamento_codigo,
                                     tc.glb_tpcliend_descricao
                                    Into 
                                       pCarreg,
                                       pDestino 
                                    From 
                                       TdvAdm.t_Arm_Embalagem emb,
                                       Tdvadm.t_Glb_Tpcliend tc,
                                       tdvadm.t_Arm_CarregamentoDet carrDet,
                                       Tdvadm.t_Arm_Carregamento ca
                                    Where emb.glb_tpcliend_coddestinatario = tc.glb_tpcliend_codigo
                                       And Emb.Arm_Embalagem_Numero = carrDet.Arm_Embalagem_Numero
                                       And Emb.Arm_Embalagem_Flag   = carrDet.Arm_Embalagem_Flag
                                       And Emb.Arm_Embalagem_Sequencia = carrDet.Arm_Embalagem_Sequencia
                                       And ca.arm_carregamento_codigo  = carrDet.Arm_Carregamento_Codigo
                                       And ca.arm_carregamento_codigo  = vCarreg       
                                       And emb.arm_embalagem_numero    = pEmbalagem;    
                                   
                                Exception
                                  When No_Data_Found Then
                                     pStatus := 'E';
                                     pMessage := 'Não Encontrado Localidade de Destino';
                                End;
                     End;
                    
                    
                     Select 
                       trim(det.arm_carregamento_codigo)
                     Into 
                       pCarreg
                      From 
                         TdvAdm.t_Arm_Embalagem        emb,
                         tdvadm.t_arm_carregamentodet  det,
                         Tdvadm.t_Arm_Carregamento     ca
                       Where 
                         0=0
                         And emb.arm_embalagem_numero = det.arm_embalagem_numero
                         And emb.arm_embalagem_flag   = det.arm_embalagem_flag
                         And emb.arm_embalagem_sequencia = det.arm_embalagem_sequencia
                         And ca.arm_carregamento_codigo  = det.arm_carregamento_codigo
                         And ca.arm_carregamento_codigo  = vCarreg
                         And emb.arm_embalagem_numero = pEmbalagem;
                       
                    -- Valida se Carregamento ja está Vinculado com veic....   
                    Select Count(*)
                       into vCount
                       from tdvadm.t_arm_carregamentoveic cv
                       where cv.arm_carregamento_codigo = pCarreg;
                    -- Se qtde for Zero Nao tem vinculação do veiculo com o carregamento...!   
                    if vCount <= 0 then                    
                         pIsValid := 'S';
                         pStatus  := Status_Normal;
                         pMessage := 'Embalagem Valida para Selecionar veículo para vinculo';                    
                    else
                         pStatus  := Status_Warning;
                         pMessage := 'Embalagem com Carregamento ['||pCarreg||'] já encontra-se vinculado!';                                        
                    end if;
               Else
                 pStatus := Status_Warning;
                 pMessage := 'Embalagem não tem conhecimento, ou conhecimento não está na Série X';
               End If;
            Else
               pStatus := Status_Warning;
               pMessage := 'Embalagem não contém Carregamento.';
            End If;                        
      Else
        pStatus := Status_Warning;
        pMessage := 'Armazem não permitido para vincular embalagem. Se caso for um carregamento de outra filial, 1verifique se foi dado checking!';
      End If;
     Exception 
       When Others Then
          pStatus := Status_Erro;
          pMessage := Sqlerrm || chr(13) || dbms_utility.format_call_stack;
     End;
  End Sp_ValidaEmbalagem_Veic;                              
  
  Procedure Sp_ValidaEmbalagem_Veic3(pXmlIn     In Varchar2,
                                    pCarreg    Out TdvAdm.t_Arm_Embalagem.Arm_Carregamento_Codigo%Type,
                                    pDestino   Out Tdvadm.t_Glb_Localidade.Glb_Localidade_Descricao%Type,
                                    pIsValid   Out Char,
                                    pStatus    Out Char,
                                    pMessage   Out Varchar2)
  /************************************************************************************************
   * ROTINA           : Sp_ValidaEmbalagem_Veic                                                   *
   * PROGRAMA         : Carregamento Mobile: Carregar Veículo                                     *
   * ANALISTA         : Diego Lírio                                                               *
   * DESENVOLVEDOR    : Diego Lírio                                                               *
   * DATA DE CRIACAO  : 03/10/2011                                                                *
   * ALTERADO POR     :                                                                           *
   * DATA ALTERAÇÃO   :  /  /                                                                     *
   * BANCO            : ORACLE-TDP                                                                *
   * EXECUTADO POR    :                                                                           *
   * ALIMENTA         :                                                                           *
   * FUNCINALIDADE    : Válida Emb, e retorna o carrega vinculado do mesmo... p/ vinculo com veic.*
   * PARTICULARIDADES :                                                                           *
   * PARAM. OBRIGAT.  : pEmbalagem, pArmazem.                                                     *
   ************************************************************************************************/                                      
   
   /*
      <Parametros><Input><BarCode xmlns:barcode="http://www.dellavolpe.com.br"><NotaPINI >1</NotaPINI><NotaSize >8</NotaSize><CNPJPINI >9</CNPJPINI><CNPJSize >14</CNPJSize><VolAtualPINI >23</VolAtualPINI><VolAtualSize >3</VolAtualSize><QtTotVolPINI >26</QtTotVolPINI><QtTotVolSize >3</QtTotVolSize><EmbalPINI >29</EmbalPINI><EmbalSize >6</EmbalSize><Nota>00109458</Nota><CNPJ>18715177000130</CNPJ><VolumeAtual>001</VolumeAtual><QtdeTotalVolume>001</QtdeTotalVolume><Embalagem>235572</Embalagem></BarCode><Armazem>06</Armazem></Input></Parametros>   
   */
  Is
  vCount Number;
  vCarreg Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type;
  vArmazem   tdvadm.t_arm_armazem.arm_armazem_codigo%type;
  vArm   tdvadm.t_arm_armazem.arm_armazem_codigo%type;
 -- vXml       Varchar2(4000);
 vBarcode Barcode;
  Begin
    Begin
        
      pIsValid := 'N';
       
       Select extractvalue(Value(xmlIn), 'Input/BarCode/Embalagem'),
              extractvalue(Value(xmlIn), 'Input/BarCode/Nota'),
              extractvalue(Value(xmlIn), 'Input/BarCode/CNPJ'),
              extractvalue(Value(xmlIn), 'Input/BarCode/VolumeAtual'),
              extractvalue(Value(xmlIn), 'Input/BarCode/QtdeTotalVolume'), 
              extractvalue(Value(xmlIn), 'Input/Armazem')
         Into vBarcode.Embalagem,
              vBarcode.Nota,
              vBarcode.CNPJ,
              vBarcode.Volume,
              vBarcode.VolumeTotal,
              vArmazem
         From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) xmlIn;       
       
       -- ToDo...: Bloquear armazem 06 para teste....
       /*if(vArmazem = '06')then
          pStatus := 'E';
          pMessage := 'Contate o departamento de T.I.';
          return;
       end if;    
         */
       --insert into tdvadm.dropme d(a,x)values('Mobile'||vArmazem||'-'||vBarcode.Nota, pXmlIn);commit;
         
       if(vBarcode.Volume = vBarcode.VolumeTotal) then
            /*************************************************************
            Valida qtde de volumes da Nota...
            Zero (Bloqueia),Maior que Zero é valido
            /*************************************************************/            
            Select Count(*)
              Into vBarcode.Volume
              From tdvadm.t_arm_nota n
              where n.arm_nota_numero = To_Number(vBarcode.Nota)
                and trim(n.glb_cliente_cgccpfremetente) = vBarcode.CNPJ
                and n.arm_nota_qtdvolume = vBarcode.VolumeTotal;
                
            if vBarcode.Volume = 0 then    
                 pStatus := 'N';
                 pMessage := 'Quantidade de volumes incorretos';    
                 return;
            end if;           
       
       end if;
         
       -- Pega o Ultimo Carreg feito para esta Embalagem...
       -- Em caso de Tranferencia Emb poderá ter mais de 1 carregamento na CarregamentoDet!
       Select nvl(Max(To_Number(cf.arm_carregamento_codigo)),'-1')
           Into vCarreg
           from tdvadm.t_arm_carregamentodet cf
           where cf.arm_embalagem_numero = vBarcode.Embalagem;      
       
       if vCarreg = '-1' then
         pStatus := Status_Warning;
         pMessage := 'Embalagem ['||vBarcode.Embalagem||'] não contém carregamento vinculado';
         return;
       end if;       
      
      /*************************************************************
       valida se Embalagem é de Origem a ao Armazem que esta sendo carregado...
       Zero (Bloqueia),Maior que Zero é valido
      /*************************************************************/      

      Select Count(*)
         Into vCount
         From tdvadm.t_arm_embalagem emb,
              tdvadm.t_arm_carregamentodet cd,
              tdvadm.t_arm_carregamento c
         Where emb.arm_embalagem_numero    = cd.arm_embalagem_numero
           And emb.arm_embalagem_flag      = cd.arm_embalagem_flag
           And emb.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
           And c.arm_carregamento_codigo   = cd.arm_carregamento_codigo
           and emb.arm_embalagem_numero = vBarcode.Embalagem
           And c.arm_carregamento_codigo = vCarreg
           And c.arm_armazem_codigo = vArmazem;
  
      If vCount > 0 Then       
      
            -- 
            /*************************************************************
             valida se Embalagem tem Carregamento...
            /*************************************************************/             
            Select Count(*)
               Into vCount
               From 
                 tdvadm.t_arm_embalagem e,
                 tdvadm.t_arm_carregamentodet det
               Where 
                 0=0
                 And e.arm_embalagem_numero = det.arm_embalagem_numero
                 And e.arm_embalagem_flag   = det.arm_embalagem_flag
                 And e.arm_embalagem_sequencia = det.arm_embalagem_sequencia
                 And nvl(Trim(det.arm_carregamento_codigo), 'R') <> 'R'
                 And det.arm_carregamento_codigo = vCarreg 
                 And e.arm_embalagem_numero = vBarcode.Embalagem;
            
              If vCount > 0 Then
                
              -- valida se Embalagem tem conhecimento na série 'X'
               Select 
                 Count(*)
               Into 
                 vCount
                From 
                    tdvadm.t_arm_embalagem   emb,
                    tdvadm.t_arm_carregamentodet  carregdet,
                    tdvadm.t_arm_carregamento ca,
                    Tdvadm.t_Con_Conhecimento co
                 Where 
                    0=0
                    And emb.arm_embalagem_numero = carregdet.arm_embalagem_numero
                    And emb.arm_embalagem_flag   = carregdet.arm_embalagem_flag
                    And emb.arm_embalagem_sequencia = carregdet.arm_embalagem_sequencia
                    And carregdet.arm_carregamento_codigo = ca.arm_carregamento_codigo
                    And co.arm_carregamento_codigo = ca.arm_carregamento_codigo 
                    And co.con_conhecimento_serie <> 'XXX'
                    and ca.arm_carregamento_codigo = vCarreg
                   And emb.arm_embalagem_numero = vBarcode.Embalagem;
               
               If vCount > 0 Then
                    -- ToDo...: valida se Embalagem tem carregamento criado no modo Automatico...
                    
                    -- Retona o Carreg Vinculado...!
                    begin
                         Select 
                           trim(det.arm_carregamento_codigo),
                           lo.glb_localidade_descricao
                         Into 
                           pCarreg,
                           pDestino       
                          From 
                             TdvAdm.t_Arm_Embalagem        emb,
                             tdvadm.t_arm_carregamentodet  det,
                             tdvadm.t_arm_cargadet         cargaDet,
                             tdvadm.t_arm_carga            carga,
                             tdvadm.t_glb_localidade       lo
                           Where 
                             0=0
                             And emb.arm_embalagem_numero    = det.arm_embalagem_numero
                             And emb.arm_embalagem_flag      = det.arm_embalagem_flag
                             And emb.arm_embalagem_sequencia = det.arm_embalagem_sequencia
                             And emb.arm_embalagem_numero    = cargaDet.Arm_Embalagem_Numero
                             And emb.arm_embalagem_flag      = cargaDet.Arm_Embalagem_Flag
                             And emb.arm_embalagem_sequencia = cargaDet.Arm_Embalagem_Sequencia 
                             And carga.arm_carga_codigo      = cargaDet.Arm_Carga_Codigo                        
                             And carga.glb_localidade_codigodestino = lo.glb_localidade_codigo
                             and det.arm_carregamento_codigo = vCarreg
                             And emb.arm_embalagem_numero    = vBarcode.Embalagem;                       
                     Exception
                       When No_Data_Found Then
                              Begin
                                 Select 
                                     ca.arm_carregamento_codigo,
                                     tc.glb_tpcliend_descricao
                                    Into 
                                       pCarreg,
                                       pDestino 
                                    From 
                                       TdvAdm.t_Arm_Embalagem emb,
                                       Tdvadm.t_Glb_Tpcliend tc,
                                       tdvadm.t_Arm_CarregamentoDet carrDet,
                                       Tdvadm.t_Arm_Carregamento ca
                                    Where emb.glb_tpcliend_coddestinatario = tc.glb_tpcliend_codigo
                                       And Emb.Arm_Embalagem_Numero = carrDet.Arm_Embalagem_Numero
                                       And Emb.Arm_Embalagem_Flag   = carrDet.Arm_Embalagem_Flag
                                       And Emb.Arm_Embalagem_Sequencia = carrDet.Arm_Embalagem_Sequencia
                                       And ca.arm_carregamento_codigo  = carrDet.Arm_Carregamento_Codigo
                                       And ca.arm_carregamento_codigo  = vCarreg       
                                       And emb.arm_embalagem_numero    = vBarcode.Embalagem;    
                                   
                                Exception
                                  When No_Data_Found Then
                                     pStatus := 'E';
                                     pMessage := 'Não Encontrado Localidade de Destino';
                                End;
                     End;
                    
                    
                     Select 
                       trim(det.arm_carregamento_codigo)
                     Into 
                       pCarreg
                      From 
                         TdvAdm.t_Arm_Embalagem        emb,
                         tdvadm.t_arm_carregamentodet  det,
                         Tdvadm.t_Arm_Carregamento     ca
                       Where 
                         0=0
                         And emb.arm_embalagem_numero = det.arm_embalagem_numero
                         And emb.arm_embalagem_flag   = det.arm_embalagem_flag
                         And emb.arm_embalagem_sequencia = det.arm_embalagem_sequencia
                         And ca.arm_carregamento_codigo  = det.arm_carregamento_codigo
                         And ca.arm_carregamento_codigo  = vCarreg
                         And emb.arm_embalagem_numero = vBarcode.Embalagem;
                       
                    -- Valida se Carregamento ja está Vinculado com veic....   
                    Select Count(*)
                       into vCount
                       from tdvadm.t_arm_carregamentoveic cv
                       where cv.arm_carregamento_codigo = pCarreg;
                    -- Se qtde for Zero Nao tem vinculação do veiculo com o carregamento...!   
                    if vCount <= 0 then                    
                         pIsValid := 'S';
                         pStatus  := Status_Normal;
                         pMessage := 'Embalagem Valida para Selecionar veículo para vinculo';                    
                    else
                         pStatus  := Status_Warning;
                         pMessage := 'Embalagem com Carregamento ['||vCarreg||'] já encontra-se vinculado!';                                        
                    end if;
               Else
                 pStatus := Status_Warning;
                 pMessage := 'Embalagem não tem conhecimento, ou conhecimento não está na Série X';
               End If;
            Else
               pStatus := Status_Warning;
               pMessage := 'Embalagem não contém Carregamento.';
            End If;                        
      Else
        pStatus := Status_Warning;
        Begin
          Select c.arm_armazem_codigo
            Into vArm
            From tdvadm.t_arm_carregamento c
            where c.arm_carregamento_codigo = vCarreg;
        Exception When No_Data_Found Then
           pStatus := Status_Erro;
        End;
        pMessage := 'Armazem não permitido para vincular embalagem, carregamento['||vCarreg||'] pertence ao armazem['||vArm||']. Se caso for um carregamento de outra filial, 2verifique se foi dado checking!';
      End If;
     Exception 
       When Others Then
          pStatus := Status_Erro;
          pMessage := Sqlerrm || chr(13) || dbms_utility.format_call_stack;
     End;
  End Sp_ValidaEmbalagem_Veic3;   
  


  Procedure Sp_ValidaEmbalagem_Veic(pXmlIn     In Varchar2,
                                    pCarreg    Out TdvAdm.t_Arm_Embalagem.Arm_Carregamento_Codigo%Type,
                                    pDestino   Out Tdvadm.t_Glb_Localidade.Glb_Localidade_Descricao%Type,
                                    pIsValid   Out Char,
                                    pStatus    Out Char,
                                    pMessage   Out Varchar2)
  /************************************************************************************************
   * ROTINA           : Sp_ValidaEmbalagem_Veic                                                   *
   * PROGRAMA         : Carregamento Mobile: Carregar Veículo                                     *
   * ANALISTA         : Diego Lírio                                                               *
   * DESENVOLVEDOR    : Diego Lírio                                                               *
   * DATA DE CRIACAO  : 03/10/2011                                                                *
   * ALTERADO POR     :                                                                           *
   * DATA ALTERAÇÃO   :  /  /                                                                     *
   * BANCO            : ORACLE-TDP                                                                *
   * EXECUTADO POR    :                                                                           *
   * ALIMENTA         :                                                                           *
   * FUNCINALIDADE    : Válida Emb, e retorna o carrega vinculado do mesmo... p/ vinculo com veic.*
   * PARTICULARIDADES :                                                                           *
   * PARAM. OBRIGAT.  : pEmbalagem, pArmazem.                                                     *
   ************************************************************************************************/                                      
   
   /*
      <Parametros><Input><BarCode xmlns:barcode="http://www.dellavolpe.com.br"><NotaPINI >1</NotaPINI><NotaSize >8</NotaSize><CNPJPINI >9</CNPJPINI><CNPJSize >14</CNPJSize><VolAtualPINI >23</VolAtualPINI><VolAtualSize >3</VolAtualSize><QtTotVolPINI >26</QtTotVolPINI><QtTotVolSize >3</QtTotVolSize><EmbalPINI >29</EmbalPINI><EmbalSize >6</EmbalSize><Nota>00109458</Nota><CNPJ>18715177000130</CNPJ><VolumeAtual>001</VolumeAtual><QtdeTotalVolume>001</QtdeTotalVolume><Embalagem>235572</Embalagem></BarCode><Armazem>06</Armazem></Input></Parametros>   
   */
  Is
  

  --vCount Number;
  vCarreg Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type;
  vArmazem   tdvadm.t_arm_armazem.arm_armazem_codigo%type;
  vArm   tdvadm.t_arm_armazem.arm_armazem_codigo%type;
 -- vXml       Varchar2(4000);
 vBarcode Barcode;
 vDadosCritica tpValidaEmbalagem;

  Begin
    Begin
      pStatus  := Status_Normal;  
      pIsValid := 'N';
       
       Select extractvalue(Value(xmlIn), 'Input/BarCode/Embalagem'),
              extractvalue(Value(xmlIn), 'Input/BarCode/Nota'),
              extractvalue(Value(xmlIn), 'Input/BarCode/CNPJ'),
              extractvalue(Value(xmlIn), 'Input/BarCode/VolumeAtual'),
              extractvalue(Value(xmlIn), 'Input/BarCode/QtdeTotalVolume'), 
              extractvalue(Value(xmlIn), 'Input/Armazem')
         Into vBarcode.Embalagem,
              vBarcode.Nota,
              vBarcode.CNPJ,
              vBarcode.Volume,
              vBarcode.VolumeTotal,
              vArmazem
         From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) xmlIn ;

         SELECT n.arm_nota_qtdvolume,
                n.con_conhecimento_codigo,
                n.con_conhecimento_serie,
                n.glb_rota_codigo,
                n.arm_armazem_codigo,
                n.arm_embalagem_numero,
                (Select nvl(Max(To_Number(cf.arm_carregamento_codigo)),'-1')
                 from tdvadm.t_arm_carregamentodet cf
                 where cf.arm_embalagem_numero    = n.arm_embalagem_numero
                   and cf.arm_embalagem_flag      = n.arm_embalagem_flag
                   and cf.arm_embalagem_sequencia = n.arm_embalagem_sequencia)
          Into vDadosCritica.VolumesDaNota,
               vDadosCritica.CTRC,
               vDadosCritica.Serie,
               vDadosCritica.Rota,
               vDadosCritica.ArmazemEmbalagem,
               vDadosCritica.Embalagem, 
               vDadosCritica.Carregamento
         From tdvadm.t_arm_nota n
         where n.arm_nota_numero = To_Number(vBarcode.Nota)
           and trim(n.glb_cliente_cgccpfremetente) = vBarcode.CNPJ;


         begin
           Select 
             pkg_fifo_carregamento.FN_Get_DestEmbalagem(emb.arm_embalagem_numero,
                                                        emb.arm_embalagem_flag,
                                                        emb.arm_embalagem_sequencia,
                                                        'L'),
             cv.arm_carregamentoveic_placa
           Into 
             vDadosCritica.Destino,
             vDadosCritica.Veiculo 
            From 
               TdvAdm.t_Arm_Embalagem        emb,
               tdvadm.t_arm_carregamentodet  det,
               tdvadm.t_arm_carregamentoveic cv
             Where 
               0=0
               And emb.arm_embalagem_numero    = det.arm_embalagem_numero
               And emb.arm_embalagem_flag      = det.arm_embalagem_flag
               And emb.arm_embalagem_sequencia = det.arm_embalagem_sequencia
               and det.arm_carregamento_codigo = vDadosCritica.Carregamento
               and det.arm_carregamento_codigo = cv.arm_carregamento_codigo (+)
               And emb.arm_embalagem_numero    = vBarcode.Embalagem;                       
         Exception
           When No_Data_Found Then
             Begin
                Select 
                  lo.glb_localidade_descricao,
                  cv.arm_carregamentoveic_placa
                  Into 
                    vDadosCritica.Destino,
                    vDadosCritica.Veiculo 
                  From 
                     TdvAdm.t_Arm_Embalagem emb,
                     Tdvadm.t_Glb_cliend tc,
                     tdvadm.t_Arm_CarregamentoDet carrDet,
                     Tdvadm.t_Arm_Carregamento ca,
                     tdvadm.t_arm_carregamentoveic cv,
                     tdvadm.t_glb_localidade lo
                  Where emb.glb_tpcliend_coddestinatario = tc.glb_tpcliend_codigo
                     and emb.glb_cliente_cgccpfdestinatario = tc.glb_cliente_cgccpfcodigo
                     And Emb.Arm_Embalagem_Numero = carrDet.Arm_Embalagem_Numero
                     And Emb.Arm_Embalagem_Flag   = carrDet.Arm_Embalagem_Flag
                     And Emb.Arm_Embalagem_Sequencia = carrDet.Arm_Embalagem_Sequencia
                     And ca.arm_carregamento_codigo  = carrDet.Arm_Carregamento_Codigo
                     And ca.arm_carregamento_codigo  = vDadosCritica.Carregamento       
                     and tc.glb_localidade_codigo = lo.glb_localidade_codigo
                     and carrDet.arm_carregamento_codigo = cv.arm_carregamento_codigo (+)
                     And emb.arm_embalagem_numero    = vBarcode.Embalagem;    
                                   
             Exception
                When No_Data_Found Then
                   pStatus := 'E';
                   pMessage := pMessage || chr(10) || 'Não Encontrado Localidade de Destino para Embalagem [' || vBarcode.Embalagem ||']';
             End;
         End;

       if vBarcode.Embalagem  <> vDadosCritica.Embalagem then
          pStatus := 'E';
          pMessage :=  pMessage || chr(10) || 'Embalagem não pertence a Nota';    
          return;
         
       end if;
       if(vBarcode.Volume = vBarcode.VolumeTotal) then
            /*************************************************************
            Valida qtde de volumes da Nota...
            Zero (Bloqueia),Maior que Zero é valido
            /*************************************************************/            
            if vDadosCritica.VolumesDaNota <> vBarcode.VolumeTotal then    
                 pStatus := 'E';
                 pMessage :=  pMessage || chr(10) || 'Quantidade de volumes incorretos';    
                 return;
            end if;           
       
       end if;
         
       -- Pega o Ultimo Carreg feito para esta Embalagem...
       -- Em caso de Tranferencia Emb poderá ter mais de 1 carregamento na CarregamentoDet!
     
       if vDadosCritica.Carregamento = '-1' then
         if pStatus <> Status_Erro Then
            pStatus := Status_Warning;
         End if;   
         pMessage :=  pMessage || chr(10) || 'Embalagem ['||vBarcode.Embalagem||'] não contém carregamento vinculado';
         return;
       end if;       
      
      /*************************************************************
       valida se Embalagem é de Origem a ao Armazem que esta sendo carregado...
       Zero (Bloqueia),Maior que Zero é valido
      /*************************************************************/      


      If vDadosCritica.ArmazemEmbalagem = vArmazem Then       
      
            -- 
            /*************************************************************
             valida se Embalagem tem Carregamento...
            /*************************************************************/             
           
           if pStatus <> Status_Erro Then
           If vDadosCritica.Carregamento <> -1 Then
                
              -- valida se Embalagem tem conhecimento 
               
               If ( vDadosCritica.CTRC is not null )  and ( vDadosCritica.Serie <> 'XXX' ) Then
                    -- ToDo...: valida se Embalagem tem carregamento criado no modo Automatico...
                    
                    -- Se qtde for Zero Nao tem vinculação do veiculo com o carregamento...!   
                    if vDadosCritica.Veiculo is null then                    
                         pIsValid := 'S';
                            pStatus  := Status_Normal;
                            pMessage :=  pMessage || chr(10) || 'Embalagem Valida';                    
                    else
                         pStatus  := Status_Warning;
                         pMessage :=  pMessage || chr(10) || 'Embalagem com Carregamento ['||vDadosCritica.Carregamento ||'] já encontra-se vinculado!';                                        
                    end if;
               Else
                 pStatus := Status_Warning;
                 pMessage :=  pMessage || chr(10) || 'Embalagem não tem conhecimento, ou conhecimento está na Série X';
               End If;
            Else
               pStatus := Status_Warning;
               pMessage :=  pMessage || chr(10) || 'Embalagem não contém Carregamento.';
            End If;                        
          end if;  
      Else
        pStatus := Status_Warning;
        pMessage :=  pMessage || chr(10) || 'Armazem não permitido para vincular embalagem, carregamento['||vCarreg||'] pertence ao armazem['||vArm||']. Se caso for um carregamento de outra filial, 3verifique se foi dado checking!';
      End If;
     Exception 
       When Others Then
          pStatus := Status_Erro;
          pMessage := Sqlerrm || chr(13) || dbms_utility.format_call_stack;
     End;
     
     pCarreg  := vDadosCritica.Carregamento;
     pDestino := vDadosCritica.Destino;

     
  End Sp_ValidaEmbalagem_Veic;   

  Procedure Sp_Get_EmbNotasNaoCarregadas(pArmazem in t_arm_embalagem.arm_armazem_codigo%type,
                                         pCursor  Out Types.cursorType)
  As
  Begin
       Open pCursor For
          Select 
                  --Distinct 
                  loc.glb_localidade_codigo,
                  Trim(loc.glb_localidade_descricao) glb_localidade_descricao,
                  Count(*) qtde
                From 
                  t_arm_nota nota,
                  t_arm_cargadet det,
                  t_glb_cliend enddest,
                  t_glb_localidade loc
                Where
                  0=0
                  And nota.arm_armazem_codigo = pArmazem
                  --And Trunc(nota.arm_nota_dtrecebimento) >= to_date(vParamsXml('dataInicial').value, 'dd/mm/yyyy')
                  --And Trunc(nota.arm_nota_dtrecebimento) <= to_date(vParamsXml('dataFinal').value, 'dd/mm/yyyy')
                  And nota.arm_nota_numero = det.arm_nota_numero
                  And nota.arm_nota_sequencia = det.arm_nota_sequencia
                        
                  And Trim(nota.glb_cliente_cgccpfdestinatario) = Trim(enddest.glb_cliente_cgccpfcodigo)
                  And nota.glb_tpcliend_coddestinatario = enddest.glb_tpcliend_codigo
                        
                  And loc.glb_localidade_codigo = enddest.glb_localidade_codigo
                        
                  And 0 = ( Select Count(*) From t_arm_carregamentodet carregdet
                             Where carregdet.arm_embalagem_numero = det.arm_embalagem_numero
                               And carregdet.arm_embalagem_flag = det.arm_embalagem_flag
                               And carregdet.arm_embalagem_sequencia = det.arm_embalagem_sequencia
                          ) 
                   Group By loc.glb_localidade_codigo,
                            Trim(loc.glb_localidade_descricao);     
  End;                                         
  
  -- New 06/02/2014
  Function Fn_To_DevolucaoData(pXmlIn   in  Varchar2) return DevolucaoData
  As
  vDevolucaoData DevolucaoData;
  Begin

       FOR R_CURSOR In (Select extractvalue(Value(V), 'Input/Nota') Nota,
                               extractvalue(Value(V), 'Input/CNPJ') CNPJ,
                               extractvalue(Value(V), 'Input/Sequencia') Sequencia,
                               extractvalue(Value(V), 'Input/Chave') Chave,
                               extractvalue(Value(V), 'Input/TipoDevolucao') TipoDevolucao,
                               extractvalue(Value(V), 'Input/PagtoFrete') PagtoFrete,
                               extractvalue(Value(V), 'Input/LocalRecusa') LocalRecusa,
                               extractvalue(Value(V), 'Input/Motivo') Motivo,
                               extractvalue(Value(V), 'Input/Coleta') Coleta,
                               extractvalue(Value(V), 'Input/Coleta_Original') Coleta_Original,
                               extractvalue(Value(V), 'Input/IDOcorrencia') IDOcorrencia,
                               extractvalue(Value(V), 'Input/Ref') Ref,
                               extractvalue(Value(V), 'Input/CodigoRef') CodigoRef,
                               extractvalue(Value(V), 'Input/Entrega') Entrega,
                               extractvalue(Value(V), 'Input/Observacao') Observacao,
                               extractvalue(Value(V), 'Input/Usuario') Usuario,
                               extractvalue(Value(V), 'Input/Rota') Rota,
                               extractvalue(Value(V), 'Input/Aplicacao') Aplicacao,
                               extractvalue(Value(V), 'Input/Versao') Versao,
                               extractvalue(Value(V), 'Input/ConheciementoCodigo') ConheciementoCodigo,
                               extractvalue(Value(V), 'Input/ConheciementoSerie') ConheciementoSerie,
                               extractvalue(Value(V), 'Input/Valor') Valor,
                               extractvalue(Value(V), 'Input/ConheciementoRota') ConheciementoRota                              
             From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V )
             Loop
                 vDevolucaoData.Nota          := R_CURSOR.NOTA;
                 vDevolucaoData.CNPJ          := R_CURSOR.CNPJ;
                 vDevolucaoData.Seq           := R_CURSOR.SEQUENCIA;
                 vDevolucaoData.Chave         := R_CURSOR.CHAVE;
                 vDevolucaoData.TipoDevolucao := R_CURSOR.Tipodevolucao;
                 vDevolucaoData.PagtoFrete    := R_CURSOR.Pagtofrete;
                 vDevolucaoData.LocalRecusa   := R_CURSOR.Localrecusa;
                 vDevolucaoData.Motivo        := R_CURSOR.Motivo;
                 vDevolucaoData.Coleta        := substr(R_CURSOR.Coleta,1,6);
                 vDevolucaoData.ColetaOrig    := R_CURSOR.Coleta_Original;
                 vDevolucaoData.IDOcorrencia  := R_CURSOR.Idocorrencia;
                 vDevolucaoData.Ref           := R_CURSOR.Ref;
                 vDevolucaoData.CodigoRef     := R_CURSOR.Codigoref;
                 vDevolucaoData.Entrega       := R_CURSOR.Entrega;
                 vDevolucaoData.Observacao    := R_CURSOR.Observacao;
                 vDevolucaoData.Usuario       := R_CURSOR.Usuario;
                 vDevolucaoData.RotaUSU       := R_CURSOR.Rota;
                 vDevolucaoData.Aplicacao     := R_CURSOR.Aplicacao;
                 vDevolucaoData.Versao        := R_CURSOR.Versao;
                 vDevolucaoData.Cte           := R_CURSOR.Conheciementocodigo;
                 vDevolucaoData.RtCte         := R_CURSOR.CONHECIEMENTOROTA;
                 vDevolucaoData.SrCte         := R_CURSOR.CONHECIEMENTOSERIE;
                 vDevolucaoData.Valor         := Replace(R_CURSOR.Valor,',','.');
                 

             End Loop; 

       
             
             if nvl(vDevolucaoData.Motivo,-9) = -9 then
                vDevolucaoData.Motivo := vDevolucaoData.IDOcorrencia;
             Else
                vDevolucaoData.IDOcorrencia := vDevolucaoData.Motivo;
             End If;   
             
             BEGIN
             SELECT A.ARM_ARMAZEM_CODIGO
               INTO vDevolucaoData.ArmazemUSU
             FROM T_ARM_ARMAZEM A
             WHERE A.GLB_ROTA_CODIGO = vDevolucaoData.RotaUSU;  
             EXCEPTION
               WHEN OTHERS THEN
                  vDevolucaoData.ArmazemUSU := 'X';
               END ;
             
        return vDevolucaoData;    
  End Fn_To_DevolucaoData;

  Procedure Sp_Devolver_EmbalagemNF(pXmlIn   in  Varchar2,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2)
  As
  vDevolucaoData DevolucaoData;
  tpRegNotaCte   tdvadm.t_arm_notacte%rowtype;
  tpCarreg       tdvadm.t_arm_carregamento%rowtype;
  tpCarregDet    tdvadm.t_arm_carregamentodet%rowtype;
  tpArmNota      tdvadm.t_arm_nota%rowtype;
  vCarregAnt     tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
  vLocTemporaria tdvadm.t_arm_notacte.glb_localidade_codigoorigem%type;
  vAuxiliar      number;
  vAuxiliarc     varchar2(50);
  
  Begin

     
--     insert into t_glb_sql s values (pXmlIn,sysdate,'DEVOLUCAOREE','DEVOLUCAOREE');
--     commit;

     IF (tdvadm.fn_glb_pegaparametro) THEN 
        insert into t_glb_sql s values (pXmlIn,sysdate,'DEVOLUCAOREE','DEVOLUCAOREE');
        commit; 
     END if;

     Begin
--        insert into dropme (a,l) values('LucasEmbalagem', pXmlIn );
--        commit;
        vDevolucaoData := Fn_To_DevolucaoData(/*PKG_GLB_COMMON.FN_LIMPA_CAMPO(*/pXmlIn/*)*/);
     Exception
       When Others Then
--         insert into t_glb_sql s values (pXmlIn,sysdate,'DEVOLUCAOERRO','DEVOLUCAOERRO');
--         commit;
         pStatus := 'E';
         pMessage := 'Erro ao Pegar dados do Xml de Entrada: ' || Chr(13) || pXmlIn || Chr(13) || sqlerrm;
         return;
     End;    


   
     
  /* exembplo do XML de Entrada

    <Parametros><Input><Nota>469359</Nota><CNPJ>33000092003850</CNPJ><Sequencia>1661149</Sequencia><Chave>33140433000092003850550010004693591736221888</Chave><TipoDevolucao>R</TipoDevolucao><Coleta_Original>422409</Coleta_Original><Usuario>bbernardo</Usuario><Rota>bbernardo</Rota><Aplicacao>carreg</Aplicacao><Versao>14.5.8.2</Versao></Input></Parametros

        Xml de Entrada Devolução:
        <Parametros>
           <Input>
              <Nota>469359</Nota>
              <CNPJ>33000092003850</CNPJ>
              <Sequencia>1661149</Sequencia>
              <Chave>33140433000092003850550010004693591736221888</Chave>
              <TipoDevolucao>R</TipoDevolucao>
              <Coleta_Original>422409</Coleta_Original>
              <PagtoFrete>D</PagtoFrete>
              <LocalRecusa>NF</LocalRecusa>
              <IDOcorrencia>13</IDOcorrencia>
              <Coleta>1</Coleta>
              <Ref>T</Ref>
           </Input>
        </Parametros>

        <Parametros>
           <Input>
              <TipoDevolucao>D</TipoDevolucao> -- Devolucao
              <Nota>635041</Nota>
              <CNPJ>61077327000156</CNPJ>
              <Sequencia>1671663</Sequencia>
              <Chave>35140561077327000156550010006350411162045730</Chave>
              <PagtoFrete>D</PagtoFrete>
              <Ref>T</Ref>
              <CodigoRef>99</CodigoRef>
              <IDOcorrencia>6</IDOcorrencia>
              <Coleta>436983</Coleta>
              <Entrega>04</Entrega> -- Aramazem se Vazio é Direta
              <Observacao>aaaaaaaa</Observacao>
              <Usuario>bbernardo</Usuario>
              <Rota>021</Rota>
              <Aplicacao>carreg</Aplicacao>
              <Versao>14.5.8.2</Versao>
           </Input>
        </Parametros>

        <Parametros>
           <Input>
              <TipoDevolucao>R</TipoDevolucao> -- Reentrega
              <Nota>579926</Nota>
              <CNPJ>44357085000135</CNPJ>
              <Sequencia>1671589</Sequencia>
              <Chave>35140544357085000135550010005799261640812230</Chave>
              <PagtoFrete>D</PagtoFrete>
              <Ref>T</Ref>
              <CodigoRef>99</CodigoRef>
              <IDOcorrencia>4</IDOcorrencia>
              <Coleta>437503</Coleta>
              <LocalRecusa>CT</LocalRecusa>
              <Observacao>aaayyyy</Observacao>
              <Usuario>bbernardo</Usuario>
              <Rota>021</Rota>
              <Aplicacao>carreg</Aplicacao>
              <Versao>14.5.8.2</Versao>
           </Input>
        </Parametros>;
  
  
  */


      if vDevolucaoData.TipoDevolucao in ('D', -- Devolucao
                                          'R', -- Rentrega
                                          'C', -- Complemento
                                          'E', -- Remoção
--                                          'F', -- Fornecedor
                                          'X' -- nada
                                          ) then
            pStatus := 'N'; 
            pMessage := '';

            tpRegNotaCte.Arm_Nota_Sequencia           := vDevolucaoData.Seq;
            tpRegNotaCte.Arm_Nota_Chavenfe            := vDevolucaoData.Chave;
            tpRegNotaCte.Arm_Nota_Numero              := vDevolucaoData.Nota;
            tpRegNotaCte.Glb_Cliente_Cgccpfremetente  := vDevolucaoData.CNPJ;
            tpRegNotaCte.Arm_Notacte_Valor            := vDevolucaoData.Valor;

            tpRegNotaCte.Arm_Coleta_Ncompra           := vDevolucaoData.Coleta;
             -- Se não foi passada a Coleta, pega a anterior
            If tpRegNotaCte.Arm_Coleta_Ncompra is null Then
               select nc.arm_coleta_ncompra
                 into tpRegNotaCte.Arm_Coleta_Ncompra
               from tdvadm.t_arm_notacte nc
               where nc.arm_notacte_codigo = 'NO'
                 and nc.arm_nota_numero = tpRegNotaCte.Arm_Nota_Numero
                 and nc.glb_cliente_cgccpfremetente = tpRegNotaCte.Glb_Cliente_Cgccpfremetente;
            End If;
            
            tpRegNotaCte.Arm_Nota_Tabsol    := vDevolucaoData.Ref;
            tpRegNotaCte.Arm_Nota_Tabsolcod := lpad(vDevolucaoData.CodigoRef,8,'0');
            Begin
                If nvl(tpRegNotaCte.Arm_Nota_Tabsol,'S') = 'S' Then
                   select max(sf.slf_solfrete_saque)
                     into tpRegNotaCte.Arm_Nota_Tabsolsq
                   from tdvadm.t_slf_solfrete sf
                   where sf.slf_solfrete_codigo = tpRegNotaCte.Arm_Nota_Tabsolcod
                     and sf.slf_solfrete_vigencia <= trunc(sysdate)
                     and sf.slf_solfrete_dataefetiva >= trunc(sysdate)
                     and nvl(sf.slf_solfrete_status,'N') = 'N';
                Else
                   select max(ta.slf_tabela_saque)
                     into tpRegNotaCte.Arm_Nota_Tabsolsq
                   from tdvadm.t_slf_tabela ta
                   where ta.slf_tabela_codigo = tpRegNotaCte.Arm_Nota_Tabsolcod
                     and nvl(ta.slf_tabela_status,'N') = 'N'
                     and ta.slf_tabela_vigencia = (select max(ta1.slf_tabela_vigencia)
                                                   from tdvadm.t_slf_tabela ta1
                                                   where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                     and nvl(ta1.slf_tabela_status,'N') = 'N'
                                                     and ta1.slf_tabela_vigencia <= trunc(sysdate));
                End If;
            exception
              When NO_DATA_FOUND Then
                 tpRegNotaCte.Arm_Nota_Tabsol := null;
                 tpRegNotaCte.Arm_Nota_Tabsolcod := null;
                 tpRegNotaCte.Arm_Nota_Tabsolsq := null;
              End ;
            -- Se nao foi passado uma Tabale ou Solicitação usa a Anterior 
/*           If tpRegNotaCte.Arm_Nota_Tabsolcod is null Then
               select nc.arm_nota_tabsol,
                      nc.arm_nota_tabsolcod
                 into tpRegNotaCte.Arm_Nota_Tabsol,
                      tpRegNotaCte.Arm_Nota_Tabsolcod 
               from tdvadm.t_arm_notacte nc
               where nc.arm_notacte_codigo = 'NO'
                 and nc.arm_nota_numero = tpRegNotaCte.Arm_Nota_Numero
                 and nc.glb_cliente_cgccpfremetente = tpRegNotaCte.Glb_Cliente_Cgccpfremetente;
            End If;
*/
            select max(co.arm_coleta_ciclo)
               into tpRegNotaCte.Arm_Coleta_Ciclo
            from t_arm_coleta co
            where co.arm_coleta_ncompra = LPAD(trim(tpRegNotaCte.Arm_Coleta_Ncompra),6,'0');  
            
            if vDevolucaoData.TipoDevolucao not in ('F') Then
               If nvl( tpRegNotaCte.Arm_Coleta_Ciclo,'999') = '999' Then
                  pMessage := pMessage || 'Coleta não Enconctrada ... ' || chr(10);
                  pStatus := pkg_glb_common.Status_Warning;
               End If;
            End If;

            If nvl(vDevolucaoData.Coleta,'000000') <> '000000' Then
               Begin
                 select ce.glb_localidade_codigo,
                        cc.glb_localidade_codigo
                    into tpRegNotaCte.Glb_Localidade_Codigodestino,
                         tpRegNotaCte.Glb_Localidade_Codigoorigem
                 from t_arm_coleta co,
                      t_glb_cliend ce,
                      t_glb_cliend cc
                 where co.arm_coleta_ncompra = LPAD(trim(tpRegNotaCte.Arm_Coleta_Ncompra),6,'0')
                   and co.arm_coleta_ciclo   = tpRegNotaCte.Arm_Coleta_Ciclo
                   and co.glb_cliente_cgccpfcodigoentreg = ce.glb_cliente_cgccpfcodigo
                   and co.glb_tpcliend_codigoentrega     = ce.glb_tpcliend_codigo   
                   and co.glb_cliente_cgccpfcodigocoleta = cc.glb_cliente_cgccpfcodigo
                   and co.glb_tpcliend_codigocoleta      = cc.glb_tpcliend_codigo;   
                Exception
                  When NO_DATA_FOUND Then
                     tpRegNotaCte.Glb_Localidade_Codigodestino := null;
                     tpRegNotaCte.Glb_Localidade_Codigoorigem  := null;
                     pMessage := pMessage || 'Coleta Não Existe ... ' || chr(10);
--                     pStatus := pkg_glb_common.Status_Erro;
                     pStatus := pkg_glb_common.Status_Warning;
                  End ;
            End If;


            tpRegNotaCte.Usu_Usuario_Codigo           := 'jsantos';
            tpRegNotaCte.Arm_Notacte_Pagadorfrete     := vDevolucaoData.PagtoFrete;

            Begin 
                if tpRegNotaCte.Arm_Notacte_Pagadorfrete in  ('D') Then
                    -- Devolucao
                    if tpRegNotaCte.Glb_Localidade_Codigoorigem is null Then
                        Select an.arm_nota_serie,
                               an.glb_cliente_cgccpfdestinatario,
                               an.glb_localidade_codigoorigem ,
                               ce.glb_localidade_codigo DestinoOriginal
                          into tpRegNotaCte.Arm_Nota_Serie,
                               tpRegNotaCte.Glb_Cliente_Cgccpfsacado,
                               tpRegNotaCte.Glb_Localidade_Codigoorigem,
                               tpRegNotaCte.Glb_Localidade_Codigodestino
                        From t_arm_nota an,
                             t_glb_cliend ce
                        Where an.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia
                          and rpad(an.glb_cliente_cgccpfdestinatario,20) = ce.glb_cliente_cgccpfcodigo
                          and an.glb_tpcliend_coddestinatario = ce.glb_tpcliend_codigo;
                    Else
                        Select an.arm_nota_serie,
                               an.glb_cliente_cgccpfdestinatario
                          into tpRegNotaCte.Arm_Nota_Serie,
                               tpRegNotaCte.Glb_Cliente_Cgccpfsacado
                        From t_arm_nota an
                        Where an.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia;
                    End If;    
                ElsIf tpRegNotaCte.Arm_Notacte_Pagadorfrete in ('R') Then
                    if tpRegNotaCte.Glb_Localidade_Codigoorigem is null Then
                        Select an.arm_nota_serie,
                               an.glb_cliente_cgccpfremetente,
                               an.glb_localidade_codigoorigem ,
                               ce.glb_localidade_codigo DestinoOriginal
                          into tpRegNotaCte.Arm_Nota_Serie,
                               tpRegNotaCte.Glb_Cliente_Cgccpfsacado,
                               tpRegNotaCte.Glb_Localidade_Codigoorigem,
                               tpRegNotaCte.Glb_Localidade_Codigodestino
                        From t_arm_nota an,
                             t_glb_cliend ce
                        Where an.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia
                          and rpad(an.glb_cliente_cgccpfremetente,20) = ce.glb_cliente_cgccpfcodigo
                          and an.glb_tpcliend_codremetente = ce.glb_tpcliend_codigo;
                    Else
                        Select an.arm_nota_serie,
                               an.glb_cliente_cgccpfremetente
                          into tpRegNotaCte.Arm_Nota_Serie,
                               tpRegNotaCte.Glb_Cliente_Cgccpfsacado
                        From t_arm_nota an
                        Where an.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia;
                    End If;    
                ElsIf tpRegNotaCte.Arm_Notacte_Pagadorfrete = 'S' Then
                    if tpRegNotaCte.Glb_Localidade_Codigoorigem is null Then
                        Select an.arm_nota_serie,
                               an.glb_cliente_cgccpfsacado,
                               an.glb_localidade_codigoorigem ,
                               ce.glb_localidade_codigo DestinoOriginal
                          into tpRegNotaCte.Arm_Nota_Serie,
                               tpRegNotaCte.Glb_Cliente_Cgccpfsacado,
                               tpRegNotaCte.Glb_Localidade_Codigoorigem,
                               tpRegNotaCte.Glb_Localidade_Codigodestino
                        From t_arm_nota an,
                             t_glb_cliend ce
                        Where an.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia
                          and rpad(an.glb_cliente_cgccpfsacado,20) = ce.glb_cliente_cgccpfcodigo
                          and an.glb_tpcliend_codsacado = ce.glb_tpcliend_codigo;
                    Else
                        Select an.arm_nota_serie,
                               an.glb_cliente_cgccpfsacado
                          into tpRegNotaCte.Arm_Nota_Serie,
                               tpRegNotaCte.Glb_Cliente_Cgccpfsacado
                        From t_arm_nota an
                        Where an.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia;
                    End If;    
                Else
--                  if vDevolucaoData.TipoDevolucao not in ('C', 'E') Then
                     pMessage := pMessage || 'Pagador do frete Não Informado ... ' || chr(10);
                     pStatus := pkg_glb_common.Status_Erro;
--                  End If;
                End If;
            exception
              When NO_DATA_FOUND then
                  pMessage := pMessage || 'Problemas para localizar a nota... '  || tpRegNotaCte.Arm_Nota_Numero || '-' || tpRegNotaCte.Glb_Cliente_Cgccpfremetente || '-' || tpRegNotaCte.Arm_Nota_Serie || '-' || tpRegNotaCte.Arm_Nota_Sequencia || chr(10);
                  pStatus := pkg_glb_common.Status_Erro;
              End ;
            
            if vDevolucaoData.TipoDevolucao not in ('C', 'E') Then
                if tpRegNotaCte.Glb_Localidade_Codigoorigem is null Then
                   pMessage := pMessage || 'Não foi possivel definir a ORIGEM ... ' || chr(10);
                   pStatus := pkg_glb_common.Status_Erro;
                End If;

                if tpRegNotaCte.Glb_Localidade_Codigodestino is null Then
                   pMessage := pMessage || 'Não foi possivel definir a DESTINO ... ' || chr(10);
                   pStatus := pkg_glb_common.Status_Erro;
                End If;
            End If;

            
             -- Inseri a nota principal na tabela de Controle
             -- sempre tem que existir uma NO
            insert into t_arm_notacte 
            select * 
            from v_arm_carreganotacte n
            where n.arm_nota_numero = tpRegNotaCte.Arm_Nota_Numero 
              and n.glb_cliente_cgccpfremetente = trim(tpRegNotaCte.Glb_Cliente_Cgccpfremetente)
              AND N.arm_notacte_codigo = 'NO'
              and 0 = (select count(*)
                       from t_arm_notacte ncte
                       where ncte.arm_nota_numero = n.arm_nota_numero
                         AND ncte.arm_notacte_codigo = 'NO'
                         and ncte.glb_cliente_cgccpfremetente = rpad(n.glb_cliente_cgccpfremetente,20));
                         
            begin
                  select n.con_conhecimento_codigo,
                         n.con_conhecimento_serie,
                         n.glb_rota_codigo
                       into tpRegNotaCte.Con_Conhecimento_Codigoa,
                            tpRegNotaCte.Con_Conhecimento_Seriea,
                            tpRegNotaCte.Glb_Rota_Codigoa
                    from t_con_nftransporta n,
                         t_con_conhecimento c
                  where n.con_nftransportada_chavenfe = tpRegNotaCte.Arm_Nota_Chavenfe
                    and n.con_conhecimento_codigo = c.con_conhecimento_codigo
                    and n.con_conhecimento_serie = c.con_conhecimento_serie
                    and n.glb_rota_codigo = c.glb_rota_codigo
                    and c.con_conhecimento_flagcancelado is null
                    and n.con_conhecimento_serie <> 'XXX'
                    and 1 = (select count(*)
                             from t_arm_notacte cte
                             where cte.arm_nota_chavenfe = tpRegNotaCte.Arm_Nota_Chavenfe
                               and cte.arm_notacte_codigo = 'NO');
              
            exception
              when too_many_rows then
                  raise_application_error(-20000,'Nota Já Foi Utilizada em 2 Conhecimentos');
              WHEN NO_DATA_FOUND Then
                  begin  
                      select n.con_conhecimento_codigo,
                             n.con_conhecimento_serie,
                             n.glb_rota_codigo
                           into tpRegNotaCte.Con_Conhecimento_Codigoa,
                                tpRegNotaCte.Con_Conhecimento_Seriea,
                                tpRegNotaCte.Glb_Rota_Codigoa
                        from t_con_nftransporta n,
                             t_con_conhecimento c
                      where n.con_nftransportada_numnfiscal = lpad(tpRegNotaCte.Arm_Nota_Numero,9,'0')  
                        and n.glb_cliente_cgccpfcodigo = tpRegNotaCte.Glb_Cliente_Cgccpfremetente
                        and trim(n.con_nftransportada_serienf) = trim(tpRegNotaCte.Arm_Nota_Serie)
                        and n.con_conhecimento_codigo = c.con_conhecimento_codigo
                        and n.con_conhecimento_serie = c.con_conhecimento_serie
                        and n.glb_rota_codigo = c.glb_rota_codigo
                        and c.con_conhecimento_flagcancelado is null
                        and n.con_conhecimento_serie <> 'XXX'
                        and 1 = (select count(*)
                                 from t_arm_notacte cte
                                 where cte.arm_nota_numero = tpRegNotaCte.Arm_Nota_Numero
                                   and cte.glb_cliente_cgccpfremetente = tpRegNotaCte.Glb_Cliente_Cgccpfremetente
                                   and cte.arm_nota_serie = tpRegNotaCte.Arm_Nota_Serie
                                   and cte.arm_notacte_codigo = 'NO');
                   exception
                     
                     When NO_DATA_FOUND Then 
                        
                          begin
                              Select to_char(nt.arm_nota_dtinclusao,'DD/MM/YYYY')
                                into vAuxiliarc 
                                from t_Arm_Nota nt
                               where nt.arm_nota_numero = tpRegNotaCte.Arm_Nota_Numero
                                 and nt.glb_cliente_cgccpfremetente = trim(tpRegNotaCte.Glb_Cliente_Cgccpfremetente)
                                 and nt.arm_nota_serie  = tpRegNotaCte.Arm_Nota_Serie
                                 and nt.arm_nota_chavenfe = tpRegNotaCte.Arm_Nota_Chavenfe;
                                
                              tpRegNotaCte.Con_Conhecimento_Codigo := null;
                              tpRegNotaCte.Con_Conhecimento_Serie  := null;
                              tpRegNotaCte.Glb_Rota_Codigo         := null;
                              pMessage := pMessage || 'CTe não encontrado para a Nota... Informado  ou Nota não faz parte do processo de devolução "Nota antiga" data de inclusão: '|| trim(vAuxiliarc) || '  ' || tpRegNotaCte.Con_Conhecimento_Codigoa || tpRegNotaCte.Con_Conhecimento_Seriea|| tpRegNotaCte.Glb_Rota_Codigoa || chr(10);
                              pStatus := pkg_glb_common.Status_Erro;
                          exception when others then
                                raise_application_error(-20010,'Erro!' || chr(13) || 'Arm_Nota_Numero: ' || tpRegNotaCte.Arm_Nota_Numero || chr(13) || 'tpRegNotaCte.Glb_Cliente_Cgccpfremetente: ' || tpRegNotaCte.Glb_Cliente_Cgccpfremetente ||  chr(13) || 'tpRegNotaCte.Arm_Nota_Serie: ' || tpRegNotaCte.Arm_Nota_Serie || chr(13) || 'tpRegNotaCte.Arm_Nota_Chavenfe: ' || tpRegNotaCte.Arm_Nota_Chavenfe || CHR(13) || SQLERRM );
                          end;
                            
                     End;
            End;

            If tpRegNotaCte.Arm_Nota_Tabsol = 'T' Then
               select MAX(T.SLF_TABELA_SAQUE)
                 into tpRegNotaCte.Arm_Nota_Tabsolsq
               From T_SLF_TABELA T  
               Where T.slf_tabela_codigo = tpRegNotaCte.Arm_Nota_Tabsolcod;
            ElsIf tpRegNotaCte.Arm_Nota_Tabsol = 'S' Then
               select MAX(T.SLF_SOLFRETE_SAQUE)
                 into tpRegNotaCte.Arm_Nota_Tabsolsq
               From T_SLF_SOLFRETE T  
               Where T.Slf_Solfrete_Codigo = tpRegNotaCte.Arm_Nota_Tabsolcod;
            Else
                tpRegNotaCte.Arm_Nota_Tabsol    := null;
                tpRegNotaCte.Arm_Nota_Tabsolcod := null;
                tpRegNotaCte.Arm_Nota_Tabsolsq  := null;
            End If;    
            
            if nvl(tpRegNotaCte.Arm_Nota_Tabsolcod,'000000') = '000000' Then
                tpRegNotaCte.Arm_Nota_Tabsol    := null;
                tpRegNotaCte.Arm_Nota_Tabsolcod := null;
                tpRegNotaCte.Arm_Nota_Tabsolsq  := null;
            End If;

            tpRegNotaCte.Arm_Notacte_Dtgravacao       := sysdate;
            tpRegNotaCte.Glb_Ocorr_Id                 := vDevolucaoData.IDOcorrencia;
            
            if vDevolucaoData.TipoDevolucao not in ('C', 'E') Then
                if tpRegNotaCte.Glb_Ocorr_Id is null Then
                   pMessage := pMessage || 'Ocorrencia Não Informada ... ' || vDevolucaoData.IDOcorrencia || chr(10);
                   pStatus := pkg_glb_common.Status_Erro;
                End If;             
            End If;
            
            If length(nvl(vDevolucaoData.Entrega,'X')) = 2 Then 
               tpRegNotaCte.Arm_Armazem_Codigo := trim(vDevolucaoData.Entrega);
            Else
               tpRegNotaCte.Arm_Armazem_Codigo := null; -- se Nulo e No fornecedor
            End If;
            tpRegNotaCte.Arm_Notacte_Localrecusa      := nvl(vDevolucaoData.LocalRecusa,'');
            tpRegNotaCte.Arm_Notacte_Observacao       := vDevolucaoData.Observacao;


--            tpRegNotaCte.Slf_Contrato_Codigo          := 
        
      End If;
     
        if vDevolucaoData.TipoDevolucao = 'X' then
           vDevolucaoData.TipoDevolucao := vDevolucaoData.TipoDevolucao;
        ElsIf vDevolucaoData.TipoDevolucao = 'F' then
            -- ToDo...: proc devolver ao fornecedor
            -- Colocar nota vinculada ao carregamento '0000000' e vincular ao carregamento det
            --pMessage := 'Fornecedor';
            Sp_Devolver_EmbNF_Fornecedor(vDevolucaoData.Nota, 
                                         vDevolucaoData.CNPJ, 
                                         vDevolucaoData.Seq, 
                                         vDevolucaoData.IDOcorrencia,
                                         pStatus, 
                                         pMessage);
        elsif vDevolucaoData.TipoDevolucao = 'D' then
            -- ToDo...: proc devolução da nota com conhecimento (que ja viajou mas por X motivo será devolvida)
            pMessage := 'Devolução Com Conhecimento' || chr(10) || 
                        '*********************************************************************' || chr(10) || 
                        pMessage || chr(10) ||
                        '*********************************************************************' || chr(10) ;
                        
                   

            tpRegNotaCte.Arm_Notacte_Codigo           := 'DE';

            -- Se nulo será entregue direto no cliente
            if tpRegNotaCte.Arm_Coleta_Ncompra is null Then
                -- TODO: Diego | 31/03/2015 | Erro na logica utilizando armazem (rotina deve ser analisada)
                if trim(nvl(tpRegNotaCte.Arm_Armazem_Codigo,'X')) <> 'X' Then
                   begin
                     select a.glb_localidade_codigo
                       into vLocTemporaria
                     from t_arm_armazem a
                     where a.arm_armazem_codigo = tpRegNotaCte.Arm_Armazem_Codigo;
                     tpRegNotaCte.Glb_Localidade_Codigodestino := tpRegNotaCte.Glb_Localidade_Codigoorigem;
                     tpRegNotaCte.Glb_Localidade_Codigoorigem := vLocTemporaria;
                   exception
                     When NO_DATA_FOUND Then
                        pStatus := pkg_glb_common.Status_Erro;
                        pMessage := pMessage || 'Favor verificar o Armazem Passado - [' || tpRegNotaCte.Arm_Armazem_Codigo || ']' || chr(10);
                     End;
                Else
                       Begin
                         select r.glb_localidade_codigo
                           into vLocTemporaria
                         from t_glb_rota r
                         where r.glb_rota_codigo = vDevolucaoData.RotaUSU;
                         tpRegNotaCte.Glb_Localidade_Codigodestino := tpRegNotaCte.Glb_Localidade_Codigoorigem;
                         tpRegNotaCte.Glb_Localidade_Codigoorigem := vLocTemporaria;
                       exception
                         When NO_DATA_FOUND Then  
                           tpRegNotaCte.Glb_Localidade_Codigoorigem := null;
                       End;
                End If;
            End If;
        elsif vDevolucaoData.TipoDevolucao = 'R' then
            -- ToDo...: proc reentregar: que foi recusada pelo destinatario e sera feita uma reentrega         
            pMessage := 'Reentrega' || chr(10) ||
                        '*********************************************************************' || chr(10) || 
                        pMessage || chr(10) ||
                        '*********************************************************************' || chr(10) ;

            tpRegNotaCte.Arm_Notacte_Codigo           := 'RE';

               if tpRegNotaCte.Arm_Notacte_Localrecusa is null Then
                  pMessage := pMessage || 'Motivo da Recusa Não informado ... ' || chr(10);
                  pStatus := pkg_glb_common.Status_Erro;
               End If;             

            -- Se nulo será entregue direto no cliente
            if trim(NVL(tpRegNotaCte.Arm_Armazem_Codigo,'X')) = 'X' Then
               select r.glb_localidade_codigo
                 into tpRegNotaCte.Glb_Localidade_Codigoorigem
               from t_glb_rota r
               where r.glb_rota_codigo = vDevolucaoData.RotaUSU;
            End If;

        elsif vDevolucaoData.TipoDevolucao = 'C' then
            -- ToDo...: proc reentregar: que foi recusada pelo destinatario e sera feita uma reentrega         
            pMessage := 'Complemento' || chr(10) ||
                        '*********************************************************************' || chr(10) || 
                        pMessage || chr(10) ||
                        '*********************************************************************' || chr(10) ;

            tpRegNotaCte.Arm_Notacte_Codigo           := 'CC';

               if tpRegNotaCte.Arm_Notacte_Localrecusa is null Then
                  pMessage := pMessage || 'Motivo da Recusa Não informado ... ' || chr(10);
                  pStatus := pkg_glb_common.Status_Erro;
               End If;             

            -- Se nulo será entregue direto no cliente
            if trim(NVL(tpRegNotaCte.Arm_Armazem_Codigo,'X')) = 'X' Then
               select r.glb_localidade_codigo
                 into tpRegNotaCte.Glb_Localidade_Codigoorigem
               from t_glb_rota r
               where r.glb_rota_codigo = vDevolucaoData.RotaUSU;
            End If;

        elsif vDevolucaoData.TipoDevolucao = 'E' then
            -- ToDo...: proc reentregar: que foi recusada pelo destinatario e sera feita uma reentrega         
            pMessage := 'Remoção' || chr(10) ||
                        '*********************************************************************' || chr(10) || 
                        pMessage || chr(10) ||
                        '*********************************************************************' || chr(10) ;

            tpRegNotaCte.Arm_Notacte_Codigo           := 'RR';

               if tpRegNotaCte.Arm_Notacte_Localrecusa is null Then
                  pMessage := pMessage || 'Motivo da Recusa Não informado ... ' || chr(10);
                  pStatus := pkg_glb_common.Status_Erro;
               End If;             

            -- Se nulo será entregue direto no cliente
            if trim(NVL(tpRegNotaCte.Arm_Armazem_Codigo,'X')) = 'X' Then
               select r.glb_localidade_codigo
                 into tpRegNotaCte.Glb_Localidade_Codigoorigem
               from t_glb_rota r
               where r.glb_rota_codigo = vDevolucaoData.RotaUSU;
            End If;


        elsif vDevolucaoData.TipoDevolucao = 'N' then
            -- ToDo...: proc Recuperar nota devolvida ao fornecedor.    
            -- Retirar carregamento '0000000' vinculado a embalagem e excluir tambem no carregamentodet     
            --pMessage := 'Recuperar Nota devolvida ao Fornecedor';                   
            Sp_Recup_EmbNF_Fornecedor(vDevolucaoData.Nota, vDevolucaoData.CNPJ, vDevolucaoData.Seq, pStatus, pMessage);
        end if;
       
      
      
       -- Retirar apos implementar Dev|Reentr
       if vDevolucaoData.TipoDevolucao In ('D', 'R', 'C', 'E') then     
--             pStatus := 'N';

          select count(*)
            into vAuxiliar
          from t_arm_notacte nc
          where nc.arm_notacte_codigo = tpRegNotaCte.Arm_Notacte_Codigo
            and nc.arm_nota_numero = tpRegNotaCte.Arm_Nota_Numero
            and nc.glb_cliente_cgccpfremetente = tpRegNotaCte.Glb_Cliente_Cgccpfremetente;
          if vAuxiliar > 0 Then
             pStatus := pkg_glb_common.Status_Erro;
             if vDevolucaoData.TipoDevolucao = 'D' then
                pMessage := pMessage || 'NOTA JA USADA PARA DEVOLUCAO ' || chr(10);
             ElsIf vDevolucaoData.TipoDevolucao = 'R' then
                pMessage := pMessage || 'NOTA JA USADA PARA REENTREGA ' || chr(10);
             ElsIf vDevolucaoData.TipoDevolucao = 'C' then
                pMessage := pMessage || 'NOTA JA USADA PARA COMPLEMENTO ' || chr(10);
             ElsIf vDevolucaoData.TipoDevolucao = 'E' then
                pMessage := pMessage || 'NOTA JA USADA PARA REMOCAO ' || chr(10);
             ElsIf vDevolucaoData.TipoDevolucao = 'F' then
                pMessage := pMessage || 'NOTA JA DEVOLVIDA PARA O FORNECEDOR ' || chr(10);
             End If;
          End IF;



             commit;
             if pStatus = pkg_glb_common.Status_Erro Then
                 pMessage := pMessage || chr(10);
                 pMessage := pMessage || '*********************************************************************'|| chr(10);
                 pMessage := pMessage || 'Nota: ' || tpRegNotaCte.Arm_Nota_Numero || chr(10);
                 pMessage := pMessage || 'CNPJ: ' || tpRegNotaCte.Glb_Cliente_Cgccpfremetente || chr(10);
                 pMessage := pMessage || 'Sequencia: ' || tpRegNotaCte.Arm_Nota_Sequencia || chr(10);
                 pMessage := pMessage || 'Chave: ' || tpRegNotaCte.Arm_Nota_Chavenfe || chr(10);
                 pMessage := pMessage || 'Tipo da devolução: ' || tpRegNotaCte.Arm_Notacte_Codigo || chr(10);
                 pMessage := pMessage || 'Conhecimento: ' || tpRegNotaCte.Con_Conhecimento_Codigoa || '-' || tpRegNotaCte.Con_Conhecimento_Seriea || '-' ||  tpRegNotaCte.Glb_Rota_Codigoa || chr(10) ;
                 pMessage := pMessage || 'Pagamento de Frete: ' || tpRegNotaCte.Arm_Notacte_Pagadorfrete || chr(10);
                 pMessage := pMessage || 'Sacado: ' || tpRegNotaCte.Glb_Cliente_Cgccpfsacado || chr(10);
                 pMessage := pMessage || 'Local Recusa: ' || tpRegNotaCte.Arm_Notacte_Localrecusa || chr(10);
                 pMessage := pMessage || 'Coleta: ' || tpRegNotaCte.Arm_Coleta_Ciclo || tpRegNotaCte.Arm_Coleta_Ncompra || chr(10);
                 pMessage := pMessage || 'Origem: ' || tpRegNotaCte.Glb_Localidade_Codigoorigem  || chr(10);
                 pMessage := pMessage || 'Destino: ' || tpRegNotaCte.Glb_Localidade_Codigodestino  || chr(10);
                 pMessage := pMessage || 'Observação: ' || tpRegNotaCte.Arm_Notacte_Observacao  || chr(10);
                 pMessage := pMessage || '*********************************************************************'|| chr(10);
    --             pMessage := pMessage || 'Procedure : ' || 'pkg_arm_embalagem.Sp_Devolver_EmbalagemNF' || CHR(10);
   
             Else

             /*********************************************/
                        select * 
                           into tpArmNota
                        From t_arm_nota an
                        Where an.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia;
                        
                        Begin
                        select *
                          into tpCarregdet
                        from t_arm_carregamentodet cd
                        where cd.arm_embalagem_numero = tpArmNota.Arm_Embalagem_Numero
                          and cd.arm_embalagem_flag   = tpArmNota.Arm_Embalagem_Flag
                          and cd.arm_embalagem_sequencia = tpArmNota.Arm_Embalagem_Sequencia
                          and cd.arm_carregamento_codigo = (select max(cd1.arm_carregamento_codigo)
                                                            from t_arm_carregamentodet cd1
                                                            where cd1.arm_embalagem_numero = cd.arm_embalagem_numero
                                                              and cd1.arm_embalagem_flag = cd.arm_embalagem_flag
                                                              and cd1.arm_embalagem_sequencia = cd.arm_embalagem_sequencia);
                        exception
                          When OTHERS Then
                             raise_application_error(-20010,'CARGADET ' || tpArmNota.Arm_Embalagem_Numero || '-' || tpArmNota.Arm_Embalagem_Flag || '-' || tpArmNota.Arm_Embalagem_Sequencia || chr(10) || sqlerrm);
                          End ; 
                        select c.*
                          into tpCarreg
                        from t_arm_carregamento c
                        where c.arm_carregamento_codigo = tpCarregdet.Arm_Carregamento_Codigo;
                         
                        vCarregAnt := tpCarreg.Arm_Carregamento_Codigo;

                        select max(to_number(c.arm_carregamento_codigo)) + 1 
                           into tpCarreg.arm_carregamento_codigo
                        from t_arm_carregamento c;

                        tpCarreg.Car_Veiculo_Placa              := null;  
                        tpCarreg.Arm_Carregamento_Pesocobrado   := 0;
                        tpCarreg.Arm_Carregamento_Pesoreal      := 0;
                        tpCarreg.Fcf_Tpveiculo_Codigo           := null;
                        tpCarreg.Arm_Carregamento_Pesobalanca   := 0;
                        tpCarreg.Car_Veiculo_Saque              := null;
                        tpCarreg.Arm_Carregamento_Pesocubado    := 0;
                        tpCarreg.Frt_Conjveiculo_Codigo         := null; 
                        tpCarreg.Arm_Carregamento_Dtfechamento  := null;
                        tpCarreg.Fcf_Veiculodisp_Codigo         := null;
                        tpCarreg.Fcf_Veiculodisp_Sequencia      := null;
                        tpCarreg.Arm_Carregamento_Qtdctrc       := 0;
                        tpCarreg.Arm_Carregamento_Qtdimpctrc    := 0;
                        tpCarreg.Arm_Carregamento_Dtviagem      := null;
                        tpCarreg.Arm_Carregamento_Ordementrega  := null;
                        tpCarreg.Arm_Carregamento_Dtentrega     := null;
                        tpCarreg.Arm_Carregamento_Flagmanifesto := null;
                        tpCarreg.Arm_Armazem_Codigo             := vDevolucaoData.ArmazemUSU;
                        tpCarreg.Arm_Carregamento_Dtfinalizacao := null;
                        tpCarreg.Arm_Carregamento_Autorizaspot  := null;
                        tpCarreg.Usu_Usuario_Crioucarreg        := vDevolucaoData.Usuario; 
                        tpCarreg.Usu_Usuario_Fechoucarreg       := null;
                        tpCarreg.Arm_Carregamento_Mobile        := 'N';
                        tpCarreg.Fcf_Solveic_Cod                := null;
                        tpCarreg.Arm_Carregamento_Destembs      := null;
                        tpCarreg.Arm_Carregamento_Dtcria        := sysdate;
                        tpCarreg.Arm_Carregamento_Flagvirtual   := 'N';
                        tpCarreg.Con_Manifesto_Codigo           := null;
                        tpCarreg.Con_Manifesto_Serie            := null;
                        tpCarreg.Con_Manifesto_Rota             := null;
--                        tpCarreg.Arm_Carregamemcalc_Codigo      := tpCarreg.arm_carregamento_codigo;
                        tpCarreg.Usu_Usuario_Conferiucarreg     := null;
                        tpCarreg.Arm_Carregamento_Dtconferencia := null;
                        

                     insert into t_arm_carregamento values tpCarreg;

                     tpCarregdet.arm_carregamento_codigo := tpCarreg.arm_carregamento_codigo;
                     
                     if tpRegNotaCte.Arm_Armazem_Codigo is not null Then
                        tpCarregdet.Arm_Armazem_Codigo_Transf     := tpRegNotaCte.Arm_Armazem_Codigo;
                        tpCarregdet.Arm_Carregamentodet_Flagtrans := 'S';
                     End If;
                     
                     insert into t_arm_carregamentodet values tpCarregdet;
             
                     update tdvadm.t_arm_nota n  
                       set n.arm_carregamento_codigo = tpCarreg.arm_carregamento_codigo,
                           n.con_conhecimento_codigo = null,
                           n.con_conhecimento_serie  = null,
                           n.glb_rota_codigo = null,
                           n.arm_nota_tabsol = tpRegNotaCte.Arm_Nota_Tabsol,
                           n.Arm_Nota_Tabsolcod = tpRegNotaCte.Arm_Nota_Tabsolcod,
                           n.Arm_Nota_Tabsolsq = tpRegNotaCte.Arm_Nota_Tabsolsq
                     where n.arm_nota_sequencia = tpArmNota.Arm_Nota_Sequencia;
                       
                     update tdvadm.t_arm_embalagem n  
                       set n.arm_carregamento_codigo = tpCarreg.arm_carregamento_codigo,
                           n.arm_embalagem_dtfechado = sysdate,
                           n.arm_armazem_codigo = vDevolucaoData.ArmazemUSU
                     where n.arm_embalagem_numero = tpArmNota.Arm_Embalagem_Numero
                       and n.arm_embalagem_flag   = tpArmNota.Arm_Embalagem_Flag
                       and n.arm_embalagem_sequencia = tpArmNota.Arm_Embalagem_Sequencia;


                     tpCarreg.Fcf_Veiculodisp_Codigo := tdvadm.pkg_fifo.fn_CriaVeicVirtual(tpCarreg.Arm_Carregamento_Codigo);
                     tpCarreg.Fcf_Veiculodisp_Sequencia := '0';

                     update t_arm_carregamento ca
                     set ca.fcf_veiculodisp_codigo =  tpCarreg.Fcf_Veiculodisp_Codigo,
                         ca.fcf_veiculodisp_sequencia = tpCarreg.Fcf_Veiculodisp_Sequencia
                     where ca.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;

                    -- Atualiza os Pesos
                     pStatus :=  pkg_fifo_carregamento.FN_CARREG_ATUALIZA_PESOS(tpCarreg.arm_carregamento_codigo );
                        
                     tpRegNotaCte.arm_carregamento_codigo := tpCarreg.arm_carregamento_codigo;
                     tpRegNotaCte.Arm_Coleta_Ncompra      := LPAD(trim(tpRegNotaCte.Arm_Coleta_Ncompra),6,'0'); 

                    insert into t_arm_notacte values tpRegNotaCte;
                    commit; 
                     UPDATE T_ARM_NOTA AN
                       SET AN.ARM_COLETA_NCOMPRA = LPAD(trim(tpRegNotaCte.Arm_Coleta_Ncompra),6,'0'),
                           AN.ARM_COLETA_CICLO = tpRegNotaCte.Arm_Coleta_Ciclo
                     WHERE AN.ARM_NOTA_SEQUENCIA = tpRegNotaCte.Arm_Nota_Sequencia;      
                     commit;
                     
                    
                    SELECT COUNT(*)
                      INTO vAuxiliar
                    FROM t_arm_notacte CTE
                    WHERE CTE.ARM_NOTACTE_CODIGO = tpRegNotaCte.Arm_Notacte_Codigo
                      AND CTE.ARM_NOTA_CHAVENFE = tpRegNotaCte.Arm_Nota_Chavenfe;
                     
                    IF vAuxiliar > 0 Then
                      if tpRegNotaCte.Arm_Nota_Numero <> 0000 Then
                       pkg_fifo_carregamento.SP_FECHA_CARREGAMENTO(tpCarreg.Arm_Carregamento_Codigo,
                                                                   vDevolucaoData.ArmazemUSU,
                                                                   vDevolucaoData.Usuario,
                                                                   pStatus,
                                                                   pMessage);
                      Else
                        pStatus := 'N';                                            
                      End If;  
                                                                
                       If pStatus = pkg_glb_common.Status_Nomal Then
                         pMessage := 'Carregamento [ ' || tpCarreg.Arm_Carregamento_Codigo || ' ] Fechado Com Sucesso.' || CHR(10) || 'FAÇA A CONFERENCIA NA ABA DO CTRC!';
                       Else 
                          pMessage := 'Carregamento [ ' || tpCarreg.Arm_Carregamento_Codigo || ' ] Fechado Com ERRO. '|| CHR(10) || pMessage;

  /*                        update t_arm_embalagem eb
                            set eb.arm_carregamento_codigo = vCarregAnt
                          where eb.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;
                          
                          delete t_arm_carregamentodet cd
                          where cd.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;

                          delete t_arm_carregamento_hist cd
                          where cd.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;

                          update t_arm_carregamento c
                            set c.fcf_veiculodisp_codigo = null,
                                c.fcf_veiculodisp_sequencia = null
                          where c.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;

                          update t_fcf_veiculodisp c
                             set c.arm_carregamento_codigo = null
                          where c.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;

                          delete t_arm_carregamento cd
                          where cd.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;


                          delete t_arm_notacte n 
                          where n.arm_nota_sequencia = tpRegNotaCte.Arm_Nota_Sequencia
                            and n.arm_notacte_codigo = tpRegNotaCte.Arm_Notacte_Codigo;
                          commit;
  */                        
                       End IF;
                   Else
                        pMessage := 'Identificação da DEV/REE não gravada...';
                   end If;    
                End If;
             /**********************************************/






       end if;                   
  End Sp_Devolver_EmbalagemNF; 
  
  Procedure Sp_GetMotivoDevolucao(pXmlOut  Out Clob,
                                  pStatus  Out Char,
                                  pMessage Out varchar2)
  As
  vIndex Number;
  vXml Varchar2(4000);
  vStatus Char(1);
  vMessage varchar2(500);
  Begin              
      Begin         
          vIndex := -1;      
          for o in (select t.glb_ocorr_id ID,
                           t.glb_ocorrclass_descr || ' - ' || glb_ocorr_descr || '                ' DESCRICAO
                              from V_GLB_OCORRENCIA t
                             where t.glb_ocorrtpdoc_codigo = '002'
                               and t.glb_ocorrclass_codigo = '009' )
           loop
              vIndex := vIndex +1;  
              vXml := vXml || '<row num="' || to_char( vIndex      ) || '">';
              vXml := vXml || '<ID>'       || to_char( o.id ) || '</ID>';
              vXml := vXml || '<Descricao>'|| o.descricao     || '</Descricao>'; 
              vXml := vXml || '</row>';
           end loop;   
           
          vXml := '<Table name="Motivos"><RowSet>'|| vXml || '</RowSet></Table>';
          vStatus := 'N';
          vMessage := 'Terminais retornado com sucesso!';                
          
      Exception
        When Others Then
           vStatus := 'E';
           vMessage := sqlerrm;
      End;   
      
      pXmlOut := '<Parametros><OutPut>';
      pXmlOut := pXmlOut|| '<Status>' ||vStatus ||'</Status>';
      pXmlOut := pXmlOut|| '<Message>'||vMessage||'</Message>';
      pXmlOut := pXmlOut|| '<Tables>';
      pXmlOut := pXmlOut|| vXml;
      pXmlOut := pXmlOut|| '</Tables>';
      pXmlOut := pXmlOut|| '</OutPut></Parametros>'; 
      pXmlOut := Pkg_Glb_Common.FN_LIMPA_CAMPO(pXmlOut);
      
      pStatus := vStatus;
      pMessage := vMessage;
  
  End Sp_GetMotivoDevolucao;       
  
  Procedure Sp_Devolver_EmbNF_Fornecedor(pNota      in t_arm_nota.arm_nota_numero%Type,
                                         pCNPJ      In t_arm_nota.glb_cliente_cgccpfremetente%type,
                                         pSequencia In t_arm_nota.arm_nota_sequencia%Type,
                                         pMotivo    In Number,
                                         pStatus    Out Char,
                                         pMessage   Out Varchar2)
  As
  vEmbalagem t_arm_embalagem.arm_embalagem_numero%type;
  vFlag      t_arm_embalagem.arm_embalagem_flag%type;
  vSequencia t_arm_embalagem.arm_embalagem_sequencia%type;
  vColeta    t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo     t_arm_coleta.arm_coleta_ciclo%type;
  Begin
      Begin
          Select e.arm_embalagem_numero,
                 e.arm_embalagem_flag,
                 e.arm_embalagem_sequencia
            Into vEmbalagem,
                 vFlag,
                 vSequencia     
            from t_arm_embalagem e,
                 t_arm_cargadet cd
            where e.arm_embalagem_numero = cd.arm_embalagem_numero
              and e.arm_embalagem_flag   = cd.arm_embalagem_flag
              and e.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
              and cd.arm_nota_numero        = pNota
              and cd.glb_cliente_cgccpfremetente = pCNPJ
              and cd.arm_nota_sequencia          = pSequencia;
              
          Update t_arm_embalagem em
             set em.arm_carregamento_codigo = CARREGAMENTO_DEVOLVE_NOTA
             WHERE em.arm_embalagem_numero = vEmbalagem
               and em.arm_embalagem_flag   = vFlag
               and em.arm_embalagem_sequencia = vSequencia;
               
          Insert Into t_arm_carregamentodet 
                           values (CARREGAMENTO_DEVOLVE_NOTA,
                                   vEmbalagem,
                                   vFlag,
                                   vSequencia,
                                   null,
                                   null,
                                   pCNPJ,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null,
                                   null); 
                                   
           Update t_arm_cargadet cd
             set cd.GLB_OCORR_ID = pMotivo
               where cd.arm_nota_numero             = pNota
                 and cd.glb_cliente_cgccpfremetente = pCNPJ
                 and cd.arm_nota_sequencia          = pSequencia
                 and cd.arm_embalagem_numero        = vEmbalagem
                 and cd.arm_embalagem_flag           = vFlag
                 and cd.arm_embalagem_sequencia = vSequencia;

        select n.arm_coleta_ncompra,
               n.arm_coleta_ciclo
          into vColeta,
               vCiclo
        from t_arm_nota n
        where n.arm_nota_numero             = pNota
          and n.glb_cliente_cgccpfremetente = pCNPJ
          and n.arm_nota_sequencia          = pSequencia;
          
          pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,vCiclo,'59',pStatus,pMessage);

          if pStatus = 'N' Then                                                       
             Commit;    
             pStatus := 'N';
             pMessage := 'Nota Devolvida ao fornecedor com sucesso!!!';
          End If;   
       Exception
         When Others Then
            pStatus := 'E';
            pMessage := sqlerrm;           
            Rollback;
       End;
  End Sp_Devolver_EmbNF_Fornecedor;   

  Procedure Sp_Recup_EmbNF_Fornecedor(pNota      in t_arm_nota.arm_nota_numero%Type,
                                      pCNPJ      In t_arm_nota.glb_cliente_cgccpfremetente%type,
                                      pSequencia In t_arm_nota.arm_nota_sequencia%Type,
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2)
  As
  vEmbalagem t_arm_embalagem.arm_embalagem_numero%type;
  vFlag      t_arm_embalagem.arm_embalagem_flag%type;
  vSequencia t_arm_embalagem.arm_embalagem_sequencia%type;
  vMotivo    t_arm_cargadet.glb_ocorr_id%type;
  vColeta    t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo     t_arm_coleta.arm_coleta_ciclo%type;
  Begin
      Begin
          Select e.arm_embalagem_numero,
                 e.arm_embalagem_flag,
                 e.arm_embalagem_sequencia
            Into vEmbalagem,
                 vFlag,
                 vSequencia     
            from t_arm_embalagem e,
                 t_arm_cargadet cd
            where e.arm_embalagem_numero = cd.arm_embalagem_numero
              and e.arm_embalagem_flag   = cd.arm_embalagem_flag
              and e.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
              and cd.arm_nota_numero        = pNota
              and cd.glb_cliente_cgccpfremetente = pCNPJ
              and cd.arm_nota_sequencia          = pSequencia;
              
          Select cd.glb_ocorr_id
            Into vMotivo
            from t_arm_cargadet cd
            where cd.arm_nota_numero             = pNota
              and cd.glb_cliente_cgccpfremetente = pCNPJ
              and cd.arm_nota_sequencia          = pSequencia
              and cd.arm_embalagem_numero        = vEmbalagem
              and cd.arm_embalagem_flag          = vFlag
              and cd.arm_embalagem_sequencia     = vSequencia;           
             
         /*
          if vMotivo = '5' then
   --           Select * v_ocor
              pStatus := 'W';
              pMessage := 'Não é possivel recuperar nota. Motivo: ' || 'Nota Vencida';
              return;
          end if;                   
          */ 

        select n.arm_coleta_ncompra,
               n.arm_coleta_ciclo
          into vColeta,
               vCiclo
        from tdvadm.t_arm_nota n
        where n.arm_nota_numero             = pNota
          and n.glb_cliente_cgccpfremetente = pCNPJ
          and n.arm_nota_sequencia          = pSequencia;
          
          pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,vCiclo,'99',pStatus,pMessage);
          
          If pStatus = 'W' Then
             Update tdvadm.t_arm_nota n
               set n.arm_coleta_ncompra = null,
                   n.arm_coleta_ciclo = null
             where n.arm_nota_numero             = pNota
               and n.glb_cliente_cgccpfremetente = pCNPJ
               and n.arm_nota_sequencia          = pSequencia;
             pStatus := 'N';
             pMessage := '';   
          End If;

          If pStatus = 'N' then
             
              Update t_arm_embalagem em
                 set em.arm_carregamento_codigo = null
                 WHERE em.arm_embalagem_numero = vEmbalagem
                   and em.arm_embalagem_flag   = vFlag
                   and em.arm_embalagem_sequencia = vSequencia;
                   
              Delete from t_arm_carregamentodet cc
                where cc.arm_carregamento_codigo = CARREGAMENTO_DEVOLVE_NOTA
                  and cc.arm_embalagem_numero    = vEmbalagem
                  and cc.arm_embalagem_flag      = vFlag
                  and cc.arm_embalagem_sequencia = vSequencia;
                                                                       
              Commit;    
              pStatus := 'N';
              pMessage := 'Nota Recuperada.';
          End If;
       Exception
         When Others Then
            pStatus := 'E';
            pMessage := sqlerrm;           
            Rollback;
       End;
  End Sp_Recup_EmbNF_Fornecedor;    

end PKG_ARM_EMBALAGEM;
/
