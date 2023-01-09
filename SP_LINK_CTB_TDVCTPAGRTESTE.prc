CREATE OR REPLACE PROCEDURE SP_LINK_CTB_TDVCTPAGR(P_MES  IN CHAR,
                                                  P_ANO  IN CHAR,
                                                  P_DIA  IN CHAR,
                                                  P_MODO IN CHAR,
                                                  P_ID   IN CHAR)

AS

/* --------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : Contabilidade
 * PROGRAMA     : SP_LINK_CTB_TDVVFRETE.SQL
 * ANALISTA     : Roberto Pariz
 * PROGRAMADOR  : Roberto Pariz
 * CRIACAO      : 14-02-2007
 * BANCO        : ORACLE
 * ALIMENTA     : T_CTB_MOVIMENTO
 * SIGLAS       : CTB,CON,GLB
 *              :
 * ALTERACAO    : 15-05-2007 - Versao (3) - Roberto Pariz
 *              :
 *              : 03-05-2012 - Passou a utilizar a procedure PKG_GLB_COMMON.SET_SISTEMAFECHAMENTO para
 *              :              notificar o fechamento contabil para os outros modulos so Sistema TDV - Roberto Pariz
 *              :
 *              : 14-12-2015 - PASSOU A VERIFICAR E EXISTENCIA DE FORNECEDORES COM NOMES DIVERGENTES - ROBERTO PARIZ.
 *              :
 *              : 11-01-2016 - retirei as contas de prefeitura e impostos do PARDAL para nao comparar os nomes - Sirlano Dumond.
 *              :
 *              : 10-02-2016 - Coloquei is inidicadores de looping no P_ID dos registros - Roberto Pariz.
 *              :
 *              : 12-09-2016 - Foi alterado para  prever valores nulos e trasforma-los em zeros. - Roberto Pariz                                                                                    
 *              :
 *              : 06-10-2021 - Sirlano 
 *              :              mplementado a Rotina que muda os borderos para Cheque, para melhorar a contabilização
 *              :              tdvadm.pkg_cpg_contaspagar.sp_MudaBorderoPCheque
 *              :
 * COMENTARIOS  : Link entre o Contas a Pagar e a Contabilidade.
 * ATUALIZA     :
 * --------------------------------------------------------------------------------------------------------------------
 */

 VT_PROCNAME  CHAR(25) := 'SP_LINK_CTB_TDVCTPAGR';
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
-- VT_NUMTIT    INTEGER;
 VT_FORN      CHAR(20);
 VT_CONTROLE  INTEGER;
 VT_HTC       CHAR(3);
 VT_HDC       CHAR(50);
 VT_CCRED     CHAR(12);
 VT_DATA      DATE;
 VT_USUARIO   CHAR(20);
 VT_STATUS    CHAR(1);
 VT_ERROR     CHAR(100);
 VT_REF       CHAR(6);
 VT_ORG       CHAR(1) := '3'; -- INDICADOR DE ORIGEM DO LANÇAMENTO NA CONTABILIDADE (3) CONTAS A PAGAR

 -- CURSOR C_TIT_LANCADOS (Titulos Lancados)

 CURSOR C_TIT_LANCADOS IS
SELECT T.GLB_FORNECEDOR_CGCCPF   FORN,
       T.CPG_TITULOS_COMPETENCIA DATA,
       cbt.cpg_chequebanco_numero cheque,
       T.CPG_TITULOS_NUMTIT      NUMTIT,
       TCC.CPG_DESPESAS_CODIGO   DESP,
       TCC.GLB_ROTA_CODIGOCCUSTO CCUSTO,
       REPLACE(D.CTB_PCONTA_CODIGODEB,'***',TCC.GLB_ROTA_CODIGOCCUSTO)  CDEB,
       REPLACE(D.CTB_PCONTA_CODIGOCRED,'***',TCC.GLB_ROTA_CODIGOCCUSTO) CCRED,
       D.CTB_HISTORICO_CODIGODEB  HTD,
       DECODE(D.CTB_HISTORICO_CODIGODEB,'993',F.GLB_FORNECEDOR_NOME,(SELECT SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(HD.CTB_HISTORICO_DESCRICAO,'#TIT#',TRIM(lpad(T.CPG_TITULOS_NUMTIT,9,'0'))),'#VC#',NULL),'#NOME#',F.GLB_FORNECEDOR_NOME),'#DOC#',TRIM(lpad(T.CPG_TITULOS_NUMTIT,9,'0'))),'#CHQ#','CH-' || lpad(cbt.cpg_chequebanco_numero,6,'0')),'CH- ',''),1,50)
                                                                       FROM TDVADM.T_CTB_HISTORICO HD
                                                                      WHERE HD.CTB_HISTORICO_CODIGO = D.CTB_HISTORICO_CODIGODEB)) HDD,
       D.CTB_HISTORICO_CODIGOCRED HTC,
       DECODE(D.CTB_HISTORICO_CODIGOCRED,'993',F.GLB_FORNECEDOR_NOME,(SELECT SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(HC.CTB_HISTORICO_DESCRICAO,'#TIT#',TRIM(lpad(T.CPG_TITULOS_NUMTIT,9,'0'))),'#VC#',NULL),'#NOME#',F.GLB_FORNECEDOR_NOME),'#DOC#',TRIM(lpad(T.CPG_TITULOS_NUMTIT,9,'0'))),'#CHQ#','CH-' || lpad(cbt.cpg_chequebanco_numero,6,'0')),'CH- ',''),1,50)
                                                                       FROM TDVADM.T_CTB_HISTORICO HC
                                                                       WHERE HC.CTB_HISTORICO_CODIGO = D.CTB_HISTORICO_CODIGOCRED)) HDC,
       TCC.CPG_TITULOCCUSTOVALOR VALOR,
       F.GLB_FORNECEDOR_NOME     FNOME,
       TCC.GLB_CENTROCUSTO_CODIGO,
       TCC.GLB_CENTROCUSTO_CODIGOC
  FROM tdvadm.T_GLB_FORNECEDOR   F,
       tdvadm.T_CPG_DESPESAS     D,
       tdvadm.T_CPG_TITULOS      T,
       tdvadm.T_CPG_TITULOCCUSTO TCC,
       tdvadm.t_cpg_chequebancoparcela cbt
 WHERE T. CPG_TITULOS_PREVISAO  = 'N'
   and t.cpg_titulos_numtit = cbt.cpg_titulos_numtit (+)
   and t.glb_fornecedor_cgccpf = cbt.glb_fornecedor_cgccpf (+) 
   AND NVL(CPG_TITULOS_TIPOTITULO,'#')  <> 'I'
   AND D.CTB_PCONTA_CODIGODEB   IS NOT NULL
   AND T.GLB_FORNECEDOR_CGCCPF  = F.GLB_FORNECEDOR_CGCCPF(+)
   AND TCC.CPG_DESPESAS_CODIGO  = D.CPG_DESPESAS_CODIGO
   AND T.CPG_TITULOS_NUMTIT     = TCC.CPG_TITULOS_NUMTIT (+)
   AND T.GLB_ROTA_CODIGOEMPRESA = TCC.GLB_ROTA_CODIGOEMPRESA (+)
   AND T.GLB_FORNECEDOR_CGCCPF  = TCC.GLB_FORNECEDOR_CGCCPF  (+)
   AND T.CPG_TITULOS_COMPETENCIA >= VT_DTINI
   AND T.CPG_TITULOS_COMPETENCIA <= VT_DTFIM
 ORDER BY T.GLB_FORNECEDOR_CGCCPF,
          T.CPG_TITULOS_COMPETENCIA,
          T.CPG_TITULOS_NUMTIT,
          TCC.CPG_DESPESAS_CODIGO,
          TCC.GLB_ROTA_CODIGOCCUSTO;

 --  CURSOR C_IMPOSTOS (Impostos Retidos no Lancamento dos Titulos)

 CURSOR C_IMPOSTOS IS
