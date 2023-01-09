CREATE OR REPLACE TRIGGER TG_AIU_TRANS_FATURA_CRECEBER
before INSERT OR UPDATE OF CON_FATURA_STATUS ON TDVADM.T_CON_FATURA
FOR EACH ROW
DECLARE
  V_CGCCPF_CODIGO           T_CON_FATURA.GLB_CLIENTE_CGCCPFSACADO%TYPE;
  V_TITRECEBER_SAQUE        T_CRP_TITRECEBER.CRP_TITRECEBER_SAQUE%TYPE;
  V_NUMTITBANCO_NUMERO      T_CRP_TITRECEBER.CRP_NUMTITBANCO_NUMERO%TYPE;
  V_TPCARTERIA_CODIGO       T_CRP_TPCARTEIRA.CRP_TPCARTERIA_CODIGO%TYPE;
  V_AGENCIA_NUMERO          T_GLB_CONTAS.GLB_AGENCIA_NUMERO%TYPE;
  V_BANCO_NUMERO            T_GLB_CONTAS.GLB_BANCO_NUMERO%TYPE;
  V_CONTAS_NUMERO           T_GLB_CONTAS.GLB_CONTAS_NUMERO%TYPE;
  V_MOEDA_CODIGO            T_GLB_MOEDA.GLB_MOEDA_CODIGO%TYPE;
  V_TXMORA_CODIGO           T_GLB_TXMORA.GLB_TXMORA_CODIGO%TYPE;
  V_CTRLBORDERO_NUMERO      T_CRP_CTRLBODERO.CRP_CTRLBODERO_NUMERO%TYPE;
  VCRP_TITRECEBER_NUMTITULO T_CRP_TITRECEBER.CRP_TITRECEBER_NUMTITULO%TYPE;
  VCRP_TITRECEBER_SAQUE     T_CRP_TITRECEBER.CRP_TITRECEBER_SAQUE%TYPE;
  VGLB_ROTA_CODIGO          T_CRP_TITRECEBER.GLB_ROTA_CODIGO%TYPE;
  VCRP_NUMTITBANCO_NUMERO   T_CRP_TITRECEBER.CRP_NUMTITBANCO_NUMERO%TYPE;
  V_DATACTB                 DATE;
  V_PAGTOS                  INTEGER;
  VCODIGOEVT                CHAR(4);
  vAplicacao                v_glb_ambiente.PROGRAM%type;  
  vAuxiliar                 varchar2(10);
  v1pra1                    number;
  vTipoRateio               tdvadm.t_crp_titrecevento.crp_titreceber_rateio%type;
  vDocRateio                tdvadm.t_crp_titrecevento.crp_titrecevento_docrateio%type;
  tpConhecFat               tdvadm.t_con_conhecfaturado%rowtype;
  vSerie                    char(2);
  vImpCLi                   tdvadm.t_glb_cliente.glb_cliente_tipodesconto%type;
  vISSRet                   tdvadm.t_glb_cliente.glb_cliente_issret%type;
  v_imposto                 tdvadm.t_con_fatura.con_fatura_descimposto%type;
  vPerDesc                  number;
