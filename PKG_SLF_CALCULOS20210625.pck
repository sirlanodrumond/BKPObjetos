CREATE OR REPLACE PACKAGE PKG_SLF_CALCULOS IS
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
  STATUS_NORMAL         CONSTANT CHAR(1)       := 'N';
  STATUS_ERRO           CONSTANT CHAR(1)       := 'E';
  COLUNAS_TPCALCULO     CONSTANT NUMBER        :=  4;
  COLUNAS_CALCULO       CONSTANT NUMBER        := 32;
  COLUNAS_SEQCALCULO    CONSTANT NUMBER        :=  7;
 /* Typo utilizado como base para utilização dos Paramentros                                                                 */
 Type TpMODELO  is RECORD (CAMPO1         char(10),
                           CAMPO2         number(6));
   

 /* variaveis */
 
--  COLOCAR NA TRIGGER 
 vDebugCalculoUsuario Char(10) := 'uuuuuuuuuu';
 vDebugCalculoCTRC    Char(9) := 'CCCCCCRRR';
 V_VERBA_BREAKPOINT  char(10);

 vListaCNPJDIFAL     CONSTANT VARCHAR2(100) := '33592510005547;72372998000409;07157314000141;30722805000100';
 vListaCNPJcomDestaqueICMS varchar2(200) := '17469701010482;17469701001653;17469701005306;17469701008232;83249078000171;36785418001502;60643228061503;16404287044870';

