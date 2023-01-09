CREATE OR REPLACE PACKAGE PKG_CTB_LINKS IS
/***************************************************************************************************
 * ROTINA           : centralização de todas as rotinas de inteface com a contabilidade
 * PROGRAMA         :
 * ANALISTA         : Roberto Pariz
 * DESENVOLVEDOR    : Roberto Pariz
 * DATA DE CRIACAO  : 
 * BANCO            :
 * EXECUTADO POR    :
 * ALIMENTA         :
 * FUNCINALIDADE    : Criado a PKG para parametrizar as views
 * ATUALIZA         :
 * PARTICULARIDADES :                                           
 * PARAM. OBRIGAT.  :
 *                                                                                                  *
 ****************************************************************************************************/
 
 TYPE TP_LINK_CTB_CTRECB IS RECORD (TIPO      VARCHAR2(20),
                                    TIT       VARCHAR2(10),
                                    SEQ       INTEGER,
                                    CLI       VARCHAR2(50),
                                    DIA       DATE,
                                    CCUSTO    CHAR(3),
                                    CRESP     CHAR(3),
                                    PCONTA    CHAR(12),
                                    CONTA     VARCHAR2(50),
                                    HIST      CHAR(3),
                                    DESCRICAO VARCHAR2(50),
                                    VALOR     NUMBER
                                   );
 
  TYPE T_CURSOR IS REF CURSOR;
  STATUS_NORMAL CONSTANT CHAR(1)      := 'N';
  STATUS_ERRO   CONSTANT CHAR(1)      := 'E';
  
  vGLB_CATVF               VARCHAR2(20);
  vGLB_SERIEVF             VARCHAR2(40);
  vGLB_TPDATAVF            VARCHAR2(8);
  vGLB_TPDATAVFEX          VARCHAR2(8);
  vCriticaProcess          clob;
  
 /* Typo utilizado como base para utilização dos Paramentros                                                                 */
 Type TpMODELO  is RECORD (CAMPO1         char(10),
                           CAMPO2         number(6));
   
 FUNCTION GET_REFCTB RETURN VARCHAR2;


 TYPE TB_LINK_CTB_CTRECB IS TABLE OF TP_LINK_CTB_CTRECB;

-- FUNCTION FN_LINK_CTB_CTRECB(P_DTINI IN CHAR,P_DTFIN IN CHAR) RETURN TB_LINK_CTB_CTRECB; 

 PROCEDURE SET_CATVF(P_REFERENCIA IN CHAR);
 FUNCTION  GET_CATVF RETURN VARCHAR2;

 PROCEDURE SET_SERIEVF(P_REFERENCIA IN CHAR);
 FUNCTION  GET_SERIEVF RETURN VARCHAR2;

 PROCEDURE SET_TPDATAVF(P_REFERENCIA IN CHAR);
 FUNCTION  GET_TPDATAVF RETURN VARCHAR2;

 -- ESTAS DUAS SÃO USADAS NO SELECT E NO GROUP BY PARA A EXPORTACAO DEVIDO A MUDANCA SOMENTE EM 2012
 PROCEDURE SET_TPDATAVFEX(P_REFERENCIA IN CHAR);
 FUNCTION  GET_TPDATAVFEX RETURN VARCHAR2;

 FUNCTION FN_GET_CTBREFSTATUS(P_REF IN CHAR) RETURN CHAR;

FUNCTION FN_GET_EVENTO_DTCOMPET(P_DTEVENTO IN CHAR,
                                P_DTLANCTO IN CHAR,
                                P_DTDOC    IN CHAR DEFAULT NULL,
                                P_REFCTB   IN CHAR DEFAULT NULL) 
          RETURN CHAR;

FUNCTION FN_GET_EVENTO_DTCOMPETold(P_DTEVENTO IN CHAR,
                                P_DTLANCTO IN CHAR,
                                P_REFDOC   IN CHAR DEFAULT NULL,
                                P_REFCTB   IN CHAR DEFAULT NULL) 
           RETURN CHAR;

FUNCTION FN_GET_CODMERCADORIA(P_CODCTE    TDVADM.T_GLB_MERCADORIA.GLB_MERCADORIA_CODIGO%TYPE,
                                     P_CODTABSOL TDVADM.T_GLB_MERCADORIA.GLB_MERCADORIA_CODIGO%TYPE)RETURN CHAR;


 PROCEDURE SP_LINK_CTB_TDVVFRETE(P_MES  IN CHAR,
                                 P_ANO  IN CHAR,
                                 P_DIA  IN CHAR,
                                 P_MODO IN CHAR,
                                 P_ID   IN CHAR);
   
PROCEDURE SP_LINK_CTB_TDVCOCA(P_MES  IN CHAR,
                              P_ANO  IN CHAR,
                              P_DIA  IN CHAR,               
                              P_MODO IN CHAR,
                              P_ID   IN CHAR);
                              
  -- USADA PARA GRAVAR OU ATUALIZA O LINK DE CONHECIMENTO
 Procedure SP_LINK_ATUCONHECIMENTO(P_CONHECIMENTO In T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%Type,
                                   P_SERIE        In T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%Type,
                                   P_ROTA         In T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%Type,
                                   P_ORIGEM       In Varchar2,
                                   P_DATA         In T_CON_CONHECCTBDET.CTB_MOVIMENTO_DTMOVTO%type,
                                   P_ID           In T_CON_CONHECCTB.CON_CONHECCTB_ID%type,
                                   P_DOCUMENTO    In T_CON_CONHECCTBDET.CTB_MOVIMENTO_DOCUMENTO%Type,
                                   P_SEQUENCIA    IN T_CON_CONHECCTBDET.CTB_MOVIMENTO_DSEQUENCIA%TYPE,
                                   P_REFERENCIA   In T_CON_CONHECCTB.CON_CONHECCTB_REF%Type,
                                   P_OBSERVACAO   IN VARCHAR2,
                                   P_COMMIT       In Char Default 'N');

 PROCEDURE SP_LINK_ATUCONHECIMENTOHIST(P_REFERENCIA In TDVADM.T_CON_CONHECCTB.CON_CONHECCTB_REF%Type);
                                     

 Procedure SP_LINK_ATUVALEFRETE(P_VALE       In    T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%Type,
                                P_SERIE      In T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%Type,
                                P_ROTA       In T_CON_VALEFRETE.GLB_ROTA_CODIGO%Type,
                                P_SAQUE      In T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%Type,
                                P_ORIGEM     In Varchar2,
                                P_DATA       In t_Con_Vfretectbdet.Ctb_Movimento_Dtmovto%type, 
                                P_ID         In t_Con_Vfretectb.Con_Vfretectb_Id%Type,
                                P_DOCUMENTO    In t_Con_Vfretectbdet.CTB_MOVIMENTO_DOCUMENTO%Type,
                                P_SEQUENCIA    IN t_Con_Vfretectbdet.CTB_MOVIMENTO_DSEQUENCIA%TYPE,
                                P_REFERENCIA In T_CON_CONHECCTB.CON_CONHECCTB_REF%Type,
                                p_observacao in varchar2,
                                p_classifexp in char,
                                P_COMMIT     In Char Default 'N');

                                
 PROCEDURE SP_LINK_ATUVALEFRETEHIST(P_REFERENCIA In TDVADM.T_CON_CONHECCTB.CON_CONHECCTB_REF%Type);

 Procedure SP_LINK_ATUDECONTO(P_REFERENCIA IN CHAR,
                              P_TITULO     IN TDVADM.T_CRP_TITRECEBER.CRP_TITRECEBER_NUMTITULO%TYPE,
                              P_ROTATIT    IN TDVADM.T_CRP_TITRECEBER.GLB_ROTA_CODIGO%TYPE,
                              P_SQTIT      IN TDVADM.T_CRP_TITRECEBER.CRP_TITRECEBER_SAQUE%TYPE,
                              P_COMMIT     In Char Default 'N');

PROCEDURE SP_LINK_ATUDECONTOHIST(P_REFERENCIA In TDVADM.T_CON_CONHECCTB.CON_CONHECCTB_REF%Type,
                                 P_CURSOR OUT T_CURSOR,
                                 P_STATUS OUT VARCHAR2,
                                 P_MESSAGE OUT VARCHAR2);


function FN_GET_DADOSCTENFSN(pOrigem         tdvadm.t_ctb_movimento.ctb_movimento_origem%type,
                             pDataLancamento tdvadm.t_ctb_movimento.ctb_movimento_dtmovto%type,
                             pHistorico      tdvadm.t_ctb_movimento.ctb_movimento_descricao%type,
                             pVerba          tdvadm.t_con_calcconhecimento.slf_reccust_codigo%type)
      return tdvadm.t_con_calcconhecimento.con_calcviagem_valor%type;
                              


function FN_GET_DADOSCTENFST(pOrigem         tdvadm.t_ctb_movimento.ctb_movimento_origem%type,
                             pDataLancamento tdvadm.t_ctb_movimento.ctb_movimento_dtmovto%type,
                             pHistorico      tdvadm.t_ctb_movimento.ctb_movimento_descricao%type,
                             pTipoRetorno    char)
                             -- pTipoRetorno : TC Tipo de Carga
      return varchar2;



END PKG_CTB_LINKS;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_CTB_LINKS AS

  vFreteConhecHist char(1) := 'N';

FUNCTION GET_REFCTB RETURN VARCHAR2 IS
   BEGIN
      RETURN pkg_glb_common.GET_SISTEMAFECHAMENTO('CTB');
   END GET_REFCTB;

/*
FUNCTION fn_link_ctb_ctrecb(p_dtini in char,p_dtfin in char)
   RETURN TB_LINK_CTB_CTRECB IS

VT_LINK_CTB_CTRECB TB_LINK_CTB_CTRECB;

BEGIN

/*
TYPE TP_LINK_CTB_CTRECB IS RECORD (
                                TIPO      VARCHAR2(20),
                                TIT       VARCHAR2(10),
                                SEQ       INTEGER,
                                CLI       VARCHAR2(50),
                                DIA       DATE,
                                CCUSTO    CHAR(3),
                                CRESP     CHAR(3),
                                PCONTA    CHAR(12),
                                CONTA     VARCHAR2(50),
                                HIST      CHAR(3),
                                DESCRICAO VARCHAR2(50),
                                VALOR     NUMBER
                               );



SELECT TIPO,
       TIT,
       SEQ,
       CLI,
       DIA,
       CCUSTO,
       CRESP,
       PCONTA,
       CONTA,
       HIST,
       DESCRICAO,
       VALOR
  INTO VT_LINK_CTB_CTRECB 
  FROM (
SELECT 'NOTA DEBITO'                            TIPO,
       T.CRP_TITRECEBER_NUMTITULO               TIT,
       0                                        SEQ,
       C.GLB_CLIENTE_RAZAOSOCIAL                CLI,
       TRUNC(T.CRP_TITRECEBER_DTGERACAO)        DIA,
       NULL                                     CCUSTO,
       NULL                                     CRESP,
       F.CTB_PCONTA_CODIGO                      PCONTA,
       PC.CTB_PCONTA_DESCRICAO                  CONTA,
       F.CTB_HISTORICO_CODIGO                   HIST,
       H.CTB_HISTORICO_DESCRICAO                DESCRICAO,
       NVL(T.CRP_TITRECEBER_VLRCOBRADO,0)       VALOR
  FROM T_CRP_TITRECEBER T,
       T_GLB_FINALIDADE F,
       T_GLB_CLIENTE C,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND F.CTB_PCONTA_CODIGO         = PC.CTB_PCONTA_CODIGO(+)
   AND F.CTB_HISTORICO_CODIGO      = H.CTB_HISTORICO_CODIGO(+)
   AND T.GLB_FINALIDADE_CODIGO     = F.GLB_FINALIDADE_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO  = C.GLB_CLIENTE_CGCCPFCODIGO
   AND T.CRP_TITRECEBER_DTGERACAO >= '01/07/2013'
   AND T.CRP_TITRECEBER_DTGERACAO <= '31/07/2013'
   AND T.GLB_ROTA_CODIGO           = TRIM(FN_GETPARM('NOTADEBITO',1))
   AND NVL(T.CRP_TITRECEBER_CANCELADO,'N') <> 'S'
 -- CURSOR C_PAGT (Pagamentos Recebidos e N?o Cancelados)
UNION ALL
SELECT 'PAGAMENTOS'                                                                                                 TIPO,
       T.CRP_TITRECEBER_NUMTITULO                                                                                   TIT,
       TE.CRP_TITRECEVENTO_SEQ                                                                                      SEQ,
       C.GLB_CLIENTE_RAZAOSOCIAL                                                                                    CLI,
       TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO)                                                                          DIA,
       DECODE(E.GLB_EVENTO_CENTROCUSTO,'S',TE.GLB_ROTA_CODIGO,NULL)                                                 CCUSTO,
       DECODE(E.GLB_EVENTO_CENTROCUSTO,'S',TE.GLB_ROTA_CODIGO,NULL)                                                 CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) PCONTA,
       PC.CTB_PCONTA_DESCRICAO                                                                                      CONTA,
       E.CTB_HISTORICO_CODIGODEB                                                                                    HIST,
       H.CTB_HISTORICO_DESCRICAO                                                                                    DESCRICAO,
       TE.CRP_TITRECEVENTO_VALOR                                                                                    VALOR
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_GLB_EVENTO E,
       T_GLB_CLIENTE C,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) = PC.CTB_PCONTA_CODIGO
   AND E.CTB_HISTORICO_CODIGODEB            = H.CTB_HISTORICO_CODIGO
   AND TE.GLB_EVENTO_CODIGO                 = E.GLB_EVENTO_CODIGO
   AND TE.CRP_TITRECEBER_NUMTITULO          = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE              = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO                   = T.GLB_ROTA_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO           = C.GLB_CLIENTE_CGCCPFCODIGO
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR     IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC        IS NULL
-- AND TE.CRP_TITRECEVENTO_DATACTB         IS NULL
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) >= '01/07/2013'
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/07/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB)      = 'P'

-- CURSOR C_CDIVS (Credores Diversos Recebidos e N?o Cancelados)
UNION ALL
SELECT 'C-DIVERSOS'                                                                                                  TIPO,
       T.CRP_TITRECEBER_NUMTITULO                                                                                    TIT,
       0                                                                                                             SEQ,
       C.GLB_CLIENTE_RAZAOSOCIAL                                                                                     CLI,
       TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO)                                                                           DIA,
       DECODE(E.GLB_EVENTO_CENTROCUSTO,'S',TE.GLB_ROTA_CODIGO,NULL)                                                  CCUSTO,
       DECODE(E.GLB_EVENTO_CENTROCUSTO,'S',TE.GLB_ROTA_CODIGO,NULL)                                                  CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12)  PCONTA,
       PC.CTB_PCONTA_DESCRICAO                                                                                       CONTA,
       E.CTB_HISTORICO_CODIGODEB                                                                                     HIST,
       H.CTB_HISTORICO_DESCRICAO                                                                                     DESCRICAO,
       TE.CRP_TITRECEVENTO_VALOR                                                                                     VALOR
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_GLB_EVENTO E,
       T_GLB_CLIENTE C,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) = PC.CTB_PCONTA_CODIGO
   AND E.CTB_HISTORICO_CODIGODEB            = H.CTB_HISTORICO_CODIGO
   AND TE.GLB_EVENTO_CODIGO                 = E.GLB_EVENTO_CODIGO
   AND TE.CRP_TITRECEBER_NUMTITULO          = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE              = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO                   = T.GLB_ROTA_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO           = C.GLB_CLIENTE_CGCCPFCODIGO
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR     IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC        IS NULL
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) >= '01/07/2013'
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/07/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB)      IN 'S'


-- *******************************************************************************************************************************************

 -- CURSOR C_DESC (Descontos Aplicados e Retensao de Impostos e N?o Canceladas)
UNION ALL
SELECT * FROM (
SELECT 'DESCONTO'                                                                                                    TIPO,
       T.CRP_TITRECEBER_NUMTITULO                                                                                    TIT,
       TE.CRP_TITRECEVENTO_SEQ                                                                                       SEQ,
       CL.GLB_CLIENTE_RAZAOSOCIAL                                                                                    CLI,
       TRUNC(T.CRP_TITRECEBER_DTBAIXA)                                                                               DIA,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL)                                CCUSTO,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL)  CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12)  PCONTA,
       PC.CTB_PCONTA_DESCRICAO                                                                                       CONTA,
       E.CTB_HISTORICO_CODIGODEB                                                                                     HIST,
       H.CTB_HISTORICO_DESCRICAO                                                                                     DESCRICAO,
       sum(decode(fn_vrfcrpconhec(TE.CRP_TITRECEBER_NUMTITULO,TE.CRP_TITRECEBER_SAQUE,TE.CRP_TITRECEVENTO_SEQ,TE.GLB_ROTA_CODIGO),0,te.crp_titrecevento_valor,CE.CRP_CONHECEVENTO_VALOR))           VALOR
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_CRP_CONHECEVENTO CE,
       T_CON_CONHECIMENTO C,
       T_GLB_EVENTO E,
       T_GLB_ROTA R,
       T_GLB_CLIENTE CL,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) = PC.CTB_PCONTA_CODIGO
   AND E.CTB_HISTORICO_CODIGODEB            = H.CTB_HISTORICO_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO           = CL.GLB_CLIENTE_CGCCPFCODIGO(+)
   AND TE.GLB_EVENTO_CODIGO                 = E.GLB_EVENTO_CODIGO(+)
   AND TE.CRP_TITRECEBER_NUMTITULO          = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE              = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO                   = T.GLB_ROTA_CODIGO(+)
   AND TE.CRP_TITRECEBER_NUMTITULO          = CE.CRP_TITRECEBER_NUMTITULO(+)
   AND TE.CRP_TITRECEBER_SAQUE              = CE.CRP_TITRECEBER_SAQUE(+)
   AND TE.CRP_TITRECEVENTO_SEQ              = CE.CRP_TITRECEVENTO_SEQ(+)
   AND TE.GLB_ROTA_CODIGO                   = CE.GLB_ROTA_CODIGO(+)
   AND CE.CON_CONHECIMENTO_CODIGO           = C.CON_CONHECIMENTO_CODIGO(+)
   AND CE.CON_CONHECIMENTO_SERIE            = C.CON_CONHECIMENTO_SERIE(+)
   AND CE.GLB_ROTA_CODIGOCONHEC             = C.GLB_ROTA_CODIGO(+)
   AND C.GLB_ROTA_CODIGO                    = R.GLB_ROTA_CODIGO(+)
   AND DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL) IS NOT NULL
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR     IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC        IS NULL
--   AND TE.CRP_TITRECEVENTO_DATACTB         IS NULL
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/07/2013'
--   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/03/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB)      IN ('D','I')
   AND T.CRP_TITRECEBER_PAGO <> 'S'
   AND decode(fn_vrfcrpconhec(TE.CRP_TITRECEBER_NUMTITULO,TE.CRP_TITRECEBER_SAQUE,TE.CRP_TITRECEVENTO_SEQ,TE.GLB_ROTA_CODIGO),0,te.crp_titrecevento_valor,CE.CRP_CONHECEVENTO_VALOR) <> 0
   and 0 = (SELECT COUNT(*)
            FROM T_CON_FATURAEXCEL FE,
                 T_CON_FATURA F
            WHERE FE.CON_FATURA_CODIGO        = T.CON_FATURA_CODIGO
              AND FE.CON_FATURA_CICLO         = T.CON_FATURA_CICLO
              AND FE.GLB_ROTA_CODIGOFILIALIMP = T.GLB_ROTA_CODIGOFILIALIMP
              AND FE.CON_FATURA_CODIGO        = F.CON_FATURA_CODIGO
              AND FE.CON_FATURA_CICLO         = F.CON_FATURA_CICLO
              AND FE.GLB_ROTA_CODIGOFILIALIMP = F.GLB_ROTA_CODIGOFILIALIMP
              AND F.CON_FATURA_STATUS = 'I'
              AND F.CON_FATURA_DATACANC IS NULL)
GROUP BY T.CRP_TITRECEBER_NUMTITULO,
          TE.CRP_TITRECEVENTO_SEQ,
          CL.GLB_CLIENTE_RAZAOSOCIAL,
          TRUNC(T.CRP_TITRECEBER_DTBAIXA),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL),
          SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12),
          PC.CTB_PCONTA_DESCRICAO,
          E.CTB_HISTORICO_CODIGODEB,
          H.CTB_HISTORICO_DESCRICAO,
          NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO)

UNION
SELECT 'DESCONTO'                                                                                                    TIPO,
       T.CRP_TITRECEBER_NUMTITULO                                                                                    TIT,
       TE.CRP_TITRECEVENTO_SEQ                                                                                       SEQ,
       CL.GLB_CLIENTE_RAZAOSOCIAL                                                                                    CLI,
       TRUNC(T.CRP_TITRECEBER_DTBAIXA)                                                                               DIA,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL)                                CCUSTO,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL)  CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12)  PCONTA,
       PC.CTB_PCONTA_DESCRICAO                                                                                       CONTA,
       E.CTB_HISTORICO_CODIGODEB                                                                                     HIST,
       H.CTB_HISTORICO_DESCRICAO                                                                                     DESCRICAO,
       sum(decode(fn_vrfcrpconhec(TE.CRP_TITRECEBER_NUMTITULO,TE.CRP_TITRECEBER_SAQUE,TE.CRP_TITRECEVENTO_SEQ,TE.GLB_ROTA_CODIGO),0,te.crp_titrecevento_valor,CE.CRP_CONHECEVENTO_VALOR))           VALOR
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_CRP_CONHECEVENTO CE,
       T_CON_CONHECIMENTO C,
       T_GLB_EVENTO E,
       T_GLB_ROTA R,
       T_GLB_CLIENTE CL,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) = PC.CTB_PCONTA_CODIGO
   AND E.CTB_HISTORICO_CODIGODEB            = H.CTB_HISTORICO_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO           = CL.GLB_CLIENTE_CGCCPFCODIGO(+)
   AND TE.GLB_EVENTO_CODIGO                 = E.GLB_EVENTO_CODIGO(+)
   AND TE.CRP_TITRECEBER_NUMTITULO          = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE              = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO                   = T.GLB_ROTA_CODIGO(+)
   AND TE.CRP_TITRECEBER_NUMTITULO          = CE.CRP_TITRECEBER_NUMTITULO(+)
   AND TE.CRP_TITRECEBER_SAQUE              = CE.CRP_TITRECEBER_SAQUE(+)
   AND TE.CRP_TITRECEVENTO_SEQ              = CE.CRP_TITRECEVENTO_SEQ(+)
   AND TE.GLB_ROTA_CODIGO                   = CE.GLB_ROTA_CODIGO(+)
   AND CE.CON_CONHECIMENTO_CODIGO           = C.CON_CONHECIMENTO_CODIGO(+)
   AND CE.CON_CONHECIMENTO_SERIE            = C.CON_CONHECIMENTO_SERIE(+)
   AND CE.GLB_ROTA_CODIGOCONHEC             = C.GLB_ROTA_CODIGO(+)
   AND C.GLB_ROTA_CODIGO                    = R.GLB_ROTA_CODIGO(+)
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR     IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC        IS NULL
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     >= '01/07/2013'
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     <= '31/07/2013'
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/07/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB)      IN ('D','I')
   AND T.CRP_TITRECEBER_PAGO = 'S'
   AND decode(fn_vrfcrpconhec(TE.CRP_TITRECEBER_NUMTITULO,TE.CRP_TITRECEBER_SAQUE,TE.CRP_TITRECEVENTO_SEQ,TE.GLB_ROTA_CODIGO),0,te.crp_titrecevento_valor,CE.CRP_CONHECEVENTO_VALOR) <> 0
   and 0 = (SELECT COUNT(*)
            FROM T_CON_FATURAEXCEL FE,
                 T_CON_FATURA F
            WHERE FE.CON_FATURA_CODIGO        = T.CON_FATURA_CODIGO
              AND FE.CON_FATURA_CICLO         = T.CON_FATURA_CICLO
              AND FE.GLB_ROTA_CODIGOFILIALIMP = T.GLB_ROTA_CODIGOFILIALIMP
              AND FE.CON_FATURA_CODIGO        = F.CON_FATURA_CODIGO
              AND FE.CON_FATURA_CICLO         = F.CON_FATURA_CICLO
              AND FE.GLB_ROTA_CODIGOFILIALIMP = F.GLB_ROTA_CODIGOFILIALIMP
              AND F.CON_FATURA_STATUS = 'I'
              AND F.CON_FATURA_DATACANC IS NULL)
GROUP BY T.CRP_TITRECEBER_NUMTITULO,
          TE.CRP_TITRECEVENTO_SEQ,
          CL.GLB_CLIENTE_RAZAOSOCIAL,
          TRUNC(T.CRP_TITRECEBER_DTBAIXA),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL),
          SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12),
          PC.CTB_PCONTA_DESCRICAO,
          E.CTB_HISTORICO_CODIGODEB,
          H.CTB_HISTORICO_DESCRICAO,
          NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO)
UNION
SELECT 'DESCONTO'                                                                                                    TIPO,
       T.CRP_TITRECEBER_NUMTITULO                                                                                    TIT,
       TE.CRP_TITRECEVENTO_SEQ                                                                                       SEQ,
       CL.GLB_CLIENTE_RAZAOSOCIAL                                                                                    CLI,
       TRUNC(T.CRP_TITRECEBER_DTBAIXA)                                                                               DIA,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL)                                CCUSTO,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL)  CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12)  PCONTA,
       PC.CTB_PCONTA_DESCRICAO                                                                                       CONTA,
       E.CTB_HISTORICO_CODIGODEB                                                                                     HIST,
       H.CTB_HISTORICO_DESCRICAO                                                                                     DESCRICAO,
       SUM(NVL(FE.CON_FATURAEXCEL_GLOSA,0)) valor
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_CON_FATURAEXCEL FE,
       T_CON_CONHECIMENTO C,
       T_GLB_EVENTO E,
       T_GLB_ROTA R,
       T_GLB_CLIENTE CL,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) = PC.CTB_PCONTA_CODIGO
   AND E.CTB_HISTORICO_CODIGODEB            = H.CTB_HISTORICO_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO           = CL.GLB_CLIENTE_CGCCPFCODIGO(+)
   AND TE.GLB_EVENTO_CODIGO                 = E.GLB_EVENTO_CODIGO(+)
   AND TE.CRP_TITRECEBER_NUMTITULO          = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE              = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO                   = T.GLB_ROTA_CODIGO(+)
   AND T.CON_FATURA_CODIGO                  = FE.CON_FATURA_CODIGO
   AND T.CON_FATURA_CICLO                   = FE.CON_FATURA_CICLO
   AND T.GLB_ROTA_CODIGOFILIALIMP           = FE.GLB_ROTA_CODIGOFILIALIMP
   AND FE.CON_CONHECIMENTO_CODIGO           = C.CON_CONHECIMENTO_CODIGO
   AND FE.CON_CONHECIMENTO_SERIE            = C.CON_CONHECIMENTO_SERIE
   AND FE.GLB_ROTA_CODIGO                   = C.GLB_ROTA_CODIGO
   AND C.GLB_ROTA_CODIGO                    = R.GLB_ROTA_CODIGO(+)
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR     IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC        IS NULL
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     >= '01/07/2013'
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     <= '31/07/2013'
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/07/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB)      IN ('D','I')
   AND T.CRP_TITRECEBER_PAGO = 'S'
   AND FE.CON_FATURAEXCEL_GLOSA <> 0
   and 0 < (SELECT COUNT(*)
            FROM T_CON_FATURAEXCEL FE,
                 T_CON_FATURA F
            WHERE FE.CON_FATURA_CODIGO        = T.CON_FATURA_CODIGO
              AND FE.CON_FATURA_CICLO         = T.CON_FATURA_CICLO
              AND FE.GLB_ROTA_CODIGOFILIALIMP = T.GLB_ROTA_CODIGOFILIALIMP
              AND FE.CON_FATURA_CODIGO        = F.CON_FATURA_CODIGO
              AND FE.CON_FATURA_CICLO         = F.CON_FATURA_CICLO
              AND FE.GLB_ROTA_CODIGOFILIALIMP = F.GLB_ROTA_CODIGOFILIALIMP
              AND F.CON_FATURA_STATUS = 'I'
              AND F.CON_FATURA_DATACANC IS NULL)
GROUP BY T.CRP_TITRECEBER_NUMTITULO,
          TE.CRP_TITRECEVENTO_SEQ,
          CL.GLB_CLIENTE_RAZAOSOCIAL,
          TRUNC(T.CRP_TITRECEBER_DTBAIXA),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL),
          SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12),
          PC.CTB_PCONTA_DESCRICAO,
          E.CTB_HISTORICO_CODIGODEB,
          H.CTB_HISTORICO_DESCRICAO,
          NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))

 -- CURSOR C_ACREC (Descontos Aplicados e N?o Canceladas)
UNION ALL
SELECT DISTINCT
       'ACRECIMOS'                                                                                                   TIPO,
       T.CRP_TITRECEBER_NUMTITULO                                                                                    TIT,
       0                                                                                                             SEQ,       
       CL.GLB_CLIENTE_RAZAOSOCIAL                                                                                    CLI,
       TRUNC(T.CRP_TITRECEBER_DTBAIXA)                                                                               DIA,
       DECODE(TRIM(E.GLB_EVENTO_CENTROCUSTO),'S',CE.GLB_ROTA_CODIGOCONHEC,NULL)                                      CCUSTO,
       DECODE(TRIM(E.GLB_EVENTO_CENTROCUSTO),'S',CE.GLB_ROTA_CODIGOCONHEC,NULL)                                      CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGOCRED,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) PCONTA,
       PC.CTB_PCONTA_DESCRICAO                                                                                       CONTA,
       E.CTB_HISTORICO_CODIGOCRED                                                                                    HIST,
       H.CTB_HISTORICO_DESCRICAO                                                                                     DESCRICAO,
       TE.CRP_TITRECEVENTO_VALOR                                                                                     VALOR
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_GLB_EVENTO E,
       T_GLB_CLIENTE CL,
       T_CRP_CONHECEVENTO CE,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND SUBSTR(REPLACE(E.CTB_PCONTA_CODIGOCRED,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) = PC.CTB_PCONTA_CODIGO
   AND E.CTB_HISTORICO_CODIGOCRED       = H.CTB_HISTORICO_CODIGO
   AND T.CRP_TITRECEBER_PAGO            = 'S'
   AND TE.GLB_EVENTO_CODIGO             = E.GLB_EVENTO_CODIGO
   AND TE.CRP_TITRECEBER_NUMTITULO      = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE          = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO               = T.GLB_ROTA_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO       = CL.GLB_CLIENTE_CGCCPFCODIGO
   AND CE.CRP_TITRECEBER_NUMTITULO      = TE.CRP_TITRECEBER_NUMTITULO
   AND CE.CRP_TITRECEBER_SAQUE          = TE.CRP_TITRECEBER_SAQUE
   AND CE.CRP_TITRECEVENTO_SEQ          = TE.CRP_TITRECEVENTO_SEQ
   AND CE.GLB_ROTA_CODIGO               = TE.GLB_ROTA_CODIGO
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR     IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC        IS NULL
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     >= '01/07/2013'
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     <= '31/07/2013'
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/07/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB)      IN (SELECT TRIM(CTB_LINKPARAMETRO_CONTEUDOCHAR)
                                               FROM T_CTB_LINKPARAMETRO
                                               WHERE CTB_LINKPARAMETRO_TIPO = 'TPEVCRBACR')

 -- CURSOR C_EXCL (Descontos Aplicados e N?o Canceladas)
UNION ALL
SELECT 'DESCONTO'                                                                                                   TIPO,
       T.CRP_TITRECEBER_NUMTITULO                                                                                   TIT,
       TE.CRP_TITRECEVENTO_SEQ                                                                                      SEQ,
       CL.GLB_CLIENTE_RAZAOSOCIAL                                                                                   CLI,
       TRUNC(T.CRP_TITRECEBER_DTBAIXA)                                                                              DIA,
       DECODE(TRIM(E.GLB_EVENTO_CENTROCUSTO),'S',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),NULL)              CCUSTO,
       NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO)                                                              CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) PCONTA,
       PC.CTB_PCONTA_DESCRICAO                                                                                      CONTA,
       E.CTB_HISTORICO_CODIGODEB                                                                                    HIST,
       H.CTB_HISTORICO_DESCRICAO                                                                                    DESCRICAO,
       CE.CRP_CONHECEVENTO_VALOR                                                                                    VALOR
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_CRP_CONHECEVENTO CE,
       T_CON_CONHECIMENTO C,
       T_GLB_EVENTO E,
       T_GLB_CLIENTE CL,
       T_CTB_PCONTA PC,
       T_CTB_HISTORICO H
 WHERE 0 = 0
   AND SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12) = PC.CTB_PCONTA_CODIGO
   AND E.CTB_HISTORICO_CODIGODEB            = H.CTB_HISTORICO_CODIGO
   AND T.GLB_CLIENTE_CGCCPFCODIGO           = CL.GLB_CLIENTE_CGCCPFCODIGO
   AND TE.GLB_EVENTO_CODIGO                 = E.GLB_EVENTO_CODIGO
   AND TE.CRP_TITRECEBER_NUMTITULO          = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE              = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO                   = T.GLB_ROTA_CODIGO
   AND CE.CRP_TITRECEBER_NUMTITULO          = TE.CRP_TITRECEBER_NUMTITULO
   AND CE.CRP_TITRECEBER_SAQUE              = TE.CRP_TITRECEBER_SAQUE
   AND CE.CRP_TITRECEVENTO_SEQ              = TE.CRP_TITRECEVENTO_SEQ
   AND CE.GLB_ROTA_CODIGO                   = TE.GLB_ROTA_CODIGO
   AND CE.CON_CONHECIMENTO_CODIGO           = C.CON_CONHECIMENTO_CODIGO
   AND CE.CON_CONHECIMENTO_SERIE            = C.CON_CONHECIMENTO_SERIE
   AND CE.GLB_ROTA_CODIGOCONHEC             = C.GLB_ROTA_CODIGO
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC    IS NULL
-- AND TE.CRP_TITRECEVENTO_DATACTB     IS NULL
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     >= '01/07/2013'
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     <= '31/07/2013'
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/07/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB) = 'X'
   AND T.CRP_TITRECEBER_PAGO = 'S'
   AND CE.CRP_CONHECEVENTO_VALOR <> 0);
          
  RETURN VT_LINK_CTB_CTRECB;
END;                  
*/