SELECT DISTINCT
       T.GLB_FORNECEDOR_CGCCPF    FORN,
       T.CPG_TITULOS_COMPETENCIA  DATA,
       T.CPG_TITULOS_NUMTIT       NUMTIT,
       I.CPG_IMPOSTOCDEBITO       CDEB,
       I.CPG_IMPOSTOCCREDITO      CCRED,
       I.CPG_IMPOSTOHISTDEBITO    HTD,
       SUBSTR(TRIM(REPLACE((SELECT HD.CTB_HISTORICO_DESCRICAO FROM TDVADM.T_CTB_HISTORICO HD WHERE CTB_HISTORICO_CODIGO = I.CPG_IMPOSTOHISTDEBITO),'#TIT#',lpad(TI.CPG_TITULOS_NUMTIT,9,'0')))||' '||F.GLB_FORNECEDOR_NOME,1,50) HDD,
       I.CPG_IMPOSTOHISTCREDITO   HTC,
       SUBSTR(TRIM(REPLACE((SELECT HC.CTB_HISTORICO_DESCRICAO FROM TDVADM.T_CTB_HISTORICO HC WHERE CTB_HISTORICO_CODIGO = I.CPG_IMPOSTOHISTCREDITO),'#TIT#',lpad(TI.CPG_TITULOS_NUMTIT,9,'0')))||' '||F.GLB_FORNECEDOR_NOME,1,50) HDC,
       TI.CPG_TITULOIMPOSTOSVALOR VALOR
  FROM TDVADM.T_CPG_TITULOS T,
       TDVADM.T_CPG_TITULOIMPOSTOS TI,
       TDVADM.T_CPG_IMPOSTO I,
       TDVADM.T_GLB_FORNECEDOR F
 WHERE TI.GLB_FORNECEDOR_CGCCPF  = F.GLB_FORNECEDOR_CGCCPF(+)
   AND TI.CPG_IMPOSTO_CODIGO     = I.CPG_IMPOSTO_CODIGO
   AND TI.CPG_TITULOS_NUMTIT     = T.CPG_TITULOS_NUMTIT
   AND TI.GLB_FORNECEDOR_CGCCPF  = T.GLB_FORNECEDOR_CGCCPF
   AND TI.GLB_ROTA_CODIGOEMPRESA = T.GLB_ROTA_CODIGOEMPRESA
   AND T. CPG_TITULOS_PREVISAO  = 'N'
   AND NVL(CPG_TITULOS_TIPOTITULO,'#')  <> 'I'
   AND T.CPG_TITULOS_COMPETENCIA >= VT_DTINI
   AND T.CPG_TITULOS_COMPETENCIA <= VT_DTFIM
 ORDER BY T.GLB_FORNECEDOR_CGCCPF,
          LAST_DAY(T.CPG_TITULOS_COMPETENCIA),
          T.CPG_TITULOS_NUMTIT;

--  CURSOR C_JUROS (JUROS)

 CURSOR C_JUROS IS

-- JUROS PAGAMENTOS 

SELECT
  TVE.GLB_FORNECEDOR_CGCCPF FORN,
  TVE.GPG_TITULOEVENTO_DTEVENTO          DATA,
  TVE.CPG_TITULOS_NUMTIT                 NUMTIT,
  DECODE(FRN.GLB_FORNECEDOR_CTBPCONTA,NULL,EVE.CTB_PCONTA_CODIGODEB,REPLACE(EVE.CTB_PCONTA_CODIGODEB,'FFFFF',FRN.GLB_FORNECEDOR_CTBPCONTA)) CDEB,
  REPLACE(EVE.CTB_PCONTA_CODIGOCRED,'BBBBB','00'||(SELECT TRIM(TVE1.GLB_BANCO_NUMERO)
                                                   FROM TDVADM.T_CPG_TITULOEVENTO TVE1,
                                                        TDVADM.T_GLB_EVENTO EVE1
                                                   WHERE TVE1.CPG_TITULOS_NUMTIT         = TVE.CPG_TITULOS_NUMTIT
                                                     AND TVE1.GPG_TITULOEVENTO_SEQ       = TVE.GPG_TITULOEVENTO_SEQ
                                                     AND TVE1.GLB_FORNECEDOR_CGCCPF      = TVE.GLB_FORNECEDOR_CGCCPF
                                                     AND TVE1.GLB_EVENTO_CODIGO          = EVE1.GLB_EVENTO_CODIGO
                                                     AND EVE1.GLB_TPEVENTO_CODIGO        = 'P'
                                                     AND TVE1.GPG_TITULOEVENTO_DTEVENTO >= VT_DTINI
                                                     AND TVE1.GPG_TITULOEVENTO_DTEVENTO <= VT_DTFIM))             CCRED,
  EVE.CTB_HISTORICO_CODIGODEB            HTD,
  SUBSTR(TRIM(REPLACE((SELECT HD.CTB_HISTORICO_DESCRICAO
                         FROM TDVADM.T_CTB_HISTORICO HD
                        WHERE CTB_HISTORICO_CODIGO = EVE.CTB_HISTORICO_CODIGODEB),'#TIT#',lpad(TVE.CPG_TITULOS_NUMTIT,9,'0')))||' '||FRN.GLB_FORNECEDOR_NOME,1,50) HDD,
  EVE.CTB_HISTORICO_CODIGOCRED           HTC,
  SUBSTR(TRIM(REPLACE((SELECT HC.CTB_HISTORICO_DESCRICAO
                         FROM TDVADM.T_CTB_HISTORICO HC
                        WHERE CTB_HISTORICO_CODIGO = EVE.CTB_HISTORICO_CODIGOCRED),'#DOC#',(SELECT TRIM(TVE1.CPG_TITULOEVENTO_NRODOC)
                                                                                              FROM TDVADM.T_CPG_TITULOEVENTO TVE1,
                                                                                                   TDVADM.T_GLB_EVENTO EVE1
                                                                                             WHERE TVE1.CPG_TITULOS_NUMTIT         = TVE.CPG_TITULOS_NUMTIT
                                                                                               AND TVE1.GPG_TITULOEVENTO_SEQ       = TVE.GPG_TITULOEVENTO_SEQ
                                                                                               AND TVE1.GLB_FORNECEDOR_CGCCPF      = TVE.GLB_FORNECEDOR_CGCCPF
                                                                                               AND TVE1.GLB_EVENTO_CODIGO          = EVE1.GLB_EVENTO_CODIGO
                                                                                               AND EVE1.GLB_TPEVENTO_CODIGO        = 'P'
                                                                                               AND TVE1.GPG_TITULOEVENTO_DTEVENTO >= VT_DTINI
                                                                                               AND TVE1.GPG_TITULOEVENTO_DTEVENTO <= VT_DTFIM)))||' '||FRN.GLB_FORNECEDOR_NOME,1,50) HDC,
  TVE.GLB_ROTA_CODIGOEMPRESA ,
  TVE.CPG_TITULOEVENTO_VALOR VALOR,
  '    ' glb_centocusto_codigo,
  '    ' glb_centocusto_codigoc
FROM
  TDVADM.T_CPG_TITULOS TIT,
  TDVADM.T_CPG_TITULOEVENTO TVE,
  TDVADM.T_GLB_EVENTO EVE,
  TDVADM.T_GLB_FORNECEDOR FRN
