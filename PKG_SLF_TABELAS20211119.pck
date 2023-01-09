CREATE OR REPLACE PACKAGE PKG_SLF_TABELAS IS
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

 /* Typo utilizado como base para utilização dos Paramentros                                       */



 vSomentePedagio     char(1) := 'N';
 vTipoTab            char(3) := 'XXX';
 vTipoRodando        char(3) := 'XXX';
 vTABFRETEHORA       varchar2(50);
 vTABFRETETOTREG     number;
 vTABFRETEQTDEREG    number;
 vMSG                varchar2(32000) ;



 type tpCurosr is REF CURSOR;

 Type TpMODELO  is RECORD (CAMPO1         char(10),
                           CAMPO2         number(6));


 Type TpCriaTab is RECORD (SHEET_NR      varchar2(50),
                           SHEET_NAME    varchar2(50),
                           ROW_NR        number,
                           TIPOLINHA     varchar2(10),
                           TABELA        tdvadm.t_slf_calcfretekm.slf_tabela_codigo%type,
                           TIPOTAB       tdvadm.t_slf_tabela.slf_tabela_tipo%type,
                           COLENT        varchar2(10),
                           VIGENCIA      date,
                           GRUPO         tdvadm.t_slf_tabela.glb_grupoeconomico_codigo%type,
                           CLIENTE       tdvadm.t_slf_tabela.glb_cliente_cgccpfcodigo%type,
                           CONTRATO      tdvadm.t_slf_tabela.slf_tabela_contrato%type,
                           CARGA         varchar2(50),
                           VEICULO       varchar2(50), 
                           PESODE        tdvadm.t_slf_calcfretekm.slf_calcfretekm_pesode%type,
                           PESOATE       tdvadm.t_slf_calcfretekm.slf_calcfretekm_pesoate%type,
                           KMDE          tdvadm.t_slf_calcfretekm.slf_calcfretekm_kmde%type,
                           KMATE         tdvadm.t_slf_calcfretekm.slf_calcfretekm_kmate%type,
                           TPORIGEM      varchar2(50),
                           ORIGEM        tdvadm.t_slf_calcfretekm.slf_calcfretekm_origemi%type,
                           TPDESTINO     varchar2(50),
                           DESTINO       tdvadm.t_slf_calcfretekm.slf_calcfretekm_destinoi%type,
                           VALOR         number,
                           DES           varchar2(50),
                           TIPO          varchar2(50), -- KG ou TON
                           COMIMP        varchar2(50), -- Com ou sem Imposto
                           CODCLI        tdvadm.t_slf_calcfretekm.slf_calcfretekm_codcli%type,
                           VERBA         varchar2(50), 
                           LIMITE        tdvadm.t_slf_calcfretekm.slf_calcfretekm_limite%type,
                           VALORE        tdvadm.t_slf_calcfretekm.slf_calcfretekm_valore%type,
                           DESE          tdvadm.t_slf_calcfretekm.slf_calcfretekm_desinenciae%type,
                           VALORFIXO     tdvadm.t_slf_calcfretekm.slf_calcfretekm_valorf%type,
                           DESFIXO       tdvadm.t_slf_calcfretekm.slf_calcfretekm_desinenciaf%type,
                           RAIOKMORIGEM  tdvadm.t_slf_calcfretekm.slf_calcfretekm_raiokmorigem%type,
                           RAIOKMDESTINO tdvadm.t_slf_calcfretekm.slf_calcfretekm_raiokmdestino%type,
                           CODCARGA      tdvadm.t_slf_tabela.fcf_tpcarga_codigo%type,
                           CODVEICULO    tdvadm.t_slf_tabela.fcf_tpveiculo_codigo%type,
                           CODTPORIGEM   tdvadm.t_slf_tpfrete.slf_tpfrete_tpcodorigem%type,
                           CODTPDESTINO  tdvadm.t_slf_tpfrete.slf_tpfrete_tpcoddestino%type,
                           CODVERBA      tdvadm.t_slf_calcfretekm.slf_reccust_codigo%type);

    function fn_inserepedagio(pCarga in char,
                              pOrigem in char,
                              pDestino in char) return char;

    Procedure sp_LePlanilha(pPlanilha     in char,
                            pCursor       out tpCurosr );
                            
                            
    Procedure sp_PegaLinhaTabela(pPlanilha     in char,
                                 pLinha        in out TDVADM.v_slf_tabelaNovaCarga%rowtype,
                                 pLinhaDefault in out TDVADM.v_slf_tabelaNovaCarga%rowtype,
                                 pNrLinha      in out number,
                                 pStatus       out char,
                                 pMessage      out clob);

    Procedure sp_PegaLinhaValores(pPlanilha     in char,
                                  pLinha        in out TDVADM.V_slf_calcfretekmpreimpCSV%rowtype,
                                  pLinhaDefault in out TDVADM.V_slf_calcfretekmpreimpCSV%rowtype,
                                  pNrLinha      in out number,
                                  pStatus       out char,
                                  pMessage      out clob);

    Procedure sp_CriaAtulizaTabela(pXLS in varchar2,
                                   pStatus out Char,
                                   pMessage out clob);

    Procedure sp_CriaAtulizaValores(pXLS in varchar2,
                                    pStatus out Char,
                                    pMessage out clob);
                                   
    -- USADO PARA CALCULAR AS VERBAS DE UMA LOCALIDADE DE UMA TABELA
    PROCEDURE SP_MONTA_FORMULA_TABELA(V_TIPOCALCULOPAI IN     CHAR,
                                      V_TABELACODIGO   IN     CHAR,
                                      V_SAQUE          IN     CHAR,
                                      V_LOCALIDADE     IN     CHAR);

    -- USADO PARA CALCULAR TODAS AS LOCALIDADES DE UMA TABELA
    PROCEDURE SP_CALC_TOT_PRACA_TABELA(V_Codigo     Char,
                                       V_Saque      Char);


    -- USADO PARA ATUALIZAR OS PEDAGIOS DE UMA TABELA
    PROCEDURE SP_ATUALIZAPEDTABELA(P_TABELAORIGEM  IN     CHAR,
                                   P_SAQUEORIGEM   IN     CHAR,
                                   P_TABELADESTINO IN     CHAR,
                                   P_SAQUEDESTINO  IN     CHAR,
                                   P_VIGENCIA      IN     CHAR,
                                   P_REFERENCIA    IN     CHAR,
                                   P_OBS           IN     CHAR,
                                   P_TIPOTAB       IN     CHAR,
                                   P_ADMPEDOUTROS  IN     CHAR DEFAULT 'N',
                                   P_PERCENTOUTROS IN     NUMBER DEFAULT 0);


    -- EMBUTE O VALOR DO ICMS NA VERBA DE FRETE   
    PROCEDURE SP_EMBUTE_ICMS_TAB(P_VIGENCIA  IN CHAR,
                                 P_RECALCULA IN CHAR DEFAULT 'N');


    -- DESEMBUTE O VALOR DO ICMS NA VERBA DE FRETE   
    PROCEDURE SP_DESEMBUTE_ICMS_TAB(P_RECALCULA IN CHAR DEFAULT 'N',
                                    P_CIF       IN CHAR DEFAULT 'S',
                                    P_FOB       IN CHAR DEFAULT 'S');


    PROCEDURE SP_REAJUSTE_TABELA(V_TABELA_CODIGO      IN T_SLF_TABELA.SLF_TABELA_CODIGO%TYPE,
                                 V_TABELA_SAQUE       IN T_SLF_TABELA.SLF_TABELA_SAQUE%TYPE,
                                 V_ESTADO_CODIGO      IN T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE,
                                 V_LOCREAJUSTE_CODIGO IN T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE,
                                 V_TIPO_DE_REAJUSTE   IN CHAR,
                                 V_REAJUSTE           IN NUMBER,
                                 V_VLRREAJ            IN NUMBER,
                                 realiza_copia_saque  IN Char);


    PROCEDURE SP_SLF_REAJUSTAPED(P_USUARIO   IN CHAR,
                                 P_RELATORIO IN CHAR,
                                 P_DATA      IN CHAR,
                                 P_VAR_TABELA IN CHAR);

    PROCEDURE SP_LISTAREGRACONTRATO(pContrato in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                                    pStatus   out char,
                                    pMessage  out clob);


    PROCEDURE SP_CRITICAPLANILHA(pProtocolo in char,
                                 pStatus    out char,
                                 pMessage   out clob);

  function fi_verifica_carga(pTabela tdvadm.t_slf_tabela.slf_tabela_codigo%type,
                             pSaque  tdvadm.t_slf_tabela.slf_tabela_saque%type,
                             vReccust tdvadm.t_slf_reccust.slf_reccust_codigo%type,
                             vPercent number) return number;

  function fi_verifica_carga(pTabela tdvadm.t_slf_tabela.slf_tabela_codigo%type,
                             pSaque  tdvadm.t_slf_tabela.slf_tabela_saque%type,
                             pReccust tdvadm.t_slf_reccust.slf_reccust_codigo%type,
                             pVerbas  varchar2,
                             pPercent number) return number;

  Procedure sp_reajustaTABKM(pContrato      in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                             pPercent       in number, -- numero inteiro
                             pVigencia      in char,   -- a partir de quando sera o reajuste
                             pListaTAB      in varchar2 default 'TODAS', -- EXEMPLO => 94846;847465;848464.484746
                             pListaCargas   in varchar2 default 'TODAS', -- Lista das cargas a serem reajustadas Exemplo => 02;11;12
                             pReajustaFRETE in char default 'S',
                             pReajustaPED   in char default 'S',
                             pReajustaDESP  in char default 'S');
   
/*
BEGIN
   BLOCO DE INSTRUCOES
EXCEPTION
  WHEN DUP_VAL_ON_INDEX  THEN       -- ORA-00001   You attempted to create a duplicate value in a field restricted by a unique index.
  WHEN TIMEOUT_ON_RESOURCE  THEN    -- ORA-00051 	A resource timed out, took too long.
  WHEN TRANSACTION_BACKED_OUT  THEN -- ORA-00061 	The remote portion of a transaction has rolled back.
  WHEN INVALID_CURSOR  THEN         -- ORA-01001 	The cursor does not yet exist. The cursor must be OPENed before any FETCH cursor or CLOSE cursor operation.
  WHEN NOT_LOGGED_ON  THEN          -- ORA-01012 	You are not logged on.
  WHEN LOGIN_DENIED  THEN           -- ORA-01017 	Invalid username/password.
  WHEN NO_DATA_FOUND  THEN          -- ORA-01403 	No data was returned
  WHEN TOO_MANY_ROWS  THEN          -- ORA-01422 	You tried to execute a SELECT INTO statement and more than one row was returned.
  WHEN ZERO_DIVIDE  THEN            -- ORA-01476 	Divide by zero error.
  WHEN INVALID_NUMBER  THEN         -- ORA-01722 	Converting a string to a number was unsuccessful.
  WHEN STORAGE_ERROR  THEN          -- ORA-06500 	Out of memory.
  WHEN PROGRAM_ERROR  THEN          -- ORA-06501 	
  WHEN VALUE_ERROR  THEN            -- ORA-06502 	You tried to perform an operation and there was a error on a conversion, truncation, or invalid constraining of numeric or character data.
  WHEN ROWTYPE_MISMATCH  THEN       -- ORA-06504 	 
  WHEN CURSOR_ALREADY_OPEN  THEN    -- ORA-06511 	The cursor is already open.
  WHEN ACCESS_INTO_NULL  THEN       -- ORA-06530 	 
  WHEN COLLECTION_IS_NULL  THEN     -- ORA-06531    
  WHEN OTHERS THEN
END;

*/

                                    