PROCEDURE SET_CATVF(P_REFERENCIA IN CHAR)
  AS
BEGIN
--01  Uma Viagem
--02  Várias Viagens
--03  Tombo
--04  Reforço
--05  Complemento
--06  Transpesa
--07  Remoção
--08  Avulso (Despesa TDV)
--09  Avulso com CTRC
--10  Serviço de Terceiro
--11  Manifesto CVRD
--12  Avulso Manifesto
--13  Bônus CVRD Manifesto
--14  Bônus CVRD CTRC
--15  Operação Coca-Cola
--16  Viagem CTRC s/ Placa
--17  Estadia
--18  Coleta
  
  IF P_REFERENCIA <= '200706' THEN
     vGLB_CATVF := '04,07,10';
  ELSE    
     vGLB_CATVF := '04,10';
  END IF;   
END SET_CATVF;  

FUNCTION GET_CATVF RETURN VARCHAR2 IS
   BEGIN
      RETURN vGLB_CATVF;
   END GET_CATVF;

-- Função que retorna data de competencia contabil dos eventos do contas a receber.
   
FUNCTION FN_GET_CTBREFSTATUS(P_REF IN CHAR) RETURN CHAR IS

/* ----------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : CONTABILIDADE
 * OBJETIVO     : RETORNAR O STATUS DA REFERENCIA CONTABIL
 * PROGRAMA     : FN_GET_CTBREFSTATUS
 * ANALISTA     : Roberto Pariz
 * PROGRAMADOR  : Roberto Pariz
 * CRIACAO      : 12-05-2015
 * BANCO        : ORACLE
 * PARAMETRO    : P_REF - REFERENCIA CONTABIL A SER VERIFICADA 'AAAAMM'
 * RETORNO      : STATUS DA REFERENCIA CONTAIL (A)BERTA OU (F)ECHADA
 * ALTERACAO    :
 *
 * ---------------------------------------------------------------------------------------------------------------------------
 */

vStatus char(1);

begin
  BEGIN
    SELECT r.ctb_referencia_status 
      INTO vStatus
      FROM t_ctb_referencia r
     WHERE r.ctb_referencia_codigo = p_ref;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      vStatus := 'F';   
    END;
  return vStatus;
end FN_GET_CTBREFSTATUS;
 

FUNCTION FN_GET_EVENTO_DTCOMPET(P_DTEVENTO IN CHAR,
                                P_DTLANCTO IN CHAR,
                                P_DTDOC    IN CHAR DEFAULT NULL,
                                P_REFCTB   IN CHAR DEFAULT NULL) 
           RETURN CHAR 
     IS

/* ----------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : CONTAS A RECEBER
 * OBJETIVO     : RETORNAR A DATA DE COMPETENCIA CONTABIL NA QUAL O EVENTO SERA CONTABILIZADO
 * PROGRAMA     : FN_GET_EVENTO_DTCOMPET
 * ANALISTA     : Roberto Pariz
 * PROGRAMADOR  : Roberto Pariz
 * CRIACAO      : 12-05-2015
 * BANCO        : ORACLE
 * PARAMETRO    : P_DTEVENTO 
 *              : P_DTLANCTO 
 *              : P_REFCTB   
 * RETORNO      : DATA DE COMPETENCIA CONTABIL
 * ALTERACAO    :
 *
 * ---------------------------------------------------------------------------------------------------------------------------
 */

vDtevento         date    := to_date(nvl(P_DTEVENTO,'01/01/1900'),'dd/mm/yyyy');
vDtlancto         date    := to_date(nvl(P_DTLANCTO,'01/01/1900'),'dd/mm/yyyy');
vRefctb           char(6) := nvl(P_REFCTB,pkg_glb_common.Fn_Refr_Next(pkg_glb_common.Get_Sistemafechamento('CRP','R')));
vDtDoc           char(10) := P_DTDOC;
vDtRetorno       char(10);
vAuxiliar        char(10);
begin


    if vDtDoc is null Then
        If trim(to_char(vDtevento,'yyyymm')) = vRefctb then
          vDtRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
        ElsIf trim(to_char(vDtevento,'yyyymm')) > vRefctb Then
          vDtRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
        ElsIf trim(to_char(vDtevento,'yyyymm')) < vRefctb Then
          vDtRetorno := to_char(last_day(to_date(vRefctb||'01','yyyymmdd')) ,'dd/mm/yyyy');
        End If;
    Else

        If trim(to_char(vDtevento,'yyyymm')) > to_char(TO_DATE(vDtDoc,'DD/MM/YYYY'),'yyyymm') Then
          vDtRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
        ElsIf trim(to_char(vDtevento,'yyyymm')) < to_char(TO_DATE(vDtDoc,'DD/MM/YYYY'),'yyyymm') Then
          vDtRetorno := vDtDoc;
        ElsIf trim(to_char(vDtevento,'yyyymm')) = TO_CHAR(TO_DATE(vDtDoc,'DD/MM/YYYY'),'yyyymm') then
          vDtRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
       End If;
  
       -- se a referencia da Data escolhida for diferente da referencia Contabilizada volta o Ultimo dia do mes
--        vDtDoc := nvl(vDtDoc,to_char(TO_DATE(vDtRetorno,'dd/mm/yyyy'),'yyyymm'));
        if  trim(to_char(vDtevento,'yyyymm')) > vRefctb Then
            vDtRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
        ElsIf trim(to_char(vDtevento,'yyyymm')) < vRefctb Then
            vDtRetorno := to_char(last_day(to_date(vRefctb||'01','yyyymmdd')) ,'dd/mm/yyyy');
        ElsIf trim(to_char(vDtevento,'yyyymm')) = vRefctb Then
            vDtRetorno := to_char(vDtevento ,'dd/mm/yyyy');
        Elsif TO_DATE(vDtRetorno,'dd/mm/yyyy') <>  TO_DATE(vDtDoc,'dd/mm/yyyy') Then
           vDtRetorno := to_char(last_day(to_date(vDtDoc,'dd/mm/yyyy')) ,'dd/mm/yyyy');
        End If;
    End If;
        -- se a referencia da Data escolhida for diferente da referencia do Conhecimento volta o Ultimo dia do mes
    vRefctb := nvl(vRefctb,to_char(TO_DATE(vDtRetorno,'dd/mm/yyyy'),'yyyymm'));
   if to_char(TO_DATE(vDtRetorno,'dd/mm/yyyy'),'yyyymm') < vRefctb Then
      vDtRetorno := to_char(last_day(to_date(vRefctb||'01','yyyymmdd')) ,'dd/mm/yyyy');
   Elsif to_char(TO_DATE(vDtRetorno,'dd/mm/yyyy'),'yyyymm') = vRefctb Then
      vDtRetorno := vDtRetorno;
   End If;

   Begin
     vAuxiliar := to_char(to_date(vDtRetorno,'dd/mm/yyyy'),'YYYYMM');
   exception
     When OTHERS Then
        raise_application_error(-20081,'Data retorno [' || vDtRetorno || ']' || sqlerrm); 
     End;
     
   Begin
     vAuxiliar := trim(to_char(to_date(vDtDoc,'dd/mm/yyyy'),'YYYYMM'));
   exception
     When OTHERS Then
        raise_application_error(-20091,'Data Doc [' || vDtDoc || ']' || sqlerrm); 
     End;


   if    ( to_char(to_date(vDtRetorno,'dd/mm/yyyy'),'YYYYMM') =  to_char(to_date(vDtDoc,'dd/mm/yyyy'),'YYYYMM') ) and  ( to_date(vDtRetorno,'dd/mm/yyyy') < to_date(vDtDoc,'dd/mm/yyyy') ) Then
       vDtRetorno := vDtDoc;
   End If;

   If ( to_char(to_date(vDtRetorno,'dd/mm/yyyy'),'YYYYMM') <> to_char(to_date(vDtDoc,'dd/mm/yyyy'),'YYYYMM') ) and  ( to_date(vDtRetorno,'dd/mm/yyyy') < to_date(vDtDoc,'dd/mm/yyyy') ) Then
       vDtRetorno := last_day(to_date(vDtDoc,'dd/mm/yyyy'));
   End If;
    
    return vDtRetorno;
     
end FN_GET_EVENTO_DTCOMPET;


FUNCTION FN_GET_EVENTO_DTCOMPETold(P_DTEVENTO IN CHAR,
                                P_DTLANCTO IN CHAR,
                                P_REFDOC   IN CHAR DEFAULT NULL,
                                P_REFCTB   IN CHAR DEFAULT NULL) 
           RETURN CHAR 
     IS

/* ----------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : CONTAS A RECEBER
 * OBJETIVO     : RETORNAR A DATA DE COMPETENCIA CONTABIL NA QUAL O EVENTO SERA CONTABILIZADO
 * PROGRAMA     : FN_GET_EVENTO_DTCOMPET
 * ANALISTA     : Roberto Pariz
 * PROGRAMADOR  : Roberto Pariz
 * CRIACAO      : 12-05-2015
 * BANCO        : ORACLE
 * PARAMETRO    : P_DTEVENTO 
 *              : P_DTLANCTO 
 *              : P_REFCTB   
 * RETORNO      : DATA DE COMPETENCIA CONTABIL
 * ALTERACAO    :
 *
 * ---------------------------------------------------------------------------------------------------------------------------
 */

vDtevento         date    := to_date(nvl(P_DTEVENTO,'01/01/1900'),'dd/mm/yyyy');
vDtlancto         date    := to_date(nvl(P_DTLANCTO,'01/01/1900'),'dd/mm/yyyy');
vRefctb           char(6) := nvl(P_REFCTB,pkg_glb_common.Fn_Refr_Next(pkg_glb_common.Get_Sistemafechamento('CRP','R')));
vRefDoc           char(10) := P_REFDOC;
vDtfRetorno       char(10);
begin


    if vRefDoc is null Then
        If trim(to_char(vDtevento,'yyyymm')) = vRefctb then
          vDtfRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
        ElsIf trim(to_char(vDtevento,'yyyymm')) > vRefctb Then
          vDtfRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
        ElsIf trim(to_char(vDtevento,'yyyymm')) < vRefctb Then
          vDtfRetorno := to_char(last_day(to_date(vRefctb||'01','yyyymmdd')) ,'dd/mm/yyyy');
        End If;
    Else

        If trim(to_char(vDtevento,'yyyymm')) > to_char(TO_DATE(vRefDoc,'DD/MM/YYYY'),'yyyymm') Then
          vDtfRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
        ElsIf trim(to_char(vDtevento,'yyyymm')) < to_char(TO_DATE(vRefDoc,'DD/MM/YYYY'),'yyyymm') Then
          vDtfRetorno := vRefDoc;
        ElsIf trim(to_char(vDtevento,'yyyymm')) = TO_CHAR(TO_DATE(vRefDoc,'DD/MM/YYYY'),'yyyymm') then
          vDtfRetorno := trim(to_char(vDtevento,'dd/mm/yyyy'));
       End If;
  
       -- se a referencia da Data escolhida for diferente da referencia Contabilizada volta o Ultimo dia do mes
--        vRefDoc := nvl(vRefDoc,to_char(TO_DATE(vDtfRetorno,'dd/mm/yyyy'),'yyyymm'));
        if TO_DATE(vDtfRetorno,'dd/mm/yyyy') <>  TO_DATE(vRefDoc,'dd/mm/yyyy') Then
           vDtfRetorno := to_char(last_day(to_date(vRefDoc,'dd/mm/yyyy')) ,'dd/mm/yyyy');
        End If;
    End If;
        -- se a referencia da Data escolhida for diferente da referencia do Conhecimento volta o Ultimo dia do mes
    vRefctb := nvl(vRefctb,to_char(TO_DATE(vDtfRetorno,'dd/mm/yyyy'),'yyyymm'));
   if to_char(TO_DATE(vDtfRetorno,'dd/mm/yyyy'),'yyyymm') < vRefctb Then
      vDtfRetorno := to_char(last_day(to_date(vRefctb||'01','yyyymmdd')) ,'dd/mm/yyyy');
   End If;
    
    
    
    
    return vDtfRetorno;
     
end FN_GET_EVENTO_DTCOMPETold;


FUNCTION FN_GET_CODMERCADORIA(P_CODCTE    TDVADM.T_GLB_MERCADORIA.GLB_MERCADORIA_CODIGO%TYPE,
                              P_CODTABSOL TDVADM.T_GLB_MERCADORIA.GLB_MERCADORIA_CODIGO%TYPE)RETURN CHAR IS

vRetorno TDVADM.T_GLB_MERCADORIA.GLB_MERCADORIA_CODIGO%TYPE:= '$$';
BEGIN
  
  --EX EXPORTACAO       
  --NE NIQUEL EXPORTACAO
  --09 CARVAO           
  --CI NITRATO          
  --BM BOLA DE MOINHO   


  -- 1º Nivel Conhecimento
  if (P_CODCTE in ('EX','NE','09','CI','BM')) then
    vRetorno := P_CODCTE;
  else
    --2º Tabela ou Solicitação
    if (P_CODTABSOL in ('EX','NE','09','CI','BM')) then
      vRetorno := P_CODTABSOL; 
    else
      vRetorno := P_CODCTE;
    end if;   
  
  end if;

  RETURN vRetorno;  
  
END FN_GET_CODMERCADORIA;




PROCEDURE SET_SERIEVF(P_REFERENCIA IN CHAR)
  AS
BEGIN
 
  IF P_REFERENCIA <= '200706' THEN
     vGLB_SERIEVF := 'A1';
  ELSE    
     -- COLOQUEI ASSIM PORQUE TODAS AS SERIES TEM UM NUMERO AI A 
     -- FUNCAO INSTR VAI RETORNAR MAIOR QUE 0 (ZERO)
     vGLB_SERIEVF := 'A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,C0,C1';
  END IF;   
END SET_SERIEVF;  

FUNCTION GET_SERIEVF RETURN VARCHAR2 IS
   BEGIN
      RETURN vGLB_SERIEVF;
   END GET_SERIEVF;
   
PROCEDURE SET_TPDATAVF(P_REFERENCIA IN CHAR)
  AS
BEGIN
 
  IF P_REFERENCIA <= '200710' THEN
     vGLB_TPDATAVF := 'EMISSAO';
     vGLB_TPDATAVF := 'CADASTRO';
  ELSE    
     vGLB_TPDATAVF := 'CADASTRO';
  END IF;   
END SET_TPDATAVF;  

FUNCTION GET_TPDATAVF RETURN VARCHAR2 IS
   BEGIN
      RETURN vGLB_TPDATAVF;
   END GET_TPDATAVF;


PROCEDURE SET_TPDATAVFEX(P_REFERENCIA IN CHAR)
  AS
BEGIN
 
  IF P_REFERENCIA <= '201201' THEN
     vGLB_TPDATAVFEX := 'EMISSAO';
  ELSE    
     vGLB_TPDATAVFEX := 'CADASTRO';
  END IF;   
END SET_TPDATAVFEX;  

FUNCTION GET_TPDATAVFEX RETURN VARCHAR2 IS
   BEGIN
      RETURN vGLB_TPDATAVFEX;
   END GET_TPDATAVFEX;

PROCEDURE SP_LINK_CTB_TDVVFRETE(P_MES  IN CHAR,
                                P_ANO  IN CHAR,
                                P_DIA  IN CHAR,
                                P_MODO IN CHAR,
                                P_ID   IN CHAR)
-- P_MODO -> 1 PRODUCAO
--           2 PREVIA

AS

/* -----------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : Contabilidade
 * PROGRAMA     : SP_LINK_CTB_TDVVFRETE.SQL
 * ANALISTA     : Roberto Pariz
 * PROGRAMADOR  : Roberto Pariz
 * CRIACAO      : 14-02-2007
 * BANCO        : ORACLE
 * ALIMENTA     : T_CTB_MOVIMENTO
 * SIGLAS       : CTB,CON,GLB
 * ALTERACAO    : 15-05-2007 - Vers?o (3) - Roberto Pariz
 *              : * 16-07-2007 - Incluido os Vale Frete de Remocao                     - Roberto Pariz
 *              : * 16-07-2007 - Retirado o Filtro de Serie                            - Roberto Pariz
 *              : * 18-07-2007 - Verificac?o de Exportac?es                            - Roberto Pariz
 *              : & 09-08-2007 - Ajustado o CCusto INSS P/empresa                      - Roberto Pariz
 *              : & 11-10-2007 - Passou a Utilizar a View de Impotstos                 - Roberto Pariz
 *              : & 13-11-2007 - Passou a contabilizar na rota papel                   - Roberto Pariz
 *              : & 13-11-2007 - Atualiza T_CTB_LOGTRANSF nas previas                  - Roberto Pariz
 *              : * 13-11-2007 - Passou a usar a data de cadastro ao inves da emissa?o - Roberto Pariz
 *              : ? 14-03-2009 - Foi retirada a condic?o (T.CON_VALEFRETE_IMPRESSO='S')
 *                             Porque n?o e Confiavel e Para manter compatibilidade com V_CTB_IMPOSTOS2 - Roberto Pariz
 *              : ? 14-03-2009 - For acrescentada a condic?o (T.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL) 
 *                             Impede a contabilizac?o de Vales de Fretes Incompletos. - Roberto Pariz
 *              :
 * COMENTARIOS  : Link entre o Vale de Frete e a Contabilidade.
 * ATUALIZA     :
 * ---------------------------------------------------------------------------------------------------
 */

 VT_PROCNAME  Varchar2(100) := 'PKG_CTB_LINKS.SP_LINK_CTB_TDVVFRETE';
 VT_MES       CHAR(2);
 VT_DIA       CHAR(2);
 VT_CONTADOR  NUMBER;
 VT_DOCTO     INTEGER  := FN_GETDOCNUM;
 VT_SEQUENCIA INTEGER;
 VT_SOMA      NUMBER;
 VT_DTINI     DATE;
 VT_DTFIM     DATE;
 VT_DESCDEB   CHAR(50);
 VT_DESCCRE   CHAR(50);
-- VT_MODO      CHAR(1);
 VT_CONTROLE  CHAR(2);
 VT_USUARIO   CHAR(20);

 -- CURSOR C_FRETE_PEDG (Frete e Pedagio dos Vales de Frete Impressos e N?o Cancelados)

 CURSOR C_FRETE_PEDG IS
 SELECT TO_CHAR(T.CON_VALEFRETE_DATACADASTRO,'DD') DIA,
        T.GLB_ROTA_CODIGO                                                                                                          GLB_ROTA_CODIGO,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(trim(T.GLB_TPMOTORISTA_CODIGO),'A',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)))) FRETE,
        SUM(NVL(DECODE(P.CAR_PROPRIETARIO_TIPOPESSOA,'F',DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(trim(T.GLB_TPMOTORISTA_CODIGO),'A',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)-NVL(T.CON_VALEFRETE_PEDAGIO,0)))),0)) FRETESP_PF,
        SUM(NVL(DECODE(P.CAR_PROPRIETARIO_TIPOPESSOA,'J',DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(trim(T.GLB_TPMOTORISTA_CODIGO),'A',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)-NVL(T.CON_VALEFRETE_PEDAGIO,0)))),0)) FRETESP_PJ,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.CON_VALEFRETE_PEDAGIO,0)))) PEDAGIO
   FROM T_CON_VALEFRETE T,
        T_CAR_VEICULO V,
        T_CAR_PROPRIETARIO P,
        T_GLB_ROTA R
  WHERE 0 = (SELECT COUNT(*)
               FROM T_CTB_LINKWRK_VFRETEEXP VFE
              WHERE VFE.CON_VALEFRETE_CODIGO     = T.CON_CONHECIMENTO_CODIGO
                AND VFE.CON_VALEFRETE_SERIE      = T.CON_CONHECIMENTO_SERIE
                AND VFE.GLB_ROTA_CODIGOVALEFRETE = T.GLB_ROTA_CODIGO
                AND VFE.CON_VALEFRETE_SAQUE      = T.CON_VALEFRETE_SAQUE
                AND VFE.CTB_LINKWRK_LINKID       = P_ID)
   AND T.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL
   AND nvl(trim(T.GLB_TPMOTORISTA_CODIGO),'C')  <> 'F'
   AND NVL(T.CON_VALEFRETE_STATUS,'N')      = 'N'
   AND R.GLB_ROTA_CODIGO                    = T.GLB_ROTA_CODIGO
   AND T.CON_VALEFRETE_PLACA                = V.CAR_VEICULO_PLACA
   AND T.CON_VALEFRETE_PLACASAQUE           = V.CAR_VEICULO_SAQUE
   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO      = P.CAR_PROPRIETARIO_CGCCPFCODIGO
   AND trunc(T.CON_VALEFRETE_DATACADASTRO) >= VT_DTINI
   AND trunc(T.CON_VALEFRETE_DATACADASTRO) <= VT_DTFIM
   -- VERIFICA QUAIS CATEGORIAS NÃO PODEM ENTRAR
   AND INSTR(GET_CATVF,T.CON_CATVALEFRETE_CODIGO) = 0 
   AND INSTR(GET_SERIEVF,T.CON_CONHECIMENTO_SERIE)  > 0 
GROUP BY TO_CHAR(T.CON_VALEFRETE_DATACADASTRO,'DD'),
         T.GLB_ROTA_CODIGO;


 -- CURSOR C_FRETE_PEDG_EX (Frete e Pedagio dos Vales de Frete de EXPORTACAO Impressos e N?o Cancelados)

 CURSOR C_FRETE_PEDG_EX IS
 SELECT to_char(T.CON_VALEFRETE_DATACADASTRO,'DD') DIA,
        T.GLB_ROTA_CODIGO                                             GLB_ROTA_CODIGO,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(trim(T.GLB_TPMOTORISTA_CODIGO),'A',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)))) FRETE,
        SUM(NVL(DECODE(P.CAR_PROPRIETARIO_TIPOPESSOA,'F',DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(trim(T.GLB_TPMOTORISTA_CODIGO),'A',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)-NVL(T.CON_VALEFRETE_PEDAGIO,0)))),0)) FRETESP_PF,
        SUM(NVL(DECODE(P.CAR_PROPRIETARIO_TIPOPESSOA,'J',DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(T.GLB_TPMOTORISTA_CODIGO,'A ',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)-NVL(T.CON_VALEFRETE_PEDAGIO,0)))),0)) FRETESP_PJ,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.CON_VALEFRETE_PEDAGIO,0)))) PEDAGIO
   FROM T_CON_VALEFRETE T,
        T_CAR_VEICULO V,
        T_CAR_PROPRIETARIO P,
        T_GLB_ROTA R
  WHERE 0 < (SELECT COUNT(*)
               FROM T_CTB_LINKWRK_VFRETEEXP VFE
              WHERE VFE.CON_VALEFRETE_CODIGO     = T.CON_CONHECIMENTO_CODIGO
                AND VFE.CON_VALEFRETE_SERIE      = T.CON_CONHECIMENTO_SERIE
                AND VFE.GLB_ROTA_CODIGOVALEFRETE = T.GLB_ROTA_CODIGO
                AND VFE.CON_VALEFRETE_SAQUE      = T.CON_VALEFRETE_SAQUE
                AND VFE.CTB_LINKWRK_LINKID       = P_ID)
   AND T.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL
   AND trim(T.GLB_TPMOTORISTA_CODIGO)            <> 'F'
   AND NVL(T.CON_VALEFRETE_STATUS,'N')   = 'N'
   AND R.GLB_ROTA_CODIGO                 = T.GLB_ROTA_CODIGO
   AND T.CON_VALEFRETE_PLACA             = V.CAR_VEICULO_PLACA
   AND T.CON_VALEFRETE_PLACASAQUE        = V.CAR_VEICULO_SAQUE
   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO   = P.CAR_PROPRIETARIO_CGCCPFCODIGO
   AND trunc(T.CON_VALEFRETE_DATACADASTRO) >= VT_DTINI
   AND trunc(T.CON_VALEFRETE_DATACADASTRO) <= VT_DTFIM
   -- VERIFICA QUAIS CATEGORIAS NÃO PODEM ENTRAR
   AND INSTR(GET_CATVF,T.CON_CATVALEFRETE_CODIGO) = 0 
   AND INSTR(GET_SERIEVF,T.CON_CONHECIMENTO_SERIE)  > 0 
GROUP BY to_char(T.CON_VALEFRETE_DATACADASTRO,'DD'),  
         T.GLB_ROTA_CODIGO;

-- CURSOR C_FRETE_DESC (Descontos de Frete dos Vales de Frete Impressos e N?o Cancelados)

-- EM 14/07/2008 - Passou a Verificar Somente as pessoas Fisicas LENGTH(TRIM(V.CPF)) = 11 - Roberto Pariz

CURSOR C_FRETE_DESC IS
SELECT V.DIA                                                       DIA,
       R.GLB_ROTA_CODGENERICO                                      GLB_ROTA_CODIGO, 
       sum(nvl(V.ADIANTAMENTO,0))                                  ADIANTAMENTO,
       sum(nvl(V.IR,0))                                            IRRF,
       sum(nvl(decode(LENGTH(TRIM(V.CPF)),11,V.SESTSENAT,0),0))    SESTSENAT,
       sum(nvl(decode(LENGTH(TRIM(V.CPF)),11,V.INSS,0),0))         INSS,
       sum(nvl(V.MULTAS,0))                                        MULTA,
       sum(nvl(decode(LENGTH(TRIM(V.CPF)),11,V.PARTEEMPINSS,0),0)) PARTEEMPINSS
  FROM V_CTB_IMPOSTOS2 V,T_GLB_ROTA R
 WHERE V.ROTA = R.GLB_ROTA_CODIGO
   AND V.ROTA IS NOT NULL
--   AND LENGTH(TRIM(V.CPF)) = 11
   AND DT = '02/2012'
 GROUP BY V.DIA,R.GLB_ROTA_CODGENERICO;
 
 
-- As ocorrencias deixaram de ser debitadas na conta 447058058360 (Recuperacao de Despesas) 
-- E voltaram a ser debitadas na conta 220202300023 (Fretes a Pagar)
-- Alterac?o Solicitada pelo Raul em 10/09/2008 - Roberto Pariz

-- CURSOR C_OCORR (Ocorrencias dos Vales de Frete da Coca Cola)

CURSOR C_OCORR IS
SELECT TO_CHAR(P.RJF_PAGAMENTOS_DTPPAGTO,'DD') DIA, 
       DECODE(SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3),'033','032',SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3)) GLB_ROTA_CODIGO,
       SUBSTR(REPLACE(O.CTB_PCONTA_CODIGODEB,'***',DECODE(SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3),'033','032',SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3))),1,12) C_DEB,
       SUBSTR(REPLACE(O.CTB_PCONTA_CODIGOCRED,'***',DECODE(SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3),'033','032',SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3))),1,12) C_CRE,
       O.CTB_HISTORICO_CODIGODEB,
       O.CTB_HISTORICO_CODIGOCRED,
       SUM(ABS(MO.RJF_MOVIMENTOOCOR_VALOR)) VALOR
FROM T_RJF_MOVIMENTOOCOR MO,
     T_RJF_MOVIMENTO M,
     T_RJF_OCORRENCIA O,
     T_RJF_PAGAMENTOS P
WHERE MO.RJF_MOVIMENTO_DTEMBARQUE = M.RJF_MOVIMENTO_DTEMBARQUE
  AND MO.RJF_MOVIMENTO_CONTROLE = M.RJF_MOVIMENTO_CONTROLE
  AND MO.RJF_OCORRENCIA_CODIGO = O.RJF_OCORRENCIA_CODIGO
  AND TO_CHAR(P.RJF_PAGAMENTOS_DTPPAGTO,'YYYYMM') = '201202'
  AND M.RJF_MOVIMENTO_CODPGTO2Q = P.RJF_PAGAMENTOS_CODIGO
  AND M.FRT_CONJVEICULO_CODIGO = P.FRT_CONJVEICULO_CODIGO
  AND O.CTB_PCONTA_CODIGODEB   IS NOT NULL
  AND SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3) IS NOT NULL