WHERE FRN.GLB_FORNECEDOR_CGCCPF  = TIT.GLB_FORNECEDOR_CGCCPF
  AND TIT.CPG_TITULOS_NUMTIT     = TVE.CPG_TITULOS_NUMTIT (+)
  AND TIT.GLB_ROTA_CODIGOEMPRESA = TVE.GLB_ROTA_CODIGOEMPRESA (+)
  AND TIT.GLB_FORNECEDOR_CGCCPF  = TVE.GLB_FORNECEDOR_CGCCPF  (+)
  AND TVE.GLB_EVENTO_CODIGO      = EVE.GLB_EVENTO_CODIGO
  AND EVE.GLB_TPEVENTO_CODIGO    = 'A'
  AND 0 < (SELECT COUNT(*)
             FROM TDVADM.T_CPG_TITULOEVENTO TVE1,
                  TDVADM.T_GLB_EVENTO EVE1
            WHERE TVE1.CPG_TITULOS_NUMTIT         = TVE.CPG_TITULOS_NUMTIT
              AND TVE1.GLB_EVENTO_CODIGO          = EVE1.GLB_EVENTO_CODIGO
              AND EVE1.GLB_TPEVENTO_CODIGO        = 'P'
              AND TVE1.GPG_TITULOEVENTO_DTEVENTO >= VT_DTINI
              AND TVE1.GPG_TITULOEVENTO_DTEVENTO <= VT_DTFIM)
  AND TVE.GPG_TITULOEVENTO_DTEVENTO >= VT_DTINI
  AND TVE.GPG_TITULOEVENTO_DTEVENTO <= VT_DTFIM;

 --  CURSOR C_ABAT (ABATIMENTOS OBTIDOS)

 CURSOR C_ABAT IS
SELECT
  TVE.GLB_FORNECEDOR_CGCCPF FORN,
  TVE.GPG_TITULOEVENTO_DTEVENTO          DATA,
  TVE.CPG_TITULOS_NUMTIT                 NUMTIT,
  DECODE(FRN.GLB_FORNECEDOR_CTBPCONTA,NULL,EVE.CTB_PCONTA_CODIGODEB,REPLACE(EVE.CTB_PCONTA_CODIGODEB,'FFFFF',FRN.GLB_FORNECEDOR_CTBPCONTA)) CDEB,
  EVE.CTB_PCONTA_CODIGOCRED              CCRED,
  EVE.CTB_HISTORICO_CODIGODEB            HTD,
  SUBSTR(TRIM(REPLACE(REPLACE((SELECT HD.CTB_HISTORICO_DESCRICAO
                         FROM TDVADM.T_CTB_HISTORICO HD
                        WHERE CTB_HISTORICO_CODIGO = EVE.CTB_HISTORICO_CODIGOCRED),'#TIT#',lpad(TVE.CPG_TITULOS_NUMTIT,9,'0')),'#NOME#',NULL))||' '||FRN.GLB_FORNECEDOR_NOME,1,50) HDD,
  EVE.CTB_HISTORICO_CODIGOCRED           HTC,
  SUBSTR(TRIM(REPLACE(REPLACE((SELECT HC.CTB_HISTORICO_DESCRICAO
                         FROM TDVADM.T_CTB_HISTORICO HC
                        WHERE CTB_HISTORICO_CODIGO = EVE.CTB_HISTORICO_CODIGOCRED),'#TIT#',lpad(TVE.CPG_TITULOS_NUMTIT,9,'0')),'#NOME#',NULL))||' '||FRN.GLB_FORNECEDOR_NOME,1,50) HDC,
  TVE.GLB_ROTA_CODIGOEMPRESA ,
  TVE.CPG_TITULOEVENTO_VALOR VALOR,
  '    ' glb_centocusto_codigo,
  '    ' glb_centocusto_codigoc
FROM
  TDVADM.T_CPG_TITULOS TIT,
  TDVADM.T_CPG_TITULOEVENTO TVE,
  TDVADM.T_GLB_EVENTO EVE,
  TDVADM.T_GLB_FORNECEDOR FRN
WHERE FRN.GLB_FORNECEDOR_CGCCPF  = TIT.GLB_FORNECEDOR_CGCCPF
  AND TIT.CPG_TITULOS_NUMTIT     = TVE.CPG_TITULOS_NUMTIT (+)
  AND TIT.GLB_ROTA_CODIGOEMPRESA = TVE.GLB_ROTA_CODIGOEMPRESA (+)
  AND TIT.GLB_FORNECEDOR_CGCCPF  = TVE.GLB_FORNECEDOR_CGCCPF  (+)
  AND TVE.GLB_EVENTO_CODIGO      = EVE.GLB_EVENTO_CODIGO
  AND EVE.GLB_TPEVENTO_CODIGO    = 'D'
  AND TVE.GPG_TITULOEVENTO_DTEVENTO >= VT_DTINI
  AND TVE.GPG_TITULOEVENTO_DTEVENTO <= VT_DTFIM;

 --  CURSOR C_PAGBOR (PAGAMENTOS POR BORDERO)

 CURSOR C_PAGBOR IS
SELECT lpad(B.CPG_BORDEROS_NUMERO,6,'0') NUMERO,
--       TC.GLB_ROTA_CODIGOCCUSTO CCUSTO,
       B.CPG_BORDEROS_DATA DATA,
       B.GLB_BANCO_NUMERO BANCO,
       TE.GLB_EVENTO_CODIGO EVENTO,
       TE.GLB_FORNECEDOR_CGCCPF FORN,
       T.CPG_TITULOS_TIPOTITULO TTITULO,
--       DECODE(T.CPG_TITULOS_TIPOTITULO,'I',REPLACE(F.GLB_FORNECEDOR_CPGPCONTA,'***',R.GLB_ROTA_CODGENBAL),SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(B.GLB_BANCO_NUMERO)),1,12))  CDEB,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(B.GLB_BANCO_NUMERO)),1,12)  CDEB,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGOCRED,'BBBBB','00'||TRIM(B.GLB_BANCO_NUMERO)),1,12) CCRED,
       DECODE(T.CPG_TITULOS_TIPOTITULO,'I',F.GLB_FORNECEDOR_CPGHISTCTB,E.CTB_HISTORICO_CODIGODEB)       HTD,
       DECODE(T.CPG_TITULOS_TIPOTITULO,'I',(SELECT TRIM(CTB_HISTORICO_DESCRICAO) FROM TDVADM.T_CTB_HISTORICO WHERE CTB_HISTORICO_CODIGO = F.GLB_FORNECEDOR_CPGHISTCTB),
       (SUBSTR(TRIM(REPLACE((SELECT HD.CTB_HISTORICO_DESCRICAO FROM TDVADM.T_CTB_HISTORICO HD WHERE CTB_HISTORICO_CODIGO = E.CTB_HISTORICO_CODIGODEB),'#DOC#',lpad(BP.CPG_TITULOS_NUMTIT,9,'0')))||' '||F.GLB_FORNECEDOR_NOME,1,50))) HDD,
       E.CTB_HISTORICO_CODIGOCRED      HTC,
       SUBSTR(TRIM(REPLACE((SELECT HC.CTB_HISTORICO_DESCRICAO FROM TDVADM.T_CTB_HISTORICO HC WHERE CTB_HISTORICO_CODIGO = E.CTB_HISTORICO_CODIGOCRED),'#DOC#',lpad(B.CPG_BORDEROS_NUMERO,6,'0'))),1,50) HDC,
       BP.CPG_BORDEROSPARC_VALORTITULO VALOR
