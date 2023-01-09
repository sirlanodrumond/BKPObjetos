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

 VT_PROCNAME  CHAR(25)     := 'SP_LINK_CTB_IMP';
 VT_ID        CHAR(25)     := FN_IDEXEC(TRIM(VT_PROCNAME));
 VT_ORG       CHAR(1)      := '9'; -- IMPORTAÇÃO DE DADOS DO EXCEL
 VT_SEQ       INTEGER      := 1; -- CONTROLA A SEQUENCIA DENTRO DO VOUCHER
 VT_DOC_ANT   CHAR(7)      := NULL; -- CONTEM O DOCUMENTO ANTERIORMENTE PROCESSADO
 vVersao      varchar2(15) := 'SIRLANO'; --'ROBERTO PARIZ'
 vMovimentoOK char(1)      := 'S';
 cCritica     cLob         := empty_clob;
 vAuxiliar    integer      := 0;
 vCC          tdvadm.t_ctb_movimento.glb_centrocusto_codigo%type;
 vCCC         tdvadm.t_ctb_movimento.glb_centrocusto_codigoc%type;
 vRefCTB      char(6);
 vErro        integer := 0;
 vOk          Integer := 0;
 TpBenesseRec rmadm.t_glb_benasserec%rowtype;
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
        CTB_MOVIMENTO_IMP_DESCRICAO DESCRICAO,
        CTB_MOVIMENTO_IMP_PROTOCOLO PROTOCOLO
  FROM TDVADM.T_CTB_MOVIMENTO_IMP
 ORDER BY CTB_MOVIMENTO_IMP_VOUCHER,LPAD(TRIM(CTB_MOVIMENTO_IMP_PAGAMENTO),5,'0');