GROUP BY TO_CHAR(P.RJF_PAGAMENTOS_DTPPAGTO,'YYYYMM'),
       TO_CHAR(P.RJF_PAGAMENTOS_DTPPAGTO,'DD'),
       DECODE(SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3),'033','032',SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3)),
       M.FRT_CONJVEICULO_CODIGO,
       O.RJF_OCORRENCIA_CODIGO,
       O.RJF_OCORRENCIA_DESCRICAO,
       O.RJF_OCORRENCIA_TIPO,
       SUBSTR(REPLACE(O.CTB_PCONTA_CODIGOCRED,'***',DECODE(SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3),'033','032',SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3))),1,12),
       O.CTB_HISTORICO_CODIGOCRED,
       SUBSTR(REPLACE(O.CTB_PCONTA_CODIGODEB,'***',DECODE(SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3),'033','032',SUBSTR(FN_GET_VALEFRETE(M.FRT_CONJVEICULO_CODIGO,P.RJF_PAGAMENTOS_DTPPAGTO),26,3))),1,12),
       O.CTB_HISTORICO_CODIGODEB,
       M.FRT_CONJVEICULO_CODIGO,
       M.RJF_MOVIMENTO_CODPGTO2Q; 

/*

Cursores substituidos pela View de Impostos e Descontos a partir do mes 09/2007

 CURSOR C_FRETE_DESC
 SELECT SUBSTR(TO_CHAR(T.CON_VALEFRETE_DATAEMISSAO,'DD/MM/YYYY'),1,2) DIA,
        R.GLB_ROTA_CODGENERICO                                        GLB_ROTA_CODIGO,
        SUM(NVL(T.CON_VALEFRETE_ADIANTAMENTO-NVL(T.CON_VALEFRETE_ADTANTERIOR,0),0)+
            (DECODE(CON_CATVALEFRETE_CODIGO,'4',0,NVL(T.CON_VALEFRETE_IRRF,0)))+
           ((DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(T.GLB_TPMOTORISTA_CODIGO,'A ',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)-NVL(T.CON_VALEFRETE_PEDAGIO,0)))) * 0.005)+
            (DECODE(CON_CATVALEFRETE_CODIGO,'4',0,NVL(T.CON_VALEFRETE_INSS,0)))+
            (DECODE(CON_CATVALEFRETE_CODIGO,'4',0,NVL(T.CON_VALEFRETE_MULTA,0)))) SOMA,
        SUM(NVL((T.CON_VALEFRETE_ADIANTAMENTO-NVL(T.CON_VALEFRETE_ADTANTERIOR,0)),0)) ADIANTAMENTO,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,NVL(T.CON_VALEFRETE_IRRF,0))) IRRF,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(T.GLB_TPMOTORISTA_CODIGO,'A ',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)-NVL(T.CON_VALEFRETE_PEDAGIO,0)))) * 0.005 SESTSENAT,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,NVL(T.CON_VALEFRETE_INSS,0))) INSS,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,NVL(T.CON_VALEFRETE_MULTA,0))) MULTA
   FROM T_CON_VALEFRETE T,
        T_CAR_VEICULO V,
        T_CAR_PROPRIETARIO P,
        T_GLB_ROTA R
 WHERE T.GLB_TPMOTORISTA_CODIGO         <> 'F'
   AND T.CON_VALEFRETE_IMPRESSO          = 'S'
   AND NVL(T.CON_VALEFRETE_STATUS,'N')   = 'N'
   AND R.GLB_ROTA_CODIGO                 = T.GLB_ROTA_CODIGO
   AND T.CON_VALEFRETE_PLACA             = V.CAR_VEICULO_PLACA
   AND T.CON_VALEFRETE_PLACASAQUE        = V.CAR_VEICULO_SAQUE
   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO   = P.CAR_PROPRIETARIO_CGCCPFCODIGO
   AND TRUNC(CON_VALEFRETE_DATAEMISSAO) >= VT_DTINI
   AND TRUNC(CON_VALEFRETE_DATAEMISSAO) <= VT_DTFIM
   AND T.CON_CATVALEFRETE_CODIGO        <> '10'
 GROUP BY SUBSTR(TO_CHAR(T.CON_VALEFRETE_DATAEMISSAO,'DD/MM/YYYY'),1,2),
                 R.GLB_ROTA_CODGENERICO;

-- CURSOR C_INSS_EMPR (INSS Parte Empresa dos Vales de Frete Impressos e N?o Cancelados)
-- Pitangi do IRAJA!!!

 CURSOR C_INSS_EMPR IS
 SELECT VT_DIA DIA,
        R.GLB_ROTA_CODGENERICO     GLB_ROTA_CODIGO,
        SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(T.GLB_TPMOTORISTA_CODIGO,'A ',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0)-NVL(T.CON_VALEFRETE_PEDAGIO,0)))) * 0.040 PARTEEMPINSS
   FROM T_CON_VALEFRETE T,
        T_CAR_VEICULO V,
        T_CAR_PROPRIETARIO P,
        T_GLB_ROTA R
 WHERE T.GLB_TPMOTORISTA_CODIGO         <> 'F'
   AND P.CAR_PROPRIETARIO_TIPOPESSOA     = 'F'
   AND T.CON_VALEFRETE_IMPRESSO          = 'S'
   AND NVL(T.CON_VALEFRETE_STATUS,'N')   = 'N'
   AND R.GLB_ROTA_CODIGO                 = T.GLB_ROTA_CODIGO
   AND T.CON_VALEFRETE_PLACA             = V.CAR_VEICULO_PLACA
   AND T.CON_VALEFRETE_PLACASAQUE        = V.CAR_VEICULO_SAQUE
   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO   = P.CAR_PROPRIETARIO_CGCCPFCODIGO
   AND TRUNC(CON_VALEFRETE_DATAEMISSAO) >= VT_DTINI
   AND TRUNC(CON_VALEFRETE_DATAEMISSAO) <= VT_DTFIM
   AND T.CON_CATVALEFRETE_CODIGO        <> '10'
 GROUP BY SUBSTR(TO_CHAR(T.CON_VALEFRETE_DATAEMISSAO,'DD/MM/YYYY'),1,2),
                         R.GLB_ROTA_CODGENERICO;
*/

CURSOR C_FRETE_CTB IS
SELECT T.CON_CONHECIMENTO_CODIGO,
       T.CON_CONHECIMENTO_SERIE,
       T.GLB_ROTA_CODIGO,
       T.CON_VALEFRETE_SAQUE
  FROM T_CON_VALEFRETE T,
       T_CAR_VEICULO V,
       T_CAR_PROPRIETARIO P,
       T_GLB_ROTA R
 WHERE trim(T.GLB_TPMOTORISTA_CODIGO)         <> 'F'
   AND T.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL
   AND NVL(T.CON_VALEFRETE_STATUS,'N')   = 'N'
   AND R.GLB_ROTA_CODIGO                 = T.GLB_ROTA_CODIGO
   AND T.CON_VALEFRETE_PLACA             = V.CAR_VEICULO_PLACA
   AND T.CON_VALEFRETE_PLACASAQUE        = V.CAR_VEICULO_SAQUE
   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO   = P.CAR_PROPRIETARIO_CGCCPFCODIGO
   AND TRUNC(CON_VALEFRETE_DATACADASTRO) >= VT_DTINI
   AND TRUNC(CON_VALEFRETE_DATACADASTRO) <= VT_DTFIM
   AND T.CON_CATVALEFRETE_CODIGO        <> '10';

 BEGIN
 who_called_me2;
 COMMIT;
 -- *** I N I C I A C A O   L O G ***


  SET_CATVF(P_ANO || P_MES);
  SET_SERIEVF(P_ANO || P_MES);
  SET_TPDATAVF(P_ANO || P_MES);
  SET_TPDATAVFEX(P_ANO || P_MES);
  

   SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'INICIO DA EXECUCAO DA PROCEDURE','EXECUCAO',P_ID,NULL);

 -- Verificacao de ID

   SELECT COUNT(*)
     INTO VT_CONTADOR
     FROM T_CTB_LINKCTL
    WHERE CTB_LINKCTL_STATUS = 'E'
      AND CTB_LINKCTL_ID = P_ID;

   IF VT_CONTADOR > 1 THEN
     SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'ID INVALIDO OU INEXISTENTE VERIFIQUE!!','ERRO',P_ID,'ATENCAO!!! Esta procedure so deve ser executada atraves de SP_LINK_CTB_TDV');
     RAISE_APPLICATION_ERROR(-20007,'ID INVALIDO OU INEXISTENTE VERIFIQUE!!');
     END IF;

 -- Ajusta Paramentros

   IF LENGTH(P_MES) = 1 THEN
     VT_MES := '0'||P_MES;
   ELSE
     VT_MES := P_MES;
     END IF;

   IF LENGTH(P_DIA) = 1 THEN
     VT_DIA := '0'||P_DIA;
   ELSE
     VT_DIA := P_DIA;
     END IF;

   VT_DTINI := TO_DATE('01/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY');
   VT_DTFIM := TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY');

 -- Verifica Inconsistencias

BEGIN
  SELECT CTB_HISTORICO_DESCRICAO
    INTO VT_DESCCRE
    FROM T_CTB_HISTORICO
   WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEEM',1));
  EXCEPTION WHEN NO_DATA_FOUND THEN
    SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL DE FRETES EMITIDOS N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
  END;

 -- Gera Lista de Vales de Frete de Exportacão

 INSERT INTO T_CTB_LINKWRK_VFRETEEXP
 SELECT VC.CON_VALEFRETE_CODIGO,
        VC.CON_VALEFRETE_SERIE,
        VC.GLB_ROTA_CODIGOVALEFRETE,
        VC.CON_VALEFRETE_SAQUE,
        COUNT(*),
        P_ANO||VT_MES,
        P_ID
   FROM T_CON_VFRETECONHEC VC
  WHERE VC.GLB_ROTA_CODIGO||VC.CON_CONHECIMENTO_CODIGO||VC.CON_CONHECIMENTO_SERIE IN
        (SELECT C.GLB_ROTA_CODIGO||C.CON_CONHECIMENTO_CODIGO||C.CON_CONHECIMENTO_SERIE
           FROM V_CON_I_TTPV V,
                T_CON_CONHECIMENTO C,
                T_GLB_ROTA R,
                T_CON_CONHECCTB CT,
                T_SLF_SOLFRETE S
          WHERE C.GLB_ROTA_CODIGO                         = CT.GLB_ROTA_CODIGO(+)
            AND C.CON_CONHECIMENTO_CODIGO                 = CT.CON_CONHECIMENTO_CODIGO(+)
            AND C.CON_CONHECIMENTO_SERIE                  = CT.CON_CONHECIMENTO_SERIE(+)
            AND C.GLB_ROTA_CODIGO                         = R.GLB_ROTA_CODIGO
            AND C.CON_CONHECIMENTO_CODIGO                 = V.CON_CONHECIMENTO_CODIGO
            AND C.CON_CONHECIMENTO_SERIE                  = V.CON_CONHECIMENTO_SERIE
            AND C.GLB_ROTA_CODIGO                         = V.GLB_ROTA_CODIGO
            AND C.SLF_SOLFRETE_CODIGO                     = S.SLF_SOLFRETE_CODIGO(+)
            AND C.SLF_SOLFRETE_SAQUE                      = S.SLF_SOLFRETE_SAQUE(+)
            AND 'EX'                                      = NVL(S.GLB_MERCADORIA_CODIGO,'00')
            AND C.CON_CONHECIMENTO_DTEMISSAO             >= VT_DTINI
            AND C.CON_CONHECIMENTO_DTEMISSAO             <= VT_DTFIM
            AND CT.CON_CONHECCTB_DATACTB                 IS NULL
            AND C.CON_CONHECIMENTO_SERIE                 <> 'XXX'
            AND C.CON_CONHECIMENTO_DIGITADO               = 'I'
            AND NVL(C.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N'
            AND C.GLB_MERCADORIA_CODIGO                   = 'EX'
            AND C.GLB_ROTA_CODIGO            NOT IN (SELECT TRIM(CTB_LINKPARAMETRO_CONTEUDOCHAR)
                                                       FROM TDVADM.T_CTB_LINKPARAMETRO
                                                      WHERE CTB_LINKPARAMETRO_TIPO = 'EXCROTACON'
                                                        AND CTB_LINKPARAMETRO_STATUS = 'A'))
  GROUP BY VC.CON_VALEFRETE_CODIGO,
           VC.CON_VALEFRETE_SERIE,
           VC.GLB_ROTA_CODIGOVALEFRETE,
           VC.CON_VALEFRETE_SAQUE;

 -- Rotina Principal

 IF P_MODO > 1 THEN

 -- ********** F R E T E S **********

   BEGIN
     SELECT SUM(DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(trim(T.GLB_TPMOTORISTA_CODIGO),'A',T.CON_VALEFRETE_VALORCOMDESCONTO,T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1)),0))))
       INTO VT_SOMA
       FROM T_CON_VALEFRETE T,
            T_CAR_VEICULO V,
            T_CAR_PROPRIETARIO P
      WHERE trim(T.GLB_TPMOTORISTA_CODIGO) <> 'F'
        AND T.CON_VALEFRETE_IMPRESSO = 'S'
        AND NVL(T.CON_VALEFRETE_STATUS,'N') = 'N'
        AND T.CON_CONHECIMENTO_SERIE <> 'A0'
        AND T.CON_VALEFRETE_PLACA = V.CAR_VEICULO_PLACA
        AND T.CON_VALEFRETE_PLACASAQUE = V.CAR_VEICULO_SAQUE
        AND V.CAR_PROPRIETARIO_CGCCPFCODIGO = P.CAR_PROPRIETARIO_CGCCPFCODIGO
        AND TRUNC(CON_VALEFRETE_DATAEMISSAO) >= VT_DTINI
        AND TRUNC(CON_VALEFRETE_DATAEMISSAO) <= VT_DTFIM
        AND T.GLB_ROTA_CODIGO            NOT IN (SELECT TRIM(CTB_LINKPARAMETRO_CONTEUDOCHAR)
                            FROM TDVADM.T_CTB_LINKPARAMETRO
                     WHERE CTB_LINKPARAMETRO_TIPO = 'EXCROTAVLF'
                       AND CTB_LINKPARAMETRO_STATUS = 'A');
     EXCEPTION WHEN NO_DATA_FOUND THEN
      SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'ITEM 1 DO VOUCHER COM VALOR 0,00 - VERIFIQUE','INCONSIST',P_ID,NULL);
     END;

   VT_SEQUENCIA := 1;
   VT_CONTROLE  := NULL;
   VT_SOMA      := 0;


   FOR R_FRETE_PEDG IN C_FRETE_PEDG LOOP

   IF (VT_CONTROLE IS NOT NULL) AND (VT_CONTROLE <> R_FRETE_PEDG.DIA) THEN

     VT_SEQUENCIA := 1;

     INSERT INTO tdvadm.T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                      CTB_MOVIMENTO_DSEQUENCIA,
                                      CTB_MOVIMENTO_DTMOVTO,
                                      CTB_PCONTA_CODIGO_CPARTIDA,
                                      CTB_PCONTA_CODIGO_PARTIDA,
                                      GLB_ROTA_CODIGO,
                                      CTB_REFERENCIA_CODIGO_PARTIDA,
                                      CTB_REFERENCIA_CODIGO_CPARTIDA,
                                      CTB_HISTORICO_CODIGO,
                                      CTB_MOVIMENTO_TDOCUMENTO,
                                      CTB_MOVIMENTO_VALOR,
                                      CTB_MOVIMENTO_TVALOR,
                                      CTB_MOVIMENTO_DESCRICAO,
                                      CTB_MOVIMENTO_SYSDATE,
                                      CTB_MOVIMENTO_ORIGEM,
                                      GLB_ROTA_CODIGO_CRESP,
                                      CTB_MOVIMENTO_LINKID,
                                      CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      NULL,
                                      TRIM(FN_GETPARM('CTFRETE',1)),
                                      NULL,
                                      P_ANO||VT_MES,
                                      NULL,
                                      TRIM(FN_GETPARM('HTFRETEEM',1)),
                                      '3',
                                      VT_SOMA,
                                      'C',
                                      TRIM(VT_DESCCRE),
                                      SYSDATE,
                                      P_MODO,
                                      NULL,
                                      P_ID,
                                      P_MODO);

     VT_SEQUENCIA := 1;
     VT_SOMA      := 0;
     VT_DOCTO     := VT_DOCTO + 1;

     END IF;

     VT_CONTROLE := R_FRETE_PEDG.DIA;

-- Fretes Pessoa Fisica

     IF R_FRETE_PEDG.FRETESP_PF > 0 THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPF',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPF',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;


        VT_SEQUENCIA := VT_SEQUENCIA+1;

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                         CTB_MOVIMENTO_DSEQUENCIA,
                                         CTB_MOVIMENTO_DTMOVTO,
                                          CTB_PCONTA_CODIGO_PARTIDA,
                                   CTB_PCONTA_CODIGO_CPARTIDA,
                                          GLB_ROTA_CODIGO,
                                          CTB_REFERENCIA_CODIGO_PARTIDA,
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,
                                          CTB_HISTORICO_CODIGO,
                                          CTB_MOVIMENTO_TDOCUMENTO,
                                          CTB_MOVIMENTO_VALOR,
                                          CTB_MOVIMENTO_TVALOR,
                                          CTB_MOVIMENTO_DESCRICAO,
                                          CTB_MOVIMENTO_SYSDATE,
                                          CTB_MOVIMENTO_ORIGEM,
                                         GLB_ROTA_CODIGO_CRESP,
                                         CTB_MOVIMENTO_LINKID,
                                         CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE_PEDG.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPF',1)),'***',R_FRETE_PEDG.GLB_ROTA_CODIGO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_PEDG.GLB_ROTA_CODIGO),
                                         R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPF',1)),
                                         '3',
                                         TRUNC(R_FRETE_PEDG.FRETESP_PF,2),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         P_ID,
                                         P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_PEDG.FRETESP_PF,2);

       END IF;

-- Fretes Pessoa Juridica

     IF R_FRETE_PEDG.FRETESP_PJ > 0 THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPJ',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPJ',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

        VT_SEQUENCIA := VT_SEQUENCIA+1;

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                         CTB_MOVIMENTO_DSEQUENCIA,
                                         CTB_MOVIMENTO_DTMOVTO,
                                          CTB_PCONTA_CODIGO_PARTIDA,
                                         CTB_PCONTA_CODIGO_CPARTIDA,
                                          GLB_ROTA_CODIGO,
                                          CTB_REFERENCIA_CODIGO_PARTIDA,
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,
                                          CTB_HISTORICO_CODIGO,
                                          CTB_MOVIMENTO_TDOCUMENTO,
                                          CTB_MOVIMENTO_VALOR,
                                          CTB_MOVIMENTO_TVALOR,
                                          CTB_MOVIMENTO_DESCRICAO,
                                          CTB_MOVIMENTO_SYSDATE,
                                          CTB_MOVIMENTO_ORIGEM,
                                         GLB_ROTA_CODIGO_CRESP,
                                         CTB_MOVIMENTO_LINKID,
                                         CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE_PEDG.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPJ',1)),'***',R_FRETE_PEDG.GLB_ROTA_CODIGO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_PEDG.GLB_ROTA_CODIGO),
                                         R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPJ',1)),
                                         '3',
                                         TRUNC(R_FRETE_PEDG.FRETESP_PJ,2),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         P_ID,
                                         P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_PEDG.FRETESP_PJ,2);

       END IF;

-- Pedagio

     IF R_FRETE_PEDG.PEDAGIO > 0 THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPED',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPED',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

        VT_SEQUENCIA := VT_SEQUENCIA+1;

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                         CTB_MOVIMENTO_DSEQUENCIA,
                                         CTB_MOVIMENTO_DTMOVTO,
                                          CTB_PCONTA_CODIGO_PARTIDA,
                                        CTB_PCONTA_CODIGO_CPARTIDA,
                                          GLB_ROTA_CODIGO,
                                          CTB_REFERENCIA_CODIGO_PARTIDA,
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,
                                          CTB_HISTORICO_CODIGO,
                                          CTB_MOVIMENTO_TDOCUMENTO,
                                          CTB_MOVIMENTO_VALOR,
                                          CTB_MOVIMENTO_TVALOR,
                                          CTB_MOVIMENTO_DESCRICAO,
                                          CTB_MOVIMENTO_SYSDATE,
                                          CTB_MOVIMENTO_ORIGEM,
                                         GLB_ROTA_CODIGO_CRESP,
                                         CTB_MOVIMENTO_LINKID,
                                         CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE_PEDG.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPED',1)),'***',R_FRETE_PEDG.GLB_ROTA_CODIGO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_PEDG.GLB_ROTA_CODIGO),
                                         R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPED',1)),
                                         '3',
                                         TRUNC(R_FRETE_PEDG.PEDAGIO,2),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE_PEDG.GLB_ROTA_CODIGO,
                                         P_ID,
                                         P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_PEDG.PEDAGIO,2);

       END IF;

     END LOOP;

     IF VT_SOMA > 0 THEN

       VT_SEQUENCIA := 1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                  CTB_MOVIMENTO_DSEQUENCIA,
                                  CTB_MOVIMENTO_DTMOVTO,
                                  CTB_PCONTA_CODIGO_CPARTIDA,
                                  CTB_PCONTA_CODIGO_PARTIDA,
                                  GLB_ROTA_CODIGO,
                                  CTB_REFERENCIA_CODIGO_PARTIDA,
                                  CTB_REFERENCIA_CODIGO_CPARTIDA,
                                  CTB_HISTORICO_CODIGO,
                                  CTB_MOVIMENTO_TDOCUMENTO,
                                  CTB_MOVIMENTO_VALOR,
                                  CTB_MOVIMENTO_TVALOR,
                                  CTB_MOVIMENTO_DESCRICAO,
                                  CTB_MOVIMENTO_SYSDATE,
                                  CTB_MOVIMENTO_ORIGEM,
                                  GLB_ROTA_CODIGO_CRESP,
                                  CTB_MOVIMENTO_LINKID,
                                  CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        NULL,
                                        TRIM(FN_GETPARM('CTFRETE',1)),
                                        NULL,
                                        P_ANO||VT_MES,
                                        NULL,
                                        TRIM(FN_GETPARM('HTFRETEEM',1)),
                                        '3',
                                        VT_SOMA,
                                        'C',
                                        TRIM(VT_DESCCRE),
                                        SYSDATE,
                                        P_MODO,
                                        NULL,
                                        P_ID,
                                        P_MODO);
      END IF;


-- ********** F R E T E S   E X P O R T A C ? O **********

   VT_DOCTO     := VT_DOCTO + 1;
   VT_SEQUENCIA := 1;
   VT_CONTROLE  := NULL;
   VT_SOMA      := 0;

   FOR R_FRETE_PEDG_EX IN C_FRETE_PEDG_EX LOOP

   IF (VT_CONTROLE IS NOT NULL) AND (VT_CONTROLE <> R_FRETE_PEDG_EX.DIA) THEN

     VT_SEQUENCIA := 1;

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                CTB_MOVIMENTO_DSEQUENCIA,
                                CTB_MOVIMENTO_DTMOVTO,
                                CTB_PCONTA_CODIGO_CPARTIDA,
                                CTB_PCONTA_CODIGO_PARTIDA,
                                GLB_ROTA_CODIGO,
                                CTB_REFERENCIA_CODIGO_PARTIDA,
                                CTB_REFERENCIA_CODIGO_CPARTIDA,
                                CTB_HISTORICO_CODIGO,
                                CTB_MOVIMENTO_TDOCUMENTO,
                                CTB_MOVIMENTO_VALOR,
                                CTB_MOVIMENTO_TVALOR,
                                CTB_MOVIMENTO_DESCRICAO,
                                CTB_MOVIMENTO_SYSDATE,
                                CTB_MOVIMENTO_ORIGEM,
                                GLB_ROTA_CODIGO_CRESP,
                                CTB_MOVIMENTO_LINKID,
                                CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      NULL,
                                      TRIM(FN_GETPARM('CTFRETE',1)),
                                      NULL,
                                      P_ANO||VT_MES,
                                      NULL,
                                      TRIM(FN_GETPARM('HTFRETEEM',1)),
                                      '3',
                                      VT_SOMA,
                                      'C',
                                      TRIM(VT_DESCCRE),
                                      SYSDATE,
                                      P_MODO,
                                      NULL,
                                      P_ID,
                                      P_MODO);

     VT_SEQUENCIA := 1;
     VT_SOMA      := 0;
     VT_DOCTO     := VT_DOCTO + 1;

     END IF;

     VT_CONTROLE := R_FRETE_PEDG_EX.DIA;

-- Fretes Pessoa Fisica Exportac?o

     IF R_FRETE_PEDG_EX.FRETESP_PF > 0 THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPF',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPF',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;


        VT_SEQUENCIA := VT_SEQUENCIA+1;

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                         CTB_MOVIMENTO_DSEQUENCIA,
                                         CTB_MOVIMENTO_DTMOVTO,
                                          CTB_PCONTA_CODIGO_PARTIDA,
                                   CTB_PCONTA_CODIGO_CPARTIDA,
                                          GLB_ROTA_CODIGO,
                                          CTB_REFERENCIA_CODIGO_PARTIDA,
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,
                                          CTB_HISTORICO_CODIGO,
                                          CTB_MOVIMENTO_TDOCUMENTO,
                                          CTB_MOVIMENTO_VALOR,
                                          CTB_MOVIMENTO_TVALOR,
                                          CTB_MOVIMENTO_DESCRICAO,
                                          CTB_MOVIMENTO_SYSDATE,
                                          CTB_MOVIMENTO_ORIGEM,
                                          GLB_ROTA_CODIGO_CRESP,
                                          CTB_MOVIMENTO_LINKID,
                                          CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE_PEDG_EX.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPFX',1)),'***',R_FRETE_PEDG_EX.GLB_ROTA_CODIGO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_PEDG_EX.GLB_ROTA_CODIGO),
                                         R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPF',1)),
                                         '3',
                                         TRUNC(R_FRETE_PEDG_EX.FRETESP_PF,2),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         P_ID,
                                         P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_PEDG_EX.FRETESP_PF,2);

       END IF;

-- Fretes Pessoa Juridica Exportac?o

     IF R_FRETE_PEDG_EX.FRETESP_PJ > 0 THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPJ',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPJ',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

        VT_SEQUENCIA := VT_SEQUENCIA+1;

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                         CTB_MOVIMENTO_DSEQUENCIA,
                                         CTB_MOVIMENTO_DTMOVTO,
                                          CTB_PCONTA_CODIGO_PARTIDA,
                                       CTB_PCONTA_CODIGO_CPARTIDA,
                                          GLB_ROTA_CODIGO,
                                          CTB_REFERENCIA_CODIGO_PARTIDA,
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,
                                          CTB_HISTORICO_CODIGO,
                                          CTB_MOVIMENTO_TDOCUMENTO,
                                          CTB_MOVIMENTO_VALOR,
                                          CTB_MOVIMENTO_TVALOR,
                                          CTB_MOVIMENTO_DESCRICAO,
                                          CTB_MOVIMENTO_SYSDATE,
                                          CTB_MOVIMENTO_ORIGEM,
                                          GLB_ROTA_CODIGO_CRESP,
                                          CTB_MOVIMENTO_LINKID,
                                          CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE_PEDG_EX.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPJX',1)),'***',R_FRETE_PEDG_EX.GLB_ROTA_CODIGO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_PEDG_EX.GLB_ROTA_CODIGO),
                                         R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPJ',1)),
                                         '3',
                                         TRUNC(R_FRETE_PEDG_EX.FRETESP_PJ,2),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         P_ID,
                                         P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_PEDG_EX.FRETESP_PJ,2);

       END IF;

-- Pedagio Exportac?o

     IF R_FRETE_PEDG_EX.PEDAGIO > 0 THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPED',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPED',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

        VT_SEQUENCIA := VT_SEQUENCIA+1;

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                         CTB_MOVIMENTO_DSEQUENCIA,
                                         CTB_MOVIMENTO_DTMOVTO,
                                          CTB_PCONTA_CODIGO_PARTIDA,
                                        CTB_PCONTA_CODIGO_CPARTIDA,
                                          GLB_ROTA_CODIGO,
                                          CTB_REFERENCIA_CODIGO_PARTIDA,
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,
                                          CTB_HISTORICO_CODIGO,
                                          CTB_MOVIMENTO_TDOCUMENTO,
                                          CTB_MOVIMENTO_VALOR,
                                          CTB_MOVIMENTO_TVALOR,
                                          CTB_MOVIMENTO_DESCRICAO,
                                          CTB_MOVIMENTO_SYSDATE,
                                          CTB_MOVIMENTO_ORIGEM,
                                          GLB_ROTA_CODIGO_CRESP,
                                          CTB_MOVIMENTO_LINKID,
                                          CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE_PEDG_EX.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPED',1)),'***',R_FRETE_PEDG_EX.GLB_ROTA_CODIGO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_PEDG_EX.GLB_ROTA_CODIGO),
                                         R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPED',1)),
                                         '3',
                                         TRUNC(R_FRETE_PEDG_EX.PEDAGIO,2),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE_PEDG_EX.GLB_ROTA_CODIGO,
                                         P_ID,
                                         P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_PEDG_EX.PEDAGIO,2);

       END IF;

     END LOOP;

     IF VT_SOMA > 0 THEN

       VT_SEQUENCIA := 1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                  CTB_MOVIMENTO_DSEQUENCIA,
                                  CTB_MOVIMENTO_DTMOVTO,
                                  CTB_PCONTA_CODIGO_CPARTIDA,
                                  CTB_PCONTA_CODIGO_PARTIDA,
                                  GLB_ROTA_CODIGO,
                                  CTB_REFERENCIA_CODIGO_PARTIDA,
                                  CTB_REFERENCIA_CODIGO_CPARTIDA,
                                  CTB_HISTORICO_CODIGO,
                                  CTB_MOVIMENTO_TDOCUMENTO,
                                  CTB_MOVIMENTO_VALOR,
                                  CTB_MOVIMENTO_TVALOR,
                                  CTB_MOVIMENTO_DESCRICAO,
                                  CTB_MOVIMENTO_SYSDATE,
                                  CTB_MOVIMENTO_ORIGEM,
                                  GLB_ROTA_CODIGO_CRESP,
                                  CTB_MOVIMENTO_LINKID,
                                  CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        NULL,
                                        TRIM(FN_GETPARM('CTFRETE',1)),
                                        NULL,
                                        P_ANO||VT_MES,
                                        NULL,
                                        TRIM(FN_GETPARM('HTFRETEEM',1)),
                                        '3',
                                        VT_SOMA,
                                        'C',
                                        TRIM(VT_DESCCRE),
                                        SYSDATE,
                                        P_MODO,
                                        NULL,
                                        P_ID,
                                        P_MODO);
      END IF;

 -- ********** D E S C O N T O S **********

   BEGIN
     SELECT CTB_HISTORICO_DESCRICAO
       INTO VT_DESCDEB
       FROM T_CTB_HISTORICO
      WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETDESC',1));
     EXCEPTION WHEN NO_DATA_FOUND THEN
       SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETDESC',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
     END;

   VT_SOMA      := 0;
   VT_DOCTO     := VT_DOCTO + 1;
   VT_CONTROLE  := NULL;
   VT_SEQUENCIA := 1;

   FOR R_FRETE_DESC IN C_FRETE_DESC LOOP

   IF (VT_CONTROLE IS NOT NULL) AND (VT_CONTROLE <> R_FRETE_DESC.DIA) THEN

     VT_SEQUENCIA := 1;

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                CTB_MOVIMENTO_DSEQUENCIA,
                                CTB_MOVIMENTO_DTMOVTO,
                                       CTB_PCONTA_CODIGO_CPARTIDA,
                                     CTB_PCONTA_CODIGO_PARTIDA,
                                GLB_ROTA_CODIGO,
                                CTB_REFERENCIA_CODIGO_PARTIDA,
                                CTB_REFERENCIA_CODIGO_CPARTIDA,
                                CTB_HISTORICO_CODIGO,
                                CTB_MOVIMENTO_TDOCUMENTO,
                                CTB_MOVIMENTO_VALOR,
                                CTB_MOVIMENTO_TVALOR,
                                CTB_MOVIMENTO_DESCRICAO,
                                CTB_MOVIMENTO_SYSDATE,
                                CTB_MOVIMENTO_ORIGEM,
                                GLB_ROTA_CODIGO_CRESP,
                                CTB_MOVIMENTO_LINKID,
                                CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      NULL,
                                      TRIM(FN_GETPARM('CTFRETE',1)),
                                      NULL,
                                      P_ANO||VT_MES,
                                      NULL,
                                      TRIM(FN_GETPARM('HTFRETDESC',1)),
                                      '2',
                                      VT_SOMA,
                                      'D',
                                      TRIM(VT_DESCDEB),
                                      SYSDATE,
                                      P_MODO,
                                      NULL,
                                      P_ID,
                                      P_MODO);
     VT_SEQUENCIA := 1;
     VT_SOMA      := 0;
     VT_DOCTO     := VT_DOCTO + 1;

     END IF;

     VT_CONTROLE := R_FRETE_DESC.DIA;