--       TC.CPG_TITULOCCUSTOVALOR VALOR,
--       DECODE(T.CPG_TITULOS_TIPOTITULO,'I',TC.CPG_TITULOCCUSTOVALOR,BP.CPG_BORDEROSPARC_VALORTITULO) VALOR,
--       TC.GLB_CENTROCUSTO_CODIGO,
--       TC.GLB_CENTROCUSTO_CODIGOC
  FROM tdvadm.T_CPG_BORDEROS B,
       tdvadm.T_CPG_BORDEROSPARC BP,
       tdvadm.T_CPG_TITULOEVENTO TE,
       tdvadm.T_CPG_TITULOS T,
       tdvadm.T_GLB_EVENTO E,
       tdvadm.T_GLB_FORNECEDOR F
--       TDVADM.T_CPG_TITULOCCUSTO TC
--       TDVADM.T_GLB_ROTA R
 WHERE B.CPG_BORDEROS_NUMERO = BP.CPG_BORDEROS_NUMERO
   AND TE.CPG_TITULOS_NUMTIT = BP.CPG_TITULOS_NUMTIT
   AND TE.GLB_FORNECEDOR_CGCCPF = BP.GLB_FORNECEDOR_CGCCPF
   AND TE.GLB_ROTA_CODIGOEMPRESA = BP.GLB_ROTA_CODIGOEMPRESA
   AND TE.GLB_TPDOC_CODIGO = 'BOR'
   and nvl(b.cpg_bordero_status,'A') <> 'C'
   AND TE.CPG_TITULOEVENTO_NRODOC = BP.CPG_BORDEROS_NUMERO
   AND TE.GPG_TITULOEVENTO_SEQ    = BP.GPG_TITULOEVENTO_SEQ
   AND T.CPG_TITULOS_NUMTIT = TE.CPG_TITULOS_NUMTIT
   AND T.GLB_FORNECEDOR_CGCCPF = TE.GLB_FORNECEDOR_CGCCPF
   AND T.GLB_ROTA_CODIGOEMPRESA = TE.GLB_ROTA_CODIGOEMPRESA
   AND E.GLB_EVENTO_CODIGO      = TE.GLB_EVENTO_CODIGO
--   AND T.CPG_TITULOS_NUMTIT     = TC.CPG_TITULOS_NUMTIT
--   AND T.GLB_FORNECEDOR_CGCCPF  = TC.GLB_FORNECEDOR_CGCCPF
--   AND T.GLB_ROTA_CODIGOEMPRESA = TC.GLB_ROTA_CODIGOEMPRESA
   AND TE.GLB_FORNECEDOR_CGCCPF = F.GLB_FORNECEDOR_CGCCPF
--   AND TC.GLB_ROTA_CODIGOCCUSTO = R.GLB_ROTA_CODIGO
   -- alterado SIRLANO 16/05/2007
   AND trunc(B.CPG_BORDEROS_DATA) >= VT_DTINI
   AND trunc(B.CPG_BORDEROS_DATA) <= VT_DTFIM
   -- criado SIRLANO 16/05/2007
   and trunc(te.gpg_tituloevento_dtevento) >= VT_DTINI
   and TRUNC(te.gpg_tituloevento_dtevento) <= VT_DTFIM
   and te.cpg_titparcelas_parcela = bp.cpg_titparcelas_parcela
   ORDER BY B.CPG_BORDEROS_NUMERO ;
   -- and te.gpg_tituloevento_seq = bp.gpg_tituloevento_seq
   -- Segundo Victor - esse campo ( bp.gpg_tituloevento_seq ) foi criado no dia 02 de abril
   -- ent?o existira sequencias em branco no mes de Abril
   -- Apartir do mes de maio essa linha podera ser usada
   -- Ele Vai Colocar na lista de pendencias a complementac?o das sequencias dessa tabela.

 --  CURSOR C_PAGCHQ (PAGAMENTOS POR CHEQUE)

 CURSOR C_PAGCHQ IS
SELECT DISTINCT 
       lpad(C.CPG_CHEQUEBANCO_NUMERO,6,'0')    NUMERO,
       C.CPG_CHEQUEBANCO_PAGAMENTO DATA,
       C.GLB_BANCO_NUMERO          BANCO,
       C.CPG_CHEQUEBANCO_VALOR     VALOR_CHQ,
       LPAD(TRIM(cp.cpg_chequebanco_numero),6,'0')   cheque,
       E.GLB_EVENTO_CODIGO         EVENTO,
       F.GLB_FORNECEDOR_CGCCPF     FORN,
       T.CPG_TITULOS_TIPOTITULO    TTITULO,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGODEB,'BBBBB','00'||TRIM(C.GLB_BANCO_NUMERO)),1,12)  CDEB,
       SUBSTR(REPLACE(E.CTB_PCONTA_CODIGOCRED,'BBBBB','00'||TRIM(C.GLB_BANCO_NUMERO)),1,12) CCRED,
       E.CTB_HISTORICO_CODIGODEB       HTD,
       E.GLB_EVENTO_CODIGO,
       SUBSTR(TRIM(REPLACE((SELECT HD.CTB_HISTORICO_DESCRICAO FROM TDVADM.T_CTB_HISTORICO HD WHERE CTB_HISTORICO_CODIGO = E.CTB_HISTORICO_CODIGODEB),'#DOC#',lpad(CP.CPG_TITULOS_NUMTIT,9,'0')))||' '||DECODE(nvl(TCC.CPG_DESPESAS_CODIGO,'0000'),'0277',C.CPG_CHEQUEBANCO_NOMINAL, F.GLB_FORNECEDOR_NOME),1,50) HDD,
       E.CTB_HISTORICO_CODIGOCRED      HTC,
       SUBSTR(TRIM(REPLACE((SELECT HC.CTB_HISTORICO_DESCRICAO FROM TDVADM.T_CTB_HISTORICO HC WHERE CTB_HISTORICO_CODIGO = E.CTB_HISTORICO_CODIGOCRED),'#DOC#',lpad(C.CPG_CHEQUEBANCO_NUMERO,6,'0'))),1,50) HDC,
       CP.CPG_CHEQUEBANCOTITULO_VALOR VALOR,
       CP.CPG_TITPARCELAS_PARCELA -- incluido esta coluna para diferenciar lançamentos feitos na mesma data e valor para o mesmo ducumento, porem a parcela é diferente.
  FROM tdvadm.T_GLB_EVENTO E,
       tdvadm.T_CPG_CHEQUEBANCO C,
       tdvadm.T_CPG_TITULOS T,
       tdvadm.T_GLB_FORNECEDOR F,
       tdvadm.T_CPG_CHEQUEBANCOPARCELA CP,
       tdvadm.T_CPG_TITULOEVENTO TE,
       TDVADM.T_CPG_TITULOCCUSTO TCC
 WHERE F.GLB_FORNECEDOR_CGCCPF             = TE.GLB_FORNECEDOR_CGCCPF
   AND E.GLB_EVENTO_CODIGO                 = TE.GLB_EVENTO_CODIGO
   AND CP.GLB_BANCO_NUMERO                 = C.GLB_BANCO_NUMERO
   AND CP.GLB_AGENCIA_NUMERO               = C.GLB_AGENCIA_NUMERO
   AND CP.CPG_CHEQUEBANCO_CONTA            = C.CPG_CHEQUEBANCO_CONTA
   AND CP.CPG_CHEQUEBANCO_NUMERO           = C.CPG_CHEQUEBANCO_NUMERO
   AND CP.CPG_TITPARCELAS_PARCELA          = TE.CPG_TITPARCELAS_PARCELA
   AND CP.GLB_ROTA_CODIGOEMPRESA           = TE.GLB_ROTA_CODIGOEMPRESA
   AND CP.GLB_FORNECEDOR_CGCCPF            = TE.GLB_FORNECEDOR_CGCCPF
   AND CP.CPG_TITULOS_NUMTIT               = TE.CPG_TITULOS_NUMTIT
   AND TE.GLB_TPDOC_CODIGO                 = 'CHQ'
   AND CP.GLB_ROTA_CODIGOEMPRESA           = T.GLB_ROTA_CODIGOEMPRESA
   AND CP.GLB_FORNECEDOR_CGCCPF            = T.GLB_FORNECEDOR_CGCCPF
   AND CP.CPG_TITULOS_NUMTIT               = T.CPG_TITULOS_NUMTIT
   AND CP.GPG_TITULOEVENTO_SEQ             = TE.GPG_TITULOEVENTO_SEQ
   AND T.GLB_ROTA_CODIGOEMPRESA            = TCC.GLB_ROTA_CODIGOEMPRESA (+)
   AND T.GLB_FORNECEDOR_CGCCPF             = TCC.GLB_FORNECEDOR_CGCCPF (+)
   AND T.CPG_TITULOS_NUMTIT                = TCC.CPG_TITULOS_NUMTIT (+)
