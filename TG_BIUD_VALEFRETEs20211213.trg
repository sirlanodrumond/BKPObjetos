CREATE OR REPLACE TRIGGER TG_BIUD_VALEFRETEs
  BEFORE INSERT OR DELETE OR UPDATE ON TDVADM.T_CON_VALEFRETE  
  FOR EACH ROW
DECLARE
 /******************************************************************************
  *   BEGIN: TDVADM.TG_DELETA_T_CON_VFRETECONHEC - BEFORE DELETE               *
  ******************************************************************************/
  vMsg     varchar2(10000);
  V_CONHEC VARCHAR2(8);
  V_SERIE  VARCHAR2(4);
  V_ROTA   CHAR(3);
  vListaparams glbadm.pkg_listas.tlistausuparametros;
  tpVF PKG_CON_VALEFRETE.TpValidaVF;
  vTeste boolean;
  vData  date;
  vRef   char(6);
  vCON_VALEFRETE_DESCBONUS     tdvadm.t_con_valefrete.CON_VALEFRETE_DESCBONUS%type; 
  vCON_VALEFRETE_CONDESPECIAIS tdvadm.t_con_valefrete.CON_VALEFRETE_CONDESPECIAIS%type;
     
  CURSOR C_FRETE IS
    SELECT A.CON_CONHECIMENTO_CODIGO,
           A.CON_CONHECIMENTO_SERIE,
           A.GLB_ROTA_CODIGO
      FROM T_CON_VFRETECONHEC A, T_CON_CALCCONHECIMENTO B
     WHERE A.CON_VALEFRETE_CODIGO = :OLD.CON_CONHECIMENTO_CODIGO
       AND A.CON_VALEFRETE_SERIE = :OLD.CON_CONHECIMENTO_SERIE
       AND A.GLB_ROTA_CODIGOVALEFRETE = :OLD.GLB_ROTA_CODIGO
       AND A.CON_CONHECIMENTO_CODIGO = B.CON_CONHECIMENTO_CODIGO
       AND A.CON_CONHECIMENTO_SERIE = B.CON_CONHECIMENTO_SERIE
       AND A.GLB_ROTA_CODIGO = B.GLB_ROTA_CODIGO
       AND B.CON_CONHECIMENTO_ALTALTMAN IS NULL;

  CURSOR C_VFRETECONHEC IS
    SELECT COUNT(*)
      FROM T_CON_VFRETECONHEC
     WHERE CON_CONHECIMENTO_CODIGO = V_CONHEC
       AND CON_CONHECIMENTO_SERIE = V_SERIE
       AND GLB_ROTA_CODIGO = V_ROTA
       AND CON_VALEFRETE_CODIGO <> :OLD.CON_CONHECIMENTO_CODIGO
       AND CON_VALEFRETE_SERIE <> :OLD.CON_CONHECIMENTO_SERIE
       AND GLB_ROTA_CODIGOVALEFRETE <> :OLD.GLB_ROTA_CODIGO;
  /******************************************************************************
   *   END: TDVADM.TG_DELETA_T_CON_VFRETECONHEC - BEFORE DELETE                 *
   ******************************************************************************/

 /******************************************************************************
  *   BEGIN: TDVADM.TG_DATA_CHECKIN - BEFORE INSERT                            *
  ******************************************************************************/
/*  V_CON_VALEFRETE_DTCHECKIN T_CON_VALEFRETE.CON_VALEFRETE_DTCHECKIN%TYPE;*/
  V_KM  NUMBER;
 /******************************************************************************
  *   END: TDVADM.TG_DATA_CHECKIN - BEFORE INSERT                              *
  ******************************************************************************/  

 /******************************************************************************
  *   BEGIN: TDVADM.TG_TRAVA_CARRETEIRO_CHECKLIST2 - BEFORE INSERT             *
  ******************************************************************************/
   sCpf            T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE;
   sNome           T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_RAZAOSOCIAL%TYPE;   
 /******************************************************************************
  *   END: TDVADM.TG_TRAVA_CARRETEIRO_CHECKLIST2 - BEFORE INSERT               *
  ******************************************************************************/  
  
 /******************************************************************************
  *   BEGIN: TDVADM.TG_TIPOMOTORISTA - BEFORE INSERT E UPDATE                  *
  ******************************************************************************/
  V_PLACA VARCHAR(7);
  V_TIPO CHAR(20);
 /******************************************************************************
  *   END: TDVADM.TG_TIPOMOTORISTA - BEFORE INSERT E UPDATE                    *
  ******************************************************************************/  

 /******************************************************************************
  *   BEGIN: TDVADM.TG_BU_ATUALIZA_IMPOSTOS - BEFORE UPDATE                    *
  ******************************************************************************/
  sProprietario       T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_CGCCPFCODIGO%TYPE;
  sProprietarioNome   T_CAR_PROPRIETARIO.CAR_PROPRIETARIO_RAZAOSOCIAL%TYPE;
  sMAQUINA            VARCHAR2(50);
  sUSUARIO_MAQUINA    VARCHAR2(50);
  nFrete              NUMBER;
  nVlrAcumulado       NUMBER;
  nIR                 NUMBER;
  nSESTSENAT          NUMBER;
  nINSS               NUMBER;
  nQTDVF              NUMBER;
  nIRacumulado        NUMBER;
  nSESTSENATacumulado NUMBER;
  nINSSacumulado      NUMBER;
  nQTDVFacumulado     NUMBER;
 /******************************************************************************
  *   END: TDVADM.TG_BU_ATUALIZA_IMPOSTOS - BEFORE UPDATE                      *
  ******************************************************************************/  

 /******************************************************************************
  *   BEGIN: TDVADM.TG_RATEIACONHEC - BEFORE UPDATE                            *
  ******************************************************************************/
  NVALORRATEIO         NUMBER;
  NVALORRATEIOF        NUMBER;
  NVALORRATEIOP        NUMBER;
  V_NVALORCALCULO      NUMBER;
  V_PEDAGIOFROTA       NUMBER;
  V_PESOCONTRATADO     NUMBER;
  V_VLRDESCONTO        NUMBER;
  V_VALORTOTALCTRC     NUMBER;
  V_PEDAGIOCLI         NUMBER;
  V_BONUS              NUMBER;
  v_valortotalctrccimp NUMBER;
  V_EMITE_BONUS        CHAR(1);
  V_TIPOMOT            CHAR(2);
  v_AgregadoPercDef    NUMBER;
  v_AgregadoPerc       NUMBER;
  v_AgregadoPercCAT    NUMBER;
  v_AgregadoPercPlaca  NUMBER;
  vTemGrupo0020        number;
  vAuxiliar            number;
  
  -- VARIAVEIS PARA PEGAR OS PARAMETROS
  V_PARAMETRO     T_USU_PERFIL.USU_PERFIL_CODIGO%TYPE; 
  V_PARAMTEXTO    T_USU_PERFIL.USU_PERFIL_PARAT%TYPE; 
  v_paramnumber   t_usu_perfil.usu_perfil_paran1%TYPE;
  V_PERC_BONUS    T_USU_PERFIL.USU_PERFIL_PARAT%TYPE; 
 
  -- MONTA O CURSOR PARA PEGAR OS PARAMETROS
  CURSOR C_PARAMETROS IS
    SELECT P.PERFIL, P.TEXTO,p.numerico1
      FROM T_USU_PARAMETROTMP P
     WHERE P.USUARIO = :NEW.USU_USUARIO_CODIGO
       AND P.APLICACAO = 'comvlfrete'
       and P.ROTA = :NEW.GLB_ROTA_CODIGO;
 /******************************************************************************
  *   END: TDVADM.TG_RATEIACONHEC - BEFORE UPDATE                              *
  ******************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BU_ATUALIZA_DTCADASTRO - BEFORE UPDATE                  *
  *****************************************************************************/
  vStrHora CHAR(8);
  /*****************************************************************************
  *   END: TDVADM.TG_BU_ATUALIZA_DTCADASTRO - BEFORE UPDATE                    *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BUC_LIBVEICECARREG - BEFORE UPDATE                      *
  *****************************************************************************/
  V_COD_VEICULO TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE;
  V_SEQUENCIA   TDVADM.T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE;
  /*****************************************************************************
  *   END: TDVADM.TG_BUC_LIBVEICECARREG - BEFORE UPDATE                        *
  *****************************************************************************/

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_CON_VALEFRETE_VPEDAGIO - BEFORE UPDATE                  *
  *****************************************************************************/
  V_FORMAPAGTO_VPED T_CON_CONHECVPED.CON_FPAGTOMOTPED_CODIGO%TYPE;
  V_VALOR_VPED      T_CON_CONHECVPED.CON_CONHECVPED_VALOR%TYPE;
  V_MOTPED_VPED     T_CON_FPAGTOMOTPED.CON_FPAGTOMOTPED_PAGTOVFRETE%TYPE;
  V_COBROCLI_VPED   T_CON_FPAGTOMOTPED.CON_FPAGTOMOTPED_CUSTO%TYPE;
  /*****************************************************************************
  *   END: TDVADM.TG_CON_VALEFRETE_VPEDAGIO - BEFORE UPDATE                    *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_INFORMA_DTRETROATIVA - BEFORE UPDATE                    *
  *****************************************************************************/
   VUSUARIO     VARCHAR(50);
   V_ORIGEM     VARCHAR(80);
   V_DESTINO    VARCHAR(80);
   V_DESC_ROTA  VARCHAR(50);
   V_MOTORISTA  VARCHAR(80);
   V_MAQUINA    VARCHAR(50);
   V_FPREVISTO  NUMBER;
   V_CONJUNTO   CHAR(7);
   V_USUARIO_MAQUINA VARCHAR(50);
   V_EMAIL_USUARIO  VARCHAR2(100);
  /*****************************************************************************
  *   END: TDVADM.TG_INFORMA_DTRETROATIVA - BEFORE UPDATE                      *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_CON_VFRETECANCELCIOT - BEFORE UPDATE                    *
  *****************************************************************************/
  vControl  integer;
  /*****************************************************************************
  *   END: TDVADM.TG_CON_VFRETECANCELCIOT - BEFORE UPDATE                      *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BU_C_ATR_VIAGEM - BEFORE UPDATE                         *
  *****************************************************************************/
   V_TOTAL   NUMBER;
  /*****************************************************************************
  *   END: TDVADM.TG_BU_C_ATR_VIAGEM - BEFORE UPDATE                           *
  *****************************************************************************/  
  
  /*****************************************************************************
  *   BEGIN: TDVADM.TG_CON_VFRETECTB - BEFORE UPDATE OR DELETE                 *
  *****************************************************************************/
  V_ESTOURATRIGGER BOOLEAN;
  V_CURSORID   INTEGER; -- NUMERO INTERO DO CURSOR
  V_FRASESQL   VARCHAR2(200);
  V_TEMPORARIA INTEGER;
  VI_TESTE     CHAR(3);
  VI_TESTE2    CHAR(10);
  vERRO       varchar2(500); 
  ndado1     CHAR(1);
  ndado2     CHAR(1);

  ncoluna     varchar2(3000);
  nTOTAL      NUMBER;

  CURSOR C_COLUNAS IS
    select c.COLUMN_NAME
      from user_tab_columns c
     where c.TABLE_NAME = 'T_CON_VALEFRETE'
     ORDER BY 1;
  /*****************************************************************************
  *   END: TDVADM.TG_CON_VFRETECTB - BEFORE UPDATE OR DELETE                   *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BUD_CARGA_TERCEIRO - BEFORE UPDATE OR DELETE            *
  *****************************************************************************/
   V_USUARIO    VARCHAR(50);
/*   V_CGC_PROPRIETARIO VARCHAR(20);
   V_CAR_CARRETEIRO_SAQUE CHAR(4);
*/   v_acao  CHAR(8); 
  /*****************************************************************************
  *   END: TDVADM.TG_BUD_CARGA_TERCEIRO - BEFORE UPDATE OR DELETE              *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BUD_VERIFICAMDFE - BEFORE UPDATE OR DELETE              *
  *****************************************************************************/
  vStatus       char(1);
  vMessage      varchar2(2000);
  vVeicDispCod  t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
  vVeicDispSeq  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
  /*****************************************************************************
  *   END: TDVADM.TG_BUD_VERIFICAMDFE - BEFORE UPDATE OR DELETE                *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BDU_C_ALTER_VF - BEFORE UPDATE OR DELETE                *
  *****************************************************************************/
  sTipoAlteracao      VARCHAR2(100);
  sContinua           Boolean;
  vContador           Number := 0;
  v_codaltman         number;
  /*****************************************************************************
  *   END: TDVADM.TG_BDU_C_ALTER_VF - BEFORE UPDATE OR DELETE                  *
  *****************************************************************************/  

BEGIN
  vData := :old.con_valefrete_datacadastro; 
  vRef  := to_char(vData,'YYYYMM');
  
  /*******************************************************************************
  *   BEGIN: TDVADM.TG_CON_VFRETECANCELCIOT - BEFORE UPDATE                      *
  *   ALTERADO POR KLAYTON SOUZA EM 26/04/2021                                   *
  *   BLOCO DE VERIFICAC?O FOI COLOCADO PRIMEIRO, POIS NÃO ESTAVA SENDO EXECUTADO*
  *******************************************************************************/
  IF UPDATING('CON_VALEFRETE_STATUS') Then
  /********************************************************************************************************/
  /* Func?o dessa TRIGGER, e impedir que um usuario cancele um Vale de Frete apos ter  solicitado  ciot.  */ 
  /********************************************************************************************************/

    --Inicializa a variavel que ser?o utilizadas nessa trigger
    vControl := 0;
    
    --Verifico se o usuario esta cancelando o Vale de Frete
    if (:new.CON_VALEFRETE_STATUS = 'C') then
      begin
        
        begin
          --verifico se existe um CIOT para o saque do vale de frete
         select count(*) 
           into vControl
           from t_con_vfreteciot ciot
          where 0=0
            and trim(ciot.con_conhecimento_codigo) = trim(:old.con_conhecimento_codigo) 
            and trim(ciot.con_conhecimento_serie)  = trim(:old.con_conhecimento_serie)
            and trim(ciot.glb_rota_codigo)         = trim(:old.glb_rota_codigo)
            and trim(ciot.con_valefrete_saque)     = trim(:old.Con_Valefrete_Saque);
            
        exception
          --caso ocorra algum erro durante o processo de busca de ciot.
          when others then
            raise_application_error(-20001, 'Erro ao tentar localizar Vale de Frete com Ciot');  
        end;
        
        --Caso a variavel de controle seja maior que zero
        if ( Nvl(vControl, 0) > 0) Then
          raise_application_error(-20001, 'VALE DE FRETE NÃO PODE SER CANCELADO' || chr(13)|| 'CANCELE PRIMEIRO O CIOT');
        end if;
      
      exception
        --caso ocorra algum erro durante o processamento da trigger
        when others then
          --Exibe mensagem gerada na tela
          If TDVADM.FN_GET_TPVEICULO(:NEW.CON_VALEFRETE_PLACA,:NEW.CON_VALEFRETE_dataCADASTRO) <> 'UTILITARIO' Then
             raise_application_error(-20001, 'Erro:' || chr(13) || chr(13) || sqlerrm);
          End If;
          return;
      end;
          SELECT COUNT(*) TOTAL
            INTO nTOTAL
            FROM tdvadm.T_CTB_LOGTRANSF L
           WHERE L.CTB_LOGTRANSF_REFERENCIA > vRef
             AND L.CTB_LOGTRANSF_SISTEMA = 'VLF';
             
          If nTOTAL = 0  Then
            -- Mostra que o periodo ja esta fechado
             SELECT count(*) --P.USU_PERFIL_CODIGO,P.USU_PERFIL_PARAT REFERENCIA
                INTO nTOTAL
             FROM T_USU_PERFIL P
             WHERE P.USU_APLICACAO_CODIGO = '0000000000'
               AND TRIM(P.USU_PERFIL_CODIGO) = 'REFFECHAMENTOVFC'          
               and P.USU_PERFIL_PARAT >=  vRef;
          End IF;

          IF (nTOTAL <> 0) or ( V_ESTOURATRIGGER )  THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'ESTE DOCUMENTO ' ||
                                    :old.CON_CONHECIMENTO_CODIGO || ' DA ROTA ' ||
                                    :OLD.GLB_ROTA_CODIGO ||
                                    ' NÃO PODE SER ALTERADO.' || CHR(10) ||
                                    'DEVIDO A CONTABILIDADE REF.: ' ||
                                    TO_CHAR(:OLD.CON_VALEFRETE_DATACADASTRO,
                                            'YYYYMM') ||
                                    ' ESTAR EM FECHAMENTO OU FECHADA' ||
                                    ' erro - ' || TRIM(vERRO) );
    --                                ' Coluna ALTERADA ' || ncoluna);
          END IF;
      

    end if;
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_CON_VFRETECANCELCIOT - BEFORE UPDATE                      *
  *****************************************************************************/  


 /******************************************************************************
  *   BEGIN: TDVADM.TG_DELETA_T_CON_VFRETECONHEC - BEFORE DELETE               *
  ******************************************************************************/
  
  If TDVADM.FN_GET_TPVEICULO(:NEW.CON_VALEFRETE_PLACA,:NEW.CON_VALEFRETE_dataCADASTRO) = 'UTILITARIO'
     and :NEW.GLB_TPMOTORISTA_CODIGO = 'F' Then
     return;
  End If;

  If nvl(:new.con_valefrete_impresso,'N') = 'S' and  ( not UPDATING('CON_VALEFRETE_STATUS')) Then
     Return;
  End If;

  IF DELETING THEN
    FOR R_FRETE IN C_FRETE LOOP
      V_CONHEC := R_FRETE.CON_CONHECIMENTO_CODIGO;
      V_SERIE  := R_FRETE.CON_CONHECIMENTO_SERIE;
      V_ROTA   := R_FRETE.GLB_ROTA_CODIGO;
    
      OPEN C_VFRETECONHEC;
    
      IF C_VFRETECONHEC%ROWCOUNT > 0 THEN
        UPDATE T_CON_VFRETECONHEC
           SET CON_VFRETECONHEC_RECALCULA = 'S'
         WHERE CON_CONHECIMENTO_CODIGO = V_CONHEC
           AND CON_CONHECIMENTO_SERIE = V_SERIE
           AND GLB_ROTA_CODIGO = V_ROTA;
      ELSE
        UPDATE T_CON_CALCCONHECIMENTO
           SET CON_CALCVIAGEM_VALOR = 0
         WHERE CON_CONHECIMENTO_CODIGO = V_CONHEC
           AND CON_CONHECIMENTO_SERIE = V_SERIE
           AND GLB_ROTA_CODIGO = V_ROTA
           AND SLF_RECCUST_CODIGO = 'I_CTCR';
      END IF;
    
      CLOSE C_VFRETECONHEC;
    END LOOP;

    DELETE T_CON_VFRETECONHEC
     WHERE CON_VALEFRETE_CODIGO = :OLD.CON_CONHECIMENTO_CODIGO
       AND CON_VALEFRETE_SERIE = :OLD.CON_CONHECIMENTO_SERIE
       AND GLB_ROTA_CODIGOVALEFRETE = :OLD.GLB_ROTA_CODIGO
       AND CON_VALEFRETE_SAQUE = :OLD.CON_VALEFRETE_SAQUE;

    DELETE T_CON_CALCVALEFRETE VF
     WHERE VF.CON_CONHECIMENTO_CODIGO = :OLD.CON_CONHECIMENTO_CODIGO
       AND VF.CON_CONHECIMENTO_SERIE = :OLD.CON_CONHECIMENTO_SERIE
       AND VF.GLB_ROTA_CODIGO = :OLD.GLB_ROTA_CODIGO
       AND VF.CON_VALEFRETE_SAQUE = :OLD.CON_VALEFRETE_SAQUE;
   END IF;
 /******************************************************************************
  *   END: TDVADM.TG_DELETA_T_CON_VFRETECONHEC - BEFORE DELETE                 *
  ******************************************************************************/

 /******************************************************************************
  *   BEGIN: TDVADM.TG_DATA_CHECKIN - BEFORE INSERT                            *
  ******************************************************************************/
  IF INSERTING THEN