BEGIN

  -- Verifica Parametro.

  IF UPPER(nvl(P_LAYOUT,'GERAL')) NOT IN ('BANCOS','GERAL') THEN
    RAISE_APPLICATION_ERROR(-20001,'PARAMETRO '||nvl(P_LAYOUT,'GERAL')||' INVALIDO! - UTILIZAR (B)ANCOS OU (I)MOBILIZADO.');
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
  
  select p.usu_perfil_parat
    into vRefCTB
  from tdvadm.t_usu_perfil p
  where p.usu_perfil_codigo = 'REFFECHAMENTOCTB';

  -- BANCOS
  If vVersao = 'SOMENTE PARA DOCUMENTAR' Then
     VT_SEQ := 1;
  ElsIf vVersao = 'ROBERTO PARIZ' Then
        IF UPPER(nvl(P_LAYOUT,'GERAL')) = 'BANCOS' THEN
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
       
        IF UPPER(nvl(P_LAYOUT,'GERAL')) = 'GERAL' THEN
          
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
  ElsIf vVersao = 'SIRLANO' Then
     FOR R_LAN IN C_LAN 
        LOOP
           If ( TpBenesseRec.Glb_Benasserec_Chave is null ) and ( r_lan.protocolo is not null ) Then
              select br.*
                 into TpBenesseRec
              from rmadm.t_glb_benasserec br
              where br.glb_benasserec_chave = r_lan.protocolo;
           End If;
           vMovimentoOK := 'S';
           
           If UPPER(nvl(P_LAYOUT,'GERAL')) = 'GERAL' THEN
              vCC := TRIM(TO_CHAR(SUBSTR(R_LAN.CLIENTE,1,4),'0000'));
              vCCC := TRIM(TO_CHAR(SUBSTR(R_LAN.DOCUMENTO,1,4),'0000'));
           ElsIf UPPER(nvl(P_LAYOUT,'GERAL')) = 'BANCOS' THEN
              vCC  := NULL;
              vCCC := NULL;
              VT_SEQ := 1;
           End If;
           
           -- Verifica se a Referencia esta Fechada
           
           If r_lan.refr < vRefCTB Then
              vMovimentoOK := 'N';
              cCritica := cCritica || 'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Referencia ' || r_lan.refr || ' Ja Fechada' || chr(10);
           End If;
           
           -- Critica Referencia
           select count(*)
             into vAuxiliar
           from tdvadm.t_ctb_movimento m
           where to_char(m.ctb_movimento_dtmovto,'YYYYMM') = r_lan.refr;
           
           If vAuxiliar = 0 Then
              vMovimentoOK := 'N';
              cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Referencia ' || r_lan.refr || ' nao Exite no movimento' || chr(10);
           End If;
           
           Select count(*)
             into vAuxiliar
           From tdvadm.t_ctb_pconta pc
           where pc.ctb_pconta_codigo = r_lan.debito
             and pc.ctb_pconta_grau = '5';
           
           If vAuxiliar = 0 Then
              vMovimentoOK := 'N';
              cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Conta ' || r_lan.debito || ' nao Exite no Plano de Contas ou nao e do QUINTO GRAU' || chr(10);
           End If;
           
           Select count(*)
             into vAuxiliar
           From tdvadm.t_ctb_pconta pc
           where pc.ctb_pconta_codigo = r_lan.credito
             and pc.ctb_pconta_grau = '5';
           
           If vAuxiliar = 0 Then
              vMovimentoOK := 'N';
              cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Conta ' || r_lan.credito || ' nao Exite no Plano de Contas ou nao e do QUINTO GRAU' || chr(10);
           End If;

           If r_lan.valor <= 0 Then
              vMovimentoOK := 'N';
              cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Valor ' || r_lan.valor || ' Tem que ser maior que ZERO' || chr(10);
           End If;
           
           If substr(r_lan.credito,1,1) in ('3','4') Then
              If vCC is null Then
                 vMovimentoOK := 'N';
                 cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Conta Credito ' || r_lan.credito || ' Exige Centro de Custo' || chr(10);
              End If;
           End If;

           If substr(r_lan.debito,1,1) in ('3','4') Then 
              If vCC is null Then
                 vMovimentoOK := 'N';
                 cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Conta Debito ' || r_lan.debito || ' Exige Centro de Custo' || chr(10);
              End If;
           End If;
           
           If vCC is not null Then
              Select count(*)
                into vAuxiliar
              From tdvadm.t_glb_centrocusto cc
              where cc.glb_centrocusto_codigo = vCC;
           
              If vAuxiliar = 0 Then
                 vMovimentoOK := 'N';
                 cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Centro Custo ' || vCC || ' nao Exite ' || chr(10);
              End If;
           End If;
           
           If vCCC is not null Then
              Select count(*)
                into vAuxiliar
              From tdvadm.t_glb_centrocusto cc
              where cc.glb_centrocusto_codigo = vCCC;
           
              If vAuxiliar = 0 Then
                 vMovimentoOK := 'N';
                 cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Centro Custo Contrato ' || vCCC || ' nao Exite ' || chr(10);
              End If;
           End If;  
           
           
           If length(trim(r_lan.descricao)) > 60 then
              vMovimentoOK := 'N';
              cCritica := cCritica ||  'Documento ' || TRIM(TO_CHAR(R_LAN.VOUCHER,'0000000')) || ' Historico com mais de 60 Digitos, tamanho ' || length(trim(r_lan.descricao)) || chr(10);
           End If;
           
           If vMovimentoOK = 'S' Then
              vOk := vOk + 1;
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
                                             vCC,
                                             vCCC,
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
                                             vCC,
                                             vCCC,
                                             VT_ID,
                                             VT_ORG);
               VT_SEQ := VT_SEQ+1;
               VT_DOC_ANT := TRIM(R_LAN.VOUCHER);
           Else
              vErro := vErro + 1;
           End If;
       End Loop;
  End If; --
    /* Analista : MALCAR
       Data     : 29/11/2019
       Alteracao : Finalizando o processo na tabela LINKCTB
    */

    IF vErro > 0 Then
       cCritica := 'INTEGRACAO NAO FOI GRAVADA| PROBLEMAS ' || chr(10) || chr(10) || 
                   vOk || ' Registros OK' || chr(10) || 
                   vErro || ' Registros Com erro,   ' || chr(10) || chr(10) || 
                   cCritica;
    Else
       cCritica := vOk || ' Registros Gravados' || chr(10) || chr(10) || 
                   cCritica;
    End If;
    If TpBenesseRec.Glb_Benasserec_Chave is not null Then
       cCritica :=  'PROTOCOLO - ' || to_char(TpBenesseRec.Glb_Benasserec_Chave) || chr(10) ||
                    'Remtente  - ' || TpBenesseRec.Glb_Benasserec_Origem || chr(10) ||
                    'Anexo     - ' || TpBenesseRec.Glb_Benasserec_Fileanexoorig || chr(10) ||
                    '*****************************************************************************' || chr(10) ||
                    cCritica;
       
    End If;   


  
  If vErro = 0 Then  
     COMMIT;
  Else
     ROLLBACK;
  End If;

    UPDATE TDVADM.T_CTB_LINKCTL C
       SET C.CTB_LINKCTL_STATUS = NULL,
           C.CTB_LINKCTL_SYSDATEFIM = SYSDATE
     WHERE C.CTB_LINKCTL_ID = VT_ID;
           
    wservice.pkg_glb_email.SP_ENVIAEMAIL(P_ASSUNTO => 'CRITICA LEITURA PLANILHA',
                                         P_TEXTO => cCritica,
                                         P_ORIGEM => 'aut-e@dellavolpe.com.br',
                                         P_DESTINO => 'cfaria@dellavolpe.com.br',
                                         P_COPIA => 'sirlano.drumond@dellavolpe.com.br',
                                         P_COPIA2 => null);
    commit;

  END;

 
/
