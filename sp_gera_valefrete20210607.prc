CREATE OR REPLACE PROCEDURE sp_gera_valefrete(P_FCF_VEICULOCOD       IN T_ARM_CARREGAMENTO.FCF_VEICULODISP_CODIGO%TYPE,
                                              P_FCF_VEICSEQ          IN T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                                              P_ROTA                 IN T_ARM_ARMAZEM.GLB_ROTA_CODIGO%TYPE,
                                              P_USUARIO              IN T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                              P_OBRIGACOES           IN T_CON_VALEFRETE.CON_VALEFRETE_OBRIGACOES%TYPE,
                                              P_OBSERVACAO           IN T_CON_VALEFRETE.CON_VALEFRETE_CONDESPECIAIS%TYPE,
                                              P_SAQUE                IN T_FCF_VEICULODISP.CAR_CARRETEIRO_SAQUE%TYPE,
                                              P_PESO                 IN T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_PESOREAL%TYPE,
                                              P_ERRO_PROCESSAMENTO   OUT CHAR,
                                              P_RETORNOPROCESSAMENTO OUT t_con_loggeracao.con_loggeracao_obsgeracao%type) IS

/********************************************************************************************** 
 * ROTINA           : SP_GERA_VALEFRETE                                                       *
 * PROGRAMA         : Vale Frete                                                              *
 * ANALISTA         : Flavio Alencar                                                          *
 * DESENVOLVEDOR    : Flavio Alencar                                                          *
 * DATA DE CRIACAO  : 01/01/2009                                                              *
 * BANCO            : ORACLE-TDP                                                              *
 * EXECUTADO POR    : prj_valefrete.exe                                                       *
 * ALIMENTA         : T_CON_VALEFRETE, T_CON_VFRETECONHEC                                     *
 * FUNCINALIDADE    : Rotina responsavel por Inserir Vale Frete saque 1, dos CTRC'S gerados   *
 *                    pelo FIFO.                                                              *
 * ATUALIZA         :                                                                         *
 * PARTICULARIDADES : Gera o Vale de frete,  somente se todas as imagens de NOTA e CTRC       *
 *                    foram scaneadas.                                                        *
 * PARAM. OBRIGAT.  : p_fcf_veiculocod, p_fcf_veicseq, p_rota, p_usuario                      *
 **********************************************************************************************/

  V_DATAENTREGA        DATE;
  v_destinoctrc        tdvadm.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_MAIORORIGEM        tdvadm.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_MAIORDEST          tdvadm.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  P_PLACA              tdvadm.T_CAR_VEICULO.CAR_VEICULO_PLACA%TYPE;
  P_PROPRIETARIO       tdvadm.T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_RAZAOSOCIAL%TYPE;
  P_MARCA              tdvadm.T_CAR_VEICULO.CAR_VEICULO_MARCA%TYPE;
  P_LOCAL              tdvadm.T_CAR_VEICULO.CAR_VEICULO_PLACACIDADE%TYPE;
  P_UF_VEICULO         tdvadm.T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
  P_NOMEMOTORISTA      tdvadm.T_CAR_CARRETEIRO.CAR_CARRETEIRO_NOME%TYPE;
  P_RG                 tdvadm.T_CAR_CARRETEIRO.CAR_CARRETEIRO_RGCODIGO%TYPE;
  P_CPF                tdvadm.T_CAR_CARRETEIRO.CAR_CARRETEIRO_CPFCODIGO%TYPE;
  P_UF_MOTORISTA       tdvadm.T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
  P_CNH                tdvadm.T_CAR_CARRETEIRO.CAR_CARRETEIRO_CNHCODIGO%TYPE;
  P_TPMOTORISTA        tdvadm.T_GLB_TPMOTORISTA.GLB_TPMOTORISTA_CODIGO%TYPE;
  P_PLACA_SAQUE        tdvadm.T_CAR_VEICULO.CAR_VEICULO_SAQUE%TYPE;
  V_FLAGMANIFESTO      tdvadm.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_FLAGMANIFESTO%TYPE;
  V_MANIFESTOCODIGO    tdvadm.T_CON_MANIFESTO .CON_MANIFESTO_CODIGO%TYPE;
  V_VFCTRC             VARCHAR2(100); --T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_CTRC               VARCHAR2(8); --T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_VERIFICACTRC       tdvadm.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_VFNF               VARCHAR2(100);
  V_MAXCTRC            tdvadm.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_VERIFICAMAXCTRC    tdvadm.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_CTRCSERIE          tdvadm.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  V_PESOCOBRADO        NUMBER(14, 3);
  V_PESOREAL           NUMBER(14, 3);
  V_PESOBALANCA        NUMBER(14, 3);
  V_PESOCUBADO         NUMBER(14, 3);
  V_PESOCOBRADONEW     NUMBER(14, 3);
  V_PESOREALNEW        NUMBER(14, 3);
  V_PESOBALANCANEW     NUMBER(14, 3);
  V_PESOCUBADONEW      NUMBER(14, 3);
  V_QTDENTREGAS        NUMBER;
  V_USUARIO            tdvadm.T_USU_USUARIO.USU_USUARIO_NOME%TYPE;
  V_CATVF              NUMBER;
  V_CATVALEFRETE       tdvadm.T_CON_CATVALEFRETE.CON_CATVALEFRETE_CODIGO%TYPE;
  V_REMETENTE          tdvadm.T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%TYPE;
  V_DESTINATARIO       tdvadm.T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%TYPE;
  V_TPVEICULO          tdvadm.T_FCF_TPVEICULO.FCF_TPVEICULO_CODIGO%TYPE;
  P_KM                 tdvadm.T_FCF_FRETECAR.FCF_FRETECAR_KM%TYPE;
  V_KMFINAL            tdvadm.T_FCF_FRETECAR.FCF_FRETECAR_KM%TYPE;
  P_TPCARGA            tdvadm.T_FCF_FRETECAR.FCF_TPCARGA_CODIGO%TYPE;
  P_CUSTOCARRETEIRO    tdvadm.T_FCF_FRETECAR.FCF_FRETECAR_VALOR%TYPE;
  V_CUSTOCARRETEIRO    tdvadm.T_FCF_FRETECAR.FCF_FRETECAR_VALOR%TYPE;
  P_DESINENCIA         tdvadm.T_CON_VALEFRETE.CON_VALEFRETE_TIPOCUSTO%TYPE;
  P_TPVEICULO          tdvadm.T_FCF_TPVEICULO.FCF_TPVEICULO_CODIGO%TYPE;
  P_PEDAGIO            tdvadm.T_FCF_FRETECAR.FCF_FRETECAR_PEDAGIO%TYPE;
  P_TPRETORNO          CHAR(2);
  P_MENSAGEM           CHAR(100);
  P_FRETEPRACA         CHAR(100);
  V_LOTACAO            tdvadm.T_FCF_TPVEICULO.FCF_TPVEICULO_LOTACAO%TYPE;
  V_CIDADEREM          tdvadm.T_GLB_CLIEND.GLB_CLIEND_CIDADE%TYPE;
  V_RAZAOREM           tdvadm.T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE;
  V_CIDDEST            tdvadm.T_GLB_CLIEND.GLB_CLIEND_CIDADE%TYPE;
  V_RAZAODEST          tdvadm.T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE;
  V_TPCARGA            tdvadm.T_FCF_TPCARGA.FCF_TPCARGA_CODIGO%TYPE;
  V_DESTINO            tdvadm.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_PROXIMOORIGEM      tdvadm.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_PRAZODEENTREGA     DATE;
  V_PRAZODEENTREGA2    DATE;
  V_COLETA             CHAR(10);
  V_ADIANTAMENTO       NUMBER(14, 2);
  V_VIAGEMNUMERO       tdvadm.T_CON_VALEFRETE.CON_VIAGEM_NUMERO%TYPE;
  vv_rota              tdvadm.t_glb_rota.glb_rota_codigo%type;
  vv_ctrc              tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
  vv_serie             tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
  V_IMAGEMNOTA         tdvadm.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE;
  V_CTRCELETRONICO     CHAR(1);
  V_IMAGEMCTRC         tdvadm.T_ARM_NOTA.CON_CONHECIMENTO_CODIGO%TYPE;
  V_CARREGAMENTO       tdvadm.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE;
  V_IMAGEMNOTAVF       CHAR(1);
  V_IMAGEMCTRCVF       CHAR(1);
  V_CALCBONUS          CHAR(1);
  V_SAQUE_VF           TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
  V_SAQUE_CONTADOR     INTEGER;
  V_KM                 tdvadm.T_SLF_PERCURSO.SLF_PERCURSO_KM%TYPE;
  V_ERRO_PROCESSAMENTO char(1);
  V_CONTADOR           INTEGER;
  V_ROTA               tdvadm.T_ARM_ARMAZEM.GLB_ROTA_CODIGO%TYPE;
  v_bonus              Number(14,2);
  V_CONDESPECIAIS      Varchar2(100);  
  V_QTDIMG             Integer;
  V_TPARQUIVO          tdvadm.T_GLB_TPARQUIVO.GLB_TPARQUIVO_CODIGO%TYPE;
  V_FRETEFECHADO       tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_VALORFRETE%TYPE;
  V_FRETEEXCECAO       tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_VALOREXCECAO%Type;
  v_PARTICULARIDADE    tdvadm.T_FCF_VEICULODISP.fcf_veiculodisp_particularidade%Type;
  v_OUTROS             tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_VALORFRETE%TYPE;     
  v_freteRowId         number;
  V_DESCONTOFECHADO    tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_DESCONTO%TYPE;
  V_DESINENCIA         Char(2);
  V_ENTREGAS           tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_QTDEENTREGAS%TYPE;
  V_QTDECOLETAS        tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_QTDECOLETAS%TYPE;
  V_ACRESCIMO          tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_ACRESCIMO%TYPE;
  V_PEDAGIO            tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_pedagio%type;
  V_PEDNOFRETE         tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_pednofrete%type;
  V_TPFRETE            tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_TPFRETE%TYPE;
  V_TPDESCONTO         tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_TPDESCONTO%TYPE;
  V_OBSVEICDISP        tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_OBSVALEFRETE%TYPE;
  V_OBSACRESCIMO       tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_OBSACRESCIMO%TYPE;
  V_KMCOLETA           tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_KMCOLETAS%TYPE;
  V_OBRIGACOES         tdvadm.T_FCF_VEICULODISP.FCF_VEICULODISP_OBSVALEFRETE%TYPE;
  V_ROTATRAVADA        Char(1);
  v_diasfretemesa      Number;  
  /* Variáveis criadas para controlar a exigência de imagem para o CTRC e/ou NF, na criação do valefrete. */
  V_EXCESSAO_CTRC      Char(1);
  V_EXCESSAO_NOTA      Char(1);
  v_PercetDesconto     Number;
  vAuxiliar            Number;
  vContCteRota         Integer; 
  vContCteDifRota      Integer;
  vValeFreteCte        tdvadm.t_con_conhecimento.con_conhecimento_codigo%type:= 0;
  vValeFreteSerie      tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
  vValeFretRota        tdvadm.t_con_conhecimento.glb_rota_codigo%type;
  vValeFreteSq         tdvadm.t_con_valefrete.con_valefrete_saque%type;
  vCodViagem           tdvadm.t_con_conhecimento.con_viagem_numero%type;

  vCarregamento        tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
  vTemArmTransf        tdvadm.t_arm_armazem.arm_armazem_codigo%type; 
  vEmbNumero           tdvadm.t_arm_embalagem.arm_embalagem_numero%type;
  vEmbFlag             tdvadm.t_arm_embalagem.arm_embalagem_flag%type;
  vEmbSeq              tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type; 
  tpValeFrete          tdvadm.t_con_valefrete%rowtype; 
  vErro                char(1);  
  vOrigemSOl           tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vDestinoSOl          tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vPercentExpresso     number; 
  vPednoFrete          tdvadm.t_fcf_fretecar.fcf_fretecar_pednofrete%type;
  vProcessoSV          char(1);
  vProcessoMS          char(1);
  tpFreteMemo          tdvadm.t_fcf_fretecarmemo%rowtype;
  /*******************************************************************/
  /**         MONTO O CURSOR PARA CARREGAMENTOS DESTE VEICULO       **/
  /*******************************************************************/
  CURSOR C_CARREGAMENTO IS
    SELECT CA.ARM_CARREGAMENTO_CODIGO
      FROM T_ARM_CARREGAMENTO CA, T_FCF_VEICULODISP VD
     WHERE VD.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
       AND VD.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
       AND CA.FCF_VEICULODISP_CODIGO = VD.FCF_VEICULODISP_CODIGO
       AND CA.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA;

       
  /*******************************************************************/
  /**CURSOR PARA PEGAR OS CTE´S VINC. DIRETAMENTE PELO VEIC DISP    **/
  /*******************************************************************/
  CURSOR C_CONHECIMENTO IS 
  SELECT VV.CON_CONHECIMENTO_CODIGO,
         VV.CON_CONHECIMENTO_SERIE,
         VV.GLB_ROTA_CODIGO
    FROM T_CON_VEICCONHEC VV,
         T_CON_CONHECIMENTO CC
   WHERE VV.FCF_VEICULODISP_CODIGO                  = P_FCF_VEICULOCOD
     AND VV.FCF_VEICULODISP_SEQUENCIA               = P_FCF_VEICSEQ   
     AND VV.CON_CONHECIMENTO_CODIGO                 = CC.CON_CONHECIMENTO_CODIGO
     AND VV.CON_CONHECIMENTO_SERIE                  = CC.CON_CONHECIMENTO_SERIE
     AND VV.GLB_ROTA_CODIGO                         = CC.GLB_ROTA_CODIGO
     AND NVL(CC.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N';
       
  
  /*******************************************************************/
  /**  MONTO UM CURSOR PARA PEGAR AS LOCALIDADES DE ORIGEM E DESTINO**/
  /*******************************************************************/
  CURSOR C_LOCALIDADES IS
    SELECT AR.GLB_LOCALIDADE_CODIGO            ORIGEM,
           CO.GLB_LOCALIDADE_CODIGODESTINO     DESTINO,
          -- nvl(DE.FCF_VEICULODISPDEST_ORDEM,1) ORDEM
          DE.FCF_VEICULODISPDEST_ORDEM    ORDEM
      FROM T_ARM_CARREGAMENTO    CA,
           T_FCF_VEICULODISP     VD,
           T_FCF_VEICULODISPDEST DE,
           T_CON_CONHECIMENTO    CO,
           T_ARM_ARMAZEM         AR
     WHERE VD.FCF_VEICULODISP_CODIGO              = P_FCF_VEICULOCOD
       AND VD.FCF_VEICULODISP_SEQUENCIA           = P_FCF_VEICSEQ
       AND VD.FCF_VEICULODISP_CODIGO              = DE.FCF_VEICULODISP_CODIGO
       AND VD.FCF_VEICULODISP_SEQUENCIA 	        = DE.FCF_VEICULODISP_SEQUENCIA
       AND CA.FCF_VEICULODISP_CODIGO              = VD.FCF_VEICULODISP_CODIGO
       AND CA.FCF_VEICULODISP_SEQUENCIA           = VD.FCF_VEICULODISP_SEQUENCIA
       AND CA.ARM_CARREGAMENTO_CODIGO             = CO.ARM_CARREGAMENTO_CODIGO
       AND DE.GLB_LOCALIDADE_CODIGO               = CO.GLB_LOCALIDADE_CODIGODESTINO
       AND CA.ARM_ARMAZEM_CODIGO                  = AR.ARM_ARMAZEM_CODIGO
     
       AND CO.CON_CONHECIMENTO_FLAGCANCELADO      IS NULL
     
     GROUP BY AR.GLB_LOCALIDADE_CODIGO            ,
              CO.GLB_LOCALIDADE_CODIGODESTINO     ,
              DE.FCF_VEICULODISPDEST_ORDEM        ,
              DE.FCF_VEICULODISP_SEQUENCIA
     ORDER BY DE.FCF_VEICULODISPDEST_ORDEM;

  
  /*******************************************************************/
  /**  MONTO UM CURSOR PARA PEGAR TODOS CONHECIMENTOS DO VEICULO    **/
  /*******************************************************************/ 
  CURSOR C_CTRCVEIC IS
    /* SELECT CONSIDERA TODOS OS CONHECIMENTOS QUE ESTÃO VINCULADO AO VEICULO DISPONIVEL PELO CARREGAMENTO*/
        SELECT DISTINCT CO.CON_CONHECIMENTO_CODIGO,
                    CO.CON_CONHECIMENTO_SERIE,
                    CO.GLB_ROTA_CODIGO,
                    CC.SLF_TPCALCULO_CODIGO
      FROM TDVADM.T_CON_CONHECIMENTO     CO,
           TDVADM.T_ARM_CARREGAMENTODET  CD,
           -- Sirlano 21/07/2017
           -- Troquei da T_ARM_NOTA para T_ARM_NOTACTE
           TDVADM.T_ARM_NOTA             NT,
           TDVADM.T_ARM_CARREGAMENTO     CA,
           TDVADM.T_CON_CALCCONHECIMENTO CC
     WHERE CA.FCF_VEICULODISP_CODIGO         = P_FCF_VEICULOCOD
       AND CA.FCF_VEICULODISP_SEQUENCIA      = P_FCF_VEICSEQ
       AND CA.ARM_CARREGAMENTO_CODIGO        = CD.ARM_CARREGAMENTO_CODIGO
--       AND CA.ARM_CARREGAMENTO_CODIGO        = NT.ARM_CARREGAMENTO_CODIGO
       -- Sirlano 21/07/2017
       -- Antiga Ligacao com a ARM_NOTA
       -- Depois que começou a cobrar coleta em CTe separado 
       AND CD.ARM_EMBALAGEM_NUMERO           = NT.ARM_EMBALAGEM_NUMERO
       AND CD.ARM_EMBALAGEM_FLAG             = NT.ARM_EMBALAGEM_FLAG
       AND CD.ARM_EMBALAGEM_SEQUENCIA        = NT.ARM_EMBALAGEM_SEQUENCIA 
       AND NT.CON_CONHECIMENTO_CODIGO        = CO.CON_CONHECIMENTO_CODIGO
       AND NT.CON_CONHECIMENTO_SERIE         = CO.CON_CONHECIMENTO_SERIE
       AND NT.GLB_ROTA_CODIGO                = CO.GLB_ROTA_CODIGO
       AND CO.CON_CONHECIMENTO_CODIGO        = CC.CON_CONHECIMENTO_CODIGO
       AND CO.CON_CONHECIMENTO_SERIE         = CC.CON_CONHECIMENTO_SERIE
       AND CO.GLB_ROTA_CODIGO                = CC.GLB_ROTA_CODIGO
       AND CC.SLF_RECCUST_CODIGO             = 'I_TTPV'
       --       AND CO.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
       AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
    UNION
       SELECT DISTINCT NC.CON_CONHECIMENTO_CODIGO,
                       NC.CON_CONHECIMENTO_SERIE,
                       NC.GLB_ROTA_CODIGO,
                       CALC.SLF_TPCALCULO_CODIGO
       FROM TDVADM.T_ARM_NOTACTE NC,
            TDVADM.T_ARM_CARREGAMENTO CA,
            TDVADM.T_CON_CALCCONHECIMENTO CALC,
            TDVADM.T_CON_CONHECIMENTO C
       WHERE 0 = 0
         AND NC.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
         AND NC.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
         AND NC.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
         AND NC.ARM_NOTACTE_CODIGO <> 'CO'
         and CA.ARM_CARREGAMENTO_CODIGO = C.ARM_CARREGAMENTO_CODIGO
         AND NC.CON_CONHECIMENTO_CODIGO = CALC.CON_CONHECIMENTO_CODIGO
         AND NC.CON_CONHECIMENTO_SERIE = CALC.CON_CONHECIMENTO_SERIE
         AND NC.GLB_ROTA_CODIGO = CALC.GLB_ROTA_CODIGO
         AND CALC.SLF_RECCUST_CODIGO = 'I_TTPV'
         AND CA.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
         AND CA.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
    UNION
    /* SELECT CONSIDERA TODOS OS CONHECIMENTOS QUE ESTÃO VINCULADOS AO VEICULO DISPONIVEL( CONHECIMENTOS NÃO FORAM FEITOS PELO O FIFO)*/
    SELECT CH.CON_CONHECIMENTO_CODIGO,
           CH.CON_CONHECIMENTO_SERIE,
           CH.GLB_ROTA_CODIGO,
           CC.SLF_TPCALCULO_CODIGO
      FROM T_CON_CONHECIMENTO     CH,
           T_CON_VEICCONHEC       VV,
           T_CON_CALCCONHECIMENTO CC
     WHERE CH.CON_CONHECIMENTO_CODIGO                 = VV.CON_CONHECIMENTO_CODIGO
       AND CH.CON_CONHECIMENTO_SERIE                  = VV.CON_CONHECIMENTO_SERIE
       AND CH.GLB_ROTA_CODIGO                         = VV.GLB_ROTA_CODIGO
       AND CH.CON_CONHECIMENTO_CODIGO                 = CC.CON_CONHECIMENTO_CODIGO
       AND CH.CON_CONHECIMENTO_SERIE                  = CC.CON_CONHECIMENTO_SERIE
       AND CH.GLB_ROTA_CODIGO                         = CC.GLB_ROTA_CODIGO
       AND CC.SLF_RECCUST_CODIGO                      = 'I_TTPV'
       AND VV.FCF_VEICULODISP_CODIGO                  = P_FCF_VEICULOCOD
       AND VV.FCF_VEICULODISP_SEQUENCIA               = P_FCF_VEICSEQ
       AND NVL(CH.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N'
    UNION
       SELECT DISTINCT C.CON_CONHECIMENTO_CODIGO,
                       C.CON_CONHECIMENTO_SERIE,
                       C.GLB_ROTA_CODIGO,
                       CALC.SLF_TPCALCULO_CODIGO
       FROM TDVADM.T_ARM_CARREGAMENTO CA,
            TDVADM.T_CON_CALCCONHECIMENTO CALC,
            TDVADM.T_CON_CONHECIMENTO C
       WHERE 0 = 0
         and CA.ARM_CARREGAMENTO_CODIGO = C.ARM_CARREGAMENTO_CODIGO
         AND C.CON_CONHECIMENTO_CODIGO = CALC.CON_CONHECIMENTO_CODIGO
         AND C.CON_CONHECIMENTO_SERIE = CALC.CON_CONHECIMENTO_SERIE
         AND C.GLB_ROTA_CODIGO = CALC.GLB_ROTA_CODIGO
         AND CALC.SLF_RECCUST_CODIGO = 'I_TTPV'
         AND 0 = (SELECT COUNT(*)
                  FROM TDVADM.T_ARM_NOTACTE NCTE
                  WHERE NCTE.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
                    AND NCTE.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
                    AND NCTE.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
                    AND NCTE.ARM_NOTACTE_CODIGO = 'CO')
         AND ca.FCF_VEICULODISP_CODIGO                  = P_FCF_VEICULOCOD
         AND ca.FCF_VEICULODISP_SEQUENCIA               = P_FCF_VEICSEQ
         AND NVL(C.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N';


  /*    SELECT DISTINCT CO.CON_CONHECIMENTO_CODIGO,
                      CO.CON_CONHECIMENTO_SERIE,
                      CO.GLB_ROTA_CODIGO,
                      CC.SLF_TPCALCULO_CODIGO
        FROM T_CON_CONHECIMENTO     CO,
             T_ARM_CARREGAMENTO     CA,
             T_CON_CALCCONHECIMENTO CC
       WHERE CA.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
         AND CA.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
         AND CO.CON_CONHECIMENTO_CODIGO = CC.CON_CONHECIMENTO_CODIGO
         AND CO.CON_CONHECIMENTO_SERIE = CC.CON_CONHECIMENTO_SERIE
         AND CO.GLB_ROTA_CODIGO = CC.GLB_ROTA_CODIGO
         AND CO.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
         AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL;
  */
  
  /*******************************************************************/
  /**  VARIAVEIS PARA PEGAR OS PARAMETROS                           **/
  /*******************************************************************/
  V_ROTASIMG   T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;
  V_PARAMETRO  T_USU_PERFIL.USU_PERFIL_CODIGO%TYPE;
  V_PARAMTEXTO T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;
  V_PARAMVALOR T_USU_PERFIL.USU_PERFIL_PARAN1%TYPE;
  V_PERC_BONUS T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;
  
  
  /*******************************************************************/
  /**  MONTA O CURSOR PARA PEGAR OS PARAMETROS                      **/
  /*******************************************************************/
  CURSOR C_PARAMETROS IS
    SELECT DISTINCT P.PERFIL, P.TEXTO, P.NUMERICO1
      FROM T_USU_PARAMETROTMP P
     WHERE P.USUARIO = P_USUARIO
       AND P.APLICACAO = 'comvlfrete'
       and P.ROTA = P_ROTA;
     

BEGIN
  

  -- Verifica se o processo e pelo NOVO Sistema ou Antigo
  -- Sirlano 04/06/2021
  Begin
  select tdvadm.Pkg_Fcf_VeiculoDisp.fn_get_versaoSOLVEIC(P_FCF_VEICULOCOD,P_FCF_VEICSEQ),
         tdvadm.Pkg_Fcf_VeiculoDisp.fn_get_versaoMESA(P_FCF_VEICULOCOD,P_FCF_VEICSEQ)
    into vProcessoSV,
         vProcessoMS
  From dual;
  Exception
    When OTHERS Then
       vProcessoSV := 'V';
       vProcessoMS := 'V';      
    End;
  Begin 
  /*******************************************************************/
  /**                      INICIALIZANDO VARIAVEIS                  **/
  /*******************************************************************/
  
  begin
  
    V_ERRO_PROCESSAMENTO := 'N';
    vErro                := 'N';
    V_VERIFICAMAXCTRC    := '';
    V_VERIFICACTRC       := NULL;
    V_CTRC               := NULL;
    V_MAXCTRC            := 0;
    V_PESOCOBRADO        := 0;
    V_PESOREAL           := 0;
    V_PESOCUBADO         := 0;
    V_PESOBALANCA        := 0;
    V_PESOCOBRADONEW     := 0;
    V_PESOREALNEW        := 0;
    V_PESOCUBADONEW      := 0;
    V_PESOBALANCANEW     := 0;
    V_QTDENTREGAS        := 0;
    V_CATVALEFRETE       := NULL;
    P_KM                 := NULL;
    V_KMFINAL            := NULL;
    V_CUSTOCARRETEIRO    := 0;
    V_VFCTRC             := NULL;
    V_VFNF               := NULL;
    V_COLETA             := NULL;
    V_IMAGEMNOTA         := NULL;
    V_IMAGEMCTRC         := NULL;
    V_IMAGEMNOTAVF       := '0';
    V_IMAGEMCTRCVF       := '0';
    P_ERRO_PROCESSAMENTO := NULL;
    V_CALCBONUS          := NULL;
    V_SAQUE_VF           := '1';
    V_TPCARGA            := '00';
    V_CONTADOR           := 0;
    V_ROTA               := P_ROTA;
    v_bonus              := 0;
    V_CONDESPECIAIS      := '';
    
  
  end;
  
  /*******************************************************************/
  
  /*******************************************************************/
  /**                      MOSTRANDO PARAMETROS                     **/
  /*******************************************************************/
  
  begin
    
    if P_ROTA = '999' then 
      
      
      raise_application_error(-20001, 'Paramentros '          || CHR(10) || 
                              '1 - ' || P_FCF_VEICULOCOD      || CHR(10) ||           
                              '2 - ' || P_FCF_VEICSEQ         || CHR(10) ||    
                              '3 - ' || P_ROTA                || CHR(10) ||    
                              '4 - ' || P_USUARIO             || CHR(10) ||    
                              '5 - ' || P_OBRIGACOES          || CHR(10) ||    
                              '6 - ' || P_OBSERVACAO          || CHR(10) ||    
                              '7 - ' || P_SAQUE               || CHR(10) ||    
                              '8 - ' || P_PESO                || CHR(10) ||    
                              '9 - ' || P_ERRO_PROCESSAMENTO  || CHR(10) ||  
                              '10 - '|| P_RETORNOPROCESSAMENTO); 
    end if;                          

  end;
  
  /*******************************************************************/

  /*ARRUMA OS VALORES DA TABELA T_ARM_NOTA   O "CTRC" "SERIE" "NOTA"*/
  --SP_ARM_NOTA_CTRC_VEICULO(P_FCF_VEICULOCOD, P_FCF_VEICSEQ);

  /*******************************************************************/
  /**                      PEGA PARAMETROS                          **/
  /*******************************************************************/
  
  begin
    
    sp_usu_parametrossc('comvlfrete', P_USUARIO, P_ROTA, 'PROCEDURE');

    /*VERIFICA SE FOI ADICIONADO OS DESTINOS DO CARREGAMENTO NA MESA DE CONTRATAC?O*/
    BEGIN
      SELECT COUNT(*)
        INTO V_CONTADOR
        FROM T_FCF_VEICULODISPDEST DEST
       WHERE DEST.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
         AND DEST.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CONTADOR := 0;
    END;

    IF V_CONTADOR = 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
                              CHR(10) ||
                              'NÃO FOI DEFINIDO OS DESTINOS NO CARREGAMENTO!' ||
                              CHR(10) ||
                              ' VERIFIQUE OS DESTINOS NA MESA DE CONTRATACÃO');
    END IF;
    
    OPEN C_PARAMETROS;
    LOOP
      FETCH C_PARAMETROS
        INTO V_PARAMETRO, V_PARAMTEXTO,  V_PARAMVALOR;
      EXIT WHEN C_PARAMETROS%NOtFOUND;
      IF TRIM(V_PARAMETRO) = 'ROTACOMIMG' THEN
        V_ROTASIMG := V_PARAMTEXTO;
      Elsif TRIM(V_PARAMETRO) = 'PERCENT_BONUS' THEN
        V_PERC_BONUS := V_PARAMTEXTO;
      Elsif TRIM(V_PARAMETRO) = 'VALEFRETETRAVADO' THEN
        V_ROTATRAVADA := V_PARAMTEXTO ;
      Elsif TRIM(V_PARAMETRO) = 'DIASPESQMESA' THEN
        v_diasfretemesa  := V_PARAMVALOR;
      /* Alimento a variável com o Parametro de excessão para Imagem da CTRC  { 'S' ou 'N' }*/ 
      elsif Trim(V_PARAMETRO) = 'ROTAEXIMGCTRC' THEN    V_EXCESSAO_CTRC := V_PARAMTEXTO;
      /* Alimento a variável com o Parametro de excessão para Imagem da Nota Fiscal { 'S' ou 'N' }*/
      ELSIF Trim(V_PARAMETRO) = 'ROTAEXIMGNOTA' THEN    V_EXCESSAO_NOTA := V_PARAMTEXTO;
      ELSIF Trim(V_PARAMETRO) = 'PERCTDESCCC' Then    
         v_PercetDesconto := V_PARAMVALOR;
      END If;
        
    END LOOP;
    CLOSE C_PARAMETROS;
    
  end;
  
  /*******************************************************************/
  
  
  /*******************************************************************/
  /**      VERIFICA SE A ROTA E TRAVADA E SE TEM FRETE VINCULADO    **/
  /*******************************************************************/
  
  begin
      
    If nvl(v_PercetDesconto,0) = 0 Then
       v_PercetDesconto := 20;
    End If;   
    
    If nvl(v_diasfretemesa,0) <= 2 Then
       v_diasfretemesa := 2;
    End If;   

    IF ( instr('021,036,185,197,421',P_ROTA) > 0 ) AND ( V_ROTATRAVADA = 'N' ) THEN 
       INSERT INTO dropme (a,x) VALUES ('VF:TRAVAMENTO', 'Verificar parametros -> Aplicacao : comvlfrete / Usuario : ' || P_USUARIO || ' / Rota : ' || P_ROTA);
       V_ROTATRAVADA := 'S';
    END IF;   
       
    /*PEGO OS DADOS DO VEICULO*/
    sp_busca_fcfveiculodisp(P_FCF_VEICULOCOD,
                            P_PROPRIETARIO,
                            P_MARCA,
                            P_PLACA,
                            P_LOCAL,
                            P_UF_VEICULO,
                            P_NOMEMOTORISTA,
                            P_RG,
                            P_CPF,
                            P_UF_MOTORISTA,
                            P_CNH,
                            P_TPMOTORISTA,
                            P_PLACA_SAQUE);

  end;
  
  /*******************************************************************/
  
  /*******************************************************************/
  /**       PEGO A QTDE DE ENTREGAS                                 **/
  /*******************************************************************/
  
  begin
    
    BEGIN
      
      SELECT COUNT(DISTINCT EN.GLB_CLIEND_CIDADE)
        INTO V_QTDENTREGAS
        FROM T_ARM_CARREGAMENTO CA,
             T_FCF_VEICULODISP  VD,
             T_CON_CONHECIMENTO CO,
             T_GLB_CLIEND       EN
       WHERE VD.FCF_VEICULODISP_CODIGO          = P_FCF_VEICULOCOD
         AND VD.FCF_VEICULODISP_SEQUENCIA       = P_FCF_VEICSEQ
         AND CA.FCF_VEICULODISP_CODIGO          = VD.FCF_VEICULODISP_CODIGO
         AND CA.FCF_VEICULODISP_SEQUENCIA       = VD.FCF_VEICULODISP_SEQUENCIA
         AND CA.ARM_CARREGAMENTO_CODIGO         = CO.ARM_CARREGAMENTO_CODIGO
         AND CO.GLB_CLIENTE_CGCCPFDESTINATARIO  = EN.GLB_CLIENTE_CGCCPFCODIGO
         AND CO.GLB_TPCLIEND_CODIGODESTINATARI  = EN.GLB_TPCLIEND_CODIGO
         AND CO.CON_CONHECIMENTO_FLAGCANCELADO  IS NULL;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        IF P_RETORNOPROCESSAMENTO IS NULL THEN
          P_RETORNOPROCESSAMENTO := ' Localidade de Entrega Vazio-> ' ||
                                    P_PLACA;
        ELSE
          P_RETORNOPROCESSAMENTO := P_RETORNOPROCESSAMENTO || CHR(10) ||
                                    ' Localidade Entrega Vazio -> ' ||
                                    P_PLACA;
        END IF;
        V_QTDENTREGAS := 0;
      END;
    END;

  end;
  
  /*******************************************************************/

  /*******************************************************************/
  /**        PEGO O TIPO DE VEICULO                                 **/
  /*******************************************************************/
  
  begin
    
    BEGIN
      SELECT V.FCF_TPVEICULO_CODIGO
        INTO V_TPVEICULO
        FROM T_FCF_VEICULODISP V
       WHERE V.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
         AND V.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          IF P_RETORNOPROCESSAMENTO IS NULL THEN
            P_RETORNOPROCESSAMENTO := 'TP VEICULO Vazio -> ' || P_PLACA;
          ELSE
            P_RETORNOPROCESSAMENTO := P_RETORNOPROCESSAMENTO || CHR(10) ||
                                      ' TP VEICULO Vazio -> ' || P_PLACA;
          END IF;
          V_TPVEICULO := '';
        END;
    END;
    
  end;
  
  /*******************************************************************/ 


  /*******************************************************************/
  /**        ANALISE DA ROTA DO VALE DE FRETE                       **/
  /*******************************************************************/
  
  begin
    
    /*******************************************************************/  
    /*             BUSCA DA ROTA POR  CARREGAMENTOS                    */
    /*******************************************************************/ 
    FOR R_CTRC IN C_CARREGAMENTO LOOP
      
      BEGIN
       
        SELECT COUNT(*)
          INTO V_CONTADOR
          FROM T_CON_CONHECIMENTO CO
         WHERE CO.GLB_ROTA_CODIGO         = V_ROTA
           AND CO.ARM_CARREGAMENTO_CODIGO = R_CTRC.ARM_CARREGAMENTO_CODIGO
           AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL;
           
        IF V_CONTADOR > 0 THEN
          EXIT;
        END IF;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_CONTADOR := 0;
      END;
      
    END LOOP;
    /*******************************************************************/
    
    /*******************************************************************/
    /*             BUSCA DA ROTA POR CONHECIMENTOS VINCULADOS          */
    /*******************************************************************/
    IF (V_CONTADOR = 0) THEN
    
      FOR R_CTRC3 IN C_CONHECIMENTO LOOP
        
         BEGIN
           
         SELECT COUNT(*)
            INTO V_CONTADOR
            FROM T_CON_CONHECIMENTO CO
           WHERE CO.GLB_ROTA_CODIGO                         = V_ROTA
             AND CO.CON_CONHECIMENTO_CODIGO                 = R_CTRC3.CON_CONHECIMENTO_CODIGO
             AND CO.CON_CONHECIMENTO_SERIE                  = R_CTRC3.CON_CONHECIMENTO_SERIE
             AND CO.GLB_ROTA_CODIGO                         = R_CTRC3.GLB_ROTA_CODIGO 
             AND NVL(CO.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N';
             
          IF V_CONTADOR > 0 THEN
            EXIT;
          END IF;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_CONTADOR := 0;
        END;
        
      END LOOP;  
    
    END IF;
    /*******************************************************************/
    
    if V_ROTA  = '000' then 
       V_ROTA := '000';
    end if;
    
    IF V_CONTADOR = 0 THEN
      BEGIN
        IF V_ROTA <> '000' THEN 
        SELECT AR.GLB_ROTA_CODIGONF
          INTO V_ROTA
          FROM T_ARM_ARMAZEM AR
         WHERE AR.GLB_ROTA_CODIGO = V_ROTA;
        END IF; 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_ROTA := NULL;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  CHR(10) ||
                                  'OCORREU ALGUM ERRO AO PESQUISAR A ROTA DA NOTA FISCAL DE SERVICO ROTA: ' ||
                                  V_ROTA || CHR(10) || CHR(10) ||
                                  'DESCRICÃO DO "SELECT"' || CHR(10) ||
                                  'SELECT AR.GLB_ROTA_CODIGONF FROM T_ARM_ARMAZEM AR WHERE AR.GLB_ROTA_CODIGO = ' ||
                                  V_ROTA);
      END;
    END IF;

    IF V_ROTA IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,
                              CHR(10) ||
                              'ERRO AO IDENTIFICAR A ROTA DOS CONHECIMENTOS! Rota Passada - ' || V_rota || 
                              CHR(10) ||
                              'VERIFIQUE OS CONHECIMENTOS OU CONTATE A EQUIPE DE TI');
    END IF;
    
  end;
  
  /*******************************************************************/
  
  
  /*******************************************************************/
  /**         PEGO MAIOR CTRC E SERIE DO VALE FRETE                 **/
  /*******************************************************************/
  
  begin
    
    /** QUANDO FOR CTE DE CARREGAMENTO                  **/
    FOR R_CTRC IN C_CARREGAMENTO LOOP 
      
     begin
       
        SELECT CO.CON_CONHECIMENTO_CODIGO,
               CO.CON_CONHECIMENTO_SERIE,
               CO.CON_VIAGEM_NUMERO
          INTO V_VERIFICAMAXCTRC, 
               V_CTRCSERIE, 
               V_VIAGEMNUMERO
          FROM T_CON_CONHECIMENTO CO, 
               T_ARM_CARREGAMENTO CA
         WHERE CA.ARM_CARREGAMENTO_CODIGO = R_CTRC.ARM_CARREGAMENTO_CODIGO
           AND CO.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
           AND CO.GLB_ROTA_CODIGO         = V_ROTA
           AND CO.CON_CONHECIMENTO_CODIGO =  (SELECT MAX(CO2.CON_CONHECIMENTO_CODIGO)
                                                FROM T_CON_CONHECIMENTO CO2
                                               WHERE CO2.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
                                                 AND CO2.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
                                                 AND CO2.GLB_ROTA_CODIGO = CO.GLB_ROTA_CODIGO
                                                 AND 0 = (SELECT COUNT(*)
                                                            FROM T_CON_VALEFRETE V
                                                           WHERE V.CON_CONHECIMENTO_CODIGO = CO2.CON_CONHECIMENTO_CODIGO
                                                             AND V.CON_CONHECIMENTO_SERIE = CO2.CON_CONHECIMENTO_SERIE
                                                             AND V.GLB_ROTA_CODIGO = CO2.GLB_ROTA_CODIGO
                                                             AND NVL(V.CON_VALEFRETE_STATUS, 'I') <> 'C'))
         AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL;
     
     Exception
       
        WHEN NO_DATA_FOUND THEN
          V_VERIFICAMAXCTRC := V_VERIFICAMAXCTRC;
          V_CTRCSERIE       := V_CTRCSERIE;
          V_VIAGEMNUMERO    := V_VIAGEMNUMERO;
          BEGIN
            SELECT CO.CON_CONHECIMENTO_CODIGO,
                   CO.CON_CONHECIMENTO_SERIE,
                   CO.CON_VIAGEM_NUMERO
              INTO V_VERIFICAMAXCTRC, 
                   V_CTRCSERIE, 
                   V_VIAGEMNUMERO
              FROM T_CON_CONHECIMENTO CO, 
                   T_ARM_CARREGAMENTO CA
             WHERE CA.ARM_CARREGAMENTO_CODIGO = R_CTRC.ARM_CARREGAMENTO_CODIGO
               AND CO.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
               AND CO.GLB_ROTA_CODIGO = V_ROTA
               AND CO.CON_CONHECIMENTO_CODIGO =  (SELECT MAX(CO2.CON_CONHECIMENTO_CODIGO)
                                                    FROM T_CON_CONHECIMENTO CO2
                                                   WHERE CO2.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
                                                     AND CO2.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
                                                     AND CO2.GLB_ROTA_CODIGO = CO.GLB_ROTA_CODIGO
                                                     AND 0 < (SELECT COUNT(*)
                                                                FROM T_CON_VALEFRETE V
                                                               WHERE V.CON_CONHECIMENTO_CODIGO = CO2.CON_CONHECIMENTO_CODIGO
                                                                 AND V.CON_CONHECIMENTO_SERIE = CO2.CON_CONHECIMENTO_SERIE
                                                                 AND V.GLB_ROTA_CODIGO = CO2.GLB_ROTA_CODIGO
                                                                 AND NVL(V.CON_VALEFRETE_STATUS, 'I') <> 'C'))
             AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL;
/*             RAISE_APPLICATION_ERROR(-20001, CHR(10) ||
                                     '******************************************' || CHR(10) ||
                                     'JA EXISTE UM VALE DE FRETE COM ESTE NUMERO' || CHR(10) ||
                                     ' CTRC  = ' || V_MAXCTRC   || CHR(10) ||
                                     ' SERIE = ' || V_CTRCSERIE || CHR(10) ||
                                     ' ROTA  = ' || V_ROTA      || CHR(10) ||
                                     ' SAQUE = ' || V_SAQUE_VF  || CHR(10) ||
                                     '******************************************' ||V_VERIFICAMAXCTRC|| CHR(10));*/
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              
             V_VERIFICAMAXCTRC := V_VERIFICAMAXCTRC;
             V_CTRCSERIE       := V_CTRCSERIE;
             V_VIAGEMNUMERO    := V_VIAGEMNUMERO;
            END ;   
     
     
     end;
       
     IF V_MAXCTRC < V_VERIFICAMAXCTRC THEN
        V_MAXCTRC := V_VERIFICAMAXCTRC;
     END IF;
    
    END LOOP;
    
    
    /** QUANDO FOR CONHECIMENTO VINCULADO VIA VEIC DISP **/
    IF ((V_MAXCTRC = 0) OR (V_VERIFICAMAXCTRC is null)) and (V_CONTADOR > 0) THEN
      
      FOR R_CTRC2 IN C_CONHECIMENTO LOOP
        
          BEGIN
            
            SELECT CO.CON_CONHECIMENTO_CODIGO,
                   CO.CON_CONHECIMENTO_SERIE,
                   CO.CON_VIAGEM_NUMERO
              INTO V_VERIFICAMAXCTRC, 
                   V_CTRCSERIE, 
                   V_VIAGEMNUMERO
              FROM T_CON_CONHECIMENTO CO
             WHERE CO.CON_CONHECIMENTO_CODIGO        = R_CTRC2.CON_CONHECIMENTO_CODIGO
               AND CO.CON_CONHECIMENTO_SERIE         = R_CTRC2.CON_CONHECIMENTO_SERIE
               AND CO.GLB_ROTA_CODIGO                = R_CTRC2.GLB_ROTA_CODIGO
               AND nvl(CO.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N'
               AND 0 = (SELECT COUNT(*)
                          FROM T_CON_VALEFRETE V
                         WHERE V.CON_CONHECIMENTO_CODIGO = CO.CON_CONHECIMENTO_CODIGO
                           AND V.CON_CONHECIMENTO_SERIE  = CO.CON_CONHECIMENTO_SERIE
                           AND V.GLB_ROTA_CODIGO         = CO.GLB_ROTA_CODIGO
                           AND NVL(V.CON_VALEFRETE_STATUS, 'I') <> 'C');
                         
          EXCEPTION WHEN OTHERS THEN
               V_VERIFICAMAXCTRC := V_VERIFICAMAXCTRC;
               V_CTRCSERIE       := V_CTRCSERIE;
               V_VIAGEMNUMERO    := V_VIAGEMNUMERO;
               RAISE_APPLICATION_ERROR(-20001,SQLERRM);
          END;
          
          IF V_MAXCTRC < V_VERIFICAMAXCTRC THEN
            V_MAXCTRC := V_VERIFICAMAXCTRC;
          END IF;
                                                  
      END LOOP;   
      
    end if;  
  
    
    /** ANALISE DO NIMERO DO VALE DE FRETE QUANDO O     **/
    /** VEIC TIVER SOMENTE CARGA DE TRANSFERENCIA       **/
    
    
    --RAISE_APPLICATION_ERROR(-20001,v_rota);
    
    IF (V_MAXCTRC = 0) OR (V_VERIFICAMAXCTRC is null) THEN
      
       FOR R_CARREG IN C_CARREGAMENTO LOOP 
        
       begin
         
        FOR VF_CURSOR IN (select ch.con_conhecimento_codigo,
                                 ch.con_conhecimento_serie,
                                 ch.glb_rota_codigo,
                                 ch.con_viagem_numero,
                                 c.con_valefrete_codigo,
                                 c.con_valefrete_serie,
                                 c.glb_rota_codigovalefrete,
                                 c.con_valefrete_saque
                            from t_con_conhecimento ch,
                                 t_con_vfreteconhec c
                           where ch.arm_carregamento_codigo                 = r_carreg.arm_carregamento_codigo
                             and ch.glb_rota_codigo                         <> P_ROTA
                             and c.glb_rota_codigovalefrete                 <> P_ROTA
                             and nvl(ch.con_conhecimento_flagcancelado,'N') = 'N'
                             and ch.con_conhecimento_codigo                 = c.con_conhecimento_codigo
                             and ch.con_conhecimento_serie                  = c.con_valefrete_serie
                             and ch.glb_rota_codigo                         = c.glb_rota_codigo)
        LOOP
          
          IF (To_Number(vf_cursor.con_valefrete_codigo) > To_Number(vValeFreteCte) ) THEN
            
            vValeFreteCte    := vf_cursor.con_valefrete_codigo; 
            vValeFreteSerie  := vf_cursor.con_valefrete_serie;
            vValeFretRota    := vf_cursor.glb_rota_codigovalefrete;
            vValeFreteSq     := vf_cursor.con_valefrete_saque;
            vCodViagem       := vf_cursor.con_viagem_numero;
          
          end if;
          
        END LOOP;  
          
       Exception When Others Then
         V_VERIFICAMAXCTRC := V_VERIFICAMAXCTRC;
         V_CTRCSERIE       := V_CTRCSERIE;
         V_VIAGEMNUMERO    := V_VIAGEMNUMERO;
       end;
         
       IF V_MAXCTRC < vValeFreteCte THEN
          
          V_MAXCTRC         := vValeFreteCte;
          V_CTRCSERIE       := vValeFreteSerie;
          V_ROTA            := vValeFretRota;
          V_VERIFICAMAXCTRC := vValeFreteCte;
          
          Select Max(vf.con_valefrete_saque)
            into vValeFreteSq
            from t_con_valefrete vf
           where vf.con_conhecimento_codigo = vValeFreteCte
             and vf.con_conhecimento_serie  = vValeFreteSerie
             and vf.glb_rota_codigo         = vValeFretRota;
             
         V_SAQUE_VF := nvl(vValeFreteSq,0) + 1;
             
       END IF;
      
      END LOOP;
      
    END IF;  
    
    
    /** SE NÃO ENCONTRAR NUMERO DO VALE DE FRETE        **/
    IF (V_MAXCTRC = 0) OR (V_VERIFICAMAXCTRC is null) THEN
      
      RAISE_APPLICATION_ERROR(-20001,'Erro ao identificar o numero do do Vale Frete a ser criado!!!');  
    
    END IF;      

  end;
  
  /*******************************************************************/
  
  
  /*******************************************************************/
  /**         ANALISE DE SERIE E SAQUE                              **/
  /*******************************************************************/
  
  begin
      
      
    IF V_CTRCSERIE = NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'NÃO EXISTE NOS CARREGAMENTOS A ROTA DA FILIAL! VERIFIQUE OS CONHECIMENTOS!');
    END IF;

    V_SAQUE_CONTADOR := 1;
    
--    WHILE V_SAQUE_CONTADOR <> 0 LOOP
      BEGIN
        
        SELECT max(co.con_valefrete_saque)
--        Select count(*)
          INTO V_SAQUE_CONTADOR
          FROM T_CON_VALEFRETE CO
         WHERE CO.CON_CONHECIMENTO_CODIGO  = V_MAXCTRC
           AND CO.CON_CONHECIMENTO_SERIE   = V_CTRCSERIE
           AND CO.GLB_ROTA_CODIGO          = V_ROTA
--           AND CO.CON_VALEFRETE_SAQUE      = V_SAQUE_VF
--           AND CO.CON_VALEFRETE_STATUS     = 'C'
         ;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_SAQUE_CONTADOR := 0;
      END;
--      IF V_SAQUE_CONTADOR > 0 THEN
        V_SAQUE_VF := TO_CHAR(TO_NUMBER(nvl(V_SAQUE_CONTADOR,0)) + 1);
--      END IF;
--    END LOOP;
  
  end;
  
  /*******************************************************************/
  
  
  /*******************************************************************/
  /**         MONTO O CAMPO TRANSP. DOS BENS.....                   **/
  /*******************************************************************/

  begin
    
    FOR R_MANIFESTO IN C_CARREGAMENTO LOOP
      
      FOR R_MANCAR IN (SELECT CA.ARM_CARREGAMENTO_FLAGMANIFESTO,
                              MA.CON_MANIFESTO_CODIGO
                         FROM T_ARM_CARREGAMENTO CA, T_CON_MANIFESTO MA
                        WHERE CA.ARM_CARREGAMENTO_CODIGO = R_MANIFESTO.ARM_CARREGAMENTO_CODIGO
                          AND CA.ARM_CARREGAMENTO_CODIGO = MA.ARM_CARREGAMENTO_CODIGO) LOOP
        IF V_VFCTRC IS NULL THEN
          V_VFCTRC := 'M' || R_MANCAR.CON_MANIFESTO_CODIGO;
        ELSE
          V_VFCTRC := SUBSTR(trim(V_VFCTRC) || ' ; M ' ||
                             trim(R_MANCAR.CON_MANIFESTO_CODIGO),
                             1,
                             100);
        END IF;
      END LOOP;
      
      FOR R_NUMCTRC IN (SELECT CO.CON_CONHECIMENTO_CODIGO,
                               CO.GLB_ROTA_CODIGO,
                               CLR.glb_cliente_ctrcimg,
                               CLS.glb_grupoeconomico_codigo,
                               pkg_con_cte.FN_CTE_EELETRONICO(co.con_conhecimento_codigo,co.con_conhecimento_serie,co.glb_rota_codigo) ELETRONICO
                          FROM T_CON_CONHECIMENTO CO,
                               T_ARM_CARREGAMENTO CA,
                               T_GLB_CLIENTE      CLR,
                               T_GLB_CLIENTE      CLS
                         WHERE CA.ARM_CARREGAMENTO_CODIGO = R_MANIFESTO.ARM_CARREGAMENTO_CODIGO
                           AND CO.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
                           AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
                           AND CO.glb_cliente_cgccpfremetente = CLR.glb_cliente_cgccpfcodigo
                           AND CO.glb_cliente_cgccpfsacado = CLS.glb_cliente_cgccpfcodigo
                         ORDER BY CO.CON_CONHECIMENTO_CODIGO ASC) LOOP
        -------------- INICIO ---------------
        -- Verifica se esta auotrizado na SEFAZ
        -- Se for NFS ou NFSe retorna S
        if R_NUMCTRC.ELETRONICO = 'N' Then
           V_ERRO_PROCESSAMENTO := 'E';
           P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                     CHR(10) || 'CteÑAUT=' ||
                                     R_NUMCTRC.CON_CONHECIMENTO_CODIGO || '-' ||
                                     R_NUMCTRC.Glb_Rota_Codigo,
                                     1,200);
        End If;
          
        
        IF R_NUMCTRC.Glb_Cliente_Ctrcimg = 'S' THEN
            /* VERIFICO SE O CTRC E ELETRONICO */