--   AND CP.GLB_FORNECEDOR_CGCCPF = '61139432000177'
   AND TRUNC(C.CPG_CHEQUEBANCO_PAGAMENTO) >= VT_DTINI
   AND TRUNC(C.CPG_CHEQUEBANCO_PAGAMENTO) <= VT_DTFIM
 order by 1,12;  

 -- CURSOR C_AJUSTA_FORN (Fornecedores que Precisam ser Criados no Plano de Contas)

CURSOR C_AJUSTA_FORN IS
SELECT CTB_MOVIMENTO_DOCUMENTO,
       CTB_MOVIMENTO_DSEQUENCIA,
       CTB_PCONTA_CODIGO_PARTIDA   PARTIDA,
       CTB_PCONTA_CODIGO_CPARTIDA  CPARTIDA,
       CTB_MOVIMENTO_CGCCNPJ       CNPJ
  FROM tdvadm.T_CTB_MOVIMENTO_TST
 WHERE (SUBSTR(CTB_PCONTA_CODIGO_PARTIDA,8,5) = 'FFFFF'
 OR SUBSTR(CTB_PCONTA_CODIGO_CPARTIDA,8,5) = 'FFFFF');


 BEGIN

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


-- REABERTURA DE MOVIMENTO ANTERIORMENTE FECHADO

IF P_MODO = 0 THEN

  DELETE T_CTB_LINKCTL 
   WHERE CTB_LINKCTL_STATUS = 'E';

  DELETE T_CTB_LOGTRANSF LT 
   WHERE LT.CTB_LOGTRANSF_SISTEMA = 'CPG' 
     AND LT.CTB_LOGTRANSF_REFERENCIA = P_ANO||VT_MES;

  UPDATE T_USU_PERFIL P
     SET P.USU_PERFIL_PARAT = F_RET_REF_ANT(P_ANO||VT_MES)
   WHERE P.USU_APLICACAO_CODIGO = '0000000000'
     AND TRIM(P.USU_PERFIL_CODIGO) = 'REFFECHAMENTOCPG';              

  UPDATE T_USU_PERFIL P
     SET P.USU_PERFIL_PARAT = F_RET_REF_ANT(P_ANO||VT_MES)
   WHERE P.USU_APLICACAO_CODIGO = '0000000000'
     AND TRIM(P.USU_PERFIL_CODIGO) = 'REFFECHAMENTOCTB';              

  DELETE T_CTB_MOVIMENTO M
   WHERE M.CTB_REFERENCIA_CODIGO_PARTIDA = P_ANO||VT_MES
     AND M.CTB_MOVIMENTO_ORIGEMPR = VT_ORG;

  END IF;

 -- Rotina Principal

 IF P_MODO > 1 THEN

-- VERIFICA E EXISTENCIA DE FORNECEDORES COM NOMES DIVERGENTES

  SELECT COUNT(*)
    INTO VT_CONTADOR  
    FROM TDVADM.T_GLB_FORNECEDOR F,
         TDVADM.T_CTB_PCONTA P
   WHERE F.GLB_FORNECEDOR_CTBPCONTA IS NOT NULL
     AND P.CTB_PCONTA_CODIGO = '2202022'||TRIM(F.GLB_FORNECEDOR_CTBPCONTA)
     AND TRIM(F.GLB_FORNECEDOR_NOME) <> TRIM(P.CTB_PCONTA_DESCRICAO)
     -- Inclui as contas de prefeituras e impostos do PARDAL
     and f.glb_fornecedor_cgccpf > '00000000000191'
     and f.glb_fornecedor_cgccpf <> '00000000011'
     and f.glb_fornecedor_cgccpf <>  '02000000000001'
     and substr(f.glb_fornecedor_cgccpf,1,8) <> '61139432';      

   IF VT_CONTADOR = 1 THEN
     RAISE_APPLICATION_ERROR(-20007,'EXISTE 1 FORNECEDOR COM NOME DIVERGENTE EXECUTAR RELATORIO (CPG - Fornecedores Divergentes) PARA MAIORES DETALHES!');
     END IF;

   IF VT_CONTADOR > 1 THEN
     RAISE_APPLICATION_ERROR(-20007,'EXISTEM '||VT_CONTADOR|| ' FORNECEDORES COM NOMES DIVERGENTES EXECUTAR RELATORIO (CPG - Fornecedores Divergentes) PARA MAIORES DETALHES!');
     END IF;

 -- *** I N I C I A C A O   L O G ***

   SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'INICIO DA EXECUCAO DA PROCEDURE','EXECUCAO',P_ID,NULL);

 -- Verificacao de ID

   SELECT COUNT(*)
     INTO VT_CONTADOR
     FROM TDVADM.T_CTB_LINKCTL
    WHERE CTB_LINKCTL_STATUS = 'E'
      AND CTB_LINKCTL_ID = P_ID;

   IF VT_CONTADOR > 1 THEN
     SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'ID INVALIDO OU INEXISTENTE VERIFIQUE!!','ERRO',P_ID,'ATENCAO!!! Esta procedure so deve ser executada atraves de SP_LINK_CTB_TDV');
     RAISE_APPLICATION_ERROR(-20007,'ID INVALIDO OU INEXISTENTE VERIFIQUE!!');
     END IF;
     
   -- Muda Bordero para Cheque 
   tdvadm.pkg_cpg_contaspagar.sp_MudaBorderoPCheque(P_ANO || P_MES); 

