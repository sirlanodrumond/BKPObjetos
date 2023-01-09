CREATE OR REPLACE TRIGGER TG_AIUD_VALEFRETE
  AFTER INSERT OR DELETE OR UPDATE ON TDVADM.T_CON_VALEFRETE  
  FOR EACH ROW
DECLARE
 -- TDVADM.TG_AUC_CON_VALEFRETEANAVIAGEM
 call_stack  varchar2(4096) default dbms_utility.format_call_stack;
 vViagemCodVf   tdvadm.t_con_viagem.con_viagem_numero%type;
 vViagemRtVf    tdvadm.t_con_viagem.glb_rota_codigoviagem%type;
 vViagemCodCte  tdvadm.t_con_viagem.con_viagem_numero%type;
 vViagemRtCte   tdvadm.t_con_viagem.glb_rota_codigoviagem%type;

 vViagemInfo    tdvadm.t_con_viagem%rowtype;
 vViagemInfo2   tdvadm.t_con_viagem%rowtype;

 vTerminal      tdvadm.v_glb_ambiente.terminal%type;
 vOsUser        tdvadm.v_glb_ambiente.os_user%type;
 vProgram       tdvadm.v_glb_ambiente.PROGRAM%type;
 vIP            tdvadm.v_glb_ambiente.ip_address%type;

 vCiot          tdvadm.t_con_vfreteciot.con_vfreteciot_numero%type; 
 
 -- TDVADM.TG_aduc_CON_VALEFRETELOG
 V_OUSER    V_GLB_AMBIENTE.OS_USER%TYPE;
 V_USER     V_GLB_AMBIENTE.SESSION_USER%TYPE;
 V_MACHINE  V_GLB_AMBIENTE.HOST%TYPE;
 V_PROGRAM  V_GLB_AMBIENTE.PROGRAM%TYPE;
 V_OPERACAO VARCHAR2(100);
 vPlacaANT  varchar2(10);
 vPlacaATU  varchar2(10);
 vMsg       clob;


 -- TDVADM.TG_VALEFRETE_EMAIL
 --Tipo que vai me fornecer a estrutura necessária para montar o e-mail.
  Type  tDadosEmail Is Record ( valefrete_codigo     t_con_valefrete.con_conhecimento_codigo%Type,
                                valefrete_rota       t_glb_rota.glb_rota_codigo%Type,
                                valefrete_origem     t_con_valefrete.con_valefrete_localcarreg%Type,
                                valefrete_destino    t_con_valefrete.con_valefrete_localdescarga%Type,
                                valefrete_dtEnrega   t_con_valefrete.con_valefrete_dataprazomax%Type,
                                valefrete_Valor      Varchar2(30),

                                FrotaAgregado_codigo Char(07),
                                FrotaAgregado_tipo   t_con_valefrete.glb_tpmotorista_codigo%Type,
                                Agregado_cpfcnpj     Varchar2(20),
                                Agregado_nome        Varchar2(50),

                                veiculo_placa        Char(07),
                                veiculo_marca        Varchar2(50),
                                mct_codigo           t_atr_terminal.atr_terminal_mct%Type,
                                
                                email_Mensagem       t_uti_infomail.uti_infomail_memo%Type,
                                email_destino        t_uti_infomail.uti_infomail_endmaildestinatar%Type,
                                email_assunto        t_uti_infomail.uti_infomail_assunto%Type     
                              );  
                              
  vDados   tDadosEmail;
  vTpValeFrete   Varchar2(10) := '';
  vFrota         Char(07);
  vPlaca         Char(07);
  vMarca         Varchar2(50);
  vMct           tdvadm.t_atr_terminal.atr_terminal_mct%Type;
  vCnpjCgc_Proc  tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%Type:= '';
  vNomeProc      tdvadm.t_car_proprietario.car_proprietario_razaosocial%Type := '';
  vMensagem      Varchar2(1000):= '';
  vAssunto       t_uti_infomail.uti_infomail_assunto%Type;
 
  -- TDVADM.TG_AIU_INSEREVFRETE
  sProprietario     T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE;
  sProprietarioNome T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_RAZAOSOCIAL%TYPE;
  vt_veiculo_codigo t_frt_veiculo.frt_veiculo_codigo%TYPE;
  v_origem          varchar(100);
  v_Destino         varchar(100);
  DATA_INIC         DATE;
  DATA_PREVISAO     DATE;
  TOTAL_DIAS_INS    NUMBER;
  DATA_MOVTO        DATE;
  CONTADOR          NUMBER;
  TPDOC             CHAR(3);
  CONTINUA          BOOLEAN;
  v_UsuarioVF       char(10);
  v_bloqueios       number;
  v_alertas         number;
  
  -- TDVADM.TG_AU_ATU_CONHECIMENTO_WEB
  V_ROTAVALE    T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE;
  V_DATAENTREGA T_CON_VFRETECONHEC.CON_VFRETECONHEC_DTENTREGA%TYPE;
  
  -- TDVADM.TG_AUD_ATUALIZA_VEICULODISP
  vVeiculoDispNumero    tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
  vVeiculoDispSeq       tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;

   -- TDVADM.TG_AU_C_ACOMPANHAMENTO_VIAGENS
   V_USUARIO         VARCHAR(50);
   V_DESC_ROTA       VARCHAR(50);
   V_MOTORISTA       VARCHAR(80);
   V_MAQUINA         VARCHAR(50);
   V_CONJUNTO        CHAR(7);
   V_USUARIO_MAQUINA VARCHAR(50);
   V_TERMINAL        NUMBER;
   V_MARCATERMINAL   VARCHAR(30);
   V_KM              NUMBER;
   V_KMPERCURSO      NUMBER;
   V_DIAS            NUMBER;
   V_KMMIN           NUMBER;
   V_PLACA           VARCHAR(7);
   V_CATEGORIA       T_CON_CATVALEFRETE.CON_CATVALEFRETE_DESCRICAO%TYPE;

   vAuxiliar         number;
   TPVALEFRETEHIST   TDVADM.T_CON_VALEFRETEHIST%ROWTYPE;

BEGIN
  
   vMsg := empty_clob;
   
   select amb.terminal,
          amb.os_user,
          amb.PROGRAM,
          amb.ip_address
      into vTerminal,
           vOsUser,
           vProgram,
           ViP
   from tdvadm.v_glb_ambiente amb;

 
  -- TDVADM.TG_AUC_CON_VALEFRETEANAVIAGEM
  if updating('CON_VALEFRETE_IMPRESSO') then
        if (:new.CON_VALEFRETE_IMPRESSO = 'S') and (nvl(:new.con_valefrete_fifo,'N') = 'S') then

          vViagemCodVf := :NEW.CON_VIAGEM_NUMERO;
          vViagemRtVf  := :NEW.GLB_ROTA_CODIGOVIAGEM;
          begin
            select k.con_viagem_numero,
                   k.glb_rota_codigoviagem
              into vViagemCodCte,
                   vViagemRtCte
              from tdvadm.t_con_conhecimento k
              where k.con_conhecimento_codigo = :NEW.CON_CONHECIMENTO_CODIGO
                and k.con_conhecimento_serie  = :NEW.CON_CONHECIMENTO_SERIE
                and k.glb_rota_codigo         = :NEW.GLB_ROTA_CODIGO;

            select *
              into vViagemInfo
              from tdvadm.t_con_viagem kk
             where kk.con_viagem_numero     = vViagemCodVf
               and kk.glb_rota_codigoviagem = vViagemRtVf;

            select *
              into vViagemInfo2
              from tdvadm.t_con_viagem kk
             where kk.con_viagem_numero     = vViagemCodCte
               and kk.glb_rota_codigoviagem = vViagemRtCte;

          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   NULL;
          End;

          insert into tdvadm.t_grd_audit(uti_audit_terminal,
                                  uti_audit_user,
                                  uti_audit_tabela,
                                  uti_audit_acao,
                                  uti_audit_valoranterior,
                                  uti_audit_valoratual,
                                  uti_audit_datagravacao,
                                  uti_audit_maquina,
                                  uti_audit_ouser,
                                  uti_audit_programa)
                           values(vTerminal,
                                  vOsUser,
                                  'T_CON_VALEFRETE',
                                  'IMPRESSAO',
                                  'Viagem VF: '||vViagemInfo.Con_Viagem_Numero||'-'||vViagemInfo.Glb_Rota_Codigoviagem||'_'||vViagemInfo.Car_Carreteiro_Cpfcodigo||'*'||vViagemInfo.Frt_Motorista_Codigo,
                                  'Viagem CTe:'||vViagemInfo.Con_Viagem_Numero||'-'||vViagemInfo.Glb_Rota_Codigoviagem||'_'||vViagemInfo.Car_Carreteiro_Cpfcodigo||'*'||vViagemInfo.Frt_Motorista_Codigo||' vfID: '||:NEW.CON_CONHECIMENTO_CODIGO||'-'||:NEW.CON_CONHECIMENTO_SERIE||'-'||:NEW.GLB_ROTA_CODIGO||'-'||:NEW.CON_VALEFRETE_SAQUE,
                                  sysdate,
                                  vTerminal,
                                  vOsUser,
                                  vProgram);

        end if;
  end if;
  
  -- TDVADM.TG_aduc_CON_VALEFRETELOG
  if updating('CON_VALEFRETE_ADIANTAMENTO') or
     updating('CON_VALEFRETE_VALORLIQUIDO') or
     updating('CON_VALEFRETE_IRRF')         or
     updating('CON_VALEFRETE_SESTSENAT')    or
     updating('CON_VALEFRETE_INSS')         or
     updating('FCF_VEICULODISP_CODIGO')     or
     DELETING                               then
    
      IF ((:OLD.CON_VALEFRETE_IRRF > 0)  AND  (:NEW.CON_VALEFRETE_IRRF <> :OLD.CON_VALEFRETE_IRRF)) OR
         ((:OLD.CON_VALEFRETE_SESTSENAT > 0)  AND  (:NEW.CON_VALEFRETE_SESTSENAT <> :OLD.CON_VALEFRETE_SESTSENAT)) OR
         ((:OLD.CON_VALEFRETE_INSS > 0)  AND  (:NEW.CON_VALEFRETE_INSS <> :OLD.CON_VALEFRETE_INSS)) OR
         ((:OLD.CON_VALEFRETE_ADIANTAMENTO > 0 )   AND  (:NEW.CON_VALEFRETE_ADIANTAMENTO <> :OLD.CON_VALEFRETE_ADIANTAMENTO)) OR
         ((:OLD.CON_VALEFRETE_VALORLIQUIDO > 0 )   AND  (:NEW.CON_VALEFRETE_VALORLIQUIDO <> :OLD.CON_VALEFRETE_VALORLIQUIDO)) OR
         ( NVL(:OLD.FCF_VEICULODISP_CODIGO,'XXX' ) <> nvl(:NEW.FCF_VEICULODISP_CODIGO,'YYY') ) THEN

      IF DELETING THEN
         V_OPERACAO := 'DELETE';
      ELSIF UPDATING THEN
         V_OPERACAO := 'UPDATE';
      END IF;

      BEGIN
        SELECT S.OS_USER,
               S.SESSION_USER,
               S.HOST,
               S.TERMINAL,
               S.PROGRAM
          INTO V_OUSER,
               V_USER,
               V_MACHINE,
               vTerminal,
               V_PROGRAM
          FROM V_GLB_AMBIENTE S;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_OUSER    := 'NOTFOUND';
          V_USER     := 'NOTFOUND';
          V_MACHINE  := 'NOTFOUND';
          vTerminal := 'NOTFOUND';
          V_PROGRAM  := 'NOTFOUND';
      END;

          IF ( NVL(:OLD.FCF_VEICULODISP_CODIGO,'XXX' ) <> nvl(:NEW.FCF_VEICULODISP_CODIGO,'YYY') ) and
             NVL(:OLD.FCF_VEICULODISP_CODIGO,'XXX' ) <> 'XXX' THEN

              Begin
                  select VD.CAR_VEICULO_PLACA
                    into vPlacaANT
                  from t_fcf_veiculodisp vd
                  Where vd.fcf_veiculodisp_codigo = :OLD.FCF_VEICULODISP_CODIGO
                    and vd.fcf_veiculodisp_sequencia = :OLD.FCF_VEICULODISP_SEQUENCIA;
              Exception
                When OTHERS Then
                   vPlacaANT := 'ERRO ';
                End ;
                
              Begin
                  select VD.CAR_VEICULO_PLACA
                    into vPlacaATU
                  from t_fcf_veiculodisp vd
                  Where vd.fcf_veiculodisp_codigo = :NEW.FCF_VEICULODISP_CODIGO
                    and vd.fcf_veiculodisp_sequencia = :NEW.FCF_VEICULODISP_SEQUENCIA;
              Exception
                When OTHERS Then
                   vPlacaATU := 'ERRO ';
                End ;

              If V_OPERACAO <> 'DELETE' Then
                 wservice.pkg_glb_email.SP_ENVIAEMAIL('MUDANDO O VEIC DISP',
                                                       'VDISP ' || V_OPERACAO  || CHR(13) ||
                                                       'VF: ' || :OLD.CON_CONHECIMENTO_CODIGO ||'-'|| :OLD.CON_CONHECIMENTO_SERIE || '-' || :OLD.GLB_ROTA_CODIGO || '-' || CHR(13) ||
                                                       'ANT : [' || :OLD.FCF_VEICULODISP_CODIGO || ']' || vPlacaANT || ' ATU : [' || :NEW.FCF_VEICULODISP_CODIGO || ']' || CHR(13) || CHR(13) ||
                                                       call_stack,
                                                       'aut-e@dellavolpe.com.br',
                                                       'sdrumond@dellavolpe.com.br');
                
                 INSERT INTO T_GRD_AUDIT(UTI_AUDIT_TERMINAL,
                                         UTI_AUDIT_USER,
                                         UTI_AUDIT_TABELA,
                                         UTI_AUDIT_ACAO,
                                         UTI_AUDIT_VALORANTERIOR,
                                         UTI_AUDIT_VALORATUAL,
                                         UTI_AUDIT_DATAGRAVACAO,
                                         UTI_AUDIT_MAQUINA,
                                         UTI_AUDIT_OUSER,
                                         UTI_AUDIT_PROGRAMA)
                                 VALUES (SUBSTR(vTerminal,1,50),
                                         SUBSTR(V_USER,1,50),
                                         'T_CON_VALEFRETE',
                                         'VDISP ' || V_OPERACAO,
                                         'VF: ' || :OLD.CON_CONHECIMENTO_CODIGO ||'-'|| :OLD.CON_CONHECIMENTO_SERIE || '-' || :OLD.GLB_ROTA_CODIGO || '-' || :OLD.CON_VALEFRETE_SAQUE,
                                         'ANT : [' || :OLD.FCF_VEICULODISP_CODIGO || '] ' || vPlacaANT || ' ATU : [' || :NEW.FCF_VEICULODISP_CODIGO || ']' || vPlacaATU,
                                         SYSDATE,
                                         SUBSTR(V_MACHINE,1,20),
                                         SUBSTR(V_OUSER,1,50),
                                         SUBSTR(V_PROGRAM,1,50));
              End If;    
          ELSE

              INSERT INTO T_GRD_AUDIT(UTI_AUDIT_TERMINAL,
                                      UTI_AUDIT_USER,
                                      UTI_AUDIT_TABELA,
                                      UTI_AUDIT_ACAO,
                                      UTI_AUDIT_VALORANTERIOR,
                                      UTI_AUDIT_VALORATUAL,
                                      UTI_AUDIT_DATAGRAVACAO,
                                      UTI_AUDIT_MAQUINA,
                                      UTI_AUDIT_OUSER,
                                      UTI_AUDIT_PROGRAMA)
                              VALUES (SUBSTR(vTerminal,1,50),
                                      SUBSTR(V_USER,1,50),
                                      'T_CON_VALEFRETE',
                                      V_OPERACAO,
                                      'VF: ' || :OLD.CON_CONHECIMENTO_CODIGO ||'-'|| :OLD.CON_CONHECIMENTO_SERIE || '-' || :OLD.GLB_ROTA_CODIGO || '-' || :OLD.CON_VALEFRETE_SAQUE,
                                      'VLR_ANT --> IR: ' || NVL(:OLD.CON_VALEFRETE_IRRF,0) || '  - SS: ' || NVL(:OLD.CON_VALEFRETE_SESTSENAT,0) || '  - INSS: ' || NVL(:OLD.CON_VALEFRETE_INSS,0) || ' - AD: ' || NVL(:OLD.CON_VALEFRETE_ADIANTAMENTO,0) || ' - LIQ: ' || NVL(:OLD.CON_VALEFRETE_VALORLIQUIDO,0) || 
                                      ' - VLR_ATU --> IR: ' || NVL(:NEW.CON_VALEFRETE_IRRF,0) || '  - SS: ' || NVL(:NEW.CON_VALEFRETE_SESTSENAT,0) || '  - INSS: ' || NVL(:NEW.CON_VALEFRETE_INSS,0) || ' - AD: ' || NVL(:NEW.CON_VALEFRETE_ADIANTAMENTO,0) || ' - LIQ: ' || NVL(:NEW.CON_VALEFRETE_VALORLIQUIDO,0),
                                      SYSDATE,
                                      SUBSTR(V_MACHINE,1,20),
                                      SUBSTR(V_OUSER,1,50),
                                      SUBSTR(V_PROGRAM,1,50));
          END IF;
      END IF;
  end if;
  
  -- TDVADM.TG_Auc_CON_VALEFRETEDDURO
  if updating('CON_VALEFRETE_STATUS') then
    
    IF (nvl(trim(:NEW.ACC_ACONTAS_NUMERO), 'SIRLANO') <> 'SIRLANO') AND
       (:NEW.CON_VALEFRETE_STATUS = 'C') THEN
      raise_application_error(-20001,'VALE DE FRETE NÃO PODE SER CANCELADO..'||:NEW.ACC_ACONTAS_NUMERO);
    END IF;

    IF (nvl(trim(:NEW.CAX_BOLETIM_DATA), '11/11/1111') <> '11/11/1111') AND
       (:NEW.CON_VALEFRETE_STATUS = 'C') THEN
      raise_application_error(-20001,'VALE DE FRETE NÃO PODE SER CANCELADO, VF LANÇADO CX');
    END IF;

    IF (nvl(trim(:NEW.CAX_BOLETIM_DATA), '11/11/1111') <> '11/11/1111') AND
       (:OLD.CON_VALEFRETE_STATUS = 'C') THEN
      raise_application_error(-20001,'LANCAMENTO NÃO PERMITIDO VALE DE FRETE CANCELADO');
    END IF;    

  end if;

  If updating('CON_VALEFRETE_CUSTOCARRETEIRO') Then
    
        select max(m.con_valefretelog_sequencia)
           into vAuxiliar
        from tdvadm.t_con_valefretelog m
        where m.con_valefretelog_documento = :NEW.CON_CONHECIMENTO_CODIGO
          and m.con_valefretelog_serie = :NEW.CON_CONHECIMENTO_SERIE
          and m.con_valefretelog_rota = :NEW.GLB_ROTA_CODIGO
          and m.con_valefretelog_saque = :NEW.CON_VALEFRETE_SAQUE;
        vAuxiliar := NVL(vAuxiliar,0);

     If ( ( ( nvl(:new.CON_VALEFRETE_CUSTOCARRETEIRO,0) > nvl(:old.CON_VALEFRETE_CUSTOCARRETEIRO,0) ) 
          and ( nvl(:old.CON_VALEFRETE_CUSTOCARRETEIRO,0) <> 0 ) )
        or ( vAuxiliar > 0 ) ) Then
        insert into tdvadm.t_con_valefretelog 
        Values
          (:NEW.CON_CONHECIMENTO_CODIGO,
           :NEW.CON_CONHECIMENTO_SERIE,
           :NEW.GLB_ROTA_CODIGO,
           :NEW.CON_VALEFRETE_SAQUE,
           vAuxiliar + 1,
           :NEW.CON_VALEFRETE_CUSTOCARRETEIRO,
           :OLD.CON_VALEFRETE_CUSTOCARRETEIRO,
           'Trrigger TG_AIUD_VALEFRETE',
           :NEW.USU_USUARIO_CODALTERACAO ,
           sysdate,
           vTerminal,
           vOsUser,
           vProgram);
 
     End If;
     
     