--            IF (INSTR(V_ROTASIMG, V_ROTA) > 0) or (length(trim(nvl(V_ROTASIMG,''))) = 0 ) THEN
              IF fn_busca_xml_ctrc_NF(R_NUMCTRC.CON_CONHECIMENTO_CODIGO,
                                      R_NUMCTRC.GLB_ROTA_CODIGO,
                                      NULL,
                                      NULL,
                                      NULL) = 'N' THEN
                BEGIN
                  SELECT ICO.CON_CONHECIMENTO_CODIGO,ico.glb_tparquivo_codigo,count(*)
                    INTO V_IMAGEMCTRC,
                         V_TPARQUIVO,
                         V_QTDIMG
                    FROM T_GLB_COMPIMAGEM ICO
                   WHERE ICO.CON_CONHECIMENTO_CODIGO = R_NUMCTRC.CON_CONHECIMENTO_CODIGO
                     AND ICO.GLB_ROTA_CODIGO = R_NUMCTRC.GLB_ROTA_CODIGO
                     and ico.glb_tpimagem_codigo = '0001'
                     AND ICO.GLB_COMPIMAGEM_ARQUIVADO = 'S'
                   group by ICO.CON_CONHECIMENTO_CODIGO,ico.glb_tparquivo_codigo  ;
                     -- ACHOU FRENTE E VERSO E TIPO DE ARQUIVO = A JPG
                   /*  IF V_QTDIMG <> 2 AND V_TPARQUIVO = '0002'  THEN
                        V_IMAGEMCTRC := NULL;
                     END IF;  --Retirado 06/09/2013 por Lucas e Sirlano!*/  
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    V_IMAGEMCTRC := NULL;
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20001,'IMAGEM DUPLICADA CTRC ' ||  R_NUMCTRC.CON_CONHECIMENTO_CODIGO || '-' ||R_NUMCTRC.GLB_ROTA_CODIGO || '-' || SQLERRM);
                END;
                IF ((V_IMAGEMCTRC IS NULL) AND
                   (R_NUMCTRC.GLB_GRUPOECONOMICO_CODIGO <> '0020') AND
                   (R_NUMCTRC.GLB_CLIENTE_CTRCIMG = 'N')) THEN
                  V_IMAGEMCTRC := 'CIFSIMG';
                END IF;
              
                -- A partir do Paramentro, libero a rota mesmo sem a imagem
                IF V_EXCESSAO_CTRC = 'S' then
                  V_IMAGEMCTRC := 'Liberada';
                end if;
                

                -- klayton em 24/11/2015
                
                V_IMAGEMCTRC := 'liberada';
                   
            
              
                IF V_IMAGEMCTRC IS NULL THEN
                  V_IMAGEMCTRCVF         := '1';
                  V_ERRO_PROCESSAMENTO   := 'E';
                  P_RETORNOPROCESSAMENTO := substr(trim(P_RETORNOPROCESSAMENTO) ||
                                                   CHR(10) || ' FIMG X CTRC=' ||
                                                   R_NUMCTRC.CON_CONHECIMENTO_CODIGO || '-' ||
                                                   R_NUMCTRC.Glb_Rota_Codigo,
                                                   1,
                                                   200);
                
                  INSERT INTO T_GLB_CONTROLEIMAGENS img
                    (IMG.TIPO,
                     NUMERO,
                     CNPJ,
                     ROTA,
                     DATA,
                     USUARIO,
                     IMAGEM,
                     ARM_CARREGAMENTO_CODIGO)
                  VALUES
                    ('CTRC',
                     R_NUMCTRC.CON_CONHECIMENTO_CODIGO,
                     NULL,
                     R_NUMCTRC.GLB_ROTA_CODIGO,
                     SYSDATE,
                     P_USUARIO,
                     'N',
                     R_MANIFESTO.ARM_CARREGAMENTO_CODIGO);
                END IF;
              END IF;