/*     IF (:NEW.CON_CATVALEFRETE_CODIGO = '13') THEN
     
        BEGIN
           SELECT C.CON_CONHECIMENTO_DTCHECKIN
             INTO V_CON_VALEFRETE_DTCHECKIN
             FROM T_CON_CONHECIMENTO C
            WHERE C.CON_CONHECIMENTO_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
              AND C.CON_CONHECIMENTO_SERIE = :NEW.CON_CONHECIMENTO_SERIE
              AND C.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 V_CON_VALEFRETE_DTCHECKIN := NULL;
        END;  
        
     END IF;
*/     
     BEGIN
       SELECT MAX(PE.SLF_PERCURSO_KM)
          INTO V_KM
       FROM T_SLF_PERCURSO PE
       WHERE PE.GLB_LOCALIDADE_CODIGOORIGEM = :NEW.GLB_LOCALIDADE_CODIGOORI
         AND PE.GLB_LOCALIDADE_CODIGODESTINO = :NEW.GLB_LOCALIDADE_CODIGODES;
       EXCEPTION
        WHEN NO_DATA_FOUND THEN  
           V_KM := 50;
        END;         
            
        IF ( :new.con_valefrete_kmprevista <> V_KM ) AND ( V_KM > 50 ) THEN
           :new.con_valefrete_kmprevista := V_KM  ;
        ELSIF NVL(:new.con_valefrete_kmprevista,0) < 50 THEN
          :new.con_valefrete_kmprevista := 50;
        END IF;    
  END IF;
 /******************************************************************************
  *   END: TDVADM.TG_DATA_CHECKIN - BEFORE INSERT                              *
  ******************************************************************************/  
  
 /******************************************************************************
  *   BEGIN: TDVADM.TG_TRAVA_CARRETEIRO_CHECKLIST2 - BEFORE INSERT             *
  ******************************************************************************/
  IF INSERTING THEN 
    IF NVL(:NEW.GLB_TPMOTORISTA_CODIGO,'N ') <> 'F ' THEN
      BEGIN
          SELECT P.CAR_PROPRIETARIO_CGCCPFCODIGO,
                 P.CAR_PROPRIETARIO_RAZAOSOCIAL
            INTO sCpf,
                 sNome
          FROM T_CAR_VEICULO V,
               T_CAR_PROPRIETARIO P
          WHERE V.CAR_VEICULO_PLACA = :NEW.CON_VALEFRETE_PLACA
            AND V.CAR_VEICULO_SAQUE = :NEW.CON_VALEFRETE_PLACASAQUE
            AND V.CAR_PROPRIETARIO_CGCCPFCODIGO = P.CAR_PROPRIETARIO_CGCCPFCODIGO
            AND NVL(SUBSTR(P.CAR_PROPRIETARIO_INPS_CODIGO,LENGTH(TRIM(P.CAR_PROPRIETARIO_INPS_CODIGO)),1),99) <> F_DIGCONTROLEINSS(P.CAR_PROPRIETARIO_INPS_CODIGO)
            AND P.CAR_PROPRIETARIO_TIPOPESSOA = 'F'; 
            RAISE_APPLICATION_ERROR(-20001,'O PROP. : ' || TRIM(sNome) || ' CPF : ' || TRIM(sCpf) || ' NÃO TEM INSS VALIDO, VALE DE FRETE NAO SERA EMITIDO !');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
          null;   
     END;        
    END IF;
  END IF;
 /******************************************************************************
  *   END: TDVADM.TG_TRAVA_CARRETEIRO_CHECKLIST2 - BEFORE INSERT               *
  ******************************************************************************/  

 /******************************************************************************
  *   BEGIN: TDVADM.TG_TIPOMOTORISTA - BEFORE INSERT E UPDATE                  *
  ******************************************************************************/
  IF INSERTING OR UPDATING THEN
    IF :NEW.GLB_TPMOTORISTA_CODIGO IS NULL THEN
      IF SUBSTR(:NEW.CON_VALEFRETE_PLACA,1,3) = '000' THEN
        BEGIN
          SELECT F.FRT_VEICULO_PLACA
            INTO V_PLACA
            FROM T_FRT_VEICULO F,
                 T_FRT_CONTENG E
           WHERE F.FRT_VEICULO_CODIGO = E.FRT_VEICULO_CODIGO
             AND E.FRT_CONJVEICULO_CODIGO = :NEW.CON_VALEFRETE_PLACA
             AND SUBSTR(E.FRT_VEICULO_CODIGO,1,1) = 'C';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_PLACA := :NEW.CON_VALEFRETE_PLACA;
        END;
      ELSE
        V_PLACA := :NEW.CON_VALEFRETE_PLACA;
      END IF;     
      SELECT FN_RETTP_MOTORISTA(F_Retorna_placa(V_PLACA), NULL, :NEW.CON_VALEFRETE_DATAEMISSAO)
        INTO V_TIPO
        FROM DUAL;
      IF (TRIM(V_TIPO) = 'FROTA') or (TRIM(V_TIPO) = 'APOIO') THEN
        :NEW.GLB_TPMOTORISTA_CODIGO := 'F';
      ELSIF TRIM(V_TIPO) = 'AGREGADO' THEN
        :NEW.GLB_TPMOTORISTA_CODIGO := 'A';
      ELSIF TRIM(V_TIPO) = 'CARRET. DEDICADO' THEN
        :NEW.GLB_TPMOTORISTA_CODIGO := 'D';
      ELSE
        :NEW.GLB_TPMOTORISTA_CODIGO := 'C';
      END IF;
    END IF;
    IF (:NEW.CON_CATVALEFRETE_CODIGO = '05') AND (:NEW.CON_VALEFRETE_PEDAGIO IS NULL) THEN
      :NEW.CON_VALEFRETE_PEDAGIO := 0;
    END IF;    
  END IF;   
 /******************************************************************************
  *   END: TDVADM.TG_TIPOMOTORISTA - BEFORE INSERT E UPDATE                    *
  ******************************************************************************/  

 /******************************************************************************
  *   BEGIN: TDVADM.TG_BIU_VALEFRETE - BEFORE INSERT E UPDATE                  *
  ******************************************************************************/
  IF INSERTING OR UPDATING THEN
     :new.con_valefrete_diariobordo := 'N';
    
     IF (NVL(:NEW.USU_USUARIO_CODIGO,'NAOTEM') = 'NAOTEM') AND
        ((:NEW.GLB_ROTA_CODIGO = '033') OR
        (:NEW.GLB_ROTA_CODIGO = '030')) THEN
        :NEW.USU_USUARIO_CODIGO := 'tteste';
     END IF;
    
     IF NVL(:NEW.CON_VALEFRETE_TIPOCUSTO,'X') NOT IN ('T','U') then
        :NEW.CON_VALEFRETE_TIPOCUSTO := 'U';
     End IF;
    