-- Adiantamento

     IF R_FRETE_DESC.ADIANTAMENTO > 0 THEN
       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCCRE
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETADTM',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETADTM',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

       VT_SEQUENCIA := VT_SEQUENCIA+1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                        CTB_MOVIMENTO_DSEQUENCIA,
                                        CTB_MOVIMENTO_DTMOVTO,
                                         CTB_PCONTA_CODIGO_PARTIDA,
                                         CTB_PCONTA_CODIGO_CPARTIDA,
                                         GLB_ROTA_CODIGO,
                                        CTB_REFERENCIA_CODIGO_PARTIDA,
                                        CTB_REFERENCIA_CODIGO_CPARTIDA,
                                        CTB_HISTORICO_CODIGO,
                                        CTB_MOVIMENTO_TDOCUMENTO,
                                        CTB_MOVIMENTO_VALOR,
                                        CTB_MOVIMENTO_TVALOR,
                                        CTB_MOVIMENTO_DESCRICAO,
                                        CTB_MOVIMENTO_SYSDATE,
                                        CTB_MOVIMENTO_ORIGEM,
                                        GLB_ROTA_CODIGO_CRESP,
                                        CTB_MOVIMENTO_LINKID,
                                        CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(R_FRETE_DESC.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETADTM',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ANO||VT_MES,
                                        P_ANO||VT_MES,
                                        TRIM(FN_GETPARM('HTFRETADTM',1)),
                                        '2',
                                        TRUNC(R_FRETE_DESC.ADIANTAMENTO,2),
                                        'C',
                                        TRIM(VT_DESCCRE)||' '||R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        SYSDATE,
                                        P_MODO,
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ID,
                                        P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_DESC.ADIANTAMENTO,2);

       END IF;

-- IRRF

     IF R_FRETE_DESC.IRRF > 0 THEN
       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCCRE
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETIRRF',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETIRRF',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

       VT_SEQUENCIA := VT_SEQUENCIA+1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                        CTB_MOVIMENTO_DSEQUENCIA,
                                        CTB_MOVIMENTO_DTMOVTO,
                                         CTB_PCONTA_CODIGO_PARTIDA,
                                       CTB_PCONTA_CODIGO_CPARTIDA,
                                        GLB_ROTA_CODIGO,
                                        CTB_REFERENCIA_CODIGO_PARTIDA,
                                        CTB_REFERENCIA_CODIGO_CPARTIDA,
                                        CTB_HISTORICO_CODIGO,
                                        CTB_MOVIMENTO_TDOCUMENTO,
                                        CTB_MOVIMENTO_VALOR,
                                        CTB_MOVIMENTO_TVALOR,
                                        CTB_MOVIMENTO_DESCRICAO,
                                        CTB_MOVIMENTO_SYSDATE,
                                        CTB_MOVIMENTO_ORIGEM,
                                        GLB_ROTA_CODIGO_CRESP,
                                        CTB_MOVIMENTO_LINKID,
                                        CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(R_FRETE_DESC.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETIRRF',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ANO||VT_MES,
                                        P_ANO||VT_MES,
                                        TRIM(FN_GETPARM('HTFRETIRRF',1)),
                                        '2',
                                        TRUNC(R_FRETE_DESC.IRRF,2),
                                        'C',
                                        TRIM(VT_DESCCRE)||' '||R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        SYSDATE,
                                        P_MODO,
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ID,
                                        P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_DESC.IRRF,2);

       END IF;

-- SEST/SENAT

     IF R_FRETE_DESC.SESTSENAT > 0 THEN
       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCCRE
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETSTSN',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETSTSN',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

       VT_SEQUENCIA := VT_SEQUENCIA+1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                        CTB_MOVIMENTO_DSEQUENCIA,
                                        CTB_MOVIMENTO_DTMOVTO,
                                         CTB_PCONTA_CODIGO_PARTIDA,
                                       CTB_PCONTA_CODIGO_CPARTIDA,
                                        GLB_ROTA_CODIGO,
                                        CTB_REFERENCIA_CODIGO_PARTIDA,
                                        CTB_REFERENCIA_CODIGO_CPARTIDA,
                                        CTB_HISTORICO_CODIGO,
                                        CTB_MOVIMENTO_TDOCUMENTO,
                                        CTB_MOVIMENTO_VALOR,
                                        CTB_MOVIMENTO_TVALOR,
                                        CTB_MOVIMENTO_DESCRICAO,
                                        CTB_MOVIMENTO_SYSDATE,
                                        CTB_MOVIMENTO_ORIGEM,
                                        GLB_ROTA_CODIGO_CRESP,
                                        CTB_MOVIMENTO_LINKID,
                                        CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(R_FRETE_DESC.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETSTSN',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ANO||VT_MES,
                                        P_ANO||VT_MES,
                                        TRIM(FN_GETPARM('HTFRETSTSN',1)),
                                        '2',
                                        TRUNC(R_FRETE_DESC.SESTSENAT,2),
                                        'C',
                                        TRIM(VT_DESCCRE)||' '||R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        SYSDATE,
                                        P_MODO,
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ID,
                                        P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_DESC.SESTSENAT,2);

       END IF;

-- INSS

     IF R_FRETE_DESC.INSS > 0 THEN
       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCCRE
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETINSS',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETINSS',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

       VT_SEQUENCIA := VT_SEQUENCIA+1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                        CTB_MOVIMENTO_DSEQUENCIA,
                                        CTB_MOVIMENTO_DTMOVTO,
                                         CTB_PCONTA_CODIGO_PARTIDA,
                                       CTB_PCONTA_CODIGO_CPARTIDA,
                                        GLB_ROTA_CODIGO,
                                        CTB_REFERENCIA_CODIGO_PARTIDA,
                                        CTB_REFERENCIA_CODIGO_CPARTIDA,
                                        CTB_HISTORICO_CODIGO,
                                        CTB_MOVIMENTO_TDOCUMENTO,
                                        CTB_MOVIMENTO_VALOR,
                                        CTB_MOVIMENTO_TVALOR,
                                        CTB_MOVIMENTO_DESCRICAO,
                                        CTB_MOVIMENTO_SYSDATE,
                                        CTB_MOVIMENTO_ORIGEM,
                                        GLB_ROTA_CODIGO_CRESP,
                                        CTB_MOVIMENTO_LINKID,
                                        CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(R_FRETE_DESC.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETINSS',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ANO||VT_MES,
                                        P_ANO||VT_MES,
                                        TRIM(FN_GETPARM('HTFRETINSS',1)),
                                        '2',
                                        TRUNC(R_FRETE_DESC.INSS,2),
                                        'C',
                                        TRIM(VT_DESCCRE)||' '||R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        SYSDATE,
                                        P_MODO,
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ID,
                                        P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_DESC.INSS,2);

       END IF;

-- MULTA / RECUPERACAO

     IF R_FRETE_DESC.MULTA > 0 THEN
       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCCRE
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETMULT',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETMULT',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;

       VT_SEQUENCIA := VT_SEQUENCIA+1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                        CTB_MOVIMENTO_DSEQUENCIA,
                                        CTB_MOVIMENTO_DTMOVTO,
                                         CTB_PCONTA_CODIGO_PARTIDA,
                                         CTB_PCONTA_CODIGO_CPARTIDA,
                                        GLB_ROTA_CODIGO,
                                        CTB_REFERENCIA_CODIGO_PARTIDA,
                                        CTB_REFERENCIA_CODIGO_CPARTIDA,
                                        CTB_HISTORICO_CODIGO,
                                        CTB_MOVIMENTO_TDOCUMENTO,
                                        CTB_MOVIMENTO_VALOR,
                                        CTB_MOVIMENTO_TVALOR,
                                        CTB_MOVIMENTO_DESCRICAO,
                                        CTB_MOVIMENTO_SYSDATE,
                                        CTB_MOVIMENTO_ORIGEM,
                                        GLB_ROTA_CODIGO_CRESP,
                                        CTB_MOVIMENTO_LINKID,
                                        CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(R_FRETE_DESC.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETMULT',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE_DESC.GLB_ROTA_CODIGO),
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ANO||VT_MES,
                                        P_ANO||VT_MES,
                                        TRIM(FN_GETPARM('HTFRETMULT',1)),
                                        '2',
                                        TRUNC(R_FRETE_DESC.MULTA,2),
                                        'C',
                                        TRIM(VT_DESCCRE)||' '||R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        SYSDATE,
                                        P_MODO,
                                        R_FRETE_DESC.GLB_ROTA_CODIGO,
                                        P_ID,
                                        P_MODO);

       VT_SOMA := VT_SOMA + TRUNC(R_FRETE_DESC.MULTA,2);

       END IF;

   END LOOP;

   IF VT_SOMA > 0 THEN

     VT_SEQUENCIA := 1;

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                 CTB_MOVIMENTO_DSEQUENCIA,
                                CTB_MOVIMENTO_DTMOVTO,
                                       CTB_PCONTA_CODIGO_CPARTIDA,
                                     CTB_PCONTA_CODIGO_PARTIDA,
                                GLB_ROTA_CODIGO,
                                CTB_REFERENCIA_CODIGO_PARTIDA,
                                CTB_REFERENCIA_CODIGO_CPARTIDA,
                                CTB_HISTORICO_CODIGO,
                                CTB_MOVIMENTO_TDOCUMENTO,
                                CTB_MOVIMENTO_VALOR,
                                CTB_MOVIMENTO_TVALOR,
                                CTB_MOVIMENTO_DESCRICAO,
                                CTB_MOVIMENTO_SYSDATE,
                                CTB_MOVIMENTO_ORIGEM,
                                GLB_ROTA_CODIGO_CRESP,
                                CTB_MOVIMENTO_LINKID,
                                CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      NULL,
                                      TRIM(FN_GETPARM('CTFRETE',1)),
                                      NULL,
                                      P_ANO||VT_MES,
                                      NULL,
                                      TRIM(FN_GETPARM('HTFRETDESC',1)),
                                      '2',
                                      VT_SOMA,
                                      'D',
                                      TRIM(VT_DESCDEB),
                                      SYSDATE,
                                      P_MODO,
                                      NULL,
                                      P_ID,
                                      P_MODO);
     END IF;

 -- ********** I N S S  E M P R E S A **********

 BEGIN
   SELECT CTB_HISTORICO_DESCRICAO
     INTO VT_DESCDEB
     FROM T_CTB_HISTORICO
    WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTINSSEMPR',1));
   EXCEPTION WHEN NO_DATA_FOUND THEN
     SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTINSSEMPR',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
   END;

 BEGIN
   SELECT CTB_HISTORICO_DESCRICAO
     INTO VT_DESCCRE
     FROM T_CTB_HISTORICO
    WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTINSSDESC',1));
   EXCEPTION WHEN NO_DATA_FOUND THEN
     SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTINSSDESC',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
   END;

 VT_SOMA      := 0;
 VT_DOCTO     := VT_DOCTO + 1;
 VT_CONTROLE  := NULL;
 VT_SEQUENCIA := 1;

 FOR R_INSS_EMPR IN C_FRETE_DESC LOOP

   IF (VT_CONTROLE IS NOT NULL) AND (VT_CONTROLE <> R_INSS_EMPR.DIA) THEN

     VT_SEQUENCIA := 1;

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                CTB_MOVIMENTO_DSEQUENCIA,
                                CTB_MOVIMENTO_DTMOVTO,
                                CTB_PCONTA_CODIGO_CPARTIDA,
                                CTB_PCONTA_CODIGO_PARTIDA,
                                GLB_ROTA_CODIGO,
                                CTB_REFERENCIA_CODIGO_PARTIDA,
                                CTB_REFERENCIA_CODIGO_CPARTIDA,
                                CTB_HISTORICO_CODIGO,
                                CTB_MOVIMENTO_TDOCUMENTO,
                                CTB_MOVIMENTO_VALOR,
                                CTB_MOVIMENTO_TVALOR,
                                CTB_MOVIMENTO_DESCRICAO,
                                CTB_MOVIMENTO_SYSDATE,
                                CTB_MOVIMENTO_ORIGEM,
                                GLB_ROTA_CODIGO_CRESP,
                                CTB_MOVIMENTO_LINKID,
                                CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      NULL,
                                      TRIM(FN_GETPARM('CTFRETINSS',1)),
                                      NULL,
                                      P_ANO||VT_MES,
                                      NULL,
                                      TRIM(FN_GETPARM('HTINSSDESC',1)),
                                      '3',
                                      VT_SOMA,
                                      'C',
                                      TRIM(VT_DESCCRE),
                                      SYSDATE,
                                      P_MODO,
                                      NULL,
                                      P_ID,
                                      P_MODO);
     VT_SEQUENCIA := 1;
     VT_SOMA      := 0;
     VT_DOCTO     := VT_DOCTO + 1;

     END IF;


     VT_CONTROLE := R_INSS_EMPR.DIA;

-- INSS Empresa

     BEGIN
       SELECT CTB_HISTORICO_DESCRICAO
         INTO VT_DESCDEB
         FROM T_CTB_HISTORICO
        WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTINSSEMPR',1));
       EXCEPTION WHEN NO_DATA_FOUND THEN
         SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTINSSEMPR',1))||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
       END;

     VT_SEQUENCIA := VT_SEQUENCIA+1;

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                      CTB_MOVIMENTO_DSEQUENCIA,
                                      CTB_MOVIMENTO_DTMOVTO,
                                      CTB_PCONTA_CODIGO_PARTIDA,
                                      CTB_PCONTA_CODIGO_CPARTIDA,
                                     GLB_ROTA_CODIGO,
                                       CTB_REFERENCIA_CODIGO_PARTIDA,
                                       CTB_REFERENCIA_CODIGO_CPARTIDA,
                                       CTB_HISTORICO_CODIGO,
                                       CTB_MOVIMENTO_TDOCUMENTO,
                                       CTB_MOVIMENTO_VALOR,
                                       CTB_MOVIMENTO_TVALOR,
                                       CTB_MOVIMENTO_DESCRICAO,
                                       CTB_MOVIMENTO_SYSDATE,
                                       CTB_MOVIMENTO_ORIGEM,
                                       GLB_ROTA_CODIGO_CRESP,
                                       CTB_MOVIMENTO_LINKID,
                                       CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(R_INSS_EMPR.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      REPLACE(TRIM(FN_GETPARM('CTINSSEMPR',1)),'***',R_INSS_EMPR.GLB_ROTA_CODIGO),
                                      REPLACE(TRIM(FN_GETPARM('CTFRETINSS',1)),'***',R_INSS_EMPR.GLB_ROTA_CODIGO),
                                      R_INSS_EMPR.GLB_ROTA_CODIGO,
                                      P_ANO||VT_MES,
                                      P_ANO||VT_MES,
                                      TRIM(FN_GETPARM('HTINSSEMPR',1)),
                                      '3',
                                      TRUNC(R_INSS_EMPR.PARTEEMPINSS,2),
                                      'D',
                                      TRIM(VT_DESCDEB)||' '||R_INSS_EMPR.GLB_ROTA_CODIGO,
                                      SYSDATE,
                                      P_MODO,
                                      R_INSS_EMPR.GLB_ROTA_CODIGO,
                                      P_ID,
                                      P_MODO);

     VT_SOMA := VT_SOMA + TRUNC(R_INSS_EMPR.PARTEEMPINSS,2);

     END LOOP;

     IF VT_SOMA > 0 THEN

       VT_SEQUENCIA := 1;

       INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                  CTB_MOVIMENTO_DSEQUENCIA,
                                  CTB_MOVIMENTO_DTMOVTO,
                                  CTB_PCONTA_CODIGO_CPARTIDA,
                                  CTB_PCONTA_CODIGO_PARTIDA,
                                  GLB_ROTA_CODIGO,
                                  CTB_REFERENCIA_CODIGO_PARTIDA,
                                  CTB_REFERENCIA_CODIGO_CPARTIDA,
                                  CTB_HISTORICO_CODIGO,
                                  CTB_MOVIMENTO_TDOCUMENTO,
                                  CTB_MOVIMENTO_VALOR,
                                  CTB_MOVIMENTO_TVALOR,
                                  CTB_MOVIMENTO_DESCRICAO,
                                  CTB_MOVIMENTO_SYSDATE,
                                  CTB_MOVIMENTO_ORIGEM,
                                  GLB_ROTA_CODIGO_CRESP,
                                  CTB_MOVIMENTO_LINKID,
                                  CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        VT_SEQUENCIA,
                                        TO_DATE(VT_CONTROLE||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                        NULL,
                                        TRIM(FN_GETPARM('CTFRETINSS',1)),
                                        NULL,
                                        P_ANO||VT_MES,
                                        NULL,
                                        TRIM(FN_GETPARM('HTINSSDESC',1)),
                                        '3',
                                        VT_SOMA,
                                        'C',
                                        TRIM(VT_DESCCRE),
                                        SYSDATE,
                                        P_MODO,
                                        NULL,
                                        P_ID,
                                        P_MODO);
      END IF;

-- Ocorrenccias dos Vales de Frete do Rio de Janeiro

FOR R_OCORR IN C_OCORR LOOP

     BEGIN
       SELECT CTB_HISTORICO_DESCRICAO
         INTO VT_DESCDEB
         FROM T_CTB_HISTORICO
        WHERE CTB_HISTORICO_CODIGO = R_OCORR.CTB_HISTORICO_CODIGODEB;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(R_OCORR.CTB_HISTORICO_CODIGODEB)||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
       END;

     BEGIN
       SELECT CTB_HISTORICO_DESCRICAO
         INTO VT_DESCCRE
         FROM T_CTB_HISTORICO
        WHERE CTB_HISTORICO_CODIGO = R_OCORR.CTB_HISTORICO_CODIGOCRED;
       EXCEPTION WHEN NO_DATA_FOUND THEN
         SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(R_OCORR.CTB_HISTORICO_CODIGOCRED)||' N?O ENCONTRADO!!!','INCONSIST',P_ID,NULL);
       END;

      VT_SEQUENCIA := 1;
      VT_SOMA      := 0;
      VT_DOCTO     := VT_DOCTO + 1;

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                      CTB_MOVIMENTO_DSEQUENCIA,
                                      CTB_MOVIMENTO_DTMOVTO,
                                      CTB_PCONTA_CODIGO_PARTIDA,
                                      CTB_PCONTA_CODIGO_CPARTIDA,
                                      GLB_ROTA_CODIGO,
                                       CTB_REFERENCIA_CODIGO_PARTIDA,
                                       CTB_REFERENCIA_CODIGO_CPARTIDA,
                                       CTB_HISTORICO_CODIGO,
                                       CTB_MOVIMENTO_TDOCUMENTO,
                                       CTB_MOVIMENTO_VALOR,
                                       CTB_MOVIMENTO_TVALOR,
                                       CTB_MOVIMENTO_DESCRICAO,
                                       CTB_MOVIMENTO_SYSDATE,
                                       CTB_MOVIMENTO_ORIGEM,
                                       GLB_ROTA_CODIGO_CRESP,
                                       CTB_MOVIMENTO_LINKID,
                                       CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      1,
                                      TO_DATE(R_OCORR.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      R_OCORR.C_DEB,
                                      R_OCORR.C_CRE,
                                      R_OCORR.GLB_ROTA_CODIGO,
                                      P_ANO||VT_MES,
                                      P_ANO||VT_MES,
                                      R_OCORR.CTB_HISTORICO_CODIGODEB,
                                      '1',
                                      R_OCORR.VALOR,
                                      'D',
                                      VT_DESCDEB,
                                      SYSDATE,
                                      P_MODO,
                                      R_OCORR.GLB_ROTA_CODIGO,
                                      P_ID,
                                      P_MODO);

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,
                                      CTB_MOVIMENTO_DSEQUENCIA,
                                      CTB_MOVIMENTO_DTMOVTO,
                                      CTB_PCONTA_CODIGO_PARTIDA,
                                      CTB_PCONTA_CODIGO_CPARTIDA,
                                      GLB_ROTA_CODIGO,
                                       CTB_REFERENCIA_CODIGO_PARTIDA,
                                       CTB_REFERENCIA_CODIGO_CPARTIDA,
                                       CTB_HISTORICO_CODIGO,
                                       CTB_MOVIMENTO_TDOCUMENTO,
                                       CTB_MOVIMENTO_VALOR,
                                       CTB_MOVIMENTO_TVALOR,
                                       CTB_MOVIMENTO_DESCRICAO,
                                       CTB_MOVIMENTO_SYSDATE,
                                       CTB_MOVIMENTO_ORIGEM,
                                       GLB_ROTA_CODIGO_CRESP,
                                       CTB_MOVIMENTO_LINKID,
                                       CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      2,
                                      TO_DATE(R_OCORR.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      R_OCORR.C_CRE,
                                      R_OCORR.C_DEB,
                                      R_OCORR.GLB_ROTA_CODIGO,
                                      P_ANO||VT_MES,
                                      P_ANO||VT_MES,
                                      R_OCORR.CTB_HISTORICO_CODIGOCRED,
                                      '1',
                                      R_OCORR.VALOR,
                                      'C',
                                      VT_DESCCRE,
                                      SYSDATE,
                                      P_MODO,
                                      R_OCORR.GLB_ROTA_CODIGO,
                                      P_ID,
                                      P_MODO);
   END LOOP;

-- Atualiza a Tabela de Logs de Transferencia.

   SELECT SUBSTR(OSUSER,1,20) OSUSER
     INTO VT_USUARIO
     FROM V$SESSION
    WHERE AUDSID = SYS_CONTEXT('USERENV','SESSIONID');

/*   INSERT INTO T_CTB_LOGTRANSF (CTB_LOGTRANSF_REFERENCIA,
                                CTB_LOGTRANSF_DATA,
                                CTB_LOGTRANSF_USUARIO,
                                CTB_LOGTRANSF_SISTEMA)
                        VALUES (P_ANO||VT_MES,
                                SYSDATE,
                                VT_USUARIO,
                                'VLF');
*/





--  FOR R_FRETE_CTB IN C_FRETE_CTB LOOP
--      INSERT INTO T_CON_VALEFRETECTB (CON_CONHECIMENTO_CODIGO,                            
--                                      CON_CONHECIMENTO_SERIE,                            
--                                      GLB_ROTA_CODIGO,                                
--                                      CON_VALEFRETE_SAQUE,                                
--                                      CON_VALEFRETECTB_ID,
--                                      CON_VALEFRETECTB_DATACTB)
--                              VALUES (R_FRETE_CTB.CON_CONHECIMENTO_CODIGO,                            
--                                      R_FRETE_CTB.CON_CONHECIMENTO_SERIE,                            
--                                      R_FRETE_CTB.GLB_ROTA_CODIGO,                                
--                                      R_FRETE_CTB.CON_VALEFRETE_SAQUE,                                
--                                      P_ID,
--                                      SYSDATE);
--      END LOOP;

   END IF;

 IF P_MODO > 2 THEN
  VT_SEQUENCIA := 0;
  END IF;

 IF P_MODO > 3 THEN
  VT_SEQUENCIA := 0;
  END IF;


 -- *** F I N A L I Z A C A O  L O G ***

 SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'FINAL DA EXECUCAO DA PROCEDURE','EXECUCAO',P_ID,NULL);


--  INSERT INTO T_CTB_MOVIMENTO_PREV
--  SELECT * FROM T_CTB_MOVIMENTO_TMP;
--  Commit;
  

END SP_LINK_CTB_TDVVFRETE;

   

PROCEDURE SP_LINK_CTB_TDVCOCA(P_MES  IN CHAR,
                              P_ANO  IN CHAR,
                              P_DIA  IN CHAR,
                              P_MODO IN CHAR,
                              P_ID   IN CHAR)
AS

/* -------------------------------------------------------------------------
 *
 * SISTEMA      : Contabilidade
 * PROGRAMA     : SP_LINK_CTB_TDVCOCA.SQL
 * ANALISTA     : Roberto Pariz
 * PROGRAMADOR  : Roberto Pariz
 * CRIACAO      : 14-02-2007
 * BANCO        : ORACLE
 * ALIMENTA     : T_CTB_MOVIMENTO
 * SIGLAS       : CTB,CON,GLB
 * ALTERACAO    : 16-10-2007 - Foi retirada a verificação da vigencia - Roberto / Sirlano
 *              : 12-11-2007 - Atualiza T_CTB_LOGTRANSF nas previas   - Roberto Pariz
 * COMENTARIOS  : Link entre o Vale de Frete e a Contabilidade.
 * ATUALIZA     : 
 * ------------------------------------------------------------------------ 
 */
 
 VT_PROCNAME  CHAR(25) := 'SP_LINK_CTB_TDVCOCA';
 VT_MES       CHAR(2);
 VT_DIA       CHAR(2);
 VT_CONTADOR  NUMBER;
 VT_DOCTO     INTEGER  := FN_GETDOCNUM; 
 VT_SEQUENCIA INTEGER;
 VT_FRETE     NUMBER;
 VT_NCTB      NUMBER; 
 VT_SOMA      NUMBER;
 VT_DTINI     DATE;
 VT_DTFIM     DATE;
 VT_DESCDEB   CHAR(50);
 VT_DESCCRE   CHAR(50);
 VT_MODO      CHAR(1);
 VT_USUARIO   CHAR(20);
 
 -- SERA RETIRADO APARTIR DE ABRIL/2007 PASSANDO A SER UMA OCORRENCIA...
 
 VT_ADIANTAMENTO NUMBER;
 VT_SETSTSENAT   NUMBER;
 VT_PARETEEMP    NUMBER;
 
 
 -- CURSOR C_FRETE (Producao (Fretes) Apersentados nos Demonstrativos de Veiculos)
  
 CURSOR C_FRETE IS
 SELECT V.FRT_VEICULO_CENTROCUSTO                                            CCUSTO,
        DECODE(LENGTH(TRIM(P.RJF_PROPRIETARIO_CPFPROP1)),11,'F',
        DECODE(LENGTH(TRIM(P.RJF_PROPRIETARIO_CPFPROP1)),14,'J','E'))        TP_PESSOA,
        TO_CHAR(F.RJF_PAGAMENTOS_DTFINAL,'DD') DIA, 
        SUM(F.RJF_PAGAMENTOS_VLRPAGOPAL + 
            F.RJF_PAGAMENTOS_VLRBONRET  +
            F.RJF_PAGAMENTOS_VLRBONAPR  +
            F.RJF_PAGAMENTOS_VLRBONDEB)                                      FRETE,
        SUM(FN_GETNCTBRJF(F.RJF_PAGAMENTOS_CODIGO,F.FRT_CONJVEICULO_CODIGO)) NCTB,
        SUM(F.RJF_PAGAMENTOS_VLRPAGOPRQUINZ)                                 ADIANTAMENTO,      
        SUM((F.RJF_PAGAMENTOS_VLRPAGOPAL + 
             F.RJF_PAGAMENTOS_VLRBONRET  +
             F.RJF_PAGAMENTOS_VLRBONAPR  +  
             F.RJF_PAGAMENTOS_VLRBONDEB)) * 0.040                            PARTEEMPRESA,
        SUM((F.RJF_PAGAMENTOS_VLRPAGOPAL + 
             F.RJF_PAGAMENTOS_VLRBONRET  +
             F.RJF_PAGAMENTOS_VLRBONAPR  +
             F.RJF_PAGAMENTOS_VLRBONDEB)) * 0.005                            SESTSENAT
   FROM T_RJF_PAGAMENTOS F,
        T_RJF_PROPRIETARIO P,
        T_FRT_VEICULODEPARA V
  WHERE F.FRT_CONJVEICULO_CODIGO = P.FRT_VEICULO_CLIENTE
    AND TRIM(P.RJF_PROPRIETARIO_CPFPROP1) IS NOT NULL
    AND P.RJF_PROPRIETARIO_CPFPROP1 IS NOT NULL
    AND F.FRT_CONJVEICULO_CODIGO = V.FRT_VEICULO_CLIENTE
--    AND P.RJF_PROPRIETARIO_VIGENCIA = (SELECT MAX(RJF_PROPRIETARIO_VIGENCIA)
--                                         FROM T_RJF_PROPRIETARIO PP 
--                                        WHERE F.FRT_CONJVEICULO_CODIGO    = PP.FRT_VEICULO_CLIENTE
--                                          AND RJF_PROPRIETARIO_VIGENCIA  <= VT_DTFIM)
    AND F.RJF_PAGAMENTOS_DTFINAL   = (SELECT MAX(RJF_PAGAMENTOS_DTFINAL) 
                                        FROM T_RJF_PAGAMENTOS
                                       WHERE RJF_PAGAMENTOS_DTINICIAL >= VT_DTINI 
                                         AND RJF_PAGAMENTOS_DTFINAL   <= VT_DTFIM)  
   GROUP BY V.FRT_VEICULO_CENTROCUSTO,
            DECODE(LENGTH(TRIM(P.RJF_PROPRIETARIO_CPFPROP1)),11,'F',
            DECODE(LENGTH(TRIM(P.RJF_PROPRIETARIO_CPFPROP1)),14,'J','E')),
            TO_CHAR(F.RJF_PAGAMENTOS_DTFINAL,'DD');