--            END IF;
            /* VERIFICO SE O CTRC E ELETRONICO */
            ---------------- FIM ----------------
            IF V_VERIFICACTRC IS NULL THEN
              V_VERIFICACTRC := R_NUMCTRC.CON_CONHECIMENTO_CODIGO;
              IF V_VFCTRC IS NULL THEN
                V_VFCTRC := 'C' || R_NUMCTRC.CON_CONHECIMENTO_CODIGO;
              ELSE
                V_VFCTRC := SUBSTR(V_VFCTRC || ';C' ||
                                   R_NUMCTRC.CON_CONHECIMENTO_CODIGO,
                                   1,
                                   100);
              END IF;
            ELSE
              IF (R_NUMCTRC.CON_CONHECIMENTO_CODIGO - V_VERIFICACTRC) <> 1 THEN
                IF V_VFCTRC IS NULL THEN
                  V_VFCTRC       := 'C' || R_NUMCTRC.CON_CONHECIMENTO_CODIGO;
                  V_VERIFICACTRC := R_NUMCTRC.CON_CONHECIMENTO_CODIGO;
                ELSE
                  V_VFCTRC       := SUBSTR(V_VFCTRC || 'a C' ||
                                           R_NUMCTRC.CON_CONHECIMENTO_CODIGO,
                                           1,
                                           100);
                  V_VERIFICACTRC := NULL;
                END IF;
              ELSE
                V_VERIFICACTRC := R_NUMCTRC.CON_CONHECIMENTO_CODIGO;
              END IF;
            END IF;
         END IF;      
      END LOOP;
      
      IF V_VERIFICACTRC IS NOT NULL THEN
        V_VFCTRC := SUBSTR(V_VFCTRC || 'a C' || V_VERIFICACTRC, 1, 100);
      END IF;
    
    END LOOP;
  
  end;
  
  /*******************************************************************/
  
  
  /*******************************************************************/
  /**         MONTO O CAMPO NOTAS FISCAIS                           **/
  /*******************************************************************/
  
  begin
    
    V_VFCTRC := V_VFCTRC;
    
    FOR R_NFS IN C_CARREGAMENTO LOOP
      
      BEGIN
        
        FOR R_NOTAS IN (SELECT lpad(NT.ARM_NOTA_NUMERO, 6, '0')                      ARM_NOTA_NUMERO,
                               NT.ARM_NOTA_NUMERO                                    ARM_NOTA_NUMERO2,
                               LPAD(NT.GLB_CLIENTE_CGCCPFREMETENTE, 14, '0')         GLB_CLIENTE_CGCCPFREMETENTE,
                               NT.GLB_ROTA_CODIGO,
                               fn_busca_xml_ctrc_NF(NULL,NULL,NT.ARM_NOTA_NUMERO,NT.GLB_CLIENTE_CGCCPFREMETENTE,NT.ARM_MOVIMENTO_DATANFENTRADA) ELETRONICO,
                               CLd.glb_cliente_notaimg,
                               NT.arm_nota_tabsolcod,
                               CLd.glb_grupoeconomico_codigo
                          FROM 
                            T_ARM_CARREGAMENTO     CA,
                            t_arm_carregamentodet  CD,
                            T_ARM_EMBALAGEM        EM,
                            T_ARM_NOTA             NT,
                            t_glb_cliente          clR,
                           T_GLB_CLIENTE           CLd
                         WHERE 
                           --Passo o número do carregamento recuperado no cursor de carregamento.
                            CA.ARM_CARREGAMENTO_CODIGO = R_NFS.ARM_CARREGAMENTO_CODIGO

                           --Carregamento com a carregamentodet 
                           And CD.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
                           
                           --Carregamentodet com a embalagem.
                           And CD.ARM_EMBALAGEM_NUMERO = EM.ARM_EMBALAGEM_NUMERO
                           And CD.ARM_EMBALAGEM_FLAG = EM.ARM_EMBALAGEM_FLAG
                           And CD.ARM_EMBALAGEM_SEQUENCIA = EM.ARM_EMBALAGEM_SEQUENCIA
                           
                           --Embalagem com Nota Fiscal (arm_nota)
                           And EM.ARM_EMBALAGEM_NUMERO = NT.ARM_EMBALAGEM_NUMERO
                           And EM.ARM_EMBALAGEM_FLAG = NT.ARM_EMBALAGEM_FLAG
                           And EM.ARM_EMBALAGEM_SEQUENCIA = NT.ARM_EMBALAGEM_SEQUENCIA
                           
                           --Nota com Cliente_Remetente
                           and RPAD(nt.glb_cliente_cgccpfremetente,20) = clR.glb_cliente_cgccpfcodigo
                           
                           --Nota com Cliente_Sacado.
                           AND RPAD(NT.glb_cliente_cgccpfsacado,20) = cld.glb_cliente_cgccpfcodigo)
         LOOP
           
           IF (R_NOTAS.GLB_CLIENTE_NOTAIMG = 'S') AND 
             (nvl(R_NOTAS.arm_nota_tabsolcod,'00000000')  <> '00051803' ) AND 
             (nvl(R_NOTAS.arm_nota_tabsolcod,'00000000')  <> '00051804' ) THEN                 