END PKG_SLF_TABELAS;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_SLF_TABELAS AS

    vTotalLinhasFrete number := -1;   
    vInserePedagioJunto   glbadm.pkg_listas.tListaParamsString;
    vInserePedagioJuntoVZ glbadm.pkg_listas.tListaParamsString;

    function fn_inserepedagio(pCarga in char,
                              pOrigem in char,
                              pDestino in char) return char
    As
    Begin
      return vInserePedagioJunto(trim(pCarga) || trim(pOrigem) || trim(pDestino)).Asstring;
    End;

    function fn_arumavalor(pValor in char) return char
    as
      vValor varchar2(500);
    Begin
       vValor := replace(pValor,'.','');
       vValor := replace(vValor,',','.');
       return vValor;
    End;


    Procedure sp_LePlanilha(pPlanilha     in char,
                            pCursor       out tpCurosr )
      Is
        vAuxiliar number;


    Begin
       vAuxiliar := 0;
       
       delete glbadm.t_glb_loadxlsx;
       select count(*)
         into vAuxiliar 
       from GLBADM.T_GLB_LOADXLSXfixa;
       if vAuxiliar = 0 Then  

       for c_msg in ( Select pPlanilha Planilha,x.* From table(GLBADM.load_xlsx.read(GLBADM.load_xlsx.file2blob('PLANS',REPLACE(pPlanilha,'\','/')))) x )
         loop
            insert into glbadm.t_glb_loadxlsx
            (PLANILHA,
             SHEET_NR,
             SHEET_NAME,
             ROW_NR,
             COL_NR,
             CELL,
             CELL_TYPE,
             STRING_VAL,
             NUMBER_VAL,
             DATE_VAL,
             FORMULA)
            Values 
            (trim(c_msg.planilha),
             c_msg.sheet_nr,
             c_msg.sheet_name,
             c_msg.row_nr,
             c_msg.col_nr,
             c_msg.cell,
             c_msg.cell_type,
             c_msg.string_val,
             c_msg.number_val,
             c_msg.date_val,
             c_msg.formula);
             vAuxiliar := vAuxiliar + 1;
            if mod(vAuxiliar,10000) = 0 Then
               insert into t_glb_sql values (null,sysdate,TO_CHAR(vAuxiliar), 'IMPORTAPLA ' || pPlanilha);
               commit;
             End If;  
         End Loop;
         insert into t_glb_sql values (null,sysdate,TO_CHAR(vAuxiliar), 'IMPORTAPLA ' || pPlanilha);
         commit;   

         select count(distinct X.ROW_NR)
            into vAuxiliar
         from glbadm.t_glb_loadxlsx x;
         vAuxiliar := vAuxiliar;
         
--         insert into GLBADM.T_GLB_LOADXLSXfixa
--         select * from GLBADM.T_GLB_LOADXLSX  ;       
--        Else
--         insert into GLBADM.T_GLB_LOADXLSX
--         select * from GLBADM.T_GLB_LOADXLSXfixa x;       
          
        End If; 
         open pcursor  for select * from glbadm.t_glb_loadxlsx;
    
    End sp_LePlanilha;

    Procedure sp_PegaLinhaTabela(pPlanilha     in char,
                                 pLinha        in out TDVADM.v_slf_tabelaNovaCarga%rowtype,
                                 pLinhaDefault in out TDVADM.v_slf_tabelaNovaCarga%rowtype,
                                 pNrLinha      in out number,
                                 pStatus       out char,
                                 pMessage      out clob)
      Is
        vAuxiliar number;
        vString   varchar2(1000);
        vNumerico number;
        vData     date;
        vFormula  varchar2(1000);
        vUsaTabExcel char(1) := 'T';
        vLinha TDVADM.v_slf_tabelaNovaCarga%rowtype;
        vNovaLinha    number;
    Begin
      
        pNrLinha := nvl(pNrLinha,2);
        pStatus := 'N';
        pMessage := '';
        pLinha := null;
        
        Select count(*)
          into vAuxiliar
        from tdvadm.v_slf_tabelaNovaCarga p
        where p.protocolo = pPlanilha;

       -- Decide se vai :
       -- E - Usar a leitura de um XLS
       -- T - Usar o conceito de uma Tabela do Banco.
        if vAuxiliar = 0 Then
           vUsaTabExcel := 'E';
        Else
           vUsaTabExcel := 'T';   
        End If;
        
        If vUsaTabExcel = 'T' Then
           -- Chegou no Final da Tabela
           If pNrLinha > vAuxiliar Then
              pStatus := 'F';
              pMessage := 'Registro não existe';
              Return;
           End If;
           -- Pega a Linha desejada
           

           If vSomentePedagio = 'S' Then

             vNovaLinha := pNrLinha;
             
              select min(x.ROW_NR)
                into vNovaLinha
              from tdvadm.v_slf_tabelaNovaCarga x
              where x.protocolo = pPlanilha
                and x.row_nr >=  vNovaLinha
                and trim(x.CODVERBA) = 'D_PD';
             
             pNrLinha := vNovaLinha;

           End If;
            
           Select *
             into pLinha
           from tdvadm.v_slf_tabelaNovaCarga x
           where x.protocolo = pPlanilha
             and x.row_nr =  pNrLinha;
             

           if pLinha.COLENT = 'AMBOS' Then
              pLinha.COLENT := 'N';
           Else
              pLinha.COLENT := substr(pLinha.COLENT,1,1);
           End If;

        Else
        
            if pNrLinha = 1 Then
               pNrLinha := 2;
               pMessage := 'Linha 1 e Cabecalho';
               Return ;
            End IF; 
            
            

            loop

              vAuxiliar := 0;
              for c_msg in (select * from glbadm.t_glb_loadxlsx x
                            where x.planilha = pPlanilha
                              and x.row_nr  = pNrLinha
                            order by x.col_nr
                           )
              loop
                 
                  vString   := null;
                  vNumerico := null;
                  vData     := null;
                  vFormula  := null;
                  
                  if c_msg.CELL_TYPE = 'S' Then
                     vString := trim(replace(c_msg.string_val,chr(160),chr(32)));
                  Elsif c_msg.CELL_TYPE = 'N' Then
                     vNumerico := c_msg.number_val;
                  Elsif c_msg.CELL_TYPE = 'D' Then
                     vData     := c_msg.date_val;
                  ElsIf c_msg.cell_type = 'F' Then
                     vFormula := trim(c_msg.formula);
                  Else  
                     pStatus := 'E';
                     pMessage := pMessage || 'Erro Lendo coluna ' || c_msg.col_nr || chr(10);
                  End If;      

                  pLinha.SHEET_NR   := c_msg.sheet_nr;
--                  pLinha.SHEET_NAME := c_msg.sheet_name;
                  pLinha.ROW_NR     := c_msg.row_nr;
                
                  If c_msg.col_nr between 1 and 10 Then
                      if c_msg.col_nr =  1 Then
                         pLinha.TIPOLINHA := vString;
                      ElsIf c_msg.Col_Nr =  2 Then   
                         pLinha.TABELA := vString;
                      ElsIf c_msg.Col_Nr =  3 Then   
                         pLinha.TIPOTAB := vString;
                      ElsIf c_msg.Col_Nr =  4 Then   
                         if vString = 'AMBOS' Then
                            pLinha.COLENT := 'N';
                         Else
                            pLinha.COLENT := substr(vString,1,1);
                         End If;
                      ElsIf c_msg.Col_Nr =  5 Then   
                         pLinha.VIGENCIA := vData;
                      ElsIf c_msg.Col_Nr =  6 Then   
                         IF vString Is NOT Null Then 
                            pLinha.GRUPO := LPAD(TRIM(vString),4,'0');
                         Else
                            pLinha.GRUPO := LPAD(trim(to_char(vNumerico)),4,'0');
                         End If;
                      ElsIf c_msg.Col_Nr =  7 Then 
                         IF vString Is NOT Null Then 
                            pLinha.CLIENTE := vString;
                         Else
                            pLinha.CLIENTE := LPAD(trim(to_char(vNumerico)),14,'0');
                         End If;   
                      ElsIf c_msg.Col_Nr =  8 Then   
                         IF vString Is NOT Null Then 
                            pLinha.CONTRATO := vString;
                         Else
                            pLinha.CONTRATO := trim(to_char(vNumerico));
                         End If;   
                      ElsIf c_msg.Col_Nr =  9 Then   
                         pLinha.CARGA := vString;
                      ElsIf c_msg.Col_Nr = 10 Then   
                         pLinha.VEICULO := vString;
                      End If;

                  ElsIf c_msg.col_nr between 11 and 20 Then   

                      If c_msg.Col_Nr = 11 Then   
                         pLinha.PESODE := vNumerico;
                      ElsIf c_msg.Col_Nr = 12 Then   
                         pLinha.PESOATE := vNumerico;
                      ElsIf c_msg.Col_Nr = 13 Then   
                         pLinha.KMDE := vNumerico;
                      ElsIf c_msg.Col_Nr = 14 Then   
                         pLinha.KMATE := vNumerico;
                      ElsIf c_msg.Col_Nr = 15 Then   
                         pLinha.TPORIGEM := vString;
                      ElsIf c_msg.Col_Nr = 16 Then   
                         IF vString Is NOT Null Then 
                            pLinha.ORIGEM := vString;
                         Else
                            pLinha.ORIGEM := LPAD(trim(to_char(vNumerico)),7,'0');
                         End If;   
                      ElsIf c_msg.Col_Nr = 17 Then   
                         pLinha.TPDESTINO := vString;
                      ElsIf c_msg.Col_Nr = 18 Then   
                         IF vString Is NOT Null Then 
                            pLinha.DESTINO := vString;
                         Else
                            pLinha.DESTINO := LPAD(trim(to_char(vNumerico)),7,'0');
                         End If;   
                      ElsIf c_msg.Col_Nr = 19 Then   
                         pLinha.VALOR := vNumerico;
                         if nvl(pLinha.VALOR,0) = 0 Then
                            pLinha.VALOR := to_number(vString);
                         End If;
                      ElsIf c_msg.Col_Nr = 20 Then   
                         pLinha.DES := vString;
                      End If;

                  ElsIf c_msg.col_nr between 21 and 30 Then   

                      If c_msg.Col_Nr = 21 Then   
                         pLinha.TIPO := vString;
                      ElsIf c_msg.Col_Nr = 22 Then   
                         pLinha.COMIMP := nvl(vString,'N');
                      ElsIf c_msg.Col_Nr = 23 Then   
                         pLinha.CODCLI := vString;
                      ElsIf c_msg.Col_Nr = 24 Then   
                         pLinha.VERBA := vString;
                      ElsIf c_msg.Col_Nr = 25 Then   
                         pLinha.LIMITE := vNumerico;
                      ElsIf c_msg.Col_Nr = 26 Then   
                         pLinha.VALORE := vNumerico;
                      ElsIf c_msg.Col_Nr = 27 Then   
                         pLinha.DESE := vString;
                      ElsIf c_msg.Col_Nr = 28 Then   
                         pLinha.VALORFIXO := vNumerico;
                      ElsIf c_msg.Col_Nr = 29 Then   
                         pLinha.DESFIXO := vString;
                      ElsIf c_msg.Col_Nr = 30 Then   
                         pLinha.RAIOKMORIGEM := vNumerico;
                      End If;

                  ElsIf c_msg.col_nr between 31 and 40 Then   

                      If c_msg.Col_Nr = 31 Then   
                         pLinha.RAIOKMDESTINO := vNumerico;
                      ElsIf c_msg.Col_Nr = 32 Then   
                         pLinha.CODCARGA := vString;
                      ElsIf c_msg.Col_Nr = 33 Then   
                         pLinha.CODVEICULO := vString;
                      ElsIf c_msg.Col_Nr = 34 Then   
                         pLinha.CODTPORIGEM := vString;
                      ElsIf c_msg.Col_Nr = 35 Then   
                         pLinha.CODTPDESTINO := vString;
                      ElsIf c_msg.Col_Nr = 36 Then   
                         pLinha.CODVERBA := vString;
                      End If;

                  End If;    

                  vAuxiliar := vAuxiliar + 1;
                  if vAuxiliar >= 33 Then
                     vAuxiliar := vAuxiliar;
                  End If;
              End Loop;
              
              -- Se não Encontrou a Linha
              If vAuxiliar = 0 Then

                 select count(distinct X.ROW_NR)
                   into vAuxiliar
                 from glbadm.t_glb_loadxlsx x
                 where x.planilha = pPlanilha;
                 If vAuxiliar < pNrLinha Then
                    pStatus := 'F';
                    pMessage := 'Registro não existe';
                 Else
                    pStatus := 'E';
                    pMessage := 'Erro Lendo registro ' || pnrLinha || ' da Planilha';
                 End If;
                 if vAuxiliar = 0 then 
                    select count(distinct X.ROW_NR)
                      into vAuxiliar
                    from glbadm.t_glb_loadxlsx x;
                 End If; 

                 -- Volta
                 Return;
              End If;
              
              IF  pLinha.TIPOLINHA = 'DEFAULT' Then
                  pLinhaDefault := pLinha;
                  pLinha := null;
                  pNrLinha := pNrLinha + 1;
              Else
                  exit;
              End If;
            end loop;
        End If;
        Return;           
    
      
    End sp_PegaLinhaTabela;
   
    Procedure sp_PegaLinhaValores(pPlanilha     in char,
                                  pLinha        in out TDVADM.V_slf_calcfretekmpreimpCSV%rowtype,
                                  pLinhaDefault in out TDVADM.V_slf_calcfretekmpreimpCSV%rowtype,
                                  pNrLinha      in out number,
                                  pStatus       out char,
                                  pMessage      out clob)
      Is
        vAuxiliar number;
        vString   varchar2(1000);
        vNumerico number;
        vData     date;
        vFormula  varchar2(1000);
        vUsaTabExcel char(1) := 'T';
        vLinha TDVADM.V_slf_calcfretekmpreimpCSV%rowtype;
        vNovaLinha    number;
    Begin
      
        pNrLinha := nvl(pNrLinha,2);
        pStatus := 'N';
        pMessage := '';
        pLinha := null;

     If vTotalLinhasFrete = -1 Then   
            
        Select count(*)
          into vAuxiliar
        from tdvadm.v_slf_calcfretekmpreimpcsv p
        where 0 = 0 
          and p.protocolo = pPlanilha
         and p.ROW_NR > 1;

        vTotalLinhasFrete := vAuxiliar;
     End If;

            
       -- Decide se vai :
       -- E - Usar a leitura de um XLS
       -- T - Usar o conceito de uma Tabela do Banco.
        if vAuxiliar = 0 Then
           vUsaTabExcel := 'E';
        Else
           vUsaTabExcel := 'T';   
        End If;
        
        If vUsaTabExcel = 'T' Then
           -- Chegou no Final da Tabela
           If pNrLinha > vAuxiliar Then
              pStatus := 'F';
              pMessage := 'Registro não existe';
              Return;
           End If;
           -- Pega a Linha desejada
           

           If vSomentePedagio = 'S' Then

             vNovaLinha := pNrLinha;
             
              select min(x.ROW_NR)
                into vNovaLinha
              from tdvadm.v_slf_calcfretekmpreimpcsv x
              where 0 = 0 
                and x.protocolo = pPlanilha
                and x.row_nr >=  vNovaLinha
                and trim(x.CODVERBA) = 'D_PD';
             
             pNrLinha := vNovaLinha;

           End If;
            
           Select *
             into pLinha
           from tdvadm.v_slf_calcfretekmpreimpcsv x
           where 0 = 0 
             and x.protocolo = pPlanilha
             and x.row_nr =  pNrLinha;
             

           if pLinha.COLENT = 'AMBOS' Then
              pLinha.COLENT := 'N';
           Else
              pLinha.COLENT := substr(pLinha.COLENT,1,1);
           End If;

        Else
        
            if pNrLinha = 1 Then
               pNrLinha := 2;
               pMessage := 'Linha 1 e Cabecalho';
               Return ;
            End IF; 
            
            

            loop

              vAuxiliar := 0;
              for c_msg in (select * from glbadm.t_glb_loadxlsx x
                            where x.planilha = pPlanilha
                              and x.row_nr  = pNrLinha
                            order by x.col_nr
                           )
              loop
                 
                  vString   := null;
                  vNumerico := null;
                  vData     := null;
                  vFormula  := null;
                  
                  if c_msg.CELL_TYPE = 'S' Then
                     vString := trim(replace(c_msg.string_val,chr(160),chr(32)));
                  Elsif c_msg.CELL_TYPE = 'N' Then
                     vNumerico := c_msg.number_val;
                  Elsif c_msg.CELL_TYPE = 'D' Then
                     vData     := c_msg.date_val;
                  ElsIf c_msg.cell_type = 'F' Then
                     vFormula := trim(c_msg.formula);
                  Else  
                     pStatus := 'E';
                     pMessage := pMessage || 'Erro Lendo coluna ' || c_msg.col_nr || chr(10);
                  End If;      

                  pLinha.SHEET_NR   := c_msg.sheet_nr;
                  pLinha.SHEET_NAME := c_msg.sheet_name;
                  pLinha.ROW_NR     := c_msg.row_nr;
                
                  If c_msg.col_nr between 1 and 10 Then
                      if c_msg.col_nr =  1 Then
                         pLinha.TIPOLINHA := vString;
                      ElsIf c_msg.Col_Nr =  2 Then   
                         pLinha.TABELA := vString;
                      ElsIf c_msg.Col_Nr =  3 Then   
                         pLinha.TIPOTAB := vString;
                      ElsIf c_msg.Col_Nr =  4 Then   
                         if vString = 'AMBOS' Then
                            pLinha.COLENT := 'N';
                         Else
                            pLinha.COLENT := substr(vString,1,1);
                         End If;
                      ElsIf c_msg.Col_Nr =  5 Then   
                         pLinha.VIGENCIA := vData;
                      ElsIf c_msg.Col_Nr =  6 Then   
                         IF vString Is NOT Null Then 
                            pLinha.GRUPO := LPAD(TRIM(vString),4,'0');
                         Else
                            pLinha.GRUPO := LPAD(trim(to_char(vNumerico)),4,'0');
                         End If;
                      ElsIf c_msg.Col_Nr =  7 Then 
                         IF vString Is NOT Null Then 
                            pLinha.CLIENTE := vString;
                         Else
                            pLinha.CLIENTE := LPAD(trim(to_char(vNumerico)),14,'0');
                         End If;   
                      ElsIf c_msg.Col_Nr =  8 Then   
                         IF vString Is NOT Null Then 
                            pLinha.CONTRATO := vString;
                         Else
                            pLinha.CONTRATO := trim(to_char(vNumerico));
                         End If;   
                      ElsIf c_msg.Col_Nr =  9 Then   
                         pLinha.CARGA := vString;
                      ElsIf c_msg.Col_Nr = 10 Then   
                         pLinha.VEICULO := vString;
                      End If;

                  ElsIf c_msg.col_nr between 11 and 20 Then   

                      If c_msg.Col_Nr = 11 Then   
                         pLinha.PESODE := vNumerico;
                      ElsIf c_msg.Col_Nr = 12 Then   
                         pLinha.PESOATE := vNumerico;
                      ElsIf c_msg.Col_Nr = 13 Then   
                         pLinha.KMDE := vNumerico;
                      ElsIf c_msg.Col_Nr = 14 Then   
                         pLinha.KMATE := vNumerico;
                      ElsIf c_msg.Col_Nr = 15 Then   
                         pLinha.TPORIGEM := vString;
                      ElsIf c_msg.Col_Nr = 16 Then   
                         IF vString Is NOT Null Then 
                            pLinha.ORIGEM := vString;
                         Else
                            pLinha.ORIGEM := LPAD(trim(to_char(vNumerico)),7,'0');
                         End If;   
                      ElsIf c_msg.Col_Nr = 17 Then   
                         pLinha.TPDESTINO := vString;
                      ElsIf c_msg.Col_Nr = 18 Then   
                         IF vString Is NOT Null Then 
                            pLinha.DESTINO := vString;
                         Else
                            pLinha.DESTINO := LPAD(trim(to_char(vNumerico)),7,'0');
                         End If;   
                      ElsIf c_msg.Col_Nr = 19 Then   
                         pLinha.VALOR := vNumerico;
                         if nvl(pLinha.VALOR,0) = 0 Then
                            pLinha.VALOR := to_number(vString);
                         End If;
                      ElsIf c_msg.Col_Nr = 20 Then   
                         pLinha.DES := vString;
                      End If;

                  ElsIf c_msg.col_nr between 21 and 30 Then   

                      If c_msg.Col_Nr = 21 Then   
                         pLinha.TIPO := vString;
                      ElsIf c_msg.Col_Nr = 22 Then   
                         pLinha.COMIMP := nvl(vString,'N');
                      ElsIf c_msg.Col_Nr = 23 Then   
                         pLinha.CODCLI := vString;
                      ElsIf c_msg.Col_Nr = 24 Then   
                         pLinha.VERBA := vString;
                      ElsIf c_msg.Col_Nr = 25 Then   
                         pLinha.LIMITE := vNumerico;
                      ElsIf c_msg.Col_Nr = 26 Then   
                         pLinha.VALORE := vNumerico;
                      ElsIf c_msg.Col_Nr = 27 Then   
                         pLinha.DESE := vString;
                      ElsIf c_msg.Col_Nr = 28 Then   
                         pLinha.VALORFIXO := vNumerico;
                      ElsIf c_msg.Col_Nr = 29 Then   
                         pLinha.DESFIXO := vString;
                      ElsIf c_msg.Col_Nr = 30 Then   
                         pLinha.RAIOKMORIGEM := vNumerico;
                      End If;

                  ElsIf c_msg.col_nr between 31 and 40 Then   

                      If c_msg.Col_Nr = 31 Then   
                         pLinha.RAIOKMDESTINO := vNumerico;
                      ElsIf c_msg.Col_Nr = 32 Then   
                         pLinha.CODCARGA := vString;
                      ElsIf c_msg.Col_Nr = 33 Then   
                         pLinha.CODVEICULO := vString;
                      ElsIf c_msg.Col_Nr = 34 Then   
                         pLinha.CODTPORIGEM := vString;
                      ElsIf c_msg.Col_Nr = 35 Then   
                         pLinha.CODTPDESTINO := vString;
                      ElsIf c_msg.Col_Nr = 36 Then   
                         pLinha.CODVERBA := vString;
                      End If;

                  End If;    

                  vAuxiliar := vAuxiliar + 1;
                  if vAuxiliar >= 33 Then
                     vAuxiliar := vAuxiliar;
                  End If;
              End Loop;
              
              -- Se não Encontrou a Linha
              If vAuxiliar = 0 Then

                 select count(distinct X.ROW_NR)
                   into vAuxiliar
                 from glbadm.t_glb_loadxlsx x
                 where x.planilha = pPlanilha;
                 If vAuxiliar < pNrLinha Then
                    pStatus := 'F';
                    pMessage := 'Registro não existe';
                 Else
                    pStatus := 'E';
                    pMessage := 'Erro Lendo registro ' || pnrLinha || ' da Planilha';
                 End If;
                 if vAuxiliar = 0 then 
                    select count(distinct X.ROW_NR)
                      into vAuxiliar
                    from glbadm.t_glb_loadxlsx x;
                 End If; 

                 -- Volta
                 Return;
              End If;
              
              IF  pLinha.TIPOLINHA = 'DEFAULT' Then
                  pLinhaDefault := pLinha;
                  pLinha := null;
                  pNrLinha := pNrLinha + 1;
              Else
                  exit;
              End If;
            end loop;
        End If;
        Return;           
    
      
    End sp_PegaLinhaValores;


     Procedure sp_CriaAtulizaTabela(pXLS in varchar2,
                                   pStatus out Char,
                                   pMessage out clob)
      Is
      vLinha        tdvadm.v_slf_tabelaNovaCarga%rowtype;
      vLinhaDefault tdvadm.v_slf_tabelaNovaCarga%rowtype;
      vAuxiliar     number;
      vNrLinha      number;
      vCursor       tpCurosr;
      vMessage      clob;
      vSaqueTab     tdvadm.t_slf_tabela.slf_tabela_saque%type;
      vTpTabela     tdvadm.t_slf_tabela%rowtype;
      vTpCalcTabela tdvadm.t_slf_calcfretekm%rowtype;
      vCriaTabela   char(1) := 'N';
      vCriaSaque    char(1) := 'N';
      vSQL          CLOB;
      vErro         varchar2(20000);
      vMostraErro   char(1) := 'N';
      vAliquota     number;
      vSair         char(1) := 'N';
      vVigencia     date;
      vPula         boolean := False;
      vStatus       char(1);
      cLinhas       tpCurosr;
    Begin
      
      pStatus := 'N';
      pMessage := '';
      
    
    -- \TabelasFrete\TABELA_LOTACAO_23_11_2015.xlsx
       delete tdvadm.dropme d where x = pXLS;
--       insert into tdvadm.dropme d
--       (x,a) values (pXLS,'0');
       

    
    
       vSomentePedagio := vSomentePedagio;
       vInserePedagioJunto := vInserePedagioJunto;
--       vInserePedagioJunto := 'S';
       
--       DELETE T_SLF_CALCFRETEKMIMP2;  
       
       commit;            
  
       pMessage := pkg_glb_html.Assinatura;
       pMessage := pMessage || pkg_glb_html.fn_Titulo('CRITICA Arquivo ' || pXLS);
       vAuxiliar := 0; 
       vNrLinha  := 1;
--       sp_LePlanilha(pXLS,vCursor);
       
       open cLinhas FOR SELECT * 
                  FROM TDVADM.V_SLF_TABELANOVACARGA NC
                  where upper(NC.planilha) = upper(pXLS);



       loop
         fetch cLinhas
         into vLinha;
       Exit When cLinhas%Notfound;
         
--          sp_PegaLinhaTabela(pXLS,vLinha,vLinhaDefault,vNrLinha,pStatus,vMessage);  
--          if vNrLinha > 10 Then
--             pStatus := 'F';
--          End IF;

          vPula := False;

          pStatus := substr(pStatus,1,1);
          pStatus := substr(pStatus,1,1);
          vStatus := substr(pStatus,1,1);
          
          If ( vLinha.CODVERBA = 'D_PD' ) Then
             vLinha.CODVERBA := vLinha.CODVERBA;
          End If;
          
          IF ( nvl(vLinha.CODVERBA,'XXX') <> 'D_PD' ) /*or ( vInserePedagioJunto = 'S' )*/ Then
          
          if vNrLinha = 1882 Then
             pStatus := pStatus;
          End IF;
          
          if vSair = 'S' Then
             exit;
          End If; 
            
          exit when trim(nvl(pStatus,'N')) = 'F';

          if vNrLinha = 1882 Then
             vNrLinha := vNrLinha;
          End If;
          
          vLinha.TABELA        := trim(nvl(vLinha.TABELA,vLinhaDefault.TABELA));
          If tdvadm.f_enumerico(vLinha.TABELA) = 'N' Then
             vLinha.TABELA := null;
          End If;
          vLinha.TIPOTAB       := nvl(vLinha.TIPOTAB,vLinhaDefault.TIPOTAB);
          If vLinha.TIPOTAB = 'AMB' Then
             vTipoTab := 'AMB';
             If vTipoRodando = 'XXX' Then
                vTipoRodando := 'CIF';
                vLinha.TIPOTAB := 'CIF';
             Else
                vLinha.TIPOTAB := vTipoRodando;  
             End If;
          Else
             vTipoRodando := vLinha.TIPOTAB;
          End If;   

          vLinha.COLENT        := substr(nvl(vLinha.COLENT,vLinhaDefault.COLENT),1,1);
          vLinha.VIGENCIA      := nvl(vLinha.VIGENCIA,vLinhaDefault.VIGENCIA);
          vLinha.GRUPO         := lpad(nvl(vLinha.GRUPO,vLinhaDefault.GRUPO),4,'0');
          vLinha.CLIENTE       := nvl(vLinha.CLIENTE,vLinhaDefault.CLIENTE);
          vLinha.CONTRATO      := nvl(vLinha.CONTRATO,vLinhaDefault.CONTRATO);
          vLinha.CARGA         := nvl(vLinha.CARGA,vLinhaDefault.CARGA);
          vLinha.VEICULO       := nvl(vLinha.VEICULO,vLinhaDefault.VEICULO);
          vLinha.VEICULO       := nvl(vLinha.VEICULO,vLinhaDefault.VEICULO);
          vLinha.PESODE        := replace(replace(nvl(nvl(vLinha.PESODE,vLinhaDefault.PESODE),0),'.',''),',','.');
          vLinha.PESOATE       := replace(replace(nvl(nvl(vLinha.PESOATE,vLinhaDefault.PESOATE),9999999),'.',''),',','.');
          vLinha.KMDE          := nvl(nvl(vLinha.KMDE,vLinhaDefault.KMDE),0);
          vLinha.KMATE         := nvl(nvl(vLinha.KMATE,vLinhaDefault.KMATE),9999);
          vLinha.TPORIGEM      := nvl(vLinha.TPORIGEM,vLinhaDefault.TPORIGEM);
          vLinha.ORIGEM        := trim(nvl(vLinha.ORIGEM,vLinhaDefault.ORIGEM));
          vLinha.TPDESTINO     := nvl(vLinha.TPDESTINO,vLinhaDefault.TPDESTINO);
          vLinha.DESTINO       := trim(nvl(vLinha.DESTINO,vLinhaDefault.DESTINO));
          vLinha.VALOR         := REPLACE(nvl(vLinha.VALOR,vLinhaDefault.VALOR),',','.');
          vLinha.DES           := trim(nvl(vLinha.DES,vLinhaDefault.DES));
          vLinha.TIPO          := nvl(vLinha.TIPO,vLinhaDefault.TIPO);
          vLinha.COMIMP        := nvl(nvl(vLinha.COMIMP,vLinhaDefault.COMIMP),'N');
          vLinha.CODCLI        := nvl(vLinha.CODCLI,vLinhaDefault.CODCLI);
          vLinha.VERBA         := nvl(vLinha.VERBA,vLinhaDefault.VERBA);
          vLinha.LIMITE        := REPLACE(nvl(vLinha.LIMITE,vLinhaDefault.LIMITE),',','.');
          vLinha.VALORE        := REPLACE(nvl(vLinha.VALORE,vLinhaDefault.VALORE),',','.');
          vLinha.DESE          := nvl(vLinha.DESE,vLinhaDefault.DESE);
          vLinha.VALORFIXO     := REPLACE(nvl(vLinha.VALORFIXO,vLinhaDefault.VALORFIXO),',','.');
          vLinha.DESFIXO       := nvl(vLinha.DESFIXO,vLinhaDefault.DESFIXO);
          vLinha.RAIOKMORIGEM  := REPLACE(nvl(vLinha.RAIOKMORIGEM,vLinhaDefault.RAIOKMORIGEM),',','.');
          vLinha.RAIOKMDESTINO := REPLACE(nvl(vLinha.RAIOKMDESTINO,vLinhaDefault.RAIOKMDESTINO),',','.');
          vLinha.CODCARGA      := rpad(lpad(nvl(vLinha.CODCARGA,vLinhaDefault.CODCARGA),2,'0'),3);
          vLinha.OUTRACOL      := nvl(trim(vLinha.OUTRACOL),vLinhaDefault.OUTRACOL);
          vLinha.OUTRAENT      := nvl(trim(vLinha.OUTRAENT),vLinhaDefault.OUTRAENT);
          vLinha.CODVVEN       := nvl(trim(vLinha.CODVVEN),vLinhaDefault.CODVVEN);
          Begin
             vLinha.CODVEICULO    := trim(to_char(to_number(nvl(vLinha.CODVEICULO,vLinhaDefault.CODVEICULO))));
          Exception
            When OTHERS Then
               vLinha.CODVEICULO := null;
            End;
          vLinha.CODTPORIGEM   := nvl(vLinha.CODTPORIGEM,vLinhaDefault.CODTPORIGEM);
          vLinha.CODTPDESTINO  := nvl(vLinha.CODTPDESTINO,vLinhaDefault.CODTPDESTINO);
          vLinha.CODVERBA      := TRIM(nvl(vLinha.CODVERBA,vLinhaDefault.CODVERBA));
--          vLinha.Codverba      := nvl(vLinha.Codverba,'XXX');
         

          vPula := False;
          
          If Not vPula Then 



              vErro :=  vErro || pkg_glb_html.fn_AbreLista;
              vErro :=  vErro || pkg_glb_html.fn_ItensLista('Linha ' || vNrLinha);
              vErro :=  vErro || pkg_glb_html.fn_AbreLista;

              -- Validacoes Basicas

              Begin
                vLinha.VIGENCIA := to_date(vLinha.VIGENCIA,'dd/mm/yyyy');
              Exception
                When OTHERS Then
                   pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('Erro na Vigencia ' || vLinha.VIGENCIA  );
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('erro : ' || sqlerrm);
                End ;

                vStatus := substr(pStatus,1,1);


              if vLinha.CLIENTE is Null Then
                pStatus := 'E';
                vMostraErro := 'S';
                vErro :=  vErro || pkg_glb_html.fn_ItensLista('Cliente não Informado');
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_glb_cliente cl
                 where trim(cl.glb_cliente_cgccpfcodigo) = trim(vLinha.CLIENTE);
                 if vAuxiliar = 0 Then
                    vAuxiliar := length(trim(replace(vLinha.CLIENTE,'9','')));
                    if nvl(vAuxiliar,0) = 0 Then
                       vLinha.CLIENTE := tdvadm.pkg_fifo_carregctrc.QualquerCliente;
                    Else     
                      pStatus := 'E';
                      vMostraErro := 'S';
                      vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CLIENTE || '] -Cliente não existe');
                    End If;  
                End If;   
              End If; 
               
              vStatus := substr(pStatus,1,1);
               
              If vLinha.CONTRATO is Null Then
                pStatus := 'E';
                vMostraErro := 'S';
                vErro :=  vErro || pkg_glb_html.fn_ItensLista('Contrato não Informado');
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_slf_contrato cl
                 where cl.slf_contrato_codigo = vLinha.CONTRATO;

                 if vAuxiliar = 0 Then
                    pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CONTRATO || '] -Contrato não existe');
                End If;   
              End If; 
              
              vStatus := substr(pStatus,1,1);
                
              If vLinha.GRUPO is Null Then
                 vLinha.GRUPO := '9999';
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_glb_grupoeconomico cl
                 where cl.glb_grupoeconomico_codigo = vLinha.GRUPO;
                 if vAuxiliar = 0 Then
                    pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.GRUPO || '] -Grupo Economico não existe');
                End If;   
              End If; 
              
              vStatus := substr(pStatus,1,1);

              If vLinha.CODCARGA is Null Then
                pStatus := 'E';
                vErro :=  vErro || pkg_glb_html.fn_ItensLista('Tipo de Carga não Informado');
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_fcf_tpcarga cl
                 where cl.fcf_tpcarga_codigo = rpad(vLinha.CODCARGA,3);
                 if vAuxiliar = 0 Then
                    pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CODCARGA || '-' || vLinha.CARGA || '] -Carga não existe');
                End If;   
              End If; 
              
              vStatus := substr(pStatus,1,1);
              
              If vLinha.CODVEICULO is NOT Null Then
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_fcf_tpveiculo cl
                 where cl.fcf_tpveiculo_codigo = rpad(vLinha.CODVEICULO,3);
                 if vAuxiliar = 0 Then
                    pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CODVEICULO || '-' || vLinha.VEICULO || '] -Veiculo não existe');
                End If;  
              Else
                vLinha.CODVEICULO := '9';   
              End If; 
 
              vStatus := substr(pStatus,1,1); 

              -- Verifica se tem regra
              
              If nvl(pStatus,'N') <> 'E' Then


                  if vLinha.TABELA is NOT Null Then
                     Begin
                        select ta.slf_tabela_saque,
                               ta.slf_tabela_vigencia
                          into vSaqueTab,
                               vVigencia
                        from tdvadm.t_slf_tabela ta
                        where ta.slf_tabela_codigo = vLinha.TABELA
                          and trim(ta.fcf_tpcarga_codigo) = trim(vLinha.CODCARGA)
                          and trim(ta.fcf_tpveiculo_codigo) = trim(vLinha.CODVEICULO)
                          and trim(ta.glb_grupoeconomico_codigo) = trim(decode(vLinha.GRUPO,tdvadm.pkg_fifo_carregctrc.QualquerGrupo,ta.glb_grupoeconomico_codigo,vLinha.GRUPO))
                          and trim(ta.glb_cliente_cgccpfcodigo)  = trim(decode(vLinha.CLIENTE,tdvadm.pkg_fifo_carregctrc.QualquerCliente,ta.glb_cliente_cgccpfcodigo,vLinha.CLIENTE))
                          and trim(ta.slf_tabela_contrato)       = trim(decode(vLinha.CONTRATO,tdvadm.pkg_fifo_carregctrc.QualquerContrato,ta.slf_tabela_contrato,vLinha.CONTRATO))
                          and ta.slf_tabela_tipo  = vLinha.TIPOTAB
                          and ta.slf_tabela_coletaentrega in ('A','N',vLinha.COLENT) 
                          and nvl(ta.slf_tabela_status,'N') = 'N'
                          and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                                     from tdvadm.t_slf_tabela ta1
                                                     where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                       and ta.slf_tabela_vigencia <= vLinha.VIGENCIA
                                                       and nvl(ta.slf_tabela_status,'N') = 'N');
                       If vVigencia < vLinha.VIGENCIA Then
                          vCriaSaque := 'S';
                       End If;
                     Exception
                       When NO_DATA_FOUND Then
                          pStatus := 'E';
                          vMostraErro := 'S';
                          vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' ||vLinha.TABELA  || '] -Tabela não existe');
                       End ;
                  Else
                     -- Procura qual tabela Atende esta regra.
                        vAuxiliar := 0;
                        for c_msg in (Select slf_tabela_codigo,
                                             slf_tabela_saque,
                                             slf_tabela_vigencia
                                      From (select ta.slf_tabela_codigo,
                                                   ta.slf_tabela_saque,
                                                   ta.slf_tabela_vigencia
                                            from tdvadm.t_slf_tabela ta
                                            where 0 = 0
                                              and trim(ta.fcf_tpcarga_codigo) = trim(vLinha.CODCARGA)
                                              and trim(ta.fcf_tpveiculo_codigo) = trim(vLinha.CODVEICULO)
                                              and trim(ta.glb_grupoeconomico_codigo) = trim(decode(vLinha.GRUPO,tdvadm.pkg_fifo_carregctrc.QualquerGrupo,ta.glb_grupoeconomico_codigo,vLinha.GRUPO))
                                              and trim(ta.glb_cliente_cgccpfcodigo)  = trim(decode(vLinha.CLIENTE,tdvadm.pkg_fifo_carregctrc.QualquerCliente,ta.glb_cliente_cgccpfcodigo,vLinha.CLIENTE))
                                              and trim(ta.slf_tabela_contrato)       = trim(decode(vLinha.CONTRATO,tdvadm.pkg_fifo_carregctrc.QualquerContrato,ta.slf_tabela_contrato,vLinha.CONTRATO))
                                              and ta.slf_tabela_tipo  = vLinha.TIPOTAB
                                              and ta.slf_tabela_coletaentrega in ('A','N',vLinha.COLENT) 
                                              and nvl(ta.slf_tabela_status,'N') = 'N'
                                              and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                                                         from tdvadm.t_slf_tabela ta1
                                                                         where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                                           and ta1.slf_tabela_vigencia <= TO_DATE(vLinha.VIGENCIA,'DD/MM/YYYY')
                                                                           and nvl(ta1.slf_tabela_status,'N') = 'N'))
                                     )
                         Loop
                             If vAuxiliar = 1 Then
                                vMostraErro := 'S';
                                vErro := vErro || pkg_glb_html.fn_ItensLista (' Favor verificar! ' || 
                                                                              ' Chave de Tabela Duplicada ' || 
                                                                              ' Vigencia  - ' || vLinha.VIGENCIA || 
                                                                              ' - Contrato  - ' || vLinha.CONTRATO || 
                                                                              ' - Grupo     - ' || vLinha.GRUPO || 
                                                                              ' - Cliente   - ' || vLinha.CLIENTE || 
                                                                              ' - Cod Carga - ' || vlinha.CODCARGA || 
                                                                              ' - Cod Veic  - ' || vLinha.CODVEICULO || 
                                                                              ' - Tp Tab    - ' || vLinha.TIPOTAB || 
                                                                              ' - ENT/COL   - ' || vLinha.COLENT ); 
                                vErro := vErro || pkg_glb_html.fn_ItensLista ('Verifique as Tabelas Abaixo: ');
                                vErro := vErro || pkg_glb_html.fn_ItensLista ('Tabela  - ' || vLinha.TABELA || '-' || vSaqueTab || '-' || vVigencia );
                                                         
                                                  
                             End If;
                            vAuxiliar := vAuxiliar + 1;
                            vLinha.TABELA := c_msg.slf_tabela_codigo;
                            vSaqueTab     := c_msg.slf_tabela_saque;
                            vVigencia     := c_msg.slf_tabela_vigencia;
                            
                            vErro := vErro || pkg_glb_html.fn_ItensLista ('Tabela  - ' || vLinha.TABELA || '-' || vSaqueTab || '-' || vVigencia );
                             


                          If nvl(vLinha.TABELA,'XX') = 'XX' Then
                             vCriaTabela := 'S';
                          ElsIf vVigencia < vLinha.VIGENCIA Then
                             vCriaSaque := 'S';
--                          Else   
--                             
--                             vErro :=  vErro || pkg_glb_html.fn_ItensLista('-Usando Tabela ' || vLinha.TABELA || '-' || vSaqueTab);
                          End If;   
                     End Loop;
                     If vAuxiliar = 0 Then
                        vCriaTabela := 'S';
                     Elsif vAuxiliar > 1 Then
                        vCriaTabela := 'N';
                        vCriaSaque := 'N';
                        vTpTabela.Slf_Tabela_Status  := 'E';
                        pStatus := 'E';
                     End If;

                  End If;

                  vStatus := substr(pStatus,1,1);
                  
                  If ( vCriaTabela = 'S' ) or ( vCriaSaque = 'S' ) Then
                    
                     if vCriaTabela = 'S' Then
                        select max(ta.slf_tabela_codigo+1)
                          into vLinha.TABELA
                        from tdvadm.t_slf_tabela ta
                        where substr(ta.slf_tabela_codigo,1,3) = '021';
                      vLinha.TABELA := lpad(to_number(vLinha.TABELA),8,'0');
                        vSaqueTab := '0001';
                     ElsIf vCriaSaque = 'S' Then
                        select max(ta.slf_tabela_saque)
                           into vSaqueTab
                        from tdvadm.t_slf_tabela ta
                        where ta.slf_tabela_codigo = vLinha.TABELA;
                        vSaqueTab := lpad(to_number(vSaqueTab) + 1,4,'0');
                     End If;   

    --                 vMostraErro := 'S';
                     vErro :=  vErro || pkg_glb_html.fn_ItensLista('-Tabela não existe Criado Tabela ' || vLinha.TABELA || '-' || vSaqueTab);
                         
                     vTpTabela.Slf_Tabela_Codigo         := vLinha.TABELA;
                     vTpTabela.Glb_Rota_Codigo           := '021';
                     vTpTabela.Slf_Tabela_Saque          := vSaqueTab;
                     vTpTabela.Slf_Tabela_Tipo           := vLinha.TIPOTAB;
                     vTpTabela.Glb_Cliente_Cgccpfcodigo  := vLinha.CLIENTE;
                     vTpTabela.Glb_Mercadoria_Codigo     := '99';
                     vTpTabela.Slf_Tabela_Vigencia       := vLinha.VIGENCIA;
                     vTpTabela.Glb_Embalagem_Codigo      := '18';
                     vTpTabela.Slf_Tabela_Dtgravacao     := sysdate;
                     vTpTabela.Slf_Tabela_Contrato       := vLinha.CONTRATO;
                     vTpTabela.Fcf_Tpveiculo_Codigo      := vLinha.CODVEICULO;
                     vTpTabela.Fcf_Tpcarga_Codigo        := vLinha.CODCARGA;
                     vTpTabela.Glb_Grupoeconomico_Codigo := vLinha.GRUPO;
                     vTpTabela.Slf_Tabela_Imprimeobsctrc := 'N';
                     vTpTabela.Slf_Tabela_Imprimeobsvenc := 'N';
                     vTpTabela.Slf_Tabela_Coletaentrega  := vLinha.COLENT;
                     vTpTabela.Slf_Tabela_Isento         := 'N';
                     vTpTabela.Slf_Tabela_Descricao      := 'Criado Automati';
                     vTpTabela.Slf_Tpcalculo_Codigo      := '041';
                     if ( vLinha.CONTRATO = 'C2013010022' ) Then -- LOT-VOLKSWAGEN-0113-XXX
                        vTpTabela.Slf_Tpcalculo_Codigo := '315';
                     end If   ;
                     If vLinha.GRUPO = '0020' Then
                        vTpTabela.Slf_Tpcalculo_Codigo := '315';
                     End If;
                     vTpTabela.Glb_Vendfrete_Codigo      := vLinha.CODVVEN;
                    
                     vTpTabela.Slf_Tabela_Status         := 'N';


                     -- Verificar em Desuso
                     vTpTabela.Glb_Condpag_Codigo        := '0054';
                     vTpTabela.Glb_Tpcarga_Codigo        := 'CL';
                     vTpTabela.Glb_Localidade_Codigo     := '99999999';
                     vTpTabela.Slf_Tabela_Lotacaoflag    := 'N';
                     vTpTabela.Slf_Tabela_Pesominimo     := 0;
                     vTpTabela.Slf_Tabela_Pesomaximo     := 999999;
                     vTpTabela.Slf_Tabela_Contato        := null;
                     vTpTabela.Slf_Tabela_Obstabela      := null;
                     vTpTabela.Slf_Tabela_Obsfaturamento := null;
                     vTpTabela.Slf_Tabela_Pedreajaut     := null;
                     vTpTabela.Slf_Tabela_Pedatualiza    := null; 
                     vTpTabela.Slf_Tabela_Origemdestino  := null;
                     vTpTabela.Slf_Tabela_Viagemmin      := null;
                     vTpTabela.Slf_Tabela_Viagemmax      := null;
                     vTpTabela.Slf_Tabela_Viagemident    := null; 
                     vTpTabela.Con_Fcobped_Codigo        := null;
                     vTpTabela.Con_Modalidadeped_Codigo  := null;
                     vTpTabela.Slf_Tabela_Tpdesconto     := null; 
                     vTpTabela.Slf_Tabela_Desconto       := null;
                     vTpTabela.Slf_Tabela_Perclotacao    := null;
                     vTpTabela.Slf_Tabela_Msglotacao     := null;
                     vTpTabela.Slf_Tabela_Abortalotacao  := null;
                     vTpTabela.Slf_Tabela_Ocupacao       := null;
                     vTpTabela.Slf_Tabela_Comissionado   := null;
                    
                     insert into t_slf_tabela values vTpTabela;
                     commit;

                     vCriaTabela := 'N';
                     vCriaSaque  := 'N';
                  End If;
              
              End If;
            
              vStatus := substr(pStatus,1,1);

              vErro :=  vErro || pkg_glb_html.fn_FechaLista;
              vErro :=  vErro || pkg_glb_html.fn_FechaLista;

--              End If;
              
              If vMostraErro = 'S' Then
                 pMessage := pMessage || vErro;
                 vMostraErro := 'N';
              End If;  

          End If;
           
          End If;

          vErro := '';
          vNrLinha := vNrLinha + 1;

          if mod(vNrLinha,1000) = 0 Then
             commit;
          End IF;
          
          if mod(vNrLinha,5000) = 0 Then
             commit;
          End IF;


          if mod(vNrLinha,10000) = 0 Then
             commit;
          End IF;
          
--          update tdvadm.dropme d 
--            set a = to_char(vNrLinha) || ' - ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss');
--          commit;
              
          vStatus := substr(pStatus,1,1);
          
          exit when trim(nvl(pStatus,'N')) = 'F';
          
       End Loop;
       
       commit;
       
       pMessage :=  pMessage || pkg_glb_html.fn_FechaLista;
       pMessage :=  pMessage || pkg_glb_html.fn_Titulo('FIM');

             