--   VT_SOMA      := 0;
--   VT_SEQUENCIA := 1;
--   VT_CONTROLE  := NULL;

   FOR R_TIT_LANCADOS IN C_TIT_LANCADOS LOOP

     INSERT INTO tdvadm.T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                      CTB_MOVIMENTO_CGCCNPJ,
                                      glb_centrocusto_codigo,
                                      glb_centrocusto_codigoc,
                                      CTB_MOVIMENTO_ORIGEMPR )
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      1,
                                      R_TIT_LANCADOS.DATA,
                                      R_TIT_LANCADOS.CCRED,
                                      R_TIT_LANCADOS.CDEB,
                                      null, --R_TIT_LANCADOS.CCUSTO,
                                      TRIM(P_ANO)||VT_MES,
                                      TRIM(P_ANO)||VT_MES,
                                      R_TIT_LANCADOS.HTD,
                                      '1',
                                      nvl(R_TIT_LANCADOS.VALOR,0),
                                      'D',
                                      R_TIT_LANCADOS.HDD,
                                      SYSDATE,
                                      VT_ORG,
                                      null, --R_TIT_LANCADOS.CCUSTO,
                                      trim(P_ID)||'1',
                                      R_TIT_LANCADOS.FORN,
                                      R_TIT_LANCADOS.GLB_CENTROCUSTO_CODIGO,
                                      R_TIT_LANCADOS.GLB_CENTROCUSTO_CODIGOC,
                                      VT_ORG);

     INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                      CTB_MOVIMENTO_CGCCNPJ,
                                      GLB_CENTROCUSTO_CODIGO,
                                      GLB_CENTROCUSTO_CODIGOC,
                                      CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      2,
                                      R_TIT_LANCADOS.DATA,
                                      R_TIT_LANCADOS.CDEB,
                                      R_TIT_LANCADOS.CCRED,
                                      null, --R_TIT_LANCADOS.CCUSTO,
                                      TRIM(P_ANO)||VT_MES,
                                      TRIM(P_ANO)||VT_MES,
                                      R_TIT_LANCADOS.HTC,
                                      '1',
                                      nvl(R_TIT_LANCADOS.VALOR,0),
                                      'C',
                                      R_TIT_LANCADOS.HDC,
                                      SYSDATE,
                                      VT_ORG,
                                      null, --R_TIT_LANCADOS.CCUSTO,
                                      trim(P_ID)||'1',
                                      R_TIT_LANCADOS.FORN,
                                      R_TIT_LANCADOS.GLB_CENTROCUSTO_CODIGO,
                                      R_TIT_LANCADOS.GLB_CENTROCUSTO_CODIGOC,
                                      VT_ORG);
     VT_DOCTO := VT_DOCTO + 1;
     commit;
     END LOOP;

   VT_SOMA      := 0;
   VT_SEQUENCIA := 2;
   VT_CONTROLE  := 0;

-- IMPOSTOS

  FOR R_IMPOSTOS IN C_IMPOSTOS LOOP

    INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                     CTB_MOVIMENTO_CGCCNPJ,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     1,
                                     R_IMPOSTOS.DATA,
                                     R_IMPOSTOS.CCRED,
                                     R_IMPOSTOS.CDEB,
                                     NULL,
                                     TRIM(P_ANO)||VT_MES,
                                     TRIM(P_ANO)||VT_MES,
                                     R_IMPOSTOS.HTD,
                                     '1',
                                     nvl(R_IMPOSTOS.VALOR,0),
                                     'D',
                                     R_IMPOSTOS.HDD,
                                     SYSDATE,
                                     VT_ORG,
                                     NULL,
                                     trim(P_ID)||'2',
                                     R_IMPOSTOS.FORN,
                                     VT_ORG);

    INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                     CTB_MOVIMENTO_CGCCNPJ,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     2,
                                     R_IMPOSTOS.DATA,
                                     R_IMPOSTOS.CDEB,
                                     R_IMPOSTOS.CCRED,
                                     NULL,
                                     TRIM(P_ANO)||VT_MES,
                                     TRIM(P_ANO)||VT_MES,
                                     R_IMPOSTOS.HTC,
                                     '1',
                                     nvl(R_IMPOSTOS.VALOR,0),
                                     'C',
                                     R_IMPOSTOS.HDC,
                                     SYSDATE,
                                     VT_ORG,
                                     NULL,
                                     trim(P_ID)||'2',
                                     R_IMPOSTOS.FORN,
                                     VT_ORG);

         VT_DOCTO := VT_DOCTO + 1;

         END LOOP;

-- JUROS PAGOS

  FOR R_JUROS IN C_JUROS LOOP

    VT_DESCDEB := TRIM(SUBSTR(R_JUROS.HDD,1,50));
    VT_DESCCRE := TRIM(SUBSTR(R_JUROS.HDC,1,50));
    
    Begin
        select tcc.glb_centrocusto_codigo,
               tcc.glb_centrocusto_codigoc
          into R_JUROS.GLB_CENTOCUSTO_CODIGO,
               R_JUROS.Glb_Centocusto_Codigoc
        from tdvadm.T_CPG_TITULOCCUSTO TCC
        where tcc.cpg_titulos_numtit = R_JUROS.NUMTIT
          and tcc.glb_fornecedor_cgccpf = r_JUROS.Forn
          and tcc.glb_centrocusto_codigoc is not null
          and rownum = 1;
    Exception
      When OTHERS Then
         Begin 
            select tcc.glb_centrocusto_codigo,
                   tcc.glb_centrocusto_codigoc
              into R_JUROS.GLB_CENTOCUSTO_CODIGO,
                   R_JUROS.Glb_Centocusto_Codigoc
            from tdvadm.T_CPG_TITULOCCUSTO TCC
            where tcc.cpg_titulos_numtit = R_JUROS.NUMTIT
              and tcc.glb_fornecedor_cgccpf = r_JUROS.Forn
              and tcc.glb_centrocusto_codigoc is null
              and rownum = 1;
         Exception
           When OTHERS Then
              R_JUROS.GLB_CENTOCUSTO_CODIGO := null;
              R_JUROS.Glb_Centocusto_Codigoc := null;
           End;
            
      End;

    INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                     CTB_MOVIMENTO_CGCCNPJ,
                                     GLB_CENTROCUSTO_CODIGO,
                                     GLB_CENTROCUSTO_CODIGOC,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     1,
                                     R_JUROS.DATA,
                                     R_JUROS.CCRED,
                                     R_JUROS.CDEB,
                                     R_JUROS.GLB_ROTA_CODIGOEMPRESA,
                                     TRIM(P_ANO)||VT_MES,
                                     TRIM(P_ANO)||VT_MES,
                                     R_JUROS.HTD,
                                     '1',
                                     nvl(R_JUROS.VALOR,0),
                                     'D',
                                     REPLACE(VT_DESCDEB,'#TIT#',R_JUROS.NUMTIT),
                                     SYSDATE,
                                     VT_ORG,
                                     NULL,
                                     trim(P_ID)||'3',
                                     R_JUROS.FORN,
                                     R_JUROS.Glb_Centocusto_Codigo,
                                     R_JUROS.Glb_Centocusto_Codigoc,
                                     VT_ORG);

    INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                     CTB_MOVIMENTO_CGCCNPJ,
                                     GLB_CENTROCUSTO_CODIGO,
                                     GLB_CENTROCUSTO_CODIGOC,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     2,
                                     R_JUROS.DATA,
                                     R_JUROS.CDEB,
                                     R_JUROS.CCRED,
                                     R_JUROS.GLB_ROTA_CODIGOEMPRESA,
                                     TRIM(P_ANO)||VT_MES,
                                     TRIM(P_ANO)||VT_MES,
                                     R_JUROS.HTC,
                                     '1',
                                     nvl(R_JUROS.VALOR,0),
                                     'C',
                                     REPLACE(VT_DESCCRE,'#TIT#',R_JUROS.NUMTIT),
                                     SYSDATE,
                                     VT_ORG,
                                     NULL,
                                     trim(P_ID)||'3',
                                     R_JUROS.FORN,
                                     R_JUROS.Glb_Centocusto_Codigo,
                                     R_JUROS.Glb_Centocusto_Codigoc,
                                     VT_ORG);

         VT_DOCTO := VT_DOCTO + 1;

         END LOOP;