--              IF (INSTR(V_ROTASIMG, V_ROTA) > 0) or (length(trim(nvl(V_ROTASIMG,''))) = 0 ) THEN
              
                /* VERIFICO SE O NOTA E ELETRONICO */
                IF R_NOTAS.ELETRONICO = 'N' THEN
                  BEGIN
                    SELECT distinct lpad(to_number(INF.CON_NFTRANSPORTADA_NUMNFISCAL),9,'0')
                      INTO V_IMAGEMNOTA
                      FROM T_GLB_NFIMAGEM INF
                     WHERE to_number(INF.CON_NFTRANSPORTADA_NUMNFISCAL) = To_number( R_NOTAS.ARM_NOTA_NUMERO2 )
                       AND INF.GLB_CLIENTE_CGCCPFCODIGO = rpad(R_NOTAS.GLB_CLIENTE_CGCCPFREMETENTE, 20)
                       AND INF.GLB_NFIMAGEM_ARQUIVADO = 'S';
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      V_IMAGEMNOTA := NULL;
                    when others then
                      RAISE_APPLICATION_ERROR(-20001,'VERIFICAR A NOTA ' || R_NOTAS.ARM_NOTA_NUMERO2 || ' CNPJ ' || rpad(R_NOTAS.GLB_CLIENTE_CGCCPFREMETENTE, 20) || 'erro-' || sqlerrm);
                  END;
                
                  IF (V_IMAGEMNOTA IS NULL) AND
                     (R_NOTAS.GLB_GRUPOECONOMICO_CODIGO <> '0020') AND
                     (R_NOTAS.GLB_CLIENTE_NOTAIMG = 'N' ) AND 
                     (nvl(R_NOTAS.arm_nota_tabsolcod,'00000000')  <> '00051803' ) AND 
                     (nvl(R_NOTAS.arm_nota_tabsolcod,'00000000')  <> '00051804' ) THEN                 
                    V_IMAGEMNOTA := -9;
                  END IF;
                  
                  -- A partir do Paramentro, libero a rota mesmo sem a imagem
                  IF V_EXCESSAO_NOTA = 'S' then
                    V_IMAGEMNOTA := 0;
                  end if;
                  -- 0 = liberada (Thiago 13/07/2011 - autorizado pelo Sirlano)
                
                
                  IF (V_IMAGEMNOTA IS NULL)  THEN 
                    V_IMAGEMNOTAVF         := 1;
                    V_ERRO_PROCESSAMENTO   := 'E';
                    P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                                     CHR(10) || ' FIMG NF-' ||
                                                     R_NOTAS.ARM_NOTA_NUMERO,
                                                     1,
                                                     200) || ' CNPJ-' ||R_NOTAS.GLB_CLIENTE_NOTAIMG ||'-' ||
                                              R_NOTAS.GLB_CLIENTE_CGCCPFREMETENTE || '-' || P_ROTA;
                    INSERT INTO T_GLB_CONTROLEIMAGENS img
                      (IMG.TIPO,
                       NUMERO,
                       CNPJ,
                       ROTA,
                       DATA,
                       USUARIO,
                       IMAGEM,
                       ARM_CARREGAMENTO_CODIGO)
                    VALUES
                      ('NF',
                       R_NOTAS.ARM_NOTA_NUMERO,
                       R_NOTAS.GLB_CLIENTE_CGCCPFREMETENTE,
                       R_NOTAS.GLB_ROTA_CODIGO,
                       SYSDATE,
                       P_USUARIO,
                       'N',
                       R_NFS.ARM_CARREGAMENTO_CODIGO);
                  END IF;
                END IF;
              