/*          INSERT INTO T_SLF_CLIREGRASVEIC
          SELECT TA.GLB_GRUPOECONOMICO_CODIGO,
                 TA.GLB_CLIENTE_CGCCPFCODIGO,
                 TA.SLF_TABELA_CONTRATO,
                 TA.FCF_TPVEICULO_CODIGO,
                 TV.FCF_TPVEICULO_DESCRICAO,
                 TA.FCF_TPCARGA_CODIGO,
                 TC.FCF_TPCARGA_DESCRICAO,
                 TA.SLF_TABELA_VIGENCIA,
                 'S',
                 0,
                 0,
                 'S',
                 'S'
          FROM tdvadm.T_SLF_TABELA TA,
               tdvadm.T_FCF_TPCARGA TC,
               tdvadm.T_FCF_TPVEICULO TV
          WHERE TA.SLF_TABELA_CONTRATO = vLinha.CONTRATO
            AND TA.FCF_TPVEICULO_CODIGO = TV.FCF_TPVEICULO_CODIGO
            AND TA.FCF_TPCARGA_CODIGO = TC.FCF_TPCARGA_CODIGO
            AND TV.FCF_TPVEICULO_CODIGO <> '9  '
            AND 0 = (SELECT COUNT(*)
                     FROM tdvadm.T_SLF_CLIREGRASVEIC CV
                     WHERE CV.GLB_GRUPOECONOMICO_CODIGO = TA.GLB_GRUPOECONOMICO_CODIGO
                       AND CV.GLB_CLIENTE_CGCCPFCODIGO = TA.GLB_CLIENTE_CGCCPFCODIGO
                       AND CV.SLF_CONTRATO_CODIGO = TA.SLF_TABELA_CONTRATO
                       AND CV.FCF_TPVEICULO_CODIGO = TA.FCF_TPVEICULO_CODIGO
                       AND CV.FCF_TPCARGA_CODIGO = TA.FCF_TPCARGA_CODIGO
                       AND CV.SLF_CLIREGRASVEIC_VIGENCIA = TA.SLF_TABELA_VIGENCIA);

       insert into tdvadm.t_slf_calcfretekm 
       select * from tdvadm.T_SLF_CALCFRETEKMIMP2 KM
       WHERE 0 = (SELECT COUNT(*)
                  FROM TDVADM.T_SLF_CALCFRETEKM KM1
                  WHERE KM1.SLF_TABELA_CODIGO = KM.SLF_TABELA_CODIGO
                    AND KM1.SLF_TABELA_SAQUE = KM.SLF_TABELA_SAQUE
                    AND KM1.SLF_CALCFRETEKM_KMDE = KM.SLF_CALCFRETEKM_KMDE
                    AND KM1.SLF_CALCFRETEKM_KMATE = KM.SLF_CALCFRETEKM_KMATE
                    AND KM1.SLF_CALCFRETEKM_PESODE = KM.SLF_CALCFRETEKM_PESODE
                    AND KM1.SLF_CALCFRETEKM_PESOATE = KM.SLF_CALCFRETEKM_PESOATE
                    AND KM1.SLF_TPCALCULO_CODIGO = KM.SLF_TPCALCULO_CODIGO
                    AND KM1.SLF_RECCUST_CODIGO = KM.SLF_RECCUST_CODIGO
                    AND KM1.SLF_CALCFRETEKM_ORIGEM = KM.SLF_CALCFRETEKM_ORIGEM
                    AND KM1.SLF_CALCFRETEKM_DESTINO = KM.SLF_CALCFRETEKM_DESTINO
                    AND KM1.SLF_CALCFRETEKM_ORIGEMI = KM.SLF_CALCFRETEKM_ORIGEMI
                    AND KM1.SLF_CALCFRETEKM_DESTINOI = KM.SLF_CALCFRETEKM_DESTINOI
                    AND KM1.SLF_CALCFRETEKM_TPFRETE = KM.SLF_CALCFRETEKM_TPFRETE
                    AND KM1.SLF_CALCFRETEKM_OUTRACOLETAI = KM.SLF_CALCFRETEKM_OUTRACOLETAI
                    AND KM1.SLF_CALCFRETEKM_OUTRAENTREGAI = KM.SLF_CALCFRETEKM_OUTRAENTREGAI);
*/
/* SIRLANO DRUMOND 
              insert into   tdvadm.t_slf_clienteped
              select distinct x.grupo,
                              x.cliente,
                              x.codcarga,
                              x.contrato,
                              x.vigencia,
                              'S',
                              x.codveiculo,
                              '99999',
                              '99999',
                              x.origem,
                              x.destino,
                              to_number(replace(nvl(valor,0),',','.')) valor,
                              x.des,
                              x.codcli,
                              nvl(x.OUTRACOL,'99999'),
                              nvl(x.OUTRAENT,'99999')
              from tdvadm.v_slf_tabelaNovaCarga x 
              where x.protocolo = pXLS
              --  and x.codcarga = '02'
                and x.VALOR <> 0
                and x.codverba = 'D_PD'
                and 0 = (select count(*)
                         from tdvadm.t_slf_clienteped cp
                         where cp.GLB_GRUPOECONOMICO_CODIGO = rpad(x.GRUPO,4)
                           and cp.GLB_CLIENTE_CGCCPFCODIGO = rpad(x.CLIENTE,20)
                           and cp.FCF_TPCARGA_CODIGO = rpad(x.CODCARGA,3)
                           and cp.SLF_CONTRATO_CODIGO = x.CONTRATO
                           and cp.SLF_CLIENTEPED_VIGENCIA = to_date(x.VIGENCIA,'DD/MM/YYYY')
                           and cp.SLF_CLIENTEPED_ATIVO = 'S'
                           and cp.FCF_TPVEICULO_CODIGO = rpad(x.CODVEICULO,3)
                           and cp.GLB_LOCALIDADE_CODIGOORI = '99999'
                           and cp.GLB_LOCALIDADE_CODIGODES = '99999'
                           and cp.GLB_LOCALIDADE_CODIGOORIIB = rpad(x.ORIGEM,8)
                           and cp.GLB_LOCALIDADE_CODIGODESIB = rpad(x.DESTINO,8)
                           and cp.GLB_LOCALIDADE_OUTRACOLETAI = rpad(nvl(x.OUTRACOL,'99999'),8)
                           and cp.GLB_LOCALIDADE_OUTRAENTREGAI = rpad(nvl(x.OUTRAENT,'99999'),8));
*/
          
       wservice.pkg_glb_email.SP_ENVIAEMAIL(pXLS,pMessage,'aut-e@dellavolpe.com.br','sirlanodrumond@gmail.com;alexandre.malcar@dellavolpe.com.br');
       commit;
    exception            
      When OTHERS Then
           pStatus := 'E';
           vNrLinha := vNrLinha;
           pMessage := pMessage || chr(13) || 'Planilha ' || pXLS || ' Linha : ' || vNrLinha || ' Erro: ' || sqlerrm || chr(10) || ' Onde ' || DBMS_UTILITY.format_call_stack;
           wservice.pkg_glb_email.SP_ENVIAEMAIL(pXLS,pMessage,'aut-e@dellavolpe.com.br','sirlanodrumond@gmail.com;alexandre.malcar@dellavolpe.com.br');

    End sp_CriaAtulizaTabela;



    Procedure sp_CriaAtulizaValores(pXLS in varchar2,
                                    pStatus out Char,
                                    pMessage out clob)
      Is
      vLinha        tdvadm.v_slf_calcfretekmpreimpCSV%rowtype;
      vLinhaDefault tdvadm.v_slf_calcfretekmpreimpCSV%rowtype;
      vAuxiliar     number;
      vAuxiliarT    varchar2(10);
      vNrLinha      number;
      vCursor       tpCurosr;
      vMessage      clob;
      vSaqueTab     tdvadm.t_slf_tabela.slf_tabela_saque%type;
      vTpTabela     tdvadm.t_slf_tabela%rowtype;
      vTpCalcTabela tdvadm.t_slf_calcfretekm%rowtype;
      vCriaTabela   char(1) := 'N';
      vCriaSaque    char(1) := 'N';
      vSQL          CLOB;
      vErro         varchar2(20000);
      vMostraErro   char(1) := 'N';
      vAliquota     number;
      vSair         char(1) := 'N';
      vVigencia     date;
      vPula         boolean := False;
      cLinhas       tpCurosr;
      vArqcsv       rmadm.t_glb_benasserec.glb_benasserec_fileanexo%type;
      vProtocolo    rmadm.t_glb_benasserec.glb_benasserec_chave%type;
    Begin

    
    -- \TabelasFrete\TABELA_LOTACAO_23_11_2015.xlsx
       delete tdvadm.dropme d where x = pXLS;
--       insert into tdvadm.dropme d
--       (x,a) values (pXLS,'0');
       
       vInserePedagioJunto := vInserePedagioJuntoVZ;
    
       vMSG := 'INICIO';

    
       vSomentePedagio := vSomentePedagio;
       
       DELETE T_SLF_CALCFRETEKMIMP2;  
       
       commit;            
  
       pMessage := pkg_glb_html.Assinatura;
       pMessage := pMessage || pkg_glb_html.fn_Titulo('CRITICA Arquivo ' || pXLS);
       vAuxiliar := 0; 
       vNrLinha  := 1;
       pStatus := 'N';
--       sp_LePlanilha(pXLS,vCursor);

      TDVADM.PKG_SLF_TABELAS.vTABFRETEHORA := to_char(sysdate,'dd/mm/yyyy hh24:mi:ss');

      TDVADM.PKG_SLF_TABELAS.vTABFRETEQTDEREG := 0;

      
      
      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('vTABFRETEHORAI',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('vTABFRETEHORAF','');
      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('vTABFRETETOTREG','0');
      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('vTABFRETEQTDEREG','0');
       
        select upper(br.glb_benasserec_fileanexo),
               br.glb_benasserec_chave
          into vArqcsv,
               vProtocolo
        from rmadm.t_glb_benasserec br
        where upper(br.glb_benasserec_fileanexo) = upper(pXLS);
       
      dbms_output.put_line(pXLS || '-' || vProtocolo || '-' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '-' || vNrLinha);
      
      select count(*)
         into TDVADM.PKG_SLF_TABELAS.vTABFRETETOTREG
      from tdvadm.v_slf_calcfretekmpreimpcsv c
      where upper(c.planilha) = vArqcsv
       and c.CARGA <> 'CARGA';
      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('vTABFRETETOTREG',to_char(TDVADM.PKG_SLF_TABELAS.vTABFRETETOTREG));


      for c_msg in (select distinct 
                           s.CODTPORIGEM,
                           s.CODTPDESTINO,
                           s.CODCARGA,
                           rpad(trim(s.CODVEICULO),3) CODVEICULO,
                           s.DES,
                           s.CODVERBA
                      from tdvadm.v_slf_calcfretekmpreimpcsv s
                     where s.CODVERBA = 'D_PD'
                     and s.CARGA <> 'CARGA'
                     and upper(s.planilha) = vArqcsv)
      loop      
       -- REGRAS para que o PEDAGIO fique Em TABELA SEPARADA T_SLF_CLIENTPED
       If ( (TRIM(c_msg.codtporigem) = 'IB' and TRIM(c_msg.codtpdestino) = 'IB' ) and ( TRIM(c_msg.codverba) = 'D_PD' ) ) and
          ( ( TRIM(c_msg.CODVEICULO) <> '9' and TRIM(c_msg.DES) = 'VL' ) /*or ( TRIM(c_msg.CODVEICULO) = '9' and TRIM(c_msg.DES) = 'TX' )*/ )  Then
          vInserePedagioJunto(trim(c_msg.codcarga) || trim(c_msg.CODTPORIGEM) || trim(c_msg.CODTPDESTINO)).Asstring := 'N';
          -- Se não atender fica junto com o FRETE
       Else
          vInserePedagioJunto(trim(c_msg.codcarga) || trim(c_msg.CODTPORIGEM) || trim(c_msg.CODTPDESTINO)).Asstring := 'S';
       End If;        
      End Loop;
      
      
      
       open cLinhas FOR select c.protocolo,
                                               c.planilha,
                                               c.sistema,
                                               c.SHEET_NR,
                                               c.SHEET_NAME,
                                               c.ROW_NR,
                                               c.TIPOLINHA,
                                               c.TABELA,
                                               c.TIPOTAB,
                                               c.COLENT,
                                               c.VIGENCIA,
                                               c.GRUPO,
                                               c.CLIENTE,
                                               c.CONTRATO,
                                               c.CARGA,
                                               C.VENDEDOR,
                                               c.VEICULO,
                                               c.PESODE,
                                               c.PESOATE,
                                               c.KMDE,
                                               c.KMATE,
                                               c.TPORIGEM,
                                               c.ORIGEM,
                                               c.TPDESTINO,
                                               c.DESTINO,
                                               c.valor,
                                               c.DES,
                                               c.TIPO,
                                               c.COMIMP,
                                               c.CODCLI,
                                               c.VERBA,
                                               c.limite,
                                               c.valoRe,
                                               c.DESE,
                                               c.valorfixo,
                                               c.DESFIXO,
                                               c.RAIOKMORIGEM,
                                               c.RAIOKMDESTINO,
                                               c.CODCARGA,
                                               c.CODVEICULO,
                                               c.CODTPORIGEM,
                                               c.CODTPDESTINO,
                                               c.CODVERBA,
                                               c.OUTRACOL,
                                               c.OUTRAENT,
                                               c.DATAGRAVACAO,
                                               C.CODVVEN
                        from tdvadm.v_slf_calcfretekmpreimpcsv c
                        where 0 = 0 --c.protocolo = pXLS
                          and upper(c.planilha) = vArqcsv
                          and c.CARGA <> 'CARGA';
       loop
         fetch cLinhas
         into vLinha;
       Exit When cLinhas%Notfound;
       
       If vNrLinha = 2082 Then
          vNrLinha  := vNrLinha;
       End If;
       
       vMSG := 'Pegando registro ' ||  vNrLinha ;
       
       Begin
          -- para testar se a variavel existe
          vAuxiliarT := vInserePedagioJunto(trim(vLinha.codcarga) || trim(vLinha.CODTPORIGEM) || trim(vLinha.CODTPDESTINO)).Asstring;
         exception
           when NO_DATA_FOUND Then
              -- se não existir
              vInserePedagioJunto(trim(vLinha.codcarga) || trim(vLinha.CODTPORIGEM) || trim(vLinha.CODTPDESTINO)).Asstring := 'S';
           when OTHERS Then
              -- se não existir
              vInserePedagioJunto(trim(vLinha.codcarga) || trim(vLinha.CODTPORIGEM) || trim(vLinha.CODTPDESTINO)).Asstring := 'S';
           End;

       if vLinha.COLENT = 'AMBOS' Then
          vLinha.COLENT := 'N';
       Else
          vLinha.COLENT := substr(vLinha.COLENT,1,1);
       End If;

       vLinhaDefault := vLinha;
       
--          sp_PegaLinhaValores(pXLS,vLinha,vLinhaDefault,vNrLinha,pStatus,vMessage);  
--          if vNrLinha > 10 Then
--             pStatus := 'F';
--          End IF;
          
          vMSG := 'Após Linha Default ' ||  vNrLinha ;
          
          vPula := False;

          pStatus := substr(pStatus,1,1);
          pStatus := substr(pStatus,1,1);
          
          vMSG := 'Antes de linha das Verbas ' || vNrLinha;
          
          If ( vLinha.CODVERBA = 'D_PD' ) Then
             vLinha.CODVERBA := vLinha.CODVERBA;
          End If;
          
          vMSG := 'No meio do IF de Verbas ' || vNrLinha;
          
          IF ( vLinha.CODVERBA <> 'D_PD' ) or 
             ( vInserePedagioJunto(trim(vLinha.codcarga) || trim(vLinha.CODTPORIGEM) || trim(vLinha.CODTPDESTINO)).Asstring = 'S' ) Then
          
          vMSG := 'Inicio do IF ' || vNrLinha;
          
          if vNrLinha = 2 Then
             pStatus := pStatus;
          End IF;
          if vSair = 'S' Then
             exit;
          End If; 
            
          exit when trim(nvl(pStatus,'N')) = 'F';

          if vNrLinha = 376 Then
             vNrLinha := vNrLinha;
          End If;
          
          vLinha.TABELA        := trim(nvl(vLinha.TABELA,vLinhaDefault.TABELA));
          If length(trim(vLinha.TABELA)) = 0 Then
             vLinha.TABELA := null;
          End If;
          if tdvadm.f_enumerico(vLinha.TABELA) = 'N' Then
             vLinha.TABELA := null;
          End If;
          vLinha.TIPOTAB       := nvl(vLinha.TIPOTAB,vLinhaDefault.TIPOTAB);
          If vLinha.TIPOTAB = 'AMB' Then
             vTipoTab := 'AMB';
             If vTipoRodando = 'XXX' Then
                vTipoRodando := 'CIF';
                vLinha.TIPOTAB := 'CIF';
             Else
                vLinha.TIPOTAB := vTipoRodando;  
             End If;
          Else
             vTipoRodando := vLinha.TIPOTAB;
          End If;   

          vMSG := 'Antes de Preencher variaveis ' ||  vNrLinha ;

          vLinha.COLENT        := nvl(vLinha.COLENT,vLinhaDefault.COLENT);
          vLinha.VIGENCIA      := nvl(vLinha.VIGENCIA,vLinhaDefault.VIGENCIA);
          vLinha.GRUPO         := lpad(nvl(vLinha.GRUPO,vLinhaDefault.GRUPO),4,'0');
          vLinha.CLIENTE       := nvl(vLinha.CLIENTE,vLinhaDefault.CLIENTE);
          vLinha.CONTRATO      := nvl(vLinha.CONTRATO,vLinhaDefault.CONTRATO);
          vLinha.CARGA         := nvl(vLinha.CARGA,vLinhaDefault.CARGA);
          vLinha.VEICULO       := nvl(vLinha.VEICULO,vLinhaDefault.VEICULO);
          vLinha.VEICULO       := nvl(vLinha.VEICULO,vLinhaDefault.VEICULO);
          vLinha.PESODE        := replace(replace(nvl(nvl(vLinha.PESODE,vLinhaDefault.PESODE),0),'.',''),',','.');
          vLinha.PESOATE       := replace(replace(nvl(nvl(vLinha.PESOATE,vLinhaDefault.PESOATE),9999999),'.',''),',','.');
          vLinha.KMDE          := nvl(nvl(vLinha.KMDE,vLinhaDefault.KMDE),0);
          vLinha.KMATE         := nvl(nvl(vLinha.KMATE,vLinhaDefault.KMATE),9999);
          vLinha.TPORIGEM      := nvl(vLinha.TPORIGEM,vLinhaDefault.TPORIGEM);
          vLinha.ORIGEM        := trim(nvl(vLinha.ORIGEM,vLinhaDefault.ORIGEM));
          vLinha.TPDESTINO     := nvl(vLinha.TPDESTINO,vLinhaDefault.TPDESTINO);
          vLinha.DESTINO       := trim(nvl(vLinha.DESTINO,vLinhaDefault.DESTINO));
          vLinha.VALOR         := fn_arumavalor(nvl(vLinha.VALOR,vLinhaDefault.VALOR));
          vLinha.DES           := nvl(vLinha.DES,vLinhaDefault.DES);
          vLinha.TIPO          := nvl(vLinha.TIPO,vLinhaDefault.TIPO);
          vLinha.COMIMP        := nvl(nvl(vLinha.COMIMP,vLinhaDefault.COMIMP),'N');
          vLinha.CODCLI        := nvl(vLinha.CODCLI,vLinhaDefault.CODCLI);
          vLinha.VERBA         := nvl(vLinha.VERBA,vLinhaDefault.VERBA);
          vLinha.LIMITE        := fn_arumavalor(nvl(vLinha.LIMITE,vLinhaDefault.LIMITE));
          vLinha.VALORE        := fn_arumavalor(nvl(vLinha.VALORE,vLinhaDefault.VALORE));
          vLinha.DESE          := trim(nvl(vLinha.DESE,vLinhaDefault.DESE));
          vLinha.VALORFIXO     := fn_arumavalor(nvl(vLinha.VALORFIXO,vLinhaDefault.VALORFIXO));
          vLinha.DESFIXO       := nvl(vLinha.DESFIXO,vLinhaDefault.DESFIXO);
          vLinha.RAIOKMORIGEM  := fn_arumavalor(nvl(vLinha.RAIOKMORIGEM,vLinhaDefault.RAIOKMORIGEM));
          vLinha.RAIOKMDESTINO := fn_arumavalor(nvl(vLinha.RAIOKMDESTINO,vLinhaDefault.RAIOKMDESTINO));
          vLinha.CODCARGA      := rpad(lpad(nvl(vLinha.CODCARGA,vLinhaDefault.CODCARGA),2,'0'),3);
          vLinha.OUTRACOL      := nvl(trim(vLinha.OUTRACOL),vLinhaDefault.OUTRACOL);
          vLinha.OUTRAENT      := nvl(trim(vLinha.OUTRAENT),vLinhaDefault.OUTRAENT);
          Begin
             vLinha.CODVEICULO    := trim(to_char(to_number(nvl(vLinha.CODVEICULO,vLinhaDefault.CODVEICULO))));
          Exception
            When OTHERS Then
               vLinha.CODVEICULO := null;
            End;
          vLinha.CODTPORIGEM   := nvl(vLinha.CODTPORIGEM,vLinhaDefault.CODTPORIGEM);
          vLinha.CODTPDESTINO  := nvl(vLinha.CODTPDESTINO,vLinhaDefault.CODTPDESTINO);
          vLinha.CODVERBA      := TRIM(nvl(vLinha.CODVERBA,vLinhaDefault.CODVERBA));

          If vLinha.ORIGEM in ('ARM06','ARM 06') Then
             Vlinha.ORIGEM := '05571';
          ElsIf vLinha.ORIGEM in ('ARM07','ARM 07') Then
             Vlinha.ORIGEM := '32001';
          ElsIf vLinha.ORIGEM in ('ARM10','ARM 10') Then
             vLinha.ORIGEM := '68515';
          ElsIf vLinha.ORIGEM in ('ARM15','ARM 15') Then
             Vlinha.ORIGEM := '20000';
          ElsIf vLinha.ORIGEM in ('ARM18','ARM 18') Then
             vLinha.ORIGEM := '67001';
          ElsIf vLinha.ORIGEM in ('ARM23','ARM 23') Then
             vLinha.ORIGEM := '67001';
          ElsIf vLinha.ORIGEM in ('ARM24','ARM 24') Then
             vLinha.ORIGEM := '38400';
          ElsIf vLinha.ORIGEM in ('ARM25','ARM 25') Then
             vLinha.ORIGEM := '80000';
          ElsIf vLinha.ORIGEM in ('ARM27','ARM 27') Then
             vLinha.ORIGEM := '88300';
          ElsIf vLinha.ORIGEM in ('ARM34','ARM 34') Then
             vLinha.ORIGEM := '68500';
          End If;          

          If vLinha.DESTINO in ('ARM06','ARM 06') Then
             Vlinha.DESTINO := '05571';
          ElsIf vLinha.DESTINO in ('ARM07','ARM 07') Then
             Vlinha.DESTINO := '32001';
          ElsIf vLinha.DESTINO in ('ARM10','ARM 10') Then
             vLinha.DESTINO := '68515';
          ElsIf vLinha.DESTINO in ('ARM15','ARM 15') Then
             Vlinha.DESTINO := '20000';
          ElsIf vLinha.DESTINO in ('ARM18','ARM 18') Then
             vLinha.DESTINO := '67001';
          ElsIf vLinha.DESTINO in ('ARM23','ARM 23') Then
             vLinha.DESTINO := '67001';
          ElsIf vLinha.DESTINO in ('ARM24','ARM 24') Then
             vLinha.DESTINO := '38400';
          ElsIf vLinha.DESTINO in ('ARM25','ARM 25') Then
             vLinha.DESTINO := '80000';
          ElsIf vLinha.DESTINO in ('ARM27','ARM 27') Then
             vLinha.DESTINO := '88300';
          ElsIf vLinha.DESTINO in ('ARM34','ARM 34') Then
             vLinha.DESTINO := '68500';
          End If;          

          vPula := False;
          
          If ( vLinha.CODVERBA = 'D_PD' ) and  
             ( vInserePedagioJunto(trim(vLinha.codcarga) || trim(vLinha.CODTPORIGEM) || trim(vLinha.CODTPDESTINO)).Asstring = 'N') Then

             vPula := vPula;
             vPula := True;
             
          End If; 

          If Not vPula Then 


              if vLinha.CODTPORIGEM = 'NN' Then
                 vLinha.ORIGEM        := '99999';
              End If; 

              if vLinha.CODTPDESTINO = 'NN' Then
                 vLinha.DESTINO        := '99999';
              End If; 
              
              vLinha.OUTRACOL := nvl(vLinha.OUTRACOL,'99999');
              vLinha.OUTRAENT := nvl(vLinha.OUTRAENT,'99999');
              


              if vLinha.ORIGEM = '3515707' Then          
                 vLinha.ORIGEM := vLinha.ORIGEM;
              End If;   

              -- Se for da Mesma UF não tem imposto imbutido
--              if ( fn_busca_codigoibge(trim(vLinha.ORIGEM),'UF') = fn_busca_codigoibge(trim(vLinha.DESTINO),'UF') ) and 
--                 ( vLinha.COMIMP = 'S' ) Then
--                 vLinha.COMIMP := 'N';
--              End If;
              
              If nvl(vLinha.COMIMP,'N') = 'S' Then
                 vAliquota := PKG_SLF_CALCULOS.fn_retorna_aliquota(vLinha.ORIGEM,vLinha.DESTINO,null,trunc(sysdate));
                 If vAliquota <= 0 Then
                    vMostraErro := 'S';
                    vErro :=  vErro || pkg_glb_html.fn_ItensLista('-Aliquota Zerada ' || vNrLinha  || ' Usando Tabela ' || vLinha.TABELA || '-' || vSaqueTab || 'Origem  ' || vLinha.ORIGEM || 'Destino ' || vLinha.DESTINO);
                    vErro :=  vErro || pkg_glb_html.fn_ItensLista('erro : ' || sqlerrm);
                 End If;
              End If;   
                   
--             if vLinha.VERBA <> 'COLETA' Then

               If vLinha.VERBA = 'COLETA' Then
                  vLinha.CODVERBA := 'D_FRPSVO';
               End If;

              vErro :=  vErro || pkg_glb_html.fn_AbreLista;
              vErro :=  vErro || pkg_glb_html.fn_ItensLista('Linha ' || vNrLinha);
              vErro :=  vErro || pkg_glb_html.fn_AbreLista;

              -- Validacoes Basicas

              Begin
                vLinha.VIGENCIA := to_date(vLinha.VIGENCIA,'dd/mm/yyyy');
              Exception
                When OTHERS Then
                   pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('Erro na Vigencia ' || vLinha.VIGENCIA  );
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('erro : ' || sqlerrm);
                End ;


              if vLinha.CLIENTE is Null Then
                pStatus := 'E';
                vMostraErro := 'S';
                vErro :=  vErro || pkg_glb_html.fn_ItensLista('Cliente não Informado');
/* SIRLANO DRUMOND
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_glb_cliente cl
                 where trim(cl.glb_cliente_cgccpfcodigo) = trim(vLinha.CLIENTE);
                 if vAuxiliar = 0 Then
                    vAuxiliar := length(trim(replace(vLinha.CLIENTE,'9','')));
                    if nvl(vAuxiliar,0) = 0 Then
                       vLinha.CLIENTE := tdvadm.pkg_fifo_carregctrc.QualquerCliente;
                    Else     
                      pStatus := 'E';
                      vMostraErro := 'S';
                      vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CLIENTE || '] -Cliente não existe');
                    End If;  
                End If;   
*/
              End If; 
                
              If vLinha.CONTRATO is Null Then
                pStatus := 'E';
                vMostraErro := 'S';
                vErro :=  vErro || pkg_glb_html.fn_ItensLista('Contrato não Informado');
/* SIRLANO DRUMOND
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_slf_contrato cl
                 where cl.slf_contrato_codigo = vLinha.CONTRATO;

                 if vAuxiliar = 0 Then
                    pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CONTRATO || '] -Contrato não existe');
                End If;   
*/
              End If; 
                
              If vLinha.GRUPO is Null Then
                 vLinha.GRUPO := '9999';
/* SIRLANO DRUMOND
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_glb_grupoeconomico cl
                 where cl.glb_grupoeconomico_codigo = vLinha.GRUPO;
                 if vAuxiliar = 0 Then
                    pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.GRUPO || '] -Grupo Economico não existe');
                End If;   
*/
              End If; 

              If vLinha.CODCARGA is Null Then
                pStatus := 'E';
                vErro :=  vErro || pkg_glb_html.fn_ItensLista('Tipo de Carga não Informado');
/* SIRLANO DRUMOND
              Else
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_fcf_tpcarga cl
                 where cl.fcf_tpcarga_codigo = rpad(vLinha.CODCARGA,3);
                 if vAuxiliar = 0 Then
                    pStatus := 'E'
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CODCARGA || '-' || vLinha.CARGA || '] -Carga não existe');
                End If;   
*/
              End If; 
              
              If vLinha.CODVEICULO is NOT Null Then
                 vAuxiliar := 1;
/* SIRLANO DRUMOND
                 select count(*)
                   into vAuxiliar
                 from tdvadm.t_fcf_tpveiculo cl
                 where cl.fcf_tpveiculo_codigo = rpad(vLinha.CODVEICULO,3);
                 if vAuxiliar = 0 Then
                    pStatus := 'E';
                   vMostraErro := 'S';
                   vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.CODVEICULO || '-' || vLinha.VEICULO || '] -Veiculo não existe');
                End If;  
*/
              Else
                vLinha.CODVEICULO := '9';   
              End If; 

              -- Verifica se tem regra
              
              vSQL := empty_clob;
              vSQL := vSQL || 'select count(*) ';
              vSQL := vSQL || 'from tdvadm.v_slf_clientecargas_tra cc ';
              vSQL := vSQL || ' Where 0 = 0 ';
              VSQL := vSQL || '  and cc.planilha = ' || pkg_glb_common.Fn_QuotedStr(trim(pXLS));
              vSQL := vSQL || '  and substr(cc.TpCarga,1,2) = ' ||  pkg_glb_common.Fn_QuotedStr(trim(vLinha.CODCARGA)) ;
              If vLinha.GRUPO <> tdvadm.pkg_fifo_carregctrc.QualquerGrupo Then
                 vSQL := vSQL || '  and cc.Grupo = ' || pkg_glb_common.Fn_QuotedStr(vLinha.GRUPO) ;
              End If;
              if vLinha.CLIENTE <> tdvadm.pkg_fifo_carregctrc.QualquerCliente Then
                 vSQL := vSQL || ' and cc.cnpj = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CLIENTE) ;
              End If;   
              if vLinha.CONTRATO <> tdvadm.pkg_fifo_carregctrc.QualquerContrato Then
                 vSQL := vSQL || ' and cc.contrato = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CONTRATO) ;
              End If;   
              if vLinha.CODVEICULO = TRIM(tdvadm.pkg_fifo_carregctrc.TpVFracionado) Then
                 vSQL := vSQL || ' and cc.usaveiculo = ' ||  pkg_glb_common.Fn_QuotedStr('N') ;
              Else
                 vSQL := vSQL || ' and cc.usaveiculo = ' ||  pkg_glb_common.Fn_QuotedStr('S') ;
              End If;   
              vSQL := vSQL || ' and cc.tporigem = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CODTPORIGEM) ;
              vSQL := vSQL || ' and cc.tpdestino = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CODTPDESTINO) ;
                        
/* SIRLANO DRUMOND
              execute immediate vSQL into vAuxiliar;
*/

vAuxiliar := 1;

              -- Pesquisa se nao existe regra para Coleta
              If vAuxiliar = 0 Then
                  vSQL := empty_clob;
                  vSQL := vSQL || 'select count(*) ';
                  vSQL := vSQL || 'from tdvadm.v_slf_clientecargas_tra cc ';
                  vSQL := vSQL || ' Where 0 = 0 ';
                  vSQL := vSQL || '  and substr(cc.TpCargaCol,1,2) = ' ||  pkg_glb_common.Fn_QuotedStr(trim(vLinha.CODCARGA)) ;
                  If vLinha.GRUPO <> tdvadm.pkg_fifo_carregctrc.QualquerGrupo Then
                     vSQL := vSQL || '  and cc.Grupo = ' || pkg_glb_common.Fn_QuotedStr(vLinha.GRUPO) ;
                  End If;
                  if vLinha.CLIENTE <> tdvadm.pkg_fifo_carregctrc.QualquerCliente Then
                     vSQL := vSQL || ' and cc.cnpj = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CLIENTE) ;
                  End If;   
                  if vLinha.CONTRATO <> tdvadm.pkg_fifo_carregctrc.QualquerContrato Then
                     vSQL := vSQL || ' and cc.contrato = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CONTRATO) ;
                  End If;   
    /*  Uso de Veiculo não implementado na coleta
                  if vLinha.CODVEICULO = tdvadm.pkg_fifo_carregctrc.TpVFracionado Then
                     vSQL := vSQL || ' and cc.usaveiculo = ' ||  pkg_glb_common.Fn_QuotedStr('N') ;
                  Else
                     vSQL := vSQL || ' and cc.usaveiculo = ' ||  pkg_glb_common.Fn_QuotedStr('S') ;
                  End If;   
    */
                  vSQL := vSQL || ' and cc.tporigemcoleta = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CODTPORIGEM) ;
                  vSQL := vSQL || ' and cc.tpdestinocoleta = ' ||  pkg_glb_common.Fn_QuotedStr(vLinha.CODTPDESTINO) ;

                  execute immediate vSQL into vAuxiliar;

              End If;

              If vAuxiliar = 0 Then
                 pStatus := 'E';
                 vMostraErro := 'S';
    --             insert into t_glb_sql values (vSql, sysdate,'IMPTAB','Carga [' || vLinha.CODCARGA || '] Grupo [' || vLinha.GRUPO || '] Cliente [' || vLinha.CLIENTE ||  '] Contrato [' || vLinha.CONTRATO || '] TPOrigem [' || vLinha.CODTPORIGEM || '] TPDestino [' || vLinha.CODTPDESTINO || ']');
                 vErro :=  vErro || pkg_glb_html.fn_ItensLista('Não existe Regra para esta linha');
                 vErro :=  vErro || pkg_glb_html.fn_ItensLista('Carga [' || vLinha.CODCARGA || '] Grupo [' || vLinha.GRUPO || '] Cliente [' || vLinha.CLIENTE ||  '] Contrato [' || vLinha.CONTRATO || '] TPOrigem [' || vLinha.CODTPORIGEM || '] TPDestino [' || vLinha.CODTPDESTINO || '] Verba ['  || vLinha.CODVERBA || ']' );
                 
              End If;  

              If pStatus <> 'E' Then
            

                  if vLinha.TABELA is NOT Null Then
                     Begin
                        select ta.slf_tabela_saque,
                               ta.slf_tabela_vigencia
                          into vSaqueTab,
                               vVigencia
                        from tdvadm.t_slf_tabela ta
                        where ta.slf_tabela_codigo = vLinha.TABELA
                          and trim(ta.fcf_tpcarga_codigo) = trim(vLinha.CODCARGA)
                          and trim(ta.fcf_tpveiculo_codigo) = trim(vLinha.CODVEICULO)
                          and trim(ta.glb_grupoeconomico_codigo) = trim(decode(vLinha.GRUPO,tdvadm.pkg_fifo_carregctrc.QualquerGrupo,ta.glb_grupoeconomico_codigo,vLinha.GRUPO))
                          and trim(ta.glb_cliente_cgccpfcodigo)  = trim(decode(vLinha.CLIENTE,tdvadm.pkg_fifo_carregctrc.QualquerCliente,ta.glb_cliente_cgccpfcodigo,vLinha.CLIENTE))
                          and trim(ta.slf_tabela_contrato)       = trim(decode(vLinha.CONTRATO,tdvadm.pkg_fifo_carregctrc.QualquerContrato,ta.slf_tabela_contrato,vLinha.CONTRATO))
                          and ta.slf_tabela_tipo  = vLinha.TIPOTAB
                          and ta.slf_tabela_coletaentrega in ('A','N',vLinha.COLENT) 
                          and nvl(ta.slf_tabela_status,'N') = 'N'
                          and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                                     from tdvadm.t_slf_tabela ta1
                                                     where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                       and ta.slf_tabela_vigencia <= vLinha.VIGENCIA
                                                       and nvl(ta.slf_tabela_status,'N') = 'N');
                       If vVigencia < vLinha.VIGENCIA Then
                          vCriaSaque := 'S';
                       End If;
                     Exception
                       When NO_DATA_FOUND Then
                          pStatus := 'E';
                          vMostraErro := 'S';
                          vErro :=  vErro || pkg_glb_html.fn_ItensLista('[' || vLinha.TABELA  || '] -Tabela não existe');
                       End ;
                  Else
                     -- Procura qual tabela Atende esta regra.
                     Begin
                        Select slf_tabela_codigo,
                               slf_tabela_saque,
                               slf_tabela_vigencia
                          into vLinha.TABELA,
                               vSaqueTab,
                               vVigencia
                        From (select ta.slf_tabela_codigo,
                                     ta.slf_tabela_saque,
                                     ta.slf_tabela_vigencia
                              from tdvadm.t_slf_tabela ta
                              where 0 = 0
                                and trim(ta.fcf_tpcarga_codigo) = trim(vLinha.CODCARGA)
                                and trim(ta.fcf_tpveiculo_codigo) = trim(vLinha.CODVEICULO)
                                and trim(ta.glb_grupoeconomico_codigo) = trim(decode(vLinha.GRUPO,tdvadm.pkg_fifo_carregctrc.QualquerGrupo,ta.glb_grupoeconomico_codigo,vLinha.GRUPO))
                                and trim(ta.glb_cliente_cgccpfcodigo)  = trim(decode(vLinha.CLIENTE,tdvadm.pkg_fifo_carregctrc.QualquerCliente,ta.glb_cliente_cgccpfcodigo,vLinha.CLIENTE))
                                and trim(ta.slf_tabela_contrato) = trim(decode(vLinha.CONTRATO,tdvadm.pkg_fifo_carregctrc.QualquerContrato,ta.slf_tabela_contrato,vLinha.CONTRATO))
                                and ta.slf_tabela_tipo  = vLinha.TIPOTAB
                                and ta.slf_tabela_coletaentrega in ('A','N',vLinha.COLENT) 
                                and nvl(ta.slf_tabela_status,'N') = 'N'
                                and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                                           from tdvadm.t_slf_tabela ta1
                                                           where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                             and ta1.slf_tabela_vigencia <= TO_DATE(vLinha.VIGENCIA,'DD/MM/YYYY')
                                                             and nvl(ta1.slf_tabela_status,'N') = 'N'));

                          If nvl(vLinha.TABELA,'XX') = 'XX' Then
                             vCriaTabela := 'S';
                          ElsIf vVigencia < vLinha.VIGENCIA Then
                             vCriaSaque := 'S';
                          Else   
                                vErro :=  vErro || pkg_glb_html.fn_ItensLista('-Usando Tabela ' || vLinha.TABELA || '-' || vSaqueTab);
                             
                          End If;   
                          If tdvadm.f_enumerico(nvl(vLinha.TABELA,'000')) = 'N' Then
                             vLinha.TABELA := vLinha.TABELA;
                          End If;
                     Exception 
                       When NO_DATA_FOUND Then
                          vCriaTabela := 'S';
                       when Others Then
                          vErro := sqlerrm;
                     End ;              
                  End If;

                  vMSG := 'Contando se existe linhas de calculo vlinha ' || vNrLinha;
                  
                  If vNrLinha = 2 Then
                      vNrLinha  := vNrLinha;
                  End If;
                  
                 -- Consulta se ja existe a praca cadastrada
                  select count(*)
                    into vAuxiliar
                 from tdvadm.t_Slf_Calcfretekm km
                 where km.slf_tabela_codigo          = vLinha.TABELA
                   and km.slf_tabela_saque           = vSaqueTab
                   and km.slf_calcfretekm_kmde       = vLinha.KMDE
                   and km.slf_calcfretekm_kmate      = vLinha.KMATE
                   and km.slf_calcfretekm_pesode     = vLinha.PESODE
                   and km.slf_calcfretekm_pesoate    = vLinha.PESOATE
                   and km.slf_tpcalculo_codigo       in ('041','315')
                   and km.slf_reccust_codigo         = vLinha.CODVERBA
                   and km.SLF_CALCFRETEKM_ORIGEM     = km.SLF_CALCFRETEKM_ORIGEM
                   and km.SLF_CALCFRETEKM_DESTINO    = km.SLF_CALCFRETEKM_DESTINO
                   and km.slf_calcfretekm_origemi    = vLinha.ORIGEM
                   and km.slf_calcfretekm_destinoi   = vLinha.DESTINO
                   and km.SLF_CALCFRETEKM_TPFRETE    = km.SLF_CALCFRETEKM_TPFRETE
                   and SLF_CALCFRETEKM_OUTRACOLETAI  = SLF_CALCFRETEKM_OUTRACOLETAI
                   and SLF_CALCFRETEKM_OUTRAENTREGAI = SLF_CALCFRETEKM_OUTRAENTREGAI;

                  If vAuxiliar = 0 Then                  
              
                      -- Verificando as verbas
                      -- ve se ja não existe 
                      select count(*)
                        into vAuxiliar
                     from tdvadm.T_SLF_CALCFRETEKMIMP2 km,
                          tdvadm.t_slf_tabela ta
                     where km.slf_tabela_codigo              = RPAD(vLinha.TABELA,8)
                       and km.slf_tabela_saque               = RPAD(vSaqueTab,4)
                       and km.slf_tabela_codigo              = ta.slf_tabela_codigo
                       and km.slf_tabela_saque               = ta.slf_tabela_saque
                       and ta.slf_tabela_tipo                = TRIM(vLinha.TIPOTAB)
                       and km.slf_calcfretekm_kmde           = to_number(vLinha.KMDE)
                       and km.slf_calcfretekm_kmate          = to_number(vLinha.KMATE)
                       and km.slf_calcfretekm_pesode         = to_number(vLinha.PESODE)
                       and km.slf_calcfretekm_pesoate        = to_number(vLinha.PESOATE)