-- ABATIMENTOS

  FOR R_ABAT IN C_ABAT LOOP

    VT_DESCDEB := TRIM(SUBSTR(R_ABAT.HDD,1,50));
    VT_DESCCRE := TRIM(SUBSTR(R_ABAT.HDC,1,50));

    Begin
        select tcc.glb_centrocusto_codigo,
               tcc.glb_centrocusto_codigoc
          into R_ABAT.GLB_CENTOCUSTO_CODIGO,
               R_ABAT.Glb_Centocusto_Codigoc
        from tdvadm.T_CPG_TITULOCCUSTO TCC
        where tcc.cpg_titulos_numtit = R_ABAT.NUMTIT
          and tcc.glb_fornecedor_cgccpf = R_ABAT.Forn
          and tcc.glb_centrocusto_codigoc is not null
          and rownum = 1;
    Exception
      When OTHERS Then
         Begin 
            select tcc.glb_centrocusto_codigo,
                   tcc.glb_centrocusto_codigoc
              into R_ABAT.GLB_CENTOCUSTO_CODIGO,
                   R_ABAT.Glb_Centocusto_Codigoc
            from tdvadm.T_CPG_TITULOCCUSTO TCC
            where tcc.cpg_titulos_numtit = R_ABAT.NUMTIT
              and tcc.glb_fornecedor_cgccpf = R_ABAT.Forn
              and tcc.glb_centrocusto_codigoc is null
              and rownum = 1;
         Exception
           When OTHERS Then
              R_ABAT.GLB_CENTOCUSTO_CODIGO := null;
              R_ABAT.Glb_Centocusto_Codigoc := null;
           End;
            
      End;


    INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                     CTB_MOVIMENTO_CGCCNPJ,
                                     GLB_CENTROCUSTO_CODIGO,
                                     GLB_CENTROCUSTO_CODIGOC,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     1,
                                     R_ABAT.DATA,
                                     R_ABAT.CCRED,
                                     R_ABAT.CDEB,
                                     R_ABAT.GLB_ROTA_CODIGOEMPRESA,
                                     TRIM(P_ANO)||VT_MES,
                                     TRIM(P_ANO)||VT_MES,
                                     R_ABAT.HTD,
                                     '1',
                                     nvl(R_ABAT.VALOR,0),
                                     'D',
                                     VT_DESCDEB,
                                     SYSDATE,
                                     VT_ORG,
                                     NULL,
                                     trim(P_ID)||'4',
                                     R_ABAT.FORN,
                                     R_ABAT.GLB_CENTOCUSTO_CODIGO,
                                     R_ABAT.GLB_CENTOCUSTO_CODIGOC,
                                     VT_ORG);

    INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                     CTB_MOVIMENTO_CGCCNPJ,
                                     GLB_CENTROCUSTO_CODIGO,
                                     GLB_CENTROCUSTO_CODIGOC,
                                     CTB_MOVIMENTO_ORIGEMPR)
                             VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                     2,
                                     R_ABAT.DATA,
                                     R_ABAT.CDEB,
                                     R_ABAT.CCRED,
                                     R_ABAT.GLB_ROTA_CODIGOEMPRESA,
                                     TRIM(P_ANO)||VT_MES,
                                     TRIM(P_ANO)||VT_MES,
                                     R_ABAT.HTC,
                                     '1',
                                     nvl(R_ABAT.VALOR,0),
                                     'C',
                                     VT_DESCCRE,
                                     SYSDATE,
                                     VT_ORG,
                                     NULL,
                                     trim(P_ID)||'4',
                                     R_ABAT.FORN,
                                     R_ABAT.GLB_CENTOCUSTO_CODIGO,
                                     R_ABAT.GLB_CENTOCUSTO_CODIGOC,
                                     VT_ORG);

         VT_DOCTO := VT_DOCTO + 1;

         END LOOP;

-- PAGAMENTOS POR BORDERO

   FOR R_PAGBOR IN C_PAGBOR LOOP

     IF (VT_CONTROLE <> 0) AND (VT_CONTROLE <> R_PAGBOR.NUMERO) THEN

       INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                        CTB_MOVIMENTO_CGCCNPJ,
                                        CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        1,
                                        VT_DATA,
                                        NULL,
                                        VT_CCRED,
                                        NULL,
                                        TRIM(P_ANO)||VT_MES,
                                        NULL,
                                        VT_HTC,
                                        '3',
                                        nvl(VT_SOMA,0),
                                        'C',
                                        VT_HDC,
                                        SYSDATE,
                                        VT_ORG,
                                        NULL,
                                        trim(P_ID)||'5',
                                        VT_FORN,
                                        VT_ORG);



       VT_DOCTO := VT_DOCTO + 1;
       VT_SOMA      := 0;
       VT_SEQUENCIA := 2;

       END IF;

     VT_CONTROLE := R_PAGBOR.NUMERO;
     VT_HTC      := R_PAGBOR.HTC;
     VT_HDC      := R_PAGBOR.HDC;
     VT_CCRED    := R_PAGBOR.CCRED;
     VT_DATA     := R_PAGBOR.DATA;
     VT_FORN     := R_PAGBOR.FORN;

     INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                      CTB_MOVIMENTO_CGCCNPJ,
                                      CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      R_PAGBOR.DATA,
                                      R_PAGBOR.CCRED,
                                      R_PAGBOR.CDEB,
                                      NULL,
                                      TRIM(P_ANO)||VT_MES,
                                      TRIM(P_ANO)||VT_MES,
                                      R_PAGBOR.HTD,
                                      '3',
                                      nvl(R_PAGBOR.VALOR,0),
                                      'D',
                                      NVL(R_PAGBOR.HDD,'*** ATENÇÃO !!! - HISTORICO NÃO ENCONTRADO'),
                                      SYSDATE,
                                      VT_ORG,
                                      NULL,
                                      trim(P_ID)||'5',
                                      R_PAGBOR.FORN,
                                      VT_ORG);

     VT_SEQUENCIA := VT_SEQUENCIA + 1;
     VT_SOMA      := VT_SOMA + R_PAGBOR.VALOR;


     END LOOP;

   INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                    CTB_MOVIMENTO_CGCCNPJ,
                                    CTB_MOVIMENTO_ORIGEMPR)
                            VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                    1,
                                    VT_DATA,
                                    NULL,
                                    VT_CCRED,
                                    NULL,
                                    TRIM(P_ANO)||VT_MES,
                                    NULL,
                                    VT_HTC,
                                    '3',
                                    nvl(VT_SOMA,0),
                                    'C',
                                    VT_HDC,
                                    SYSDATE,
                                    VT_ORG,
                                    NULL,
                                    trim(P_ID)||'5',
                                    VT_FORN,
                                    VT_ORG);


   VT_DOCTO := VT_DOCTO + 1;
   VT_SOMA      := 0;
   VT_SEQUENCIA := 2;
   VT_CONTROLE  := 0;

-- PAGAMENTOS POR CHEQUE

   FOR R_PAGCHQ IN C_PAGCHQ LOOP

     If R_PAGCHQ.cheque is not null Then
        R_PAGCHQ.HDD := replace(R_PAGCHQ.HDD,'#CHQ#',R_PAGCHQ.cheque);
        R_PAGCHQ.HDC := replace(R_PAGCHQ.HDC,'#CHQ#',R_PAGCHQ.cheque);
     Else
        R_PAGCHQ.HDD := replace(R_PAGCHQ.HDD,'#CHQ#','');
        R_PAGCHQ.HDC := replace(R_PAGCHQ.HDC,'#CHQ#','');
     End If;