--              END IF;
              IF V_VFNF IS NULL THEN
                V_VFNF := R_NOTAS.ARM_NOTA_NUMERO;
              ELSE
                V_VFNF := substr(V_VFNF || '; ' ||
                                 TO_CHAR(R_NOTAS.ARM_NOTA_NUMERO),
                                 1,
                                 100);
              END IF;
           
           END IF;    
        
         END LOOP;
      
        --NOTAS FISCAIS QU8E SÃO PROVENIENTES DE CTRC´S DA DIG MANUAL. 
        FOR R_NOTAS_2 IN (SELECT TR.CON_NFTRANSPORTADA_NUMNFISCAL
                            FROM T_CON_NFTRANSPORTA TR,
                                 T_CON_VEICCONHEC V
                           WHERE TR.CON_CONHECIMENTO_CODIGO = V.CON_CONHECIMENTO_CODIGO
                             AND TR.CON_CONHECIMENTO_SERIE  = V.CON_CONHECIMENTO_SERIE
                             AND TR.GLB_ROTA_CODIGO         = V.GLB_ROTA_CODIGO
                             AND V.FCF_VEICULODISP_CODIGO   = P_FCF_VEICULOCOD      
                         AND V.FCF_VEICULODISP_SEQUENCIA= P_FCF_VEICSEQ)
        LOOP
              IF V_VFNF IS NULL THEN
                V_VFNF := R_NOTAS_2.CON_NFTRANSPORTADA_NUMNFISCAL;
              ELSE
                V_VFNF := substr(V_VFNF || '; ' ||
                                 TO_CHAR(R_NOTAS_2.CON_NFTRANSPORTADA_NUMNFISCAL),
                                 1,
                                 100);
              END IF;
        
        END LOOP;
            
        
        
      END;
      
    END LOOP;
  
  end;
  
  /*******************************************************************/
  

  /*******************************************************************/
  /**    PEGO OS PESOS (NOMINAL, COBRADO, CUBADO, BALANCA           **/
  /*******************************************************************/
  
  begin
    
    FOR R_PESOS IN C_CARREGAMENTO LOOP
      BEGIN
        FOR R_PESOTOTAL IN (SELECT CA.ARM_CARREGAMENTO_PESOCOBRADO,
                                   CA.ARM_CARREGAMENTO_PESOREAL,
                                   CA.ARM_CARREGAMENTO_PESOBALANCA,
                                   CA.ARM_CARREGAMENTO_PESOCUBADO
                              FROM T_ARM_CARREGAMENTO CA
                             WHERE CA.ARM_CARREGAMENTO_CODIGO = R_PESOS.ARM_CARREGAMENTO_CODIGO) 
       LOOP
          IF V_PESOCOBRADONEW < R_PESOTOTAL.ARM_CARREGAMENTO_PESOCOBRADO THEN
            V_PESOCOBRADONEW := V_PESOCOBRADONEW +
                                R_PESOTOTAL.ARM_CARREGAMENTO_PESOCOBRADO;
          END IF;
          IF V_PESOREALNEW < R_PESOTOTAL.ARM_CARREGAMENTO_PESOREAL THEN
            V_PESOREALNEW := V_PESOREALNEW +
                             R_PESOTOTAL.ARM_CARREGAMENTO_PESOREAL;
          END IF;
          IF V_PESOBALANCANEW < R_PESOTOTAL.ARM_CARREGAMENTO_PESOBALANCA THEN
            V_PESOBALANCANEW := V_PESOBALANCANEW +
                                R_PESOTOTAL.ARM_CARREGAMENTO_PESOBALANCA;
          END IF;
          IF V_PESOCUBADONEW < R_PESOTOTAL.ARM_CARREGAMENTO_PESOCUBADO THEN
            V_PESOCUBADONEW := V_PESOCUBADONEW +
                               R_PESOTOTAL.ARM_CARREGAMENTO_PESOCUBADO;
          END IF;
        END LOOP;
      END;
    END LOOP;
  
  end;
  
  /*******************************************************************/

  /*******************************************************************/
  /**    PEGO O NOME DO USUARIO                                     **/
  /*******************************************************************/
  
  begin
    
    BEGIN
      SELECT US.USU_USUARIO_NOME
        INTO V_USUARIO
        FROM T_USU_USUARIO US
       WHERE US.USU_USUARIO_CODIGO = P_USUARIO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_USUARIO := NULL;
    END;
  
  end;
  
  /*******************************************************************/

  
  /*******************************************************************/
  /**    VERIFICO A CATEGORIA DO VALE DE FRETE                      **/
  /*******************************************************************/
  
  begin
  
    BEGIN
      SELECT COUNT(CA.ARM_CARREGAMENTO_FLAGMANIFESTO)
        INTO V_CATVF
        FROM T_ARM_CARREGAMENTO CA, T_FCF_VEICULODISP VD
       WHERE VD.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
         AND VD.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
         AND CA.ARM_CARREGAMENTO_FLAGMANIFESTO = 'M'
         AND CA.FCF_VEICULODISP_CODIGO = VD.FCF_VEICULODISP_CODIGO
         AND CA.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          IF P_RETORNOPROCESSAMENTO IS NULL THEN
            P_RETORNOPROCESSAMENTO := 'CAT VF não encontrada -> ' ||
                                      P_PLACA;
          ELSE
            P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                             CHR(10) ||
                                             ' CAT VF n?o encontrada -> ' ||
                                             P_PLACA,
                                             1,
                                             200);
          END IF;
          V_CATVF := NULL;
        END;
    END;
  
    BEGIN
      SELECT RR.GLB_ROTA_CALCBONUS
        INTO V_CALCBONUS
        FROM T_GLB_ROTA RR
       WHERE RR.GLB_ROTA_CODIGO = V_ROTA;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CALCBONUS := NULL;
    END;
  
    IF V_CATVF >= 1 THEN
      V_CATVALEFRETE := '11';
    ELSE
      V_CATVALEFRETE := '01';
    END IF;
  
  end;
  
  /*******************************************************************/

  /*******************************************************************/
  /**    PEGO A LOTAC?O DO VEICULO                                  **/
  /*******************************************************************/
  
  begin
      
      
    BEGIN
      SELECT V.FCF_TPVEICULO_LOTACAO
        INTO V_LOTACAO
        FROM T_FCF_TPVEICULO V, 
             T_FCF_VEICULODISP VD
       WHERE VD.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
         AND VD.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
         AND V.FCF_TPVEICULO_CODIGO = VD.FCF_TPVEICULO_CODIGO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          IF P_RETORNOPROCESSAMENTO IS NULL THEN
            P_RETORNOPROCESSAMENTO := 'Peso lotac?o n?o encontrado -> ' ||
                                      P_PLACA;
          ELSE
            P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                             CHR(10) ||
                                             ' Peso lotacão não encontrado -> ' ||
                                             P_PLACA,
                                             1,
                                             200);
          END IF;
          V_LOTACAO := NULL;
        END;
    END;
  
  end;
  
  /*******************************************************************/

  
  /*******************************************************************/
  /** VERIFICO O VALOR DO MAIOR FRETE DE ACORDO COM ORIGEM / DESTINO**/
  /*******************************************************************/
  
  begin
    
  
    FOR R_LOCALIDADE IN C_CARREGAMENTO LOOP
      BEGIN
        FOR R_CTRCLOC IN (SELECT DISTINCT CO.GLB_LOCALIDADE_CODIGOORIGEM,
                                          CO.GLB_LOCALIDADE_CODIGODESTINO,
                                          TV.FCF_TPVEICULO_CODIGO,
                                          NVL((SELECT 'EXPRESSA'
                                                FROM T_ARM_COLETA CO2
                                               WHERE CO2.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA
                                                 and co2.arm_coleta_ciclo = co.arm_coleta_ciclo
                                                 AND CO2.GLB_TPCARGA_CODIGO IN ('EC', 'ET', 'EB')),'NORMAL') COLETA
                            FROM T_CON_CONHECIMENTO CO,
                                 T_ARM_CARREGAMENTO CA,
                                 T_FCF_VEICULODISP  VD,
                                 T_FCF_TPVEICULO    TV
                           WHERE CO.ARM_CARREGAMENTO_CODIGO = R_LOCALIDADE.ARM_CARREGAMENTO_CODIGO
                             AND CA.ARM_CARREGAMENTO_CODIGO = CO.ARM_CARREGAMENTO_CODIGO
                             AND CA.FCF_VEICULODISP_CODIGO =  VD.FCF_VEICULODISP_CODIGO
                             AND CA.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
                             AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL) 
        LOOP
  /*        sp_busca_fretecarreteiro(R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM,
                                   R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO,
                                   V_TPCARGA,
                                   R_CTRCLOC.FCF_TPVEICULO_CODIGO,
                                   V_QTDENTREGAS,
                                   P_USUARIO,
                                   P_CUSTOCARRETEIRO,
                                   P_DESINENCIA,
                                   P_PEDAGIO,
                                   P_KM,
                                   P_TPRETORNO,
                                   P_MENSAGEM);*/
          P_CUSTOCARRETEIRO:= 0;               
          P_DESINENCIA     := 'V';
          P_PEDAGIO        := 0;
          P_KM             := 0;
          P_TPRETORNO      := 'N';
          P_MENSAGEM       := 'N';         
      
          V_KM := NULL;
          IF (P_KM IS NULL) OR (P_KM = 0) THEN
            BEGIN
              SELECT PE.SLF_PERCURSO_KM
                INTO V_KM
                FROM T_SLF_PERCURSO PE
               WHERE PE.GLB_LOCALIDADE_CODIGOORIGEM  = R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM
                 AND PE.GLB_LOCALIDADE_CODIGODESTINO = R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO;
              if ( R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM = R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO ) and 
                 ( nvl(V_KM,0) = 0 ) Then
                 v_km := 20;
              End If;   
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                V_KM := 0;
              if ( R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM = R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO ) and 
                 ( nvl(V_KM,0) = 0 ) Then
                 v_km := 20;
              End If;   

            END;
          END IF;
          IF V_KM IS NOT NULL THEN
            begin
                UPDATE T_FCF_FRETECAR FC
                   SET FC.FCF_FRETECAR_KM = V_KM
                 WHERE FC.FCF_FRETECAR_ORIGEM = R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM
                   AND FC.FCF_FRETECAR_DESTINO = R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO;
                P_KM := V_KM;
            exception when others then
                raise_application_error( -20001, 'V_KM: ' || V_KM || 'origem: ' || R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM || 'destino: ' || R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO);         
            end;
          END IF;
          BEGIN
            IF R_CTRCLOC.COLETA = 'EXPRESSA' THEN
              V_COLETA := 'EXPRESSA';
            END IF;
            IF V_KMFINAL IS NULL THEN
              BEGIN
                V_REMETENTE       := R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM;
                V_DESTINATARIO    := R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO;
                V_KMFINAL         := P_KM;
                V_CUSTOCARRETEIRO := P_CUSTOCARRETEIRO;
              END;
            ELSE
              IF P_KM > V_KMFINAL THEN
                BEGIN
                  V_REMETENTE       := R_CTRCLOC.GLB_LOCALIDADE_CODIGOORIGEM;
                  V_DESTINATARIO    := R_CTRCLOC.GLB_LOCALIDADE_CODIGODESTINO;
                  V_KMFINAL         := P_KM;
                  V_CUSTOCARRETEIRO := P_CUSTOCARRETEIRO;
                END;
              END IF;
            END IF;
          END;
        END LOOP;
      END;
    END LOOP;
      
  end;
  
  
  
  /*******************************************************************/
  
  
  /*******************************************************************/
  /** MONTO O PRAZO DE ENTREGA                                      **/
  /*******************************************************************/
  
  begin
    
    FOR R_KM IN C_LOCALIDADES LOOP
      
      BEGIN
        --Pego os dados da localidade.
        V_PROXIMOORIGEM := R_KM.DESTINO;
        
        IF R_KM.ORDEM = '1' THEN
          sp_busca_fretecarreteiro(R_KM.ORIGEM,
                                   R_KM.DESTINO,
                                   V_TPCARGA,
                                   V_TPVEICULO,
                                   V_QTDENTREGAS,
                                   P_USUARIO,
                                   P_CUSTOCARRETEIRO,
                                   P_DESINENCIA,
                                   P_PEDAGIO,
                                   P_KM,
                                   P_TPRETORNO,
                                   P_MENSAGEM);
        ELSE
          sp_busca_fretecarreteiro(V_PROXIMOORIGEM,
                                   R_KM.DESTINO,
                                   V_TPCARGA,
                                   V_TPVEICULO,
                                   V_QTDENTREGAS,
                                   P_USUARIO,
                                   P_CUSTOCARRETEIRO,
                                   P_DESINENCIA,
                                   P_PEDAGIO,
                                   P_KM,
                                   P_TPRETORNO,
                                   P_MENSAGEM);
                                   
        
/*        IF P_KM IS NULL THEN
           --RAISE_APPLICATION_ERROR(-20001,'1 '||V_PROXIMOORIGEM||' 2 '||R_KM.DESTINO);
           
           RAISE_APPLICATION_ERROR(-20001,'V_PROXIMOORIGEM: '||V_PROXIMOORIGEM||
           'R_KM.DESTINO: '||R_KM.DESTINO||
           'V_TPCARGA: '||V_TPCARGA||
           'V_TPVEICULO: '||V_TPVEICULO||
           'V_QTDENTREGAS: '||V_QTDENTREGAS||
           'P_USUARIO: '||P_USUARIO);
           
           
               
        END IF;
                 */              
                                   
        END IF;
      
        IF (P_KM IS NULL) or (P_KM = 0) THEN
          
          IF R_KM.ORDEM = 1 THEN
            
            BEGIN
              SELECT PE.SLF_PERCURSO_KM
                INTO V_KM
                FROM T_SLF_PERCURSO PE
               WHERE PE.GLB_LOCALIDADE_CODIGOORIGEM = R_KM.ORIGEM
                 AND PE.GLB_LOCALIDADE_CODIGODESTINO = R_KM.DESTINO;
              if ( R_KM.ORIGEM = R_KM.DESTINO ) and 
                 ( nvl(V_KM,0) = 0 ) Then
                 v_km := 20;
              End If;   
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                IF R_KM.ORIGEM = R_KM.DESTINO THEN
                  V_KM := '20';
                ELSE
                  V_KM := 0;
--                  IF V_ERRO_PROCESSAMENTO IS NULL THEN
                    V_ERRO_PROCESSAMENTO := 'E';