-- CURSOR C_DESC (Descontos Apersentados nos Demonstrativos de Veiculos)
  
 CURSOR C_DESC IS
 SELECT V.FRT_VEICULO_CENTROCUSTO  CCUSTO,
        O.CTB_PCONTA_CODIGOCRED    PCONTA,
        O.CTB_HISTORICO_CODIGOCRED HIST,
        SUM(NVL(R.RJF_MOVIMENTOOCOR_VALOR,0)) VALOR
   FROM T_RJF_MOVIMENTOOCOR R,
        T_RJF_MOVIMENTO M,
        T_RJF_OCORRENCIA O,
        T_FRT_VEICULODEPARA V,
        T_RJF_PROPRIETARIO PP
  WHERE M.FRT_CONJVEICULO_CODIGO           = V.FRT_VEICULO_CLIENTE
    AND M.RJF_MOVIMENTO_DTEMBARQUE         = R.RJF_MOVIMENTO_DTEMBARQUE
    AND M.RJF_MOVIMENTO_CONTROLE           = R.RJF_MOVIMENTO_CONTROLE
    AND R.RJF_OCORRENCIA_CODIGO            = O.RJF_OCORRENCIA_CODIGO
    AND M.FRT_CONJVEICULO_CODIGO           = PP.FRT_VEICULO_CLIENTE
    AND TRIM(PP.RJF_PROPRIETARIO_CPFPROP1) IS NOT NULL
    AND PP.RJF_PROPRIETARIO_CPFPROP1 IS NOT NULL
    AND TRUNC(R.RJF_MOVIMENTO_DTEMBARQUE) >= VT_DTINI
    AND TRUNC(R.RJF_MOVIMENTO_DTEMBARQUE) <= VT_DTFIM
    AND O.CTB_PCONTA_CODIGOCRED           IS NOT NULL
    AND O.CTB_PCONTA_CODIGODEB            IS NOT NULL
    AND M.FRT_CONJVEICULO_CODIGO IN (SELECT P.FRT_CONJVEICULO_CODIGO
                                       FROM T_RJF_PAGAMENTOS P
                                      WHERE P.RJF_PAGAMENTOS_DTINICIAL = VT_DTINI
                                        AND P.RJF_PAGAMENTOS_DTFINAL   = VT_DTFIM)
  GROUP BY V.FRT_VEICULO_CENTROCUSTO,O.CTB_PCONTA_CODIGOCRED,O.CTB_HISTORICO_CODIGOCRED;

 -- CURSOR C_INSS (INSS Parte Empresa Sobre Producao (Fretes) Apersentados nos Demonstrativos de Veiculos)
  
 CURSOR C_INSS IS
 SELECT V.FRT_VEICULO_CENTROCUSTO                                            CCUSTO,
         SUM((F.RJF_PAGAMENTOS_VLRPAGOPAL + 
             F.RJF_PAGAMENTOS_VLRBONRET  +
             F.RJF_PAGAMENTOS_VLRBONAPR  +  
             F.RJF_PAGAMENTOS_VLRBONDEB)) * 0.040                            PARTEEMPRESA
   FROM T_RJF_PAGAMENTOS F,
        T_RJF_PROPRIETARIO P,
        T_FRT_VEICULODEPARA V
  WHERE F.FRT_CONJVEICULO_CODIGO = P.FRT_VEICULO_CLIENTE
    AND TRIM(P.RJF_PROPRIETARIO_CPFPROP1) IS NOT NULL
    AND P.RJF_PROPRIETARIO_CPFPROP1 IS NOT NULL
    AND LENGTH(TRIM(P.RJF_PROPRIETARIO_CPFPROP1)) = 11
    AND F.FRT_CONJVEICULO_CODIGO = V.FRT_VEICULO_CLIENTE
--    AND P.RJF_PROPRIETARIO_VIGENCIA = (SELECT MAX(RJF_PROPRIETARIO_VIGENCIA)
--                                         FROM T_RJF_PROPRIETARIO PP 
--                                        WHERE F.FRT_CONJVEICULO_CODIGO    = PP.FRT_VEICULO_CLIENTE
--                                          AND RJF_PROPRIETARIO_VIGENCIA  <= VT_DTFIM)
    AND F.RJF_PAGAMENTOS_DTFINAL   = (SELECT MAX(RJF_PAGAMENTOS_DTFINAL) 
                                        FROM T_RJF_PAGAMENTOS
                                       WHERE RJF_PAGAMENTOS_DTINICIAL >= VT_DTINI 
                                         AND RJF_PAGAMENTOS_DTFINAL   <= VT_DTFIM)  
   GROUP BY V.FRT_VEICULO_CENTROCUSTO;

 BEGIN
 
 -- *** I N I C I A C A O   L O G ***
 
  
   SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'INICIO DA EXECUCAO DA PROCEDURE','EXECUCAO',P_ID,NULL);
 
 -- Verificacao de ID
 
   SELECT COUNT(*)
     INTO VT_CONTADOR
     FROM T_CTB_LINKCTL 
    WHERE CTB_LINKCTL_STATUS = 'E' 
      AND CTB_LINKCTL_ID = P_ID;
 
   IF VT_CONTADOR > 1 THEN
     SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'ID INVALIDO OU INEXISTENTE VERIFIQUE!!','ERRO',P_ID,'ATENCAO!!! Esta procedure so deve ser executada atraves de SP_LINK_CTB_TDV');
     RAISE_APPLICATION_ERROR(-20007,'ID INVALIDO OU INEXISTENTE VERIFIQUE!!');
     END IF;
 
 -- Ajusta Paramentros
 
   IF LENGTH(P_MES) = 1 THEN
     VT_MES := '0'||P_MES;   
   ELSE
     VT_MES := P_MES;  
     END IF;    
 
   IF LENGTH(P_DIA) = 1 THEN
     VT_DIA := '0'||P_DIA;   
   ELSE
     VT_DIA := P_DIA;  
     END IF;    
 
   VT_DTINI := TO_DATE('01/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY');
   VT_DTFIM := TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY');
   
 -- Verifica Inconsistencias  

BEGIN
  SELECT CTB_HISTORICO_DESCRICAO
    INTO VT_DESCCRE
    FROM T_CTB_HISTORICO
   WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEEM',1));
  EXCEPTION WHEN NO_DATA_FOUND THEN
    SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL DE FRETES EMITIDOS NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
  END;    

-- Gera inconsistencia de Lembrete para alteraçao do modo e contabilizar o SEST/SENAT

IF TO_NUMBER(VT_MES) >= 4 THEN
  SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'LEMBRETE!!!! VERRIFICAR SE SEST-SENAT JA FOI ALTERADO PARA OCORRENCIA!!!','INCONSIST',P_ID,NULL);
  END IF;
 
 -- Rotina Principal
 
IF P_MODO > 1 THEN
 
 -- ********** F R E T E S **********
 
  VT_SEQUENCIA := 1;

  BEGIN
    SELECT SUM(F.RJF_PAGAMENTOS_VLRPAGOPAL + 
               F.RJF_PAGAMENTOS_VLRBONRET  +
               F.RJF_PAGAMENTOS_VLRBONAPR  +
               F.RJF_PAGAMENTOS_VLRBONDEB)  FRETE,
           SUM(FN_GETNCTBRJF(F.RJF_PAGAMENTOS_CODIGO,F.FRT_CONJVEICULO_CODIGO)) NCTB       
      INTO VT_FRETE,VT_NCTB         
      FROM T_RJF_PAGAMENTOS F,
           T_RJF_PROPRIETARIO P,
           T_FRT_VEICULODEPARA V
     WHERE F.FRT_CONJVEICULO_CODIGO = P.FRT_VEICULO_CLIENTE
       AND TRIM(P.RJF_PROPRIETARIO_CPFPROP1) IS NOT NULL
       AND P.RJF_PROPRIETARIO_CPFPROP1 IS NOT NULL
       AND F.FRT_CONJVEICULO_CODIGO = V.FRT_VEICULO_CLIENTE
--       AND P.RJF_PROPRIETARIO_VIGENCIA = (SELECT MAX(RJF_PROPRIETARIO_VIGENCIA)
--                                            FROM T_RJF_PROPRIETARIO PP 
--                                           WHERE F.FRT_CONJVEICULO_CODIGO    = PP.FRT_VEICULO_CLIENTE
--                                             AND RJF_PROPRIETARIO_VIGENCIA  <= VT_DTFIM)
        AND F.RJF_PAGAMENTOS_DTFINAL   = (SELECT MAX(RJF_PAGAMENTOS_DTFINAL) 
                                            FROM T_RJF_PAGAMENTOS
                                           WHERE RJF_PAGAMENTOS_DTINICIAL >= VT_DTINI 
                                             AND RJF_PAGAMENTOS_DTFINAL   <= VT_DTFIM);  

    VT_SOMA := NVL(VT_FRETE,0)+NVL(VT_NCTB,0);

 -- SERA RETIRADO APARTIR DE ABRIL/2007 PASSANDO A SER UMA OCORRENCIA...
    
    VT_ADIANTAMENTO := 0;
    VT_SETSTSENAT   := 0;
    VT_PARETEEMP    := 0;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'ITEM 1 DO VOUCHER COM VALOR 0,00 - VERIFIQUE','INCONSIST',P_ID,NULL);
    END;    
 
    INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                     CTB_MOVIMENTO_DSEQUENCIA,               
                                     CTB_MOVIMENTO_DTMOVTO,                  
                                     CTB_PCONTA_CODIGO_CPARTIDA,             
                                     CTB_PCONTA_CODIGO_PARTIDA,             
                                     GLB_ROTA_CODIGO,                        
                                     CTB_REFERENCIA_CODIGO_PARTIDA,          
                                     CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                     CTB_HISTORICO_CODIGO,                   
                                     CTB_MOVIMENTO_TDOCUMENTO,               
                                     CTB_MOVIMENTO_VALOR,                    
                                     CTB_MOVIMENTO_TVALOR,                   
                                     CTB_MOVIMENTO_DESCRICAO,                
                                     CTB_MOVIMENTO_SYSDATE,                  
                                     CTB_MOVIMENTO_ORIGEM,                   
                                     GLB_ROTA_CODIGO_CRESP,
                                     CTB_MOVIMENTO_LINKID,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     VT_SEQUENCIA,
                                     TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                     NULL,
                                     TRIM(FN_GETPARM('CTFRETE',1)),
                                     NULL,
                                     P_ANO||VT_MES,
                                     NULL,
                                     TRIM(FN_GETPARM('HTFRETEEM',1)),
                                     '3',
                                     VT_SOMA,
                                     'C',
                                     TRIM(VT_DESCCRE),
                                     SYSDATE,
                                     P_MODO,
                                     NULL,
                                     P_ID,
                                     P_MODO);
  
   FOR R_FRETE IN C_FRETE LOOP    
  
-- Erros de Classificacao

     IF R_FRETE.TP_PESSOA = 'E' THEN
       SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'EXISTEM TIPOS DE PESSOA COM ERRO VERIFIQUE!!','ERRO',P_ID,NULL);
       RAISE_APPLICATION_ERROR(-20007,'EXISTEM TIPOS DE PESSOA COM ERRO VERIFIQUE!!');
       END IF;

-- Fretes Pessoa Fisica

     IF R_FRETE.TP_PESSOA = 'F' THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPF',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPF',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;    

        VT_SEQUENCIA := VT_SEQUENCIA+1; 

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                         CTB_MOVIMENTO_DSEQUENCIA,               
                                         CTB_MOVIMENTO_DTMOVTO,
                                          CTB_PCONTA_CODIGO_PARTIDA,
                                   CTB_PCONTA_CODIGO_CPARTIDA,                                                       
                                          GLB_ROTA_CODIGO,                        
                                          CTB_REFERENCIA_CODIGO_PARTIDA,          
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                          CTB_HISTORICO_CODIGO,                   
                                          CTB_MOVIMENTO_TDOCUMENTO,               
                                          CTB_MOVIMENTO_VALOR,                    
                                          CTB_MOVIMENTO_TVALOR,                   
                                          CTB_MOVIMENTO_DESCRICAO,                
                                          CTB_MOVIMENTO_SYSDATE,                  
                                          CTB_MOVIMENTO_ORIGEM,                   
                                         GLB_ROTA_CODIGO_CRESP,
                                         CTB_MOVIMENTO_LINKID,
                                         CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPF',1)),'***',R_FRETE.CCUSTO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE.CCUSTO),
                                         R_FRETE.CCUSTO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPF',1)),
                                         '3',
                                         NVL(R_FRETE.FRETE,0)+NVL(R_FRETE.NCTB,0),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE.CCUSTO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE.CCUSTO,                                       
                                         P_ID,
                                         P_MODO);
       END IF;

-- Fretes Pessoa Juridica

     IF R_FRETE.TP_PESSOA = 'J' THEN

       BEGIN
         SELECT CTB_HISTORICO_DESCRICAO
           INTO VT_DESCDEB
           FROM T_CTB_HISTORICO
          WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETEPJ',1));
         EXCEPTION WHEN NO_DATA_FOUND THEN
           SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETEPJ',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
         END;    

        VT_SEQUENCIA := VT_SEQUENCIA+1; 

        INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                         CTB_MOVIMENTO_DSEQUENCIA,               
                                         CTB_MOVIMENTO_DTMOVTO,                  
                                          CTB_PCONTA_CODIGO_PARTIDA,             
                                       CTB_PCONTA_CODIGO_CPARTIDA,             
                                          GLB_ROTA_CODIGO,                        
                                          CTB_REFERENCIA_CODIGO_PARTIDA,          
                                          CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                          CTB_HISTORICO_CODIGO,                   
                                          CTB_MOVIMENTO_TDOCUMENTO,               
                                          CTB_MOVIMENTO_VALOR,                    
                                          CTB_MOVIMENTO_TVALOR,                   
                                          CTB_MOVIMENTO_DESCRICAO,                
                                          CTB_MOVIMENTO_SYSDATE,                  
                                          CTB_MOVIMENTO_ORIGEM,                   
                                         GLB_ROTA_CODIGO_CRESP,
                                         CTB_MOVIMENTO_LINKID,
                                         CTB_MOVIMENTO_ORIGEMPR)
                                 VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                         VT_SEQUENCIA,
                                         TO_DATE(R_FRETE.DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETEPJ',1)),'***',R_FRETE.CCUSTO),
                                         REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_FRETE.CCUSTO),
                                         R_FRETE.CCUSTO,
                                         P_ANO||VT_MES,
                                         P_ANO||VT_MES,
                                         TRIM(FN_GETPARM('HTFRETEPJ',1)),
                                         '3',
                                         NVL(R_FRETE.FRETE,0)+NVL(R_FRETE.NCTB,0),
                                         'D',
                                         TRIM(VT_DESCDEB)||' '||R_FRETE.CCUSTO,
                                         SYSDATE,
                                         P_MODO,
                                         R_FRETE.CCUSTO,
                                         P_ID,
                                         P_MODO);
       END IF;
      
       -- SERA RETIRADO APARTIR DE ABRIL/2007 PASSANDO A SER UMA OCORRENCIA...
       
       VT_ADIANTAMENTO := VT_ADIANTAMENTO + R_FRETE.ADIANTAMENTO;
       VT_SETSTSENAT   := VT_SETSTSENAT   + R_FRETE.SESTSENAT;
       VT_PARETEEMP    := VT_PARETEEMP    + R_FRETE.PARTEEMPRESA;
       
     END LOOP;
  
 -- ********** D E S C O N T O S ********** 

   BEGIN
     SELECT CTB_HISTORICO_DESCRICAO
       INTO VT_DESCDEB
       FROM T_CTB_HISTORICO
      WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETDESC',1));
     EXCEPTION WHEN NO_DATA_FOUND THEN
       SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETDESC',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
     END;    

   VT_DOCTO     := VT_DOCTO + 1;
   VT_SEQUENCIA := 1;

   BEGIN
     SELECT SUM(NVL(R.RJF_MOVIMENTOOCOR_VALOR,0)) 
       INTO VT_SOMA
       FROM T_RJF_MOVIMENTOOCOR R,
            T_RJF_MOVIMENTO M,
            T_RJF_OCORRENCIA O,
            T_FRT_VEICULODEPARA V,
            T_RJF_PROPRIETARIO PP
      WHERE M.FRT_CONJVEICULO_CODIGO            = PP.FRT_VEICULO_CLIENTE
        AND TRIM(PP.RJF_PROPRIETARIO_CPFPROP1) IS NOT NULL
        AND PP.RJF_PROPRIETARIO_CPFPROP1       IS NOT NULL
        AND M.FRT_CONJVEICULO_CODIGO            = V.FRT_VEICULO_CLIENTE  
        AND M.RJF_MOVIMENTO_DTEMBARQUE          = R.RJF_MOVIMENTO_DTEMBARQUE
        AND M.RJF_MOVIMENTO_CONTROLE            = R.RJF_MOVIMENTO_CONTROLE
        AND R.RJF_OCORRENCIA_CODIGO             = O.RJF_OCORRENCIA_CODIGO
        AND TRUNC(R.RJF_MOVIMENTO_DTEMBARQUE)  >= VT_DTINI
        AND TRUNC(R.RJF_MOVIMENTO_DTEMBARQUE)  <= VT_DTFIM
        AND O.CTB_PCONTA_CODIGOCRED            IS NOT NULL       
        AND O.CTB_PCONTA_CODIGODEB             IS NOT NULL
        AND M.FRT_CONJVEICULO_CODIGO IN (SELECT P.FRT_CONJVEICULO_CODIGO
                                     FROM T_RJF_PAGAMENTOS P
                                    WHERE P.RJF_PAGAMENTOS_DTINICIAL = VT_DTINI
                                      AND P.RJF_PAGAMENTOS_DTFINAL   = VT_DTFIM);

     -- SERA RETIRADO APARTIR DE ABRIL/2007 PASSANDO A SER UMA OCORRENCIA...

     VT_SOMA := NVL(VT_SOMA,0)+NVL(VT_ADIANTAMENTO,0)+NVL(VT_SETSTSENAT,0);

     EXCEPTION WHEN NO_DATA_FOUND THEN
      SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'ITEM 1 DO VOUCHER COM VALOR 0,00 - VERIFIQUE','INCONSIST',P_ID,NULL);
     END;    

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                CTB_MOVIMENTO_DSEQUENCIA,               
                                CTB_MOVIMENTO_DTMOVTO,                  
                                       CTB_PCONTA_CODIGO_CPARTIDA,             
                                     CTB_PCONTA_CODIGO_PARTIDA,                          
                                GLB_ROTA_CODIGO,                        
                                CTB_REFERENCIA_CODIGO_PARTIDA,          
                                CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                CTB_HISTORICO_CODIGO,                   
                                CTB_MOVIMENTO_TDOCUMENTO,               
                                CTB_MOVIMENTO_VALOR,                    
                                CTB_MOVIMENTO_TVALOR,                   
                                CTB_MOVIMENTO_DESCRICAO,                
                                CTB_MOVIMENTO_SYSDATE,                  
                                CTB_MOVIMENTO_ORIGEM,                   
                                GLB_ROTA_CODIGO_CRESP,
                                CTB_MOVIMENTO_LINKID,
                                CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      NULL,
                                      TRIM(FN_GETPARM('CTFRETE',1)),
                                      NULL,
                                      P_ANO||VT_MES,
                                      NULL,
                                      TRIM(FN_GETPARM('HTFRETDESC',1)),
                                      '2',
                                      VT_SOMA,
                                      'D',
                                      TRIM(VT_DESCDEB),
                                      SYSDATE,
                                      P_MODO,
                                      NULL,
                                      P_ID,
                                      P_MODO);
-- Adiantamento

  IF VT_ADIANTAMENTO > 0 THEN
    BEGIN
      SELECT CTB_HISTORICO_DESCRICAO
        INTO VT_DESCCRE
        FROM T_CTB_HISTORICO
       WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETADTM',1));
      EXCEPTION WHEN NO_DATA_FOUND THEN
        SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETADTM',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
      END;    

    VT_SEQUENCIA := VT_SEQUENCIA+1; 

    INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                     CTB_MOVIMENTO_DSEQUENCIA,               
                                     CTB_MOVIMENTO_DTMOVTO,                  
                                     CTB_PCONTA_CODIGO_PARTIDA,             
                                  CTB_PCONTA_CODIGO_CPARTIDA,
                                   GLB_ROTA_CODIGO,                        
                                     CTB_REFERENCIA_CODIGO_PARTIDA,          
                                     CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                     CTB_HISTORICO_CODIGO,                   
                                     CTB_MOVIMENTO_TDOCUMENTO,               
                                     CTB_MOVIMENTO_VALOR,                    
                                     CTB_MOVIMENTO_TVALOR,                   
                                     CTB_MOVIMENTO_DESCRICAO,                
                                     CTB_MOVIMENTO_SYSDATE,                  
                                     CTB_MOVIMENTO_ORIGEM,                   
                                     GLB_ROTA_CODIGO_CRESP,
                                     CTB_MOVIMENTO_LINKID,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     VT_SEQUENCIA,
                                     TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                     TRIM(FN_GETPARM('CTFRETADTM',1)),
                                     TRIM(FN_GETPARM('CTFRETE',1)),
                                     NULL,
                                     P_ANO||VT_MES,
                                     P_ANO||VT_MES,
                                     TRIM(FN_GETPARM('HTFRETADTM',1)),
                                     '2',
                                     VT_ADIANTAMENTO,
                                     'C',
                                     TRIM(VT_DESCCRE),
                                     SYSDATE,
                                     P_MODO,
                                     NULL,
                                     P_ID,
                                     P_MODO);
    END IF;


-- SERA RETIRADO APARTIR DE ABRIL/2007 PASSANDO A SER UMA OCORRENCIA...
-- SEST/SENAT

  IF VT_SETSTSENAT > 0 THEN
    BEGIN
      SELECT CTB_HISTORICO_DESCRICAO
        INTO VT_DESCCRE
        FROM T_CTB_HISTORICO
       WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTFRETSTSN',1));
      EXCEPTION WHEN NO_DATA_FOUND THEN
        SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTFRETSTSN',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
        END;    

      VT_SEQUENCIA := VT_SEQUENCIA+1; 
 
      INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                       CTB_MOVIMENTO_DSEQUENCIA,               
                                       CTB_MOVIMENTO_DTMOVTO,                  
                                       CTB_PCONTA_CODIGO_PARTIDA,             
                                       CTB_PCONTA_CODIGO_CPARTIDA,                   
                                       GLB_ROTA_CODIGO,                        
                                       CTB_REFERENCIA_CODIGO_PARTIDA,          
                                       CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                       CTB_HISTORICO_CODIGO,                   
                                       CTB_MOVIMENTO_TDOCUMENTO,               
                                       CTB_MOVIMENTO_VALOR,                    
                                       CTB_MOVIMENTO_TVALOR,                   
                                       CTB_MOVIMENTO_DESCRICAO,                
                                       CTB_MOVIMENTO_SYSDATE,                  
                                       CTB_MOVIMENTO_ORIGEM,                   
                                       GLB_ROTA_CODIGO_CRESP,
                                       CTB_MOVIMENTO_LINKID,
                                       CTB_MOVIMENTO_ORIGEMPR)
                               VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                       VT_SEQUENCIA,
                                       TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                       TRIM(FN_GETPARM('CTFRETSTSN',1)),
                                       TRIM(FN_GETPARM('CTFRETE',1)),
                                       NULL,
                                       P_ANO||VT_MES,
                                       P_ANO||VT_MES,
                                       TRIM(FN_GETPARM('HTFRETSTSN',1)),
                                       '2',
                                       VT_SETSTSENAT,
                                       'C',
                                       TRIM(VT_DESCCRE),
                                       SYSDATE,
                                       P_MODO,
                                       NULL,
                                       P_ID,
                                       P_MODO);
      END IF;


  FOR R_DESC IN C_DESC LOOP    

-- DESCONTOS DO DEMONSTRATIVO

    BEGIN
      SELECT CTB_HISTORICO_DESCRICAO
        INTO VT_DESCCRE
        FROM T_CTB_HISTORICO
       WHERE CTB_HISTORICO_CODIGO = TRIM(R_DESC.HIST);
      EXCEPTION WHEN NO_DATA_FOUND THEN
        SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(R_DESC.HIST)||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
      END;    

      VT_SEQUENCIA := VT_SEQUENCIA+1; 
 
      INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                       CTB_MOVIMENTO_DSEQUENCIA,               
                                       CTB_MOVIMENTO_DTMOVTO,                  
                                       CTB_PCONTA_CODIGO_PARTIDA,             
                                      CTB_PCONTA_CODIGO_CPARTIDA,                         
                                       GLB_ROTA_CODIGO,                        
                                       CTB_REFERENCIA_CODIGO_PARTIDA,          
                                       CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                       CTB_HISTORICO_CODIGO,                   
                                       CTB_MOVIMENTO_TDOCUMENTO,               
                                       CTB_MOVIMENTO_VALOR,                    
                                       CTB_MOVIMENTO_TVALOR,                   
                                       CTB_MOVIMENTO_DESCRICAO,                
                                       CTB_MOVIMENTO_SYSDATE,                  
                                       CTB_MOVIMENTO_ORIGEM,                   
                                       GLB_ROTA_CODIGO_CRESP,
                                       CTB_MOVIMENTO_LINKID,
                                       CTB_MOVIMENTO_ORIGEMPR)
                               VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                       VT_SEQUENCIA,
                                       TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                       REPLACE(TRIM(R_DESC.PCONTA),'***',R_DESC.CCUSTO),
                                       REPLACE(TRIM(FN_GETPARM('CTFRETE',1)),'***',R_DESC.CCUSTO),
                                       TRIM(FN_VERFCTBCC(TRIM(R_DESC.PCONTA),R_DESC.CCUSTO)),
                                       P_ANO||VT_MES,
                                       P_ANO||VT_MES,
                                       TRIM(R_DESC.HIST),
                                       '2',
                                       R_DESC.VALOR,
                                       'C',
                                       TRIM(VT_DESCCRE)||' '||TRIM(FN_VERFCTBCC(TRIM(R_DESC.PCONTA),R_DESC.CCUSTO)),
                                       SYSDATE,
                                       P_MODO,
                                       TRIM( FN_VERFCTBCC(TRIM(R_DESC.PCONTA),R_DESC.CCUSTO)),
                                       P_ID,
                                       P_MODO);

    END LOOP;

 -- ********** I N S S  E M P R E S A ********** 


IF VT_PARETEEMP > 0 THEN
  BEGIN
    SELECT CTB_HISTORICO_DESCRICAO
      INTO VT_DESCDEB
      FROM T_CTB_HISTORICO
     WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTINSSEMPR',1));
    EXCEPTION WHEN NO_DATA_FOUND THEN
      SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTINSSEMPR',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
    END;    

  BEGIN
    SELECT CTB_HISTORICO_DESCRICAO
      INTO VT_DESCCRE
      FROM T_CTB_HISTORICO
     WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTINSSDESC',1));
    EXCEPTION WHEN NO_DATA_FOUND THEN
      SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTINSSDESC',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
    END;    

   VT_DOCTO     := VT_DOCTO + 1;
 
   VT_SEQUENCIA := 1;

   INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                    CTB_MOVIMENTO_DSEQUENCIA,               
                               CTB_MOVIMENTO_DTMOVTO,                  
                               CTB_PCONTA_CODIGO_CPARTIDA,             
                               CTB_PCONTA_CODIGO_PARTIDA,             
                               GLB_ROTA_CODIGO,                        
                               CTB_REFERENCIA_CODIGO_PARTIDA,          
                               CTB_REFERENCIA_CODIGO_CPARTIDA,         
                               CTB_HISTORICO_CODIGO,                   
                               CTB_MOVIMENTO_TDOCUMENTO,               
                               CTB_MOVIMENTO_VALOR,                    
                               CTB_MOVIMENTO_TVALOR,                   
                               CTB_MOVIMENTO_DESCRICAO,                
                               CTB_MOVIMENTO_SYSDATE,                  
                               CTB_MOVIMENTO_ORIGEM,                   
                                     GLB_ROTA_CODIGO_CRESP,
                                     CTB_MOVIMENTO_LINKID,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     VT_SEQUENCIA,
                                     TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                     NULL,
                                     TRIM(FN_GETPARM('CTFRETINSS',1)),
                                     NULL,
                                     P_ANO||VT_MES,
                                     NULL,
                                     TRIM(FN_GETPARM('HTINSSDESC',1)),
                                     '3',
                                     VT_PARETEEMP,
                                     'C',
                                     TRIM(VT_DESCCRE),
                                     SYSDATE,
                                     P_MODO,
                                     NULL,
                                     P_ID,
                                     P_MODO);
  
   FOR R_INSS IN C_INSS LOOP    

-- INSS Empresa

     BEGIN
       SELECT CTB_HISTORICO_DESCRICAO
         INTO VT_DESCDEB
         FROM T_CTB_HISTORICO
        WHERE CTB_HISTORICO_CODIGO = TRIM(FN_GETPARM('HTINSSEMPR',1));
       EXCEPTION WHEN NO_DATA_FOUND THEN
         SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'HISTORICO CONTABIL '||TRIM(FN_GETPARM('HTINSSEMPR',1))||' NÃO ENCONTRADO!!!','INCONSIST',P_ID,NULL);
       END;    

     VT_SEQUENCIA := VT_SEQUENCIA+1; 

     INSERT INTO T_CTB_MOVIMENTO_TMP (CTB_MOVIMENTO_DOCUMENTO,                
                                      CTB_MOVIMENTO_DSEQUENCIA,               
                                      CTB_MOVIMENTO_DTMOVTO,
                                      CTB_PCONTA_CODIGO_PARTIDA,
                                      CTB_PCONTA_CODIGO_CPARTIDA,             
                                     GLB_ROTA_CODIGO,                        
                                       CTB_REFERENCIA_CODIGO_PARTIDA,          
                                       CTB_REFERENCIA_CODIGO_CPARTIDA,         
                                       CTB_HISTORICO_CODIGO,                   
                                       CTB_MOVIMENTO_TDOCUMENTO,               
                                       CTB_MOVIMENTO_VALOR,                    
                                       CTB_MOVIMENTO_TVALOR,                   
                                       CTB_MOVIMENTO_DESCRICAO,                
                                       CTB_MOVIMENTO_SYSDATE,                  
                                       CTB_MOVIMENTO_ORIGEM,                   
                                      GLB_ROTA_CODIGO_CRESP,
                                      CTB_MOVIMENTO_LINKID,
                                      CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      TO_DATE(VT_DIA||'/'||VT_MES||'/'||P_ANO,'DD/MM/YYYY'),
                                      REPLACE(TRIM(FN_GETPARM('CTINSSEMPR',1)),'***',R_INSS.CCUSTO),
                                      REPLACE(TRIM(FN_GETPARM('CTFRETINSS',1)),'***',R_INSS.CCUSTO),
                                      TRIM(FN_VERFCTBCC(TRIM(FN_GETPARM('CTINSSEMPR',1)),R_INSS.CCUSTO)),
                                      P_ANO||VT_MES,
                                      P_ANO||VT_MES,
                                      TRIM(FN_GETPARM('HTINSSEMPR',1)),
                                      '3',
                                      R_INSS.PARTEEMPRESA,
                                      'D',
                                      TRIM(VT_DESCDEB)||' '||TRIM(FN_VERFCTBCC(TRIM(FN_GETPARM('CTINSSEMPR',1)),R_INSS.CCUSTO)),
                                      SYSDATE,
                                      P_MODO,
                                      TRIM(FN_VERFCTBCC(TRIM(FN_GETPARM('CTINSSEMPR',1)),R_INSS.CCUSTO)),                                       
                                      P_ID,
                                      P_MODO);
      END LOOP;
    END IF;
 
 -- Atualiza a Tabela de Logs de Transferencia.
 
    SELECT SUBSTR(OSUSER,1,20) OSUSER
      INTO VT_USUARIO
      FROM V$SESSION
     WHERE AUDSID = SYS_CONTEXT('USERENV','SESSIONID');
 