-- 79600 ou 79601
-- 79600001
-- 16404287044870



  function fn_retorna_aliquota(pCodOrigem in t_glb_localidade.glb_localidade_codigo%type,
                               pDestimo   in t_glb_localidade.glb_localidade_codigo%type,
                               pRota      in t_glb_rota.glb_rota_codigo%type default null, -- Para os casos de NFs, se não passar volta o Default
                               pData      in date default trunc(sysdate))
     return number;                               

  function fn_Troca_tags(pConConhecimento IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                           pConSerie        IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                           pConRota         IN T_CON_CONHECIMENTO.Glb_Rota_Codigo%TYPE,
                           pObsCli        OUT VARCHAR2)
     return BOOLEAN;

 
   PROCEDURE SP_VERIFICA_ISENCAO_SUBST(P_SOLFRETE_CODIGO    IN CHAR, -- PODE SE UMA SOL OU TAB
                                       P_SOLFRETE_SAQUE     IN CHAR,
                                       P_LOCALIDADE_ORIGEM  IN CHAR,
                                       P_LOCALIDADE_DESTINO IN CHAR,
                                       P_ROTA_CODIGO        IN CHAR,
                                       P_MERCADORIA_CODIGO  IN CHAR,
                                       P_CLIENTE_REMETENTE  IN CHAR,
                                       P_CLIENTE_SACADO     IN CHAR,
                                       P_TIPORETORNO        IN OUT CHAR, -- INDICA SE E UMA TABELA OU SOLICITACAO
                                       P_DATAEMBARQUE       IN DATE,
                                       P_LEI                IN OUT T_SLF_ICMS.SLF_ICMS_DESCRICAOLEI%TYPE,
                                       P_CTRC               IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE DEFAULT NULL,
                                       P_SERIE              IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE DEFAULT NULL,
                                       P_ROTA               IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE DEFAULT NULL);
                                                      

  PROCEDURE SP_SLF_COPIACALCULO(P_CALCULOORIG   IN TDVADM.T_SLF_TPCALCULO.SLF_TPCALCULO_CODIGO%TYPE,
                                P_CALCULODEST   IN TDVADM.T_SLF_TPCALCULO.SLF_TPCALCULO_CODIGO%TYPE,
                                P_DESCRICAOCALC IN TDVADM.T_SLF_TPCALCULO.SLF_TPCODIGO_DESCRICAO%TYPE,
                                P_FORMULARIO    IN CHAR DEFAULT 'C',
                                P_STATUS        OUT CHAR,
                                P_MENSAGEM      OUT VARCHAR2);
                                
  PROCEDURE SP_MOVE_DADOS_CNHC_VIAG(V_NUMCONHEC_CLONE   IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    V_NUMCONHEC         IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    V_SERIECONHEC       IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    V_NUMVIAGEM_CLONE   IN T_CON_CALCVIAGEMDET.CON_VIAGEM_NUMERO%TYPE,
                                    V_SAQUEVIAGEM_CLONE IN T_CON_CALCVIAGEMDET.CON_VIAGAM_SAQUE%TYPE,
                                    V_ROTAVIAGEM_CLONE  IN T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                                    V_NUMFORMULARIO     IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_NRFORMULARIO%TYPE DEFAULT NULL);

  PROCEDURE SP_MONTA_FORMULA_CNHC(V_TIPOCALCULOPAI IN OUT tdvadm.t_slf_tpcalculo.slf_tpcalculo_codigo%TYPE,
                                  V_NUMERO IN tdvadm.t_con_conhecimento.con_conhecimento_codigo%TYPE,
                                  V_SAQUE_SERIE IN tdvadm.t_con_conhecimento.con_conhecimento_serie%TYPE,
                                  V_ROTA_CODIGO IN tdvadm.t_con_conhecimento.glb_rota_codigo%TYPE,
                                  V_INCLUIPED IN CHAR DEFAULT 'S');
  

  
  FUNCTION F_BUSCA_CONHEC_TPFORMULARIO(P_CONHECIMENTO_CODIGO IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                       P_CONHECIMENTO_SERIE  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                       P_ROTA_CODIGO         IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR;
                                        

END PKG_SLF_CALCULOS;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_SLF_CALCULOS AS



  function fn_retorna_aliquota(pCodOrigem in t_glb_localidade.glb_localidade_codigo%type,
                               pDestimo   in t_glb_localidade.glb_localidade_codigo%type,
                               pRota      in t_glb_rota.glb_rota_codigo%type default null, -- Para os casos de NFs, se não passar volta o Default
                               pData      in date default trunc(sysdate))
     return number                               
  As
    vRetorno    number;
    vUFOrigem  char(2);
    vUFDestino char(2);
    vRota      t_glb_rota.glb_rota_codigo%type;
    vData      date;
  Begin
    
     vRota := pRota; 
     vData := nvl(pData,trunc(sysdate));
    
      -- Pegando UF Origem
      Begin
          select l.glb_estado_codigo
            into vUFOrigem 
          from t_glb_localidade l
          where l.glb_localidade_codigo = pCodOrigem; 
      exception
        When NO_DATA_FOUND Then
           Begin
              select i.ufsigla
                into vUFOrigem
              from v_glb_ibge i
              where i.codmun = trim(pCodOrigem);  
           exception
             When NO_DATA_FOUND Then
                vUFOrigem := 'EX';
             End;
        End;
      -- Pegando UF destino
      Begin
          select l.glb_estado_codigo
            into vUFDestino 
          from t_glb_localidade l
          where l.glb_localidade_codigo = pDestimo; 
      exception
        When NO_DATA_FOUND Then
           Begin
              select i.ufsigla
                into vUFDestino
              from v_glb_ibge i
              where i.codmun = trim(pDestimo);  
           exception
             When NO_DATA_FOUND Then
                vUFDestino := 'EX';
             End;
        End;

     if vUFDestino <> 'EX' and  vUFDestino <> 'EX' Then
        if fn_busca_codigoibge(pCodOrigem,'IBC') <> fn_busca_codigoibge(pDestimo,'IBC') Then
          Begin
             select i.slf_icms_aliquota
               into vRetorno
             from t_slf_icms i
             where i.glb_estado_codigoorigem = vUFOrigem
               and i.glb_estado_codigodestino = vUFDestino
               and i.slf_icms_dataefetiva = (select max(i2.slf_icms_dataefetiva)
                                             from t_slf_icms i2
                                             where i2.glb_estado_codigoorigem = i.glb_estado_codigoorigem
                                               and i2.glb_estado_codigodestino = i.glb_estado_codigodestino
                                               and i2.slf_icms_dataefetiva < vData);
           Exception
             When NO_DATA_FOUND Then
                vRetorno := 0;
             End;                                      
        Else
           Begin
             select i.slf_iss_aliquota
               into vRetorno
             from t_slf_iss i
             where i.slf_tpcalculo_codigo = '115'
               and fn_busca_codigoibge(i.glb_localidade_codigo,'IBC') = fn_busca_codigoibge(pCodOrigem,'IBC')
               and i.glb_rota_codigo = vRota;
           Exception
             When NO_DATA_FOUND Then
               Begin
                   select i.slf_iss_aliquota
                     into vRetorno
                   from t_slf_iss i
                   where i.slf_tpcalculo_codigo = '115'
                     and fn_busca_codigoibge(i.glb_localidade_codigo,'IBC') = fn_busca_codigoibge(pCodOrigem,'IBC');
               Exception
                 When NO_DATA_FOUND Then
                     select i.slf_iss_aliquota
                       into vRetorno
                     from t_slf_iss i
                     where i.slf_tpcalculo_codigo = '115'
                       and i.slf_iss_default = 'S';
               End ;  
          End ;
          
        End If;
     Else
        vRetorno := 0;
     End If; 

     return vRetorno;

  End fn_retorna_aliquota; 

  function fn_Troca_tags(pConConhecimento IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                           pConSerie      IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                           pConRota       IN T_CON_CONHECIMENTO.Glb_Rota_Codigo%TYPE,
                           pObsCli        OUT VARCHAR2)
     return BOOLEAN
   As
      vValor       VARCHAR2(30);
      vDesinencia  VARCHAR2(30);
      vAlterou     boolean;
   Begin
    
    Begin 
      select cc.con_conhecimento_obscliente
        into pObsCli
      from t_con_conhecimento cc  
      WHERE Cc.CON_CONHECIMENTO_CODIGO = pConConhecimento
        AND Cc.CON_CONHECIMENTO_SERIE = pConSerie
        AND Cc.GLB_ROTA_CODIGO = pConRota;
    Exception
      When NO_DATA_FOUND Then
        pObsCli := null;
      End;

    vAlterou := False;
    if instr(pObsCli,'<<FRPSVO>>') > 0  Then

        begin
        select f_mascara_valor(ca.con_calcviagem_valor,10),
               ca.con_calcviagem_desinencia
           into vValor,
                vDesinencia
        from t_con_CalcConhecimento ca
        WHERE Ca.CON_CONHECIMENTO_CODIGO = pConConhecimento
          AND Ca.CON_CONHECIMENTO_SERIE = pConSerie
          AND Ca.GLB_ROTA_CODIGO = pConRota
          AND Ca.Slf_Reccust_Codigo = 'D_FRPSVO'
          and rownum = 1;
        exception
          when NO_DATA_FOUND then 
              vValor := 0;
              vDesinencia := '';
          End;    
          pObsCli := REPLACE(pObsCli,'<<FRPSVO>>', vValor || '-' || vDesinencia ); 
          vAlterou := true;

    End If;
    

    if instr(pObsCli,'<<NRCLI>>') > 0  Then

        begin
        select trim(to_char(ca.con_nftransportada_numero))
           into vValor
        from t_con_nftransporta ca
        WHERE Ca.CON_CONHECIMENTO_CODIGO = pConConhecimento
          AND Ca.CON_CONHECIMENTO_SERIE = pConSerie
          AND Ca.GLB_ROTA_CODIGO = pConRota
          and rownum = 1;
        exception
          when NO_DATA_FOUND then 
              vValor := 0;
              vDesinencia := '';
          End;    
          pObsCli := REPLACE(pObsCli,'<<NRCLI>>', vValor ); 
          vAlterou := true;

    End If;


    if instr(pObsCli,'<<PSCOB>>') > 0  Then
       Begin
        select f_mascara_valor(ca.con_calcviagem_valor,10,3),
               ca.con_calcviagem_desinencia
           into vValor,
                vDesinencia
        from t_con_CalcConhecimento ca
        WHERE Ca.CON_CONHECIMENTO_CODIGO = pConConhecimento
          AND Ca.CON_CONHECIMENTO_SERIE = pConSerie
          AND Ca.GLB_ROTA_CODIGO = pConRota
          AND Ca.Slf_Reccust_Codigo = 'I_PSCOBRAD'
          and rownum = 1;
        exception
          when NO_DATA_FOUND then 
              vValor := 0;
              vDesinencia := '';
          End;    

        pObsCli := REPLACE(pObsCli,'<<PSCOB>>', vValor || '-' || vDesinencia ); 
        vAlterou := true;
    End If;
      
    if instr(pObsCli,'<<PSREAL>>') > 0  Then
       Begin
        select f_mascara_valor (ca.con_calcviagem_valor,10,3),
               ca.con_calcviagem_desinencia
           into vValor,
                vDesinencia
        from t_con_CalcConhecimento ca
        WHERE Ca.CON_CONHECIMENTO_CODIGO = pConConhecimento
          AND Ca.CON_CONHECIMENTO_SERIE = pConSerie
          AND Ca.GLB_ROTA_CODIGO = pConRota
          AND Ca.Slf_Reccust_Codigo = 'D_PSREAL'
          and rownum = 1;
        exception
          when NO_DATA_FOUND then 
              vValor := 0;
              vDesinencia := '';
          End;    

        pObsCli := REPLACE(pObsCli,'<<PSREAL>>', vValor || '-' || vDesinencia ); 
        vAlterou := true;
    End If;
    
    return vAlterou; 
   
   End fn_Troca_tags;


   PROCEDURE SP_VERIFICA_ISENCAO_SUBST(P_SOLFRETE_CODIGO    IN CHAR, -- PODE SE UMA SOL OU TAB
                                       P_SOLFRETE_SAQUE     IN CHAR,
                                       P_LOCALIDADE_ORIGEM  IN CHAR,
                                       P_LOCALIDADE_DESTINO IN CHAR,
                                       P_ROTA_CODIGO        IN CHAR,
                                       P_MERCADORIA_CODIGO  IN CHAR,
                                       P_CLIENTE_REMETENTE  IN CHAR,
                                       P_CLIENTE_SACADO     IN CHAR,
                                       P_TIPORETORNO        IN OUT CHAR, -- INDICA SE E UMA TABELA OU SOLICITACAO
                                       P_DATAEMBARQUE       IN DATE,
                                       P_LEI                IN OUT T_SLF_ICMS.SLF_ICMS_DESCRICAOLEI%TYPE,
                                       P_CTRC               IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE DEFAULT NULL,
                                       P_SERIE              IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE DEFAULT NULL,
                                       P_ROTA               IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE DEFAULT NULL) IS
  V_VERIFICA             CHAR(4) := NULL;
  V_TIPO                 CHAR(1) := NULL; -- I para isento N normal T tributado
  V_TABELA_TIPO          CHAR(3) := NULL; -- se a tabela e CIF, FOB ou FOC
  V_SOLFRETE_TABELA      CHAR(3) := NULL;
  V_LOCALIDADE_SACADO    CHAR(8) := NULL;
  V_UFORIGEM             CHAR(2) := NULL;
  V_UFDESTINO            CHAR(2) := NULL;
  V_UFSACADO             CHAR(2) := NULL;
  V_CLIENTE_DESTINATARIO T_CON_CONHECIMENTO.GLB_CLIENTE_CGCCPFDESTINATARIO%TYPE := NULL;
  V_CLIENTE_REMETENTE    T_CON_CONHECIMENTO.GLB_CLIENTE_CGCCPFREMETENTE%TYPE    := P_CLIENTE_REMETENTE;
  V_CLIENTE_SACADO       T_CON_CONHECIMENTO.GLB_CLIENTE_CGCCPFSACADO%TYPE       := P_CLIENTE_SACADO;
  V_CLIENTE_SACADOIE     T_GLB_CLIENTE.GLB_CLIENTE_IE%TYPE;
  V_TAG                  VARCHAR2(15) := NULL;
  V_EXCESSAOMG           CHAR(1) := NULL;
  P_LEI1                 VARCHAR2(200);
  V_IMPRESSO             T_CON_CONHECIMENTO.CON_CONHECIMENTO_DIGITADO%TYPE := NULL;
  V_TRIGGER              CHAR(1);
  V_OBSSOLFRETE          T_SLF_SOLFRETE.SLF_SOLFRETE_OBSFATURAMENTO%TYPE;
  V_IMPRIMEOBSCTRC       T_SLF_SOLFRETE.SLF_SOLFRETE_IMPRIMEOBSCTRC%TYPE;
  v_Contrato             t_slf_solfrete.slf_solfrete_contrato%type;
  vAchou                 number;
  vStatus                char(1);
  vMessage               varchar2(200);
  vtpSacado              char(1);
  vUfSacado              char(2);
  vCalculo               tdvadm.t_slf_tpcalculo.slf_tpcalculo_formulario%type;
  vOBS1                  varchar2(200);
  vOBS2                  varchar2(200);
  vGLOBALIZADO           tdvadm.t_glb_estado.glb_estado_descleiglob%type;
  vMercadoria            tdvadm.t_glb_mercadoria.glb_mercadoria_codigo%type;
  vSubContrat            char(1);  
BEGIN
  
WHO_CALLED_ME2;


   vMercadoria := P_MERCADORIA_CODIGO;

  IF   P_CTRC = '09652698' THEN
      raise_application_error(-20001,P_SOLFRETE_CODIGO || chr(10) ||
                                     P_SOLFRETE_SAQUE || chr(10) ||
                                     P_LOCALIDADE_ORIGEM || chr(10) ||
                                     P_LOCALIDADE_DESTINO || chr(10) ||
                                     P_ROTA_CODIGO || chr(10) ||
                                     P_MERCADORIA_CODIGO || chr(10) ||
                                     V_CLIENTE_REMETENTE || chr(10) ||
                                     V_CLIENTE_SACADO || chr(10) ||
                                     P_TIPORETORNO || chr(10) ||
                                     P_DATAEMBARQUE || chr(10) ||
                                     P_LEI || chr(10) ||
                                     P_CTRC || chr(10) ||
                                     P_SERIE || chr(10) ||
                                     P_ROTA);
  END IF;     
   vCalculo := 'N';
   
  
/*  
  
  IF P_SOLFRETE_CODIGO = '00051803' THEN
    RAISE_APPLICATION_ERROR(-20001,'KALYTON TA PASSANDO POR AQUI!');
  END IF;*/
  
  
  select count(*)
    into vAchou
  from t_con_conhecimentoregesp x
  where x.con_conhecimento_codigo = P_CTRC
    and x.con_conhecimento_serie = P_SERIE
    and x.glb_rota_codigo = P_ROTA
    and x.con_conhecimentoregesp_tpglob is not null;
  
  If vAchou <> 0 Then
     select e.glb_estado_descleiglob
       into vGLOBALIZADO
     from t_glb_estado e,
          t_glb_rota r
     where r.glb_rota_codigo = P_ROTA
       and r.glb_estado_codigo = e.glb_estado_codigo;
  Else
    vGLOBALIZADO := '';
  End If;
  V_IMPRIMEOBSCTRC := 'N';
  IF TRIM(P_LEI) = 'TRIGGER' THEN
    V_TRIGGER := 'S';
    P_LEI     := ' ';
  ELSIF TRIM(P_LEI) = 'FUNCAO' THEN
    V_TRIGGER := 'F';
  ELSE
    V_TRIGGER := 'N';
  END IF;


   if ( P_CTRC is not null ) and ( V_TRIGGER = 'N' ) THEN
      BEGIN
         select TP.SLF_TPCALCULO_FORMULARIO
           into vCalculo
         from T_CON_CALCCONHECIMENTO CA,
              T_SLF_TPCALCULO TP
         WHERE CA.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CA.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND CA.GLB_ROTA_CODIGO         = P_ROTA      
           AND CA.SLF_TPCALCULO_CODIGO = TP.SLF_TPCALCULO_CODIGO
           AND TP.SLF_TPCALCULO_CALCULOMAE = 'S'
           AND CA.SLF_RECCUST_CODIGO = 'I_TTPV';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vCalculo := 'N';
        END ;     
   End If;     


  -- Verifica se existe regime especial para este ctrc
  -- 03/01/2013 - Sirlano
  IF V_TRIGGER <> 'F' THEN
      if P_CTRC is not null then
         pkg_con_cte.SP_SETREGESPECIAL(P_CTRC,P_SERIE,P_ROTA,vStatus,vMessage,V_TRIGGER);
      end if;   
  END IF;

  IF (P_CTRC IS NOT NULL) or (length(ltrim(rtrim(nvl(P_CTRC, '')))) = 6) THEN
     BEGIN

        SELECT C.GLB_CLIENTE_CGCCPFDESTINATARIO,
               C.GLB_CLIENTE_CGCCPFREMETENTE,
               C.GLB_CLIENTE_CGCCPFSACADO,
               nvl(C.CON_CONHECIMENTO_DIGITADO,'D')
          INTO V_CLIENTE_DESTINATARIO,
               V_CLIENTE_REMETENTE,
               V_CLIENTE_SACADO,
               V_IMPRESSO
          FROM T_CON_CONHECIMENTO C
         WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND C.CON_CONHECIMENTO_SERIE = P_SERIE
           AND C.GLB_ROTA_CODIGO = P_ROTA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_CLIENTE_DESTINATARIO := '';
          V_CLIENTE_REMETENTE    := P_CLIENTE_REMETENTE;
          V_CLIENTE_SACADO       := P_CLIENTE_SACADO;
          V_IMPRESSO             := '';
      END;

  End if;
  
  IF V_CLIENTE_SACADO = V_CLIENTE_REMETENTE THEN
     vtpSacado := 'R'; -- Remetente
     V_TABELA_TIPO := 'CIF';
  ELSIF V_CLIENTE_DESTINATARIO <> '' THEN
     IF V_CLIENTE_SACADO = V_CLIENTE_DESTINATARIO THEN
        vtpSacado := 'D'; -- Destinatario
        V_TABELA_TIPO := 'FOB';
     ELSE
        vtpSacado := 'O'; -- Terceiro
-- não sei o que colocar quando for um terceiro pagando 
--        V_TABELA_TIPO := 'FOB';
     END IF;
  ELSE 
     vtpSacado := 'N';
  END IF;   
        
  begin
  select ce.glb_estado_codigo,
         CE.GLB_CLIEND_IE
    into vUfSacado,
         V_CLIENTE_SACADOIE
  from t_glb_cliend ce
  where ce.glb_cliente_cgccpfcodigo = V_CLIENTE_SACADO 
    and ce.glb_tpcliend_codigo = 'E';  
  exception
    when NO_DATA_FOUND Then
       vUfSacado := '**';
    end ;
  IF P_LOCALIDADE_ORIGEM = P_LOCALIDADE_DESTINO THEN
    -- SE ORIGEM = DESTINO E ISS
    P_LEI         := ' ';
    --P_TIPORETORNO := 'T';
    
     IF NVL(TRIM(P_TIPORETORNO), 'S') = 'S' THEN
        BEGIN
          SELECT s.SLF_SOLFRETE_ISENTO,
                 s.slf_solfrete_contrato
            INTO V_TIPO,
                 v_Contrato
            FROM T_SLF_SOLFRETE s
           WHERE SLF_SOLFRETE_CODIGO = P_SOLFRETE_CODIGO
             AND SLF_SOLFRETE_SAQUE = P_SOLFRETE_SAQUE;
          V_SOLFRETE_TABELA := 'SOL';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            P_TIPORETORNO     := 'T';
            V_SOLFRETE_TABELA := 'TAB';
        END;
      ELSE
        V_SOLFRETE_TABELA := 'TAB';
      END IF;
    
    
  ELSE
    -- PEGA O DESTINATARIO
    -- 03/04/2006 SIRLANO
    -- ALTERADO PARA IGNORAR A DATA DE EMBARQUE PASSADA E PEGAR EFETIVAMENTE A DATA
    -- DE EMBARQUE GRAVADA NO CTRC

    if P_TIPORETORNO = 'S' THEN

      SELECT S.GLB_CLIENTE_CGCCPFCODIGODES,
             s.slf_solfrete_contrato
        INTO V_CLIENTE_DESTINATARIO,
             v_Contrato
        FROM T_SLF_SOLFRETE S
       WHERE S.SLF_SOLFRETE_CODIGO = P_SOLFRETE_CODIGO
         AND S.SLF_SOLFRETE_SAQUE = P_SOLFRETE_SAQUE;
      V_IMPRESSO := nvl(V_IMPRESSO,'D');

    ELSE
      V_CLIENTE_DESTINATARIO := NULL;
      V_IMPRESSO             := nvl(V_IMPRESSO,'D');
    END IF;
    -- PROCURA OS ESTADOS DE ORIGEM E DESTINO
    BEGIN
      SELECT L.GLB_ESTADO_CODIGO
        INTO V_UFORIGEM
        FROM T_GLB_LOCALIDADE L
       WHERE L.GLB_LOCALIDADE_CODIGO = P_LOCALIDADE_ORIGEM;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_UFORIGEM := 'XX';
    END;
    BEGIN
      SELECT L.GLB_ESTADO_CODIGO
        INTO V_UFDESTINO
        FROM T_GLB_LOCALIDADE L
       WHERE L.GLB_LOCALIDADE_CODIGO = P_LOCALIDADE_DESTINO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_UFDESTINO := 'XX';
    END;
    -- POR CAUSA DA EXCESAO DE MG FOB A LEI NAO PODE APARECER NA DESCRICAO DO CONHECIMENTO
    -- SANDOR 18/05/2006 SOLICITADO PELO RONALDO
    -- NO FIlIAL DA SP ELE OLHA SE V_EXCESSAO = S SE FOR P_LEI := ' '
    V_EXCESSAOMG := 'N';
    IF V_UFORIGEM = 'MG' AND V_UFDESTINO <> 'MG' THEN
      V_EXCESSAOMG := 'S';
    END IF;
    -- CHUMBADA RJ REFRESCOS PARA O ESTADO DO ESPIRITO SANTO
    IF V_CLIENTE_SACADO = '00074569000100' AND
       P_DATAEMBARQUE >= to_date('15/11/2005','dd/mm/yyyy') AND 
       P_DATAEMBARQUE < to_date('24/11/2005','dd/mm/yyyy') AND
       V_UFORIGEM = 'ES' AND
       P_LOCALIDADE_ORIGEM <> P_LOCALIDADE_DESTINO THEN
      P_TIPORETORNO := 'S';
      P_LEI         := 'Subst.Trib. Art 269 Par 2 Port 44-R-RICMS/ES';
      -- CHUMBADA ACESITA PARA O ESTADO DE MINAS GERAIS
      -- retirada apos MENOS de 24 horas apos entrar em vigor
    ELSIF V_CLIENTE_REMETENTE = '33390170001312' AND
          P_DATAEMBARQUE = to_date('02/12/2005','dd/mm/yyyy') AND 
          V_UFORIGEM = 'MG' AND
          V_UFDESTINO <> 'MG' AND
          P_LOCALIDADE_ORIGEM <> P_LOCALIDADE_DESTINO THEN
      P_TIPORETORNO := 'T';
      P_LEI         := ' ';



    ElsIF V_UFORIGEM = 'SP' AND V_UFDESTINO = 'EX' THEN
      V_TIPO := 'I';
      P_TIPORETORNO := 'I';
      P_LEI  := 'ISENTO ICMS Art.149 Anexo I do RICMS-SP';
      
    ElsiF V_UFORIGEM = 'MG' AND vMercadoria = 'EX' THEN
        
          V_TIPO := 'I'; 
          P_TIPORETORNO := 'I';  
          P_LEI := 'Isento cf.Parte 1-AnexoI-Item 126-Dec.43.080/02-RICMS/MG';
         
    -- Retirado a MERCADORIA DA FIBRIA em 27/10/2017
    -- TODAS AS CARGAS DA FIBRIA SERAO SUBSTITUICAO TRIBUTARIA
    ElsiF V_UFORIGEM = 'MS' /*AND vMercadoria = 'EX'*/ and trim(V_CLIENTE_SACADO) in ('36785418001502','60643228061503') THEN
        
          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
          P_LEI := 'ICMS SERA RECOLHIDO P/REMETENTE MERCADORIA RE 11/049202/2013';
    ElsIf V_UFORIGEM = 'MS' and trim(V_CLIENTE_SACADO) in ('16404287044870') and P_LOCALIDADE_ORIGEM in ('79600','79601') Then
          P_LEI := 'ICMS retido pelo remetente da mercadoria.';
          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
    ElsIf V_UFORIGEM = 'ES' and 
          trim(V_CLIENTE_SACADO) in ('16404287046147') and 
          V_CLIENTE_SACADOIE = '083522581' AND 
          P_DATAEMBARQUE < to_date('01/05/2021','dd/mm/yyyy') Then
          P_LEI := 'TRIBUTADA E COM COBRANÇA DO ICMS POR SUBSTITUIÇÃO TRIBUTÁRIA';
          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
    ElsIf V_UFORIGEM = 'MS' and 
          V_UFDESTINO = 'MG' and
          trim(V_CLIENTE_SACADO) in ('03543379001146') and 
--          trim(V_CLIENTE_DESTINATARIO) in ('03543379001146') and
          P_DATAEMBARQUE >= to_date('18/06/2021','dd/mm/yyyy') and 
          P_DATAEMBARQUE <= to_date('20/06/2021','dd/mm/yyyy') Then

          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
    ELSE
      -- BUSCA ENDERECO DA UNIDADE DO SACADO
      BEGIN
        SELECT T.GLB_LOCALIDADE_CODIGO
          INTO V_LOCALIDADE_SACADO
          FROM T_GLB_CLIEND T
         WHERE T.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTE_SACADO
           AND T.GLB_TPCLIEND_CODIGO = 'E';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT T.GLB_LOCALIDADE_CODIGO
              INTO V_LOCALIDADE_SACADO
              FROM T_GLB_CLIEND T
             WHERE T.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTE_SACADO
               AND T.GLB_TPCLIEND_CODIGO = 'B';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              BEGIN
                SELECT T.GLB_LOCALIDADE_CODIGO
                  INTO V_LOCALIDADE_SACADO
                  FROM T_GLB_CLIEND T
                 WHERE T.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTE_SACADO
                   AND T.GLB_TPCLIEND_CODIGO = 'E';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    SELECT T.GLB_LOCALIDADE_CODIGO
                      INTO V_LOCALIDADE_SACADO
                      FROM T_GLB_CLIEND T
                     WHERE T.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTE_SACADO
                       AND ROWNUM = 1;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      RAISE_APPLICATION_ERROR(-20001,
                                              'SACADO SEM ENDERECOS CADASTRADOS! AVISE A MATRIZ! CNPJ/CPF: ' ||
                                              V_CLIENTE_SACADO);
                  END;
              END;
          END;
      END;
      -- UF SACADO
      BEGIN
        SELECT L.GLB_ESTADO_CODIGO
          INTO V_UFSACADO
          FROM T_GLB_LOCALIDADE L
         WHERE L.GLB_LOCALIDADE_CODIGO = V_LOCALIDADE_SACADO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_UFSACADO := 'XX';
      END;

      -- VERIFICA SE E TABELA OU SOLICITAC?O, NO CASO DE P_TIPORETORNO = NULL
      IF NVL(TRIM(P_TIPORETORNO), 'S') = 'S' THEN
        BEGIN
          SELECT s.SLF_SOLFRETE_ISENTO,
                 s.slf_solfrete_contrato
            INTO V_TIPO,
                 v_Contrato
            FROM T_SLF_SOLFRETE s
           WHERE SLF_SOLFRETE_CODIGO = P_SOLFRETE_CODIGO
             AND SLF_SOLFRETE_SAQUE = P_SOLFRETE_SAQUE;
          V_SOLFRETE_TABELA := 'SOL';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            P_TIPORETORNO     := 'T';
            V_SOLFRETE_TABELA := 'TAB';
        END;
      ELSE
        V_SOLFRETE_TABELA := 'TAB';
      END IF;
      -- IF (LTRIM(RTRIM(V_CLIENTE_REMETENTE))  =  LTRIM(RTRIM(V_CLIENTE_SACADO)))  THEN V_TIPO := 'S';
      IF (LTRIM(RTRIM(V_CLIENTE_REMETENTE)) = 'DRUMOND') THEN
        V_TIPO := 'S';
      ELSE
        BEGIN
          IF V_SOLFRETE_TABELA = 'SOL' THEN
            -- VERIFICA TIPO DE TRIBUTAC?O DA SOLICITAC?O
            BEGIN
              SELECT s.SLF_SOLFRETE_ISENTO,
                     s.slf_solfrete_contrato
                INTO V_TIPO,
                     v_Contrato
                FROM T_SLF_SOLFRETE s
               WHERE SLF_SOLFRETE_CODIGO = P_SOLFRETE_CODIGO
                 AND SLF_SOLFRETE_SAQUE = P_SOLFRETE_SAQUE;
              V_TABELA_TIPO := '***';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001,
                                        P_SOLFRETE_CODIGO || '-' ||
                                        P_SOLFRETE_SAQUE);
            END;
          ELSE
            -- VERIFICA TIPO DE TRIBUTAC?O DA TABELA E O TIPO DA TABELA
            BEGIN
              SELECT t.SLF_TABELA_ISENTO, 
                     t.SLF_TABELA_TIPO,
                     t.slf_tabela_contrato
                INTO V_TIPO, 
                     V_TABELA_TIPO,
                     v_Contrato
                FROM T_SLF_TABELA t
               WHERE SLF_TABELA_CODIGO = P_SOLFRETE_CODIGO
                 AND SLF_TABELA_SAQUE = P_SOLFRETE_SAQUE;
              -- V_TIPO := 'T';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                IF NVL(P_SOLFRETE_CODIGO, 'sirlano') = 'sirlano' THEN
                  V_TIPO        := 'T';
                  V_TABELA_TIPO := 'CIF';
                ELSE
                  RAISE_APPLICATION_ERROR(-20001,
                                          NVL(P_SOLFRETE_CODIGO, 'sirlano') || '-' ||
                                          P_SOLFRETE_SAQUE);
                END IF;
            END;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    V_SOLFRETE_TABELA || '-' ||
                                    P_TIPORETORNO || '-' ||
                                    P_SOLFRETE_CODIGO || '-' ||
                                    P_SOLFRETE_SAQUE);
        END;
        IF V_TIPO = 'N' THEN
          -- SE NORMAL
          BEGIN
            -- verifica se a mercadoria e isenta
            SELECT SLF_TPCALCULO_CODIGO, TRIM(SLF_ISENCAO_DESCLEI)
              INTO V_VERIFICA, P_LEI1
              FROM T_SLF_ISENCAO
             WHERE GLB_MERCADORIA_CODIGO = vMercadoria
               AND (GLB_ESTADO_CODIGO IS NULL OR
                   GLB_ESTADO_CODIGO = V_UFORIGEM)
               AND SLF_ISENCAO_DATAINICIO <= P_DATAEMBARQUE
               AND (SLF_ISENCAO_DATAFINAL >= P_DATAEMBARQUE OR
                   SLF_ISENCAO_DATAFINAL IS NULL)
             GROUP BY SLF_TPCALCULO_CODIGO, SLF_ISENCAO_DESCLEI;
            V_TIPO := 'I';
            P_LEI  := P_LEI1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              BEGIN
                SELECT I.SLF_ICMS_DESCRICAOLEI
                  INTO P_LEI1
                  FROM T_SLF_ICMS I
                 WHERE TRUNC(I.SLF_ICMS_DATAEFETIVA) =
                       (SELECT MAX(TRUNC(A.SLF_ICMS_DATAEFETIVA))
                          FROM T_SLF_ICMS A
                         WHERE A.GLB_ESTADO_CODIGOORIGEM  = I.GLB_ESTADO_CODIGOORIGEM
                           AND A.GLB_ESTADO_CODIGODESTINO = I.GLB_ESTADO_CODIGODESTINO
                           AND A.SLF_ICMS_DATAEFETIVA <= P_DATAEMBARQUE)
                   AND I.SLF_ICMS_DATAEFETIVAISENCAO <= P_DATAEMBARQUE
                   AND I.GLB_ESTADO_CODIGOORIGEM = V_UFORIGEM
                   AND I.GLB_ESTADO_CODIGODESTINO = V_UFDESTINO
                   AND I.SLF_ICMS_DESCRICAOLEI IS NOT NULL
                   AND decode(I.Slf_Icms_Ufsacado,'**',vufSacado,I.Slf_Icms_Ufsacado) = vufSacado;
                V_TIPO := 'I';
                P_LEI  := P_LEI1;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    -- verifica se e substituicao tributaria
                    SELECT SLF_TPCALCULO_CODIGO
                      INTO V_VERIFICA
                      FROM T_SLF_SUBSTRIBUTARIA S
                     WHERE SLF_SUBSTRIBUTARIA_TIPO = V_SOLFRETE_TABELA
                       AND SLF_SUBSTRIBUTARIA_TABELA = DECODE(SLF_SUBSTRIBUTARIA_TABELA,'***','***',V_TABELA_TIPO)
                       AND GLB_ESTADO_CODIGOORIGEM = V_UFORIGEM
                       AND GLB_ESTADO_CODIGODESTINO = V_UFSACADO
                       AND SLF_SUBSTRIBUTARIA_DATAINICIO <= TRUNC(P_DATAEMBARQUE) 
                       AND ((SLF_SUBSTRIBUTARIA_DATAFINAL >= TRUNC(P_DATAEMBARQUE)) OR (SLF_SUBSTRIBUTARIA_DATAFINAL IS NULL))
                     GROUP BY SLF_TPCALCULO_CODIGO;
                    -- V_TIPO := 'S';
                    /* ALTERAR O IF ABAIXO PARA VERIFICAR O ESTADO DO SACADO = ESTADO DE ORIGEM */
                    IF V_UFORIGEM = 'SP' THEN
                      -- JERONIMO - 20/04/2006
                      -- MUDANCA NA VERIFICAC?O DE TRES ENVOLVIDOS
                      -- SE REMETENTE = DESTINATARIO, MAS DIFERENTE SACADO, CONSIDERAR COMO SE FOSSE 3 ENVOLVIDOS
                      IF vtpSacado in ('R','D')  OR
                        -- CONFORME SOLICITAC?O DA GERENCIA ADMINISTRATIVA EM 06/09/2006, FORAM AMARRADAS AS SOLICITAC?ES
                        -- ABAIXO DO CLIENTE CBA PARA CONSIDERAR SEMPRE SUBSTITUIC?O, MESMO QUE SEJA 3 ENVOLVIDOS
                        -- ESSAS CONDIC?ES FOI COLOCADO JUNTAMENTE COM OUTRO IF NA SP_MONTA_FORMULA_CNHC1
                         ((V_SOLFRETE_TABELA = 'SOL') AND (P_SOLFRETE_CODIGO = '00047467') AND (P_SOLFRETE_SAQUE >= '0003')) OR
                         ((V_SOLFRETE_TABELA = 'SOL') AND (P_SOLFRETE_CODIGO = '00047494') AND (P_SOLFRETE_SAQUE >= '0002')) OR
                         (V_CLIENTE_DESTINATARIO IS NULL) THEN
                        -- ESTA ULTIMA CONDIC?O E PARA GARANTIR CALCULO QUANDO N?O HA CTRC
                        V_TIPO := 'S';
                      ELSE
                        V_TIPO := 'T';
                      END IF;
                    ELSE
                      V_TIPO := 'S';
                      -- V_TIPO := NULL;
                    END IF;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      BEGIN
                        -- IF V_SOLFRETE_TABELA = 'TAB' THEN
                        --     V_SOLFRETE_TABELA := 'SIR'; -- FORCA PARA NAO ACHAR SE FOR TABELA
                        -- END IF;
                        SELECT SLF_TPCALCULO_CODIGO
                          INTO V_VERIFICA
                          FROM T_SLF_SUBSTRIBUTARIA
                         WHERE SLF_SUBSTRIBUTARIA_TIPO = V_SOLFRETE_TABELA
                           AND SLF_SUBSTRIBUTARIA_TABELA = DECODE(SLF_SUBSTRIBUTARIA_TABELA,'***','***',V_TABELA_TIPO)
                           AND GLB_ESTADO_CODIGOORIGEM = V_UFORIGEM
                           AND GLB_ESTADO_CODIGODESTINO = DECODE(GLB_ESTADO_CODIGODESTINO,'XX','XX',V_UFDESTINO)
                           AND SLF_SUBSTRIBUTARIA_DATAINICIO <= TRUNC(P_DATAEMBARQUE)
                           AND ((SLF_SUBSTRIBUTARIA_DATAFINAL >= TRUNC(P_DATAEMBARQUE)) OR (SLF_SUBSTRIBUTARIA_DATAFINAL IS NULL))
                         GROUP BY SLF_TPCALCULO_CODIGO;
                        IF vtpSacado = 'R' OR V_UFORIGEM = 'MG' THEN
                          V_TIPO := 'S';
                        ELSE
                          V_TIPO := 'T';
                          -- V_TIPO := NULL;
                        END IF;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          -- Colocar as excecoes por CNPJ para Substituicao Tributaria
                          If instr(vListaCNPJcomDestaqueICMS,trim(V_CLIENTE_SACADO)) > 0 and
                             P_DATAEMBARQUE >= to_date('01/08/2017','dd/mm/yyyy') AND 
                             V_UFORIGEM in ('ES','MS') Then
                          
                             V_TIPO := 'S';
                             If V_UFORIGEM = 'ES' Then
                                P_LEI := 'ST. ART.185,VII,RICMS/ES¿DEC.1090R/2002.';
                             ElsIf V_UFORIGEM = 'MS' and P_LOCALIDADE_ORIGEM in ('79600','79601') Then
                                P_LEI := 'ICMS retido pelo remetente da mercadoria.';
                             End If;
                          Else
                             V_TIPO := 'T';  
                          End If;
                      END;
                  END;
              END;
          END;
        END IF;
      END IF;
      P_TIPORETORNO := V_TIPO;
      IF (V_TIPO = 'I') THEN
        IF (P_LEI IS NULL) THEN
          BEGIN
            SELECT I.SLF_ICMS_DESCRICAOLEI
              INTO P_LEI1
              FROM T_SLF_ICMS I
             WHERE TRUNC(I.SLF_ICMS_DATAEFETIVAISENCAO) =
                   (SELECT MAX(TRUNC(A.SLF_ICMS_DATAEFETIVAISENCAO))
                      FROM T_SLF_ICMS A
                     WHERE A.GLB_ESTADO_CODIGOORIGEM  = I.GLB_ESTADO_CODIGOORIGEM
                       AND A.GLB_ESTADO_CODIGODESTINO = I.GLB_ESTADO_CODIGODESTINO
                       AND A.SLF_ICMS_DATAEFETIVAISENCAO <= P_DATAEMBARQUE)
               AND I.GLB_ESTADO_CODIGOORIGEM = V_UFORIGEM
               AND I.GLB_ESTADO_CODIGODESTINO = V_UFDESTINO
               AND decode(I.Slf_Icms_Ufsacado,'**',vufSacado,I.Slf_Icms_Ufsacado) = vufSacado;
            P_LEI := P_LEI1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              P_LEI := 'ISENTO';
          END;
        END IF;
        -- JERONIMO 20/07/2006 - INICIO
        -- CHUMBADA VA TECH HYDRO BRASIL
        -- FORCANDO OBSERVAC?O EM BRANCO NOS CASOS DE ISENC?O DE MG X MG
        IF (V_CLIENTE_SACADO = '01714762000112') AND
           (P_DATAEMBARQUE >= to_date('11/08/2006','dd/mm/yyyy')) AND 
           (V_UFORIGEM = 'MG') AND
           (V_UFDESTINO = 'MG') THEN
          P_LEI := ' ';
        END IF;
        -- JERONIMO 20/07/2006 - FIM
      ELSIF (V_TIPO = 'S') THEN
        IF (P_LEI IS NULL) THEN
          BEGIN
            SELECT SUBSTR(E.GLB_ESTADO_DESCLEI,1,200)
              INTO P_LEI1
              FROM T_GLB_ESTADO E
             WHERE E.GLB_ESTADO_CODIGO = V_UFORIGEM;
            P_LEI := SUBSTR(P_LEI1, 1, 99);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              P_LEI := 'SUBSTITUICÃO TRIBUTARIA';
                          WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR(-20001, '- P_LEI: ' || P_LEI || CHR(10) ||' - P_LEI1: ' || P_LEI1|| V_UFORIGEM);
          END;
        END IF;
        -- JERONIMO 20/07/2006 - INICIO
        -- CHUMBADA VOTORANTIM METAIS NIQUEL / VOTORANTIM CELULOSE E PAPEL
        -- FORCANDO OBSERVAC?O DIFERENCIADA DE SUBSTITUIC?O TRIBUTARIA CONFORME O CNPJ
        IF (V_CLIENTE_SACADO = '18499616000467') AND
           (P_DATAEMBARQUE >= to_date('20/07/2006','dd/mm/yyyy')) AND (V_UFORIGEM = 'SP') THEN
          P_LEI := substr('ICMS R$ <<VLICMS>> Subst. Tributaria art. 317 do RICMS',
                          1,
                          200);

        ELSIF  V_CLIENTE_SACADO IN ('44682318002623','60643228019574') AND 
               V_UFORIGEM = 'SP' AND
               P_DATAEMBARQUE >= to_date('01/10/2006','dd/mm/yyyy') THEN
          P_LEI := substr('ICMS R$ <<VLICMS>> Subst. Tributaria art. 317 do RICMS',
                           1,
                          200);
        END IF;
        
        IF P_ROTA = '170' then
          P_LEI1 := 'RECOLHIMENTO DO ICMS ATE O 10 (DECIMO) DIA DO MES SUBSEQUENTE AO DA OCORRENCIA DO FATO GERADOR, AUTORIZADO PELO REGIME TRIBUTARIO DIFERENCIADO NR 000080/16 DE 06/04/2016';
        END IF;
        -- JERONIMO 20/07/2006 - FIM
        -- JERONIMO 16/03/2007 - INICIO   
        -- CHUMBADA BUCYRUS BRASIL LTDA
        -- FORCANDO OBSERVAC?O DIFERENCIADA DE SUBSTITUIC?O TRIBUTARIA
        IF (V_CLIENTE_SACADO = '33502360000140') AND
           (P_DATAEMBARQUE >= to_date('19/03/2007','dd/mm/yyyy')) AND
           (P_DATAEMBARQUE <= to_date('30/09/2014','dd/mm/yyyy')) and
           (V_UFORIGEM = 'MG') AND
           (V_UFDESTINO <> 'MG') THEN

          P_LEI := substr('ICMS ST responsabilidade remetente/alienante. Desc. R$ <<VLICM80%>>',
                          1,
                          200);
        END IF;
        -- JERONIMO 16/03/2007 - FIM
        IF ((P_CTRC IS NOT NULL) or
           (length(ltrim(rtrim(nvl(P_CTRC, '')))) = 6)) AND
           (P_LEI = substr('R$ <<VLICMS>> ICMS ST de responsabilidade do remetente',
                           1,
                           200)) AND (P_DATAEMBARQUE >= to_date('01/04/2006','dd/mm/yyyy')) THEN
          P_LEI := 'ICMS ST de responsabilidade do remetente/alienante';
        ELSIF ((P_CTRC IS NOT NULL) or
              (length(ltrim(rtrim(nvl(P_CTRC, '')))) = 6)) AND
              (INSTR(P_LEI, '<<VLICMS>>', 1, 1) > 0) THEN
          BEGIN
            IF ((V_SOLFRETE_TABELA = 'SOL' AND (P_SOLFRETE_CODIGO in ('00047064','00047069','00047070'))) OR
               (V_SOLFRETE_TABELA = 'TAB' AND (P_SOLFRETE_CODIGO in ('00000982')))) THEN
              -- P_SOLFRETE_CODIGO = '00000082') THEN
              SELECT TRIM(TO_CHAR(ROUND(CC.CON_CALCVIAGEM_VALOR *
                                        (I.SLF_ICMS_ALIQUOTA / 100),
                                        2),
                                  '9,999,990.00'))
                INTO V_TAG
                FROM T_SLF_ICMS I, 
                     T_CON_CALCCONHECIMENTO CC
               WHERE I.GLB_ESTADO_CODIGOORIGEM = 'MG'
                 AND I.GLB_ESTADO_CODIGODESTINO = 'MG'
                 AND CC.CON_CONHECIMENTO_CODIGO = P_CTRC
                 AND CC.CON_CONHECIMENTO_SERIE = P_SERIE
                 AND CC.GLB_ROTA_CODIGO = P_ROTA
                 AND CC.SLF_RECCUST_CODIGO = 'I_TTPV'
                 AND TRUNC(I.SLF_ICMS_DATAEFETIVA) =
                     (SELECT MAX(TRUNC(A.SLF_ICMS_DATAEFETIVA))
                        FROM T_SLF_ICMS A
                       WHERE A.GLB_ESTADO_CODIGOORIGEM = 'MG'
                         AND A.GLB_ESTADO_CODIGODESTINO = 'MG');
            ELSE
              SELECT TRIM(TO_CHAR(ROUND(CC.CON_CALCVIAGEM_VALOR *
                                        (I.SLF_ICMS_ALIQUOTA / 100),
                                        2),
                                  '9,999,990.00'))
                INTO V_TAG
                FROM T_SLF_ICMS I, 
                     T_CON_CALCCONHECIMENTO CC
               WHERE I.GLB_ESTADO_CODIGOORIGEM = V_UFORIGEM
                 AND I.GLB_ESTADO_CODIGODESTINO = V_UFDESTINO
                 AND CC.CON_CONHECIMENTO_CODIGO = P_CTRC
                 AND CC.CON_CONHECIMENTO_SERIE = P_SERIE
                 AND CC.GLB_ROTA_CODIGO = P_ROTA
                 AND CC.SLF_RECCUST_CODIGO = 'I_TTPV'
                 AND TRUNC(I.SLF_ICMS_DATAEFETIVA) =
                     (SELECT MAX(TRUNC(A.SLF_ICMS_DATAEFETIVA))
                        FROM T_SLF_ICMS A
                       WHERE A.GLB_ESTADO_CODIGOORIGEM  = I.GLB_ESTADO_CODIGOORIGEM
                         AND A.GLB_ESTADO_CODIGODESTINO = I.GLB_ESTADO_CODIGODESTINO);
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              V_TAG := '0,00';
          END;
          WHILE INSTR(P_LEI, '<<VLICMS>>', 1, 1) > 0 LOOP
            P_LEI := TRIM(SUBSTR(P_LEI,
                                 1,
                                 INSTR(P_LEI, '<<VLICMS>>', 1, 1) - 1) ||
                          V_TAG ||
                          SUBSTR(P_LEI,
                                 INSTR(P_LEI, '<<VLICMS>>', 1, 1) + 10,
                                 LENGTH(P_LEI) -
                                 (INSTR(P_LEI, '<<VLICMS>>', 1, 1) + 10)));
          END LOOP;
        ELSIF ((P_CTRC IS NOT NULL) or
              (length(ltrim(rtrim(nvl(P_CTRC, '')))) = 6)) AND
              (INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) > 0) THEN
          BEGIN
            IF (V_SOLFRETE_TABELA = 'SOL' AND (P_SOLFRETE_CODIGO in ('00047064','00047069','00047070')) OR
               (V_SOLFRETE_TABELA = 'TAB' AND (P_SOLFRETE_CODIGO = '00000982'))) THEN
              SELECT TRIM(TO_CHAR(ROUND((CC.CON_CALCVIAGEM_VALOR *
                                        (I.SLF_ICMS_ALIQUOTA / 100)) * 0.8,
                                        2),
                                  '9,999,990.00'))
                INTO V_TAG
                FROM T_SLF_ICMS I, 
                     T_CON_CALCCONHECIMENTO CC
               WHERE I.GLB_ESTADO_CODIGOORIGEM = 'MG'
                 AND I.GLB_ESTADO_CODIGODESTINO = 'MG'
                 AND CC.CON_CONHECIMENTO_CODIGO = P_CTRC
                 AND CC.CON_CONHECIMENTO_SERIE = P_SERIE
                 AND CC.GLB_ROTA_CODIGO = P_ROTA
                 AND CC.SLF_RECCUST_CODIGO = 'I_TTPV'
                 AND TRUNC(I.SLF_ICMS_DATAEFETIVA) =
                     (SELECT MAX(TRUNC(A.SLF_ICMS_DATAEFETIVA))
                        FROM T_SLF_ICMS A
                       WHERE A.GLB_ESTADO_CODIGOORIGEM = 'MG'
                         AND A.GLB_ESTADO_CODIGODESTINO = 'MG');
            ELSE
              SELECT TRIM(TO_CHAR(ROUND((CC.CON_CALCVIAGEM_VALOR *
                                        (I.SLF_ICMS_ALIQUOTA / 100)) * 0.8,
                                        2),
                                  '9,999,990.00'))
                INTO V_TAG
                FROM T_SLF_ICMS I, 
                     T_CON_CALCCONHECIMENTO CC
               WHERE I.GLB_ESTADO_CODIGOORIGEM = V_UFORIGEM
                 AND I.GLB_ESTADO_CODIGODESTINO = V_UFDESTINO
                 AND CC.CON_CONHECIMENTO_CODIGO = P_CTRC
                 AND CC.CON_CONHECIMENTO_SERIE = P_SERIE
                 AND CC.GLB_ROTA_CODIGO = P_ROTA
                 AND CC.SLF_RECCUST_CODIGO = 'I_TTPV'
                 AND TRUNC(I.SLF_ICMS_DATAEFETIVA) =
                     (SELECT MAX(TRUNC(A.SLF_ICMS_DATAEFETIVA))
                        FROM T_SLF_ICMS A
                       WHERE A.GLB_ESTADO_CODIGOORIGEM =
                             I.GLB_ESTADO_CODIGOORIGEM
                         AND A.GLB_ESTADO_CODIGODESTINO =
                             I.GLB_ESTADO_CODIGODESTINO);
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              V_TAG := '0,00';
          END;
          WHILE INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) > 0 LOOP
            P_LEI := TRIM(SUBSTR(P_LEI,
                                 1,
                                 INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) - 1) ||
                          V_TAG ||
                          SUBSTR(P_LEI,
                                 INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) + 10,
                                 LENGTH(P_LEI) -
                                 (INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) + 10)));
          END LOOP;
        ELSIF ((P_CTRC IS NULL) AND
              (INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) > 0)) THEN
          V_TAG := '0,00';
          WHILE INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) > 0 LOOP
            P_LEI := TRIM(SUBSTR(P_LEI,
                                 1,
                                 INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) - 1) ||
                          V_TAG ||
                          SUBSTR(P_LEI,
                                 INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) + 10,
                                 LENGTH(P_LEI) -
                                 (INSTR(P_LEI, '<<VLICMS80%>>', 1, 1) + 10)));
          END LOOP;
        END IF;
      END IF;
      --P_LEI := SUBSTR(P_LEI, 1, 70);
    END IF;
    -- POR CAUSA DA EXCESAO DE MG FOB A LEI NAO PODE APARECER NA DESCRICAO DO CONHECIMENTO
    -- SANDOR 18/05/2006 SOLICITADO PELO RONALDO  CONSISTENCIA NO COMECO DA V_EXCESSAOMG
    IF V_EXCESSAOMG = 'S' AND vtpSacado not in ('R','N') THEN
      P_LEI := ' ';
      --      P_TIPORETORNO := 'T';
    END IF;
    IF V_EXCESSAOMG = 'S' AND vtpSacado = 'D' THEN
      P_LEI := ' ';
    END IF;

    -- 08/02/2008
    -- TRES ENVOLVIDOS E SACADO E REMETENTE DE MINAS IMPRIMIR LEI

    IF vtpSacado not in ('O','N') AND 
       (V_UFORIGEM = 'MG') AND 
       (V_UFSACADO = 'MG') AND
       (P_DATAEMBARQUE <= to_date('30/09/2014','dd/mm/yyyy'))
       THEN
      P_LEI := 'ICMS ST de responsabilidade do remetente/alienante.';
    END IF;

    --17/12/2007
    --SOLICITADO POR MOREIRA CARGAS C/ ORIGEM MG E SE FOR EXPORTAC?O

    IF V_TRIGGER <> 'F' THEN
    
      IF V_UFORIGEM = 'MG' AND vMercadoria = 'EX' THEN
        
        begin
          P_LEI := 'Isento cf.Parte 1-AnexoI-Item 126-Dec.43.080/02-RICMS/MG';
          V_TIPO := 'I'; 
          P_TIPORETORNO := 'I';
          UPDATE T_CON_calcCONHECIMENTO C
            SET C.CON_CALCVIAGEM_VALOR = 0
          WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
            AND C.CON_CONHECIMENTO_SERIE = P_SERIE
            and nvl(c.con_conhecimento_altaltman,'N') = 'N'
            AND c.slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS')
            AND C.GLB_ROTA_CODIGO = P_ROTA;
          if sql%rowcount > 0 Then
              UPDATE T_CON_CONHECIMENTO C
                SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
              WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
                AND C.CON_CONHECIMENTO_SERIE = P_SERIE
                AND C.GLB_ROTA_CODIGO = P_ROTA;
          End If;   
              
         exception when others then
             raise_application_error(-20001, sqlerrm || chr(13) || 
              'CTRC: ' || P_CTRC || ' Serie: ' || P_SERIE || ' Rota: ' || P_ROTA || chr(13) ||
               dbms_utility.format_error_backtrace);
         end;
         
      END IF;
    
    END IF;

    IF V_UFORIGEM = 'SP' AND vMercadoria = '69' THEN
      P_LEI := 'Não-Incidencia do ICMS-Art.7,Inciso XIII';
    END IF;
    