/*     if ( :new.con_valefrete_descbonus = 'S' ) and 
        ( nvl(:new.con_valefrete_freteoriginal,0) = 0 ) and 
        ( nvl(:new.con_valefrete_frete,0) < nvl(:old.con_valefrete_frete,0)  ) 
      Then
         :new.con_valefrete_freteoriginal := nvl(:old.con_valefrete_frete,0) ;
     End If;
*/  
     If nvl(:new.con_valefrete_frete,0) > 0 and nvl(:old.con_valefrete_frete,0) = 0 Then
       IF NVL(:new.con_valefrete_freteoriginal, 0) = 0 Then
          :new.con_valefrete_freteoriginal := :new.con_valefrete_frete;
       End If;
     End If; 
         
     If INSERTING Then
       If glbadm.pkg_listas.fn_get_usuparamtros(tpVF.VFAplicacaoTDV,
                                                  tpVF.VFusuarioTDV,
                                                  tpVF.VFRotaUsuarioTDV,
                                                  vListaparams) Then
         Begin                                             
               If UPPER(nvl(vListaparams('ATUALIZA_PEDAGIO').texto, 'S')) = 'S' Then
                  :new.con_valefrete_pedagiooriginal := 
                  F_RETORNANUMEIXOS(:new.con_valefrete_placa) * 
                  (PKG_CFE_FRETE.FN_GET_VALORPED(:new.glb_localidade_codigoori,
                                                 :new.glb_localidade_codigodes,
                                                 NVL(:new.glb_localidade_codigopasspor,'00000'),
                                                 NVL(:new.con_valefrete_dataemissao,SYSDATE)));    
               
               End If;
               
               If nvl(:new.con_valefrete_pedagio,0) > 0 and nvl(:old.con_valefrete_pedagio,0) = 0 Then
                      IF NVL(:new.con_valefrete_pedagiooriginal, 0) = 0 Then
                         :new.con_valefrete_pedagiooriginal := :new.con_valefrete_pedagio;
                      End If;
               End If;     
                   
         Exception
           When NO_DATA_FOUND Then
             -- Thiago 12/09/2019 - Caso o parametro não seja encontrado grava o pedagio
               If nvl(:new.con_valefrete_pedagio,0) > 0 and nvl(:old.con_valefrete_pedagio,0) = 0 Then
                      IF NVL(:new.con_valefrete_pedagiooriginal, 0) = 0 Then
                         :new.con_valefrete_pedagiooriginal := :new.con_valefrete_pedagio;
                      End If;
               End If;   
                 
         End;
       End If;
     End If;
  End If;
 /******************************************************************************
  *   END: TDVADM.TG_BIU_VALEFRETE - BEFORE INSERT E UPDATE                    *
  ******************************************************************************/  

 /******************************************************************************
  *   BEGIN: TDVADM.TG_BU_ATUALIZA_IMPOSTOS - BEFORE UPDATE                    *
  ******************************************************************************/
  IF UPDATING THEN
    IF (:OLD.GLB_TPMOTORISTA_CODIGO IN ('A', 'C') AND
       (TRUNC(:OLD.CON_VALEFRETE_DATACADASTRO) >= '01/03/2007')) AND
       ((:OLD.CON_VALEFRETE_STATUS IS NULL AND
       :NEW.CON_VALEFRETE_STATUS = 'C') OR
       (:OLD.CON_VALEFRETE_IMPRESSO IS NOT NULL AND
       :NEW.CON_VALEFRETE_IMPRESSO IS NULL)) THEN
    
      IF :OLD.GLB_TPMOTORISTA_CODIGO = 'A' THEN
        nFrete := NVL(:OLD.CON_VALEFRETE_VALORCOMDESCONTO, 0) -
                  NVL(:OLD.CON_VALEFRETE_PEDAGIO, 0);
      ELSIF :OLD.GLB_TPMOTORISTA_CODIGO = 'C' THEN
        nFrete := NVL(:OLD.CON_VALEFRETE_FRETE, 0);
      END IF;
    
      nIR        := NVL(:OLD.CON_VALEFRETE_IRRF, 0);
      nSESTSENAT := NVL(:OLD.CON_VALEFRETE_SESTSENAT, 0);
      nINSS      := NVL(:OLD.CON_VALEFRETE_INSS, 0);
      nQTDVF     := 1;
    
      BEGIN
        SELECT A.CAR_PROPRIETARIO_CGCCPFCODIGO,
               P.CAR_PROPRIETARIO_RAZAOSOCIAL
          INTO sProprietario, sProprietarioNome
          FROM T_CAR_VEICULO A, T_CAR_PROPRIETARIO P
         WHERE A.CAR_VEICULO_PLACA = :OLD.CON_VALEFRETE_PLACA
           AND A.CAR_VEICULO_SAQUE = :OLD.CON_VALEFRETE_PLACASAQUE
           AND A.CAR_PROPRIETARIO_CGCCPFCODIGO =
               P.CAR_PROPRIETARIO_CGCCPFCODIGO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          sProprietario     := NULL;
          sProprietarioNome := NULL;
      END;
    
      BEGIN
        SELECT NVL(B.CON_VALEFRETE_IMPOSTOSVLRACUMU, 0),
               NVL(B.CON_VALEFRETE_IMPOSTOS_IRRF, 0),
               NVL(B.CON_VALEFRETE_IMPOSTOS_SS, 0),
               NVL(B.CON_VALEFRETE_IMPOSTOS_INSS, 0),
               NVL(B.CON_VALEFRETE_IMPOSTOS_QTDVF, 0)
          INTO nVlrAcumulado,
               nIRacumulado,
               nSESTSENATacumulado,
               nINSSacumulado,
               nQTDVFacumulado
          FROM T_CON_VALEFRETEIMPOSTOS B
         WHERE B.CAR_PROPRIETARIO_CGCCPFCODIGO = sPROPRIETARIO
           AND B.CON_VALEFRETE_IMPOSTOS_REF = TO_CHAR(:OLD.CON_VALEFRETE_DATACADASTRO, 'MM/YYYY');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          nVlrAcumulado       := 0;
          nIRacumulado        := 0;
          nSESTSENATacumulado := 0;
          nINSSacumulado      := 0;
          nQTDVFacumulado     := 0;
      END;
    
      BEGIN
       SELECT TERMINAL, OS_USER
       INTO sMAQUINA, sUSUARIO_MAQUINA
          FROM V_GLB_AMBIENTE
         WHERE TERMINAL = USERENV('TERMINAL')
           AND ROWNUM = 1;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          sMAQUINA         := NULL;
          sUSUARIO_MAQUINA := NULL;
      END;
    
      BEGIN
      
        IF (nVlrAcumulado > 0) OR (nIRacumulado > 0) OR
           (nSESTSENATacumulado > 0) OR (nINSSacumulado > 0) THEN
          UPDATE T_CON_VALEFRETEIMPOSTOS B
             SET B.CON_VALEFRETE_IMPOSTOSVLRACUMU = (nVlrAcumulado - nFrete),
                 B.CON_VALEFRETE_IMPOSTOS_IRRF    = (nIRacumulado - nIR),
                 B.CON_VALEFRETE_IMPOSTOS_INSS    = (nINSSacumulado - nINSS),
                 B.CON_VALEFRETE_IMPOSTOS_QTDVF   = (nQTDVFacumulado - nQTDVF),
                 B.CON_VALEFRETE_IMPOSTOS_SS      = (nSESTSENATacumulado -
                                                    nSESTSENAT)
           WHERE B.CAR_PROPRIETARIO_CGCCPFCODIGO = sPROPRIETARIO
             AND B.CON_VALEFRETE_IMPOSTOS_REF =
                 TO_CHAR(:OLD.CON_VALEFRETE_DATACADASTRO, 'MM/YYYY');
        END IF;
      
        SP_ENVIAMAIL('SEQUENCIAL',
                     'tdv.operacao@dellavolpe.com.br',
                     TRIM('CANCELAMENTO/RETIRADA DE IMPRESSAO DO VF --> ' ||
                          :OLD.CON_CONHECIMENTO_CODIGO || ' - ' ||
                          :OLD.GLB_ROTA_CODIGO || ' - ' ||
                          :OLD.CON_VALEFRETE_SAQUE || ' - ' ||
                          :OLD.CON_CONHECIMENTO_SERIE),
                     'Data do Cancelamento...: ' || SYSDATE || CHR(10) ||
                     'Vale Frete N?..........: ' ||
                     :OLD.CON_CONHECIMENTO_CODIGO || CHR(10) ||
                     'Data de Emiss?o........: ' ||
                     :OLD.CON_VALEFRETE_DATACADASTRO || CHR(10) ||
                     'Rota...................: ' || :OLD.GLB_ROTA_CODIGO ||
                     CHR(10) || 'Serie..................: ' ||
                     :OLD.CON_CONHECIMENTO_SERIE || CHR(10) ||
                     'Placa..................: ' || :OLD.CON_VALEFRETE_PLACA ||
                     CHR(10) || 'Proprietario...........: ' ||
                     Trim(sProprietario) || ' - ' || Trim(sProprietarioNome) ||
                     CHR(10) || CHR(10) || 'VALORES/IMPOSTOS ACUMULADOS:' ||
                     CHR(10) || 'Frete.....: R$ ' || nVlrAcumulado || CHR(10) ||
                     'IRRF......: R$ ' || nIRacumulado || CHR(10) ||
                     'INSS......: R$ ' || nINSSacumulado || CHR(10) ||
                     'SESTSENAT.: R$ ' || nSESTSENATacumulado || CHR(10) ||
                     CHR(10) || 'VALORES/IMPOSTOS A SEREM ESTORNADOS:' ||
                     CHR(10) || 'Frete.....: R$ ' || nFrete || CHR(10) ||
                     'IRRF......: R$ ' || nIR || CHR(10) || 'INSS......: R$ ' ||
                     nINSS || CHR(10) || 'SESTSENAT.: R$ ' || nSESTSENAT ||
                     CHR(10) || CHR(10) ||
                     'ATENC?O: OS VALORES ACIMA SER?O ESTORNADOS DO ACUMULADO DO PROPRIETARIO.' ||
                     CHR(10) || CHR(10) || 'Data.........................: ' ||
                     TO_CHAR(SYSDATE, 'DD/MM/YYYY - HH24:MI:SS') || CHR(10) ||
                     'Rotina.......................: ' ||
                     'TG_ATUALIZA_IMPOSTOS' || CHR(10) ||
                     'Maquina Utilizada............: ' || sMAQUINA || CHR(10) ||
                     'Usuario Logado na Maquina....: ' || sUSUARIO_MAQUINA ||
                     CHR(10) || ' ' || CHR(10) || '',
                     '0',
                     'S',
                     'mneves@dellavolpe.com.br;tdv.assgeradmin@dellavolpe.com.br;sdrumond@dellavolpe.com.br',
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
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  'ERRO AO ESTORNAR IMPOSTOS.' || CHR(10) ||
                                  'ERRO: ' || SQLERRM);
      END;
    END IF;    
  END IF;
 /******************************************************************************
  *   END: TDVADM.TG_BU_ATUALIZA_IMPOSTOS - BEFORE UPDATE                      *
  ******************************************************************************/  
  
 /******************************************************************************
  *   BEGIN: TDVADM.TG_RATEIACONHEC - BEFORE UPDATE                            *
  ******************************************************************************/
  IF UPDATING('CON_VALEFRETE_LOTACAO')         or
     UPDATING('CON_VALEFRETE_PESOCOBRADO')     or
     UPDATING('CON_VALEFRETE_TIPOCUSTO')       or
     UPDATING('CON_VALEFRETE_CUSTOCARRETEIRO') or
     UPDATING('CON_VALEFRETE_ENLONAMENTO')     or
     UPDATING('CON_VALEFRETE_ESTADIA')         or
     UPDATING('CON_VALEFRETE_OUTROS')          or
     UPDATING('CON_VALEFRETE_VALORESTIVA')     or
     UPDATING('CON_VALEFRETE_STATUS')          or
     UPDATING('ACC_ACONTAS_NUMERO')            or
     UPDATING('CON_VALEFRETE_DATARECEBIMENTO') or
     UPDATING('ACC_ACONTAS_TPDOC')             or
     UPDATING('CON_VALEFRETE_IMPRESSO')        THEN

    V_EMITE_BONUS := 'N';
     
    -- PEGA PARAMETROS
    sp_usu_parametrossc('comvlfrete', NVL(:NEW.USU_USUARIO_CODIGO,'jsantos'), NVL(:NEW.GLB_ROTA_CODIGO,'010'), 'TRIGGER');
    --
    
    v_AgregadoPerc      := 0;  
    v_AgregadoPercDef   := 0;
    v_AgregadoPercPlaca := -1;
    v_AgregadoPercCAT   := 0;

    OPEN C_PARAMETROS;
    LOOP
      FETCH C_PARAMETROS
        INTO V_PARAMETRO, 
             V_PARAMTEXTO,
             v_paramnumber;
      EXIT WHEN C_PARAMETROS%NOtFOUND;

      IF V_PARAMETRO = 'PERCENT_BONUS' THEN
        V_PERC_BONUS := V_PARAMTEXTO;
      ELSIF V_PARAMETRO = 'VLRAGREGPER' THEN
        v_AgregadoPercDef := v_paramnumber ;
      ELSIF V_PARAMETRO = 'VLRAGREGPER' || TRIM(:new.con_valefrete_placa) THEN
        v_AgregadoPercPlaca := v_paramnumber ;
      ELSIF V_PARAMETRO = 'VLRAGREGPER' || TRIM(:new.CON_CATVALEFRETE_CODIGO) THEN
        v_AgregadoPercCAT := v_paramnumber ;
      END IF;
    END LOOP;
    CLOSE C_PARAMETROS;

    IF nvl(v_AgregadoPercDef,0) = 0 THEN
       v_AgregadoPercDef := 100;
    END IF;   
    
    IF v_AgregadoPercPlaca > -1 tHEN
      v_AgregadoPerc := v_AgregadoPercPlaca;
    Else
       if v_AgregadoPercCAT > 0 Then  
          v_AgregadoPerc := v_AgregadoPercCAT;
       Else
          v_AgregadoPerc := v_AgregadoPercDef;
       End if;
    End If;      
            
    IF (nvl(v_AgregadoPerc,0) = 0) and (v_AgregadoPercPlaca = -1) THEN
       v_AgregadoPerc := v_AgregadoPercDef;
    END IF;   
    
    IF (nvl(v_AgregadoPerc,0) = 0) AND (v_AgregadoPercPlaca = -1)THEN
       v_AgregadoPerc := 5;
    END IF;   
    
    -- SE CANCELADO ENTRA COM VALOR DE RATEIO ZERADO
    IF (:NEW.CON_VALEFRETE_STATUS = 'C') THEN
      :NEW.CON_VALEFRETE_VALORRATEIO := 0;
    ELSE
      IF NVL(:NEW.CON_VALEFRETE_PEDPGCLI, 'N') = 'S' THEN 
        V_PEDAGIOCLI := :NEW.CON_VALEFRETE_PEDAGIO;
      ELSE
        V_PEDAGIOCLI := 0;
      END IF;
      
      V_TIPOMOT := :NEW.GLB_TPMOTORISTA_CODIGO ;

      -- Testa se teve desconto de Agregado
      If V_TIPOMOT in ('C','D') Then
         select count(*)
           into vAuxiliar
         from tdvadm.t_con_calcvalefrete cv
         where cv.con_conhecimento_codigo = :new.con_conhecimento_codigo
           and cv.con_conhecimento_serie = :new.con_conhecimento_serie
           and cv.glb_rota_codigo = :new.glb_rota_codigo
           and cv.con_valefrete_saque = :new.con_valefrete_saque
           and cv.con_calcvalefretetp_codigo = '05'
           and cv.con_calcvalefrete_valor <> 0 ;
         If vAuxiliar > 0 then
            V_TIPOMOT := 'A';
         End If;
      End If;

      SELECT SUM(NVL(FN_VERBASEMIMPOSTO(X.CON_CONHECIMENTO_CODIGO, X.CON_CONHECIMENTO_SERIE, X.GLB_ROTA_CODIGO, 'I_TTPV'), 1)),
             SUM(NVL(f_busca_conhec_ttpv(X.CON_CONHECIMENTO_CODIGO, X.CON_CONHECIMENTO_SERIE, X.GLB_ROTA_CODIGO), 1)),
             SUM(DECODE(CL.GLB_GRUPOECONOMICO_CODIGO,'0020',1,0))
        INTO V_VALORTOTALCTRC,
             v_valortotalctrccimp,
             vTemGrupo0020
        FROM TDVADM.T_CON_VFRETECONHEC X,
             TDVADM.t_con_conhecimento c,
             TDVADM.t_glb_cliente cl
       WHERE X.CON_VALEFRETE_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
         AND X.CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
         AND X.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO
         AND X.CON_VALEFRETE_SAQUE = :NEW.CON_VALEFRETE_SAQUE
         AND X.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
         AND X.CON_CONHECIMENTO_SERIE  = C.CON_CONHECIMENTO_SERIE
         AND X.GLB_ROTA_CODIGO         = C.GLB_ROTA_CODIGO
         AND C.GLB_CLIENTE_CGCCPFSACADO = CL.GLB_CLIENTE_CGCCPFCODIGO;
    
      IF NVL(V_VALORTOTALCTRC, 0) = 0 THEN
        V_VALORTOTALCTRC := 1;
        v_valortotalctrccimp := 1;
      END IF;
    
      IF NVL(:NEW.CON_VALEFRETE_PESOCOBRADO, 0) = 0 THEN
        V_PESOCONTRATADO := 1;
      ELSE
        V_PESOCONTRATADO := :NEW.CON_VALEFRETE_PESOCOBRADO;
      END IF;

      -- GILES 20/07/2004
      -- QUANDO COMPLEMENTO SOMO AS VERBAS PARA CALCULAR OS CUSTOS
      IF (:NEW.CON_CATVALEFRETE_CODIGO = '05') THEN
        IF (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) = 0) THEN
          NVALORRATEIO := (NVL(:NEW.CON_VALEFRETE_VALORESTIVA, 0) + 
                           NVL(:NEW.CON_VALEFRETE_ENLONAMENTO, 0) + 
                           NVL(:NEW.CON_VALEFRETE_ESTADIA, 0) + 
                           NVL(:NEW.CON_VALEFRETE_OUTROS, 0)) / V_VALORTOTALCTRC;
          NVALORRATEIOF := (NVL(:NEW.CON_VALEFRETE_VALORESTIVA, 0) + 
                           NVL(:NEW.CON_VALEFRETE_ENLONAMENTO, 0) + 
                           NVL(:NEW.CON_VALEFRETE_ESTADIA, 0) + 
                           NVL(:NEW.CON_VALEFRETE_OUTROS, 0)) / v_valortotalctrccimp;
          NVALORRATEIOP := NVL(:NEW.CON_VALEFRETE_PEDAGIO - V_PEDAGIOCLI, 0) / v_valortotalctrccimp;
        ELSE
          IF UPPER(:NEW.CON_VALEFRETE_TIPOCUSTO) = 'T' THEN
            NVALORRATEIO := ((NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) * V_PESOCONTRATADO) - V_PEDAGIOCLI) / V_VALORTOTALCTRC;
            NVALORRATEIOF := ((NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) * V_PESOCONTRATADO) - V_PEDAGIOCLI) / v_valortotalctrccimp;
            NVALORRATEIOP := NVL(:NEW.CON_VALEFRETE_PEDAGIO - V_PEDAGIOCLI, 0) / v_valortotalctrccimp;
            V_NVALORCALCULO := (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) * V_PESOCONTRATADO) / V_VALORTOTALCTRC;
            
            --NVALORRATEIO := ((NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) - V_PEDAGIOCLI) * V_PESOCONTRATADO) / V_VALORTOTALCTRC;
          ELSE
            NVALORRATEIO := (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) - V_PEDAGIOCLI) / V_VALORTOTALCTRC;
            NVALORRATEIOF := (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) - V_PEDAGIOCLI) / v_valortotalctrccimp;
            NVALORRATEIOP := NVL(:NEW.CON_VALEFRETE_PEDAGIO - V_PEDAGIOCLI, 0) / v_valortotalctrccimp;
            V_NVALORCALCULO := NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) / V_VALORTOTALCTRC;
          END IF;
        END IF;
      ELSE
        IF UPPER(:NEW.CON_VALEFRETE_TIPOCUSTO) = 'T' THEN
          --NVALORRATEIO := ((NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) - V_PEDAGIOCLI) * V_PESOCONTRATADO) / V_VALORTOTALCTRC;
          
          --JUNIOR 20/05  (MANEIRA CORRETA DE OBTER O CUSTO CARRETEIRO P/ FRETE POR TONELADA)
          NVALORRATEIO := ((NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) * V_PESOCONTRATADO) - V_PEDAGIOCLI) / V_VALORTOTALCTRC;
          NVALORRATEIOF := ((NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) * V_PESOCONTRATADO) - V_PEDAGIOCLI) / v_valortotalctrccimp;
          NVALORRATEIOP := NVL(:NEW.CON_VALEFRETE_PEDAGIO - V_PEDAGIOCLI, 0) / v_valortotalctrccimp;
          V_NVALORCALCULO := (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) * V_PESOCONTRATADO) / V_VALORTOTALCTRC;
        ELSE
          NVALORRATEIO := (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) - V_PEDAGIOCLI) / V_VALORTOTALCTRC;
          NVALORRATEIOF := (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) - V_PEDAGIOCLI) / v_valortotalctrccimp;
          NVALORRATEIOP := NVL(:NEW.CON_VALEFRETE_PEDAGIO - V_PEDAGIOCLI, 0) / v_valortotalctrccimp;
          V_NVALORCALCULO := NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0) / V_VALORTOTALCTRC;
        END IF;
      END IF;
    
      IF SUBSTR(:NEW.CON_VALEFRETE_PLACA, 1, 2) = '00' THEN -- FROTA
        IF (:NEW.CON_VALEFRETE_PEDAGIO = 0) AND 
           (NVL(:NEW.CON_VALEFRETE_PEDPGCLI,'N') = 'N') and 
           :new.con_catvalefrete_codigo  in ( tdvadm.pkg_con_valefrete.CatTUmaViagem,
                                              tdvadm.pkg_con_valefrete.CatTAvulsoCCTRC    
                                                ) THEN
          V_PEDAGIOFROTA := NVL(((F_BUSCA_PEDAGIO_PERCURSO_ATU(:NEW.GLB_LOCALIDADE_CODIGOORI, 
                                                               :NEW.GLB_LOCALIDADE_CODIGODES, 
                                                               :NEW.CON_VALEFRETE_DATAEMISSAO) *
                                                               F_RETORNANUMEIXOS(:NEW.CON_VALEFRETE_PLACA)) / 
                                V_VALORTOTALCTRC), 0);
        ELSE
          V_PEDAGIOFROTA := 0;
        END IF;
        NVALORRATEIOF := 0;
        NVALORRATEIOP := 0;
      ELSE  -- AGREGADO/TERCEIRO
        V_VLRDESCONTO := ((V_NVALORCALCULO * V_VALORTOTALCTRC) - 
                          NVL(:NEW.CON_VALEFRETE_PEDAGIO, 0) - 
                          NVL(:NEW.CON_VALEFRETE_VALORESTIVA, 0) - 
                          NVL(:NEW.CON_VALEFRETE_VALORVAZIO, 0) -
                          NVL(:NEW.CON_VALEFRETE_ENLONAMENTO, 0) - 
                          NVL(:NEW.CON_VALEFRETE_OUTROS, 0) -
                          NVL(:NEW.CON_VALEFRETE_IRRF, 0) - 
                          NVL(:NEW.CON_VALEFRETE_ESTADIA, 0)) * ( (100 - v_AgregadoPerc) /100 ) ;
        V_VLRDESCONTO := (V_VLRDESCONTO + 
                          NVL(:NEW.CON_VALEFRETE_PEDAGIO, 0) + 
                          NVL(:NEW.CON_VALEFRETE_VALORESTIVA, 0) + 
                          NVL(:NEW.CON_VALEFRETE_VALORVAZIO, 0) + 
                          NVL(:NEW.CON_VALEFRETE_ENLONAMENTO, 0) +
                          NVL(:NEW.CON_VALEFRETE_OUTROS, 0) +
                          NVL(:NEW.CON_VALEFRETE_IRRF, 0) + 
                          NVL(:NEW.CON_VALEFRETE_ESTADIA, 0));
        IF (TRIM(FN_RETTP_MOTORISTA(:NEW.CON_VALEFRETE_PLACA, :NEW.CON_VALEFRETE_PLACASAQUE, :NEW.CON_VALEFRETE_DATAEMISSAO)) = 'AGREGADO') AND
           (NVL(:NEW.CON_VALEFRETE_VALORCOMDESCONTO, 0) <> NVL(V_VLRDESCONTO, 0)) AND
           (NVL(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, 0)) > 0 and 
           (nvl(:new.con_valefrete_impresso,'N') = 'N')  THEN
          -- SE VALE PEDAGIO -- REVER O CONCEITO
          :NEW.CON_VALEFRETE_VALORCOMDESCONTO := ((V_NVALORCALCULO * V_VALORTOTALCTRC) - 
                                                  NVL(:NEW.CON_VALEFRETE_PEDAGIO, 0) - 
                                                  NVL(:NEW.CON_VALEFRETE_VALORESTIVA, 0) -
                                                  NVL(:NEW.CON_VALEFRETE_ENLONAMENTO, 0) - 
                                                  NVL(:NEW.CON_VALEFRETE_OUTROS, 0) -
                                                  NVL(:NEW.CON_VALEFRETE_ESTADIA, 0)) * ( (100 - v_AgregadoPerc) /100 );  
          :NEW.CON_VALEFRETE_VALORCOMDESCONTO := (:NEW.CON_VALEFRETE_VALORCOMDESCONTO + 
                                                  NVL(:NEW.CON_VALEFRETE_PEDAGIO, 0) + 
                                                  NVL(:NEW.CON_VALEFRETE_VALORESTIVA, 0) +
                                                  NVL(:NEW.CON_VALEFRETE_ENLONAMENTO, 0) + 
                                                  NVL(:NEW.CON_VALEFRETE_OUTROS, 0) +
                                                  NVL(:NEW.CON_VALEFRETE_ESTADIA, 0));
        END IF;
        V_PEDAGIOFROTA := 0;
      END IF;
      
      IF V_TIPOMOT = 'A' THEN
         NVALORRATEIOF := (NVL(:NEW.CON_VALEFRETE_VALORCOMDESCONTO, 0) - V_PEDAGIOCLI) / v_valortotalctrccimp;
         NVALORRATEIOP := NVL(:NEW.CON_VALEFRETE_PEDAGIO - V_PEDAGIOCLI, 0) / v_valortotalctrccimp;
      END IF;
      
    
      IF (NVL(:NEW.CON_VALEFRETE_VALORVAZIO, 0) > 0) AND
         (TRIM(FN_RETTP_MOTORISTA(:NEW.CON_VALEFRETE_PLACA, :NEW.CON_VALEFRETE_PLACASAQUE, :NEW.CON_VALEFRETE_DATAEMISSAO)) = 'AGREGADO') THEN   
        :NEW.CON_VALEFRETE_VALORRATEIO := NVALORRATEIO + 
                                          V_PEDAGIOFROTA + 
                                          (NVL(:NEW.CON_VALEFRETE_VALORVAZIO, 0) / V_VALORTOTALCTRC);
      ELSE
        :NEW.CON_VALEFRETE_VALORRATEIO := NVALORRATEIO + V_PEDAGIOFROTA;
      END IF;
    
    END IF;
    begin 


    IF (nvl(:new.con_valefrete_impresso,'N') = 'N') and ( TO_DATE(TO_CHAR(:NEW.CON_VALEFRETE_DATACADASTRO,'DD/MM/YYYY'),'DD/MM/YYYY') >= TRUNC(SYSDATE))  THEN
        :NEW.CON_VALEFRETE_DATACADASTRO := trunc(:NEW.CON_VALEFRETE_DATACADASTRO);
    END IF;    



    IF TO_DATE(TO_CHAR(:NEW.CON_VALEFRETE_DATACADASTRO,'DD/MM/YYYY'),'DD/MM/YYYY') >= TRUNC(SYSDATE)-90  THEN
    
      BEGIN
         SELECT GLB_ROTA_CALCBONUS
           INTO V_EMITE_BONUS
           FROM T_GLB_ROTA
           WHERE GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               V_EMITE_BONUS := 'N';
    END;
      
    -- Pega o Conteudo da Rota se estiver inserindo
    -- Colocar a proc abaixo verificando contrato
    -- TRAVA DE SANTOS