--                       and km.slf_tpcalculo_codigo           = '0 41'
                       and km.slf_reccust_codigo             = RPAD(vLinha.CODVERBA,10)
                       and km.slf_calcfretekm_origemi        = RPAD(vLinha.ORIGEM,8)
                       and km.slf_calcfretekm_destinoi       = RPAD(vLinha.DESTINO,8)
                       and km.slf_calcfretekm_outracoletai   = RPAD(vLinha.OUTRACOL,8)
                       and km.slf_calcfretekm_outraentregai  = RPAD(vLinha.OUTRAENT,8);
                   
                 End If;
                 
                 If vAuxiliar = 0 Then
                 /*NotNull*/   vTpCalcTabela.Slf_Tabela_Codigo             := vLinha.TABELA;
                 /*NotNull*/   vTpCalcTabela.Slf_Tabela_Saque              := vSaqueTab;
                 /*NotNull*/   vTpCalcTabela.Slf_Calcfretekm_Kmde          := vLinha.KMDE;
                 /*NotNull*/   vTpCalcTabela.Slf_Calcfretekm_Kmate         := vLinha.KMATE;
                 /*NotNull*/   vTpCalcTabela.Slf_Calcfretekm_Pesode        := vLinha.PESODE;
                 /*NotNull*/   vTpCalcTabela.Slf_Calcfretekm_Pesoate       := vLinha.PESOATE; 
                 /*NotNull*/   vTpCalcTabela.Slf_Tpcalculo_Codigo          := '041';

                     if ( vLinha.CONTRATO = 'C2013010022' ) Then -- LOT-VOLKSWAGEN-0113-XXX
                        vTpCalcTabela.Slf_Tpcalculo_Codigo := '315';
                     end If   ;
                     If vLinha.GRUPO = '0020' Then
                        vTpCalcTabela.Slf_Tpcalculo_Codigo := '315';
                     End If;

                 /*NotNull*/   vTpCalcTabela.Slf_Reccust_Codigo            := vLinha.CODVERBA;

                    vLinha.TIPO :=  vLinha.TIPO;
                    if ( vLinha.TIPO = 'KG' and  vLinha.DES = 'TX'  and  vLinha.CODVERBA = 'D_FRPSVO' )  Then
                       vTpCalcTabela.Slf_Calcfretekm_Valor      := vLinha.VALOR * 1000;
                    ElsIf  vLinha.TIPO = 'TON' Then  
                       vTpCalcTabela.Slf_Calcfretekm_Valor      := vLinha.VALOR;
                    ElsIf  vLinha.TIPO = 'VIAG' Then  
                       vTpCalcTabela.Slf_Calcfretekm_Valor      := vLinha.VALOR;
                    -- Verificar depois como ficou a Formula
                    ElsIf  vLinha.TIPO = 'KM' Then  
                       vTpCalcTabela.Slf_Calcfretekm_Valor      := vLinha.VALOR;
                       vTpCalcTabela.Slf_Calcfretekm_Desinencia := 'KM';
                    Else
                       vTpCalcTabela.Slf_Calcfretekm_Valor      := vLinha.VALOR;
                    End If;
     
                    
                    
                    -- Colocar a funcao aqui
                    if nvl(vLinha.COMIMP,'N') = 'S' Then
                       vTpCalcTabela.Slf_Calcfretekm_Valor      := vTpCalcTabela.Slf_Calcfretekm_Valor * ((100 - vAliquota) / 100) ;
                    End If;

                    If vLinha.CODVERBA not in ('D_ADVL','D_OT3') Then
                       vTpCalcTabela.Slf_Calcfretekm_Valor         := round(vTpCalcTabela.Slf_Calcfretekm_Valor,2);
                    End If;   
                    vTpCalcTabela.Slf_Calcfretekm_Desinencia    := vLinha.DES;
                    vTpCalcTabela.Slf_Calcfretekm_Codcli        := lpad(vNrLinha,4,'0') || '-' || vLinha.CODCLI;
                    /*NotNull*/vTpCalcTabela.Slf_Calcfretekm_Origem        := '99999';
                    /*NotNull*/vTpCalcTabela.Slf_Calcfretekm_Destino       := '99999';
                    /*NotNull*/vTpCalcTabela.Slf_Calcfretekm_Origemi       := vLinha.ORIGEM;
                    /*NotNull*/vTpCalcTabela.Slf_Calcfretekm_Destinoi      := vLinha.DESTINO;
                    vTpCalcTabela.Slf_Calcfretekm_Limite        := vLinha.LIMITE;
                    vTpCalcTabela.Slf_Calcfretekm_Valore        := vLinha.VALORE;
                    vTpCalcTabela.Slf_Calcfretekm_Desinenciae   := vLinha.DESE;
                    vTpCalcTabela.Slf_Calcfretekm_Valorf        := vLinha.VALORFIXO;
                    vTpCalcTabela.Slf_Calcfretekm_Desinenciaf   := vLinha.DESFIXO;
                    vTpCalcTabela.Slf_Calcfretekm_Raiokmorigem  := vLinha.RAIOKMORIGEM;
                    vTpCalcTabela.Slf_Calcfretekm_Raiokmdestino := vLinha.RAIOKMDESTINO;
                    /*NotNull*/vTpCalcTabela.Slf_Calcfretekm_Outracoletai  := vLinha.OUTRACOL;
                    /*NotNull*/vTpCalcTabela.Slf_Calcfretekm_Outraentregai := vLinha.OUTRAENT;
                    vTpCalcTabela.Slf_Calcfretekm_Dtgravacao    := sysdate;
                    

                 
                    Begin
                       SELECT TF.SLF_TPFRETE_CODIGO
                         /*NotNull*/INTO vTpCalcTabela.Slf_Calcfretekm_Tpfrete
                       FROM TDVADM.T_SLF_TPFRETE TF
                       WHERE TF.SLF_TPFRETE_TPCODORIGEM = vLinha.CODTPORIGEM
                         AND TF.SLF_TPFRETE_TPCODDESTINO = vLinha.CODTPDESTINO
                         AND TF.SLF_TPFRETE_TPCODOCOUTRACOL = DECODE(NVL(vLinha.OUTRACOL,'99999'),'99999','NN','IB')
                         AND TF.SLF_TPFRETE_TPCODOCOUTRAENTR = DECODE(NVL(vLinha.OUTRAENT,'99999'),'99999','NN','IB');
                    Exception
                      When NO_DATA_FOUND Then
                          vMostraErro := 'S';
                          vErro :=  vErro || pkg_glb_html.fn_ItensLista('-Valor do Frete Zerado ' || to_char(vTpCalcTabela.Slf_Calcfretekm_Valor)  || ' Usando Tabela ' || vLinha.TABELA || '-' || vSaqueTab);
                          when others then
                           vErro := vErro ||'-'|| (vLinha.CODTPORIGEM||'-'||vLinha.CODTPDESTINO||'-'||vLinha.OUTRACOL||'-'||vLinha.OUTRAENT);
                      End;
                      
                    
                    if nvl(vTpCalcTabela.Slf_Calcfretekm_Valor,0) <= 0 then
                       vMostraErro := 'S';
                       vErro :=  vErro || pkg_glb_html.fn_ItensLista('-verifique Tipo de Origem ' || vLinha.CODTPORIGEM  || ' Tipo de Destino ' || vLinha.CODTPDESTINO );
                    End If;
     
                    if ( vLinha.CODVERBA = 'D_ADVL' ) and vTpCalcTabela.Slf_Calcfretekm_Valor >= 1 Then
                       vMostraErro := 'S';
                       vErro :=  vErro || pkg_glb_html.fn_ItensLista('-D_ADVL muito alto ' || to_char(vTpCalcTabela.Slf_Calcfretekm_Valor)  || ' Usando Tabela ' || vLinha.TABELA || '-' || vSaqueTab);
                    End If;
                    
                    if vMostraErro <> 'S' Then
                        Begin
                           insert into TDVADM.t_Slf_Calcfretekmimp2 values vTpCalcTabela;
                           vMostraErro := vMostraErro;
                        exception
                          When OTHERS Then
                                vMostraErro := 'S';
                                vErro :=  vErro || pkg_glb_html.fn_ItensLista('-Erro inserindo linha ' || vNrLinha  || ' Usando Tabela ' || vLinha.TABELA || '-' || vSaqueTab);
                                vErro :=  vErro || pkg_glb_html.fn_ItensLista('erro : ' || sqlerrm);
                          End;
                     Else
                        vMostraErro := vMostraErro;
                     End If;    

                 Else
                 
                    vMostraErro := 'S';
                    vErro :=  vErro || pkg_glb_html.fn_ItensLista('Linha não Importada DUPLICIDADE ' || vNrLinha);
                    vErro :=  vErro || pkg_glb_html.fn_ItensLista(' QTDE ' || TO_CHAR(vAuxiliar) ||
                                                                  ' TAB ' || vLinha.TABELA || 
                                                                  ' SAQ ' || vSaqueTab || 
                                                                  ' TIPO ' || vLinha.TIPOTAB ||
                                                                  ' CARGA ' || vLinha.CARGA || 
                                                                  ' VEICULO '   || vLinha.VEICULO ||
                                                                  ' KMDE ' || vLinha.KMDE || 
                                                                  ' KM ATE' || vLinha.KMATE || 
                                                                  ' PESO DE ' || vLinha.PESODE || 
                                                                  ' PESO ATE ' || vLinha.PESOATE || 
                                                                  ' VERBA ' || vLinha.CODVERBA || 
                                                                  ' ORIGEM ' || VLinha.ORIGEM || 
                                                                  ' DESTINO ' || vLinha.DESTINO ||
                                                                  ' VALOR '   || vLinha.VALOR);
                 End If;
                      
              
              
              
              
              
              
              End If;

              vErro :=  vErro || pkg_glb_html.fn_FechaLista;
              vErro :=  vErro || pkg_glb_html.fn_FechaLista;

--              End If;
              
              If vMostraErro = 'S' Then
                 pMessage := pMessage || vErro;
                 vMostraErro := 'N';
              End If;  

          End If;
           
          End If;
          
          vMSG := 'Fim do IF de Verbas ' || vNrLinha;
          
          vErro := '';
          vNrLinha := vNrLinha + 1;
 

           if mod(vNrLinha,50) = 0 Then
             commit;
          End IF;
          
          if mod(vNrLinha,5000) = 0 Then
             commit;
             dbms_output.put_line(pXLS || '-' || vProtocolo || '-' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '-' || vNrLinha);
          End IF;


          if mod(vNrLinha,10000) = 0 Then
             commit;
          End IF;
          
