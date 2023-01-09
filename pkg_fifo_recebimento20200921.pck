create or replace package pkg_fifo_recebimento is

TYPE T_CURSOR IS REF CURSOR;  

  
/***************************************************************************************************************/
/*                                        RELAÇÃO DE PROCEDURES                                                */
/***************************************************************************************************************/
----------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para inserir / Atualizar nota fiscal. Paramentro de entrada é um ARQUIVO XML           --
----------------------------------------------------------------------------------------------------------------
Procedure sp_InsertNota( pParamsEntrada In blob, 
                         pStatus         Out Char,
                         pMessage       Out Varchar2,
                         pParamsSaida    Out Clob  );



Procedure sp_InsertNotaVide(pParamsEntrada In clob, 
                            pStatus         Out Char,
                            pMessage       Out Varchar2,
                            pParamsSaida    Out Clob  ) ;



/***************************************************************************************************************/
/*                                          RELAÇÃO DE FUNÇÕES                                                 */
/***************************************************************************************************************/


/***************************************************************************************************************/





Function FNP_getDadosNotaXml(pXmlEntrada Varchar2) Return tdvadm.pkg_fifo.tDadosNota;

/* Procedure utilizada para gerar um cursor para alimentar o grid principal da Aba Recebimento                 */
procedure sp_getNotasRecebimentos( pNumNota      in  char,
                                   pCnpj         in  char,
                                   pEmbalagem    in  char,
                                   pCarregamento in  char,
                                   pColeta       in  char,
                                   pPo           in  char,
                                   pDataIni      in  char,
                                   pDataFim      in  char,
                                   pAxo          in  char,
                                   pArmazem      in  char,
                                   pCursor       out T_CURSOR,
                                   pStatus       out char,
                                   pMessage      out varchar2);
                                   
/* Procedure utilizada para gerar um cursor com os dados de uma nota fiscal para edição. Essa edição partirá do grid principal */                                   
procedure sp_getNotaFiscal( pNumNota       in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCnpjRemetente in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pCnpjDestino   in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pNumColeta     in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pNumEmbalagem  in tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pStatus        out char,
                            pMessage       out varchar2,
                            pCursor        out T_CURSOR);

/* função Utilizada para criar a Carga "T_ARM_CARGA" */
Function fn_CriaCarga( pCargaCodigo     tdvadm.t_arm_carga.arm_carga_codigo%Type,
                       pRota            tdvadm.t_arm_carga.glb_rota_codigo%type,
                       pTpCarga         tdvadm.t_arm_carga.glb_tpcarga_codigo%type,
                       pCargaStatus     tdvadm.t_arm_carga.arm_status_codigo%type,
                       pCargaCubado     tdvadm.t_arm_carga.arm_carga_cubado%type,
                       pDtInclusao      tdvadm.t_arm_carga.arm_carga_dtinclusao%type,
                       pDtFechamento    tdvadm.t_arm_carga.arm_carga_dtfechado%type,
                       pQtdeVolume      tdvadm.t_arm_carga.arm_carga_qtdvolume%type,
                       pCargaPeso       tdvadm.t_arm_carga.arm_carga_peso%type,
                       pCodDestino      tdvadm.t_arm_carga.glb_localidade_codigodestino%type, 
                       pUsuario         tdvadm.t_arm_carga.usu_usuario_codigo%Type ) Return pkg_fifo.tRetornoFunc;

/* função utilizada para criar registro na t_arm_cargadet */
Function fn_CriaCargaDet( pCargaCodigo   tdvadm.t_arm_cargadet.arm_carga_codigo%type,
                          pCargaDetSeq   tdvadm.t_arm_cargadet.arm_cargadet_seq%type,
                          pNotaSeq       tdvadm.t_arm_cargadet.arm_nota_sequencia%type,                           
                          pNotaNumero    tdvadm.t_arm_cargadet.arm_nota_numero%type,
                          pCnpjRemet     tdvadm.t_arm_cargadet.glb_cliente_cgccpfremetente%Type,
                          pEmbNumero     tdvadm.t_arm_cargadet.arm_embalagem_numero%type,
                          pEmbSeq        tdvadm.t_arm_cargadet.arm_embalagem_sequencia%type,
                          pEmbFlag       tdvadm.t_arm_cargadet.arm_embalagem_flag%type,
                          pUsuario       tdvadm.t_arm_cargadet.usu_usuario_codigo%Type ) Return pkg_fifo.tRetornoFunc;
                          
/* Função responsável por criar uma embalagem */                           
Function fn_CriaEmbalagem(  pEmbNumero       tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                            pEmbSequencia    tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                            pEmbFlag         tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                            pCargaCodigo     tdvadm.t_arm_embalagem.arm_carga_codigo%Type,
                            pDtInclusao      tdvadm.t_arm_embalagem.arm_embalagem_dtinclusao%Type,
                            pDtFechamento    tdvadm.t_arm_embalagem.arm_embalagem_dtfechado%Type,
                            pEmbAltura       tdvadm.t_arm_embalagem.arm_embalagem_altura%Type,
                            pEmbLargura      tdvadm.t_arm_embalagem.arm_embalagem_largura%Type,
                            pEmbComprimento  tdvadm.t_arm_embalagem.arm_embalagem_comprimento%Type,
                            pTpCarga         tdvadm.t_arm_embalagem.arm_tpcarga_codigo%Type,
                            pCgnpDestino     tdvadm.t_arm_embalagem.glb_cliente_cgccpfdestinatario%Type,
                            pTpEndDesTino    tdvadm.t_arm_embalagem.glb_tpcliend_coddestinatario%Type,
                            pArmazem         tdvadm.t_arm_embalagem.arm_armazem_codigo%Type,
                            pUsuario         tdvadm.t_arm_embalagem.usu_usuario_codigo%Type,
                            pCodigoOnu       tdvadm.t_arm_embalagem.glb_onu_codigo%Type,
                            pPesoNota        tdvadm.t_arm_embalagem.arm_embalagem_peso%Type,
                            pPesoBalanca     tdvadm.t_arm_embalagem.arm_embalagem_pesobalanca%Type) Return Char;

/* Procedure responsável por inserir uma nota no banco a partir do Recebimento com todas as suas dependencias   */
procedure sp_inserirDadosNota( pOrigemNota   in char,
                               pSequencia    in tdvadm.t_arm_nota.arm_nota_sequencia%type,
                               pNota         in tdvadm.t_arm_nota.arm_nota_numero%type,
                               pSerie        in tdvadm.t_arm_nota.arm_nota_serie%type,
                               pDtEmissao    in varchar2,
                               pDtSaida      in varchar2,
                               pTpNota       in tdvadm.t_arm_nota.arm_nota_tipo%type,
                               pRota         in tdvadm.t_arm_nota.glb_rota_codigo%type,
                               pArmazem      in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                               pTpCarga      in tdvadm.t_arm_nota.glb_tpcarga_codigo%type,
                               pCnpjRemet    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pTpEndRemet   in tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,
                               pCnpjDestino  in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                               pTpEndDestino in tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type,
                               pCnpjOutros   in varchar2,
                               pSacado       in char,
                               pLocOrigem    in tdvadm.t_arm_nota.glb_localidade_codigoorigem%type,
                               pLocDestino   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                               pAltura       in tdvadm.t_arm_nota.arm_nota_altura%type,
                               pLargura      in tdvadm.t_arm_nota.arm_nota_largura%type,
                               pComprimento  in tdvadm.t_arm_nota.arm_nota_comprimento%type,
                               pFlagEmp      in tdvadm.t_arm_nota.arm_nota_flagemp%type,
                               pQtdeEmp      in tdvadm.t_arm_nota.arm_nota_empqtde%type,
                               pMercadoria   in tdvadm.t_arm_nota.glb_mercadoria_codigo%type,
                               pVlrMercad    in tdvadm.t_arm_nota.arm_nota_valormerc%type,
                               pDescricao    In tdvadm.t_arm_nota.arm_nota_mercadoria%Type,
                               pQtdeVolume   in tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                               pPesoNota     in tdvadm.t_arm_nota.arm_nota_peso%type,
                               pPesoBalanca  in tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                               pCubagem      in tdvadm.t_arm_nota.arm_nota_cubagem%type,
                               pChaveNfe     in tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                               pCfop         in tdvadm.t_arm_nota.glb_cfop_codigo%type,
                               pDi           in tdvadm.t_arm_nota.arm_nota_di%type,
                               pContrato     in tdvadm.t_arm_nota.slf_contrato_codigo%type,
                               pTpRequis     in tdvadm.t_arm_nota.arm_nota_tabsol%type,
                               pRequisCod    in tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                               pSaqueRequis  in tdvadm.t_arm_nota.arm_nota_tabsolsq%type,
                               pCodOnu       in tdvadm.t_arm_nota.arm_nota_onu%type,
                               pGrpEmbOnu    in tdvadm.t_arm_nota.arm_nota_grpemb%type,
                               pColeta       in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                               pTpColeta     in tdvadm.t_arm_nota.arm_coleta_tpcompra%type,
                               pPO           in tdvadm.t_arm_nota.xml_notalinha_numdoc%type,
                               pNotaVide     in tdvadm.t_arm_nota.arm_nota_vide%type,
                               pUsuario      in tdvadm.t_arm_nota.usu_usuario_codigo%type,
                               pVideSeq      In Integer,
                               pVideNumNota  In Integer,
                               pVideSerie    In Char,
                               pVideCnpj     In Char,
                               pStatus       out char,
                               pMessage      out Varchar2);

/* Função responsável por criar um registro na T_ARM_NOTA  */
Function fn_CriaNotaFiscal( pUsusario      tdvadm.t_arm_nota.usu_usuario_codigo%type, 
                            pNumNota       tdvadm.t_arm_nota.arm_nota_numero%type,
                            pNotaSeq       tdvadm.t_arm_nota.arm_nota_sequencia%type,
                            pSerie         tdvadm.t_arm_nota.arm_nota_serie%type,
                            pDtEmissao     tdvadm.t_arm_nota.arm_movimento_datanfentrada%type,
                            pDtInclusao    tdvadm.t_arm_nota.arm_nota_dtinclusao%type,
                            pDtSaida       tdvadm.t_arm_nota.arm_nota_dtrecebimento%type,
                            pMercadCod     tdvadm.t_arm_nota.glb_mercadoria_codigo%type,
                            pDescMercad    tdvadm.t_arm_nota.arm_nota_mercadoria%type,
                            pValorNota     tdvadm.t_arm_nota.arm_nota_valormerc%type,
                            pFlagEmp       tdvadm.t_arm_nota.arm_nota_flagemp%type,
                            pQtdeEmp       tdvadm.t_arm_nota.arm_nota_empqtde%type,
                            pTipoNota      tdvadm.t_arm_nota.arm_nota_tipo%type,
                            pVideNota      tdvadm.t_arm_nota.arm_nota_vide%type,
                            pNotaAtrb      tdvadm.t_arm_nota.arm_nota_atribuido%type,   --"S"
                            pNotaAtrbMov   tdvadm.t_arm_nota.arm_nota_atribui_movimento%type,
                            pPo            tdvadm.t_arm_nota.xml_notalinha_numdoc%type,
                            pDi            tdvadm.t_arm_nota.arm_nota_di%type,
                            pCnpjRemet     tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pTpEndRemet    tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,
                            pCnpjDestino   tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pTpEndDest     tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type, 
                            pCnpjSacado    tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,
                            pTpEndSacado   tdvadm.t_arm_nota.glb_tpcliend_codsacado%type,
                            pCodOrigem     tdvadm.t_arm_nota.glb_localidade_codigoorigem%type,
                            pTpRequis      tdvadm.t_arm_nota.arm_nota_tabsol%type,
                            pCodRequis     tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                            pSaqRequis     tdvadm.t_Arm_nota.arm_nota_tabsolsq%type,
                            pContrato      tdvadm.t_arm_nota.slf_contrato_codigo%type,
                            pFlagPgto      tdvadm.t_arm_nota.arm_nota_flagpgto%type,
                            pQtdeVolume    tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                            pLargura       tdvadm.t_arm_nota.arm_nota_largura%type,
                            pAltura        tdvadm.t_arm_nota.arm_nota_altura%type,
                            pComprimento   tdvadm.t_arm_nota.arm_nota_comprimento%type,
                            pCargaCod      tdvadm.t_arm_nota.arm_carga_codigo%type,
                            pTpCargaCod    tdvadm.t_arm_nota.glb_tpcarga_codigo%type,
                            pNumColeta     tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pTpCompra      tdvadm.t_arm_nota.arm_coleta_tpcompra%type,
                            pEmbNumero     tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pEmbFlag       tdvadm.t_arm_nota.arm_embalagem_flag%type,
                            pEmbSeq        tdvadm.t_arm_nota.arm_embalagem_sequencia%type,
                            pPesoNota      tdvadm.t_arm_nota.arm_nota_peso%type,
                            pPesoBalanca   tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                            pCubagem       tdvadm.t_arm_nota.arm_nota_cubagem%type,
                            pRota          tdvadm.t_arm_nota.glb_rota_codigo%type,
                            pArmazem       tdvadm.t_arm_nota.arm_armazem_codigo%type,
                            pChaveNFE      tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                            pCfop          tdvadm.t_arm_nota.glb_cfop_codigo%type,
                            pCodOnu        tdvadm.t_arm_nota.arm_nota_onu%type,
                            pGrpEmb        tdvadm.t_arm_nota.arm_nota_grpemb%type,
                            pNfe           tdvadm.t_arm_nota.arm_nota_nf_e%type,
                            pCTRCe         tdvadm.t_arm_nota.arm_nota_ctrc_e%type ) return char;


--Procedure utilizada para buscar lista de notas 
procedure sp_getVideNota( pCnpj in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                          pStatus out char,
                          pMessage out varchar2,
                          pCursor out tdvadm.pkg_fifo.T_CURSOR
                         );  
                         
/* Procedure utilizada para buscar dados da NotaFiscal a partir de uma chave nfe */                         
procedure sp_getDadosNota_chaveNFE( pChaveNfe  in  char,
                                    pNota_Coleta in pkg_fifo.tDadosNota,
                                    pStatus    out char,
                                    pMessage   out varchar2,
                                    pRetorno    Out pkg_fifo.tDadosNota   );


/* Procedure utilizada para buscar dados de uma coleta */
procedure sp_getDadosColeta( pColeta  in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                             pArmazem in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                             pStatus  out char,
                             pMessage out varchar2,
                             pCursor  out T_CURSOR ); 

/* Função utilizada para definir o tipo do Sacado */ 
Function fn_defineTpSacado( pCnpjRemet  In  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                            pCnpjDest   In  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                            pCnpjSacado In  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type
                           ) Return Char; 

/* Procedure utilizada para buscar os dados da Nota-Mae, quando tivermos uma nota Vide. */
procedure sp_getVideNota( pNotaVide    in  tdvadm.t_arm_notavide.arm_notavide_numero%type,
                          pCnpjVide    in  tdvadm.t_arm_notavide.arm_notavide_cgccpfremetente%type,
                          pSerieVide   in  tdvadm.t_arm_notavide.arm_notavide_serie%type,
                          pSeqVide     in  tdvadm.t_arm_notavide.arm_notavide_sequencia%type,
                          pVideNota    in  integer,
                          pNotaMae     out tdvadm.t_arm_notavide.arm_nota_numero%type,
                          pCnpjMae     out tdvadm.t_arm_notavide.glb_cliente_cgccpfremetente%type,
                          pSerieMae    out tdvadm.t_arm_notavide.arm_nota_serie%type,
                          pSeqMae      out tdvadm.t_arm_notavide.arm_nota_sequencia%type
                            );


Procedure SP_RECEB_GETNOTAS( pParamsEntrada   In Varchar2,
                             pStatus          Out Char,
                             pMessage         Out Varchar2,
                             pParamsSaida     Out Clob);                            

-- Função utilizada para receber solicitações para Notas Fiscais 
Procedure SP_SolicAutNotas( pXmlIn in varchar2, 
                            pStatus out char,
                            pMessage out varchar2,
                            pXmlOut out clob
                          );
                            


Function FNP_getXML_TpDocumentos( pAutorizacao   Char,
                                  pDocDefault    tdvadm.t_con_tpdoc.con_tpdoc_codigo%Type,
                                  pRota          tdvadm.t_con_tpdoc.glb_rota_codigo%type
                                 ) Return pkg_fifo.tRetornoFunc;
                     

Procedure SP_Get_DadosCliente( pXmlIn in varchar2, 
                               pStatus out char,
                               pMessage out varchar2,
                               pXmlOut out clob
                             );

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para definir os tipos de documentos possíveis de busca                                                         --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_GetTpDocBusca( pXmlIn In Varchar2,
                            pStatus Out Char,
                            pMessage Out Varchar2,
                            pXmlOut Out Varchar2
                          );

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar dados iniciais para lançamento de nota.                                                         --    
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_Get_DadosInicLanc( pXmlIn In Varchar2,
                                pStatus Out Char,
                                pMessage Out Varchar2,
                                pXmlOut Out Clob
                              );

----------------------------------------------------------------------------------------------------------------------------------------                       
-- Procedure utilizada para recuperar o Saque de uma Tabela ou solicitação a partir de seu numero                                     --
----------------------------------------------------------------------------------------------------------------------------------------
procedure SP_Get_SaqueTabSol( pXmlIn In Varchar2,
                              pStatus Out Char,
                              pMessage Out Varchar2,
                              pXmlOut Out Varchar2
                            );                              
                          
                                                               
----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar serviços adicionais cadastrados.                                                                --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure sp_get_servicosadd( pXmlIn In Varchar2,
                              pStatus Out Char,
                              pMessage Out Varchar2,
                              pXmlOut Out Clob
                            );

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure criara para o HELPDESK excluir notas fiscais Recebimento.                                                                --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_HD_Del_NotaFiscal( pArm_nota_numero In tdvadm.t_arm_nota.arm_nota_numero%Type,
                                pGlb_cliente_cgccpfremetente In tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%Type,
                                pArm_nota_serie In tdvadm.t_arm_nota.arm_nota_serie%Type,
                                pStatus Out Char,
                                pMessage Out Varchar2,
                                pSequencia In Integer);
                            
PROCEDURE Sp_Get_NotaPorChave(P_CHAVENFE IN  t_edi_nf.edi_nf_chavenfe%TYPE,
                              P_Nota     OUT t_Edi_Nf%RowType,
                              P_STATUS   OUT CHAR,
                              P_MESSAGE  OUT VARCHAR2);                          


  Procedure Sp_Get_NotasVencidasCount(    pArm_armazem_codigo in varchar2,
                                          pDtEmissao in varchar2,
                                          pNota in varchar2,
                                          pCnpjRemetente in varchar2,
                                          pStatus  out varchar2,
                                          pMessage out varchar2,
                                          pTotalPaginas out int);
                              
  Procedure Sp_Get_NotasVencidas(pArm_armazem_codigo in varchar2,
                                 pDtEmissao in varchar2,
                                 pNota in varchar2,
                                 pCnpjRemetente in varchar2,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2);
                               
Procedure Sp_Get_NotasAprovadasCount( pDtAprovacao in varchar2,
                                   pStatus  out varchar2,
                                   pMessage out varchar2,
                                   pTotalPaginas out int);

                               
Procedure Sp_Get_NotasAprovadas(pDtAprovacao in varchar2,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2);
                              
-- New 06/02/2014    

Procedure Sp_Get_NotaDevolReentr(pXmlIn In Varchar2,
                                 pXmlOut Out Clob,
                                 pStatus Out Char,
                                 pMessage Out Varchar2);  
                                 
Function Fn_Get_FinalizaDigNota(pCodigo In t_Arm_Coletaocor.Arm_Coletaocor_Codigo%Type) return char;                                                             

Procedure Sp_Get_ProdQuimico(pXmlIn In Varchar2,
                             pXmlOut Out Clob,
                             pStatus Out Char,
                             pMessage Out Varchar);

Procedure Sp_Get_Ocorrencias(pXmlIn In Varchar2,
                             pXmlOut Out Clob,
                             pStatus Out Char,
                             pMessage Out Varchar);                             

  Function FN_NotasVencidas( pArm_nota_numero              in integer,
                             pArm_nota_serie               in Varchar2,
                             p_glb_cliente_cgccpfremetente in Varchar2 ) return integer;

Procedure SP_INSERT_NOTA_SEM_PESAGEM( pArmNotaSequencia in varchar2,
                                        pUsuario in Varchar2,
                                        pObservacao in Varchar2,
                                        pStatus out char,
                                        pMessage out Varchar2 );
                                        
Procedure Sp_Get_NotasSemPesagem(pArm_armazem_codigo in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                                 pGlb_Rota_Codigo in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                 pusuUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2);

 Procedure Sp_Get_NFSemPesagemAut(pArm_armazem_codigo in varchar2,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2);

 Procedure Sp_Get_NFSemPesagemAutCount(pArm_armazem_codigo in varchar2,
                                 pStatus  out varchar2,
                                 pMessage out varchar2,
                                 pTotalPaginas out int);

Procedure Sp_Get_NotasSemPesagemCount(pArm_armazem_codigo in varchar2,
                                 pGlb_Rota_Codigo in varchar2,
                                 pusuUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                 pStatus  out varchar2,
                                 pMessage out varchar2,
                                 pTotalPaginas out int);

  Procedure SP_Autoriza_OC_Img (  pconConhecimentoCodigo in varchar2,
                                  pconConhecimentoSerie in varchar2,
                                  pconValeFreteSaque in varchar2,
                                  pglbGrupoImagemCodigo in varchar2,
                                  pglbRotaCodigo in varchar2,
                                  pglbTpArquivoCodigo in varchar2,
                                  pglbTpImagemCodigo in varchar2,
                                  pglbVfimagemCodCliente in varchar2,
                                  pStatus out char,
                                  pMessage out varchar2);
                                                                                                                                                                                                              
  Procedure SP_Get_Outros_Comp_Img ( pValeFrete in String,
                                     pPagina in int,
                                     pCursor out t_cursor,
                                     pStatus out char,
                                     pMessage out varchar2);

 Procedure SP_Get_Outros_Comp_ImgCount ( pValeFrete in String,
                                     pTotalReg out  int,
                                     pStatus out char,
                                     pMessage out varchar2);

 Procedure SP_Get_Outros_Comp( pValeFrete in String,
                               pPagina in int,
                               pCursor out t_cursor,
                               pStatus out char,
                               pMessage out varchar2);

 Procedure SP_Get_Outros_CompCount( pValeFrete in String,
                                    pTotalReg out int,
                                    pStatus out char,
                                    pMessage out varchar2);

                                                                                                                                                                               
function fn_get_dataentrega(pNota  in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCNPJ  in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pSerie in tdvadm.t_arm_nota.arm_nota_serie%type)
Return varchar2;



end pkg_fifo_recebimento;

 
/
create or replace package body pkg_fifo_recebimento is
 
/********************f*******************************************************************************************
* ROTINA           : pkg_fifo_recebimento                                                                      *
* PROGRAMA         : Pacote criado para centralizar as rotinas que serão utilizadas na aba RECEBIMENTO do FIFO *
*                    OBS.: As funções e Procedures contidas nesse package, serão chamadas atraves do PKG_FIFO  *
* ANALISTA         : Rogerio de Paula                                                                          *
* DATA DE CRIACAO  : 06/04/2011                                                                                *
* BANCO            : ORACLE-TDP                                                                                *
****************************************************************************************************************/
/**********************************************************/
/*                 CONSTANTES                             */
/**********************************************************/

cBusca        Constant char(1) := 'B';
cEtiqueta     Constant char(1) := 'L';
cEdicaoInsert Constant char(1) := 'E';
cExcluir      Constant char(1) := 'D';
cValidacao    Constant char(1) := 'V';



/***************************************************************************************************************/
/*                            VARIÁVEIS UTILIZADAS PARA ADMINISTRAR EXCEÇÕES.                                  */
/***************************************************************************************************************/
vEx_ParamsIniciais Exception;
vEx_ExecFunction Exception;

/***************************************************************************************************************/
/*                                      FUNÇÕES / PROCEDURE PRIVADAS                                       fn_CriaNotaFiscal    */
/***************************************************************************************************************/
--Função utilizada para verificar se a Nota solicitada faz parte do mesmo armazem do Usuario
Function FNP_Valida_ArmazemNota( pSeqNota    tdvadm.t_arm_nota.arm_nota_sequencia%Type,
                                 pRota       tdvadm.t_glb_rota.glb_rota_codigo%Type
                                ) 
                                Return pkg_fifo.tRetornoFunc Is 
 --Variável utilizada para guardar o Armazem da Nota Fiscal
 vNota_Armazem   tdvadm.t_arm_armazem.arm_armazem_codigo%Type; 
 
 --Variável que será utilizada como retorno da função.
 vRetorno   pkg_fifo.tRetornoFunc;
Begin
  --Limpo as variáveis que serão utilizadas para garantir que não vou pergar lixo.
  vRetorno.Status_Booleano := '';  
  vRetorno.Status := '';
  vRetorno.Message := '';
  vRetorno.Controle := 0;


 Begin 
   --Busco o Armazem cadastrado na nota, e guardo na variável específica
   Select n.arm_armazem_codigo 
   Into vNota_Armazem
   From T_Arm_Nota n
   Where n.arm_nota_sequencia = pSeqNota;
   
 Exception
   --Caso não encontre a nota, mostro mensagem na tela.
   When no_data_found Then
     vRetorno.Status := pkg_fifo.Status_Erro;
     vRetorno.Message := 'Nota Fiscal não localizada.';
     Return vRetorno;
 End; 
 
 --Verifico se o armazem da Nota, está cadastrada na Rota do Usuario.
 
 Select 
   Count(*) Into vRetorno.Controle
 From 
   t_arm_armazem w
 Where 
      w.glb_rota_codigo = pRota
  And w.arm_armazem_codigo = vNota_Armazem;
  
  --Caso não encontre o armazem, Mando mensagem explicativa.
  If vRetorno.Controle = 0 Then
    vRetorno.Status := 'N';
    vRetorno.Message := 'Nota Fiscal não está cadastrado em nenhum dos armazens da Rota do Usuário';
  End If;
  
  
  --Caso encontre, simplesmente seto a variável de status para Normal.
  If vRetorno.Controle > 0 Then
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
  End If;
  
  --Retorno a própria variável.  
  Return vRetorno;

End FNP_Valida_ArmazemNota; 

----------------------------------------------------------------------------------------------------------------
-- Função utilizada para criar uma coleta a partir dos dados de uma nota fiscal                            --
----------------------------------------------------------------------------------------------------------------    
Function FNP_Cria_Coleta( pDadosNota In pkg_fifo.tDadosNota,
                          pArm_coleta_ncompra Out t_arm_coleta.arm_coleta_ncompra%Type,
                          pArm_coleta_ciclo Out t_arm_coleta.arm_coleta_ciclo%Type,
                          pMessage Out Varchar
                        ) Return Boolean Is
 --Variáveis uitlizadas para recuperar dados da coleta.
 vArm_coleta_ncompra tdvadm.t_arm_coleta.arm_coleta_ncompra%Type;
 vArm_coleta_ciclo tdvadm.t_arm_coleta.arm_coleta_ciclo%Type;                        
 
 --Variável utilizada para criar / recuperar mensagens.
 vMessage Varchar2(30000);
 vStatus Char(1);
 
 --Variável de linha, utilizada para facilitar a inserção.
 vArm_coleta tdvadm.t_arm_coleta%Rowtype;
 vArm_Ncompra tdvadm.t_arm_coletancompra%Rowtype;
Begin
  --inicializa as variáveis que serão utilizadas nessa função
  vArm_coleta_ncompra := '';
  vArm_coleta_ciclo := '';
  vMessage := '';
  vStatus := '';
  
  Begin
    --verifico se os dados da nota, possui uma coleta.
    If ( nvl(pDadosNota.coleta_Codigo, 'r') != 'r' ) Then
      --Crio uma coleta coleta
      Return True;
      
    End If;  
    
    --Primeiro recupero os numeros de coleta
    pkg_arm_coleta.SP_GET_NUMCOLETA(vArm_coleta_ncompra, vArm_coleta_ciclo, vStatus, vMessage);
    
--    raise_application_error(-20888,pDadosNota.coleta_Tipo);
    
    --Dados da coleta
    vArm_coleta.Arm_Coleta_Ncompra      := vArm_coleta_ncompra;
    vArm_coleta.Arm_Coleta_Ciclo        := vArm_coleta_ciclo;
    vArm_coleta.Arm_Coleta_Tpcompra     := Case NVL(upper(substr(trim(pDadosNota.coleta_Tipo),1,1)), 'E') When 'E' Then 'FCA' Else 'FOB' End;
    vArm_coleta.Arm_Coleta_Entcoleta    := Case NVL(upper(substr(trim(pDadosNota.coleta_Tipo),1,1)), 'E') When 'E' Then 'E' Else 'C' End;
    vArm_coleta.Arm_Coleta_Tipo         := Case NVL(upper(substr(trim(pDadosNota.coleta_Tipo),1,1)), 'E') When 'E' Then 'ENTREGA' Else 'COLETAR' End;
    vArm_coleta.Arm_Coleta_Prioridade   := '4';
    vArm_coleta.Usu_Usuario_Codigo_Prog := pDadosNota.usu_usuario_codigo;
    vArm_coleta.Usu_Usuario_Codigo_Cad  := 'carreg';
    vArm_coleta.Arm_Armazem_Codigo      := pDadosNota.armazem_Codigo;
    vArm_coleta.Arm_Coleta_Peso         := pDadosNota.nota_pesoBalanca;
    vArm_coleta.Arm_Coleta_Vlmercadoria := pDadosNota.nota_ValorMerc;
    vArm_coleta.Glb_Cliente_Cgccpfcodigocoleta := pDadosNota.Remetente_CNPJ;
    vArm_coleta.Glb_Tpcliend_Codigocoleta      := pDadosNota.Remetente_tpCliente;
    vArm_coleta.Glb_Cliente_Cgccpfcodigoentreg := pDadosNota.Destino_CNPJ;
    vArm_coleta.Glb_Tpcliend_Codigoentrega     := pDadosNota.Destino_tpCliente;
    vArm_coleta.Arm_Coleta_Dtgravacao    := Sysdate;
    -- 16/04/2018
    -- Sirlano
    -- Alterado a pedido da Laila
    vArm_coleta.Arm_Coleta_Dtsolicitacao := trunc(sysdate); -- pDadosNota.nota_dtEmissao;
    vArm_coleta.Arm_Coleta_Hrsolicitacao := to_char(sysdate, 'hh24:mi');
    -- 16/04/2018
    -- Sirlano
    -- Alterado a pedido da Laila
    vArm_coleta.Arm_Coleta_Dtprogramacao := trunc(sysdate); -- pDadosNota.nota_dtEmissao; 
    -- Acrescenta 1 minuto na hora da solicitação
    vArm_coleta.Arm_Coleta_Hrprogramacao := to_char(sysdate + ((1/24)/60) , 'hh24:mi');
    vArm_coleta.Arm_Coleta_Normalimpexp  := 'N';
    vArm_coleta.Arm_Coletaorigem_Cod := 6;
    vArm_coleta.Usu_Usuario_Codalterou := pDadosNota.usu_usuario_codigo;
    if pDadosNota.nota_flagPgto = 'R' Then
       vArm_coleta.Arm_Coleta_Cnpjsolicitante := pDadosNota.Remetente_CNPJ;
--       pDadosNota.Sacado_CNPJ := pDadosNota.Remetente_CNPJ;
    ElsIf pDadosNota.nota_flagPgto = 'D' Then
       vArm_coleta.Arm_Coleta_Cnpjsolicitante := pDadosNota.Destino_CNPJ;
--       pDadosNota.Sacado_CNPJ := pDadosNota.Destino_CNPJ; 
    Else
       vArm_coleta.Arm_Coleta_Cnpjsolicitante := pDadosNota.Sacado_CNPJ;
    End If;     

    vArm_coleta.Arm_Coleta_Pagadorfrete  :=  pDadosNota.nota_flagPgto;
    vArm_coleta.Arm_Coleta_Pedido        := pDadosNota.nota_PO;    
   

    
    --Itens
    vArm_Ncompra.Arm_Coletancompra := vArm_coleta_ncompra;
    vArm_Ncompra.Arm_Coleta_Ciclo := vArm_coleta_ciclo;
    vArm_ncompra.GLB_MERCADORIA_CODIGO := pDadosNota.mercadoria_codigo;
    vArm_ncompra.GLB_EMBALAGEM_CODIGO := '56'; --'TDV CARGA NORMAL';
    vArm_ncompra.ARM_COLETANCOMPRA_MERCADORIA := pDadosNota.nota_descricao;
    vArm_ncompra.Arm_Coleta_Ncompra_Volume := pDadosNota.nota_qtdeVolume;
    vArm_ncompra.Arm_Coleta_Ncompra_Peso := pDadosNota.nota_pesoBalanca;
    vArm_ncompra.Arm_Coleta_Seqitem      := tdvadm.seq_col_itemcoleta.nextval;


    If pDadosNota.nota_RequisCodigo is not null Then
       If nvl(pDadosNota.nota_RequisTp,'X') = 'S'  Then 
          select sf.fcf_tpcarga_codigo
             into vArm_coleta.Fcf_Tpcarga_Codigo
          from tdvadm.t_slf_solfrete SF
          where sf.slf_solfrete_codigo = lpad(trim(pDadosNota.nota_RequisCodigo),8,'0')
            and sf.slf_solfrete_saque = lpad(trim(pDadosNota.nota_RequisSaque),4,'0');
       ElsIf nvl(pDadosNota.nota_RequisTp,'X') = 'T' Then
          select sf.fcf_tpcarga_codigo
             into vArm_coleta.Fcf_Tpcarga_Codigo
          from tdvadm.t_slf_Tabela SF
          where sf.slf_Tabela_codigo = lpad(trim(pDadosNota.nota_RequisCodigo),8,'0')
            and sf.slf_Tabela_saque = lpad(trim(pDadosNota.nota_RequisSaque),4,'0');
       Else
          vArm_coleta.Fcf_Tpcarga_Codigo := '12';
       End If; 
    Else
       vArm_coleta.Fcf_Tpcarga_Codigo := '12';
    End If;    




    
    Insert Into t_arm_coleta Values vArm_coleta;
    update t_arm_coleta co
      set co.Arm_Coleta_Tpcompra  = Case NVL(upper(substr(trim(pDadosNota.coleta_Tipo),1,1)), 'E') When 'E' Then 'FCA' Else 'FOB' End,
      co.Arm_Coleta_Entcoleta = Case NVL(upper(substr(trim(pDadosNota.coleta_Tipo),1,1)), 'E') When 'E' Then 'E' Else 'C' End,
      co.Arm_Coleta_Tipo      = Case NVL(upper(substr(trim(pDadosNota.coleta_Tipo),1,1)), 'E') When 'E' Then 'ENTREGA' Else 'COLETAR' End
    Where co.arm_coleta_ncompra = vArm_Ncompra.Arm_Coletancompra
      and co.arm_coleta_ciclo = vArm_Ncompra.Arm_Coleta_Ciclo;
      
    Insert Into t_arm_coletancompra Values vArm_Ncompra;
    Commit;
    
    --Seto os paramentros de saida.
    pArm_coleta_ncompra := vArm_coleta_ncompra;
    pArm_coleta_ciclo := vArm_coleta_ciclo;
    pMessage := '';
    Return True;
    
  Exception
    When Others Then
      pMessage := 'Erro ao tentar criar coleta a partir dos dados da nota.' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_recebimento.fnp_cria_coleta(); ' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return False;            
  End;
  

End FNP_Cria_Coleta;                          



----------------------------------------------------------------------------------------------------------------
--Função utilizada para Validar a NotaFiscal                                                                  -- 
----------------------------------------------------------------------------------------------------------------
Function FNP_Valida_NotaFiscal(pDadosNota  pkg_fifo.tDadosNota,
                               pUsuario    tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                               pAplicacao  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type,
                               pRota       tdvadm.t_glb_rota.glb_rota_codigo%Type) Return pkg_fifo.tRetornoFunc Is 
 --Variável utilizada como retorno da função
 vRetorno            pkg_fifo.tRetornoFunc;
 
 --Variável utilizada para transferir os dados para validação.
 vDadosValidacao  pkg_fifo.tDadosNotaValidacao;
Begin
  --Populo a variável que será utilizada para transferencia de dados.
  vDadosValidacao.NumeroNota  := pDadosNota.nota_numero;
  vDadosValidacao.Nota_serie  := pDadosNota.nota_serie; 
  vDadosValidacao.DtEmissao   := to_char(pDadosNota.nota_dtEmissao, 'dd/mm/yyyy');
  vDadosValidacao.DtSaida     := to_char(pDadosNota.nota_dtSaida, 'dd/mm/yyyy');
  vDadosValidacao.dtEntrada   := pDadosNota.nota_dtEntrada;
  vDadosValidacao.CnpjRemet   := Trim( pDadosNota.Remetente_CNPJ );
  vDadosValidacao.TpEndRemet  := pDadosNota.Remetente_tpCliente;
  vDadosValidacao.CnpjDestino := pDadosNota.Destino_CNPJ;
  vDadosValidacao.TpEndDestino:= pDadosNota.Destino_tpCliente;
  vDadosValidacao.tpSacado    := pDadosNota.nota_flagPgto;
  vDadosValidacao.CnpjSacado  := pDadosNota.Sacado_CNPJ;
  vDadosValidacao.PesoNota    := pDadosNota.nota_pesoNota;
  vDadosValidacao.PesoBalanca := pDadosNota.nota_pesoBalanca;

  If vDadosValidacao.CnpjSacado is null Then
     If vDadosValidacao.tpSacado = 'R' then
        vDadosValidacao.CnpjSacado := Trim( pDadosNota.Remetente_CNPJ );
     ElsIf vDadosValidacao.tpSacado = 'D' then
        vDadosValidacao.CnpjSacado := trim(pDadosNota.Destino_CNPJ); 
     End If;
  End If;
  
  vDadosValidacao.Coleta       := pDadosNota.coleta_Codigo;
  vDadosValidacao.Coleta_Ciclo := pDadosNota.coleta_Ciclo;


  vDadosValidacao.TpColeta    := pDadosNota.coleta_Tipo;
  
  vDadosValidacao.FlagEmp     := pDadosNota.nota_EmpilhamentoFlag;
  vDadosValidacao.QtdeEmp     := pDadosNota.nota_EmpilhamentoQtde;
  vDadosValidacao.Mercadoria  := pDadosNota.mercadoria_codigo;
  vDadosValidacao.VlrMercad   := pDadosNota.nota_ValorMerc;
  vDadosValidacao.QtdeVolume  := pDadosNota.nota_qtdeVolume;
  vDadosValidacao.ChaveNfe    := pDadosNota.nota_chaveNFE;
  vDadosValidacao.Cfop        := pDadosNota.cfop_Codigo;

  Begin
     Select c.slf_contrato_codigo
       into vDadosValidacao.Contrato
     from tdvadm.t_slf_contrato c
     where trim(c.slf_contrato_descricao) = trim(pDadosNota.nota_Contrato);
    
  Exception
    When NO_DATA_FOUND Then
       vDadosValidacao.Contrato    := pDadosNota.nota_Contrato;
    End;
    

  vDadosValidacao.TpRequis    := pDadosNota.nota_RequisTp;
  vDadosValidacao.RequisCod   := pDadosNota.nota_RequisCodigo;
  vDadosValidacao.SaqueRequis := lpad( Trim( pDadosNota.nota_RequisSaque ), 4, '0');
  vDadosValidacao.NotaVide    := pDadosNota.nota_Vide;
  vDadosValidacao.Usuario     := pUsuario;
  vDadosValidacao.Aplicacao   := pAplicacao;
  vDadosValidacao.Rota        := pRota;
  vDadosValidacao.Armazem     := pDadosNota.armazem_Codigo;
  
--  vDadosValidacao.Origem_LocalCodigo    := pDadosNota.
  vDadosValidacao.Remetente_LocalCodigo := pDadosNota.Remetente_LocalCodigo;
  vDadosValidacao.Destino_LocalCodigo   := pDadosNota.Destino_LocalCodigo;
  
   If pDadosNota.carga_Tipo = 'CA' Then   
    vDadosValidacao.TpCarga := 'FF' ;
   Else
     vDadosValidacao.TpCarga :=  pDadosNota.carga_Tipo;
   End If;
   
   vDadosValidacao.nota_tpDocumento := pDadosNota.nota_tpDocumento;

    --Executo a função que vai validar a NotaFisca.
    vRetorno := pkg_fifo_validadoresnota.FN_ValidaNotaFiscal( vDadosValidacao );
 
  
  --Devolve o resultado da função
  Return vRetorno;
End;  

----------------------------------------------------------------------------------------------------------------
-- Função utilizada para gerar um arquivo XML de um Registro de nota.                                         --
----------------------------------------------------------------------------------------------------------------
Function FNP_Xml_getXml( pLinha        integer,
                         pDadosNota    pkg_fifo.tDadosNota
                        ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada para gerar o arquivo XML principal
 vXmlNota   Clob;
 
 --Variável para ser utilizada como retorno da função.
 vRetorno  pkg_fifo.tRetornoFunc;
 

 
 --Variável que vai controlar a linha do Arquivo XML
 vLinha    integer := 0;
Begin
  if nvl(pLinha, 0) <> 0 then
    vLinha := pLinha;
  else
    vLinha := 1;
  end if;

  if pDadosNota.Destino_CNPJ is null then
    vLinha := 0;
  end if;

  Begin
  If vLinha > 0 Then
        vRetorno.Xml := vRetorno.Xml || '<row num=§'               ||  Trim(to_char(vLinha) )                                                         || ' §>';
        vRetorno.Xml := vRetorno.Xml || '<NotaStatus>'             ||  Trim( pDadosNota.NotaStatus )                                                  || '</NotaStatus>'          ;    
        vRetorno.Xml := vRetorno.Xml || '<coleta_Codigo>'          ||  Trim( pDadosNota.coleta_Codigo )                                               || '</coleta_Codigo>'          ;
        vRetorno.Xml := vRetorno.Xml || '<coleta_Tipo>'            ||  Trim( pDadosNota.coleta_Tipo )                                                 || '</coleta_Tipo>'            ;
        vRetorno.Xml := vRetorno.Xml || '<coleta_ocor>'            ||  Trim( pDadosNota.coleta_ocor )                                                 || '</coleta_ocor>'            ;
        vRetorno.Xml := vRetorno.Xml || '<coleta_pedido>'          ||  Trim( pDadosNota.coleta_Pedido )                                               || '</coleta_pedido>'            ;
        vRetorno.Xml := vRetorno.Xml || '<finaliza_digitacao>'     ||  Trim( pDadosNota.finaliza_digitacao )                                          || '</finaliza_digitacao>'     ;
        vRetorno.Xml := vRetorno.Xml || '<nota_tipo>'              ||  Trim( pDadosNota.nota_Tipo )                                                   || '</nota_tipo>'              ;   
        vRetorno.Xml := vRetorno.Xml || '<nota_Sequencia>'         ||  Trim( to_char( pDadosNota.nota_Sequencia ) )                                   || '</nota_Sequencia>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_numero>'            ||  Trim( to_char( pDadosNota.nota_numero ) )                                      || '</nota_numero>'            ;
        vRetorno.Xml := vRetorno.Xml || '<nota_serie>'             ||  Trim( pDadosNota.nota_serie )                                                  || '</nota_serie>'             ;
        vRetorno.Xml := vRetorno.Xml || '<nota_dtEmissao>'         ||  Trim( to_char( pDadosNota.nota_dtEmissao, 'DD/MM/YYYY' ) )                     || '</nota_dtEmissao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_dtSaida>'           ||  Trim( to_char( pDadosNota.nota_dtSaida, 'DD/MM/YYYY' ) )                       || '</nota_dtSaida>'           ;
        vRetorno.Xml := vRetorno.Xml || '<nota_dtEntrada>'         ||  Trim( to_char( pDadosNota.nota_dtEntrada, 'DD/MM/YYYY' ) )                     || '</nota_dtEntrada>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_chaveNFE>'          ||  Trim( pDadosNota.nota_chaveNFE )                                               || '</nota_chaveNFE>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_pesoNota>'          ||  Trim( to_char( pDadosNota.nota_pesoNota ) )                                    || '</nota_pesoNota>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_pesoBalanca>'       ||  Trim( to_char( pDadosNota.nota_pesoBalanca ) )                                 || '</nota_pesoBalanca>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_altura>'            ||  Trim( to_char( pDadosNota.nota_altura ) )                                      || '</nota_altura>'            ;
        vRetorno.Xml := vRetorno.Xml || '<nota_largura>'           ||  Trim( to_char( pDadosNota.nota_largura ) )                                     || '</nota_largura>'           ;
        vRetorno.Xml := vRetorno.Xml || '<nota_comprimento>'       ||  Trim( to_char( pDadosNota.nota_comprimento ) )                                 || '</nota_comprimento>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_cubagem>'           ||  Trim( to_char( pDadosNota.nota_cubagem ) )                                     || '</nota_cubagem>'           ;
        vRetorno.Xml := vRetorno.Xml || '<nota_EmpilhamentoFlag>'  ||  Trim( pDadosNota.nota_EmpilhamentoFlag )                                       || '</nota_EmpilhamentoFlag>'  ;
        vRetorno.Xml := vRetorno.Xml || '<nota_EmpilhamentoQtde>'  ||  Trim( to_char( pDadosNota.nota_EmpilhamentoQtde ) )                            || '</nota_EmpilhamentoQtde>'  ;
        vRetorno.Xml := vRetorno.Xml || '<nota_descricao>'         ||  pkg_fifo_auxiliar.fn_removeAcentos( Trim( pDadosNota.nota_descricao ) )        || '</nota_descricao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_qtdeVolume>'        ||  Trim( to_char( pDadosNota.nota_qtdeVolume ) )                                  || '</nota_qtdeVolume>'        ;
        vRetorno.Xml := vRetorno.Xml || '<nota_ValorMerc>'         ||  Trim( to_char( pDadosNota.nota_ValorMerc ) )                                   || '</nota_ValorMerc>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_RequisTp>'          ||  Trim( pDadosNota.nota_RequisTp )                                               || '</nota_RequisTp>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_RequisCodigo>'      ||  Trim( pDadosNota.nota_RequisCodigo )                                           || '</nota_RequisCodigo>'      ;
        vRetorno.Xml := vRetorno.Xml || '<nota_RequisSaque>'       ||  Trim( pDadosNota.nota_RequisSaque )                                            || '</nota_RequisSaque>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_Contrato>'          ||  Trim( pDadosNota.nota_Contrato )                                               || '</nota_Contrato>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_PO>'                ||  Trim( pDadosNota.nota_PO )                                                     || '</nota_PO>'                ;
        vRetorno.Xml := vRetorno.Xml || '<nota_Di>'                ||  Trim( pDadosNota.nota_Di )                                                     || '</nota_Di>'                ;
        vRetorno.Xml := vRetorno.Xml || '<nota_Vide>'              ||  Trim( pDadosNota.nota_Vide )                                                   || '</nota_Vide>'              ;
        vRetorno.Xml := vRetorno.Xml || '<nota_flagPgto>'          ||  Trim( pDadosNota.nota_flagPgto )                                               || '</nota_flagPgto>'          ;                                    
        vRetorno.Xml := vRetorno.Xml || '<carga_Codigo>'           ||  Trim( to_char( pDadosNota.carga_Codigo ) )                                     || '</carga_Codigo>'           ;
        vRetorno.Xml := vRetorno.Xml || '<carga_Tipo>'             ||  Trim( pDadosNota.carga_Tipo )                                                  || '</carga_Tipo>'             ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Sequencia>'         ||  Trim( to_char( pDadosNota.vide_Sequencia ) )                                   || '</vide_Sequencia>'         ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Numero>'            ||  Trim( to_char( pDadosNota.vide_Numero ) )                                      || '</vide_Numero>'            ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Cnpj>'              ||  Trim( pDadosNota.vide_Cnpj )                                                   || '</vide_Cnpj>'              ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Serie>'             ||  Trim( pDadosNota.vide_Serie )                                                  || '</vide_Serie>'             ;
        vRetorno.Xml := vRetorno.Xml || '<mercadoria_codigo>'      ||  Trim( pDadosNota.mercadoria_codigo )                                           || '</mercadoria_codigo>'      ;
        vRetorno.Xml := vRetorno.Xml || '<mercadoria_descricao>'   ||  pkg_fifo_auxiliar.fn_removeAcentos( Trim( pDadosNota.mercadoria_descricao ))   || '</mercadoria_descricao>'   ;
        vRetorno.Xml := vRetorno.Xml || '<cfop_Codigo>'            ||  Trim( pDadosNota.cfop_Codigo )                                                 || '</cfop_Codigo>'            ;
        vRetorno.Xml := vRetorno.Xml || '<cfop_Descricao>'         ||  pkg_fifo_auxiliar.fn_removeAcentos( Trim( pDadosNota.cfop_Descricao ))         || '</cfop_Descricao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<embalagem_numero>'       ||  Trim( to_char( pDadosNota.embalagem_numero ) )                                 || '</embalagem_numero>'       ;
        vRetorno.Xml := vRetorno.Xml || '<embalagem_flag>'         ||  Trim( pDadosNota.embalagem_flag )                                              || '</embalagem_flag>'         ;
        vRetorno.Xml := vRetorno.Xml || '<embalagem_sequencia>'    ||  Trim( to_char( pDadosNota.embalagem_sequencia ) )                              || '</embalagem_sequencia>'    ;
        vRetorno.Xml := vRetorno.Xml || '<rota_Codigo>'            ||  Trim( pDadosNota.rota_Codigo )                                                 || '</rota_Codigo>'            ;
        vRetorno.Xml := vRetorno.Xml || '<rota_Descricao>'         ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.rota_Descricao ) )        || '</rota_Descricao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<armazem_Codigo>'         ||  Trim( pDadosNota.armazem_Codigo )                                              || '</armazem_Codigo>'         ;
        vRetorno.Xml := vRetorno.Xml || '<armazem_Descricao>'      ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.armazem_Descricao ) )     || '</armazem_Descricao>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_CNPJ>'         ||  Trim( pDadosNota.Remetente_CNPJ )                                              || '</Remetente_CNPJ>'         ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_RSocial>'      ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.Remetente_RSocial ) )     || '</Remetente_RSocial>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_tpCliente>'    ||  Trim( pDadosNota.Remetente_tpCliente )                                         || '</Remetente_tpCliente>'    ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_CodCliente>'   ||  pkg_fifo_auxiliar.fn_removeAcentos( Trim( pDadosNota.Remetente_CodCliente ))   || '</Remetente_CodCliente>'   ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_Endereco>'     ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.Remetente_Endereco ) )    || '</Remetente_Endereco>'     ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_LocalCodigo>'  ||  Trim( pDadosNota.Remetente_LocalCodigo )                                       || '</Remetente_LocalCodigo>'  ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_LocalDesc>'    ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.Remetente_LocalDesc ) )   || '</Remetente_LocalDesc>'    ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_CNPJ>'           ||  Trim( pDadosNota.Destino_CNPJ )                                                || '</Destino_CNPJ>'           ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_RSocial>'        ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.Destino_RSocial ) )       || '</Destino_RSocial>'        ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_tpCliente>'      ||  Trim( pDadosNota.Destino_tpCliente )                                           || '</Destino_tpCliente>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_CodCliente>'     ||  pkg_fifo_auxiliar.fn_removeAcentos( Trim( pDadosNota.Destino_CodCliente ) )    || '</Destino_CodCliente>'     ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_Endereco>'       ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.Destino_Endereco ) )      || '</Destino_Endereco>'       ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_LocalCodigo>'    ||  Trim( pDadosNota.Destino_LocalCodigo )                                         || '</Destino_LocalCodigo>'    ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_LocalDesc>'      ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.Destino_LocalDesc ) )     || '</Destino_LocalDesc>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Sacado_CNPJ>'            ||  Trim( pDadosNota.Sacado_CNPJ )                                                 || '</Sacado_CNPJ>'            ;
        vRetorno.Xml := vRetorno.Xml || '<Sacado_RSocial>'         ||  Trim( pkg_fifo_auxiliar.fn_removeAcentos( pDadosNota.Sacado_RSocial ) )        || '</Sacado_RSocial>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_tpDoc_codigo>'      ||  Trim( pDadosNota.nota_tpDocumento)                                             || '</nota_tpDoc_codigo>'      ;

        vRetorno.Xml := vRetorno.Xml || '<Cte_Original>'           ||  Trim( pDadosNota.Cte_Original)                                                 || '</Cte_Original>'           ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Devolucao>'          ||  Trim( pDadosNota.Cte_Devolucao)                                                || '</Cte_Devolucao>'          ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Reentrega>'          ||  Trim( pDadosNota.Cte_Reentrega)                                                || '</Cte_Reentrega>'          ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Anulador>'           ||  Trim( pDadosNota.Cte_Anulador)                                                 || '</Cte_Anulador>'           ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Substituto>'         ||  Trim( pDadosNota.Cte_Substituto)                                               || '</Cte_Substituto>'         ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_ColCancelada>'       ||  Trim( pDadosNota.Cte_ColCancelada)                                             || '</Cte_ColCancelada>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_qtdelimitada>'      ||  Trim( pDadosNota.nota_qtdelimitada)                                            || '</nota_qtdelimitada>'      ;
        vRetorno.Xml := vRetorno.Xml || '<ctrc_localColeta>'       ||  ''                                                                             || '</ctrc_localColeta>'       ;
    --18/09/2014
    --
        vRetorno.Xml := vRetorno.Xml || '</row>';
    Else
      
        vLinha := 0;

        vRetorno.Xml := vRetorno.Xml || '<row num=§' ||  Trim(to_char(vLinha)) || ' §>';
        vRetorno.Xml := vRetorno.Xml || '<NotaStatus></NotaStatus>'          ;    
        vRetorno.Xml := vRetorno.Xml || '<coleta_Codigo></coleta_Codigo>'          ;
        vRetorno.Xml := vRetorno.Xml || '<coleta_Tipo></coleta_Tipo>'            ;
        vRetorno.Xml := vRetorno.Xml || '<coleta_ocor></coleta_ocor>'            ;
        vRetorno.Xml := vRetorno.Xml || '<coleta_pedido></coleta_pedido>'            ;
        vRetorno.Xml := vRetorno.Xml || '<finaliza_digitacao></finaliza_digitacao>'     ;
        vRetorno.Xml := vRetorno.Xml || '<nota_tipo></nota_tipo>'              ;   
        vRetorno.Xml := vRetorno.Xml || '<nota_Sequencia></nota_Sequencia>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_numero></nota_numero>'            ;
        vRetorno.Xml := vRetorno.Xml || '<nota_serie></nota_serie>'             ;
        vRetorno.Xml := vRetorno.Xml || '<nota_dtEmissao></nota_dtEmissao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_dtSaida></nota_dtSaida>'           ;
        vRetorno.Xml := vRetorno.Xml || '<nota_dtEntrada></nota_dtEntrada>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_chaveNFE></nota_chaveNFE>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_pesoNota></nota_pesoNota>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_pesoBalanca></nota_pesoBalanca>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_altura></nota_altura>'            ;
        vRetorno.Xml := vRetorno.Xml || '<nota_largura></nota_largura>'           ;
        vRetorno.Xml := vRetorno.Xml || '<nota_comprimento></nota_comprimento>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_cubagem></nota_cubagem>'           ;
        vRetorno.Xml := vRetorno.Xml || '<nota_EmpilhamentoFlag></nota_EmpilhamentoFlag>'  ;
        vRetorno.Xml := vRetorno.Xml || '<nota_EmpilhamentoQtde></nota_EmpilhamentoQtde>'  ;
        vRetorno.Xml := vRetorno.Xml || '<nota_descricao></nota_descricao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_qtdeVolume></nota_qtdeVolume>'        ;
        vRetorno.Xml := vRetorno.Xml || '<nota_ValorMerc></nota_ValorMerc>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_RequisTp></nota_RequisTp>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_RequisCodigo></nota_RequisCodigo>'      ;
        vRetorno.Xml := vRetorno.Xml || '<nota_RequisSaque></nota_RequisSaque>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_Contrato></nota_Contrato>'          ;
        vRetorno.Xml := vRetorno.Xml || '<nota_PO></nota_PO>'                ;
        vRetorno.Xml := vRetorno.Xml || '<nota_Di></nota_Di>'                ;
        vRetorno.Xml := vRetorno.Xml || '<nota_Vide></nota_Vide>'              ;
        vRetorno.Xml := vRetorno.Xml || '<nota_flagPgto></nota_flagPgto>'          ;                                    
        vRetorno.Xml := vRetorno.Xml || '<carga_Codigo></carga_Codigo>'           ;
        vRetorno.Xml := vRetorno.Xml || '<carga_Tipo></carga_Tipo>'             ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Sequencia></vide_Sequencia>'         ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Numero></vide_Numero>'            ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Cnpj></vide_Cnpj>'              ;
        vRetorno.Xml := vRetorno.Xml || '<vide_Serie></vide_Serie>'             ;
        vRetorno.Xml := vRetorno.Xml || '<mercadoria_codigo></mercadoria_codigo>'      ;
        vRetorno.Xml := vRetorno.Xml || '<mercadoria_descricao></mercadoria_descricao>'   ;
        vRetorno.Xml := vRetorno.Xml || '<cfop_Codigo></cfop_Codigo>'            ;
        vRetorno.Xml := vRetorno.Xml || '<cfop_Descricao></cfop_Descricao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<embalagem_numero></embalagem_numero>'       ;
        vRetorno.Xml := vRetorno.Xml || '<embalagem_flag></embalagem_flag>'         ;
        vRetorno.Xml := vRetorno.Xml || '<embalagem_sequencia></embalagem_sequencia>'    ;
        vRetorno.Xml := vRetorno.Xml || '<rota_Codigo></rota_Codigo>'            ;
        vRetorno.Xml := vRetorno.Xml || '<rota_Descricao></rota_Descricao>'         ;
        vRetorno.Xml := vRetorno.Xml || '<armazem_Codigo></armazem_Codigo>'         ;
        vRetorno.Xml := vRetorno.Xml || '<armazem_Descricao></armazem_Descricao>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_CNPJ></Remetente_CNPJ>'         ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_RSocial></Remetente_RSocial>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_tpCliente></Remetente_tpCliente>'    ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_CodCliente></Remetente_CodCliente>'   ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_Endereco></Remetente_Endereco>'     ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_LocalCodigo></Remetente_LocalCodigo>'  ;
        vRetorno.Xml := vRetorno.Xml || '<Remetente_LocalDesc></Remetente_LocalDesc>'    ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_CNPJ></Destino_CNPJ>'           ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_RSocial></Destino_RSocial>'        ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_tpCliente></Destino_tpCliente>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_CodCliente></Destino_CodCliente>'     ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_Endereco></Destino_Endereco>'       ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_LocalCodigo></Destino_LocalCodigo>'    ;
        vRetorno.Xml := vRetorno.Xml || '<Destino_LocalDesc></Destino_LocalDesc>'      ;
        vRetorno.Xml := vRetorno.Xml || '<Sacado_CNPJ></Sacado_CNPJ>'            ;
        vRetorno.Xml := vRetorno.Xml || '<Sacado_RSocial></Sacado_RSocial>'         ;
        vRetorno.Xml := vRetorno.Xml || '<nota_tpDoc_codigo></nota_tpDoc_codigo>'         ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Original></Cte_Original>'           ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Devolucao></Cte_Devolucao>'          ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Reentrega></Cte_Reentrega>'          ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Anulador></Cte_Anulador>'           ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_Substituto></Cte_Substituto>'         ;
        vRetorno.Xml := vRetorno.Xml || '<Cte_ColCancelada></Cte_ColCancelada>'       ;
        vRetorno.Xml := vRetorno.Xml || '<nota_qtdelimitada></nota_qtdelimitada>'      ;
        vRetorno.Xml := vRetorno.Xml || '<ctrc_localColeta></ctrc_localColeta>'      ;

        vRetorno.Xml := vRetorno.Xml || '</row>';
      
    End If;    
    --Seto as variáveis para normal, como retorno na função.
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';

  Exception 
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := '';
  End;
  
  --Retorno a variável 
  Return vRetorno;
  
End FNP_Xml_getXml;  

----------------------------------------------------------------------------------------------------------------
--Função privada que retorna um record com os dados de uma nota a partir do Numero de Sequencia               --
----------------------------------------------------------------------------------------------------------------
Function FNP_getDadosNotaSeq( pSequencia    tdvadm.t_arm_nota.arm_nota_sequencia%type ) return pkg_fifo.tDadosNota is

  --Variável utilizada como retorno na função.
  vRetorno   pkg_fifo.tDadosNota;

begin
  begin
    --Utilizo um cursor e laço apenas para facilitar a atribuição de valores para as variáveis 
    --Como vou passar o Codigo de Sequencia, sempre trará apenas uma linha (Primary Key).
    
    -- coloquei para pegar o Local de destino da Carga


    
    for vCursor in ( Select
                      'S'                                      nota_Status,  
                       nota.arm_nota_tipo                      nota_tipo,
                       nota.arm_nota_sequencia                 nota_sequencia,
                       nota.arm_nota_numero                    nota_numero,
                       nota.arm_nota_serie                     nota_serie,
                       nota.arm_movimento_datanfentrada        nota_dtEmissao,
                       nota.arm_nota_dtrecebimento             nota_dtSaida,
                       nota.arm_nota_chavenfe                  nota_chaveNFE,
                       nota.arm_nota_peso                      nota_pesoNota,
                       nota.arm_nota_pesobalanca               nota_pesoBalanca,
                       nota.arm_nota_altura                    nota_altura,
                       nota.arm_nota_largura                   nota_largura,
                       nota.arm_nota_comprimento               nota_comprimento,
                       nota.arm_nota_cubagem                   nota_cubagem,
                       nota.arm_nota_flagemp                   nota_EmpilhamentoFlag,
                       nota.arm_nota_empqtde                   nota_EmpilhamentoQtde,
                       nota.arm_nota_mercadoria                nota_descricao,
                       nota.arm_nota_qtdvolume                 nota_qtdeVolume,
                       nota.arm_nota_valormerc                 nota_ValorMerc,
                       nota.arm_nota_tabsol                    nota_RequisTp,
                       nota.arm_nota_tabsolcod                 nota_RequisCodigo,
                       nota.arm_nota_tabsolsq                  nota_RequisSaque,
                       nota.slf_contrato_codigo                nota_Contrato, 
                       nota.xml_notalinha_numdoc               nota_PO,
                       nota.arm_nota_di                        nota_Di,
                       nota.arm_carga_codigo                   nota_cargaCodigo, 
                       nota.glb_tpcarga_codigo                 nota_cargaTipo,
                       decode(nota.arm_nota_flagpgto, 'A', 'D', 'P', 'R', nota.arm_nota_flagpgto)                   nota_flagPgto,
                       

                       nota.arm_nota_vide                      nota_Vide,
                       vide.arm_nota_sequencia                 vide_Sequencia,
                       vide.arm_nota_numero                    vide_Numero,
                       vide.glb_cliente_cgccpfremetente        vide_Cnpj,
                       vide.arm_nota_serie                     vide_Serie,
                       
                       
                       
                       coleta.arm_coleta_ncompra               coleta_codigo,
                       --coleta.arm_coleta_tpcompra              coleta_tipo,
                       coleta.arm_coleta_entcoleta             coleta_tipo,                       
                       coleta.arm_coletaocor_codigo            coleta_ocor,
                       coleta.arm_coleta_pedido                coleta_pedido,
                       Fn_Get_FinalizaDigNota(coleta.arm_coletaocor_codigo) finaliza_dig,
                       
                       cliRemetente.Glb_Cliente_Cgccpfcodigo   remetente_Cnpj,
                       cliRemetente.Glb_Cliente_Razaosocial    remetente_RSocial,
                       endRemetente.Glb_Tpcliend_Codigo        remetente_tpCliente,
                       endRemetente.Glb_Cliend_Codcliente      remetente_CodCliente,
                       endRemetente.Glb_Cliend_Endereco        remetente_Endereco,
                       
                       remetenteLocal.Glb_Localidade_Codigo    remetente_LocalCod,
                       remetenteLocal.Glb_Localidade_Descricao remetente_LocalDesc,
                       
                       destinoLocal.Glb_Localidade_Codigo      destino_LocalCod,
                       destinoLocal.Glb_Localidade_Descricao   destino_LocalDesc,
                       
                       cliDestino.Glb_Cliente_Cgccpfcodigo     destino_Cnpj,
                       cliDestino.Glb_Cliente_Razaosocial      destino_RSocial,
                       endDestino.Glb_Tpcliend_Codigo          destino_tpCliente,
                       endDestino.Glb_Cliend_Codcliente        destino_CodCliente,
                       endDestino.Glb_Cliend_Endereco          destino_Endereco,
                       
                       cliSacado.Glb_Cliente_Cgccpfcodigo      sacado_Cnpj,
                       cliSacado.Glb_Cliente_Razaosocial       sacado_RSocial,
                       
                       mercadoria.glb_mercadoria_codigo        mercadoria_codigo,
                       mercadoria.glb_mercadoria_descricao     mercadoria_descricao,
                       
                       embalagem.arm_embalagem_numero          embalagem_numero,
                       embalagem.arm_embalagem_flag            embalagem_flag,
                       embalagem.arm_embalagem_sequencia       embalagem_sequencia,
                       
                       armazem.arm_armazem_codigo              armazem_codigo,
                       armazem.arm_armazem_descricao           armazem_descricao,
                       
                       rota.glb_rota_codigo                    rota_codigo,
                       rota.glb_rota_descricao                 rota_descricao,
                       
                       cfop.glb_cfop_codigo                    cfop_codigo,
                       cfop.glb_cfop_descricao                 cfop_descricao,
                       
                      --Função que devolve o tipo de Sacado "0 = Remetente; 1=Destinatario; 2=Outros
                       tdvadm.pkg_fifo_recebimento.fn_defineTpSacado( nota.glb_cliente_cgccpfremetente,
                                                                      nota.glb_cliente_cgccpfdestinatario,
                                                                      nota.glb_cliente_cgccpfsacado
                                                                    ) nota_TpSacado,
                       NOTA.CON_TPDOC_CODIGO                   Nota_tpdocumento       ,
                       nota.arm_coleta_ciclo                   arm_coleta_ciclo,
                       nvl(nota.arm_nota_qtdelimit,'S')        nota_qtdelimitada
                                      

                     from
                       tdvadm.t_arm_nota              nota,
                       tdvadm.t_glb_cfop              cfop,
                       tdvadm.t_glb_mercadoria        mercadoria,
                       tdvadm.t_arm_armazem           armazem,
                       tdvadm.t_arm_embalagem         embalagem,
                       tdvadm.t_glb_rota              rota,
                       tdvadm.t_arm_coleta            coleta,
                       tdvadm.t_glb_cliente           cliRemetente,
                       tdvadm.t_glb_cliend            endRemetente,
                       tdvadm.t_glb_cliente           cliDestino,
                       tdvadm.t_glb_cliend            endDestino,
                       tdvadm.t_glb_cliente           cliSacado,
                       tdvadm.t_glb_localidade        remetenteLocal,
                       tdvadm.t_glb_localidade        destinoLocal,
                       tdvadm.t_arm_notavide          Vide,
                       tdvadm.t_arm_carga             carga
                       
                     where
                       0=0
                       and nota.glb_cfop_codigo    = cfop.glb_cfop_codigo(+)
                       
                       and nota.glb_mercadoria_codigo = mercadoria.glb_mercadoria_codigo (+)
                       
                       and nota.arm_armazem_codigo = armazem.arm_armazem_codigo
                       
                       and nota.arm_embalagem_numero = embalagem.arm_embalagem_numero
                       and nota.arm_embalagem_flag = embalagem.arm_embalagem_flag
                       and nota.arm_embalagem_sequencia = embalagem.arm_embalagem_sequencia
                       
                       and nota.arm_coleta_ncompra  = coleta.arm_coleta_ncompra
                       --Sirlano coloquei o ciclo em 20/12/2018
                       and nota.arm_coleta_ciclo = coleta.arm_coleta_ciclo 
                       
                       and nota.glb_rota_codigo = rota.glb_rota_codigo (+)
                       
                       and Trim( nota.glb_cliente_cgccpfremetente ) = Trim( cliRemetente.Glb_Cliente_Cgccpfcodigo(+))
                       
                       and trim( nota.glb_cliente_cgccpfremetente ) = Trim( endRemetente.Glb_Cliente_Cgccpfcodigo(+) )
                       and nota.glb_tpcliend_codremetente = endRemetente.Glb_Tpcliend_Codigo(+)
                       
                       and trim( nota.glb_cliente_cgccpfdestinatario ) = Trim( cliDestino.Glb_Cliente_Cgccpfcodigo(+) )
                       
                       and trim( nota.glb_cliente_cgccpfdestinatario ) = Trim( endDestino.Glb_Cliente_Cgccpfcodigo(+) )
                       and nota.glb_tpcliend_coddestinatario = endDestino.Glb_Tpcliend_Codigo(+)
                       
                       and trim( nota.glb_cliente_cgccpfsacado) = trim( cliSacado.Glb_Cliente_Cgccpfcodigo(+) )
                       
                       And nota.glb_localidade_codigoorigem = remetenteLocal.Glb_Localidade_Codigo (+)
                       
                       and nota.arm_carga_codigo            = carga.arm_carga_codigo (+)

                       and carga.Glb_Localidade_Codigodestino = destinoLocal.Glb_Localidade_Codigo (+)

                       and nota.arm_nota_numero             = vide.arm_notavide_numero (+)
                       and nota.glb_cliente_cgccpfremetente = vide.arm_notavide_cgccpfremetente (+)
                       and nota.arm_nota_serie              = vide.arm_notavide_serie (+)
                       
                       and nota.arm_nota_sequencia = pSequencia
                   ) 
                   loop

                     --Dados da Nota Fiscal
                     vRetorno.NotaStatus             := vCursor.Nota_Status; 
                     vRetorno.nota_Tipo              := vCursor.Nota_Tipo;
                     vRetorno.nota_Sequencia         := vCursor.Nota_Sequencia;
                     vRetorno.nota_numero            := vCursor.Nota_Numero;
                     vRetorno.nota_serie             := vCursor.Nota_Serie;   
                     vRetorno.nota_dtEmissao         := vCursor.Nota_Dtemissao;
                     vRetorno.nota_dtSaida           := vCursor.Nota_Dtsaida;
                     vRetorno.nota_chaveNFE          := vCursor.Nota_Chavenfe;
                     vRetorno.nota_pesoNota          := vCursor.Nota_Pesonota;
                     vRetorno.nota_pesoBalanca       := vCursor.Nota_Pesobalanca;
                     vRetorno.nota_altura            := vCursor.Nota_Altura;
                     vRetorno.nota_largura           := vCursor.Nota_Largura;
                     vRetorno.nota_comprimento       := vCursor.Nota_Comprimento;
                     vRetorno.nota_cubagem           := vCursor.Nota_Cubagem;
                     vRetorno.nota_EmpilhamentoFlag  := vCursor.Nota_Empilhamentoflag;
                     vRetorno.nota_EmpilhamentoQtde  := vCursor.Nota_Empilhamentoqtde;
                     vRetorno.nota_descricao         := vCursor.Nota_Descricao;
                     vRetorno.nota_qtdeVolume        := vCursor.Nota_Qtdevolume;
                     vRetorno.nota_ValorMerc         := vCursor.Nota_Valormerc;
                     vRetorno.nota_RequisTp          := vCursor.Nota_Requistp;
                     vRetorno.nota_RequisCodigo      := vCursor.Nota_Requiscodigo;
                     vRetorno.nota_RequisSaque       := vCursor.Nota_Requissaque;


                      Begin
                         Select c.slf_contrato_codigo
                           into vRetorno.nota_Contrato
                         from tdvadm.t_slf_contrato c
                         where trim(c.slf_contrato_descricao) = trim(vCursor.nota_Contrato);
                          
                      Exception
                        When NO_DATA_FOUND Then
                           vRetorno.nota_Contrato         := vCursor.nota_Contrato;
                        End;

                     vRetorno.nota_PO                := vCursor.Nota_Po;
                     vRetorno.nota_Di                := vCursor.Nota_Di;
                     vRetorno.carga_Codigo           := vCursor.Nota_Cargacodigo;
                     vRetorno.carga_Tipo             := vCursor.Nota_Cargatipo;
                     vRetorno.nota_Vide              := vCursor.Nota_Vide;
                     vRetorno.vide_Sequencia         := vCursor.Vide_Sequencia;
                     vRetorno.vide_Numero            := vCursor.Vide_Numero;
                     vRetorno.vide_Cnpj              := vCursor.Vide_Cnpj;
                     vRetorno.vide_Serie             := vCursor.Vide_Serie;
                     vRetorno.coleta_Codigo          := vCursor.Coleta_Codigo;
                     vRetorno.coleta_Tipo            := vCursor.Coleta_Tipo;
                     vRetorno.coleta_ocor            := vCursor.Coleta_Ocor;
                     vRetorno.finaliza_digitacao     := vcursor.finaliza_dig;
                     vRetorno.Remetente_CNPJ         := vCursor.Remetente_Cnpj;
                     vRetorno.Remetente_RSocial      := vCursor.Remetente_Rsocial;
                     vRetorno.Remetente_tpCliente    := vCursor.Remetente_Tpcliente;
                     vRetorno.Remetente_CodCliente   := vCursor.Remetente_Codcliente;
                     vRetorno.Remetente_Endereco     := vCursor.Remetente_Endereco;
                     vRetorno.Remetente_LocalCodigo  := vCursor.Remetente_Localcod;
                     vRetorno.Remetente_LocalDesc    := vCursor.Remetente_Localdesc;
                     vRetorno.Destino_CNPJ           := vCursor.Destino_Cnpj;
                     vRetorno.Destino_RSocial        := vCursor.Destino_Rsocial;
                     vRetorno.Destino_tpCliente      := vCursor.Destino_Tpcliente;
                     vRetorno.Destino_CodCliente     := vCursor.Destino_Codcliente;
                     vRetorno.Destino_Endereco       := vCursor.Destino_Endereco;
                     vRetorno.Destino_LocalCodigo    := vCursor.Destino_Localcod;
                     vRetorno.Destino_LocalDesc      := vCursor.Destino_Localdesc;
                     vRetorno.Sacado_CNPJ            := vCursor.Sacado_Cnpj;
                     vRetorno.Sacado_RSocial         := vCursor.Sacado_Rsocial;
                     vRetorno.mercadoria_codigo      := vCursor.Mercadoria_Codigo;
                     vRetorno.mercadoria_descricao   := vCursor.Mercadoria_Descricao;
                     vRetorno.embalagem_numero       := vCursor.Embalagem_Numero;
                     vRetorno.embalagem_flag         := vCursor.Embalagem_Flag;
                     vRetorno.embalagem_sequencia    := vCursor.Embalagem_Sequencia;
                     vRetorno.armazem_Codigo         := vCursor.Armazem_Codigo;
                     vRetorno.armazem_Descricao      := vCursor.Armazem_Descricao;
                     vRetorno.rota_Codigo            := vCursor.Rota_Codigo;
                     vRetorno.rota_Descricao         := vCursor.Rota_Descricao;
                     vRetorno.cfop_Codigo            := vCursor.Cfop_Codigo;
                     vRetorno.cfop_Descricao         := vCursor.Cfop_Descricao;
                     vRetorno.nota_flagPgto          := vCursor.Nota_Flagpgto;
                     vRetorno.nota_tpDocumento       := vCursor.Nota_Tpdocumento;
                     vRetorno.coleta_Ciclo           := vCursor.Arm_Coleta_Ciclo;
                     vRetorno.coleta_Pedido          := vCursor.Coleta_Pedido;
                     vRetorno.nota_qtdelimitada      := vCursor.nota_qtdelimitada;
                     
                     
                     
                     If vCursor.Nota_Vide = 1 Then
                       Select 
                         w.arm_nota_numero,
                         w.arm_nota_serie,
                         w.glb_cliente_cgccpfremetente,
                         w.arm_nota_sequencia
                       Into 
                         vRetorno.vide_Numero,
                         vRetorno.vide_Serie,
                         vRetorno.vide_Cnpj,
                         vRetorno.vide_Sequencia
                         
                         
                       From 
                        t_arm_notavide w
                       Where 
                        w.arm_notavide_sequencia = vCursor.Nota_Sequencia;
                       
                     End If;
                     
                     vRetorno.Cte_Original   := null;
                     vRetorno.Cte_Devolucao  := null;
                     vRetorno.Cte_Reentrega  := null;
                     vRetorno.Cte_Substituto := null;
                     vRetorno.Cte_Anulador   := null;
                     
                     for c_msg in (select nc.arm_notacte_codigo,
                                          nc.con_conhecimento_codigo,
                                          nc.con_conhecimento_serie,
                                          nc.glb_rota_codigo 
                                   from tdvadm.t_arm_notacte nc
                                   where nc.arm_nota_sequencia = vCursor.Nota_Sequencia)
                     Loop
                        If c_msg.arm_notacte_codigo = 'NO' Then
                           vRetorno.Cte_Original := c_msg.con_conhecimento_codigo || c_msg.con_conhecimento_serie || c_msg.glb_rota_codigo;
                        ElsIf c_msg.arm_notacte_codigo = 'DE' Then   
                           vRetorno.Cte_Devolucao := c_msg.con_conhecimento_codigo || c_msg.con_conhecimento_serie || c_msg.glb_rota_codigo;
                        ElsIf c_msg.arm_notacte_codigo = 'RE' Then   
                           vRetorno.Cte_Reentrega := c_msg.con_conhecimento_codigo || c_msg.con_conhecimento_serie || c_msg.glb_rota_codigo;
                        End If;  

                     End Loop;
                     
                     Begin
                        Select x.con_conhecimento_codigo || x.con_conhecimento_serie || x.glb_rota_codigo
                           into vRetorno.Cte_Substituto
                        from tdvadm.t_con_conhecsubstituto x
                        where x.con_conhecsubstituto_codorigem = substr(vRetorno.Cte_Original,1,6)
                          and x.con_conhecsubstituto_srorigem = substr(vRetorno.Cte_Original,7,2)
                          and x.glb_rota_codigoorigem = substr(vRetorno.Cte_Original,9,3);
                     Exception
                       When NO_DATA_FOUND Then
                         vRetorno.Cte_Substituto := null;
                       End;
                       
                     Begin
                        Select x.con_conhecimento_codigo || x.con_conhecimento_serie || x.glb_rota_codigo
                           into vRetorno.Cte_Anulador
                        from tdvadm.t_con_conhecanula x
                        where x.con_conhecimento_codigoorigem = substr(vRetorno.Cte_Original,1,6)
                          and x.con_conhecimento_serieorigem = substr(vRetorno.Cte_Original,7,2)
                          and x.glb_rota_codigoorigem = substr(vRetorno.Cte_Original,9,3);
                     Exception
                       When NO_DATA_FOUND Then
                         vRetorno.Cte_Anulador := null;
                       End;

                    
                   end loop;
    
    --Seto a variável de status para normal para retorno da função.
    vRetorno.Status  := pkg_fifo.Status_Normal;
    vRetorno.Message := '';  
    
  exception
    --Caso ocorra algum erro, seto o status para erro, e mostro a mensagem de erro.
    when others then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar buscar dados de Nota Fiscal.' || chr(13) || dbms_utility.format_call_stack ;
  end;
  
return vREtorno;
  
end;




----------------------------------------------------------------------------------------------------------------
--Função privada que retorna um record com os dados Iniciais a partir de um número de coleta                  --
----------------------------------------------------------------------------------------------------------------
Function FNP_getDadosNotaColeta( pCodColeta  tdvadm.t_arm_coleta.arm_coleta_ncompra%type) return pkg_fifo.tDadosNota is
 --variável utilizada para controlar o retorno da função.
 vRetorno   pkg_fifo.tDadosNota;
 vCount Integer;
begin
  
  begin
    
       Select Count(*)
         Into vCount
         from 
           tdvadm.t_arm_coleta      coleta
           ,tdvadm.t_glb_cliente     cliRemetente
           ,tdvadm.t_glb_cliend      endRemetente
           ,tdvadm.t_glb_localidade  locRemetente                       
         where
           0=0
           and coleta.glb_cliente_cgccpfcodigocoleta = cliRemetente.Glb_Cliente_Cgccpfcodigo
           and coleta.glb_cliente_cgccpfcodigocoleta = endRemetente.Glb_Cliente_Cgccpfcodigo
           and coleta.glb_tpcliend_codigocoleta      = endRemetente.Glb_Tpcliend_Codigo
           and endRemetente.Glb_Localidade_Codigo    = locRemetente.Glb_Localidade_Codigo
           and coleta.arm_coleta_ncompra = pCodColeta
           And coleta.arm_coleta_ciclo = ( Select Max(scol.arm_coleta_ciclo) 
                                           From t_arm_coleta scol
                                           Where  0=0
                                            And scol.arm_coleta_ncompra = coleta.arm_coleta_ncompra
                                         ) ;  
                                         
    if vCount > 0 then                                     
      
        --Crio um cursor e um laço, apenas para facilitar a atribuição de valores para a variável de retorno
        for vCursor in ( Select 
                           'N'                                      nota_Status,
                           --Dados da Coleta "Número e Tipo
                           coleta.arm_coleta_ncompra     Coleta_codigo,
                           coleta.arm_coleta_ciclo       Coleta_ciclo,
                           --coleta.arm_coleta_tpcompra    Coleta_tipo,
                           coleta.arm_coleta_entcoleta    Coleta_tipo,
                           
                           --Dados do Remetente "Cnpj / Razão Social / tipo de Cliente / cod Cliente / Endereço "
                           cliRemetente.Glb_Cliente_Cgccpfcodigo   remetente_Cnpj,
                           cliRemetente.Glb_Cliente_Razaosocial    remetente_Rsocial,
                           endRemetente.Glb_Tpcliend_Codigo        remetente_TpCliente,
                           endRemetente.Glb_Cliend_Codcliente      remetente_CodCliente,
                           endRemetente.Glb_Cliend_Endereco        remetente_Endereco,
                           
                           --Dados do Destino "Cnpj / Razão Social / tipo de Cliente / cod Cliente / Endereço "                       
                           cliDestino.Glb_Cliente_Cgccpfcodigo     destino_Cnpj,
                           cliDestino.Glb_Cliente_Razaosocial      destino_Rsocial,
                           endDestino.Glb_Tpcliend_Codigo          destino_TpCliente,
                           endDestino.Glb_Cliend_Codcliente        destino_CodCliente,
                           endDestino.Glb_Cliend_Endereco          destino_Endereco,  
                           
                           --Dados de Localidade de Rementente "Código e Descrição"
                           locRemetente.Glb_Localidade_Codigo     Remetente_LocalCodigo,
                           locRemetente.Glb_Localidade_Descricao  Remetente_LocalDesc,
                           
                           --Dados de Localidade de Destino  "Código e Descrição"
                           locDestino.Glb_Localidade_Codigo       Destino_LocalCodigo,
                           locDestino.Glb_Localidade_Descricao    Destino_LocalDesc
                         from 
                           tdvadm.t_arm_coleta      coleta,
                           tdvadm.t_glb_cliente     cliRemetente,
                           tdvadm.t_glb_cliend      endRemetente,
                           tdvadm.t_glb_localidade  locRemetente,
                           tdvadm.t_glb_cliente     cliDestino,
                           tdvadm.t_glb_cliend      endDestino,
                           tdvadm.t_glb_localidade  locDestino 
                           
                         where
                           0=0
                           and coleta.glb_cliente_cgccpfcodigocoleta = cliRemetente.Glb_Cliente_Cgccpfcodigo
                           and coleta.glb_cliente_cgccpfcodigocoleta = endRemetente.Glb_Cliente_Cgccpfcodigo
                           and coleta.glb_tpcliend_codigocoleta      = endRemetente.Glb_Tpcliend_Codigo
                           and endRemetente.Glb_Localidade_Codigo   = locRemetente.Glb_Localidade_Codigo
                           
                           and coleta.glb_cliente_cgccpfcodigoentreg = cliDestino.Glb_Cliente_Cgccpfcodigo
                           and coleta.glb_cliente_cgccpfcodigoentreg = endDestino.Glb_Cliente_Cgccpfcodigo
                           and coleta.glb_tpcliend_codigoentrega     = endDestino.Glb_Tpcliend_Codigo
                           and endDestino.Glb_Localidade_Codigo      = locDestino.Glb_Localidade_Codigo

                           and coleta.arm_coleta_ncompra = pCodColeta
                           
                           --Busco o maior ciclo da coleta.
                           And coleta.arm_coleta_ciclo = ( Select Max(scol.arm_coleta_ciclo) 
                                                           From t_arm_coleta scol
                                                           Where  0=0
                                                            And scol.arm_coleta_ncompra = coleta.arm_coleta_ncompra
                                                         )  
                       ) 
                       Loop
                         vRetorno.NotaStatus     := nvl(vCursor.Nota_Status,'N'); 
                         --Dados da Coleta
                         vRetorno.coleta_codigo  := vCursor.Coleta_Codigo;
                         vRetorno.Coleta_ciclo   := vCursor.Coleta_ciclo;
                         vRetorno.coleta_tipo    := vCursor.Coleta_Tipo;
                         
                         --Dados do Remetente
                         vRetorno.Remetente_CNPJ       := vCursor.Remetente_Cnpj;
                         vRetorno.Remetente_RSocial    := vCursor.Remetente_Rsocial;
                         vRetorno.Remetente_tpCliente  := vCursor.Remetente_Tpcliente;
                         vRetorno.Remetente_CodCliente := vCursor.Remetente_Codcliente;
                         vRetorno.Remetente_Endereco   := vCursor.Remetente_Endereco;
                         
                         vRetorno.Remetente_LocalCodigo := vCursor.Remetente_Localcodigo;
                         vRetorno.Remetente_LocalDesc   := vCursor.Remetente_Localdesc;
                         
                         --Dados do Destino
                         vRetorno.Destino_CNPJ       := vCursor.Destino_Cnpj;
                         vRetorno.Destino_RSocial    := vCursor.Destino_Rsocial;
                         vRetorno.Destino_tpCliente  := vCursor.Destino_Tpcliente;
                         vRetorno.Destino_CodCliente := vCursor.Destino_Codcliente;
                         vRetorno.Destino_Endereco   := vCursor.Destino_Endereco;
                         
                         vRetorno.Destino_LocalCodigo := vCursor.Destino_Localcodigo;
                         vRetorno.Destino_LocalDesc   := vCursor.Destino_Localdesc;
                       end loop;
        
        --Atribuo o status normal, para retorno da função.
        vRetorno.Status := pkg_fifo.Status_Normal;
        vRetorno.Message := '';
     else
        vRetorno.Status := pkg_fifo.Status_Erro;
        vRetorno.Message := 'Localidade no Tipo de Endereço do Remetente não encontrada!!!';       
     end if;
  exception 
    --Caso ocorra algum erro, mostra mensagem e seta Status para erro.
    when others then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar buscar dados de Coleta.'|| chr(13) || dbms_utility.format_call_stack; 
  end;
   
  --Retorna a variável.   
  return vRetorno;

End;


-- Função Privada utilizada para recuperar os produtos quimicos de uma nota fiscal
Function FNP_getDadosServAdicionais( pDadosNota    pkg_fifo.tDadosNota ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno da função.
 vRetorno   pkg_fifo.tRetornoFunc;
Begin
  vRetorno.Controle := 0;
  vRetorno.Xml := '';
  vRetorno.Status := '';
  vRetorno.Message := '';
  
  Begin
    --Corro a tabela para pegar os produtos quimicos de uma determinada nota Fiscal.
    For vCursor In ( select r.arm_notaservadd_codigo,
                             sa.arm_notaservadd_descricao,
                             r.arm_notaredespacho_cnpjctrc,
                             r.arm_notaredespacho_tpcliend,
                             r.arm_notaredespacho_ctrc,
                             r.arm_notaredespacho_serie,
                             r.arm_notaredespacho_chavecte,
                             r.arm_notaredespacho_dtemissao
                      from tdvadm.t_arm_notaredespacho r,
                           tdvadm.t_arm_notaservadd sa
                      where r.arm_nota_sequencia = pDadosNota.nota_Sequencia
                        and r.arm_notaservadd_codigo = sa.arm_notaservadd_codigo
                    )
                    Loop
                      --Incremento a variável de controle
                      vRetorno.Controle := vRetorno.Controle + 1;
                      
                      --Monto o arquivo XML propriamente dito.
                      vRetorno.Xml := vRetorno.Xml || '<row>' ;
                      vRetorno.Xml := vRetorno.Xml || '<Sequencia>'                    || vRetorno.Controle                   || '</Sequencia>'  ;
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaservadd_codigo>'       || vCursor.arm_notaservadd_codigo      || '</arm_notaservadd_codigo>'     ;
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaservadd_descricao>'    || vCursor.arm_notaservadd_descricao   || '</arm_notaservadd_descricao>'   ; 
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaredespacho_cnpjctrc>'  || vCursor.arm_notaredespacho_cnpjctrc || '</arm_notaredespacho_cnpjctrc>' ;
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaredespacho_tpcliend>'  || vCursor.arm_notaredespacho_tpcliend || '</arm_notaredespacho_tpcliend>';
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaredespacho_ctrc>'      || vCursor.arm_notaredespacho_ctrc     || '</arm_notaredespacho_ctrc>';
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaredespacho_serie>'     || vCursor.arm_notaredespacho_serie    || '</arm_notaredespacho_serie>';
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaredespacho_chavecte>'  || vCursor.arm_notaredespacho_chavecte || '</arm_notaredespacho_chavecte>';
                      vRetorno.Xml := vRetorno.Xml || '<arm_notaredespacho_dtemissao>' || to_char(vCursor.arm_notaredespacho_dtemissao,'dd/mm/yyyy') || '</arm_notaredespacho_dtemissao>';
                      vRetorno.Xml := vRetorno.Xml || '</row>';
                    End Loop;   
                    
    --Caso a variável controle retorno zerada, quer dizer que o cursor não encontrou nenhum registro,
    --monto um arquivo sem registro para não dar erro na abertura do clientdataset pelo front-end.                
    If vRetorno.Controle = 0 Then 
      vRetorno.Xml := vRetorno.Xml || '<row>'           ;
      vRetorno.Xml := vRetorno.Xml || '<Sequencia />'   ;
      vRetorno.Xml := vRetorno.Xml || '<servad_cod />'      ;
      vRetorno.Xml := vRetorno.Xml || '<servad_desc />'    ;
      vRetorno.Xml := vRetorno.Xml || '<servad_cnpjctrc />'  ;
      vRetorno.Xml := vRetorno.Xml || '<servad_tpcliend />' ;
      vRetorno.Xml := vRetorno.Xml || '<servad_ctrc />' ;
      vRetorno.Xml := vRetorno.Xml || '<servad_serie />' ;
      vRetorno.Xml := vRetorno.Xml || '<servad_chavecte />' ;
      vRetorno.Xml := vRetorno.Xml || '<servad_dtemisao />' ;
      vRetorno.Xml := vRetorno.Xml || '</row>'          ;
    End If;      
    
    --seto as variávei s de retorno para normal, e limpo a variável de mensagem;
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
  Exception
    --Caso ocorra algum erro, seto a variável de retorno para erro, e defino mensagem de erro.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar buscar dados de Servicos Adicionais.';
  End;
  

  --retorno a variável 
  Return vRetorno;
End;  





-- Função Privada utilizada para recuperar os produtos quimicos de uma nota fiscal
Function FNP_getDadosProdQuimicos( pDadosNota    pkg_fifo.tDadosNota ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno da função.
 vRetorno   pkg_fifo.tRetornoFunc;
Begin
  vRetorno.Controle := 0;
  vRetorno.Xml := '';
  vRetorno.Status := '';
  vRetorno.Message := '';
  
  Begin
    --Corro a tabela para pegar os produtos quimicos de uma determinada nota Fiscal.
    For vCursor In ( Select 
                       Distinct
                       to_char( w.glb_onu_codigo)             onu_Codigo,
                       o.glb_onu_produto                      onu_desc,
                       To_char( w.glb_onu_grpemb )            onu_grpEmb,
                       to_char( w.arm_notafichaemerg_uniemb ) onu_qtdeemb,
                       to_char( w.arm_notafichaemerg_peso )   onu_pesoEmb
                     From 
                       tdvadm.t_arm_notafichaemerg w,
                       tdvadm.t_glb_onu            o
                     Where 
                       w.glb_onu_codigo = o.glb_onu_codigo
                       And lpad(w.arm_nota_numero, 9, '0') = lpad(pDadosNota.nota_numero, 9, '0')
                       And w.arm_nota_serie = pDadosNota.nota_serie
                       And Trim(w.glb_cliente_cgccpfremetente) = Trim(pDadosNota.Remetente_CNPJ)
                    )
                    Loop
                      --Incremento a variável de controle
                      vRetorno.Controle := vRetorno.Controle + 1;
                      
                      --Monto o arquivo XML propriamente dito.
                      vRetorno.Xml := vRetorno.Xml || '<row>' ;
                      vRetorno.Xml := vRetorno.Xml || '<Sequencia>'   || vRetorno.Controle   || '</Sequencia>'  ;
                      vRetorno.Xml := vRetorno.Xml || '<codOnu>'      || vCursor.Onu_Codigo  || '</codOnu>'     ;
                      vRetorno.Xml := vRetorno.Xml || '<onu_desc>'    || vCursor.Onu_Desc    || '</onu_desc>'   ; 
                      vRetorno.Xml := vRetorno.Xml || '<onu_grpEmb>'  || vCursor.Onu_Grpemb  || '</onu_grpEmb>' ;
                      vRetorno.Xml := vRetorno.Xml || '<onu_qtdeemb>' || vCursor.Onu_Qtdeemb || '</onu_qtdeemb>';
                      vRetorno.Xml := vRetorno.Xml || '<onu_pesoEmb>' || vCursor.Onu_Pesoemb || '</onu_pesoEmb>';
                      vRetorno.Xml := vRetorno.Xml || '</row>';
                    End Loop;   
                    
    --Caso a variável controle retorno zerada, quer dizer que o cursor não encontrou nenhum registro,
    --monto um arquivo sem registro para não dar erro na abertura do clientdataset pelo front-end.                
    If vRetorno.Controle = 0 Then 
      vRetorno.Xml := vRetorno.Xml || '<row>'           ;
      vRetorno.Xml := vRetorno.Xml || '<Sequencia />'   ;
      vRetorno.Xml := vRetorno.Xml || '<codOnu />'      ;
      vRetorno.Xml := vRetorno.Xml || '<onu_desc />'    ;
      vRetorno.Xml := vRetorno.Xml || '<onu_grpEmb />'  ;
      vRetorno.Xml := vRetorno.Xml || '<onu_qtdeemb />' ;
      vRetorno.Xml := vRetorno.Xml || '<onu_pesoEmb />' ;
      vRetorno.Xml := vRetorno.Xml || '</row>'          ;
    End If;      
    
    --seto as variávei s de retorno para normal, e limpo a variável de mensagem;
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
  Exception
    --Caso ocorra algum erro, seto a variável de retorno para erro, e defino mensagem de erro.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar buscar dados de produtos quimicos.';
  End;
  

  --retorno a variável 
  Return vRetorno;
End;  

-- Função Privada utilizada para recuperar os produtos quimicos de uma nota fiscal
Function FNP_getDadosProdQuimicos2(pSequencia In t_arm_Nota.Arm_Nota_Sequencia%Type ) Return Clob 
Is
 --Variável utilizada como retorno da função.
 vXml Clob;
 vSeqQuim Integer;
Begin  
    --Corro a tabela para pegar os produtos quimicos de uma determinada nota Fiscal.
    vSeqQuim := 0;
    For nf_prod_quim In ( Select 
                             Distinct
                             to_char( w.glb_onu_codigo)             onu_Codigo,
                             o.glb_onu_produto                      onu_desc,
                             To_char( w.glb_onu_grpemb )            onu_grpEmb,
                             to_char( w.arm_notafichaemerg_uniemb ) onu_qtdeemb,
                             to_char( w.arm_notafichaemerg_peso )   onu_pesoEmb
                           From 
                              tdvadm.t_arm_notafichaemerg w,
                              tdvadm.t_glb_onu            o
                           Where w.glb_onu_codigo = o.glb_onu_codigo
                             --And lpad(w.arm_nota_numero, 9, '0') = lpad(pDadosNota.nota_numero, 9, '0')
                             --And w.arm_nota_serie = pDadosNota.nota_serie
                             --And Trim(w.glb_cliente_cgccpfremetente) = Trim(pDadosNota.Remetente_CNPJ)
                             And w.arm_nota_sequencia = pSequencia
                    )
                    Loop
                      --Incremento a variável de controle
                      vSeqQuim := vSeqQuim + 1;
                      
                      --Monto o arquivo XML propriamente dito.
                      vXml := vXml || '<row>' ;
                      vXml := vXml || '<Sequencia>'   || vSeqQuim            || '</Sequencia>'  ;
                      vXml := vXml || '<codOnu>'      || nf_prod_quim.Onu_Codigo  || '</codOnu>'     ;
                      vXml := vXml || '<onu_desc>'    || nf_prod_quim.Onu_Desc    || '</onu_desc>'   ; 
                      vXml := vXml || '<onu_grpEmb>'  || nf_prod_quim.Onu_Grpemb  || '</onu_grpEmb>' ;
                      vXml := vXml || '<onu_qtdeemb>' || nf_prod_quim.Onu_Qtdeemb || '</onu_qtdeemb>';
                      vXml := vXml || '<onu_pesoEmb>' || nf_prod_quim.Onu_Pesoemb || '</onu_pesoEmb>';
                      vXml := vXml || '</row>';
                    End Loop;   
                    
    --Caso a variável controle retorno zerada, quer dizer que o cursor não encontrou nenhum registro,
    --monto um arquivo sem registro para não dar erro na abertura do clientdataset pelo front-end.                
    If vSeqQuim = 0 Then 
      vXml := vXml || '<row>'           ;
      vXml := vXml || '<Sequencia />'   ;
      vXml := vXml || '<codOnu />'      ;
      vXml := vXml || '<onu_desc />'    ;
      vXml := vXml || '<onu_grpEmb />'  ;
      vXml := vXml || '<onu_qtdeemb />' ;
      vXml := vXml || '<onu_pesoEmb />' ;
      vXml := vXml || '</row>'          ;
    End If;      

  Return vXml;
End;  

----------------------------------------------------------------------------------------------------------------
--Função utilizada para buscar os tipos de documentos e o documento default.
----------------------------------------------------------------------------------------------------------------
Function FNP_getXML_TpDocumentos( pAutorizacao   Char,
                                  pDocDefault    tdvadm.t_con_tpdoc.con_tpdoc_codigo%Type,
                                  pRota          tdvadm.t_con_tpdoc.glb_rota_codigo%type
                                 ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno da função.
 vRetorno  pkg_fifo.tRetornoFunc;
 
 --Variável utilizada como ponteiro para o documento default.
 vDocDefault   t_con_tpdoc.con_tpdoc_codigo%Type:= '';
Begin
  --Limpa as variáveis que serão utilizadas na função.
  vRetorno.Controle := 0;
  vRetorno.Xml := empty_clob();
  vRetorno.Status := '';
  vRetorno.Message := '';
  
  Begin
    --Variável utilizada para receber o código default.
    vDocDefault :=  Trim(  nvl( Trim(pDocDefault), '55') );
    
    --corre o cursor, para listar todos os código que serão enviados para o FrontEnd.
    For vCursor In ( Select 
                       w.con_tpdoc_codigo,
                       w.con_tpdoc_descricao
                     From 
                       tdvadm.t_con_tpdoc w
                     Where 
                      0=0 
                      And w.glb_rota_codigo in ('999',nvl(pRota,'999'))
                      And case 
                            when Trim(NVL(pAutorizacao,'N')) =  'N' and w.con_tpdoc_codigo = vDocDefault then 1
                            when Trim(NVL(pAutorizacao,'N')) <> 'N' and 0=0 then 1  
                           END =1
                      and w.con_tpdoc_ativo = 'S'
                      and w.con_tpdoc_vigencia = (select max(w1.con_tpdoc_vigencia)     
                                                  from tdvadm.t_con_tpdoc w1
                                                  where w1.con_tpdoc_codigo = w.con_tpdoc_codigo
                                                    and w1.con_tpdoc_ativo = 'S'
                                                    and w1.con_tpdoc_sefazpref = w.con_tpdoc_sefazpref
                                                    and w1.glb_rota_codigo in ('999',nvl(pRota,'999')))

--                      And Case pAutorizacao
  --                      When 'N' Then w.con_tpdoc_codigo = vDocDefault
                        
                     Order By w.con_tpdoc_codigo
                    ) 
                    Loop
                      vRetorno.Controle := vRetorno.Controle +1;
                      vRetorno.Xml := vRetorno.Xml || '<row num=§'            || to_char(vRetorno.Controle)  || '§ > ';
                      vRetorno.Xml := vRetorno.Xml || '<con_tpdoc_codigo>'    || vCursor.Con_Tpdoc_Codigo    || '</con_tpdoc_codigo>';
                      vRetorno.Xml := vRetorno.Xml || '<Con_Tpdoc_Descricao>' || vCursor.Con_Tpdoc_Descricao || '</Con_Tpdoc_Descricao>'; 
                      vRetorno.Xml := vRetorno.Xml || '<doc_default>'         || Trim( vDocDefault )         || '</doc_default>';
                      vRetorno.Xml := vRetorno.Xml || '</row>';
                    End Loop;

    --Caso o cursor não encontre nada, preciso enviar um xml vazio para o FrontEnd.
    If vRetorno.Controle = 0 Then
      vRetorno.Xml := vRetorno.Xml || '<row num=§0§> ';
      vRetorno.Xml := vRetorno.Xml || '<con_tpdoc_codigo />'    ;
      vRetorno.Xml := vRetorno.Xml || '<Con_Tpdoc_Descricao />' ;
      vRetorno.Xml := vRetorno.Xml || '<doc_default />'         ;
      vRetorno.Xml := vRetorno.Xml || '</row>';
    End If;
    
                   
  Exception
    --Caso ocorra qualquer erro não esperado. Encerro o processamento, e devolvo mensagem explicativa.
    When Others Then
      vRetorno.Status  :=  pkg_glb_common.Status_Erro;
      vRetorno.Message := 'Erro ao buscar os Tipos de Documentos.' || chr(13) ||
                           Sqlerrm                                 || chr(13) ||
                           dbms_utility.format_call_stack;
      Return vRetorno;                     
  End;
  
  --Popula as variáveis de retorno
  vRetorno.Status := pkg_glb_common.Status_Nomal;
  vRetorno.Message := '';
  
  --Retorna a variável preenchida
  Return vRetorno;
  
  
End;  


----------------------------------------------------------------------------------------------------------------
-- Função Privada que recebe um Arquivo XML e devolve um RECORD (tDadosNota) preenchido                       --
----------------------------------------------------------------------------------------------------------------
Function FNP_getDadosNotaXml(pXmlEntrada Varchar2) Return tdvadm.pkg_fifo.tDadosNota Is
 --Variáve que será utilizada no retorno da função.
 vRetorno      pkg_fifo.tDadosNota;
 vColetaCiclo  t_arm_coleta.arm_coleta_ciclo%type;
Begin
  Begin
    
  --insert into tdvadm.dropme (a, l) values('DANIELFNP_getDadosNotaXml', pXmlEntrada);COMMIT;
  --commit;
--Dento do XML, deve ter apenas uma linha, mas mesmo assim resolvi criar um cursor e laço
--apenas para facilitar a atribuição de valores para as variáveis.
  For vCursor In ( Select 
                     extractvalue(value(field), 'Table/Rowset/Row/notaStatus')                 notaStatus,
                     extractvalue(value(field), 'Table/Rowset/Row/coleta_Codigo')              coleta_Codigo, 
                     extractvalue(value(field), 'Table/Rowset/Row/coleta_Tipo')                coleta_Tipo, 
                     extractvalue(value(field), 'Table/Rowset/Row/coleta_pedido')                coleta_pedido, 
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Sequencia')             nota_sequencia, 
                     extractvalue(value(field), 'Table/Rowset/Row/nota_numero')                nota_numero,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_serie')                 nota_serie,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtEmissao')             nota_dtEmissao,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtSaida')               nota_dtSaida,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtEntrada')             nota_dtEntrada,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_chaveNFE')              nota_chaveNFE,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_pesoNota')              nota_pesoNota,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_pesoBalanca')           nota_pesoBalanca,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_altura')                nota_altura,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_largura')               nota_largura,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_comprimento')           nota_comprimento,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_cubagem')               nota_cubagem,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_EmpilhamentoFlag')      nota_EmpilhamentoFlag,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_EmpilhamentoQtde')      nota_EmpilhamentoQtde,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_descricao')             nota_descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_qtdeVolume')            nota_qtdeVolume,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_ValorMerc')             nota_ValorMerc,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisTp')              nota_RequisTp,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisCodigo')          nota_RequisCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisSaque')           nota_RequisSaque,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Contrato')              nota_Contrato,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_PO')                    nota_PO,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Di')                    nota_Di,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Vide')                  nota_Vide,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_flagPgto')              nota_flagPgto,
                     extractvalue(value(field), 'Table/Rowset/Row/carga_Codigo')               carga_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/carga_Tipo')                 carga_Tipo,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Sequencia')             vide_Sequencia,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Numero')                vide_Numero,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Cnpj')                  vide_Cnpj,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Serie')                 vide_Serie,
                     extractvalue(value(field), 'Table/Rowset/Row/mercadoria_codigo')          mercadoria_codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/mercadoria_descricao')       mercadoria_descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/cfop_Codigo')                cfop_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/cfop_Descricao')             cfop_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/embalagem_numero')           embalagem_numero,
                     extractvalue(value(field), 'Table/Rowset/Row/embalagem_flag')             embalagem_flag,
                     extractvalue(value(field), 'Table/Rowset/Row/embalagem_sequencia')        embalagem_sequencia,
                     extractvalue(value(field), 'Table/Rowset/Row/rota_Codigo')                rota_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/rota_Descricao')             rota_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/armazem_Codigo')             armazem_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/armazem_Descricao')          armazem_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_CNPJ')             Remetente_CNPJ,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_RSocial')          Remetente_RSocial,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_tpCliente')        Remetente_tpCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_CodCliente')       Remetente_CodCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_Endereco')         Remetente_Endereco,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_LocalCodigo')      Remetente_LocalCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_LocalDesc')        Remetente_LocalDesc,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_CNPJ')               Destino_CNPJ,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_RSocial')            Destino_RSocial, 
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_tpCliente')          Destino_tpCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_CodCliente')         Destino_CodCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_Endereco')           Destino_Endereco,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_LocalCodigo')        Destino_LocalCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_LocalDesc')          Destino_LocalDesc,
                     extractvalue(value(field), 'Table/Rowset/Row/Sacado_CNPJ')                Sacado_CNPJ,
                     extractvalue(value(field), 'Table/Rowset/Row/Sacado_RSocial')             Sacado_RSocial,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_tpDoc_codigo')          tpDoc_codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_qtdelimitada')          nota_qtdelimitada
                   From 
                     Table(xmlsequence( Extract(xmltype.createXml(pXmlEntrada) , '/Parametros/Inputs/Input/Tables/Table'))) field
                   Where 
                     Trim( extractvalue(value(field), 'Table/@name') ) = 'dadosNota'
                  ) Loop

                      vRetorno.NotaStatus            := nvl(vCursor.Notastatus,'N');
                      vRetorno.coleta_Codigo         := vCursor.coleta_Codigo; 
                      vRetorno.coleta_Tipo           := vCursor.Coleta_Tipo;
                      vRetorno.Coleta_pedido         := vCursor.Coleta_pedido;
                      vRetorno.nota_Sequencia        := vCursor.nota_sequencia; 
                      vRetorno.nota_numero           := vCursor.nota_numero;
                      vRetorno.nota_serie            := vCursor.nota_serie;
                      vRetorno.nota_dtEmissao        := vCursor.nota_dtEmissao;
                      vRetorno.nota_dtSaida          := vCursor.nota_dtSaida;
                      vRetorno.nota_dtEntrada        := vCursor.nota_dtEntrada;
                      vRetorno.nota_chaveNFE         := Trim( vCursor.nota_chaveNFE ) ;
                      vRetorno.nota_pesoNota         := vCursor.nota_pesoNota;
                      vRetorno.nota_pesoBalanca      := vCursor.nota_pesoBalanca;
                      vRetorno.nota_altura           := vCursor.nota_altura;
                      vRetorno.nota_largura          := vCursor.nota_largura;
                      vRetorno.nota_comprimento      := vCursor.nota_comprimento;
                      vRetorno.nota_cubagem          := vCursor.nota_cubagem;
                      vRetorno.nota_EmpilhamentoFlag := vCursor.nota_EmpilhamentoFlag;
                      vRetorno.nota_EmpilhamentoQtde := vCursor.nota_EmpilhamentoQtde;
                      vRetorno.nota_descricao        := vCursor.nota_descricao;
                      vRetorno.nota_qtdeVolume       := vCursor.nota_qtdeVolume;
                      vRetorno.nota_ValorMerc        := vCursor.nota_ValorMerc;
                      vRetorno.nota_RequisTp         := vCursor.nota_RequisTp;
                      vRetorno.nota_RequisCodigo     := vCursor.nota_RequisCodigo;
                      vRetorno.nota_RequisSaque      := vCursor.nota_RequisSaque;

                      Begin
                         Select c.slf_contrato_codigo
                           into vRetorno.nota_Contrato
                         from tdvadm.t_slf_contrato c
                         where trim(c.slf_contrato_descricao) = trim(vCursor.nota_Contrato);
                          
                      Exception
                        When NO_DATA_FOUND Then
                           vRetorno.nota_Contrato         := vCursor.nota_Contrato;
                        End;


                      
                      vRetorno.nota_PO               := vCursor.nota_PO;
                      vRetorno.nota_Di               := vCursor.nota_Di;
                      vRetorno.nota_Vide             := vCursor.nota_Vide;
                      vRetorno.nota_flagPgto         := vCursor.nota_flagPgto;
                      vRetorno.carga_Codigo          := vCursor.carga_Codigo;
                      vRetorno.carga_Tipo            := vCursor.carga_Tipo;
                      vRetorno.vide_Sequencia        := vCursor.vide_Sequencia;
                      vRetorno.vide_Numero           := vCursor.vide_Numero;
                      vRetorno.vide_Cnpj             := vCursor.vide_Cnpj;
                      vRetorno.vide_Serie            := vCursor.vide_Serie;
                      vRetorno.mercadoria_codigo     := vCursor.mercadoria_codigo;
                      vRetorno.mercadoria_descricao  := vCursor.mercadoria_descricao;
                      vRetorno.cfop_Codigo           := vCursor.cfop_Codigo;
                      vRetorno.cfop_Descricao        := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.cfop_Descricao );
                      vRetorno.embalagem_numero      := vCursor.embalagem_numero;
                      vRetorno.embalagem_flag        := vCursor.embalagem_flag;
                      vRetorno.embalagem_sequencia   := vCursor.embalagem_sequencia;
                      vRetorno.rota_Codigo           := vCursor.rota_Codigo;
                      vRetorno.rota_Descricao        := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.rota_Descricao );
                      vRetorno.armazem_Codigo        := vCursor.armazem_Codigo;
                      vRetorno.armazem_Descricao     := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.armazem_Descricao );
                      vRetorno.Remetente_CNPJ        := vCursor.Remetente_CNPJ;
                      vRetorno.Remetente_RSocial     := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.Remetente_RSocial );
                      vRetorno.Remetente_tpCliente   := Trim( vCursor.Remetente_tpCliente);
                      vRetorno.Remetente_CodCliente  := Trim( vCursor.Remetente_CodCliente);
                      vRetorno.Remetente_Endereco    := substr(pkg_fifo_auxiliar.fn_removeAcentos( Trim(vCursor.Remetente_Endereco) ),1,50);
                      vRetorno.Remetente_LocalCodigo := vCursor.Remetente_LocalCodigo;
                      vRetorno.Remetente_LocalDesc   := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.Remetente_LocalDesc );
                      vRetorno.Destino_CNPJ          := vCursor.Destino_CNPJ;
                      vRetorno.Destino_RSocial       := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.Destino_RSocial );
                      vRetorno.Destino_tpCliente     := Trim( vCursor.Destino_tpCliente);
                      vRetorno.Destino_CodCliente    := Trim( vCursor.Destino_CodCliente);
                      vRetorno.Destino_Endereco      :=  substr(Trim( pkg_glb_common.FN_LIMPA_CAMPO( vCursor.Destino_Endereco) ), 01, 50);
                      vRetorno.Destino_LocalCodigo   := vCursor.Destino_LocalCodigo;
                      vRetorno.Destino_LocalDesc     := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.Destino_LocalDesc );
                      vRetorno.Sacado_CNPJ           := vCursor.Sacado_CNPJ;
                      vRetorno.Sacado_RSocial        := pkg_fifo_auxiliar.fn_removeAcentos( vCursor.Sacado_RSocial );
                      vRetorno.nota_tpDocumento      := vCursor.Tpdoc_Codigo;
                      vRetorno.nota_qtdelimitada     := vCursor.nota_qtdelimitada;
                      
                      --Busco o maior ciclo utilizada por uma coleta desse número.
                      Select Max(col.arm_coleta_ciclo) 
                        Into vColetaCiclo
                        From t_arm_coleta col
                       Where col.arm_coleta_ncompra = vCursor.Coleta_Codigo; 
                       
                      vRetorno.coleta_Ciclo := vColetaCiclo;
                      
                    End Loop;   
      
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';  

  Exception
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := substr('Erro ao tentar extrair valores do XML enviado pela Aplicação ' || CHR(13) ||
                           SQLERRM                                                        || CHR(13) ||
                           dbms_utility.format_call_stack,1,3999);
      
   End;    
      
  Return vRetorno;

End FNP_getDadosNotaXml;

----------------------------------------------------------------------------------------------------------------
--Função utilizada para Excluir uma Nota Fiscal                                                               --
----------------------------------------------------------------------------------------------------------------
Function FNP_Del_NotaFiscal( pArm_nota_numero In tdvadm.t_arm_nota.arm_nota_numero%Type,
                             pGlb_cliente_cgccpfremetente In tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%Type,
                             pArm_nota_serie In tdvadm.t_arm_nota.arm_nota_serie%Type,
                             pPermXml In Char,
                             pMessage Out Varchar2,
                             pSequencia In Integer
                           ) Return Boolean Is
 --Variável de controle
 vControlErro Integer;
 
 --Variável utilizada para Criar / recuperar mensagem
 vStatus  char(1);
 vMessage Varchar2(10000);
 
 --Dados da nota
 vArm_movimento_datanfentrada tdvadm.t_arm_nota.arm_movimento_datanfentrada%Type;
 vChaveJanela  tdvadm.t_arm_nota.arm_janelacons_sequencia%type;
 
 --Dados da Embalagem
 vArm_embalagem_numero tdvadm.t_arm_embalagem.arm_embalagem_numero%Type;
 vArm_embalagem_flag tdvadm.t_arm_embalagem.arm_embalagem_flag%Type;
 vArm_embalagem_sequencia tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type;
 
 --Dados da carga
 vArm_carga_codigo tdvadm.t_arm_carga.arm_carga_codigo%Type;
 
 --Variáveis de controle
 vCarregamento Integer;
 vNotaXml Integer;
 vFichaEmergencia Integer;
 vVideNota Integer;
 vNotaRedesp Integer;
 vSequenciaNota Integer;
 vDetalhes Varchar2(2000);
 vContaCteJanela number;
 vDtFinalJanela date;
 vGrupoJanela   tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
 --Variaveis de Coleta
 vColetaNumero t_arm_coleta.arm_coleta_ncompra%type;
 vColetaCiclo  t_arm_coleta.arm_coleta_ciclo%type;
 vDtInicioJAN  date;
 vDtFimJAN     date;
 vArmazem      tdvadm.t_arm_armazem.arm_armazem_codigo%type;
 vContaASN     number;
 vID_Prescarga tdvadm.t_arm_presencarga.arm_presencarga_id%type;
 vAuxiliar     number;
 vContador     number;
Begin
  --inicializa as variáeis utilizadas nessa função
  vControlErro := 0;
  vMessage := '';
  vCarregamento := 0;
  vNotaXml := 0;
  vFichaEmergencia := 0;
  vVideNota := 0;
  vNotaRedesp := 0;

  If pArm_nota_numero = 590741 Then
     raise_application_error(-20001,'PASSEI AQUI');
  end IF;

  
  Begin
    --Recupero os dados da nota fiscal
    Select 
      nota.arm_movimento_datanfentrada,
      nota.arm_embalagem_numero,
      nota.arm_embalagem_flag,
      nota.arm_embalagem_sequencia,
      nota.arm_carga_codigo,
      nota.arm_nota_sequencia,
      0 NotaXml,
      (  Select Count(*) From t_arm_carregamentodet det
         Where det.arm_embalagem_numero = nota.arm_embalagem_numero
           And det.arm_embalagem_flag = nota.arm_embalagem_flag
           And det.arm_embalagem_sequencia = nota.arm_embalagem_sequencia
      ) carregamento,
      ( Select Count(*) From t_arm_notafichaemerg fe
        Where fe.arm_nota_numero = nota.arm_nota_numero
          And fe.arm_nota_serie = nota.arm_nota_serie
          And fe.glb_cliente_cgccpfremetente = nota.glb_cliente_cgccpfremetente
      ) FichaEmerg,
      ( Select Count(*) From t_arm_notavide vide
        --Where  vide.arm_notavide_numero = nota.arm_nota_numero
        --  And vide.arm_notavide_cgccpfremetente = nota.glb_cliente_cgccpfremetente
        --  And vide.arm_notavide_serie = nota.arm_nota_serie
        Where vide.arm_nota_sequencia = nota.arm_nota_sequencia
      ) VideNota,
      
      ( Select Count(*) From t_arm_notaredespacho red
        Where red.arm_nota_numero = nota.arm_nota_numero
          And red.glb_cliente_cgccpfremetente =nota.glb_cliente_cgccpfremetente
          And red.arm_nota_serie = nota.arm_nota_serie 
      ) NotaRed,
      nota.arm_coleta_ncompra,
      nota.arm_coleta_ciclo,
      nota.arm_janelacons_sequencia,
      nota.arm_armazem_codigo
    Into 
      vArm_movimento_datanfentrada,
      vArm_embalagem_numero,
      vArm_embalagem_flag,
      vArm_embalagem_sequencia,
      vArm_carga_codigo,
      vSequenciaNota,
      vNotaXml,
      vCarregamento,
      vFichaEmergencia,
      vVideNota,
      vNotaRedesp,
      vColetaNumero,
      vColetaCiclo,
      vChaveJanela,
      vArmazem
    From 
       tdvadm.t_arm_nota nota

    Where
      0=0
      And nota.arm_nota_numero = pArm_nota_numero
      And nota.glb_cliente_cgccpfremetente = Trim(pGlb_cliente_cgccpfremetente)
      And Trim(nota.arm_nota_serie) = Trim(pArm_nota_serie)
      And nota.arm_nota_sequencia = pSequencia;
  
    /***************************************************************************************************/
    /*                         VALIDAÇÃO ANTES DA EXCLUSÃO DA NOTA                                     */ 
    /***************************************************************************************************/                       
    --Caso tenha algum carregamento
    If ( vCarregamento > 0 ) Then       
      --Lanço a exceção.
      vControlErro := vControlErro + 1;
      vMessage := vMessage || lpad(vControlErro, 2, '0') || ' - Nota Fiscal já está em um carregamento.' || chr(10);
    End If;

    -- Conta se Ja FOi impresso algum CTe/NFSe da Janela

    If vChaveJanela is not null Then

        select count(*)
          into vContaCteJanela
        from t_arm_nota an
        where an.arm_janelacons_sequencia = vChaveJanela
          and an.con_conhecimento_codigo is not null;
          
          
       
        If ( vContaCteJanela > 0 ) Then       
          --Lanço a exceção.
          vControlErro := vControlErro + 1;
          vMessage := vMessage || lpad(vControlErro, 2, '0') || ' - Janela Ja Possui CTe Emitido.' || chr(10);
        End If;
        
       select count(*)
         into vContaASN
       from t_xml_coleta x
       where x.arm_coleta_ncompra = vColetaNumero
         and x.arm_coleta_ciclo = vColetaCiclo;
       If vContaASN = 0 Then  
          -- Se não achar ASN deixa excluir
          vContaASN := vContaASN;
       
       Else
       
           
            
           Select jc.arm_janelacons_dtfim,
                  jc.glb_grupoeconomico_codigo
             into vDtFinalJanela,
                  vGrupoJanela
           from t_arm_janelacons jc
           where jc.arm_janelacons_sequencia = vChaveJanela;
     
           If ( to_char(vDtFinalJanela,'DD') < to_char(sysdate,'DD') ) and ( vGrupoJanela = '0020' )/* and ( vArmazem = '07')*/ Then
             vControlErro := vControlErro + 1;
             vMessage := vMessage || lpad(vControlErro, 2, '0') || ' - Pertence a Janela De Dias Anteirores, não pode Ser Excluida. Final Janela - ' || to_char(vDtFinalJanela,'dd/mm/yyyy hh24:mi:ss') || chr(10);
           End If;

           If ( vGrupoJanela = '0020' ) Then
             vControlErro := vControlErro + 1;
             vMessage := vMessage || lpad(vControlErro, 2, '0') || ' - Pertence a Uma Janela, não pode Ser Excluida. Final Janela - ' || to_char(vDtFinalJanela,'dd/mm/yyyy hh24:mi:ss') || chr(10);
           End If;
       End If;
       
          select count (*)
           into vContador
           from tdvadm.t_arm_palletnota np   
          where np.arm_nota_sequencia = pSequencia;
          
     ---------------------------------------------
     ----------------Rafael Aiti------------------
     ---Verifico se nota está em etiqueta única---
     ------------------18/11/2019-----------------
     ---------------------------------------------
          
          if (vContador > 0) then
            vControlErro := vControlErro + 1;
            vMessage := vMessage || lpad(vControlErro, 2, '0') || 'Nota fiscal está em etiqueta única e não pode ser excluida' || chr(10);
          end if;
       
    End If; 
    --Caso tenha encontrado algum erro
    If ( vControlErro > 0 ) Then
      --Monto mensagem de retorno e lanço a exceção.
      vMessage := '*****************************************************************' || chr(10) ||
                  'NOTA FISCAL NÃO PODE SER EXCLUÍDA'                                 || chr(10) ||
                  'Abaixo lista de motivos motivos: '                                 || chr(10) || 
                  ''                                                                  || chr(10) ||
                  vMessage                                                            || chr(10) ||
                  '*****************************************************************';
      Raise vEx_ExecFunction; 
    End If;
    
    /***************************************************************************************************/
    /*                      PROCESSO DE EXCLUSÃO DA NOTA E SUAS DEPENDENCIAS                           */
    /***************************************************************************************************/                       
   --Verifica se a nota veio do XML
    If ( vNotaXml > 0 ) Then
      UPDATE T_XML_NOTA NT
        SET NT.XML_NOTA_STATUS                     = 'OK'
      WHERE NT.XML_NOTA_NF                         = pArm_nota_numero
        AND Trunc(NT.XML_NOTA_EMISSAO)             = Trunc(vArm_movimento_datanfentrada)
        AND Trim(NT.GLB_CLIENTE_CGCCPFREMETENTE)   = Trim(pGlb_cliente_cgccpfremetente)
        AND NT.XML_NOTA_NOTA                       = 'S'
        AND NT.XML_NOTA_STATUS                     = 'NO';
    End If;


    --Deleta Vide nota
    If ( vVideNota > 0 ) Then
      Delete  t_arm_notavide vide
      --Where  vide.arm_notavide_numero = pArm_nota_numero
      --   And vide.arm_notavide_cgccpfremetente = Trim(pGlb_cliente_cgccpfremetente)
      --   And Trim(vide.arm_notavide_serie) = Trim(pArm_nota_serie);
      where vide.arm_nota_sequencia = vSequenciaNota;
    End If;
    
    --deleta Ficha de Emergencia
    If ( vFichaEmergencia > 0 ) Then
      Delete t_arm_notafichaemerg fe
      Where fe.arm_nota_numero = pArm_nota_numero
        And fe.glb_cliente_cgccpfremetente = Trim(pGlb_cliente_cgccpfremetente)
        And Trim(fe.arm_nota_serie) = Trim(pArm_nota_serie);
    End If;
    
    --Deleta nota de redespacho
    If ( vNotaRedesp > 0 ) Then
      Delete t_arm_notaredespacho redsp
      Where redsp.arm_nota_numero = pArm_nota_numero
       And redsp.glb_cliente_cgccpfremetente = Trim(pGlb_cliente_cgccpfremetente)
       And Trim(redsp.arm_nota_serie) = Trim(redsp.arm_nota_serie);
    End If;
    
    vDetalhes := dbms_utility.format_error_backtrace || ' - PKG_HD_UTILITARIO.SP_EXCLUI_NOTA - ' || 'Acao=D Nota=' || pArm_nota_numero || ' CNPJ='||pGlb_cliente_cgccpfremetente || ' Sequencia='||pSequencia;
        
--    insert into t_glb_sql(glb_sql_instrucao,glb_sql_programa) values(vDetalhes,'CARGA_DET_20150622');      

    --deleto a ligação entre as tabelas base
    Delete t_arm_cargadet det
    Where det.arm_embalagem_numero = vArm_embalagem_numero
      And det.arm_embalagem_flag = vArm_embalagem_flag
      And det.arm_embalagem_sequencia = vArm_embalagem_sequencia;
      
      
    --deleto os itens da pesagem
    Delete t_arm_notapesagemitem pe
      where pe.arm_nota_sequencia = pSequencia;
            
   --deleto a pesagem da nota  
   Delete t_arm_notapesagem peso
      where peso.arm_nota_sequencia = pSequencia;

   -- deleta a presenca de carga

    Begin
    select pc.arm_presencarga_id
       into vID_Prescarga
    from tdvadm.t_arm_presencarganf pc
    where pc.arm_nota_sequencia   = pSequencia
      and rownum = 1;
    exception
      When NO_DATA_FOUND Then
         vID_Prescarga := null;
      End;
    vAuxiliar := sql%rowcount;


/*        FOR PN IN (SELECT *
                     FROM TDVADM.T_ARM_PRESENCARGANF N
                   where n.arm_presencarga_id =  vID_Prescarga 
--                     WHERE N.arm_nota_sequencia = pSequencia 
                  )
        LOOP               
          DELETE TDVADM.T_ARM_PRESENCARGANFVOL V
          WHERE V.ARM_PRESENCARGANF_ID = PN.ARM_PRESENCARGANF_ID;
          vAuxiliar := sql%rowcount;
        END LOOP;  
        */

    delete tdvadm.t_arm_presencargacanc x 
    where x.arm_presencarga_id in (select pc.arm_presencarga_id 
                                   From tdvadm.t_arm_presencarganf pc
                                   Where pc.arm_nota_sequencia   = pSequencia);
    vAuxiliar := sql%rowcount;
   
    delete tdvadm.t_arm_presencarganfvol x 
    where x.arm_presencarganf_id in (select pc.arm_presencarganf_id 
                                   From tdvadm.t_arm_presencarganf pc
                                   Where pc.arm_nota_sequencia   = pSequencia);
    vAuxiliar := sql%rowcount;

       
    delete tdvadm.t_arm_presencarganf pc
    where pc.arm_nota_sequencia = pSequencia;
    vAuxiliar := sql%rowcount;

/* Gustavo vocatore
    Tirei a parte de excluir a presença de carga pois */
    /*delete tdvadm.t_arm_presencarga x 
    where x.arm_presencarga_id = vID_Prescarga;
    vAuxiliar := sql%rowcount;*/
   
/*
  Rafael Aiti
  Deleto da t_arm_notaprioriza, pois usuário não
  consegue excluir nota priorizada
  */  
  
   Delete t_arm_notaprioriza np
    where np.arm_nota_sequencia = pSequencia;
  
    --Deleto a Nota propriamente dito.
    Delete t_arm_nota nota
    Where nota.arm_nota_numero = pArm_nota_numero
      And nota.glb_cliente_cgccpfremetente = Trim(pGlb_cliente_cgccpfremetente)
      And Trim(nota.arm_nota_serie) = Trim(pArm_nota_serie)
      And nota.arm_nota_sequencia = pSequencia;
    vAuxiliar := sql%rowcount;
    
    Commit;    
   
    
    -- Analise para saber se a Coleta pode ser liberada
    pkg_arm_gercoleta.Sp_get_PodeLiberarColeta(vColetaNumero,
                                               vColetaCiclo,
                                               vStatus, 
                                               vMessage);
   
    --Deleta embalagem
    Delete t_arm_embalagem emb
    Where emb.arm_embalagem_numero = vArm_embalagem_numero
      And emb.arm_embalagem_flag = vArm_embalagem_flag
      And emb.arm_embalagem_sequencia = vArm_embalagem_sequencia;
    
    --deleto a carga
    Delete t_arm_carga carga
    Where carga.arm_carga_codigo = vArm_carga_codigo;
  

    -- Se Sim tento liberar a coleta.
    -- Essa função ja esta olhando a coluna de sobrepocição e ocorrência.
    if (vStatus = pkg_glb_common.Status_Nomal) then
       
        vStatus  := NULL;
        vMessage := NULL;
        
        -- Se não conseguir devolvo a mensagem do processamento.
        pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColetaNumero,
                                                       vColetaCiclo,
                                                       '',
                                                       vStatus, 
                                                       vMessage);
        pMessage:= vMessage;                                              
      
     else
       
       pMessage:= vMessage;
       
     end if;   
     
     --Limpa data e hora de acompanhamento da coleta de nota em armazém.
     
     if (vStatus = pkg_glb_common.Status_Nomal) then
       
             update tdvadm.t_arm_coletaacompanhamento ac
             set  ac.arm_coletaacompanhamento_dthr = null 
           where  ac.arm_coleta_ncompra = vColetaNumero
             and  ac.arm_coleta_ciclo = vColetaCiclo
             and  ac.arm_coletaevento_id = '3';

             update tdvadm.t_arm_coleta ac
             set  ac.arm_coleta_dtfechamento = null 
           where  ac.arm_coleta_ncompra = vColetaNumero
             and  ac.arm_coleta_ciclo = vColetaCiclo;
             
             
    end if;                          
    

   --salvo todas as alterações
  Commit;    
   
                                             
   
   Return True;
    
  Exception
    --algum erro na validação
    When vEx_ExecFunction Then
      pMessage:= vMessage;
      Rollback;
      Return False;
      
    --Erro não previsto
    When Others Then
      pMessage:= 'Erro ao tentar excluir Nota Fisca: ' || pArm_nota_numero || ' - Cnpj: ' || pGlb_cliente_cgccpfremetente || ' - Serie: ' || pArm_nota_serie || 'Sequencia ' || pSequencia || chr(10) ||
                 vMessage || chr(10) ||               
                 'Rotina: tdvadm.pkg_fifo_recebimento.fnp_del_notafiscal(); ' || chr(10) ||
                 'Erro ora: ' || Sqlerrm;
      Rollback;           
      Return False; 
  End;
   
  
  
  
End FNP_Del_NotaFiscal;

----------------------------------------------------------------------------------------------------------------
--Função privada que verifica se a nota-fiscal pode ser atualizada.                                           --
----------------------------------------------------------------------------------------------------------------
function FNP_Valida_Atualizacao( pDadosNota   pkg_fifo.tDadosNota) return pkg_fifo.tRetornoFunc is
  --Variavel utilizada como retorno da função.
  vRetorno    pkg_fifo.tRetornoFunc;
begin
  Begin

    Select
      Count(*) Into vRetorno.Controle
    From 
      tdvadm.t_arm_nota  n
    Where 
       0=0
      And n.con_conhecimento_codigo Is Not Null
      And n.arm_nota_sequencia = pDadosNota.nota_Sequencia;
      
      vRetorno.Status := pkg_fifo.Status_Normal;
  exception
    when others then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao verificar existência de CTRC';
  end;
  
  if vRetorno.Controle > 0 then
    vRetorno.Status := pkg_fifo.Status_Erro;
    vRetorno.Message := 'ATUALIZAÇÃO NÃO PERMITIDA.' || chr(13) || chr(13) ||
                        'Nota Fiscal não pode ser atualizada por que já faz parte de um CTRC' ||CHR(13)||
                        'Sequencia: ' ||pDadosNota.nota_Sequencia;
  end if;
  

  return vRetorno;
  
  
end FNP_Valida_Atualizacao;  

function FNP_ValidaNota( pDadosNota  pkg_fifo.tDadosNota)
   return pkg_fifo.tRetornoFunc 
   is
    vRetorno pkg_fifo.tRetornoFunc;
    vAuxiliar Integer;
    vOnu      tdvadm.t_arm_nota.arm_nota_onu%type;
    vStatus  char(1);
    vMessage varchar2(2000);
    vGrupoRemetChave tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
    vTipoRemetenteChave tdvadm.t_glb_cliente.glb_cliente_nacional%type;
    vTipoRemetente   tdvadm.t_glb_cliente.glb_cliente_nacional%type;
    vNumeroNota      varchar2(50);
Begin
  vRetorno.Controle:= 0;
  vRetorno.Status := 'N';
  vRetorno.Message:= '';
  
        if pDadosNota.nota_chaveNFE is not null then
           -- Verifica Data de Emissao
           if (substr(pDadosNota.nota_chaveNFE,3,4) <> to_char(pDadosNota.nota_dtEmissao,'YYMM')) Then
              vRetorno.Status := pkg_fifo.Status_Erro;
              vRetorno.Message := vRetorno.Message || Chr(13) || 'Emissao da Data Digitada errada! Nota Emitida em ' || substr(pDadosNota.nota_chaveNFE,5,2) || '/' || substr(pDadosNota.nota_chaveNFE,3,2);
           End If;
           -- Verifica numero da Nota
           if (substr(pDadosNota.nota_chaveNFE,26,9) <> lpad(trim(pDadosNota.nota_numero),9,'0') )  Then
              vRetorno.Status := pkg_fifo.Status_Erro;
              vRetorno.Message := vRetorno.Message || Chr(13) || 'Numero da Nota Diferente da Chave nr da Chave [' || substr(pDadosNota.nota_chaveNFE,26,9) || ']';
           End If;
           -- Verifica Serie da Nota
           if (substr(pDadosNota.nota_chaveNFE,23,3) <> lpad(trim(pDadosNota.nota_serie),3,'0'))  Then
              vRetorno.Status := pkg_fifo.Status_Erro;
              vRetorno.Message := vRetorno.Message || Chr(13) || 'Serie da Nota Diferente da Chave nr da Serie [' || substr(pDadosNota.nota_chaveNFE,23,3) || ']';
           End If;

           -- Verifica Remetente da Nota
           if (trim(substr(pDadosNota.nota_chaveNFE,7,14)) <> trim(pDadosNota.Remetente_CNPJ)) Then
              Begin
                 select cl.glb_grupoeconomico_codigo,
                        cl.glb_cliente_nacional
                   into vGrupoRemetChave,
                        vTipoRemetenteChave
                 from tdvadm.t_glb_cliente cl
                 where cl.glb_cliente_cgccpfcodigo = rpad(trim(substr(pDadosNota.nota_chaveNFE,7,14)),20);
              exception
                When NO_DATA_FOUND Then
                   vGrupoRemetChave := '9999';
                End;
              
              Begin
                 select cl.glb_cliente_nacional
                   into vTipoRemetente
                 from tdvadm.t_glb_cliente cl
                 where cl.glb_cliente_cgccpfcodigo = rpad(trim(pDadosNota.Remetente_CNPJ),20);
              exception
                When NO_DATA_FOUND Then
                   vTipoRemetente := 'N';
                End;

              If (vTipoRemetenteChave = 'N') and (vTipoRemetente <> 'I') Then
                 vRetorno.Status := pkg_fifo.Status_Erro;
                 vRetorno.Message := vRetorno.Message || Chr(13) || 'Remetente da Nota Diferente da Chave CNPJ da Cheve [' || substr(pDadosNota.nota_chaveNFE,7,14)  || ']';
              End If;
           End If;

           -- Valida A Chave NFE
           IF F_DIGCONTROLEMODCTE(SUBSTR(pDadosNota.nota_chaveNFE ,1,43)) <> SUBSTR(pDadosNota.nota_chaveNFE,-1) THEN
              vRetorno.Message := vRetorno.Message || Chr(13) || 'Chave NFE (44) Invalida';
              vRetorno.Status := pkg_fifo.Status_Erro;
           END IF;

        End If;     

        SELECT COUNT(*)
          INTO vAuxiliar
        FROM TDVADM.T_GLB_CLIEND CE
        WHERE CE.GLB_CLIENTE_CGCCPFCODIGO = pDadosNota.Sacado_CNPJ
          AND CE.GLB_TPCLIEND_CODIGO = 'C';

        If vAuxiliar = 0 Then
           vRetorno.Message := vRetorno.Message || Chr(13) || 'Sacado ' || pDadosNota.Sacado_CNPJ || ' não possui endereço de Cobranca.';
           vRetorno.Status := pkg_fifo.Status_Erro;
        End If;
         
        SELECT COUNT(*)
          INTO vAuxiliar
        FROM TDVADM.T_GLB_CLIENTE CE
        WHERE CE.GLB_CLIENTE_CGCCPFCODIGO = pDadosNota.Sacado_CNPJ
          AND CE.GLB_CLIENTE_VLRLIMITE = 0;

        If vAuxiliar > 0 Then
           vRetorno.Message := vRetorno.Message || Chr(13) || 'Sacado ' || pDadosNota.Sacado_CNPJ || ' sem Limite para emissao de CTe/NFSe';
           vRetorno.Status := pkg_fifo.Status_Erro;
        End If;



        If pDadosNota.Onu_Codigo is null then
          
          Begin 
             select an.arm_nota_onu
                 into vOnu
              from tdvadm.t_arm_nota an
              where an.arm_nota_sequencia = pDadosNota.nota_Sequencia;  
          exception
            When NO_DATA_FOUND Then
               vOnu := null;
            end;
        Else
          vOnu := pDadosNota.Onu_Codigo;
        End If;        

        If vOnu is null then
          
           select count(*)
             into vAuxiliar
           from t_glb_clientebloqueios cb
           where cb.glb_cliente_cgccpfcodigo = rpad(pDadosNota.Remetente_CNPJ,20)
             and cb.glb_clientebloqueios_flagbloq = 'S'
             and cb.glb_clientebloqueios_dtdesbloq is null;
       
          If vAuxiliar <> 0 Then
             vRetorno.Status := pkg_fifo.Status_Erro;
             vRetorno.Message := vRetorno.Message || Chr(13) || '1 Fornecedor ja Transportou Quimico, Favor informar ONU ou 9999 para prosseguir...';
          End If;   
        End If;     
      
      vAuxiliar := 0;  
      select count(*)
        into vAuxiliar
      from t_arm_nota an
      where an.arm_nota_chavenfe = pDadosNota.nota_chaveNFE
        and rpad(an.glb_cliente_cgccpfsacado,20) = rpad(pDadosNota.Sacado_CNPJ,20);

      vAuxiliar := 0;  
        
      If vAuxiliar > 0 then
          vRetorno.Status := 'E';
          vRetorno.Message := vRetorno.Message || Chr(13) || 'Nota ' || pDadosNota.nota_numero || ' Ja Cadastrada para este SACADO [' || pDadosNota.Sacado_CNPJ || ']';
      End If;

      If nvl(pDadosNota.nota_pesoNota,0) <= 0 then
          vRetorno.Status := 'E';
          vRetorno.Message := vRetorno.Message || Chr(13) || 'Nota Sem Peso ou peso Zerado';
      End If; 
      

      If nvl(pDadosNota.cfop_Codigo,'9999') = '9999' then
          vRetorno.Status := 'E';
          vRetorno.Message := vRetorno.Message || Chr(13) || 'Nota Sem CFOP';
      End If; 




      If  Not tdvadm.pkg_fifo_validadoresnota.FN_Valida_NotaColeta(pDadosNota,vMessage) Then 
          vRetorno.Status := pkg_glb_common.Status_Erro;
           vRetorno.Message := vRetorno.Message || ' ' || vMessage;
        End If; 
--       vRetorno.Message := 'Limpei';
  return vRetorno;
End FNP_ValidaNota;
        

----------------------------------------------------------------------------------------------------------------                         
-- função utilizada para saber se a nota fiscal já foi lançada                                                --
----------------------------------------------------------------------------------------------------------------
function FNP_VerifaNotaLancada( pDadosNota  pkg_fifo.tDadosNota,
                                pQtdeDias   integer 
                               ) return pkg_fifo.tRetornoFunc is
 --Variável utilizada como retorno da função.
 vRetorno  pkg_fifo.tRetornoFunc;
begin
  --primeiro zero as variáveis utilizadas durante a função.
  vRetorno.Controle:= 0;
  vRetorno.Status := '';
  vRetorno.Message:= '';
  
  Begin
    --Verifica se já foi lançada nesse armazem, durante um determinado período.
    Select 
      count(*) into vRetorno.Controle
    from 
      tdvadm.t_arm_nota  nota
    where
      0=0
      and nota.arm_nota_numero = pDadosNota.nota_numero
      and Trim(nota.glb_cliente_cgccpfremetente) = Trim(pDadosNota.Remetente_CNPJ)
      and Trim(nota.arm_nota_serie) = Trim(pDadosNota.nota_serie)
      and nota.arm_armazem_codigo = pDadosnota.armazem_Codigo
      and trunc(nota.arm_nota_dtinclusao) >= trunc(sysdate) - pQtdeDias;
      
      vRetorno.Status := pkg_fifo.Status_Normal;
  Exception
    --Caso ocorra algum erro, seto variável de Status para erro.
    when others then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar verificar lançamento da nota.' || chr(13) || dbms_utility.format_call_stack;
  end;    
  
  --Caso a variável controle seja maior que um, retorno com erro, e informando que a nota já foi lançada.
  if vRetorno.Controle > 0 then
    vRetorno.Status := pkg_fifo.Status_Erro;
    vRetorno.Message := 'Nota Fiscal '|| pDadosNota.nota_numero || chr(13) || 'Já foi lançada nesse armazem.' || chr(13) ||
                        'Data' || pQtdeDias;
  end if;
  vRetorno.Status := pkg_fifo.Status_Normal;
  --Retorno a variável 
  return vRetorno;
end FNP_VerifaNotaLancada;

----------------------------------------------------------------------------------------------------------------
-- Função Privada, responsável por inserir um registro na T_ARM_CARGA                                         --
----------------------------------------------------------------------------------------------------------------
Function FNP_Ins_Carga( pDadosNota   pkg_fifo.tDadosNota,
                        pUsuario     t_usu_usuario.usu_usuario_codigo%Type
                       ) Return pkg_fifo.tRetornoFunc Is
 --Função que será utilizada como retorno da função.
 vRetorno  pkg_fifo.tRetornoFunc;
 
 --Variável do tipo da linha
 vCarga   tdvadm.t_arm_carga%Rowtype;
Begin
  Begin
    --Popula a variável do tipo da linha da tabela t_Arm_Carga.
    vCarga.Arm_Carga_Codigo             := pDadosNota.carga_Codigo;
    vCarga.Glb_Rota_Codigo              := pDadosNota.rota_Codigo;
    vCarga.Glb_Tpcarga_Codigo           := pDadosNota.carga_Tipo;
    vCarga.Arm_Status_Codigo            := '02';
    vCarga.Arm_Carga_Cubado             := pDadosNota.nota_cubagem;
    vCarga.Arm_Carga_Dtinclusao         := Sysdate;
    vCarga.Arm_Carga_Dtfechado          := Sysdate;
    vCarga.Arm_Carga_Qtdvolume          := pDadosNota.nota_qtdeVolume;
    vCarga.Arm_Carga_Peso               := pDadosNota.nota_pesoNota;
    vCarga.Glb_Localidade_Codigodestino := Trim( pDadosNota.Destino_LocalCodigo );
    vCarga.Usu_Usuario_Codigo           := Trim( pUsuario );
    
    --Executa a inserção propriamente dito.
    Insert Into t_arm_carga Values vCarga;
    Commit;

    --Seta a variável de status para normal, e limpa a variável de mensagem.
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
    
  Exception
    --Caso ocorra algum erro, seto a variável de status para erro, e defino mensagem de retorno.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar inserir registro de Carga.' || chr(13) || dbms_utility.format_call_stack ;
  End;  
  
  --Devolvo a variável 
  Return vRetorno;
End;  

----------------------------------------------------------------------------------------------------------------
--Função Privada, responsável por inserir um registro na T_ARM_CARGADET                                       --
----------------------------------------------------------------------------------------------------------------
Function FNP_Ins_CargaDet( pDadosNota  pkg_fifo.tDadosNota,
                           pUsuario    t_usu_usuario.usu_usuario_codigo%Type
                         ) Return pkg_fifo.tRetornoFunc Is
 --Variável que será utilizada como retorno da função
 vRetorno   pkg_fifo.tRetornoFunc;
 
 --Variável do tipo da linha da Tabela, utilizada para inserção dos dados.
 vCargaDet   tdvadm.t_arm_cargadet%Rowtype;
Begin
  Begin
    --Popula a variável que será utilizada para executar a inserção propriamente dito.
    vCargaDet.Arm_Carga_Codigo            := pDadosNota.carga_Codigo;
    vCargaDet.Arm_Cargadet_Seq            := 1;
    vCargaDet.Arm_Nota_Sequencia          := pDadosNota.nota_Sequencia;
    vCargaDet.Arm_Nota_Numero             := pDadosNota.nota_numero;
    vCargaDet.Glb_Cliente_Cgccpfremetente := Trim( pDadosNota.Remetente_CNPJ );
    vCargadet.Arm_Embalagem_Numero        := pDadosNota.embalagem_numero;
    vCargadet.Arm_Embalagem_Flag          := pDadosNota.embalagem_flag;
    vCargaDet.Arm_Embalagem_Sequencia     := pDadosNota.embalagem_sequencia;
    vCargaDet.Usu_Usuario_Codigo          := Trim( pUsuario );
    
    --Realizo a inserção propriamente dito
    Insert Into tdvadm.t_arm_cargadet Values vCargaDet;
    
    --Seto a variável de status para normal, e defino a variável de mensagem para vazia.
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
    
    Commit;
    
  Exception
    --Caso ocorra algum erro, seta a variável de status para erro, e define uma mensagem de erro.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao inserir registro de Detalhe de Carga.' || chr(13) || sqlerrm || chr(13) || dbms_utility.format_call_stack;
  End;
  
  --Retorna a Variável
  Return vRetorno;
  
End FNP_Ins_CargaDet;
  
----------------------------------------------------------------------------------------------------------------
--Função Privada, responsável por inserir um registro na T_ARM_EMBALAGEM                                      --
----------------------------------------------------------------------------------------------------------------
Function FNP_Ins_Embalagem( pDadosNota   pkg_fifo.tDadosNota,
                            pUsuario     t_usu_usuario.usu_usuario_codigo%Type,
                            pCodOnu      pkg_fifo.tDadosProdutosQuimicos
                           ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno da função.
 vRetorno  pkg_fifo.tRetornoFunc;
 
 --Variável do tipo da tabela, utilizada para fazer o insert propriamente dito.
 vEmbalagem   tdvadm.t_arm_embalagem%Rowtype;
 
 --Variável para atribuir kilo insento.
 vKGIsenta    tdvadm.t_glb_onu.glb_onu_kgisenta%Type;
Begin
  Begin
    --Popula a variável de linha, para executar a inserção.
    vEmbalagem.Arm_Embalagem_Numero           := pDadosNota.embalagem_numero;
    vEmbalagem.Arm_Embalagem_Flag             := pDadosNota.embalagem_flag;
    vEmbalagem.Arm_Embalagem_Sequencia        := pDadosNota.embalagem_sequencia; 
    vEmbalagem.Arm_Carga_Codigo               := pDadosNota.carga_Codigo;
    vEmbalagem.Arm_Embalagem_Dtinclusao       := pDadosNota.nota_dtEntrada;
    vEmbalagem.Arm_Embalagem_Dtfechado        := pDadosNota.nota_dtEntrada;
    vEmbalagem.Arm_Embalagem_Altura           := pDadosNota.nota_altura;
    vEmbalagem.Arm_Embalagem_Largura          := pDadosNota.nota_largura;
    vEmbalagem.Arm_Embalagem_Comprimento      := pDadosNota.nota_comprimento;
    vEmbalagem.Arm_Tpcarga_Codigo             := pDadosNota.carga_Tipo;
    vEmbalagem.Glb_Cliente_Cgccpfdestinatario := Trim(pDadosNota.Destino_CNPJ);
    vEmbalagem.Glb_Tpcliend_Coddestinatario   := pDadosNota.Destino_tpCliente;
    vEmbalagem.Arm_Embalagem_Impresso         := 'N';
    vEmbalagem.Arm_Armazem_Codigo             := pDadosNota.armazem_Codigo;
    vEmbalagem.usu_usuario_codigo             := Trim(pUsuario);
    vEmbalagem.Arm_Embalagem_Peso             := pDadosNota.nota_pesoNota;
    vEmbalagem.Arm_Embalagem_Pesobalanca      := pDadosNota.nota_pesoBalanca;
    vEmbalagem.Arm_Embalagem_Pesocobrado      := 0;
    
    
    --Verifico se foi passado algum código Onu
    If ( nvl(Trim(pCodOnu.onu_codigo), 0 ) <> 0 ) Then
      SELECT GLB_ONU_KGISENTA Into vKGIsenta 
      FROM T_GLB_ONU 
      WHERE GLB_ONU_CODIGO = pCodOnu.onu_codigo And rownum = 1 ;
    End If;
      
    
    --Definir valores.
    vEmbalagem.Glb_Onu_Codigo := pCodOnu.onu_codigo;
    vEmbalagem.Arm_Embalagem_Pesoonu := pCodOnu.onu_peso;
    vEmbalagem.Glb_Onu_Kgisenta := vKGIsenta;
    
    --Executo a inserção.
    Insert Into tdvadm.t_arm_embalagem Values vEmbalagem;
    
    --Seto a variável de retorno para normal.
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
    Commit;
    
  Exception
    --Caso ocorra algum erro, seto a variável de Status, e a mensagem de erro.
    When Others Then
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := 'Erro ao tentar criar uma embalagem.' || chr(13) || dbms_utility.format_call_stack;
  End;
  
  --Retorna a variável vRetorno.
  Return vRetorno;
  
End FNP_Ins_Embalagem;
  
----------------------------------------------------------------------------------------------------------------
--Função Privada, responsável por inserir um registro na T_ARM_NOTA                                           --
----------------------------------------------------------------------------------------------------------------
Function FNP_Ins_NotaFiscal( pDadosNota   pkg_fifo.tDadosNota,
                             pProdQuimicos pkg_fifo.tDadosProdutosQuimicos,
                             pUsuario     t_usu_usuario.usu_usuario_codigo%Type
                           ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno da função
 vRetorno    pkg_fifo.tRetornoFunc;
 vRetornoAux pkg_fifo.tRetornoFunc;
 --Variável do tipo de linha será utilizada para executar a inserção.
 vLinha  tdvadm.t_arm_nota%Rowtype;
 vJanelaCons tdvadm.t_arm_janelacons%Rowtype;
 vLinhaTpDoc tdvadm.t_arm_notatpdoc%Rowtype;
 vCodAut  Integer := 0;
 vAuxiliar integer := 0;
 vArmazem  tdvadm.t_arm_nota.arm_armazem_codigo%type;
 vGrupoEc  tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
 vContaCteJanela number;
 vSomaPeso       number;
 vContaCte       number;
 vContaNota      number;
 vStatus   char(1);
 vMessage  varchar2(1000);
 vLinha2    char(2);
Begin


  vRetorno.Status := pkg_glb_common.Status_Nomal;
  
  if pDadosNota.Destino_LocalCodigo is null Then
     vRetorno.Status := pkg_glb_common.Status_Erro;
     vRetorno.Message := 'Localidade de destiono Obrigatoria...';
  End If;
  
   vLinha2 := '00'; 

  Begin

      
     If vRetorno.Status = pkg_glb_common.Status_Nomal Then
       
        --Caso na inserção o código de produto seja diferente de 55 ( nota fiscal)
        If (  nvl(Trim(pDadosNota.nota_tpDocumento), '55') not in ('55','99', '13') ) or 
           (  nvl(pDadosNota.nota_numero,'0') = '0' ) Then

          --Populo a variável da tabela 
          vCodAut := arm_notatpdoc_codigo.nextval;
          vLinhaTpDoc.Arm_Nota_Sequencia          := pDadosNota.nota_Sequencia;
          vLinhaTpdoc.Arm_Nota_Numero             := vCodAut;
          vLinhaTpDoc.Glb_Cliente_Cgccpfremetente := Trim(pDadosNota.Remetente_CNPJ);
          vLinhaTpDoc.Arm_Nota_Serie              := Trim( pDadosNota.nota_serie );
          vLinhaTpDoc.Con_Tpdoc_Codigo            := Trim( pDadosNota.nota_tpDocumento );
          vLinhaTpDoc.Arm_Notatpdoc_Codigo        := Trim( pDadosNota.nota_numero);
       
          vLinha.Arm_Nota_Numero := vCodAut;
     
        Else
          vLinha.Arm_Nota_Numero                := pDadosNota.nota_numero;
        End If;
          
        vLinha.Usu_Usuario_Codigo             := pUsuario;
        vLinha.Arm_Nota_Sequencia             := pDadosNota.nota_Sequencia;
        vLinha.Arm_Nota_Serie                 := pDadosNota.nota_serie; 
        vLinha.Arm_Movimento_Datanfentrada    := pDadosNota.nota_dtEmissao;
        vLinha.Arm_Nota_Dtrecebimento         := pDadosNota.nota_dtSaida;
        vLinha.Arm_Nota_Dtinclusao            := Sysdate;
        vLinha.Glb_Mercadoria_Codigo          := pDadosNota.mercadoria_codigo;
        vLinha.Arm_Nota_Mercadoria            := pDadosNota.nota_descricao;
        vLinha.Arm_Nota_Valormerc             := pDadosNota.nota_ValorMerc; 
        vLinha.Arm_Nota_Flagemp               := pDadosNota.nota_EmpilhamentoFlag;
        vLinha.Arm_Nota_Empqtde               := pDadosNota.nota_EmpilhamentoQtde;
        vLinha.Arm_Nota_Tipo                  := 'D';
        vLinha.Arm_Nota_Vide                  := pDadosNota.nota_Vide;
        vLinha.Arm_Nota_Atribuido             := 'S';
        vLinha.Arm_Nota_Atribui_Movimento     := 'N';
        vLinha.Xml_Notalinha_Numdoc           := pDadosNota.nota_PO;
        vLinha.Arm_Nota_Di                    := pDadosNota.nota_Di;
        vLinha.Glb_Cliente_Cgccpfremetente    := Trim( pDadosNota.Remetente_CNPJ );
        vLinha.Glb_Tpcliend_Codremetente      := pDadosNota.Remetente_tpCliente;
        vLinha.Glb_Cliente_Cgccpfdestinatario := Trim( pDadosNota.Destino_CNPJ );
        vLinha.Glb_Tpcliend_Coddestinatario   := pDadosNota.Destino_tpCliente;
        vLinha.Glb_Cliente_Cgccpfsacado       := Trim( pDadosNota.Sacado_CNPJ );
        vLinha.Glb_Tpcliend_Codsacado         := pDadosNota.Sacado_tpCliente;
        vLinha.Glb_Localidade_Codigoorigem    := pDadosNota.Remetente_LocalCodigo;
        vLinha.Arm_Nota_Tabsol                := pDadosNota.nota_RequisTp;
        vLinha.Arm_Nota_Tabsolcod             := pDadosNota.nota_RequisCodigo;
        vLinha.Arm_Nota_Tabsolsq              := pDadosNota.nota_RequisSaque;
        vLinha.Slf_Contrato_Codigo            := pDadosNota.nota_Contrato;
        vLinha.Arm_Nota_Flagpgto              := pDadosNota.nota_flagPgto;
        vLinha.Arm_Nota_Qtdvolume             := pDadosNota.nota_qtdeVolume;
        vLinha.Arm_Nota_Largura               := pDadosNota.nota_largura;
        vLinha.Arm_Nota_Altura                := pDadosNota.nota_altura;
        vLinha.Arm_Nota_Comprimento           := pDadosNota.nota_comprimento;
        vLinha.Arm_Carga_Codigo               := pDadosNota.carga_Codigo;
        vLinha.Glb_Tpcarga_Codigo             := pDadosNota.carga_Tipo;
        vLinha.Arm_Coleta_Ncompra             := pDadosNota.coleta_Codigo;
        vLinha.Arm_Coleta_Tpcompra            := pDadosNota.coleta_Tipo;
        vLinha.Arm_Coleta_Ciclo               := pDadosNota.coleta_Ciclo;
        vLinha.Arm_Embalagem_Numero           := pDadosNota.embalagem_numero;
        vLinha.Arm_Embalagem_Flag             := pDadosNota.embalagem_flag;
        vLinha.Arm_Embalagem_Sequencia        := pDadosNota.embalagem_sequencia;
        vLinha.Arm_Nota_Peso                  := pDadosNota.nota_pesoNota;
        -- Sirlano 09/05/2014
        vLinha.Arm_Nota_Pesobalanca           := 0; --Nvl(pDadosNota.nota_pesoBalanca,0);
        vLinha.Arm_Nota_Cubagem               := pDadosNota.nota_cubagem;
        vLinha.Glb_Rota_Codigo                := pDadosNota.rota_Codigo;
        vLinha.Arm_Armazem_Codigo             := pDadosNota.armazem_Codigo;
        vLinha.Arm_Nota_Chavenfe              := pDadosNota.nota_chaveNFE;
        vLinha.Glb_Cfop_Codigo                := pDadosNota.cfop_Codigo;
        vLinha.Arm_Nota_Onu                   := pProdQuimicos.onu_codigo;
        vLinha.Arm_Nota_Grpemb                := pProdQuimicos.onu_grpEmb;
        vLinha.Arm_Nota_Nf_e                  := 'N';
        vLinha.Arm_Nota_Ctrc_e                := 'N';
        vLinha.Con_Tpdoc_Codigo               := pDadosNota.nota_tpDocumento;
        vLinha.Arm_Nota_Qtdelimit             := pDadosNota.nota_qtdelimitada;

        If nvl(pProdQuimicos.onu_codigo, 0) <> 0 Then
          vLinha.Arm_Nota_Flagonu := 'S';
        End If;
        
        if nvl(vLinha.Arm_Movimento_Pesocubado, '-1') = '-1' then
          Begin
            Select n.edi_nf_pesocubado
               Into vLinha.Arm_Movimento_Pesocubado
               From t_edi_nf n
               where n.edi_nf_chavenfe = vLinha.Arm_Nota_Chavenfe;           
            vLinha.Arm_Coleta_Pesocobrado := vLinha.Arm_Nota_Peso;           
          Exception
            When No_Data_Found Then
              vLinha.Arm_Movimento_Pesocubado := vLinha.Arm_Movimento_Pesocubado;
          End;  
        end if;  
        

   vLinha2 := '01'; 

--  pDadosNota.Onu_Codigo := vProdQuimico.onu_codigo;
--  pDadosNota.Onu_GrpEmb := vProdQuimico.onu_grpEmb;

   
   vRetornoAux := FNP_ValidaNota(pDadosNota);
   
   if vRetorno.Status <> pkg_fifo.Status_Erro Then
      vRetorno.Status := vRetornoAux.Status;
   End If;
    
   If vRetornoAux.Message is not null Then
      vRetorno.Message := vRetornoAux.Message;
   End If;

if vRetorno.Status <> pkg_fifo.Status_Erro Then
        

   vLinha2 := '02'; 
   
  -- ADICIONA POR JONATAS VELOSO 25/02/2019 PARA EVITAR PROBLEMA DE DUAS NOTAS NA MESMA COLETA
    IF (vLinha.slf_contrato_codigo in ('C0590000792','C5900048672')) THEN
      
      SELECT count(*)
        into vContaNota
        FROM TDVADM.T_ARM_NOTA N
       WHERE N.ARM_COLETA_NCOMPRA = vLinha.arm_coleta_ncompra
         AND N.Arm_Coleta_Ciclo   = vLinha.arm_coleta_ciclo;
         
      IF (vContaNota >= 1) THEN
        vRetorno.Status := 'E';
        vRetorno.Message := vRetorno.Message || chr(13) || 'Coleta já utilizada em outra nota';
      END if;  
    END IF;
 ---------------------------------------------
      If vRetorno.Status <> 'E' Then
--         if vLinha.Slf_Contrato_Codigo is null then
--            vLinha.Slf_Contrato_Codigo := '999999';
--         End If;

         Select count(*)
            into vAuxiliar 
         from tdvadm.t_arm_nota an
         where an.Arm_Nota_Chavenfe = vLinha.Arm_Nota_Chavenfe
           and an.glb_cliente_cgccpfsacado = vLinha.glb_cliente_cgccpfsacado
           and an.glb_tpcarga_codigo not in ('CO','RP');
         If vAuxiliar = 0 Then
            Insert Into tdvadm.t_arm_nota Values vLinha;
         Else
            vRetorno.Status := 'E';
            vRetorno.Message := vRetorno.Message || chr(13) || 'Nota Ja Cadastrada para esta pagador.';   
            return vRetorno; 
         End If;   
         vLinha2 := '29';
      Else
         vLinha2 := '22';
         return vRetorno; 
      End IF;
      
      -- 27/06/2016
            
           --Ajusta Dados da Nota
           vStatus := 'N';
           vMessage := '';
           vLinha2 := 'Pa';
           Begin
           tdvadm.pkg_slf_contrato.SP_SETPARTCONTRATO(vLinha.Arm_Nota_Numero,
                                                      vlinha.glb_cliente_cgccpfremetente,
                                                      vLinha.Arm_Nota_Serie,
                                                      vStatus,
                                                      vMessage);
           Exception
             When OTHERS Then
                vLinha2 := 'PE';
                vRetorno.Message := Sqlerrm;
             End ;
           If vStatus = 'E' Then
              vRetorno.Status := vStatus;
              vRetorno.Message := vRetorno.Message || ' ' || vMessage;
           Else
             Commit;   
           End If;


           -- Somente Iremos criar Janela Depois da Etiqueta ou Balanca
           -- Ou quanto não temos controle de Janela

   vLinha2 := '33'; 
        If vRetorno.Status <> 'E' Then
           PKG_SLF_CONTRATO.SP_GETJANELANOTA(vlinha.arm_nota_numero,
                                             vlinha.glb_cliente_cgccpfremetente,
                                             vlinha.arm_nota_serie,
                                             vJanelaCons.Arm_Janelacons_Dtinicio,
                                             vJanelacons.Arm_Janelacons_Dtfim,
                                             vJanelaCons.Arm_Janelacons_Geracte); 

/***************** deixar o IF e colocar a FUNCAO *****************************************/
           -- Se as Datas são iguais e Diferentes de 01/01/1900 e porque não tem controle de Janela
           If ( vJanelaCons.Arm_Janelacons_Dtinicio = vJanelacons.Arm_Janelacons_Dtfim ) and 
              ( vJanelaCons.Arm_Janelacons_Dtinicio <> to_date('01/01/1900','dd/mm/yyyy') ) Then
             
              vLinha2 := '31'; 
               
              tdvadm.pkg_slf_contrato.SP_INFORMACLIENTE(vlinha.arm_nota_numero,
                                                        vlinha.glb_cliente_cgccpfremetente,
                                                        vlinha.arm_nota_serie,
                                                        vlinha.arm_armazem_codigo,
                                                        vlinha.usu_usuario_codigo,
                                                        'E',
                                                        vStatus,
                                                        vMessage);

/*               Trocado pela rotina acima em 30/11/2016 Sirlano
               pkg_slf_contrato.SP_SETCRIAJANELA(vlinha.arm_nota_numero,
                                                 vlinha.glb_cliente_cgccpfremetente,
                                                 vlinha.arm_nota_serie,
                                                 vLinha.Arm_Nota_Sequencia,
                                                 'N',
                                                 vStatus,
                                                 vMessage);
*/
              If vStatus = 'E' Then
                 vRetorno.Status := vStatus;
                 vRetorno.Message := vRetorno.Message || ' ' || vMessage;
              End IF;
                                                 
           End If;

   vLinha2 := '04'; 

        End If;   
     End If;            
     End If; 
  Exception
    --Caso ocorra algum erro, seta a variável para erro, e defini uma mensagem de erro.
    When Others Then 
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := vLinha2 || '-' || 'Erro ao tentar inserir dados da Nota Fiscal x' || chr(13) || 
                          'Nota ' || vLinha.Arm_Nota_Numero || chr(13) ||
                          'CNPJ ' || vlinha.glb_cliente_cgccpfremetente || chr(13) ||
                          'Serie ' || vLinha.Arm_Nota_Serie || chr(13) ||
                          Sqlerrm || chr(13) ||
                          dbms_utility.format_call_stack  ;
  End;
    
  Return vRetorno;
End; 

----------------------------------------------------------------------------------------------------------------
-- Função Privada para recuperar os dados dos produtos quimicos.                                              --
----------------------------------------------------------------------------------------------------------------             
Function FNP_Ins_ProdutosQuimicos( pXmlEntrada   Varchar2,
                                   pNota_numero   tdvadm.t_arm_nota.arm_nota_numero%Type,
                                   pNota_sequencia tdvadm.t_arm_nota.arm_nota_sequencia%Type,
                                   pNota_serie     tdvadm.t_arm_nota.arm_nota_serie%Type,
                                   pRemetente_Cnpj tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                                   pColeta         tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                                   pCiclo          tdvadm.t_arm_coleta.arm_coleta_ciclo%type
                                 ) Return pkg_fifo.tDadosProdutosQuimicos Is
 --Variável utilizada como variável de retorno.
 vRetorno   pkg_fifo.tDadosProdutosQuimicos;
 
 --Variável do tipo da linha para facilitar a atribuição dos valores.
 vLinha     tdvadm.t_arm_notafichaemerg%Rowtype;
 
 --Variável de controle.
 vCount     Integer := 0;
 vNumeroOnu varchar2(10);
 vIndOnusOk integer := 0;
 vExiteOnuN integer := 0;
 vNumeroAsn tdvadm.t_arm_coleta.xml_coleta_numero%type;
 vOrigemCol tdvadm.t_arm_coletaorigem.arm_coletaorigem_cod%type;
 
Begin
  --Limpo as variáveis que serão utilizadas para ter certeza que não vou encontrar lixo.

 
  --Verifico se a nota já possui algum registro de produto químico.
  Select Count(*) 
    Into vCount
    From tdvadm.t_arm_notafichaemerg w
   Where w.arm_nota_numero                   = pNota_numero
     And w.arm_nota_serie                    = pNota_serie 
     And Trim(w.glb_cliente_cgccpfremetente) = Trim(pRemetente_Cnpj);
 
  --caso tenha algum produto quimico, excluo todos para nova inclusão.
  If vCount > 0 Then

   -- Verifico se ja foi pedido autorizacao ou se ja tem autorização
   select Count(*) 
     Into vCount 
     From t_arm_notafichaemerg fe 
    Where 0 = 0
      and fe.arm_nota_numero = pNota_numero
      and fe.arm_nota_serie = pNota_serie 
      and fe.glb_cliente_cgccpfremetente = Trim(pRemetente_Cnpj)
      and fe.arm_notafichaemerg_codcli is not null;
       
   If vCount = 0 Then
     
     --Caso a nota tenmha vindo do XML, verifico se ela tinha produto QUIMICO.
     Select Count(*) 
       Into vCount 
       From  t_xml_notafichaemerg w 
     Where 0 < ( Select Count(*) 
                   From t_xml_nota n
                  Where n.xml_nota_numero    = w.xml_nota_numero
                    And n.xml_nota_tipo      = w.xml_nota_tipo
                    And n.xml_nota_emissao   = w.xml_nota_emissao
                    And n.xml_nota_sequencia = w.xml_nota_sequencia
                    And n.xml_nota_nf        = pNota_numero
                    And Trim(n.glb_cliente_cgccpfremetente) = Trim(pRemetente_Cnpj)
            );  
     
     --Caso tenha eu excluo os registros, de produtos quimicos XML
     If vCount > 0 Then 
       
       Delete From t_xml_notafichaemerg w 
       Where
         0 < ( Select Count(*) From t_xml_nota n
               Where n.xml_nota_numero    = w.xml_nota_numero
                 And n.xml_nota_tipo      = w.xml_nota_tipo
                 And n.xml_nota_emissao   = w.xml_nota_emissao
                 And n.xml_nota_sequencia = w.xml_nota_sequencia
                 And n.xml_nota_nf = pNota_numero
                 And Trim(n.glb_cliente_cgccpfremetente) = Trim(pRemetente_Cnpj)
             );  
     End If; 
     
     Commit;     

     --Excluo os registros de produtos quimicos da extrutura recebimento.
     Delete  From tdvadm.t_arm_notafichaemerg w
     Where w.arm_nota_numero = pNota_numero
     And w.arm_nota_serie = pNota_serie 
     And Trim(w.glb_cliente_cgccpfremetente) = Trim(pRemetente_Cnpj);
     
     Commit;
   Else
         -- Erro Não posso excluir produtos quimicos     
        vRetorno.Status := pkg_fifo.Status_Erro;
        vRetorno.Message := 'Produto quimico já tem autorização, Nota não pode ser Alterada.' || chr(13) ;
        Return vRetorno;
        
   End If;    
  End If;
-- sirlano colocar aqui para guardar os produtos quimicos quando estiverem autorizados
-- 21/03/2014
  Begin
    
  
   -- Analise do Coleta e produto Quimico
   if (pColeta is not null) and (pCiclo is not null) then
     
     -- Busco Asn e Origem da ASN
     select k.xml_coleta_numero,
            k.arm_coletaorigem_cod
       into vNumeroAsn,
            vOrigemCol
       from tdvadm.t_arm_coleta k
      where k.arm_coleta_ncompra = pColeta 
        and k.arm_coleta_ciclo   = pCiclo;  
   
   end if; 

   -- Se tiver ASN e for da Nimbi validaremos
   if (vNumeroAsn is not null) and (vOrigemCol = '8') then   
      
      select asn.col_asn_numeroonu
        into vNumeroOnu
        from tdvadm.t_arm_coleta ll,
             tdvadm.t_col_asn asn
       where ll.arm_coleta_ncompra = pColeta
         and ll.arm_coleta_ciclo   = pCiclo
         and ll.arm_coleta_ncompra = asn.arm_coleta_ncompra
         and ll.arm_coleta_ciclo   = asn.arm_coleta_ciclo
         and asn.col_asn_dtgravacao = (select max(kl.col_asn_dtgravacao)
                                         from tdvadm.t_col_asn kl
                                         where kl.arm_coleta_ncompra = ll.arm_coleta_ncompra
                                           and kl.arm_coleta_ciclo   = ll.arm_coleta_ciclo  );       
   
      If ( vNumeroOnu is not null) then
     
         -- Cursor para validar oc procutos Quimicos da Nota X Coleta.
         For vCursorVal In ( Select extractvalue(value(field), 'Row/@num')      Linha,
                                    extractvalue(value(field), 'Row/codOnu')    CodOnu,
                                    extractvalue(value(field), 'Row/DescOnu')   DescOnu,
                                    extractvalue(value(field), 'Row/grp_Emb')   grp_Emb,
                                    extractvalue(value(field), 'Row/qtdeEmb')   qtdeEmb,
                                    extractvalue(value(field), 'Row/pesoEmb')   pesoEmb
                               From Table(xmlsequence( Extract(xmltype.createXml(pXmlEntrada) , '/Parametros/Inputs/Input/Tables/Table/Rowset/Row'))) field
                              where extractvalue(value(field), 'Row/codOnu') <> '9999'
                                and extractvalue(value(field), 'Row/codOnu') IS NOT NULL
                        )       
        
         Loop
           
           -- Numero Onu da ASN X Numero Onu da Nota
           if (vCursorVal.Codonu <> trim(vNumeroOnu)) then
              vIndOnusOk := vIndOnusOk;
           else
             vIndOnusOk := vIndOnusOk + 1;
           end if;
         
         end loop;  
         
         if (vIndOnusOk = 0) then
                
           vRetorno.Status  := pkg_fifo.Status_Erro;
           vRetorno.Message := 'Nenhun numero de ONU informado na nota corresponde com o numero ONU da ASN.';
           Return vRetorno;
          
         end if;
  
      else
      
         -- Cursor para verificar se foi informado numero ONU em uma nota que sua ASN não teve codigo informado.
         For vCursorVal In ( Select extractvalue(value(field), 'Row/@num')      Linha,
                                    extractvalue(value(field), 'Row/codOnu')    CodOnu,
                                    extractvalue(value(field), 'Row/DescOnu')   DescOnu,
                                    extractvalue(value(field), 'Row/grp_Emb')   grp_Emb,
                                    extractvalue(value(field), 'Row/qtdeEmb')   qtdeEmb,
                                    extractvalue(value(field), 'Row/pesoEmb')   pesoEmb
                               From Table(xmlsequence( Extract(xmltype.createXml(pXmlEntrada) , '/Parametros/Inputs/Input/Tables/Table/Rowset/Row'))) field
                              where extractvalue(value(field), 'Row/codOnu') <> '9999'
                                AND extractvalue(value(field), 'Row/codOnu') IS NOT NULL
                        )       
        
         Loop
           
          vExiteOnuN := vExiteOnuN + 1;
         
         end loop;  
         
         -- Se tiver ONU informada Diferente de 9999
         if (vExiteOnuN != 0) then
                
           vRetorno.Status  := pkg_fifo.Status_Erro;
           vRetorno.Message := 'Foi informado um Codigo de ONU para uma nota, mas sua ASN não é quimica.';
           Return vRetorno;
          
         end if;
         
      end if;
       
   end if;
  

  -- Cursor para Inserir os Produtos Quimicos da nota.  
  For vCursor In ( Select extractvalue(value(field), 'Row/@num')      Linha,
                          extractvalue(value(field), 'Row/codOnu')    CodOnu,
                          extractvalue(value(field), 'Row/DescOnu')   DescOnu,
                          extractvalue(value(field), 'Row/grp_Emb')   grp_Emb,
                          extractvalue(value(field), 'Row/qtdeEmb')   qtdeEmb,
                          extractvalue(value(field), 'Row/pesoEmb')   pesoEmb
                     From Table(xmlsequence( Extract(xmltype.createXml(pXmlEntrada) , '/Parametros/Inputs/Input/Tables/Table/Rowset/Row'))) field
                    Where extractvalue(value(field), 'Row/codOnu') IS NOT NULL     
                 Order By extractvalue(value(field), 'Row/codOnu') desc
                  )       
  
  Loop
    
    
    If nvl(vCursor.Codonu, 0) <> 0 Then
      vRetorno.onu_codigo  := vCursor.Codonu;
      vRetorno.onu_grpEmb  := vCursor.Grp_Emb;
      vRetorno.onu_qtdeEmb := replace(vCursor.Qtdeemb, ',', '.');
      vRetorno.onu_peso    := replace(vCursor.Pesoemb, ',', '.');
          
          
      vLinha.Arm_Nota_Numero             := pNota_numero;
      vLinha.Arm_Nota_Sequencia          := pNota_sequencia;
      vLinha.Arm_Nota_Serie              := pNota_serie;
      vLinha.Glb_Cliente_Cgccpfremetente := Trim(pRemetente_Cnpj);
      vLinha.Arm_Notafichaemerg_Seqficha := vCursor.Linha;
      vLinha.Glb_Onu_Codigo              := vCursor.Codonu;
      vLinha.Glb_Onu_Grpemb              := vCursor.Grp_Emb;
      vLinha.Arm_Notafichaemerg_Uniemb   := replace(vCursor.Qtdeemb, ',', '.');
      vLinha.Arm_Notafichaemerg_Peso     := replace(vCursor.Pesoemb, ',', '.');
      vLinha.Arm_Nota_Dtinclusao := Sysdate;
          
      Insert Into tdvadm.t_arm_notafichaemerg Values vLinha;
      Commit;
      Else
        vRetorno.onu_codigo := Null;
        vRetorno.onu_grpEmb := '';

    End If;
  End Loop;
                     
                     Commit;
     --Seto as variáveis para normal
     vRetorno.Status := pkg_fifo.Status_Normal;
     vRetorno.Message := ''; 
  Exception
    --Caso ocorra algum erro, seto a variável de status para erro, e defino uma mensagem de erro.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar inserir produtos químicos.' || chr(13) ||Sqlerrm ;
      Return vRetorno;
  End;  
  
  Return vRetorno;    
End;  

----------------------------------------------------------------------------------------------------------------
-- Função privada utilizada para administrar a vide-nota.                                                     --
----------------------------------------------------------------------------------------------------------------
Function FNP_Ins_VideNota( pDadosNota    pkg_fifo.tDadosNota ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno de uma função.
 vRetorno   pkg_fifo.tRetornoFunc;
 
 --Variável do tipo de linha, que será utilizado para facilitar a inserção.
 vVideNota    tdvadm.t_arm_notavide%Rowtype;
 
 vDtInclusao   t_arm_nota.arm_nota_dtinclusao%Type;
 
 --Variável que será utilizada para recuperar numero de di.
 vDi  t_arm_nota.arm_nota_di%Type;
 
 --Variavel para verificar se a Nota mãe foi digitada a mais de 5 dias.
 -- Sirlano 10/12/2019
 vDiasNMae  integer := 10;
Begin

 --Limpo as variável que serão utilizadas
 vRetorno.Status := '';
 vRetorno.Message := '';
 vRetorno.Controle := 0;  
 vDi := '';

 --Caso a variável de vide nota, venho com o Valore Zero, preciso verificar se havia alguma nota vinculada
 --para excluir o registro.
 If pDadosNota.nota_Vide = 0 Then
   Select 
     Count(*) Into vRetorno.Controle
   From
     t_arm_notavide  w
   Where
     w.arm_notavide_sequencia = pDadosNota.nota_Sequencia;
   Begin
     --Caso a variável controle seja maior que zero, exclui o registro.
     If vRetorno.Controle > 0 Then
       Delete t_arm_notavide w
       Where w.arm_notavide_sequencia = pDadosNota.nota_Sequencia;
       Commit;
     End If;  
       
     vRetorno.Status := pkg_glb_common.Status_Nomal;
     vRetorno.Message := '';
       
     Exception
       When Others Then
         vRetorno.Status := pkg_glb_common.Status_Erro;
         vRetorno.Message := 'Erro ao tentar excluir o vide da nota.' || chr(13) || Sqlerrm;
         Return vRetorno;
     End;  
   End If;  

 
 
 --Caso o vide nota, seja 1, primeiro verifico se a nota não já possui um registro de vide.
 If pDadosNota.nota_Vide = 1 Then
   Select Count(*) Into vRetorno.Controle From t_arm_notavide w
   Where w.arm_notavide_sequencia = pDadosNota.nota_Sequencia;
   
   --Se o retorno for igual a zero, então deve proceder com a inserção.
   If vRetorno.Controle = 0 Then
     --Primeiro vou verificar se a nota mae pode ser utilizada.
     Begin
       Select
         n.arm_nota_numero,
         n.arm_nota_serie,
         n.glb_cliente_cgccpfremetente,
         n.arm_nota_sequencia,
         n.arm_nota_dtinclusao,
         n.arm_nota_di
       Into
         vVideNota.Arm_Nota_Numero,
         vVideNota.Arm_Nota_Serie,
         vVideNota.Glb_Cliente_Cgccpfremetente,
         vVideNota.Arm_Nota_Sequencia,
         vDtInclusao,
         vDi
       From t_arm_nota  n
       Where n.arm_nota_numero = pDadosNota.vide_Numero
        And Trim(n.arm_nota_serie) = Trim(pDadosNota.vide_Serie)
        And Trim(n.glb_cliente_cgccpfremetente) = Trim(pDadosNota.vide_Cnpj)
        -- Devido a ter a nota mae digitada em armazens diferentes,
        -- Coloquei o armazem para diferenciar as notas
        -- Sirlano 18/12/2019
        and n.arm_armazem_codigo = pDadosNota.armazem_Codigo;
--        And Trim(n.glb_cliente_cgccpfremetente) = Trim(pDadosNota.Remetente_CNPJ);

     Exception
       When no_data_found Then
         vRetorno.Status := pkg_glb_common.Status_Erro;
         vRetorno.Message := 'Nota Fiscal Mãe, não encontrada.' || 
                             'Nota mae: ' || pDadosNota.vide_Numero || chr(10) ||
                             'Serie : ' || pDadosNota.vide_Serie || chr(10) ||
                             'Cnpj : ' || pDadosNota.vide_Cnpj;
         Return vRetorno;
        WHEN TOO_MANY_ROWS THEN
          vRetorno.Status := pkg_glb_common.Status_Erro;
         vRetorno.Message := 'Nota Fiscal Mãe, lançada mais de uma vez no sistema' || 
                             'Nota mae: ' || pDadosNota.vide_Numero || chr(10) ||
                             'Serie : ' || pDadosNota.vide_Serie || chr(10) ||
                             'Cnpj : ' || pDadosNota.vide_Cnpj;
         Return vRetorno;
     End; 
     
     --Verifico se a Nota mãe foi digitada a mais de 5 dias.
     -- Sirlano 10/12/2019
     -- mudei para 10 dias e mudei para variavel colocarei parametro
    
     If vRetorno.Status <> pkg_glb_common.Status_Erro Then
        If (Trunc(vDtInclusao) >= trunc(Sysdate) - vDiasNMae) Or ( nvl(Trim(vDi), 'R') <> 'R') Then
          vVideNota.Arm_Notavide_Numero          := pDadosNota.nota_numero;
          vVideNota.Arm_Notavide_Cgccpfremetente := pDadosNota.Remetente_CNPJ;
          vVideNota.Arm_Notavide_Serie           := pDadosNota.nota_serie;
          vVideNota.Arm_Notavide_Sequencia       := pDadosNota.nota_Sequencia;
       
          Insert Into t_arm_notavide Values vVideNota;
          Commit;
       
          vRetorno.Status := pkg_glb_common.Status_Nomal;
          vRetorno.Message := '';
          Return vRetorno;
        Else
          vRetorno.Status := pkg_glb_common.Status_Erro;
          vRetorno.Message := 'Nota Mãe invalida. '|| chr(13) ||
                              'Nota Mãe digitada a mais de ' || to_char(vDiasNMae) || ' dias' || chr(13) ||
                              'DTINC VALIDACAO => [ ' || to_char(vDtInclusao,'dd/mm/yyyy') || ' >= ' || to_char(sysdate,'dd/mm/yyyy') || ' - ' || to_char(vDiasNMae) || ']' || chr(13) ||
                              'Nr da DI ' || vDi || chr(13)   ;
          Return vRetorno;                    
       
        End If;
     End If;
  Else
     --Caso a nota já tenha Vide nota, não tomo nenhuma atitude.
        vRetorno.Status:= pkg_glb_common.Status_Nomal;
        vRetorno.Message := '';
  End If;
 End If;

 Return vRetorno;
  
End FNP_Ins_VideNota;  

----------------------------------------------------------------------------------------------------------------
-- Função Privada utilizada para inserir dados de Redespacho                                                  --
----------------------------------------------------------------------------------------------------------------
Function FNP_Ins_Redespacho( pXmlin In Varchar2,
                             pDadosNota In pkg_fifo.tDadosNota,
                             pMessage Out Varchar2
                            ) Return Boolean Is
 --Variável utilizada para recuperar os dados do CTRC
 vListaParams glbadm.pkg_listas.tListaParamsExec;                           
 
 --Variável utilizada para recuperar / criar mensagens
 vMessage Varchar2(20000)  ;
 
 --variável de linha, utilizada facilitar a inserção dos odados de redespacho.
 vLinha tdvadm.t_arm_notaredespacho%Rowtype;
 
 --variávelde controle
 vControl Integer;
 
 --Variáveis de controle de erro
 vCountErro Integer;
 vMessageErro Varchar2(30000);
 

Begin
  --inicializa as variáveis utilizadas nessa função
  vListaParams.delete();
  vMessage:= '';
  vControl := 0;
  
 vCountErro := 0;
 vMessageErro := '';

  
  Begin
    Select Count(*) 
       Into vControl 
    From tdvadm.t_arm_notaredespacho rs
    Where rs.arm_nota_numero = pDadosNota.nota_numero
     And rs.glb_cliente_cgccpfremetente = pDadosNota.Remetente_CNPJ
     And rs.arm_nota_serie = pDadosNota.nota_serie
     And rs.arm_nota_sequencia = pDadosNota.nota_Sequencia;
     
    Delete From tdvadm.t_arm_notaredespacho rs
    Where rs.arm_nota_numero = pDadosNota.nota_numero
     And rs.glb_cliente_cgccpfremetente = pDadosNota.Remetente_CNPJ
     And rs.arm_nota_serie = pDadosNota.nota_serie
     And rs.arm_nota_sequencia = pDadosNota.nota_Sequencia;
   
    Commit;  
     
    
    
    --recupero os dados da tabela de redespacho.
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsExec(lower(pXmlIn), vListaParams, vMessage, 'redespacho') ) Then
      --caso não tenha encontrado nenhum registro de redespacho, saio da função
      Return True;
    End If; 
    
    
--    If vListaParams.count > 0 Then
--      raise_application_error(-20001, 'Servicos Adicionais desativado temporariamente');
--    End If;
    
    
    
    --entro em laço, para recuperar os paramentros passados por xml
    For i In 1..vListaParams.count Loop
      --transfiro os dados da lista para a variável de linha
      If Trim(lower(vListaParams(i).ParamsName)) = 'glb_cliente_cgccpfcodigo'   Then vLinha.Arm_Notaredespacho_Cnpjctrc  := Trim(vListaParams(i).ParamsValue); End If;
      If Trim(lower(vListaParams(i).ParamsName)) = 'glb_tpcliend_codigo'        Then vLinha.Arm_Notaredespacho_Tpcliend  := UPPER(Trim(vListaParams(i).ParamsValue)); End If;
      If Trim(lower(vListaParams(i).ParamsName)) = 'con_conhecimento_codigo'    Then vLinha.Arm_Notaredespacho_Ctrc      := upper(Trim(vListaParams(i).ParamsValue)); End If;
      If Trim(lower(vListaParams(i).ParamsName)) = 'con_conhecimento_serie'     Then vLinha.Arm_Notaredespacho_Serie     := upper(Trim(vListaParams(i).ParamsValue)); End If;
      If Trim(lower(vListaParams(i).ParamsName)) = 'con_conhecimento_dtemissao' Then vLinha.Arm_Notaredespacho_Dtemissao := to_date(vListaParams(i).ParamsValue, 'dd/mm/yyyy'); End If;
      If Trim(lower(vListaParams(i).ParamsName)) = 'con_conhecimento_chavecte'  Then vLinha.Arm_Notaredespacho_Chavecte  := Trim(vListaParams(i).ParamsValue); End If;
      If Trim(lower(vListaParams(i).ParamsName)) = 'tpoperacao'                 Then vLinha.Arm_Notaservadd_Codigo       := upper(Trim(vListaParams(i).ParamsValue)); End If;

    End Loop;
    
    --adiciono os valores da nota fiscal.
    vLinha.Arm_Nota_Sequencia := pDadosNota.nota_Sequencia;
    vLinha.Arm_Nota_Numero := pDadosNota.nota_numero;
    vLinha.Glb_Cliente_Cgccpfremetente := pDadosNota.Remetente_CNPJ;
    vLinha.Arm_Nota_Serie := pDadosNota.nota_serie;
    
/*     --verifico se a coleta utilizada no lançamento d
    Select Count(*) Into vControl
    From t_arm_coleta col
    Where col.arm_coleta_ncompra = pDadosNota.coleta_Codigo
     And col.arm_coleta_ciclo = ( Select Max(scol.arm_coleta_ciclo) From t_arm_coleta scol
                                   Where scol.arm_coleta_ncompra = col.arm_coleta_ncompra
                                ) ;   
--     And col.arm_coleta_tpcompra = 'FCA';
    
    --Coleta diferente de FCA 
    If ( vControl = 0 ) Then
      vCountErro := vCountErro + 1;
      vMessageErro := vMessageErro || lpad(vCountErro, 2, '0') || ' - ' ||
                      'Apenas pode ser utilizada coletas do tipo "FCA", para operação de transbordo';
    End If;   
  */
  
    If vLinha.Arm_Notaservadd_Codigo In ('02X', '03X') Then
      vCountErro := vCountErro + 1;
      vMessageErro := vMessageErro || chr(10) || lpad(vCountErro, 2, '0') || ' - ' ||
                      'Serviço Adicional em desenvolvimento';
    End If;
    
    If ( Trunc(vLinha.Arm_Notaredespacho_Dtemissao) < Trunc(pDadosNota.nota_dtSaida) ) Then
      vCountErro := vCountErro + 1;
      vMessageErro := vMessageErro || chr(10) || lpad(vCountErro, 2, '0') || ' - ' ||
                      'Data de emissão do CTRC de Terceiro, maior que data de saida da nota.';
    End If;

    If ( Trunc(vLinha.Arm_Notaredespacho_Dtemissao) > trunc(Sysdate) ) Then
      vCountErro := vCountErro + 1;
      vMessageErro := vMessageErro || chr(10) || lpad(vCountErro, 2, '0') || ' - ' ||
                      'Data de emissão do CTRC de Terceiro, não pode ser uma data futura.';
    End If;    
    
    If vLinha.Arm_Notaservadd_Codigo In ('01') Then
       If ( nvl(Trim(vLinha.Arm_Notaredespacho_Ctrc), 'r') = 'r') Then
         vCountErro := vCountErro + 1;
         vMessageErro := vMessageErro || chr(10) || lpad(vCountErro, 2, '0') || ' - ' ||
                         'Número do CTRC originario não passado.';
       End If;
    End If;

    
    --Data de emissão do Conhecimento maior que 1 dia da data de saida da nota fiscal
    If  ( ( abs( Trunc(pDadosnota.nota_dtSaida) - trunc(vLinha.Arm_Notaredespacho_Dtemissao) ) > 1 ) and  (vLinha.Arm_Notaservadd_Codigo not In ('04','05','07')) ) Then
      vCountErro := vCountErro + 1;
      vMessageErro := vMessageErro || chr(10) || lpad(vCountErro, 2, '0') || ' - ' ||
                      'Data de Saida da Nota e maior que data de Emissao do CTe de Terceiro';
    End If;
    
    --Data de Emissão do conhecimento maior que 30 dias da data atual.
    -- Alterada de 30 para 05 dias em 30/04/2013 Sirlano 
    If ( abs( trunc(Sysdate) - trunc(vLinha.Arm_Notaredespacho_Dtemissao) ) > 120 ) Then
      vCountErro := vCountErro + 1;
      vMessageErro := vMessageErro || chr(10) || lpad(vCountErro, 2, '0') || ' - ' ||
                      'Emissão do CTRC Terceiro, há mais de 30 dias da data de hoje';
    End If;
    
    
    --Valido a chave do CTE, caso 
--    If ( nvl(vLinha.Arm_Notaredespacho_Chavecte, 'r') <> 'r' )  Then
      
--    End If;

    
    If ( vCountErro > 0 ) Then
      vMessageErro := CHR(10) || CHR(10) ||
                      '*********************************************************************' || CHR(10) ||
                      ' ERRO AO VALIDAR ENTRADA DE SERVIÇOS ADICIONAIS                      ' || CHR(10) ||
                      '   Abaixo lista de erros encontrado:                                 ' || CHR(10) || 
                      vMessageErro                                                            || CHR(10) ||
                      '*********************************************************************';  
                      
             
      raise_application_error(-20001, vMessageErro);
    End If;
    

    
    
    --insiro os dados na tabela de redespacho
    Insert Into t_arm_notaredespacho Values vLinha;
    Commit;

    --seto os paramentros de saida
    pMessage:= '';
    Return True;
  
  Exception
    --erro não previsto.
    When Others Then
      pMessage:= 'Erro ao recuperar dados de redespacho redespacho.' || chr(10) ||
                 'Rotina: tdvadm.pkg_fifo_recebimento.fnp_ins_redespacho(); ' || chr(10) ||
                 'Erro ora: ' || Sqlerrm;
      Return False;             
  End;
  
End;                             


----------------------------------------------------------------------------------------------------------------
-- Função Privada utilizada para Atualizar os Dados de Uma Nota.                                              -- 
----------------------------------------------------------------------------------------------------------------
Function FNP_AtualizaDadosNota( pDadosNota   pkg_fifo.tDadosNota,
                                pProdQuimicos pkg_fifo.tDadosProdutosQuimicos,
                                pUsuario      tdvadm.t_usu_usuario.usu_usuario_codigo%Type
                               ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno da função 
 vRetorno  pkg_fifo.tRetornoFunc; 
 
  vFlagProdQuimico Char(1) := '';
  
  vAuxiliarN  number;
  vAuxiliarT  varchar2(50);
  vColetaOrigem tdvadm.t_arm_coleta.arm_coletaorigem_cod%type;
  vColetaEntCol tdvadm.t_arm_coleta.arm_coleta_entcoleta%type;
  vLocalidade tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vIbge       tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
  vDescricao  tdvadm.t_glb_localidade.glb_localidade_descricao%type;

  vAuxiliarOrigemNota    tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vAuxiliarOrigemColeta  tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vAuxiliarLocalidadeArm tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vAuxiliarTipoColeta    char(1);
  
  vKGIsenta tdvadm.t_glb_onu.glb_onu_kgisenta%Type;
  
  --Variável de controle
  vControl integer;
  
  vNotaBalanca t_arm_nota.arm_nota_pesobalanca%type;
  vStatus char(1);
  vMessage varchar2(1000);
  
  vMercadoria   tdvadm.t_glb_mercadoria.glb_mercadoria_codigo%type;
  
  vRemtente     tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vDestinatario tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vSacado       tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;

  vNomeRemtente     tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vNomeDestinatario tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vNomeSacado       tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vPesoTotal        tdvadm.t_arm_notapesagem.arm_notapesagem_pesototal%type;
  vParamAlteraPeso  tdvadm.t_usu_perfil.usu_perfil_parat%type;
  vAuxiliar         Integer;
  --Variável de linha, utilizada 
 
 ------------------------------------------------------------
 --Função Interna apenas para formatar o peso
 ------------------------------------------------------------
 Function FNI_Peso(pPeso numeric) Return Char Is
   Begin
     Return TRIM(to_char(pPeso, '999G999G990D9999'));
   End;
   
 -------------------------------------------------------------  
 --Função interna apenas para formatar Valor  
 -------------------------------------------------------------
 Function FNI_Valor(pValor numeric) Return Char Is
   Begin
     Return TRIM(to_char(pValor, '999G999G990D99'));
   End;
 
 -------------------------------------------------------------  
 --Função interna apenas para mostrar o tipo de Requisição  
 -------------------------------------------------------------
 Function FNI_TpRequisicao(pCodigo Char) Return Char Is
     vRetorno  Char(15) := '';
   Begin
     vRetorno := Case nvl(Trim(pCodigo), 'R') 
                   When 'T' Then 'Tabela' 
                   When 'S' Then 'Solicitação' 
                   When 'R' Then ''
                 End ;
                 
     Return vRetorno;
   End;
   
  -------------------------------------------------------------
  -- Função interna apenas para mostrar o tipo do Sacado     --
  -------------------------------------------------------------
  Function FNI_Sacado( pCodigo Char) Return Char Is
    vRetorno Char(25):= '';
  Begin
    vRetorno := Case  Trim(pCodigo)
                  When 'R' Then 'Remetente' 
                  When 'D' Then 'Destinatário' 
                  When 'O' Then 'Consignatário / Outros'
                End;

    Return vRetorno;
  End;
  
 
  
Begin
  --Limpo as variáveis que serão utilizadas para garantir que não vou pegar lixo.
  vRetorno.Status := pkg_fifo.Status_Normal;
  vRetorno.Message := '';
  vRetorno.Controle := 0;
  
  --Procuro a nota apenas por precaução.
  Select 
    Count(*) Into vRetorno.Controle
  From 
    tdvadm.t_arm_nota   nota
  Where 
    nota.arm_nota_sequencia  = pDadosNota.nota_Sequencia;
  
  --Caso a Variáve de controle seja diferente de 1 não consegui localizar a nota correta.
  If vRetorno.Controle <> 1 Then
    vRetorno.Status := pkg_fifo.Status_Erro;
    vRetorno.Message := 'Nota para atualização não encontrada';
    Return vRetorno;
  End If;


  
  
  Begin
    If nvl(pProdQuimicos.onu_codigo, 0) = 0 Then
      vFlagProdQuimico := '';
    Else
      vFlagProdQuimico := 'S';
    End If;
    Begin
      
    -- ============================================================= -
    -- Alteração: Bloqueia se peso Balanca Diferente do Atual gravado, 
    -- Diego Lirio - 11/12/2013          
    Select Nvl(n.arm_nota_pesobalanca,1)
      Into vNotaBalanca
    From t_arm_nota n
    where n.arm_nota_sequencia = pDadosNota.nota_Sequencia;                  

    -- Pesquisa parâmetro que permite alterar peso balança
    select u.usu_perfil_parat
      into vParamAlteraPeso
    from tdvadm.T_USU_PERFIL u
    where lower(USU_APLICACAO_CODIGO) like '%pesonota%'
      and usu_perfil_codigo like '%ALTERA_PESAGEM%';         
           
    if (Nvl(vNotaBalanca,1) > 0) and (vParamAlteraPeso = 'N') then         
      if(pDadosNota.nota_pesoBalanca != vNotaBalanca) then
           Raise_Application_Error(-20001, 'Não será possivel Alterar Peso Balança. Procure alguém com autorização.');
      end if; 
    end if;   
    -- ============================================================= -          
    
    
   /*
      V erifica se existe os codigos do IBGE para as Localidades do envolvidos.
      sirlano - 26/06/2014
  */

  vRetorno.Message := '';
  -- Pega a localidade do Armazem
   Begin
     select a.glb_localidade_codigo
       into vAuxiliarLocalidadeArm 
     From t_arm_armazem a
     where a.arm_armazem_codigo = pDadosNota.armazem_Codigo;   
   Exception
     When NO_DATA_FOUND then
       vAuxiliarLocalidadeArm := null;
       vRetorno.Message := 'Não foi possivel encontrar a localidade do Armazem ' || pDadosNota.armazem_Codigo || chr(10) ;
     End ;

   Begin
      -- Verifique se a Colete tem um parceiro de coleta diferente do endereco da nota.
      select ce.glb_localidade_codigo
         into vAuxiliarOrigemColeta
      From t_arm_coletaparceiro p,
           t_glb_cliend ce
      where p.glb_cliente_cgccpfpar  = ce.glb_cliente_cgccpfcodigo
        and p.glb_tpcliend_codigopar = ce.glb_tpcliend_codigo
        and p.Arm_Coleta_Ncompra = pDadosNota.coleta_Codigo
        and p.Arm_coleta_ciclo   = pDadosNota.coleta_Ciclo
        and p.arm_coletatppar_codigo = 'CC';
   Exception
     WHEN NO_DATA_FOUND Then
        Begin
            select ce.glb_localidade_codigo
              into vAuxiliarOrigemColeta
            From t_arm_coleta co,
                 t_glb_cliend ce
            where co.glb_cliente_cgccpfcodigocoleta = ce.glb_cliente_cgccpfcodigo
              and co.glb_tpcliend_codigocoleta = ce.glb_tpcliend_codigo
              and co.Arm_Coleta_Ncompra = pDadosNota.coleta_Codigo
              and co.arm_coleta_ciclo = pDadosNota.coleta_Ciclo;
        exception
           When NO_DATA_FOUND Then
               vAuxiliarOrigemColeta:= null;
               vRetorno.Message := 'Não foi possivel encontrar a localidade da Coleta ' || pDadosNota.armazem_Codigo || chr(10) ;
           End ; 
   End; 

   Begin
       vAuxiliarT := 'REMETENTE';  
       select ce.glb_localidade_codigo,
              lo.glb_localidade_descricao,
              lo.glb_localidade_codigoibge
         into vLocalidade,
              vDescricao,
              vIbge
       from t_glb_cliend ce,
            t_glb_localidade lo  
       where ce.glb_cliente_cgccpfcodigo = pDadosNota.Remetente_CNPJ
         and ce.glb_tpcliend_codigo = pDadosNota.Remetente_tpCliente
         and ce.glb_localidade_codigo = lo.glb_localidade_codigo (+);
         if vLocalidade is null then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message || 'LOCALIDADE DO ' || vAuxiliarT || ' EM BRANCO' || chr(10);
            vDescricao := '';         
            vIbge := '';
         ElsIf vIbge is null Then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message ||  'IBGE DA LOCALIDADE ' || trim(vLocalidade || '-' || vDescricao) || ' DO ' || vAuxiliarT || ' NÃO ENCONTRADA' || chr(10);
            vIbge := '';
         End If ;  
   exception
     when NO_DATA_FOUND Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     When OTHERS Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     End;
     
     if vRetorno.Status = pkg_fifo.Status_Normal Then
        vAuxiliarOrigemNota := vLocalidade;
     End If;   

   Begin
       vAuxiliarT := 'DESTINATARIO';  
       select ce.glb_localidade_codigo,
              lo.glb_localidade_descricao,
              lo.glb_localidade_codigoibge
         into vLocalidade,
              vDescricao,
              vIbge
       from t_glb_cliend ce,
            t_glb_localidade lo  
       where ce.glb_cliente_cgccpfcodigo = pDadosNota.Destino_CNPJ
         and ce.glb_tpcliend_codigo = pDadosNota.Destino_tpCliente
         and ce.glb_localidade_codigo = lo.glb_localidade_codigo (+);
         if vLocalidade is null then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message || 'LOCALIDADE DO ' || vAuxiliarT || ' EM BRANCO' || chr(10);
            vDescricao := '';         
            vIbge := '';
         ElsIf vIbge is null Then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message ||  'IBGE DA LOCALIDADE ' || trim(vLocalidade || '-' || vDescricao) || ' DO ' || vAuxiliarT || ' NÃO ENCONTRADA' || chr(10);
            vIbge := '';
         End If  ; 
   exception
     when NO_DATA_FOUND Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     When OTHERS Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     End;
     

   Begin
       vAuxiliarT := 'SACADO';  
       select ce.glb_localidade_codigo,
              lo.glb_localidade_descricao,
              lo.glb_localidade_codigoibge
         into vLocalidade,
              vDescricao,
              vIbge
       from t_glb_cliend ce,
            t_glb_localidade lo  
       where ce.glb_cliente_cgccpfcodigo = pDadosNota.Sacado_CNPJ
         and ce.glb_tpcliend_codigo = pDadosNota.Sacado_tpCliente
         and ce.glb_localidade_codigo = lo.glb_localidade_codigo (+);
         if vLocalidade is null then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message || 'LOCALIDADE DO ' || vAuxiliarT || ' EM BRANCO' || chr(10);
            vDescricao := '';         
            vIbge := '';
         ElsIf vIbge is null Then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message ||  'IBGE DA LOCALIDADE ' || trim(vLocalidade || '-' || vDescricao) || ' DO ' || vAuxiliarT || ' NÃO ENCONTRADA' || chr(10);
            vIbge := '';
         End If ;
   exception
     when NO_DATA_FOUND Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO [' || pDadosNota.Sacado_CNPJ || ']-[' || pDadosNota.Sacado_tpCliente || ']' || chr(10);
         vDescricao := '';         
         vIbge := '';
     When OTHERS Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     End;


   Begin
       vAuxiliarT := 'COLETA';  
       select lo.glb_localidade_codigo,
              lo.glb_localidade_descricao,
              lo.glb_localidade_codigoibge
         into vLocalidade,
              vDescricao,
              vIbge
       from t_glb_localidade lo  
       where lo.glb_localidade_codigo = pDadosNota.Remetente_LocalCodigo;
         if vLocalidade is null then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message || 'LOCALIDADE DO ' || vAuxiliarT || ' EM BRANCO' || chr(10);
            vDescricao := '';         
            vIbge := '';
         ElsIf vIbge is null Then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message ||  'IBGE DA LOCALIDADE ' || trim(vLocalidade || '-' || vDescricao) || ' DO ' || vAuxiliarT || ' NÃO ENCONTRADA' || chr(10);
            vIbge := '';
         End If   ;
   exception
     when NO_DATA_FOUND Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     When OTHERS Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     End;

   Begin

       vAuxiliarT := 'ENTREGA';  
       select lo.glb_localidade_codigo,
              lo.glb_localidade_descricao,
              lo.glb_localidade_codigoibge
         into vLocalidade,
              vDescricao,
              vIbge
       from t_glb_localidade lo  
       where lo.glb_localidade_codigo = pDadosNota.Destino_LocalCodigo;
         if vLocalidade is null then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message || 'LOCALIDADE DO ' || vAuxiliarT || ' EM BRANCO' || chr(10);
            vDescricao := '';         
            vIbge := '';
         ElsIf vIbge is null Then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := vRetorno.Message ||  'IBGE DA LOCALIDADE ' || trim(vLocalidade || '-' || vDescricao) || ' DO ' || vAuxiliarT || ' NÃO ENCONTRADA' || chr(10);
            vIbge := '';
         End If   ;
   exception
     when NO_DATA_FOUND Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     When OTHERS Then
         vRetorno.Status := pkg_fifo.Status_Erro;
         vRetorno.Message := vRetorno.Message ||  'LOCALIDADE DO ' || vAuxiliarT || ' NAO LOCALIZADO' || chr(10);
         vDescricao := '';         
         vIbge := '';
     End;

--      if pDadosNota.nota_chaveNFE is not null then
--         if substr(pDadosNota.nota_chaveNFE,3,4) <> to_char(pDadosNota.nota_dtEntrada,'YYMM') Then
--            vRetorno.Status := pkg_fifo.Status_Erro;
--            vRetorno.Message := 'Emissao da Data Digitada errada! Nota Emitida em ' || substr(pDadosNota.nota_chaveNFE,5,2) || '/' || substr(pDadosNota.nota_chaveNFE,3,2);
--         End If;
--      End If;     


     if trim(pDadosNota.coleta_Tipo) = 'E' Then
        if trim(vAuxiliarLocalidadeArm) <> trim(pDadosNota.Remetente_LocalCodigo) Then
            vRetorno.Status  := pkg_fifo.Status_Erro;
            vRetorno.Message := 'Localidade de Origem Tem que SER o ARMAZEM quando ENTREGA';
        End If;
     Else   
        if trim(vAuxiliarOrigemColeta) <> trim(pDadosNota.Remetente_LocalCodigo) Then
            vRetorno.Status  := pkg_fifo.Status_Erro;
            vRetorno.Message := 'Localidade de Origem Tem que IGUAL AO DA COLETA';
        End If;
     End If;       




     if vRetorno.Status = pkg_fifo.Status_Erro Then
        return vRetorno;
     End If; 
     
     Begin
     select co.arm_coletaorigem_cod,
            co.arm_coleta_entcoleta
        into vColetaOrigem,
             vColetaEntCol
     from t_arm_coleta co
      where co.arm_coleta_ncompra = pDadosNota.coleta_Codigo
        and co.arm_coleta_ciclo = pDadosNota.coleta_Ciclo;
     Exception
       When NO_DATA_FOUND Then
         vColetaOrigem := 0;
         vColetaEntCol := 'X';
       end ;
   

     If vColetaOrigem = 0 Then
        vRetorno.Status := pkg_fifo.Status_Erro;
        vRetorno.Message := 'Coleta Não existe! ' || pDadosNota.coleta_Codigo ;
     End If;
     If vColetaOrigem <> 6 Then
        if vColetaEntCol <> pDadosNota.coleta_Tipo Then
           vRetorno.Status := pkg_fifo.Status_Erro;
           vRetorno.Message := 'Coleta Não pode ser alterada não foi feita no FIFO! ' || pDadosNota.coleta_Codigo ;
        End If;
     End If;
    -- Sirlano
    -- Atualiza Nota

--     If  vRetorno.Status =  pkg_fifo.Status_Normal Then 
        If  Not pkg_fifo_validadoresnota.FN_Valida_NotaColeta(pDadosNota,vMessage) Then 
            vRetorno.Status := pkg_glb_common.Status_Erro;
            vRetorno.Message := vRetorno.Message || vMessage;
            Return vRetorno;
        End If; 

--     End If;
    
      -- Se foi passado uma Solicitacao 
      If pDadosNota.nota_RequisTp = 'S' Then
         Begin
             select sf.glb_cliente_cgccpfcodigorem,
                    clr.glb_cliente_razaosocial,
                    sf.glb_cliente_cgccpfcodigodes,
                    cld.glb_cliente_razaosocial,
                    sf.glb_cliente_cgccpfcodigosac,
                    cls.glb_cliente_razaosocial,
                    sf.glb_mercadoria_codigo
               into vRemtente,
                    vNomeRemtente,
                    vDestinatario,
                    vNomeDestinatario,
                    vSacado,
                    vNomeSacado,
                    vMercadoria
             from tdvadm.t_slf_solfrete sf,
                  tdvadm.t_glb_cliente clr,
                  tdvadm.t_glb_cliente cld,
                  tdvadm.t_glb_cliente cls
             where sf.slf_solfrete_codigo = trim(lpad(trim(pDadosNota.nota_RequisCodigo),8,'0'))
               and sf.slf_solfrete_saque = trim(lpad(trim(pDadosNota.nota_RequisSaque),4,'0'))
               and sf.glb_cliente_cgccpfcodigorem = clr.glb_cliente_cgccpfcodigo
               and sf.glb_cliente_cgccpfcodigodes = cld.glb_cliente_cgccpfcodigo
               and sf.glb_cliente_cgccpfcodigosac = cls.glb_cliente_cgccpfcodigo;
         Exception
           When NO_DATA_FOUND Then
              vRemtente := '';
              vDestinatario := '';
              vSacado := '';
               vRetorno.Status := pkg_fifo.Status_Erro;
               vRetorno.Message := vRetorno.Message || 'Solicitacao não Existe ! [S]-[' || pDadosNota.nota_RequisCodigo || '] [SQ]-[' || pDadosNota.nota_RequisSaque || ']' || chr(10);
              
           end;  
         
         If vRetorno.Status = 'N' Then
         
             If ( vMercadoria <> pDadosNota.mercadoria_codigo ) Then
               vRetorno.Status := pkg_fifo.Status_Erro;
               vRetorno.Message := vRetorno.Message || 'MERCADORIA da Solicitcacao [' || vMercadoria || '] Diferente do da NOTA [' || pDadosNota.mercadoria_codigo || '] !' || chr(10);
             End If;
         
             If ( vRemtente <> pDadosNota.Remetente_CNPJ ) and ( instr(upper(vNomeRemtente),'DIVERSOS') = 0 ) Then
               vRetorno.Status := pkg_fifo.Status_Erro;
               vRetorno.Message := vRetorno.Message || 'CNPJ do Remetente difere do da Solicitação! [S]-[' || vRemtente || '] [N]-[' || pDadosNota.Remetente_CNPJ || ']' || chr(10);
             End If;
               
             If ( vDestinatario <> pDadosNota.Destino_CNPJ ) and ( instr(upper(vNomeDestinatario),'DIVERSOS') = 0 ) Then
               vRetorno.Status := pkg_fifo.Status_Erro;
               vRetorno.Message := vRetorno.Message || 'CNPJ do Destinatario difere do da Solicitação! [S]-[' || vDestinatario || '] [N]-[' || pDadosNota.Destino_CNPJ || ']' || chr(10);
             End If;

             If ( vSacado <> pDadosNota.Sacado_CNPJ ) and ( instr(upper(vNomeSacado),'DIVERSOS') = 0 ) Then
               vRetorno.Status := pkg_fifo.Status_Erro;
               vRetorno.Message := vRetorno.Message || 'CNPJ do Sacado difere do da Solicitação! [S]-[' || vSacado || '] [N]-[' || pDadosNota.Sacado_CNPJ || ']' || chr(10);
             End If;
         End If;     
      end If;   
      



     If  vRetorno.Status =  pkg_fifo.Status_Normal Then 
         
         -- Busca parâmetro para se tem acesso a alteração do Peso Balança
         select u.usu_perfil_parat
           into vParamAlteraPeso
         from tdvadm.T_USU_PERFIL u
         where lower(USU_APLICACAO_CODIGO) like '%pesonota%'
           and usu_perfil_codigo like '%ALTERA_PESAGEM%';
           
         -- Busca pesoBalanca na pesagem da nota 
         Begin     
           -- Select implementado para buscar o peso total da nota  
           select np.arm_notapesagem_pesototal 
             into vPesoTotal
           from tdvadm.t_arm_notapesagem np
           where np.arm_nota_numero = pDadosNota.nota_numero
             and np.arm_nota_sequencia = pDadosNota.nota_Sequencia
             and np.arm_nota_chavenfe = pDadosNota.nota_chaveNFE; 
                
           vAuxiliar := 1;     
         Exception
         WHEN NO_DATA_FOUND Then
              vAuxiliar := 0;           
         End;
         -- Fim busca pesagem  
         
         If (pDadosNota.nota_pesoBalanca <> NVL(vPesoTotal, 0)) Then
           -- Verivica se tem direito de alterar o Peso Balança
           If (vParamAlteraPeso = 'S') Then     
             vPesoTotal := pDadosNota.nota_pesoBalanca;  
           Else
             -- Atualiza Status para Liberada
             update tdvadm.t_arm_notapesagem pesagem 
              set pesagem.arm_notapesagem_status = 'L'
             where pesagem.arm_nota_numero = pDadosNota.nota_numero
                 and pesagem.arm_nota_sequencia = pDadosNota.nota_Sequencia
                 and pesagem.arm_nota_chavenfe = pDadosNota.nota_chaveNFE;
             -- Fim atualização pesagem
           End If;          
         End If; 

         --realizo o Update propriamente dito na tabela t_arm_nota, passando os novo dados.
         update t_arm_nota nota
          set 
            NOTA.ARM_NOTA_SERIE                  = pDadosNota.nota_serie,
    /*hABILITADO EM 01/03/2013 SIRLANO CANVERSAR COM ROGÉRIO*/
            NOTA.ARM_NOTA_DTRECEBIMENTO          = pDadosNota.nota_dtSaida,
      --      nota.arm_movimento_datanfentrada     = pDadosNota.nota_dtEmissao,
            nota.glb_mercadoria_codigo           = pDadosNota.mercadoria_codigo,
            nota.arm_nota_mercadoria             = pDadosNota.nota_descricao,
            nota.arm_nota_qtdvolume              = pDadosNota.nota_qtdeVolume,
            nota.arm_nota_valormerc              = pDadosNota.nota_ValorMerc,      
            nota.arm_nota_peso                   = pDadosNota.nota_pesoNota,
            nota.arm_nota_pesobalanca            = vPesoTotal,
            nota.arm_nota_chavenfe               = pDadosNota.nota_chaveNFE,
            nota.glb_cfop_codigo                 = pDadosNota.cfop_Codigo,
            nota.arm_nota_tabsol                 = pDadosNota.nota_RequisTp,
            nota.arm_nota_tabsolcod              = lpad( Trim(pDadosNota.nota_RequisCodigo), 8, '0'),
            nota.arm_nota_tabsolsq               = pDadosNota.nota_RequisSaque,
            nota.xml_notalinha_numdoc            = pDadosNota.nota_PO,
            nota.arm_nota_di                     = pDadosnota.nota_Di,
            nota.arm_nota_flagpgto               = pDadosNota.nota_flagPgto,
            nota.glb_tpcliend_codremetente       = pDadosNota.Remetente_tpCliente,
            nota.glb_tpcliend_coddestinatario    = pDadosNota.Destino_tpCliente,
            nota.arm_nota_vide                   = pDadosNota.nota_Vide,
            NOTA.GLB_CLIENTE_CGCCPFSACADO        = Trim(pDadosNota.Sacado_CNPJ),
            nota.glb_localidade_codigoorigem     = Trim(pdadosnota.Remetente_LocalCodigo),
            nota.arm_nota_onu                    = pProdQuimicos.onu_codigo,
            nota.arm_nota_grpemb                 = pProdQuimicos.onu_grpEmb,
            nota.arm_nota_flagonu                = vFlagProdQuimico,
            nota.con_tpdoc_codigo                = pDadosNota.nota_tpDocumento,
            nota.arm_coleta_tpcompra             = pDadosNota.coleta_Tipo,
            nota.glb_tpcarga_codigo              = nvl(pDadosNota.carga_Tipo,'CD'),
            nota.slf_contrato_codigo             = nvl(pDadosNota.nota_Contrato,nota.slf_contrato_codigo),
            nota.arm_nota_largura                = pDadosNota.nota_largura,
            nota.arm_nota_comprimento            = pDadosNota.nota_comprimento,
            nota.arm_nota_altura                 = pDadosNota.nota_altura,
            nota.arm_nota_flagemp                = pDadosNota.nota_EmpilhamentoFlag,
            nota.arm_nota_empqtde                = pDadosNota.nota_EmpilhamentoQtde,
            nota.arm_nota_qtdelimit              = pDadosNota.nota_qtdelimitada
            
            
          where 
            nota.arm_nota_sequencia = pDadosNota.nota_Sequencia;
            
          update t_arm_coleta co
            set co.arm_coleta_entcoleta = substr(trim(pDadosNota.coleta_Tipo),1,1)
          where co.arm_coleta_ncompra = pDadosNota.coleta_Codigo
            and co.arm_coleta_ciclo = pDadosNota.coleta_Ciclo
            and co.arm_coletaorigem_cod = '6';

          update t_arm_coleta co
            set co.arm_coleta_pedido = trim(substr(pDadosNota.nota_PO,1,30))
          where co.arm_coleta_ncompra = pDadosNota.coleta_Codigo
            and co.arm_coleta_ciclo = pDadosNota.coleta_Ciclo
            and co.arm_coleta_pedido is null;  

          

            
          -- VERIFICAR SE PODE ALTERAR A LOCALIDADE DE DESTINO
          -- Sirlano em 03/04/2014
          UPDATE T_ARM_CARGA CA
            SET CA.GLB_LOCALIDADE_CODIGODESTINO = pDadosNota.Destino_LocalCodigo
          WHERE CA.ARM_CARGA_CODIGO = pDadosNota.carga_Codigo;
     End If;   
      Exception
        When Others Then
          raise_application_error(-20001, 'Erro ao atualizar dados da nota' || Sqlerrm);
      End;  
      
      If ( nvl(Trim(pProdQuimicos.onu_codigo), 0 ) <> 0 ) Then
      SELECT GLB_ONU_KGISENTA Into vKGIsenta 
      FROM T_GLB_ONU 
      WHERE GLB_ONU_CODIGO = pProdQuimicos.onu_codigo And rownum = 1 ;
    End If;
      
    /*
    
    --Definir valores.
    vEmbalagem.Glb_Onu_Codigo := pCodOnu.onu_codigo;
    vEmbalagem.Arm_Embalagem_Pesoonu := pCodOnu.onu_peso;
    vEmbalagem.Glb_Onu_Kgisenta := vKGIsenta;
    */
      
    Update t_arm_embalagem  emb
      Set emb.glb_onu_codigo               = pProdQuimicos.onu_codigo,
          emb.glb_onu_kgisenta             = vKGIsenta,
          emb.arm_embalagem_pesoonu        = pProdQuimicos.onu_peso,
          emb.glb_tpcliend_coddestinatario = pdadosNota.Destino_tpCliente
    Where
      emb.arm_embalagem_numero = pdadosNota.embalagem_numero
      And emb.arm_embalagem_flag = pdadosNota.embalagem_flag
      And emb.arm_embalagem_sequencia = pDadosNota.embalagem_sequencia; 
      


       --Ajusta Dados da Nota para o Contrato
       vStatus := 'N';
       vMessage := '';
       pkg_slf_contrato.SP_SETPARTCONTRATO(pdadosNota.nota_numero,
                                           pdadosNota.Remetente_CNPJ,
                                           pdadosNota.nota_serie,
                                           vStatus,
                                           vMessage);
       If vMessage Is not null Then
          vRetorno.Message := vRetorno.Message || vMessage ;
       End If;

       If vStatus = 'E' Then
          vRetorno.Status := vStatus;
       End If;
       commit;                                    


    /*
   vControl := 0;
    
   Select Count(*) Into vControl 
   From t_arm_cargadet w
   Where w.arm_embalagem_numero = pDadosNota.embalagem_numero
     And w.arm_embalagem_flag = pDadosNota.embalagem_sequencia
     And w.arm_embalagem_sequencia = pDadosNota.embalagem_sequencia;

     
   If ( vControl  = 0 ) Then
     vRetorno := FNP_Ins_CargaDet(pDadosNota, pDadosnota.usu_usuario_codigo);
   End If;
    */
           
          
      if vRetorno.Status <> pkg_fifo.Status_Erro Then
          vRetorno.Status := pkg_fifo.Status_Normal;
          vRetorno.Message := '*********** 1 NOTA ATUALIZADA COM SUCESSO ***********'                                                || CHR(13) || CHR(13) ||
                              'Abaixo relação dos campos atualizados para a nota Fiscal: ' || pDadosNota.nota_numero               || chr(13) ||
                              '--------------------------------------------------'                                                 || chr(13) ||
                              'Serie: '             || pDadosNota.nota_serie                                                       || chr(13) ||
                              'Data de Saida: '     || pDadosNota.nota_dtSaida                                                     || chr(13) ||
                              'Data de Emissao: '   || pDadosNota.nota_dtEmissao                                                   || chr(13) ||

                              'Cod Mercadoria: '    || pDadosNota.mercadoria_codigo                                                      || chr(13) ||
                              'Desc. Mercadoria: '  || pDadosNota.nota_descricao                                                         || chr(13) ||
                              'Qtde de Volumes: '   || to_char( pDadosNota.nota_qtdeVolume )                                             || chr(13) ||
                              'Valor Mercadoria: '  || pDadosNota.nota_ValorMerc                                                         || chr(13) ||
                              'Peso Nota (Kilo): '  || FNI_Peso( pDadosNota.nota_pesoNota )                                              || chr(13) ||                              
                              'Peso Balança(Kilo): '|| vPesoTotal                                                                      || chr(13) ||
                              'Comprimento: '       || pDadosNota.nota_Comprimento                                                       || chr(13) ||
                              'Largura: '           || pDadosNota.nota_Largura                                                           || chr(13) ||
                              'Altura: '            || pDadosNota.nota_Altura                                                            || chr(13) ||
                              'Empilhamento : '     || pDadosNota.nota_EmpilhamentoFlag                                                  || chr(13) ||
                              'Qtde Empilhamento : '|| pDadosNota.nota_EmpilhamentoQtde                                                  || chr(13) ||
    --                          'Peso Balança(Kilo): '|| FNI_Peso( pDadosNota.nota_pesoBalanca )                                           || chr(13) || 
                              'Chave NFE: '         || pDadosNota.nota_chaveNFE                                                          || chr(13) ||
                              'Cod. CFOP: '         || pDadosNota.cfop_Codigo                                                            || chr(13) ||
                              'Tipo Requisição: '   || FNI_TpRequisicao( pDadosNota.nota_RequisTp )                                      || chr(13) ||
                              'Codigo Tab/Sol '     || lPad( Trim(pDadosNota.nota_RequisCodigo), 8, '0' )                                || chr(13) ||
                              'Saque Tab/Sol  '     || lpad( Trim(pDadosNota.nota_RequisSaque),  4, '0' )                                || chr(13) ||
                              'P.O.: '              || pDadosNota.nota_PO                                                                || chr(13) ||
                              'D.I.: '              || pDadosNota.nota_Di                                                                || chr(13) ||
                              'Sacado: '            || FNI_Sacado(pDadosNota.nota_flagPgto)                                              || chr(13) ||
                              'Tipo End. Rement:'   || pDadosNota.Remetente_tpCliente                                                    || chr(13) ||
                              'Local. Rementente: ' || pDadosNota.Remetente_LocalCodigo || '-' || pDadosNota.Remetente_LocalDesc         || chr(13) || 
                              'Tipo End. Destino: ' || pDadosNota.Destino_tpCliente                                                      || chr(13) ||
                              'Flag Vide Nota: '    || pDadosNota.nota_Vide                                                              || chr(13) ||
                              'Cnpj de Sacado: '    || pDadosNota.Sacado_CNPJ                                                            || chr(13) ||     
                              'Tipo de Documento: ' || pDadosNota.nota_tpDocumento                                                       || chr(13) || 
                              'Destino da Nota:   ' || trim(pDadosNota.Destino_LocalCodigo) || '-' || trim(pDadosNota.Destino_LocalDesc) || chr(13) ||
                              'Tipo Da Coleta:    ' || pDadosNota.coleta_Tipo                                                            || chr(13) ||  
                              'AuxiliarLOCArmazem:' || vAuxiliarLocalidadeArm                                                            || chr(13) ||
                              'AuxiliarLOCNota:   ' || vAuxiliarOrigemNota                                                               || chr(13) ||
                              'AuxiliarLOCColeta: ' || vAuxiliarOrigemColeta                                                             || chr(13) ||
                              'Tipo de Carga:     ' || nvl(pDadosNota.carga_Tipo,'CD')                                                   || chr(13) ||
                              'Qtde Limitada:     ' || pDadosNota.nota_qtdelimitada                                                      || chr(13) ||
                              'Contrato:          ' || pDadosNota.nota_Contrato                                                          || chr(13) ||
    --                          'Origem da Nota:    ' || pDadosNota.coleta_Tipo                                                            || chr(13) ||
                              'Msg ' || vStatus || '-' || trim(vRetorno.Message)  || chr(13) ||
                              '**************************************************';
           End If;       
  --Devolvo a Variável vRetorno.
  Return vRetorno;
                          
  Exception
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao Tentar atualizar os Dados da Nota Fiscal ' || pDadosNota.nota_numero || chr(10) ||
                          'Rotina: tdvadm.pkg_fifo_recebimento.()' || chr(10) ||
                          'Erro ora: ' || sqlerrm;    
      Return vRetorno;
  End;
  

  
End FNP_AtualizaDadosNota;   

Function Fn_Get_CodColetaOcorEncerDig return t_arm_coletaocor.arm_coletaocor_codigo%Type
As
vCodigo t_arm_coletaocor.arm_coletaocor_codigo%Type;
Begin
  Begin
     Select max(to_number(trim(oc.arm_coletaocor_codigo)))
       Into vCodigo
       From t_arm_coletaocor oc
       where oc.arm_coletaocor_flagativo = 'S'
         and oc.arm_coletaocor_encerradig = 'S';
  Exception
    When No_Data_Found Then
       Raise_Application_Error(-20001, 'Não foi possivel finalizar Digitação da Nota. Codigo de ocorrencia não encontrado!');
  End;             
     return vCodigo;       
End Fn_Get_CodColetaOcorEncerDig;

Procedure Sp_Set_UpdateOcorEncerraDig(pColeta In t_Arm_Coleta.Arm_Coleta_Ncompra%Type,
                                      pCiclo In t_Arm_Coleta.Arm_Coleta_Ciclo%Type,
                                      pStatus Out Char,
                                      pMessage Out Varchar2)
As
vCodigo t_arm_coletaocor.arm_coletaocor_codigo%Type;
Begin
  Begin
     vCodigo := Fn_Get_CodColetaOcorEncerDig();
         
      Update tdvadm.t_arm_coleta c
         set c.arm_coletaocor_codigo = vCodigo
       where c.arm_coleta_ncompra    = pColeta
         and c.arm_coleta_ciclo      = pCiclo
         and nvl(trim(c.arm_coletaocor_codigo),'88') <> '01';    
        
      pStatus := 'N';
      pMessage := 'Digitação das Notas para está Coleta Finalizada';           
  Exception
    When Others Then
       pStatus := 'E';
       pMessage := 'Não foi possivel finalizar Digitação da Nota: ' || sqlerrm;       
  End;   
   
              
End Sp_Set_UpdateOcorEncerraDig; 

----------------------------------------------------------------------------------------------------------------        
-- Procedure Privada utilizada para popular a variável de Notas, com os dados de Inserção                     --
----------------------------------------------------------------------------------------------------------------        
Procedure SPP_CompletaVarNotas( pDadosNota In Out pkg_fifo.tDadosNota,
                                pStatus    Out Char,
                                pMessage   Out Varchar2 ) Is
 vMessage Varchar2(10000);                                
Begin
  Begin
    --Através do Flag de Pagamento definir o Sacado.
    --Remetente.
    If Trim(pDadosNota.nota_flagPgto) = 'R' Then
      pDadosNota.Sacado_CNPJ      := pDadosNota.Remetente_CNPJ;
      pDadosNota.Sacado_tpCliente := pDadosNota.Remetente_tpCliente;
    End If;
    
    --Destinatário.
    If Trim(pDadosNota.nota_flagPgto) = 'D' Then
      pDadosNota.Sacado_CNPJ      := pDadosNota.Destino_CNPJ;
      pDadosNota.Sacado_tpCliente := pDadosNota.Destino_tpCliente;
    End If;
    
    If Trim(pDadosNota.nota_flagPgto) = 'O' Then
      pDadosNota.Sacado_tpCliente := 'C';
    End If;
    
    --Define o Tipo de Carga
    pDadosNota.carga_Tipo :=  Case Trim( pDadosNota.carga_Tipo )
                                When 'CA' Then 'FF'
                                When 'EX' Then 'EX'
                                Else pDadosNota.carga_Tipo
                              End;
                              
    If nvl(pDadosNota.NotaStatus,'N') = 'N' Then
      --Define o Código da Carga.            
      pDadosNota.carga_Codigo := arm_carga_codigo_sequencia.nextval;
    
      --Define os dados da embalagem
      pDadosNota.embalagem_numero    := s_arm_avulso_numero.nextval;
      pDadosNota.embalagem_sequencia := arm_embalagem_numero_sequencia.nextval;
      pDadosNota.embalagem_flag      := 'A';
    
      --Define a sequencia da Nota.
      pDadosNota.nota_Sequencia := arm_nota_numero_sequencia.nextval;
      
      --Data de inclusão
      pDadosNota.nota_dtEntrada := Sysdate;
    End If;                             
                    
    

    
    --Define o Flag de Status como normal, e não define nenhuma mensagem a principio.
    pStatus:= pkg_fifo.Status_Normal;
    pMessage := '';
  Exception
    When Others Then
      --Caso ocorra algum erro, seto o flag de Status para erro, e defino mensagem de erro.
      pStatus := pkg_fifo.Status_Erro;
      pMessage := 'Erro ao definir dados complementares para a Nota fiscal' || chr(13) || dbms_utility.format_call_stack;
  End;  
  
End SPP_CompletaVarNotas; 
                  

/***************************************************************************************************************/
/* Procedure utilizada para gerar um cursor para alimentar o grid principal da Aba Recebimento                 */
/***************************************************************************************************************/
procedure sp_getNotasRecebimentos( pNumNota      in  char,
                                   pCnpj         in  char,
                                   pEmbalagem    in  char,
                                   pCarregamento in  char,
                                   pColeta       in  char,
                                   pPo           in  char,
                                   pDataIni      in  char,
                                   pDataFim      in  char,
                                   pAxo          in  char,
                                   pArmazem      in  char,
                                   pCursor       out T_CURSOR,
                                   pStatus       out char,
                                   pMessage      out varchar2) AS

 /* Variável que será utilizada para gerar o SQL */
 vSelect varchar2(5000):= '';  

 /* Variável que será utilizada informar se foi passado algum paramentro */
 vCountParams integer := 0;

begin
  vSelect := ' SELECT ';
  vSelect := vSelect || '  ARM_ARMAZEM_CODIGO                                     #Armazem#,           ';
  vSelect := vSelect || '  trim(to_char(ARM_NOTA_NUMERO, §9999999999999§))        #N.F. Número#,       ';
  vSelect := vSelect || '  substr(Trim(GLB_CLIENTE_CGCCPFREMETENTE),    01, 15)   #CNPJ Remetente#,    ';
  vSelect := vSelect || '  substr(Trim(GLB_CLIENTE_CGCCPFDESTINATARIO), 01, 15)   #CNPJ Destinatario#, ';
  vSelect := vSelect || '  substr(ARM_EMBALAGEM_NUMERO, 01, 06)                   #Embalagem#,         ';
  vSelect := vSelect || '  ARM_COLETA_NCOMPRA                                     #Núm. Coleta#,       ';
  vSelect := vSelect || '  ARM_CARREGAMENTO_CODIGO                                #Carregamento#,      ';
  vSelect := vSelect || '  to_char(ARM_NOTA_DTINCLUSAO, §dd/mm/yyyy hh24:mi:ss§)  #Data Inclusão#,     ';
  vSelect := vSelect || '  GLB_TPCLIEND_CODREMETENTE                              #Tp. End.#,            ';
  vSelect := vSelect || '  substr(ORIGEM, 01, 25)                                 #Origem#,            ';
  vSelect := vSelect || '  GLB_TPCLIEND_CODDESTINATARIO                           #Tp. End.#,            ';
  vSelect := vSelect || '  substr(DESTINO, 01, 25)                                #Destino#,           ';
  vSelect := vSelect || '  REMETENTE                                              #Remetente#,         ';
  vSelect := vSelect || '  DESTINATARIO                                           #Destinatário#,      ';
  vSelect := vSelect || '  ARM_NOTA_QTDVOLUME                                     #Volume#,            ';
  vSelect := vSelect || '  ARM_NOTA_PESO                                          #Peso#,              ';  
  vSelect := vSelect || '  ALX                                                    #ALX#,               ';        
  vSelect := vSelect || '  substr(CTRC, 01, 10)                                   #C.T.C.R.#,          ';
  vSelect := vSelect || '  substr(ROTA, 01, 03)                                   #Rota#,              ';
  vSelect := vSelect || '  substr(SERIE, 01, 03)                                  #Série#,             ';
  vSelect := vSelect || '  USUARIO                                                #Usuário#,           ';
  vSelect := vSelect || '  TRANSFERIR_PARA                                        #Transferir Para#,   ';
  vSelect := vSelect || '  CHEKIN                                                 #Chekin #             ';
  vSelect := vSelect || ' FROM V_NOTA_RECEBIMENTO          ';
  vSelect := vSelect || ' WHERE ARM_NOTA_NUMERO >= 0       ';
  
  
  /* Código de Armazem */
  if (nvl(Trim(pArmazem), 'R' ) <> 'R') then
    vSelect := vSelect || ' and  ( ( ARM_ARMAZEM_CODIGO = §'|| pArmazem ||'§ ) or ( Trim(TRANSFERIR_PARA) = §'||pArmazem||'§) ) ';
    vCountParams := vCountParams +1;
  end if;
  
  /* Número de Nota Fiscal */
  if ( nvl(trim( pNumNota ), 'R' ) <> 'R' ) then
    vSelect := vSelect || ' AND ARM_NOTA_NUMERO =  §'||pNumNota||'§ '; 
    vCountParams := vCountParams +1;
  end if;
 
  /* Número de CNPJ */
  if (nvl(Trim( pCnpj ), 'R' ) <> 'R') then
    vSelect := vSelect || ' AND GLB_CLIENTE_CGCCPFREMETENTE like (§%'|| pCnpj ||'%§) ';
    vCountParams := vCountParams +1;
  end if;
  
  /* Numero de embalagem */
  if (nvl(Trim( pEmbalagem ), 'R' ) <> 'R') then
    vSelect := vSelect || ' AND ARM_EMBALAGEM_NUMERO = §'|| pEmbalagem ||'§ ';
    vCountParams := vCountParams +1;
  end if;
  
  /* Código Carregamento */
  if (nvl(Trim( pCarregamento ), 'R' ) <> 'R') then
    vSelect := vSelect || ' AND ARM_CARREGAMENTO_CODIGO = §'|| pCarregamento ||'§ ' ;
    vCountParams := vCountParams +1;
  end if;
  
  /* Numero da Coleta */
  if (nvl(Trim( pColeta ), 'R' ) <> 'R') then 
    vSelect := vSelect || ' AND ARM_COLETA_NCOMPRA = §'|| pColeta ||'§ ';
    vCountParams := vCountParams +1;
  end if;
  
  /* Número da PO */
  if (nvl(Trim( pPo ), 'R' ) <> 'R') then
    vSelect := vSelect || '  AND XML_NOTALINHA_NUMDOC like (§%'|| pPo ||'%§) ';
    vCountParams := vCountParams +1;
  end if;
  
  /* Intervalo de Datas de Pesquisa */
  if ( (nvl(Trim( pDataIni ), 'R' ) <> 'R') and (nvl(Trim( pDataFim ), 'R' ) <> 'R')  )  then
    vSelect := vSelect || ' AND TRUNC(ARM_NOTA_DTINCLUSAO) >= TO_DATE(§'|| TRIM(pDataIni)||'§, §DD/MM/YYYY§)' ;
    vSelect := vSelect || ' AND TRUNC(ARM_NOTA_DTINCLUSAO) <= TO_DATE(§'|| TRIM(pDataFim)||'§, §DD/MM/YYYY§)' ;
    vCountParams := vCountParams +1;
  end if;
  
  /* Código de Almoxerifado */
  if (nvl(Trim( pAxo ), 'R' ) <> 'R') then
    vSelect := vSelect || ' AND UPPER(GLB_CLIEND_CODCLIENTE) LIKE (§%'||TRIM(pAxo)||'%§)';
  end if;
  
  vSelect := replace(vSelect, '#', '"');
  vSelect := replace(vSelect, '§', '''');
  dbms_output.put_line(vSelect);

  /* Após a montagem do Select decido a atitude correta a tomar */
  begin
    /* Caso a Variável que conta os paramentros for maior que 1, ou seja, o Armazem e mais um paramentro */
    if ( vCountParams > 1 ) then
      /* Passo o Status para Normal, e abro o cursor de saida indiferente se o valor é 0 */
      pStatus := pkg_fifo.Status_Normal;
      pMessage := '';
      open pCursor for vSelect;
    else
      /* Caso a Variável seja igual a menor que 1, não foi passado paramentros necessárioa para a busca */
      pStatus := pkg_fifo.Status_Erro;
      pMessage := 'Falta de Paramentros para Busca ' || sqlerrm ;
    end if;
  exception
    /* Caso ocorra qualquer erro, devolve apenas o status e o erro para a aplicação */
    when others then
      pStatus := pkg_fifo.Status_Erro;
      pMessage := 'Erro ao gerar a consulta de Notas Fiscais' || sqlerrm;
  end;
  
end;
  
/*******************************************************************************************************************************/
/* Procedure utilizada para gerar um cursor com os dados de uma nota fiscal para edição. Essa edição partirá do grid principal */
/*******************************************************************************************************************************/                                   
procedure sp_getNotaFiscal( pNumNota       in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCnpjRemetente in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pCnpjDestino   in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pNumColeta     in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pNumEmbalagem  in tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pStatus        out char,
                            pMessage       out varchar2,
                            pCursor        out T_CURSOR) as
                            
begin
    Begin
/*      If pNumColeta = '979929' Then
        pmessage := 'Numero Nota: '|| pNumNota || chr(13) ||
                    'Cnpj Rementente: '|| pCnpjRemetente ||chr(13) ||
                    'Cnpj Destino : '|| pCnpjDestino ||chr(13) ||
                    'Numero Coleta : '|| pNumColeta ||chr(13) ||
                    'Embalagem: '|| pNumEmbalagem;
        pStatus := 'E';
        Return;
                  
      End If;
*/    
    
    Open pCursor for
      Select
       --Dados da Nota Fiscal
       nota.arm_nota_sequencia                sequencia,    --
       nota.arm_nota_numero                   numnota,      --
       nota.arm_nota_serie                    serie,        --
       nota.arm_movimento_datanfentrada       dtemissao,    --
       nota.arm_nota_dtrecebimento            dtsaida,      -- 
       nota.arm_nota_chavenfe                 chavenfe,     --
       nota.arm_nota_qtdvolume                qtdevolume,   --
       nota.arm_nota_peso                     pesonota,     --
       nota.arm_nota_pesobalanca              pesobalanca,  --
       nota.glb_mercadoria_codigo             codmercadoria,
       mercadorias.glb_mercadoria_descricao   descmercadorias,
       nota.arm_nota_valormerc                valornota,       --
       nota.arm_nota_mercadoria               descricao,
       
       --Dados de Dimensão
       nota.arm_nota_altura                   Altura,        --
       nota.arm_nota_largura                  Largura,       --
       nota.arm_nota_comprimento              comprimento,   --
       
       --Dados de Empilhamento 
       nota.arm_nota_flagemp                  FlagEmp,  --
       nota.arm_nota_empqtde                  QtdeEmp,  --
       
       --Dados de Cfop
       nota.glb_cfop_codigo                   codCfop,  --
       cfop.glb_cfop_descricao                DescCfop, --
       
       --Dados de Requisição
       nota.arm_nota_tabsol                   tpRequis,--
       nota.arm_nota_tabsolcod                CodRequis,--
       nota.arm_nota_tabsolsq                 SaqueSolic,--
       nota.slf_contrato_codigo               Contrato,--
       
       --Dados do Rementente
       nota.glb_cliente_cgccpfremetente       cnpjRemet,         --
       nota.glb_tpcliend_codremetente         TpCliRemet,        --
       cliRemet.Glb_Cliente_Razaosocial       RSocialRemet,      --
       endRemet.Glb_Cliend_Codcliente         CodCliRemet,       --
       EndRemet.Glb_Cliend_Endereco           EndRemetente,      --
       
       --Dados do Destino
       nota.glb_cliente_cgccpfdestinatario    cnpjdestino,     --
       nota.glb_tpcliend_coddestinatario      tpCliDestino,    --
       cliDestino.Glb_Cliente_Razaosocial     RSocialDestino,  --
       EndDestino.Glb_Cliend_Codcliente       CodCliDestino,   --
       endDestino.Glb_Cliend_Endereco         EndDestino,      -- 
       
       --Dados do Sacado
       nota.glb_cliente_cgccpfsacado          cnpjSacado,      --
       cliSacado.Glb_Cliente_Razaosocial      RSocialSacado,   --
       
       --Dados de Localidade "Origem / Destino"
       nota.glb_localidade_codigoorigem       CodOrigem,
       locOrigem.Glb_Localidade_Descricao     DescOrigem,
       EndDestino.glb_localidade_codigo       CodDestino,
       locDestino.Glb_Localidade_Descricao    DescDesino,
       
       nota.xml_notalinha_numdoc              PO,
       nota.arm_nota_di                       Di,
       nota.arm_nota_onu                      CodOnu,
       nota.arm_nota_grpemb                   GrupoEmbalagem,
       tabOnu.Glb_Onu_Produto                 DescProdOnu,

       --Dados de Armazem
       nota.arm_armazem_codigo                CodArmazem,   --
       armazem.arm_armazem_descricao          DescArmazem,  --
       
       --Dados da Rota
       nota.glb_rota_codigo                   CodRota,   --
       rota.glb_rota_descricao                DescRota,  --
       
       
       --Dados da Embalagem
       embalagem.arm_embalagem_numero         Emb_NumEmbalagem, --
       embalagem.arm_embalagem_flag           FlagEmbalagem,    --
       embalagem.arm_embalagem_sequencia      Emb_sequencia,    --
       
       nota.glb_tpcarga_codigo                NTpCarga,
       
       --Dados da Carga
       carga.arm_carga_codigo                 CodCarga,    --
       carga.glb_tpcarga_codigo               TpCarga,     --
       
       --dados de Carregamento
       ''                                     Carregamento,   --
       
       
       nota.arm_nota_vide                     VideNota,
       vide.arm_nota_sequencia                seqNotaMae,
       vide.arm_nota_numero                   NumNotaMae,
       vide.glb_cliente_cgccpfremetente       cnpjNotaMae,
       vide.arm_nota_serie                    SerieNotaMae,
      
      --Função que devolve o tipo de Sacado "0 = Remetente; 1=Destinatario; 2=Outros
       tdvadm.pkg_fifo_recebimento.fn_defineTpSacado( nota.glb_cliente_cgccpfremetente,
                                                      nota.glb_cliente_cgccpfdestinatario,
                                                      nota.glb_cliente_cgccpfsacado) TpSacado,
      
      --Dados da Coleta
      coleta.arm_coleta_ncompra               CodColeta,   --
      coleta.arm_coleta_tpcompra              tpColeta     --                                                   
                                                    

      From
        /* Relação das tabelas que faram parte do select */
        TDVADM.T_ARM_CARGA       carga,
        tdvadm.t_arm_embalagem   embalagem,
        tdvadm.t_arm_cargadet    cargadet,
        tdvadm.t_arm_nota        nota,
        tdvadm.t_glb_cfop        cfop,
        tdvadm.t_glb_cliente     CliRemet,
        tdvadm.t_glb_cliend      EndRemet,
        tdvadm.t_glb_cliente     CliDestino,
        tdvadm.t_glb_cliend      EndDestino,
        tdvadm.t_glb_cliente     CliSacado,
        tdvadm.t_glb_mercadoria  Mercadorias,
        tdvadm.t_glb_localidade  LocDestino,
        tdvadm.t_glb_localidade  LocOrigem,
        tdvadm.t_glb_onu         TabOnu,
        tdvadm.t_arm_armazem     armazem,
        tdvadm.t_glb_rota        Rota,
        tdvadm.t_arm_coleta      coleta,
        tdvadm.t_arm_notavide    Vide
                
            
      Where
      -- Ligação entre a T_ARM_CARGA com a T_ARM_CARGADET
      carga.arm_carga_codigo = cargadet.arm_carga_codigo
      
      --Ligação entre a T_ARM_CARGADET com a T_ARM_EMBALAGEM
      And cargadet.arm_embalagem_numero = embalagem.arm_embalagem_numero
      And cargadet.arm_embalagem_flag   = embalagem.arm_embalagem_flag
      And cargadet.arm_embalagem_sequencia = embalagem.arm_embalagem_sequencia
      
      --Ligação entre a T_ARM_CARGADET com a T_ARM_NOTA
      And cargadet.arm_nota_numero = nota.arm_nota_numero
      And cargadet.arm_nota_sequencia = nota.arm_nota_sequencia
      
      --Ligação entre a T_ARM_NOTA com a T_GLB_CFOP "Apenas para pegar a descrição do código de CFOP
      And nota.glb_cfop_codigo = cfop.glb_cfop_codigo (+)
      
      --Ligação entre a T_ARM_NOTA com a T_GLB_CLIENTE "Dados do Remetente"
      and Trim(nota.glb_cliente_cgccpfremetente) =  Trim(cliRemet.Glb_Cliente_Cgccpfcodigo)
      
      --Ligação entre a T_ARM_NOTA com a T_GLB_CLIEND "Dados do endereço do Rementente" Estou utilizando alter join, por causa das notas vindas da quadrem
      and trim(nota.glb_cliente_cgccpfremetente) =  Trim(endRemet.Glb_Cliente_Cgccpfcodigo(+))
      and nota.glb_tpcliend_codremetente         = endRemet.Glb_Tpcliend_Codigo(+)
      
      --Ligação entre a T_ARM_NOTA com a T_GLB_CLIENTE "Dados do Destinatário"
      and trim(nota.glb_cliente_cgccpfdestinatario) = trim(CliDestino.Glb_Cliente_Cgccpfcodigo)
      
      --Ligação entre a T_ARM_NOTA com a T_GLB_CLIEND "Dados do Endereço do Destinatário". Estou utilizando alter join, por causa das notas vindas da Quadrem
      And trim(nota.glb_cliente_cgccpfdestinatario) = trim(endDestino.Glb_Cliente_Cgccpfcodigo(+))
      and nota.glb_tpcliend_coddestinatario         = endDestino.Glb_Tpcliend_Codigo(+)
      
      --Ligação entre a T_ARM_NOTA com a T_GLB_CLIENTE "Dados do Sacado"
      and trim(nota.glb_cliente_cgccpfsacado) = trim(cliSacado.Glb_Cliente_Cgccpfcodigo)
      
      --Ligação entre a T_ARM_NOTA com a T_GLB_MERCADORIA "Apenas para pegar a descrição da Mercadoria
      and nota.glb_mercadoria_codigo = mercadorias.glb_mercadoria_codigo(+)
      
      --Ligação entre a T_GLB_CLIEND com a T_GLB_LOCALIDADE "Descrição de Localidade do Remetente.
      and EndRemet.Glb_Localidade_Codigo   = locOrigem.Glb_Localidade_Codigo(+)
      
      --Ligação entre a T_GLB_CLIEND com a T_GLB_LOCALIDADE "Descrição de Localidae do Destino.
      and EndDestino.glb_localidade_codigo = locDestino.Glb_Localidade_Codigo(+)
      
      --Ligação ente a T_ARM_NOTA e a T_GLB_ONU
      and nota.arm_nota_onu               = tabOnu.Glb_Onu_Codigo(+)
      
      --Ligação entre a T_ARM_NOTA e a T_ARM_ARMAZEM
      and nota.arm_armazem_codigo         = armazem.arm_armazem_codigo
      
      --Ligação entre a T_ARM_NOTA e a T_GLB_ROTA, estou utilizando o inner join pois o MONITOR_XML, não adiciona a rota
      and nota.glb_rota_codigo  =  rota.glb_rota_codigo(+)
      
      --Ligação entre a T_ARM_NOTA e a T_ARM_COLETA 
      and nota.arm_coleta_ncompra = coleta.arm_coleta_ncompra
      --Sirlano inserido em 20/12/2018
      and nota.arm_coleta_ciclo = coleta.arm_coleta_ciclo
      
      --Ligação da t_Arm_nota com a T_ARM_NOTAVIDE, estou utlizando o inner join pois apenas uma quantidade pequena de notas terá uma Nota de Vide.
      and nota.arm_nota_numero             = vide.arm_notavide_numero (+)
      and nota.glb_cliente_cgccpfremetente = vide.arm_notavide_cgccpfremetente (+)
      and nota.arm_nota_serie              = vide.arm_notavide_serie (+)


      and nota.arm_nota_numero                        = pNumNota
      and Trim( nota.glb_cliente_cgccpfremetente )    = Trim(pCnpjRemetente)
      and Trim( nota.glb_cliente_cgccpfdestinatario ) = Trim(pCnpjDestino)
      and Trim( nota.arm_coleta_ncompra )             = Trim(pNumColeta)
      -- Sirlano inserido em 20/12/2018
      and nota.arm_coleta_ciclo = (select max(co.arm_coleta_ciclo)
                                   from tdvadm.t_arm_coleta co
                                   where co.arm_coleta_ncompra = pNumColeta)
                                   
      and
        
       case 
         when nvl(pNumEmbalagem, 0) = 0 and 0 = 0 then 1
         when nvl(pNumEmbalagem, 0) <> 0 and nota.arm_embalagem_numero = Trim(pNumEmbalagem) then 1  
       END =1;
          
    pStatus := PKG_FIFO.Status_Normal;
    pMessage := '';
  exception
    when others then
      pStatus := PKG_FIFO.Status_Erro;
      pMessage := 'Erro ao buscar nota';
      
  end;
  
  
end;

  Procedure Sp_Get_NotasVencidas(pArm_armazem_codigo in varchar2,
                                 pDtEmissao in varchar2,
                                 pNota in varchar2,
                                 pCnpjRemetente in varchar2,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2) as
  mRegIni       int;
  mRegFin       int;
  vDiasVencida  number := -1;
  Begin
      If nvl(pNota,'SEMNOTA') = 'SEMNOTA' Then
         vDiasVencida := -1;
      Else
         vDiasVencida := -100;
      End If;
         
      mRegIni := 1+((pPagina-1)*10);
      mRegFin := 10*pPagina;
    begin
     open pCursor for
     select *
       from ( select topn.*, ROWNUM rnum
      from (       
      select 
      coleta.pkg_web_auxiliar.fn_retornaLinkNOTA(nf.arm_nota_numero, nf.glb_cliente_cgccpfremetente) as imagem,
      nf.arm_nota_dtinclusao,
      nf.arm_nota_sequencia,
      nf.arm_armazem_codigo,
      nf.arm_movimento_datanfentrada DataEmissao, 
      nf.arm_Nota_DTRecebimento DataSaida,
      nf.arm_nota_numero,
      nf.glb_cliente_cgccpfremetente,
      crem.glb_cliente_razaosocial glb_cliente_razaosocial,--crem.glb_cliente_razaosocial,
      nf.arm_nota_valormerc,
      nf.arm_nota_serie,
      max(nLib.Arm_Notaliberacao_Dtlib) as ultimaAutorizacao,
      endorigem.glb_estado_codigo UF_Origem, endorigem.glb_cliend_cidade Origem,
      enddest.glb_estado_codigo UF_Destino, enddest.glb_cliend_cidade Destino,
      tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(nf.arm_embalagem_numero, 
                                                          nf.arm_embalagem_flag, 
                                                          nf.arm_embalagem_sequencia,
                                                          'A','N','D') Validade
      from tdvadm.t_arm_nota nf 
      left outer join tdvadm.t_Arm_Notaliberacao nLib on nLib.Arm_Nota_Numero = nf.arm_nota_numero and nLib.Arm_Nota_Serie = nf.arm_nota_serie and trim(nLib.Glb_Cliente_Cgccpfcodigo) = trim(nf.glb_cliente_cgccpfremetente)
      left outer join tdvadm.t_glb_cliente crem on trim(nf.glb_cliente_cgccpfremetente) = trim(crem.glb_cliente_cgccpfcodigo)
      left outer join tdvadm.t_glb_cliente cdes on trim(nf.glb_cliente_cgccpfdestinatario) = trim(cdes.glb_cliente_cgccpfcodigo)
      left outer join tdvadm.t_glb_cliend endorigem on trim(crem.glb_cliente_cgccpfcodigo) = trim(endorigem.glb_cliente_cgccpfcodigo) and nf.glb_tpcliend_codremetente = endorigem.glb_tpcliend_codigo
      left outer join tdvadm.t_glb_cliend enddest on trim(cdes.glb_cliente_cgccpfcodigo) = trim(enddest.glb_cliente_cgccpfcodigo) and nf.arm_armazem_codigo like '06' and nf.glb_tpcliend_coddestinatario = enddest.glb_tpcliend_codigo
      where 0 = 0
        and nf.glb_cliente_cgccpfremetente like '%'||NVL(pCnpjRemetente,nf.glb_cliente_cgccpfremetente)||'%'
        and nf.arm_nota_numero like '%'||NVL(pNota,nf.arm_nota_numero)||'%'
        and tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(nf.arm_embalagem_numero, 
                                                                nf.arm_embalagem_flag, 
                                                                nf.arm_embalagem_sequencia,
                                                                'A',
                                                                'N',
                                                                'D') not in ('Nao definido',' D :: HS')
        and nf.arm_armazem_codigo like NVL(pArm_armazem_codigo,nf.arm_armazem_codigo)
        and to_number(substr(tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(arm_embalagem_numero, 
                                                                                 nf.arm_embalagem_flag, 
                                                                                 nf.arm_embalagem_sequencia,
                                                                                 'A',
                                                                                 'N',
                                                                                 'D'),1,2)) > vDiasVencida
                                                          
        and FN_NotasVencidas(nf.arm_nota_numero, 
                             nf.arm_nota_serie, 
                             nf.glb_cliente_cgccpfremetente) = 1 
        and ( nf.arm_carregamento_codigo is null  or nf.arm_carregamento_codigo not in ('0000000','0000001','0000002'))
        and nf.arm_armazem_codigo like pArm_armazem_codigo and nvl(nf.con_conhecimento_serie,'XXX') = 'XXX'
        and nf.arm_movimento_datanfentrada >= TO_DATE(pDtEmissao,'DD/MM/YYYY')
        -- Coloquei para pegar somenta as notas vencidas
        -- Sirlano 09/10/2017
        and nvl(nLib.Arm_Notaliberacao_Validade,trunc(sysdate-1)) < trunc(sysdate) 
        and to_date(nf.arm_movimento_datanfentrada,'dd/mm/yyyy') <= trunc(sysdate) 
      group by coleta.pkg_web_auxiliar.fn_retornaLinkNOTA(nf.arm_nota_numero,
                                                          nf.glb_cliente_cgccpfremetente),
               nf.arm_nota_dtinclusao,
               nf.arm_nota_sequencia,
               nf.arm_armazem_codigo,
               nf.arm_movimento_datanfentrada, 
               nf.arm_Nota_DTRecebimento,
               nf.arm_nota_numero,
               nf.glb_cliente_cgccpfremetente,
               crem.glb_cliente_razaosocial,--crem.glb_cliente_razaosocial,
               nf.arm_nota_valormerc,
               nf.arm_nota_serie, 
               endorigem.glb_estado_codigo,
               endorigem.glb_cliend_cidade,
               enddest.glb_estado_codigo, 
               enddest.glb_cliend_cidade,      
               tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(nf.arm_embalagem_numero, 
                                                                   nf.arm_embalagem_flag, 
                                                                   nf.arm_embalagem_sequencia,
                                                                   'A','N','D')      
      
      order by to_date(nf.arm_movimento_datanfentrada,'dd/mm/yyyy hh24:mi') 
       ) topn where ROWNUM <= mRegFin )
         where rnum  >= mRegIni;  
      
      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasVencidas. Erro.: '||sqlerrm;
      
    end;
    
  End Sp_Get_NotasVencidas;
  
  Procedure Sp_Get_NotasAprovadas(pDtAprovacao in varchar2,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2) as
  mRegIni int;
  mRegFin int;
  Begin
      mRegIni := 1+((pPagina-1)*10);
      mRegFin := 10*pPagina;
    begin
     open pCursor for
     select *
       from ( select topn.*, ROWNUM rnum
      from (       
      select 
      nf.arm_nota_numero,
      nf.glb_cliente_cgccpfcodigo,
      nf.arm_nota_serie,
      nf.arm_notaliberacao_dtlib,
      nf.arm_notaliberacao_validade,
      nf.arm_armazem_codigo,
      nf.arm_notaliberacao_origem,
      nf.usu_usuario_codigo
      from tdvadm.t_arm_notaliberacao nf 
      where 
      nf.arm_notaliberacao_dtlib >= pDtAprovacao
      order by nf.arm_notaliberacao_dtlib desc
       ) topn where ROWNUM <= mRegFin )
         where rnum  >= mRegIni;  
      
      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasAutorizacao. Erro.: '||sqlerrm;
      
    end;
    
  End Sp_Get_NotasAprovadas;  


  Procedure Sp_Get_NotasAprovadasCount( pDtAprovacao in varchar2,
                                   pStatus  out varchar2,
                                   pMessage out varchar2,
                                   pTotalPaginas out int) as
  Begin
    begin
      select count(*) into pTotalPaginas
      from tdvadm.t_Arm_Notaliberacao nf 
      where 
      nf.arm_notaliberacao_dtlib >= pDtAprovacao;
      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    exception when others then
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasAprovadasCount. Erro.: '||sqlerrm;
    end;
  End Sp_Get_NotasAprovadasCount;  
  
  
  
  Procedure Sp_Get_NotasVencidasCount(    pArm_armazem_codigo in varchar2,
                                          pDtEmissao in varchar2,
                                          pNota in varchar2,
                                          pCnpjRemetente in varchar2,
                                          pStatus  out varchar2,
                                          pMessage out varchar2,
                                          pTotalPaginas out int) as
  vDiasVencida  number := -2;
  Begin
      If nvl(pNota,'SEMNOTA') = 'SEMNOTA' Then
         vDiasVencida := -1;
      Else
         vDiasVencida := -100;
      End If;
    begin
      select count(*) into pTotalPaginas
      from tdvadm.t_arm_nota nf 
      left outer join tdvadm.t_glb_cliente crem on trim(nf.glb_cliente_cgccpfremetente) = trim(crem.glb_cliente_cgccpfcodigo)
      left outer join tdvadm.t_glb_cliente cdes on trim(nf.glb_cliente_cgccpfdestinatario) = trim(cdes.glb_cliente_cgccpfcodigo)
      left outer join tdvadm.t_glb_cliend endorigem on trim(crem.glb_cliente_cgccpfcodigo) = trim(endorigem.glb_cliente_cgccpfcodigo) and nf.glb_tpcliend_codremetente = endorigem.glb_tpcliend_codigo
      left outer join tdvadm.t_glb_cliend enddest on trim(cdes.glb_cliente_cgccpfcodigo) = trim(enddest.glb_cliente_cgccpfcodigo) and nf.arm_armazem_codigo like '06' and nf.glb_tpcliend_coddestinatario = enddest.glb_tpcliend_codigo
      where 0 = 0
        and nf.arm_nota_numero like '%'||NVL(pNota,nf.arm_nota_numero)||'%'
        and nf.glb_cliente_cgccpfremetente like '%'||NVL(pCnpjRemetente,nf.glb_cliente_cgccpfremetente)||'%'
        and tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(nf.arm_embalagem_numero, 
                                                                nf.arm_embalagem_flag, 
                                                                nf.arm_embalagem_sequencia,
                                                                'A',
                                                                'N',
                                                                'D') not in ('Nao definido',' D :: HS')
      
        and FN_NotasVencidas(nf.arm_nota_numero, 
                             nf.arm_nota_serie, 
                             nf.glb_cliente_cgccpfremetente) = 1
        and nf.arm_armazem_codigo like NVL(pArm_armazem_codigo,nf.arm_armazem_codigo)
        and to_number(substr(tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(nf.arm_embalagem_numero, 
                                                                                 nf.arm_embalagem_flag, 
                                                                                 nf.arm_embalagem_sequencia,
                                                                                 'A',
                                                                                 'N',
                                                                                 'D'),1,2)) > vDiasVencida
        and ( nf.arm_carregamento_codigo is null  or nf.arm_carregamento_codigo not in ('0000000','0000001','0000002'))
        and nf.arm_armazem_codigo like NVL(pArm_armazem_codigo,nf.arm_armazem_codigo) and nvl(nf.con_conhecimento_serie,'XXX') = 'XXX'
        and nf.arm_movimento_datanfentrada >= TO_DATE(pDtEmissao,'DD/MM/YYYY')
        and to_date(nf.arm_movimento_datanfentrada,'dd/mm/yyyy') <= trunc(sysdate) ;

      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    exception when others then
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasVencidasCount. Erro.: '||sqlerrm;
    end;
  End Sp_Get_NotasVencidasCount;  

/***************************************************************************************************************/
/* Procedure Utilizada para criar a Carga "T_ARM_CARGA"                                                           */
/***************************************************************************************************************/
Function fn_CriaCarga( pCargaCodigo     tdvadm.t_arm_carga.arm_carga_codigo%Type,
                       pRota            tdvadm.t_arm_carga.glb_rota_codigo%type,
                       pTpCarga         tdvadm.t_arm_carga.glb_tpcarga_codigo%type,
                       pCargaStatus     tdvadm.t_arm_carga.arm_status_codigo%type,
                       pCargaCubado     tdvadm.t_arm_carga.arm_carga_cubado%type,
                       pDtInclusao      tdvadm.t_arm_carga.arm_carga_dtinclusao%type,
                       pDtFechamento    tdvadm.t_arm_carga.arm_carga_dtfechado%type,
                       pQtdeVolume      tdvadm.t_arm_carga.arm_carga_qtdvolume%type,
                       pCargaPeso       tdvadm.t_arm_carga.arm_carga_peso%type,
                       pCodDestino      tdvadm.t_arm_carga.glb_localidade_codigodestino%type, 
                       pUsuario         tdvadm.t_arm_carga.usu_usuario_codigo%Type ) Return pkg_fifo.tRetornoFunc as

  --Variavel utilizada como retorno.                        
  vRetorno   pkg_fifo.tRetornoFunc;                       
begin
 
 Begin
   --Faz a Inserção dos dados na tabela "t_arm_carga
   insert into  tdvadm.t_arm_carga ( arm_carga_codigo,
                                     glb_rota_codigo,
                                     glb_tpcarga_codigo,
                                     arm_status_codigo,
                                     arm_carga_cubado,
                                     arm_carga_dtinclusao,
                                     arm_carga_dtfechado, 
                                     arm_carga_qtdvolume,
                                     arm_carga_peso,
                                     glb_localidade_codigodestino,
                                     usu_usuario_codigo
                                   ) 
                                   values
                                   (
                                     pCargaCodigo,
                                     pRota,
                                     pTpCarga,
                                     pCargaStatus,
                                     pCargaCubado,
                                     pDtInclusao,
                                     pDtFechamento,
                                     pQtdeVolume,
                                     pCargaPeso,
                                     pCodDestino,
                                     pUsuario );
                                     
                                     
    --Se não ocorrer nenhum erro, retonar o Status Normal.
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';

    Return vRetorno;
 exception
   --caso ocorra qualquer erro na inserção dos dados retona N
   when others then
     vRetorno.Status := pkg_fifo.Status_Erro;
     vRetorno.Message := sqlerrm;
     Return vRetorno;
 end;
    
End fn_CriaCarga;                       

/***************************************************************************************************************/
/* procedure utilizada para criar registro na t_arm_cargadet                                                   */
/***************************************************************************************************************/
Function fn_CriaCargaDet( pCargaCodigo   tdvadm.t_arm_cargadet.arm_carga_codigo%type,
                          pCargaDetSeq   tdvadm.t_arm_cargadet.arm_cargadet_seq%type,
                          pNotaSeq       tdvadm.t_arm_cargadet.arm_nota_sequencia%type,                           
                          pNotaNumero    tdvadm.t_arm_cargadet.arm_nota_numero%type,
                          pCnpjRemet     tdvadm.t_arm_cargadet.glb_cliente_cgccpfremetente%Type,
                          pEmbNumero     tdvadm.t_arm_cargadet.arm_embalagem_numero%type,
                          pEmbSeq        tdvadm.t_arm_cargadet.arm_embalagem_sequencia%type,
                          pEmbFlag       tdvadm.t_arm_cargadet.arm_embalagem_flag%type,
                          pUsuario       tdvadm.t_arm_cargadet.usu_usuario_codigo%Type ) Return pkg_fifo.tRetornoFunc as

 vRetorno   pkg_fifo.tRetornoFunc;                          
begin

  Begin
    INSERT INTO T_ARM_CARGADET ( ARM_CARGA_CODIGO,
                                 ARM_CARGADET_SEQ,
                                 ARM_NOTA_NUMERO,
                                 ARM_EMBALAGEM_NUMERO,
                                 ARM_EMBALAGEM_FLAG,
                                 USU_USUARIO_CODIGO,
                                 ARM_NOTA_SEQUENCIA,
                                 ARM_EMBALAGEM_SEQUENCIA,
                                 GLB_CLIENTE_CGCCPFREMETENTE
                                ) 
                                VALUES 
                                (
                                  pCargaCodigo, 
                                  pCargaDetSeq, 
                                  pNotaNumero,  
                                  pEmbNumero,   
                                  pEmbFlag,     
                                  pUsuario,     
                                  pNotaSeq,     
                                  pEmbSeq,      
                                  Trim(pCnpjRemet)
                                );
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';                            
    Return vRetorno;  
  exception
    when others then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := sqlerrm;
      
      Return  vRetorno;
  end;
                                    
  
End fn_CriaCargaDet;

/***************************************************************************************************************/
/* Procedure responsável por criar uma embalagem                                                               */                           
/***************************************************************************************************************/
Function fn_CriaEmbalagem(  pEmbNumero       tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                            pEmbSequencia    tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                            pEmbFlag         tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                            pCargaCodigo     tdvadm.t_arm_embalagem.arm_carga_codigo%Type,
                            pDtInclusao      tdvadm.t_arm_embalagem.arm_embalagem_dtinclusao%Type,
                            pDtFechamento    tdvadm.t_arm_embalagem.arm_embalagem_dtfechado%Type,
                            pEmbAltura       tdvadm.t_arm_embalagem.arm_embalagem_altura%Type,
                            pEmbLargura      tdvadm.t_arm_embalagem.arm_embalagem_largura%Type,
                            pEmbComprimento  tdvadm.t_arm_embalagem.arm_embalagem_comprimento%Type,
                            pTpCarga         tdvadm.t_arm_embalagem.arm_tpcarga_codigo%Type,
                            pCgnpDestino     tdvadm.t_arm_embalagem.glb_cliente_cgccpfdestinatario%Type,
                            pTpEndDesTino    tdvadm.t_arm_embalagem.glb_tpcliend_coddestinatario%Type,
                            pArmazem         tdvadm.t_arm_embalagem.arm_armazem_codigo%Type,
                            pUsuario         tdvadm.t_arm_embalagem.usu_usuario_codigo%Type,
                            pCodigoOnu       tdvadm.t_arm_embalagem.glb_onu_codigo%Type,
                            pPesoNota        tdvadm.t_arm_embalagem.arm_embalagem_peso%Type,
                            pPesoBalanca     tdvadm.t_arm_embalagem.arm_embalagem_pesobalanca%Type) Return Char Is 
 
 /* Variáveis Utilizadas para atribuir os valores para produtos Químicos "ONU" */
 vPesoOnu   tdvadm.t_arm_embalagem.arm_embalagem_pesoonu%Type := 0;
 vKGIsenta  tdvadm.t_arm_embalagem.glb_onu_kgisenta%Type      := 0;
 vCodOnu    tdvadm.t_arm_embalagem.glb_onu_codigo%Type;
 
Begin
 
 --Verifico se foi passado algum código Onu
 If ( nvl(Trim(pCodigoOnu), 0 ) <> 0 ) Then
   Begin
     --Pego a quantidade de KGIsenta
      SELECT GLB_ONU_KGISENTA Into vKGIsenta FROM T_GLB_ONU WHERE GLB_ONU_CODIGO = pCodigoOnu And rownum = 1 ;
      --Atribuo para o peso ONU, o mesmo peso da nota.
      vPesoOnu := pPesoNota;
      vCodOnu := pCodigoOnu;
   Exception
     --Caso não traga nenhum registro, é porque o código ONU, não é válido
     When Others Then
       Return pkg_fifo.Status_Erro;
   End;
 Else
   vCodOnu := Null;  
   
 End If;

 Begin
  
   
   
   /* faço a inserção do registro na t_arm_embalagem */   
   Insert Into tdvadm.t_arm_embalagem ( arm_embalagem_numero, 
                                        arm_embalagem_flag,
                                        arm_embalagem_sequencia,
                                        arm_carga_codigo,
                                        arm_embalagem_dtinclusao,
                                        arm_embalagem_dtfechado,
                                        arm_embalagem_altura,
                                        arm_embalagem_largura,
                                        arm_embalagem_comprimento,
                                        arm_tpcarga_codigo,
                                        glb_cliente_cgccpfdestinatario,
                                        glb_tpcliend_coddestinatario, 
                                        arm_embalagem_impresso,
                                        arm_armazem_codigo,
                                        usu_usuario_codigo,
                                        arm_embalagem_peso, 
                                        arm_embalagem_pesobalanca, 
                                        arm_embalagem_pesocobrado,
                                        glb_onu_codigo,
                                        arm_embalagem_pesoonu,
                                        glb_onu_kgisenta )
                                      Values
                                      ( pEmbNumero, 
                                        pEmbFlag,
                                        pEmbSequencia,
                                        pCargaCodigo,
                                        pDtInclusao,
                                        pDtFechamento,
                                        pEmbAltura,
                                        pEmbLargura,
                                        pEmbComprimento,
                                        pTpCarga,
                                        Trim(pCgnpDestino),
                                        pTpEndDesTino,
                                        'N',
                                        pArmazem, 
                                        pUsuario,
                                        pPesoNota,
                                        pPesoBalanca,
                                        0,
                                        vCodOnu,
                                        vPesoOnu,
                                        vKGIsenta  );
   
   
   
   Return pkg_fifo.Status_normal;
 Exception
   --Caso ocorra qualquer erro no momento da inserção, devolve a mensagem e Status de Erro.
   When Others Then
     Return pkg_fifo.Status_erro;

 End;
  
End fn_CriaEmbalagem;  

/**************************************************************************************************************************/
/* Função responsável por criar um registro na T_ARM_NOTA                                                                 */
/**************************************************************************************************************************/
Function fn_CriaNotaFiscal( pUsusario      tdvadm.t_arm_nota.usu_usuario_codigo%type, 
                            pNumNota       tdvadm.t_arm_nota.arm_nota_numero%type,
                            pNotaSeq       tdvadm.t_arm_nota.arm_nota_sequencia%type,
                            pSerie         tdvadm.t_arm_nota.arm_nota_serie%type,
                            pDtEmissao     tdvadm.t_arm_nota.arm_movimento_datanfentrada%type,
                            pDtInclusao    tdvadm.t_arm_nota.arm_nota_dtinclusao%type,
                            pDtSaida       tdvadm.t_arm_nota.arm_nota_dtrecebimento%type,
                            pMercadCod     tdvadm.t_arm_nota.glb_mercadoria_codigo%type,
                            pDescMercad    tdvadm.t_arm_nota.arm_nota_mercadoria%type,
                            pValorNota     tdvadm.t_arm_nota.arm_nota_valormerc%type,
                            pFlagEmp       tdvadm.t_arm_nota.arm_nota_flagemp%type,
                            pQtdeEmp       tdvadm.t_arm_nota.arm_nota_empqtde%type,
                            pTipoNota      tdvadm.t_arm_nota.arm_nota_tipo%type,
                            pVideNota      tdvadm.t_arm_nota.arm_nota_vide%type,
                            pNotaAtrb      tdvadm.t_arm_nota.arm_nota_atribuido%type,   --"S"
                            pNotaAtrbMov   tdvadm.t_arm_nota.arm_nota_atribui_movimento%type,
                            pPo            tdvadm.t_arm_nota.xml_notalinha_numdoc%type,
                            pDi            tdvadm.t_arm_nota.arm_nota_di%type,
                            pCnpjRemet     tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pTpEndRemet    tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,
                            pCnpjDestino   tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pTpEndDest     tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type, 
                            pCnpjSacado    tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,
                            pTpEndSacado   tdvadm.t_arm_nota.glb_tpcliend_codsacado%type,
                            pCodOrigem     tdvadm.t_arm_nota.glb_localidade_codigoorigem%type,
                            pTpRequis      tdvadm.t_arm_nota.arm_nota_tabsol%type,
                            pCodRequis     tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                            pSaqRequis     tdvadm.t_Arm_nota.arm_nota_tabsolsq%type,
                            pContrato      tdvadm.t_arm_nota.slf_contrato_codigo%type,
                            pFlagPgto      tdvadm.t_arm_nota.arm_nota_flagpgto%type,
                            pQtdeVolume    tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                            pLargura       tdvadm.t_arm_nota.arm_nota_largura%type,
                            pAltura        tdvadm.t_arm_nota.arm_nota_altura%type,
                            pComprimento   tdvadm.t_arm_nota.arm_nota_comprimento%type,
                            pCargaCod      tdvadm.t_arm_nota.arm_carga_codigo%type,
                            pTpCargaCod    tdvadm.t_arm_nota.glb_tpcarga_codigo%type,
                            pNumColeta     tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pTpCompra      tdvadm.t_arm_nota.arm_coleta_tpcompra%type,
                            pEmbNumero     tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pEmbFlag       tdvadm.t_arm_nota.arm_embalagem_flag%type,
                            pEmbSeq        tdvadm.t_arm_nota.arm_embalagem_sequencia%type,
                            pPesoNota      tdvadm.t_arm_nota.arm_nota_peso%type,
                            pPesoBalanca   tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                            pCubagem       tdvadm.t_arm_nota.arm_nota_cubagem%type,
                            pRota          tdvadm.t_arm_nota.glb_rota_codigo%type,
                            pArmazem       tdvadm.t_arm_nota.arm_armazem_codigo%type,
                            pChaveNFE      tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                            pCfop          tdvadm.t_arm_nota.glb_cfop_codigo%type,
                            pCodOnu        tdvadm.t_arm_nota.arm_nota_onu%type,
                            pGrpEmb        tdvadm.t_arm_nota.arm_nota_grpemb%type,
                            pNfe           tdvadm.t_arm_nota.arm_nota_nf_e%type,
                            pCTRCe         tdvadm.t_arm_nota.arm_nota_ctrc_e%type ) return char is
  vAuxiliar number;
  vArmazem  tdvadm.t_arm_armazem.arm_armazem_codigo%type;
  vStatus   char(1) := 'N';
  vMercadoria   tdvadm.t_glb_mercadoria.glb_mercadoria_codigo%type;
  vSacado       tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vRemetente    tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vDestinatario tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vRazaoCliente tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
begin
 Begin
   
       Begin
        select n.arm_armazem_codigo,
               count(*)
          into vArmazem,
               vAuxiliar
        from tdvadm.t_arm_nota n
        where n.arm_nota_chavenfe =  pChaveNFE
          and rpad(n.glb_cliente_cgccpfsacado,20) = rpad(pCnpjSacado,20)
        group by n.arm_armazem_codigo;
      exception
        When NO_DATA_FOUND Then
            vAuxiliar := 0;
        When OTHERS Then
            vAuxiliar := -1;
            vStatus := pkg_glb_common.Status_Erro;
        End;
      if nvl(vAuxiliar,0) > 0 Then
         vStatus := pkg_glb_common.Status_Erro;
      End If;

      If pCodOnu is null then
         select count(*)
           into vAuxiliar
         from t_glb_clientebloqueios cb
         where cb.glb_cliente_cgccpfcodigo = rpad(Trim(pCnpjRemet),20)
           and cb.glb_clientebloqueios_flagbloq = 'S'
           and cb.glb_clientebloqueios_dtdesbloq is null;
      
         If vAuxiliar <> 0 Then
             vStatus := pkg_fifo.Status_Erro;
            raise_application_error(-20001,'2 Fornecedor ja Transportou Quimico, Favor informar ONU ou 9999 para prosseguir...');
            Return pkg_fifo.Status_Erro;
         End If;   
      End If;

      If pTpRequis = 'S' Then
         select sf.glb_cliente_cgccpfcodigosac,
                sf.glb_cliente_cgccpfcodigorem,
                sf.glb_cliente_cgccpfcodigodes,
                sf.glb_mercadoria_codigo
           into vSacado,
                vRemetente,
                vDestinatario,
                vMercadoria
         From tdvadm.t_slf_solfrete sf
         where sf.slf_solfrete_codigo = lpad(trim(pCodRequis),8,'0') 
           and sf.slf_solfrete_saque = lpad(trim(pSaqRequis),4,'0');
         
         
      Else
         select decode(ta.slf_tabela_tipo,'CIF',ta.glb_cliente_cgccpfcodigo,null),
                null,
                null
           into vSacado,
                vRemetente,
                vDestinatario
         From tdvadm.t_slf_tabela ta
         where ta.slf_tabela_codigo = lpad(trim(pCodRequis),8,'0') 
           and ta.slf_tabela_saque = lpad(trim(pSaqRequis),4,'0');
      End If;
      
         
      If ( vMercadoria <> pMercadCod )  Then
          vStatus := pkg_fifo.Status_Erro;
          raise_application_error(-20001,'MERCADORIA da Solicitcacao [' || vMercadoria || '] Diferente do da NOTA [' || pMercadCod || '] !');
      End If;
         
      

      If vSacado is not null Then
        
         select upper(cl.glb_cliente_razaosocial)
           into vRazaoCliente
         from tdvadm.t_glb_cliente cl
         where cl.glb_cliente_cgccpfcodigo = vSacado;
         
         If instr(vRazaoCliente,'DIVERSOS') > 0 Then
            vSacado := null;
         End If;  
         
      End If;

      If vRemetente is not null Then
        
         select upper(cl.glb_cliente_razaosocial)
           into vRazaoCliente
         from tdvadm.t_glb_cliente cl
         where cl.glb_cliente_cgccpfcodigo = vRemetente;
         
         If instr(vRazaoCliente,'DIVERSOS') > 0 Then
            vRemetente := null;
         End If;  
         
      End If;

      If vDestinatario is not null Then
        
         select upper(cl.glb_cliente_razaosocial)
           into vRazaoCliente
         from tdvadm.t_glb_cliente cl
         where cl.glb_cliente_cgccpfcodigo = vDestinatario;
         
         If instr(vRazaoCliente,'DIVERSOS') > 0 Then
            vDestinatario := null;
         End If;  
         
      End If;


      If vSacado is not null Then
         If vSacado <> pCnpjSacado Then
            vStatus := pkg_fifo.Status_Erro;
            raise_application_error(-20001,'Sacado Sol/Tab [' || vSacado || '] Diferente na NOTA [' || pCnpjSacado || ']');
            Return pkg_fifo.Status_Erro;
         End If;
      End If;
      If vRemetente is not null Then
         If vRemetente <> pCnpjSacado Then
            vStatus := pkg_fifo.Status_Erro;
            raise_application_error(-20001,'Remetente Sol/Tab [' || vRemetente || '] Diferente na NOTA [' || pCnpjRemet || ']');
            Return pkg_fifo.Status_Erro;
         End If;
      End If;
      If vDestinatario is not null Then
         If vDestinatario <> pCnpjSacado Then
            vStatus := pkg_fifo.Status_Erro;
            raise_application_error(-20001,'Destinatario Sol/Tab [' || vDestinatario || '] Diferente na NOTA [' || pCnpjDestino || ']');
            Return pkg_fifo.Status_Erro;
         End If;
      End If;



 If vStatus <> 'N' Then
    raise_application_error(-20001,'Nota Ja Existe No ARMAZEM');
    Return pkg_fifo.Status_Erro;
 Else
   Insert Into T_ARM_NOTA ( usu_usuario_codigo, 
                            arm_nota_numero,
                            arm_nota_sequencia,
                            arm_nota_serie,
                            arm_movimento_datanfentrada,
                            arm_nota_dtinclusao,
                            arm_nota_dtrecebimento,
                            glb_mercadoria_codigo,
                            arm_nota_mercadoria,
                            arm_nota_valormerc,
                            arm_nota_flagemp,
                            arm_nota_empqtde,
                            arm_nota_tipo,
                            arm_nota_vide,
                            arm_nota_atribuido,
                            arm_nota_atribui_movimento,
                            xml_notalinha_numdoc,
                            arm_nota_di,
                            glb_cliente_cgccpfremetente,
                            glb_tpcliend_codremetente,
                            glb_cliente_cgccpfdestinatario,
                            glb_tpcliend_coddestinatario, 
                            glb_cliente_cgccpfsacado,
                            glb_tpcliend_codsacado,
                            glb_localidade_codigoorigem,
                            arm_nota_tabsol,
                            arm_nota_tabsolcod,
                            arm_nota_tabsolsq,
                            slf_contrato_codigo,
                            arm_nota_flagpgto,
                            arm_nota_qtdvolume,
                            arm_nota_largura,
                            arm_nota_altura,
                            arm_nota_comprimento,
                            arm_carga_codigo,
                            glb_tpcarga_codigo,
                            arm_coleta_ncompra,
                            arm_coleta_tpcompra,
                            arm_embalagem_numero,
                            arm_embalagem_flag,
                            arm_embalagem_sequencia,
                            arm_nota_peso,
                            arm_nota_pesobalanca,
                            arm_nota_cubagem,
                            glb_rota_codigo,
                            arm_armazem_codigo,
                            arm_nota_chavenfe,
                            glb_cfop_codigo,
                            arm_nota_onu,
                            arm_nota_grpemb,
                            arm_nota_nf_e,
                            arm_nota_ctrc_e
   ) Values (
                            pUsusario, 
                            pNumNota,
                            pNotaSeq,
                            pSerie,
                            pDtEmissao,
                            pDtInclusao,
                            pDtSaida,
                            pMercadCod,
                            pDescMercad,    
                            pValorNota,     
                            pFlagEmp,       
                            pQtdeEmp,       
                            pTipoNota,      
                            pVideNota,      
                            pNotaAtrb,      
                            pNotaAtrbMov,   
                            pPo,        
                            pDi,    
                            Trim(pCnpjRemet),     
                            pTpEndRemet,    
                            Trim(pCnpjDestino),   
                            pTpEndDest,     
                            Trim(pCnpjSacado),    
                            pTpEndSacado,   
                            pCodOrigem,     
                            pTpRequis,      
                            pCodRequis,     
                            lpad(pSaqRequis, 4, '0'),
                            pContrato,      
                            pFlagPgto,      
                            pQtdeVolume,    
                            pLargura,       
                            pAltura,        
                            pComprimento,   
                            pCargaCod,      
                            pTpCargaCod,   
                            pNumColeta,     
                            pTpCompra,      
                            pEmbNumero,     
                            pEmbFlag,       
                            pEmbSeq,        
                            pPesoNota,      
                            0, --pPesoBalanca,   
                            pCubagem,       
                            pRota,          
                            pArmazem,       
                            pChaveNFE,      
                            pCfop,          
                            pCodOnu,        
                            pGrpEmb,        
                            pNfe,           
                            pCTRCe         
                            );
   
   
      Return pkg_fifo.Status_Normal;
   End If;
 Exception 
   When Others Then
     raise_application_error(-20001, Sqlerrm);
--     Return PKG_FIFO.Status_Erro;
 End;
  
  
  
end fn_CriaNotaFiscal;

/**************************************************************************************************************************/
/* Procedure responsável por inserir uma nota no banco a partir do Recebimento com todas as suas dependencias             */
/**************************************************************************************************************************/
procedure sp_inserirDadosNota( pOrigemNota   in char,                                                  --Ação a ser tomada "Inserção / Edição"
                               pSequencia    in tdvadm.t_arm_nota.arm_nota_sequencia%type,             --Sequencia para t_arm_nota
                               pNota         in tdvadm.t_arm_nota.arm_nota_numero%type,                --Numero da Nota Fiscal  
                               pSerie        in tdvadm.t_arm_nota.arm_nota_serie%type,                 --Série para a Nota Fiscal 
                               pDtEmissao    in varchar2,                                              --Data de Emissão da Nota 
                               pDtSaida      in varchar2,                                              --Data de Saida da Nota
                               pTpNota       in tdvadm.t_arm_nota.arm_nota_tipo%type,                  --Tipo da Nota "Fifo=D"
                               pRota         in tdvadm.t_arm_nota.glb_rota_codigo%type,                 
                               pArmazem      in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                               pTpCarga      in tdvadm.t_arm_nota.glb_tpcarga_codigo%type,
                               pCnpjRemet    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pTpEndRemet   in tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,
                               pCnpjDestino  in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type, 
                               pTpEndDestino in tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type,
                               pCnpjOutros   in varchar2,
                               pSacado       in char,                                                  --Tipo de Sacado / FlagPgto "R=Remetente", "D=Destino", "O=Outros"
                               pLocOrigem    in tdvadm.t_arm_nota.glb_localidade_codigoorigem%type,    --Codigo de Localidade de Origem
                               pLocDestino   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,    --Codigo de Localidade de Destino
                               pAltura       in tdvadm.t_arm_nota.arm_nota_altura%type,                --Altura 
                               pLargura      in tdvadm.t_arm_nota.arm_nota_largura%type,               --Largura
                               pComprimento  in tdvadm.t_arm_nota.arm_nota_comprimento%type,           --Comprimento
                               pFlagEmp      in tdvadm.t_arm_nota.arm_nota_flagemp%type,
                               pQtdeEmp      in tdvadm.t_arm_nota.arm_nota_empqtde%type,
                               pMercadoria   in tdvadm.t_arm_nota.glb_mercadoria_codigo%type,
                               pVlrMercad    in tdvadm.t_arm_nota.arm_nota_valormerc%type,
                               pDescricao    In tdvadm.t_arm_nota.arm_nota_mercadoria%Type,
                               pQtdeVolume   in tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                               pPesoNota     in tdvadm.t_arm_nota.arm_nota_peso%type,
                               pPesoBalanca  in tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                               pCubagem      in tdvadm.t_arm_nota.arm_nota_cubagem%type,
                               pChaveNfe     in tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                               pCfop         in tdvadm.t_arm_nota.glb_cfop_codigo%type,
                               pDi           in tdvadm.t_arm_nota.arm_nota_di%type,
                               pContrato     in tdvadm.t_arm_nota.slf_contrato_codigo%type,
                               pTpRequis     in tdvadm.t_arm_nota.arm_nota_tabsol%type,
                               pRequisCod    in tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                               pSaqueRequis  in tdvadm.t_arm_nota.arm_nota_tabsolsq%type,
                               pCodOnu       in tdvadm.t_arm_nota.arm_nota_onu%type,
                               pGrpEmbOnu    in tdvadm.t_arm_nota.arm_nota_grpemb%type,
                               pColeta       in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                               pTpColeta     in tdvadm.t_arm_nota.arm_coleta_tpcompra%type,
                               pPO           in tdvadm.t_arm_nota.xml_notalinha_numdoc%type,     
                               pNotaVide     in tdvadm.t_arm_nota.arm_nota_vide%type,
                               pUsuario      in tdvadm.t_arm_nota.usu_usuario_codigo%type,             --Usuario que está fazendo a inserção da nota
                               pVideSeq      In Integer,
                               pVideNumNota  In Integer,
                               pVideSerie    In Char,
                               pVideCnpj     In Char,
                               pStatus       out char,
                               pMessage      out Varchar2
                                ) As
                                
-- vParamsEntrada varchar(32500);
                                      
 /* Variáveis utilizadas para armazenar números iniciais */
 vCargaCodigo   Integer := 0;  -- Código de Carga
 vCargaDetSeq   Integer := 0;  --Sequencia de Detalhe de Carregamento
 vEmbNumero     Integer := 0;  -- Numero de Embalagem
 vEmbSequencia  Integer := 0;  -- Sequencia Embalagem
 vFlagEmbalagem Char(01):= ''; -- Flag Embalagem
 vNotaSequencia Integer := 0;  -- Sequencia de Nota

 vDadosNota   pkg_fifo.tDadosNota;

 vArm_Carga_codigo tdvadm.t_arm_carga.arm_carga_codigo%type;
 
 vNotaBalanca t_arm_nota.Arm_Nota_Pesobalanca%Type; -- Criado para condicao (Diego)
 
 /* Varuiável utilizada para armazenar o tipo de Carga */
 vTpCarga Char(02);
 
 /* Variáveis utilizadas para carregar o CNPJ e tipo de endereço do SACADO */
 vCnpjSacado     tdvadm.t_glb_cliend.glb_cliente_cgccpfcodigo%type := '';
 vTpEndSacado    tdvadm.t_glb_cliend.glb_tpcliend_codigo%type := '';
 
 vControle Char(01) := '';
 
 vRetorno pkg_fifo.tRetornoFunc;
 
 vParamsEntrada Varchar2(32000);  
 
 vAuxLocalidade tdvadm.t_glb_localidade.glb_localidade_codigo%type;
 
 vDadosValid pkg_fifo.tDadosNotaValidacao; 
 vParamAlteraPeso tdvadm.t_usu_perfil.usu_perfil_parat%type;
 
 vCount Integer := 0;                         
Begin


/*
If Trim(pUsuario) = 'kjesus' Then
      vParamsEntrada := 'Origem Nota:  '|| pOrigemNota   || chr(13); 
      vParamsEntrada := vParamsEntrada || 'Sequ. Nota:   '|| pSequencia    || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Numero Nota:  '|| pNota         || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Serie Nota:   '|| pSerie        || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Data Emissao: '|| pDtEmissao    || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Data Saida:   '|| pDtSaida      || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Tipo Nota:    '|| pTpNota       || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Rota:         '|| pRota         || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Armazem:      '|| pArmazem      || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Tipo Carga:   '|| pTpCarga      || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Cnpj Remet:   '|| pCnpjRemet    || chr(13);  
      vParamsEntrada := vParamsEntrada || 'Tp End Remet: '|| pTpEndRemet   || chr(13); 
      vParamsEntrada := vParamsEntrada || 'Cnpj Destino: '|| pCnpjDestino  || chr(13);
      vParamsEntrada := vParamsEntrada || 'Tp End Dest.: '|| pTpEndDestino || chr(13);
      vParamsEntrada := vParamsEntrada || 'Cnpj Outros:  '|| pCnpjOutros   || chr(13);
      vParamsEntrada := vParamsEntrada || 'Tipo Sacado:  '|| pSacado       || chr(13);
      vParamsEntrada := vParamsEntrada || 'Loc Origem:   '|| pLocOrigem    || chr(13);
      vParamsEntrada := vParamsEntrada || 'Loc Destino:  '|| pLocDestino   || chr(13);
      vParamsEntrada := vParamsEntrada || 'Altura:       '|| pAltura       || chr(13);
      vParamsEntrada := vParamsEntrada || 'Largura:      '|| pLargura      || chr(13);
      vParamsEntrada := vParamsEntrada || 'Comprimento:  '|| pComprimento  || chr(13);
      vParamsEntrada := vParamsEntrada || 'Flag Emp.:    '|| pFlagEmp      || chr(13);
      vParamsEntrada := vParamsEntrada || 'Qtde Emp.:    '|| pQtdeEmp      || chr(13);
      vParamsEntrada := vParamsEntrada || 'Cod Mercad.:  '|| pMercadoria   || chr(13);
      vParamsEntrada := vParamsEntrada || 'Valor Nota:   '|| pVlrMercad    || chr(13);
      vParamsEntrada := vParamsEntrada || 'Descricao:    '|| pDescricao    || chr(13);
      vParamsEntrada := vParamsEntrada || 'Qtde Volume:  '|| pQtdeVolume   || chr(13);
      vParamsEntrada := vParamsEntrada || 'Peso Nota:    '|| pPesoNota     || chr(13);
      vParamsEntrada := vParamsEntrada || 'Peso Balança: '|| pPesoBalanca  || chr(13);
      vParamsEntrada := vParamsEntrada || 'Cubagem:      '|| pCubagem      || chr(13);
      vParamsEntrada := vParamsEntrada || 'CnaveNFE:     '|| pChaveNfe     || chr(13);
      vParamsEntrada := vParamsEntrada || 'Codigo CFOP:  '|| pCfop         || chr(13);
      vParamsEntrada := vParamsEntrada || 'DI:           '|| pDi           || chr(13);
      vParamsEntrada := vParamsEntrada || 'Contrato:     '|| pContrato     || chr(13);
      vParamsEntrada := vParamsEntrada || 'Tp Req.:      '|| pTpRequis     || chr(13);
      vParamsEntrada := vParamsEntrada || 'Cod. Req.:    '|| pRequisCod    || chr(13);
      vParamsEntrada := vParamsEntrada || 'Saque Req.:   '|| pSaqueRequis  || chr(13);
      vParamsEntrada := vParamsEntrada || 'Codigo Onu:   '|| pCodOnu       || chr(13);
      vParamsEntrada := vParamsEntrada || 'Grup Emb Onu: '|| pGrpEmbOnu    || chr(13);
      vParamsEntrada := vParamsEntrada || 'Coleta:       '|| pColeta       || chr(13);
      vParamsEntrada := vParamsEntrada || 'Tp Coleta:    '|| pTpColeta     || chr(13);
      vParamsEntrada := vParamsEntrada || 'PO.:          '|| pPO           || chr(13);
      vParamsEntrada := vParamsEntrada || 'Vide Nota:    '|| pNotaVide     || chr(13);
      vParamsEntrada := vParamsEntrada || 'Usuario:      '|| pUsuario      || chr(13);
      vParamsEntrada := vParamsEntrada || 'Vide Seq. Mae:'|| pVideSeq      || chr(13);
      vParamsEntrada := vParamsEntrada || 'Vide Num Nota:'|| pVideNumNota  || chr(13);
      vParamsEntrada := vParamsEntrada || 'Vide Serie:   '|| pVideSerie    || chr(13);
      vParamsEntrada := vParamsEntrada || 'Vide Cnpj:    '|| pVideCnpj     || chr(13);
      
      pstatus := 'E';
      pMessage := vParamsEntrada;
      Return;
  
End If;

*/

  
--Verificando o Paramentro tipo "pSacado", vou definir o CNPJ e TpEndereço de Sacado.
    --Caso o CNPJ seja o Remetente
    if (Trim(pSacado) = 'R' ) then
      vCnpjSacado := pCnpjRemet;
      vTpEndSacado := pTpEndRemet;
    end if;
    
    --Caso o CNPJ seja o Destinatário
    if ( Trim(pSacado) = 'D' ) then
      vCnpjSacado := pCnpjDestino;
      vTpEndSacado := pTpEndDestino;
    end if;
    
    --Caso o CNPJ seja OUTROS - "Consignatário"
    if ( Trim(pSacado) = 'O' ) then
      vCnpjSacado  := pCnpjOutros;
      vTpEndSacado := '';
    end if;
    

  if ( Trim(pOrigemNota) <> 'E' ) Then
     Select count(*)
        into vCount
     from tdvadm.t_arm_nota an
     where an.arm_nota_chavenfe = pChaveNfe
       and an.glb_cliente_cgccpfsacado = vCnpjSacado;

     If vCount > 0 Then
        pStatus := pkg_fifo.Status_Erro;
        pMessage := 'Nota ' || pNota || ' Ja cadastrada para o Sacado [' || vCnpjSacado || ']' || chr(10) ;
        Return;
     End If;

  End If;
  
  



   --Defini o Tipo da Carga.
    Select 
      Case pTpCarga
        When 'EX' Then 'EX'
        When 'CA' Then 'FF'
      End 
    Into vTpCarga From dual;

    
/***********************************************************************************************/
/*           ALIMENTA A VARIÁVEL "vDadosValid" PARA EFETUAR A VALIDAÇÃO DA NOTA                */
/***********************************************************************************************/
    vDadosValid.NumeroNota   := pNota;
    vDadosValid.DtEmissao    := pDtEmissao;
    vDadosValid.DtSaida      := pDtSaida;
    vDadosValid.CnpjRemet    := pCnpjRemet;
    vDadosValid.TpEndRemet   := pTpEndRemet;
    vDadosValid.CnpjDestino  := pCnpjDestino;
    vDadosValid.TpEndDestino := pTpEndDestino;
    vDadosValid.tpSacado     := pSacado;
    vDadosValid.CnpjSacado   := vCnpjSacado;
    vDadosValid.PesoNota     := pPesoNota;
    vDadosValid.PesoBalanca  := pPesoBalanca;
    vDadosValid.Coleta       := pColeta;
    vDadosValid.TpColeta     := pTpColeta;
    vDadosValid.TpCarga      := vTpCarga;
    vDadosValid.FlagEmp      := pFlagEmp;
    vDadosValid.QtdeEmp      := pQtdeEmp;
    vDadosValid.Mercadoria   := pMercadoria;
    vDadosValid.VlrMercad    := pVlrMercad;
    vDadosValid.QtdeVolume   := pQtdeVolume;
    vDadosValid.ChaveNfe     := Trim( pChaveNfe ); 
    vDadosValid.Cfop         := pCfop;
    vDadosValid.Contrato     := pContrato;
    vDadosValid.TpRequis     := pTpRequis;
    vDadosValid.RequisCod    := pRequisCod;
    vDadosValid.SaqueRequis  := lpad(Trim(pSaqueRequis), 4, '0');
    vDadosValid.Usuario      := pUsuario;
    vDadosValid.Aplicacao    := 'carreg';
    vDadosValid.Rota         := pRota;
    vDadosValid.Armazem      := pArmazem;
    
    vDadosValid.Remetente_LocalCodigo := pLocOrigem;
    vDadosValid.Destino_LocalCodigo := pLocDestino;

 -- VER COM ROGERIO POIS PEGUEI AQUI O TIPO DE DOCUMENTO
 -- PARA SE COLOCADO NA CHAMADA DA PROCEDURE.
 -- COLOCAR SE EXIGE NFE NO TIPO DE DOCUMENTO
 
   BEGIN
   SELECT AN.CON_TPDOC_CODIGO,
          an.arm_carga_codigo
     INTO vDadosValid.nota_tpDocumento,
          vArm_Carga_codigo
   FROM TDVADM.T_ARM_NOTA AN 
   WHERE AN.ARM_NOTA_SEQUENCIA = pSequencia; 
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       vDadosValid.nota_tpDocumento := '55';
   END;    


     
    
/***********************************************************************************************/    
    
    vRetorno := pkg_fifo_validadoresnota.fn_ValidaNotaFiscal( vDadosValid);
    
    If ( vRetorno.Status = pkg_fifo.Status_Erro ) Then
      
      pStatus := vRetorno.Status;
      pMessage := vretorno.Message;
      Return;
    End If;
    
    

    vDadosNota.Remetente_CNPJ      := pCnpjRemet;
    vDadosNota.Remetente_tpCliente := pTpEndRemet;
    vDadosNota.Destino_CNPJ        := pCnpjDestino;
    vDadosNota.Destino_tpCliente   := pTpEndDestino;
    vDadosNota.nota_flagPgto       := pSacado;
    vDadosNota.Sacado_CNPJ         := pCnpjOutros;
    vDadosNota.coleta_Codigo       := pColeta;

    If pColeta is not null Then
       select max(co.arm_coleta_ciclo)
          into vDadosNota.coleta_Ciclo
       from tdvadm.t_arm_coleta co
       where co.arm_coleta_ncompra = pColeta;
    Else
       select an.arm_coleta_ncompra,
              an.arm_coleta_ciclo
         into vDadosNota.coleta_Codigo,
              vDadosNota.coleta_Ciclo
       from tdvadm.t_arm_nota an
       where an.arm_nota_sequencia = pSequencia;
    End If;

--     If  vRetorno.Status =  pkg_fifo.Status_Normal Then 
        If  Not pkg_fifo_validadoresnota.FN_Valida_NotaColeta(vDadosNota,pMessage) Then 
            pStatus := pkg_glb_common.Status_Erro;
            Return;
        End If; 

--     End If;


  
  -- Caso a origem da nota seja do tipo "E", é uma edição, preciso apenas dar um update na T_ARM_NOTA, trazendo os novos dados.
  if ( Trim(pOrigemNota) = 'E' ) Then
    
    
    --Verifica se a nota já possui conhecimento.
    Select 
      Count(*) Into vCount
    From 
      t_arm_nota  n
    Where 
       0=0
      And n.con_conhecimento_codigo Is Not Null
      And n.arm_nota_sequencia = pSequencia;
      
    If vCount > 0 Then
       pStatus := pkg_fifo.Status_Erro;
      pMessage := 'ATUALIZAÇÃO NÃO PERMITIDA.' || chr(13) || chr(13) ||
                  'Nota Fiscal não pode ser atualizada por que já faz parte de um CTRC';
      Return;
      
    End If;
    
    --verifico se a nota já está carregada.
 /*  
    Select  
      Count(*) Into vCount
    From 
       t_arm_carregamentodet c,
       t_arm_nota            n
    Where c.arm_embalagem_numero = n.arm_embalagem_numero
    And c.arm_embalagem_flag = n.arm_embalagem_flag
    And c.arm_embalagem_sequencia = n.arm_embalagem_sequencia
    And n.arm_nota_sequencia = pSequencia;
    
    If vCount > 0 Then
      pStatus := pkg_fifo.Status_Erro;
      pMessage := 'ATUALIZAÇÃO NÃO PERMITIDA.' || chr(13) || chr(13) ||
                  'Nota Fiscal não pode ser atualizada por que já faz parte de um carregamento.';
      Return;            
    End If;
   */ 
    
    
    
    
  
    -- ============================================================= -
    -- Alteração: Bloqueia se peso Diferente do Atual gravado, 
    -- Diego Lirio - 11/12/2013
    Select Nvl(n.arm_nota_pesobalanca,1),
           n.arm_carga_codigo
      Into vNotaBalanca,
           vArm_Carga_codigo
      From tdvadm.t_arm_nota n
      where n.arm_nota_sequencia = pSequencia;
    
    -- Pesquisa parâmetro que permite alterar peso balança  
    select u.usu_perfil_parat
      into vParamAlteraPeso
    from tdvadm.T_USU_PERFIL u
    where lower(USU_APLICACAO_CODIGO) like '%pesonota%'
      and usu_perfil_codigo like '%ALTERA_PESAGEM%';         

    if(pPesoBalanca != vNotaBalanca) and (vParamAlteraPeso = 'N') then
        Raise_Application_Error(-20001, 'Não será possivel Alterar Peso Balança. Procure alguém com autorização.');
    end if;    
    -- ============================================================= -      

    -- Alteracao: Verifica se origem da nota foi alterada
    -- Sirlano 09/12/2014
    -- Testando se é uma entrega ou coleta
--    pLocOrigem
--    pCnpjRemet
--    pTpEndRemet
    
    if pTpColeta = 'E' then
        -- Entrega Pega a Localidade do armazem.
        select r.glb_localidade_codigo
          into vAuxLocalidade
          from t_arm_armazem a,
               t_glb_rota r
          where a.arm_armazem_codigo = pArmazem
            and a.glb_rota_codigo = r.glb_rota_codigo;                            
    Else
        select ce.glb_localidade_codigo
           into vAuxLocalidade
           from t_glb_cliente c,
                t_glb_cliend ce
           where trim(c.glb_cliente_cgccpfcodigo) = trim(pCnpjRemet)
             and ce.glb_tpcliend_codigo = pTpEndRemet
             and trim(c.glb_cliente_cgccpfcodigo) = trim(ce.glb_cliente_cgccpfcodigo);
    end if;
                      




    if trim(pLocOrigem) <> trim(vAuxLocalidade) Then                      
       pStatus := pkg_fifo.Status_Erro;
        pMessage := '*********** NOTA NAO ATUALIZADA ***********' || CHR(13) || CHR(13) ||
                    'Localidade de ORIGEM Diferente do Tipo da Coleta '|| chr(13) ||
                    '**************************************************';
    Else                      
        update t_arm_nota nota
        set 
          nota.arm_nota_peso          = pPesoNota,
          nota.arm_nota_pesobalanca   = pPesoBalanca,
          nota.arm_nota_qtdvolume     = pQtdeVolume,
          nota.glb_mercadoria_codigo  = pMercadoria,
          nota.arm_nota_valormerc     = pVlrMercad,
          nota.arm_nota_mercadoria    = pDescricao,
          nota.arm_nota_chavenfe      = pChaveNfe,
          nota.glb_cfop_codigo        = pCfop,
          nota.xml_notalinha_numdoc   = pPo,
          nota.arm_nota_di            = pDi,
          nota.arm_nota_onu           = pCodOnu,
          nota.arm_nota_grpemb        = pGrpEmbOnu,

          nota.arm_nota_tabsol        = pTpRequis,
          nota.arm_nota_tabsolcod     = pRequisCod,
          nota.arm_nota_tabsolsq      = lpad(pSaqueRequis,4,'0'),
         

          nota.arm_nota_vide          = pNotaVide,
     
          nota.arm_nota_flagpgto      = pSacado,
           
          nota.glb_tpcliend_codremetente = pTpEndRemet,
          nota.glb_tpcliend_coddestinatario = pTpEndDestino,
          nota.glb_localidade_codigoorigem = pLocOrigem,
          NOTA.ARM_NOTA_DTRECEBIMENTO = pDtSaida,
          nota.arm_movimento_datanfentrada = pDtEmissao,
          NOTA.ARM_NOTA_SERIE = pSerie,
          nota.arm_nota_largura                = pLargura,
          nota.arm_nota_comprimento            = pComprimento,
          nota.arm_nota_altura                 = pAltura,
          nota.arm_nota_flagemp                = pFlagEmp,
          nota.arm_nota_empqtde                = pQtdeEmp

          
        where nota.arm_nota_sequencia = pSequencia;
        

        
          UPDATE T_ARM_CARGA CA
            SET CA.GLB_LOCALIDADE_CODIGODESTINO = (select ce.glb_localidade_codigo from tdvadm.t_glb_cliend ce where ce.glb_cliente_cgccpfcodigo = pCnpjDestino and ce.glb_tpcliend_codigo = pTpEndDestino)
          WHERE CA.ARM_CARGA_CODIGO = vArm_Carga_codigo;

        
        pStatus := pkg_fifo.status_normal;
        pMessage := '*********** 2 NOTA ATUALIZADA COM SUCESSO ***********' || CHR(13) || CHR(13) ||
                    'Abaixo relação dos campos atualizados '|| chr(13) ||
                    'Sequencia da Nota: ' || pSequencia   || chr(13) ||
                    'Peso Nota (Kilo): '  || pPesoNota    || chr(13) ||
                    'Peso Balança(Kilo): '|| pPesoBalanca || chr(13) || 
                    'Comprimento: '       || pComprimento || chr(13) ||
                    'Largura: '           || pLargura     || chr(13) ||
                    'Altura: '            || pAltura      || chr(13) ||
                    'Empilhamento : '     || pFlagEmp     || chr(13) ||
                    'Qtde Empilhamento : '|| pQtdeEmp     || chr(13) ||
                    'Qtde de Volumes: '   || pQtdeVolume  || chr(13) ||
                    'Cod Mercadoria: '    || pMercadoria  || chr(13) ||
                    'Valor Mercadoria: '  || pVlrMercad   || chr(13) ||
                    'Desc. Mercadoria: '  || pDescricao   || chr(13) ||
                    'Chave NFE: '         || pChaveNfe    || chr(13) ||
                    'Cod. CFOP: '         || pCfop        || chr(13) ||
                    'Tipo       '         || pTpRequis    || chr(13) ||
                    'Codigo Tab/Sol '     || pRequisCod   || chr(13) ||
                    'Saque Tab/Sol  '     || lpad(pSaqueRequis,4,'0') || chr(13) ||
                    'P.O.: '              || pPo          || chr(13) ||
                    'D.I.: '              || pDi          || chr(13) ||
                    'Codigo Onu: '        || pCodOnu      || chr(13) ||
                    'Grupo Embalagem: '   || pGrpEmbOnu   || chr(13) ||
                    'Flag de Pagto: '     || pSacado      || chr(13) ||

                    'Flag Vide Nota: '    || pNotaVide    || chr(13) ||
                    'Tipo End. Rement:'   || pTpEndRemet  || chr(13) ||
                    'Tipo End. Destino: ' || pTpEndDestino|| chr(13) ||
                    'Tipo Nota:    '      || pTpNota      || chr(13) ||
                    'Data de Saida: '     || pDtSaida     || chr(13) ||
                    'Data de Emissao: '   || pDtEmissao   || chr(13) ||
--                    'Tipo de Carga:     ' || nvl(pDadosNota.carga_Tipo,'CD')                                                   || chr(13) ||
                    
                    'Serie: '             || pSerie || chr(13) ||
                    
                    '**************************************************';
       End If;         
  end if;
  
   --Caso a origem da nota seja do tipo "D", é uma digitação, preciso criar toda a entrada da nota fiscal. 
  If ( Trim(pOrigemNota) = 'D' ) Then
  
    --pega o código para a t_arm_carga 
    select arm_carga_codigo_sequencia.nextval Into vCargaCodigo from dual;
    
    --Sequencia de detalhe de carregamento 
    vCargaDetSeq := 1;
    
    --pega o código para Embalagem Avulsa
    select s_arm_avulso_numero.nextval Into vEmbNumero  from dual;
    
    --pega o código para Sequencia de Embalagem
    select arm_embalagem_numero_sequencia.nextval Into vEmbSequencia from dual; 
    
    --Flag da embalagem
    vFlagEmbalagem := 'A';
    
    --pega o código para Sequencia de Nota
    Select arm_nota_numero_sequencia.nextval Into vNotaSequencia from dual;
    
    --Cria um registro na t_arm_carga
    vRetorno:= fn_CriaCarga(vCargaCodigo, 
                            pRota, 
                            vTpCarga, 
                            '02', 
                            pCubagem, 
                            Sysdate, 
                            Sysdate, 
                            pQtdeVolume, 
                            pPesoNota, 
                            pLocDestino, 
                            pUsuario);
                             
    
    
    --Não tendo nenhum problema na criação de uma "Carga" 
    If vRetorno.Status = pkg_fifo.Status_Normal Then
    
      --Criar uma linha na "t_arm_carga_det" 
      vRetorno := fn_CriaCargaDet( vCargaCodigo,      --Código da Carga 
                                   vCargaDetSeq,      --Sequencia do detalhe da Carga 
                                   vNotaSequencia,    --sequencia da Nota 
                                   pNota,             --Numero da Nota
                                   Trim(pCnpjRemet),  --Cnpj Remetente
                                   vEmbNumero,        --Numero Embalagem
                                   vEmbSequencia,     --Sequencia embalagem
                                   vFlagEmbalagem,    --Flag de embalagem
                                   pUsuario           --Usuario
                                  );
 
    Else
      pStatus :=  vRetorno.Status;
      pMessage:= 'Erro ao criar a Carga '|| CHR(13) || vRetorno.Message;  
      Rollback;
      Return;
    End If;                                                                   
                                   
                                   
    --Não tendo nenhum problema da criação da "CargaDet" 
    If ( vRetorno.Status = pkg_fifo.Status_Normal ) Then
      --Cria uma linha na "t_arm_embalagem" 
      vControle := fn_CriaEmbalagem(vEmbNumero, 
                                    vEmbSequencia, 
                                    vFlagEmbalagem, 
                                    vCargaCodigo, 
                                    Sysdate, 
                                    Sysdate, 
                                    pAltura, 
                                    pLargura, 
                                    pComprimento,
                                    pTpCarga, 
                                    pCnpjDestino, 
                                    pTpEndDestino, 
                                    pArmazem, 
                                    pUsuario, 
                                    pCodOnu, 
                                    pPesoNota, 
                                    pPesoBalanca 
                                   );
    Else
      pStatus := vRetorno.Status;
      pMessage := 'Erro ao criar Detalhe de Carregamento. '||chr(13)|| vRetorno.Message;
      Rollback;
      Return;  
    End If;                                  
                                   
         
    --Não tendo nenhum problema na criação da "Embalagem" 
    If vControle = pkg_fifo.Status_Normal Then

        -- Sirlano
        -- Insere Nota

/*
        vDadosNota.NotaStatus              := null;
                            
               --Dados da Coleta
        vDadosNota.criar_coleta            := null;
        vDadosNota.coleta_Codigo           := null;
        vDadosNota.coleta_Ciclo            := null;
        vDadosNota.coleta_Pedido           := null;
        vDadosNota.coleta_Tipo             := null;
        vDadosNota.coleta_ocor             := null;
        vDadosNota.finaliza_digitacao      := null;
               --Dados da Nota Fiscal
        vDadosNota.nota_Tipo               := null;
        vDadosNota.nota_Sequencia          := null;
        vDadosNota.nota_numero             := null;
        vDadosNota.nota_serie              := null;
        vDadosNota.nota_dtEmissao          := null;
        vDadosNota.nota_dtSaida            := null;
        vDadosNota.nota_dtEntrada          := null;
        vDadosNota.nota_chaveNFE           := null;
        vDadosNota.nota_pesoNota           := null;
        vDadosNota.nota_pesoBalanca        := null;
        vDadosNota.nota_altura             := null;
        vDadosNota.nota_largura            := null;
        vDadosNota.nota_comprimento        := null;
        vDadosNota.nota_cubagem            := null;
        vDadosNota.nota_EmpilhamentoFlag   := null;
        vDadosNota.nota_EmpilhamentoQtde   := null;
        vDadosNota.nota_descricao          := null;
        vDadosNota.nota_qtdeVolume         := null;
        vDadosNota.nota_ValorMerc          := null;
        vDadosNota.nota_RequisTp           := null;
        vDadosNota.nota_RequisCodigo       := null;
        vDadosNota.nota_RequisSaque        := null;
        vDadosNota.nota_Contrato           := null;
        vDadosNota.nota_PO                 := null;
        vDadosNota.nota_Di                 := null;
        vDadosNota.nota_Vide               := null;
        vDadosNota.nota_flagPgto           := null;
                            
                --Dados da Carga
        vDadosNota.carga_Codigo            := null;
        vDadosNota.carga_Tipo              := null;

           --Dados de Vide Nota
        vDadosNota.vide_Sequencia          := null;
        vDadosNota.vide_Numero             := pNota;
        vDadosNota.vide_Cnpj               := null;
        vDadosNota.vide_Serie              := null;

           --Dados da Mercadoria
        vDadosNota.mercadoria_codigo       := null;
        vDadosNota.mercadoria_descricao    := null;
                            
            --Dados de CFOP
        vDadosNota.cfop_Codigo             := null;
        vDadosNota.cfop_Descricao          := null;
                            
           --Dados de Embalagem 
        vDadosNota.embalagem_numero        := null;
        vDadosNota.embalagem_flag          := null;
        vDadosNota.embalagem_sequencia     := null;
                            
           --Dados da Rota
        vDadosNota.vrota_Codigo            := null;
        vDadosNota.rota_Descricao          := null;
                            
          --Dados do Armazem 
        vDadosNota.armazem_Codigo          := null;
        vDadosNota.armazem_Descricao       := null;
                            
         --Dados de Remetente
        vDadosNota.Remetente_CNPJ          := null;
        vDadosNota.Remetente_RSocial       := null;
        vDadosNota.Remetente_tpCliente     := null;
        vDadosNota.Remetente_CodCliente    := null;
        vDadosNota.Remetente_Endereco      := null;
                            
        vDadosNota.Remetente_LocalCodigo   := null;
        vDadosNota.Remetente_LocalDesc     := null;
                            
         --Dados de Destino
        vDadosNota.vDestino_CNPJ           := null;
        vDadosNota.Destino_RSocial         := null;
        vDadosNota.Destino_tpCliente       := null;
        vDadosNota.Destino_CodCliente      := null;
        vDadosNota.Destino_Endereco        := null;
                            
        vDadosNota.Destino_LocalCodigo     := null;
        vDadosNota.Destino_LocalDesc       := null;
                            
              --Dados do Sacado
        vDadosNota.Sacado_CNPJ             := null;
        vDadosNota.Sacado_RSocial          := null;
        vDadosNota.Sacado_tpCliente        := null;
                            
               --Código Onu 
        vDadosNota.Onu_Codigo              := null;
        vDadosNota.Onu_GrpEmb              := null;
        vDadosNota.Onu_Flag                := null;
                            
           --Dados de redespacho
        vDadosNota.DadosRedespacho         := null;
                           
           --Tipo de Documento
        vDadosNota.nota_tpDocumento        := null;
                            
        vDadosNota.usu_usuario_codigo      := pUsuario/
                            
        vDadosNota.Status                  := null;
        vDadosNota.Message                 := null;
        
*/
        
--        If  Not tdvadm.pkg_fifo_validadoresnota.FN_Valida_NotaColeta(vDadosNota,vRetorno.Message) Then 
--            pStatus := pkg_glb_common.Status_Erro;
--        End If; 
--        If pStatus <> 'E' Then
--           pMessage := vRetorno.Message;
--           return;
--        End If;

        --Faz a inserção da Nota na "t_arm_nota"
      vControle := fn_CriaNotaFiscal(pUsuario, 
                                     pNota, vNotaSequencia, pSerie, pDtEmissao, Sysdate, pDtSaida, 
                                     pMercadoria, pDescricao, pVlrMercad, pFlagEmp, pQtdeEmp, pTpNota, pNotaVide, 'S', 'N', pPO, pDi,
                                     pCnpjRemet, pTpEndRemet, pCnpjDestino, pTpEndDestino, vCnpjSacado, vTpEndSacado,
                                     pLocOrigem,
                                     pTpRequis, pRequisCod, pSaqueRequis, pContrato, pSacado, 
                                     pQtdeVolume, pLargura, pAltura, pComprimento, 
                                     vCargaCodigo, vTpCarga,  pColeta, pTpColeta, 
                                     vEmbNumero, vFlagEmbalagem, vEmbSequencia, 
                                     pPesoNota, pPesoBalanca, pCubagem, pRota, pArmazem, pChaveNfe, pCfop, pCodOnu, pGrpEmbOnu,
                                    'N', 'N');
       
       --Caso a inserção da nota esteja correta, e a nota tenha um vide, faz a inserção da nota na tabela de crontrole videnota 
      If ( vControle = pkg_fifo.Status_Normal ) Then
        If ( pNotaVide = 1 ) Then
          Insert Into t_arm_notavide ( arm_notavide_numero,
                                       arm_notavide_cgccpfremetente,
                                       arm_notavide_serie,
                                       arm_notavide_sequencia,
                                       arm_nota_numero,
                                       glb_cliente_cgccpfremetente,
                                       arm_nota_serie,
                                       arm_nota_sequencia 
                                     )
                                     Values
                                     (
                                       pNota,
                                       Trim(pCnpjRemet),
                                       pSerie,
                                       vNotaSequencia,
                                       pVideNumNota,
                                       Trim( pVideCnpj ),
                                       pVideSerie,
                                       pVideSeq
                                     );
        End If;
        
      End If;
       
    Else
      pStatus := pkg_fifo.Status_erro;
      pMessage := 'Erro ao Criar embalagem.'||chr(13)||Sqlerrm;
      Rollback;
      Return;
    End If;              
    
/*************************************************
Aqui que colocarei as criticas e excluir a nota caso tenha problema
*************************************************/
                          
          
    
    if ( Trim(vControle) = pkg_fifo.Status_Normal )  Then
       pStatus := vControle;
       pMessage := 'Nota Inserida com sucesso [4915]'   || chr(13) ||
                   'Embalagem: '|| vEmbNumero    || chr(13) ||
                   'Seqüência: '|| vEmbSequencia || chr(13) ||
                   'Flag Embalagem: ' || vFlagEmbalagem ; 

       Commit;

     
    else
      pStatus := pkg_fifo.Status_Erro;
      pMessage := 'Erro ao Inserir a nota fiscal' ||chr(13)||sqlerrm;
      rollback;
      return;
    end if;
                   
   
  End If;
end sp_inserirDadosNota;



/**************************************************************************************************************************/
/* Procedure responsável por excluir a nota fiscal                                                                        */                            
/**************************************************************************************************************************
procedure sp_excluirNota( pUsuario         in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                          pRota            in tdvadm.t_glb_rota.glb_rota_codigo%type,
                          pNumeroNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                          pDataEmissao     in varchar2,
                          pCnpjRemetente   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                          pCnpjDestino     in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                          pColeta          in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                          pEmbalagem       in tdvadm.t_arm_nota.arm_embalagem_numero%type,
                          pStatus          out char,
                          pMessage         out varchar2 ) as
 
 -- Variável de controle 
 vCount   integer := 0;
 
 --Variáveis utilizadas para recuperar dados de Embalagem
 vArm_embalagem_numero    tdvadm.t_arm_embalagem.arm_embalagem_numero%Type;
 vArm_embalagem_flag      tdvadm.t_arm_embalagem.arm_embalagem_flag%Type;
 vArm_embalagem_sequencia tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type;
 
 --Variáveis utilizadas para recuperar dados da carga
 vArm_carga_codigo tdvadm.t_arm_carga.arm_carga_codigo%Type;
 
 
 --Variável com a linha de paramentros específico.
 vLinhaParamentro   glbadm.pkg_glb_auxiliar.tParametros;
Begin
 --Inicializo as variáveis que serão utilizadas nessa função
 vCount := 0;
 vArm_embalagem_numero := 0;
 vArm_embalagem_flag := '';
 vArm_embalagem_sequencia := 0;
 
 --Variáveis utilizadas para recuperar dados da carga
 vArm_carga_codigo:= 0;
   



  --Verifico se a nota está em algum carregamento.
  Select 
    Count(c.arm_carregamento_codigo)
    Into vCount
  From 
    tdvadm.t_arm_nota             nota,
    tdvadm.t_arm_carregamentodet  cd,
    tdvadm.t_arm_carregamento     c
  Where
    0 = 0
    And nota.arm_embalagem_numero    = cd.arm_embalagem_numero
    And nota.arm_embalagem_flag      = cd.arm_embalagem_flag
    And nota.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
  
    And cd.arm_carregamento_codigo = c.arm_carregamento_codigo
  
    And nota.arm_nota_numero                      = pNumeroNota
    And Trim(nota.glb_cliente_cgccpfremetente)    = pCnpjRemetente
    And Trim(nota.glb_cliente_cgccpfdestinatario) = pCnpjDestino
    And nota.arm_embalagem_numero                 = pEmbalagem;
  

    --Caso a variável "vCount" seja maior que zero quer dizer que a nota fiscal já possui um carregamento.
    if vCount > 0 then
      pStatus := pkg_fifo.Status_Normal;
      pMessage := 'Nota Fiscal está relacionada em um carregamento.'||chr(13)||
                  'Retire a nota do carregamento antes de excluir a nota.';
      return;
    end if;
    
    --Verifico se a nota veio do XML
    Select count(*) 
    into vCount
    from tdvadm.t_xml_nota no
    where
      no.xml_nota_nf = pNumeroNota
      and Trim(no.glb_cliente_cgccpfremetente) = Trim(pCnpjRemetente);
    
    --Caso a Variável "vCount" seja maior que zero, quer dizer que a nota fiscal veio do XML
    if vCount > 0 then
      glbadm.pkg_glb_auxiliar.sp_Espec_Params( Trim(lower(pUsuario)), pkg_fifo.NomeAplicacao, pRota, 'EXNTARMCXML', vLinhaParamentro);
      
      
      --Verifico se o usuario tem permissão para excluir nota do XML.
      if Trim(vLinhaParamentro.TEXTO) = 'S' then
        --Atualiza a nota na base XML.
        UPDATE T_XML_NOTA NT
        SET NT.XML_NOTA_STATUS                       = 'OK'
        WHERE NT.XML_NOTA_NF                         = pNumeroNota 
          AND NT.XML_NOTA_EMISSAO                    = Trunc(to_date(pDataEmissao, 'DD/MM/YYYY'))
          AND Trim(NT.GLB_CLIENTE_CGCCPFREMETENTE)   = Trim(pCnpjRemetente)
          AND NT.XML_NOTA_NOTA                       = 'S'
          AND NT.XML_NOTA_STATUS                     = 'NO';
      else
        --Caso não tenha permissão para excluir a nota do Xml 
        pStatus := pkg_fifo.Status_Erro;
        pMessage := 'Nota Fiscal veio do XML.'||chr(13)||
                    'Você não tem permissão para executar essa operação.';
        return;
      end if;
      
    end if;
    
    
    begin
      --Delete a nota que está na T_ARM_NOTA.
      delete from t_arm_nota nota
      where nota.arm_nota_numero = pNumeroNota
      and nota.glb_cliente_cgccpfremetente = pCnpjRemetente
      and Trunc(nota.arm_movimento_datanfentrada) = Trunc(to_date(pDataEmissao, 'DD/mm/yyyy'))
      and nota.arm_coleta_ncompra = pColeta
      and nota.arm_embalagem_numero = pEmbalagem;
      
      
      pStatus := pkg_fifo.Status_Normal;
      pMessage := 'Nota Fiscal excluída com sucesso.';

    exception
      when others then
        pStatus := pkg_fifo.Status_Erro;
        pMessage := 'Erro ao tentar excluir Nota Fiscal. ' || chr(13) || sqlerrm;
    end;
end sp_excluirNota;
*/


--Procedure utilizada para buscar lista de notas
procedure sp_getVideNota( pCnpj in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                          pStatus out char,
                          pMessage out varchar2,
                          pCursor out tdvadm.pkg_fifo.T_CURSOR
                         ) as
--Variavel de controle
 vCount integer:= 0;
 vDiasRetrocesso integer := 15;  
 vDataNota Date; 
begin
    


   /* Primeiro verifico se a nota pode ter uma nota mae */
   Select nvl(trunc(Max(nota.arm_nota_dtinclusao) ),'01/01/1900')
      into vDataNota
   from tdvadm.t_arm_nota nota
   where trim(nota.glb_cliente_cgccpfremetente) = trim(pCnpj);
-- reitrado para verificar se a nota existe ou sua data esta fora do parametro
--   and Trunc(nota.arm_nota_dtinclusao) >= trunc(sysdate) - vDiasRetrocesso;
   
 
  begin     

   /* Caso não tenha, antes de abrir o cursor, já finalizo o processamento e mostro a mensagem na tela */
   if (vDataNota < (trunc(sysdate) - vDiasRetrocesso)) then
     pStatus := pkg_fifo.Status_Erro;
     pMessage := 'Não existem notas com Data Superior a ' ||  to_char(trunc(sysdate) - vDiasRetrocesso,'dd/mm/yyyy') || ', impossivel continuar.'  ;
     return;
   Elsif (vDataNota = '01/01/1900') then
     pStatus := pkg_fifo.Status_Erro;
     pMessage := 'Não há nenhuma nota cadastrada para ser utilizada como Nota Mãe.' ;
     return;
   Else
    /* Caso tenha encontrado alguma nota, dentro do intevalo pré estabeecido tendo o mesmo cnpj como rementente, 
       Abre o cursor. */
     open pcursor for
       Select 
         nota.arm_nota_sequencia                                      SeqNota,
         nota.arm_nota_numero                                         numeroNota,
         nota.arm_nota_serie                                          SerieNota,
         Trunc(nota.arm_nota_dtinclusao)                              DtInclusao,
         tdvadm.f_mascara_cgccpf(nota.glb_cliente_cgccpfremetente)    cnpjRemet,
         cliRemet.Glb_Cliente_Razaosocial                             NomeRemente,
         tdvadm.f_mascara_cgccpf(nota.glb_cliente_cgccpfdestinatario) CnpjDestino,
         cliDestino.Glb_Cliente_Razaosocial                           NomeDestino
         
       from 
         tdvadm.t_arm_nota nota,
         tdvadm.t_glb_cliente  cliDestino, 
         tdvadm.t_glb_cliente  cliRemet
       where 
             Trim(nota.glb_cliente_cgccpfremetente)    = Trim(cliRemet.Glb_Cliente_Cgccpfcodigo)
         and trim(nota.glb_cliente_cgccpfdestinatario) = trim(cliDestino.Glb_Cliente_Cgccpfcodigo)
         and trim(nota.glb_cliente_cgccpfremetente) = trim(pCnpj)
         and Trunc(nota.arm_nota_dtinclusao) >= trunc(sysdate) - vDiasRetrocesso
      Order By nota.arm_nota_dtinclusao Desc   ;
   end if;
   
   pStatus := pkg_fifo.Status_Normal;
   pMessage := '';
 exception
   when others then
      pStatus := tdvadm.pkg_fifo.Status_Erro;
      pMessage:= 'Erro ao gerar cursor de notas Mãe'|| chr(13) || sqlerrm;
   
 end;  

end sp_getVideNota;   


   

/***************************************************************************************************************/
/* Procedure utilizada para buscar dados da NotaFiscal a partir de uma chave nfe                               */
/***************************************************************************************************************/
procedure sp_getDadosNota_chaveNFE( pChaveNfe  in  char,
                                    pNota_Coleta in pkg_fifo.tDadosNota,
                                    pStatus    out char,
                                    pMessage   out varchar2,
                                    pRetorno    Out pkg_fifo.tDadosNota   ) as

type tDadosNota is record (  --Dados do Remetente 
                             CnpjRementente   tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                             NomeRementente   tdvadm.t_glb_cliente.glb_cliente_razaosocial%type,
                             
                             --Dados do Destino
                             CnpjDestino      tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                             NomeDestino      tdvadm.t_glb_cliente.glb_cliente_razaosocial%type,
                             
                             --Dados Sacado
                             TpSacado         char(1),
                             
                             --Dados da Nota fiscal
                             NumNota          tdvadm.t_arm_nota.arm_nota_numero%type,
                             SerieNota        tdvadm.t_arm_nota.arm_nota_serie%type,
                             DtEmissao        tdvadm.t_arm_nota.arm_movimento_datanfentrada%type,
                             dtSaida          tdvadm.t_arm_nota.arm_nota_dtrecebimento%type,
                             Descricao        tdvadm.t_arm_nota.arm_nota_mercadoria%type,
                             QtdeVolume       tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                             ValorNota        tdvadm.t_arm_nota.arm_nota_valormerc%type,
                             PesoBalanca      tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                             PesoLiquido      tdvadm.t_arm_nota.arm_nota_peso%type,
                             ModFrete         char,
                             CodCfop          tdvadm.t_glb_cfop.glb_cfop_codigo%type,
                             DescCfop         tdvadm.t_glb_cfop.glb_cfop_descricao%type
                          );
                          
  vLinhaDestino       tdvadm.v_xml_destinatario%rowtype;   
  vLinhaRementente    tdvadm.v_xml_remetente%rowtype;
  vLinhaDadosNota     tdvadm.v_xml_idenota%rowtype;
  vLinhaItensNota     tdvadm.V_XML_ITENSNOTA%rowtype;                     
  vLinhaTotais        tdvadm.v_xml_notatotais%rowtype;
  vDadosNota          tDadosNota;
  
  vCursorRemet        tdvadm.pkg_fifo.T_CURSOR;
  vCursorDestino      tdvadm.pkg_fifo.T_CURSOR;
  vCursorDadosNota    tdvadm.pkg_fifo.T_CURSOR;
  
  vCursorDadosProduto tdvadm.pkg_fifo.T_CURSOR;
  vCursorDadosTotais  tdvadm.pkg_fifo.T_CURSOR;


  vNotaRow            tdvadm.t_edi_nf%RowType;
  
  --Variável que sera utilizada como retrono da funcção
  vRetorno            pkg_fifo.tDadosNota;
  vTpCliendCod        t_arm_coleta.glb_tpcliend_codigoentrega%Type;

  vColetaEnt          t_arm_coleta.Arm_Coleta_Entcoleta%TYpe;
  vColetaTpCompra     t_arm_coleta.Arm_Coleta_Tpcompra%Type;  
  vArmColeta          t_arm_coleta.arm_armazem_codigo%Type;
  vColetaRemetente    t_arm_coleta.glb_cliente_cgccpfcodigocoleta%Type;
  vColetaTpRemetente  t_arm_coleta.glb_tpcliend_codigocoleta%Type;
  vColetaTpEntrega    t_arm_coleta.glb_tpcliend_codigoentrega%Type;
begin

  update tdvadm.t_xml_nfe set XML_NFE_LIDO = 'S' where XML_NFE_ID=pChaveNfe;

  if ( nvl(pChaveNfe, 'R') <> 'R' ) and ( length( Trim(pChaveNfe)) = 44 ) then
    
    --Rodo a procedure que vai trazer os dados do Destinatário da Nota Fiscal.
    pkg_xml_nfe.SP_XML_GETNOTADESTINATARIO(trim(pChaveNfe), vCursorDestino, pStatus, pMessage);
    --Caso a procedure retorne com erro, encerro o processamento e mostro a mensagem.
    if ( pStatus = pkg_fifo.Status_Erro) then
        --Return;        
         pkg_fifo_recebimento.Sp_Get_NotaPorChave(trim(pChaveNfe), vNotaRow, pStatus, pMessage);
        
         if ( pStatus = pkg_fifo.Status_Erro) then  
              vRetorno.NotaStatus    := 'N';
              vRetorno.nota_chaveNFE := pChaveNfe;         
              pRetorno := vRetorno;
              Return;
         else              
                  vRetorno.coleta_Codigo := pNota_Coleta.coleta_Codigo;
                  vRetorno.coleta_Tipo:= pNota_Coleta.coleta_Tipo;
                  
                  vRetorno.Destino_Endereco := pNota_Coleta.Destino_Endereco;
                  vRetorno.Destino_tpCliente := pNota_Coleta.Destino_tpCliente;
                  vRetorno.Destino_CodCliente := pNota_Coleta.Destino_CodCliente;
                  vRetorno.Destino_LocalCodigo := pNota_Coleta.Destino_LocalCodigo;
                  vRetorno.Destino_LocalDesc := pNota_Coleta.Destino_LocalDesc;
                  
                  vRetorno.Remetente_tpCliente := pNota_Coleta.Remetente_tpCliente;
                  vRetorno.Remetente_CodCliente := pNota_Coleta.Remetente_CodCliente;
                  vRetorno.Remetente_Endereco := pNota_Coleta.Remetente_Endereco;
                  vRetorno.Remetente_LocalCodigo := pNota_Coleta.Remetente_LocalCodigo;
                  vRetorno.Remetente_LocalDesc := pNota_Coleta.Remetente_LocalDesc;


                  vRetorno.Remetente_CNPJ := vNotaRow.Edi_Emb_Cnpj;                                      
                  vRetorno.Remetente_tpCliente := '';
                  vRetorno.Destino_CNPJ :=  vNotaRow.Edi_Dest_Cnpj;                                  
                  --vRetorno.Sacado_tpCliente := vDadosNota.TpSacado;
                  vRetorno.nota_numero := vNotaRow.Edi_Nf_Numero;
                  vRetorno.nota_serie := vNotaRow.Edi_Nf_Serie;
                  vRetorno.nota_dtEmissao := vNotaRow.Edi_Nf_Emissao;
                  vRetorno.nota_dtSaida := vNotaRow.Edi_Nf_Emissao;
                  vRetorno.nota_chaveNFE:= pChaveNfe;
                  vRetorno.nota_descricao := vNotaRow.Edi_Nf_Mercadoria;
                  vRetorno.nota_qtdeVolume := vNotaRow.Edi_Nf_Volumes;
                  vRetorno.nota_ValorMerc := vNotaRow.Edi_Nf_Valor;
                  vRetorno.nota_pesoBalanca := vNotaRow.Edi_Nf_Pesototal;
                  vRetorno.nota_pesoNota := vNotaRow.Edi_Nf_Pesototal;
                  --vRetorno. := vNotaRow.Edi_Nf_Pesototal;
                  vRetorno.cfop_Codigo := vNotaRow.Edi_Nf_Cfop;
                  vRetorno.nota_PO     := vNotaRow.Edi_Nf_Numerosap;
                  
                  --vRetorno.nota_altura := 
                  --vRetorno.nota_largura := 
                  --vRetorno.nota_comprimento := 
                  
                  vRetorno.coleta_Codigo := vNotaRow.Arm_Coleta_Ncompra;
                  vRetorno.coleta_Ciclo := vNotaRow.Arm_Coleta_Ciclo;

                  begin 
                      Select c.glb_tpcliend_codigoentrega,
                             c.arm_coleta_tpcompra,
                             c.arm_coleta_entcoleta,
                             c.arm_armazem_codigo,
                             c.GLB_CLIENTE_CGCCPFCODIGOCOLETA,
                             c.glb_tpcliend_codigocoleta,
                             c.glb_tpcliend_codigoentrega
                        Into vTpCliendCod,
                             vColetaTpCompra,
                             vColetaEnt,
                             vArmColeta,
                             vColetaRemetente,
                             vColetaTpRemetente,
                             vColetaTpEntrega
                        From t_Arm_Coleta c
                        where c.arm_coleta_ncompra = vRetorno.coleta_Codigo
                          and c.arm_coleta_ciclo = vRetorno.coleta_Ciclo;    
                          
                      vRetorno.Remetente_tpCliente := vTpCliendCod; 
                      vRetorno.coleta_Tipo := vColetaTpCompra;

                      -- Remetente
                      select ce.glb_cliend_codcliente,
                             ce.glb_tpcliend_codigo,
                             ce.glb_cliend_endereco,
                             c.glb_cliente_razaosocial
                         into vRetorno.Remetente_CodCliente,
                              vRetorno.Remetente_tpCliente,
                              vRetorno.Remetente_Endereco,
                              vRetorno.Remetente_RSocial
                         from t_glb_cliente c,
                              t_glb_cliend ce
                         where trim(c.glb_cliente_cgccpfcodigo) = trim(vColetaRemetente)
                           and ce.glb_tpcliend_codigo = vColetaTpRemetente
                           and trim(c.glb_cliente_cgccpfcodigo) = trim(ce.glb_cliente_cgccpfcodigo);
                           
                      select c.glb_cliente_razaosocial,
                             cd.glb_cliend_codcliente,
                             cd.glb_tpcliend_codigo,
                             cd.glb_cliend_endereco                  
                           into vRetorno.Destino_RSocial,
                                vRetorno.Destino_CodCliente,
                                vRetorno.Destino_tpCliente,
                                vRetorno.Destino_Endereco
                           from tdvadm.t_glb_cliente c,
                                tdvadm.t_glb_cliend cd
                        where trim(c.glb_cliente_cgccpfcodigo) = Trim(vNotaRow.Edi_Dest_Cnpj)
                          and trim(c.glb_cliente_cgccpfcodigo) = trim(cd.glb_cliente_cgccpfcodigo)
                          and cd.glb_tpcliend_codigo = vColetaTpEntrega; 
                      
                      if vColetaEnt = 'E' then
                          -- Entrega Pega a Localidade do armazem.
                          select r.glb_localidade_codigo
                            into vRetorno.Remetente_LocalCodigo
                            from t_arm_armazem a,
                                 t_glb_rota r
                            where a.arm_armazem_codigo = vArmColeta
                              and a.glb_rota_codigo = r.glb_rota_codigo;                            
                      Else
                          select ce.glb_localidade_codigo
                             into vRetorno.Remetente_LocalCodigo
                             from t_glb_cliente c,
                                  t_glb_cliend ce
                             where trim(c.glb_cliente_cgccpfcodigo) = trim(vColetaRemetente)
                               and ce.glb_tpcliend_codigo = vColetaTpRemetente
                               and trim(c.glb_cliente_cgccpfcodigo) = trim(ce.glb_cliente_cgccpfcodigo);
                      end if;
                    
                           
                  exception
                    when others then
                      vRetorno.Remetente_tpCliente := Null;
                  end;                              
                  
                  begin --vRetorno.cfop_Descricao := vDadosNota.DescCfop;
                    select c.glb_cfop_descricao into vRetorno.cfop_Descricao
                    from t_glb_cfop c
                    where Trim(c.glb_cfop_codigo) = trim(vNotaRow.Edi_Nf_Cfop); 
                  exception
                    when others then
                      pStatus := pkg_fifo.Status_Erro;
                      pMessage := 'Erro ao buscar o código de CFOP ' || 'vNotaRow.Edi_Nf_Cfop: ' || vNotaRow.Edi_Nf_Cfop || sqlerrm;
                      return;
                  end;                  
                  vRetorno.NotaStatus := 'N';
                  pRetorno := vRetorno;     
                  
                  pStatus := pkg_fifo.Status_Normal;      
                  return;
         end if;
    end if;
    
    --Caso o retorno da procedure esteja correto, alimento a variável "vLinhaDestino", com o valor do cursor. 
    if ( pStatus = pkg_fifo.Status_Normal ) then
      loop
        fetch vCursorDestino into vLinhaDestino ;
        exit when vCursorDestino%notfound;
      end loop;
    end if;
    
    
    --Rodo a procedure que vai trazer os dados do Rementente da Nota Fiscal
    pkg_xml_nfe.SP_XML_GETNOTAREMETENTE(Trim(pChaveNfe), vCursorRemet, pStatus, pMessage);
    --Caso a procedure retorne com erro, encerro o processamento e motro a mensagem
    if ( pStatus = pkg_fifo.Status_Erro ) then
      return;
    end if;
    
    --Caso o retorno da procedure esteja correto, alimento a variável "vLinhaRementente", com o valor do cursor.
    if ( pStatus = pkg_fifo.Status_Normal ) then
      loop
        fetch vCursorRemet into vLinhaRementente;
        exit when vCursorRemet%notfound;
      end loop;
    end if;
    
    
    --Rodo a procedure que vai trazer os dados da Nota Fiscal
    pkg_xml_nfe.SP_XML_GETIDENOTA(trim(pChaveNfe), vCursorDadosNota, pStatus, pMessage);
    
    --caso a procedure retorne com erro, encerro o processamento e mostro a mensagem
    if ( pStatus = pkg_fifo.Status_Erro ) then
      return;
    end if;
    
    if ( pStatus = pkg_fifo.Status_Normal ) then
      loop
        fetch vCursorDadosNota into  vLinhaDadosNota.ID,
                                     vLinhaDadosNota.NNF,
                                     vLinhaDadosNota.SERIE,
                                     vLinhaDadosNota.CNPJ,
                                     vLinhaDadosNota.DEMI,
                                     vLinhaDadosNota.DSAIENT,
                                     vLinhaDadosNota.XNOME,
                                     vLinhaDadosNota.NATOP,
                                     vLinhaDadosNota.MODFRETE,
                                     vLinhaDadosNota.QVOL,
                                     vLinhaDadosNota.PESOB,
                                     vLinhaDadosNota.PESOL,
                                     vLinhaDadosNota.XML_NFE_ID 
        ;
        exit when vCursorDadosNota%notfound;
      end loop;
    end if;
    
    
    --de posse de todas as tabelas, vou alimentar a minha variável com os dados obtidos, mesmo que precise efetuar algum select.
    --Dados do Remetente
    vDadosNota.CnpjRementente := Trim(vLinhaRementente.CNPJ);
    begin
      Select c.glb_cliente_razaosocial into vDadosNota.NomeRementente 
      from tdvadm.t_glb_cliente c
      where Trim(c.glb_cliente_cgccpfcodigo) = Trim(vLinhaRementente.CNPJ);
    exception
      when others then
        pStatus := pkg_fifo.Status_Erro;
        pMessage := 'Erro ao buscar dados do Remetente.'|| chr(13) ||sqlerrm;
    end;
    
    --Dados do Destinatário
    vDadosNota.CnpjDestino  := Trim(vLinhaDestino.CNPJ);
     Begin
      select c.glb_cliente_razaosocial into vDadosNota.NomeDestino 
      from tdvadm.t_glb_cliente c
      where trim(c.glb_cliente_cgccpfcodigo) = Trim(vLinhaDestino.CNPJ);
     exception
       when others then
         pStatus := pkg_fifo.Status_Erro;
         pMessage := 'Erro ao buscar dados do Destinatário.'||chr(13)||sqlerrm;
     end;
    
    --Dados do Sacado       /*   0 = Remetente  -  1 = Destino  -  2 = terceiros      */
    vDadosNota.TpSacado       := Trim(vLinhaDadosNota.modFrete);
        
    --Dados da Nota Fiscal
    vDadosNota.NumNota        :=  to_number( vLinhaDadosNota.nNF );
    vDadosNota.SerieNota      :=  vLinhaDadosNota.serie;
    vDadosNota.DtEmissao      :=  vLinhaDadosNota.dEmi;
    vDadosNota.dtSaida        :=  vLinhaDadosNota.dSaiEnt;
    vDadosNota.Descricao      :=  substr(Trim(vLinhaDadosNota.natOp),1,50);
    vDadosNota.QtdeVolume     :=  vLinhaDadosNota.qVol;
    vDadosNota.PesoBalanca    :=  Trim(vLinhaDadosNota.pesoB);
    vDadosNota.PesoLiquido    :=  Trim(vLinhaDadosNota.pesoL);
    vDadosNota.CodCfop        :=  Trim( pkg_xml_nfe.FN_XML_GETCFOPNFE(pChaveNfe) );
    
    begin
      select c.glb_cfop_descricao into vDadosNota.DescCfop
      from t_glb_cfop c
      where Trim(c.glb_cfop_codigo) = trim(vDadosNota.CodCfop); 
    exception
      when others then
        pStatus := pkg_fifo.Status_Erro;
        pMessage := 'Erro ao buscar o código de CFOP' || sqlerrm;
    end;

     
    BEGIN
      pStatus := pkg_fifo.Status_Normal;
      pMessage := '';
      
      vRetorno.Remetente_CNPJ := vDadosNota.CnpjRementente;
      vRetorno.Remetente_RSocial := vDadosNota.NomeRementente;
      vRetorno.Remetente_tpCliente := '';
      
      vRetorno.Destino_CNPJ :=  vDadosNota.CnpjDestino;
      vRetorno.Destino_RSocial := vDadosNota.NomeDestino;

      vRetorno.coleta_Codigo := pNota_Coleta.coleta_Codigo;
      vRetorno.coleta_Tipo:= pNota_Coleta.coleta_Tipo;
      
      vRetorno.Destino_Endereco := pNota_Coleta.Destino_Endereco;
      vRetorno.Destino_tpCliente := pNota_Coleta.Destino_tpCliente;
      vRetorno.Destino_CodCliente := pNota_Coleta.Destino_CodCliente;
      vRetorno.Destino_LocalCodigo := pNota_Coleta.Destino_LocalCodigo;
      vRetorno.Destino_LocalDesc := pNota_Coleta.Destino_LocalDesc;
      
      vRetorno.Remetente_tpCliente := pNota_Coleta.Remetente_tpCliente;
      vRetorno.Remetente_CodCliente := pNota_Coleta.Remetente_CodCliente;
      vRetorno.Remetente_Endereco := pNota_Coleta.Remetente_Endereco;
      vRetorno.Remetente_LocalCodigo := pNota_Coleta.Remetente_LocalCodigo;
      vRetorno.Remetente_LocalDesc := pNota_Coleta.Remetente_LocalDesc;
      
      
      vRetorno.Sacado_tpCliente := vDadosNota.TpSacado;
      vRetorno.nota_numero := vDadosNota.NumNota;
      vRetorno.nota_serie := vDadosNota.SerieNota;
      vRetorno.nota_dtEmissao := vDadosNota.DtEmissao;
      vRetorno.nota_dtSaida := vDadosNota.dtSaida;
      vRetorno.nota_chaveNFE:= pChaveNfe;
      
      vRetorno.nota_descricao := vDadosNota.Descricao;
      vRetorno.nota_qtdeVolume := vDadosNota.QtdeVolume;
      vRetorno.nota_ValorMerc := '0'; 
      vRetorno.nota_pesoBalanca := vDadosNota.PesoBalanca;
      vRetorno.nota_pesoNota := vDadosNota.PesoLiquido;
      vRetorno.cfop_Codigo := vDadosNota.CodCfop;
      vRetorno.cfop_Descricao := vDadosNota.DescCfop;
      
    
    pkg_xml_nfe.sp_xml_itenspredominante(pChaveNfe,
                                         pStatus,
                                         pMessage,
                                         vCursorDadosProduto);
    
                         
                                       


    if ( pStatus = pkg_fifo.Status_Normal ) then
      
      loop
        fetch vCursorDadosProduto into vLinhaItensNota.Iten,
                                       vLinhaItensNota.xProd,
                                       vLinhaItensNota.vProd,
                                       vLinhaItensNota.CFOP;
        exit when vCursorDestino%notfound;
      end loop;

      
    end if;
    
    
     pkg_xml_nfe.SP_XML_GETNOTATOTAIS(pChaveNfe,
                                      vCursorDadosTotais,
                                      pStatus,
                                      pMessage);
    
                                      
     if ( pStatus = pkg_fifo.Status_Normal ) then
      
      loop
        
        fetch vCursorDadosTotais into vLinhaTotais.vBC,
                                      vLinhaTotais.vICMS,
                                      vLinhaTotais.vBCST,
                                      vLinhaTotais.vST,
                                      vLinhaTotais.vProd,
                                      vLinhaTotais.vFrete,
                                      vLinhaTotais.vDesc,
                                      vLinhaTotais.vII,
                                      vLinhaTotais.vIPI,
                                      vLinhaTotais.vPIS,
                                      vLinhaTotais.vCOFINS,
                                      vLinhaTotais.vOutro,
                                      vLinhaTotais.vNF;                   
        exit when vCursorDadosTotais%notfound;
        
      end loop;

          vRetorno.nota_ValorMerc := vLinhaTotais.vNF; 
      
    end if;
    

     

     if ( pStatus = pkg_fifo.Status_Erro) then  
          vRetorno.NotaStatus    := 'N';
          vRetorno.nota_chaveNFE := pChaveNfe;         
          pRetorno := vRetorno;
          Return;
     else 
          --VRetorno.nota_ValorMerc := vLinhaItensNota.VPROD;
          VRetorno.nota_descricao := Translate(substr(vLinhaItensNota.XPROD,1,50),'<>','  ');
          --VRetorno.cfop_Codigo    := vLinhaItensNota.CFOP;

     End if;      
      
      vRetorno.NotaStatus := 'N';
      
      
      pRetorno := vRetorno;
    EXCEPTION
      WHEN OTHERS THEN
        pStatus := pkg_fifo.Status_Erro;
        pMessage := 'Erro ao gerar o cursor de notas.'||chr(13)||sqlerrm||dbms_utility.format_error_backtrace;
    END;
         
  end if;

  
end;                                                  

/***************************************************************************************************************/
/* Procedure utilizada para buscar dados de uma coleta                                                         */
/***************************************************************************************************************/
procedure sp_getDadosColeta( pColeta  in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                             pArmazem in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                             pStatus  out char,
                             pMessage out varchar2,
                             pCursor  out T_CURSOR ) as
--Variável de controle
 vCount integer := 0;
 vArmazem tdvadm.t_arm_armazem.arm_armazem_codigo%type := '';
                            
begin
  begin
    select count(*), c.arm_armazem_codigo into vCount, vArmazem 
    from tdvadm.t_arm_coleta c 
    where c.arm_coleta_ncompra = lpad(pColeta, 6, '0')
    --Sirlano inserido em 20/12/2018
      and c.arm_coleta_ciclo = (select max(co.arm_coleta_ciclo)
                                from tdvadm.t_arm_coleta co
                                where co.arm_coleta_ncompra = c.arm_coleta_ncompra)
    group by c.arm_armazem_codigo;
    
    --Caso a coleta digitada não exista, finaliza o processamento
    if ( vCount = 0 ) then
      pStatus := pkg_fifo.Status_Erro;
      pMessage := 'Coleta não encontrada.';
      return;
    end if;
    
    --Caso encontre a Coleta, verifica se é do mesmo Armazem que está solicitando os dados.
    if (vCount = 1 ) then
      --Se não for do mesmo armazem, finaliza a operação.
      if Trim( vArmazem ) <> nvl(Trim(pArmazem ), 'R') then
        pStatus := pkg_fifo.Status_Erro;
        pMessage := 'A coleta de código '|| lpad(Trim(pColeta), 6, '0') ||' pertence ao armazem '|| vArmazem; 
        return;
      end if;
    end if;
  exception
    when others then
      pStatus := pkg_fifo.Status_Erro;
      pMessage := 'Erro ao validar dados da coleta.'||chr(13)||sqlerrm;
      return;
  end;
  
    begin
      open pCursor for
       Select 
         --Dados da Coleta "Numero e Tipo"
         coleta.arm_coleta_ncompra               NUMEROCOLETA,
         coleta.arm_coleta_tpcompra              TPCOLETA,
         --Dados do Remetente.
         cliRemetente.Glb_Cliente_Cgccpfcodigo   CNPJREMENTENTE,
         cliRemetente.Glb_Cliente_Razaosocial    NOMEREMETENTE,
         endRementente.Glb_Tpcliend_Codigo       TPENDREMENTENTE,
         endRementente.Glb_Cliend_Codcliente     CODCLIREMENTENTE, 
         endRementente.Glb_Cliend_Endereco       ENDREMENTENTE,
         
         --Dados do Destino
         cliDestino.Glb_Cliente_Cgccpfcodigo     CNPJDESTINO,
         cliDestino.Glb_Cliente_Razaosocial      NOMEDESTINO,

         endDestino.Glb_Tpcliend_Codigo          TPENDDESTINO,
         endDestino.Glb_Cliend_Codcliente        CODCLIDESTINO, 
         endDestino.Glb_Cliend_Endereco          ENDDESTINO,
         
         --Dados do Sacado
         'l' tpSacado,
         
         --Dados da Nota Fiscal
         to_char(0)                              NumNotaFiscal,
         ' '                                     SERIENOTA,
         ' '                                     DTEMISSAO,
         ' '                                     DTSAIDA,
         ' '                                     CHAVENFE,
         ' '                                     DESCRICAO,
         to_char(0)                              QTDEVOLUME,
         to_char(0)   VALORNOTA,
         to_char(0)                              PESOBALANCA,
         to_char(0)                              PESOLIQUIDO,
         ' '                                     CODCFOP,
         ' '                                     DESCCFOP,
         'CO'                                    TIPODADO,
         endRementente.Glb_Localidade_Codigo     CodLocRemet,
         locRemetente.Glb_Localidade_Descricao   DescLocRemet,
         endDestino.Glb_Localidade_Codigo        CodLocDestino,
         locDestino.Glb_Localidade_Descricao     DescLocDestino
         
         
       FROM 
         tdvadm.t_arm_coleta      coleta,
         tdvadm.t_glb_cliente     cliRemetente, 
         tdvadm.t_glb_cliend      endRementente,
         tdvadm.t_glb_localidade  locRemetente,
         tdvadm.t_glb_cliente     cliDestino,
         tdvadm.t_glb_cliend      endDestino,
         TDVADM.t_Glb_Localidade  locDestino
       WHERE
            coleta.glb_cliente_cgccpfcodigocoleta = cliRemetente.Glb_Cliente_Cgccpfcodigo
        and coleta.glb_cliente_cgccpfcodigocoleta = endRementente.Glb_Cliente_Cgccpfcodigo
        and coleta.glb_tpcliend_codigocoleta      = endRementente.Glb_Tpcliend_Codigo
        and endRementente.Glb_Localidade_Codigo   = locRemetente.Glb_Localidade_Codigo
        
            
        and coleta.glb_cliente_cgccpfcodigoentreg = cliDestino.Glb_Cliente_Cgccpfcodigo
        and coleta.glb_cliente_cgccpfcodigoentreg = endDestino.Glb_Cliente_Cgccpfcodigo
        and coleta.glb_tpcliend_codigoentrega     = endDestino.Glb_Tpcliend_Codigo
        and endDestino.Glb_Localidade_Codigo      = locDestino.Glb_Localidade_Codigo
        

        
        and coleta.arm_coleta_ncompra = lpad(pColeta, 06, '0')
        and coleta.arm_coleta_ciclo = ( select max(col.arm_coleta_ciclo)
                                        from t_arm_coleta col
                                        where col.arm_coleta_ncompra = coleta.arm_coleta_ncompra ) ;   
        
        pStatus := PKG_FIFO.Status_Normal;
        pMessage := '';      
    exception 
      when others then
        pStatus := PKG_FIFO.Status_Erro;
        pMessage := 'Erro ao localizar os Dados da coleta.';
    end;

    
  
end sp_getDadosColeta;                             



/* Função utilizada para definir o tipo do Sacado */ 
Function fn_defineTpSacado( pCnpjRemet  In  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                            pCnpjDest   In  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                            pCnpjSacado In  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type
                           ) Return Char Is
Begin
  If ( Trim(pCnpjRemet) = Trim(pCnpjSacado) ) Then
    Return 'R';
  End If;


  If (Trim(pCnpjDest) = Trim(pCnpjSacado) ) Then
    Return 'D';
  End If;
  
  
  Return 'O';
   
End;                           


/* Procedure utilizada para buscar os dados da Nota-Mae, quando tivermos uma nota Vide. */
procedure sp_getVideNota( pNotaVide    in  tdvadm.t_arm_notavide.arm_notavide_numero%type,
                          pCnpjVide    in  tdvadm.t_arm_notavide.arm_notavide_cgccpfremetente%type,
                          pSerieVide   in  tdvadm.t_arm_notavide.arm_notavide_serie%type,
                          pSeqVide     in  tdvadm.t_arm_notavide.arm_notavide_sequencia%type,
                          pVideNota    in  integer,
                          pNotaMae     out tdvadm.t_arm_notavide.arm_nota_numero%type,
                          pCnpjMae     out tdvadm.t_arm_notavide.glb_cliente_cgccpfremetente%type,
                          pSerieMae    out tdvadm.t_arm_notavide.arm_nota_serie%type,
                          pSeqMae      out tdvadm.t_arm_notavide.arm_nota_sequencia%type
                            ) as

vCount integer := 0;                            
begin

  if pVideNota = 1 then
     --Verifico se existe um registro de vide nota
     select 
       count(*) into vCount
     from
       tdvadm.t_arm_notavide  nota
     where 
           nota.arm_notavide_numero         = pNotaVide
       and nota.glb_cliente_cgccpfremetente = pCnpjVide
       and nota.arm_notavide_serie          = pSerieVide
       and nota.arm_notavide_sequencia      = pSeqVide;
      
     begin
       select
         nota.arm_nota_numero,
         nota.glb_cliente_cgccpfremetente,
         nota.arm_nota_serie,
         nota.arm_nota_sequencia
       into
         pNotaMae,
         pCnpjMae,
         pSerieMae,
         pSeqMae 
       from
         tdvadm.t_arm_notavide  nota
       where 
             nota.arm_notavide_numero         = pNotaVide
         and nota.glb_cliente_cgccpfremetente = pCnpjVide
         and nota.arm_notavide_serie          = pSerieVide
         and nota.arm_notavide_sequencia      = pSeqVide;
     exception
       when others then
         raise_application_error(-20001, 'Erro com Vide Nota' ||chr(13)|| Sqlerrm );
     end;
  end if;     
end;    

function Fn_Existe_Contrato(pContratoCodigo In t_Slf_Contrato.Slf_Contrato_Codigo%type) return Char
As  
  vResult Char(1);
begin
    Select Case Count(*)
            When 0 then 'N'
            Else 'S'
           End
      Into vResult
      From t_slf_contrato c
      Where trim(c.slf_contrato_codigo) = trim(pContratoCodigo);
      
    if vResult = 'N' then
        Begin
            Select Case Count(*)
                    When 0 then 'N'
                    Else 'S'
                   End
              Into vResult
              From t_slf_contrato c
              Where to_Number(trim(c.slf_contrato_codigo)) = to_Number(trim(pContratoCodigo));        
        Exception
          When Others Then
            vResult := 'N';
        End;
    end if;  
      
    return vResult;  
      
end Fn_Existe_Contrato;  

-----------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para Inserir / Atualizar / Consultar e Excluir Nota Fisca a partir de do FIFO.          --
-----------------------------------------------------------------------------------------------------------------

Procedure sp_InsertNota( pParamsEntrada In blob, 
                         pStatus         Out Char,
                         pMessage       Out Varchar2,
                         pParamsSaida    Out Clob  ) As
 --Variáveis utilizada para recuperar os valores passados como paramentros.
 vUsuario      tdvadm.t_usu_usuario.usu_usuario_codigo%Type;
 vAplicacao    tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type;
 vRota         tdvadm.t_glb_rota.glb_rota_codigo%Type;
 vArmazem      tdvadm.t_arm_armazem.arm_armazem_codigo%Type;
 vCodBusca     Varchar2(50) := '';
 vCodBuscaAux  Varchar2(50) := '';
 vTpBusca      Char(1):= '';
 vAuxiliar     number;
 vTemImpEtiqueta char(1);
    

 --Variável que controlará a solicitação do Front-End.
 vAcao         Char(1) := '';  --Opção Válidas = B=BUSCA; L=ETIQUETA; E=EDIÇÃO / INSERIR; D=EXCLUIR; V=TESTE DE VALIDAÇÃO 
 
 
 --Variável utilizada para recuperar os paramentros da aplicação
 vArrayParamentros   glbadm.pkg_glb_auxiliar.tArrayParams;
 
 --Variáveis utilizadas para recuperar valores de paramentros.
 vDias_coleta_CIF Integer := 0; --CIF/FCA A ENTREGAR 
 vDias_coleta_FOB Integer := 0; --FOB A COLETAR 
 vPermExcXml      Char(1) := ''; --Permissão para excluir nota que veio do XML
 vAutTpDocs       Char(1) := ''; --Permissão para utilizar Documentos que não sejam notas Fiscais.
 
 --Variáveis utilizadas para gerar o XML de saida.
 vXmlRetorno   Clob;
 vXmlDadosNota  Clob;
 vXmlProdQuimicos Clob;
 vXmlTpDocumento  Clob;
 vXmlServAdicionais Clob;

 
 --Variável utilizada para receber valores de funçãos
 vRetorno    pkg_fifo.tRetornoFunc;
 vRetornoAux pkg_fifo.tRetornoFunc;
 
 --Variável do tipo tDadosNota, que sera preenchido durante a execução da procedure.
 vDadosNota   TDVADM.pkg_fifo.tDadosNota;
 vDadosNotaColeta pkg_fifo.tDadosNota;
 
 --Variável do tipo tDadosProdutosQuimicos, que será preenchida durante a execução da procedure
 vProdQuimico pkg_fifo.tDadosProdutosQuimicos;
 
 --Variável de Controle.
 vCount Integer := 0;
 
 --Documento default
  vTpDoc_Default  tdvadm.t_con_tpdoc.con_tpdoc_descricao%Type:= '';
  
  vFinalizaDigitacao Char(1);
  vCriarColeta       Char(1);
  vQtdeNotaCol       integer;
  vNrColeta          t_arm_coleta.arm_coleta_ncompra%type;
  vNrColetaCiclo     t_arm_coleta.arm_coleta_ciclo%type;
  
  vStatus            Char(1);
  vMessage           Varchar2(4000);
  vSacadoGrpVale     integer;
  vColeta_Codigo     Varchar2(50);
  vColeta_Tipo       Varchar2(50);
  P_QRYSTR           clob;
Begin
 
 Begin


  pStatus := 'N';

/*  Modelo de um XML de entrada
/*
<Parametros>
   <Inputs>
      <Input>
         <usuario>jdemariz</usuario>
         <aplicacao>carreg</aplicacao><
         rota>021</rota>
         <acao>E</acao>
         <finaliza_coleta>N</finaliza_coleta>
         <criar_coleta>S</criar_coleta>
         <Tables>
            <Table name="prodQuimicos">
               <Rowset><Row num="1"><codOnu>9999</codOnu><DescOnu>PRODUTO QUIMICO SEM CLASSIFICA</DescOnu><grp_Emb>SE</grp_Emb><qtdeEmb>1</qtdeEmb><pesoEmb>1</pesoEmb></Row></Rowset>
             </Table>
             <Table name="dadosNota"><Rowset><Row num="1"><notaStatus>N</notaStatus><coleta_Codigo></coleta_Codigo><coleta_Tipo>E</coleta_Tipo><nota_Sequencia>0</nota_Sequencia><nota_numero>24847</nota_numero><nota_serie>001</nota_serie><nota_dtEmissao>27/10/2015</nota_dtEmissao><nota_dtSaida>28/10/2015</nota_dtSaida><nota_dtEntrada></nota_dtEntrada><nota_chaveNFE>35151011149881000123550010000248471028703125</nota_chaveNFE><nota_pesoNota>597</nota_pesoNota><nota_pesoBalanca>597</nota_pesoBalanca><nota_altura>0</nota_altura><nota_largura>0</nota_largura><nota_comprimento>0</nota_comprimento><nota_cubagem>0</nota_cubagem><nota_EmpilhamentoFlag>N</nota_EmpilhamentoFlag><nota_EmpilhamentoQtde>0</nota_EmpilhamentoQtde><nota_descricao>fios</nota_descricao><nota_qtdeVolume>1</nota_qtdeVolume><nota_ValorMerc>18624.68</nota_ValorMerc><nota_RequisTp>T</nota_RequisTp><nota_RequisCodigo>00001077</nota_RequisCodigo><nota_RequisSaque>6</nota_RequisSaque><nota_Contrato></nota_Contrato><nota_PO>4500727708</nota_PO><nota_Di></nota_Di><nota_Vide>0</nota_Vide><nota_flagPgto>D</nota_flagPgto><carga_Codigo>0</carga_Codigo><carga_Tipo>CA</carga_Tipo><vide_Sequencia>0</vide_Sequencia><vide_Numero>0</vide_Numero><vide_Cnpj></vide_Cnpj><vide_Serie></vide_Serie><mercadoria_codigo>54</mercadoria_codigo><mercadoria_descricao>PECAS/FERRAMENTAS/ACESS</mercadoria_descricao><cfop_Codigo>6101</cfop_Codigo><cfop_Descricao>Venda de Producao do Estabelecimento</cfop_Descricao><embalagem_numero>0</embalagem_numero><embalagem_flag></embalagem_flag><embalagem_sequencia>0</embalagem_sequencia><rota_Codigo>021</rota_Codigo><rota_Descricao></rota_Descricao><armazem_Codigo>06</armazem_Codigo><armazem_Descricao></armazem_Descricao><Remetente_CNPJ>11149881000123</Remetente_CNPJ><Remetente_RSocial>SANDVIK MAT. TECHNOLOGY DO BRASIL S/A  IND. COM.</Remetente_RSocial><Remetente_tpCliente>X</Remetente_tpCliente><Remetente_CodCliente></Remetente_CodCliente><Remetente_Endereco>X -  - AVENIDA SUECIA 3200</Remetente_Endereco><Remetente_LocalCodigo>05571</Remetente_LocalCodigo><Remetente_LocalDesc>SP - ARMAZEM SAO PAULO-SP</Remetente_LocalDesc><Destino_CNPJ>33390170001312</Destino_CNPJ><Destino_RSocial>APERAM INOX AMERICA DO SUL S/A.</Destino_RSocial><Destino_tpCliente>X</Destino_tpCliente><Destino_CodCliente></Destino_CodCliente><Destino_Endereco>X - APERAM-MG - AV 1 DE MAIO 09</Destino_Endereco><Destino_LocalCodigo>35180</Destino_LocalCodigo><Destino_LocalDesc>MG - TIMOTEO</Destino_LocalDesc><Sacado_CNPJ></Sacado_CNPJ><Sacado_RSocial></Sacado_RSocial><nota_tpDoc_codigo>55</nota_tpDoc_codigo></Row></Rowset></Table></Tables></Input></Inputs></Parametros>

*/
   P_QRYSTR := glbadm.pkg_glb_blob.f_blob2clob(pParamsEntrada);

    --Pego os Paramentros basicos dos Arquivo Xml, para definir a atidute a ser tomada.
    /* Thiago - 13/03/2020 - transformar em type para pegar o xml*/
    
    for c_msg in (Select 
       Trim( substr(extractvalue(value(Field) ,  'Input/usuario'),1,10) ) usuario
       ,Trim( extractvalue(value(Field) ,  'Input/aplicacao')) aplicacao
       ,Trim( extractvalue(value(Field) ,  'Input/rota') ) Rota
       ,Trim( extractValue(Value(Field) ,  'Input/acao') ) Acao
       ,Trim( extractvalue(value(Field) ,  'Input/armazem') ) Armazem
       ,substr(Trim( extractvalue(value(Field) ,  'Input/tpBusca') ),1,1) TpBusca
       ,Trim( extractvalue(value(Field) ,  'Input/codBusca') ) CodBusca
       ,Trim( extractvalue(value(Field) ,  'Input/coleta') ) Coleta_Codigo
       ,Trim( extractvalue(value(Field) ,  'Input/finaliza_coleta') ) Finalizacol
       ,Trim( extractvalue(value(Field) ,  'Input/criar_coleta') ) criacol
     from 
       --Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/Input'))) Field)
       Table(xmlsequence( Extract(xmltype.createXml(P_QRYSTR) , '/Parametros/Inputs/Input'))) Field)
     loop

       vUsuario  := c_msg.usuario;
       vAplicacao := c_msg.aplicacao;
       vRota := c_msg.rota;
       vAcao := c_msg.acao;
       vArmazem := c_msg.armazem;
       vTpBusca := c_msg.tpbusca;
       vCodBusca := c_msg.codbusca;
       vFinalizaDigitacao := c_msg.finalizacol;
       vCriarColeta := c_msg.criacol;
       vColeta_Codigo := c_msg.Coleta_Codigo;
       
     End Loop;
                
     If vUsuario = 'jsantos' Then
        insert into tdvadm.t_glb_sql values(pParamsEntrada, sysdate,'INSERINOTA-ERRO','INSERINOTA-ERRO');
        commit;
        --RETURN;
     End If;


  Exception
    When Others Then
--      insert into t_glb_sql values(pParamsEntrada, sysdate,'INSERINOTA-ERRO','INSERINOTA-ERRO');
--      commit;
      pStatus := pkg_fifo.Status_Erro;
      pMessage := Substr('Erro ao extrair Dados do pParamsEntrada (xmlIn).' || chr(13) || Sqlerrm, 1, 1000);
      Return;
  End;
 
/*    if ( lower(trim(vUsuario)) in ('bbernardo','jsantos','jdemariz') ) \*and ( vAcao <> 'B' )*\ Then
       insert into tdvadm.t_glb_sql values(pParamsEntrada, sysdate,'INSERINOTA','INSERINOTA');
       commit;
--       pMessage := 'Pegando XML de Entrada';
--       return;
--    Else
--      pStatus := pkg_glb_common.Status_Erro;
--      pMessage := 'RECEBIMENTO PARADO ...';
--      return;
    End If;
*/
  --if (vUsuario = 'sbgomes') and (vAcao != 'llll') then
   --  insert into dropme d (l,a) values(pParamsEntrada, 'RECEBIMENTO_FELIPE');commit;
  --end if;

/* If ( Trim(lower(vUsuario)) in ('bbernardo') ) Then
   if vAcao not in ('B') then
      pStatus := 'E';
      pMessage := pParamsEntrada;
      Delete dropme de Where de.a = 'recebimento';
      Insert Into t_glb_sql (glb_sql_instrucao,
                             glb_sql_dtgravacao,
                             glb_sql_programa)                      
                      Values 
                            (pParamsEntrada,
                             sysdate,
                             'recebimento pkg_fifo_recebimento.sp_InsertNota');
      Commit;
      Return;
    end if;
  End If;*/


  --Rodo a procedure utilizada para buscar os paramentros da aplicação.
  glbadm.pkg_glb_auxiliar.sp_Cursor_Params( vUsuario,         --Usuario
                                            vAplicacao,       --Aplicacao 
                                            vRota,            --Rota  
                                            vArrayParamentros --Array para ser populado com os paramentros.
                                           );
  
  --Corro o Array de paramentros para pegar os valores específicos.
  For i In vArrayParamentros.first .. vArrayParamentros.last Loop
    
    --Quantidade de dias, entre a data de programação e a utilização de uma coleta.
    If vArrayParamentros(i).PERFIL = 'DIASUTEIS_COLETA_CIF' Then  vDias_coleta_CIF := vArrayParamentros(i).NUMERICO1; End If;    
    If vArrayParamentros(i).PERFIL = 'DIASUTEIS_COLETA_FOB' Then  vDias_coleta_FOB := vArrayParamentros(i).NUMERICO1; End If;
    
    --Caso o usuario tente excluir uma nota fiscal que foi dada entrada através do Processo XML.
    If vArrayParamentros(i).PERFIL = 'EXNTARMCXML'          Then  vPermExcXml      :=  Trim(vArrayParamentros(i).TEXTO); End If;

    --autorização para buscar tipos de documentos diferentes de Nota fiscal.
    If vArrayParamentros(i).PERFIL = 'AUT_TPDOC'            Then  vAutTpDocs       :=  Trim(vArrayParamentros(i).TEXTO); End If;
      
    If vArrayParamentros(i).PERFIL = 'IMPRESSORAETIQUETA'   Then  vTemImpEtiqueta  :=  Trim(vArrayParamentros(i).TEXTO); End If;
    
  End Loop;

  --Se a ação for do tipo B, quer dizer que uma busca por dados iniciais, a partir de um código.
  If vAcao = cBusca Then

     If vTpBusca = '2' Then -- Pesquisa pela BARRA
        select count(*)
          into vCount
        from tdvadm.t_xml_nfe nf
        where nf.xml_nfe_id = vCodBusca;
        If ( vCount = 0 ) and  ( vColeta_Codigo is not null ) Then
           pMessage := pMessage || 'XML da nota não DISPONIVEL!, Pesquisando somente pela COLETA.' || chr(10);
           vCodBusca := vColeta_Codigo;
           vTpBusca := '1';
        End If;   
     End if;

    --Se o Código de Busca for Tipo de Busca For Zero, Tipo Fixo da Aplicação. Busca pela Sequencia da nota (Chave da t_arn_nota ).
    If vTpBusca = '0' Then
      --Verifico se a Nota pertence a Rota do Usuario.
      BEGIN 
         vRetorno := FNP_Valida_ArmazemNota( vCodBusca, vRota );  
      EXCEPTION
        WHEN OTHERS THEN 
          pStatus := 'E';
          pMessage := SQLERRM;
          RETURN;
      END;
      --Caso a solicitação não passe na Validação, mostro na tela a mensagem gerada pela função.
      If vRetorno.Status <> pkg_fifo.Status_Normal Then
        pStatus := vRetorno.Status;
        pMessage := pMessage || ' ' || vRetorno.Message;
        Return;
      Else
        --Rodo a Função que vai retornar um Objeto "tDadosNota" preenchido.
        vDadosNota := FNP_getDadosNotaSeq(vCodBusca);  
      End If;
    --Foi implementado o Tipo 01 = Código de Coleta"
    --                        03 = Pedido
    ElsIf vTpBusca = '1' Then
       

      --Caso a Coleta, não passe pela validação, mostro mensagem que foi gerada pela função
      If vRetorno.Status <> pkg_fifo.Status_Normal Then
        pStatus := vRetorno.Status;
        pMessage := pMessage || ' ' || vRetorno.Message;
        Return;
      Else
          --Rodo a Função que vai retornar um objeto "tDadoNota" preenchido.
          vDadosNota := FNP_getDadosNotaColeta( vCodBusca );
          If vDadosNota.Status <> pkg_fifo.Status_Normal Then
            pStatus := vDadosNota.Status;
            pMessage := pMessage || ' ' || vDadosNota.Message;
            Return;
          end if;        
      End If;    
                                      
    -- caso a busca seja realizada através de uma chave NFE
    ElsIf vTpBusca = '2' or vTpBusca = '3' Then
      
      if (vColeta_Codigo is not null) Then
        vDadosNotaColeta := FNP_getDadosNotaColeta(vColeta_Codigo);
      End if;
      select count(*)
        into vCount
      from tdvadm.t_xml_nfe nf
      where nf.xml_nfe_id = vCodBusca;
      If vCount = 0 Then
         pMessage := pMessage || 'XML da nota não DISPONIVEL!';
         If vColeta_Codigo is not null Then 
            pMessage := pMessage || ', Pesquisando somente pela COLETA.';
         End If;
         pMessage := pMessage || chr(10);
         pStatus := 'E';
         Return;
      Else   
         sp_getDadosNota_chaveNFE( vCodBusca,vDadosNotaColeta,pStatus, pMessage, vDadosNota );      
      End If;
      
      
      if (vColeta_Codigo is not null) /*and ( vCount = 0 )*/ Then
         vDadosNota.coleta_Codigo := vDadosNotaColeta.coleta_Codigo;
         vDadosNota.coleta_Ciclo  := vDadosNotaColeta.coleta_Ciclo;
--         If Not tdvadm.pkg_fifo_validadoresnota.FN_Valida_NotaColeta(vDadosNota,pMessage) Then
--            pStatus := 'E';
--            Return;
--         End If;
      End If;    
    -- Pesquisa por Vide Nota (Nota Mae)   
    Elsif vTpBusca = '4' Then

          Begin
             SELECT N.ARM_NOTA_SEQUENCIA
               into vCodBuscaAux 
             FROM T_ARM_NOTA N
             WHERE 0 = 0
               AND N.ARM_NOTA_NUMERO = f_extrai(1,vCodBusca,';')
               AND N.GLB_CLIENTE_CGCCPFREMETENTE = f_extrai(2,vCodBusca,';')
               AND N.ARM_NOTA_SERIE = f_extrai(3,vCodBusca,';')
               AND N.ARM_ARMAZEM_CODIGO = vArmazem;
             vCodBusca := vCodBuscaAux;
          Exception
            When NO_DATA_FOUND Then
               pStatus := 'E';
               pMessage := 'Nota Mae Não Encontrada [' || vCodBusca || '] Não Encontrado... ou Coleta já foi Finalizada! ';
               return;
            End;

       
       vDadosNota                  := FNP_getDadosNotaSeq( vCodBusca );
       vDadosNota.nota_Sequencia   := null;
       vDadosNota.nota_qtdeVolume  := 0;
       vDadosNota.nota_pesoNota    := 0;
       vDadosNota.nota_pesoBalanca := 0;
       vDadosNota.nota_Vide        := 1;
       vDadosNota.vide_Numero      := f_extrai(1,vCodBusca,';');
       vDadosNota.vide_Cnpj        := f_extrai(2,vCodBusca,';');
       vDadosNota.vide_Serie       := f_extrai(3,vCodBusca,';');
       vDadosNota.vide_Sequencia   := vCodBusca;
       vDadosNota.nota_descricao   := null;
       vDadosNota.nota_chaveNFE    := null;
       vDadosNota.nota_numero      := null;
       vDadosNota.nota_serie       := null;
       vDadosNota.nota_dtEmissao   := null;
       vDadosNota.nota_dtSaida     := null;
       vDadosNota.nota_dtEntrada   := null;
       
       If vDadosNota.Status <> pkg_fifo.Status_Normal Then
         pStatus := vDadosNota.Status;
         pMessage := vDadosNota.Message;
         Return;
       end if;        
    
    End If;
    
  End If;
    
  --Se o Tipo da Ação for um dos Tipos "E, D ou V", o Front-end estará enviando um arquivo XML com dados da nota preenchido.

  If vAcao In (cEdicaoInsert, cExcluir, cValidacao, cEtiqueta) Then
    --Qualquer um dos casos, precisarei recuperar os valores do Xml, e popular um objeto tDadosNota.
    --Rodo a Função "FNP_GETDADOSNOTAXML"
    -- Thiago -13/03/2020
    --vDadosNota := FNP_getDadosNotaXml( pParamsEntrada );
    vDadosNota := FNP_getDadosNotaXml( P_QRYSTR );
    -- ToDo...: Valida Contrato....
    --if 'N' != Fn_Existe_Contrato(vDadosNota.nota_Contrato) then
    --    Raise_Application_Error(-20001, 'Número do contrado não é valido');
    --end if;
   
    --Eu adicionei as variáveis de status para poder verificar se o processo ocorreu com sucesso.
    If vDadosNota.Status <> pkg_fifo.Status_Normal Then
      --Caso ocorra algum erro, mostro na tela a mensagem gerada pela função.
      pStatus := vDadosNota.Status;
      pMessage := vDadosNota.Message;
      Return;
    End If;
    
    -- Incluir, Editar a nota
    If vAcao = cEdicaoInsert Then
      vDadosNota.usu_usuario_codigo := vUsuario;
      
        -- Retirar..........
/*        if trim(lower(vUsuario)) = 'xbbernardo' then
          Insert Into t_glb_sql values(pParamsEntrada,sysdate, 'RECEBIMENTO__', 'RECEBIMENTO__');
          commit;
          Raise_Application_Error(-20001, pParamsEntrada);
        end if;      
*/      
        --Define os Dados Complementares
        spp_CompletaVarNotas( vDadosNota, vRetorno.Status, vRetorno.Message );
        
        --Caso não consiga completar os dados complementares encerra o processamento, e mostra mensagem.
        If vRetorno.Status <> pkg_fifo.Status_Normal Then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          Return;
        End If;
        
        
/*        If nvl(pStatus,'N') <> 'N' Then
           Return;
        End If;
*/        
               
        
      --Caso o Status da Nota seja "S", quer dizer que a nota já foi salva.
      If Trim(nvl(vDadosNota.NotaStatus,'N')) = 'S' Then
        --Verifica se a nota pode ser atualizada.
        vRetorno := FNP_Valida_Atualizacao( vDadosNota );
        
        --Se o retorno não for normal, quer dizer que a nota não pode ser atualizada.
        if vRetorno.Status <> pkg_fifo.Status_Normal then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          return;
        end if;
        
        


        --Função utilizada para inserir produtos quimicos.
        -- Thiago -13/03/2020
        --vProdQuimico := FNP_Ins_ProdutosQuimicos( pParamsEntrada,
        vProdQuimico := FNP_Ins_ProdutosQuimicos( P_QRYSTR,
                                              vDadosNota.nota_numero, 
                                              vDadosNota.nota_Sequencia,
                                              vDadosNota.nota_serie,
                                              vDadosNota.Remetente_CNPJ,
                                              vDadosNota.coleta_Codigo,
                                              vDadosNota.coleta_Ciclo
                                              ); 

        If vProdQuimico.Status <> pkg_fifo.Status_Normal Then
          pStatus := vProdQuimico.Status;
          pMessage := vProdQuimico.Message;
          Return;
        End If; 
        
        
        
        vRetorno := FNP_Ins_VideNota( vDadosNota );
        
        If vRetorno.Status <> pkg_glb_common.Status_Nomal Then
          pStatus := vRetorno.Status ;
          pMessage := vRetorno.Message;
          Return;
        End If;
        
        --Dados de redespacho
        -- Thiago -13/03/2020
        --If ( Not FNP_Ins_Redespacho( pParamsEntrada, vDadosNota, vRetorno.Message) ) Then
        If ( Not FNP_Ins_Redespacho( P_QRYSTR, vDadosNota, vRetorno.Message) ) Then
          pStatus := PKG_GLB_COMMON.Status_Erro;
          pMessage:= vRetorno.Message;
          Return;
        End If;
        
        
       vDadosNota.Onu_Codigo := vProdQuimico.onu_codigo;
       vDadosNota.Onu_GrpEmb := vProdQuimico.onu_grpEmb;

        vRetorno := FNP_ValidaNota( vDadosNota );
        if vRetorno.Status <> pkg_fifo.Status_Normal then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          return;
        end if;


        --Rodo a procedure que vai atualizar a nota.
        vRetorno := FNP_AtualizaDadosNota( vDadosNota, vProdQuimico, vUsuario );
        
        --Indiferente do retorno, encerra o processamento, e devolve a informação gerada na função.
        pStatus := vRetorno.Status;
        pMessage := vRetorno.Message;
        
        
        
      End If;
      



      --Caso o Status da Nota seja "N", quer dizer que a nota ainda não foi salva.
      if Trim(nvl(vDadosNota.NotaStatus,'N')) = 'N' Then
        
        If vRetorno.Status = pkg_fifo.Status_Normal Then

           -- Verifica se Finaliza Digitacao da Coleta
           vAuxiliar := 0;
           select count(*)
             into vAuxiliar
           From tdvadm.t_slf_clienteregras c
           Where c.slf_contrato_codigo = trim(vDadosNota.nota_Contrato)
             and c.slf_clienteregras_fimdigitnota = 'S'
             and c.slf_clienteregras_ativo = 'S';
           if (vAuxiliar > 0) then
              vFinalizaDigitacao := 'S';
           end if;  

           -- Pode Criar coleta no FIFO
           vAuxiliar := 0;
           select count(*)
             into vAuxiliar
           from tdvadm.t_slf_clienteregras c
           Where c.slf_contrato_codigo = trim(vDadosNota.nota_Contrato)
             and c.slf_clienteregras_criacolfifo = 'N'
             and c.slf_clienteregras_ativo = 'S';
            
          
          If ( vAuxiliar > 0 ) Then
             If (vCriarColeta = 'S') Then
               If ( NVL(vDadosNota.nota_RequisTp,'T') = 'T' )  Then
                  pMessage := pMessage || Chr(13) || 'Para o Contrato ' || vDadosNota.nota_Contrato || ' não e permitido Criar coleta Com a Entrada da NOTA';
                  pStatus := pkg_fifo.Status_Erro;
                  vRetorno.Status := pkg_fifo.Status_Erro;
                  return;
               End If;
             End If;
             
          End If;
          

          if (vCriarColeta = 'S') and (nvl(vDadosNota.coleta_Codigo, '§§') = '§§' or vDadosNota.coleta_Codigo = '') then
--              insert into t_glb_sql values (pParamsEntrada,sysdate,'CRIANDO COLETA FIFO-'|| vUsuario,'CRIANDO COLETA FIFO');        
              --Caso a nota não tenha coleta, cria-se uma
              If ( Not FNP_Cria_Coleta(vDadosNota, vDadosNota.coleta_Codigo, vDadosNota.coleta_Ciclo, vRetorno.Message ) ) Then                                                                                                            
                   pStatus := pkg_glb_common.Status_Erro;
                   pMessage := pMessage || ' ' || vRetorno.Message;
                   Return; 
--              Else
--                 insert into t_glb_sql values (pParamsEntrada,sysdate,'ERRO-CRIANDO COLETA FIFO-'|| vUsuario,'ERRO-CRIANDO COLETA FIFO');
              End If;
              
             -- Verificar se e para mudar o Tipo da Coleta.
             -- Sirlano 28/10/2015
             
              update t_arm_coleta c
                 set --c.arm_coletaocor_codigo = '54', -- 54 = ENTRADA DE NOTA NO ARMAZEM
                     --c.arm_coleta_entcoleta = nvl(upper(vDadosNota.coleta_Tipo), 'E'),
--                     c.arm_coleta_entcoleta    = Case NVL(upper(vDadosNota.coleta_Tipo), 'FOB') When 'FOB' Then 'C' Else 'E' End,
                     c.arm_coleta_entcoleta    = Case NVL(upper(trim(vDadosNota.coleta_Tipo)), 'C') When 'C' Then 'C' Else 'E' End,
                     c.arm_coleta_tipo         = Case NVL(upper(trim(vDadosNota.coleta_Tipo)), 'C') When 'C' Then 'COLETA' Else 'ENTREGA' End,
                     c.arm_coleta_tpcompra     = Case NVL(upper(trim(vDadosNota.coleta_Tipo)), 'C') When 'C' Then 'FOB' Else 'FCA' End,
                     c.arm_coleta_pagadorfrete = decode(vDadosNota.nota_flagPgto,'O','S',vDadosNota.nota_flagPgto),
                     c.arm_coleta_cnpjsolicitante = vDadosNota.Sacado_CNPJ,
                     c.usu_usuario_codigofecha = vUsuario,
                     c.arm_coleta_tpcoleta     = decode(substr(c.glb_tpcarga_codigo,1,1),'E','E','N') -- Case NVL(upper(vDadosNota.coleta_Tipo), 'FOB') When 'FOB' Then 'C' Else 'E' End
               where c.arm_coleta_ncompra = vDadosNota.coleta_Codigo
                 and c.arm_coleta_ciclo = vDadosNota.coleta_Ciclo;  
              commit;            
              pMessage := pMessage || ' ' || vRetorno.Message;
              
          elsif (vCriarColeta = 'N') and (nvl(vDadosNota.coleta_Codigo, '§§') = '§§' or vDadosNota.coleta_Codigo = '') then          
                pStatus := pkg_glb_common.Status_Erro;
                pMessage := 'Erro ao Gravar Nota, nota está sem Coleta!!!';
                Return;              
          end if;
          /***************************************************************/  



          -- Verifica se pode Ter Mais de uma Nota por Coleta
          vQtdeNotaCol := 0;
          Begin
             select distinct slf_clientecargas_QTDENotaCOL
               into vQtdeNotaCol
             from tdvadm.t_slf_clientecargas c
             Where c.slf_contrato_codigo = trim(vDadosNota.nota_Contrato)
               and c.slf_clientecargas_ativo = 'S';          
          Exception
            When OTHERS Then
               vQtdeNotaCol := 0;
            End;
            
          If vQtdeNotaCol > 0 Then
             select count(*)
               into vAuxiliar
             from t_arm_nota an
             where an.arm_nota_dtinclusao >= '01/01/2016'
               and an.arm_coleta_ncompra = nvl(vDadosNota.coleta_Codigo, '§§')
               and an.arm_coleta_ciclo = nvl(vDadosNota.coleta_Ciclo,'§§');
          End If;
             
          If ( vAuxiliar  > vQtdeNotaCol ) Then
             pMessage := pMessage || Chr(13) || 'Coleta [' || vDadosNota.coleta_Codigo || '] Superou o Limite de Notas. Limite [' || to_char(vQtdeNotaCol) || '] Para o Contrato [' || vDadosNota.nota_Contrato || ']';
             pStatus := pkg_fifo.Status_Erro;
             vRetorno.Status := pkg_fifo.Status_Erro;
             return;
          End If;



          If  Not pkg_fifo_validadoresnota.FN_Valida_NotaColeta(vDadosNota,pMessage) Then 
             pStatus := pkg_glb_common.Status_Erro;
             pMessage := pMessage;
             return;
          End If; 
          




          
        end if;        

    -- Desativada em 20/04/2106
    -- Sirlano, para permitir que a nota entre para ser validada pelo Juridico
      --tanto para Edição como Inserção, primeiro tenho que validar a nota.
      -- Reativando em 02/05/2016
      -- O Valida Nota quando não tem Carregamento deixa entrar 
      -- Caso contrario Bloqueia.
      vRetorno := FNP_Valida_NotaFiscal( vDadosNota, vUsuario, vAplicacao, vRota );  
      
      If  Not tdvadm.pkg_fifo_validadoresnota.FN_Valida_NotaColeta(vDadosNota,pMessage) Then 
          pStatus := pkg_glb_common.Status_Erro;
          vRetorno.Status := pkg_glb_common.Status_Erro;
          vRetorno.Message := vRetorno.Message || pMessage;
      End If; 
      --Se Validação não retornar com sucesso, encerro o processamento e devolvo a mensagem gerada pela função
      If vRetorno.Status <> pkg_fifo.Status_Normal Then
        
        if (vCriarColeta = 'S') and (vDadosNota.coleta_Codigo is not null) and (vDadosNota.coleta_Ciclo is not null) then
           begin
             update t_arm_coleta c
                set c.arm_coletaocor_codigo = '61' -- 61 = Coleta Criada automática e cancelada (Finaliza)
              where c.arm_coleta_ncompra = vDadosNota.coleta_Codigo
                and c.arm_coleta_ciclo = vDadosNota.coleta_Ciclo;
             commit;
           exception
             when Others Then
               pMessage := sqlerrm || chr(13)|| vRetorno.Message;
               pStatus := 'E';
           end;          
        end if; 
      
        pStatus := vRetorno.Status;
        pMessage := substr(vRetorno.Message,1,32000);
        Return;
      End If;
      
       --Verifico se a Nota ainda Não foi Lançada 
        vRetorno  := FNP_VerifaNotaLancada( vDadosNota, 5 );
        
        
        
        --Caso a função tenha retornado com erro, encerro o processamento e mostro na tela.
        if vRetorno.Status <> pkg_fifo.Status_Normal then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          return;
        end if;
        
        --inicia As inserções nas tabelas necessárias.
        
        --PRODUTOS QUIMICOS.
        -- Thiago -13/03/2020
        --vProdQuimico := FNP_Ins_ProdutosQuimicos( pParamsEntrada, 
        vProdQuimico := FNP_Ins_ProdutosQuimicos( P_QRYSTR, 
                                                  vDadosNota.nota_numero, 
                                                  vDadosNota.nota_Sequencia,
                                                  vDadosNota.nota_serie,
                                                  vDadosNota.Remetente_CNPJ,
                                                  vDadosNota.coleta_Codigo,
                                                  vDadosNota.coleta_Ciclo
                                                ); 
                                                
        --caso a atualização dos produtos químicos de algum erro, 
        If vProdQuimico.Status <> pkg_fifo.Status_Normal Then
          pStatus := vProdQuimico.Status;
          pMessage := vProdQuimico.Message;
          Return;
        End If; 
        -- Alimenta dados do Produto Quimico        
        vDadosNota.Onu_Codigo := vProdQuimico.onu_codigo;
        vDadosNota.Onu_GrpEmb := vProdQuimico.onu_grpEmb;

        
        --DADOS DE CARGA
        vRetorno := FNP_Ins_Carga( vDadosNota, vUsuario );
        
        If vRetorno.Status <> pkg_fifo.Status_Normal Then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          Return;
        End If;
        

        --EMBALAGEM
        vRetorno := FNP_Ins_Embalagem( vDadosNota, vUsuario, vProdQuimico);
        
        If vRetorno.Status <> pkg_fifo.Status_Normal Then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          Return;
        End If;

        
        --Dados de redespacho
        -- Thiago -13/03/2020
        --If ( Not FNP_Ins_Redespacho( pParamsEntrada, vDadosNota, vRetorno.Message) ) Then
        If ( Not FNP_Ins_Redespacho(P_QRYSTR, vDadosNota, vRetorno.Message) ) Then
          pStatus := PKG_GLB_COMMON.Status_Erro;
          pMessage:= vRetorno.Message;
          Return;
        End If;

        

        --Tabela de NOTA
        vRetorno := FNP_Ins_NotaFiscal( vDadosNota, vProdQuimico, vUsuario );

       If vRetorno.Status = pkg_glb_common.Status_Nomal Then
          If vDadosNota.nota_Vide = 1 Then
            vRetorno := FNP_Ins_VideNota( vDadosNota );
          End If;
       End If;
        
        --Busco novamente os dados da nota, agora com os dados atualizados.
        vDadosNota := FNP_getDadosNotaSeq( vDadosNota.nota_Sequencia );
        
       If vRetorno.Status <> pkg_fifo.Status_Normal Then
          pStatus  := vRetorno.Status;
          pMessage := vRetorno.Message;
       End If;
        
/*       If vRetorno.Status = pkg_glb_common.Status_Nomal Then
          If vDadosNota.nota_Vide = 1 Then
            vRetorno := FNP_Ins_VideNota( vDadosNota );
          End If;
       End If;
*/           
       If vRetorno.Status <> pkg_glb_common.Status_Nomal Then
          pStatus :=vRetorno.Status;
          pMessage := vRetorno.Message;
          If ( Not FNP_Del_NotaFiscal( vDadosNota.nota_numero,
                                       vDadosNota.Remetente_CNPJ,
                                       vDadosNota.nota_serie,
                                       vPermExcXml,
                                       vRetornoAux.Message,
                                       vDadosNota.nota_Sequencia)) Then
                  vRetornoAux.Status := 'E';                                
          End If;
          Return;
       End If;
       

        --CARGADET
        vRetorno := FNP_Ins_CargaDet( vDadosNota, vUsuario);
        
        If vRetorno.Status <> PKG_FIFO.Status_Normal Then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          Return;
        End If;
        
/*************************************************
Aqui que colocarei as criticas e excluir a nota caso tenha problema
*************************************************/

        If vRetorno.Status <> 'E' then

           vDadosNota.Onu_Codigo := vProdQuimico.onu_codigo;
           vDadosNota.Onu_GrpEmb := vProdQuimico.onu_grpEmb;

           vRetorno := FNP_ValidaNota(vDadosNota);
           If vRetorno.Status = 'E' Then
              If ( Not FNP_Del_NotaFiscal( vDadosNota.nota_numero,
                                           vDadosNota.Remetente_CNPJ,
                                           vDadosNota.nota_serie,
                                           vPermExcXml,
                                           vRetornoAux.Message,
                                           vDadosNota.nota_Sequencia) ) Then
                  vRetornoAux.Status := 'E';
                                           
               End If;
           End If;
           
        End If;
        
        If vRetorno.Status = 'E' Then
           pMessage := vRetorno.Message || Chr(13) || vRetornoAux.Message;
           Return;
        Else
           pMessage:= 'Nota Inserida com Sucesso. [6470]' ||chr(13) || chr(13) ||
                      'Embalagem número: '         || vDadosNota.embalagem_numero    || chr(13) ||
                      'Embalagem flag: '           || vDadosNota.embalagem_flag      || chr(13) ||
                      'Embalagem Sequencia: '      || vDadosNota.embalagem_sequencia; 
        End If;
                   
        if (vRetorno.Status = PKG_FIFO.Status_Normal) and (vDadosNota.coleta_Codigo is not null) and (vDadosNota.coleta_Ciclo is not null) then 
          pMessage := pMessage || chr(13) || 'Coleta: '||vDadosNota.coleta_Codigo;
        end if;
 
       /*
        --Busco por imagem de uma nota arquivado.
        Select Count(*) Into vCount From t_glb_nfimagem im
        Where lpad(Trim(im.con_nftransportada_numnfiscal), 9, '0') = lpad(vDadosnota.nota_numero, 9, '0')
         And Trim(im.glb_cliente_cgccpfcodigo) = Trim(vDadosNota.Remetente_CNPJ);
         
       --Caso encontre imagem da nota 
        If ( vCount > 0 ) Then
          pMessage := pMessage || chr(10) || chr(10) ||
                      'Nota fiscal já possui imagem arquivada.' || chr(10) ||
                      'Não é necessário escaneamente / atribuição de imagem.' ;
        End If;  
         
       */ 
       
        /*******************************************************************/
        
        
        -- implementado por Diego.... 
        if vFinalizaDigitacao != 'X' then
            if vFinalizaDigitacao = 'S' then
                Sp_Set_UpdateOcorEncerraDig(vDadosNota.coleta_Codigo, vDadosNota.coleta_Ciclo, vStatus, vMessage); 
                pMessage := pMessage || Chr(13) || vMessage;
            else
                pMessage := pMessage || Chr(13) || 'Digitação das Notas para está Coleta Em Aberto';
            end if;        
        end if;              
        
      end if;
      
      vDadosNota := FNP_getDadosNotaSeq(vDadosNota.nota_Sequencia);
      
      -- Ver se der erro excluir a Embalagem / Carga
      /*
      vRetorno := FNP_Valida_NotaFiscal( vDadosNota, vUsuario, vAplicacao, vRota );
      
      If vRetorno.Status <> pkg_fifo.Status_Normal Then
          pStatus := vRetorno.Status;
          pMessage := vRetorno.Message;
          Return;
      End If;
      */
    End If;
    
    -- Excluir a nota
    If vAcao = cExcluir Then
      --Rodo a Função responsável por excluir uma nota fiscal.
      If ( Not FNP_Del_NotaFiscal( vDadosNota.nota_numero,
                                   vDadosNota.Remetente_CNPJ,
                                   vDadosNota.nota_serie,
                                   vPermExcXml,
                                   vRetorno.Message,
                                   vDadosNota.nota_Sequencia
                                  ) ) Then
                                  
                               
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := vRetorno.Message;
        Return;
      Else
        pStatus := pkg_glb_common.Status_Warning;
        pMessage := 'Nota Fiscal excluída com sucesso. '||vRetorno.Message;
        Return;
     End If;   
     
     Return;
   End If;
     
    --Ação do Tipo "V", apenas faz a validação da nota. o Front-End está fazendo um "Teste".
    If vAcao = cValidacao Then
    -- Desativada em 20/04/2106
    -- Sirlano, para permitir que a nota entre para ser validada pelo Juridico
      --Rodo a Função que valida a Nota Fiscal.
      vRetorno := FNP_Valida_NotaFiscal( vDadosNota, vUsuario, vAplicacao, vRota );
      
      --Como é apenas validação, se a Função retornar normal, mostro mensagem de nota validada com sucesso,
      --ou devolvo a mensagem de erro.
      If vRetorno.Status <> pkg_fifo.Status_Normal Then
        pStatus := vRetorno.Status;
        pMessage := vRetorno.Message;
        Return;
      Else
        
        pMessage := 'Nota Fiscal: '             || vDadosNota.nota_numero       || chr(13) ||
                    'CNPJ Rementente: '         || vDadosNota.Remetente_CNPJ    || chr(13) ||
                    'Razão Social Rementente: ' || vDadosNota.Remetente_RSocial || chr(13) || chr(13) ||
                    'Validada com sucesso .' || vRetorno.Status;
        pStatus := 'W';
                 Return;            
      End If;
    End If;
    
    --Se a ação for do tipo "L", apenas atualizo a tabela adicionando a data da impressão da Etiqueta
    If vAcao = cEtiqueta Then
      Update t_arm_nota nota
        Set nota.arm_nota_dtetiqueta = to_char(Sysdate, 'dd/mm/yyyy hh24:mi:ss' )
      Where nota.arm_nota_sequencia = vDadosNota.nota_Sequencia;
      
      pkg_slf_contrato.SP_INFORMACLIENTE(vDadosNota.nota_numero, 
                                         vDadosNota.Remetente_CNPJ, 
                                         vDadosNota.nota_serie, 
                                         vDadosNota.armazem_Codigo ,
                                         vUsuario,
                                         'E', 
                                         vStatus, 
                                         vMessage);
      if( vStatus = pkg_fifo.Status_Normal ) Then
        Commit;
      else
        if( vMessage is not null ) Then
            pMessage := pMessage || chr(10) || vMessage;
        End If;
      End If;
      if ( vTemImpEtiqueta = 'N' ) Then
         vStatus := 'W';
         pMessage := pMessage || chr(10) || 'Nota Confirmada';
      End If;
    End If;
    
    -- Etiqueta Anderson
  End If;
  


  --Rodo a função que vai retornar um Arquivo XML recebendo como paramentro um objeto tDadosNota.

  If ( vAcao = cEtiqueta ) and ( vTemImpEtiqueta = 'N' ) Then
     -- Retorna um XML vazio para não imprimir a Etiqueta
     vRetorno :=  FNP_Xml_getXml( -1, vDadosNota );

  Else
     vRetorno := FNP_Xml_getXml( 0, vDadosNota );
  End If;
  
  --Função retornando erro, mostro a mensagem gerada pela função
  If vRetorno.Status <> pkg_fifo.Status_Normal Then
    pStatus := vRetorno.Status;
    pMessage := vRetorno.Message;
    Return;
  Else
    --Caso tenha retornado sem erro, atribuo o arquivo XML para a variável específica.
    vXmlDadosNota := Trim( vRetorno.Xml );  
  End If;
  
  --Busco os produtos quimicos da nota fiscal. 
  vRetorno := FNP_getDadosProdQuimicos( vDadosNota );
  
  --Função retornando erro, mostro a mensagem gerada pela função
  If vRetorno.Status <> pkg_fifo.Status_Normal Then
    pStatus := vRetorno.Status;
    pMessage := vRetorno.Message;
    Return;
  Else
    --caso tenha retornado sem erro, atribuo o arquivo XML para a variável específica.
    vXmlProdQuimicos := vRetorno.Xml;
  End If;
  

  --Busco os Servicos Adicionais da nota fiscal. 
  vRetorno := FNP_getDadosServAdicionais( vDadosNota );
  
  --Função retornando erro, mostro a mensagem gerada pela função
  If vRetorno.Status <> pkg_fifo.Status_Normal Then
    pStatus := vRetorno.Status;
    pMessage := vRetorno.Message;
    Return;
  Else
    --caso tenha retornado sem erro, atribuo o arquivo XML para a variável específica.
    vXmlServAdicionais := vRetorno.Xml;
  End If;
  
  
  
  
  --Vou criar um arquivo xml com a lista de tipo de documentos 
  vRetorno := FNP_getXML_TpDocumentos(vAutTpDocs, vDadosNota.nota_tpDocumento,vDadosNota.rota_Codigo ); 
  If vRetorno.Status <> pkg_glb_common.Status_Nomal Then 
    pStatus := vRetorno.Status;
    pMessage := vRetorno.Message;
    Return;
  Else
    vXmlTpDocumento := vRetorno.Xml; 
  End If;
  
   --Monta o arquivo propriamente dito.
   vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
   vXmlRetorno := vXmlRetorno || '<Table name=#prodQuimicos#><ROWSET>' || vXmlProdQuimicos || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#servadicionais#><ROWSET>' || vXmlServAdicionais || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#dadosNota#><ROWSET>'    || vXmlDadosNota    || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#tpDocumento#><ROWSET>'  || vXmlTpDocumento  || '</ROWSET></Table>';
   
   vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
   --Substitui os carecteres "CORINGAS"
   vXmlRetorno := Replace(vXmlRetorno, '#', '"');
   vXmlRetorno := Replace(vXmlRetorno, '§', '''');
   
  --Seto os Paramentros de Saida. 
  pParamsSaida := pkg_glb_common.FN_LIMPA_CAMPO( vXmlRetorno );
  pStatus := pkg_fifo.Status_Normal;
/* insert into tdvadm.t_glb_sql values (pParamsSaida,sysdate,'NOTA',vUsuario||'-NOTA');
*/
 commit ;
--  pMessage := '';
End sp_InsertNota;                  

   
-----------------------------------------------------------------------------------------------------------------
----PROCEDURE XML, Utilizada para inserir uma nota Filha a partir de uma Nota Mae
-----------------------------------------------------------------------------------------------------------------
Procedure sp_InsertNotaVide(pParamsEntrada In clob, 
                            pStatus         Out Char,
                            pMessage       Out Varchar2,
                            pParamsSaida    Out Clob  ) 
     As
     
  vParamsEntrada  clob;
  vParamsCriaNota clob;

  vUsuario           tdvadm.t_usu_usuario.usu_usuario_codigo%Type;
  vAplicacao         tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type;
  vRota              tdvadm.t_glb_rota.glb_rota_codigo%Type;
  vAcao              char(1);
  vArmazem           tdvadm.t_arm_armazem.arm_armazem_codigo%Type;
  vnotamae           tdvadm.t_arm_nota.arm_nota_numero%type;
  vemissao           char(10);
  vcodigobarra       char(44);
  vseriemae          tdvadm.t_arm_nota.arm_nota_serie%type;
  vcnpjmae           tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
  vchavemae          tdvadm.t_arm_nota.arm_nota_chavenfe%type;
  vnotavide          tdvadm.t_arm_nota.arm_nota_numero%type;
  vserievide         tdvadm.t_arm_nota.arm_nota_serie%type;
  vcnpjvide          tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
  vTpCliente         tdvadm.t_glb_cliend.glb_tpcliend_codigo%type;
  vTpCarga           tdvadm.t_arm_nota.glb_tpcarga_codigo%type;
  vCFOP              tdvadm.t_glb_cfop.glb_cfop_codigo%type;
  vpeso              tdvadm.t_arm_nota.arm_nota_peso%type;
  vvalormerc         tdvadm.t_arm_nota.arm_nota_valormerc%type; 
  vFinalizaDigitacao Char(1);
  vCriarColeta       Char(1);
  vTpBusca           Char(1):= '';
  vCodBusca          Varchar2(50) := '';
  vTpDocumento       tdvadm.t_con_tpdoc.con_tpdoc_codigo%type;

 --Variável utilizada para receber valores de funçãos
 vRetorno   pkg_fifo.tRetornoFunc;
 
 --Variável do tipo tDadosNota, que sera preenchido durante a execução da procedure.
 vDadosNota   pkg_fifo.tDadosNota;
 vDadosNotaColeta   pkg_fifo.tDadosNota;
 

  vStatus Char(1);
  vMessage Varchar2(4000);

  -- Thiago 
  vParamsCriaNotaB  blob;   
  Begin
    
  vParamsEntrada  := empty_clob();
  vParamsCriaNota := empty_clob();
  vParamsEntrada := pParamsEntrada;
  vParamsCriaNotaB  := empty_blob();
/*
--TICKET=4612&PESO=26070&VALOR=5598,27&NMAE=0023&EMITENTE=33592510007590&REMETENTE=99999948004206
  vParamsEntrada := '';
  vParamsEntrada := vParamsEntrada || '<Parametros>';
  vParamsEntrada := vParamsEntrada || '   <Inputs>';
  vParamsEntrada := vParamsEntrada || '      <Input>';
  vParamsEntrada := vParamsEntrada || '         <usuario>jrabelo</usuario>';
  vParamsEntrada := vParamsEntrada || '         <aplicacao>carreg</aplicacao>';
  vParamsEntrada := vParamsEntrada || '         <rota>160</rota>';
  vParamsEntrada := vParamsEntrada || '         <armazem>10</armazem>';
  vParamsEntrada := vParamsEntrada || '         <notamae>0023</notamae>';
  vParamsEntrada := vParamsEntrada || '         <seriemae>3</seriemae>';
  vParamsEntrada := vParamsEntrada || '         <cnpjmae>33592510007590</cnpjmae>';
  vParamsEntrada := vParamsEntrada || '         <chavemae></chavemae>';
  vParamsEntrada := vParamsEntrada || '         <tpdocumento>99<tpdocumento>';
  vParamsEntrada := vParamsEntrada || '         <emissao>' || trim(vEmissao) || '</emissao>';
  vParamsEntrada := vParamsEntrada || '         <codigobarra>' || trim(vCodigoBarra) || '</codigobarra>';
  vParamsEntrada := vParamsEntrada || '         <notavide>4612</notavide>';
  vParamsEntrada := vParamsEntrada || '         <serievide>0</serievide>';
  vParamsEntrada := vParamsEntrada || '         <cnpjvide>99999948004206</cnpjvide>';
  vParamsEntrada := vParamsEntrada || '         <tpendcliente>X<tpendcliente>';
  vParamsEntrada := vParamsEntrada || '         <tipocarga>CA<tipocarga>';
  vParamsEntrada := vParamsEntrada || '         <cfop>5350<cfop>';
  vParamsEntrada := vParamsEntrada || '         <peso>26070</peso>';
  vParamsEntrada := vParamsEntrada || '         <valormerc>5598.27</valormerc>';
  vParamsEntrada := vParamsEntrada || '         <finaliza_coleta>S</finaliza_coleta>';
  vParamsEntrada := vParamsEntrada || '         <criar_coleta>S</criar_coleta>';
  vParamsEntrada := vParamsEntrada || '      </Input>';
  vParamsEntrada := vParamsEntrada || '   </Inputs>';
  vParamsEntrada := vParamsEntrada || '</Parametros>';
*/
   Begin   
      Select Trim( substr(extractvalue(value(Field) ,  'Input/usuario'),1,10) ),
             Trim( extractvalue(value(Field) ,  'Input/aplicacao')),
             Trim( extractvalue(value(Field) ,  'Input/rota') ),
             'E',
             Trim( extractvalue(value(Field) ,  'Input/armazem') ),
             Trim( extractvalue(value(Field) ,  'Input/notamae') ),
             Trim( extractvalue(value(Field) ,  'Input/seriemae') ),
             Trim( extractvalue(value(Field) ,  'Input/cnpjmae') ),
             Trim( extractvalue(value(Field) ,  'Input/chavemae') ),
             Trim( extractvalue(value(Field) ,  'Input/emissao') ),
             Trim( extractvalue(value(Field) ,  'Input/codigobarra') ),

             Trim( extractvalue(value(Field) ,  'Input/tpdocumento')),
             Trim( extractvalue(value(Field) ,  'Input/notavide') ),
             Trim( extractvalue(value(Field) ,  'Input/serievide') ),
             Trim( extractvalue(value(Field) ,  'Input/cnpjvide') ),
             Trim( extractvalue(value(Field) ,  'Input/tpendcliente')),
             Trim( extractvalue(value(Field) ,  'Input/tipocarga')),
             Trim( extractvalue(value(Field) ,  'Input/cfop')),  
             Trim( extractvalue(value(Field) ,  'Input/peso') ),
             Trim( extractvalue(value(Field) ,  'Input/valormerc') ),
             Trim( extractvalue(value(Field) ,  'Input/finaliza_coleta') ),
             Trim( extractvalue(value(Field) ,  'Input/criar_coleta') )
         Into vUsuario,
              vAplicacao,
              vRota, 
              vAcao,
              vArmazem,
              vnotamae,
              vseriemae,
              vcnpjmae,
              vchavemae,
              vemissao,
              vcodigobarra,
              vTpDocumento,
              vnotavide,
              vserievide,
              vcnpjvide,
              vTpCliente,
              vTpCarga,
              vCFOP,
              vpeso,
              vvalormerc,
              vFinalizaDigitacao,
              vCriarColeta
      from Table(xmlsequence( Extract(xmltype.createXml(vParamsEntrada) , '/Parametros/Inputs/Input'))) Field;  
  Exception
    When Others Then
      pStatus := pkg_fifo.Status_Erro;
      pMessage := Substr('Erro ao extrair Dados do pParamsEntrada (xmlIn).' || chr(13) || Sqlerrm, 1, 1000);
      Return;
  End;
  
  if vTpDocumento is null Then
    vTpDocumento := '99';
  End If;  
  
  if vTpCliente is null Then
     vTpCliente := 'X';
  End If;   
  
  if vTpCarga is null Then
     vTpCarga := 'CA';
  End If;
  if vCFOP is null Then
    vCFOP := '3949';
  End If;     

    -- Procura se a Nota Mae tem chave nfe
   if length(trim(nvl(vchavemae,'Sem Chave'))) = 44 Then
      vCodBusca := trim(vchavemae);
      vTpBusca := '1'; -- Busca pela Chave
   Else
      select n.arm_nota_sequencia
        into vCodBusca
      from t_arm_nota n
      where n.arm_nota_numero = vnotamae
        and n.glb_cliente_cgccpfremetente = vcnpjmae
        and to_number(n.arm_nota_serie) = to_number(vseriemae)  ;   
      vTpBusca := '0'; -- Busca pela Sequencia

   End If;

    If vTpBusca = '0' Then
      --Verifico se a Nota pertence a Rota do Usuario.
      BEGIN 
         vRetorno := FNP_Valida_ArmazemNota( vCodBusca, vRota );  
      EXCEPTION
        WHEN OTHERS THEN 
          pStatus := 'E';
          pMessage := SQLERRM;
          RETURN;
      END;
      --Caso a solicitação não passe na Validação, mostro na tela a mensagem gerada pela função.
      If vRetorno.Status <> pkg_fifo.Status_Normal Then
        pStatus := vRetorno.Status;
        pMessage := vRetorno.Message;
        Return;
      Else
        --Rodo a Função que vai retornar um Objeto "tDadosNota" preenchido.
        vDadosNota := FNP_getDadosNotaSeq(vCodBusca);  
      End If;
    Elsif vTpBusca = '1' Then
       sp_getDadosNota_chaveNFE( vCodBusca, vDadosNotaColeta,pStatus, pMessage, vDadosNota );
    End If;



   vDadosNota.nota_tpDocumento      := vTpDocumento; 
   vDadosNota.carga_Tipo            := vTpCarga;
   vDadosNota.cfop_Codigo           := vCFOP;

   
   



   -- Apos recuperar os Dados da Nota
   -- Muda Os codigos para vide Nota
   vDadosNota.NotaStatus            := vDadosNota.NotaStatus;
   vDadosNota.criar_coleta          := vCriarColeta;
   vDadosNota.coleta_Codigo         := NULL;
   vDadosNota.coleta_Ciclo          := NULL;
   vDadosNota.coleta_Tipo           := NULL; 
   vDadosNota.coleta_ocor           := NULL;
   vDadosNota.finaliza_digitacao    := vFinalizaDigitacao;

   vDadosNota.rota_Codigo           := vRota;
   vDadosNota.armazem_Codigo        := vArmazem;
  
   -- Anota Pesquisa vira A nossa Vide Nota
   
   vDadosNota.nota_Vide             := '1';
   vDadosNota.vide_Sequencia        := vDadosNota.nota_Sequencia;
   vDadosNota.vide_Numero           := vDadosNota.nota_numero;
   vDadosNota.vide_Cnpj             := vDadosNota.Remetente_CNPJ;
   vDadosNota.vide_Serie            := vDadosNota.nota_serie;
   vDadosNota.nota_Sequencia        := null; 
   vDadosNota.nota_numero           := vnotavide;
   vDadosNota.nota_serie            := vserievide;
   vDadosNota.Remetente_CNPJ        := vcnpjvide;
   vDadosNota.Remetente_tpCliente   := vTpCliente;

   select cl.glb_cliente_razaosocial,
          ce.glb_localidade_codigo,
          ce.glb_cliend_codcliente,
          ce.glb_cliend_endereco,
          substr(l.glb_estado_codigo || '-' || l.glb_localidade_descricao,1,50)
      into vDadosNota.Remetente_RSocial,
           vDadosNota.Remetente_LocalCodigo,
           vDadosNota.Remetente_CodCliente,
           vDadosNota.Remetente_Endereco,
           vDadosNota.Remetente_LocalDesc 
   from t_glb_cliend ce,
        t_glb_cliente cl,
        t_glb_localidade l  
   where ce.glb_cliente_cgccpfcodigo = cl.glb_cliente_cgccpfcodigo
     and trim(ce.glb_cliente_cgccpfcodigo) = trim(vDadosNota.Remetente_CNPJ)
     and ce.glb_tpcliend_codigo = vDadosNota.Remetente_tpCliente
     and ce.glb_localidade_codigo = l.glb_localidade_codigo (+);

   select cl.glb_cliente_razaosocial,
          ce.glb_localidade_codigo,
          ce.glb_cliend_codcliente,
          ce.glb_cliend_endereco,
          substr(l.glb_estado_codigo || '-' || l.glb_localidade_descricao,1,50)
      into vDadosNota.Destino_RSocial,
           vDadosNota.Destino_LocalCodigo,
           vDadosNota.Destino_CodCliente,
           vDadosNota.Destino_Endereco,
           vDadosNota.Destino_LocalDesc 
   from t_glb_cliend ce,
        t_glb_cliente cl,
        t_glb_localidade l  
   where ce.glb_cliente_cgccpfcodigo = cl.glb_cliente_cgccpfcodigo
     and trim(ce.glb_cliente_cgccpfcodigo) = trim(vDadosNota.Destino_CNPJ)
     and ce.glb_tpcliend_codigo = vDadosNota.Destino_tpCliente
     and ce.glb_localidade_codigo = l.glb_localidade_codigo (+);

   

   vDadosNota.nota_dtEmissao        := vemissao;
   vDadosNota.nota_dtSaida          := vemissao;
   vDadosNota.nota_dtEntrada        := vemissao;
   vDadosNota.nota_chaveNFE         := vcodigobarra;
   vDadosNota.nota_pesoNota         := vpeso;
   vDadosNota.nota_pesoBalanca      := vpeso;
   vDadosNota.nota_altura           := 0;
   vDadosNota.nota_largura          := 0;
   vDadosNota.nota_comprimento      := 0;
   vDadosNota.nota_cubagem          := 0;
   vDadosNota.nota_qtdeVolume       := 1;
   vDadosNota.nota_ValorMerc        := vvalormerc;
   vDadosNota.embalagem_numero      := null;
   vDadosNota.embalagem_flag        := null;
   vDadosNota.embalagem_sequencia   := null;
   


  --Rodo a função que vai retornar um Arquivo XML recebendo como paramentro um objeto tDadosNota.
  vRetorno := FNP_Xml_getXml( 0, vDadosNota );


     vParamsCriaNota := '';    

     vParamsCriaNota := vParamsCriaNota || '<Parametros>';
     vParamsCriaNota := vParamsCriaNota || '<Inputs>';
     vParamsCriaNota := vParamsCriaNota || '<Input>';
     vParamsCriaNota := vParamsCriaNota || '<usuario>' || vUsuario || '</usuario>';
     vParamsCriaNota := vParamsCriaNota || '<aplicacao>'||vAplicacao||'</aplicacao>';
     vParamsCriaNota := vParamsCriaNota || '<rota>'||vRota||'</rota>';
     vParamsCriaNota := vParamsCriaNota || '<acao>' || vAcao || '</acao>';
     vParamsCriaNota := vParamsCriaNota || '<finaliza_coleta>'||vFinalizaDigitacao||'</finaliza_coleta>';
     vParamsCriaNota := vParamsCriaNota || '<criar_coleta>'||vCriarColeta||'</criar_coleta>';
     vParamsCriaNota := vParamsCriaNota || '<Tables>';
     vParamsCriaNota := vParamsCriaNota || '<Table name=#dadosNota#>';
     vParamsCriaNota := vParamsCriaNota || '<Rowset>';
     vParamsCriaNota := vParamsCriaNota || trim(vRetorno.Xml);
     vParamsCriaNota := vParamsCriaNota || '</Rowset>';
     vParamsCriaNota := vParamsCriaNota || '</Table>';
     vParamsCriaNota := vParamsCriaNota || '</Tables>';
     vParamsCriaNota := vParamsCriaNota || '</Input>';
     vParamsCriaNota := vParamsCriaNota || '</Inputs>';
     vParamsCriaNota := vParamsCriaNota || '</Parametros>';
     --Substitui os carecteres "CORINGAS"
     
     vParamsCriaNota := Replace(vParamsCriaNota, '<row num', '<Row num');
     vParamsCriaNota := Replace(vParamsCriaNota, '</row', '</Row');
     vParamsCriaNota := Replace(vParamsCriaNota, '#', '"');
     vParamsCriaNota := Replace(vParamsCriaNota, '§', '''');
       
     --sp_InsertNota(vParamsCriaNota,  
     -- Thiago -13/03/2020   
     sp_InsertNota(glbadm.pkg_glb_blob.f_CLOB2BLOB(vParamsCriaNota, vParamsCriaNotaB),
                   pStatus,
                   pMessage,
                   pParamsSaida);
  
  
    
  End sp_InsertNotaVide;
                   


-----------------------------------------------------------------------------------------------------------------
----PROCEDURE XML, UTILIZADA PARA RECUPERAR DADOS DE NOTAS FISCAIS.
-----------------------------------------------------------------------------------------------------------------
Procedure SP_RECEB_GETNOTAS( pParamsEntrada   In Varchar2,
                             pStatus          Out Char,
                             pMessage         Out Varchar2,
                             pParamsSaida     Out Clob) As

  --Variáveis utilizadas para recuperar os valores enviados via paramentros.
  vUsuario              tdvadm.t_usu_usuario.usu_usuario_codigo%Type;
  vAplicacao            tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type;
  vRota                 tdvadm.t_glb_rota.glb_rota_codigo%Type;
  vNota_Numero          Varchar2(09) := '';
  vRemetente_Cnpj       tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type;
  vEmbalagem_Codigo     Varchar(15) := '';
  vCarregamento_codigo  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type;
  vColeta_Codigo        tdvadm.t_arm_coleta.arm_coleta_ncompra%Type;
  vArmazem_codigo       tdvadm.t_arm_armazem.arm_armazem_codigo%Type;
  vDataInicial          Varchar2(10) := '';
  vDataFinal            Varchar2(10) := '';
  vAxo                  tdvadm.t_glb_cliend.glb_cliend_codcliente%Type;
  vPo                   tdvadm.t_arm_nota.xml_notalinha_numdoc%Type;
  
  --Variável de controle
  vCount Integer :=0;
  
  --Variável utilizada para montar o arquivo XML de saida
  vXmlSaida   Clob;
  

Begin

 Begin
   
   --Insert Into dropme d (a,x) values('NOTASS', pParamsEntrada); commit;
 
   --Recupera os valores passados como paramentros.
    Select 
       extractvalue(value(field), 'input/usuario'),
       extractvalue(value(field), 'input/aplicacao'),
       extractvalue(value(field), 'input/rota'),
       extractvalue(value(field), 'input/nota_numero'),
       extractvalue(value(field), 'input/rementente_cnpj'),
       extractvalue(value(field), 'input/embalagem_codigo'),
       extractValue(Value(Field), 'input/carregamento_codigo'),
       extractValue(Value(Field), 'input/coleta_codigo'),
       extractValue(Value(Field), 'input/armazem_codigo'),
       extractValue(Value(Field), 'input/dtInicial'),
       extractValue(Value(Field), 'input/dtFinal'),
       extractValue(Value(Field), 'input/Axo'),
       extractValue(Value(Field), 'input/Po')
     Into 
       vUsuario,
       vAplicacao,
       vRota,
       vNota_Numero,
       vRemetente_Cnpj,
       vEmbalagem_Codigo,
       vCarregamento_codigo,
       vColeta_Codigo,
       vArmazem_codigo,
       vDataInicial,
       vDataFinal,
       vAxo,
       vPo
     from 
       Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input'))) field;  
   
 Exception
   When Others Then
     pStatus := pkg_fifo.Status_Erro;
     pMessage := 'Erro ao recuperar os valores passados vias paramentros.';
     Return;
 End;
-- If (trim(lower(vUsuario)) = 'jsantos') Then
--   insert into dropme (a,l) values ('teste26/05',pParamsEntrada);
-- End If;
 
 --Após recuperar os valores, gera um cursor a partir dos paramentros,
 For vCursor In ( Select
                    arm_coleta_ncompra                                       coleta_codigo,
                    armnota.arm_armazem_codigo                               armazem_codigo,
                    arm_carregamento_codigo                                  carregamento,
                    armnota.transferir_para                                  armazem_transfdestino,
                    --rpad(substr(arm_embalagem_numero, 01, 06),6, ' ')        embalagem_numero ,
                    rpad(substr(arm_embalagem_numero, 01, 07),7, ' ')        embalagem_numero ,
                    trim(to_char(armnota.ARM_NOTA_NUMERO))                   nota_numero, 
                    to_char(arm_nota_dtinclusao, 'dd/mm/yyyy hh24:mi:ss')    nota_dtinclusao,
                    to_char(armnota.arm_nota_qtdvolume)                      nota_qtdevolume,
                    to_char(arm_nota_peso)                                   nota_pesonota,
                    Rpad(to_char(armnota.arm_nota_sequencia), 8, ' ')        nota_sequencia,
                    substr(trim(glb_cliente_cgccpfremetente),    01, 15)     remetente_cnpj,    
                    pkg_fifo_auxiliar.fn_removeAcentos(remetente)            rementente_rsocial,
       pkg_fifo_auxiliar.fn_removeAcentos( glb_tpcliend_codremetente )       remetente_tpendereco,
                    substr(origem, 01, 25)                                   remetente_locdesc,
                    substr(trim(glb_cliente_cgccpfdestinatario), 01, 15)     destino_cnpj ,
                    pkg_fifo_auxiliar.fn_removeAcentos( destinatario )       destino_rsocial,
                    pkg_fifo_auxiliar.fn_removeAcentos( glb_tpcliend_coddestinatario ) destino_tpendereco ,
                    pkg_fifo_auxiliar.fn_removeAcentos( substr(destino, 01, 25))                                  destino_locdesc,
                    pkg_fifo_auxiliar.fn_removeAcentos(alx)                  destino_codclientes,
                    substr(Trim(ctrc), 01, 10)                                     ctrc_codigo,
                    substr(Trim(rota), 01, 03)                                     ctrc_rota,
                    substr(Trim(serie), 01, 03)                                    ctrc_serie,
                    pkg_fifo_auxiliar.fn_removeAcentos(usuario )             usuario_tdv,
                    --arm_carregamento_codigo                                  carregamento,
                    armnota.Arm_Nota_Serie                                   arm_nota_serie,
                    
                    

                    chekin                                                   chekin
                  FROM 
                   tdvadm.V_NOTA_RECEBIMENTO armnota
                   
                   
                  WHERE
                    0=0
                    And armnota.ARM_ARMAZEM_CODIGO = vArmazem_codigo
                     --Data Inicial ( Data de Inclusão )
                    And Case
                      When nvl( Trim(vDataInicial), 'R') <> 'R' And trunc(armnota.arm_nota_dtinclusao) >= trunc( to_date(vDataInicial, 'DD/MM/YYYY') ) Then 1
                      When nvl( Trim(vDataInicial), 'R') = 'R'  And 0=0 Then 1
                    End = 1
                    
                    And Case
                      When nvl( Trim(vDataFinal), 'R') <> 'R' And trunc(armnota.arm_nota_dtinclusao) <= trunc( to_date(vDataFinal,   'DD/MM/YYYY') ) Then 1
                      When nvl( Trim(vDataFinal), 'R') = 'R'  And 0=0 Then 1
                    End = 1

                    --Numero da Nota  
                    And Case
                      When nvl( Trim(vNota_Numero),  'R') <> 'R' And armnota.arm_nota_numero = to_number( vNota_Numero)  Then 1
                      When nvl( Trim(vNota_Numero),  'R')  = 'R' And 0=0 Then 1  
                    End = 1
                    
                    
                    
                    --Pelo CNPJ do Remetente
                    And Case     
                      When nvl( Trim(vRemetente_Cnpj), 'R') <> 'R' And instr(armNota.Glb_Cliente_Cgccpfremetente, Trim(vRemetente_Cnpj)) > 0 Then 1
                      When nvl( Trim(vRemetente_Cnpj), 'R') = 'R' And 0=0 Then 1  
                    End = 1    
                        
                   
                    
                    And Case
                      When nvl( Trim(vEmbalagem_Codigo), 'R') <> 'R' And armNota.arm_embalagem_numero = vEmbalagem_Codigo Then 1
                      When nvl( Trim(vEmbalagem_Codigo), 'R') = 'R' And 0=0 Then 1
                    End = 1
                    
                    And Case
                      When nvl( Trim(vCarregamento_codigo), 'R') <> 'R' And armnota.ARM_CARREGAMENTO_CODIGO = vCarregamento_codigo Then 1
                      When nvl( Trim(vCarregamento_codigo), 'R')  = 'R' And 0=0 Then 1
                    End = 1    
                    
                    
                    
                    And Case
                      When nvl( Trim(vColeta_Codigo), 'R') <> 'R' And armNota.arm_coleta_ncompra = vColeta_Codigo Then 1
                      When nvl( Trim(vColeta_Codigo), 'R') = 'R'  And 0=0 Then 1
                    End = 1
                    
                    And Case
                     When nvl( Trim(vAxo), 'R') <> 'R' And instr(armNota.ALX, Trim(vAxo)) > 0 Then 1
                     When nvl( Trim(vAxo), 'R') = 'R' And 0=0 Then 1
                    End = 1
                     
                    And Case
                     When nvl( Trim(vPo), 'R') <> 'R' And Trim(armNota.PO) = vPo Then 1
                     When nvl( Trim(vPo), 'R') = 'R' And 0=0 Then 1
                    End = 1
                    
                    Order By armnota.ARM_NOTA_NUMERO

                   ) 
                   Loop
                     vcount := vCount +1;
                     vXmlSaida := vXmlSaida || '<row num="'              || to_char( vCount )                || '"> ';
                     vXmlSaida := vXmlSaida || '<Coleta_Codigo>'         || vCursor.Coleta_Codigo          || '</Coleta_Codigo>'         ;
                     vXmlSaida := vXmlSaida || '<armazem_codigo>'        || vCursor.armazem_codigo         || '</armazem_codigo>'        ;
                     vXmlSaida := vXmlSaida || '<carregamento>'          || vCursor.carregamento           || '</carregamento>'          ;
                     vXmlSaida := vXmlSaida || '<armazem_transfdestino>' || vCursor.armazem_transfdestino  || '</armazem_transfdestino>' ;
                     vXmlSaida := vXmlSaida || '<embalagem_numero>'      || vCursor.embalagem_numero       || '</embalagem_numero>'      ;
                     vXmlSaida := vXmlSaida || '<nota_numero>'           || vCursor.nota_numero            || '</nota_numero>'           ;
                     vXmlSaida := vXmlSaida || '<nota_dtinclusao>'       || vCursor.nota_dtinclusao        || '</nota_dtinclusao>'       ;
                     vXmlSaida := vXmlSaida || '<nota_qtdevolume>'       || vCursor.nota_qtdevolume        || '</nota_qtdevolume>'       ;
                     vXmlSaida := vXmlSaida || '<nota_pesonota>'         || vCursor.nota_pesonota          || '</nota_pesonota>'         ;
                     vXmlSaida := vXmlSaida || '<nota_sequencia>'        || vCursor.Nota_Sequencia         || '</nota_sequencia>'        ;
                     vXmlSaida := vXmlSaida || '<remetente_cnpj>'        || vCursor.remetente_cnpj         || '</remetente_cnpj>'        ;
                     vXmlSaida := vXmlSaida || '<rementente_rsocial>'    || vCursor.rementente_rsocial     || '</rementente_rsocial>'    ;
                     vXmlSaida := vXmlSaida || '<remetente_tpendereco>'  || vCursor.remetente_tpendereco   || '</remetente_tpendereco>'  ;
                     vXmlSaida := vXmlSaida || '<remetente_locdesc>'     || vCursor.remetente_locdesc      || '</remetente_locdesc>'     ;
                     vXmlSaida := vXmlSaida || '<destino_cnpj>'          || vCursor.destino_cnpj           || '</destino_cnpj>'          ;
                     vXmlSaida := vXmlSaida || '<destino_rsocial>'       || vCursor.destino_rsocial        || '</destino_rsocial>'       ;
                     vXmlSaida := vXmlSaida || '<destino_tpendereco>'    || vCursor.destino_tpendereco     || '</destino_tpendereco>'    ;
                     vXmlSaida := vXmlSaida || '<destino_locdesc>'       || vCursor.destino_locdesc        || '</destino_locdesc>'       ;
                     vXmlSaida := vXmlSaida || '<destino_codclientes>'   || vCursor.destino_codclientes    || '</destino_codclientes>'   ;
                     vXmlSaida := vXmlSaida || '<ctrc_codigo>'           || vCursor.ctrc_codigo            || '</ctrc_codigo>'           ;
                     vXmlSaida := vXmlSaida || '<ctrc_rota>'             || vCursor.ctrc_rota              || '</ctrc_rota>'             ;
                     vXmlSaida := vXmlSaida || '<ctrc_serie>'            || vCursor.ctrc_serie             || '</ctrc_serie>'            ;
                     vXmlSaida := vXmlSaida || '<usuario_tdv>'           || vCursor.usuario_tdv            || '</usuario_tdv>'           ;
                     --vXmlSaida := vXmlSaida || '<carregamento>'          || vCursor.carregamento           || '</carregamento>'          ;
                     vXmlSaida := vXmlSaida || '<arm_nota_serie>'        || vCursor.Arm_Nota_Serie         || '</arm_nota_serie>'          ;                     
                     vXmlSaida := vXmlSaida || '<Chekin>'                || vCursor.Chekin                 || '</Chekin>'                ;
                     vXmlSaida := vXmlSaida || '</row>';
  End Loop;

  --Caso o cursor tenha vindo em branco, gera um arquivo XML em branco.
  If vCount = 0 Then
     vXmlSaida := vXmlSaida || '<row num="0">' ;
     vXmlSaida := vXmlSaida || '<Coleta_Codigo />'         ;
     vXmlSaida := vXmlSaida || '<armazem_codigo />'        ;
     vXmlSaida := vXmlSaida || '<armazem_transfdestino />' ;
     vXmlSaida := vXmlSaida || '<embalagem_numero />'      ;
     vXmlSaida := vXmlSaida || '<nota_numero />'           ;
     vXmlSaida := vXmlSaida || '<nota_dtinclusao />'       ;
     vXmlSaida := vXmlSaida || '<nota_qtdevolume />'       ;
     vXmlSaida := vXmlSaida || '<nota_pesonota />'         ;
     vXmlSaida := vXmlSaida || '<nota_sequencia />'        ;
     vXmlSaida := vXmlSaida || '<remetente_cnpj />'        ;
     vXmlSaida := vXmlSaida || '<rementente_rsocial />'    ;
     vXmlSaida := vXmlSaida || '<remetente_tpendereco />'  ;
     vXmlSaida := vXmlSaida || '<remetente_locdesc />'     ;
     vXmlSaida := vXmlSaida || '<destino_cnpj />'          ;
     vXmlSaida := vXmlSaida || '<destino_rsocial />'       ;
     vXmlSaida := vXmlSaida || '<destino_tpendereco />'    ;
     vXmlSaida := vXmlSaida || '<destino_locdesc />'       ;
     vXmlSaida := vXmlSaida || '<destino_codclientes />'   ;
     vXmlSaida := vXmlSaida || '<ctrc_codigo />'           ;
     vXmlSaida := vXmlSaida || '<ctrc_rota />'             ;
     vXmlSaida := vXmlSaida || '<ctrc_serie />'            ;
     vXmlSaida := vXmlSaida || '<usuario_tdv />'           ;
     vXmlSaida := vXmlSaida || '<carregamento />'          ;
     vXmlSaida := vXmlSaida || '<Chekin />'                ;
     vXmlSaida := vXmlSaida || '<arm_nota_serie />'        ;     

      vXmlSaida := vXmlSaida || '</row>';    
    End If;
    
    
   pParamsSaida := pParamsSaida || '<Parametros><Output><Tables>';
   pParamsSaida := pParamsSaida || '<Table name="gridPrincipal"><ROWSET>'   || Trim(vXmlSaida) || '</ROWSET></Table>';
   pParamsSaida := pParamsSaida || '</Tables></Output></Parametros>'; 
 
    
    pStatus := pkg_fifo.Status_Normal;
    pMessage := '';
  
                       
 
 

End SP_RECEB_GETNOTAS;   

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar dados de transportadora.                                                                        --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_Get_DadosCliente( pXmlIn in varchar2, 
                               pStatus out char,
                               pMessage out varchar2,
                               pXmlOut out clob
                             ) as                                  
 --Variável utilizada para recuperar paramentros enviados via xml                            
 vParamsXml glbadm.pkg_listas.tListaParamsString;
 
 -- Variável string, utilizada para recuperar mensagens.
 vMessage Varchar2(20000);
 
 --Tipo utilizado para recuperar dados da consulta.
 vListaDados pkg_fifo.tListaDadosCliente;
 
 --Variável Inteira, utilizada para definir linha 
 vLinha Integer;
 
 --Variável utilizada para receber o XML com os dados do Cliente.
 vXmlDadosCliente Varchar2(32000);
 

Begin
  --inicializa as variáveis
  vLinha := 0;  
  vXmlDadosCliente := '';

  Begin
    --executo a função que será responsável por recuperar os paramentros enviados por xml.
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue( pXmlIn, vParamsXml, vMessage) ) Then
      --Caso ocorra algum erro na recuperação, lanço a exceção
      Raise vEx_ParamsIniciais;
    End If;
    
    --abro o cursor, para transferir os dados para a lista.
    For vCursor In (Select 
                      cli.glb_cliente_cgccpfcodigo, 
                      cli.glb_cliente_razaosocial,
                      endcli.glb_tpcliend_codigo,
                      endcli.glb_cliend_codcliente,
                      endcli.glb_cliend_cidade,
                      endcli.glb_estado_codigo,
                      endcli.glb_localidade_codigo,
                      endcli.glb_localidade_codigoie,
                      loc.glb_localidade_descricao
                    From
                      tdvadm.t_glb_cliente cli,
                      tdvadm.t_glb_cliend Endcli,
                      tdvadm.t_glb_localidade loc
                    Where
                      cli.glb_cliente_cgccpfcodigo = endcli.glb_cliente_cgccpfcodigo
                      And endcli.glb_localidade_codigo = loc.glb_localidade_codigo
                      And Trim(cli.glb_cliente_cgccpfcodigo) = Trim(vParamsXml('glb_cliente_cgccpfcodigo').value)
                   )
    Loop
      --incremento a variável de linha
      vLinha := vLinha +1;
      
      --popula a variável de lista, com os dados da linha
      vListaDados(vLinha).Glb_Cliente_Cgccpfcodigo := vCursor.Glb_Cliente_Cgccpfcodigo;
      vListaDados(vLinha).Glb_Cliente_Razaosocial  := vCursor.Glb_Cliente_Razaosocial;
      vListaDados(vLinha).Glb_Tpcliend_Codigo      := vCursor.Glb_Tpcliend_Codigo;
      vListaDados(vLinha).Glb_Cliend_Codcliente    := vCursor.Glb_Cliend_Codcliente;
      vListaDados(vLinha).Glb_Cliend_Cidade        := vCursor.Glb_Cliend_Cidade;
      vListaDados(vLinha).Glb_Estado_Codigo        := vCursor.Glb_Estado_Codigo;
      vListaDados(vLinha).Glb_Localidade_Codigo    := vCursor.Glb_Localidade_Codigo;
      vListaDados(vLinha).Glb_Localidade_Codigoie  := vCursor.Glb_Localidade_Codigoie;
      vListaDados(vLinha).Glb_Localidade_Descricao := vCursor.Glb_Localidade_Descricao;
    End Loop;           
    
    If ( vLinha = 0 ) Then
      pMessage := 'Cliente não encontrado para o CNPJ: '|| Trim(vParamsXml('glb_cliente_cgccpfcodigo').value) ||'.' || chr(10) ||
                  'Consulte o cadastro de clientes.';
      pStatus := pkg_glb_common.Status_Erro;
      Return;  
    End If;           
    
    --Gero o Xml com dados da transportadora partir da lista populada.
    If ( Not pkg_fifo_xml.FN_Xml_DadosCliente(vListaDados, 'dadostransp', vXmlDadosCliente, vMessage) ) Then
      --caso ocorra algum erro, lanço a exceção.
      Raise vEx_ExecFunction;
    End If;
    
    --Monto Xml de retorno.
    pXmlOut:= '<parametros><output>';
    pXmlOut:= pXmlOut || '<status>N</status>';
    pXmlOut:= pXmlOut || '<message></message>';
    pXmlOut:= pXmlOut || '<tables>';
    pXmlOut:= pXmlOut || Trim(vXmlDadosCliente);
    pXmlOut:= pXmlOut || '</tables></output></parametros>';
    
    --Seto os parametros de saida
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage := '';
    
  Exception
    --erro ao recuperar paramentros iniciais.
    When vEx_ParamsIniciais Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;
    
    --Erro de execução de função
    When vEx_ExecFunction Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;  

    --Erro não previsto
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao buscar dados da transportadora.' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_recebimento.sp_get_dadostransp();' || chr(10) ||
                  'Erro Ora: ' || Sqlerrm;
  End;
  
End SP_Get_DadosCliente;   



----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar descrição de mercadoria                                                                         --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_Get_Mercadoria( pXmlIn In Varchar2,
                             pStatus Out Char,
                             pMessage Out Varchar2,
                             pXmlOut Out Varchar2
                           ) Is 
 --Variável de controle
 vControl Integer;
 
 --Variável utilizada para recuperar oa paramentros passados por XML.
 vListaParams glbadm.pkg_listas.tListaParamsString;
 
 --variável utilizada para recuperar Mensagens 
 vMessage Varchar2(20000);
 
 --Variável utilizada para recuperar descrição das mercadorias.
 vGlb_mercadoria_descricao tdvadm.t_glb_mercadoria.glb_mercadoria_descricao%Type;
 
Begin
  --inicializa as variaveis
  vMessage := '';
  
  Begin
    --recupero os paramentros passados por xml
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue( pXmlIn, vListaParams, vMessage) ) Then
      --caso ocorra algum erro, lança a exceção
      Raise vEx_ParamsIniciais;
    End If;
    
    Begin

      Select merc.glb_mercadoria_descricao 
      Into vGlb_mercadoria_descricao
      From tdvadm.t_glb_mercadoria merc
      Where merc.glb_mercadoria_codigo = vListaParams('glb_mercadoria_codigo').value;

    Exception
      When no_data_found Then
        pMessage := 'Codigo de mercadoria : ' || vListaParams('glb_mercadoria_codigo').value || ' nao encontrado.';
        pStatus := pkg_glb_common.Status_Erro;
        Return;
    End; 

    --Monto Xml de retorno.
    pXmlOut := '<parametros>             ' ||  
               '  <output>               ' ||
               '    <status>N</status>   ' ||
               '    <message></message>  ' ||
               '    <glb_mercadoria_descricao>' || vGlb_mercadoria_descricao || '</glb_mercadoria_descricao> ' ||
               '  </output>              ' || 
               '</parametros>';

    --Seto os parametros de saida
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage := '';
    
  Exception
    --erro ao recuperar paramentros iniciais
    When vEx_ParamsIniciais Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;
      
    --Erro não esperado
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao recuperar descricao de mercadoria' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_recebimento_sp_get_mercadoria(); ' || chr(10)||
                  'Erro ora: ' || Sqlerrm;
      Return;             
  End;
  
End SP_Get_Mercadoria; 

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar descrição de localidade                                                                         --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_Get_Localidade( pXmlIn In Varchar2,
                             pStatus Out Char,
                             pMessage Out Varchar2,
                             pXmlOut Out Clob
                           ) Is
 --Variável utilizada para recuperar lista de paramentros passados via xml
 vListaParams glbadm.pkg_listas.tListaParamsString;
 
 --variável utilizada para recuperar mensagens
 vMessage Varchar2(20000);                           
 
 --Variável utilizada para recuperar descrição da localização.
 vGlb_localidade_descricao tdvadm.t_glb_localidade.glb_localidade_descricao%Type;
Begin
  Begin
    
    -- Recupero os paramentros passados por xml
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue( pXmlIn, vListaParams, vMessage ) ) Then
      Raise vEx_ParamsIniciais;
    End If;
    
    Begin
      --busco a descrição da localidade passada por paramentro
      Select loc.glb_localidade_descricao 
      Into vGlb_localidade_descricao
      From tdvadm.t_glb_localidade loc
      Where loc.glb_localidade_codigo = vListaParams('glb_localidade_codigo').value;
    Exception
      --caso não encontre a localidade.
      When no_data_found Then
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := 'Localidade nao localizada';
        Return;
    End;
    
    --Monto Xml de retorno.
    pXmlOut := '<parametros>             ' ||  
               '  <output>               ' ||
               '    <status>N</status>   ' ||
               '    <message></message>  ' ||
               '    <glb_localidade_codigo>' || vGlb_localidade_descricao || '</glb_localidade_codigo> ' ||
               '  </output>              ' || 
               '</parametros>';

    --Seto os parametros de saida
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage := '';
    
    
    
    
  Exception
    --ero ao recuperar paramentros iniciais.
    When vEx_ParamsIniciais Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;
    
    --caso ocorra algum erro não previsto
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage:= 'Erro ao recuperar descrição da localidade' || chr(10) ||
                 'Rotina: tdvadm.pkg_fifo_recebimento.sp_get_localidade(); ' || chr(10) ||
                 'Erro ora: ' || Sqlerrm;
      Return;            
      
  End;
  
End SP_Get_Localidade;                             
 

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizad apara recuperar descrição de CFOP                                                                               --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_Get_Cfop( pXmlIn In Varchar2,
                       pStatus Out Char,
                       pMessage Out Varchar2,
                       pXmlOut Out Clob 
                     ) Is
 --Variável utilizada para recuperar os paramentros passados via XML
 vListaParams glbadm.pkg_listas.tListaParamsString;
 
 --variável utilizad apara recuperar mensagens
 vMessage Varchar2(20000);
 
 --variável utilizada para recuperar a descrição do CFOP
 vGlb_cfop_descricao tdvadm.t_glb_cfop.glb_cfop_descricao%Type;
Begin
  --inicializa as variáveis dessa procedure
  vMessage := '';
  
  Begin
     --recupero paramentros passados por XML
     If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue(pXmlIn, vListaParams, vMessage ) ) Then
       --caso ocorra algum erro, lanço exceção
       Raise vEx_ParamsIniciais;
     End If;
     
     Begin
       --busco a descrição do CFOP passado.
       Select cfop.glb_cfop_descricao 
       Into vGlb_cfop_descricao
       From tdvadm.t_glb_cfop cfop
       Where cfop.glb_cfop_codigo = vListaParams('glb_cfop_codigo').value;
     Exception
       When no_data_found Then
         pMessage := 'Cfop: ' || vListaParams('glb_cfop_codigo').value || ' nao localizado.';
         pStatus := pkg_glb_common.Status_Erro;
         Return;  
     End;

    --Monto Xml de retorno.
    pXmlOut := '<parametros>             ' ||  
               '  <output>               ' ||
               '    <status>N</status>   ' ||
               '    <message></message>  ' ||
               '    <glb_cfop_descricao>'  || vGlb_cfop_descricao || '</glb_cfop_descricao> ' ||
               '  </output>              ' || 
               '</parametros>';

    --Seto os parametros de saida
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage := '';
       
  Exception
    --Erro na recuperação dos paramentros XML
    When vEx_ParamsIniciais Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;
      
    --caso ocorra algum erro não previsto
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao recuperar dados do CFOP codigo: ' || vListaParams('glb_cfop_codigo').value || Chr(10) ||
                  'Rotian: tdvadm.pkg_fifo_recebimento.sp_get_cfop(); ' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return;                   
  End;
End SP_Get_Cfop;

----------------------------------------------------------------------------------------------------------------------------------------                       
-- Procedure utilizada para recuperar o Saque de uma Tabela ou solicitação a partir de seu numero                                     --
----------------------------------------------------------------------------------------------------------------------------------------
procedure SP_Get_SaqueTabSol( pXmlIn In Varchar2,
                              pStatus Out Char,
                              pMessage Out Varchar2,
                              pXmlOut Out Varchar2
                            ) Is

 --Variavel utilizada para recuperar lista de paramentros passados por Xml
 vListaParams glbadm.pkg_listas.tListaParamsString;
 
 --Variável utilizada para montar mensagens.
 vMessage Varchar2(10000);
                             
 --Variável utilizada para recuperar o saque da tabela/solicitação
 vSaque Char(04);
                           
Begin
  vMessage := '';
  vSaque := '';
  
  Begin
    --Recupero os paramentros que foram passados por Xml
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue( pXmlIn, vListaParams, vMessage) ) Then
      Raise vEx_ParamsIniciais;
    End If; 
    
    --Caso a busca seja por uma tabela
    If ( vListaParams('arm_nota_tabsol').value = 'T' ) Then
      select max(ta1.slf_tabela_saque) into vSaque
       from tdvadm.t_slf_tabela ta1                                          
       where ta1.slf_tabela_codigo = vListaParams('arm_nota_tabsolcod').value
         and ta1.slf_tabela_vigencia = (SELECT MAX(ta2.slf_tabela_vigencia)
                                        FROM t_slf_tabela ta2
                                        WHERE  ta2.slf_tabela_vigencia <= trunc(sysdate)
                                        And ta2.slf_tabela_codigo = ta1.slf_tabela_codigo);
    End If;
    
    --Caso a busca seja por uma solicitação
    If ( vListaParams('arm_nota_tabsol').value = 'S' ) Then
      select max(sf1.slf_solfrete_saque) into vSaque                               
      from tdvadm.t_slf_solfrete sf1                                        
      where sf1.slf_solfrete_codigo = vListaParams('arm_nota_tabsolcod').value
        and sf1.slf_solfrete_dataefetiva >= trunc(sysdate)
        AND sf1.slf_solfrete_vigencia <= trunc(SYSDATE);
    End If;
    
    --Monto Xml de retorno.
    pXmlOut := '<parametros>           ' ||  
               '  <output>             ' ||
               '    <status>N</status> ' ||
               '    <message></message>' ||
               '    <arm_nota_tabsolsq>' || vSaque || '</arm_nota_tabsolsq>' ||
               '  </output>            ' || 
               '</parametros>';

    --Seto os parametros de saida
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage := '';
  
  Exception
    --erro ao recuperar paramentros iniciais.
    When vEx_ParamsIniciais Then
      pMessage := vMessage;
      pStatus :=  pkg_glb_common.Status_Erro;
      Return;
      
    --erro não esperado
    When Others Then
      pMessage := 'Erro ao buscar saque da Tabela ou Solicitacao' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_recebimento.sp_get_saquetabsol(); ' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      pStatus :=  pkg_glb_common.Status_Erro;
      Return;
  End;
  
End sp_get_SaqueTabSol;

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para definir os tipos de documentos possíveis de busca                                                         --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_GetTpDocBusca( pXmlIn In Varchar2,
                            pStatus Out Char,
                            pMessage Out Varchar2,
                            pXmlOut Out Varchar2
                          ) As
 --Variável utilizada para gerar tabela de retorno
 vTabTpDoc Varchar2(1000);                           
Begin
  vTabTpDoc := '<table name="tpDocumentos">                                    ' || 
               '  <rowset>                                                     ' || 
               '    <row num="1"> <id>col</id>  <chave>Coleta</chave></row>' ||
               '    <row num="2"> <id>cnf</id>  <chave>Chave NFE</chave></row>' ||
               '  </rowset>                                                    ' ||
               '</table>';
  
  pXmlOut:= '';
  pXmlOut:= pXmlOut ||'<parametros><output>';
  pXmlOut:= pXmlOut || '<status>N</status>';
  pXmlOut:= pXmlOut || '<message></message>';
  pXmlOut:= pXmlOut || '<tables>';
  pXmlOut:= pXmlOut || Trim(vTabTpDoc);
  pXmlOut:= pXmlOut || '</tables></output></parametros>';
  
  pStatus := pkg_glb_common.Status_Nomal;
  pMessage := '';
    
End sp_getTpDocBusca;      

----------------------------------------------------------------------------------------------------------------------------------------
-- Função interna utilizada para recuperar os dados iniciais para lançamento de nota, a partir de uma coleta.                         -- 
----------------------------------------------------------------------------------------------------------------------------------------
Function FNP_Get_DadosInicColeta( pArm_coleta_ncompra In tdvadm.t_arm_coleta.arm_coleta_ncompra%Type,
                                  pArm_armazem_codigo In tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                  pMessage Out Varchar2,
                                  pXmlOut Out Clob
                                 ) Return Boolean Is
 --Variável de controle.
 vControl Integer;
 
 --Variável utilizada para recuperar o ciclo da coleta
 vArm_coleta_ciclo tdvadm.t_arm_coleta.arm_coleta_ciclo%Type;
 
 --Variável utilizada para recuperar o armazem da coleta.
 vArm_armazem_codigo tdvadm.t_arm_armazem.arm_armazem_codigo%Type;
 
 --Variável do tipo de Dados Iniciais de nota
 vDadosLancNota pkg_fifo.tDadosLancNota;
 
 --Variável utilizada para recuperar o XML com os dados da coleta.
 vXmlDadosCol Varchar2(32000);
 
 --Variável utilizada para recuperar mensagens.
 vMessage Varchar2(1000);
 
Begin
  Begin
    Begin
      --vrifico se a coleta existe.
      Select Count(*),
             col.arm_coleta_ciclo,
             col.arm_armazem_codigo 
      Into vControl,
           vArm_coleta_ciclo,
           vArm_armazem_codigo       
      From t_arm_coleta col
      Where col.arm_coleta_ncompra = pArm_coleta_ncompra 
      And col.arm_coleta_ciclo = ( Select Max(sCol.Arm_Coleta_Ciclo) From t_arm_coleta sCol
                                   Where col.arm_coleta_ncompra =  sCol.Arm_Coleta_Ncompra  )
      Group By col.arm_coleta_ciclo,
               col.arm_armazem_codigo;
    Exception
      --caso não encontre a coleta
      When no_data_found Then
        vControl := 0;
    End;    
             
    --Caso não tenha encontrado a coleta de referência
    If ( vControl = 0 ) Then
      pMessage := 'Coleta número ' || pArm_coleta_ncompra || ' nao encontrada';
      Return False; 
    End If;
    
    --Caso o armazem da coleta, não seja o armazem da rota.
    If ( pArm_armazem_codigo != vArm_armazem_codigo ) Then
      pMessage := 'Armazem da Coleta numero: ' || vArm_coleta_ciclo || '.' || pArm_coleta_ncompra || ' pertence ao armazem ' || vArm_armazem_codigo;
      Return False;
    End If;
    
    Select
      col.arm_coleta_ncompra,
      col.arm_coleta_ciclo,
      col.glb_cliente_cgccpfcodigocoleta,
      col.glb_tpcliend_codigocoleta,
      col.glb_cliente_cgccpfcodigoentreg,
      col.glb_tpcliend_codigocoleta
    Into 
      vDadosLancNota
    From
      tdvadm.t_arm_coleta col
    Where
      col.arm_coleta_ncompra = pArm_coleta_ncompra 
      And col.arm_coleta_ciclo = vArm_coleta_ciclo;
      
    --Monta Xml a partir do tipo preenchido com os dados da coleta.
    If ( Not pkg_fifo_xml.FN_Xml_DadosLancNota(vDadosLancNota, 'DadosIniciais', vMessage, vXmlDadosCol) ) Then
      pMessage := vMessage;
      Return False;
    End If;  
    

    pXmlOut:= '';
    pXmlOut:= pXmlOut ||'<parametros><output>';
    pXmlOut:= pXmlOut || '<status>N</status>';
    pXmlOut:= pXmlOut || '<message></message>';
    pXmlOut:= pXmlOut || '<tables>';
    pXmlOut:= pXmlOut || Trim(vXmlDadosCol);
    pXmlOut:= pXmlOut || '</tables></output></parametros>';
    pMessage := '';
    Return True;
    
      
      
    
  Exception
    --Erro não esperado.
    When Others Then
      pMessage := 'Erro ao recuperar dados através da coleta nº: ' || pArm_coleta_ncompra || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_recebimento.FNI_Get_DadosInicColeta(); ' || chr(10) ||
                  'Erro Ora: ' || Sqlerrm;
      Return False;              
  End;
  
End FNP_Get_DadosInicColeta;                                   
                                  

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar dados iniciais para lançamento de nota.                                                         --    
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_Get_DadosInicLanc( pXmlIn In Varchar2,
                                pStatus Out Char,
                                pMessage Out Varchar2,
                                pXmlOut Out Clob
                              ) Is
 --Variável utilizada para recuperar paramentros passados no XML
 vListaParams glbadm.pkg_listas.tListaParamsString;                                
 
 --Variável utilizada para recuperar mensagens.
 vMessage Varchar2(20000);
Begin
  Begin
    --recupero os paramentros passados via xml
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue(pXmlIn, vListaParams, vMessage) ) Then
      --caso ocorra algum erro, lanço a exceção.
      Raise vEx_ParamsIniciais;
    End If;
    
    If ( vListaParams('tpDocumento').value = 'col' ) Then
      If ( Not FNP_Get_DadosInicColeta( vListaParams('codigo_busca').value,
                                        vListaParams('arm_armazem_codigo').value,
                                        vMessage,
                                        pXmlOut
                                       ) ) Then
        Raise vEx_ExecFunction;                                       
      End If;                                 
    End If;
    
    
    pMessage:= '';
    pStatus:= 'N';
    
  Exception
    When vEx_ExecFunction Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;
      
    --Erro ao recuperar paramentros iniciais.
    When vEx_ParamsIniciais Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage:= vMessage;
      Return;
      
    --caso ocorra algum erro não esperado
    When Others Then
      pStatus:= pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao buscar dados iniciais.' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_recebimento.sp_solicautnotas(); ' || chr(10) ||
                  'Erro Ora: ' || Sqlerrm;
      Return;              
  End;
  
End SP_Get_DadosInicLanc;


----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar serviços adicionais cadastrados.                                                                --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure sp_get_servicosadd( pXmlIn In Varchar2,
                              pStatus Out Char,
                              pMessage Out Varchar2,
                              pXmlOut Out Clob
                            ) Is 
 -- Variável que será responsável para gerar xml de retorno
 vXmlRetorno Varchar2(20000);                            
 
 --Variável de controle de linha
 vLinha Integer;
Begin
  vXmlRetorno := '';
  vLinha := 0;
  
  Begin
    For vCursor In ( Select 
                       sa.arm_notaservadd_codigo,
                       sa.arm_notaservadd_descricao
                     from t_arm_notaservadd sa
                     Where 0 = 0
--                       and sa.arm_notaservadd_codigo = '01'
                     Order By sa.arm_notaservadd_descricao
                    ) 
    Loop
      --Incremento a variável de linha
      vLinha := vLinha +1;
      
      --Gero linha de um xml
      vXmlRetorno := vXmlRetorno || '<row num="' || Trim(to_char(vLinha)) || '" > '||
                                 glbadm.pkg_xml_common.FN_Xml_GetField('arm_notaservadd_codigo',    vCursor.Arm_Notaservadd_Codigo,    glbadm.pkg_xml_common.Field_Char) ||
                                 glbadm.pkg_xml_common.FN_Xml_GetField('arm_notaservadd_descricao', vCursor.Arm_Notaservadd_Descricao, glbadm.pkg_xml_common.Field_Varchar2) ||                                 
                                 '</row>';
    End Loop;   
    
    vXmlRetorno := '<table name="servadicionais"><rowset>' || vXmlRetorno || '</rowset></table>';                  
    
    pXmlOut:= '';
    pXmlOut:= pXmlOut ||'<parametros><output>';
    pXmlOut:= pXmlOut || '<status>N</status>';
    pXmlOut:= pXmlOut || '<message></message>';
    pXmlOut:= pXmlOut || '<servprincipal>01</servprincipal>';
    pXmlOut:= pXmlOut || '<tables>';
    pXmlOut:= pXmlOut || Trim(vXmlRetorno);
    pXmlOut:= pXmlOut || '</tables></output></parametros>';
    pMessage := '';
    pStatus:= pkg_glb_common.Status_Nomal;
    
      
          

    
  Exception
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao recuperar serviços adicionais.' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_recebimento.sp_get_servicosadd(); ' || chr(10) ||
                  'Erro Ora: ' || Sqlerrm; 
  End;
  
End;                              
                                                   

----------------------------------------------------------------------------------------------------------------------------------------
-- Função utilizada para receber solicitações para Notas Fiscais 
----------------------------------------------------------------------------------------------------------------------------------------
procedure SP_SolicAutNotas( pXmlIn in varchar2, 
                            pStatus out char,
                            pMessage out varchar2,
                            pXmlOut out clob
                          ) As
                        
Begin
  
  
  pStatus := pkg_glb_common.Status_Erro;
  pMessage := 'procedure em desenvolvimento';
    
  
End SP_SolicAutNotas;        

----------------------------------------------------------------------------------------------------------------------------------------
-- Procedure criara para o HELPDESK excluir notas fiscais Recebimento.                                                                --
----------------------------------------------------------------------------------------------------------------------------------------
Procedure SP_HD_Del_NotaFiscal( pArm_nota_numero In tdvadm.t_arm_nota.arm_nota_numero%Type,
                                pGlb_cliente_cgccpfremetente In tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%Type,
                                pArm_nota_serie In tdvadm.t_arm_nota.arm_nota_serie%Type,
                                pStatus Out Char,
                                pMessage Out Varchar2,
                                pSequencia In Integer) As
Begin
  If ( Not FNP_Del_NotaFiscal( pArm_nota_numero, pGlb_cliente_cgccpfremetente, pArm_nota_serie, 'S', pMessage, pSequencia ) ) Then
    pStatus := pkg_glb_common.Status_Erro;
  Else
    pStatus := pkg_glb_common.Status_Nomal;
  End If;
  
End SP_HD_Del_NotaFiscal;    

  
PROCEDURE Sp_Get_NotaPorChave(P_CHAVENFE IN  t_edi_nf.edi_nf_chavenfe%TYPE,
                              P_Nota     OUT t_Edi_Nf%RowType,
                              P_STATUS   OUT CHAR,
                              P_MESSAGE  OUT VARCHAR2) AS
V_EXISTE INTEGER;                              
Begin
    BEGIN
      
          select COUNT(*)
            INTO V_EXISTE
            from t_edi_nf l
            where l.edi_nf_chavenfe = P_CHAVENFE;
           
           IF V_EXISTE = 0 THEN
      
              select COUNT(*)
                  INTO V_EXISTE
                  from t_edi_nf l
                  where trim(l.edi_nf_numero) = substr(P_CHAVENFE, 26, 9)
                    and trim(l.edi_nf_serie)  = substr(P_CHAVENFE, 23, 3)
                    and trim(l.edi_emb_cnpj)  = substr(P_CHAVENFE, 7, 14);
                    
              if V_EXISTE = 0 then             
                  P_STATUS  := 'E';
                  P_MESSAGE := 'XML DA NOTA NÃO DISPONÍVEL, ENTRE SOMENTE COM O NÚMERO DA COLETA.';
                  RETURN;                
              else            
                    select l.edi_emb_cnpj remetente,
                           l.edi_dest_cnpj,
                           l.edi_nf_serie,
                           l.edi_nf_numero,
                           l.edi_nf_emissao emissao,
                           l.edi_nf_chavenfe chavenfe,
                           l.edi_nf_mercadoria,
                           l.edi_nf_volumes,
                           l.edi_nf_valor,
                           l.edi_nf_pesototal peso_nota,
                           l.edi_nf_cfop cfop,
                           l.edi_nf_numerosap,
                           l.arm_coleta_ncompra,
                           l.arm_coleta_ciclo,
                           l.edi_nf_pesocubado
                      into P_Nota.Edi_Emb_Cnpj,
                           P_Nota.Edi_Dest_Cnpj,
                           P_Nota.Edi_Nf_Serie,
                           P_Nota.Edi_Nf_Numero,
                           P_Nota.Edi_Nf_Emissao,
                           P_Nota.Edi_Nf_Chavenfe,
                           P_Nota.Edi_Nf_Mercadoria,
                           P_Nota.Edi_Nf_Volumes,
                           P_Nota.Edi_Nf_Valor,
                           P_Nota.Edi_Nf_Pesototal,
                           P_Nota.Edi_Nf_Cfop,
                           P_Nota.Edi_Nf_Numerosap,
                           P_Nota.Arm_Coleta_Ncompra,
                           P_Nota.Arm_Coleta_Ciclo,
                           P_Nota.edi_nf_pesocubado                           
                      from t_edi_nf l
                      where 0=0
                        and trim(l.edi_nf_numero) = substr(P_CHAVENFE, 26, 9)
                        and trim(l.edi_nf_serie)  = substr(P_CHAVENFE, 23, 3)
                        and trim(l.edi_emb_cnpj)  = substr(P_CHAVENFE, 7, 14);            
              end if; 
          
           ELSE
                  select l.edi_emb_cnpj remetente,
                         l.edi_dest_cnpj,
                         l.edi_nf_serie,
                         l.edi_nf_numero,
                         l.edi_nf_emissao emissao,
                         l.edi_nf_chavenfe chavenfe,
                         l.edi_nf_mercadoria,
                         l.edi_nf_volumes,
                         l.edi_nf_valor,
                         l.edi_nf_pesototal peso_nota,
                         l.edi_nf_cfop cfop,
                         l.edi_nf_numerosap,
                         l.arm_coleta_ncompra,
                         l.arm_coleta_ciclo,
                         l.edi_nf_pesocubado
                    into P_Nota.Edi_Emb_Cnpj,
                         P_Nota.Edi_Dest_Cnpj,
                         P_Nota.Edi_Nf_Serie,
                         P_Nota.Edi_Nf_Numero,
                         P_Nota.Edi_Nf_Emissao,
                         P_Nota.Edi_Nf_Chavenfe,
                         P_Nota.Edi_Nf_Mercadoria,
                         P_Nota.Edi_Nf_Volumes,
                         P_Nota.Edi_Nf_Valor,
                         P_Nota.Edi_Nf_Pesototal,
                         P_Nota.Edi_Nf_Cfop,
                         P_Nota.Edi_Nf_Numerosap,
                         P_Nota.Arm_Coleta_Ncompra,
                         P_Nota.Arm_Coleta_Ciclo,
                         P_Nota.edi_nf_pesocubado
                    from t_edi_nf l
                    where l.edi_nf_chavenfe = P_CHAVENFE;
                    -- 35130709358108001288550040002297041623130109
           END IF;     
             
    EXCEPTION WHEN OTHERS THEN
          P_STATUS  := 'E';
          P_MESSAGE := 'ERRO SO CONSULTAR DESTINATÁRIO. ERRO = '||SQLERRM;
    END;
    
    P_STATUS  := 'N';
    P_MESSAGE := 'PROCESSAMENTO NORMAL.';  
        
End Sp_Get_NotaPorChave;     

-- New 06/02/2014    

Procedure Sp_Get_NotaDevolReentr(pXmlIn In Varchar2,
                                 pXmlOut Out Clob,
                                 pStatus Out Char,
                                 pMessage Out Varchar2)

As
vNota varchar2(11) ; --t_arm_nota.arm_nota_numero%Type;
vCNPJ t_arm_nota.glb_cliente_cgccpfremetente%Type;
vCTRC t_con_conhecimento.con_conhecimento_codigo%Type;
vSerie t_con_conhecimento.con_conhecimento_serie%Type;
vRota t_con_conhecimento.glb_rota_codigo%Type;
vXmlRetorno Clob;
vCount      Integer;   
vLinha      Clob;

Begin

/*     
<Parametros>    
  <Input>        
     <Nota>91418</Nota>        
     <CNPJ>07083656000750</CNPJ>        
     <CTRC>644845</CTRC>        
     <Serie>A1</Serie>        
     <Rota>197</Rota>        
     <Coleta></Coleta>    
  </Input>
</Parametros>
*/  
      Begin
       Select trim(extractvalue(Value(V), 'Input/Nota')),
              trim(extractvalue(Value(V), 'Input/CNPJ')),
              trim(extractvalue(Value(V), 'Input/CTRC')),
              trim(extractvalue(Value(V), 'Input/Serie')),
              trim(extractvalue(Value(V), 'Input/Rota'))
             into vNota,
                  vCNPJ,
                  vCTRC,
                  vSerie,
                  vRota
            From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;
       Exception
         When Others Then
           pStatus := 'E';
           pMessage := sqlerrm;
           return;
       End;   

   vLinha := '';
   vCount := 0;  
   pStatus := 'x';
   for n in (
              
                Select arm_coleta_ncompra coleta_codigo,
                       armnota.arm_armazem_codigo armazem_codigo,
                       armnota.transferir_para armazem_transfdestino,
                       substr(arm_embalagem_numero, 01, 06) embalagem_numero,
                       trim(to_char(armnota.ARM_NOTA_NUMERO)) nota_numero,
                       to_char(arm_nota_dtinclusao, 'dd/mm/yyyy hh24:mi:ss') nota_dtinclusao,
                       to_char(armnota.arm_nota_qtdvolume) nota_qtdevolume,
                       to_char(arm_nota_peso) nota_pesonota,
                       to_char(armnota.arm_nota_sequencia) nota_sequencia,
                       substr(trim(glb_cliente_cgccpfremetente), 01, 15) remetente_cnpj,
                       pkg_fifo_auxiliar.fn_removeAcentos(remetente) rementente_rsocial,
                       pkg_fifo_auxiliar.fn_removeAcentos(glb_tpcliend_codremetente) remetente_tpendereco,
                       substr(origem, 01, 25) remetente_locdesc,
                       substr(trim(glb_cliente_cgccpfdestinatario), 01, 15) destino_cnpj,
                       pkg_fifo_auxiliar.fn_removeAcentos(destinatario) destino_rsocial,
                       pkg_fifo_auxiliar.fn_removeAcentos(glb_tpcliend_coddestinatario) destino_tpendereco,
                       pkg_fifo_auxiliar.fn_removeAcentos(substr(destino, 01, 25)) destino_locdesc,
                       pkg_fifo_auxiliar.fn_removeAcentos(alx) destino_codclientes,
                       substr(Trim(ctrc), 01, 10) ctrc_codigo,
                       substr(Trim(rota), 01, 03) ctrc_rota,
                       substr(Trim(serie), 01, 03) ctrc_serie,
                       pkg_fifo_auxiliar.fn_removeAcentos(usuario) usuario_tdv,
                       arm_carregamento_codigo carregamento,
                       armnota.Arm_Nota_Serie arm_nota_serie,       
                       chekin chekin
                  FROM V_NOTA_RECEBIMENTO armnota
                 WHERE 0 = 0   
                   And armnota.ARM_NOTA_NUMERO = vNota--'356323'
                   And armnota.GLB_CLIENTE_CGCCPFREMETENTE = vCNPJ--'43238138000136'
--                   AND armnota.CTRC = LPAD(vCTRC,6,'0')--'512178'
--                   And armnota.SERIE = vSerie--'A1'
--                   And armnota.ROTA = LPAD(vRota,3)--'021'
                  and armnota.ARM_NOTA_DTINCLUSAO = ( select max(n.ARM_NOTA_DTINCLUSAO)
                                                        from V_NOTA_RECEBIMENTO n
                                                        where n.arm_nota_numero = armnota.arm_nota_numero
                                                          and n.GLB_CLIENTE_CGCCPFREMETENTE = armnota.GLB_CLIENTE_CGCCPFREMETENTE )
                                                             
                /*
                select n.arm_embalagem_sequencia nota_sequencia,
                       n.con_conhecimento_codigo ctrc_codigo,
                       n.con_conhecimento_serie ctrc_serie,
                       n.glb_rota_codigo ctrc_rota,
                       n.arm_nota_numero nota_numero,
                       n.glb_cliente_cgccpfremetente remetente_cnpj,
                       n.arm_nota_dtinclusao nota_dtinclusao
                  from t_arm_nota n
                  where n.arm_nota_numero = '2323'
                    and n.glb_cliente_cgccpfremetente = '04943352000131'
                    and n.con_conhecimento_codigo = '509202'
                    and n.con_conhecimento_serie = 'A1'
                    and n.glb_rota_codigo = '021'
                    and n.arm_nota_dtinclusao = ( Select max(nn.arm_nota_dtinclusao)
                                                   from t_arm_nota nn
                                                   where nn.arm_nota_numero = n.arm_nota_numero
                                                     and nn.glb_cliente_cgccpfremetente = n.glb_cliente_cgccpfremetente)                
                   */
                 )
   Loop
     if  (LPAD(vCTRC,6,'0') = n.ctrc_codigo ) and 
         (vSerie = n.ctrc_serie ) and 
         (LPAD(vRota,3) = n.ctrc_rota ) then 
               
             vCount := vCount + 1;                           
             vLinha := vLinha
                       || '<row num="'|| To_Char(vCount)                        || '" >'    ||
                              '<Nota>'       || To_Char(trim(n.nota_numero))    || '</Nota>'      ||
                              '<CNPJ>'       || To_Char(trim(n.remetente_cnpj)) || '</CNPJ>'      ||                              
                              '<Sequencia>'  || To_Char(trim(n.nota_sequencia)) || '</Sequencia>' ||                              
                          '</row>';     
     Else
       pMessage := 'Cte Encontrado - ' || n.ctrc_codigo || '-' || n.ctrc_serie || '-' || n.ctrc_rota || chr(10);
       pMessage := pMessage || 'Cte Informado  - ' || LPAD(vCTRC,6,'0') || '-' || vSerie || '-' || LPAD(vRota,3,'0') || chr(10);
       pStatus := 'W';
     End If;
                           
   End Loop;
   if pStatus = 'W' then
      pMessage := 'Problema no CTe/NFSe Informado.' || chr(10) || pMessage;
   End If;
   
   If (vCount = 0) and (pStatus = 'x' ) then
     pStatus := 'W';
     pMessage := 'Nota não encontrado.';          
   end if;
   
   if ( vCount > 0 ) and (trim(pStatus) = 'x' ) then
     pStatus := 'N';
     pMessage := 'OK';        
   End If;
  
       
   vXmlRetorno :=               '<Parametros>';
   vXmlRetorno := vXmlRetorno ||     '<OutPut>';
   vXmlRetorno := vXmlRetorno ||          '<Status>' ||pStatus ||'</Status>';
   vXmlRetorno := vXmlRetorno ||          '<Message>'||pMessage||'</Message>';   
   vXmlRetorno := vXmlRetorno ||          '<Tables>';
   vXmlRetorno := vXmlRetorno ||               '<Table name="Status"><RowSet>'|| vLinha || '</RowSet></Table>';
   vXmlRetorno := vXmlRetorno ||          '</Tables>';
   vXmlRetorno := vXmlRetorno ||     '</OutPut>';
   vXmlRetorno := vXmlRetorno ||'</Parametros>';          

   pXmlOut := PKG_GLB_COMMON.FN_LIMPA_CAMPO(vXmlRetorno);

   

End Sp_Get_NotaDevolReentr;  

Function Fn_Get_FinalizaDigNota(pCodigo In t_Arm_Coletaocor.Arm_Coletaocor_Codigo%Type) return char
As  
  vCount Integer;
Begin
  
  select Count(*)
  into vCount
  from t_arm_coletaocor co
  where co.arm_coletaocor_codigo = pcodigo
    and co.arm_coletaocor_flagativo = 'S'
    and (co.arm_coletaocor_encerradig = 'S' -- Se Encerrada a Dig, ou Se finalizada, consudero como finalizada a Digitação
          or co.arm_coletaocor_finaliza   = 'S');
  
  if vCount > 0 then  
     Return 'S';   
  else
     Return 'N';
  end if;
    
End Fn_Get_FinalizaDigNota;                     

Procedure Sp_Get_ProdQuimico(pXmlIn In Varchar2,
                             pXmlOut Out Clob,
                             pStatus Out Char,
                             pMessage Out Varchar)
As
/*  XmlIn de Ex: 
       <Parametros>
          <Input>
             <Sequencia>768988</Sequencia>
          </Input>
       </Parametros> 
*/        
vNota t_arm_nota.arm_nota_numero%Type;
vRemetenteCNPJ t_Arm_Nota.Glb_Cliente_Cgccpfremetente%Type;
vSequencia t_Arm_Nota.Arm_Nota_Sequencia%Type;
vXmlTable Clob;
Begin
    Begin
     Select trim(extractvalue(Value(V), 'Input/Nota')),
            trim(extractvalue(Value(V), 'Input/CNPJ')),
            trim(extractvalue(Value(V), 'Input/Sequencia'))
           into vNota,
                vRemetenteCNPJ,
                vSequencia
          From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;
    Exception
       When Others Then
         pStatus := 'E';
         pMessage := sqlerrm;
         return;
    End;    
    
    Begin
       vXmlTable := FNP_getDadosProdQuimicos2(vSequencia);
       pStatus := 'N';
       pMessage := 'OK';
    Exception
      When Others Then
        pStatus := 'E';
        pMessage := sqlerrm;
    End;
    
    pXmlOut := Pkg_Glb_Common.FN_LIMPA_CAMPO(
               '<Parametros>
                   <OutPut>
                         <Status>' ||pStatus ||'</Status>
                         <Message>'||pMessage||'</Message>                               
                         <Tables>
                               <Table name="produtos_quimico"><RowSet>'|| vXmlTable || '</RowSet></Table>
                         </Tables>
                   </OutPut>
                </Parametros>' );    
     
End Sp_Get_ProdQuimico;                             

Procedure Sp_Get_Ocorrencias(pXmlIn In Varchar2,
                             pXmlOut Out Clob,
                             pStatus Out Char,
                             pMessage Out Varchar)
As
/*  XmlIn de Ex: 
       <Parametros>
          <Input>
             <OcorrenciaClassCodigo>0109</OcorrenciaClassCodigo>
             <TipoOcorrenciaCodigo>002</TipoOcorrenciaCodigo>             
          </Input>
       </Parametros> 
*/        
vOcorrenciaClassCodigo Varchar2(10); --v_Glb_Ocorrencia.glb_ocorrclass_codigo%Type;
vTipoOcorrenciaCodigo  Varchar2(10);--v_Glb_Ocorrencia.glb_ocorrtpdoc_codigo%Type;
vXml Clob;
Begin
    Begin
     Select trim(extractvalue(Value(V), 'Input/OcorrenciaClassCodigo')),
            trim(extractvalue(Value(V), 'Input/TipoOcorrenciaCodigo'))
           into vOcorrenciaClassCodigo,
                vTipoOcorrenciaCodigo
          From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;
    Exception
       When Others Then
         pStatus := 'E';
         pMessage := 'Erro ao Converter XmlIn ' || sqlerrm;
         return;
    End;    
    
    Begin
        For o In ( select t.glb_ocorr_id ID, 
                          t.glb_ocorrclass_descr || ' - ' || glb_ocorr_descr descr
                     from V_GLB_OCORRENCIA t
                     where t.glb_ocorrtpdoc_codigo = vTipoOcorrenciaCodigo
                       and t.glb_ocorrclass_codigo = vOcorrenciaClassCodigo
                    )
                    Loop
                      vXml := vXml || '<row>' ;
                      vXml := vXml ||    '<ID>'        || o.id    || '</ID>'     ;
                      vXml := vXml ||    '<Descricao>' || o.descr || '</Descricao>'   ;
                      vXml := vXml || '</row>';
                    End Loop;  
       pStatus := 'N';
       pMessage := 'OK';
    Exception
      When Others Then
        pStatus := 'E';
        pMessage := sqlerrm;
    End;
    
    pXmlOut := Pkg_Glb_Common.FN_LIMPA_CAMPO(
               '<Parametros>
                   <OutPut>
                         <Status>' ||pStatus ||'</Status>
                         <Message>'||pMessage||'</Message>                               
                         <Tables>
                               <Table name="ocorrencias"><RowSet>'|| vXml || '</RowSet></Table>
                         </Tables>
                   </OutPut>
                </Parametros>' );    
     
End Sp_Get_Ocorrencias;    



/*   proc´s do Anderson Fabio */

  Function FN_NotasVencidas( pArm_nota_numero              in integer,
                             pArm_nota_serie               in Varchar2,
                             p_glb_cliente_cgccpfremetente in Varchar2 ) return integer is
    vValida boolean;                             
    pMessage varchar2(1000);
    Begin                             
      
    vValida := tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(pArm_nota_numero,
                                                                   p_glb_cliente_cgccpfremetente,
                                                                   pArm_nota_serie,
                                                                   pMessage);
    if(vValida = true) Then                                                                                                                        
       return 0;
    else
       return 1;
    end if;
  End FN_NotasVencidas;


 Procedure SP_INSERT_NOTA_SEM_PESAGEM( pArmNotaSequencia in varchar2,
                                        pUsuario in Varchar2,
                                        pObservacao in Varchar2,
                                        pStatus out char,
                                        pMessage out Varchar2 ) as

vARM_NOTA_NUMERO T_arm_nota.Arm_Nota_Numero%type;
vGLB_CLIENTE_CGCCPFREMETENTE t_arm_nota.glb_cliente_cgccpfremetente%type;
vARM_NOTA_QTDVOLUME t_arm_nota.arm_nota_qtdvolume%type;
vARM_NOTA_PESO t_arm_nota.arm_nota_peso%type;
vARM_NOTAPESAGEM_QTDVOLUME t_arm_nota.arm_nota_qtdvolume%type;
vARM_NOTAPESAGEM_COD int;
vARM_NOTA_CHAVENFE t_arm_nota.arm_nota_chavenfe%type;
VARM_NOTA_SEQUENCIA t_arm_nota.arm_nota_sequencia%type;
Begin
  

select max(ARM_NOTAPESAGEM_COD) into vARM_NOTAPESAGEM_COD from t_arm_notapesagem;

select x.arm_nota_numero, x.glb_cliente_cgccpfremetente, 
x.arm_nota_qtdvolume, x.arm_nota_peso,
x.arm_nota_qtdvolume, x.arm_nota_chavenfe, x.arm_nota_sequencia
into
varm_nota_numero, vglb_cliente_cgccpfremetente, 
varm_nota_qtdvolume, varm_nota_peso,
varm_nota_qtdvolume, varm_nota_chavenfe, VARM_NOTA_SEQUENCIA
from T_ARM_NOTA x 
where x.arm_nota_sequencia = pArmNotaSequencia;

insert into t_arm_notapesagem(ARM_NOTA_NUMERO,
                               GLB_CLIENTE_CGCCPFREMETENTE,
                               ARM_NOTA_QTDVOLUME,
                               USU_USUARIO_CODIGOIMPRIMIU,
                               ARM_NOTA_PESO,
                               ARM_NOTAPESAGEM_QTDVOLUME,
                               ARM_NOTAPESAGEM_PESOTOTAL,
                               ARM_NOTAPESAGEM_DTIMPRIMIU,
                               ARM_NOTAPESAGEM_COD,
                               ARM_NOTA_SEQUENCIA,
                               ARM_NOTA_CHAVENFE,
                               ARM_NOTAPESAGEM_OBS)
                         values 
                              (vARM_NOTA_NUMERO,
                               vGLB_CLIENTE_CGCCPFREMETENTE,
                               vARM_NOTA_QTDVOLUME,
                               pUsuario,
                               vARM_NOTA_PESO,
                               vARM_NOTAPESAGEM_QTDVOLUME,
                               vARM_NOTA_PESO,
                               sysdate,
                               vARM_NOTAPESAGEM_COD,
                               VARM_NOTA_SEQUENCIA,
                               vARM_NOTA_CHAVENFE,
                               pObservacao);
commit;                                                                                   

End SP_INSERT_NOTA_SEM_PESAGEM;  
  
 Procedure Sp_Get_NotasSemPesagem(pArm_armazem_codigo in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                                 pGlb_Rota_Codigo in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                 pusuUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2) as
  mRegIni int;
  mRegFin int;
  vCapacidade int;
  vDias int;
  Begin
    
    vDias := 360;
    select max(fb.glb_filialbalanca_capacidade) into vCapacidade
    from tdvadm.t_glb_filialbalanca fb
    where fb.glb_rota_codigo = pGlb_Rota_Codigo and fb.glb_filialbalanca_ativa = 'S';

      mRegIni := 1+((pPagina-1)*7);
      mRegFin := 7*pPagina;
    begin
     open pCursor for
     select *
       from ( select topn.*, ROWNUM rnum
      from (       
select
      nf.arm_nota_dtinclusao,
      nf.arm_nota_sequencia,
      nf.arm_armazem_codigo,
      nf.arm_movimento_datanfentrada DataEmissao, 
      nf.arm_Nota_DTRecebimento DataSaida,
      nf.arm_nota_numero,
      nf.glb_cliente_cgccpfremetente,
      crem.glb_cliente_razaosocial,
      nf.arm_nota_valormerc,
      nf.arm_nota_serie,
      nf.arm_nota_peso Peso,
      endorigem.glb_estado_codigo UF_Origem, endorigem.glb_localidade_descricao Origem,
      enddest.glb_estado_codigo UF_Destino, enddest.glb_localidade_descricao Destino,
      tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota(
      nf.arm_embalagem_numero, 
      nf.arm_embalagem_flag, 
      nf.arm_embalagem_sequencia,
      'A','N','D') Validade  
      from tdvadm.t_arm_nota nf 
      join tdvadm.t_glb_cliente crem on trim(nf.glb_cliente_cgccpfremetente) = trim(crem.glb_cliente_cgccpfcodigo)
      join tdvadm.t_glb_localidade endorigem on trim(nf.arm_nota_localcoletal) = trim(endorigem.glb_localidade_codigo)
      join tdvadm.t_glb_localidade enddest on trim(nf.arm_nota_localentregal) = trim(enddest.glb_localidade_codigo)
      left outer join tdvadm.t_arm_notapesagem np on nf.arm_nota_numero = np.arm_nota_numero and nf.arm_nota_sequencia = np.arm_nota_sequencia      
      where 0 = 0
        and nf.arm_armazem_codigo like pArm_armazem_codigo
      --and nf.glb_rota_codigo = pGlb_Rota_Codigo
      and nvl(np.arm_notapesagem_pesototal,0) = 0
      and nf.arm_nota_peso <= vCapacidade
      and nf.arm_nota_dtinclusao >= sysdate-vDias
      and nf.con_conhecimento_codigo is null
      and nf.arm_armazem_codigo in (
       select am.arm_armazem_codigo
         from t_usu_usuariorota r,
               t_arm_armazem am
               where r.usu_usuario_codigo = pusuUsuario
               and r.glb_rota_codigo = am.glb_rota_codigo
         )
      order by nf.arm_movimento_datanfentrada desc
       ) topn where ROWNUM <= mRegFin )
         where rnum  >= mRegIni;  
      
      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasSemPesagem. Erro.: '||sqlerrm;
      
    end;
 End Sp_Get_NotasSemPesagem;      
    
 Procedure Sp_Get_NFSemPesagemAut(pArm_armazem_codigo in varchar2,
                                 pPagina  in int,
                                 pCursor  out t_cursor,
                                 pStatus  out varchar2,
                                 pMessage out varchar2) as
  mRegIni int;
  mRegFin int;
  vDias int;
  Begin
    
    vDias := 90;
      mRegIni := 1+((pPagina-1)*10);
      mRegFin := 10*pPagina;
    begin
     open pCursor for
     select *
       from ( select topn.*, ROWNUM rnum
      from (       
select
      nf.arm_nota_dtinclusao,
      nf.arm_nota_sequencia,
      nf.arm_armazem_codigo,
      nf.arm_movimento_datanfentrada DataEmissao, 
      nf.arm_Nota_DTRecebimento DataSaida,
      nf.arm_nota_numero,
      nf.glb_cliente_cgccpfremetente,
      crem.glb_cliente_razaosocial,
      nf.arm_nota_valormerc,
      nf.arm_nota_serie,
      nf.arm_nota_peso Peso,
      
      np.arm_notapesagem_dtimprimiu DtAutorizacao,
      np.usu_usuario_codigoimprimiu Autorizador,
      np.arm_notapesagem_obs Observacao,
      
      endorigem.glb_estado_codigo UF_Origem, endorigem.glb_localidade_descricao Origem,
      enddest.glb_estado_codigo UF_Destino, enddest.glb_localidade_descricao Destino      
      from tdvadm.t_arm_nota nf 
      join tdvadm.t_glb_cliente crem on trim(nf.glb_cliente_cgccpfremetente) = trim(crem.glb_cliente_cgccpfcodigo)
      join tdvadm.t_glb_localidade endorigem on trim(nf.arm_nota_localcoletal) = trim(endorigem.glb_localidade_codigo)
      join tdvadm.t_glb_localidade enddest on trim(nf.arm_nota_localentregal) = trim(enddest.glb_localidade_codigo)
      join tdvadm.t_arm_notapesagem np on nf.arm_nota_sequencia = np.arm_nota_sequencia      
      left outer join tdvadm.t_arm_notapesagemitem npi on nf.arm_nota_sequencia = npi.arm_nota_sequencia
      where nf.arm_armazem_codigo like pArm_armazem_codigo
      and np.arm_notapesagem_dtimprimiu >= sysdate-vDias
      and npi.arm_nota_sequencia is null
      order by nf.arm_movimento_datanfentrada desc
       ) topn where ROWNUM <= mRegFin )
         where rnum  >= mRegIni;  
      
      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasSemPesagem. Erro.: '||sqlerrm;
      
    end;
    
  End Sp_Get_NFSemPesagemAut;
  
 Procedure Sp_Get_NFSemPesagemAutCount(pArm_armazem_codigo in varchar2,
                                 pStatus  out varchar2,
                                 pMessage out varchar2,
                                 pTotalPaginas out int) as
                                 
  vDias int;
  Begin
    
    vDias := 90;
    select count(*) into pTotalPaginas
      from tdvadm.t_arm_nota nf 
      join tdvadm.t_glb_cliente crem on trim(nf.glb_cliente_cgccpfremetente) = trim(crem.glb_cliente_cgccpfcodigo)
      join tdvadm.t_glb_localidade endorigem on trim(nf.arm_nota_localcoletal) = trim(endorigem.glb_localidade_codigo)
      join tdvadm.t_glb_localidade enddest on trim(nf.arm_nota_localentregal) = trim(enddest.glb_localidade_codigo)
      join tdvadm.t_arm_notapesagem np on nf.arm_nota_sequencia = np.arm_nota_sequencia      
      left outer join tdvadm.t_arm_notapesagemitem npi on nf.arm_nota_sequencia = npi.arm_nota_sequencia
      where nf.arm_armazem_codigo like pArm_armazem_codigo
      and np.arm_notapesagem_dtimprimiu >= sysdate-vDias
      and npi.arm_nota_sequencia is null;
      
      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasSemPesagem. Erro.: '||sqlerrm;
      
  End Sp_Get_NFSemPesagemAutCount;
  
 Procedure Sp_Get_NotasSemPesagemCount(pArm_armazem_codigo in varchar2,
                                 pGlb_Rota_Codigo in varchar2,
                                 pusuUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                 pStatus  out varchar2,
                                 pMessage out varchar2,
                                 pTotalPaginas out int) as
  vCapacidade int;
  vDias int;
  Begin
    
    vDias := 360;
    
    select max(fb.glb_filialbalanca_capacidade) into vCapacidade
    from tdvadm.t_glb_filialbalanca fb
    where fb.glb_rota_codigo = pGlb_Rota_Codigo and fb.glb_filialbalanca_ativa = 'S';
   
  
    select count(*) into pTotalPaginas
      from tdvadm.t_arm_nota nf 
      join tdvadm.t_glb_cliente crem on trim(nf.glb_cliente_cgccpfremetente) = trim(crem.glb_cliente_cgccpfcodigo)
      join tdvadm.t_glb_localidade endorigem on trim(nf.arm_nota_localcoletal) = trim(endorigem.glb_localidade_codigo)
      join tdvadm.t_glb_localidade enddest on trim(nf.arm_nota_localentregal) = trim(enddest.glb_localidade_codigo)
      left outer join tdvadm.t_arm_notapesagem np on nf.arm_nota_numero = np.arm_nota_numero and nf.arm_nota_sequencia = np.arm_nota_sequencia      
      where nf.arm_armazem_codigo like pArm_armazem_codigo
      --and nf.glb_rota_codigo = pGlb_Rota_Codigo
      and nvl(np.arm_notapesagem_pesototal,0) = 0
      and nf.arm_nota_peso <= vCapacidade
      and nf.arm_nota_dtinclusao >= sysdate-vDias
      and nf.con_conhecimento_codigo is null
      and nf.arm_armazem_codigo in (
       select am.arm_armazem_codigo
         from t_usu_usuariorota r,
               t_arm_armazem am
               where r.usu_usuario_codigo = pusuUsuario
               and r.glb_rota_codigo = am.glb_rota_codigo
         )      
      order by nf.arm_movimento_datanfentrada desc;
      
      pStatus  := PKG_GLB_COMMON.Status_Nomal;
      pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.Sp_Get_NotasSemPesagemCount. Erro.: '||sqlerrm;
      
    
    
  End Sp_Get_NotasSemPesagemCount;
  
 Procedure SP_Autoriza_OC_Img (  pconConhecimentoCodigo in varchar2,
                                  pconConhecimentoSerie in varchar2,
                                  pconValeFreteSaque in varchar2,
                                  pglbGrupoImagemCodigo in varchar2,
                                  pglbRotaCodigo in varchar2,
                                  pglbTpArquivoCodigo in varchar2,
                                  pglbTpImagemCodigo in varchar2,
                                  pglbVfimagemCodCliente in varchar2,
                                  pStatus out char,
                                  pMessage out varchar2
                               ) as
  Begin                               
  update t_glb_vfimagem x set x.glb_vfimagem_dtconferencia=sysdate
         where x.con_conhecimento_codigo = pconConhecimentoCodigo
               and x.con_conhecimento_serie = pconConhecimentoSerie
               and x.con_valefrete_saque = pconValeFreteSaque
               and x.glb_grupoimagem_codigo = pglbGrupoImagemCodigo
               and x.glb_rota_codigo = pglbRotaCodigo
               and x.glb_tparquivo_codigo = pglbTpArquivoCodigo
               and x.glb_tpimagem_codigo = pglbTpImagemCodigo
               and x.glb_vfimagem_codcliente = pglbVfimagemCodCliente;
        commit;
        pStatus  := PKG_GLB_COMMON.Status_Nomal;
        pMessage := 'Processamento normal.';
    exception when others then
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.SP_Autoriza_OC_Img. Erro.: '||sqlerrm;
    

  End;

 Procedure SP_Get_Outros_Comp_Img ( pValeFrete in String,
                                     pPagina in int,
                                     pCursor out t_cursor,
                                     pStatus out char,
                                     pMessage out varchar2) as
 mRegIni int;
 mRegFin int;
                                     
 Begin

 mRegIni := 1+((pPagina-1)*10);
 mRegFin := 10*pPagina;
    begin
     open pCursor for
     select *
       from ( select topn.*, ROWNUM rnum
      from ( 
         select 
         coleta.pkg_web_auxiliar.fn_retornaLinkValeFrete(
         vfi.con_conhecimento_codigo, 
         vfi.con_conhecimento_serie, vfi.glb_rota_codigo, vfi.con_valefrete_saque, vfi.glb_vfimagem_codcliente) imagem,
         vfi.con_conhecimento_codigo    conConhecimentoCodigo,
         vfi.con_conhecimento_serie     conConhecimentoSerie,
         vfi.glb_rota_codigo            glbRotaCodigo,
         vfi.con_valefrete_saque        conValeFreteSaque,
         vfi.glb_vfimagem_codcliente    glbVfimagemCodCliente,
         vfi.glb_grupoimagem_codigo     glbGrupoImagemCodigo,
         vfi.glb_tpimagem_codigo        glbTpimagemCodigo,
         vfi.glb_tparquivo_codigo       glbTpArquivoCodigo,
         nvl(to_char(to_Date(vfi.glb_vfimagem_dtconferencia,'dd/mm/yy')),'             ') glbVFImagemDTConfere
         from t_glb_vfimagem vfi
         where vfi.con_conhecimento_codigo = pValeFrete
         ) topn where ROWNUM <= mRegFin )
           where rnum  >= mRegIni;  
      
        pStatus  := PKG_GLB_COMMON.Status_Nomal;
        pMessage := 'Processamento normal.';
    exception when others then
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.SP_Get_Outros_Comp_Img. Erro.: '||sqlerrm;
    
    end;
    
 End;
 
 Procedure SP_Get_Outros_Comp_ImgCount ( pValeFrete in String,
                                     pTotalReg out  int,
                                     pStatus out char,
                                     pMessage out varchar2) as
 Begin

         select count(*) into pTotalReg
         from t_glb_vfimagem vfi
         where vfi.con_conhecimento_codigo = pValeFrete;
      
        pStatus  := PKG_GLB_COMMON.Status_Nomal;
        pMessage := 'Processamento normal.';
    exception when others then
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.SP_Get_Outros_Comp_Img. Erro.: '||sqlerrm;
    
    
 End;

 Procedure SP_Get_Outros_Comp( pValeFrete in String,
                               pPagina in int,
                               pCursor out t_cursor,
                               pStatus out char,
                               pMessage out varchar2) as
 mRegIni int;
 mRegFin int;
 Begin

    mRegIni := 1+((pPagina-1)*10);
    mRegFin := 10*pPagina;

    begin
     open pCursor for
     select *
       from ( select topn.*, ROWNUM rnum
      from (       
   
        select vfi.con_conhecimento_codigo ValeFrete,
        cli.glb_cliente_razaosocial        Cliente,
        con.con_conhecimento_horasaida     Saida,
        con.con_conhecimento_entrega       Entrega,
        vfi.con_conhecimento_serie         Serie,
        vfi.glb_rota_codigo                Rota
        from t_glb_vfimagem vfi,
        t_con_conhecimento con,
        t_glb_cliente cli
        where vfi.con_conhecimento_codigo = con.con_conhecimento_codigo
        and vfi.con_conhecimento_serie = con.con_conhecimento_serie
        and vfi.glb_rota_codigo = con.glb_rota_codigo
        and vfi.con_conhecimento_codigo like pValeFrete
        and con.glb_cliente_cgccpfsacado = cli.glb_cliente_cgccpfcodigo
        and nvl(vfi.glb_vfimagem_dtconferencia,'01/01/1900') = decode(pvalefrete,'%',to_date('01/01/1900','dd/mm/yyyy'),nvl(vfi.glb_vfimagem_dtconferencia,'01/01/1900'))
        group by vfi.con_conhecimento_codigo,
        cli.glb_cliente_razaosocial        ,
        con.con_conhecimento_horasaida     ,
        con.con_conhecimento_entrega       ,
        vfi.glb_vfimagem_localservidor     ,
        vfi.con_conhecimento_serie         ,
        vfi.glb_rota_codigo                                 
        order by ValeFrete, Serie, Rota, Cliente
         ) topn where ROWNUM <= mRegFin )
           where rnum  >= mRegIni;  
      
        pStatus  := PKG_GLB_COMMON.Status_Nomal;
        pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.SP_Get_Outros_Comp. Erro.: '||sqlerrm;
      
    end;

   
 End;                                                             
 
 Procedure SP_Get_Outros_CompCount( pValeFrete in String,
                                    pTotalReg out int,
                                    pStatus out char,
                                    pMessage out varchar2) as
 Begin
        select count(*) into pTotalReg 
        from 
        ( 
        select con.con_conhecimento_codigo
        from t_glb_vfimagem vfi,
        t_con_conhecimento con,
        t_glb_cliente cli
        where vfi.con_conhecimento_codigo = con.con_conhecimento_codigo
        and vfi.con_conhecimento_serie = con.con_conhecimento_serie
        and vfi.glb_rota_codigo = con.glb_rota_codigo
        and vfi.con_conhecimento_codigo like pValeFrete
        and con.glb_cliente_cgccpfsacado = cli.glb_cliente_cgccpfcodigo
        and nvl(vfi.glb_vfimagem_dtconferencia,'01/01/1900') = decode(pvalefrete,'%',to_date('01/01/1900','dd/mm/yyyy'),nvl(vfi.glb_vfimagem_dtconferencia,'01/01/1900'))
        group by vfi.con_conhecimento_codigo,
        cli.glb_cliente_razaosocial        ,
        con.con_conhecimento_horasaida     ,
        con.con_conhecimento_entrega       ,
        vfi.con_conhecimento_serie         ,
        vfi.glb_rota_codigo) a  ;
      
        pStatus  := PKG_GLB_COMMON.Status_Nomal;
        pMessage := 'Processamento normal.';
    
    exception when others then
      
      pStatus  := PKG_GLB_COMMON.Status_Erro;
      pMessage := 'Erro ao executar pkg_fifo_recebimento.SP_Get_Outros_CompCount. Erro.: '||sqlerrm;
      
 End; 
 

/**************************************************/


function fn_get_dataentrega(pNota  in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCNPJ  in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pSerie in tdvadm.t_arm_nota.arm_nota_serie%type)
Return varchar2
Is

  FatorDia           CONSTANT number := 1;
  FatorHora          CONSTANT number := 0.0416666666666667;

   vContrato       tdvadm.t_slf_contrato.slf_contrato_codigo%Type;
   vAsn            tdvadm.t_arm_coleta.xml_coleta_numero%type;
   vEntCol         tdvadm.t_arm_coleta.arm_coleta_entcoleta%type;
   vGrupoSac       tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
   vGrupoRem       tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
   vGrupoDest      tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
   vColeta         tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
   vCiclo          tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
   vColetaExpressa tdvadm.t_arm_coleta.arm_coleta_tpcoleta%type;
   vColetaQuimico  tdvadm.t_arm_coleta.arm_coleta_flagquimico%type;
   vTpCarga        tdvadm.t_arm_coleta.fcf_tpcarga_codigo%type;
   vChaveNFe       tdvadm.t_Arm_Nota.arm_nota_chavenfe%type;
   vChaveCte       tdvadm.t_con_controlectrce.con_controlectrce_chavesefaz%type;
   vPrevisao        date;
   vDataProgramacao date;
   vUf             tdvadm.t_glb_localidade.glb_estado_codigo%type;
   vLocalidadeA    tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vLocalidadeC    tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vLocalidadeE    tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vDiasHorasUtil  number;
   vDiasHoras      number;
   vFator          number;
   vKm             number;  
   vDiasHorasUteisCorridos char(1);
   vDtauxiliar     timestamp(6);
   vCNPJSac        varchar2(20);
Begin
 
   Begin
     select an.slf_contrato_codigo,
            an.arm_coleta_ncompra,
            an.arm_coleta_ciclo,
            an.glb_cliente_cgccpfsacado,
            ( select cl.glb_grupoeconomico_codigo
              from tdvadm.t_glb_cliente cl,
                   tdvadm.t_glb_grupoeconomico gp
              where 0 = 0
                and cl.glb_grupoeconomico_codigo = gp.glb_grupoeconomico_codigo
                and cl.glb_cliente_cgccpfcodigo = rpad(an.glb_cliente_cgccpfsacado,20) ),
            co.xml_coleta_numero,
            co.arm_coleta_entcoleta,
            co.arm_coleta_tpcoleta,
            co.arm_coleta_flagquimico,
            clr.glb_grupoeconomico_codigo,
            cld.glb_grupoeconomico_codigo,
            co.fcf_tpcarga_codigo,
            an.arm_nota_chavenfe,
            cte.con_controlectrce_chavesefaz,
            lo.glb_estado_codigo,
            lo.glb_localidade_codigo,
            cec.glb_localidade_codigo,
            cee.glb_localidade_codigo
       into vContrato,
            vColeta,
            vCiclo,
            vCNPJSac,
            vGrupoSac,
            vAsn,
            vEntCol,
            vColetaExpressa,
            vColetaQuimico,
            vGrupoRem,
            vGrupoDest,
            vTpCarga,
            vChaveNFe,
            vChaveCte,
            vUf,
            vLocalidadeA,
            vLocalidadeC,
            vLocalidadeE
     from tdvadm.t_arm_nota an,
          tdvadm.t_arm_coleta co,
          tdvadm.t_glb_localidade lo,
          tdvadm.t_arm_armazem a,
          tdvadm.t_glb_cliend cec,
          tdvadm.t_glb_cliend cee,
          tdvadm.t_glb_cliente clr,
          tdvadm.t_glb_cliente cld,
          tdvadm.t_con_controlectrce cte
     where an.arm_nota_numero = pNota
       and an.glb_cliente_cgccpfremetente = pCNPJ
       and an.arm_nota_serie = pSerie
       and an.arm_coleta_ncompra = co.arm_coleta_ncompra
       and an.arm_coleta_ciclo = co.arm_coleta_ciclo
       and co.arm_armazem_codigo = a.arm_armazem_codigo
       and a.glb_localidade_codigo = lo.glb_localidade_codigo
       and co.glb_cliente_cgccpfcodigocoleta = cec.glb_cliente_cgccpfcodigo
       and co.glb_tpcliend_codigocoleta = cec.glb_tpcliend_codigo
       and co.glb_cliente_cgccpfcodigoentreg = cee.glb_cliente_cgccpfcodigo
       and co.glb_tpcliend_codigoentrega = cee.glb_tpcliend_codigo
       and co.glb_cliente_cgccpfcodigocoleta = clr.glb_cliente_cgccpfcodigo
       and co.glb_cliente_cgccpfcodigoentreg = cld.glb_cliente_cgccpfcodigo
       and an.con_conhecimento_codigo = cte.con_conhecimento_codigo (+)
       and an.con_conhecimento_serie = cte.con_conhecimento_serie (+)
       and an.glb_rota_codigo = cte.glb_rota_codigo (+);
   Exception 
    When NO_DATA_FOUND Then
         vGrupoSac := 'XXXX';
         vAsn := null;
    When OTHERS Then
       return null;         
    end ; 
    
    
       vFator := FatorDia;
        
       select max(p.slf_percurso_km)
          into vKm
       from tdvadm.t_slf_percurso p
       where p.glb_localidade_codigoorigemi = rpad(trim(tdvadm.fn_busca_codigoibge1(decode(vEntCol,'C',vLocalidadeC,vLocalidadeA),'IBC')),8)
         and p.glb_localidade_codigodestinoi = rpad(trim(tdvadm.fn_busca_codigoibge1(vLocalidadeE,'IBC')),8);

       vKm := nvl(vKm,0);
       If vKm = 0 Then
          return null;
       End If; 

       If vGrupoSac <> '0020' Then -- VALE
          Begin
             vPrevisao := to_date(tdvadm.pkg_arm_gercoleta.FN_CalculaPrazoColeta2(vColeta,
                                                                                  vCiclo,
                                                                                  'jsantos',
                                                                                  'E'),'dd/mm/yyyy hh24:mi:ss');
          exception
            When OTHERS Then
              return null;
            end; 
       End If;

    
    If vGrupoSac = 'ABCD' Then -- VALE    
      vGrupoSac := vGrupoSac;
    ElsIf vGrupoSac = '0020' Then -- VALE
       vDiasHoras := 0;
       Begin
          select max(a.dtagendamento) 
            into vDtauxiliar
          from eclick.t_eck_param_agendamento a
          where a.chave_cte = vChaveCte
            and a.chave_nfe = vChaveNFe
            and a.dtagendamento is not null;
          
          Begin
             vPrevisao:= CAST(vDtauxiliar As Date);
          exception
            When OTHERS Then
              return null;
            End;  
       exception
         When NO_DATA_FOUND Then
           return null;
       End;
       
    ElsIf vGrupoSac = '0074' Then -- VLI
         
       If vKm > 400 Then
          vDiasHoras := ( round(( vKm / 400 ) + 0.5,0 ) - 1 ) + 3;
       Else
          vDiasHoras := 3;
       End If;

    ElsIf vGrupoSac = '0612' Then -- ALBRAS

       If ( vTpCarga in ('03') ) or ( vColetaExpressa = 'S' )  Then
          If vKm <= 250 Then -- 12 horas
             vFator     := FatorHora;
             vDiasHoras := 12;
          ElsIf vKm <= 500 Then -- 12 Horas 
             vFator     := FatorHora;
             vDiasHoras := 12;
          ElsIf vKm <= 1000 Then -- 24 horas
             vFator     := FatorDia;
             vDiasHoras := 1;
          ElsIf vKm <= 1500 Then -- 48 horas
             vFator     := FatorDia;
             vDiasHoras := 2;
          ElsIf vKm <= 2000 Then  -- 60 horas
             vFator     := FatorHora;
             vDiasHoras := 60;
          ElsIf vKm <= 2500 Then -- 72 horas     
             vFator     := FatorDia;
             vDiasHoras := 3;
          ElsIf vKm <= 3000 Then -- 96 horas      
             vFator     := FatorDia;
             vDiasHoras := 4;
          Else                   -- 120 horas
             vFator     := FatorDia;
             vDiasHoras := 5;
          End If;
       Else
          If vKm <= 250 Then -- 24 horas
             vFator     := FatorDia;
             vDiasHoras := 1;
          ElsIf vKm <= 500 Then -- 36 horas 
             vFator     := FatorHora;
             vDiasHoras := 36;
          ElsIf vKm <= 1000 Then -- 72       
             vFator     := FatorDia;
             vDiasHoras := 3;
          ElsIf vKm <= 1500 Then -- 96         
             vFator     := FatorDia;
             vDiasHoras := 4;
          ElsIf vKm <= 2000 Then -- 120        
             vFator     := FatorDia;
             vDiasHoras := 5;
          ElsIf vKm <= 2500 Then -- 144   
             vFator     := FatorDia;
             vDiasHoras := 6;
          ElsIf vKm <= 3000 Then -- 168         
             vFator     := FatorDia;
             vDiasHoras := 7;
          Else                   -- 192
             vFator     := FatorDia;
             vDiasHoras := 8;
          End If;
       End If;            

    ElsIf vGrupoSac = '0613' Then -- ALUNORTE

       If ( vTpCarga in ('03') ) or ( vColetaExpressa = 'S' )  Then
          If vKm <= 250 Then -- 12 horas
             vFator     := FatorHora;
             vDiasHoras := 12;
          ElsIf vKm <= 500 Then -- 12 Horas 
             vFator     := FatorHora;
             vDiasHoras := 12;
          ElsIf vKm <= 1000 Then -- 24 horas
             vFator     := FatorDia;
             vDiasHoras := 1;
          ElsIf vKm <= 1500 Then -- 48 horas
             vFator     := FatorDia;
             vDiasHoras := 2;
          ElsIf vKm <= 2000 Then  -- 60 horas
             vFator     := FatorHora;
             vDiasHoras := 60;
          ElsIf vKm <= 2500 Then -- 72 horas     
             vFator     := FatorDia;
             vDiasHoras := 3;
          ElsIf vKm <= 3000 Then -- 96 horas      
             vFator     := FatorDia;
             vDiasHoras := 4;
          Else                   -- 120 horas
             vFator     := FatorDia;
             vDiasHoras := 5;
          End If;
       Else
          If vKm <= 250 Then -- 24 horas
             vFator     := FatorDia;
             vDiasHoras := 1;
          ElsIf vKm <= 500 Then -- 36 horas 
             vFator     := FatorHora;
             vDiasHoras := 36;
          ElsIf vKm <= 1000 Then -- 72       
             vFator     := FatorDia;
             vDiasHoras := 3;
          ElsIf vKm <= 1500 Then -- 96         
             vFator     := FatorDia;
             vDiasHoras := 4;
          ElsIf vKm <= 2000 Then -- 120        
             vFator     := FatorDia;
             vDiasHoras := 5;
          ElsIf vKm <= 2500 Then -- 144   
             vFator     := FatorDia;
             vDiasHoras := 6;
          ElsIf vKm <= 3000 Then -- 168         
             vFator     := FatorDia;
             vDiasHoras := 7;
          Else                   -- 192
             vFator     := FatorDia;
             vDiasHoras := 8;
          End If;
       End If;            

    ElsIf vGrupoSac = '0614' Then -- HYDRA

       If ( vTpCarga in ('03') ) or ( vColetaExpressa = 'S' )  Then
          If vKm <= 250 Then -- 12 horas
             vFator     := FatorHora;
             vDiasHoras := 12;
          ElsIf vKm <= 500 Then -- 12 Horas 
             vFator     := FatorHora;
             vDiasHoras := 12;
          ElsIf vKm <= 1000 Then -- 24 horas
             vFator     := FatorDia;
             vDiasHoras := 1;
          ElsIf vKm <= 1500 Then -- 48 horas
             vFator     := FatorDia;
             vDiasHoras := 2;
          ElsIf vKm <= 2000 Then  -- 60 horas
             vFator     := FatorHora;
             vDiasHoras := 60;
          ElsIf vKm <= 2500 Then -- 72 horas     
             vFator     := FatorDia;
             vDiasHoras := 3;
          ElsIf vKm <= 3000 Then -- 96 horas      
             vFator     := FatorDia;
             vDiasHoras := 4;
          Else                   -- 120 horas
             vFator     := FatorDia;
             vDiasHoras := 5;
          End If;
       Else
          If vKm <= 250 Then -- 24 horas
             vFator     := FatorDia;
             vDiasHoras := 1;
          ElsIf vKm <= 500 Then -- 36 horas 
             vFator     := FatorHora;
             vDiasHoras := 36;
          ElsIf vKm <= 1000 Then -- 72       
             vFator     := FatorDia;
             vDiasHoras := 3;
          ElsIf vKm <= 1500 Then -- 96         
             vFator     := FatorDia;
             vDiasHoras := 4;
          ElsIf vKm <= 2000 Then -- 120        
             vFator     := FatorDia;
             vDiasHoras := 5;
          ElsIf vKm <= 2500 Then -- 144   
             vFator     := FatorDia;
             vDiasHoras := 6;
          ElsIf vKm <= 3000 Then -- 168         
             vFator     := FatorDia;
             vDiasHoras := 7;
          Else                   -- 192
             vFator     := FatorDia;
             vDiasHoras := 8;
          End If;
       End If;            

    Else  -- Padrao Della Volpe

       If ( vTpCarga in ('03') ) or ( vColetaExpressa = 'S' )  Then
          If vKm > 600 Then
             vDiasHoras := ( round(( vKm / 600 ) + 0.5,0 ) - 1 ) + 3;
          Else
             vDiasHoras := 1;
          End If;   
       Else
          If vKm > 400 Then
             vDiasHoras := ( round(( vKm / 400 ) + 0.5,0 ) - 1 ) + 3;
          Else
             vDiasHoras := 2;
          End If;   
       End If;
         
                                                                    
    End If;
    

     vDataProgramacao := vPrevisao; 
     vDiasHorasUtil := 0;
     loop
        If ( f_diautillocal(vPrevisao,vUf,vLocalidadeA,null) = 'S' ) Then
           If  vPrevisao <> vDataProgramacao Then
              vDiasHorasUtil := vDiasHorasUtil + 1;
           End If;
        End If;
        exit when ( vDiasHoras = vDiasHorasUtil );
        vPrevisao := vPrevisao + vFator;
     end loop;
    

    return to_char(vPrevisao,'dd/mm/yyyy hh24:mi:ss');
  
End fn_get_dataentrega;

                            




end pkg_fifo_recebimento;
/