--     IF (VT_CONTROLE <> 0) AND (VT_CONTROLE <> R_PAGCHQ.NUMERO) THEN

 
       INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                        CTB_MOVIMENTO_CGCCNPJ,
                                        CTB_MOVIMENTO_ORIGEMPR)
                                VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                        1,
                                        VT_DATA,
                                        NULL,
                                        VT_CCRED,
                                        NULL,
                                        TRIM(P_ANO)||VT_MES,
                                        NULL,
                                        VT_HTC,
                                        '3',
                                        R_PAGCHQ.VALOR, --nvl(VT_SOMA,0),
                                        'C',
                                        R_PAGCHQ.HDC, --VT_HDC,
                                        SYSDATE,
                                        VT_ORG,
                                        NULL,
                                        trim(P_ID)||'6',
                                        VT_FORN,
                                        VT_ORG);

     IF (VT_CONTROLE <> 0) AND (VT_CONTROLE <> R_PAGCHQ.NUMERO) THEN
       VT_DOCTO := VT_DOCTO + 1;
       VT_SOMA      := 0;
       VT_SEQUENCIA := 2;

      END IF;


     
     VT_CONTROLE := R_PAGCHQ.NUMERO;
     VT_HTC      := R_PAGCHQ.HTC;
     VT_HDC      := R_PAGCHQ.HDC;
     VT_CCRED    := R_PAGCHQ.CCRED;
     VT_DATA     := R_PAGCHQ.DATA;
     VT_FORN     := R_PAGCHQ.FORN;

     INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                      CTB_MOVIMENTO_CGCCNPJ,
                                      CTB_MOVIMENTO_ORIGEMPR)
                              VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                      VT_SEQUENCIA,
                                      R_PAGCHQ.DATA,
                                      R_PAGCHQ.CCRED,
                                      R_PAGCHQ.CDEB,
                                      NULL,
                                      TRIM(P_ANO)||VT_MES,
                                      TRIM(P_ANO)||VT_MES,
                                      R_PAGCHQ.HTD,
                                      '3',
                                      nvl(R_PAGCHQ.VALOR,0),
                                      'D',
                                      R_PAGCHQ.HDD,
                                      SYSDATE,
                                      VT_ORG,
                                      NULL,
                                      trim(P_ID)||'6',
                                      R_PAGCHQ.FORN,
                                      VT_ORG);
     VT_SEQUENCIA := VT_SEQUENCIA + 1;
     VT_SOMA      := VT_SOMA + R_PAGCHQ.VALOR;

     END LOOP;

   INSERT INTO T_CTB_MOVIMENTO_TST (CTB_MOVIMENTO_DOCUMENTO,
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
                                    CTB_MOVIMENTO_CGCCNPJ,
                                    CTB_MOVIMENTO_ORIGEMPR)
                            VALUES (TRIM(TO_CHAR(VT_DOCTO,'0000000')),
                                    1,
                                    VT_DATA,
                                    NULL,
                                    VT_CCRED,
                                    NULL,
                                    TRIM(P_ANO)||VT_MES,
                                    NULL,
                                    VT_HTC,
                                    '3',
                                    nvl(VT_SOMA,0),
                                    'C',
                                    VT_HDC,
                                    SYSDATE,
                                    VT_ORG,
                                    NULL,
                                    trim(P_ID)||'6',
                                    VT_FORN,
                                    VT_ORG);


--   VT_DOCTO := VT_DOCTO + 1;
--   VT_SOMA      := 0;
--   VT_SEQUENCIA := 2;

-- AJUSTA A CONTA DOS FORNECEDORES AINDA NAO CADASTRADOS NA CONTABILIDADE

  FOR R_AJUSTA_FORN IN C_AJUSTA_FORN LOOP

    UPDATE T_CTB_MOVIMENTO_TST
       SET CTB_PCONTA_CODIGO_PARTIDA  = FN_GETPCONTAFORN(R_AJUSTA_FORN.PARTIDA,R_AJUSTA_FORN.CNPJ,P_ID),
           CTB_PCONTA_CODIGO_CPARTIDA = FN_GETPCONTAFORN(R_AJUSTA_FORN.CPARTIDA,R_AJUSTA_FORN.CNPJ,P_ID)
     WHERE CTB_MOVIMENTO_DOCUMENTO    = R_AJUSTA_FORN.CTB_MOVIMENTO_DOCUMENTO
       AND CTB_MOVIMENTO_DSEQUENCIA   = R_AJUSTA_FORN.CTB_MOVIMENTO_DSEQUENCIA;

    END LOOP;

-- Retira Sujeiras que restaram nos hitoricos

 UPDATE T_CTB_MOVIMENTO_TST M SET M.CTB_MOVIMENTO_DESCRICAO = REPLACE(M.CTB_MOVIMENTO_DESCRICAO,'#TIT# - #NOME#');
 UPDATE T_CTB_MOVIMENTO_TST M SET M.CTB_MOVIMENTO_DESCRICAO = REPLACE(M.CTB_MOVIMENTO_DESCRICAO,'#NOME#');
 UPDATE T_CTB_MOVIMENTO_TST M SET M.CTB_MOVIMENTO_DESCRICAO = REPLACE(M.CTB_MOVIMENTO_DESCRICAO,'#TIT#');
 UPDATE T_CTB_MOVIMENTO_TST M SET M.CTB_MOVIMENTO_DESCRICAO = REPLACE(M.CTB_MOVIMENTO_DESCRICAO,'(PAGTO), ','(PAGTO),');

  END IF; -- P_MODO > 1

-- IF P_MODO > 2 THEN
--  VT_SEQUENCIA := 0;
--  END IF;

 IF P_MODO > 3 THEN
   
-- Atualiza a Tabela de Logs de Transferencia.

   SELECT SUBSTR(OSUSER,1,20) OSUSER
     INTO VT_USUARIO
     FROM V$SESSION
    WHERE AUDSID = SYS_CONTEXT('USERENV','SESSIONID');
  
   INSERT INTO T_CTB_LOGTRANSF (CTB_LOGTRANSF_REFERENCIA,
                                CTB_LOGTRANSF_DATA,
                                CTB_LOGTRANSF_USUARIO,
                                CTB_LOGTRANSF_SISTEMA)
                        VALUES (P_ANO||VT_MES,
                                SYSDATE,
                                VT_USUARIO,
                                'CPG');
 
  -- Verifica se o Fechamento ja foi notificado e em caso negativo notifica o fechamento para os demais modulos do sistema. 
  -- Alterado para efetuar fechamento apenas se ainda estiver aberto - 08/07/2013 - Roberto Pariz.   
  
  SELECT P.USU_PERFIL_PARAT REFERENCIA
    INTO VT_REF
    FROM TDVADM.T_USU_PERFIL P
   WHERE P.USU_APLICACAO_CODIGO = '0000000000'
     AND TRIM(P.USU_PERFIL_CODIGO) = 'REFFECHAMENTOCPG';

  IF VT_REF < P_ANO||VT_MES THEN
    PKG_GLB_COMMON.SET_SISTEMAFECHAMENTO('CPG',P_ANO||VT_MES,SYSDATE,VT_STATUS,VT_ERROR);   
    IF VT_STATUS <> 'N' THEN
      RAISE_APPLICATION_ERROR(-20100,'STATUS='||VT_STATUS||' - '||VT_ERROR);
      END IF;
    END IF;
  END IF;


 -- *** F I N A L I Z A C A O  L O G ***

 SP_LINK_CTB_TDV_LOG(VT_PROCNAME,P_MES,P_ANO,P_DIA,P_MODO,NULL,'FINAL DA EXECUCAO DA PROCEDURE','EXECUCAO',P_ID,NULL);
 COMMIT;
 END;

 
/
