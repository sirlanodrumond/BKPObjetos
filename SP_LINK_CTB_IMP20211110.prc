CREATE OR REPLACE PROCEDURE SP_LINK_CTB_IMP(P_LAYOUT IN CHAR DEFAULT 'GERAL')
AS

/* 
 * ------------------------------------------------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA          : Contabilidade
 * PROGRAMA         : SP_LINK_CTB_IMP.SQL
 * ANALISTA         : Roberto Pariz
 * PROGRAMADOR      : Roberto Pariz
 * CRIACAO          : 05-03-2015
 * BANCO            : ORACLE
 * ALIMENTA         : T_CTB_MOVIMENTO
 * SIGLAS           : CTB,CON,GLB
 * EXECUCAO         : SP_LINK_CTB_IMP
 * COMENTARIOS      : Promove a contabilizacao de dados provenientes de planilhas
 * ATUALIZA         :
 * PARAMETRO        : P_LAYOUT => LAYOUT NO QUAL ESTA PLANILHA A SER PROCESSADO PELA PROCEDURE (BANCOS) (GERAL) => (PADRÃO).   
 *                  :
 * PARTICULARIDADES : UTILIZA DADOS IMPORTADOS PARA TABELA T_CTB_MOVIMENTO_IMP
 *                  : PARA FAZER OS LANÇAMENTOS NA CONTABILIDADE.
 *                  : 
 * ALTERACAO        : INCLUIDO O PARAMENTRO DE LAYOUT PARA POSSIBILITAR VARIOS LAYOUTS DE PLANULHA DE CONTABILIZAÇÃO A PARTIR DA MESMA TABELA
 *                  : OS LAYOUTS ATUAIS SÃO (B)ANCOS (I)MOBILIZADO. - 17/06/2015 - ROBERTO PARIZ. 
 *                  : 
 * ------------------------------------------------------------------------------------------------------------------------------------------------------------------
 */

 VT_PROCNAME  CHAR(25) := 'SP_LINK_CTB_IMP';
 VT_ID        CHAR(25) := FN_IDEXEC(TRIM(VT_PROCNAME));
 VT_ORG       CHAR(1)  := '9'; -- IMPORTAÇÃO DE DADOS DO EXCEL
 VT_SEQ       INTEGER  := 1; -- CONTROLA A SEQUENCIA DENTRO DO VOUCHER
 VT_DOC_ANT   CHAR(7)  := NULL; -- CONTEM O DOCUMENTO ANTERIORMENTE PROCESSADO

 CURSOR C_LAN IS
 SELECT CTB_MOVIMENTO_IMP_VOUCHER   VOUCHER,
        CTB_MOVIMENTO_IMP_PAGAMENTO PAGAMENTO,
        CTB_MOVIMENTO_IMP_DTMOVTO   DATA,
        SUBSTR(REPLACE_ALL(CTB_PCONTA_CODIGO_PARTIDA,'.',''),1,12)   DEBITO,
        SUBSTR(REPLACE_ALL(CTB_PCONTA_CODIGO_CPARTIDA,'.',''),1,12)  CREDITO,
        SUBSTR(CTB_MOVIMENTO_IMP_DTMOVTO,7.4)||SUBSTR(CTB_MOVIMENTO_IMP_DTMOVTO,4,2) REFR,
        CTB_MOVIMENTO_IMP_CLIENTE   CLIENTE,
        CTB_MOVIMENTO_IMP_DOCUMENTO DOCUMENTO,
        CTB_MOVIMENTO_IMP_VALOR     VALOR,
        CTB_MOVIMENTO_IMP_DESCRICAO DESCRICAO
  FROM TDVADM.T_CTB_MOVIMENTO_IMP
 ORDER BY CTB_MOVIMENTO_IMP_VOUCHER,LPAD(TRIM(CTB_MOVIMENTO_IMP_PAGAMENTO),5,'0');