/*
     -- RETIRADO EM 07/11/2016 Sirlano

    IF NVL(P_ROTA, '000') = '170' AND P_TIPORETORNO <> 'I' THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.087-25/07/08';
    ELSIF NVL(P_ROTA, '000') = '165' AND P_TIPORETORNO <> 'I' AND P_DATAEMBARQUE >= to_date('23/05/2016','dd/mm/yyyy') THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.120/16-23/05/16';
    ELSIF NVL(P_ROTA, '000') = '165' AND P_TIPORETORNO <> 'I' AND P_DATAEMBARQUE >= to_date('09/09/2008','dd/mm/yyyy') THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.109-05/09/08';
    ELSIF NVL(P_ROTA, '000') = '175' AND P_TIPORETORNO <> 'I' AND P_DATAEMBARQUE >= to_date('25/05/2016','dd/mm/yyyy') THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.Trib.Diferenciado nr.122/16-25/05/16';
    ELSIF NVL(P_ROTA, '000') = '175' AND P_TIPORETORNO <> 'I' AND P_DATAEMBARQUE >= to_date('25/07/2016','dd/mm/yyyy') THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.122-25/05/16';
    ELSIF NVL(P_ROTA, '000') = '175' AND P_TIPORETORNO <> 'I' AND P_DATAEMBARQUE >= to_date('09/09/2008','dd/mm/yyyy') THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.108-05/09/08';
    ELSIF NVL(P_ROTA, '000') = '160' AND P_TIPORETORNO <> 'I' AND P_DATAEMBARQUE >= to_date('11/07/2016','dd/mm/yyyy') THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.142/16-15/06/16';
    ELSIF NVL(P_ROTA, '000') = '160' AND P_TIPORETORNO <> 'I' AND P_DATAEMBARQUE >= to_date('09/09/2008','dd/mm/yyyy') THEN
      P_LEI := 'Rec.ICMS ate dia 10 do mes sub do fato gerador,AUT.Reg.Esp.110-05/09/08';
    ELSIF V_UFORIGEM = 'SP' AND V_UFDESTINO = 'EX' THEN
      V_TIPO := 'I';
      P_TIPORETORNO := 'I';
      P_LEI  := 'ISENTO ICMS Art.149 Anexo I do RICMS-SP';
      UPDATE T_CON_calcCONHECIMENTO C
        SET C.CON_CALCVIAGEM_VALOR = 0
      WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
        AND C.CON_CONHECIMENTO_SERIE = P_SERIE
        and nvl(c.con_conhecimento_altaltman,'N') = 'N'
        AND c.slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS')
        AND C.GLB_ROTA_CODIGO = P_ROTA;
          if sql%rowcount > 0 Then
              UPDATE T_CON_CONHECIMENTO C
                SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
              WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
                AND C.CON_CONHECIMENTO_SERIE = P_SERIE
                AND C.GLB_ROTA_CODIGO = P_ROTA;
          End If;   
      
    END IF;
*/


    If P_TIPORETORNO <> 'I' Then

       Begin 
         select t.glb_rotalei_lei
            into P_LEI
         from tdvadm.t_glb_rotalei t 
         where t.glb_rotalei_ativo = 'S'
           and t.glb_rota_codigo = NVL(P_ROTA, '000')
           and t.glb_rotalei_vigencia = (select max(t1.glb_rotalei_vigencia)
                                         from tdvadm.t_glb_rotalei t1
                                         where t1.glb_rota_codigo = t.glb_rota_codigo
                                           and t1.glb_rotalei_ativo = 'S');
       Exception
         When NO_DATA_FOUND Then
            P_LEI := P_LEI;
       End;
    ElsIF V_UFORIGEM = 'SP' AND V_UFDESTINO = 'EX' THEN
       V_TIPO := 'I';
       P_TIPORETORNO := 'I';
       P_LEI  := 'ISENTO ICMS Art.149 Anexo I do RICMS-SP';
       UPDATE T_CON_calcCONHECIMENTO C
         SET C.CON_CALCVIAGEM_VALOR = 0
       WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
         AND C.CON_CONHECIMENTO_SERIE = P_SERIE
         and nvl(c.con_conhecimento_altaltman,'N') = 'N'
         AND c.slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS')
         AND C.GLB_ROTA_CODIGO = P_ROTA;
           if sql%rowcount > 0 Then
               UPDATE T_CON_CONHECIMENTO C
                 SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
               WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
                 AND C.CON_CONHECIMENTO_SERIE = P_SERIE
                 AND C.GLB_ROTA_CODIGO = P_ROTA;
           End If;   
      
    END IF;
        
    IF ( INSTR(UPPER(NVL(P_LEI,'SIRLANO')),'PRESUMIDO') = 0 ) and ( vCalculo = 'C' ) THEN
       P_LEI := SUBSTR('OPT.CRED.PRESUMIDO-CONV.ICMS 106/96' || '-' || TRIM(P_LEI),1,200);
    END IF;    

    -- SE OS PARAMETROS DE IDENTIFICAC?O DO CONHECIMENTO FORAM PASSADOS
    -- VERIFICA SE O CONHECIMENTO N?O FOI IMPRESSO E GRAVA A LEI
    IF (V_IMPRESSO IS NOT NULL) AND (NVL(V_IMPRESSO, 'D') <> 'I') AND
       ((P_CTRC IS NOT NULL) or (LENGTH(TRIM(NVL(P_CTRC, ''))) = 6)) THEN
      if P_DATAEMBARQUE >= to_date('01/01/2007','dd/mm/yyyy') then
        
        
        IF V_TRIGGER <> 'F' THEN
--          BEGIN

/*            IF P_CTRC = '141662' THEN
               
               INSERT INTO DROPME(A,X) VALUES(TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')||' - '||P_LEI,'141662 - 1'||               P_SOLFRETE_CODIGO || chr(10) ||
               P_SOLFRETE_SAQUE || chr(10) ||
               P_LOCALIDADE_ORIGEM || chr(10) ||
               P_LOCALIDADE_DESTINO || chr(10) ||
               P_ROTA_CODIGO || chr(10) ||
               P_MERCADORIA_CODIGO || chr(10) ||
               V_CLIENTE_REMETENTE || chr(10) ||
               V_CLIENTE_SACADO || chr(10) ||
               P_TIPORETORNO || chr(10) ||
               P_DATAEMBARQUE || chr(10) ||
               P_LEI || chr(10) ||
               P_CTRC || chr(10) ||
               P_SERIE || chr(10) ||
               P_ROTA||' - '||DBMS_UTILITY.format_call_stack);
               
            END IF;*/
            
            
            IF V_TRIGGER <> 'S' THEN
            Begin
                UPDATE T_CON_CONHECIMENTO C
                   SET C.CON_CONHECIMENTO_OBSLEI = substr(trim(P_LEI) || ' ' || trim(vGLOBALIZADO),1,200),
                     c.con_conhecimento_cst = decode(P_TIPORETORNO,'T','00',
                                                                   'I','40',
                                                                   'S',decode(V_UFORIGEM,'BA','90','60'),'20')
                 WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
                   AND C.CON_CONHECIMENTO_SERIE = P_SERIE
                   AND C.GLB_ROTA_CODIGO = P_ROTA;
                

              EXCEPTION
                WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Trigger' || V_TRIGGER ||' - Lei '|| P_LEI ||' - Glob' || vGLOBALIZADO || ' Ctre ' || P_CTRC||' - sr  '||P_SERIE||' - rt '||P_ROTA || '- erro-' || sqlerrm);
              END;
          END IF;  
        END IF;
      end if;
    END IF;
  END IF;


  -- 14/07/2010 KLAYTON/SIRLANO SOMENTE FAZ A VERIFICAÇÃO PARA SOLICITAÇÃO
   -- ver sobre contrato
   -- sirlano 22/04/201
   BEGIN
      If TRIM(V_SOLFRETE_TABELA) = 'SOL' Then 
         SELECT fn_limpa_campo3(S.SLF_SOLFRETE_OBSSOLICITACAO),
                s.slf_solfrete_contrato,
                S.SLF_SOLFRETE_IMPRIMEOBSCTRC
           INTO V_OBSSOLFRETE,
                v_Contrato,
                V_IMPRIMEOBSCTRC
         FROM T_SLF_SOLFRETE S,
              T_CON_CONHECIMENTO CC
         WHERE CC.CON_CONHECIMENTO_CODIGO = P_CTRC 
           AND CC.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND CC.GLB_ROTA_CODIGO         = P_ROTA
           AND S.SLF_SOLFRETE_CODIGO = CC.SLF_SOLFRETE_CODIGO
           AND S.SLF_SOLFRETE_SAQUE = CC.SLF_SOLFRETE_SAQUE;
      Else      
         SELECT S.SLF_TABELA_OBSTABELA,
                s.slf_tabela_contrato,
                (fn_limpa_campo3(S.SLF_TABELA_IMPRIMEOBSCTRC))
           INTO V_OBSSOLFRETE,
                v_Contrato,
                V_IMPRIMEOBSCTRC
           FROM T_SLF_TABELA S,
                T_CON_CONHECIMENTO CC
          WHERE CC.CON_CONHECIMENTO_CODIGO = P_CTRC 
            AND CC.CON_CONHECIMENTO_SERIE  = P_SERIE
            AND CC.GLB_ROTA_CODIGO         = P_ROTA
            AND S.SLF_TABELA_CODIGO = CC.SLF_TABELA_CODIGO
            AND S.SLF_TABELA_SAQUE  = CC.SLF_TABELA_SAQUE;
      End If;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         V_OBSSOLFRETE := '';
         V_CONTRATO    := '';
         V_IMPRIMEOBSCTRC := 'N';
         
      WHEN OTHERS THEN
         V_OBSSOLFRETE := '';
         V_CONTRATO    := '';
         V_IMPRIMEOBSCTRC := 'N';
   END;  
   
   IF V_IMPRIMEOBSCTRC = 'N' THEN
      V_OBSSOLFRETE := '';
   END IF;
     -- if V_IMPRESSO <> 'I' then           
   IF (NVL(V_IMPRESSO, 'D') <> 'I')  THEN
   IF (V_OBSSOLFRETE IS NOT NULL) and (V_TRIGGER <> 'F') THEN  
                
     --   V_OBSSOLFRETE := V_OBSSOLFRETE || 'SIR';
/*       if ( nvl(c.con_conhecimento_obs,'SIRLANO') = 'SIRLANO' ) or 
          ( length(trim(c.con_conhecimento_obs)) = 0 ) then
           UPDATE T_CON_CONHECIMENTO C
             SET C.CON_CONHECIMENTO_OBS = trim(V_OBSSOLFRETE)
           WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
             AND C.CON_CONHECIMENTO_SERIE = P_SERIE
             AND C.GLB_ROTA_CODIGO = P_ROTA;
        else
*/ 
          IF ( INSTR(UPPER(NVL(P_LEI,'SIRLANO')),'PRESUMIDO') = 0 ) and ( vCalculo = 'C' ) THEN
             P_LEI := SUBSTR('OPT.CRED.PRESUMIDO-CONV.ICMS 106/96' || '-' || TRIM(P_LEI),1,200);
          END IF;    
          
          
/*            IF P_CTRC = '141662' THEN
               
                              INSERT INTO DROPME(A,X) VALUES(TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')||' - '||P_LEI,'141662 - 1'||               P_SOLFRETE_CODIGO || chr(10) ||
               P_SOLFRETE_SAQUE || chr(10) ||
               P_LOCALIDADE_ORIGEM || chr(10) ||
               P_LOCALIDADE_DESTINO || chr(10) ||
               P_ROTA_CODIGO || chr(10) ||
               P_MERCADORIA_CODIGO || chr(10) ||
               V_CLIENTE_REMETENTE || chr(10) ||
               V_CLIENTE_SACADO || chr(10) ||
               P_TIPORETORNO || chr(10) ||
               P_DATAEMBARQUE || chr(10) ||
               P_LEI || chr(10) ||
               P_CTRC || chr(10) ||
               P_SERIE || chr(10) ||
               P_ROTA||' - '||DBMS_UTILITY.format_call_stack);
               
            END IF;*/
          
          IF V_TRIGGER <> 'S' THEN
            
          UPDATE T_CON_CONHECIMENTO C
             SET C.SLF_SOLFRETE_OBSSOLICITACAO = trim(V_OBSSOLFRETE),
                 C.CON_CONHECIMENTO_OBSLEI = SUBSTR(trim(P_LEI) || ' ' || trim(vGLOBALIZADO),1,200),
                 c.con_conhecimento_cst = decode(P_TIPORETORNO,'T','00',
                                                               'I','40',
                                                               'S',decode(V_UFORIGEM,'BA','90','60'),'20')
           WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
             AND C.CON_CONHECIMENTO_SERIE = P_SERIE
             AND C.GLB_ROTA_CODIGO = P_ROTA;
         
          END IF;

--          if P_CTRC = '617430' then
--             raise_application_error(-20001,'Pomba o Retorno - ' || V_TRIGGER || to_char(sql%rowcount ));
--          end if; 



--        end if;  

/*      if P_MERCADORIA_CODIGO='EX' Then
         UPDATE T_CON_CONHECIMENTO C
           SET C.CON_CONHECIMENTO_OBS = TRIM(C.CON_CONHECIMENTO_OBS) || '-' || V_OBSSOLFRETE
         WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND C.CON_CONHECIMENTO_SERIE = P_SERIE
           AND C.GLB_ROTA_CODIGO = P_ROTA
           and instr(LOWER(NVL(c.con_conhecimento_obs,'SIRLANO')),LOWER(TRIM(V_OBSSOLFRETE))) = 0;
      end if;
*/      end if;
   END IF;

--       IF P_CTRC = '467009' THEN
--         RAISE_APPLICATION_ERROR(-20001,'SIRLANO -' || v_Contrato || '-' || V_SOLFRETE_TABELA || '-' || V_TRIGGER);
--       END IF;

   IF ( INSTR(UPPER(NVL(P_LEI,'SIRLANO')),'PRESUMIDO') = 0 ) and ( vCalculo = 'C' ) THEN
      P_LEI := SUBSTR('OPT.CRED.PRESUMIDO-CONV.ICMS 106/96' || '-' || TRIM(P_LEI),1,200);
   END IF;    
   IF (V_TRIGGER <> 'F') THEN 
   
/*    IF P_CTRC = '141662' THEN
               
               INSERT INTO DROPME(A,X) VALUES(TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')||' - '||P_LEI,'141662 - 1'||               P_SOLFRETE_CODIGO || chr(10) ||
               P_SOLFRETE_SAQUE || chr(10) ||
               P_LOCALIDADE_ORIGEM || chr(10) ||
               P_LOCALIDADE_DESTINO || chr(10) ||
               P_ROTA_CODIGO || chr(10) ||
               P_MERCADORIA_CODIGO || chr(10) ||
               V_CLIENTE_REMETENTE || chr(10) ||
               V_CLIENTE_SACADO || chr(10) ||
               P_TIPORETORNO || chr(10) ||
               P_DATAEMBARQUE || chr(10) ||
               P_LEI || chr(10) ||
               P_CTRC || chr(10) ||
               P_SERIE || chr(10) ||
               P_ROTA||' - '||DBMS_UTILITY.format_call_stack);
               
    END IF;*/
   
      UPDATE T_CON_CONHECIMENTO C
        SET C.CON_CONHECIMENTO_OBS = TRIM(NVL(C.CON_CONHECIMENTO_OBS,'')) || DECODE(NVL(v_Contrato,'NAOUPD'),'NAOUPD','','-CONTRATO-' || upper(trim(v_Contrato))),
            C.CON_CONHECIMENTO_OBSLEI = substr(TRIM(P_LEI) || ' ' || trim(vGLOBALIZADO),1,200),
            c.con_conhecimento_cst = decode(P_TIPORETORNO,'T','00',
                                                          'I','40',
                                                          'S',decode(V_UFORIGEM,'BA','90','60'),'20')
      WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
        AND C.CON_CONHECIMENTO_SERIE = P_SERIE
        AND C.GLB_ROTA_CODIGO = P_ROTA
        and instr(upper(trim(NVL(c.con_conhecimento_obs,'SIRLANO'))),upper(trim(v_Contrato)),1) = 0;
--       IF P_CTRC = '467009' THEN
--         RAISE_APPLICATION_ERROR(-20001,'-CONTRATO-' || upper(trim(v_Contrato)));
--        END IF;


    if P_ROTA in ('060','061') Then
      
           Begin
              Select CASE nvl(A1.ARM_COLETA_NORMALIMPEXP,'N')   
                         WHEN 'N' Then replace (SUBSTR(A1.ARM_COLETA_OBS,346, 88), CHR(13), '')
                         WHEN 'I' Then 'DI-' || a1.arm_coleta_direserva || ' RF CLI-' || a1.arm_coleta_codcli || ' RF DESP-' || a1.arm_coleta_coddesp || ' NAVIO-' || a1.arm_coleta_navio
                         WHEN 'E' Then 'RESERV-' || a1.arm_coleta_direserva || ' RF CLI-' || a1.arm_coleta_codcli || ' RF DESP-' || a1.arm_coleta_coddesp || ' NAVIO-' || a1.arm_coleta_navio
                      END COLETA_01OBS,
                      CASE A1.ARM_COLETA_NORMALIMPEXP   
                         WHEN 'N' Then replace (SUBSTR(A1.ARM_COLETA_OBS,434, 88), CHR(13), '')
                         WHEN 'I' Then 'CONT-'||a1.arm_coleta_containertp||'PES-'||a1.arm_coleta_containercod||' COLETA-'|| a1.arm_coleta_terminalcol ||' ENTREGA-'||a1.arm_coleta_terminalent
                         WHEN 'E' Then 'CONT-'||a1.arm_coleta_containertp||'PES-'||a1.arm_coleta_containercod||' COLETA-'|| a1.arm_coleta_terminalcol ||' ENTREGA-'||a1.arm_coleta_terminalent||' PORTO-'|| a1.arm_coleta_porto
                      END COLETA_02OBS
                into vOBS1,
                     vOBS2
              From t_arm_coleta a1,
                   t_con_conhecimento c
              where c.con_conhecimento_codigo = P_CTRC
                and c.con_conhecimento_serie = P_SERIE
                and c.glb_rota_codigo = P_ROTA
                and a1.arm_coleta_ncompra = c.arm_coleta_ncompra
                and a1.arm_coleta_ciclo = c.arm_coleta_ciclo
                and a1.arm_coleta_direserva is not null
                and c.arm_carregamento_codigo is null;

             UPDATE T_CON_CONHECIMENTO C
                SET C.CON_CONHECIMENTO_OBS    = SUBSTR(TRIM(NVL(C.CON_CONHECIMENTO_OBS,'')) || ' ' || vOBS1 || ' ' || vOBS2,1,200)
              WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
                AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
                AND C.GLB_ROTA_CODIGO         = P_ROTA;
                
           Exception
             WHEN NO_DATA_FOUND Then
                vOBS1 := '';
                vOBS2 := '';
             End ;     

    End IF;



    IF V_UFORIGEM = 'SP' AND V_UFDESTINO = 'EX' THEN
      V_TIPO := 'I';
      P_TIPORETORNO := 'I';
      P_LEI  := 'ISENTO ICMS Art.149 Anexo I do RICMS-SP';
      UPDATE T_CON_calcCONHECIMENTO C
        SET C.CON_CALCVIAGEM_VALOR = 0
      WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
        AND C.CON_CONHECIMENTO_SERIE = P_SERIE
        and nvl(c.con_conhecimento_altaltman,'N') = 'N'
        AND c.slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS')
        AND C.GLB_ROTA_CODIGO = P_ROTA;
          if sql%rowcount > 0 Then
              UPDATE T_CON_CONHECIMENTO C
                SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
              WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
                AND C.CON_CONHECIMENTO_SERIE = P_SERIE
                AND C.GLB_ROTA_CODIGO = P_ROTA;
          End If;   
      
    ElsiF V_UFORIGEM = 'MG' AND vMercadoria = 'EX' THEN
        
        begin
          V_TIPO := 'I'; 
          P_TIPORETORNO := 'I';  
          P_LEI := 'Isento cf.Parte 1-AnexoI-Item 126-Dec.43.080/02-RICMS/MG';
          UPDATE T_CON_calcCONHECIMENTO C
            SET C.CON_CALCVIAGEM_VALOR = 0
          WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
            AND C.CON_CONHECIMENTO_SERIE = P_SERIE
            and nvl(c.con_conhecimento_altaltman,'N') = 'N'
            AND c.slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS')
            AND C.GLB_ROTA_CODIGO = P_ROTA;
          if sql%rowcount > 0 Then
              UPDATE T_CON_CONHECIMENTO C
                SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
              WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
                AND C.CON_CONHECIMENTO_SERIE = P_SERIE
                AND C.GLB_ROTA_CODIGO = P_ROTA;
          End If;   
         exception when others then
             raise_application_error(-20001, sqlerrm || chr(13) || 
              'CTRC: ' || P_CTRC || ' Serie: ' || P_SERIE || ' Rota: ' || P_ROTA || chr(13) ||
               dbms_utility.format_error_backtrace);
         end;
         
    -- Retirado a MERCADORIA DA FIBRIA em 27/10/2017
    -- TODAS AS CARGAS DA FIBRIA SERAO SUBSTITUICAO TRIBUTARIA
    ElsiF V_UFORIGEM = 'MS' /*AND vMercadoria = 'EX'*/ and trim(V_CLIENTE_SACADO) in ('36785418001502','60643228061503') THEN
        
          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
          P_LEI := 'ICMS SERA RECOLHIDO P/REMETENTE MERCADORIA RE 11/049202/2013';
          UPDATE T_CON_CONHECIMENTO C
            SET C.CON_CONHECIMENTO_TRIBUTACAO = 'S'
          WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
            AND C.CON_CONHECIMENTO_SERIE = P_SERIE
            AND C.GLB_ROTA_CODIGO = P_ROTA;

    ElsIf V_UFORIGEM = 'MS' and trim(V_CLIENTE_SACADO) in ('16404287044870') and P_LOCALIDADE_ORIGEM in ('79600','79601') Then

          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
          P_LEI := 'ICMS retido pelo remetente da mercadoria.';


          UPDATE T_CON_CONHECIMENTO C
            SET C.CON_CONHECIMENTO_TRIBUTACAO = 'S'
          WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
            AND C.CON_CONHECIMENTO_SERIE = P_SERIE
            AND C.GLB_ROTA_CODIGO = P_ROTA;
    END IF;



   ELSE

    IF V_UFORIGEM = 'SP' AND V_UFDESTINO = 'EX' THEN
      V_TIPO := 'I';
      P_TIPORETORNO := 'I';
      P_LEI  := 'ISENTO ICMS Art.149 Anexo I do RICMS-SP';
      
    ElsiF V_UFORIGEM = 'MG' AND vMercadoria = 'EX' THEN
        
          V_TIPO := 'I'; 
          P_TIPORETORNO := 'I';  
          P_LEI := 'Isento cf.Parte 1-AnexoI-Item 126-Dec.43.080/02-RICMS/MG';
    -- Retirado a MERCADORIA DA FIBRIA em 27/10/2017
    -- TODAS AS CARGAS DA FIBRIA SERAO SUBSTITUICAO TRIBUTARIA
    ElsiF V_UFORIGEM = 'MS' /*AND vMercadoria = 'EX'*/ and trim(V_CLIENTE_SACADO) in ('36785418001502','60643228061503') THEN
        
          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
          P_LEI := 'ICMS SERA RECOLHIDO P/REMETENTE MERCADORIA RE 11/049202/2013';

    ElsIf V_UFORIGEM = 'MS' and trim(V_CLIENTE_SACADO) in ('16404287044870') and P_LOCALIDADE_ORIGEM in ('79600','79601') Then

          V_TIPO := 'S'; 
          P_TIPORETORNO := 'S';  
          P_LEI := 'ICMS retido pelo remetente da mercadoria.';


    END IF;
 

     
   END IF;
   