--          update tdvadm.dropme d 
--            set a = to_char(vNrLinha) || ' - ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')
--          where x = pXLS;
--          commit;
              
          exit when trim(nvl(pStatus,'N')) = 'F';

       SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('vTABFRETEQTDEREG',to_char(vNrLinha));
          
       End Loop;
      dbms_output.put_line(pXLS || '-' || vProtocolo || '-' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '-' || vNrLinha);
       
       vMSG := 'Sai do Loop ' || vNrLinha;

       commit;
    
   
       pMessage :=  pMessage || pkg_glb_html.fn_FechaLista;
       pMessage :=  pMessage || pkg_glb_html.fn_Titulo('FIM');

       If vMostraErro = 'N' Then
             
       vMSG := 'Dentro do If vMostraErro ' || vNrLinha;
       
          If vMostraErro = 'S' Then
             Return;
          End If;
          INSERT INTO T_SLF_CLIREGRASVEIC
          SELECT TA.GLB_GRUPOECONOMICO_CODIGO,
                 TA.GLB_CLIENTE_CGCCPFCODIGO,
                 TA.SLF_TABELA_CONTRATO,
                 TA.FCF_TPVEICULO_CODIGO,
                 TV.FCF_TPVEICULO_DESCRICAO,
                 TA.FCF_TPCARGA_CODIGO,
                 TC.FCF_TPCARGA_DESCRICAO,
                 TA.SLF_TABELA_VIGENCIA,
                 'S',
                 0,
                 0,
                 'S',
                 'S'
          FROM tdvadm.T_SLF_TABELA TA,
               tdvadm.T_FCF_TPCARGA TC,
               tdvadm.T_FCF_TPVEICULO TV
          WHERE TA.SLF_TABELA_CONTRATO = vLinha.CONTRATO
            AND TA.FCF_TPVEICULO_CODIGO = TV.FCF_TPVEICULO_CODIGO
            AND TA.FCF_TPCARGA_CODIGO = TC.FCF_TPCARGA_CODIGO
            AND TV.FCF_TPVEICULO_CODIGO <> '9  '
            AND 0 = (SELECT COUNT(*)
                     FROM tdvadm.T_SLF_CLIREGRASVEIC CV
                     WHERE CV.GLB_GRUPOECONOMICO_CODIGO = TA.GLB_GRUPOECONOMICO_CODIGO
                       AND CV.GLB_CLIENTE_CGCCPFCODIGO = TA.GLB_CLIENTE_CGCCPFCODIGO
                       AND CV.SLF_CONTRATO_CODIGO = TA.SLF_TABELA_CONTRATO
                       AND CV.FCF_TPVEICULO_CODIGO = TA.FCF_TPVEICULO_CODIGO
                       AND CV.FCF_TPCARGA_CODIGO = TA.FCF_TPCARGA_CODIGO
                       AND CV.SLF_CLIREGRASVEIC_VIGENCIA = TA.SLF_TABELA_VIGENCIA);


          insert into tdvadm.t_slf_calcfretekm 
          select * from tdvadm.T_SLF_CALCFRETEKMIMP2 KM
          WHERE 0 = (SELECT COUNT(*)
                     FROM TDVADM.T_SLF_CALCFRETEKM KM1
                     WHERE KM1.SLF_TABELA_CODIGO = KM.SLF_TABELA_CODIGO
                       AND KM1.SLF_TABELA_SAQUE = KM.SLF_TABELA_SAQUE
                       AND KM1.SLF_CALCFRETEKM_KMDE = KM.SLF_CALCFRETEKM_KMDE
                       AND KM1.SLF_CALCFRETEKM_KMATE = KM.SLF_CALCFRETEKM_KMATE
                       AND KM1.SLF_CALCFRETEKM_PESODE = KM.SLF_CALCFRETEKM_PESODE
                       AND KM1.SLF_CALCFRETEKM_PESOATE = KM.SLF_CALCFRETEKM_PESOATE
                       AND KM1.SLF_TPCALCULO_CODIGO = KM.SLF_TPCALCULO_CODIGO
                       AND KM1.SLF_RECCUST_CODIGO = KM.SLF_RECCUST_CODIGO
                       AND KM1.SLF_CALCFRETEKM_ORIGEM = KM.SLF_CALCFRETEKM_ORIGEM
                       AND KM1.SLF_CALCFRETEKM_DESTINO = KM.SLF_CALCFRETEKM_DESTINO
                       AND KM1.SLF_CALCFRETEKM_ORIGEMI = KM.SLF_CALCFRETEKM_ORIGEMI
                       AND KM1.SLF_CALCFRETEKM_DESTINOI = KM.SLF_CALCFRETEKM_DESTINOI
                       AND KM1.SLF_CALCFRETEKM_TPFRETE = KM.SLF_CALCFRETEKM_TPFRETE
                       AND KM1.SLF_CALCFRETEKM_OUTRACOLETAI = KM.SLF_CALCFRETEKM_OUTRACOLETAI
                       AND KM1.SLF_CALCFRETEKM_OUTRAENTREGAI = KM.SLF_CALCFRETEKM_OUTRAENTREGAI);
          vAuxiliar := sql%rowcount;

       End If;
      
       vMSG := 'Sai do If vMostraErro ' || vNrLinha;

      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('vTABFRETEHORAF',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));

              
              insert into   tdvadm.t_slf_clienteped
              select distinct x.grupo,
                              x.cliente,
                              x.codcarga,
                              x.contrato,
                              x.vigencia,
                              'S',
                              x.codveiculo,
                              '99999',
                              '99999',
                              x.origem,
                              x.destino,
                              to_number(replace(nvl(valor,0),',','.')) valor,
                              x.des,
                              x.codcli,
                              nvl(x.OUTRACOL,'99999'),
                              nvl(x.OUTRAENT,'99999')
              from tdvadm.v_slf_calcfretekmpreimpcsv x 
              where 0 = 0 --x.protocolo = pXLS
              --  and x.codcarga = '02'
                and to_number(replace(x.VALOR,',','.')) <> 0
                and x.codverba = 'D_PD'
                and x.planilha = vArqcsv
                and x.carga <> 'CARGA'
                and fn_inserepedagio(trim(x.codcarga), trim(x.CODTPORIGEM), trim(x.CODTPDESTINO)) = 'N'
                and 0 = (select count(*)
                         from tdvadm.t_slf_clienteped cp
                         where cp.GLB_GRUPOECONOMICO_CODIGO = rpad(x.GRUPO,4)
                           and cp.GLB_CLIENTE_CGCCPFCODIGO = rpad(x.CLIENTE,20)
                           and cp.FCF_TPCARGA_CODIGO = rpad(x.CODCARGA,3)
                           and cp.SLF_CONTRATO_CODIGO = x.CONTRATO
                           and cp.SLF_CLIENTEPED_VIGENCIA = to_date(x.VIGENCIA,'DD/MM/YYYY')
                           and cp.SLF_CLIENTEPED_ATIVO = 'S'
                           and cp.FCF_TPVEICULO_CODIGO = rpad(x.CODVEICULO,3)
                           and cp.GLB_LOCALIDADE_CODIGOORI = '99999'
                           and cp.GLB_LOCALIDADE_CODIGODES = '99999'
                           and cp.GLB_LOCALIDADE_CODIGOORIIB = rpad(x.ORIGEM,8)
                           and cp.GLB_LOCALIDADE_CODIGODESIB = rpad(x.DESTINO,8)
                           and cp.GLB_LOCALIDADE_OUTRACOLETAI = rpad(nvl(x.OUTRACOL,'99999'),8)
                           and cp.GLB_LOCALIDADE_OUTRAENTREGAI = rpad(nvl(x.OUTRAENT,'99999'),8));
                  
      vMSG := 'Final do Insert após vMostraErro ' || vNrLinha;    
      
       wservice.pkg_glb_email.SP_ENVIAEMAIL(pXLS,pMessage,'aut-e@dellavolpe.com.br','sirlanodrumond@gmail.com;alexandre.malcar@dellavolpe.com.br');
       commit;
    exception            
      When OTHERS Then
           pStatus := 'E';
           vNrLinha := vNrLinha;
           pMessage := pMessage || chr(13) || 'Planilha ' || pXLS || ' Linha : ' || vNrLinha || ' Erro : ' || sqlerrm || chr(10) || ' Onde ' || DBMS_UTILITY.format_call_stack;
           wservice.pkg_glb_email.SP_ENVIAEMAIL(pXLS,pMessage,'aut-e@dellavolpe.com.br','sirlanodrumond@gmail.com;alexandre.malcar@dellavolpe.com.br');
    End sp_CriaAtulizaValores;

    PROCEDURE SP_MONTA_FORMULA_TABELA(V_TIPOCALCULOPAI IN     CHAR,
                                      V_TABELACODIGO   IN     CHAR,
                                      V_SAQUE          IN     CHAR,
                                      V_LOCALIDADE     IN     CHAR)
    IS
        V_SEQ                         NUMBER;
        V_TPCALCULO_CODIGO            CHAR(3);
        V_RECCUST_CODIGO              CHAR(10);
        V_FORMULA_FRONTEND            CHAR(10);
        V_FORMULA_FORMULA_TX          VARCHAR2(500);
        V_FORMULA_FORMULA_VLR         VARCHAR2(500);
        V_FORMULA_FORMULA_PERC        VARCHAR2(500);
        V_FORMULA_DESINENCIA_TX       CHAR(3);
        V_FORMULA_DESINENCIA_VLR      CHAR(3);
        V_FORMULA_DESINENCIA_PERC     CHAR(3);
        V_VERBA_PRINCIPAL             CHAR(10);
        V_DESINENCIA                  T_SLF_CALCTABELA.SLF_CALCTABELA_DESINECIA%TYPE;
        V_MOEDA                       T_SLF_CALCTABELA.GLB_MOEDA_CODIGO%TYPE;
        V_FORMULA_CALC                VARCHAR2(500);
        V_FORMULA_DESINENCIA          CHAR(3);
        V_TAMANHO_FORMULA             NUMBER;
        V_CONT                        NUMBER;
        V_VALOR_CAMPO                 CHAR(20);
        V_MOEDA_CAMPO                 CHAR(4);
        V_VALOR_ATUAL                 NUMBER;
        V_VERBARESULTADO              CHAR(10);
        V_PRECISAO                    NUMBER;
        V_PONTEIRO                    VARCHAR2(500);
        V_CAMPO                       VARCHAR2(500);
        V_MOEDANACIONAL               CHAR(4);
        V_FORMULA_CALCTRATADA         VARCHAR2(500);
        CUR                           INTEGER;
        TOTAL                         INTEGER;
        V_FORMULA_DESINENCIARTR       T_SLF_CALCTABELA.SLF_CALCTABELA_DESINECIA%TYPE;
        V_FORMULA_MOEDA               CHAR(4);
        V_TIPOCALCULOSEQ              CHAR(3);
        V_VALOR_FORMULA               VARCHAR2(30);
        ERRO_FORMULA                  EXCEPTION;
        CURSOR SEQCALCULO IS SELECT SLF_TPCALCULO_CODIGOSEQ
                             FROM   tdvadm.T_SLF_SEQCALCULO
                             WHERE  SLF_TPCALCULO_CODIGO  = V_TIPOCALCULOPAI
                             AND    SLF_SEQCALCULO_CALCTABELA = 'S'
                             ORDER BY SLF_SEQCALCLULO_SEQUENCIA;
    BEGIN

        --MOEDA NACIONAL

        SELECT GLB_MOEDA_CODIGO
        INTO   V_MOEDANACIONAL
        FROM   tdvadm.T_GLB_MOEDA
        WHERE  GLB_MOEDA_PAIS = 'S';

        -- RECUPERA VERBA PRINCIPAL

        OPEN SEQCALCULO;
        LOOP

            FETCH SEQCALCULO
            INTO  V_TIPOCALCULOSEQ;
            EXIT WHEN SEQCALCULO%NOTFOUND;
            BEGIN
                SELECT  SLF_RECCUST_CODIGO
                  INTO  V_VERBA_PRINCIPAL
                  FROM  tdvadm.T_SLF_CALCULO
                 WHERE  SLF_TPCALCULO_CODIGO = V_TIPOCALCULOSEQ
                   AND  SLF_CALCULO_VERBAPRINCIPAL = 'S';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                V_VERBA_PRINCIPAL := NULL;
            END;

            --RETORNA FORMULA DO CALCULO

            BEGIN
                SELECT  SLF_TPCALCULO_CODIGO        ,
                        SLF_RECCUST_CODIGO          ,
                        SLF_FORMULA_FRONTEND        ,
                        SLF_FORMULA_FORMULA_TX      ,
                        SLF_FORMULA_FORMULA_VLR     ,
                        SLF_FORMULA_FORMULA_PERC    ,
                        SLF_FORMULA_DESINENCIA_TX   ,
                        SLF_FORMULA_DESINENCIA_VLR  ,
                        SLF_FORMULA_DESINENCIA_PERC
                INTO    V_TPCALCULO_CODIGO          ,
                        V_RECCUST_CODIGO            ,
                        V_FORMULA_FRONTEND          ,
                        V_FORMULA_FORMULA_TX        ,
                        V_FORMULA_FORMULA_VLR       ,
                        V_FORMULA_FORMULA_PERC      ,
                        V_FORMULA_DESINENCIA_TX     ,
                        V_FORMULA_DESINENCIA_VLR    ,
                        V_FORMULA_DESINENCIA_PERC
                FROM    tdvadm.T_SLF_FORMULA
                WHERE   SLF_TPCALCULO_CODIGO  = V_TIPOCALCULOSEQ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                V_FORMULA_FRONTEND         := '';
            END;

            --RETORNA DESINENCIA E MOEDA DA VERBA PRINCIPAL DA FORMULA CORRENTE

            BEGIN
                SELECT  SLF_CALCTABELA_DESINECIA,
                        GLB_MOEDA_CODIGO
                INTO    V_DESINENCIA,
                        V_MOEDA
                FROM    tdvadm.T_SLF_CALCTABELA
                WHERE   SLF_TABELA_CODIGO     = V_TABELACODIGO
                AND     SLF_TABELA_SAQUE      = V_SAQUE
                AND     GLB_LOCALIDADE_CODIGO = V_LOCALIDADE
                AND     SLF_TPCALCULO_CODIGO     = V_TIPOCALCULOPAI
                AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_VERBA_PRINCIPAL,10);
            EXCEPTION WHEN NO_DATA_FOUND THEN
                V_DESINENCIA := NULL;
                V_MOEDA      := NULL;
            END;
            IF NVL(V_MOEDA,0) = 0 THEN
         V_MOEDA := V_MOEDANACIONAL; 
            END IF ;

            V_FORMULA_DESINENCIARTR := V_DESINENCIA;
            V_FORMULA_MOEDA      := V_MOEDA;

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

            V_CONT := 1;
            V_TAMANHO_FORMULA := LENGTH(RTRIM(LTRIM(V_FORMULA_CALC)));

            V_PONTEIRO := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC,V_CONT,1)));
            WHILE V_CONT <= V_TAMANHO_FORMULA
            LOOP
               IF V_PONTEIRO = '"' THEN

                    V_CONT := V_CONT + 1;
                    V_PONTEIRO := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC,V_CONT,1)));
                    IF V_PONTEIRO NOT IN('-','*','+','/',')','(',',') THEN
                       WHILE V_PONTEIRO <> '"'
                       LOOP
                            V_PONTEIRO := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC,V_CONT,1)));
                            IF V_PONTEIRO <> '"' THEN
                                V_CAMPO := V_CAMPO||V_PONTEIRO;
                                V_CONT := V_CONT + 1;
                            END IF;
                       END LOOP;

                      --SELECIONA VALOR E MOEDA DA VERBA

                       BEGIN
                            SELECT   SLF_CALCTABELA_VALOR,
                                     GLB_MOEDA_CODIGO
                            INTO     V_VALOR_CAMPO,
                                     V_MOEDA_CAMPO
                            FROM    tdvadm.T_SLF_CALCTABELA
                            WHERE   SLF_TABELA_CODIGO  = V_TABELACODIGO
                            AND     SLF_TABELA_SAQUE   = V_SAQUE
                            AND     GLB_LOCALIDADE_CODIGO = V_LOCALIDADE
                            AND     SLF_TPCALCULO_CODIGO = V_TIPOCALCULOPAI
                            AND     RPAD(SLF_RECCUST_CODIGO,10)   = RPAD(V_CAMPO,10);
                       EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                            V_VALOR_CAMPO := 0;
                            V_MOEDA_CAMPO := NULL;
                       END;

                       IF  (V_MOEDA_CAMPO <> V_MOEDANACIONAL) AND (V_MOEDA_CAMPO IS NOT NULL)  THEN
                            --CONVERTE MOEDA
                            BEGIN
                                SELECT GLB_MOEDAVL_VALOR
                                INTO   V_VALOR_ATUAL
                                FROM   tdvadm.T_GLB_MOEDAVL
                                WHERE  GLB_MOEDA_CODIGO  = V_MOEDA_CAMPO
                                AND    GLB_MOEDAVL_DATAEFETIVA <= SYSDATE
                AND    ROWNUM = 1
                                ORDER BY GLB_MOEDAVL_DATAEFETIVA DESC;
                                V_PONTEIRO := TO_CHAR(TO_NUMBER(V_VALOR_CAMPO)*V_VALOR_ATUAL);
                            EXCEPTION WHEN NO_DATA_FOUND THEN
                                V_VALOR_ATUAL := '';
                            END;
                       ELSE
                           IF (V_VALOR_CAMPO IS NULL) OR (V_VALOR_CAMPO = '') THEN
                               V_PONTEIRO := '0';
                           ELSE
                               V_PONTEIRO := V_VALOR_CAMPO;
                           END IF;
                       END IF;

                       V_FORMULA_CALCTRATADA := CONCAT(RTRIM(LTRIM(V_FORMULA_CALCTRATADA)),RTRIM(LTRIM(V_PONTEIRO)));
                       V_PONTEIRO := '';
                    ELSE
                        V_FORMULA_CALCTRATADA := CONCAT(RTRIM(LTRIM(V_FORMULA_CALCTRATADA)),RTRIM(LTRIM(V_PONTEIRO)));
                        V_CONT := V_CONT + 1;
                        V_PONTEIRO := '';
                    END IF;
               ELSE
                    V_FORMULA_CALCTRATADA := CONCAT(RTRIM(LTRIM(V_FORMULA_CALCTRATADA)),RTRIM(LTRIM(V_PONTEIRO)));
                    V_CONT := V_CONT + 1;
                    V_PONTEIRO := '';
               END IF;

                V_PONTEIRO := LTRIM(RTRIM(SUBSTR(V_FORMULA_CALC,V_CONT,1)));
                V_CAMPO := '';
            END LOOP;

            --RETORNA VERBA RESULTADO

            BEGIN
                SELECT SLF_RECCUST_CODIGO
                INTO   V_VERBARESULTADO
                FROM   tdvadm.T_SLF_CALCULO
                WHERE  SLF_TPCALCULO_CODIGO = V_TIPOCALCULOSEQ
                AND    SLF_CALCULO_TPCAMPO = 'R';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                V_VERBARESULTADO := '';
            END;

            --RETORNA PRECISAO

            BEGIN
                SELECT SLF_CALCULO_PRECISAO
                INTO   V_PRECISAO
                FROM   tdvadm.T_SLF_CALCULO
                WHERE  SLF_TPCALCULO_CODIGO = V_TIPOCALCULOPAI
                AND    RPAD(SLF_RECCUST_CODIGO,10) = RPAD(V_VERBARESULTADO,10);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                V_PRECISAO := '0';
            END;
                CUR := DBMS_SQL.OPEN_CURSOR;
            BEGIN
                CUR := DBMS_SQL.OPEN_CURSOR;
                DBMS_SQL.PARSE(CUR,'SELECT ROUND('||REPLACE(V_FORMULA_CALCTRATADA,',','.')||',10) FROM DUAL ',DBMS_SQL.V7);
                DBMS_SQL.DEFINE_COLUMN(CUR,1,V_VALOR_FORMULA,30);
                TOTAL := DBMS_SQL.EXECUTE(CUR);
                TOTAL := DBMS_SQL.FETCH_ROWS(CUR);
                DBMS_SQL.COLUMN_VALUE(CUR,1,V_VALOR_FORMULA);
                DBMS_SQL.CLOSE_CURSOR(CUR);
            EXCEPTION WHEN OTHERS THEN
                IF V_VERBARESULTADO = 'I_MRBRC' THEN
                    V_VALOR_FORMULA := 100;
                ELSE
                    V_VALOR_FORMULA := 0;
                END IF;
            END;
            IF LENGTH(RTRIM(LTRIM(V_FORMULA_MOEDA))) > 0 THEN
                UPDATE T_SLF_CALCTABELA
                SET    SLF_CALCTABELA_VALOR      = ROUND(V_VALOR_FORMULA,V_PRECISAO),
                       SLF_CALCTABELA_DESINECIA  = V_FORMULA_DESINENCIARTR,
                       GLB_MOEDA_CODIGO            = V_FORMULA_MOEDA
                WHERE  SLF_TABELA_CODIGO = V_TABELACODIGO
                AND    SLF_TABELA_SAQUE  = V_SAQUE
                AND     GLB_LOCALIDADE_CODIGO = V_LOCALIDADE
                AND    RPAD(SLF_RECCUST_CODIGO,10)  = RPAD(V_VERBARESULTADO,10);
             ELSE
                UPDATE T_SLF_CALCTABELA
                SET    SLF_CALCTABELA_VALOR      = ROUND(V_VALOR_FORMULA,V_PRECISAO),
                       SLF_CALCTABELA_DESINECIA  = V_FORMULA_DESINENCIARTR,
                       GLB_MOEDA_CODIGO            = NULL
                WHERE  SLF_TABELA_CODIGO = V_TABELACODIGO
                AND    SLF_TABELA_SAQUE  = V_SAQUE
                AND     GLB_LOCALIDADE_CODIGO = V_LOCALIDADE
                AND    RPAD(SLF_RECCUST_CODIGO,10)  = RPAD(V_VERBARESULTADO,10);
             END IF;
            V_VALOR_FORMULA       := '';
            V_FORMULA_CALCTRATADA := '';
            V_PRECISAO            := '';
            V_FORMULA_CALC        := '';
        END LOOP;
    END SP_MONTA_FORMULA_TABELA;





    PROCEDURE SP_CALC_TOT_PRACA_TABELA(V_Codigo     Char,
                                       V_Saque      Char)
    IS
        V_Localidade       char(8);
        v_tpcalculo_codigo char(4);
        CURSOR Det_Tabela IS SELECT Glb_Localidade_Codigo
                             FROM   tdvadm.T_Slf_Tabeladet
                             WHERE  Slf_Tabela_Codigo = V_Codigo
                             AND    Slf_Tabela_Saque  = V_Saque;
    Begin
        OPEN Det_Tabela;
        SELECT slf_tpcalculo_codigo
          INTO v_tpcalculo_codigo
          FROM tdvadm.t_slf_tabela
         WHERE Slf_Tabela_Codigo = V_Codigo
           AND Slf_Tabela_Saque  = V_Saque;
        LOOP
            FETCH Det_Tabela
            INTO  V_Localidade;
            EXIT WHEN Det_Tabela%Notfound;
            Sp_Monta_Formula_Tabela(v_tpcalculo_codigo,V_Codigo,V_Saque,V_Localidade);
        END LOOP;
        CLOSE Det_Tabela;
    END SP_CALC_TOT_PRACA_TABELA;


    PROCEDURE SP_ATUALIZAPEDTABELA(P_TABELAORIGEM  IN     CHAR,
                                   P_SAQUEORIGEM   IN     CHAR,
                                   P_TABELADESTINO IN     CHAR,
                                   P_SAQUEDESTINO  IN     CHAR,
                                   P_VIGENCIA      IN     CHAR,
                                   P_REFERENCIA    IN     CHAR,
                                   P_OBS           IN     CHAR,
                                   P_TIPOTAB       IN     CHAR,
                                   P_ADMPEDOUTROS  IN     CHAR DEFAULT 'N',
                                   P_PERCENTOUTROS IN     NUMBER DEFAULT 0)
    IS
          V_ORIGEMDESTINO 	CHAR(8);
          V_LOCALIDADE 	CHAR(8);
          V_REAJUSTAUTO	CHAR(1);
          V_ORIGEM		CHAR(8);
          V_DESTINO		CHAR(8);
          V_NREIXOS		NUMBER;
          V_TABELAORIGEM    CHAR(8);
          V_SAQUEORIGEM     CHAR(4);
          V_TABELADESTINO   CHAR(8);
          V_SAQUEDESTINO    CHAR(4);
          V_VIGENCIA        CHAR(10);
          V_REFERENCIA      CHAR(10);
          V_OBS             CHAR(200);
          V_TIPOTAB         CHAR(3);
    BEGIN
          V_TABELAORIGEM   := P_TABELAORIGEM ;
          V_SAQUEORIGEM    := P_SAQUEORIGEM  ;
          V_TABELADESTINO  := P_TABELADESTINO;
          V_SAQUEDESTINO   := P_SAQUEDESTINO ;
          V_VIGENCIA       := P_VIGENCIA     ;
          V_REFERENCIA     := NVL(P_REFERENCIA,'SIRLANO');
          V_OBS            := P_OBS          ;
          V_TIPOTAB        := P_TIPOTAB      ;
    IF V_REFERENCIA <> 'SIRLANO' THEN
       INSERT INTO T_SLF_TABELA
       (SLF_TABELA_CODIGO,
        SLF_TABELA_SAQUE,
        GLB_ROTA_CODIGO,
        GLB_CONDPAG_CODIGO,
        SLF_TABELA_TIPO,
        GLB_CLIENTE_CGCCPFCODIGO,
        GLB_MERCADORIA_CODIGO,
        SLF_TABELA_VIGENCIA,
        GLB_EMBALAGEM_CODIGO,
        SLF_TABELA_DTGRAVACAO,
        GLB_TPCARGA_CODIGO,
        GLB_LOCALIDADE_CODIGO,
        SLF_TABELA_CONTATO,
        SLF_TABELA_OBSTABELA,
        GLB_VENDFRETE_CODIGO,
        SLF_TABELA_OBSFATURAMENTO,
        SLF_TABELA_LOTACAOFLAG,
        SLF_TABELA_ISENTO,
        SLF_TABELA_DESCRICAO,
        SLF_TPCALCULO_CODIGO,
        SLF_TABELA_PEDREAJAUT,
        SLF_TABELA_PEDATUALIZA,
        SLF_TABELA_ORIGEMDESTINO,
        SLF_TABELA_STATUS,              
        SLF_TABELA_VIAGEMMIN,           
        SLF_TABELA_VIAGEMMAX,           
        SLF_TABELA_VIAGEMIDENT,         
        CON_FCOBPED_CODIGO,             
        CON_MODALIDADEPED_CODIGO,
        SLF_TABELA_TPDESCONTO,          
        SLF_TABELA_DESCONTO,            
        SLF_TABELA_PERCLOTACAO,         
        SLF_TABELA_MSGLOTACAO,          
        SLF_TABELA_ABORTALOTACAO,
        SLF_TABELA_PESOMINIMO,          
        SLF_TABELA_PESOMAXIMO,          
        SLF_TABELA_OCUPACAO,            
        SLF_TABELA_BASEOCUPACAO)
        (SELECT TRIM(V_TABELADESTINO) ,
                TRIM(V_SAQUEDESTINO)  ,
                GLB_ROTA_CODIGO,
                GLB_CONDPAG_CODIGO,
                SLF_TABELA_TIPO,
                GLB_CLIENTE_CGCCPFCODIGO,
                GLB_MERCADORIA_CODIGO,
                V_VIGENCIA,
                GLB_EMBALAGEM_CODIGO,
                TO_DATE(SYSDATE,'DD/MM/YYYY'),
                GLB_TPCARGA_CODIGO,
                GLB_LOCALIDADE_CODIGO,
                SLF_TABELA_CONTATO,
                TRIM(SLF_TABELA_OBSTABELA) || ' ' || TRIM(V_OBS),
                GLB_VENDFRETE_CODIGO,
                SLF_TABELA_OBSFATURAMENTO,
                SLF_TABELA_LOTACAOFLAG,
                SLF_TABELA_ISENTO,
                SLF_TABELA_DESCRICAO,
                SLF_TPCALCULO_CODIGO,
                SLF_TABELA_PEDREAJAUT,
                SLF_TABELA_PEDATUALIZA,
                SLF_TABELA_ORIGEMDESTINO,
                SLF_TABELA_STATUS,              
                SLF_TABELA_VIAGEMMIN,           
                SLF_TABELA_VIAGEMMAX,           
                SLF_TABELA_VIAGEMIDENT,         
                CON_FCOBPED_CODIGO,             
                CON_MODALIDADEPED_CODIGO,
                SLF_TABELA_TPDESCONTO,          
                SLF_TABELA_DESCONTO,            
                SLF_TABELA_PERCLOTACAO,         
                SLF_TABELA_MSGLOTACAO,          
                SLF_TABELA_ABORTALOTACAO,
                SLF_TABELA_PESOMINIMO,          
                SLF_TABELA_PESOMAXIMO,          
                SLF_TABELA_OCUPACAO,            
                SLF_TABELA_BASEOCUPACAO
         FROM tdvadm.T_SLF_TABELA
         WHERE SLF_TABELA_CODIGO = TRIM(V_TABELAORIGEM) 
           AND SLF_TABELA_SAQUE = TRIM(V_SAQUEORIGEM)) ;
    ELSE
       V_REFERENCIA := TO_CHAR(SYSDATE,'DD/MM/YYYY');
    END IF;  
    INSERT INTO T_SLF_TABELALOTACAO 
    (SLF_TABELA_CODIGO        ,     
     SLF_TABELA_SAQUE         ,     
      SLF_TPVEICULO_CODIGO    ,     
      GLB_TABELALOTACAO_MAXKG  )    
     ( SELECT P_TABELADESTINO ,
              P_SAQUEDESTINO  ,
              SLF_TPVEICULO_CODIGO   ,     
              GLB_TABELALOTACAO_MAXKG      
       FROM tdvadm.T_SLF_TABELALOTACAO          
       WHERE SLF_TABELA_CODIGO = P_TABELAORIGEM 
         AND SLF_TABELA_SAQUE = P_SAQUEORIGEM); 
    -- COPIA DA  T_SLF_TABELAFAIXA
    INSERT INTO T_SLF_TABELAFAIXA 
    ( SLF_TABELA_CODIGO         , 
     SLF_TABELA_SAQUE           , 
     SLF_TABELAFAIXA_TPVALOR    , 
     SLF_TABELAFAIXA_DESINENCIA  )
     (SELECT P_TABELADESTINO ,
             P_SAQUEDESTINO  ,
             SLF_TABELAFAIXA_TPVALOR ,     
             SLF_TABELAFAIXA_DESINENCIA    
      FROM tdvadm.T_SLF_TABELAFAIXA             
      WHERE SLF_TABELA_CODIGO = P_TABELAORIGEM
        AND SLF_TABELA_SAQUE = P_SAQUEORIGEM ); 
    -- COPIA DA  T_SLF_TABELAFAIXADET
    INSERT INTO T_SLF_TABELAFAIXADET 
    ( SLF_TABELA_CODIGO ,            
     SLF_TABELA_SAQUE ,              
     SLF_TABELAFAIXADET_VALORINICIO ,
     SLF_TABELAFAIXADET_VALORFINAL , 
     SLF_TABELAFAIXADET_ACRECIMO)    
     (SELECT P_TABELADESTINO ,
             P_SAQUEDESTINO  ,
             SLF_TABELAFAIXADET_VALORINICIO ,
             SLF_TABELAFAIXADET_VALORFINAL , 
             SLF_TABELAFAIXADET_ACRECIMO     
      FROM tdvadm.T_SLF_TABELAFAIXADET            
      WHERE SLF_TABELA_CODIGO = P_TABELAORIGEM
        AND SLF_TABELA_SAQUE = P_SAQUEORIGEM) ;
    -- COPIA DA  T_SLF_TABELADET
    INSERT INTO T_SLF_TABELADET        
    ( SLF_TABELA_CODIGO,               
      SLF_TABELA_SAQUE,                
      GLB_LOCALIDADE_CODIGO,           
      SLF_TABELADET_KILOMETRAGEM,      
      SLF_TABELADET_DTGRAVACAO,        
      SLF_TABELADET_MAIORCUSTCARRET,   
      SLF_TABELADET_MENORCUSTCARRET,   
      SLF_TABELADET_ATUALCUSTCARRET,   
      SLF_TABELADET_ANTERIORCUSTCARR ) 
     (SELECT P_TABELADESTINO ,
             P_SAQUEDESTINO  ,
             GLB_LOCALIDADE_CODIGO,         
             SLF_TABELADET_KILOMETRAGEM,    
             TO_DATE(SYSDATE,'DD/MM/YYYY') , 
             SLF_TABELADET_MAIORCUSTCARRET, 
             SLF_TABELADET_MENORCUSTCARRET, 
             SLF_TABELADET_ATUALCUSTCARRET, 
             SLF_TABELADET_ANTERIORCUSTCARR 
       FROM tdvadm.T_SLF_TABELADET                
       WHERE SLF_TABELA_CODIGO = P_TABELAORIGEM
         AND SLF_TABELA_SAQUE = P_SAQUEORIGEM); 
    -- COPIA DA  T_SLF_TABELAPEDAGIO
    INSERT INTO T_SLF_PERCURSOTABELA
    (SLF_TABELA_CODIGO    ,
     SLF_TABELA_SAQUE     ,
     SLF_PERCURSO_CODIGO,
     GLB_LOCALIDADE_CODIGO)
    (SELECT P_TABELADESTINO ,
            P_SAQUEDESTINO  ,
            SLF_PERCURSO_CODIGO,
            GLB_LOCALIDADE_CODIGO
      FROM tdvadm.T_SLF_PERCURSOTABELA 
      WHERE SLF_TABELA_CODIGO = P_TABELAORIGEM
        AND SLF_TABELA_SAQUE = P_SAQUEORIGEM) ;
    -- COPIA DA  T_SLF_CALCTABELA
    INSERT INTO T_SLF_CALCTABELA     
    ( SLF_TABELA_CODIGO            , 
      SLF_TABELA_SAQUE             , 
      GLB_MOEDA_CODIGO             , 
      SLF_CALCTABELA_DESINECIA     , 
      GLB_LOCALIDADE_CODIGO        , 
      SLF_CALCTABELA_VALOR         , 
      SLF_TPCALCULO_CODIGO         , 
      SLF_RECCUST_CODIGO           , 
      SLF_CALCTABELA_REEMBOLSO     ) 
     (SELECT P_TABELADESTINO ,
             P_SAQUEDESTINO  ,
             GLB_MOEDA_CODIGO            , 
             SLF_CALCTABELA_DESINECIA    , 
             GLB_LOCALIDADE_CODIGO       , 
             SLF_CALCTABELA_VALOR        , 
             SLF_TPCALCULO_CODIGO        , 
             SLF_RECCUST_CODIGO          , 
             SLF_CALCTABELA_REEMBOLSO      
       FROM tdvadm.T_SLF_CALCTABELA              
       WHERE SLF_TABELA_CODIGO = P_TABELAORIGEM
         AND SLF_TABELA_SAQUE = P_SAQUEORIGEM); 
    SELECT SLF_TABELA_ORIGEMDESTINO,
           GLB_LOCALIDADE_CODIGO,
           SLF_TABELA_PEDREAJAUT
     INTO V_ORIGEMDESTINO,
          V_LOCALIDADE,
          V_REAJUSTAUTO
    FROM tdvadm.T_SLF_TABELA 
    WHERE SLF_TABELA_CODIGO = P_TABELADESTINO
      AND SLF_TABELA_SAQUE = P_SAQUEDESTINO;
    -- VERIFICA SE E REAJUSTE AUTOMATICO
    IF V_REAJUSTAUTO <> 'N' THEN
       V_ORIGEM := 'SIRLANO' ;
       V_DESTINO := 'SIRLANO' ;
       IF P_TIPOTAB = 'FOB' THEN
          V_DESTINO := V_LOCALIDADE;
       ELSE
          V_ORIGEM := V_LOCALIDADE;
       END IF;   
          -- PEGA O NR. DE EIXOS
       SELECT GLB_TPCARGA_NREIXOS
       INTO V_NREIXOS
       FROM  tdvadm.T_GLB_TPCARGA
       WHERE GLB_TPCARGA_CODIGO = (SELECT GLB_TPCARGA_CODIGO
                                   FROM tdvadm.T_SLF_TABELA
                                   WHERE SLF_TABELA_CODIGO = P_TABELADESTINO
                                     AND SLF_TABELA_SAQUE = P_SAQUEDESTINO);
    -- ATUALIZA OS PEDAGIOS
       IF V_ORIGEM <> 'SIRLANO' THEN
          UPDATE T_SLF_CALCTABELA     
          SET SLF_CALCTABELA_VALOR = F_BUSCA_PEDAGIO_PERCURSO_ATU(V_ORIGEM,GLB_LOCALIDADE_CODIGO,V_REFERENCIA) * V_NREIXOS
          WHERE SLF_TABELA_CODIGO = P_TABELADESTINO
            AND SLF_TABELA_SAQUE = P_SAQUEDESTINO
            AND SLF_RECCUST_CODIGO = 'D_PD';
          IF P_ADMPEDOUTROS = 'S' THEN
             UPDATE T_SLF_CALCTABELA     
             SET SLF_CALCTABELA_VALOR = ROUND((F_BUSCA_PEDAGIO_PERCURSO_ATU(V_ORIGEM,GLB_LOCALIDADE_CODIGO,V_REFERENCIA) * V_NREIXOS) * (P_PERCENTOUTROS / 100),2)
             WHERE SLF_TABELA_CODIGO = P_TABELADESTINO
               AND SLF_TABELA_SAQUE = P_SAQUEDESTINO
               AND SLF_RECCUST_CODIGO = 'D_OT';
          END IF;     
       ELSE
          UPDATE T_SLF_CALCTABELA     
          SET SLF_CALCTABELA_VALOR = F_BUSCA_PEDAGIO_PERCURSO_ATU(GLB_LOCALIDADE_CODIGO,V_DESTINO,V_REFERENCIA) * V_NREIXOS
          WHERE SLF_TABELA_CODIGO = P_TABELADESTINO
            AND SLF_TABELA_SAQUE = P_SAQUEDESTINO
            AND SLF_RECCUST_CODIGO = 'D_PD';
          IF P_ADMPEDOUTROS = 'S' THEN
             UPDATE T_SLF_CALCTABELA     
             SET SLF_CALCTABELA_VALOR = ROUND((F_BUSCA_PEDAGIO_PERCURSO_ATU(GLB_LOCALIDADE_CODIGO,V_DESTINO,V_REFERENCIA) * V_NREIXOS) * (P_PERCENTOUTROS / 100),2)
             WHERE SLF_TABELA_CODIGO = P_TABELADESTINO
               AND SLF_TABELA_SAQUE = P_SAQUEDESTINO
               AND SLF_RECCUST_CODIGO = 'D_OT';
          END IF;     
       END IF;     
    END IF;
    SP_CALC_TOT_PRACA_TABELA(P_TABELADESTINO,P_SAQUEDESTINO);
    COMMIT;
    END SP_ATUALIZAPEDTABELA;

    PROCEDURE SP_EMBUTE_ICMS_TAB(P_VIGENCIA  IN CHAR,
                                 P_RECALCULA IN CHAR DEFAULT 'N')
    IS
      V_NOVOSAQUE T_SLF_TABELA.SLF_TABELA_SAQUE%TYPE;
      
      CURSOR C_CIF IS
        SELECT DISTINCT
               T.SLF_TABELA_CODIGO CODIGO,
               T.SLF_TABELA_SAQUE SAQUE
          FROM tdvadm.T_SLF_TABELA T,
               tdvadm.T_SLF_TABELADET X,
               tdvadm.T_GLB_LOCALIDADE O,
               tdvadm.T_GLB_LOCALIDADE D
         WHERE T.SLF_TABELA_STATUS = 'N'
           AND T.SLF_TABELA_TIPO <> 'FOB'
           AND T.SLF_TABELA_ISENTO = 'N'
           AND T.SLF_TPCALCULO_CODIGO in ('041','315')
           AND T.SLF_TABELA_SAQUE = (SELECT MAX(M.SLF_TABELA_SAQUE)
                                       FROM tdvadm.T_SLF_TABELA M
                                      WHERE M.SLF_TABELA_CODIGO = T.SLF_TABELA_CODIGO)
           AND T.SLF_TABELA_CODIGO = X.SLF_TABELA_CODIGO
           AND T.SLF_TABELA_SAQUE = X.SLF_TABELA_SAQUE
           AND T.GLB_LOCALIDADE_CODIGO = O.GLB_LOCALIDADE_CODIGO
           AND X.GLB_LOCALIDADE_CODIGO = D.GLB_LOCALIDADE_CODIGO
           AND O.GLB_ESTADO_CODIGO = 'MG'
           AND D.GLB_ESTADO_CODIGO <> 'MG';
                
      CURSOR C_FOB IS
        SELECT DISTINCT
               T.SLF_TABELA_CODIGO CODIGO,
               T.SLF_TABELA_SAQUE SAQUE
          FROM tdvadm.T_SLF_TABELA T,
               tdvadm.T_SLF_TABELADET X,
               tdvadm.T_GLB_LOCALIDADE O,
               tdvadm.T_GLB_LOCALIDADE D
         WHERE T.SLF_TABELA_STATUS = 'N'
           AND T.SLF_TABELA_TIPO = 'FOB'
           AND T.SLF_TABELA_ISENTO = 'N'
           AND T.SLF_TPCALCULO_CODIGO in ('041','315')
           AND T.SLF_TABELA_SAQUE = (SELECT MAX(M.SLF_TABELA_SAQUE)
                                       FROM tdvadm.T_SLF_TABELA M
                                      WHERE M.SLF_TABELA_CODIGO = T.SLF_TABELA_CODIGO)
           AND T.SLF_TABELA_CODIGO = X.SLF_TABELA_CODIGO
           AND T.SLF_TABELA_SAQUE = X.SLF_TABELA_SAQUE
           AND X.GLB_LOCALIDADE_CODIGO = O.GLB_LOCALIDADE_CODIGO
           AND T.GLB_LOCALIDADE_CODIGO = D.GLB_LOCALIDADE_CODIGO
           AND O.GLB_ESTADO_CODIGO = 'MG'
           AND D.GLB_ESTADO_CODIGO <> 'MG';
           
    BEGIN

      -- TESTA OS PARAMETROS
      IF NVL(P_VIGENCIA, '**') = '**'  THEN
        RAISE_APPLICATION_ERROR(-20001,'O PARAMETRO DE VIGENCIA E OBRIGATORIO');  
      END IF;
      
      -- TRABALHA COM AS TABELAS CIF E FOC
      FOR TAB IN C_CIF LOOP
          -- CRIA UM NOVO SAQUE 
    --      SP_COPIA_TABELA_SEM_REAJ(TAB.CODIGO, TAB.SAQUE, TO_DATE(P_VIGENCIA, 'DD/MM/YYYY'), 'N');
          
          -- SETA VARIAVEL COM O NOVO SAQUE
    --      V_NOVOSAQUE := LPAD(TRIM(TO_CHAR(TO_NUMBER(TAB.SAQUE) + 1)),4,'0');
          V_NOVOSAQUE := TAB.SAQUE;

          FOR DET IN (SELECT A.GLB_LOCALIDADE_CODIGO DESTINO,
                             C.SLF_CALCTABELA_VALOR ALIQ
                        FROM tdvadm.T_SLF_TABELADET A,
                             tdvadm.T_GLB_LOCALIDADE D,
                             tdvadm.T_SLF_CALCTABELA C
                       WHERE A.SLF_TABELA_CODIGO = TAB.CODIGO
                         AND A.SLF_TABELA_SAQUE = V_NOVOSAQUE
                         AND A.GLB_LOCALIDADE_CODIGO = D.GLB_LOCALIDADE_CODIGO
                         AND D.GLB_ESTADO_CODIGO <> 'MG'
                         AND A.SLF_TABELA_CODIGO = C.SLF_TABELA_CODIGO
                         AND A.SLF_TABELA_SAQUE = C.SLF_TABELA_SAQUE
                         AND A.GLB_LOCALIDADE_CODIGO = C.GLB_LOCALIDADE_CODIGO
                         AND C.SLF_RECCUST_CODIGO = 'S_ALICMS'
                         AND C.SLF_CALCTABELA_VALOR <> 0) LOOP
          
            -- EMBUTE O ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = ROUND((CT.SLF_CALCTABELA_VALOR / ((100 - DET.ALIQ)/100)), 2)
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.DESTINO
               AND CT.SLF_RECCUST_CODIGO = 'D_FRPSVO';
             
            -- ZERA A ALIQUOTA DO ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = 0
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.DESTINO
               AND CT.SLF_RECCUST_CODIGO = 'S_ALICMS'; 

     -- EXECUTA O CALCULO DA SOLICITAC?O NO CASO DO P_RECALCULA = 'S'

            IF P_RECALCULA = 'S' THEN
              SP_MONTA_FORMULA_TABELA('041',TAB.CODIGO, TAB.SAQUE, DET.DESTINO);
              SP_MONTA_FORMULA_TABELA('315',TAB.CODIGO, TAB.SAQUE, DET.DESTINO);
            END IF;
          END LOOP;

       
      END LOOP;

      -- TRABALHA COM AS TABELAS FOB
      FOR TAB IN C_FOB LOOP
          -- CRIA UM NOVO SAQUE 
    --      SP_COPIA_TABELA_SEM_REAJ(TAB.CODIGO, TAB.SAQUE, TO_DATE(P_VIGENCIA, 'DD/MM/YYYY'), 'N');
          
          -- SETA VARIAVEL COM O NOVO SAQUE
    --      V_NOVOSAQUE := LPAD(TRIM(TO_CHAR(TO_NUMBER(TAB.SAQUE) + 1)),4,'0');
          V_NOVOSAQUE := TAB.SAQUE;
          
          FOR DET IN (SELECT A.GLB_LOCALIDADE_CODIGO ORIGEM,
                             C.SLF_CALCTABELA_VALOR ALIQ
                        FROM tdvadm.T_SLF_TABELADET A,
                             tdvadm.T_GLB_LOCALIDADE O,
                             tdvadm.T_SLF_CALCTABELA C
                       WHERE A.SLF_TABELA_CODIGO = TAB.CODIGO
                         AND A.SLF_TABELA_SAQUE = V_NOVOSAQUE
                         AND A.GLB_LOCALIDADE_CODIGO = O.GLB_LOCALIDADE_CODIGO
                         AND O.GLB_ESTADO_CODIGO = 'MG'
                         AND A.SLF_TABELA_CODIGO = C.SLF_TABELA_CODIGO
                         AND A.SLF_TABELA_SAQUE = C.SLF_TABELA_SAQUE
                         AND A.GLB_LOCALIDADE_CODIGO = C.GLB_LOCALIDADE_CODIGO
                         AND C.SLF_RECCUST_CODIGO = 'S_ALICMS'
                         AND C.SLF_CALCTABELA_VALOR <> 0) LOOP
          
            -- EMBUTE O ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = ROUND((CT.SLF_CALCTABELA_VALOR / ((100 - DET.ALIQ)/100)), 2)
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.ORIGEM
               AND CT.SLF_RECCUST_CODIGO = 'D_FRPSVO';
             
            -- ZERA A ALIQUOTA DO ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = 0
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.ORIGEM
               AND CT.SLF_RECCUST_CODIGO = 'S_ALICMS'; 

            -- EXECUTA O CALCULO DA PRACA NO CASO DO P_RECALCULA = 'S'
            IF P_RECALCULA = 'S' THEN
              SP_MONTA_FORMULA_TABELA('041',TAB.CODIGO, TAB.SAQUE, DET.ORIGEM);
              SP_MONTA_FORMULA_TABELA('315',TAB.CODIGO, TAB.SAQUE, DET.ORIGEM);
            END IF;
          END LOOP;

      END LOOP;

      COMMIT;
    END SP_EMBUTE_ICMS_TAB;

    PROCEDURE SP_DESEMBUTE_ICMS_TAB(P_RECALCULA IN CHAR DEFAULT 'N',
                                    P_CIF       IN CHAR DEFAULT 'S',
                                    P_FOB       IN CHAR DEFAULT 'S')
    IS
      V_NOVOSAQUE T_SLF_TABELA.SLF_TABELA_SAQUE%TYPE;
      V_ALIQ NUMBER;
      
      CURSOR C_CIF IS
        SELECT DISTINCT
               T.SLF_TABELA_CODIGO CODIGO,
               T.SLF_TABELA_SAQUE SAQUE,
               O.GLB_ESTADO_CODIGO UFORIGEM
          FROM tdvadm.T_SLF_TABELA T,
               tdvadm.T_SLF_TABELADET X,
               tdvadm.T_GLB_LOCALIDADE O,
               tdvadm.T_GLB_LOCALIDADE D,
               tdvadm.T_SLF_CALCTABELA C
         WHERE T.SLF_TABELA_STATUS = 'N'
           AND T.SLF_TABELA_TIPO <> 'FOB'
           AND T.SLF_TABELA_ISENTO = 'N'
           AND T.SLF_TPCALCULO_CODIGO in ('041','315')
           and t.glb_rota_codigo <> '216'
           AND T.SLF_TABELA_SAQUE = (SELECT MAX(M.SLF_TABELA_SAQUE)
                                       FROM tdvadm.T_SLF_TABELA M
                                      WHERE M.SLF_TABELA_CODIGO = T.SLF_TABELA_CODIGO)
           AND T.SLF_TABELA_CODIGO = X.SLF_TABELA_CODIGO
           AND T.SLF_TABELA_SAQUE = X.SLF_TABELA_SAQUE
           AND T.GLB_LOCALIDADE_CODIGO = O.GLB_LOCALIDADE_CODIGO
           AND X.GLB_LOCALIDADE_CODIGO = D.GLB_LOCALIDADE_CODIGO
           AND O.GLB_ESTADO_CODIGO = 'MG'
           AND D.GLB_ESTADO_CODIGO <> 'MG'
           AND C.SLF_TABELA_CODIGO = X.SLF_TABELA_CODIGO
           AND C.SLF_TABELA_SAQUE = X.SLF_TABELA_SAQUE
           AND C.GLB_LOCALIDADE_CODIGO = X.GLB_LOCALIDADE_CODIGO
           AND C.SLF_RECCUST_CODIGO = 'S_ALICMS'
           AND C.SLF_CALCTABELA_VALOR = 0;
                
      CURSOR C_FOB IS
        SELECT DISTINCT
               T.SLF_TABELA_CODIGO CODIGO,
               T.SLF_TABELA_SAQUE SAQUE,
               D.GLB_ESTADO_CODIGO UFDESTINO
          FROM tdvadm.T_SLF_TABELA T,
               tdvadm.T_SLF_TABELADET X,
               tdvadm.T_GLB_LOCALIDADE O,
               tdvadm.T_GLB_LOCALIDADE D,
               tdvadm.T_SLF_CALCTABELA C
         WHERE T.SLF_TABELA_STATUS = 'N'
           AND T.SLF_TABELA_TIPO = 'FOB'
           AND T.SLF_TABELA_ISENTO = 'N'
           AND T.SLF_TPCALCULO_CODIGO in ('041','315')
           AND T.SLF_TABELA_CODIGO IN ('00000618',
    '00000802',
    '00000804',
    '00000806',
    '00000811',
    '00000821',
    '00000824',
    '00000829',
    '00000834',
    '00000839',
    '00000844',
    '00000878',
    '00000883',
    '00000885',
    '00000888',
    '00000906')
           AND T.SLF_TABELA_SAQUE = (SELECT MAX(M.SLF_TABELA_SAQUE)
                                       FROM tdvadm.T_SLF_TABELA M
                                      WHERE M.SLF_TABELA_CODIGO = T.SLF_TABELA_CODIGO)
           AND T.SLF_TABELA_CODIGO = X.SLF_TABELA_CODIGO
           AND T.SLF_TABELA_SAQUE = X.SLF_TABELA_SAQUE
           AND X.GLB_LOCALIDADE_CODIGO = O.GLB_LOCALIDADE_CODIGO
           AND T.GLB_LOCALIDADE_CODIGO = D.GLB_LOCALIDADE_CODIGO
           AND O.GLB_ESTADO_CODIGO = 'MG'
           AND D.GLB_ESTADO_CODIGO <> 'MG'
           AND C.SLF_TABELA_CODIGO = X.SLF_TABELA_CODIGO
           AND C.SLF_TABELA_SAQUE = X.SLF_TABELA_SAQUE
           AND C.GLB_LOCALIDADE_CODIGO = X.GLB_LOCALIDADE_CODIGO
           AND C.SLF_RECCUST_CODIGO = 'S_ALICMS'
           AND C.SLF_CALCTABELA_VALOR = 0;
           
    BEGIN
      IF P_CIF = 'S' THEN
        -- TRABALHA COM AS TABELAS CIF E FOC
        FOR TAB IN C_CIF LOOP
          -- CRIA UM NOVO SAQUE 
          SP_COPIA_TABELA_SEM_REAJ(TAB.CODIGO, TAB.SAQUE, '01/04/2006', 'N');
            
          -- SETA VARIAVEL COM O NOVO SAQUE
          V_NOVOSAQUE := LPAD(TRIM(TO_CHAR(TO_NUMBER(TAB.SAQUE) + 1)),4,'0');
      
          --V_NOVOSAQUE := TAB.SAQUE;
      
          FOR DET IN (SELECT DISTINCT
                             A.GLB_LOCALIDADE_CODIGO DESTINO,
                             D.GLB_ESTADO_CODIGO UFDESTINO
                        FROM tdvadm.T_SLF_TABELADET A,
                             tdvadm.T_GLB_LOCALIDADE D,
                             tdvadm.T_SLF_CALCTABELA C
                       WHERE A.SLF_TABELA_CODIGO = TAB.CODIGO
                         AND A.SLF_TABELA_SAQUE = V_NOVOSAQUE
                         AND A.GLB_LOCALIDADE_CODIGO = D.GLB_LOCALIDADE_CODIGO
                         AND D.GLB_ESTADO_CODIGO <> 'MG'
                         AND C.SLF_TABELA_CODIGO = A.SLF_TABELA_CODIGO
                         AND C.SLF_TABELA_SAQUE = A.SLF_TABELA_SAQUE
                         AND C.GLB_LOCALIDADE_CODIGO = A.GLB_LOCALIDADE_CODIGO
                         AND C.SLF_RECCUST_CODIGO = 'S_ALICMS'
                         AND C.SLF_CALCTABELA_VALOR = 0) LOOP
            
            -- PROCURA A ALIQUOTA
            BEGIN
              SELECT I.SLF_ICMS_ALIQUOTA
                INTO V_ALIQ
                FROM tdvadm.T_SLF_ICMS I
               WHERE I.GLB_ESTADO_CODIGOORIGEM = TAB.UFORIGEM
                 AND I.GLB_ESTADO_CODIGODESTINO = DET.UFDESTINO
                 AND I.SLF_ICMS_DATAEFETIVA = (SELECT MAX(M.SLF_ICMS_DATAEFETIVA)
                                                 FROM tdvadm.T_SLF_ICMS M
                                                WHERE M.GLB_ESTADO_CODIGOORIGEM = I.GLB_ESTADO_CODIGOORIGEM
                                                  AND M.GLB_ESTADO_CODIGODESTINO = I.GLB_ESTADO_CODIGODESTINO); 
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'ALIQUOTA N?O ENCONTRADA PARA O PERCURSO ' || TAB.UFORIGEM || '-' || DET.UFDESTINO);
              WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(-20002, 'MAIS DE UMA ALIQUOTA PARA O PERCURSO ' || TAB.UFORIGEM || '-' || DET.UFDESTINO);
            END;
            
            -- DESEMBUTE O ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = ROUND((CT.SLF_CALCTABELA_VALOR * ((100 - V_ALIQ)/100)), 2)
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.DESTINO
               AND CT.SLF_RECCUST_CODIGO LIKE 'D%';
             
            -- VOLTA A ALIQUOTA DO ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = V_ALIQ
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.DESTINO
               AND CT.SLF_RECCUST_CODIGO = 'S_ALICMS'; 
      
            -- EXECUTA O CALCULO DA SOLICITAC?O NO CASO DO P_RECALCULA = 'S'
            IF P_RECALCULA = 'S' THEN
              SP_MONTA_FORMULA_TABELA('041',TAB.CODIGO, TAB.SAQUE, DET.DESTINO);
              SP_MONTA_FORMULA_TABELA('315',TAB.CODIGO, TAB.SAQUE, DET.DESTINO);
            END IF;
          END LOOP;
        END LOOP;
      END IF;

      IF P_FOB = 'S' THEN
        -- TRABALHA COM AS TABELAS FOB
        FOR TAB IN C_FOB LOOP
          -- CRIA UM NOVO SAQUE 
          SP_COPIA_TABELA_SEM_REAJ(TAB.CODIGO, TAB.SAQUE, '01/04/2006', 'N');
            
          -- SETA VARIAVEL COM O NOVO SAQUE
          V_NOVOSAQUE := LPAD(TRIM(TO_CHAR(TO_NUMBER(TAB.SAQUE) + 1)),4,'0');
      
            
          FOR DET IN (SELECT A.GLB_LOCALIDADE_CODIGO ORIGEM,
                             O.GLB_ESTADO_CODIGO UFORIGEM
                        FROM tdvadm.T_SLF_TABELADET A,
                             tdvadm.T_GLB_LOCALIDADE O,
                             tdvadm.T_SLF_CALCTABELA C
                       WHERE A.SLF_TABELA_CODIGO = TAB.CODIGO
                         AND A.SLF_TABELA_SAQUE = V_NOVOSAQUE
                         AND A.GLB_LOCALIDADE_CODIGO = O.GLB_LOCALIDADE_CODIGO
                         AND O.GLB_ESTADO_CODIGO = 'MG'
                         AND C.SLF_TABELA_CODIGO = A.SLF_TABELA_CODIGO
                         AND C.SLF_TABELA_SAQUE = A.SLF_TABELA_SAQUE
                         AND C.GLB_LOCALIDADE_CODIGO = A.GLB_LOCALIDADE_CODIGO
                         AND C.SLF_RECCUST_CODIGO = 'S_ALICMS'
                         AND C.SLF_CALCTABELA_VALOR = 0) LOOP
          
            -- PROCURA A ALIQUOTA
            BEGIN
              SELECT I.SLF_ICMS_ALIQUOTA
                INTO V_ALIQ
                FROM tdvadm.T_SLF_ICMS I
               WHERE I.GLB_ESTADO_CODIGOORIGEM = DET.UFORIGEM
                 AND I.GLB_ESTADO_CODIGODESTINO = TAB.UFDESTINO
                 AND I.SLF_ICMS_DATAEFETIVA = (SELECT MAX(M.SLF_ICMS_DATAEFETIVA)
                                                 FROM tdvadm.T_SLF_ICMS M
                                                WHERE M.GLB_ESTADO_CODIGOORIGEM = I.GLB_ESTADO_CODIGOORIGEM
                                                  AND M.GLB_ESTADO_CODIGODESTINO = I.GLB_ESTADO_CODIGODESTINO); 
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'ALIQUOTA N?O ENCONTRADA PARA O PERCURSO ' || DET.UFORIGEM || '-' || TAB.UFDESTINO);
              WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(-20002, 'MAIS DE UMA ALIQUOTA PARA O PERCURSO ' || DET.UFORIGEM || '-' || TAB.UFDESTINO);
            END;
      
            -- DESEMBUTE O ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = ROUND((CT.SLF_CALCTABELA_VALOR * ((100 - V_ALIQ)/100)), 2)
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.ORIGEM
               AND CT.SLF_RECCUST_CODIGO LIKE 'D%';
             
            -- VOLTA A ALIQUOTA DO ICMS NO NOVO SAQUE
            UPDATE T_SLF_CALCTABELA CT
               SET CT.SLF_CALCTABELA_VALOR = V_ALIQ
             WHERE CT.SLF_TABELA_CODIGO = TAB.CODIGO
               AND CT.SLF_TABELA_SAQUE = V_NOVOSAQUE
               AND CT.GLB_LOCALIDADE_CODIGO = DET.ORIGEM
               AND CT.SLF_RECCUST_CODIGO = 'S_ALICMS'; 
      
            -- EXECUTA O CALCULO DA PRACA NO CASO DO P_RECALCULA = 'S'
            IF P_RECALCULA = 'S' THEN
              SP_MONTA_FORMULA_TABELA('041',TAB.CODIGO, TAB.SAQUE, DET.ORIGEM);
              tdvadm.SP_MONTA_FORMULA_TABELA('315',TAB.CODIGO, TAB.SAQUE, DET.ORIGEM);
            END IF;
          END LOOP;
        END LOOP;
      END IF;
      COMMIT;
    END SP_DESEMBUTE_ICMS_TAB;


    PROCEDURE SP_REAJUSTE_TABELA(V_TABELA_CODIGO      IN T_SLF_TABELA.SLF_TABELA_CODIGO%TYPE,
                                 V_TABELA_SAQUE       IN T_SLF_TABELA.SLF_TABELA_SAQUE%TYPE,
                                 V_ESTADO_CODIGO      IN T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE,
                                 V_LOCREAJUSTE_CODIGO IN T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE,
                                 V_TIPO_DE_REAJUSTE   IN CHAR,
                                 V_REAJUSTE           IN NUMBER,
                                 V_VLRREAJ            IN NUMBER,
                                 realiza_copia_saque  IN Char)
    IS
        -- 1 Este cusor e para selecionar um conjunto de verbas de um estado de uma tabela
        CURSOR C_REAJUSTE_UF_C IS SELECT A.Slf_Calctabela_Valor,
                                         A.Slf_Tpcalculo_Codigo,
                                         A.Glb_Localidade_Codigo,
                                         A.Slf_Reccust_Codigo
                                  FROM   tdvadm.T_Slf_Calctabela A
                                  WHERE  A.Glb_Localidade_Codigo IN (SELECT Glb_Localidade_Codigo
                                                                       FROM tdvadm.T_Glb_Localidade
                                                                      WHERE Glb_Estado_Codigo = V_Estado_Codigo)
                                  And    RPAD(A.SLF_RECCUST_CODIGO,10)  In (Select RPAD(SLF_RECCUST_CODIGO,10)
                                                                            FROM tdvadm.V_Conjreccust_Codigo)
                                  AND    A.Slf_Tabela_Codigo  = V_Tabela_Codigo
                                  AND    A.Slf_Tabela_Saque   = V_Tabela_Saque
                                  AND    A.Slf_Reccust_Codigo   NOT IN ('S_ALICMS','S_ALISS');
        -- 2 Este cursor e para selecionar um conjunto de verbas de uma localidade
        CURSOR C_REAJUSTE_LOC_C IS SELECT Slf_Calctabela_Valor,
                                          Slf_Tpcalculo_Codigo,
                                          Glb_Localidade_Codigo,
                                          Slf_Reccust_Codigo
                                   FROM   tdvadm.T_Slf_Calctabela
                                   WHERE  Glb_Localidade_Codigo = V_Locreajuste_Codigo
                                   AND    Slf_Tabela_Codigo     = V_Tabela_Codigo
                                   AND    Slf_Tabela_Saque      = V_Tabela_Saque
                                   And    RPAD(SLF_RECCUST_CODIGO,10)  In (Select RPAD(SLF_RECCUST_CODIGO,10)
                                                                               from tdvadm.V_Conjreccust_Codigo)
                                   AND    Slf_Reccust_Codigo   NOT IN ('S_ALICMS','S_ALISS');
        -- 3 Este cursor e para selecionar um conjunto de verbas de toda a tabela
        CURSOR C_REAJUSTE_TOT_TAB_C IS SELECT NVL(Slf_Calctabela_Valor,0) AS Slf_Calctabela_Valor,
                                              Slf_Tpcalculo_Codigo,
                                              Glb_Localidade_Codigo,
                                              Slf_Reccust_Codigo
                                       FROM   tdvadm.T_Slf_Calctabela
                                       WHERE  Slf_Tabela_Codigo     = V_Tabela_Codigo
                                       AND    Slf_Tabela_Saque      = V_Tabela_Saque
                                       And    RPAD(SLF_RECCUST_CODIGO,10)  In (Select RPAD(SLF_RECCUST_CODIGO,10)
                                                                                   from tdvadm.V_Conjreccust_Codigo)
                                       AND    Slf_Reccust_Codigo   NOT IN ('S_ALICMS','S_ALISS');
        -- 4 Este cusor e para selecionar um conjunto de verbas que n?o seja do estado indicado de uma tabela
        CURSOR C_REAJUSTE_UF_C_NOT IS SELECT Slf_Calctabela_Valor,
                                             Slf_Tpcalculo_Codigo,
                                             Glb_Localidade_Codigo,
                                             Slf_Reccust_Codigo
                                      FROM   tdvadm.T_Slf_Calctabela
                                      WHERE  Glb_Localidade_Codigo NOT IN (SELECT Glb_Localidade_Codigo
                                                                           FROM   tdvadm.T_Glb_Localidade
                                                                           WHERE  Glb_Estado_Codigo = V_Estado_Codigo)
                                      AND    Slf_Tabela_Codigo  = V_Tabela_Codigo
                                      AND    Slf_Tabela_Saque   = V_Tabela_Saque
                                      And    RPAD(SLF_RECCUST_CODIGO,10)  In (Select RPAD(SLF_RECCUST_CODIGO,10)
                                                                                  from tdvadm.t_slf_reajusteverbas)
                                      AND    Slf_Reccust_Codigo   NOT IN ('S_ALICMS','S_ALISS');
         --Este cursor e para selecionar todas as localidade de uma tabela
         CURSOR C_LOC_TABELA IS SELECT Glb_Localidade_Codigo
                                FROM   tdvadm.T_Slf_Tabeladet
                                WHERE  Slf_Tabela_Codigo     = V_Tabela_Codigo
                                AND    Slf_Tabela_Saque      = V_Tabela_Saque;
         --Este cursor e para selecionar todas as localidade de uma tabela por estado
         CURSOR C_LOC_TABELA_UF IS SELECT Glb_Localidade_Codigo
                                   FROM   tdvadm.T_Slf_Tabeladet
                                   WHERE  Slf_Tabela_Codigo     = V_Tabela_Codigo
                                   AND    Slf_Tabela_Saque      = V_Tabela_Saque
                                   AND    Glb_Localidade_Codigo In (Select Glb_Localidade_Codigo
                                                                   From   tdvadm.T_Glb_Localidade
                                                                   Where  Glb_Estado_Codigo = V_Estado_Codigo);
         --Este cursor e para selecionar todas as localidade de uma tabela por estado exceto o informado
         CURSOR C_LOC_TABELA_UF_NOT IS SELECT GLB_LOCALIDADE_CODIGO
                                       From   tdvadm.T_Slf_Tabeladet
                                       Where  Slf_Tabela_Codigo     = V_Tabela_Codigo
                                       And    Slf_Tabela_Saque      = V_Tabela_Saque
                                       And    Glb_Localidade_Codigo In (Select Glb_Localidade_Codigo
                                                                       From   tdvadm.T_Glb_Localidade
                                                                       Where  Glb_Estado_Codigo = V_Estado_Codigo);
         V_Valor             T_Slf_Calctabela.Slf_Calctabela_Valor%Type;
         V_Tpcalculo_Codigo  T_Slf_Calctabela.Slf_Tpcalculo_Codigo%Type;
         V_Localidade_Codigo T_Slf_Calctabela.Glb_Localidade_Codigo%Type;
         V_Reccust_Codigo    T_Slf_Calctabela.Slf_Reccust_Codigo%Type;
         V_Tabela_Saqueatual T_Slf_Tabela.Slf_Tabela_Saque%Type;
         V_Precisao          T_Slf_Calculo.Slf_Calculo_Precisao%Type;
         X                   Number;
    BEGIN
        IF realiza_copia_saque = 'S' THEN
            SP_FAZ_COPIA_SAQUE_TAB(V_TABELA_CODIGO,V_TABELA_SAQUE,'','S');
            SELECT (MAX(TO_NUMBER(SLF_TABELA_SAQUE)))
            INTO   X
            FROM   tdvadm.T_SLF_TABELA
            WHERE  SLF_TABELA_CODIGO  = V_TABELA_CODIGO;
            V_TABELA_SAQUEATUAL := SUBSTR(TO_CHAR(X,'0000'),2,4);
        ELSE
            V_TABELA_SAQUEATUAL := V_TABELA_SAQUE;
        END IF;
        IF V_REAJUSTE = '1' THEN
            OPEN C_REAJUSTE_UF_C;
            LOOP
              FETCH C_REAJUSTE_UF_C
              INTO  V_VALOR,
                    V_TPCALCULO_CODIGO,
                    V_LOCALIDADE_CODIGO,
                    V_RECCUST_CODIGO;
              EXIT WHEN C_REAJUSTE_UF_C%NOTFOUND;          
               V_VALOR := F_CALCULO_DINAMICO_RVL(V_VALOR,V_VLRREAJ,V_TIPO_DE_REAJUSTE);           
              BEGIN
                  SELECT SLF_CALCULO_PRECISAO
                  INTO   V_PRECISAO
                  FROM   tdvadm.T_SLF_CALCULO
                  WHERE  SLF_TPCALCULO_CODIGO = V_TPCALCULO_CODIGO
                  AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10);
              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                  V_PRECISAO := '0';
              END;
              UPDATE T_SLF_CALCTABELA
              SET    SLF_CALCTABELA_VALOR    = ROUND(V_VALOR,V_PRECISAO)
              WHERE  SLF_TABELA_CODIGO       = V_TABELA_CODIGO
              AND    SLF_TABELA_SAQUE        = V_TABELA_SAQUEATUAL
              AND    GLB_LOCALIDADE_CODIGO   = V_LOCALIDADE_CODIGO
              AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10)
              AND    SLF_TPCALCULO_CODIGO    = V_TPCALCULO_CODIGO;
            END LOOP;
            OPEN C_LOC_TABELA_UF;
            LOOP
                  FETCH C_LOC_TABELA_UF
                  INTO  V_LOCALIDADE_CODIGO;
                  EXIT WHEN C_LOC_TABELA_UF%NOTFOUND;
                  SP_MONTA_FORMULA_TABELA(V_TPCALCULO_CODIGO,V_TABELA_CODIGO,V_TABELA_SAQUEATUAL,V_LOCALIDADE_CODIGO);
            END LOOP;
        ELSE
            IF V_REAJUSTE = '2' THEN
                OPEN C_REAJUSTE_LOC_C;
                LOOP
                  FETCH C_REAJUSTE_LOC_C
                  INTO  V_VALOR,
                        V_TPCALCULO_CODIGO,
                        V_LOCALIDADE_CODIGO,
                        V_RECCUST_CODIGO;
                  EXIT WHEN C_REAJUSTE_LOC_C%NOTFOUND;              
                   V_VALOR := F_CALCULO_DINAMICO_RVL(V_VALOR,V_VLRREAJ,V_TIPO_DE_REAJUSTE);               
                  BEGIN
                      SELECT SLF_CALCULO_PRECISAO
                      INTO   V_PRECISAO
                      FROM   tdvadm.T_SLF_CALCULO
                      WHERE  SLF_TPCALCULO_CODIGO = V_TPCALCULO_CODIGO
                      AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10);
                  EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                      V_PRECISAO := '0';
                  END;
                  UPDATE T_SLF_CALCTABELA
                  SET    SLF_CALCTABELA_VALOR    = ROUND(V_VALOR,V_PRECISAO)
                  WHERE  SLF_TABELA_CODIGO       = V_TABELA_CODIGO
                  AND    SLF_TABELA_SAQUE        = V_TABELA_SAQUEATUAL
                  AND    GLB_LOCALIDADE_CODIGO   = V_LOCALIDADE_CODIGO
                  AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10)
                  AND    SLF_TPCALCULO_CODIGO    = V_TPCALCULO_CODIGO;
                END LOOP;
                SP_MONTA_FORMULA_TABELA(V_TPCALCULO_CODIGO,V_TABELA_CODIGO,V_TABELA_SAQUEATUAL,V_LOCALIDADE_CODIGO);
            ELSE
                IF V_REAJUSTE = '3' THEN
                    OPEN C_REAJUSTE_TOT_TAB_C;
                    LOOP
                      FETCH C_REAJUSTE_TOT_TAB_C
                      INTO  V_VALOR,
                            V_TPCALCULO_CODIGO,
                            V_LOCALIDADE_CODIGO,
                            V_RECCUST_CODIGO;
                      EXIT WHEN C_REAJUSTE_TOT_TAB_C%NOTFOUND;                  
                       V_VALOR := F_CALCULO_DINAMICO_RVL(V_VALOR,V_VLRREAJ,V_TIPO_DE_REAJUSTE); 
                      BEGIN
                          SELECT SLF_CALCULO_PRECISAO
                          INTO   V_PRECISAO
                          FROM   tdvadm.T_SLF_CALCULO
                          WHERE  SLF_TPCALCULO_CODIGO = V_TPCALCULO_CODIGO
                          AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10);
                      EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                          V_PRECISAO := '0';
                      END;
                      UPDATE T_SLF_CALCTABELA
                      SET    SLF_CALCTABELA_VALOR    = ROUND(V_VALOR,V_PRECISAO)
                      WHERE  SLF_TABELA_CODIGO       = V_TABELA_CODIGO
                      AND    SLF_TABELA_SAQUE        = V_TABELA_SAQUEATUAL
                      AND    GLB_LOCALIDADE_CODIGO   = V_LOCALIDADE_CODIGO
                      AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10)
                      AND    SLF_TPCALCULO_CODIGO    = V_TPCALCULO_CODIGO;
                    END LOOP;
                    OPEN C_LOC_TABELA;
                    LOOP
                          FETCH C_LOC_TABELA
                          INTO  V_LOCALIDADE_CODIGO;
                          EXIT WHEN C_LOC_TABELA%NOTFOUND;
                          SP_MONTA_FORMULA_TABELA(V_TPCALCULO_CODIGO,V_TABELA_CODIGO,V_TABELA_SAQUEATUAL,V_LOCALIDADE_CODIGO);
                    END LOOP;
                ELSE
                    IF V_REAJUSTE = '4' THEN
                        OPEN C_REAJUSTE_UF_C_NOT;
                        LOOP
                          FETCH C_REAJUSTE_UF_C_NOT
                          INTO  V_VALOR,
                                V_TPCALCULO_CODIGO,
                                V_LOCALIDADE_CODIGO,
                                V_RECCUST_CODIGO;
                          EXIT WHEN C_REAJUSTE_UF_C_NOT%NOTFOUND;                      
                           V_VALOR := F_CALCULO_DINAMICO_RVL(V_VALOR,V_VLRREAJ,V_TIPO_DE_REAJUSTE);                      
                          BEGIN
                              SELECT SLF_CALCULO_PRECISAO
                              INTO   V_PRECISAO
                              FROM   tdvadm.T_SLF_CALCULO
                              WHERE  SLF_TPCALCULO_CODIGO = V_TPCALCULO_CODIGO
                              AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10);
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                              V_PRECISAO := '0';
                          END;
                          UPDATE T_SLF_CALCTABELA
                          SET    SLF_CALCTABELA_VALOR    = ROUND(V_VALOR,V_PRECISAO)
                          WHERE  SLF_TABELA_CODIGO       = V_TABELA_CODIGO
                          AND    SLF_TABELA_SAQUE        = V_TABELA_SAQUEATUAL
                          AND    GLB_LOCALIDADE_CODIGO   = V_LOCALIDADE_CODIGO
                          AND     RPAD(SLF_RECCUST_CODIGO,10)       = RPAD(V_RECCUST_CODIGO,10)
                          AND    SLF_TPCALCULO_CODIGO    = V_TPCALCULO_CODIGO;
                        END LOOP;
                        OPEN C_LOC_TABELA_UF_NOT;
                        LOOP
                              FETCH C_LOC_TABELA_UF_NOT
                              INTO  V_LOCALIDADE_CODIGO;
                              EXIT WHEN C_LOC_TABELA_UF_NOT%NOTFOUND;
                              SP_MONTA_FORMULA_TABELA(V_TPCALCULO_CODIGO,V_TABELA_CODIGO,V_TABELA_SAQUEATUAL,V_LOCALIDADE_CODIGO);
                        END LOOP;
                    END IF;
                END IF;
            END IF;
        END IF;
        commit;
    END SP_REAJUSTE_TABELA;


    PROCEDURE SP_SLF_REAJUSTAPED(P_USUARIO   IN CHAR,
                                 P_RELATORIO IN CHAR,
                                 P_DATA      IN CHAR,
                                 P_VAR_TABELA IN CHAR)
      IS
         V_TABELA                      CHAR(8);
         V_SAQUE                       CHAR(4);
         CURSOR C_QUAIS
         IS
          select distinct substr(TMP_RPT_TEXTO8,1,8) as tabela,
                          substr(TMP_RPT_TEXTO9,1,4) as saque
          from tdvadm.t_tmp_rpt
          where TMP_RPT_USUARIO = P_USUARIO
            and TMP_RPT_RELATORIO = P_RELATORIO
            and TMP_RPT_TEXTO8 > P_VAR_TABELA;
         CURSOR C_TABELA
         IS
           select SLF_TPCALCULO_CODIGO,
                  SLF_TABELA_CODIGO as TabNova,
                  to_char(to_number(SLF_TABELA_SAQUE)+1,'0000') as SaqueNovo,
                  SLF_TABELA_CODIGO,
                  SLF_TABELA_SAQUE,
                  SLF_TABELA_ISENTO,
                  GLB_LOCALIDADE_CODIGOORIGEM,
                  GLB_LOCALIDADE_CODIGODESTINO,
                  GLB_ROTA_CODIGO,
                  GLB_MERCADORIA_CODIGO,
                  GLB_CLIENTE_CGCCPFCODIGOSACADO,
                  SLF_TABELA_TIPO,
                  SLF_TABELA_ORIGEMDESTINO,
                  SLF_TABELA_PEDREAJAUT,
                  SLF_TABELA_PEDATUALIZA,
                  'T' as TIPO
      from tdvadm.v_slf_tabperaltped
      where SLF_TABELA_CODIGO = V_TABELA
        and SLF_TABELA_SAQUE = V_SAQUE;
         -- DEFINE OS REGISTROS DE TRABALHO
      --   RC_QUAIS                      C_QUAIS%ROWTYPE;
      --   RC_CTABELA                    C_TABELA%ROWTYPE;
      BEGIN
         FOR RC_QUAIS IN C_QUAIS
         LOOP
            V_TABELA := RC_QUAIS.TABELA;
            V_SAQUE  := RC_QUAIS.SAQUE;

            FOR RC_CTABELA IN C_TABELA
            LOOP
               SP_COPIA_CALC_TABELA2(RC_CTABELA.SLF_TPCALCULO_CODIGO,
                                     RC_CTABELA.TabNova,
                                     LTRIM(RC_CTABELA.SaqueNovo),
                                     RC_CTABELA.SLF_TABELA_CODIGO,
                                     RC_CTABELA.SLF_TABELA_SAQUE,
                                     RC_CTABELA.SLF_TABELA_ISENTO,
                                     RTRIM(RC_CTABELA.GLB_LOCALIDADE_CODIGOORIGEM),
                                     RTRIM(RC_CTABELA.GLB_LOCALIDADE_CODIGODESTINO),
                                     RC_CTABELA.GLB_ROTA_CODIGO,
                                     RC_CTABELA.GLB_MERCADORIA_CODIGO,
                                     RTRIM(RC_CTABELA.GLB_CLIENTE_CGCCPFCODIGOSACADO),
                                     RTRIM(RC_CTABELA.SLF_TABELA_TIPO),
                                     RC_CTABELA.SLF_TABELA_ORIGEMDESTINO,
                                     RC_CTABELA.SLF_TABELA_PEDREAJAUT,
                                     RC_CTABELA.SLF_TABELA_PEDATUALIZA,
                                     RC_CTABELA.TIPO,
                                     P_DATA);
               SP_MONTA_FORMULA_TABELA(RC_CTABELA.SLF_TPCALCULO_CODIGO,
                                       RC_CTABELA.TabNova,
                                       RC_CTABELA.SaqueNovo,
                                       RTRIM(RC_CTABELA.GLB_LOCALIDADE_CODIGODESTINO));
               COMMIT;
            END LOOP;
         END LOOP;
    END SP_SLF_REAJUSTAPED;

    PROCEDURE SP_LISTAREGRACONTRATO(pContrato in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                                    pStatus   out char,
                                    pMessage  out clob)
    As
      vCursor PKG_EDI_PLANILHA.T_CURSOR;
      vLinha pkg_glb_SqlCursor.tpString1024;
    Begin
      
    pMessage := empty_clob;
    pStatus  := 'N';
      
         open vCursor FOR SELECT * 
                          from (SELECT	c.Seq, 	'02' ordem,	'Vigencia'                                 DESCRICAO	,	TO_CHAR(C.VIGENCIA,'DD/MM/YYYY') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'03' ordem,	'Ativo'                                    DESCRICAO	,	C.ATIVO                    CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'04' ordem,	'Inicio do Contrato'                       DESCRICAO	,	TO_CHAR(C.DTINICIO,'DD/MM/YYYY') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'05' ordem,	'Final do Contrato'                        DESCRICAO	,	TO_CHAR(C.DTFINAL,'DD/MM/YYYY')  CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'06' ordem,	'Codigo do Contrato'                       DESCRICAO	,	C.CONTRATO                 CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'07' ordem,	'Descricao do Contrato'                    DESCRICAO	,	C.DESCCONTRATO             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'08' ordem,	'Grupo Economico da Regra'                 DESCRICAO	,	C.GRUPO                    CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'09' ordem,	'Nome do Grupo'                            DESCRICAO	,	C.DESCGRUPO                CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'10' ordem,	'CNPJ usado na Regra'                      DESCRICAO	,	C.CNPJ                     CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'11' ordem,	'Tipo de Carga Selecionada'                DESCRICAO	,	C.TPCARGA                  CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'12' ordem,	'Finaliza digitação da Nota'               DESCRICAO	,	C.FIMDIGITNOTA             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'13' ordem,	'Agrupa Nota por Cte'                      DESCRICAO	,	C.AGRUPANOTACTE            CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'14' ordem,	'Quantidade de Notas por Cte'              DESCRICAO	,	TO_CHAR(C.QTDECTRC)        CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'15' ordem,	'Agrupa Nota por NFSe'                     DESCRICAO	,	C.AGRUPANOTANFSE           CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'16' ordem,	'Quantidade de Notas por NFSe'             DESCRICAO	,	TO_CHAR(C.QTDENF)          CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'17' ordem,	'Globalizado'                              DESCRICAO	,	C.GLOBALIZADO              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'18' ordem,	'Cria coleta no Fifo'                      DESCRICAO	,	C.CRIACOLFIFO              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'19' ordem,	'Quantidade de Notas por Coleta'           DESCRICAO	,	TO_CHAR(C.QTDENOTACOL)     CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'20' ordem,	'Peso pra Cobranca'                        DESCRICAO	,	C.PESOCOBRANCA             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'21' ordem,	'Base de Ocupação'                         DESCRICAO	,	TO_CHAR(C.BASEOCUPACAO)    CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'22' ordem,	'Valor da Base de Ocupacao'                DESCRICAO	,	TO_CHAR(C.VALORBASE)       CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'23' ordem,	'Peso Minimo'                              DESCRICAO	,	TO_CHAR(C.PESOMINIMO)      CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'24' ordem,	'Peso Maximo'                              DESCRICAO	,	TO_CHAR(C.PESOMAXIMO)      CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'25' ordem,	'Rateia valor do Frete'                    DESCRICAO	,	C.RATEIA                   CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'26' ordem,	'Tipo de Rateio a ser feito'               DESCRICAO	,	C.TIPORATEIO               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'27' ordem,	'Tipo de Agrupamento para calculo'         DESCRICAO	,	C.TIPOAGRUPA               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'28' ordem,	'Cria um Novo Cte por coleta'              DESCRICAO	,	C.NOVOCTEPORCOLETA         CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'29' ordem,	'Cria um Novo NFSe por coleta'             DESCRICAO	,	C.NOVANOTAPORCOLETA        CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'30' ordem,	'Como sera pesquisado para Achar o FRETE'  DESCRICAO	,	C.TPFRETEPESQ              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'31' ordem,	'Usa Faixa de KM'                          DESCRICAO	,	C.USAFAIXAKM               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'32' ordem,	'Usa Faixa de Peso'                        DESCRICAO	,	C.USAFAIXAPESO             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'33' ordem,	'Usa Veiculo'                              DESCRICAO	,	C.USAVEICULO               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'34' ordem,	'Onde Pesquisar o Veiculo'                 DESCRICAO	,	C.PESQUISAVEICULO          CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'35' ordem,	'Procura Formulario para Expresso'         DESCRICAO	,	C.FORMULARIOEXP            CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'36' ordem,	'Percentual para Expresso'                 DESCRICAO	,	TO_CHAR(C.PERCTEX)         CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'37' ordem,	'Procura Formulario para Quimico'          DESCRICAO	,	C.FORMAULARIOQUIMICO       CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'38' ordem,	'Percentual para Quimico'                  DESCRICAO	,	TO_CHAR(C.PERCENTQUIMICO)  CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'39' ordem,	'Percentual para OUTBOUND'                 DESCRICAO	,	TO_CHAR(C.PERCENTOUTBOUND) CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'40' ordem,	'Percentual para Transferencia'            DESCRICAO	,	TO_CHAR(C.PERCTTRANSF)     CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'41' ordem,	'Percentual para Redutor'                  DESCRICAO	,	TO_CHAR(C.PERCENTREDUTOR)  CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'42' ordem,	'Fixa Origem '                             DESCRICAO	,	C.FIXOORIGEM               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'43' ordem,	'Fixa Destino'                             DESCRICAO	,	C.FIXODESTINO              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'44' ordem,	'Somente pode ser Carga de Transferencia'  DESCRICAO	,	C.SOTRANSFERENCIA          CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'45' ordem,	'Usa tabela especifica de Pedagio'         DESCRICAO	,	C.TABPEDAGIO               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'46' ordem,	'Usa Tabela especifica para KM'            DESCRICAO	,	C.TABKM                    CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'47' ordem,	'Km minimo para percurso'                  DESCRICAO	,	TO_CHAR(C.KMMINIMO)        CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'48' ordem,	'Cobra Coleta'                             DESCRICAO	,	C.COBRACOLETA              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'49' ordem,	'Forma de Cobranca para Coleta'            DESCRICAO	,	C.FORCOBCOLETA             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'50' ordem,	'Pode Mudar a Origem da Coleta'            DESCRICAO	,	C.MUDAORIGEMCC             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'51' ordem,	'Para sem Preco para coleta'               DESCRICAO	,	C.PARASEMPCC               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'52' ordem,	'Usa Faixa de KM para Coleta'              DESCRICAO	,	C.USAFAIXAKMC              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'53' ordem,	'Usa Faixa de Peso para Coleta'            DESCRICAO	,	C.USAFAIXAPSOC             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'54' ordem,	'Cria um novo Cte/NFSe para cobrar Coleta' DESCRICAO	,	C.CTEDECOLETA              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'55' ordem,	'Tipo de Carga para Pesquisar a Coleta'    DESCRICAO	,	C.TPCARGACOL               CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'56' ordem,	'Como sera pesquisado para Achar a Coleta' DESCRICAO	,	C.TPFRETEPESQCOL           CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'57' ordem,	'Usa Veiculo na Coleta'                    DESCRICAO	,	C.USAVEICULOC              CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'58' ordem,	'Onde Pesquisar o Veiculo para coleta'     DESCRICAO	,	C.PESQVEICULOC             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                --SELECT	c.Seq, 	'59' ordem,	'?????'                                    DESCRICAO	,	C.AGRPORCOLETA             CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'60' ordem,	'Formula para Cobrar coleta como Taxa'     DESCRICAO	,	replace(replace(C.FORMULACOLTX,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'61' ordem,	'Formula para Cobrar coleta como Valor'    DESCRICAO	,	replace(replace(C.FORMULACOLVL,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'62' ordem,	'Formula para Cobrar coleta como KM'       DESCRICAO	,	replace(replace(C.FORMULACOLKM,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'63' ordem,	'Limite de Valor para emissao de Cte'      DESCRICAO	,	TO_CHAR(C.LIMITEVLRCTE)    CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'64' ordem,	'Limite de Valor para emissao de NFSe'     DESCRICAO	,	TO_CHAR(C.LIMITVLRNFSE)    CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'65' ordem,	'Formula para Cobrar Frete como Taxa'      DESCRICAO	,	replace(replace(C.FORMULAFRTX,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'66' ordem,	'Formula para Cobrar Frete como Valor'     DESCRICAO	,	replace(replace(C.FORMULAFRTVL,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'67' ordem,	'Formula para Cobrar Frete como KM'        DESCRICAO	,	replace(replace(C.FORMULAFRTKM,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'68' ordem,	'Formula para Cobrar Pedagio como Taxa'    DESCRICAO	,	replace(replace(C.FORMULAPDTX,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato UNION
                                SELECT	c.Seq, 	'69' ordem,	'Formula para Cobrar Pedagio como Valor'   DESCRICAO	,	replace(replace(C.FORMULAPDVL,'<<',''),'>>','') CONTEUDO	FROM tdvadm.v_slf_clientecargas_tra c where c.contrato = pContrato 
                                )
                          order by seq,ordem;
                          
         pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
         pkg_glb_SqlCursor.TipoHederHTML.Tamanho := '100%';
         pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
         pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha);
      
         pMessage := pMessage || tdvadm.pkg_glb_html.LinhaH;

         for i in 1 .. vLinha.count loop
            if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
               pMessage := pMessage || vLinha(i);
            Else
               pMessage := pMessage || vLinha(i) || chr(10);
            End if;
         End loop;

    
    End SP_LISTAREGRACONTRATO;                                     


    PROCEDURE SP_CRITICAPLANILHA(pProtocolo in char,
                                 pStatus    out char,
                                 pMessage   out clob)
    As
      vTotalRegistros number;
      vCerto          number;
      vErrado         number;
      vContrato       tdvadm.t_slf_contrato.slf_contrato_codigo%type;
      vAuxiliar       number;
      vAuxiliarT      varchar2(200);
      vAuxiliarT1     varchar2(200);
      vArqcsv         rmadm.t_glb_benasserec.glb_benasserec_fileanexo%type;
      vEmail          rmadm.t_glb_benasserec.glb_benasserec_origem%type;
      vStatus         char(1);
      vMessage        clob;
    Begin

    pStatus := 'N'; -- Normal      
    pMessage := empty_clob;

-------------------------- INICIO DO PROCESSO ----------------------------

      pMessage := tdvadm.pkg_glb_html.Assinatura;
      pMessage := pMessage || tdvadm.pkg_glb_html.fn_Titulo('CRITICA DO PROTOCOLO ' || pProtocolo);
      pMessage := pMessage || tdvadm.pkg_glb_html.fn_AbreLista;
     

      -- Verifica se foi processado
      Begin
        select br.glb_benasserec_status,
               br.glb_benasserec_origem,
               upper(br.glb_benasserec_fileanexo)
          into vAuxiliarT,
               vEmail,
               vArqcsv
        from rmadm.t_glb_benasserec br
        where br.glb_benasserec_chave = pProtocolo;
      exception
        When NO_DATA_FOUND Then
          vAuxiliarT := 'NE';
          pStatus := 'E';
      End;
      
   /*   vEmail := 'sdrumond@dellavolpe.com.br';*/
      pStatus := 'N';
          
      If vAuxiliarT <> 'MO' Then
         
         If vAuxiliarT = 'NE' Then
            vAuxiliarT1 := 'Processo Não Encontrado';
         ElsIf vAuxiliarT = 'ER' Then
            vAuxiliarT1 := 'Processo Com Erro';
         Else
            vAuxiliarT1 := 'Entre em contato com a TI - Verificar o STATUS do PROCESSO [' || vAuxiliarT1 || ']';
         End If;

         pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
      End If;

     -- Conta os Registros
      select count(*)
         into vTotalRegistros
      from tdvadm.v_slf_calcfretekmpreimpcsv X
      where 0 = 0
        AND X.CONTRATO IS NOT NULL
        and x.CARGA <> 'CARGA'
        and x.planilha = vArqcsv;
        
      dbms_output.put_line('ARQUIVO ' || vArqcsv || ' Registros - ' || to_char(vTotalRegistros));
      If vTotalRegistros = 0 Then
         pStatus := 'E';
         vAuxiliarT1 := 'Problema na Leitura da Planilha, registros encontrados [' || to_char(vTotalRegistros) || ']';
         pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
         pMessage := pMessage || tdvadm.pkg_glb_html.fn_FechaLista;
      Else

         vAuxiliarT1 := 'Registros encontrados [' || to_char(vTotalRegistros) || ']';
         pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
      End If;

      If pStatus = 'N' Then
  
         Begin
            select distinct trim(x.VIGENCIA)
               into vAuxiliarT
           from tdvadm.v_slf_calcfretekmpreimpcsv X
           where 0 = 0 --x.protocolo in (pProtocolo)
             AND X.CONTRATO IS NOT NULL
             and x.planilha = vArqcsv
             and x.VIGENCIA <> 'VIGENCIA';
         exception
           When NO_DATA_FOUND Then
                pStatus := 'E';
                vAuxiliarT1 := 'Problemas na Checagem da VIGENCIA, NAO LOCALIZADA';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
           When TOO_MANY_ROWS Then
                pStatus := 'E';
                vAuxiliarT1 := 'Problemas na Checagem da VIGENCIA - Retornou mais que uma DATA';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
           When OTHERS Then
                pStatus := 'E';
                vAuxiliarT1 := 'Problemas na Checagem da VIGENCIA, erro: ' || sqlerrm;
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
           End ;

         vAuxiliarT1 := 'Vigencia da Tabela [' || vAuxiliarT || ']';
         pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);


          -- Verifica se existe o Grupo, Cliente e Contrato
          for c_msg in (select x.grupo,
                               gp.glb_grupoeconomico_nome nomegrupo,
                               x.cliente,
                               cl.glb_cliente_razaosocial nomecliente,
                               x.contrato,
                               ct.slf_contrato_descricao descricaocontrato,
                               count(*) qtde
                        from tdvadm.v_slf_calcfretekmpreimpcsv x,
                             tdvadm.t_glb_grupoeconomico gp,
                             tdvadm.t_Glb_Cliente cl,
                             tdvadm.t_slf_contrato ct
                        where 0 = 0 --x.protocolo = pProtocolo
                          AND X.CONTRATO IS NOT NULL
                          and x.grupo = gp.glb_grupoeconomico_codigo (+)
                          and rpad(LPAD(x.cliente,14,'0'),20) = cl.glb_cliente_cgccpfcodigo (+)
                          and x.contrato = ct.slf_contrato_codigo (+)
                          and x.planilha = vArqcsv
                          and x.GRUPO <> 'GRUPO'
                          group by x.grupo,
                                 gp.glb_grupoeconomico_nome,
                                 x.cliente,
                                 cl.glb_cliente_razaosocial,
                                 x.contrato,
                                 ct.slf_contrato_descricao)
          Loop
            
             If c_msg.nomegrupo is null Then
                pStatus := 'E';
                vAuxiliarT1 := 'Grupo Economico Invalido ou inexistente [' || c_msg.grupo || ']';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             End If;

             If c_msg.nomecliente is null Then
                pStatus := 'E';
                vAuxiliarT1 := 'CNPJ do Cliente Invalido ou inexistente [' || c_msg.cliente || ']';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             End If;

             If c_msg.descricaocontrato is null Then
                pStatus := 'E';
                vContrato := '';
                vAuxiliarT1 := 'Codigo de Contrato Invalido ou inexistente [' || c_msg.contrato || ']';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vContrato := c_msg.contrato; 
             End If;

          End Loop;
             

          vCerto := 0;
          vErrado := 0;
          
          -- Conta os registros para tipos de Carga
          for c_msg in (select x.protocolo,nvl(X.CODCARGA,'XX') CODCARGA,tc.fcf_tpcarga_descricao nome, COUNT(*) qtde
                        from tdvadm.v_slf_calcfretekmpreimpcsv X,
                             tdvadm.t_fcf_tpcarga tc
                        where 0 = 0 --x.protocolo in (pProtocolo)
                          AND X.CONTRATO IS NOT NULL
                          and x.planilha = vArqcsv
                          and x.CARGA <> 'CARGA'
                          and trim(X.CODCARGA) = trim(tc.fcf_tpcarga_codigo (+))
                        group by x.protocolo,X.CODCARGA,tc.fcf_tpcarga_descricao)
          Loop

             If c_msg.nome is null Then
                pStatus := 'E';
                vErrado := vErrado + c_msg.qtde;
                If c_msg.CODCARGA = 'XX' Then
                   vAuxiliarT1 := 'Codigo de Carga em BRANCO';
                Else
                   vAuxiliarT1 := 'Codigo de Carga Não existe [' || c_msg.codcarga || ']';
                End If;
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vCerto := vCerto + c_msg.qtde;
             End If;
               
          End Loop;

          -- Conta os registros para tipos de Veiculos
          for c_msg in (select x.protocolo,nvl(X.CODVEICULO,'XX') CODVEICULO ,tv.fcf_tpveiculo_descricao nome, COUNT(*) qtde
                        from tdvadm.v_slf_calcfretekmpreimpcsv X,
                             tdvadm.t_fcf_tpveiculo tv
                        where 0=0
                            --x.protocolo in (pProtocolo)
                          AND X.CONTRATO IS NOT NULL
                          and x.CODVEICULO <> 'CODVEICULO'
                          and x.CODVEICULO <> 'COD'
                          and x.planilha = vArqcsv
                          and trim(X.CODVEICULO) = trim(tv.fcf_tpveiculo_codigo (+))
                        group by x.protocolo,X.CODVEICULO,tv.fcf_tpveiculo_descricao)
          Loop

             If c_msg.nome is null Then
                pStatus := 'E';
                vErrado := vErrado + c_msg.qtde;
                If c_msg.codveiculo = 'XX' Then
                   vAuxiliarT1 := 'Codigo de Veiculo em BRANCO';
                Else  
                   vAuxiliarT1 := 'Codigo de Veiculo Não existe [' || c_msg.codveiculo || ']';
                End If;
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vCerto := vCerto + c_msg.qtde;
             End If;
            
          End Loop;      



          -- Procurando se existe alguma origem nula
          for c_msg in (select x.protocolo,
                               decode(nvl(x.ORIGEM,'XXXXXX'),'XXXXXX','NULO','NAONULO') ORIGEM, 
                               count(*) qtde
                        from tdvadm.v_slf_calcfretekmpreimpcsv X
                        where 0 = 0 --x.protocolo in (pProtocolo)
                          AND X.CONTRATO IS NOT NULL
                          and x.planilha = vArqcsv
                          AND X.origem <> 'ORIGEM'
                        --  and x.ORIGEM is null
                        group by x.protocolo,decode(nvl(x.ORIGEM,'XXXXXX'),'XXXXXX','NULO','NAONULO'))
          Loop
            
             If c_msg.origem = 'NULO' Then
                pStatus := 'E';
                vErrado := vErrado + c_msg.qtde;
                vAuxiliarT1 := 'Codigo de Origem em Branco, Verificar';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vCerto := vCerto + c_msg.qtde;
             End If;

          End Loop;

          -- Procurando se existe alguma destino nulo
          for c_msg in (select x.protocolo,decode(nvl(x.DESTINO,'XXXXXX'),'XXXXXX','NULO','NAONULO') DESTINO, count(*) qtde
                        from tdvadm.v_slf_calcfretekmpreimpcsv X
                        where 0 = 0 --x.protocolo in (pProtocolo)
                          AND X.CONTRATO IS NOT NULL
                          and x.planilha = vArqcsv
                          and x.DESTINO <> 'DESTINO'                        --  and x.DESTINO is null
                        group by x.protocolo,decode(nvl(x.DESTINO,'XXXXXX'),'XXXXXX','NULO','NAONULO'))
          Loop
            
             If c_msg.destino = 'NULO' Then
                pStatus := 'E';
                vErrado := vErrado + c_msg.qtde;
                vAuxiliarT1 := 'Codigo de Destinos em Branco, Verificar';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vCerto := vCerto + c_msg.qtde;
             End If;

          End Loop;

          -- pesquisa se existe algum tipo diferente de CIF e FOB
          for c_msg in (select x.TIPOTAB,X.CARGA,count(*) qtde
                        from tdvadm.v_slf_calcfretekmpreimpcsv X
                        where 0 = 0 --x.protocolo = pProtocolo
                          AND X.CONTRATO IS NOT NULL
                          and x.planilha = vArqcsv
                          and x.TIPOTAB not in ('TIPO','TIPOTAB')
                        group by x.TIPOTAB,X.CARGA)
          Loop
             If c_msg.TIPOTAB = 'AMB' Then
                vTipoTab := 'AMB';
                If vTipoRodando = 'XXX' Then
                   vTipoRodando := 'CIF';
                   c_msg.TIPOTAB := 'CIF';
                Else
                   c_msg.TIPOTAB := vTipoRodando;  
                End If;
             Else
               vTipoRodando := c_msg.TIPOTAB;
             End If;   
                
             If nvl(c_msg.TIPOTAB,'X') not in ('CIF','FOB','AMB') Then
                pStatus := 'E';
                vErrado := vErrado + c_msg.qtde;
                vAuxiliarT1 := 'Tipo de Tabela Errado ou inexistente [' || c_msg.tipotab || '] para Carga [' ||C_MSG.CARGA  || ']';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vCerto := vCerto + c_msg.qtde;
             End If;
            
          End Loop;

          -- Pesquisa de existe algum tipo diferente de Coleta Entrega ou Ambos
          for c_msg in (select x.protocolo,x.colent,x.CARGA,count(*) qtde
                        from tdvadm.v_slf_calcfretekmpreimpcsv X
                        where 0 = 0 --x.protocolo = pProtocolo
                          AND X.CONTRATO IS NOT NULL
                          and x.planilha = vArqcsv
                          and x.CARGA <> 'CARGA'
                        group by x.protocolo,x.colent,x.CARGA)
          Loop

             If nvl(c_msg.colent,'X') not in ('COLETA','ENTREGA','AMBOS') Then
                pStatus := 'E';
                vErrado := vErrado + c_msg.qtde;
                vAuxiliarT1 := 'Indicativo de COLETA/ENTRAGA Errado ou inexistente [' || c_msg.colent || '] para Carga [' ||C_MSG.CARGA  || ']';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vCerto := vCerto + c_msg.qtde;
             End If;
            
          End Loop;

     
          -- Pesquisa se existe algum tipo de Verba Não Cadastrado
          for c_msg in (select x.codverba,X.VERBA verba,COUNT(*) QTDE
                        from tdvadm.v_slf_calcfretekmpreimpcsv X,
                             tdvadm.t_slf_reccust tv
                        where 0 = 0 --x.protocolo = pProtocolo
                          AND X.CONTRATO IS NOT NULL
                          and x.planilha = vArqcsv
                          and x.VERBA <> 'VERBA'
                          and TRIM(nvl(x.codverba,'x')) = TRIM(tv.slf_reccust_codigo(+))
                        GROUP BY x.codverba,X.VERBA)
          Loop
            
             If nvl(c_msg.verba,'X') = 'X' Then
                pStatus := 'E';
                vErrado := vErrado + c_msg.qtde;
                vAuxiliarT1 := 'Codigo de VERBA Errado ou inexistente [' || c_msg.codverba || ']';
                pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
             Else
                vCerto := vCerto + c_msg.qtde;
             End If;

          End Loop;

    --Pegando Duplicidade  

          for c_msg in (select x.ROW_NR,
                               x.TIPOTAB,
                               x.COLENT,
    --                           x.COLENT,
                               x.GRUPO,
                               x.CONTRATO,
                               x.ORIGEM,
                               x.DESTINO,
                               x.OUTRACOL,
                               x.OUTRAENT,
                               x.CARGA,
                               x.VEICULO,
                               x.VERBA,
                               x.PESODE,
                               x.PESOATE,
                               x.KMDE,
                               x.KMATE,
                               x.VALOR
                        from tdvadm.v_slf_calcfretekmpreimpcsv x
                        where 0 = 0
                          and (x.protocolo,
                               x.TIPOTAB,
                               x.COLENT,
                               nvl(x.CODCARGA,'XX'),
                               nvl(x.CODVEICULO,'XX'),
                               x.kmde,
                               x.kmate,
                               x.pesode,
                               x.pesoate,
                               x.CODVERBA,
                               x.ORIGEM,
                               x.destino,
                               x.OUTRACOL,
                               x.OUTRAENT) in (select x1.protocolo, 
                                                     x1.TIPOTAB,
                                                     x1.COLENT,
                                                     nvl(x1.CODCARGA,'XX'),
                                                     nvl(x1.CODVEICULO,'XX'),
                                                     x1.kmde,
                                                     x1.kmate,
                                                     x1.pesode,
                                                     x1.pesoate,
                                                     x1.CODVERBA,
                                                     x1.ORIGEM,
                                                     x1.destino,
                                                     x1.OUTRACOL,
                                                     x1.OUTRAENT
                                              from  tdvadm.v_slf_calcfretekmpreimpcsv x1
                                              where 0 = 0 --x1.protocolo = pProtocolo
                                                AND X1.CONTRATO IS NOT NULL
                                                and x1.planilha = vArqcsv
                                                AND X1.CARGA <> 'CARGA'
                                              group by x1.protocolo,
                                                       x1.TIPOTAB,
                                                       x1.COLENT,
                                                       nvl(x1.CODCARGA,'XX'),
                                                       nvl(x1.CODVEICULO,'XX'),
                                                       x1.kmde,
                                                       x1.kmate,
                                                       x1.pesode,
                                                       x1.pesoate,
                                                       x1.CODVERBA,
                                                        x1.ORIGEM,
                                                       x1.DESTINO,
                                                       x1.OUTRACOL,
                                                       x1.OUTRAENT
                                              having count(*) > 1)
                        order by x.TIPOTAB,
                                 x.COLENT,
                                 x.COLENT,
                                 x.GRUPO,
                                 x.CONTRATO,
                                 x.ORIGEM,
                                 x.DESTINO,
                                 x.OUTRACOL,
                                 x.OUTRAENT,
                                 x.CARGA,
                                 x.VEICULO,
                                 x.VERBA,
                                 x.PESODE,
                                 x.PESOATE,
                                 x.KMDE,
                                 x.KMATE,
                                 x.VALOR)
          Loop

             pStatus := 'E';
             vAuxiliarT1 := 'Linha da Planilha com Registro DUPLICADO [' || to_char(c_msg.ROW_NR) || ']';
             pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
                
          End Loop;
      
          If pStatus = 'N' Then
          
              Begin
                  -- Tabela usada para mostrar cargas e veiculos na WEB 
                  -- insert into tdvadm.t_arm_coletacargaveiculo              
            
                  -- Insere os Registros de Regra de Veiculo
                  insert into tdvadm.t_slf_cliregrasveic
                  select distinct x.grupo ,
                         x.cliente,
                         x.contrato,
                         rpad(x.codveiculo,3) codveiculo,
                         tv.fcf_tpveiculo_descricao veiculo,
                         rpad(x.codcarga,3) codcarga,
                         tc.fcf_tpcarga_descricao carga,
                         x.VIGENCIA,
                         'S' ativo,
                         decode(trim(x.codveiculo),'9',0,x.PESODE) PESODE,
                         decode(trim(x.codveiculo),'9',99999,x.PESOATE) PESOATE,
                         'S',
                         'S'
                  from tdvadm.v_slf_calcfretekmpreimpcsv x,
                       tdvadm.t_fcf_tpveiculo tv,
                       tdvadm.t_fcf_tpcarga tc
                  where 0 = 0 --x.protocolo = pProtocolo
                    AND X.CONTRATO IS NOT NULL
                    and x.planilha = vArqcsv
                    and x.carga <> 'CARGA'
                    and rpad(x.codveiculo,3) = tv.fcf_tpveiculo_codigo (+)
                    and rpad(x.codcarga,3) = tc.fcf_tpcarga_codigo (+)
                    and 0 = (select count(*) 
                             from tdvadm.t_slf_cliregrasveic X
                             where x.glb_grupoeconomico_codigo = rpad(x.grupo,4) 
                               and x.glb_cliente_cgccpfcodigo = rpad(x.cliente,20)
                               and x.slf_contrato_codigo = trim(x.contrato)
                               and x.fcf_tpcarga_codigo = rpad(x.codcarga,3)
                               and x.fcf_tpveiculo_codigo = rpad(x.codveiculo,3))
                  order by 1,2,3,7,10;
                  vAuxiliar :=  sql%rowcount;
            exception
              When OTHERS Then
                 pStatus := 'E';
                 vAuxiliarT1 := 'Erro Incluindo Veiculos para o Contrato';
                 pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
                 pMessage := pMessage || tdvadm.pkg_glb_html.fn_AbreLista;
                 pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(sqlerrm);
                 pMessage := pMessage || tdvadm.pkg_glb_html.fn_FechaLista;
              End;
          End If;
         


          If pStatus = 'N' Then
          
             Begin

/* ver como vai ficar com a divisao das tabelas.
    
           insert into tdvadm.t_slf_clientecargas cc
                select X.grupo     GLB_GRUPOECONOMICO_CODIGO,
                       X.cliente   GLB_CLIENTE_CGCCPFCODIGO,
                       X.codcarga  FCF_TPCARGA_CODIGO,
                       X.contrato  SLF_CONTRATO_CODIGO,
                       null        SLF_CLIENTECARGAS_PROCEDURE,  
                       rownum      SLF_CLIENTECARGAS_SEQEXEC,
                       'S'         SLF_CLIENTECARGAS_AGCTRC,
                       50          SLF_CLIENTECARGAS_QTDECTRC,
                       'S'         SLF_CLIENTECARGAS_AGNF,
                       50          SLF_CLIENTECARGAS_QTDENF,
                       'PR'        SLF_CLIENTECARGAS_PCOBRANCA,  
                       0           SLF_CLIENTECARGAS_BASEOCUPACAO,  
                       0           SLF_CLIENTECARGAS_VALORBASE,
                       0           SLF_CLIENTECARGAS_PMINIMO,
                       'S'         SLF_CLIENTECARGAS_RATEIA,
                       '01'        SLF_TPRATEIO_CODIGO,
                       'N'         SLF_CLIENTECARGAS_QPCOLCTRC,
                       'N'         SLF_CLIENTECARGAS_QPCOLNF,
                       x.tipofrete SLF_TPFRETE_CODIGO,
                       'N'         SLF_CLIENTECARGAS_PRIOREXQM,  
                       0           SLF_CLIENTECARGAS_PERCNTEX,
                       0           SLF_CLIENTECARGAS_PERCNTQM,
                       0           SLF_CLIENTECARGAS_PERCNTOUT,
                       0           SLF_CLIENTECARGAS_PERCNTTRA,
                       'ROUND(((((((<<D_FRPSVO>> * <<V_FTRATEIO>>) * <<V_PERCTQ>>) * <<V_PERCTE>>) * <<V_PERCTT>>) * <<V_PERCTO>>) * <<V_PERCTR>>),2)'        SLF_CLIENTECARGAS_FORMULAFRTX,  
                       'ROUND(((((((<<D_FRPSVO>> * <<V_FTRATEIO>>) * <<V_PERCTQ>>) * <<V_PERCTE>>) * <<V_PERCTT>>) * <<V_PERCTO>>) * <<V_PERCTR>>),2)'        SLF_CLIENTECARGAS_FORMULAFRTVL,  
                       'ROUND((<<D_PD>> * <<V_FTRATEIO>>),2)'        SLF_CLIENTECARGAS_FORMULAPDTX,  
                       'ROUND((<<D_PD>> * <<V_FTRATEIO>>),2)'        SLF_CLIENTECARGAS_FORMULAPDVL,  
                       X.VIGENCIA  SLF_CLIENTECARGAS_VIGENCIA,
                       0           SLF_CLIENTECARGAS_REDUTOR,
                       X.codcarga  FCF_TPCARGA_CODIGOPESQ,    
                       NULL        SLF_CLIENTECARGAS_FIXAORIGEM,  
                       NULL        SLF_CLIENTECARGAS_FIXADESTINO,  
                       'N'         SLF_CLIENTECARGAS_FORMULARIOQM,
                       'N'         SLF_CLIENTECARGAS_FORMULARIOEX,
                       'S'         SLF_CLIENTECARGAS_ATIVO,
                       'N'         SLF_CLIENTECARGAS_SOTRANSF,
                       NULL        SLF_CLIENTECARGAS_TABPED,  
                       0           SLF_CLIENTECARGAS_KMMINIMO,
                       'N'         SLF_CLIENTECARGAS_COBRACOLETA,
                       '00'        SLF_CLIENTECARGAS_FORCOBCOLETA,
                       NULL        SLF_TPFRETE_CODIGOCOL,  
                       NULL        FCF_TPCARGA_CODIGOCOL,  
                       'N'         SLF_CLIENTECARGAS_AGRPORCOLETA,
                       X.temveic   SLF_CLIENTECARGAS_USAVEICULO,
                       'C'         SLF_CLIENTECARGAS_PESQVEICULO,
                       0           SLF_CLIENTECARGAS_LIMITECTE,
                       0           SLF_CLIENTECARGAS_LIMITENFSE,
                       NULL        SLF_CLIENTECARGAS_TABKM,  
                       X.Faixakm   SLF_CLIENTECARGAS_USAFAIXAKM,
                       X.Faixapeso SLF_CLIENTECARGAS_USAFAIXAPESO,
                       'N'         SLF_CLIENTECARGAS_USAFAIXAVG,
                       'N'         SLF_CLIENTECARGAS_USAFAIXAKMC,
                       'N'         SLF_CLIENTECARGAS_USAFAIXAPSOC,
                       'N'         SLF_CLIENTECARGAS_USAFAIXAVGC,
                       'ROUND((((((((<<D_FRPSVO>> * <<S_KMPER>>) * <<V_FTRATEIO>>) * <<V_PERCTQ>>) * <<V_PERCTE>>) * <<V_PERCTT>>) * <<V_PERCTO>>) * <<V_PERCTR>>),2)'        SLF_CLIENTECARGAS_FORMULAFRTKM,  
                       'N'         SLF_CLIENTECARGAS_USAVEICULOC,  
                       'C'         SLF_CLIENTECARGAS_PESQVEICULOC,
                       'N'         SLF_CLIENTECARGAS_GLOBALIZADO,
                       'N'         SLF_CLIENTECARGAS_CTEDECOLETA,
                       'ROUND(((((((<<D_FRPSVO>> * <<V_FTRATEIO>>) * <<V_PERCTQ>>) * <<V_PERCTE>>) * <<V_PERCTT>>) * <<V_PERCTO>>) * <<V_PERCTR>>),2)'        SLF_CLIENTECARGAS_FORMULACOLTX,  
                       'ROUND(((((((<<D_FRPSVO>> * <<V_FTRATEIO>>) * <<V_PERCTQ>>) * <<V_PERCTE>>) * <<V_PERCTT>>) * <<V_PERCTO>>) * <<V_PERCTR>>),2)'        SLF_CLIENTECARGAS_FORMULACOLVL,  
                       'ROUND((((((((<<D_FRPSVO>> * <<S_KMCOL>>) * <<V_FTRATEIO>>) * <<V_PERCTQ>>) * <<V_PERCTE>>) * <<V_PERCTT>>) * <<V_PERCTO>>) * <<V_PERCTR>>),2)'        SLF_CLIENTECARGAS_FORMULACOLKM,  
                       'S'         SLF_CLIENTECARGAS_CRIACOLFIFO,
                       'S'         SLF_CLIENTECARGAS_FIMDIGITNOTA,
                       1           SLF_CLIENTECARGAS_QTDENOTACOL,
                       0           SLF_CLIENTECARGAS_PESAGEMMAX,
                       '01'        SLF_TPAGRUPA_CODIGO,
                       'N'         SLF_CLIENTECARGAS_MUDAORIGEMCC,
                       'S'         SLF_CLIENTECARGAS_PARASEMPCC,
                       'N'         SLF_CLIENTECARGAS_VALEPED,
                       sysdate     SLF_CLIENTECARGAS_DTCADASTRO
                from tdvadm.v_slf_verificaregracsv X
                where 0 = 0 --x.protocolo = pProtocolo
                  and x.grupo <> '0020'
                  and 0 = (select count(*)
                           from tdvadm.v_slf_clientecargas_tra c
                           where c.Grupo = x.grupo
                             and c.cnpj = rpad(x.cliente,20)
                             and trim(c.contrato) = trim(x.contrato)
                             and rpad(substr(c.TpcargaPesq,1,2),3) = rpad(x.codcarga,3)  
                             and c.tporigem = x.codtporigem
                             and c.tpdestino = x.codtpdestino
                             and c.usaveiculo = x.temveic
                             );
*/
                 vAuxiliar :=  sql%rowcount; 
                 
                 If vAuxiliar > 0 Then
                     for c_msg in (select x.grupo,
                                          x.cliente,
                                          x.contrato,
                                          x.codcarga,
                                          x.codtporigem,
                                          x.codtpdestino,
                                          x.temveic,
                                          count(*) qtde
                                     from tdvadm.v_slf_verificaregracsv X
                                     where x.planilha = vArqcsv
                                     and x.contrato <> 'CONTRATO'
                                     group by x.grupo,
                                              x.cliente,
                                              x.contrato,
                                              x.codcarga,
                                              x.codtporigem,
                                              x.codtpdestino,
                                              x.temveic)
                    Loop
                      select count(distinct c.slf_tpagrupa_codigo)
                        into vAuxiliar
                      from tdvadm.t_slf_clientecargas c
                      where c.glb_grupoeconomico_codigo = lpad(c_msg.grupo,4,'0')
                        and c.glb_cliente_cgccpfcodigo = rpad(c_msg.cliente,20)
                        and trim(c.slf_contrato_codigo) = trim(c_msg.contrato)
                        and c.fcf_tpcarga_codigo <> '20'
                        and c.slf_clientecargas_ativo = 'S'
                        --01/11/2021
                        -- Controle da vigencia para apurar os agrupamentos
                        -- Sirlano / Alison
                        and c.slf_clientecargas_vigencia = (select max(c1.slf_clientecargas_vigencia)
                                                            from tdvadm.t_slf_clientecargas c1
                                                            where c1.glb_grupoeconomico_codigo = c.glb_grupoeconomico_codigo
                                                              and c1.glb_cliente_cgccpfcodigo = c.glb_cliente_cgccpfcodigo
                                                              and c1.slf_contrato_codigo = c.slf_contrato_codigo
                                                              and c1.fcf_tpcarga_codigo <> '20'
                                                              and c1.slf_clientecargas_ativo = 'S');
                        -- Colocando para ate dois agrupamentos por contrato
                        -- 28/10/2021 Sirlano
                        -- Devido a BIO-SERVICE ter mais de um agrupamento por contrato
                        
                      If vAuxiliar > 5 Then
                         PSTATUS := 'E';
                         VAUXILIART1 := 'Contrato com mais de 2 tipo de Agrupamento - VERIFICA AS REGAS TIPO DE AGRUPAMENTOS DIFERENTE ';
                         PMESSAGE := PMESSAGE || TDVADM.PKG_GLB_HTML.FN_ITENSLISTA(VAUXILIART1);
                      End If;
                    End Loop;  
                 End If;

             exception
               When OTHERS Then
                  pStatus := 'E';
                  vAuxiliarT1 := 'Erro Incluindo Regras para o Contrato';
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_AbreLista;
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(sqlerrm);
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_FechaLista;
             End;
          End If;
     

          If pStatus = 'N' Then
          
             Begin

                  -- INSERINDO PELA REGRA 
                  insert into tdvadm.t_glb_clientecontrato
                  select distinct x.CLIENTE,
                         x.CONTRATO,
                         'S',
                         sysdate,
                         'jsantos'
                  from tdvadm.v_slf_calcfretekmpreimpcsv x
                  where 0 = 0 --x.protocolo = pProtocolo
                    AND X.CONTRATO IS NOT NULL
                    and x.planilha = vArqcsv
                    and x.carga <> 'CARGA'
                    AND X.cliente <> '99999999999999'
                    and 0 = (select count(*)
                             from tdvadm.t_glb_clientecontrato cc
                             where cc.glb_cliente_cgccpfcodigo = rpad(x.CLIENTE,20)
                               and cc.slf_contrato_codigo = x.CONTRATO);

                  vAuxiliar :=  sql%rowcount; 

             exception
               When OTHERS Then
                  pStatus := 'E';
                  vAuxiliarT1 := 'Erro Incluindo Contrato DEFAULT para CLiente';
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_AbreLista;
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(sqlerrm);
                  pMessage := pMessage || tdvadm.pkg_glb_html.fn_FechaLista;
             End;
          End If;
       End If;
       
       If pStatus = 'N' Then
          vAuxiliarT1 := 'Processo Concluido com Sucesso';
       Else
          vAuxiliarT1 := 'Processo Concluido com ERRO';
       End If;  

       pMessage := pMessage || tdvadm.pkg_glb_html.fn_ItensLista(vAuxiliarT1);
       pMessage := pMessage || tdvadm.pkg_glb_html.fn_FechaLista;
       pMessage := pMessage || tdvadm.pkg_glb_html.PulaLinha;
    
       
      
      If pStatus = 'N' Then
         pkg_slf_tabelas.SP_LISTAREGRACONTRATO(vContrato,
                                               vStatus,
                                               vMessage);
                                               
          pMessage := pMessage || vMessage;
      End If;    
      
      
      
      wservice.pkg_glb_email.SP_ENVIAEMAIL('MSG=PROCINCTAB;PROTOCOLO=' || pProtocolo ,
                                           pMessage,
                                           'aut-e@dellavolpe.com.br',
                                           vEmail,
                                           'sdrumond@dellavolpe.com.br');


-------------------------- FIM DO PROCESSO ----------------------------

      
    End SP_CRITICAPLANILHA;
  function fi_verifica_carga(pTabela tdvadm.t_slf_tabela.slf_tabela_codigo%type,
                             pSaque  tdvadm.t_slf_tabela.slf_tabela_saque%type,
                             vReccust tdvadm.t_slf_reccust.slf_reccust_codigo%type,
                             vPercent number) return number
   As
    vCarga tdvadm.t_slf_tabela.fcf_tpcarga_codigo%type;
  Begin
     select ta.fcf_tpcarga_codigo
       into vCarga
     from tdvadm.t_slf_tabela ta
     where ta.slf_tabela_codigo = pTabela
       and ta.slf_tabela_saque = pSaque;  
     
     If vReccust = 'D_PD' and vCarga in ('01','11') Then
        return 1;
     End If;
         
     If vReccust in ('D_FRPSVO','D_PD') Then
        return vPercent;
     End If;

     return 1;
     
  
  End fi_verifica_carga; 
    
  
  function fi_verifica_carga(pTabela tdvadm.t_slf_tabela.slf_tabela_codigo%type,
                             pSaque  tdvadm.t_slf_tabela.slf_tabela_saque%type,
                             pReccust tdvadm.t_slf_reccust.slf_reccust_codigo%type,
                             pVerbas  varchar2,
                             pPercent number) return number
   As
--    vCarga tdvadm.t_slf_tabela.fcf_tpcarga_codigo%type;
  Begin

--     select ta.fcf_tpcarga_codigo
--       into vCarga
--     from tdvadm.t_slf_tabela ta
--     where ta.slf_tabela_codigo = pTabela
--       and ta.slf_tabela_saque = pSaque;  
     
--     If pReccust = 'D_PD' and vCarga in ('01','11') Then
--        return 1;
--     End If;
         
     If instr(pReccust,pVerbas) > 0 Then
        return pPercent;
     End If;

     return 1;
  
  End fi_verifica_carga; 
  
  Procedure sp_reajustaTABKM(pContrato      in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                             pPercent       in number, -- numero inteiro
                             pVigencia      in char,   -- a partir de quando sera o reajuste
                             pListaTAB      in varchar2 default 'TODAS', -- EXEMPLO => 94846;847465;848464.484746
                             pListaCargas   in varchar2 default 'TODAS', -- Lista das cargas a serem reajustadas Exemplo => 02;11;12
                             pReajustaFRETE in char default 'S',
                             pReajustaPED   in char default 'S',
                             pReajustaDESP  in char default 'S')
As                                

 
  i        integer;
  vPercent number;
  vSaque   tdvadm.t_slf_tabela.slf_tabela_saque%type;
  vModeloTAB char(1) := 'N';  
  vProcessa     char(1);
begin

  vPercent := 1 + (pPercent / 100);
  
  for c_msg in (select distinct ta.slf_tabela_codigo,
                       ta.slf_tabela_codigo tab2
                from tdvadm.t_slf_tabela ta
                where ta.slf_tabela_contrato = pContrato 
                  and nvl(ta.slf_tabela_status,'N') <> 'S'
--                  AND TA.SLF_TABELA_CODIGO = '02102266'
                  and 0 < (select count(*) 
                           from tdvadm.t_slf_calcfretekm km 
                           where km.slf_tabela_codigo = ta.slf_tabela_codigo 
                             and km.slf_tabela_saque = ta.slf_tabela_saque)
                  and decode(nvl(pListaCargas,'TODAS'),'TODAS',1,instr(pListaCargas,trim(ta.fcf_tpcarga_codigo))) > 0)
  Loop      
      
       select max(ta.slf_tabela_saque) 
          into vSaque
       from tdvadm.t_slf_tabela ta
       where ta.slf_tabela_codigo = c_msg.slf_tabela_codigo;
       
       If substr(c_msg.slf_tabela_codigo,1,3) = '021' Then
           vModeloTAB := 'N'; -- Modelo Novo
       Else
           vModeloTAB := 'V'; -- Modelo Velho
       end If; 
       
       vProcessa := 'N';
       If nvl(pListaTAB,'TODAS') = 'TODAS' Then
          vProcessa := 'S';
       Else
          If instr(pListaTAB,c_msg.tab2) > 0  Then
             vProcessa := 'S';
          End If;
       End If;
                    
       If vProcessa = 'S' Then
         
            insert into tdvadm.t_slf_tabela
              select ta.SLF_TABELA_CODIGO,
                     ta.GLB_ROTA_CODIGO,
                     lpad(vSaque + 1,4,'0') SLF_TABELA_SAQUE,
                     ta.GLB_CONDPAG_CODIGO,
                     ta.SLF_TABELA_TIPO,
                     ta.GLB_CLIENTE_CGCCPFCODIGO,
                     ta.GLB_MERCADORIA_CODIGO,
                     pVigencia SLF_TABELA_VIGENCIA,
                     ta.GLB_EMBALAGEM_CODIGO,
                     sysdate,
                     ta.GLB_TPCARGA_CODIGO,
                     ta.GLB_LOCALIDADE_CODIGO,
                     ta.SLF_TABELA_CONTATO,
                     ta.SLF_TABELA_OBSTABELA,
                     ta.GLB_VENDFRETE_CODIGO,
                     ta.SLF_TABELA_OBSFATURAMENTO,
                     ta.SLF_TABELA_LOTACAOFLAG,
                     ta.SLF_TABELA_ISENTO,
                     ta.SLF_TABELA_DESCRICAO,
                     ta.SLF_TPCALCULO_CODIGO,
                     ta.SLF_TABELA_PEDREAJAUT,
                     ta.SLF_TABELA_PEDATUALIZA,
                     ta.SLF_TABELA_ORIGEMDESTINO,
                     ta.SLF_TABELA_STATUS,
                     ta.SLF_TABELA_VIAGEMMIN,
                     ta.SLF_TABELA_VIAGEMMAX,
                     ta.SLF_TABELA_VIAGEMIDENT,
                     ta.CON_FCOBPED_CODIGO,
                     ta.CON_MODALIDADEPED_CODIGO,
                     ta.SLF_TABELA_TPDESCONTO,
                     ta.SLF_TABELA_DESCONTO,
                     ta.SLF_TABELA_PERCLOTACAO,
                     ta.SLF_TABELA_MSGLOTACAO,
                     ta.SLF_TABELA_ABORTALOTACAO,
                     ta.SLF_TABELA_PESOMINIMO,
                     ta.SLF_TABELA_PESOMAXIMO,
                     ta.SLF_TABELA_OCUPACAO,
                     ta.SLF_TABELA_BASEOCUPACAO,
                     ta.SLF_TABELA_CONTRATO,
                     ta.SLF_TABELA_COMISSIONADO,
                     ta.FCF_TPVEICULO_CODIGO,
                     ta.FCF_TPCARGA_CODIGO,
                     ta.GLB_GRUPOECONOMICO_CODIGO,
                     ta.SLF_TABELA_IMPRIMEOBSCTRC,
                     ta.SLF_TABELA_IMPRIMEOBSVENC,
                     ta.SLF_TABELA_COLETAENTREGA
              from tdvadm.t_slf_tabela ta
              where ta.slf_tabela_codigo = c_msg.slf_tabela_codigo
                and ta.slf_tabela_saque = vSaque
                and nvl(ta.slf_tabela_status,'N') <> 'S'
                and decode(nvl(pListaCargas,'TODAS'),'TODAS',1,instr(pListaCargas,trim(ta.fcf_tpcarga_codigo))) > 0;
                i := sql%rowcount;  
                commit;

              If vModeloTAB = 'N' then
                  insert into tdvadm.t_slf_calcfretekm
                  select km.SLF_TABELA_CODIGO,
                         lpad(vSaque + 1,4,'0') SLF_TABELA_SAQUE,
                         km.SLF_CALCFRETEKM_KMDE,
                         km.SLF_CALCFRETEKM_KMATE,
                         km.SLF_CALCFRETEKM_PESODE,
                         km.SLF_CALCFRETEKM_PESOATE,
                         km.SLF_TPCALCULO_CODIGO,
                         km.SLF_RECCUST_CODIGO,
                         round(km.SLF_CALCFRETEKM_VALOR * decode(trim(km.slf_reccust_codigo),'D_FRPSVO',decode(pReajustaFRETE,'S',vPercent,1),
                                                                                             'D_DP'    ,decode(pReajustaPED,'S',vPercent,1),
                                                                                             'D_PD'    ,decode(pReajustaDESP,'S',vPercent,1), 1),2) SLF_CALCFRETEKM_VALOR,
                         km.SLF_CALCFRETEKM_DESINENCIA,
                         km.SLF_CALCFRETEKM_CODCLI,
                         km.SLF_CALCFRETEKM_TPFRETE,
                         km.SLF_CALCFRETEKM_ORIGEM,
                         km.SLF_CALCFRETEKM_DESTINO,
                         km.SLF_CALCFRETEKM_ORIGEMI,
                         km.SLF_CALCFRETEKM_DESTINOI,
                         km.SLF_CALCFRETEKM_LIMITE,
                         km.SLF_CALCFRETEKM_VALORE,
                         km.SLF_CALCFRETEKM_DESINENCIAE,
                         km.SLF_CALCFRETEKM_VALORF,
                         km.SLF_CALCFRETEKM_DESINENCIAF,
                         km.SLF_CALCFRETEKM_RAIOKMORIGEM,
                         km.SLF_CALCFRETEKM_RAIOKMDESTINO,
                         km.SLF_CALCFRETEKM_IMPEMBUTIDO,
                         km.SLF_CALCFRETEKM_OUTRACOLETAI,
                         km.SLF_CALCFRETEKM_OUTRAENTREGAI,
                         sysdate
                  from tdvadm.t_slf_calcfretekm km                             
                  where (km.slf_tabela_codigo,
                         km.slf_tabela_saque) in (select ta.slf_tabela_codigo,
                                                         ta.slf_tabela_saque
                                                  from tdvadm.t_slf_tabela ta
                                                  where ta.slf_tabela_codigo = c_msg.slf_tabela_codigo
                                                    and nvl(ta.slf_tabela_status,'N') <> 'S'
                                                    and decode(nvl(pListaCargas,'TODAS'),'TODAS',1,instr(pListaCargas,trim(ta.fcf_tpcarga_codigo))) > 0
                                                    and ta.slf_tabela_vigencia < pVigencia
                                                    and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                                                               from tdvadm.t_slf_tabela ta1
                                                                               where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                                                 and ta1.slf_tabela_vigencia < pVigencia
                                                                                 and nvl(ta1.slf_tabela_status,'N') <> 'S'));
                i := sql%rowcount;  
              Else
                  insert into tdvadm.t_slf_calctabela
                  select tab.slf_tabela_codigo,
                         lpad(vSaque + 1,4,'0') SLF_TABELA_SAQUE,
                         tab.glb_localidade_codigo,
                         tab.slf_tpcalculo_codigo,
                         tab.slf_reccust_codigo,
                         tab.glb_moeda_codigo,
                         tab.slf_calctabela_desinecia,
                         round(tab.slf_calctabela_valor * decode(trim(tab.slf_reccust_codigo),'D_FRPSVO',decode(pReajustaFRETE,'S',vPercent,1),
                                                                                              'D_DP'    ,decode(pReajustaPED,'S',vPercent,1),
                                                                                              'D_PD'    ,decode(pReajustaDESP,'S',vPercent,1), 1),2) slf_calctabela_valor ,
                         tab.slf_calctabela_reembolso
                  from tdvadm.t_slf_calctabela tab                             
                  where (tab.slf_tabela_codigo,
                         tab.slf_tabela_saque) in (select ta.slf_tabela_codigo,
                                                          ta.slf_tabela_saque
                                                   from tdvadm.t_slf_tabela ta
                                                   where ta.slf_tabela_codigo = c_msg.slf_tabela_codigo
                                                     and nvl(ta.slf_tabela_status,'N') <> 'S'
                                                     and decode(nvl(pListaCargas,'TODAS'),'TODAS',1,instr(pListaCargas,trim(ta.fcf_tpcarga_codigo))) > 0
                                                     and ta.slf_tabela_vigencia < pVigencia
                                                     and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                                                                from tdvadm.t_slf_tabela ta1
                                                                                where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                                                  and nvl(ta1.slf_tabela_status,'N') <> 'S'
                                                                                  and ta1.slf_tabela_vigencia < pVigencia));
              
                i := sql%rowcount;  
              End if;
              
        End If;
   End Loop;
   
   -- Atualizando os Pedagios
   -- Quando existir na tabela
   -- 28/11/2021
   insert into tdvadm.t_slf_clienteped 
   select cp.glb_grupoeconomico_codigo,
          cp.glb_cliente_cgccpfcodigo,
          cp.fcf_tpcarga_codigo,
          cp.slf_contrato_codigo,
          pVigencia slf_clienteped_vigencia,
          cp.slf_clienteped_ativo,
          cp.fcf_tpveiculo_codigo,
          cp.glb_localidade_codigoori,
          cp.glb_localidade_codigodes,
          cp.glb_localidade_codigooriib,
          cp.glb_localidade_codigodesib,
          cp.slf_clienteped_valor * decode(pReajustaPED,'S',vPercent,1) slf_clienteped_valor, 
          cp.slf_clienteped_desinencia,
          cp.slf_clienteped_codcli,
          cp.glb_localidade_outracoletai,
          cp.glb_localidade_outraentregai
   from tdvadm.t_slf_clienteped cp
   where cp.slf_contrato_codigo = pContrato
     and decode(nvl(pListaCargas,'TODAS'),'TODAS',1,instr(pListaCargas,trim(cp.fcf_tpcarga_codigo))) > 0
     and cp.slf_clienteped_vigencia = (select max(cp1.slf_clienteped_vigencia)
                                       from tdvadm.t_slf_clienteped cp1
                                       where cp1.slf_contrato_codigo       = cp.slf_contrato_codigo
                                         and cp1.glb_grupoeconomico_codigo = cp.glb_grupoeconomico_codigo
                                         and cp1.glb_cliente_cgccpfcodigo  = cp.glb_cliente_cgccpfcodigo
                                         and cp1.fcf_tpcarga_codigo        = cp.fcf_tpcarga_codigo)
     and 0 = (select count(*)
              from tdvadm.t_slf_clienteped cp1
              where cp1.slf_contrato_codigo        = cp.slf_contrato_codigo
                and cp1.glb_grupoeconomico_codigo  = cp.glb_grupoeconomico_codigo
                and cp1.glb_cliente_cgccpfcodigo   = cp.glb_cliente_cgccpfcodigo
                and cp1.fcf_tpcarga_codigo         = cp.fcf_tpcarga_codigo
                and cp1.slf_clienteped_vigencia    = cp.slf_clienteped_vigencia
                and cp1.fcf_tpveiculo_codigo       = cp.fcf_tpveiculo_codigo
                and cp1.glb_localidade_codigoori   = cp.glb_localidade_codigoori
                and cp1.glb_localidade_codigodes   = cp.glb_localidade_codigodes
                and cp1.glb_localidade_codigooriib = cp.glb_localidade_codigooriib
                and cp1.glb_localidade_codigodesib = cp.glb_localidade_codigodesib);                                         

   
   
   
end sp_reajustaTABKM;

  

begin
     execute immediate ( ' ALTER SESSION set NLS_DATE_FORMAT = "DD/MM/YYYY" '   ||
                                          ' NLS_LANGUAGE = AMERICAN '          ||
                                          ' NLS_TERRITORY = AMERICA  '         ||
                                          ' NLS_DUAL_CURRENCY = WE8ISO8859P1 ' ||
                                          ' NLS_NUMERIC_CHARACTERS = ".," ' );


END PKG_SLF_TABELAS;
/
