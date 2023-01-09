CREATE OR REPLACE PACKAGE PKG_CON_VALEFRETE IS
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

  TYPE T_CURSOR IS REF CURSOR;

  type TStrings is table of varchar2(4000);

  vPrazoVencTitulo    constant number  := 30;
  vInsereOpSaidaSaldo Constant char(1) := 'N';
  CatTUmaViagem       Constant CHAR(2) := '01';
  CatTVariasViagens   Constant CHAR(2) := '02';
  CatTTombo           Constant CHAR(2) := '03';
  CatTReforco         Constant CHAR(2) := '04';
  CatTComplemento     Constant CHAR(2) := '05';
  CatTTranspesa       Constant CHAR(2) := '06';
  CatTRemocao         Constant CHAR(2) := '07';
  CatTAvulsoSCTRC     Constant CHAR(2) := '08';
  CatTAvulsoCCTRC     Constant CHAR(2) := '09';
  CatTServicoTerceiro Constant CHAR(2) := '10';
  CatTManifesto       Constant CHAR(2) := '11';
  CatTAvulsoManifesto Constant CHAR(2) := '12';
  CatTBonusManifesto  Constant CHAR(2) := '13';
  CatTBonusCTRC       Constant CHAR(2) := '14';
  CatTCocaCola        Constant CHAR(2) := '15';
  CatTCTRCSPlaca      Constant CHAR(2) := '16';
  CatTEstadia         Constant CHAR(2) := '17';
  CatTColeta          Constant CHAR(2) := '18';
  CatTOpCCTRC         Constant CHAR(2) := '19';
  CatTOpSCTRC         Constant CHAR(2) := '20';

  vInsereOp2948       char(1) := 'N';
  vProcValidaValeFrete char(1) := 'N'; 

 
 Type TpValidaVF is RECORD (   
                             /* XML de Entrada */ 
                               vXmlTab                        Clob,
                            /* Paramentros de Entrada */  
                               VFNumero                       tdvadm.t_con_valefrete.con_conhecimento_codigo%Type,
                               VFSerie                        tdvadm.t_con_valefrete.con_conhecimento_serie%Type,
                               VFRota                         tdvadm.t_con_valefrete.glb_rota_codigo%Type,
                               VFSaque                        tdvadm.t_con_valefrete.con_valefrete_saque%Type,
                               VFAcao                         Varchar2(17),
                               VFusuarioTDV                   tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                               VFRotaUsuarioTDV               tdvadm.t_glb_rota.glb_rota_codigo%Type,
                               VFAplicacaoTDV                 tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type,
                               VFVersaoAplicao                tdvadm.t_usu_aplicacao.usu_aplicacao_versao%Type,
                               VFCON_VALEFRETE_PERCETDES      Varchar2(5),
                               VFCON_CATVALEFRETE_CODIGO      tdvadm.t_con_subcatvalefrete.con_catvalefrete_codigo%Type,
                               VFCON_SUBCATVALEFRETE_CODIGO   tdvadm.t_con_subcatvalefrete.con_subcatvalefrete_codigo%Type,
                               VFCON_VALEFRETE_PLACA          tdvadm.t_con_valefrete.con_valefrete_placa%Type,
                               VFCON_VALEFRETE_PLACASAQUE     tdvadm.t_con_valefrete.con_valefrete_placasaque%Type,
                               vfCARGO_MOTORISTA              char(5),
                               vfCON_VALEFRETE_CARRETEIRO     tdvadm.t_con_valefrete.con_valefrete_carreteiro%type,
                               vCON_VALEFRETE_CUSTOCARRETEIRO tdvadm.t_con_valefrete.con_valefrete_custocarreteiro%Type,
                               vCON_VALEFRETE_TIPOCUSTO       tdvadm.t_con_valefrete.CON_VALEFRETE_TIPOCUSTO%Type,
                               vFCF_FRETECAR_ROWID            tdvadm.t_con_valefrete.FCF_FRETECAR_ROWID%Type,
                               vFCF_VEICULODISP_CODIGO        tdvadm.t_con_valefrete.FCF_VEICULODISP_CODIGO%Type,
                               vFCF_VEICULODISP_SEQUENCIA     tdvadm.t_con_valefrete.FCF_VEICULODISP_SEQUENCIA%Type,
                               vFGLB_CLIENTE_CGCCPFCODIGO     TDVADM.T_CON_VALEFRETE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                             /* Variaveis de Entrada e Saida */
                               VFCON_VALEFRETE_MULTA          tdvadm.t_con_valefrete.con_valefrete_multa%Type,

                              /* Variaveis de Saida */
                               vStatusVF                      Char(1),
                               vPrimeiroSaque                 char(1),
                               vUltimoSaque                   Char(1),
                               vUltimoSaqueValido             char(1),
                               vSQAntPagoCx                   Char(1),
                               vSQAntPagoAc                   Char(1),
                               vSQAntPagoEl                   Char(1),
                               vFaltaComprovante              Char(1),
                               vZeraPedagio                   Char(1),
                               vCriadoPeloFIFO                Char(1),
                               vServTercPagador               tdvadm.t_glb_cliente.glb_cliente_razaosocial%type,
                               vLinkImgagem                   varchar2(100),
                             
                             /* Tipos da Tabela */
                               tpValeFrete                    tdvadm.t_con_valefrete%Rowtype,
                               tpValeFretemenor               tdvadm.t_con_valefrete%Rowtype,
                               tpValeFretemaior               tdvadm.t_con_valefrete%Rowtype,
                               tpValeFreteAnt                 tdvadm.t_con_valefrete%Rowtype,
                               tpSubCategoria                 tdvadm.t_con_subcatvalefrete%Rowtype,
                               tpContaCorrente                tdvadm.t_car_contacorrente%Rowtype, 


                             /* Variaveis de Uso */
                               
                               vFCF_VEICULODISP_ROTATRAVAS    char(1),
                               vFCF_VEICULODISP_ALTERAFRETE   char(1),
                               vFCF_SOLVEIC_CODIGO            tdvadm.t_fcf_solveic.fcf_solveic_cod%type,
                               vFCF_VEICULODISP_VALORFRETE    tdvadm.t_fcf_veiculodisp.FCF_VEICULODISP_VALORFRETE%Type,
                               vFCF_VEICULODISP_VALOREXCECAO  tdvadm.t_fcf_veiculodisp.FCF_VEICULODISP_VALOREXCECAO%Type,
                               vFCF_VEICULODISP_TPFRETE       tdvadm.t_fcf_veiculodisp.FCF_VEICULODISP_TPFRETE%Type,
                               vFCF_FRETECAR_VALOR            tdvadm.t_fcf_fretecar.FCF_FRETECAR_VALOR%Type,
                               vFCF_FRETECAR_DESINENCIA       tdvadm.t_fcf_fretecar.FCF_FRETECAR_DESINENCIA%Type,
                               vFCF_FRETECAR_ACRESCIMO        tdvadm.t_cad_frete.cad_frete_novovalor%type,
                               vFCF_FRETECAR_OBSERVACAO       tdvadm.t_cad_frete.cad_frete_observacao%type,
                               vFCF_FRETECAR_AUTORIZADO       tdvadm.t_cad_frete.cad_frete_status%type,
                               vFCF_CADFRETE_STATUS           tdvadm.t_cad_frete.cad_frete_status%type, 
                               vFCF_CADFRETE_ORIGEM           varchar2(60),
                               vFCF_CADFRETE_DESTINO          varchar2(60),
                               vFCF_CADFRETE_VEICULO          varchar2(60),
                               vFCF_CADFRETE_PESO             tdvadm.t_cad_frete.cad_frete_pesoestimado%type,
                               vFCF_CADFRETE_FRETE            tdvadm.t_cad_frete.cad_frete_jacadastrado%type,
                               vFCF_CADFRETE_NOVOVALOR        tdvadm.t_cad_frete.cad_frete_novovalor%type,
                               vFCF_CADFRETE_AJUDANTE         tdvadm.t_cad_frete.cad_frete_novovalor_ajudante%type,
                               vFCF_CADFRETE_APROVADOR        tdvadm.t_cad_frete.cad_frete_aprovado%type,
                               vFCF_CADFRETE_VALORAPROVADO    tdvadm.t_cad_frete.cad_frete_vlraprovado%type,
                               vCIOT                          tdvadm.t_con_vfreteciot.con_vfreteciot_numero%Type,
                               vSolCIOT                       Char(1),
                               vConvfersao                    tdvadm.t_usu_aplicacao.usu_aplicacao_versao%TYPE, 
                               vExisteSubCategoria            char,
                               v_LimiteDesconto               Number,
                               v_Valoradescontar              Number,
                               v_ValorRestante                Number,
                               v_Proprietario                 tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%Type,
                               v_TpProprietario               tdvadm.t_car_proprietario.car_proprietario_tipopessoa%type,
                               v_Coleta                       tdvadm.t_car_veiculo.car_veiculo_coleta%Type,
                               v_DtAutColeta                  tdvadm.t_car_veiculo.car_veiculo_coletaaut%Type,
                               v_DtVigColeta                  tdvadm.t_car_veiculo.car_veiculo_coletavigencia%Type,
                               vAuxiliar                      Number,
                               vAuxiliar2                     number,
                               vAuxiliarData                  date,
                               vAuxiliarTexto                 varchar2(1500),
                               vLiberaComprovanteFrota        char(1),
                               vValefreteNaoImp               char(1),
                               vValefreteNaoImpQtdeDias       number,
                               vContabilizado                 char(1),
                               
                              /* Atualiza Posicao do Veiculo */
                               v_gruposac                     T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE,
                               v_gruporem                     T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE,
                               v_grupodes                     T_GLB_GRUPOECONOMICO.GLB_GRUPOECONOMICO_CODIGO%TYPE,
                               v_cnpjcpfsac                   t_glb_cliente.glb_cliente_cgccpfcodigo%TYPE,
                               v_cnpjcpfrem                   t_glb_cliente.glb_cliente_cgccpfcodigo%TYPE,
                               v_cnpjcpfdes                   t_glb_cliente.glb_cliente_cgccpfcodigo%TYPE,
                               VCOR                           RMADM.T_GLB_BENASSEMSG.GLB_BENASSEMSG_CORCODIGO%TYPE,
                               VCORFONTE                      RMADM.T_GLB_BENASSEMSG.GLB_BENASSEMSG_CORCODIGOFONTE%TYPE,
                               VSTATUS                        RMADM.T_GLB_BENASSEMSG.GLB_BENASSEMSG_DESCCLI%Type,
                               vPodeImprimir                  t_con_vfreteciot.con_vfreteciot_flagimprime%type,
                               vRotaCaixa                     TDVADM.T_GLB_ROTA.GLB_ROTA_CAIXA%TYPE,
                               vImprimePCL                    tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type,
                               vMaquina                       tdvadm.v_glb_ambiente.terminal%type,
                               vDescBonus                     char(1),
                               vDescBonusFrota                char(1));


 
 /* Typo utilizado como base para utilização dos Paramentros                                                                 */
 Type TpMODELO  is RECORD (CAMPO1         char(10),
                           CAMPO2         number(6));

   Function Fn_RetornaTarifa(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                             pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                             pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                             pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type)
       return number;             

  Function fn_RetornaPrimeiroVF(pCte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                pSerie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                pRota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type)
          return varchar2;

  Function fn_RetornaUltimoVF(pCte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                              pSerie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                              pRota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type)
          return varchar2;


  Procedure SP_eSocialValida(pCPF in tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type,
                             pPrazo in integer default 90,
                             pStatus out Char,
                             pMessage out varchar2);

  Function F_STATUS_IMGESTADIA(pVFCategoria  in tdvadm.t_con_valefrete.con_catvalefrete_codigo%type,
                               pIMGArquivada in tdvadm.t_glb_vfimagem.glb_vfimagem_arquivado%type,
                               pUsuConf      in tdvadm.t_glb_vfimagem.usu_usuario_codigoconf%type)
      RETURN CHAR;


  Function FN_Get_CNPJLOCLIBIMAGEM(P_CGCCPFREMETENTE    IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                   P_CGCCPFDESTINATARIO IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,  
                                   P_CGCCPFSACADO       IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                   P_CODIGOORIGEM       IN TDVADM.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE,
                                   P_CODIGODESTINO      IN TDVADM.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE)
     RETURN CHAR;                                   



  Function F_BUSCA_TRANSFENTREARMAZEM(P_LOCALIDADE T_CON_VALEFRETE.CON_VALEFRETE_LOCALDESCARGA%TYPE)
      RETURN CHAR;


          
  Function fn_ValidaMesaFrete(P_QRYSTR   In clob,
                               P_STATUS   OUT CHAR,
                               P_MESSAGE  OUT VARCHAR2)
    RETURN BOOLEAN;
    
  Function Fn_RetornaOperacao(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                              pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                              pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                              pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type,
                              pCodParcelaPaga in t_con_calcvalefrete.con_calcvalefretetp_codigo%type,
                              pRotaCaixa      in t_glb_rota.glb_rota_codigo%type,
                              pTipo           in char) return char;
  
  Function Fn_VerificaProcessamento(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                                    pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                                    pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                                    pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type,
                                    pCodParcelaPaga in t_con_calcvalefrete.con_calcvalefretetp_codigo%type,
                                    pRotaCaixa      in t_glb_rota.glb_rota_codigo%type,
                                    pTipo           in char) return char;                            
    
  PROCEDURE SP_CON_INSERECONTACORRENTE(P_CON_VALEFRETE  IN T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                                       P_CON_SERIE      IN T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                                       P_CON_ROTA       IN T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                                       P_CON_SAQUE      IN T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                                       P_VALORACREDITO  IN NUMBER default 0,
                                       P_SISTEMA        IN T_USU_SISTEMA.USU_SISTEMA_CODIGO%TYPE,
                                       P_USUARIO        IN T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                       P_ACAO           IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                       P_STATUS         OUT CHAR,
                                       P_MESSAGE        OUT VARCHAR2);

  PROCEDURE SP_CON_CRIATITULO(P_CON_VALEFRETE IN T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                              P_CON_SERIE     IN T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                              P_CON_ROTA      IN T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                              P_CON_SAQUE     IN T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                              P_CNPJ          IN T_CON_VALEFRETE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                              P_USUARIO       IN T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                              P_ACAO          IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                              P_STATUS        OUT CHAR,
                              P_MESSAGE       OUT VARCHAR2);

  PROCEDURE SP_CON_ATUCALCVALEFRETE(P_QUERYSTR      IN OUT  Varchar2,
                                    P_STATUS        OUT CHAR,
                                    P_MESSAGE       OUT VARCHAR2,
                                    P_CURSOR        OUT PKG_GLB_COMMON.T_CURSOR);
 
  PROCEDURE SP_CON_ATUCALCVALEFRETEGER(P_QUERYSTR      IN OUT  Varchar2,
                                       P_STATUS        OUT CHAR,
                                       P_MESSAGE       OUT VARCHAR2,
                                       P_CURSOR        OUT PKG_GLB_COMMON.T_CURSOR);
 
  PROCEDURE SP_CON_RATEIACALCVALEFRETE(P_CON_VALEFRETE IN T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                                       P_CON_SERIE     IN T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                                       P_CON_ROTA      IN T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                                       P_CON_SAQUE     IN T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                                       P_USUARIO       IN T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                       P_ROTAUSUARIO   IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                       P_TPCALCULO     IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETETP_CODIGO%TYPE,
                                       P_PERCENTUAL    IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETE_PERCDIVSAO%TYPE,
                                       P_CNPJ          IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETE_CNPJCPF%TYPE,
                                       P_TPPESSOA      IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETE_TPPESSOA%TYPE,
                                       P_STATUS        OUT CHAR,
                                       P_MESSAGE       OUT VARCHAR2);

  
  PROCEDURE SP_GET_IDINTEGRACAODRU(P_referencia IN CHAR);

  Function fn_ListaEntregas(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                            pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                            pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                            pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type)
         return varchar2;

  Function fn_ListaClienteEntregas(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                   pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                   pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                   pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                   pCriaEstadia    in char,
                                   pStatus         out char,
                                   pMessage        out varchar2)
                            -- podendo ser D para Destinos
                            --             Q para quantidades
         return varchar2;
      
  PROCEDURE SP_CON_VALIDAVALEFRETE(P_QRYSTR   In blob,
                                   P_XMLOUT   Out Clob,
                                   P_STATUS   OUT CHAR,
                                   P_MESSAGE  OUT VARCHAR2);     



  PROCEDURE SP_CON_VERIFICACANCELVF(P_VF      IN  T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                                    P_SERIE   IN  T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                                    P_ROTA    IN  T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                                    P_SAQUE   IN  T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                                    P_STATUS  OUT CHAR,
                                    P_MESSAGE OUT VARCHAR2);                                      
                                  
  PROCEDURE SP_CON_CONSULTAVALEFRETE(P_QRYSTR    In Out  Varchar2,   
                                     P_STATUS    In OUT Varchar2,
                                     P_MESSAGE   In OUT Varchar2,
                                     P_CURSOR    OUT PKG_GLB_COMMON.T_CURSOR);

  procedure sp_con_InsereVFTContaCorrente(p_vfnumero  in t_con_valefrete.con_conhecimento_codigo%type,
                                          p_vfserie   in t_con_valefrete.con_conhecimento_serie%type,
                                          p_vfrota    in t_con_valefrete.glb_rota_codigo%type,
                                          p_vfsaque   in t_con_valefrete.con_valefrete_saque%type,
                                          p_Usuario     in t_con_valefrete.usu_usuario_codigo%type,
                                          p_RotaUsuario in t_con_valefrete.glb_rota_codigo%type,
                                          p_status   out char,
                                          p_message  out varchar2);

 PROCEDURE SP_CON_INSERE_VALEFRETE(P_CON_CONHECIMENTO_CODIGO      IN CHAR,
                                   P_CON_CONHECIMENTO_SERIE       IN CHAR,
                                   P_CON_VIAGEM_NUMERO            IN CHAR,
                                   P_GLB_ROTA_CODIGO              IN CHAR,
                                   P_GLB_ROTA_CODIGOVIAGEM        IN CHAR,
                                   P_CON_VALEFRETE_SAQUE          IN CHAR,
                                   P_CON_VALEFRETE_CONHECIMENTOS  IN CHAR,
                                   P_CON_VALEFRETE_CARRETEIRO     IN CHAR,
                                   P_CON_VALEFRETE_NFS            IN CHAR,
                                   P_CON_VALEFRETE_PLACASAQUE     IN CHAR,
                                   P_CON_VALEFRETE_TIPOTRANSPORTE IN CHAR,
                                   P_CON_VALEFRETE_PLACA          IN CHAR,
                                   P_CON_VALEFRETE_LOCALCARREG    IN CHAR,
                                   P_CON_VALEFRETE_LOCALDESCARGA  IN CHAR,
                                   P_CON_VALEFRETE_KMPREVISTA     IN NUMBER,
                                   P_CON_VALEFRETE_PESOINDICADO   IN NUMBER,
                                   P_CON_VALEFRETE_LOTACAO        IN NUMBER,
                                   P_CON_VALEFRETE_PESOCOBRADO    IN NUMBER,
                                   P_CON_VALEFRETE_ENTREGAS       IN CHAR,
                                   P_CON_VALEFRETE_CUSTOCARRET    IN NUMBER,
                                   P_CON_VALEFRETE_TIPOCUSTO      IN CHAR,
                                   P_CON_VALEFRETE_EMISSOR        IN CHAR,
                                   P_GLB_LOCALIDADE_CODIGODES     IN CHAR,
                                   P_GLB_LOCALIDADE_CODIGOORI     IN CHAR,
                                   P_CON_CATVALEFRETE_CODIGO      IN CHAR,
                                   P_GLB_TPMOTORISTA_CODIGO       IN CHAR,
                                   P_USU_USUARIO                  IN CHAR,
                                   P_CON_VALEFRETE_DTEMISSAO      CHAR,
                                   p_CON_VALEFRETE_DOCREF         IN VARCHAR2,
                                   P_CON_SUBCATVALEFRETE_CODIGO   IN CHAR);


 PROCEDURE SP_CON_INSERE_VFRETECONHEC(P_CON_VALEFRETE_CODIGO     CHAR,
                                      P_CON_VALEFRETE_SERIE      CHAR,
                                      P_GLB_ROTA_CODIGOVALEFRETE CHAR,
                                      P_CON_VALEFRETE_SAQUE      CHAR,
                                      P_GLB_ROTA_CODIGO          CHAR,
                                      P_CON_CONHECIMENTO_CODIGO  CHAR,
                                      P_CON_CONHECIMENTO_SERIE   CHAR,
                                      P_CON_CONHECIMENTO_PLACA   CHAR DEFAULT NULL);


 PROCEDURE SP_CON_VFRETEANTERIOR(PCON_VALEFRETE_CODIGO        CHAR,
                                 PCON_VALEFRETE_SERIE         CHAR,
                                 PGLB_ROTA_CODIGOVALEFRETE    CHAR,
                                 PCON_VALEFRETE_SAQUEANTERIOR CHAR,
                                 PCON_VALEFRETE_SAQUEATUAL    CHAR);

PROCEDURE SP_CON_FRETECAIXA(P_ROTA    IN CHAR,
                            P_DATALANCAMENTO IN CHAR,
                            P_DATAPROCESSAMENTO IN CHAR,
                            P_COMMIT  IN CHAR DEFAULT 'N',
                            P_HORARIOCORTE IN CHAR DEFAULT 'N',
                            P_REVERTE IN CHAR DEFAULT 'N');

Procedure SP_CON_ATUALIZACAIXA(pDataProc in char default sysdate);
                              
-- PROCEDURE SP_CON_FRETECAIXA(P_QUERYSTR      IN Varchar2,
--                             P_STATUS        OUT CHAR,
--                             P_MESSAGE       OUT VARCHAR2) ;


-- Função utilizada para saber se um Conhecimento possui uma embalagem de transfereência.                             --
Function FN_Get_EmbTransferencia(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                 pCon_conhecimento_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                 pGlb_rota_codigo in tdvadm.t_con_conhecimento.glb_rota_codigo%type ) return char;
                                 

Function FN_Get_EmbTransferencia2(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                  pCon_conhecimento_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                  pGlb_rota_codigo in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                  pDataaSerVerificada in char default trunc(sysdate) ,
                                  pRetorno char default 'T') return char;

 Function FN_Get_SaqueCheckin(pCon_Valefrete_codigo    in tdvadm.t_con_vfreteconhec.con_valefrete_codigo%type,
                              pGlb_Valefrete_rota      in tdvadm.t_con_vfreteconhec.glb_rota_codigovalefrete%type,
                              pCon_ValeFrete_serie     in tdvadm.t_con_vfreteconhec.con_valefrete_serie%type,
                              pCon_Valefrete_Saque     in tdvadm.t_con_vfreteconhec.con_valefrete_saque%type,
                              pCon_conhecimento_codigo in tdvadm.t_con_vfreteconhec.con_conhecimento_codigo%type,
                              pCon_conhecimento_serie  in tdvadm.t_con_vfreteconhec.con_conhecimento_serie%type,
                              pGlb_rota_codigo         in tdvadm.t_con_vfreteconhec.glb_rota_codigo%type
                             ) return char;

Function FN_Get_Pagamento(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                          pCon_conhecimento_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                          pGlb_rota_codigo         in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                          pCon_Valefrete_Saque     in tdvadm.t_con_valefrete.con_valefrete_saque%type,
                          pCon_Calcvalefrete_Tipo  in tdvadm.t_con_calcvalefrete.con_calcvalefrete_tipo%type  default '20'  
                           ) return char;
   PROCEDURE SP_CON_VFPODEIMPRIMIR(  P_APLIACACAO     IN  TDVADM.T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE,
                                     P_ROTA           IN  TDVADM.T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                     P_USUARIO        IN  TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                     p_VfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                     p_VfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                     p_VfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                     p_VfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%TYPE,
                                     P_PODEIMPRIMIR   OUT CHAR,
                                     P_STATUS         OUT CHAR,
                                     P_MESSAGE        OUT VARCHAR2);

  
  PROCEDURE SP_GETIDVALIDOALT( P_APLIACACAO     IN  TDVADM.T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE,
                               P_ROTA           IN  TDVADM.T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                               P_USUARIO        IN  TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                               p_VfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                               p_VfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                               p_VfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                               p_VfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type,
                               P_IDOPER_CODIGO  OUT VARCHAR2,
                               P_IDOPER_ROTA    OUT TDVADM.T_CON_FRETEOPER.CON_FRETEOPER_ROTA%TYPE,
                               p_CIOTNUMERO     OUT TDVADM.T_CON_VFRETECIOT.CON_VFRETECIOT_NUMERO%TYPE,
                               p_viagem         OUT TDVADM.t_Vgm_Viagem.VGM_VIAGEM_CODIGO%TYPE,
                               p_viagemRota     OUT TDVADM.t_Vgm_Viagem.GLB_ROTA_CODIGO%TYPE,
                               P_STATUS         OUT CHAR,
                               P_MESSAGE        OUT VARCHAR2 
                         );
  
  PROCEDURE SP_CON_VERIFICAPODEIMP;
  
  
  
    PROCEDURE SP_CON_SETALTERACAOVLR(P_QUERYSTR      IN  Varchar2,
                                     P_STATUS        OUT CHAR,
                                     P_MESSAGE       OUT VARCHAR2);
                           
  PROCEDURE SP_GET_DOCREFERENCIA(P_QRYSTR   In VARCHAR2,
                                 P_XMLOUT   Out Clob);

  PROCEDURE SP_ATUVERBA_VFRETE;

  PROCEDURE SP_CON_MARCARECALCULO;
  
  
  procedure SP_RecalculaCusto(pMargem  in number default 10, -- qual a margem minima para o recalculo
                              pRota    in char default '000',
                              pStatus  out char,
                              pMessage out varchar2);

  procedure SP_RecalculaCusto;

  PROCEDURE SP_CON_VALIDAVALEFRETE2(P_QRYSTR   In blob,
                                   P_XMLOUT   Out clob,
                                   P_STATUS   OUT CHAR,
                                   P_MESSAGE  OUT VARCHAR2);  
                                   
  procedure sp_con_duplicidade_cax(pRota in tdvadm.t_glb_rota.glb_rota_codigo%type);


  Function fn_ListaAtivos(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                          pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                          pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                          pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type)
         return varchar2;

  Function fn_ListaCte(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                       pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                       pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                       pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type)
         return varchar2;

  Function fn_PegaCodEstadia(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                             pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                             pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                             pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type,
                             pListaCliente in tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type,
                             pListaGrupo   in tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type)
         return varchar2;

  Function fn_DiarioBordoEmitido(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                 pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                 pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                 pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type)
         return varchar2;
         
  Procedure Sp_Get_ValeFreteImpDiario(pXmlIn   In Varchar2,
                                      pCursor  Out Types.cursorType,
                                      pStatus  Out Char,
                                      pMessage Out Varchar2);         
         

  Function fn_DiarioBordoRecebido(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                  pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                  pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                  pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type)
         return varchar2;
         
  Function Fn_DiarioBordoStatusFull(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                    pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                    pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                    pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type)return varchar2;

  Procedure Sp_Con_ValidavfretemdfeNew(p_vfnumero  in t_con_valefrete.con_conhecimento_codigo%type,
                                       p_vfserie   in t_con_valefrete.con_conhecimento_serie%type,
                                       p_vfrota    in t_con_valefrete.glb_rota_codigo%type,
                                       p_vfsaque   in t_con_valefrete.con_valefrete_saque%type,
                                       p_parametro in varchar2,
                                       p_status   out char,
                                       p_message  out varchar2);
  
  Procedure Sp_Con_Validavfretemdfe(p_vfnumero  in t_con_valefrete.con_conhecimento_codigo%type,
                                    p_vfserie   in t_con_valefrete.con_conhecimento_serie%type,
                                    p_vfrota    in t_con_valefrete.glb_rota_codigo%type,
                                    p_vfsaque   in t_con_valefrete.con_valefrete_saque%type,
                                    p_parametro in varchar2,
                                    p_status    out char,
                                    p_message   out varchar2);                                    

  procedure sp_con_CalcValefrete(p_vfnumero  in t_con_valefrete.con_conhecimento_codigo%type,
                                 p_vfserie   in t_con_valefrete.con_conhecimento_serie%type,
                                 p_vfrota    in t_con_valefrete.glb_rota_codigo%type,
                                 p_vfsaque    in t_con_valefrete.con_valefrete_saque%type,
                                 p_DescDebito in char default 'S',
--                                 p_Usuario     in t_con_valefrete.usu_usuario_codigo%type,
--                                 p_RotaUsuario in t_con_valefrete.glb_rota_codigo%type,
                                 p_status   out char,
                                 p_message  out varchar2
                                 );

  procedure Sp_Set_MarcaVfRecebido(pVfNumero in t_con_valefrete.con_conhecimento_codigo%type,
                                   pVfSerie  in t_con_valefrete.con_conhecimento_serie%type,
                                   pVfRota   in t_con_valefrete.glb_rota_codigo%type,
                                   pVfSaque  in t_con_valefrete.con_valefrete_saque%type,
                                   pDateRec  in date,
                                   pStatus   out char,
                                   pMessage  out varchar2);


   function fn_validahorario(phorario in tdvadm.t_con_diariobordo.hora1iv%type,
                             pTipo in char default 'X') -- indica se é Inicio ou Fim 
     return  tdvadm.t_con_diariobordo.hora1iv%type;

   procedure sp_con_ProcessaDiarioBordo(pCodSol in t_glb_solicitacao.glb_solicitacao_cod%type);

   PROCEDURE SP_LISTA_DIARIO(pDataIni in char,
                             pDataFim in Char);

   Procedure Sp_ExisteMDFeNaoCancelado(p_veicDisp in  t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                       p_veicSeq  in  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type, 
                                       p_status   out char,
                                       p_message  out varchar2);
   
   
   Procedure sp_con_calcImpostos(p_vfnumero   in t_con_valefrete.con_conhecimento_codigo%type,
                                 p_vfserie    in t_con_valefrete.con_conhecimento_serie%type,
                                 p_vfrota     in t_con_valefrete.glb_rota_codigo%type,
                                 p_vfsaque    in t_con_valefrete.con_valefrete_saque%type,
                                 p_INSS       out number,
                                 p_SESTSENAT  out number,
                                 p_IRRF       out number,
                                 p_COFINS     out number,
                                 p_CSLL       out number,
                                 p_PIS        out number,
                                 p_Status     out char,
                                 p_Message    out varchar2);

   Procedure sp_con_atualizaFreteAnalise;
   
    Procedure Sp_Con_CancelaVfAmfo(p_chavemdfe in tdvadm.t_con_controlemdfe.con_controlemdfe_chaveaces%type,
                                         p_status    out char,
                                         p_messagen  out varchar2);                                                                            
    
   Function Fn_VerificaObrigacaoDigCodOrigem(pListaParams IN glbadm.pkg_listas.tlistausuparametros, 
                                             pGrupoEconomico TDVADM.T_GLB_CLIENTE.GLB_GRUPOECONOMICO_CODIGO%type)
   RETURN BOOLEAN;
   
-- Verifica se Houve desconto ou nao no Vale de FRETE  
   Function Fn_RetornaDescBonus(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                                pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                                pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                                pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type)
   RETURN CHAR;           

-- Verifica se Desconta Bonus ou Não validando os Coontratos dos CTE´s
-- Se variaos contratos nos CTEs e Com DESCONTA igual a 'S' e 'N'
-- O Sistema pega o Maior que é o 'S'
 Function Fn_VerificaDescBonus(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                               pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                               pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                               pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type,
                               pTpMotrista     in tdvadm.t_con_valefrete.glb_tpmotorista_codigo%type default 'X')
       return char;

-- Verifica se Desconta Bonus ou Não validando o Coontrato Passado
-- Se variaos contratos nos CTEs e Com DESCONTA igual a 'S' e 'N'
-- O Sistema pega o Maior que é o 'S'
   Function Fn_VerificaDescBonus(pContrato in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                                 pFrotaCar in char)
   return char;
   

END PKG_CON_VALEFRETE;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_CON_VALEFRETE AS

    tpVF PKG_CON_VALEFRETE.TpValidaVF;
    -- Variavael usada para lancamento do Frete eletronico no caixa
    tpMovimento          tdvadm.t_cax_movimento%rowtype;
    


   Function Fn_RetornaTarifa(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                             pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                             pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                             pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type)
       return number
    Is
      vValor number;
    Begin
        select sum(vf.con_calcvalefrete_valor)
           into vValor
        from t_con_calcvalefrete vf
        where vf.con_conhecimento_codigo = pValeFreteCod
          and vf.con_conhecimento_serie = pValeFrereSerie
          and vf.glb_rota_codigo = pValeFreteRota
          and vf.con_valefrete_saque = pValeFreteSaque
          and vf.con_calcvalefretetp_codigo in ('06','07'); 
        
        return vValor;
       
    End Fn_RetornaTarifa;



  Function fn_RetornaPrimeiroVF(pCte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                pSerie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                pRota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type)
          return varchar2
  As
  Begin
 
     For c_msg in (select vfc.con_valefrete_codigo vfrete,
                          vfc.con_valefrete_serie vserie,
                          vfc.glb_rota_codigovalefrete vrota, 
                          vfc.con_valefrete_saque vsaque
                   from tdvadm.t_con_vfreteconhec vfc,
                        tdvadm.t_con_valefrete vf
                   where vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                     and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                     and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                     and vfc.con_valefrete_saque = vf.con_valefrete_saque   
                     and vf.con_valefrete_status is null
                     and vfc.con_conhecimento_codigo = pCte
                     and vfc.con_conhecimento_serie = pSerie
                     and vfc.glb_rota_codigo = pRota
                   order by vf.con_valefrete_datacadastro)
      Loop
         return c_msg.vfrete || '-' || c_msg.vserie || '-' || c_msg.vrota || '-' || c_msg.vsaque;
      End Loop;
      Return null;

    
  End fn_RetornaPrimeiroVF ;          

  Function fn_RetornaUltimoVF(pCte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                              pSerie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                              pRota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type)
          return varchar2
  As
  Begin
 
     For c_msg in (select vfc.con_valefrete_codigo vfrete,
                          vfc.con_valefrete_serie vserie,
                          vfc.glb_rota_codigovalefrete vrota, 
                          vfc.con_valefrete_saque vsaque
                   from tdvadm.t_con_vfreteconhec vfc,
                        tdvadm.t_con_valefrete vf
                   where vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                     and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                     and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                     and vfc.con_valefrete_saque = vf.con_valefrete_saque   
                     and vf.con_valefrete_status is null
                     and vfc.con_conhecimento_codigo = pCte
                     and vfc.con_conhecimento_serie = pSerie
                     and vfc.glb_rota_codigo = pRota
                   order by vf.con_valefrete_datacadastro desc)
      Loop
         return c_msg.vfrete || '-' || c_msg.vserie || '-' || c_msg.vrota || '-' || c_msg.vsaque;
      End Loop;
      Return null;

    
  End fn_RetornaUltimoVF ;          

  Procedure SP_eSocialValida(pCPF in tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type,
                             pPrazo in integer default 90,
                             pStatus out Char,
                             pMessage out varchar2)
   Is
     vTextoeSocial tdvadm.t_car_esocial.car_esocial_mensagem%type;
     vUltConsulta  tdvadm.t_car_esocial.car_esocial_dtconsulta%type;
     vStatus       tdvadm.t_car_esocial.car_esocial_status%type;
   Begin
     
      pStatus  := 'N';
      pMessage := '';
      If tpVF.v_Proprietario Is not null Then
         Begin
              
         
            select tdvadm.f_extrai(3,e.car_esocial_mensagem,'['),
                   e.car_esocial_dtconsulta,
                   e.car_esocial_status
              into vTextoeSocial,
                   vUltConsulta,
                   vStatus
            from TDVADM.T_CAR_ESOCIAL e
            where e.car_proprietario_cgccpfcodigo = trim(pCPF);
              
            If ( round(sysdate - vUltConsulta,0) > pPrazo ) and ( vStatus = '200' ) Then
              -- Sirlano 29/08/2018
              -- pStatus  := PKG_GLB_COMMON.Status_Erro;
              pStatus := 'N';
               pMessage := 'CONSULTA DO eSocial VENCIDA!' || chr(10) || 'VALIDAR ID NO MONITOR DE FRETE ELETRONICO' || chr(10);
            Elsif  vStatus = '400' Then
               vTextoeSocial := replace(replace(replace(vTextoeSocial,']'),'}'),'"');
               vTextoeSocial := replace(vTextoeSocial,',',chr(10));
               pMessage := '**************ERRO DE QUALIFICACAO eSocial**************' || chr(10);
               pStatus  := PKG_GLB_COMMON.Status_Erro;
               pMessage := pMessage || vTextoeSocial || chr(10);
            End If;      

              Exception
                When NO_DATA_FOUND Then
              -- Sirlano 29/08/2018
              -- pStatus  := PKG_GLB_COMMON.Status_Erro;
              pStatus := 'N';
                    pMessage := 'VALIDAR ID NO MONITOR DE FRETE ELETRONICO';
                End;        
              
          End If;    

   End SP_eSocialValida;   
     
     
  Function F_STATUS_IMGESTADIA(pVFCategoria  in tdvadm.t_con_valefrete.con_catvalefrete_codigo%type,
                               pIMGArquivada in tdvadm.t_glb_vfimagem.glb_vfimagem_arquivado%type,
                               pUsuConf      in tdvadm.t_glb_vfimagem.usu_usuario_codigoconf%type)
    RETURN CHAR
    IS
    vRetorno varchar2(50);
     Begin
    -- decode(vi.glb_vfimagem_arquivado,'S',decode(cat.con_catvalefrete_codigo,'17',decode(nvl(vi.usu_usuario_codigoconf,'Sirlano'),'Sirlano','Aguardando Autorização','Autorizado'),'Outras Imagens'),'R','Recusado','Aguardando Imagem') status,
     if nvl(pIMGArquivada,'N') = 'S' then
       if nvl(pVFCategoria,'00') = CatTEstadia Then
           if nvl(pUsuConf,'Sirlano') = 'Sirlano' Then
             vRetorno := 'Aguardando Autorizacao';
           Else
             vRetorno := 'Autorizada';
           End If;
        Else
           vRetorno := 'Outras Imagens';
        End If;
     ElsIf nvl(pIMGArquivada,'N') = 'R' Then
        vRetorno := 'Recusada';
     ElsIf nvl(pIMGArquivada,'N') = 'I' Then
        vRetorno := 'Imagem Incompleta';
       Else
       if nvl(pVFCategoria,'00') = CatTEstadia Then
          vRetorno := 'Aguardando Imagem';
       Else
          vRetorno := 'Imagem NAO OBRIGATORIA';
       End If;
     End If;

     return vRetorno;

   End F_STATUS_IMGESTADIA;


   Function FN_Get_CNPJLOCLIBIMAGEM(P_CGCCPFREMETENTE    IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                    P_CGCCPFDESTINATARIO IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                    P_CGCCPFSACADO       IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                    P_CODIGOORIGEM       IN TDVADM.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE,
                                    P_CODIGODESTINO      IN TDVADM.T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE)
      RETURN CHAR
      is
     Begin
       if TRIM(P_CGCCPFREMETENTE)    = '33931486002427' and  -- VALE FERTILIZANTES
          TRIM(P_CGCCPFDESTINATARIO) = '33931486001960' and  -- VALE FERTILIZANTES
          TRIM(P_CGCCPFSACADO)       = '33931486001960' and  -- VALE FERTILIZANTES
          TRIM(P_CODIGOORIGEM)       = '38180' and           -- CUBATÃO-SP
          TRIM(P_CODIGODESTINO)      = '11500' Then          -- ARAXA-MG
          return 'S';
       Else
          return 'N';
       End If;
    End FN_Get_CNPJLOCLIBIMAGEM;

   Function F_BUSCA_TRANSFENTREARMAZEM(P_LOCALIDADE T_CON_VALEFRETE.CON_VALEFRETE_LOCALDESCARGA%TYPE)
       RETURN CHAR
     IS
    Begin

     -- alterado conforme email recebido da Cris
     -- todas as filiais foram informadas no dia 29/03/2012
     If trunc(Sysdate) >= to_date('30/03/2012','dd/mm/yyyy') Then

       IF P_LOCALIDADE IN ( '65033',  -- ARMAZEM ACAILANDIA-MA
                            '13471',  -- ARMAZEM AMERICANA-SP
                            '67001',  -- ARMAZEM ANANINDEUA-PA
                            '76991',  -- ARMAZEM APARECIDA DE GOIANIA-GO
                            '35589',  -- ARMAZEM ARCOS-MG
                            '36201',  -- ARMAZEM BARBACENA-MG
                            '27401',  -- ARMAZEM BARRA MANSA-RJ
                            '40044',  -- ARMAZEM CAMACARI-BA
                            '99420',  -- ARMAZEM CANOAS-RS
                            '29002',  -- ARMAZEM CARIACICA-ES
                            '32001',  -- ARMAZEM CONTAGEM-MG
                            '30099',  -- ARMAZEM CONTAGEM-MG 18/04/2013
                            '79301',  -- ARMAZEM CORUMBA-MS
                            '80003',  -- ARMAZEM CURITIBA-PR
                            '35502',  -- ARMAZEM DIVINOPOLIS-MG
                            '60001',  -- ARMAZEM FORTALEZA-CE
                            '35452',  -- ARMAZEM ITABIRITO-MG
                            '54390',  -- ARMAZEM JABOATAO DOS GUARARAPES-PE
                            '68502',  -- ARMAZEM MARABA-PA
                            '68023',  -- ARMAZEM MARITUBA-PA
                            '68024',  -- ARMAZEM OURILANDIA DO NORTE-PA
                            '68022',  -- ARMAZEM PARAUAPEBAS-PA
                            '12401',  -- ARMAZEM PINDAMONHANGABA-SP
                            '20001',  -- ARMAZEM RIO DE JANEIRO-RJ
                            '49761',  -- ARMAZEM ROSARIO DO CATETE-SE
                            '11001',  -- ARMAZEM SANTOS-SP
                            '65022',  -- ARMAZEM SÃO LUIS-MA
                            '05571',  -- ARMAZEM SAO PAULO-SP
                            '99801',  -- ARMAZEM SETE LAGOAS-MG
                            '35182',  -- ARMAZEM TIMOTEO-MG
                            '26001',  -- ARMAZEM TRINDADE-PE
                            '38401',  -- ARMAZEM UBERLANDIA-MG
                            '68537') Then -- ARMAZEM CANAA DOS CARAJAS - PA 
         RETURN 'S';
       ELSE
         RETURN 'N';
       END IF;
     Else
       IF P_LOCALIDADE IN ('20001', -- RJ  ARMAZEM RIO DE JANEIRO-RJ
                           '11001', -- SP  ARMAZEM SANTOS-SP
                           '30099', -- MG  ARMAZEM CONTAGEM-MG
                           '05571', -- SP  ARMAZEM SAO PAULO-SP
                           '32001', -- MG  ARMAZEM CONTAGEM-MG
                           '99420', -- RS  ARMAZEM CANOAS-RS
                           '29002', -- ES  ARMAZEM CARIACICA-ES
                           '35180', -- MG ARMAZEM TIMOTEO-MG
                           '40044', -- BA  ARMAZEM CAMACARI-BA
                           '65022', -- MA  ARMAZEM SÃO LUIS-MA
                           '65033', -- MA  ARMAZEM ACAILANDIA-MA
                           '68022', -- PA  ARMAZEM PARAUAPEBAS-PA
                           '68023', -- PA  ARMAZEM MARITUBA-PA
                           '68024') THEN -- PA  ARMAZEM OURILANDIA DO NORTE-PA

      -- no dia 29 a minuta 021/347780 estava como transferencia indefidamente
         If ( trunc(Sysdate) = to_date('29/03/2012','dd/mm/yyyy') ) And ( P_LOCALIDADE = '29002' ) Then
           Return 'N';
         Else
           RETURN 'S';
         End If;
       ELSE
          RETURN 'N';
       END If;
     End If;
   END F_BUSCA_TRANSFENTREARMAZEM;

   function fni_vld_PagaPedagio(pCategoria in tdvadm.t_con_catvalefrete.con_catvalefrete_codigo%type)
     return Char
   is
     vAuxiliar char;

   Begin
      Begin
         select decode(cvf.con_catvalefrete_pagapedagio,'S','N','S')
            into vAuxiliar
         from t_con_catvalefrete cvf
         where cvf.con_catvalefrete_codigo = pCategoria;
      exception
         When Others Then
            vAuxiliar := 'N';

      End;
      return vAuxiliar;

   End fni_vld_PagaPedagio;

   function fni_vld_SubCategoria(pCategoria      in tdvadm.t_con_subcatvalefrete.con_catvalefrete_codigo%type,
                                 pSubCategoria   in tdvadm.t_con_subcatvalefrete.con_subcatvalefrete_codigo%type,
                                 ptpSubcategoria out tdvadm.t_con_subcatvalefrete%rowtype)
     return Char
   is
     vAuxiliar number;
   Begin
      Begin
         Select *
           Into ptpSubcategoria
         From t_con_subcatvalefrete sc
         Where sc.con_catvalefrete_codigo = pCategoria
           And sc.con_subcatvalefrete_codigo = pSubCategoria ;
         vAuxiliar := 1;
      Exception
        When NO_DATA_FOUND Then
            Select Count(*)
               Into vAuxiliar
            From t_con_subcatvalefrete sc
            Where sc.con_catvalefrete_codigo = pCategoria;
      end;
       if vAuxiliar > 0 Then
          return 'S';
       else
          return 'N';
       End if;
   End fni_vld_SubCategoria;

   Function fn_ValidaMesaFrete(P_QRYSTR   In clob,
                                P_STATUS   OUT CHAR,
                                P_MESSAGE  OUT VARCHAR2)
     RETURN BOOLEAN
   IS
      vfcf_veiculodisp_codigo    tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
      vfcf_veiculodisp_sequencia tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
      vXmlin                     CLOB;
   Begin

   vXmlin :=           '<Parametros> ';
   vXmlin := vXmlin || '   <Inputs>';
   vXmlin := vXmlin || '     <Input>';
   vXmlin := vXmlin || '       <fcf_veiculodisp_codigo>' || '11233' || '</fcf_veiculodisp_codigo> ';
   vXmlin := vXmlin || '       <fcf_veiculodisp_sequencia>' || '0'  || '</fcf_veiculodisp_sequencia>';
   vXmlin := vXmlin || '     </Input>';
   vXmlin := vXmlin || '   </Inputs>';
   vXmlin := vXmlin || '</Parametros> ';
   -- lIBERAR DEPOIS DO teste
 --  vXmlin := P_QRYSTR;

      P_STATUS  :=  PKG_GLB_COMMON.Status_Nomal;
      P_MESSAGE := '';
      vfcf_veiculodisp_codigo    := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXmlin,'fcf_veiculodisp_codigo' ));
      vfcf_veiculodisp_sequencia := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXmlin,'fcf_veiculodisp_sequencia' ));

      -- Pega o Tipo de Veiculo

      -- Pega as Localidades da Solictacção

      -- Pega a Localidade fechada no Frete

      RETURN TRUE;

   End fn_ValidaMesaFrete;

   Function Fn_RetornaOperacao(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                               pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                               pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                               pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type,
                               pCodParcelaPaga in t_con_calcvalefrete.con_calcvalefretetp_codigo%type,
                               pRotaCaixa      in t_glb_rota.glb_rota_codigo%type,
                               pTipo           in char) return char is
   vIsFrota        integer;
   vGerenciadora   t_cfe_gerenbco.cfe_gerenbco_cod%type;
   vCodOperacao    t_cax_operacaocfe.cax_operacao_codigos%type; 
   vTipoFavorecido t_cax_operacaocfe.cax_operacaocfe_tpfavorecido%type;
   vAuxiliar       Integer;
   begin
     
     begin
       
       -- Busco se é um Frota
       select decode(substr(vf.con_valefrete_placa,1,3),'000',1,0)
         into vIsFrota
         from t_con_valefrete vf
        where vf.con_conhecimento_codigo = pValeFreteCod   
          and vf.con_conhecimento_serie  = pValeFrereSerie 
          and vf.glb_rota_codigo         = pValeFreteRota  
          and vf.con_valefrete_saque     = pValeFreteSaque;
       
       -- Analisando o tipo de favorecido
       if (vIsFrota > 0) then
         vTipoFavorecido := 'F';
       else
         vTipoFavorecido := 'C';
       end if;
         
       -- Busco a Gerenciadora 
       Begin
       select nvl(s.cfe_gerenbco_cod,'1')
         into vGerenciadora
         from t_con_vfreteciot c,
              t_uti_sequencia s
        where c.con_conhecimento_codigo = pValeFreteCod  
          and c.con_conhecimento_serie  = pValeFrereSerie
          and c.glb_rota_codigo         = pValeFreteRota 
          and c.con_valefrete_saque     = pValeFreteSaque
          and c.con_freteoper_id        = s.uti_sequencia_codigo(+)
          and c.con_freteoper_rota      = s.uti_sequencia_rota  (+); 
       Exception
         When NO_DATA_FOUND Then
             vGerenciadora := '1';
         End ;     
       --Busco o Codido da Operação usando o Codigo da parcela e a Gerenciadora
       
       if (pTipo = 'S') Then
         
         if pCodParcelaPaga = '20' Then
            Begin
            -- Se for Saldo
            -- Pego qual operacao e a de Entrada
            -- Para pesquisar no caixa se o Cheque ja foi lancado.
             -- Busco pela rota de Pgto
               select l.cax_operacao_codigoE
                  into vCodOperacao
               from t_cax_operacaocfe l
               where l.cfe_gerenbco_cod             = vGerenciadora
                 and l.con_calcvalefretetp_codigo   = pCodParcelaPaga
                 and l.cax_operacaocfe_tpfavorecido = vTipoFavorecido
                 and l.glb_rota_codigo_operacaos    = pRotaCaixa;
           
            exception when no_data_found then
             
               -- Se não encontro busco sem rota  
               select l.cax_operacao_codigoE
                 into vCodOperacao
               from t_cax_operacaocfe l
                where l.cfe_gerenbco_cod             = vGerenciadora
                  and l.con_calcvalefretetp_codigo   = pCodParcelaPaga
                  and l.cax_operacaocfe_tpfavorecido = vTipoFavorecido;
           
            end;     

            select count(*)
              into vAuxiliar
            from t_cax_movimento m
            where m.cax_operacao_codigo = vCodOperacao
              and m.glb_tpdoc_codigo = 'VFS'
              and m.cax_movimento_documentoref = pValeFreteCod || pValeFrereSerie || pValeFreteRota || pValeFreteSaque;
              
            if vAuxiliar > 0 Then
               return vCodOperacao;
            End If;  
           
          End IF;
       
       
         begin
           
           -- Busco pela rota de Pgto
           select l.cax_operacao_codigos
             into vCodOperacao
             from t_cax_operacaocfe l
            where l.cfe_gerenbco_cod             = vGerenciadora
              and l.con_calcvalefretetp_codigo   = pCodParcelaPaga
              and l.cax_operacaocfe_tpfavorecido = vTipoFavorecido
              and l.glb_rota_codigo_operacaos    = pRotaCaixa;
         
         exception when no_data_found then
           
           -- Se não encontro busco sem rota  
           select l.cax_operacao_codigos
             into vCodOperacao
             from t_cax_operacaocfe l
            where l.cfe_gerenbco_cod             = vGerenciadora
              and l.con_calcvalefretetp_codigo   = pCodParcelaPaga
              and l.cax_operacaocfe_tpfavorecido = vTipoFavorecido;
         
         end;     
       
       elsif(pTipo = 'E') then
         
         begin
           
           -- Busco pela rota de Pgto
           select l.cax_operacao_codigoe
             into vCodOperacao
             from t_cax_operacaocfe l
            where l.cfe_gerenbco_cod             = vGerenciadora
              and l.con_calcvalefretetp_codigo   = pCodParcelaPaga
              and l.cax_operacaocfe_tpfavorecido = vTipoFavorecido
              and l.glb_rota_codigo_operacaoe    = pRotaCaixa; 
         
         exception when no_data_found then
          
           -- Se não encontro busco sem rota  
           select l.cax_operacao_codigoe
             into vCodOperacao
             from t_cax_operacaocfe l
            where l.cfe_gerenbco_cod             = vGerenciadora
              and l.con_calcvalefretetp_codigo   = pCodParcelaPaga
              and l.cax_operacaocfe_tpfavorecido = vTipoFavorecido;
         
         end;    
         
       end if;    
          
       return vCodOperacao;
       
     exception when others then
     
       return '0000';       
     
     end;
   
   end Fn_RetornaOperacao;    
   
   Function Fn_VerificaProcessamento(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                                     pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                                     pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                                     pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type,
                                     pCodParcelaPaga in t_con_calcvalefrete.con_calcvalefretetp_codigo%type,
                                     pRotaCaixa      in t_glb_rota.glb_rota_codigo%type,
                                     pTipo           in char) return char is
   vCodOperacao t_cax_operacao.cax_operacao_codigo%type;
   vRetorno     char(1);
   vIndicadorES t_cax_operacao.cax_operacao_tipo%type;
   begin
     
     -- Pega o retorno com a operação a ser lançada para aquela parcela.
     vCodOperacao :=  Fn_RetornaOperacao(pValeFreteCod,  
                                         pValeFrereSerie,
                                         pValeFreteRota, 
                                         pValeFreteSaque,
                                         pCodParcelaPaga,
                                         pRotaCaixa,     
                                         pTipo);
     
     select l.cax_operacao_tipo
       into vIndicadorES
       from t_cax_operacao l
      where l.cax_operacao_codigo = vCodOperacao
        and l.glb_rota_codigo_operacao = '000';
     
     -- Se for Saldo analise se o sistema inverteu a Operação
     if (pCodParcelaPaga = '20') then
       
       if (vIndicadorES <> pTipo) then
         
         vRetorno := 'N';
         
       else
           
         vRetorno := 'S';
       
       end if;
       
     else
       
       vRetorno := 'S'; 
      
     end if;    
                                      
     
     return vRetorno;                                
     
   end Fn_VerificaProcessamento;                                                             
                               
  
   PROCEDURE SP_CON_INSERECONTACORRENTE(P_CON_VALEFRETE  IN T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                                        P_CON_SERIE      IN T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                                        P_CON_ROTA       IN T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                                        P_CON_SAQUE      IN T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                                        P_VALORACREDITO  IN NUMBER default 0,
                                        P_SISTEMA        IN T_USU_SISTEMA.USU_SISTEMA_CODIGO%TYPE,
                                        P_USUARIO        IN T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                        P_ACAO           IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                        P_STATUS         OUT CHAR,
                                        P_MESSAGE        OUT VARCHAR2)
   As
     vProprietario t_car_proprietario.car_proprietario_cgccpfcodigo%type;
     tpContaCorrente t_car_contacorrente%rowtype;
     vVALORRESTANTE   number;
     vMultaValeFrete  number;
     vVAlorADescontar number;
     vValorCredito    number;
     vValorContaCorrente number;
     vImpresso      tdvadm.t_con_valefrete.con_valefrete_impresso%type;
   Begin
      P_STATUS := pkg_glb_common.Status_Nomal;
      P_MESSAGE := '';
      vValorCredito := nvl(P_VALORACREDITO,0);
      Begin
         select v.car_proprietario_cgccpfcodigo
            into vProprietario
         From t_con_valefrete vf,
              t_car_veiculo v
         Where vf.con_valefrete_placa = v.car_veiculo_placa
          and vf.con_valefrete_placasaque = v.car_veiculo_saque
          and vf.con_conhecimento_codigo = P_CON_VALEFRETE
          and vf.con_conhecimento_serie = P_CON_SERIE
          and vf.glb_rota_codigo = P_CON_ROTA
          and vf.con_valefrete_saque = P_CON_SAQUE;
      exception
        When NO_DATA_FOUND Then
           P_STATUS := pkg_glb_common.Status_Erro;
           P_MESSAGE := P_MESSAGE || 'Proprietario não encontrado para o Vale de Frete';
      End;

      Begin
            select vf.con_valefrete_multa,
                   vf.con_valefrete_impresso
              into vMultaValeFrete,
                   vImpresso
            from t_con_valefrete vf
            where vf.con_conhecimento_codigo  = P_CON_VALEFRETE
              and vf.con_conhecimento_serie = P_CON_SERIE
              and vf.glb_rota_codigo = P_CON_ROTA
              and vf.con_valefrete_saque = P_CON_SAQUE;
      exception
          When NO_DATA_FOUND Then
              P_STATUS := pkg_glb_common.Status_Erro;
              P_MESSAGE := P_MESSAGE ||  'Vale de Frete Não Localizado ';
      End ;
          vMultaValeFrete := nvl(vMultaValeFrete,0);

        if vMultaValeFrete <> vValorCredito Then

           IF nvl(vValorCredito,0) = 0 Then
              P_MESSAGE := 'Inserir Débito';
           Else
              P_MESSAGE := P_MESSAGE ||  'Problemas com o Valor da Multa ...';
              P_STATUS := pkg_glb_common.Status_erro;
           End If;
        End If;

        vVALORRESTANTE := vMultaValeFrete;

          select sum(cc.car_contacorrente_valor)
             into vValorContaCorrente
          from v_car_contacorrente cc
          where trim(cc.docref) = P_CON_VALEFRETE || P_CON_ROTA || P_CON_SAQUE;

          If nvl(vValorContaCorrente,0) > nvl(vMultaValeFrete,0)   Then
             vVALORRESTANTE := vMultaValeFrete;
 --            vInserDebito := 'N';
             If P_ACAO = 'Imprimir' Then
                P_MESSAGE := P_MESSAGE || '(IncCC) Valor da Multa Foi Alterado! Salve novamente o Vale de Frete Antes de IMPRIMIR.' || chr(10);
                P_MESSAGE := P_MESSAGE || 'Conta Corrente ' || f_mascara_valor(vValorContaCorrente,20,2);
                P_STATUS := pkg_glb_common.Status_Erro;
             End If;

          End If;
          If P_ACAO = P_ACAO Then
             If P_STATUS = pkg_glb_common.Status_Nomal Then
                If nvl(vImpresso,'N') = 'N' Then
                   delete t_car_contacorrente cc
                   where trim(cc.car_Contacorrente_Docref) = P_CON_VALEFRETE || P_CON_ROTA || P_CON_SAQUE;
                End If;
                
                FOR R_CURSOR IN(Select p.dtvenc,
                                   p.car_contacorrente_saldo,
                                   p.rowidcc,
                                   P.car_contacorrente_dtgravacao
                            FROM v_Car_Contacorrente P
                            WHERE trim(p.cpncnpjprop) = trim(vProprietario)
                              and p.dtfecha is Null
                              and trunc(p.dtvenc) <= trunc(sysdate)
                              And p.car_contacorrente_saldo > 0
     --                                       And trunc(p.car_contacorrente_dtgravacao) >= trunc(Sysdate - 1)
                              And p.car_contacorrente_saldo = (Select Min(p1.car_contacorrente_saldo)
                                                               From v_Car_Contacorrente P1
                                                               WHERE trim(p1.cpncnpjprop) = trim(vProprietario)
                                                                 And p1.documento = p.documento
                                                                 and trunc(p1.dtvenc) <= trunc(sysdate)
                                                                 and p.dtfecha is Null )
                            Order By P.car_contacorrente_dtgravacao)
               Loop
                  If vVALORRESTANTE > 0  Then
                     Select *
                       Into tpContaCorrente
                     From t_car_contacorrente cc
                     Where cc.rowid = r_cursor.rowidcc;

                      If  tpContaCorrente.Car_Contacorrente_Saldo >=  vVALORRESTANTE Then
                          vVAlorADescontar := vVALORRESTANTE;
                      Else
                          vVAlorADescontar := tpContaCorrente.Car_Contacorrente_Saldo;
                      End If;

 --                     vVAlorADescontar := vVAlorADescontar + vVAlorADescontar;
                      tpContaCorrente.Car_Contacorrente_Saldo := tpContaCorrente.Car_Contacorrente_Saldo -  vVAlorADescontar;
                      vVALORRESTANTE := vVALORRESTANTE - vVAlorADescontar;
                      If tpVF.VFNumero = '023750' Then
                         P_MESSAGE := P_MESSAGE || 'Descontar ' || to_char(vVAlorADescontar) || chr(10);
                         P_MESSAGE := P_MESSAGE || 'restante ' || to_char(vVALORRESTANTE) || chr(10);
                         P_MESSAGE := P_MESSAGE || 'Total Descontado ' || to_char(vVAlorADescontar) || chr(10);
                      End If;  
                      tpContaCorrente.Car_Contacorrente_Docref := P_CON_VALEFRETE || P_CON_ROTA || P_CON_SAQUE;
     --                             tpVF.tpContaCorrente.car_contacorrente_docorigem := tpVF.VFNumero || tpVF.VFSerie || tpVF.VFRota || tpVF.VFSaque;

                      tpContaCorrente.Car_Contacorrente_Valor := vVAlorADescontar;
                      tpContaCorrente.Car_Contacorrente_Tplanc := 'C';
                      tpContaCorrente.Car_Contacorrente_Tplancamento := 'C';
                      tpContaCorrente.Car_Contacorrente_Pagtomin := tpContaCorrente.Car_Contacorrente_Saldo;
                      tpContaCorrente.Car_Contacorrente_Data := Sysdate;
                      tpContaCorrente.Car_Contacorrente_Dtgravacao := Sysdate;
                      tpContaCorrente.Car_Contacorrente_Usuario := tpVF.VFusuarioTDV;
                      tpContaCorrente.Car_Contacorrente_Sistorigem   := 'comvlfrete';
                      tpContaCorrente.Car_Contacorrente_Obs := 'Desconto automatico feito no VF ' || tpVF.VFNumero || tpVF.VFSaque  || tpVF.VFRota || tpVF.VFSaque;


                         P_STATUS :=  PKG_GLB_COMMON.Status_Warning;
                         P_MESSAGE := P_MESSAGE || '11-Houve Desconto de Debito do CONTA CORRETE, Imprimir o Recibo se necessario.' || chr(10);


                       begin
                         Insert Into t_car_contacorrente
                         Values tpContaCorrente;
                       Exception
                         When OTHERS Then
                            P_STATUS   := PKG_GLB_COMMON.Status_Erro;
                             P_MESSAGE :=  P_MESSAGE || chr(10) ||
                                                        'Erro ao Inserir no Conta corrente Informe estes dados'                 || chr(10) ||
                                                        'Motorista - '    || tpContaCorrente.CAR_CARRETEIRO_CPFCODIGO      || chr(10) ||
                                                        'Sq Motrista - '  || tpContaCorrente.CAR_CARRETEIRO_SAQUE          || chr(10) ||
                                                        'Placa - '        || tpContaCorrente.CAR_VEICULO_PLACA             || chr(10) ||
                                                        'Sq Placa - '     || tpContaCorrente.CAR_VEICULO_SAQUE             || chr(10) ||
                                                        'Proprietario - ' || tpContaCorrente.CAR_PROPRIETARIO_CGCCPFCODIGO || chr(10) ||
                                                        'Documento - '    || tpContaCorrente.CAR_CONTACORRENTE_DOCUMENTO   || chr(10) ||
                                                        'Doc Ref - '      || tpContaCorrente.CAR_CONTACORRENTE_DOCREF      || chr(10) ||
                                                        'Vencimento - '   || tpContaCorrente.CAR_CONTACORRENTE_DTVENC      || chr(10) ||
                                                        'Valor - '        || tpContaCorrente.Car_Contacorrente_Valor       || chr(10) ||
                                                        'erro-' || sqlerrm;

                       End ;
                  End If;
            End Loop;
 --           commit;
        End If;
     End If;


   End SP_CON_INSERECONTACORRENTE;


   PROCEDURE SP_CON_CRIATITULO(P_CON_VALEFRETE IN T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                               P_CON_SERIE     IN T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                               P_CON_ROTA      IN T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                               P_CON_SAQUE     IN T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                               P_CNPJ          IN T_CON_VALEFRETE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                               P_USUARIO       IN T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                               P_ACAO          IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                               P_STATUS        OUT CHAR,
                               P_MESSAGE       OUT VARCHAR2)
    AS
      tpValeFrete tdvadm.t_con_valefrete%rowtype;
      tpTitulo    tdvadm.t_crp_titreceber%rowtype;

     Begin
       P_STATUS := pkg_glb_common.Status_Nomal;
       P_MESSAGE := '';

             If P_CNPJ is null Then
                P_STATUS := pkg_glb_common.Status_Erro;
                P_MESSAGE := P_MESSAGE || 'Obrigatorio preencher o CNPJ do Transportador' || chr(10);
             Else
                -- Verifica se o Cliente Existe
                select count(*)
                  into tpVF.vAuxiliar
                from t_glb_cliente cl
                where cl.glb_cliente_cgccpfcodigo = RPAD(P_CNPJ,20);
                If tpVF.vAuxiliar = 0 Then
                   P_STATUS := pkg_glb_common.Status_Erro;
                   P_MESSAGE := P_MESSAGE || 'Transportador não Cadastrado [' || RPAD(P_CNPJ,20) || ']' || chr(10);
                Else
                   -- Verifica se tem pelo menos um Endereço
                   select count(*)
                      into tpVF.vAuxiliar
                   from t_glb_cliend ce
                   where ce.glb_cliente_cgccpfcodigo = RPAD(P_CNPJ,20);
                   if tpVF.vAuxiliar = 0 Then
                      P_STATUS := pkg_glb_common.Status_Erro;
                      P_MESSAGE := P_MESSAGE || 'Transportador Tem que ter pelo menos 1 endereço' || chr(10);
                   Else
                     -- Verifica se Tem contato
                     select count(*)
                       into tpVF.vAuxiliar
                     from t_glb_clicont cc
                     where cc.glb_cliente_cgccpfcodigo = RPAD(P_CNPJ,20)
                       and cc.glb_clicont_fone is null;
                    if tpVF.vAuxiliar = 0 Then
                        P_STATUS := pkg_glb_common.Status_Erro;
                        P_MESSAGE := P_MESSAGE || 'Transportador Tem que ter pelo menos 1 Contato com Telefone' || chr(10);
                     End If;
                   End If;
                End If;
             End If;

              If ( tpVF.VFAcao in ('Imprimir') ) and ( NVL(P_STATUS,'N') <> pkg_glb_common.Status_Erro )   Then

                 select *
                    into tpValeFrete
                 from t_con_valefrete vf
                 where vf.con_conhecimento_codigo = P_CON_VALEFRETE
                   and vf.con_conhecimento_serie = P_CON_SERIE
                   and vf.glb_rota_codigo = P_CON_ROTA
                   and vf.con_valefrete_saque = P_CON_SAQUE;


                  select count(*)
                    into tpVF.vAuxiliar
                  from t_crp_titreceber tr
                  where tr.glb_rota_codigo = tpValeFrete.glb_rota_codigo
                    and tr.crp_titreceber_numtitulo =  tpValeFrete.Con_Conhecimento_codigo;

                  if tpVF.vAuxiliar = 0 then



                      tpTitulo.Glb_Rota_Codigo := tpValeFrete.glb_rota_codigo;
                      tpTitulo.Crp_Titreceber_Numtitulo := tpValeFrete.Con_Conhecimento_codigo;
                      tpTitulo.Crp_Titreceber_Saque := pkg_crp_titreceber.fn_get_Saque(tpTitulo.Glb_Rota_Codigo);

                      tpTitulo.Crp_Titreceber_Serie        := null;
                      tpTitulo.Crp_Tpcarteria_Codigo       := null;
                      tpTitulo.Glb_Banco_Numero            := null;
                      tpTitulo.Glb_Agencia_Numero          := null;
                      tpTitulo.Glb_Contas_Numero           := null;
                      tpTitulo.Glb_Moeda_Codigo            := '0001';
                      tpTitulo.Glb_Txmora_Codigo           := null;
                      tpTitulo.Con_Fatura_Codigo           := null;
                      tpTitulo.Glb_Rota_Codigofilialimp    := null;
                      tpTitulo.Crp_Titreceber_Dtgeracao    := sysdate;
                      tpTitulo.Glb_Cliente_Cgccpfcodigo    := tpValeFrete.glb_cliente_cgccpfcodigo;
                      tpTitulo.Crp_Titreceber_Vlrcobrado   := NVL(tpValeFrete.con_valefrete_frete,0) + NVL(tpVF.tpValeFrete.con_valefrete_Pedagio,0);
                      tpTitulo.Crp_Titreceber_Dtvencimento := tpValeFrete.Con_Valefrete_Dataprazomax + vPrazoVencTitulo;
                      tpTitulo.Crp_Titreceber_Dtprevpag    := tpValeFrete.Con_Valefrete_Dataprazomax;
                      If nvl(tpTitulo.Crp_Titreceber_Vlrcobrado,0) > 0 Then
                         insert into t_crp_titreceber values tpTitulo;
                         commit;
                         P_MESSAGE := 'Titulo criado....';
                      Else   
                         P_MESSAGE := 'Vale de Frete com Problema retornou valor zerado para o TITULO...';
                         P_STATUS  := pkg_glb_common.Status_Erro;
                      End If;                      
                  Else
                      P_MESSAGE := 'Titulo ja EXISTE....';
                  End If;
              End If;

              If ( tpVF.VFAcao in ('Excluir','Alterar','Cancela') ) and ( P_STATUS <> pkg_glb_common.Status_Erro )   Then

                 select count(*)
                   into tpVF.vAuxiliar
                 from t_crp_titreceber tr
                 where tr.glb_rota_codigo = tpValeFrete.glb_rota_codigo
                   and tr.crp_titreceber_numtitulo = tpValeFrete.Con_Conhecimento_codigo;

                 if tpVF.vAuxiliar <> 0 Then
                    P_STATUS := pkg_glb_common.Status_Erro;
                    P_MESSAGE := P_MESSAGE || 'Vale de Frete Contem Titulo. Cancele ou Exclua antes!' || chr(10);
                 End If;


              End If;


    End SP_CON_CRIATITULO;

   PROCEDURE SP_CON_ATUCALCVALEFRETE(P_QUERYSTR      IN OUT  Varchar2,
                                     P_STATUS        OUT CHAR,
                                     P_MESSAGE       OUT VARCHAR2,
                                     P_CURSOR        OUT PKG_GLB_COMMON.T_CURSOR) AS

      plistaparams         glbadm.pkg_listas.tlistausuparametros;
      vValeFrete  TDVADM.T_CON_VALEFRETE%ROWTYPE;
      vContador   NUMBER;
      vQtdeVerbas NUMBER;
      vFreteBruto NUMBER;
      vValorDesc  NUMBER;
      vProprietario tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%TYPE;
      vExisteCiot INTEGER;
      vExisteCiotVinc INTEGER;
      vExisteSolCiot INTEGER;
      vDescpedagio char(1) := 'S';
      vValorPedagio number := 0;
      vValeFreteNumero                  T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE;
      vValeFreteSerie                   T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE;
      vValeFreteRota                    T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE;
      vValeFreteSaque                   T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
      vValeFreteUsuario                 T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE;
      vValeFreteAplicacao               T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE;
      vValeFreteRotaUsu                 T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE;
      vPodeAlterar                      Integer;
      vAcao                             Varchar2(20);
      V_IDOPER_CODIGO                   T_CON_FRETEOPER.CON_FRETEOPER_ID%TYPE;
      V_IDOPER_ROTA                     T_CON_FRETEOPER.CON_FRETEOPER_ROTA%TYPE;
      V_CIOTNUMERO                      T_CON_VFRETECIOT.CON_VFRETECIOT_NUMERO%TYPE;
      V_VIAGEM                          T_VGM_VIAGEM.VGM_VIAGEM_CODIGO%TYPE;
      V_VIAGEMROTA                      T_VGM_VIAGEM.GLB_ROTA_CODIGO%TYPE;
      V_STATUS                          CHAR(1);
      V_MESSAGE                         VARCHAR2(200);
      vExisteCiotValeFrete              Number;
      vVgmCiot                          T_VGM_VGCIOT%ROWTYPE;
      vCategoriaVF                      tdvadm.t_con_valefrete.con_catvalefrete_codigo%type;
      vVfFrota                          boolean := False;
      vOutrosNegativo                   char(1);
      vValorTransferencia               number := 14.00;
      vValorSaque                       number := 14.00;
      vValorAd                          NUMBER := 0;
      vTACETCEQP                        char(4);
      vMenorSaque                       number;
      vGeraTarifa                       char(1) := 'N';
      vForcaAtualizacao                 char(1) := 'N';
   BEGIN

-- VFNumero=nome=VFNumero|tipo=String|valor=895312*VFSerie=nome=VFSerie|tipo=String|valor=A1*VFRota=nome=VFRota|tipo=String|valor=903*VFSaque=nome=VFSaque|tipo=String|valor=1*VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=bbernardo*VFRotaUsuarioTDV=nome=VFRotaUsuarioTDV|tipo=String|valor=197*VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*VFVersaoAplicao=nome=VFVersaoAplicao|tipo=String|valor=16.1.14.0*


       /*****************************************************/
       /**************  VALORES INICIAIS   ******************/
       /*****************************************************/

       begin

         who_called_me2;
         vDescpedagio  := 'S';
         vValorPedagio := 0;

         SELECT COUNT(*)
           INTO vQtdeVerbas
           FROM T_CON_CALCVALEFRETETP DETP
          WHERE DETP.CON_CALCVALEFRETETP_ATIVO = 'S';


         P_STATUS   := tdvadm.pkg_glb_common.Status_Nomal;
         P_MESSAGE  := ' ';

       end;

       /*****************************************************/
       /**************  EXTRAINDO VALORES  ******************/
       /*****************************************************/

      vValeFreteNumero := trim(substr(TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFNumero','=','*'), 'valor', '=', '|'),1,7));
      If  nvl(vValeFreteNumero,'Sirlano') <> 'Sirlano' Then
          vValeFreteSerie     := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFSerie','=','*'), 'valor', '=', '|');
          vValeFreteRota      := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFRota','=','*'), 'valor', '=', '|');
          vValeFreteSaque     := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFSaque','=','*'), 'valor', '=', '|');
          vValeFreteUsuario   := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFUsuarioTDV','=','*'), 'valor', '=', '|');
          vValeFreteAplicacao := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFAplicacaoTDV','=','*'), 'valor', '=', '|');
          vValeFreteRotaUsu   := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|');
          vAcao               := trim(TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFAcao','=','*'), 'valor', '=', '|'));
          vCategoriaVF        := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFCategoria','=','*'), 'valor', '=', '|');
          vForcaAtualizacao   := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VPForcaAtualizacao','=','*'), 'valor', '=', '|');

     Else
          vValeFreteNumero    := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( P_QUERYSTR,'VFNumero' ));
          vValeFreteSerie     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( P_QUERYSTR,'VFSerie' ));
          vValeFreteRota      := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( P_QUERYSTR,'VFRota' ));
          vValeFreteSaque     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( P_QUERYSTR,'VFSaque' ));
          vValeFreteUsuario   := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFUsuarioTDV' ));
          vValeFreteAplicacao := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFAplicacaoTDV' );
          vValeFreteRotaUsu   := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFRotaUsuarioTDV' );
          vAcao               := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFAcao' ));
          vCategoriaVF        := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_CATVALEFRETE_CODIGO' );
      End If;


   if Not glbadm.pkg_listas.fn_get_usuparamtros(vValeFreteAplicacao,
                                                vValeFreteUsuario,
                                                vValeFreteRotaUsu,
                                                plistaparams) Then

      P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
      P_MESSAGE := P_MESSAGE || '10 - Erro ao Buscar Parametros.' || chr(10);
   End if ;



    begin
        vValorTransferencia := plistaparams('VLRTRANSF').numerico1;
     exception
       when NO_DATA_FOUND Then
         vValorTransferencia := 14.00;
       end;

    begin
        vValorSaque := plistaparams('VLRSAQUE').numerico1;
     exception
       when NO_DATA_FOUND Then
         vValorSaque := 14.00;
       end;
       

       if vAcao not in ('Salvar','Consulta') Then
          vAcao := 'Salvar';
       end if;

       vAcao := 'Salvar';


       /*****************************************************/
       /***   SE TIVER CIOT NÃO ALTERAMOS AS VERBAS       ***/
       /*****************************************************/

         SELECT COUNT(*)
           INTO vExisteCiot
           FROM T_CON_VFRETECIOT VC
          WHERE VC.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
            AND VC.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
            AND VC.GLB_ROTA_CODIGO         = vValeFreteRota
            AND VC.CON_VALEFRETE_SAQUE     = vValeFreteSaque
            AND VC.CON_VFRETECIOT_NUMERO   IS NOT NULL
            -- se flag imprime = S e que posso imprimir o Vale de Frete
            AND NVL(VC.CON_VFRETECIOT_FLAGIMPRIME,'S') = 'S';

       /*****************************************************/
       /** SE TIVER CIOT OU SOLICITAÇÃO DE CIOT            **/
       /*  NÃO ALTERAMOS AS VERBAS                         **/
       /*****************************************************/

         SELECT COUNT(*)
           INTO vExisteSolCiot
           FROM T_CON_VFRETESOLCIOT VS
          WHERE VS.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
            AND VS.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
            AND VS.GLB_ROTA_CODIGO         = vValeFreteRota
            AND VS.CON_VALEFRETE_SAQUE     = vValeFreteSaque;

       /*****************************************************/
       /** SE TIVER CIOT NÃO ALTERAMOS AS VERBAS           **/
       /*****************************************************/

          SELECT COUNT(*)
           INTO vExisteCiotVinc
           FROM T_CON_VFRETECIOT VC
          WHERE VC.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
            AND VC.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
            AND VC.GLB_ROTA_CODIGO         = vValeFreteRota
            AND VC.CON_VALEFRETE_SAQUE     = vValeFreteSaque
            AND VC.CON_VFRETECIOT_NUMERO   IS NOT NULL
            AND NVL(VC.CON_VFRETECIOT_FLAGIMPRIME,'S') = 'N';

       /*****************************************************/
       /**  ANALISE DE VERBAR NA AÇÃO Salvar               **/
       /*****************************************************/

       Begin

          if  vAcao = 'Salvar' then

              IF vExisteSolCiot > 0 THEN
                 P_STATUS   := tdvadm.pkg_glb_common.Status_Erro;
                 P_MESSAGE  := 'Vale frete ja possue solicitação de CIOT, impossivel atualizar verbas!';
              END IF;

              IF vExisteCiot > 0  THEN
                 P_STATUS   := tdvadm.pkg_glb_common.Status_Erro;
                 P_MESSAGE  := 'Vale frete ja possue CIOT, impossivel atualizar verbas!';
              END IF;

              if ( P_STATUS = pkg_glb_common.Status_Nomal ) and  ( vValeFreteNumero is not null ) Then

                  -- paga os dados do vale de Frete
                  begin

                     SELECT *
                       INTO vValeFrete
                     FROM T_CON_VALEFRETE VF
                     WHERE VF.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                       AND VF.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                       AND VF.GLB_ROTA_CODIGO         = vValeFreteRota
                       AND VF.CON_VALEFRETE_SAQUE     = vValeFreteSaque;
                  exception
                     When OTHERS Then
                        P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
                        P_MESSAGE := 'ERRO : Verifique o VF passado -' ||
                                      vValeFreteNumero || '-' ||
                                      vValeFreteSerie  || '-' ||
                                      vValeFreteRota   || '-' ||
                                      vValeFreteSaque  || '-' ||
                                      SQLERRM;
                  End;

              -- Vai Buscar os Dados do Proprietario
           BEGIN


              -- Verifica se o Outros Esta Negativo
              if nvl(vValeFrete.con_valefrete_outros,0) >= 0 Then
                 vOutrosNegativo := 'N';
              Else
                 vOutrosNegativo := 'S';
              End If;

             If substr(vValeFrete.Con_Valefrete_Placa,1,3) = '000' Then
              -- ver com a Diretoria qual sera o CNPJ a ser usado
                vProprietario := '61139432000172';
                vVfFrota      := true;
                vTACETCEQP    := 'ETCN';
             Else
                SELECT V.CAR_PROPRIETARIO_CGCCPFCODIGO
                   INTO vProprietario
                FROM T_CAR_VEICULO V
                WHERE V.CAR_VEICULO_PLACA = vValeFrete.Con_Valefrete_Placa
                  AND V.CAR_VEICULO_SAQUE = vValeFrete.Con_Valefrete_Placasaque;

                vVfFrota      := False;
                
                select p.car_proprietario_classantt || p.car_proprietario_classeqp
                  into vTACETCEQP
                from t_car_proprietario p
                where p.car_proprietario_cgccpfcodigo = vProprietario;
                 

             End If;

           EXCEPTION
             WHEN OTHERS THEN
                P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
                P_MESSAGE := 'ERRO : ' ||  SQLERRM;
           END;

             -- Criando a Tabela T_CON_CALCVALEFRETE
           IF(vValeFrete.con_valefrete_status = 'C') THEN

              UPDATE T_CON_CALCVALEFRETE DE
                SET DE.CON_CALCVALEFRETE_VALOR = 0
              WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque;
           ELSE
              if ( ( nvl(vValeFrete.Con_Valefrete_Impresso,'N') <> 'S' ) or ( vForcaAtualizacao = 'S' )) Then
                  SELECT COUNT(DISTINCT de.con_calcvalefretetp_codigo)
                    INTO vContador
                  FROM T_CON_CALCVALEFRETE DE
                  WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                    AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                    AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                    AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque;

                  IF vContador <> vQtdeVerbas THEN
                     delete T_CON_CALCVALEFRETE DE
                     WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                                  AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                                  AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                                  AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque;
                     INSERT INTO T_CON_CALCVALEFRETE DE
                     SELECT vValeFreteNumero,
                            vValeFreteSerie,
                            vValeFreteRota,
                            vValeFreteSaque,
                            ROWNUM,
                            'C',
                            0,
                            NULL,
                            NULL,
                            NULL,
                            decode(DETP.CON_CALCVALEFRETETP_TPPESDEF,'P',vProprietario,
                                                                     'M',vValeFrete.Con_Valefrete_Carreteiro,
                                                                     'O','61139432000172',
                                                                         '61139432000172'),
       --                     DECODE(DETP.CON_CALCVALEFRETETP_CODIGO,'02','M',
       --                                                            '05','O',
       --                                                                 'P'),
                            DETP.CON_CALCVALEFRETETP_TPPESDEF,
                            DETP.CON_CALCVALEFRETETP_FLAGPGDEF,
                            NULL,
                            DETP.CON_CALCVALEFRETETP_CODIGO,
                            'N',
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            100,
                            NULL,
                            NULL,
                            NULL,
                            Null,
                            Null,
                            Null,
                            Null,
                            null,
                            null,
                            null,
                            Null,
                            NULL,
                            NULL,
                            'N'
                     FROM T_CON_CALCVALEFRETETP DETP
                     WHERE DETP.CON_CALCVALEFRETETP_ATIVO = 'S'
                       AND 0 = (SELECT COUNT(*)
                                FROM T_CON_CALCVALEFRETE DE
                                WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                                  AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                                  AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                                  AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                                  AND DE.CON_CALCVALEFRETETP_CODIGO = DETP.CON_CALCVALEFRETETP_CODIGO)
                     ORDER BY DETP.CON_CALCVALEFRETETP_CODIGO;


                  END IF;

                  -- INICIALIZA A VARIAVEL
                  vFreteBruto := 0;


                    /***     NÃO É FROTA     ***/
                    if (vVfFrota = false) then


                        UPDATE T_CON_CALCVALEFRETE DE
                          SET  DE.CON_CALCVALEFRETE_VALOR = DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'00',vFreteBruto,
                                                                                                 '01',round((nvl(vValeFrete.con_valefrete_adiantamento,0) * (de.con_calcvalefrete_percdivsao / 100) ),2)  ,
                                                                                                 '02',nvl(vValeFrete.con_valefrete_pedagio,0),
                                                                                                 '03',nvl(vValeFrete.con_valefrete_multa,0),
                                                                                                 '04',nvl(vValeFrete.con_valefrete_outros,0),
                                                                                                 '10',nvl(vValeFrete.con_valefrete_irrf,0),
                                                                                                 '11',nvl(vValeFrete.con_valefrete_inss,0),
                                                                                                 '12',nvl(vValeFrete.con_valefrete_sestsenat,0),
                                                                                                 '13',0,
                                                                                                 '14',nvl(vValeFrete.con_valefrete_pis,0),
                                                                                                 '15',nvl(vValeFrete.con_valefrete_cofins,0),
                                                                                                 '16',nvl(vValeFrete.con_valefrete_csll,0),
                                                                                                 '20',round((nvl(vValeFrete.con_valefrete_valorliquido,0) * (de.con_calcvalefrete_percdivsao / 100) ),2)  ,
                                                                                                 0),
                               DE.CON_CALCVALEFRETE_VENCIMENTO = DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'20',TRUNC(nvl(vValeFrete.con_valefrete_dataprazomax,Sysdate) + 5),trunc(SYSDATE)),
                               DE.CON_CALCVALEFRETE_TIPO = 'C'
                        WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                          AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                          AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                          AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque;

                    /***     É UM FROTA      ***/
                    else



                       UPDATE T_CON_CALCVALEFRETE DE
                          SET DE.CON_CALCVALEFRETE_VALOR = DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'00',vFreteBruto,
                                                                                                '01',0,
                                                                                                '02',nvl(vValeFrete.con_valefrete_pedagio,0),
                                                                                                '03',nvl(vValeFrete.con_valefrete_multa,0),
                                                                                                '04',nvl(vValeFrete.con_valefrete_outros,0),
                                                                                                '10',nvl(vValeFrete.con_valefrete_irrf,0),
                                                                                                '11',nvl(vValeFrete.con_valefrete_inss,0),
                                                                                                '12',nvl(vValeFrete.con_valefrete_sestsenat,0),
                                                                                                '13',0,
                                                                                                '14',nvl(vValeFrete.con_valefrete_pis,0),
                                                                                                '15',nvl(vValeFrete.con_valefrete_cofins,0),
                                                                                                '16',nvl(vValeFrete.con_valefrete_csll,0),
                                                                                                '17',nvl(vValeFrete.con_valefrete_frete,0),
                                                                                                '20',round((nvl(vValeFrete.con_valefrete_valorliquido,0) * (de.con_calcvalefrete_percdivsao / 100) ),2)  ,
                                                                                                0),
                             DE.CON_CALCVALEFRETE_VENCIMENTO = DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'20',TRUNC(nvl(vValeFrete.con_valefrete_dataprazomax,Sysdate) + 5),trunc(SYSDATE)),
                             DE.CON_CALCVALEFRETE_TIPO       = 'C'
                     WHERE DE.CON_CONHECIMENTO_CODIGO        = vValeFreteNumero
                       AND DE.CON_CONHECIMENTO_SERIE         = vValeFreteSerie
                       AND DE.GLB_ROTA_CODIGO                = vValeFreteRota
                       AND DE.CON_VALEFRETE_SAQUE            = vValeFreteSaque;

                    end if;
                    
                    
                    -- Verifica o Que vai ser feito com a Transf/Saque
                    -- Pega o Valor da Transf/Saque
                    -- Faz somente para TAC ETC e Equiparados
                    if vTACETCEQP in ('TACS','ETCS') Then

                           Select min(vf.con_valefrete_saque)
                             into vMenorSaque
                           FROM T_CON_VALEFRETE vf
                           WHERE vf.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                             AND vf.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                             AND vf.GLB_ROTA_CODIGO         = vValeFreteRota
                             and vf.con_valefrete_placa     = vValeFrete.Con_Valefrete_Placa
--                             AND vf.CON_VALEFRETE_SAQUE     = ValeFreteSaque
                             and nvl(vf.con_valefrete_status,'N')    <> 'C';
                             
                             if ( nvl(vMenorSaque,vValeFreteSaque) = vValeFreteSaque ) Then
                               vGeraTarifa := 'S'; 
                             End If;
                             
                             if vValeFrete.Con_Catvalefrete_Codigo in ( 
--                                                                       '01',--'Uma Viagem
--                                                                       '02',--'Várias Viagens
                                                                       '03',--'Tombo
                                                                       '04',--'Reforço
                                                                       '05',--'Complemento
                                                                       '06',--'Transpesa
                                                                       '07',--'Remoção
                                                                       '08',--'Avulso (Despesa TDV)
--                                                                       '09',--'Avulso com CTRC
                                                                       '10',--'Serviço de Terceiro
                                                                       '11',--'Manifesto
                                                                       '12',--'Avulso Manifesto
                                                                       '13',--'Bônus  Manifesto
                                                                       '14',--'Bônus CTRC
                                                                       '15',--'Operação Coca-Cola
                                                                       '16',--'Viagem CTRC s/ Placa
                                                                       '17',--'Estadia
--                                                                       '18',--'Coleta
                                                                       '19'--'Operacoes Com CTRC
                                                 ) Then
                                vGeraTarifa := 'N';
                             End If;

                             -- Caso não tenha sido informado o Força Tarifa, segue o que o Sistema indicou.
                             vGeraTarifa := nvl(vValeFrete.Con_Valefrete_Forcatarifa,vGeraTarifa); 

                           -- Não e Frota e não teve cobranca anterior.
                        if ( (vVfFrota = false) and (vGeraTarifa = 'S') ) then

                           UPDATE T_CON_CALCVALEFRETE DE
                             set de.con_calcvalefrete_valor = vValorSaque
                           WHERE DE.CON_CONHECIMENTO_CODIGO        = vValeFreteNumero
                             AND DE.CON_CONHECIMENTO_SERIE         = vValeFreteSerie
                             AND DE.GLB_ROTA_CODIGO                = vValeFreteRota
                             AND DE.CON_VALEFRETE_SAQUE            = vValeFreteSaque
                             and DE.CON_CALCVALEFRETETP_CODIGO = '06';

                           /*desconta o pedagio do liquido só para os carreteiros*/

                              UPDATE T_CON_CALCVALEFRETE DE
                                SET DE.CON_CALCVALEFRETE_VALOR = DE.CON_CALCVALEFRETE_VALOR - vValorSaque
                              WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                                AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                                AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                                AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                                AND DE.CON_CALCVALEFRETETP_CODIGO IN ('01');
                      End If;
                        
                      If ( (vVfFrota = false) and (vGeraTarifa = 'S') )  then
                        
                                      
                         UPDATE T_CON_CALCVALEFRETE DE
                           set de.con_calcvalefrete_valor = vValorTransferencia
                         WHERE DE.CON_CONHECIMENTO_CODIGO        = vValeFreteNumero
                           AND DE.CON_CONHECIMENTO_SERIE         = vValeFreteSerie
                           AND DE.GLB_ROTA_CODIGO                = vValeFreteRota
                           AND DE.CON_VALEFRETE_SAQUE            = vValeFreteSaque
                           and DE.CON_CALCVALEFRETETP_CODIGO = '07';

     
                           /*desconta o pedagio do liquido só para os carreteiros*/

                            UPDATE T_CON_CALCVALEFRETE DE
                               SET DE.CON_CALCVALEFRETE_VALOR = DE.CON_CALCVALEFRETE_VALOR - vValorTransferencia
                            WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                              AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                              AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                              AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                              AND DE.CON_CALCVALEFRETETP_CODIGO IN ('01');

                      End If;
                    End If;
                    
                    

                        -- soma o valor do pedagio para desconto
                        select sum(nvl(de.con_calcvalefrete_valor,0))
                           into vValorPedagio
                        from T_CON_CALCVALEFRETE DE
                        WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                          AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                          AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                          AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                          and DE.CON_CALCVALEFRETETP_CODIGO = '02';

                        vValorPedagio := nvl(vValorPedagio,0);

                  /***   Desabilitei Pois o valor do Frota ***/
                  /*If substr(vProprietario,1,8) = '61139432' Then

                       UPDATE T_CON_CALCVALEFRETE DE
                         SET DE.CON_CALCVALEFRETE_VALOR    = 0
                       WHERE DE.CON_CONHECIMENTO_CODIGO    = vValeFreteNumero
                         AND DE.CON_CONHECIMENTO_SERIE     = vValeFreteSerie
                         AND DE.GLB_ROTA_CODIGO            = vValeFreteRota
                         AND DE.CON_VALEFRETE_SAQUE        = vValeFreteSaque
                         And DE.CON_CALCVALEFRETETP_CODIGO = '01';

                    End If;  */

                  if vDescpedagio = 'S' then

                       /*desconta o pedagio do liquido só para os carreteiros*/
                       if (vVfFrota = false) then

                         UPDATE T_CON_CALCVALEFRETE DE
                            SET DE.CON_CALCVALEFRETE_VALOR = DE.CON_CALCVALEFRETE_VALOR - vValorPedagio
                          WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                            AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                            AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                            AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                            AND DE.CON_CALCVALEFRETETP_CODIGO IN ('01');

                       end if;


                  end if;

                  SELECT SUM(NVL(DE.CON_CALCVALEFRETE_VALOR * (decode(de.con_calcvalefretetp_codigo||vOutrosNegativo,'04S',-1,1)) ,0))
                    INTO vFreteBruto
                  FROM T_CON_CALCVALEFRETE DE,
                       T_CON_CALCVALEFRETETP DETP
                  WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                    AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                    AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                    AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                    AND DE.CON_CALCVALEFRETETP_CODIGO = DETP.CON_CALCVALEFRETETP_CODIGO
                    AND DETP.CON_CALCVALEFRETETP_SOMA = 'S';

                  IF nvl(vValeFrete.con_valefrete_valorcomdesconto,0) > 0  THEN
                     vValorDesc := ( nvl(vValeFrete.con_valefrete_valorcomdesconto,0) - vValorPedagio ) - nvl(vValeFrete.con_valefrete_frete,0);
                  END IF;

                  UPDATE T_CON_CALCVALEFRETE DE
                     SET  DE.CON_CALCVALEFRETE_VALOR = NVL(DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'00',vFreteBruto,
                                                                                                     vValorDesc),0)
                  WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                    AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                    AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                    AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                    AND DE.CON_CALCVALEFRETETP_CODIGO IN ('00','05');

                  
                  select de.con_calcvalefrete_valor
                    into vValorAd
                  from T_CON_CALCVALEFRETE DE
                  WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                    AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                    AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                    AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                    AND DE.CON_CALCVALEFRETETP_CODIGO = '01';
                  -- Caso o Valor da Parcela fique negativo.
                  -- Jogo o Valor na Adiantamento
                  If vValorAd < 0 Then
                     vValorAd := abs(vValorAd); 
/*
                     update t_con_valefrete vf
                       set vf.con_valefrete_adiantamento = vf.con_valefrete_adiantamento + vValorAd,
                           vf.con_valefrete_valorliquido = vf.con_valefrete_valorliquido - vValorAd
                     WHERE vf.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                       AND vf.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                       AND vf.GLB_ROTA_CODIGO         = vValeFreteRota
                       AND vf.CON_VALEFRETE_SAQUE     = vValeFreteSaque;
*/
                     
                  update T_CON_CALCVALEFRETE DE
                    set de.con_calcvalefrete_valor = vValorAd
                  WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                    AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                    AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                    AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                    AND DE.CON_CALCVALEFRETETP_CODIGO = '01';
                     
                  update T_CON_CALCVALEFRETE DE
                    set de.con_calcvalefrete_valor = de.con_calcvalefrete_valor - vValorAd
                  WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                    AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                    AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                    AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                    AND DE.CON_CALCVALEFRETETP_CODIGO = '20';
                    
                  End If;
                  
               end If;

            END IF;

         END IF;


     end if;

   end;


       /*****************************************************/


       /*****************************************************/
       /**  RETORNANDO VALORES QRYSTR                       */
       /*****************************************************/

       begin

         SELECT COUNT(*)
           INTO vPodeAlterar
           FROM t_con_vfreteciot l
          WHERE l.con_conhecimento_codigo = vValeFreteNumero
            AND L.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
            AND L.GLB_ROTA_CODIGO         = vValeFreteRota
            AND L.CON_VALEFRETE_SAQUE     = vValeFreteSaque
            AND NVL(L.CON_VFRETECIOT_FLAGALTERA,'N') = 'S';


         IF vPodeAlterar > 0 THEN
            P_QUERYSTR := 'VFPodeAlterar=nome=VFPodeAlterar|tipo=String|valor=S*';

        ELSE
            P_QUERYSTR := 'VFPodeAlterar=nome=VFPodeAlterar|tipo=String|valor=N*';
         END IF;

         P_STATUS   := pkg_glb_common.Status_Nomal;
         P_MESSAGE  := ' ';

         P_QUERYSTR := P_QUERYSTR || 'P_STATUS=nome=P_STATUS|tipo=String|valor='   || trim(P_STATUS) || '*';
         P_QUERYSTR := P_QUERYSTR || 'P_MESSAGE=nome=P_MESSAGE|tipo=String|valor=' || trim(P_MESSAGE) || '*';

       end;

       /*****************************************************/


       /*****************************************************/
       /** RETORNANDO CURSOR COM OS VALORES                 */
       /*****************************************************/

       begin

         OPEN P_CURSOR FOR
          SELECT CVF.CON_CALCVALEFRETE_SEQ                                            SEQ,
                 substr(TP.CON_CALCVALEFRETETP_DESCRICAO,1,20)                        VERBA,
                 replace(replace(replace(to_char(CVF.CON_CALCVALEFRETE_VALOR,'999,999.99'),',','*'),'.',','),'*','.') VALOR,
                 replace(to_char(CVF.CON_CALCVALEFRETE_PERCDIVSAO,'999'),'.',',')     perc,
                 CVF.CON_CALCVALEFRETE_TPPESSOA                                       TP,
                 to_char(CVF.Con_Calcvalefrete_Dtliberacao,'dd/mm/yy')                Lib,
                 to_char(CVF.Con_Calcvalefrete_Dtpgto,'dd/mm/yy')                     pgto,
                 to_char(CVF.CON_CALCVALEFRETE_DTBLOQUEIO,'dd/mm/yy')                 BLOQ,
                 to_char(CVF.CON_CALCVALEFRETE_VENCIMENTO,'dd/mm/yy')                 venc,
                 TP.CON_CALCVALEFRETETP_TPVERBA                                       TPVERBA,
                 cvf.con_calcvalefrete_flaglib                                        liberada,
                 cvf.con_calcvalefrete_tipo                                           paga,
                 cvf.usu_usuario_codigoliberou                                        usulib,
                 cvf.usu_usuario_codigopgto                                           usupgto,
                 cvf.usu_usuario_bloqueou                                             usubloq,
                 cvf.con_calcvalefrete_dtpgto                                         dtpgto,
                 CVF.CON_CALCVALEFRETETP_CODIGO                                       CODPARTDV,
                 cvf.con_calcvalefrete_codparoper                                     CODPAROPER,
                 CVF.CON_CALCVALEFRETE_TIPO                                           TIPO,
                 cvf.con_calcvalefrete_flagpgto                                       flagpgto,
                 cvf.con_calcvalefrete_cancelada                                      Cancelada
          FROM T_CON_CALCVALEFRETE CVF,
               T_CON_CALCVALEFRETETP TP
          WHERE CVF.CON_CALCVALEFRETETP_CODIGO = TP.CON_CALCVALEFRETETP_CODIGO
            AND CVF.CON_CONHECIMENTO_CODIGO    = vValeFreteNumero
            AND CVF.CON_CONHECIMENTO_SERIE     = vValeFreteSerie
            AND CVF.GLB_ROTA_CODIGO            = vValeFreteRota
            AND CVF.CON_VALEFRETE_SAQUE        = vValeFreteSaque
            AND CVF.CON_CALCVALEFRETE_VALOR    <> 0
       ORDER BY CVF.CON_CALCVALEFRETETP_CODIGO;


     end;

       /*****************************************************/



  END SP_CON_ATUCALCVALEFRETE;

   PROCEDURE SP_CON_ATUCALCVALEFRETEGER(P_QUERYSTR      IN OUT  Varchar2,
                                        P_STATUS        OUT CHAR,
                                        P_MESSAGE       OUT VARCHAR2,
                                        P_CURSOR        OUT PKG_GLB_COMMON.T_CURSOR) AS

      vValeFrete                        TDVADM.T_CON_VALEFRETE%ROWTYPE;
      vContador                         NUMBER;
      vQtdeVerbas                       NUMBER;
      vFreteBruto                       NUMBER;
      vValorDesc                        NUMBER;
      vProprietario                     tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%TYPE;
      vExisteCiot                       INTEGER;
      vExisteSolCiot                    INTEGER;
      vDescpedagio                      char(1) := 'S';
      vValorPedagio                     number  := 0;
      V_IDOPER_CODIGO                   T_CON_FRETEOPER.CON_FRETEOPER_ID%TYPE;
      V_IDOPER_ROTA                     T_CON_FRETEOPER.CON_FRETEOPER_ROTA%TYPE;
      V_CIOTNUMERO                      T_CON_VFRETECIOT.CON_VFRETECIOT_NUMERO%TYPE;
      V_VIAGEM                          T_VGM_VIAGEM.VGM_VIAGEM_CODIGO%TYPE;
      V_VIAGEMROTA                      T_VGM_VIAGEM.GLB_ROTA_CODIGO%TYPE;
      V_STATUS                          CHAR(1);
      V_MESSAGE                         VARCHAR2(200);
      vExisteCiotValeFrete              INTEGER;
      vVgmCiot                          T_VGM_VGCIOT%ROWTYPE;
      vValeFreteNumero                  T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE;
      vValeFreteSerie                   T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE;
      vValeFreteRota                    T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE;
      vValeFreteSaque                   T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
      vValeFreteUsuario                 T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE;
      vValeFreteAplicacao               T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE;
      vValeFreteRotaUsu                 T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE;
      vPodeAlterar                      INTEGER;
      vMessagem                         varchar2(32000);
      vOutrosNegativo                   char(1);
   BEGIN


       --INSERT INTO dropme(x,a) VALUES (P_QUERYSTR,'klayton'||SYSDATE);

       /**********************************************************/
       /**************  EXTRAINDO VALORES  ***********************/
       /**********************************************************/

       BEGIN
         who_called_me2;
         vDescpedagio := 'S';
         vValorPedagio := 0;
         SELECT COUNT(*)
           INTO vQtdeVerbas
         FROM T_CON_CALCVALEFRETETP DETP
         WHERE DETP.CON_CALCVALEFRETETP_ATIVO = 'S';

         P_STATUS   := tdvadm.pkg_glb_common.Status_Nomal;
         P_MESSAGE  := 'Processado com Sucesso';
       END;

       /**********************************************************/


       /**********************************************************/
       /**************  EXTRAINDO VALORES  ***********************/
       /**********************************************************/

       BEGIN
           vValeFreteNumero      := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFNumero','=','*'), 'valor', '=', '|');
           vValeFreteSerie       := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFSerie','=','*'), 'valor', '=', '|');
           vValeFreteRota        := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFRota','=','*'), 'valor', '=', '|');
           vValeFreteSaque       := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFSaque','=','*'), 'valor', '=', '|');
           vValeFreteUsuario     := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFUsuarioTDV','=','*'), 'valor', '=', '|');
           vValeFreteAplicacao   := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFAplicacaoTDV','=','*'), 'valor', '=', '|');
           vValeFreteRotaUsu     := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|');
       END;

       /**********************************************************/



       /**********************************************************/
       /***   SE TIVER CIOT NÃO ALTERAMOS AS VERBAS       ********/
       /**********************************************************/

       BEGIN
         SELECT COUNT(*)
           INTO vExisteCiot
           FROM T_CON_VFRETECIOT VC
          WHERE VC.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
            AND VC.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
            AND VC.GLB_ROTA_CODIGO         = vValeFreteRota
            AND VC.CON_VALEFRETE_SAQUE     = vValeFreteSaque
            AND VC.CON_VFRETECIOT_NUMERO   IS NOT NULL
            AND NVL(VC.CON_VFRETECIOT_FLAGIMPRIME,'S') = 'S';

         IF vExisteCiot > 0 THEN
            P_STATUS   := tdvadm.pkg_glb_common.Status_Erro;
            P_MESSAGE  := 'Vale frete ja possue CIOT, impossivel atualizar verbas!';
         END IF;

       END;

       /**********************************************************/


       /**********************************************************/
       /** SE TIVER SOLICITAÇÃO DE CIOT NÃO ALTERAMOS AS VERBAS **/
       /**********************************************************/

       BEGIN
         SELECT COUNT(*)
           INTO vExisteSolCiot
           FROM T_CON_VFRETESOLCIOT VS
          WHERE VS.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
            AND VS.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
            AND VS.GLB_ROTA_CODIGO         = vValeFreteRota
            AND VS.CON_VALEFRETE_SAQUE     = vValeFreteSaque;

         IF vExisteSolCiot > 0 THEN
            P_STATUS   := tdvadm.pkg_glb_common.Status_Erro;
            P_MESSAGE  := 'Vale frete ja possue solicitação de CIOT, impossivel atualizar verbas!';
         END IF;

       END;

       /**********************************************************/


       /**********************************************************/
       /**        Buscando o CIOT para Reaproveitamento         **/
       /**********************************************************/

       BEGIN

           if vValeFreteUsuario = 'jsantosv' then

              vMessagem :=

                           'vValeFreteAplicacao='||vValeFreteAplicacao||
                           ' vValeFreteUsuario=  '||vValeFreteUsuario  ||
                           ' vValeFreteRotaUsu=  '||vValeFreteRotaUsu  ||
                           ' vValeFreteNumero=   '||vValeFreteNumero   ||
                           ' vValeFreteSerie=    '||vValeFreteSerie    ||
                           ' vValeFreteRota=     '||vValeFreteRota     ||
                           ' vValeFreteSaque=   '||vValeFreteSaque;

               -- raise_application_error(-20001,vMessagem);
            -- end if;

           SP_GETIDVALIDOALT(vValeFreteAplicacao,
                             vValeFreteUsuario  ,
                             vValeFreteRotaUsu  ,
                             vValeFreteNumero   ,
                             vValeFreteSerie    ,
                             vValeFreteRota     ,
                             vValeFreteSaque    ,
                             V_IDOPER_CODIGO    ,
                             V_IDOPER_ROTA      ,
                             V_CIOTNUMERO       ,
                             V_VIAGEM           ,
                             V_VIAGEMROTA       ,
                             V_STATUS           ,
                             V_MESSAGE);

           IF V_CIOTNUMERO IS NOT NULL THEN

               SELECT COUNT(*)
                 INTO vExisteCiotValeFrete
                 FROM T_CON_VFRETECIOT CIOT
                WHERE CIOT.CON_CONHECIMENTO_CODIGO  = vValeFreteNumero
                  AND CIOT.CON_CONHECIMENTO_SERIE   = vValeFreteSerie
                  AND CIOT.GLB_ROTA_CODIGO          = vValeFreteRota
                  AND CIOT.CON_VALEFRETE_SAQUE      = vValeFreteSaque
                  AND CIOT.CON_VFRETECIOT_NUMERO IS NOT NULL;

               IF vExisteCiotValeFrete = 0 THEN


                  SELECT *
                     INTO vVgmCiot
                    FROM T_VGM_VGCIOT L
                    WHERE L.GLB_ROTA_CODIGO   = V_VIAGEMROTA
                      AND L.VGM_VIAGEM_CODIGO = V_VIAGEM;


                  INSERT INTO T_CON_VFRETECIOT(CON_CONHECIMENTO_CODIGO     ,
                                               CON_CONHECIMENTO_SERIE      ,
                                               GLB_ROTA_CODIGO             ,
                                               CON_VALEFRETE_SAQUE         ,
                                               CON_VFRETECIOT_NUMERO       ,
                                               CON_VFRETECIOT_PROTOCOLO    ,
                                               CON_FRETEOPER_ID            ,
                                               CON_FRETEOPER_ROTA          ,
                                               CON_VFRETECIOT_ID           ,
                                               CON_VFRETECIOT_IDCLIENTE    ,
                                               CON_VFRETECIOT_TPPAGAMENTO  ,
                                               CON_VFRETECIOT_FLAGCANCEL   ,
                                               CON_VFRETECIOT_DATA         ,
                                               CON_VFRETECIOT_FLAGIMPRIME  ,
                                               CON_VFRETECIOT_FLAGALTERA   ,
                                               CON_VFRETECIOT_FLAGPROCESAL)
                                       VALUES (vValeFreteNumero         ,
                                               vValeFreteSerie          ,
                                               vValeFreteRota           ,
                                               vValeFreteSaque          ,
                                               vVgmCiot.Vgm_Vgciot_Numero  ,
                                               vVgmCiot.Vgm_Vgciot_Protocolo,
                                               vVgmCiot.Con_Freteoper_Id   ,
                                               vVgmCiot.Con_Freteoper_Rota ,
                                               vVgmCiot.Vgm_Vgciot_Id      ,
                                               vVgmCiot.Vgm_Vgciot_Idcliente,
                                               vVgmCiot.Vgm_Vgciot_Tppagamento,
                                               vVgmCiot.Vgm_Vgciot_Flagcancel,
                                               vVgmCiot.Vgm_Vgciot_Data,
                                               'N',
                                               'S',
                                               'N');

               END IF;

           END IF;

         end if;


       END;

       /**********************************************************/



       Begin
         -- paga os dados do vale de Frete
         SELECT *
           INTO vValeFrete
         FROM T_CON_VALEFRETE VF
         WHERE VF.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
           AND VF.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
           AND VF.GLB_ROTA_CODIGO         = vValeFreteRota
           AND VF.CON_VALEFRETE_SAQUE     = vValeFreteSaque;
           -- Vai Buscar os Dados do Proprietario
          If substr(vValeFrete.Con_Valefrete_Placa,1,3) = '000' Then
              -- ver com a Diretoria qual sera o CNPJ a ser usado
              vProprietario := '61139432000172';
          Else
              SELECT V.CAR_PROPRIETARIO_CGCCPFCODIGO
                 INTO vProprietario
              FROM T_CAR_VEICULO V
              WHERE V.CAR_VEICULO_PLACA = vValeFrete.Con_Valefrete_Placa
                AND V.CAR_VEICULO_SAQUE = vValeFrete.Con_Valefrete_Placasaque;
          End If;
       EXCEPTION
          WHEN OTHERS THEN
             P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
             P_MESSAGE := 'ERRO : ' ||  SQLERRM;
       END;

              if vValeFrete.con_valefrete_outros >= 0 Then
                 vOutrosNegativo := 'N';
              Else
                 vOutrosNegativo := 'S';
              End If;

       IF P_STATUS = tdvadm.pkg_glb_common.Status_Nomal THEN
             IF(vValeFrete.con_valefrete_status = 'C') THEN
               UPDATE T_CON_CALCVALEFRETE DE
                 SET DE.CON_CALCVALEFRETE_VALOR = 0
               WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                 AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                 AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                 AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque;
             ELSE
               SELECT COUNT(DISTINCT de.con_calcvalefretetp_codigo)
                 INTO vContador
               FROM T_CON_CALCVALEFRETE DE
               WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                 AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                 AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                 AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque;

               IF vContador <> vQtdeVerbas THEN
                   INSERT INTO T_CON_CALCVALEFRETE DE
                   SELECT vValeFreteNumero,
                          vValeFreteSerie,
                          vValeFreteRota,
                          vValeFreteSaque,
                          ROWNUM,
                          'C',
                          0,
                          NULL,
                          NULL,
                          NULL,
                          decode(DETP.CON_CALCVALEFRETETP_TPPESDEF,'P',vProprietario,
                                                                   'M',vValeFrete.Con_Valefrete_Carreteiro,
                                                                   'O','61139432000172',
                                                                       '61139432000172'),
 --                         DECODE(DETP.CON_CALCVALEFRETETP_CODIGO,'02','M',
 --                                                                '05','O',
 --                                                                     'P'),
                          DETP.CON_CALCVALEFRETETP_TPPESDEF,
                          DETP.CON_CALCVALEFRETETP_FLAGPGDEF,
                          NULL,
                          DETP.CON_CALCVALEFRETETP_CODIGO,
                          'N',
                          NULL,
                          NULL,
                          NULL,
                          NULL,
                          NULL,
                          100,
                          NULL,
                          NULL,
                          NULL,
                          Null,
                          Null,
                          Null,
                          Null,
                          null,
                          null,
                          null,
                          Null,
                          Null,
                          Null,
                          'N'
                   FROM T_CON_CALCVALEFRETETP DETP
                   WHERE DETP.CON_CALCVALEFRETETP_ATIVO = 'S'
                     AND 0 = (SELECT COUNT(*)
                              FROM T_CON_CALCVALEFRETE DE
                              WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                                AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                                AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                                AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                                AND DE.CON_CALCVALEFRETETP_CODIGO = DETP.CON_CALCVALEFRETETP_CODIGO)
                   ORDER BY DETP.CON_CALCVALEFRETETP_CODIGO;


                END IF;

           /*                 con_valefrete_avaria ,
                            con_valefrete_valorcomdesconto ,
                            con_valefrete_custocarreteiro,
                            con_valefrete_valorestiva ,
                            con_valefrete_frete ,
                            con_valefrete_enlonamento ,
                            con_valefrete_estadia
           */


                -- INICIALIZA A VARIAVEL
                vFreteBruto := 0;
                UPDATE T_CON_CALCVALEFRETE DE
                  SET  DE.CON_CALCVALEFRETE_VALOR = DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'00',vFreteBruto,
                                                                                         '01',round((nvl(vValeFrete.con_valefrete_adiantamento,0) * (de.con_calcvalefrete_percdivsao / 100) ),2)  ,
                                                                                         '02',nvl(vValeFrete.con_valefrete_pedagio,0),
                                                                                         '03',nvl(vValeFrete.con_valefrete_multa,0),
                                                                                         '04',nvl(vValeFrete.con_valefrete_outros,0),
                                                                                         '10',nvl(vValeFrete.con_valefrete_irrf,0),
                                                                                         '11',nvl(vValeFrete.con_valefrete_inss,0),
                                                                                         '12',nvl(vValeFrete.con_valefrete_sestsenat,0),
                                                                                         '13',0,
                                                                                         '14',nvl(vValeFrete.con_valefrete_pis,0),
                                                                                         '15',nvl(vValeFrete.con_valefrete_cofins,0),
                                                                                         '16',nvl(vValeFrete.con_valefrete_csll,0),
                                                                                         '20',round((nvl(vValeFrete.con_valefrete_valorliquido,0) * (de.con_calcvalefrete_percdivsao / 100) ),2)  ,
                                                                                         0),
                       DE.CON_CALCVALEFRETE_VENCIMENTO = DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'20',TRUNC(vValeFrete.con_valefrete_dataprazomax + 5),trunc(SYSDATE)),
                       DE.CON_CALCVALEFRETE_TIPO = 'C'
                WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                  AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                  AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                  AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque ;
                -- soma o valor do pedagio para desconto
                select sum(nvl(de.con_calcvalefrete_valor,0))
                  into vValorPedagio
                from T_CON_CALCVALEFRETE DE
                WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                  AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                  AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                  AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                  and DE.CON_CALCVALEFRETETP_CODIGO = '02';

                If substr(vProprietario,1,8) = '61139432' Then
                   UPDATE T_CON_CALCVALEFRETE DE
                     SET DE.CON_CALCVALEFRETE_VALOR = 0
                   WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                     AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                     AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                     AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                     And DE.CON_CALCVALEFRETETP_CODIGO = '01';
                End If;

              if vDescpedagio = 'S' then
                -- desconta o pedagio do liquido
                UPDATE T_CON_CALCVALEFRETE DE
                  SET  DE.CON_CALCVALEFRETE_VALOR = DE.CON_CALCVALEFRETE_VALOR - vValorPedagio
                WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                  AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                  AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                  AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                  AND DE.CON_CALCVALEFRETETP_CODIGO IN ('01');

              end if;

                SELECT SUM(NVL(DE.CON_CALCVALEFRETE_VALOR  * (decode(de.con_calcvalefretetp_codigo||vOutrosNegativo,'04S',-1,1)) ,0))
                  INTO vFreteBruto
                FROM T_CON_CALCVALEFRETE DE,
                     T_CON_CALCVALEFRETETP DETP
                WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                  AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                  AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                  AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                  AND DE.CON_CALCVALEFRETETP_CODIGO = DETP.CON_CALCVALEFRETETP_CODIGO
 --                 AND DE.CON_CALCVALEFRETE_FLAGPGTO = 'S'
                  AND DETP.CON_CALCVALEFRETETP_SOMA = 'S';

                IF nvl(vValeFrete.con_valefrete_valorcomdesconto,0) > 0  THEN
                   vValorDesc :=  ( nvl(vValeFrete.con_valefrete_valorcomdesconto,0) - vValorPedagio ) - nvl(vValeFrete.con_valefrete_frete,0);
                END IF;

                UPDATE T_CON_CALCVALEFRETE DE
                  SET  DE.CON_CALCVALEFRETE_VALOR = NVL(DECODE(DE.CON_CALCVALEFRETETP_CODIGO,'00',vFreteBruto,
                                                                                              vValorDesc),0)
                WHERE DE.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                  AND DE.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                  AND DE.GLB_ROTA_CODIGO         = vValeFreteRota
                  AND DE.CON_VALEFRETE_SAQUE     = vValeFreteSaque
                  AND DE.CON_CALCVALEFRETETP_CODIGO IN ('00','05');

             END IF;
       END IF;

     OPEN P_CURSOR FOR
      SELECT CVF.CON_CALCVALEFRETE_SEQ SEQ,
             substr(TP.CON_CALCVALEFRETETP_DESCRICAO,1,20) VERBA,
 --            TP.CON_CALCVALEFRETETP_TPLANC LANC,
             replace(replace(replace(to_char(CVF.CON_CALCVALEFRETE_VALOR,'999,999.99'),',','*'),'.',','),'*','.') VALOR,
             replace(to_char(CVF.CON_CALCVALEFRETE_PERCDIVSAO,'999'),'.',',') perc,
             CVF.CON_CALCVALEFRETE_TPPESSOA TP,
             to_char(CVF.Con_Calcvalefrete_Dtliberacao,'dd/mm/yy') Lib,
             to_char(CVF.Con_Calcvalefrete_Dtpgto,'dd/mm/yy') pgto,
             to_char(CVF.CON_CALCVALEFRETE_DTBLOQUEIO,'dd/mm/yy') BLOQ,
             to_char(CVF.CON_CALCVALEFRETE_VENCIMENTO,'dd/mm/yy') venc,
             TP.CON_CALCVALEFRETETP_TPVERBA TPVERBA,
             cvf.con_calcvalefrete_flaglib liberada,
             cvf.con_calcvalefrete_tipo paga,
             cvf.usu_usuario_codigoliberou usulib,
             cvf.usu_usuario_codigopgto usupgto,
             cvf.usu_usuario_bloqueou usubloq,
             cvf.con_calcvalefrete_dtpgto dtpgto,
             CVF.CON_CALCVALEFRETETP_CODIGO CODPARTDV,
             cvf.con_calcvalefrete_codparoper  CODPAROPER,
             CVF.CON_CALCVALEFRETE_TIPO TIPO,
             cvf.con_calcvalefrete_flagpgto flagpgto,
             cvf.con_calcvalefrete_cancelada  Cancelada
      FROM T_CON_CALCVALEFRETE CVF,
           T_CON_CALCVALEFRETETP TP
      WHERE CVF.CON_CALCVALEFRETETP_CODIGO = TP.CON_CALCVALEFRETETP_CODIGO
        AND CVF.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
        AND CVF.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
        AND CVF.GLB_ROTA_CODIGO         = vValeFreteRota
        AND CVF.CON_VALEFRETE_SAQUE     = vValeFreteSaque
        AND CVF.CON_CALCVALEFRETE_VALOR <> 0
        ORDER BY CVF.CON_CALCVALEFRETETP_CODIGO;


       SELECT COUNT(*)
         INTO vPodeAlterar
         FROM t_con_vfreteciot l
        WHERE l.con_conhecimento_codigo = vValeFreteNumero
          AND L.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
          AND L.GLB_ROTA_CODIGO         = vValeFreteRota
          AND L.CON_VALEFRETE_SAQUE     = vValeFreteSaque
          AND NVL(L.CON_VFRETECIOT_FLAGALTERA,'N') = 'S';



      IF vPodeAlterar > 0 THEN
         P_QUERYSTR := 'VFPodeAlterar=nome=VFPodeAlterar|tipo=String|valor=S*';

     ELSE
         P_QUERYSTR := 'VFPodeAlterar=nome=VFPodeAlterar|tipo=String|valor=N*';
      END IF;

   END SP_CON_ATUCALCVALEFRETEGER;

   PROCEDURE SP_CON_RATEIACALCVALEFRETE(P_CON_VALEFRETE IN T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                                        P_CON_SERIE     IN T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                                        P_CON_ROTA      IN T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                                        P_CON_SAQUE     IN T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                                        P_USUARIO       IN T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                        P_ROTAUSUARIO   IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                        P_TPCALCULO     IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETETP_CODIGO%TYPE,
                                        P_PERCENTUAL    IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETE_PERCDIVSAO%TYPE,
                                        P_CNPJ          IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETE_CNPJCPF%TYPE,
                                        P_TPPESSOA      IN T_CON_CALCVALEFRETE.CON_CALCVALEFRETE_TPPESSOA%TYPE,
                                        P_STATUS        OUT CHAR,
                                        P_MESSAGE       OUT VARCHAR2) AS

      vTpArqCalc   TDVADM.T_CON_CALCVALEFRETE%ROWTYPE;
      vTpArqCalcTP TDVADM.T_CON_CALCVALEFRETETP%ROWTYPE;
      vSequencia   TDVADM.T_CON_CALCVALEFRETE.CON_CALCVALEFRETE_SEQ%TYPE;
   BEGIN

   -- VERIFICA SE REALMENTE PODE FAZER O RATEIO
   BEGIN
       SELECT *
         INTO vTpArqCalc
       FROM T_CON_CALCVALEFRETE CVF
       WHERE CVF.CON_CONHECIMENTO_CODIGO    = P_CON_VALEFRETE
         AND CVF.CON_CONHECIMENTO_SERIE     = P_CON_SERIE
         AND CVF.GLB_ROTA_CODIGO            = P_CON_ROTA
         AND CVF.CON_VALEFRETE_SAQUE        = P_CON_SAQUE
         AND CVF.CON_CALCVALEFRETETP_CODIGO = P_TPCALCULO;
       SELECT *
         INTO vTpArqCalcTP
       FROM T_CON_CALCVALEFRETETP  TP
       WHERE TP.CON_CALCVALEFRETETP_CODIGO = vTpArqCalc.Con_Calcvalefretetp_Codigo;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       P_STATUS   := tdvadm.pkg_glb_common.Status_Erro;
       P_MESSAGE  := 'Registro não Encontrado';
     WHEN OTHERS THEN
       P_STATUS   := tdvadm.pkg_glb_common.Status_Erro;
       P_MESSAGE  := 'Houve algum problema na busca ' || chr(10) ||  Sqlerrm ;
    END;

   IF    vTpArqCalcTP.Con_Calcvalefretetp_Tpverba <> 'PA' THEN
       P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
       P_MESSAGE := 'Esta Verba não é uma Parcela';
   ELSIF P_PERCENTUAL > 0 AND P_PERCENTUAL < 100 THEN
       P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
       P_MESSAGE := 'Percentual Invalida para Rateio';
   ELSIF vTpArqCalc.Con_Calcvalefrete_Percdivsao <> 100 THEN
       P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
       P_MESSAGE := 'Parcela Ja Foi Rateada ' || chr(10) ||  Sqlerrm ;
   ELSIF vTpArqCalc.Usu_Usuario_Codigoliberou <> '' THEN
       P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
       P_MESSAGE := 'Parcela Ja Autorizada, Favor Desbloquear antes';
   ELSIF vTpArqCalc.Usu_Usuario_Codigopgto <> '' THEN
       P_STATUS  := tdvadm.pkg_glb_common.Status_Erro;
       P_MESSAGE := 'Parcela Ja Paga, Impossivel Prosseguir';
    ELSE
      UPDATE T_CON_CALCVALEFRETE CVF
        SET CVF.CON_CALCVALEFRETE_PERCDIVSAO = P_PERCENTUAL
      WHERE CVF.CON_CONHECIMENTO_CODIGO      = P_CON_VALEFRETE
        AND CVF.CON_CONHECIMENTO_SERIE       = P_CON_SERIE
        AND CVF.GLB_ROTA_CODIGO              = P_CON_ROTA
        AND CVF.CON_VALEFRETE_SAQUE          = P_CON_SAQUE
        AND CVF.CON_CALCVALEFRETETP_CODIGO   = P_TPCALCULO;
      -- PAGA A MAIOR SEQUENCIA
      SELECT MAX(CVF.CON_CALCVALEFRETE_SEQ) + 1
         INTO vTpArqCalc.Con_Calcvalefrete_Seq
      FROM T_CON_CALCVALEFRETE CVF
      WHERE CVF.CON_CONHECIMENTO_CODIGO      = P_CON_VALEFRETE
        AND CVF.CON_CONHECIMENTO_SERIE       = P_CON_SERIE
        AND CVF.GLB_ROTA_CODIGO              = P_CON_ROTA
        AND CVF.CON_VALEFRETE_SAQUE          = P_CON_SAQUE;

        vTpArqCalc.Con_Calcvalefrete_Cnpjcpf    := P_CNPJ;
        vTpArqCalc.Con_Calcvalefrete_Tppessoa   := P_TPPESSOA;
        vTpArqCalc.Con_Calcvalefrete_Percdivsao := 100 - P_PERCENTUAL;

        INSERT INTO T_CON_CALCVALEFRETE
        VALUES vTpArqCalc;
        COMMIT;
        P_STATUS  := tdvadm.pkg_glb_common.Status_Nomal;

   END IF;

   END SP_CON_RATEIACALCVALEFRETE;

   PROCEDURE SP_GET_IDINTEGRACAODRU(P_referencia IN CHAR) AS
      v_QryStr   CLOB;
      p_idconsulta Varchar2(100);
      p_status     Varchar2(100);
      p_message    VARCHAR2(100);
   BEGIN


      FOR R_CURSOR IN(SELECT TRIM('IntegraTdv_Cod=nome=IntegraTdv_Cod|tipo=String|valor=19*') ||
                             TRIM('Proprietario=nome=Proprietario|tipo=String|valor=' || TRIM(p.car_proprietario_cgccpfcodigo) || '*') ||
                             TRIM('PropRntrc=nome=PropRntrc|tipo=String|valor=' || TRIM(p.car_proprietario_rntrc)  || '*') ||
                             TRIM('Atualiza_Rntrc=nome=Atualiza_Rntrc|tipo=String|valor=S*') Query
                      FROM t_car_proprietario p
                      WHERE p.car_proprietario_rntrc IS NOT NULL
 --                       AND trunc(p.car_proprietario_classdt) < trunc(SYSDATE)
 --                       AND p.car_proprietario_rntrcdtval IS NOT NULL
                        AND 0 = (SELECT COUNT(*)
                                 FROM T_CON_FRETEOPER t
                                 WHERE t.con_freteoper_rota = 999
                                   AND t.cfe_integratdv_cod = 19
                                   AND t.cfe_operacoes_cod = 16
                                   AND nvl(INSTR(t.con_freteoper_msgenv,TRIM(p.car_proprietario_cgccpfcodigo)),0) > 0
                                   AND TRUNC(t.con_freteoper_dtcad) >= trunc(SYSDATE-1))

                        AND p.car_proprntrcst_codigo = '98'
                        AND 0 < (SELECT COUNT(*)
                                 FROM T_CON_VALEFRETE VF,
                                      T_CAR_VEICULO V
                                 WHERE 0 = 0
                                   AND to_char(VF.CON_VALEFRETE_DATACADASTRO,'yyyymmdd') >= P_referencia || '01'
                                   AND VF.CON_VALEFRETE_PLACA = V.CAR_VEICULO_PLACA
                                   AND VF.CON_VALEFRETE_PLACASAQUE = V.CAR_VEICULO_SAQUE
                                   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO = P.CAR_PROPRIETARIO_CGCCPFCODIGO)
                       )
       LOOP


          dbms_lock.sleep(5);
          v_QryStr := R_CURSOR.Query;
          pkg_cfe_frete.SP_GET_IDINTEGRACAO(v_QryStr,'999',p_idconsulta,P_STATUS,P_MESSAGE);



       END LOOP;

   END SP_GET_IDINTEGRACAODRU;

   procedure sp_con_InsereVFTContaCorrente(p_vfnumero  in t_con_valefrete.con_conhecimento_codigo%type,
                                           p_vfserie   in t_con_valefrete.con_conhecimento_serie%type,
                                           p_vfrota    in t_con_valefrete.glb_rota_codigo%type,
                                           p_vfsaque   in t_con_valefrete.con_valefrete_saque%type,
                                           p_Usuario     in t_con_valefrete.usu_usuario_codigo%type,
                                           p_RotaUsuario in t_con_valefrete.glb_rota_codigo%type,
                                           p_status   out char,
                                           p_message  out varchar2) as
     vXmlDeb       clob;
     vAuxiliar     number;
     vTpValeFrete  tdvadm.t_con_valefrete%rowtype;
     vValorDeb     number;
     vProprietario tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type;
     vCarreteiroSq tdvadm.t_car_carreteiro.car_carreteiro_saque%type;

   Begin
      p_status  := pkg_glb_common.Status_Nomal;
      p_message := '';
      vXmlDeb   := empty_clob();
      vAuxiliar := 0;
      Begin
          select *
            into vTpValeFrete
          from t_con_valefrete vf
          where vf.con_conhecimento_codigo = p_vfnumero
            and vf.con_conhecimento_serie  = p_vfserie
            and vf.glb_rota_codigo         = p_vfrota
            and vf.con_valefrete_saque     = p_vfsaque;
      Exception
        When NO_DATA_FOUND Then
           p_status  := pkg_glb_common.Status_Erro;
           p_message := 'Vale de frete não encontrado';

       End ;

      if p_status = pkg_glb_common.Status_Nomal Then
         if vTpValeFrete.Con_Catvalefrete_Codigo = CatTServicoTerceiro Then
            If substr(vTpValeFrete.Con_Valefrete_Placa,1,3) = '000' then
               p_status  := pkg_glb_common.Status_Erro;
               p_message := 'Vale de frete De Frota, sera gerado Titulo';
            Else


               If upper(vTpValeFrete.Con_Valefrete_Tipocusto) = 'T' Then
                  vValorDeb := ( ( ( vTpValeFrete.Con_Valefrete_Custocarreteiro  * vTpValeFrete.Con_Valefrete_Pesocobrado) - vTpValeFrete.Con_Valefrete_Pedagio ) * 0.08);
               Else
                  vValorDeb := (( vTpValeFrete.Con_Valefrete_Custocarreteiro - vTpValeFrete.Con_Valefrete_Pedagio ) * 0.08 );
               End if;

               Begin 
               Select v.car_proprietario_cgccpfcodigo,
                      ca.car_carreteiro_saque
                  Into vProprietario,
                       vCarreteiroSq
               From t_car_veiculo v,
                    t_car_carreteiro ca
               Where v.car_veiculo_placa = vTpValeFrete.Con_Valefrete_Placa
                 And v.car_veiculo_saque = vTpValeFrete.Con_Valefrete_Placasaque
                 And v.car_veiculo_placa = ca.car_veiculo_placa
                 And v.car_veiculo_saque = ca.car_veiculo_saque
                 And ca.car_carreteiro_cpfcodigo = vTpValeFrete.Con_Valefrete_Carreteiro
                 And ca.car_carreteiro_saque = (Select Max(ca1.car_carreteiro_saque)
                                                From t_car_carreteiro ca1
                                                Where ca1.car_carreteiro_cpfcodigo = ca.car_carreteiro_cpfcodigo
                                                  And ca1.car_veiculo_placa = ca.car_veiculo_placa
                                                  And ca1.car_veiculo_saque = ca.car_veiculo_saque);
               exception
                 When NO_DATA_FOUND Then
                    dbms_output.put_line('Erro Inserindo Conta Corrente ' || vTpValeFrete.Con_Valefrete_Placa || '-' || vTpValeFrete.Con_Valefrete_Placasaque);  
                    --raise_application_error(-20123,'Erro Inserindo Conta Corrente ' || vTpValeFrete.Con_Valefrete_Placa || '-' || vTpValeFrete.Con_Valefrete_Placasaque);
                 End ;



               vXmlDeb :=         '<Parametros> ';
               vXmlDeb := vXmlDeb || '   <Input>';
               vXmlDeb := vXmlDeb || '     <pProprietario>' || vProprietario || '</pProprietario> ';
               vXmlDeb := vXmlDeb || '     <pVeiculo>' || vTpValeFrete.Con_Valefrete_Placa  || '</pVeiculo>';
               vXmlDeb := vXmlDeb || '     <pVeiculoSq>' || vTpValeFrete.Con_Valefrete_PlacaSaque  || '</pVeiculoSq>';
               vXmlDeb := vXmlDeb || '     <pMotorista>' || vTpValeFrete.Con_Valefrete_Carreteiro || '</pMotorista>';
               vXmlDeb := vXmlDeb || '     <pMotoristaSq>' || vCarreteiroSq || '</pMotoristaSq>';
               vXmlDeb := vXmlDeb || '     <pRotaUsuario>' || nvl(p_RotaUsuario,'010') || '</pRotaUsuario>';
               vXmlDeb := vXmlDeb || '     <pUsuario>' || p_Usuario || '</pUsuario>';
               vXmlDeb := vXmlDeb || '     <pAplicacao>comvlfrete</pAplicacao>';
               vXmlDeb := vXmlDeb || '     <pDocumento>'|| vTpValeFrete.Con_Conhecimento_Codigo  || tpVF.tpValeFrete.Glb_Rota_Codigo || tpVF.tpValeFrete.Con_Valefrete_Saque  ||'</pDocumento>';
               vXmlDeb := vXmlDeb || '     <pValorDebitar>' || trim(to_char(vValorDeb)) || '</pValorDebitar>';
               vXmlDeb := vXmlDeb || '     <pVencimento></pVencimento>';
               vXmlDeb := vXmlDeb || '     <pTpLancamento>VFT</pTpLancamento>';
               vXmlDeb := vXmlDeb || '     <pOBS>Lancamento Automatico VFT</pOBS>';
               vXmlDeb := vXmlDeb || '     <pHistoricoLancamento>' || vTpValeFrete.Con_Conhecimento_Codigo || vTpValeFrete.Con_Conhecimento_Serie || vTpValeFrete.Glb_Rota_Codigo || vTpValeFrete.Con_Valefrete_Saque || '</pHistoricoLancamento>';
               vXmlDeb := vXmlDeb || '     <pVersao>12.7.27.3</pVersao>';
               vXmlDeb := vXmlDeb || '   </Input>';
               vXmlDeb := vXmlDeb || '</Parametros>';

               pkg_car_proprietario.Sp_DebitaContaCorrente(vXmlDeb,P_STATUS,P_MESSAGE);
               commit;
            End If;
         Else
            p_status  := pkg_glb_common.Status_Erro;
            p_message := 'Vale de frete não e Categoria Serviço de Terceiro';
         End If;

     End If;

   End sp_con_InsereVFTContaCorrente;

   Function fn_ListaClienteEntregas(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                    pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                    pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                    pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                    pCriaEstadia    in char,
                                    pStatus         out char,
                                    pMessage        out varchar2
                                    )
                             -- podendo ser D para Destinos
                             --             Q para quantidades
          return varchar2
     As
 --      pStatus    char(1);
 --      pMessage    varchar2(3000);
       vQtde      integer;
       vDescricao varchar2(3000);
       vAuxiliar Char(2);
       vAuxiliarN number;
       vMenorSaqueValido char(1);
       vTpVeic t_Fcf_Tpveiculo.Fcf_Tpveiculo_Codigo%Type;
       vDtEntrega tdvadm.t_con_vfreteentrega.con_vfreteentrega_dtentrega%type;
       vCategoria  t_con_catvalefrete.con_catvalefrete_codigo%type;

    Begin

       pStatus := pkg_glb_common.Status_Warning;
       pMessage := 'Iniciando Inclusao Estadia';
       
 --      pStatus := pkg_glb_common.Status_Nomal;
       Begin
          select vf.con_catvalefrete_codigo
            into vCategoria
          from t_con_valefrete vf
          where vf.con_conhecimento_codigo = pVfreteCodigo
            and vf.con_conhecimento_serie = pVfreteSerie
            and vf.glb_rota_codigo = pVfreteRota
            and vf.con_valefrete_saque = pVfreteSaque;
       Exception
         When NO_DATA_FOUND Then
           vCategoria := '00';
         End;


       if vCategoria <> CatTEstadia Then
          pStatus := pkg_glb_common.Status_Nomal;
          pMessage := 'Categoria não e de ESTADIA';
       End If;


       vQtde := 0;
       vDescricao := '';
       -- Apaga se encontrar algum registro = 0
       -- Este era usando quando imprimia
       delete tdvadm.t_con_valefreteest x
       where x.con_conhecimento_codigo = pVfreteCodigo
         and x.con_conhecimento_serie = pVfreteSerie
         and x.glb_rota_codigo = pVfreteRota
--         and x.con_valefrete_saque = pVfreteSaque
         and nvl(x.con_valefreteest_peso,0) = 0
         and x.con_valefreteest_usuaprovacao is null;
         
       vTpVeic := Pkg_frtcar_veiculo.fn_retVeiculoVF(pVfreteCodigo,pVfreteSerie,pVfreteRota,'P','C', pVfreteSaque);
         
  for c_Cursor in (select distinct
                               a.con_valefrete_saque,
                               ce.glb_portaria_id IdPor,
                               ce.glb_cliente_cgccpfcodigo,
                               ce.glb_tpcliend_codigo, 
                               ce.glb_cliend_codcliente ,
                               to_date(to_char(nvl(a.con_valefrete_dataprazomax,sysdate),'dd/mm/yyyy') || ' ' || to_char(nvl(a.con_valefrete_horaprazomax,trunc(sysdate)),'hh24:mi'),'dd/mm/yyyy hh24:mi') dtentrega,
                               max(ce.glb_tpcliend_codigo || '-' || ce.glb_cliente_cgccpfcodigo) tpEnd,
                               SUM(a.con_valefrete_pesocobrado) peso,
                               c.glb_cliente_cgccpfsacado sacado,
                               --CLDest.GLB_GRUPOECONOMICO_CODIGO,
                               CLSac.Glb_Grupoeconomico_Codigo,
                               tdvadm.pkg_slf_utilitarios.fn_retorna_contrato(C.CON_CONHECIMENTO_CODIGO,C.CON_CONHECIMENTO_SERIE,C.GLB_ROTA_CODIGO) CONTRATO
                           From tdvadm.t_con_valefrete a,
                                tdvadm.t_fcf_solveic sv,
                                tdvadm.t_fcf_solveicdest svd,
                                tdvadm.t_con_vfreteconhec vfc,
                                tdvadm.t_con_conhecimento c,
                                tdvadm.t_glb_cliend ce,
                                tdvadm.T_GLB_CLIENTE CLDest,
                                tdvadm.T_GLB_CLIENTE CLSac
                           where sv.fcf_veiculodisp_codigo    = a.fcf_veiculodisp_codigo
                             and sv.fcf_veiculodisp_sequencia = a.fcf_veiculodisp_sequencia
                             and nvl(a.con_valefrete_status,'N') = 'N'
                             --and vfc.con_vfreteconhec_transfchekin <> 'Sim'
                             and vfc.arm_armazem_codigo is null
                             and a.con_conhecimento_codigo = pVfreteCodigo
                             and a.con_conhecimento_serie  = pVfreteSerie
                             and a.glb_rota_codigo         = pVfreteRota
                             AND A.CON_VALEFRETE_Saque     = pVfreteSaque
                             and sv.fcf_solveic_cod        = svd.fcf_solveic_cod
                             and a.con_conhecimento_codigo = vfc.con_valefrete_codigo
                             and a.con_conhecimento_serie  = vfc.con_valefrete_serie
                             and a.glb_rota_codigo         = vfc.glb_rota_codigovalefrete
                             and a.con_valefrete_saque     = vfc.con_valefrete_saque
                             and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                             and vfc.con_conhecimento_serie  = c.con_conhecimento_serie
                             and vfc.glb_rota_codigo         = c.glb_rota_codigo
                             and c.glb_cliente_cgccpfsacado  = CLSac.Glb_Cliente_Cgccpfcodigo
                             and c.glb_cliente_cgccpfdestinatario = ce.glb_cliente_cgccpfcodigo
                             and c.glb_tpcliend_codigodestinatari = ce.glb_tpcliend_codigo
                             AND CLDest.GLB_CLIENTE_CGCCPFCODIGO      = CE.GLB_CLIENTE_CGCCPFCODIGO
/*                             
                             and a.con_valefrete_saque = (select min(a1.con_valefrete_saque)
                                                          from tdvadm.t_con_valefrete a1
                                                          where a1.con_conhecimento_codigo = a.con_conhecimento_codigo
                                                            and a1.con_conhecimento_serie = a.con_conhecimento_serie
                                                            and a1.glb_rota_codigo = a.glb_rota_codigo
                                                            and nvl(a1.con_valefrete_status,'N') = 'N'
                                                            group by a1.con_conhecimento_codigo,
                                                                     a1.con_conhecimento_serie,
                                                                     a1.glb_rota_codigo)
*/                            group by a.con_valefrete_saque,
                                     ce.glb_portaria_id,
                                     ce.glb_cliente_cgccpfcodigo,
                                     ce.glb_tpcliend_codigo,
                                     ce.glb_cliend_codcliente,
                                     to_date(to_char(nvl(a.con_valefrete_dataprazomax,sysdate),'dd/mm/yyyy') || ' ' || to_char(nvl(a.con_valefrete_horaprazomax,trunc(sysdate)),'hh24:mi'),'dd/mm/yyyy hh24:mi'),
                                     c.glb_cliente_cgccpfsacado,
                                     CLSac.Glb_Grupoeconomico_Codigo,
                                     C.CON_CONHECIMENTO_CODIGO,C.CON_CONHECIMENTO_SERIE,C.GLB_ROTA_CODIGO)

        Loop

             vAuxiliarN := 0;
             Begin
                tpVF.vAuxiliar2 := length(trim(c_Cursor.Glb_Cliend_Codcliente));
                select e.con_vfreteentrega_dtentrega
                  into vDtEntrega
                from tdvadm.T_CON_VFRETEENTREGA e
               where e.con_conhecimento_codigo = pVfreteCodigo
                  and e.con_conhecimento_serie = pVfreteSerie
                  and e.glb_rota_codigo = pVfreteRota
                  and e.con_valefrete_saque = pVfreteSaque
                  and TDVADM.fn_limpa_campo3(SUBSTR(e.con_vfreteentrega_codcli,1,tpVF.vAuxiliar2)) = TDVADM.fn_limpa_campo3(trim(c_Cursor.Glb_Cliend_Codcliente));
                vAuxiliarN := 1;
             exception
               When NO_DATA_FOUND Then
                  vDtEntrega := c_Cursor.dtentrega; 
                  vAuxiliarN := 0;
               When OTHERS Then
                  vAuxiliarN := -1;
               End ;
               
             vQtde := vQtde + 1;
             vDescricao := vDescricao || trim(c_Cursor.tpEnd) ||'-'|| trim(c_Cursor.Glb_Cliend_Codcliente) || '-' || to_char(vDtEntrega,'dd/mm/yyyy hh24:mi') ||  ' # ';


             If c_Cursor.Glb_Cliend_Codcliente Is null Then
                pStatus := 'E';
                pMessage := pMessage || 'Falta CodCli para CNPJ ' || c_Cursor.glb_cliente_cgccpfcodigo || ' tpEnd ' || c_Cursor.glb_tpcliend_codigo || chr(10); 
                vAuxiliarN := -1;
             End If;  
             
             if vAuxiliarN = 0 Then
                Begin
                   Insert into tdvadm.t_con_vfreteentrega vfe
                      (CON_CONHECIMENTO_CODIGO,
                       CON_CONHECIMENTO_SERIE,
                       GLB_ROTA_CODIGO,
                       CON_VALEFRETE_SAQUE,
                       CON_VFRETEENTREGA_CODCLI,
                       CON_VFRETEENTREGA_SEQ,
                       CON_VFRETEENTREGA_DTENTREGA,
                       CON_VFRETEENTREGA_CODIGO,
                       CON_VFRETEENTREGAOBSERVACAO,
                       USU_USUARIO_CODIGO,
                       CON_VFRETEENTREGA_CONFIRMADO)
                   Values
                      (pVfreteCodigo,
                       pVfreteSerie,
                       pVfreteRota,
                       pVfreteSaque,
                       TDVADM.fn_limpa_campo3(c_Cursor.Glb_Cliend_Codcliente),
                       1,
                       null,-- c_Cursor.dtentrega, -- SIRLANO vERIFICAR AMANHA
                       null,
                       null,
                       null,
                       null);
                 exception
                   When OTHERS Then
                      vAuxiliarN := vAuxiliarN;
                   End;      
              
             End If;



             If pCriaEstadia = 'S' Then
                 select count(*)
                   into vAuxiliarN
                 from tdvadm.t_con_valefreteest x
                 where x.con_conhecimento_codigo = pVfreteCodigo
                   and x.con_conhecimento_serie = pVfreteSerie
                   and x.glb_rota_codigo = pVfreteRota
    --               and x.con_valefrete_saque = pVfreteSaque
                   and trim(x.glb_cliente_cgccpfcodigodest) = trim(substr(c_Cursor.tpEnd,3))
                   and x.glb_tpcliend_codigodest = substr(c_Cursor.tpEnd,1,1);
                 if vAuxiliarN = 0 Then
                   If vCategoria = CatTEstadia Then
                     insert into tdvadm.t_con_valefreteest
                       (CON_CONHECIMENTO_CODIGO,
                        con_conhecimento_serie,
                        glb_rota_codigo ,
                        con_valefrete_saque,
                        con_valefreteest_seq,
                        glb_cliente_cgccpfcodigosacado ,
                        glb_tpcliend_codigosac,
                        glb_cliente_cgccpfcodigodest,
                        glb_tpcliend_codigodest,
                        con_valefreteest_peso,
                        slf_contrato_codigo,
                        glb_grupoeconomico_codigosac,
                        FCF_TPVEICULO_CODIGO)
                     Values
                       (pVfreteCodigo,
                        pVfreteSerie,
                        pVfreteRota,
                        c_Cursor.Con_Valefrete_Saque,
                        vQtde,
                        c_Cursor.sacado,
                        'C',
                        substr(c_Cursor.tpEnd,3),
                        substr(c_Cursor.tpEnd,1,1),
                        c_Cursor.peso,
                        C_CURSOR.CONTRATO,
                        C_CURSOR.GLB_GRUPOECONOMICO_CODIGO,
                        Decode(vTpVeic,'NE',null,vTpVeic));
                    End If;
                 End If;
             End If;
         End Loop;
         vDescricao := lpad(vQtde,2,'0') || ' - ' || vDescricao;
         
         pStatus := pkg_glb_common.Status_Nomal;
         pMessage := 'OK';         
         
         Return  trim(vDescricao);

     End fn_ListaClienteEntregas;


   Procedure sp_InsereEntregas(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                               pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                               pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                               pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type)
     Is
      vQtde Number;
      vDestinos varchar2(3000);
      vCnpj     tdvadm.t_Glb_Cliend.glb_cliente_cgccpfcodigo%type;
      vTpCliend tdvadm.t_Glb_Cliend.glb_tpcliend_codigo%Type;
      i         number;
   Begin
     vDestinos := fn_ListaEntregas(pVfreteCodigo,pVfreteSerie,pVfreteRota,pVfreteSaque);
     vQtde := to_number(substr(vDestinos,1,2));
     vDestinos := substr(vDestinos,4);

 /*
     for i in 1..vQtde
      loop

       insert into t_con_valefreteest
         (CON_CONHECIMENTO_CODIGO,
          con_conhecimento_serie,
          glb_rota_codigo ,
          con_valefrete_saque,
          con_valefreteest_seq,
          glb_cliente_cgccpfcodigo,
          glb_tpcliend_codigo)

      Values
         (pVfreteCodigo,
          pVfreteSerie,
          pVfreteRota,
          pVfreteSaque,
          vCnpj,
          vTpCliend);
     end loop;

 */    commit;



   End sp_InsereEntregas;

   

   PROCEDURE SP_CON_VALIDAVALEFRETE(P_QRYSTR   In blob,
                                    P_XMLOUT   Out Clob,
                                    P_STATUS   OUT CHAR,
                                    P_MESSAGE  OUT VARCHAR2) As



 /* exemplo de QueryStr
 'VFNumero=nome=VFNumero|tipo=String|valor=' + p_VF + '*' +
 'VFSerie=nome=VFSerie|tipo=String|valor=' + p_Serie + '*' +
 'VFRota=nome=VFRota|tipo=String|valor=' + p_Rota + '*' +
 'VFSaque=nome=VFSaque|tipo=String|valor=' + p_Saque + '*' +
 'VFAcao=nome=VFAcao|tipo=String|valor=Excluir*' +
 'VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=' + p_Usuario + '*' +
 'VFRotaUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=' + Frm_ValeFrete.v_Rota + '*' +
 'VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*' +
 'VFVersaoAplicao=nome=VFVersaoAplicao|tipo=String|valor=12.3.8.0*' ;
 */


 /* Variáveis criadas para controlar a exigência de imagem para o CTRC e/ou NF, na criação do valefrete. */
   plistavalefrete        glbadm.pkg_listas.tlistavalefrete;
   plistaVfImagem         glbadm.pkg_listas.tListaVFImagens;
   tpVfreteentregas       tdvadm.t_con_vfreteentrega%rowtype;
   plistaVFEntregas       glbadm.pkg_listas.tListaVFEntregas;
   plistaparams           glbadm.pkg_listas.tlistausuparametros;
   P_MESSAGEAUX           VARCHAR2(32000);
   vCursor                t_cursor;
   vLinha                 pkg_glb_SqlCursor.tpString1024;
   vXmlTabOutxml          xmltype;
   vXmlTabOutclob         clob;
   vXmlDeb                clob;
   vXmlImagem             clob;
   vXmlEntrega            clob;
   vXmlEntregaDet         clob;
   vValorDeb              number;
   vProprietario          tdvadm.t_car_veiculo.car_proprietario_cgccpfcodigo%type;
   vCarreteiroSq          tdvadm.t_car_carreteiro.car_veiculo_saque%type;
   vC_QRYSTR              CLOB;
   tpLinhaValeFrete       tdvadm.t_con_valefrete%rowtype;
   vStatus                char(1);
   vProrrogaDebito        char(1);
   vMessage               varchar2(20000);
   vParametros            varchar2(2000);
   vInserDebito           char(1) := 'S';
   vQtdeCTecomCarreg      number;
   vQtdeCTesemCarreg      number;
   vFrotaPagoCartao       char(1);
   vExisteViagem          integer;
   vStatus2               char(1);
   vMessage2              varchar2(2000);
   vQtdeEntregas          integer;
   vXmlin                 varchar2(32000);
   vXmlout                varchar2(32000);
   vXmlOutT               clob;
   vXmlOutB               blob;
   vPclCodigo             tdvadm.t_glb_pcl.glb_pcl_codigo%type;
   vPclVersao             tdvadm.t_glb_pcl.glb_pcl_versao%type;
   V_QTDEIMG              INTEGER;
   V_CONTADORREC          number; -- quantidade de imagens recusadas
   V_CONTADORNAPROV       number; -- quantidade de imagens nao aprovadas
   vOnde                  varchar2(200);
   vViagemCiot            integer;
   vCodEstadia            char(3);
   vOBSEstadia            tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type;
   vErroAverbacao         tdvadm.t_con_erroaverbacao.con_erroaverbacao_msgerro%type;
   vTemAverbacao          integer;
   vTemErroAverbacao      integer;
   vListaNaoAverbados     varchar2(1000);
   vExisteCancel          integer;
   vQtdeTotalCancel       integer;
   vQtdeCteNautorizado    integer;
   vListaNaoAutorizados   varchar2(1000);
   vListaPedidoCancel     varchar2(1000);
   vStatusEstadia         varchar2(300);
   vDataDeEntrega         date;
   vHoraDeEntrega         char(5);
   vCATVFRETE             tdvadm.t_usu_perfil.usu_perfil_parat%type;
   vExcluirCTe            tdvadm.t_usu_perfil.usu_perfil_parat%type;
   vRotaSemAverbacao      tdvadm.t_usu_perfil.usu_perfil_parat%type;
   vTextoeSocial          tdvadm.t_Car_Esocial.car_esocial_mensagem%type;
   vBloqAltFrete          tdvadm.t_usu_perfil.usu_perfil_parat%type;
   vValidaDTEntrega       char(1);
   vPercentExpresso       number;
   vDataMaximaEntrega     TDVADM.t_Con_Vfreteentrega.CON_VFRETEENTREGA_DTENTREGA%type;
   vValorTrava            number;
   vValorValeFrete        number;
   vLiberacao             number;
   vPercDifRecXDesp       number;
   vQtdeDiasRecXDesp      integer;

   
   vDataVf                TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_DATACADASTRO%TYPE;
   vDataEmiCTe            TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_DTEMBARQUE%TYPE;
   
   vLibPercDifRecXDesp    integer;
   vLibDiasRecXDesp       integer;
   vValorTotalDespesa     TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_CUSTOCARRETEIRO%TYPE;
   vValorTotalReceita     TDVADM.T_CON_CALCCONHECIMENTO.CON_CALCVIAGEM_VALOR%TYPE;
   
   vLibBloqueiCteCompl    integer;
   vBloqueiCteCompl       varchar2(100);
   vExisteCteComplementar integer;
      
   vGrupoEconomico        TDVADM.T_GLB_CLIENTE.GLB_GRUPOECONOMICO_CODIGO%type;
   vSQLTeste              clob;
   
   --vValeFreteObrigacoes TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_OBRIGACOES%type;
   --vValeFreteObrigacoes varchar2(1000);
   --vMSG_CONTRATADO      tdvadm.t_usu_perfil.usu_perfil_parat%type;
 begin


    begin
        if P_QRYSTR is null Then
           vC_QRYSTR := '<Parametros>    <Input>     <VFNumero>083341</VFNumero>      <VFSerie>A1</VFSerie>     <VFRota>185</VFRota>     <VFSaque>1</VFSaque>     <VFAcao>Salvar</VFAcao>     <VFUsuarioTDV>jsantos</VFUsuarioTDV>     <VFRotaUsuarioTDV>185</VFRotaUsuarioTDV>     <VFAplicacaoTDV>comvlfrete</VFAplicacaoTDV>     <VFVersaoAplicao>16.1.27.0</VFVersaoAplicao>     <VFProcedureDelphi></VFProcedureDelphi>     <CON_CATVALEFRETE_CODIGO>01</CON_CATVALEFRETE_CODIGO>     <CON_SUBCATVALEFRETE_CODIGO></CON_SUBCATVALEFRETE_CODIGO>     <CON_VALEFRETE_PERCETDES>20</CON_VALEFRETE_PERCETDES>     <CON_VALEFRETE_MULTA>0</CON_VALEFRETE_MULTA>     <CON_VALEFRETE_PLACA>MPF7989</CON_VALEFRETE_PLACA>     <CON_VALEFRETE_PLACASAQUE>0004</CON_VALEFRETE_PLACASAQUE>     <CON_VALEFRETE_CUSTOCARRETEIRO>499</CON_VALEFRETE_CUSTOCARRETEIRO>     <CON_VALEFRETE_TIPOCUSTO>U</CON_VALEFRETE_TIPOCUSTO>     <FCF_FRETECAR_ROWID>AAAReDACMAAAM7SAA1</FCF_FRETECAR_ROWID>     <FCF_VEICULODISP_CODIGO>2403064</FCF_VEICULODISP_CODIGO>     <FCF_VEICULODISP_SEQUENCIA>0</FCF_VEICULODISP_SEQUENCIA>     <GLB_CLIENTE_CGCCPFCODIGO></GLB_CLIENTE_CGCCPFCODIGO>       <Tables> <table name="Entrega" tipo="P"><Rowset><Row><vfrete>083341</vfrete><serie>A1</serie><rota>185</rota><Saque>1</Saque><Codcli>037-GOV VAL.</Codcli><Sequencia>1</Sequencia><DtEntrega>05/07/2016 23:00</DtEntrega><CodEntrega>teste 1</CodEntrega><UsuCriou>jsantos</UsuCriou><Conf/><Obs>12345dfsgl</Obs></Row><Row><vfrete>083341</vfrete><serie>A1</serie><rota>185</rota><Saque>1</Saque><Codcli>03D-PIRAQUEACU</Codcli><Sequencia>1</Sequencia><DtEntrega>10/07/2016 21:00</DtEntrega><CodEntrega>teste2</CodEntrega><UsuCriou>jsantos</UsuCriou><Conf/><Obs>asdfadfads</Obs></Row></Rowset></table>       </Tables>    </Input></Parametros>';
           vC_QRYSTR := '<Parametros>    <Input>     <VFNumero>083341</VFNumero>      <VFSerie>A1</VFSerie>     <VFRota>185</VFRota>     <VFSaque>1</VFSaque>     <VFAcao>Salvar</VFAcao>     <VFUsuarioTDV>jsantos</VFUsuarioTDV>     <VFRotaUsuarioTDV>185</VFRotaUsuarioTDV>     <VFAplicacaoTDV>comvlfrete</VFAplicacaoTDV>     <VFVersaoAplicao>16.5.23.0</VFVersaoAplicao>     <VFProcedureDelphi></VFProcedureDelphi>     <CON_CATVALEFRETE_CODIGO>01</CON_CATVALEFRETE_CODIGO>     <CON_SUBCATVALEFRETE_CODIGO></CON_SUBCATVALEFRETE_CODIGO>     <CON_VALEFRETE_PERCETDES>20</CON_VALEFRETE_PERCETDES>     <CON_VALEFRETE_MULTA>0</CON_VALEFRETE_MULTA>     <CON_VALEFRETE_PLACA>MPF7989</CON_VALEFRETE_PLACA>     <CON_VALEFRETE_PLACASAQUE>0004</CON_VALEFRETE_PLACASAQUE>     <CON_VALEFRETE_CUSTOCARRETEIRO>499</CON_VALEFRETE_CUSTOCARRETEIRO>     <CON_VALEFRETE_TIPOCUSTO>U</CON_VALEFRETE_TIPOCUSTO>     <FCF_FRETECAR_ROWID>AAAReDACMAAAM7SAA1</FCF_FRETECAR_ROWID>     <FCF_VEICULODISP_CODIGO>2403064</FCF_VEICULODISP_CODIGO>     <FCF_VEICULODISP_SEQUENCIA>0</FCF_VEICULODISP_SEQUENCIA>     <GLB_CLIENTE_CGCCPFCODIGO></GLB_CLIENTE_CGCCPFCODIGO>   </Input></Parametros>';

               select d.glb_sql_instrucao
                 into vC_QRYSTR
               from tdvadm.t_glb_sql d
               where trim(d.glb_sql_programa) = 'teste22/11'
                 and d.glb_sql_observacao like '%Sirlano%'
                 and rownum = 1;


        Else
           vC_QRYSTR := glbadm.pkg_glb_blob.f_blob2clob(P_QRYSTR);
        end if;

--        insert into tdvadm.dropme (x , l) values ('teste03/10' , vC_QRYSTR);
          

       exception
         when OTHERS Then
              begin
               select d.glb_sql_instrucao
                 into vC_QRYSTR
               from tdvadm.t_glb_sql d
               where trim(d.glb_sql_programa) = 'teste22/11'
                 and d.glb_sql_observacao like '%Sirlano%'
                 and rownum = 1;
              Exception
                When OTHERS Then
                  vC_QRYSTR := sqlerrm;
                 return;
                End ;
         End ;





      P_STATUS  := trim(pkg_glb_common.Status_Nomal);

      select a.terminal
        into tpVF.vMaquina
      from v_glb_ambiente a;


      tpVF.VFNumero         := trim(substr(TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFNumero','=','*'), 'valor', '=', '|'),1,7));
      tpVF.VFNumero := 'Sirlano';
      If  nvl(tpVF.VFNumero,'Sirlano') <> 'Sirlano' Then
          tpVF.VFSerie          := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFSerie','=','*'), 'valor', '=', '|');
          tpVF.VFRota           := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFRota','=','*'), 'valor', '=', '|');
          tpVF.VFSaque          := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFSaque','=','*'), 'valor', '=', '|');
          tpVF.VFAcao           := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFAcao','=','*'), 'valor', '=', '|');
          tpVF.VFusuarioTDV     := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFUsuarioTDV','=','*'), 'valor', '=', '|');
          tpVF.VFRotaUsuarioTDV := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|');
          tpVF.VFAplicacaoTDV   := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFAplicacaoTDV','=','*'), 'valor', '=', '|');
          tpVF.VFVersaoAplicao  := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'VFVersaoAplicao','=','*'), 'valor', '=', '|');
          tpVF.VFCON_VALEFRETE_PERCETDES := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'CON_VALEFRETE_PERCETDES','=','*'), 'valor', '=', '|');
          tpVF.VFCON_VALEFRETE_MULTA := TDVADM.fn_querystring(TDVADM.fn_querystring(vC_QRYSTR,'CON_VALEFRETE_MULTA','=','*'), 'valor', '=', '|');
          tpVF.VFCON_CATVALEFRETE_CODIGO  := '';
          tpVF.VFCON_VALEFRETE_PLACA      := '';
          tpVF.VFCON_VALEFRETE_PLACASAQUE := '';

     Else
          tpVF.vXmlTab := vC_QRYSTR;
          tpVF.VFNumero                       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFNumero' ));
          tpVF.VFSerie                        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFSerie' ));
          tpVF.VFRota                         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFRota' ));
          tpVF.VFSaque                        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFSaque' ));
          tpVF.VFAcao                         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFAcao' ));
          tpVF.VFusuarioTDV                   := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFUsuarioTDV' ));
          tpVF.VFRotaUsuarioTDV               := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFRotaUsuarioTDV' );
          tpVF.VFAplicacaoTDV                 := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFAplicacaoTDV' );
          tpVF.VFVersaoAplicao                := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFVersaoAplicao' );
          tpVF.VFCON_VALEFRETE_PERCETDES      := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_VALEFRETE_PERCETDES' );
          tpVF.VFCON_VALEFRETE_MULTA          := replace(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_VALEFRETE_MULTA'),',','.');
          tpVF.VFCON_CATVALEFRETE_CODIGO      := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_CATVALEFRETE_CODIGO' );
          tpVF.VFCON_SUBCATVALEFRETE_CODIGO   := substr(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_SUBCATVALEFRETE_CODIGO' ),1,2);
          tpVF.VFCON_VALEFRETE_PLACA          := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_VALEFRETE_PLACA'));
          tpVF.VFCON_VALEFRETE_PLACASAQUE     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_VALEFRETE_PLACASAQUE'));
          tpVF.vCON_VALEFRETE_CUSTOCARRETEIRO := replace(trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_VALEFRETE_CUSTOCARRETEIRO')),',','.');
          tpVF.vCON_VALEFRETE_TIPOCUSTO       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_VALEFRETE_TIPOCUSTO'));
          tpVF.vFCF_FRETECAR_ROWID            := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'FCF_FRETECAR_ROWID'));
          tpVF.vFCF_VEICULODISP_CODIGO        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'FCF_VEICULODISP_CODIGO'));
          tpVF.vFCF_VEICULODISP_SEQUENCIA     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'FCF_VEICULODISP_SEQUENCIA'));
          tpVF.vFGLB_CLIENTE_CGCCPFCODIGO     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'GLB_CLIENTE_CGCCPFCODIGO'));
      End If;

      system.pkg_glb_context.sp_set_vlr_VALEFRETE(tpVF.VFusuarioTDV,to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));

        insert into tdvadm.t_glb_sql values (vC_QRYSTR,
                                             sysdate,
                                             'teste22/11',
                                             tpVF.VFNumero || '-' || tpVF.VFSerie || '-' || tpVF.VFRota  || '-' || tpVF.VFSaque || '-' || tpVF.VFAcao || '-' || tpVF.VFCON_CATVALEFRETE_CODIGO );
        commit;


 --     if Not glbadm.pkg_listas.fn_get_listavaledefrete(tpVF.vXmlTab,plistavalefrete,P_MESSAGE) then
 --        P_MESSAGE := P_MESSAGE;
 --     End if;

          -- verifica se existe SubCategoria e preenche o Tipo da Sub Categoria
          tpVF.vExisteSubCategoria := fni_vld_SubCategoria(tpVF.VFCON_CATVALEFRETE_CODIGO,
                                                           tpVF.VFCON_SUBCATVALEFRETE_CODIGO,
                                                           tpVF.tpSubCategoria);



      if tpVF.VFVersaoAplicao = '13.1.23.1' Then
         P_MESSAGE := ' ' ; -- Processamento normal!';

     Else
         P_MESSAGE := '' ; -- Processamento normal!';
      end if;

   -- Validações Basicas.
   if tpVF.VFusuarioTDV = 'jsantos' then
      P_MESSAGE := chr(10) || 'Ac Solicitada ' || tpVF.VFAcao || '-' || tpVF.VFCON_CATVALEFRETE_CODIGO || chr(10);

   End If;

   If nvl(tpVF.VFCON_VALEFRETE_PERCETDES,'') = '' Then
      tpVF.VFCON_VALEFRETE_PERCETDES := '20';
   End If;
   
   if Not glbadm.pkg_listas.fn_get_usuparamtros(tpVF.VFAplicacaoTDV,
                                                tpVF.VFusuarioTDV,
                                                tpVF.VFRotaUsuarioTDV,
                                                plistaparams) Then

      P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
      P_MESSAGE := P_MESSAGE || '10 - Erro ao Buscar Parametros.' || chr(10);
   End if ;



   Begin
      Select v.car_proprietario_cgccpfcodigo,
             p.car_proprietario_tipopessoa
        Into tpVF.v_Proprietario,
             tpVf.v_TpProprietario
      From tdvadm.t_car_veiculo v,
           tdvadm.t_Car_Proprietario p,
           tdvadm.t_con_valefrete vf
      Where v.car_veiculo_placa = vf.con_valefrete_placa
        And v.car_veiculo_saque = vf.con_valefrete_placasaque
        and v.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo
        and vf.con_conhecimento_codigo = tpVF.VFNumero
        and vf.con_conhecimento_serie = tpVF.VFSerie
        and vf.glb_rota_codigo = tpVF.VFRota
        and vf.con_valefrete_saque = tpVF.VFSaque;
   Exception
      When NO_DATA_FOUND Then
          tpVF.v_Proprietario := null;
      End;

    If ( nvl(plistaparams('ESOCIALCONSULTA').texto,'S') = 'S' ) and 
       ( tpVf.v_TpProprietario = 'F' ) and 
       ( tpVF.VFAcao in ('Salvar','Imprimir') )  Then
       If tpVF.v_Proprietario Is not null Then

          SP_eSocialValida(tpVF.v_Proprietario,
                           nvl(plistaparams('ESOCIALPRAZOVALID').numerico1,90),
                           vStatus,
                           vMessage);
          If vStatus <> 'N' Then
             P_STATUS := 'E';
             P_MESSAGE := P_MESSAGE || vMessage;
          End If;
       End If;    
    
    End If;
    



  If tpVF.VFCON_VALEFRETE_PLACA <> '' Then

      vxmlin := '<Parametros>' ||
                '    <Input>' ||
                '        <Manifesto></Manifesto>' ||
                '        <Serie></Serie>' ||
                '        <Rota></Rota>' ||
                '        <Placa>' || trim(tpVF.VFCON_VALEFRETE_PLACA) || '</Placa>' ||
                '    </Input>' ||
                '</Parametros>';


      tdvadm.pkg_fifo_manifesto.Sp_Get_StatusAutorizacaoPlaca(pxmlin => vxmlin,
                                                              pxmlout => vxmlout,
                                                              pstatus => vStatus,
                                                              pmessage => vMessage);

    --  raise_application_error(-20001, vxmlout);
      If length(trim(vxmlout)) > 10 Then

         vMessage := '';
         for c_msg in (Select extractvalue(value(field), 'row/Status_Atual_TDV') Status_Atual_TDV,
                              extractvalue(value(field), 'row/Encerramento') Encerramento
                       From Table(xmlsequence( Extract(xmltype.createXml(vxmlout) , '/Parametros/OutPut/Tables/Table[@name="Status"]/RowSet/row'))) field )
         Loop
         
           vMessage := vMessage || substr(c_msg.status_atual_tdv,37,15) || chr(10);
         
         End Loop;
         
    --  raise_application_error(-20001, vpmessage);


         If ( length(trim(vMessage)) > 6 ) Then
            raise_application_error(-20001, chr(10) || chr(10) || 
                                            '**********************************' || chr(10) ||
                                            'MANIFESTOS PENDENTES DE FECHAMENTO'|| chr(10) ||
                                            vMessage || 
                                            '**********************************' || chr(10) || chr(10) || chr(10));
         End If;  
      
      End If;

   End If;
       
   
    
            -- Valida Se foi criado a FRETECARMEMO
    

    begin
        vValidaDTEntrega := plistaparams('VALIDADTENTREGA').texto;
     exception
       when NO_DATA_FOUND Then
         vValidaDTEntrega := 'N';
       end;


    
    begin
        vBloqAltFrete := plistaparams('SOL_ACRESCIMO').texto;
     exception
       when NO_DATA_FOUND Then
         vBloqAltFrete := 'S';
       end;

    
    begin
        vRotaSemAverbacao := plistaparams('ROTASEMAVERBACAO').texto;
     exception
       when NO_DATA_FOUND Then
         vRotaSemAverbacao := 'S';
       end;


    begin
        tpVf.vValefreteNaoImp := plistaparams('LIBVFNAOIMP').texto;
     exception
       when NO_DATA_FOUND Then
         tpVf.vValefreteNaoImp := 'N';
       end;

      tpVf.vValefreteNaoImp := 'S';


    begin
        tpVf.vImprimePCL := plistaparams('IMPPCL').texto;
     exception
       when NO_DATA_FOUND Then
         tpVf.vImprimePCL := 'N';
       end;



    begin
        tpVf.vValefreteNaoImpQtdeDias := plistaparams('LIBVFNAOIMPDIAS').numerico1;
     exception
       when NO_DATA_FOUND Then
         tpVf.vValefreteNaoImpQtdeDias := 0;
       end;
       
    begin
       vCATVFRETE := plistaparams('CATVFRETE').texto;
     exception
       when NO_DATA_FOUND Then
          vCATVFRETE := 'NNNNNNNNNNNNNNNNNNNNNNNNN';
       end;

    begin
       vExcluirCTe := plistaparams('EXCLUIR_CTRC').texto;
     exception
       when NO_DATA_FOUND Then
          vExcluirCTe := 'N';
       end;



       
       
       

       vStatusEstadia := ''; 
       Pkg_frt_Estadia.Sp_Get_StatusEstadia(tpVF.VFNumero,
                                            tpVF.VFSerie,
                                            tpVF.VFRota,
                                            tpVf.vAuxiliarTexto,
                                            vStatus,
                                            vMessage);
                 
       if    trim(tpVf.vAuxiliarTexto) = 'N' Then -- N = 
           vStatusEstadia :=  'Estadias não foram criadas' || chr(10) ;
       ElsIf trim(tpVf.vAuxiliarTexto) = 'P' Then
          vStatusEstadia :=  'Pendente (de imagens e de cálculos)' || chr(10) ;
       ElsIf trim(tpVf.vAuxiliarTexto) = 'R' Then
          vStatusEstadia :=  'Imagem Recusada' || chr(10) ;
       ElsIf trim(tpVf.vAuxiliarTexto) = 'A' Then
          vStatusEstadia :=  'Estadias Autorizada' || chr(10) ;
       End IF;
       vStatusEstadia := vStatusEstadia || trim(substr(vMessage,1,100)) || chr(10);

    -- Verifica se o Veiculo Disp Ja esta em outro veiculo
    If tpVF.vFCF_VEICULODISP_CODIGO is not null Then
      
       Begin
       select vf.con_conhecimento_codigo || '-' || vf.con_conhecimento_serie || '-' || vf.glb_rota_codigo
          into tpVf.vAuxiliarTexto
       from tdvadm.t_con_valefrete vf
       where vf.fcf_veiculodisp_codigo = tpVF.vFCF_VEICULODISP_CODIGO
         and vf.fcf_veiculodisp_sequencia = tpVf.vFCF_VEICULODISP_SEQUENCIA
         and vf.con_conhecimento_codigo <> tpVf.VFNumero
--         and vf.glb_rota_codigo <> tpVf.VFRota
         and nvl(vf.con_valefrete_status,'N') <> 'C'
         and rownum = 1;
         If tpVf.vAuxiliarTexto is not null Then
            P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
            P_MESSAGE := P_MESSAGE || 'Veiculo Disponivel ' || tpVF.vFCF_VEICULODISP_CODIGO || ' em uso no Vale de Frete ' || tpVf.vAuxiliarTexto || chr(10);
            return;            
         End If;
         
       exception
         When NO_DATA_FOUND Then
            tpVf.vAuxiliarTexto := 'SEM VALE DE FRETE';
         End;
    End If;
    
   

     If tpVF.VFAcao = 'Sirlano' Then
        tpVF.VFAcao := tpVF.VFAcao; 
     ElsIf tpVF.VFAcao = 'ExcluirCTe' Then
     
        If vExcluirCTe = 'N' Then
           Select count(*) 
             into tpVF.vAuxiliar  
           From tdvadm.t_con_valefrete vf
           where vf.con_conhecimento_codigo = tpVF.VFNumero
             and vf.con_conhecimento_serie = tpVF.VFSerie
             and vf.glb_rota_codigo = tpVF.VFRota
             and vf.con_valefrete_saque = tpVF.VFSaque
             and vf.con_valefrete_fifo = 'S';
              
           If tpVF.vAuxiliar > 0 Then
           
              P_STATUS := 'E';
              P_MESSAGE := P_MESSAGE || chr(10) || 'Vale de Frete Feito pelo FIFO, Volte o CARREGAMENTO para Excluir Conhecimento';
              tpVF.vXmlTab :=           '<parametros><output>';
              tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
              tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
              tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';
              P_XMLOUT := tpVF.vXmlTab;
              return;
           End If;
        End If;

     
     
     ElsIf tpVF.VFAcao = 'ImprimirOk' Then

           -- Status de Impresso na Tabela do Monitor
            
/*  23/01/2017 Desativado para não acumular
            Update glbadm.T_INT_MONITORIMP mi
               set mi.int_monitorimp_impresso = 'S',
                   mi.int_monitorimp_dtimpressao = sysdate,
                   mi.int_monitorimp_status = 'Impresso'
            where mi.usu_aplicacao_codigo    = 'comvlfrete'
              AND mi.usu_aplicacaorel_codigo = 'valefrete'
              AND mi.usu_usuario_codigo      = tpVF.VFusuarioTDV
              AND mi.int_monitorimp_impresso = 'N';
*/  

            delete glbadm.T_INT_MONITORIMP mi
            where mi.usu_aplicacao_codigo    = 'comvlfrete'
              AND mi.usu_aplicacaorel_codigo = 'valefrete'
              AND mi.usu_usuario_codigo      = tpVF.VFusuarioTDV
              AND mi.int_monitorimp_impresso = 'N';
            
            update t_con_valefrete vf
              set vf.con_valefrete_impresso = 'S',
                  vf.con_valefrete_qtdereimp = 0
          where vf.con_conhecimento_codigo = tpVF.VFNumero
              and vf.con_conhecimento_serie = tpVF.VFSerie
              and vf.glb_rota_codigo = tpVF.VFRota
              and vf.con_valefrete_saque = tpVF.VFSaque;

           tpVF.vXmlTab :=           '<parametros><output>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';
           P_XMLOUT := tpVF.vXmlTab;
          return;

     End If;


     if nvl(tpVf.vValefreteNaoImp,'N') = 'N' Then
        SELECT MIN(VF.CON_VALEFRETE_DATACADASTRO) MENOR,
               COUNT(*) QTDE
           into tpVF.vAuxiliarData,
                 tpVF.vAuxiliar
        FROM T_CON_VALEFRETE VF
        WHERE 0 = 0
          AND VF.GLB_ROTA_CODIGO = tpVF.VFRotaUsuarioTDV
          AND NVL(VF.CON_VALEFRETE_IMPRESSO,'N') <> 'S' -- NAO IMPRESSO
          AND NVL(VF.CON_VALEFRETE_STATUS,'N') <> 'C' --NORMAL
          AND VF.CON_VALEFRETE_DATACADASTRO >= '01/08/2013';

        if tpVF.vAuxiliar > 0 Then
           if ( trunc(sysdate) - trunc(tpVF.vAuxiliarData) ) >= nvl(tpVf.vValefreteNaoImpQtdeDias,1) Then
              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := P_MESSAGE || 'Vales de Fretes Não Impressos !' || chr(10);
              P_MESSAGE := P_MESSAGE || 'Duvidas como Ricardo/Bruno !' || chr(10);
              P_MESSAGE := P_MESSAGE || '*******************************' || chr(10);
              FOR R_CURSOR In (Select Vf.Con_Conhecimento_Codigo Vale,
                                      vf.con_valefrete_saque Sq
                               From T_CON_VALEFRETE VF
                               Where 0 = 0
                                 and vf.glb_rota_codigo = tpVF.VFRotaUsuarioTDV
                                 and VF.CON_VALEFRETE_DATACADASTRO >= tpVF.vAuxiliarData
                                 AND NVL(VF.CON_VALEFRETE_IMPRESSO,'N') <> 'S' -- NAO IMPRESSO
                                  AND NVL(VF.CON_VALEFRETE_STATUS,'N') <> 'C') --NORMAL

              Loop
                   P_MESSAGE := P_MESSAGE || R_CURSOR.Vale || '-' || R_CURSOR.Sq || chr(10);
              End Loop;
                P_MESSAGE := P_MESSAGE || '*******************************' || chr(10);
           End If;
        End if;
     End If;



    begin
        tpVf.vLiberaComprovanteFrota := plistaparams('LIBCOMPFROTA').texto;
     exception
       when NO_DATA_FOUND Then
         tpVf.vLiberaComprovanteFrota := 'N';
       end;


    begin
        tpVf.vFCF_VEICULODISP_ROTATRAVAS := plistaparams('VALEFRETETRAVADO').texto;
     exception
       when NO_DATA_FOUND Then
         tpVf.vFCF_VEICULODISP_ROTATRAVAS := 'S';
       end;


    begin
        tpVf.vFCF_VEICULODISP_ALTERAFRETE := plistaparams('ALTERA_FRETE').texto;
     exception
       when NO_DATA_FOUND Then
         tpVf.vFCF_VEICULODISP_ALTERAFRETE := 'N';
       end;

     tpVf.vLiberaComprovanteFrota := nvl(tpVf.vLiberaComprovanteFrota,'N');

        -- Pegando o Maior Saque Valido
        Select Min(vf.con_valefrete_saque),
               Max(vf.con_valefrete_saque)
          Into tpVF.vPrimeiroSaque,
               tpVF.vUltimoSaqueValido
        From t_con_valefrete vf
        Where vf.con_conhecimento_codigo = tpVF.VFNumero
          And vf.con_conhecimento_serie  = tpVF.VFSerie
          And vf.glb_rota_codigo         = tpVF.VFRota
          and nvl(vf.con_valefrete_status,'N') = 'N';

        tpVF.vPrimeiroSaque :=  nvl(tpVF.vPrimeiroSaque,0);
        tpVF.vUltimoSaque   :=  nvl(tpVF.vUltimoSaque,0);
          -- Pega o Maior saque Criado
        Select Max(vf.con_valefrete_saque)
            Into tpVF.vUltimoSaque
        From t_con_valefrete vf
        Where vf.con_conhecimento_codigo = tpVF.VFNumero
          And vf.con_conhecimento_serie  = tpVF.VFSerie
          And vf.glb_rota_codigo         = tpVF.VFRota;


       BEGIN
          SELECT NVL(R.GLB_ROTA_CAIXA,'999')
            INTO tpVF.vRotaCaixa
          FROM T_GLB_ROTA R
          WHERE R.GLB_ROTA_CODIGO = tpVF.VFRota;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             tpVF.vRotaCaixa := '999';
          END ;

    -- Pega a ORIGEM do Vale de Frete
    tpVf.vCriadoPeloFIFO := null;
    vDataDeEntrega := null;
    vHoraDeEntrega := null;
     begin
      SELECT nvl(vf.Con_Valefrete_Fifo,'N')
        INTO tpVf.vCriadoPeloFIFO
         FROM tdvadm.T_CON_VALEFRETE VF
         Where VF.con_conhecimento_codigo = tpVF.VFNumero
           And VF.con_conhecimento_serie  = tpVF.VFSerie
           And VF.glb_rota_codigo         = tpVF.VFRota
           AND VF.CON_VALEFRETE_SAQUE     = TPvF.VFSaque;
      SELECT to_char(vf.con_valefrete_dataprazomax,'dd/mm/yyyy'),
             to_char(vf.con_valefrete_horaprazomax,'hh24:mi')
        INTO vDataDeEntrega,
             vHoraDeEntrega
         FROM tdvadm.T_CON_VALEFRETE VF
         Where VF.con_conhecimento_codigo = tpVF.VFNumero
           And VF.con_conhecimento_serie  = tpVF.VFSerie
           And VF.glb_rota_codigo         = tpVF.VFRota
           AND VF.CON_VALEFRETE_SAQUE     = TPvF.VFSaque;

   Exception
    When NO_DATA_FOUND Then
        tpVf.vCriadoPeloFIFO := 'N';
        vDataDeEntrega := null;
        vHoraDeEntrega := null;
    When OTHERS Then
        tpVf.vCriadoPeloFIFO := 'N';
        vDataDeEntrega := null;
        vHoraDeEntrega := null;
   End;
   
   If ( substr(tpVF.VFCON_VALEFRETE_PLACA,1,3) = '000' )  Then
              -- pega o Motorista
      begin
         select distinct  mm.frt_motorista_cpf,
                DECODE(F.FUCODCARGO,231,'TRUCK',
                                    001,'CAR',
                                    629,'MTC',
                                    45065,'UTL',F.FUCODCARGO)
             into tpvf.vfCON_VALEFRETE_CARRETEIRO,
                  tpvf.vfCARGO_MOTORISTA
         from tdvadm.t_frt_conjunto cj,
              tdvadm.t_frt_motorista mm,
              fpw.funciona f
         where cj.frt_motorista_codigo = mm.frt_motorista_codigo
           and cj.frt_conjveiculo_codigo = substr(tpVF.VFCON_VALEFRETE_PLACA,1,7)
           and mm.frt_motorista_matricula = f.fumatfunc (+)
           and mm.frt_motorista_cpf is not null;
      exception
         when NO_DATA_FOUND Then
              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := P_MESSAGE || '10a - Erro ao Buscar Motorista Frota, Verifique o Conjunto.' || substr(tpVF.VFCON_VALEFRETE_PLACA,1,7) || chr(10);
         end;   
    End If;
   
   If tpVF.VFAcao in ('Criando','ConcluindoCriando') Then
      tpVF.vAuxiliar := 0;
      If tpVF.VFCON_CATVALEFRETE_CODIGO in (CatTBonusManifesto,CatTBonusCTRC) Then
      
         select count(*)
            into tpVF.vAuxiliar
         From t_con_valefrete vf
        Where vf.con_conhecimento_codigo = tpVF.VFNumero
           And vf.con_conhecimento_serie  = tpVF.VFSerie
           And vf.glb_rota_codigo         = tpVF.VFRota
           and vf.con_catvalefrete_codigo in  (CatTBonusManifesto,CatTBonusCTRC)
           and nvl(vf.con_valefrete_status,'N') = 'N'; -- normal
 
         if tpVF.vAuxiliar > 0  Then
            P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
           P_MESSAGE := P_MESSAGE || 'Vale de frete Ja tem Bonus, Cancele antes de fazer outro.' || chr(10);
          End if;
    End IF;      
   End If;
        If tpVF.VFAcao = 'SaldoCarreito' Then

           tpVF.vXmlTab :=           '<parametros><output>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';

           P_XMLOUT := tpVF.vXmlTab;
           Return;

        ElsIf tpVF.VFAcao In ('RetTab') Then
           P_STATUS  := pkg_glb_common.Status_Nomal;
              if tpVF.VFVersaoAplicao = '13.1.23.1' Then
                 P_MESSAGE := ' ' ; -- Processamento normal!';
              Else
                 P_MESSAGE := '' ; -- Processamento normal!';
              end if;
           P_XMLOUT := '';
           EXECUTE immediate('ALTER SESSION SET nls_date_format = "DD/MM/YYYY HH24:MI:SS"');
           open vCursor for select *
                            From t_con_valefrete vf
                            Where vf.con_conhecimento_codigo = tpVF.VFNumero
                              And vf.con_conhecimento_serie  = tpVF.VFSerie
                              And vf.glb_rota_codigo         = tpVF.VFRota
                            order by vf.con_valefrete_saque  ;
 --                              And vf.con_valefrete_saque     = tpVF.vUltimoSaqueValido


           -- Crio um XML a partir de um Cursor
           pkg_glb_xml.sp_getxmltable('ValeFrete',vCursor,vXmlTabOutxml,P_STATUS,P_MESSAGE);


           EXECUTE immediate('ALTER SESSION SET nls_date_format = "DD/MM/YYYY"');
           tpVF.vXmlTab :=           '<parametros><output>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';

           P_XMLOUT := tpVF.vXmlTab;


           Return ;

        ElsIf tpVF.VFAcao In ('ConcluindoCriando') Then


           if ( tpVF.VFCON_CATVALEFRETE_CODIGO = CatTServicoTerceiro ) and ( substr(tpVF.VFCON_VALEFRETE_PLACA,1,3) = '000') Then
               wservice.pkg_glb_email.SP_ENVIAEMAIL('VALE FRETE DE TERCEIRO, NOITE DA PIZZA',tpVF.VFNumero || '-' || tpVF.VFrota,'aut-e@dellavolpe.com.br','sdrumond@dellavolpe.com.br;ezpereira@dellavolpe.com.br');
           End If;

                  -- verifica se falta comprovante de entrega
           If ( substr(tpVF.VFCON_VALEFRETE_PLACA,1,3) <> '000' )  Then
             Begin
               select max(vf.con_valefrete_saque)
                 into tpVF.vUltimoSaque
               from t_con_valefrete vf
               Where vf.con_conhecimento_codigo = tpVF.VFNumero
                 And vf.con_conhecimento_serie  = tpVF.VFSerie
                 And vf.glb_rota_codigo         = tpVF.VFRota;

               select vf.con_valefrete_carreteiro
                  into tpvf.vfCON_VALEFRETE_CARRETEIRO
               from t_con_valefrete vf
               Where vf.con_conhecimento_codigo = tpVF.VFNumero
                 And vf.con_conhecimento_serie  = tpVF.VFSerie
                 And vf.glb_rota_codigo         = tpVF.VFRota
                 And vf.con_valefrete_saque     = tpVF.vUltimoSaque;

             Exception
               When NO_DATA_FOUND Then
                   tpvf.vfCON_VALEFRETE_CARRETEIRO := null;
                   tpVF.vUltimoSaque := 0;
               End; 
           End If;


/*            if tpVF.VFNumero = '595294' then
              P_MESSAGE := P_MESSAGE || tpvf.vfCON_VALEFRETE_CARRETEIRO|| chr(10) ; 
              P_MESSAGE := P_MESSAGE || tpVF.VFCON_VALEFRETE_PLACA|| chr(10) ; 
              P_MESSAGE := P_MESSAGE || tpVF.vUltimoSaque || chr(10) ;
              return;
            end if;
*/            
                      tpVF.vAuxiliar := 0;
 --             tpvf.vfCON_VALEFRETE_CARRETEIRO := '06045040805';
              FOR R_CURSOR In (Select V.*
                               From v_con_conhecentrega v
                               Where 0 = 0
 --                                and v.placa = substr(tpVF.VFCON_VALEFRETE_PLACA,1,7)
                                 and v.cpf = tpvf.vfCON_VALEFRETE_CARRETEIRO
                                 and v.embarque >= '01/01/2015'
                                 and v.embarque < trunc(sysdate)
                                 And V.ENTREGA Is Null
                                 and v.VALE = tpVF.VFNumero
                                 and v.RTVALE = tpVF.VFRota
                                 and v.saque <= tpVF.VFSaque
                                 And V.Transferencia In ('Fora do Fifo', 'Não')
                               ORDER BY V.EMBARQUE,V.rtctrc,V.ctrc )
                Loop
                   tpVF.vAuxiliar := tpVF.vAuxiliar + 1;
                   P_MESSAGEAUX := P_MESSAGEAUX || TO_CHAR(R_CURSOR.EMBARQUE,'DD/MM/YYYY') || '-' || R_CURSOR.CTRC || '-' || R_CURSOR.RTCTRC || CHR(10);
                End Loop;
                if tpVF.VFusuarioTDV = 'jsantos' Then
                   tpVF.vAuxiliar := 0;
                End IF; 
              If tpVF.vAuxiliar > 0 Then
                 P_MESSAGE := P_MESSAGE || chr(10) || ' RELACAO DE ' || TO_CHAR(tpVF.vAuxiliar)  ||  ' CTRC ' || chr(10) || 'SEM COMPROVANTE DE ENTREGA BAIXADOS' || CHR(10) ;
                 P_MESSAGE := P_MESSAGE ||            ' CPF ' || tpvf.vfCON_VALEFRETE_CARRETEIRO || ' Vale Frete ' || tpVF.VFNumero || '-' || tpVF.VFRota  || chr(10);
                 P_MESSAGE := P_MESSAGE || P_MESSAGEAUX ;
                 
/*                 delete t_con_vfreteconhec vf
                 Where vf.con_conhecimento_codigo = tpVF.VFNumero
                   And vf.con_conhecimento_serie  = tpVF.VFSerie
                   And vf.glb_rota_codigo         = tpVF.VFRota
                   And vf.con_valefrete_saque     = tpVF.vUltimoSaque;
                   
                 delete t_mon_controlesosfirst  vf 
                 Where vf.con_conhecimento_codigo = tpVF.VFNumero
                   And vf.con_conhecimento_serie  = tpVF.VFSerie
                   And vf.glb_rota_codigo         = tpVF.VFRota
                   And vf.con_valefrete_saque     = tpVF.vUltimoSaque;

                 delete t_con_valefrete vf
                 Where vf.con_conhecimento_codigo = tpVF.VFNumero
                   And vf.con_conhecimento_serie  = tpVF.VFSerie
                   And vf.glb_rota_codigo         = tpVF.VFRota
                   And vf.con_valefrete_saque     = tpVF.vUltimoSaque;
*/                 
                 If nvl(trim(P_STATUS),'N') <> PKG_GLB_COMMON.Status_Erro Then
                    if tpVF.vLiberaComprovanteFrota = 'S' Then
                       P_STATUS := PKG_GLB_COMMON.Status_Warning;
                    Else
                       P_STATUS := PKG_GLB_COMMON.Status_Erro;
                       P_MESSAGE := P_MESSAGE || 'ERRO AO PROCESSAR ->' || tpVF.vLiberaComprovanteFrota;
                    End if;
                 End If;
                 tpVF.vFaltaComprovante := 'S';
              Else
                 tpVF.vFaltaComprovante := 'N';
              End If;

        end if;




        if tdvadm.pkg_glb_menutdv.fn_vld_AppVersionDB('comvlfrete',tpVF.VFVersaoAplicao) <> 'S' Then
           if tpVF.VFVersaoAplicao <> '123456' Then
              select ap.usu_aplicacao_versao
                into tpVF.vConvfersao
              From tdvadm.t_usu_aplicacao ap
              where ap.usu_aplicacao_codigo = 'comvlfrete';
              
              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := P_MESSAGE || '11- Vale frete com versão desatualizada!, Versão servidor v:'||trim(tpVF.vConvfersao)||' Versão local v:'||trim(tpVF.VFVersaoAplicao)|| '.' || chr(10);
           end if;
        End if;

      -- Pegar alguma configurações e Criticar os comprovantes para os Frotas

          -- Verifica se a Categoria paga Pedagio for S o Zera Pedagio e igual a N
        tpVF.vZeraPedagio := fni_vld_PagaPedagio(tpVF.VFCON_CATVALEFRETE_CODIGO);


      If tpVF.VFAcao Not In ('Criando','ConcluindoCriando','Consulta','AtualizaSaldo') Then


          -- Preenche o Tipo do Vale Passado
          Begin
             Select vf.*
             Into tpVF.tpValeFrete
             From T_CON_VALEFRETE VF
             Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
               And VF.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
               And VF.GLB_ROTA_CODIGO         = tpVF.VFRota
               And VF.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;






             tpVF.tpValeFrete.con_valefrete_impresso := nvl(tpVF.tpValeFrete.con_valefrete_impresso,'N');
             tpVF.tpValeFrete.con_valefrete_status   := nvl(tpVF.tpValeFrete.con_valefrete_status,'N');
             tpVF.tpValeFrete.CON_VALEFRETE_BERCONF  := trim(tpVF.tpValeFrete.CON_VALEFRETE_BERCONF);
             -- caso os parametros entrarem por QueryString
             If tpVF.VFCON_CATVALEFRETE_CODIGO = '' Then
                tpVF.VFCON_CATVALEFRETE_CODIGO  := tpVF.tpValeFrete.Con_Catvalefrete_Codigo;
                tpVF.VFCON_VALEFRETE_PLACA      := tpVF.tpValeFrete.Con_Valefrete_Placa;
                tpVF.VFCON_VALEFRETE_PLACASAQUE := tpVF.tpValeFrete.Con_Valefrete_Placasaque;
             End If;


          Exception
            When NO_DATA_FOUND Then
                 P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                 P_MESSAGE := P_MESSAGE || '01-Vale de Frete não encontrado' || chr(10) ||
                              'VF - ' || tpVF.VFNumero || chr(10) ||
                              'SR - ' || tpVF.VFSerie  || chr(10) ||
                              'RT - ' || tpVF.VFRota   || chr(10) ||
                              'SQ - ' || tpVF.VFSaque  || chr(10);
            When Others Then
                 P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                 P_MESSAGE := P_MESSAGE || '02-Ocorreu um Erro Não Esperado '|| chr(10) ||
                              'VF - ' || tpVF.VFNumero || chr(10) ||
                              'SR - ' || tpVF.VFSerie  || chr(10) ||
                              'RT - ' || tpVF.VFRota   || chr(10) ||
                              'SQ - ' || tpVF.VFSaque  || chr(10) ||
                              Trim(Sqlerrm);
          End;
         

        -- Pega o Proprietario

       Begin
          Select v.car_proprietario_cgccpfcodigo,
                 p.car_proprietario_tipopessoa
            Into tpVF.v_Proprietario,
                 tpVf.v_TpProprietario
           From t_car_veiculo v,
                t_Car_Proprietario p
           Where v.car_veiculo_placa = tpVF.tpValeFrete.Con_Valefrete_Placa
             And v.car_veiculo_saque = tpVF.tpValeFrete.Con_Valefrete_Placasaque
             and v.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo;
          Exception
            When NO_DATA_FOUND Then
               tpVF.v_Proprietario := '61139432000172';
          End;



        If tpVF.VFAcao = 'Imprimir' Then


           If tpvf.vfCARGO_MOTORISTA = 'UTL' Then
              tpVF.vPodeImprimir := 'N';
              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := P_MESSAGE || 'Vale de Frete de Utilitario nao pode ser impresso.' || chr(10);
              update tdvadm.t_con_valefrete vf
                set vf.con_valefrete_impresso = 'S'
              where vf.con_conhecimento_codigo = tpVF.VFNumero 
                and vf.con_conhecimento_serie = tpVF.VFSerie
                and vf.glb_rota_codigo = tpVF.VFRota
                and vf.con_valefrete_saque = tpVF.VFSaque ;
                commit;
           End If;
             

            -- verifica se o Veiculo Disp ja existe em outro Vale de Frete.
            select count(*)
              into tpVf.vAuxiliar
            from tdvadm.t_con_valefrete vf
            where vf.fcf_veiculodisp_codigo = tpVF.tpValeFrete.fcf_veiculodisp_codigo
              and vf.fcf_veiculodisp_sequencia = tpVF.tpValeFrete.fcf_veiculodisp_sequencia 
              and vf.con_conhecimento_codigo <> tpVF.VFNumero
              and vf.glb_rota_codigo <> tpVF.VFRota ;
             
            If tpVf.vAuxiliar > 0 Then
                tpVF.vPodeImprimir := 'N';
                P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                P_MESSAGE := P_MESSAGE || 'Veiculo disponivel usando em outro Vale de Frete [' || tpVF.tpValeFrete.fcf_veiculodisp_codigo || ']' || chr(10);
            End If;
            
---------------------------------------------------------------------------
-------------Validação abaixo desabilitada a pedido do Chaves--------------
---------------------Rafael Aiti 18/04/2019--------------------------------
---------------------------------------------------------------------------

/*            select count(*)
              into tpVf.vAuxiliar
            from tdvadm.t_con_valefrete vf
            Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
              And VF.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
              And VF.Glb_Rota_Codigo         = tpVF.VFRota
              And VF.CON_VALEFRETE_SAQUE     = tpVF.VFSaque
              and vf.con_valefrete_fifo      = 'S';

            If tpVf.vAuxiliar > 0 Then

             select count(*)
                 into tpVf.vAuxiliar
               from tdvadm.t_con_vfreteconhec vf,
                    tdvadm.t_con_conhecimento c
               Where VF.CON_VALEFRETE_CODIGO     = tpVF.VFNumero
                 And VF.Con_Valefrete_Serie      = tpVF.VFSerie
                 And VF.GLB_ROTA_CODIGOVALEFRETE = tpVF.VFRota
                 And VF.CON_VALEFRETE_SAQUE      = tpVF.VFSaque
                 and vf.con_conhecimento_codigo = c.con_conhecimento_codigo
                 and vf.con_conhecimento_serie = c.con_conhecimento_serie
                 and vf.glb_rota_codigo = c.glb_rota_codigo
                 and c.arm_carregamento_codigo is not null
                 and 0 = (select count(*)
                          from tdvadm.t_arm_notacte nc
                          where nc.con_conhecimento_codigo = c.con_conhecimento_codigo
                            and nc.con_conhecimento_serie = c.con_conhecimento_serie
                            and nc.glb_rota_codigo = c.glb_rota_codigo
                            and nc.arm_notacte_codigo = 'CO');
              
               select count(*)
                 into tpVf.vAuxiliar2
               from tdvadm.t_arm_carregamento ca,
                    tdvadm.t_con_conhecimento c
               where ca.arm_carregamento_codigo = c.arm_carregamento_codigo
                 and ca.fcf_veiculodisp_codigo = tpVF.tpValeFrete.fcf_veiculodisp_codigo
                 and ca.fcf_veiculodisp_sequencia = tpVF.tpValeFrete.fcf_veiculodisp_sequencia
                 and 0 = (select count(*)
                          from tdvadm.t_arm_notacte nc
                          where nc.con_conhecimento_codigo = c.con_conhecimento_codigo
                            and nc.con_conhecimento_serie = c.con_conhecimento_serie
                            and nc.glb_rota_codigo = c.glb_rota_codigo
                            and nc.arm_notacte_codigo = 'CO');
            
            
               If ( tpVf.vAuxiliar <> tpVf.vAuxiliar2) and ( tpVF.VFNumero not in ('881357') )  Then

                   tpVF.vPodeImprimir := 'N';
                   P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                   P_MESSAGE := P_MESSAGE || 'Quantidade de CTe do Veiculo Disp Diferente da Quantidade no Vale de Frete' || chr(10);
                 
               End If;
                 
            End IF;
*/

           /********************************************************/
           /***  analise de pedido de cancelamento de CTe        ***/
           /***  Qtde de CTe ou NFe não autorizadas              ***/
           /***  Cte não Averbados                               ***/
           /********************************************************/
           Begin


             vQtdeTotalCancel    := 0;
             vQtdeCteNautorizado := 0;
             vListaNaoAutorizados := '';
             vListaPedidoCancel   := '';
             
            select count(*)
              into vViagemCiot
              from t_con_vfreteciot vf
             where vf.con_conhecimento_codigo = tpVF.VFNumero
               and vf.con_conhecimento_serie  = tpVF.VFSerie
               and vf.glb_rota_codigo         = tpVF.VFRota
               and vf.con_valefrete_saque     = tpVF.VFSaque;
             
             
             vListaNaoAutorizados := '';
             for c_cursor in (select vf.con_conhecimento_codigo,
                                     vf.con_conhecimento_serie,
                                     vf.glb_rota_codigo,
                                     c.con_conhecimento_dtembarque,
                                     tdvadm.fn_busca_conhec_verba(vf.con_conhecimento_codigo,
                                                                  vf.con_conhecimento_serie,
                                                                  vf.glb_rota_codigo,
                                                                  'I_VLMR') VLRMERC                        
                                from tdvadm.t_con_vfreteconhec vf,
                                     tdvadm.t_con_conhecimento c
                               where vf.con_valefrete_codigo     = tpVF.VFNumero
                                 and vf.con_valefrete_serie      = tpVF.VFSerie
                                 and vf.glb_rota_codigovalefrete = tpVF.VFRota
                                 and vf.con_valefrete_saque      = tpVF.VFSaque
                                 and vf.con_conhecimento_codigo  = c.con_conhecimento_codigo
                                 and vf.con_conhecimento_serie   = c.con_conhecimento_serie
                                 and vf.glb_rota_codigo          = c.glb_rota_codigo)
             loop

               select count(*)
                 into vExisteCancel
                 from t_con_eventocte ll
                where ll.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
                  and ll.con_conhecimento_serie  = c_cursor.con_conhecimento_serie
                  and ll.glb_rota_codigo         = c_cursor.glb_rota_codigo
                  and ll.glb_eventosefaz_codigo  = '4';

               vQtdeTotalCancel := vQtdeTotalCancel+ vExisteCancel;
               If vExisteCancel > 0 Then
                 vListaPedidoCancel := vListaPedidoCancel || c_cursor.con_conhecimento_codigo || '-' || 
                                                             c_cursor.con_conhecimento_serie  || '-' || 
                                                             c_cursor.glb_rota_codigo         || '-' || chr(10);
               End If;

               if pkg_con_cte.FN_CTE_EELETRONICO(c_cursor.con_conhecimento_codigo,c_cursor.con_conhecimento_serie,c_cursor.glb_rota_codigo) = 'N' Then
                  vQtdeCteNautorizado := vQtdeCteNautorizado + 1;
                  vListaNaoAutorizados := vListaNaoAutorizados || c_cursor.con_conhecimento_codigo || '-' || c_cursor.con_conhecimento_serie ||'-' || c_cursor.glb_rota_codigo || chr(10);
               Else
                  if vExisteCancel = 0 Then
                     vTemAverbacao := 0;
                     vTemErroAverbacao := 0;
                     vErroAverbacao := '';
                     If ( tdvadm.pkg_slf_calculos.F_BUSCA_CONHEC_TPFORMULARIO(c_cursor.con_conhecimento_codigo,
                                                                              c_cursor.con_conhecimento_serie,
                                                                              c_cursor.glb_rota_codigo) = 'CTRC' ) and
                        ( c_cursor.con_conhecimento_dtembarque >= to_date('01/09/2017') ) Then
                        Begin
                            select ea.con_erroaverbacao_msgerro erro,
                                   sum(nvl(ea.con_erroaverbacao_id,0)) erroaverbacao,
                                   sum(nvl(av.con_averbacao_id,0)) averbado
                              into vErroAverbacao,
                                   vTemErroAverbacao,
                                   vTemAverbacao
                            FROM TDVADM.T_CON_CONTROLECTRCE L,
                                 TDVADM.T_CON_AVERBACAO AV
                                 -- Pode existir uma averbação com erro, caso ocorra tera registro somente nesta tabela
                                 ,TDVADM.t_Con_Erroaverbacao ea
                           WHERE 0 = 0
                             --AND L.CON_CONTROLECTRCE_CHAVESEFAZ IN ('31170961139432007002571970008852491601359948','31170961139432007002571970008852481644580797','31170961139432007002571970008849401511967513','31170961139432007002571970008852501867798340','31170961139432007002571970008852441517681420','31170961139432007002571970008852461760100211','31170961139432007002571970008852471377155146')
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = AV.CON_AVERBACAO_CHAVECTE (+)
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = ea.con_erroaverbacao_chavecte  (+)
                             and l.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
                             and l.con_conhecimento_serie = c_cursor.con_conhecimento_serie
                             and l.glb_rota_codigo = c_cursor.glb_rota_codigo
                           group by ea.con_erroaverbacao_msgerro;
                       Exception
                         When NO_DATA_FOUND Then
                             vErroAverbacao := 1;
                             vErroAverbacao := 'Registro não Encontrado na Tabela de Averbação';
                             vTemAverbacao  := 0;
                         When TOO_MANY_ROWS Then
                            select ea.con_erroaverbacao_msgerro erro,
                                   sum(nvl(ea.con_erroaverbacao_id,0)) erroaverbacao,
                                   sum(nvl(av.con_averbacao_id,0)) averbado
                              into vErroAverbacao,
                                   vTemErroAverbacao,
                                   vTemAverbacao
                            FROM TDVADM.T_CON_CONTROLECTRCE L,
                                 TDVADM.T_CON_AVERBACAO AV
                                 -- Pode existir uma averbação com erro, caso ocorra tera registro somente nesta tabela
                                 ,TDVADM.t_Con_Erroaverbacao ea
                           WHERE 0 = 0
                             --AND L.CON_CONTROLECTRCE_CHAVESEFAZ IN ('31170961139432007002571970008852491601359948','31170961139432007002571970008852481644580797','31170961139432007002571970008849401511967513','31170961139432007002571970008852501867798340','31170961139432007002571970008852441517681420','31170961139432007002571970008852461760100211','31170961139432007002571970008852471377155146')
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = AV.CON_AVERBACAO_CHAVECTE (+)
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = ea.con_erroaverbacao_chavecte  (+)
                             and l.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
                             and l.con_conhecimento_serie = c_cursor.con_conhecimento_serie
                             and l.glb_rota_codigo = c_cursor.glb_rota_codigo
                             and ea.con_erroaverbacao_dtcadastro = (select max(ea1.con_erroaverbacao_dtcadastro)
                                                                    from TDVADM.t_Con_Erroaverbacao ea1
                                                                    where ea1.con_erroaverbacao_chavecte = ea.con_erroaverbacao_chavecte) 
                           group by ea.con_erroaverbacao_msgerro;
                            
                         When OTHERS Then
                             vErroAverbacao := 1;
                             vErroAverbacao := 'Retornou mais de Um Registro na pesquisa da Averbação';
                             vTemAverbacao  := 0;
                         End;    
                       If vTemAverbacao = 0 Then
                          vListaNaoAverbados := vListaNaoAverbados || c_cursor.con_conhecimento_codigo || '-' || 
                                                                      c_cursor.glb_rota_codigo         || '-' ||
                                                                      tdvadm.f_mascara_valor(c_cursor.VLRMERC,12,2) || chr(10);
                          If vTemErroAverbacao <> 0 Then
                             vListaNaoAverbados := vListaNaoAverbados || '   Erro - ' || trim(vErroAverbacao) || chr(10);
                          End If;

                       End IF;
                     End If;
                  End If;
               End If;                    
             end loop;
             
             If Length(trim(vListaNaoAverbados)) <> 0 Then
                vListaNaoAverbados := 'CTe´ Não Averbados' || chr(10) || vListaNaoAverbados;
                If vRotaSemAverbacao = 'N' Then                
                   P_STATUS :=  tdvadm.PKG_GLB_COMMON.Status_Erro;
                   P_MESSAGE := P_MESSAGE || vListaNaoAverbados;
                End If;
                wservice.pkg_glb_email.SP_ENVIAEMAIL('AVERBACAO',
                                                     vListaNaoAverbados,
                                                     'aut-e@dellavolpe.com.br',
                                                     'ksouza@dellavolpe.com.br;sdrumond@dellavolpe.com.br;emsouza@dellavolpe.com.br');
             End If;

             if (vQtdeTotalCancel > 0)  then
                  tpVF.vPodeImprimir := 'N';
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || 'Existem CTé(s) nesse vale frete com solicitação de cancelamento |||' || chr(10) || vListaPedidoCancel;
             end if;

  

             select vf.con_valefrete_datacadastro
               into tpVF.vAuxiliarData
             from tdvadm.t_con_valefrete vf
             where vf.con_conhecimento_codigo = tpVF.VFNumero
               and vf.con_conhecimento_serie  = tpVF.VFSerie
               and vf.glb_rota_codigo         = tpVF.VFRota
               and vf.con_valefrete_saque     = tpVF.VFSaque;


             if (vQtdeCteNautorizado > 0) and ( tpVF.vAuxiliarData >= add_months(sysdate,-60) )  then
                  tpVF.vPodeImprimir := 'N';
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || 'Existem CTé(s) não Autorizados na SEFAZ |||' || chr(10) || vListaNaoAutorizados;
             end if;


           end;
           /********************************************************/

        
    
                   -- Verifica se as Verbas estão calculadas
               Select Count(*)
                    Into tpVF.vAuxiliar
               From t_con_calcvalefrete vf
               Where vf.con_conhecimento_codigo = tpVF.VFNumero
                 And vf.con_conhecimento_serie  = tpVF.VFSerie
                 And vf.glb_rota_codigo         = tpVF.VFRota
                 And vf.con_valefrete_saque     = tpVF.VFSaque;

               if  tpVF.vAuxiliar = 0 Then
                  If tpvf.VFCON_CATVALEFRETE_CODIGO in (CatTServicoTerceiro) then
                     tdvadm.PKG_CON_VALEFRETE.SP_CON_ATUCALCVALEFRETE(vC_QRYSTR,vStatus,vMessage2,vCursor);
                  Else
                     P_STATUS := pkg_glb_common.Status_Erro;
                      P_MESSAGE := P_MESSAGE || 'Verbas Não Calculada entre na ABA do FRETE ELETRONICO!' || chr(10);
                  End If;
 
               End If;

            -- Verifica se Tem Ciot e Não gerou as Tarifas
           Select sum(vf.con_calcvalefrete_valor)
                Into tpVF.vAuxiliar
           From t_con_calcvalefrete vf
           Where vf.con_conhecimento_codigo = tpVF.VFNumero
             And vf.con_conhecimento_serie  = tpVF.VFSerie
             And vf.glb_rota_codigo         = tpVF.VFRota
             And vf.con_valefrete_saque     = tpVF.VFSaque
             and vf.con_calcvalefretetp_codigo in ('06','07');

             If ( tpVF.vAuxiliar > 0 )  and ( vViagemCiot = 0 ) Then
                P_STATUS := pkg_glb_common.Status_Erro;
                P_MESSAGE := P_MESSAGE || 'Vale de Frete SEM CIOT e Com TARIFAS CALCULADAS INFORMAR A TI' || chr(10);
             ElsIf ( tpVF.vAuxiliar = 0 )  and ( vViagemCiot <> 0 ) Then
                P_STATUS := pkg_glb_common.Status_Erro;
                P_MESSAGE := P_MESSAGE || 'Vale de Frete COM CIOT e Com TARIFAS NAO CALCULADAS INFORMAR A TI' || chr(10);
             end If;
             
             
             --12/05/2016
             if tpvf.VFCON_CATVALEFRETE_CODIGO = CatTEstadia Then

               
--                tpVf.vAuxiliarTexto := 'R';
                
                If SUBSTR(vCATVFRETE,17,1) = 'N' Then
                
                    if    trim(tpVf.vAuxiliarTexto) = 'N' Then -- N = 
                       P_MESSAGE :=  P_MESSAGE || chr(10) || vStatusEstadia ;
                       P_STATUS := 'E';
                    ElsIf trim(tpVf.vAuxiliarTexto) = 'P' Then
                       P_MESSAGE := P_MESSAGE || chr(10) || vStatusEstadia;
                       P_STATUS := 'E';
                    ElsIf trim(tpVf.vAuxiliarTexto) = 'R' Then
                       P_MESSAGE := P_MESSAGE || chr(10) || vStatusEstadia;
                       P_STATUS := 'E';
                    ElsIf trim(tpVf.vAuxiliarTexto) = 'A' Then
                       P_MESSAGE := P_MESSAGE || chr(10) || vStatusEstadia;
                    End IF;

                    P_MESSAGE := P_MESSAGE || chr(10) || vMessage;
                
                End IF;
                

             End If; 



           -- Verifica
           /**************************************************************************/
           /* Fabiano: 19/02/2014                                                    */
           /* Adicionei a condição de categorias obrigatórias a verificação de Bonus */
           /*   quando for Frota                                                     */
           /**************************************************************************/
 
              -- 01/04/2021
              -- Sirlano 
              -- Inclui a Validade de pegar o codigo de verificar se em algum contrato do vale de Frete
              -- Tem o Flag de não descontar Bonus do Frota.   
              select NVL(MAX(cr.slf_clienteregras_bonus),'S') bonus,NVL(MAx(cr.slf_clienteregras_bonusfrota),'S') bonusfrota
                 into tpVF.vDescBonus,
                      tpVF.vDescBonusFrota 
              from tdvadm.t_slf_clienteregras cr
              where 0 = 0
                and cr.slf_contrato_codigo in (select trim(pkg_slf_utilitarios.fn_retorna_contratoCod(vfc.CON_CONHECIMENTO_CODIGO,
                                                                                                      vfc.CON_CONHECIMENTO_SERIE,
                                                                                                      vfc.GLB_ROTA_CODIGO)) contrato
                                               from tdvadm.t_con_vfreteconhec vfc
                                               where vfc.con_valefrete_codigo     = tpVF.VFNumero
                                                 and vfc.con_valefrete_serie      = tpVF.VFSerie
                                                 and vfc.glb_rota_codigovalefrete = tpVF.VFRota
                                                 and vfc.con_valefrete_saque      = tpVF.VFSaque
                                                -- 27/04/2021
                                                -- Sirlano
                                                -- Inclui a validadcao de pegar o contato quando o Vale de Frete
                                                -- Contem somente coletas.
                                                union
                                                select trim(m.slf_contrato_codgo) contrato
                                                from tdvadm.t_fcf_fretecarmemo m 
                                                where m.con_valefrete_codigo = tpVF.VFNumero
                                                  and m.con_valefrete_serie  = tpVF.VFSerie
                                                  and m.glb_rota_codigo      = tpVF.VFRota
                                                  and m.con_valefrete_saque  = tpVF.VFSaque
                                                union
                                                select trim(m.slf_contrato_codgo) contrato
                                                from tdvadm.t_fcf_fretecarmemo m 
                                                where m.con_valefrete_codigo2 = tpVF.VFNumero
                                                  and m.con_valefrete_serie2  = tpVF.VFSerie
                                                  and m.glb_rota_codigo2      = tpVF.VFRota
                                                  and m.con_valefrete_saque2  = tpVF.VFSaque
                                                )
                and ( nvl(cr.slf_clienteregras_bonus,'N') = 'N'
                   or nvl(cr.slf_clienteregras_bonusfrota,'N') = 'N');

           begin

               if ( tpVF.vPrimeiroSaque = tpvf.VFSaque )  and  -- Primeiro Saque Valido
                  ( ( tpVF.vDescBonus = 'N' ) or ( tpVF.vDescBonusFrota = 'S' )  ) and
                  ( tpVf.VFRota <> '026' ) and
                  ( tpVF.VFRota < '900' ) Then
                  If (tpVF.v_Proprietario = '61139432000172') and 
                     ( tpvf.vfCARGO_MOTORISTA <> 'UTL') and
                     ( tpVF.vDescBonusFrota = 'S') 
                     then -- É Frota
                    if (tpVF.VFCON_CATVALEFRETE_CODIGO in (CatTUmaViagem, CatTAvulsoCCTRC)) Then -- categorias que obrigam a verificação de bonus

                       select count(*)
                         into tpVF.vAuxiliar
                       from t_con_valefrete vf
                       Where vf.con_conhecimento_codigo = tpVF.VFNumero
                         And vf.con_conhecimento_serie  = tpVF.VFSerie
                         And vf.glb_rota_codigo         = tpVF.VFRota
                         and nvl(vf.con_valefrete_status,'N') = 'N'
                         and nvl(vf.con_valefrete_descbonus,'N') = 'S';

                       if nvl(tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao,'NADA') not in ('PRMOTORISTA','CARVAOFROTA') Then
                          if tpVF.vAuxiliar = 0 then
                             P_STATUS := pkg_glb_common.Status_Erro;
                             P_MESSAGE := P_MESSAGE || 'Emissao de VF com BONUS OBRIGATORIO para FROTA!' || chr(10);
                          End If;
                       End If;

                    End If; -- categorias
                  End If; -- é Frota
               End If; -- primeiro saque, rota <> 026, Rota < 900

           end;

         /**************************************************************************/
         /*         bloqueio para verificar se o mdfe foi emitido                  */
         /*         klayton em 09/01/2014                                          */
         /**************************************************************************/

         begin

           if (tpVF.VFRota = '999') then

             if ( tpVF.vPrimeiroSaque            =  tpvf.VFSaque ) and  -- Primeiro Saque Valido
                ( tpVf.VFRota                    <> '026'       ) and  -- Não verifica rota 026
                ( tpVF.VFRota                    <  '900'        ) and  -- Não verifica rota abaixo 900
                ( tpVF.VFCON_CATVALEFRETE_CODIGO in (CatTUmaViagem,CatTAvulsoCCTRC) ) and -- Categorias
                ( PKG_CON_MDFE.fn_Con_MdfeTpAmb(tpvf.VFRota) = '1') Then           -- Se é rota de Mdfe

                vParametros := '<Parametros>                                                              '||
                               '  <Input>                                                                 '||
                               '    <VFUsuarioTDV>'    ||trim(tpVF.VFusuarioTDV)    ||'</VFUsuarioTDV>    '||
                               '    <VFRotaUsuarioTDV>'||trim(tpVF.VFRotaUsuarioTDV)||'</VFRotaUsuarioTDV>'||
                               '    <VFAplicacaoTDV>'  ||'comvlfrete'               ||'</VFAplicacaoTDV>  '||
                               '    <VFVersaoAplicao>' ||trim(tpVF.VFVersaoAplicao) ||'</VFVersaoAplicao> '||
                               '  </Input>                                                                '||
                               '</Parametros>                                                             ';

                  if (tpVF.VFRota = '999') then

                    Sp_Con_Validavfretemdfenew(tpVF.VFNumero,
                                               tpVF.VFSerie,
                                               tpVF.VFRota,
                                               tpVF.VFSaque,
                                               vParametros,
                                               vStatus,
                                               vMessage);


                  else

                    Sp_Con_Validavfretemdfe(tpVF.VFNumero,
                                            tpVF.VFSerie,
                                            tpVF.VFRota,
                                            tpVF.VFSaque,
                                            vParametros,
                                            vStatus,
                                            vMessage);

                  end if;

                if (nvl(trim(vStatus),'N') <> pkg_glb_common.Status_Nomal) then
                    P_STATUS  := pkg_glb_common.Status_Erro;
                    P_MESSAGE := P_MESSAGE || vMessage || chr(10);
                Else
                  select count(*)
                    into tpVF.vAuxiliar
                  from t_con_vfreteconhec v
                  where v.con_valefrete_codigo = tpVF.VFNumero
                    and v.con_valefrete_serie  = tpVF.VFSerie
                    and v.glb_rota_codigovalefrete = tpVF.VFRota
                    and v.con_valefrete_saque  = tpVF.VFSaque
                    and PKG_CON_CTE.FN_CTE_EELETRONICO(v.con_conhecimento_codigo,
                                                       v.con_conhecimento_serie,
                                                       v.glb_rota_codigo) = 'N';
                   if tpVF.vAuxiliar <> 0 Then
                      P_STATUS  := pkg_glb_common.Status_Erro;
                      P_MESSAGE := P_MESSAGE || 'Existem ' ||  to_char(tpVF.vAuxiliar) || ' Conhecimentos Não autorizados ' || chr(10);
                   End If;
                end if;

             end if;

           else


             if ( tpVf.VFRota                                <> '026'       ) and  -- Não verifica rota 026
                ( tpVF.VFRota                                < '900'        ) and  -- Não verifica rota abaixo 900
                ( PKG_CON_MDFE.fn_Con_MdfeTpAmb(tpvf.VFRota) = '1') Then           -- Se é rota de Mdfe

                vParametros := '<Parametros>                                                              '||
                               '  <Input>                                                                 '||
                               '    <VFUsuarioTDV>'    ||trim(tpVF.VFusuarioTDV)    ||'</VFUsuarioTDV>    '||
                               '    <VFRotaUsuarioTDV>'||trim(tpVF.VFRotaUsuarioTDV)||'</VFRotaUsuarioTDV>'||
                               '    <VFAplicacaoTDV>'  ||'comvlfrete'               ||'</VFAplicacaoTDV>  '||
                               '    <VFVersaoAplicao>' ||trim(tpVF.VFVersaoAplicao) ||'</VFVersaoAplicao> '||
                               '  </Input>                                                                '||
                               '</Parametros>                                                             ';

                /*******************************************************************/
                /*******************************************************************/
                /*******************************************************************/
                /*No Momento da impressão só iremos analisar de ele tem mdfe ou não*/
                /* os Vales de frete com CIOT, ou seja feitos para TAC E ETC(Eqp). */
                /*******************************************************************/


                --if (vViagemCiot = 0) then

                      Sp_Con_Validavfretemdfenew(tpVF.VFNumero,
                                                 tpVF.VFSerie,
                                                 tpVF.VFRota,
                                                 tpVF.VFSaque,
                                                 vParametros,
                                                 vStatus,
                                                 vMessage);

                --end if;

                if (nvl(trim(vStatus),'N') <> pkg_glb_common.Status_Nomal) then
                    P_STATUS  := pkg_glb_common.Status_Erro;
                    P_MESSAGE := P_MESSAGE || vMessage || chr(10);
                Else

                 select count(*)
                   into tpVF.vAuxiliar
                   from t_con_vfreteconhec v
                  where v.con_valefrete_codigo         = tpVF.VFNumero
                    and v.con_valefrete_serie          = tpVF.VFSerie
                    and v.glb_rota_codigovalefrete     = tpVF.VFRota
                    and v.con_valefrete_saque          = tpVF.VFSaque
                    and PKG_CON_CTE.FN_CTE_EELETRONICO(v.con_conhecimento_codigo,
                                                       v.con_conhecimento_serie,
                                                       v.glb_rota_codigo) = 'N';

                 if tpVF.vAuxiliar <> 0 Then
                    P_STATUS  := pkg_glb_common.Status_Erro;
                    P_MESSAGE := P_MESSAGE || 'Existem ' ||  to_char(tpVF.vAuxiliar) || ' Conhecimentos Não autorizados ' || chr(10);
                 End If;

                end if;

             end if;


           end if;

         end;

         /**************************************************************************/

          /**************************************************************************/
          /*         Validação de alteração de CIOT                                 */
          /**************************************************************************/


          begin

              SP_CON_VERIFICAPODEIMP;
              
              Begin
                 Select CI.con_vfreteciot_numero,
                        NVL(CI.CON_VFRETECIOT_FLAGIMPRIME,'S')
                        --PKG_CFE_FRETE.FN_GET_PODEALTERAR(tpVF.VFNumero,
                        --                                 tpVF.VFSerie,
                        --                                 tpVF.VFRota,
                        --                                 tpVF.VFSaque)
                     Into tpVF.vCIOT,
                          tpVF.vPodeImprimir
                 From T_CON_VFRETECIOT CI
                 Where CI.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                   And CI.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
                   And CI.GLB_ROTA_CODIGO         = tpVF.VFRota
                   And CI.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;
              Exception
                When NO_DATA_FOUND Then
                    tpVF.vCIOT :='';
                    tpVF.vPodeImprimir := 'S';
                When Others Then
                  tpVF.vPodeImprimir := 'E';
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || '??-Erro ao Procurar o CIOT';
              End;

              If nvl(tpVF.vPodeImprimir,'N') <> 'S' Then
                 P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                 P_MESSAGE := P_MESSAGE || '10a-Vale Tem Solicitação de CIOT ou tem uma solicitação de alteração não valida ' ||
                                           tpVF.VFNumero ||'-'|| tpVF.VFSerie ||'-'|| tpVF.VFRota ||'-'|| tpVF.VFSaque||'['||tpVF.vPodeImprimir||']'||
                                           chr(10) || sqlerrm;
              End If;
          end;
          
                
          /******************************************************************************/
          /*  Bloqueio para não imprimir vale de frete maior que um determinado valor   */
          /*  Gustavo vocatore 30/11/2020                                               */
          /******************************************************************************/   
          
          begin 
          
          vValorTrava := nvl(plistaparams('VFTRAVAVALOR').numerico1,0);
          
          --insert into tdvadm.t_glb_testestr(glb_testestr_1,glb_testestr_dtgrav) values(vValorTrava,sysdate);
          -- commit;
          
          SELECT SUM(N.ARM_NOTA_VALORMERC)
                 into vValorValeFrete
            FROM TDVADM.T_CON_VALEFRETE V,
                 TDVADM.T_CON_VFRETECONHEC CC,
                 TDVADM.T_CON_CONHECIMENTO CO,
                 TDVADM.t_ARM_NOTA N,
                 TDVADM.t_Con_Controlectrce ct
            WHERE 0 = 0
            AND V.CON_CONHECIMENTO_CODIGO   = CC.CON_VALEFRETE_CODIGO
            AND V.CON_CONHECIMENTO_SERIE    = CC.CON_VALEFRETE_SERIE
            AND V.GLB_ROTA_CODIGO           = CC.GLB_ROTA_CODIGOVALEFRETE
            AND V.CON_VALEFRETE_SAQUE       = CC.CON_VALEFRETE_SAQUE
            AND CC.CON_CONHECIMENTO_CODIGO  = CO.CON_CONHECIMENTO_CODIGO
            AND CC.CON_CONHECIMENTO_SERIE   = CO.CON_CONHECIMENTO_SERIE
            AND CC.GLB_ROTA_CODIGO          = CO.GLB_ROTA_CODIGO
            AND CO.CON_CONHECIMENTO_CODIGO  = N.CON_CONHECIMENTO_CODIGO
            AND CO.CON_CONHECIMENTO_SERIE   = N.CON_CONHECIMENTO_SERIE
            AND CO.GLB_ROTA_CODIGO          = N.GLB_ROTA_CODIGO
            AND V.CON_CONHECIMENTO_CODIGO   = tpVF.VFNumero
            AND V.GLB_ROTA_CODIGO           = tpVF.VFRota 
            AND V.CON_CONHECIMENTO_SERIE    = tpVF.VFSerie
            AND V.CON_VALEFRETE_SAQUE       = tpVF.VFSaque
            AND CO.CON_CONHECIMENTO_CODIGO  = CT.CON_CONHECIMENTO_CODIGO
            AND CO.CON_CONHECIMENTO_SERIE   = CT.CON_CONHECIMENTO_SERIE
            AND CO.GLB_ROTA_CODIGO          = CT.GLB_ROTA_CODIGO;
            
            if(vValorValeFrete > vValorTrava) then
            
                 SELECT COUNT(*)
                   into vLiberacao
                   FROM TDVADM.T_CON_VALEFRETELIB LIB
                  WHERE LIB.CON_CONHECIMENTO_CODIGO =  tpVF.VFNumero
                    AND LIB.GLB_ROTA_CODIGO         =  tpVF.VFRota
                    AND LIB.CON_CONHECIMENTO_SERIE  =  tpVF.VFSerie
                    AND LIB.CON_VALEFRETE_SAQUE     =  tpVF.VFSaque
                    AND LIB.CON_VALEFRETETPLIB_ID   = 1;  

                 if(vLiberacao = 0) then
                   P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                   P_MESSAGE := P_MESSAGE || 'Valor da mercadoria maior que o valor permitido ' || vValorTrava || chr(10);
                 end if;
            end if;
            
          end;       
          
          /******************************************************************************/
          
          
          if ( tpVF.vPrimeiroSaque            =  tpvf.VFSaque )                     and  -- Primeiro Saque Valido
             ( tpVf.VFRota                    <> '026'       )                      and  -- Não verifica rota 026
             ( tpVF.VFRota                    <  '900'        )                     and  -- Não verifica rota abaixo 900
             ( tpVF.VFCON_CATVALEFRETE_CODIGO in (CatTUmaViagem,CatTAvulsoCCTRC) ) Then
          
           /*
            /******************************************************************************/
            /** Bloqueio, Despesa Maior que Receita                                      **/
            /******************************************************************************/
            /*
            Begin
             
             vPercDifRecXDesp      := nvl(plistaparams('VFDIFRECEDISP').numerico1,0);
             
             -- Valor da Despesa
             select vf.CON_VALEFRETE_CUSTOCARRETEIRO
               into vValorTotalDespesa
               from tdvadm.t_con_valefrete vf
              where vf.con_conhecimento_codigo = tpVF.VFNumero
                and vf.con_conhecimento_serie  = tpVF.VFRota
                and vf.glb_rota_codigo         = tpVF.VFSerie
                and vf.con_valefrete_saque     = tpVF.VFSaque;
             
             -- Valor da Receita
             select sum (tp.CON_CALCVIAGEM_VALOR)
               into vValorTotalReceita
               from tdvadm.t_con_vfreteconhec vfc,
                    tdvadm.t_con_conhecimento ch,
                    tdvadm.v_con_i_ttpv tp
              where vfc.con_conhecimento_codigo  = ch.con_conhecimento_codigo
                and vfc.con_conhecimento_serie   = ch.con_conhecimento_serie
                and vfc.glb_rota_codigo          = ch.glb_rota_codigo
                
                and vfc.con_conhecimento_codigo  = tp.con_conhecimento_codigo
                and vfc.con_conhecimento_serie   = tp.con_conhecimento_serie
                and vfc.glb_rota_codigo          = tp.glb_rota_codigo
                
                and vfc.con_valefrete_codigo     = tpVF.VFNumero
                and vfc.con_valefrete_serie      = tpVF.VFRota
                and vfc.glb_rota_codigovalefrete = tpVF.VFSerie
                and vfc.con_valefrete_saque      = tpVF.VFSaque; 
              

              if (vPercDifRecXDesp > (100 - ((vValorTotalReceita/vValorTotalDespesa)*100)  )) then
                
                SELECT COUNT(*)
                  INTO vLibPercDifRecXDesp
                  FROM TDVADM.T_CON_VALEFRETELIB LIB
                 WHERE LIB.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                   AND LIB.GLB_ROTA_CODIGO         = tpVF.VFRota
                   AND LIB.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
                   AND LIB.CON_VALEFRETE_SAQUE     = tpVF.VFSaque
                   AND LIB.CON_VALEFRETETPLIB_ID   = 2;  
                
                IF (vLibPercDifRecXDesp = 0) Then
                  
                  P_STATUS  :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE :=  P_MESSAGE || 'Diferenta entre Despesa X Receita Supera, ('||vPercDifRecXDesp||') %.';
                
                End If;
                
                
              end if;      
             

             
            End;
            
            /******************************************************************************/
            
            /******************************************************************************/
            /** Bloqueio. Emissão Da Receita contra a Emissão da despesa maios de 90 dias**/
            /******************************************************************************/
            
            Begin
              
             begin  
            
               -- Parametro Qtde de dias que a Emissão do Cte pode ser diferente da Emissão do VF;    
               vQtdeDiasRecXDesp        := nvl(plistaparams('VFDIFDTRDTD').numerico1,0);
               
             
             exception when others then
               
             vQtdeDiasRecXDesp := 365;  
             
             end;  
             
             
             -- Data de Emisão do Vf
             select trunc(vf.con_valefrete_datacadastro)
               into vDataVf
               from tdvadm.t_con_valefrete vf
              where vf.con_conhecimento_codigo = tpVF.VFNumero
                and vf.con_conhecimento_serie  = tpVF.VFSerie
                and vf.glb_rota_codigo         = tpVF.VFRota
                and vf.con_valefrete_saque     = tpVF.VFSaque;
             
             -- Menor Data de Emissão do CTe
             select min (ch.con_conhecimento_dtembarque)
               into vDataEmiCTe
               from tdvadm.t_con_vfreteconhec vfc,
                    tdvadm.t_con_conhecimento ch
              where vfc.con_conhecimento_codigo  = ch.con_conhecimento_codigo
                and vfc.con_conhecimento_serie   = ch.con_conhecimento_serie
                and vfc.glb_rota_codigo          = ch.glb_rota_codigo
                and vfc.con_valefrete_codigo     = tpVF.VFNumero
                and vfc.con_valefrete_serie      = tpVF.VFSerie
                and vfc.glb_rota_codigovalefrete = tpVF.VFRota
                and vfc.con_valefrete_saque      = tpVF.VFSaque;

             if ((TRUNC(vDataVf)-TRUNC(vDataEmiCTe))  >  vQtdeDiasRecXDesp)  then                    
            
                SELECT COUNT(*)
                  INTO vLibDiasRecXDesp
                  FROM TDVADM.T_CON_VALEFRETELIB LIB
                 WHERE LIB.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                   AND LIB.GLB_ROTA_CODIGO         = tpVF.VFRota
                   AND LIB.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
                   AND LIB.CON_VALEFRETE_SAQUE     = tpVF.VFSaque
                   AND LIB.CON_VALEFRETETPLIB_ID   = 3;  
                
                IF (vLibDiasRecXDesp = 0) Then
                  
                 P_STATUS  :=  PKG_GLB_COMMON.Status_Erro;
                 P_MESSAGE :=  P_MESSAGE || 'Diferenta entre emissão do Vale de Frete e Emissão do CTe/NFSe supera: ('||vQtdeDiasRecXDesp||') dias.';
              
                End If;
              
            end if;     

              
            End;
           
            /******************************************************************************/
            
            /******************************************************************************/
            /** Bloqueio, Cte de Complemento                                             **/
            /******************************************************************************/
            
            Begin
              
             vBloqueiCteCompl     := nvl(plistaparams('VFBLOQCTECOMPL').texto,'N');
             
             select count(*)
               into vExisteCteComplementar
               from tdvadm.t_con_vfreteconhec vfc,
                    tdvadm.t_con_conhecimento ch,
                    tdvadm.t_con_conheccomplemento cp
              where vfc.con_conhecimento_codigo  = ch.con_conhecimento_codigo
                and vfc.con_conhecimento_serie   = ch.con_conhecimento_serie
                and vfc.glb_rota_codigo          = ch.glb_rota_codigo
                and ch.con_conhecimento_codigo   = cp.con_conhecimento_codigo
                and ch.con_conhecimento_serie    = cp.con_conhecimento_serie
                and ch.glb_rota_codigo           = cp.glb_rota_codigo
                and vfc.con_valefrete_codigo     = tpVF.VFNumero
                and vfc.con_valefrete_serie      = tpVF.VFSerie
                and vfc.glb_rota_codigovalefrete = tpVF.VFRota
                and vfc.con_valefrete_saque      = tpVF.VFSaque;
              
             
             if ((vExisteCteComplementar > 0) and (vBloqueiCteCompl = 'S'))  then
               
               select count(*)
                 into vLibBloqueiCteCompl
                 from tdvadm.t_con_valefretelib lib
                where lib.con_conhecimento_codigo = tpvf.vfnumero
                  and lib.glb_rota_codigo         = tpvf.vfrota
                  and lib.con_conhecimento_serie  = tpvf.vfserie
                  and lib.con_valefrete_saque     = tpvf.vfsaque
                  and lib.con_valefretetplib_id   = 2;  
                
               If (vLibBloqueiCteCompl = 0) Then
                  
                 P_STATUS  :=  PKG_GLB_COMMON.Status_Erro;
                 P_MESSAGE :=  P_MESSAGE || 'Existem CTe(s) complementares neste Vale de Frete, impossivel prosseguir!';
              
               End If;
              
             end if;     
              
            End;
            
            /******************************************************************************/
            
          
          End if;

          /**************************************************************************/
          /*         bloqueio para verificar se o vf de um frota                    */
          /*         foi criado viagem junto a alguma gerenciadora                  */
          /*         Klayton em 01/12/2014                                          */
          /**************************************************************************/


          begin

            if (substr(tpVF.VFCON_VALEFRETE_PLACA,1,3) = '000') then

              pkg_cfe_frete.Sp_Get_PgtoFrota(tpVF.VFCON_VALEFRETE_PLACA,
                                             vStatus2,
                                             vMessage2);


             If (nvl(vStatus2,'N') = pkg_glb_common.Status_Nomal) then

                 vFrotaPagoCartao := 'S';

              end if;

              select count(*)
                into vExisteViagem
                from t_con_vfreteciot ci
               where ci.con_conhecimento_codigo = tpVF.VFNumero
                 and ci.con_conhecimento_serie  = tpVF.VFSerie
                 and ci.glb_rota_codigo         = tpVF.VFRota
                 and ci.con_valefrete_saque     = tpVF.VFSaque;

              if (vFrotaPagoCartao = 'S') and (vExisteViagem = 0) then

                P_STATUS  := pkg_glb_common.Status_Erro;
                P_MESSAGE := P_MESSAGE || '10-Vale de frete do Frota: '||tpVF.VFCON_VALEFRETE_PLACA||' não tem viagem para pgto eletronico de frete vinculada, entre em contato com o Bruno|';

              end if;

            end if;

          end;




          /**************************************************************************/

         /*************************************************
            Verifica se for de Estadia.
         *************************************************/
         vQtdeEntregas    := 0;
         V_QTDEIMG        := 0;
         V_CONTADORREC    := 0;
         V_CONTADORNAPROV := 0;





         if ( tpvf.VFCON_CATVALEFRETE_CODIGO in (CatTEstadia) ) Then

           
           
            tpvf.vAuxiliarTexto := fn_ListaClienteEntregas(tpVF.VFNumero,
                                                           tpVF.VFSerie,
                                                           tpVF.VFRota,
                                                           tpVF.VFSaque,
                                                           substr(vCATVFRETE,17,1), -- Cria ou Nao Estadia
                                                           vStatus,
                                                           vMessage);
            If nvl(vStatus,'N') = 'E' Then
               P_STATUS := 'E';
            End If;
            
            P_MESSAGE := P_MESSAGE || ' ' || vMessage;               

            select sum(nvl(vd.fcf_veiculodisp_qtdeentregas,1))
              into vQtdeEntregas
            from t_con_valefrete vf,
                 t_fcf_veiculodisp vd
            where vf.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
              and vf.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
              and vf.con_conhecimento_codigo = tpVF.VFNumero
              and vf.con_conhecimento_serie  = tpVF.VFSerie
              and vf.glb_rota_codigo         = tpVF.VFRota;

             vQtdeEntregas := nvl(vQtdeEntregas,1);
             if vQtdeEntregas = 0 then
               vQtdeEntregas := 1;
             End If;

             select count(*),
                    sum(decode(nvl(vi.glb_vfimagem_arquivado,'N'),'R',1,0)),
                    sum(decode(nvl(vi.usu_usuario_codigoconf,'sirlano'),'sirlano',1,0))
               into V_QTDEIMG,
                    V_CONTADORREC,
                    V_CONTADORNAPROV
             from t_glb_vfimagem vi
             where vi.con_conhecimento_codigo = tpVF.VFNumero
               and vi.con_conhecimento_serie  = tpVF.VFSerie
               and vi.glb_rota_codigo         = tpVF.VFRota
               and vi.con_valefrete_saque     = tpVF.VFSaque;

             V_QTDEIMG        := nvl(V_QTDEIMG,0);
             V_CONTADORREC    := nvl(V_CONTADORREC,0);
             V_CONTADORNAPROV := nvl(V_CONTADORNAPROV,0);
             if ( V_QTDEIMG < vQtdeEntregas ) or
                ( V_CONTADORREC > 0 )
                -- or V_CONTADORNAPROV > 0 )  So vale para o Caixa se não estiver aprovada
 --              and ( trunc(sysdate) > to_date('12/01/2015','dd/mm/yyyy'))
              Then
                 P_STATUS  := pkg_glb_common.Status_Erro;
                 P_MESSAGE := P_MESSAGE || '**********************************************************'            || chr(10) ||
                                           'TOTAL DE ENTREGAS                :' || TO_CHAR(vQtdeEntregas,'999')    || CHR(10) ||
                                           'TOTAL DE IMAGENS                 :' || TO_CHAR(V_QTDEIMG,'999')        || CHR(10) ||
                                           'TOTAL DE IMAGENS RECUSADAS       :' || TO_CHAR(V_CONTADORREC,'999')    || CHR(10) ||
                                           'TOTAL DE IMAGENS NÃO AUTORIZADAS :' || TO_CHAR(V_CONTADORNAPROV,'999') || CHR(10) ||
                                           'DUVIDAS LIGAR PARA O FATURAMENTO (11) 2967-8718    ....'               || CHR(10) ||
                                           'USE O GERDOR DE PLANILHAS RELATORIO '                                  || CHR(10) ||
                                           'CAX - Relatório de imagens de Estadia Vale Frete '                     || chr(10) ||
                                           '**********************************************************'            || chr(10);


             End If;
          End If;

          if nvl(trim(P_STATUS),'N') <> pkg_glb_common.Status_Erro Then
             if tpVF.tpValeFrete.fcf_veiculodisp_codigo is null Then
                Begin
                   select vvf.fcf_veiculodisp_codigo,
                          vvf.fcf_veiculodisp_sequencia
                     into tpVF.tpValeFrete.fcf_veiculodisp_codigo,
                          tpVF.tpValeFrete.fcf_veiculodisp_sequencia
                   from t_con_veicdispvf vvf
                   where vvf.con_conhecimento_codigo = tpVF.VFNumero
                     and vvf.con_conhecimento_serie  = tpVF.VFSerie
                     and vvf.glb_rota_codigo         = tpVF.VFRota
                     and vvf.con_valefrete_saque     = tpVF.VFSaque;
                exception
                  When NO_DATA_FOUND Then
                      tpVF.tpValeFrete.fcf_veiculodisp_codigo    := null;
                      tpVF.tpValeFrete.fcf_veiculodisp_sequencia := null;
                  End ;
             End If;

          End If;


          -- Verifica se a Placa do veiculo Disp e a Mesma do Vale de Frete
          
          If tpVF.tpValeFrete.fcf_veiculodisp_codigo is not null Then
              Begin
              Select vd.car_veiculo_placa
                into tpVF.vAuxiliarTexto
              from t_fcf_veiculodisp vd
              where vd.fcf_veiculodisp_codigo = tpVF.tpValeFrete.fcf_veiculodisp_codigo
                and vd.fcf_veiculodisp_sequencia = tpVF.tpValeFrete.fcf_veiculodisp_sequencia;
              Exception
                When OTHERS Then
                    P_STATUS := pkg_glb_common.Status_Erro ;
                    P_MESSAGE := P_MESSAGE || 'Problemas a recuperando Placa do Veiculo na Mesa! ' || chr(10) ||
                                              'Vdisp [' || tpVF.tpValeFrete.fcf_veiculodisp_codigo || ']' || chr(10) || sqlerrm;
                End;
                
                If trim(tpVF.vAuxiliarTexto) <> trim(tpVF.tpValeFrete.Con_valefrete_placa) Then
                    P_STATUS := pkg_glb_common.Status_Erro ;
                    P_MESSAGE := P_MESSAGE || 'Placa [' || tpVF.tpValeFrete.Con_valefrete_placa || '] do Vale de Frete ' || chr(10) ||
                                              'Placa [' || trim(tpVF.vAuxiliarTexto) || '] da Mesa ' || chr(10) ||
                                              'Diferentes, impossivel prosseguir.... Vdisp [' || tpVF.tpValeFrete.fcf_veiculodisp_codigo || ']';
                End If;
         End If; 

       End If;

          If tpVF.VFAcao = 'ConcluindoCriando' Then

          -- se existe Sub e não Passou Da Erro.
          If ( tpVF.vExisteSubCategoria = 'S' ) and
             ( tpVF.VFCON_SUBCATVALEFRETE_CODIGO is null )  Then
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '- 00 Uso Obrigatorio de Sub Categoria... ' || chr(10);
          End If;

          -- Pegar alguma configurações e Criticar os comprovantes para os Frotas

              If tpVF.vUltimoSaqueValido > 0 Then

                  Select Count(*)
                     Into tpVF.vAuxiliar
                  From t_con_calcvalefrete vf
                  Where vf.con_conhecimento_codigo = tpVF.VFNumero
                    And vf.con_conhecimento_serie  = tpVF.VFSerie
                    And vf.glb_rota_codigo         = tpVF.VFRota
                    And vf.con_valefrete_saque     = tpVF.vUltimoSaqueValido
                    And vf.usu_usuario_codigoliberou Is Not Null;

                  If tpVF.vAuxiliar > 0 Then
                     tpVF.vSQAntPagoEl := 'S';
                  Else
                     tpVF.vSQAntPagoEl := 'N';
                  End If;
              End If;
          End if;

          Begin
             Select CI.con_vfreteciot_numero,
                    PKG_CFE_FRETE.FN_GET_PODEALTERAR(tpVF.VFNumero,
                                                     tpVF.VFSerie,
                                                     tpVF.VFRota,
                                                     tpVF.VFSaque)
                 Into tpVF.vCIOT,
                      tpVF.vSolCIOT
             From T_CON_VFRETECIOT CI
             Where CI.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
               And CI.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
               And CI.GLB_ROTA_CODIGO         = tpVF.VFRota
               And CI.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;
          Exception
            When NO_DATA_FOUND Then
                tpVF.vCIOT :='';
            When Others Then
              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := '??-Erro ao Procurar im CIOT';
          End;

         If ( tpVF.VFAcao = 'Salvar' ) Then 
          Begin
 
             If ( nvl(tpVF.vCIOT,0) = 0 ) and ( nvl(tpVF.tpValeFrete.con_valefrete_impresso,'N') = 'N' ) Then
                sp_con_CalcValefrete(p_vfnumero   => tpVF.VFNumero,
                                     p_vfserie    => tpVF.VFSerie,
                                     p_vfrota     => tpVF.VFRota,
                                     p_vfsaque    => tpVF.VFSaque,
                                     p_DescDebito => 'S',
                                     p_status     => vStatus,
                                     p_message    => vMessage);
                
                 If nvl(vStatus,'N') = 'E' Then
                      P_STATUS := 'E';
                   End If;                 
                   P_MESSAGE := P_MESSAGE || ' ' || vMessage;  
               End If;                       
            Exception
              When OTHERS Then
                 P_MESSAGE := P_MESSAGE || ' ' || sqlerrm;
              End;                  
        End If;   

          If nvl(trim(P_STATUS),'N') =  PKG_GLB_COMMON.Status_Erro Then
           tpVF.vXmlTab :=           '<parametros><output>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';

           P_XMLOUT := tpVF.vXmlTab;

             Return;
          End If;


          If ( tpVF.VFAcao = 'RetiraImpressao' ) and ( tpVF.tpValeFrete.Con_Valefrete_Impresso = 'N' ) Then
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '03-Vale Não Esta Impresso .' || chr(10);
          ElsIf ( tpVF.VFAcao not in ('RetiraImpressao','GravaImg' )) and ( tpVF.tpValeFrete.Con_Valefrete_Impresso = 'S' ) Then
              if plistaparams('PODE_REIMPRIMIR').texto = 'N' Then
                 P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                 P_MESSAGE := P_MESSAGE || '03-Vale Ja Esta Impresso .' || chr(10);
              ElsIf  plistaparams('PODE_REIMPRIMIR').texto = 'PROPRIO' Then
                 if  trim(tpVF.VFusuarioTDV) <> trim(tpVF.tpValeFrete.usu_usuario_codigo) Then
                    P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                    P_MESSAGE := P_MESSAGE || '03-Voce não pode REIMPRIMIR VF de outro usuario.' || chr(10);
                 End IF;
              End IF;
          End If;

          If tpVF.tpValeFrete.Con_Valefrete_Status = 'C' Then
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '04-Vale Ja Cancelado.' || chr(10);
          End If;

          If tpVF.tpValeFrete.Acc_Acontas_Numero <> '' Then
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '05-Vale Encontra-se no acerto ' || tpVF.tpValeFrete.Acc_Acontas_Numero || '.' || chr(10);
          End If;

          If tpVF.tpValeFrete.Con_Valefrete_Berconf <> '' Then
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '06-Vale contem Ativos.' || chr(10);
          End If;

          If tpVF.tpValeFrete.Frt_Movvazio_Numero <> '' Then
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '07-Vale Tem Um Vazio Associado.' || chr(10);
          End If;

          If tpVF.tpValeFrete.Cax_Boletim_Data <> '' Then
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '08-Vale Tem Lancamento no Caixa da Rota ' || tpVF.tpValeFrete.Cax_Boletim_Data || '.' || chr(10);
          End If;

--          If nvl(tpVF.vCIOT,0) = 0 Then
--             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
--             P_MESSAGE := P_MESSAGE || '09-Vale Tem CIOT Valido nr. ' || tpVF.vCIOT || '.' || chr(10);
--          End If;

          If tpVF.VFAcao <> 'Imprimir' Then
             tpVF.vSolCIOT := 'S';
             If tpVF.vSolCIOT = 'N' Then
                P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                P_MESSAGE := P_MESSAGE || '10x-Vale Tem Solicitação de CIOT, Aguarde Retorno' || tpVF.vCIOT || '.' || chr(10);
                tpVF.vXmlTab :=           '<parametros><output>';
                tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
                tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
 --          tpVF.vXmlTab := tpVF.vXmlTab|| '<tables>';
 --          tpVF.vXmlTab := tpVF.vXmlTab|| fn_limpa_campoxml(vXmlTabOutclob);
 --          tpVF.vXmlTab := tpVF.vXmlTab|| fn_limpa_campoxml(vXmlTabOutxml.getclobval());
 --          tpVF.vXmlTab := tpVF.vXmlTab|| '</tables>';
                tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';

                P_XMLOUT := tpVF.vXmlTab;
                RETURN;
             End If;
          End If;
      End If;

      If tpVF.VFAcao = 'SO PARA DOCUMENTAR' Then
         tpVF.VFAcao := tpVF.VFAcao;
      ElsIf tpVF.VFAcao = 'Criando' Then

         If tpVF.vExisteSubCategoria = 'S'  Then

           If (  tpVF.VFNumero Is Null  Or tpVF.VFSerie Is Null Or tpVF.VFRota Is Null ) And ( tpVF.VFCON_CATVALEFRETE_CODIGO <> CatTAvulsoSCTRC ) Then
                 P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                 P_MESSAGE := P_MESSAGE || '- Favor informar o Documento de referencia... ' || chr(10);
           End If;

           begin
               if plistaparams('SUB'||tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao).TEXTO = 'N' Then
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || '- Sub Categoria '|| tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao || ' Não autorizada Para Voce  Rota - ' || nvl(tpVF.VFRotaUsuarioTDV,'00') || 'Usuario - ' || tpVF.VFusuarioTDV || chr(10);
               End if;
           exception
             When NO_DATA_FOUND Then
               if plistaparams('SUB'||tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao).TEXTO = 'N' Then
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || '- Categoria não Parametrizada - ' || tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao || ' SOLICITAR CADASTRAMENTO A TI... '|| chr(10);
               End if;

             End ;

           -- Para calcular os Saques Menor e Maior
           if tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao in ('SQ1CANCELADO','TROCAVEIC') Then
               Begin
                 Select *
                   Into tpVF.tpValeFreteMenor
                 From t_con_valefrete vf
                 Where vf.con_conhecimento_codigo = tpVF.VFNumero
                   And vf.con_conhecimento_serie  = tpVF.VFSerie
                   And vf.glb_rota_codigo         = tpVF.VFRota
                   And vf.con_valefrete_saque     = '1';
                  If nvl(tpVF.tpValeFreteMenor.Con_Valefrete_Status,'N') <> 'C' Then
                     if tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao = 'SQ1CANCELADO' Then
                        P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                        P_MESSAGE := P_MESSAGE || '- Saque 1 deste Vale de Frete não esta Cancelado... ' || chr(10);
                     End If;
                  End If;
                Exception
                  When NO_DATA_FOUND Then
                     P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                     P_MESSAGE := P_MESSAGE || '- Não Existe Saque 1 deste Vale de Frete... ' || chr(10);
                  End;

                  Begin
                     Select *
                       Into tpVF.tpValeFretemaior
                     From tdvadm.t_con_valefrete vf
                     Where vf.con_conhecimento_codigo = tpVF.VFNumero
                       And vf.con_conhecimento_serie  = tpVF.VFSerie
                       And vf.glb_rota_codigo         = tpVF.VFRota
                       And vf.con_valefrete_saque     = (Select Max(vf1.con_valefrete_saque)
                                                         From t_con_valefrete vf1
                                                         Where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                                                           And vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                                                           And vf1.glb_rota_codigo         = vf.glb_rota_codigo);
                  Exception
                      When NO_DATA_FOUND Then
                         P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                         P_MESSAGE := P_MESSAGE || '1- Não Existe Vale de Frete Anterior... ' || chr(10);
                  End ;


           End If;



           if tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao = 'SQ1CANCELADO' Then

                  If nvl(trim(P_STATUS),'N') <>  PKG_GLB_COMMON.Status_Erro Then

                     Begin
                       if tpVF.tpValeFretemaior.Con_Valefrete_Saque <> '1' then
                           Select *
                             Into tpVF.tpValeFreteAnt
                           From t_con_valefrete vf
                           Where vf.con_conhecimento_codigo = tpVF.VFNumero
                             And vf.con_conhecimento_serie  = tpVF.VFSerie
                             And vf.glb_rota_codigo         = tpVF.VFRota
                          --   And nvl(vf.con_valefrete_status,'N') = 'N'
                             And nvl(vf.con_valefrete_impresso,'N') = 'S'
                             And vf.con_valefrete_saque     = (Select Max(vf1.con_valefrete_saque)
                                                               From t_con_valefrete vf1
                                                               Where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                                                                 And vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                                                                 And vf1.glb_rota_codigo         = vf.glb_rota_codigo
                                                                 And vf1.con_valefrete_saque < tpVF.tpValeFretemaior.Con_Valefrete_Saque);
                        Else
                           Select *
                             Into tpVF.tpValeFreteAnt
                           From t_con_valefrete vf
                           Where vf.con_conhecimento_codigo = tpVF.VFNumero
                             And vf.con_conhecimento_serie  = tpVF.VFSerie
                             And vf.glb_rota_codigo         = tpVF.VFRota
                          --   And nvl(vf.con_valefrete_status,'N') = 'N'
                             And nvl(vf.con_valefrete_impresso,'N') = 'S'
                             And vf.con_valefrete_saque     = '1';
                        End If;
                     Exception
                      When NO_DATA_FOUND Then
                         P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                         P_MESSAGE := P_MESSAGE || '2- Não Existe Vale de Frete Anterior...' || chr(10) ||
                                                   'VF: ' || tpVF.VFNumero ||' Série: '|| tpVF.VFSerie || ' Rota: ' || tpVF.VFRota || ' tpVF.tpValeFretemaior.Con_Valefrete_Saque: '|| tpVF.tpValeFretemaior.Con_Valefrete_Saque ;
                      End ;

                  End If;
              Elsif tpVF.tpSubCategoria.Con_Subcatvalefrete_Validacao = 'TROCAVEIC' Then

                     Begin
                       Select *
                         Into tpVF.tpValeFreteAnt
                       From t_con_valefrete vf
                       Where vf.con_conhecimento_codigo = tpVF.VFNumero
                         And vf.con_conhecimento_serie  = tpVF.VFSerie
                         And vf.glb_rota_codigo         = tpVF.VFRota
                         And nvl(vf.con_valefrete_status,'N') = 'N'
                         And nvl(vf.con_valefrete_impresso,'N') = 'S'
                         And vf.con_valefrete_saque     = (Select Max(vf1.con_valefrete_saque)
                                                           From t_con_valefrete vf1
                                                           Where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                                                             And vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                                                             And vf1.glb_rota_codigo         = vf.glb_rota_codigo
                                                             And vf1.con_valefrete_saque <= tpVF.tpValeFretemaior.Con_Valefrete_Saque);
                     Exception
                      When NO_DATA_FOUND Then
                         P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                         P_MESSAGE := P_MESSAGE || '3 - Não Existe Vale de Frete Anterior... ' || chr(10) ||
                                                 'VFNumero: ' || tpVF.VFNumero || ' VFSerie: ' || tpVF.VFSerie || ' VFRota' || tpVF.VFRota || ' VFreteMaior: ' || tpVF.tpValeFretemaior.Con_Valefrete_Saque;
                      End ;

                     if tpVF.tpValeFrete.con_valefrete_placa = tpVf.tpValeFreteAnt.con_valefrete_placa Then
                         P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                         P_MESSAGE := P_MESSAGE || '4 - OBRIGATORIO a Troca da placa para uso desta Categoria... ' || chr(10);

                     End If;

              End If;



           End If;

      ElsIf tpVF.VFAcao = 'GravaImg' Then
         if Not glbadm.pkg_listas.FN_Get_ListaVfreteImg(tpVF.vXmlTab,plistaVfImagem,vMessage) then
            P_MESSAGE := P_MESSAGE || chr(10) || vMessage;

        Else
            tpVF.vAuxiliar := 1;
            begin
              loop
                begin
                   tpVF.vAuxiliar2 := LENGTH(TRIM(plistaVfImagem(tpVF.vAuxiliar).glb_vfimagem_codcliente));
                   update t_glb_vfimagem vi
                     set vi.usu_usuario_codigoconf = trim(plistaVfImagem(tpVF.vAuxiliar).usu_usuario_codigoconf) ,
                         vi.glb_vfimagem_dtconferencia = sysdate,
                         vi.glb_vfimagem_arquivado  = trim(plistaVfImagem(tpVF.vAuxiliar).glb_vfimagem_arquivado)
                   where vi.con_conhecimento_codigo = trim(plistaVfImagem(tpVF.vAuxiliar).con_conhecimento_codigo)
                     and vi.con_conhecimento_serie  = trim(plistaVfImagem(tpVF.vAuxiliar).con_conhecimento_serie)
                     and vi.glb_rota_codigo         = trim(plistaVfImagem(tpVF.vAuxiliar).glb_rota_codigo)
                     and vi.con_valefrete_saque     = trim(plistaVfImagem(tpVF.vAuxiliar).con_valefrete_saque)
                     and TDVADM.fn_limpa_campo3(SUBSTR(vi.glb_vfimagem_codcliente,1,tpVF.vAuxiliar2)) = TDVADM.fn_limpa_campo3(trim(plistaVfImagem(tpVF.vAuxiliar).glb_vfimagem_codcliente))  ;

                    P_MESSAGE := P_MESSAGE || chr(10) ||  'Saque ' || trim(plistaVfImagem(tpVF.vAuxiliar).con_valefrete_saque) || 'Cod Cli ' || trim(plistaVfImagem(tpVF.vAuxiliar).glb_vfimagem_codcliente)  || '-' || ' QtdeGravou ' || to_char(sql%rowcount) ;
                    tpVF.vAuxiliar := tpVF.vAuxiliar + 1;
 --                   tpVf.vAuxiliar2 := tpVf.vAuxiliar2
                    commit;
                exception
                  when OTHERS Then
                      P_MESSAGE := P_MESSAGE || chr(10) || sqlerrm;
                      exit;
                  end;
                exit when tpVF.vAuxiliar > plistaVfImagem.count;
              end loop;
              commit;

            End;
         End if;


      ElsIf tpVF.VFAcao in ('Salvar','Imprimir') Then

         if ( tpvf.VFCON_CATVALEFRETE_CODIGO in (CatTUmaViagem,
                                                 CatTVariasViagens,
                                                 CatTAvulsoCCTRC)) Then


            -- 30/06/2021
            -- Sirlano
            -- Acertando o Calculo dos Impostos para o Vale de Frete



            tpvf.vAuxiliarTexto := fn_ListaClienteEntregas(tpVF.VFNumero,
                                                           tpVF.VFSerie,
                                                           tpVF.VFRota,
                                                           tpVF.VFSaque,
                                                           'N', -- Cria ou Nao Estadia
                                                           vStatus,
                                                           vMessage);

            If nvl(vStatus,'N') = 'E' Then
               P_STATUS := 'E';
            End If;
            
            P_MESSAGE := P_MESSAGE || ' ' || vMessage;               
           
            
      
        if Not glbadm.pkg_listas.FN_Get_ListaVfreteEntrega(tpVF.vXmlTab,plistaVFEntregas,vMessage) then
            If vMessage <> 'Lista de Data de Entregas Não Passada' Then
               P_MESSAGE := P_MESSAGE || chr(10) || vMessage;
            End If;
             
        Else
            tpVF.vAuxiliar := 1;
            begin
              loop
                begin                                     
                  tpVF.vAuxiliar2 := length(trim(plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_codcli));
                  iF plistaVFEntregas(tpVF.vAuxiliar).con_conhecimento_codigo is not null Then
                      select *
                        into tpVfreteentregas
                      from tdvadm.t_con_vfreteentrega vfe
                      where vfe.con_conhecimento_codigo = plistaVFEntregas(tpVF.vAuxiliar).con_conhecimento_codigo
                        and vfe.con_conhecimento_serie = plistaVFEntregas(tpVF.vAuxiliar).con_conhecimento_serie
                        and vfe.glb_rota_codigo = plistaVFEntregas(tpVF.vAuxiliar).glb_rota_codigo
                        and vfe.con_valefrete_saque = plistaVFEntregas(tpVF.vAuxiliar).con_valefrete_saque
                        and TDVADM.fn_limpa_campo3(substr(vfe.con_vfreteentrega_codcli,1,tpVF.vAuxiliar2)) = TDVADM.fn_limpa_campo3(trim(plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_codcli))
                        and vfe.con_vfreteentrega_seq = plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_seq;
                      --Begin 
                          vSQLTeste := 'SELECT DISTINCT C.GLB_GRUPOECONOMICO_CODIGO ';                          
                          vSQLTeste := vSQLTeste || 'FROM TDVADM.T_CON_VFRETECONHEC VF, ';
                          vSQLTeste := vSQLTeste || '     TDVADM.T_CON_CONHECIMENTO CO, ';
                          vSQLTeste := vSQLTeste || '     TDVADM.T_GLB_CLIEND CLI,';
                          vSQLTeste := vSQLTeste || '     TDVADM.T_GLB_CLIENTE C, ';
                          vSQLTeste := vSQLTeste || '     TDVADM.T_GLB_CLIENTE CD, ';
                          vSQLTeste := vSQLTeste || '     TDVADM.t_con_vfreteentrega E ';
                          vSQLTeste := vSQLTeste || ' WHERE 0 = 0 AND ';
                          vSQLTeste := vSQLTeste || '       VF.con_conhecimento_codigo = CO.CON_CONHECIMENTO_CODIGO AND';
                          vSQLTeste := vSQLTeste || '       VF.con_conhecimento_serie  = CO.CON_CONHECIMENTO_SERIE AND ';
                          vSQLTeste := vSQLTeste || '       VF.glb_rota_codigo  = CO.GLB_ROTA_CODIGO AND ';
                          vSQLTeste := vSQLTeste || '       CO.GLB_CLIENTE_CGCCPFDESTINATARIO =  CLI.GLB_CLIENTE_CGCCPFCODIGO AND ';
                          vSQLTeste := vSQLTeste || '       CO.GLB_TPCLIEND_CODIGODESTINATARI = CLI.GLB_TPCLIEND_CODIGO AND ';                                    
                          vSQLTeste := vSQLTeste || '       CO.GLB_CLIENTE_CGCCPFSACADO = C.GLB_CLIENTE_CGCCPFCODIGO AND ';
                          vSQLTeste := vSQLTeste || '       CO.GLB_CLIENTE_CGCCPFDESTINATARIO = CD.GLB_CLIENTE_CGCCPFCODIGO AND ';
                          vSQLTeste := vSQLTeste || '       TDVADM.fn_limpa_campo3(CLI.GLB_CLIEND_CODCLIENTE) LIKE ' || tdvadm.pkg_glb_common.Fn_QuotedStr('%' || plistaVFEntregas(tpVF.vAuxiliar).CON_VFRETEENTREGA_CODCLI || '%') || ' AND ';
                                        
                          vSQLTeste := vSQLTeste || '       VF.CON_VALEFRETE_CODIGO   = ' || tdvadm.pkg_glb_common.Fn_QuotedStr(plistaVFEntregas(tpVF.vAuxiliar).CON_CONHECIMENTO_CODIGO) || ' AND ';
                          vSQLTeste := vSQLTeste || '       VF.CON_VALEFRETE_SERIE    = ' || tdvadm.pkg_glb_common.Fn_QuotedStr(plistaVFEntregas(tpVF.vAuxiliar).CON_CONHECIMENTO_SERIE) || ' AND ';
                          vSQLTeste := vSQLTeste || '       VF.CON_VALEFRETE_SAQUE    = ' || tdvadm.pkg_glb_common.Fn_QuotedStr(plistaVFEntregas(tpVF.vAuxiliar).CON_VALEFRETE_SAQUE) || ' AND ';
                          vSQLTeste := vSQLTeste || '       VF.GLB_ROTA_CODIGO        = ' || tdvadm.pkg_glb_common.Fn_QuotedStr(plistaVFEntregas(tpVF.vAuxiliar).GLB_ROTA_CODIGO) || ' AND ';
                          vSQLTeste := vSQLTeste || '       C.GLB_GRUPOECONOMICO_CODIGO = ' || tdvadm.pkg_glb_common.Fn_QuotedStr(plistaparams('OBRIGA_COD_AGEND_GRUPO').texto) || ' AND ';
                          vSQLTeste := vSQLTeste || '       CD.GLB_GRUPOECONOMICO_CODIGO = ' || tdvadm.pkg_glb_common.Fn_QuotedStr(plistaparams('OBRIGA_COD_AGEND_GRUPO').texto) || ' AND ';
                          vSQLTeste := vSQLTeste || '       TRUNC(E.CON_VFRETEENTREGA_DTGRAVACAO) >= TO_DATE(' || tdvadm.pkg_glb_common.Fn_QuotedStr('20/11/2019')||', '||tdvadm.pkg_glb_common.Fn_QuotedStr('dd/mm/yyyy')||')';
                          Begin
                            Execute immediate(vSQLTeste) into vGrupoEconomico;
                          exception 
                          when OTHERS Then
                               wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro montagem sql ' || to_char(SQLCODE) || ': ' || SQLERRM || ' : '|| SQLCODE , vSQLTeste , 'aut-e@dellavolpe.com.br', 'thiago.soares@dellavolpe.com.br');
                          end;      
                          /* Thiago - 14/11/2019 - Validação código de entrega*/
                          /*
                          SELECT DISTINCT C.GLB_GRUPOECONOMICO_CODIGO
                            INTO vGrupoEconomico
                          FROM TDVADM.T_CON_VFRETECONHEC VF,
                               TDVADM.T_CON_CONHECIMENTO CO,
                               TDVADM.T_GLB_CLIEND CLI,
                               TDVADM.T_GLB_CLIENTE C
                          WHERE VF.con_conhecimento_codigo = CO.CON_CONHECIMENTO_CODIGO AND
                                VF.con_conhecimento_serie  = CO.CON_CONHECIMENTO_SERIE AND
                                VF.glb_rota_codigo  = CO.GLB_ROTA_CODIGO AND                                    
                                CO.GLB_CLIENTE_CGCCPFDESTINATARIO =  CLI.GLB_CLIENTE_CGCCPFCODIGO AND
                                CO.GLB_TPCLIEND_CODIGODESTINATARI = CLI.GLB_TPCLIEND_CODIGO AND                                    
                                CO.GLB_CLIENTE_CGCCPFSACADO = C.GLB_CLIENTE_CGCCPFCODIGO AND
                                TDVADM.fn_limpa_campo3(CLI.GLB_CLIEND_CODCLIENTE) LIKE  '''%' || plistaVFEntregas(tpVF.vAuxiliar).CON_VFRETEENTREGA_CODCLI || '%''' AND
                                        
                                VF.CON_VALEFRETE_CODIGO   = plistaVFEntregas(tpVF.vAuxiliar).CON_CONHECIMENTO_CODIGO AND
                                VF.CON_VALEFRETE_SERIE    = plistaVFEntregas(tpVF.vAuxiliar).CON_CONHECIMENTO_SERIE AND
                                VF.CON_VALEFRETE_SAQUE    = plistaVFEntregas(tpVF.vAuxiliar).CON_VALEFRETE_SAQUE AND
                                VF.GLB_ROTA_CODIGO        = plistaVFEntregas(tpVF.vAuxiliar).GLB_ROTA_CODIGO;
                                */
                      --exception
                      --when OTHERS Then
                      --    wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro SQL BUSCA GRUPO ECONOMICO', to_char(SQLCODE) || ': ' || SQLERRM || ' : '|| SQLCODE || ' : '|| vSQLTeste , 'aut-e@dellavolpe.com.br', 'thiago.soares@dellavolpe.com.br');
                      --end;  
                            
                      If  Fn_VerificaObrigacaoDigCodOrigem(pListaParams, vGrupoEconomico) AND 
                          (NVL(plistaVFEntregas(tpVF.vAuxiliar).Con_Vfreteentrega_Codigo, 'x') = 'x') AND 
                          -- Thiago 29/11/2019 - novas validações
                          (SUBSTR(plistaVFEntregas(tpVF.vAuxiliar).Con_Vfreteentrega_Codigo, 1, 1) = '0') AND
                          (LENGTH(plistaVFEntregas(tpVF.vAuxiliar).Con_Vfreteentrega_Codigo) <> 10) Then
                           
                           P_STATUS :=  'E';
                           P_MESSAGE := 'Campo Código de Entrega não foi preenchido ou foi preenchido incorretamente.';

                      End If;
                      /* Thiago - 14/11/2019 - Fim alteração */

                       /* Thiago 22/11/2019  */
                       --IF Incluido para não deixar dar continuidade caso não for preenchido o código de entrega                                              
                       IF NVL(P_STATUS, 'N') <> 'E' Then 
                         -- Se nao tinha data atualiza
                         If ( nvl(tpVfreteentregas.Con_Vfreteentrega_Dtentrega,'01/01/1900') <> plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_dtentrega ) or
                            ( nvl(tpVfreteentregas.con_vfreteentrega_horaentrega,'99:99') <> plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_horaentrega )     Then
                            update tdvadm.t_con_vfreteentrega vfe
                              set vfe.con_vfreteentrega_dtentrega = plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_dtentrega,
                                  vfe.con_vfreteentrega_horaentrega = plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_horaentrega,
                                  vfe.con_vfreteentrega_codigo = plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_codigo ,
                                  vfe.con_vfreteentregaobservacao = plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentregaobservacao,
                                  vfe.usu_usuario_codigo = plistaVFEntregas(tpVF.vAuxiliar).usu_usuario_codigo,
                                  vfe.con_vfreteentrega_dtgravacao = sysdate 
                            where vfe.con_conhecimento_codigo = plistaVFEntregas(tpVF.vAuxiliar).con_conhecimento_codigo
                              and vfe.con_conhecimento_serie = plistaVFEntregas(tpVF.vAuxiliar).con_conhecimento_serie
                              and vfe.glb_rota_codigo = plistaVFEntregas(tpVF.vAuxiliar).glb_rota_codigo
                              and vfe.con_valefrete_saque = plistaVFEntregas(tpVF.vAuxiliar).con_valefrete_saque
                              and TDVADM.fn_limpa_campo3(substr(vfe.con_vfreteentrega_codcli,1,tpVF.vAuxiliar2)) = TDVADM.fn_limpa_campo3(trim(plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_codcli))
                              and vfe.con_vfreteentrega_seq = plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_seq;
                               
                            If sql%rowcount = 0 Then
                               P_MESSAGE := P_MESSAGE || chr(10) || trim(tpVF.vAuxiliar) || '-' ||
                                                                    plistaVFEntregas(tpVF.vAuxiliar).con_conhecimento_codigo || '-' ||
                                                                    plistaVFEntregas(tpVF.vAuxiliar).con_conhecimento_serie  || '-' ||
                                                                    plistaVFEntregas(tpVF.vAuxiliar).glb_rota_codigo || '-' || 
                                                                    trim(plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_codcli) || '-' ||
                                                                    plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_seq || chr(10);
                                                                    
                            End If;

                          Elsif (tpVfreteentregas.Con_Vfreteentrega_Confirmado is null) and
                                ( ( nvl(tpVfreteentregas.Con_Vfreteentrega_Dtentrega,'01/01/1900')   <> nvl(plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_dtentrega, '01/01/1900') ) or 
                                  ( nvl(tpVfreteentregas.Con_Vfreteentrega_Codigo, 'x')  <> nvl(plistaVFEntregas(tpVF.vAuxiliar).Con_Vfreteentrega_Codigo, 'x') ) or
                                  ( nvl(tpVfreteentregas.Con_Vfreteentregaobservacao, 'x')  <> nvl(plistaVFEntregas(tpVF.vAuxiliar).Con_Vfreteentregaobservacao, 'x') ) or
                                  ( nvl(tpVfreteentregas.Usu_Usuario_Codigo, 'x')  <> nvl(plistaVFEntregas(tpVF.vAuxiliar).Usu_Usuario_Codigo, 'x') )
                                )   Then
                                 
                                tpVfreteentregas.Con_Vfreteentrega_Seq := tpVfreteentregas.Con_Vfreteentrega_Seq + 1;
                                tpVfreteentregas.Con_Vfreteentrega_Dtentrega := plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_dtentrega;
                                tpVfreteentregas.con_vfreteentrega_horaentrega := plistaVFEntregas(tpVF.vAuxiliar).con_vfreteentrega_horaentrega;
                                tpVfreteentregas.Con_Vfreteentrega_Codigo := plistaVFEntregas(tpVF.vAuxiliar).Con_Vfreteentrega_Codigo;
                                tpVfreteentregas.Con_Vfreteentregaobservacao := plistaVFEntregas(tpVF.vAuxiliar).Con_Vfreteentregaobservacao;
                                tpVfreteentregas.Usu_Usuario_Codigo := plistaVFEntregas(tpVF.vAuxiliar).Usu_Usuario_Codigo;
                                tpVfreteentregas.Con_Vfreteentrega_Dtgravacao := sysdate;                                                            
                                  
                                insert into tdvadm.t_con_vfreteentrega vfe
                                values tpVfreteentregas;  
                                
                          
                          End If;
                       End If;
                    End If;
                    tpVF.vAuxiliar := tpVF.vAuxiliar + 1;
                    commit;
                exception
                  when OTHERS Then
                      exit;
                  end;
                exit when tpVF.vAuxiliar > plistaVFEntregas.count;
              end loop;
           end;
        end If;  

           select count(*)
              into tpVF.vAuxiliar
           from tdvadm.t_con_vfreteentrega ve
           where ve.con_conhecimento_codigo = tpVF.VFNumero
             and ve.con_conhecimento_serie = tpVF.VFSerie
             and ve.glb_rota_codigo = tpVF.VFRota
             and ve.con_valefrete_saque = tpVF.VFSaque;  
           
           if tpVF.vAuxiliar = 1 Then
              update tdvadm.t_con_vfreteentrega vfe
                 set vfe.con_vfreteentrega_dtentrega = vDataDeEntrega,
                     vfe.con_vfreteentrega_horaentrega = vHoraDeEntrega,
                     vfe.usu_usuario_codigo = tpVF.VFusuarioTDV,
                     vfe.con_vfreteentrega_dtgravacao = sysdate              
              where vfe.con_conhecimento_codigo = tpVF.VFNumero
                and vfe.con_conhecimento_serie = tpVF.VFSerie
                and vfe.glb_rota_codigo = tpVF.VFRota
                and vfe.con_valefrete_saque = tpVF.VFSaque
                and vfe.con_vfreteentrega_dtentrega is null;  
           Else
              
               select count(*)
                  into tpVF.vAuxiliar
               from tdvadm.t_con_vfreteentrega ve
               where ve.con_conhecimento_codigo = tpVF.VFNumero
                 and ve.con_conhecimento_serie = tpVF.VFSerie
                 and ve.glb_rota_codigo = tpVF.VFRota
                 and ve.con_valefrete_saque = tpVF.VFSaque
                 and ve.con_vfreteentrega_dtentrega is null;  
               If ( tpVF.vAuxiliar > 0 ) AND ( vValidaDTEntrega = 'S') Then
                  P_MESSAGE := P_MESSAGE || chr(10) || '  EXISTEM ENTREGAS SEM DATA' ||
                                            CHR(10) || 'DUVIDAS PROCURA EZEQUIEL' || 
                                            CHR(10) || '      (11) 2967-8712' || CHR(10);
                  If tpVF.VFAcao in ('Imprimir') Then
                     P_STATUS := 'E';
                  End If;
               End If;
           End IF; 


         End If;  
         

           /********************************************************/
           /***  analise de pedido de cancelamento de CTe        ***/
           /***  Qtde de CTe ou NFe não autorizadas              ***/
           /***  Cte não Averbados                               ***/
           /********************************************************/
           Begin


             vQtdeTotalCancel    := 0;
             vQtdeCteNautorizado := 0;
             vListaNaoAutorizados := '';
             vListaPedidoCancel   := '';
             
            select count(*)
              into vViagemCiot
              from t_con_vfreteciot vf
             where vf.con_conhecimento_codigo = tpVF.VFNumero
               and vf.con_conhecimento_serie  = tpVF.VFSerie
               and vf.glb_rota_codigo         = tpVF.VFRota
               and vf.con_valefrete_saque     = tpVF.VFSaque;
             
 
             vListaNaoAutorizados := '';
             for c_cursor in (select vf.con_conhecimento_codigo,
                                     vf.con_conhecimento_serie,
                                     vf.glb_rota_codigo,
                                     c.con_conhecimento_dtembarque,
                                     tdvadm.fn_busca_conhec_verba(vf.con_conhecimento_codigo,
                                                                  vf.con_conhecimento_serie,
                                                                  vf.glb_rota_codigo,
                                                                  'I_VLMR') VLRMERC                        
                                from tdvadm.t_con_vfreteconhec vf,
                                     tdvadm.t_con_conhecimento c
                               where vf.con_valefrete_codigo     = tpVF.VFNumero
                                 and vf.con_valefrete_serie      = tpVF.VFSerie
                                 and vf.glb_rota_codigovalefrete = tpVF.VFRota
                                 and vf.con_valefrete_saque      = tpVF.VFSaque
                                 and vf.con_conhecimento_codigo  = c.con_conhecimento_codigo
                                 and vf.con_conhecimento_serie   = c.con_conhecimento_serie
                                 and vf.glb_rota_codigo          = c.glb_rota_codigo)
             loop

               select count(*)
                 into vExisteCancel
                 from t_con_eventocte ll
                where ll.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
                  and ll.con_conhecimento_serie  = c_cursor.con_conhecimento_serie
                  and ll.glb_rota_codigo         = c_cursor.glb_rota_codigo
                  and ll.glb_eventosefaz_codigo  = '4';

               vQtdeTotalCancel := vQtdeTotalCancel+ vExisteCancel;
               If vExisteCancel > 0 Then
                 vListaPedidoCancel := vListaPedidoCancel || c_cursor.con_conhecimento_codigo || '-' || 
                                                             c_cursor.con_conhecimento_serie  || '-' || 
                                                             c_cursor.glb_rota_codigo         || '-' || chr(10);
               End If;

               if pkg_con_cte.FN_CTE_EELETRONICO(c_cursor.con_conhecimento_codigo,c_cursor.con_conhecimento_serie,c_cursor.glb_rota_codigo) = 'N' Then
                  vQtdeCteNautorizado := vQtdeCteNautorizado + 1;
                  vListaNaoAutorizados := vListaNaoAutorizados || c_cursor.con_conhecimento_codigo || '-' || c_cursor.con_conhecimento_serie ||'-' || c_cursor.glb_rota_codigo || chr(10);
               Else
                  if vExisteCancel = 0 Then
                     vTemAverbacao := 0;
                     vTemErroAverbacao := 0;
                     vErroAverbacao := '';
                     If ( tdvadm.pkg_slf_calculos.F_BUSCA_CONHEC_TPFORMULARIO(c_cursor.con_conhecimento_codigo,
                                                                              c_cursor.con_conhecimento_serie,
                                                                              c_cursor.glb_rota_codigo) = 'CTRC' ) and
                        ( c_cursor.con_conhecimento_dtembarque >= to_date('01/09/2017') ) Then
                        Begin
                            select ea.con_erroaverbacao_msgerro erro,
                                   sum(nvl(ea.con_erroaverbacao_id,0)) erroaverbacao,
                                   sum(nvl(av.con_averbacao_id,0)) averbado
                              into vErroAverbacao,
                                   vTemErroAverbacao,
                                   vTemAverbacao
                            FROM TDVADM.T_CON_CONTROLECTRCE L,
                                 TDVADM.T_CON_AVERBACAO AV
                                 -- Pode existir uma averbação com erro, caso ocorra tera registro somente nesta tabela
                                 ,TDVADM.t_Con_Erroaverbacao ea
                           WHERE 0 = 0
                             --AND L.CON_CONTROLECTRCE_CHAVESEFAZ IN ('31170961139432007002571970008852491601359948','31170961139432007002571970008852481644580797','31170961139432007002571970008849401511967513','31170961139432007002571970008852501867798340','31170961139432007002571970008852441517681420','31170961139432007002571970008852461760100211','31170961139432007002571970008852471377155146')
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = AV.CON_AVERBACAO_CHAVECTE (+)
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = ea.con_erroaverbacao_chavecte  (+)
                             and l.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
                             and l.con_conhecimento_serie = c_cursor.con_conhecimento_serie
                             and l.glb_rota_codigo = c_cursor.glb_rota_codigo
                           group by ea.con_erroaverbacao_msgerro;
                       Exception
                         When NO_DATA_FOUND Then
                             vErroAverbacao := 1;
                             vErroAverbacao := 'Registro não Encontrado na Tabela de Averbação';
                             vTemAverbacao  := 0;
                         When TOO_MANY_ROWS Then
                            select ea.con_erroaverbacao_msgerro erro,
                                   sum(nvl(ea.con_erroaverbacao_id,0)) erroaverbacao,
                                   sum(nvl(av.con_averbacao_id,0)) averbado
                              into vErroAverbacao,
                                   vTemErroAverbacao,
                                   vTemAverbacao
                            FROM TDVADM.T_CON_CONTROLECTRCE L,
                                 TDVADM.T_CON_AVERBACAO AV
                                 -- Pode existir uma averbação com erro, caso ocorra tera registro somente nesta tabela
                                 ,TDVADM.t_Con_Erroaverbacao ea
                           WHERE 0 = 0
                             --AND L.CON_CONTROLECTRCE_CHAVESEFAZ IN ('31170961139432007002571970008852491601359948','31170961139432007002571970008852481644580797','31170961139432007002571970008849401511967513','31170961139432007002571970008852501867798340','31170961139432007002571970008852441517681420','31170961139432007002571970008852461760100211','31170961139432007002571970008852471377155146')
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = AV.CON_AVERBACAO_CHAVECTE (+)
                             AND L.CON_CONTROLECTRCE_CHAVESEFAZ = ea.con_erroaverbacao_chavecte  (+)
                             and l.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
                             and l.con_conhecimento_serie = c_cursor.con_conhecimento_serie
                             and l.glb_rota_codigo = c_cursor.glb_rota_codigo
                             and ea.con_erroaverbacao_dtcadastro = (select max(ea1.con_erroaverbacao_dtcadastro)
                                                                    from TDVADM.t_Con_Erroaverbacao ea1
                                                                    where ea1.con_erroaverbacao_chavecte = ea.con_erroaverbacao_chavecte) 
                           group by ea.con_erroaverbacao_msgerro;
                            
                         When OTHERS Then
                             vErroAverbacao := 1;
                             vErroAverbacao := 'Retornou mais de Um Registro na pesquisa da Averbação';
                             vTemAverbacao  := 0;
                         End;    
                       If vTemAverbacao = 0 Then
                          vListaNaoAverbados := vListaNaoAverbados || c_cursor.con_conhecimento_codigo || '-' || 
                                                                      c_cursor.glb_rota_codigo         || '-' ||
                                                                      tdvadm.f_mascara_valor(c_cursor.VLRMERC,12,2) || chr(10);
                          If vTemErroAverbacao <> 0 Then
                             vListaNaoAverbados := vListaNaoAverbados || '   Erro - ' || trim(vErroAverbacao) || chr(10);
                          End If;

                       End IF;
                     End If;
                  End If;
               End If;                    
             end loop;
             
             If Length(trim(vListaNaoAverbados)) <> 0 Then
                vListaNaoAverbados := 'CTe´ Não Averbados' || chr(10) || vListaNaoAverbados;
                If vRotaSemAverbacao = 'N' Then                
                   P_STATUS :=  tdvadm.PKG_GLB_COMMON.Status_Erro;
                   P_MESSAGE := P_MESSAGE || vListaNaoAverbados;
                End If;
                wservice.pkg_glb_email.SP_ENVIAEMAIL('AVERBACAO',
                                                     vListaNaoAverbados,
                                                     'aut-e@dellavolpe.com.br',
                                                     'ksouza@dellavolpe.com.br;sdrumond@dellavolpe.com.br;emsouza@dellavolpe.com.br');
             End If;

             if (vQtdeTotalCancel > 0)  then
                  tpVF.vPodeImprimir := 'N';
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || 'Existem CTé(s) nesse vale frete com solicitação de cancelamento |||' || chr(10) || vListaPedidoCancel;
             end if;

  

             select vf.con_valefrete_datacadastro
               into tpVF.vAuxiliarData
             from tdvadm.t_con_valefrete vf
             where vf.con_conhecimento_codigo = tpVF.VFNumero
               and vf.con_conhecimento_serie  = tpVF.VFSerie
               and vf.glb_rota_codigo         = tpVF.VFRota
               and vf.con_valefrete_saque     = tpVF.VFSaque;


             if (vQtdeCteNautorizado > 0) and ( tpVF.vAuxiliarData >= add_months(sysdate,-60) )  then
                  tpVF.vPodeImprimir := 'N';
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || 'Existem CTé(s) não Autorizados na SEFAZ |||' || chr(10) || vListaNaoAutorizados;
             end if;


           end;
           /********************************************************/

        
         

         -- Verifica se o Agregado esta desengatado antes de imprimir
         If (substr(tpVF.VFCON_VALEFRETE_PLACA,1,3) <> '000') then
      
            Begin
            select v.frt_veiculo_codigo
              into tpVF.vAuxiliarTexto
            from t_frt_veiculo v
            where v.frt_veiculo_placa = tpVF.tpValeFrete.CON_VALEFRETE_PLACA
              and substr(v.frt_veiculo_codigo,1,1) = 'A'
              and v.frt_veiculo_datavenda is null;

              select count(*)
                into tpVF.vAuxiliar
              from t_frt_conteng ce
              where trim(ce.frt_conjveiculo_codigo) = trim(tpVF.vAuxiliarTexto); 
              
              If tpVF.vAuxiliar < 2 then
                 tpVF.vAuxiliarTexto := tpVF.vAuxiliarTexto;
              Else
                 If tpVF.tpValeFrete.GLB_TPMOTORISTA_CODIGO = 'C' Then
--                    P_STATUS := pkg_glb_common.Status_Erro ;
                    
                    P_MESSAGE := P_MESSAGE || 'PERCENTUAL DE AGREGADO NAO COBRADO ' || chr(10) ||
                                              'EXCLUA O VALE DE FRETE E TENTE NOVAMENTE ' || chr(10);
                 End If;
                 tpVF.vAuxiliarTexto := 'NA';
              End If;
                 
            Exception
              When NO_DATA_FOUND Then
                 tpVF.vAuxiliarTexto := 'NA';
              End;
            If substr(tpVF.vAuxiliarTexto,1,3) = 'A00' Then
--                    P_STATUS := pkg_glb_common.Status_Erro ;
                    P_MESSAGE := P_MESSAGE || 'AGREGADO ' || tpVF.vAuxiliarTexto  || ' ESTA DESENGATDO ' || chr(10) ||
                                              'Favor ENGATAR ou DESAGREGAR' || chr(10);
            end If;
            
              
 
         End If;
          -- procura por cte não autorizados
          tpVf.vAuxiliar := 1;
          FOR R_CURSOR IN (select v.con_conhecimento_codigo||'-'||v.glb_rota_codigo cte
                           from t_con_vfreteconhec v
                           where v.con_valefrete_codigo = tpVF.VFNumero
                             and v.con_valefrete_serie  = tpVF.VFSerie
                             and v.glb_rota_codigovalefrete = tpVF.VFRota
                             and v.con_valefrete_saque  = tpVF.VFSaque
                             and PKG_CON_CTE.FN_CTE_EELETRONICO(v.con_conhecimento_codigo,
                                                                v.con_conhecimento_serie,
                                                                v.glb_rota_codigo) = 'N')
           loop
              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              if tpVF.vAuxiliar = 1 Then
                  P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
                  P_MESSAGE := P_MESSAGE || 'Conhecimentos Não Autorizados' || chr(10);
              End If;
              tpVF.vAuxiliar := tpVF.vAuxiliar + 1;
              P_MESSAGE := P_MESSAGE || R_CURSOR.cte || chr(10);
           End Loop;


          tpVF.VFCON_VALEFRETE_MULTA :=  nvl(tpVF.VFCON_VALEFRETE_MULTA,0);
          vInserDebito := 'S';
          
          If ( ( tpVF.tpValeFrete.glb_tpmotorista_codigo <> 'F' )  and 
               nvl(tpVF.tpValeFrete.Con_Valefrete_Impresso,'N') <>  'S' ) Then
            
            If tpVF.VFAcao = 'Salvar' Then
              
              if tpVF.VFCON_CATVALEFRETE_CODIGO != 10 then
                
               delete t_car_contacorrente cc
               where trim(cc.car_Contacorrente_Docref) = tpVF.VFNumero || tpVF.VFRota || tpVF.VFSaque
                 and 0 = (select count(*)
                          from tdvadm.t_con_valefrete vf
                          where vf.con_conhecimento_codigo = tpVF.VFNumero
                            and vf.glb_rota_codigo = tpVF.VFRota
                            and vf.con_valefrete_saque = tpVF.VFSaque
                            and nvl(vf.con_valefrete_impresso,'N') = 'S');
              end if;
            
             tpVF.VFCON_VALEFRETE_MULTA := 0;
                   
            End If;
            
            select sum(cc.car_contacorrente_valor)
               into tpvf.vAuxiliar
            from v_car_contacorrente cc
            where cc.docref = rpad(tpVF.VFNumero || tpVF.VFRota || tpVF.VFSaque,20)
              and cc.car_contacorrente_tplanc = 'C' ;

          Else
            tpvf.vAuxiliar := 0;
          End If;     

          If nvl(tpvf.vAuxiliar,0) > tpVF.VFCON_VALEFRETE_MULTA   Then
             tpVF.VFCON_VALEFRETE_MULTA := tpvf.vAuxiliar;
             If tpVF.VFAcao = 'Imprimir' Then
                vInserDebito := 'N';
                P_MESSAGE := P_MESSAGE || '(Vld) Valor da Multa Foi Alterado! Salve novamente o Vale de Frete Antes de IMPRIMIR.' || chr(10);
                P_MESSAGE := P_MESSAGE || 'Conta Corrente ' || f_mascara_valor(tpvf.vAuxiliar,20,2);
                P_STATUS := pkg_glb_common.Status_Erro;
             End If;

          ElsIf ( nvl(tpvf.vAuxiliar,0) < tpVF.VFCON_VALEFRETE_MULTA )  Then
             vInserDebito := 'N';
             P_MESSAGE := P_MESSAGE || 'Verificar No Conta corrente!' || chr(10) || 'Valor da Multa estava maior no Vale de Frete e Maior que o Registrado no Conta corrente' || chr(10);
             P_MESSAGE := P_MESSAGE || 'Numero Pesquisado ' || rpad(tpVF.VFNumero || tpVF.VFRota || tpVF.VFSaque,20);
             P_MESSAGE := P_MESSAGE || 'Valor no CC ' || f_mascara_valor(tpvf.vAuxiliar,10,2) || chr(10) || 'Valor no VF ' || f_mascara_valor(tpVF.VFCON_VALEFRETE_MULTA,10,2);
             tpVF.VFCON_VALEFRETE_MULTA := tpvf.vAuxiliar;
             P_STATUS := pkg_glb_common.Status_Erro;
          ElsIf ( nvl(tpvf.vAuxiliar,0) = tpVF.VFCON_VALEFRETE_MULTA ) and nvl(tpvf.vAuxiliar,0) <> 0 Then
             vInserDebito := 'N';
          End If;
          if nvl(trim(P_STATUS),'N') = pkg_glb_common.Status_Erro Then
            if ( tpVF.VFCON_CATVALEFRETE_CODIGO != 10 ) then
            
              delete t_car_contacorrente cc
               where trim(cc.car_Contacorrente_Docref) = tpVF.VFNumero || tpVF.VFRota || tpVF.VFSaque
                and 0 = (select count(*)
                         from tdvadm.t_con_valefrete vf
                         where vf.con_conhecimento_codigo = tpVF.VFNumero
                           and vf.glb_rota_codigo = tpVF.VFRota
                           and vf.con_valefrete_saque = tpVF.VFSaque
                           and nvl(vf.con_valefrete_impresso,'N') = 'S');
              If sql%rowcount > 0 Then
                 tpVF.VFCON_VALEFRETE_MULTA := 0;
              End If;
            
            end if;
          End IF;

     End If;

      If tpVF.VFAcao in ('Salvar','Imprimir','Excluir','Alterar','Cancela') Then
          -- Verifica se falta alguma dado do Transportador no Vale de Frete
          -- Quando for da Categoria serviço de Terceiro.


          If ( tpVf.VFCON_CATVALEFRETE_CODIGO in (CatTServicoTerceiro) ) and ( tpVF.tpValeFrete.glb_tpmotorista_codigo = 'F' )  Then
             PKG_CON_VALEFRETE.SP_CON_CRIATITULO(tpVF.VFNumero,
                                                 tpVF.VFSerie,
                                                 tpVF.VFRota,
                                                 tpVF.VFSaque,
                                                 RPAD(tpVF.vFGLB_CLIENTE_CGCCPFCODIGO,20),
                                                 tpVF.VFusuarioTDV,
                                                 tpVF.VFAcao,
                                                 vStatus,
                                                 vMessage);
             If nvl(trim(P_STATUS),'N') <> pkg_glb_common.Status_Erro Then
                P_STATUS := vStatus;
             End IF;
             P_MESSAGE := P_MESSAGE ||  vMessage;

          End If;

          /* Thiago 04/09/2019 - Alteração para pegar data máxima das entregas
             e atualizar a tabela T_CON_VALEFRETE com a maior data e hora */
          If tpVF.VFAcao = 'Salvar' Then
                 
             SELECT MAX(E.CON_VFRETEENTREGA_DTENTREGA)
               INTO vDataMaximaEntrega
             FROM TDVADM.t_Con_Vfreteentrega E 
             WHERE E.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
               AND E.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
               AND E.GLB_ROTA_CODIGO         = tpVF.VFRota
               AND E.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;
              /*     
              UPDATE TDVADM.T_CON_VALEFRETE V
                 SET V.CON_VALEFRETE_DATAPRAZOMAX = to_char(vDataMaximaEntrega, 'DD/MM/YYYY'),
                     V.CON_VALEFRETE_HORAPRAZOMAX = to_char(vDataMaximaEntrega, 'HH24:MI:SS')
              WHERE V. CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                AND V.CON_CONHECIMENTO_SERIE   = tpVF.VFSerie
                AND V.GLB_ROTA_CODIGO          = tpVF.VFRota
                AND V.CON_VALEFRETE_SAQUE      = tpVF.VFSaque;
              */    
          End If;
                               
     End If;


      if tpVF.VFAcao = 'SO PARA DOCUMENTAR' Then
         tpVF.VFAcao := tpVF.VFAcao;
      Elsif tpVF.VFAcao = 'RetiraImpressao' Then
         if nvl(trim(P_STATUS),'N') <> pkg_glb_common.Status_Erro Then
            if tpVF.tpValeFrete.con_valefrete_impresso = 'N' Then
               P_STATUS := pkg_glb_common.Status_Erro;
               P_MESSAGE := P_MESSAGE || 'Vale De Frete Não esta Impresso...';
            Else
               -- verificar o mes de emissao se pode tirar a impressao
               if tpVF.VFCON_CATVALEFRETE_CODIGO = CatTServicoTerceiro Then
                  update t_con_valefrete vf
                    set vf.con_valefrete_impresso = 'A'
                  where vf.con_conhecimento_codigo = tpvf.VFNumero
                    and vf.con_conhecimento_serie = tpVF.VFSerie
                    and vf.glb_rota_codigo = tpVF.VFRota
                    and vf.con_valefrete_saque = tpVF.VFSaque;
               Else
                  P_MESSAGE := P_MESSAGE || 'Passei no Update ' || chr(10);
                  update t_con_valefrete vf
                    set vf.con_valefrete_impresso = null
                  where vf.con_conhecimento_codigo = tpVF.VFNumero
                    and vf.con_conhecimento_serie = tpVF.VFSerie
                    and vf.glb_rota_codigo = tpVF.VFRota
                    and vf.con_valefrete_saque = tpVF.VFSaque;
 --                          SELECT * FROM T_CON_VALEFRETE

                  if tpVF.v_TpProprietario = 'F' Then
                      vParametros :=                '<Parametros> ';
                      vParametros := vParametros || '   <Input>';
                      vParametros := vParametros || '     <pProprietario>' || tpVF.v_Proprietario || '</pProprietario> ';
                      vParametros := vParametros || '     <pReferencia>' || TO_CHAR(tpVF.tpValeFrete.con_valefrete_datacadastro,'MM/YYYY') || '</pReferencia>';
                      vParametros := vParametros || '     <pRotaUsuario></pRotaUsuario>';
                      vParametros := vParametros || '     <pUsuario/>';
                      vParametros := vParametros || '     <pAplicacao/>';
                      vParametros := vParametros || '     <pVersao/>';
                      vParametros := vParametros || '   </Input>';
                      vParametros := vParametros || '</Parametros>';

                      pkg_car_proprietario.Sp_Calcula_SaldoCarreteiro(vParametros,vStatus,vMessage);
                      If vStatus <> pkg_glb_common.Status_Nomal Then
                         P_STATUS := vStatus;
                         P_MESSAGE := P_MESSAGE || vMessage || chr(10);
                      End If;
                   End If;
               End If;
            End If;
         End If;
      ElsIf tpVF.VFAcao = 'Salvar' Then

           if ( tpVF.vPrimeiroSaque = tpvf.VFSaque ) and -- Primeiro Saque Valido
              ( tpVf.VFCON_CATVALEFRETE_CODIGO not in (CatTServicoTerceiro,
                                                       CatTAvulsoSCTRC,
                                                       CatTRemocao,
                                                       CatTTranspesa) ) and
              ( tpVF.VFRotaUsuarioTDV <>  tpVF.VFRota ) and  -- Rota do Usuario tem que ser igual a do Vale Frete
              ( tpVF.VFRotaUsuarioTDV <>  tpVF.vRotaCaixa ) Then -- Rota do Usuario tem que ser igual a do Caixa
               P_STATUS := pkg_glb_common.Status_Erro;
               P_MESSAGE := P_MESSAGE || 'Emissao PROIBIDA, Voce não pertence a Rota do Vale de Frete' || chr(10);
            End if;

            -- Verifica se existe algum conhecimento feito pelo FIFO
            -- e Este e o primeiro SAQUE valido não feito pelo FIFO

            If ( tpVF.vPrimeiroSaque = tpvf.VFSaque ) and -- Primeiro Saque Valido
               ( tpVf.VFCON_CATVALEFRETE_CODIGO not in (CatTUmaViagem) ) Then

                   if nvl(tpVf.vCriadoPeloFIFO,'N') = 'N' Then
                   begin
                       select sum(decode(nvl(c.arm_carregamento_codigo,'A'),'A',1,0)) semcarreg,
                              sum(decode(nvl(c.arm_carregamento_codigo,'A'),'A',0,1)) comcarreg
                          into vQtdeCTesemCarreg,
                               vQtdeCTecomCarreg
                       from t_con_valefrete vf,
                            t_con_vfreteconhec vfc,
                            t_con_conhecimento c
                       where vf.con_conhecimento_codigo = tpVF.VFNumero
                         and vf.con_conhecimento_serie  = tpVF.VFSerie
                         and vf.glb_rota_codigo         = tpVF.VFRota
                         and vf.con_valefrete_saque     = tpVF.VFSaque
                         and vf.con_conhecimento_codigo = vfc.con_valefrete_codigo
                         and vf.con_conhecimento_serie  = vfc.con_valefrete_serie
                         and vf.glb_rota_codigo         = vfc.glb_rota_codigovalefrete
                         and vf.con_valefrete_saque     = vfc.con_valefrete_saque
                         and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                         and vfc.con_conhecimento_serie  = c.con_conhecimento_serie
                         and vfc.glb_rota_codigo         = c.glb_rota_codigo
                      group by vf.con_valefrete_fifo;
                 exception when OTHERS then
                     vQtdeCTesemCarreg := 0;
                     vQtdeCTecomCarreg := 0;
                 end;

                  if vQtdeCTecomCarreg > 0 Then
                     P_STATUS := pkg_glb_common.Status_Erro;
                     P_MESSAGE := P_MESSAGE || 'EREmissao PROIBIDA, Conhecimento com NR de CARREGAMENTO somete VALE DE FRETE PELO FIFO' || chr(10);
                  End If;

               End If;


            End If;

      -- Colocar aqui as Critica sa Sub Categoria
          -- Grava o XML para testar
 --        trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpSubCategoria.Con_Subcatvalefrete_Xmlvalid ,'UFORIGEM' ))
         -- CRITICA SE O VALOR DO FRETE FOI ALTERADO

          
          -- Se for maior que Zero verifica se esta autorizado
          If tpvf.vFCF_FRETECAR_ACRESCIMO > 0 Then
              Begin
                  select cad.cad_frete_status status
    --                     ,cad.cad_frete_solicitacao
    --                     ,c.slf_contrato_descricao || '-' || cad.slf_contrato_codigo contrato
    --                     ,cad.fcf_tpcarga_codigo || '-' || tc.fcf_tpcarga_descricao carga
                         ,cad.glb_localidade_origem || '-' || tdvadm.fn_busca_codigoibge(cad.glb_localidade_origem,'LOD') origem
                         ,cad.glb_localidade_destino || '-' || tdvadm.fn_busca_codigoibge(cad.glb_localidade_destino,'LOD') destino
                         ,cad.fcf_tpveiculo_codigo || '-' || tv.fcf_tpveiculo_descricao veiculo
                         ,cad.cad_frete_pesoestimado peso
    --                     ,cad.cad_frete_km distancia
                         ,cad.cad_frete_jacadastrado frete
                         ,cad.cad_frete_novovalor novovalor
                         ,cad.cad_frete_novovalor_ajudante ajudante
                         ,cad.cad_frete_aprovado aprovador
                         ,decode(nvl(cad.cad_frete_vlraprovado,0),0,cad.cad_frete_novovalor,
                                                                    cad.cad_frete_vlraprovado) vlraprovado
                         ,cad.cad_frete_observacao observacao
    --                     ,cad.cad_frete_codigo acrescimo
    --                     ,sv.fcf_solveic_cod solicitacao
    --                     ,fc.fcf_fretecar_rowid IDFrete
                      into tpvf.vFCF_CADFRETE_STATUS,
                           tpvf.vFCF_CADFRETE_ORIGEM,
                           tpvf.vFCF_CADFRETE_DESTINO,
                           tpvf.vFCF_CADFRETE_VEICULO,
                           tpvf.vFCF_CADFRETE_PESO,
                           tpvf.vFCF_CADFRETE_FRETE,
                           tpvf.vFCF_CADFRETE_NOVOVALOR,
                           tpvf.vFCF_CADFRETE_AJUDANTE,
                           tpvf.vFCF_CADFRETE_APROVADOR,
                           tpvf.vFCF_CADFRETE_VALORAPROVADO,
                           tpvf.vFCF_FRETECAR_OBSERVACAO
                  from tdvadm.t_fcf_solveic sv,
                       tdvadm.t_fcf_fretecar fc,
                       tdvadm.t_cad_frete cad,
                       tdvadm.t_slf_contrato c,
                       tdvadm.t_fcf_tpcarga tc,
                       tdvadm.t_fcf_tpveiculo tv
                  where sv.fcf_veiculodisp_codigo = tpvf.vFCF_VEICULODISP_CODIGO
                    and sv.fcf_veiculodisp_sequencia = tpvf.vFCF_VEICULODISP_SEQUENCIA
                    and sv.fcf_fretecar_rowid = fc.fcf_fretecar_rowid
                    and sv.fcf_solveic_cod = cad.fcf_solveic_cod 
                    and fc.fcf_fretecar_rowid = cad.fcf_fretecar_rowid
                    and cad.cad_frete_data = (select max(cad1.cad_frete_data)
                                              from tdvadm.t_cad_frete cad1
                                              where cad1.fcf_solveic_cod = cad.fcf_solveic_cod)
                    and cad.fcf_tpcarga_codigo = tc.fcf_tpcarga_codigo
                    and cad.fcf_tpveiculo_codigo = tv.fcf_tpveiculo_codigo
                    and cad.slf_contrato_codigo = c.slf_contrato_codigo;
             exception
               When NO_DATA_FOUND Then
                   tpvf.vFCF_CADFRETE_STATUS := null;
                   tpvf.vFCF_CADFRETE_ORIGEM := null;
                   tpvf.vFCF_CADFRETE_DESTINO := null;
                   tpvf.vFCF_CADFRETE_VEICULO := null;
                   tpvf.vFCF_CADFRETE_PESO := null;
                   tpvf.vFCF_CADFRETE_FRETE := null;
                   tpvf.vFCF_CADFRETE_NOVOVALOR := null;
                   tpvf.vFCF_CADFRETE_AJUDANTE := null;
                   tpvf.vFCF_CADFRETE_APROVADOR := null;
                   tpvf.vFCF_CADFRETE_VALORAPROVADO := null;
               End;
          Else
             tpvf.vFCF_CADFRETE_STATUS := null;
             tpvf.vFCF_CADFRETE_ORIGEM := null;
             tpvf.vFCF_CADFRETE_DESTINO := null;
             tpvf.vFCF_CADFRETE_VEICULO := null;
             tpvf.vFCF_CADFRETE_PESO := null;
             tpvf.vFCF_CADFRETE_FRETE := null;
             tpvf.vFCF_CADFRETE_NOVOVALOR := null;
             tpvf.vFCF_CADFRETE_AJUDANTE := null;
             tpvf.vFCF_CADFRETE_APROVADOR := null;
             tpvf.vFCF_CADFRETE_VALORAPROVADO := null;
          End If;

          If tpvf.vFCF_CADFRETE_STATUS Is Not Null Then
             If tpvf.vFCF_CADFRETE_STATUS = 'RJ' Then
                If vBloqAltFrete = 'S' Then
                   P_STATUS := pkg_glb_common.Status_Erro;
                End If;
                P_MESSAGE := P_MESSAGE || 'Solicitação de Alteracao de FRETE REJEITADA' || chr(10);
              ElsIf tpvf.vFCF_CADFRETE_STATUS = 'AG' Then                
                If vBloqAltFrete = 'S' Then
                   P_STATUS := pkg_glb_common.Status_Erro;
                End If;
                P_MESSAGE := P_MESSAGE || 'Solicitação de Alteracao de FRETE AGUARDANDO APROVACAO' || chr(10);
              ElsIf tpvf.vFCF_CADFRETE_STATUS in ('ALT','AP') Then       
                Begin 
                    select p.usu_perfil_paran1
                      into vPercentExpresso
                    from tdvadm.t_usu_perfil p
                    where p.usu_aplicacao_codigo = 'veicdisp'
                      and p.usu_perfil_codigo = 'PER_EXPRESSO'
                      and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                                   from tdvadm.t_usu_perfil p1
                                                   where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                                     and p1.usu_perfil_codigo = p.usu_perfil_codigo
                                                     and trunc(p1.usu_perfil_vigencia) <= trunc(sysdate));
                    vPercentExpresso := 1 + (vPercentExpresso /100);
                exception
                  When NO_DATA_FOUND Then
                     vPercentExpresso := 1;
                
                
                End;
                Update tdvadm.t_fcf_veiculodisp vd
                  set vd.fcf_veiculodisp_acrescimo = round( ( tpvf.vFCF_CADFRETE_VALORAPROVADO - tpvf.vFCF_CADFRETE_FRETE) * decode(vd.fcf_veiculodisp_tpfrete,'N',1,vPercentExpresso),2) ,
                      vd.fcf_veiculodisp_obsacrescimo = substr(tpvf.vFCF_FRETECAR_OBSERVACAO,1,200) 
                where vd.fcf_veiculodisp_codigo = tpvf.vFCF_VEICULODISP_CODIGO
                  and vd.fcf_veiculodisp_sequencia = tpvf.vFCF_VEICULODISP_SEQUENCIA;

                tpvf.vFCF_FRETECAR_ACRESCIMO := tpvf.vFCF_CADFRETE_VALORAPROVADO - tpvf.vFCF_CADFRETE_FRETE;        

                P_MESSAGE := P_MESSAGE || 'Solicitação de Alteracao de FRETE AUTORIZADA' || chr(10);
              End If;
-- CAD - Cadastrado



           End If;


          if tpVF.vFCF_VEICULODISP_TPFRETE = 'E' Then
               -- ESTOU VERIFICANDO SE A COLETA E EXPRESSA
               -- NAO DEVERIA SER O CTE ?????
         
        SELECT SUM(QTDE) into tpVF.vAuxiliar
        FROM (select count(*) QTDE
                       from TDVADM.t_arm_nota an,
                            TDVADM.T_ARM_COLETA CO,
                            TDVADM.t_con_vfreteconhec vfc
                       where 0 = 0
                         AND AN.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA (+)
                         AND AN.ARM_COLETA_CICLO   = CO.ARM_COLETA_CICLO (+)
                         and an.con_conhecimento_codigo     = vfc.con_conhecimento_codigo
                         and an.con_conhecimento_serie      = vfc.con_conhecimento_serie
                         and an.glb_rota_codigo             = vfc.glb_rota_codigo
                         AND CO.ARM_COLETA_TPCOLETA       = 'E'
                         AND VFC.CON_VALEFRETE_CODIGO = tpVF.VFNumero
                         AND VFC.CON_VALEFRETE_SERIE = tpVF.VFSerie
                         AND VFC.GLB_ROTA_CODIGOVALEFRETE = tpVF.VFRota
                         AND VFC.CON_VALEFRETE_SAQUE = tpVF.VFSaque
                    UNION
                    SELECT COUNT(*) QTDE
                    FROM TDVADM.T_CON_VFRETECONHEC VFC,
                         TDVADM.T_CON_CONHECIMENTO C,
                         TDVADM.T_ARM_COLETA CO
                     WHERE VFC.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
                       AND VFC.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
                       AND VFC.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
                       AND C.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA
                       AND C.ARM_COLETA_CICLO = CO.ARM_COLETA_CICLO
                       AND C.ARM_CARREGAMENTO_CODIGO IS NULL
                       AND CO.ARM_COLETA_TPCOLETA       = 'E'
                       AND VFC.CON_VALEFRETE_CODIGO = tpVF.VFNumero
                       AND VFC.CON_VALEFRETE_SERIE = tpVF.VFSerie
                       AND VFC.GLB_ROTA_CODIGOVALEFRETE = tpVF.VFRota
                       AND VFC.CON_VALEFRETE_SAQUE = tpVF.VFSaque);

               If tpVF.vAuxiliar = 0 Then
                  P_STATUS := pkg_glb_common.Status_Erro;
                  P_MESSAGE := P_MESSAGE || 'ERRO NA SOL. DO VEICULO ' || tpvf.vFCF_VEICULODISP_CODIGO || ' - CTe´s SEM COLETA EXPRESSA' || chr(10);
               End if;
          End if;

          -- Pega o Ultimo Valido para verificar se foi pago no Caixa
          -- ou se esta em acerto
        If tpVF.vUltimoSaqueValido > 0 Then
           Select decode(nvl(vf.cax_movimento_sequencia,0),0,'N','S'),
                  decode(nvl(vf.acc_contas_ciclo,0),0,'N','S'),
                  nvl(tpVF.vSQAntPagoCx,'N')
             Into tpVF.vSQAntPagoCx,
                  tpVF.vSQAntPagoAc,
                  tpVF.vStatusVF
           From t_con_valefrete vf
           Where vf.con_conhecimento_codigo = tpVF.VFNumero
             And vf.con_conhecimento_serie  = tpVF.VFSerie
             And vf.glb_rota_codigo         = tpVF.VFRota
             And vf.con_valefrete_saque     = tpVF.vUltimoSaqueValido;
        Else
           tpVF.vSQAntPagoCx := '';
           tpVF.vSQAntPagoCx := '';
           tpVF.vSQAntPagoCx := '';
        End if;

 --         P_MESSAGE := P_MESSAGE || 'Rota Travada ' || tpVf.vFCF_VEICULODISP_ROTATRAVAS || chr(10);

      if tpVF.VFNumero = '095526' Then
          P_MESSAGE := P_MESSAGE || 'Parametros ' || tpVf.vFCF_VEICULODISP_ROTATRAVAS || '-' || tpVf.vFCF_VEICULODISP_ALTERAFRETE || chr(10);
          P_MESSAGE := P_MESSAGE || tpVF.VFAplicacaoTDV || '-' || tpVF.VFusuarioTDV || '-' || tpVF.VFRotaUsuarioTDV || chr(10);
      End if;





         if ( tpVf.vFCF_VEICULODISP_ROTATRAVAS = 'S'  ) and  -- Rota Esta Travada
            ( tpVf.vFCF_VEICULODISP_ALTERAFRETE = 'N' ) and  -- Não pode Alterar Frete
            -- ver para colocar aqui as categorias a serem travadas
            ( tpVf.VFCON_CATVALEFRETE_CODIGO not in (CatTServicoTerceiro,
                                                     CatTVariasViagens,
                                                     CatTRemocao,
                                                     CatTTranspesa,
                                                     CatTEstadia,
                                                     CatTColeta,
                                                     CatTBonusManifesto,
                                                     CatTBonusCTRC,
                                                     CatTCocaCola) ) and
            ( tpVF.vExisteSubCategoria = 'N' ) and  -- Não tem Sub Categoria
             ( tpVF.vPrimeiroSaque = tpvf.VFSaque ) Then -- Primeiro Saque Valido


           if tpvf.vFCF_VEICULODISP_VALORFRETE + tpvf.vFCF_VEICULODISP_VALOREXCECAO + tpvf.vFCF_FRETECAR_ACRESCIMO < -- Frete Fechado na Mesa
              tpVF.vCON_VALEFRETE_CUSTOCARRETEIRO Then  -- Frete digitado no Vale de frete
              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := P_MESSAGE || 'ER-ERRO NO CUSTO COM VLR DE EXCECAO' || chr(10);
              if tpvf.vFCF_VEICULODISP_VALORFRETE = -1 Then
                 tpvf.vFCF_VEICULODISP_VALORFRETE   := 0;
                 P_MESSAGE := P_MESSAGE || 'ER-ROTA TRAVADA , FRETE NÃO VINCULADO NA MESA' || CHR(10);
              End If;

              P_MESSAGE := P_MESSAGE || 'Usuario      ' || tpVF.VFusuarioTDV || chr(10);
              P_MESSAGE := P_MESSAGE || 'Rota Usuario ' || tpVF.VFRotaUsuarioTDV || chr(10);
              P_MESSAGE := P_MESSAGE || 'Categoria VF ' || tpVf.VFCON_CATVALEFRETE_CODIGO || chr(10);
              P_MESSAGE := P_MESSAGE || 'Frete Mesa   ' || to_char(tpvf.vFCF_VEICULODISP_VALORFRETE,'99999999.99') || chr(10);
              P_MESSAGE := P_MESSAGE || 'Acrescimo    ' || to_char(tpvf.vFCF_FRETECAR_ACRESCIMO,'99999999.99') || chr(10);
              P_MESSAGE := P_MESSAGE || 'Excecao Mesa ' || to_char(tpvf.vFCF_VEICULODISP_VALOREXCECAO,'99999999.99') || chr(10);


              P_MESSAGE := P_MESSAGE || '**********************************' || chr(10) ;
              P_MESSAGE := P_MESSAGE || '  FRETE MAIOR QUE FECHADO NA MESA'  || chr(10);
              P_MESSAGE := P_MESSAGE || '     TRANSACAO NAO AUTORIZADA'      || chr(10);
              P_MESSAGE := P_MESSAGE || '**********************************' || chr(10) ;
           End if;

             If tpvf.vCON_VALEFRETE_TIPOCUSTO <> substr(tpvf.vFCF_FRETECAR_DESINENCIA,1,1) Then
                If plistaparams('ALTERA_TPCUSTO').texto = 'N' Then
                  P_STATUS := pkg_glb_common.Status_Erro;
                  P_MESSAGE := P_MESSAGE || 'ER-ROTA TRAVADA - Voce não pode Mudar o Tipo de Custo do Frete'  || chr(10);
                end if;
             End If;
           End if;

         If tpvf.tpValeFrete.con_valefrete_valorliquido < 0 Then
            P_STATUS := pkg_glb_common.Status_Erro;
            P_MESSAGE := P_MESSAGE || ' ER-SALDO ERRADO - Saldo não pode ser negativo '  || tpvf.tpValeFrete.con_valefrete_valorliquido || chr(10);
         End If;

          -- Se a Categoria for Coleta Ver se o Veiculo esta Auotrizado
          If tpVF.VFCON_CATVALEFRETE_CODIGO = CatTColeta Then
            Begin
                Select v.car_veiculo_coleta,
                       v.car_veiculo_coletaaut,
                       v.car_veiculo_coletavigencia
                  Into tpVF.v_Coleta,
                       tpVF.v_DtAutColeta,
                       tpVF.v_DtVigColeta
                 From t_car_veiculo v
                 Where v.car_veiculo_placa = tpVF.VFCON_VALEFRETE_PLACA
                   And v.car_veiculo_saque = tpVF.VFCON_VALEFRETE_PLACASAQUE;
            Exception
              When NO_DATA_FOUND Then
                 if SUBSTR(tpVF.VFCON_VALEFRETE_PLACA,1,3) = '000' Then
                    tpVF.v_Coleta := 'S';
                 Else
                    tpVF.v_Coleta := 'N';
                    tpVF.v_DtAutColeta := '01/01/1900';
                    P_STATUS := pkg_glb_common.Status_Erro;
                    P_MESSAGE := P_MESSAGE ||  'ERVale de Frete De Coleta - Veiculo ' || tpVF.VFCON_VALEFRETE_PLACA || tpVF.VFCON_VALEFRETE_PLACASAQUE ||  ' não Existe ! ' || chr(10);
                 End if;
              End;
              if SUBSTR(tpVF.VFCON_VALEFRETE_PLACA,1,3) = '000' Then
                 tpVF.v_Coleta := 'S';
              End if;
              If tpVF.v_Coleta = 'N' Then
                 P_STATUS := pkg_glb_common.Status_Erro;
                 P_MESSAGE := P_MESSAGE ||  'ERVale de Frete De Coleta - Veiculo ' || tpVF.VFCON_VALEFRETE_PLACA || tpVF.VFCON_VALEFRETE_PLACASAQUE ||  ' não AUTORIZADO ! ' || chr(10);
              Else
                 If trunc(tpVF.v_DtAutColeta) > trunc(Sysdate) Then
                    P_STATUS := pkg_glb_common.Status_Erro;
                    P_MESSAGE :=  P_MESSAGE || 'ERVeiculo ' || tpVF.VFCON_VALEFRETE_PLACA || tpVF.VFCON_VALEFRETE_PLACASAQUE || ' com Autorização  Futura ! - Autorizada A partir de - ' || to_char(tpVF.v_DtAutColeta,'dd/mm/yyyy') || chr(10);
                 End If;

                 If trunc(tpVF.v_DtVigColeta) <= trunc(Sysdate) Then
                    P_STATUS := pkg_glb_common.Status_Erro;
                    P_MESSAGE :=  P_MESSAGE || 'ERVeiculo ' || tpVF.VFCON_VALEFRETE_PLACA || tpVF.VFCON_VALEFRETE_PLACASAQUE || ' com Autorização  Vencida ! Vigencia - ' || to_char(tpVF.v_DtAutColeta,'dd/mm/yyyy') ||  '- Autorizada Até - ' || to_char(tpVF.v_DtVigColeta,'dd/mm/yyyy') ||chr(10);
                 End If;
              End If;
          End If;
          if tpVf.tpValeFrete.glb_tpmotorista_codigo = 'A' Then
              tpVF.v_LimiteDesconto := trunc(tpVF.tpValeFrete.CON_VALEFRETE_VALORCOMDESCONTO * ( to_number(tpVF.VFCON_VALEFRETE_PERCETDES) / 100 ));
          Else
              tpVF.v_LimiteDesconto := trunc(tpVF.tpValeFrete.Con_Valefrete_Frete * ( to_number(tpVF.VFCON_VALEFRETE_PERCETDES) / 100 ));
          End If;
          -- faz so se não for frota
 --(VFusuarioTDV = 'fsilva' )
 --         tpVF.v_LimiteDesconto := trunc(tpVF.vCON_VALEFRETE_CUSTOCARRETEIRO * ( to_number(tpVF.VFCON_VALEFRETE_PERCETDES) / 100 ));

           IF trim(sys_context('VALEFRETE','CODROTA')) = trim(tpVF.VFNumero || tpVF.VFRota) Then
              P_MESSAGE := P_MESSAGE || 'Prop ' || tpVF.v_Proprietario || chr(10);
              P_MESSAGE := P_MESSAGE || 'CC ' || f_mascara_valor(tpVF.vCON_VALEFRETE_CUSTOCARRETEIRO,20,2) || '-' || tpVF.vCON_VALEFRETE_TIPOCUSTO || chr(10);
              P_MESSAGE := P_MESSAGE || 'Ft ' || f_mascara_valor(tpVF.tpValeFrete.Con_Valefrete_Valorcomdesconto,20,2) || chr(10);
              P_MESSAGE := P_MESSAGE || 'Perc  ' || f_mascara_valor(tpVF.VFCON_VALEFRETE_PERCETDES,10,2) || chr(10);
              P_MESSAGE := P_MESSAGE || 'Vlr Multa ' || f_mascara_valor(tpVF.VFCON_VALEFRETE_MULTA,20,2) || chr(10);
              P_MESSAGE := P_MESSAGE || 'InDebito ' || vInserDebito || chr(10);
           End IF;
 --             raise_application_error(-20001,to_char(v_LimiteDesconto));
              if tpVF.v_LimiteDesconto > nvl(tpVF.VFCON_VALEFRETE_MULTA,0) Then
                 tpVF.v_ValorRestante  := ( tpVF.v_LimiteDesconto - nvl(tpVF.VFCON_VALEFRETE_MULTA,0) );
              Else
                 tpVF.v_ValorRestante       := tpVF.v_LimiteDesconto;
                 tpVF.VFCON_VALEFRETE_MULTA := nvl(tpVF.v_LimiteDesconto,0);
              End IF;
           IF trim(sys_context('VALEFRETE','CODROTA')) = trim(tpVF.VFNumero || tpVF.VFRota) Then
          P_MESSAGE := P_MESSAGE || 'Frete ' || f_mascara_valor(tpVF.tpValeFrete.Con_Valefrete_Valorcomdesconto,20,2) || chr(10);
          P_MESSAGE := P_MESSAGE || 'Limite ' ||  f_mascara_valor(tpVF.v_LimiteDesconto,20,2)  || chr(10);
          P_MESSAGE := P_MESSAGE || 'VlrRest ' || f_mascara_valor(tpVF.v_ValorRestante,20,2) || CHR(10);
          P_MESSAGE := P_MESSAGE || 'Status ' || nvl(trim(P_STATUS),'N') || chr(10);
 End If;
          If nvl(trim(P_STATUS),'N') = pkg_glb_common.Status_Nomal Then
              -- Rotina para não debitar os debitos
              -- enviando um email para o aut-e
              -- com o assunto abaixo
              --Exemplo de QryString = MSG=PRODEB;PROP=06045040805;PLACA=CFS0030;DTINICIO=01/11/2014;DTFIM=30/11/2014;
              vProrrogaDebito := 'N';
              select count(*)
                into tpVF.vAuxiliar
              from rmadm.t_glb_benasserec rec
              where rec.glb_benasserec_status = 'LB'
                and trim(tdvadm.fn_querystring(rec.Glb_Benasserec_Assunto, 'MSG', '=', ';')) = 'PRODEB'
                and trim(tdvadm.fn_querystring(rec.Glb_Benasserec_Assunto, 'PROP', '=', ';')) = tpVF.v_Proprietario
                and trunc(sysdate) between to_date(trim(tdvadm.fn_querystring(rec.Glb_Benasserec_Assunto, 'DTINICIO', '=', ';')),'dd/mm/yyyy') and to_date(trim(tdvadm.fn_querystring(rec.Glb_Benasserec_Assunto, 'DTFIM', '=', ';')),'dd/mm/yyyy') ;

              if tpVF.vAuxiliar > 0 Then
                 vProrrogaDebito := 'S';
              End If;

           IF trim(sys_context('VALEFRETE','CODROTA')) = trim(tpVF.VFNumero || tpVF.VFRota) Then
          P_MESSAGE := P_MESSAGE || 'Prorroga ' || vProrrogaDebito || chr(10);
           End If;

              If Not ( trim(tpVF.v_Proprietario) = '61139432000172') and
                 ( vProrrogaDebito = 'N' ) and
                 ( tpVF.VFCON_CATVALEFRETE_CODIGO not in (CatTServicoTerceiro,CatTReforco)  )   Then

           IF trim(sys_context('VALEFRETE','CODROTA')) = trim(tpVF.VFNumero || tpVF.VFRota) Then
                  P_MESSAGE := P_MESSAGE || 'limite ' || f_mascara_valor(tpVf.v_LimiteDesconto,20,2) || chr(10);
                  P_MESSAGE := P_MESSAGE || 'restante ' || f_mascara_valor(tpVf.v_ValorRestante,20,2) || chr(10);
                  P_MESSAGE := P_MESSAGE || 'Insere Debito ' || vInserDebito || chr(10);
                  P_MESSAGE := P_MESSAGE || 'Prorroga Debito ' || vProrrogaDebito || chr(10);


 End If;
                   If ( tpVF.v_ValorRestante > 0 ) and (vInserDebito = 'S' )  Then
                      If nvl(tpVF.tpValeFrete.con_valefrete_impresso,'N') = 'N' Then
                         delete t_car_contacorrente cc
                            where trim(cc.car_Contacorrente_Docref) = tpVF.VFNumero || tpVF.VFRota || tpVF.VFSaque;
                      End If;
                      FOR R_CURSOR IN(Select p.dtvenc,
                                             p.car_contacorrente_saldo,
                                             p.rowidcc,
                                             P.car_contacorrente_dtgravacao
                                      FROM v_Car_Contacorrente P
                                      WHERE trim(p.cpncnpjprop) = trim(tpVF.v_Proprietario)
                                        and p.dtfecha is Null
                                        and trunc(p.dtvenc) <= trunc(sysdate)
                                        And p.car_contacorrente_saldo > 0
 --                                       And trunc(p.car_contacorrente_dtgravacao) >= trunc(Sysdate - 1)
                                        And p.car_contacorrente_saldo = (Select Min(p1.car_contacorrente_saldo)
                                                                         From v_Car_Contacorrente P1
                                                                         WHERE trim(p1.cpncnpjprop) = trim(tpVF.v_Proprietario)
                                                                           And p1.documento = p.documento
                                                                           and trunc(p1.dtvenc) <= trunc(sysdate)
                                                                           and p.dtfecha is Null )
                                      Order By P.car_contacorrente_dtgravacao)

                      Loop
                          If tpVF.v_ValorRestante > 0  Then
                             Select *
                               Into tpVF.tpContaCorrente
                             From t_car_contacorrente cc
                             Where cc.rowid = r_cursor.rowidcc;

                              If  tpVF.tpContaCorrente.Car_Contacorrente_Saldo >=  tpVF.v_ValorRestante Then
                                  tpVF.v_Valoradescontar := tpVF.v_ValorRestante;
                              Else
                                  tpVF.v_Valoradescontar := tpVF.tpContaCorrente.Car_Contacorrente_Saldo;
                              End If;

                              tpVF.VFCON_VALEFRETE_MULTA := tpVF.VFCON_VALEFRETE_MULTA + tpVF.v_Valoradescontar;
                              tpVF.tpContaCorrente.Car_Contacorrente_Saldo := tpVF.tpContaCorrente.Car_Contacorrente_Saldo -  tpVF.v_Valoradescontar;
                              tpVF.v_ValorRestante := tpVF.v_ValorRestante - tpVF.v_Valoradescontar;

                              P_MESSAGE := P_MESSAGE || 'Descontar ' || to_char(tpVf.v_Valoradescontar) || chr(10);
                              P_MESSAGE := P_MESSAGE || 'restante ' || to_char(tpVf.v_ValorRestante) || chr(10);
                              P_MESSAGE := P_MESSAGE || 'Total Descontado ' || to_char(tpVf.VFCON_VALEFRETE_MULTA) || chr(10);

                              tpVF.tpContaCorrente.Car_Contacorrente_Docref := tpVF.VFNumero || tpVF.VFRota || tpVF.VFSaque;
 --                             tpVF.tpContaCorrente.car_contacorrente_docorigem := tpVF.VFNumero || tpVF.VFSerie || tpVF.VFRota || tpVF.VFSaque;

                              tpVF.tpContaCorrente.Car_Contacorrente_Valor := tpVF.v_Valoradescontar;
                              tpVF.tpContaCorrente.Car_Contacorrente_Tplanc := 'C';
                              tpVF.tpContaCorrente.Car_Contacorrente_Tplancamento := 'C';
                              tpVF.tpContaCorrente.Car_Contacorrente_Pagtomin := tpVF.tpContaCorrente.Car_Contacorrente_Saldo;
                              tpVF.tpContaCorrente.Car_Contacorrente_Data := Sysdate;
                              tpVF.tpContaCorrente.Car_Contacorrente_Dtgravacao := Sysdate;
                              tpVF.tpContaCorrente.Car_Contacorrente_Usuario := tpVF.VFusuarioTDV;
                              tpVF.tpContaCorrente.Car_Contacorrente_Sistorigem   := 'comvlfrete';
                              /* 23/11/2021 Sirlano, Vinicius Rezende
                              Alteramos a montagem do campo de Car_Contacorrente_Obs de  
                              'Desconto automatico feito no VF ' || tpVF.VFNumero || tpVF.VFSaque  || tpVF.VFRota || tpVF.VFSaque; Para:*/
                              tpVF.tpContaCorrente.Car_Contacorrente_Obs := 'Desconto automatico feito no VF ' || tpVF.VFNumero || tpVF.VFSerie || tpVF.VFRota || tpVF.VFSaque;


                                 P_STATUS :=  PKG_GLB_COMMON.Status_Warning;
                                 P_MESSAGE := P_MESSAGE || '11-Houve Desconto de Debito do CONTA CORRETE, Imprimir o Recibo se necessario.' || chr(10);

                               begin
                                 Insert Into t_car_contacorrente
                                 Values tpVF.tpContaCorrente;
                               Exception
                                 When OTHERS Then
                                    P_STATUS   := PKG_GLB_COMMON.Status_Erro;
                                     P_MESSAGE :=  P_MESSAGE || chr(10) ||
                                                                'Erro ao Inserir no Conta corrente Informe estes dados'                 || chr(10) ||
                                                                'Motorista - '    || tpVF.tpContaCorrente.CAR_CARRETEIRO_CPFCODIGO      || chr(10) ||
                                                                'Sq Motrista - '  || tpVF.tpContaCorrente.CAR_CARRETEIRO_SAQUE          || chr(10) ||
                                                                'Placa - '        || tpVF.tpContaCorrente.CAR_VEICULO_PLACA             || chr(10) ||
                                                                'Sq Placa - '     || tpVF.tpContaCorrente.CAR_VEICULO_SAQUE             || chr(10) ||
                                                                'Proprietario - ' || tpVF.tpContaCorrente.CAR_PROPRIETARIO_CGCCPFCODIGO || chr(10) ||
                                                                'Documento - '    || tpVF.tpContaCorrente.CAR_CONTACORRENTE_DOCUMENTO   || chr(10) ||
                                                                'Doc Ref - '      || tpVF.tpContaCorrente.CAR_CONTACORRENTE_DOCREF      || chr(10) ||
                                                                'Vencimento - '   || tpVF.tpContaCorrente.CAR_CONTACORRENTE_DTVENC      || chr(10) ||
                                                                'Valor - '        || tpVF.tpContaCorrente.Car_Contacorrente_Valor       || chr(10) ||
                                                                'erro-' || sqlerrm;

                                 End ;
                          End If;
                      End Loop;
                 End If;
     --            tem que devolver o valor descontado

             End If;
         End If;

      Elsif tpVF.VFAcao = 'Cancelando' Then
        If P_STATUS = tdvadm.pkg_glb_common.Status_Nomal Then
          Begin
           update tdvadm.t_con_valefrete vf
             set vf.con_valefrete_status = 'C'
           Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
             And VF.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
             And VF.GLB_ROTA_CODIGO         = tpVF.VFRota
             And VF.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;
            update tdvadm.t_arm_carregamento c
              set c.arm_carregamento_dtfinalizacao = null
            where c.arm_carregamento_codigo in (select distinct c.arm_carregamento_codigo
                                                from tdvadm.t_con_vfreteconhec vfc,
                                                     tdvadm.t_con_conhecimento c
                                                where vfc.con_valefrete_codigo     = tpVF.VFNumero
                                                  and vfc.con_valefrete_serie      = tpVF.VFSerie
                                                  and vfc.glb_rota_codigovalefrete = tpVF.VFRota
                                                  and vfc.con_valefrete_saque    = tpVF.VFSaque
                                                  and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                                                  and vfc.con_conhecimento_serie  = c.con_conhecimento_serie
                                                  and vfc.glb_rota_codigo         = c.glb_rota_codigo
                                                  and c.arm_carregamento_codigo is not null);
            
            commit;
           exception
             When OTHERS Then
                rollback;
           end ;  
        End If;
        P_MESSAGE := 'Em Desenvolcimento Favor tentar mais Tarde ... ' || P_MESSAGE;
      Elsif tpVF.VFAcao in ('Excluir','Cancela') Then
         If nvl(trim(P_STATUS),'N') <> PKG_GLB_COMMON.Status_Erro Then
             select count(*)
               into tpVf.vAuxiliar
             From t_con_vfreteciot vfc
             Where VFc.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
               And VFc.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
               And VFc.GLB_ROTA_CODIGO         = tpVF.VFRota
               And VFc.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;

             if tpVf.vAuxiliar > 0 Then
                P_MESSAGE := P_MESSAGE || '201-Vale de Frete tem CIOT vinculado ' || chr(10) ;
                P_STATUS := pkg_glb_common.Status_Erro;
             End If;
             
             if tpVf.tpValeFrete.con_valefrete_impresso = 'S' Then
                P_MESSAGE := P_MESSAGE || '211-Vale de Frete Já foi Impresso ' || chr(10);
                P_STATUS := pkg_glb_common.Status_Erro;
             End If;

             If  tpVF.VFAcao = 'Cancela' Then   
                 SP_CON_VERIFICACANCELVF(tpVF.VFNumero,
                                         tpVF.VFSerie,
                                         tpVF.VFRota,
                                         tpVF.VFSaque,
                                         vStatus,
                                         vMessage);
                 If vStatus <> pkg_glb_common.Status_Nomal Then                      
                    P_STATUS := vStatus;
                    P_MESSAGE := P_MESSAGE || vMessage;
                 End If;
             End If; 
             if P_STATUS = pkg_glb_common.Status_Nomal Then
                Delete t_car_contacorrente cc
                Where Trim(Car_Contacorrente_Docref) = tpVF.VFNumero || tpVF.VFRota || tpVF.VFSaque
                 and 0 = (select count(*)
                          from tdvadm.t_con_valefrete vf
                          where vf.con_conhecimento_codigo = tpVF.VFNumero
                            and vf.glb_rota_codigo = tpVF.VFRota
                            and vf.con_valefrete_saque = tpVF.VFSaque
                            and nvl(vf.con_valefrete_impresso,'N') = 'S');
                if tpVF.VFAcao = 'Excluir' then
                   Delete t_con_calcvalefrete vf
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                   
                   delete t_Con_Vfreteconhec vf
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                   
                   delete t_glb_vfimagem vf
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                   
                    
                   delete t_con_valefreteest VF
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                    
                   delete t_con_vfreteentrega VF
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                    
                    delete tdvadm.T_MON_CONTROLESOSFIRST vf
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                      
                   delete t_con_veicdispvf vf
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
 
                   update tdvadm.t_fcf_fretecarmemo vf
                      set vf.con_valefrete_codigo = null,
                          vf.con_valefrete_serie = null,
                          vf.glb_rota_codigo = null,
                          vf.con_valefrete_saque = null,
                          vf.arm_coleta_ncompra = null
                   where vf.con_valefrete_codigo = tpvf.VFNumero
                     and vf.con_valefrete_serie = tpVF.VFSerie
                      and vf.glb_rota_codigo = tpVF.VFRota
                     and vf.con_valefrete_saque = tpVF.VFSaque;

                   update tdvadm.t_fcf_fretecarmemo vf
                      set vf.con_valefrete_codigo2 = null,
                          vf.con_valefrete_serie2 = null,
                          vf.glb_rota_codigo2 = null,
                          vf.con_valefrete_saque2 = null,
                          vf.arm_coleta_ncompra = null
                   where vf.con_valefrete_codigo2 = tpvf.VFNumero
                     and vf.con_valefrete_serie2 = tpVF.VFSerie
                      and vf.glb_rota_codigo2 = tpVF.VFRota
                     and vf.con_valefrete_saque2 = tpVF.VFSaque;
                     
                   delete tdvadm.t_con_vfretecoleta vf
                   where vf.con_valefrete_codigo = tpvf.VFNumero
                     and vf.con_valefrete_serie = tpVF.VFSerie
                      and vf.glb_rota_codigovalefrete = tpVF.VFRota
                     and vf.con_valefrete_saque = tpVF.VFSaque;

                   delete T_con_valefrete vf
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                   
 
                ElsIf  tpVF.VFAcao = 'Cancela' Then
                    update t_con_valefrete vf
                       set vf.con_valefrete_status = 'C'
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;

                   delete t_glb_vfimagem vf
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                    
                   delete t_con_valefreteest VF
                    Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
                      And VF.CON_CONHECIMENTO_SERIE = tpVF.VFSerie
                      And VF.GLB_ROTA_CODIGO = tpVF.VFRota
                      And VF.CON_VALEFRETE_SAQUE = tpVF.VFSaque;
                End If;     
              commit;
             End If;

        Else
          if tpVF.VFAcao = 'Excluir' Then
            P_MESSAGE := P_MESSAGE || '200-Vale de Frete Nao Pode ser Excluido por :' || chr(10) || P_MESSAGE;
          Elsif tpVF.VFAcao = 'Cancela' Then
            P_MESSAGE := P_MESSAGE ||  '200-Vale de Frete Nao Pode ser Cancleado por :' || chr(10) || P_MESSAGE;
          End If;
         End If;
      Elsif tpVF.VFAcao = 'Alterar' Then
         If nvl(trim(P_STATUS),'N') = PKG_GLB_COMMON.Status_Erro Then
            P_MESSAGE := P_MESSAGE ||  '400-Vale de Frete Nao Pode ser Alterado por :' || chr(10) || P_MESSAGE;
         End If;
      Elsif tpVF.VFAcao = 'Inclui' Then
         If nvl(trim(P_STATUS),'N') = PKG_GLB_COMMON.Status_Erro Then
            P_MESSAGE := P_MESSAGE ||  '600-Vale de Frete Nao Pode ser Inserido por :' || chr(10) || P_MESSAGE;
         End If;
      Elsif tpVF.VFAcao = 'Imprimir' Then
         If nvl(trim(P_STATUS),'N') = PKG_GLB_COMMON.Status_Erro Then
            P_MESSAGE := P_MESSAGE ||  '700-Vale de Frete Nao Pode ser Impresso por :' || chr(10) || P_MESSAGE;

         Else

          -- Verificando de encontra a FRETECARMEMO
          Begin
                 Select nvl(vd.FCF_VEICULODISP_VALORFRETE,0),
                        nvl(vd.FCF_VEICULODISP_VALOREXCECAO,0),
                        vd.FCF_VEICULODISP_TPFRETE,
                        nvl(f.fcf_fretecar_valor,0),
                        nvl(f.fcf_fretecar_desinencia,'U'),
                        nvl(vd.fcf_veiculodisp_acrescimo,0)
                Into tpvf.vFCF_VEICULODISP_VALORFRETE,
                     tpvf.vFCF_VEICULODISP_VALOREXCECAO,
                     tpvf.vFCF_VEICULODISP_TPFRETE,
                     tpvf.vFCF_FRETECAR_VALOR,
                     tpvf.vFCF_FRETECAR_DESINENCIA,
                     tpvf.vFCF_FRETECAR_ACRESCIMO
             FROM tdvadm.T_FCF_VEICULODISP VD,
                  tdvadm.T_FCF_FRETECAR F,
                  tdvadm.T_CON_VALEFRETE VF
             WHERE VD.FCF_VEICULODISP_CODIGO = VF.FCF_VEICULODISP_CODIGO
               AND VD.FCF_VEICULODISP_SEQUENCIA = VF.FCF_VEICULODISP_SEQUENCIA
       --            And F.FCF_VEICULODISP_SEQUENCIA = tpvf.vFCF_VEICULODISP_SEQUENCIA
               And Vd.FCF_FRETECAR_ROWID        = F.FCF_FRETECAR_ROWID (+)
 /*              and f.fcf_fretecar_vigencia = (select max(f1.fcf_fretecar_vigencia)
                                              from T_FCF_FRETECAR F1
                                              where f1.fcf_fretecar_origem = f.fcf_fretecar_origem
                                                and f1.fcf_fretecar_destino = f.fcf_fretecar_destino
                                                and f1.fcf_fretecar_tpfrete = f.fcf_fretecar_tpfrete
                                                and f1.FCF_TPVEICULO_CODIGO = f.FCF_TPVEICULO_CODIGO
                                                and f1.FCF_TPCARGA_CODIGO   = f.FCF_TPCARGA_CODIGO)
 */              AND VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
               AND VF.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
               AND VF.GLB_ROTA_CODIGO         = tpVF.VFRota
               AND VF.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;
           exception
             WHEN NO_DATA_FOUND then
               Begin
                 Select nvl(F.FCF_VEICULODISP_VALORFRETE,0),
                        nvl(F.FCF_VEICULODISP_VALOREXCECAO,0),
                        F.FCF_VEICULODISP_TPFRETE,
                        nvl(FC.FCF_FRETECAR_VALOR,0),
                        FC.FCF_FRETECAR_DESINENCIA,
                        nvl(f.fcf_veiculodisp_acrescimo,0)
                    Into tpvf.vFCF_VEICULODISP_VALORFRETE,
                         tpvf.vFCF_VEICULODISP_VALOREXCECAO,
                         tpvf.vFCF_VEICULODISP_TPFRETE,
                         tpvf.vFCF_FRETECAR_VALOR,
                         tpvf.vFCF_FRETECAR_DESINENCIA,
                         tpvf.vFCF_FRETECAR_ACRESCIMO
                 From tdvadm.T_FCF_VEICULODISP F,
                      tdvadm.T_FCF_FRETECAR FC
                 Where 0 = 0
                   And F.FCF_VEICULODISP_CODIGO    = tpvf.vFCF_VEICULODISP_CODIGO
       --            And F.FCF_VEICULODISP_SEQUENCIA = tpvf.vFCF_VEICULODISP_SEQUENCIA
                   And F.FCF_FRETECAR_ROWID        = FC.FCF_FRETECAR_ROWID;
               Exception
                  When NO_DATA_FOUND Then
                    tpvf.vFCF_VEICULODISP_VALORFRETE   := -1;
                    tpvf.vFCF_VEICULODISP_VALOREXCECAO := 0;
                    tpvf.vFCF_VEICULODISP_TPFRETE      := 'N';
                    tpvf.vFCF_FRETECAR_VALOR           := 0;
                    tpvf.vFCF_FRETECAR_DESINENCIA      := 'U';
                    tpvf.vFCF_FRETECAR_ACRESCIMO       := 0;
               End ;
          End;

          If  tpVF.tpValeFrete.CON_CATVALEFRETE_CODIGO in ( '01'--'Uma Viagem
                                                           ,'02'--'Várias Viagens
--                                                         ,'03'--'Tombo
--                                                         ,'04'--'Reforço
--                                                         ,'05'--'Complemento
--                                                         ,'06'--'Transpesa
--                                                         ,'07'--'Remoção
--                                                         ,'08'--'Avulso (Despesa TDV)
                                                           ,'09'--'Avulso com CTRC
--                                                         ,'10'--'Serviço de Terceiro
--                                                         ,'11'--'Manifesto
--                                                         ,'12'--'Avulso Manifesto
--                                                         ,'13'--'Bônus  Manifesto
--                                                         ,'14'--'Bônus CTRC
--                                                         ,'15'--'Operação Coca-Cola
--                                                         ,'16'--'Viagem CTRC s/ Placa
--                                                         ,'17'--'Estadia
--                                                         ,'18'--'Coleta
--                                                         ,'19' --'Operacoes Com CTRC
                                                           ) Then

             select min(vf.con_valefrete_saque)
                into tpvf.vAuxiliarTexto
             from tdvadm.t_con_valefrete vf
             where vf.con_conhecimento_codigo = tpVF.VFNumero
               and vf.con_conhecimento_serie  = tpVF.VFSerie
               and vf.glb_rota_codigo         = tpVF.VFRota
               and vf.con_valefrete_placa     = tpVF.tpValeFrete.CON_VALEFRETE_PLACA
               and nvl(vf.con_valefrete_impresso,'N') = 'S'
               and nvl(vf.con_valefrete_status,'N') = 'N'
               and vf.con_catvalefrete_codigo in ('01','02','09');

             
             If tpvf.vAuxiliarTexto = tpVF.VFSaque Then
  
                tpVF.vAuxiliarTexto := chr(10) ||
                                       'CRITICA DA FRETECARMEMO ' || chr(10) ||
                                       'VF ' || tpVF.VFNumero || '-' || tpVF.VFSerie || '-' || tpVF.VFRota || '-' || tpVF.VFSaque || chr(10) ||
                                       'Categoria ' || tpVF.tpValeFrete.CON_CATVALEFRETE_CODIGO || chr(10) ||
                                       'Fifo      ' || tpVF.vCriadoPeloFIFO || chr(10) ||
                                       'PLACA     ' || tpVF.tpValeFrete.CON_VALEFRETE_PLACA || '-' || tpVF.tpValeFrete.CON_VALEFRETE_PLACASAQUE || chr(10) ||
                                       'VDISP     ' || tpvf.vFCF_VEICULODISP_CODIGO || '-' || tpvf.vFCF_VEICULODISP_SEQUENCIA || chr(10) ||
                                       'Sem FRETECARMEMO. VERIFICAR !!!' || chr(10) || 
                                       'Procure Thiago na TI' || chr(10);
                Select count(*)
                  into tpVF.vAuxiliar
                From tdvadm.t_fcf_fretecarmemo m
                Where m.fcf_veiculodisp_codigo = tpvf.vFCF_VEICULODISP_CODIGO
      --            and m.fcf_veiculodisp_sequencia = tpvf.vFCF_VEICULODISP_SEQUENCIA
                  and m.fcf_solveic_cod is not null
                  and m.fcf_fretecar_rowid is not null;
                If ( nvl(plistaparams('TRAVAFRETECARMEMO').texto,'S') = 'S' ) Then
                   If tpVF.vAuxiliar = 0 Then
                         P_STATUS := 'E';
                         P_MESSAGE := P_MESSAGE || tpVF.vAuxiliarTexto ;
                         wservice.pkg_glb_email.SP_ENVIAEMAIL(P_ASSUNTO => 'PROBLEMAS FRETECARMEMO - PARAMETRO HABILITADO Qtde - ' || tpVF.vAuxiliar,
                                                              P_TEXTO   => P_MESSAGE,
                                                              P_ORIGEM  => 'aut-e@dellavolpe.com.br',
                                                              P_DESTINO => 'thiago.soares@dellavolpe.com.br;sirlano.drumond@dellavolpe.com.br',
                                                              P_COPIA   => null,
                                                              P_COPIA2  => null);
                   ElsIf tpVF.vAuxiliar > 1 Then
                         P_STATUS := 'E';
                         P_MESSAGE := P_MESSAGE || tpVF.vAuxiliarTexto ;
                         wservice.pkg_glb_email.SP_ENVIAEMAIL(P_ASSUNTO => 'PROBLEMAS FRETECARMEMO - PARAMETRO HABILITADO Qtde - ' || tpVF.vAuxiliar,
                                                              P_TEXTO   => P_MESSAGE,
                                                              P_ORIGEM  => 'aut-e@dellavolpe.com.br',
                                                              P_DESTINO => 'thiago.soares@dellavolpe.com.br;sirlano.drumond@dellavolpe.com.br',
                                                              P_COPIA   => null,
                                                              P_COPIA2  => null);
                   End If;
                Else
                   If tpVF.vAuxiliar = 0 Then
                         P_MESSAGE := P_MESSAGE || tpVF.vAuxiliarTexto ;
                         wservice.pkg_glb_email.SP_ENVIAEMAIL(P_ASSUNTO => 'PROBLEMAS FRETECARMEMO - PARAMETRO DESABILITADO Qtde - ' || tpVF.vAuxiliar,
                                                              P_TEXTO   => P_MESSAGE,
                                                              P_ORIGEM  => 'aut-e@dellavolpe.com.br',
                                                              P_DESTINO => 'thiago.soares@dellavolpe.com.br;sirlano.drumond@dellavolpe.com.br',
                                                              P_COPIA   => null,
                                                              P_COPIA2  => null);
                   ElsIf tpVF.vAuxiliar > 1 Then
                         P_MESSAGE := P_MESSAGE || tpVF.vAuxiliarTexto ;
                         wservice.pkg_glb_email.SP_ENVIAEMAIL(P_ASSUNTO => 'PROBLEMAS FRETECARMEMO - PARAMETRO DESABILITADO Qtde - ' || tpVF.vAuxiliar,
                                                              P_TEXTO   => P_MESSAGE,
                                                              P_ORIGEM  => 'aut-e@dellavolpe.com.br',
                                                              P_DESTINO => 'thiago.soares@dellavolpe.com.br;sirlano.drumond@dellavolpe.com.br',
                                                              P_COPIA   => null,
                                                              P_COPIA2  => null);
                   End If;
                End If;
             End If;
       End If;








           Begin

               SELECT M.GLB_BENASSEMSG_DESCCLI,
                      M.GLB_BENASSEMSG_CORCODIGO,
                      M.GLB_BENASSEMSG_CORCODIGOFONTE
                  INTO tpVF.VSTATUS,
                       tpVF.VCOR,
                       tpVF.VCORFONTE
               FROM RMADM.T_GLB_BENASSEMSG M
               WHERE M.GLB_BENASSEMSG_CODIGO = 1
                 AND M.GLB_BENASSEMSG_ORIGEM = 'CT';

                Select s.glb_grupoeconomico_codigo,
                       r.glb_grupoeconomico_codigo,
                       d.glb_grupoeconomico_codigo,
                       s.glb_cliente_cgccpfcodigo,
                       r.glb_cliente_cgccpfcodigo,
                       d.glb_cliente_cgccpfcodigo
                  Into tpVF.v_gruposac,
                       tpVF.v_gruporem,
                       tpVF.v_grupodes,
                       tpVF.v_cnpjcpfsac,
                       tpVF.v_cnpjcpfrem,
                       tpVF.v_cnpjcpfdes
                From t_con_conhecimento c,
                     t_con_vfreteconhec vfc,
                     t_glb_cliente r,
                     t_glb_cliente d,
                     t_glb_cliente s
                Where c.con_conhecimento_codigo    = vfc.con_conhecimento_codigo
                  And c.con_conhecimento_serie     = vfc.con_conhecimento_serie
                  And c.glb_rota_codigo            = vfc.glb_rota_codigo
                  And vfc.con_valefrete_codigo     = tpVF.tpValeFrete.Con_Conhecimento_Codigo
                  And vfc.con_valefrete_serie      = tpVF.tpValeFrete.Con_Conhecimento_Serie
                  And vfc.glb_rota_codigovalefrete = tpVF.tpValeFrete.Glb_Rota_Codigo
                  And vfc.con_valefrete_saque      = tpVF.tpValeFrete.Con_Valefrete_Saque
                  And c.glb_cliente_cgccpfremetente    = r.glb_cliente_cgccpfcodigo (+)
                  And c.glb_cliente_cgccpfdestinatario = d.glb_cliente_cgccpfcodigo (+)
                  And c.glb_cliente_cgccpfsacado       = s.glb_cliente_cgccpfcodigo (+)
                  And rownum = 1;

                Begin
                  UPDATE T_ATR_ULTPOSICAO UP
                    SET UP.CON_CONHECIMENTO_CODIGO = tpVF.tpValeFrete.Con_Conhecimento_Codigo,
                        UP.CON_CONHECIMENTO_SERIE = tpVF.tpValeFrete.Con_Conhecimento_Serie,
                        UP.GLB_ROTA_CODIGO = tpVF.tpValeFrete.GLB_ROTA_CODIGO,
                        UP.CON_VALEFRETE_SAQUE = tpVF.tpValeFrete.con_valefrete_SAQUE,
                        UP.GLB_CLIENTE_CGCCPFCODIGOSAC = tpVF.v_cnpjcpfsac,
                        UP.GLB_CLIENTE_CGCCPFCODIGOREM = tpVF.v_cnpjcpfrem,
                        UP.GLB_CLIENTE_CGCCPFCODIGODES = tpVF.v_cnpjcpfdes,
                        up.glb_grupoeconomico_codigos = tpVF.v_gruposac,
                        up.glb_grupoeconomico_codigor = tpVF.v_gruporem,
                        up.glb_grupoeconomico_codigod = tpVF.v_grupodes,
                        UP.ATR_ULTPOSICAO_STATUS = tpVF.VSTATUS,
                        UP.ATR_ULTPOSICAO_CORCODIGO =  tpVF.VCOR,
                        UP.ATR_ULTPOSICAO_CORCODIGOFONTE = tpVF.VCORFONTE
                  WHERE UP.ATR_ULTPOSICAO_MCT = fn_getantena(tpVF.tpValeFrete.Con_Valefrete_Placa);
 --                 vqtde := Sql%Rowcount;
                EXCEPTION
                  WHEN OTHERS THEN
                     tpVF.v_cnpjcpfsac := tpVF.v_cnpjcpfsac;
                END;
             Exception
               When NO_DATA_FOUND Then
                     tpVF.v_cnpjcpfsac := tpVF.v_cnpjcpfsac;

             End ;

            tpVF.tpValeFrete.Con_Valefrete_Pedagio := nvl(tpVF.tpValeFrete.Con_Valefrete_Pedagio,0);


            If ( tpVF.tpValeFrete.Con_Catvalefrete_Codigo = CatTServicoTerceiro ) and
               ( substr(tpVF.tpValeFrete.Con_Valefrete_Placa,2,2) <> '00' ) and 
               ( nvl(tpVF.tpValeFrete.con_valefrete_impresso,'A') = 'A' ) Then


             sp_con_InsereVFTContaCorrente(tpVF.tpValeFrete.Con_Conhecimento_Codigo,
                                           tpVF.tpValeFrete.Con_Conhecimento_serie,
                                           tpVF.tpValeFrete.Glb_Rota_codigo,
                                           tpVF.tpValeFrete.Con_Valefrete_saque,
                                           tpVF.VFusuarioTDV,
                                           tpVF.VFRotaUsuarioTDV,
                                           P_STATUS,
                                           P_MESSAGE);
 /*
             -- inclusao do Vale frete de Terceiro

              If upper(tpVF.tpValeFrete.Con_Valefrete_Tipocusto) = 'T' Then
                  vValorDeb := ( ( ( tpVF.tpValeFrete.Con_Valefrete_Custocarreteiro  * tpVF.tpValeFrete.Con_Valefrete_Pesocobrado) - tpVF.tpValeFrete.Con_Valefrete_Pedagio ) * 0.08);
              Else
                  vValorDeb := (( tpVF.tpValeFrete.Con_Valefrete_Custocarreteiro - tpVF.tpValeFrete.Con_Valefrete_Pedagio ) * 0.08 );
              End if;

              Select v.car_proprietario_cgccpfcodigo,
                     ca.car_carreteiro_saque
                  Into vProprietario,
                       vCarreteiroSq
              From t_car_veiculo v,
                   t_car_carreteiro ca
              Where v.car_veiculo_placa = tpVF.tpValeFrete.Con_Valefrete_Placa
                 And v.car_veiculo_saque = tpVF.tpValeFrete.Con_Valefrete_Placasaque
                 And v.car_veiculo_placa = ca.car_veiculo_placa
                 And v.car_veiculo_saque = ca.car_veiculo_saque
                 And ca.car_carreteiro_cpfcodigo = tpVF.tpValeFrete.Con_Valefrete_Carreteiro
                 And ca.car_carreteiro_saque = (Select Max(ca1.car_carreteiro_saque)
                                                From t_car_carreteiro ca1
                                                Where ca1.car_carreteiro_cpfcodigo = ca.car_carreteiro_cpfcodigo
                                                  And ca1.car_veiculo_placa = ca.car_veiculo_placa
                                                  And ca1.car_veiculo_saque = ca.car_veiculo_saque);




                   vXmlDeb :=         '<Parametros> ';
                   vXmlDeb := vXmlDeb || '   <Input>';
                   vXmlDeb := vXmlDeb || '     <pProprietario>' || vProprietario || '</pProprietario> ';
                   vXmlDeb := vXmlDeb || '     <pVeiculo>' || tpVF.tpValeFrete.Con_Valefrete_Placa  || '</pVeiculo>';
                   vXmlDeb := vXmlDeb || '     <pVeiculoSq>' || tpVF.tpValeFrete.Con_Valefrete_PlacaSaque  || '</pVeiculoSq>';
                   vXmlDeb := vXmlDeb || '     <pMotorista>' || tpVF.tpValeFrete.Con_Valefrete_Carreteiro || '</pMotorista>';
                   vXmlDeb := vXmlDeb || '     <pMotoristaSq>' || vCarreteiroSq || '</pMotoristaSq>';
                   vXmlDeb := vXmlDeb || '     <pRotaUsuario>' || nvl(tpVF.VFRotaUsuarioTDV,'010') || '</pRotaUsuario>';
                   vXmlDeb := vXmlDeb || '     <pUsuario>' || tpVF.VFusuarioTDV || '</pUsuario>';
                   vXmlDeb := vXmlDeb || '     <pAplicacao>comvlfrete</pAplicacao>';
                   vXmlDeb := vXmlDeb || '     <pDocumento>'|| tpVF.tpValeFrete.Con_Conhecimento_Codigo  || tpVF.tpValeFrete.Glb_Rota_Codigo || tpVF.tpValeFrete.Con_Valefrete_Saque  ||'</pDocumento>';
                   vXmlDeb := vXmlDeb || '     <pValorDebitar>' || trim(to_char(vValorDeb)) || '</pValorDebitar>';
                   vXmlDeb := vXmlDeb || '     <pVencimento></pVencimento>';
                   vXmlDeb := vXmlDeb || '     <pTpLancamento>VFT</pTpLancamento>';
                   vXmlDeb := vXmlDeb || '     <pOBS>Lancamento Automatico VFT</pOBS>';
                  vXmlDeb := vXmlDeb || '     <pHistoricoLancamento>' || tpVF.tpValeFrete.Con_Conhecimento_Codigo || tpVF.tpValeFrete.Con_Conhecimento_Serie || tpVF.tpValeFrete.Glb_Rota_Codigo || tpVF.tpValeFrete.Con_Valefrete_Saque || '</pHistoricoLancamento>';
                   vXmlDeb := vXmlDeb || '     <pVersao>12.7.27.3</pVersao>';
                   vXmlDeb := vXmlDeb || '   </Input>';
                   vXmlDeb := vXmlDeb || '</Parametros>';

                   pkg_car_proprietario.Sp_DebitaContaCorrente(vXmlDeb,P_STATUS,P_MESSAGE);
                   commit;
                Else
                  -- Vale de frete de Terceiro com Frota
                  -- Colocar aqui a geração do Titulo
                  vXmlDeb := vXmlDeb;
 */
                End If;
         End If;

         Update t_con_conhecimento cc
           Set cc.con_conhecimento_placa = tpVF.tpValeFrete.Con_Valefrete_Placa
         Where cc.con_conhecimento_codigo ||
               cc.con_conhecimento_serie ||
               cc.glb_rota_codigo In (Select vfc.con_conhecimento_codigo || vfc.con_conhecimento_serie || vfc.glb_rota_codigo
                                      From t_con_vfreteconhec vfc
                                      Where vfc.con_valefrete_codigo     = tpVF.tpValeFrete.Con_Conhecimento_Codigo
                                        And vfc.con_valefrete_serie      = tpVF.tpValeFrete.Con_Conhecimento_Serie
                                        And vfc.glb_rota_codigovalefrete = tpVF.tpValeFrete.Glb_Rota_Codigo
                                        And vfc.con_valefrete_saque      = tpVF.tpValeFrete.Con_Valefrete_Saque)
           And cc.con_conhecimento_placa Is Null;

      End If;
      If nvl(trim(P_STATUS),'N') = PKG_GLB_COMMON.Status_Nomal Then

         If nvl(INSTR(upper(tpVF.tpValeFrete.Con_Valefrete_Obs),'VERSAO'),0) = 0 Then
            tpVF.vAuxiliar := to_number(substr(fn_ListaEntregas(tpVF.VFNumero,tpVF.VFSerie,tpVF.VFRota,tpVF.VFSaque),1,2));
            Update t_con_valefrete vf
            Set vf.con_valefrete_obs = SUBSTR(TRIM(vf.con_valefrete_obs) || ' ' || Trim(tpVF.tpValeFrete.Cax_Boletim_Data) || 'Versao',0,700),
                vf.con_valefrete_entregas = tpVF.vAuxiliar
            Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
              And VF.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
              And VF.GLB_ROTA_CODIGO         = tpVF.VFRota
              And VF.CON_VALEFRETE_SAQUE     = tpVF.VFSaque;
            Commit;
         End If;
         If tpVF.vFCF_VEICULODISP_CODIGO Is Not Null Then
            Update tdvadm.t_con_valefrete vf
               Set vf.fcf_veiculodisp_codigo    = tpVF.vFCF_VEICULODISP_CODIGO,
                   vf.fcf_veiculodisp_sequencia = tpVf.vFCF_VEICULODISP_SEQUENCIA,
                   vf.fcf_fretecar_rowid        = (select vd.fcf_fretecar_rowid
                                                   from t_fcf_veiculodisp vd
                                                   where vd.fcf_veiculodisp_codigo = tpVF.vFCF_VEICULODISP_CODIGO
                                                     and vd.fcf_veiculodisp_sequencia = tpVf.vFCF_VEICULODISP_SEQUENCIA)
            Where VF.CON_CONHECIMENTO_CODIGO = tpVF.VFNumero
              And VF.CON_CONHECIMENTO_SERIE  = tpVF.VFSerie
              And VF.GLB_ROTA_CODIGO         = tpVF.VFRota
              And VF.CON_VALEFRETE_SAQUE     = tpVF.VFSaque
              and nvl(vf.con_valefrete_impresso,'N') <> 'I';
            Commit;
          End If;
 --        VFCON_VALEFRETE_MULTA := 0;


     End If;

 /*    if tpVF.VFusuarioTDV = 'jalencar' Then
              P_MESSAGE := P_MESSAGE || 'Usuario       ' || tpVF.VFusuarioTDV || chr(10);
              P_MESSAGE := P_MESSAGE || 'Rota Usuario  ' || tpVF.VFRotaUsuarioTDV || chr(10);
              P_MESSAGE := P_MESSAGE || 'Categoria VF  ' || tpVf.VFCON_CATVALEFRETE_CODIGO || chr(10);
              P_MESSAGE := P_MESSAGE || 'Rota Travada  ' || tpVf.vFCF_VEICULODISP_ROTATRAVAS || chr(10);
              P_MESSAGE := P_MESSAGE || 'Altera frete  ' || tpVf.vFCF_VEICULODISP_ALTERAFRETE || chr(10);
              P_MESSAGE := P_MESSAGE || 'SubCategoria  ' || tpVF.vExisteSubCategoria || chr(10);
              P_MESSAGE := P_MESSAGE || 'Primeiro Sq   ' || tpVF.vPrimeiroSaque || chr(10);
              P_MESSAGE := P_MESSAGE || 'Saque Atual   ' || tpvf.VFSaque || chr(10);
              P_MESSAGE := P_MESSAGE || 'Custo Carr    ' || to_char(tpVF.vCON_VALEFRETE_CUSTOCARRETEIRO,'99999999.99') || chr(10);
              P_MESSAGE := P_MESSAGE || 'Frete Mesa    ' || to_char(tpvf.vFCF_VEICULODISP_VALORFRETE,'99999999.99') || chr(10);
              P_MESSAGE := P_MESSAGE || 'Excecao Mesa  ' || to_char(tpvf.vFCF_VEICULODISP_VALOREXCECAO,'99999999.99') || chr(10);
              P_MESSAGE := P_MESSAGE || 'TipoCustoVF   ' || tpvf.vCON_VALEFRETE_TIPOCUSTO || chr(10);
              P_MESSAGE := P_MESSAGE || 'TipoCustoMesa ' || tpvf.vFCF_FRETECAR_DESINENCIA || chr(10);
              P_MESSAGE := P_MESSAGE || '**********************************' || chr(10) ;
     end if;
 */

    if nvl(trim(P_STATUS),'N') = pkg_glb_common.Status_Nomal Then
       if fn_DiarioBordoEmitido(tpVF.VFNumero,tpvf.VFSerie,tpVf.VFRota,tpvf.VFSaque) = 'N' Then
          P_MESSAGE := P_MESSAGE || chr(10) || 'IMPRESSAO DO DIARIO DE BORDO E OBRIGATORIO PARA ESTA VIAGEM' || CHR(10);
       End If;
       if tpvf.tpValeFrete.GLB_CLIENTE_CGCCPFCODIGO is not null Then
          begin
              select cl.glb_cliente_razaosocial
                into tpVf.vServTercPagador
              from t_glb_cliente cl
              where cl.glb_cliente_cgccpfcodigo = tpvf.tpValeFrete.GLB_CLIENTE_CGCCPFCODIGO;
          exception
            When NO_DATA_FOUND Then
                tpVf.vServTercPagador := '';
            When OTHERS Then
                tpVf.vServTercPagador := 'Erro...';
          End;
       End If;

    End If;

    tpVF.vAuxiliar := 0;
    vXmlImagem := '';
    TPVF.vAuxiliarTexto := nvl(trim(P_STATUS),'N');
     Begin
       if ( tpVF.VFAcao = 'Imprimir') and
          ( TRIM(nvl(trim(P_STATUS),'N')) =  TRIM(pkg_glb_common.Status_Nomal) ) Then
           if tpVf.vImprimePCL = 'S' Then

              Begin
                 tpVF.vAuxiliarTexto := '1';
                 select trim(P.GLB_PCL_CODIGO),
                        trim(P.GLB_PCL_VERSAO)
                    into vPclCodigo,
                         vPclVersao
                 from T_GLB_PCL P
                 WHERE P.GLB_PCL_CODIGO = 'VALEFRETE'
                   AND P.GLB_PCL_ATIVO = 'S'
                   AND P.GLB_PCL_CRIACAO = (SELECT MAX(P1.GLB_PCL_CRIACAO)
                                            FROM T_GLB_PCL P1
                                            WHERE P1.GLB_PCL_CODIGO = P.GLB_PCL_CODIGO
                                              AND P1.GLB_PCL_ATIVO = 'S');
               exception
                 WHEN OTHERS Then
                     P_MESSAGE := P_MESSAGE || chr(10) || 'Erro buscando Versao da Mascara PCL (SELECT)';
                     P_STATUS := pkg_glb_common.Status_Erro;
               End;

               vXmlin := '';
               vXmlin := vXmlin || '<Parametros> ';
               vXmlin := vXmlin || '   <Input> ';
               vXmlin := vXmlin || '      <PCL>' || vPclCodigo || '</PCL> ';
               vXmlin := vXmlin || '      <PCLVersao>' || vPclVersao || '</PCLVersao> ';
               vXmlin := vXmlin || '      <Codigo>' || tpVF.VFNumero || '</Codigo> ';
               vXmlin := vXmlin || '      <Serie>' || tpVF.VFSerie || '</Serie> ';
               vXmlin := vXmlin || '      <Rota>' || tpVF.VFRota || '</Rota> ';
               vXmlin := vXmlin || '      <Saque>' || tpVF.VFSaque  || '</Saque> ';
               vXmlin := vXmlin || '      <Ciclo></Ciclo> ';
               vXmlin := vXmlin || '      <DiarioBordo>' || 'S' || '</DiarioBordo> ';
               vXmlin := vXmlin || '      <UsuarioTDV>' || tpVF.VFusuarioTDV || '</UsuarioTDV> ';
               vXmlin := vXmlin || '      <RotaUsuarioTDV>' || tpVF.VFRotaUsuarioTDV || '</RotaUsuarioTDV> ';
               vXmlin := vXmlin || '      <Aplicacao>comvlfrete</Aplicacao> ';
               vXmlin := vXmlin || '      <VersaoAplicao>' || tpVF.VFVersaoAplicao || '</VersaoAplicao> ';
               vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
               vXmlin := vXmlin || '   </Input> ';
               vXmlin := vXmlin || '</Parametros> ';

               vOnde := 'Apos XML';
               vXmlOutT := empty_clob();
               tpVF.vAuxiliarTexto := '2';
               pkg_glb_pcl.SP_GLB_RETORNAPCL( vXmlin,vXmlOutt,vXmlOutb,vStatus,vMessage);
               vOnde := 'Apos Procedure';
               tpvf.vAuxiliar := glbadm.seq_int_monitorimp.nextval;

               insert into glbadm.T_INT_MONITORIMP
               VALUES
               (tpvf.vAuxiliar, -- sequencia
                'comvlfrete', -- aplicacao
                'valefrete', -- relatorio
                tpVF.VFusuarioTDV, -- usuario
                '00001', -- impressora
                'Vale Frete '|| tpVF.VFNumero||'-'||tpVF.VFSerie||'-'||tpVF.VFRota||'-'||tpVF.VFSaque, -- Documento
                'N', -- impresso
                null, --data impressao
                sysdate, -- gravacao
                0, -- tentativas
                'Aguardando', --Status
                3, -- prioridade
                vXmlOutt, -- texto
                vXmlOutb); -- Binario
                vOnde := 'Apos Insert';
            tpVF.vAuxiliarTexto := '3';
            if PKG_CON_VALEFRETE.fn_DiarioBordoEmitido(tpVF.VFNumero,
                                                       tpVF.VFSerie,
                                                       tpVF.VFRota,
                                                       tpVF.VFSaque) = 'N' and
               tpVF.VFRota not in ('161','237','230','021')      Then
 --           if tpVF.VFNumero = '572795' Then
              Begin
                 tpVF.vAuxiliarTexto := '4';
                 select trim(P.GLB_PCL_CODIGO),
                        trim(P.GLB_PCL_VERSAO)
                    into vPclCodigo,
                         vPclVersao
                 from T_GLB_PCL P
                 WHERE P.GLB_PCL_CODIGO = 'DIARIOBORD'
                   AND P.GLB_PCL_ATIVO = 'S'
                   AND P.GLB_PCL_CRIACAO = (SELECT MAX(P1.GLB_PCL_CRIACAO)
                                            FROM T_GLB_PCL P1
                                            WHERE P1.GLB_PCL_CODIGO = P.GLB_PCL_CODIGO
                                              AND P1.GLB_PCL_ATIVO = 'S');
               exception
                 WHEN OTHERS Then
                     P_MESSAGE := P_MESSAGE || chr(10) || 'Erro buscando Versao da Mascara PCL (SELECT)';
                     P_STATUS := pkg_glb_common.Status_Erro;
               End;

               vXmlin := '';
               vXmlin := vXmlin || '<Parametros> ';
               vXmlin := vXmlin || '   <Input> ';
               vXmlin := vXmlin || '      <PCL>' || vPclCodigo || '</PCL> ';
               vXmlin := vXmlin || '      <PCLVersao>' || vPclVersao || '</PCLVersao> ';
               vXmlin := vXmlin || '      <Codigo>' || tpVF.VFNumero || '</Codigo> ';
               vXmlin := vXmlin || '      <Serie>' || tpVF.VFSerie || '</Serie> ';
               vXmlin := vXmlin || '      <Rota>' || tpVF.VFRota || '</Rota> ';
               vXmlin := vXmlin || '      <Saque>' || tpVF.VFSaque  || '</Saque> ';
               vXmlin := vXmlin || '      <Ciclo></Ciclo> ';
               vXmlin := vXmlin || '      <DiarioBordo>' || 'S' || '</DiarioBordo> ';
               vXmlin := vXmlin || '      <UsuarioTDV>' || tpVF.VFusuarioTDV || '</UsuarioTDV> ';
               vXmlin := vXmlin || '      <RotaUsuarioTDV>' || tpVF.VFRotaUsuarioTDV || '</RotaUsuarioTDV> ';
               vXmlin := vXmlin || '      <Aplicacao>comvlfrete</Aplicacao> ';
               vXmlin := vXmlin || '      <VersaoAplicao>' || tpVF.VFVersaoAplicao || '</VersaoAplicao> ';
               vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
               vXmlin := vXmlin || '   </Input> ';
               vXmlin := vXmlin || '</Parametros> ';

               vOnde := 'Apos XML';
               vXmlOutT := empty_clob();
               tpVF.vAuxiliarTexto := '5';
               pkg_glb_pcl.SP_GLB_RETORNAPCL( vXmlin,vXmlOutt,vXmlOutb,vStatus,vMessage);
               vOnde := 'Apos Procedure';

               if vStatus <> pkg_glb_common.Status_Nomal Then
                  P_MESSAGE := P_MESSAGE || vMessage ||  chr(10);
                  P_STATUS := pkg_glb_common.Status_Erro;

               End If;

               update glbadm.T_INT_MONITORIMP mm
                 set mm.int_monitorimp_dados =  mm.int_monitorimp_dados || vXmlOutt
               where mm.int_monitorimp_sequencia = tpvf.vAuxiliar;
               if Sql%rowcount = 0 Then
                  P_MESSAGE := P_MESSAGE || chr(10) || 'Erro buscando Mascara PCL (UPDATE)' || chr(10);
                  P_STATUS := pkg_glb_common.Status_Erro;
               End If;
            end If;


             vCodEstadia     := PKG_CON_VALEFRETE.fn_PegaCodEstadia(tpVF.VFNumero,tpVF.VFSerie,tpVF.VFRota,tpVF.VFSaque,plistaparams('MSG_ESTADIAC').Texto,plistaparams('MSG_ESTADIAG').Texto);
             vOBSEstadia     := plistaparams('MSG_ESTADIA' || vCodEstadia).Texto;


             update t_con_valefrete vf
               set vf.con_valefrete_obs =  tpVF.vCIOT || '-' || vOBSEstadia || '-' || tpVF.VFVersaoAplicao
             where vf.con_conhecimento_codigo = tpVF.VFNumero
               and vf.con_conhecimento_serie = tpVF.VFSerie
               and vf.glb_rota_codigo = tpVF.VFRota
               and vf.con_valefrete_saque = tpVF.VFSaque;



            commit;

              if ( plistaparams('PODE_REIMPRIMIR').texto <> 'N' ) and -- ele pode ser S ou PROPRIO
                 ( tpVF.tpValeFrete.con_valefrete_impresso = 'S' ) Then
                 insert into t_con_valefretereimp ri
                   (CON_CONHECIMENTO_CODIGO,
                    CON_CONHECIMENTO_SERIE,
                    GLB_ROTA_CODIGO,
                    CON_VALEFRETE_SAQUE,
                    CON_VALEFRETEREIMP_DTGRAVACAO,
                    USU_USUARIO_CODIGO,
                    CON_VALEFRETEREIMP_MAQUINA)
                 Values
                   (tpVF.VFNumero,
                    tpVF.VFSerie,
                    tpVF.VFRota,
                    tpVF.VFSaque,
                    sysdate,
                    tpVF.VFusuarioTDV,
                    tpVF.vMaquina);
              End If;


          End If;

 --          P_MESSAGE := P_MESSAGE || chr(10) || vMessage;
           if nvl(trim(P_STATUS),'N') <> pkg_glb_common.Status_Erro Then
              P_STATUS := vStatus;
           else
              P_MESSAGE := P_MESSAGE || chr(10) || vMessage;
           End If;

        End If;

   exception
      When NO_DATA_FOUND Then
          P_MESSAGE := P_MESSAGE || chr(10) || 'Versao da Mascara PCL não encontrada ' || vPclVersao || '-' || tpVF.vAuxiliarTexto;
          P_STATUS := pkg_glb_common.Status_Erro;
      When OTHERS Then
          P_MESSAGE := P_MESSAGE || chr(10) || 'Erro ao pegar Versao da Mascara PCL ' || vOnde || '- erro' ||  sqlerrm || chr(10) || dbms_utility.format_error_backtrace;
 --         P_STATUS := pkg_glb_common.Status_Erro;
      End ;
      
      vXmlEntrega := empty_clob;
      tpVF.vAuxiliar := 0;
      FOR R_CURSOR in (select *
                       from tdvadm.t_con_vfreteentrega ve
                       where ve.con_conhecimento_codigo = tpVF.VFNumero
                         and ve.con_conhecimento_serie  = tpVF.VFSerie
                         and ve.glb_rota_codigo         = tpVF.VFRota
                         and ve.con_valefrete_saque     = tpVF.VFSaque
                         and ve.con_vfreteentrega_seq = (select max(ve1.con_vfreteentrega_seq)
                                                         from tdvadm.t_con_vfreteentrega ve1
                                                         where ve1.con_conhecimento_codigo = ve.con_conhecimento_codigo
                                                           and ve1.con_conhecimento_serie = ve.con_conhecimento_serie
                                                           and ve1.glb_rota_codigo = ve.glb_rota_codigo
                                                           and ve1.con_valefrete_saque = ve.con_valefrete_saque
                                                           and ve1.con_vfreteentrega_codcli = ve.con_vfreteentrega_codcli)
                       order by ve.con_vfreteentrega_codcli,ve.con_vfreteentrega_dtentrega  )
      Loop

          tpVF.vAuxiliar := tpVF.vAuxiliar + 1;
          vXmlEntrega := vXmlEntrega || '<row num=#'   || to_char(tpVF.vAuxiliar)                                             ||  '#>';
          vXmlEntrega := vXmlEntrega || '<vfrete>'     || R_CURSOR.con_conhecimento_codigo                                    || '</vfrete>';
          vXmlEntrega := vXmlEntrega || '<serie>'      || R_CURSOR.con_conhecimento_serie                                     || '</serie>';
          vXmlEntrega := vXmlEntrega || '<rota>'       || R_CURSOR.glb_rota_codigo                                            || '</rota>';
          vXmlEntrega := vXmlEntrega || '<Saque>'      || R_CURSOR.con_valefrete_saque                                        || '</Saque>';
          vXmlEntrega := vXmlEntrega || '<Codcli>'     || R_CURSOR.con_vfreteentrega_codcli                                   || '</Codcli>';
          vXmlEntrega := vXmlEntrega || '<Sequencia>'  || R_CURSOR.con_vfreteentrega_seq                                      || '</Sequencia>';
          vXmlEntrega := vXmlEntrega || '<DtEntrega>'  || rpad(to_char(R_CURSOR.con_vfreteentrega_dtentrega ,'dd/mm/yyyy hh24:mi'),20) || '</DtEntrega>';
          vXmlEntrega := vXmlEntrega || '<HrEntrega>'  || R_CURSOR.con_vfreteentrega_horaentrega || '</HrEntrega>';
          vXmlEntrega := vXmlEntrega || '<CodEntrega>' || rpad(R_CURSOR.con_vfreteentrega_codigo,50)                          || '</CodEntrega>';
          vXmlEntrega := vXmlEntrega || '<UsuCriou>'   || rpad(R_CURSOR.usu_usuario_codigo,10)                                         || '</UsuCriou>';
          vXmlEntrega := vXmlEntrega || '<Conf>'       || rpad(to_char(R_CURSOR.con_vfreteentrega_confirmado ,'dd/mm/yyyy hh24:mi'),20)|| '</Conf>';
          vXmlEntrega := vXmlEntrega || '<Obs>'        || rpad(R_CURSOR.con_vfreteentregaobservacao,100)                      || '</Obs>';
          vXmlEntrega := vXmlEntrega || '</row>';
        
      End Loop;
      
      If tpVF.vAuxiliar = 0 Then
        
          vXmlEntrega := vXmlEntrega || '<row num=#1#>';
          vXmlEntrega := vXmlEntrega || '<vfrete></vfrete>';
          vXmlEntrega := vXmlEntrega || '<serie></serie>';
          vXmlEntrega := vXmlEntrega || '<rota></rota>';
          vXmlEntrega := vXmlEntrega || '<Saque></Saque>';
          vXmlEntrega := vXmlEntrega || '<Codcli></Codcli>';
          vXmlEntrega := vXmlEntrega || '<Sequencia></Sequencia>';
          vXmlEntrega := vXmlEntrega || '<DtEntrega></DtEntrega>';
          vXmlEntrega := vXmlEntrega || '<HrEntrega></HrEntrega>';
          vXmlEntrega := vXmlEntrega || '<CodEntrega></CodEntrega>';
          vXmlEntrega := vXmlEntrega || '<UsuCriou></UsuCriou>';
          vXmlEntrega := vXmlEntrega || '<Conf></Conf>';
          vXmlEntrega := vXmlEntrega || '<Obs></Obs>';
          vXmlEntrega := vXmlEntrega || '</row>';

      End IF;

       vXmlEntrega := '<table name=#Entrega#><rowset>'|| vXmlEntrega || '</rowset></table>';

       vXmlEntrega := Replace( vXmlEntrega, '#', '''' );


      vXmlEntregaDet := empty_clob;
      tpVF.vAuxiliar := 0;
      FOR R_CURSOR in (select *
                       from tdvadm.v_con_vfreteentrega ve
                       where ve.vf  = tpVF.VFNumero
                         and ve.sr = tpVF.VFSerie
                         and ve.rt = tpVF.VFRota
                         and ve.sq = tpVF.VFSaque
                        order by ve.ENTREGA,ve.TRANSF,ve.CHAVECTE)
      Loop

          tpVF.vAuxiliar := tpVF.vAuxiliar + 1;
          vXmlEntregaDet := vXmlEntregaDet || '<row num=#'      || to_char(tpVF.vAuxiliar)                            ||  '#>';
          vXmlEntregaDet := vXmlEntregaDet || '<NOTAINC>'       || to_char(R_CURSOR.NOTAINC ,'dd/mm/yyyy hh24:mi')    || '</NOTAINC>';
          vXmlEntregaDet := vXmlEntregaDet || '<DESTINATARIO>'  || R_CURSOR.DESTINATARIO                              || '</DESTINATARIO>';
          vXmlEntregaDet := vXmlEntregaDet || '<ENTREGA>'       || R_CURSOR.ENTREGA                                   || '</ENTREGA>';
          vXmlEntregaDet := vXmlEntregaDet || '<DTAGENDADA>'    || R_CURSOR.DTAGENDADA                                ||  '</DTAGENDADA>';
          vXmlEntregaDet := vXmlEntregaDet || '<TRANSF>'        || R_CURSOR.TRANSF                                    || '</TRANSF>';
          vXmlEntregaDet := vXmlEntregaDet || '<ARMAZEMTRANSF>' || R_CURSOR.ARMAZEMTRANSF                             || '</ARMAZEMTRANSF>';
          vXmlEntregaDet := vXmlEntregaDet || '<CTE>'           || R_CURSOR.CTE                                       || '</CTE>';
          vXmlEntregaDet := vXmlEntregaDet || '<NOTA>'          || R_CURSOR.NOTA                                      || '</NOTA>';
          vXmlEntregaDet := vXmlEntregaDet || '<REMETENTE>'     || R_CURSOR.REMETENTE                                 || '</REMETENTE>';
          vXmlEntregaDet := vXmlEntregaDet || '<CHAVENF>'       || RPAD(NVL(R_CURSOR.CHAVENF,'.'),44)                 || '</CHAVENF>';
          vXmlEntregaDet := vXmlEntregaDet || '<CHAVECTE>'      || RPAD(NVL(R_CURSOR.CHAVECTE,''),44)                 || '</CHAVECTE>';
          vXmlEntregaDet := vXmlEntregaDet || '</row>';

      End Loop;
      
      If tpVF.vAuxiliar = 0 Then
        
          vXmlEntregaDet := vXmlEntregaDet || '<row num=#1#>';
          vXmlEntregaDet := vXmlEntregaDet || '<NOTAINC></NOTAINC>';
          vXmlEntregaDet := vXmlEntregaDet || '<DESTINATARIO></DESTINATARIO>';
          vXmlEntregaDet := vXmlEntregaDet || '<ENTREGA></ENTREGA>';
          vXmlEntregaDet := vXmlEntregaDet || '<DTAGENDADA></DTAGENDADA>';
          vXmlEntregaDet := vXmlEntregaDet || '<ARMAZEMTRANSF></ARMAZEMTRANSF>';
          vXmlEntregaDet := vXmlEntregaDet || '<CTE></CTE>';
          vXmlEntregaDet := vXmlEntregaDet || '<NOTA></NOTA>';
          vXmlEntregaDet := vXmlEntregaDet || '<REMETENTE></REMETENTE>';
          vXmlEntregaDet := vXmlEntregaDet || '<CHAVENF></CHAVENF>';
          vXmlEntregaDet := vXmlEntregaDet || '<CHAVECTE></CHAVECTE>';
          vXmlEntregaDet := vXmlEntregaDet || '</row>';

      End IF;

       vXmlEntregaDet := '<table name=#EntregaDet#><rowset>'|| vXmlEntregaDet || '</rowset></table>';

       vXmlEntregaDet := Replace( vXmlEntregaDet, '#', '''' );

      
      tpVF.vAuxiliar := 0;
      FOR R_CURSOR IN(SELECT vi.con_conhecimento_codigo vfrete,
                             vi.con_conhecimento_serie serie,
                             vi.glb_rota_codigo rota,
                             vi.con_valefrete_saque sq,
                             vi.glb_vfimagem_codcliente seq,
                             vi.usu_usuario_codigocriou ucriou,
                             vi.glb_vfimagem_dtgravacao dcriou,
                             vi.usu_usuario_codigoconf uconf,
                             vi.glb_vfimagem_dtconferencia dconf,
                             vi.glb_vfimagem_codentrega codentrega,
                             vi.glb_vfimagem_arquivado Arquivada,
                             coleta.pkg_web_auxiliar.fn_retornalinkvalefrete(vi.con_conhecimento_codigo,
                                                                             vi.con_conhecimento_serie,
                                                                             vi.glb_rota_codigo,
                                                                             vi.con_valefrete_saque,
                                                                             vi.glb_vfimagem_codcliente) link
                      FROM TDVADM.T_GLB_VFIMAGEM VI
                      where vi.con_conhecimento_codigo = tpVF.VFNumero
                        and vi.con_conhecimento_serie  = tpVF.VFSerie
                        and vi.glb_rota_codigo         = tpVF.VFRota
                        and vi.glb_vfimagem_arquivado = 'S'
                      order by vi.con_conhecimento_codigo,
                               vi.con_conhecimento_serie,
                               vi.glb_rota_codigo,
                               vi.con_valefrete_saque,
                               vi.glb_vfimagem_codcliente
                      )
       LOOP

          tpVF.vAuxiliar := tpVF.vAuxiliar + 1;
          vXmlImagem := vXmlImagem || '<row num=#'    || to_char(tpVF.vAuxiliar)                       ||  '#>';
          vXmlImagem := vXmlImagem || '<vfrete>'      || R_CURSOR.VFRETE                               || '</vfrete>';
          vXmlImagem := vXmlImagem || '<serie>'       || R_CURSOR.SERIE                                || '</serie>';
          vXmlImagem := vXmlImagem || '<rota>'        || R_CURSOR.ROTA                                 || '</rota>';
          vXmlImagem := vXmlImagem || '<Saque>'       || R_CURSOR.SQ                                   || '</Saque>';
          vXmlImagem := vXmlImagem || '<Sequencia>'   || R_CURSOR.SEQ                                  || '</Sequencia>';
          vXmlImagem := vXmlImagem || '<UsuCriou>'    || R_CURSOR.UCRIOU                               || '</UsuCriou>';
          vXmlImagem := vXmlImagem || '<DtCriou>'     || to_char(R_CURSOR.DCRIOU,'dd/mm/yyyy hh24:mi') || '</DtCriou>';
          vXmlImagem := vXmlImagem || '<UsuConferiu>' || R_CURSOR.UCONF                                || '</UsuConferiu>';
          vXmlImagem := vXmlImagem || '<DtConferiu>'  || to_char(R_CURSOR.DCONF,'dd/mm/yyyy hh24:mi')  || '</DtConferiu>';
          vXmlImagem := vXmlImagem || '<CodEntrega>'  || R_CURSOR.CODENTREGA                           || '</CodEntrega>';
          vXmlImagem := vXmlImagem || '<Arquivada>'   || R_CURSOR.Arquivada                            || '</Arquivada>';
          vXmlImagem := vXmlImagem || '<link>'        || rpad(R_CURSOR.LINK,150)                       || '</link>';
          vXmlImagem := vXmlImagem || '</row>';


       End Loop;
       
       

       If tpVF.vAuxiliar = 0 Then

          vXmlImagem := '';
          vXmlImagem := vXmlImagem || '<row num=#1#>';
          vXmlImagem := vXmlImagem || '<vfrete></vfrete>';
          vXmlImagem := vXmlImagem || '<serie></serie>';
          vXmlImagem := vXmlImagem || '<rota></rota>';
          vXmlImagem := vXmlImagem || '<Saque></Saque>';
          vXmlImagem := vXmlImagem || '<Sequencia></Sequencia>';
          vXmlImagem := vXmlImagem || '<UsuCriou></UsuCriou>';
          vXmlImagem := vXmlImagem || '<DtCriou></DtCriou>';
          vXmlImagem := vXmlImagem || '<UsuConferiu></UsuConferiu>';
          vXmlImagem := vXmlImagem || '<DtConferiu></DtConferiu>';
          vXmlImagem := vXmlImagem || '<CodEntrega></CodEntrega>';
          vXmlImagem := vXmlImagem || '<Arquivada></Arquivada>';
          vXmlImagem := vXmlImagem || '<link></link>';
          vXmlImagem := vXmlImagem || '</row>';

       End If;

       vXmlImagem := '<table name=#Imagem#><rowset>'|| vXmlImagem || '</rowset></table>';

    vXmlImagem := Replace( vXmlImagem, '#', '''' );


      Select sum(p.car_contacorrente_saldo)
        into tpVF.vAuxiliar
      FROM v_Car_Contacorrente P
      WHERE trim(p.cpncnpjprop) = trim(tpVF.v_Proprietario)
        and p.dtfecha is Null
        and trunc(p.dtvenc) <= trunc(sysdate)
        And p.car_contacorrente_saldo > 0
        And p.car_contacorrente_saldo = (Select Min(p1.car_contacorrente_saldo)
                                         From v_Car_Contacorrente P1
                                         WHERE trim(p1.cpncnpjprop) = trim(p.cpncnpjprop)
                                           And p1.documento = p.documento
                                           and trunc(p1.dtvenc) <= trunc(sysdate)
                                           and p.dtfecha is Null )
      Order By P.car_contacorrente_dtgravacao;




     tpVF.vXmlTab :=           '<parametros><output>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<CON_VALEFRETE_MULTA>' || replace(REPLACE(to_char(tpVF.VFCON_VALEFRETE_MULTA,'99990.00'),',',''),'.',',')      || '</CON_VALEFRETE_MULTA>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<psaldocc>' || f_mascara_valor(tpVF.vAuxiliar,20,2) || '</psaldocc>';
     -- retirar na proxima versao
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vStatusVF>'           || tpVF.vSQAntPagoCx       || '</vStatusVF>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vPrimeiroSaque>'      || tpVF.vPrimeiroSaque     || '</vPrimeiroSaque>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vUltimoSaque>'        || tpVF.vUltimoSaque       || '</vUltimoSaque>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vUltimoSaqueValido>'  || tpVF.vUltimoSaqueValido || '</vUltimoSaqueValido>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vSQAnteriorPagoCx>'   || tpVF.vSQAntPagoCx       || '</vSQAnteriorPagoCx>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vSQAnteriorPagoEl>'   || tpVF.vSQAntPagoEl       || '</vSQAnteriorPagoEl>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vSQAnteriorAcerto>'   || tpVF.vSQAntPagoAc       || '</vSQAnteriorAcerto>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vFaltaComprovante>'   || tpVF.vFaltaComprovante  || '</vFaltaComprovante>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vZeraPedagio>'        || tpVF.vZeraPedagio       || '</vZeraPedagio>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vCriadoPeloFIFO>'     || tpVf.vCriadoPeloFIFO    || '</vCriadoPeloFIFO>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vServTercPagador>'    || tpVf.vServTercPagador   || '</vServTercPagador>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vPclCodigo>'          || vPclCodigo              || '</vPclCodigo>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vPclVersao>'          || vPclVersao              || '</vPclVersao>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<vStatusEstadia>'      || trim(vStatusEstadia)    || '</vStatusEstadia>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '<tables>';
     tpVF.vXmlTab := tpVF.vXmlTab|| vXmlImagem;
     tpVF.vXmlTab := tpVF.vXmlTab|| vXmlEntrega;
     tpVF.vXmlTab := tpVF.vXmlTab|| vXmlEntregaDet;
     tpVF.vXmlTab := tpVF.vXmlTab|| '</tables>';
     tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';
      
     
     
     P_XMLOUT := replace(fn_limpa_campoxml(tpVF.vXmlTab),'img ','img$');
--     P_XMLOUT := tdvadm.fn_limpa_campo2(P_XMLOUT);
    

   End SP_CON_VALIDAVALEFRETE;

   PROCEDURE SP_CON_VERIFICACANCELVF(P_VF      IN  T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                                     P_SERIE   IN  T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                                     P_ROTA    IN  T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                                     P_SAQUE   IN  T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                                     P_STATUS  OUT CHAR,
                                     P_MESSAGE OUT VARCHAR2) AS

   vPlacaVeic      T_CAR_VEICULO.CAR_VEICULO_PLACA%TYPE;
   vPlacaSaque     T_CAR_VEICULO.CAR_VEICULO_SAQUE%TYPE;
   vDatacadastroVf T_CON_VALEFRETE.CON_VALEFRETE_DATACADASTRO%TYPE;
   vProprietario   T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE;
   vExistValeFrete INTEGER;
   vstringRetorno  VARCHAR2(4000);

   BEGIN

         BEGIN
           /***********************************************/
           /************  INFORMAÇÕES DO VF  **************/
           /***********************************************/
           BEGIN
             SELECT J.CON_VALEFRETE_PLACA       ,
                    J.CON_VALEFRETE_PLACASAQUE  ,
                    J.CON_VALEFRETE_DATACADASTRO
               INTO vPlacaVeic                  ,
                    vPlacaSaque                 ,
                    vDatacadastroVf
               FROM T_CON_valefrete j
              WHERE J.CON_CONHECIMENTO_CODIGO = P_VF
                AND J.CON_CONHECIMENTO_SERIE  = P_SERIE
                AND J.GLB_ROTA_CODIGO         = P_ROTA
                AND J.CON_VALEFRETE_SAQUE     = P_SAQUE;
           EXCEPTION WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20001,'Erro ao consultar Vale frete! Erro= '||sqlerrm);
           END;
           /***********************************************/


           /***********************************************/
           /*********** INF DO PROPRIETARIO ***************/
           /***********************************************/
           BEGIN

             SELECT J.CAR_PROPRIETARIO_CGCCPFCODIGO
               INTO vProprietario
               FROM T_CAR_VEICULO J
              WHERE J.CAR_VEICULO_PLACA = vPlacaVeic
                AND J.CAR_VEICULO_SAQUE = vPlacaSaque;

           EXCEPTION WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20001,'Erro ao consultar proprietário! Erro= '||sqlerrm);
           END;
           /***********************************************/


           /***************************************************************************/
           /*********** CURSOR COM OS VF CRIADOS APÓS O A SER CANCELADO ***************/
           /***************************************************************************/
           vExistValeFrete := 0;
           FOR V_VFRETE IN  (SELECT VF.CON_CONHECIMENTO_CODIGO,
                                    VF.CON_CONHECIMENTO_SERIE,
                                    VF.GLB_ROTA_CODIGO,
                                    VF.CON_VALEFRETE_SAQUE,
                                    VF.CON_VALEFRETE_DATACADASTRO
                               FROM T_CON_VALEFRETE VF
                               WHERE NVL(VF.CON_VALEFRETE_STATUS,'I') <> 'C'
                                 AND (SELECT PRO.CAR_PROPRIETARIO_CGCCPFCODIGO
                                        FROM T_CAR_VEICULO VEI,
                                             T_CAR_PROPRIETARIO PRO
                                       WHERE VEI.CAR_VEICULO_PLACA = VF.CON_VALEFRETE_PLACA
                                         AND VEI.CAR_VEICULO_SAQUE = VF.CON_VALEFRETE_PLACASAQUE
                                         AND VEI.CAR_PROPRIETARIO_CGCCPFCODIGO = PRO.CAR_PROPRIETARIO_CGCCPFCODIGO) = vProprietario
                                 AND VF.CON_VALEFRETE_DATACADASTRO > vDatacadastroVf)
           LOOP
             vExistValeFrete := vExistValeFrete+1;
             IF length(vstringRetorno) = 0 THEN
                vstringRetorno  := 'Vale frete = '||V_VFRETE.CON_CONHECIMENTO_CODIGO||
                                   ' Serie = '  ||V_VFRETE.CON_CONHECIMENTO_SERIE||
                                   ' Rota  = '  ||V_VFRETE.GLB_ROTA_CODIGO||
                                   ' Saque = '  ||V_VFRETE.CON_VALEFRETE_SAQUE||
                                   ' Emissão = '||TRUNC(V_VFRETE.CON_VALEFRETE_DATACADASTRO);
             ELSE
                vstringRetorno  := vstringRetorno ||chr(13)||
                                   ' Vale frete = '||V_VFRETE.CON_CONHECIMENTO_CODIGO||
                                   ' Serie = '||V_VFRETE.CON_CONHECIMENTO_SERIE||
                                   ' Rota  = '||V_VFRETE.GLB_ROTA_CODIGO||
                                   ' Saque = '||V_VFRETE.CON_VALEFRETE_SAQUE||
                                   ' Emissão = '||TRUNC(V_VFRETE.CON_VALEFRETE_DATACADASTRO);
             END IF;


           END LOOP;

           /***********************************************/
           /*********** RETORNO DA PROCEDURE***************/
           /***********************************************/
           IF vExistValeFrete > 0 THEN
              P_STATUS  := PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := 'Existem documentos emitidos para esse proprietario posterior a data desse vale frete.'||
                           CHR(13)||
                           vstringRetorno;
           ELSE
              P_STATUS  := PKG_GLB_COMMON.Status_Nomal;
              P_MESSAGE := '' ;
           END IF;
           /***********************************************/
         EXCEPTION WHEN OTHERS THEN
           P_STATUS  := PKG_GLB_COMMON.Status_Erro;
           P_MESSAGE := 'Erro na execução da procedure "PKG_CON_VALEFRETE.SP_CON_VERIFICACANCELVF". Erro = '||SQLERRM;
         END;

   END SP_CON_VERIFICACANCELVF;

   PROCEDURE SP_CON_CONSULTAVALEFRETE(P_QRYSTR    In Out  Varchar2,
                                      P_STATUS    In OUT Varchar2,
                                      P_MESSAGE   In OUT Varchar2,
                                      P_CURSOR    OUT PKG_GLB_COMMON.T_CURSOR) As

 /* exemplo de QueryStr
 'VFNumero=nome=VFNumero|tipo=String|valor=' + p_VF + '*' +
 'VFSerie=nome=VFSerie|tipo=String|valor=' + p_Serie + '*' +
 'VFRota=nome=VFRota|tipo=String|valor=' + p_Rota + '*' +
 'VFSaque=nome=VFSaque|tipo=String|valor=' + p_Saque + '*' +
 'VFAcao=nome=VFAcao|tipo=String|valor=Excluir*' +
 'VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=' + p_Usuario + '*' +
 'VFRotaUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=' + Frm_ValeFrete.v_Rota + '*' +
 'VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*' +
 'VFVersaoAplicao=nome=VFVersaoAplicao|tipo=String|valor=12.3.8.0*' +
 'VFTpValeFrete=nome=VFTpValeFrete|tipo=String|valor=01*' +
 'VFValeFreteSemConhec=nome=VFTpValeFrete|tipo=String|valor=N*;
 */

      VSql             Varchar2(1000);

      VFNumero         tdvadm.t_con_valefrete.con_conhecimento_codigo%Type;
      VFSerie          tdvadm.t_con_valefrete.con_conhecimento_serie%Type;
      VFRota           tdvadm.t_con_valefrete.glb_rota_codigo%Type;
      VFSaque          tdvadm.t_con_valefrete.con_valefrete_saque%Type;
      VFAcao           Varchar2(15);
      VFusuarioTDV     tdvadm.t_usu_usuario.usu_usuario_codigo%Type;
      VFRotaUsuarioTDV tdvadm.t_glb_rota.glb_rota_codigo%Type;
      VFAplicacaoTDV   tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type;
      VFVersaoAplicao  tdvadm.t_usu_aplicacao.usu_aplicacao_versao%Type;
      vImpressao       tdvadm.t_con_valefrete.con_valefrete_impresso%Type;
      vStatus          tdvadm.t_con_valefrete.con_valefrete_status%Type;
      VFTpValeFrete    Char(2);
      vSerieDiferente  Char(1);
      VFValeFreteSemConhec Char(1);
      vRetorno          Number;

      vRotaDescricao       tdvadm.t_glb_rota.glb_rota_descricao%Type;
      vDataEntrega         tdvadm.t_con_valefrete.con_valefrete_dataprazomax%Type;
      vLocalidade          tdvadm.t_glb_localidade.glb_localidade_codigo%Type;
      vLocalidadeDescricao tdvadm.t_glb_localidade.glb_localidade_descricao%Type;

    Begin

      VFNumero             := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFNumero','=','*'), 'valor', '=', '|');
      VFSerie              := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFSerie','=','*'), 'valor', '=', '|');
      VFRota               := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFRota','=','*'), 'valor', '=', '|');
      VFSaque              := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFSaque','=','*'), 'valor', '=', '|');
      VFAcao               := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFAcao','=','*'), 'valor', '=', '|');
      VFusuarioTDV         := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFusuarioTDV','=','*'), 'valor', '=', '|');
      VFRotaUsuarioTDV     := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|');
      VFAplicacaoTDV       := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFAplicacaoTDV','=','*'), 'valor', '=', '|');
      VFVersaoAplicao      := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFVersaoAplicao','=','*'), 'valor', '=', '|');
      vImpressao           := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'vImpressao','=','*'), 'valor', '=', '|');
      vStatus              := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'vStatus','=','*'), 'valor', '=', '|');
      VFTpValeFrete        := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFTpValeFrete','=','*'), 'valor', '=', '|');
      VFValeFreteSemConhec := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QRYSTR,'VFValeFreteSemConhec','=','*'), 'valor', '=', '|');


      VSql := ' SELECT A.CON_VALEFRETE_CODIGO, ' ||
              '        A.CON_VALEFRETE_SERIE, ' ||
              '        A.GLB_ROTA_CODIGOVALEFRETE, ' ||
              '        A.CON_VALEFRETE_CODIGO, ' ||
              '        A.CON_CONHECIMENTO_CODIGO, ' ||
              '        A.CON_CONHECIMENTO_PLACA, ' ||
              '        A.CON_VALEFRETE_SAQUE ' ||
              ' FROM  T_CON_CONHECIMENTO A ' ||
              ' WHERE  A.CON_CONHECIMENTO_CODIGO = ' || pkg_glb_common.fn_QuotedStr(VFNumero) ||
              '   AND  A.CON_CONHECIMENTO_SERIE  = ' ||pkg_glb_common.fn_QuotedStr(VFSerie) ||
              '   AND  A.GLB_ROTA_CODIGO   = ' || pkg_glb_common.fn_QuotedStr(VFRota) ||
              '   AND  A.CON_VALEFRETE_CODIGO IS NOT Null ' ||
              '   AND  A.CON_VALEFRETE_SERIE  IS NOT Null ' ||
              '   AND  A.GLB_ROTA_CODIGOVALEFRETE IS NOT Null ' ||
              '   AND  A.CON_VALEFRETE_SAQUE IS NOT Null ' ||
              '   AND  (SELECT COUNT(*)  ' ||
              '         FROM   T_CON_VALEFRETE B ' ||
              '         WHERE  B.CON_CONHECIMENTO_CODIGO = A.CON_VALEFRETE_CODIGO ' ||
              '           AND  B.CON_CONHECIMENTO_SERIE  = A.CON_VALEFRETE_SERIE ' ||
              '           AND  B.GLB_ROTA_CODIGO         = A.GLB_ROTA_CODIGOVALEFRETE ' ||
              '           AND  B.CON_VALEFRETE_SAQUE     = A.CON_VALEFRETE_SAQUE) > 0 ';

      Open P_CURSOR For Trim(VSQL);


      P_STATUS := 'N';
      P_MESSAGE := 'TESTE DE RETORNO MSG' || chr(10);

 -- Verifica se a Rota Existe.

   if VFRota = '' then
     P_MESSAGE := P_MESSAGE || 'Preencha a Rota.' || chr(10);
     P_STATUS := 'E';
   else
      Begin
        Select r.glb_rota_descricao,
               r.glb_localidade_codigo ,
               l.glb_localidade_descricao
          Into vRotaDescricao,
               vLocalidade,
               vLocalidadeDescricao
        From t_glb_rota r,
             t_glb_localidade l
        Where r.glb_rota_codigo = VFRota
          And r.glb_localidade_codigo = l.glb_localidade_codigo (+);
       Exception
         When NO_DATA_FOUND Then
            vRotaDescricao       := '';
            vLocalidade          := '';
            vLocalidadeDescricao := '';

       End;
         if nvl(vRotaDescricao,'NE') = 'NE' then
           P_MESSAGE := P_MESSAGE || 'Rota Não Existe' || chr(10);
           P_STATUS := 'E';
         End If;

         if nvl(vLocalidade,'NE') = 'NE' then
           P_MESSAGE := P_MESSAGE || 'Rota Sem Codigo de Localidade' || chr(10);
           P_STATUS := 'E';
         End If;


  End If;




   if (VFTpValeFrete = '02') or (VFTpValeFrete = '09')  then
       if (VFSerie <> 'A0') and (VFSerie <> 'A1') and (VFSerie <> 'C1') then
         vSerieDiferente := 'S';
       else
         vSerieDiferente := 'N';
       End If;

  End If;

   if (VFNumero = '') and (VFTpValeFrete <> '10') and (VFTpValeFrete <> '11') then
     P_MESSAGE := P_MESSAGE || 'Preencha o número do CTRC.' || chr(10);
     P_STATUS := 'E';

  End If;

   if (VFNumero = '') and (VFTpValeFrete = '11') then
     P_MESSAGE := P_MESSAGE || 'Preencha o número do Manifesto.' || chr(10);
     P_STATUS := 'E';

  End If;


 /********************************/



   if VFSerie = '' then
     P_MESSAGE := P_MESSAGE || 'Preencha a série.' || chr(10);
     P_STATUS := 'E';

  End If;



   if ((VFTpValeFrete = '08') or (VFTpValeFrete = '10')) and (VFRota <> '026') and (VFRota <> '039') then
     if not (( VFValeFreteSemConhec = 'S' ) and (VFTpValeFrete = '08') and (VFRota <> '')) then
       P_MESSAGE := P_MESSAGE || 'Vale frete Avulso Despesas TDV/Serviço de Terceiro só pode ser feito na ROTA 026 ou 039.';
       P_STATUS := 'E';
       VFRota := '';
     End If;

  End If;


   Begin
     If ( ( VFRota Not In ('033','034') ) Or (vSerieDiferente = 'N') ) Then
        Select vf.con_valefrete_dataprazomax
          Into vDataEntrega
        From t_con_valefrete vf
        Where vf.con_conhecimento_codigo = VFNumero
          And vf.con_conhecimento_serie = VFSerie
          And vf.glb_rota_codigo = vfRota
          And vf.con_valefrete_saque = VFSaque;
      Else
        Select vf.con_valefrete_dataprazomax
          Into vDataEntrega
        From t_con_valefrete vf
        Where vf.con_conhecimento_codigo = VFNumero
          And vf.glb_rota_codigo = vfRota
          And vf.con_valefrete_saque = VFSaque;
     End If;
   Exception
      When NO_DATA_FOUND Then
          vDataEntrega := Null;
   End ;


   if (VFTpValeFrete < '11') or (VFTpValeFrete = '14') or (VFTpValeFrete = '16') or (VFTpValeFrete = '17') then
       if (VFTpValeFrete <> '06') and -- TRANSPESA
          (VFTpValeFrete <> '07') and -- REMOÇÃO
          (VFTpValeFrete <> '08') and -- AVULSO DESP S/ CTRC
          (VFTpValeFrete <> '10') Then -- SERVIÇO DE TERCEIRO
 -- sirlano         LocalizaConhecimento(E_CTRC.Text, VFSerie, VFRota);
          if vRetorno = '0' then
             P_MESSAGE := P_MESSAGE || 'Conhecimento não cadastrado.';
             P_STATUS := 'E';
          End If;
       Else -- transpesa e (avulso despesas TDV)
          if (VFTpValeFrete = '10') And (VFNumero = '') then
              VFNumero := '0' ;-- sirlano GeraSequenciaTerceiro;
          End If;

 -- sirlano         LocalizaValeFrete(VFNumero, VFSerie, VFRota);

          if vRetorno <> 0  then
             P_MESSAGE := P_MESSAGE || 'Já existe um Vale Frete com esse Número.' || chr(10);
             P_STATUS := 'E';
          End If;
       End If;
   else
     if (VFTpValeFrete = '11') then
 -- sirlano       LocalizaManifesto(E_CTRC.Text,VFSerie,VFRota);
         P_STATUS := P_STATUS;
     End If;
       -- pega o codigo do manifesto antes de localizar
     if (VFTpValeFrete = '12') or (VFTpValeFrete = '13') then
 /*                sql.Add('SELECT MN.CON_MANIFESTO_CODIGO, ');
                 sql.Add('MN.CON_MANIFESTO_SERIE, '        );
                 sql.Add('MN.CON_MANIFESTO_ROTA '          );
                 sql.Add('FROM T_ARM_NOTA NT, '            );
                 sql.Add('T_CON_CONHECIMENTO CH, '         );
                 sql.Add('T_ARM_CARREGAMENTO CG, '         );
                 sql.Add('T_CON_MANIFESTO MN '             );
                 sql.Add('WHERE NT.CON_CONHECIMENTO_CODIGO = '+QuotedStr(E_CTRC.Text));
                 sql.Add('  AND NT.CON_CONHECIMENTO_SERIE  = '+QuotedStr(E_SERIE.Text));
                 sql.Add('  AND NT.GLB_ROTA_CODIGO         = '+QuotedStr(E_ROTA.Text));
                 sql.Add('  AND NT.CON_CONHECIMENTO_CODIGO = CH.CON_CONHECIMENTO_CODIGO');
                 sql.Add('  AND NT.CON_CONHECIMENTO_SERIE  = CH.CON_CONHECIMENTO_SERIE');
                 sql.Add('  AND NT.GLB_ROTA_CODIGO         = CH.GLB_ROTA_CODIGO');
                 sql.Add('  AND CH.ARM_CARREGAMENTO_CODIGO = CG.ARM_CARREGAMENTO_CODIGO');
                 sql.Add('  AND MN.ARM_CARREGAMENTO_CODIGO = CG.ARM_CARREGAMENTO_CODIGO');
                 Open;
                   if (RecordCount = 0) then
                     MessageDlg('CTRC não localizado no Armazém.', mtInformation, [mbOk], 0);
                   End If;
 */
             P_MESSAGE := P_MESSAGE || 'CTRC não localizado no Armazém.' || chr(10);
             P_STATUS := 'E';

     End If;
 -- sirlano           LocalizaManifesto(Fields[0].AsString, Fields[1].AsString, Fields[2].AsString);
    End If;

      P_QRYSTR := 'Klayton';

   End SP_CON_CONSULTAVALEFRETE;


  PROCEDURE SP_CON_INSERE_VALEFRETE(P_CON_CONHECIMENTO_CODIGO      IN CHAR,
                                    P_CON_CONHECIMENTO_SERIE       IN CHAR,
                                    P_CON_VIAGEM_NUMERO            IN CHAR,
                                    P_GLB_ROTA_CODIGO              IN CHAR,
                                    P_GLB_ROTA_CODIGOVIAGEM        IN CHAR,
                                    P_CON_VALEFRETE_SAQUE          IN CHAR,
                                    P_CON_VALEFRETE_CONHECIMENTOS  IN CHAR,
                                    P_CON_VALEFRETE_CARRETEIRO     IN CHAR,
                                    P_CON_VALEFRETE_NFS            IN CHAR,
                                    P_CON_VALEFRETE_PLACASAQUE     IN CHAR,
                                    P_CON_VALEFRETE_TIPOTRANSPORTE IN CHAR,
                                    P_CON_VALEFRETE_PLACA          IN CHAR,
                                    P_CON_VALEFRETE_LOCALCARREG    IN CHAR,
                                    P_CON_VALEFRETE_LOCALDESCARGA  IN CHAR,
                                    P_CON_VALEFRETE_KMPREVISTA     IN NUMBER,
                                    P_CON_VALEFRETE_PESOINDICADO   IN NUMBER,
                                    P_CON_VALEFRETE_LOTACAO        IN NUMBER,
                                    P_CON_VALEFRETE_PESOCOBRADO    IN NUMBER,
                                    P_CON_VALEFRETE_ENTREGAS       IN CHAR,
                                    P_CON_VALEFRETE_CUSTOCARRET    IN NUMBER,
                                    P_CON_VALEFRETE_TIPOCUSTO      IN CHAR,
                                    P_CON_VALEFRETE_EMISSOR        IN CHAR,
                                    P_GLB_LOCALIDADE_CODIGODES     IN CHAR,
                                    P_GLB_LOCALIDADE_CODIGOORI     IN CHAR,
                                    P_CON_CATVALEFRETE_CODIGO      IN CHAR,
                                    P_GLB_TPMOTORISTA_CODIGO       IN CHAR,
                                    P_USU_USUARIO                  IN CHAR,
                                    P_CON_VALEFRETE_DTEMISSAO      CHAR,
                                    p_CON_VALEFRETE_DOCREF         IN VARCHAR2,
                                    P_CON_SUBCATVALEFRETE_CODIGO   IN CHAR)
 --DEFAULT TRUNC(SYSDATE)
  AS
   V_SAQUE                   T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
   V_MAQAUTORIZADA           CHAR(400);
   V_TERMINAL                CHAR(20);
   V_DIAS                    NUMBER;
   V_OBS                     CHAR(60);
   V_CON_VALEFRETE_DTCHECKIN CHAR(10);
   V_BONUS                   NUMBER;
   V_PLACASAQUE              CHAR(4);
   V_QTDDIAS                 NUMBER;
   v_bloqueios               number;
   v_alertas                 number;
   V_TESTE                   CHAR(10);
   V_DATA                    DATE;
   vEmissor                  varchar2(15);
   TypeValeFrete             TDVADM.T_CON_VALEFRETE%ROWTYPE;
   -- VARIAVEIS PARA PEGAR OS PARAMETROS
   V_PARAMETRO  T_USU_PERFIL.USU_PERFIL_CODIGO%TYPE;
   V_PARAMTEXTO T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;
   V_PERC_BONUS T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;
   vInteger                  integer;
   vPedaco          tdvadm.t_por_mensagem.por_mensagem_codigo%type;
   VS_BLOQUEIOS     varchar2(200);
   VS_PLACACARRETA  char(7);
   VS_CONJUNTO      char(7);
   vs_MOTORISTA     varchar2(50);
   VS_ODOMETRO      varchar2(20);


   -- MONTA O CURSOR PARA PEGAR OS PARAMETROS
   CURSOR C_PARAMETROS IS
     SELECT P.PERFIL, P.TEXTO
       FROM T_USU_PARAMETROTMP P
      WHERE P.USUARIO = P_USU_USUARIO
        AND P.APLICACAO = 'comvlfrete'
        and P.ROTA = P_GLB_ROTA_CODIGO;

 BEGIN

  --  RAISE_APPLICATION_ERROR(-20001,'ERRO = '||LENGTH(TRIM(P_CON_VALEFRETE_ENTREGAS)));

   -- PEGA PARAMETROS
   sp_usu_parametrossc('comvlfrete', P_USU_USUARIO, P_GLB_ROTA_CODIGO, 'PROCEDURE');

   OPEN C_PARAMETROS;
   LOOP
     FETCH C_PARAMETROS
       INTO V_PARAMETRO, V_PARAMTEXTO;
     EXIT WHEN C_PARAMETROS%NOtFOUND;

     IF V_PARAMETRO = 'PERCENT_BONUS' THEN
       V_PERC_BONUS := V_PARAMTEXTO;
     END IF;

   END LOOP;
   CLOSE C_PARAMETROS;

 --  EXECUTE IMMEDIATE ('ALTER SESSION SET OPTIMIZER_MODE=RULE');
   SELECT DISTINCT USERENV('TERMINAL')
     INTO V_TERMINAL
     FROM V$SESSION
    WHERE TERMINAL = USERENV('TERMINAL') AND STATUS = 'ACTIVE';

   BEGIN
     SELECT INT_PARAMETROS_STRING
       INTO V_MAQAUTORIZADA
       FROM T_INT_PARAMETROS
      WHERE INT_PARAMETROS_SISTEMA = 'CON' AND
            INT_PARAMETROS_CODIGO = 'EXC_ALT_VF' AND
            INT_PARAMETROS_ATIVO = 'S';

     V_MAQAUTORIZADA := TRIM(V_MAQAUTORIZADA);
     /*
                        ', CVRD_002,
                           CVRDPA_001,
                           CVRDPA_002,
                           CVRDPA_003,
                           CVRDMA_001,
                           CVRDMA_002, ' ||
                        'CVRDMA_003,
                         NOTE-TI,
                         UBERLANDIA-01,
                         Cvrd_Note;
                         CPD2000_006';*/

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       V_MAQAUTORIZADA := NULL;
   END;

   V_MAQAUTORIZADA := NULL;

  select substr(u.usu_usuario_nome,1,15)
    into vEmissor
  from t_usu_usuario u
  where u.usu_usuario_codigo = P_USU_USUARIO;

   -- SE AVULSO(C/ CTRC)

 SELECT max(TT.INT_PARAMETROS_VALOR1)
 INTO V_QTDDIAS
  FROM  T_INT_PARAMETROS TT
  WHERE TT.INT_PARAMETROS_CODIGO = 'VL_DIAS'
    AND TT.INT_PARAMETROS_SISTEMA = 'CON'
    AND TT.INT_PARAMETROS_ATIVO = 'S'
    AND TT.INT_PARAMETROS_ROTA = (P_GLB_ROTA_CODIGO)
    and nvl(instr(tt.int_parametros_string,trim(P_USU_USUARIO)),0) > 0;


   IF (lpad(P_CON_CATVALEFRETE_CODIGO,2,'0') = CatTAvulsoCCTRC) THEN

    BEGIN
        SELECT TO_DATE(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), 'DD/MM/YYYY')
          INTO V_DATA
        FROM DUAL;
     EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,'EU SOU BOM ' || SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10));
       END;
     IF (TRUNC(SYSDATE) - TO_DATE(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), 'DD/MM/YYYY'))> V_QTDDIAS THEN
         RAISE_APPLICATION_ERROR(-20001,
                                 'PRIMEIRO SAQUE DESTE VF FEITO A MAIS DE 5 DIAS, IMPOSSIVEL PROSSEGUIR - ' ||
                                 V_TERMINAL);

       END IF;


   ELSE
     IF (lpad(P_CON_CATVALEFRETE_CODIGO,2,'0') not in (CatTTranspesa,
                                           CatTRemocao,
                                           CatTAvulsoSCTRC,
                                           CatTServicoTerceiro)) THEN

       V_DIAS := (TO_DATE(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), 'DD/MM/YYYY') -
                 TRUNC(SYSDATE));

     -- a pedido do sr. ronald o serginho esta autorizado a emitir vales de fretes mesmo
       -- se superar o peso e for > que 5 dias alterado tambem na sp_con_insere_valefretenovo

        IF (TRUNC(SYSDATE) - TO_DATE(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), 'DD/MM/YYYY')) > V_QTDDIAS THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'CTRC DESTE VF EMITIDO A MAIS DE 5 DIAS, IMPOSSIVEL PROSSEGUIR');
        END IF;
     END IF;

  END IF;
   IF NVL(P_CON_VALEFRETE_SAQUE, 'NAOTEM') = 'NAOTEM' THEN
     SELECT MAX(NVL(CON_VALEFRETE_SAQUE, '1'))
       INTO V_SAQUE
       FROM T_CON_VALEFRETE
      WHERE CON_CONHECIMENTO_CODIGO = P_CON_CONHECIMENTO_CODIGO AND
            CON_CONHECIMENTO_SERIE = P_CON_CONHECIMENTO_SERIE AND
            GLB_ROTA_CODIGO = P_GLB_ROTA_CODIGO;
     --  P_CON_VALEFRETE_SAQUE :=  V_SAQUE;

  END IF;


   IF P_GLB_ROTA_CODIGO In ('021','036','160','185','197','237','270','320','460') And
      lpad(P_CON_CATVALEFRETE_CODIGO,2,'0') In (CatTUmaViagem,CatTVariasViagens) THEN


     IF TRIM(P_CON_VALEFRETE_TIPOCUSTO) = 'T' THEN
        V_BONUS := ((P_CON_VALEFRETE_CUSTOCARRET * P_CON_VALEFRETE_PESOCOBRADO) * TO_NUMBER(V_PERC_BONUS) / 100);
      ELSE
        V_BONUS := ((P_CON_VALEFRETE_CUSTOCARRET) * TO_NUMBER(V_PERC_BONUS) / 100);
     END IF;

     V_OBS := 'RECEBER R$ 0,00 DE BONUS NA PONTA - SE ENTREGUE NO PRAZO';    ---???,??

   ELSE
     V_OBS := '';

  END IF;
   ----

   IF P_CON_VALEFRETE_PLACASAQUE IS NULL THEN
      SELECT MAX(V.CAR_VEICULO_SAQUE)
        INTO V_PLACASAQUE
        FROM T_CAR_VEICULO V
       WHERE V.CAR_VEICULO_PLACA = P_CON_VALEFRETE_PLACA;

  END IF;

 PKG_CON_VALEFRETE.vProcValidaValeFrete := 'S';
 v_bloqueios := nvl(v_bloqueios ,0);
 sp_car_bloqueios(P_CON_VALEFRETE_PLACA,
                  trim(P_GLB_TPMOTORISTA_CODIGO),
                  trunc(sysdate),
                  null,
                  null,
                  null,
                  v_bloqueios,
                  v_alertas);


  v_bloqueios := nvl(v_bloqueios ,0);
  If v_bloqueios = 0 Then
     sp_valida_veiculo( P_CON_VALEFRETE_PLACA,
                        trim(P_GLB_TPMOTORISTA_CODIGO),
                        VS_BLOQUEIOS,
                        VS_PLACACARRETA,
                        VS_CONJUNTO,
                        vs_MOTORISTA,
                        VS_ODOMETRO);

     loop
       vInteger := nvl(instr(VS_BLOQUEIOS,'#'),0);
       exit when vInteger = 0;
       vPedaco := substr(VS_BLOQUEIOS,1,vInteger-1);
       VS_BLOQUEIOS := substr(VS_BLOQUEIOS,vInteger+1);
       Select count(*)
         into vInteger
       from tdvadm.t_por_mensagem m
       where m.por_mensagem_codigo = vPedaco
         and trim(nvl(m.por_mensagem_ativo,'S')) = 'S'
         and trim(nvl(m.por_mensagem_bloqueia,'1')) = '4';
       v_bloqueios := v_bloqueios + vInteger; 
     end loop;

       

  End If;

 PKG_CON_VALEFRETE.vProcValidaValeFrete := 'N';

--   Sirlano Retirado em 10/11/2021
--     Ricardo questionou porque nao estava funcionando
If lpad(trim(P_CON_CATVALEFRETE_CODIGO),2,'0') not in ('01','02') Then
     -- Retirei o 09
     -- Sirlano 17/09/2021
      v_bloqueios := 0;
 End If;   

   if v_bloqueios = 0 then
       BEGIN

      begin

      vInteger := 0;
      TypeValeFrete.Con_Conhecimento_Codigo       :=  P_CON_CONHECIMENTO_CODIGO;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Conhecimento_Serie        :=  P_CON_CONHECIMENTO_SERIE;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Viagem_Numero             :=  P_CON_VIAGEM_NUMERO;
      vInteger := vInteger+1;
      TypeValeFrete.Glb_Rota_Codigo               :=  P_GLB_ROTA_CODIGO;
      vInteger := vInteger+1;
      TypeValeFrete.Glb_Rota_Codigoviagem         :=  P_GLB_ROTA_CODIGOVIAGEM;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Saque           :=  P_CON_VALEFRETE_SAQUE;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Conhecimentos   :=  SUBSTR(P_CON_VALEFRETE_CONHECIMENTOS,1,60);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Carreteiro      :=  TRIM(P_CON_VALEFRETE_CARRETEIRO);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Nfs             :=  SUBSTR(P_CON_VALEFRETE_NFS,1,60);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Placasaque      :=  NVL( P_CON_VALEFRETE_PLACASAQUE, V_PLACASAQUE );
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Tipotransporte  :=  P_CON_VALEFRETE_TIPOTRANSPORTE;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Placa           :=  P_CON_VALEFRETE_PLACA;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Localcarreg     :=  SUBSTR(P_CON_VALEFRETE_LOCALCARREG,1,25);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Localdescarga   :=  SUBSTR(P_CON_VALEFRETE_LOCALDESCARGA,1,25);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Kmprevista      :=  TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_KMPREVISTA, 0), ',', '.'));
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Pesoindicado    := TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOINDICADO, 0), ',', '.'));
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Lotacao         := TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_LOTACAO, 0), ',', '.'));
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Pesocobrado     := TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOCOBRADO, 0), ',', '.'));
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Entregas        := TRIM(P_CON_VALEFRETE_ENTREGAS);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Custocarreteiro := TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_CUSTOCARRET, 0), ',', '.'));
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Tipocusto       := P_CON_VALEFRETE_TIPOCUSTO;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Datacadastro    := trunc(SYSDATE);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Emissor         := vEmissor;
      vInteger := vInteger+1;
      TypeValeFrete.Glb_Localidade_Codigodes      := TRIM(P_GLB_LOCALIDADE_CODIGODES);
      vInteger := vInteger+1;
      TypeValeFrete.Glb_Localidade_Codigoori      := TRIM(P_GLB_LOCALIDADE_CODIGOORI);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Dataemissao     := NVL(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), TRUNC(SYSDATE));
      vInteger := vInteger+1;
      TypeValeFrete.Con_Catvalefrete_Codigo       := lpad(P_CON_CATVALEFRETE_CODIGO,2,'0');
      vInteger := vInteger+1;
      TypeValeFrete.Glb_Tpmotorista_Codigo        := P_GLB_TPMOTORISTA_CODIGO;
      vInteger := vInteger+1;
      TypeValeFrete.Usu_Usuario_Codigo            := P_USU_USUARIO;
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Condespeciais   := SUBSTR(V_OBS,1,70);
      vInteger := vInteger+1;
      TypeValeFrete.Usu_Usuario_Codigortapresent  := (P_USU_USUARIO);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Valefrete_Docref          := (p_CON_VALEFRETE_DOCREF);
      vInteger := vInteger+1;
      TypeValeFrete.Con_Subcatvalefrete_Codigo    := (P_CON_SUBCATVALEFRETE_CODIGO);

      If substr(TypeValeFrete.Con_Valefrete_Placa,1,3) <> '000' then
         select p.car_proprietario_optsimples
           into TypeValeFrete.Con_Valefrete_Optsimples
         from tdvadm.t_car_proprietario p,
              tdvadm.t_car_veiculo v
         where p.car_proprietario_cgccpfcodigo = v.car_proprietario_cgccpfcodigo
           and v.car_veiculo_placa = TypeValeFrete.Con_Valefrete_Placa
           and v.car_veiculo_saque = TypeValeFrete.Con_Valefrete_Placasaque;
      Else
         TypeValeFrete.Con_Valefrete_Optsimples := 'N';
      End If;

      INSERT INTO TDVADM.T_CON_VALEFRETE VALUES TypeValeFrete;

      exception when others then
          RAISE_APPLICATION_ERROR(-20001,'ERRO = '||vInteger||' - Qtde Entregas (03):'||P_CON_VALEFRETE_SAQUE || '-' || Sqlerrm);

     end;


         
/*

         INSERT INTO T_CON_VALEFRETE
           (CON_CONHECIMENTO_CODIGO,
            CON_CONHECIMENTO_SERIE,
            CON_VIAGEM_NUMERO,
            GLB_ROTA_CODIGO,
            GLB_ROTA_CODIGOVIAGEM,
            CON_VALEFRETE_SAQUE,
            CON_VALEFRETE_CONHECIMENTOS,
            CON_VALEFRETE_CARRETEIRO,
            CON_VALEFRETE_NFS,
            CON_VALEFRETE_PLACASAQUE,
            CON_VALEFRETE_TIPOTRANSPORTE,
            CON_VALEFRETE_PLACA,
            CON_VALEFRETE_LOCALCARREG,
            CON_VALEFRETE_LOCALDESCARGA,
            CON_VALEFRETE_KMPREVISTA,
            CON_VALEFRETE_PESOINDICADO,
            CON_VALEFRETE_LOTACAO,
            CON_VALEFRETE_PESOCOBRADO,
            CON_VALEFRETE_ENTREGAS,
            CON_VALEFRETE_CUSTOCARRETEIRO,
            CON_VALEFRETE_TIPOCUSTO,
            CON_VALEFRETE_DATACADASTRO,
            CON_VALEFRETE_EMISSOR,
            GLB_LOCALIDADE_CODIGODES,
            GLB_LOCALIDADE_CODIGOORI,
            CON_VALEFRETE_DATAEMISSAO,
            CON_CATVALEFRETE_CODIGO,
            GLB_TPMOTORISTA_CODIGO,
            USU_USUARIO_CODIGO,
            CON_VALEFRETE_CONDESPECIAIS,
            USU_USUARIO_CODIGORTAPRESENT)
         VALUES
           (P_CON_CONHECIMENTO_CODIGO,
            P_CON_CONHECIMENTO_SERIE,
            P_CON_VIAGEM_NUMERO,
            P_GLB_ROTA_CODIGO,
            P_GLB_ROTA_CODIGOVIAGEM,
            P_CON_VALEFRETE_SAQUE,
            SUBSTR(P_CON_VALEFRETE_CONHECIMENTOS,1,60),
            TRIM(P_CON_VALEFRETE_CARRETEIRO),
            SUBSTR(P_CON_VALEFRETE_NFS,1,60),
            NVL( P_CON_VALEFRETE_PLACASAQUE, V_PLACASAQUE ),
            P_CON_VALEFRETE_TIPOTRANSPORTE,
            P_CON_VALEFRETE_PLACA,
            SUBSTR(P_CON_VALEFRETE_LOCALCARREG,1,25),
            SUBSTR(P_CON_VALEFRETE_LOCALDESCARGA,1,25),
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_KMPREVISTA, 0), ',', '.')),
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOINDICADO, 0), ',', '.')),
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_LOTACAO, 0), ',', '.')),
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOCOBRADO, 0), ',', '.')),
            TRIM(P_CON_VALEFRETE_ENTREGAS),
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_CUSTOCARRET, 0), ',', '.')),
            P_CON_VALEFRETE_TIPOCUSTO,
            trunc(SYSDATE),
            vEmissor,
            TRIM(P_GLB_LOCALIDADE_CODIGODES),
            TRIM(P_GLB_LOCALIDADE_CODIGOORI),
            NVL(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), TRUNC(SYSDATE)),
            lpad(P_CON_CATVALEFRETE_CODIGO,2,'0'),
            P_GLB_TPMOTORISTA_CODIGO,
            P_USU_USUARIO,
            SUBSTR(V_OBS,1,70),
            P_USU_USUARIO);

*/

       EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
           SELECT MAX(NVL(CON_VALEFRETE_SAQUE, '1')) + 1
             INTO V_SAQUE
             FROM T_CON_VALEFRETE
            WHERE CON_CONHECIMENTO_CODIGO = P_CON_CONHECIMENTO_CODIGO
              AND CON_CONHECIMENTO_SERIE = P_CON_CONHECIMENTO_SERIE
              AND GLB_ROTA_CODIGO = P_GLB_ROTA_CODIGO;
           
           TypeValeFrete.Con_Valefrete_Saque := V_SAQUE;
           
           INSERT INTO TDVADM.T_CON_VALEFRETE VALUES TypeValeFrete;
           
/*
           INSERT INTO T_CON_VALEFRETE
             (CON_CONHECIMENTO_CODIGO,
              CON_CONHECIMENTO_SERIE,
              CON_VIAGEM_NUMERO,
              GLB_ROTA_CODIGO,
              GLB_ROTA_CODIGOVIAGEM,
              CON_VALEFRETE_SAQUE,
              CON_VALEFRETE_CONHECIMENTOS,
              CON_VALEFRETE_CARRETEIRO,
              CON_VALEFRETE_NFS,
              CON_VALEFRETE_PLACASAQUE,
              CON_VALEFRETE_TIPOTRANSPORTE,
              CON_VALEFRETE_PLACA,
              CON_VALEFRETE_LOCALCARREG,
              CON_VALEFRETE_LOCALDESCARGA,
              CON_VALEFRETE_KMPREVISTA,
              CON_VALEFRETE_PESOINDICADO,
              CON_VALEFRETE_LOTACAO,
              CON_VALEFRETE_PESOCOBRADO,
              CON_VALEFRETE_ENTREGAS,
              CON_VALEFRETE_CUSTOCARRETEIRO,
              CON_VALEFRETE_TIPOCUSTO,
              CON_VALEFRETE_DATACADASTRO,
              CON_VALEFRETE_EMISSOR,
              GLB_LOCALIDADE_CODIGODES,
              GLB_LOCALIDADE_CODIGOORI,
              CON_VALEFRETE_DATAEMISSAO,
              CON_CATVALEFRETE_CODIGO,
              GLB_TPMOTORISTA_CODIGO,
              USU_USUARIO_CODIGO,
              CON_VALEFRETE_CONDESPECIAIS,
              USU_USUARIO_CODIGORTAPRESENT)
           VALUES
             (P_CON_CONHECIMENTO_CODIGO,
              P_CON_CONHECIMENTO_SERIE,
              P_CON_VIAGEM_NUMERO,
              P_GLB_ROTA_CODIGO,
              P_GLB_ROTA_CODIGOVIAGEM,
              V_SAQUE,
              P_CON_VALEFRETE_CONHECIMENTOS,
              P_CON_VALEFRETE_CARRETEIRO,
              P_CON_VALEFRETE_NFS,
              P_CON_VALEFRETE_PLACASAQUE,
              P_CON_VALEFRETE_TIPOTRANSPORTE,
              P_CON_VALEFRETE_PLACA,
              P_CON_VALEFRETE_LOCALCARREG,
              P_CON_VALEFRETE_LOCALDESCARGA,
              TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_KMPREVISTA, 0), ',', '.')),
              TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOINDICADO, 0), ',', '.')),
              TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_LOTACAO, 0), ',', '.')),
              TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOCOBRADO, 0), ',', '.')),
              trim(P_CON_VALEFRETE_ENTREGAS),
              TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_CUSTOCARRET, 0), ',', '.')),
              P_CON_VALEFRETE_TIPOCUSTO,
              TRUNC(SYSDATE),
              vEmissor,
              P_GLB_LOCALIDADE_CODIGODES,
              P_GLB_LOCALIDADE_CODIGOORI,
              NVL(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), TRUNC(SYSDATE)),
              lpad(P_CON_CATVALEFRETE_CODIGO,2,'0'),
              P_GLB_TPMOTORISTA_CODIGO,
              P_USU_USUARIO,
              SUBSTR(V_OBS,1,70),
              P_USU_USUARIO);
*/
 /*       when others then
          insert into t_glb_sql (glb_sql_dtgravacao,glb_sql_observacao, glb_sql_instrucao)
        values (sysdate,
                ,
                'SP_CON_INSERE_VALEFRETE ' || V_SAQUE  || chr(10) ||
            P_CON_CONHECIMENTO_CODIGO || chr(10) ||
            P_CON_CONHECIMENTO_SERIE || chr(10) ||
            P_CON_VIAGEM_NUMERO || chr(10) ||
            P_GLB_ROTA_CODIGO || chr(10) ||
            P_GLB_ROTA_CODIGOVIAGEM || chr(10) ||
            P_CON_VALEFRETE_SAQUE || chr(10) ||
            SUBSTR(P_CON_VALEFRETE_CONHECIMENTOS,1,60) || chr(10) ||
            TRIM(P_CON_VALEFRETE_CARRETEIRO) || chr(10) ||
            SUBSTR(P_CON_VALEFRETE_NFS,1,60) || chr(10) ||
            P_CON_VALEFRETE_PLACASAQUE || chr(10) ||
            P_CON_VALEFRETE_TIPOTRANSPORTE || chr(10) ||
            P_CON_VALEFRETE_PLACA || chr(10) ||
            SUBSTR(P_CON_VALEFRETE_LOCALCARREG,1,25) || chr(10) ||
            SUBSTR(P_CON_VALEFRETE_LOCALDESCARGA,1,25) || chr(10) ||
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_KMPREVISTA, 0), ',', '.')) || chr(10) ||
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOINDICADO, 0), ',', '.')) || chr(10) ||
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_LOTACAO, 0), ',', '.')) || chr(10) ||
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_PESOCOBRADO, 0), ',', '.')) || chr(10) ||
            TRIM(P_CON_VALEFRETE_ENTREGAS) || chr(10) ||
            TO_NUMBER(REPLACE(NVL(P_CON_VALEFRETE_CUSTOCARRET, 0), ',', '.')) || chr(10) ||
            P_CON_VALEFRETE_TIPOCUSTO || chr(10) ||
            TRUNC(SYSDATE) || chr(10) ||
            SUBSTR(P_CON_VALEFRETE_EMISSOR, 1,15) || chr(10) ||
            TRIM(P_GLB_LOCALIDADE_CODIGODES) || chr(10) ||
            TRIM(P_GLB_LOCALIDADE_CODIGOORI) || chr(10) ||
            NVL(SUBSTR(P_CON_VALEFRETE_DTEMISSAO,1,10), TRUNC(SYSDATE)) || chr(10) ||
            lpad(P_CON_CATVALEFRETE_CODIGO,2,'0') || chr(10) ||
            P_GLB_TPMOTORISTA_CODIGO || chr(10) ||
            P_USU_USUARIO || chr(10) ||
            SUBSTR(V_OBS,1,70)|| chr(10));
  */
       END;


     COMMIT;
   else
      raise_application_error(-20001,chr(13) ||
                                     '************************************************************' || chr(13) ||
                                     'Veiculo/Proprietario/Motorista com Bloqueio, ' || chr(13) ||
                                     'Consulte Ficha Carreteiro Placa ' || P_CON_VALEFRETE_PLACA || chr(13) ||
                                     'TpVeic - ' || P_GLB_TPMOTORISTA_CODIGO || '-' || to_char(v_bloqueios) || ' Bloqueios' || chr(13) ||
                                     'Categoria - ' || P_CON_CATVALEFRETE_CODIGO || chr(13) || 
                                     'Vale De Frete Código' || P_CON_CONHECIMENTO_CODIGO || chr(13) ||
                                     '************************************************************' || chr(13) ||
                                     sqlerrm || CHR(13) ||
                                     '************************************************************' || chr(13));
   end if;
 --  EXECUTE IMMEDIATE ('ALTER SESSION SET OPTIMIZER_MODE=CHOOSE');
 End SP_CON_INSERE_VALEFRETE;



  PROCEDURE SP_CON_INSERE_VFRETECONHEC(P_CON_VALEFRETE_CODIGO     CHAR,
                                       P_CON_VALEFRETE_SERIE      CHAR,
                                       P_GLB_ROTA_CODIGOVALEFRETE CHAR,
                                       P_CON_VALEFRETE_SAQUE      CHAR,
                                       P_GLB_ROTA_CODIGO          CHAR,
                                       P_CON_CONHECIMENTO_CODIGO  CHAR,
                                       P_CON_CONHECIMENTO_SERIE   CHAR,
                                       P_CON_CONHECIMENTO_PLACA   CHAR DEFAULT NULL) IS

 /*  CURSOR C_CONHECIMENTO IS
     SELECT A.CON_CONHECIMENTO_CODIGO,
            A.CON_CONHECIMENTO_SERIE,
            A.GLB_ROTA_CODIGO
       FROM T_CON_CONHECIMENTO A
      WHERE A.CON_CONHECIMENTO_PLACA = P_CON_CONHECIMENTO_PLACA
        AND A.CON_CONHECIMENTO_SERIE <> 'XXX'
        AND A.CON_VALEFRETE_CODIGO IS NULL
        -- INCLUIDO PARA EVITAR DUPLICIDADE DE CTRC NA VFRETECONHEC
        -- SIRLANO 06/07/2010
        AND 0 = (SELECT COUNT(*)
                 FROM T_CON_VFRETECONHEC VFC
                 WHERE VFC.CON_VALEFRETE_CODIGO = P_CON_VALEFRETE_CODIGO
                   AND VFC.CON_VALEFRETE_SERIE = P_CON_VALEFRETE_SERIE
                   AND VFC.GLB_ROTA_CODIGOVALEFRETE = P_GLB_ROTA_CODIGOVALEFRETE
                   AND VFC.CON_VALEFRETE_SAQUE = P_CON_VALEFRETE_SAQUE
                   AND VFC.CON_CONHECIMENTO_CODIGO = A.CON_CONHECIMENTO_CODIGO
                   AND VFC.CON_CONHECIMENTO_SERIE = A.CON_CONHECIMENTO_SERIE
                   AND VFC.GLB_ROTA_CODIGO = A.GLB_ROTA_CODIGO)
        AND A.CON_CONHECIMENTO_DTEMBARQUE =
            (SELECT B.CON_CONHECIMENTO_DTEMBARQUE
               FROM T_CON_CONHECIMENTO B
              WHERE B.CON_CONHECIMENTO_CODIGO = P_CON_CONHECIMENTO_CODIGO
                AND B.CON_CONHECIMENTO_SERIE = P_CON_CONHECIMENTO_SERIE
                AND B.GLB_ROTA_CODIGO = P_GLB_ROTA_CODIGO);
   R_CONHECIMENTO C_CONHECIMENTO%ROWTYPE;
 */

   CURSOR C_NFTRANSPORTA(p_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                         p_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                         p_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) IS
   SELECT NFT.CON_CONHECIMENTO_CODIGO,
          NFT.CON_CONHECIMENTO_SERIE,
          NFT.GLB_ROTA_CODIGO,
          NFT.CON_NFTRANSPORTADA_NUMNFISCAL,
          NFT.GLB_CLIENTE_CGCCPFCODIGO
   FROM T_CON_NFTRANSPORTA NFT,
        T_CON_CONHECIMENTO CT,
        T_GLB_CLIENTE CL,
        T_GLB_CLIENTE CLD
   WHERE NFT.CON_CONHECIMENTO_CODIGO = p_CTRC
     AND NFT.CON_CONHECIMENTO_SERIE  = p_SERIE
     AND NFT.GLB_ROTA_CODIGO         = p_ROTA
     AND NFT.CON_CONHECIMENTO_CODIGO = CT.CON_CONHECIMENTO_CODIGO
     AND NFT.CON_CONHECIMENTO_SERIE  = CT.CON_CONHECIMENTO_SERIE
     AND NFT.GLB_ROTA_CODIGO         = CT.GLB_ROTA_CODIGO
     AND CT.GLB_CLIENTE_CGCCPFDESTINATARIO = CLD.GLB_CLIENTE_CGCCPFCODIGO
 --    AND CLD.GLB_GRUPOECONOMICO_CODIGO = '0020'
     AND CT.CON_CONHECIMENTO_LOCALCOLETA <> CT.CON_CONHECIMENTO_LOCALENTREGA
     AND NFT.GLB_CLIENTE_CGCCPFCODIGO = CL.GLB_CLIENTE_CGCCPFCODIGO
     AND CL.GLB_CLIENTE_NOTAIMG = 'S'
     AND COLETA.PKG_WEB_VISUALIMAGEM.fn_retornaLinkNOTA(NFT.CON_NFTRANSPORTADA_NUMNFISCAL, NFT.GLB_CLIENTE_CGCCPFCODIGO) = 'http://extranet.dellavolpe.com.br'
   --  ;
     AND (SELECT COUNT(*)
            FROM T_ARM_NOTA N
           WHERE LPAD(N.ARM_NOTA_NUMERO,9,'0')              = LPAD(NFT.CON_NFTRANSPORTADA_NUMNFISCAL,9,'0')
             AND RPAD(N.GLB_CLIENTE_CGCCPFREMETENTE,20,' ') = NFT.GLB_CLIENTE_CGCCPFCODIGO
             AND N.CON_CONHECIMENTO_CODIGO                  = NFT.CON_CONHECIMENTO_CODIGO
             AND N.CON_CONHECIMENTO_SERIE                   = NFT.CON_CONHECIMENTO_SERIE
             AND N.GLB_ROTA_CODIGO                          = NFT.GLB_ROTA_CODIGO) >= 1;



   V_NFSEMIMG  VARCHAR2(2000);
   v_rotausuvf  t_glb_rota.glb_rota_codigo%TYPE;
   V_PEDEIMG  CHAR(1);
   V_MENORSQ  T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
   V_CTRCCANCELADO T_CON_CONHECIMENTO.CON_CONHECIMENTO_FLAGCANCELADO%TYPE;
   V_ROTACSCN  T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;

   vNotaEletr Char(1);
 BEGIN
   --     EXECUTE IMMEDIATE('ALTER SESSION SET OPTIMIZER_MODE=RULE');

   -- FABIANO: 04/12/2009 -----------------------------------------------------------------------------------
   -- IMPEDIR QUE SEJA INSERIDO NO VALE DE FRETE CONHECIMENTOS CANCELADOS....................................
   BEGIN
         SELECT CON.CON_CONHECIMENTO_FLAGCANCELADO
           INTO V_CTRCCANCELADO
           FROM T_CON_CONHECIMENTO CON
          WHERE CON.CON_CONHECIMENTO_CODIGO = P_CON_CONHECIMENTO_CODIGO
            AND CON.CON_CONHECIMENTO_SERIE = P_CON_CONHECIMENTO_SERIE
            AND CON.GLB_ROTA_CODIGO = P_GLB_ROTA_CODIGO;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          V_CTRCCANCELADO := 'N';
   END;

   IF NVL(V_CTRCCANCELADO, 'N') = 'S' THEN
      RAISE_APPLICATION_ERROR(-20001, chr(13) ||
                                      '*******************************************************' || chr(13) ||
                                      'CTRC CANCELADO NÃO PODE SER INSERIDO NO VALE DE FRETE! ' || CHR(13) ||
                                      'CTRC: ' || P_CON_CONHECIMENTO_CODIGO || CHR(13) ||
                                      'SERIE: ' || P_CON_CONHECIMENTO_SERIE || CHR(13) ||
                                      'ROTA: ' || P_GLB_ROTA_CODIGO || chr(13) ||
                                      '*******************************************************' || chr(13));

  END IF;
   ----------------------------------------------------------------------------------------------------------

   -- VERIFICA AS IMAGENS

   -- VERIFICAR SE E O PRIMEIRO VALE DE FRETE DO CTRC/NOTA
 --  V_PEDEIMG := 'N';



   BEGIN
     /*Rogerio / Sirlano dia 18/10/2011,
       foi mudado a condição do select, para buscar o último saque valido não impresso.

       essa mudança foi realizada para não pedir a imagem da Nota Fiscal, mesmo que o vale seja feito fora do FIFO.
     */
       SELECT MIN(VF.CON_VALEFRETE_SAQUE)
         INTO V_MENORSQ
       FROM T_CON_VALEFRETE VF
       WHERE VF.CON_CONHECIMENTO_CODIGO = P_CON_VALEFRETE_CODIGO
         AND VF.CON_CONHECIMENTO_SERIE  = P_CON_VALEFRETE_SERIE
         AND VF.GLB_ROTA_CODIGO         = P_GLB_ROTA_CODIGOVALEFRETE
         AND NVL(VF.CON_VALEFRETE_STATUS,'N') = 'N'
         AND NVL(VF.CON_VALEFRETE_IMPRESSO,'N') = 'N';

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, chr(13) ||
                                      '******************************************' || chr(13) ||
                                      'NÃO FOI ENCONTRADO O VALE DE FRETE ABAIXO ' || CHR(13) ||
                                      'VFRETE: ' || P_CON_VALEFRETE_CODIGO         || CHR(13) ||
                                      'SERIE : ' || P_CON_VALEFRETE_SERIE          || CHR(13) ||
                                      'ROTA  : ' || P_GLB_ROTA_CODIGOVALEFRETE     || chr(13) ||
                                      '******************************************' || chr(13));
      V_MENORSQ := '000';
    END;


   IF P_CON_VALEFRETE_SAQUE = V_MENORSQ THEN

      BEGIN
         SELECT P.USU_PERFIL_PARAT
           INTO V_ROTACSCN
         FROM T_USU_PERFIL P
         WHERE P.USU_PERFIL_CODIGO = 'ROTACOMIMG' ;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         V_ROTACSCN := '';
      END;

      -- Verifico se a Rota que está emitindo o Vale de frete, está no paramentro de solicitação de Imagem.
      IF nvl(INSTR(V_ROTACSCN,P_GLB_ROTA_CODIGOVALEFRETE),0) > 0 THEN
         V_PEDEIMG := 'S';

     ELSE
         V_PEDEIMG := 'N';
      END IF;

  END IF;

   V_NFSEMIMG := 'FALTAM IMG NF ' || CHR(13);

   --Se não for rota de Notafiscal ou Rota de Frota
   IF (P_GLB_ROTA_CODIGOVALEFRETE < '900' ) AND
      (P_GLB_ROTA_CODIGOVALEFRETE > '015')  AND
      ( V_PEDEIMG = 'S' ) THEN

       --Abro o cursor passando o Conhecimento, Serie e Rota como parametro, para saber se tem alguma nota sem imagem.
       FOR R_NFTRANSPORTA IN C_NFTRANSPORTA( P_CON_CONHECIMENTO_CODIGO,
                                             P_CON_CONHECIMENTO_SERIE,
                                             P_GLB_ROTA_CODIGO
                                            )
       Loop


         /*Select
          n.arm_nota_nf_e Into vNotaEletr

        From
           T_ARM_NOTA N
         Where
          0 < ( Select Count(*) From t_con_conhecimento c
                Where c.con_conhecimento_codigo = n.con_conhecimento_codigo
                 And c.con_conhecimento_serie = n.con_conhecimento_serie
                 And c.glb_rota_codigo = n.glb_rota_codigo
                 And c.con_conhecimento_codigo = P_CON_CONHECIMENTO_CODIGO
                 And c.con_conhecimento_serie = P_CON_CONHECIMENTO_SERIE
                 And c.glb_rota_codigo = P_GLB_ROTA_CODIGO
              );

           If Trim(vNotaEletr) <> 'S' Then     */

             --Guarda na variável v_nfsemimg relação das notas sem imagens encontradas pelo cursor.
             V_NFSEMIMG := V_NFSEMIMG || 'NF-'||R_NFTRANSPORTA.CON_NFTRANSPORTADA_NUMNFISCAL || '-CNPJ-' ||  f_mascara_cgccpf(TRIM(R_NFTRANSPORTA.GLB_CLIENTE_CGCCPFCODIGO)) || CHR(13);
             V_NFSEMIMG := V_NFSEMIMG || P_CON_CONHECIMENTO_CODIGO || ' - ' ||  P_CON_CONHECIMENTO_SERIE || ' - ' ||  P_GLB_ROTA_CODIGO;


 --          End If;

       END LOOP;

       --Encerrado o loop, caso a variável tenha recebido algum valor, mostro na tela relação de notas sem imagem.
       IF LENGTH(TRIM(V_NFSEMIMG)) > 20 THEN
          RAISE_APPLICATION_ERROR(-20002, TRIM(V_NFSEMIMG));
       END IF;

   END IF;

   IF P_CON_CONHECIMENTO_PLACA IS NULL THEN


    BEGIN
     INSERT INTO T_CON_VFRETECONHEC
       (CON_VALEFRETE_CODIGO,
        CON_VALEFRETE_SERIE,
        GLB_ROTA_CODIGOVALEFRETE,
        CON_VALEFRETE_SAQUE,
        GLB_ROTA_CODIGO,
        CON_CONHECIMENTO_CODIGO,
        CON_CONHECIMENTO_SERIE)
     VALUES
       (P_CON_VALEFRETE_CODIGO,
        P_CON_VALEFRETE_SERIE,
        P_GLB_ROTA_CODIGOVALEFRETE,
        P_CON_VALEFRETE_SAQUE,
        P_GLB_ROTA_CODIGO,
        P_CON_CONHECIMENTO_CODIGO,
        P_CON_CONHECIMENTO_SERIE);
     EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          -- SO PARA CONSTAR E NÃO FAZER NADA
          -- SIRLANO 06/07/2010
          V_CTRCCANCELADO := V_CTRCCANCELADO;
        END;

     UPDATE T_CON_CONHECIMENTO
        SET CON_VALEFRETE_CODIGO     = P_CON_VALEFRETE_CODIGO,
            CON_VALEFRETE_SERIE      = P_CON_VALEFRETE_SERIE,
            GLB_ROTA_CODIGOVALEFRETE = P_GLB_ROTA_CODIGOVALEFRETE,
            CON_VALEFRETE_SAQUE      = P_CON_VALEFRETE_SAQUE
      WHERE CON_CONHECIMENTO_CODIGO = P_CON_CONHECIMENTO_CODIGO
        AND CON_CONHECIMENTO_SERIE = P_CON_CONHECIMENTO_SERIE
        AND GLB_ROTA_CODIGO = P_GLB_ROTA_CODIGO
        AND CON_VALEFRETE_CODIGO IS NULL
        AND CON_VALEFRETE_SERIE IS NULL
        AND GLB_ROTA_CODIGOVALEFRETE IS NULL
        AND CON_VALEFRETE_SAQUE IS NULL;
  /*  ELSE
     OPEN C_CONHECIMENTO;
            IF C_CONHECIMENTO%ROWCOUNT > 0 THEN
               IF SUBSTR(P_CON_CONHECIMENTO_PLACA,1,2) = 'A0' THEN
                   BEGIN
                        SELECT FRT_VEICULO_PLACA
                        INTO   P_CON_CONHECIMENTO_PLACA2
                        FROM   T_FRT_VEICULO
                        WHERE  FRT_VEICULO_CODIGO = P_CON_CONHECIMENTO_PLACA;
                   EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                           P_CON_CONHECIMENTO_PLACA2 := P_CON_CONHECIMENTO_PLACA;
                   END;
               ELSE
                   IF  SUBSTR(P_CON_CONHECIMENTO_PLACA,1,2) = '00' THEN
                     BEGIN
                         SELECT FRT_VEICULO_PLACA
                         INTO   P_CON_CONHECIMENTO_PLACA2
                         FROM   T_FRT_VEICULO
                         WHERE  FRT_VEICULO_CODIGO = P_CON_CONHECIMENTO_PLACA;
                     EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                               P_CON_CONHECIMENTO_PLACA2 := P_CON_CONHECIMENTO_PLACA;
                     END;
                   ELSE
                     BEGIN
                         SELECT FRT_VEICULO_CODIGO
                         INTO   P_CON_CONHECIMENTO_PLACA2
                         FROM   T_FRT_VEICULO
                         WHERE  FRT_VEICULO_PLACA = P_CON_CONHECIMENTO_PLACA;
                     EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                               P_CON_CONHECIMENTO_PLACA2 := P_CON_CONHECIMENTO_PLACA;
                     END;
                   END IF;
               END IF;
            END IF;
            CLOSE C_CONHECIMENTO;
            FOR R_CONHECIMENTO IN C_CONHECIMENTO LOOP
                 UPDATE T_CON_CONHECIMENTO
                 SET CON_VALEFRETE_CODIGO      = P_CON_VALEFRETE_CODIGO
                    ,CON_VALEFRETE_SERIE       = P_CON_VALEFRETE_SERIE
                    ,GLB_ROTA_CODIGOVALEFRETE  = P_GLB_ROTA_CODIGOVALEFRETE
                    ,CON_VALEFRETE_SAQUE       = P_CON_VALEFRETE_SAQUE
                 WHERE CON_CONHECIMENTO_CODIGO = R_CONHECIMENTO.CON_CONHECIMENTO_CODIGO
                   AND CON_CONHECIMENTO_SERIE  = R_CONHECIMENTO.CON_CONHECIMENTO_SERIE
                   AND GLB_ROTA_CODIGO         = R_CONHECIMENTO.GLB_ROTA_CODIGO;
                 INSERT INTO T_CON_VFRETECONHEC VALUES(P_CON_VALEFRETE_CODIGO,
                                                       P_CON_VALEFRETE_SERIE,
                                                       P_GLB_ROTA_CODIGOVALEFRETE,
                                                       P_CON_VALEFRETE_SAQUE,
                                                       R_CONHECIMENTO.GLB_ROTA_CODIGO,
                                                       R_CONHECIMENTO.CON_CONHECIMENTO_CODIGO,
                                                       R_CONHECIMENTO.CON_CONHECIMENTO_SERIE,
                                                       NULL,
                                                       NULL,
                                                       NULL,
                                                       NULL,
                                                       NULL,
                                                       null,
                                                       null);
                                                      -- aqui tem sirlano
             END LOOP;

     close C_CONHECIMENTO;
 */

  END IF;

  COMMIT;
   --    EXECUTE IMMEDIATE('ALTER SESSION SET OPTIMIZER_MODE=CHOOSE');
 End SP_CON_INSERE_VFRETECONHEC;



  PROCEDURE SP_CON_VFRETEANTERIOR(PCON_VALEFRETE_CODIGO        CHAR,
                                  PCON_VALEFRETE_SERIE         CHAR,
                                  PGLB_ROTA_CODIGOVALEFRETE    CHAR,
                                  PCON_VALEFRETE_SAQUEANTERIOR CHAR,
                                  PCON_VALEFRETE_SAQUEATUAL    CHAR) AS
   CURSOR C_VFRETECONHEC IS
     SELECT CON_CONHECIMENTO_CODIGO, 
            CON_CONHECIMENTO_SERIE, 
            GLB_ROTA_CODIGO,
            con_vfreteconhec_transfchekin,
            arm_armazem_codigo
       FROM T_CON_VFRETECONHEC
      WHERE CON_VALEFRETE_CODIGO = PCON_VALEFRETE_CODIGO
        AND CON_VALEFRETE_SERIE = PCON_VALEFRETE_SERIE
        AND GLB_ROTA_CODIGOVALEFRETE = PGLB_ROTA_CODIGOVALEFRETE
        AND CON_VALEFRETE_SAQUE = PCON_VALEFRETE_SAQUEANTERIOR;
   vTransferencia varchar2(20);
   vEmissao       date;
   R_VFRETECONHEC C_VFRETECONHEC%rowtype;
   V_SQL_TEXTO    VARCHAR(2000);
   vMaquina       v_glb_ambiente.terminal%type;
   vUsuario       v_glb_ambiente.os_user%type;
   vCategoria     t_con_valefrete.con_catvalefrete_codigo%type;
 BEGIN
   select a.terminal,
          a.os_user
     into vMaquina,
          vUsuario
   from v_glb_ambiente a;

   --EXECUTE IMMEDIATE('ALTER SESSION SET OPTIMIZER_MODE=RULE');

   select v.con_valefrete_dataemissao
     into vEmissao
   from t_con_valefrete v
   where v.con_conhecimento_codigo = PCON_VALEFRETE_CODIGO
     and v.con_conhecimento_serie = PCON_VALEFRETE_SERIE
     and v.glb_rota_codigo = PGLB_ROTA_CODIGOVALEFRETE
     and v.con_valefrete_saque = PCON_VALEFRETE_SAQUEATUAL ;


   FOR R_VFRETECONHEC IN C_VFRETECONHEC LOOP
     if vCategoria not in (CatTBonusCTRC , CatTBonusManifesto) then
         INSERT INTO T_CON_VFRETECONHEC
         VALUES
           (PCON_VALEFRETE_CODIGO,
            PCON_VALEFRETE_SERIE,
            PGLB_ROTA_CODIGOVALEFRETE,
            PCON_VALEFRETE_SAQUEATUAL,
            R_VFRETECONHEC.GLB_ROTA_CODIGO,
            R_VFRETECONHEC.CON_CONHECIMENTO_CODIGO,
            R_VFRETECONHEC.CON_CONHECIMENTO_SERIE,

           NULL,

           NULL,

           0,

           0,

           0,

           0,

           0,

           NULL,

           0,
            sysdate,
            substr(trim(vMaquina) ||'-' || trim(vUsuario),1,50),
            substr(PKG_CON_VALEFRETE.fn_get_embtransferencia2(R_VFRETECONHEC.CON_CONHECIMENTO_CODIGO,
                                                              R_VFRETECONHEC.CON_CONHECIMENTO_SERIE,
                                                              R_VFRETECONHEC.GLB_ROTA_CODIGO,
                                                              trunc(vEmissao),'T'),1,15),
            substr(PKG_CON_VALEFRETE.fn_get_embtransferencia2(R_VFRETECONHEC.CON_CONHECIMENTO_CODIGO,
                                                              R_VFRETECONHEC.CON_CONHECIMENTO_SERIE,
                                                              R_VFRETECONHEC.GLB_ROTA_CODIGO,
                                                              trunc(vEmissao),'A'),1,15));

    else
     INSERT INTO T_CON_VFRETECONHEC
         VALUES
           (PCON_VALEFRETE_CODIGO,
            PCON_VALEFRETE_SERIE,
            PGLB_ROTA_CODIGOVALEFRETE,
            PCON_VALEFRETE_SAQUEATUAL,
            R_VFRETECONHEC.GLB_ROTA_CODIGO,
            R_VFRETECONHEC.CON_CONHECIMENTO_CODIGO,
            R_VFRETECONHEC.CON_CONHECIMENTO_SERIE,

           NULL,

           NULL,

           0,

           0,

           0,

           0,

           0,

           NULL,

           0,
            sysdate,
            substr(trim(vMaquina) ||'-' || trim(vUsuario),1,50),
            R_VFRETECONHEC.CON_VFRETECONHEC_TRANSFCHEKIN,
            R_VFRETECONHEC.ARM_ARMAZEM_CODIGO);
    end if;
   END LOOP;
 End SP_CON_VFRETEANTERIOR;

 FUNCTION FN_VERIFICA_DUPLANC_CX(ptpMovimento tdvadm.t_cax_movimento%rowtype)
    RETURN CHAR
   Is
    vAuxiliar number;
    vData  tdvadm.t_cax_movimento.cax_boletim_data%type;
    vRota  tdvadm.t_Cax_Movimento.glb_rota_codigo%type;
    vSeq   tdvadm.t_cax_movimento.cax_movimento_sequencia%type;
 Begin
   
    If ptpMovimento.Cax_Operacao_Codigo <> '1200' Then
       Begin
           select m.glb_rota_codigo,
                  m.cax_boletim_data,
                  m.cax_movimento_sequencia
              into vRota,
                   vData,
                   vSeq
           from tdvadm.t_cax_movimento m
           where m.cax_operacao_codigo          = ptpMovimento.Cax_Operacao_Codigo
             and m.cax_movimento_documento      = ptpMovimento.Cax_Movimento_Documento
             and m.glb_rota_codigo_referencia   = ptpMovimento.glb_rota_codigo_referencia
             and m.cax_movimento_serie          = ptpMovimento.cax_movimento_serie
             and m.cax_movimento_doccomplemento = ptpMovimento.cax_movimento_doccomplemento
    --         and m.glb_tpdoc_codigo             = ptpMovimento.Glb_Tpdoc_Codigo
             and m.cax_movimento_valor          = ptpMovimento.cax_movimento_valor;
             tpMovimento.Glb_Rota_Codigo := vRota;
             tpMovimento.Cax_Boletim_Data := vData;
             tpMovimento.Cax_Movimento_Sequencia := vSeq;
             Return 'S';
        Exception
          When NO_DATA_FOUND Then
              Return 'N';
          End;
    Else
       select count(*)
         into vAuxiliar
       from tdvadm.t_cax_movimento m
       where m.cax_operacao_codigo          = ptpMovimento.Cax_Operacao_Codigo
         and m.cax_movimento_documento      = ptpMovimento.Cax_Movimento_Documento
--         and m.glb_rota_codigo_referencia   = ptpMovimento.glb_rota_codigo_referencia
--         and m.cax_movimento_serie          = ptpMovimento.cax_movimento_serie
--         and m.cax_movimento_doccomplemento = ptpMovimento.cax_movimento_doccomplemento
         and m.cax_movimento_documentoref   = ptpMovimento.Cax_Movimento_Documentoref
--         and m.glb_tpdoc_codigo             = ptpMovimento.Glb_Tpdoc_Codigo
         and m.cax_movimento_valor          = ptpMovimento.cax_movimento_valor;
       
     End If;
     
  If vAuxiliar > 0 Then
     Return 'S';
  Else
     return 'N';
  End If;
     
 End FN_VERIFICA_DUPLANC_CX;



 PROCEDURE SP_CON_FRETECAIXA(P_ROTA    IN CHAR,
                             P_DATALANCAMENTO IN CHAR,
                             P_DATAPROCESSAMENTO IN CHAR,
                             P_COMMIT  IN CHAR DEFAULT 'N',
                             P_HORARIOCORTE IN CHAR DEFAULT 'N',
                             P_REVERTE IN CHAR DEFAULT 'N')
   As
  VFNumero             tdvadm.t_con_valefrete.con_conhecimento_codigo%type;
  VFSerie              tdvadm.t_con_valefrete.con_conhecimento_serie%type;
  VFRota               tdvadm.t_con_valefrete.glb_rota_codigo%type;
  VFSaque              tdvadm.t_con_valefrete.con_valefrete_saque%type;
  VFAcao               varchar2(15);
  VFusuarioTDV         tdvadm.t_usu_usuario.usu_usuario_codigo%type;
  VFRotaUsuarioTDV     tdvadm.t_glb_rota.glb_rota_codigo%type;
  VFAplicacaoTDV       tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type;
  VFVersaoAplicao      tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
  vImpressao           tdvadm.t_con_valefrete.con_valefrete_impresso%type;
  vStatus              tdvadm.t_con_valefrete.con_valefrete_status%type;
  vAcerto              tdvadm.t_con_valefrete.acc_acontas_numero%type;
  vAtivos              tdvadm.t_con_valefrete.con_valefrete_berconf%type;
  vVazio               tdvadm.t_con_valefrete.frt_movvazio_numero%type;
  vCaixa               tdvadm.t_con_valefrete.cax_boletim_data%type;
  vCIOT                tdvadm.t_con_vfreteciot.con_vfreteciot_numero%type;
  vSolCIOT             char(1);
  vOBS                 tdvadm.t_con_valefrete.con_valefrete_obs%type;
  vteste               varchar2(1000);
  vValorPed            tdvadm.t_con_calcvalefrete.con_calcvalefrete_valor%type;
  vNrCartao            tdvadm.t_con_calcvalefrete.con_calcvalefrete_cartao%type;
  vHorarioCorte        char(8);
  vStatusBoletim       tdvadm.t_cax_boletim.cax_boletim_status%type;
  vFiltro              char(14);
  TpBoletim            tdvadm.t_cax_boletim%rowtype;
  vOcorreuErro         char(1);
  vInsereMov           char(1);
  vAuxiliar            number;
  vVfFrota             boolean := false;
  vQtdeVgmFrt          integer := 0;
  vStatusMR            char(1);
  vMessageMR           varchar2(2000);
  vSaque               t_con_valefrete.con_valefrete_saque%type;
  vPrimeiroSaque       boolean := false;
  vValorTarifa         NUMBER;
  vAchouDup            char(1) := 'N';
 Begin
   
   vOcorreuErro  := 'N';
   vInsereMov    := 'S';

   /********************************************************/
   /**    DEFININDO PARAMETROS PARA LANÇAMENTO DO CAIXA   **/
   /********************************************************/
   begin
     
     if P_HORARIOCORTE = 'S' Then
        vHorarioCorte := '15:30:00';
        vFiltro := to_char(to_date(P_DATAPROCESSAMENTO,'dd/mm/yyyy'),'yyyymmdd') || '153000';
      Else
        vHorarioCorte := '23:59:00';
        vFiltro := to_char(to_date(P_DATAPROCESSAMENTO,'dd/mm/yyyy'),'yyyymmdd') || '235900';
     End If;


     Begin
       
       select bo.cax_boletim_status
         into vStatusBoletim
         from t_cax_boletim bo
        where bo.glb_rota_codigo  = P_ROTA
          and bo.cax_boletim_data = TO_DATE(P_DATALANCAMENTO,'DD/MM/YYYY');

      exception when NO_DATA_FOUND Then
        
        if (vOcorreuErro = 'N') Then

             select *
               into TpBoletim
               from t_cax_boletim bo
              where bo.glb_rota_codigo  = P_ROTA
                and bo.cax_boletim_data = (select max(bo1.cax_boletim_data)
                                             from t_cax_boletim bo1
                                            where bo1.glb_rota_codigo = bo.glb_rota_codigo
                                              and bo1.cax_boletim_data < TO_DATE(P_DATALANCAMENTO,'DD/MM/YYYY'));

             if to_char(TpBoletim.Cax_Boletim_Data,'yyyy') = TO_char(to_date(P_DATALANCAMENTO,'dd/mm/yyyy'),'YYYY') Then
               
                TpBoletim.Cax_Boletim_Codigo := lpad(to_number(TpBoletim.Cax_Boletim_Codigo) + 1,3,'0');
             
             Else
                
                TpBoletim.Cax_Boletim_Codigo := '001';
             
             End if;

             TpBoletim.Cax_Boletim_Data         := TO_DATE(P_DATALANCAMENTO,'DD/MM/YYYY');
             TpBoletim.Cax_Boletim_Tentradas    := 0;
             TpBoletim.Cax_Boletim_Tsaidas      := 0;
             TpBoletim.Cax_Boletim_Santerior    := 0;
             TpBoletim.Cax_Boletim_Satual       := 0;
             TpBoletim.Cax_Boletim_Status       := 'E';
             TpBoletim.Cax_Boletim_Soeletronico := 'S';


             INSERT INTO t_cax_boletim bo VALUES TpBoletim;


             vStatusBoletim := 'E';

        Else
          
          vStatusBoletim := 'E';
        
        End if;

      end;

   end;
   /********************************************************/
   
   /********************************************************/
   /**    REALIZANDO O PROCESSAMENTO                      **/
   /********************************************************/
   begin
     
     If (P_REVERTE = 'N') then
       

       /********************************************************/
       /**    CURSOR COM OS FRETES PAGAR A SEREM LANÇADOS     **/
       /********************************************************/

       begin

         For R_CURSOR IN(Select c.con_conhecimento_codigo        vf,
                                c.glb_rota_codigo                rt,
                                c.con_conhecimento_serie         serie,
                                c.con_valefrete_saque            saque,
                                c.glb_rota_codigocx              rtcx,
                                c.con_calcvalefrete_valor        valor,
                                c.con_calcvalefrete_tipo         tipopgto,
                                c.con_calcvalefrete_seq          seq,
                                c.con_calcvalefrete_codparoper   codpar,
                                tp.con_calcvalefretetp_codigo    cod,
                                tp.con_calcvalefretetp_descricao Descri,
                                c.usu_usuario_codigoliberou      usulib,
                                c.glb_rota_codigolib             rtlib,
                                c.usu_usuario_codigopgto         usupgto,
                                c.con_calcvalefrete_dtpgto       dtpgto,
                                c.glb_rota_codigopgto            rtpgto,
                                c.usu_usuario_bloqueou           usublq,
                                c.glb_rota_codigobloqueou        rtblq,
                                c.con_calcvalefrete_cnpjcpf      quemrecebeu,
                                c.con_calcvalefrete_cartao       cartao,
                                vf.con_valefrete_placa           placa,
                                vf.glb_tpmotorista_codigo        tp_motorista,
                                VF.CON_VALEFRETE_CARRETEIRO      quemrecebeu_frota,
                                c.GLB_ROTA_CODIGOCX              rota_pgto,
                                c.rowid                          
                           From t_con_valefrete vf,
                                t_con_calcvalefrete c,
                                t_con_calcvalefretetp tp
                          Where 0 = 0
                            And vf.con_conhecimento_codigo     = c.con_conhecimento_codigo
                            And vf.con_conhecimento_serie      = c.con_conhecimento_serie
                            And vf.glb_rota_codigo             = c.glb_rota_codigo
                            And vf.con_valefrete_saque         = c.con_valefrete_saque
                            And c.con_calcvalefretetp_codigo   = tp.con_calcvalefretetp_codigo
                            -- 05/11/2021 - Sirlano / Vinicius Rezende
                            -- Icluido o tipo 02 Pedagio para pegar pedagio 
                            -- que não estao no caixa
                            And tp.con_calcvalefretetp_codigo in ('01',/*'02',*/'06','07','20')
                            and nvl(vf.con_valefrete_status,'N') <> 'C'
                            And c.con_calcvalefrete_valor      > 0
                            And C.CON_CALCVALEFRETE_TIPO       = 'C'
                            And nvl(C.GLB_ROTA_CODIGOCX,'999') <> '999'
--                            and c.con_conhecimento_codigo = '175166'
                            AND C.con_calcvalefrete_dtpgto     IS NOT NULL
                            And c.con_conhecimento_codigo || c.con_conhecimento_serie || c.glb_rota_codigo ||  c.con_valefrete_saque <> '01702710231'
                            And C.GLB_ROTA_CODIGOCX           = P_ROTA
                            -- 05/11/2021 - Sirlano / Vinicius Rezende
                            -- Controle para ver se pedagio ja foi lancado no caixa
                           /* and case tp.con_calcvalefretetp_codigo 
                                  when '02' Then (select count(*)
                                                  from tdvadm.t_cax_movimento m
                                                  where m.cax_movimento_documentoref = c.con_conhecimento_codigo || c.con_conhecimento_serie || c.glb_rota_codigo ||  c.con_valefrete_saque
                                                    and m.glb_tpdoc_codigo = 'VFP') 
                                  Else 0
                                end = 0*/
                            and c.cax_boletim_data is null
                            and trunc(c.con_calcvalefrete_dtpgto) >= to_date('01/01/2016','dd/mm/yyyy')
                            And to_char(c.con_calcvalefrete_dtpgto,'yyyymmddhh24miss') <= vFiltro
                            
/*                            And 0 = (SELECT COUNT(*)
                                       FROM T_CAX_MOVIMENTO M
                                      WHERE M.CAX_MOVIMENTO_DOCUMENTO            = RPAD(C.CON_CONHECIMENTO_CODIGO,10)
                                        AND trim(M.CAX_MOVIMENTO_SERIE)          = TRIM(C.CON_CONHECIMENTO_SERIE)
                                        AND M.GLB_ROTA_CODIGO_REFERENCIA         = C.GLB_ROTA_CODIGO
                                        AND TRIM(M.CAX_MOVIMENTO_DOCCOMPLEMENTO) = C.CON_VALEFRETE_SAQUE
                                        AND M.CAX_OPERACAO_CODIGO                = PKG_CON_VALEFRETE.Fn_RetornaOperacao(vf.con_conhecimento_codigo, 
                                                                                                                        vf.con_conhecimento_serie, 
                                                                                                                        vf.glb_rota_codigo, 
                                                                                                                        vf.con_valefrete_saque, 
                                                                                                                        c.con_calcvalefretetp_codigo,
                                                                                                                        c.GLB_ROTA_CODIGOCX, 
                                                                                                                        'S'))
*/                           And 'S' = PKG_CON_VALEFRETE.Fn_VerificaProcessamento(vf.con_conhecimento_codigo, 
                                                                                  vf.con_conhecimento_serie, 
                                                                                  vf.glb_rota_codigo, 
                                                                                  vf.con_valefrete_saque, 
                                                                                  c.con_calcvalefretetp_codigo,
                                                                                  c.GLB_ROTA_CODIGOCX, 
                                                                                  'S')
                                                                                                                        


                       order by c.con_calcvalefrete_dtpgto,
                                tp.con_calcvalefretetp_codigo)
           Loop
             vAchouDup := 'N';
               
             if r_cursor.vf || r_cursor.rt = '006032060' Then
                r_cursor.vf := r_cursor.vf;
             End If;
             
             /********************************************************/
             /***        ANALISE PARA SABER SE É FROTA             ***/
             /********************************************************/

             begin

                if ((substr(trim(r_cursor.placa),1,3) = '000') and (nvl(trim(r_cursor.tp_motorista),'N') = 'F')) then

                  vVfFrota := true;

                else

                  vVfFrota      := false;
                  vInsereMov    := 'N';
                  vInsereOp2948 := 'N';

                end if;


            end;

             /********************************************************/

             /********************************************************/
             /*** CONTADO A QUANTIDADE DE VIAGEM QUE AQUELE VF TEM ***/
             /********************************************************/

             begin

               -- Quantidade de documentos
               select count(*)
                 into vQtdeVgmFrt
                 from t_con_vfreteciot cc
                where cc.con_conhecimento_codigo = R_CURSOR.VF
                  and cc.con_conhecimento_serie  = R_CURSOR.SERIE
                  and cc.glb_rota_codigo         = R_CURSOR.RT
                  and cc.con_vfreteciot_numero   is not null;

               -- Analise se é o primeiro vale de frete
               select min(ll.con_valefrete_saque)
                 into vsaque
                 from t_con_valefrete ll
                where ll.con_conhecimento_codigo       = r_cursor.vf
                  and ll.con_conhecimento_serie        = r_cursor.serie
                  and ll.glb_rota_codigo               = r_cursor.rt
                  and nvl(ll.con_valefrete_status,'N') = 'N';

               If (R_CURSOR.SAQUE = vSaque) Then

                  vPrimeiroSaque := True;

               else


                  vPrimeiroSaque := false;

               End If;


            end;

             /********************************************************/


             /********************************************************/
             /***  LANÇAMENTO DO ADIANTAMENTO E SALDO               **/
             /***  OPERAÇÕES 2203, 2201 (S)aida DO DOCUMENTO        **/
             /********************************************************/

             begin

               vValorTarifa := 0;

               If (r_cursor.cod    = '01') Then  -- Adiantamento

                   select sum(cv.con_calcvalefrete_valor)
                     into vValorTarifa
                   from t_con_calcvalefrete cv
                   where cv.con_conhecimento_codigo = R_CURSOR.VF
                     and cv.con_conhecimento_serie = R_CURSOR.SERIE
                     and cv.glb_rota_codigo = R_CURSOR.RT 
                     and cv.con_valefrete_saque = R_CURSOR.SAQUE
                     and cv.con_calcvalefretetp_codigo in ('06','07');
                    
                   vValorTarifa := nvl(vValorTarifa,0);
--                     vValorTarifa := 0;

                   tpMovimento.Glb_Tpdoc_Codigo := 'VFA';
                   tpMovimento.GLB_ROTA_CODIGO_OPERACAO     := '000';
                 --tpMovimento.CAX_OPERACAO_CODIGO          := '2203'; -- 2002
                   tpMovimento.CAX_OPERACAO_CODIGO          := PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                    R_CURSOR.SERIE, 
                                                                                                    R_CURSOR.RT, 
                                                                                                    R_CURSOR.SAQUE, 
                                                                                                    R_CURSOR.Cod,
                                                                                                    R_CURSOR.Rota_Pgto,
                                                                                                    'S');
                                                                                                    
                   
                   tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'AD VF ELET ' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                   tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                   tpMovimento.CAX_MOVIMENTO_FREND          := 'N';


               ElsIf (r_cursor.cod    = '06') Then  -- Saque

                  If trunc(sysdate) >= '14/01/2016' Then
                    
                   tpMovimento.Glb_Tpdoc_Codigo := 'VFT';
                   tpMovimento.GLB_ROTA_CODIGO_OPERACAO     := '000';
                   tpMovimento.CAX_OPERACAO_CODIGO          := PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                    R_CURSOR.SERIE, 
                                                                                                    R_CURSOR.RT, 
                                                                                                    R_CURSOR.SAQUE, 
                                                                                                    R_CURSOR.Cod,
                                                                                                    R_CURSOR.Rota_Pgto,
                                                                                                    'S');
                                                                                                    
                   
                   tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'TRSQ VF ELET ' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                   tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                   tpMovimento.CAX_MOVIMENTO_FREND          := 'N';

                  End If;
                  
               ElsIf (r_cursor.cod    = '07') Then  -- Transferencia

                  If trunc(sysdate) >= '14/01/2016' Then

                   tpMovimento.Glb_Tpdoc_Codigo := 'VFT';
                   tpMovimento.GLB_ROTA_CODIGO_OPERACAO     := '000';
                   tpMovimento.CAX_OPERACAO_CODIGO          := PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                    R_CURSOR.SERIE, 
                                                                                                    R_CURSOR.RT, 
                                                                                                    R_CURSOR.SAQUE, 
                                                                                                    R_CURSOR.Cod,
                                                                                                    R_CURSOR.Rota_Pgto,
                                                                                                    'S');
                                                                                                    
                   
                   tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'TRTRANS VF ELET ' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                   tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                   tpMovimento.CAX_MOVIMENTO_FREND          := 'N';

                  End If;
                  
               Elsif (r_cursor.cod = '20') Then -- Saldo

                    -- Pagamento de Frete no cartão para o Frota.
                 If (vVfFrota = true) then

                   tpMovimento.Glb_Tpdoc_Codigo := 'VFS';
                   tpMovimento.GLB_ROTA_CODIGO_OPERACAO     := '000';
                   --tpMovimento.CAX_OPERACAO_CODIGO           := '2948'; -- 2001
                   
                   tpMovimento.CAX_OPERACAO_CODIGO          :=  PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                     R_CURSOR.SERIE, 
                                                                                                     R_CURSOR.RT, 
                                                                                                     R_CURSOR.SAQUE, 
                                                                                                     R_CURSOR.Cod,
                                                                                                     R_CURSOR.Rota_Pgto,
                                                                                                    'S');
                   
                   
                   tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'AD VF ELET ' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                   tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                   tpMovimento.CAX_MOVIMENTO_FREND           := 'N';
                 -- Pagamento de Frete no cartão para os Carreteiros.
                 
                 else


                   tpMovimento.Glb_Tpdoc_Codigo := 'VFS';
                   tpMovimento.GLB_ROTA_CODIGO_OPERACAO     := '000';
                   --tpMovimento.CAX_OPERACAO_CODIGO           := '2201'; -- 2001
                   tpMovimento.CAX_OPERACAO_CODIGO          :=  PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                     R_CURSOR.SERIE, 
                                                                                                     R_CURSOR.RT, 
                                                                                                     R_CURSOR.SAQUE, 
                                                                                                     R_CURSOR.Cod,
                                                                                                     R_CURSOR.Rota_Pgto,
                                                                                                     'S');
                                                                                                    
                   tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'VF ELETRONICO ' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' || r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                   tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                   tpMovimento.CAX_MOVIMENTO_FREND           := 'N';


                 END IF;


               End If;

               tpMovimento.GLB_ROTA_CODIGO_REFERENCIA   := r_cursor.rt;
               tpMovimento.CAX_MOVIMENTO_DOCUMENTO      := r_cursor.vf;
               tpMovimento.Glb_Rota_Codigo_Ccust        := r_cursor.rt;
               tpMovimento.CAX_MOVIMENTO_SERIE          := r_cursor.serie;
               tpMovimento.CAX_MOVIMENTO_DOCCOMPLEMENTO := r_cursor.saque;


               /***********************************************************************/
               /*** PARA O PAGAMENTO AOS FROTA NO CARTÃO LANÇAR O CPF DELE NO CAIXA ***/
               /**** KLAYTOM EM 28/04/2015                                            ***/
               /***********************************************************************/

               if (vVfFrota = true) then

                  tpMovimento.CAX_MOVIMENTO_CGCCPF         := r_cursor.quemrecebeu_frota;

               else


                 tpMovimento.CAX_MOVIMENTO_CGCCPF         := r_cursor.quemrecebeu;


               end if;

               /***********************************************************************/


               tpMovimento.CAX_MOVIMENTO_CGCCPF          := r_cursor.quemrecebeu;
               tpMovimento.CAX_MOVIMENTO_FAVORECIDO      := '';

               -- coloquei me 11/09/2013
               -- para evitar duplicidade
               -- Sirlano
               vInsereMov := 'S';

               if (r_cursor.cod    = '01') Then
                  If ( r_cursor.valor = vValorTarifa ) Then
                     tpMovimento.CAX_MOVIMENTO_VALOR           := 0; --r_cursor.valor;
                     vInsereMov := 'N';
                  Else 
                     tpMovimento.CAX_MOVIMENTO_VALOR           := r_cursor.valor ;
                  End If;
               Else
                  tpMovimento.CAX_MOVIMENTO_VALOR           := r_cursor.valor;
               End If;

               tpMovimento.CAX_MOVIMENTO_USUARIO         := r_cursor.usupgto;
               tpMovimento.CAX_MOVIMENTO_DTGRAVACAO      := sysdate;

               tpMovimento.GLB_ROTA_CODIGO               := R_CURSOR.RTCX;
               tpMovimento.CAX_BOLETIM_DATA              := R_CURSOR.Dtpgto;

               tpMovimento.CAX_BOLETIM_DATA              := TO_DATE(P_DATALANCAMENTO,'DD/MM/YYYY');

               SELECT NVL(MAX(M.CAX_MOVIMENTO_SEQUENCIA),0) + 1
                 INTO tpMovimento.CAX_MOVIMENTO_SEQUENCIA
                 FROM T_CAX_MOVIMENTO M
                WHERE M.GLB_ROTA_CODIGO = tpMovimento.GLB_ROTA_CODIGO
                  AND M.CAX_BOLETIM_DATA = tpMovimento.CAX_BOLETIM_DATA;


               Select count(*)
                 into vAuxiliar
                 From t_cax_movimento m
                where 0 = 0
                  and m.glb_rota_codigo_operacao              = tpMovimento.Glb_Rota_Codigo_Operacao
                  and m.cax_operacao_codigo                   = tpMovimento.Cax_Operacao_Codigo
                  and m.cax_movimento_documento               = tpMovimento.Cax_Movimento_Documento
                  and m.cax_movimento_historico               = tpMovimento.cax_movimento_historico
                  and nvl(m.cax_movimento_serie,'1')          = nvl(tpMovimento.Cax_Movimento_Serie,'1')
                  and nvl(m.glb_rota_codigo_referencia,'1')   = nvl(tpMovimento.Glb_Rota_Codigo_Referencia,'1')
                  and nvl(m.cax_movimento_doccomplemento,'1') = nvl(tpMovimento.cax_movimento_doccomplemento,'1')
                  and m.cax_movimento_valor                   = tpMovimento.cax_movimento_valor;


               if vAuxiliar > 0 Then
               
                 vInsereMov := 'N';
               
               End if;

               /********************************************************/
               /***    SE FOR SALDO NÃO INSERE ESSE LANÇAMENTO       ***/
               /****   PARA FORÇAR A FILIAL A DIGITALIZAR OS DOC´S   ***/
               /********************************************************/
               if ( PKG_CON_VALEFRETE.vInsereOpSaidaSaldo = 'N') and ( tpMovimento.CAX_OPERACAO_CODIGO =  PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                                                               R_CURSOR.SERIE, 
                                                                                                                                               R_CURSOR.RT, 
                                                                                                                                               R_CURSOR.SAQUE, 
                                                                                                                                               '20',
                                                                                                                                               R_CURSOR.Rota_Pgto,
                                                                                                                                               'S') )  then
                  
                  vInsereMov := 'N';
               
               End if;
               /********************************************************/



               /********************************************************/
               /***    VF DE FROTA E NÃO FOR O 1º VF DESSA VIAGEM ***/
               /**NÃO LANÇAMOS OS DOC´S PARA FORÇAR SUA DIGITALIZAÇÃO **/
               /********************************************************/
               if vVfFrota = true Then
                 --if vQtdeVgmFrt > 1 then
                 IF (vPrimeiroSaque = false) then
                    vInsereMov    := 'N';
                    vInsereOp2948 := 'N';
                 Else
                    -- Se for o primeiro saque valido
                     vInsereMov    := 'S';
                     vInsereOp2948 := 'S';
                 End If;
               End if;
               
               if tpMovimento.Cax_Boletim_Data < '27/01/2015' and tpMovimento.Cax_Operacao_Codigo in ('2487','2488','2491','2492') Then
                  
                  vInsereMov := 'N';   
               
               End If;
               /********************************************************/

               If tpMovimento.Cax_Movimento_Valor = 0 Then
                   vInsereMov := 'N';   
               End If;
               
               if (vInsereMov = 'S') Then


                 /********************************************************/
                 /*** FAZ O LANÇAMENTO EFETIVO                         ***/
                 /********************************************************/
                   -- Indica que o Historico foi gerado pelo Sistema e não pela Mascara do cadastro de Operações
                   tpMovimento.Cax_Movimento_Contabil := 'A';
                   tpMovimento.Cax_Movimento_Documentoref := TRIM(R_CURSOR.VF) || 
                                                             TRIM(R_CURSOR.SERIE) || 
                                                             TRIM(R_CURSOR.RT) || 
                                                             TRIM(R_CURSOR.SAQUE);

                    If FN_VERIFICA_DUPLANC_CX(tpMovimento) = 'N' Then

                      Begin
                         INSERT INTO T_CAX_MOVIMENTO VALUES tpMovimento;
                         COMMIT;
                         tpMovimento.Cax_Movimento_HistoricoP := pkg_ctb_caixa.fn_set_historico(tpMovimento.Glb_Rota_Codigo,
                                                                                                tpMovimento.Cax_Boletim_Data,
                                                                                                tpMovimento.Cax_Movimento_Sequencia,
                                                                                                'P');
                         tpMovimento.Cax_Movimento_Historico := substr(trim(tpMovimento.Cax_Movimento_HistoricoP) || '-' || trim(tpMovimento.Cax_Movimento_HistoricoC),1,50);
                         update t_cax_movimento m
                           set m.cax_movimento_historicoP = tpMovimento.Cax_Movimento_HistoricoP,
                               m.cax_movimento_historico  = tpMovimento.Cax_Movimento_Historico
                         where m.glb_rota_codigo = tpMovimento.Glb_Rota_Codigo
                           and m.cax_boletim_data = tpMovimento.Cax_Boletim_Data
                           and m.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia;
                      exception
                        When OTHERS Then
                           raise_application_error(-20015,'Glb_Tpdoc [' || tpMovimento.Glb_Tpdoc_Codigo || ']' || chr(10) || sqlerrm);                       
                        End;
                    Else
                       If tpMovimento.Cax_Operacao_Codigo <> '1200' Then
                          update tdvadm.t_con_calcvalefrete cv
                            set cv.glb_rota_codigocx = tpMovimento.Glb_Rota_Codigo,
                                cv.cax_boletim_data = tpMovimento.Cax_Boletim_Data,
                                cv.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia
                          where rowid = r_cursor.Rowid;
                       End If;
                       vAchouDup := 'S';
                    End If;
                 /********************************************************/

                  -- Idependente de qualquer tipo de Vale de frete Garante que o flag ficou como Não (N)
                  vInsereOp2948 := 'N';


                 /********************************************************/
                 /***   SE FOR O PRIMEIRO SAQUE COM VIAGEM, MARCA O VF ***/
                 /***   COMO RECEBIDO, PARA O ACERTO DE CONTAS         ***/
                 /********************************************************/
                 begin

                   if (vVfFrota = true) and (vQtdeVgmFrt = 1) then

                     Sp_Set_MarcaVfRecebido(r_cursor.vf,
                                            r_cursor.serie,
                                            r_cursor.rt,
                                            r_cursor.saque,
                                            sysdate,
                                            vStatusMR,
                                            vMessageMR);

                   End if;

                 end;
                 /********************************************************/
               Else
                 vInsereMov := 'S';     
               End If;


            end;

             /********************************************************/



             /********************************************************/
             /***  LANÇAMENTO DO ADIANTAMENTO E SALDO               **/
             /***  OPERAÇÃO 1200(E)ENTRADA COMO SE FOSSE O CHEQUE   **/
             /********************************************************/

             begin

               -- Pagamento de Frete no cartão para o Frota.
               If (vVfFrota = true) then


                 tpMovimento.GLB_ROTA_CODIGO_OPERACAO         := '000';
               --tpMovimento.CAX_OPERACAO_CODIGO              := '1396';
                 tpMovimento.CAX_OPERACAO_CODIGO              := PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                      R_CURSOR.SERIE, 
                                                                                                      R_CURSOR.RT, 
                                                                                                      R_CURSOR.SAQUE, 
                                                                                                      R_CURSOR.Cod,
                                                                                                      R_CURSOR.Rota_Pgto,
                                                                                                      'E');

               -- Pagamento de Frete no cartão para os Carreteiros.
               Else


                 tpMovimento.GLB_ROTA_CODIGO_OPERACAO         := '000';
               --tpMovimento.CAX_OPERACAO_CODIGO              := '1200'; -- 1001
                 tpMovimento.CAX_OPERACAO_CODIGO              := PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                      R_CURSOR.SERIE, 
                                                                                                      R_CURSOR.RT, 
                                                                                                      R_CURSOR.SAQUE, 
                                                                                                      R_CURSOR.Cod,
                                                                                                      R_CURSOR.Rota_Pgto,
                                                                                                      'E');

               end if;


               if (r_cursor.cod = '01') then  -- Adiantamento

                  tpMovimento.Glb_Tpdoc_Codigo := 'VFA';
                  tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'CT:' || lpad(trim(r_cursor.cartao),16,'0') || 'VFA' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                  tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;

               Elsif r_cursor.cod = '06' then -- Saque
                    If trunc(sysdate) >= '14/01/2016' Then
                    tpMovimento.Glb_Tpdoc_Codigo := 'VFT';
                    tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'CT:' || lpad(trim(r_cursor.cartao),16,'0') || 'VFSQ' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                    tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                    End If;
               Elsif r_cursor.cod = '07' then -- Transferencia
                    If trunc(sysdate) >= '14/01/2016' Then
                    tpMovimento.Glb_Tpdoc_Codigo := 'VFT';
                    tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'CT:' || lpad(trim(r_cursor.cartao),16,'0') || 'VFTR' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                    tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                    End If;
               Elsif r_cursor.cod = '20' then -- Saldo

                    -- Pagamento de Frete no cartão para os Carreteiros.
                    tpMovimento.Glb_Tpdoc_Codigo := 'VFS';
                    tpMovimento.CAX_MOVIMENTO_HISTORICOP     := 'CT:' || lpad(trim(r_cursor.cartao),16,'0') || 'VFS' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                    tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                    
               End if;

               tpMovimento.GLB_ROTA_CODIGO_REFERENCIA      := null;
               tpMovimento.CAX_MOVIMENTO_DOCUMENTO         := substr(lpad(trim(r_cursor.cartao),16,'0'),-7,7);
               tpMovimento.Glb_Rota_Codigo_Ccust           := null;
               tpMovimento.CAX_MOVIMENTO_SERIE             := null;
               tpMovimento.CAX_MOVIMENTO_DOCCOMPLEMENTO    := null;
               tpMovimento.CAX_MOVIMENTO_FREND             := 'N';

               SELECT NVL(MAX(M.CAX_MOVIMENTO_SEQUENCIA),0) + 1
                 INTO tpMovimento.CAX_MOVIMENTO_SEQUENCIA
                 FROM T_CAX_MOVIMENTO M
                WHERE M.GLB_ROTA_CODIGO = tpMovimento.GLB_ROTA_CODIGO
                  AND M.CAX_BOLETIM_DATA = tpMovimento.CAX_BOLETIM_DATA;

               -- coloquei me 11/09/2013
               -- para evitar duplicidade
               -- Sirlano
               vInsereMov := 'S';

               Select count(*)
                 into vAuxiliar
                 From t_cax_movimento m
                where 0 = 0
                  and m.glb_rota_codigo_operacao              = tpMovimento.Glb_Rota_Codigo_Operacao
                  and m.cax_operacao_codigo                   = tpMovimento.Cax_Operacao_Codigo
                  and m.cax_movimento_documento               = tpMovimento.Cax_Movimento_Documento
                  and m.cax_movimento_historico               = tpMovimento.cax_movimento_historico
                  and nvl(m.cax_movimento_serie,'1')          = nvl(tpMovimento.Cax_Movimento_Serie,'1')
                  and nvl(m.glb_rota_codigo_referencia,'1')   = nvl(tpMovimento.Glb_Rota_Codigo_Referencia,'1')
                  and nvl(m.cax_movimento_doccomplemento,'1') = nvl(tpMovimento.cax_movimento_doccomplemento,'1')
                  and m.cax_movimento_valor                   = tpMovimento.cax_movimento_valor;

               if vAuxiliar > 0 Then
                   vInsereMov := 'N';
               End if;

               -- VERIFICAÇÃO SOMENTE PARA SALDO
               IF (R_CURSOR.cod = '20') THEN
                 
                 if ( PKG_CON_VALEFRETE.vInsereOpSaidaSaldo = 'N') and ( tpMovimento.CAX_OPERACAO_CODIGO = PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                                                                R_CURSOR.SERIE, 
                                                                                                                                                R_CURSOR.RT, 
                                                                                                                                                R_CURSOR.SAQUE, 
                                                                                                                                                '20',
                                                                                                                                                R_CURSOR.Rota_Pgto,
                                                                                                                                                'S') )  then
                    
                    vInsereMov := 'N';
                    
                 End if;
               
               END IF;

               If tpMovimento.Cax_Movimento_Valor = 0 Then
                   vInsereMov := 'N';   
               End If;

               if vInsereMov = 'S' Then

                   -- Indica que o Historico foi gerado pelo Sistema e não pela Mascara do cadastro de Operações
                   tpMovimento.Cax_Movimento_Contabil := 'A';
                   tpMovimento.Cax_Movimento_Documentoref := TRIM(R_CURSOR.VF) || 
                                                             TRIM(R_CURSOR.SERIE) || 
                                                             TRIM(R_CURSOR.RT) || 
                                                             TRIM(R_CURSOR.SAQUE);
                   If FN_VERIFICA_DUPLANC_CX(tpMovimento) = 'N' Then
                      Begin
                         INSERT INTO T_CAX_MOVIMENTO VALUES tpMovimento;
                         COMMIT;
                         tpMovimento.Cax_Movimento_HistoricoP := pkg_ctb_caixa.fn_set_historico(tpMovimento.Glb_Rota_Codigo,
                                                                                                tpMovimento.Cax_Boletim_Data,
                                                                                                tpMovimento.Cax_Movimento_Sequencia,
                                                                                                'P');
                         tpMovimento.Cax_Movimento_Historico := substr(trim(tpMovimento.Cax_Movimento_HistoricoP) || '-' || trim(tpMovimento.Cax_Movimento_HistoricoC),1,50);
                         update t_cax_movimento m
                           set m.cax_movimento_historicoP = tpMovimento.Cax_Movimento_HistoricoP,
                               m.cax_movimento_historico  = tpMovimento.Cax_Movimento_Historico
                         where m.glb_rota_codigo = tpMovimento.Glb_Rota_Codigo
                           and m.cax_boletim_data = tpMovimento.Cax_Boletim_Data
                           and m.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia;
                      exception
                        When OTHERS Then
                           raise_application_error(-20015,'Glb_Tpdoc [' || tpMovimento.Glb_Tpdoc_Codigo || ']' || chr(10) || sqlerrm);                       
                        End;
                   Else
                      If tpMovimento.Cax_Operacao_Codigo <> '1200' Then
                         update tdvadm.t_con_calcvalefrete cv
                           set cv.glb_rota_codigocx = tpMovimento.Glb_Rota_Codigo,
                               cv.cax_boletim_data = tpMovimento.Cax_Boletim_Data,
                               cv.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia
                         where rowid = r_cursor.Rowid;
                      End If;
                      vAchouDup := 'S';
                   End If;
                   If vAchouDup = 'N' Then
                      update t_con_calcvalefrete cvf
                         set cvf.glb_rota_codigocx          = tpMovimento.Glb_Rota_Codigo,
                             cvf.cax_boletim_data           = tpMovimento.Cax_Boletim_Data,
                             cvf.cax_movimento_sequencia    = tpMovimento.Cax_Movimento_Sequencia
                       where cvf.con_conhecimento_codigo    = r_cursor.vf
                         and cvf.con_conhecimento_serie     = r_cursor.serie
                         and cvf.glb_rota_codigo            = r_cursor.rt
                         and cvf.con_valefrete_saque        = r_cursor.saque
                         and cvf.con_calcvalefretetp_codigo = r_cursor.cod
                         and cvf.cax_boletim_data is null;
                         if sql%rowcount = 0 Then
                            rollback;
                            vInsereMov := 'N';
                         End If; 
                     End If;    
                     

               Else
                 vInsereMov := 'S';  
               End If;


            end;

             /********************************************************/

             /********************************************************/
             /***       LANÇAMENTO DO PEDÁGIO                       **/
             /********************************************************/

             begin
               -- verifica se existe pedagio para esta vale frete
               begin


                 select nvl(cvf.con_calcvalefrete_valor,0),
                        nvl(cvf.con_calcvalefrete_cartao,'0')
                   into vValorPed,
                        vNrCartao
                   from t_con_calcvalefrete cvf
                  where cvf.con_conhecimento_codigo    = r_cursor.vf
                    and cvf.con_conhecimento_serie     = r_cursor.serie
                    and cvf.glb_rota_codigo            = r_cursor.rt
                    and cvf.con_valefrete_saque        = r_cursor.saque
                    and cvf.con_calcvalefretetp_codigo = '02'
                    AND Cvf.CON_CALCVALEFRETE_TIPO     = 'C'
                    and cvf.cax_boletim_data           is null
                    and cvf.cax_movimento_sequencia    is null;


               exception when NO_DATA_FOUND Then
                     vValorPed := 0;
                     vNrCartao := '0000000000000000';
               end;


               /**********************************************************/
               /* ZERO O PEDÁGIO QUANDO FOR FROTA PARA NÃO TER LANAMENTO */
               /**********************************************************/

               begin


                 If (vVfFrota = true) then

                   vValorPed := 0;

                 end if;

               end;

               /**********************************************************/

               if (vValorPed > 0) then
                  
                  /**********************************************************/
                  /* LANÇAMENTO DE SAIDA PARA O PEDAGIO                     */
                  /**********************************************************/
                  BEGIN
                    
                    tpMovimento.Glb_Tpdoc_Codigo := 'VFP';
                    tpMovimento.GLB_ROTA_CODIGO_OPERACAO      := '000';
                 -- tpMovimento.CAX_OPERACAO_CODIGO           := '2227'; -- 2545
                    tpMovimento.CAX_OPERACAO_CODIGO           := PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                      R_CURSOR.SERIE, 
                                                                                                      R_CURSOR.RT, 
                                                                                                      R_CURSOR.SAQUE, 
                                                                                                      '02',
                                                                                                      R_CURSOR.Rota_Pgto,
                                                                                                      'S');
                                                                                                      
                    tpMovimento.CAX_MOVIMENTO_HISTORICOP      := 'VALE PEDAGIO ' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                    tpMovimento.CAX_MOVIMENTO_HISTORICO       := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                    tpMovimento.CAX_MOVIMENTO_FREND           := 'N';
                    tpMovimento.CAX_MOVIMENTO_VALOR           := vValorPed;

                    tpMovimento.GLB_ROTA_CODIGO_REFERENCIA    := r_cursor.rt;
                    tpMovimento.CAX_MOVIMENTO_DOCUMENTO       := r_cursor.vf;
                    tpMovimento.Glb_Rota_Codigo_Ccust         := r_cursor.rt;
                    tpMovimento.CAX_MOVIMENTO_SERIE           := r_cursor.serie;
                    tpMovimento.CAX_MOVIMENTO_DOCCOMPLEMENTO  := r_cursor.saque;
                    tpMovimento.CAX_MOVIMENTO_CGCCPF          := r_cursor.quemrecebeu;
                    tpMovimento.CAX_MOVIMENTO_FAVORECIDO      := '';
                    tpMovimento.CAX_MOVIMENTO_VALOR           := vValorPed;
                    tpMovimento.CAX_MOVIMENTO_USUARIO         := r_cursor.usupgto;
                    tpMovimento.CAX_MOVIMENTO_DTGRAVACAO      := sysdate;

                    tpMovimento.GLB_ROTA_CODIGO               := R_CURSOR.RTCX;
                    tpMovimento.CAX_BOLETIM_DATA              := R_CURSOR.Dtpgto;

                    tpMovimento.CAX_BOLETIM_DATA              := TO_DATE(P_DATALANCAMENTO,'DD/MM/YYYY');

                    SELECT NVL(MAX(M.CAX_MOVIMENTO_SEQUENCIA),0) + 1
                      INTO tpMovimento.CAX_MOVIMENTO_SEQUENCIA
                      FROM T_CAX_MOVIMENTO M
                     WHERE M.GLB_ROTA_CODIGO  = tpMovimento.GLB_ROTA_CODIGO
                       AND M.CAX_BOLETIM_DATA = tpMovimento.CAX_BOLETIM_DATA;

                    -- coloquei me 11/09/2013
                    -- para evitar duplicidade
                    -- Sirlano
                    vInsereMov := 'S';

                    Select count(*)
                      into vAuxiliar
                      From t_cax_movimento m
                     where 0 = 0
                       and m.glb_rota_codigo_operacao              = tpMovimento.Glb_Rota_Codigo_Operacao
                       and m.cax_operacao_codigo                   = tpMovimento.Cax_Operacao_Codigo
                       -- Retirado, pois colocamos o Pedagio no Select Principal
                       -- Com isto esta provocando duplicicade dos lancamentos
                       -- Sirlano /  Vinicius
                       --08/11/2021
                       --and m.cax_movimento_documento               = tpMovimento.Cax_Movimento_Documento
                       --and m.cax_movimento_historicoP              = tpMovimento.cax_movimento_historico
                       --and nvl(m.cax_movimento_serie,'1')          = nvl(tpMovimento.Cax_Movimento_Serie,'1')
                       --and nvl(m.glb_rota_codigo_referencia,'1')   = nvl(tpMovimento.Glb_Rota_Codigo_Referencia,'1')
                       --and nvl(m.cax_movimento_doccomplemento,'1') = nvl(tpMovimento.cax_movimento_doccomplemento,'1')
                       -- Inserimos este codigo para pegar a duplicidade
                       -- Sirlano /  Vinicius
                       --08/11/2021
                       and m.glb_tpdoc_codigo                      = 'VFP'
                       and m.cax_movimento_documentoref            = TRIM(R_CURSOR.VF) || 
                                                                     TRIM(R_CURSOR.SERIE) || 
                                                                     TRIM(R_CURSOR.RT) || 
                                                                     TRIM(R_CURSOR.SAQUE)
                       -- **************** ate aqui
                       and m.cax_movimento_valor                   = tpMovimento.cax_movimento_valor;

                    if vAuxiliar > 0 Then
                        vInsereMov := 'N';
                    End if;

                 /*   if ( PKG_CON_VALEFRETE.vInsereOpSaidaSaldo = 'N') and ( tpMovimento.CAX_OPERACAO_CODIGO =  PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                                                                    R_CURSOR.SERIE, 
                                                                                                                                                    R_CURSOR.RT, 
                                                                                                                                                    R_CURSOR.SAQUE, 
                                                                                                                                                    '20',
                                                                                                                                                    R_CURSOR.Rota_Pgto,
                                                                                                                                                    'S') )  then
                       
                       vInsereMov := 'N';
                       
                    End if;*/

                    If tpMovimento.Cax_Movimento_Valor = 0 Then
                       vInsereMov := 'N';   
                    End If;

                    if vInsereMov = 'S' Then
                       -- Indica que o Historico foi gerado pelo Sistema e não pela Mascara do cadastro de Operações
                       tpMovimento.Cax_Movimento_Contabil := 'A';
                       tpMovimento.Cax_Movimento_Documentoref := TRIM(R_CURSOR.VF) || 
                                                                 TRIM(R_CURSOR.SERIE) || 
                                                                 TRIM(R_CURSOR.RT) || 
                                                                 TRIM(R_CURSOR.SAQUE);
                       If FN_VERIFICA_DUPLANC_CX(tpMovimento) = 'N' Then
                          Begin
                             INSERT INTO T_CAX_MOVIMENTO VALUES tpMovimento;
                             COMMIT;
                             tpMovimento.Cax_Movimento_HistoricoP := pkg_ctb_caixa.fn_set_historico(tpMovimento.Glb_Rota_Codigo,
                                                                                                    tpMovimento.Cax_Boletim_Data,
                                                                                                    tpMovimento.Cax_Movimento_Sequencia,
                                                                                                    'P');
                             tpMovimento.Cax_Movimento_Historico := substr(trim(tpMovimento.Cax_Movimento_HistoricoP) || '-' || trim(tpMovimento.Cax_Movimento_HistoricoC),1,50);
                             update t_cax_movimento m
                               set m.cax_movimento_historicoP = tpMovimento.Cax_Movimento_HistoricoP,
                                   m.cax_movimento_historico  = tpMovimento.Cax_Movimento_Historico
                             where m.glb_rota_codigo = tpMovimento.Glb_Rota_Codigo
                               and m.cax_boletim_data = tpMovimento.Cax_Boletim_Data
                               and m.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia;
                          exception
                            When OTHERS Then
                               raise_application_error(-20015,'Glb_Tpdoc [' || tpMovimento.Glb_Tpdoc_Codigo || ']' || chr(10) || sqlerrm);                       
                           End;
                       Else
                           If tpMovimento.Cax_Operacao_Codigo <> '1200' Then
                              update tdvadm.t_con_calcvalefrete cv
                                set cv.glb_rota_codigocx = tpMovimento.Glb_Rota_Codigo,
                                    cv.cax_boletim_data = tpMovimento.Cax_Boletim_Data,
                                    cv.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia
                              where rowid = r_cursor.Rowid;
                           End If;
                          vAchouDup := 'S';
                       End If; 
                   End If;
                  
                  END;

                  /**********************************************************/
                  /* LANÇAMENTO DE ENTRADA PARA O PEDAGIO                   */
                  /**********************************************************/
                  BEGIN
                    -- criar a inclusao do " cheque "
                    tpMovimento.Glb_Tpdoc_Codigo := 'VFP';
                    tpMovimento.GLB_ROTA_CODIGO_OPERACAO     := '000';
                  --tpMovimento.CAX_OPERACAO_CODIGO          := '1200'; -- 1001
                    tpMovimento.CAX_OPERACAO_CODIGO          := PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                     R_CURSOR.SERIE, 
                                                                                                     R_CURSOR.RT, 
                                                                                                     R_CURSOR.SAQUE,
                                                                                                     '02',
                                                                                                     R_CURSOR.Rota_Pgto,
                                                                                                     'E');

                    -- para o cheque
                    tpMovimento.CAX_MOVIMENTO_HISTORICOP       := 'CT:' || lpad(trim(vNrCartao),16,'0') || 'VFP' || TO_CHAR(R_CURSOR.Dtpgto,'DD/MM/YYYY') || '-' ||  r_cursor.vf || '-' || r_cursor.serie || '-' || r_cursor.rt || '-' || r_cursor.saque;
                    tpMovimento.CAX_MOVIMENTO_HISTORICO      := tpMovimento.CAX_MOVIMENTO_HISTORICOP;
                    tpMovimento.GLB_ROTA_CODIGO_REFERENCIA    := null;
                    tpMovimento.CAX_MOVIMENTO_DOCUMENTO       := substr(lpad(trim(vNrCartao),16,'0'),-7,7);
                    tpMovimento.Glb_Rota_Codigo_Ccust         := null;
                    tpMovimento.CAX_MOVIMENTO_SERIE           := null;
                    tpMovimento.CAX_MOVIMENTO_DOCCOMPLEMENTO  := null;
                    tpMovimento.CAX_MOVIMENTO_FREND           := 'N';

                    SELECT NVL(MAX(M.CAX_MOVIMENTO_SEQUENCIA),0) + 1
                      INTO tpMovimento.CAX_MOVIMENTO_SEQUENCIA
                      FROM T_CAX_MOVIMENTO M
                     WHERE M.GLB_ROTA_CODIGO = tpMovimento.GLB_ROTA_CODIGO
                       AND M.CAX_BOLETIM_DATA = tpMovimento.CAX_BOLETIM_DATA;

                    -- coloquei me 11/09/2013
                    -- para evitar duplicidade
                    -- Sirlano
                    vInsereMov := 'S';
                    Select count(*)
                   into vAuxiliar
                 From t_cax_movimento m
                 where 0 = 0
                   and m.glb_rota_codigo_operacao              = tpMovimento.Glb_Rota_Codigo_Operacao
                   and m.cax_operacao_codigo                   = tpMovimento.Cax_Operacao_Codigo
                   and m.cax_movimento_documento               = tpMovimento.Cax_Movimento_Documento
                   and m.cax_movimento_historico               = tpMovimento.cax_movimento_historico
                   and nvl(m.cax_movimento_serie,'1')          = nvl(tpMovimento.Cax_Movimento_Serie,'1')
                   and nvl(m.glb_rota_codigo_referencia,'1')   = nvl(tpMovimento.Glb_Rota_Codigo_Referencia,'1')
                   and nvl(m.cax_movimento_doccomplemento,'1') = nvl(tpMovimento.cax_movimento_doccomplemento,'1')
                   and m.cax_movimento_valor          = tpMovimento.cax_movimento_valor;


                    if vAuxiliar > 0 Then
                       vInsereMov := 'N';
                    End if;

                   /* if ( PKG_CON_VALEFRETE.vInsereOpSaidaSaldo = 'N') and ( tpMovimento.CAX_OPERACAO_CODIGO = PKG_CON_VALEFRETE.Fn_RetornaOperacao(R_CURSOR.VF, 
                                                                                                                                                   R_CURSOR.SERIE, 
                                                                                                                                                   R_CURSOR.RT, 
                                                                                                                                                   R_CURSOR.SAQUE, 
                                                                                                                                                   '20',
                                                                                                                                                   R_CURSOR.Rota_Pgto,
                                                                                                                                                   'S') )  then
                       
                       vInsereMov := 'N';
                       
                    End if;*/

                    If tpMovimento.Cax_Movimento_Valor = 0 Then
                       vInsereMov := 'N';   
                    End If;
                    if vInsereMov = 'S' Then
                       -- Indica que o Historico foi gerado pelo Sistema e não pela Mascara do cadastro de Operações
                       tpMovimento.Cax_Movimento_Contabil := 'A';
                   tpMovimento.Cax_Movimento_Documentoref := TRIM(R_CURSOR.VF) || 
                                                             TRIM(R_CURSOR.SERIE) || 
                                                             TRIM(R_CURSOR.RT) || 
                                                             TRIM(R_CURSOR.SAQUE);

                   If FN_VERIFICA_DUPLANC_CX(tpMovimento) = 'N' Then
                      Begin
                         INSERT INTO T_CAX_MOVIMENTO VALUES tpMovimento;
                         COMMIT;
                         tpMovimento.Cax_Movimento_HistoricoP := pkg_ctb_caixa.fn_set_historico(tpMovimento.Glb_Rota_Codigo,
                                                                                                tpMovimento.Cax_Boletim_Data,
                                                                                                tpMovimento.Cax_Movimento_Sequencia,
                                                                                                'P');
                         tpMovimento.Cax_Movimento_Historico := substr(trim(tpMovimento.Cax_Movimento_HistoricoP) || '-' || trim(tpMovimento.Cax_Movimento_HistoricoC),1,50);
                         update t_cax_movimento m
                           set m.cax_movimento_historicoP = tpMovimento.Cax_Movimento_HistoricoP,
                               m.cax_movimento_historico  = tpMovimento.Cax_Movimento_Historico
                         where m.glb_rota_codigo = tpMovimento.Glb_Rota_Codigo
                           and m.cax_boletim_data = tpMovimento.Cax_Boletim_Data
                           and m.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia;
                      exception
                        When OTHERS Then
                           raise_application_error(-20015,'Glb_Tpdoc [' || tpMovimento.Glb_Tpdoc_Codigo || ']' || chr(10) || sqlerrm);                       
                        End;
                    Else
                       If tpMovimento.Cax_Operacao_Codigo <> '1200' Then
                          update tdvadm.t_con_calcvalefrete cv
                            set cv.glb_rota_codigocx = tpMovimento.Glb_Rota_Codigo,
                                cv.cax_boletim_data = tpMovimento.Cax_Boletim_Data,
                                cv.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia
                          where rowid = r_cursor.Rowid;
                       End If;
                       vAchouDup := 'S';
                    End If;
                     
                    If vAchouDup = 'N' Then
                       update t_con_calcvalefrete cvf
                       set cvf.glb_rota_codigocx = tpMovimento.Glb_Rota_Codigo,
                           cvf.cax_boletim_data = tpMovimento.Cax_Boletim_Data,
                           cvf.cax_movimento_sequencia = tpMovimento.Cax_Movimento_Sequencia
                       where cvf.con_conhecimento_codigo    = r_cursor.vf
                         and cvf.con_conhecimento_serie     = r_cursor.serie
                         and cvf.glb_rota_codigo            = r_cursor.rt
                         and cvf.con_valefrete_saque        = r_cursor.saque
                         and cvf.con_calcvalefretetp_codigo = '02';
                       
                       vAuxiliar := sql%rowcount;
                       
                       If vAuxiliar = 0 Then
                          rollback;
                          vInsereMov := 'N';
                         
                       End If;
                    End If;   

                    End If;
                  
                  END;
               
                end if;
            
            end;

             /********************************************************/

             IF P_COMMIT = 'S' THEN
             
                COMMIT;
             
             END IF ;

           End Loop;

       end;

       /********************************************************/


       /********************************************************/
       /**   VOLTA O STATUS DO BOLETIM                        **/
       /********************************************************/
       
       begin
         
         update t_cax_boletim bo
            set bo.cax_boletim_status  = vStatusBoletim
          where bo.glb_rota_codigo     = P_ROTA
            and bo.cax_boletim_data    = TO_DATE(P_DATALANCAMENTO,'DD/MM/YYYY')  ;
       
       End;   
       
       /********************************************************/
          
       IF P_COMMIT = 'S' THEN
          COMMIT;
       END IF;

     ELSE
       
        FOR R_CURSOR IN (SELECT M.GLB_ROTA_CODIGO,COUNT(*)
                           FROM T_CAX_MOVIMENTO M
                          WHERE M.CAX_BOLETIM_DATA = P_DATALANCAMENTO
                            AND M.CAX_OPERACAO_CODIGO IN ('2203',
                                                          '2201',
                                                          '1200',
                                                          '2227',
                                                          '2487',
                                                          '2488',
                                                          '2491',
                                                          '2492',
                                                          '1200')
                         GROUP BY M.GLB_ROTA_CODIGO
                         order by 2)
         LOOP
           
           for r_cursor2 in (select m.glb_rota_codigo,
                                    m.cax_boletim_data,
                                    m.cax_movimento_sequencia
                               from t_cax_movimento m
                              where m.cax_boletim_data = P_DATALANCAMENTO
                                and m.cax_operacao_codigo in ('2203',
                                                              '2201',
                                                              '1200',
                                                              '2227',
                                                              '2487',
                                                              '2488',
                                                              '2491',
                                                              '2492',
                                                              '1200')
                                and m.glb_rota_codigo = R_CURSOR.GLB_ROTA_CODIGO)
           loop

                pkg_ctb_caixa.vAutorizaExclusaoFe := 'S';

                Begin

                  delete t_cax_movimento m
                   where m.glb_rota_codigo         = r_cursor2.glb_rota_codigo
                     and m.cax_boletim_data        = r_cursor2.cax_boletim_data
                     and m.cax_movimento_sequencia = r_cursor2.cax_movimento_sequencia;

                   pkg_ctb_caixa.vAutorizaExclusaoFe := 'N';

                exception when Others Then
                      pkg_ctb_caixa.vAutorizaExclusaoFe := 'N';
                end;

                IF P_COMMIT = 'S' THEN
                   COMMIT;
                END IF ;

           end loop;

         end loop;

     END IF;
     
   end;
   /********************************************************/
   
  Commit;

 End SP_CON_FRETECAIXA;


 /*
 
 update tdvadm.t_cax_movimento m
  set m.glb_tpdoc_codigo = 'VFA'
where m.cax_boletim_data >= to_date('01/01/2016','dd/mm/yyyy')    
  and nvl(m.glb_tpdoc_codigo,'XXX') <> 'VFA'
  and ( ( substr(m.cax_movimento_historico,19,4) = ',AD,' and m.cax_operacao_codigo = '1200' )
      or m.cax_operacao_codigo = '2203' ) ;

update tdvadm.t_cax_movimento m
  set m.glb_tpdoc_codigo = 'VFS'
where m.cax_boletim_data >= to_date('01/01/2016','dd/mm/yyyy')    
  and nvl(m.glb_tpdoc_codigo,'XXX') <> 'VFS'
  and ( ( substr(m.cax_movimento_historico,19,4) = ',SD,' and m.cax_operacao_codigo = '1200' )
      or m.cax_operacao_codigo = '2201' ) ;


update tdvadm.t_cax_movimento m
  set m.glb_tpdoc_codigo = 'VFT'
where m.cax_boletim_data >= to_date('01/01/2016','dd/mm/yyyy')    
  and nvl(m.glb_tpdoc_codigo,'XXX') <> 'VFT'
  and ( ( substr(m.cax_movimento_historico,19,4) = ',TR,' and m.cax_operacao_codigo = '1200' )
      or m.cax_operacao_codigo in ('2487','2488') ) ;
      
update tdvadm.t_cax_movimento m
  set m.glb_tpdoc_codigo = 'VFP'
where m.cax_boletim_data >= to_date('01/01/2016','dd/mm/yyyy')    
  and nvl(m.glb_tpdoc_codigo,'XXX') <> 'VFP'
  and ( ( substr(m.cax_movimento_historico,19,4) = ',PD,' and m.cax_operacao_codigo = '1200' )
      or m.cax_operacao_codigo = '2227' ) ;

 

 Select 'update t_con_calcvalefrete ca ' ||
        decode(vo.cfe_integratdv_cod,22, ' Set ca.glb_rota_codigolib  = ' || pkg_glb_common.fn_QuotedStr(TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|')) ,
                                     23, ' Set ca.glb_rota_codigopgto = ' || pkg_glb_common.fn_QuotedStr(TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|')) ,
                                     '' ) ||
        ' Where ca.con_conhecimento_codigo = ' || pkg_glb_common.fn_QuotedStr(TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFNumero','=','*'), 'valor', '=', '|')) ||
        ' And ca.con_conhecimento_serie = ' || pkg_glb_common.fn_QuotedStr(TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFSerie','=','*'), 'valor', '=', '|')) ||
        ' And ca.glb_rota_codigo = ' || pkg_glb_common.fn_QuotedStr(TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFRota','=','*'), 'valor', '=', '|')) ||
        ' And ca.con_valefrete_saque = ' || pkg_glb_common.fn_QuotedStr(TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFSaque','=','*'), 'valor', '=', '|')) ||
        ' And ca.con_calcvalefretetp_codigo = ' || pkg_glb_common.fn_QuotedStr(TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFParcelTdv','=','*'), 'valor', '=', '|')) ||
        decode(vo.cfe_integratdv_cod,22, ' And ca.glb_rota_codigolib  is null;' ,
                                     23, ' And ca.glb_rota_codigopgto is null;' ,
                                     'ddddd' ) script,

        vo.con_freteoper_rota ROTAID,
        vo.cfe_integratdv_cod INTEGRA,
        vo.cfe_operacoes_cod OPER,
        vo.con_freteoper_paramqrystr,
        TDVADM.fn_querystring(TDVADM.fn_querystring(trim(vo.con_freteoper_paramqrystr),'IntegraTdv_Cod','=','*'), 'valor', '=', '|') integracao,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFParcelIdSt','=','*'), 'valor', '=', '|') status,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFNumero','=','*'), 'valor', '=', '|') VALE,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFSerie','=','*'), 'valor', '=', '|') SR,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFRota','=','*'), 'valor', '=', '|') ROTAVF,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFSaque','=','*'), 'valor', '=', '|') SQ,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFParcelGer','=','*'), 'valor', '=', '|') PARCELAGER,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFParcelTdv','=','*'), 'valor', '=', '|') PARCELATDV,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFUsuarioTDV','=','*'), 'valor', '=', '|') USUARIO,
        TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|') ROTAPGTO
 --Select Count(*)
 From T_CON_FRETEOPER vo
 Where vo.cfe_statusfreteoper_status = 'OK'
   And vo.cfe_integratdv_cod In (23)
   And 0 < (Select Count(*)
            From t_con_calcvalefrete ca
            Where ca.con_conhecimento_codigo = TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFNumero','=','*'), 'valor', '=', '|')
              And ca.con_conhecimento_serie  = TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFSerie','=','*'), 'valor', '=', '|')
              And ca.glb_rota_codigo         = TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFRota','=','*'), 'valor', '=', '|')
              And ca.con_valefrete_saque     = TDVADM.fn_querystring(TDVADM.fn_querystring(vo.con_freteoper_paramqrystr,'VFSaque','=','*'), 'valor', '=', '|')
              And ca.con_calcvalefretetp_codigo In ('01','20')
              And ( ca.glb_rota_codigolib Is Null Or ca.glb_rota_codigopgto Is Null))

 update t_con_calcvalefrete ca
   set ca.glb_rota_codigocx = (select rt.glb_rota_caixa from t_glb_rota rt where rt.glb_rota_codigo = ca.glb_rota_codigopgto)
 where nvl(ca.glb_rota_codigocx,'999') = '999'
   and ca.con_calcvalefrete_tipo = 'C'
   and ca.usu_usuario_bloqueou is null
   and ca.con_calcvalefrete_dtliberacao is not null;

 update t_con_calcvalefrete ca
   set ca.glb_rota_codigocx = (select rt.glb_rota_caixa from t_glb_rota rt where rt.glb_rota_codigo = ca.glb_rota_codigolib)
 where nvl(ca.glb_rota_codigocx,'999') = '999'
   and ca.con_calcvalefrete_tipo = 'C'
   and ca.usu_usuario_bloqueou is null
   and ca.con_calcvalefrete_dtliberacao is not null;


 -- coloca a rota do VF se for adiantamento
 update t_con_calcvalefrete ca
   set ca.glb_rota_codigocx = (select rt.glb_rota_caixa from t_glb_rota rt where rt.glb_rota_codigo = ca.glb_rota_codigo)
 where nvl(ca.glb_rota_codigocx,'999') = '999'
   and ca.con_calcvalefrete_tipo = 'C'
   and ca.usu_usuario_bloqueou is null
   and ca.con_calcvalefretetp_codigo = '01'
   and ca.con_calcvalefrete_dtliberacao is not null;

 update t_con_calcvalefrete ca
   set ca.glb_rota_codigocx = (select rt.glb_rota_caixa
                               from t_glb_rota rt,
                                    t_usu_usuario u
                               where rt.glb_rota_codigo = u.glb_rota_codigo
                                 and u.usu_usuario_codigo = ca.usu_usuario_codigopgto)
 where nvl(ca.glb_rota_codigocx,'999') = '999'
   and ca.con_calcvalefrete_tipo = 'C'
   and ca.usu_usuario_bloqueou is null
   and ca.con_calcvalefretetp_codigo = '20'
   and ca.con_calcvalefrete_dtliberacao is not null;

 update t_con_calcvalefrete ca
   set ca.glb_rota_codigocx = (select rt.glb_rota_caixa
                               from t_glb_rota rt,
                                    t_usu_usuario u
                               where rt.glb_rota_codigo = u.glb_rota_codigo
                                 and u.usu_usuario_codigo = ca.usu_usuario_codigoliberou)
 where nvl(ca.glb_rota_codigocx,'999') = '999'
   and ca.con_calcvalefrete_tipo = 'C'
   and ca.usu_usuario_bloqueou is null
   and ca.con_calcvalefretetp_codigo = '20'
   and ca.con_calcvalefrete_dtliberacao is not null;


 select distinct ca.con_calcvalefretetp_codigo
 from  t_con_calcvalefrete ca
 where nvl(ca.glb_rota_codigocx,'999') = '999'
   and ca.con_calcvalefrete_tipo = 'C'
   and ca.usu_usuario_bloqueou is null
   and ca.con_calcvalefrete_dtliberacao is not null;



select 'exec PKG_CON_VALEFRETE.SP_CON_FRETECAIXA(' ||  pkg_glb_common.fn_QuotedStr(ca.glb_rota_codigocx) || ',' || pkg_glb_common.fn_QuotedStr('31/03/2013') || ',' || pkg_glb_common.fn_QuotedStr('31/03/2013') || ',' || pkg_glb_common.fn_QuotedStr('S') || ');'
 --      ,ca.con_conhecimento_codigo vf
 --      ,ca.glb_rota_codigo rt
        ,count(*)
 from t_con_calcvalefrete ca,
      t_con_valefrete vf
 where 0 = 0
   and ca.con_conhecimento_codigo = vf.con_conhecimento_codigo
   and ca.con_conhecimento_serie  = vf.con_conhecimento_serie
   and ca.glb_rota_codigo         = vf.glb_rota_codigo
   and ca.con_valefrete_saque     = vf.con_valefrete_saque
   and nvl(vf.con_valefrete_status,'N') <> 'C'
   and ca.glb_rota_codigocx <> '999'
   and ca.cax_boletim_data is null
   and ca.con_calcvalefrete_dtpgto <= '31/03/2013'
group by 'exec PKG_CON_VALEFRETE.SP_CON_FRETECAIXA(' ||  pkg_glb_common.fn_QuotedStr(ca.glb_rota_codigocx) || ',' || pkg_glb_common.fn_QuotedStr('31/03/2013') || ',' || pkg_glb_common.fn_QuotedStr('31/03/2013') || ',' || pkg_glb_common.fn_QuotedStr('S') || ');'


 Select * From t_glb_rota r
 Where r.glb_rota_codigo = '010' For Update;




 Select c.con_conhecimento_codigo vf,
        c.glb_rota_codigo rt,
        c.con_calcvalefrete_seq seq,
        c.con_calcvalefrete_codparoper codpar,
        tp.con_calcvalefretetp_codigo cod,
        tp.con_calcvalefretetp_descricao Descri,
        c.usu_usuario_codigoliberou usulib,
        c.glb_rota_codigolib rtlib,
        c.usu_usuario_codigopgto usupgto,
        c.glb_rota_codigopgto rtpgto,
        c.usu_usuario_bloqueou usublq,
        c.glb_rota_codigobloqueou rtblq,
        c.glb_rota_codigocx rtcx
 From t_con_calcvalefrete c,
      t_con_calcvalefretetp tp

Where 0 = 0
   And c.con_calcvalefretetp_codigo = tp.con_calcvalefretetp_codigo
   And c.glb_rota_codigocx Is Not Null  ;


 Select Distinct c.usu_usuario_codigoliberou usulib,
        u.usu_usuario_nome usuario,
        c.glb_rota_codigolib rtlib,
        c.glb_rota_codigocx rtcx
 From t_con_calcvalefrete c,
      t_con_calcvalefretetp tp,
      t_usu_usuario u

Where 0 = 0
   And c.con_calcvalefretetp_codigo = tp.con_calcvalefretetp_codigo
   And c.glb_rota_codigocx Is Not Null
   And c.usu_usuario_codigoliberou = u.usu_usuario_codigo
   And c.glb_rota_codigocx = '999'



 */

 Procedure SP_CON_ATUALIZACAIXA(pDataProc in char default sysdate)
   as
    vCursor1           T_CURSOR;
    vAuxiliar          number;
    vDataProcessamento char(10);
    vHorarioCorte      char(8);
    vfiltro            char(14);
    vScript            varchar2(200);
    vErro              clob;
    vHoraAtual         date;
    vUsuliberou        tdvadm.t_usu_usuario.usu_usuario_codigo%type;
    vMessage           varchar2(20000);
 Begin


     If SYS_CONTEXT('PROCESSOUNICO','SP_CON_ATUALIZACAIXA') = 'S' Then


          vMessage := 'Rodando desde ' ||SYS_CONTEXT('PROCESSOUNICO','SP_CON_ATUALIZACAIXAINI') || chr(13);
          if substr(fn_calcula_tempodecorrido(to_date(SYS_CONTEXT('PROCESSOUNICO','SP_CON_ATUALIZACAIXAINI'),'dd/mm/yyyy hh24:mi:ss'),sysdate,'H'),1,5) > 2 then
             vMessage := vMessage || ' Processo inicializado novamente AGORA.' || chr(13);
             SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_CON_ATUALIZACAIXAINI','');
             SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_CON_ATUALIZACAIXAFIM','');
             SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_CON_ATUALIZACAIXA','N');
             wservice.pkg_glb_email.SP_ENVIAEMAIL('Atualizando Caixa (Eletronico)',vMessage,'aut-e@dellavolpe.com.br','sdrumond@dellavolpe.com.br');
          End If;
         return;
   Else
     SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_CON_ATUALIZACAIXAINI',to_date(sysdate,'dd/mm/yyyy hh24:mi:ss'));
     SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_CON_ATUALIZACAIXA','S');
   End If;



     -- Tenta atualiza as rotas de caixas das operações
     update t_con_calcvalefrete ca
       set ca.glb_rota_codigocx = (select rt.glb_rota_caixa 
                                   from t_glb_rota rt 
                                   where rt.glb_rota_codigo = ca.glb_rota_codigopgto)
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefrete_dtpgto is not null;

/*     update t_con_calcvalefrete ca
       set ca.glb_rota_codigocx = (select rt.glb_rota_caixa 
                                   from t_glb_rota rt 
                                   where rt.glb_rota_codigo = ca.glb_rota_codigolib)
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefrete_dtliberacao is not null;
*/

     -- coloca a rota do VF se for adiantamento
     update t_con_calcvalefrete ca
       set ca.glb_rota_codigocx = (select rt.glb_rota_caixa 
                                   from t_glb_rota rt 
                                   where rt.glb_rota_codigo = ca.glb_rota_codigopgto)
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefretetp_codigo = '01'
       and ca.con_calcvalefrete_dtpgto is not null;

     update t_con_calcvalefrete ca
       set ca.glb_rota_codigocx = (select rt.glb_rota_caixa
                                   from t_glb_rota rt,
                                        t_usu_usuario u
                                   where rt.glb_rota_codigo = u.glb_rota_codigo
                                     and u.usu_usuario_codigo = ca.usu_usuario_codigopgto)
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefretetp_codigo = '20'
       and ca.con_calcvalefrete_dtpgto is not null;

/*     update t_con_calcvalefrete ca
       set ca.glb_rota_codigocx = (select rt.glb_rota_caixa
                                   from t_glb_rota rt,
                                        t_usu_usuario u
                                   where rt.glb_rota_codigo = u.glb_rota_codigo
                                     and u.usu_usuario_codigo = ca.usu_usuario_codigoliberou)
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefretetp_codigo = '20'
       and ca.con_calcvalefrete_dtliberacao is not null;
*/
      -- Atualiza as Tarifas
     update t_con_calcvalefrete ca
       set ca.glb_rota_codigocx = (select calc.glb_rota_codigocx
                                   from tdvadm.t_con_calcvalefrete calc
--                                        ,tdvadm.t_glb_rota rt
--                                        ,tdvadm.t_usu_usuario u
                                   where calc.con_conhecimento_codigo = ca.con_conhecimento_codigo
                                     and calc.con_conhecimento_serie = ca.con_conhecimento_serie
                                     and calc.glb_rota_codigo = ca.glb_rota_codigo
                                     and calc.con_valefrete_saque = ca.con_valefrete_saque
                                     and calc.con_calcvalefretetp_codigo =  '01'
                                     and nvl(calc.glb_rota_codigocx,'999') <> '999'
--                                     and u.usu_usuario_codigo = ca.usu_usuario_codigopgto
--                                     and rt.glb_rota_codigo = u.glb_rota_codigo
                                  )
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefretetp_codigo in ('06','07')
--       and ca.con_calcvalefrete_dtpgto is not null
       ;

     update t_con_calcvalefrete ca
       set ca.glb_rota_codigocx = (select calc.glb_rota_codigocx
                                   from tdvadm.t_con_calcvalefrete calc
--                                        ,tdvadm.t_glb_rota rt,
--                                        ,tdvadm.t_usu_usuario u
                                   where calc.con_conhecimento_codigo = ca.con_conhecimento_codigo
                                     and calc.con_conhecimento_serie = ca.con_conhecimento_serie
                                     and calc.glb_rota_codigo = ca.glb_rota_codigo
                                     and calc.con_valefrete_saque = ca.con_valefrete_saque
                                     and calc.con_calcvalefretetp_codigo =  '20'
                                     and nvl(calc.glb_rota_codigocx,'999') <> '999'
--                                     and u.usu_usuario_codigo = ca.usu_usuario_codigopgto
--                                     and rt.glb_rota_codigo = u.glb_rota_codigo
                                   )
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefretetp_codigo in ('06','07')
--       and ca.con_calcvalefrete_dtpgto is not null
       ;

     commit;


     /*

     select distinct ca.con_calcvalefretetp_codigo
     from  t_con_calcvalefrete ca
     where nvl(ca.glb_rota_codigocx,'999') = '999'
       and ca.con_calcvalefrete_tipo = 'C'
       and ca.usu_usuario_bloqueou is null
       and ca.con_calcvalefrete_dtliberacao is not null;
     */


 --   inicializa as Variaveis

    vHoraAtual := sysdate;
--    vHoraAtual := to_date(TRUNC(NVL(pDataProc,SYSDATE)) || ' 15:30:00','DD/MM/YYYY HH24:MI:SS');
    vHoraAtual := to_date(TRUNC(SYSDATE) || ' 15:30:00','DD/MM/YYYY HH24:MI:SS');
    vAuxiliar          := 0;
--    vDataProcessamento := NVL(TRUNC(NVL(pDataProc,SYSDATE)),to_char(vHoraAtual,'DD/MM/YYYY'));
    vDataProcessamento := NVL(TRUNC(SYSDATE),to_char(vHoraAtual,'DD/MM/YYYY'));
    vHorarioCorte      := '15:30:00';
    vfiltro            :=  to_char(to_date(vDataProcessamento,'dd/mm/yyyy'),'yyyymmdd')||'153000';
    
    
    
    -- verifica se existe alguem no primeiro corte
    select count(*)
      into vAuxiliar
    from tdvadm.t_con_calcvalefrete ca,
         tdvadm.t_con_valefrete vf
    where 0 = 0
      and ca.con_conhecimento_codigo = vf.con_conhecimento_codigo
      and ca.con_conhecimento_serie  = vf.con_conhecimento_serie
      and ca.glb_rota_codigo         = vf.glb_rota_codigo
      and ca.con_valefrete_saque     = vf.con_valefrete_saque
      and nvl(vf.con_valefrete_status,'N') <> 'C'
      and nvl(ca.glb_rota_codigocx,'999') <> '999'
      and ca.cax_boletim_data is null
      and ca.con_calcvalefretetp_codigo in ('01','20')
      and ca.con_calcvalefrete_valor > 0
      AND Ca.CON_CALCVALEFRETE_TIPO = 'C'
      and ca.cax_boletim_data is null
      and to_char(ca.con_calcvalefrete_dtpgto,'yyyymmddhh24miss') <= vfiltro;

     if vAuxiliar = 0 and ( TO_char(vHoraAtual,'YYYYMMDDhh24miss') >  vfiltro )

     Then
        vDataProcessamento := f_diautil_proximo(to_date(vDataProcessamento,'dd/mm/yyyy') + 1);
        vfiltro            :=  to_char(to_date(vDataProcessamento,'dd/mm/yyyy'),'yyyymmdd')||'153000';
        -- Calcula a quantidade novamente
        select count(*)
          into vAuxiliar
        from t_con_calcvalefrete ca,
             t_con_valefrete vf
        where 0 = 0
          and ca.con_conhecimento_codigo = vf.con_conhecimento_codigo
          and ca.con_conhecimento_serie  = vf.con_conhecimento_serie
          and ca.glb_rota_codigo         = vf.glb_rota_codigo
          and ca.con_valefrete_saque     = vf.con_valefrete_saque
          and nvl(vf.con_valefrete_status,'N') <> 'C'
          and nvl(ca.glb_rota_codigocx,'999') <> '999'
          and ca.cax_boletim_data is null
          and ca.con_calcvalefretetp_codigo in ('01','20')
          and ca.con_calcvalefrete_valor > 0
          AND Ca.CON_CALCVALEFRETE_TIPO = 'C'
          and to_char(ca.con_calcvalefrete_dtpgto,'yyyymmddhh24miss') <= vfiltro;

     End if;



     FOR vCursor1 in (select ca.glb_rota_codigocx Rota,
                             count(*) qtde,
                             max(vHoraAtual) data
                        from t_con_calcvalefrete ca,
                             t_con_valefrete vf
                       where 0 = 0
                         and ca.con_conhecimento_codigo                               = vf.con_conhecimento_codigo
                         and ca.con_conhecimento_serie                                = vf.con_conhecimento_serie
                         and ca.glb_rota_codigo                                       = vf.glb_rota_codigo
                         and ca.con_valefrete_saque                                   = vf.con_valefrete_saque
                         and nvl(vf.con_valefrete_status,'N')                         <> 'C'
                         and ca.glb_rota_codigocx                                     <> '999'
                         and ca.cax_boletim_data                                      is null
                         and ca.con_calcvalefretetp_codigo in ('01','20')
                         and to_char(ca.con_calcvalefrete_dtpgto,'yyyymmddhh24miss')  <= vfiltro
                         group by ca.glb_rota_codigocx)
     loop
       
       begin
         
         vfiltro := vfiltro;
         If vCursor1.Rota = '917' Then
            vCursor1.Rota := vCursor1.Rota;
         End If;
-- Verificando janela de Corte de Horario
         PKG_CON_VALEFRETE.SP_CON_FRETECAIXA(vCursor1.Rota,vDataProcessamento,vDataProcessamento,'S','S','N');
-- Sem verificar janela 
--         PKG_CON_VALEFRETE.SP_CON_FRETECAIXA(vCursor1.Rota,vDataProcessamento,vDataProcessamento,'S','N','N');
         
       exception when OTHERS then
           
           vErro := '';
           vErro := 'Verifique erro na Rota - ' ||  vCursor1.Rota || ' Deixou de fazer ' || vCursor1.qtde || ' Lançamentos...' || chr(10) ||
                    'Rodei a procedure abaixo :' || chr(10) ||
                    '***********************************************************************' || chr(10) ||

                    'exec  PKG_CON_VALEFRETE.SP_CON_FRETECAIXA(' ||  pkg_glb_common.fn_QuotedStr(vCursor1.Rota) || ',' || pkg_glb_common.fn_QuotedStr(vDataProcessamento) || ',' || pkg_glb_common.fn_QuotedStr(vDataProcessamento) || ',''S'',''S'',''N'');' || chr(10) ||
                    '***********************************************************************' || chr(10) ||
                    'Erros Abaixo ...' || chr(10) ||
                    '***********************************************************************' || chr(10) ||
                    dbms_utility.format_call_stack ||
                    '***********************************************************************' || chr(10) ||
                    sqlerrm || chr(10) ||
                    '***********************************************************************' ;

           WSERVICE.PKG_GLB_EMAIL.SP_ENVIAEMAIL('ERRO PROCESAMENTO FRETE ELETRONICO x CAIXA',
                                                 vErro,
                                                 'aut-e@dellavolpe.com.br',
                                                 'sirlano.drumond@dellavolpe.com.br');
       end;

     End Loop;


       update t_cax_boletim_trava t
         set  t.cax_boletim_qtd = (select count(*)
                                   from t_cax_boletim b
                                   where b.glb_rota_codigo = t.glb_rota_codigo
                                     and b.cax_boletim_status in ('A','R'));
       
       commit;
       
       
     SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_CON_ATUALIZACAIXA','N');
     SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_CON_ATUALIZACAIXAFIM',to_date(sysdate,'dd/mm/yyyy hh24:mi:ss'));
       
       
 End SP_CON_ATUALIZACAIXA;




 ------------------------------------------------------------------------------------------------------------------------
 -- Função utilizada para saber se um Conhecimento possui uma embalagem de transfereência.                             --
 ------------------------------------------------------------------------------------------------------------------------
 Function FN_Get_EmbTransferencia(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                  pCon_conhecimento_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                  pGlb_rota_codigo in tdvadm.t_con_conhecimento.glb_rota_codigo%type ) return char is
  --Variável de controle
  vControl integer;
  vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
 begin
   vControl := 0;

   Begin
     --Verifico primeiro se o CTRC passado possui um carregamento.

    begin
       select ctrc.arm_carregamento_codigo
         into vCarregamento
         from t_con_conhecimento ctrc
        where ctrc.con_conhecimento_codigo = pCon_conhecimento_codigo
          and ctrc.con_conhecimento_serie = pCon_conhecimento_serie
          and ctrc.glb_rota_codigo = pGlb_rota_codigo
          and ctrc.arm_carregamento_codigo is not null;
       vControl := 1;
     exception
       when NO_DATA_FOUND Then
          vControl  := 0;
          vCarregamento := null;
       end ;
     --caso a variável retorno zero, é porque o CTRC não possui um carregamento.
     if ( vControl = 0 ) then
       -- Encerro o processamento, o
       return tdvadm.pkg_glb_common.Boolean_Nao;
     end if;

     --Caso o CTRC possua um carregamento
     if ( vControl > 0 ) then
       vControl := 0;

       --verifico se a embalagem é de transferência.
       select
         COUNT(*) INTO vControl
       from
         T_ARM_NOTA NOTA,
         T_ARM_CARREGAMENTODET CARREGDET
       where
         0=0
         AND NOTA.CON_CONHECIMENTO_CODIGO = pCon_conhecimento_codigo
         AND NOTA.CON_CONHECIMENTO_SERIE = pCon_conhecimento_serie
         AND NOTA.GLB_ROTA_CODIGO = pGlb_rota_codigo

         AND NOTA.ARM_EMBALAGEM_NUMERO = CARREGDET.ARM_EMBALAGEM_NUMERO
         AND NOTA.ARM_EMBALAGEM_FLAG = CARREGDET.ARM_EMBALAGEM_FLAG
         AND NOTA.ARM_EMBALAGEM_SEQUENCIA = CARREGDET.ARM_EMBALAGEM_SEQUENCIA
         and carregdet.arm_carregamento_codigo = vCarregamento

         AND CARREGDET.ARM_ARMAZEM_CODIGO_TRANSF IS NOT NULL;

         --Caso tenha algum registro, decido se retorno como sim ou não.
         if ( vControl > 0 ) then
           return tdvadm.pkg_glb_common.Boolean_Sim;

        else
           return tdvadm.pkg_glb_common.Boolean_Nao;
         end if;
     end if;

   Exception
     --caso ocorra algum erro não previsto.
     when others then
       raise_application_error(-20001, 'Erro ao validar transferência' || chr(13) || sqlerrm);
   end;

 end FN_Get_EmbTransferencia ;

 Function FN_Get_EmbTransferencia2(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                   pCon_conhecimento_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                   pGlb_rota_codigo in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                   pDataaSerVerificada in char default trunc(sysdate) ,
                                   pRetorno char default 'T') return char is
  --Variável de controle
  vControl            integer;
  vCarregamento       tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
  vDataaSerVerificada CHAR(10) := nvl(pDataaSerVerificada,trunc(sysdate));
  vRetorno            varchar2(30);
  vChave              varchar2(30);
  vContador           number;
  vArmTransferencia   tdvadm.t_arm_carregamentodet.arm_armazem_codigo_transf%type;
  vFlagTransf         tdvadm.t_arm_carregamentodet.arm_carregamentodet_flagtrans%type;
  vArmCarreg          tdvadm.t_arm_armazem.arm_armazem_codigo%type;
  vArmNota            tdvadm.t_arm_armazem.arm_armazem_codigo%type;
  vCarregDevolucao    tdvadm.t_arm_carregamento.ARM_CARREGAMENTO_CODIGO%type;
  vRotaArmazem        tdvadm.t_glb_rota.glb_rota_codigo%type;
  vRotaCte            tdvadm.t_glb_rota.glb_rota_codigo%type;
  vErro               varchar2(5000);
  vAuxiliar           number;
  PRAGMA AUTONOMOUS_TRANSACTION;

 begin
--   insert into dropme (a,x) values ('TesteTrans', pCon_conhecimento_codigo || ' - ' || pCon_conhecimento_serie || ' - ' || pGlb_rota_codigo || ' - ' || pDataaSerVerificada);
--   commit;
   vControl := 0;
   
   Begin

   SELECT N.CON_CONHECIMENTO_CODIGO                || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO ,
          count(DISTINCT N.CON_CONHECIMENTO_CODIGO || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO),
          det.arm_carregamentodet_flagtrans,
          DET.arm_armazem_codigo_transf,
          ca.arm_armazem_codigo armcarreg,
          n.arm_armazem_codigo armnota,
          nvl(C.ARM_CARREGAMENTO_CODIGO, 'Devoluc') CARREGAMENTO,
          AM.GLB_ROTA_CODIGO ROTAARM,C.GLB_ROTA_CODIGO ROTACTE
          --         Decode(nvl(DET.arm_armazem_codigo_transf, 'R'),'R',Decode(ca.arm_armazem_codigo,n.arm_armazem_codigo,Decode(nvl(C.ARM_CARREGAMENTO_CODIGO, 'D'),'D','Devolucao','Não'),DECODE(AM.GLB_ROTA_CODIGO,C.GLB_ROTA_CODIGO,'Transf. chekin feito','Normal')),'Sim') Transferencia

 /*  SELECT N.CON_CONHECIMENTO_CODIGO                || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO ,
          count(DISTINCT N.CON_CONHECIMENTO_CODIGO || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO),
         Decode(nvl(DET.arm_armazem_codigo_transf, 'R'),'R',Decode(ca.arm_armazem_codigo,n.arm_armazem_codigo,Decode(nvl(C.ARM_CARREGAMENTO_CODIGO, 'D'),'D','Devolucao','Não'),DECODE(AM.GLB_ROTA_CODIGO,C.GLB_ROTA_CODIGO,'Transf. chekin feito','Normal')),'Sim') Transferencia
 */
     into vChave   ,
          vContador,
          vFlagTransf,
          vArmTransferencia,
          vArmCarreg,
          vArmNota,
          vCarregDevolucao,
          vRotaArmazem,
          vRotaCte
 --         ,vRetorno
     from t_arm_nota n,
          t_arm_carregamentodet det,
          t_arm_carregamento     ca,
          t_con_conhecimento      c,
          t_arm_armazem          am,
          t_arm_embalagem       emb
     where 0 = 0
       and ca.arm_armazem_codigo          = am.arm_armazem_codigo
       and n.arm_embalagem_numero         = det.arm_embalagem_numero
       and n.arm_embalagem_flag           = det.arm_embalagem_flag
       and n.arm_embalagem_sequencia      = det.arm_embalagem_sequencia
       and det.arm_carregamento_codigo    = ca.arm_carregamento_codigo
       and n.con_conhecimento_codigo      = c.con_conhecimento_codigo
       and n.con_conhecimento_serie       = c.con_conhecimento_serie
       and n.glb_rota_codigo              = c.glb_rota_codigo
       and emb.arm_embalagem_numero        = n.arm_embalagem_numero
       and emb.arm_embalagem_flag          = n.arm_embalagem_flag
       and emb.arm_embalagem_sequencia     = n.arm_embalagem_sequencia
       and trim(n.con_conhecimento_codigo)= trim(pCon_conhecimento_codigo)
       and n.con_conhecimento_serie       = pCon_conhecimento_serie
       and n.glb_rota_codigo              = pGlb_rota_codigo
        and ca.arm_carregamento_codigo    = (select max(cc.arm_carregamento_codigo)
                                              from t_arm_carregamentodet t,
                                                   t_arm_carregamento cc
                                              where T.arm_embalagem_numero    = DET.arm_embalagem_numero   
                                                AND t.arm_embalagem_flag      = DET.arm_embalagem_flag     
                                                AND t.arm_embalagem_sequencia = DET.arm_embalagem_sequencia
                                                and t.arm_carregamento_codigo = cc.arm_carregamento_codigo
                                                and cc.arm_armazem_codigo     = emb.arm_armazem_codigo
                                             )
       /*and ca.arm_carregamento_codigo     = (select t.arm_carregamento_codigo
                                             from t_arm_carregamento t
                                             where t.arm_carregamento_codigo = ca.arm_carregamento_codigo
                                             and t.arm_armazem_codigo = emb.arm_armazem_codigo)*/
       /*
       and ca.arm_carregamento_codigo     =  (select cc.arm_carregamento_codigo
                                               from t_arm_carregamento cc,
                                                     t_arm_carregamentodet det1
                                            where 0 =0
                                              and trunc(cc.arm_carregamento_dtcria) <= nvl(pDataaSerVerificada,trunc(sysdate))
                                              and det1.arm_carregamento_codigo        = cc.arm_carregamento_codigo
                                              and det1.arm_embalagem_numero           = n.arm_embalagem_numero
                                              and det1.arm_embalagem_flag             = n.arm_embalagem_flag
                                              and det1.arm_embalagem_sequencia        = n.arm_embalagem_sequencia
                                              and cc.arm_carregamento_dtcria         = (select max(cc1.arm_carregamento_dtcria)
                                                                                       from t_arm_carregamento cc1,
                                                                                            t_arm_carregamentodet det1
                                                                                        where 0 =0
                                                                                          and trunc(cc1.arm_carregamento_dtcria) <= nvl(pDataaSerVerificada,trunc(sysdate))
                                                                                          and det1.arm_carregamento_codigo        = cc1.arm_carregamento_codigo
                                                                                          and det1.arm_embalagem_numero           = n.arm_embalagem_numero
                                                                                          and det1.arm_embalagem_flag             = n.arm_embalagem_flag
                                                                                          and det1.arm_embalagem_sequencia        = n.arm_embalagem_sequencia
                                                                                          and emb.arm_armazem_codigo              = cc1.arm_armazem_codigo))*/

       group by N.CON_CONHECIMENTO_CODIGO || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO,
                det.arm_carregamentodet_flagtrans,
                DET.arm_armazem_codigo_transf,
                ca.arm_armazem_codigo,
                n.arm_armazem_codigo,
                nvl(C.ARM_CARREGAMENTO_CODIGO, 'Devoluc'),
                AM.GLB_ROTA_CODIGO,
                C.GLB_ROTA_CODIGO;
                --              Decode(nvl(DET.arm_armazem_codigo_transf, 'R'),'R',Decode(ca.arm_armazem_codigo,n.arm_armazem_codigo,Decode(nvl(C.ARM_CARREGAMENTO_CODIGO, 'D'),'D','Devolucao','Não'),DECODE(AM.GLB_ROTA_CODIGO,C.GLB_ROTA_CODIGO,'Transf. chekin feito','Normal')),'Sim');

       if vContador > 1 Then
          vRetorno := vChave;
       End If;

      if nvl(vArmTransferencia,'R') = 'R' Then
          if vArmCarreg = vArmNota  Then
             if nvl(vCarregDevolucao,'D') = 'D' Then
                vRetorno := 'Devolucao';
              Else
                vRetorno := 'Não';
              End If;
           Else
              if vRotaArmazem = vRotaCte then
                 vRetorno := 'Transf. chekin feito';
              Else
                vRetorno := 'Não' ;
              End If;
          End If;
      Else
        if nvl(vFlagTransf,'X') = 'S' Then
           vRetorno := 'Sim';
        Else
           vRetorno := 'Transf. chekin feito';
        End If;   
       End If  ;




   Exception
     --When NO_DATA_FOUND Then
     --caso ocorra algum erro não previsto.
     --w
    /* WHEN TOO_MANY_ROWS then
       
       select *
       from t_arm_nota ta
       
       where ta.con_conhecimento_codigo = pCon_conhecimento_codigo
         and ta.con_conhecimento_serie  = pCon_conhecimento_serie
         and ta.glb_rota_codigo         = pGlb_rota_codigo;*/
       
--     when others then
     when TOO_MANY_ROWS then
          
          
          
          select t.arm_carregamento_codigo
            into vCarregamento
          from t_con_conhecimento t
          where t.con_conhecimento_codigo = pCon_conhecimento_codigo
            and t.con_conhecimento_serie = pCon_conhecimento_serie
            and t.glb_rota_codigo = pGlb_rota_codigo;
            
         if vCarregamento is not null then
           --Montagem da mensagem de erro.
           vErro := 'Erro ao definir Transferencia! Favor Analisar as Embalagens Abaixo: ' || chr(13) || ' - Ambas Devem estar no mesmo carregamento e transferidas!' || chr(13);
           vAuxiliar := 0;
           for i in (
                      select *
                      from t_Arm_nota ta
                      where ta.con_conhecimento_codigo= pCon_conhecimento_codigo
                        and ta.con_conhecimento_serie = pCon_conhecimento_serie
                        and ta.glb_rota_codigo        = pGlb_rota_codigo)
           loop
               vAuxiliar := vAuxiliar + 1; 
               vErro :=  vErro || ' Embalagem: ' || i.arm_embalagem_numero  || ' Seq - ' || i.arm_embalagem_sequencia || '-' || pCon_conhecimento_codigo || '-' || pGlb_rota_codigo || chr(13);
             
           end loop;
           
           if vAuxiliar > 1 then
            
              vErro := vErro || ' Essas Embalagens pertencem ao conhecimento ' || pCon_conhecimento_codigo || '-' || pGlb_rota_codigo || chr(13);
              RAISE_APPLICATION_ERROR(-20001, vErro || sqlerrm || chr(13) || dbms_utility.format_error_stack);            
           end if;
         end if;
            
         insert into t_log_system (usu_aplicacao_codigo,
                                       log_system_datahora, 
                                       log_tipo_codigo, 
                                       log_system_message ) 
             values ('comvlfrete',
                     sysdate,
                     'I',
                     'Erro ao tentar definir transferencia - ' || pCon_conhecimento_codigo || ' - ' || pGlb_rota_codigo);
          commit;
         vRetorno := 'Não';
      end;

   if nvl(pRetorno,'T') = 'T' Then
      return nvl(vRetorno,'N');
   Else
      return vArmTransferencia;

  End If;

 end FN_Get_EmbTransferencia2 ;


 Function FN_Get_SaqueCheckin(pCon_Valefrete_codigo    in tdvadm.t_con_vfreteconhec.con_valefrete_codigo%type,
                              pGlb_Valefrete_rota      in tdvadm.t_con_vfreteconhec.glb_rota_codigovalefrete%type,
                              pCon_ValeFrete_serie     in tdvadm.t_con_vfreteconhec.con_valefrete_serie%type,
                              pCon_Valefrete_Saque     in tdvadm.t_con_vfreteconhec.con_valefrete_saque%type,
                              pCon_conhecimento_codigo in tdvadm.t_con_vfreteconhec.con_conhecimento_codigo%type,
                              pCon_conhecimento_serie  in tdvadm.t_con_vfreteconhec.con_conhecimento_serie%type,
                              pGlb_rota_codigo         in tdvadm.t_con_vfreteconhec.glb_rota_codigo%type
                             ) return char is
                             
    -- Retornos ST - Sem transferencia
    --          SC - Sem Checkin                             
    --          CF - Checkin Feito

   vArmazemNota       tdvadm.t_glb_rota.glb_rota_codigo%type;
   vArmazemValeFrete  tdvadm.t_glb_rota.glb_rota_codigo%type;
   vArmazemEmbalagem  tdvadm.t_glb_rota.glb_rota_codigo%type;
   vAuxiliar          number;
   vNotaSequencia     tdvadm.t_arm_nota.arm_nota_sequencia%type;
   vCarregamento      tdvadm.t_con_conhecimento.arm_carregamento_codigo%type;
 Begin

     
     Select count(*)
       into vAuxiliar
     from tdvadm.t_arm_carregamentodet cd,
          tdvadm.t_arm_nota an
     where cd.arm_embalagem_numero = an.arm_embalagem_numero
       and cd.arm_embalagem_flag = an.arm_embalagem_flag
       and cd.arm_embalagem_sequencia = an.arm_embalagem_sequencia
       and an.arm_nota_sequencia = vNotaSequencia
       and cd.arm_carregamento_codigo = vCarregamento
       and cd.arm_armazem_codigo_transf is not null;
       
     -- Não Tem Transferencia  
     If vAuxiliar = 0 Then
        return 'ST';
     end If;
       
   
   Begin
   select vfc.arm_armazem_codigo
     into vArmazemNota
   from tdvadm.t_con_vfreteconhec vfc
   where vfc.con_valefrete_codigo = pCon_Valefrete_codigo
     and vfc.con_valefrete_serie = pCon_ValeFrete_serie
     and vfc.glb_rota_codigovalefrete = pGlb_Valefrete_rota
     and vfc.con_valefrete_saque = pCon_Valefrete_Saque
     and vfc.con_conhecimento_codigo = pCon_conhecimento_codigo 
     and vfc.con_conhecimento_serie = pCon_conhecimento_serie
     and vfc.glb_rota_codigo = pGlb_rota_codigo
     and vfc.arm_armazem_codigo is not null;
     vAuxiliar := 1;
   Exception
     When NO_DATA_FOUND Then
        vAuxiliar := 0;
     End ;  

   If vAuxiliar = 0 Then
      return 'ST'; -- Sem transferencia
   End If;

   Begin
       select an.arm_armazem_codigo,
              an.arm_nota_sequencia
          into vArmazemNota,
               vNotaSequencia
       from tdvadm.t_arm_notacte an
       where an.con_conhecimento_codigo = pCon_conhecimento_codigo
         and an.con_conhecimento_serie = pCon_conhecimento_serie
         and an.glb_rota_codigo = pGlb_rota_codigo
         and an.arm_notacte_codigo IN ('NO','DE','RE')
         AND ROWNUM = 1;
   exception
     -- Se não Achar nenhum Registro e porque foi feito pela digitacao Manual
     When NO_DATA_FOUND Then
        return 'ST'; -- Sem transferencia
     End;

   Begin
      select a.arm_armazem_codigo
        into vArmazemValeFrete
      from tdvadm.t_arm_armazem a
      where a.glb_rota_codigo = pGlb_Valefrete_rota
        and nvl(a.arm_armazem_ativo,'N') = 'S';  
   exception
     When NO_DATA_FOUND Then
        return 'ST'; -- Sem transferencia
     End;
    

   Begin
     Select eb.arm_armazem_codigo
       into vArmazemEmbalagem
     from tdvadm.t_arm_nota an,
          tdvadm.t_arm_embalagem eb
     where an.arm_nota_sequencia = vNotaSequencia
       and an.arm_embalagem_numero = eb.arm_embalagem_numero
       and an.arm_embalagem_flag = eb.arm_embalagem_flag
       and an.arm_embalagem_sequencia = eb.arm_embalagem_sequencia;
   exception
     When NO_DATA_FOUND Then
        return 'ST'; -- Sem transferencia
     End;
     
     Begin
        select c.arm_carregamento_codigo
          into vCarregamento
        from tdvadm.t_con_conhecimento c
        where c.con_conhecimento_codigo = pCon_conhecimento_codigo
          and c.con_conhecimento_serie = pCon_conhecimento_serie
          and c.glb_rota_codigo = pGlb_rota_codigo;
       
     exception
       When NO_DATA_FOUND Then
           vCarregamento := '';
           return 'ST';
       End;
 
    If vArmazemEmbalagem = vArmazemValeFrete Then
        return 'SC'; -- Sem Checkin
    ElsIf nvl(vArmazemEmbalagem,'XX') <> vArmazemValeFrete Then
        Return 'CF'; -- Checkin Feito
    End If;     

    return 'SC'; -- Sem Checkin
   
 End FN_Get_SaqueCheckin;



 Function FN_Get_EmbCheckin(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                            pCon_conhecimento_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                            pGlb_rota_codigo in tdvadm.t_con_conhecimento.glb_rota_codigo%type ) return char is

 begin

     return tdvadm.pkg_glb_common.Boolean_Nao;

 end FN_Get_EmbCheckin;


 Function FN_Get_Pagamento(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                           pCon_conhecimento_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                           pGlb_rota_codigo         in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                           pCon_Valefrete_Saque     in tdvadm.t_con_valefrete.con_valefrete_saque%type,
                           pCon_Calcvalefrete_Tipo  in tdvadm.t_con_calcvalefrete.con_calcvalefrete_tipo%type  default '20'
                            ) return char is

     CURSOR C_CURSOR IS SELECT M.GLB_ROTA_CODIGO RTCAX,
                               to_char(M.CAX_BOLETIM_DATA,'dd/mm/yyyy') BOLETIM,
                               M.CAX_MOVIMENTO_SEQUENCIA SEQ,
                               M.CAX_OPERACAO_CODIGO OPERACAO,
                               M.GLB_ROTA_CODIGO_OPERACAO RTOPER
                        FROM T_CAX_MOVIMENTO M
                        WHERE M.CAX_MOVIMENTO_DOCUMENTO            = RPAD(TRIM(pCon_conhecimento_codigo),10)
                          AND M.CAX_MOVIMENTO_SERIE                = RPAD(TRIM(pCon_conhecimento_serie),2)
                          AND M.GLB_ROTA_CODIGO_REFERENCIA         = pGlb_rota_codigo
                          AND TRIM(M.CAX_MOVIMENTO_DOCCOMPLEMENTO) = TRIM(pCon_Valefrete_Saque)   ;

     TpCursor  C_CURSOR%ROWTYPE;
     vContador  number;
     vPgtoSemTransf varchar2(100);
 begin

     -- pCon_Calcvalefrete_Tipo vide os tipos na Tabela t_Con_Calcvalefrete_Tipo
     -- Default Saldo

     -- Retorno
     -- Modo se foi eletronico (cartão) ou Cheque P Previsao pagou so na gerenciadora
     -- Chave com Rota/Boletim/Seq/Modo
     -- Rota do caixa
     -- Boletim é a data do caixa
     -- Seq e a sequencia do lançamento

       vContador := 0;

       open C_CURSOR;
       loop
          fetch C_CURSOR into TpCursor;
          exit when C_CURSOR%notfound;
          vContador := vContador + 1;
         IF   pCon_Calcvalefrete_Tipo = '01' Then -- Adiantamento
            if    TpCursor.operacao in ('2002') then -- Cheque Carreteiro
                return 'H' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            ElsIf TpCursor.operacao in ('2203') then -- Eletronico Carreteiro
                return 'C' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            Elsif TpCursor.operacao in ('2168') then -- Cheque Frota
                return 'H' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            ElsIf TpCursor.operacao in ('2208') then -- Eletronico Frota
                return 'C' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            Else
                Begin
                    select 'P' || '*' || cv.glb_rota_codigocx || '*' || cv.con_calcvalefrete_dtpgto || '*' || pCon_Calcvalefrete_Tipo
                      into vPgtoSemTransf
                    from t_con_calcvalefrete cv
                    where cv.con_conhecimento_codigo = pCon_conhecimento_codigo
                      and cv.con_conhecimento_serie  = pCon_conhecimento_serie
                      and cv.glb_rota_codigo         = pGlb_rota_codigo
                      and cv.con_valefrete_saque     = pCon_Valefrete_Saque
                      and cv.con_calcvalefretetp_codigo = pCon_Calcvalefrete_Tipo
                      and cv.con_calcvalefrete_dtpgto is not null;
                      vContador := vContador + 1;
                      return vPgtoSemTransf;
                exception
                      when NO_DATA_FOUND then
                          vPgtoSemTransf := '';
                end;
            End if;
        ElsIf pCon_Calcvalefrete_Tipo = '02' Then  -- Pedagio
            if    TpCursor.operacao in ('2545') then -- Cheque Carreteiro
                return 'H' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            ElsIf TpCursor.operacao in ('2227') then -- Eletronico Carreteiro
                return 'C' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            Elsif TpCursor.operacao in ('2058') then -- Cheque Frota
                return 'H' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            ElsIf TpCursor.operacao in ('2228') then -- Eletronico Frota
                return 'C' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            Else
                Begin
                    select 'P' || '*' || cv.glb_rota_codigocx || '*' || cv.con_calcvalefrete_dtpgto || '*' || pCon_Calcvalefrete_Tipo
                      into vPgtoSemTransf
                    from t_con_calcvalefrete cv
                    where cv.con_conhecimento_codigo = pCon_conhecimento_codigo
                      and cv.con_conhecimento_serie  = pCon_conhecimento_serie
                      and cv.glb_rota_codigo         = pGlb_rota_codigo
                      and cv.con_valefrete_saque     = pCon_Valefrete_Saque
                      and cv.con_calcvalefretetp_codigo = pCon_Calcvalefrete_Tipo
                      and cv.con_calcvalefrete_dtpgto is not null;
                      vContador := vContador + 1;
                      return vPgtoSemTransf;
                exception
                      when NO_DATA_FOUND then
                          vPgtoSemTransf := '';
                end;
            End if;
        ElsIf pCon_Calcvalefrete_Tipo = '20' Then  -- Saldo
            if    TpCursor.operacao in ('2001') then -- Cheque Carreteiro
                return 'H' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            ElsIf TpCursor.operacao in ('2201') then -- Eletronico Carreteiro
                return 'C' || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
            Else
                Begin
                    select 'P' || '*' || cv.glb_rota_codigocx || '*' || cv.con_calcvalefrete_dtpgto || '*' || pCon_Calcvalefrete_Tipo
                      into vPgtoSemTransf
                    from t_con_calcvalefrete cv
                    where cv.con_conhecimento_codigo = pCon_conhecimento_codigo
                      and cv.con_conhecimento_serie  = pCon_conhecimento_serie
                      and cv.glb_rota_codigo         = pGlb_rota_codigo
                      and cv.con_valefrete_saque     = pCon_Valefrete_Saque
                      and cv.con_calcvalefretetp_codigo = pCon_Calcvalefrete_Tipo
                      and cv.con_calcvalefrete_dtpgto is not null;
                      vContador := vContador + 1;
                      return vPgtoSemTransf;
                exception
                      when NO_DATA_FOUND then
                          vPgtoSemTransf := '';
                end;
            End if;
        End If;

       END LOOP;

       If vContador > 0 Then
           -- SE NÃO ACHOU NADA NO LOOP RETORNA ESTE
          return 'X' || trim(to_char(vContador)) || '*' || TpCursor.Rtcax || '*' || TpCursor.BOLETIM  || '*' || TpCursor.SEQ || '*' || TpCursor.OPERACAO ;
       Else
          Return 'X0****';
       End if;

 end FN_Get_Pagamento;


   PROCEDURE SP_CON_VFPODEIMPRIMIR(  P_APLIACACAO     IN  TDVADM.T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE,
                                     P_ROTA           IN  TDVADM.T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                     P_USUARIO        IN  TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                     p_VfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                     p_VfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                     p_VfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                     p_VfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%TYPE,
                                     P_PODEIMPRIMIR   OUT CHAR,
                                     P_STATUS         OUT CHAR,
                                     P_MESSAGE        OUT VARCHAR2) IS
   vVfreteCiot    T_CON_VFRETECIOT%ROWTYPE;
   vExisteSolCiot INTEGER;
   vAuxiliar      integer;
   BEGIN

    BEGIN

        SELECT COUNT(*)
          INTO vExisteSolCiot
          FROM T_CON_VFRETESOLCIOT L
         WHERE L.CON_CONHECIMENTO_CODIGO = p_VfreteCodigo
           AND l.con_conhecimento_serie  = p_VfreteSerie
           AND L.GLB_ROTA_CODIGO         = p_VfreteRota
           AND L.CON_VALEFRETE_SAQUE     = p_VfreteSaque;


         IF vExisteSolCiot = 0 THEN
            P_PODEIMPRIMIR := 'S';
            P_STATUS       := pkg_glb_common.Status_Nomal;
            P_MESSAGE      := ''; --Processamento Normal';

        ELSE
            P_PODEIMPRIMIR := 'N';
            P_STATUS       := pkg_glb_common.Status_Warning;
            P_MESSAGE      := 'Existe solicitação de CIOT em andamento, por favor aguarde!';
         END IF;


         BEGIN

            SELECT *
              INTO vVfreteCiot
              FROM T_CON_VFRETECIOT L
              WHERE L.CON_CONHECIMENTO_CODIGO  = p_VfreteCodigo
                AND L.CON_CONHECIMENTO_SERIE   = p_VfreteSerie
                AND L.GLB_ROTA_CODIGO          = p_VfreteRota
                AND L.CON_VALEFRETE_SAQUE      = p_VfreteSaque;

         EXCEPTION WHEN OTHERS THEN
             P_STATUS   := pkg_glb_common.Status_Erro;
             P_MESSAGE  := 'Viagem não possue CIOT!';
         END;

         IF vVfreteCiot.Con_Vfreteciot_Flagimprime = 'S' THEN
            P_PODEIMPRIMIR := 'S';
            P_STATUS       := pkg_glb_common.Status_Nomal;
            P_MESSAGE      := ''; --Processamento Normal';

        ELSE
            P_PODEIMPRIMIR := 'N';
            P_STATUS       := pkg_glb_common.Status_Warning;
            P_MESSAGE      := 'Vale de frete de frete não esta liberado para impressão!';
         END IF;
         
         
         select count(*)
           into vAuxiliar
         from tdvadm.t_con_valefrete vf, 
              tdvadm.t_car_veiculo v
         where vf.con_conhecimento_codigo = p_VfreteCodigo
           and vf.con_conhecimento_serie = p_VfreteSerie
           and vf.glb_rota_codigo = p_VfreteRota
           and vf.con_valefrete_saque = p_VfreteSaque
           and vf.con_valefrete_placa = v.car_veiculo_placa
           and vf.con_valefrete_placasaque = v.car_veiculo_saque
           and length(trim(v.car_proprietario_cgccpfcodigo)) = 11
           and nvl(vf.con_valefrete_sestsenat,0) = 0; 

        If vAuxiliar > 0 Then
            P_PODEIMPRIMIR := 'N';
            P_STATUS       := pkg_glb_common.Status_Erro;
            P_MESSAGE      := 'Vale de frete semcalculo de SEST/SENAT!';
        end IF;

     EXCEPTION
       WHEN OTHERS THEN
       BEGIN
           P_STATUS   := pkg_glb_common.Status_Erro;
           P_MESSAGE  := 'Erro';

      END;
     END;


   END SP_CON_VFPODEIMPRIMIR;


   PROCEDURE SP_GETIDVALIDOALT( P_APLIACACAO     IN  TDVADM.T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE,
                                P_ROTA           IN  TDVADM.T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                P_USUARIO        IN  TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                p_VfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                p_VfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                p_VfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                p_VfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                P_IDOPER_CODIGO  OUT VARCHAR2,
                                P_IDOPER_ROTA    OUT TDVADM.T_CON_FRETEOPER.CON_FRETEOPER_ROTA%TYPE,
                                p_CIOTNUMERO     OUT TDVADM.T_CON_VFRETECIOT.CON_VFRETECIOT_NUMERO%TYPE,
                                p_viagem         OUT TDVADM.t_Vgm_Viagem.VGM_VIAGEM_CODIGO%TYPE,
                                p_viagemRota     OUT TDVADM.t_Vgm_Viagem.GLB_ROTA_CODIGO%TYPE,
                                P_STATUS         OUT CHAR,
                                P_MESSAGE        OUT VARCHAR2
                            )AS
   vProprietario   t_car_proprietario.car_proprietario_cgccpfcodigo%TYPE;
   vMotorista      t_car_carreteiro.car_carreteiro_cpfcodigo%TYPE;
   vMotoristaSaque t_car_carreteiro.car_carreteiro_saque%TYPE;
   vPlaca          t_car_veiculo.car_veiculo_placa%TYPE;
   vPlacaSaque     t_car_veiculo.car_veiculo_saque%TYPE;
   vControl        INTEGER;
   vExistIntCiot   INTEGER;
   vQryStr         t_con_freteoper.con_freteoper_paramqrystr%TYPE;
   vViagemNumero   t_vgm_viagem.vgm_viagem_codigo%TYPE;
   vViagemRota     t_vgm_viagem.glb_rota_codigo%TYPE;
   vVgmCiot        t_vgm_vgciot%ROWTYPE;
   vCiotUsado      INTEGER;

   BEGIN

    BEGIN

       BEGIN


         SELECT VE.CAR_PROPRIETARIO_CGCCPFCODIGO,
                VF.CON_VALEFRETE_CARRETEIRO,
                NULL,
                VF.CON_VALEFRETE_PLACA,
                VF.CON_VALEFRETE_PLACASAQUE
           INTO vProprietario     ,
                vMotorista        ,
                vMotoristaSaque   ,
                vPlaca            ,
                vPlacaSaque
           FROM T_CON_VALEFRETE VF,
                T_CAR_VEICULO VE
           WHERE VF.CON_CONHECIMENTO_CODIGO =  p_VfreteCodigo
             AND vf.con_conhecimento_serie  =  p_VfreteSerie
             AND vf.glb_rota_codigo         =  p_VfreteRota
             AND vf.con_valefrete_saque     =  p_VfreteSaque
             AND VF.CON_VALEFRETE_PLACASAQUE = VE.CAR_VEICULO_SAQUE
             AND VF.CON_VALEFRETE_PLACA      = VE.CAR_VEICULO_PLACA;

       EXCEPTION WHEN OTHERS THEN
         P_STATUS   := PKG_GLB_COMMON.Status_Erro;
         P_MESSAGE  := 'Erro ao consultar vale de frete. Erro: '||SQLERRM;
         RETURN;
       END;

       for vCursorIds In ( Select Distinct
                            seq.uti_sequencia_rota,
                            seq.uti_sequencia_codigo,
                            seq.uti_sequencia_validade,
                            oper.con_freteoper_dtcad
                          From
                            t_con_freteoper oper,
                            t_uti_sequencia seq
                          Where
                            oper.con_freteoper_id = seq.uti_sequencia_codigo
                            And oper.con_freteoper_rota = seq.uti_sequencia_rota
                            --And Trunc(seq.uti_sequencia_validade) >= Trunc(Sysdate)
                            And tRIM(TDVADM.fn_querystring(TDVADM.fn_querystring(oper.con_freteoper_paramqrystr ,'Proprietario','=','*'), 'valor', '=', '|')) = tRIM(vProprietario)
                            And tRIM(TDVADM.fn_querystring(TDVADM.fn_querystring(oper.con_freteoper_paramqrystr ,'Motorista','=','*'), 'valor', '=', '|')) = Trim(vMotorista)
                            And tRIM(TDVADM.fn_querystring(TDVADM.fn_querystring(oper.con_freteoper_paramqrystr ,'Placa','=','*'), 'valor', '=', '|')) = Trim(vPlaca)
                            And seq.uti_sequencia_aplicacao = 'gercoleta'
                          Order BY oper.con_freteoper_dtcad DESC
                        ) Loop

                            --Verifico se o Id encontrado está totalmente validado.
                            Select Count(*)
                              Into vControl
                              From t_con_freteoper w
                             Where w.con_freteoper_id   = vCursorIds.Uti_Sequencia_Codigo
                               And w.con_freteoper_rota = vCursorIds.Uti_Sequencia_Rota
                               And w.cfe_statusfreteoper_status <> 'OK';

                             IF vControl  = 0 THEN
                                 -- VERifico se tem uma uma integração de viagem
                                 Select Count(*)
                                   Into vExistIntCiot
                                   From t_con_freteoper w
                                  Where w.con_freteoper_id   = vCursorIds.Uti_Sequencia_Codigo
                                    And w.con_freteoper_rota = vCursorIds.Uti_Sequencia_Rota
                                    And w.cfe_statusfreteoper_status = 'OK'
                                    AND w.cfe_integratdv_cod = '31'
                                    AND w.cfe_operacoes_cod  = '41';


                               IF vExistIntCiot > 0 THEN
                                  -- se existe pego o QryStr para analisar o CIOT
                                  BEGIN
                                    SELECT W.CON_FRETEOPER_PARAMQRYSTR
                                      INTO vQryStr
                                      From t_con_freteoper w
                                     Where w.con_freteoper_id           = vCursorIds.Uti_Sequencia_Codigo
                                       And w.con_freteoper_rota         = vCursorIds.Uti_Sequencia_Rota
                                       And w.cfe_statusfreteoper_status = 'OK'
                                       AND w.cfe_integratdv_cod         = '31'
                                       AND w.cfe_operacoes_cod          = '41';
                                   EXCEPTION WHEN OTHERS THEN
                                     vQryStr := NULL;
                                   END;
                                 END IF;

                                 IF vQryStr IS NOT NULL THEN

                                    vViagemNumero :=  tRIM(TDVADM.fn_querystring(TDVADM.fn_querystring(vQryStr ,'ViagemNumero','=','*'), 'valor', '=', '|'));
                                    vViagemRota   :=  tRIM(TDVADM.fn_querystring(TDVADM.fn_querystring(vQryStr ,'ViagemRota','=','*'), 'valor', '=', '|'));

                                     SELECT *
                                       INTO vVgmCiot
                                       FROM T_VGM_VGCIOT L
                                      WHERE L.GLB_ROTA_CODIGO   = vViagemRota
                                        AND L.VGM_VIAGEM_CODIGO = vViagemNumero;

                                       SELECT COUNT(*)
                                         INTO vCiotUsado
                                         FROM T_CON_VFRETECIOT L
                                        WHERE L.CON_VFRETECIOT_NUMERO = vVgmCiot.Vgm_Vgciot_Numero
                                          AND L.CON_FRETEOPER_ID      = vVgmCiot.Con_Freteoper_Id
                                          AND L.CON_FRETEOPER_ROTA    = vVgmCiot.Con_Freteoper_Rota;

                                        IF vCiotUsado = 0 THEN

                                           P_IDOPER_CODIGO := vVgmCiot.Con_Freteoper_Id;
                                           P_IDOPER_ROTA   := vVgmCiot.Con_Freteoper_Rota;
                                           p_CIOTNUMERO    := vVgmCiot.Vgm_Vgciot_Numero;
                                           P_STATUS        := PKG_GLB_COMMON.Status_Nomal;
                                           p_viagem        := vVgmCiot.Vgm_Viagem_Codigo;
                                           p_viagemRota    := vVgmCiot.Glb_Rota_Codigo;
                                           P_MESSAGE       := '' ; --Processamento normal!';
                                          RETURN;

                                        END IF;

                                 END IF;

                              END IF;

                        End Loop;

       IF p_CIOTNUMERO is NULL THEN
          P_IDOPER_CODIGO := NULL;
          P_IDOPER_ROTA   := NULL;
          p_CIOTNUMERO    := NULL;
          p_viagem        := NULL;
          p_viagemRota    := NULL;
          P_STATUS        := PKG_GLB_COMMON.Status_Nomal;
          P_MESSAGE       := 'Ciot não localizado!';
     END IF;

     EXCEPTION
        WHEN OTHERS THEN
          BEGIN
              P_IDOPER_CODIGO := NULL;
              P_IDOPER_ROTA   := NULL;
              p_CIOTNUMERO    := NULL;
              p_viagem        := NULL;
              p_viagemRota    := NULL;
              P_STATUS        := PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE       := 'Erro ao localizar CIOT. Erro: '||SQLERRM;
          END;
      END;


   END SP_GETIDVALIDOALT;

   PROCEDURE SP_CON_VERIFICAPODEIMP AS
   vInteger      INTEGER;
   vIntegracaoOk INTEGER;
   BEGIN

    BEGIN

         FOR R_CURSOR IN(
                          SELECT *
                            FROM T_CON_VFRETECIOT L
                            WHERE NVL(L.CON_VFRETECIOT_FLAGIMPRIME,'S') = 'N'
                              AND NVL(L.CON_VFRETECIOT_FLAGPROCESAL,'N') = 'S'
                              AND (SELECT COUNT(*)
                                     FROM T_CON_FRETEOPER EXI
                                    WHERE EXI.CON_FRETEOPER_ID = L.CON_FRETEOPER_ID
                                      AND EXI.CON_FRETEOPER_ROTA = L.CON_FRETEOPER_ROTA
                                      AND EXI.CFE_INTEGRATDV_COD = '35') >= 1
                        )
         LOOP

           SELECT COUNT(*)
             INTO vIntegracaoOk
             FROM T_CON_FRETEOPER OPER
            WHERE OPER.CON_FRETEOPER_ID = R_CURSOR.CON_FRETEOPER_ID
              AND OPER.CON_FRETEOPER_ROTA = R_CURSOR.CON_FRETEOPER_ROTA
              AND OPER.CFE_INTEGRATDV_COD = '35'
              AND OPER.CFE_STATUSFRETEOPER_STATUS <> 'OK'
              AND (SELECT COUNT(*)
                     FROM T_CON_FRETEOPER EXI
                     WHERE EXI.CON_FRETEOPER_ID = OPER.CON_FRETEOPER_ID
                       AND EXI.CON_FRETEOPER_ROTA = OPER.CON_FRETEOPER_ROTA
                       AND EXI.CFE_INTEGRATDV_COD = '35' ) >= 1;


           IF vIntegracaoOk = 0 THEN

              UPDATE T_CON_VFRETECIOT CIOTA
                 SET CIOTA.CON_VFRETECIOT_FLAGIMPRIME  = 'S',
                     CIOTA.CON_VFRETECIOT_FLAGALTERA   = 'N',
                     CIOTA.CON_VFRETECIOT_FLAGPROCESAL = 'N'
               WHERE CIOTA.CON_CONHECIMENTO_CODIGO     =  R_CURSOR.CON_CONHECIMENTO_CODIGO
                 AND CIOTA.CON_CONHECIMENTO_SERIE      =  R_CURSOR.CON_CONHECIMENTO_SERIE
                 AND CIOTA.GLB_ROTA_CODIGO             =  R_CURSOR.GLB_ROTA_CODIGO
                 AND CIOTA.CON_VALEFRETE_SAQUE         =  R_CURSOR.CON_VALEFRETE_SAQUE;

           END IF;

         END LOOP;
         COMMIT;

     EXCEPTION
       WHEN OTHERS THEN
       BEGIN
         vInteger := 1;

      END;
      END;

   END SP_CON_VERIFICAPODEIMP;


   PROCEDURE SP_CON_SETALTERACAOVLR(P_QUERYSTR      IN  Varchar2,
                                    P_STATUS        OUT CHAR,
                                    P_MESSAGE       OUT VARCHAR2)AS

   vValeFreteNumero     t_con_valefrete.con_conhecimento_codigo%TYPE;
   vValeFreteSerie      t_con_valefrete.con_conhecimento_serie%TYPE;
   vValeFreteRota       t_con_valefrete.glb_rota_codigo%TYPE;
   vValeFreteSaque      t_con_valefrete.con_valefrete_saque%TYPE;
   vValeFreteUsuario    t_usu_usuario.usu_usuario_codigo%TYPE;
   vValeFreteAplicacao  t_usu_aplicacao.usu_aplicacao_codigo%TYPE;
   vValeFreteRotaUsu    t_glb_rota.glb_rota_codigo%TYPE;
   vTableCiot           t_con_vfreteciot%ROWTYPE;
   vTableValeFrete      t_con_valefrete%ROWTYPE;
   vStatus              CHAR(1);
   vMessage             VARCHAR2(2000);
   vVfdeFrota           integer;
   BEGIN

    BEGIN


      
       /**********************************************************/
       /*****************  EXTRAINDO VALORES  ********************/
       /**********************************************************/

       BEGIN
           vValeFreteNumero      := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFNumero','=','*'), 'valor', '=', '|');
           vValeFreteSerie       := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFSerie','=','*'), 'valor', '=', '|');
           vValeFreteRota        := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFRota','=','*'), 'valor', '=', '|');
           vValeFreteSaque       := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFSaque','=','*'), 'valor', '=', '|');
           vValeFreteUsuario     := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFUsuarioTDV','=','*'), 'valor', '=', '|');
           vValeFreteAplicacao   := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFAplicacaoTDV','=','*'), 'valor', '=', '|');
           vValeFreteRotaUsu     := TDVADM.fn_querystring(TDVADM.fn_querystring(P_QUERYSTR,'VFRotaUsuarioTDV','=','*'), 'valor', '=', '|');
       END;

        
       /**********************************************************/
       /*****************  SE É UM VF DE FROTA********************/
       /**********************************************************/
       begin
           select count(*)
             into vVfdeFrota
             from t_con_valefrete vf
            where vf.con_conhecimento_codigo         = vValeFreteNumero
              and vf.con_conhecimento_serie          = vValeFreteSerie
              and vf.glb_rota_codigo                 = vValeFreteRota
              and vf.con_valefrete_saque             = vValeFreteSaque
              and vf.glb_tpmotorista_codigo          = 'F'
              and substr(vf.con_valefrete_placa,1,3) = '000';


           if (vVfdeFrota > 0) then


               P_STATUS  := pkg_glb_common.Status_Erro;
               P_MESSAGE := 'Vale de frete para pagamento de frota não pode ser alterado, cancele a viagem do mesmo.';
               return;
           end if;

       end;

       /**********************************************************/
       /********************  DADOS TABELAS  *********************/
       /**********************************************************/

           vStatus  := pkg_glb_common.Status_Nomal;

       If vStatus <> pkg_glb_common.Status_Erro Then

           BEGIN

              SELECT *
                INTO vTableCiot
                FROM T_CON_VFRETECIOT CIO
               WHERE CIO.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                 AND CIO.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                 AND CIO.GLB_ROTA_CODIGO         = vValeFreteRota
                 AND CIO.CON_VALEFRETE_SAQUE     = vValeFreteSaque;

              SELECT *
                INTO vTableValeFrete
                FROM T_CON_VALEFRETE VF
               WHERE VF.CON_CONHECIMENTO_CODIGO = vValeFreteNumero
                 AND VF.CON_CONHECIMENTO_SERIE  = vValeFreteSerie
                 AND VF.GLB_ROTA_CODIGO         = vValeFreteRota
                 AND VF.CON_VALEFRETE_SAQUE     = vValeFreteSaque;

           END;

           /**********************************************************/


           /**********************************************************/
           /*************** INICIALIZANDO VARIAVEIS ******************/
           /**********************************************************/

           BEGIN
               vStatus  := pkg_glb_common.Status_Nomal;
               vMessage := '' ; --Processamento Normal!';
           END;

           /**********************************************************/

           /**********************************************************/
           /*************** VERIFICAÇÕES VALE DE FRETE ***************/
           /**********************************************************/

           BEGIN
             IF nvl(vTableValeFrete.Con_Valefrete_Status,'N') <> 'N' THEN
                vStatus  := pkg_glb_common.Status_Warning;
                vMessage := 'Vale Frete Cancelado não pode ser habilitado alteração!';
             END IF;


             IF nvl(vTableValeFrete.Con_Valefrete_Impresso,'N') = 'S' THEN
                vStatus  := pkg_glb_common.Status_Warning;
                vMessage := vMessage||CHR(10)||'Vale Frete impresso não pode ser habilitado alteração!';
             END IF;


           END;

           /**********************************************************/

           /**********************************************************/
           /*************** VERIFICAÇÕES TABELA CIOT *****************/
           /**********************************************************/

           BEGIN

               IF nvl(vTableCiot.Con_Vfreteciot_Flagprocesal,'N') <> 'N' THEN
                  vStatus  := pkg_glb_common.Status_Warning;
                  vMessage := vMessage||CHR(10)||'Uma solicitação de alteração de valores para esse vale de frete esta em andamento, por favor aguarde!! '||vTableCiot.Con_Vfreteciot_Flagprocesal;
               END IF;
           END;

           /**********************************************************/


           /**********************************************************/
           /**************** ATUALIZA TABELA DE CIOT *****************/
           /**********************************************************/

           BEGIN
               IF vStatus = pkg_glb_common.Status_Nomal THEN

                  BEGIN
                      UPDATE T_CON_VFRETECIOT CI
                         SET CI.CON_VFRETECIOT_FLAGIMPRIME  = 'N',
                             CI.CON_VFRETECIOT_FLAGALTERA   = 'S',
                             CI.CON_VFRETECIOT_FLAGPROCESAL = 'N'
                       WHERE CI.CON_CONHECIMENTO_CODIGO     = vValeFreteNumero
                         AND ci.con_conhecimento_serie      = vValeFreteSerie
                         AND CI.GLB_ROTA_CODIGO             = vValeFreteRota
                         AND CI.CON_VALEFRETE_SAQUE         = vValeFreteSaque;
                   EXCEPTION
                     WHEN OTHERS THEN
                     BEGIN
                       vStatus  := pkg_glb_common.Status_Erro;
                       vMessage := 'Habilita alteração não pode ser realizada. Erro= '||SQLERRM;
                     END;
                   END;

               END IF;
           END;

           /**********************************************************/

           /**********************************************************/
           /**************** RETORNANDO PARAMETRO ********************/
           /**********************************************************/

           BEGIN

              P_STATUS   := vStatus;
              P_MESSAGE  := vMessage;

           END;

           /**********************************************************/

     End If;

     EXCEPTION
       WHEN OTHERS THEN
       BEGIN
         P_STATUS   := pkg_glb_common.Status_Erro;
         P_MESSAGE  := 'Habilita alteração não pode ser realizada. Erro= '||SQLERRM;

      END;
     END;


   END SP_CON_SETALTERACAOVLR;

   function fni_xml_Gettabelas(pValeFrete in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                               pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                               pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                               pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%type,
                               pCategoria in tdvadm.t_con_valefrete.con_catvalefrete_codigo%type)
     return clob
   is

    vCursor1 PKG_GLB_COMMON.T_CURSOR;
    vCursor2 PKG_GLB_COMMON.T_CURSOR;
    vLinha pkg_glb_SqlCursor.tpString1024;
    vRetorno1 xmltype;
    vRetornoc clob;
    P_STATUS CHAR;
    P_MESSAGE VARCHAR2(100);


   Begin
 --  vRetorno1  := empty_clob();
   vlinha.delete;


   if pCategoria = CatTColeta Then
     -- roda como 01 viagem so para ter o cursor vazio
     OPEN vCursor1 FOR
       SELECT VC.ARM_COLETA_NCOMPRA COLETA,
              VC.ARM_COLETA_CICLO CICLO,
              CO.ARM_COLETA_DTSOLICITACAO SOLICITADA,
              TRUNC(co.arm_coleta_dtfechamento) BAIXADA,
              fn_limpa_campo3(OC.ARM_COLETAOCOR_DESCRICAO) OCORRENCIA,
              VC.CON_VFRETECOLETA_RECALCULA RECALC,
              'Fabiano' teste,
              'Bruno' teste2,
              'L-Liberado' status
       FROM T_CON_VFRETECOLETA VC,
            T_ARM_COLETA CO,
            T_ARM_COLETAOCOR OC,
            dual
       WHERE 0 = 0
         AND VC.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA
         AND VC.ARM_COLETA_CICLO   = CO.ARM_COLETA_CICLO
         AND CO.ARM_COLETAOCOR_CODIGO = OC.ARM_COLETAOCOR_CODIGO (+)
         AND VC.CON_VALEFRETE_CODIGO = pValeFrete
         AND VC.CON_VALEFRETE_SERIE = pSerie
         AND VC.GLB_ROTA_CODIGOVALEFRETE = pRota
         AND VC.CON_VALEFRETE_SAQUE = pSaque
       union
       SELECT '' COLETA,
              '' CICLO,
              null SOLICITADA,
              null BAIXADA,
              null OCORRENCIA,
              null RECALC,
              'Fabiano' teste,
              'Bruno' teste2,
              'L-Liberado' status
        from dual
        where 0 = ( select count(*)
                    FROM T_CON_VFRETECOLETA VC,
                        T_ARM_COLETA CO,
                        T_ARM_COLETAOCOR OC
                   WHERE 0 = 0
                     AND VC.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA
                     AND VC.ARM_COLETA_CICLO   = CO.ARM_COLETA_CICLO
                     AND CO.ARM_COLETAOCOR_CODIGO = OC.ARM_COLETAOCOR_CODIGO (+)
                     AND VC.CON_VALEFRETE_CODIGO = pValeFrete
                     AND VC.CON_VALEFRETE_SERIE = pSerie
                     AND VC.GLB_ROTA_CODIGOVALEFRETE = pRota
                     AND VC.CON_VALEFRETE_SAQUE = pSaque)
       ORDER BY 2,1;


     pkg_glb_xml.sp_getxmltable('ColetasVF',vCursor1,vRetorno1,P_STATUS,P_MESSAGE);
 /*
     if instr(vRetorno1.getclobval(),'<Rowset/>') > 0 Then
         vRetornoc :=  empty_clob();
         pkg_glb_SqlCursor.TiposComuns.Formato := 'X';
       --  pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
         pkg_glb_SqlCursor.sp_Get_Cursor(vCursor1,vLinha);

         if vCursor1%isopen Then
            close vCursor1;
         End if;

         for i in 1 .. vLinha.count loop
            vRetornoc := vRetornoc || vLinha(i) ; --|| chr(10);
         End loop;

     End if;
 */
   Else
       OPEN vCursor2 FOR
       SELECT A.CON_VALEFRETE_CODIGO,
              A.CON_VALEFRETE_SERIE,
              A.GLB_ROTA_CODIGOVALEFRETE,
              A.CON_VALEFRETE_SAQUE,
              A.CON_CONHECIMENTO_CODIGO,
              A.CON_CONHECIMENTO_SERIE,
              A.GLB_ROTA_CODIGO,
              A.CON_VFRETECONHEC_RECALCULA,
              C.CON_CONHECIMENTO_DTEMBARQUE,
              C.CON_CONHECIMENTO_PLACA PLACA,
              C.GLB_CLIENTE_CGCCPFREMETENTE,
              C.GLB_CLIENTE_CGCCPFDESTINATARIO,
              C.GLB_CLIENTE_CGCCPFSACADO ,
              Decode(NVL(CON_FPAGTOMOTPED_PAGTOVFRETE,'S'),'N',CVP.CON_CONHECVPED_VALOR,0) VALEPEDAGIO,
              CLD.GLB_GRUPOECONOMICO_CODIGO GEDEST,
              CLS.GLB_GRUPOECONOMICO_CODIGO GESAC
       FROM  T_CON_VFRETECONHEC A,
             T_CON_CONHECIMENTO C,
             T_CON_CONHECVPED CVP,
             T_CON_FPAGTOMOTPED FP,
             T_GLB_CLIENTE      CLD,
             T_GLB_CLIENTE      CLS
       WHERE A.CON_VALEFRETE_CODIGO     = pValeFrete
         AND A.CON_VALEFRETE_SERIE      = pSerie
         AND A.GLB_ROTA_CODIGOVALEFRETE = pRota
         AND A.CON_VALEFRETE_SAQUE      = pSaque
           And a.con_conhecimento_codigo  = c.con_conhecimento_codigo
           And a.con_conhecimento_serie   = c.con_conhecimento_serie
           And a.glb_rota_codigo          = c.glb_rota_codigo
           And C.GLB_CLIENTE_CGCCPFDESTINATARIO = CLD.GLB_CLIENTE_CGCCPFCODIGO
           And C.GLB_CLIENTE_CGCCPFSACADO       = CLS.GLB_CLIENTE_CGCCPFCODIGO
           And C.CON_CONHECIMENTO_CODIGO        = CVP.CON_CONHECIMENTO_CODIGO (+)
           And C.CON_CONHECIMENTO_SERIE         = CVP.CON_CONHECIMENTO_SERIE (+)
           And C.GLB_ROTA_CODIGO                = CVP.GLB_ROTA_CODIGO (+)
           And CVP.CON_FPAGTOMOTPED_CODIGO      = FP.CON_FPAGTOMOTPED_CODIGO (+)
       union
       SELECT null CON_VALEFRETE_CODIGO,
              null CON_VALEFRETE_SERIE,
              null GLB_ROTA_CODIGOVALEFRETE,
              null CON_VALEFRETE_SAQUE,
              null CON_CONHECIMENTO_CODIGO,
              null CON_CONHECIMENTO_SERIE,
              null GLB_ROTA_CODIGO,
              null CON_VFRETECONHEC_RECALCULA,
              null CON_CONHECIMENTO_DTEMBARQUE,
              null  PLACA,
              null GLB_CLIENTE_CGCCPFREMETENTE,
              null GLB_CLIENTE_CGCCPFDESTINATARIO,
              null GLB_CLIENTE_CGCCPFSACADO ,
              0 VALEPEDAGIO,
              null GEDEST,
              null GESAC
        from dual
        where 0 = (select count(*)
                   FROM  T_CON_VFRETECONHEC A,
                         T_CON_CONHECIMENTO C,
                         T_CON_CONHECVPED CVP,
                         T_CON_FPAGTOMOTPED FP,
                         T_GLB_CLIENTE      CLD,
                         T_GLB_CLIENTE      CLS
                   WHERE A.CON_VALEFRETE_CODIGO     = pValeFrete
                     AND A.CON_VALEFRETE_SERIE      = pSerie
                     AND A.GLB_ROTA_CODIGOVALEFRETE = pRota
                     AND A.CON_VALEFRETE_SAQUE      = pSaque
                       And a.con_conhecimento_codigo  = c.con_conhecimento_codigo
                       And a.con_conhecimento_serie   = c.con_conhecimento_serie
                       And a.glb_rota_codigo          = c.glb_rota_codigo
                       And C.GLB_CLIENTE_CGCCPFDESTINATARIO = CLD.GLB_CLIENTE_CGCCPFCODIGO
                       And C.GLB_CLIENTE_CGCCPFSACADO       = CLS.GLB_CLIENTE_CGCCPFCODIGO
                       And C.CON_CONHECIMENTO_CODIGO        = CVP.CON_CONHECIMENTO_CODIGO (+)
                       And C.CON_CONHECIMENTO_SERIE         = CVP.CON_CONHECIMENTO_SERIE (+)
                       And C.GLB_ROTA_CODIGO                = CVP.GLB_ROTA_CODIGO (+)
                       And CVP.CON_FPAGTOMOTPED_CODIGO      = FP.CON_FPAGTOMOTPED_CODIGO (+));


 /*
        pkg_glb_SqlCursor.TiposComuns.Formato := 'X';
       --  pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
         pkg_glb_SqlCursor.sp_Get_Cursor(vCursor2,vLinha);

         if vCursor2%isopen Then
            close vCursor2;
         End if;

         for i in 1 .. vLinha.count loop
            vRetorno1 := vRetorno1 || vLinha(i) ; --|| chr(10);
         End loop;

 */
     pkg_glb_xml.sp_getxmltable('ConhecimentoVF',vCursor2,vRetorno1,P_STATUS,P_MESSAGE);



    End if;


       return vRetorno1.getclobval();



   end fni_xml_Gettabelas;

   PROCEDURE SP_GET_DOCREFERENCIA(P_QRYSTR   In VARCHAR2,
                                  P_XMLOUT   Out Clob) As





 /* Variáveis criadas para controlar a exigência de imagem para o CTRC e/ou NF, na criação do valefrete. */

 --  plistaparams glbadm.pkg_listas.tlistausuparametros;
   vXmlTabTodas clob;
   pXmlOut      clob;
   vStatus      char(1);
   vMESSAGE     varchar2(32000);
 begin
      vSTATUS  := pkg_glb_common.Status_Nomal;
      vMESSAGE := '';
      vXmlTabTodas := empty_clob();
      pXmlOut      := empty_clob();


      tpVF.vXmlTab := P_QRYSTR;
      tpVF.VFNumero                       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFNumero' ));
      tpVF.VFSerie                        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFSerie' ));
      tpVF.VFRota                         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFRota' ));
      tpVF.VFSaque                        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFSaque' ));
      tpVF.VFAcao                         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFAcao' ));
      tpVF.VFusuarioTDV                   := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFUsuarioTDV' ));
      tpVF.VFRotaUsuarioTDV               := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFRotaUsuarioTDV' ));
      tpVF.VFAplicacaoTDV                 := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFAplicacaoTDV' ));
      tpVF.VFVersaoAplicao                := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFVersaoAplicao' ));
      tpVF.VFCON_CATVALEFRETE_CODIGO      := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_CATVALEFRETE_CODIGO' ));
      tpVF.VFCON_SUBCATVALEFRETE_CODIGO   := substr(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'CON_SUBCATVALEFRETE_CODIGO' ),1,2);

      vXmlTabTodas := fni_xml_Gettabelas(tpVF.VFNumero,
                                         tpVF.VFSerie,
                                         tpVF.VFRota,
                                         tpVF.VFSaque,
                                         tpVF.VFCON_CATVALEFRETE_CODIGO);

       if  tpVF.VFCON_CATVALEFRETE_CODIGO = CatTColeta Then
           vXmlTabTodas := vXmlTabTodas || fni_xml_Gettabelas(tpVF.VFNumero,
                                                              tpVF.VFSerie,
                                                              tpVF.VFRota,
                                                              tpVF.VFSaque,
                                                              '01');
       Else
           vXmlTabTodas := vXmlTabTodas || fni_xml_Gettabelas(tpVF.VFNumero,
                                                              tpVF.VFSerie,
                                                              tpVF.VFRota,
                                                              tpVF.VFSaque,
                                                              '18');

       End if;
       vXmlTabTodas  := Replace( vXmlTabTodas, '#', '''' );
       pXmlOut :=           '<parametros><output>';
       pXmlOut := pXmlOut|| '<P_STATUS>'  || trim(vStatus)  || '</P_STATUS>';
       pXmlOut := pXmlOut|| '<P_MESSAGE>' || trim(vMessage) || '</P_MESSAGE>';
       pXmlOut := pXmlOut|| '<tables>';
       pXmlOut := pXmlOut|| vXmlTabTodas;
       pXmlOut := pXmlOut|| '</tables>';
       pXmlOut := pXmlOut|| '</output></parametros>';

       P_XMLOUT := pXmlOut;

 end SP_GET_DOCREFERENCIA;




    PROCEDURE SP_ATUVERBA_VFRETE IS
       /*CURSOR C_VFRETECONHEC IS
       SELECT A.CON_VALEFRETE_CODIGO,
              A.CON_VALEFRETE_SERIE,
              A.GLB_ROTA_CODIGOVALEFRETE,
              A.CON_VALEFRETE_SAQUE,
              B.GLB_TPMOTORISTA_CODIGO,
              B.CON_VALEFRETE_TIPOTRANSPORTE
       FROM   T_CON_VFRETECONHEC A,
              T_CON_VALEFRETE B
       WHERE  nvl(A.CON_VFRETECONHEC_RECALCULA,'N') = 'F'
          AND A.CON_VALEFRETE_CODIGO     = B.CON_CONHECIMENTO_CODIGO
          AND A.CON_VALEFRETE_SERIE      = B.CON_CONHECIMENTO_SERIE
          AND A.GLB_ROTA_CODIGOVALEFRETE = B.GLB_ROTA_CODIGO
          AND A.CON_VALEFRETE_SAQUE      = B.CON_VALEFRETE_SAQUE
          AND B.CON_VALEFRETE_IMPRESSO   = 'S'
          AND B.CON_VALEFRETE_STATUS     IS NULL;*/
       CURSOR C_VFRETE IS
         SELECT DISTINCT A.CON_CONHECIMENTO_CODIGO,
                         A.CON_CONHECIMENTO_SERIE,
                         A.GLB_ROTA_CODIGO,
                         b.SLF_TPCALCULO_CODIGO,
                         B.CON_CONHECIMENTO_ALTALTMAN,
                         B.CON_CONHECIMENTO_DTEMBARQUE,
                         NVL(FN_VERBASEMIMPOSTO(A.CON_CONHECIMENTO_CODIGO,
                                                A.CON_CONHECIMENTO_SERIE,
                                                A.GLB_ROTA_CODIGO,
                                                'I_TTPV'),
                             1) V_VALOR_CONHEC
           FROM T_CON_VFRETECONHEC     A,
                T_CON_CALCCONHECIMENTO B,
                T_CON_VALEFRETE        C
          WHERE 0 = 0
            and ( NVL(A.CON_VFRETECONHEC_RECALCULA, 'N') = 'S' or a.con_conhecimento_codigo = '626228' )
            AND A.CON_VALEFRETE_CODIGO = C.CON_CONHECIMENTO_CODIGO
            AND A.CON_VALEFRETE_SERIE = C.CON_CONHECIMENTO_SERIE
            AND A.GLB_ROTA_CODIGOVALEFRETE = C.GLB_ROTA_CODIGO
            AND A.CON_VALEFRETE_SAQUE = C.CON_VALEFRETE_SAQUE
            AND (
                  (nvl(C.CON_VALEFRETE_IMPRESSO, 'N') = 'S') or
                  ( PKG_CON_VALEFRETE.FN_Get_Pagamento(a.con_valefrete_codigo,a.con_valefrete_serie,a.glb_rota_codigovalefrete,a.con_valefrete_saque,'01') <> 'X0****' ) or
                  ( PKG_CON_VALEFRETE.FN_Get_Pagamento(a.con_valefrete_codigo,a.con_valefrete_serie,a.glb_rota_codigovalefrete,a.con_valefrete_saque,'20') <> 'X0****' )
                )
     --            (c.cax_boletim_data is not null))
            AND
                A.CON_CONHECIMENTO_CODIGO = B.CON_CONHECIMENTO_CODIGO
            AND A.CON_CONHECIMENTO_SERIE = B.CON_CONHECIMENTO_SERIE
            AND A.GLB_ROTA_CODIGO = B.GLB_ROTA_CODIGO
            and B.SLF_RECCUST_CODIGO = 'I_CTCR';

       CURSOR C_CTRC IS
         -- estava com 600 dias e todos os CTRC
         -- coloquei para 6 dias e impresso = I e verba diferente de 0
         SELECT C.CON_CONHECIMENTO_CODIGO CODIGO,
                C.CON_CONHECIMENTO_SERIE  SERIE,
                C.GLB_ROTA_CODIGO         ROTA
           FROM T_CON_CONHECIMENTO C,
                t_con_calcconhecimento ca
          WHERE C.CON_CONHECIMENTO_DTEMBARQUE >= trunc(sysdate) - 60
            and c.con_conhecimento_serie <> 'XXX'
            and c.con_conhecimento_digitado = 'I'
            AND 0 = (SELECT COUNT(*)
                       FROM T_CON_VFRETECONHEC V
                      WHERE V.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
                        AND V.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
                        AND V.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO)
            and c.con_conhecimento_codigo = ca.con_conhecimento_codigo
            and c.con_conhecimento_serie = ca.con_conhecimento_serie
            and c.glb_rota_codigo = ca.glb_rota_codigo
            and ca.slf_reccust_codigo = 'I_CTCR'
            and ca.con_calcviagem_valor <> 0;

       V_TOTAL_CONHEC tdvadm.t_con_valefrete.CON_VALEFRETE_VALORRATEIO%type;
       V_MAIORDTVF    tdvadm.t_con_valefrete.con_valefrete_datacadastro%type;
       CONT INTEGER;
       vMessage  varchar2(32000);
       vInicio   date;

    BEGIN
       WHO_CALLED_ME2;

        vMessage := '';
        If SYS_CONTEXT('PROCESSOUNICO','SP_ATUVERBA_VFRETE') = 'S' Then
          vMessage := 'Rodando desde ' ||SYS_CONTEXT('PROCESSOUNICO','SP_ATUVERBA_VFRETEINI') || chr(13);
          if substr(fn_calcula_tempodecorrido(to_date(SYS_CONTEXT('PROCESSOUNICO','SP_ATUVERBA_VFRETEINI'),'dd/mm/yyyy hh24:mi:ss'),sysdate,'H'),1,5) > 2 then
             vMessage := vMessage || ' Processo inicializado novamente AGORA.' || chr(13);
             SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETEINI','');
             SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETEFIM','');
             SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETE','N');
             wservice.pkg_glb_email.SP_ENVIAEMAIL('RECALCULO EM ANDAMENTO',vMessage,'aut-e@dellavolpe.com.br','sdrumond@dellavolpe.com.br');
          Else
             Return;
          End If;
        End If;


       begin
        SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETE','S');
        SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETEINI',to_char(sysdate,'DD/MM/YYYY HH24:MI:SS'));
        SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETEFIM','');







     /* colocamos isto para corrigir o valor de rateio dos Vales de frete
        com este update starta um a trigger quando a soma dos ctrc sejam maiores que 1 real
        e o vale de frete tem que ter valor

    */



       CONT := 0;
       FOR R_VFRETE IN C_VFRETE LOOP
         v_total_conhec := sql%rowcount;
         if R_VFRETE.CON_CONHECIMENTO_CODIGO =  '626228' Then
            v_total_conhec := v_total_conhec;
         End If;
     --    IF R_VFRETE.CON_CONHECIMENTO_ALTALTMAN IS NULL THEN
           SELECT sum(decode(NVL(A.CON_VALEFRETE_STATUS, 'X'),
                             'C',
                             0,
                             NVL(A.CON_VALEFRETE_VALORRATEIO, 0))),
                             max(a.con_valefrete_datacadastro)
             INTO V_TOTAL_CONHEC,
                  V_MAIORDTVF
             FROM T_CON_VALEFRETE A, T_CON_VFRETECONHEC B
            WHERE B.CON_CONHECIMENTO_CODIGO = R_VFRETE.CON_CONHECIMENTO_CODIGO
              AND B.CON_CONHECIMENTO_SERIE = R_VFRETE.CON_CONHECIMENTO_SERIE
              AND B.GLB_ROTA_CODIGO = R_VFRETE.GLB_ROTA_CODIGO
              AND A.CON_CONHECIMENTO_CODIGO = B.CON_VALEFRETE_CODIGO
              AND a.CON_CONHECIMENTO_SERIE = b.CON_VALEFRETE_SERIE
              AND A.CON_VALEFRETE_SAQUE = B.CON_VALEFRETE_SAQUE
              AND A.GLB_ROTA_CODIGO = B.GLB_ROTA_CODIGOVALEFRETE
              AND A.CON_VALEFRETE_IMPRESSO = 'S'
              AND NVL(A.CON_CATVALEFRETE_CODIGO, '99') <> CatTReforco;
           -- VALEFRETE TEM QUE SER DIFERENTE DE REFORCO

           UPDATE T_CON_CALCCONHECIMENTO A
              SET A.CON_CALCVIAGEM_VALOR      = round((V_TOTAL_CONHEC * R_VFRETE.V_VALOR_CONHEC),2),
                  A.CON_CALCVIAGEM_DESINENCIA = 'VL'
            WHERE A.CON_CONHECIMENTO_CODIGO = R_VFRETE.CON_CONHECIMENTO_CODIGO
              AND A.CON_CONHECIMENTO_SERIE = R_VFRETE.CON_CONHECIMENTO_SERIE
              AND A.GLB_ROTA_CODIGO = R_VFRETE.GLB_ROTA_CODIGO
              AND A.SLF_RECCUST_CODIGO = 'I_CTCR';
         UPDATE T_CON_VFRETECONHEC
            SET CON_VFRETECONHEC_RECALCULA = NULL
          WHERE CON_CONHECIMENTO_CODIGO = R_VFRETE.CON_CONHECIMENTO_CODIGO
            AND CON_CONHECIMENTO_SERIE = R_VFRETE.CON_CONHECIMENTO_SERIE
            AND GLB_ROTA_CODIGO = R_VFRETE.GLB_ROTA_CODIGO;
         IF CONT >= 10 THEN
           COMMIT;
           CONT := 0;

        ELSE
           CONT := CONT + 1;
         END IF;
       END LOOP;
       commit;
       FOR CTRC IN C_CTRC LOOP
         UPDATE T_CON_CALCCONHECIMENTO CC
            SET CC.CON_CALCVIAGEM_VALOR = 0,
                cc.con_calcviagem_desinencia = 'VL'
          WHERE CC.CON_CONHECIMENTO_CODIGO = CTRC.CODIGO
            AND CC.CON_CONHECIMENTO_SERIE = CTRC.SERIE
            AND CC.GLB_ROTA_CODIGO = CTRC.ROTA
            AND CC.SLF_RECCUST_CODIGO = 'I_CTCR';
            commit;
       END LOOP;
       COMMIT;
       exception
         when Others Then
            vMessage :=             'Iniciou as ' || SYS_CONTEXT('PROCESSOUNICO','SP_ATUVERBA_VFRETEINI') || chr(10);
            vMessage := vMessage || 'Deu Erro as ' || to_char(sysdate,'DD/MM/YYYY HH24:MI:SS') || CHR(10);
            vMessage := vMessage || 'Erro : ' || SQLERRM || CHR(10);
            wservice.pkg_glb_email.SP_ENVIAEMAIL('RECALCULO RODOU COM ERRO',
                                                 vMessage,
                                                 'aut-e@dellavolpe.com.br',
                                                 'sdrumond@dellavolpe.com.br');
            SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETEINI','');
            SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETEFIM','');
            SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETE','N');
 --           raise_application_error(-20001,sqlerrm);
       end;

     SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETEFIM',to_char(sysdate,'DD/MM/YYYY HH24:MI:SS'));
     vMessage := 'Rodou das ' || SYS_CONTEXT('PROCESSOUNICO','SP_ATUVERBA_VFRETEINI') || ' Até as ' || SYS_CONTEXT('PROCESSOUNICO','SP_ATUVERBA_VFRETEFIM');
 --    wservice.pkg_glb_email.SP_ENVIAEMAIL('RECALCULO RODOU',vMessage,'aut-e@dellavolpe.com.br');
     SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_ATUVERBA_VFRETE','N');

   END SP_ATUVERBA_VFRETE;


 PROCEDURE SP_CON_MARCARECALCULO AS

         CURSOR C_VFRETE IS
         select (select sum(FN_VERBASEMIMPOSTO(vc.CON_CONHECIMENTO_CODIGO,vc.CON_CONHECIMENTO_SERIE, vc.GLB_ROTA_CODIGO, 'I_TTPV') - FN_VERBASEMIMPOSTO(vc.CON_CONHECIMENTO_CODIGO,vc.CON_CONHECIMENTO_SERIE, vc.GLB_ROTA_CODIGO, 'I_CTCR'))
                    from t_con_valefrete v,
                         t_con_vfreteconhec vc
                    where 0 = 0
                      and v.con_conhecimento_codigo = vf.con_conhecimento_codigo
                      and v.con_conhecimento_serie  = vf.con_conhecimento_serie
                      and v.glb_rota_codigo         = vf.glb_rota_codigo
                      and v.con_valefrete_saque     = vf.con_valefrete_saque
                      and vc.con_valefrete_codigo = v.con_conhecimento_codigo
                      and vc.con_valefrete_serie = v.con_conhecimento_serie
                      and vc.glb_rota_codigovalefrete = v.glb_rota_codigo
                      and vc.con_valefrete_saque = v.con_valefrete_saque) teste,
                vf.*
         from t_con_valefrete vf
         where 0=0
 --          and vf.con_conhecimento_codigo || vf.glb_rota_codigo in ('102255060','102254026','102255026')
           and vf.con_valefrete_datacadastro >= sysdate - 30
           and vf.con_valefrete_datacadastro <= sysdate - 0.01
 --          and vf.con_valefrete_valorrateio < 1
           and vf.con_valefrete_frete > 0
           and NVL(vf.CON_CATVALEFRETE_CODIGO, '99') <> CatTReforco
           and 1 > (select sum(FN_VERBASEMIMPOSTO(vc.CON_CONHECIMENTO_CODIGO,vc.CON_CONHECIMENTO_SERIE, vc.GLB_ROTA_CODIGO, 'I_TTPV') - FN_VERBASEMIMPOSTO(vc.CON_CONHECIMENTO_CODIGO,vc.CON_CONHECIMENTO_SERIE, vc.GLB_ROTA_CODIGO, 'I_CTCR'))
                    from t_con_valefrete v,
                         t_con_vfreteconhec vc
                    where 0 = 0
                      and v.con_conhecimento_codigo = vf.con_conhecimento_codigo
                      and v.con_conhecimento_serie  = vf.con_conhecimento_serie
                      and v.glb_rota_codigo         = vf.glb_rota_codigo
                      and v.con_valefrete_saque     = vf.con_valefrete_saque
                      and vc.con_valefrete_codigo = v.con_conhecimento_codigo
                      and vc.con_valefrete_serie = v.con_conhecimento_serie
                      and vc.glb_rota_codigovalefrete = v.glb_rota_codigo
                      and vc.con_valefrete_saque = v.con_valefrete_saque);
     vAuxiliar NUMBER;
 BEGIN
    vAuxiliar := 0;
    FOR R_VFRETE IN C_VFRETE LOOP
       UPDATE T_CON_VALEFRETE VFC
         SET VFC.CON_VALEFRETE_CUSTOCARRETEIRO = VFC.CON_VALEFRETE_CUSTOCARRETEIRO
       WHERE VFC.CON_CONHECIMENTO_CODIGO = R_VFRETE.CON_CONHECIMENTO_CODIGO
         AND VFC.CON_CONHECIMENTO_SERIE  = R_VFRETE.CON_CONHECIMENTO_SERIE
         AND VFC.GLB_ROTA_CODIGO          = R_VFRETE.GLB_ROTA_CODIGO
         AND VFC.CON_VALEFRETE_SAQUE      = R_VFRETE.CON_VALEFRETE_SAQUE;
       vAuxiliar := vAuxiliar + 1;
       IF MOD(vAuxiliar,100) = 0 THEN
          COMMIT;
       END IF;

   END LOOP;

   COMMIT;
 END SP_CON_MARCARECALCULO;





   procedure SP_RecalculaCusto(pMargem in number default 10, -- qual a margem minima para o recalculo
                               pRota   in char default '000',
                               pStatus out char,
                               pMessage out varchar2)
   is
    vCursor1 PKG_GLB_COMMON.T_CURSOR;
    vCommit  number;
    vContador number;
    vErro     number;
    vHoraini  date;
    begin
     vHoraini  := sysdate;
     vCommit   := 100;
     vContador :=   0;
     vErro     :=   0;
     pStatus := pkg_glb_common.Status_Nomal;
     pMessage := '';
     FOR vCursor1 in
         (

         select distinct
                vf.con_conhecimento_codigo vfrete,
                vf.con_conhecimento_serie vfsr,
                vf.glb_rota_codigo vfrt,
                vf.con_valefrete_saque vfsq
         from tdvadm.t_con_vfreteconhec vfc,
              tdvadm.t_con_valefrete vf
--              tdvadm.t_con_calcconhecimento cc,
--              tdvadm.t_con_calcconhecimento ccc
         where 0 = 0
           and vfc.con_valefrete_codigo     = vf.con_conhecimento_codigo
           and vfc.con_valefrete_serie      = vf.con_conhecimento_serie
           and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
           and vfc.con_valefrete_saque      = vf.con_valefrete_saque
           and vf.con_catvalefrete_codigo not in (CatTReforco,
                                                  CatTRemocao,
                                                  CatTServicoTerceiro)
           and vf.glb_rota_codigo = decode(nvl(pRota,'000'),'000',vf.glb_rota_codigo,pRota)
           and vf.con_valefrete_datacadastro >=  add_months(sysdate,-2)
           and vf.con_valefrete_datacadastro < sysdate
/*           and vfc.con_conhecimento_codigo = cc.con_conhecimento_codigo
           and vfc.con_conhecimento_serie = cc.con_conhecimento_serie
           and vfc.glb_rota_codigo = cc.glb_rota_codigo
           and cc.slf_reccust_codigo = 'I_TTPV'

           and vfc.con_conhecimento_codigo = ccc.con_conhecimento_codigo
           and vfc.con_conhecimento_serie = ccc.con_conhecimento_serie
           and vfc.glb_rota_codigo = ccc.glb_rota_codigo
           and ccc.slf_reccust_codigo = 'I_CTCR'

           and ( cc.con_calcviagem_valor > 0 or cc.con_calcviagem_valor < 0 )
           and round(( 1 - (ccc.con_calcviagem_valor / cc.con_calcviagem_valor)) * 100,2) < nvl(pMargem,10)

*/
           and tdvadm.fn_busca_conhec_verba(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo,'I_TTPV')  > 0
           and ROUND((1 - (tdvadm.fn_busca_conhec_verba(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo,'I_CTCR') /  
                           tdvadm.fn_busca_conhec_verba(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo,'I_TTPV')) * 100),2) < nvl(pMargem,10)



           
/*           
         select distinct
                vf.con_conhecimento_codigo vfrete,
                vf.con_conhecimento_serie vfsr,
                vf.glb_rota_codigo vfrt,
                vf.con_valefrete_saque vfsq
         from t_con_vfreteconhec vfc,
              t_con_valefrete vf
         where 0 = 0
           and vfc.glb_rota_codigo = decode(nvl(pRota,'000'),'000',vfc.glb_rota_codigo,pRota)
           and vf.con_valefrete_datacadastro >=  add_months(sysdate,-2)
           and vf.con_valefrete_datacadastro < sysdate
           and fn_busca_conhec_verba(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo,'I_TTPV') <> 0
           and vfc.con_valefrete_codigo     = vf.con_conhecimento_codigo
           and vfc.con_valefrete_serie      = vf.con_conhecimento_serie
           and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
           and vfc.con_valefrete_saque      = vf.con_valefrete_saque
           and vf.con_catvalefrete_codigo not in (CatTReforco,
                                                  CatTRemocao,
                                                  CatTServicoTerceiro)
           and round(( 1 - (fn_busca_conhec_verba(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo,'I_CTCR') / fn_busca_conhec_verba(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo,'I_TTPV'))) * 100,2) < nvl(pMargem,10)

*/
        )
       loop
          begin
             update t_con_valefrete vf
               set vf.con_valefrete_custocarreteiro = vf.con_valefrete_custocarreteiro
             where vf.con_conhecimento_codigo = vCursor1.Vfrete
               and vf.con_conhecimento_serie  = vCursor1.Vfsr
               and vf.glb_rota_codigo         = vCursor1.Vfrt
               and vf.con_valefrete_saque     = vCursor1.Vfsq;

             vContador := vContador + 1;
             if mod(vContador,vCommit) = 0 Then
                Commit;
            End if;
          exception
            when OTHERS Then
               pStatus :=  pkg_glb_common.Status_Erro;
               pMessage := pMessage || 'VFrete ' || vCursor1.Vfrete || '-' || vCursor1.Vfsr || '-' || vCursor1.Vfrt || '-' || vCursor1.Vfsq || chr(10) ||
                                       'Erro: ' || sqlerrm || chr(10);
               vErro := vErro + 1;
            end;


       end loop;
       pMessage := pMessage || chr(10) || 'Total Processados ' || to_char(vContador) || ' Total erro ' || to_char(vErro)  || ' rodou das ' || to_char(vHoraini,'dd/mm/yyyy hh24:mi:ss') || ' a ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || chr(10) ;
       Commit;
       SP_ATUVERBA_VFRETE;
   end SP_RecalculaCusto;

   procedure SP_RecalculaCusto is
     vStatus char(1);
     vMessage varchar2(32000);
   Begin
      begin
         PKG_CON_VALEFRETE.SP_RecalculaCusto(5,'000',vStatus,vMessage);
 --        wservice.pkg_glb_email.SP_ENVIAEMAIL('MARCA RECALCULO',vMessage,'aut-e@dellavolpe.com.br');
      exception
         when OTHERS Then
        wservice.pkg_glb_email.SP_ENVIAEMAIL('MARCA RECALCULO COM ERRO',sqlerrm || chr(10) || vMessage,'aut-e@dellavolpe.com.br','sdrumond@dellavolpe.com.br');
       End;


   End SP_RecalculaCusto;


   PROCEDURE spi_GravarValefrete(P_QRYSTR   In VARCHAR2,
                                 P_STATUS   OUT CHAR,
                                 P_MESSAGE  OUT VARCHAR2) As
   Begin
      P_STATUS :=  pkg_glb_common.Status_Nomal;

   End spi_GravarValefrete;



   PROCEDURE SP_CON_VALIDAVALEFRETE2(P_QRYSTR   In blob,
                                    P_XMLOUT   Out clob,
                                    P_STATUS   OUT CHAR,
                                    P_MESSAGE  OUT VARCHAR2) As
   vCursor    t_cursor;
   vXmlTabOutxml   xmltype;
   x varchar2(32767);
   pclob    clob;

   Begin
 --          pclob := CONVERT(blobtoclob(P_QRYSTR), 'US7ASCII', 'WE8ISO8859P1');
           pclob := glbadm.pkg_glb_blob.f_blob2clob(P_QRYSTR);
           P_STATUS  := pkg_glb_common.Status_Nomal;
           P_MESSAGE := '' ; -- Processamento normal!';
           P_XMLOUT := '';
           tpVF.vXmlTab := pclob;
          tpVF.VFNumero                       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFNumero' ));
          tpVF.VFSerie                        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFSerie' ));
          tpVF.VFRota                         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( tpVF.vXmlTab,'VFRota' ));

           EXECUTE immediate('ALTER SESSION SET nls_date_format = "DD/MM/YYYY HH24:MI:SS"');
           open vCursor for select *
                            From t_con_valefrete vf
                            Where vf.con_conhecimento_codigo = tpVF.VFNumero
                              And vf.con_conhecimento_serie  = tpVF.VFSerie
                              And vf.glb_rota_codigo         = tpVF.VFRota
                            order by vf.con_valefrete_saque  ;
 --                              And vf.con_valefrete_saque     = tpVF.vUltimoSaqueValido


           -- Crio um XML a partir de um Cursor
           pkg_glb_xml.sp_getxmltable('ValeFrete',vCursor,vXmlTabOutxml,P_STATUS,P_MESSAGE);

           EXECUTE immediate('ALTER SESSION SET nls_date_format = "DD/MM/YYYY"');
           tpVF.vXmlTab :=           '<parametros><output>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Status>'              || trim(P_STATUS)                    || '</Status>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<Message>'             || trim(P_MESSAGE)                   || '</Message>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '<tables>';
 --          tpVF.vXmlTab := tpVF.vXmlTab|| fn_limpa_campoxml(vXmlTabOutclob);
           tpVF.vXmlTab := tpVF.vXmlTab|| fn_limpa_campoxml(vXmlTabOutxml.getclobval());
           tpVF.vXmlTab := tpVF.vXmlTab|| '</tables>';
           tpVF.vXmlTab := tpVF.vXmlTab|| '</output></parametros>';

           P_XMLOUT := tpVF.vXmlTab;
           P_MESSAGE := to_char(length(trim(pclob)));


   End;

   procedure sp_con_duplicidade_cax(pRota in tdvadm.t_glb_rota.glb_rota_codigo%type) as
     vAnterior tdvadm.t_cax_movimento.cax_movimento_historico%type;
   Begin

   pkg_ctb_caixa.vAutorizaExclusaoFe := 'S';

   vAnterior := 'anterior';

   for c_msg in (SELECT m1.glb_rota_codigo,
                        m1.cax_boletim_data,
                        M1.Glb_Rota_Codigo_Operacao,
                        M1.Cax_Operacao_Codigo,
                        M1.Cax_Movimento_Documento,
                        M1.Cax_Movimento_Serie,
                        M1.Glb_Rota_Codigo_Referencia,
                        M1.cax_movimento_doccomplemento,
                        M1.cax_movimento_valor,
                        m1.cax_movimento_historico,
                        m1.rowid
                 FROM T_CAX_MOVIMENTO M1
                 WHERE 0 = 0
                   and m1.glb_rota_codigo = pRota
                   and m1.cax_boletim_data >= '01/09/2013'
                   and 1 < (select count(*)
                            From t_cax_movimento m
                            where 0 = 0
                              and m.cax_boletim_data >= '01/09/2013'
                              and m.glb_rota_codigo_operacao     = M1.Glb_Rota_Codigo_Operacao
                              and m.cax_operacao_codigo          = M1.Cax_Operacao_Codigo
                              and m.cax_movimento_documento      = M1.Cax_Movimento_Documento
                              and m.cax_movimento_historico      = m1.cax_movimento_historico
                              and nvl(m.cax_movimento_serie,'1')          = nvl(M1.Cax_Movimento_Serie,'1')
                              and nvl(m.glb_rota_codigo_referencia,'1')   = nvl(M1.Glb_Rota_Codigo_Referencia,'1')
                              and nvl(m.cax_movimento_doccomplemento,'1') = nvl(M1.cax_movimento_doccomplemento,'1')
                              and m.cax_movimento_valor          = M1.cax_movimento_valor)
                 order by        M1.Glb_Rota_Codigo_Operacao,
                        M1.Cax_Operacao_Codigo,
                        M1.Cax_Movimento_Documento,
                        M1.Cax_Movimento_Serie,
                        M1.Glb_Rota_Codigo_Referencia,
                        M1.cax_movimento_doccomplemento,
                        M1.cax_movimento_valor,
                        m1.cax_movimento_historico,
                        m1.cax_boletim_data)
           loop
              if vAnterior = c_msg.cax_movimento_historico Then
                 delete t_cax_movimento m where m.rowid = c_msg.rowid;
              Else
                 vAnterior := c_msg.cax_movimento_historico;
              End if;
           End Loop;

   pkg_ctb_caixa.vAutorizaExclusaoFe := 'N';

   end sp_con_duplicidade_cax;


   Function fn_ListaEntregas(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                             pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                             pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                             pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type)
                             -- podendo ser D para Destinos
                             --             Q para quantidades
          return varchar2
     As
       vQtde      integer;
       vDescricao varchar2(3000);


    Begin
        vQtde := 0;
        vDescricao := '';
        for c_Cursor in (select lc.glb_estado_codigo ||'-'||trim(lc.glb_localidade_descricao) destino
                         From t_con_valefrete a,
                              t_fcf_solveic sv,
                              t_fcf_solveicdest svd,
                              t_glb_localidade lc
                         where sv.fcf_veiculodisp_codigo    = a.fcf_veiculodisp_codigo
                           and sv.fcf_veiculodisp_sequencia = a.fcf_veiculodisp_sequencia
                           and a.con_conhecimento_codigo = pVfreteCodigo
                           and a.con_conhecimento_serie  = pVfreteSerie
                           and a.glb_rota_codigo         = pVfreteRota
                           AND A.CON_VALEFRETE_Saque     = pVfreteSaque
                           and sv.fcf_solveic_cod        = svd.fcf_solveic_cod
                           and svd.glb_localidade_codigo = lc.glb_localidade_codigo
                         order by svd.fcf_solveicdest_ordem)

        Loop
             vQtde := vQtde + 1;
             vDescricao := vDescricao || trim(c_Cursor.destino) || ' # ';
         End Loop;
         vDescricao := lpad(vQtde,2,'0') || ' - ' || vDescricao;
         Return  trim(vDescricao);

     End fn_ListaEntregas;

   Function fn_ListaAtivos(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                           pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                           pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                           pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type)
          return varchar2
     As

     vAtivo tdvadm.t_ati_ativo.ati_ativo_descricao%type;
     vDescricao varchar2(2000);


    Begin

        vAtivo := 'Sirlano';
        vDescricao := '';
        for c_Cursor in (SELECT B.ATI_ATIVO_DESCRICAO,
                                A.ATI_MOVATIVO_DOCUMENTO,
                                A.ATI_MOVATIVO_QTDE
                         FROM T_ATI_MOVATIVO A,
                              T_ATI_ATIVO B
                         WHERE  0 = 0
                           and A.CON_VALEFRETE_CODIGO = pVfreteCodigo
                           AND  A.CON_VALEFRETE_SERIE  = pVfreteSerie
                           AND  A.GLB_ROTA_CODIGOVALEFRETE = pVfreteRota
                           AND  A.CON_VALEFRETE_SAQUE  = pVfreteSaque
                           AND  A.ATI_ATIVO_CODIGO = B.ATI_ATIVO_CODIGO
                           AND  A.ATI_ATIVO_DONO   = B.ATI_ATIVO_DONO
                         ORDER BY 1)

        Loop
            If c_Cursor.Ati_Ativo_Descricao <> vAtivo Then
               vDescricao := vDescricao || c_Cursor.Ati_Ativo_Descricao || ' DOC-' || c_Cursor.Ati_Movativo_Documento || ' QTD-' || c_Cursor.Ati_Movativo_Qtde || ' ';
               vAtivo := c_Cursor.Ati_Ativo_Descricao;
            Else
               vDescricao := vDescricao || 'DOC-' || c_Cursor.Ati_Movativo_Documento || ' QTD-' || c_Cursor.Ati_Movativo_Qtde || ' ';
            End If;
         End Loop;

         Return  trim(vDescricao);

     End fn_ListaAtivos;

   Function fn_ListaCte(pVfreteCodigo   in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                        pVfreteSerie    in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                        pVfreteRota     in tdvadm.t_glb_rota.glb_rota_codigo%type,
                        pVfreteSaque    in tdvadm.t_glb_rota.glb_rota_codigo%type)
          return varchar2
     As

     vAnterior number;
     vInicoSeq char(10);
     vAnteriorImp char(10);
     vLista    varchar2(32000);
     vSeq      char(1);

    Begin

        vAnterior := 0;
        vLista    := '';
        vSeq      := 'N';
        vInicoSeq := '';
        vAnteriorImp := '';
        for c_Cursor in (SELECT vc.glb_rota_codigo || '-' || vc.con_conhecimento_codigo Atual,
                                to_number(vc.glb_rota_codigo || vc.con_conhecimento_codigo) nr
                         FROM tdvadm.t_con_vfreteconhec vc
                         WHERE  0 = 0
                           and vc.CON_VALEFRETE_CODIGO = pVfreteCodigo
                           AND vc.CON_VALEFRETE_SERIE  = pVfreteSerie
                           AND vc.GLB_ROTA_CODIGOVALEFRETE = pVfreteRota
                           AND vc.CON_VALEFRETE_SAQUE  = pVfreteSaque
                         ORDER BY 1)

        Loop
             if ( c_Cursor.Nr - vAnterior ) = 1 Then
                if vSeq = 'N' Then
                   vInicoSeq := vAnteriorImp;
                   vSeq := 'S';
                End If;
             Else
                 if vSeq = 'S' Then
                    vLista := vLista || vInicoSeq || ' à ' || vAnteriorImp || ' ; ';
                    vSeq := 'N';
                 Else
                    If vAnterior <> 0 Then
                       vLista := vLista || vInicoSeq || ' ; ';
                    End If;
                 End If;
             End If;
             if vSeq = 'N' Then
                vInicoSeq := c_Cursor.Atual;
                vLista := vLista || vInicoSeq || ' ; ';
             End If;
             vAnterior    := c_Cursor.Nr ;
             vAnteriorImp := c_Cursor.Atual;

         End Loop;

         Return  trim(vLista);

     End fn_ListaCte;


   Function fn_PegaCodEstadia(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                              pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                              pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                              pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type,
                              pListaCliente in tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type,
                              pListaGrupo   in tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type)
          return varchar2
     As

     vAchouCli    number;
     vTamCli      number;
     vAchouGrupo  number;
     vTamGrupo    number;


    Begin
      
    
        for c_Cursor in (SELECT cl.glb_grupoeconomico_codigo,
                                count(cl.glb_grupoeconomico_codigo) qtdecnpj,
                                count(*) qtde
                         FROM tdvadm.t_con_vfreteconhec vc,
                              tdvadm.t_con_conhecimento cte,
                              tdvadm.t_glb_cliente cl
                         WHERE 0 = 0
                           and vc.con_conhecimento_codigo = cte.con_conhecimento_codigo
                           and vc.con_conhecimento_serie  = cte.con_conhecimento_serie
                           and vc.glb_rota_codigo         = cte.glb_rota_codigo
                           and cte.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                           and vc.CON_VALEFRETE_CODIGO = pVfreteCodigo
                           AND vc.CON_VALEFRETE_SERIE  = pVfreteSerie
                           AND vc.GLB_ROTA_CODIGOVALEFRETE = pVfreteRota
                           AND vc.CON_VALEFRETE_SAQUE  = pVfreteSaque
                         group by cl.glb_grupoeconomico_codigo
                         ORDER BY 2)
        Loop
              vAchouGrupo := instr(pListaGrupo,trim(c_cursor.glb_grupoeconomico_codigo));
              vTamGrupo   := length(trim(c_cursor.glb_grupoeconomico_codigo)) + 1;
        End Loop;



        for c_Cursor in (SELECT cl.glb_cliente_cgccpfcodigo,
                                count(cl.glb_cliente_cgccpfcodigo) qtdeCNPJ,
                                count(*) qtde
                         FROM tdvadm.t_con_vfreteconhec vc,
                              tdvadm.t_con_conhecimento cte,
                              tdvadm.t_glb_cliente cl
                         WHERE 0 = 0
                           and vc.con_conhecimento_codigo = cte.con_conhecimento_codigo
                           and vc.con_conhecimento_serie  = cte.con_conhecimento_serie
                           and vc.glb_rota_codigo         = cte.glb_rota_codigo
                           and cte.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                           and vc.CON_VALEFRETE_CODIGO = pVfreteCodigo
                           AND vc.CON_VALEFRETE_SERIE  = pVfreteSerie
                           AND vc.GLB_ROTA_CODIGOVALEFRETE = pVfreteRota
                           AND vc.CON_VALEFRETE_SAQUE  = pVfreteSaque
                         group by cl.glb_cliente_cgccpfcodigo
                         ORDER BY 2)
        Loop
              vAchouCli := instr(pListaCliente,trim(c_cursor.glb_cliente_cgccpfcodigo));
              vTamCli   := length(trim(c_cursor.glb_cliente_cgccpfcodigo)) + 1;
        End Loop;


         if vAchouCli > 0 then
            Return substr(pListaCliente,vAchouCli + vTamCli , 3);
         Elsif vAchouGrupo > 0 then
            Return substr(pListaGrupo,vAchouGrupo + vTamGrupo , 3);

        Else
            Return '000';
         End If;

     End fn_PegaCodEstadia;


   Function fn_DiarioBordoEmitido(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                  pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                  pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                  pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type)
          return varchar2
          -- S - Emitido
          -- N - Não Emitido
          -- L - Livre ( Não Emitido )
     As

     vAchouCli    number;
     vTamCli      number;
     vTamGrupo    number;
     vAchouGrupo  number;
     vAchouPlaca  number;
     vAchouContrato number;
     vAchouDiario number;
     vSaqueViagem number;
     vMenorData   date;
     vListaCliente varchar2(1000) := '';
     vListaGrupo   varchar(1000)  := '';
     vObrigatorio Char(1);
     vListaPlaca  varchar2(100) := ''; --,0002248,0002250,0002252,0002290,0002292,0002294,0002296,0002300,';
     vListaContrato varchar2(100) := ',1791115,179115,'; -- TCN


    Begin
        -- Verifica se é o menor Saque Valido
        select min(v.con_valefrete_saque),
               min(trunc(v.con_valefrete_datacadastro))
          into vSaqueViagem,
               vMenorData
        from t_con_valefrete v
        where v.con_conhecimento_codigo = pVfreteCodigo
          and v.con_conhecimento_serie = pVfreteSerie
          and v.glb_rota_codigo = pVfreteRota
          and nvl(v.con_valefrete_status,'N') <> 'C';


        -- Inicio da Operação de Diario de Bordo
        if vMenorData < to_date('01/12/2013','dd/mm/yyyy') Then
            Return 'L';
        End If;

        -- Obrigatorio somente para o Saque da Viagem
        if  vSaqueViagem <> pVfreteSaque Then
            Return 'L';
        End If;

        -- Rota de Coleta esta liberada
        if  pVfreteRota >= '900' Then
            Return 'L';
        End If;

        vAchouCli      := 0;
        vAchouGrupo    := 0;
        vAchouContrato := 0;
        vAchouPlaca    := 0;
        for c_Cursor in (SELECT distinct cl.glb_cliente_cgccpfcodigo,
                                         cl.glb_grupoeconomico_codigo  ,
                                         vf.con_valefrete_placa,
                                         trim(ta.slf_tabela_contrato) || trim(sf.slf_solfrete_contrato) Contrato
                         FROM tdvadm.t_con_vfreteconhec vc,
                              tdvadm.t_con_valefrete vf,
                              tdvadm.t_con_conhecimento cte,
                              tdvadm.t_glb_cliente cl,
                              tdvadm.t_slf_solfrete sf,
                              tdvadm.t_slf_tabela ta
                         WHERE  0 = 0

                           and vc.con_valefrete_codigo      = vf.con_conhecimento_codigo
                           and vc.con_valefrete_serie       = vf.con_conhecimento_serie
                           and vc.glb_rota_codigovalefrete  = vf.glb_rota_codigo
                           and vc.con_valefrete_saque       = vf.con_valefrete_saque

                           and vc.con_conhecimento_codigo   = cte.con_conhecimento_codigo
                           and vc.con_conhecimento_serie    = cte.con_conhecimento_serie
                           and vc.glb_rota_codigo           = cte.glb_rota_codigo

                           and cte.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo

                           and cte.slf_solfrete_codigo = sf.slf_solfrete_codigo (+)
                           and cte.slf_solfrete_saque  = sf.slf_solfrete_saque (+)

                           and cte.slf_tabela_codigo   = ta.slf_tabela_codigo (+)
                           and cte.slf_tabela_saque    = ta.slf_tabela_saque (+)

                           and vc.CON_VALEFRETE_CODIGO      = pVfreteCodigo
                           AND vc.CON_VALEFRETE_SERIE       = pVfreteSerie
                           AND vc.GLB_ROTA_CODIGOVALEFRETE  = pVfreteRota
                           AND vc.CON_VALEFRETE_SAQUE       = pVfreteSaque

                         ORDER BY 1)

        Loop

              if vAchouPlaca = 0 then
                 vAchouPlaca := nvl(instr(vListaPlaca,trim(c_cursor.con_valefrete_placa)),0);
              end if;

              if vAchouCli = 0 then
                 vAchouCli   := nvl(instr(vListaCliente,trim(c_cursor.glb_cliente_cgccpfcodigo)),0);
              end if;
              if vAchouContrato = 0  Then
                 vAchouContrato := nvl(instr(vListaContrato,trim(c_cursor.Contrato)),0);
              End If;

              if vTamCli = 0 then
                 vTamCli     := length(trim(c_cursor.glb_cliente_cgccpfcodigo)) + 1;
              end if;

              if vAchouGrupo = 0 then
                 vAchouGrupo := instr(vListaGrupo,trim(c_cursor.glb_grupoeconomico_codigo));
              end if;

              if vTamGrupo = 0 then
                 vTamGrupo   := length(trim(c_cursor.glb_grupoeconomico_codigo)) + 1;
              end if;

         End Loop;
         -- coloca se é obrigatorio ou nao ou livre
         if vAchouPlaca > 0 Then
           vObrigatorio := 'N' ;
         ElsIf vAchouContrato > 0 then
           vObrigatorio := 'N' ;
         ElsIf vAchouCli > 0 then
           vObrigatorio := 'S' ; --Return substr(vListaCliente,vAchouCli + vTamCli , 3);
         Elsif vAchouGrupo > 0 then
           vObrigatorio := 'S' ; --Return 'S'; --substr(vListaGrupo,vAchouGrupo + vTamGrupo , 3);

        Else
           vObrigatorio := 'N' ; --Return 'N'; -- '000';
         End If;



          Select count(*)
              into vAchouDiario
            From t_con_valefrete vf
            Where vf.con_conhecimento_codigo = pVfreteCodigo
              and vf.con_conhecimento_serie = pVfreteSerie
              and vf.glb_rota_codigo = pVfreteRota
              and vf.con_valefrete_saque = pVfreteSaque
              and vf.con_valefrete_diariobordo = 'S';

          if vAchouDiario > 0 Then
             Return 'S';
          Else
             if vObrigatorio = 'S' Then
                Return 'N';
             Else
               Return 'L';
             End If;
          End If;



     End fn_DiarioBordoEmitido;

   Procedure Sp_Get_ValeFreteImpDiario(pXmlIn   In Varchar2,
                                       pCursor  Out Types.cursorType,
                                       pStatus  Out Char,
                                       pMessage Out Varchar2)
   As
   vConhecimento T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE;
   vSerie        T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE;
   vRota         T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE;
   vSaque        T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
   vCount Number;
   Begin



       Begin
            SELECT TRIM(extractvalue(Value(xml), 'Input/Conhecimento')),
                   TRIM(extractvalue(Value(xml), 'Input/Serie')),
                   TRIM(extractvalue(Value(xml), 'Input/Rota')),
                   TRIM(extractvalue(Value(xml), 'Input/Saque'))
               Into vConhecimento,
                    vSerie,
                    vRota,
                    vSaque
               FROM TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input'))) xml;
        Exception
          When Others Then
            Open pCursor For select sysdate from dual;
            pStatus := 'E';
            pMessage := 'Erro ao converter Xml de Entrada.'||chr(13)||sqlerrm;
            return;
        End;

         SELECT Count(*)
           Into vCount
           FROM T_CON_CALCVALEFRETE K,
                t_con_vfreteciot cio,
                t_con_calcvalefretetp tp

           WHERE to_number(Trim(K.CON_CONHECIMENTO_CODIGO))  = to_number(trim(vConhecimento)) --'005520'
           AND K.CON_CONHECIMENTO_SERIE     = vSerie --'A1'
           AND K.GLB_ROTA_CODIGO            = vRota --'461'
           AND K.CON_VALEFRETE_SAQUE        = vSaque -- '1'
           AND K.CON_CALCVALEFRETE_FLAGPGTO = 'S'
           AND K.CON_CALCVALEFRETE_VALOR    <> 0
           and k.con_conhecimento_codigo    = cio.con_conhecimento_codigo(+)
           and k.con_conhecimento_serie     = cio.con_conhecimento_serie(+)
           and k.glb_rota_codigo            = cio.glb_rota_codigo(+)
           and k.con_valefrete_saque        = cio.con_valefrete_saque(+)
           and k.con_calcvalefretetp_codigo = tp.con_calcvalefretetp_codigo;

       Open pCursor For
         -- Consulta por Vale de Frete
         SELECT trim(tp.con_calcvalefretetp_codigo)||' - '||trim(tp.con_calcvalefretetp_descricao) "Tp parcela",
                k.con_conhecimento_codigo "Vale Frete",
                k.con_conhecimento_serie "Serie Vf",
                k.glb_rota_codigo "Rota Vf",
                k.con_valefrete_saque "Saque Vf",
                case
                  when k.con_calcvalefrete_dtpgto is not null then Pkg_Cfe_Pgtofreteeletr.STATUS_PAGO
                  when k.con_calcvalefrete_dtliberacao is not null then Pkg_Cfe_Pgtofreteeletr.STATUS_LIBERADO
                  when k.con_calcvalefrete_dtbloqueio is not null then Pkg_Cfe_Pgtofreteeletr.STATUS_BLOQUEADO
                  else Pkg_Cfe_Pgtofreteeletr.STATUS_PENDENTE
                end "Status",
                k.usu_usuario_codigoliberou "Usuario Lib",
                k.con_calcvalefrete_dtliberacao "Dt Lib",
                k.usu_usuario_bloqueou "Usuario Bloq",
                k.con_calcvalefrete_dtbloqueio "Dt Bloq",
                k.usu_usuario_codigopgto "Usuario Pgto",
                k.con_calcvalefrete_dtpgto "Dt Pgto",

                k.con_calcvalefrete_codparoper "Cod Parcela",
                k.con_calcvalefrete_valor "Valor Parcela",
                /* ******************************************************************************************************** */
                /* Atenção ao alterar o nome de "ID Consulta e Rota Consulta, afeterá diretamente a app prj_pgtoFreteEletr" */
                cio.con_freteoper_id "ID Consulta",
                cio.con_freteoper_rota "Rota Consulta",
                /* ******************************************************************************************************** */

 /*               Fn_GetStatus(k.con_conhecimento_codigo,
                             k.con_conhecimento_serie,
                             k.glb_rota_codigo,
                             k.con_valefrete_saque) "Status",*/
                'VF' "Tp Doc"
           FROM T_CON_CALCVALEFRETE K,
                t_con_vfreteciot cio,
                t_con_calcvalefretetp tp

           WHERE to_number(Trim(K.CON_CONHECIMENTO_CODIGO))  = to_number(trim(vConhecimento)) --'005520'
           AND K.CON_CONHECIMENTO_SERIE     = vSerie --'A1'
           AND K.GLB_ROTA_CODIGO            = vRota --'461'
           AND K.CON_VALEFRETE_SAQUE        = vSaque -- '1'
           AND K.CON_CALCVALEFRETE_FLAGPGTO = 'S'
           AND K.CON_CALCVALEFRETE_VALOR    <> 0
           and k.con_conhecimento_codigo    = cio.con_conhecimento_codigo(+)
           and k.con_conhecimento_serie     = cio.con_conhecimento_serie(+)
           and k.glb_rota_codigo            = cio.glb_rota_codigo(+)
           and k.con_valefrete_saque        = cio.con_valefrete_saque(+)
           and k.con_calcvalefretetp_codigo = tp.con_calcvalefretetp_codigo;

        pStatus := 'N';
        if vCount > 0 then
            pMessage := 'OK';
        else
            pMessage := 'Não foi possivel localizar VF';
        end if;

   End Sp_Get_ValeFreteImpDiario;


   Function fn_DiarioBordoRecebido(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                   pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                   pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                   pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type)
          return varchar2
          -- S - Recebido
          -- N - Não Recebido
          -- L - Livre ( Não Emitido )
     As

     vAchouCli    number;
     vTamCli      number;
     vAchouGrupo  number;
     vTamGrupo    number;
     vAchouDiario number;
     vSaqueViagem number;
     vMenorData   date;
     vListaCliente varchar2(1000) := '';
     vListaGrupo   varchar(1000)  := '';
     vObrigatorio Char(1);


    Begin
        -- Verifica se é o menor Saque Valido
        select v.con_valefrete_diariobordo
          into vObrigatorio
        from t_con_valefrete v
        where v.con_conhecimento_codigo = pVfreteCodigo
          and v.con_conhecimento_serie  = pVfreteSerie
          and v.glb_rota_codigo         = pVfreteRota
          and v.con_valefrete_saque     = pVfreteSaque;



         if vObrigatorio = 'S' Then
            Select count(*)
              into vAchouDiario
            From t_con_diariobordo vf
            Where vf.con_conhecimento_codigo = pVfreteCodigo
              and vf.con_conhecimento_serie  = pVfreteSerie
              and vf.glb_rota_codigo         = pVfreteRota
              and vf.con_valefrete_saque     = pVfreteSaque
              and vf.glb_solicitacao_dtgravacao = (select max(vf1.glb_solicitacao_dtgravacao)
                                                   from t_con_diariobordo vf1
                                                   where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                                                     and vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                                                     and vf1.glb_rota_codigo         = vf.glb_rota_codigo
                                                     and vf1.con_valefrete_saque = vf.con_valefrete_saque);

              if vAchouDiario > 0 Then
                 Return 'S';
              Else
                 Return 'N';
              End If;

        Else
            Return 'L';
         End If;



     End fn_DiarioBordoRecebido;

   Function Fn_DiarioBordoStatusFull(pVfreteCodigo in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                     pVfreteSerie  in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                     pVfreteRota   in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                     pVfreteSaque  in tdvadm.t_glb_rota.glb_rota_codigo%type)
     return varchar2
   As
   vStatus Varchar2(100);

  Begin
      if Tdvadm.PKG_CON_VALEFRETE.fn_DiarioBordoEmitido(pVfreteCodigo,
                                                        pVfreteSerie,
                                                        pVfreteRota,
                                                        pVfreteSaque) = 'N' Then
            vStatus := 'Não';
      elsif Tdvadm.PKG_CON_VALEFRETE.fn_DiarioBordoEmitido(pVfreteCodigo,
                                                           pVfreteSerie,
                                                           pVfreteRota,
                                                           pVfreteSaque) = 'S'
          and Tdvadm.PKG_CON_VALEFRETE.fn_DiarioBordoRecebido(pVfreteCodigo,
                                                              pVfreteSerie,
                                                              pVfreteRota,
                                                              pVfreteSaque) = 'N' Then
            vStatus := 'Emitido';
      elsif Tdvadm.PKG_CON_VALEFRETE.fn_DiarioBordoEmitido(pVfreteCodigo,
                                                           pVfreteSerie,
                                                           pVfreteRota,
                                                           pVfreteSaque) = 'S'
          and Tdvadm.PKG_CON_VALEFRETE.fn_DiarioBordoRecebido(pVfreteCodigo,
                                                              pVfreteSerie,
                                                              pVfreteRota,
                                                              pVfreteSaque) = 'S' Then
            vStatus := 'Recebido';

      elsif Tdvadm.PKG_CON_VALEFRETE.fn_DiarioBordoEmitido(pVfreteCodigo,
                                                           pVfreteSerie,
                                                           pVfreteRota,
                                                           pVfreteSaque) = 'L' Then

            vStatus := 'Liberado';


     else
            vStatus := Tdvadm.PKG_CON_VALEFRETE.fn_DiarioBordoEmitido(pVfreteCodigo,
                                                                      pVfreteSerie,
                                                                      pVfreteRota,
                                                                      pVfreteSaque);

     end if;


      return vStatus;
   End Fn_DiarioBordoStatusFull;

   Procedure Sp_Con_ValidavfretemdfeNew(p_vfnumero  in t_con_valefrete.con_conhecimento_codigo%type,
                                        p_vfserie   in t_con_valefrete.con_conhecimento_serie%type,
                                        p_vfrota    in t_con_valefrete.glb_rota_codigo%type,
                                        p_vfsaque   in t_con_valefrete.con_valefrete_saque%type,
                                        p_parametro in varchar2,
                                        p_status   out char,
                                        p_message  out varchar2)as
   vStatus           char(1);
   vMessage          varchar2(2000);
   vQtde             integer;
   vQtdeDocumentos   integer;
   vQtdeMdfe         integer;
   vQtdeMdfeOk       integer;
   vListaParams      glbadm.pkg_listas.tlistausuparametros;
   vUsuarioTdv       t_usu_usuario.usu_usuario_codigo%type;
   vRotaAplicacao    t_usu_usuario.glb_rota_codigo%type;
   vVersaoApp        t_usu_aplicacao.usu_aplicacao_versao%type;
   vAplicacao        t_usu_aplicacao.usu_aplicacao_codigo%type;
   vMdfeLiberado     t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type;
   vVfQtdeSaques     integer;
   vVfCatAvulsoCtrc  integer;
   vPrimeiroSaque    integer;
   vPlacaSaqueAtual  t_con_valefrete.con_valefrete_placa%type;
   vVfQtdeSqPlaca    integer;
   vDtEmissao        t_con_valefrete.con_valefrete_datacadastro%type;
   vCategoria        t_con_valefrete.con_catvalefrete_codigo%type;
   begin

    
--   INSERT INTO TDVADM.T_GLB_SQL
--     (GLB_SQL_INSTRUCAO, GLB_SQL_DTGRAVACAO, GLB_SQL_PROGRAMA)
--   VALUES
--     (P_PARAMETRO, SYSDATE, 'PGTOFRETE');

    begin


        vStatus         := pkg_glb_common.Status_Nomal;
        vMessage        := 'Conhecimento(s) não esta vinculado(s) a um Mdfe Autorizado!' || chr(13);
        vQtde           := 0;
        vQtdeDocumentos := 0;

        /**************************************************/
        /************** PARAMETRO DA APLICAÇÃO    *********/
        /**************************************************/


       begin

         if P_PARAMETRO is not null then
            vUsuarioTdv      := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFUsuarioTDV');
            vRotaAplicacao   := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFRotaUsuarioTDV');
            vVersaoApp       := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFVersaoAplicao');
            vAplicacao       := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFAplicacaoTDV');
         end if;

        exception when others then
          P_STATUS   := pkg_glb_common.Status_Warning;
          P_MESSAGE  := 'Erro ao buscar parametros, P_PARAMETRO: '||P_PARAMETRO||' Erro: '||sqlerrm;
          RETURN;
        end;

        if vUsuarioTdv is not null then


           if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacao,
                                                        vUsuarioTdv,
                                                        vRotaAplicacao,
                                                        vListaParams) Then

              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := P_MESSAGE || '10 - Erro ao Buscar Parametros.' || chr(10);
              return;
           else
             -- Parametro responsavel pela liberação do mdfe
             vMdfeLiberado := vListaParams('LIBERAMDFE').TEXTO;
             commit;
           End if;

        end if;
        

        


        /**********************************************************/
        /*** Analise se é o promeiro Saque Valido e Categoria   ***/
        /*** Avuldo Com Ctrc                                    ***/
        /**********************************************************/

       begin


          -- Placa do Saque analisado.
          select cc.con_valefrete_placa,
                 trunc(cc.con_valefrete_datacadastro),
                 cc.con_catvalefrete_codigo
            into vPlacaSaqueAtual,
                 vDtEmissao,
                 vCategoria
            from t_con_valefrete cc
           where cc.con_conhecimento_codigo = p_vfnumero
             and cc.con_conhecimento_serie  = p_vfserie
             and cc.glb_rota_codigo         = p_vfrota
             and cc.con_valefrete_saque     = p_vfsaque;

          -- Quantidade de Saques
          select count(*)
            into vVfQtdeSaques
            from t_con_valefrete vf
           where vf.con_conhecimento_codigo         = p_vfnumero
             and vf.con_conhecimento_serie          = p_vfserie
             and vf.glb_rota_codigo                 = p_vfrota
             and nvl(vf.con_valefrete_status,'N')   = 'N';


          -- Quantidade de Vales de Frete com a Placa <> Do saque
          select count(*)
            into vVfQtdeSqPlaca
            from t_con_valefrete cc
           where cc.con_conhecimento_codigo         = p_vfnumero
             and cc.con_conhecimento_serie          = p_vfserie
             and cc.glb_rota_codigo                 = p_vfrota
             and nvl(cc.con_valefrete_status,'N')   = 'N'
             and cc.con_valefrete_saque            <> p_vfsaque
             and cc.con_valefrete_placa             = vPlacaSaqueAtual;


           If vCategoria = PKG_CON_VALEFRETE.CatTEstadia Then
              vMdfeLiberado := 'L';
           End If;


       end;
        /**********************************************************/


        /**********************************************************/
        /*** Analise se aquele Vale de Frete esta vinculando a  ***/
        /*** Veiculo Disp / Manifesto Autorizado                ***/
        /**********************************************************/


       begin


          -- Conceito de analise de MDFE Avulso
          select count(*)
            into vQtde
            from t_con_valefrete l,
                 t_con_veicdispvf vv,
                 t_con_veicdispmanif vm,
                 t_con_controlemdfe cc
            where l.con_conhecimento_codigo     = p_vfnumero
              and l.con_conhecimento_serie      = p_vfserie
              and l.glb_rota_codigo             = p_vfrota
              and l.con_valefrete_saque         = p_vfsaque
              and l.con_conhecimento_codigo     = vv.con_conhecimento_codigo
              and l.con_conhecimento_serie      = vv.con_conhecimento_serie
              and l.glb_rota_codigo             = vv.glb_rota_codigo
              and l.con_valefrete_saque         = vv.con_valefrete_saque
              and vv.fcf_veiculodisp_codigo     = vm.fcf_veiculodisp_codigo
              and vv.fcf_veiculodisp_sequencia  = vm.fcf_veiculodisp_sequencia
              and vm.con_manifesto_codigo       = cc.con_manifesto_codigo
              and vm.con_manifesto_serie        = cc.con_manifesto_serie
              and vm.con_manifesto_rota         = cc.con_manifesto_rota
              and cc.con_mdfestatus_codigo      IN ('OK','EN')
              and cc.con_controlemdfe_codstenv  = '100';

          -- Conceito de Vf feito pelo o FIFO
          if (vQtde) = 0 then


            -- Contando os MDFE gerados para aquele Veic Disp
            select count(*)
              into vQtdeMdfe
              from t_con_valefrete vf,
                   t_con_veicdispmanif ma
             where vf.con_conhecimento_codigo   = p_vfnumero
               and vf.con_conhecimento_serie    = p_vfserie
               and vf.glb_rota_codigo           = p_vfrota
               and vf.con_valefrete_saque       = p_vfsaque
               and vf.fcf_veiculodisp_codigo    = ma.fcf_veiculodisp_codigo
               and vf.fcf_veiculodisp_sequencia = ma.fcf_veiculodisp_sequencia;

            -- Contando os MDFE gerados para Com o Status OK
            select count(*)
             into vQtdeMdfeOk
             from t_con_valefrete vf,
                  t_con_veicdispmanif ma,
                  t_con_controlemdfe  cc
            where vf.con_conhecimento_codigo   = p_vfnumero
              and vf.con_conhecimento_serie    = p_vfserie
              and vf.glb_rota_codigo           = p_vfrota
              and vf.con_valefrete_saque       = p_vfsaque
              and vf.fcf_veiculodisp_codigo    = ma.fcf_veiculodisp_codigo
              and vf.fcf_veiculodisp_sequencia = ma.fcf_veiculodisp_sequencia
              and ma.con_manifesto_codigo      = cc.con_manifesto_codigo
              and ma.con_manifesto_serie       = cc.con_manifesto_serie
              and ma.con_manifesto_rota        = cc.con_manifesto_rota
              and cc.con_mdfestatus_codigo     IN ('OK','EN');

            if (vQtdeMdfe <> 0) then

              if (vQtdeMdfe = vQtdeMdfeOk) then
                vQtde := 1;
              else
                vQtde := 0;
              end if;

            else

              vQtde := 0;

            end if;

          end if;

          -- Vf Liberados
          if (vQtde = 0) then


             select count(*)
               into vQtde
               from t_con_vflibmdfe mm
              where mm.con_conhecimento_codigo  =  p_vfnumero
                and mm.con_conhecimento_serie   =  p_vfserie
                and mm.glb_rota_codigo          =  p_vfrota
                and mm.con_valefrete_saque      =  p_vfsaque;


          end if;

        end;

        /**********************************************************/


        /**********************************************************/
        /*** Contagem de Documentos dentro de  do vale de frete ***/
        /**********************************************************/


       begin


          select count(*)
            into vQtdeDocumentos
            from t_con_vfreteconhec ll
           where ll.con_valefrete_codigo     = p_vfnumero
             and ll.con_valefrete_serie      = p_vfserie
             and ll.glb_rota_codigovalefrete = p_vfrota
             and ll.con_valefrete_saque      = p_vfsaque
             and TDVADM.f_busca_conhec_tpformulario(LL.con_conhecimento_codigo, LL.con_conhecimento_serie, LL.glb_rota_codigo) != 'NF';

        end;

        /**********************************************************/

        --vMdfeLiberado := 'N';
        -- Obriga Que o Vf esteja vinculado a um veic Disp com um MDFE autorizado.
            if vMdfeLiberado = 'N' then

              if    (vVfQtdeSaques = 1) then
                 --Caso tenha apenas NF(vQtdeDocumentos = 0) deixo passar
                 if (vQtde > 0 or vQtdeDocumentos = '0') then

                   p_status  := pkg_glb_common.Status_Nomal;
                   p_message := 'Processamento Normal.';

                 else

                   p_status  := pkg_glb_common.Status_Warning;
                   p_message := '1 - Vale de Frete não tem vinculo com um MDF-e autorizado!';

                 end if;


               elsif (vVfQtdeSaques > 1) then

                   if (vQtde > 0 or vQtdeDocumentos = '0') then

                       p_status  := pkg_glb_common.Status_Nomal;
                       p_message := 'Processamento Normal.';

                   else
                   
                       if (vVfQtdeSqPlaca = 0) and (vQtde = 0) then

                          p_status  := pkg_glb_common.Status_Warning;
                          p_message := '2 - Vale de Frete não tem vinculo com um MDF-e autorizado!';


                       elsif (vVfQtdeSqPlaca = 0) and (vQtde > 0) then

                          p_status  := pkg_glb_common.Status_Nomal;
                          p_message := 'Processamento Normal.';

                       elsif (vVfQtdeSqPlaca > 0) then

                          p_status  := pkg_glb_common.Status_Nomal;
                          p_message := 'Processamento Normal.';

                       end if;
                   
                   end if;

               end if;

            -- mdfe liberado só para cargar que contem viagens com 1 conhecimento.
            elsif vMdfeLiberado = 'L' then

              if    (vVfQtdeSaques = 1) and (vQtdeDocumentos > 1) then

                 if (vQtde > 0 ) then

                   p_status  := pkg_glb_common.Status_Nomal;
                   p_message := 'Processamento Normal.';

                 else

                   p_status  := pkg_glb_common.Status_Warning;
                   p_message := '3 - Vale de Frete não tem vinculo com um MDF-e autorizado!';

                 end if;

              elsif (vVfQtdeSaques = 1) and (vQtdeDocumentos = 1) then

                   p_status  := pkg_glb_common.Status_Nomal;
                   p_message := 'Processamento Normal.';

              elsif (vVfQtdeSaques > 1) and (vQtdeDocumentos > 1) then

                   if (vVfQtdeSqPlaca = 0) and (vQtde = 0) then

                      p_status  := pkg_glb_common.Status_Warning;
                      p_message := '4 - Vale de Frete não tem vinculo com um MDF-e autorizado!';


                   elsif (vVfQtdeSqPlaca = 0) and (vQtde > 0) then

                      p_status  := pkg_glb_common.Status_Nomal;
                      p_message := 'Processamento Normal.';

                   elsif (vVfQtdeSqPlaca > 0) then

                      p_status  := pkg_glb_common.Status_Nomal;
                      p_message := 'Processamento Normal.';

                   end if;

              elsif (vVfQtdeSaques > 1) and (vQtdeDocumentos = 1) then

                   p_status  := pkg_glb_common.Status_Nomal;
                   p_message := 'Processamento Normal.';

              end if;

            -- mdfe liberado para todas as cargas, independente da quantidade de mdfe.
            elsif vMdfeLiberado = 'T' then

              p_status  := pkg_glb_common.Status_Nomal;
              p_message := 'Processamento Normal.';

            end if;

     exception when others then
        p_status  := pkg_glb_common.Status_Erro;
        p_message := 'Erro ao Executar PKG_CON_VALEFRETE.Sp_Con_Validavfretemdfe Erro: '||sqlerrm;
      end;

   end Sp_Con_ValidavfretemdfeNew;

   Procedure Sp_Con_Validavfretemdfe(p_vfnumero  in t_con_valefrete.con_conhecimento_codigo%type,
                                     p_vfserie   in t_con_valefrete.con_conhecimento_serie%type,
                                     p_vfrota    in t_con_valefrete.glb_rota_codigo%type,
                                     p_vfsaque   in t_con_valefrete.con_valefrete_saque%type,
                                     p_parametro in varchar2,
                                     p_status   out char,
                                     p_message  out varchar2)as
   vStatus           char(1);
   vMessage          varchar2(2000);
   vQtde             integer;
   vQtdeDocumentos   integer;
   vListaParams      glbadm.pkg_listas.tlistausuparametros;
   vUsuarioTdv       t_usu_usuario.usu_usuario_codigo%type;
   vRotaAplicacao    t_usu_usuario.glb_rota_codigo%type;
   vVersaoApp        t_usu_aplicacao.usu_aplicacao_versao%type;
   vAplicacao        t_usu_aplicacao.usu_aplicacao_codigo%type;
   vMdfeLiberado     t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type;
   begin


    begin

        vStatus         := pkg_glb_common.Status_Nomal;
        vMessage        := 'Conhecimento(s) não esta vinculado(s) a um Mdfe Autorizado!' || chr(13);
        vQtde           := 0;
        vQtdeDocumentos := 0;

        /**************************************************/
        /************** PARAMETRO DA APLICAÇÃO    *********/
        /**************************************************/


       begin

         if P_PARAMETRO is not null then
            vUsuarioTdv      := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFUsuarioTDV');
            vRotaAplicacao   := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFRotaUsuarioTDV');
            vVersaoApp       := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFVersaoAplicao');
            vAplicacao       := GLBADM.pkg_glb_wsinterfacedb.fn_getparam(P_PARAMETRO,'VFAplicacaoTDV');
         end if;

        exception when others then
          P_STATUS   := pkg_glb_common.Status_Warning;
          P_MESSAGE  := 'Erro ao buscar parametros, P_PARAMETRO: '||P_PARAMETRO||' Erro: '||sqlerrm;
          RETURN;
        end;

        if vUsuarioTdv is not null then


           if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacao,
                                                        vUsuarioTdv,
                                                        vRotaAplicacao,
                                                        vListaParams) Then

              P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := P_MESSAGE || '10 - Erro ao Buscar Parametros.' || chr(10);
              return;
           else
             -- Parametro responsavel pela liberação do mdfe
             vMdfeLiberado := vListaParams('LIBERAMDFE').TEXTO;
             commit;
           End if;

        end if;

        for p_cursor in (select ch.con_conhecimento_codigo cte,
                                ch.con_conhecimento_serie serie,
                                ch.glb_rota_codigo rota,
                                (select count(*)
                                   from t_con_docmdfe l,
                                        t_con_controlemdfe mdf
                                  where l.con_conhecimento_codigo = ch.con_conhecimento_codigo
                                    and l.con_conhecimento_serie  = ch.con_conhecimento_serie
                                    and l.glb_rota_codigo         = ch.glb_rota_codigo
                                    and l.con_manifesto_codigo    = mdf.con_manifesto_codigo
                                    and l.con_manifesto_serie     = mdf.con_manifesto_serie
                                    and l.con_manifesto_rota      = mdf.con_manifesto_rota
                                    and mdf.con_controlemdfe_codstenv =  '100'
                                    and mdf.con_mdfestatus_codigo     in ('OK','EN')) qtde
                           from t_con_conhecimento ch,
                                t_con_controlectrce k,
                                t_con_vfreteconhec vf
                          where ch.con_conhecimento_codigo   = k.con_conhecimento_codigo
                            and ch.con_conhecimento_serie    = k.con_conhecimento_serie
                            and ch.glb_rota_codigo           = k.glb_rota_codigo
                            and ch.con_conhecimento_codigo   = vf.con_conhecimento_codigo
                            and ch.con_conhecimento_serie    = vf.con_conhecimento_serie
                            and ch.glb_rota_codigo           = vf.glb_rota_codigo
                            and vf.con_valefrete_codigo      = p_vfnumero
                            and vf.con_valefrete_serie       = p_vfserie
                            and vf.glb_rota_codigovalefrete  = p_vfrota
                            and vf.con_valefrete_saque       = p_vfsaque
                            and vf.glb_rota_codigo           = p_vfrota)
        loop

           vQtdeDocumentos := vQtdeDocumentos + 1;

           if p_cursor.qtde = 0 then


              vQtde    := vQtde + 1;
              vStatus  := pkg_glb_common.Status_Warning;
              vMessage := vMessage|| p_cursor.cte||'-'||p_cursor.serie||'-'||p_cursor.rota||chr(13);

           end if;

        end loop;

        -- mdfe não liberado, exige que o / os conhecimento estejam vinculado a um mdfe
        if vMdfeLiberado = 'N' then

           if vQtde = 0 Then
                vMessage := null;
           End if;


           p_status  := vStatus;
           p_message := nvl(vMessage,'Processamento Normal.');

        -- mdfe liberado só para cargar que contem viagens com 1 conhecimento.
        elsif vMdfeLiberado = 'L' then


          if vQtdeDocumentos = 1 then
             p_status  := pkg_glb_common.Status_Nomal;
             p_message := 'Processamento Normal.';


          else


             if vQtde = 0 Then
                  vMessage := null;
             End if;

             p_status  := vStatus;
             p_message := nvl(vMessage,'Processamento Normal.');

          end if;
        -- mdfe liberado para todas as cargas, independente da quantidade de mdfe.
        elsif vMdfeLiberado = 'T' then


          p_status  := pkg_glb_common.Status_Nomal;
          p_message := 'Processamento Normal.';


        end if;

     exception when others then
        p_status  := pkg_glb_common.Status_Erro;
        p_message := 'Erro ao Executar PKG_CON_VALEFRETE.Sp_Con_Validavfretemdfe Erro: '||sqlerrm;
      end;

   end Sp_Con_Validavfretemdfe;

   procedure sp_con_CalcValefrete(p_vfnumero   in t_con_valefrete.con_conhecimento_codigo%type,
                                  p_vfserie    in t_con_valefrete.con_conhecimento_serie%type,
                                  p_vfrota     in t_con_valefrete.glb_rota_codigo%type,
                                  p_vfsaque    in t_con_valefrete.con_valefrete_saque%type,
                                  p_DescDebito in char default 'S',
 --                                 p_Usuario     in t_con_valefrete.usu_usuario_codigo%type,
 --                                 p_RotaUsuario in t_con_valefrete.glb_rota_codigo%type,
                                  p_status   out char,
                                  p_message  out varchar2
                                  ) as

       vTpValefrete     tdvadm.t_con_valefrete%rowtype;
       vValorFrete      number;
       vValorLiquido    number;
       vValorconDesc    number;
       vValorBaseDesc   number;
       vTpMotorista     TDVADM.T_CON_VALEFRETE.GLB_TPMOTORISTA_CODIGO%TYPE; -- Frota / Carreterio / Agregado / Dedicado
       vPercentAgregado number;
       vPercentDesconto number;
       vTpProprietario  char(1); -- Pessoa Fisica / Juridica
       vStatus          char(1);
       vMessage         varchar2(200);
       vCursor          t_cursor;
       vQuery           varchar2(2000);
     Begin

       select *
         into vTpValefrete
       from t_con_valefrete vf
       where vf.con_conhecimento_codigo = p_vfnumero
         and vf.con_conhecimento_serie = p_vfserie
         and vf.glb_rota_codigo = p_vfrota
         and vf.con_valefrete_saque =  p_vfsaque;

       vTpMotorista := vTpValefrete.Glb_Tpmotorista_Codigo;


       if vTpValefrete.Con_Valefrete_Tipocusto = 'T' Then
          vValorFrete := vTpValefrete.Con_Valefrete_Custocarreteiro * vTpValefrete.Con_Valefrete_Pesocobrado;
       Else
         vValorFrete := vTpValefrete.Con_Valefrete_Custocarreteiro;
       End If;
--       vValorconDesc := vValorFrete;

       
       Begin
          select p.usu_perfil_paran1
             into vPercentAgregado
          from tdvadm.t_usu_perfil p
          where p.usu_aplicacao_codigo = 'comvlfrete'
            and p.usu_perfil_codigo = 'VLRAGREGPER' || upper(vTpValefrete.Con_Valefrete_Placa) 
            and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                         from TDVADM.t_usu_perfil p1
                                         where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                           and p1.usu_perfil_codigo = p.usu_perfil_codigo   
                                           and p1.usu_perfil_vigencia <= sysdate);
       Exception
         When NO_DATA_FOUND Then
             select p.usu_perfil_paran1
               into vPercentAgregado
             from tdvadm.t_usu_perfil p
             where p.usu_aplicacao_codigo = 'comvlfrete'
               and p.usu_perfil_codigo = 'VLRAGREGPER'
               and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                            from TDVADM.t_usu_perfil p1
                                            where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                              and p1.usu_perfil_codigo = p.usu_perfil_codigo   
                                              and p1.usu_perfil_vigencia <= sysdate);
       End;                                  
       If vTpMotorista = 'A' Then
           vValorBaseDesc := vValorFrete - vTpValefrete.Con_Valefrete_Pedagio -
                                           vTpValefrete.Con_Valefrete_Valorestiva -
                                           vTpValefrete.Con_Valefrete_Valorvazio -
                                           vTpValefrete.Con_Valefrete_Enlonamento -
                                           vTpValefrete.Con_Valefrete_Estadia;
                                           
           if (vPercentAgregado != 0) then
               vValorconDesc :=  vValorFrete - ( vValorBaseDesc *  ( vPercentAgregado / 100 ) )  ;
           end if;
           
       End If;

       update t_con_valefrete vf
         set vf.con_valefrete_frete = vValorFrete,
             vf.con_valefrete_valorcomdesconto = nvl(vValorconDesc,0)
       where vf.con_conhecimento_codigo = vTpValefrete.Con_Conhecimento_Codigo
         and vf.con_conhecimento_serie = vTpValefrete.Con_Conhecimento_Serie
         and vf.glb_rota_codigo = vTpValefrete.Glb_Rota_Codigo
         and vf.con_valefrete_saque = vTpValefrete.Con_Valefrete_Saque;

         
       -- Calcular impostos.
       sp_con_calcImpostos(vTpValefrete.Con_Conhecimento_Codigo,
                           vTpValefrete.Con_Conhecimento_Serie,
                           vTpValefrete.Glb_Rota_Codigo,
                           vTpValefrete.Con_Valefrete_Saque,
                           vTpValefrete.Con_Valefrete_Inss,
                           vTpValefrete.Con_Valefrete_Sestsenat,
                           vTpValefrete.Con_Valefrete_Irrf,
                           vTpValefrete.Con_Valefrete_Cofins,
                           vTpValefrete.Con_Valefrete_Csll,
                           vTpValefrete.Con_Valefrete_Pis,
                           vStatus,
                           vMessage);


       If vTpMotorista = 'A' Then
          vValorLiquido := vValorconDesc - 0 ; -- nvl(vTpValefrete.Con_Valefrete_Pedagio,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Adiantamento,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Multa,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Irrf,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Inss,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Sestsenat,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Valorestiva,0);
       Else
          vValorLiquido := vValorFrete - 0 ; -- nvl(vTpValefrete.Con_Valefrete_Pedagio,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Adiantamento,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Multa,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Irrf,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Inss,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Sestsenat,0);
          vValorLiquido := vValorLiquido - nvl(vTpValefrete.Con_Valefrete_Valorestiva,0);
       End If;

       update t_con_valefrete vf
         set vf.Con_Valefrete_Inss = nvl(vTpValefrete.Con_Valefrete_Inss,0),
             vf.Con_Valefrete_Sestsenat = nvl(vTpValefrete.Con_Valefrete_Sestsenat,0),
             vf.Con_Valefrete_Irrf = nvl(vTpValefrete.Con_Valefrete_Irrf,0),
             vf.Con_Valefrete_Cofins = vTpValefrete.Con_Valefrete_Cofins,
             vf.Con_Valefrete_Csll = vTpValefrete.Con_Valefrete_Csll,
             vf.Con_Valefrete_Pis = vTpValefrete.Con_Valefrete_Pis,
             vf.con_valefrete_valorliquido = vValorLiquido
       where vf.con_conhecimento_codigo = vTpValefrete.Con_Conhecimento_Codigo
         and vf.con_conhecimento_serie = vTpValefrete.Con_Conhecimento_Serie
         and vf.glb_rota_codigo = vTpValefrete.Glb_Rota_Codigo
         and vf.con_valefrete_saque = vTpValefrete.Con_Valefrete_Saque;



      vQuery := 'VFNumero=nome=VFNumero|tipo=String|valor=' || vTpValefrete.Con_Conhecimento_Codigo || '*' ||
                'VFSerie=nome=VFSerie|tipo=String|valor=' || vTpValefrete.Con_Conhecimento_Serie || '*' ||
                'VFRota=nome=VFRota|tipo=String|valor=' || vTpValefrete.Glb_Rota_Codigo || '*' ||
                'VFSaque=nome=VFSaque|tipo=String|valor=' || vTpValefrete.Con_Valefrete_Saque || '*' ||
                'VFAcao=nome=VFAcao|tipo=String|valor=Salvar*' ||
                'VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=jsantos*' ||
                'VFRotaUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=' || vTpValefrete.Glb_Rota_Codigo || '*' ||
                'VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*' ;
 
       SP_CON_ATUCALCVALEFRETE(P_QUERYSTR => vQuery,
                               P_STATUS   => vStatus,
                               P_MESSAGE  => vMessage,
                               P_CURSOR   => vCursor); 

       -- ver Bonus




    End sp_con_CalcValefrete;

   procedure Sp_Set_MarcaVfRecebido(pVfNumero in t_con_valefrete.con_conhecimento_codigo%type,
                                    pVfSerie  in t_con_valefrete.con_conhecimento_serie%type,
                                    pVfRota   in t_con_valefrete.glb_rota_codigo%type,
                                    pVfSaque  in t_con_valefrete.con_valefrete_saque%type,
                                    pDateRec  in date,
                                    pStatus   out char,
                                    pMessage  out varchar2) as
   begin


    begin

       update t_con_valefrete vf
          set vf.con_valefrete_datarecebimento = nvl(pDateRec,sysdate)
        where vf.con_conhecimento_codigo       = pVfNumero
          and vf.con_conhecimento_serie        = pVfSerie
          and vf.glb_rota_codigo               = pVfRota
          and vf.con_valefrete_saque           = pVfSaque;

       commit;

       pStatus   := pkg_glb_common.Status_Nomal;
       pMessage  := 'Processamento Normal!';

     exception when others then
        pStatus   := pkg_glb_common.Status_Erro;
        pMessage  := 'Erro ao executar PKG_CON_VALEFRETE.Sp_Set_MarcaVfRecebido. Erro.: '||sqlerrm;
      end;

   end Sp_Set_MarcaVfRecebido;


    function fn_validahorario(phorario in tdvadm.t_con_diariobordo.hora1iv%type,
                              pTipo in char default 'X') -- indica se é Inicio ou Fim
      return  tdvadm.t_con_diariobordo.hora1iv%type
    As
      vPos       number;
      vBloco1 varchar(2);
      vBloco2 varchar(2);
      vBloco3 varchar(2);
      vErro     char(1);
      vTeste    date;
      vRetorno  tdvadm.t_con_diariobordo.hora1iv%type;

   Begin
      vRetorno := phorario;
       -- Verifica se é uma hora valida
       vErro := 'N';
       if nvl(vRetorno,'ERROR #') = 'ERROR #' Then
          if nvl(pTipo,'X') = 'I' Then
            vRetorno := '08:00';
          Elsif nvl(pTipo,'X') = 'F' Then
            vRetorno := '18:00';
          Else
            vRetorno := null;
          End If;
          return vRetorno;
       End IF;
       if glbadm.pkg_glb_util.F_ENUMERICO(vRetorno) = 'S' Then
          if nvl(pTipo,'X') = 'I' Then
            vRetorno := '08:00';
          Elsif nvl(pTipo,'X') = 'F' Then
            vRetorno := '18:00';
          Else
            vRetorno := null;
          End If;
          return vRetorno;
       End IF;

       begin
         if length(trim(substr(vRetorno,1,5))) = 5 then
            vTeste := to_date(trunc(sysdate) || ' ' || substr(vRetorno,1,5),'dd/mm/yyyy hh:mi');
            if upper(substr(vRetorno,-2,2)) not in ('PM','AM') Then
               if nvl(pTipo,'X') = 'I' Then
                 vRetorno :=  substr(vRetorno,1,5);
               Elsif nvl(pTipo,'X') = 'F' Then
                  IF to_number(substr(vRetorno,1,2)) < 12 Then
                     vRetorno :=  trim(to_char(to_number(substr(vRetorno,1,2))+12)) || ':' ||  substr(vRetorno,4,2)  ;
                  Else
                     vRetorno := '00:' || substr(vRetorno,4,2);
                  End If;
               Else
                 vRetorno := substr(vRetorno,1,5);
               End If;
            Elsif upper(substr(vRetorno,-2,2)) = 'AM' Then
               vRetorno :=  substr(vRetorno,1,5);
           Elsif upper(substr(vRetorno,-2,2)) = 'PM' Then
              IF to_number(substr(vRetorno,1,2)) < 12 Then
                 vRetorno :=  trim(to_char(to_number(substr(vRetorno,1,2))+12)) || ':' ||  substr(vRetorno,4,2)  ;
              Else
                 vRetorno := '00:' || substr(vRetorno,4,2);
              End If;
            End If;

        Else
           vErro := 'E';
         End If;
       exception
         When OTHERS Then
           vErro := 'E';
         End ;
       If vErro = 'E' Then
          vPos := 1;
          vBloco1 := '';
          vBloco2 := '';
          vBloco3 := '';
          loop
             if glbadm.pkg_glb_util.F_ENUMERICO(substr(vRetorno,vPos,1)) = 'S' Then
                if vPos < 3 Then -- Regiao da Hora
                  vBloco1 := vBloco1 || substr(vRetorno,vPos,1);
                ElsIf vPos < 6 Then  -- do Minuto
                  vBloco2 := vBloco2 || substr(vRetorno,vPos,1);
                End If;
             Else
                if substr(vRetorno,vPos,1) = 'P' Then
                  vBloco3 := 'PM';
                Elsif substr(vRetorno,vPos,1) = 'A' Then
                  vBloco3 := 'AM';
                Elsif substr(vRetorno,vPos,1) = ':' Then
                  vBloco3 := vBloco3; -- Não faco nada
                ElsIf vPos < 3 Then -- Regiao da Hora
                   if nvl(pTipo,'X') = 'I' Then
                      vBloco1 := '08';
                   Elsif nvl(pTipo,'X') = 'F' Then
                      vBloco1 := '18';
                   Else
                      vRetorno := null;
                   End If;
                ElsIf vPos < 6 Then  -- do Minuto
                  vBloco2 := '00';
                End If;
             End If;
             vPos := vPos + 1;

             exit when vPos = 8;
          end loop;
          if ( ( nvl(vBloco3,'XX') = 'PM') or nvl(pTipo,'X') = 'F' )  and to_number(vBloco1) < 12 Then
             vRetorno := trim(to_char(to_number(vBloco1) + 12)) || ':' || nvl(vBloco2,'00');
          Elsif ( ( nvl(vBloco3,'XX') = 'PM') or nvl(pTipo,'X') = 'F' )  and to_number(vBloco1) = 12 Then
             vRetorno := '00' || ':' || nvl(vBloco2,'00');
          Else
             vRetorno := vBloco1 || ':' || nvl(vBloco2,'00');
          End If;
       End If;

       return vRetorno;

   exception
       When OTHERS Then
         dbms_output.put_line(phorario);
         return phorario;
    End fn_validahorario;

    procedure sp_con_ProcessaDiarioBordo(pCodSol in t_glb_solicitacao.glb_solicitacao_cod%type)
      As
      vSql varchar2(10000);
      vTpDiarioBordo tdvadm.t_con_diariobordo%rowtype;
      vTpValerfrete  tdvadm.t_con_valefrete%rowtype;
      vAuxiliarN number;
      vAuxiliatT varchar(20);
      cDiario T_CURSOR;
      vErro   Clob;
      vProcessegue char(1);
      vFolha    integer;
      vFolhaAte integer;
     Begin
 --       if nvl(pCodSol,0) = 0 Then
 --          delete t_con_diariobordo;
 --          commit;
 --       End If;
        vAuxiliarN := 0;
        vProcessegue := 'S';
        vErro := empty_clob();
        vErro := pkg_glb_html.Assinatura;
        vProcessegue := 'S';
        FOR R_CURSOR IN(SELECT GLB_SOLICITACAO_COD,
                               GLB_SOLICITACAO_DTGRAVACAO,
                               CON_CONHECIMENTO_CODIGO,
                               CON_CONHECIMENTO_SERIE,
                               GLB_ROTA_CODIGO,
                               CON_VALEFRETE_SAQUE,
                               CODIGOBARRA,
                               DIARIO,
                               C0,
                               C1,
                               DATA1,
                               HORA1IV,
                               HORA1FV,
                               HORA1ID1,
                               HORA1FD1,
                               HORA1ID2,
                               HORA1FD2,
                               HORA1ID3,
                               HORA1FD3,
                               HORA1IE1,
                               HORA1FE1,
                               OBSERVE1,
                               DATA2,
                               HORA2IV,
                               HORA2FV,
                               HORA2ID1,
                               HORA2FD1,
                               HORA2ID2,
                               HORA2FD2,
                               HORA2ID3,
                               HORA2FD3,
                               HORA2IE1,
                               HORA2FE1,
                               OBSERVE2,
                               DATA3,
                               HORA3IV,
                               HORA3FV,
                               HORA3ID1,
                               HORA3FD1,
                               HORA3ID2,
                               HORA3FD2,
                               HORA3ID3,
                               HORA3FD3,
                               HORA3IE1,
                               HORA3FE1,
                               OBSERVE3,
                               DATA4,
                               HORA4IV,
                               HORA4FV,
                               HORA4ID1,
                               HORA4FD1,
                               HORA4ID2,
                               HORA4FD2,
                               HORA4ID3,
                               HORA4FD3,
                               HORA4IE1,
                               HORA4FE1,
                               OBSERVE4,
                               PERG1,
                               PERG2,
                               PERG3,
                               ASSINATURA,
                               null CON_DIARIOBORDO_DTPROC
                         FROM v_con_diariobordo d
                         WHERE d.GLB_SOLICITACAO_DTGRAVACAO >= '01/03/2014'
                           and d.CODIGOBARRA is not null
                           and 0 = (select count(*)
                                    from t_con_diariobordo d1
                                    where d1.GLB_SOLICITACAO_COD = d.GLB_SOLICITACAO_COD)
                              and d.GLB_SOLICITACAO_COD = decode(nvl(pCodSol,0),0,GLB_SOLICITACAO_COD,pCodSol)
 --                        order by d.codigobarra
                         )
        Loop
             vAuxiliarN := vAuxiliarN +1;
             vTpDiarioBordo.GLB_SOLICITACAO_COD := R_CURSOR.GLB_SOLICITACAO_COD;
             vTpDiarioBordo.GLB_SOLICITACAO_DTGRAVACAO := trim(R_CURSOR.GLB_SOLICITACAO_DTGRAVACAO);
             vTpDiarioBordo.CON_CONHECIMENTO_CODIGO := trim(R_CURSOR.CON_CONHECIMENTO_CODIGO);
             vTpDiarioBordo.CON_CONHECIMENTO_SERIE := trim(R_CURSOR.CON_CONHECIMENTO_SERIE);
             vTpDiarioBordo.GLB_ROTA_CODIGO := trim(R_CURSOR.GLB_ROTA_CODIGO);
             vTpDiarioBordo.CON_VALEFRETE_SAQUE := trim(R_CURSOR.CON_VALEFRETE_SAQUE);
             vTpDiarioBordo.CODIGOBARRA := trim(R_CURSOR.CODIGOBARRA);
             vTpDiarioBordo.DIARIO := trim(R_CURSOR.DIARIO);
             vTpDiarioBordo.C0 := substr(trim(R_CURSOR.C0),1,255);
             vTpDiarioBordo.C1 := substr(trim(R_CURSOR.C1),1,255);
             vTpDiarioBordo.DATA1 := trim(R_CURSOR.DATA1);
             vTpDiarioBordo.HORA1IV := trim(R_CURSOR.HORA1IV);
             vTpDiarioBordo.HORA1FV := trim(R_CURSOR.HORA1FV);
             vTpDiarioBordo.HORA1ID1 := trim(R_CURSOR.HORA1ID1);
             vTpDiarioBordo.HORA1FD1 := trim(R_CURSOR.HORA1FD1);
             vTpDiarioBordo.HORA1ID2 := trim(R_CURSOR.HORA1ID2);
             vTpDiarioBordo.HORA1FD2 := trim(R_CURSOR.HORA1FD2);
             vTpDiarioBordo.HORA1ID3 := trim(R_CURSOR.HORA1ID3);
             vTpDiarioBordo.HORA1FD3 := trim(R_CURSOR.HORA1FD3);
             vTpDiarioBordo.HORA1IE1 := trim(R_CURSOR.HORA1IE1);
             vTpDiarioBordo.HORA1FE1 := trim(R_CURSOR.HORA1FE1);
             vTpDiarioBordo.OBSERVE1 := trim(R_CURSOR.OBSERVE1);
             vTpDiarioBordo.DATA2 := trim(R_CURSOR.DATA2);
             vTpDiarioBordo.HORA2IV := trim(R_CURSOR.HORA2IV);
             vTpDiarioBordo.HORA2FV := trim(R_CURSOR.HORA2FV);
             vTpDiarioBordo.HORA2ID1 := trim(R_CURSOR.HORA2ID1);
             vTpDiarioBordo.HORA2FD1 := trim(R_CURSOR.HORA2FD1);
             vTpDiarioBordo.HORA2ID2 := trim(R_CURSOR.HORA2ID2);
             vTpDiarioBordo.HORA2FD2 := trim(R_CURSOR.HORA2FD2);
             vTpDiarioBordo.HORA2ID3 := trim(R_CURSOR.HORA2ID3);
             vTpDiarioBordo.HORA2FD3 := trim(R_CURSOR.HORA2FD3);
             vTpDiarioBordo.HORA2IE1 := trim(R_CURSOR.HORA2IE1);
             vTpDiarioBordo.HORA2FE1 := trim(R_CURSOR.HORA2FE1);
             vTpDiarioBordo.OBSERVE2 := trim(R_CURSOR.OBSERVE2);
             vTpDiarioBordo.DATA3 := trim(R_CURSOR.DATA3);
             vTpDiarioBordo.HORA3IV := trim(R_CURSOR.HORA3IV);
             vTpDiarioBordo.HORA3FV := trim(R_CURSOR.HORA3FV);
             vTpDiarioBordo.HORA3ID1 := trim(R_CURSOR.HORA3ID1);
             vTpDiarioBordo.HORA3FD1 := trim(R_CURSOR.HORA3FD1);
             vTpDiarioBordo.HORA3ID2 := trim(R_CURSOR.HORA3ID2);
             vTpDiarioBordo.HORA3FD2 := trim(R_CURSOR.HORA3FD2);
             vTpDiarioBordo.HORA3ID3 := trim(R_CURSOR.HORA3ID3);
             vTpDiarioBordo.HORA3FD3 := trim(R_CURSOR.HORA3FD3);
             vTpDiarioBordo.HORA3IE1 := trim(R_CURSOR.HORA3IE1);
             vTpDiarioBordo.HORA3FE1 := trim(R_CURSOR.HORA3FE1);
             vTpDiarioBordo.OBSERVE3 := trim(R_CURSOR.OBSERVE3);
             vTpDiarioBordo.DATA4 := trim(R_CURSOR.DATA4);
             vTpDiarioBordo.HORA4IV := trim(R_CURSOR.HORA4IV);
             vTpDiarioBordo.HORA4FV := trim(R_CURSOR.HORA4FV);
             vTpDiarioBordo.HORA4ID1 := trim(R_CURSOR.HORA4ID1);
             vTpDiarioBordo.HORA4FD1 := trim(R_CURSOR.HORA4FD1);
             vTpDiarioBordo.HORA4ID2 := trim(R_CURSOR.HORA4ID2);
             vTpDiarioBordo.HORA4FD2 := trim(R_CURSOR.HORA4FD2);
             vTpDiarioBordo.HORA4ID3 := trim(R_CURSOR.HORA4ID3);
             vTpDiarioBordo.HORA4FD3 := trim(R_CURSOR.HORA4FD3);
             vTpDiarioBordo.HORA4IE1 := trim(R_CURSOR.HORA4IE1);
             vTpDiarioBordo.HORA4FE1 := trim(R_CURSOR.HORA4FE1);
             vTpDiarioBordo.OBSERVE4 := trim(R_CURSOR.OBSERVE4);
             vTpDiarioBordo.PERG1 := trim(R_CURSOR.PERG1);
             vTpDiarioBordo.PERG2 := trim(R_CURSOR.PERG2);
             vTpDiarioBordo.PERG3 := trim(R_CURSOR.PERG3);
             vTpDiarioBordo.ASSINATURA := trim(R_CURSOR.ASSINATURA);

              vErro := vErro || pkg_glb_html.LinhaH;
              vErro := vErro || pkg_glb_html.fn_Titulo(vTpDiarioBordo.Con_Conhecimento_Codigo || '-' ||
                                                       vTpDiarioBordo.Con_Conhecimento_Serie  || '-' ||
                                                       vTpDiarioBordo.Glb_Rota_Codigo         || '-' ||
                                                       vTpDiarioBordo.Con_Valefrete_Saque);
              vErro := vErro || pkg_glb_html.fn_AbreLista;
              Begin
                select *
                  into vTpValerfrete
                from t_con_valefrete vf
                where vf.con_conhecimento_codigo = vTpDiarioBordo.Con_Conhecimento_Codigo
                  and vf.con_conhecimento_serie  = vTpDiarioBordo.Con_Conhecimento_Serie
                  and vf.glb_rota_codigo         = vTpDiarioBordo.Glb_Rota_Codigo
                  and vf.con_valefrete_saque     = vTpDiarioBordo.Con_Valefrete_Saque;
              exception
                WHEN NO_DATA_FOUND Then
                  vProcessegue := 'N';
                  vErro := vErro || pkg_glb_html.fn_ItensLista('Vale de Frete Não encontrado');
              End;

              if vProcessegue = 'S' Then
                 vFolha    := substr(vTpDiarioBordo.Codigobarra,15,2);
                 vFolhaAte := substr(vTpDiarioBordo.Codigobarra,17,2);
 --                if vFolha <> 1 Then
 --                   vProcessegue := 'N';
 --                   vErro := vErro || pkg_glb_html.fn_ItensLista('Falta folha 1');
 --                End If;
                 If vProcessegue = 'S' Then
                     -- Primeira Data
                     vTpDiarioBordo.Data1 := to_char(TO_DATE(TO_DATE(vTpValerfrete.Con_Valefrete_Datacadastro,'DD/MM/YY') + ( vFolha * 4) - 4,'DD/MM/YY'),'DD/MM/YYYY');
                     vTpDiarioBordo.Data2 := to_char(TO_DATE(TO_DATE(vTpValerfrete.Con_Valefrete_Datacadastro,'DD/MM/YY') + ( vFolha * 4) - 3,'DD/MM/YY'),'DD/MM/YYYY');
                     vTpDiarioBordo.Data3 := to_char(TO_DATE(TO_DATE(vTpValerfrete.Con_Valefrete_Datacadastro,'DD/MM/YY') + ( vFolha * 4) - 2,'DD/MM/YY'),'DD/MM/YYYY');
                     vTpDiarioBordo.Data4 := to_char(TO_DATE(TO_DATE(vTpValerfrete.Con_Valefrete_Datacadastro,'DD/MM/YY') + ( vFolha * 4) - 1,'DD/MM/YY'),'DD/MM/YYYY');


 /*************** Inicio e Fim do Dia Primeiro dia *****************/
                     vTpDiarioBordo.Hora1iv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1iv,'I');
                     vTpDiarioBordo.Hora1fv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1fv,'F');

                     -- Inicio e Fim da Primeira parada
                     vTpDiarioBordo.Hora1id1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1id1,'I');
                     vTpDiarioBordo.Hora1fd1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1fd1,'F');

                     -- Inicio e Fim da Segunda parada
                     vTpDiarioBordo.Hora1id2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1id2,'I');
                     vTpDiarioBordo.Hora1fd2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1fd2,'F');

                     -- Inicio e Fim da Terceira parada
                     vTpDiarioBordo.Hora1id3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1id3,'I');
                     vTpDiarioBordo.Hora1fd3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1fd3,'F');

                     -- Inicio e Fim da Hora Extra
                     vTpDiarioBordo.Hora1ie1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1ie1,'I');
                     vTpDiarioBordo.Hora1fe1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora1fe1,'F');

 /*************** Inicio e Fim do Dia Segundo dia *****************/
                     vTpDiarioBordo.Hora2iv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2iv,'I');
                     vTpDiarioBordo.Hora2fv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2fv,'F');

                     -- Inicio e Fim da Primeira parada
                     vTpDiarioBordo.Hora2id1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2id1,'I');
                     vTpDiarioBordo.Hora2fd1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2fd1,'F');

                     -- Inicio e Fim da Segunda parada
                     vTpDiarioBordo.Hora2id2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2id2,'I');
                     vTpDiarioBordo.Hora2fd2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2fd2,'F');

                     -- Inicio e Fim da Terceira parada
                     vTpDiarioBordo.Hora2id3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2id3,'I');
                     vTpDiarioBordo.Hora2fd3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2fd3,'F');

                     -- Inicio e Fim da Hora Extra
                     vTpDiarioBordo.Hora2ie1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2ie1,'I');
                     vTpDiarioBordo.Hora2fe1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora2fe1,'F');

 /*************** Inicio e Fim do Dia Terceiro dia *****************/
                     vTpDiarioBordo.Hora3iv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3iv,'I');
                     vTpDiarioBordo.Hora3fv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3fv,'F');

                     -- Inicio e Fim da Primeira parada
                     vTpDiarioBordo.Hora3id1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3id1,'I');
                     vTpDiarioBordo.Hora3fd1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3fd1,'F');

                     -- Inicio e Fim da Segunda parada
                     vTpDiarioBordo.Hora3id2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3id2,'I');
                     vTpDiarioBordo.Hora3fd2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3fd2,'F');

                     -- Inicio e Fim da Terceira parada
                     vTpDiarioBordo.Hora3id3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3id3,'I');
                     vTpDiarioBordo.Hora3fd3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3fd3,'F');

                     -- Inicio e Fim da Hora Extra
                     vTpDiarioBordo.Hora3ie1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3ie1,'I');
                     vTpDiarioBordo.Hora3fe1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora3fe1,'F');

 /*************** Inicio e Fim do Dia Quarto dia *****************/
                     vTpDiarioBordo.Hora4iv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4iv,'I');
                     vTpDiarioBordo.Hora4fv := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4fv,'F');

                     -- Inicio e Fim da Primeira parada
                     vTpDiarioBordo.Hora4id1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4id1,'I');
                     vTpDiarioBordo.Hora4fd1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4fd1,'F');

                     -- Inicio e Fim da Segunda parada
                     vTpDiarioBordo.Hora4id2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4id2,'I');
                     vTpDiarioBordo.Hora4fd2 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4fd2,'F');

                     -- Inicio e Fim da Terceira parada
                     vTpDiarioBordo.Hora4id3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4id3,'I');
                     vTpDiarioBordo.Hora4fd3 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4fd3,'F');

                     -- Inicio e Fim da Hora Extra
                     vTpDiarioBordo.Hora4ie1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4ie1,'I');
                     vTpDiarioBordo.Hora4fe1 := PKG_CON_VALEFRETE.fn_validahorario(vTpDiarioBordo.Hora4fe1,'F');

                     if nvl(trim(vTpDiarioBordo.Perg1),'Sim') <> 'Não' Then
                        vTpDiarioBordo.Perg1 := 'Sim';
                     Else
                        vTpDiarioBordo.Perg1 := 'Nao';
                     End If;
                     if nvl(trim(vTpDiarioBordo.Perg2),'Sim') <> 'Não' Then
                        vTpDiarioBordo.Perg2 := 'Sim';
                     Else
                        vTpDiarioBordo.Perg2 := 'Nao';
                     End If;
                     if nvl(trim(vTpDiarioBordo.Perg3),'Sim') <> 'Não' Then
                        vTpDiarioBordo.Perg3 := 'Sim';
                     Else
                        vTpDiarioBordo.Perg3 := 'Nao';
                     End If;

                     if nvl(pCodSol,0) = 0 Then
                        vTpDiarioBordo.Con_Diariobordo_Dtproc := '01/11/2014';
                     else
                        vTpDiarioBordo.Con_Diariobordo_Dtproc := sysdate;
                     end if;


                     insert into t_con_diariobordo values vTpDiarioBordo;
                     if pCodSol is null then
                        commit;
                     End If;

                 End If;
              End If;
              vProcessegue := 'S';


        End Loop;
        vTpDiarioBordo.Perg3 := vTpDiarioBordo.Perg3;
        if pCodSol is null then
           wservice.pkg_glb_email.SP_ENVIAEMAIL('DIARIO DE BORDO',
                                                vErro,
                                                'aut-e@dellavolpe.com.br',
                                                'sdrumond@dellavolpe.com.br');
        End If;
    exception
      when OTHERS Then
             vTpDiarioBordo.Perg3 := vTpDiarioBordo.Perg3;
    End sp_con_ProcessaDiarioBordo;

    PROCEDURE SP_LISTA_DIARIO(pDataIni in char,
                              pDataFim in Char)
    As
      vTexto clob;
      vTempo varchar2(20);
      vErro   varchar2(1000);
      vErro1  varchar2(1000);
      vErro2  varchar2(1000);
      vAuxiliar number;
      vTpDiarioBordo tdvadm.t_con_diariobordo%rowtype;
    Begin
      vTexto := empty_clob();
      vTexto := pkg_glb_html.Assinatura;
      vauxiliar := 0;
      dbms_output.disable;
       for c_msg in (select db.con_conhecimento_codigo vf,
                            db.glb_rota_codigo rt,
                            db.con_conhecimento_serie sr,
                            db.con_valefrete_saque  sq,
                            db.glb_solicitacao_cod cod,
                            vf.con_valefrete_placa placa,

                            to_char(to_date(db.data1,'dd/mm/yy'),'dd/mm/yyyy') dia1,
                            db.hora1iv,
                            db.hora1fv,

                            to_char(to_date(db.data2,'dd/mm/yy'),'dd/mm/yyyy') dia2,
                            db.hora2iv,
                            db.hora2fv,

                            to_char(to_date(db.data3,'dd/mm/yy'),'dd/mm/yyyy') dia3,
                            db.hora3iv,
                            db.hora3fv,

                            to_char(to_date(db.data4,'dd/mm/yy'),'dd/mm/yyyy') dia4,
                            db.hora4iv,
                            db.hora4fv,

                            vf.con_valefrete_datacadastro inicio,
                            vf.con_valefrete_dataprazomax fim
                     from t_con_diariobordo db,
                          t_con_valefrete vf
                     where 0 = 0
                       and db.con_conhecimento_codigo = vf.con_conhecimento_codigo
                       and db.con_conhecimento_serie  = vf.con_conhecimento_serie
                       and db.glb_rota_codigo         = vf.glb_rota_codigo
                       and db.con_valefrete_saque     = vf.con_valefrete_saque
                       and ( TO_NUMBER(substr(db.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora1fv,1,2)) < 23 )
                       and ( TO_NUMBER(substr(db.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora2fv,1,2)) < 23 )
                       and ( TO_NUMBER(substr(db.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora3fv,1,2)) < 23 )
                       and ( TO_NUMBER(substr(db.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora4fv,1,2)) < 23 )
                       and vf.con_valefrete_datacadastro >= pDataIni
                       and vf.con_valefrete_datacadastro <= pDataFim
                       and nvl(db.con_diariobordo_jornada1,0) = 0
                       and db.glb_solicitacao_dtgravacao = (select max(db1.glb_solicitacao_dtgravacao)
                                                            from t_con_diariobordo db1
                                                            where db1.codigobarra = db.codigobarra
                                                              and ( TO_NUMBER(substr(db1.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora1fv,1,2)) < 23 )
                                                              and ( TO_NUMBER(substr(db1.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora2fv,1,2)) < 23 )
                                                              and ( TO_NUMBER(substr(db1.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora3fv,1,2)) < 23 )
                                                              and ( TO_NUMBER(substr(db1.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora4fv,1,2)) < 23 ))
 --                    order by vf.con_valefrete_datacadastro,db.codigobarra
                     )
       loop

       -- DIA 1
          Begin
             Begin
                vTempo := FN_CALCULA_TEMPODECORRIDO(to_date(c_msg.dia1 || ' ' || c_msg.hora1iv,'dd/mm/yyyy hh24:mi'),to_date(c_msg.dia1 || ' ' || c_msg.hora1fv,'dd/mm/yyyy hh24:mi'));
                vTpDiarioBordo.Con_Diariobordo_Jornada1 := to_number(substr(vTempo,1,5));
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO1 D1 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia1 || '-' || c_msg.hora1iv || '-' || c_msg.hora1fv || '-' || sqlerrm);
  --                  dbms_output.put_line('FN_CALCULA_TEMPODECORRIDO(to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia1 || ' ' || c_msg.hora1iv ) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ',to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia1 || ' ' || c_msg.hora1fv) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ')');
                End ;

             Begin
                vTexto := vTexto || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia1 || '-' || c_msg.hora1iv || '-' || c_msg.hora1fv || '-' || vTempo || '< /b>';
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO2 D1 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia1 || '-' || c_msg.hora1iv || '-' || c_msg.hora1fv || '-' || sqlerrm);
                End ;

          Exception
            When OTHERS Then
                dbms_output.put_line('ERRO  D1 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia1 || '-' || c_msg.hora1iv || '-' || c_msg.hora1fv || '-' || sqlerrm);
            End ;


       -- DIA 2
          Begin
             Begin
                vTempo := FN_CALCULA_TEMPODECORRIDO(to_date(c_msg.dia2 || ' ' || c_msg.hora2iv,'dd/mm/yyyy hh24:mi'),to_date(c_msg.dia2 || ' ' || c_msg.hora2fv,'dd/mm/yyyy hh24:mi'));
                vTpDiarioBordo.Con_Diariobordo_Jornada2 := to_number(substr(vTempo,1,5));
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO1 D2 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia2 || '-' || c_msg.hora2iv || '-' || c_msg.hora2fv || '-' || sqlerrm);
                   -- dbms_output.put_line('FN_CALCULA_TEMPODECORRIDO(to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia2 || ' ' || c_msg.hora2iv ) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ',to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia2 || ' ' || c_msg.hora2fv) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ')');
                End ;

             Begin
                vTexto := vTexto || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia2 || '-' || c_msg.hora2iv || '-' || c_msg.hora2fv || '-' || vTempo || '< /b>';
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO2 D2 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia2 || '-' || c_msg.hora2iv || '-' || c_msg.hora2fv || '-' || sqlerrm);
                End ;

          Exception
            When OTHERS Then
                dbms_output.put_line('ERRO D2 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia2 || '-' || c_msg.hora2iv || '-' || c_msg.hora2fv || '-' || sqlerrm);
            End ;


       -- DIA 3
          Begin
             Begin
                vTempo := FN_CALCULA_TEMPODECORRIDO(to_date(c_msg.dia3 || ' ' || c_msg.hora3iv,'dd/mm/yyyy hh24:mi'),to_date(c_msg.dia3 || ' ' || c_msg.hora3fv,'dd/mm/yyyy hh24:mi'));
                vTpDiarioBordo.Con_Diariobordo_Jornada3 := to_number(substr(vTempo,1,5));
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO1 D3 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia3 || '-' || c_msg.hora3iv || '-' || c_msg.hora3fv || '-' || sqlerrm);
                   --dbms_output.put_line('FN_CALCULA_TEMPODECORRIDO(to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia3 || ' ' || c_msg.hora3iv ) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ',to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia3 || ' ' || c_msg.hora3fv) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ')');
             End ;

             Begin
                vTexto := vTexto || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia3 || '-' || c_msg.hora3iv || '-' || c_msg.hora3fv || '-' || vTempo || '< /b>';
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO2 D3 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia3 || '-' || c_msg.hora3iv || '-' || c_msg.hora3fv || '-' || sqlerrm);
                End ;

          Exception
            When OTHERS Then
                dbms_output.put_line('ERRO D3 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia3 || '-' || c_msg.hora3iv || '-' || c_msg.hora3fv || '-' || sqlerrm);
            End ;


       -- DIA 4
          Begin
             Begin
                vTempo := FN_CALCULA_TEMPODECORRIDO(to_date(c_msg.dia4 || ' ' || c_msg.hora4iv,'dd/mm/yyyy hh24:mi'),to_date(c_msg.dia4 || ' ' || c_msg.hora4fv,'dd/mm/yyyy hh24:mi'));
                vTpDiarioBordo.Con_Diariobordo_Jornada4 := to_number(substr(vTempo,1,5));
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO1 D4 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia4 || '-' || c_msg.hora4iv || '-' || c_msg.hora4fv || '-' || sqlerrm);
                   --                  dbms_output.put_line('FN_CALCULA_TEMPODECORRIDO(to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia4 || ' ' || c_msg.hora4iv ) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ',to_date(' || PKG_GLB_COMMON.Fn_QuotedStr(c_msg.dia4 || ' ' || c_msg.hora4fv) || ',' || PKG_GLB_COMMON.Fn_QuotedStr('dd/mm/yyyy hh24:mi') || ')');
                End ;

             Begin
                vTexto := vTexto || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia4 || '-' || c_msg.hora4iv || '-' || c_msg.hora4fv || '-' || vTempo || '< /b>';
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO2 D4 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia4 || '-' || c_msg.hora4iv || '-' || c_msg.hora4fv || '-' || sqlerrm);
                End ;

          Exception
            When OTHERS Then
                dbms_output.put_line('ERRO D4 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia4 || '-' || c_msg.hora4iv || '-' || c_msg.hora4fv || '-' || sqlerrm);
            End ;


           -- Pegando as Inter Jonadas

             Begin
                vTempo := FN_CALCULA_TEMPODECORRIDO(to_date(c_msg.dia1 || ' ' || c_msg.hora1fv,'dd/mm/yyyy hh24:mi'),to_date(c_msg.dia2 || ' ' || c_msg.hora2iv,'dd/mm/yyyy hh24:mi'));
                vTpDiarioBordo.Con_Diariobordo_Interjornada1 := to_number(substr(vTempo,1,5));
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO1 I1 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia1 || '-' || c_msg.hora1fv || '-' || c_msg.dia2 || '-' || c_msg.hora2iv || '-' || sqlerrm);
                End ;

             Begin
                vTempo := FN_CALCULA_TEMPODECORRIDO(to_date(c_msg.dia2 || ' ' || c_msg.hora2fv,'dd/mm/yyyy hh24:mi'),to_date(c_msg.dia3 || ' ' || c_msg.hora3iv,'dd/mm/yyyy hh24:mi'));
                vTpDiarioBordo.Con_Diariobordo_Interjornada2 := to_number(substr(vTempo,1,5));
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO1 I1 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia2 || '-' || c_msg.hora1fv || '-' || c_msg.dia3 || '-' || c_msg.hora3iv || '-' || sqlerrm);
                End ;

             Begin
                vTempo := FN_CALCULA_TEMPODECORRIDO(to_date(c_msg.dia3 || ' ' || c_msg.hora3fv,'dd/mm/yyyy hh24:mi'),to_date(c_msg.dia4 || ' ' || c_msg.hora4iv,'dd/mm/yyyy hh24:mi'));
                vTpDiarioBordo.Con_Diariobordo_Interjornada3 := to_number(substr(vTempo,1,5));
             exception
                When OTHERS Then
                   dbms_output.put_line('ERRO1 I1 ' || c_msg.vf || '-' || c_msg.rt || '-' || c_msg.placa || '-' || c_msg.dia3 || '-' || c_msg.hora3fv || '-' || c_msg.dia4 || '-' || c_msg.hora4iv || '-' || sqlerrm);
                End ;

              update t_con_diariobordo d
                set d.con_diariobordo_interjornada1 = vTpDiarioBordo.Con_Diariobordo_Interjornada1,
                    d.con_diariobordo_jornada1      = vTpDiarioBordo.Con_Diariobordo_Jornada1,
                    d.con_diariobordo_interjornada2 = vTpDiarioBordo.Con_Diariobordo_Interjornada2,
                    d.con_diariobordo_jornada2      = vTpDiarioBordo.Con_Diariobordo_Jornada2,
                    d.con_diariobordo_interjornada3 = vTpDiarioBordo.Con_Diariobordo_Interjornada3,
                    d.con_diariobordo_jornada3      = vTpDiarioBordo.Con_Diariobordo_Jornada3
              where d.glb_solicitacao_cod = c_msg.cod;

              vAuxiliar := vAuxiliar + 1;
              if mod(vAuxiliar,10) = 0 Then
                 commit;
              End If;

       End Loop;


       commit;

    End SP_LISTA_DIARIO;

    Procedure Sp_ExisteMDFeNaoCancelado(p_veicDisp in  t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                        p_veicSeq  in  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                                        p_status   out char,
                                        p_message  out varchar2) as
    vQtdeMDFe  integer;
    vQtdeMDFeA integer;
    vQtdeMDFeC integer;

     begin
      p_status := pkg_glb_common.Status_Nomal;
      begin

        -- Quantidade de MDFe.
        select count(*)
          into vQtdeMDFe
          from t_con_veicdispmanif l
         where l.fcf_veiculodisp_codigo    = p_veicDisp
           and l.fcf_veiculodisp_sequencia = p_veicSeq;

        -- Quantidade de MDFe ainda aceitos.
        select count(*)
          into vQtdeMDFeA
          from t_con_veicdispmanif f,
               t_con_controlemdfe m
         where f.fcf_veiculodisp_codigo    = p_veicDisp
           and f.fcf_veiculodisp_sequencia = p_veicSeq
           and f.con_manifesto_codigo      = m.con_manifesto_codigo
           and f.con_manifesto_serie       = m.con_manifesto_serie
           and f.con_manifesto_rota        = m.con_manifesto_rota
           and m.con_mdfestatus_codigo     = 'OK';

        -- Quantidade de MDFe Cancelados.
        select count(*)
          into vQtdeMDFeC
          from t_con_veicdispmanif f,
               t_con_controlemdfe m
         where f.fcf_veiculodisp_codigo    = p_veicDisp
           and f.fcf_veiculodisp_sequencia = p_veicSeq
           and f.con_manifesto_codigo      = m.con_manifesto_codigo
           and f.con_manifesto_serie       = m.con_manifesto_serie
           and f.con_manifesto_rota        = m.con_manifesto_rota
           and m.con_mdfestatus_codigo     = 'CA';

        -- Se o Veiculo disponivel tem MDFe atrelado a ele.
        if (vQtdeMDFe > 0) then


            p_status := pkg_glb_common.Status_Warning;
            p_message:= 'Existem MDFe´s vinculados a esse veiculo, Impossível prosseguir!!!';

        end if;

      exception when others then
        p_status := pkg_glb_common.Status_Erro;
        p_message:= 'Erro ao executar PKG_CON_VALEFRETE.Sp_ExisteMDFeNaoCancelado. Erro: '||dbms_utility.format_error_backtrace;

     end;


    end Sp_ExisteMDFeNaoCancelado;


   Procedure sp_con_calcImpostos(p_vfnumero   in t_con_valefrete.con_conhecimento_codigo%type,
                                 p_vfserie    in t_con_valefrete.con_conhecimento_serie%type,
                                 p_vfrota     in t_con_valefrete.glb_rota_codigo%type,
                                 p_vfsaque    in t_con_valefrete.con_valefrete_saque%type,
                                 p_INSS       out number,
                                 p_SESTSENAT  out number,
                                 p_IRRF       out number,
                                 p_COFINS     out number,
                                 p_CSLL       out number,
                                 p_PIS        out number,
                                 p_Status     out char,
                                 p_Message    out varchar2)
   As
      vCNPJ        tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type;
      vCNPJTp      tdvadm.t_car_proprietario.car_proprietario_tipopessoa%type;
      vTpValefrete tdvadm.t_con_valefrete%rowtype;

      vStatus        char(1);
      vMessage       varchar2(200);
      vReferencia    char(6);
      vRef_MMAAAA    char(7);
      vXmlIn         VARCHAR2(1000);
      
      vValorTOTALIR_PF   number;
      vBaseIRRF_PF       number;
      vPrecBaseIRRF_PF   number;
      vAliqIRRF_PF       number;
      vVlrRetidoIRRF     number;
      vDeduzir_PF        number;
      vVlrDeduzDep       number;
      
      vBaseINSS          number;
      vPrecBaseINSS      number;
      vAliqINSS          number;
      vVlrRetidoINSS     number;
      vLimiteDesINSS     Number;

      vBaseSESTSENAT     number;
      vPrecBaseSESTSENAT number;
      vAliqSESTSENAT     number;


      vAliqCOFINS        number;
      vAliqCSLL          number;
      vAliqPIS           number;
      vAliqIRRF_PJ       number;



      
   Begin
     
     p_Status  := 'N';
     p_Message := '';
     
     p_IRRF      := 0;
     p_INSS      := 0;
     p_SESTSENAT := 0;
     p_COFINS    := 0;
     p_CSLL      := 0;
     p_PIS       := 0;
     Begin
        select *
          into vTpValefrete
        from tdvadm.t_con_valefrete vf
        where vf.con_conhecimento_codigo = p_vfnumero
          and vf.con_conhecimento_serie = p_vfserie
          and vf.glb_rota_codigo = p_vfrota
          and vf.con_valefrete_saque = p_vfsaque;
     Exception
       When NO_DATA_FOUND Then
          p_Status := 'E';
          p_Message := 'Vale de Frete Não Localizado';
          Return;
       end ;

      -- Verifica se é FROTA
      If substr(vTpValefrete.Con_Valefrete_Placa,1,3) = '000' Then 
         p_Status := 'W';
         p_Message := 'Vale de Frete de Frete de FROTA';
         Return;
      End If;

      -- Pega o Proprietario
      Begin
         select v.car_proprietario_cgccpfcodigo,
                p.car_proprietario_tipopessoa
            into vCNPJ,
                 vCNPJTp
         from tdvadm.t_car_veiculo v,
              tdvadm.t_car_proprietario p
         where 0 = 0
           and v.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo
           and v.car_veiculo_placa = vTpValefrete.Con_Valefrete_Placa
           and v.car_veiculo_saque = vTpValefrete.Con_Valefrete_Placasaque;
      Exception
        When NO_DATA_FOUND Then
           p_Status := 'E';
           p_Message := 'Problemas na Identificação do Proprietario';
           Return;
        End;
        
      If vCNPJTp = 'J' Then
         p_Status := 'W';
         p_Message := 'Vale de Frete de Pessoa Juridica';
         Return;
      End If;

      vReferencia := to_char(vTpValefrete.Con_Valefrete_Datacadastro,'YYYYMM');
      vRef_MMAAAA := to_char(vTpValefrete.Con_Valefrete_Datacadastro,'MM/YYYY');



    for c_msg in (select p.usu_perfil_codigo,
                         p.usu_perfil_paran1
                         ,p.usu_perfil_descricao 
                  from t_usu_perfil p
                  where p.usu_aplicacao_codigo in ('0000000000','comvlfrete')
                                                -- Bases
                    and p.usu_perfil_codigo in ('BSINSS_PF', 
                                                'IRRF_PF',   
                                                'BSESTSENAT',
                                                -- Aliquotas
                                                'INSS_PF', 
                                                'SESTSENAT', 
                                                'COFINS_PJ', 
                                                'CSLL_PJ',  
                                                'PIS_PJ', 
                                                'IRRF_PJ',
                                                -- Limite Descoonto INSS  
                                                'LIMINSS_PF', 
                                                -- Valor de Deducao por Dependente
                                                'VLR_DESC_DEP_IR') -- *
                    and to_char(p.usu_perfil_vigencia,'YYYYMM') <= vReferencia
                    and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                                 from t_usu_perfil p1
                                                 where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                                   and p1.usu_perfil_codigo = p.usu_perfil_codigo   
                                                   and p1.usu_perfil_vigencia <= sysdate)
                  )
      Loop
        
      
          If c_msg.usu_perfil_codigo = 'LIMINSS_PF' Then
             vLimiteDesINSS := c_msg.usu_perfil_paran1;

          ElsIf    c_msg.usu_perfil_codigo = 'BSINSS_PF' Then
--  Mudado em 30/04/2021
--             vBaseINSS := c_msg.usu_perfil_paran1;
             vPrecBaseINSS := ( c_msg.usu_perfil_paran1 / 100 );
          ElsIf c_msg.usu_perfil_codigo = 'INSS_PF' Then
             vAliqINSS :=  (c_msg.usu_perfil_paran1 / 100 );

          ElsIf c_msg.usu_perfil_codigo = 'BSESTSENAT' Then
--  Mudado em 30/04/2021
--             vBaseSESTSENAT := c_msg.usu_perfil_paran1;
             vPrecBaseSESTSENAT := ( c_msg.usu_perfil_paran1 / 100 );
          ElsIf c_msg.usu_perfil_codigo = 'SESTSENAT' Then
             vAliqSESTSENAT := ( c_msg.usu_perfil_paran1 / 100 );

          ElsIf c_msg.usu_perfil_codigo = 'IRRF_PF' Then
             vPrecBaseIRRF_PF := ( c_msg.usu_perfil_paran1 / 100 );

          ElsIf c_msg.usu_perfil_codigo = 'COFINS_PJ' Then
             vAliqCOFINS := ( c_msg.usu_perfil_paran1 / 100 );
          ElsIf c_msg.usu_perfil_codigo = 'CSLL_PJ' Then
             vAliqCSLL := ( c_msg.usu_perfil_paran1  / 100 );
          ElsIf c_msg.usu_perfil_codigo = 'PIS_PJ' Then
             vAliqPIS := ( c_msg.usu_perfil_paran1 / 100 );
          ElsIf c_msg.usu_perfil_codigo = 'IRRF_PJ' Then
             vAliqIRRF_PJ := ( c_msg.usu_perfil_paran1 / 100 );
          ElsIf c_msg.usu_perfil_codigo = 'VLR_DESC_DEP_IR' Then
             vVlrDeduzDep := c_msg.usu_perfil_paran1; 
          End If;
        
      End Loop;
      
      vXmlIn :=           '<Parametros> ';
      vXmlIn := vXmlIn || '   <Input>';
      vXmlIn := vXmlIn || '     <pProprietario>' || trim(vCNPJ) || '</pProprietario> ';
      vXmlIn := vXmlIn || '     <pReferencia>' || vReferencia  || '</pReferencia>';
      vXmlIn := vXmlIn || '     <pRotaUsuario></pRotaUsuario>';
      vXmlIn := vXmlIn || '     <pUsuario/>';
      vXmlIn := vXmlIn || '     <pAplicacao/>';
      vXmlIn := vXmlIn || '     <pVersao/>';
      vXmlIn := vXmlIn || '   </Input>';
      vXmlIn := vXmlIn || '</Parametros>';    


      TDVADM.Pkg_Car_Proprietario.Sp_Calcula_SaldoCarreteiro(vXmlIn,
                                                             vStatus,
                                                             vMessage);
      
      -- Pega Valores Acumulados
      Begin 
         select i.con_valefrete_impostosvlracumu,
                i.con_valefrete_impostos_irrf,
                i.con_valefrete_impostos_inss  
           into vValorTOTALIR_PF,
                vVlrRetidoIRRF,
                vVlrRetidoINSS
         from tdvadm.t_Con_Valefreteimpostos i
         where i.car_proprietario_cgccpfcodigo = vCNPJ
           and i.con_valefrete_impostos_ref = vRef_MMAAAA;
      Exception
        When NO_DATA_FOUND Then
           vVlrRetidoIRRF := 0;
           vVlrRetidoINSS := 0;
        End ;


      -- Calcula a Base do INSS
      If vTpValefrete.Glb_Tpmotorista_Codigo = 'A' Then
         vBaseINSS := vTpValefrete.Con_Valefrete_Valorcomdesconto;
      Else
         If vTpValefrete.Con_Valefrete_Tipocusto = 'T' Then
            vBaseINSS := vTpValefrete.Con_Valefrete_Custocarreteiro * vTpValefrete.Con_Valefrete_Pesocobrado;
         Else
            vBaseINSS := vTpValefrete.Con_Valefrete_Custocarreteiro;
         End If; 
      End If;
      -- Retirando o Pedagio da Base do INSS
      vBaseINSS := vBaseINSS - nvl(vTpValefrete.Con_Valefrete_Pedagio,0);

      -- Verifica se ja chagou no limite do INSS
      if vVlrRetidoINSS = vLimiteDesINSS Then
         p_INSS := 0;
      Else
         p_INSS := nvl( ( vBaseINSS * vPrecBaseINSS ) * vAliqINSS ,0);
      End If;

      p_INSS := round(p_INSS,2);

      
      
      -- Se ultrapassar o Limite pega so a diferenca
      If ( p_INSS > 0 ) and  ( ( vVlrRetidoINSS + p_INSS ) > vLimiteDesINSS ) Then
         p_INSS := nvl(vLimiteDesINSS - vVlrRetidoINSS,0);
      End If;

      If nvl(p_INSS,0) <= 0 Then
         p_INSS := 0;
      End If;



      p_SESTSENAT := nvl(( vBaseINSS * vPrecBaseSESTSENAT ) * vAliqSESTSENAT,0);
      
      p_SESTSENAT := round(p_SESTSENAT,2);

      
      -- Calcula a Base do IRRF
      If vTpValefrete.Glb_Tpmotorista_Codigo = 'A' Then
         vBaseIRRF_PF := vTpValefrete.Con_Valefrete_Valorcomdesconto;
      Else
         If vTpValefrete.Con_Valefrete_Tipocusto = 'T' Then
            vBaseIRRF_PF := vTpValefrete.Con_Valefrete_Custocarreteiro * vTpValefrete.Con_Valefrete_Pesocobrado;
         Else
            vBaseIRRF_PF := vTpValefrete.Con_Valefrete_Custocarreteiro;
         End If; 
      End If;
      -- Retirando o Pedagio da Base do INSS
      vBaseIRRF_PF := vBaseIRRF_PF - nvl(vTpValefrete.Con_Valefrete_Pedagio,0);
      -- Retirado somente o INSS da BASE doooSETSSENAT de desconto da BASE
      vBaseIRRF_PF := ( vBaseIRRF_PF - p_INSS /*- p_SESTSENAT*/ ) * vPrecBaseIRRF_PF ;
      -- Acrescenta o total ja pago

      vBaseIRRF_PF := vBaseIRRF_PF + ( vValorTOTALIR_PF * vPrecBaseIRRF_PF )  ;

      Begin
         select --p.usu_perfil_paran1 faixai,
                --p.usu_perfil_paran2 faixaf,
                p.usu_perfil_paran3 aliquota,
                p.usu_perfil_paran4 deduzir
              INTO vAliqIRRF_PF,
                   vDeduzir_PF       
         from t_usu_perfil p
         where p.usu_aplicacao_codigo = '0000000000'
           and p.usu_perfil_codigo like '%FAIXAIR%'
           and to_char(p.usu_perfil_vigencia,'YYYYMM') <= vReferencia
           and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                        from t_usu_perfil p1
                                        where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                          and p1.usu_perfil_codigo = p.usu_perfil_codigo   
                                          and p1.usu_perfil_vigencia <= sysdate)
           and vBaseIRRF_PF between p.usu_perfil_paran1 and p.usu_perfil_paran2;
            
           vAliqIRRF_PF := ( vAliqIRRF_PF / 100 );

      Exception
        When NO_DATA_FOUND Then
           vAliqIRRF_PF := 0;
           vDeduzir_PF := 0;
        End ;

      p_IRRF := nvl( ( vBaseIRRF_PF * vAliqIRRF_PF ) - vDeduzir_PF ,0)   ;  
     
      p_IRRF := p_IRRF - vVlrRetidoIRRF;

      p_IRRF := round(p_IRRF,2);
      If p_IRRF < 0 Then
         p_IRRF := 0;
      End If;
   End sp_con_calcImpostos;                                  


   Procedure sp_con_atualizaFreteAnalise
    As
      vValeFrete tdvadm.t_con_valefrete.con_conhecimento_codigo%type;
      vSerie     tdvadm.t_con_valefrete.con_conhecimento_serie%type;
      vRota      tdvadm.t_con_valefrete.glb_rota_codigo%type;
      vSaque     tdvadm.t_con_valefrete.con_valefrete_saque%type;
      vSaquePesq tdvadm.t_con_valefrete.con_valefrete_saque%type;
      vAuxiliar  number;
      Begin  

          insert into tdvadm.t_fcf_freteanalise
          select * from tdvadm.v_fcf_gilbertojose x
          where 0 = 0
            and trunc(x.cadastro) >= to_date(sysdate-10,'dd/mm/yyyy')
            and trunc(x.cadastro) <= trunc(sysdate-1)
           and 0 = (select count(*)
                     from tdvadm.t_fcf_freteanalise f
                     where f.vfrete = x.vfrete
                       and f.rota = x.rota
                       and trunc(f.cadastro) = trunc(x.cadastro));
          commit;
           

    for c_msg in (select x.*,x.rowid
                  from tdvadm.t_fcf_freteanalise x
                  where 0 = 0
                    and nvl(x.fretecar,0) = 0
                    and x.cadastro >= to_date(sysdate-10,'dd/mm/yyyy')
                  )
    Loop
        for c_msg1 in (select fc.fcf_fretecar_valor,fc.fcf_fretecar_dtcadastro,fc.fcf_fretecar_vigencia
                       from tdvadm.t_fcf_fretecar fc
                       where fc.fcf_fretecar_origemi = rpad(tdvadm.fn_busca_codigoibge(c_msg.codorigemsv,'IBC'),8)
                         and fc.fcf_fretecar_destinoi = rpad(tdvadm.fn_busca_codigoibge(c_msg.coddestinosv,'IBC'),8)
                         and fc.fcf_fretecar_tpfrete = rpad(c_msg.tipofrete,2)
                         and fc.fcf_tpveiculo_codigo = rpad(c_msg.tpveiculo,3)
                         and fc.fcf_tpcarga_codigo = rpad(c_msg.tpcarga,3)
                         and fc.fcf_fretecar_vigencia = (select max(fc1.fcf_fretecar_vigencia)
                                                         from tdvadm.t_fcf_fretecar fc1
                                                         where fc1.fcf_fretecar_origemi = fc.fcf_fretecar_origemi
                                                           and fc1.fcf_fretecar_destinoi = fc.fcf_fretecar_destinoi
                                                           and fc1.fcf_fretecar_tpfrete = fc.fcf_fretecar_tpfrete
                                                           and fc1.fcf_tpveiculo_codigo = fc.fcf_tpveiculo_codigo
                                                           and fc1.fcf_tpcarga_codigo = fc.fcf_tpcarga_codigo)
                       order by 1)
         Loop
            c_msg.fretecar   := c_msg1.fcf_fretecar_valor;
            c_msg.dtcadastro := c_msg1.fcf_fretecar_dtcadastro;
            c_msg.dtvigencia := c_msg1.fcf_fretecar_vigencia;
         End Loop;
         
         update tdvadm.t_fcf_freteanalise x
           set x.fretecar = c_msg.fretecar,
               x.dtcadastro = c_msg.dtcadastro,
               x.dtvigencia = c_msg.dtvigencia   
         where x.rowid = c_msg.rowid;
         COMMIT;
    End Loop; 
    commit;

           update tdvadm.t_fcf_freteanalise x
             set ( x.pedagiovf ) = (select vf.con_valefrete_pedagio 
                                    from tdvadm.t_con_valefrete vf 
                                    where vf.con_conhecimento_codigo = substr(x.chave,1,6) 
                                      and vf.con_conhecimento_serie = substr(x.chave,7,2) 
                                      and vf.glb_rota_codigo = substr(x.chave,9,3) 
                                      and vf.con_valefrete_saque = substr(x.chave,12,1))
            WHERE x.pedagiovf = 0
              and x.cadastro >= to_date(sysdate-10,'dd/mm/yyyy');
          commit; 

           update tdvadm.t_fcf_freteanalise x
             set ( x.statusvf ) = (select vf.con_valefrete_status 
                                   from tdvadm.t_con_valefrete vf 
                                   where vf.con_conhecimento_codigo = substr(x.chave,1,6) 
                                     and vf.con_conhecimento_serie = substr(x.chave,7,2) 
                                     and vf.glb_rota_codigo = substr(x.chave,9,3) 
                                     and vf.con_valefrete_saque = substr(x.chave,12,1))
            WHERE x.cadastro >= to_date(sysdate-30,'dd/mm/yyyy');
          commit; 

          for c_msg in (select fa.chave
                        from tdvadm.t_fcf_freteanalise fa
                        where fa.statusvf is null
                          and fa.cadastro >= to_date(sysdate-30,'dd/mm/yyyy'))
          Loop                       
                 vValeFrete := substr(c_msg.chave,1,6); 
                 vSerie     := substr(c_msg.chave,7,2); 
                 vRota      := substr(c_msg.chave,9,3); 
                 vSaque     := substr(c_msg.chave,11,1); 
                 
              select min(vf.con_valefrete_saque)
                into vSaquePesq
              from tdvadm.t_con_valefrete vf
              where vf.con_conhecimento_codigo = vValeFrete
                and vf.con_conhecimento_serie  = vSerie
                and vf.glb_rota_codigo         = vRota
                and vf.con_valefrete_status is null
                and nvl(vf.con_valefrete_impresso,'N') = 'S';

              Update tdvadm.t_fcf_freteanalise x
                set x.menorsaque = decode(vSaquePesq,vSaque,'S','N')
              where x.chave = c_msg.chave;
          End Loop;

          update tdvadm.t_fcf_freteanalise x
            set x.pedagiotdv = tdvadm.F_BUSCA_PEDAGIO_PERCURSO_ATU(TRIM(x.codorigemsv),TRIM(x.coddestinosv))
          where nvl(x.pedagiotdv,0) = 0  
            and x.cadastro >= to_date(sysdate-10,'dd/mm/yyyy');
          commit;

          update tdvadm.t_fcf_freteanalise x
            set x.km = 20
          where x.km <= 0
            and tdvadm.fn_busca_codigoibge(x.codorigemsv,'IBC') = tdvadm.fn_busca_codigoibge(x.coddestinosv,'IBC');
            
          for c_msg in (select distinct x.codorigemsv,
                                        x.coddestinosv,
                                        tdvadm.fn_busca_codigoibge(x.codorigemsv,'IBC') origemib,
                                        tdvadm.fn_busca_codigoibge(x.coddestinosv,'IBC') destinoib
                        from tdvadm.t_fcf_freteanalise x
                        where x.km <= 0)
          Loop
 
             vAuxiliar := tdvadm.pkg_fifo_carregctrc.fn_ConsultaKM(c_msg.codorigemsv,c_msg.coddestinosv) ;            
            
          End Loop;

          update tdvadm.t_fcf_freteanalise x
            set x.km = tdvadm.fn_busca_km(x.codorigemsv,x.coddestinosv)
          where x.km <= 0;
          
          commit; 

      End sp_con_atualizaFreteAnalise;
   
   Procedure Sp_Con_CancelaVfAmfo(p_chavemdfe in tdvadm.t_con_controlemdfe.con_controlemdfe_chaveaces%type,
                                         p_status    out char,
                                         p_messagen  out varchar2) as

  vveicdisp     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
  vveicdispseq  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
  vAuxiliar     integer;
  
  Begin

     Begin

        -- Busca do veiculo Disp
        Begin
            select vf.fcf_veiculodisp_codigo,
                   vf.fcf_veiculodisp_sequencia
              into vveicdisp,
                   vveicdispseq
              from tdvadm.t_con_controlemdfe  l,
                   tdvadm.t_con_veicdispmanif m,
                   tdvadm.t_con_valefrete     vf
             where l.con_manifesto_codigo       = m.con_manifesto_codigo
               and l.con_manifesto_serie        = m.con_manifesto_serie
               and l.con_manifesto_rota         = m.con_manifesto_rota
               and m.fcf_veiculodisp_codigo     = vf.fcf_veiculodisp_codigo
               and m.fcf_veiculodisp_sequencia  = vf.fcf_veiculodisp_sequencia
               and l.con_controlemdfe_chaveaces = p_chavemdfe;
        exception
          When NO_DATA_FOUND Then
              vveicdisp := null;
              vveicdispseq := null;
          End; 
        -- analise para saber se existe vale frete do cliente especifico (ANFO)
        If vveicdisp is not null Then
            select count(*)
              into vAuxiliar
              from tdvadm.t_con_valefrete vf,
                   tdvadm.t_con_vfreteconhec vfc,
                   tdvadm.t_con_conhecimento c
             where 0 = 0
               and vf.con_valefrete_datacadastro                 >= '01/07/2017'
               and vf.con_conhecimento_codigo                    = vfc.con_valefrete_codigo   (+)
               and vf.con_conhecimento_serie                     = vfc.con_valefrete_serie     (+)
               and vf.glb_rota_codigo                            = vfc.glb_rota_codigovalefrete       (+)
               and vf.con_valefrete_saque                        = vfc.con_valefrete_saque        (+)
               and vfc.con_conhecimento_codigo                   = c.con_conhecimento_codigo (+)
               and vfc.con_conhecimento_serie                    = c.con_conhecimento_serie (+)
               and vfc.glb_rota_codigo                           = c.glb_rota_codigo (+)
               and vf.fcf_veiculodisp_codigo                     = vVeicDisp
               and vf.fcf_veiculodisp_sequencia                  = vVeicDispSeq
               and tdvadm.pkg_slf_utilitarios.fn_retorna_contratoCod(c.con_conhecimento_codigo,
                                                                     c.con_conhecimento_serie,
                                                                     c.glb_rota_codigo) = 'C5900010739';

            -- Cancela o Vale de frete
            If vAuxiliar > 0  Then

              update tdvadm.t_con_valefrete vf
                 set vf.con_valefrete_status        = 'C',
                     vf.con_valefrete_condespeciais = 'VALE DE FRETE USADO SOMENTE PARA EMITIR MANIFESTO - CARREGAMENTO ANFO'
               Where vf.fcf_veiculodisp_codigo      = vVeicDisp
                 and vf.fcf_veiculodisp_sequencia   = vVeicDispSeq
                 and vf.con_valefrete_impresso      is null
                 and vf.cax_boletim_data            is null;

            End If;

            -- Delete a tabela tdvadm.t_fcf_veiculodispdup
            delete tdvadm.t_fcf_veiculodispdup vd
             where vd.fcf_veiculodisp_codigo    = vVeicDisp
               and vd.fcf_veiculodisp_sequencia = vVeicDispSeq;

            p_status    := 'N';
            p_messagen  := 'Processamento Normal!';
        End If; 
      exception when others then
        p_status    := 'E';
        p_messagen  := 'Erro ao executar sp_con_cancelavfamfo. Erro.: '||sqlerrm;
      end;

  End Sp_Con_CancelaVfAmfo;
  
  Function Fn_VerificaObrigacaoDigCodOrigem(pListaParams IN glbadm.pkg_listas.tlistausuparametros,
                                            pGrupoEconomico TDVADM.T_GLB_CLIENTE.GLB_GRUPOECONOMICO_CODIGO%type)
    RETURN BOOLEAN
    As
    Begin                     
        
        If plistaparams('OBRIGA_COD_AGEND').texto = 'S' Then
            If INSTR(plistaparams('OBRIGA_COD_AGEND_GRUPO').texto, pGrupoEconomico) > 0 Then                              
                             
                Return True;
                  
            Else
                Return False;       
            End If;
               
        Else
          Return False;
        End If;              
    
    end Fn_VerificaObrigacaoDigCodOrigem;


 /*

 create table t_con_analisediario
 as
 select vf.con_conhecimento_codigo vf,
        vf.glb_rota_codigo rt,
        vf.con_valefrete_saque,
        vf.con_valefrete_placa placa,
        vf.con_valefrete_localcarreg carrega,
        vf.con_valefrete_localdescarga descarga,
        vf.con_valefrete_pesocobrado peso,
        db.codigobarra barra,
        db.data1,
        db.hora1iv,
        db.hora1fv,
        db.con_diariobordo_jornada1 jornada1,
        db.con_diariobordo_descanso1 descanso1,
        db.con_diariobordo_espera1 espera1
 from t_con_diariobordo db,
      t_con_valefrete vf
 where 0 = 0
   and db.con_conhecimento_codigo = vf.con_conhecimento_codigo
   and db.con_conhecimento_serie  = vf.con_conhecimento_serie
   and db.glb_rota_codigo         = vf.glb_rota_codigo
   and db.con_valefrete_saque     = vf.con_valefrete_saque
   and ( TO_NUMBER(substr(db.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora1fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora2fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora3fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora4fv,1,2)) < 23 )
   and vf.con_valefrete_datacadastro >= '01/03/2014'
   and vf.con_valefrete_datacadastro <= '30/09/2014'
   and nvl(db.con_diariobordo_jornada1,0) > 0
   and db.glb_solicitacao_dtgravacao = (select max(db1.glb_solicitacao_dtgravacao)
                                        from t_con_diariobordo db1
                                        where db1.codigobarra = db.codigobarra
                                          and ( TO_NUMBER(substr(db1.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora1fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora2fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora3fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora4fv,1,2)) < 23 ))
 union
 select vf.con_conhecimento_codigo vf,
        vf.glb_rota_codigo rt,
        vf.con_valefrete_saque,
        vf.con_valefrete_placa placa,
        vf.con_valefrete_localcarreg carrega,
        vf.con_valefrete_localdescarga descarga,
        vf.con_valefrete_pesocobrado peso,
        db.codigobarra barra,
        db.data2 DIA,
        db.hora2iv INICO,
        db.hora2fv FIM,
        db.con_diariobordo_jornada2 jornada,
        db.con_diariobordo_descanso2 descanso,
        db.con_diariobordo_espera2 espera
 from t_con_diariobordo db,
      t_con_valefrete vf
 where 0 = 0
   and db.con_conhecimento_codigo = vf.con_conhecimento_codigo
   and db.con_conhecimento_serie  = vf.con_conhecimento_serie
   and db.glb_rota_codigo         = vf.glb_rota_codigo
   and db.con_valefrete_saque     = vf.con_valefrete_saque
   and ( TO_NUMBER(substr(db.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora1fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora2fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora3fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora4fv,1,2)) < 23 )
   and vf.con_valefrete_datacadastro >= '01/03/2014'
   and vf.con_valefrete_datacadastro <= '30/09/2014'
   and nvl(db.con_diariobordo_jornada2,0) > 0
   and db.glb_solicitacao_dtgravacao = (select max(db1.glb_solicitacao_dtgravacao)
                                        from t_con_diariobordo db1
                                        where db1.codigobarra = db.codigobarra
                                          and ( TO_NUMBER(substr(db1.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora1fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora2fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora3fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora4fv,1,2)) < 23 ))
 union
 select vf.con_conhecimento_codigo vf,
        vf.glb_rota_codigo rt,
        vf.con_valefrete_saque,
        vf.con_valefrete_placa placa,
        vf.con_valefrete_localcarreg carrega,
        vf.con_valefrete_localdescarga descarga,
        vf.con_valefrete_pesocobrado peso,
        db.codigobarra barra,
        db.data3 DIA,
        db.hora3iv INICO,
        db.hora3fv FIM,
        db.con_diariobordo_jornada3 jornada,
        db.con_diariobordo_descanso3 descanso,
        db.con_diariobordo_espera3 espera
 from t_con_diariobordo db,
      t_con_valefrete vf
 where 0 = 0
   and db.con_conhecimento_codigo = vf.con_conhecimento_codigo
   and db.con_conhecimento_serie  = vf.con_conhecimento_serie
   and db.glb_rota_codigo         = vf.glb_rota_codigo
   and db.con_valefrete_saque     = vf.con_valefrete_saque
   and ( TO_NUMBER(substr(db.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora1fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora2fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora3fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora4fv,1,2)) < 23 )
   and vf.con_valefrete_datacadastro >= '01/03/2014'
   and vf.con_valefrete_datacadastro <= '30/09/2014'
   and nvl(db.con_diariobordo_jornada3,0) > 0
   and db.glb_solicitacao_dtgravacao = (select max(db1.glb_solicitacao_dtgravacao)
                                        from t_con_diariobordo db1
                                        where db1.codigobarra = db.codigobarra
                                          and ( TO_NUMBER(substr(db1.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora1fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora2fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora3fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora4fv,1,2)) < 23 ))
 union
 select vf.con_conhecimento_codigo vf,
        vf.glb_rota_codigo rt,
        vf.con_valefrete_saque,
        vf.con_valefrete_placa placa,
        vf.con_valefrete_localcarreg carrega,
        vf.con_valefrete_localdescarga descarga,
        vf.con_valefrete_pesocobrado peso,
        db.codigobarra barra,
        db.data4 DIA,
        db.hora4iv INICO,
        db.hora4fv FIM,
        db.con_diariobordo_jornada4 jornada,
        db.con_diariobordo_descanso4 descanso,
        db.con_diariobordo_espera4 espera
 from t_con_diariobordo db,
      t_con_valefrete vf
 where 0 = 0
   and db.con_conhecimento_codigo = vf.con_conhecimento_codigo
   and db.con_conhecimento_serie  = vf.con_conhecimento_serie
   and db.glb_rota_codigo         = vf.glb_rota_codigo
   and db.con_valefrete_saque     = vf.con_valefrete_saque
   and ( TO_NUMBER(substr(db.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora1fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora2fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora3fv,1,2)) < 23 )
   and ( TO_NUMBER(substr(db.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db.hora4fv,1,2)) < 23 )
   and vf.con_valefrete_datacadastro >= '01/03/2014'
   and vf.con_valefrete_datacadastro <= '30/09/2014'
   and nvl(db.con_diariobordo_jornada4,0) > 0
   and db.glb_solicitacao_dtgravacao = (select max(db1.glb_solicitacao_dtgravacao)
                                        from t_con_diariobordo db1
                                        where db1.codigobarra = db.codigobarra
                                          and ( TO_NUMBER(substr(db1.hora1iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora1fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora2iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora2fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora3iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora3fv,1,2)) < 23 )
                                          and ( TO_NUMBER(substr(db1.hora4iv,1,2)) < 23 OR TO_NUMBER(substr(db1.hora4fv,1,2)) < 23 ));

 */

-- Verifica se Desconta Bonus ou Não validando os Coontratos dos CTE´s
-- Se variaos contratos nos CTEs e Com DESCONTA igual a 'S' e 'N'
-- O Sistema pega o Maior que é o 'S'
 Function Fn_VerificaDescBonus(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                               pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                               pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                               pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type,
                               pTpMotrista     in tdvadm.t_con_valefrete.glb_tpmotorista_codigo%type default 'X')
       return char
 is
     vEFrota         char(1);
     vDescBonusFrota char(1);
     vDescBonus      char(1);
 begin
    Begin
       select NVL(MAX(cr.slf_clienteregras_bonus),'S') bonus,NVL(MAx(cr.slf_clienteregras_bonusfrota),'S') bonusfrota
          into vDescBonus,
               vDescBonusFrota 
       from tdvadm.t_slf_clienteregras cr
       where 0 = 0
         and cr.slf_contrato_codigo in (select distinct pkg_slf_utilitarios.fn_retorna_contratoCod(vfc.CON_CONHECIMENTO_CODIGO,
                                                                                                   vfc.CON_CONHECIMENTO_SERIE,
                                                                                                   vfc.GLB_ROTA_CODIGO)
                                        from tdvadm.t_con_vfreteconhec vfc
                                        where vfc.con_valefrete_codigo     = pValeFreteCod
                                          and vfc.con_valefrete_serie      = pValeFrereSerie
                                          and vfc.glb_rota_codigovalefrete = pValeFreteRota
                                          and vfc.con_valefrete_saque      = pValeFreteSaque)
         and cr.slf_clienteregras_ativo = 'S'
         and cr.slf_clienteregras_vigencia = (select max(cr1.slf_clienteregras_vigencia)
                                              from tdvadm.t_slf_clienteregras cr1
                                              where cr1.slf_contrato_codigo = cr.slf_contrato_codigo
                                                and cr1.slf_clienteregras_ativo = 'S') 
         and ( nvl(cr.slf_clienteregras_bonus,'N') = 'N'
            or nvl(cr.slf_clienteregras_bonusfrota,'N') = 'N');
       Exception
         When NO_DATA_FOUND Then
           vDescBonus      := 'S';
           vDescBonusFrota := 'S';
         End;
       If nvl(pTpMotrista,'X') = 'X' then
       Begin
          select decode(substr(vf.con_valefrete_placa,1,3),'000','S','N')
            into vEFrota
          from tdvadm.t_con_valefrete vf
          where vf.con_conhecimento_codigo = pValeFreteCod
            and vf.con_conhecimento_serie  = pValeFrereSerie
            and vf.glb_rota_codigo         = pValeFreteRota
            and vf.con_valefrete_saque     = pValeFreteSaque; 
       exception
         when NO_DATA_FOUND Then
            vEFrota := 'N';
         End; 
       Else
         If nvl(pTpMotrista,'X') <> 'F' Then
            vEFrota := 'N';
         Else
            vEFrota := 'F';
         End If;
       End If;
        
       If vEFrota = 'N' Then
          Return vDescBonus;
       Else
          Return vDescBonusFrota;
       End If;

 end Fn_VerificaDescBonus;

-- Verifica se Desconta Bonus ou Não validando o Coontrato Passado
-- Se variaos contratos nos CTEs e Com DESCONTA igual a 'S' e 'N'
-- O Sistema pega o Maior que é o 'S'
 Function Fn_VerificaDescBonus(pContrato in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                               pFrotaCar in char)
       return char
 is
     vDescBonusFrota char(1);
     vDescBonus      char(1);
 begin
    Begin   
       select NVL(MAX(cr.slf_clienteregras_bonus),'S') bonus,NVL(MAx(cr.slf_clienteregras_bonusfrota),'S') bonusfrota
          into vDescBonus,
               vDescBonusFrota 
       from tdvadm.t_slf_clienteregras cr
       where 0 = 0
         and cr.slf_contrato_codigo = pContrato
         and cr.slf_clienteregras_ativo = 'S'
         and cr.slf_clienteregras_vigencia = (select max(cr1.slf_clienteregras_vigencia)
                                              from tdvadm.t_slf_clienteregras cr1
                                              where cr1.slf_contrato_codigo = cr.slf_contrato_codigo
                                                and cr1.slf_clienteregras_ativo = 'S') 
         and ( nvl(cr.slf_clienteregras_bonus,'N') = 'N'
            or nvl(cr.slf_clienteregras_bonusfrota,'N') = 'N');
    Exception
      When NO_DATA_FOUND Then
         vDescBonus      := 'S';
         vDescBonusFrota := 'S';
    End;    
        
    If nvl(pFrotaCar,'C') = 'F' Then
       Return vDescBonusFrota;
    Else
       Return vDescBonus;
    End If;

 end Fn_VerificaDescBonus;


-- Verifica se Houve desconto ou nao no Vale de FRETE  
 Function Fn_RetornaDescBonus(pValeFreteCod   in t_con_valefrete.con_conhecimento_codigo%type,
                              pValeFrereSerie in t_con_valefrete.con_conhecimento_serie%type,
                              pValeFreteRota  in t_con_valefrete.glb_rota_codigo%type,
                              pValeFreteSaque in t_con_valefrete.con_valefrete_saque%type)
       return char
 is
     vBonus tdvadm.t_con_valefrete.con_valefrete_descbonus%type;
 begin
       SELECT NVL(VF.CON_VALEFRETE_DESCBONUS, 'N')  DESCBONUS 
       into vBonus                        
        FROM T_CON_VALEFRETE VF                                                           
       WHERE VF.CON_CONHECIMENTO_CODIGO = pValeFreteCod
         AND VF.CON_CONHECIMENTO_SERIE  = pValeFrereSerie
         AND VF.GLB_ROTA_CODIGO         = pValeFreteRota
         AND VF.CON_VALEFRETE_SAQUE     = pValeFreteSaque; 

       RETURN vBonus;
 end Fn_RetornaDescBonus;

END PKG_CON_VALEFRETE;
/