/*
    INSERT INTO T_CTB_LOGTRANSF (CTB_LOGTRANSF_REFERENCIA, 
                                 CTB_LOGTRANSF_DATA,       
                                 CTB_LOGTRANSF_USUARIO,    
                                 CTB_LOGTRANSF_SISTEMA)
                         VALUES (P_ANO||VT_MES,
                                 SYSDATE,
                                 VT_USUARIO,
                                 'COC'); 
*/
 END IF;
 
 IF P_MODO > 2 THEN
  VT_SEQUENCIA := 0;
  END IF;
 
 IF P_MODO > 3 THEN
  VT_SEQUENCIA := 0;
  END IF;

 
 -- *** F I N A L I Z A C A O  L O G ***
 
 SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'FINAL DA EXECUCAO DA PROCEDURE','EXECUCAO',P_ID,NULL);

 

--  INSERT INTO T_CTB_MOVIMENTO_TST
--  SELECT * FROM T_CTB_MOVIMENTO_TMP;


--  INSERT INTO T_CTB_MOVIMENTO_PREV
--  SELECT * FROM T_CTB_MOVIMENTO_TMP;
  
   


 END SP_LINK_CTB_TDVCOCA;

 

 Procedure SP_LINK_ATUCONHECIMENTO(P_CONHECIMENTO In T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%Type,
                                   P_SERIE        In T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%Type,
                                   P_ROTA         In T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%Type,
                                   P_ORIGEM       In Varchar2,
                                   P_DATA         In T_CON_CONHECCTBDET.CTB_MOVIMENTO_DTMOVTO%type,
                                   P_ID           In T_CON_CONHECCTB.CON_CONHECCTB_ID%type,
                                   P_DOCUMENTO    In T_CON_CONHECCTBDET.CTB_MOVIMENTO_DOCUMENTO%Type,
                                   P_SEQUENCIA    IN T_CON_CONHECCTBDET.CTB_MOVIMENTO_DSEQUENCIA%TYPE,
                                   P_REFERENCIA   In T_CON_CONHECCTB.CON_CONHECCTB_REF%Type,
                                   P_OBSERVACAO   IN VARCHAR2,
                                   P_COMMIT        In Char Default 'N')
 As
  
  Cursor C_CONHECIMENTO Is
  SELECT C.CON_CONHECIMENTO_CODIGO                   CON_CONHECIMENTO_CODIGO,
         C.CON_CONHECIMENTO_SERIE                    CON_CONHECIMENTO_SERIE,
         C.GLB_ROTA_CODIGO                           GLB_ROTA_CODIGO,
         P_DATA                                      CON_CONHECCTB_DATACTB,
         P_DATA                                      CON_CONHECCTB_DATAFiscal,
         C.CON_CONHECIMENTO_DTEMBARQUE               CON_CONHECIMENTO_DTEMBARQUE,
         NVL(R.GLB_ROTA_CODGENBAL,C.GLB_ROTA_CODIGO) CON_CONHECCTB_ROTA_RECEITA,
         R.GLB_ROTA_FISCAL                           CON_CONHECCTB_ROTA_FISCAL,
         c.glb_cliente_cgccpfsacado                  CON_CONHECCTB_sacado,
         NVL(VVAL.CON_CALCVIAGEM_VALOR,0)            CON_CONHECCTB_VALOR,
         nvl(PED.CON_CALCVIAGEM_VALOR,0)             CON_CONHECCTB_VALOR_PEDAGIO,
         NVL(VISS.CON_CALCVIAGEM_VALOR,0)            CON_CONHECCTB_VALOR_INSS,
         NVL(VICM.CON_CALCVIAGEM_VALOR,0)            CON_CONHECCTB_VALOR_ICMS,
         nvl(ALICMS.CON_CALCVIAGEM_VALOR,1)          CON_CONHECCTB_ALIQUOTA_ICMS, 
         nvl(ALISS.CON_CALCVIAGEM_VALOR,1)           CON_CONHECCTB_ALIQUOTA_ISS, 
         SUBSTR(P_REFERENCIA,1,6)                    CON_CONHECCTB_REF,
       --NVL(C.GLB_MERCADORIA_CODIGO, NVL(NVL(S.GLB_MERCADORIA_CODIGO,'') || NVL(T.GLB_MERCADORIA_CODIGO,''),'00'))           CON_CONHECCTB_EX,
       --NVL(NVL(S.GLB_MERCADORIA_CODIGO,'') || NVL(T.GLB_MERCADORIA_CODIGO,''),'00')           CON_CONHECCTB_EX,
         FN_GET_CODMERCADORIA(NVL(C.GLB_MERCADORIA_CODIGO,'99'), NVL(NVL(S.GLB_MERCADORIA_CODIGO,'') || NVL(T.GLB_MERCADORIA_CODIGO,''),'00')) CON_CONHECCTB_EX,
         NVL(C.CON_CONHECIMENTO_FLAGCANCELADO,'N')   CON_CONHECCTB_FLAGCANCELADO,
         R.GLB_CENTROCUSTO_CODIGO                    GLB_CENTROCUSTO_CODIGO 
  FROM V_CON_I_TTPV   VVAL,
       V_CON_I_VLISS  VISS,
       V_CON_I_VLICMS VICM,
       v_con_i_pd     PED,
       v_con_i_alicms ALICMS,
       v_con_i_aliss  ALISS,
       TDVADM.T_CON_CONHECIMENTO C,
       T_GLB_ROTA R,
       T_CON_CONHECCTB CT,
       T_SLF_SOLFRETE S,
       T_SLF_TABELA T
 WHERE C.GLB_ROTA_CODIGO                         = CT.GLB_ROTA_CODIGO(+)
   AND C.CON_CONHECIMENTO_CODIGO                 = CT.CON_CONHECIMENTO_CODIGO(+)
   AND C.CON_CONHECIMENTO_SERIE                  = CT.CON_CONHECIMENTO_SERIE(+)
   AND C.GLB_ROTA_CODIGO                         = R.GLB_ROTA_CODIGO
   AND C.CON_CONHECIMENTO_CODIGO                 = VVAL.CON_CONHECIMENTO_CODIGO(+)
   AND C.CON_CONHECIMENTO_SERIE                  = VVAL.CON_CONHECIMENTO_SERIE(+)
   AND C.GLB_ROTA_CODIGO                         = VVAL.GLB_ROTA_CODIGO(+)
   AND C.CON_CONHECIMENTO_CODIGO                 = PED.CON_CONHECIMENTO_CODIGO(+)
   AND C.CON_CONHECIMENTO_SERIE                  = PED.CON_CONHECIMENTO_SERIE(+)
   AND C.GLB_ROTA_CODIGO                         = PED.GLB_ROTA_CODIGO(+)
   AND C.CON_CONHECIMENTO_CODIGO                 = VISS.CON_CONHECIMENTO_CODIGO(+)
   AND C.CON_CONHECIMENTO_SERIE                  = VISS.CON_CONHECIMENTO_SERIE(+)
   AND C.GLB_ROTA_CODIGO                         = VISS.GLB_ROTA_CODIGO(+)
   AND C.CON_CONHECIMENTO_CODIGO                 = VICM.CON_CONHECIMENTO_CODIGO(+)
   AND C.CON_CONHECIMENTO_SERIE                  = VICM.CON_CONHECIMENTO_SERIE(+)
   AND C.GLB_ROTA_CODIGO                         = VICM.GLB_ROTA_CODIGO(+)


   AND C.CON_CONHECIMENTO_CODIGO                 = ALISS.CON_CONHECIMENTO_CODIGO(+)
   AND C.CON_CONHECIMENTO_SERIE                  = ALISS.CON_CONHECIMENTO_SERIE(+)
   AND C.GLB_ROTA_CODIGO                         = ALISS.GLB_ROTA_CODIGO(+)
   AND C.CON_CONHECIMENTO_CODIGO                 = ALICMS.CON_CONHECIMENTO_CODIGO(+)
   AND C.CON_CONHECIMENTO_SERIE                  = ALICMS.CON_CONHECIMENTO_SERIE(+)
   AND C.GLB_ROTA_CODIGO                         = ALICMS.GLB_ROTA_CODIGO(+)




   AND C.SLF_SOLFRETE_CODIGO                     = S.SLF_SOLFRETE_CODIGO(+)
   AND C.SLF_SOLFRETE_SAQUE                      = S.SLF_SOLFRETE_SAQUE(+)
   AND C.SLF_TABELA_CODIGO                       = T.SLF_TABELA_CODIGO(+)
   AND C.SLF_TABELA_SAQUE                        = T.SLF_TABELA_SAQUE(+)
   And C.CON_CONHECIMENTO_CODIGO                 = P_CONHECIMENTO
   And C.CON_CONHECIMENTO_SERIE                  = P_SERIE
   And C.GLB_ROTA_CODIGO                         = P_ROTA
   AND C.CON_CONHECIMENTO_SERIE                 <> 'XXX'
   -- Sirlano 21/11/2016
   -- Para evitar de registrar algum Conhecimento não autorizado
   and pkg_con_cte.fn_cte_eeletronico(c.con_conhecimento_codigo,c.con_conhecimento_serie,c.glb_rota_codigo) = 'S'
--   AND NVL(C.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N'

   AND C.GLB_ROTA_CODIGO            NOT IN (SELECT TRIM(CTB_LINKPARAMETRO_CONTEUDOCHAR)
                                              FROM TDVADM.T_CTB_LINKPARAMETRO
                                             WHERE CTB_LINKPARAMETRO_TIPO = 'EXCROTACON'
                                               AND CTB_LINKPARAMETRO_STATUS = 'A');

  TypeCursorCtrc C_CONHECIMENTO%Rowtype;
  TypeConhecCTB    tdvadm.t_con_conhecctb%Rowtype;
  TypeConhecCTBDet tdvadm.t_con_conhecctbdet%Rowtype;
  vContador    Number;
  vContadorDet Number;
  vNovaData    Date;
  vIdCTB       tdvadm.t_con_conhecctb.con_conhecctb_id%type;
  vDataFiscal  char(10);
  
 Begin
  
  Begin
      Select *
        Into TypeConhecCTB
      From t_con_conhecctb c
      Where C.CON_CONHECIMENTO_CODIGO = P_CONHECIMENTO
        And C.CON_CONHECIMENTO_SERIE  = P_SERIE
        And C.GLB_ROTA_CODIGO         = P_ROTA;
        vContador := 1;
  Exception
    When NO_DATA_FOUND Then
      vContador := 0;
    End;  

  if P_DOCUMENTO is null then
     vContadorDet := -1;
  Else   
      Begin
          Select *
            Into TypeConhecCTBDet
          From t_con_conhecctbdet c
          Where C.CON_CONHECIMENTO_CODIGO  = P_CONHECIMENTO
            And C.CON_CONHECIMENTO_SERIE   = P_SERIE
            And C.GLB_ROTA_CODIGO          = P_ROTA
            and c.ctb_movimento_dtmovto    = P_DATA
            and c.ctb_movimento_documento  = P_DOCUMENTO
            and c.ctb_movimento_dsequencia = P_SEQUENCIA;
            vContadordet := 1;
      Exception
        When NO_DATA_FOUND Then
          vContadordet := 0;
        End;  
  End if;      


    Open C_CONHECIMENTO;
    
    Fetch C_CONHECIMENTO 
       Into TypeCursorCtrc;

    If TypeCursorCtrc.Con_Conhecimento_Codigo Is Not Null then
            

           
        If P_DATA Is Null Then
           vNovaData := LAST_DAY(to_date(TO_DATE(P_REFERENCIA || '01','YYYYMMDD'),'dd/mm/yyyy'));       
        Else
           vNovaData := P_DATA;   
        End If;


        If vContador = 0 Then
           TypeConhecCTB.Con_Conhecimento_Codigo     := TypeCursorCtrc.Con_Conhecimento_Codigo    ;
           TypeConhecCTB.Con_Conhecimento_Serie      := TypeCursorCtrc.Con_Conhecimento_Serie     ;
           TypeConhecCTB.Glb_Rota_Codigo             := TypeCursorCtrc.Glb_Rota_Codigo            ;
           TypeConhecCTB.Con_Conhecctb_Datactb       := TypeCursorCtrc.Con_Conhecctb_Datactb      ;
           TypeConhecCTB.Con_Conhecctb_DataFiscal    := TypeCursorCtrc.Con_Conhecctb_Datafiscal   ;
           TypeConhecCTB.Con_Conhecimento_Dtembarque := TypeCursorCtrc.Con_Conhecimento_Dtembarque;
           TypeConhecCTB.Con_Conhecctb_Rota_Receita  := TypeCursorCtrc.Con_Conhecctb_Rota_Receita ;
           TypeConhecCTB.Con_Conhecctb_Rota_Fiscal   := TypeCursorCtrc.Con_Conhecctb_Rota_Fiscal  ;
           TypeConhecCTB.Con_Conhecctb_Valor         := TypeCursorCtrc.Con_Conhecctb_Valor        ;
           TypeConhecCTB.Con_Conhecctb_Valor_Pedagio := TypeCursorCtrc.Con_Conhecctb_Valor_Pedagio;
           TypeConhecCTB.Con_Conhecctb_Valor_Inss    := TypeCursorCtrc.Con_Conhecctb_Valor_Inss   ;
           TypeConhecCTB.Con_Conhecctb_Valor_Icms    := TypeCursorCtrc.Con_Conhecctb_Valor_Icms   ;
           TypeConhecCTB.Con_Conhecctb_Aliquota_icms := TypeCursorCtrc.Con_Conhecctb_Aliquota_icms;
           TypeConhecCTB.Con_Conhecctb_Aliquota_iss  := TypeCursorCtrc.Con_Conhecctb_Aliquota_iss ;
           TypeConhecCTB.CON_CONHECCTB_REF           := TypeCursorCtrc.CON_CONHECCTB_REF          ;
           TypeConhecCTB.Con_Conhecctb_Ex            := TypeCursorCtrc.Con_Conhecctb_Ex           ;
           TypeConhecCTB.Con_Conhecctb_Flagcancelado := TypeCursorCtrc.Con_Conhecctb_Flagcancelado;
           TypeConhecCTB.Con_Conhecctb_Sacado        := TypeCursorCtrc.CON_CONHECCTB_sacado; 
           TypeConhecCTB.Con_Conhecctb_Datactb       := Null;
           TypeConhecCTB.Con_Conhecctb_DataFiscal    := Null;
           TypeConhecCTB.Con_Conhecctb_Id            := p_id;
           TypeConhecCTB.Glb_Centrocusto_Codigo      := TypeCursorCtrc.GLB_CENTROCUSTO_CODIGO;
           TypeConhecCTB.Glb_Centrocusto_CodigoC     := tdvadm.PKG_SLF_UTILITARIOS.fn_retorna_contratoCC(TypeCursorCtrc.Con_Conhecimento_Codigo,TypeCursorCtrc.Con_Conhecimento_Serie,TypeCursorCtrc.Glb_Rota_Codigo);
            

        End If; 
        

        If p_origem = 'CTB' Then
           TypeConhecCTB.Con_Conhecctb_Datactb := vNovaData;
           TypeConhecCTB.Con_Conhecctb_Id            := p_id;
        Elsif p_origem = 'SYN' Then
           TypeConhecCTB.Con_Conhecctb_Datafiscal := vNovaData;
        End If;

        TypeConhecCTB.Con_Conhecctb_Observacao    := trim(TypeConhecCTB.Con_Conhecctb_Observacao) || ' ' || P_OBSERVACAO;


        If vContador = 0 Then
          BEGIN
             Insert Into t_con_conhecctb
             Values TypeConhecCTB;
          EXCEPTION
            WHEN others THEN
               raise_application_error(-20001,P_CONHECIMENTO||'-'||P_SERIE||'-'||P_ROTA ||'-'|| SQLERRM);
            END;   

             
        Else
          if P_ORIGEM is null Then
              Update  tdvadm.t_con_conhecctb c
                Set c.con_conhecctb_id            = TypeConhecCTB.Con_Conhecctb_Id,
                    c.con_conhecctb_datactb       = TypeConhecCTB.Con_Conhecctb_Datactb,
                    c.con_conhecctb_DataFiscal     = TypeConhecCTB.Con_Conhecctb_DataFiscal,
                    c.con_conhecimento_dtembarque = TypeCursorCtrc.Con_Conhecimento_Dtembarque,
                    c.con_conhecctb_rota_receita  = TypeCursorCtrc.Con_Conhecctb_Rota_Receita,
                    c.con_conhecctb_rota_fiscal   = TypeCursorCtrc.Con_Conhecctb_Rota_Fiscal,
                    c.con_conhecctb_valor         = TypeCursorCtrc.Con_Conhecctb_Valor,
                    c.con_conhecctb_valor_inss    = TypeCursorCtrc.Con_Conhecctb_Valor_Inss,
                    c.con_conhecctb_valor_icms    = TypeCursorCtrc.Con_Conhecctb_Valor_Icms,
                    c.con_conhecctb_ex            = TypeCursorCtrc.Con_Conhecctb_Ex,
                    c.con_conhecctb_flagcancelado = TypeCursorCtrc.Con_Conhecctb_Flagcancelado,
                    c.con_conhecctb_sacado        = TypeCursorCtrc.Con_Conhecctb_Sacado,
                    c.glb_centrocusto_codigo      = TypeCursorCtrc.glb_centrocusto_codigo,
                    c.glb_centrocusto_codigoC     = tdvadm.PKG_SLF_UTILITARIOS.fn_retorna_contratoCC(TypeCursorCtrc.Con_Conhecimento_Codigo,TypeCursorCtrc.Con_Conhecimento_Serie,TypeCursorCtrc.Glb_Rota_Codigo),
                    c.Con_Conhecctb_Aliquota_icms = TypeCursorCtrc.Con_Conhecctb_Aliquota_icms,
                    c.Con_Conhecctb_Aliquota_iss  = TypeCursorCtrc.Con_Conhecctb_Aliquota_iss
               Where c.con_conhecimento_codigo = P_CONHECIMENTO
                 And c.con_conhecimento_serie  = P_SERIE
                 And c.glb_rota_codigo         = P_ROTA
                 and c.con_conhecctb_id is null
                 and c.con_conhecctb_DataFiscal is null;
          Elsif P_ORIGEM = 'CTB' then
              Update  t_con_conhecctb c
                Set c.con_conhecctb_id            = TypeConhecCTB.Con_Conhecctb_Id,
                    c.con_conhecctb_datactb       = TypeConhecCTB.Con_Conhecctb_Datactb
               Where c.con_conhecimento_codigo = P_CONHECIMENTO
                 And c.con_conhecimento_serie  = P_SERIE
                 And c.glb_rota_codigo         = P_ROTA
                 and c.con_conhecctb_id is null;
          Elsif P_ORIGEM = 'SYN' then        
              Update  t_con_conhecctb c
                Set c.con_conhecctb_DataFiscal     = TypeConhecCTB.Con_Conhecctb_DataFiscal
               Where c.con_conhecimento_codigo = P_CONHECIMENTO
                 And c.con_conhecimento_serie  = P_SERIE
                 And c.glb_rota_codigo         = P_ROTA
                 and c.con_conhecctb_DataFiscal is null;
          End if;       
        End If;

        if sql%rowcount = 0 Then
           pkg_ctb_links.vCriticaProcess :=  pkg_ctb_links.vCriticaProcess || P_CONHECIMENTO || '-' || P_SERIE || '-' || P_ROTA ;
           if vContador = 0 Then 
              pkg_ctb_links.vCriticaProcess :=  pkg_ctb_links.vCriticaProcess || ' - Não Inserido ' || chr(10);
           Else
              select con_conhecctb_id,
                     to_char(con_conhecctb_DataFiscal,'dd/mm/yyyy')
                 into vIdCTB,
                      vDataFiscal
               from t_con_conhecctb c
               Where c.con_conhecimento_codigo = P_CONHECIMENTO
                 And c.con_conhecimento_serie  = P_SERIE
                 And c.glb_rota_codigo         = P_ROTA;

              pkg_ctb_links.vCriticaProcess :=  pkg_ctb_links.vCriticaProcess || ' - Não Alterado IDCTB - ' || vIdCTB || ' - DTFiscal ' || vDataFiscal ||  chr(10);
           End if;   
        End if;
       
        if vContadorDet > 0 Then
           delete t_con_conhecctbdet ct
           Where Ct.CON_CONHECIMENTO_CODIGO  = P_CONHECIMENTO
             And Ct.CON_CONHECIMENTO_SERIE   = P_SERIE
             And Ct.GLB_ROTA_CODIGO          = P_ROTA
             AND CT.CON_CONHECCTB_ID         = p_ID;
             vContadorDet := 0;
        end if;
        if vContadorDet = 0 Then
           TypeConhecCTBDet.Con_Conhecimento_Codigo     := P_CONHECIMENTO;
           TypeConhecCTBDet.Con_Conhecimento_Serie      := P_SERIE; 
           TypeConhecCTBDet.Glb_Rota_Codigo             := P_ROTA;
           TypeConhecCTBDet.Ctb_Movimento_Dtmovto       := P_DATA;
           TypeConhecCTBDet.Ctb_Movimento_Documento     := P_DOCUMENTO;
           TypeConhecCTBDet.Ctb_Movimento_Dsequencia    := P_SEQUENCIA; 
           TypeConhecCTBDet.Con_Conhecctbdet_Dtgravacao := sysdate;
           TypeConhecCTBDet.Con_Conhecctbdet_Observacao := P_OBSERVACAO;
           TypeConhecCTBDet.Con_Conhecctb_Id            := P_ID;
           insert into t_con_conhecctbdet
           values TypeConhecCTBDet;
        end if;
         
    End If;     


   
    If NVL(P_COMMIT,'N') = 'S' Then
      Commit;
    End If;  
   
 End SP_LINK_ATUCONHECIMENTO;



PROCEDURE SP_LINK_ATUCONHECIMENTOHIST(P_REFERENCIA In TDVADM.T_CON_CONHECCTB.CON_CONHECCTB_REF%Type)
As                                
  P_DATAINI DATE;
  P_DATAFIM DATE;
  CURSOR c_CONHEC IS
    select A.con_conhecimento_codigo,
           A.con_conhecimento_serie,
           A.glb_rota_codigo,
           A.CON_CONHECIMENTO_FLAGCANCELADO
      from t_con_conhecimento A
     where nvl(A.CON_CONHECIMENTO_DTEMBARQUE,'01/01/1900') >= P_DATAINI
       and nvl(A.CON_CONHECIMENTO_DTEMBARQUE,'01/01/1900') <= P_DATAFIM
--       AND nvl(A.CON_CONHECIMENTO_DTEMBARQUE,'01/01/1900') <= to_date('15/08/2019','dd/mm/yyyy') 
       And A.con_conhecimento_serie <> 'XXX'
       AND A.GLB_ROTA_CODIGO    NOT IN (SELECT TRIM(CTB_LINKPARAMETRO_CONTEUDOCHAR)
                                        FROM TDVADM.T_CTB_LINKPARAMETRO
                                        WHERE CTB_LINKPARAMETRO_TIPO = 'EXCROTACON'
                                          AND CTB_LINKPARAMETRO_STATUS = 'A');
       
   TypeConhec c_conhec%Rowtype;
BEGIN
  who_called_me2;

  P_DATAINI := TO_DATE(P_REFERENCIA || '01','YYYYMMDD');
  P_DATAFIM := LAST_DAY(TO_DATE(P_REFERENCIA || '01','YYYYMMDD'));
  pkg_ctb_links.vCriticaProcess := ' Iniciando Processamento as ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || chr(10);
  
  open c_conhec;
  LOOP
    FETCH c_CONHEC
      INTO TypeConhec;
    EXIT WHEN c_CONHEC%notfound;
    pkg_ctb_links.SP_LINK_ATUCONHECIMENTO(TypeConhec.Con_Conhecimento_Codigo,
                                          TypeConhec.con_conhecimento_serie,
                                          TypeConhec.Glb_Rota_Codigo,
                                          NULL,
                                          NULL,
                                          Null,
                                          Null,
                                          null,
                                          P_REFERENCIA,
                                          null,
                                          'S');
                                          
                                         
                                          

  END LOOP;
  if pkg_ctb_links.vCriticaProcess = '' Then
     pkg_ctb_links.vCriticaProcess := 'Executado sem Erros ... ';
  Else
     pkg_ctb_links.vCriticaProcess := pkg_ctb_links.vCriticaProcess || ' Finalizando Processamento as ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || chr(10);       
  End if;
     wservice.pkg_glb_email.SP_ENVIAEMAIL('PROCESSAMENTO CONHECIMENTO',
                                          pkg_ctb_links.vCriticaProcess,
                                          'tdv.producao@dellavolpe.com.br',
                                          'rpariz@dellavolpe.com.br');
  
End SP_LINK_ATUCONHECIMENTOHIST;


 Procedure SP_LINK_ATUVALEFRETE(P_VALE       In    T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%Type,
                                P_SERIE      In T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%Type,
                                P_ROTA       In T_CON_VALEFRETE.GLB_ROTA_CODIGO%Type,
                                P_SAQUE      In T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%Type,
                                P_ORIGEM     In Varchar2,
                                P_DATA       In t_Con_Vfretectbdet.Ctb_Movimento_Dtmovto%type, 
                                P_ID         In t_Con_Vfretectb.Con_Vfretectb_Id%Type,
                                P_DOCUMENTO    In t_Con_Vfretectbdet.CTB_MOVIMENTO_DOCUMENTO%Type,
                                P_SEQUENCIA    IN t_Con_Vfretectbdet.CTB_MOVIMENTO_DSEQUENCIA%TYPE,
                                P_REFERENCIA In T_CON_CONHECCTB.CON_CONHECCTB_REF%Type,
                                p_observacao in varchar2,
                                p_classifexp in char,
                                P_COMMIT     In Char Default 'N')
 As
  
  Cursor C_VALEFRETE Is
      SELECT TO_CHAR(T.CON_VALEFRETE_DATACADASTRO,'DD') DIA,
              t.con_conhecimento_codigo,
              t.con_conhecimento_serie,
              T.GLB_ROTA_CODIGO                                                                                                          GLB_ROTA_CODIGO,
              t.con_valefrete_saque,
              p_id con_vfrectb_id,
              SUBSTR(p_referencia,1,6) con_vfretectb_ref,
              t.con_valefrete_dataemissao,
              t.con_valefrete_datacadastro,
              Null con_vfretectb_datacancelado,
              NVL(T.CON_VALEFRETE_STATUS,'N') con_vfretectb_flagcancelado,
              t.glb_tpmotorista_codigo,
              p.car_proprietario_cgccpfcodigo,
              p.car_proprietario_inps_codigo,
              t.con_valefrete_carreteiro,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(DECODE(trim(T.GLB_TPMOTORISTA_CODIGO),'A',nvl(T.CON_VALEFRETE_VALORCOMDESCONTO,(T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1))),(T.CON_VALEFRETE_CUSTOCARRETEIRO * DECODE(T.CON_VALEFRETE_TIPOCUSTO,'T',T.CON_VALEFRETE_PESOCOBRADO,1))),0))) FRETE,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Adiantamento,0))) adiantamento,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.CON_VALEFRETE_PEDAGIO,0))) PEDAGIO,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.CON_VALEFRETE_VALORLIQUIDO,0))) VALORLIQUIDO,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Inss,0))) Inss,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Sestsenat,0))) Sestsenat ,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Irrf,0))) Irrf ,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Cofins,0))) Cofins,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Csll,0))) Csll,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Pis,0))) Pis,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Multa,0))) Multa,
              DECODE(CON_CATVALEFRETE_CODIGO,'4',0,(NVL(T.Con_Valefrete_Outros,0)))Outros,
              0 QTDECTRCEX,
              0 QTDECTRC,
              T.CON_VALEFRETE_PLACA,
              T.CON_VALEFRETE_PLACASAQUE,
              t.con_catvalefrete_codigo,
              '61139432000172' CON_VFRETECTB_CNPJRECOLHE,
              (select nvl(count(*),0) 
                 from t_con_vfreteciot vc
                where vc.con_conhecimento_codigo = t.con_conhecimento_codigo
                  and vc.con_conhecimento_serie  = t.con_conhecimento_serie
                  and vc.glb_rota_codigo         = t.glb_rota_codigo
                  and vc.con_valefrete_saque     = t.con_valefrete_saque) Eletronico
         FROM T_CON_VALEFRETE T,
              T_CAR_VEICULO V,
              T_CAR_PROPRIETARIO P,
              T_GLB_ROTA R
         Where T.CON_CONHECIMENTO_CODIGO = P_VALE
           And T.CON_CONHECIMENTO_SERIE = P_SERIE
           And T.GLB_ROTA_CODIGO = P_ROTA
           And T.CON_VALEFRETE_SAQUE = P_SAQUE
           AND T.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL
           AND trim(T.GLB_TPMOTORISTA_CODIGO)            <> 'F'
           AND R.GLB_ROTA_CODIGO                    = T.GLB_ROTA_CODIGO
           AND T.CON_VALEFRETE_PLACA                = V.CAR_VEICULO_PLACA (+)
           AND T.CON_VALEFRETE_PLACASAQUE           = V.CAR_VEICULO_SAQUE (+)
           AND V.CAR_PROPRIETARIO_CGCCPFCODIGO      = P.CAR_PROPRIETARIO_CGCCPFCODIGO (+)
         -- VERIFICA QUAIS CATEGORIAS NÃO PODEM ENTRAR
           AND INSTR(GET_CATVF,T.CON_CATVALEFRETE_CODIGO) = 0 
           AND INSTR(GET_SERIEVF,T.CON_CONHECIMENTO_SERIE)  > 0 ;
 
  TypeCursorVF    C_VALEFRETE%Rowtype;
  TypeVFCTB       tdvadm.t_Con_Vfretectb%Rowtype;
  TypeVFCTBDet    tdvadm.t_Con_Vfretectbdet%Rowtype;
  TypeVFCONHECCTB tdvadm.t_con_vfreteconhecctb%rowtype;
  vContador Number;
  vContadordet Number;
  vNovaData Date;
  vSomaRatFrete number;
  VsomaRatReceita number;
  vSomaRatPedagio number;
 Begin
   
  
 
  If P_VALE = '719079' Then
     VsomaRatReceita := VsomaRatReceita;
  End IF;

  Begin
      Select *
        Into TypeVFCTB
      From t_con_VFRETECtb c
      Where C.CON_CONHECIMENTO_CODIGO = P_VALE
        And C.CON_CONHECIMENTO_SERIE  = P_SERIE
        And C.GLB_ROTA_CODIGO         = P_ROTA
        And C.CON_VALEFRETE_SAQUE     = P_SAQUE;

        vContador := 1;
  Exception
    When NO_DATA_FOUND Then
      vContador := 0;

    End;  

  if P_DOCUMENTO is null then
     vContadordet := -1;
  Else
    
    Begin
        Select *
          Into TypeVFCTBDet
        From t_Con_Vfretectbdet c
        Where C.CON_CONHECIMENTO_CODIGO  = P_VALE
          And C.CON_CONHECIMENTO_SERIE   = P_SERIE
          And C.GLB_ROTA_CODIGO          = P_ROTA
          And C.CON_VALEFRETE_SAQUE      = P_SAQUE
          and c.ctb_movimento_dtmovto    = P_DATA
          and c.ctb_movimento_documento  = P_DOCUMENTO
          and c.ctb_movimento_dsequencia = P_SEQUENCIA;
          vContadordet := 1;
    Exception
      When NO_DATA_FOUND Then
        vContadordet := 0;

      End;  
  end if;   


    Open C_VALEFRETE;
    
    Fetch C_VALEFRETE 
       Into TypeCursorVF;
    
    If P_DATA Is Null Then
       vNovaData := LAST_DAY(TO_DATE(P_REFERENCIA || '01','YYYYMMDD'));       
    Else
       vNovaData := P_DATA;   
    End If;

    