/*   If p_rota = '210' Then
     V_TIPO := 'I'; 
     P_TIPORETORNO := 'I';
   End If;*/
   
   
           select count (*)
               into vAchou
            from tdvadm.t_con_conhecimento cte,
                 tdvadm.t_con_consigredespacho co,
                 tdvadm.t_glb_ramoatividade ta,
                 tdvadm.t_glb_cliente cl
            where cte.con_conhecimento_codigo = co.con_conhecimento_codigo
              and cte.con_conhecimento_serie  = co.con_conhecimento_serie
              and cte.glb_rota_codigo         = co.glb_rota_codigo
              and cl.glb_ramoatividade_codigo = ta.glb_ramoatividade_codigo
              and co.con_consigredespacho_cgccpf = cl.glb_cliente_cgccpfcodigo
              and ta.glb_ramoatividade_codigo = '06'
              and co.con_consigredespacho_flagcr = 'S'
              and cte.con_conhecimento_codigo = P_CTRC
              and cte.con_conhecimento_serie = P_SERIE
              and cte.glb_rota_codigo = P_ROTA;
              
              
   vSubContrat := 'N'; 
   If vAchou > 0 Then
     vSubContrat := 'S'; 
     V_TIPO := 'I'; 
     P_TIPORETORNO := 'I';
     P_LEI := substr(trim(trim(P_LEI) || '-ICMS RECOLHIDO PELO SUBCONTRATANTE '),1,200);
   End If;
   
     
              

    IF V_TRIGGER <> 'F' THEN
      
       IF P_CTRC IS NOT NULL then
         UPDATE T_CON_CONHECIMENTO C
           SET C.CON_CONHECIMENTO_TRIBUTACAO = substr(P_TIPORETORNO,1,1)
         WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND C.CON_CONHECIMENTO_SERIE = P_SERIE
           AND C.GLB_ROTA_CODIGO = P_ROTA;
       End If;
    End If;
    
   P_LEI := substr(trim(trim(P_LEI) || ' ' || trim(vGLOBALIZADO)),1,200);
    
   IF V_TRIGGER = 'N' THEN
      COMMIT;
   END IF;
--    if P_CTRC = '625028' then
--       raise_application_error(-20111,sql%rowcount);
--     end if;

  
END SP_VERIFICA_ISENCAO_SUBST;



  PROCEDURE SP_SLF_COPIACALCULO(P_CALCULOORIG   IN TDVADM.T_SLF_TPCALCULO.SLF_TPCALCULO_CODIGO%TYPE,
                                P_CALCULODEST   IN TDVADM.T_SLF_TPCALCULO.SLF_TPCALCULO_CODIGO%TYPE,
                                P_DESCRICAOCALC IN TDVADM.T_SLF_TPCALCULO.SLF_TPCODIGO_DESCRICAO%TYPE,
                                P_FORMULARIO    IN CHAR DEFAULT 'C',
                                P_STATUS        OUT CHAR,
                                P_MENSAGEM      OUT VARCHAR2)
  IS
    V_CONTADOR NUMBER;
  BEGIN
    P_STATUS := 'N';
    -- VERIFICA SE UMA DAS TABELAS FOI ALTERADA
    SELECT COUNT(*)
      INTO V_CONTADOR
    FROM USER_TAB_COLUMNS TC
    WHERE TC.TABLE_NAME = 'T_SLF_TPCALCULO';  
    IF COLUNAS_TPCALCULO <> V_CONTADOR THEN
       P_STATUS := 'E';
       P_MENSAGEM := 'Estrutura de Tabela(s) alterada(s) ' || chr(10) || 
                     'T_SLF_TPCALCULO' || chr(10);
    END IF;
    SELECT COUNT(*)
      INTO V_CONTADOR
    FROM USER_TAB_COLUMNS TC
    WHERE TC.TABLE_NAME = 'T_SLF_CALCULO';  
    IF COLUNAS_CALCULO <> V_CONTADOR THEN
       P_STATUS := 'E';
       P_MENSAGEM := P_MENSAGEM || 
                     'T_SLF_CALCULO' || chr(10);
    END IF;
    SELECT COUNT(*)
      INTO V_CONTADOR
    FROM USER_TAB_COLUMNS TC
    WHERE TC.TABLE_NAME = 'T_SLF_SEQCALCULO';  
    IF COLUNAS_SEQCALCULO <> V_CONTADOR THEN
       P_STATUS := 'E';
       P_MENSAGEM := P_MENSAGEM || 
                     'T_SLF_SEQCALCULO' || chr(10);
    END IF;

    -- VERIFICA SE JA EXISTE O CALCULO ORIGEM
    SELECT COUNT(*)
      INTO V_CONTADOR
    FROM T_SLF_TPCALCULO TC
    WHERE TC.SLF_TPCALCULO_CODIGO = P_CALCULOORIG;
    IF V_CONTADOR = 0 THEN
      P_STATUS := 'E';
      P_MENSAGEM := P_MENSAGEM || 
                    'CALCULO '|| P_CALCULOORIG || ' ORIGEM NAO EXISTE' || CHR(10);
    END IF;  

    -- VERIFICA SE JA EXISTE UM CALCULO IGUAL
    SELECT COUNT(*)
      INTO V_CONTADOR
    FROM T_SLF_TPCALCULO TC
    WHERE TC.SLF_TPCALCULO_CODIGO = P_CALCULODEST;
    IF V_CONTADOR > 0 THEN
      P_STATUS := 'E';
      P_MENSAGEM := P_MENSAGEM || 
                    'CALCULO '|| P_CALCULODEST || ' DESTINO JA EXISTE' || CHR(10);
    END IF;  


    IF P_STATUS = 'N' THEN
        
       -- INSERE O CALCULO MAE
       INSERT INTO T_SLF_TPCALCULO 
       (SLF_TPCALCULO_CODIGO,
        SLF_TPCODIGO_DESCRICAO,
        SLF_TPCALCULO_CALCULOMAE,
        SLF_TPCALCULO_FORMULARIO)
       VALUES
       (P_CALCULODEST,
        P_DESCRICAOCALC,
        'S',
        P_FORMULARIO);
            
       INSERT INTO T_SLF_CALCULO
       SELECT P_CALCULODEST,        
              SLF_RECCUST_CODIGO,
              SLF_CALCULO_TPCAMPO,
              SLF_CALCULO_VERBAPRINCIPAL,
              SLF_CALCULO_PRECISAO,
              SLF_CALCULO_REEMBOLSO,
              SLF_CALCULO_REQUERIDOSOLFRETE,
              SLF_CALCULO_REQUERIDOTABELA,
              SLF_CALCULO_REQUERIDOCONHECIME,
              SLF_CALCULO_REQUERIDOVIAGEM,
              SLF_CALCULO_DSPSOLFRETE,
              SLF_CALCULO_DSPTABELA,
              SLF_CALCULO_DSPCONHECIMENTO,
              SLF_CALCULO_IMPSOLFRETE,
              SLF_CALCULO_DSPVIAGEM,
              SLF_CALCULO_IMPTABELA,
              SLF_CALCULO_IMPCONHECIMENTO,
              SLF_CALCULO_NIVELVISAO,
              SLF_CALCULO_SEQSOLFRETE,
              SLF_CALCULO_IMPVIAGEM,
              SLF_CALCULO_SEQTABELA,
              SLF_CALCULO_SEQCONECIMENTO,
              SLF_CALCULO_ALTERAVIAGEM,
              SLF_CALCULO_ALTERACONHECIM,
              SLF_CALCULO_IDENTIFICADOR,
              SLF_GPVERBAS_CODIGO,
              SLF_CALCULO_ALTMANCONHEC,
              SLF_CALCULO_ALTMANSOLFRETE,
              SLF_CALCULO_ALTMANTABELA,
              SLF_CALCULO_ALTMANVIAGEM,
              SLF_CALCULO_SEQALTCONEC,
              SLF_CALCULO_TIPOVERBA
       FROM T_SLF_CALCULO C
       WHERE C.SLF_TPCALCULO_CODIGO = P_CALCULOORIG;
           
       INSERT INTO T_SLF_SEQCALCULO
       SELECT SLF_TPCALCULO_CODIGOSEQ,
              P_CALCULODEST,
              SLF_SEQCALCLULO_SEQUENCIA,
              SLF_SEQCALCULO_CALCSOLFRETE,
              SLF_SEQCALCULO_CALCTABELA,
              SLF_SEQCALCULO_CONECIMENTO,
              SLF_SEQCALCULO_CALCVIAGEM
       FROM T_SLF_SEQCALCULO SC
       WHERE SC.SLF_TPCALCULO_CODIGO = P_CALCULOORIG;
           
    END IF;          

  IF P_STATUS = 'N' THEN
     COMMIT;
  END IF;   

  END SP_SLF_COPIACALCULO;      


  PROCEDURE SP_MOVE_DADOS_CNHC_VIAG(V_NUMCONHEC_CLONE   IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    V_NUMCONHEC         IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    V_SERIECONHEC       IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    V_NUMVIAGEM_CLONE   IN T_CON_CALCVIAGEMDET.CON_VIAGEM_NUMERO%TYPE,
                                    V_SAQUEVIAGEM_CLONE IN T_CON_CALCVIAGEMDET.CON_VIAGAM_SAQUE%TYPE,
                                    V_ROTAVIAGEM_CLONE  IN T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                                    V_NUMFORMULARIO     IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_NRFORMULARIO%TYPE DEFAULT NULL) IS
  --  V_QTDECONHEC NUMBER;
  V_TOTAL      NUMBER;
  V_X          NUMBER;
  V_DATA                       DATE;
  vROTA_CODIGOPROGCARGADET    T_PRG_PROGCARGADET.GLB_ROTA_CODIGO%TYPE;
  V_PROGCARGA_CODIGO           T_PRG_PROGCARGADET.PRG_PROGCARGA_CODIGO%TYPE;
  V_PROGCARGADET_SEQUENCIA     T_PRG_PROGCARGADET.PRG_PROGCARGADET_SEQUENCIA%TYPE;
  V_Rota_Codgenerico           T_glb_rota.glb_Rota_Codgenerico%type;
  V_Conhecimento_Dtembarque    T_con_conhecimento.Con_Conhecimento_Dtembarque%type;
  V_CLIENTE_CGCCPFDESTINATARIO CHAR(20);
  V_CLIENTE_CGCCPFSACADO       CHAR(20);
  V_CLIENTE_RAZAOSOCIAL        VARCHAR2(50);
  V_CLIENTE_RAZAOSOCIALREMET   VARCHAR2(50);
  V_NFTRANSPORTADA_NUMERO      CHAR(11);
  V_NFTRANSPORTADA_VALOR       CHAR(10);
  V_CONHECIMENTO_PLACA         CHAR(10);
  V_ROTA_DESCRICAO             VARCHAR2(50);
  vROTA_CODIGO                CHAR(3);
  V_ANTENA                     CHAR(7);
  v_texto                      varchar2(2000);
  v_MOTORISTA                  VARCHAR(80);
  V_CIDADEDES                  VARCHAR2(50);
  V_ESTADODES                  CHAR(2);
  V_CIDADEORI                  VARCHAR2(50);
  V_VLR_MERC                   VARCHAR2(20);
  V_ESTADOORI                  CHAR(2);
  v_valepedagio                char(1);
  V_GLB_ROTA                   CHAR(3);
  V_VERIFICA_VERBAS            NUMBER;
  V_MAIORCTRC                  T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_TERMINAL                   VARCHAR2(256);
  V_OSUSER                     VARCHAR2(256);
  V_RPS                        CHAR(1);
  V_NUMCONHECAUX               T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_ENVIAELE                   CHAR(1);
  V_ROTACTE                    T_GLB_ROTA.GLB_ROTA_CTE%TYPE;
  V_SERIECONHECAUX             T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  v_erro                       varchar2(4000);
  -- colcar aqui Sirlano
  vNotaCte                     char(1);
  vCalculo                     tdvadm.t_slf_tpcalculo.slf_tpcalculo_formulario%type;
  vDateFormatDel               varchar2(100);
  vObs                         tdvadm.t_con_conhecimento.con_conhecimento_obs%type;
  vStatus                      char(1);
  vMessage                     varchar2(200);
  vCarregamento                tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
  vLogSeq                      integer;
  BEGIN
    
    BEGIN
    --WHO_CALLED_ME2;
      
      BEGIN
        SELECT V.TERMINAL, V.OS_USER
          INTO V_TERMINAL, V_OSUSER
          FROM V_GLB_AMBIENTE V;
      EXCEPTION
        WHEN OTHERS THEN
          V_TERMINAL := '';
          V_OSUSER   := '';
      END;
         
      SELECT TO_DATE(to_CHAR(SYSDATE, 'dd/mm/yyyy'), 'DD/MM/YYYY')
        INTO V_DATA
        FROM DUAL;
        
      V_NUMCONHECAUX   := V_NUMCONHEC;
      V_SERIECONHECAUX := V_SERIECONHEC;
         
      Select Glb_Rota_Codigo
         INTO V_GLB_ROTA
      From T_Con_Conhecimento
      WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
        AND CON_CONHECIMENTO_SERIE = 'XXX';
          
      IF V_GLB_ROTA in ('530','180') THEN
         V_SERIECONHECAUX := 'A0';
      END IF;
      
      IF V_GLB_ROTA = '198' THEN
         V_SERIECONHECAUX := 'A1';
      END IF;    
          

      vCalculo := 'N';
      BEGIN
         select TP.SLF_TPCALCULO_FORMULARIO
           into vCalculo
         from T_CON_CALCCONHECIMENTO CA,
              T_SLF_TPCALCULO TP
         WHERE CA.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CA.CON_CONHECIMENTO_SERIE  = 'XXX'
           AND CA.GLB_ROTA_CODIGO         = V_GLB_ROTA      
           AND CA.SLF_TPCALCULO_CODIGO = TP.SLF_TPCALCULO_CODIGO
           AND TP.SLF_TPCALCULO_CALCULOMAE = 'S'
           AND CA.SLF_RECCUST_CODIGO = 'I_TTPV';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vCalculo := 'N';
        END ;     
          
      -- KLAYTON ANSELMO 20/12/2010
      -- VERIFICO SE É A ROTA É DE CTE 
      BEGIN
      SELECT NVL(RT.GLB_ROTA_CTE,'N')
        INTO V_ROTACTE
        FROM T_GLB_ROTA RT
       WHERE RT.GLB_ROTA_CODIGO = V_GLB_ROTA;
      EXCEPTION WHEN OTHERS THEN
            V_ROTACTE := 'N';
      END;
      

       -- KLAYTON ANSELMO 08/10/2010
       -- CASO O PARAMETRO RPS FOR 'S' ASSUMO O NUMERO DE RECUPERAÇAO COMO NUMERO OFICIAL 'PROVISORIAMENTE' 
      BEGIN
       select DECODE(COUNT(*),0,'N','S')
         into V_RPS
         from wservice.t_glb_rotaservicourl l
        where l.glb_rota_codigo = V_GLB_ROTA
          and l.glb_rotatpintegracao_cod in ('GOV','NFD')
          and l.glb_tpservico_cod        = 'ENVIARLOTE';
      EXCEPTION WHEN OTHERS THEN
             V_RPS := 'N';
      END;
       
      -- V_RPS := 'N';
       -- desabilitado klayton em 02/10/2018
       /* IF V_RPS = 'S' THEN
         V_NUMCONHECAUX := V_NUMCONHEC_CLONE;
          END IF;*/
      
      -- KLAYTON ANSELMO 08/10/2010
      -- PEGO O PARAMETRO ENV PARA SABER SE ENVIO OU NÃO O RPS PARA A PREFEITURA DEFALT S 
     
      BEGIN
         SELECT NVL(FN_QUERYSTRING(G.GLB_TPSERVICOPART_CODPART,'ENV'),'S')
           INTO V_ENVIAELE
           FROM WSERVICE.T_GLB_TPSERVICOPART G
          WHERE G.GLB_ROTA_CODIGO   = V_GLB_ROTA
            AND G.GLB_TPSERVICO_COD IN ('ENVIARLOTE','ENVIARCTE');
      EXCEPTION WHEN OTHERS THEN
            V_ENVIAELE := 'S';
      END;
           
            
      IF (V_GLB_ROTA = '461') AND (UPPER(V_TERMINAL) = 'NOTE_MNEVES') THEN
         V_ENVIAELE := 'N';
      END IF;  
       
     -- desabilitado klayton em 02/10/2018
     -- IF V_RPS <> 'S' THEN 
      
        SELECT MAX(C.CON_CONHECIMENTO_CODIGO)
          INTO V_MAIORCTRC
          FROM T_CON_CONHECIMENTO C
         WHERE C.GLB_ROTA_CODIGO = V_GLB_ROTA
           AND  C.CON_CONHECIMENTO_SERIE = TRIM(V_SERIECONHECAUX)
           AND C.CON_CONHECIMENTO_CODIGO < V_NUMCONHECAUX;

        IF V_GLB_ROTA not in ('194','571','230','000','188') THEN
           IF (TO_NUMBER(V_NUMCONHECAUX) - TO_NUMBER(V_MAIORCTRC)) > 100 OR 
              (TO_NUMBER(V_NUMCONHECAUX) - TO_NUMBER(V_MAIORCTRC)) <= 0 THEN
             
              RAISE_APPLICATION_ERROR(-20001,'NUMERAÇÃO MUITO ELEVADA, FAVOR VERIFICAR'||
              '- MAIOR - ' || V_MAIORCTRC ||
              '- SR    - ' || V_SERIECONHECAUX || 
              '- NRIMP - ' || V_NUMCONHECAUX ||
              '- INTERVALO - ' ||TO_CHAR((TO_NUMBER(V_NUMCONHECAUX) - TO_NUMBER(V_MAIORCTRC))));
             
           END IF;
        END IF;
       
   --   END IF; 