BEGIN

  -- Verifica Parametro.

  IF UPPER(P_LAYOUT) NOT IN ('BANCOS','GERAL') THEN
    RAISE_APPLICATION_ERROR(-20001,'PARAMETRO '||P_LAYOUT||' INVALIDO! - UTILIZAR (B)ANCOS OU (I)MOBILIZADO.');
    END IF;

  -- Inicializa o Id de Referencia.

  INSERT INTO TDVADM.T_CTB_LINKCTL
  SELECT VT_ID,
         TRIM(VT_PROCNAME)||'('||TO_CHAR(SYSDATE,'DD/MM/YYYY')||')',
         OSUSER,
         MACHINE,
         TERMINAL,
         'E',-- sendo executado
         SYSDATE,
         null
    FROM V$SESSION
   WHERE AUDSID = SYS_CONTEXT('USERENV','SESSIONID')
     and rownum = 1;
  COMMIT;

  -- BANCOS

  IF UPPER(P_LAYOUT) = 'BANCOS' THEN
    FOR R_LAN IN C_LAN LOOP
      INSERT INTO TDVADM.T_CTB_MOVIMENTO (CTB_MOVIMENTO_DOCUMENTO,
                                   CTB_MOVIMENTO_DSEQUENCIA,
                                   CTB_MOVIMENTO_DTMOVTO,
                                   CTB_PCONTA_CODIGO_CPARTIDA,
                                   CTB_PCONTA_CODIGO_PARTIDA,
                                   CTB_REFERENCIA_CODIGO_PARTIDA,
                                   CTB_REFERENCIA_CODIGO_CPARTIDA,
                                   CTB_HISTORICO_CODIGO,
                                   CTB_MOVIMENTO_TDOCUMENTO,
                                   CTB_MOVIMENTO_VALOR,
                                   CTB_MOVIMENTO_TVALOR,
                                   CTB_MOVIMENTO_DESCRICAO,
                                   CTB_MOVIMENTO_SYSDATE,
                                   CTB_MOVIMENTO_ORIGEM,
                                   GLB_CENTROCUSTO_CODIGO,
                                   GLB_CENTROCUSTO_CODIGOC, 
                                   CTB_MOVIMENTO_LINKID,
                                   CTB_MOVIMENTO_ORIGEMPR)
                            VALUES (TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')),
                                    1,
                                    R_LAN.DATA,
                                    R_LAN.CREDITO,
                                    R_LAN.DEBITO,
                                    R_LAN.REFR,
                                    R_LAN.REFR,
                                    '999',
                                    '1',
                                    R_LAN.VALOR,
                                    'D',
                                    SUBSTR(R_LAN.DESCRICAO,1,60),
                                    SYSDATE,
                                    VT_ORG,
                                    NULL,
                                    NULL,
                                    VT_ID,
                                    VT_ORG);

       INSERT INTO TDVADM.T_CTB_MOVIMENTO (CTB_MOVIMENTO_DOCUMENTO,
                                    CTB_MOVIMENTO_DSEQUENCIA,
                                    CTB_MOVIMENTO_DTMOVTO,
                                    CTB_PCONTA_CODIGO_CPARTIDA,
                                    CTB_PCONTA_CODIGO_PARTIDA,
                                    CTB_REFERENCIA_CODIGO_PARTIDA,
                                    CTB_REFERENCIA_CODIGO_CPARTIDA,
                                    CTB_HISTORICO_CODIGO,
                                    CTB_MOVIMENTO_TDOCUMENTO,
                                    CTB_MOVIMENTO_VALOR,
                                    CTB_MOVIMENTO_TVALOR,
        	                          CTB_MOVIMENTO_DESCRICAO,
       	                            CTB_MOVIMENTO_SYSDATE,
       	                            CTB_MOVIMENTO_ORIGEM,
                                    GLB_CENTROCUSTO_CODIGO,
                                    GLB_CENTROCUSTO_CODIGOC, 
                                    CTB_MOVIMENTO_LINKID,
                                    CTB_MOVIMENTO_ORIGEMPR)
                            VALUES (TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')),
                                    2,
                                    R_LAN.DATA,
                                    R_LAN.DEBITO,
                                    R_LAN.CREDITO,
                                    R_LAN.REFR,
                                    R_LAN.REFR,
                                    '999',
                                    '1',
                                    R_LAN.VALOR,
                                    'C',
                                    SUBSTR(R_LAN.DESCRICAO,1,60),
                                    SYSDATE,
                                    VT_ORG,
                                    NULL,
                                    NULL,
                                    VT_ID,
                                    VT_ORG);
      END LOOP; -- FINAL DO LAYOUT (B)
    END IF;  -- FINAL DO LAYOUT (B)

  -- IMOBILIZADO
 
  IF UPPER(P_LAYOUT) = 'GERAL' THEN
    
    FOR R_LAN IN C_LAN LOOP

      IF TRIM(R_LAN.VOUCHER) <> VT_DOC_ANT THEN
         VT_SEQ :=1; -- CONTROLA SEQUENCIA DENTRO DO VOUCHER
        END IF;
         
      INSERT INTO TDVADM.T_CTB_MOVIMENTO (CTB_MOVIMENTO_DOCUMENTO,
                                   CTB_MOVIMENTO_DSEQUENCIA,
                                   CTB_MOVIMENTO_DTMOVTO,
                                   CTB_PCONTA_CODIGO_CPARTIDA,
                                   CTB_PCONTA_CODIGO_PARTIDA,
                                   CTB_REFERENCIA_CODIGO_PARTIDA,
                                   CTB_REFERENCIA_CODIGO_CPARTIDA,
                                   CTB_HISTORICO_CODIGO,
                                   CTB_MOVIMENTO_TDOCUMENTO,
                                   CTB_MOVIMENTO_VALOR,
                                   CTB_MOVIMENTO_TVALOR,
                                   CTB_MOVIMENTO_DESCRICAO,
                                   CTB_MOVIMENTO_SYSDATE,
                                   CTB_MOVIMENTO_ORIGEM,
                                   GLB_CENTROCUSTO_CODIGO,
                                   GLB_CENTROCUSTO_CODIGOC, 
                                   CTB_MOVIMENTO_LINKID,
                                   CTB_MOVIMENTO_ORIGEMPR)
                            VALUES (TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')),
                                    VT_SEQ,
                                    R_LAN.DATA,
                                    R_LAN.CREDITO,
                                    R_LAN.DEBITO,
                                    R_LAN.REFR,
                                    R_LAN.REFR,
                                    '999',
                                    '1',
                                    R_LAN.VALOR,
                                    'D',
                                    SUBSTR(R_LAN.DESCRICAO,1,60),
                                    SYSDATE,
                                    VT_ORG,
                                    TRIM(TO_CHAR(SUBSTR(R_LAN.CLIENTE,1,4),'0000')),
                                    TRIM(TO_CHAR(SUBSTR(R_LAN.DOCUMENTO,1,4),'0000')),
                                    VT_ID,
                                    VT_ORG);
      VT_SEQ := VT_SEQ+1;

      INSERT INTO TDVADM.T_CTB_MOVIMENTO (CTB_MOVIMENTO_DOCUMENTO,
                                   CTB_MOVIMENTO_DSEQUENCIA,
                                   CTB_MOVIMENTO_DTMOVTO,
                                   CTB_PCONTA_CODIGO_CPARTIDA,
                                   CTB_PCONTA_CODIGO_PARTIDA,
                                   CTB_REFERENCIA_CODIGO_PARTIDA,
                                   CTB_REFERENCIA_CODIGO_CPARTIDA,
                                   CTB_HISTORICO_CODIGO,
                                   CTB_MOVIMENTO_TDOCUMENTO,
                                   CTB_MOVIMENTO_VALOR,
                                   CTB_MOVIMENTO_TVALOR,
                                   CTB_MOVIMENTO_DESCRICAO,
                                   CTB_MOVIMENTO_SYSDATE,
                                   CTB_MOVIMENTO_ORIGEM,
                                   GLB_CENTROCUSTO_CODIGO,
                                   GLB_CENTROCUSTO_CODIGOC, 
                                   CTB_MOVIMENTO_LINKID,
                                   CTB_MOVIMENTO_ORIGEMPR)
                            VALUES (TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')),
                                    VT_SEQ,
                                    R_LAN.DATA,
                                    R_LAN.DEBITO,
                                    R_LAN.CREDITO,
                                    R_LAN.REFR,
                                    R_LAN.REFR,
                                    '999',
                                    '1',
                                    R_LAN.VALOR,
                                    'C',
                                    SUBSTR(R_LAN.DESCRICAO,1,60),
                                    SYSDATE,
                                    VT_ORG,
                                    TRIM(TO_CHAR(SUBSTR(R_LAN.CLIENTE,1,4),'0000')),
                                    TRIM(TO_CHAR(SUBSTR(R_LAN.DOCUMENTO,1,4),'0000')),
                                    VT_ID,
                                    VT_ORG);
      VT_SEQ := VT_SEQ+1;
      VT_DOC_ANT := TRIM(R_LAN.VOUCHER);
                                   
      END LOOP;  -- FINAL DO LAYOUT (I)
    END IF;  -- FINAL DO LAYOUT (I)
    
    /* Analista : MALCAR
       Data     : 29/11/2019
       Alteracao : Finalizando o processo na tabela LINKCTB
    */
    
    UPDATE TDVADM.T_CTB_LINKCTL C
       SET C.CTB_LINKCTL_STATUS = NULL,
           C.CTB_LINKCTL_SYSDATEFIM = SYSDATE
     WHERE C.CTB_LINKCTL_ID = VT_ID;
    
  COMMIT;
  END;

 
/