--    Pegar quantidade de ctrc com carga EX
 select sum(decode(ct.con_conhecctb_ex,'EX',1,0)) exportacao,
        sum(decode(ct.con_conhecctb_ex,'EX',0,1)) normal
    into TypeCursorVF.Qtdectrcex,
         TypeCursorVF.Qtdectrc
 from  T_CON_CONHECCTB CT,
       t_con_vfreteconhec vfc
 WHERE ct.con_conhecimento_codigo   = vfc.con_conhecimento_codigo
   and ct.con_conhecimento_serie    = vfc.con_conhecimento_serie
   and ct.glb_rota_codigo           = vfc.glb_rota_codigo
   and vfc.con_valefrete_codigo     = P_VALE
   and vfc.con_valefrete_serie      = P_SERIE
   and vfc.glb_rota_codigovalefrete = P_ROTA
   and vfc.con_valefrete_saque      = P_SAQUE;
   
   TypeCursorVF.Qtdectrcex := nvl(TypeCursorVF.Qtdectrcex,0);
   TypeCursorVF.Qtdectrc   := nvl(TypeCursorVF.Qtdectrc,0);


--    If vContador = 0 Then
       TypeVFCTB.Con_Vfretectb_Dia             := TypeCursorVF.Dia;
       TypeVFCTB.Con_Conhecimento_Codigo       := P_VALE;  -- TypeCursorVF.Con_Conhecimento_Codigo    ;
       TypeVFCTB.Con_Conhecimento_Serie        := P_SERIE; -- TypeCursorVF.Con_Conhecimento_Serie     ;
       TypeVFCTB.Glb_Rota_Codigo               := P_ROTA;  -- TypeCursorVF.Glb_Rota_Codigo            ;
       TypeVFCTB.Con_Valefrete_Saque           := P_SAQUE; -- TypeCursorVF.Con_Valefrete_Saque;
       TypeVFCTB.Con_Vfretectb_Id              := TypeCursorVF.Con_Vfrectb_Id;
       TypeVFCTB.Con_Vfretectb_Ref             := TypeCursorVF.Con_Vfretectb_Ref;
       TypeVFCTB.Con_Valefrete_Dataemissao     := TypeCursorVF.Con_Valefrete_Dataemissao;
       TypeVFCTB.Con_Valefrete_Datacadastro    := trunc(TypeCursorVF.Con_Valefrete_Datacadastro);
       TypeVFCTB.Con_Vfretectb_Flagcancelado   := TypeCursorVF.Con_Vfretectb_Flagcancelado;
       TypeVFCTB.Glb_Tpmotorista_Codigo        := TypeCursorVF.Glb_Tpmotorista_Codigo;
       TypeVFCTB.Car_Proprietario_Cgccpfcodigo := TypeCursorVF.Car_Proprietario_Cgccpfcodigo;
       TypeVFCTB.Car_Proprietario_Nit          := TypeCursorVF.Car_Proprietario_Inps_Codigo;
       TypeVFCTB.Car_Carreteiro_Cpfcodigo      := TypeCursorVF.Con_Valefrete_Carreteiro;
       TypeVFCTB.Con_Valefrete_Frete           := TypeCursorVF.Frete;
       TypeVFCTB.Con_Valefrete_Adiantamento    := TypeCursorVF.Adiantamento;
       TypeVFCTB.Con_Valefrete_Pedagio         := TypeCursorVF.Pedagio;
       TypeVFCTB.Con_Valefrete_Valorliquido    := TypeCursorVF.Valorliquido;
       TypeVFCTB.Con_Valefrete_Inss            := TypeCursorVF.Inss;
       TypeVFCTB.Con_Valefrete_Sestsenat       := TypeCursorVF.Sestsenat;
       TypeVFCTB.Con_Valefrete_Irrf            := TypeCursorVF.Irrf;
       TypeVFCTB.Con_Valefrete_Cofins          := TypeCursorVF.Cofins;
       TypeVFCTB.Con_Valefrete_Csll            := TypeCursorVF.Csll;
       TypeVFCTB.Con_Valefrete_Pis             := TypeCursorVF.Pis;
       TypeVFCTB.Con_Valefrete_Multa           := TypeCursorVF.Multa;
       TypeVFCTB.Con_Valefrete_Outros          := TypeCursorVF.Outros;
       TypeVFCTB.Con_Vfretectb_Qtdectrcex      := TypeCursorVF.Qtdectrcex;
       TypeVFCTB.Con_Vfretectb_Qtdectrc        := TypeCursorVF.Qtdectrc;
       TypeVFCTB.Car_Veiculo_Placa             := TypeCursorVF.Con_Valefrete_Placa;
       TypeVFCTB.Car_Veiculo_Saque             := TypeCursorVF.Con_Valefrete_Placasaque;
       TypeVFCTB.Con_Catvalefrete_Codigo       := TypeCursorVF.Con_Catvalefrete_Codigo;
       TypeVFCTB.Con_Vfretectb_Cnpjrecolhe     := TypeCursorVF.Con_Vfretectb_Cnpjrecolhe;
       TypeVFCTB.Con_Vfretectb_Datagravacao    := Sysdate;
       TypeVFCTB.Con_Vfretectb_Datactb         := Null;
       TypeVFCTB.Con_Vfretectb_Id              := Null;
       
--    End If; 
    

    If p_origem = 'CTB' Then
       TypeVFCTB.Con_Vfretectb_Datactb := vNovaData;
       TypeVFCTB.Con_Vfretectb_Ctbexportacao := p_classifexp;
--       TypeVFCTB.Con_Vfretectb_Refctb  := P_REFERENCIA;
       TypeVFCTB.Con_Vfretectb_Id      := P_ID;
    Elsif p_origem = 'SYN' Then
       TypeVFCTB.Con_Vfretectb_Datafiscal := vNovaData;
--       TypeVFCTB.Con_Vfretectb_RefFIS     := P_REFERENCIA;

    End If;

    If vContador = 0 Then
      Begin
      Insert Into t_Con_Vfretectb
      Values TypeVFCTB;


      TypeVFCONHECCTB.Con_Valefrete_Dtcadastro     := trunc(TypeVFCTB.Con_Valefrete_Datacadastro);
      TypeVFCONHECCTB.Con_Valefrete_Codigo         := TypeVFCTB.Con_Conhecimento_Codigo;
      TypeVFCONHECCTB.Con_Valefrete_Serie          := TypeVFCTB.Con_Conhecimento_Serie;
      TypeVFCONHECCTB.Glb_Rota_Codigovalefrete     := TypeVFCTB.Glb_Rota_Codigo;
      TypeVFCONHECCTB.Con_Valefrete_Saque          := TypeVFCTB.Con_Valefrete_Saque;  
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrfrete := TypeVFCTB.Con_Valefrete_Frete ;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrpedagio := TypeVFCTB.Con_Valefrete_Pedagio;
      vSomaRatFrete := 0;
      VsomaRatReceita := 0;
      vSomaRatPedagio := 0;


      TypeVFCONHECCTB.Con_Conhecimento_Dtembarque    := null;
      TypeVFCONHECCTB.Glb_Rota_Codigo                := null;
      TypeVFCONHECCTB.Con_Conhecimento_Codigo        := null;
      TypeVFCONHECCTB.Con_Conhecimento_Serie         := null;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Recalcula  := 0;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrreceita := 0;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Fatreceita := 0;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Fatfrete   := 0;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratreceita := 0;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratfrete   := TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrfrete;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratpegagio := TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrpedagio;
      TypeVFCONHECCTB.Con_Vfreteconhecctb_Dtgravacao := sysdate;
      TypeVFCONHECCTB.Glb_Centrocusto_Codigoc        := null;
      Select r.glb_centrocusto_codigo
         into TypeVFCONHECCTB.Glb_Centrocusto_Codigo         
      from tdvadm.t_glb_rota r
      where r.glb_rota_codigo = TypeVFCONHECCTB.Glb_Rota_Codigovalefrete;
     



      for c_msg in (select c.con_conhecimento_dtembarque,
                           c.glb_rota_codigo,
                           c.con_conhecimento_codigo,
                           c.con_conhecimento_serie,
                           vfc.con_vfreteconhec_recalcula,
                           vfc.slf_tpcalculo_codigo,
                           vfc.con_vfreteconhec_rateioreceita,
                           nvl(vfc.con_vfreteconhec_rateiofrete,1) con_vfreteconhec_rateiofrete,
                           nvl(vfc.con_vfreteconhec_rateiopedagio,1) con_vfreteconhec_rateiopedagio,
                           sysdate dtcadastro,
                           r.glb_centrocusto_codigo,
                           tdvadm.fn_busca_conhec_verba(c.Con_Conhecimento_Codigo,c.Con_Conhecimento_Serie,c.Glb_Rota_Codigo,'I_TTPV') valorReceita,
                           tdvadm.PKG_SLF_UTILITARIOS.fn_retorna_contratoCC(c.Con_Conhecimento_Codigo,c.Con_Conhecimento_Serie,c.Glb_Rota_Codigo) glb_centrocusto_codigoC
                    from tdvadm.t_con_vfreteconhec vfc,
                         tdvadm.t_con_conhecimento c,
                         tdvadm.t_glb_rota r
                    where vfc.con_valefrete_codigo     = TypeVFCONHECCTB.Con_Valefrete_Codigo
                      and vfc.con_valefrete_serie      = TypeVFCONHECCTB.Con_Valefrete_Serie
                      and vfc.glb_rota_codigovalefrete = TypeVFCONHECCTB.Glb_Rota_Codigovalefrete
                      and vfc.con_valefrete_saque      = TypeVFCONHECCTB.Con_Valefrete_Saque
                      and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                      and vfc.con_conhecimento_serie = c.con_conhecimento_serie
                      and vfc.glb_rota_codigo = c.glb_rota_codigo
                      and c.glb_rota_codigo = r.glb_rota_codigo
                    order by vfc.con_valefrete_codigo,
                             vfc.con_valefrete_serie,
                             vfc.glb_rota_codigovalefrete,
                             c.con_conhecimento_dtembarque,
                             c.glb_rota_codigo,
                             c.con_conhecimento_codigo )
           Loop
              TypeVFCONHECCTB.Con_Conhecimento_Dtembarque    := c_msg.con_conhecimento_dtembarque;
              TypeVFCONHECCTB.Glb_Rota_Codigo                := c_msg.glb_rota_codigo;
              TypeVFCONHECCTB.Con_Conhecimento_Codigo        := c_msg.con_conhecimento_codigo;
              TypeVFCONHECCTB.Con_Conhecimento_Serie         := c_msg.con_conhecimento_serie;
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Recalcula  := c_msg.con_vfreteconhec_recalcula;
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrreceita := c_msg.valorreceita;
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Fatreceita := c_msg.con_vfreteconhec_rateioreceita;
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Fatfrete   := c_msg.con_vfreteconhec_rateiofrete;
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratreceita := round((c_msg.valorreceita * c_msg.con_vfreteconhec_rateioreceita),2) ;
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratfrete   := round((c_msg.valorreceita * c_msg.con_vfreteconhec_rateiofrete ),2);
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratpegagio := round((c_msg.valorreceita * c_msg.con_vfreteconhec_rateioPedagio ),2);
              TypeVFCONHECCTB.Con_Vfreteconhecctb_Dtgravacao := c_msg.dtcadastro;
              TypeVFCONHECCTB.Glb_Centrocusto_Codigo         := c_msg.glb_centrocusto_codigo;
              TypeVFCONHECCTB.Glb_Centrocusto_Codigoc        := c_msg.glb_centrocusto_codigoc;
               
              vSomaRatFrete := vSomaRatFrete +  TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratfrete;
              VsomaRatReceita := VsomaRatReceita + TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratreceita;
              vSomaRatPedagio := vSomaRatPedagio + TypeVFCONHECCTB.Con_Vfreteconhecctb_Ratpegagio;
              
              insert into tdvadm.t_con_vfreteconhecctb
              values TypeVFCONHECCTB;
           End Loop; 

           If vSomaRatFrete = 0 Then
              insert into tdvadm.t_con_vfreteconhecctb
              values TypeVFCONHECCTB;
           Else
               If vSomaRatFrete <> TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrfrete Then
                 update tdvadm.t_con_vfreteconhecctb vfcc
                   set vfcc.con_vfreteconhecctb_ratfrete = vfcc.con_vfreteconhecctb_ratfrete + (TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrfrete - vSomaRatFrete )
                 where vfcc.con_valefrete_codigo     = TypeVFCONHECCTB.Con_Valefrete_Codigo
                   and vfcc.con_valefrete_serie      = TypeVFCONHECCTB.Con_Valefrete_Serie
                   and vfcc.glb_rota_codigovalefrete = TypeVFCONHECCTB.Glb_Rota_Codigovalefrete
                   and vfcc.con_valefrete_saque      = TypeVFCONHECCTB.Con_Valefrete_Saque
                   and vfcc.con_conhecimento_codigo = TypeVFCONHECCTB.con_conhecimento_codigo
                   and vfcc.con_conhecimento_serie = TypeVFCONHECCTB.con_conhecimento_serie
                   and vfcc.glb_rota_codigo = TypeVFCONHECCTB.glb_rota_codigo;
               End If;                     
      
               If vSomaRatPedagio <> TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrpedagio Then
                 update tdvadm.t_con_vfreteconhecctb vfcc
                   set vfcc.con_vfreteconhecctb_ratpegagio = vfcc.con_vfreteconhecctb_ratpegagio + (TypeVFCONHECCTB.Con_Vfreteconhecctb_Vlrpedagio - vSomaRatPedagio )
                 where vfcc.con_valefrete_codigo     = TypeVFCONHECCTB.Con_Valefrete_Codigo
                   and vfcc.con_valefrete_serie      = TypeVFCONHECCTB.Con_Valefrete_Serie
                   and vfcc.glb_rota_codigovalefrete = TypeVFCONHECCTB.Glb_Rota_Codigovalefrete
                   and vfcc.con_valefrete_saque      = TypeVFCONHECCTB.Con_Valefrete_Saque
                   and vfcc.con_conhecimento_codigo = TypeVFCONHECCTB.con_conhecimento_codigo
                   and vfcc.con_conhecimento_serie = TypeVFCONHECCTB.con_conhecimento_serie
                   and vfcc.glb_rota_codigo = TypeVFCONHECCTB.glb_rota_codigo;
               End If;                     
          End If;


      Exception
        When Others Then
          Insert Into DROPME 
          (A)
          Values 
          (substr('INTEGRASYNCHRO - ' ||P_VALE || '-' || P_SERIE  || '-' || P_ROTA || '-' || P_SAQUE,1,100));
          DBMS_OUTPUT.put_line('INTEGRASYNCHRO - ' ||P_VALE || '-' || P_SERIE  || '-' || P_ROTA || '-' || P_SAQUE||'-'||Sqlerrm);
        End;

    Else
      if P_ORIGEM is null then
          Update  t_Con_Vfretectb c
            Set c.con_vfretectb_id         = TypeVFCTB.Con_Vfretectb_Id,
                c.con_vfretectb_datactb    = TypeVFCTB.Con_Vfretectb_Datactb,
                C.CON_VFRETECTB_DATAFISCAL = TypeVFCTB.Con_Vfretectb_Datafiscal,
                c.con_vfretectb_qtdectrcex = TypeVFCTB.Con_Vfretectb_Qtdectrcex,
                c.con_vfretectb_qtdectrc   = TypeVFCTB.Con_Vfretectb_Qtdectrc
           Where c.con_conhecimento_codigo = P_VALE
             And c.con_conhecimento_serie  = P_SERIE
             And c.glb_rota_codigo         = P_ROTA
             And C.CON_VALEFRETE_SAQUE     = P_SAQUE
             and c.con_vfretectb_id is null
             and c.con_vfretectb_datafiscal is null;
      Elsif P_ORIGEM = 'CTB' then
          Update  t_Con_Vfretectb c
            Set c.con_vfretectb_id            = TypeVFCTB.Con_Vfretectb_Id,
                c.con_vfretectb_datactb       = TypeVFCTB.Con_Vfretectb_Datactb,
                c.con_vfretectb_qtdectrcex    = TypeVFCTB.Con_Vfretectb_Qtdectrcex,
                c.con_vfretectb_ctbexportacao = TypeVFCTB.Con_Vfretectb_Ctbexportacao,
                c.con_vfretectb_qtdectrc      = TypeVFCTB.Con_Vfretectb_Qtdectrc
           Where c.con_conhecimento_codigo = P_VALE
             And c.con_conhecimento_serie  = P_SERIE
             And c.glb_rota_codigo         = P_ROTA
             And C.CON_VALEFRETE_SAQUE     = P_SAQUE
             and c.con_vfretectb_id is null;
      Elsif P_ORIGEM = 'SYN' then              

          Update  t_Con_Vfretectb c
            Set C.CON_VFRETECTB_DATAFISCAL = TypeVFCTB.Con_Vfretectb_Datafiscal
           Where c.con_conhecimento_codigo = P_VALE
             And c.con_conhecimento_serie  = P_SERIE
             And c.glb_rota_codigo         = P_ROTA
             And C.CON_VALEFRETE_SAQUE     = P_SAQUE
             and c.con_vfretectb_datafiscal is null;
      End if;
    End If;

    if vContadordet > 0 then
        delete t_Con_Vfretectbdet c
        Where C.CON_CONHECIMENTO_CODIGO  = P_VALE
          And C.CON_CONHECIMENTO_SERIE   = P_SERIE
          And C.GLB_ROTA_CODIGO          = P_ROTA
          And C.CON_VALEFRETE_SAQUE      = P_SAQUE
          and c.con_vfretectb_id         = p_id;
        vContadordet := 0;
     End if;
     
     if vContadordet = 0 then
        TypeVFCTBDet.Con_Conhecimento_Codigo     := P_VALE;
        TypeVFCTBDet.Con_Conhecimento_Serie      := P_SERIE;
        TypeVFCTBDet.Glb_Rota_Codigo             := P_ROTA;
        TypeVFCTBDet.Con_Valefrete_Saque         := P_SAQUE;
        TypeVFCTBDet.Ctb_Movimento_Dtmovto       := P_DATA;
        TypeVFCTBDet.Ctb_Movimento_Documento     := P_DOCUMENTO;
        TypeVFCTBDet.Ctb_Movimento_Dsequencia    := P_SEQUENCIA;
        TypeVFCTBDet.Con_Vfretectbdet_Dtgravacao := sysdate;
        TypeVFCTBDet.Con_Vfretectbdet_Observacao := p_observacao;
        TypeVFCTBDet.Con_Vfretectb_Id            := P_ID;
        insert into t_con_vfretectbdet
        values TypeVFCTBDet;
     end if;        



   
    If NVL(P_COMMIT,'N') = 'S' Then
      Commit;
    End If;  
    
    
/*
ESTE E O SELECT PARA INSERIR A COCA
insert into T_CON_VFRETECTB
SELECT 30 DIA,
       substr(TRIM(F.FRT_CONJVEICULO_CODIGO) || TO_CHAR(R.RJF_MOVIMENTOOCOR_DTOCORR,'MM'),1,6) || substr(P.CAR_PROPRIETARIO_INPS_CODIGO,1,2) CODIGO,
       'A1' SERIE,
       '030' ROTA,
       '1' SAQUE,
       NULL ID,
       null REFCTB,
       TO_CHAR(R.RJF_MOVIMENTOOCOR_DTOCORR,'YYYYMM') REFFIS,
       null DATACTB,
       LAST_DAY(R.RJF_MOVIMENTOOCOR_DTOCORR) DATAFISCAL,
       R.RJF_MOVIMENTOOCOR_DTOCORR DATAEMISSAO,
       R.RJF_MOVIMENTOOCOR_DTOCORR DATACADASTRO,
       NULL,
       'N',
       'A',
       P.CAR_PROPRIETARIO_CGCCPFCODIGO CPF,
       P.CAR_PROPRIETARIO_INPS_CODIGO MATRICULA,
       P.CAR_PROPRIETARIO_CGCCPFCODIGO CPF,
       SUM((F.RJF_PAGAMENTOS_VLRPAGOPAL + F.RJF_PAGAMENTOS_VLRBONRET + F.RJF_PAGAMENTOS_VLRBONAPR + F.RJF_PAGAMENTOS_VLRBONDEB)  / PP.RJF_PROPRIETARIO_QTDEPROP) FRETE,
       0 ADIANTAMENTO,
       0 PEDAGIO,
       SUM((F.RJF_PAGAMENTOS_VLRPAGOPAL + F.RJF_PAGAMENTOS_VLRBONRET + F.RJF_PAGAMENTOS_VLRBONAPR + F.RJF_PAGAMENTOS_VLRBONDEB)  / PP.RJF_PROPRIETARIO_QTDEPROP) VALORLIQUIDO,
       SUM(R.RJF_MOVIMENTOOCOR_VALOR / PP.RJF_PROPRIETARIO_QTDEPROP) INSS,
       SUM(((F.RJF_PAGAMENTOS_VLRPAGOPAL + F.RJF_PAGAMENTOS_VLRBONRET + F.RJF_PAGAMENTOS_VLRBONAPR + F.RJF_PAGAMENTOS_VLRBONDEB)) / PP.RJF_PROPRIETARIO_QTDEPROP) * 0.005 SESTSENAT,
       0 IR,
       0 CONFINS,
       0 CSLL,
       0 PIS,
       0 MULTA,
       0 OUTROS,
       0 QTDECTRCEX,
       0 QTDECTRC,
       NULL,
       NULL,
       SYSDATE,
       NULL,
       NULL,
       '010',
       '61139432000172'
FROM T_RJF_MOVIMENTOOCOR R
     ,T_RJF_MOVIMENTO M
     ,T_RJF_PAGAMENTOS F
     ,V_RJF_PROPRIETARIO PP
     ,T_CAR_PROPRIETARIO P
WHERE TO_CHAR(R.RJF_MOVIMENTOOCOR_DTOCORR,'YYYY') = '2007'
   and R.RJF_MOVIMENTO_DTEMBARQUE = M.RJF_MOVIMENTO_DTEMBARQUE
  AND R.RJF_MOVIMENTO_CONTROLE = M.RJF_MOVIMENTO_CONTROLE
  AND ((F.RJF_PAGAMENTOS_VLRPAGOPAL + F.RJF_PAGAMENTOS_VLRBONRET + F.RJF_PAGAMENTOS_VLRBONAPR + F.RJF_PAGAMENTOS_VLRBONDEB)  / PP.RJF_PROPRIETARIO_QTDEPROP) > 0
  AND R.RJF_OCORRENCIA_CODIGO = '0016'
-- com retenc?o ---------------------
--  AND R.RJF_MOVIMENTOOCOR_VALOR > 0
-------------------------------------
-- sem retenc?o ---------------------
--  AND R.RJF_MOVIMENTOOCOR_VALOR = 0
-------------------------------------
  AND M.RJF_MOVIMENTO_CODPGTO2Q = F.RJF_PAGAMENTOS_CODIGO
  AND M.FRT_CONJVEICULO_CODIGO = F.FRT_CONJVEICULO_CODIGO
  AND PP.frt_veiculo_cliente = F.FRT_CONJVEICULO_CODIGO
  AND PP.RJF_PROPRIETARIO_CPFPROP = P.CAR_PROPRIETARIO_CGCCPFCODIGO (+)
--  AND SUBSTR(P.CAR_PROPRIETARIO_INPS_CODIGO,LENGTH(TRIM(P.CAR_PROPRIETARIO_INPS_CODIGO)),1) = F_DIGCONTROLEINSS(P.CAR_PROPRIETARIO_INPS_CODIGO)
--  AND P.CAR_PROPRIETARIO_INPS_CODIGO IS NOT NULL
GROUP BY TRIM(F.FRT_CONJVEICULO_CODIGO) || TO_CHAR(R.RJF_MOVIMENTOOCOR_DTOCORR,'MM'),
       TO_CHAR(R.RJF_MOVIMENTOOCOR_DTOCORR,'YYYYMM'),
       TO_CHAR(R.RJF_MOVIMENTOOCOR_DTOCORR,'YYYYMM'),
       LAST_DAY(R.RJF_MOVIMENTOOCOR_DTOCORR),
       LAST_DAY(R.RJF_MOVIMENTOOCOR_DTOCORR),
       R.RJF_MOVIMENTOOCOR_DTOCORR,
       R.RJF_MOVIMENTOOCOR_DTOCORR,
       P.CAR_PROPRIETARIO_CGCCPFCODIGO,
       P.CAR_PROPRIETARIO_INPS_CODIGO,
       P.CAR_PROPRIETARIO_CGCCPFCODIGO,
       TO_CHAR(R.RJF_MOVIMENTOOCOR_DTOCORR,'MM/YYYY')


*/ 

    
   
 End SP_LINK_ATUVALEFRETE;




PROCEDURE SP_LINK_ATUVALEFRETEHIST(P_REFERENCIA In TDVADM.T_CON_CONHECCTB.CON_CONHECCTB_REF%Type)
As                                

   P_DATAINI Date;
   P_DATAFIM Date;

  CURSOR c_VALEFRETE IS
    select T.con_conhecimento_codigo,
           T.con_conhecimento_serie,
           T.glb_rota_codigo,
           T.CON_VALEFRETE_SAQUE,
           T.CON_VALEFRETE_STATUS
      from tdvadm.T_CON_VALEFRETE T
  Where trunc(T.CON_VALEFRETE_DATACADASTRO) >= P_DATAINI
   AND trunc(T.CON_VALEFRETE_DATACADASTRO) <= P_DATAFIM
   and T.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL
   AND NVL(trim(T.GLB_TPMOTORISTA_CODIGO),'C') <> 'F'
--    and T.con_conhecimento_codigo = '910922'
   -- VERIFICA QUAIS CATEGORIAS NÃO PODEM ENTRAR
   AND INSTR(GET_CATVF,T.CON_CATVALEFRETE_CODIGO) = 0 
   AND INSTR(GET_SERIEVF,T.CON_CONHECIMENTO_SERIE)  > 0 
   and 0 = (select count(*)
            from tdvadm.t_con_vfretectb ct
            where ct.con_conhecimento_codigo = t.con_conhecimento_codigo
              and ct.con_conhecimento_serie = t.con_conhecimento_serie
              and ct.glb_rota_codigo = t.glb_rota_codigo
              and ct.con_valefrete_saque = t.con_valefrete_saque);

       
   TypeVALEFRETE c_VALEFRETE%Rowtype;

Begin
   
  who_called_me2;
  
  P_DATAINI := TO_DATE(P_REFERENCIA || '01','YYYYMMDD');
  P_DATAFIM := LAST_DAY(TO_DATE(P_REFERENCIA || '01','YYYYMMDD'));
  SET_CATVF(P_REFERENCIA);
  SET_SERIEVF(P_REFERENCIA);
  SET_TPDATAVF(P_REFERENCIA);
  SET_TPDATAVFEX(P_REFERENCIA);
  DBMS_OUTPUT.put_line(P_REFERENCIA);
-- 14/08/2018
  delete t_con_vfretectb ctb   where ctb.con_vfretectb_ref = P_REFERENCIA;
  delete tdvadm.t_con_vfreteconhecctb ct where to_char(ct.con_valefrete_dtcadastro,'YYYYMM') = P_REFERENCIA;
   vFreteConhecHist := 'S';

  commit;
  open c_VALEFRETE;
  LOOP
    FETCH c_VALEFRETE
      INTO TypeVALEFRETE;
    EXIT WHEN c_VALEFRETE%notfound;

    pkg_ctb_links.SP_LINK_ATUVALEFRETE(TypeVALEFRETE.Con_Conhecimento_Codigo,
                                       TypeVALEFRETE.Con_Conhecimento_Serie,
                                       TypeVALEFRETE.Glb_Rota_Codigo,
                                       TypeVALEFRETE.Con_Valefrete_Saque,
                                       null,
                                       Null,
                                       Null,
                                       null,
                                       null,
                                       P_REFERENCIA,
                                       null,
                                       null,
                                       'S');
                                          
  END LOOP;

  Commit;
  
  vFreteConhecHist := 'N'; 