--                  END IF;
                
                  IF P_RETORNOPROCESSAMENTO IS NULL THEN
                    P_RETORNOPROCESSAMENTO := 'KM1 não encontrado -> Origem: ' ||
                                              R_KM.ORIGEM || ' Destino: ' ||
                                              R_KM.DESTINO || '-' || v_km;
                  ELSE
                    P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                                     CHR(10) ||
                                                     ' KM0 n?o encontrado -> Origem: ' ||
                                                     R_KM.ORIGEM ||
                                                     ' Destino: ' ||
                                                     R_KM.DESTINO || '-' || v_km,
                                                     1,
                                                     200);
                  END IF;
                END IF;
            END;
          
            IF V_KM IS NOT NULL THEN
              UPDATE T_FCF_FRETECAR FC
                 SET FC.FCF_FRETECAR_KM = V_KM
               WHERE FC.FCF_FRETECAR_ORIGEM = R_KM.ORIGEM
                 AND FC.FCF_FRETECAR_DESTINO = R_KM.DESTINO;
            END IF;
          
          ELSE
            
            BEGIN
              SELECT PE.SLF_PERCURSO_KM
                INTO V_KM
                FROM T_SLF_PERCURSO PE
               WHERE PE.GLB_LOCALIDADE_CODIGOORIGEM = V_PROXIMOORIGEM
                 AND PE.GLB_LOCALIDADE_CODIGODESTINO = R_KM.DESTINO;
              if ( V_PROXIMOORIGEM = R_KM.DESTINO ) and 
                 ( nvl(V_KM,0) = 0 ) Then
                 v_km := 20;
              End If;   

              UPDATE T_FCF_FRETECAR FC
                 SET FC.FCF_FRETECAR_KM = V_KM
               WHERE FC.FCF_FRETECAR_ORIGEM = V_PROXIMOORIGEM
                 AND FC.FCF_FRETECAR_DESTINO = R_KM.DESTINO;
              if ( V_PROXIMOORIGEM = R_KM.DESTINO ) and 
                 ( nvl(V_KM,0) = 0 ) Then
                 v_km := 20;
              End If;   

            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                
                    
              
                IF V_PROXIMOORIGEM = R_KM.DESTINO THEN
                
                  V_KM := '20';
                
                ELSE
                  
                  V_KM := NULL;
                  
--                  IF V_ERRO_PROCESSAMENTO IS NULL THEN
                    V_ERRO_PROCESSAMENTO := 'E';
--                  END IF;
                  
                  IF P_RETORNOPROCESSAMENTO IS NULL THEN
                    
                    P_RETORNOPROCESSAMENTO := ' KM2 não encontrado -> Origem: ' ||
                                              V_PROXIMOORIGEM ||
                                              ' Destino: ' || R_KM.DESTINO || '-' || v_km;
                  
                  ELSE
                  
                    P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                                     CHR(10) ||
                                                     ' KM3 não encontrado -> Origem: ' ||
                                                     V_PROXIMOORIGEM ||
                                                     ' Destino: ' ||
                                                     R_KM.DESTINO || '-' || v_km,
                                                     1,
                                                     200);
                  END IF;
                
                
                END IF;
                
            END;
          
          END IF;
          
        ELSE
          
          V_KM := P_KM;
          
        END IF;
        
        IF (V_KM IS NOT NULL) AND (V_KM <> 0) THEN
          
          IF TRIM(V_COLETA) = 'EXPRESSA' THEN
            
            BEGIN
              
              IF R_KM.ORDEM = '1' THEN
                
                BEGIN
                  
                  IF V_KM <= 300 THEN
                    V_PRAZODEENTREGA := SYSDATE + (6 / 24);
                  ELSE
                    V_PRAZODEENTREGA := SYSDATE + (V_KM / 950);
                  END IF;
                  
                  IF V_PRAZODEENTREGA IS NOT NULL THEN
                    BEGIN
                      V_PRAZODEENTREGA2 := V_PRAZODEENTREGA;
                      UPDATE T_FCF_VEICULODISPDEST VDE
                         SET VDE.FCF_VEICULODISPDEST_DTENTREGA = V_PRAZODEENTREGA
                       WHERE VDE.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
                         AND VDE.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
                         AND VDE.FCF_VEICULODISPDEST_ORDEM = R_KM.ORDEM;
                    END;
                  END IF;
                
                END;
              
              ELSE
                
                BEGIN
                  
                  IF V_KM <= 300 THEN
                    V_PRAZODEENTREGA := V_PRAZODEENTREGA + (6 / 24);
                  ELSE
                    V_PRAZODEENTREGA := V_PRAZODEENTREGA + (V_KM / 950);
                  END IF;
                  
                  IF V_PRAZODEENTREGA IS NOT NULL THEN
                    BEGIN
                      V_PRAZODEENTREGA2 := V_PRAZODEENTREGA;
                      UPDATE T_FCF_VEICULODISPDEST VDE
                         SET VDE.FCF_VEICULODISPDEST_DTENTREGA = V_PRAZODEENTREGA
                       WHERE VDE.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
                         AND VDE.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
                         AND VDE.FCF_VEICULODISPDEST_ORDEM = R_KM.ORDEM;
                    END;
                  END IF;
                
                END;
              
              END IF;
            
            END;
          
          ELSE
            
            BEGIN
              
              IF R_KM.ORDEM = '1' THEN
                
                BEGIN
                  
                  IF V_KM <= 300 THEN
                    V_PRAZODEENTREGA := SYSDATE + (6 / 24);
                  ELSE
                    V_PRAZODEENTREGA := SYSDATE + (V_KM / 650);
                  END IF;
                  
                  IF V_PRAZODEENTREGA IS NOT NULL THEN
                    BEGIN
                      V_PRAZODEENTREGA2 := V_PRAZODEENTREGA;
                      UPDATE T_FCF_VEICULODISPDEST VDE
                         SET VDE.FCF_VEICULODISPDEST_DTENTREGA = V_PRAZODEENTREGA
                       WHERE VDE.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
                         AND VDE.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
                         AND VDE.FCF_VEICULODISPDEST_ORDEM = R_KM.ORDEM;
                    END;
                  END IF;
                
                END;
              
              ELSE
                
                BEGIN
                  
                  IF V_KM <= 300 THEN
                    V_PRAZODEENTREGA := V_PRAZODEENTREGA2 + (6 / 24);
                  ELSE
                    V_PRAZODEENTREGA := V_PRAZODEENTREGA + (V_KM / 650);
                  END IF;
                
                  IF V_PRAZODEENTREGA IS NOT NULL THEN
                    BEGIN
                      V_PRAZODEENTREGA2 := V_PRAZODEENTREGA;
                      UPDATE T_FCF_VEICULODISPDEST VDE
                         SET VDE.FCF_VEICULODISPDEST_DTENTREGA = V_PRAZODEENTREGA
                       WHERE VDE.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
                         AND VDE.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
                         AND VDE.FCF_VEICULODISPDEST_ORDEM = R_KM.ORDEM;
                    END;
                  END IF;
                
                END;
                
              END IF;
            
            END;
          
          END IF;
        
        ELSE
          
--          IF V_ERRO_PROCESSAMENTO IS NULL THEN
            V_ERRO_PROCESSAMENTO := 'E';
--          END IF;
        
          IF P_RETORNOPROCESSAMENTO IS NULL THEN
             P_RETORNOPROCESSAMENTO := ' KM4 não encontrado -> Origem: ' ||
                                       R_KM.ORIGEM || ' Destino: ' ||
                                       R_KM.DESTINO || '- KM: ' || v_km || '- PROXORIGEM: ' || V_PROXIMOORIGEM || '- ORDEM: ' || R_KM.ORDEM;
          ELSE
            P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                             CHR(10) ||
                                             ' KM5 não encontrado -> Origem: ' ||
                                             R_KM.ORIGEM || ' Destino: ' ||
                                             R_KM.DESTINO || '-' || v_km,
                                             1,
                                             200);
          END IF;
          
        END IF;
        
      END;
      
      V_MAIORORIGEM := R_KM.ORIGEM;
      
      V_MAIORDEST   := R_KM.DESTINO;
    
    END LOOP;
  
    BEGIN
        SELECT distinct  
             ED.GLB_CLIEND_CIDADE       CIDDEST,
             CD.GLB_CLIENTE_RAZAOSOCIAL RAZDEST
        INTO V_CIDDEST,
             V_RAZAODEST
        FROM T_CON_CONHECIMENTO CO,
             T_ARM_CARREGAMENTO CA,
             T_FCF_VEICULODISP  VD,
             T_FCF_FRETECAR     FC,
             T_GLB_CLIEND       ER,
             T_GLB_CLIENTE      CR,
             T_GLB_CLIEND       ED,
             T_GLB_CLIENTE      CD
       WHERE VD.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
         AND VD.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
--         AND ER.GLB_LOCALIDADE_CODIGO = V_MAIORORIGEM
         AND ED.GLB_LOCALIDADE_CODIGO = V_MAIORDEST
         AND CO.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO
         AND CA.FCF_VEICULODISP_CODIGO = VD.FCF_VEICULODISP_CODIGO
         AND CA.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
         AND CO.CON_CONHECIMENTO_LOCALCOLETA = FC.FCF_FRETECAR_ORIGEM(+)
         AND CO.CON_CONHECIMENTO_LOCALENTREGA = FC.FCF_FRETECAR_DESTINO(+)
         AND CO.GLB_CLIENTE_CGCCPFREMETENTE = CR.GLB_CLIENTE_CGCCPFCODIGO
         AND CO.GLB_CLIENTE_CGCCPFREMETENTE = ER.GLB_CLIENTE_CGCCPFCODIGO
         AND CO.GLB_TPCLIEND_CODIGOREMETENTE = ER.GLB_TPCLIEND_CODIGO
         AND CO.GLB_CLIENTE_CGCCPFDESTINATARIO = CD.GLB_CLIENTE_CGCCPFCODIGO
         AND CO.GLB_CLIENTE_CGCCPFDESTINATARIO = ED.GLB_CLIENTE_CGCCPFCODIGO
         AND CO.GLB_TPCLIEND_CODIGODESTINATARI = ED.GLB_TPCLIEND_CODIGO
         AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
         and rownum = 1
       GROUP BY 
             ED.GLB_CLIEND_CIDADE,
             CD.GLB_CLIENTE_RAZAOSOCIAL;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
    BEGIN
      
          IF V_CIDDEST IS NULL THEN
            BEGIN
              IF P_RETORNOPROCESSAMENTO IS NULL THEN
                 P_RETORNOPROCESSAMENTO := 'Cidade Destinatario ' || V_CIDDEST || ' não encontrado. Verifique na Mesa de Contratac?o';
             ELSE
                P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                                 CHR(10) ||
                                                 'Cidade Destinatario ' || V_CIDDEST || ' não encontrado.',
                                                 1,
                                                 200);
              END IF;
            END;
          END IF;
 
          IF V_RAZAOREM IS NULL THEN
            BEGIN
              IF P_RETORNOPROCESSAMENTO IS NULL THEN
                P_RETORNOPROCESSAMENTO := 'Razão Social do Remetente ' || V_RAZAOREM  || ' não encotrado.';
              ELSE
                P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                                 CHR(10) ||
                                                 'Razão Social do Remetente ' || V_RAZAOREM  || ' não encotrado.',
                                                 1,
                                                 200);
              END IF;
              V_RAZAOREM := '';
            END;
          END IF;

          IF V_CIDDEST IS NULL THEN
            BEGIN
              IF P_RETORNOPROCESSAMENTO IS NULL THEN
                P_RETORNOPROCESSAMENTO := 'Cidade do Destinatario ' || V_CIDDEST  || ' não localizado.';
              ELSE
                P_RETORNOPROCESSAMENTO := substr(P_RETORNOPROCESSAMENTO ||
                                                 CHR(10) ||
                                                 'Cidade do Destinatario ' || V_CIDDEST  || ' não localizado.',
                                                 1,
                                                 200);
              END IF;
            END;
          END IF;

          IF V_RAZAODEST IS NULL THEN
            BEGIN
              IF P_RETORNOPROCESSAMENTO IS NULL THEN
                P_RETORNOPROCESSAMENTO := 'Razão Social do Destinatario ' || V_RAZAODEST || ' não encontrado.';
              ELSE
                P_RETORNOPROCESSAMENTO := substr(to_char(P_RETORNOPROCESSAMENTO ||
                                                         CHR(10) ||
                                                         'Razão Social do Destinatario ' || V_RAZAODEST || ' não encontrado.'),
                                                 1,
                                                 200);
              END IF;
            END;
          END IF;

    END;
    
    END;
    
  end;
  
  /*******************************************************************/

  /*******************************************************************/
  /** VERIFICAR PORQUE NAO PEGA O PARAMETRO                         **/
  /*******************************************************************/
  
  begin
    
    IF NVL(V_ROTATRAVADA,'N') = 'S' THEN
      
      BEGIN
        If vProcessoSV = 'N' and vProcessoMS = 'N' Then
          
           select *
             into tpFreteMemo
           from tdvadm.t_fcf_fretecarmemo m
           where m.fcf_veiculodisp_codigo = P_FCF_VEICULOCOD
             and m.fcf_veiculodisp_sequencia = P_FCF_VEICSEQ;
             
        Else
           IF P_TPMOTORISTA <> 'F' THEN
           
          SELECT nvl(VD.FCF_VEICULODISP_VALORFRETE,0),
                 VD.FCF_VEICULODISP_TPFRETE,
                 nvl(VD.FCF_VEICULODISP_DESCONTO,0),
                 VD.FCF_VEICULODISP_TPDESCONTO,
                 nvl(vd.fcf_veiculodisp_desinencia,'U'),
                 nvl(VD.FCF_VEICULODISP_QTDEENTREGAS,0),
                 nvl(VD.FCF_VEICULODISP_ACRESCIMO,0),
                 VD.FCF_VEICULODISP_OBSACRESCIMO,
                 vd.fcf_veiculodisp_pedagio,
                 vd.fcf_veiculodisp_pednofrete,
                 VD.FCF_VEICULODISP_OBSVALEFRETE,
                 nvl(VD.FCF_VEICULODISP_QTDECOLETAS,0),
                 nvl(VD.FCF_VEICULODISP_KMCOLETAS,0),
                 nvl(VD.FCF_VEICULODISP_VALOREXCECAO,0),
                 nvl(vd.fcf_veiculodisp_particularidade,0),
                 vd.fcf_fretecar_rowid ,
                 vd.fcf_veiculodisp_pednofrete
             INTO V_FRETEFECHADO,
                  V_TPFRETE,
                  V_DESCONTOFECHADO,
                  V_TPDESCONTO,
                  V_DESINENCIA,
                  V_ENTREGAS,
                  V_ACRESCIMO,
                  V_OBSACRESCIMO,
                  V_PEDAGIO,
                  V_PEDNOFRETE,
                  V_OBSVEICDISP,
                  V_QTDECOLETAS,
                  V_KMCOLETA,
                  V_FRETEEXCECAO,
                  v_PARTICULARIDADE,
                  v_freteRowId ,
                  vPednoFrete
          FROM tdvadm.T_FCF_VEICULODISP VD
          WHERE VD.CAR_VEICULO_PLACA = P_PLACA
  --          AND VD.ARM_CARREGAMENTO_CODIGO IS Not Null 
            AND VD.FCF_VEICULODISP_FLAGVALEFRETE IS NULL 
            AND VD.FCF_OCORRENCIA_CODIGO IS NULL 
            AND VD.CON_FRETEOPER_ID IS NOT NULL 
            AND VD.FCF_VEICULODISP_VALORFRETE <> 0 
            AND TRUNC(VD.FCF_VEICULODISP_DATA) >= TRUNC(SYSDATE - v_diasfretemesa) 
            AND TRUNC(VD.FCF_VEICULODISP_DATA) <= TRUNC(SYSDATE) 
            AND VD.FCF_VEICULODISP_DATA = (SELECT MAX(D1.FCF_VEICULODISP_DATA) 
                                           FROM T_FCF_VEICULODISP D1 
                                        WHERE D1.CAR_VEICULO_PLACA = VD.CAR_VEICULO_PLACA 
    --                                      AND D1.ARM_CARREGAMENTO_CODIGO IS Not NULL 
                                             AND D1.FCF_VEICULODISP_FLAGVALEFRETE IS NULL 
                                             AND D1.FCF_OCORRENCIA_CODIGO IS NULL 
                                             AND D1.CON_FRETEOPER_ID IS NOT NULL 
                                             AND TRUNC(D1.FCF_VEICULODISP_DATA) <= TRUNC(SYSDATE) 
                                             AND D1.FCF_VEICULODISP_VALORFRETE <> 0) ;

        ELSE
          
          SELECT nvl(VD.FCF_VEICULODISP_VALORFRETE,0),
                 VD.FCF_VEICULODISP_TPFRETE,
                 nvl(VD.FCF_VEICULODISP_DESCONTO,0),
                 VD.FCF_VEICULODISP_TPDESCONTO,
                 nvl(vd.fcf_veiculodisp_desinencia,'U'),
                 nvl(VD.FCF_VEICULODISP_QTDEENTREGAS,0),
                 nvl(VD.FCF_VEICULODISP_ACRESCIMO,0),
                 VD.FCF_VEICULODISP_OBSACRESCIMO,
                 vd.fcf_veiculodisp_pedagio,
                 vd.fcf_veiculodisp_pednofrete,
                 VD.FCF_VEICULODISP_OBSVALEFRETE,
                 nvl(VD.FCF_VEICULODISP_QTDECOLETAS,0),
                 nvl(VD.FCF_VEICULODISP_KMCOLETAS,0),
                 nvl(VD.FCF_VEICULODISP_VALOREXCECAO,0),
                 nvl(vd.fcf_veiculodisp_particularidade,0),
                 vd.fcf_fretecar_rowid ,
                 vd.fcf_veiculodisp_pednofrete
            INTO V_FRETEFECHADO,
                 V_TPFRETE,
                 V_DESCONTOFECHADO,
                 V_TPDESCONTO,
                 V_DESINENCIA,
                 V_ENTREGAS,
                 V_ACRESCIMO,
                 V_OBSACRESCIMO,
                 V_PEDAGIO,
                 V_PEDNOFRETE,
                 V_OBSVEICDISP,
                 V_QTDECOLETAS,
                 V_KMCOLETA,
                 V_FRETEEXCECAO,
                 v_PARTICULARIDADE,
                 v_freteRowId,
                 vPednoFrete
           FROM TDVADM.T_FCF_VEICULODISP VD
           WHERE VD.FRT_CONJVEICULO_CODIGO = P_PLACA
  --          AND VD.ARM_CARREGAMENTO_CODIGO IS Not Null 
            AND VD.FCF_VEICULODISP_FLAGVALEFRETE IS NULL 
            AND VD.FCF_OCORRENCIA_CODIGO IS NULL 
            AND VD.CON_FRETEOPER_ID IS NOT NULL 
            AND VD.FCF_VEICULODISP_VALORFRETE <> 0 
            AND TRUNC(VD.FCF_VEICULODISP_DATA) >= TRUNC(SYSDATE - v_diasfretemesa) 
            AND TRUNC(VD.FCF_VEICULODISP_DATA) <= TRUNC(SYSDATE) 
            AND VD.FCF_VEICULODISP_DATA = (SELECT MAX(D1.FCF_VEICULODISP_DATA) 
                                           FROM T_FCF_VEICULODISP D1 
                                        WHERE D1.FRT_CONJVEICULO_CODIGO = VD.FRT_CONJVEICULO_CODIGO 
    --                                      AND D1.ARM_CARREGAMENTO_CODIGO IS Not NULL 
                                             AND D1.FCF_VEICULODISP_FLAGVALEFRETE IS NULL 
                                             AND D1.FCF_OCORRENCIA_CODIGO IS NULL 
                                             AND D1.CON_FRETEOPER_ID IS NOT NULL 
                                             AND TRUNC(D1.FCF_VEICULODISP_DATA) <= TRUNC(SYSDATE) 
                                             AND D1.FCF_VEICULODISP_VALORFRETE <> 0) ;
        
        END IF;
        End If;
        
      EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001,' Favor verificar Veiculo FRETE NÃO FOI VINCULADO NA MESA - ' || P_FCF_VEICULOCOD  || ' SEQ. - ' || P_FCF_VEICSEQ || '-' || V_ROTATRAVADA||' - '||P_PLACA||' - '||P_TPMOTORISTA || ' - ' || v_diasfretemesa);        V_FRETEFECHADO    := 0;
        V_FRETEEXCECAO    := 0;
        v_PARTICULARIDADE := 0;
        v_freteRowId      := Null;
        V_TPFRETE         := 'N';
        V_DESCONTOFECHADO := 0;
        V_TPDESCONTO      := NULL;
        V_DESINENCIA      := 'U';
        V_ENTREGAS        := 0;
        V_ACRESCIMO       := 0;
        V_PEDAGIO         := 0;
        V_PEDNOFRETE      := 'N';
        V_OBSACRESCIMO    := NULL;
        V_OBSVEICDISP     := NULL;
        V_QTDECOLETAS     := 0;
        V_KMCOLETA        := 0;
        vPednoFrete       := 'N';
      END;  
       
       IF V_FRETEFECHADO <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001,'Favor verificar Veiculo - ' || P_FCF_VEICULOCOD  || ' SEQ. - ' || P_FCF_VEICSEQ || '-' || V_ROTATRAVADA);
       END IF;
       
    ELSE
      
        V_FRETEFECHADO    := 0;
        V_FRETEEXCECAO    := 0;
        v_PARTICULARIDADE := 0;
        v_freteRowId      := Null;
        V_TPFRETE         := 'N';
        V_DESCONTOFECHADO := 0;
        V_TPDESCONTO      := NULL;
        V_DESINENCIA      := 'U';
        V_ENTREGAS        := 0;
        V_ACRESCIMO       := 0;
        V_PEDAGIO         := 0;
        V_PEDNOFRETE      := 'N';
        V_OBSACRESCIMO    := NULL;
        V_OBSVEICDISP     := NULL;
        V_QTDECOLETAS     := 0;
        V_KMCOLETA        := 0;
        
    END IF;
  
  end;
  
  /*******************************************************************/
  
  
  /*******************************************************************/
  /**   CALCULO O VALOR DO FRETE                                    **/
  /*******************************************************************/
  
  begin
    If vProcessoSV = 'N' and vProcessoMS = 'N' Then
      V_CUSTOCARRETEIRO := tpFreteMemo.Fcf_Fretecarmemo_Frete +
                           tpFreteMemo.Fcf_Fretecarmemo_Expresso +
                           tpFreteMemo.Fcf_Fretecarmemo_Acrescimo +
                           tpFreteMemo.Fcf_Fretecarmemo_Particularidade +
                           tpFreteMemo.Fcf_Fretecarmemo_Excecao;
      If tpFreteMemo.Fcf_Fretecarmemo_Pedagionofrete = 'N' Then
         V_CUSTOCARRETEIRO := V_CUSTOCARRETEIRO + tpFreteMemo.Fcf_Fretecarmemo_Pedagio;
      end If;


    Else
       If V_TPFRETE = 'E' Then
          select p.usu_perfil_paran1
            into vPercentExpresso
          from tdvadm.t_usu_perfil p
          where p.usu_aplicacao_codigo = 'veicdisp'
            and p.usu_perfil_codigo = 'PER_EXPRESSO'
            and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                         from tdvadm.t_usu_perfil p1
                                         where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                           and p1.usu_perfil_codigo = p.usu_perfil_codigo);
          V_ACRESCIMO := V_ACRESCIMO * (1 + (vPercentExpresso/100));
       End If;   
  
       V_CUSTOCARRETEIRO := V_FRETEFECHADO + V_ACRESCIMO + V_FRETEEXCECAO;
  
    End If;
    
    BEGIN
      V_ADIANTAMENTO := (V_CUSTOCARRETEIRO * 0.7);
    END;

    IF  NVL(V_CUSTOCARRETEIRO,0) > 0 Then
          
        begin
    --select fn_retornavalorfretebonus(V_CUSTOCARRETEIRO, 15, 'B')
        select fn_retornavalorfretebonus(V_CUSTOCARRETEIRO,  V_PERC_BONUS, 'B')
          into V_bonus
          from dual;
        exception
          when no_data_found then
            v_bonus := '0';
          when OTHERS Then
             RAISE_APPLICATION_ERROR(-20001,'ERRO RODANDO FUNCAO select fn_retornavalorfretebonus(' || TO_CHAR(V_CUSTOCARRETEIRO) || ',TO_NUMBER(' ||  V_PERC_BONUS || '),B)');
        end;
  --      V_CUSTOCARRETEIRO := V_CUSTOCARRETEIRO - v_bonus;
    Else    
        V_CUSTOCARRETEIRO := 0;
        V_BONUS := 0;
    End if;
    

    V_OBRIGACOES := TRIM(P_OBRIGACOES);
    
    IF LENGTH(TRIM(V_OBRIGACOES)) > 0 THEN
       V_OBRIGACOES := V_OBRIGACOES || ' ';
    END IF; 
  
  end;  
  
  /*******************************************************************/

  
  
  /*******************************************************************/
  /**   FACO INSERT DOS CTRC'S NA T_CON_VALEFRETE                   **/
  /*******************************************************************/
  
  
    
    Begin
     select sv.origemLOSO,
            sv.destinoLOSO
        into vOrigemSOl,
             vDestinoSOl
  from tdvadm.v_fcf_solveic sv
  where 0 = 0