/* A pedido do Dr. Laerte, foi retirado da OBS a frase sobre a partilha
   31/07/2019 as 08:54
   Sirlano

      If V_RPS <> 'S' THEN
         tdvadm.pkg_fifo_carregctrc .sp_Partilha(V_NUMCONHEC_CLONE,'XXX',V_GLB_ROTA,vStatus,vMessage);
         Begin
            SELECT 'Partilha: ' || ll.vUFINI || ' x ' || ll.vUFFIM || 
                   ' (' || ll.picmsuffim || '%)' || 
                   ' BC ' || to_char(ll.vbscalculo ) || ' ORIGEM (20%) ' || to_char(ll.vicmsufini) || ' DESTINO (80%) ' || to_char(ll.vicmsuffim) ||
                   decode(ll.vfcpuffim,0,'',' FCP (' || to_char(ll.pfcpuffim) || '%) ' || to_char(ll.vfcpuffim))
               into vObs
            FROM tdvadm.v_cte_icmsuffim_3 LL
            WHERE LL.con_conhecimento_codigo = V_NUMCONHEC_CLONE
              AND LL.con_conhecimento_serie  = 'XXX'
              AND LL.glb_rota_codigo         = V_GLB_ROTA
              and ll.vUFINI <> ll.vUFFIM;
         Exception
           When NO_DATA_FOUND Then
              vObs := null;
           End;
           If vObs is not null Then
              update tdvadm.t_con_conhecimento c
                set c.con_conhecimento_obs = c.con_conhecimento_obs || ' ' || vObs
              Where c.con_conhecimento_codigo = V_NUMCONHEC_CLONE
                and c.con_conhecimento_serie = 'XXX'
                and c.glb_rota_codigo = V_GLB_ROTA;
           End If;
      End If;            

*/

      If vCalculo = 'C' Then
         tdvadm.pkg_fifo_carregctrc.sp_Partilha(V_NUMCONHEC_CLONE,'XXX',V_GLB_ROTA,vStatus,vMessage);
      End If;

      begin
       
        Select GLB_ROTA_CODGENERICO
          Into V_Rota_Codgenerico
          From T_Glb_Rota
         Where Glb_Rota_Codigo = V_GLB_ROTA;
        
      exception
        when no_data_found then
          v_rota_codgenerico := null;
         when others then
          v_rota_codgenerico :=  V_ROTAVIAGEM_CLONE;   
      end;

      BEGIN
        

         -- KLAYTON ANSELMO 20/12/2010
         -- SE FOR ROTA DE CTE SEMPRE COLOCO SYSDATE NA DATA DE EMBARQUE CON_CONHECIMENTO_DTEMBARQUE
         
         IF V_ROTACTE = 'S' THEN
            BEGIN
                 UPDATE T_CON_CONHECIMENTO CT
                    SET CT.CON_CONHECIMENTO_DTEMBARQUE = TRUNC(SYSDATE)
                  WHERE CT.CON_CONHECIMENTO_CODIGO     = V_NUMCONHEC_CLONE
                    AND CT.CON_CONHECIMENTO_SERIE      = 'XXX'
                    AND CT.GLB_ROTA_CODIGO             = V_GLB_ROTA;
            EXCEPTION WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20001,'ERRO AO IGUALAR DATA DE EMBARQUE COM DATA DO SISTEMA! ERRO: '||SQLERRM);
            END;
         
         END IF;
         


        INSERT INTO T_CON_CONHECIMENTO
          (CON_CONHECIMENTO_CODIGO,
           CON_CONHECIMENTO_SERIE,
           GLB_ROTA_CODIGOPROGCARGADET,
           GLB_ROTA_CODIGO,
           SLF_SOLFRETE_CODIGO,
           PRG_PROGCARGA_CODIGO,
           SLF_SOLFRETE_SAQUE,
           PRG_PROGCARGADET_SEQUENCIA,
           SLF_TABELA_CODIGO,
           SLF_TABELA_SAQUE,
           GLB_CLIENTE_CGCCPFREMETENTE,
           GLB_TPCLIEND_CODIGOREMETENTE,
           GLB_CLIENTE_CGCCPFDESTINATARIO,
           GLB_TPCLIEND_CODIGODESTINATARI,
           GLB_CLIENTE_CGCCPFSACADO,
           CON_VIAGEM_NUMERO,
           GLB_ROTA_CODIGOVIAGEM,
           CON_VIAGAM_SAQUE,
           GLB_MERCADORIA_CODIGO,
           GLB_EMBALAGEM_CODIGO,
           GLB_ROTA_CODIGOIMPRESSAO,
           CON_CONHECIMENTO_DTINCLUSAO,
           CON_CONHECIMENTO_LOCALCOLETA,
           CON_CONHECIMENTO_DTALTERACAO,
           GLB_LOCALIDADE_CODIGOORIGEM,
           GLB_LOCALIDADE_CODIGODESTINO,
           CON_CONHECIMENTO_LOCALENTREGA,
           CON_CONHECIMENTO_DTEMISSAO,
           CON_CONHECIMENTO_QTDEENTREGA,
           CON_CONHECIMENTO_NUMVIAGENS,
           CON_CONHECIMENTO_FLAGRECOLHIME,
           CON_CONHECIMENTO_FLAGCORTESIA,
           CON_CONHECIMENTO_FLAGCANCELADO,
           CON_CONHECIMENTO_FLAGBLOQUEADO,
           CON_CONHECIMENTO_DTEMBARQUE,
           CON_CONHECIMENTO_HORASAIDA,
           CON_CONHECIMENTO_OBS,
           CON_CONHECIMENTO_EMISSOR,
           CON_CONHECIMENTO_TPFRETE,
           CON_CONHECIMENTO_LOTE,
           CON_CONHECIMENTO_KILOMETRAGEM,
           CON_CONHECIMENTO_TPREGISTRO,
           CON_CONHECIMENTO_DTGRAVACAO,
           GLB_ROTA_CODIGOGENERICO,
           CON_CONHECIMENTO_CFO,
           CON_CONHECIMENTO_TRIBUTACAO,
           CON_CONHECIMENTO_TPCOMPLEMENTO,
           CON_CONHECIMENTO_DTTRANSF,
           CON_CONHECIMENTO_ESCOAMENTO,
           CON_CONHECIMENTO_NRFORMULARIO,
           CON_FATURA_CODIGO,
           CON_FATURA_CICLO,
           GLB_ROTA_CODIGOFILIALIMP,
           CON_CONHECIMENTO_TPFAN,
           CON_CONHECIMENTO_REDFRETE,
           CON_CONHECIMENTO_FLAGCOMPLEMEN,
           CON_CONHECIMENTO_FLAGESTADIA,
           GLB_ALTMAN_SEQUENCIA,
           CON_CONHECIMENTO_DIGITADO,
           CON_CONHECIMENTO_PLACA,
           CON_CONHECIMENTO_VENCIMENTO,
           CON_CONHECIMENTO_ENTREGA,
           CON_CONHECIMENTO_ATRAZO,
           CON_CONHECIMENTO_OBSDTENTREGA,
           CON_CONHECIMENTO_VLRINDENIZ,
           CON_CONHECIMENTO_PESOINDENIZ,
           CON_CONHECIMENTO_FATURAINDENIZ,
           CON_CONHECIMENTO_DTVENCINDENIZ,
           CON_CONHECIMENTO_AVARIAS,
           CON_CONHECIMENTO_DTCHEGMATRIZ,
           CON_VALEFRETE_CODIGO,
           CON_VALEFRETE_SERIE,
           GLB_ROTA_CODIGOVALEFRETE,
           CON_VALEFRETE_SAQUE,
           GLB_GERRISCO_CODIGO,
           CON_CONHECIMENTO_CODLIBERACAO,
           CON_CONHECIMENTO_AUTORISEG,
           CON_CONHECIMENTO_DTRECEBIMENTO,
           CON_CONHECIMENTO_DTCHEGCELULA,
           ARM_COLETA_NCOMPRA,
           arm_coleta_ciclo,
           --ARM_ARMAZEM_CODIGO             ,
           CON_CONHECIMENTO_DTENVSEG,
           CON_CONHECIMENTO_DTENVEDI,
           CON_CONHECIMENTO_OBSLEI,
           CON_CONHECIMENTO_OBSCLIENTE,
           GLB_ROTA_CODIGORECEITA,
           ARM_CARREGAMENTO_CODIGO,
           ARM_CARREGAMENTO_CODIGOPR,
           CON_CONHECIMENTO_TERMINAL,
           CON_CONHECIMENTO_OSUSER,
           CON_CONHECIMENTO_ENVIAELE,
           slf_solfrete_obssolicitacao,
           con_conhecimento_cst  
           )
          SELECT V_NUMCONHECAUX,
                 V_SERIECONHECAUX,
                 GLB_ROTA_CODIGOPROGCARGADET,
                 GLB_ROTA_CODIGO,
                 SLF_SOLFRETE_CODIGO,
                 PRG_PROGCARGA_CODIGO,
                 SLF_SOLFRETE_SAQUE,
                 PRG_PROGCARGADET_SEQUENCIA,
                 SLF_TABELA_CODIGO,
                 SLF_TABELA_SAQUE,
                 GLB_CLIENTE_CGCCPFREMETENTE,
                 GLB_TPCLIEND_CODIGOREMETENTE,
                 GLB_CLIENTE_CGCCPFDESTINATARIO,
                 GLB_TPCLIEND_CODIGODESTINATARI,
                 GLB_CLIENTE_CGCCPFSACADO,
                 CON_VIAGEM_NUMERO,
                 GLB_ROTA_CODIGOVIAGEM,
                 CON_VIAGAM_SAQUE,
                 GLB_MERCADORIA_CODIGO,
                 GLB_EMBALAGEM_CODIGO,
                 GLB_ROTA_CODIGOIMPRESSAO,
                 V_DATA,
                 CON_CONHECIMENTO_LOCALCOLETA,
                 null,
                 GLB_LOCALIDADE_CODIGOORIGEM,
                 GLB_LOCALIDADE_CODIGODESTINO,
                 CON_CONHECIMENTO_LOCALENTREGA,
                 CON_CONHECIMENTO_DTEMISSAO,
                 CON_CONHECIMENTO_QTDEENTREGA,
                 CON_CONHECIMENTO_NUMVIAGENS,
                 CON_CONHECIMENTO_FLAGRECOLHIME,
                 CON_CONHECIMENTO_FLAGCORTESIA,
                 CON_CONHECIMENTO_FLAGCANCELADO,
                 CON_CONHECIMENTO_FLAGBLOQUEADO,
                 CON_CONHECIMENTO_DTEMBARQUE,
                 sysdate, -- trocado em 05/08/2009 sirlano CON_CONHECIMENTO_HORASAIDA,
                 SUBSTR(CON_CONHECIMENTO_OBS, 1, 2000),
                 CON_CONHECIMENTO_EMISSOR,
                 CON_CONHECIMENTO_TPFRETE,
                 CON_CONHECIMENTO_LOTE,
                 CON_CONHECIMENTO_KILOMETRAGEM,
                 CON_CONHECIMENTO_TPREGISTRO,
                 V_DATA,
                 V_Rota_Codgenerico,
                 CON_CONHECIMENTO_CFO,
                 CON_CONHECIMENTO_TRIBUTACAO,
                 CON_CONHECIMENTO_TPCOMPLEMENTO,
                 CON_CONHECIMENTO_DTTRANSF,
                 CON_CONHECIMENTO_ESCOAMENTO,
                 V_NUMFORMULARIO,
                 --                                              CON_CONHECIMENTO_NRFORMULARIO  , 
                 CON_FATURA_CODIGO,
                 CON_FATURA_CICLO,
                 GLB_ROTA_CODIGOFILIALIMP,
                 CON_CONHECIMENTO_TPFAN,
                 CON_CONHECIMENTO_REDFRETE,
                 CON_CONHECIMENTO_FLAGCOMPLEMEN,
                 CON_CONHECIMENTO_FLAGESTADIA,
                 GLB_ALTMAN_SEQUENCIA,
                 CON_CONHECIMENTO_DIGITADO,
                 CON_CONHECIMENTO_PLACA,
                 CON_CONHECIMENTO_VENCIMENTO,
                 CON_CONHECIMENTO_ENTREGA,
                 CON_CONHECIMENTO_ATRAZO,
                 CON_CONHECIMENTO_OBSDTENTREGA,
                 CON_CONHECIMENTO_VLRINDENIZ,
                 CON_CONHECIMENTO_PESOINDENIZ,
                 CON_CONHECIMENTO_FATURAINDENIZ,
                 CON_CONHECIMENTO_DTVENCINDENIZ,
                 CON_CONHECIMENTO_AVARIAS,
                 CON_CONHECIMENTO_DTCHEGMATRIZ,
                 CON_VALEFRETE_CODIGO,
                 CON_VALEFRETE_SERIE,
                 GLB_ROTA_CODIGOVALEFRETE,
                 CON_VALEFRETE_SAQUE,
                 GLB_GERRISCO_CODIGO,
                 CON_CONHECIMENTO_CODLIBERACAO,
                 CON_CONHECIMENTO_AUTORISEG,
                 CON_CONHECIMENTO_DTRECEBIMENTO,
                 CON_CONHECIMENTO_DTCHEGCELULA,
                 ARM_COLETA_NCOMPRA,
                 arm_coleta_ciclo,
                 --ARM_ARMAZEM_CODIGO             ,
                 CON_CONHECIMENTO_DTENVSEG,
                 CON_CONHECIMENTO_DTENVEDI,
                 decode(vCalculo,'C',decode(INSTR(UPPER(CON_CONHECIMENTO_OBSLEI),'PRESUMIDO'),0,SUBSTR( 'OPT.CRED.PRESUMIDO-CONV.ICMS 106/96' || '-' || TRIM(CON_CONHECIMENTO_OBSLEI),1,200),CON_CONHECIMENTO_OBSLEI),CON_CONHECIMENTO_OBSLEI),
                 CON_CONHECIMENTO_OBSCLIENTE,
                 GLB_ROTA_CODIGORECEITA,
                 ARM_CARREGAMENTO_CODIGO,
                 ARM_CARREGAMENTO_CODIGOPR,
                 V_TERMINAL,
                 V_OSUSER,
                 V_ENVIAELE,
                 slf_solfrete_obssolicitacao,
                 con_conhecimento_cst
            FROM T_CON_CONHECIMENTO
           WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
             AND CON_CONHECIMENTO_SERIE = 'XXX';   
          
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  ' - RECUPERACAO ' || V_NUMCONHEC_CLONE ||
                                  '- CTRC ' || V_NUMCONHECAUX || ' - ROTA ' ||
                                  V_ROTAVIAGEM_CLONE || ' - ' || SQLERRM);
      END;

      UPDATE T_CON_CONHECCOMPLEMENTO
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   

      BEGIN
        SELECT Con_Conhecimento_Dtembarque
          Into v_Conhecimento_Dtembarque
          From T_Con_Conhecimento
         Where Con_Conhecimento_Codigo = V_NUMCONHEC_CLONE
           And Con_Conhecimento_Serie = 'XXX';   
      exception
        WHEN NO_DATA_FOUND THEN
          v_Conhecimento_Dtembarque := NULL;
      END;
      
      SELECT count(*)
        INTO V_VERIFICA_VERBAS
        FROM T_CON_CALCCONHECIMENTO
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';  
         
      IF(V_VERIFICA_VERBAS =0) THEN
      
            SELECT COUNT(*)
              INTO V_VERIFICA_VERBAS
              FROM T_CON_CALCCONHECIMENTO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX
               AND CON_CONHECIMENTO_SERIE = V_SERIECONHECAUX
               AND Glb_Rota_Codigo = V_ROTAVIAGEM_CLONE;
      
      END IF;
         
      IF (V_VERIFICA_VERBAS =0) THEN
        RAISE_APPLICATION_ERROR(-20002,' ERRO AO GERAR VERBAS sirlano 1633 SP_MOVE_DADOS_CNHC_VIAG ctrc ' ||
                                V_NUMCONHEC_CLONE || '-' || V_ROTAVIAGEM_CLONE || '-' || V_NUMCONHECAUX|| '-'||
                                SQLERRM);
      END IF;

      UPDATE T_CON_CALCCONHECIMENTO
         SET CON_CONHECIMENTO_CODIGO     = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE      = V_SERIECONHECAUX,
             CON_CONHECIMENTO_DTEMBARQUE = v_Conhecimento_Dtembarque
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   
      
      -- SELECT  GLB_ROTA_CODIGO    ,
      -- ALTERADO POR SIRLANO POR ACHAR QUE E O CERTO
      -- DEVE SE PEGAR A ROTA DA PROGRAMAC?O E NAO A ROTA DO CTRC

      BEGIN
        SELECT GLB_ROTA_CODIGOPROGCARGADET,
               PRG_PROGCARGA_CODIGO,
               PRG_PROGCARGADET_SEQUENCIA
          INTO vROTA_CODIGOPROGCARGADET,
               V_PROGCARGA_CODIGO,
               V_PROGCARGADET_SEQUENCIA
          FROM T_CON_CONHECIMENTO
         WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CON_CONHECIMENTO_SERIE = 'XXX';   
      exception
        WHEN NO_DATA_FOUND THEN
          vROTA_CODIGOPROGCARGADET := NULL;
          V_PROGCARGA_CODIGO        := NULL;
          V_PROGCARGADET_SEQUENCIA  := NULL;
      END;

      UPDATE T_PRG_PROGCARGADET
         SET PRG_PROGCARGADET_CONHECIMENTO = 'S'
       WHERE GLB_ROTA_CODIGO = vROTA_CODIGOPROGCARGADET
         AND PRG_PROGCARGA_CODIGO = V_PROGCARGA_CODIGO
         AND PRG_PROGCARGADET_SEQUENCIA = V_PROGCARGADET_SEQUENCIA;

      BEGIN
           UPDATE T_CON_CONSIGREDESPACHO
              SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
                  CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
            WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
              AND CON_CONHECIMENTO_SERIE = 'XXX';
      EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'ERRO AO CRIAR O CTRC '||V_SERIECONHECAUX||' '||V_NUMCONHECAUX||' '||V_NUMCONHEC_CLONE||' '||V_NUMVIAGEM_CLONE||' '||V_SAQUEVIAGEM_CLONE||' '||V_ROTAVIAGEM_CLONE ||SQLERRM);
      END;   
      
      BEGIN
           UPDATE T_CON_CONHECIMENTOREGESP R
              SET R.CON_CONHECIMENTO_CODIGO   = V_NUMCONHECAUX,
                  R.CON_CONHECIMENTO_SERIE    = V_SERIECONHECAUX
            WHERE R.CON_CONHECIMENTO_CODIGO   = V_NUMCONHEC_CLONE
              AND R.CON_CONHECIMENTO_SERIE    = 'XXX';
      EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'ERRO AO CRIAR O CTRC '||V_SERIECONHECAUX||' '||V_NUMCONHECAUX||' '||V_NUMCONHEC_CLONE||' '||V_NUMVIAGEM_CLONE||' '||V_SAQUEVIAGEM_CLONE||' '||V_ROTAVIAGEM_CLONE ||SQLERRM);
      END; 
      
       BEGIN
         
           UPDATE tdvadm.t_con_conhecsubst R
              SET R.CON_CONHECIMENTO_CODIGO   = V_NUMCONHECAUX,
                  R.CON_CONHECIMENTO_SERIE    = V_SERIECONHECAUX
            WHERE R.CON_CONHECIMENTO_CODIGO   = V_NUMCONHEC_CLONE
              AND R.CON_CONHECIMENTO_SERIE    = 'XXX';
              
      EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'ERRO AO CRIAR O CTRC '||V_SERIECONHECAUX||' '||V_NUMCONHECAUX||' '||V_NUMCONHEC_CLONE||' '||V_NUMVIAGEM_CLONE||' '||V_SAQUEVIAGEM_CLONE||' '||V_ROTAVIAGEM_CLONE ||SQLERRM);
      END; 
      
      BEGIN
           UPDATE tdvadm.t_con_conhecanula R
              SET R.CON_CONHECIMENTO_CODIGO   = V_NUMCONHECAUX,
                  R.CON_CONHECIMENTO_SERIE    = V_SERIECONHECAUX
            WHERE R.CON_CONHECIMENTO_CODIGO   = V_NUMCONHEC_CLONE
              AND R.CON_CONHECIMENTO_SERIE    = 'XXX';
      EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'ERRO AO CRIAR O CTRC '||V_SERIECONHECAUX||' '||V_NUMCONHECAUX||' '||V_NUMCONHEC_CLONE||' '||V_NUMVIAGEM_CLONE||' '||V_SAQUEVIAGEM_CLONE||' '||V_ROTAVIAGEM_CLONE ||SQLERRM);
      END;   
                                                                                                
                                                                                                                 
      BEGIN
        INSERT INTO tdvadm.T_CON_NFTRANSPORTA
          (CON_CONHECIMENTO_CODIGO,
           CON_CONHECIMENTO_SERIE,
           GLB_ROTA_CODIGO,
           CON_NFTRANSPORTADA_NUMNFISCAL,
           GLB_EMBALAGEM_CODIGO,
           CON_NFTRANSPORTADA_VALOR,
           CON_NFTRANSPORTADA_VOLUMES,
           CON_NFTRANSPORTADA_PESO,
           CON_NFTRANSPORTADA_UNIDADE,
           CON_NFTRANSPORTADA_NUMERO,
           CON_NFTTRANSPORTA_MERCADORIA,
           GLB_CLIENTE_CGCCPFCODIGO,
           CON_NFTRANSPORTADA_VALORSEG,
           CON_NFTRANSPORTADA_PESOCOBRADO,
           CON_NFTRANSPORTADA_LARGURA,
           CON_NFTRANSPORTADA_ALTURA,
           CON_NFTRANSPORTADA_COMPRIMENTO,
           CON_NFTRANSPORTADA_CUBAGEM,
           CON_NFTRANSPORTADA_REMONTA,
           CON_NFTRANSPORTADA_PESOCUBADO,
           CON_NFTRANSPORTADA_ARMAZEM,
           glb_cfop_codigo,
           con_nftransportada_valorbsicms,
           con_nftransportada_valoricms,
           con_nftransportada_vlbsicmsst,
           con_nftransportada_vlicmsst,
           con_nftransportada_chavenfe,
           con_nftransportada_dtemissao,
           con_nftransportada_dtsaida,
           con_nftransportada_serienf,
           con_tpdoc_codigo,
           arm_coleta_ncompra,
           arm_coleta_ciclo  )
          SELECT V_NUMCONHECAUX,
                 V_SERIECONHECAUX,
                 GLB_ROTA_CODIGO,
                 CON_NFTRANSPORTADA_NUMNFISCAL,
                 GLB_EMBALAGEM_CODIGO,
                 CON_NFTRANSPORTADA_VALOR,
                 CON_NFTRANSPORTADA_VOLUMES,
                 CON_NFTRANSPORTADA_PESO,
                 CON_NFTRANSPORTADA_UNIDADE,
                 CON_NFTRANSPORTADA_NUMERO,
                 CON_NFTTRANSPORTA_MERCADORIA,
                 GLB_CLIENTE_CGCCPFCODIGO,
                 CON_NFTRANSPORTADA_VALORSEG,
                 CON_NFTRANSPORTADA_PESOCOBRADO,
                 CON_NFTRANSPORTADA_LARGURA,
                 CON_NFTRANSPORTADA_ALTURA,
                 CON_NFTRANSPORTADA_COMPRIMENTO,
                 CON_NFTRANSPORTADA_CUBAGEM,
                 CON_NFTRANSPORTADA_REMONTA,
                 CON_NFTRANSPORTADA_PESOCUBADO,
                 CON_NFTRANSPORTADA_ARMAZEM,
                 glb_cfop_codigo,
                 con_nftransportada_valorbsicms,
                 con_nftransportada_valoricms,
                 con_nftransportada_vlbsicmsst,
                 con_nftransportada_vlicmsst,
                 con_nftransportada_chavenfe,
                 con_nftransportada_dtemissao,
                 con_nftransportada_dtsaida,
                 con_nftransportada_serienf,
                 con_tpdoc_codigo,
                 arm_coleta_ncompra,
                 arm_coleta_ciclo  
            FROM T_CON_NFTRANSPORTA
           WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
             AND CON_CONHECIMENTO_SERIE = 'XXX';
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20003,
                                  ' - Não foi possivel registrar o numero da nota!' ||
                                  V_NUMCONHEC_CLONE || V_NUMCONHECAUX ||
                                  V_SERIECONHECAUX || SQLERRM);
      END;
      
      UPDATE tdvadm.t_Con_Conheccfop 
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   
      

      UPDATE tdvadm.T_ARM_NOTA
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   

      UPDATE tdvadm.t_Arm_Notacte
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   

      UPDATE tdvadm.t_Con_Conheccfop 
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   

      begin
        UPDATE tdvadm.T_CON_NFTRANSPORTAEXTRA
           SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
               CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
         WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CON_CONHECIMENTO_SERIE = 'XXX';   
      exception
        WHEN DUP_VAL_ON_INDEX THEN
          delete tdvadm.T_CON_NFTRANSPORTAEXTRA
           WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX
             AND CON_CONHECIMENTO_SERIE = V_SERIECONHECAUX;
          UPDATE T_CON_NFTRANSPORTAEXTRA
             SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
                 CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
           WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
             AND CON_CONHECIMENTO_SERIE = 'XXX';   
      end;

      BEGIN
      
        SELECT R.GLB_ROTA_VALEPEDAGIO
          INTO v_valepedagio
          FROM tdvadm.T_GLB_ROTA R
         WHERE R.GLB_ROTA_CODIGO =
               (SELECT C.GLB_ROTA_CODIGO
                  FROM T_CON_CONHECIMENTO C
                 WHERE C.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                   AND C.CON_CONHECIMENTO_SERIE = 'XXX');
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  'NãO FOI ENCONTRADO O CONHECIMENTO XXX NR. CTRC CLONE: ' ||
                                  V_NUMCONHEC_CLONE);
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  'SELECT R.GLB_ROTA_VALEPEDAGIO  ' ||
                                  'INTO v_valepedagio   ' ||
                                  'FROM T_GLB_ROTA R ' ||
                                  ' WHERE R.GLB_ROTA_CODIGO = (SELECT C.GLB_ROTA_CODIGO FROM T_CON_CONHECIMENTO C ' ||
                                  'WHERE C.CON_CONHECIMENTO_CODIGO = ' ||
                                  V_NUMCONHEC_CLONE ||
                                  'AND C.CON_CONHECIMENTO_SERIE = XXX)');
      END;

      IF v_valepedagio = 'S' THEN
        UPDATE tdvadm.T_CON_CONHECVPED
           SET CON_CONHECIMENTO_CODIGO     = V_NUMCONHECAUX,
               CON_CONHECIMENTO_SERIE      = V_SERIECONHECAUX,
               CON_CONHECIMENTO_DTGRAVACAO = sysdate
         WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CON_CONHECIMENTO_SERIE = 'XXX';   
        --      AND (CON_CONHECVPED_VALOR <> 0 
        --        OR CON_CONHECIMENTO_VALORTDV <> 0);
      
        --                               AND 0 < (SELECT COUNT(*)
        --                                        FROM T_CON_MODALIDADEPED B
        --                                        WHERE B.CON_MODALIDADEPED_CODIGO = A.CON_MODALIDADEPED_CODIGO
        --                                          AND B.CON_MODALIDADEPED_COBROCLI = 'S')
        --                               AND 0 < (SELECT COUNT(*)
        --                                        FROM T_CON_FPAGTOMOTPED B
        --                                        WHERE B.CON_FPAGTOMOTPED_CODIGO = A.CON_FPAGTOMOTPED_CODIGO
        --                                          AND B.CON_FPAGTOMOTPED_PAGTOVFRETE = 'S');
      ELSE
        DELETE tdvadm.T_CON_CONHECVPED
         WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CON_CONHECIMENTO_SERIE = 'XXX';   
      
      END IF;
      
      
      BEGIN
      UPDATE tdvadm.T_CON_CONHECGSRMOV
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX'; 
       EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, V_NUMCONHECAUX||' -T_CON_CONHECGSRMOV- '||V_SERIECONHECAUX||'   '||V_NUMCONHEC_CLONE||' - '||SQLERRM);
        END;    

      begin
        SELECT A.CON_CONHECIMENTO_DTEMBARQUE,
               A.GLB_CLIENTE_CGCCPFDESTINATARIO,
               A.GLB_CLIENTE_CGCCPFSACADO,
               C.GLB_CLIENTE_RAZAOSOCIAL,
               G.GLB_CLIENTE_RAZAOSOCIAL,
               TRIM(TO_CHAR(B.CON_NFTRANSPORTADA_NUMERO, '9999999999')),
               A.CON_CONHECIMENTO_PLACA,
               TRIM(F_EXTRAI(1, F_RETORNAANTENA(A.CON_CONHECIMENTO_PLACA), '-')),
               SUBSTR(FN_NOME_MOTORISTA(A.CON_CONHECIMENTO_PLACA), 1, 50),
               A.GLB_ROTA_CODIGO,
               E.GLB_LOCALIDADE_DESCRICAO,
               E.GLB_ESTADO_CODIGO,
               F.GLB_LOCALIDADE_DESCRICAO,
               F.GLB_ESTADO_CODIGO,
               D.GLB_ROTA_DESCRICAO,
               H.CON_CALCVIAGEM_VALOR
          INTO V_CONHECIMENTO_DTEMBARQUE,
               V_CLIENTE_CGCCPFDESTINATARIO,
               V_CLIENTE_CGCCPFSACADO,
               V_CLIENTE_RAZAOSOCIAL,
               V_CLIENTE_RAZAOSOCIALREMET,
               V_NFTRANSPORTADA_NUMERO,
               V_CONHECIMENTO_PLACA,
               V_ANTENA,
               V_MOTORISTA,
               vROTA_CODIGO,
               V_CIDADEDES,
               V_ESTADODES,
               V_CIDADEORI,
               V_ESTADOORI,
               V_ROTA_DESCRICAO,
               V_NFTRANSPORTADA_VALOR
          FROM tdvadm.T_CON_CONHECIMENTO     A,
               tdvadm.T_CON_NFTRANSPORTA     B,
               tdvadm.T_GLB_CLIENTE          C,
               tdvadm.T_GLB_CLIENTE          G,
               tdvadm.T_GLB_ROTA             D,
               tdvadm.T_GLB_LOCALIDADE       E,
               tdvadm.T_GLB_LOCALIDADE       F,
               tdvadm.T_CON_CALCCONHECIMENTO H
         WHERE a.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND a.CON_CONHECIMENTO_SERIE = 'XXX'
           AND A.CON_CONHECIMENTO_CODIGO = B.CON_CONHECIMENTO_CODIGO(+)
           AND A.CON_CONHECIMENTO_SERIE = B.CON_CONHECIMENTO_SERIE(+)
           AND A.GLB_ROTA_CODIGO = B.GLB_ROTA_CODIGO(+)
           AND A.CON_CONHECIMENTO_CODIGO = H.CON_CONHECIMENTO_CODIGO(+)
           AND A.CON_CONHECIMENTO_SERIE = H.CON_CONHECIMENTO_SERIE(+)
           AND A.GLB_ROTA_CODIGO = H.GLB_ROTA_CODIGO(+)
           AND A.GLB_CLIENTE_CGCCPFDESTINATARIO = C.GLB_CLIENTE_CGCCPFCODIGO
           AND A.GLB_CLIENTE_CGCCPFREMETENTE = G.GLB_CLIENTE_CGCCPFCODIGO
           AND A.GLB_ROTA_CODIGO = D.GLB_ROTA_CODIGO
           AND E.GLB_LOCALIDADE_CODIGO = A.CON_CONHECIMENTO_LOCALENTREGA
           AND F.GLB_LOCALIDADE_CODIGO = A.CON_CONHECIMENTO_LOCALCOLETA
           AND H.SLF_RECCUST_CODIGO = 'D_VLRSEGUR'
           AND ROWNUM = 1;
      exception
        when no_data_found then
          V_CLIENTE_CGCCPFSACADO := null;
      end;

      UPDATE tdvadm.T_CON_CONHECAUTORIZADOR
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   

      -- 31/05/2021
      -- Sirlano / Alison
      -- Gravando a OBS apos mudar para serie A1, no LOGGERACAO DO CARREGAMENTO 
      Begin
         select c.con_conhecimento_obs
           into vObs
         from tdvadm.t_con_conhecimento c
         where c.con_conhecimento_codigo = V_NUMCONHECAUX
           and c.con_conhecimento_serie = V_SERIECONHECAUX
           and c.glb_rota_codigo = V_ROTAVIAGEM_CLONE;
      exception
        When OTHERS then
           vObs := '';
        End;

       Begin      
         select x.arm_carregamento_codigo,
                max(to_number(x.con_loggeracao_codigo))
           into vCarregamento,
                vLogSeq
         from tdvadm.T_CON_LOGGERACAO x
         WHERE x.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND x.CON_CONHECIMENTO_SERIE = 'XXX';
      Exception
        When OTHERS Then
          vCarregamento := '';
          vLogSeq := 0;
      End;
      
      insert into tdvadm.T_CON_LOGGERACAO x
      values (lpad(vLogSeq+1,5,'0'),
              vCarregamento,
              null,
              null,
              V_NUMCONHECAUX,
              V_SERIECONHECAUX,
              V_ROTAVIAGEM_CLONE,
              sysdate,
              'OBS CUST 3 -> OBS APOS MUDAR A SERIE PARA A1, ANTES DA NDD',
              vObs,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null);

      -- FIM DA ALTERACAO              
           
      UPDATE tdvadm.T_CON_LOGGERACAO
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   

      UPDATE tdvsva.t_Cs278_Simulador
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX,
             cs278_simulador_calculado = nvl(cs278_simulador_calculado,'N')
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   

      update tdvadm.t_con_veicconhec 
         SET CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX,
             CON_CONHECIMENTO_SERIE  = V_SERIECONHECAUX
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
         AND CON_CONHECIMENTO_SERIE = 'XXX';   
      
      
      DELETE tdvadm.T_CON_NFTRANSPORTA
       WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
       AND CON_CONHECIMENTO_SERIE = 'XXX' ; 
       
       

       commit;
       
      BEGIN
          
        vDateFormatDel := trim(to_char(sysdate,'YYYY/MM/DD HH24:MI:SS'));

        DELETE T_CON_CONHECIMENTO
         WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CON_CONHECIMENTO_SERIE  = 'XXX';
           
           commit;

