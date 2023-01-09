CREATE OR REPLACE PACKAGE PKG_CON_CTE IS
  /***************************************************************************************************
  * ROTINA           :                                                                               *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  :                                                                               *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    :                                                                               *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    :                                                                               *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *
  * PARAM. OBRIGAT.  :                                                                               *
  ****************************************************************************************************/
  TYPE T_CURSOR IS REF CURSOR;
  
  

  TYPE TpEstruturaVeiculo IS RECORD (CTRC        tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                     SERIE       tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                     ROTA        tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                     Placa       TDVADM.T_CAR_VEICULO.CAR_VEICULO_PLACA%TYPE,
                                     Prop        TDVADM.T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE,
                                     Renavan     TDVADM.T_CAR_VEICULO.CAR_VEICULO_RENAVAN%TYPE,
                                     TpProp      char(1),
                                     TdRod       char(2),  
                                     TpVeic      char(1),
                                     TpCar       char(2), 
                                     UF          TDVADM.T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE
                                    );

    TYPE TpVeiculo IS TABLE OF TpEstruturaVeiculo INDEX BY BINARY_INTEGER; 

    vVeiculo TpVeiculo;


  /***************************************************************************************************
  **                        FUN«√O QUE RETORNA SE O CLIENTE … INTERNACIONAL                         **
  ***************************************************************************************************/
  FUNCTION FN_CLI_NACIONAL(P_CNPJ T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE)RETURN CHAR;
  
  FUNCTION FN_VALIDA_BXACOL(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) RETURN BOOLEAN;
                            
  FUNCTION FN_VALIDA_CTECOL(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) RETURN varchar2;

  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA O ENDERE«O DO CLIENTE                                 **
  ***************************************************************************************************/
  FUNCTION FN_CON_VALIDAENDERECOCLI(P_GLB_CLIENTE_CGCCPFCODIGO IN T_GLB_CLIEND.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                    P_GLB_TPCLIEND_CODIGO      IN T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%TYPE)RETURN INTEGER;
  
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA O CEP DO ENDERE«O DO CLIENTE                          **
  ***************************************************************************************************/
  FUNCTION FN_CON_VALIDACEPCTE(P_CNPJ   IN T_GLB_CLIEND.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                               P_TP_END IN T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%TYPE)RETURN CHAR;
                               
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA SE O CLIENTE … INTERNACIONAL                          **
  ***************************************************************************************************/                             
  FUNCTION FN_CLI_VALIDAINTER(P_CLIENTE IN T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE, 
                              P_TIPO    IN T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%TYPE)RETURN VARCHAR2;
  
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA A LOCALIDADE SO CLIENTE                               **
  ***************************************************************************************************/                            
  FUNCTION FN_CON_VALIDAIBGELOC(P_LOCALIDADE IN T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE)RETURN INTEGER;
  
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA O TOTAL DA PRESTA«√O DO CTE                           **
  ***************************************************************************************************/
  FUNCTION FN_CON_ITTPV(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                        P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                        P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN INTEGER;                            
                             
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA SE A CHAVE NFE … OBRIGATORIA                          **
  ***************************************************************************************************/
  FUNCTION FN_CTE_VERIOBRICHAVENFE(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                   P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                   P_CFOP  IN T_GLB_CFOP.GLB_CFOP_CODIGO%TYPE)RETURN CHAR;
                                   
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA SE A CHAVE NFE … VALIDA                               **
  ***************************************************************************************************/
  FUNCTION FN_CTE_VALIDACHAVENFE(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                 P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                 P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                 P_MESSAGE OUT VARCHAR2) RETURN CHAR;
                                 
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA SE O LOCAL DA COLETA                                  **
  ***************************************************************************************************/
  FUNCTION FN_CON_VALIDALOCALCOLETA(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR;

  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA SE O LOCAL DA ENTREGA                                 **
  ***************************************************************************************************/                                  
  FUNCTION FN_CON_VALIDALOCALENTREGA(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                     P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                     P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR;
                                     
  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA SE O LOCAL DA ENTREGA                                 **
  ***************************************************************************************************/                                  
  FUNCTION FN_CON_RETORNAOBSEMISSOR(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN VARCHAR2;
  
  
  
  /***************************************************************************************************
  **                     PROCEDURE QUE VALIDA UM CTE DE COMPLEMENTO                                 **
  ***************************************************************************************************/                                  
  PROCEDURE SP_CON_CTECOMPLEMENTO(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                  P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                  P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                  P_ERRO    OUT VARCHAR2,
                                  P_MESSAGE OUT VARCHAR2);
                                     
  
  /***************************************************************************************************
  **                        PROCEDURE PARA VALIDAR SE O CTE PODE SER EMITIDO                        **
  ***************************************************************************************************/
   PROCEDURE SP_CON_VALIDACTE(P_CTRC     IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                             P_SERIE    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                             P_ROTA     IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                             P_ERRO     OUT VARCHAR2,
                             P_MENSAGEM OUT VARCHAR2);
                             
  /***************************************************************************************************
  **           PROCEDURE PARA VALIDAR SE ROTA DO CTE ESTA LIBERADA PARA A EMISS√O DO CTE            **
  ***************************************************************************************************/
  PROCEDURE SP_CON_VALIDAROTACTE(P_ROTA     IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                 P_ERRO     OUT VARCHAR2,
                                 P_MENSAGEM OUT VARCHAR2);                                                                            

  /***************************************************************************************************
  **                        FUN«√O QUE VALIDA SE O LOCAL DA ENTREGA                                 **
  ***************************************************************************************************/                                  
  FUNCTION FN_SETVEICVIAGEM(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            P_DATA    IN DATE DEFAULT SYSDATE) RETURN CHAR;

  FUNCTION FN_GETPlaca(P_QUAL IN INTEGER) RETURN CHAR;
  FUNCTION FN_GETProp(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETRenavan(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETUF(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETCTRC(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETSERIE(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETROTA(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETTPPROP(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETTPVEIC(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETTDROD(P_QUAL IN INTEGER)  RETURN CHAR;
  FUNCTION FN_GETTPCAR(P_QUAL IN INTEGER)  RETURN CHAR;
  
  /***************************************************************************************************
  **                              FUN«√O QUE RETORNA A OBS DO CTE                                   **
  ***************************************************************************************************/
  FUNCTION FN_RETORNA_OBS(vConhecCodigo In tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type,
                          vConhecSerie  In tdvadm.t_con_conhecimento.con_conhecimento_serie%Type,
                          vGlbRota      In tdvadm.t_con_conhecimento.glb_rota_codigo%Type) Return Varchar2;

  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_REFRESH RETURN DATE;
   
  /***************************************************************************************************
  **                          PROCEDURE PARA REENVIO DO CTE                                         **
  ***************************************************************************************************/ 
  PROCEDURE SP_CON_REENVIACTESEMOUT (P_CTRC      IN CHAR,
                                     P_SERIE     IN CHAR, 
                                     P_ROTA      IN CHAR);
                                     
  PROCEDURE SP_CON_REENVIACTE(P_CTRC      IN CHAR,
                              P_SERIE     IN CHAR, 
                              P_ROTA      IN CHAR,
                              P_PARAMETRO IN VARCHAR2,
                              P_STATUS    OUT CHAR,
                              P_MESSAGE   OUT VARCHAR2);
  
  /*************************************************************************************************** 
  **                          PROCEDURE PARA LIMPARA CTE N√O GERADOS                                ** 
  ***************************************************************************************************/
  PROCEDURE SP_CON_LIMPANGERADOS;
   
  
  /***************************************************************************************************
  **                          FUN«√O PARA LIMPAR CAMPOS DO CTE                                      **
  ***************************************************************************************************/
  FUNCTION FN_LIMPA_CAMPOCTE(p_string     CHAR, p_trocapnulo char default 'N')return CHAR;
   
  
  /***************************************************************************************************
  **                          PROCEDURE PARA RETORNAR O JOB A SER UTILIZADO NO CTE                  **
  ***************************************************************************************************/
  FUNCTION FN_GET_LOCALIMP(p_cte     t_con_conhecimento.con_conhecimento_codigo%TYPE,
                           p_serie   t_con_conhecimento.con_conhecimento_serie%TYPE,
                           p_rota    t_con_conhecimento.glb_rota_codigo%TYPE) RETURN VARCHAR2;
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTERETORNASAC(CTRC   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            SERIE  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            ROTA   IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            INDICE IN VARCHAR2) RETURN T_GLB_CLICONT.GLB_CLICONT_EMAIL%TYPE;
      
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTERETPATHXML(CTRC   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            SERIE  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            ROTA   IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            INDICE IN VARCHAR2 ) RETURN VARCHAR2;
    
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTERETPATHPDF(CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            INDICE IN VARCHAR2 DEFAULT '0') RETURN VARCHAR2;
  
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTERETFILETYPE(CTRC   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,                
                             SERIE  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                             ROTA   IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                             INDICE IN VARCHAR2) RETURN VARCHAR2;                                                    
 
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTE_GETCHAVESEFAZ(P_CHAVE IN VARCHAR2) RETURN VARCHAR2;
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_FORMATA_DTRECCTE(P_DHRECBTO in varchar2)RETURN DATE;
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_GETREGESPECIAL(p_cte      t_con_conhecimento.con_conhecimento_codigo%TYPE,
                              p_serie   t_con_conhecimento.con_conhecimento_serie%TYPE,
                              p_rota    t_con_conhecimento.glb_rota_codigo%TYPE,
                              p_tipo    varchar2)RETURN CHAR;
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  PROCEDURE SP_SETREGESPECIAL(p_cte     IN  t_con_conhecimento.con_conhecimento_codigo%TYPE,
                              p_serie   IN t_con_conhecimento.con_conhecimento_serie%TYPE,
                              p_rota    IN t_con_conhecimento.glb_rota_codigo%TYPE,
                              P_STATUS  OUT CHAR,
                              P_MESSAGE OUT VARCHAR2,
                              P_TRIGGER IN char DEFAULT 'N');

  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  PROCEDURE SP_CON_CTECOMNF(P_CTRC    IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN  T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            P_STATUS  OUT CHAR,
                            P_MESSAGE OUT VARCHAR2);
  
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTEEXISTREDES(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) RETURN VARCHAR2;  
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  PROCEDURE SP_CON_VALIDASACADO(P_CTRC    IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                P_SERIE   IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                P_ROTA    IN  T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                P_STATUS  OUT CHAR,
                                P_MESSAGE OUT VARCHAR2);
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  PROCEDURE SP_CON_LIMPALOGREENV;         
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  PROCEDURE SP_CON_CTESEMRESP;
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  PROCEDURE SP_CON_LISTACTENAOACEITOS(P_CURSOR   OUT T_CURSOR,
                                       P_STATUS   OUT CHAR,
                                       P_MESSAGE  OUT VARCHAR2);
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  PROCEDURE SP_CON_AVISACTENACEiTO;
   
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTE_EMAILENVIADO(p_ctrc  in t_con_conhecimento.con_conhecimento_codigo%type,
                               p_serie in t_con_conhecimento.con_conhecimento_serie%type,
                               p_rota  in t_con_conhecimento.glb_rota_codigo%type) RETURN CHAR;
                                    
  /***************************************************************************************************
  **                                                                                                **
  ***************************************************************************************************/
  FUNCTION FN_CTE_EELETRONICO(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                              P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                              P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR;
   

  FUNCTION FN_CTE_CONFIRMAIMPOSTOS(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                   P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR ;

 
  Procedure sp_CteProcessaEnviado(p_arquivo  in varchar2,
                                  p_status   out char,
                                  p_message  out varchar2);

  Procedure sp_CteProcessaEnviadoCont(p_arquivo  in varchar2,
                                      p_data     in varchar2,
                                      p_status   out char,
                                      p_message  out varchar2);
  
  Procedure sp_CteDataBaseOK(p_status   out char,
                             p_message  out varchar2);                                    
  
  Procedure Sp_CtePodeEnviar(p_arquivo  in varchar2,
                             p_status   out char,
                             p_message  out varchar2);
                             
  
  FUNCTION FN_CTE_RETORNACONTRATO(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                  P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                  P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                  P_tIPO  IN CHAR default 'T')
        RETURN varchar2;
  
  PROCEDURE SP_NDD_ECONECTOR(P_DODUMENTO IN NUMBER,
                             P_SERIE     IN NUMBER,
                             P_JODIDNDD  IN NDD_NEW.TBLOGDOCUMENT.JOBID%TYPE,
                             p_status    out char,
                             p_message   out varchar2);
                             
  FUNCTION FN_RETORNA_TPAMBCTE(P_ROTA IN CHAR) RETURN CHAR;
  
  procedure Sp_Cte_ReenviaCancel(p_Cte   in t_con_conhecimento.con_conhecimento_codigo%type,
                                 p_Serie in t_con_conhecimento.con_conhecimento_serie%type,
                                 p_Rota  in t_con_conhecimento.glb_rota_codigo%type,
                                 p_Status out char,
                                 p_Message out varchar2);
                                 
  Function Fn_Cte_AverbaAperan(p_cte   in t_con_conhecimento.con_conhecimento_codigo%type,
                               p_serie in t_con_conhecimento.con_conhecimento_serie%type,
                               p_rota  in t_con_conhecimento.glb_rota_codigo%type)return char;
  
  Function Fn_Cte_RetornaApolice(p_cte   in t_con_conhecimento.con_conhecimento_codigo%type,
                                 p_serie in t_con_conhecimento.con_conhecimento_serie%type,
                                 p_rota  in t_con_conhecimento.glb_rota_codigo%type)return number;                             
  
  procedure sp_Con_CteGravaEventoCCe(p_cte       in  t_con_conhecimento.con_conhecimento_codigo%type,
                                     p_serie     in  t_con_conhecimento.con_conhecimento_serie%type,
                                     p_rota      in  t_con_conhecimento.glb_rota_codigo%type,
                                     p_usuario   in  t_usu_usuario.usu_usuario_codigo%type,
                                     p_TagCorr   in  t_con_tagcorrecao.con_tagcorrecao_cod%type,
                                     p_NovoVlr   in  t_con_eventocte.con_eventocte_valoralterado%type,
                                     p_Sequencia out t_con_eventocte.con_eventocte_seqevento%type,
                                     p_Status    out char,
                                     p_Message   out varchar2) ;
  
  Function FN_GET_CONTEUDOORIGINALCTE(p_cte       in  t_con_conhecimento.con_conhecimento_codigo%type,
                                      p_serie     in  t_con_conhecimento.con_conhecimento_serie%type,
                                      p_rota      in  t_con_conhecimento.glb_rota_codigo%type,
                                      p_Tag       in varchar2)
    return varchar2;
  
  Procedure Sp_Cte_ExcluiNdd(p_cte       in t_con_conhecimento.con_conhecimento_codigo%type,
                             p_serie     in t_con_conhecimento.con_conhecimento_serie%type,
                             p_rota      in t_con_conhecimento.glb_rota_codigo%type,
                             p_parametro in varchar2,
                             p_status    out char,
                             p_message   out varchar2);  
  
  
  Function Fn_Cte_RetxCaracAd(p_cte    in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                              p_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                              p_rota   in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2;
  
  Function Fn_Cte_RetDocUsiminas(p_cte    in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                 p_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                 p_rota   in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2;                            
 
  
  Function Fn_Cte_GetIndIeToma(p_cte    in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                               p_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                               p_rota   in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2;
  
  Function Fn_Cte_GettpServ(p_cte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                            p_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                            p_rota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2;                                                                                    
 
  Function Fn_Cte_GetUltimaPlacaCte(p_cte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                    p_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                    p_rota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2;
  
  Procedure Sp_Cte_GetTipoFrete(p_arquivo  in  varchar2,
                                p_tipocte  out varchar2,
                                p_status   out char,
                                p_message  out varchar2);
  
  Procedure Sp_Cte_GetTipoFreteCte(pCte       in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                   pSerie     in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                   pRota      in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                   p_tipocte  out varchar2,
                                   p_status   out char,
                                   p_message  out varchar2);
                                   
  Procedure Sp_Cte_GetTpEnvioNestle(p_arquivo  in  varchar2,
                                    p_tipoenv  out varchar2,
                                    p_status   out char,
                                    p_message  out varchar2);                                                               
                                    
END PKG_CON_CTE;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_CON_CTE IS
  /***************************************************************************************************
  * ROTINA           :                                                                               *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  :                                                                               *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    :                                                                               *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    :                                                                               *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *
  * PARAM. OBRIGAT.  :                                                                               *
  ****************************************************************************************************/
  
  FUNCTION FN_CLI_NACIONAL(P_CNPJ T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE)RETURN CHAR IS
  -- VARIAVEIS LOCAIS
  V_NACIONAL T_GLB_CLIENTE.GLB_CLIENTE_NACIONAL%TYPE;
  BEGIN
         SELECT NVL(C.GLB_CLIENTE_NACIONAL,'N')
           INTO V_NACIONAL
           FROM T_GLB_CLIENTE C
          WHERE C.GLB_CLIENTE_CGCCPFCODIGO = P_CNPJ;

           RETURN V_NACIONAL;

  END FN_CLI_NACIONAL;
  
  FUNCTION FN_CON_VALIDAENDERECOCLI(P_GLB_CLIENTE_CGCCPFCODIGO IN T_GLB_CLIEND.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                    P_GLB_TPCLIEND_CODIGO IN T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%TYPE)RETURN INTEGER IS
  V_LOCALIDADE INTEGER;
  BEGIN
       SELECT COUNT(*)
         INTO V_LOCALIDADE
         FROM T_GLB_CLIEND C,
              T_GLB_LOCALIDADE LO
        WHERE C.GLB_CLIENTE_CGCCPFCODIGO   = P_GLB_CLIENTE_CGCCPFCODIGO
          AND C.GLB_TPCLIEND_CODIGO        = P_GLB_TPCLIEND_CODIGO
          AND C.GLB_LOCALIDADE_CODIGO      = LO.GLB_LOCALIDADE_CODIGO
          AND UPPER(LO.GLB_ESTADO_CODIGO)  = UPPER(C.GLB_ESTADO_CODIGO)
          AND LO.GLB_LOCALIDADE_CODIGOIBGE IS NOT NULL;

          RETURN V_LOCALIDADE;
  END FN_CON_VALIDAENDERECOCLI;
  
   /***************************************************************************************************
  * ROTINA           : FN_VALIDA_CTECOL                                                              *
  * PROGRAMA         : VALIDA«AO DA COLETA                                                           *
  * ANALISTA         : Sirlano Sauro - SDRUMOND                                                      *
  * DESENVOLVEDOR    : Anderson F·bio- AFABIO                                                        *
  * DATA DE CRIACAO  : 12/04/2016                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL                                          *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : VERIFICAR SE A COLETA EXISTE E ESTA DE ACORDO COM O CONHECIMENTO              *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_CTRC, P_SERIE, P_ROTA                                                       *
  * RETORNOS         : FAC - Falta Coleta
  *                    REM - Remetente diferente da Coleta
  *                    DES - Destinatario diferente
  *                    LCC - Local de Coleta Diferente 
  *                    LCE - Local de Entrega Diferente 
  ****************************************************************************************************/
  FUNCTION FN_VALIDA_CTECOL(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) RETURN varchar2 AS

  vColeta        TDVADM.T_ARM_COLETA.ARM_COLETA_NCOMPRA%TYPE;
  vColetaCiclo   TDVADM.T_ARM_COLETA.ARM_COLETA_CICLO%TYPE;
  
  vRemetente     TDVADM.T_ARM_COLETA.GLB_CLIENTE_CGCCPFCODIGOCOLETA%TYPE;
  vDestinatario  TDVADM.T_ARM_COLETA.GLB_CLIENTE_CGCCPFCODIGOENTREG%TYPE;
  vLocalColeta   TDVADM.T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%TYPE;
  vLocalEntrega  TDVADM.T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%TYPE;
  vColEnt        TDVADM.T_ARM_COLETA.ARM_COLETA_ENTCOLETA%TYPE;
  
  vcRemetente     TDVADM.T_ARM_COLETA.GLB_CLIENTE_CGCCPFCODIGOCOLETA%TYPE;
  vcDestinatario  TDVADM.T_ARM_COLETA.GLB_CLIENTE_CGCCPFCODIGOENTREG%TYPE;
  vcLocalColeta   TDVADM.T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%TYPE;
  vcLocalEntrega  TDVADM.T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%TYPE;
  vcColEnt        TDVADM.T_ARM_COLETA.ARM_COLETA_ENTCOLETA%TYPE;
  vMensagem       varchar2(100);
  
    
  BEGIN
       SELECT C.ARM_COLETA_NCOMPRA,
              C.ARM_COLETA_CICLO,
              C.GLB_CLIENTE_CGCCPFREMETENTE,
              C.GLB_CLIENTE_CGCCPFDESTINATARIO,
              C.CON_CONHECIMENTO_LOCALCOLETA,
              C.CON_CONHECIMENTO_LOCALENTREGA
         INTO vColeta,
              vColetaCiclo,
              vRemetente,
              vDestinatario,
              vLocalColeta,
              vLocalEntrega
         FROM T_CON_CONHECIMENTO C
          WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
          AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
          AND C.GLB_ROTA_CODIGO         = P_ROTA;
       
       if( vColeta is null ) then
           return 'FAC';
       End if;
       SELECT C.ARM_COLETA_ENTCOLETA
          INTO
              vColEnt
          FROM T_ARM_COLETA C
           WHERE C.ARM_COLETA_NCOMPRA = vColeta
           AND   C.ARM_COLETA_CICLO = vColetaCiclo;

       SELECT C.Glb_Cliente_Cgccpfcodigocoleta,
              C.Glb_Cliente_Cgccpfcodigoentreg,
              cc.glb_localidade_codigo,
              ce.glb_localidade_codigo
          INTO
              vcRemetente,
              vcDestinatario,
              vcLocalColeta,
              vcLocalEntrega
          FROM T_ARM_COLETA C,
               t_glb_cliend cc,
               t_glb_cliend ce
           WHERE C.ARM_COLETA_NCOMPRA = vColeta
           AND   C.ARM_COLETA_CICLO = vColetaCiclo
           and c.glb_cliente_cgccpfcodigoentreg = ce.glb_cliente_cgccpfcodigo
           and c.glb_tpcliend_codigoentrega = ce.glb_tpcliend_codigo
           and c.glb_cliente_cgccpfcodigocoleta = cc.glb_cliente_cgccpfcodigo
           and c.glb_tpcliend_codigocoleta = cc.glb_tpcliend_codigo;
       
       if( vColEnt = 'E' ) Then
           select distinct 
               -- a.arm_armazem_codigo codarm,
               -- a.arm_armazem_descricao armazem,
               -- Quando for ENTREGA para definir a localidade de ORIGEM
               a.glb_localidade_codigo locarmazem -- con_conhecimento_localcoleta
           INTO
               vcLocalColeta           
           from t_con_conhecimento c,
               t_arm_armazem a
           where c.con_conhecimento_codigo = P_CTRC
               and c.con_conhecimento_serie =  P_SERIE
               and c.glb_rota_codigo =  P_ROTA
               and c.glb_rota_codigo = a.glb_rota_codigo;
       End If;
       
       
       
       if( vRemetente <> vcRemetente ) Then 
           vMensagem := 'REM' || CHR(10);
       end if;
       if( vDestinatario <> vcDestinatario ) Then 
           vMensagem := vMensagem || 'DES' || CHR(10);
       end if;
       if( vLocalColeta <> vcLocalColeta ) Then 
           vMensagem := vMensagem || 'LCC' || CHR(10);
       end if;
       if( vLocalEntrega <> vcLocalEntrega ) Then 
           vMensagem := vMensagem || 'LCE' || CHR(10);
       end if;
       
       if( nvl(vMensagem,'00') = '00' ) Then
           return 'OK';
       else
           return vMensagem;
       end if;
  
  END FN_VALIDA_CTECOL;
  
   /***************************************************************************************************
  * ROTINA           : FN_VALIDA_BXACOL                                                              *
  * PROGRAMA         : VALIDA«AO DA BAIXA DA COLETA                                                  *
  * ANALISTA         : Sirlano Sauro - SDRUMOND                                                      *
  * DESENVOLVEDOR    : Anderson F·bio- AFABIO                                                        *
  * DATA DE CRIACAO  : 12/04/2016                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL                                          *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : VERIFICAR SE A BAIXA NA COLETA OCORREU                                        *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_CTRC, P_SERIE, P_ROTA                                                       *
  ****************************************************************************************************/
  FUNCTION FN_VALIDA_BXACOL(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) RETURN BOOLEAN AS
  vCodOcorrencia T_ARM_COLETA.ARM_COLETAOCOR_CODIGO%TYPE;
  vFinalizaColeta   T_ARM_COLETAOCOR.ARM_COLETAOCOR_FINALIZA%TYPE;
  vStatus T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_STATUS%TYPE;
  vRetorno T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CODSTENV%TYPE;
  
  BEGIN


  SELECT 
         --C.CON_CONHECIMENTO_CODIGO, -- CONHECIMENTO
         --C.CON_CONHECIMENTO_SERIE, -- SERIE
         --C.GLB_ROTA_CODIGO, -- ROTA
         CO.ARM_COLETAOCOR_CODIGO, -- CODIGO DE OCORRENCIA DA COLETA N√O PODE SER NULO SE CODSTENV = 100
         nvl(oc.ARM_COLETAOCOR_FINALIZA,'N'), -- Indica se finaliza o Coleta ou n„o
         CTL.CON_CONTROLECTRCE_STATUS, -- TEM QUE SER OK
         CTL.CON_CONTROLECTRCE_CODSTENV -- CODIGO DE RETORNO DA SEFAZ
  INTO
         vCodOcorrencia,
         vFinalizaColeta,
         vStatus,
         vRetorno
  FROM T_CON_CONHECIMENTO C,
         T_ARM_COLETA CO,
         T_ARM_COLETAOCOR OC,
         T_CON_CONTROLECTRCE CTL
  WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
         AND C.CON_CONHECIMENTO_SERIE = P_SERIE
         AND C.GLB_ROTA_CODIGO = P_ROTA
         AND CO.ARM_COLETAOCOR_CODIGO = OC.ARM_COLETAOCOR_CODIGO (+)
         AND C.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA(+)
         AND C.ARM_COLETA_CICLO = CO.ARM_COLETA_CICLO(+)
         AND C.CON_CONHECIMENTO_CODIGO = CTL.CON_CONHECIMENTO_CODIGO(+)
         AND C.CON_CONHECIMENTO_SERIE = CTL.CON_CONHECIMENTO_SERIE(+)
         AND C.GLB_ROTA_CODIGO = CTL.GLB_ROTA_CODIGO(+);
  
  if(  nvl(vRetorno,'000') = '100' and vFinalizaColeta = 'S' ) Then
      return true;
      
  ElsIf vFinalizaColeta = 'S'  Then
      return True;
  else
      return false;
  end if;
  END FN_VALIDA_BXACOL;                                                        


    
  FUNCTION FN_CON_VALIDACEPCTE(P_CNPJ   IN T_GLB_CLIEND.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                               P_TP_END IN T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%TYPE)RETURN CHAR IS  
  /****************************************************************************************************
    * ROTINA           : FN_CON_VALIDACEPCTE                                                           *
    * PROGRAMA         : VALIDA CEP                                                                    *
    * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
    * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
    * DATA DE CRIACAO  : 20/03/2011                                                                    *
    * BANCO            : ORACLE-TDP                                                                    *
    * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL, COMPC, FIFO                             *
    * ALIMENTA         :                                                                               *
    * FUNCINALIDADE    : VALIDA O CEP DOS ENVOLVIDOS NO TRANSPORTE ANTE DA EMISS√O DO CTE              *
    * ATUALIZA         :                                                                               *
    * PARTICULARIDADES :                                                                               *                                           
    * PARAM. OBRIGAT.  : P_CNPJ , P_TP_END                                                *
    ****************************************************************************************************/
    
  V_CEP T_GLB_CLIEND.GLB_CEP_CODIGO %TYPE;
  BEGIN
       BEGIN
       
       SELECT CD.GLB_CEP_CODIGO
         INTO V_CEP
         FROM T_GLB_CLIEND CD
        WHERE CD.GLB_CLIENTE_CGCCPFCODIGO = P_CNPJ
          AND CD.GLB_TPCLIEND_CODIGO      = P_TP_END;
       
       EXCEPTION WHEN OTHERS THEN
       V_CEP:= '';
       END;     

        IF LENGTH(TRIM(V_CEP)) <> 8 THEN
          RETURN 'E';
        ELSE
          RETURN 'N';
        END IF;
  END FN_CON_VALIDACEPCTE;
  
  FUNCTION FN_CLI_VALIDAINTER(P_CLIENTE IN T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE, 
                              P_TIPO    IN T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%TYPE)RETURN VARCHAR2 IS
  V_PAIS T_GLB_PAIS.GLB_PAIS_CODIGO%TYPE;
  BEGIN

     BEGIN

     SELECT PA.GLB_PAIS_CODIGO
         INTO V_PAIS
         FROM T_GLB_CLIEND PA
        WHERE PA.GLB_CLIENTE_CGCCPFCODIGO = P_CLIENTE
          AND PA.GLB_TPCLIEND_CODIGO       = P_TIPO;

     EXCEPTION WHEN NO_DATA_FOUND THEN
         V_PAIS := 'BRA';
     END;

     IF TRIM(V_PAIS) = 'BRA' THEN
        RETURN 'N';
     ELSE
        RETURN 'S';
     END IF;
  END FN_CLI_VALIDAINTER;

  FUNCTION FN_CON_VALIDAIBGELOC(P_LOCALIDADE IN T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE)RETURN INTEGER IS
  V_QTDE INTEGER;
  BEGIN

       SELECT COUNT(*)
         INTO V_QTDE
         FROM T_GLB_LOCALIDADE L
        WHERE TRIM(L.GLB_LOCALIDADE_CODIGO) =  TRIM(P_LOCALIDADE)
          AND L.GLB_LOCALIDADE_CODIGOIBGE IS NOT NULL;
          
  RETURN V_QTDE;
  END FN_CON_VALIDAIBGELOC;

  FUNCTION FN_CON_DUPLICIDADENOTA(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                  P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                  P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN varchar2
     IS
     vChave tdvadm.t_con_nftransporta.con_nftransportada_chavenfe%Type; 
  Begin
     
       FOR R_NOTA IN (SELECT TR.CON_NFTRANSPORTADA_NUMNFISCAL,
                             TR.GLB_CLIENTE_CGCCPFCODIGO,
                             TR.CON_NFTRANSPORTADA_CHAVENFE,
                             TR.CON_TPDOC_CODIGO,
                             TR.GLB_CFOP_CODIGO
                        FROM T_CON_NFTRANSPORTA TR
                       WHERE TR.CON_CONHECIMENTO_CODIGO = P_CTE
                         AND TR.CON_CONHECIMENTO_SERIE  = P_SERIE
                         AND TR.GLB_ROTA_CODIGO         = P_ROTA)
       LOOP

          vChave := '';
       
       END LOOP;    
    
  End FN_CON_DUPLICIDADENOTA;
  
  FUNCTION FN_CON_ITTPV(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                        P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                        P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN INTEGER IS
                                        
  V_TOTALPREST T_CON_CALCCONHECIMENTO.CON_CALCVIAGEM_VALOR%TYPE;
  V_COMPLEMENTO INTEGER;
  vMessage Varchar2(30000);
  Begin
    Begin
      
      SELECT NVL(CAL.CON_CALCVIAGEM_VALOR,0)
        INTO V_TOTALPREST
      FROM T_CON_CALCCONHECIMENTO CAL
      WHERE CAL.CON_CONHECIMENTO_CODIGO = P_CTE
        AND CAL.CON_CONHECIMENTO_SERIE  = P_SERIE
        AND CAL.GLB_ROTA_CODIGO         = P_ROTA
        AND CAL.SLF_RECCUST_CODIGO = 'I_TTPV';
        
    Exception
      When no_data_found Then
        V_TOTALPREST := 0;
      
    End;  

    SELECT COUNT(*)
      INTO V_COMPLEMENTO
    FROM T_CON_CONHECCOMPLEMENTO COM
     WHERE COM.CON_CONHECIMENTO_CODIGO = P_CTE
       AND COM.CON_CONHECIMENTO_SERIE  = P_SERIE
       AND COM.GLB_ROTA_CODIGO         = P_ROTA;

    IF (V_TOTALPREST = 0) AND (V_COMPLEMENTO = 0) THEN
      RETURN  0;
    ELSE
      RETURN 1;
    END IF;
  END FN_CON_ITTPV;
  
  FUNCTION FN_CTE_VERIOBRICHAVENFE(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                  P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                  P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                  P_CFOP  IN T_GLB_CFOP.GLB_CFOP_CODIGO%TYPE)RETURN CHAR AS
 /****************************************************************************************************
  * ROTINA           : FN_CTE_VERIOBRICHAVENFE                                                       *
  * PROGRAMA         : FUN«√O PARA VERIFICAR A OBRIGATORIEDADE DE DIGITAR A CHAVE NFE NO CTE         *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 24/02/2011                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : SP_CON_VALIDACTE                                                              *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : FUN«√O PARA VERIFICAR A OBRIGATORIEDADE DE DIGITAR A CHAVE NFE NO CTE         *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_CTRC, P_SERIE, P_ROTA                                                       *
  ****************************************************************************************************/
  
V_UFREMET          T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
V_UFDEST           T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
V_LOCALORIGEM      T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
V_LOCALDESTINO     T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
V_CNPJREMET        T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
V_CNPJDEST         T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
V_UFLOCALORIGEM    T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
V_UFLOCALDESTINO   T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
vCfopLivreChaveNfe t_glb_cfop.glb_cfop_flagnfe%type;
BEGIN
     
     BEGIN
      SELECT L.GLB_CFOP_FLAGNFE
        INTO vCfopLivreChaveNfe
        FROM T_GLB_CFOP L
       WHERE L.GLB_CFOP_CODIGO = P_CFOP; 
     EXCEPTION WHEN OTHERS THEN
        vCfopLivreChaveNfe := 'S';
     END;    
         
     SELECT UPPER(CD.GLB_ESTADO_CODIGO),
            UPPER(CD2.GLB_ESTADO_CODIGO),
            C.GLB_LOCALIDADE_CODIGOORIGEM,
            C.GLB_LOCALIDADE_CODIGODESTINO,
            C.GLB_CLIENTE_CGCCPFREMETENTE,
            C.GLB_CLIENTE_CGCCPFDESTINATARIO
       INTO V_UFREMET,
            V_UFDEST,
            V_LOCALORIGEM, 
            V_LOCALDESTINO,
            V_CNPJREMET,
            V_CNPJDEST 
       FROM T_CON_CONHECIMENTO C,
            T_GLB_CLIEND CD,
            T_GLB_CLIEND CD2
       WHERE C.CON_CONHECIMENTO_CODIGO        = P_CTRC
         AND C.CON_CONHECIMENTO_SERIE         = P_SERIE
         AND C.GLB_ROTA_CODIGO                = P_ROTA
         AND C.GLB_CLIENTE_CGCCPFREMETENTE    = CD.GLB_CLIENTE_CGCCPFCODIGO
         AND C.GLB_TPCLIEND_CODIGOREMETENTE   = CD.GLB_TPCLIEND_CODIGO
         AND C.GLB_CLIENTE_CGCCPFDESTINATARIO = CD2.GLB_CLIENTE_CGCCPFCODIGO
         AND C.GLB_TPCLIEND_CODIGODESTINATARI = CD2.GLB_TPCLIEND_CODIGO;
   
     BEGIN
          SELECT UPPER(LO.GLB_ESTADO_CODIGO)
            INTO V_UFLOCALORIGEM
            FROM T_GLB_LOCALIDADE LO
           WHERE LO.GLB_LOCALIDADE_CODIGO = V_LOCALORIGEM;
     EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,'ERRO AO CONSULTAR LOCALIDADE.');
     END;    
  
     BEGIN   
          SELECT LO.GLB_ESTADO_CODIGO
            INTO V_UFLOCALDESTINO
            FROM T_GLB_LOCALIDADE LO
            WHERE LO.GLB_LOCALIDADE_CODIGO = V_LOCALDESTINO;          
     EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,'ERRO AO CONSULTAR LOCALIDADE.');
     END;
    
     IF P_ROTA IN ('461','161','188','033','028') THEN
        RETURN 'N';
     END IF; 
     
     IF FN_CLI_NACIONAL(V_CNPJREMET) = 'N' THEN   
     -- KLAYTON 11/04/2013
     --   IF V_UFREMET <> V_UFDEST THEN
       IF vCfopLivreChaveNfe = 'S' THEN
          RETURN 'S';
       ELSE
          RETURN 'N';
       END IF;
          
     ELSE
     
       --IF V_UFLOCALORIGEM <> V_UFLOCALDESTINO THEN
       IF vCfopLivreChaveNfe = 'S' THEN
           RETURN 'S';
       ELSE
           RETURN 'N';
       END IF;  
     
     END IF;  
   
END FN_CTE_VERIOBRICHAVENFE;

  FUNCTION FN_CTE_VALIDACHAVENFE(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                 P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                 P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                 P_MESSAGE OUT VARCHAR2) RETURN CHAR IS
  /***************************************************************************************************
  * ROTINA           : PKG_CON_CTE.FN_CTE_VALIDACHAVENFE                                                         *
  * PROGRAMA         : VALIDA«AO DA CHAVE DA NOTA                                                    *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 23/02/2010                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL, COMPC, FIFO                             *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : FAZ ALGUMAS VERIFICA«’ES NO CONHECIMENTO ANTES DA DUA EMISSAO                 *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_ROTA , P_SERIE  , P_ROTA                                                    *
  ****************************************************************************************************/
  V_ERRO    CHAR(1);
  vMessage  varchar2(2000);
  vCNPJLiberados tdvadm.t_usu_perfil.usu_perfil_parat%type;
  BEGIN
       V_ERRO:= 'N';
       FOR R_NOTA IN (SELECT TR.CON_NFTRANSPORTADA_NUMNFISCAL,
                             TR.GLB_CLIENTE_CGCCPFCODIGO,
                             TR.CON_NFTRANSPORTADA_CHAVENFE,
                             TR.CON_TPDOC_CODIGO,
                             TR.GLB_CFOP_CODIGO
                        FROM T_CON_NFTRANSPORTA TR
                       WHERE TR.CON_CONHECIMENTO_CODIGO = P_CTRC
                         AND TR.CON_CONHECIMENTO_SERIE  = P_SERIE
                         AND TR.GLB_ROTA_CODIGO         = P_ROTA)
       LOOP
           
           --if R_NOTA.CON_NFTRANSPORTADA_CHAVENFE NOT IN ('31130633592510003501550010000149411018262087') then
             
           IF R_NOTA.CON_TPDOC_CODIGO IN ('99','13') THEN
              V_ERRO  := '';
              RETURN V_ERRO;
           END IF;  
             
           if nvl(R_NOTA.GLB_CFOP_CODIGO,'NULL') = 'NULL' THEN
              V_ERRO   := 'E';
              vMessage := 'Cfop da nota: '||trim(R_NOTA.CON_NFTRANSPORTADA_NUMNFISCAL)||' do remetente: '||trim(R_NOTA.GLB_CLIENTE_CGCCPFCODIGO)||' N„o informado!';
           END IF;   
           
           IF nvl(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,'NULL') = 'NULL' THEN
              IF FN_CTE_VERIOBRICHAVENFE(P_CTRC, P_SERIE, P_ROTA,R_NOTA.GLB_CFOP_CODIGO) = 'S' THEN
                 V_ERRO   := 'E';
                 vMessage := 'Chave Nfe n„o foi informada!';
              END IF;
           END IF;   
           
           IF (TRIM(R_NOTA.GLB_CLIENTE_CGCCPFCODIGO) <> SUBSTR(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,7,14)) AND (FN_CLI_NACIONAL(R_NOTA.GLB_CLIENTE_CGCCPFCODIGO) = 'N') THEN
             IF FN_CTE_VERIOBRICHAVENFE(P_CTRC, P_SERIE, P_ROTA,R_NOTA.GLB_CFOP_CODIGO) = 'S' THEN

                select p.usu_perfil_parat
                  into vCNPJLiberados
                from tdvadm.t_usu_perfil p
                where p.usu_perfil_codigo = 'CNPJSEFAZ';
                
                If instr(vCNPJLiberados,SUBSTR(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,7,14)) = 0 Then
                    V_ERRO   := 'E';
                    vMessage := 'Nfe n„o pertence ao remetente do conhecimento!';
                End If;
              END IF;
           END IF;
           
           IF LENGTH(TRIM(NVL(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,0)))<> 44 /*AND (FN_CLI_NACIONAL(R_NOTA.GLB_CLIENTE_CGCCPFCODIGO) = 'N')*/ THEN
              IF FN_CTE_VERIOBRICHAVENFE(P_CTRC, P_SERIE, P_ROTA, R_NOTA.GLB_CFOP_CODIGO) = 'S' THEN
                 V_ERRO   := 'E';
                 vMessage := 'Chave Nfe n„o possue 44 posiÁıes!';
              END IF;
           END IF;
           

           IF NVL(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,'0') <> '0' THEN
             
             IF F_DIGCONTROLEMODCTE(SUBSTR(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,1,43)) <> SUBSTR(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,-1) THEN
                   V_ERRO   := 'E';
                   vMessage := 'Digito verificador da Nfe n„o confere!';   
             END IF;
           
           END IF;
           
           
           IF TRIM(R_NOTA.CON_NFTRANSPORTADA_NUMNFISCAL) <> SUBSTR(R_NOTA.CON_NFTRANSPORTADA_CHAVENFE,26,9) THEN
              IF FN_CTE_VERIOBRICHAVENFE(P_CTRC, P_SERIE, P_ROTA, R_NOTA.GLB_CFOP_CODIGO) = 'S' THEN
                 V_ERRO   := 'E';
                 vMessage := 'Chave Nfe n„o pertence a essa nota.!';
              END IF;
           END IF;
           
          -- end if;
  
       END LOOP;
       
       
       FOR R_NOTA IN (SELECT TR.CON_NFTRANSPORTADA_NUMNFISCAL,
                             TR.GLB_CLIENTE_CGCCPFCODIGO,
                             count(*) qtde
                      FROM T_CON_NFTRANSPORTA TR
                      WHERE TR.CON_CONHECIMENTO_CODIGO = P_CTRC
                        AND TR.CON_CONHECIMENTO_SERIE  = P_SERIE
                        AND TR.GLB_ROTA_CODIGO         = P_ROTA
                      group by TR.CON_NFTRANSPORTADA_NUMNFISCAL,
                               TR.GLB_CLIENTE_CGCCPFCODIGO
                       having count(*) > 1)
       
       LOOP
            
          V_ERRO   := 'E';
          vMessage := vMessage || 'Nfe-Qtde-' || R_NOTA.CON_NFTRANSPORTADA_NUMNFISCAL || '-(' || to_char(R_NOTA.QTDE) || ')/' ;
       
         
       END LOOP;
       
       P_MESSAGE := vMessage; 
       
       RETURN V_ERRO;
  END FN_CTE_VALIDACHAVENFE;
  
  FUNCTION FN_CON_VALIDALOCALCOLETA(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR IS
 /****************************************************************************************************
  * ROTINA           : PKG_CON_CTE.FN_CON_VALIDALOCALCOLETA                                                      *
  * PROGRAMA         : VALIDA LOCAL COLETA                                                           *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 21/03/2011                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL, COMPC, FIFO                             *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : VALIDA O LOCAL DE COLETA                                                      *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_CTRC , P_SERIE , P_ROTA                                                     *
  ****************************************************************************************************/
  V_IBGEREMET        T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGOIBGE%TYPE;
  V_IBGEOCOLETA      T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGOIBGE%TYPE;
  V_IBGELOCALCOLETA  T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGOIBGE%TYPE;
  V_LOCALCOLETA      INTEGER;
  V_CNPJ_REMET       T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  V_CLI_NACIONAL     T_GLB_CLIENTE.GLB_CLIENTE_NACIONAL%TYPE;

  BEGIN
       -- PEGO O IBGE DE COLETA, DO DESTINATARIO, E O CNPJ DO REMETENTE
       BEGIN
            SELECT (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                      FROM T_GLB_LOCALIDADE LO
                      WHERE LO.GLB_LOCALIDADE_CODIGO = C.CON_CONHECIMENTO_LOCALCOLETA) ORIGEM,
                   (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                     FROM T_GLB_CLIEND CD,
                          T_GLB_LOCALIDADE LO
                     WHERE CD.GLB_CLIENTE_CGCCPFCODIGO = C.GLB_CLIENTE_CGCCPFREMETENTE
                       AND CD.GLB_TPCLIEND_CODIGO      = C.GLB_TPCLIEND_CODIGOREMETENTE
                       AND CD.GLB_LOCALIDADE_CODIGO    = LO.GLB_LOCALIDADE_CODIGO) REMET,
                   C.GLB_CLIENTE_CGCCPFREMETENTE    
              INTO V_IBGEOCOLETA,
                   V_IBGEREMET,
                   V_CNPJ_REMET
              FROM T_CON_CONHECIMENTO C
             WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
               AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
               AND C.GLB_ROTA_CODIGO         = P_ROTA;
       EXCEPTION WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR CTE. ERRO= '||SQLERRM);
       END;     

       -- VERIFICO SE O CLIENTE … INTERNACIOPNAL OU NACIONAL 
       V_CLI_NACIONAL := NVL(FN_CLI_NACIONAL(V_CNPJ_REMET),'N'); 
        
       -- SE NACIONAL 
       IF V_CLI_NACIONAL = 'N' THEN
         
          -- SE LOCAIS DE COLETA / REMETENTE <> FA«O A VALIDA«√O
          IF V_IBGEOCOLETA <> V_IBGEREMET THEN
              -- VEJO SE O FOI GRAVADO O TIPO DE ENDERE«O PARA A COLETA
              BEGIN
                   -- V_CTE_12121_ OLHA O CONCEITO ANTIGO "T_CON_CONSIGREDEPACHO" E CONCEITO NOVO "T_ARM_COLETAPARCEIRO"   
                   SELECT COUNT(*)
                   INTO V_LOCALCOLETA
                   FROM V_CTE_12121_ R
                  WHERE R.CON_CONHECIMENTO_CODIGO     = P_CTRC
                    AND R.CON_CONHECIMENTO_SERIE      = P_SERIE
                    AND R.GLB_ROTA_CODIGO             = P_ROTA;
                    
             EXCEPTION WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR LOCAL COLETA. ERRO= '||SQLERRM);
             END;    

                -- SE EXISTE VERIFICO SE … VALIDO / SE N√O EXISTE ENTENDO QUE N√O … VALIDO
                IF V_LOCALCOLETA > 0 THEN
                    
                    -- PEGO O IBGE CADASTRADO NO LOCAL DA COLETA.
                    BEGIN
                         SELECT (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                                   FROM T_GLB_CLIEND CD,
                                        T_GLB_LOCALIDADE LO
                                   WHERE CD.GLB_CLIENTE_CGCCPFCODIGO = R.CNPJ
                                     AND CD.GLB_TPCLIEND_CODIGO      = R.GLB_TPCLIEND_CODIGO
                                     AND CD.GLB_LOCALIDADE_CODIGO    = LO.GLB_LOCALIDADE_CODIGO)
                           INTO V_IBGELOCALCOLETA
                           FROM V_CTE_12121_ R
                          WHERE R.CON_CONHECIMENTO_CODIGO = P_CTRC
                            AND R.CON_CONHECIMENTO_SERIE = P_SERIE
                            AND R.GLB_ROTA_CODIGO = P_ROTA;
                     EXCEPTION WHEN OTHERS THEN
                       RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR LOCAL COLETA. ERRO= '||SQLERRM);   
                     END;    
                    
                    -- SE FOI CADASTRADA UM LOCAL DE COLETA COM O MESMO IBGE DO REMETENTE N√O UM LOCAL DE COLETA VALIDO
                    IF V_IBGELOCALCOLETA = V_IBGEOCOLETA THEN
                      RETURN 'E';
                    ELSE
                      RETURN 'N';
                    END IF;
                ELSE
                  RETURN 'E';
                END IF;
          ELSE
              RETURN 'S';
          END IF;
       
       ELSE
          
          BEGIN
               -- VERIFICO SE FOI DIGITADO UM LOCAL DE COLETA
               -- V_CTE_12121_ OLHA O CONCEITO ANTIGO "T_CON_CONSIGREDEPACHO" E CONCEITO NOVO "T_ARM_COLETAPARCEIRO"
               SELECT COUNT(*)
                 INTO V_LOCALCOLETA
                 FROM V_CTE_12121_ R
                WHERE R.CON_CONHECIMENTO_CODIGO     = P_CTRC
                  AND R.CON_CONHECIMENTO_SERIE      = P_SERIE
                  AND R.GLB_ROTA_CODIGO             = P_ROTA;
          EXCEPTION WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR LOCAL COLETA. ERRO= '||SQLERRM);
          END;

          IF V_LOCALCOLETA > 0 THEN
             SELECT (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                       FROM T_GLB_CLIEND CD,
                            T_GLB_LOCALIDADE LO
                       WHERE CD.GLB_CLIENTE_CGCCPFCODIGO = R.CNPJ
                         AND CD.GLB_TPCLIEND_CODIGO      = R.GLB_TPCLIEND_CODIGO
                         AND CD.GLB_LOCALIDADE_CODIGO    = LO.GLB_LOCALIDADE_CODIGO)
               INTO V_IBGELOCALCOLETA
               FROM V_CTE_12121_ R
              WHERE R.CON_CONHECIMENTO_CODIGO = P_CTRC
                AND R.CON_CONHECIMENTO_SERIE  = P_SERIE
                AND R.GLB_ROTA_CODIGO         = P_ROTA;
                    
             IF V_IBGELOCALCOLETA = V_IBGEOCOLETA THEN
                RETURN 'E';
             ELSE
                RETURN 'N';
             END IF;
                    
          ELSE
            RETURN 'E';
          END IF;
          
       END IF;  

  END FN_CON_VALIDALOCALCOLETA;
  
  FUNCTION FN_CON_VALIDALOCALENTREGA(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                     P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                     P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR IS
 /****************************************************************************************************
  * ROTINA           : PKG_CON_CTE.FN_CON_VALIDALOCALENTREGA                                                     *
  * PROGRAMA         : VALIDA LOCAL COLETA                                                           *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 22/03/2011                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL, COMPC, FIFO                             *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : VALIDA O LOCAL DE ENTREGA                                                     *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *
  * PARAM. OBRIGAT.  : P_CTRC , P_SERIE , P_ROTA                                                     *
  ****************************************************************************************************/
  V_IBGEDEST           T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGOIBGE%TYPE;
  V_IBGEENTREGA        T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGOIBGE%TYPE;
  V_IBGELOCALENTREGA   T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGOIBGE%TYPE;
  V_LOCALENTREGA       INTEGER;
  V_CNPJ_DEST          T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  V_CLI_NACIONAL       T_GLB_CLIENTE.GLB_CLIENTE_NACIONAL%TYPE;

  BEGIN
       -- PEGO O IBGE DE COLETA, DO DESTINATARIO, E O CNPJ DO REMETENTE
       BEGIN
            SELECT (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                      FROM T_GLB_LOCALIDADE LO
                      WHERE LO.GLB_LOCALIDADE_CODIGO = C.CON_CONHECIMENTO_LOCALENTREGA) ORIGEM,
                   (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                     FROM T_GLB_CLIEND CD,
                          T_GLB_LOCALIDADE LO
                     WHERE CD.GLB_CLIENTE_CGCCPFCODIGO = C.GLB_CLIENTE_CGCCPFDESTINATARIO
                       AND CD.GLB_TPCLIEND_CODIGO      = C.GLB_TPCLIEND_CODIGODESTINATARI
                       AND CD.GLB_LOCALIDADE_CODIGO    = LO.GLB_LOCALIDADE_CODIGO) REMET,
                   C.GLB_CLIENTE_CGCCPFREMETENTE
              INTO V_IBGEENTREGA,
                   V_IBGEDEST,
                   V_CNPJ_DEST
              FROM T_CON_CONHECIMENTO C
             WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
               AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
               AND C.GLB_ROTA_CODIGO         = P_ROTA;
       EXCEPTION WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR CTE. ERRO= '||SQLERRM);
       END;

       -- VERIFICO SE O CLIENTE … INTERNACIOPNAL OU NACIONAL
       V_CLI_NACIONAL := NVL(FN_CLI_NACIONAL(V_CNPJ_DEST),'N');

       -- SE NACIONAL
       IF V_CLI_NACIONAL = 'N' THEN
          -- SE LOCAIS DE COLETA / REMETENTE <> FA«O A VALIDA«√O
          IF V_IBGEENTREGA <> V_IBGEDEST THEN
              -- VEJO SE O FOI GRAVADO O TIPO DE ENDERE«O PARA A COLETA
             BEGIN
                  SELECT COUNT(*)
                    INTO V_LOCALENTREGA
                    FROM V_CTE_12420 R
                   WHERE R.CON_CONHECIMENTO_CODIGO     = P_CTRC
                     AND R.CON_CONHECIMENTO_SERIE      = P_SERIE
                     AND R.GLB_ROTA_CODIGO             = P_ROTA;
             EXCEPTION WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR LOCAL COLETA. ERRO= '||SQLERRM);
             END;

             -- SE EXISTE VERIFICO SE … VALIDO / SE N√O EXISTE ENTENDO QUE N√O … VALIDO
             IF V_LOCALENTREGA > 0 THEN

                -- PEGO O IBGE CADASTRADO NO LOCAL DA COLETA.
                BEGIN
                     SELECT (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                               FROM T_GLB_CLIEND CD,
                                    T_GLB_LOCALIDADE LO
                               WHERE CD.GLB_CLIENTE_CGCCPFCODIGO = R.CNPJ
                                 AND CD.GLB_TPCLIEND_CODIGO      = R.GLB_TPCLIEND_CODIGO
                                 AND CD.GLB_LOCALIDADE_CODIGO    = LO.GLB_LOCALIDADE_CODIGO)
                       INTO V_IBGELOCALENTREGA
                       FROM V_CTE_12420 R
                      WHERE R.CON_CONHECIMENTO_CODIGO = P_CTRC
                        AND R.CON_CONHECIMENTO_SERIE = P_SERIE
                        AND R.GLB_ROTA_CODIGO = P_ROTA;
                 EXCEPTION WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR LOCAL COLETA. ERRO= '||SQLERRM);
                 END;

                -- SE FOI CADASTRADA UM LOCAL DE COLETA COM O MESMO IBGE DO REMETENTE N√O UM LOCAL DE COLETA VALIDO
                IF V_IBGELOCALENTREGA = V_IBGEENTREGA THEN
                  RETURN 'E';
                ELSE
                  RETURN 'N';
                END IF;
              ELSE
                  RETURN 'E';
              END IF;
          ELSE
              RETURN 'S';
          END IF;

       ELSE
          BEGIN
                   SELECT COUNT(*)
                   INTO V_LOCALENTREGA
                   FROM V_CTE_12420 R
                  WHERE R.CON_CONHECIMENTO_CODIGO     = P_CTRC
                    AND R.CON_CONHECIMENTO_SERIE      = P_SERIE
                    AND R.GLB_ROTA_CODIGO             = P_ROTA;
             EXCEPTION WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20001, 'ERRO AO CONULTAR LOCAL COLETA. ERRO= '||SQLERRM);
             END;

                IF V_LOCALENTREGA > 0 THEN
                    SELECT (SELECT LO.GLB_LOCALIDADE_CODIGOIBGE
                              FROM T_GLB_CLIEND CD,
                                   T_GLB_LOCALIDADE LO
                              WHERE CD.GLB_CLIENTE_CGCCPFCODIGO = R.CNPJ
                                AND CD.GLB_TPCLIEND_CODIGO      = R.GLB_TPCLIEND_CODIGO
                                AND CD.GLB_LOCALIDADE_CODIGO    = LO.GLB_LOCALIDADE_CODIGO)
                      INTO V_IBGELOCALENTREGA
                      FROM V_CTE_12420 R
                     WHERE R.CON_CONHECIMENTO_CODIGO = P_CTRC
                       AND R.CON_CONHECIMENTO_SERIE  = P_SERIE
                       AND R.GLB_ROTA_CODIGO         = P_ROTA;
                    IF V_IBGELOCALENTREGA = V_IBGEENTREGA THEN
                      RETURN 'E';
                    ELSE
                      RETURN 'N';
                    END IF;
                ELSE
                  RETURN 'E';
                END IF;
       END IF;

  END FN_CON_VALIDALOCALENTREGA;
                                 
  FUNCTION FN_CON_RETORNAOBSEMISSOR(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN VARCHAR2 AS
  vExisteG20 INTEGER;
  BEGIN
  
       SELECT COUNT(*)
         INTO vExisteG20
         FROM T_CON_CONHECIMENTO CH,
              T_GLB_CLIENTE K
        WHERE CH.CON_CONHECIMENTO_CODIGO  = P_CTRC
          AND CH.CON_CONHECIMENTO_SERIE   = P_SERIE
          AND CH.GLB_ROTA_CODIGO          = P_ROTA
          AND CH.GLB_CLIENTE_CGCCPFSACADO = K.GLB_CLIENTE_CGCCPFCODIGO
          AND K.GLB_GRUPOECONOMICO_CODIGO = '0020';
       
       IF vExisteG20 > 0 THEN
          RETURN 'Comprovante de entrega, solicitamos que o mesmo retorne carimbado e assinado frente e verso.'; 
       ELSE
          RETURN '';
       END IF;     
    
  END FN_CON_RETORNAOBSEMISSOR;                                  
    
  PROCEDURE SP_CON_CTECOMPLEMENTO(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                  P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                  P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                  P_ERRO    OUT VARCHAR2,
                                  P_MESSAGE OUT VARCHAR2)AS
  /***************************************************************************************************
  * ROTINA           : PKG_CON_CTE.SP_CON_CTECOMPLEMENTO                                             *
  * PROGRAMA         : VALIDA«AO DO CTE ANTES DE SUA EMISS√O                                         *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 06/05/2011                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL, COMPC, FIFO                             *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : VALIDA UM CTE DE COMPLEMENTO                                                  *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_ROTA , P_SERIE  , P_ROTA                                                    *
  ****************************************************************************************************/
  -- VARIAVEIS LOCAIS
  V_EXISTE_COMP INTEGER;
  V_AUTORIZADO  T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CODSTENV%TYPE;   
  BEGIN
       BEGIN
            SELECT COUNT(*)
              INTO V_EXISTE_COMP
              FROM T_CON_CONHECCOMPLEMENTO C
             WHERE C.CON_CONHECIMENTO_CODIGO = P_CTE
               AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
               AND C.GLB_ROTA_CODIGO         = P_ROTA;
       EXCEPTION WHEN OTHERS THEN
         V_EXISTE_COMP := 0;
       END;
       
       IF V_EXISTE_COMP > 0 THEN
          
          FOR C_COMPLEMENTO IN (SELECT CC.CON_CONHECIMENTO_CODIGO,
                                       CC.CON_CONHECIMENTO_SERIE,
                                       CC.GLB_ROTA_CODIGO,
                                       LO1.GLB_ESTADO_CODIGO UF_ORI_COMP,
                                       LO2.GLB_ESTADO_CODIGO UF_DETS_COMP,
                                       CH1.GLB_CLIENTE_CGCCPFSACADO SAC_COMP,
                                       CC.CON_CONHECIMENTO_CODIGOORIGEM,
                                       CC.CON_CONHECIMENTO_SERIEORIGEM,
                                       CC.GLB_ROTA_CODIGOORIGEM,
                                       LO3.GLB_ESTADO_CODIGO UF_ORI_CTE,
                                       LO4.GLB_ESTADO_CODIGO UF_DETS_CTE,
                                       CH1.GLB_CLIENTE_CGCCPFSACADO SAC_CTE
                                  FROM T_CON_CONHECCOMPLEMENTO  CC,
                                       T_CON_CONHECIMENTO      CH1,
                                       T_CON_CONHECIMENTO      CH2,
                                       T_GLB_LOCALIDADE        LO1,
                                       T_GLB_LOCALIDADE        LO2,
                                       T_GLB_LOCALIDADE        LO3,
                                       T_GLB_LOCALIDADE        LO4
                                 WHERE CC.CON_CONHECIMENTO_CODIGO       = P_CTE
                                   AND CC.CON_CONHECIMENTO_SERIE        = P_SERIE
                                   AND CC.GLB_ROTA_CODIGO               = P_ROTA
                                   AND CC.CON_CONHECIMENTO_CODIGO       = CH1.CON_CONHECIMENTO_CODIGO
                                   AND CC.CON_CONHECIMENTO_SERIE        = CH1.CON_CONHECIMENTO_SERIE
                                   AND CC.GLB_ROTA_CODIGO               = CH1.GLB_ROTA_CODIGO
                                   AND CC.CON_CONHECIMENTO_CODIGOORIGEM = CH2.CON_CONHECIMENTO_CODIGO
                                   AND CC.CON_CONHECIMENTO_SERIEORIGEM  = CH2.CON_CONHECIMENTO_SERIE
                                   AND CC.GLB_ROTA_CODIGOORIGEM         = CH2.GLB_ROTA_CODIGO
                                   AND CH1.GLB_LOCALIDADE_CODIGOORIGEM  = LO1.GLB_LOCALIDADE_CODIGO 
                                   AND CH1.GLB_LOCALIDADE_CODIGODESTINO = LO2.GLB_LOCALIDADE_CODIGO
                                   AND CH2.GLB_LOCALIDADE_CODIGOORIGEM  = LO3.GLB_LOCALIDADE_CODIGO 
                                   AND CH2.GLB_LOCALIDADE_CODIGODESTINO = LO4.GLB_LOCALIDADE_CODIGO)
          LOOP
            BEGIN
              SELECT NVL(C.CON_CONTROLECTRCE_CODSTENV,999)
                INTO V_AUTORIZADO
                FROM T_CON_CONTROLECTRCE C
               WHERE C.CON_CONHECIMENTO_CODIGO = C_COMPLEMENTO.CON_CONHECIMENTO_CODIGOORIGEM
                 AND C.CON_CONHECIMENTO_SERIE  = C_COMPLEMENTO.CON_CONHECIMENTO_SERIEORIGEM
                 AND C.GLB_ROTA_CODIGO         = C_COMPLEMENTO.GLB_ROTA_CODIGOORIGEM;
            EXCEPTION WHEN NO_DATA_FOUND THEN
             P_ERRO    := 'E'; 
             P_MESSAGE := 'CTE COMPLEMENTADO N√O EXISTE, FAVOR VERIFIQUE.';
             RETURN; 
            END;     
            
            IF V_AUTORIZADO <> '100' THEN
               P_ERRO    := 'E'; 
               P_MESSAGE := 'CTE COMPLEMENTADO N√O FOI ACEITO, FAVOR VERIFIQUE.';
               RETURN;
            ELSE
                IF (C_COMPLEMENTO.UF_ORI_COMP <> C_COMPLEMENTO.UF_ORI_CTE) OR (C_COMPLEMENTO.UF_DETS_COMP <> C_COMPLEMENTO.UF_DETS_CTE) THEN
                   P_ERRO    := 'E'; 
                   P_MESSAGE := 'UF DE ORIGEM OU DESTINO DO CTE COMPLEMENTO … DIFERENTE DO CTE COMPLEMENTADO.';   
                END IF;
                
                IF C_COMPLEMENTO.SAC_COMP <> C_COMPLEMENTO.SAC_CTE THEN
                   P_ERRO    := 'E'; 
                   
                   SELECT TRIM(P_MESSAGE)||DECODE(LENGTH(TRIM(P_MESSAGE)),0,'',CHR(13))||'SACADO CO CTE COMPLEMENTO DIFERENTE DO SACADO DO CTE COMPLEMENTADO.'
                     INTO P_MESSAGE
                     FROM DUAL;
                   
                   RETURN; 
                END IF;        
            END IF;                       
          END LOOP;                                     
       END IF;
       
       P_ERRO    := 'N';           
       P_MESSAGE := 'PROCESSAMENTO NORMAL';     
              
  END SP_CON_CTECOMPLEMENTO;                                 
                                                                                                  
  PROCEDURE SP_CON_VALIDACTE(P_CTRC     IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                             P_SERIE    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                             P_ROTA     IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                             P_ERRO     OUT VARCHAR2,
                             P_MENSAGEM OUT VARCHAR2) AS
 /****************************************************************************************************
  * ROTINA           : SP_CON_VALIDACTE                                                              *
  * PROGRAMA         : VALIDA«AO DO CTE ANTES DE SUA EMISS√O                                         *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 17/12/2010                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL, COMPC, FIFO                             *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : FAZ ALGUMAS VERIFICA«’ES NO CONHECIMENTO ANTES DA SUA EMISSAO                 *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_ROTA , P_SERIE  , P_ROTA                                                    *
  ****************************************************************************************************/
                                                                                          
  V_CLIVALIDO      CHAR(1);
  V_LOCALORIGEM    INTEGER;
  V_LOCALDESTINO   INTEGER;
  V_LOCALCOLETA    INTEGER;
  V_LOCALENTREGA   INTEGER;
  V_RNTRC          CHAR(14);
  V_UF             T_GLB_ROTA.GLB_ESTADO_CODIGO%TYPE;
  V_CNPJPROP       T_CAR_CARRETEIRO.CAR_CARRETEIRO_CPFCODIGO%TYPE;
  V_IEPROP         T_GLB_CLIENTE.GLB_CLIENTE_IE%TYPE;
  
  V_ERRO           VARCHAR2(1);
  V_MESAGEM        VARCHAR2(32000);
  
  V_ERRORT         VARCHAR2(1);
  V_MESAGEMRT      VARCHAR2(32000);
  
  V_UF_INI         T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
  V_UF_FIM         T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;  
  vCnpjProp        t_car_proprietario.car_proprietario_cgccpfcodigo%type;
  vExisteTipoE     integer; 
  vExisteImp       integer;   
  vTpFormulario    varchar(20);  
  vAuxiliarT       varchar2(50);       
  vAuxiliarC       number;
  vGrupoSac        tdvadm.t_glb_cliente.glb_grupoeconomico_codigo%type;
  vTpCte           varchar2(10);
  vStatus          char(1);
  vMessage         varchar2(2000);
   
BEGIN
     V_CLIVALIDO := '';
     P_ERRO      := 'N';
     P_MENSAGEM  := '';
     
     
     SELECT NVL(CC.GLB_GRUPOECONOMICO_CODIGO,'9999')
       INTO vGrupoSac
       FROM TDVADM.T_CON_CONHECIMENTO CH,
            TDVADM.t_glb_cliente cc
      WHERE CH.CON_CONHECIMENTO_CODIGO  = P_CTRC
        AND CH.CON_CONHECIMENTO_SERIE   = P_SERIE
        AND CH.GLB_ROTA_CODIGO          = P_ROTA
        AND CH.GLB_CLIENTE_CGCCPFSACADO = CC.GLB_CLIENTE_CGCCPFCODIGO;
     
     
    /* IF (vGrupoSac = '0020') THEN
       
       begin
         vTpCte := 'F';
         
      -- TDVADM.PKG_CON_CTE.Sp_Cte_GetTipoFreteCte(P_CTRC, P_SERIE, P_ROTA, vTpCte, vStatus, vMessage);
       
       exception when others then
         vTpCte := 'F';
       end;  
       
       
       if (vTpCte = 'F') then 
         P_ERRO      := 'E';
         P_MENSAGEM  := 'Emiss„o de CTe desabilitada temporariamente para sacados do grupo 0020 Vale, procure o Faturamento. !!';
         
         return;
       
       end if;
       
     END IF;*/

      
     BEGIN
          -- VALIDA«√O DA ROTA DO CTE
          SP_CON_VALIDAROTACTE(P_ROTA,V_ERRORT,V_MESAGEMRT);
          
     EXCEPTION
     WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20001, 'ERRO AO VALIDAR ROTA DE CTE! ERRO: '||SQLERRM);
     END;
     
     

     -- Valida o tipo de Calculo para ver se È CTe ou NFS(e)
     IF FN_CTE_CONFIRMAIMPOSTOS(P_CTRC,P_SERIE,P_ROTA) <> 'C' THEN
        P_ERRO := 'E';     
        P_MENSAGEM := TRIM(P_MENSAGEM)||CHR(13)||'N„o foi usado calculo de ICMS! Verificar Calcula da Solicitacao/Tabela';
     End If;  
       
     FOR C_CURSOR IN (SELECT CH.CON_CONHECIMENTO_CODIGO        ,
                             CH.CON_CONHECIMENTO_SERIE         ,
                             CH.GLB_ROTA_CODIGO                ,
                             CH.GLB_CLIENTE_CGCCPFREMETENTE    ,
                             CH.GLB_TPCLIEND_CODIGOREMETENTE   ,
                             CH.GLB_CLIENTE_CGCCPFDESTINATARIO ,
                             CH.GLB_TPCLIEND_CODIGODESTINATARI ,
                             CH.GLB_CLIENTE_CGCCPFSACADO       ,
                             CH.GLB_LOCALIDADE_CODIGOORIGEM    ,
                             CH.GLB_LOCALIDADE_CODIGODESTINO   ,
                             CH.CON_CONHECIMENTO_LOCALCOLETA   ,
                             CH.CON_CONHECIMENTO_LOCALENTREGA  ,
                             CH.CON_CONHECIMENTO_PLACA         ,
                             cf.con_conheccfop_codigo CON_CONHECIMENTO_CFO ,
                             CH.ARM_COLETA_NCOMPRA 
                    FROM TDVADM.T_CON_CONHECIMENTO CH,
                         tdvadm.t_con_conheccfop cf
                    WHERE CH.CON_CONHECIMENTO_CODIGO = P_CTRC
                      AND CH.CON_CONHECIMENTO_SERIE  = P_SERIE
                      AND CH.GLB_ROTA_CODIGO         = P_ROTA
                      and CH.CON_CONHECIMENTO_CODIGO = CF.CON_CONHECIMENTO_CODIGO
                      AND CH.CON_CONHECIMENTO_SERIE  = CF.CON_CONHECIMENTO_SERIE
                      AND CH.GLB_ROTA_CODIGO         = CF.GLB_ROTA_CODIGO)
     LOOP
     
       
       -- VICULA«√O DE NOTAS DO CONHEC COMPLEMENTAR
       SP_CON_CTECOMNF(P_CTRC,P_SERIE,P_ROTA, P_ERRO, P_MENSAGEM);
       
       
       IF TRIM(P_ERRO) = 'N' THEN
          
          P_ERRO     := 'N';
          P_MENSAGEM := '';  
       
       END IF;  
       
       -- VALIDA«√O DO ENDERE«O DO REMETENTE   
       BEGIN 
            IF FN_CLI_NACIONAL(C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE) = 'N' THEN
               IF FN_CON_VALIDAENDERECOCLI(C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE, C_CURSOR.GLB_TPCLIEND_CODIGOREMETENTE) = 0 THEN
                  P_ERRO := 'E';
                  P_MENSAGEM  := TRIM(P_MENSAGEM)||CHR(13)||'PROBLEMA NA LOCALIDADE DO REMETENTE, VERIFIQUE O TIPO DE ENDERE«O "'||C_CURSOR.GLB_TPCLIEND_CODIGOREMETENTE||'" DO CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE;
               END IF;
               
               IF FN_CON_VALIDACEPCTE(C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE, C_CURSOR.GLB_TPCLIEND_CODIGOREMETENTE) = 'E' THEN
                  P_ERRO      := 'E';
                  P_MENSAGEM  := TRIM(P_MENSAGEM)||CHR(13)||'PROBLEMA NO CADASTRO DO REMETENTE, VERIFIQUE O CEP CADASTRADO NO TIPO DE ENDERE«O "'||C_CURSOR.GLB_TPCLIEND_CODIGOREMETENTE||'" DO CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE;
               END IF; 
                
            ELSE
               IF FN_CLI_VALIDAINTER(C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE, C_CURSOR.GLB_TPCLIEND_CODIGOREMETENTE) = 'N' THEN
                  P_ERRO:= 'E';
                  P_MENSAGEM  := TRIM(P_MENSAGEM)||CHR(13)||'PROBLEMA NO CADASTRO DO REMETENTE, VERIFIQUE O PAIS CADASTRADO PARA O CLIENTE INTERNACIONAL COM O CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE || 'TIPO DE ENDERE«O DO REMETENTE: '||C_CURSOR.GLB_TPCLIEND_CODIGOREMETENTE;
               END IF; 
            END IF;
       END;
       
       -- VALIDA«√O DO ENDERE«O DO DESTINAT¡RIO
       BEGIN
            IF FN_CLI_NACIONAL(C_CURSOR.GLB_CLIENTE_CGCCPFDESTINATARIO) = 'N' THEN
               IF FN_CON_VALIDAENDERECOCLI(C_CURSOR.GLB_CLIENTE_CGCCPFDESTINATARIO, C_CURSOR.GLB_TPCLIEND_CODIGODESTINATARI) = 0 THEN
                  P_ERRO      := 'E';
                  P_MENSAGEM  := TRIM(P_MENSAGEM)||CHR(13)||'PROBLEMA NO CADASTRO DO DESTINATARIO, VERIFIQUE O TIPO DE ENDERE«O "'||C_CURSOR.GLB_TPCLIEND_CODIGODESTINATARI||'" DO CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFDESTINATARIO;
               END IF;
               
               IF FN_CON_VALIDACEPCTE(C_CURSOR.GLB_CLIENTE_CGCCPFDESTINATARIO, C_CURSOR.GLB_TPCLIEND_CODIGODESTINATARI) = 'E' THEN
                  P_ERRO      := 'E';
                  P_MENSAGEM  := TRIM(P_MENSAGEM)||CHR(13)||'PROBLEMA NO CADASTRO DO DESTINAT¡RIO, VERIFIQUE O CEP CADASTRADO NO TIPO DE ENDERE«O "'||C_CURSOR.GLB_TPCLIEND_CODIGODESTINATARI||'" DO CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFDESTINATARIO;
               END IF;
               
            ELSE
               IF FN_CLI_VALIDAINTER(C_CURSOR.GLB_CLIENTE_CGCCPFDESTINATARIO, C_CURSOR.GLB_TPCLIEND_CODIGODESTINATARI) = 'N' THEN
                  P_ERRO      := 'E';
                  P_MENSAGEM  := TRIM(P_MENSAGEM)||'PROBLEMA NO CADASTRO DO DESTINATARIO, VERIFIQUE O PAIS CADASTRADO PARA O CLIENTE INTERNACIONAL COM O CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFDESTINATARIO;
               END IF; 
            END IF;
       END;
                   
       -- VALIDA«√O DO ENDERE«O DO SACADO QUANDO FOR UM TERCEIRO PAGANTE
       BEGIN
            IF F_GET_CIFFOB_2(C_CURSOR.CON_CONHECIMENTO_CODIGO,C_CURSOR.CON_CONHECIMENTO_SERIE, C_CURSOR.GLB_ROTA_CODIGO) = 'TER' THEN
              
               IF FN_CLI_NACIONAL(C_CURSOR.GLB_CLIENTE_CGCCPFSACADO) = 'N' THEN
                  IF FN_CON_VALIDAENDERECOCLI(C_CURSOR.GLB_CLIENTE_CGCCPFSACADO, 'C') = 0 THEN
                     P_ERRO := 'E';
                     P_MENSAGEM  := P_MENSAGEM||CHR(13)||'PROBLEMA NO CADASTRO DO SACADO, VERIFIQUE O TIPO DE ENDERE«O "C" DO CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFSACADO;
                  END IF;
                  IF FN_CON_VALIDACEPCTE(C_CURSOR.GLB_CLIENTE_CGCCPFSACADO, 'C') = 'E' THEN
                  P_ERRO      := 'E';
                  P_MENSAGEM  := TRIM(P_MENSAGEM)||CHR(13)||'PROBLEMA NO CADASTRO DO REMETENTE, VERIFIQUE O CEP CADASTRADO NO TIPO DE ENDERE«O "'||C_CURSOR.GLB_TPCLIEND_CODIGOREMETENTE||'" DO CNPJ N∫ '||C_CURSOR.GLB_CLIENTE_CGCCPFREMETENTE;
               END IF;
               END IF;
            
            END IF;
       END;  
       
       
       -- VALIDA«√O SE SACADO POSSUE TIPO E
       SELECT COUNT(*)
         INTO vExisteTipoE
         FROM T_CON_CONHECIMENTO CH,
              T_GLB_CLIEND CD
        WHERE CH.CON_CONHECIMENTO_CODIGO  = P_CTRC
          AND CH.CON_CONHECIMENTO_SERIE   = P_SERIE
          AND CH.GLB_ROTA_CODIGO          = P_ROTA
          AND CH.GLB_CLIENTE_CGCCPFSACADO = CD.GLB_CLIENTE_CGCCPFCODIGO
          AND CD.GLB_TPCLIEND_CODIGO      = 'E';
      
       IF vExisteTipoE = 0 THEN
          P_ERRO      := 'E';
          P_MENSAGEM  := P_MENSAGEM||CHR(13)||' SACADO DO CTE N√O POSSUE TIPO "E" NO CADASTRO DE CLIENTES.';
       END IF;  
       
               
       -- VALIDA«√O DO CODIGO IBGE DA LOCALIDADE DE ORIGEM.        
       IF FN_CON_VALIDAIBGELOC(C_CURSOR.GLB_LOCALIDADE_CODIGOORIGEM) = 0 THEN
          P_ERRO      := 'E';
          P_MENSAGEM  := P_MENSAGEM||CHR(13)||'PROBLEMA NA LOCALIDADE DE ORIGEM FAVOR CONSULTE O CODIGO DE IBGE PARA A LOCALIDADE '||C_CURSOR.GLB_LOCALIDADE_CODIGOORIGEM;
       END IF;
       
       
      -- VALIDA«√O DO CODIGO IBGE DA LOCALIDADE DE DESTINO.
       IF FN_CON_VALIDAIBGELOC(C_CURSOR.GLB_LOCALIDADE_CODIGODESTINO) = '0' THEN
          P_ERRO      := 'E';
          P_MENSAGEM  := P_MENSAGEM||CHR(13)||'PROBLEMA NA LOCALIDADE DE DESTINO FAVOR CONSULTE O CODIGO DE IBGE PARA A LOCALIDADE '||C_CURSOR.GLB_LOCALIDADE_CODIGODESTINO;
       END IF;
       
       
       -- VALIDA«√O DO CODIGO IBGE DA LOCALIDADE DE COLETA.
       IF C_CURSOR.GLB_LOCALIDADE_CODIGOORIGEM <> C_CURSOR.CON_CONHECIMENTO_LOCALCOLETA THEN
          IF FN_CON_VALIDAIBGELOC(C_CURSOR.CON_CONHECIMENTO_LOCALCOLETA) = 0  THEN
             P_ERRO      := 'E';
             P_MENSAGEM  := P_MENSAGEM||CHR(13)||'PROBLEMA NA LOCALIDADE DE COLETA FAVOR CONSULTE O CODIGO DE IBGE PARA A LOCALIDADE '||C_CURSOR.GLB_LOCALIDADE_CODIGODESTINO;
          END IF;
       END IF;
       
       
       -- VALIDA«√O DO CODIGO IBGE DA LOCALIDADE DE ENTREGA. 
       IF C_CURSOR.GLB_LOCALIDADE_CODIGODESTINO <> C_CURSOR.CON_CONHECIMENTO_LOCALENTREGA THEN 
           IF FN_CON_VALIDAIBGELOC(C_CURSOR.CON_CONHECIMENTO_LOCALENTREGA) = 0 THEN
              P_ERRO      := 'E';
              P_MENSAGEM  := P_MENSAGEM||CHR(13)||'PROBLEMA NA LOCALIDADE DE ENTREGA FAVOR CONSULTE O CODIGO DE IBGE PARA A LOCALIDADE '||C_CURSOR.GLB_LOCALIDADE_CODIGODESTINO;
           END IF;  
       END IF;
      
       -- VALIDA«√O DO VALOR TOTAL DO CONEHCIMENTO    
       IF FN_CON_ITTPV(C_CURSOR.CON_CONHECIMENTO_CODIGO, C_CURSOR.CON_CONHECIMENTO_SERIE, C_CURSOR.GLB_ROTA_CODIGO) = 0 THEN
           P_ERRO      := 'E';
           P_MENSAGEM  := P_MENSAGEM||CHR(13)||'TOTAL DA PRESTA«√O ESTA ZERADA FAVOR VERIFIQUE!';
       END IF;
         
       -- VALIDA«√O DO CFOP
       IF NVL(TRIM(C_CURSOR.CON_CONHECIMENTO_CFO),'NULO') = 'NULO' THEN
          P_ERRO      := 'E';
          P_MENSAGEM  := P_MENSAGEM||CHR(13)||'CFOP ' || NVL(TRIM(C_CURSOR.CON_CONHECIMENTO_CFO),'NULO') || ' EM BRANCO, CONTATE O DPTO. DE T.I.!';
       END IF;  
              
       -- VALIDA«√O CHAVE CTE      
       IF PKG_CON_CTE.FN_CTE_VALIDACHAVENFE(C_CURSOR.CON_CONHECIMENTO_CODIGO, C_CURSOR.CON_CONHECIMENTO_SERIE, C_CURSOR.GLB_ROTA_CODIGO,V_MESAGEM) = 'E' THEN
          P_ERRO      := 'E';
          P_MENSAGEM  := P_MENSAGEM||CHR(13)||V_MESAGEM;
       END IF;
         
       
       /******************************************************/
       /***************RAFAEL AITI 21/11/2018****************/
       /**********VERIFICO SE A COLETA EST¡ CANCELADA********/
       /******************************************************/
        
        SELECT COUNT (*)
          INTO vAuxiliarC
          FROM TDVADM.T_ARM_COLETA       CO,
               TDVADM.T_ARM_COLETAOCOR   OC,
               TDVADM.T_CON_CONHECIMENTO CTE
        WHERE  CO.ARM_COLETAOCOR_CODIGO        = OC.ARM_COLETAOCOR_CODIGO
          AND  CO.ARM_COLETA_NCOMPRA           = CTE.ARM_COLETA_NCOMPRA
          AND  CO.ARM_COLETA_CICLO             = CTE.ARM_COLETA_CICLO
          AND  CTE.CON_CONHECIMENTO_CODIGO     = P_CTRC    
          AND  CTE.CON_CONHECIMENTO_SERIE      = P_SERIE
          AND  CTE.GLB_ROTA_CODIGO             = P_ROTA
          AND  OC.ARM_COLETAOCOR_CANCELACOLETA = 'S'
          AND  CO.ARM_COLETAOCOR_CODIGO NOT IN '79';
          
          if vAuxiliarC > 0 then 
              P_ERRO      := 'E';
              P_MENSAGEM  := P_MENSAGEM||CHR(13)||'N√O … POSSÕVEL EMITIR O CONHECIMENTO, POIS A COLETA EST¡ CANCELADA';
          end if;
        
           /*-- VALIDA«√O DO LOCAL DE COLETA CASO <> DO REMET INFORMAR O LOCAL DE COLETA
        IF FN_CON_VALIDALOCALCOLETA(C_CURSOR.CON_CONHECIMENTO_CODIGO, C_CURSOR.CON_CONHECIMENTO_SERIE, C_CURSOR.GLB_ROTA_CODIGO) = 'E' THEN
           P_ERRO      := 'E';
           P_MENSAGEM  := P_MENSAGEM||CHR(13)||'LOCAL DE COLETA DIFERENTE DO LOCAL DO REMETENTE, FAVOR INFORMAR O LOCAL DE COLETA PARA ESTE CTE.!';
        END IF;
          
        -- VALIDA«√O DO LOCAL DE ENTREGA CASO <> DO DESTINATARIO INFORMAR O LOCAL DE ENTREGA
        IF FN_CON_VALIDALOCALENTREGA(C_CURSOR.CON_CONHECIMENTO_CODIGO, C_CURSOR.CON_CONHECIMENTO_SERIE, C_CURSOR.GLB_ROTA_CODIGO) = 'E' THEN
           P_ERRO      := 'E';
           P_MENSAGEM  := P_MENSAGEM||CHR(13)||'LOCAL DE ENTREGA DIFERENTE DO LOCAL DO DESTINATARIO, FAVOR INFORMAR O LOCAL DE ENTREGA PARA ESTE CTE.!';
        END IF;
        */
        
        /******************************************************/
        /***************VALIDA«√O DO SACADO DO CTE*************/
        /******************************************************/
        
        begin
        
          V_ERRO    := '';    
          V_MESAGEM := '';
        
          pkg_con_cte.SP_CON_VALIDASACADO(C_CURSOR.CON_CONHECIMENTO_CODIGO,
                                          C_CURSOR.CON_CONHECIMENTO_SERIE ,
                                          C_CURSOR.GLB_ROTA_CODIGO        ,
                                          V_ERRO                          ,    
                                          V_MESAGEM
                                         );
          IF V_ERRO <> PKG_GLB_COMMON.Status_Nomal THEN
             P_ERRO      := V_ERRO;
             P_MENSAGEM  := P_MENSAGEM||CHR(13)||V_MESAGEM;
          END IF;  
        
        end; 
        
        /******************************************************/
        
        /******************************************************/
        /***************VALIDA«√O DE PLACAS DO CTE*************/
        /******************************************************/
        vCnpjProp := null;
        FOR P_PLACAS IN (SELECT VV.ID               ,
                                VV.CINT             ,
                                VV.RENAVAN          ,        
                                VV.PLACA            ,
                                VV.TARA             ,
                                VV.CAPKG            ,
                                VV.CAPM3            ,
                                VV.TPPROP           ,
                                VV.TPVEIC           ,
                                VV.TDROD            ,
                                VV.TPCAR            ,
                                VV.UF               ,
                                VV.prop
                           FROM V_CTE_16400_T VV
                           WHERE VV.CON_CONHECIMENTO_CODIGO = C_CURSOR.CON_CONHECIMENTO_CODIGO 
                             AND VV.CON_CONHECIMENTO_SERIE  = C_CURSOR.CON_CONHECIMENTO_SERIE
                             AND VV.GLB_ROTA_CODIGO         = C_CURSOR.GLB_ROTA_CODIGO)
          LOOP
           
              
            /*************************************************/
            /*************VALIDA«√O DA PLACA******************/
            /*************************************************/
            IF LENGTH(TRIM(P_PLACAS.PLACA)) <> 7 THEN
               P_ERRO      := 'E';
               P_MENSAGEM  := P_MENSAGEM||CHR(13)||'Placa: '||TRIM(P_PLACAS.PLACA)||' do Veiculo invalida!'; 
            END IF;    
            /*************************************************/
            
            
            
            /*************************************************/
            /*************VALIDA«√O DO RENAVAN****************/
            /*************************************************/
            IF NVL(TRIM(P_PLACAS.RENAVAN),'NULLO') = 'NULLO' THEN
               P_ERRO      := 'E';
               P_MENSAGEM  := P_MENSAGEM||CHR(13)||'Veiculo de Placa: '||TRIM(P_PLACAS.PLACA)||' sem Renavan cadastrado!'; 
            END IF;
            
            
            IF length(TRIM(P_PLACAS.RENAVAN)) <> 9 THEN
               P_ERRO      := 'E';
               P_MENSAGEM  := P_MENSAGEM||CHR(13)||'Veiculo de Placa: '||TRIM(P_PLACAS.PLACA)||' com Renavam invalido!'; 
            END IF;      
            /*************************************************/
            
            
            /*************************************************/
            /*************PROPRIETARIO DO VEICULO*************/
            /*************************************************/
            vCnpjProp := null;
            
            FOR P_PROP IN (SELECT VP.ID      ,
                                  VP.CPF_CNPJ,
                                  VP.RNTRC   ,
                                  VP.XNOME   ,
                                  VP.IE      ,
                                  VP.UF      ,
                                  VP.TPPROP
                             FROM V_CTE_16410_T_104 VP
                             WHERE VP.CON_CONHECIMENTO_CODIGO = C_CURSOR.CON_CONHECIMENTO_CODIGO 
                               AND VP.CON_CONHECIMENTO_SERIE  = C_CURSOR.CON_CONHECIMENTO_SERIE
                               AND VP.GLB_ROTA_CODIGO         = C_CURSOR.GLB_ROTA_CODIGO
                               AND TRIM(VP.CPF_CNPJ)          = TRIM(P_PLACAS.PROP))
            LOOP
              
            
            /*************************************************/
            /*************VALIDA«√O DO RNTRC******************/
            /*************************************************/
            IF LENGTH(TRIM(P_PROP.RNTRC)) <> 8 THEN
               P_ERRO      := 'E';
               P_MENSAGEM  := P_MENSAGEM||CHR(13)||'RNTRC: '||P_PROP.RNTRC||' do proprietario: '||TRIM(P_PROP.CPF_CNPJ)||' Invalido!'; 
            END IF;    
            /*************************************************/
            
            
            
            /******************************************************/
            /*************VALIDA«√O DA IE DO PROP******************/
            /******************************************************/
            
            if vCnpjProp <> P_PROP.CPF_CNPJ then 
               if length(trim(P_PROP.CPF_CNPJ)) = '14' THEN 
                  IF PKG_GLB_VALIDAIE.FN_VALIDAIE(P_PROP.IE,P_PROP.UF) <> 'OK' THEN
                     P_ERRO      := 'E';
                     P_MENSAGEM  := P_MENSAGEM||CHR(13)||'Insc. Est: '||P_PROP.IE||' na UF: '||p_prop.uf||' do prop.: '||TRIM(P_PROP.CPF_CNPJ)||' È Invalida!'; 
                  END IF;         
               END IF;
            end if;
            /******************************************************/
            
            
            if vCnpjProp is null then
               vCnpjProp := P_PROP.CPF_CNPJ;
            end if; 
            
            
            END LOOP;   
            /*************************************************/
            
          END LOOP;         
        /******************************************************/
        
        
        /******************************************************/
        /***************VALIDA«√O DAS MERCARORIAS *************/
        /******************************************************/
        BEGIN
          FOR v_cursor IN (SELECT TR.INFCARGA,
                                  TR.VMERC   ,
                                  TR.PRODPRED,
                                  TR.XOUTCAT
                             FROM V_CTE_15100 TR
                             WHERE TR.CON_CONHECIMENTO_CODIGO = P_CTRC  
                               AND tr.con_conhecimento_serie  = P_SERIE 
                               AND tr.glb_rota_codigo         = P_ROTA  
                          )
          LOOP
            
            IF NVL(v_cursor.prodpred,'NULLO') = 'NULLO' THEN
               P_ERRO      := 'E';
               P_MENSAGEM  := P_MENSAGEM||CHR(13)||' DescriÁ„o da mercadoria n„o informada.'; 
            END IF;
            
            IF NVL(v_cursor.xoutcat,'NULLO') = 'NULLO' THEN
               P_ERRO      := 'E';
               P_MENSAGEM  := P_MENSAGEM||CHR(13)||' InformaÁıes da embalagem invalida.'; 
            END IF;
            
            IF NVL(v_cursor.vmerc,'NULLO') = 'NULLO' THEN
               P_ERRO      := 'E';
               P_MENSAGEM  := P_MENSAGEM||CHR(13)||' Valor da mercadoria n„o informada.';
            END IF;
               
          END LOOP;
             
        END;  
        /******************************************************/
        
        
        /******************************************************/
        /***************   VALIDA«√O DOS IMPOSTOS *************/
        /******************************************************/
       vTpFormulario := pkg_slf_calculos.F_BUSCA_CONHEC_TPFORMULARIO(c_cursor.con_conhecimento_codigo,c_cursor.con_conhecimento_serie,c_cursor.glb_rota_codigo);
       
       
       IF vTpFormulario = 'CTRC' then
        
            select count(*)
              INTO vExisteImp
              from V_CTE_14100B imp
             where imp.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
               and imp.con_conhecimento_serie  = c_cursor.con_conhecimento_serie
               and imp.glb_rota_codigo         = c_cursor.glb_rota_codigo
               and imp.TIPO in ('14100','14145','14180','24120');
               
            
            IF vExisteImp = 0 THEN
               begin

                  select imp.TIPO
                    INTO vAuxiliarT
                    from V_CTE_14100B imp
                   where imp.con_conhecimento_codigo = c_cursor.con_conhecimento_codigo
                     and imp.con_conhecimento_serie  = c_cursor.con_conhecimento_serie
                     and imp.glb_rota_codigo         = c_cursor.glb_rota_codigo;
                 
               exception
                WHEN NO_DATA_FOUND Then
                   vAuxiliarT := 'NADA';
                when OTHERS Then
                   vAuxiliarT := substr(sqlerrm,1,50);
                End ;
             
               P_ERRO := 'E'; 
               P_MENSAGEM := P_MENSAGEM||' - '||' Cte sem imposto conhecido. Retornou o imposto [' || vAuxiliarT || ']';
              
            END IF;
        END IF; 
           
        /******************************************************/
        
        If c_cursor.arm_coleta_ncompra is null Then
          -- Cachoeiro de Itapemirim esta liberada da Obrigatoriedade de ter coleta
          If c_cursor.glb_rota_codigo not in ('186','180') Then
              P_ERRO := 'E'; 
              P_MENSAGEM := P_MENSAGEM||' - '||' Cte sem COLETA...';
          End If;
        End If;
        
     END LOOP;
     
     IF NVL(V_ERRORT,'N') = 'N' THEN
     
       P_ERRO     := trim(P_ERRO);
       P_MENSAGEM := substr(trim(P_MENSAGEM),1,255);
       
     ELSE
        P_MENSAGEM := trim(SUBSTR(V_MESAGEMRT||' - '||P_MENSAGEM,1,255));
        P_ERRO     := V_ERRORT; 
     END IF;   
  --  P_ERRO := V_CLIVALIDO;
  P_MENSAGEM := TRIM(P_MENSAGEM);

END SP_CON_VALIDACTE;

  PROCEDURE SP_CON_VALIDAROTACTE(P_ROTA     IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                P_ERRO     OUT VARCHAR2,
                                P_MENSAGEM OUT VARCHAR2) AS
 /***************************************************************************************************
  * ROTINA           : SP_CON_VALIDAROTACTE                                                          *
  * PROGRAMA         : VALIDA«AO DA ROTA DE EMISS√O DO CTE                                           *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 16/12/2010                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : GERA«√O CONHECIMENTO DIGITACAOMANUAL, COMPC, FIFO                             *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : VERIFICAR SE A CTE REJEITADO N√O ACEITO NA ROTA A MAIS DE DUAS HORAS          *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_ROTA                                                                        *
  ****************************************************************************************************/

V_COUNT   INTEGER;
V_COUNTNG INTEGER;
V_CTRCREJEITADO VARCHAR2(4000);
V_CTRCNAOGERADOS VARCHAR2(4000);
V_UFROTA  T_GLB_ROTA.GLB_ESTADO_CODIGO%TYPE;

BEGIN
     
     SELECT RT.GLB_ESTADO_CODIGO
       INTO V_UFROTA
       FROM T_GLB_ROTA RT
      WHERE RT.GLB_ROTA_CODIGO = P_ROTA;  
     
     
     BEGIN
           V_COUNT := 0;
           V_CTRCREJEITADO := '';
           FOR R_REJEITADO IN (SELECT C.CON_CONHECIMENTO_CODIGO,
                                      C.CON_CONHECIMENTO_SERIE,
                                      C.GLB_ROTA_CODIGO
                                 FROM T_CON_CONTROLECTRCE C,
                                      T_GLB_ROTA RT,
                                      T_CON_CONHECIMENTO CR
                                WHERE C.GLB_ROTA_CODIGO = RT.GLB_ROTA_CODIGO
                                  AND RT.GLB_ROTA_CTE = 'S'
                                  AND (SYSDATE - C.CON_CONTROLECTRCE_DTGERACAO) > (4/24)
                                  AND TRUNC(C.CON_CONHECIMENTO_DTEMBARQUE)      >= RT.GLB_ROTA_CTEINICIO
                                  AND C.CON_CONTROLECTRCE_CODSTENV              IS NOT NULL
                                  AND C.CON_CONTROLECTRCE_DTRETORNO             IS NOT NULL
                                  AND NVL(C.CON_CONTROLECTRCE_CODSTENV, '999')  NOT IN('100','301')
                                  AND C.CON_CONHECIMENTO_CODIGO = CR.CON_CONHECIMENTO_CODIGO
                                  AND C.CON_CONHECIMENTO_SERIE  = CR.CON_CONHECIMENTO_SERIE
                                  AND C.GLB_ROTA_CODIGO         = CR.GLB_ROTA_CODIGO
                                  AND NVL(CR.CON_CONHECIMENTO_CFO,'XXXX')       <> '9999'
                                  AND C.GLB_ROTA_CODIGO = P_ROTA
                                  AND 0 = (SELECT COUNT(*)
                                             FROM T_CON_CONTROLEINUTCTE I 
                                            WHERE C.CON_CONHECIMENTO_CODIGO BETWEEN I.CON_CONTROLEINUTCTE_NUMINI
                                              AND I.CON_CONTROLEINUTCTE_NUMFIM
                                              AND I.GLB_ROTA_CONTROLEINUTCTE = C.GLB_ROTA_CODIGO))
              LOOP
               
                V_COUNT         := V_COUNT+1;
                if length(V_CTRCREJEITADO) < 3960 Then
                   V_CTRCREJEITADO := V_CTRCREJEITADO ||CHR(13) || R_REJEITADO.CON_CONHECIMENTO_CODIGO;
                End If;   
              END LOOP;
              if V_COUNT > 0 Then
                   V_CTRCREJEITADO := trim(to_char(V_COUNT)) || ' - Ctrc Rejeitado: ' || CHR(13) || trim(V_CTRCREJEITADO);
              End If;
      EXCEPTION
        WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20001, 'ERRO AO BUSCAR CONHECIMENTOS N√O ACEITOS! ERRO: '||SQLERRM);
        END;

      V_COUNTNG := 0;
      V_CTRCNAOGERADOS := '';
          BEGIN
             FOR R_NAGERADOS IN ( SELECT distinct Cr.CON_CONHECIMENTO_CODIGO,
                                        Cr.CON_CONHECIMENTO_SERIE,
                                        Cr.GLB_ROTA_CODIGO
                                 FROM T_GLB_ROTA RT,
                                      T_CON_CONHECIMENTO CR,
                                      T_UTI_LOGCTE LO
                                 WHERE RT.GLB_ROTA_CODIGO                    = P_ROTA
                                   AND RT.GLB_ROTA_CODIGO                    = CR.GLB_ROTA_CODIGO
                                   AND CR.CON_CONHECIMENTO_CODIGO            = LO.UTI_LOGCTE_CODIGO
                                   AND CR.CON_CONHECIMENTO_SERIE             = LO.UTI_LOGCTE_SERIE
                                   AND CR.GLB_ROTA_CODIGO                    = LO.UTI_LOGCTE_ROTA_CODIGO
                                   AND TRUNC(CR.CON_CONHECIMENTO_DTEMBARQUE) >= '27/11/2012'
                                   AND (SYSDATE - CR.CON_CONHECIMENTO_HORASAIDA) > (4/24))
             loop
               V_COUNTNG := V_COUNTNG + 1;
               V_CTRCNAOGERADOS := V_CTRCNAOGERADOS||CHR(13)||'Ctrc N„o gerado: '||R_NAGERADOS.CON_CONHECIMENTO_CODIGO;
               
             End loop; 
      EXCEPTION
        WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20001, 'ERRO AO BUSCAR CONHECIMENTOS N√O ACEITOS! ERRO: '||SQLERRM);
        END;


/*      IF (V_COUNT >= 1) THEN 
         P_ERRO     := 'E';
         P_MENSAGEM := 'CTe REJEITADOS + DE 4 HORAS. '||V_CTRCREJEITADO;
      end if;
             
      if (V_COUNTNG >= 1) THEN  
         P_ERRO     := 'E';
         P_MENSAGEM := P_MENSAGEM||chr(13)||'CTe N√O GERADOS + DE 4 HORAS .'||V_CTRCNAOGERADOS;
      END IF;

      if ((V_COUNT >= 1) or (V_COUNTNG >= 1)) then
         return;
      end if;*/
        
        
        P_ERRO     := 'N';
        
END SP_CON_VALIDAROTACTE;                                 

  FUNCTION FN_SETVEICVIAGEM(P_CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            P_DATA    IN DATE DEFAULT SYSDATE) RETURN CHAR IS

    vColeta      TDVADM.T_ARM_COLETA.ARM_COLETA_NCOMPRA%TYPE;
    vColetaCiclo tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
    vConjunto    TDVADM.T_FRT_CONJUNTO.FRT_CONJVEICULO_CODIGO%TYPE;
    vMotorista   TDVADM.T_CAR_CARRETEIRO.CAR_CARRETEIRO_CPFCODIGO%TYPE;
    vPlacaConhec TDVADM.t_con_conhecimento.CON_CONHECIMENTO_PLACA%TYPE;
    vPlaca       TDVADM.T_CAR_VEICULO.CAR_VEICULO_PLACA%TYPE;
    vPlacaSq     TDVADM.T_CAR_VEICULO.CAR_VEICULO_SAQUE%TYPE;
    vPlacaCar2   TDVADM.T_CAR_VEICULO.CAR_VEICULO_PLACA%TYPE;
    vPlacaCar2Sq TDVADM.T_CAR_VEICULO.CAR_VEICULO_SAQUE%TYPE;
    vPlacaCar3   TDVADM.T_CAR_VEICULO.CAR_VEICULO_PLACA%TYPE;
    vPlacaCar3Sq TDVADM.T_CAR_VEICULO.CAR_VEICULO_SAQUE%TYPE;
    vProp        TDVADM.T_CAR_VEICULO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE;
    VPropCar2    TDVADM.T_CAR_VEICULO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE;
    VPropCar3    TDVADM.T_CAR_VEICULO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE; 
    vTeste       CHAR(2);  
  BEGIN
    
    -- Limpando variavel do tipo 
    Begin
       vVeiculo.delete;
       vVeiculo.delete;
    exception
      when others then
        -- so pra constar
        vConjunto := '11';
      end; 
    
    -- Atribuido 11, depois da validaÁ„o se ainda for 11 È porque n„o È frota.
    vConjunto := '11';
     
    BEGIN
       -- Select na placa que esta vinculada a Coleta.
       SELECT M.ARM_COLETA_NCOMPRA,
              m.arm_coleta_ciclo,
              M.ARM_COLETA_CARRETEIRO,
              M.ARM_COLETA_MOTORISTA_PLACA,
              M.ARM_COLETA_MOTORISTA_PLACASAQU,
              M.ARM_COLETA_PLACA2,
              M.ARM_COLETA_PLACA2SAQUE,
              M.ARM_COLETA_PLACA3,
              M.ARM_COLETA_PLACA3SAQUE,
              c.con_conhecimento_placa
         INTO vColeta,
              vColetaCiclo,
              vMotorista,
              vPlaca,
              vPlacaSq,
              vPlacaCar2,
              vPlacaCar2Sq,
              vPlacaCar3,
              vPlacaCar3Sq,
              vPlacaConhec
         FROM T_CON_CONHECIMENTO C, 
              T_ARM_COLETA_MOTORISTA M
        WHERE C.ARM_COLETA_NCOMPRA      = M.ARM_COLETA_NCOMPRA(+)
          and c.arm_coleta_ciclo        = m.arm_coleta_ciclo(+)
          AND C.CON_CONHECIMENTO_CODIGO = P_CTRC
          AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
          AND C.GLB_ROTA_CODIGO         = P_ROTA;
     
       
       
       IF vPlacaCar2 IS NULL THEN
          vColeta := NULL;  
       END IF;  
       
       /******************************************/
       /*******alimentando o conjunto*************/
       /******************************************/
       -- Se for frota
       IF  substr(vPlacaConhec,1,2) = '00' THEN
           
           vConjunto :=  TRIM(vPlacaConhec);
           
       END IF;
             
       -- se for frota
       IF  (substr(vPlaca,1,2) = '00') AND (vPlacaCar2 IS NOT NULL) THEN
           
           vConjunto :=  TRIM(vPlaca);
           
       END IF;
       
     

       
       /******************************************/
    EXCEPTION
       WHEN OTHERS THEN
         vColeta := NULL;
         vConjunto := '11';
    END; 


    -- N„o È frota
    If substr(vConjunto,1,2) = '11' then
       
       -- Se tem placa na coleta
       IF vColeta is Not NULL THEN
          
          -- Da tabela de careteiro.
          If vPlaca is not null THEN
             
              -- COLOCAR DEPOIS SE NO_DATA_FOUND PESQUISAR COMO FROTA
              SELECT V.CAR_VEICULO_PLACA            ,
                     V.CAR_PROPRIETARIO_CGCCPFCODIGO,
                     V.CAR_VEICULO_RENAVAN          ,
                     V.GLB_ESTADOVEICULO_CODIGO
                INTO vVeiculo(1).Placa              ,
                     vVeiculo(1).Prop               ,
                     vVeiculo(1).Renavan            ,
                     vVeiculo(1).UF
                FROM T_CAR_VEICULO V
               WHERE V.CAR_VEICULO_PLACA = vPlaca
                 AND V.CAR_VEICULO_SAQUE = vPlacaSq;

              
              -- Primeiro veiculo.
              vVeiculo(1).TPPROP := 'T';
              vVeiculo(1).TPVEIC := '0';
              vVeiculo(1).TDROD  := '03';
              vVeiculo(1).TPCAR  := '00';
              vVeiculo(1).CTRC   := P_CTRC;
              vVeiculo(1).SERIE  := P_SERIE; 
              vVeiculo(1).ROTA   := P_ROTA;
  
         End If;

          -- Da Tabela de Veiculo TDV.
          If vPlaca is not null then

           BEGIN
                 
               SELECT TRIM(P_CTRC),
                    TRIM(P_SERIE),
                    TRIM(P_ROTA),
                    TRIM(V.FRT_VEICULO_PLACA) PLACA,
                    '61139432000172' prop,
                    TRIM(LPAD(TRIM(V.FRT_VEICULO_RENAVAN), 9, '0')) RENAVAN,
                    'P' TPPROP,
                    '03' TDROD,
                    DECODE(TV.FRT_TPVEICULO_TRACAO, 'S', '0', '1') TPVEIC,
                    DECODE(TV.FRT_TPVEICULO_TRACAO, 'S', '00', '01') TPCAR,
                    TRIM(V.GLB_ESTADO_CODIGO) UF
               INTO vVeiculo(2).CTRC,
                    vVeiculo(2).SERIE,
                    vVeiculo(2).ROTA,
                    vVeiculo(2).Placa,
                    vVeiculo(2).Prop,
                    vVeiculo(2).Renavan,
                    vVeiculo(2).TPPROP,
                    vVeiculo(2).TDROD,
                    vVeiculo(2).TPVEIC,
                    vVeiculo(2).TPCAR,
                    vVeiculo(2).UF
               FROM T_FRT_VEICULO V, 
                    T_FRT_MARMODVEIC MM, 
                    T_FRT_TPVEICULO TV
              WHERE V.FRT_VEICULO_PLACA       = vPlacaCar2
                AND V.FRT_VEICULO_DATAVENDA   IS NULL
                AND V.FRT_MARMODVEIC_CODIGO   = MM.FRT_MARMODVEIC_CODIGO
                AND MM.FRT_TPVEICULO_CODIGO   = TV.FRT_TPVEICULO_CODIGO;
           
           EXCEPTION
             WHEN OTHERS THEN
               vTeste := '';
           END;
          
          End If;

       -- Se n„o tem placa na coleta
       Else
         
        BEGIN
          
          -- Pega da tabela de carreteiro.
          SELECT TRIM(A.CAR_VEICULO_PLACA)                           PLACA,         -- CAVALO
                 a.car_proprietario_cgccpfcodigo                     prop,          -- PROPRIETARIO
                 LPAD(TRIM(A.CAR_VEICULO_RENAVAN), 9, '0')           RENAVAN,       -- RENAVAM
                 TRIM(A.GLB_ESTADOVEICULO_CODIGO)                    UF,            -- UF
                 TRIM(A.CAR_VEICULO_CARRETA_PLACA)                   PLACA,         -- 1™ CARRETA
                 a.car_proprietario_cgccpfcodigoc                    prop,          -- PROPRIETARIO
                 LPAD(TRIM(A.CAR_VEICULO_CARRETA_RENAVAN), 9, '0')   RENAVAN,       -- RENAVAM
                 TRIM(A.GLB_ESTADOVEICULO_CODIGO)                    UF,            -- UF
                 O.CAR_VEICULOOUTROS_PLACA                           PLACA,         -- 2™ CARRETA      
                 O.CAR_PROPRIETARIO_CGCCPFCODIGO                     prop,          -- PROPRIETARIO
                 O.CAR_VEICULOOUTROS_RENAVAN                         RENAVAN,       -- RENAVAM
                 O.GLB_ESTADO_CODIGO                                 UF             -- UF
            INTO vVeiculo(1).Placa,
                 vVeiculo(1).Prop,
                 vVeiculo(1).Renavan,
                 vVeiculo(1).UF,
                 vVeiculo(2).Placa,
                 vVeiculo(2).Prop,
                 vVeiculo(2).Renavan,
                 vVeiculo(2).UF,
                 vVeiculo(3).Placa,
                 vVeiculo(3).Prop,
                 vVeiculo(3).Renavan,
                 vVeiculo(3).UF
            FROM T_CAR_VEICULO        A,
                 T_CON_CONHECIMENTO CH1,
                 T_CAR_VEICULOOUTROS O
           WHERE ch1.con_conhecimento_codigo       = P_CTRC
             and ch1.con_conhecimento_serie        = P_SERIE
             and ch1.glb_rota_codigo               = P_ROTA
             and  A.CAR_VEICULO_PLACA              =  RPAD(TRIM(CH1.CON_CONHECIMENTO_PLACA), 7)
             AND CH1.CON_CONHECIMENTO_DTEMBARQUE  >= '01/11/2010'
             AND CH1.CON_CONHECIMENTO_SERIE       <> 'XXX'
             AND A.CAR_VEICULO_SAQUE               = (SELECT MAX(A1.CAR_VEICULO_SAQUE)
                                                        FROM T_CAR_VEICULO A1
                                                       WHERE A1.CAR_VEICULO_PLACA = A.CAR_VEICULO_PLACA)
             AND CH1.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
             AND TRIM(A.CAR_VEICULO_PLACA)          IS NOT NULL
             AND A.CAR_VEICULO_PLACA                = O.CAR_VEICULO_PLACA(+)
             AND A.CAR_VEICULO_SAQUE                = O.CAR_VEICULO_SAQUE(+);

          vVeiculo(1).TPPROP := 'T';
          vVeiculo(1).TPVEIC := '0';
          vVeiculo(1).TDROD  := '03';
          vVeiculo(1).TPCAR  := '00';
          vVeiculo(1).CTRC   := P_CTRC;
          vVeiculo(1).SERIE  := P_SERIE; 
          vVeiculo(1).ROTA   := P_ROTA;

          vVeiculo(2).CTRC   := P_CTRC;
          vVeiculo(2).SERIE  := P_SERIE; 
          vVeiculo(2).ROTA   := P_ROTA;
          vVeiculo(2).TPPROP := 'T';
          vVeiculo(2).TPVEIC := '1';
          vVeiculo(2).TDROD  := '03';
          vVeiculo(2).TPCAR  := '01';
          
          vVeiculo(3).CTRC   := P_CTRC;
          vVeiculo(3).SERIE  := P_SERIE; 
          vVeiculo(3).ROTA   := P_ROTA;
          vVeiculo(3).TPPROP := 'T';
          vVeiculo(3).TPVEIC := '1';
          vVeiculo(3).TDROD  := '03';
          vVeiculo(3).TPCAR  := '01';



         EXCEPTION WHEN NO_DATA_FOUND THEN
            vConjunto := '00';
         END;
       
       End if; 
        
    End If;
   
    -- » um frota
    if substr(vConjunto,1,2) = '00' then
      
        SELECT TRIM(P_CTRC),
               TRIM(P_SERIE),
               TRIM(P_ROTA),
               TRIM(FR.FRT_VEICULO_PLACA) PLACA,
               '61139432000172' prop,
               LPAD(TRIM(FR.FRT_VEICULO_RENAVAN), 9, '0') RENAVAN,
               'P' TPPROP,
               '03' TDROD,
               DECODE(TV.FRT_TPVEICULO_TRACAO, 'S', '0', '1') TPVEIC,
               DECODE(TV.FRT_TPVEICULO_TRACAO, 'S', '00', '01') TPCAR,
               TRIM(FR.GLB_ESTADO_CODIGO) UF BULK COLLECT
          into vVeiculo
          FROM T_CON_VIAGEM       D,
               T_CON_CONHECIMENTO CH,
               T_FRT_VEICULO      FR,
               T_FRT_CONJUNTO     CJ,
               T_FRT_CONTENG      CE,
               T_FRT_MARMODVEIC   MM,
               T_FRT_TPVEICULO    TV
         WHERE ch.con_conhecimento_codigo = P_CTRC
           and ch.con_conhecimento_serie  = P_SERIE
           and ch.glb_rota_codigo         = P_ROTA
           and d.CON_VIAGEM_NUMERO        = CH.CON_VIAGEM_NUMERO
           AND d.GLB_ROTA_CODIGOVIAGEM    = CH.GLB_ROTA_CODIGOVIAGEM
           AND D.FRT_CONJVEICULO_CODIGO   = CJ.FRT_CONJVEICULO_CODIGO
           AND CJ.FRT_CONJVEICULO_CODIGO  = CE.FRT_CONJVEICULO_CODIGO
           AND CE.FRT_VEICULO_CODIGO      = FR.FRT_VEICULO_CODIGO
           AND FR.FRT_MARMODVEIC_CODIGO   = MM.FRT_MARMODVEIC_CODIGO
           AND MM.FRT_TPVEICULO_CODIGO    = TV.FRT_TPVEICULO_CODIGO
           AND CH.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
         order by TV.FRT_TPVEICULO_TRACAO desc;

    End If;
    
    RETURN 'N';
    
  END FN_SETVEICVIAGEM;                            

  FUNCTION FN_GETPlaca(P_QUAL IN INTEGER)    RETURN CHAR IS
  BEGIN
     RETURN vVeiculo(P_QUAL).Placa;
  END FN_GETPlaca;                            

  FUNCTION FN_GETProp(P_QUAL IN INTEGER)     RETURN CHAR IS
  BEGIN
     RETURN vVeiculo(P_QUAL).Prop;
  END FN_GETProp;                            

  FUNCTION FN_GETRenavan(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).Renavan;
  END FN_GETRenavan;                            

  FUNCTION FN_GETUF(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).UF;
  END FN_GETUF;                            

  FUNCTION FN_GETCTRC(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).CTRC;
  END FN_GETCTRC;                            
  
  FUNCTION FN_GETSERIE(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).SERIE;
  END FN_GETSERIE;                            
  
  FUNCTION FN_GETROTA(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).ROTA;
  END FN_GETROTA;                            

  FUNCTION FN_GETTPPROP(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).TPPROP;
  END FN_GETTPPROP;
  
  FUNCTION FN_GETTPVEIC(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).TPVEIC;
  END FN_GETTPVEIC;
  
  FUNCTION FN_GETTDROD(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).TDROD;
  END FN_GETTDROD;
  
  FUNCTION FN_GETTPCAR(P_QUAL IN INTEGER)  RETURN CHAR is
  BEGIN
     RETURN vVeiculo(P_QUAL).TPCAR;

  END FN_GETTPCAR;

  Function fn_retorna_obs(vConhecCodigo In tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type,
                          vConhecSerie  In tdvadm.t_con_conhecimento.con_conhecimento_serie%Type,
                          vGlbRota      In tdvadm.t_con_conhecimento.glb_rota_codigo%Type) Return Varchar2
  Is
    vObsSolTab      tdvadm.t_slf_solfrete.slf_solfrete_obssolicitacao%Type;
    vObsConhec      tdvadm.t_con_conhecimento.con_conhecimento_obs%Type;
    vObsLei         tdvadm.t_con_conhecimento.con_conhecimento_obslei%Type;
    vObsCliente     tdvadm.t_con_conhecimento.con_conhecimento_obscliente%Type;
    vSacado         tdvadm.t_con_conhecimento.glb_cliente_cgccpfsacado%Type;
    vLocalidadeCol  tdvadm.t_glb_localidade.glb_localidade_codigo%type;
    vLocalidadeOri  tdvadm.t_glb_localidade.glb_localidade_codigo%type;
    vExisteEntrega  integer;
    vExisteRedesp   integer;
    vObsEntrega     varchar2(200);
    vlocalidadeDesc tdvadm.t_glb_localidade.glb_localidade_descricao%type;
    vLocalidadeUf   tdvadm.t_glb_localidade.glb_estado_codigo%type;
    vConhecRedes    tdvadm.t_con_consigredespacho.con_consigredespacho_conhec%type; 	
    vSerieRedes     tdvadm.t_con_consigredespacho.con_consigredespacho_seriedoc%type;
    vEmissaRedes    tdvadm.t_con_consigredespacho.con_consigredespacho_dtemissao%type;
    
  Begin
     Select c.con_conhecimento_obs,
            c.con_conhecimento_obslei,
            c.con_conhecimento_obscliente,
            c.slf_solfrete_obssolicitacao,
            c.glb_cliente_cgccpfsacado,
            c.con_conhecimento_localcoleta,
            c.glb_localidade_codigoorigem
       Into vObsConhec,
            vObsLei,
            vObsCliente,
            vObsSolTab,
            vSacado,
            vLocalidadeCol,
            vLocalidadeOri
     From t_con_conhecimento c
     Where c.con_conhecimento_codigo = vConhecCodigo
       And c.con_conhecimento_serie  = vConhecSerie
       And c.glb_rota_codigo         = vGlbRota;
    
     -- sirlano em 16/07/2013
     -- coloquei de forma paliativa ate achar quem esta
     -- colocando nulo na lei
   IF INSTR(UPPER(NVL(vObsLei,'NULO')),'PRESUMIDO') = 0 THEN
      vObsLei := SUBSTR('OPT.CRED.PRESUMIDO-CONV.ICMS 106/96' || '-' || TRIM(vObsLei),1,200);
   END IF;    
     
  
     select count(*)
       into vExisteEntrega
       from V_CTE_ENTREGA vv
      where vv.GLB_ROTA_CODIGO         = vGlbRota
        and vv.CON_CONHECIMENTO_SERIE  = vConhecSerie
        and vv.CON_CONHECIMENTO_CODIGO = vConhecCodigo; 
        
        
     BEGIN
       
     SELECT R.NUMERO_DOC,
            R.SER_DOC,
            TRUNC(R.EMI_DOC),
            1 EXISTE
       INTO vConhecRedes ,
            vSerieRedes  ,
            vEmissaRedes ,
            vExisteRedesp
       FROM V_CTE_12200 R
      WHERE R.CON_CONHECIMENTO_CODIGO = vConhecCodigo
        AND R.CON_CONHECIMENTO_SERIE  = vConhecSerie
        AND R.GLB_ROTA_CODIGO         = vGlbRota;    
    
    EXCEPTION WHEN OTHERS THEN
      vConhecRedes  := NULL;
      vSerieRedes   := NULL;
      vEmissaRedes  := NULL;
      vExisteRedesp := 0;
    END;    

     if /*(vExisteEntrega > 0) AND */(vExisteRedesp > 0) then

            SELECT LO.GLB_LOCALIDADE_DESCRICAO,
                   LO.GLB_ESTADO_CODIGO
              INTO vlocalidadeDesc,
                   vLocalidadeUf  
              FROM T_GLB_LOCALIDADE LO
            WHERE LO.GLB_LOCALIDADE_CODIGO = vLocalidadeCol; 
            
            vObsEntrega := 'Expedidor entregou a mercadoria em '||vlocalidadeDesc||' - '||vLocalidadeUf;
            vObsEntrega := vObsEntrega ||'. Com o conhecimento: '||vConhecRedes||' Serie: '||vSerieRedes||' Emiss„o: '||vEmissaRedes;
            
     end if;        
 
     -- colocado atÈ que seja conversado com o Cliente sobre que a lei tem que anteceder o frase do cliente.
     If vSacado In ('33390170001312') Then
       
       IF TRIM(vObsEntrega) IS NOT NULL THEN
          Return Trim(vObsConhec) || '-' || Trim(vObsLei) || '-' || Trim(vObsSolTab) || '-' || Trim(vObsCliente)||'-'||TRIM(vObsEntrega);
       ELSE
          Return Trim(vObsConhec) || '-' || Trim(vObsLei) || '-' || Trim(vObsSolTab) || '-' || Trim(vObsCliente);
       END IF;
         
     Else
       
       IF vObsEntrega IS NOT NULL THEN
          Return Trim(vObsConhec) ||'-'|| Trim(vObsLei) || '-' || Trim(vObsSolTab) || '-' || Trim(vObsCliente) || '-' || TRIM(vObsEntrega);
       ELSE
          Return Trim(vObsConhec) ||'-'|| Trim(vObsLei) || '-' || Trim(vObsSolTab) || '-' || Trim(vObsCliente);
       END IF;
         
     End If;  

  End fn_retorna_obs;                          

  function fn_Refresh 
     return date
   is
     vReturn date;
   begin
     select sysdate
       into vReturn
       from dual;
     return vReturn;
   end fn_Refresh;
     
  PROCEDURE SP_CON_REENVIACTESEMOUT (P_CTRC      IN CHAR,
                                     P_SERIE     IN CHAR, 
                                     P_ROTA      IN CHAR) IS
     vParametro char;
     vStatus char;
     vMessage clob;
     
  BEGIN
    vParametro := null;
    pkg_con_cte.SP_CON_REENVIACTE(p_ctrc,
                                  p_serie,
                                  p_rota,
                                  vParametro,
                                  vStatus,
                                  vMessage );
                                  
  END SP_CON_REENVIACTESEMOUT;
  

  PROCEDURE SP_CON_REENVIACTE (P_CTRC      IN CHAR,
                               P_SERIE     IN CHAR, 
                               P_ROTA      IN CHAR,
                               P_PARAMETRO IN VARCHAR2,
                               P_STATUS    OUT CHAR,
                               P_MESSAGE   OUT VARCHAR2) IS
 /****************************************************************************************************
  * ROTINA           : SP_REENVIACTE                                                                 *
  * PROGRAMA         : VALIDA«AO DO CTE ANTES DO SEU REENVIO                                         *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 04/10/2009                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : Monitor do Cte                                                                * 
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : FAZ ALGUMAS VERIFICA«’ES NO CONHECIMENTO ANTES DE SEU REENVIO                 *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : CTRC , SERIE  , ROTA                                                          *
  ****************************************************************************************************/

 vStatus           CHAR(1);
 vMessage          VARCHAR2(2000);
 vAutorizado       t_con_controlectrce.con_controlectrce_codstenv%TYPE;
 vNaoGerado        integer;
 vExisteLogReenv   integer;
 vMaquina          t_uti_logreenvcte.uti_logreenvcte_terminal%type;
 vUsuarioWin       t_uti_logreenvcte.uti_logreenvcte_osuser%type;
 vUsuarioTdv       t_usu_usuario.usu_usuario_codigo%type;
 vRotaAplicacao    t_usu_usuario.glb_rota_codigo%type;
 vVersaoApp        t_usu_aplicacao.usu_aplicacao_versao%type;
 vAplicacao        t_usu_aplicacao.usu_aplicacao_codigo%type;
 plistaparams      glbadm.pkg_listas.tlistausuparametros;
 vQtdePodeReenviar integer;
 vPodeReenviar     varchar2(200); 
 vInformacao       varchar2(100);
 vExisteCold       INTEGER;
 BEGIN

   BEGIN
     
       /**************************************************/
       /** bloqueio se CTe veio nullo                   **/
       /**************************************************/
       
       if (P_CTRC is null) then
          
           P_STATUS  := PKG_GLB_COMMON.Status_Warning;
           P_MESSAGE := 'Nenhum CTe selecionado para reenvio!';
           return; 
         
       end if;  
       
       /**************************************************/
       /**************************************************/
       /**************************************************/
        
       /**************************************************/
       /************** PARAMETRO DA APLICA«√O    *********/
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
                                                       plistaparams) Then
                                            
             P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
             P_MESSAGE := P_MESSAGE || '10 - Erro ao Buscar Parametros.' || chr(10);
             return;
          else
            vQtdePodeReenviar := plistaparams('QTDEDEREENVIO').NUMERICO1; 
            vPodeReenviar     := plistaparams('PODEREENVIARCTE').TEXTO;
          End if ; 
        end if;
        
        if trim(vUsuarioTdv) = 'jsantosx' then
            P_STATUS  := PKG_GLB_COMMON.Status_Erro;
            P_MESSAGE := P_PARAMETRO;
            return;
        end if;  
       

       /**************************************************/           
       
       /**************************************************/
       /************** USUARIO MAQUINA E MAQUINA *********/
       /**************************************************/
       begin
        
        select L.terminal,
               L.os_user
          into vMaquina   ,
               vUsuarioWin
          FROM V_GLB_AMBIENTE L;  
          
       exception when others then
         vMaquina     := '';         
         vUsuarioWin  := '';
       end;
       /**************************************************/      
            
       
       /**************************************************/
       /****** QUANTIDADE DE VESEZ QUE FOI REENVIADO *****/
       /**************************************************/
       begin
          select count(*)
            into vExisteLogReenv            
            from t_uti_logreenvcte l
           where l.con_conhecimento_codigo = P_CTRC
             AND L.CON_CONHECIMENTO_SERIE  = P_SERIE
             AND L.GLB_ROTA_CODIGO         = P_ROTA;
       exception when others then
          vExisteLogReenv := 0;       
       end; 
       /**************************************************/          
       
       
       /**************************************************/
       /*********** SE ESTA NA ABA N√O GERADOS ***********/
       /**************************************************/
       
       begin
         select count(*)
           into vNaoGerado
           from t_uti_logcte lo
          where lo.uti_logcte_codigo      = p_CTRC
            and lo.uti_logcte_serie       = p_serie
            and lo.uti_logcte_rota_codigo = p_rota;  
      exception when others then
           vNaoGerado := 0; 
      end;    
        
       /**************************************************/
       
       
       /**************************************************/
       /**************** ABA DE AUTORIZA«√O **************/
       /**************************************************/
           
       BEGIN
         SELECT K.CON_CONTROLECTRCE_CODSTENV
           INTO vAutorizado
           FROM T_CON_CONTROLECTRCE K
          WHERE K.CON_CONHECIMENTO_CODIGO = p_CTRC
            AND K.CON_CONHECIMENTO_SERIE  = p_SERIE
            AND K.GLB_ROTA_CODIGO         = p_ROTA;
              
       EXCEPTION WHEN OTHERS THEN
          vAutorizado := '000';
       END;    
       
       /**************************************************/
       
      
        /**************************************************/
        /****************        COLD        **************/
        /**************************************************/
        
        BEGIN
       
         SELECT COUNT(*) 
           into vExisteCold
           FROM NDD_NEW.COLD_PRODUCAO COL 
          WHERE to_number(COL.IDE_SERIE) = to_number(p_rota)
            AND to_number(COL.IDE_NCT)   = to_number(p_CTRC);
            
         if (vExisteCold > 0) then
         
             P_STATUS   := pkg_glb_common.Status_Warning;
             P_MESSAGE  := 'Cte: '||p_CTRC||' Serie: '||p_SERIE||' Rota: '||p_ROTA||' J· esta autorizado, e ja esta no Cold!';
             RETURN;
         
         end if;
         
            
       END; 
       
        /**************************************************/
       
       
       
       
       
       
       /**************************************************/
       /**************** SE CTE ACEITO **************/
       /**************************************************/
       
       IF vAutorizado = '100' THEN
         
         if vNaoGerado > 0 then
         
         
           DELETE T_UTI_LOGCTE LO
            WHERE LO.UTI_LOGCTE_CODIGO       = p_CTRC
              AND LO.UTI_LOGCTE_SERIE        = p_SERIE
              AND LO.UTI_LOGCTE_ROTA_CODIGO  = p_ROTA;
           
           
           P_STATUS   := pkg_glb_common.Status_Warning;
           P_MESSAGE  := 'Cte: '||p_CTRC||' Serie: '||p_SERIE||' Rota: '||p_ROTA||' J· esta autorizado, e foi liberado da aba dos nao gerados!';
           RETURN;
           
           commit;     
          
         END IF;  
         
         P_STATUS   := pkg_glb_common.Status_Warning;
         P_MESSAGE  := 'Cte: '||p_CTRC||' Serie: '||p_SERIE||' Rota: '||p_ROTA||' J· esta autorizado, n„o pode ser reenviado!';
         RETURN;
         
       END IF;  
       
       /**************************************************/
       
       
       /**************************************************/
       /**************  SE JA FOI REENVIADO MUITAS VESES */
       /**************************************************/
       
       if nvl(vPodeReenviar,'N') <> 'S' then -- Parametro libera independente da quantidade de vezes de reenvio
           if vExisteLogReenv > nvl(vQtdePodeReenviar,10) then
              -- sirlano
              select c.con_conhecimento_emissor || ' Gerado em ' || to_char(c.con_conhecimento_dtgravacao,'dd/mm/yyyy') || ' as ' || to_char(c.con_conhecimento_horasaida,'hh24:mi:ss') 
                into vInformacao
              from t_con_conhecimento c
              WHERE c.CON_CONHECIMENTO_CODIGO = p_CTRC
                AND c.CON_CONHECIMENTO_SERIE  = p_SERIE
                AND c.GLB_ROTA_CODIGO         = p_ROTA;
              
              P_STATUS   := pkg_glb_common.Status_Warning;
              P_MESSAGE  := 'Cte: '||p_CTRC||' Serie: '||p_SERIE||' Rota: '||p_ROTA|| vInformacao || chr(10) || 
                            'J· foi reenviado mais que ' ||nvl(vQtdePodeReenviar,10)|| ' vezes, Acerte as informaÁıes do cte para reenvio! ou Cancele o mesmo com o motivo "Cte n„o aceito"';
              return;
           end if;  
       end if;
       
       /**************************************************/
       
       /**************************************************/
       /*************** VALIDA O CTE *********************/
       /**********  ALTERADO EM 11/07/2012  **************/
       /**************************************************/
       
       --sp_con_validacte(p_CTRC,p_SERIE,p_ROTA,vStatus,vMessage);
       
       vStatus := 'N';
       /**************************************************/
        
       /**************************************************/
       /************** SE VALIDO REENVIO *****************/
       /**************************************************/
       
       IF nvl(vStatus,'N') = TDVADM.PKG_GLB_COMMON.Status_Nomal THEN  
          
          DELETE T_XML_CTE CT
          WHERE CT.CON_CONHECIMENTO_CODIGO = p_CTRC
            AND CT.CON_CONHECIMENTO_SERIE  = p_SERIE
            AND CT.GLB_ROTA_CODIGO         = p_ROTA;
            
            
          DELETE T_UTI_LOGCTE LO
          WHERE LO.UTI_LOGCTE_CODIGO       = p_CTRC
            AND LO.UTI_LOGCTE_SERIE        = p_SERIE
            AND LO.UTI_LOGCTE_ROTA_CODIGO  = p_ROTA;  
            
             
          DELETE T_CON_CONTROLECTRCE CT
          WHERE CT.CON_CONHECIMENTO_CODIGO = p_CTRC
            AND CT.CON_CONHECIMENTO_SERIE  = p_SERIE
            AND CT.GLB_ROTA_CODIGO         = p_ROTA;
            
          --IF vAutorizado IN ('17','19','22') THEN
          
          --   sp_ndd_econector(TO_NUMBER(p_CTRC),TO_NUMBER(p_ROTA));
          
          --END IF;    
          
         /**************************************************/
         /************** GRAVO CONTROLE DE REENVIO *********/
         /**************************************************/
         
          BEGIN
            
            INSERT INTO t_uti_logreenvcte(con_conhecimento_codigo  ,
                                          con_conhecimento_serie   ,
                                          glb_rota_codigo          ,
                                          uti_logreenvcte_sequencia,
                                          uti_logreenvcte_dtreenvio,
                                          usu_usuario_codigo       ,
                                          uti_logreenvcte_terminal ,
                                          uti_logreenvcte_osuser)
                                   VALUES(p_CTRC                   ,
                                          p_SERIE                  ,
                                          p_ROTA                   ,
                                          vExisteLogReenv+1        ,
                                          sysdate                  ,
                                          vUsuarioTdv              ,
                                          vMaquina                 ,   
                                          vUsuarioWin
                                         );
                                        
          END;  
         
         /**************************************************/   
            
       ELSE
         
         P_STATUS   := pkg_glb_common.Status_Warning;
         P_MESSAGE  := vMessage;
         RETURN;
         
       END IF;
       
       /**************************************************/
       
       P_STATUS   := pkg_glb_common.Status_Nomal;
       P_MESSAGE  := 'Processamento Normal.';
         
       COMMIT;
         
       /**************************************************/     
   EXCEPTION WHEN OTHERS THEN
        P_STATUS   := pkg_glb_common.Status_Erro;
        P_MESSAGE  := 'Erro ao Reenviar| Erro: '||SQLERRM;
        RETURN;
   END;
  END;
  
  PROCEDURE SP_CON_LIMPANGERADOS AS
  BEGIN
    
  BEGIN
      DELETE T_UTI_LOGCTE P
       WHERE P.UTI_LOGCTE_CODIGO || P.UTI_LOGCTE_SERIE ||
             P.UTI_LOGCTE_ROTA_CODIGO IN
             (SELECT K.CON_CONHECIMENTO_CODIGO || K.CON_CONHECIMENTO_SERIE ||
                     K.GLB_ROTA_CODIGO
                FROM T_CON_CONTROLECTRCE K
               WHERE K.CON_CONTROLECTRCE_CODSTENV = '100'
                 AND (SELECT COUNT(*)
                        FROM T_UTI_LOGCTE LO
                       WHERE K.CON_CONHECIMENTO_CODIGO = LO.UTI_LOGCTE_CODIGO
                         AND K.CON_CONHECIMENTO_SERIE = LO.UTI_LOGCTE_SERIE
                         AND K.GLB_ROTA_CODIGO = LO.UTI_LOGCTE_ROTA_CODIGO) > 0);
      COMMIT;
                     
  EXCEPTION WHEN OTHERS THEN
    sp_enviamail_wflow('SEQ','ksouza@dellavolpe.com.br','Erro SP_CON_LIMPANGERADOS','Erro ao Executar Erro: '||Sqlerrm);
  END;                     
  
  END SP_CON_LIMPANGERADOS;   
  
  function fn_limpa_campoCTE(p_string     char,
                             p_trocapnulo char default 'N')
    return char as

    v_stringcaracteres1 varchar2(100);
    v_stringcaracteres2 varchar2(100);
    v_string            varchar2(20000);
    x                   integer;
    v_posicao           integer;
    v_caracter          char(1);
  begin

    v_stringcaracteres1 := '¸ø∫øø∫ø¥µ()/≥_".<>;*$#@%\|{}±√[]·ÈÛ˙‚ÙÍ„ı”:’……ÃÕ¡¿‹⁄‘ ¬Æ¥Ωæ≤®?øÿ∑∞∫• ™ºß£øø©°&' || ''''||chr(10)||chr(13);
    v_stringcaracteres2 := ' -                     e Cc     A  aeouaoeaoO OEEIIAAUUOEAOBS                       ';
    v_string            := '';
    X                   := 1;
    WHILE X < (LENGTH(p_string) + 1) LOOP
      v_caracter := substr(p_string, x, 1);
      v_posicao  := instr(v_stringcaracteres1, v_caracter);
      if v_posicao > 0 then
        if p_trocapnulo = 'N' then
          v_string := v_string || substr(v_stringcaracteres2, v_posicao, 1);
        end if;
      else
        if ascii(v_caracter) >= 128 Then
           v_string := v_string || ' ';
        Else   
           v_string := v_string || v_caracter;
        End If;   
      end if;

      x := x + 1;

    END LOOP;

    return substr(v_string, 1, x);

  end;
  
  function FN_GET_LOCALIMP(p_cte     t_con_conhecimento.con_conhecimento_codigo%TYPE,
                           p_serie   t_con_conhecimento.con_conhecimento_serie%TYPE,
                           p_rota    t_con_conhecimento.glb_rota_codigo%TYPE)
  return VARCHAR2 AS
  
  vUsuario  t_usu_usuario.usu_usuario_codigo%TYPE;
  vMachine  t_int_maquinas.int_maquinas_codigo%TYPE;
  vLocalImp VARCHAR2(200);
  
  BEGIN
          
  
     IF p_rota = '740' THEN
       
       RETURN 'ENTRADA/MS_CORUMBA_300/';
     
     END IF;  
       
      -- 1∫ NIVEL BUSCA POR USUARIO
      begin
          
          SELECT NVL(TRIM(CH.CON_CONHECIMENTO_EMISSOR),'emissor'),
                 nvl(trim(ch.con_conhecimento_terminal),'terminal'),
                 (SELECT U.USU_USUARIO_CTEPASTAGRAV
                  FROM T_USU_USUARIO U
                  WHERE U.USU_USUARIO_CODIGO = RPAD(CH.CON_CONHECIMENTO_EMISSOR,10))
            INTO vUsuario,
                 vMachine,
                 vLocalImp
            FROM T_CON_CONHECIMENTO CH
           WHERE CH.CON_CONHECIMENTO_CODIGO = p_cte  
             AND CH.CON_CONHECIMENTO_SERIE  = p_serie
             AND CH.GLB_ROTA_CODIGO         = p_rota;
      
      exception when others then
       vLocalImp := '';
      end;  
      
      -- 2∫ NIVEL BUSCA POR MAQUINA
      IF vLocalImp IS NULL THEN
         
         BEGIN
           SELECT NVL(M.INT_MAQUINAS_CTEPASTAGRAV,'NULO')
             INTO vLocalImp
             FROM T_INT_MAQUINAS M
             WHERE LOWER(TRIM(M.INT_MAQUINAS_CODIGO)) = LOWER(TRIM(vMachine)); 
         EXCEPTION WHEN OTHERS THEN
           vLocalImp := '';
         END;
         
      END IF;      
      
      -- 3∫ NIVEL BUSCA POR ROTA
      IF (vLocalImp IS NULL) OR (vLocalImp = 'NULO') THEN
      
         SELECT TRIM(L.GLB_ROTA_CTEPASTAGRAV)
           INTO vLocalImp
           FROM T_GLB_ROTA L
           WHERE L.GLB_ROTA_CODIGO = P_ROTA;
           
      END IF;   
       
      RETURN vLocalImp;
    
  END FN_GET_LOCALIMP;  
  
  FUNCTION FN_CTERETORNASAC(CTRC     IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            SERIE    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            ROTA     IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            INDICE   IN VARCHAR2) RETURN T_GLB_CLICONT.GLB_CLICONT_EMAIL%TYPE IS
  v_EMAIL   T_GLB_CLICONT.GLB_CLICONT_EMAIL%TYPE;
  BEGIN

   BEGIN
       
     IF (INDICE = 1)    THEN
       
       SELECT trim(CT.GLB_CLICONT_EMAIL)
         INTO v_EMAIL
         FROM TDVADM.T_CON_CONHECIMENTO CC,
              TDVADM.T_GLB_CLICONT CT
        WHERE CC.CON_CONHECIMENTO_CODIGO  = CTRC
          AND CC.CON_CONHECIMENTO_SERIE   = SERIE
          AND CC.GLB_ROTA_CODIGO          = ROTA
          AND CC.GLB_CLIENTE_CGCCPFSACADO = CT.GLB_CLIENTE_CGCCPFCODIGO
          AND CT.GLB_CLICONT_SEQ          = '0';
        
     ELSIF (INDICE = 2) THEN
     
       SELECT trim(CT.GLB_CLICONT_EMAILAUX)
         INTO v_EMAIL
         FROM TDVADM.T_CON_CONHECIMENTO CC,
              TDVADM.T_GLB_CLICONT CT
        WHERE CC.CON_CONHECIMENTO_CODIGO  = CTRC
          AND CC.CON_CONHECIMENTO_SERIE   = SERIE
          AND CC.GLB_ROTA_CODIGO          = ROTA
          AND CC.GLB_CLIENTE_CGCCPFSACADO = CT.GLB_CLIENTE_CGCCPFCODIGO
          AND CT.GLB_CLICONT_SEQ          = '0';
        
     END IF;    
     
   EXCEPTION WHEN OTHERS THEN
     v_EMAIL := ''; 
   END ;  

  RETURN v_EMAIL;
  END;
  
  FUNCTION FN_CTERETPATHXML(CTRC   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            SERIE  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            ROTA   IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE, 
                            INDICE IN VARCHAR2 ) RETURN VARCHAR2 IS
  vPathXml     t_glb_clicont.glb_clicont_pathxml%type;
  vAdvlZerado  integer;
  vCnpjSacado  tdvadm.t_con_conhecimento.glb_cliente_cgccpfsacado%type;
  vApolice     tdvadm.t_glb_apolice.glb_apolice_codigo%type;
  BEGIN

   Begin
    
     -- retorno para o ndd, salvar o xml do cte para envio aos clientes. 
     If (indice = '1') Then
       
       select trim(ct.glb_clicont_pathxml),
              cc.glb_cliente_cgccpfsacado
         into vPathXml,
              vCnpjSacado
         from t_con_conhecimento cc,
              t_glb_clicont ct
        where cc.con_conhecimento_codigo  = ctrc
          and cc.con_conhecimento_serie   = serie
          and cc.glb_rota_codigo          = rota
          and cc.glb_cliente_cgccpfsacado = ct.glb_cliente_cgccpfcodigo(+)
          and ct.glb_clicont_seq          = '0';
       
     -- Retorno para a ndd, salvar o xml do CTe para averbaÁ„o dos documentos
     ElsIf (indice = '2') Then
     
       vApolice := tdvadm.pkg_con_cte.Fn_Cte_RetornaApolice(CTRC, SERIE, ROTA);
       
       -- Se n„o for a apolice da Tdv, busco qual a pasta
       If (vApolice != '1') Then
         
         select trim(ct.glb_clicont_pathxmlseg),
                cc.glb_cliente_cgccpfsacado
           into vPathXml,
                vCnpjSacado
           from t_con_conhecimento cc,
                t_glb_clicont ct
          where cc.con_conhecimento_codigo  = ctrc
            and cc.con_conhecimento_serie   = serie
            and cc.glb_rota_codigo          = rota
            and cc.glb_cliente_cgccpfsacado = ct.glb_cliente_cgccpfcodigo(+)
            and ct.glb_clicont_seq          = '0';
         
       -- Se for a apolice ta TDV, enviamos para averbar na apolice da TDV.
       Else
         
         vPathXml := '\\vsjavac-2\CT-e\DELLAVOLPE';
         
       End If;
       
     END IF;     
        
   Exception when others then
     vPathXml := ''; 
   End ;  
   

  Return vPathXml;
  
  End;
   
  FUNCTION FN_CTERETPATHPDF(CTRC    IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            INDICE  IN VARCHAR2 DEFAULT '0') RETURN VARCHAR2 IS
  vPathPdf     T_GLB_CLICONT.GLB_CLICONT_PATHPDF%TYPE;
  vRotaGerPdf  integer;
  BEGIN
   
   IF (INDICE = '1') THEN
     
     Begin
       
       select trim(ct.glb_clicont_pathpdf)
         into vPathPdf
         from t_con_conhecimento cc,
              t_glb_clicont ct
        where cc.con_conhecimento_codigo  = ctrc
          and cc.con_conhecimento_serie   = serie
          and cc.glb_rota_codigo          = rota
          and cc.glb_cliente_cgccpfsacado = ct.glb_cliente_cgccpfcodigo(+)
          and ct.glb_clicont_seq          = '0';
       
     exception When Others Then
        vPathPdf := '';
     end;
       
   ELSE
/*          
     SELECT COUNT(*)
       INTO vRotaGerPdf 
       FROM T_GLB_ROTA RT
      WHERE ((RT.GLB_ROTA_COLETA = 'S') OR (RT.GLB_ROTA_CODIGO in ('036', '196', '630','060','020','055')))
        AND RT.GLB_ROTA_CODIGO   = ROTA; 
    
     IF vRotaGerPdf > 0 THEN
         vPathPdf := '\\stnas01.tdv.lan\CT-e\PDF';
     ELSE
         vPathPdf := '';
     END IF;    */
     
      vPathPdf := '\\vsjavac-2\CT-e\PDF';
     
   END IF;  

  RETURN vPathPdf;
  
  END FN_CTERETPATHPDF;
  
  FUNCTION FN_CTERETFILETYPE(CTRC   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,                
                             SERIE  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                             ROTA   IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                             INDICE IN VARCHAR2) RETURN VARCHAR2 IS 
  vEmail     varchar2(200);
  vFileType  tdvadm.t_glb_clicont.glb_clicont_emailtype%type;
  BEGIN
    
    vEmail := tdvadm.pkg_con_cte.fn_cteretornasac(CTRC, SERIE, ROTA, INDICE);
    
    if (vEmail is not null) then
      
      if (INDICE = '1') then
        
        select nvl(trim(ct.glb_clicont_emailtype),'0')
          into vFileType
          from tdvadm.t_con_conhecimento cc,
               tdvadm.t_glb_clicont ct
         where cc.con_conhecimento_codigo  = ctrc
           and cc.con_conhecimento_serie   = serie
           and cc.glb_rota_codigo          = rota
           and cc.glb_cliente_cgccpfsacado = ct.glb_cliente_cgccpfcodigo
           and ct.glb_clicont_seq          = '0';
          
      elsif(INDICE = '2') then
        
          select nvl(trim(ct.glb_clicont_emailauxtype),'0')
            into vFileType
            from tdvadm.t_con_conhecimento cc,
                 tdvadm.t_glb_clicont ct
           where cc.con_conhecimento_codigo  = ctrc
             and cc.con_conhecimento_serie   = serie
             and cc.glb_rota_codigo          = rota
             and cc.glb_cliente_cgccpfsacado = ct.glb_cliente_cgccpfcodigo
             and ct.glb_clicont_seq          = '0';
             
      end if;    
      
    else
      
      vFileType := '';
      
    end if;   
    
    RETURN vFileType;
    
  END FN_CTERETFILETYPE;                             
    
  FUNCTION FN_CTE_GETCHAVESEFAZ(P_CHAVE IN VARCHAR2) RETURN VARCHAR2 AS
  vNumConhec VARCHAR2(9);
  vSerie     VARCHAR2(3);
  vChaveCte  t_con_controlectrce.con_controlectrce_chavesefaz%TYPE;
  BEGIN

   vNumConhec := substr(P_CHAVE,26,9);
   vSerie     := substr(P_CHAVE,23,3);

   BEGIN
     SELECT L.CON_CONTROLECTRCE_CHAVESEFAZ
       INTO vChaveCte
       FROM T_CON_CONTROLECTRCE L
      WHERE LPAD(L.CON_CONHECIMENTO_CODIGO,9,0) = vNumConhec   
        AND L.GLB_ROTA_CODIGO                   = vSerie;
        
   EXCEPTION WHEN OTHERS THEN
    vChaveCte := P_CHAVE;
   END;    
    
   RETURN vChaveCte;

  END;
   
  FUNCTION FN_FORMATA_DTRECCTE(P_DHRECBTO in varchar2)RETURN DATE IS
   V_DATE    DATE;
   V_DATEFOR VARCHAR2(20);
   BEGIN
       
       V_DATEFOR:= SUBSTR(P_DHRECBTO,9,2)||'/'||SUBSTR(P_DHRECBTO,6,2)||'/'||SUBSTR(P_DHRECBTO,0,4)||' '||SUBSTR(P_DHRECBTO,12,9);
       
       SELECT TO_DATE(V_DATEFOR,'DD/MM/YYYY hh24:MI:SS')
         INTO V_DATE
         FROM DUAL;
         
         RETURN V_DATE;
   END;
     
  FUNCTION FN_GETREGESPECIAL(p_cte     t_con_conhecimento.con_conhecimento_codigo%TYPE,
                             p_serie   t_con_conhecimento.con_conhecimento_serie%TYPE,
                             p_rota    t_con_conhecimento.glb_rota_codigo%TYPE,
                             p_tipo    varchar2)RETURN CHAR iS
  vExisteRegEsp INTEGER;
  vGrupoEcono t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
  --0058
  BEGIN
    
    BEGIN
      
      if(p_rota = '031') then
      
         return 'S';
         
      end if;
       
       begin
      
       select c.glb_grupoeconomico_codigo
         into vGrupoEcono
         from t_con_conhecimento ch,
              t_glb_cliente c   
         where ch.con_conhecimento_codigo        = p_cte  
           and ch.con_conhecimento_serie         = p_serie
           and ch.glb_rota_codigo                = p_rota 
           and ch.glb_cliente_cgccpfdestinatario = c.glb_cliente_cgccpfcodigo;
      
      exception when others then
        vGrupoEcono := '0000';
      end;
      
         
       SELECT COUNT(*)
         INTO vExisteRegEsp 
         FROM T_CON_CONHECIMENTOREGESP L
        WHERE L.CON_CONHECIMENTO_CODIGO = p_cte  
          AND l.con_conhecimento_serie  = p_serie
          AND l.glb_rota_codigo         = p_rota
          AND NVL(L.CON_CONHECIMENTOREGESP_TPGLOB,'D') = p_tipo; 
           
    EXCEPTION WHEN OTHERS THEN
       vExisteRegEsp := 0;
    END;
    
    IF vExisteRegEsp > 0 THEN
       if vGrupoEcono <> '0058' then
          RETURN 'S';
       else
          return 'N';
       end if;  
    ELSE
      RETURN 'N';
    END IF;    
        
  END FN_GETREGESPECIAL;            
  -- Sirlano;Criei para unificar a inserÁ„o e validaÁ„o do regime especial;03/01/2013
  PROCEDURE SP_SETREGESPECIAL(p_cte     IN  t_con_conhecimento.con_conhecimento_codigo%TYPE,
                              p_serie   IN t_con_conhecimento.con_conhecimento_serie%TYPE,
                              p_rota    IN t_con_conhecimento.glb_rota_codigo%TYPE,
                              P_STATUS  OUT CHAR,
                              P_MESSAGE OUT VARCHAR2,
                              P_TRIGGER IN char DEFAULT 'N') IS
                              
    vExisteRegime number;
    vVerificaRegime char(1);
    vCNPJSC t_con_conhecimento.glb_cliente_cgccpfsacado%type;
    vCNPJDS t_con_conhecimento.glb_cliente_cgccpfdestinatario%type;
    vLOCALIDADE t_con_conhecimento.con_conhecimento_localcoleta%type;    
    vUF         t_glb_localidade.glb_estado_codigo%type;                                       
                             
  Begin
    
   P_STATUS :=  PKG_GLB_COMMON.Status_Nomal;
   P_MESSAGE := '';
   
   if p_rota = '031' Then
   -- Pega o CNPJ do Pagamente e a Localidade para testar o Regime.
   Begin
   select c.glb_cliente_cgccpfsacado,
          c.glb_cliente_cgccpfdestinatario, 
          c.con_conhecimento_localcoleta,
          lo.glb_estado_codigo,
          decode(nvl(cl.glb_ramoatividade_codigo,'99'),'00','S','N')
       into vCNPJSC,
            vCNPJDS,
            vLOCALIDADE,
            vUF,
            vVerificaRegime
   from t_con_conhecimento c,
        t_glb_localidade lo,
        t_glb_cliente cl
   where c.con_conhecimento_codigo = p_cte  
     AND c.CON_CONHECIMENTO_SERIE  = p_serie
     AND c.GLB_ROTA_CODIGO         = p_rota
     and c.con_conhecimento_localcoleta = lo.glb_localidade_codigo
     and c.glb_cliente_cgccpfdestinatario = cl.glb_cliente_cgccpfcodigo;
   exception
     when NO_DATA_FOUND then
       vCNPJSC     := null;
       vCNPJDS     := null;
       vLOCALIDADE := null;
       vUF         := null;
     end;  

      



       /***************************************************/
       /*     SE EXISTE NA TABELA DE REGIME ESPECIAL      */
       /***************************************************/
      
     vVerificaRegime := 'S'; -- coloquei sempre SIM por causa que se for destinatario 
                             -- Coca e pra sair coom o CNPJ da COCA se diversos o da Della Volpe
                             -- se for outra rota que n„o e a 031 n„o È regime especial 
       
     if vVerificaRegime = 'S' Then 
      -- testa se o CTRC TEM REGIME ESPECIAL PARA A LOCALIDADE ESPECIFICA
      select count(*)
        into vExisteRegime
      from t_glb_clienteregesp clr
      where clr.glb_cliente_cgccpfcodigo = vCNPJSC
        and clr.glb_localidade_codigo    = vLOCALIDADE
        and trunc(clr.glb_clienteregesp_dtvalidade) >= trunc(sysdate);

      -- testa se tem para o ESTADO 
      if vExisteRegime = 0  Then
         -- muda o localidade para qualquer uma e procura novamente
         vLOCALIDADE := '00000';
         select count(*)
           into vExisteRegime
         from t_glb_clienteregesp clr
         where clr.glb_cliente_cgccpfcodigo = vCNPJSC
           and clr.glb_localidade_codigo    = vLOCALIDADE
           and clr.glb_estado_codigo        = vUF
           and trunc(clr.glb_clienteregesp_dtvalidade) >= trunc(sysdate);
      End if;
      
      -- testa se existe uma generica qualquer localidade qualquer estado
      if vExisteRegime = 0  Then
         -- muda o localidade para qualquer uma e procura novamente
         vLOCALIDADE := '00000';
         vUF         := '*';
         select count(*)
           into vExisteRegime
         from t_glb_clienteregesp clr
         where clr.glb_cliente_cgccpfcodigo = vCNPJSC
           and clr.glb_localidade_codigo    = vLOCALIDADE
           and clr.glb_estado_codigo        = vUF
           and trunc(clr.glb_clienteregesp_dtvalidade) >= trunc(sysdate);
      End if;
      
           
      if vExisteRegime > 0 Then   
           select count(*)
             into vExisteRegime
             from t_con_conhecimentoregesp l
           where l.con_conhecimento_codigo = p_cte  
             AND l.CON_CONHECIMENTO_SERIE  = p_serie
             AND l.GLB_ROTA_CODIGO         = p_rota; 
              
           /***************************************************/   
           
           
           IF (vExisteRegime = 0) then
              
              insert into t_con_conhecimentoregesp(con_conhecimento_codigo    ,
                                                   con_conhecimento_serie     ,
                                                   glb_rota_codigo            ,
                                                   con_conhecimentoregesp_data,
                                                   con_conhecimentoregesp_codigo,
                                                   con_conhecimentoregesp_tpglob
                                                   )
                                            values(p_cte                      ,    
                                                   P_SERIE                    ,
                                                   P_ROTA                     ,
                                                   SYSDATE,
                                                   '',
                                                   'D');
              IF P_TRIGGER = 'N' Then
                 commit;
              End if;   
           end if;
       End if;
    End if;   
    End if;     
    
  End SP_SETREGESPECIAL;
  
  PROCEDURE SP_CON_CTECOMNF(P_CTRC    IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                            P_SERIE   IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                            P_ROTA    IN  T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                            P_STATUS  OUT CHAR,
                            P_MESSAGE OUT VARCHAR2) AS

  vExistComp      integer;
  vExisteNf       integer;
  vCteCompNume    T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  vCteCompSerie   T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  vCteCompRota    T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE;
  vColeta         tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo          tdvadm.t_arm_coleta.arm_coleta_ciclo%type;

  BEGIN

     BEGIN
        
       /*************************************************/
       /**************  SE EXISTE COMPLEMENTO ***********/
       /*************************************************/
        SELECT COUNT(*)
          INTO vExistComp
          FROM T_CON_CONHECCOMPLEMENTO KK
         WHERE KK.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND KK.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND KK.GLB_ROTA_CODIGO         = P_ROTA;
       /*************************************************/
           
       /*************************************************/
       /*************  SE EXISTE NOTA FISCAL  ***********/
       /*************************************************/
        SELECT COUNT(*)
          INTO vExisteNf
          FROM T_CON_NFTRANSPORTA TR
         WHERE TR.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND TR.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND TR.GLB_ROTA_CODIGO         = P_ROTA;     
       /*************************************************/   
       
       /*************************************************/
       /**      SE EXISTE COMPLEMENT0 E O COMPLENTO    **/
       /*  N√O POSSUIR NOTA FISCAL, PEGAMOS DO ORIGINAL */
       /*************************************************/
       if (vExistComp > 0) and (vExisteNf = 0) then
          
            SELECT KK.CON_CONHECIMENTO_CODIGOORIGEM ,
                   KK.CON_CONHECIMENTO_SERIEORIGEM  ,
                   KK.GLB_ROTA_CODIGOORIGEM         
              INTO vCteCompNume                     ,
                   vCteCompSerie                    ,
                   vCteCompRota 
              FROM tdvadm.T_CON_CONHECCOMPLEMENTO KK
             WHERE KK.CON_CONHECIMENTO_CODIGO = P_CTRC
               AND KK.CON_CONHECIMENTO_SERIE  = P_SERIE
               AND KK.GLB_ROTA_CODIGO         = P_ROTA ;
               
            SELECT KK.Arm_Coleta_Ncompra,
                   KK.Arm_Coleta_Ciclo         
              INTO vColeta,
                   vCiclo 
              FROM tdvadm.T_CON_CONHECIMENTO KK
             WHERE KK.CON_CONHECIMENTO_CODIGO = P_CTRC
               AND KK.CON_CONHECIMENTO_SERIE  = P_SERIE
               AND KK.GLB_ROTA_CODIGO         = P_ROTA ;

                   
              
               INSERT INTO T_CON_NFTRANSPORTA 
                SELECT P_CTRC                          ,
                       P_SERIE                         ,
                       P_ROTA                          ,
                       TR.CON_NFTRANSPORTADA_NUMNFISCAL,
                       TR.GLB_EMBALAGEM_CODIGO         ,
                       TR.CON_NFTRANSPORTADA_VALOR     ,
                       TR.CON_NFTRANSPORTADA_VOLUMES   ,
                       TR.CON_NFTRANSPORTADA_PESO      ,
                       TR.CON_NFTRANSPORTADA_UNIDADE   ,
                       TR.CON_NFTRANSPORTADA_NUMERO    ,
                       TR.CON_NFTTRANSPORTA_MERCADORIA ,
                       TR.GLB_CLIENTE_CGCCPFCODIGO     ,
                       TR.CON_NFTRANSPORTADA_VALORSEG  ,
                       TR.CON_NFTRANSPORTADA_PESOCOBRADO,
                       TR.CON_NFTRANSPORTADA_LARGURA   ,
                       TR.CON_NFTRANSPORTADA_ALTURA    ,
                       TR.CON_NFTRANSPORTADA_COMPRIMENTO,
                       TR.CON_NFTRANSPORTADA_CUBAGEM   ,
                       TR.CON_NFTRANSPORTADA_REMONTA   ,
                       TR.CON_NFTRANSPORTADA_PESOCUBADO,
                       TR.CON_NFTRANSPORTADA_ARMAZEM   ,
                       TR.GLB_CFOP_CODIGO              ,
                       TR.CON_NFTRANSPORTADA_VALORBSICMS,
                       TR.CON_NFTRANSPORTADA_VALORICMS ,
                       TR.CON_NFTRANSPORTADA_VLBSICMSST,
                       TR.CON_NFTRANSPORTADA_VLICMSST  ,
                       TR.CON_NFTRANSPORTADA_CHAVENFE  ,
                       TR.CON_TPDOC_CODIGO             ,
                       TR.CON_NFTRANSPORTADA_DTEMISSAO ,
                       TR.CON_NFTRANSPORTADA_DTSAIDA   ,
                       TR.CON_NFTRANSPORTADA_SERIENF   ,
                       TR.GLB_ONU_CODIGO               ,
                       TR.GLB_ONU_GRPEMB,
                       vColeta,
                       vCiclo
                  FROM T_CON_NFTRANSPORTA TR
                 WHERE TR.CON_CONHECIMENTO_CODIGO = vCteCompNume 
                   AND TR.CON_CONHECIMENTO_SERIE  = vCteCompSerie
                   AND TR.GLB_ROTA_CODIGO         = vCteCompRota ;
                                  
            P_STATUS  := pkg_glb_common.Status_Nomal;
            P_MESSAGE := 'Processamento Normal.';     
            
            commit;                 

       else
         
          P_STATUS  := pkg_glb_common.Status_Nomal;
          P_MESSAGE := 'Processamento Normal.';
        
       end if;        
       /*************************************************/
      
    EXCEPTION WHEN OTHERS THEN
        P_STATUS  := pkg_glb_common.Status_Erro;
        P_MESSAGE := 'Erro ao processar. Erro:'||sqlerrm;
     
    END;   
      
  END SP_CON_CTECOMNF;
    
  FUNCTION FN_CTEEXISTREDES(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE, 
                            P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE, 
                            P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) RETURN VARCHAR2 IS
  vExisteRedesp INTEGER;
  BEGIN

   BEGIN
     SELECT COUNT(*)
       INTO vExisteRedesp 
       FROM V_CTE_12200 R
      WHERE R.CON_CONHECIMENTO_CODIGO = P_CTRC
        AND R.CON_CONHECIMENTO_SERIE  = P_SERIE
        AND R.GLB_ROTA_CODIGO         = P_ROTA;    
   EXCEPTION WHEN OTHERS THEN
     vExisteRedesp := 0; 
   END;  

  IF vExisteRedesp > 0 THEN
     RETURN 'SIM';
  ELSE
    RETURN 'NAO';
  END IF;
 END FN_CTEEXISTREDES; 
  
  PROCEDURE SP_CON_VALIDASACADO(P_CTRC    IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                P_SERIE   IN  T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                P_ROTA    IN  T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                P_STATUS  OUT CHAR,
                                P_MESSAGE OUT VARCHAR2) AS
  
  V_CLIENTE_SITUACAO CHAR(1);
  V_REGIMEESP_VP     T_GLB_CLIENTE.GLB_CLIENTE_REGIMEESPVP%TYPE;
  V_VLRLIMITE        T_GLB_CLIENTE.GLB_CLIENTE_VLRLIMITE%TYPE;
  V_VLTOTVENC        T_GLB_CLIENTE.GLB_CLIENTE_VLTOTVENC%TYPE;
  vCnpjSacado        T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%type;
  BEGIN

    BEGIN
      SELECT C.GLB_CLIENTE_SITUACAO   ,
             C.GLB_CLIENTE_REGIMEESPVP,
             C.GLB_CLIENTE_VLRLIMITE  ,
             C.GLB_CLIENTE_VLTOTVENC  ,
             c.glb_cliente_cgccpfcodigo
        INTO V_CLIENTE_SITUACAO       , 
             V_REGIMEESP_VP           , 
             V_VLRLIMITE              ,
             V_VLTOTVENC              ,
             vCnpjSacado
        FROM T_GLB_CLIENTE C,
             T_CON_CONHECIMENTO CH
       WHERE C.GLB_CLIENTE_CGCCPFCODIGO = CH.GLB_CLIENTE_CGCCPFSACADO
         AND CH.CON_CONHECIMENTO_CODIGO = P_CTRC 
         AND CH.CON_CONHECIMENTO_SERIE  = P_SERIE
         AND CH.GLB_ROTA_CODIGO         = P_ROTA;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CLIENTE_SITUACAO := 'N';
        V_REGIMEESP_VP     := NULL;
    END;

    IF (V_CLIENTE_SITUACAO = 'I') THEN
        P_STATUS := pkg_glb_common.Status_Erro; 
        P_MESSAGE := 'CNPJ : ' ||TRIM(vCnpjSacado) ||
                     ', BLOQUEADO PELA MATRIZ, N√O EMITIR DOCUMENTO.... CTRC/ROTA' ||
                     P_CTRC || '/' || P_SERIE || '/' ||P_ROTA;            
        return;             
    END IF;
    
    
    IF (V_VLRLIMITE <= V_VLTOTVENC) then
        P_STATUS := pkg_glb_common.Status_Erro;
        P_MESSAGE := 'SACADO '||trim(vCnpjSacado)||
                     ' ATINGIU SEU LIMITE PROCURE O SETOR CONTAS A RECEBER NA MATRIZ' ||CHR(10) || 
                     ' SALDO RESTANTE ' ||TO_CHAR(V_VLRLIMITE - V_VLTOTVENC,'999,999,990.00');
        return;
    END IF;
    
    if nvl(P_STATUS,'NULL') = 'NULL' THEN
       P_STATUS  := pkg_glb_common.Status_Nomal;
       P_MESSAGE := 'Processamento Normal!';
    END IF;  
    
 END SP_CON_VALIDASACADO; 
 
  PROCEDURE SP_CON_LIMPALOGREENV AS
  /****************************************************************************************************
  * ROTINA           : SP_CON_LIMPALOGREENV                                                          *
  * PROGRAMA         : LIMPA LISTA DE REENVIO DOS CTE¥S QUE JA FORAM AUTORIZADOS                     *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 11/04/2013                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : Job Oracle                                                                    * 
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : LIMPA LISTA DE REENVIO DOS CTE¥S QUE JA FORAM AUTORIZADOS                     *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  :                                                                               *
  ****************************************************************************************************/

    vCteAceito integer;
    vExisteCte integer;
    BEGIN

           /**************************************************/
           /******** CURSOR COM A LISTA DOS REENVIADOS *******/
           /**************************************************/
          FOR P_CURSOR IN (SELECT DISTINCT L.CON_CONHECIMENTO_CODIGO,
                                           L.CON_CONHECIMENTO_SERIE,
                                           L.GLB_ROTA_CODIGO
                            FROM T_UTI_LOGREENVCTE L)
          LOOP



           /**************************************************/
           /************** SE EXISTE O DOCUMENTO     *********/
           /**************************************************/
            SELECT COUNT(*)
              INTO vExisteCte
              FROM T_CON_CONHECIMENTO CH
             WHERE CH.CON_CONHECIMENTO_CODIGO    = P_CURSOR.CON_CONHECIMENTO_CODIGO
               AND CH.CON_CONHECIMENTO_SERIE     = P_CURSOR.CON_CONHECIMENTO_SERIE
               AND CH.GLB_ROTA_CODIGO            = P_CURSOR.GLB_ROTA_CODIGO;


           /**************************************************/
           /**************     SE ESTA ACEITO        *********/
           /**************************************************/
            SELECT COUNT(*)
              INTO vCteAceito
              FROM T_CON_CONTROLECTRCE L
             WHERE L.CON_CONHECIMENTO_CODIGO    = P_CURSOR.CON_CONHECIMENTO_CODIGO
               AND L.CON_CONHECIMENTO_SERIE     = P_CURSOR.CON_CONHECIMENTO_SERIE
               AND L.GLB_ROTA_CODIGO            = P_CURSOR.GLB_ROTA_CODIGO
               AND L.CON_CONTROLECTRCE_CODSTENV = '100';


            
           /**************************************************/
           /*SE TIVER NAS CONDI«’ES APAGO DA LISTA DE REENVIO*/
           /**************************************************/
            
            IF (vExisteCte > 0) AND (vCteAceito > 0) THEN

              DELETE T_UTI_LOGREENVCTE K
               WHERE K.CON_CONHECIMENTO_CODIGO = P_CURSOR.CON_CONHECIMENTO_CODIGO
                 AND K.CON_CONHECIMENTO_SERIE  = P_CURSOR.CON_CONHECIMENTO_SERIE
                 AND K.GLB_ROTA_CODIGO         = P_CURSOR.GLB_ROTA_CODIGO;

            ELSIF (vExisteCte = 0) AND (vCteAceito = 0) THEN 
              
              DELETE T_UTI_LOGREENVCTE K
               WHERE K.CON_CONHECIMENTO_CODIGO = P_CURSOR.CON_CONHECIMENTO_CODIGO
                 AND K.CON_CONHECIMENTO_SERIE  = P_CURSOR.CON_CONHECIMENTO_SERIE
                 AND K.GLB_ROTA_CODIGO         = P_CURSOR.GLB_ROTA_CODIGO;
              
            END IF;

          END LOOP;

          COMMIT;
  END SP_CON_LIMPALOGREENV;
  
  PROCEDURE SP_CON_CTESEMRESP AS
  /****************************************************************************************************
   * ROTINA           : SP_CON_CTESEMRESP                                                             *
   * PROGRAMA         : SP_CON_CTESEMRESP                                                             *
   * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
   * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
   * DATA DE CRIACAO  : 28/03/2011                                                                    *
   * BANCO            : ORACLE-TDP                                                                    *
   * EXECUTADO POR    : JOB PARA VERIFICAR OS CTE¥S N√O RESPONDIDOS                                   *
   * ALIMENTA         :                                                                               *
   * FUNCINALIDADE    : ATUALIZAR OS CT¥S N√O RESPONDIDOS PELA NDD                                    *
   * ATUALIZA         : T_CON_CONTROLECTRCE                                                           *
   * PARTICULARIDADES :                                                                               *                                           
   * PARAM. OBRIGAT.  :                                                                               *
   ****************************************************************************************************/
  vExisteCold   integer;
  vXmlAut       clob;
  vProtocolo    t_con_controlectrce.con_controlectrce_nprotenv%type;
  vDataRetorno  t_con_controlectrce.con_controlectrce_dtretorno%type;
  vChaveCte     t_con_controlectrce.con_controlectrce_chavesefaz%type;
  vCodSt        char(3);  
  vMensagem     varchar2(500);
  vChaveGerada  varchar2(44);
  vStatus       char(1);
  vMsgProcess   varchar2(2000);
  BEGIN
       -- CURSOR COM OS CT¥S QUE N√O FORAM RESPONDIDOS PELA A NDD A MAIS QUE 10 MINUTOS
       FOR R_CTE IN (SELECT C.CON_CONHECIMENTO_CODIGO,
                            C.CON_CONHECIMENTO_SERIE,
                            C.GLB_ROTA_CODIGO,
                            C.CON_CONHECIMENTO_DTEMBARQUE
                       FROM T_CON_CONTROLECTRCE C
                      WHERE C.CON_CONTROLECTRCE_DTGERACAO          IS NOT NULL
                        AND C.CON_CONTROLECTRCE_DTRETORNO          IS NULL
                        AND C.CON_CONHECIMENTO_DTEMBARQUE          >= '01/01/2011'
                      UNION
                     SELECT C.CON_CONHECIMENTO_CODIGO,
                            C.CON_CONHECIMENTO_SERIE,
                            C.GLB_ROTA_CODIGO,
                            C.CON_CONHECIMENTO_DTEMBARQUE
                       FROM T_CON_CONTROLECTRCE C
                      WHERE C.CON_CONTROLECTRCE_DTGERACAO           IS NOT NULL
                        AND C.CON_CONTROLECTRCE_DTRETORNO           IS NOT NULL
                        AND NVL(C.CON_CONTROLECTRCE_CODSTENV,'000') <> '100'
                        AND (SYSDATE-C.CON_CONTROLECTRCE_DTGERACAO) >=(((1/2)/60)/24)
                        AND C.CON_CONHECIMENTO_DTEMBARQUE           >= '01/01/2012'
                      )
       LOOP
           
           begin
             
             -- VERIFICO SE O CTE EXISTE NA TABELA DE ARAMAZENAMENTO DA SOLU«√O
             BEGIN
                  SELECT COUNT(*)
                    INTO vExisteCold
                    FROM NDD_NEW.COLD_PRODUCAO CL
                   WHERE CL.IDE_SERIE = TO_NUMBER(R_CTE.GLB_ROTA_CODIGO)
                     AND CL.IDE_NCT = TO_NUMBER(R_CTE.CON_CONHECIMENTO_CODIGO);
             EXCEPTION WHEN OTHERS THEN
                vExisteCold := 0;
             END;
             
             -- SE EXISTE TENTO ATUALIZAR NOSSA TABELA
             IF vExisteCold >= 1 THEN
    
               /***********************************************/  
               /**          BUSCANDO XML DO COLD             **/
               /***********************************************/
--               SELECT SYS.XMLTYPE.CREATEXML(CO.XML_AUT)
               SELECT CO.XML_AUT
                 INTO vXmlAut
                 FROM NDD_NEW.COLD_PRODUCAO CO
                WHERE CO.IDE_SERIE   = TO_NUMBER(R_CTE.GLB_ROTA_CODIGO)
                  AND CO.IDE_NCT     = TO_NUMBER(R_CTE.CON_CONHECIMENTO_CODIGO)
                  AND CO.DOCSEQUENCE = 1;
               
               /***********************************************/
               /**          EXTRAINDO INFORMA«’ES            **/
               /***********************************************/
               select EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/chCTe' ,'xmlns="http://www.portalfiscal.inf.br/cte"'),
                      EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/nProt'  ,'xmlns="http://www.portalfiscal.inf.br/cte"'),
                      EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/cStat'  ,'xmlns="http://www.portalfiscal.inf.br/cte"'),
                      EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/xMotivo'  ,'xmlns="http://www.portalfiscal.inf.br/cte"')
                 into vChaveCte                                                 ,
                      vProtocolo                                                ,
                      vCodSt                                                ,
                      vMensagem
                 from dual; 
               
               
               if (vChaveCte is null) then
                 
                 select EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/chCTe'),
                        EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/nProt'),
                        EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/cStat'),
                        EXTRACTVALUE(XMLTYPE.createxml(vXmlAut), '/infProt/xMotivo')
                   into vChaveCte                                                 ,
                        vProtocolo                                                ,
                        vCodSt                                                ,
                        vMensagem
                   from dual; 
                 
               end if;      
               
               /***********************************************/
               /**    ATU. INFORMA«’ES NA TABELA DE CONTROLE **/
               /***********************************************/
               vChaveGerada := pkg_con_cte.fn_cte_getchavesefaz(vChaveCte);

               update t_con_controlectrce cc
                  set cc.con_controlectrce_nprotenv   = vProtocolo,  
                      cc.con_controlectrce_codstenv   = vCodSt,
                      cc.con_controlectrce_dtretorno  = sysdate,
                      cc.con_controlectrce_status     = decode(vCodSt,'100','OK','RJ'),
                      cc.con_controlectrce_xmlretenv  = vXmlAut,
                      cc.con_controlectrce_chavesefaz = vChaveCte
                where cc.con_controlectrce_chavesefaz = vChaveGerada;    
               
               COMMIT;

             END IF;  
             
           exception when others then
             
             vStatus     := 'E';    
             vMsgProcess := trim(vMsgProcess||chr(13)||' Erro ao processar CTe.: '||R_CTE.CON_CONHECIMENTO_CODIGO||' - '||R_CTE.CON_CONHECIMENTO_SERIE||' - '||R_CTE.GLB_ROTA_CODIGO||' - Erro.: '||dbms_utility.format_error_backtrace); 
           
           end;
            
       END LOOP;
       
       if (nvl(vStatus,'N') <> 'N') then
              
          
          wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro rotina pkg_con_cte.sp_con_ctesemresp.',
                                               vMsgProcess,
                                               'tdv.operacao@dellavolpe.com.br',
                                               'grp.hd@dellavolpe.com.br',
                                               'ksouza@dellavolpe.com.br');
                                                
                                                
              
       end if;
       
  END SP_CON_CTESEMRESP;
    
  PROCEDURE SP_CON_LISTACTENAOACEITOS(P_CURSOR   OUT T_CURSOR,
                                      P_STATUS   OUT CHAR,
                                      P_MESSAGE  OUT VARCHAR2)AS
  BEGIN
    BEGIN
    	OPEN P_CURSOR FOR
      SELECT A.CON_CONHECIMENTO_CODIGO "Cte",
             A.CON_CONHECIMENTO_SERIE "Serie",
             A.GLB_ROTA_CODIGO "Rota",
             nvl(A.CON_CONHECIMENTO_FLAGCANCELADO,'N') "Cancelado",
             A.CON_CONHECIMENTO_DTEMBARQUE "DtEmbarque",
             it.CON_CALCVIAGEM_VALOR "ValorConhec",
             U.USU_USUARIO_CODIGO||' - '|| INITCAP(LOWER(U.USU_USUARIO_NOME)) "Emissor"       
        FROM T_CON_CONHECIMENTO A,
             v_con_i_ttpv it,
             T_USU_USUARIO U
       WHERE to_char(trunc(A.CON_CONHECIMENTO_DTEMBARQUE),'YYYYMM') BETWEEN TO_CHAR(TRUNC(SYSDATE-31),'YYYYMM') AND  TO_CHAR(TRUNC(SYSDATE),'YYYYMM')  
         AND A.CON_CONHECIMENTO_SERIE <> 'XXX'
         AND FN_CTE_EELETRONICO(A.CON_CONHECIMENTO_CODIGO, A.CON_CONHECIMENTO_SERIE, A.GLB_ROTA_CODIGO) = 'N'
         and a.con_conhecimento_codigo = it.CON_CONHECIMENTO_CODIGO
         and a.con_conhecimento_serie  = it.CON_CONHECIMENTO_SERIE
         and a.glb_rota_codigo         = it.GLB_ROTA_CODIGO
         AND TRIM(A.CON_CONHECIMENTO_EMISSOR) = TRIM(U.USU_USUARIO_CODIGO(+))
         AND TRUNC(A.CON_CONHECIMENTO_DTEMBARQUE) < TRUNC(SYSDATE);

    EXCEPTION WHEN OTHERS THEN
      P_STATUS  := pkg_glb_common.Status_Erro; 
      P_MESSAGE := 'ERRO AO CONSULTAR PARCEIROS NOTA. ERRO= '||SQLERRM;
    END;
       
    P_STATUS  := pkg_glb_common.Status_Nomal; 
    P_MESSAGE := 'Processamento Normal!';
      
  END SP_CON_LISTACTENAOACEITOS;      
  
  PROCEDURE SP_CON_AVISACTENACEITO AS
  vCursor      PKG_EDI_PLANILHA.T_CURSOR;
  vLinha       pkg_glb_SqlCursor.tpString1024;
  vCorpoEmail  Clob;
  BEGIN

    /******************************************************/
    /**     LOOP PARA MONTAR O E-MAIL DE RETORNO         **/
    /******************************************************/
    begin
      
      open vCursor FOR SELECT A.CON_CONHECIMENTO_CODIGO "Cte",
                              A.CON_CONHECIMENTO_SERIE "Serie",
                              A.GLB_ROTA_CODIGO "Rota",
                              nvl(A.CON_CONHECIMENTO_FLAGCANCELADO,'N') "Cancelado",
                              A.CON_CONHECIMENTO_DTEMBARQUE "DtEmbarque",
                              it.CON_CALCVIAGEM_VALOR "ValorConhec",
                              U.USU_USUARIO_CODIGO||' - '|| INITCAP(LOWER(U.USU_USUARIO_NOME)) "Emissor"
                              
                         FROM T_CON_CONHECIMENTO A,
                              v_con_i_ttpv it,
                              T_USU_USUARIO U
                        WHERE to_char(trunc(A.CON_CONHECIMENTO_DTEMBARQUE),'YYYYMM') BETWEEN TO_CHAR(TRUNC(SYSDATE-60),'YYYYMM') AND  TO_CHAR(TRUNC(SYSDATE),'YYYYMM')  
                          AND A.CON_CONHECIMENTO_SERIE <> 'XXX'
                          AND FN_CTE_EELETRONICO(A.CON_CONHECIMENTO_CODIGO, A.CON_CONHECIMENTO_SERIE, A.GLB_ROTA_CODIGO) = 'N'
                          and a.con_conhecimento_codigo = it.CON_CONHECIMENTO_CODIGO
                          and a.con_conhecimento_serie  = it.CON_CONHECIMENTO_SERIE
                          and a.glb_rota_codigo         = it.GLB_ROTA_CODIGO
                          AND TRIM(A.CON_CONHECIMENTO_EMISSOR) = TRIM(U.USU_USUARIO_CODIGO(+))
                          AND NVL(A.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N'
                          AND TRUNC(A.CON_CONHECIMENTO_DTEMBARQUE) < TRUNC(SYSDATE);

      pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
      pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';

  /*    pkg_glb_SqlCursor.TipoHederHTML.Tamanho := 100;
      pkg_glb_SqlCursor.TipoHederHTML.TipoTamanho := '%';
      pkg_glb_SqlCursor.TipoColunaHTML.Tamanho := 100;
      pkg_glb_SqlCursor.TipoColunaHTML.TipoTamanho := '%';
  */
      pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha);

      vCorpoEmail := vCorpoEmail ||  'LISTA DE CTE NAO ACEITOS. <br />';

      for i in 1 .. vLinha.count loop
         if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
            vCorpoEmail := vCorpoEmail || vLinha(i);
         Else
            vCorpoEmail := vCorpoEmail || vLinha(i) || chr(10);
         End if;
      End loop;
      
    end;
    /******************************************************/
    
    wservice.pkg_glb_email.SP_ENVIAEMAIL('Cte¥s n„o aceitos.',
                                         vCorpoEmail,
                                         'tdv.operacao@dellavolpe.com.br',
                                         'jmoreira@dellavolpe.com.br',
                                         'rcarvalho@dellavolpe.com.br',
                                         'ksouza@dellavolpe.com.br');
    
  END SP_CON_AVISACTENACEITO;   
  
  function fn_cte_emailenviado(p_ctrc  in t_con_conhecimento.con_conhecimento_codigo%type,
                               p_serie in t_con_conhecimento.con_conhecimento_serie%type,
                               p_rota  in t_con_conhecimento.glb_rota_codigo%type) RETURN CHAR IS
  vDocEnviado integer;
  begin

      begin
        
        select (SELECT COUNT(*)
                  FROM ndd_new.tblogdocmeSSAGE msg
                 WHERE msg.logdocid = doc.logdocid
                   AND msg.msgcode = '55')
               into vDocEnviado
          from ndd_new.tblogdocument doc
         WHERE doc.DOCUMENTNUMBER || doc.serie = to_number(p_ctrc) || to_number(p_rota);
     
       if vDocEnviado > 0 then
         return 'Documento Enviado por e-mail com sucesso!';
       else
         return 'Documento n„o enviado!';	
       end if;
     
     exception when others then
         return 'Documento n„o enviado!';
     end;      


  end fn_cte_emailenviado;                             
  
  FUNCTION FN_CTE_EELETRONICO(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                              P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                              P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR IS
  V_STATUS  T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CODSTENV%TYPE;
  V_ROTACTE T_GLB_ROTA.GLB_ROTA_CTE%TYPE;
  V_NUNINIC T_GLB_ROTA.GLB_ROTA_CTENUMINICIO%TYPE;
  V_RETURN  CHAR;
  V_IMPRESSO T_CON_CONHECIMENTO.CON_CONHECIMENTO_DIGITADO%TYPE;
  vCalculoICMS char;
  
  BEGIN
        
       
        SELECT NVL(RT.GLB_ROTA_CTE,'N'),
               RT.GLB_ROTA_CTENUMINICIO
          INTO V_ROTACTE,
               V_NUNINIC
          FROM T_GLB_ROTA RT
          WHERE RT.GLB_ROTA_CODIGO = P_ROTA;

        -- Sirlano 21/11/2016
        -- Para verificar se foi feito algum calculo de ICMS em ROTA de ISS


        If F_BUSCA_CONHEC_TPFORM(P_CTE,P_SERIE,P_ROTA) = 'C' Then
           vCalculoICMS := 'S';
        Else
           vCalculoICMS := 'N';
        End If;

        
        IF ( ( (V_ROTACTE = 'S') AND ( P_CTE > V_NUNINIC) ) or 
           ( vCalculoICMS = 'S' ) ) THEN
          BEGIN
            -- Sirlano 17/05/2014
            -- Coloquei a Sequencia e Status 
            -- estava retornando mais que uma linha
            -- cte '531243','531244','531245' Rota '021'
          SELECT NVL(C.CON_CONTROLECTRCE_CODSTENV,'000')
            INTO V_STATUS
            FROM T_CON_CONTROLECTRCE C
           WHERE C.CON_CONHECIMENTO_CODIGO = P_CTE
             AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
             AND C.GLB_ROTA_CODIGO         = P_ROTA
             AND C.CON_CONTROLECTRCE_SEQUENCIA = 1
/*             AND C.CON_CONTROLECTRCE_STATUS <> 'AG'
             AND C.CON_CONTROLECTRCE_SEQUENCIA = (SELECT MAX(C1.CON_CONTROLECTRCE_SEQUENCIA)
                                                  FROM T_CON_CONTROLECTRCE C1
                                                  WHERE C1.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
                                                    AND C1.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
                                                    AND C1.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
                                                    AND C1.CON_CONTROLECTRCE_STATUS <> 'AG')*/;
          EXCEPTION
            WHEN TOO_MANY_ROWS THEN
              RAISE_APPLICATION_ERROR(-20001, SQLERRM || ' CTRC: ' || P_CTE || ' ' || P_SERIE || ' ' || P_ROTA);
          WHEN NO_DATA_FOUND THEN
              V_STATUS:= '000';
          END;

         
          IF V_STATUS in ('100','301')THEN
             V_RETURN:= 'S';
          ELSIF V_STATUS not in ('100','301') THEN
             V_RETURN:= 'N';
          END IF;
        
        ELSIF ( ( (V_ROTACTE = 'S') AND ( P_CTE < V_NUNINIC) ) OR
             ( vCalculoICMS = 'S' ) )  THEN 
             V_RETURN:= 'S';
        ELSIF vCalculoICMS = 'N' THEN 
             V_RETURN:= 'S';
        END IF;
        
        IF P_ROTA IN ('161','461','188','028','033') THEN
           V_RETURN:= 'S';
        END IF;
        
        SELECT C.CON_CONHECIMENTO_DIGITADO
          INTO V_IMPRESSO 
          FROM T_CON_CONHECIMENTO C
          WHERE C.CON_CONHECIMENTO_CODIGO = P_CTE
            AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
            AND C.GLB_ROTA_CODIGO         = P_ROTA;
        
        -- CONHECIMENTOS INUTILIZADOS TERAO QUE RETONAR COMO ELETRONICOS, PARA SUBIR PARA O LIVRO FISCAL COMO CNACELADOS POR INUT.
        IF (NVL(V_IMPRESSO,'D') = 'N') AND (V_ROTACTE = 'S') THEN
           V_RETURN := 'S';
        END IF;  
        
        RETURN V_RETURN;
  END FN_CTE_EELETRONICO;
  
  FUNCTION FN_CTE_CONFIRMAIMPOSTOS(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                   P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR IS
  V_IMPOSTOS T_SLF_TPCALCULO.SLF_TPCALCULO_FORMULARIO%TYPE;

  BEGIN
     -- Retorno
     -- (C) Conhecimento de Transporte
     -- (N) Nota fiscal de Servico
     -- (X) Documento ou Calculo  N„o encontrado
    
     BEGIN
         SELECT NVL(TPCA.SLF_TPCALCULO_FORMULARIO,'X')
           INTO V_IMPOSTOS
         FROM T_CON_CALCCONHECIMENTO CA,
              T_SLF_TPCALCULO TPCA
         WHERE CA.CON_CONHECIMENTO_CODIGO = P_CTE
           AND CA.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND CA.GLB_ROTA_CODIGO         = P_ROTA
           AND CA.SLF_RECCUST_CODIGO = 'I_TTPV'
           AND CA.SLF_TPCALCULO_CODIGO = TPCA.SLF_TPCALCULO_CODIGO
           AND TPCA.SLF_TPCALCULO_CALCULOMAE = 'S';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_IMPOSTOS := 'X';
        END;     
       
      RETURN V_IMPOSTOS;  
  
  END FN_CTE_CONFIRMAIMPOSTOS;              
  
  
  Procedure sp_CteProcessaEnviado(p_arquivo  in varchar2,
                                  p_status   out char,
                                  p_message  out varchar2)as
  vCteCodigo     t_con_conhecimento.con_conhecimento_codigo%type;
  vCteSerie      t_con_conhecimento.con_conhecimento_serie%type;
  vCteRota       t_con_conhecimento.glb_rota_codigo%type;
  vExisteCte     integer;
  vExisteEnviado integer;
  
  begin
   
   
    begin
    
      select l.con_conhecimento_codigo,
             l.con_conhecimento_serie,
             l.glb_rota_codigo,
             1
        into vCteCodigo,  
             vCteSerie, 
             vCteRota,
             vExisteCte
        from t_con_controlectrce l
       where l.con_controlectrce_chavesefaz = substr(p_arquivo,4,44);
       --CTe35140661139432000172570210005362721967002120_procCTe.xml
    
    exception when no_data_found then
      vExisteCte := 0;
    end;
    
    
    if vExisteCte = 0 then
       
       p_status   := pkg_glb_common.Status_Warning;    
       p_message := 'Nao foi possivel identificar o CTe atraves desse nome de arquivo.: ' || trim(p_arquivo);
       
    else
       
       select count(*) 
         into vExisteEnviado
         from t_con_cteenvio cc
        where cc.con_conhecimento_codigo = vCteCodigo
          and cc.con_conhecimento_serie  = vCteSerie 
          and cc.glb_rota_codigo         = vCteRota
          and cc.glb_formaenvio_codigo   = 5;
         
       if (vExisteEnviado = 0) then
           insert into tdvadm.t_con_cteenvio
             (con_conhecimento_codigo,
              con_conhecimento_serie,
              glb_rota_codigo,
              glb_formaenvio_codigo,
              con_cteenvio_dtenvio)
           values
             (vCteCodigo,
              vCteSerie, 
              vCteRota, 
              5, 
              sysdate);
              
           p_status   := pkg_glb_common.Status_Nomal;
           p_message  := 'Cte.: '||vCteCodigo||'_'||vCteSerie||'_'||vCteRota|| ' processado com sucesso!';  
           
              
       else
           
           update t_con_cteenvio f
              set f.con_cteenvio_dtenvio    = sysdate
            where f.con_conhecimento_codigo = vCteCodigo     
              and f.con_conhecimento_serie  = vCteSerie
              and f.glb_rota_codigo         = vCteRota
              and f.glb_formaenvio_codigo   = 5;
              
              
           p_status   := pkg_glb_common.Status_Nomal;
           p_message  := 'Cte.: '||vCteCodigo||'_'||vCteSerie||'_'||vCteRota||' reprocessado com sucesso!';     
              
       end if;
        
    end if;    
      
  end  sp_CteProcessaEnviado;                                  
   
  Procedure sp_CteProcessaEnviadoCont(p_arquivo  in varchar2,
                                      p_data     in varchar2,
                                      p_status   out char,
                                      p_message  out varchar2)as
  vCteCodigo     t_con_conhecimento.con_conhecimento_codigo%type;
  vCteSerie      t_con_conhecimento.con_conhecimento_serie%type;
  vCteRota       t_con_conhecimento.glb_rota_codigo%type;
  vExisteCte     integer;
  vExisteEnviado integer;
  vData          date;   
  begin
   
  
    /*************************/
    /*** se cte existe      **/
    /*************************/
    begin
    
      select l.con_conhecimento_codigo,
             l.con_conhecimento_serie,
             l.glb_rota_codigo,
             1
        into vCteCodigo,  
             vCteSerie, 
             vCteRota,
             vExisteCte
        from t_con_controlectrce l
       where l.con_controlectrce_chavesefaz = substr(p_arquivo,4,44);
       --CTe35140661139432000172570210005362721967002120_procCTe.xml
      
    exception when no_data_found then
      vExisteCte := 0;
    end;
    
    /*************************/
    /** formatacao data     **/
    /*************************/
    begin
      
      vData := to_date(p_data,'dd/mm/yyyy hh24:mi:ss');   
     
    exception when others then
      vData := sysdate;
    end;  
        
    /*************************/
    /** processamento do CTe**/
    /*************************/
    if vExisteCte = 0 then
       
       p_status   := pkg_glb_common.Status_Warning;    
       p_message := 'Nao foi possivel identificar o CTe atraves desse nome de arquivo.: ' || trim(p_arquivo);
       
    else
       
       select count(*) 
         into vExisteEnviado
         from t_con_cteenvio cc
        where cc.con_conhecimento_codigo = vCteCodigo
          and cc.con_conhecimento_serie  = vCteSerie 
          and cc.glb_rota_codigo         = vCteRota;
         
       if (vExisteEnviado = 0) then
           insert into t_con_cteenvio
             (con_conhecimento_codigo,
              con_conhecimento_serie,
              glb_rota_codigo,
              glb_formaenvio_codigo,
              con_cteenvio_dtenvio)
           values
             (vCteCodigo,
              vCteSerie, 
              vCteRota, 
              5, 
              vData);
              
           p_status   := pkg_glb_common.Status_Nomal;
           p_message  := 'Cte.: '||vCteCodigo||'_'||vCteSerie||'_'||vCteRota|| ' processado com sucesso!';  
           
              
       else
           
           update t_con_cteenvio f
              set f.con_cteenvio_dtenvio    = vData
            where f.con_conhecimento_codigo = vCteCodigo     
              and f.con_conhecimento_serie  = vCteSerie
              and f.glb_rota_codigo         = vCteRota
              and f.glb_formaenvio_codigo   = 5;
              
              
           p_status   := pkg_glb_common.Status_Nomal;
           p_message  := 'Cte.: '||vCteCodigo||'_'||vCteSerie||'_'||vCteRota||' reprocessado com sucesso!';     
              
       end if;
        
    end if;    
      
  end  sp_CteProcessaEnviadoCont;                                 
  
  Procedure sp_CteDataBaseOK(p_status   out char,
                             p_message  out varchar2)as
  vData date;
  begin
    
    begin
      
      select sysdate
        into vData  
        from dual;
      
      p_status      := pkg_glb_common.Status_Nomal; 
      p_message     := 'Processamento normal.';
    
    exception when others then
        p_status  := pkg_glb_common.Status_Erro; 
        p_message := 'Erro ao processar, Erro.: '||sqlerrm;
    end;
      
  end sp_CteDataBaseOK;                            
  
  Procedure Sp_CtePodeEnviar(p_arquivo  in varchar2,
                             p_status   out char,
                             p_message  out varchar2)as
  vChaveCte          t_con_controlectrce.con_controlectrce_chavesefaz%type;
  vCteCodigo         t_con_controlectrce.con_conhecimento_codigo%TYPE;
  vCteSerie          t_con_controlectrce.con_conhecimento_serie%TYPE;
  vCteRota           t_con_controlectrce.glb_rota_codigo%TYPE;
  vExisteCte         integer;
  vXmlColeta         t_xml_coleta.xml_coleta_numero%type;
  vNunColetaDef      t_xml_coleta.xml_coleta_numero%type := '9999999999';
  vPodeEnviar        integer;
  vGrupoEconomico    t_glb_cliente.glb_grupoeconomico_codigo%type;
  begin

      begin
        
          vChaveCte := substr(p_arquivo,4,44);
          
          begin
            
            select l.con_conhecimento_codigo,
                   l.con_conhecimento_serie,
                   l.glb_rota_codigo,
                   1
              into vCteCodigo,  
                   vCteSerie, 
                   vCteRota,
                   vExisteCte
              from t_con_controlectrce l
             where l.con_controlectrce_chavesefaz = vChaveCte;

          exception when others then
             
             vExisteCte := 0;
          
          end;
          
          if (vExisteCte > 0 ) then
            
             begin
               
               select nvl(ar.xml_coleta_numero,vNunColetaDef),
                      cl.glb_grupoeconomico_codigo
                 into vXmlColeta,
                      vGrupoEconomico
                 from t_con_conhecimento ch,
                      t_arm_coleta       ar,
                      t_glb_cliente      cl
                where ch.con_conhecimento_codigo  = vCteCodigo       
                  and ch.con_conhecimento_serie   = vCteSerie
                  and ch.glb_rota_codigo          = vCteRota
                  and ch.arm_coleta_ncompra       = ar.arm_coleta_ncompra
                  and ch.arm_coleta_ciclo         = ar.arm_coleta_ciclo
                  and ch.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo;
             
             exception when others then
                
                vXmlColeta := vNunColetaDef;
                
             end;
             
             if (vXmlColeta <> vNunColetaDef) then
               
                -- Busca por coletado via Quadrem
                select count(*) 
                  into vPodeEnviar
                  from t_xml_coleta col
                 where col.xml_coleta_numero                   = vXmlColeta
                   and col.xml_coleta_tipocoleta               = 'Received'
                   and col.xml_coleta_tipodoc                  = 'ASNR'
                   and col.xml_coleta_status	                 = 'OK'
                   and (sysdate -  col.xml_coleta_aprovacao)   > glbadm.PKG_Glb_DateUtil.fn_CalculaIntervalo(30,'M') 
                   and col.xml_coleta_sequencia                = (select min(col.xml_coleta_sequencia)  
                                                                    from t_xml_coleta col
                                                                   where col.xml_coleta_numero                   = vXmlColeta
                                                                     and col.xml_coleta_tipocoleta               = 'Received'
                                                                     and col.xml_coleta_tipodoc                  = 'ASNR'
                                                                     and col.xml_coleta_status	                 = 'OK');
                
                -- Busca por coletado via Nimbi
                if (vPodeEnviar = 0) then
                  
                  select count(*)
                    into vPodeEnviar
                    from tdvadm.t_col_asn a,
                         tdvadm.t_col_asnarquivo ar,
                         tdvadm.t_col_asnevento  ev
                   where a.col_asn_numero       = vXmlColeta
                     and a.col_asn_id           = ar.col_asn_id
                     and ar.col_asnarquivo_id   = ev.col_asnarquivo_id
                     and ev.col_asntpevento_id  = '3'   -- EVENTO DE ASN COLETADO
                     and ev.col_asnstatusevt_id = '1' ; -- STATUS DO EVENTO 2 = ENVIADO COM SUCESSO
                  
                  -- AJUSTE FEITO A PEDIDO TIAGO DA VALE COM CONSENSO DA ANA BECHARA E FERNANDA BOTELHO. 
                  -- FEINTO EM 13/02/2017
                  -- TODOS OS CTE¥S SER√O ENVIADOS..
                  vPodeEnviar := 1;   
                    
                
                end if;                                                       
                                                               
             end if;
               
             
          end if;
            
          if (Trim(vGrupoEconomico) = '0020') and (vXmlColeta <> vNunColetaDef) then
            
              if (vPodeEnviar > 0) then
                
                p_status   := PKG_GLB_COMMON.Status_Nomal;
                p_message  := 'Processamento Normal. Asn.: '||vXmlColeta;
              
              else
                
                p_status   := PKG_GLB_COMMON.Status_Warning;
                p_message  := 'Asn n„o foi enviada ainda para a Vale. Asn.: '||vXmlColeta;
              
              
              end if;
          
          else
            
              p_status   := PKG_GLB_COMMON.Status_Nomal;
              p_message  := 'Processamento Normal!';
             
          end if;
              
      exception when others then

          p_status   := PKG_GLB_COMMON.Status_Erro;
          p_message  := 'Docuento n„o pode ser enviado.: Erro.: '||SQLERRM;

      end;

  end Sp_CtePodeEnviar;
                                          
  FUNCTION FN_CTE_RETORNACONTRATO(P_CTE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                  P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                  P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                  P_TIPO  IN CHAR default 'T')
        RETURN varchar2
  IS
    vTabSol   tdvadm.t_slf_tabela.slf_tabela_codigo%type;
    vTabSolSq tdvadm.t_slf_tabela.slf_tabela_saque%type;
    vTabSolTp char(1);
    vContratoD TDVADM.T_SLF_CONTRATO.SLF_CONTRATO_DESCRICAO%TYPE;
    vContratoC TDVADM.T_SLF_CONTRATO.SLF_CONTRATO_CODIGO%TYPE;
  Begin
     
     select lpad(trim(c.slf_tabela_codigo) || trim(c.slf_solfrete_codigo),8,'0'),
            lpad(trim(c.slf_tabela_saque) || trim(c.slf_solfrete_saque),4,'0'),
            decode(tdvadm.f_enumerico(c.slf_tabela_codigo),'S','T','S')
       into vTabSol,
            vTabSolSq,
            vTabSolTp
     from t_con_conhecimento c
     where c.con_conhecimento_codigo = P_CTE
       and c.con_conhecimento_serie  = P_SERIE    
       and c.glb_rota_codigo         = P_ROTA;

     Begin
       if vTabSolTp = 'T' Then
          select t.slf_tabela_contrato,
                 c.slf_contrato_descricao
            into vContratoC,
                 vContratoD
          from t_slf_tabela t,
               t_slf_contrato c
          where t.slf_tabela_codigo = vTabSol
            and t.slf_tabela_saque = vTabSolSq
            and t.slf_tabela_contrato = c.slf_contrato_codigo (+);
       Else
          select t.slf_solfrete_contrato,
                 c.slf_contrato_descricao
            into vContratoC,
                 vContratoD
          from t_slf_solfrete t,
               t_slf_contrato c
          where t.slf_solfrete_codigo = vTabSol
            and t.slf_solfrete_saque = vTabSolSq
            and t.slf_solfrete_contrato = c.slf_contrato_codigo (+);
       End If; 
     Exception
       When OTHERS Then
          vContratoC := '';
          vContratoD := '';
       End;
      
     If nvl(P_TIPO,'T') = 'T' Then
        if (vContratoD is null) then
           return trim(vContratoC);
        else
           return trim(vContratoC) || '-' || trim(vContratoD);
        end if;
     Elsif nvl(P_TIPO,'T') = 'C' Then
        return trim(vContratoC);
     Elsif nvl(P_TIPO,'T') = 'D' Then
        return trim(vContratoD);
     Else   
        if (vContratoD is null) then
           return trim(vContratoC);
        else
           return trim(vContratoC) || '-' || trim(vContratoD);
        end if;
     End If;
    
  End FN_CTE_RETORNACONTRATO;        
  
  PROCEDURE SP_NDD_ECONECTOR(P_DODUMENTO IN NUMBER,
                             P_SERIE     IN NUMBER,
                             P_JODIDNDD  IN NDD_NEW.TBLOGDOCUMENT.JOBID%TYPE,
                             p_status    out char,
                             p_message   out varchar2) AS

  vDocumentoId  NDD_NEW.tblogdocument.LOGDOCID%TYPE;
  vDocumentoJob NDD_NEW.tblogdocument.JOBID%TYPE;
  vExisteCold   integer;
  vExiste       integer :=0;
  vEventoAut    integer;
  vControlectrce integer;

  BEGIN

        If P_DODUMENTO in ('389169','389170') Then
           raise_application_error(-20111,SUBSTR(DBMS_UTILITY.format_call_stack,1,2000));
        End If;
   
          BEGIN

            FOR r_cursor IN (SELECT L.LOGDOCID,
                                    L.JOBID,
                                    l.documentnumber,
                                    l.serie
                               FROM NDD_NEW.TBLOGDOCUMENT L
                              WHERE L.DOCUMENTNUMBER = P_DODUMENTO
                                AND L.SERIE          = P_SERIE
                                AND L.jobid          = P_JODIDNDD)
            LOOP                

                vExiste := vExiste +1;
                
                select count(*) 
                  into vexistecold
                  from ndd_new.cold_producao col 
                 where to_number(col.ide_serie) = to_number(r_cursor.serie)
                   and to_number(col.ide_nct)   = to_number(r_cursor.documentnumber);
                   
                select count (*)
                  into vEventoAut
                  from ndd_new.tblogdocmessage m, ndd_new.tblogdocument do
                 where m.msgcode = '100'
                    and m.logdocid = do.logdocid
                    and lpad(do.DOCUMENTNUMBER,6,0) = P_DODUMENTO
                    and lpad(do.serie,3,0) = P_SERIE
                    and do.jobid = P_JODIDNDD;
                    
                select count (*)
                  into vControlectrce
                  from tdvadm.t_con_controlectrce ce
                 where ce.con_conhecimento_codigo = P_DODUMENTO
                   and ce.glb_rota_codigo = P_SERIE
                   and ce.con_controlectrce_status = 'OK';
        
                
                if (vExisteCold = 0) and (vEventoAut = 0) and ( vControlectrce = 0 ) then
                
                    IF r_cursor.logdocid IS NOT NULL THEN
                      
                          delete from ndd_new.tblogdocumentstatus  s    where s.logdocid   = r_cursor.logdocid;
                          delete from ndd_new.tblogdocmessage      m    where m.logdocid   = r_cursor.logdocid;
                          delete from ndd_new.tbprocess            p    where p.logdocid   = r_cursor.logdocid and p.jobid = r_cursor.jobid;
                          delete from ndd_new.tblogdocumentprinted pr   where pr.logdocid  = r_cursor.logdocid;
                          delete from ndd_new.tbrelateddocument    re   where re.logdocid  = r_cursor.logdocid;
                          delete from ndd_new.tblogdocumentaction  tt   where tt.logdocid  = r_cursor.logdocid; 
                          delete from ndd_new.tbevent              tt2  where tt2.logdocid = r_cursor.logdocid;
                          delete from ndd_new.tblogdocument        do   where do.logdocid  = r_cursor.logdocid and do.jobid = r_cursor.jobid;
                           
                          commit;
                      
                    END IF;
                
                else
                   
                   p_status   := PKG_GLB_COMMON.Status_Erro; 
                   p_message  := 'Documento n„o pode ser excluido, pois ja esta no Cold ou autorizado na SEFAZ';
                   return;
                  
                end if;
          
          END LOOP;
          
          if (vExiste = 0) then
              
            p_status   := PKG_GLB_COMMON.Status_Nomal; 
            p_message  := 'Documento n„o existe na integraÁ„o!';
            return;
          
          else
            
            p_status   := PKG_GLB_COMMON.Status_Nomal; 
            p_message  := 'Documento excluido com sucesso!';
            
          end if;
      
      EXCEPTION WHEN OTHERS THEN
        p_status   := PKG_GLB_COMMON.Status_Erro; 
        p_message  := 'Erro ao exluir documento da integraÁ„o. Erro: '||SQLERRM;
      END;   

  END SP_NDD_ECONECTOR;
     
  FUNCTION FN_RETORNA_TPAMBCTE(P_ROTA IN CHAR) RETURN CHAR IS
  vFLAG           CHAR;
  vTPAMB          CHAR;
  vExisteIntNfse integer;
  vTdx            boolean:= false;
  BEGIN

    /* BUSCA SE ROTA … DE CTE */
    
    BEGIN
      SELECT NVL(RT.GLB_ROTA_CTE,'N')
        INTO vFLAG
        FROM T_GLB_ROTA RT,
             WSERVICE.T_GLB_ROTASERVICOURL W
       WHERE RT.GLB_ROTA_CODIGO                     = W.GLB_ROTA_CODIGO
         AND W.GLB_ROTATPINTEGRACAO_COD             = 'CTE'
         AND W.GLB_TPSERVICO_COD                    = 'ENVIARCTE'
         AND W.GLB_ROTA_CODIGO                      = P_ROTA;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        vFLAG := 'N';
     END;      
     
    /* BUSCA SE ROTA … DE NFSE */
    SELECT COUNT(*)
      INTO vExisteIntNfse 
      FROM WSERVICE.T_GLB_ROTASERVICOURL KL
     WHERE KL.GLB_TPSERVICO_COD = 'ENVIARLOTE'
       AND KL.GLB_ROTATPINTEGRACAO_COD IN ('ABR','DSF','GOV','NFD','TDV')
       AND KL.GLB_ROTA_CODIGO          = P_ROTA;
    
    
    if (vTdx) then
       vFLAG := 'N';
    end if;  
      
    
    IF vExisteIntNfse > 0 THEN
       vFLAG := 'S';
    END IF;  
       
    IF vFLAG = 'S' THEN
      vTPAMB:= '1';
    ELSIF vFLAG = 'N' THEN
      vTPAMB:= '2';
    END IF;

    RETURN TRIM(vTPAMB);
    
  END FN_RETORNA_TPAMBCTE;
  
  procedure Sp_Cte_ReenviaCancel(p_Cte   in t_con_conhecimento.con_conhecimento_codigo%type,
                                 p_Serie in t_con_conhecimento.con_conhecimento_serie%type,
                                 p_Rota  in t_con_conhecimento.glb_rota_codigo%type,
                                 p_Status out char,
                                 p_Message out varchar2) as
                                 
  vCteCancelado  t_con_conhecimento.con_conhecimento_flagcancelado%type := 'N';
  vExisteEventoc integer;
  vCodCancel     t_con_controlectrce.con_controlectrce_codstcancel%type;
  begin

    begin

       select nvl(ll.con_conhecimento_flagcancelado,'N')
         into vCteCancelado
         from t_con_conhecimento ll
        where ll.con_conhecimento_codigo = p_Cte
          and ll.con_conhecimento_serie  = p_Serie
          and ll.glb_rota_codigo         = p_Rota;
          
       select count(*)   
         into vExisteEventoc
         from t_con_eventocte l
        where l.con_conhecimento_codigo          = p_Cte
          and l.con_conhecimento_serie           = p_Serie 
          and l.glb_rota_codigo                  = p_Rota
          and nvl(l.con_eventocte_flagret,'N')   = 'N'; 

       select nvl(cc.con_controlectrce_codstcancel,'999')
         into vCodCancel
         from t_con_controlectrce cc
        where cc.con_conhecimento_codigo = p_Cte
          and cc.con_conhecimento_serie  = p_Serie
          and cc.glb_rota_codigo         = p_Rota;  
       
       
       if (vCteCancelado = 'N') and (vExisteEventoc > 0) and (vCodCancel not in ('101','999') ) then
          
          update t_con_controlectrce ll
             set ll.con_controlectrce_status      = 'OK',
                 ll.con_controlectrce_dtsolcancel = null,
                 ll.con_controlectrce_dtretcancel = null,
                 ll.con_controlectrce_codstcancel = null
           where ll.con_conhecimento_codigo       = p_Cte   
             and ll.con_conhecimento_serie        = p_Serie
             and ll.glb_rota_codigo               = p_Rota;   
                        
          update t_con_eventocte vv
            set vv.con_eventocte_flagenvio       = null
          where vv.con_conhecimento_codigo       = p_Cte   
            and vv.con_conhecimento_serie        = p_Serie
            and vv.glb_rota_codigo               = p_Rota;   
          
          commit;
          
          p_Status  := PKG_GLB_COMMON.Status_Nomal; 
          p_Message := 'Processamento Normal!';
          
       else
         
         p_Status  := PKG_GLB_COMMON.Status_Warning; 
         p_Message := 'Reenvio de cancelamento n„o realizado, verifique condiÁıes internar da Procedure.';
         
       end if;        
                
    exception when others then
      
      p_Status  := PKG_GLB_COMMON.Status_Erro; 
      p_Message := 'Erro ao reenviar CTe. Erro.: '||sqlerrm;
      
    end;

  end Sp_Cte_ReenviaCancel;
 
  Function Fn_Cte_AverbaAperan(p_cte   in t_con_conhecimento.con_conhecimento_codigo%type,
                               p_serie in t_con_conhecimento.con_conhecimento_serie%type,
                               p_rota  in t_con_conhecimento.glb_rota_codigo%type)return char is
  vValorZerado         integer;
  vCnpjSacado   t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vRetorno      char(1);
  begin
       
     select kk.glb_cliente_cgccpfsacado
       into vCnpjSacado
       from t_con_conhecimento kk
      where kk.con_conhecimento_codigo = p_cte
        and kk.con_conhecimento_serie  = p_serie
        and kk.glb_rota_codigo         = p_rota;
     
     if (TRIM(vCnpjSacado) in ('33390170000421','60500121001368','33390170001312','33390170001070')) and (vCnpjSacado is not null) then
     
       select count(*)
         into vValorZerado
         from v_con_i_advl l
        where l.con_conhecimento_codigo = p_cte
          and l.con_conhecimento_serie  = p_serie
          and l.glb_rota_codigo         = p_rota
          and l.con_calcviagem_valor    = 0;
          
       if (vValorZerado > 0) then
          vRetorno := 'S';
       else
          vRetorno := 'N'; 
       end if;  

     else
       vRetorno := 'N'; 
     end if;

     return vRetorno; 
       
   
  end Fn_Cte_AverbaAperan;                                 
  
  Function Fn_Cte_RetornaApolice(p_cte   in t_con_conhecimento.con_conhecimento_codigo%type,
                                 p_serie in t_con_conhecimento.con_conhecimento_serie%type,
                                 p_rota  in t_con_conhecimento.glb_rota_codigo%type)return number is
  vExisteAdvl   integer;
  vCnpjSacado   t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vCodApolice   t_glb_apolice.glb_apolice_codigo%type;
  vIbgeOrigem   v_glb_ibge.codmun%type;
  vIbgeDestino  v_glb_ibge.codmun%type;
  vIndPhilips   boolean := false;
  begin
    
     -- Buscando Sacado do CTe, ibge origem e ibge destino
     select kk.glb_cliente_cgccpfsacado,
            lo.glb_localidade_codigoibge,
            ld.glb_localidade_codigoibge
       into vCnpjSacado,
            vIbgeOrigem,      
            vIbgeDestino
       from t_con_conhecimento kk,
            t_glb_localidade   lo,
            t_glb_localidade   ld
      where kk.con_conhecimento_codigo       = p_cte
        and kk.con_conhecimento_serie        = p_serie
        and kk.glb_rota_codigo               = p_rota
        and kk.con_conhecimento_localcoleta  = lo.glb_localidade_codigo
        and kk.con_conhecimento_localentrega = ld.glb_localidade_codigo;
        
     -- Analise para saber se o CTe tem ADVL.
     select count(*)
       into vExisteAdvl
       from v_con_i_advl l
      where l.con_conhecimento_codigo = p_cte
        and l.con_conhecimento_serie  = p_serie
        and l.glb_rota_codigo         = p_rota
        and l.con_calcviagem_valor    <> 0;
     
     -- Analise para buscar a apolice
     begin
       
       select l.glb_apolice_codigo
         into vCodApolice
         from t_glb_apolice l
        where l.glb_cliente_cgccpfcodigo = vCnpjSacado;
     
     exception when others then
       -- N„o achou apolice Defalut Della Volpe
       vCodApolice := 1;
     end;
     
     -- Analise excess„o da regra para a Philips 
     if (vCnpjSacado in ('61086336000456','22555787000433','61086336013604','61352050000122','61352050000394')) then
      
       -- Origem Guaruja - SP, Destino Santos - SP
       if ((vIbgeOrigem = '3518701')  and (vIbgeDestino = '3548500')) then
         
         vIndPhilips := true;

       end if;  
     
     end if;  
       
     -- Quando a verba ADVL for maior que 0, o seguro È por conta da tdv
     -- Menos para o sacado Philips que analise È feita pela origem e destino da carga
     if (vExisteAdvl > 0) and (vCnpjSacado not in('61086336000456','22555787000433','61086336013604','61352050000394','61352050000122')) then
       
         -- Apolice Defalut Della Volpe
         vCodApolice := 1;
         
     end if;  
     
     -- Quando for a excess„o para philips a respondabilidade È da TDV
     if (vIndPhilips = true) then
       
       -- Apolice Defalut Della Volpe
       vCodApolice := 1;
        
     end if;  
     
     return nvl(vCodApolice,1);
             
  end Fn_Cte_RetornaApolice;                                 
  
  procedure sp_Con_CteGravaEventoCCe(p_cte       in  t_con_conhecimento.con_conhecimento_codigo%type,
                                     p_serie     in  t_con_conhecimento.con_conhecimento_serie%type,
                                     p_rota      in  t_con_conhecimento.glb_rota_codigo%type,
                                     p_usuario   in  t_usu_usuario.usu_usuario_codigo%type,
                                     p_TagCorr   in  t_con_tagcorrecao.con_tagcorrecao_cod%type,
                                     p_NovoVlr   in  t_con_eventocte.con_eventocte_valoralterado%type,
                                     p_Sequencia out t_con_eventocte.con_eventocte_seqevento%type,
                                     p_Status    out char,
                                     p_Message   out varchar2) as
  vExisteCte          integer;
  vExisteUsuario      integer;
  vExisteTagCorrigida integer;
  vSequencia          t_con_eventocte.con_eventocte_seqevento%type;
  begin
    
    begin
      
      -- Se Cte Existe
      select count(*)
        into vExisteCte
        from t_con_conhecimento ch
       where ch.con_conhecimento_codigo = p_cte   
         and ch.con_conhecimento_serie  = p_serie
         and ch.glb_rota_codigo         = p_rota; 
               
      -- Se existe usuario          
      select count(*)
        into vExisteUsuario
        from t_usu_usuario us
       where us.usu_usuario_codigo = p_usuario;  
       
      -- Se Tag existe 
      select count(*) 
        into vExisteTagCorrigida
        from t_con_tagcorrecao ta
       where ta.con_tagcorrecao_cod = p_TagCorr;     
      
      
      if (vExisteCte = 0) Then
        
        p_Status  := pkg_glb_common.Status_Warning; 
        p_Message := 'Cte N„o existe!!';
        Return;
        
      end if;
      
        
      if (vExisteUsuario = 0) then
      
        p_Status  := pkg_glb_common.Status_Warning; 
        p_Message := 'Usuario N„o existe!!';
        Return;
      
      end if;
      
             
      if (vExisteTagCorrigida = 0) then
        
        p_Status  := pkg_glb_common.Status_Warning; 
        p_Message := 'Tag Corrigida N„o existe!!';
        Return;
      
      end if;
      
      -- Ultima Sequencia
      select count(*)
        into vSequencia
        from t_con_eventocte kk
       where kk.con_conhecimento_codigo = p_cte
         and kk.con_conhecimento_serie  = p_serie
         and kk.glb_rota_codigo         = p_rota;
      
      vSequencia := vSequencia +1;
      
      -- Gravando o Evento
      insert into t_con_eventocte
        (con_conhecimento_codigo,
         con_conhecimento_serie,
         glb_rota_codigo,
         con_eventocte_seqevento,
         glb_eventosefaz_codigo,
         usu_usuario_codigo,
         con_eventocte_dtcadastro,
         con_tagcorrecao_cod,
         con_eventocte_valoralterado)
      values
        (p_cte,
         p_serie,
         p_rota,
         vSequencia,
         '5',-- EVENTO DE CARTA DE CORRE«√O FIXO NESTA PROCEDURE
         LOWER(p_usuario),
         Sysdate,
         p_TagCorr,
         p_NovoVlr);
      
      commit;
        
      p_Sequencia := vSequencia;
      p_Status    := pkg_glb_common.Status_Nomal;  
      p_Message   := 'Processamento Normal!';
      
      
    exception when others then
    
      p_Status  := pkg_glb_common.Status_Erro;  
      p_Message := 'Erro ao executar pkg_con_cte.sp_Con_CteGravaEventoCCe. Erro.: '||sqlerrm;
    
    end;
        
  end sp_Con_CteGravaEventoCCe;     
  
  Function FN_GET_CONTEUDOORIGINALCTE(p_cte       in  t_con_conhecimento.con_conhecimento_codigo%type,
                                      p_serie     in  t_con_conhecimento.con_conhecimento_serie%type,
                                      p_rota      in  t_con_conhecimento.glb_rota_codigo%type,
                                      p_Tag       in varchar2)
    return varchar2
   Is
     vCampo varchar2(1000);
     vComando varchar2(1000);
     vTabela tdvadm.t_con_tagcorrecao.con_tagcorrecao_objorigem%type;
     vColuna tdvadm.t_con_tagcorrecao.con_tagcorrecao_campoorigem%type;
   Begin
     
      SELECT t.con_tagcorrecao_objorigem,
             t.con_tagcorrecao_campoorigem
        INTO vTabela,
             vColuna
      FROM TDVADM.T_CON_TAGCORRECAO T
      WHERE T.CON_TAGCORRECAO_COD = p_Tag;     
   
      vComando := 'SELECT ' || vColuna || ' FROM ' || vTabela || ' WHERE con_conhecimento_codigo = *' || lpad(trim(p_cte),6,'0') || '* AND con_conhecimento_serie = *' || p_serie || '* and glb_rota_codigo = *' || lpad(trim(p_rota),3,'0') || '*';
      vComando := REPLACE(vComando,'*','''');
      Begin
        execute immediate vComando into vCampo;
      Exception
        When OTHERS Then
          vCampo := sqlerrm;
     end;     
      return vCampo;
      
   End FN_GET_CONTEUDOORIGINALCTE;  
       
  Procedure Sp_Cte_ExcluiNdd(p_cte       in t_con_conhecimento.con_conhecimento_codigo%type,
                             p_serie     in t_con_conhecimento.con_conhecimento_serie%type,
                             p_rota      in t_con_conhecimento.glb_rota_codigo%type,
                             p_parametro in varchar2,
                             p_status    out char,
                             p_message   out varchar2) as
  vJobId     varchar2(5);
  vStatus	   char(1);
  vMessage   varchar2(2000);
  begin
    
    begin
       
      vJobId := pkg_hd_utilitario.fn_GET_IDJOBNDD(p_cte, p_rota, 'C');
      
      if (nvl(vJobId,'9999') <> '9999') then
        
          SP_NDD_ECONECTOR(p_cte, 
                           p_rota, 
                           vJobId, 
                           vStatus, 
                           vMessage);
          
          p_status   := vStatus;
          p_message  := vMessage;
      
      else
        
        p_status  := 'W';
        p_message := 'Documento n„o foi encontrado em nenhum job, provavelmente ele n„o esta mais na integraÁ„o!';
        
      end if;    

    exception when others then
      
      p_status  := 'E';
      p_message := 'Erro ao esecutar pkg_con_cte.sp_cte_excluindd. Erro.: '||sqlerrm;
      
    end;
        
  end Sp_Cte_ExcluiNdd;    
  
  Function Fn_Cte_RetxCaracAd(p_cte    in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                              p_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                              p_rota   in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2 as
  vRetorno       varchar2(50);
  vCnpjSacado    tdvadm.t_con_conhecimento.glb_cliente_cgccpfsacado%type;
  vSolFreteCod   tdvadm.t_con_conhecimento.slf_solfrete_codigo%type;
  vSolFreteSaq   tdvadm.t_con_conhecimento.slf_solfrete_saque%type;
  vTabelaCod     tdvadm.t_con_conhecimento.slf_tabela_codigo%type;	 
  vTabelaSaque   tdvadm.t_con_conhecimento.slf_tabela_saque%type;	 
  vTpCarga       tdvadm.t_slf_solfrete.glb_tpcarga_codigo%type;
  begin
  
  begin
    
    -- Busca de Sacado, SoliciraÁ„o e Tabela.
    select ll.glb_cliente_cgccpfsacado,
           ll.slf_solfrete_codigo,
           ll.slf_solfrete_saque,
           ll.slf_tabela_codigo,
           ll.slf_tabela_saque
      into vCnpjSacado,
           vSolFreteCod,
           vSolFreteSaq,
           vTabelaCod,
           vTabelaSaque
      from tdvadm.t_con_conhecimento ll
     where ll.con_conhecimento_codigo = p_cte
       and ll.con_conhecimento_serie  = p_serie
       and ll.glb_rota_codigo         = p_rota;

    -- Se For o Sacado Cnova, fazemos uma regra para definir o tipo do frete.
    if vCnpjSacado in ('07170938001685','07170938001766','07170938001847','07170938014078','07170938050970','07170938001502') then

      if (vSolFreteCod is not null) then
        -- Busca do tipo de frete da solicitaÁ„o.
        -- para a Cnova as cargas de devoluÁ„o e reentrega s„o feitas por solicitaÁ„o.
        select kk.glb_tpcarga_codigo
          into vTpCarga
          from tdvadm.t_slf_solfrete kk
         where kk.slf_solfrete_codigo = vSolFreteCod
           and kk.slf_solfrete_saque  = vSolFreteSaq;

        -- Reentrega
        if (vTpCarga = '13') then
          vRetorno := 'REENTREGA';
        -- DevoluÁ„o
        elsif (vTpCarga = '14') then
          vRetorno := 'DEVOLUCAO';
        -- Carga Normal
        else
          vRetorno := 'ENTREGA';
        end if;
      
    else
       vRetorno := 'ENTREGA';
    end if;    

    -- Se n„o for CNOVA, retorna normal.
    else

      vRetorno := 'NORMAL';

    end if;


  exception when others then
    -- Se der erro para n„o comprometer o processo, sempre retornamos normal.
    vRetorno := 'NORMAL';

  end;

  RETURN vRetorno;
        
  End Fn_Cte_RetxCaracAd;
  
  Function Fn_Cte_RetDocUsiminas(p_cte    in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                 p_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                 p_rota   in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2 as
  vStrRetorno    varchar2(2000);
  vNrPedido      tdvadm.t_arm_coleta.arm_coleta_pedido%type;
  vClienteSacado tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vColetaNr      tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
  vColetaCiclo   tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
  begin
    
     begin
       
       -- Busco os dados da coleta e Sacado.
       select kk.glb_cliente_cgccpfsacado,
              kk.arm_coleta_ncompra,
              kk.arm_coleta_ciclo
         into vClienteSacado,
              vColetaNr,     
              vColetaCiclo
         from tdvadm.t_con_conhecimento kk
        where kk.con_conhecimento_codigo = p_cte  
          and kk.con_conhecimento_serie  = p_serie
          and kk.glb_rota_codigo         = p_rota;
       
       -- Somente esses sacados iremos realizar a regra
       if (vClienteSacado in ('17500224003261','17500224003423','17500224000246')) and (vColetaNr is not null) then
         
         -- busco o numero do pedido
         select trim(co.arm_coleta_pedido)
           into vNrPedido
           from tdvadm.t_arm_coleta co
          where co.arm_coleta_ncompra = vColetaNr
            and co.arm_coleta_ciclo   = vColetaCiclo;
         
         
         if (vNrPedido is not null) then
            
            vStrRetorno :=  vNrPedido||'-1';
            
         else
            
            vStrRetorno := null;
            
         end if;  
         
       else
         
         vStrRetorno := null;
         
       end if;     
      
      exception when others then
        
        vStrRetorno := null;
      
      end;    
      
      
      return vStrRetorno;
    
  end Fn_Cte_RetDocUsiminas;                                 
                             
  Function Fn_Cte_GetIndIeToma(p_cte    in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                               p_serie  in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                               p_rota   in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2 as

  vCnpjTomador     tdvadm.t_con_conhecimento.glb_cliente_cgccpfsacado%type;
  vIndIeToma       varchar2(1);
  vIe              tdvadm.t_glb_cliente.glb_cliente_ie%type;
  vIeIsento        tdvadm.t_glb_cliente.glb_cliente_ieisento%type;
  vTipoPessoa      varchar2(1);
  vNaoContribuinte tdvadm.t_glb_cliente.glb_cliente_naocont%type;
  begin
    
    begin
      
      select ch.glb_cliente_cgccpfsacado,
             nvl(cl.glb_cliente_naocont,'N') glb_cliente_naocont
        into vCnpjTomador,
             vNaoContribuinte
        from tdvadm.t_con_conhecimento ch,
             tdvadm.t_glb_cliente cl
       where ch.con_conhecimento_codigo  = p_cte  
         and ch.con_conhecimento_serie   = p_serie
         and ch.glb_rota_codigo          = p_rota
         and ch.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo;
      
      
      select decode(length(trim(vCnpjTomador)),11,'F','J')
        into vTipoPessoa 
        from dual;
      
      
      select c.glb_cliente_ie,
             nvl(c.glb_cliente_ieisento,'N')
        into vIe       ,
             vIeIsento
        from tdvadm.t_glb_cliente c
       where c.glb_cliente_cgccpfcodigo = vCnpjTomador;
       
      
      if ((vTipoPessoa = 'F') or (vNaoContribuinte = 'S')) then
      
         vIndIeToma := '9'; 
      
      elsif (substr(vCnpjTomador,1,8) = '61139432')        then
        
         vIndIeToma := '9';   
      
      elsif (vIe != 'ISENTO') or (vIeIsento != 'S')        then
        
        vIndIeToma := '1';
      
      elsif (vIe = 'ISENTO') or (vIeIsento = 'S')          then
        
         vIndIeToma := '2';
      
      else
         
         vIndIeToma := '1';
        
      end if;
      
      
      if ( vCnpjTomador in ('28537364000124','28608536000103')) then
        
        vIndIeToma := '9';
        
      end if;  

    exception when others then  
        vIndIeToma := '1';
    end;    
    
    return vIndIeToma;
    
  end;                                
                                    
  Function Fn_Cte_GettpServ(p_cte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                            p_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                            p_rota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2 as
  vRetorno         varchar2(1);
  vTipoConsigRes   tdvadm.t_con_consigredespacho.con_consigredespacho_flagcr%type;
  vExiste          integer;
  begin

    begin
      
      -- Teste para buscar registro na tabela
      select count(*)
        into vExiste
        from tdvadm.t_con_consigredespacho rr
       where rr.con_conhecimento_codigo = p_cte
         and rr.con_conhecimento_serie  = p_serie
         and rr.glb_rota_codigo         = p_rota;
      
      
      -- Se existe buscar o tipo
      if (vExiste > 0) then   
      
        -- Buscando Tipo do ConsigRespacho.
        select rr.con_consigredespacho_flagcr
          into vTipoConsigRes
          from tdvadm.t_con_consigredespacho rr
         where rr.con_conhecimento_codigo = p_cte
           and rr.con_conhecimento_serie  = p_serie
           and rr.glb_rota_codigo         = p_rota;
        
        
        -- Definindo o retorno
        if (vTipoConsigRes = 'S') then   -- SubContrataÁ„o
        
           vRetorno := '1';
        
        elsif(vTipoConsigRes = 'D') then -- Redespacho
        
           vRetorno := '2';
        
        elsif(vTipoConsigRes = 'I') then -- Redespacho Intermediario
        
           vRetorno := '3';
        
        else                             -- Normal
        
           vRetorno := '0';              
        
        end if;   
        
      else
        
        vRetorno := 0;
        
      end if;  

    exception when others then

       vRetorno := 0;

    end;
    
   
    return vRetorno;

  end;              
  
  
  Function Fn_Cte_GetUltimaPlacaCte(p_cte   in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                    p_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                    p_rota  in tdvadm.t_con_conhecimento.glb_rota_codigo%type) return varchar2 as
  vUltimaPlaca  varchar2(7);
  vIndSucesso   boolean:= false;
  vGrupoSacado  tdvadm.t_glb_cliente.glb_grupoeconomico_codigo%type; 
  
  begin
    
   -- Busco o grupo economico do cliente sacado
   select c.glb_grupoeconomico_codigo
     into vGrupoSacado
     from tdvadm.t_con_conhecimento ch,
          tdvadm.t_glb_cliente c
    where ch.con_conhecimento_codigo = p_cte  
      and ch.con_conhecimento_serie  = p_serie
      and ch.glb_rota_codigo         = p_rota 
      and ch.glb_cliente_cgccpfsacado = c.glb_cliente_cgccpfcodigo; 
   
   -- Se o grupo o da ARCELOR
   if (vGrupoSacado = '0561') then
     -- frota
     begin
  
       select trim(fr.frt_veiculo_placa) placa
         into vUltimaPlaca
         from tdvadm.t_con_viagem       d,
              tdvadm.t_con_conhecimento ch,
              tdvadm.t_frt_veiculo      fr,
              tdvadm.t_frt_conjunto     cj,
              tdvadm.t_frt_conteng      ce,
              tdvadm.t_frt_marmodveic   mm,
              tdvadm.t_frt_tpveiculo    tv
        where ch.con_conhecimento_codigo         = p_cte  
          and ch.con_conhecimento_serie          = p_serie
          and ch.glb_rota_codigo                 = p_rota 
          and d.con_viagem_numero                = ch.con_viagem_numero
          and d.glb_rota_codigoviagem            = ch.glb_rota_codigoviagem
          and d.frt_conjveiculo_codigo           = cj.frt_conjveiculo_codigo
          and cj.frt_conjveiculo_codigo          = ce.frt_conjveiculo_codigo
          and ce.frt_veiculo_codigo              = fr.frt_veiculo_codigo
          and fr.frt_marmodveic_codigo           = mm.frt_marmodveic_codigo
          and mm.frt_tpveiculo_codigo            = tv.frt_tpveiculo_codigo
          and ch.con_conhecimento_dtembarque    >= '01/11/2010'
          and ch.con_conhecimento_flagcancelado  is null
          and ce.frt_veiculo_codigo              = (select max(ll.frt_veiculo_codigo)
                                                      from tdvadm.t_frt_conteng ll
                                                     where ll.frt_conjveiculo_codigo = ce.frt_conjveiculo_codigo
                                                       and length(trim(ll.frt_veiculo_codigo)) = CASE WHEN ((select count(*) from tdvadm.t_frt_conteng jj where jj.frt_conjveiculo_codigo = ll.frt_conjveiculo_codigo) > 1) 
                                                                                                 then 4
                                                                                                 else 5
                                                                                                 end);
       
       vIndSucesso := true;
       
     exception when no_data_found then
        
       vIndSucesso := false;  
     
     end;  
     
     
     if (vIndSucesso = false) then
       
       -- carreteiro.
       select NVL(nvl(trim(o.car_veiculooutros_placa),trim(a.car_veiculo_carreta_placa)),a.car_veiculo_placa)
         into vUltimaPlaca
         from tdvadm.t_car_veiculo a,
              tdvadm.t_con_conhecimento ch1,
              tdvadm.t_car_veiculooutros o	
        where ch1.con_conhecimento_codigo         = p_cte  
          and ch1.con_conhecimento_serie          = p_serie
          and ch1.glb_rota_codigo                 = p_rota 
          and a.car_veiculo_placa                 = rpad(trim(ch1.con_conhecimento_placa), 7)
          and ch1.con_conhecimento_dtembarque    >= '01/11/2010'
          and ch1.con_conhecimento_serie         <> 'XXX'
          and a.car_veiculo_saque                 = (select max(a1.car_veiculo_saque)
                                                       from tdvadm.t_car_veiculo a1
                                                      where a1.car_veiculo_placa = a.car_veiculo_placa)
          and ch1.con_conhecimento_flagcancelado  is null
          and trim(a.car_veiculo_placa)           is not null
          and a.car_veiculo_placa                 = o.car_veiculo_placa(+)
          and a.car_veiculo_saque                 = o.car_veiculo_saque(+);     
       
     end if;                                                                                         
     
   else
     
     vUltimaPlaca := null;
     
   end if;
   
   Return vUltimaPlaca;                                                  
  
  
  end;  
  
  Procedure Sp_Cte_GetTipoFrete(p_arquivo  in  varchar2,
                                p_tipocte  out varchar2,
                                p_status   out char,
                                p_message  out varchar2)as
  vChaveCte          tdvadm.t_con_controlectrce.con_controlectrce_chavesefaz%type;
  vCteCodigo         tdvadm.t_con_controlectrce.con_conhecimento_codigo%TYPE;
  vCteSerie          tdvadm.t_con_controlectrce.con_conhecimento_serie%TYPE;
  vCteRota           tdvadm.t_con_controlectrce.glb_rota_codigo%TYPE;
  vExisteCte         integer;
  vTipoCargaTabSol   tdvadm.t_slf_tabela.fcf_tpcarga_codigo%type;
  vIsExpresso        boolean := false;
  vPrioridade        tdvadm.t_arm_coleta.Arm_Coleta_Prioridade%type;
  vTpCarga           tdvadm.t_arm_coleta.Glb_Tpcarga_Codigo%type;
  Begin

    vChaveCte := substr(p_arquivo,4,44);

    begin

      begin

        select l.con_conhecimento_codigo,
               l.con_conhecimento_serie,
               l.glb_rota_codigo,
               1
          into vCteCodigo,
               vCteSerie,
               vCteRota,
               vExisteCte
          from t_con_controlectrce l
         where l.con_controlectrce_chavesefaz = vChaveCte;

      exception when others then

         vExisteCte := 0;

      end;

      if (vExisteCte > 0) then

        -- Analise tipo carga
        select nvl(ta.fcf_tpcarga_codigo, sol.fcf_tpcarga_codigo)
          into vTipoCargaTabSol
          from tdvadm.t_con_conhecimento ch,
               tdvadm.t_slf_tabela ta,
               tdvadm.t_slf_solfrete sol
         where ch.con_conhecimento_codigo = vCteCodigo
           and ch.con_conhecimento_serie  = vCteSerie
           and ch.glb_rota_codigo         = vCteRota
           and ch.slf_tabela_codigo       = ta.slf_tabela_codigo    (+)
           and ch.Slf_Tabela_Saque        = ta.slf_tabela_saque     (+)
           and ch.slf_solfrete_codigo     = sol.slf_solfrete_codigo (+)
           and ch.slf_solfrete_saque      = sol.slf_solfrete_saque  (+);

        -- Busca Coleta
        begin

          select ar.Arm_Coleta_Prioridade,
                 ar.Glb_Tpcarga_Codigo
            into vPrioridade,
                 vTpCarga
            from tdvadm.t_con_conhecimento ch,
                 tdvadm.t_arm_coleta       ar,
                 tdvadm.t_glb_cliente      cl
           where ch.con_conhecimento_codigo  = vCteCodigo
             and ch.con_conhecimento_serie   = vCteSerie
             and ch.glb_rota_codigo          = vCteRota
             and ch.arm_coleta_ncompra       = ar.arm_coleta_ncompra
             and ch.arm_coleta_ciclo         = ar.arm_coleta_ciclo
             and ch.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo;

          -- Analise de È expressa
          if (vPrioridade = '2' and vTpCarga = 'EX') then
            vIsExpresso := true;
          else
            vIsExpresso := false;
          end if;

        exception when others then
          vIsExpresso := false;
        end;

      end if;

      if (vTipoCargaTabSol in ('10','12') and (vIsExpresso = false)) then
        p_tipocte := 'F';
      else
        p_tipocte := 'L';
      end if;

      p_status  := 'N';
      p_message := 'Processamento Normal!';


    exception when others then
      p_status  := 'E';
      p_message := 'Erro ao executar Sp_Cte_GetTipoFrete. Erro.: '||sqlerrm;
    end;

  End Sp_Cte_GetTipoFrete;
  
  Procedure Sp_Cte_GetTipoFreteCte(pCte       in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                   pSerie     in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                   pRota      in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                   p_tipocte  out varchar2,
                                   p_status   out char,
                                   p_message  out varchar2)as
  vChaveCte          tdvadm.t_con_controlectrce.con_controlectrce_chavesefaz%type;
  vCteCodigo         tdvadm.t_con_controlectrce.con_conhecimento_codigo%TYPE;
  vCteSerie          tdvadm.t_con_controlectrce.con_conhecimento_serie%TYPE;
  vCteRota           tdvadm.t_con_controlectrce.glb_rota_codigo%TYPE;
  vExisteCte         integer;
  vTipoCargaTabSol   tdvadm.t_slf_tabela.fcf_tpcarga_codigo%type;
  vIsExpresso        boolean := false;
  vPrioridade        tdvadm.t_arm_coleta.Arm_Coleta_Prioridade%type;
  vTpCarga           tdvadm.t_arm_coleta.Glb_Tpcarga_Codigo%type;
  Begin

    begin

      begin

        select l.con_conhecimento_codigo,
               l.con_conhecimento_serie,
               l.glb_rota_codigo,
               1
          into vCteCodigo,
               vCteSerie,
               vCteRota,
               vExisteCte
          from t_con_controlectrce l
         where l.con_conhecimento_codigo = pCte  
           and l.con_conhecimento_serie  = pSerie
           and l.glb_rota_codigo         = pRota ;

      exception when others then

         vExisteCte := 0;

      end;

      if (vExisteCte > 0) then

        -- Analise tipo carga
        select nvl(ta.fcf_tpcarga_codigo, sol.fcf_tpcarga_codigo)
          into vTipoCargaTabSol
          from tdvadm.t_con_conhecimento ch,
               tdvadm.t_slf_tabela ta,
               tdvadm.t_slf_solfrete sol
         where ch.con_conhecimento_codigo = vCteCodigo
           and ch.con_conhecimento_serie  = vCteSerie
           and ch.glb_rota_codigo         = vCteRota
           and ch.slf_tabela_codigo       = ta.slf_tabela_codigo    (+)
           and ch.Slf_Tabela_Saque        = ta.slf_tabela_saque     (+)
           and ch.slf_solfrete_codigo     = sol.slf_solfrete_codigo (+)
           and ch.slf_solfrete_saque      = sol.slf_solfrete_saque  (+);

        -- Busca Coleta
        begin

          select ar.Arm_Coleta_Prioridade,
                 ar.Glb_Tpcarga_Codigo
            into vPrioridade,
                 vTpCarga
            from tdvadm.t_con_conhecimento ch,
                 tdvadm.t_arm_coleta       ar,
                 tdvadm.t_glb_cliente      cl
           where ch.con_conhecimento_codigo  = vCteCodigo
             and ch.con_conhecimento_serie   = vCteSerie
             and ch.glb_rota_codigo          = vCteRota
             and ch.arm_coleta_ncompra       = ar.arm_coleta_ncompra
             and ch.arm_coleta_ciclo         = ar.arm_coleta_ciclo
             and ch.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo;

          -- Analise de È expressa
          if (vPrioridade = '2' and vTpCarga = 'EX') then
            vIsExpresso := true;
          else
            vIsExpresso := false;
          end if;

        exception when others then
          vIsExpresso := false;
        end;

      end if;

      if (vTipoCargaTabSol in ('10','12') and (vIsExpresso = false)) then
        p_tipocte := 'F';
      else
        p_tipocte := 'L';
      end if;

      p_status  := 'N';
      p_message := 'Processamento Normal!';


    exception when others then
      p_status  := 'E';
      p_message := 'Erro ao executar Sp_Cte_GetTipoFrete. Erro.: '||sqlerrm;
    end;

  End Sp_Cte_GetTipoFretecte;
  
  Procedure Sp_Cte_GetTpEnvioNestle(p_arquivo  in  varchar2,
                                    p_tipoenv  out varchar2,
                                    p_status   out char,
                                    p_message  out varchar2) as
  vChaveCte          tdvadm.t_con_controlectrce.con_controlectrce_chavesefaz%type;
  vCteCodigo         tdvadm.t_con_controlectrce.con_conhecimento_codigo%type;
  vCteSerie          tdvadm.t_con_controlectrce.con_conhecimento_serie%type;
  vCteRota           tdvadm.t_con_controlectrce.glb_rota_codigo%type;
  vConfigEnvioCC     tdvadm.t_slf_contratoconfig.slf_tpenvio_id%type;
  vExisteCte         integer;
  vFlagCancelado     tdvadm.t_con_conhecimento.con_conhecimento_flagcancelado%type;
  Begin
    
    Begin
      

      begin
        
        vChaveCte := substr(p_arquivo,4,44);

        select l.con_conhecimento_codigo,
               l.con_conhecimento_serie,
               l.glb_rota_codigo,
               1
          into vCteCodigo,
               vCteSerie,
               vCteRota,
               vExisteCte
          from t_con_controlectrce l
         where l.con_controlectrce_chavesefaz = vChaveCte;

      exception when others then

         vExisteCte := 0;

      end;
      
      if ( vExisteCte > 0) then
        
        select co.slf_tpenvio_id,
               nvl(ch.con_conhecimento_flagcancelado,'N')
          into vConfigEnvioCC,
               vFlagCancelado
          from tdvadm.t_con_conhecimento ch,
               tdvadm.t_slf_tabela ta,
               tdvadm.t_slf_solfrete sol,
               tdvadm.t_slf_contratoconfig co
          where ch.con_conhecimento_codigo                            = vCteCodigo
            and ch.con_conhecimento_serie                             = vCteSerie
            and ch.glb_rota_codigo                                    = vCteRota
            and ch.slf_tabela_codigo                                  = ta.slf_tabela_codigo    (+)
            and ch.slf_tabela_saque                                   = ta.slf_tabela_saque     (+)
            and ch.slf_solfrete_codigo                                = sol.slf_solfrete_codigo (+)
            and ch.slf_solfrete_saque                                 = sol.slf_solfrete_saque  (+)
            and nvl(ta.slf_tabela_contrato,sol.slf_solfrete_contrato) = co.slf_contrato_codigo  (+);
        
        
        
        p_tipoenv := vConfigEnvioCC;
        
        /*****************************************************************************/
        /**** AJUSTE RALIZADO PARA OS CTE¥S CANCELADOS QUE N«AO PODEM SER ENVIADOS****/
        /*****************************************************************************/
        
        If ( vFlagCancelado = 'S' ) Then
          
          p_tipoenv:= '2';
        
        End If;  
        
        /**************************************************/
        
      end if;
      
      p_status  := 'N';
      p_message := 'Processamento Normal!';
      
    Exception when others then
      p_status  := 'E';
      p_message := 'Erro ao executar Sp_Cte_GetTpEnvioNestle. Erro.: '||sqlerrm;
    End;
      
  End Sp_Cte_GetTpEnvioNestle;                                   
  
END PKG_CON_CTE;
/