BEGIN
  
  BEGIN 
     SELECT CO.CON_CONHECIMENTO_SERIE
       INTO vSerie
       FROM TDVADM.T_CON_CONHECIMENTO CO
      WHERE CO.CON_FATURA_CODIGO        = :NEW.CON_FATURA_CODIGO
        AND CO.GLB_ROTA_CODIGOFILIALIMP = :NEW.GLB_ROTA_CODIGOFILIALIMP
        AND CO.CON_FATURA_CICLO         = :NEW.CON_FATURA_CICLO;
  EXCEPTION
    WHEN OTHERS THEN
      vSerie := 'A1';
  END;
  
  V_CGCCPF_CODIGO := :NEW.GLB_CLIENTE_CGCCPFSACADO;
  
  select m.PROGRAM
    into vAplicacao
   from v_glb_ambiente m;  
  
  

  IF (:NEW.CON_FATURA_STATUS = 'I' /*AND :NEW.CON_FATURA_DATAEMISSAO >= '01/01/2007'*/
     ) OR (:NEW.CON_FATURA_CODIGO = '843247') THEN



    /* verifica se a Fatura Tem CTe */
    
        /* PEGA O BANCO RELACIONADO AO CLIENTE */
        BEGIN
          SELECT GLB_BANCO_NUMERO, 
                 GLB_CLIENTE_TPBOLETO, 
                 CRP_TPCARTERIA_CODIGO,
                 cl.glb_cliente_tipodesconto,
                 cl.glb_cliente_issret
            INTO V_BANCO_NUMERO, 
                 V_CTRLBORDERO_NUMERO, 
                 V_TPCARTERIA_CODIGO,
                 vImpCLi,
                 vISSRet
            FROM T_GLB_CLIENTE cl
           WHERE GLB_CLIENTE_CGCCPFCODIGO = :NEW.GLB_CLIENTE_CGCCPFSACADO;
          /* PEGA A AGENCIA E A CONTA DO DEFAULT */
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'SEM CLIENTE');
        END;
        BEGIN
          SELECT distinct GLB_AGENCIA_NUMERO, glb_contas_numero  
            INTO V_AGENCIA_NUMERO, V_CONTAS_NUMERO
            FROM T_GLB_CONTAS
           WHERE GLB_BANCO_NUMERO = V_BANCO_NUMERO
             AND GLB_CONTAS_DEFALT = 'S';
          /**/
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'SEM AGENCIA');
          WHEN ToO_MANY_ROWS Then
            RAISE_APPLICATION_ERROR(-20001, 'Verifique tabela de contas DEFAULT para o Banco ' || V_BANCO_NUMERO);
        END;
        BEGIN
          SELECT GLB_BANCO_NUMIDBANCO
            INTO V_NUMTITBANCO_NUMERO
            FROM T_GLB_BANCO
           WHERE GLB_BANCO_NUMERO = V_BANCO_NUMERO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'SEM BANCO');
        END;
        BEGIN
          SELECT GLB_MOEDA_CODIGO
            INTO V_MOEDA_CODIGO
            FROM T_GLB_MOEDA
           WHERE GLB_MOEDA_PAIS = 'S';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'SEM MOEDA');
        END;
        BEGIN
          SELECT GLB_TXMORA_CODIGO
            INTO V_TXMORA_CODIGO
            FROM T_GLB_TXMORA
           WHERE GLB_TXMORA_DEFALT = 'S';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'SEM TAXA');
        END;
        
      IF :NEW.CON_FATURA_DESCIMPOSTO is null  and vImpCLi = 'I' Then
            v_imposto := null;
            vPerDesc  := null;
            for c_msg in (select tc.slf_tpcalculo_formulario Formulario,
                                 cc.con_calcviagem_valor valor
                          from tdvadm.t_con_calcconhecimento cc,
                               tdvadm.t_con_conhecimento c,
                               tdvadm.t_slf_tpcalculo tc,
                               tdvadm.t_glb_cliente cl
                          where cc.con_conhecimento_codigo = c.con_conhecimento_codigo
                            and cc.con_conhecimento_serie = c.con_conhecimento_serie
                            and cc.glb_rota_codigo = c.glb_rota_codigo
                            and cc.slf_tpcalculo_codigo = tc.slf_tpcalculo_codigo
                            and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                            and cl.glb_cliente_tipodesconto = 'I'
                            and cc.slf_reccust_codigo in ('S_ALICMS','S_ALISS')     
                            and c.con_fatura_codigo = :new.con_fatura_codigo
                            and c.glb_rota_codigofilialimp = :new.glb_rota_codigofilialimp
                           order by cc.con_calcviagem_valor desc)
            Loop
               If c_msg.formulario = 'N' Then
                  v_imposto := 'ISS';
               Else
                  v_imposto := 'ICMS';
               End If; 
               vPerDesc := c_msg.valor;
               If ( vPerDesc > 0 ) and      -- Tem Aliquota para Calcular imposto
                  ( v_imposto = 'ISS' ) and -- E Calculo de ISS
                  ( vISSRet = 'S' ) Then    -- Tem retenção do ISS pelo Cliente
                  :NEW.CON_FATURA_DESCONTO := round(:new.con_fatura_valorcobrado * (vPerDesc/100) ,2);
                  :NEW.Con_Fatura_Obsdesconto := 'DESCONTO DE ' || v_imposto;
               End If;
            End Loop;
            :NEW.CON_FATURA_DESCIMPOSTO := v_imposto;
      End IF;   
      IF :NEW.CON_FATURA_DESCIMPOSTO = 'ICMS' THEN
         VCODIGOEVT := '0136';
      ELSIF :NEW.CON_FATURA_DESCIMPOSTO = 'ISS' THEN
         VCODIGOEVT := '0013';
      ELSE
         VCODIGOEVT := '0004';
      END IF;

        
        
        
        
        -- INSERT INTO DROPME (CX) VALUES('PASSEI SELECT TXMORA'); COMMIT;
        --RAISE_APPLICATION_ERROR(-20001, :NEW.CON_FATURA_CODIGO);
        vAuxiliar := pkg_glb_common.GET_SISTEMAFECHAMENTO('CTB','R');
        vAuxiliar := to_char(:NEW.CON_FATURA_DATAEMISSAO,'yyyymm');
        
        IF :NEW.CON_FATURA_CODIGO NOT IN ('032985','981997','018959') then
        if pkg_glb_common.GET_SISTEMAFECHAMENTO('CTB','R') >= to_char(:NEW.CON_FATURA_DATAEMISSAO,'yyyymm') Then
           RAISE_APPLICATION_ERROR(-20001, 'Sistema CONTABIL FECHADO em - ' || pkg_glb_common.GET_SISTEMAFECHAMENTO('CTB','R'));
        End IF;
        vAuxiliar := pkg_glb_common.GET_SISTEMAFECHAMENTO('CRP','R');
        vAuxiliar := to_char(:NEW.CON_FATURA_DATAEMISSAO,'yyyymm');

        if pkg_glb_common.GET_SISTEMAFECHAMENTO('CRP','R') >= to_char(:NEW.CON_FATURA_DATAEMISSAO,'yyyymm') Then
           RAISE_APPLICATION_ERROR(-20001, 'Sistema de Contas a RECEBER FECHADO em - ' || pkg_glb_common.GET_SISTEMAFECHAMENTO('CPG','R'));
        End IF;
        end If;
        V_TITRECEBER_SAQUE := PKG_CRP_TITRECEBER.fn_get_Saque(:NEW.GLB_ROTA_CODIGOFILIALIMP);



  
        
        BEGIN
          INSERT INTO T_CRP_TITRECEBER
            (GLB_ROTA_CODIGO,
             CRP_TITRECEBER_NUMTITULO,
             GLB_AGENCIA_NUMERO,
             CRP_TITRECEBER_SAQUE,
             CRP_TPCARTERIA_CODIGO,
             GLB_BANCO_NUMERO,
             GLB_CONTAS_NUMERO,
             GLB_MOEDA_CODIGO,
             GLB_TXMORA_CODIGO,
             CRP_TPBAIXA_CODIGO,
             CON_FATURA_CODIGO,
             CON_FATURA_CICLO,
             GLB_ROTA_CODIGOFILIALIMP,
             CRP_CTRLBODERO_NUMERO,
             CRP_NUMTITBANCO_NUMERO,
             CRP_TITRECEBER_VLRPGBANCO,
             CRP_TITRECEBER_DESCONTO,
             CRP_TITRECEBER_DTBAIXA,
             CRP_TITRECEBER_DTLIMTDESC,
             CRP_TITRECEBER_PROTESTADO,
             CRP_TITRECEBER_USUALTEROU,
             CRP_TITRECEBER_DTGERACAO,
             CRP_TITRECEBER_NUMBOLETIM,
             CRP_TITRECEBER_DTALTERACAO,
             CRP_TITRECEBER_CANCELADO,
             CRP_TITRECEBER_ENVBANCO,
             CRP_TITRECEBER_SERIE,
             CRP_TITRECEBER_DTVENCIMENTO,
             CRP_TITRECEBER_VLRCOBRADO,
             CRP_TITRECEBER_DTPREVPAG,
             GLB_CLIENTE_CGCCPFCODIGO)
          VALUES
            (:NEW.GLB_ROTA_CODIGOFILIALIMP,
             :NEW.CON_FATURA_CODIGO,
             V_AGENCIA_NUMERO,
             V_TITRECEBER_SAQUE,
             V_TPCARTERIA_CODIGO,
             V_BANCO_NUMERO,
             V_CONTAS_NUMERO,
             V_MOEDA_CODIGO,
             V_TXMORA_CODIGO,
             NULL,
             :NEW.CON_FATURA_CODIGO,
             :NEW.CON_FATURA_CICLO,
             :NEW.GLB_ROTA_CODIGOFILIALIMP,
             V_CTRLBORDERO_NUMERO,
             NULL,
             NULL,
             NULL, --:NEW.CON_FATURA_DESCONTO,
             NULL,
             TO_DATE(:NEW.CON_FATURA_DTLIMTDESC, 'DD/MM/YYYY'),
             NULL,
             NULL,
             :NEW.CON_FATURA_DATAEMISSAO, --TO_CHAR(SYSDATE,'DD/MM/YYYY'),
             NULL,
             NULL,
             NULL,
             NULL,
             :NEW.CON_FATURA_SERIE,
             TO_DATE(:NEW.CON_FATURA_DATAVENC, 'DD/MM/YYYY'),
             :NEW.CON_FATURA_VALORCOBRADO,
             TO_DATE(:NEW.CON_FATURA_DATAVENC, 'DD/MM/YYYY'),
             V_CGCCPF_CODIGO);
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            SP_INSERE_CONHEC_NF_FAT(:NEW.CON_FATURA_CODIGO,
                                    :NEW.CON_FATURA_CICLO,
                                    :NEW.GLB_ROTA_CODIGOFILIALIMP);
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003,
                                    SQLERRM || ' - ' || 'TABELA TITRECEBER');
        END;
        tdvadm.SP_INSERE_CONHEC_NF_FAT(:NEW.CON_FATURA_CODIGO,
                                       :NEW.CON_FATURA_CICLO,
                                       :NEW.GLB_ROTA_CODIGOFILIALIMP);
        -- VCODIGOEVT := '0004';                                                            
        IF :NEW.CON_FATURA_DESCIMPOSTO = 'ICMS' THEN
          VCODIGOEVT := '0136';
        ELSIF :NEW.CON_FATURA_DESCIMPOSTO = 'ISS' THEN
          VCODIGOEVT := '0013';
        ELSE
          VCODIGOEVT := '0004';
        END IF;
        BEGIN
            
        
        
            If :NEW.GLB_ROTA_CODIGOFILIALIMP not in ('015','010') then
               vTipoRateio := 'C';
               vDocRateio  := trim(trim(:NEW.CON_FATURA_CODIGO) || vSerie || trim(:NEW.GLB_ROTA_CODIGOFILIALIMP));
               select count(*)
                  into vAuxiliar
               from tdvadm.t_con_conhecimento c
               where c.con_conhecimento_codigo = trim(:NEW.CON_FATURA_CODIGO)
                 and c.con_conhecimento_serie = vSerie
                 and c.glb_rota_codigo = trim(:NEW.GLB_ROTA_CODIGOFILIALIMP);
                 
               if :NEW.GLB_ROTA_CODIGOFILIALIMP = '180' then
                  vSerie := 'A0';
               end if;
                 
               If vAuxiliar = 0 Then
                  vSerie := 'A0';
                  vDocRateio  := trim(trim(:NEW.CON_FATURA_CODIGO) || vSerie || trim(:NEW.GLB_ROTA_CODIGOFILIALIMP));
               End If;
            Else
               vTipoRateio := 'R';
               vDocRateio  := null;
            End If;
            
            If :NEW.Glb_Rota_Codigofilialimp <> '013' Then
               tpConhecFat.Con_Conhecimento_Codigo        := :NEW.CON_FATURA_CODIGO;
               tpConhecFat.Con_Conhecimento_Serie         := vSerie;
               tpConhecFat.Glb_Rota_Codigoconhec          := :NEW.Glb_Rota_Codigofilialimp;
               tpConhecFat.Con_Fatura_Codigo              := :NEW.Con_Fatura_Codigo;
               tpConhecFat.Con_Fatura_Ciclo               := :NEW.Con_Fatura_Ciclo;
               tpConhecFat.Glb_Rota_Codigofilialimp       := :NEW.Glb_Rota_Codigofilialimp;
               tpConhecFat.Glb_Rota_Codigotitrec          := :NEW.Glb_Rota_Codigofilialimp;
               tpConhecFat.Crp_Titreceber_Numtitulo       := :NEW.CON_FATURA_CODIGO;
               tpConhecFat.Crp_Titreceber_Saque           := V_TITRECEBER_SAQUE;
               select c.con_conhecimento_dtembarque
                  into tpConhecFat.Con_Conhecimento_Dtembarque
               from tdvadm.t_con_conhecimento c
               where c.con_conhecimento_codigo = :NEW.Con_Fatura_Codigo
                 and c.con_conhecimento_serie = vSerie
                 and c.glb_rota_codigo = :NEW.Glb_Rota_Codigofilialimp;

               tpConhecFat.Con_Conhecimento_Valor         := :NEW.Con_Fatura_Valorcobrado;
               tpConhecFat.Con_Conhecimento_Cgccpfsacado  := :NEW.Glb_Cliente_Cgccpfsacado;
               tpConhecFat.Con_Conhecfaturado_Pago        := 'N';
               tpConhecFat.Con_Conhecfaturado_Comprovante := null;
               tpConhecFat.Con_Conhecfaturado_Valorpago   := 0;
               tpConhecFat.Con_Conhecfaturado_Dtbaixa     := null;
               tpConhecFat.Con_Conhecfaturado_Desconto    := :NEW.Con_Fatura_Desconto;
               tpConhecFat.Con_Conhecfaturado_Vlracres    := 0;
               tpConhecFat.Con_Conhecfaturado_Despcart    := 0;
               tpConhecFat.Con_Conhecfaturado_Despjuros   := 0;
               tpConhecFat.Con_Conhecfaturado_Despoutros  := 0;             
               begin
                  insert into tdvadm.t_con_conhecfaturado values tpConhecFat;
               exception
                 When DUP_VAL_ON_INDEX Then
                   tpConhecFat.Con_Conhecfaturado_Despoutros  := 0;     
                 End;
          End If;  
          IF NVL(:NEW.CON_FATURA_DESCONTO, 0) > 0 THEN
            
            INSERT INTO TDVADM.T_CRP_TITRECEVENTO
              (CRP_TITRECEVENTO_OBS,
               GLB_ROTA_CODIGO,
               CRP_TITRECEBER_NUMTITULO,
               CRP_TITRECEBER_SAQUE,
               CRP_TITRECEVENTO_SEQ,
               GLB_EVENTO_CODIGO,
               CRP_TITRECEVENTO_DTEVENTO,
               GLB_BANCO_NUMERO,
               GLB_AGENCIA_NUMERO,
               GLB_CONTAS_NUMERO,
               GLB_TPDOC_CODIGO,
               CRP_TITRECEVENTO_NRODOC,
               CRP_TITRECEVENTO_AUTORIZADOR,
               CRP_TITRECEVENTO_DATA,
               CRP_TITRECEVENTO_DATACTB,
               USU_USUARIO_CODIGO,
               CRP_TITRECEVENTO_DATAGRV,
               CRP_TITRECEVENTO_CCUSTO,
               CRP_TITRECEVENTO_CRESP,
               CRP_TITRECEVENTO_VALOR,
               CRP_TITRECEBER_RATEIO,
               CRP_TITRECEVENTO_DOCRATEIO)
            VALUES
              (:NEW.CON_FATURA_OBSDESCONTO,
               :NEW.GLB_ROTA_CODIGOFILIALIMP,
               :NEW.CON_FATURA_CODIGO,
               V_TITRECEBER_SAQUE,
               1,
               VCODIGOEVT,
               :NEW.CON_FATURA_DATAEMISSAO,
               V_BANCO_NUMERO,
               V_AGENCIA_NUMERO,
               V_CONTAS_NUMERO,
               'FAT',
               :NEW.CON_FATURA_CODIGO || '-' || :NEW.CON_FATURA_CICLO || '-' || :NEW.GLB_ROTA_CODIGOFILIALIMP,
               'sistema',
               :NEW.CON_FATURA_DATAEMISSAO,
               NULL,
               :NEW.USU_USUARIO_CODIGO, --'PER_FATURA',
               SYSDATE,
               NULL,
               NULL,
               :NEW.CON_FATURA_DESCONTO,
               vTipoRateio,
               vDocRateio);

               update tdvadm.t_crp_titreceber tr
                  set tr.crp_titreceber_desconto = 0
                  where tr.glb_rota_codigo = V_TITRECEBER_SAQUE
                    and tr.crp_titreceber_numtitulo = :NEW.CON_FATURA_CODIGO
                    and tr.glb_rota_codigo = :NEW.GLB_ROTA_CODIGOFILIALIMP;
                   iF :new.Con_Fatura_Codigo = '070785' Then
                       vTipoRateio := vTipoRateio;
                   End IF;
               tdvadm.sp_crp_rateiaevento(:new.Con_Fatura_Codigo,
                                          V_TITRECEBER_SAQUE,
                                          :NEW.GLB_ROTA_CODIGOFILIALIMP,
                                          1,
                                          :NEW.CON_FATURA_DESCONTO,
                                          vTipoRateio,
                                          vDocRateio);
          END IF;
        EXCEPTION

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,
                                    SQLERRM || chr(10) || 'TABELA TITRECEVENTO. USUARIO = '||:NEW.USU_USUARIO_CODIGO || CHR(10) || 
                                                        'tdvadm.sp_crp_rateiaevento( ' || :new.Con_Fatura_Codigo ||','||V_TITRECEBER_SAQUE ||','||:NEW.GLB_ROTA_CODIGOFILIALIMP ||',1,'|| :NEW.CON_FATURA_DESCONTO ||','||vTipoRateio ||','||vDocRateio  ||');');
        END;
      ELSIF (:NEW.CON_FATURA_STATUS = 'C' AND
            :NEW.CON_FATURA_DATAEMISSAO >= '01/01/2007') THEN
        BEGIN
          SELECT R.CRP_TITRECEBER_NUMTITULO,
                 R.CRP_TITRECEBER_SAQUE,
                 R.GLB_ROTA_CODIGO,
                 R.CRP_NUMTITBANCO_NUMERO,
                 (SELECT NVL(MAX(E.CRP_TITRECEVENTO_DATACTB),'31/12/2006')
                    FROM T_CRP_TITRECEVENTO E
                   WHERE E.CRP_TITRECEBER_NUMTITULO = R.CRP_TITRECEBER_NUMTITULO
                     AND E.CRP_TITRECEBER_SAQUE = R.CRP_TITRECEBER_SAQUE
                     AND E.GLB_ROTA_CODIGO = R.GLB_ROTA_CODIGO),
                 (SELECT COUNT(*)
                    FROM T_CRP_TITRECEVENTO E, T_GLB_EVENTO V
                   WHERE E.CRP_TITRECEBER_NUMTITULO = R.CRP_TITRECEBER_NUMTITULO
                     AND E.CRP_TITRECEBER_SAQUE = R.CRP_TITRECEBER_SAQUE
                     AND E.GLB_ROTA_CODIGO = R.GLB_ROTA_CODIGO
                     AND E.GLB_EVENTO_CODIGO = V.GLB_EVENTO_CODIGO
                     AND TRIM(V.GLB_TPEVENTO_CODIGO) = 'P')
            INTO VCRP_TITRECEBER_NUMTITULO,
                 VCRP_TITRECEBER_SAQUE,
                 VGLB_ROTA_CODIGO,
                 VCRP_NUMTITBANCO_NUMERO,
                 V_DATACTB,
                 V_PAGTOS
            FROM T_CRP_TITRECEBER R
           WHERE R.CON_FATURA_CODIGO = :OLD.CON_FATURA_CODIGO
             AND R.CON_FATURA_CICLO = :OLD.CON_FATURA_CICLO
             AND R.GLB_ROTA_CODIGOFILIALIMP = :OLD.GLB_ROTA_CODIGOFILIALIMP;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            VCRP_TITRECEBER_NUMTITULO := NULL;
            VCRP_TITRECEBER_SAQUE     := NULL;
            VGLB_ROTA_CODIGO          := NULL;
        END;
        IF VCRP_TITRECEBER_NUMTITULO IS NOT NULL THEN
          IF (V_DATACTB = '31/12/2006') AND (V_PAGTOS = 0) THEN
            SP_CRP_CANCELATITULO_TG(VCRP_TITRECEBER_NUMTITULO,
                                    VCRP_TITRECEBER_SAQUE,
                                    VGLB_ROTA_CODIGO);
            INSERT INTO T_UTI_INFOMAIL
              (UTI_INFOMAIL_CODIGO,
               UTI_INFOMAIL_ENDMAILREMETENTE,
               UTI_INFOMAIL_NOMEREMETENTE,
               UTI_INFOMAIL_PERIODODT,
               UTI_INFOMAIL_PERIODODTSTART,
               UTI_INFOMAIL_PERIODOHR,
               UTI_INFOMAIL_PERIODOHRSTART,
               UTI_INFOMAIL_ENDMAILDESTINATAR,
               UTI_INFOMAIL_ENDDESTCOPIAS,
               UTI_INTOMAIL_ENDCOPIASOCULTAS,
               UTI_INFOMAIL_ASSUNTO,
               UTI_INFOMAIL_ARQANEXAR,
               UTI_INFOMAIL_MEMO,
               UTI_INFOMAIL_RPT,
               UTI_INFOMAIL_PROCEDURE,
               UTI_INFOMAIL_ARQANEXARTP,
               UTI_INFOMAIL_ORIGEM,
               UTI_INFOMAIL_EXECUTAVEL,
               UTI_INFOMAIL_ENVIASEMMOV,
               UTI_INFOMAIL_PRIORIDADE,
               UTI_INFOMAIL_CONFIRMAREC,
               UTI_INFOMAIL_LOGO)
            VALUES
              ('SEQUENCIAL',
               'TDV.OPERACAO@DELLAVOLPE.COM.BR',
               'ENVIO AUTOMATICO',
               1,
               SYSDATE,
               1,
               SYSDATE,
               'TDV.COBRANCA@DELLAVOLPE.COM.BR',
               'rpariz@DELLAVOLPE.COM.BR',
               '',
               'FATURA CANCELADA - CANCELAR TITULO',
               NULL,
               'O TITULO NR ' || VCRP_TITRECEBER_NUMTITULO || '-' ||
               VGLB_ROTA_CODIGO ||
               ' FOI CANCELADO. FAVOR VERIFICAR PROCEDIMENTOS COMPLEMENTARES DE CANCELAMENTO JUNTO AO BANCO E CARTEIRA.',
               NULL,
               NULL,
               'T',
               'A',
               NULL,
               'S',
               0,
               'S',
               'N');
          ELSE
            RAISE_APPLICATION_ERROR(-20001,
                                    'O TITULO POSSUI PAGAMENTOS OU FOI CONTABILIZADO. A FATURA N?O PODE SER CANCELADA!');
          END IF;
        END IF;
    Else
        V_CGCCPF_CODIGO := V_CGCCPF_CODIGO;