/*        update tdvadm.T_CON_CONHECIMENTO x
           set x.arm_carregamento_codigo = null,
               x.arm_carregamento_codigopr = null
         WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CON_CONHECIMENTO_SERIE  = 'XXX';
*/

      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20003, V_NUMCONHEC_CLONE || ' -T_CON_CONHECIMENTO-  ' || V_NUMCONHECAUX ||' - '||SQLERRM);
      END;
       
      v_texto := ' CTCR - ' || V_NUMCONHECAUX || '-' || V_SERIECONHECAUX ||
                 ' ROTA - ' || vROTA_CODIGO || ' - ' || V_ROTA_DESCRICAO ||
                 CHR(13) || CHR(10);
      v_texto := v_texto || ' VIAGEM - ' || V_NFTRANSPORTADA_NUMERO || ' ' ||
                 CHR(13) || CHR(10);
      v_texto := v_texto || ' REMET  - ' || V_CLIENTE_RAZAOSOCIALREMET ||
                 CHR(13) || CHR(10);
      v_texto := v_texto || ' DESTINAT - ' ||
                 TRIM(V_CLIENTE_CGCCPFDESTINATARIO) || '-' ||
                 V_CLIENTE_RAZAOSOCIAL || CHR(13) || CHR(10);
      v_texto := v_texto || ' ORIGEM - ' || TRIM(V_CIDADEORI) || '-' ||
                 V_ESTADOORI || CHR(13) || CHR(10);
      v_texto := v_texto || ' DESTINO - ' || TRIM(V_CIDADEDES) || '-' ||
                 V_ESTADODES || CHR(13) || CHR(10);
      v_texto := v_texto || ' VEICULO - ' || V_CONHECIMENTO_PLACA ||
                 ' - MOT - ' || V_MOTORISTA || CHR(13) || CHR(10);
      v_texto := v_texto || ' TERMINAL - ' || V_ANTENA || CHR(13) || CHR(10);
      v_texto := v_texto || ' VLR MERC - R$: ' || trim(V_NFTRANSPORTADA_VALOR) ||
                 CHR(13) || CHR(10);
      -- insert into dropme (x) values (v_texto);
      -- commit;

      IF SUBSTR(trim(V_CLIENTE_CGCCPFSACADO), 1, 8) = '19900000' THEN
        insert into T_UTI_INFOMAIL
          (UTI_INFOMAIL_CODIGO,
           UTI_INFOMAIL_ENDMAILREMETENTE,
           UTI_INFOMAIL_NOMEREMETENTE,
           UTI_INFOMAIL_PERIODODT,
           UTI_INFOMAIL_PERIODODTSTART,
           UTI_INFOMAIL_ENDMAILDESTINATAR,
           UTI_INFOMAIL_ENDDESTCOPIAS,
           UTI_INFOMAIL_ASSUNTO,
           UTI_INFOMAIL_MEMO,
           UTI_INFOMAIL_ARQANEXARTP,
           UTI_INFOMAIL_ORIGEM)
        VALUES
          (TO_CHAR(SYSDATE, 'YYYYMMDDHHMISS'),
           'tdv.operacao@dellavolpe.com.br',
           'EMISSOR DE CONHECIMENTO',
           1,
           sysdate - 1,
           'grp.rastreamento@dellavolpe.com.br;jjunior@dellavolpe.com.br',
           'tdv.geradmin@dellavolpe.com.br' ||
           chr(59) || 'tdv.email@brfree.com.br',
           'VIAGEM KAISER - VLR MERC R$: ' ||
           trim(SUBSTR(TO_CHAR(V_NFTRANSPORTADA_VALOR, '999,999,990.00'), 1, 15)),
           v_texto,
           'P',
           'A');
      END IF;

      
      BEGIN
        UPDATE T_CON_CONHECIMENTO
           SET CON_CONHECIMENTO_DIGITADO = 'I'
         WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHECAUX
           AND CON_CONHECIMENTO_SERIE = V_SERIECONHECAUX
           AND GLB_ROTA_CODIGO = V_ROTAVIAGEM_CLONE
           AND NVL(CON_CONHECIMENTO_DIGITADO, 'X') <> 'I';
        exception
          WHEN others THEN
             
             v_erro :=  'Erro ao marcar CTe como disponivel para envio. CTe: '||V_NUMCONHECAUX ||
                        ' Rota: ' ||V_ROTAVIAGEM_CLONE||
                        ' Erro.: '||SQLERRM;
              
             --insert into dropme(x,a) values(substr(v_erro,1,2000),'pkg_slf_calculos.sp_move_dados_cnhc_viag');
             --commit;
             wservice.pkg_glb_email.SP_ENVIAEMAIL('CTe NFSe NAO MARCADO COMO IMPRESSO',
                                                  v_erro,
                                                  'aut-e@dellavolpe.com.br',
                                                  'sdrumond@dellavolpe.com.br;grp.hd@dellavolpe.com.br');
             
--             RAISE_APPLICATION_ERROR(-20001,v_erro); 
      END;
        
    exception 
      when others then
      begin
           rollback;
           
           v_erro :=           'Hora Delete t_con_conhecimento: '||vDateFormatDel                ||
                               ' Hora do Log: '||TRIM(to_char(sysdate,'YYYY/MM/DD HH24:MI:SS'))  ||
                               ' Erro no CTRC: '||V_NUMCONHECAUX ||' Rota: '||V_ROTAVIAGEM_CLONE ||
                               ' SqlErrm: '||SQLERRM; 
           insert into dropme
                  (x, 
                   a)
            values
                  (substr(v_erro||' - '||dbms_utility.format_call_stack, 1, 2000),
                  'pkg_slf_calculos.sp_move_dados_cnhc_viag');
           commit;
           
           RAISE_APPLICATION_ERROR(-20001,'Erro ao gerar Cte.  Recuperação: '||V_NUMCONHECAUX ||' rota: '||V_ROTAVIAGEM_CLONE||'  Erro.: '||SQLERRM||' - '||dbms_utility.format_error_backtrace);
           
      end;      
    END;      

    COMMIT;
  END SP_MOVE_DADOS_CNHC_VIAG;


        
  PROCEDURE SP_MONTA_FORMULA_CNHC(V_TIPOCALCULOPAI IN OUT tdvadm.t_slf_tpcalculo.slf_tpcalculo_codigo%TYPE,
                                  V_NUMERO IN tdvadm.t_con_conhecimento.con_conhecimento_codigo%TYPE,
                                  V_SAQUE_SERIE IN tdvadm.t_con_conhecimento.con_conhecimento_serie%TYPE,
                                  V_ROTA_CODIGO IN tdvadm.t_con_conhecimento.glb_rota_codigo%TYPE,
                                  V_INCLUIPED IN CHAR DEFAULT 'S') IS

    vTIPOCALCULOPAI  tdvadm.t_slf_tpcalculo.slf_tpcalculo_codigo%TYPE;
    vNUMERO          tdvadm.t_con_conhecimento.con_conhecimento_codigo%TYPE;
    vSAQUE_SERIE     tdvadm.t_con_conhecimento.con_conhecimento_serie%TYPE;
    vROTA_CODIGO     tdvadm.t_con_conhecimento.glb_rota_codigo%TYPE;
    vINCLUIPED       char(1);
    vInvertido       CHAR(1);

    V_SEQ            NUMBER;
    V_TPCALCULO_CODIGO        CHAR(3);
    V_RECCUST_CODIGO          CHAR(10);
    V_FORMULA_FRONTEND        CHAR(10);
    V_FORMULA_FORMULA_TX      VARCHAR2(1000);
    V_FORMULA_FORMULA_VLR     VARCHAR2(1000);
    V_FORMULA_FORMULA_PERC    VARCHAR2(1000);
    V_FORMULA_DESINENCIA_TX   CHAR(3);
    V_FORMULA_DESINENCIA_VLR  CHAR(3);
    V_FORMULA_DESINENCIA_PERC CHAR(3);
    V_VERBA_PRINCIPAL         CHAR(10);
    vPrecisaoVp   tdvadm.t_slf_calculo.slf_calculo_precisao%Type;
    V_DESINENCIA              T_CON_CALCCONHECIMENTO.CON_CALCVIAGEM_DESINENCIA%TYPE;
    V_MOEDA                   T_CON_CALCCONHECIMENTO.GLB_MOEDA_CODIGO%TYPE;
    V_SOLFRETETABELA          T_CON_CONHECIMENTO.SLF_SOLFRETE_CODIGO%TYPE;
    V_SFTABSAQUE              T_CON_CONHECIMENTO.SLF_SOLFRETE_CODIGO%TYPE;
    V_SOLFRETE_OU_TABELA      CHAR(1);
    V_LOCALIDADECOLETA        T_CON_CONHECIMENTO.CON_CONHECIMENTO_LOCALCOLETA%TYPE;
    V_LOCALIDADEENTREGA       T_CON_CONHECIMENTO.CON_CONHECIMENTO_LOCALENTREGA%TYPE;
    V_MERCADORIA              T_CON_CONHECIMENTO.GLB_MERCADORIA_CODIGO%TYPE;
    V_PESOCOB                 T_CON_CALCCONHECIMENTO.CON_CALCVIAGEM_VALOR%TYPE;
    V_MUDABASEICMS            CHAR(1);
    V_FORMULA_CALC            VARCHAR2(500);
    V_FORMULA_DESINENCIA      CHAR(3);
    V_TAMANHO_FORMULA         NUMBER;
    V_CONT                    NUMBER;
    V_VALOR_CAMPO             NUMBER;
    V_MOEDA_CAMPO             CHAR(4);
    V_VALOR_ATUAL             NUMBER;
    V_VERBARESULTADO          CHAR(10);
    V_PRECISAO                NUMBER;
    V_PONTEIRO                VARCHAR2(500);
    V_CAMPO                   VARCHAR2(500);
    V_MOEDANACIONAL           CHAR(4);
    V_FORMULA_CALCTRATADA     VARCHAR2(500);
    CUR                       INTEGER;
    TOTAL                     INTEGER;
    V_FORMULA_DESINENCIARTR   T_CON_CALCCONHECIMENTO.CON_CALCVIAGEM_DESINENCIA%TYPE;
    V_FORMULA_MOEDA           CHAR(4);
    V_TIPOCALCULOSEQ          CHAR(3);
    V_VALOR_FORMULA           VARCHAR2(30);
    V_ESTADO_ORIGEM           CHAR(2);
    V_ESTADO_DESTINO          CHAR(2);
    V_ESTADO_SACADO           CHAR(2);
    V_CALCESTADO_ISENCAO      CHAR(1);
    V_ESTADO_ISENTOLEI        VARCHAR2(200);
    V_SUBST_LEI               VARCHAR2(200);
    V_DATAEMBARQUE            DATE;
    V_TRIBUTADEST             CHAR(1);
    V_TPPESSOADESTINATARIO    T_GLB_CLIENTE.GLB_CLIENTE_TPPESSOA%TYPE;
    V_CLIENTE_IE              T_GLB_CLIENTE.GLB_CLIENTE_IE%TYPE;
    V_IE                      T_GLB_CLIENTE.GLB_CLIENTE_IE%TYPE;
    v_Nacional                t_glb_cliente.glb_cliente_nacional%TYPE;
    ERRO_FORMULA EXCEPTION;
    V_PEDAGIO          NUMBER;
    V_VALORITTPV       NUMBER;
    V_VALOR_ICMS       NUMBER;
    V_NOVO_VALOROUTROS NUMBER;
    V_INCPEDAGIO       CHAR(1); -- GILES
    V_TRESENVOLVIDOS   CHAR(1);
    V_CGCSACADO        CHAR(20);
    V_CGCREMETENTE     CHAR(20);
    V_CGCDESTINATARIO  CHAR(20);
    V_ALIQUOTAINTERNA  CHAR(1);
    vRamoAtividade     tdvadm.t_glb_ramoatividade.glb_ramoatividade_codigo%type;
    V_LEI              CHAR(200);
    V_ALIQ             NUMBER;
    V_ALIQINTDEST      number;
    V_ALDIFFCP         number;
    v_vseq             number;
    v_contaverbas      NUMBER;
    vObsCli            t_con_conhecimento.con_conhecimento_obscliente%type;
    vNaoContribuinte        char(1);
    vTpCalcfrete       tdvadm.t_con_calcconhecimento%rowtype;
    vStatus            char(1);
    vMessage           varchar2(1000);
    vGrupoSac          tdvadm.t_glb_cliente.glb_grupoeconomico_codigo%type;
    vContrato          tdvadm.t_slf_contrato.slf_contrato_codigo%type; 

    CURSOR SEQCALCULO IS
      SELECT SLF_TPCALCULO_CODIGOSEQ
        FROM T_SLF_SEQCALCULO
       WHERE SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI
         AND SLF_SEQCALCULO_CONECIMENTO = 'S'
       ORDER BY SLF_SEQCALCLULO_SEQUENCIA;
    /*        CURSOR SEQCALCULO IS  SELECT SLF_TPCALCULO_CODIGOSEQ
                              FROM   T_SLF_SEQCALCULO
                              WHERE  SLF_TPCALCULO_CODIGO  = vTIPOCALCULOPAI
                              AND    SLF_SEQCALCULO_CONECIMENTO = 'S'
                              AND    SLF_TPCALCULO_CODIGOSEQ      IN (SELECT SLF_TPCALCULO_CODIGO
                                                                    FROM   T_SLF_CALCULO
                                                                     WHERE  SLF_CALCULO_TPCAMPO = 'R'
                                                                     AND    SLF_RECCUST_CODIGO     IN (SELECT SLF_RECCUST_CODIGO
                                                                                                       FROM   T_CON_CALCCONHECIMENTO
                                                                                                       WHERE  CON_CONHECIMENTO_CODIGO = vNUMERO
                                                                                                       AND    CON_CONHECIMENTO_SERIE  = vSAQUE_SERIE
                                                                                                       AND    GLB_ROTA_CODIGO         = vROTA_CODIGO
                                                                                                       AND    (CON_CONHECIMENTO_ALTALTMAN IS NULL
                                                                                                       OR      CON_CONHECIMENTO_ALTALTMAN = ''
                                                                                                       OR      CON_CONHECIMENTO_ALTALTMAN = ' ')))
                              ORDER BY SLF_SEQCALCLULO_SEQUENCIA;
    */
  BEGIN
     
   -- DBMS_OUTPUT.put_line(vTIPOCALCULOPAI);
        
    WHO_CALLED_ME2;
    
    if trim(V_ROTA_CODIGO) = 'XXX' then    
        vTIPOCALCULOPAI := trim(V_NUMERO);
        vNUMERO         := trim(V_SAQUE_SERIE);
        vSAQUE_SERIE    := trim(V_ROTA_CODIGO);
        vROTA_CODIGO    := trim(V_TIPOCALCULOPAI);
        vINCLUIPED      := 'S';
        vInvertido      := 'S';
--        raise_application_error(-20001,'Calculo ' || vTIPOCALCULOPAI  || 'CTe-' || vNUMERO || 'Serie-' || vSAQUE_SERIE || 'Rota-' || vROTA_CODIGO);
    Else
        vTIPOCALCULOPAI := trim(V_TIPOCALCULOPAI);
        vNUMERO         := trim(V_NUMERO);
        vSAQUE_SERIE    := trim(V_SAQUE_SERIE);
        vROTA_CODIGO    := trim(V_ROTA_CODIGO);
        vINCLUIPED      := 'S';
        vInvertido      := 'N';
    End If;       
    
    v_vseq            := 0;
    V_MUDABASEICMS    := 'N';
    V_INCPEDAGIO      := 'S';
    V_TRESENVOLVIDOS  := 'N';
    V_ALIQUOTAINTERNA := 'N';
    v_contaverbas     := 0;
    
    if vNUMERO = '142672' Then
       insert into t_Glb_Sql values ('PASSEI',sysdate,'CALCULO','CALCULO');
    End IF;  
    
    Begin
       vContrato := tdvadm.pkg_slf_utilitarios.fn_retorna_contratoCod(V_NUMERO,V_SAQUE_SERIE,V_ROTA_CODIGO);
    Exception
      When OTHERS Then
          vContrato := null;
    End; 
    
    /*    BEGIN
           SELECT A.SLF_SOLFRETE_CODIGO,B.CON_CALCVIAGEM_VALOR
           INTO   V_SOLFRETE,
                  V_PESOCOB
           FROM T_CON_CONHECIMENTO A,
                T_CON_CALCCONHECIMENTO B
           WHERE A.CON_CONHECIMENTO_CODIGO = vNUMERO
             AND A.CON_CONHECIMENTO_SERIE         = vSAQUE_SERIE 
             AND A.GLB_ROTA_CODIGO =    vROTA_CODIGO
            AND A.SLF_SOLFRETE_CODIGO IN ('00000000')
    -- ('00012707','00044445','00044446','00044354','00044632','00018077','00044598','00040911','00044473','00043380','00044815','00044826') 
             AND A.CON_CONHECIMENTO_CODIGO = B.CON_CONHECIMENTO_CODIGO
             AND A.CON_CONHECIMENTO_SERIE =  B.CON_CONHECIMENTO_SERIE
             AND A.GLB_ROTA_CODIGO = B.GLB_ROTA_CODIGO
             AND B.SLF_RECCUST_CODIGO = rpad('I_PSCOBRAD',10)
             AND A.CON_CONHECIMENTO_SERIE =  'XXX';
           V_MUDABASEICMS := 'S';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_SOLFRETE := NULL;
            V_PESOCOB  := NULL;
            V_MUDABASEICMS := 'N';
        END;
    */
    BEGIN
      SELECT A.CON_CONHECIMENTO_DTEMBARQUE,
             A.GLB_CLIENTE_CGCCPFSACADO,
             A.GLB_CLIENTE_CGCCPFREMETENTE,
             A.GLB_CLIENTE_CGCCPFDESTINATARIO,
             nvl(cl.glb_cliente_naocont,'N'),
             NVL(A.SLF_SOLFRETE_CODIGO, A.SLF_TABELA_CODIGO),
             NVL(A.SLF_SOLFRETE_SAQUE, A.SLF_TABELA_SAQUE),
             DECODE(NVL(A.SLF_SOLFRETE_CODIGO, 'NULO'), 'NULO', 'T', 'S'),
             A.CON_CONHECIMENTO_LOCALCOLETA,
             A.CON_CONHECIMENTO_LOCALENTREGA,
             A.GLB_MERCADORIA_CODIGO,
             LO.GLB_ESTADO_CODIGO UFO,
             LD.GLB_ESTADO_CODIGO UFD,
             cl.glb_grupoeconomico_codigo
        INTO V_DATAEMBARQUE,
             V_CGCSACADO,
             V_CGCREMETENTE,
             V_CGCDESTINATARIO,
             vNaoContribuinte,
             V_SOLFRETETABELA,
             V_SFTABSAQUE,
             V_SOLFRETE_OU_TABELA,
             V_LOCALIDADECOLETA,
             V_LOCALIDADEENTREGA,
             V_MERCADORIA,
             V_ESTADO_ORIGEM,
             V_ESTADO_DESTINO,
             vGrupoSac
        FROM tdvadm.T_CON_CONHECIMENTO A,
             tdvadm.T_GLB_LOCALIDADE LO,
             tdvadm.T_GLB_LOCALIDADE LD,
             tdvadm.t_glb_cliente cl
       WHERE A.CON_CONHECIMENTO_CODIGO = vNUMERO
         AND A.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         AND A.GLB_ROTA_CODIGO = vROTA_CODIGO
         and A.GLB_CLIENTE_CGCCPFSACADO = cl.glb_cliente_cgccpfcodigo
--         and A.GLB_CLIENTE_CGCCPFDESTINATARIO = cl.glb_cliente_cgccpfcodigo
         AND A.CON_CONHECIMENTO_LOCALCOLETA = LO.GLB_LOCALIDADE_CODIGO (+)
         AND A.CON_CONHECIMENTO_LOCALENTREGA = LD.GLB_LOCALIDADE_CODIGO (+);

      IF fn_busca_codigoibge(V_LOCALIDADECOLETA,'IBC') <>  fn_busca_codigoibge(V_LOCALIDADEENTREGA,'IBC') Then
          BEGIN
            SELECT A.SLF_ICMS_ALIQUOTA
              INTO V_ALIQ   
            FROM T_SLF_ICMS A
            WHERE A.GLB_ESTADO_CODIGOORIGEM = V_ESTADO_ORIGEM
              AND A.GLB_ESTADO_CODIGODESTINO = V_ESTADO_DESTINO 
              AND A.SLF_ICMS_DATAEFETIVA = (SELECT MAX(B.SLF_ICMS_DATAEFETIVA)
                                            FROM T_SLF_ICMS B
                                            WHERE B.GLB_ESTADO_CODIGOORIGEM = A.GLB_ESTADO_CODIGOORIGEM
                                              AND B.GLB_ESTADO_CODIGODESTINO = A.GLB_ESTADO_CODIGODESTINO
                                              AND B.SLF_ICMS_DATAEFETIVA <= SYSDATE);

            SELECT A.SLF_ICMS_ALIQUOTA
              INTO V_ALIQINTDEST   
            FROM T_SLF_ICMS A
            WHERE A.GLB_ESTADO_CODIGOORIGEM = V_ESTADO_DESTINO
              AND A.GLB_ESTADO_CODIGODESTINO = V_ESTADO_DESTINO 
              AND A.SLF_ICMS_DATAEFETIVA = (SELECT MAX(B.SLF_ICMS_DATAEFETIVA)
                                            FROM T_SLF_ICMS B
                                            WHERE B.GLB_ESTADO_CODIGOORIGEM = A.GLB_ESTADO_CODIGOORIGEM
                                              AND B.GLB_ESTADO_CODIGODESTINO = A.GLB_ESTADO_CODIGODESTINO
                                              AND B.SLF_ICMS_DATAEFETIVA <= SYSDATE);


    
    -- Verifica se preenche as variaveis do DIFAL e FCF
    
    V_ALDIFFCP := 0;
    -- Vejo se o SACADO é nao contribuinte 
    if vNaoContribuinte = 'S' Then
       if V_ESTADO_ORIGEM <> V_ESTADO_DESTINO Then
          V_ALDIFFCP := ABS(V_ALIQINTDEST - V_ALIQ); 
       Else
          V_ALDIFFCP := 0;
       END If;
    Else
       V_ALDIFFCP := 0;
    End If;
    
    If NOT ( ( vGrupoSac = '0642' ) or (instr(tdvadm.pkg_slf_calculos.vListaCNPJDIFAL,trim(V_CGCSACADO)) > 0)) Then
       V_ALDIFFCP := 0;
    End If;

    