--    AND sv.FCF_SOLVEIC_COD = ca.fcf_solveic_cod
    AND sv.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
    AND sv.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ;
    V_REMETENTE := vOrigemSOl;
    V_DESTINATARIO := vDestinoSOl;
  Exception
    When OTHERS Then
       V_REMETENTE    := V_REMETENTE;
       V_DESTINATARIO := V_DESTINATARIO;
  End;


  
  
  
  begin
    
    IF (V_IMAGEMNOTAVF = '0') AND (V_IMAGEMCTRCVF = '0') AND
       (nvl(V_ERRO_PROCESSAMENTO, 'N') <> 'E') THEN
      BEGIN
        IF nvl(V_ROTATRAVADA,'S') = 'S' THEN
           V_QTDENTREGAS     := V_ENTREGAS;
--           V_CUSTOCARRETEIRO := V_FRETEFECHADO +  V_ACRESCIMO;
           V_OBRIGACOES := SUBSTR(V_OBRIGACOES || TRIM(V_OBSACRESCIMO),1,70);
           IF V_DESINENCIA = 'U' THEN
              P_DESINENCIA := 'U';
           ELSE
              P_DESINENCIA := 'T';
           END IF;     
        END IF;    
      

      tpValeFrete.CON_CONHECIMENTO_CODIGO       := V_MAXCTRC;
      tpValeFrete.CON_CONHECIMENTO_SERIE        := V_CTRCSERIE;
      tpValeFrete.CON_VIAGEM_NUMERO             := V_VIAGEMNUMERO;
      tpValeFrete.GLB_ROTA_CODIGO               := V_ROTA;
      tpValeFrete.GLB_ROTA_CODIGOVIAGEM         := V_ROTA;
      tpValeFrete.CON_VALEFRETE_SAQUE           := V_SAQUE_VF;
      tpValeFrete.CON_VALEFRETE_CONHECIMENTOS   := substr(V_VFCTRC, 1, 60);
      tpValeFrete.CON_VALEFRETE_CARRETEIRO      := P_CPF;
      tpValeFrete.CON_VALEFRETE_NFS             := substr(V_VFNF, 1, 70);
      tpValeFrete.CON_VALEFRETE_PLACASAQUE      := P_PLACA_SAQUE; --P_SAQUE,
      tpValeFrete.CON_VALEFRETE_TIPOTRANSPORTE  := 'T';
      tpValeFrete.CON_VALEFRETE_PLACA           := P_PLACA;
      tpValeFrete.CON_VALEFRETE_LOCALCARREG     := SUBSTR(TRIM('DIVERSOS') || '/' || TRIM('DIVERSOS'), 1, 25);
      tpValeFrete.CON_VALEFRETE_LOCALDESCARGA   := SUBSTR(TRIM(V_CIDDEST) || '/' || TRIM(V_RAZAODEST), 1, 25);
      tpValeFrete.CON_VALEFRETE_KMPREVISTA      := TO_NUMBER(REPLACE(NVL(V_KMFINAL, 0), ',', '.'));
      tpValeFrete.CON_VALEFRETE_PESOINDICADO    := TO_NUMBER(REPLACE(NVL(V_PESOREALNEW / 200, 0), ',', '.'));
      tpValeFrete.CON_VALEFRETE_LOTACAO         := TO_NUMBER(REPLACE(NVL(V_PESOREALNEW / 200, 0), ',', '.'));
      tpValeFrete.CON_VALEFRETE_PESOCOBRADO     := TO_NUMBER(REPLACE(NVL(V_PESOREALNEW / 200, 0), ',', '.'));
      tpValeFrete.CON_VALEFRETE_ENTREGAS        := TO_NUMBER(REPLACE(NVL(V_QTDENTREGAS, 0), ',', '.'));
/*      If V_PEDNOFRETE = 'N' Then
         tpValeFrete.CON_VALEFRETE_CUSTOCARRETEIRO := TO_NUMBER(REPLACE(NVL(V_CUSTOCARRETEIRO + V_PEDAGIO, 0), ',', '.'));
      Else   
         tpValeFrete.CON_VALEFRETE_CUSTOCARRETEIRO := TO_NUMBER(REPLACE(NVL(V_CUSTOCARRETEIRO, 0), ',', '.'));
      End If;
*/
      tpValeFrete.CON_VALEFRETE_CUSTOCARRETEIRO := TO_NUMBER(REPLACE(NVL(V_CUSTOCARRETEIRO, 0), ',', '.'));
      tpValeFrete.CON_VALEFRETE_TIPOCUSTO       := p_DeSINENCIA;
      tpValeFrete.CON_VALEFRETE_DATACADASTRO    := SYSDATE;
      tpValeFrete.CON_VALEFRETE_EMISSOR         := SUBSTR(V_USUARIO, 1, 15);
      tpValeFrete.GLB_LOCALIDADE_CODIGODES      := TRIM(V_DESTINATARIO);
      tpValeFrete.GLB_LOCALIDADE_CODIGOORI      := TRIM(V_REMETENTE);
      tpValeFrete.CON_VALEFRETE_DATAEMISSAO     := trunc(SYSDATE);
      tpValeFrete.CON_CATVALEFRETE_CODIGO       := V_CATVALEFRETE;
      tpValeFrete.GLB_TPMOTORISTA_CODIGO        := P_TPMOTORISTA;
      tpValeFrete.USU_USUARIO_CODIGO            := P_USUARIO;
      tpValeFrete.CON_VALEFRETE_CONDESPECIAIS   := V_CONDESPECIAIS;--P_OBSERVACAO,
      tpValeFrete.CON_VALEFRETE_OBRIGACOES      := V_OBRIGACOES; -- P_OBRIGACOES,
      