/*     If :new.fcf_fretecar_rowid is null Then
        vMsg := 'Usuario : ' || :new.usu_usuario_codigo || chr(10) ||
                'ValeFrete : ' || :new.con_conhecimento_codigo || :new.con_conhecimento_serie || :new.glb_rota_codigo || :new.con_valefrete_saque || chr(10) ||
                'Valores : Atual : ' || :new.con_valefrete_custocarreteiro || ' - Anterior ' || :old.con_valefrete_custocarreteiro || chr(10) ||
                'Hora : ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || chr(10) ;
        wservice.pkg_glb_email.SP_ENVIAEMAIL('VALE DE FRETE SEM MESA',
                                             vMsg,
                                             'aut-e@dellavolpe.com.br',
                                             'sirlano.drumond@dellavolpe.com.br;jose.dantas@dellavolpe.com.br');
    End If;*/
                                    

  End If;


  -- TDVADM.TG_ADU_ATUALIZA_CTACORRENTE
  if updating('CON_VALEFRETE_STATUS') or deleting then
    
    if updating then
       If nvl(:new.con_valefrete_status,'X') = 'C' THEN
          DELETE T_CAR_CONTACORRENTE CC2
          where trim(cc2.car_contacorrente_docref) = :NEW.CON_CONHECIMENTO_CODIGO ||:NEW.GLB_ROTA_CODIGO || :NEW.CON_VALEFRETE_SAQUE;
       end if;
    Elsif Deleting then
          DELETE T_CAR_CONTACORRENTE CC2
          where trim(cc2.car_contacorrente_docref) = :NEW.CON_CONHECIMENTO_CODIGO ||:NEW.GLB_ROTA_CODIGO || :NEW.CON_VALEFRETE_SAQUE;
    End if;           
    
  end if;
  
  -- TDVADM.TG_VALEFRETE_EMAIL
  if updating('con_catvalefrete_codigo')    or
     updating('con_valefrete_placa')        or
     updating('con_valefrete_placasaque')   or
     updating('glb_tpmotorista_codigo')     or
     updating('con_valefrete_dataprazomax') or
     updating('con_valefrete_impresso')     or
     inserting                              then
       
      --Verifico se o Vale de Frete é do tipo 10 e emitido para um Frota ou Agregado.
      If ( (:New.con_catvalefrete_codigo = '10') And  ( Trim(:New.glb_tpmotorista_codigo) In ('A', 'F') ) )  Then
        -------------------------------------------------------------------------------
        -- Como esse serviço vai estar sendo realizado por uma trigger, resolvi      --  
        -- realizar dois select, uma para frota e outro para o agregado,             -- 
        -- para evitar o uso de Alter Join.                                          --
        -------------------------------------------------------------------------------
        
        -------------- VARIÁVEIS RECUPERADAS DIRETAMENTE DA TABELA (:NEW) -------------
        vDados.valefrete_codigo   := :new.con_conhecimento_codigo;
        vDados.valefrete_rota     := :new.glb_rota_codigo;
        vDados.valefrete_dtEnrega := :new.con_valefrete_dataprazomax;
        vDados.FrotaAgregado_tipo := :new.glb_tpmotorista_codigo;
        vDados.valefrete_Valor    := to_char( :New.con_valefrete_valorliquido, 'FM99G999D99'); 
        
        ------- ENDEREÇO DE E-MAILS DE DESTINO ----------------------------------------   
        vDados.email_destino := '';
        vDados.email_destino := vDados.email_destino || 'tdv.spexpedicao@dellavolpe.com.br;';
        vDados.email_destino := vDados.email_destino || 'grp.rastreamento@dellavolpe.com.br;';
        vDados.email_destino := vDados.email_destino || 'tdv.sistema_autotrac@dellavolpe.com.br;';

        
        --Sendo de um frota, busco dados do Veiculo.
        If Trim(:new.glb_tpmotorista_codigo) = 'F' Then
          
          BEGIN
            Select
              :New.con_valefrete_placa     "Frota",
              V.FRT_VEICULO_PLACA          "PLACA",
              M.FRT_MARMODVEIC_MARCA       "MARCA",
              a.atr_terminal_mct           "MCT"
            Into
              vFrota,
              vPlaca,
              vMarca,
              vMct
            From
              t_frt_veiculo     V,
              T_FRT_MARMODVEIC  M,
              t_atr_terminal    A
            Where
              v.frt_veiculo_placa =   Trim(pkg_frtcar_veiculo.fn_get_placa( :New.con_valefrete_placa ))
              And M.FRT_MARMODVEIC_CODIGO = V.FRT_MARMODVEIC_CODIGO
              And v.frt_veiculo_placa = a.atr_terminal_placa
              And A.ATR_TERMINAL_ATIVO = 'S'
              And A.ATR_TERMINAL_DTRETIRADO Is Null;
          EXCEPTION
            WHEN TOO_MANY_ROWS  THEN   
                Select
                  :New.con_valefrete_placa     "Frota",
                  V.FRT_VEICULO_PLACA          "PLACA",
                  M.FRT_MARMODVEIC_MARCA       "MARCA",
                  a.atr_terminal_mct           "MCT"
                Into
                  vFrota,
                  vPlaca,
                  vMarca,
                  vMct
                From
                  t_frt_veiculo     V,
                  T_FRT_MARMODVEIC  M,
                  t_atr_terminal    A
                Where
                  v.frt_veiculo_placa =   Trim(pkg_frtcar_veiculo.fn_get_placa( :New.con_valefrete_placa ))
                  And M.FRT_MARMODVEIC_CODIGO = V.FRT_MARMODVEIC_CODIGO
                  And v.frt_veiculo_placa = a.atr_terminal_placa
                  And A.ATR_TERMINAL_ATIVO = 'S'
                  And A.ATR_TERMINAL_DTRETIRADO Is Null
                  AND ROWNUM = 1;
          WHEN NO_DATA_FOUND THEN
               vFrota := '';
               vPlaca := 'NLOCALI';
               vMarca := '';
               vMct   := '';
          END;        
          vTpValeFrete := 'FROTA';
        End If;

        --Sendo um Agregado
        If Trim(:new.glb_tpmotorista_codigo) = 'A' Then
     
           BEGIN
              Select
                w.car_veiculo_placa          "PLACA",
                w.car_veiculo_marca           "MARCA",
                f_mascara_cgccpf( Trim( p.car_proprietario_cgccpfcodigo)),
                p.car_proprietario_razaosocial,
                atr.atr_terminal_mct,
                veic.frt_veiculo_codigo
              Into
                vPlaca,
                vMarca,
                vCnpjCgc_Proc,
                vNomeProc,
                vMct,
                vFrota
              From
                t_car_veiculo       w,
                t_car_proprietario  p,
                t_atr_terminal      atr,
                T_FRT_VEICULO       veic
              Where
                w.car_veiculo_placa = :NEW.con_valefrete_placa
                And w.car_veiculo_saque = :NEW.con_valefrete_placasaque
                And ( veic.frt_veiculo_datavenda IS NULL or veic.frt_veiculo_datavenda >= :new.con_valefrete_dataemissao )
                
                And atr.atr_terminal_placa(+) = w.car_veiculo_placa
                And w.car_veiculo_placa  = veic.frt_veiculo_placa
                And atr.ATR_TERMINAL_ATIVO(+) = 'S'
                And Atr.ATR_TERMINAL_DTRETIRADO(+) Is Null
                And w.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo;
          EXCEPTION
            WHEN  TOO_MANY_ROWS  THEN   
              Select
                  w.car_veiculo_placa          "PLACA",
                  w.car_veiculo_marca           "MARCA",
                  f_mascara_cgccpf( Trim( p.car_proprietario_cgccpfcodigo)),
                  p.car_proprietario_razaosocial,
                  atr.atr_terminal_mct,
                  veic.frt_veiculo_codigo
                Into
                  vPlaca,
                  vMarca,
                  vCnpjCgc_Proc,
                  vNomeProc,
                  vMct,
                  vFrota
                From
                  t_car_veiculo       w,
                  t_car_proprietario  p,
                  t_atr_terminal      atr,
                  T_FRT_VEICULO       veic
                Where
                  w.car_veiculo_placa = :NEW.con_valefrete_placa
                  And w.car_veiculo_saque = :NEW.con_valefrete_placasaque
                  And ( veic.frt_veiculo_datavenda IS NULL or veic.frt_veiculo_datavenda >= :new.con_valefrete_dataemissao )
                  
                  And atr.atr_terminal_placa(+) = w.car_veiculo_placa
                  And w.car_veiculo_placa  = veic.frt_veiculo_placa
                  And atr.ATR_TERMINAL_ATIVO(+) = 'S'
                  And Atr.ATR_TERMINAL_DTRETIRADO(+) Is Null
                  And w.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo
                  AND ROWNUM = 1;
              
            WHEN NO_DATA_FOUND THEN
                  vPlaca := 'NLOCALI';
                  vMarca := '';
                  vCnpjCgc_Proc := '';
                  vNomeProc := '';
                  vMct := '';
                  vFrota := '';
            END;              
            vTpValeFrete := 'AGREGADO';
        End If;


        --Monto a mensagem para ser enviada.
        vMensagem := vMensagem || 'DADOS DO VALE DE FRETE '                                                      || Chr(13);
        vMensagem := vMensagem || 'Vale de Frete Código:  ' || :new.con_conhecimento_codigo || ' - Rota: ' || :new.glb_rota_codigo || chr(13);
        vMensagem := vMensagem || 'Origem: '                || :new.con_valefrete_localcarreg                          || Chr(13);
        vMensagem := vMensagem || 'Destino: '               || :New.con_valefrete_localdescarga                        || Chr(13);
        vMensagem := vMensagem || 'Data de Entrega: '       || to_char( :New.con_valefrete_dataprazomax, 'DD/MM/YYYY') || Chr(13);
        vMensagem := vMensagem || 'Valor Vale: R$ '         ||  vDados.valefrete_Valor                                 || CHR(13);

        vMensagem := vMensagem || Chr(13);
        vMensagem := vMensagem || 'DADOS DO VEICULO '                                                            || Chr(13);

        If Trim(vTpValeFrete)  = 'FROTA' Then
          vMensagem := vMensagem || 'Código Frota: '   || vFrota  || Chr(13);
        End If;

        If Trim(vTpValeFrete)  = 'AGREGADO' Then
          vMensagem := vMensagem || 'Agregado: '                 || vFrota           || chr(13) ;
          vMensagem := vMensagem || 'CPF / CNPPJ Proprietario: ' || vCnpjCgc_Proc    || Chr(13) ;
          vMensagem := vMensagem || 'Nome Proprietario: '        || vNomeProc        || Chr(13) ;
        End If;

        vMensagem := vMensagem || 'Placa: ' || vPlaca                                                            || Chr(13);
        vMensagem := vMensagem || 'Marca: ' || vMarca                                                            || Chr(13);
        vMensagem := vMensagem || 'MCT: '   || vMct                                                              || Chr(13);
        
        vMensagem := vMensagem || Chr(13) || Chr(13) || Chr(13) || Chr(13) || Chr(13);
        vMensagem := vMensagem || 'FAVOR NÃO RESPONDA ESSE E-MAIL.' || CHR(13);
        vMensagem := vMensagem || 'E-MAIL ENVIADO ATRAVÉS DE PROCESSO AUTOMÁTICO WORKFLOW DELLAVOLPE.';

        Begin
          vAssunto := 'SRV DE TERC : ' || Trim(:new.con_conhecimento_codigo) || ' - ' ||  Trim(vTpValeFrete) || ': ' || Trim(vFrota);
            --Insiro os dados na t_uti_infomail, para que o WorkFlow, faça o envio de e-mail.
            Insert Into tdvadm.t_uti_infomail( uti_infomail_codigo,
                                               uti_infomail_nomeremetente,
                                                uti_infomail_assunto ,
                                               uti_infomail_endmaildestinatar,
                                               uti_infomail_memo 
                                               ) 
                                               Values
                                               ( 'SEQUENCIAL',
                                                 'PRODUÇÃO',
                                                 vAssunto,
                                                 vDados.email_destino,
                                                 Trim(vMensagem)
                                               );  

        Exception
          When Others Then
               Insert Into tdvadm.dropme(a, l) Values ('teste valefrete', 'erro: ' || vAssunto);
        End;   
      End If;
  end if;
  
  -- TDVADM.TG_AIU_INSEREVFRETE
  if updating or inserting then
      if ( :new.CON_VALEFRETE_PLACA != 'LFK7778' ) and 
         ( :new.glb_rota_codigo not in ('461','999') )   then
      
        IF inserting THEN
          -- SE ESSA COLUNA ESTIVER SENDO GRAVADA COMO NULO
          -- SERA BLOQUEADA - GILES 17/06/2004
        
          BEGIN
            SELECT A.CAR_PROPRIETARIO_CGCCPFCODIGO,
                   P.CAR_PROPRIETARIO_RAZAOSOCIAL
              INTO sProprietario, sProprietarioNome
              FROM T_CAR_VEICULO A, T_CAR_PROPRIETARIO P
             WHERE A.CAR_VEICULO_PLACA = :OLD.CON_VALEFRETE_PLACA
               AND A.CAR_VEICULO_SAQUE = :OLD.CON_VALEFRETE_PLACASAQUE
               AND A.CAR_PROPRIETARIO_CGCCPFCODIGO = P.CAR_PROPRIETARIO_CGCCPFCODIGO;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              sProprietarioNome := NULL;
          END;
        
         IF (INSTR(sProprietarioNome, 'LEASING'     ) <> 0 OR
             INSTR(sProprietarioNome, 'BANCO'       ) <> 0 OR
             INSTR(sProprietarioNome, 'BCO'         ) <> 0 OR
             INSTR(sProprietarioNome, 'PANAMERICANO') <> 0 OR
             INSTR(sProprietarioNome, 'MERCANTIL'   ) <> 0 OR
             INSTR(sProprietarioNome, 'ALIENANTE'   ) <> 0 OR
             INSTR(sProprietarioNome, 'ALIENADO'    ) <> 0 OR
             INSTR(sProprietarioNome, 'ARRENDANTE'  ) <> 0 OR
             INSTR(sProprietarioNome, 'UNIBANCO'    ) <> 0 OR
             INSTR(sProprietarioNome, 'BRADESCO'    ) <> 0 OR
             INSTR(sProprietarioNome, 'ITAU'        ) <> 0 OR
             INSTR(sProprietarioNome, 'HSBC'        ) <> 0 OR
             INSTR(sProprietarioNome, 'SANTANDER'   ) <> 0 OR
             INSTR(sProprietarioNome, 'REAL'        ) <> 0 OR
             INSTR(sProprietarioNome, 'BRASIL'      ) <> 0 OR
             INSTR(sProprietarioNome, 'ALIENAC?O'   ) <> 0 OR
             INSTR(sProprietarioNome, 'ALIENACAO'   ) <> 0 OR
             INSTR(sProprietarioNome, 'BANK'        ) <> 0 OR
             INSTR(sProprietarioNome, 'BV'          ) <> 0 OR
             INSTR(sProprietarioNome, 'PAULISTA'    ) <> 0 OR
             INSTR(sProprietarioNome, 'ARRENDATARIO') <> 0 OR
             INSTR(sProprietarioNome, 'ARRENDATARIO') <> 0) THEN
             RAISE_APPLICATION_ERROR(-20010, 'Não e possivel inserir VALE DE FRETE VERIFIQUE O NOME DO PROPRIETARIO.');
          END IF;
        
          sp_car_bloqueios(:new.CON_VALEFRETE_PLACA,:new.GLB_TPMOTORISTA_CODIGO,trunc(sysdate),null,null,'9999999999',v_bloqueios,v_alertas);
        
          if ( (v_bloqueios > 0) and ( Trim(:new.CON_VALEFRETE_PLACA) <> 'BXH1344' ) ) then
            raise_application_error(-20011,
                                    'Veiculo/Proprietario/Motorista com Bloqueio, Consulte Ficha Carreteiro Placa - ' ||
                                    :new.CON_VALEFRETE_PLACA || '-' ||
                                    :new.GLB_TPMOTORISTA_CODIGO|| '-' ||
                                    to_char(v_bloqueios) || ' Bloqueios');
          end if;
        
          IF (NVL(:NEW.USU_USUARIO_CODIGO, 'NAOTEM') = 'NAOTEM')  THEN
            RAISE_APPLICATION_ERROR(-20012,'APLICACAO DESATIVADA, falta usuario, USE VALE DE FRETE NOVO OU LIGUE PARA ADMINISTRACAO SP ');
          END IF;

          IF (NVL(:NEW.CON_CATVALEFRETE_CODIGO, '00') = '00') THEN
            RAISE_APPLICATION_ERROR(-20012,'APLICACAO DESATIVADA, falta categoria, USE VALE DE FRETE NOVO OU LIGUE PARA ADMINISTRACAO SP');
          END IF;
          
            IF SUBSTR(:new.con_valefrete_placa, 1, 3) <> '000' THEN
              BEGIN
                select e.frt_conjveiculo_codigo
                  into vt_veiculo_codigo
                  from t_frt_veiculo v, 
                       t_frt_conteng e,
                       T_FRT_MARMODVEIC MM,
                       T_FRT_TPVEICULO TV
                 where v.frt_veiculo_placa = :new.con_valefrete_placa
                   and e.frt_veiculo_codigo = v.frt_veiculo_codigo
                   and e.frt_conteng_datadesengate is null
                   AND v.FRT_VEICULO_DATAVENDA is null
                   AND V.FRT_MARMODVEIC_CODIGO = MM.FRT_MARMODVEIC_CODIGO
                   AND MM.FRT_TPVEICULO_CODIGO = TV.FRT_TPVEICULO_CODIGO
                   AND TV.FRT_TPVEICULO_TRACAO = 'S';
               EXCEPTION
                WHEN OTHERS THEN
                  vt_veiculo_codigo := 'SIRLANO';
              END;
              
               UPDATE T_FRT_VEICULO V
               SET V.FRT_STATUS_CODIGO = '04',
                   V.GLB_ROTA_CODIGOPARADO = NULL
               WHERE V.FRT_VEICULO_CODIGO IN (SELECT CE.FRT_VEICULO_CODIGO
                                              FROM T_FRT_CONTENG CE
                                              WHERE CE.FRT_CONJVEICULO_CODIGO = :new.frt_conjveiculo_codigo);

                 
            ELSE
              vt_veiculo_codigo := :new.con_valefrete_placa;
            END IF;
            IF NVL(vt_veiculo_codigo, 'SIRLANO') <> 'SIRLANO' THEN
            
              v_origem  := :new.con_valefrete_localcarreg;
              v_Destino := :new.con_valefrete_localdescarga;
            
              CONTINUA := FALSE;
            
              BEGIN
                SELECT T.USU_USUARIO_CODIGO
                  INTO v_UsuarioVF
                  FROM T_CON_VALEFRETE T
                 WHERE T.CON_CONHECIMENTO_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
                   AND T.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO
                   AND ROWNUM = 1;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_UsuarioVF := 'filial';
                WHEN OTHERS THEN
                  v_UsuarioVF := 'filial';
              END;
            
              --ATUALIZA CONSULTA MESA DE OPERACAO
              IF :NEW.CON_CATVALEFRETE_CODIGO = '10' THEN
                TPDOC    := '4';
                CONTINUA := TRUE;
              ELSIF :NEW.CON_CATVALEFRETE_CODIGO IN ('01', '02') THEN
                TPDOC    := '1';
                CONTINUA := TRUE;
              END IF;
            
              IF CONTINUA = TRUE THEN
                BEGIN
                  SELECT M.FRT_MOVVEIC_DATA DATA_INIC,
                         M.FRT_MOVVEIC_DTPREV DATA_PREVISAO,
                         TRUNC(SYSDATE) - (TO_DATE(M.FRT_MOVVEIC_DATA, 'dd/MM/yyyy') + 1) TOTAL_DIAS_INS
                    INTO DATA_INIC, DATA_PREVISAO, TOTAL_DIAS_INS
                    FROM T_FRT_MOVVEIC M
                   WHERE M.FRT_CONJVEICULO_CODIGO = vt_veiculo_codigo
                     AND M.FRT_STATUS_CODIGO = '2'
                     AND M.FRT_MOVVEIC_DTPREV IS NOT NULL;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    DATA_PREVISAO := NULL;
                END;
              
                CONTADOR   := 1;
                DATA_MOVTO := TO_DATE(DATA_INIC, 'dd/MM/yyyy') + 1;
              
                UPDATE T_FRT_MOVVEIC
                   SET FRT_MOVVEIC_DTPREV = NULL
                 WHERE FRT_CONJVEICULO_CODIGO = vt_veiculo_codigo
                   AND FRT_STATUS_CODIGO = '2'
                   AND FRT_MOVVEIC_DTPREV IS NOT NULL;
              
                WHILE CONTADOR <= TOTAL_DIAS_INS LOOP
                  INSERT INTO T_FRT_MOVVEIC
                    (FRT_CONJVEICULO_CODIGO,
                     FRT_MOVVEIC_DATA,
                     FRT_MOVVEIC_HORA,
                     FRT_STATUS_CODIGO,
                     USU_USUARIO_CODIGO,
                     FRT_MOVVEIC_DTGRAVACAO,
                     FRT_MOVVEIC_DTPREV,
                     GLB_ROTA_CODIGO,
                     FRT_MOVVEIC_OBS)
                  VALUES
                    (vt_veiculo_codigo,
                     DATA_MOVTO,
                     TO_CHAR(CONTADOR),
                     TRIM(TPDOC),
                     v_UsuarioVF,
                     SYSDATE,
                     NULL,
                     :NEW.GLB_ROTA_CODIGO,
                     'VAZIO PROGRAMADO C/ INICIO NO DIA: ' || DATA_INIC ||
                     ' ATE O DIA: ' || DATA_PREVISAO);
                
                  CONTADOR   := CONTADOR + 1;
                  DATA_MOVTO := TO_DATE(DATA_MOVTO, 'dd/MM/yyyy') + 1;
                END LOOP;
              
                INSERT INTO T_FRT_MOVVEIC
                  (FRT_CONJVEICULO_CODIGO,
                   FRT_MOVVEIC_DATA,
                   FRT_MOVVEIC_HORA,
                   FRT_STATUS_CODIGO,
                   USU_USUARIO_CODIGO,
                   FRT_MOVVEIC_DTGRAVACAO,
                   FRT_MOVVEIC_DTPREV,
                   GLB_ROTA_CODIGO,
                   FRT_MOVVEIC_OBS)
                VALUES
                  (vt_veiculo_codigo,
                   TRUNC(SYSDATE),
                   TO_CHAR(SYSDATE, 'HH24:SS'),
                   TRIM(TPDOC),
                   v_UsuarioVF,
                   SYSDATE,
                   NULL,
                   :NEW.GLB_ROTA_CODIGO,
                   'CTRC/VF N? : ' || :NEW.CON_CONHECIMENTO_CODIGO || ' - ' ||
                   :NEW.GLB_ROTA_CODIGO || ' - ' || :NEW.CON_CONHECIMENTO_SERIE ||
                   CHR(10) || 'PERCURSO: ' || trim(v_origem) || ' X ' ||
                   trim(v_Destino));
              
              END IF;
            
            
              INSERT INTO t_frt_movfrota
                (frt_conjveiculo_codigo,
                 glb_rota_codigodoc,
                 frt_movfrota_dthrsaida,
                 frt_movfrota_km,
                 frt_status_codigo,
                 frt_movfrota_doc,
                 frt_movfrota_serie,
                 glb_localidade_codigoorigem,
                 glb_localidade_codigodestino)
              VALUES
                (vt_veiculo_codigo,
                 :new.glb_rota_codigo,
                 TO_DATE(TO_CHAR(:new.con_valefrete_datacadastro, 'DD/MM/YYYY') || ' ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                         'DD/MM/YYYY HH24:MI:SS'),
                 :new.con_valefrete_kmprevista,
                 'V',
                 :new.con_conhecimento_codigo,
                 :new.con_conhecimento_serie,
                 :new.con_valefrete_localcarreg,
                 :new.con_valefrete_localdescarga);
            
            END IF;
        END IF;
      
      end if;
  end if;

  -- TDVADM.TG_AU_ATU_CONHECIMENTO_WEB
  if updating('CON_VALEFRETE_IMPRESSO')     or
     updating('CON_VALEFRETE_DATAPRAZOMAX') then

      /********************************************/
      /*******KLAYTON EM 10/07/2012****************/
      /********************************************/
      
      IF ((:NEW.CON_VALEFRETE_IMPRESSO <> :OLD.CON_VALEFRETE_IMPRESSO) OR 
          (:NEW.CON_VALEFRETE_DATAPRAZOMAX <> :OLD.CON_VALEFRETE_DATAPRAZOMAX)) THEN 
         
      
      IF (:NEW.CON_VALEFRETE_IMPRESSO = 'S') THEN
        FOR CTRC IN (SELECT V.CON_CONHECIMENTO_CODIGO COD,
                            V.CON_CONHECIMENTO_SERIE  SR,
                            V.GLB_ROTA_CODIGO         ROTA
                       FROM T_CON_VFRETECONHEC V
                      WHERE V.CON_VALEFRETE_CODIGO =
                            :NEW.CON_CONHECIMENTO_CODIGO
                        AND V.CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
                        AND V.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO
                        AND V.CON_VALEFRETE_SAQUE = :NEW.CON_VALEFRETE_SAQUE) LOOP
          UPDATE COLETA.T_WEB_CONHECIMENTO W
             SET W.WEB_CONHECIMENTO_PLACA = :NEW.CON_VALEFRETE_PLACA,
                 W.WEB_CONHECIMENTO_PRAZO = :NEW.CON_VALEFRETE_DATAPRAZOMAX
           WHERE W.WEB_CONHECIMENTO_CODIGO = CTRC.COD
             AND W.WEB_CONHECIMENTO_SERIE = CTRC.SR
             AND W.WEB_CONHECIMENTO_ROTA = CTRC.ROTA;
        END LOOP;
      END IF;

      -- calcula os prazos para as notas CIF da Vale

      begin
      SELECT R.GLB_ROTA_COLETA
        INTO V_ROTAVALE
        FROM T_GLB_ROTA R
       WHERE R.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
      exception when others then
                   raise_application_error(-20001,'flavia');
      end ;  
      IF V_ROTAVALE = 'S' THEN
      
        FOR CTRC IN (SELECT V.CON_CONHECIMENTO_CODIGO       COD,
                            V.CON_CONHECIMENTO_SERIE        SR,
                            V.GLB_ROTA_CODIGO               ROTA,
                            R.GLB_LOCALIDADE_CODIGO         ORIGEM,
                            C.CON_CONHECIMENTO_LOCALENTREGA DESTINO
                       FROM T_CON_VFRETECONHEC V,
                            T_CON_CONHECIMENTO C,
                            T_GLB_ROTA         R
                      WHERE V.CON_VALEFRETE_CODIGO =
                            :NEW.CON_CONHECIMENTO_CODIGO
                        AND V.CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
                        AND V.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO
                        AND V.CON_VALEFRETE_SAQUE = :NEW.CON_VALEFRETE_SAQUE
                        AND V.CON_VFRETECONHEC_DTENTREGA IS NULL
                        AND V.CON_CONHECIMENTO_CODIGO =
                            C.CON_CONHECIMENTO_CODIGO
                        AND V.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
                        AND V.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
                        AND V.GLB_ROTA_CODIGOVALEFRETE = R.GLB_ROTA_CODIGO) LOOP
        
          BEGIN
           -- begin
            SELECT MAX(V.CON_VFRETECONHEC_DTENTREGA)
              INTO V_DATAENTREGA
              FROM T_CON_VFRETECONHEC V, T_CON_CONHECIMENTO C, T_GLB_ROTA R
             WHERE V.CON_VALEFRETE_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
               AND V.CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
               AND V.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO
               AND V.CON_VALEFRETE_SAQUE = :NEW.CON_VALEFRETE_SAQUE
               AND R.GLB_LOCALIDADE_CODIGO = CTRC.ORIGEM
               AND C.CON_CONHECIMENTO_LOCALENTREGA = CTRC.DESTINO
               AND V.CON_VFRETECONHEC_DTENTREGA IS NOT NULL
               AND V.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
               AND V.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
               AND V.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
               AND V.GLB_ROTA_CODIGOVALEFRETE = R.GLB_ROTA_CODIGO;
           EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
           end;              --raise_application_error(-20001,'flavia');
            IF V_DATAENTREGA IS NULL THEN
            begin
              SELECT max(V.CON_VFRETECONHEC_DTENTREGA)
                INTO V_DATAENTREGA
                FROM T_CON_VFRETECONHEC V
               WHERE V.CON_VALEFRETE_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
                 AND V.CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
                 AND V.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO
                 AND V.CON_VALEFRETE_SAQUE = :NEW.CON_VALEFRETE_SAQUE
                 AND V.CON_VFRETECONHEC_DTENTREGA IS NOT NULL;
           EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
           end;
           END IF;        
          --END;

          IF V_DATAENTREGA IS NULL THEN
             V_DATAENTREGA := :NEW.CON_VALEFRETE_DATAPRAZOMAX;
          END IF;


          IF V_DATAENTREGA IS NOT NULL THEN
            UPDATE T_CON_VFRETECONHEC V
               SET V.CON_VFRETECONHEC_DTENTREGA = V_DATAENTREGA
             WHERE V.CON_VALEFRETE_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
               AND V.CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
               AND V.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO
               AND V.CON_VALEFRETE_SAQUE = :NEW.CON_VALEFRETE_SAQUE
               AND V.CON_CONHECIMENTO_CODIGO = CTRC.COD
               AND V.CON_CONHECIMENTO_SERIE = CTRC.SR
               AND V.GLB_ROTA_CODIGO = CTRC.ROTA
               AND V.CON_VFRETECONHEC_DTENTREGA IS NULL ;
          END IF;
        END LOOP;
      
      END IF;
      
      END IF;

  end if;
  
  -- TDVADM.TG_AUD_ATUALIZA_VEICULODISP
  if updating or deleting then

      IF DELETING THEN
        vVeiculoDispNumero := :OLD.FCF_VEICULODISP_CODIGO;
        vVeiculoDispSeq    := :OLD.FCF_VEICULODISP_SEQUENCIA;

        If (nvl(vVeiculoDispNumero,'nullo') <> 'nullo') and (nvl(vVeiculoDispSeq,'nullo') <> 'nullo') then

          update t_fcf_veiculodisp disp
             set disp.fcf_veiculodisp_flagvalefrete = null
           where disp.fcf_veiculodisp_codigo        = vVeiculoDispNumero
             and disp.fcf_veiculodisp_sequencia     = vVeiculoDispSeq;

          update t_arm_carregamento ca
             set ca.arm_carregamento_dtfinalizacao = null
           where ca.fcf_veiculodisp_codigo        = vVeiculoDispNumero
             and ca.fcf_veiculodisp_sequencia     = vVeiculoDispSeq;

        else

          UPDATE T_FCF_VEICULODISP DISP
             SET DISP.FCF_VEICULODISP_FLAGVALEFRETE = NULL
           WHERE DISP.FCF_VEICULODISP_CODIGO        = (SELECT VD.FCF_VEICULODISP_CODIGO
                                                         FROM T_ARM_CARREGAMENTO CAR,
                                                              T_CON_CONHECIMENTO CO,
                                                              T_FCF_VEICULODISP  VD
                                                        WHERE
                                                          /*    VALEFRETE                            CONHECIMENTO*/
                                                              :OLD.CON_CONHECIMENTO_CODIGO  = CO.CON_CONHECIMENTO_CODIGO
                                                          AND :OLD.CON_CONHECIMENTO_SERIE   = CO.CON_CONHECIMENTO_SERIE
                                                          AND :OLD.GLB_ROTA_CODIGO          = CO.GLB_ROTA_CODIGO
                                                          /*    CARREGAMENTO                         CONHECIMENTO*/
                                                          AND CAR.ARM_CARREGAMENTO_CODIGO   = CO.ARM_CARREGAMENTO_CODIGO
                                                          /*    CARREGAMENTO                         VEICULO*/
                                                          AND CAR.FCF_VEICULODISP_CODIGO    = VD.FCF_VEICULODISP_CODIGO
                                                          AND CAR.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
                                                          AND ROWNUM = 1)

             AND DISP.FCF_VEICULODISP_SEQUENCIA = (SELECT VD.FCF_VEICULODISP_SEQUENCIA
                                                     FROM T_ARM_CARREGAMENTO CAR,
                                                          T_CON_CONHECIMENTO CO,
                                                          T_FCF_VEICULODISP  VD
                                                    WHERE
                                                      /*    VALEFRETE                            CONHECIMENTO*/
                                                          :OLD.CON_CONHECIMENTO_CODIGO  = CO.CON_CONHECIMENTO_CODIGO
                                                      AND :OLD.CON_CONHECIMENTO_SERIE   = CO.CON_CONHECIMENTO_SERIE
                                                      AND :OLD.GLB_ROTA_CODIGO          = CO.GLB_ROTA_CODIGO
                                                      /*    CARREGAMENTO                         CONHECIMENTO*/
                                                      AND CAR.ARM_CARREGAMENTO_CODIGO   = CO.ARM_CARREGAMENTO_CODIGO
                                                      /*    CARREGAMENTO                         VEICULO*/
                                                      AND CAR.FCF_VEICULODISP_CODIGO    = VD.FCF_VEICULODISP_CODIGO
                                                      AND CAR.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
                                                      AND ROWNUM                        = 1);

          UPDATE T_ARM_CARREGAMENTO CA
             SET CA.ARM_CARREGAMENTO_DTFINALIZACAO = NULL
           WHERE CA.FCF_VEICULODISP_CODIGO         = (SELECT VD.FCF_VEICULODISP_CODIGO
                                                        FROM T_ARM_CARREGAMENTO CAR,
                                                             T_CON_CONHECIMENTO CO,
                                                             T_FCF_VEICULODISP  VD
                                                       WHERE
                                                        /*    VALEFRETE                            CONHECIMENTO*/
                                                            :OLD.CON_CONHECIMENTO_CODIGO  = CO.CON_CONHECIMENTO_CODIGO
                                                        AND :OLD.CON_CONHECIMENTO_SERIE   = CO.CON_CONHECIMENTO_SERIE
                                                        AND :OLD.GLB_ROTA_CODIGO          = CO.GLB_ROTA_CODIGO
                                                        /*    CARREGAMENTO                         CONHECIMENTO*/
                                                        AND CAR.ARM_CARREGAMENTO_CODIGO   = CO.ARM_CARREGAMENTO_CODIGO
                                                        /*    CARREGAMENTO                         VEICULO*/
                                                        AND CAR.FCF_VEICULODISP_CODIGO    = VD.FCF_VEICULODISP_CODIGO
                                                        AND CAR.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
                                                        AND ROWNUM                        = 1);

        end if;

    ELSE

       IF ( :NEW.CON_VALEFRETE_IMPRESSO = 'S' ) AND ( NVL(:OLD.CON_VALEFRETE_IMPRESSO,'N') = 'N' ) THEN

          UPDATE t_fcf_veiculodisp vd
             SET vd.fcf_veiculodisp_flagvalefrete = 'S'
           where vd.fcf_veiculodisp_flagvalefrete is null
             and vd.fcf_ocorrencia_codigo         is null
             AND vd.car_veiculo_placa             = :NEW.CON_VALEFRETE_PLACA
             and vd.car_veiculo_saque             = :NEW.CON_VALEFRETE_PLACASAQUE
             and 0 < (select count(*)
                        from t_con_vfreteconhec vfc,
                             t_con_conhecimento cc
                       where vfc.con_valefrete_codigo     = :NEW.CON_CONHECIMENTO_CODIGO
                         and vfc.con_valefrete_serie      = :NEW.CON_CONHECIMENTO_SERIE
                         and vfc.glb_rota_codigovalefrete = :NEW.GLB_ROTA_CODIGO
                         and vfc.con_valefrete_saque      = :NEW.CON_VALEFRETE_SAQUE
                         AND vfc.con_conhecimento_codigo  = cc.con_conhecimento_codigo
                         and vfc.con_conhecimento_serie   = cc.con_conhecimento_serie
                         and vfc.glb_rota_codigo          = cc.glb_rota_codigo
                         and cc.arm_carregamento_codigo   = vd.arm_carregamento_codigo);

       ELSIF ( :NEW.CON_VALEFRETE_STATUS = 'C' ) AND ( NVL(:OLD.CON_VALEFRETE_STATUS,'N') = 'N' ) THEN

          vVeiculoDispNumero := :OLD.FCF_VEICULODISP_CODIGO;
          vVeiculoDispSeq    := :OLD.FCF_VEICULODISP_SEQUENCIA;

          If (nvl(vVeiculoDispNumero,'nullo') <> 'nullo') and (nvl(vVeiculoDispSeq,'nullo') <> 'nullo') then

            update t_fcf_veiculodisp disp
               set disp.fcf_veiculodisp_flagvalefrete = null
             where disp.fcf_veiculodisp_codigo        = vVeiculoDispNumero
               and disp.fcf_veiculodisp_sequencia     = vVeiculoDispSeq;

            update t_arm_carregamento ca
               set ca.arm_carregamento_dtfinalizacao = null
             where ca.fcf_veiculodisp_codigo        = vVeiculoDispNumero
               and ca.fcf_veiculodisp_sequencia     = vVeiculoDispSeq;

          else

            UPDATE T_FCF_VEICULODISP DISP
               SET DISP.FCF_VEICULODISP_FLAGVALEFRETE = NULL
             WHERE DISP.FCF_VEICULODISP_CODIGO = (SELECT VD.FCF_VEICULODISP_CODIGO
                                                    FROM T_ARM_CARREGAMENTO CAR,
                                                         T_CON_CONHECIMENTO CO,
                                                         T_FCF_VEICULODISP  VD
                                                   WHERE
                                                     /*    VALEFRETE                            CONHECIMENTO*/
                                                         :OLD.CON_CONHECIMENTO_CODIGO  = CO.CON_CONHECIMENTO_CODIGO
                                                     AND :OLD.CON_CONHECIMENTO_SERIE   = CO.CON_CONHECIMENTO_SERIE
                                                     AND :OLD.GLB_ROTA_CODIGO          = CO.GLB_ROTA_CODIGO
                                                     /*    CARREGAMENTO                         CONHECIMENTO*/
                                                     AND CAR.ARM_CARREGAMENTO_CODIGO   = CO.ARM_CARREGAMENTO_CODIGO
                                                     /*    CARREGAMENTO                         VEICULO*/
                                                     AND CAR.FCF_VEICULODISP_CODIGO    = VD.FCF_VEICULODISP_CODIGO
                                                     AND CAR.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
                                                     AND ROWNUM                        = 1)
               AND DISP.FCF_VEICULODISP_SEQUENCIA =   (SELECT VD.FCF_VEICULODISP_SEQUENCIA
                                                         FROM T_ARM_CARREGAMENTO CAR,
                                                              T_CON_CONHECIMENTO CO,
                                                              T_FCF_VEICULODISP  VD
                                                        WHERE
                                                          /*    VALEFRETE                            CONHECIMENTO*/
                                                              :OLD.CON_CONHECIMENTO_CODIGO  = CO.CON_CONHECIMENTO_CODIGO
                                                         AND :OLD.CON_CONHECIMENTO_SERIE   = CO.CON_CONHECIMENTO_SERIE
                                                          AND :OLD.GLB_ROTA_CODIGO          = CO.GLB_ROTA_CODIGO
                                                          /*    CARREGAMENTO                         CONHECIMENTO*/
                                                          AND CAR.ARM_CARREGAMENTO_CODIGO   = CO.ARM_CARREGAMENTO_CODIGO
                                                          /*    CARREGAMENTO                         VEICULO*/
                                                          AND CAR.FCF_VEICULODISP_CODIGO    = VD.FCF_VEICULODISP_CODIGO
                                                          AND CAR.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
                                                          AND ROWNUM = 1);

            UPDATE T_ARM_CARREGAMENTO CA
               SET CA.ARM_CARREGAMENTO_DTFINALIZACAO = NULL
             WHERE CA.FCF_VEICULODISP_CODIGO = (SELECT VD.FCF_VEICULODISP_CODIGO
                                                  FROM T_ARM_CARREGAMENTO CAR,
                                                       T_CON_CONHECIMENTO CO,
                                                       T_FCF_VEICULODISP  VD
                                                 WHERE
                                                   /*  VALEFRETE                            CONHECIMENTO*/
                                                       :OLD.CON_CONHECIMENTO_CODIGO  = CO.CON_CONHECIMENTO_CODIGO
                                                   AND :OLD.CON_CONHECIMENTO_SERIE   = CO.CON_CONHECIMENTO_SERIE
                                                   AND :OLD.GLB_ROTA_CODIGO          = CO.GLB_ROTA_CODIGO
                                                   /*  CARREGAMENTO                         CONHECIMENTO*/
                                                   AND CAR.ARM_CARREGAMENTO_CODIGO   = CO.ARM_CARREGAMENTO_CODIGO
                                                   /*  CARREGAMENTO                         VEICULO*/
                                                   AND CAR.FCF_VEICULODISP_CODIGO    = VD.FCF_VEICULODISP_CODIGO
                                                   AND CAR.FCF_VEICULODISP_SEQUENCIA = VD.FCF_VEICULODISP_SEQUENCIA
                                                   AND ROWNUM                        = 1);

          end if;

       END IF;

    END IF;
  end if;
  
  -- TDVADM.TG_AU_C_ACOMPANHAMENTO_VIAGENS
       
   IF (:NEW.CON_CATVALEFRETE_CODIGO IN ('01','02','11','12')) 
        AND (:NEW.CON_VALEFRETE_SAQUE = '1') 
        AND (:OLD.CON_VALEFRETE_IMPRESSO IS NULL) AND (:NEW.CON_VALEFRETE_IMPRESSO = 'S') THEN             
        BEGIN
          IF SUBSTR(:NEW.CON_VALEFRETE_PLACA,1,3) = '000' THEN
              SELECT TRIM(pkg_frtcar_veiculo.FN_GET_PLACA(TRIM(:NEW.CON_VALEFRETE_PLACA)))
                INTO V_PLACA
                FROM DUAL;
           ELSE
              V_PLACA := TRIM(:NEW.CON_VALEFRETE_PLACA);
           END IF;
                    
           SELECT T.ATR_TERMINAL_MCT,
                  T1.ATR_MARCAMODELO_DESCRICAO
             INTO V_TERMINAL,
                  V_MARCATERMINAL
             FROM T_ATR_TERMINAL T,
                  T_ATR_MARCAMODELO T1
            WHERE T.ATR_MARCAMODELO_CODIGO = T1.ATR_MARCAMODELO_CODIGO(+)
              AND T.ATR_TERMINAL_PLACA = TRIM(V_PLACA)
              AND T.ATR_TERMINAL_ATIVO = 'S'
              AND T.ATR_TERMINAL_STATUS = 'S'
              AND ROWNUM = 1;
           
           EXCEPTION 
              WHEN NO_DATA_FOUND THEN
                  V_TERMINAL := 0;
                  V_MARCATERMINAL := 'MARCA/MODELO N?O ENCONTRADA';
        END;        
                              
        BEGIN
           SELECT A.GLB_LOCALIDADE_DESCRICAO || ' / ' || A.GLB_ESTADO_CODIGO,
                  B.GLB_LOCALIDADE_DESCRICAO || ' / ' || B.GLB_ESTADO_CODIGO
             INTO V_ORIGEM,
                  V_DESTINO
             FROM T_GLB_LOCALIDADE A,
                  T_GLB_LOCALIDADE B
            WHERE A.GLB_LOCALIDADE_CODIGO = :NEW.GLB_LOCALIDADE_CODIGOORI
              AND B.GLB_LOCALIDADE_CODIGO = :NEW.GLB_LOCALIDADE_CODIGODES;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 V_ORIGEM:=  'A LOCALIDADE INFORMADA N?O FOI ENCONTRADA';
                 V_DESTINO:= 'A LOCALIDADE INFORMADA N?O FOI ENCONTRADA';
              WHEN OTHERS THEN
                 V_ORIGEM:=  'A LOCALIDADE INFORMADA N?O FOI ENCONTRADA';
                 V_DESTINO:= 'A LOCALIDADE INFORMADA N?O FOI ENCONTRADA';               
        END;       
        
        BEGIN
           SELECT SLF_PERCURSO_KM 
             INTO V_KMPERCURSO
             FROM T_SLF_PERCURSO
            WHERE GLB_LOCALIDADE_CODIGOORIGEM = TRIM(:NEW.GLB_LOCALIDADE_CODIGOORI)
              AND GLB_LOCALIDADE_CODIGODESTINO = TRIM(:NEW.GLB_LOCALIDADE_CODIGODES);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               V_KMPERCURSO := 1;
            WHEN OTHERS THEN
               V_KMPERCURSO := 1;     
        END;
        
        BEGIN
           SELECT GLB_ROTA_CODIGO || ' - ' || GLB_ROTA_DESCRICAO
             INTO V_DESC_ROTA
             FROM T_GLB_ROTA
            WHERE GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 V_DESC_ROTA := 'A ROTA INFORMADA NAO FOI ENCONTRADA';
              WHEN OTHERS THEN
                 V_DESC_ROTA := 'A ROTA INFORMADA NAO FOI ENCONTRADA';
        END;
        
        IF SUBSTR(:NEW.CON_VALEFRETE_PLACA,1,3) <> '000' THEN
        BEGIN
           SELECT A.FRT_VEICULO_CODIGO
             INTO V_CONJUNTO
             FROM T_FRT_VEICULO A
            WHERE A.FRT_VEICULO_PLACA = :NEW.CON_VALEFRETE_PLACA
              AND A.FRT_VEICULO_DATAVENDA IS NULL
              AND ROWNUM = 1;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                V_CONJUNTO := :NEW.CON_VALEFRETE_PLACA;
             WHEN OTHERS THEN
                V_CONJUNTO := :NEW.CON_VALEFRETE_PLACA;   
        END;
        
        ELSE
           V_CONJUNTO := :NEW.CON_VALEFRETE_PLACA;   
        
        END IF;
        
        BEGIN
           SELECT USU_USUARIO_NOME
             INTO V_USUARIO
             FROM T_USU_USUARIO
            WHERE USU_USUARIO_CODIGO = :NEW.USU_USUARIO_CODIGO
              AND ROWNUM = 1;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 V_USUARIO := 'USUARIO NAO ENCONTRADO';
              WHEN OTHERS THEN
                 V_USUARIO := 'USUARIO NAO ENCONTRADO';
        END;
        
        BEGIN
           SELECT a.terminal,
                a.os_user
           INTO V_MAQUINA,
                V_USUARIO_MAQUINA
           FROM v_glb_ambiente a;
        END;
        
        BEGIN
           SELECT FN_NOME_MOTORISTA(:NEW.CON_VALEFRETE_PLACA)   
             INTO V_MOTORISTA
             FROM DUAL;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 V_MOTORISTA := 'MOTORISTA NAO ENCONTRADO';
              WHEN OTHERS THEN
                 V_MOTORISTA := 'MOTORISTA NAO ENCONTRADO';          
        END;
        
        V_KM := NVL(:NEW.CON_VALEFRETE_KMPREVISTA,1);

       Begin 
        IF V_KM <= 1 THEN
           V_KM := NVL(V_KMPERCURSO,1);
        END IF;
                    
        V_DIAS := NVL(trunc(:NEW.CON_VALEFRETE_DATAPRAZOMAX),'01/01/1901') - NVL(Trunc(:NEW.CON_VALEFRETE_DATACADASTRO),'01/01/1901');
           
        IF V_DIAS < 1 THEN
           V_DIAS := 1;
        END IF;
           
        V_KMMIN := V_KM / V_DIAS;
                 
      Exception
        When Others Then
          V_KMMIN := V_KM;
          
          Insert Into tdvadm.t_grd_audit
            SELECT SUBSTR(A.terminal, 1, 50),
                SUBSTR(A.session_user, 1, 50),
                't_con_valefrete',
                'AUDITORIA ROGERIO',
                '"TG_ACOMPANHAMENTO_VIAGENS" '||CHR(13)||' Nao consegui dividir a Kilometragem pela quantidade de dias entre a data de cadastro e data máxima de entrega.',
                'Variáveis utilizadas = Prazo Maximo: ' ||NVL(trunc(:NEW.CON_VALEFRETE_DATAPRAZOMAX),'01/01/1901') ||
                                       'Data Cadastro: '|| NVL(Trunc(:NEW.CON_VALEFRETE_DATACADASTRO),'01/01/1901') ||
                                       'Kilometragem: ' || V_KM,  
                SYSDATE,
                SUBSTR(A.terminal, 1, 20),
                SUBSTR(A.os_user, 1, 50),
                SUBSTR(A.PROGRAM, 1, 50)
         FROM V_GLB_AMBIENTE A; 
          
        End;
        
        IF V_TERMINAL > 0 THEN
        
        SP_ENVIAMAIL ('SEQUENCIAL',
                      'grp.rastreamento@dellavolpe.com.br',
                      'Inicio de Viagem: '|| V_CONJUNTO ||' Data: ' || TO_CHAR(SYSDATE,'DD/MM/YYYY - HH24:MI:SS'),
                      'Vale Frete: '  || CHR(10) ||
                      '     Data:   ' || :NEW.CON_VALEFRETE_DATAEMISSAO || CHR(10) ||
                      '     Numero: ' || :NEW.CON_CONHECIMENTO_CODIGO || CHR(10) ||
                    '     Filial Emitente: ' || V_DESC_ROTA || CHR(10) ||
                      '     Emissor: ' || V_USUARIO || CHR(10) ||
                    'Percurso:       ' || CHR(10) || 
                      '     Rota: ' || TRIM(V_ORIGEM) || '  X  ' || TRIM(V_DESTINO) || CHR(10) ||
                      '     Km do Percurso: ' || V_KM || CHR(10) ||
                      '     Data Maxima de Entrega: ' || NVL(:NEW.CON_VALEFRETE_DATAPRAZOMAX,'01/01/1901') || CHR(10) ||
                      '     Km Minimo a ser rodado por DIA: ' || ROUND(V_KMMIN) || CHR(10) ||
                      '     Remetente: ' || :NEW.CON_VALEFRETE_LOCALCARREG || CHR(10) || 
                      '     Destinatario: ' || :NEW.CON_VALEFRETE_LOCALDESCARGA || CHR(10) ||
                    'Veiculo/Motorista: ' || CHR(10) ||
                      '     Veiculo:   ' || V_CONJUNTO  || CHR(10) ||
                      '     Motorista: ' || V_MOTORISTA || CHR(10) ||
                      '     Terminal:  ' || V_TERMINAL || ' - ' || TRIM(V_MARCATERMINAL) || CHR(10) ||
                      'Obervac?es: ' || :NEW.CON_VALEFRETE_OBRIGACOES || CHR(10) || 
                      ' ' || CHR(10) ||
                  'Data.........................: ' || TO_CHAR(SYSDATE,'DD/MM/YYYY - HH24:MI:SS') || CHR(10) ||
                  'Maquina Utilizada............: ' || V_MAQUINA || CHR(10) ||
                  'Usuario Logado na Maquina....: ' || V_USUARIO_MAQUINA || CHR(10) ||
                  ' ' || CHR(10) ||
                    '',
                      '0',
                      'S',
                      'tdv.operacao@dellavolpe.com.br',
                      'Envio Automatico',                     
                      '1',
                      SYSDATE,
                      '1',
                      SYSDATE,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      'T',
                      'A',
                      NULL,
                      'S',
                      'N');
     END IF;     
     
    
     
     END IF;
     
     -- JERONIMO - 15/02/2007
     -- SOLICITAC?O DO CHAVES
   IF (:NEW.CON_CATVALEFRETE_CODIGO NOT IN ('13','14')) 
        AND (:NEW.CON_VALEFRETE_SAQUE > '1') 
        AND (:NEW.CON_VALEFRETE_IMPRESSO = 'S') THEN

          IF SUBSTR(:NEW.CON_VALEFRETE_PLACA,1,3) = '000' THEN
              SELECT TRIM(pkg_frtcar_veiculo.FN_GET_PLACA(TRIM(:NEW.CON_VALEFRETE_PLACA)))
                INTO V_PLACA
                FROM DUAL;
           ELSE
              V_PLACA := TRIM(:NEW.CON_VALEFRETE_PLACA);
           END IF;
                    
           begin
             SELECT T.ATR_TERMINAL_MCT,
                    T1.ATR_MARCAMODELO_DESCRICAO
               INTO V_TERMINAL,
                    V_MARCATERMINAL
               FROM T_ATR_TERMINAL T,
                    T_ATR_MARCAMODELO T1
              WHERE T.ATR_MARCAMODELO_CODIGO = T1.ATR_MARCAMODELO_CODIGO(+)
                AND T.ATR_TERMINAL_PLACA = TRIM(V_PLACA)
                AND T.ATR_TERMINAL_ATIVO = 'S'
                AND T.ATR_TERMINAL_STATUS = 'S'
                AND ROWNUM = 1;
           Exception when others then
              V_TERMINAL  := 0;
              V_MARCATERMINAL := '';
           end;
/*           begin                   
             SELECT A.GLB_LOCALIDADE_DESCRICAO || ' / ' || A.GLB_ESTADO_CODIGO,
                    B.GLB_LOCALIDADE_DESCRICAO || ' / ' || B.GLB_ESTADO_CODIGO
               INTO V_ORIGEM,
                    V_DESTINO
               FROM T_GLB_LOCALIDADE A,
                    T_GLB_LOCALIDADE B
              WHERE A.GLB_LOCALIDADE_CODIGO = :NEW.GLB_LOCALIDADE_CODIGOORI
                AND B.GLB_LOCALIDADE_CODIGO = :NEW.GLB_LOCALIDADE_CODIGODES;
            Exception when others then
              V_ORIGEM  := '';
              V_DESTINO := '';
            end;
*/        
            begin
             SELECT SLF_PERCURSO_KM 
               INTO V_KMPERCURSO
               FROM T_SLF_PERCURSO
              WHERE GLB_LOCALIDADE_CODIGOORIGEM = TRIM(:NEW.GLB_LOCALIDADE_CODIGOORI)
                AND GLB_LOCALIDADE_CODIGODESTINO = TRIM(:NEW.GLB_LOCALIDADE_CODIGODES);
            Exception when others then
              V_KMPERCURSO  := '';
            end;

        Begin        
         SELECT GLB_ROTA_CODIGO || ' - ' || GLB_ROTA_DESCRICAO
           INTO V_DESC_ROTA
           FROM T_GLB_ROTA
          WHERE GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        end;
        IF SUBSTR(:NEW.CON_VALEFRETE_PLACA,1,3) <> '000' THEN
         Begin
           SELECT A.FRT_VEICULO_CODIGO
             INTO V_CONJUNTO
             FROM T_FRT_VEICULO A
            WHERE A.FRT_VEICULO_PLACA = :NEW.CON_VALEFRETE_PLACA
              AND A.FRT_VEICULO_DATAVENDA IS NULL
              AND ROWNUM = 1;        
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          end;
        END IF;
       
       Begin 
         SELECT USU_USUARIO_NOME
           INTO V_USUARIO
           FROM T_USU_USUARIO
          WHERE USU_USUARIO_CODIGO = :NEW.USU_USUARIO_CODIGO
            AND ROWNUM = 1;
       EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
       end;
        
        BEGIN
           SELECT a.terminal,
                a.os_user
           INTO V_MAQUINA,
                V_USUARIO_MAQUINA
           FROM v_glb_ambiente a;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        END;

         SELECT FN_NOME_MOTORISTA(:NEW.CON_VALEFRETE_PLACA)   
           INTO V_MOTORISTA
           FROM DUAL;
        Begin
          SELECT C.CON_CATVALEFRETE_DESCRICAO
            INTO V_CATEGORIA
            FROM T_CON_CATVALEFRETE C
           WHERE C.CON_CATVALEFRETE_CODIGO = :NEW.CON_CATVALEFRETE_CODIGO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        End;
     END IF;
       
  if inserting Then
      TPVALEFRETEHIST.CON_CONHECIMENTO_CODIGO        := :NEW.CON_CONHECIMENTO_CODIGO;
      TPVALEFRETEHIST.CON_CONHECIMENTO_SERIE         := :NEW.CON_CONHECIMENTO_SERIE;
      TPVALEFRETEHIST.CON_VIAGEM_NUMERO              := :NEW.CON_VIAGEM_NUMERO;
      TPVALEFRETEHIST.GLB_ROTA_CODIGO                := :NEW.GLB_ROTA_CODIGO;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOVIAGEM          := :NEW.GLB_ROTA_CODIGOVIAGEM;
      TPVALEFRETEHIST.CON_VALEFRETE_SAQUE            := :NEW.CON_VALEFRETE_SAQUE;
      TPVALEFRETEHIST.CON_VALEFRETE_CONHECIMENTOS    := :NEW.CON_VALEFRETE_CONHECIMENTOS;
      TPVALEFRETEHIST.CON_VALEFRETE_CARRETEIRO       := :NEW.CON_VALEFRETE_CARRETEIRO;
      TPVALEFRETEHIST.CON_VALEFRETE_NFS              := :NEW.CON_VALEFRETE_NFS;
      TPVALEFRETEHIST.CON_VALEFRETE_PLACASAQUE       := :NEW.CON_VALEFRETE_PLACASAQUE;
      TPVALEFRETEHIST.CON_VALEFRETE_TIPOTRANSPORTE   := :NEW.CON_VALEFRETE_TIPOTRANSPORTE;
      TPVALEFRETEHIST.CON_VALEFRETE_PLACA            := :NEW.CON_VALEFRETE_PLACA;
      TPVALEFRETEHIST.CON_VALEFRETE_LOCALCARREG      := :NEW.CON_VALEFRETE_LOCALCARREG;
      TPVALEFRETEHIST.CON_VALEFRETE_LOCALDESCARGA    := :NEW.CON_VALEFRETE_LOCALDESCARGA;
      TPVALEFRETEHIST.CON_VALEFRETE_KMPREVISTA       := :NEW.CON_VALEFRETE_KMPREVISTA;
      TPVALEFRETEHIST.CON_VALEFRETE_PESOINDICADO     := :NEW.CON_VALEFRETE_PESOINDICADO;
      TPVALEFRETEHIST.CON_VALEFRETE_PESOCOBRADO      := :NEW.CON_VALEFRETE_PESOCOBRADO;
      TPVALEFRETEHIST.CON_VALEFRETE_ENTREGAS         := :NEW.CON_VALEFRETE_ENTREGAS;
      TPVALEFRETEHIST.CON_VALEFRETE_CUSTOCARRETEIRO  := :NEW.CON_VALEFRETE_CUSTOCARRETEIRO;
      TPVALEFRETEHIST.CON_VALEFRETE_TIPOCUSTO        := :NEW.CON_VALEFRETE_TIPOCUSTO;
      TPVALEFRETEHIST.CON_VALEFRETE_PRAZOCONTR       := :NEW.CON_VALEFRETE_PRAZOCONTR;
      TPVALEFRETEHIST.CON_VALEFRETE_OBRIGACOES       := :NEW.CON_VALEFRETE_OBRIGACOES;
      TPVALEFRETEHIST.CON_VALEFRETE_DATAPRAZOMAX     := :NEW.CON_VALEFRETE_DATAPRAZOMAX;
      TPVALEFRETEHIST.CON_VALEFRETE_HORAPRAZOMAX     := :NEW.CON_VALEFRETE_HORAPRAZOMAX;
      TPVALEFRETEHIST.CON_VALEFRETE_PERCMULTA        := :NEW.CON_VALEFRETE_PERCMULTA;
      TPVALEFRETEHIST.CON_VALEFRETE_CONDESPECIAIS    := :NEW.CON_VALEFRETE_CONDESPECIAIS;
      TPVALEFRETEHIST.CON_VALEFRETE_DATACADASTRO     := :NEW.CON_VALEFRETE_DATACADASTRO;
      TPVALEFRETEHIST.CON_VALEFRETE_EMISSOR          := :NEW.CON_VALEFRETE_EMISSOR;
      TPVALEFRETEHIST.CON_VALEFRETE_DATACHEGADA      := :NEW.CON_VALEFRETE_DATACHEGADA;
      TPVALEFRETEHIST.CON_VALEFRETE_CAIXA            := :NEW.CON_VALEFRETE_CAIXA;
      TPVALEFRETEHIST.CON_VALEFRETE_HORACHEGADA      := :NEW.CON_VALEFRETE_HORACHEGADA;
      TPVALEFRETEHIST.CON_VALEFRETE_FRETE            := :NEW.CON_VALEFRETE_FRETE;
      TPVALEFRETEHIST.CON_VALEFRETE_REEMBOLSO        := :NEW.CON_VALEFRETE_REEMBOLSO;
      TPVALEFRETEHIST.CON_VALEFRETE_ADIANTAMENTO     := :NEW.CON_VALEFRETE_ADIANTAMENTO;
      TPVALEFRETEHIST.CON_VALEFRETE_MULTA            := :NEW.CON_VALEFRETE_MULTA;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORLIQUIDO     := :NEW.CON_VALEFRETE_VALORLIQUIDO;
      TPVALEFRETEHIST.CON_VALEFRETE_DATAPAGTO        := :NEW.CON_VALEFRETE_DATAPAGTO;
      TPVALEFRETEHIST.CON_VALEFRETE_BERCONF          := :NEW.CON_VALEFRETE_BERCONF;
      TPVALEFRETEHIST.CON_VALEFRETE_BERCOQTDE        := :NEW.CON_VALEFRETE_BERCOQTDE;
      TPVALEFRETEHIST.CON_VALEFRETE_BERCOQTDEPINO    := :NEW.CON_VALEFRETE_BERCOQTDEPINO;
      TPVALEFRETEHIST.CON_VALEFRETE_POSTORAZAOSOCIAL := :NEW.CON_VALEFRETE_POSTORAZAOSOCIAL;
      TPVALEFRETEHIST.CON_VALEFRETE_COMPROVANTE      := :NEW.CON_VALEFRETE_COMPROVANTE;
      TPVALEFRETEHIST.CON_VALEFRETE_STATUS           := :NEW.CON_VALEFRETE_STATUS;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGO          := :NEW.GLB_LOCALIDADE_CODIGO;
      TPVALEFRETEHIST.CON_VALEFRETE_OBSCAIXA         := :NEW.CON_VALEFRETE_OBSCAIXA;
      TPVALEFRETEHIST.CON_VALEFRETE_IRRF             := :NEW.CON_VALEFRETE_IRRF;
      TPVALEFRETEHIST.POS_CADASTRO_CGC               := :NEW.POS_CADASTRO_CGC;
      TPVALEFRETEHIST.CON_VALEFRETE_PEDAGIO          := :NEW.CON_VALEFRETE_PEDAGIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGODES       := :NEW.GLB_LOCALIDADE_CODIGODES;
      TPVALEFRETEHIST.ACC_ACONTAS_NUMERO             := :NEW.ACC_ACONTAS_NUMERO;
      TPVALEFRETEHIST.ACC_CONTAS_CICLO               := :NEW.ACC_CONTAS_CICLO;
      TPVALEFRETEHIST.CON_VALEFRETE_DATARECEBIMENTO  := :NEW.CON_VALEFRETE_DATARECEBIMENTO;
      TPVALEFRETEHIST.ACC_ACONTAS_TPDOC              := :NEW.ACC_ACONTAS_TPDOC;
      TPVALEFRETEHIST.CON_VALEFRETE_DATAEMISSAO      := :NEW.CON_VALEFRETE_DATAEMISSAO;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORESTIVA      := :NEW.CON_VALEFRETE_VALORESTIVA;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORVAZIO       := :NEW.CON_VALEFRETE_VALORVAZIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_ORIGEMVAZIO     := :NEW.GLB_LOCALIDADE_ORIGEMVAZIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_DESTINOVAZIO    := :NEW.GLB_LOCALIDADE_DESTINOVAZIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGOORI       := :NEW.GLB_LOCALIDADE_CODIGOORI;
      TPVALEFRETEHIST.CAX_BOLETIM_DATA               := :NEW.CAX_BOLETIM_DATA;
      TPVALEFRETEHIST.CAX_MOVIMENTO_SEQUENCIA        := :NEW.CAX_MOVIMENTO_SEQUENCIA;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOCX              := :NEW.GLB_ROTA_CODIGOCX;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORRATEIO      := :NEW.CON_VALEFRETE_VALORRATEIO;
      TPVALEFRETEHIST.CON_VALEFRETE_LOTACAO          := :NEW.CON_VALEFRETE_LOTACAO;
      TPVALEFRETEHIST.CON_VALEFRETE_IMPRESSO         := :NEW.CON_VALEFRETE_IMPRESSO;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORCOMDESCONTO := :NEW.CON_VALEFRETE_VALORCOMDESCONTO;
      TPVALEFRETEHIST.CON_CATVALEFRETE_CODIGO        := :NEW.CON_CATVALEFRETE_CODIGO;
      TPVALEFRETEHIST.GLB_TPMOTORISTA_CODIGO         := :NEW.GLB_TPMOTORISTA_CODIGO;
      TPVALEFRETEHIST.CON_VALEFRETE_ENLONAMENTO      := :NEW.CON_VALEFRETE_ENLONAMENTO;
      TPVALEFRETEHIST.CON_VALEFRETE_ESTADIA          := :NEW.CON_VALEFRETE_ESTADIA;
      TPVALEFRETEHIST.CON_VALEFRETE_OUTROS           := :NEW.CON_VALEFRETE_OUTROS;
      TPVALEFRETEHIST.FRT_CONJVEICULO_CODIGO         := :NEW.FRT_CONJVEICULO_CODIGO;
      TPVALEFRETEHIST.FRT_MOVVAZIO_NUMERO            := :NEW.FRT_MOVVAZIO_NUMERO;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOVAZIO           := :NEW.GLB_ROTA_CODIGOVAZIO;
      TPVALEFRETEHIST.USU_USUARIO_CODIGO             := :NEW.USU_USUARIO_CODIGO;
      TPVALEFRETEHIST.USU_USUARIO_CODIGOVALIDADOR    := :NEW.USU_USUARIO_CODIGOVALIDADOR;
      TPVALEFRETEHIST.CON_VALEFRETE_PGVPEDAGIO       := :NEW.CON_VALEFRETE_PGVPEDAGIO;
      TPVALEFRETEHIST.CON_VALEFRETE_INSS             := :NEW.CON_VALEFRETE_INSS;
      TPVALEFRETEHIST.CON_VALEFRETE_COFINS           := :NEW.CON_VALEFRETE_COFINS;
      TPVALEFRETEHIST.CON_VALEFRETE_CSLL             := :NEW.CON_VALEFRETE_CSLL;
      TPVALEFRETEHIST.CON_VALEFRETE_PIS              := :NEW.CON_VALEFRETE_PIS;
      TPVALEFRETEHIST.CON_VALEFRETE_AVARIA           := :NEW.CON_VALEFRETE_AVARIA;
      TPVALEFRETEHIST.USU_USUARIO_CODIGO_AUTORIZA    := :NEW.USU_USUARIO_CODIGO_AUTORIZA;
      TPVALEFRETEHIST.CON_VALEFRETE_DTAUTORIZA       := :NEW.CON_VALEFRETE_DTAUTORIZA;
      TPVALEFRETEHIST.CON_VALEFRETE_DTCHEGCELULA     := :NEW.CON_VALEFRETE_DTCHEGCELULA;
      TPVALEFRETEHIST.CON_VALEFRETE_SESTSENAT        := :NEW.CON_VALEFRETE_SESTSENAT;
      TPVALEFRETEHIST.CON_VALEFRETE_ADTANTERIOR      := :NEW.CON_VALEFRETE_ADTANTERIOR;
      TPVALEFRETEHIST.CON_CONHECIMENTO_CODIGOCH      := :NEW.CON_CONHECIMENTO_CODIGOCH;
      TPVALEFRETEHIST.CON_CONHECIMENTO_SERIECH       := :NEW.CON_CONHECIMENTO_SERIECH;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOCH              := :NEW.GLB_ROTA_CODIGOCH;
      TPVALEFRETEHIST.CON_VALEFRETE_SAQUECH          := :NEW.CON_VALEFRETE_SAQUECH;
      TPVALEFRETEHIST.CON_VALEFRETEDET_SEQ           := :NEW.CON_VALEFRETEDET_SEQ;
      TPVALEFRETEHIST.USU_USUARIO_CODALTERACAO       := :NEW.USU_USUARIO_CODALTERACAO;
      TPVALEFRETEHIST.CON_VALEFRETE_PEDPGCLI         := :NEW.CON_VALEFRETE_PEDPGCLI;
      TPVALEFRETEHIST.CON_VALEFRETE_DEP              := :NEW.CON_VALEFRETE_DEP;
      TPVALEFRETEHIST.CON_VALEFRETE_DTCHECKIN        := :NEW.CON_VALEFRETE_DTCHECKIN;
      TPVALEFRETEHIST.CON_VALEFRETE_DTGRAVCHECKIN    := :NEW.CON_VALEFRETE_DTGRAVCHECKIN;
      TPVALEFRETEHIST.CON_VALEFRETE_DTHORAIMPRESSAO  := :NEW.CON_VALEFRETE_DTHORAIMPRESSAO;
      TPVALEFRETEHIST.CON_VALEFRETE_FIFO             := :NEW.CON_VALEFRETE_FIFO;
      TPVALEFRETEHIST.CON_VALEFRETE_DESCBONUS        := :NEW.CON_VALEFRETE_DESCBONUS;
      TPVALEFRETEHIST.CON_VALEFRETE_OBS              := :NEW.CON_VALEFRETE_OBS;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOAPRESENT        := :NEW.GLB_ROTA_CODIGOAPRESENT;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOAPRESENTOLD     := :NEW.GLB_ROTA_CODIGOAPRESENTOLD;
      TPVALEFRETEHIST.USU_USUARIO_CODIGORTAPRESENT   := :NEW.USU_USUARIO_CODIGORTAPRESENT;
      TPVALEFRETEHIST.CON_VALEFRETE_PERCETDES        := :NEW.CON_VALEFRETE_PERCETDES;
      TPVALEFRETEHIST.CON_SUBCATVALEFRETE_CODIGO     := :NEW.CON_SUBCATVALEFRETE_CODIGO;
      TPVALEFRETEHIST.FCF_FRETECAR_ROWID             := :NEW.FCF_FRETECAR_ROWID;
      TPVALEFRETEHIST.FCF_VEICULODISP_CODIGO         := :NEW.FCF_VEICULODISP_CODIGO;
      TPVALEFRETEHIST.FCF_VEICULODISP_SEQUENCIA      := :NEW.FCF_VEICULODISP_SEQUENCIA;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGOPASSPOR   := :NEW.GLB_LOCALIDADE_CODIGOPASSPOR;
      TPVALEFRETEHIST.GLB_CLIENTE_CGCCPFCODIGO       := :NEW.GLB_CLIENTE_CGCCPFCODIGO;
      TPVALEFRETEHIST.CON_VALEFRETE_DIARIOBORDO      := :NEW.CON_VALEFRETE_DIARIOBORDO;
      TPVALEFRETEHIST.CON_VALEFRETE_FRETEORIGINAL    := :NEW.CON_VALEFRETE_FRETEORIGINAL;
      TPVALEFRETEHIST.CON_VALEFRETE_PEDAGIOORIGINAL  := :NEW.CON_VALEFRETE_PEDAGIOORIGINAL;  
      TPVALEFRETEHIST.CON_VALEFRETE_QTDEREIMP        := :NEW.CON_VALEFRETE_QTDEREIMP;
      TPVALEFRETEHIST.CON_VALEFRETE_FORCATARIFA      := :NEW.CON_VALEFRETE_FORCATARIFA;
      TPVALEFRETEHIST.CON_VALEFRETE_OPTSIMPLES       := :NEW.CON_VALEFRETE_OPTSIMPLES;
      TPVALEFRETEHIST.CON_VALEFRETE_DOCREF           := :NEW.CON_VALEFRETE_DOCREF;
  Else
      TPVALEFRETEHIST.CON_CONHECIMENTO_CODIGO        := :OLD.CON_CONHECIMENTO_CODIGO;
      TPVALEFRETEHIST.CON_CONHECIMENTO_SERIE         := :OLD.CON_CONHECIMENTO_SERIE;
      TPVALEFRETEHIST.CON_VIAGEM_NUMERO              := :OLD.CON_VIAGEM_NUMERO;
      TPVALEFRETEHIST.GLB_ROTA_CODIGO                := :OLD.GLB_ROTA_CODIGO;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOVIAGEM          := :OLD.GLB_ROTA_CODIGOVIAGEM;
      TPVALEFRETEHIST.CON_VALEFRETE_SAQUE            := :OLD.CON_VALEFRETE_SAQUE;
      TPVALEFRETEHIST.CON_VALEFRETE_CONHECIMENTOS    := :OLD.CON_VALEFRETE_CONHECIMENTOS;
      TPVALEFRETEHIST.CON_VALEFRETE_CARRETEIRO       := :OLD.CON_VALEFRETE_CARRETEIRO;
      TPVALEFRETEHIST.CON_VALEFRETE_NFS              := :OLD.CON_VALEFRETE_NFS;
      TPVALEFRETEHIST.CON_VALEFRETE_PLACASAQUE       := :OLD.CON_VALEFRETE_PLACASAQUE;
      TPVALEFRETEHIST.CON_VALEFRETE_TIPOTRANSPORTE   := :OLD.CON_VALEFRETE_TIPOTRANSPORTE;
      TPVALEFRETEHIST.CON_VALEFRETE_PLACA            := :OLD.CON_VALEFRETE_PLACA;
      TPVALEFRETEHIST.CON_VALEFRETE_LOCALCARREG      := :OLD.CON_VALEFRETE_LOCALCARREG;
      TPVALEFRETEHIST.CON_VALEFRETE_LOCALDESCARGA    := :OLD.CON_VALEFRETE_LOCALDESCARGA;
      TPVALEFRETEHIST.CON_VALEFRETE_KMPREVISTA       := :OLD.CON_VALEFRETE_KMPREVISTA;
      TPVALEFRETEHIST.CON_VALEFRETE_PESOINDICADO     := :OLD.CON_VALEFRETE_PESOINDICADO;
      TPVALEFRETEHIST.CON_VALEFRETE_PESOCOBRADO      := :OLD.CON_VALEFRETE_PESOCOBRADO;
      TPVALEFRETEHIST.CON_VALEFRETE_ENTREGAS         := :OLD.CON_VALEFRETE_ENTREGAS;
      TPVALEFRETEHIST.CON_VALEFRETE_CUSTOCARRETEIRO  := :OLD.CON_VALEFRETE_CUSTOCARRETEIRO;
      TPVALEFRETEHIST.CON_VALEFRETE_TIPOCUSTO        := :OLD.CON_VALEFRETE_TIPOCUSTO;
      TPVALEFRETEHIST.CON_VALEFRETE_PRAZOCONTR       := :OLD.CON_VALEFRETE_PRAZOCONTR;
      TPVALEFRETEHIST.CON_VALEFRETE_OBRIGACOES       := :OLD.CON_VALEFRETE_OBRIGACOES;
      TPVALEFRETEHIST.CON_VALEFRETE_DATAPRAZOMAX     := :OLD.CON_VALEFRETE_DATAPRAZOMAX;
      TPVALEFRETEHIST.CON_VALEFRETE_HORAPRAZOMAX     := :OLD.CON_VALEFRETE_HORAPRAZOMAX;
      TPVALEFRETEHIST.CON_VALEFRETE_PERCMULTA        := :OLD.CON_VALEFRETE_PERCMULTA;
      TPVALEFRETEHIST.CON_VALEFRETE_CONDESPECIAIS    := :OLD.CON_VALEFRETE_CONDESPECIAIS;
      TPVALEFRETEHIST.CON_VALEFRETE_DATACADASTRO     := :OLD.CON_VALEFRETE_DATACADASTRO;
      TPVALEFRETEHIST.CON_VALEFRETE_EMISSOR          := :OLD.CON_VALEFRETE_EMISSOR;
      TPVALEFRETEHIST.CON_VALEFRETE_DATACHEGADA      := :OLD.CON_VALEFRETE_DATACHEGADA;
      TPVALEFRETEHIST.CON_VALEFRETE_CAIXA            := :OLD.CON_VALEFRETE_CAIXA;
      TPVALEFRETEHIST.CON_VALEFRETE_HORACHEGADA      := :OLD.CON_VALEFRETE_HORACHEGADA;
      TPVALEFRETEHIST.CON_VALEFRETE_FRETE            := :OLD.CON_VALEFRETE_FRETE;
      TPVALEFRETEHIST.CON_VALEFRETE_REEMBOLSO        := :OLD.CON_VALEFRETE_REEMBOLSO;
      TPVALEFRETEHIST.CON_VALEFRETE_ADIANTAMENTO     := :OLD.CON_VALEFRETE_ADIANTAMENTO;
      TPVALEFRETEHIST.CON_VALEFRETE_MULTA            := :OLD.CON_VALEFRETE_MULTA;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORLIQUIDO     := :OLD.CON_VALEFRETE_VALORLIQUIDO;
      TPVALEFRETEHIST.CON_VALEFRETE_DATAPAGTO        := :OLD.CON_VALEFRETE_DATAPAGTO;
      TPVALEFRETEHIST.CON_VALEFRETE_BERCONF          := :OLD.CON_VALEFRETE_BERCONF;
      TPVALEFRETEHIST.CON_VALEFRETE_BERCOQTDE        := :OLD.CON_VALEFRETE_BERCOQTDE;
      TPVALEFRETEHIST.CON_VALEFRETE_BERCOQTDEPINO    := :OLD.CON_VALEFRETE_BERCOQTDEPINO;
      TPVALEFRETEHIST.CON_VALEFRETE_POSTORAZAOSOCIAL := :OLD.CON_VALEFRETE_POSTORAZAOSOCIAL;
      TPVALEFRETEHIST.CON_VALEFRETE_COMPROVANTE      := :OLD.CON_VALEFRETE_COMPROVANTE;
      TPVALEFRETEHIST.CON_VALEFRETE_STATUS           := :OLD.CON_VALEFRETE_STATUS;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGO          := :OLD.GLB_LOCALIDADE_CODIGO;
      TPVALEFRETEHIST.CON_VALEFRETE_OBSCAIXA         := :OLD.CON_VALEFRETE_OBSCAIXA;
      TPVALEFRETEHIST.CON_VALEFRETE_IRRF             := :OLD.CON_VALEFRETE_IRRF;
      TPVALEFRETEHIST.POS_CADASTRO_CGC               := :OLD.POS_CADASTRO_CGC;
      TPVALEFRETEHIST.CON_VALEFRETE_PEDAGIO          := :OLD.CON_VALEFRETE_PEDAGIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGODES       := :OLD.GLB_LOCALIDADE_CODIGODES;
      TPVALEFRETEHIST.ACC_ACONTAS_NUMERO             := :OLD.ACC_ACONTAS_NUMERO;
      TPVALEFRETEHIST.ACC_CONTAS_CICLO               := :OLD.ACC_CONTAS_CICLO;
      TPVALEFRETEHIST.CON_VALEFRETE_DATARECEBIMENTO  := :OLD.CON_VALEFRETE_DATARECEBIMENTO;
      TPVALEFRETEHIST.ACC_ACONTAS_TPDOC              := :OLD.ACC_ACONTAS_TPDOC;
      TPVALEFRETEHIST.CON_VALEFRETE_DATAEMISSAO      := :OLD.CON_VALEFRETE_DATAEMISSAO;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORESTIVA      := :OLD.CON_VALEFRETE_VALORESTIVA;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORVAZIO       := :OLD.CON_VALEFRETE_VALORVAZIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_ORIGEMVAZIO     := :OLD.GLB_LOCALIDADE_ORIGEMVAZIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_DESTINOVAZIO    := :OLD.GLB_LOCALIDADE_DESTINOVAZIO;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGOORI       := :OLD.GLB_LOCALIDADE_CODIGOORI;
      TPVALEFRETEHIST.CAX_BOLETIM_DATA               := :OLD.CAX_BOLETIM_DATA;
      TPVALEFRETEHIST.CAX_MOVIMENTO_SEQUENCIA        := :OLD.CAX_MOVIMENTO_SEQUENCIA;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOCX              := :OLD.GLB_ROTA_CODIGOCX;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORRATEIO      := :OLD.CON_VALEFRETE_VALORRATEIO;
      TPVALEFRETEHIST.CON_VALEFRETE_LOTACAO          := :OLD.CON_VALEFRETE_LOTACAO;
      TPVALEFRETEHIST.CON_VALEFRETE_IMPRESSO         := :OLD.CON_VALEFRETE_IMPRESSO;
      TPVALEFRETEHIST.CON_VALEFRETE_VALORCOMDESCONTO := :OLD.CON_VALEFRETE_VALORCOMDESCONTO;
      TPVALEFRETEHIST.CON_CATVALEFRETE_CODIGO        := :OLD.CON_CATVALEFRETE_CODIGO;
      TPVALEFRETEHIST.GLB_TPMOTORISTA_CODIGO         := :OLD.GLB_TPMOTORISTA_CODIGO;
      TPVALEFRETEHIST.CON_VALEFRETE_ENLONAMENTO      := :OLD.CON_VALEFRETE_ENLONAMENTO;
      TPVALEFRETEHIST.CON_VALEFRETE_ESTADIA          := :OLD.CON_VALEFRETE_ESTADIA;
      TPVALEFRETEHIST.CON_VALEFRETE_OUTROS           := :OLD.CON_VALEFRETE_OUTROS;
      TPVALEFRETEHIST.FRT_CONJVEICULO_CODIGO         := :OLD.FRT_CONJVEICULO_CODIGO;
      TPVALEFRETEHIST.FRT_MOVVAZIO_NUMERO            := :OLD.FRT_MOVVAZIO_NUMERO;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOVAZIO           := :OLD.GLB_ROTA_CODIGOVAZIO;
      TPVALEFRETEHIST.USU_USUARIO_CODIGO             := :OLD.USU_USUARIO_CODIGO;
      TPVALEFRETEHIST.USU_USUARIO_CODIGOVALIDADOR    := :OLD.USU_USUARIO_CODIGOVALIDADOR;
      TPVALEFRETEHIST.CON_VALEFRETE_PGVPEDAGIO       := :OLD.CON_VALEFRETE_PGVPEDAGIO;
      TPVALEFRETEHIST.CON_VALEFRETE_INSS             := :OLD.CON_VALEFRETE_INSS;
      TPVALEFRETEHIST.CON_VALEFRETE_COFINS           := :OLD.CON_VALEFRETE_COFINS;
      TPVALEFRETEHIST.CON_VALEFRETE_CSLL             := :OLD.CON_VALEFRETE_CSLL;
      TPVALEFRETEHIST.CON_VALEFRETE_PIS              := :OLD.CON_VALEFRETE_PIS;
      TPVALEFRETEHIST.CON_VALEFRETE_AVARIA           := :OLD.CON_VALEFRETE_AVARIA;
      TPVALEFRETEHIST.USU_USUARIO_CODIGO_AUTORIZA    := :OLD.USU_USUARIO_CODIGO_AUTORIZA;
      TPVALEFRETEHIST.CON_VALEFRETE_DTAUTORIZA       := :OLD.CON_VALEFRETE_DTAUTORIZA;
      TPVALEFRETEHIST.CON_VALEFRETE_DTCHEGCELULA     := :OLD.CON_VALEFRETE_DTCHEGCELULA;
      TPVALEFRETEHIST.CON_VALEFRETE_SESTSENAT        := :OLD.CON_VALEFRETE_SESTSENAT;
      TPVALEFRETEHIST.CON_VALEFRETE_ADTANTERIOR      := :OLD.CON_VALEFRETE_ADTANTERIOR;
      TPVALEFRETEHIST.CON_CONHECIMENTO_CODIGOCH      := :OLD.CON_CONHECIMENTO_CODIGOCH;
      TPVALEFRETEHIST.CON_CONHECIMENTO_SERIECH       := :OLD.CON_CONHECIMENTO_SERIECH;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOCH              := :OLD.GLB_ROTA_CODIGOCH;
      TPVALEFRETEHIST.CON_VALEFRETE_SAQUECH          := :OLD.CON_VALEFRETE_SAQUECH;
      TPVALEFRETEHIST.CON_VALEFRETEDET_SEQ           := :OLD.CON_VALEFRETEDET_SEQ;
      TPVALEFRETEHIST.USU_USUARIO_CODALTERACAO       := :OLD.USU_USUARIO_CODALTERACAO;
      TPVALEFRETEHIST.CON_VALEFRETE_PEDPGCLI         := :OLD.CON_VALEFRETE_PEDPGCLI;
      TPVALEFRETEHIST.CON_VALEFRETE_DEP              := :OLD.CON_VALEFRETE_DEP;
      TPVALEFRETEHIST.CON_VALEFRETE_DTCHECKIN        := :OLD.CON_VALEFRETE_DTCHECKIN;
      TPVALEFRETEHIST.CON_VALEFRETE_DTGRAVCHECKIN    := :OLD.CON_VALEFRETE_DTGRAVCHECKIN;
      TPVALEFRETEHIST.CON_VALEFRETE_DTHORAIMPRESSAO  := :OLD.CON_VALEFRETE_DTHORAIMPRESSAO;
      TPVALEFRETEHIST.CON_VALEFRETE_FIFO             := :OLD.CON_VALEFRETE_FIFO;
      TPVALEFRETEHIST.CON_VALEFRETE_DESCBONUS        := :OLD.CON_VALEFRETE_DESCBONUS;
      TPVALEFRETEHIST.CON_VALEFRETE_OBS              := :OLD.CON_VALEFRETE_OBS;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOAPRESENT        := :OLD.GLB_ROTA_CODIGOAPRESENT;
      TPVALEFRETEHIST.GLB_ROTA_CODIGOAPRESENTOLD     := :OLD.GLB_ROTA_CODIGOAPRESENTOLD;
      TPVALEFRETEHIST.USU_USUARIO_CODIGORTAPRESENT   := :OLD.USU_USUARIO_CODIGORTAPRESENT;
      TPVALEFRETEHIST.CON_VALEFRETE_PERCETDES        := :OLD.CON_VALEFRETE_PERCETDES;
      TPVALEFRETEHIST.CON_SUBCATVALEFRETE_CODIGO     := :OLD.CON_SUBCATVALEFRETE_CODIGO;
      TPVALEFRETEHIST.FCF_FRETECAR_ROWID             := :OLD.FCF_FRETECAR_ROWID;
      TPVALEFRETEHIST.FCF_VEICULODISP_CODIGO         := :OLD.FCF_VEICULODISP_CODIGO;
      TPVALEFRETEHIST.FCF_VEICULODISP_SEQUENCIA      := :OLD.FCF_VEICULODISP_SEQUENCIA;
      TPVALEFRETEHIST.GLB_LOCALIDADE_CODIGOPASSPOR   := :OLD.GLB_LOCALIDADE_CODIGOPASSPOR;
      TPVALEFRETEHIST.GLB_CLIENTE_CGCCPFCODIGO       := :OLD.GLB_CLIENTE_CGCCPFCODIGO;
      TPVALEFRETEHIST.CON_VALEFRETE_DIARIOBORDO      := :OLD.CON_VALEFRETE_DIARIOBORDO;
      TPVALEFRETEHIST.CON_VALEFRETE_FRETEORIGINAL    := :OLD.CON_VALEFRETE_FRETEORIGINAL;
      TPVALEFRETEHIST.CON_VALEFRETE_PEDAGIOORIGINAL  := :OLD.CON_VALEFRETE_PEDAGIOORIGINAL;      
      TPVALEFRETEHIST.CON_VALEFRETE_QTDEREIMP        := :OLD.CON_VALEFRETE_QTDEREIMP;
      TPVALEFRETEHIST.CON_VALEFRETE_FORCATARIFA      := :OLD.CON_VALEFRETE_FORCATARIFA;
      TPVALEFRETEHIST.CON_VALEFRETE_OPTSIMPLES       := :OLD.CON_VALEFRETE_OPTSIMPLES;
      TPVALEFRETEHIST.CON_VALEFRETE_DOCREF           := :OLD.CON_VALEFRETE_DOCREF;
  End If; 

  Begin
     select c.con_vfreteciot_numero
       into vCiot
     From tdvadm.t_con_vfreteciot c
     where c.con_conhecimento_codigo = TPVALEFRETEHIST.CON_CONHECIMENTO_CODIGO  
       and c.con_conhecimento_serie  = TPVALEFRETEHIST.CON_CONHECIMENTO_SERIE
       and c.glb_rota_codigo         = TPVALEFRETEHIST.GLB_ROTA_CODIGO
       and c.con_valefrete_saque     = TPVALEFRETEHIST.Con_Valefrete_Saque;
  Exception
    When OTHERS Then
      vCiot := null;
    End; 

  TPVALEFRETEHIST.ARM_VALEFRETEHIST_CALL_STACK   := trim('CIOT - ' || vCiot || chr(10) || SUBSTR(DBMS_UTILITY.format_call_stack,1,1900));
  TPVALEFRETEHIST.ARM_VALEFRETEHIST_IP           := vIP;
  TPVALEFRETEHIST.ARM_VALEFRETEHIST_COMPUTADOR   := vTerminal;
  TPVALEFRETEHIST.ARM_VALEFRETEHIST_OSUSER       := vOsUser;
  TPVALEFRETEHIST.ARM_VALEFRETEHIST_PROGRAM      := vProgram;
  TPVALEFRETEHIST.ARM_VALEFRETEHIST_GRAVACAO     := SYSDATE;
  INSERT INTO TDVADM.T_CON_VALEFRETEHIST 
    VALUES TPVALEFRETEHIST;      


  
  
  
  
  
  
  

  

END TG_AIUD_VALEFRETE;
/