--       If V_ESTADO_DESTINO = 'RJ' Then
--          V_ALDIFFCP := V_ALDIFFCP + 2;
--       End if;
--       If V_ESTADO_DESTINO = 'RJ' Then
--          V_ALDIFFCP := V_ALDIFFCP + 1;
--       End if;
--    End If;    


    UPDATE T_CON_CALCCONHECIMENTO CA
      SET CA.CON_CALCVIAGEM_VALOR = V_ALDIFFCP
    WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
      AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
      and nvl(ca.con_conhecimento_altaltman,'N') = 'N'
      AND CA.SLF_RECCUST_CODIGO = 'S_ALDIFFCP';
    If SQL%rowcount = 0  Then
       select *
         into vTpCalcfrete
       from tdvadm.T_CON_CALCCONHECIMENTO CA
       WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
         AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         and nvl(ca.con_conhecimento_altaltman,'N') = 'N'
         AND CA.SLF_RECCUST_CODIGO = 'S_ALICMS';

      vTpCalcfrete.Slf_Reccust_Codigo := 'S_ALDIFFCP';
      vTpCalcfrete.Con_Calcviagem_Valor :=  V_ALDIFFCP;

      insert into tdvadm.T_CON_CALCCONHECIMENTO CA values vTpCalcfrete;

    End If;
    -- 18/06/2021
    -- Vendo se e SUBST ou ISENCAO
    UPDATE T_CON_CALCCONHECIMENTO CA
      SET CA.CON_CALCVIAGEM_VALOR = V_ALIQ
    WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
      AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
      and nvl(ca.con_conhecimento_altaltman,'N') = 'N'
      AND CA.SLF_RECCUST_CODIGO = 'S_ALICMS';
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_ALIQ := 0;
           V_ALDIFFCP := 0;
        WHEN OTHERS THEN 
           V_ALIQ := 0;
           V_ALDIFFCP := 0;
   End;  
 End If;              

      SP_VERIFICA_ISENCAO_SUBST(V_SOLFRETETABELA,
                                V_SFTABSAQUE,
                                V_LOCALIDADECOLETA,
                                V_LOCALIDADEENTREGA,
                                vROTA_CODIGO,
                                V_MERCADORIA,
                                V_CGCREMETENTE,
                                V_CGCSACADO,
                                V_SOLFRETE_OU_TABELA,
                                V_DATAEMBARQUE,
                                V_LEI,
                                vNUMERO,
                                vSAQUE_SERIE,
                                vROTA_CODIGO);
     
                                
      IF vNUMERO = '9388990' THEN
          raise_application_error(-20001,vNUMERO);
      END IF;  
      
      IF V_SOLFRETE_OU_TABELA = 'T' THEN
        V_ALIQUOTAINTERNA := 'N';
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_DATAEMBARQUE := TRUNC(SYSDATE);
      /*
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20001,'ERRO: ' || SQLERRM || 'PARAMETROS: ' ||
                                V_SOLFRETETABELA || '-' ||  V_SFTABSAQUE || '-' ||
                                V_LOCALIDADECOLETA || '-' ||
                                V_LOCALIDADEENTREGA || '-' ||
                                vROTA_CODIGO || '-' ||
                                V_MERCADORIA || '-' ||
                                V_CGCREMETENTE || '-' ||
                                V_CGCSACADO || '-' ||
                                V_SOLFRETE_OU_TABELA || '-' ||
                                V_DATAEMBARQUE || '-' ||
                                V_LEI || '-' ||
                                vNUMERO || '-' ||
                                vSAQUE_SERIE || '-' ||
                                vROTA_CODIGO);
       V_DATAEMBARQUE := TRUNC(SYSDATE);
      */
    END;

    

    
    IF (V_LEI IS NOT NULL) AND
       (V_SOLFRETE_OU_TABELA = 'I') THEN
      V_ESTADO_ISENTOLEI := V_LEI;
    ELSE
      V_ESTADO_ISENTOLEI := 'N';
    END IF;

    -- JERONIMO 16/11/2005
    -- USO V_SUBST_LEI PARA ZERAR A ALIQUOTA NO CASO DE SUBSTITUIC?O TRIBUTARIA
    IF (V_LEI IS NOT NULL) AND
       (V_SOLFRETE_OU_TABELA = 'S') THEN
      V_SUBST_LEI := V_LEI;
    ELSE
      V_SUBST_LEI := 'N';
    END IF;
    -- JERONIMO 16/11/2005

    IF ((vROTA_CODIGO = '031') AND (V_DATAEMBARQUE < '01/09/2004')) OR
       (NVL(V_ALIQUOTAINTERNA, 'N') = 'S') THEN
      V_ESTADO_ISENTOLEI := 'N';
    END IF;
    IF (V_MUDABASEICMS = 'S') AND
       (V_PESOCOB > 5) THEN
      UPDATE T_CON_CALCCONHECIMENTO
         SET CON_CALCVIAGEM_VALOR = 0,
             CON_CALCVIAGEM_DESINENCIA = 'VL'
       WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
         AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         AND GLB_ROTA_CODIGO = vROTA_CODIGO
         AND SLF_RECCUST_CODIGO = RPAD('D_OT2', 10);
      UPDATE T_CON_CALCCONHECIMENTO
         SET CON_CALCVIAGEM_VALOR = 0,
             CON_CALCVIAGEM_DESINENCIA = 'VL'
       WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
         AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         AND GLB_ROTA_CODIGO = vROTA_CODIGO
         AND SLF_RECCUST_CODIGO = RPAD('R_OTICMS2', 10);
    END IF;
    --MOEDA NACIONAL
    SELECT GLB_MOEDA_CODIGO
      INTO V_MOEDANACIONAL
      FROM T_GLB_MOEDA
     WHERE GLB_MOEDA_PAIS = 'S';



      BEGIN
        SELECT GLB_ESTADO_CODIGO
          INTO V_ESTADO_SACADO
          FROM T_GLB_CLIEND
         WHERE GLB_CLIENTE_CGCCPFCODIGO = V_CGCSACADO
           AND GLB_TPCLIEND_CODIGO = 'E';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT GLB_ESTADO_CODIGO
              INTO V_ESTADO_SACADO
              FROM T_GLB_CLIEND
             WHERE GLB_CLIENTE_CGCCPFCODIGO = V_CGCSACADO
               AND GLB_TPCLIEND_CODIGO = 'C';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_ESTADO_SACADO := NULL;
          END;
      END;
      
      
        
      BEGIN
        SELECT NVL(C.GLB_CLIENTE_IE, 'ISENTO'),
               c.glb_cliente_nacional,
               c.glb_ramoatividade_codigo
          INTO V_IE,
               v_Nacional,
               vRamoAtividade
          FROM T_GLB_CLIENTE C
         WHERE C.GLB_CLIENTE_CGCCPFCODIGO = V_CGCDESTINATARIO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_IE := 'ISENTO';
      END; 
      IF V_IE = 'ISENTO' THEN
        IF v_Nacional = 'N' THEN
           -- Conforme email passado pelo Dr Laerte nesta data
           If trunc(sysdate) >= '02/02/2015' Then
              V_ALIQUOTAINTERNA := 'N';
           Else           
              V_ALIQUOTAINTERNA := 'S';
           End If;
        ELSE
           V_ALIQUOTAINTERNA := 'N';
        END IF;  
      END IF;
        -- sirlano incluido em 17/04/2014
      if vRamoAtividade = '07' Then -- Contrucao civil
           -- Conforme email passado pelo Dr Laerte nesta data
           If trunc(sysdate) >= '02/02/2015' Then
              V_ALIQUOTAINTERNA := 'N';
           Else           
              V_ALIQUOTAINTERNA := 'S';
           End If;
      End If;
          


    -- RECUPERA VERBA PRINCIPAL
    --   VERIFICA SE O CLIENTE DESTINATARIO TEM INSCRICAO ESTADUAL
    OPEN SEQCALCULO;
    LOOP
      FETCH SEQCALCULO
        INTO V_TIPOCALCULOSEQ;
      EXIT WHEN SEQCALCULO%NOTFOUND;
      BEGIN
        SELECT calc.SLF_RECCUST_CODIGO,
               calc.slf_calculo_precisao
        
          INTO 
            V_VERBA_PRINCIPAL,
            vPrecisaoVp
          FROM T_SLF_CALCULO calc
         WHERE SLF_TPCALCULO_CODIGO = V_TIPOCALCULOSEQ
           AND SLF_CALCULO_VERBAPRINCIPAL = 'S';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_VERBA_PRINCIPAL := NULL;
      END;
      v_contaverbas := v_contaverbas + 1;
    
      If V_VERBA_PRINCIPAL = V_VERBA_BREAKPOINT Then
         V_VERBA_BREAKPOINT := V_VERBA_BREAKPOINT;
      End If;

      BEGIN
        SELECT SLF_CALCESTADO_ISENCAO
          INTO V_CALCESTADO_ISENCAO
          FROM T_SLF_CALCESTADO
         WHERE SLF_TPCALCULO_CODIGO = V_TIPOCALCULOSEQ
           AND GLB_ESTADO_CODIGO = V_ESTADO_ORIGEM;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_CALCESTADO_ISENCAO := 'N';
      END;

      IF V_TIPOCALCULOSEQ IN ('024','040','315') THEN
         DBMS_OUTPUT.put_line('KLAYTON:'||V_CALCESTADO_ISENCAO);
      END IF;  
       

      --******

      IF V_VERBA_PRINCIPAL = 'S_KMPER' THEN
         BEGIN
           SELECT P.SLF_PERCURSO_KM
             INTO V_VALOR_CAMPO
           FROM T_SLF_PERCURSO P
           WHERE P.GLB_LOCALIDADE_CODIGOORIGEM = V_LOCALIDADECOLETA
             AND P.GLB_LOCALIDADE_CODIGODESTINO = V_LOCALIDADEENTREGA;  
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             V_VALOR_CAMPO := 0;
           WHEN OTHERS THEN
             V_VALOR_CAMPO := 0;
         END;     


        UPDATE T_CON_CALCCONHECIMENTO
           SET CON_CALCVIAGEM_VALOR = V_VALOR_CAMPO
         WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND GLB_ROTA_CODIGO = vROTA_CODIGO
           AND NVL(CON_CALCVIAGEM_VALOR,0) = 0
           AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD(V_VERBA_PRINCIPAL, 10)
           AND (CON_CONHECIMENTO_ALTALTMAN IS NULL OR
               CON_CONHECIMENTO_ALTALTMAN = '' OR
               CON_CONHECIMENTO_ALTALTMAN = ' ');

      END IF;



      IF V_VERBA_PRINCIPAL = 'S_BSMIICMS' THEN
        BEGIN
         SELECT CA.CON_CALCVIAGEM_VALOR
           INTO V_VALOR_CAMPO
         FROM T_CON_CALCCONHECIMENTO CA
         WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND CA.SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI
           AND CA.GLB_ROTA_CODIGO       = vROTA_CODIGO
           AND RPAD(CA.SLF_RECCUST_CODIGO, 10) = RPAD('S_KMPER', 10);
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             V_VALOR_CAMPO := 0;
         END;
             
        BEGIN
         SELECT CA.CON_CALCVIAGEM_VALOR
           INTO V_VALOR_ATUAL
         FROM T_CON_CALCCONHECIMENTO CA
         WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND GLB_ROTA_CODIGO = vROTA_CODIGO
           AND CA.SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI
           AND RPAD(CA.SLF_RECCUST_CODIGO, 10) = RPAD('I_PSCOBRAD', 10);
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             V_VALOR_ATUAL := 0;
         END;

         BEGIN
         SELECT CA.CON_CALCVIAGEM_VALOR
           INTO V_ALIQ
         FROM T_CON_CALCCONHECIMENTO CA
         WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND GLB_ROTA_CODIGO = vROTA_CODIGO
           AND CA.SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI
           and nvl(ca.con_conhecimento_altaltman,'N') = 'N'
           AND RPAD(CA.SLF_RECCUST_CODIGO, 10) = RPAD('S_ALICMS', 10);
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             V_ALIQ := 0;
         END;

         
         -- PROCURA POR ORIGEM E DESTINO 
         BEGIN
           SELECT BM.SLF_BASEMINIMAICMS_VALOR
             INTO V_VALOR_CAMPO
           FROM T_SLF_BASEMINIMAICMS BM
           WHERE BM.GLB_ESTADO_CODIGOORI = V_ESTADO_ORIGEM
             AND BM.GLB_ESTADO_CODIGODES = V_ESTADO_DESTINO
             AND  V_VALOR_CAMPO BETWEEN BM.SLF_BASEMINIMAICMS_FAIXAKMI AND BM.SLF_BASEMINIMAICMS_FAIXAKMF
             AND BM.SLF_BASEMINIMAICMS_ATIVO = 'S'
             AND BM.SLF_BASEMINIMAICMS_VIGENCIA = (SELECT MAX(BM1.SLF_BASEMINIMAICMS_VIGENCIA)
                                                   FROM T_SLF_BASEMINIMAICMS BM1
                                                   WHERE BM1.GLB_ESTADO_CODIGOORI = BM.GLB_ESTADO_CODIGOORI
                                                     AND BM1.GLB_ESTADO_CODIGODES = BM.GLB_ESTADO_CODIGODES
                                                     AND BM1.SLF_BASEMINIMAICMS_FAIXAKMI = BM.SLF_BASEMINIMAICMS_FAIXAKMI
                                                     AND BM1.SLF_BASEMINIMAICMS_FAIXAKMF = BM.SLF_BASEMINIMAICMS_FAIXAKMF
                                                     AND BM1.SLF_BASEMINIMAICMS_ATIVO = 'S'
                                                     AND BM1.SLF_BASEMINIMAICMS_VIGENCIA <= NVL(V_DATAEMBARQUE,TRUNC(SYSDATE))); 
         EXCEPTION
           WHEN OTHERS THEN
           BEGIN
             SELECT BM.SLF_BASEMINIMAICMS_VALOR
               INTO V_VALOR_CAMPO
             FROM T_SLF_BASEMINIMAICMS BM
             WHERE BM.GLB_ESTADO_CODIGOORI = V_ESTADO_ORIGEM
               AND BM.GLB_ESTADO_CODIGODES = '*'
               AND  V_VALOR_CAMPO BETWEEN BM.SLF_BASEMINIMAICMS_FAIXAKMI AND BM.SLF_BASEMINIMAICMS_FAIXAKMF
               AND BM.SLF_BASEMINIMAICMS_ATIVO = 'S'
               AND BM.SLF_BASEMINIMAICMS_VIGENCIA = (SELECT MAX(BM1.SLF_BASEMINIMAICMS_VIGENCIA)
                                                     FROM T_SLF_BASEMINIMAICMS BM1
                                                     WHERE BM1.GLB_ESTADO_CODIGOORI = BM.GLB_ESTADO_CODIGOORI
                                                       AND BM1.GLB_ESTADO_CODIGODES = BM.GLB_ESTADO_CODIGODES
                                                       AND BM1.SLF_BASEMINIMAICMS_FAIXAKMI = BM.SLF_BASEMINIMAICMS_FAIXAKMI
                                                       AND BM1.SLF_BASEMINIMAICMS_FAIXAKMF = BM.SLF_BASEMINIMAICMS_FAIXAKMF
                                                       AND BM1.SLF_BASEMINIMAICMS_ATIVO = 'S'
                                                       AND BM1.SLF_BASEMINIMAICMS_VIGENCIA <= NVL(V_DATAEMBARQUE,TRUNC(SYSDATE))); 
           EXCEPTION
             WHEN OTHERS THEN
               V_VALOR_CAMPO := 0;
           END;    
           
         END;   
         
       if V_VERBA_PRINCIPAL = 'I_TTPV' Then
          vPrecisaoVp := vPrecisaoVp;
       End If;     

        UPDATE T_CON_CALCCONHECIMENTO
           SET CON_CALCVIAGEM_VALOR = round(((V_VALOR_CAMPO / ((100-V_ALIQ)/100)) * V_VALOR_ATUAL), vPrecisaoVp)
         WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND GLB_ROTA_CODIGO = vROTA_CODIGO
           AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD(V_VERBA_PRINCIPAL, 10)
           AND (CON_CONHECIMENTO_ALTALTMAN IS NULL OR
               CON_CONHECIMENTO_ALTALTMAN = '' OR
               CON_CONHECIMENTO_ALTALTMAN = ' ');
               
        if vNUMERO = '797807'  and ( V_VERBA_PRINCIPAL not in ('S_BSMIICMS') )/*and nvl(V_ALIQ,0) <> 0*/ then
           raise_application_error(-20001,V_VERBA_PRINCIPAL || '- Aliquota - ' || to_char(V_ALIQ));
        End If;

      END IF;
      
      
      -- JERONIMO - 17/11/2005
      -- DESCOMENTEI O TRATAMENTO DE TRES ENVOLVIDOS POIS, EM CONTATO COM O DR. LAERTE,
      -- O MESMO INFORMOU QUE A REGRA DE UTILIZAC?O DE ALIQUOTA INTERNA DO ESTADO
      -- PARA TRES ENVOLVIDOS VALE SOMENTE PARA ESTADO DE SP
      
      -- JERONIMO - 15/03/2006
      -- COMENTEI NOVAMENTE O TRATAMENTO EM VIRTUDE DE QUE EM NOVO CONTATO COM DR. LAERTE
      -- EM CONJUNTO COM SR. RONALDO, REALIZADO NESTA DATA, O MESMO INFORMOU APLICA-SE A
      -- ALIQUOTA INTERNA NO ESTADO DE SP PARA TRES ENVOLVIDOS SOMENTE SE O DESTINATARIO N?O
      -- POSSUIR INSCRIC?O ESTADUAL
      
      IF (V_CGCSACADO <> V_CGCREMETENTE) AND
         (V_CGCSACADO <> V_CGCDESTINATARIO) AND
         (V_CGCREMETENTE <> V_CGCDESTINATARIO) AND
         (NVL(V_ESTADO_ORIGEM, '##') = 'SP') AND
         (V_ALIQUOTAINTERNA = 'N') THEN
        -- ESSE IF FOI COLOCADO JUNTAMENTE COM OUTRO NA SP_VERIFICA_ISENCAO_SUBST
        -- PARA CONHECIMENTOS DA CBA QUE MESMO COM 3 ENVOLVIDOS DEVE SER SUBST. TRIB.
        IF ((V_SOLFRETETABELA = '00047467') AND (V_SFTABSAQUE >= '0003')) OR
           ((V_SOLFRETETABELA = '00047494') AND (V_SFTABSAQUE >= '0002')) THEN
          V_ALIQUOTAINTERNA := 'N';
        END IF;
        -- RAISE_APPLICATION_ERROR(-20001, 'tres envolvidos - ' || V_VALOR_FORMULA * 0.20);
      END IF;
      -- JERONIMO - 17/11/2005
      -- JERONIMO - 15/03/2006
      -- SIRLANO - 14/11/2007 RETIRADO A REGRA DO PARANA PARA ALIQUOTA INTERNA, SOLICITADO PELO RONALDO  
      IF ((NVL(V_ESTADO_ORIGEM, '##') = 'PR') AND
         (NVL(V_ESTADO_DESTINO, 'PR') <> 'PR') AND
         (NVL(V_ESTADO_SACADO, '##') = 'PR') AND
         (V_DATAEMBARQUE >= '18/02/2005') AND 
         (V_DATAEMBARQUE <= '13/11/2007')) -- REGRA EXCLUSIVA DO ESTADO DO PR
         OR
         ((NVL(V_ESTADO_ORIGEM, '##') = 'MG') AND
         (NVL(V_ESTADO_DESTINO, '##') = 'MG') AND
         (NVL(V_ESTADO_SACADO, 'MG') <> 'MG') AND 
         (V_MERCADORIA <> 'EX' ) AND
         (V_DATAEMBARQUE >= '22/02/2005')) THEN
        -- REGRA EXCLUSIVA DO ESTADO DE MG
        V_ALIQUOTAINTERNA := 'S';
      END IF;
      BEGIN
        SELECT SLF_TPCALCULO_CODIGO,
               SLF_RECCUST_CODIGO,
               SLF_FORMULA_FRONTEND,
               SLF_FORMULA_FORMULA_TX,
               SLF_FORMULA_FORMULA_VLR,
               SLF_FORMULA_FORMULA_PERC,
               SLF_FORMULA_DESINENCIA_TX,
               SLF_FORMULA_DESINENCIA_VLR,
               SLF_FORMULA_DESINENCIA_PERC
          INTO V_TPCALCULO_CODIGO,
               V_RECCUST_CODIGO,
               V_FORMULA_FRONTEND,
               V_FORMULA_FORMULA_TX,
               V_FORMULA_FORMULA_VLR,
               V_FORMULA_FORMULA_PERC,
               V_FORMULA_DESINENCIA_TX,
               V_FORMULA_DESINENCIA_VLR,
               V_FORMULA_DESINENCIA_PERC
          FROM T_SLF_FORMULA
         WHERE SLF_TPCALCULO_CODIGO = V_TIPOCALCULOSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_FORMULA_FRONTEND := '';
      END;
    
      --RETORNA DESINENCIA E MOEDA DA VERBA PRINCIPAL DA FORMULA CORRENTE
      BEGIN
        SELECT CON_CALCVIAGEM_DESINENCIA,
               GLB_MOEDA_CODIGO
          INTO V_DESINENCIA,
               V_MOEDA
          FROM T_CON_CALCCONHECIMENTO
         WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI
           AND GLB_ROTA_CODIGO = vROTA_CODIGO
              --AND     SEQUENCIACLONE           =
           AND SLF_RECCUST_CODIGO = RPAD(V_VERBA_PRINCIPAL, 10);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_DESINENCIA := NULL;
          V_MOEDA      := NULL;
      END;
      --CARLA 21/09/2001
      IF NVL(V_MOEDA, 0) = 0 THEN
        V_MOEDA := V_MOEDANACIONAL;
      END IF;
      V_FORMULA_DESINENCIARTR := V_DESINENCIA;
      V_FORMULA_MOEDA         := V_MOEDA;
      --SELECIONA A DESINENCIA E A FORMULA
      IF V_DESINENCIA = 'TX' THEN
        V_FORMULA_CALC := RTRIM(LTRIM(V_FORMULA_FORMULA_TX));
        IF V_FORMULA_DESINENCIA_TX IS NOT NULL THEN
          V_FORMULA_DESINENCIARTR := V_FORMULA_DESINENCIA_TX;
        ELSE
          V_FORMULA_DESINENCIARTR := V_DESINENCIA;
        END IF;
      ELSE
        IF V_DESINENCIA = '%' THEN
          V_FORMULA_CALC := RTRIM(LTRIM(V_FORMULA_FORMULA_PERC));
          IF V_FORMULA_DESINENCIA_PERC IS NOT NULL THEN
            V_FORMULA_DESINENCIARTR := V_FORMULA_DESINENCIA_PERC;
          ELSE
            V_FORMULA_DESINENCIARTR := V_DESINENCIA;
          END IF;
        ELSE
          V_FORMULA_CALC := RTRIM(LTRIM(V_FORMULA_FORMULA_VLR));
          IF V_FORMULA_DESINENCIA_VLR IS NOT NULL THEN
            V_FORMULA_DESINENCIARTR := V_FORMULA_DESINENCIA_VLR;
          ELSE
            V_FORMULA_DESINENCIARTR := V_DESINENCIA;
          END IF;
        END IF;
      END IF;
      --SELECIONA CAMPO
      --        insert into cle01(x) values ('calculo '|| V_FORMULA_DESINENCIARTR);
      
      V_CONT            := 1;
      V_TAMANHO_FORMULA := LENGTH(RTRIM(LTRIM(V_FORMULA_CALC)));
      V_PONTEIRO        := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC, V_CONT, 1)));
      WHILE V_CONT <= V_TAMANHO_FORMULA LOOP
        IF V_PONTEIRO = '"' Then
          If '409793' <> vnumero Then
          COMMIT;
          End If;
          V_CONT     := V_CONT + 1;
          V_PONTEIRO := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC, V_CONT, 1)));
          IF V_PONTEIRO NOT IN ('-', '*', '+', '/', ')', '(', ',') THEN
            WHILE V_PONTEIRO <> '"' LOOP
              V_PONTEIRO := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC, V_CONT, 1)));
              IF V_PONTEIRO <> '"' THEN
                V_CAMPO := V_CAMPO || V_PONTEIRO;
                V_CONT  := V_CONT + 1;
              END IF;
            END LOOP;
            
            If V_CAMPO = 'I_PSCOBRAD' Then
              V_CAMPO := V_CAMPO;  
            End If;
            
            --SELECIONA VALOR E MOEDA DA VERBA
            BEGIN
              SELECT CON_CALCVIAGEM_VALOR,
                     GLB_MOEDA_CODIGO
                INTO V_VALOR_CAMPO,
                     V_MOEDA_CAMPO
                FROM T_CON_CALCCONHECIMENTO
               WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
                 AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                 AND SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI
                 AND GLB_ROTA_CODIGO = vROTA_CODIGO
                 AND SLF_RECCUST_CODIGO = RPAD(V_CAMPO, 10);
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                V_VALOR_CAMPO := 0;
                V_MOEDA_CAMPO := NULL;
            END;
            IF (SUBSTR(V_ESTADO_ISENTOLEI, 1, 1) <> 'N') AND
               (RPAD(V_CAMPO, 10) = RPAD('S_ALICMS', 10)) THEN
              --SIRLANO 
              IF (V_DATAEMBARQUE < '27/08/2004') THEN
                V_ESTADO_ISENTOLEI := 'N';
              ELSE
                V_VALOR_ICMS  := 0;
                V_VALOR_CAMPO := 0;
              END IF;
            END IF;
            IF (((V_CALCESTADO_ISENCAO = 'N') AND
               (RPAD(V_CAMPO, 10) = RPAD('S_ALICMS', 10))) OR
               ((V_ALIQUOTAINTERNA = 'S') AND
               (RPAD(V_CAMPO, 10) = RPAD('S_ALICMS', 10)))) THEN
              --SIRLANO
              V_VALOR_ICMS := V_VALOR_CAMPO;
              BEGIN
                SELECT B.GLB_CLIENTE_TPPESSOA,
                       B.GLB_CLIENTE_IE
                  INTO V_TPPESSOADESTINATARIO,
                       V_CLIENTE_IE
                  FROM T_CON_CONHECIMENTO A,
                       T_GLB_CLIENTE B
                 WHERE A.GLB_CLIENTE_CGCCPFDESTINATARIO = B.GLB_CLIENTE_CGCCPFCODIGO
                   AND A.CON_CONHECIMENTO_CODIGO = vNUMERO
                   AND A.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                   AND A.GLB_ROTA_CODIGO = vROTA_CODIGO;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  V_TPPESSOADESTINATARIO := NULL;
                  V_CLIENTE_IE           := NULL;
              END;
              BEGIN
                SELECT GLB_CLIENTE_TRIBISENTO
                  INTO V_TRIBUTADEST
                  FROM T_CON_CONHECIMENTO A,
                       T_GLB_CLIENTE B
                 WHERE A.GLB_CLIENTE_CGCCPFSACADO = B.GLB_CLIENTE_CGCCPFCODIGO
                   AND A.CON_CONHECIMENTO_CODIGO = vNUMERO
                   AND A.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                   AND A.GLB_ROTA_CODIGO = vROTA_CODIGO;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  V_TRIBUTADEST := 'N';
              END;
              IF (V_TPPESSOADESTINATARIO = 'F' AND V_TRIBUTADEST = 'S') OR
                 (V_TRIBUTADEST = 'S' AND
                 ((V_CLIENTE_IE = 'ISENTO') OR
                 NVL(V_CLIENTE_IE, 'SIRLANO') = 'SIRLANO')) OR
                 (vTIPOCALCULOPAI = '314' AND V_TPCALCULO_CODIGO = '440') OR
                 (V_ALIQUOTAINTERNA = 'S') THEN  -- VERIFICAR O CASO DE MAUA SIRLANO or (V_SOLFRETE_OU_TABELA = 'T') THEN
                BEGIN
                
                  IF (V_DATAEMBARQUE >= '06/07/2005' AND vTIPOCALCULOPAI = '314' AND
                     V_TPCALCULO_CODIGO = '440') THEN
                    SELECT A.SLF_ICMS_ALIQUOTA
                      INTO V_VALOR_CAMPO
                      FROM T_SLF_ICMS A
                     WHERE A.GLB_ESTADO_CODIGOORIGEM = V_ESTADO_ORIGEM
                       AND A.GLB_ESTADO_CODIGODESTINO = V_ESTADO_DESTINO
                       AND A.SLF_ICMS_DATAEFETIVA =
                           (SELECT MAX(B.SLF_ICMS_DATAEFETIVA)
                              FROM T_SLF_ICMS B
                             WHERE B.GLB_ESTADO_CODIGOORIGEM = A.GLB_ESTADO_CODIGOORIGEM
                               AND B.GLB_ESTADO_CODIGODESTINO = A.GLB_ESTADO_CODIGODESTINO
                               AND B.SLF_ICMS_DATAEFETIVA <= SYSDATE);
                  ELSE
                    SELECT A.SLF_ICMS_ALIQUOTA
                      INTO V_VALOR_CAMPO
                      FROM T_SLF_ICMS A
                     WHERE A.GLB_ESTADO_CODIGOORIGEM = V_ESTADO_ORIGEM
                       AND A.GLB_ESTADO_CODIGODESTINO = V_ESTADO_ORIGEM
                       AND A.SLF_ICMS_DATAEFETIVA =
                           (SELECT MAX(B.SLF_ICMS_DATAEFETIVA)
                              FROM T_SLF_ICMS B
                             WHERE B.GLB_ESTADO_CODIGOORIGEM = A.GLB_ESTADO_CODIGOORIGEM
                               AND B.GLB_ESTADO_CODIGODESTINO = A.GLB_ESTADO_CODIGODESTINO
                               AND B.SLF_ICMS_DATAEFETIVA <= SYSDATE);
                   if vNUMERO = '797807'  then
                      raise_application_error(-20001,'********************' || chr(10) ||
                                                     'tppessoa ' || V_TPPESSOADESTINATARIO || chr(10) ||
                                                     'Tribut ' || V_TRIBUTADEST || chr(10) ||
                                                     'IECLI ' || V_CLIENTE_IE || chr(10) ||
                                                     'Alint ' || V_ALIQUOTAINTERNA || chr(10) ||
                                                     '***********************************' || chr(10));
                   End If;
                               
                  END IF;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    V_VALOR_CAMPO := 0;
                END;
               if V_VALOR_CAMPO <> 0 Then                
                  UPDATE T_CON_CALCCONHECIMENTO
                     SET CON_CALCVIAGEM_VALOR = V_VALOR_CAMPO
                   WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
                     AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                     AND GLB_ROTA_CODIGO = vROTA_CODIGO
                     AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD('S_ALICMS', 10)
                     AND (CON_CONHECIMENTO_ALTALTMAN IS NULL OR
                         CON_CONHECIMENTO_ALTALTMAN = '' OR
                         CON_CONHECIMENTO_ALTALTMAN = ' ');
                Else
                  UPDATE T_CON_CALCCONHECIMENTO
                     SET CON_CALCVIAGEM_VALOR = V_VALOR_CAMPO
                   WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
                     AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                     AND GLB_ROTA_CODIGO = vROTA_CODIGO
                     AND slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS')