/*    V_EMITE_BONUS := tdvadm.pkg_con_valefrete.Fn_RetornaDescBonus(pValeFreteCod   => :NEW.CON_CONHECIMENTO_CODIGO,
                                                                  pValeFrereSerie => :new.con_conhecimento_serie,
                                                                  pValeFreteRota  => :new.glb_rota_codigo,
                                                                  pValeFreteSaque => :new.con_valefrete_saque);
*/

--   V_EMITE_BONUS := nvl(:new.con_valefrete_descbonus,'S');

-- Sirlano 11/05/2021
-- Retirei a CHUMBADA abaixo e coloquei a funcao acima
    If :new.glb_rota_codigo = '060'  Then
      If nvl(:new.con_valefrete_descbonus,'N') <> 'S' Then
          V_EMITE_BONUS := tdvadm.pkg_con_valefrete.Fn_VerificaDescBonus(:new.con_conhecimento_codigo,
                                                                         :new.con_conhecimento_serie,
                                                                         :new.glb_rota_codigo,
                                                                         :new.con_valefrete_saque,
                                                                         :new.glb_tpmotorista_codigo);
          :new.con_valefrete_descbonus := V_EMITE_BONUS;
          :new.con_valefrete_condespeciais := 'RECEBER R$ 0,00 DE BONUS NA PONTA - SE ENTREGUE NO PRAZO';
       End If;
    End If;
      
      if ( ( :new.glb_rota_codigo = '460' ) or (:old.glb_rota_codigo = '460' ) ) then
         if V_EMITE_BONUS <> 'S' then
           raise_application_error(-20123,'Rota 460 tem que emitir Bonus FLAG [' || V_EMITE_BONUS || '] - ');
         end if;
      end if;
         
      vCON_VALEFRETE_DESCBONUS     := :new.CON_VALEFRETE_DESCBONUS;
      vCON_VALEFRETE_CONDESPECIAIS := :new.CON_VALEFRETE_CONDESPECIAIS; 
      IF (V_EMITE_BONUS = 'S') THEN
        if nvl(:new.con_valefrete_impresso,'N') = 'N' Then   

        IF (:NEW.CON_CATVALEFRETE_CODIGO NOT IN (tdvadm.pkg_con_valefrete.CatTBonusManifesto,
                                                 tdvadm.pkg_con_valefrete.CatTBonusCTRC)) THEN

           IF (:NEW.CON_VALEFRETE_TIPOCUSTO) = 'T' THEN
              --V_BONUS := ((:NEW.CON_VALEFRETE_CUSTOCARRETEIRO * :NEW.CON_VALEFRETE_PESOCOBRADO) * TO_NUMBER(V_PERC_BONUS) / 100);
              V_BONUS := fn_retornavalorfretebonus(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO * :NEW.CON_VALEFRETE_PESOCOBRADO, TO_NUMBER(V_PERC_BONUS), 'B2');
           ELSE
              --V_BONUS := ((:NEW.CON_VALEFRETE_CUSTOCARRETEIRO) * TO_NUMBER(V_PERC_BONUS) / 100);
              V_BONUS := fn_retornavalorfretebonus(:NEW.CON_VALEFRETE_CUSTOCARRETEIRO, TO_NUMBER(V_PERC_BONUS), 'B2');
           END IF;
           IF (:OLD.CON_VALEFRETE_CONDESPECIAIS IS NOT NULL AND :NEW.CON_VALEFRETE_CONDESPECIAIS IS NOT NULL) OR (:NEW.CON_VALEFRETE_DESCBONUS = 'S') THEN
              IF :NEW.GLB_TPMOTORISTA_CODIGO = 'F' THEN
                 --V_BONUS := V_BONUS*0.1;
                 If nvl(:NEW.CON_VALEFRETE_STATUS,'N') <> 'C' Then
                    If V_BONUS <> 0 Then
                       If vTemGrupo0020 = 0 Then
                          :NEW.CON_VALEFRETE_CONDESPECIAIS := 'RECEBER COMISS?O S/BONUS DE R$ ' || TRIM(TO_CHAR(V_BONUS,'999,999,990.00')) || ' NA PONTA SE ENTR.NO DIA COMBINADO, PAGAMENTO AUTORIZADO SOMENTE NAS FILIAIS';
                       Else
                          :NEW.CON_VALEFRETE_CONDESPECIAIS := 'RECEBER COMISS?O S/BONUS DE R$ ' || TRIM(TO_CHAR(V_BONUS,'999,999,990.00')) || ' NA PONTA SE CHEGADA/HORA DE TODAS JANELAS CONTRATADAS ESTIVER NO PRAZO, ALEM DE APRESENTAR A COPIA DO CHECK-LIST';
                       End If;                  
                    End IF;
                 End If;
              ELSE
                 If V_BONUS <> 0 Then
                    If vTemGrupo0020 = 0 Then
                       :NEW.CON_VALEFRETE_CONDESPECIAIS := 'RECEBER R$ ' || TRIM(TO_CHAR(V_BONUS,'999,999,990.00')) || ' DE BONUS NA PONTA SE ENTR.NO DIA COMBINADO, PAGAMENTO AUTORIZADO SOMENTE NAS FILIAIS';
                    Else
                       :NEW.CON_VALEFRETE_CONDESPECIAIS := 'RECEBER R$ ' || TRIM(TO_CHAR(V_BONUS,'999,999,990.00')) || ' DE BONUS NA PONTA SE CHEGADA/HORA DE TODAS JANELAS CONTRATADAS ESTIVER NO PRAZO, ALEM DE APRESENTAR A COPIA DO CHECK-LIST';
                    End If; 
                 End If; 
              END IF;    
  --               :new.con_valefrete_frete := :new.con_valefrete_frete - V_BONUS;
                 if :new.glb_tpmotorista_codigo <> 'F' Then
                     if nvl(:new.con_valefrete_valorcomdesconto,0) > 0 Then
  --                       :new.con_valefrete_valorcomdesconto := :new.con_valefrete_valorcomdesconto - V_BONUS;
                         
                         :new.con_valefrete_valorliquido := nvl(:new.con_valefrete_valorcomdesconto,0) -
  --                                                          nvl(:new.CON_VALEFRETE_PEDAGIO,0) -
                                                            nvl(:new.CON_VALEFRETE_ADIANTAMENTO,0) -
                                                            nvl(:new.CON_VALEFRETE_MULTA,0) -
                                                            nvl(:new.CON_VALEFRETE_IRRF,0) -
                                                            nvl(:new.CON_VALEFRETE_INSS,0) -
                                                            nvl(:new.CON_VALEFRETE_SESTSENAT,0) -
                                                            nvl(:new.CON_VALEFRETE_PIS,0) -
                                                            nvl(:new.CON_VALEFRETE_COFINS,0) -
                                                            nvl(:new.CON_VALEFRETE_CSLL,0) -
                                                            nvl(:new.con_valefrete_outros,0);
                    Else
                      If ( ( nvl(:new.con_valefrete_pgvpedagio,'N') = 'N' )  and 
                           ( nvl(:new.con_valefrete_pedpgcli,'N')   = 'N' ) ) Then
                         :new.con_valefrete_valorliquido := nvl(:new.con_valefrete_frete,0) 
                                                            + nvl(:new.CON_VALEFRETE_PEDAGIO,0) 
                                                            - nvl(:new.CON_VALEFRETE_ADIANTAMENTO,0) 
                                                            - nvl(:new.CON_VALEFRETE_MULTA,0) 
                                                            - nvl(:new.CON_VALEFRETE_IRRF,0) 
                                                            - nvl(:new.CON_VALEFRETE_INSS,0) 
                                                            - nvl(:new.CON_VALEFRETE_SESTSENAT,0) 
                                                            - nvl(:new.CON_VALEFRETE_PIS,0) 
                                                            - nvl(:new.CON_VALEFRETE_COFINS,0) 
                                                            - nvl(:new.CON_VALEFRETE_CSLL,0) 
                                                            - nvl(:new.con_valefrete_outros,0);
                      
                      Else
                         :new.con_valefrete_valorliquido := nvl(:new.con_valefrete_frete,0) 