End SP_LINK_ATUVALEFRETEHIST;


 Procedure SP_LINK_ATUDECONTO(P_REFERENCIA IN CHAR,
                              P_TITULO     IN TDVADM.T_CRP_TITRECEBER.CRP_TITRECEBER_NUMTITULO%TYPE,
                              P_ROTATIT    IN TDVADM.T_CRP_TITRECEBER.GLB_ROTA_CODIGO%TYPE,
                              P_SQTIT      IN TDVADM.T_CRP_TITRECEBER.CRP_TITRECEBER_SAQUE%TYPE,
                              P_COMMIT     In Char Default 'N')
 As

      TypeDescontoAnalitico tdvadm.t_crp_descontoctb%rowtype;
      TypeTitRecEvento      tdvadm.t_crp_titrecevento%rowtype;
      TypeConhecEvento      tdvadm.t_crp_conhecevento%rowtype;
      vSequencia number;

      CURSOR c_DESCONTOANALITICO IS
         SELECT TRE.CRP_TITRECEVENTO_SEQ,
                TRE.CRP_TITRECEBER_RATEIO,
                TRE.CRP_TITRECEVENTO_DOCRATEIO,
                TRE.CRP_TITRECEVENTO_CCUSTO,
                TRE.CRP_TITRECEVENTO_CRESP,
                TRE.CRP_TITRECEVENTO_VALOR,
                CEV.CON_CONHECIMENTO_CODIGO,
                CEV.CON_CONHECIMENTO_SERIE,
                CEV.GLB_ROTA_CODIGOCONHEC,
                CEV.CRP_CONHECEVENTO_VALOR,
                ev.glb_evento_codigo,
                tr.Crp_Titreceber_Dtbaixa,
                cl.glb_cliente_cgccpfcodigo,
                cl.glb_cliente_razaosocial,
                tre.glb_banco_numero,
                ev.ctb_pconta_codigocred,
                ev.ctb_historico_codigocred,
                ev.ctb_pconta_codigodeb,
                ev.ctb_historico_codigodeb,
                EV.GLB_TPEVENTO_CODIGOCTB,
                rt.glb_rota_fiscal
         FROM T_CRP_TITRECEVENTO TRE,
              T_CRP_TITRECEBER TR,
              T_CRP_CONHECEVENTO CEV,
              T_GLB_EVENTO EV,
              t_glb_cliente cl,
              t_glb_rota rt
         WHERE 0 = 0
           AND TR.GLB_ROTA_CODIGO          = P_ROTATIT
           AND TR.CRP_TITRECEBER_NUMTITULO = P_TITULO
           AND TR.CRP_TITRECEBER_SAQUE     = P_SQTIT
           and tr.glb_cliente_cgccpfcodigo = cl.glb_cliente_cgccpfcodigo
           AND TR.GLB_ROTA_CODIGO          = TRE.GLB_ROTA_CODIGO 
           AND TR.CRP_TITRECEBER_NUMTITULO = TRE.CRP_TITRECEBER_NUMTITULO 
           AND TR.CRP_TITRECEBER_SAQUE     = TRE.CRP_TITRECEBER_SAQUE
           AND TRE.CRP_TITRECEVENTO_AUTORIZADOR IS NOT NULL
           AND TRE.CRP_TITRECEVENTO_DATACTB IS NULL
           AND TRE.CRP_TITRECEVENTO_DATACANC IS NULL
           AND TRE.GLB_EVENTO_CODIGO = EV.GLB_EVENTO_CODIGO
           AND TRIM(EV.GLB_TPEVENTO_CODIGOCTB) IN ('D','I')
           AND TRE.GLB_ROTA_CODIGO          = CEV.GLB_ROTA_CODIGO (+)
           AND TRE.CRP_TITRECEBER_NUMTITULO = CEV.CRP_TITRECEBER_NUMTITULO (+)
           AND TRE.CRP_TITRECEBER_SAQUE     = CEV.CRP_TITRECEBER_SAQUE (+)
           AND TRE.CRP_TITRECEVENTO_SEQ     = CEV.CRP_TITRECEVENTO_SEQ (+)
           and cev.glb_rota_codigoconhec    = rt.glb_rota_codigo (+);
       TypeCursorDesconto    c_DESCONTOANALITICO%rowtype;       

      CURSOR c_FaturaExcel IS 
         SELECT FE.*
         FROM T_CRP_TITRECEBER TR,
              T_CON_FATURAEXCEL FE
         WHERE 0 = 0
           AND TR.CRP_TITRECEBER_NUMTITULO = P_TITULO
           AND TR.GLB_ROTA_CODIGO          = P_ROTATIT
           AND TR.CRP_TITRECEBER_SAQUE     = P_SQTIT
           AND FE.CON_FATURA_CODIGO        = TR.CON_FATURA_CODIGO
           AND FE.CON_FATURA_CICLO         = TR.CON_FATURA_CICLO
           AND FE.GLB_ROTA_CODIGOFILIALIMP = TR.GLB_ROTA_CODIGOFILIALIMP
           and FE.CON_FATURAEXCEL_GLOSA <> 0;

       TypeFaturaExcel       c_FaturaExcel%rowtype;

 begin

  -- testa se e uma fatura gerada pelo processo excel antes de gerar os descontos
  
      BEGIN
        SELECT tre.*
          INTO TypeTitRecEvento
        FROM T_CRP_TITRECEVENTO TRE,
             T_CRP_TITRECEBER TR,
             T_GLB_EVENTO EV
        WHERE 0 = 0
          AND TRE.GLB_ROTA_CODIGO          = TR.GLB_ROTA_CODIGO 
          AND TRE.CRP_TITRECEBER_NUMTITULO = TR.CRP_TITRECEBER_NUMTITULO 
          AND TRE.CRP_TITRECEBER_SAQUE     = TR.CRP_TITRECEBER_SAQUE
          AND 0 = (SELECT COUNT(*)
                   FROM T_CRP_CONHECEVENTO CEV
                   WHERE 0 = 0
                     AND CEV.CRP_TITRECEBER_NUMTITULO = TRE.CRP_TITRECEBER_NUMTITULO
                     AND CEV.GLB_ROTA_CODIGO          = TRE.GLB_ROTA_CODIGO
                     AND CEV.CRP_TITRECEBER_SAQUE     = TRE.CRP_TITRECEBER_SAQUE 
                     AND CEV.CRP_TITRECEVENTO_SEQ     = TRE.CRP_TITRECEVENTO_SEQ )
                     AND TRE.CRP_TITRECEVENTO_VALOR = (SELECT SUM(FE.CON_FATURAEXCEL_GLOSA)
                                                       FROM T_CON_FATURAEXCEL FE
                                                       WHERE 0 = 0
                                                         AND FE.CON_FATURA_CODIGO        = TR.CON_FATURA_CODIGO
                                                         AND FE.CON_FATURA_CICLO         = TR.CON_FATURA_CICLO
                                                         AND FE.GLB_ROTA_CODIGOFILIALIMP = TR.GLB_ROTA_CODIGOFILIALIMP)
          AND TRE.CRP_TITRECEVENTO_DATACTB IS NULL
          AND TRE.CRP_TITRECEVENTO_DATACANC IS NULL
          AND TRE.GLB_ROTA_CODIGO          = P_ROTATIT
          AND TRE.CRP_TITRECEBER_NUMTITULO = P_TITULO
          AND TRE.CRP_TITRECEBER_SAQUE     = P_SQTIT
          AND TRE.GLB_EVENTO_CODIGO = EV.GLB_EVENTO_CODIGO
          AND TRIM(EV.GLB_TPEVENTO_CODIGOCTB) IN ('D','I');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            TypeTitRecEvento.Crp_Titrecevento_Seq := 0;
        END ;
        
   IF TypeTitRecEvento.Crp_Titrecevento_Seq <> 0 Then
     -- cancela o desconto incial
      UPDATE T_CRP_TITRECEVENTO TRE
        SET TRE.CRP_TITRECEVENTO_DATACANC = SYSDATE,
            TRE.USU_USUARIO_CODIGOCANC = 'jsantos',
            TRE.CRP_TITRECEVENTO_OBSCANC = 'CANCELADO PARA GERAR RATEIO DOS CONHECIMENTOS'
      WHERE 0 = 0
        AND TRE.GLB_ROTA_CODIGO          = TypeTitRecEvento.Glb_Rota_Codigo
        AND TRE.CRP_TITRECEBER_NUMTITULO = TypeTitRecEvento.Crp_Titreceber_Numtitulo
        AND TRE.CRP_TITRECEBER_SAQUE     = TypeTitRecEvento.Crp_Titreceber_Saque
        AND TRE.CRP_TITRECEVENTO_SEQ     = TypeTitRecEvento.Crp_Titrecevento_Seq;
      -- PEGA A ULTIMA SEQUENCIA
      SELECT MAX(TRE.CRP_TITRECEVENTO_SEQ)
        INTO vSequencia
      FROM T_CRP_TITRECEVENTO TRE    
      WHERE 0 = 0
        AND TRE.GLB_ROTA_CODIGO          = P_ROTATIT
        AND TRE.CRP_TITRECEBER_NUMTITULO = P_TITULO
        AND TRE.CRP_TITRECEBER_SAQUE     = P_SQTIT;
       
      open c_FaturaExcel;
      LOOP
      FETCH c_FaturaExcel
        INTO TypeFaturaExcel;
       EXIT WHEN c_FaturaExcel%notfound;
          -- MUDA A SEQUENCIA PARA A PROXIMA
          vSequencia := vSequencia + 1;
          TypeTitRecEvento.Crp_Titrecevento_Seq       := vSequencia;
          TypeTitRecEvento.Crp_Titrecevento_Valor     := TypeFaturaExcel.Con_Faturaexcel_Glosa;
          TypeTitRecEvento.Crp_Titreceber_Rateio      := 'C';
          TypeTitRecEvento.Crp_Titrecevento_Docrateio := TypeFaturaExcel.Con_Conhecimento_Codigo || TypeFaturaExcel.Con_Conhecimento_Serie || TypeFaturaExcel.Glb_Rota_Codigo;
          
          TypeConhecEvento.Con_Conhecimento_Codigo  := TypeFaturaExcel.Con_Conhecimento_Codigo;
          TypeConhecEvento.Con_Conhecimento_Serie   := TypeFaturaExcel.Con_Conhecimento_Serie;
          TypeConhecEvento.Glb_Rota_Codigoconhec    := TypeFaturaExcel.Glb_Rota_Codigo;
          TypeConhecEvento.Con_Fatura_Codigo        := TypeFaturaExcel.Con_Fatura_Codigo;
          TypeConhecEvento.Con_Fatura_Ciclo         := TypeFaturaExcel.Con_Fatura_Ciclo;
          TypeConhecEvento.Glb_Rota_Codigo          := P_ROTATIT;
          TypeConhecEvento.Glb_Rota_Codigofilialimp := TypeFaturaExcel.Glb_Rota_Codigofilialimp;
          TypeConhecEvento.Crp_Titreceber_Numtitulo := P_TITULO;
          TypeConhecEvento.Crp_Titreceber_Saque     := P_SQTIT;
          TypeConhecEvento.Crp_Titrecevento_Seq     := vSequencia;
          TypeConhecEvento.Crp_Conhecevento_Valor   := TypeFaturaExcel.Con_Faturaexcel_Glosa;

          Insert Into tdvadm.t_crp_titrecevento
          Values TypeTitRecEvento;
          
          Insert Into tdvadm.t_crp_conhecevento
          Values TypeConhecEvento;

      END LOOP;           
   END IF;         

   open c_DESCONTOANALITICO;
   LOOP
     FETCH c_DESCONTOANALITICO
       INTO TypeCursorDesconto;
     EXIT WHEN c_DESCONTOANALITICO%notfound;
    
        TypeDescontoAnalitico.Crp_Titreceber_Numtitulo := P_TITULO;
        TypeDescontoAnalitico.Crp_Titrecevento_Seq     := TypeCursorDesconto.Crp_Titrecevento_Seq;
        TypeDescontoAnalitico.Glb_Rota_Codigo          := P_ROTATIT;
        TypeDescontoAnalitico.Con_Conhecimento_Codigo  := TypeCursorDesconto.Con_Conhecimento_Codigo;
        TypeDescontoAnalitico.Con_Conhecimento_Serie   := TypeCursorDesconto.Con_Conhecimento_Serie;
        TypeDescontoAnalitico.Glb_Rota_Codigoctrc      := TypeCursorDesconto.Glb_Rota_Codigoconhec;
        TypeDescontoAnalitico.Glb_Evento_Codigo        := TypeCursorDesconto.Glb_Evento_Codigo;
        TypeDescontoAnalitico.Crp_Descontoctb_Valor    := TypeCursorDesconto.CRP_CONHECEVENTO_VALOR;
        TypeDescontoAnalitico.Crp_Titreceber_Dtbaixa   := TypeCursorDesconto.Crp_Titreceber_Dtbaixa;
        
        IF TypeCursorDesconto.Glb_Tpevento_Codigoctb = 'D' Then
           TypeDescontoAnalitico.Glb_Rota_Codigoccusto := TypeCursorDesconto.Glb_Rota_Codigoconhec;
           TypeDescontoAnalitico.Glb_Rota_Codigocresp  := TypeCursorDesconto.Glb_Rota_Codigoconhec;
        Else
           TypeDescontoAnalitico.Glb_Rota_Codigoccusto := TypeCursorDesconto.GLB_ROTA_FISCAL;
           TypeDescontoAnalitico.Glb_Rota_Codigocresp  := TypeCursorDesconto.GLB_ROTA_FISCAL;
        end if;   
        
        TypeDescontoAnalitico.Crp_Descontoctb_Ref      := P_REFERENCIA;
        TypeDescontoAnalitico.Crp_Descontoctb_Gravacao := sysdate;
        TypeDescontoAnalitico.CRP_DESCONTOCTB_OBS      := TypeCursorDesconto.CRP_TITRECEBER_RATEIO  || '-' || TypeCursorDesconto.CRP_TITRECEVENTO_DOCRATEIO;
        TypeDescontoAnalitico.Glb_Cliente_Cgccpfcodigo := TypeCursorDesconto.Glb_Cliente_Cgccpfcodigo;
        TypeDescontoAnalitico.Glb_Cliente_Razaosocial  := TypeCursorDesconto.Glb_Cliente_Razaosocial;
        TypeDescontoAnalitico.Ctb_Pconta_Codigo        := SUBSTR(REPLACE(TypeCursorDesconto.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(TypeCursorDesconto.GLB_BANCO_NUMERO)),1,12);
        TypeDescontoAnalitico.Ctb_Pconta_Histdeb       := TypeCursorDesconto.Ctb_Historico_Codigodeb;
        TypeDescontoAnalitico.Glb_Banco_Numero         := TypeCursorDesconto.Glb_Banco_Numero;

--       TypeDescontoAnalitico.Crp_Descontoctb_Id       :=TypeCursorDesconto
--       TypeDescontoAnalitico.Crp_Descontoctb_Datactb  :=TypeCursorDesconto
       
        INSERT INTO TDVADM.T_CRP_DESCONTOCTB
        VALUES TypeDescontoAnalitico ;
                                          
   END LOOP;
  
     
 
   if P_COMMIT = 'S' Then
      commit;
   End if;
   
 End SP_LINK_ATUDECONTO;


PROCEDURE SP_LINK_ATUDECONTOHIST(P_REFERENCIA In TDVADM.T_CON_CONHECCTB.CON_CONHECCTB_REF%Type,
                                 P_CURSOR OUT T_CURSOR,
                                 P_STATUS OUT VARCHAR2,
                                 P_MESSAGE OUT VARCHAR2)
As                                

   vDATAINI Date;
   vDATAFIM Date;
   vAuxiliar number;

  CURSOR c_DESCONTO IS
      SELECT TR.GLB_ROTA_CODIGO,
             TR.CRP_TITRECEBER_NUMTITULO,
             TR.CRP_TITRECEBER_SAQUE,
             TR.CRP_TITRECEBER_DTBAIXA
      FROM T_CRP_TITRECEBER TR
      WHERE 0 = 0
--        AND TR.CRP_TITRECEBER_NUMTITULO = '030941'
        AND TRUNC(TR.CRP_TITRECEBER_DTBAIXA)     >= vDATAINI
        AND TRUNC(TR.CRP_TITRECEBER_DTBAIXA)     <= vDATAFIM
        AND TR.CRP_TITRECEBER_PAGO = 'S'
        AND 0 < (SELECT COUNT(*)
                 FROM T_CRP_TITRECEVENTO TRE,
                      T_GLB_EVENTO EV
                 WHERE 0 = 0
                   AND TRE.CRP_TITRECEBER_NUMTITULO = TR.CRP_TITRECEBER_NUMTITULO
                   AND TRE.CRP_TITRECEBER_SAQUE     = TR.CRP_TITRECEBER_SAQUE
                   AND TRE.GLB_ROTA_CODIGO          = TR.GLB_ROTA_CODIGO
                   AND TRE.GLB_EVENTO_CODIGO        = EV.GLB_EVENTO_CODIGO
                   AND TRE.CRP_TITRECEVENTO_AUTORIZADOR IS NOT NULL
                   AND TRE.CRP_TITRECEVENTO_DATACTB IS NULL
                   AND TRE.CRP_TITRECEVENTO_DATACANC IS NULL
                   AND TRUNC(TRE.CRP_TITRECEVENTO_DTEVENTO) <= VDATAFIM
                   AND TRIM(EV.GLB_TPEVENTO_CODIGOCTB) IN ('D','I'));


    

       
   Typedesconto c_DESCONTO%Rowtype;

Begin
   
  who_called_me2;
  
  P_STATUS := PKG_GLB_COMMON.Status_Nomal;
  P_MESSAGE := '';
  
  vDATAINI := TO_DATE(TO_DATE(P_REFERENCIA || '01','YYYYMMDD'),'DD/MM/YYYY');
  vDATAFIM := LAST_DAY(vDATAINI);

  select count(*)
    into vAuxiliar
  from tdvadm.t_crp_descontoctb ctb
  where 0 = 0
    and ctb.crp_descontoctb_ref = P_REFERENCIA
    and ctb.crp_descontoctb_id is not null;
    
  if vAuxiliar <> 0 Then
     P_STATUS := PKG_GLB_COMMON.Status_Warning;
     P_MESSAGE := 'Referencia ' || P_REFERENCIA || ' já fechada. Rodando Cursor com os dados contabilizados';
  End if;
       
  if P_STATUS = PKG_GLB_COMMON.Status_Nomal Then
      delete tdvadm.t_crp_descontoctb ctb
      where ctb.crp_descontoctb_ref = P_REFERENCIA
        and ctb.crp_descontoctb_id is null;
      commit;

      open c_DESCONTO;
      LOOP
        FETCH c_DESCONTO
          INTO Typedesconto;
        EXIT WHEN c_DESCONTO%notfound;

        pkg_ctb_links.SP_LINK_ATUDECONTO(P_REFERENCIA,
                                         Typedesconto.Crp_Titreceber_Numtitulo,
                                         Typedesconto.Glb_Rota_Codigo,
                                         Typedesconto.Crp_Titreceber_Saque, 
                                         'S');
                                              
      END LOOP;
   End if;
   
   OPEN P_CURSOR FOR 
     select x.crp_titreceber_numtitulo TIT,
       x.crp_titrecevento_seq SEQ,
       x.glb_cliente_razaosocial CLI,
       to_char(x.crp_titreceber_dtbaixa,'dd') DIA,
       x.glb_rota_codigoccusto CCUSTO,
       x.glb_rota_codigocresp	CRESP,
       x.ctb_pconta_codigo PCONTA,
       x.ctb_pconta_histdeb HIST,
       x.glb_banco_numero BANCO,
       sum(x.crp_descontoctb_valor) VALOR,
       x.crp_descontoctb_id ctbid,
       x.CRP_DESCONTOCTB_DTCTB DTCTB
from t_crp_descontoctb x
where x.crp_descontoctb_ref = P_REFERENCIA
group by x.crp_titreceber_numtitulo,
         x.crp_titrecevento_seq,
         x.glb_cliente_razaosocial,
         to_char(x.crp_titreceber_dtbaixa,'dd'),
         x.glb_rota_codigoccusto,
         x.glb_rota_codigocresp,
         x.ctb_pconta_codigo,
         x.ctb_pconta_histdeb,
         x.glb_banco_numero,
         x.crp_descontoctb_id ,
         x.CRP_DESCONTOCTB_DTCTB
         
order by x.crp_titreceber_numtitulo,x.crp_titrecevento_seq;

  
  
--  Commit;
End SP_LINK_ATUDECONTOHIST;


function FN_GET_DADOSCTENFSN(pOrigem         tdvadm.t_ctb_movimento.ctb_movimento_origem%type,
                             pDataLancamento tdvadm.t_ctb_movimento.ctb_movimento_dtmovto%type,
                             pHistorico      tdvadm.t_ctb_movimento.ctb_movimento_descricao%type,
                             pVerba          tdvadm.t_con_calcconhecimento.slf_reccust_codigo%type)
      return tdvadm.t_con_calcconhecimento.con_calcviagem_valor%type
As
  vCte  tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
  vRota tdvadm.t_con_conhecimento.glb_rota_codigo%type;
  vRetorno tdvadm.t_con_calcconhecimento.con_calcviagem_valor%type;
Begin
    Begin
        If pOrigem in ('1','A','9') Then
           If instr(pHistorico,'ICMS,') = 0 and 
              instr(pHistorico,'ICMS A,') = 0 and 
              instr(pHistorico,',FAT:') = 0 and 
              instr(pHistorico,'RET.ISS') = 0 and 
              instr(pHistorico,',ISS A,') = 0 Then
              
              If substr(pHistorico,1,3) = 'CTe' Then
                 vCte  := substr(pHistorico,5,6);
                 vRota := substr(pHistorico,12,3);
              ElsIf substr(pHistorico,1,3) = 'NFS' Then
                 vCte  := substr(pHistorico,20,6);
                 vRota := substr(pHistorico,27,3);
              Else
                 return null;   
              End If;          
              
              select cc.con_calcviagem_valor
                 into vRetorno
              from tdvadm.t_con_calcconhecimento cc
              where cc.con_conhecimento_codigo = vCte
                and cc.glb_rota_codigo = vRota
                and cc.con_conhecimento_dtembarque = pDataLancamento
                and cc.slf_reccust_codigo = pVerba;
           End If;
        Else
          return null;
        End If;
    exception
      When OTHERS Then
        vRetorno := null;
    End;

    return vRetorno;

  
End  FN_GET_DADOSCTENFSN;                           

function FN_GET_DADOSCTENFST(pOrigem         tdvadm.t_ctb_movimento.ctb_movimento_origem%type,
                             pDataLancamento tdvadm.t_ctb_movimento.ctb_movimento_dtmovto%type,
                             pHistorico      tdvadm.t_ctb_movimento.ctb_movimento_descricao%type,
                             pTipoRetorno    char)
                             -- pTipoRetorno : TC Tipo de Carga
                             --                TV Tipo de Veiculo
                             --                TCC Tipo Carga da Coleta
      return varchar2
As
  vCte  tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
  vRota tdvadm.t_con_conhecimento.glb_rota_codigo%type;
  vRetorno varchar2(100);
Begin
    Begin
        If pOrigem in ('1','A','9') Then
           If instr(pHistorico,'ICMS,') = 0 and 
              instr(pHistorico,'ICMS A,') = 0 and 
              instr(pHistorico,',FAT:') = 0 and 
              instr(pHistorico,'RET.ISS') = 0 and 
              instr(pHistorico,',ISS A,') = 0 Then

              If substr(pHistorico,1,3) = 'CTe' Then
                 vCte  := substr(pHistorico,5,6);
                 vRota := substr(pHistorico,12,3);
              ElsIf substr(pHistorico,1,3) = 'NFS' Then
                 vCte  := substr(pHistorico,20,6);
                 vRota := substr(pHistorico,27,3);
              Else
                 return null;   
              End If;          
              
              If pTipoRetorno = 'TC' Then
                 
                 select trim(ta.fcf_tpcarga_codigo) || trim(sf.fcf_tpcarga_codigo)
                    into vRetorno
                 from tdvadm.t_con_conhecimento c,
                      tdvadm.t_slf_tabela ta,
                      tdvadm.t_slf_solfrete sf
                 where c.con_conhecimento_codigo = vCte
                   and c.glb_rota_codigo = vRota
                   and c.con_conhecimento_dtembarque = pDataLancamento
                   and c.slf_solfrete_codigo = sf.slf_solfrete_codigo (+)
                   and c.slf_solfrete_saque = sf.slf_solfrete_saque (+)
                   and c.slf_tabela_codigo = ta.slf_tabela_codigo (+)
                   and c.slf_tabela_saque = ta.slf_tabela_saque (+);

                 select tc.fcf_tpcarga_descricao
                   into vRetorno
                 from tdvadm.t_fcf_tpcarga tc
                 where tc.fcf_tpcarga_codigo = rpad(vRetorno,3);
              ElsIf pTipoRetorno = 'TV' Then
                 select trim(ta.fcf_tpveiculo_codigo) || trim(sf.fcf_tpveiculo_codigo)
                    into vRetorno
                 from tdvadm.t_con_conhecimento c,
                      tdvadm.t_slf_tabela ta,
                      tdvadm.t_slf_solfrete sf
                 where c.con_conhecimento_codigo = vCte
                   and c.glb_rota_codigo = vRota
                   and c.con_conhecimento_dtembarque = pDataLancamento
                   and c.slf_solfrete_codigo = sf.slf_solfrete_codigo (+)
                   and c.slf_solfrete_saque = sf.slf_solfrete_saque (+)
                   and c.slf_tabela_codigo = ta.slf_tabela_codigo (+)
                   and c.slf_tabela_saque = ta.slf_tabela_saque (+);

                 select tc.fcf_tpveiculo_descricao
                   into vRetorno
                 from tdvadm.t_fcf_tpveiculo tc
                 where tc.fcf_tpveiculo_codigo = rpad(vRetorno,3);
              ElsIf pTipoRetorno = 'TCC' Then
                 select co.fcf_tpcarga_codigo
                   into vRetorno
                 from tdvadm.t_con_conhecimento c,
                      tdvadm.t_arm_coleta co
                 where c.con_conhecimento_codigo = vCte
                   and c.glb_rota_codigo = vRota
                   and c.con_conhecimento_dtembarque = pDataLancamento
                   and c.arm_coleta_ncompra = co.arm_coleta_ncompra
                   and c.arm_coleta_ciclo = co.arm_coleta_ciclo;

                 select tc.fcf_tpcarga_descricao
                   into vRetorno
                 from tdvadm.t_fcf_tpcarga tc
                 where tc.fcf_tpcarga_codigo = rpad(vRetorno,3);
              End If;
           End If;
        Else
          return null;
        End If;
    exception
      When OTHERS Then
        vRetorno := null;
    End;
    
    return vRetorno;
  
End  FN_GET_DADOSCTENFST;                           



/*

SELECT T.CRP_TITRECEBER_NUMTITULO                                                                                    TIT,
       TE.CRP_TITRECEVENTO_SEQ                                                                                       SEQ,
       T.GLB_ROTA_CODIGO
       CL.GLB_CLIENTE_RAZAOSOCIAL                                                                                    CLI,
       SUBSTR(TRUNC(T.CRP_TITRECEBER_DTBAIXA),1,2)                                                                   DIA,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL)                                CCUSTO,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL)  CRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12)  PCONTA,
       E.CTB_HISTORICO_CODIGODEB                                                                                     HIST,
       NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO)                                                                   BANCO,
       sum(decode(fn_vrfcrpconhec(TE.CRP_TITRECEBER_NUMTITULO,TE.CRP_TITRECEBER_SAQUE,TE.CRP_TITRECEVENTO_SEQ,TE.GLB_ROTA_CODIGO),0,te.crp_titrecevento_valor,CE.CRP_CONHECEVENTO_VALOR))           VALOR

SELECT * FROM T_CRP_DESCONTOCTB
 
SELECT * FROM T_GLB_BANCO B WHERE B.

SELECT * FROM T_CON_CONHECCTB
-- ORIGINAL
CREATE TABLE T_CRP_DESCONTOCTB
AS
SELECT T.CRP_TITRECEBER_NUMTITULO,
       TE.CRP_TITRECEVENTO_SEQ,
       T.GLB_ROTA_CODIGO,
       CL.GLB_CLIENTE_RAZAOSOCIAL,
       TRUNC(T.CRP_TITRECEBER_DTBAIXA) CRP_TITRECEBER_DTBAIXA,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL)                                GLB_ROTA_CODIGOCCUSTO,
       DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL)  GLB_ROTA_CODIGOCRESP,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12)  CTB_PCONTA_CODIGO,
       E.CTB_HISTORICO_CODIGODEB                                                                                     CTB_PCONTA_HISTDEB,
       NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO)                                                                   GLB_BANCO_NUMERO,
       (decode(fn_vrfcrpconhec(TE.CRP_TITRECEBER_NUMTITULO,TE.CRP_TITRECEBER_SAQUE,TE.CRP_TITRECEVENTO_SEQ,TE.GLB_ROTA_CODIGO),0,te.crp_titrecevento_valor,CE.CRP_CONHECEVENTO_VALOR))           VALOR
  FROM T_CRP_TITRECEBER T,
       T_CRP_TITRECEVENTO TE,
       T_CRP_CONHECEVENTO CE,
       T_CON_CONHECIMENTO C,
       T_GLB_EVENTO E,
       T_GLB_ROTA R,
       T_GLB_CLIENTE CL
WHERE T.GLB_CLIENTE_CGCCPFCODIGO           = CL.GLB_CLIENTE_CGCCPFCODIGO(+)
   AND TE.GLB_EVENTO_CODIGO                 = E.GLB_EVENTO_CODIGO(+)
   AND TE.CRP_TITRECEBER_NUMTITULO          = T.CRP_TITRECEBER_NUMTITULO
   AND TE.CRP_TITRECEBER_SAQUE              = T.CRP_TITRECEBER_SAQUE
   AND TE.GLB_ROTA_CODIGO                   = T.GLB_ROTA_CODIGO(+)
   AND TE.CRP_TITRECEBER_NUMTITULO          = CE.CRP_TITRECEBER_NUMTITULO(+)
   AND TE.CRP_TITRECEBER_SAQUE              = CE.CRP_TITRECEBER_SAQUE(+)
   AND TE.CRP_TITRECEVENTO_SEQ              = CE.CRP_TITRECEVENTO_SEQ(+)
   AND TE.GLB_ROTA_CODIGO                   = CE.GLB_ROTA_CODIGO(+)
   AND CE.CON_CONHECIMENTO_CODIGO           = C.CON_CONHECIMENTO_CODIGO(+)
   AND CE.CON_CONHECIMENTO_SERIE            = C.CON_CONHECIMENTO_SERIE(+)
   AND CE.GLB_ROTA_CODIGOCONHEC             = C.GLB_ROTA_CODIGO(+)
   AND C.GLB_ROTA_CODIGO                    = R.GLB_ROTA_CODIGO(+)
   AND TE.CRP_TITRECEVENTO_AUTORIZADOR     IS NOT NULL
   AND TE.CRP_TITRECEVENTO_DATACANC        IS NULL
-- AND TE.CRP_TITRECEVENTO_DATACTB         IS NULL
--   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     >= VT_DTINI
--   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     <= VT_DTFIM
--   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= VT_DTFIM
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     >= '01/03/2013'
   AND TRUNC(T.CRP_TITRECEBER_DTBAIXA)     <= '31/03/2013'
   AND TRUNC(TE.CRP_TITRECEVENTO_DTEVENTO) <= '31/03/2013'
   AND TRIM(E.GLB_TPEVENTO_CODIGOCTB)      IN ('D','I')
   AND T.CRP_TITRECEBER_PAGO = 'S'
   AND decode(fn_vrfcrpconhec(TE.CRP_TITRECEBER_NUMTITULO,TE.CRP_TITRECEBER_SAQUE,TE.CRP_TITRECEVENTO_SEQ,TE.GLB_ROTA_CODIGO),0,te.crp_titrecevento_valor,CE.CRP_CONHECEVENTO_VALOR) <> 0
GROUP BY T.CRP_TITRECEBER_NUMTITULO,
          TE.CRP_TITRECEVENTO_SEQ,
          CL.GLB_CLIENTE_RAZAOSOCIAL,
          SUBSTR(TRUNC(T.CRP_TITRECEBER_DTBAIXA),1,2),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',C.GLB_ROTA_CODIGO,R.GLB_ROTA_FISCAL),
          DECODE(TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL),
          SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12),
          E.CTB_HISTORICO_CODIGODEB,
          NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO)
 ORDER BY SUBSTR(TRUNC(T.CRP_TITRECEBER_DTBAIXA),1,2),
          DECODE (TRIM(E.GLB_TPEVENTO_CODIGOCTB),'D',NVL(C.GLB_ROTA_CODIGORECEITA,C.GLB_ROTA_CODIGO),R.GLB_ROTA_FISCAL),
          SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO))),1,12),
          E.CTB_HISTORICO_CODIGODEB,
          NVL(TE.GLB_BANCO_NUMERO,T.GLB_BANCO_NUMERO);
          
          
          select * from t_crp_titrecevento


*/





Begin
  
  vCriticaProcess := empty_clob();




End PKG_CTB_LINKS;
/