--                      Sirlano Troquei em 24/11/2014 quando zerar a aliquota serar o icms     
--                      AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD('S_ALICMS', 10)
                     AND (CON_CONHECIMENTO_ALTALTMAN IS NULL OR
                         CON_CONHECIMENTO_ALTALTMAN = '' OR
                         CON_CONHECIMENTO_ALTALTMAN = ' ');
                End If;         
                IF ( V_VALOR_CAMPO = 0 ) and ( sql%rowcount > 0 ) Then       
                    UPDATE T_CON_CONHECIMENTO C
                      SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
                    WHERE C.CON_CONHECIMENTO_CODIGO = vNUMERO
                      AND C.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                      AND C.GLB_ROTA_CODIGO = vROTA_CODIGO;
                End If;
              END IF;
            END IF;
            IF (V_VERBA_PRINCIPAL = 'D_PD') AND -- SOMENTE IRA VERIFICAR V_CALCESTADO_ISENCAO SE ESTIVER CALCULANDO PEDAGIO  
               (V_CALCESTADO_ISENCAO = 'S') AND
               (RPAD(V_CAMPO, 10) = RPAD('S_ALICMS', 10)) THEN
              --SIRLANO 
              V_VALOR_ICMS  := V_VALOR_CAMPO;
              V_VALOR_CAMPO := 0;
            END IF;
            IF (V_MOEDA_CAMPO <> V_MOEDANACIONAL) AND
               (V_MOEDA_CAMPO IS NOT NULL) AND
               (V_MOEDA_CAMPO <> '') THEN
              --CONVERTE MOEDA
              BEGIN
                SELECT GLB_MOEDAVL_VALOR
                  INTO V_VALOR_ATUAL
                  FROM T_GLB_MOEDAVL
                 WHERE GLB_MOEDA_CODIGO = V_MOEDA_CAMPO
                   AND GLB_MOEDAVL_DATAEFETIVA <= SYSDATE
                 ORDER BY GLB_MOEDAVL_DATAEFETIVA DESC;
                V_PONTEIRO := TO_CHAR(TO_NUMBER(V_VALOR_CAMPO) * V_VALOR_ATUAL);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  V_VALOR_ATUAL := '';
              END;
            ELSE
              --SIRLANO
              IF (V_MUDABASEICMS = 'S') AND
                 (V_PESOCOB > 5) AND
                 (RPAD(V_CAMPO, 10) = 'D_OT2') THEN
                UPDATE T_CON_CALCCONHECIMENTO
                   SET CON_CALCVIAGEM_VALOR = 0,
                       CON_CALCVIAGEM_DESINENCIA = 'VL'
                 WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
                   AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                   AND GLB_ROTA_CODIGO = vROTA_CODIGO
                   AND SLF_RECCUST_CODIGO = RPAD('D_OT2', 10);
                UPDATE T_CON_CALCCONHECIMENTO
                   SET CON_CALCVIAGEM_VALOR = 0,
                       CON_CALCVIAGEM_DESINENCIA = 'VL'
                 WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
                   AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                   AND GLB_ROTA_CODIGO = vROTA_CODIGO
                   AND SLF_RECCUST_CODIGO = RPAD('R_OTICMS2', 10);
                V_VALOR_CAMPO := 0;
              END IF;
              IF (V_VALOR_CAMPO IS NULL) OR
                 (V_VALOR_CAMPO = '') THEN
                V_PONTEIRO := '0';
              ELSE
                V_PONTEIRO := V_VALOR_CAMPO;
              END IF;
            END IF;
            V_FORMULA_CALCTRATADA := CONCAT(RTRIM(LTRIM(V_FORMULA_CALCTRATADA)),
                                            RTRIM(LTRIM(V_PONTEIRO)));
            V_PONTEIRO            := '';
          ELSE
            V_FORMULA_CALCTRATADA := CONCAT(RTRIM(LTRIM(V_FORMULA_CALCTRATADA)),
                                            RTRIM(LTRIM(V_PONTEIRO)));
            V_CONT                := V_CONT + 1;
            V_PONTEIRO            := '';
          END IF;
        ELSE
          V_FORMULA_CALCTRATADA := CONCAT(RTRIM(LTRIM(V_FORMULA_CALCTRATADA)),
                                          RTRIM(LTRIM(V_PONTEIRO)));
          V_CONT                := V_CONT + 1;
          V_PONTEIRO            := '';
        END IF;
        V_PONTEIRO := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC, V_CONT, 1)));
        V_CAMPO    := '';
      END LOOP;
      --RETORNA VERBA RESULTADO
      BEGIN
        SELECT SLF_RECCUST_CODIGO
          INTO V_VERBARESULTADO
          FROM T_SLF_CALCULO
         WHERE SLF_TPCALCULO_CODIGO = V_TIPOCALCULOSEQ
           AND SLF_CALCULO_TPCAMPO = 'R';
        --If (((V_Calcestado_Isencao = 'S')) And (Rpad(V_VERBARESULTADO,10) = Rpad('I_BSCLICMS',10))) OR 
        --   ((vINCLUIPED = 'N') And (Rpad(V_VERBARESULTADO,10) = Rpad('I_TTPV',10))) THEN Begin
        -- TROQUEI O NOME DA VARIAVEL
        -- GILES 25/03/2004
        IF (((V_CALCESTADO_ISENCAO = 'S')) AND
           (RPAD(V_VERBARESULTADO, 10) = RPAD('I_BSCLICMS', 10))) OR
           ((V_INCPEDAGIO = 'N') AND
           (RPAD(V_VERBARESULTADO, 10) = RPAD('I_TTPV', 10))) THEN
          BEGIN
            SELECT CON_CALCVIAGEM_VALOR
              INTO V_PEDAGIO
              FROM T_CON_CALCCONHECIMENTO
             WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
               AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
               AND SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI
               AND GLB_ROTA_CODIGO = vROTA_CODIGO
               AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD('I_PD', 10);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_PEDAGIO := 0;
          END;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_VERBARESULTADO := '';
      END;
      --        IF V_VERBARESULTADO = 'R_OTICMS3' THEN
      --            INSERT INTO DROPME(A,X) VALUES ('OUTROS3 - FORMULA NORMAL',V_FORMULA_CALC);
      --            INSERT INTO DROPME(A,X) VALUES ('OUTROS3 - FORMULA TRATADA',V_FORMULA_CALCTRATADA);
      --        END IF;
      --insert into cle01(x) values ('verba resultado '|| V_VERBARESULTADO);
      --RETORNA PRECISAO
      BEGIN
        SELECT SLF_CALCULO_PRECISAO
          INTO V_PRECISAO
          FROM T_SLF_CALCULO
         WHERE SLF_TPCALCULO_CODIGO = V_TIPOCALCULOSEQ
           AND SLF_RECCUST_CODIGO = RPAD(V_VERBARESULTADO, 10);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_PRECISAO := '0';
      END;
      --insert into cle01(x) values ('calculo trat'|| V_FORMULA_CALCTRATADA);
      CUR := DBMS_SQL.OPEN_CURSOR;
      BEGIN
        CUR := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(CUR,
                       'SELECT ROUND(' ||
                       REPLACE(V_FORMULA_CALCTRATADA, ',', '.') ||
                       ',10) FROM DUAL ',
                       DBMS_SQL.V7);
        DBMS_SQL.DEFINE_COLUMN(CUR, 1, V_VALOR_FORMULA, 30);
        TOTAL := DBMS_SQL.EXECUTE(CUR);
        TOTAL := DBMS_SQL.FETCH_ROWS(CUR);
        DBMS_SQL.COLUMN_VALUE(CUR, 1, V_VALOR_FORMULA);
        DBMS_SQL.CLOSE_CURSOR(CUR);
      EXCEPTION
        WHEN OTHERS THEN
          IF V_VERBARESULTADO = 'I_MRBRC' THEN
            V_VALOR_FORMULA := 100;
          ELSE
            V_VALOR_FORMULA := 0;
          END IF;
      END;
      
      

--      insert into t_glb_sql values (null,
--                                            sysdate,
--                                            'FORMULA' || '-' || vnumero || '-' || to_char(v_vseq,'00') || ' conhec '||vNUMERO||' serie '||vSAQUE_SERIE ||' rota '||vROTA_CODIGO,
--                                            V_TIPOCALCULOSEQ || '-'||V_DESINENCIA || ' - ' ||  V_FORMULA_CALC || ' - ' || V_FORMULA_CALCTRATADA||' Valor '|| V_VALOR_FORMULA|| ' verba result '||v_verbaresultado);
      v_vseq := v_vseq + 1;
      --SIRLANO
      IF V_VERBARESULTADO = 'I_TTPV' THEN
        V_VALORITTPV := ROUND(V_VALOR_FORMULA - V_PEDAGIO, 2);
      END IF;
      IF (V_MUDABASEICMS = 'S') AND
         (V_PESOCOB > 5) AND
         (V_VERBARESULTADO = 'I_BSCLICMS') THEN
        IF ((ROUND(V_VALOR_FORMULA - V_PEDAGIO, V_PRECISAO) / V_PESOCOB) < 90) THEN
          V_VALOR_FORMULA := (V_PESOCOB * 90) + V_PEDAGIO;
          -- CALCULA NOVO VALOR PARA OUTROS
          V_NOVO_VALOROUTROS := ((((V_VALOR_FORMULA - V_VALORITTPV) *
                                (V_VALOR_ICMS / 100)) *
                                ((100 - V_VALOR_ICMS) / 100)) / 0.95);
          UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = V_NOVO_VALOROUTROS,
                 CON_CALCVIAGEM_DESINENCIA = 'VL'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('D_OT2', 10);
          V_NOVO_VALOROUTROS := V_NOVO_VALOROUTROS / ((100 - V_VALOR_ICMS) / 100);
          UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = V_NOVO_VALOROUTROS,
                 CON_CALCVIAGEM_DESINENCIA = 'VL'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('R_OTICMS2', 10);
          UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = CON_CALCVIAGEM_VALOR + V_NOVO_VALOROUTROS,
                 CON_CALCVIAGEM_DESINENCIA = 'VL'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('I_OT', 10);
          UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = CON_CALCVIAGEM_VALOR + V_NOVO_VALOROUTROS,
                 CON_CALCVIAGEM_DESINENCIA = 'VL'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('I_TTPV', 10);
          UPDATE T_CON_CONHECIMENTO
             SET CON_CONHECIMENTO_OBS = TRIM(CON_CONHECIMENTO_OBS) ||
                                        ' AJUSTE CONF. O.S.58/2003 ANEXO II'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND CON_CONHECIMENTO_OBS NOT LIKE '%O.S.58/2003%';
        END IF;
      END IF;
      BEGIN
          IF (V_VERBARESULTADO = 'R_FRPSVOIC' OR V_VERBARESULTADO = 'R_FRPSVOIS') 
             and vROTA_CODIGO = '216' THEN
             V_PRECISAO := 20;
          END IF;
          


      If vDebugCalculoCTRC = vNUMERO || vROTA_CODIGO  Then
         Insert Into dropme (a,l) Values (substr('DEBUGCTRC CON_CONHECIMENTO - ' || vNUMERO || 
                                          ' SERIE - ' || vSAQUE_SERIE || ' ROTA - ' || vROTA_CODIGO,1,100),
                                          'TIPOCALCULOPAI - ' || vTIPOCALCULOPAI || chr(10) || 
                                          'VERBARESULTADO - ' || V_VERBARESULTADO || chr(10) || 
                                          'FORMULA_CALCTRATADA - ' || V_FORMULA_CALCTRATADA || chr(10) || 
                                          'VALOR_FORMULA - ' || V_VALOR_FORMULA || chr(10) || 
                                          'PEDAGIO ' || V_PEDAGIO || chr(10) || 
                                          'PRECISAO ' || V_PRECISAO 
                                         );
      End If;

      If  (TRIM(V_VERBARESULTADO) = 'I_VLICMS') or 
          (TRIM(V_VERBARESULTADO) = 'I_VLISS'  and vROTA_CODIGO not in ('028','031') ) or 
          ( vContrato = 'C5100006176' ) THEN
        UPDATE T_CON_CALCCONHECIMENTO
           SET CON_CALCVIAGEM_VALOR = ROUND(V_VALOR_FORMULA - V_PEDAGIO, V_PRECISAO),
               CON_CALCVIAGEM_DESINENCIA = V_FORMULA_DESINENCIARTR,
               GLB_MOEDA_CODIGO = V_FORMULA_MOEDA
         WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND GLB_ROTA_CODIGO = vROTA_CODIGO
           AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD(V_VERBARESULTADO, 10)
           AND (CON_CONHECIMENTO_ALTALTMAN IS NULL OR
               CON_CONHECIMENTO_ALTALTMAN = '' OR
               CON_CONHECIMENTO_ALTALTMAN = ' ');        
      Else
        UPDATE T_CON_CALCCONHECIMENTO
           SET CON_CALCVIAGEM_VALOR = TRUNC(V_VALOR_FORMULA - V_PEDAGIO, V_PRECISAO),
               CON_CALCVIAGEM_DESINENCIA = V_FORMULA_DESINENCIARTR,
               GLB_MOEDA_CODIGO = V_FORMULA_MOEDA
         WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
           AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND GLB_ROTA_CODIGO = vROTA_CODIGO
           AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD(V_VERBARESULTADO, 10)
           AND (CON_CONHECIMENTO_ALTALTMAN IS NULL OR
               CON_CONHECIMENTO_ALTALTMAN = '' OR
               CON_CONHECIMENTO_ALTALTMAN = ' ');        
      End If;      
  

      EXCEPTION
        WHEN OTHERS THEN
          RAISE;
          RAISE_APPLICATION_ERROR(-20001,
                                  vNUMERO || ' ' || vSAQUE_SERIE || ' ' ||
                                  vROTA_CODIGO||' - '||DBMS_UTILITY.format_error_backtrace);
      END;
      IF RPAD(V_VERBARESULTADO, 10) = 'R_FRPSVOIC' THEN
        SELECT COUNT(*)
          INTO V_PESOCOB
          FROM T_CON_CONHECIMENTO A
         WHERE A.CON_CONHECIMENTO_CODIGO = vNUMERO
           AND A.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
           AND A.GLB_ROTA_CODIGO = vROTA_CODIGO
           AND A.SLF_TABELA_CODIGO = '00000671'
           AND A.CON_CONHECIMENTO_DTEMBARQUE >= '23/06/2004'
           AND A.CON_CONHECIMENTO_DTEMBARQUE <= '01/07/2004';
        --             RAISE_APPLICATION_ERROR(-20001, 'LEIDE - ' || V_VALOR_FORMULA * 0.20);
        IF V_PESOCOB <> 0 THEN
          V_NOVO_VALOROUTROS := ROUND((V_VALOR_FORMULA *
                                      ROUND(((100 - V_VALOR_ICMS) / 100), 6)) * 0.20,V_PRECISAO );
          UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = V_NOVO_VALOROUTROS,
                 CON_CALCVIAGEM_DESINENCIA = 'TX'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('D_OT1', 10);
        END IF;
      END IF;
      IF (vTIPOCALCULOPAI = '314' AND V_TPCALCULO_CODIGO = '440') OR
         (((SUBSTR(nvl(V_ESTADO_ISENTOLEI,'N'), 1, 1) <> 'N') OR
           (SUBSTR(nvl(V_SUBST_LEI,'N'), 1, 1) <> 'N')) AND
           (V_DATAEMBARQUE >= '27/08/2004') AND
           (NVL(V_ALIQUOTAINTERNA, 'N') <> 'S')) THEN
        IF NOT ((SUBSTR(nvl(V_SUBST_LEI,'N'), 1, 1) <> 'N') AND
                (V_ESTADO_ORIGEM IN ('MG','PE')) AND
                (V_DATAEMBARQUE >= '01/04/2006')) THEN

           --Para na zerar alem das condicoes acima temos mais uma lista de CPJJ
           If instr(vListaCNPJcomDestaqueICMS,trim(V_CGCSACADO)) = 0 and
              V_ESTADO_ORIGEM NOT IN ('ES','MS') Then

             UPDATE T_CON_CALCCONHECIMENTO
                SET CON_CALCVIAGEM_VALOR = 0
              WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
                AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
                AND GLB_ROTA_CODIGO = vROTA_CODIGO
                AND slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS')
--             Sirlano Troquei em 24/11/2014 quando zerar a aliquota serar o icms     
--             AND RPAD(SLF_RECCUST_CODIGO, 10) = RPAD('S_ALICMS', 10)
                AND (CON_CONHECIMENTO_ALTALTMAN IS NULL 
                  or CON_CONHECIMENTO_ALTALTMAN = '' 
                  or CON_CONHECIMENTO_ALTALTMAN = ' ');
             if sql%rowcount > 0 Then
                 UPDATE T_CON_CONHECIMENTO C
                   SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
                 WHERE C.CON_CONHECIMENTO_CODIGO = vNUMERO
                   AND C.CON_CONHECIMENTO_SERIE = vROTA_CODIGO
                   AND C.GLB_ROTA_CODIGO = vROTA_CODIGO;
             End If;   
          End If;
        END IF;
      END IF;
      V_VALOR_FORMULA       := '';
      V_FORMULA_CALCTRATADA := '';
      V_PRECISAO            := '';
      V_FORMULA_CALC        := '';
      V_PEDAGIO             := 0;
    END LOOP;
    If vNUMERO <> '409793' Then
    COMMIT;
    End If;
     -- sirlano    

     if fn_Troca_tags(vNUMERO,vSAQUE_SERIE,vROTA_CODIGO,vObsCli) Then
--      IF vNUMERO = '843516' THEN
--        RAISE_APPLICATION_ERROR(-20001,'-CONTRATO-' || upper(trim(vObsCli)));
--       END IF;
       update T_CON_CONHECIMENTO cc
          set cc.con_conhecimento_obscliente = vObsCli 
       WHERE Cc.CON_CONHECIMENTO_CODIGO = vNUMERO
         AND Cc.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         AND Cc.GLB_ROTA_CODIGO = vROTA_CODIGO;
     End If;
    BEGIN
      SELECT CA.CON_CALCVIAGEM_VALOR
        INTO V_VALOR_CAMPO
      FROM T_CON_CALCCONHECIMENTO CA
      WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
        AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
        AND CA.GLB_ROTA_CODIGO = vROTA_CODIGO
        AND CA.SLF_RECCUST_CODIGO = RPAD('S_BSMIICMS',10)
        AND CA.SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI;    
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN
        V_VALOR_CAMPO := 0;
    END;  
    
    IF V_VALOR_CAMPO > 0  THEN

        BEGIN
          SELECT CA.CON_CALCVIAGEM_VALOR
            INTO V_VALOR_ATUAL
          FROM T_CON_CALCCONHECIMENTO CA
          WHERE CA.CON_CONHECIMENTO_CODIGO = vNUMERO
            AND CA.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
            AND CA.GLB_ROTA_CODIGO = vROTA_CODIGO
            AND CA.SLF_RECCUST_CODIGO = RPAD('I_BSCLICMS',10)
            AND CA.SLF_TPCALCULO_CODIGO = vTIPOCALCULOPAI;    
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN
            V_VALOR_ATUAL := 0;
        END;  
        
        -- VERIFICA SE O VALOR DA BASE E MENOR QUEO MINIMO
        IF V_VALOR_ATUAL < V_VALOR_CAMPO THEN
           -- CALCULA O VALOR DO ICMS PARA JOGAR EM OUTROS
           UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = V_VALOR_CAMPO * (V_ALIQ / 100),
                 CON_CALCVIAGEM_DESINENCIA = 'VL'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('D_OT1', 10);
           -- ATUALIZA O NOVO VALOR DA BASE           
           UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = V_VALOR_CAMPO,
                 CON_CALCVIAGEM_DESINENCIA = 'VL',
                 con_conhecimento_altaltman = 'A'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('I_BSCLICMS',10);
           -- ZERA A LIQUOTA PARA RE-FAZER O CALCULO
           UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = 0,
                 con_conhecimento_altaltman = 'A'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             and nvl(con_conhecimento_altaltman,'N') = 'N'
            AND slf_reccust_codigo IN ('I_BSCLICMS','I_VLICMS','S_ALICMS');
--            alterado em 24/11/2014 quando zerar a aliquota zera o ICMS 
--             AND SLF_RECCUST_CODIGO = RPAD('S_ALICMS',10);
          if sql%rowcount > 0 Then
              UPDATE T_CON_CONHECIMENTO C
                SET C.CON_CONHECIMENTO_TRIBUTACAO = 'I'
              WHERE C.CON_CONHECIMENTO_CODIGO = vNUMERO
                AND C.CON_CONHECIMENTO_SERIE = vROTA_CODIGO
                AND C.GLB_ROTA_CODIGO = vROTA_CODIGO;
          End If;   
             
          
    tdvadm.pkg_fifo_carregctrc .sp_Partilha(V_NUMERO,'XXX',vROTA_CODIGO,vStatus,vMessage);
          
    If vNUMERO <> '409793' Then
    COMMIT;
    End If;

           PKG_SLF_CALCULOS.SP_MONTA_FORMULA_CNHC(vTIPOCALCULOPAI,
                                                  vNUMERO,
                                                  vSAQUE_SERIE,
                                                  vROTA_CODIGO,
                                                  vINCLUIPED);    
           -- VOLTA O VALOR DA ALIQUOTA
           UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = V_ALIQ
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('S_ALICMS',10);
           UPDATE T_CON_CALCCONHECIMENTO
             SET CON_CALCVIAGEM_VALOR = V_VALOR_CAMPO * ( V_ALIQ / 100 )
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND SLF_RECCUST_CODIGO = RPAD('I_VLICMS',10);
           UPDATE T_CON_CALCCONHECIMENTO
             SET con_conhecimento_altaltman = 'A'
           WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
             AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
             AND GLB_ROTA_CODIGO = vROTA_CODIGO
             AND CON_CALCVIAGEM_VALOR <> 0;


        END IF;
        
        If vNUMERO <> '409793' Then
           COMMIT;
        End If;

    END IF;
    --    IF  ((SUBSTR(V_ESTADO_ISENTOLEI,1,1) <> 'N') and 
    --         ( V_DATAEMBARQUE >= '27/08/2004') AND (vTIPOCALCULOPAI = '0 41') and (NVL(V_ALIQUOTAINTERNA,'N') <> 'S') ) THEN
    --       UPDATE T_CON_CONHECIMENTO
    --       SET CON_CONHECIMENTO_OBS = V_ESTADO_ISENTOLEI || ' ' || TRIM(CON_CONHECIMENTO_OBS)
    --       WHERE CON_CONHECIMENTO_CODIGO = vNUMERO
    --         AND CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
    --         AND GLB_ROTA_CODIGO =    vROTA_CODIGO
    --         AND instr(trim(nvl(CON_CONHECIMENTO_OBS,'a')),V_ESTADO_ISENTOLEI) = 0;
    --    END IF;   

    -- JERONIMO - 30/11/2005 - inicio
    -- CHUMBADA PARA VALE DO RIO DOCE "DRIBLANDO" ROTINA DE SUBSTITUIC?O TRIBUTARIA DO ESTADO DE MINAS GERAIS
    /*
    IF V_ESTADO_ORIGEM = 'MG' AND
       V_ESTADO_DESTINO <> 'MG' AND
       V_DATAEMBARQUE >= '01/12/2005' AND
       (SUBSTR(V_CGCSACADO,1,8) IN ('00924429','33592510','33931494','27251842','27063874','27240092',
                                    '15144306','03553344','02639850','72372998','05728345','33931478') OR
        SUBSTR(V_CGCDESTINATARIO,1,8) IN ('00924429','33592510','33931494','27251842','27063874','27240092',
                                          '15144306','03553344','02639850','72372998','05728345','33931478')) THEN 
      BEGIN
        SELECT I.SLF_ICMS_ALIQUOTA
          INTO V_ALIQ
          FROM T_SLF_ICMS I
         WHERE I.GLB_ESTADO_CODIGOORIGEM = 'MG'
           AND I.GLB_ESTADO_CODIGODESTINO = V_ESTADO_DESTINO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_ALIQ := 0;
      END;
      UPDATE T_CON_CALCCONHECIMENTO CC
         SET CC.CON_CALCVIAGEM_VALOR = V_ALIQ
       WHERE CC.CON_CONHECIMENTO_CODIGO = vNUMERO
         AND CC.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         AND CC.GLB_ROTA_CODIGO = vROTA_CODIGO
         AND CC.SLF_RECCUST_CODIGO = 'S_ALICMS';
      UPDATE T_CON_CALCCONHECIMENTO CC
         SET CC.CON_CALCVIAGEM_VALOR = (V_ALIQ / 100) * (SELECT T.CON_CALCVIAGEM_VALOR
                                                           FROM V_CON_I_TTPV T
                                                          WHERE T.CON_CONHECIMENTO_CODIGO = CC.CON_CONHECIMENTO_CODIGO
                                                            AND T.CON_CONHECIMENTO_SERIE = CC.CON_CONHECIMENTO_SERIE
                                                            AND T.GLB_ROTA_CODIGO = CC.GLB_ROTA_CODIGO)
       WHERE CC.CON_CONHECIMENTO_CODIGO = vNUMERO
         AND CC.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         AND CC.GLB_ROTA_CODIGO = vROTA_CODIGO
         AND CC.SLF_RECCUST_CODIGO = 'I_VLICMS';
      UPDATE T_CON_CALCCONHECIMENTO CC
         SET CC.CON_CALCVIAGEM_VALOR = (SELECT T.CON_CALCVIAGEM_VALOR
                                          FROM V_CON_I_TTPV T
                                         WHERE T.CON_CONHECIMENTO_CODIGO = CC.CON_CONHECIMENTO_CODIGO
                                           AND T.CON_CONHECIMENTO_SERIE = CC.CON_CONHECIMENTO_SERIE
                                           AND T.GLB_ROTA_CODIGO = CC.GLB_ROTA_CODIGO)
       WHERE CC.CON_CONHECIMENTO_CODIGO = vNUMERO
         AND CC.CON_CONHECIMENTO_SERIE = vSAQUE_SERIE
         AND CC.GLB_ROTA_CODIGO = vROTA_CODIGO
         AND CC.SLF_RECCUST_CODIGO = 'I_BSCLICMS';
      COMMIT;
    END IF;
    -- JERONIMO - 30/11/2005 - fim
    */
   
  END SP_MONTA_FORMULA_CNHC;
  
  
  FUNCTION F_BUSCA_CONHEC_TPFORMULARIO(P_CONHECIMENTO_CODIGO IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                       P_CONHECIMENTO_SERIE  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                       P_ROTA_CODIGO         IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN CHAR IS
 
 V_TPFORMULARIO T_SLF_TPCALCULO.SLF_TPCALCULO_FORMULARIO%TYPE;
  V_FORMULARIO   VARCHAR2(16);
  V_CODIGO       T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_SERIE        T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  V_ROTA         T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE;

  BEGIN

      Begin
         V_CODIGO := ltrim(TO_CHAR(TO_NUMBER(P_CONHECIMENTO_CODIGO), '000000'));
      exception
        When OTHERS Then
         V_CODIGO := substr('000000' || trim(P_CONHECIMENTO_CODIGO),-6,6);
        End;   

      V_SERIE  := UPPER(P_CONHECIMENTO_SERIE);
      V_ROTA   := ltrim(TO_CHAR(TO_NUMBER(P_ROTA_CODIGO), '000'));

      BEGIN
        SELECT CA.SLF_TPCALCULO_FORMULARIO
          INTO V_TPFORMULARIO
          FROM T_CON_CALCCONHECIMENTO CT, T_SLF_TPCALCULO CA
         WHERE CT.CON_CONHECIMENTO_CODIGO = V_CODIGO
           AND CT.CON_CONHECIMENTO_SERIE = V_SERIE
           AND CT.GLB_ROTA_CODIGO = V_ROTA
           AND CT.SLF_RECCUST_CODIGO = 'I_TTPV'
           AND CT.SLF_TPCALCULO_CODIGO = CA.SLF_TPCALCULO_CODIGO
           AND CA.SLF_TPCALCULO_CALCULOMAE = 'S'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_TPFORMULARIO := 'X';
        
      END;

      IF V_TPFORMULARIO = 'C' THEN
        V_FORMULARIO := 'CTRC';
      ELSIF V_TPFORMULARIO = 'X' THEN
        V_FORMULARIO := 'NAO IDENTIFICADO';
      ELSE
        V_FORMULARIO := 'NF';
      END IF;

      RETURN V_FORMULARIO;
      
  END F_BUSCA_CONHEC_TPFORMULARIO;

END PKG_SLF_CALCULOS;
/