--                                                            + nvl(:new.CON_VALEFRETE_PEDAGIO,0) 
                                                            - nvl(:new.CON_VALEFRETE_ADIANTAMENTO,0) 
                                                            - nvl(:new.CON_VALEFRETE_MULTA,0) 
                                                            - nvl(:new.CON_VALEFRETE_IRRF,0) 
                                                            - nvl(:new.CON_VALEFRETE_INSS,0) 
                                                            - nvl(:new.CON_VALEFRETE_SESTSENAT,0) 
                                                            - nvl(:new.CON_VALEFRETE_PIS,0) 
                                                            - nvl(:new.CON_VALEFRETE_COFINS,0) 
                                                            - nvl(:new.CON_VALEFRETE_CSLL,0) 
                                                            - nvl(:new.con_valefrete_outros,0);
                       
                      End if; 
                   End If;
                Else
                    :new.con_valefrete_valorliquido := nvl(:new.CON_VALEFRETE_ADIANTAMENTO,0);
                End if;                                            
                 
           END IF;
        
     
        ELSE
           :NEW.CON_VALEFRETE_CONDESPECIAIS := '';
        END IF;
       end if;
      END IF;
    END IF;
    exception
      when OTHERS then
        raise_application_error(-20001,'Emite Bonus [' || V_EMITE_BONUS || '] - ' ||
                                       'PBonus [' ||V_PERC_BONUS || '] - ' || 
                                       'Rota [' || :NEW.GLB_ROTA_CODIGO || '] - ' ||
                                       'Dt Cad [' || TO_CHAR(:NEW.CON_VALEFRETE_DATACADASTRO,'DD/MM/YYYY') || '] - ' ||
                                        sqlerrm || chr(10) || dbms_utility.format_error_backtrace);
    end;  
   -- PEDE PARA ATUALIZAR O CUSTO DE TODOS OS VALES DE MESMO NUMERO
    UPDATE T_CON_VFRETECONHEC V
       SET CON_VFRETECONHEC_RECALCULA     = 'S',
           CON_VFRETECONHEC_RATEIORECEITA = NULL,
           -- ATUALIZA SOMENTE O VALE DE FRETE com o saque
           CON_VFRETECONHEC_RATEIOFRETE = decode(CON_VALEFRETE_SAQUE,:NEW.CON_VALEFRETE_SAQUE,nvl(NVALORRATEIOF,0),CON_VFRETECONHEC_RATEIOFRETE),
           CON_VFRETECONHEC_RATEIOPEDAGIO = decode(CON_VALEFRETE_SAQUE,:NEW.CON_VALEFRETE_SAQUE,nvl(NVALORRATEIOP,0),CON_VFRETECONHEC_RATEIOPEDAGIO)
     WHERE CON_VALEFRETE_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
       AND CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
       AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO;
     
   END IF;
   
 /******************************************************************************
  *   END: TDVADM.TG_RATEIACONHEC - BEFORE UPDATE                              *
  ******************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BU_ATUALIZA_DTCADASTRO - BEFORE UPDATE                  *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_IMPRESSO')         or
     UPDATING('CON_VALEFRETE_DATACADASTRO')     THEN

      -- ATUALIZA SOMENTE A DATA DE GRAVAC?O SE FOR CATEGORIAS USADAS
      -- PELA VALE, PARA QUE REPRESENTE O INICIO DA VIAGEM
      -- A DATA/HORA QUE IMPRIMIU O VALE DE FRETE
      IF nvl(:OLD.CON_VALEFRETE_IMPRESSO,'N') <> 'S' THEN
         IF :NEW.con_catvalefrete_codigo IN ('01','11','16','18') THEN
            IF TRUNC(SYSDATE - :OLD.CON_VALEFRETE_DATACADASTRO) <= 2 THEN
              if (nvl(:OLD.CON_VALEFRETE_IMPRESSO,'N') = 'I') and (nvl(:NEW.CON_VALEFRETE_IMPRESSO,'N') <> 'I') then 
                 -- esta retiranda a impressao do Vale de frete   
                 :NEW.CON_VALEFRETE_DATACADASTRO := trunc(SYSDATE);
              Else
                 :NEW.CON_VALEFRETE_DATACADASTRO := trunc(SYSDATE);
              End if;  
            END IF;
         END IF   ;
      END IF;
      IF :NEW.con_catvalefrete_codigo IN ('07') THEN
         if :old.CON_VALEFRETE_DATACADASTRO <> :new.CON_VALEFRETE_DATACADASTRO then
            :new.con_valefrete_dataemissao := trunc(:new.CON_VALEFRETE_DATACADASTRO);
         end if;
      END IF;

      -- Fabiano: 14/10/2011
      -- Solicitado pelo Chaves, controle de pagamento de terceiros.
      -- Verificar com o Sirlano se pode impactar outras rotinas.
      IF :NEW.con_catvalefrete_codigo IN ('10') THEN
         if (nvl(:OLD.CON_VALEFRETE_IMPRESSO,'N') = 'I') and (nvl(:NEW.CON_VALEFRETE_IMPRESSO,'N') <> 'I') then 
            :NEW.CON_VALEFRETE_DATACADASTRO := trunc(SYSDATE);
         Else
            :NEW.CON_VALEFRETE_DATACADASTRO := trunc(SYSDATE);
         End if;   
      end if;


      -- Klayton 19/04/2012
      -- se não tiver hora na impress?o colocamos a hora
      vStrHora := substr(to_char(:new.CON_VALEFRETE_DATACADASTRO,'DD/MM/YYYY HH24:MI:SS'),-8);

      if (nvl(:OLD.CON_VALEFRETE_IMPRESSO,'N') = 'I') and (nvl(:NEW.CON_VALEFRETE_IMPRESSO,'N') <> 'I') then 
          :NEW.CON_VALEFRETE_DATACADASTRO := trunc(SYSDATE);
      Else
         IF vStrHora = '00:00:00' THEN
            :new.CON_VALEFRETE_DATACADASTRO := TO_DATE(trunc(:new.CON_VALEFRETE_DATACADASTRO) ||' ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS');
         END IF;
      End If;
   End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BU_ATUALIZA_DTCADASTRO - BEFORE UPDATE                    *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BU_CON_DTGRAVCHEKIN2 - BEFORE UPDATE                    *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_DTCHECKIN') Then
     IF :NEW.CON_VALEFRETE_DTCHECKIN IS NOT NULL THEN
        :NEW.CON_VALEFRETE_DTGRAVCHECKIN := SYSDATE;
     END IF;
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BU_CON_DTGRAVCHEKIN2 - BEFORE UPDATE                      *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BU_CON_VALEFRETEACC_CONTAS - BEFORE UPDATE              *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_DATARECEBIMENTO') Then
    -- ENTROU NO ACERTO DE CONTAS
    -- DEU DATA DE RECEBIMENTO COLOCO QUE ESTA IMPRESSO
    -- GILES 21/07/2004
    IF (NVL(:NEW.CON_VALEFRETE_DATARECEBIMENTO,'01/01/9999') <> '01/01/9999') AND
       (NVL(:OLD.CON_VALEFRETE_DATARECEBIMENTO,'01/01/9999') =  '01/01/9999') THEN 
        :NEW.CON_VALEFRETE_IMPRESSO := 'S';                
    END IF;

    -- ESTORNOU DO ACERTO DE CONTAS
    -- DESMARCO IMPRESSO
    -- GILES 21/07/2004
    IF (NVL(:NEW.CON_VALEFRETE_DATARECEBIMENTO,'01/01/9999') = '01/01/9999') AND
       (NVL(:OLD.CON_VALEFRETE_DATARECEBIMENTO,'01/01/9999') <> '01/01/9999') THEN 
       :NEW.CON_VALEFRETE_IMPRESSO := NULL;
    END IF;
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BU_CON_VALEFRETEACC_CONTAS - BEFORE UPDATE                *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BUC_LIBVEICECARREG - BEFORE UPDATE                      *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_STATUS') Then
    IF :NEW.CON_VALEFRETE_STATUS = 'C' THEN
      BEGIN
        SELECT VE.FCF_VEICULODISP_CODIGO, VE.FCF_VEICULODISP_SEQUENCIA
          INTO V_COD_VEICULO, V_SEQUENCIA
          FROM T_CON_CONHECIMENTO CO,
               T_ARM_CARREGAMENTO CA,
               T_FCF_VEICULODISP  VE
         WHERE
        /*CARREGAMENTO                            VEICULO*/
         CA.FCF_VEICULODISP_CODIGO = VE.FCF_VEICULODISP_CODIGO
         AND CA.FCF_VEICULODISP_SEQUENCIA = VE.FCF_VEICULODISP_SEQUENCIA
        /*CARREGAMENTO                            CONHECIMENTO*/
         AND CA.ARM_CARREGAMENTO_CODIGO = CO.ARM_CARREGAMENTO_CODIGO
        /*VALEFRETE                               CONECIMENTO*/
         AND :NEW.CON_CONHECIMENTO_CODIGO = CO.CON_CONHECIMENTO_CODIGO
         AND :NEW.CON_CONHECIMENTO_SERIE = CO.CON_CONHECIMENTO_SERIE
         AND :NEW.GLB_ROTA_CODIGO = CO.GLB_ROTA_CODIGO
         AND ROWNUM = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_COD_VEICULO := '0';
          V_SEQUENCIA   := '0';
      END;
      IF NOT ((V_COD_VEICULO = '0') AND (V_SEQUENCIA = '0')) THEN
        UPDATE T_FCF_VEICULODISP VE
           SET VE.FCF_VEICULODISP_FLAGVALEFRETE = NULL
         WHERE VE.FCF_VEICULODISP_CODIGO = V_COD_VEICULO
           AND VE.FCF_VEICULODISP_SEQUENCIA = V_SEQUENCIA;

         update t_arm_carregamento ca
            set ca.arm_carregamento_dtfinalizacao = null
          where ca.fcf_veiculodisp_codigo = V_COD_VEICULO
            and ca.fcf_veiculodisp_sequencia = V_SEQUENCIA;

      END IF;
    END IF;
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BUC_LIBVEICECARREG - BEFORE UPDATE                        *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_ATU_ACONTAS_IMPR - BEFORE UPDATE                        *
  *****************************************************************************/
  IF UPDATING('ACC_ACONTAS_NUMERO')            OR
     UPDATING('ACC_ACONTAS_TPDOC')             OR
     UPDATING('ACC_CONTAS_CICLO')              OR
     UPDATING('CON_VALEFRETE_DATARECEBIMENTO') Then
     
    IF (:OLD.ACC_ACONTAS_NUMERO <> :NEW.ACC_ACONTAS_NUMERO) OR
       (:OLD.ACC_ACONTAS_TPDOC  <> :NEW.ACC_ACONTAS_TPDOC) OR
       (:OLD.ACC_CONTAS_CICLO   <> :NEW.ACC_CONTAS_CICLO) OR
       (:OLD.CON_VALEFRETE_DATARECEBIMENTO <> :NEW.CON_VALEFRETE_DATARECEBIMENTO) THEN
       if nvl(:old.CON_VALEFRETE_IMPRESSO,'N') <> 'S' then
          :NEW.CON_VALEFRETE_IMPRESSO := 'S';
       end if;   
    END IF;
 
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_ATU_ACONTAS_IMPR - BEFORE UPDATE                          *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_DATA_PRAZOMAX - BEFORE UPDATE                           *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_DATAPRAZOMAX') Then

   IF ( TO_DATE(:NEW.CON_VALEFRETE_DATAPRAZOMAX, 'dd/MM/yyyy') < TO_DATE(:NEW.CON_VALEFRETE_DATAEMISSAO, 'dd/MM/yyyy')) and (:NEW.con_catvalefrete_codigo <> '07') THEN
      If TDVADM.FN_GET_TPVEICULO(:NEW.CON_VALEFRETE_PLACA,:NEW.CON_VALEFRETE_dataCADASTRO) <> 'UTILITARIO' Then
         RAISE_APPLICATION_ERROR(-20001, 'O PRAZO DE ENTREGA NÃO PODE SER MENOR DO QUE A DATA DE EMISS?O.');
      End If; 
   END IF;   

  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_DATA_PRAZOMAX - BEFORE UPDATE                             *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BU_ATU_CAXMOVIMENTO - BEFORE UPDATE                     *
  *****************************************************************************/
  IF UPDATING('CAX_BOLETIM_DATA')        Or
     UPDATING('CAX_MOVIMENTO_SEQUENCIA') Or
     UPDATING('GLB_ROTA_CODIGOCX')       Then

        IF :OLD.CON_VALEFRETE_STATUS = 'C' THEN
           raise_application_error(-20001,'VALE DE FRETE CANCELADO ' || :NEW.CON_CONHECIMENTO_CODIGO ||'-'||:NEW.CON_CONHECIMENTO_SERIE||'-'||:NEW.GLB_ROTA_CODIGO||'-'||:NEW.CON_VALEFRETE_SAQUE); 
        END IF;


     IF (:NEW.CAX_BOLETIM_DATA IS NOT NULL) THEN
        :NEW.CON_VALEFRETE_IMPRESSO := 'S';
       End If;
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BU_ATU_CAXMOVIMENTO - BEFORE UPDATE                       *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_CON_VALEFRETE_VPEDAGIO - BEFORE UPDATE                  *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_IMPRESSO') Or
     UPDATING('CON_VALEFRETE_STATUS')   Then

    :NEW.CON_VALEFRETE_PGVPEDAGIO := 'N';

    FOR X IN (SELECT CON_CONHECIMENTO_CODIGO,
                     CON_CONHECIMENTO_SERIE,
                     GLB_ROTA_CODIGO
                FROM T_CON_VFRETECONHEC A
               WHERE A.CON_VALEFRETE_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
                 AND A.CON_VALEFRETE_SERIE = :NEW.CON_CONHECIMENTO_SERIE
                 AND A.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO
                 AND A.CON_VALEFRETE_SAQUE = :NEW.CON_VALEFRETE_SAQUE) LOOP
    
      BEGIN
        SELECT CON_FPAGTOMOTPED_CODIGO,
               CON_CONHECVPED_VALOR
          INTO V_FORMAPAGTO_VPED,
               V_VALOR_VPED
          FROM T_CON_CONHECVPED
         WHERE CON_CONHECIMENTO_CODIGO = X.CON_CONHECIMENTO_CODIGO
           AND CON_CONHECIMENTO_SERIE = X.CON_CONHECIMENTO_SERIE
           AND GLB_ROTA_CODIGO = X.GLB_ROTA_CODIGO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_FORMAPAGTO_VPED := NULL;
          V_VALOR_VPED      := NULL;
      END;
    
      IF (V_FORMAPAGTO_VPED IS NOT NULL) THEN
        BEGIN
          SELECT CON_FPAGTOMOTPED_PAGTOVFRETE,
                 CON_FPAGTOMOTPED_CUSTO
            INTO V_MOTPED_VPED,
                 V_COBROCLI_VPED
            FROM T_CON_FPAGTOMOTPED
           WHERE CON_FPAGTOMOTPED_CODIGO = V_FORMAPAGTO_VPED;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_MOTPED_VPED := NULL;
            V_COBROCLI_VPED := NULL;
        END;
      
        IF NVL(V_MOTPED_VPED, 'Q') = 'N' THEN
          :NEW.CON_VALEFRETE_PGVPEDAGIO := 'S';
          --EXIT;
        END IF;
   
        IF NVL(V_COBROCLI_VPED, 'TDV') = 'CLI' THEN
          :NEW.CON_VALEFRETE_PEDPGCLI := 'S';
          --EXIT;
        END IF;
      END IF;
    END LOOP;

  End IF;
  /*****************************************************************************
  *   END: TDVADM.TG_CON_VALEFRETE_VPEDAGIO - BEFORE UPDATE                    *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_INFORMA_DTRETROATIVA - BEFORE UPDATE                    *
  *****************************************************************************/
  IF UPDATING THEN
     FOR X IN (select USU_USUARIO_EMAIL from t_usu_usuario where trim(usu_usuario_codigo) = trim(:new.usu_usuario_codigo)) loop
        V_EMAIL_USUARIO:= X.USU_USUARIO_EMAIL;
     end loop;
     
     IF TRUNC(:NEW.CON_VALEFRETE_DATAEMISSAO) < TRUNC(:NEW.CON_VALEFRETE_DATACADASTRO) THEN
        
     IF (:NEW.CON_CATVALEFRETE_CODIGO = '10' ) AND (:NEW.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL) AND
        (:OLD.CON_VALEFRETE_IMPRESSO IS NULL)  AND (:NEW.CON_VALEFRETE_IMPRESSO = 'A') AND
        (:NEW.CON_VALEFRETE_DATARECEBIMENTO IS NULL)     THEN
        
        --frete previsto para o percurso
        
        V_FPREVISTO := (NVL(:NEW.CON_VALEFRETE_KMPREVISTA,0) * TO_NUMBER(1.50)); 
           
        
        IF (:OLD.USU_USUARIO_CODIGO IS NOT NULL) THEN
            :NEW.USU_USUARIO_CODIGO := :OLD.USU_USUARIO_CODIGO;
            :NEW.CON_VALEFRETE_EMISSOR := :OLD.CON_VALEFRETE_EMISSOR;  
        END IF;
                    
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
                 V_ORIGEM:=  'A LOCALIDADE INFORMADA NÃO FOI ENCONTRADA';
                 V_DESTINO:= 'A LOCALIDADE INFORMADA NÃO FOI ENCONTRADA';
        END;       
        
        BEGIN
           SELECT GLB_ROTA_CODIGO || ' - ' || GLB_ROTA_DESCRICAO
             INTO V_DESC_ROTA
             FROM T_GLB_ROTA
            WHERE GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 V_DESC_ROTA := 'A ROTA INFORMADA NAO FOI ENCONTRADA';
        END;
        
        IF SUBSTR(:NEW.CON_VALEFRETE_PLACA,1,3) <> '000' THEN
        BEGIN
           SELECT A.FRT_VEICULO_CODIGO
             INTO V_CONJUNTO
             FROM T_FRT_VEICULO A
            WHERE A.FRT_VEICULO_PLACA = :NEW.CON_VALEFRETE_PLACA
              AND A.FRT_VEICULO_DATAVENDA IS NULL;
           
           EXCEPTION
           
           WHEN NO_DATA_FOUND THEN
              V_CONJUNTO := :NEW.CON_VALEFRETE_PLACA;
        END;
        
        ELSE
           V_CONJUNTO := :NEW.CON_VALEFRETE_PLACA;   
        
        END IF;
        
        BEGIN
           SELECT USU_USUARIO_NOME
             INTO VUSUARIO
             FROM T_USU_USUARIO
            WHERE USU_USUARIO_CODIGO = :NEW.USU_USUARIO_CODIGO;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 VUSUARIO := 'USUARIO NAO ENCONTRADO';
        END;
        
        BEGIN
           SELECT TERMINAL,
            OS_USER
       INTO V_MAQUINA,
            V_USUARIO_MAQUINA
       FROM V_GLB_AMBIENTE
      WHERE TERMINAL = USERENV('TERMINAL');
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
        
        IF (trim(TO_CHAR(:NEW.CON_VALEFRETE_VALORLIQUIDO,'999,999,990.00')) <> '0.00') THEN
        SP_ENVIAMAIL ('SEQUENCIAL',
                      'tdv.gerenciaop@dellavolpe.com.br;ahebling@dellavolpe.com.br',
                      'Carga de Terceiro com DIVERGENCIA NA DATA: ',
                      'Foi Lancado uma CARGA DE TERCEIRO com DATA RETROATIVA, segue os dados abaixo: ' || CHR(10) || CHR(10) ||
                      'Data do Lancamento no Sistema: ' || :NEW.CON_VALEFRETE_DATACADASTRO || ' - Numero: ' || :NEW.CON_CONHECIMENTO_CODIGO || CHR(10) ||
                    'Data de Emiss?o (Transporte): ' || :NEW.CON_VALEFRETE_DATAEMISSAO || CHR(10) ||
                    'Filial Emitente: ' || V_DESC_ROTA || ' - Emissor: ' || VUSUARIO || CHR(10) ||
                    'Percurso: ' || ' Origem: ' || V_ORIGEM || ' - ' || ' Destino: ' || V_DESTINO || CHR(10) ||
                    'Km do Percurso: ' || :NEW.CON_VALEFRETE_KMPREVISTA || CHR(10) ||
                    'Frete Pago ao Motorista...............: R$  ' || trim(TO_CHAR(:NEW.CON_VALEFRETE_VALORLIQUIDO,'999,999,990.00')) || CHR(10) ||
                    'Frete Previsto para este Percurso.....: R$  ' || trim(TO_CHAR(V_FPREVISTO,'999,999,990.00')) || CHR(10) ||
                      'Remetente: ' || :NEW.CON_VALEFRETE_LOCALCARREG || ' - ' || ' Destinatario: ' || :NEW.CON_VALEFRETE_LOCALDESCARGA || CHR(10) ||
                    'Veiculo/Motorista: ' || V_CONJUNTO || ' - ' || V_MOTORISTA || CHR(10) ||
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
    END IF;
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_INFORMA_DTRETROATIVA - BEFORE UPDATE                      *
  *****************************************************************************/  
  


  /*****************************************************************************
  *   BEGIN: TDVADM.TG_EXCLUI_MINUTAENVIADA - BEFORE UPDATE                    *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_STATUS') Then
    IF :NEW.CON_VALEFRETE_STATUS = 'C' THEN
      DELETE T_UTI_CONTROLEENVIO CE
       WHERE CE.UTI_CONTROLEENVIO_ARQUIVO = SUBSTR('MINUTA',0,6)
         AND CE.CON_CONHECIMENTO_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
         AND CE.CON_CONHECIMENTO_SERIE = :NEW.CON_CONHECIMENTO_SERIE
         AND CE.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO
         AND CE.UTI_CONTROLEENVIO_ARQUIVO = SUBSTR(:NEW.CON_VALEFRETE_SAQUE,6,1);
    END IF;
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_EXCLUI_MINUTAENVIADA - BEFORE UPDATE                      *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BU_C_ATR_VIAGEM - BEFORE UPDATE                         *
  *****************************************************************************/
  IF UPDATING('CON_VALEFRETE_DATAPRAZOMAX') Then
     IF :NEW.CON_CATVALEFRETE_CODIGO IN ('01','02') THEN
        SELECT COUNT(*) TOTAL
          INTO V_TOTAL 
          FROM T_ATR_VIAGEM T 
         WHERE T.CON_CONHECIMENTO_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
           AND T.CON_CONHECIMENTO_SERIE  = :NEW.CON_CONHECIMENTO_SERIE
           AND T.GLB_ROTA_CODIGO         = :NEW.GLB_ROTA_CODIGO
           AND T.CON_VALEFRETE_SAQUE     = :NEW.CON_VALEFRETE_SAQUE;
      
        IF V_TOTAL > 0 THEN
           UPDATE T_ATR_VIAGEM T1
              SET T1.ATR_VIAGEM_DATAPRAZOMAX  = :NEW.CON_VALEFRETE_DATAPRAZOMAX,
                  T1.ATR_VIAGEM_HRPRAZOMAX    =  TO_CHAR(:NEW.CON_VALEFRETE_HORAPRAZOMAX,'HH24:MI'),
                  T1.ATR_VIAGEM_QTDENTREGAS   =  NVL(:NEW.CON_VALEFRETE_ENTREGAS,0),
                  T1.ATR_VIAGEM_KM            =  NVL(:NEW.CON_VALEFRETE_KMPREVISTA,0)
            WHERE T1.CON_CONHECIMENTO_CODIGO  = :NEW.CON_CONHECIMENTO_CODIGO
              AND T1.CON_CONHECIMENTO_SERIE   = :NEW.CON_CONHECIMENTO_SERIE
              AND T1.GLB_ROTA_CODIGO          = :NEW.GLB_ROTA_CODIGO
              AND T1.CON_VALEFRETE_SAQUE      = :NEW.CON_VALEFRETE_SAQUE;
        END IF;   
     END IF;    
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BU_C_ATR_VIAGEM - BEFORE UPDATE                           *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_CON_VFRETECTB - BEFORE UPDATE OR DELETE                 *
  *****************************************************************************/
  IF DELETING                                 Or
   UPDATING('CON_CONHECIMENTO_CODIGO')        Or    
   UPDATING('CON_CONHECIMENTO_SERIE')         Or    
   UPDATING('CON_VIAGEM_NUMERO')              Or    
   UPDATING('GLB_ROTA_CODIGO')                Or    
   UPDATING('GLB_ROTA_CODIGOVIAGEM')          Or    
   UPDATING('CON_VALEFRETE_SAQUE')            Or    
   UPDATING('CON_VALEFRETE_CARRETEIRO')       Or    
   UPDATING('CON_VALEFRETE_PLACASAQUE')       Or    
   UPDATING('CON_VALEFRETE_TIPOTRANSPORTE')   Or    
   UPDATING('CON_VALEFRETE_PLACA')            Or    
   UPDATING('CON_VALEFRETE_LOCALCARREG')      Or    
   UPDATING('CON_VALEFRETE_LOCALDESCARGA')    Or    
   UPDATING('CON_VALEFRETE_PESOINDICADO')     Or    
   UPDATING('CON_VALEFRETE_PESOCOBRADO')      Or    
   UPDATING('CON_VALEFRETE_CUSTOCARRETEIRO')  Or    
   UPDATING('CON_VALEFRETE_TIPOCUSTO')        Or    
   UPDATING('CON_VALEFRETE_PERCMULTA')        Or    
   UPDATING('CON_VALEFRETE_DATACADASTRO')     Or    
   UPDATING('CON_VALEFRETE_EMISSOR')          Or    
   UPDATING('CON_VALEFRETE_FRETE')            Or    
   UPDATING('CON_VALEFRETE_REEMBOLSO')        Or    
   UPDATING('CON_VALEFRETE_ADIANTAMENTO')     Or    
   UPDATING('CON_VALEFRETE_MULTA')            Or    
   UPDATING('CON_VALEFRETE_VALORLIQUIDO')     Or    
   UPDATING('CON_VALEFRETE_COMPROVANTE')      Or    
   UPDATING('CON_VALEFRETE_STATUS')           Or    
   UPDATING('GLB_LOCALIDADE_CODIGO')          Or    
   UPDATING('CON_VALEFRETE_IRRF')             Or    
   UPDATING('CON_VALEFRETE_PEDAGIO')          Or    
   UPDATING('GLB_LOCALIDADE_CODIGODES')       Or    
   UPDATING('CON_VALEFRETE_DATAEMISSAO')      Or    
   UPDATING('CON_VALEFRETE_VALORESTIVA')      Or    
   UPDATING('CON_VALEFRETE_VALORVAZIO')       Or    
   UPDATING('GLB_LOCALIDADE_ORIGEMVAZIO')     Or    
   UPDATING('GLB_LOCALIDADE_DESTINOVAZIO')    Or    
   UPDATING('GLB_LOCALIDADE_CODIGOORI')       Or    
   UPDATING('CON_VALEFRETE_LOTACAO')          Or    
   UPDATING('CON_VALEFRETE_IMPRESSO')         Or    
   UPDATING('CON_VALEFRETE_VALORCOMDESCONTO') Or    
   UPDATING('CON_CATVALEFRETE_CODIGO')        Or    
   UPDATING('GLB_TPMOTORISTA_CODIGO')         Or    
   UPDATING('CON_VALEFRETE_ENLONAMENTO')      Or    
   UPDATING('CON_VALEFRETE_ESTADIA')          Or    
   UPDATING('CON_VALEFRETE_OUTROS')           Or    
   UPDATING('FRT_CONJVEICULO_CODIGO')         Or    
   UPDATING('FRT_MOVVAZIO_NUMERO')            Or    
   UPDATING('GLB_ROTA_CODIGOVAZIO')           Or    
   UPDATING('CON_VALEFRETE_PGVPEDAGIO')       Or    
   UPDATING('CON_VALEFRETE_INSS')             Or    
   UPDATING('CON_VALEFRETE_COFINS')           Or    
   UPDATING('CON_VALEFRETE_CSLL')             Or    
   UPDATING('CON_VALEFRETE_PIS')              Or    
   UPDATING('CON_VALEFRETE_AVARIA')           Or    
   UPDATING('CON_VALEFRETE_SESTSENAT')        Or        
   UPDATING('CON_VALEFRETE_ADTANTERIOR')      Or         
   UPDATING('CON_VALEFRETE_PEDPGCLI')         Or                
   UPDATING('CON_VALEFRETE_DEP') Then

      who_called_me2;

      vERRO := '';
      who_called_me2;

      If :new.glb_rota_codigo = '999' Then
      If instr(upper(nvl(:new.con_valefrete_obs,'sirlano')),'VERSAO') = 0 Then
        raise_application_error(-20001,chr(10) || 
                                       chr(10) || :OLD.CON_CONHECIMENTO_CODIGO || '-' || :OLD.GLB_ROTA_CODIGO || '-' || :old.acc_acontas_numero || CHR(10) ||                                  
                                       '************************************' || chr(10) ||
                                       '    PERIGO SISTEMA DESATUALIZADO    ' || CHR(10)  ||
                                       '    FORCAR UMA ATUALIZACAO          ' || CHR(10)  ||
                                       '    SE PERSISTIR O PROBLEMA LIGUE   ' || CHR(10)  ||
                                       '    PARA O HELP DESK                ' || CHR(10)  ||
                                       '************************************' || chr(10)  ||
                                       DBMS_UTILITY.format_error_backtrace);
                                       
                                       
      End If;
      End If;


      SELECT SUBSTR(OS_USER, 1, 20) OS_USER
        INTO V_USUARIO
        FROM tdvadm.V_GLB_AMBIENTE
       WHERE SESSIONID = SYS_CONTEXT('USERENV', 'SESSIONID');

      -- MODIFICAC?O FEITA PARA PERMITIR QUE O SERGIO E MARY, PUDESSEM ADICIONAR CONHECIMENTOS NOS VALES DE FRETE DA ROTA 026, QUE FORAM
      -- EMITIDOS DURANTE A IMPLANTAC?O DO SISTEMA DA VALE DEVIDO A DIFICULDADES DE EMITIR OS MESMOS NAS ROTAS CORRETAS.
      -- SOLICITADO PELO RONALDO CONVERSADO COMO SIRLANO E EXECUTADA POR ROBERTO PARIZ EM 03/02/2009 AS 11:55
       
       V_ESTOURATRIGGER := FALSE;
       
       
       IF NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_PESOINDICADO <> :OLD.CON_VALEFRETE_PESOINDICADO),FALSE);
          vERRO := vERRO || '1-';
          V_ESTOURATRIGGER := FALSE;
       END IF;
       IF NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_PESOCOBRADO <> :OLD.CON_VALEFRETE_PESOCOBRADO),FALSE);
          vERRO := vERRO || '2-';
          V_ESTOURATRIGGER := FALSE;
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_LOTACAO <> :OLD.CON_VALEFRETE_LOTACAO ),FALSE);
          vERRO := vERRO || '3-';
          V_ESTOURATRIGGER := FALSE;
       END IF;

       
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER := NVL((:NEW.CON_VALEFRETE_TIPOCUSTO <> :OLD.CON_VALEFRETE_TIPOCUSTO),FALSE);
          vERRO := vERRO || '4-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_PERCMULTA <> :OLD.CON_VALEFRETE_PERCMULTA),FALSE);
          vERRO := vERRO || '5-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_DATACADASTRO <> :OLD.CON_VALEFRETE_DATACADASTRO ),FALSE);
          vERRO := vERRO || '6-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_EMISSOR <> :OLD.CON_VALEFRETE_EMISSOR ),FALSE);
          vERRO := vERRO || '7-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_FRETE <> :OLD.CON_VALEFRETE_FRETE ),FALSE);
          vERRO := vERRO || '8-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_REEMBOLSO <> :OLD.CON_VALEFRETE_REEMBOLSO ),FALSE);
          vERRO := vERRO || '9-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_ADIANTAMENTO <> :OLD.CON_VALEFRETE_ADIANTAMENTO ),FALSE);
          vERRO := vERRO || '10-';
       END IF;
       
       if V_ESTOURATRIGGER then
       
          V_ESTOURATRIGGER := not ( :new.con_valefrete_adtanterior  <> :old.con_valefrete_adtanterior );

       end if;

       IF  NOT V_ESTOURATRIGGER THEN
        --  V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_MULTA <> :OLD.CON_VALEFRETE_MULTA ),FALSE);
          vERRO := vERRO || '11-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_VALORLIQUIDO <> :OLD.CON_VALEFRETE_VALORLIQUIDO ),FALSE);
          vERRO := vERRO || '12- ' || to_char(:NEW.CON_VALEFRETE_VALORLIQUIDO) || '-' || to_char(:OLD.CON_VALEFRETE_VALORLIQUIDO) ;
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_STATUS <> :OLD.CON_VALEFRETE_STATUS ),FALSE);
          vERRO := vERRO || '13-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_IRRF <> :OLD.CON_VALEFRETE_IRRF ),FALSE);
          vERRO := vERRO || '14-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_PEDAGIO <> :OLD.CON_VALEFRETE_PEDAGIO ),FALSE);
          vERRO := vERRO || '15-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_DATAEMISSAO <> :OLD.CON_VALEFRETE_DATAEMISSAO ),FALSE);
          vERRO := vERRO || '16-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_VALORESTIVA <> :OLD.CON_VALEFRETE_VALORESTIVA ),FALSE);
          vERRO := vERRO || '17-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_VALORVAZIO <> :OLD.CON_VALEFRETE_VALORVAZIO ),FALSE);
          vERRO := vERRO || '18-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_IMPRESSO <> :OLD.CON_VALEFRETE_IMPRESSO ),FALSE);
          vERRO := vERRO || '19-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          --V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_VALORCOMDESCONTO <> :OLD.CON_VALEFRETE_VALORCOMDESCONTO ),FALSE);
          vERRO := vERRO || '20-' || :NEW.CON_VALEFRETE_VALORCOMDESCONTO || '-' || :OLD.CON_VALEFRETE_VALORCOMDESCONTO;
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER := NVL((:NEW.CON_VALEFRETE_ENLONAMENTO <> :OLD.CON_VALEFRETE_ENLONAMENTO ),FALSE);
          vERRO := vERRO || '21-';
       END IF;
       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_ESTADIA <> :OLD.CON_VALEFRETE_ESTADIA ),FALSE);
          vERRO := vERRO || '22-';
       END IF;
       IF   NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_OUTROS <> :OLD.CON_VALEFRETE_OUTROS ),FALSE);
          vERRO := vERRO || '23-';
       END IF;
       IF   NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_INSS <> :OLD.CON_VALEFRETE_INSS ),FALSE);
          vERRO := vERRO || '24-';
       END IF;
       IF   NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_COFINS <> :OLD.CON_VALEFRETE_COFINS ),FALSE);
          vERRO := vERRO || '25-';
       END IF;
       IF   NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_CSLL <> :OLD.CON_VALEFRETE_CSLL ),FALSE);
          vERRO := vERRO || '26-';
       END IF;
       IF   NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_PIS <> :OLD.CON_VALEFRETE_PIS ),FALSE);
          vERRO := vERRO || '27-';
       END IF;
       IF   NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_AVARIA <> :OLD.CON_VALEFRETE_AVARIA ),FALSE);
          vERRO := vERRO || '28-';
       END IF;
       IF NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_SESTSENAT <> :OLD.CON_VALEFRETE_SESTSENAT ),FALSE);
          vERRO := vERRO || '29-';
       END IF;
       IF   NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_DEP <> :OLD.CON_VALEFRETE_DEP ),FALSE);
          vERRO := vERRO || '30-';
       END IF;   

       IF  NOT V_ESTOURATRIGGER THEN
          V_ESTOURATRIGGER :=  NVL((:NEW.CON_VALEFRETE_VALORRATEIO = :OLD.CON_VALEFRETE_VALORRATEIO ),FALSE);
          vERRO := vERRO || '31-';
          V_ESTOURATRIGGER := FALSE;
       END IF;

      IF UPPER(TRIM(V_USUARIO)) NOT IN ('SDRUMOND') THEN
      
        IF TRIM(:NEW.GLB_TPMOTORISTA_CODIGO) NOT IN ('F') and
           (:new.CON_CATVALEFRETE_CODIGO <> '10') and
           :new.CON_CONHECIMENTO_CODIGO <> '009630' THEN
        
          select count(*)
            into nTOTAL
            from user_tab_columns c
           where c.TABLE_NAME = 'T_CON_VALEFRETE';
        
          ncoluna := 'daniel ';
        
          If deleting then
            ncoluna := 'Deletando - ';
          Else
            ncoluna := 'Atualizando - ';
          End If;
          -- foi colocado este vale de frete para fazer teste
          -- de qual coluna foi alterada.    
          if :new.CON_CONHECIMENTO_CODIGO = '009630' and
             :new.GLB_ROTA_CODIGO = '023' then
          
            begin
              for r_COLUNAS in c_COLUNAS LOOP
                IF UPDATING(R_COLUNAS.COLUMN_NAME) THEN
                  V_CURSORID := DBMS_SQL.OPEN_CURSOR;
                  V_FRASESQL := 'SELECT DECODE(:NEW.' || R_COLUNAS.COLUMN_NAME ||
                                ',:OLD.' || R_COLUNAS.COLUMN_NAME ||
                                ',''NAO'',''SIM''),SYSDATE FROM DROPME';
                  --         V_FRASESQL := 'SELECT ''SIM'',SYSDATE FROM DROPME';
                  DBMS_SQL.PARSE(V_CURSORID, V_FRASESQL, DBMS_SQL.V7);
                  DBMS_SQL.DEFINE_COLUMN(V_CURSORID, 1, VI_TESTE, 3);
                  DBMS_SQL.DEFINE_COLUMN(V_CURSORID, 2, VI_TESTE2, 10);
                  V_TEMPORARIA := DBMS_SQL.EXECUTE(V_CURSORID);
                  IF DBMS_SQL.FETCH_ROWS(V_CURSORID) = 0 THEN
                    EXIT;
                  END IF;
                  DBMS_SQL.COLUMN_VALUE(V_CURSORID, 1, VI_TESTE);
                  IF VI_TESTE = 'SIM' THEN
                    RAISE_APPLICATION_ERROR(-20001,
                                            'COLUNA ' || R_COLUNAS.COLUMN_NAME ||
                                            ' ALTERADA ' || VI_TESTE);
                  END IF;
                                
                  if ndado1 <> NDADO2 Then
                    ncoluna := TRIM(ncoluna) || 'S';
                  else
                    ncoluna := TRIM(ncoluna) || 'N';
                  end if;
                ELSE
                  ncoluna := TRIM(ncoluna) || 'N';
                END IF;
                nTOTAL := nTOTAL - 1;
                if nTOTAL <= 0 then
                  exit;
                end if;
              END LOOP;
            exception
              when others then
                RAISE_APPLICATION_ERROR(-20001,
                                        TRIM(ncoluna) || ' ERRO -> ' || SQLERRM);
            end;
          
            ncoluna := trim(ncoluna) || '-fim';
          end if;
        
          if :new.CON_CONHECIMENTO_CODIGO = '084081' and
             :new.GLB_ROTA_CODIGO = '020' then
            RAISE_APPLICATION_ERROR(-20001, TRIM(ncoluna)); -- SUBSTR(ncoluna,15,120));
          end if;
        
          SELECT COUNT(*) TOTAL
            INTO nTOTAL
            FROM tdvadm.T_CTB_LOGTRANSF L
           WHERE L.CTB_LOGTRANSF_REFERENCIA > vRef
             AND L.CTB_LOGTRANSF_SISTEMA = 'VLF';
             
          If nTOTAL = 0  Then
            -- Mostra que o periodo ja esta fechado
             SELECT count(*) --P.USU_PERFIL_CODIGO,P.USU_PERFIL_PARAT REFERENCIA
                INTO nTOTAL
             FROM T_USU_PERFIL P
             WHERE P.USU_APLICACAO_CODIGO = '0000000000'
               AND TRIM(P.USU_PERFIL_CODIGO) = 'REFFECHAMENTOVFC'          
               and P.USU_PERFIL_PARAT >= vRef;
          End IF;

          IF (nTOTAL <> 0) or ( V_ESTOURATRIGGER )  THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'ESTE DOCUMENTO ' ||
                                    :old.CON_CONHECIMENTO_CODIGO || ' DA ROTA ' ||
                                    :OLD.GLB_ROTA_CODIGO ||
                                    ' NÃO PODE SER ALTERADO.' || CHR(10) ||
                                    'DEVIDO A CONTABILIDADE REF.: ' ||
                                    TO_CHAR(:OLD.CON_VALEFRETE_DATACADASTRO,
                                            'YYYYMM') ||
                                    ' ESTAR EM FECHAMENTO OU FECHADA' ||
                                    'nOTOTAL ' || nTOTAL || '-'||
                                    ' erro - ' || TRIM(vERRO) );
    --                                ' Coluna ALTERADA ' || ncoluna);
          END IF;
          -- VERIFICA TABELA DE IMPOSTOS               
          SELECT COUNT(*)
            INTO nTOTAL
            FROM tdvadm.T_CON_VALEFRETEIMPOSTOS I
           WHERE I.CON_VALEFRETE_IMPOSTOS_REF =
                 TO_CHAR(:OLD.CON_VALEFRETE_DATACADASTRO, 'MM/YYYY')
             AND I.CAR_PROPRIETARIO_CGCCPFCODIGO =
                 (SELECT V.CAR_PROPRIETARIO_CGCCPFCODIGO
                    FROM tdvadm.T_CAR_VEICULO V
                   WHERE V.CAR_VEICULO_PLACA = :OLD.CON_VALEFRETE_PLACA
                     AND V.CAR_VEICULO_SAQUE = :OLD.CON_VALEFRETE_PLACASAQUE)
             AND I.CON_VALEFRETEIMPOSTOS_DTRECOL IS NOT NULL;
        
          IF (nTOTAL <> 0) AND ( V_ESTOURATRIGGER )  THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'ESTE DOCUMENTO ' ||
                                    :old.CON_CONHECIMENTO_CODIGO || ' DA ROTA ' ||
                                    :OLD.GLB_ROTA_CODIGO ||
                                    ' NÃO PODE SER ALTERADO.' || CHR(10) ||
                                    'DEVIDO OS IMPOSTOS JA RECOLHIDOS' ||
                                    ' erro - ' || TRIM(vERRO) );
    --                                ' Coluna ALTERADA ' || ncoluna);
          END IF;
        
          IF nTOTAL > 0 THEN
            nTOTAL := nTOTAL;
          ELSE
            nTOTAL := 0;
          END IF;
        
          SELECT COUNT(*) TOTAL
            INTO nTOTAL
            FROM tdvadm.T_CTB_LOGTRANSF L
           WHERE L.CTB_LOGTRANSF_REFERENCIA =
                 TO_CHAR(:NEW.CAX_BOLETIM_DATA, 'YYYYMM')
             AND L.CTB_LOGTRANSF_SISTEMA = 'CAX';
        
          IF (nTOTAL <> 0) AND ( V_ESTOURATRIGGER )  THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'ESTE DOCUMENTO ' ||
                                    :old.CON_CONHECIMENTO_CODIGO || ' DA ROTA ' ||
                                    :OLD.GLB_ROTA_CODIGO ||
                                    ' NÃO PODE SER ALTERADO.' || CHR(10) ||
                                    'CAIXA FECHADO' || ' Coluna ALTERADA ' ||
                                    ' erro - ' || TRIM(vERRO) );
    --                                ncoluna);
          END IF;
        
          IF NVL(:NEW.CAX_BOLETIM_DATA, TO_DATE('23/02/1979', 'DD/MM/YYYY')) <>
             NVL(:OLD.CAX_BOLETIM_DATA, TO_DATE('23/02/1979', 'DD/MM/YYYY')) THEN
            nTOTAL := 0;
          END IF;
        
          IF NVL(:NEW.CAX_MOVIMENTO_SEQUENCIA, 0) <>
             NVL(:OLD.CAX_MOVIMENTO_SEQUENCIA, 0) THEN
            nTOTAL := 0;
          END IF;
        
          IF NVL(:NEW.GLB_ROTA_CODIGOCX, '000') <>
             NVL(:OLD.GLB_ROTA_CODIGOCX, '000') THEN
            nTOTAL := 0;
          END IF;
        
          -- CARTA DE EXTRAVI0
        
          IF (:NEW.USU_USUARIO_CODIGO_AUTORIZA) <> 'TDVADM2' THEN
            nTOTAL := 0;
          END IF;
        
          IF (:NEW.CON_VALEFRETE_DTAUTORIZA) <> '01/01/1900' THEN
            nTOTAL := 0;
          END IF;
        
          IF (:NEW.CON_VALEFRETE_IMPRESSO) = 'S' AND
             (:OLD.CON_VALEFRETE_IMPRESSO) = 'A' AND
             (:OLD.CON_CATVALEFRETE_CODIGO = '10') THEN
            nTOTAL := 0;
          END IF;
          IF (:NEW.CON_VALEFRETE_IMPRESSO = 'S') AND
             (NVL(:OLD.CON_VALEFRETE_IMPRESSO, 'N') = 'N') THEN
            nTOTAL := 0;
          END IF;
          IF (nTOTAL <> 0) AND ( V_ESTOURATRIGGER )  THEN
               RAISE_APPLICATION_ERROR(-20001,
                                    'ESTE DOCUMENTO ' ||
                                    :old.CON_CONHECIMENTO_CODIGO || ' DA ROTA ' ||
                                    :OLD.GLB_ROTA_CODIGO ||
                                    ' NÃO PODE SER ALTERADO.' || CHR(10) ||
                                    'DEVIDO A CONTABILIDADE REF.: ' ||
                                    TO_CHAR(:OLD.CON_VALEFRETE_DATACADASTRO,
                                            'YYYYMM') || ' JA ESTA FECHADA' ||
                                    ' erro - ' || TRIM(vERRO) );
    --                                ' Coluna ALTERADA ' || ncoluna);
          END IF;
        END IF;
      END IF; -- Colocado para Fechar o Primeiro IF referente aos usuarios

  End If;  
  /*****************************************************************************
  *   END: TDVADM.TG_CON_VFRETECTB - BEFORE UPDATE OR DELETE                   *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BUD_CARGA_TERCEIRO - BEFORE UPDATE OR DELETE            *
  *****************************************************************************/
  IF UPDATING OR DELETING THEN
   IF deleting THEN
      v_acao := 'EXCLUIDA';
   ELSE
     v_acao := 'INCLUIDA';
   END IF;     

   FOR X IN (select USU_USUARIO_EMAIL from t_usu_usuario where trim(usu_usuario_codigo) = trim(:new.usu_usuario_codigo)) loop
        V_EMAIL_USUARIO:= X.USU_USUARIO_EMAIL;
   end loop;
   

   IF ( :NEW.CON_CATVALEFRETE_CODIGO = '10' ) AND 
      ( :NEW.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL) AND
      ( NVL(:NEW.CON_VALEFRETE_IMPRESSO,'N') = 'S') AND
      ( substr(:new.con_valefrete_placa,1,3) = '000' ) AND
      ( nvl(:new.con_valefrete_status,'N') = 'C' ) THEN 

         SELECT COUNT(*)
           into   vAuxiliar
        FROM T_CRP_TITRECEBER TR
        WHERE TR.CRP_TITRECEBER_NUMTITULO = :new.CON_CONHECIMENTO_CODIGO
          AND TR.GLB_ROTA_CODIGO = :new.GLB_ROTA_CODIGO;
          
        If vAuxiliar > 0 Then
           raise_application_error(-20033,'***************************************************' || chr(10) || chr(10) || 
                                          'Vale de Terceiro Contem Titulo, Impossivel Cancelar' || chr(10) || chr(10) ||
                                          '***************************************************');
        End If;
        
   End If;



  
   IF (:NEW.CON_CATVALEFRETE_CODIGO = '10' ) AND 
      (:NEW.CON_VALEFRETE_VALORLIQUIDO IS NOT NULL) AND
      (:OLD.CON_VALEFRETE_IMPRESSO IS NULL)  AND 
      (:NEW.CON_VALEFRETE_IMPRESSO = 'A') AND
      (:NEW.CON_VALEFRETE_DATARECEBIMENTO IS NULL)     THEN
      
      --frete previsto para o percurso
      
      V_FPREVISTO := (NVL(:NEW.CON_VALEFRETE_KMPREVISTA,0) * TO_NUMBER(1.50)); 
         
      
      IF (:OLD.USU_USUARIO_CODIGO IS NOT NULL) THEN
          :NEW.USU_USUARIO_CODIGO := :OLD.USU_USUARIO_CODIGO;
          :NEW.CON_VALEFRETE_EMISSOR := :OLD.CON_VALEFRETE_EMISSOR;  
      END IF;
                  
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
               V_ORIGEM:=  'A LOCALIDADE INFORMADA NÃO FOI ENCONTRADA';
               V_DESTINO:= 'A LOCALIDADE INFORMADA NÃO FOI ENCONTRADA';
      END;       
      
      BEGIN
         SELECT GLB_ROTA_CODIGO || ' - ' || GLB_ROTA_DESCRICAO
           INTO V_DESC_ROTA
           FROM T_GLB_ROTA
          WHERE GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               V_DESC_ROTA := 'A ROTA INFORMADA NAO FOI ENCONTRADA';
      END;
      
      IF SUBSTR(:NEW.CON_VALEFRETE_PLACA,1,3) <> '000' THEN
      BEGIN
         BEGIN
            SELECT A.FRT_VEICULO_CODIGO
              INTO V_CONJUNTO
              FROM T_FRT_VEICULO A
             WHERE A.FRT_VEICULO_PLACA = :NEW.CON_VALEFRETE_PLACA
               AND A.FRT_VEICULO_DATAVENDA IS NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  V_CONJUNTO := NULL;
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20001,'PLACA --> ' || V_CONJUNTO);
         END;
         