/*      If V_PEDNOFRETE = 'N' Then
         tpValeFrete.CON_VALEFRETE_FRETE           := TO_NUMBER(REPLACE(NVL(V_CUSTOCARRETEIRO + V_PEDAGIO, 0), ',', '.')); 
      Else
         tpValeFrete.CON_VALEFRETE_FRETE           := TO_NUMBER(REPLACE(NVL(V_CUSTOCARRETEIRO, 0), ',', '.')); 
      End If;
*/
      tpValeFrete.CON_VALEFRETE_FRETE           := TO_NUMBER(REPLACE(NVL(V_CUSTOCARRETEIRO, 0), ',', '.')); 
      tpValeFrete.Con_Valefrete_Pedagio         := V_PEDAGIO;
      tpValeFrete.CON_VALEFRETE_OUTROS          := 0;
      tpValeFrete.CON_VALEFRETE_ENLONAMENTO     := 0;
      tpValeFrete.CON_VALEFRETE_ESTADIA         := 0;
      tpValeFrete.CON_VALEFRETE_MULTA           := V_DESCONTOFECHADO;
      tpValeFrete.CON_VALEFRETE_VALORESTIVA     := 0;
      tpValeFrete.CON_VALEFRETE_DATAPRAZOMAX    := NVL(V_PRAZODEENTREGA2, SYSDATE);
      tpValeFrete.CON_VALEFRETE_HORAPRAZOMAX    := SYSDATE;
      tpValeFrete.CON_VALEFRETE_ADIANTAMENTO    := NVL(V_ADIANTAMENTO, 0);
      tpValeFrete.CON_VALEFRETE_FIFO            := 'S';
      tpValeFrete.con_valefrete_percetdes       := v_PercetDesconto;
      tpValeFrete.fcf_fretecar_rowid            := v_freteRowId;
      tpValeFrete.fcf_veiculodisp_codigo        := P_FCF_VEICULOCOD;
      tpValeFrete.fcf_veiculodisp_sequencia     := P_FCF_VEICSEQ; 
      If substr(tpValeFrete.Con_Valefrete_Placa,1,3) <> '000' then
         select p.car_proprietario_optsimples
           into tpValeFrete.Con_Valefrete_Optsimples
         from tdvadm.t_car_proprietario p,
              tdvadm.t_car_veiculo v
         where p.car_proprietario_cgccpfcodigo = v.car_proprietario_cgccpfcodigo
           and v.car_veiculo_placa = tpValeFrete.Con_Valefrete_Placa
           and v.car_veiculo_saque = tpValeFrete.Con_Valefrete_Placasaque;
      Else
         tpValeFrete.Con_Valefrete_Optsimples := 'N';
      End If;
      insert into t_con_valefrete values tpValeFrete;
      V_ERRO_PROCESSAMENTO := 'N';
      EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN
         -- Caso ja exista o vale de frete
         -- Consulto se a VFRETECONHEC esta vazia 
         -- Apago o Vale de Frete e insiro novamente.
         select count(*)
            into vAuxiliar
         from t_con_vfreteconhec vfc
         where vfc.con_valefrete_codigo = V_MAXCTRC 
           and vfc.con_valefrete_serie = V_CTRCSERIE
           and vfc.glb_rota_codigovalefrete = V_ROTA
           and vfc.con_valefrete_saque = V_SAQUE_VF;
          If vAuxiliar = 0 Then
             delete t_con_valefrete vf
             where vf.con_conhecimento_codigo = V_MAXCTRC 
               and vf.con_conhecimento_serie = V_CTRCSERIE
               and vf.glb_rota_codigo = V_ROTA
               and vf.con_valefrete_saque = V_SAQUE_VF;
               commit;
             insert into t_con_valefrete values tpValeFrete;
          Else
              RAISE_APPLICATION_ERROR(-20001,
                                      'Vale de Frete ja existe ! -' || 
                                      ' NR = ' || V_MAXCTRC || 
                                      ' SR = ' || V_CTRCSERIE ||
                                      ' RT = ' || V_ROTA || 
                                      ' SQ = ' || V_SAQUE_VF  );
          End If; 
       WHEN others THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  'Verifique os dados do VF ! - ' ||
                                  ' NR = ' || V_MAXCTRC || 
                                  ' SR = ' || V_CTRCSERIE ||
                                  ' RT = ' || V_ROTA || 
                                  ' SQ = ' || V_SAQUE_VF || chr(10) ||
                                  ' erro : ' || sqlerrm  );
      END;
    END IF;
  
  end;
  
  /*******************************************************************/

  
  /*******************************************************************/
  /**   FACO INSERT DOS CTRC'S NA T_CON_VFRETECONHEC                **/
  /*******************************************************************/
  
  begin
    
    IF (V_IMAGEMNOTAVF = '0') AND (V_IMAGEMCTRCVF = '0') AND
       (nvl(V_ERRO_PROCESSAMENTO, 'N') <> 'E') THEN
      FOR R_CTRCVEIC IN C_CTRCVEIC LOOP
        VV_ROTA  := R_CTRCVEIC.GLB_ROTA_CODIGO;
        VV_CTRC  := R_CTRCVEIC.CON_CONHECIMENTO_CODIGO;
        VV_SERIE := R_CTRCVEIC.CON_CONHECIMENTO_SERIE;
        BEGIN
          V_DESTINOCTRC := null;
          BEGIN
            SELECT CO.GLB_LOCALIDADE_CODIGODESTINO
              INTO V_DESTINOCTRC
              FROM T_CON_CONHECIMENTO CO
             WHERE CO.CON_CONHECIMENTO_CODIGO = VV_CTRC
               AND CO.CON_CONHECIMENTO_SERIE = VV_SERIE
               AND CO.GLB_ROTA_CODIGO = VV_ROTA;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_DESTINOCTRC := NULL;
          END;
          V_DATAENTREGA := null;
          BEGIN
            SELECT DT.FCF_VEICULODISPDEST_DTENTREGA
              INTO V_DATAENTREGA
              FROM T_FCF_VEICULODISPDEST DT
             WHERE DT.GLB_LOCALIDADE_CODIGO = V_DESTINOCTRC
               AND DT.FCF_VEICULODISP_CODIGO = P_FCF_VEICULOCOD
               AND DT.FCF_VEICULODISP_SEQUENCIA = P_FCF_VEICSEQ
--               And dt.fcf_veiculodispdest_dtentrega Is Not Null
               AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_DATAENTREGA := '01/01/1900';
            WHEN OTHERS THEN
              V_DATAENTREGA := '01/01/1901';
          END;
          If V_DATAENTREGA Is Null Then
            V_DATAENTREGA := NVL(V_PRAZODEENTREGA2, SYSDATE);
          End If;

          Begin
              Select nc.arm_carregamento_codigo,
                     nc.arm_armazem_codigo,
                     n.arm_embalagem_numero,
                     n.arm_embalagem_flag,
                     n.arm_embalagem_sequencia
                 into vCarregamento,
                      vTemArmTransf,
                      vEmbNumero,
                      vEmbFlag,
                      vEmbSeq  
              from t_arm_notacte nc,
                   t_arm_nota n 
              where nc.arm_notacte_codigo = 'DE'
                and nc.con_conhecimento_codigo = vv_ctrc
                and nc.con_conhecimento_serie = vv_serie
                and nc.glb_rota_codigo = vv_rota
                and nc.arm_nota_numero = n.arm_nota_numero
                and nc.glb_cliente_cgccpfremetente = rpad(n.glb_cliente_cgccpfremetente,20)
                and nc.arm_nota_sequencia = n.arm_nota_sequencia;

          Exception
            When NO_DATA_FOUND Then
                vTemArmTransf := null;
            End ;
            
          if  trim(nvl(vTemArmTransf,'X')) <> 'X' Then
          
              select count(*)
                 into vAuxiliar
              from t_arm_armazem a
              where a.arm_armazem_codigo = vTemArmTransf;
              if vAuxiliar = 0 Then 
                delete tdvadm.t_con_vfreteconhec vfc
                where vfc.con_valefrete_codigo = V_MAXCTRC 
                  and vfc.con_valefrete_serie = V_CTRCSERIE
                  and vfc.glb_rota_codigovalefrete = V_ROTA
                  and vfc.con_valefrete_saque = V_SAQUE_VF;
                delete tdvadm.t_con_valefrete vf  
                where vf.con_conhecimento_codigo = V_MAXCTRC 
                  and vf.con_conhecimento_serie = V_CTRCSERIE
                  and vf.glb_rota_codigo = V_ROTA
                  and vf.con_valefrete_saque = V_SAQUE_VF;
                RAISE_APPLICATION_ERROR(-20001,'Codigo de Armazem Invalido '  || vTemArmTransf || '-' || vv_ctrc || '-' || vv_rota );
              end If;
                 
          
          
              update t_arm_carregamentodet det
                set det.arm_carregamentodet_flagtrans = 'S',
                    det.arm_armazem_codigo_transf = vTemArmTransf
              where det.arm_carregamento_codigo = vCarregamento
                and det.arm_embalagem_numero = vEmbNumero
                and det.arm_embalagem_flag = vEmbFlag
                and det.arm_embalagem_sequencia =  vEmbSeq;
                       
          
          End If;  

          
          INSERT INTO T_CON_VFRETECONHEC
            (CON_VALEFRETE_CODIGO,
             CON_VALEFRETE_SERIE,
             GLB_ROTA_CODIGOVALEFRETE,
             CON_VALEFRETE_SAQUE,
             GLB_ROTA_CODIGO,
             CON_CONHECIMENTO_CODIGO,
             CON_CONHECIMENTO_SERIE,
             CON_VFRETECONHEC_RECALCULA,
             SLF_TPCALCULO_CODIGO,
             CON_VFRETECONHEC_SALDO,
             CON_VFRETECONHEC_PEDAGIO,
             CON_VFRETECONHEC_RATEIORECEITA,
             CON_VFRETECONHEC_RATEIOFRETE,
             CON_VFRETECONHEC_RATEIOPEDAGIO,
             CON_VFRETECONHEC_DTENTREGA,
             con_vfreteconhec_dtgravacao,
             con_vfreteconhec_usumaq,
             con_vfreteconhec_transfchekin,
             arm_armazem_codigo   )
          VALUES
            (V_MAXCTRC,
             V_CTRCSERIE,
             V_ROTA,
             V_SAQUE_VF,
             vv_rota,
             vv_ctrc,
             vv_serie,
             'S',
             R_CTRCVEIC.SLF_TPCALCULO_CODIGO,
             NULL,
             NULL,
             0,
             0,
             0,
             V_DATAENTREGA,
             sysdate,
             trim(SYS_CONTEXT('USERENV','TERMINAL')),
             decode(nvl(vTemArmTransf,'00'),'00',pkg_con_valefrete.FN_Get_EmbTransferencia2(vv_ctrc,vv_serie,vv_rota,trunc(sysdate),'T'),'Sim'),
             decode(nvl(vTemArmTransf,'00'),'00',pkg_con_valefrete.FN_Get_EmbTransferencia2(vv_ctrc,vv_serie,vv_rota,trunc(sysdate),'A'),vTemArmTransf));

             update tdvadm.t_con_conhecvped cvp
               set cvp.con_conhecvped_valor = V_PEDAGIO,
                   cvp.con_conhecimento_valortdv = V_PEDAGIO
             where cvp.con_conhecimento_codigo = vv_ctrc
               and cvp.con_conhecimento_serie = vv_serie
               and cvp.glb_rota_codigo = vv_rota;


             
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            
            RAISE_APPLICATION_ERROR(-20001,
                                    'Ja existe um vale frete para esse conhecimento! ' ||
                                    V_MAXCTRC);
          When OTHERS THEN

             delete tdvadm.t_con_vfreteconhec vfc
             where vfc.con_valefrete_codigo = V_MAXCTRC 
               and vfc.con_valefrete_serie = V_CTRCSERIE
               and vfc.glb_rota_codigovalefrete = V_ROTA
               and vfc.con_valefrete_saque = V_SAQUE_VF;
             delete tdvadm.t_con_valefrete vf  
             where vf.con_conhecimento_codigo = V_MAXCTRC 
               and vf.con_conhecimento_serie = V_CTRCSERIE
               and vf.glb_rota_codigo = V_ROTA
               and vf.con_valefrete_saque = V_SAQUE_VF;
             commit;
            RAISE_APPLICATION_ERROR(-20001,sqlerrm||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            
        END;
      END LOOP;
    END IF;
  
  end;
  
  /*******************************************************************/
  
  /*******************************************************************/
  /**   PARTE FINAL DA PROCEDURE                                    **/
  /*******************************************************************/
  
  begin
    
    If V_TPFRETE = 'E' Then 

        SELECT COUNT(*) 
           INTO vAuxiliar
        FROM tdvadm.T_ARM_NOTA AN,
             T_CON_VFRETECONHEC VFC
        WHERE tdvadm.pkg_fifo_carregctrc.fn_EColetaExpressa(AN.Arm_Coleta_Ncompra,an.arm_coleta_ciclo) = 'S'
          AND AN.CON_CONHECIMENTO_CODIGO = VFC.CON_CONHECIMENTO_CODIGO
          AND AN.CON_CONHECIMENTO_SERIE  = VFC.CON_CONHECIMENTO_SERIE
          AND AN.GLB_ROTA_CODIGO         = VFC.GLB_ROTA_CODIGO
          AND VFC.CON_VALEFRETE_CODIGO     = V_MAXCTRC
          AND VFC.CON_VALEFRETE_SERIE      = V_CTRCSERIE
          AND VFC.GLB_ROTA_CODIGOVALEFRETE = V_ROTA
          AND VFC.CON_VALEFRETE_SAQUE      = V_SAQUE_VF;

        If vAuxiliar = 0 Then 
           V_ERRO_PROCESSAMENTO := 'E';
           P_RETORNOPROCESSAMENTO := substr(trim(P_RETORNOPROCESSAMENTO) || chr(10) || 'ERRO NA SOL. DO VEICULO - CTe´s SEM COLETA EXPRESSA',1,200);
        End if;

    End if;
    

    IF nvl(V_ERRO_PROCESSAMENTO, 'N') <> 'E' THEN
      
      P_RETORNOPROCESSAMENTO := 'VALE FRETE.: '||V_MAXCTRC||' - '||V_CTRCSERIE||' - '||V_ROTA||' - '||V_SAQUE_VF||' GERADO COM SUCESSO!';
      UPDATE T_FCF_VEICULODISP VD
         SET VD.FCF_VEICULODISP_FLAGVALEFRETE = 'S'
       WHERE VD.FCF_VEICULODISP_CODIGO        = P_FCF_VEICULOCOD
         AND VD.FCF_VEICULODISP_SEQUENCIA     = P_FCF_VEICSEQ;
         
      commit;
    else
      P_ERRO_PROCESSAMENTO := V_ERRO_PROCESSAMENTO;
      P_RETORNOPROCESSAMENTO := P_RETORNOPROCESSAMENTO || chr(10) || 'Problemas na criação do VALE DE FRETE.: '||chr(10) || 'erro: ' || sqlerrm;

      UPDATE T_FCF_VEICULODISP VD
         SET VD.FCF_VEICULODISP_FLAGVALEFRETE = null
       WHERE VD.FCF_VEICULODISP_CODIGO        = P_FCF_VEICULOCOD
         AND VD.FCF_VEICULODISP_SEQUENCIA     = P_FCF_VEICSEQ;
         
      delete tdvadm.t_con_vfreteentrega vft
      where 0 = 0
      AND VFT.CON_CONHECIMENTO_CODIGO = V_MAXCTRC
      AND VFT.CON_CONHECIMENTO_SERIE  = V_CTRCSERIE        
      AND VFT.GLB_ROTA_CODIGO         = V_ROTA        
      AND VFT.CON_VALEFRETE_SAQUE     = V_SAQUE_VF;

      delete tdvadm.t_con_vfreteconhec vfc
      where 0 = 0
        AND VFC.CON_VALEFRETE_CODIGO     = V_MAXCTRC
        AND VFC.CON_VALEFRETE_SERIE      = V_CTRCSERIE
        AND VFC.GLB_ROTA_CODIGOVALEFRETE = V_ROTA
        AND VFC.CON_VALEFRETE_SAQUE      = V_SAQUE_VF;

      delete tdvadm.t_con_valefrete vfc
      where 0 = 0
        AND VFC.CON_CONHECIMENTO_CODIGO = V_MAXCTRC
        AND VFC.CON_CONHECIMENTO_SERIE  = V_CTRCSERIE
        AND VFC.GLB_ROTA_CODIGO         = V_ROTA
        AND VFC.CON_VALEFRETE_SAQUE     = V_SAQUE_VF;
    
      commit;



    END IF;
    
  end;
  
  /*******************************************************************/
  
  COMMIT;
  
  exception
    When OTHERS Then
      
      UPDATE T_FCF_VEICULODISP VD
         SET VD.FCF_VEICULODISP_FLAGVALEFRETE = null
       WHERE VD.FCF_VEICULODISP_CODIGO        = P_FCF_VEICULOCOD
         AND VD.FCF_VEICULODISP_SEQUENCIA     = P_FCF_VEICSEQ;
         
      delete tdvadm.t_con_vfreteentrega vft
      where 0 = 0
      AND VFT.CON_CONHECIMENTO_CODIGO = V_MAXCTRC
      AND VFT.CON_CONHECIMENTO_SERIE  = V_CTRCSERIE        
      AND VFT.GLB_ROTA_CODIGO         = V_ROTA        
      AND VFT.CON_VALEFRETE_SAQUE     = V_SAQUE_VF;

      delete tdvadm.t_con_vfreteconhec vfc
      where 0 = 0
        AND VFC.CON_VALEFRETE_CODIGO     = V_MAXCTRC
        AND VFC.CON_VALEFRETE_SERIE      = V_CTRCSERIE
        AND VFC.GLB_ROTA_CODIGOVALEFRETE = V_ROTA
        AND VFC.CON_VALEFRETE_SAQUE      = V_SAQUE_VF;

      delete tdvadm.t_con_valefrete vfc
      where 0 = 0
        AND VFC.CON_CONHECIMENTO_CODIGO = V_MAXCTRC
        AND VFC.CON_CONHECIMENTO_SERIE  = V_CTRCSERIE
        AND VFC.GLB_ROTA_CODIGO         = V_ROTA
        AND VFC.CON_VALEFRETE_SAQUE     = V_SAQUE_VF;
    
      commit;
      P_RETORNOPROCESSAMENTO := 'Problemas na criação do VALE DE FRETE.: '||chr(10) || 'erro: ' || sqlerrm;
      P_ERRO_PROCESSAMENTO := 'E';

    End;

end sp_gera_valefrete;

 
/