/*            INSERT INTO T_UTI_INFOMAIL
              (UTI_INFOMAIL_CODIGO,
               UTI_INFOMAIL_ENDMAILREMETENTE,
               UTI_INFOMAIL_NOMEREMETENTE,
               UTI_INFOMAIL_PERIODODT,
               UTI_INFOMAIL_PERIODODTSTART,
               UTI_INFOMAIL_PERIODOHR,
               UTI_INFOMAIL_PERIODOHRSTART,
               UTI_INFOMAIL_ENDMAILDESTINATAR,
           --    UTI_INFOMAIL_ENDDESTCOPIAS,
               UTI_INTOMAIL_ENDCOPIASOCULTAS,
               UTI_INFOMAIL_ASSUNTO,
               UTI_INFOMAIL_ARQANEXAR,
               UTI_INFOMAIL_MEMO,
               UTI_INFOMAIL_RPT,
               UTI_INFOMAIL_PROCEDURE,
               UTI_INFOMAIL_ARQANEXARTP,
               UTI_INFOMAIL_ORIGEM,
               UTI_INFOMAIL_EXECUTAVEL,
               UTI_INFOMAIL_ENVIASEMMOV,
               UTI_INFOMAIL_PRIORIDADE,
               UTI_INFOMAIL_CONFIRMAREC,
               UTI_INFOMAIL_LOGO)
            VALUES
              ('SEQUENCIAL',
               'TDV.OPERACAO@DELLAVOLPE.COM.BR',
               'ENVIO AUTOMATICO',
               1,
               SYSDATE,
               1,
               SYSDATE,
               'tdv.contasrcp@dellavolpe.com.br',
               -- 'tdv.cobranca@dellavolpe.com.br',
               'grp.hd@dellavolpe.com.br',
               'FATURA SEM TITULO',
               NULL,
               'O TITULO NR ' || :NEW.CON_FATURA_CODIGO || '-' ||
               :NEW.GLB_ROTA_CODIGOFILIALIMP ||
               'O usuario ' ||trim (:new.con_fatura_criador) || 'esta tentanto de imprimir fatura sem CTe.',
               NULL,
               NULL,
               'T',
               'A',
               NULL,
               'S',
               0,
               'S',
               'N');
*/      
        
  END IF;
END;
/