/*         BEGIN
            SELECT TRIM(T.CAR_PROPRIETARIO_CGCCPFCODIGO)
              INTO V_CGC_PROPRIETARIO
              FROM T_CAR_VEICULO T
             WHERE T.CAR_VEICULO_PLACA = TRIM(:NEW.CON_VALEFRETE_PLACA)
               AND T.CAR_VEICULO_SAQUE = TRIM(:NEW.CON_VALEFRETE_PLACASAQUE)
               AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  V_CGC_PROPRIETARIO := NULL;
         END;*/
         
/*         BEGIN 
            SELECT C.CAR_CARRETEIRO_SAQUE 
              INTO V_CAR_CARRETEIRO_SAQUE
              FROM T_CAR_CARRETEIRO C
            WHERE C.CAR_VEICULO_PLACA = :NEW.CON_VALEFRETE_PLACA
              AND C.CAR_VEICULO_SAQUE = :NEW.CON_VALEFRETE_PLACASAQUE
              AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 V_CAR_CARRETEIRO_SAQUE := NULL;
         END;*/
      
      END;
      ELSE
         V_CONJUNTO := :NEW.CON_VALEFRETE_PLACA;   
           
      END IF;
      
      BEGIN
         SELECT USU_USUARIO_NOME
           INTO V_USUARIO
           FROM T_USU_USUARIO
          WHERE USU_USUARIO_CODIGO = :NEW.USU_USUARIO_CODIGO;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               V_USUARIO := 'USUARIO NAO ENCONTRADO';
      END;
      
      BEGIN
         SELECT TERMINAL,
          OS_USER
     INTO V_MAQUINA,
          V_USUARIO_MAQUINA
     FROM V_GLB_AMBIENTE
    WHERE TERMINAL = USERENV('TERMINAL');
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
             
      IF (trim(TO_CHAR(:NEW.CON_VALEFRETE_VALORLIQUIDO,'999,999,990.00')) <> '0.00') THEN
      SP_ENVIAMAIL ('SEQUENCIAL',
--     21/06/2021 - Sirlano
-- retirado o email tdv.spadm@dellavolpe.com.br
-- caixa lotada
--                    'tdv.spexpedicao@dellavolpe.com.br;grp.rastreamento@dellavolpe.com.br;tdv.spadm@dellavolpe.com.br;'||trim(V_EMAIL_USUARIO),
                    'tdv.spexpedicao@dellavolpe.com.br;grp.rastreamento@dellavolpe.com.br;'||trim(V_EMAIL_USUARIO),
                    'Carga de Terceiro '|| v_acao || ' : ' || V_CONJUNTO ||' Data: ' || TO_CHAR(SYSDATE,'DD/MM/YYYY - HH24:MI:SS'),
                    'Data do Vale Frete: ' || :NEW.CON_VALEFRETE_DATACADASTRO || ' - Numero: ' || :NEW.CON_CONHECIMENTO_CODIGO || CHR(10) ||
                    'Filial Emitente: ' || V_DESC_ROTA || ' - Emissor: ' || V_USUARIO || CHR(10) ||
                    'Percurso: ' || ' Origem: ' || V_ORIGEM || ' - ' || ' Destino: ' || V_DESTINO || CHR(10) ||
                    'Km do Percurso: ' || :NEW.CON_VALEFRETE_KMPREVISTA || CHR(10) ||
                    'Frete Contratado......................: R$  ' || trim(TO_CHAR(:NEW.CON_VALEFRETE_FRETE,'999,999,990.00')) || CHR(10) ||
                    --'Frete Pago ao Motorista...............: R$  ' || trim(TO_CHAR(:NEW.CON_VALEFRETE_VALORLIQUIDO,'999,999,990.00')) || CHR(10) ||
                    'Frete Previsto para este Percurso.....: R$  ' || trim(TO_CHAR(V_FPREVISTO,'999,999,990.00')) || CHR(10) ||
                    'Remetente: ' || :NEW.CON_VALEFRETE_LOCALCARREG || ' - ' || ' Destinatario: ' || :NEW.CON_VALEFRETE_LOCALDESCARGA || CHR(10) ||
                    'Veiculo/Motorista: ' || V_CONJUNTO || ' - ' || V_MOTORISTA || CHR(10) ||
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
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BUD_CARGA_TERCEIRO - BEFORE UPDATE OR DELETE              *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BUD_VERIFICAMDFE - BEFORE UPDATE OR DELETE              *
  *****************************************************************************/
  IF UPDATING THEN
     /*********************************************************/ 
     /*** ANALISE NUMERO DO VEICULO DISPONIVEL              ***/
     /*********************************************************/
     begin
      select vvf.fcf_veiculodisp_codigo,
             vvf.fcf_veiculodisp_sequencia
        into vVeicDispCod,
             vVeicDispSeq
        from t_con_veicdispvf vvf
       where vvf.con_conhecimento_codigo = :OLD.CON_CONHECIMENTO_CODIGO
         and vvf.con_conhecimento_serie  = :OLD.CON_CONHECIMENTO_SERIE
         and vvf.glb_rota_codigo         = :OLD.GLB_ROTA_CODIGO
         and vvf.con_valefrete_saque     = :OLD.CON_VALEFRETE_SAQUE;
    exception when others then
      If UPDATING Then
         vMsg := 'UPDATING ';
      End If;
      If DELETING Then
         vMsg := 'DELETING ';
      End If;
      
      vMsg := vMsg || 'NEW ' || :new.FCF_VEICULODISP_CODIGO || '-' || :new.CON_CONHECIMENTO_CODIGO || '-' || :new.CON_CONHECIMENTO_SERIE || '-' || :new.GLB_ROTA_CODIGO || '-' || :new.CON_VALEFRETE_SAQUE || chr(10) ||
                      'OLD ' || :OLD.FCF_VEICULODISP_CODIGO || '-' || :OLD.CON_CONHECIMENTO_CODIGO || '-' || :OLD.CON_CONHECIMENTO_SERIE || '-' || :OLD.GLB_ROTA_CODIGO || '-' || :OLD.CON_VALEFRETE_SAQUE || chr(10) || 
              sqlerrm;
       vVeicDispCod := :OLD.FCF_VEICULODISP_CODIGO;  
       vVeicDispSeq := :OLD.FCF_VEICULODISP_SEQUENCIA;
    end;
     /*********************************************************/     
      -- Se deletano
      If (DELETING) Then
        if (vVeicDispCod is not null) and (vVeicDispSeq is not null) then 
            -- Analise de MDF-e não Cancelados
            pkg_con_valefrete.Sp_ExisteMDFeNaoCancelado(vVeicDispCod,
                                                        vVeicDispSeq,
                                                        vStatus,
                                                        vMessage);
            if (vStatus <> pkg_glb_common.Status_Nomal) then
              raise_application_error(-20001, vMessage);
            end if;
        end if;
      Else 
        -- No Cancelamento
        IF ( :NEW.CON_VALEFRETE_STATUS = 'C' ) AND ( NVL(:OLD.CON_VALEFRETE_STATUS,'N') = 'N' ) THEN
          if (vVeicDispCod is not null) and (vVeicDispSeq is not null) then 
              -- Analise de MDF-e não Cancelados
              select count(*)
                into vAuxiliar
              from tdvadm.t_con_vfreteconhec vfc
              where vfc.con_valefrete_codigo = :OLD.CON_CONHECIMENTO_CODIGO
                and vfc.con_valefrete_serie = :OLD.CON_CONHECIMENTO_SERIE
                and vfc.glb_rota_codigovalefrete = :OLD.GLB_ROTA_CODIGO
                and vfc.con_valefrete_saque = :OLD.CON_VALEFRETE_SAQUE
                and tdvadm.pkg_slf_utilitarios.fn_retorna_contratoCod(vfc.con_conhecimento_codigo,
                                                                      vfc.con_conhecimento_serie,
                                                                      vfc.glb_rota_codigo) = 'C5900010739';
              If vAuxiliar = 0 Then                                                        
                  pkg_con_valefrete.Sp_ExisteMDFeNaoCancelado(vVeicDispCod,
                                                              vVeicDispSeq,
                                                              vStatus,
                                                              vMessage);
                  if (vStatus <> pkg_glb_common.Status_Nomal) then
                    raise_application_error(-20002, vMessage);
                  End if;
             End If;
          end if;
        End if;
      End If;
  END IF;
  /*****************************************************************************
  *   END: TDVADM.TG_BUD_VERIFICAMDFE - BEFORE UPDATE OR DELETE                *
  *****************************************************************************/  

  /*****************************************************************************
  *   BEGIN: TDVADM.TG_BDU_C_ALTER_VF - BEFORE UPDATE OR DELETE                *
  *****************************************************************************/
  IF DELETING                                 Or
   UPDATING('CON_CONHECIMENTO_CODIGO')        Then    
      who_called_me2;
      sContinua := False;

      if :old.con_conhecimento_codigo in('022140') then  
         vContador := 0;
      end if;   


      If ( vContador > 0 ) Then
        
        raise_application_error(-20001,chr(10) || 
                                       '***********************************************************' || chr(10) ||
                                       '***                VALE DE FRETE CONTABILIZADO          ***' || CHR(10) ||
                                       '***                IMPOSSIVEL PROSSEGUIR                ***' || chr(10) ||
                                       '***********************************************************' || chr(10));
      End If;      

      IF UPDATING THEN
        
        /***************************************************/
        /***************KLAYTON A PEDIDO DO SIRLANO*********/
        /***************************************************/
        IF NVL(:NEW.CON_VALEFRETE_IMPRESSO,'N') <> 'S' THEN
           :NEW.CON_VALEFRETE_DATACADASTRO := trunc(SYSDATE);
        END IF;
        /***************************************************/
        
        IF :NEW.CON_VALEFRETE_STATUS IS NULL AND
           :OLD.CON_VALEFRETE_STATUS = 'C' THEN
          sTipoAlteracao := 'DESCANCELAMENTO DO VF --> ' ||
                            :OLD.CON_CONHECIMENTO_CODIGO || ' - ' ||
                            :OLD.GLB_ROTA_CODIGO || ' - ' ||
                            :OLD.CON_VALEFRETE_SAQUE || ' - ' ||
                            :OLD.CON_CONHECIMENTO_SERIE;
          sContinua      := True;
        END IF;
      
        IF :NEW.CON_VALEFRETE_IMPRESSO IS NULL AND
           :OLD.CON_VALEFRETE_IMPRESSO = 'S' THEN
          sTipoAlteracao := 'RETIRADA DE IMPRESSAO DO VF --> ' ||
                            :OLD.CON_CONHECIMENTO_CODIGO || ' - ' ||
                            :OLD.GLB_ROTA_CODIGO || ' - ' ||
                            :OLD.CON_VALEFRETE_SAQUE || ' - ' ||
                            :OLD.CON_CONHECIMENTO_SERIE;
          sContinua      := True;
        END IF;
      
        IF :NEW.CON_VALEFRETE_IMPRESSO IS NULL AND
           :OLD.CON_VALEFRETE_IMPRESSO = 'S' AND
           :OLD.CON_VALEFRETE_STATUS = 'C' THEN
          sTipoAlteracao := 'RETIRADA DE IMPRESSAO DE VF CANCELADO --> ' ||
                            :OLD.CON_CONHECIMENTO_CODIGO || ' - ' ||
                            :OLD.GLB_ROTA_CODIGO || ' - ' ||
                            :OLD.CON_VALEFRETE_SAQUE || ' - ' ||
                            :OLD.CON_CONHECIMENTO_SERIE;
          sContinua      := True;
        END IF;
      END IF;

      IF DELETING THEN
      
        sTipoAlteracao := 'EXCLUSAO DO VALE FRETE --> ' ||
                          :OLD.CON_CONHECIMENTO_CODIGO || ' - ' ||
                          :OLD.GLB_ROTA_CODIGO || ' - ' ||
                          :OLD.CON_VALEFRETE_SAQUE || ' - ' ||
                          :OLD.CON_CONHECIMENTO_SERIE;
        sContinua      := True;
      
        SELECT GLB_ALTMAN_SEQUENCIA.NEXTVAL INTO V_CODALTMAN FROM DUAL;
      
        INSERT INTO T_GLB_ALTMAN
        VALUES
          (V_CODALTMAN,
           'VFR',
           :OLD.CON_CONHECIMENTO_CODIGO,
           TRIM(:OLD.CON_CONHECIMENTO_SERIE) || '-' || :OLD.CON_VALEFRETE_SAQUE,
           :OLD.GLB_ROTA_CODIGO);
      
        INSERT INTO T_GLB_DETALHEALTMAN
        VALUES
          (V_CODALTMAN,
           SYSDATE,
           'DOCUMENTO EXCLUIDO',
           NULL,
           SYS_CONTEXT('USERENV', 'OS_USER'),
           SYS_CONTEXT('USERENV', 'HOST') || '-' ||
           SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
           SYSDATE,
           1,
           'E');
      
      END IF;

      IF :OLD.GLB_TPMOTORISTA_CODIGO = 'A' THEN
        nFrete := NVL(:OLD.CON_VALEFRETE_VALORCOMDESCONTO, 0) -
                  NVL(:OLD.CON_VALEFRETE_PEDAGIO, 0);
      ELSIF :OLD.GLB_TPMOTORISTA_CODIGO = 'C' THEN
        nFrete := NVL(:OLD.CON_VALEFRETE_FRETE, 0);
      END IF;

      nIR        := NVL(:OLD.CON_VALEFRETE_IRRF, 0);
      nSESTSENAT := NVL(:OLD.CON_VALEFRETE_SESTSENAT, 0);
      nINSS      := NVL(:OLD.CON_VALEFRETE_INSS, 0);
/*      nQTDVF     := 1;*/

      BEGIN
        SELECT A.CAR_PROPRIETARIO_CGCCPFCODIGO
          INTO sProprietario
          FROM T_CAR_VEICULO A
         WHERE A.CAR_VEICULO_PLACA = :OLD.CON_VALEFRETE_PLACA
           AND A.CAR_VEICULO_SAQUE = :OLD.CON_VALEFRETE_PLACASAQUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          sProprietario := NULL;
      END;

      BEGIN
        SELECT A.CAR_PROPRIETARIO_RAZAOSOCIAL
          INTO sProprietarioNome
          FROM T_CAR_PROPRIETARIO A
         WHERE A.CAR_PROPRIETARIO_CGCCPFCODIGO = sProprietario;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          sProprietarioNome := NULL;
      END;

      BEGIN
        SELECT NVL(B.CON_VALEFRETE_IMPOSTOSVLRACUMU, 0),
               NVL(B.CON_VALEFRETE_IMPOSTOS_IRRF, 0),
               NVL(B.CON_VALEFRETE_IMPOSTOS_SS, 0),
               NVL(B.CON_VALEFRETE_IMPOSTOS_INSS, 0)
/*               ,NVL(B.CON_VALEFRETE_IMPOSTOS_QTDVF, 0)*/
          INTO nVlrAcumulado,
               nIRacumulado,
               nSESTSENATacumulado,
               nINSSacumulado
/*               ,nQTDVFacumulado*/
          FROM T_CON_VALEFRETEIMPOSTOS B
         WHERE B.CAR_PROPRIETARIO_CGCCPFCODIGO = sPROPRIETARIO
           AND B.CON_VALEFRETE_IMPOSTOS_REF =
               TO_CHAR(:OLD.CON_VALEFRETE_DATAEMISSAO, 'MM/YYYY');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          nVlrAcumulado       := 0;
          nIRacumulado        := 0;
          nSESTSENATacumulado := 0;
          nINSSacumulado      := 0;
/*          nQTDVFacumulado     := 0;*/
      END;

      BEGIN

        IF sContinua then
        
          SP_ENVIAMAIL('SEQUENCIAL',
                       'mneves@dellavolpe.com.br;tdv.assgeradmin@dellavolpe.com.br;',
                       Trim(sTipoAlteracao),
                       'Data ..................: ' || SYSDATE || CHR(13) ||
                       'Vale Frete NR..........: ' ||
                       :OLD.CON_CONHECIMENTO_CODIGO || CHR(13) ||
                       'Data de Emiss?o........: ' ||
                       :OLD.CON_VALEFRETE_DATAEMISSAO || CHR(13) ||
                       'Rota...................: ' || :OLD.GLB_ROTA_CODIGO ||
                       CHR(13) || 'Serie..................: ' ||
                       :OLD.CON_CONHECIMENTO_SERIE || CHR(13) ||
                       'Saque..................: ' || :OLD.CON_VALEFRETE_SAQUE ||
                       CHR(13) || 'Status de Impress?o....: ' ||
                       :OLD.CON_VALEFRETE_IMPRESSO || CHR(13) ||
                       'Placa..................: ' || :OLD.CON_VALEFRETE_PLACA ||
                       CHR(13) || 'Proprietario...........: ' ||
                       Trim(sProprietario) || ' - ' || Trim(sProprietarioNome) ||
                       CHR(13) || CHR(13) || 'VALORES/IMPOSTOS ACUMULADOS:' ||
                       CHR(13) || 'Frete.....: R$ ' || nVlrAcumulado || CHR(13) ||
                       'IRRF......: R$ ' || nIRacumulado || CHR(13) ||
                       'INSS......: R$ ' || nINSSacumulado || CHR(13) ||
                       'SESTSENAT.: R$ ' || nSESTSENATacumulado || CHR(13) ||
                       CHR(13) || 'VALORES/IMPOSTOS DO VALE FRETE:' || CHR(13) ||
                       'Frete.....: R$ ' || nFrete || CHR(13) ||
                       'IRRF......: R$ ' || nIR || CHR(13) || 'INSS......: R$ ' ||
                       nINSS || CHR(13) || 'SESTSENAT.: R$ ' || nSESTSENAT ||
                       CHR(13) || CHR(13) || 'ATENC?O: DADOS DA ALTERACAO.' ||
                       CHR(13) || CHR(13) || 'Rotina.......................: ' ||
                       'TG_ALTER_VF' || CHR(13) ||
                       'Data.........................: ' ||
                       TO_CHAR(SYSDATE, 'DD/MM/YYYY - HH24:MI:SS') || CHR(13) ||
                       'Maquina Utilizada............: ' ||
                       SYS_CONTEXT('USERENV', 'TERMINAL') || CHR(13) ||
                       'Usuario Logado na Maquina....: ' ||
                       SYS_CONTEXT('USERENV', 'OS_USER') || CHR(13) ||
                       'IP da utilizado..............: ' ||
                       SYS_CONTEXT('USERENV', 'IP_ADDRESS') || CHR(13) || ' ' ||
                       CHR(13) || '',
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
      
      EXCEPTION
        WHEN OTHERS THEN
        raise_application_error(-20001,'***********************************************************' || chr(10) ||
                                       '***                ERRO AO DISPARAR E-MAIL              ***' || CHR(10) ||
                                       '***                IMPOSSIVEL PROSSEGUIR                ***' || chr(10) ||
                                       '***********************************************************' || chr(10) || SQLERRM);

      END;   
  End If;
  /*****************************************************************************
  *   END: TDVADM.TG_BDU_C_ALTER_VF - BEFORE UPDATE OR DELETE                  *
  *****************************************************************************/  

END TG_BIUD_VALEFRETE;
/
