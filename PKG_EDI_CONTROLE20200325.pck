CREATE OR REPLACE PACKAGE TDVADM.PKG_EDI_CONTROLE IS
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
  STATUS_NORMAL         CONSTANT CHAR(1)      := 'N';
  STATUS_ERRO           CONSTANT CHAR(1)      := 'E';
  
  -- variavel de controle da Aplicação
  vRodandoBenasse   Char(1) := 'N';

 
 /* Typo utilizado como base para utilização dos Paramentros                                                                 */
 Type TpMODELO  is RECORD (CAMPO1         char(10),
                           CAMPO2         number(6));
   
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
END;*/

  procedure spi_ExecutaAutFat(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                              pStatus out char,
                              pMessage out varchar2);

  
  Procedure sp_ExecutaAutFat2(pProtocolo in number);

   
   
-- MSG=PROCESSASAP;ACAO=CRIA;PROTOCOLO=54139;LIMITE=31/01/2015
   procedure spi_CriaFaturaConciliada( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                   pStatus out char,
                                   pMessage out clob);
   
   
   
-- MSG=PROCESSASAP;ACAO=BAIXA;PROTOCOLO=764535;LIMITE=31/01/2015
   procedure spi_BaixaTitulosConciliada( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                         pStatus out char,
                                         pMessage out varchar2);
    
   
   procedure SPI_ConfirmaNotasEmbarcadas( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                          pStatus out char,
                                          pMessage out clob);
                                          
   Procedure sp_altera_pagamentoparacheque(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                          vStatus Out Char,
                                          vMessage Out Varchar2);
                                          
     Procedure sp_arm_reabrirplacamobile(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                          vStatus Out Char,
                                          vMessage Out Varchar2);
                                          
     Procedure sp_arm_ocorestadia(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                  vStatus Out Char,
                                  vMessage Out Varchar2);
                                  
     Procedure sp_con_geraanulador(P_PROTOCOLO in varchar2,
                                   pStatus Out Char,
                                   pMessage out clob);
                                   
     Procedure sp_con_gerasubst(P_PROTOCOLO in varchar2,
                                pStatus Out Char,
                                pMessage out clob);
                                  
  procedure sp_enviasemparar(TpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                                      pStatus Out Char,
                                                      pMessage out clob);
                                          
   procedure sp_transfctemanual(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,

                                                      vStatus Out Char,
                                                      pMessage out varchar2);                                                                                                     

  Procedure SPi_INC_ACELORMITTAL(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                 pStatus out char,
                                 pMessage out varchar2,
                                 pChave in varchar2 default null);

   
   Procedure spi_Set_CustoFrota(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                vStatus Out Char,
                                vMessage Out clob);

   Procedure spi_processa_NOTATCN(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                  vStatus Out Char,
                                  vMessage Out clob);

   
   Procedure spi_processa_NOTANIQUEL(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                     vStatus Out Char,
                                     vMessage Out clob);

   Procedure SP_GLB_INCBENASSEREC2(P_XMLIN in clob,
                                   P_XMLIN2 in clob);  
                                   
   procedure sp_uti_rodou_aute(pTipo in char);                                

    Procedure SP_GLB_INCBENASSEREC(P_XMLIN in clob/*,
                                   P_STATUS out char,
                                   P_MESSAGE out varchar2*/);
            
    Procedure sp_bi_glb_processa(vSql in varchar2);
                          
    Procedure SP_BI_GLB_BENASSEREC ;  

    Procedure SP_BI_GLB_BENASSERECNIQUEL ;  

    Procedure SP_BI_GLB_BENASSERECCARVAO ;  
                              

END PKG_EDI_CONTROLE;

 
/
CREATE OR REPLACE PACKAGE BODY TDVADM.PKG_EDI_CONTROLE AS

    procedure sp_Envia_TORPEDO(pTelefone in char,
                               pMensagem in char)
      
    As
    Begin

       wservice.pkg_glb_email.SP_ENVIAEMAIL(pTelefone || ';' || pMensagem,
                                            'nada',
                                            'aut-e@dellavolpe.com.br',
                                            'enviasms@dellavolpe.com.br');

      
    End sp_Envia_TORPEDO;

    procedure sp_verifica_TORVERIFICA(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                      tpTorpedoCfg  Out tdvadm.t_edi_torpedocfg%rowtype,
                                      tpTorpedoResp Out tdvadm.t_edi_torpedoresp%rowtype,
                                      vAchouNumero Out char)
     As
       vContador Number; -- Auxiliar
     Begin

        Begin 
            select *
              into tpTorpedoCfg
            from tdvadm.t_edi_torpedocfg t
            where trim(t.edi_torpedocfg_telefone) = trim(tpRecebido.Glb_Benasserec_Origem);
            vAchouNumero := 'S';
          exception
            When NO_DATA_FOUND Then
                vAchouNumero := 'N';
          End;    
          
          if vAchouNumero = 'S' then
            BEGIN
             select *
               into tpTorpedoResp
             from tdvadm.t_edi_torpedoresp t
             where trim(t.edi_torpedorcfg_telefone) = trim(tpRecebido.Glb_Benasserec_Origem)
               and t.edi_torpedoresp_aguardaresp = 'S' 
              and t.edi_torpedoresp_dtrecebimento is null;
                vContador := 1;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                vContador := 0;
              END ;  
             if vContador > 0 Then
                vAchouNumero := 'R';
             End if;    
          End if;  
          
       
     End sp_verifica_TORVERIFICA;

    procedure sp_verifica_TORCADASTRA(tpRecebido In rmadm.t_glb_benasseREC%Rowtype,
                                      vCadastraResposta in char)
     As
      vContador Number;
    Begin
          -- PERGUNTA QUEM É
          INSERT INTO tdvadm.t_edi_torpedocfg
           (EDI_TORPEDOCFG_TELEFONE,
            EDI_TORPEDOCFG_NOME,
            EDI_TORPEDOCFG_APELIDO,
            EDI_TORPEDOCFG_NOMEPRESP,
            EDI_TORPEDOCFG_EMPRESA,
            EDI_TORPEDOCFG_DEPARTAMENTO,
            EDI_TORPEDOCFG_CADASTRO,
            EDI_TORPEDOCFG_VALIDADE,
            EDI_TORPEDOCFG_ATIVO,
            EDI_TORPEDOCFG_RECEBEENVIA)
          Values
           (trim(tpRecebido.Glb_Benasserec_Origem),
            'NAO SEI',
            'NAO SEI',
            'NAO SEI',
            'NAO SEI',
            'NAO SEI',
            DEFAULT,
            sysdate + 1,
            DEFAULT,
            DEFAULT);
            
           if vCadastraResposta = 'S' Then
                  
               BEGIN
                 select max(EDI_TORPEDORESP_SEQ) 
                   into vContador
                 from tdvadm.t_edi_torpedoresp 
                 where EDI_TORPEDORCFG_TELEFONE = trim(tpRecebido.Glb_Benasserec_Origem);
               Exception
                 When NO_DATA_FOUND then
                    vContador := 0;
               end;
                                
               vContador := NVL(vContador,0);  
                            
                            
              INSERT INTO tdvadm.t_edi_torpedoresp
               (EDI_TORPEDORCFG_TELEFONE,
                EDI_TORPEDORESP_SEQ,
                EDI_TORPEDORESP_PERGUNTA,
                EDI_TORPEDORESP_RESPOSTA,
                EDI_TORPEDORESP_AGUARDARESP,
                EDI_TORPEDORESP_RESPESPERADA,
                EDI_TORPEDORESP_DTENVIO,
                EDI_TORPEDORESP_DTRECEBIMENTO)
              Values
               (trim(tpRecebido.Glb_Benasserec_Origem),
               vContador + 1,
               'NAO TE CONHECO QUAL SEU NOME',
               null,
               'S',
               'NOME',
               sysdate,
               null);
               
               sp_Envia_TORPEDO(trim(tpRecebido.Glb_Benasserec_Origem),
                               'NAO TE CONHECO QUAL SEU NOME');
           End If; 
      
    End sp_verifica_TORCADASTRA;

    Procedure SP_Verifica_MsgRetorno(tpRecebido  In Out rmadm.t_glb_benasseREC%Rowtype,
                                     pAnexo      In Varchar2,
                                     pPermiteAnexo in char,
                                     pAutorizado In Char,
                                     pExesso     In Char,
                                     pEnviados   In Number,
                                     pLimite     In Number,
                                     pMsgRet     Out Varchar2)
    As
    Begin

            pMsgRet := 'Seu e-mail Assunto -' || tpRecebido.GLB_BENASSEREC_ASSUNTO || '- , foi recebido.' || Chr(10);
            if pAnexo <> 'N' then
              pMsgRet := pMsgRet || 'Nele continha o Anexo -> ' || tpRecebido.glb_benasserec_fileanexo || chr(10) || chr(10);
              If pAnexo = 'A' Then
                 pMsgRet := pMsgRet || 'Porem foi recusado por conter acentos no nome do Arquivo ' || chr(10) || chr(10);
                 tpRecebido.Glb_Benasserec_Processado := Sysdate;
                 tpRecebido.Glb_Benasserec_Status     := 'ER';
                 tpRecebido.Glb_Benasserec_Obs := pMsgRet   ;
              End If;
            End if;
            
            IF pPermiteAnexo = 'N' and pAnexo = 'A' THEN
              pMsgRet := pMsgRet || 'Voce ' || tpRecebido.Glb_Benasserec_Origem  || ' Não esta autorizado a enviar anexo' || chr(10) ;
              pMsgRet := pMsgRet || ' O ASSUNTO PODE ESTAR ESCRITO ERRADO OU SEU EMAIL NÃO ESTA CADASTRADO' || chr(10) || chr(10);
              pMsgRet := pMsgRet || 'TEMPORARIAMENTE ESTAMOS VALIDANOD SOMENTE O REMETENTE DO EMAIL' || chr(10) || chr(10);
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'ER';
              tpRecebido.Glb_Benasserec_Obs := pMsgRet   ;
            Elsif pAutorizado = 'N' Then  
              pMsgRet := pMsgRet || 'Voce ' || tpRecebido.Glb_Benasserec_Origem  || ' Não esta autorizado a enviar email para este processo' || chr(10) ;
              pMsgRet := pMsgRet || ' O ASSUNTO PODE ESTAR ESCRITO ERRADO OU SEU EMAIL NÃO ESTA CADASTRADO' || chr(10) || chr(10);
              pMsgRet := pMsgRet || 'TEMPORARIAMENTE ESTAMOS VALIDANOD SOMENTE O REMETENTE DO EMAIL' || chr(10) || chr(10);
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'ER';
              tpRecebido.Glb_Benasserec_Obs := pMsgRet   ;
            End if;

            If pExesso = 'S' Then
              pMsgRet := pMsgRet || chr(10) || 'VOCE EXCEDEU O LIMITE DE ENVIO DE EMAILS COM ANEXO' || chr(10);
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'ER';
            Elsif pExesso = 'L' Then
              pMsgRet := pMsgRet || chr(10) || 'VOCE ATINGIU O LIMITE DE ENVIO DE EMAILS COM ANEXO TOTAL ENVIADOS ' || to_char(pLimite) ||  chr(10);
            End If;
               tpRecebido.Glb_Benasserec_Obs := pMsgRet   ;
            
            pMsgRet := pMsgRet || 'VOCE JA ENVIOU ' || to_char(pEnviados) || ' E-MAILS, SEU LIMITE É DE ' || to_char(pLimite) || chr(10) || chr(10);
            pMsgRet := pMsgRet || 'Obrigado.';

      
    End SP_Verifica_MsgRetorno;                                     


    Procedure SP_Verifica_AutorizaAnexo(pRemetente In Varchar2,
                                        pCopia     In Varchar2,
                                        pAssunto   In Varchar2,
                                        pAnexo     In Varchar2,
                                        pAutorizado In Out Char,
                                        pLimite     In Out Char,
                                        pExesso     Out Char,
                                        pEnviados   Out Number) 
                                        
      
    As
    Begin

--       If pAssunto = 'VF026' Then
--          if (instr('tdv.santosfat3@dellavolpe.com.br;tdv.assgeradmin@dellavolpe.com.br',lower(premetente)) > 0) Then
--             pAutorizado := 'S';
--             pLimite   := 100;
--          End If;    
--       Elsif pAssunto = 'MRSCOLETA' Then
--          if (instr('tdv.mrs@dellavolpe.com.br',lower(premetente)) > 0) Then
--             pAutorizado := 'S';
--             pLimite   := 2;
--          End If;    
--       Elsif pAssunto = 'AUTCOLETA' Then
--          if (instr('paparecido@dellavolpe.com.br;bbernardo@dellavolpe.com.br;gmachado@dellavolpe.com.br;lpalmejano@dellavolpe.com.br',lower(premetente)) > 0)  
--           Then
--             pAutorizado := 'S';
--             pLimite   := 1000;
--       End If; 
          
       if INSTR(LOWER(pAssunto), 'produto=quimico') > 0 Then
          if (instr('giulia.bastos@vale.com',lower(premetente)) > 0)  
           Then
             pAutorizado := 'S';
             pLimite   := 1000;
          End If; 
       End If;

/*       Elsif pAssunto = 'CTRCFAT' Then
          if (instr('tdv.cobranca@dellavolpe.com.br;tdv.fatura@dellavolpe.com.br',lower(premetente)) > 0)  
           Then
             pAutorizado := 'S';
             pLimite   := 10;
          End If; 
*/

--       End If;
       
       If pLimite > 0 Then
          Select Count(*)
            Into pEnviados
          From rmadm.t_glb_benasserec br
          Where trunc(br.glb_benasserec_gravacao) = trunc(Sysdate)
            And br.glb_benasserec_fileanexo Is Not Null
            And br.glb_benasserec_origem = premetente
            And br.glb_benasserec_assunto = pAssunto;
       
            If pLimite > pEnviados Then
              pExesso := 'N';
            ElsIf pLimite = pEnviados Then
              pExesso := 'L';
            Else
              pExesso := 'S';
           End If;

       End If;   
      
    End SP_Verifica_AutorizaAnexo;

   Procedure spi_processa_DELETANOTA(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                     vStatus Out Char,
                                     vMessage Out clob)
   As
     vQryString     varchar2(500);
     vContador      number;
     vProcessamento clob;
     vCriticas      clob;
     vMessage2      clob; 
     vParamsEntrada clob;
     vParamsSaida   clob;
     vNota          tdvadm.t_arm_nota.arm_nota_numero%type;
     vSerie         tdvadm.t_arm_nota.arm_nota_serie%type;
     vSequencia     tdvadm.t_arm_nota.arm_nota_sequencia%type;
     vRemetente     tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
     vAuxiliar      Integer;
   Begin 
  --       Exemplo MSG=DELNOTA;NOTA=4612;SERIE=001;REMETENTE=33592510007590
      vStatus := pkg_glb_common.Status_Nomal;
      vMessage := chr(10);
      vParamsEntrada := empty_clob();
      vParamsSaida   := empty_clob();
      vProcessamento := empty_clob();
      vCriticas      := empty_clob();
      vCriticas := '<br>';
      vCriticas := pkg_glb_html.Assinatura;
      vCriticas := pkg_glb_html.fn_Titulo('CRITICAS');
      vCriticas := vCriticas || PKG_GLB_HTML.LinhaH;
      vCriticas := vCriticas || pkg_glb_html.fn_AbreLista;
      vProcessamento := pkg_glb_html.Assinatura;
         
       vQryString := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));

       vNota      := Trim(tdvadm.fn_querystring(vQryString,'NOTA','=',';'));
       vSerie     := Trim(tdvadm.fn_querystring(vQryString,'SERIE','=',';'));
       vRemetente := Trim(tdvadm.fn_querystring(vQryString,'REMETENTE','=',';'));

      -- Verifica se realmente esta autorizado
      select count(*)
         into vContador
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = Trim(tdvadm.fn_querystring(vQryString,'MSG','=',';'))
        and pa.edi_planilhacfg_sistema = Trim(tdvadm.fn_querystring(vQryString,'MSG','=',';'))
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
      -- verifica se pode autorizar                      

      If vContador > 0 Then 
         vStatus     := 'N';
         vMessage    := '';
      Else
         vStatus     := 'E';
         vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Voce Não esta AUTORIZADO');
         tpRecebido.Glb_Benasserec_Processado := Sysdate;
         tpRecebido.Glb_Benasserec_Status     := 'ER';
      End If;



      If vStatus = 'N' Then




       vAuxiliar := nvl(length(trim(nvl(vNota,''))),0);
       if vAuxiliar = 0 Then
          vStatus     := 'E';
          vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Numero da Nota Obrigatorio!');
          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'ER';
       End If;

       vAuxiliar := nvl(length(trim(nvl(vSerie,''))),0);  

       if vAuxiliar = 0 Then
          vStatus     := 'E';
          vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Serie da Nota Obrigatorio!');
          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'ER';
       End If;


      vProcessamento := vProcessamento || '<br/><br />';
      vProcessamento := vProcessamento || pkg_glb_html.fn_Titulo('DELETANDO NOTA ' || vNota);
      vProcessamento := vProcessamento || PKG_GLB_HTML.LinhaH;
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_AbreLista;
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Comando Enviado ' || trim(tpRecebido.Glb_Benasserec_Assunto));
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Recepção do E-mail ' || to_char(tpRecebido.Glb_Benasserec_Gravacao,'dd/mm/yyyy hh24:mi:ss'));
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Lendo Parametros  ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
       
       
      If vStatus = 'N' Then
         Begin
         select max(n.arm_nota_sequencia)
            into vSequencia
         from tdvadm.t_arm_nota n
         where n.arm_nota_numero = vNota
           and trim(n.glb_cliente_cgccpfremetente) = vRemetente
           and to_number(n.arm_nota_serie) = to_number(nvl(vSerie,0));
         exception
           When OTHERS  Then
               vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Nota NAO LOCALIZADA Nr [' || vNota || '] Serie [' || vSerie || ' Remetente [' || vRemetente || ']'  ); 
               vStatus     := 'E';
           End ;
      End If;    
                   
      If vStatus = 'N' Then
         tdvadm.pkg_hd_utilitario.SP_EXCLUI_NOTA_NOVO(vNota,vRemetente,'A',vSequencia,vStatus,vMessage2);             
      End If;
      
      vCriticas := vCriticas || vMessage2;
     End If;
     
     vMessage := vCriticas;

   End spi_processa_DELETANOTA;                                     


   Procedure sp_processa_TRPLSASCAR(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                    vStatus Out Char,
                                    vMessage Out Varchar2)
   As                                    
      vPlacaAtual   char(07);
      vPlacaNova    char(07);
      vEqpto        number;
      vQryString    varchar2(500);

   Begin

            --Exemplo de QryString = MSG=TRPLSASCAR;EQP=200211622316;DE=GPC1933;PARA=ELQ1433;
            
            --Inicializo as variáveis.
            vPlacaAtual := '';
            vPlacaNova  := '';
            vEqpto      := 0;
            vQryString  := '';
            vStatus     := '';
            vMessage    := '';
            
            
            begin

              --Propulo as variáveis, para recuperar os paramentros passados.
              vQryString  := tpRecebido.GLB_BENASSEREC_ASSUNTO;
              vPlacaAtual := tdvadm.fn_querystring(vQryString, 'DE', '=', ';');
              vPlacaNova  := tdvadm.fn_querystring(vQryString, 'PARA', '=', ';');
              vEqpto      := tdvadm.fn_querystring(vQryString, 'EQP', '=', ';');


              --Executo a procedure responsável por realizar as trocas.
              tdvadm.pkg_scr_integracao.SP_SCR_TrocaPlacaEqp(vEqpto,
                                                             vPlacaAtual,
                                                             vPlacaNova,
                                                             vStatus,
                                                             vMessage);
              
              --envio mensagem do resultado da procedude. 
              wservice.pkg_glb_email.SP_ENVIAEMAIL('Operação Automática: "Troca Placa Eqpto. Sascar"',
                                                   vMessage,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   'tdv.trafego@dellavolpe.com.br',
                                                   tpRecebido.glb_benasserec_origem);
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'OK';
            Exception
              when others then
                 vMessage :=  'ERRO DURANTE O PROCESSAMENTO DE TROCA DE PLACA ' || chr(10) ||
                              '********************************************************************' || chr(10) ||
                              sqlerrm || chr(10) ||
                              '********************************************************************' || chr(10);
                 
                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                tpRecebido.Glb_Benasserec_Status     := 'ER';
                tpRecebido.Glb_Benasserec_Obs := vMessage   ;
                
            end;
            
         



       
   End sp_processa_TRPLSASCAR; 
   
   -------------------------------------------------------------------------------------------------------------
   -- Procedure utilizada para devolver lista de Equipamento Sascar                                           --
   -------------------------------------------------------------------------------------------------------------
   procedure spi_get_listaSascar( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                 pStatus out char,
                                 pMessage out varchar2
                               ) is
     vMct tdvadm.t_atr_terminal.atr_terminal_mct%type;    
     
     --Variáveis auxiliares
     vMessage varchar2(5000);
     vListaEqps clob; 
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'ER';
     
     Begin
       --recupero o numero do equipamento caso seja uma consulta especifica
       vMct :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'EQP', '=', ';');
       
       --Executo a função responsável por me trazer a lista de equipamentos e placas de vinculação
       if ( not tdvadm.pkg_scr_integracao.FN_Get_ListaSascar( vMct, vMessage, vListaEqps) ) then
         --caso ocorra algum erro, devolvo a mensagem
         pStatus := 'E';
         pMessage := vMessage;
         return;
       end if;
       
       --envio o e-mail com os dados recuperados.
       wservice.pkg_glb_email.SP_ENVIAEMAIL('Operação Automática: "Lista de Eqpto. Sascar"',
                                             vListaEqps,
                                             'tdv.producao@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem,
                                             'rpaula@dellavolpe.com.br'
                                             );
      --seto os paramentros de saida.
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'OK';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := '';
       
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao recuperar lista de MCT. ' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     
     
   end spi_get_listaSascar;                                                                  
   
   --Procedure utilizada para inserir autorização para fechamento de um carregamento Químico
   Procedure SPI_Set_AutCarregQuimico( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                       pStatus out char,
                                       pMessage out Varchar2
                                      ) As
                                      
     QuimicoNaoPerigoso CONSTANT CHAR(2)      := '03';
     QuimicoPerigoso    CONSTANT CHAR(2)      := '04';
                                           
     --Variável utilizada para recuperar o numero do formulário
     vNumForm tdvadm.t_arm_notafichaemerg.arm_notafichaemerg_codcli%Type;                                      
     
     --variável utilizada para trata a chave 
     vAssunto Varchar2(200);
     
     --variável utilizada para recuperar chave de busca
     vChave tdvadm.t_arm_notafichaemerg.arm_notafichaemerg_codcli%Type;
     
     --Variável de exceção
     vEx_Responsavel exception;
     vEx_Select Exception;
     vEx_Update Exception;
     
     --Variável de controle
     vCount integer;

               
     --Variável utilizada para recuperar número do carregamento.
     vArm_carregamento_codigo tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type;
     
     --Variável utilizada para criar / recuperar mensagens
     vMessage Varchar2(10000);
   Begin
     Begin
     -- VERIFICA SE PODE AUTORIZAR
     select count(*)
         into vCount
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = 'SEMANEXO'
        and pa.edi_planilhacfg_sistema = 'PRDQUIMICO'
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(pTpRecebido.Glb_Benasserec_Origem),lower(pa.edi_planilhaaut_email)) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
      -- verifica se pode autorizar                      
      If vCount = 0 Then 
         raise vEx_Responsavel;
      end if;
       
       --recupero todo conteudo enviado no campo assunto do e-mail.
       vAssunto := pTpRecebido.Glb_Benasserec_Assunto;
       
       --caso não tenha ';' para fechar a string, eu adiciono
       If substr(vAssunto, -1) <> ';' Then
         vAssunto := vAssunto || ';';
       End If;
       
       --recupero apenas o numero do formulário.
       vNumForm := tdvadm.fn_querystring(upper(vAssunto), 'AUTORIZ', '=', ';');
       vChave := tdvadm.fn_querystring(vAssunto, 'ChaveQuimica', '=', ';');
       vArm_carregamento_codigo := tdvadm.fn_querystring(vAssunto, 'idViagem', '=', ';');
       
       --verifico se existe produto quimico registrado na chave recuperada.
       Select Count(*) 
         Into vCount
       From tdvadm.t_arm_notafichaemerg w
       Where w.arm_notafichaemerg_codcli = vChave;
       
       --caso não encontre a ficha de emergencia.
       If ( vCount = 0 ) Then
         vMessage := 'Nao foi encontrado nenhum produto quimico registrado na chave: ' || vChave;
         Raise vEx_Select;
       End If;
       
       if length(trim(vNumForm)) = 0 then
         vMessage := 'FALTA NUMERO DO FORMULARIO DE AUTORIZAÇÃO ' || vChave;
         Raise vEx_Select;
       End If;
         
        
       
       --Carregamento classificado como não perigoso
       If Trim(vNumForm) = 'NP' Then
         Update t_arm_notafichaemerg em
           Set em.arm_notafichaemerg_codcli = '999999',
               em.glb_onuclascli_codigo = QuimicoNaoPerigoso -- Não Perigoso 
         Where em.arm_notafichaemerg_codcli = vChave;
       End If;

       
       
       --Carregamento classificado como perigoso       
       If Trim(vNumForm) != 'NP' Then
         Update t_arm_notafichaemerg em
           Set em.arm_notafichaemerg_codcli = vNumForm,
               em.glb_onuclascli_codigo = QuimicoPerigoso -- Perigoso 
         Where em.arm_notafichaemerg_codcli = vChave;
         
         vChave := vNumForm;

       End If;
       --Libero carregamento para que possa ser fechado.
        Update T_ARM_CARREGSTATUS W
          Set w.glb_status_codigoproc = '00' 
        Where w.glb_processo_codigo = '004'
         And w.arm_carregamento_codigo = vArm_carregamento_codigo;

        if sql%rowcount = 0 Then 
           vMessage := 'Carregamento ' || vArm_carregamento_codigo || ' Nao estava travado para produto quimico registrado na chave: ' || vChave;
           Raise vEx_Update;
        End if;           
           
        Update t_glb_processodet w
          Set w.glb_status_codigo = '05', -- Finalizado com sucesso
              w.glb_processodet_dtfinal = Sysdate
        Where 0=0
          And w.glb_processo_codigo = '004'
          And 0 < ( Select Count(*) From tdvadm.t_arm_carregstatus st
                    Where st.glb_processo_codigo = w.glb_processo_codigo
                      And st.glb_procssodet_id = w.glb_processodet_id
                      And st.arm_carregamento_codigo = vArm_carregamento_codigo
                   );
        if sql%rowcount = 0 Then 
           vMessage := 'Carregamento ' || vArm_carregamento_codigo || ' Nao estava travado para produto quimico registrado na chave: ' || vChave;
           Raise vEx_Update;
        End if;           

       Commit;      

       
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'OK';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := 'Produto Quimico do carregamento - '|| vArm_carregamento_codigo || ' Liberado com sucesso.';

       
       
     Exception
       When vEx_Select Then
         pTpRecebido.Glb_Benasserec_Status     := 'ER';
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := pMessage ||'-'|| vMessage;
         pTpRecebido.Glb_Benasserec_Obs := pMessage   ;

         Return;
       
       when vEx_Responsavel then
         pTpRecebido.Glb_Benasserec_Status     := 'ER';
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao recuperar autorizacao para fechamento de carregamento quimico.' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     pTpRecebido.Glb_Benasserec_Origem || ' não tem permissão para liberar carregamento quimico.' || chr(10) ||
                     '********************************************************************************' || chr(10);
         pTpRecebido.Glb_Benasserec_Obs := pMessage;
         Return;
       when vEx_Update then
         pTpRecebido.Glb_Benasserec_Status     := 'ER';
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao Atualizar controles de carregamento quimico.' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     vMessage ||  chr(10) ||
                     '********************************************************************************' || chr(10);
         pTpRecebido.Glb_Benasserec_Obs := pMessage;
         Return;
       When Others Then
         pTpRecebido.Glb_Benasserec_Status     := 'ER';
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao recuperar autorizacao para fechamento de carregamento quimico.' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
         pTpRecebido.Glb_Benasserec_Obs := pMessage;
     
     End;
   End SPI_Set_AutCarregQuimico;                                       
   

   Procedure spi_Set_CustoFrota(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                vStatus Out Char,
                                vMessage Out clob)
   As       
      vQryString    varchar2(500);
      vReferencia   varchar2(10);
      vParam        varchar2(20);
      vValor        number;
      vValorLim     number;
      vFrota        CHAR(7);
      vAcao         varchar2(20);
      vContador     number;  
      vCursor       PKG_EDI_PLANILHA.T_CURSOR;
      vLinha1       pkg_glb_SqlCursor.tpString1024;
      vLinha2       pkg_glb_SqlCursor.tpString1024;
      vCustoDefault number := 4000;
   Begin

            --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=RODARCA;PARAM=DESP_RASTR;VLR=52876.98;                    
            --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=PARAM;PARAM=DESP_RASTR;VLR=52876.98;                    
            --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=LISTAFROTA;                    
            --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=LISTAPECAS;VLRLIM=4000;FROTA=0002158;                   
            --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=INCVEIC;FROTA=0002158;                   
            --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=EXCVEIC;FROTA=0002158;                   

            If tpRecebido.GLB_BENASSEREC_ASSUNTO is null Then
               tpRecebido.Glb_Benasserec_Origem := 'sdrumond@dellavolpe.com.br';
               tpRecebido.GLB_BENASSEREC_ASSUNTO := 'MSG=CUSTOFROTA;REF=201306;ACAO=RODARSA';
            End If;
            --Inicializo as variáveis.
            vReferencia := '';
            vParam      := '';
            vValor      := 0;
            vAcao       := '';
            vContador   := 0;
            vStatus     := '';
            vMessage    := '';
            
            --Propulo as variáveis, para recuperar os paramentros passados.
            vQryString  := upper(tpRecebido.GLB_BENASSEREC_ASSUNTO);
            vReferencia := substr(tdvadm.fn_querystring(vQryString,'REF','=',';'),1,7);
            vParam      := substr(tdvadm.fn_querystring(vQryString,'PARAM','=',';'),1,10);
            vValor      := NVL(tdvadm.fn_querystring(vQryString,'VLR','=',';'),0);
            vValorLim   := NVL(tdvadm.fn_querystring(vQryString,'VLRLIM','=',';'),0);
            vFrota      := LPAD(TRIM(substr(tdvadm.fn_querystring(vQryString,'FROTA','=',';'),1,7)),7,'0');

            vAcao       := trim(substr(tdvadm.fn_querystring(vQryString,'ACAO','=',';'),1,20));
            
            begin
              if nvl(vAcao,'XX') not in ('RODARCA',
                                         'RODARSA',
                                         'PARAM',
                                         'LISTAFROTA',
                                         'LISTAPECAS',
                                         'INCVEIC',
                                         'EXCVEIC') then
                 vMessage := vMessage || ' Mensagem sem ACAO definida / Desconhecida - ' || vAcao || chr(10) ;
                 vMessage := vMessage || ' Use : RODARCA    - Rodar com Acerto '  || chr(10) ;
                 vMessage := vMessage || '       RODARSA    - Rodar sem Acerto '  || chr(10) ;
                 vMessage := vMessage || '       PARAM      - Alterar algum parametro '  || chr(10) ;
                 vMessage := vMessage || '       LISTAFROTA - Receber a listagem das Frotas '  || chr(10) ;
                 vMessage := vMessage || '       INCVEIC    - Incliir Veiculo '  || chr(10) ;
                 vMessage := vMessage || '       EXCVEIC    - Excluir Veiculo '  || chr(10) ;
                 vStatus := pkg_glb_common.Status_Erro;
              End If;
              if ( nvl(vAcao,'XX') = 'PARAM') and  ( nvl(vParam,'XX') = 'XX' ) then
                 vMessage := vMessage || ' Parametro obrigatorio para esta ACAO - ' || vAcao || chr(10) ;
                 vStatus := pkg_glb_common.Status_Erro;
              End If;
              
                
            
              If vStatus <> pkg_glb_common.Status_Erro Then
                  select count(*)
                     into vContador
                  from tdvadm.t_edi_planilhaaut pa
                  where pa.edi_planilhacfg_codigo = 'SEMANEXO'
                    and pa.edi_planilhacfg_sistema = 'CUSTOFROTA'
                    and pa.edi_planilhaaut_autoriza = 'S'
                    and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
                    and pa.edi_planilhaaut_ativo = 'S'
                    and pa.edi_planilhaaut_vigencia <= sysdate
                    and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
                  If vContador > 0 Then 
                      if ( vAcao = 'RODARCA' ) or ( vAcao = 'RODARSA' )  Then 
                          --Executo a procedure responsável por realizar as trocas.
                          
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro(vReferencia,
                                                                      vAcao,
                                                                      vParam,
                                                                      vValor,
                                                                      vStatus,
                                                                      vMessage);



--                          delete eclick.t_eck_resultado e where substr(e.frt_resultado_referencia,4,4) = '2015';
--                          delete t_frt_resultado e where substr(e.frt_resultado_referencia,4,4) = '2015';
--                          delete t_frt_resultadodet e where e.referencia >= '201501';
--                          commit; 
                          tdvadm.PKG_FRT_CUSTO.vEnviaEmail := 'S';

/*
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201301','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201302','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201303','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201304','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201305','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201306','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201307','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201308','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201309','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201310','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201311','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201312','RODARSA',null,null,vStatus,vMessage);

                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201401','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201402','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201403','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201404','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201405','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201406','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201407','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201408','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201409','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201410','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201411','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201412','RODARSA',null,null,vStatus,vMessage);

                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201501','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201502','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201503','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201504','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201505','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201506','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201507','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201508','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201509','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201510','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201511','RODARSA',null,null,vStatus,vMessage);
                          tdvadm.PKG_FRT_CUSTO.SP_CarregaUtiParametro('201512','RODARSA',null,null,vStatus,vMessage);
*/


                      End if;   
                      
                      If vAcao in ('INCVEIC','EXCVEIC' )  Then

                         pkg_frt_custo.sp_IncExcVeiculo(vReferencia,vFrota,substr(vAcao,1,3),vStatus,vMessage);

                      End If;                      
                      
                      If ( vAcao = 'LISTAFROTA' )  Then
                         tdvadm.pkg_frt_custo.SP_ListaVeiculosAnalise(vReferencia,vCursor);
                         pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
                         pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
                         pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha1);
                         for i in 1 .. vLinha1.count loop
                            if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                               vMessage := vMessage || vLinha1(i);
                            Else
                                vMessage := vMessage || vLinha1(i) || chr(10);
                            End if;
                         End loop; 
                         
                      End If;                                         
                      If ( vAcao = 'LISTAPECAS' ) or (vAcao = 'RODARCA') or (vAcao = 'RODARSA') Then
                         IF vValorLim = 0 Then
                            vValorLim := vCustoDefault;
                         End if;   
                         tdvadm.pkg_frt_custo.SP_ListaPecasVeiculos(vReferencia,vValorLim,vFrota,vCursor);
                         pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
                         pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
                         pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha2);
                         for i in 1 .. vLinha2.count loop
                            if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                               vMessage := vMessage || vLinha2(i);
                            Else
                                vMessage := vMessage || vLinha2(i) || chr(10);
                            End if;
                         End loop; 
                         
                      End If;                                         

                  Else
                     vStatus     := 'E';
                     vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'ER';
                  End If;                                               
              End if;
              --envio mensagem do resultado da procedude. 
              wservice.pkg_glb_email.SP_ENVIAEMAIL('Processamento do Custo da Frota',
                                                   vMessage,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   tpRecebido.glb_benasserec_origem);
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'OK';
            Exception
              when others then
                if sqlcode <>  -29278 Then
                vMessage := sqlerrm || chr(10) || vMessage;
                wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao Autoriza Veiculo Coleta',
                                                     'Chave da Tabela - ' || to_char(tpRecebido.Glb_Benasserec_Chave) ||chr(10)|| vMessage,
                                                     'tdv.producao@dellavolpe.com.br',                                                  'tdv.producao@dellavolpe.com.br',
                                                     'bbernardo@dellavolpe.com.br');
                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                tpRecebido.Glb_Benasserec_Status     := 'ER';
                end if;
            end;
            
     
   End spi_Set_CustoFrota;



   Procedure sp_processa_EXPREVIAFAT(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                    vStatus Out Char,
                                    vMessage Out Varchar2)
   As                                    
      vQryString    varchar2(500);
      vData         Char(10);
      vChave        Varchar2(50);
      vContador     Number;

   Begin

            --Exemplo de QryString = MSG=EXPREVIAFAT;PREVIA=888888;DATA=02/08/2012;
           
            --Propulo as variáveis, para recuperar os paramentros passados.
            vQryString := tpRecebido.GLB_BENASSEREC_ASSUNTO;
            vChave     := tdvadm.fn_querystring(vQryString, 'PREVIA', '=', ';');
            vData      := tdvadm.fn_querystring(vQryString, 'DATA', '=', ';');
            
   
            if ( tpRecebido.glb_benasserec_origem = 'tdv.spfaturamento1@dellavolpe.com.br' ) or
               ( tpRecebido.glb_benasserec_origem = 'tdv.spfaturamento2@dellavolpe.com.br' ) or
               ( tpRecebido.glb_benasserec_origem = 'rayaraujo@dellavolpe.com.br' ) or
               ( tpRecebido.glb_benasserec_origem = 'tdv.auxfatura@dellavolpe.com.br' ) or
               ( tpRecebido.glb_benasserec_origem = 'dgmoreira@dellavolpe.com.br' ) or
               ( tpRecebido.glb_benasserec_origem  = 'andre.oliveira@dellavolpe.com.br' ) or
               ( tpRecebido.glb_benasserec_origem  = 'eduarda.almeida@dellavolpe.com.br' )
               
             Then
              -- criticar se gerou faturas 
              SELECT count(*)
                into vContador
                FROM tdvadm.T_CON_FATURAEXCEL EX
               WHERE trim(EX.CON_FATURAEXCEL_CODIGO) = trim(vChave)
                 AND TRUNC(EX.CON_FATURAEXCEL_DTLEITURA) = vData;
              if vContador > 0 Then
                DELETE tdvadm.T_CON_FATURAEXCEL EX
                 WHERE trim(EX.CON_FATURAEXCEL_CODIGO) = trim(vChave)
                   AND TRUNC(EX.CON_FATURAEXCEL_DTLEITURA) = vData;
                vMessage := 'Foram excluidos ' || to_char(vContador) ||
                            ' registros.';
                wservice.pkg_glb_email.SP_ENVIAEMAIL('Exclusão Realizada',
                                                     vMessage,
                                                     'tdv.producao@dellavolpe.com.br',
                                                     trim(tpRecebido.glb_benasserec_origem));
                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                tpRecebido.Glb_Benasserec_Status     := 'OK';
              Else
                vMessage := 'Não foram encontrados registros para exclusão' ||
                            chr(10) || 'Da Previa ' || vChave || chr(10) ||
                            'Data      ' || vData || chr(10);
                wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao realizar Exclusão de Previa',
                                                     vMessage,
                                                     'tdv.producao@dellavolpe.com.br',
                                                     trim(tpRecebido.glb_benasserec_origem));
                
                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                tpRecebido.Glb_Benasserec_Status     := 'ER';
              end if;
            Else
              vMessage := 'EMAIL NÃO AUTORIZADO PARA EXCLUIR PREVIA';
              wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao realizar Exclusão de Previa',
                                                   vMessage,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   trim(tpRecebido.glb_benasserec_origem));
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'ER';
              
            end if;
     
   End sp_processa_EXPREVIAFAT;   
   
   
   
   Procedure sp_processa_REFCTB(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                vStatus Out Char,
                                vMessage Out Varchar2)
   AS
     vQryString   varchar2(500);
     vReferencia  varchar2(10);
     vAcao        varchar2(20);
     vStatusAnt   tdvadm.t_ctb_referencia.ctb_referencia_status%type;
     vContador    number;
   Begin
   
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
       --Exemplo de QryString = MSG=REFCTB;REF=201212;ACAO=ABRE;

       vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));

       vReferencia := Trim(tdvadm.fn_querystring(vQryString,'REFCTB','=',';'));     
       vAcao       := Trim(tdvadm.fn_querystring(vQryString,'ACAO','=',';'));

                  select count(*)
                     into vContador
                  from tdvadm.t_edi_planilhaaut pa
                  where pa.edi_planilhacfg_codigo = 'REFCTB'
                    and pa.edi_planilhacfg_sistema = 'REFCTB'
                    and pa.edi_planilhaaut_autoriza = 'S'
                    and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
                    and pa.edi_planilhaaut_ativo = 'S'
                    and pa.edi_planilhaaut_vigencia <= sysdate
                    and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
                  If vContador > 0 Then 
                     begin

                         select REF.CTB_REFERENCIA_STATUS
                           into vStatusAnt
                         from tdvadm.T_CTB_REFERENCIA REF
                         WHERE REF.CTB_REFERENCIA_CODIGO = vReferencia;  

                         if vAcao = 'ABRE' Then
                            if nvl(vStatusAnt,'A') <> 'A' Then
                               vAcao := 'Abertura';
                               UPDATE T_CTB_REFERENCIA REF
                                 SET REF.CTB_REFERENCIA_STATUS = 'A',
                                     REF.CTB_REFERENCIA_RECALCULADA = 'S'
                               WHERE REF.CTB_REFERENCIA_CODIGO = vReferencia;     
                            Else
                               vAcao := 'Aberta'; 
                               vStatus := pkg_glb_common.Status_Warning;                                     
                            End if;   
                         ElsIf vAcao = 'FECHA' Then
                            if nvl(vStatusAnt,'A') <> 'F' Then
                               vAcao := 'Fechamento';
                               UPDATE T_CTB_REFERENCIA REF
                                 SET REF.CTB_REFERENCIA_STATUS = 'F',
                                     REF.CTB_REFERENCIA_RECALCULADA = 'S'
                               WHERE REF.CTB_REFERENCIA_CODIGO = vReferencia; 
                            Else
                               vAcao := 'Fechada'; 
                               vStatus := pkg_glb_common.Status_Warning;                                     
                            End if;   
                         Else
                            vStatus := pkg_glb_common.Status_Erro;
                            vMessage := 'Problemas para Identificar a a Ação -> ' || vAcao || ' para Referencia -> ' || vReferencia || chr(10) || chr(10); 
                            tpRecebido.Glb_Benasserec_Processado := Sysdate;
                            tpRecebido.Glb_Benasserec_Status     := 'ER';
                         End if;
                         if vStatus = pkg_glb_common.Status_Nomal Then 
                             If SQL%ROWCOUNT = 0 Then
                                vStatus := pkg_glb_common.Status_Erro;
                                vMessage := 'Problemas ao executar a Ação -> ' || vAcao || ' na Referencia -> ' || vReferencia || chr(10) || chr(10); 
                                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                                tpRecebido.Glb_Benasserec_Status     := 'ER';
                             Else
                                vStatus := pkg_glb_common.Status_Nomal;
                                vMessage := 'Referencia -> ' || vReferencia || ' alterada com exito ' || chr(10) || chr(10) ;
                                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                                tpRecebido.Glb_Benasserec_Status     := 'OK';
                                commit;
                             End If;  
                         Elsif vStatus = pkg_glb_common.Status_Warning then
                   
                                vStatus := pkg_glb_common.Status_Nomal;
                                vMessage := 'Referencia -> ' || vReferencia || ' ja Estava  ' || vAcao || chr(10) || chr(10) ;
                                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                                tpRecebido.Glb_Benasserec_Status     := 'OK';
                         End if;
                     exception
                       when NO_DATA_FOUND Then
                          vStatus     := pkg_glb_common.Status_Nomal;
                          vMessage    := 'Problemas ao executar a Ação -> ' || vAcao || ' na Referencia -> ' || vReferencia || ' não encontrada...' || chr(10) || chr(10);
                          tpRecebido.Glb_Benasserec_Processado := Sysdate;
                          tpRecebido.Glb_Benasserec_Status     := 'OK';
                         
                       when OTHERS Then
                          vStatus     := 'E';
                          vMessage    := chr(10) || chr(10) || 'Erro ORACLE ' || chr(10) || chr(10) || sqlerrm;
                          tpRecebido.Glb_Benasserec_Processado := Sysdate;
                          tpRecebido.Glb_Benasserec_Status     := 'ER';
                         
                       End;         
                  Else
                     vStatus     := 'E';
                     vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'ER';
                  End If;                                               


              wservice.pkg_glb_email.SP_ENVIAEMAIL('Mudanca de Status da Referencia Contabil',
                                                   vMessage,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   tpRecebido.glb_benasserec_origem);


   End sp_processa_REFCTB;
   
   
   Procedure sp_processa_AUTCOLETA(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                   vStatus Out Char,
                                   vMessage Out clob)
   As       
      vQryString    varchar2(500);
      vPlacaAtual   char(07);
      vPlacaNova    char(07);
      vEqpto        number;
      vVigencia     char(10);
      vAcao         char(2);
      vContador     number;                                
   Begin

            --Exemplo de QryString = MSG=AUTCOLETA;PLACA=EQP8103;VIG=01/10/2012;
            
            --Inicializo as variáveis.
            vPlacaAtual := '';
            vPlacaNova  := '';
            vEqpto      := 0;
            vQryString  := '';
            vStatus     := '';
            vMessage    := '';
            
            --Propulo as variáveis, para recuperar os paramentros passados.
            vQryString  := upper(tpRecebido.GLB_BENASSEREC_ASSUNTO);
            vPlacaAtual := substr(tdvadm.fn_querystring(vQryString,
                                                        'PLACA',
                                                        '=',
                                                        ';'),
                                  1,
                                  7);
            vVigencia   := substr(tdvadm.fn_querystring(vQryString, 'VIG', '=', ';'),
                                  1,
                                  10);
            vAcao       := substr(tdvadm.fn_querystring(vQryString, 'ACAO', '=', ';'),
                                  1,2);
            
            begin
              if nvl(vAcao,'XX') = 'XX' then
                 vMessage := vMessage || ' Mensagem sem ACAO definida ... ' || chr(10) ;
              Else  
                  select count(*)
                     into vContador
                  from tdvadm.t_edi_planilhaaut pa
                  where pa.edi_planilhacfg_codigo = 'AUTCOLETA'
                    and pa.edi_planilhacfg_sistema = 'AUTCOLETA'
                    and pa.edi_planilhaaut_autoriza = 'S'
                    and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
                    and pa.edi_planilhaaut_ativo = 'S'
                    and pa.edi_planilhaaut_vigencia <= sysdate
                    and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
                  If vContador > 0 Then 
                  --Executo a procedure responsável por realizar as trocas.
                  tdvadm.PKG_FRTCAR_VEICULO.sp_set_veiculocoleta( pkg_glb_common.FN_LIMPA_CAMPOtel(upper(vPlacaAtual)),
                                                                 vVigencia,
                                                                 vAcao,
                                                                 vStatus,
                                                                 vMessage);
                  Else
                     vStatus     := 'E';
                     vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'ER';
                  End If;                                               
              End if;
              vMessage := vMessage ||
                          '********************************************************************************' ||
                          chr(10);
              If  vMessage <> 'Voce Não esta AUTORIZADO' Then           
                 vMessage := vMessage ||
                             tdvadm.PKG_FRTCAR_VEICULO.fn_get_veiculocoleta || chr(10);
              End If;        
              --envio mensagem do resultado da procedude. 
              wservice.pkg_glb_email.SP_ENVIAEMAIL('Operação Autoriza Veiculo Coleta',
                                                   vMessage,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   tpRecebido.glb_benasserec_origem);
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'OK';
            Exception
              when others then
                if sqlcode <>  -29278 Then
                vMessage := sqlerrm || chr(10) || vMessage;
                wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao Autoriza Veiculo Coleta',
                                                     'Chave da Tabela - ' || to_char(tpRecebido.Glb_Benasserec_Chave) ||chr(10)|| vMessage,
                                                     'tdv.producao@dellavolpe.com.br',                                                  'tdv.producao@dellavolpe.com.br',
                                                     'bbernardo@dellavolpe.com.br');
                tpRecebido.Glb_Benasserec_Processado := Sysdate;
                tpRecebido.Glb_Benasserec_Status     := 'ER';
                end if;
            end;
            
     
   End sp_processa_AUTCOLETA;
--acee vaga estagio

   Procedure sp_processa_EXCTFDUP(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                  vStatus Out Char,
                                  vMessage Out Varchar2)
   AS
     vQryString   varchar2(500);
     vCodAbast    varchar2(50);
     vAcerto      varchar2(50);
     vFrota       varchar2(50);
     vAchouMsg    varchar2(50);
     vContador    number;
   Begin
   
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
       -- MSG=EXCTFDUP;CODCTF=85228710;ACERTO=45555796;FROTA=2070;
       vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));

       vCodAbast := Trim(tdvadm.fn_querystring(vQryString,'CODCTF','=',';'));     
       vAcerto   := Trim(tdvadm.fn_querystring(vQryString,'ACERTO','=',';'));
       vFrota    := substr(LPAD(Trim(tdvadm.fn_querystring(vQryString,'FROTA','=',';')),7,'0'),-7,7);

                  select count(*)
                     into vContador
                  from tdvadm.t_edi_planilhaaut pa
                  where pa.edi_planilhacfg_codigo = 'EXCTFDUP'
                    and pa.edi_planilhacfg_sistema = 'EXCTFDUP'
                    and pa.edi_planilhaaut_autoriza = 'S'
                    and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
                    and pa.edi_planilhaaut_ativo = 'S'
                    and pa.edi_planilhaaut_vigencia <= sysdate
                    and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
                  If vContador > 0 Then 
                     begin
                         DELETE T_ACC_ABASTECIMENTO A
                         WHERE trim(A.ACC_ABASTECIMENTO_NUMERO) = vCodAbast
                           AND trim(A.ACC_ACONTAS_NUMERO)       = vAcerto
                           AND A.FRT_CONJVEICULO_CODIGO   = vFrota;
                          
                         If SQL%ROWCOUNT = 0 Then
                            vStatus := pkg_glb_common.Status_Erro;
                            vMessage := 'Problemas ao Tentar excluir abastecimento ' || chr(10) || chr(10); 
                            tpRecebido.Glb_Benasserec_Processado := Sysdate;
                            tpRecebido.Glb_Benasserec_Status     := 'ER';
                         Else
                            vStatus := pkg_glb_common.Status_Nomal;
                            vMessage := 'Seu Abastecimento foi excluido com exito ' || chr(10) || chr(10) ;
                            tpRecebido.Glb_Benasserec_Processado := Sysdate;
                            tpRecebido.Glb_Benasserec_Status     := 'OK';
                         End If;  

                        select decode(count(*),0,'Não Encontrado','OK')
                          into vAchouMsg
                        from tdvadm.t_acc_abastecimento a
                        where A.ACC_ABASTECIMENTO_NUMERO = rpad(trim(vCodAbast),10,' ');
                             
                        vMessage := vMessage || ' Codigo CTF ' || vCodAbast  || ' - ' || vAchouMsg || chr(10); 
                            
                        select decode(count(*),0,'Não Encontrado','OK')
                          into vAchouMsg
                        from tdvadm.t_acc_acontas a
                        where A.ACC_ACONTAS_NUMERO = vAcerto;

                        vMessage := vMessage || ' Acerto     ' || vAcerto  || ' - ' || vAchouMsg || chr(10); 
                            
                        select decode(count(*),0,'Não Encontrado','OK')
                          into vAchouMsg
                        from tdvadm.t_frt_conteng a
                        where A.Frt_Conjveiculo_Codigo = vFrota;

                        vMessage := vMessage || ' Frota      ' || vFrota  || ' - ' || vAchouMsg || chr(10); 
                     exception
                       when OTHERS Then
                          vStatus     := 'E';
                          vMessage    := chr(10) || chr(10) || 'Erro ORACLE ' || chr(10) || chr(10) || sqlerrm;
                          tpRecebido.Glb_Benasserec_Processado := Sysdate;
                          tpRecebido.Glb_Benasserec_Status     := 'ER';
                         
                       End;         
                  Else
                     vStatus     := 'E';
                     vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'ER';
                  End If;                                               


              wservice.pkg_glb_email.SP_ENVIAEMAIL('Operação Exclusao de Abastecimento',
                                                   vMessage,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   tpRecebido.glb_benasserec_origem);


   End sp_processa_EXCTFDUP;


   Procedure sp_processa_VOLTACARREG(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                     vStatus Out Char,
                                     vMessage Out Varchar2)
   AS
     vQryString    varchar2(500);
     vCarregamento varchar2(50);
     vDescarrega   varchar2(50);
     vExcluiNota   varchar2(50);
     vAchouMsg     varchar2(50);
     vContador     number;
   Begin
   
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
      --Exemplo de QryString = MSG=VOLTACARREG;CARREGAMENTO=85229022;DESCARREGA=N;EXCLUINOTA=N;
       vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));

       vCarregamento := Trim(tdvadm.fn_querystring(vQryString,'CARREGAMENTO','=',';'));     
       vDescarrega   := Trim(tdvadm.fn_querystring(vQryString,'DESCARREGA'  ,'=',';'));
       vExcluiNota   := Trim(tdvadm.fn_querystring(vQryString,'EXCLUINOTA'  ,'=',';'));

                  select count(*)
                     into vContador
                  from tdvadm.t_edi_planilhaaut pa
                  where pa.edi_planilhacfg_codigo = 'VOLTACARREG'
                    and pa.edi_planilhacfg_sistema = 'VOLTACARREG'
                    and pa.edi_planilhaaut_autoriza = 'S'
                    and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
                    and pa.edi_planilhaaut_ativo = 'S'
                    and pa.edi_planilhaaut_vigencia <= sysdate
                    and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
                  If vContador > 0 Then 
                     begin
                         pkg_fifo.sp_RetornaCarrgamento(vCarregamento,
                                                        vStatus,
                                                        vMessage);

                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'OK';
                     exception
                       when OTHERS Then
                          vStatus     := 'E';
                          vMessage    := chr(10) || chr(10) || 'Erro ORACLE ' || chr(10) || chr(10) || sqlerrm;
                          tpRecebido.Glb_Benasserec_Processado := Sysdate;
                          tpRecebido.Glb_Benasserec_Status     := 'ER';
                         
                       End;         
                  Else
                     vStatus     := 'E';
                     vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'ER';
                  End If;                                               


              wservice.pkg_glb_email.SP_ENVIAEMAIL('Operação Volta Carregamento',
                                                   vMessage,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   tpRecebido.glb_benasserec_origem);


   End sp_processa_VOLTACARREG;




   Procedure sp_processa_LimpaSynchro(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                     vStatus Out Char,
                                     vMessage Out CLOB)
   AS
     vQryString    varchar2(500);
     vCliente      char(1);
     vEndereco     char(1);
     vDocumento    char(1);
     vNotas        char(1);
     vAssociados   char(1);
     vEmail1       varchar2(50);
     vEmail2       varchar2(50);
     vAchouEm1     INTEGER;
     vAchouEm2     INTEGER;
     vCursor       PKG_EDI_PLANILHA.T_CURSOR;
     vLinha        pkg_glb_SqlCursor.tpString1024;
     vMessage2     clob;
     
--     vAchouMsg     varchar2(50);
     vContador     number;
   Begin
   
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
       vEmail1 := 'dsilva@dellavolpe.com.br';
       vEmail2 := 'tdv.contador@dellavolpe.com.br';
       
      --Exemplo de QryString = MSG=LIMPASYNCHRO;CLIENTE=S;ENDERECO=S;DOCUMENTOS=S;NOTAS=S;ASSOCIADOS=S
       vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));

       vCliente    := Trim(tdvadm.fn_querystring(vQryString,'CLIENTE','=',';'));     
       vEndereco   := Trim(tdvadm.fn_querystring(vQryString,'ENDERECO'  ,'=',';'));
       vDocumento  := Trim(tdvadm.fn_querystring(vQryString,'DOCUMENTOS'  ,'=',';'));
       vNotas      := Trim(tdvadm.fn_querystring(vQryString,'NOTAS'  ,'=',';'));
       vAssociados := Trim(tdvadm.fn_querystring(vQryString,'ASSOCIADOS'  ,'=',';'));

      select count(*)
         into vContador
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = 'LIMPASYNCHRO'
        and pa.edi_planilhacfg_sistema = 'LIMPASYNCHRO'
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
        If vContador > 0 Then 
          begin
                       
             select count(*)
               into vAchouEm1
             from rmadm.t_glb_benasserec rec
             where trunc(rec.glb_benasserec_gravacao) = trunc(sysdate)  
               and  Trim(tdvadm.fn_querystring(rec.glb_benasserec_assunto,'MSG','=',';')) = 'LIMPASYNCHRO'
               and rec.glb_benasserec_origem = vEmail1;

             select count(*)
               into vAchouEm2
             from rmadm.t_glb_benasserec rec
             where trunc(rec.glb_benasserec_gravacao) = trunc(sysdate)  
               and  Trim(tdvadm.fn_querystring(rec.glb_benasserec_assunto,'MSG','=',';')) = 'LIMPASYNCHRO'
               and rec.glb_benasserec_origem = vEmail2;
                       
--                       if vContador > 0 Then  

             open vCursor FOR SELECT '1 - CLIENTE' tipo,
                                     to_char(p.dh_critica,'MM/YYYY') referencia,
                                     'Cadastro' tpdoc,
                                     decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA') status,
                                     count(*) QTDECRITICA 
                               from synchro.synitf_pessoa p 
                              where p.msg_critica is null 
                              group by  to_char(p.dh_critica,'MM/YYYY'),
                                        decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA')                                       
                              union
                              SELECT '2 - ENDERECO' tipo,
                                     to_char(p.dh_critica,'MM/YYYY') referencia,
                                     'Cadastro' tpdoc,
                                     decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA') status,
                                     count(*) QTDECRITICA 
                              from synchro.synitf_localidade_pessoa p 
                              where p.msg_critica is null
                              group by  to_char(p.dh_critica,'MM/YYYY'),
                                        decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA')                                       
                              union
                              select '3 - DOCUMENTO' tipo,
                                     to_char(p.dt_fato_gerador_imposto,'MM/YYYY') referencia,
                                     p.edof_codigo tpdoc,
                                     decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA') status,
                                     count(*) QTDECRITICA 
                              from synchro.SYNITF_DOF p
                              where p.msg_critica is null
                              group by  p.edof_codigo,
                                       to_char(p.dt_fato_gerador_imposto,'MM/YYYY'),
                                       decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA')                                       
                              union         
                              select '4 - DOCUMENTO ITENS' tipo,
                                     to_char(p1.dt_fato_gerador_imposto,'MM/YYYY') referencia,
                                     p1.edof_codigo tpdoc,
                                     decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA') status,
                                     count(distinct p.dof_import_numero || p.IDF_NUM) QTDECRITICA 
                              from synchro.synitf_idf p,
                                   synchro.SYNITF_DOF p1
                              where p.msg_critica is null
                                and p.dof_import_numero = p1.dof_import_numero (+)     
                              group by p1.edof_codigo,
                                       to_char(p1.dt_fato_gerador_imposto,'MM/YYYY') ,
                                       decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA')                                       
                              union
                              select '5 - NOTAS CLIENTES' tipo,
                                     to_char(nvl(p1.dt_fato_gerador_imposto,p.dh_emissao_assoc),'MM/YYYY') referencia,
                                     p1.edof_codigo tpdoc,
                                     decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA') status,
                                     count(distinct p.dof_import_numero || p.dh_emissao_assoc  ) QTDECRITICA 
                              from synchro.synitf_dof_associado p ,
                                   synchro.SYNITF_DOF p1
                              where p.msg_critica is null
                                and p.dof_import_numero = p1.dof_import_numero (+)     
                              group by p1.edof_codigo,
                                       to_char(nvl(p1.dt_fato_gerador_imposto,p.dh_emissao_assoc ),'MM/YYYY'),
                                       decode(trim(nvl(p.msg_critica,'')),'','NÂO PROCESSADO','PROCESSADO COM CRITICA')                                       
                              order by 1,3,2;


             pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
             pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
             pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha);



             vAchouEm2 :=  vAchouEm1;
             
             IF vAchouEm1 < vAchouEm2 Then
                vMessage := vMessage ||  ' <br /> FALTA AUTORIZAÇÃO DO ' || vEmail1 || ' PARA FINALIZAR O PROCESSO <br />';
                vCliente    := 'N';     
                vEndereco   := 'N';
                vDocumento  := 'N';
                vNotas      := 'N';
                vAssociados := 'N';
             Elsif vAchouEm1 > vAchouEm2 Then
                vMessage := vMessage ||  ' <br /> FALTA AUTORIZAÇÃO DO ' || vEmail2 || ' PARA FINALIZA PROCESSO <br />';
                vCliente    := 'N';     
                vEndereco   := 'N';
                vDocumento  := 'N';
                vNotas      := 'N';
                vAssociados := 'N';
             ElsIf ( vAchouEm1 = 0 ) and ( vAchouEm2 = 0 ) Then
                vMessage := vMessage ||  ' <br /> FALTA AUTORIZAÇÃO DO ' || vEmail1 || ' E DO ' || vEmail2 || ' PARA FINALIZA PROCESSO <br />';
                vCliente    := 'N';     
                vEndereco   := 'N';
                vDocumento  := 'N';
                vNotas      := 'N';
                vAssociados := 'N';
             End if;

             vMessage := vMessage ||  '<br /> ';
             if vCliente = 'S' Then
                vMessage2 := vMessage2 ||  'LIMPEZA DE CLIENTE OK <br />';
                DELETE synchro.synitf_pessoa P WHERE P.MSG_CRITICA IS NOT NULL;
             End If;
             if vEndereco = 'S' Then
                vMessage2 := vMessage2 ||  'LIMPEZA DE ENDEREÇOS OK <br />';
                DELETE synchro.Synitf_Localidade_Pessoa P WHERE P.MSG_CRITICA IS NOT NULL;
             End If;
             if vDocumento = 'S' Then
                vMessage2 := vMessage2 ||  'LIMPEZA DE DOCUMENTOS OK <br />';
                DELETE synchro.Synitf_Dof P WHERE P.MSG_CRITICA IS NOT NULL;
             End If;
             if vNotas = 'S' Then
                vMessage2 := vMessage2 ||  'LIMPEZA DE NOTAS OK <br />';
                DELETE synchro.Synitf_Idf P WHERE P.MSG_CRITICA IS NOT NULL;
             End If;
             if vAssociados = 'S' Then        
                vMessage2 := vMessage2 ||  'LIMPEZA DE ASSOCIADOS OK <br />';
                DELETE synchro.Synitf_Dof_Associado P WHERE P.MSG_CRITICA IS NOT NULL;
             End If;


              vMessage2 := vMessage2 ||  'CRITICAS ENCONTRADAS NO SYNCHRO <br />';

              for i in 1 .. vLinha.count loop
                 if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                    vMessage2 := vMessage2 || vLinha(i);
                 Else
                    vMessage2 := vMessage2 || vLinha(i) || chr(10);
                 End if;
              End loop;


                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'OK';
                     exception
                       when OTHERS Then
                          vStatus     := 'E';
                          vMessage    := chr(10) || chr(10) || 'Erro ORACLE ' || chr(10) || chr(10) || sqlerrm;
                          tpRecebido.Glb_Benasserec_Processado := Sysdate;
                          tpRecebido.Glb_Benasserec_Status     := 'ER';
                         
                       End;         
                  Else
                     vStatus     := 'E';
                     vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
                     tpRecebido.Glb_Benasserec_Processado := Sysdate;
                     tpRecebido.Glb_Benasserec_Status     := 'ER';
                  End If;                                               


              wservice.pkg_glb_email.SP_ENVIAEMAIL('Operação Limpeza do Synchro',
                                                   vMessage2,
                                                   'tdv.producao@dellavolpe.com.br',
                                                   tpRecebido.glb_benasserec_origem,
                                                   vEmail1,
                                                   vEmail2);


   End sp_processa_LimpaSynchro;









   Procedure sp_processa_ET(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                            vStatus Out Char,
                            vMessage Out Varchar2)
   As       
      MSGPlaca      CHAR(7);   
      MSGCodigoMSG  NUMBER;
      MSGORIGEM     rmadm.T_GLB_BENASSEMSG.GLB_BENASSEMSG_ORIGEM%TYPE;
      MSGMCT        TDVADM.T_ATR_ULTPOSICAO.ATR_ULTPOSICAO_MCT%TYPE;
      MSGCONTA      TDVADM.T_ATR_ULTPOSICAO.ATR_ULTPOSICAO_CONTA%TYPE;
      MSGASSUNTOCLI rmadm.T_GLB_BENASSEREC.GLB_BENASSEREC_ASSUNTO%TYPE;
      MSGASSUNTOTDV rmadm.t_glb_benasseREC.Glb_Benasserec_Assunto%TYPE;
      msgerro       clob; 
--      MsgRet        clob;
--      MSGCODIGO     NUMBER;
      MSGCOR        rmadm.T_GLB_BENASSEMSG.GLB_BENASSEMSG_CORCODIGO%TYPE;
      MSGCORFONTE   rmadm.T_GLB_BENASSEMSG.GLB_BENASSEMSG_CORCODIGOFONTE%TYPE; 
   Begin

            --Exemplo de QryString = MSG=ET;PLACA=BKU1287;ASSUNTO=SHDHD HD H DHD;
            
            MSGPlaca     := UPPER(Trim(tdvadm.fn_querystring(tpRecebido.GLB_BENASSEREC_ASSUNTO,
                                                             'PLACA',
                                                             '=',
                                                             ';')));
            MSGCodigoMSG := UPPER(Trim(tdvadm.fn_querystring(tpRecebido.GLB_BENASSEREC_ASSUNTO,
                                                             'ASSUNTO',
                                                             '=',
                                                             ';')));
            MSGORIGEM   := 'CT';

            
            BEGIN
              SELECT T.ATR_TERMINAL_MCT
                INTO MSGMCT
                FROM TDVADM.T_ATR_TERMINAL T
               WHERE 0 = 0
                 AND T.ATR_TERMINAL_PLACA = MSGPlaca;
              MSGCONTA := 99999999;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                msgerro  := msgerro || 'Placa não Encontrada ' || MSGPlaca ||
                            ' origem ' || trim(tpRecebido.glb_benasserec_origem) ||
                            chr(10);
                MSGMCT   := 9999999;
                MSGCONTA := 99999999;
            END;
            tpRecebido.Glb_Benasserec_Processado := Sysdate;
            tpRecebido.Glb_Benasserec_Status     := 'ER';
            
             update rmadm.t_glb_benasserec br
               set br.glb_benasserec_processado = tpRecebido.Glb_Benasserec_Processado,
                   br.glb_benasserec_status     = tpRecebido.Glb_Benasserec_Status
             where br.glb_benasserec_chave = tpRecebido.glb_benasserec_chave;
             commit;
             
             msgerro := '************************************************************' ||                    chr(10);


            IF GLBADM.PKG_GLB_UTIL.F_ENUMERICO(tpRecebido.GLB_BENASSEREC_ASSUNTO) = 'S' THEN
              MSGCodigoMSG := TO_NUMBER(tpRecebido.GLB_BENASSEREC_ASSUNTO);

              msgerro      := msgerro || 'Mensagem veio de do Celular ' ||
                              trim(tpRecebido.glb_benasserec_origem) ||
                              ' com Codigo  ' ||
                              to_char(tpRecebido.glb_benasserec_assunto) ||
                              chr(10);
            Else
              msgerro := msgerro || 'Mensagem veio de do Celular ' ||
                         trim(tpRecebido.glb_benasserec_origem) ||
                         ' com Codigo nao nunerico ' ||
                         trim(tpRecebido.glb_benasserec_assunto) || chr(10);
            END IF;
            MSGMCT   := 9999999;
            MSGCONTA := 99999999;



          IF tpRecebido.Glb_Benasserec_Status <> 'ER' THEN
            BEGIN
              SELECT MSG.GLB_BENASSEMSG_DESCCLI,
                     MSG.GLB_BENASSEMSG_DESCTDV,
                     MSG.GLB_BENASSEMSG_CORCODIGO,
                     MSG.GLB_BENASSEMSG_CORCODIGOFONTE
                INTO MSGASSUNTOCLI, MSGASSUNTOTDV, MSGCOR, MSGCORFONTE
                FROM RMADM.T_GLB_BENASSEMSG MSG
               WHERE MSG.GLB_BENASSEMSG_CODIGO = MSGCodigoMSG
                 AND MSG.GLB_BENASSEMSG_ORIGEM = MSGORIGEM;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                MSGORIGEM := 'ER';
                msgerro   := msgerro || CHR(10) || 'Codigo da Macro Errado - ' ||
                             to_char(MSGCodigoMSG) || ' - origem - ' || MSGORIGEM ||
                             ' -  REMETENTE: ' ||
                             tpRecebido.glb_benasserec_origem || CHR(10);
            END;
            
            IF MSGORIGEM <> 'ER' THEN
              
              UPDATE TDVADM.T_ATR_ULTPOSICAO UP
                 SET UP.ATR_ULTPOSICAO_STATUS         = MSGASSUNTOCLI,
                     UP.ATR_ULTPOSICAO_DATA           = tpRecebido.GLB_BENASSEREC_GRAVACAO,
                     UP.ATR_ULTPOSICAO_CORCODIGO      = MSGCOR,
                     UP.ATR_ULTPOSICAO_CORCODIGOFONTE = MSGCORFONTE
               WHERE 0 = 0
                    --          AND UP.ATR_ULTPOSICAO_CONTA = MSGCONTA
                 AND UP.ATR_ULTPOSICAO_MCT = MSGMCT;
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'OK';
              
              /*  ELSE
                   tpBenasserec.GLB_BENASSEREC_CHAVE := SEQ_GLB_BENASSEREC.NEXTVAL;
                     
                   UPDATE TDVADM.T_ATR_ULTPOSICAO UP
                     SET UP.ATR_ULTPOSICAO_STATUS = 'CODERRADO-' || Trim(tpBenasserec.GLB_BENASSEREC_ASSUNTO),
                         UP.ATR_ULTPOSICAO_DATA = tpBenasserec.GLB_BENASSEREC_GRAVACAO,
                         UP.ATR_ULTPOSICAO_CORCODIGO = MSGCOR,
                         UP.ATR_ULTPOSICAO_CORCODIGOFONTE = MSGCORFONTE
                   WHERE UP.ATR_ULTPOSICAO_CONTA = MSGCONTA
                     AND UP.ATR_ULTPOSICAO_MCT = MSGMCT;           
              */
            Else
              tpRecebido.Glb_Benasserec_Processado := Sysdate;
              tpRecebido.Glb_Benasserec_Status     := 'ER';
            END IF;
            
            --   If msgerro <> '************************************************************' || chr(10) Then
            --       
            msgerro := msgerro || chr(10) ||
                       '************************************************************' ||
                       chr(10);
            
            --   End If;    
            
          END IF;

   End;

   Procedure sp_processa_TORPEDO(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                 vStatus Out Char,
                                 vMessage Out Varchar2)
   As       
      tpTorpedoCfg  tdvadm.t_edi_torpedocfg%rowtype;
      tpTorpedoResp tdvadm.t_edi_torpedoresp%rowtype;
      vCadStatus       char(1);
      vContador     number; -- auxiliar
   begin

       begin

          sp_verifica_TORVERIFICA(tpRecebido,tpTorpedoCfg,tpTorpedoResp,vCadStatus);
                       
          if vCadStatus = 'N' Then -- Não Existe
             sp_verifica_TORCADASTRA(tpRecebido,'S');
          Elsif vCadStatus = 'R' Then -- Possivel Resposta de uma Pergunta
              -- GRAVAR A RESPOSTA AQUI
             if tpTorpedoResp.Edi_Torpedoresp_Respesperada = 'NOME' then
                sp_Envia_TORPEDO(tpTorpedoResp.Edi_Torpedorcfg_Telefone,
                                 'SEU NOME E ' || trim(tpRecebido.Glb_Benasserec_Assunto));
             End if;                    
          End if;

          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'OK';
       End;

     
   End;

   Procedure sp_processa_Altparametro(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                      vStatus  Out Char,
                                      vMessage Out Varchar2)
   AS
     vQryString   varchar2(500);
     vMsg         varchar2(500);
     vAcao        varchar2(20);
     vSistema     varchar2(100);
     vVigencia    date;
     vExiste      integer;
     vContador    INTEGER;
     vPerfil      T_USU_APLICACAOPERFIL.USU_PERFIL_CODIGO%type;
     vParat       T_USU_APLICACAOPERFIL.USU_APLICACAOPERFIL_PARAT%type;
     vValidade    T_USU_APLICACAOPERFIL.USU_APLICACAOPERFIL_VALIDADE%type;
     vAtivo       T_USU_APLICACAOPERFIL.USU_APLICACAOPERFIL_ATIVO%type;
   Begin
   
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
       /*Exemplo de QryString = MSG=LIBERAPARAN;
                                SISTEMA=ANTTINDISP;
                                ACAO=TRAVA/LIBERA;
                                PARAM=ANTTINDISP;
                                ROTA=010;
                                USUARIO=JSANTOS;
                                VIGENCIA=01/01/0001; 
                    */

       vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));  
       
       vMsg        := Trim(tdvadm.fn_querystring(vQryString,'MSG','=',';'));
       vAcao       := Trim(tdvadm.fn_querystring(vQryString,'ACAO','=',';'));
       vSistema    := Trim(tdvadm.fn_querystring(vQryString,'SISTEMA','=',';'));
       vVigencia   := Trim(tdvadm.fn_querystring(vQryString,'VIGENCIA','=',';'));
       
       
       if vVigencia is null then
          vVigencia := sysdate; 
       end if;  
       
       
       select count(*)
         into vContador
         from tdvadm.t_edi_planilhaaut pa
        where TRIM(pa.edi_planilhacfg_codigo)   = trim(vMsg)
          and TRIM(pa.edi_planilhacfg_sistema)  = trim(vMsg)
          and pa.edi_planilhaaut_autoriza = 'S'
          and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
          and pa.edi_planilhaaut_ativo    = 'S'
          and pa.edi_planilhaaut_vigencia <= sysdate
          and pa.edi_planilhaaut_validate >= sysdate;
                     
       -- verifica se pode autorizar                      
       If vContador > 0 Then 
          
          if vSistema = 'ANTTINDISP' then
             
             if vAcao = 'LIBERA' then
               
                select count(*)
                  into vExiste 
                  from tdvadm.t_usu_perfil pp
                 where trim(pp.usu_perfil_codigo) = trim(vSistema);
                                    
                if vExiste > 0 then
                  
                   update t_usu_perfil pp
                      set pp.usu_perfil_parat  = 'S'
                    where pp.usu_perfil_codigo = vSistema;
                    
                    
                   vStatus     := 'N';
                   vMessage    := chr(10) || chr(10) || 'Parametro liberado com sucesso!!' || chr(10) || chr(10);
                   tpRecebido.Glb_Benasserec_Processado := Sysdate;
                   tpRecebido.Glb_Benasserec_Status     := 'OK'; 
                  
                else
                   
                   vStatus     := 'E';
                   vMessage    := chr(10) || chr(10) || 'Parametro não existe !!' || chr(10) || chr(10);
                   tpRecebido.Glb_Benasserec_Processado := Sysdate;
                   tpRecebido.Glb_Benasserec_Status     := 'ER';
                   
                end if;
              
             elsif vAcao = 'TRAVA' then
             
                select count(*)
                  into vExiste 
                  from tdvadm.t_usu_perfil pp
                 where trim(pp.usu_perfil_codigo) = trim(vSistema);
                                    
                if vExiste > 0 then
                  
                   update t_usu_perfil pp
                      set pp.usu_perfil_parat  = 'N'
                    where pp.usu_perfil_codigo = vSistema;
                  
                 
                   vStatus     := 'N';
                   vMessage    := chr(10) || chr(10) || 'Parametro Bloqueado com sucesso!!' || chr(10) || chr(10);
                   tpRecebido.Glb_Benasserec_Processado := Sysdate;
                   tpRecebido.Glb_Benasserec_Status     := 'OK';                            
                  
                else
                   
                   vStatus     := 'E';
                   vMessage    := chr(10) || chr(10) || 'Parametro não existe !!' || chr(10) || chr(10);
                   tpRecebido.Glb_Benasserec_Processado := Sysdate;
                   tpRecebido.Glb_Benasserec_Status     := 'ER';
                   
                end if;

             end if;
                                    
          end if;
          
            
       Else
          vStatus     := 'E';
          vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'ER';
       End If;                                               

       wservice.pkg_glb_email.SP_ENVIAEMAIL('Mudanca de Status de Parametro: '||vPerfil,
                                            vMessage,
                                            'tdv.producao@dellavolpe.com.br',
                                            tpRecebido.glb_benasserec_origem);

   End sp_processa_Altparametro;
   
   Procedure sp_processa_IncPracaPTOCOM(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                        vStatus  Out Char,
                                        vMessage Out clob)
   AS
     vQryString   varchar2(500);
     vSistema     varchar(20);
     vAcao        varchar2(20);
     vOrigem      tdvadm.t_glb_localidade.glb_localidade_codigo%type;
     vDestino     tdvadm.t_glb_localidade.glb_localidade_codigo%type;
     vFRPSVO75    tdvadm.t_slf_calcfretekm.slf_calcfretekm_valor%type;   
     vDES75       tdvadm.t_slf_calcfretekm.slf_calcfretekm_desinencia%type;
     vFRPSVO      tdvadm.t_slf_calcfretekm.slf_calcfretekm_valor%type;
     vDES         tdvadm.t_slf_calcfretekm.slf_calcfretekm_desinencia%type;
     vOT3         tdvadm.t_slf_calcfretekm.slf_calcfretekm_valor%type;
     vDESOT3      tdvadm.t_slf_calcfretekm.slf_calcfretekm_desinencia%type;
     vADVL        tdvadm.t_slf_calcfretekm.slf_calcfretekm_valor%type;
     vDESADVL     tdvadm.t_slf_calcfretekm.slf_calcfretekm_desinencia%type;
     vDP          tdvadm.t_slf_calcfretekm.slf_calcfretekm_valor%type;
     vDESDP       tdvadm.t_slf_calcfretekm.slf_calcfretekm_desinencia%type;
     vExiste      integer;
     vContador    INTEGER;
     vAtivo       T_USU_APLICACAOPERFIL.USU_APLICACAOPERFIL_ATIVO%type;
     vDescOrigem  tdvadm.t_glb_localidade.glb_localidade_descricao%type;
     vIBGEOrigem  tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
     vDescDestino tdvadm.t_glb_localidade.glb_localidade_descricao%type;
     vIBGEDestino tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
     vTabela      tdvadm.t_slf_tabela.slf_tabela_codigo%type;
     vSaque       tdvadm.t_slf_tabela.slf_tabela_codigo%type;
     tpCalcFrete  tdvadm.t_slf_calcfretekm%rowtype;
     i            integer;
     vCursor      T_CURSOR;
     vLinha      pkg_glb_SqlCursor.tpString1024;

   Begin
   
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
 -- MSG=PONTOCOM;ORI=0100;DES=3000;FRPSVO75=67.49;DESF75=U;FRPSVO=0.75;DESF=T;OT3=0.1;DESOT3=T;ADVL=0.6;DESADVL=T;DP=12;DESDEP=U

       vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));  
       vSistema    := Trim(tdvadm.fn_querystring(vQryString,'MSG','=',';'));
       vAcao       := NVL(Trim(tdvadm.fn_querystring(vQryString,'ACAO','=',';')),'INCLUIR');
       vORIGEM     := Trim(tdvadm.fn_querystring(vQryString,'ORI','=',';'));
       vDESTINO    := Trim(tdvadm.fn_querystring(vQryString,'DES','=',';'));
       vFRPSVO75   := Trim(replace(tdvadm.fn_querystring(vQryString,'FRPSVO75','=',';'),',','.'));   
       vDES75      := Trim(tdvadm.fn_querystring(vQryString,'DESF75','=',';'));
       vFRPSVO     := Trim(replace(tdvadm.fn_querystring(vQryString,'FRPSVO','=',';'),',','.'));
       vDES        := Trim(tdvadm.fn_querystring(vQryString,'DESF','=',';'));
       vOT3        := Trim(replace(tdvadm.fn_querystring(vQryString,'OT3','=',';'),',','.'));
       vDESOT3     := Trim(tdvadm.fn_querystring(vQryString,'DESOT3','=',';'));
       vADVL       := Trim(replace(tdvadm.fn_querystring(vQryString,'ADVL','=',';'),',','.'));
       vDESADVL    := Trim(tdvadm.fn_querystring(vQryString,'DESADVL','=',';'));
       vDP         := Trim(replace(tdvadm.fn_querystring(vQryString,'DP','=',';'),',','.'));
       vDESDP      := Trim(tdvadm.fn_querystring(vQryString,'DESDP','=',';'));

       
      select count(*)
        into vContador
        from tdvadm.t_edi_planilhaaut pa
       where trim(pa.edi_planilhacfg_codigo) = vSistema
         and trim(pa.edi_planilhacfg_sistema) = vSistema
         and pa.edi_planilhaaut_autoriza = 'S'
         and instr(lower(tpRecebido.Glb_Benasserec_Origem),lower(pa.edi_planilhaaut_email)) > 0 
         and pa.edi_planilhaaut_ativo = 'S'
         and pa.edi_planilhaaut_vigencia <= sysdate
         and pa.edi_planilhaaut_validate >= sysdate;
                   
          -- verifica se pode autorizar                      
          If vContador > 0 Then 
            
              if vAcao = 'LISTAR' Then 
                 
                 open vCursor FOR select kk.slf_tabela_codigo TABELA,
                                         kk.slf_tabela_saque SAQ,
                                         kk.slf_calcfretekm_origem || '-' || lo.glb_estado_codigo || '-' || lo.glb_localidade_descricao origem,
                                         kk.slf_calcfretekm_destino || '-' || ld.glb_estado_codigo || '-' || ld.glb_localidade_descricao destino,
                                         sum(decode(trim(kk.slf_reccust_codigo),'D_FRPSVO',nvl(kk.slf_calcfretekm_valor,0),0)) FRETE,
                                         max(decode(trim(kk.slf_reccust_codigo),'D_FRPSVO',kk.slf_calcfretekm_desinencia,0)) FRETEDES,
                                         sum(decode(trim(kk.slf_reccust_codigo),'D_FRPSVO',nvl(kk.slf_calcfretekm_valore,0),0)) FRETE75,
                                         max(decode(trim(kk.slf_reccust_codigo),'D_FRPSVO',kk.slf_calcfretekm_desinenciae,0)) FRETE75DES,
                                         sum(decode(trim(kk.slf_reccust_codigo),'D_DP',nvl(kk.slf_calcfretekm_valor,0),0)) DESPACHO,
                                         max(decode(trim(kk.slf_reccust_codigo),'D_DP',kk.slf_calcfretekm_desinencia,0)) DESPACHODES,
                                         sum(decode(trim(kk.slf_reccust_codigo),'D_ADVL',nvl(kk.slf_calcfretekm_valor,0),0)) ADVL,
                                         max(decode(trim(kk.slf_reccust_codigo),'D_ADVL',kk.slf_calcfretekm_desinencia,0)) ADVLDES,
                                         sum(decode(trim(kk.slf_reccust_codigo),'D_OT3',nvl(kk.slf_calcfretekm_valor,0),0)) GRIS,
                                         max(decode(trim(kk.slf_reccust_codigo),'D_OT3',kk.slf_calcfretekm_desinencia,0)) GRISDES,
                                         tpc.slf_tpcodigo_descricao calculo
                                  from tdvadm.t_slf_calcfretekm kk,
                                       tdvadm.t_glb_localidade lo,
                                       tdvadm.t_glb_localidade ld,
                                       tdvadm.t_slf_tpcalculo tpc
                                  where kk.slf_tabela_codigo = 'C2015080004'
                                    and kk.slf_tabela_saque = '0001'
                                    and kk.slf_tpcalculo_codigo = tpc.slf_tpcalculo_codigo
                                    and trim(kk.slf_reccust_codigo) in ('D_DP','D_FRPSVO','D_ADVL','D_DP','D_OT3')
                                    and kk.slf_calcfretekm_pesode = 76
                                    and kk.slf_calcfretekm_origem = lo.glb_localidade_codigo
                                    and kk.slf_calcfretekm_destino = ld.glb_localidade_codigo
                                  group by kk.slf_tabela_codigo,
                                           kk.slf_tabela_saque,
                                           kk.slf_calcfretekm_origem || '-' || lo.glb_estado_codigo || '-' || lo.glb_localidade_descricao ,
                                           kk.slf_calcfretekm_destino || '-' || ld.glb_estado_codigo || '-' || ld.glb_localidade_descricao,
                                           tpc.slf_tpcodigo_descricao;

                 

                 pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
                 pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
                 pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha);
                 for i in 1 .. vLinha.count loop
                    if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                       vMessage := vMessage || vLinha(i);
                    Else
                       vMessage := vMessage || vLinha(i) || chr(10);
                    End if;
                 End loop; 


              Else      
                 -- verifica a praca de Origem
                 begin
                    select l.glb_estado_codigo || '-' || trim(l.glb_localidade_descricao),
                           l.glb_localidade_codigoibge
                      into vDescOrigem,
                           vIBGEOrigem
                    From tdvadm.t_glb_localidade l
                    where l.glb_localidade_codigo = vOrigem;   
                    if vIBGEOrigem is null Then
                       vStatus := pkg_glb_common.Status_Erro;
                       vMessage := vMessage || ' Praca de origem Sem IBGE - '  || vOrigem || chr(10);                  
                    End If;                   
                 exception
                   when NO_DATA_FOUND Then
                       vDescOrigem := '';             
                       vStatus := pkg_glb_common.Status_Erro;
                       vMessage := vMessage || ' Praca de origem não encontrada - '  || vOrigem || chr(10);                  
                   When OTHERS Then 
                       vDescOrigem := '';             
                       vStatus := pkg_glb_common.Status_Erro;
                       vMessage := vMessage || ' Ocorreu erro pegando a Origem ' || sqlerrm || chr(10);                  
                   End;
                 -- verifica a praca de Destino
                 begin
                    select l.glb_estado_codigo || '-' || trim(l.glb_localidade_descricao),
                           l.glb_localidade_codigoibge
                      into vDescDestino,
                           vIBGEDestino
                    From tdvadm.t_glb_localidade l
                    where l.glb_localidade_codigo = vDestino;    
                    if vIBGEDestino is null Then
                       vStatus := pkg_glb_common.Status_Erro;
                       vMessage := vMessage || ' Praca de destino Sem IBGE - '  || vDestino || chr(10);                  
                    End If;                   
                 exception
                   when NO_DATA_FOUND Then
                       vDescOrigem := '';             
                       vStatus := pkg_glb_common.Status_Erro;
                       vMessage := vMessage || ' Praca de Destino não encontrada - '  || vDestino || chr(10);                  
                   When OTHERS Then 
                       vDescOrigem := '';             
                       vStatus := pkg_glb_common.Status_Erro;
                       vMessage := vMessage || ' Ocorreu erro pegando o Destino ' || sqlerrm || chr(10);                  
                   End;
                   
                   if vStatus <> pkg_glb_common.Status_Erro Then 
                      -- pega qual tabela usar
                      select ta.slf_tabela_codigo,
                             max(ta.slf_tabela_saque)
                          into vTabela,
                               vSaque    
                      from tdvadm.t_slf_tabela ta
                      where ta.glb_cliente_cgccpfcodigo = '99999999999999'
                        and ta.glb_grupoeconomico_codigo = '0563'
                        and ta.slf_tabela_tipo = 'CIF'
                      group by ta.slf_tabela_codigo;  
                      If vSaque is null Then
                         vStatus := pkg_glb_common.Status_Erro;
                         vMessage := vMessage || 'Tabela de Frete não localizada ' || chr(10);                  
                      End If;                  
                  
                   End If;
                   if vStatus <> pkg_glb_common.Status_Erro Then 
                      -- Verifica se temos a praça
                      select count(*)
                         into vContador
                      from tdvadm.t_slf_calcfretekm cf
                      where cf.slf_tabela_codigo =  vTabela
                        and cf.slf_tabela_saque  =  vSaque
                        and cf.slf_calcfretekm_origem = vOrigem
                        and cf.slf_calcfretekm_destino = vDestino;
                        if vContador >= 4 Then 
                           vStatus := pkg_glb_common.Status_Erro;
                           vMessage := vMessage || 'Origem e Destino Já Cadastrado ' || chr(10);  
                           vMessage := vMessage || '*********************************************************' || CHR(10);
                           vMessage := vMessage || 'ORIGEM       ' || vOrigem || '-' || vDescOrigem || CHR(10);
                           vMessage := vMessage || 'DESTINO      ' || vDestino || '-' || vDescDestino || CHR(10);
                           for c_msg in (SELECT k.slf_reccust_codigo,
                                                k.slf_calcfretekm_valor,
                                                k.slf_calcfretekm_desinencia,
                                                k.slf_calcfretekm_valore,
                                                k.slf_calcfretekm_desinenciae
                                         FROM tdvadm.T_SLF_CALCFRETEKM K
                                         where k.slf_tabela_codigo =  vTabela
                                           and k.slf_tabela_saque  =  vSaque
                                           and k.slf_calcfretekm_origem = vOrigem
                                           and k.slf_calcfretekm_destino = vDestino
                                           AND k.slf_calcfretekm_pesode = 76 
                                          order by k.slf_calcfretekm_valor desc)
                             Loop 
                               if c_msg.slf_reccust_codigo = 'D_FRPSVO' Then
                                  vMessage := vMessage || 'FRETE ATE 75 ' || f_mascara_valor(c_msg.slf_calcfretekm_valor,10,2) || ' ' || c_msg.slf_calcfretekm_desinencia || CHR(10);
                                  vMessage := vMessage || 'FRETE EXCED  ' || f_mascara_valor(c_msg.slf_calcfretekm_valore,10,2) || ' ' || c_msg.slf_calcfretekm_desinenciae || ' POR TON' || CHR(10);
                               End If;
                               
                               if c_msg.slf_reccust_codigo = 'D_ADVL' Then
                                  vMessage := vMessage || 'ADVL         ' || f_mascara_valor(c_msg.slf_calcfretekm_valor,10,2) || ' ' || c_msg.slf_calcfretekm_desinencia || CHR(10);
                               ElsIf c_msg.slf_reccust_codigo = 'D_DP' Then  
                                  vMessage := vMessage || 'DESPACHO     ' || f_mascara_valor(c_msg.slf_calcfretekm_valor,10,2) || ' ' || c_msg.slf_calcfretekm_desinencia || CHR(10);
                               Elsif c_msg.slf_reccust_codigo = 'D_OT3' Then
                                  vMessage := vMessage || 'GRIS         ' || f_mascara_valor(c_msg.slf_calcfretekm_valor,10,2) || ' ' || c_msg.slf_calcfretekm_desinencia || CHR(10);
                               End If;
                             End loop;
                               vMessage := vMessage || '*********************************************************' || CHR(10);
                        ElsIf vContador = 0 Then 
                            -- esta so é para criar o Tipo 
                            -- vou colocar 01000 são paulo
                            select *
                              into tpCalcFrete
                            from tdvadm.t_slf_calcfretekm cf
                            where cf.slf_tabela_codigo      =  vTabela
                              and cf.slf_tabela_saque       =  vSaque
                              and cf.slf_calcfretekm_origem = '01000'
                              and cf.slf_reccust_codigo     = 'D_FRPSVO'
                              and rownum = 1;
                              
                            -- Parte que Não muda independente da VERBA  
                            tpCalcFrete.Slf_Calcfretekm_Origem      := vOrigem;
                            tpCalcFrete.Slf_Calcfretekm_Origemi     := vIBGEOrigem;
                            tpCalcFrete.Slf_Calcfretekm_Destino     := vDestino;
                            tpCalcFrete.Slf_Calcfretekm_Destinoi    := vIBGEDestino;

                            -- Frete
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 1;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 75;
                            tpCalcFrete.Slf_Reccust_Codigo          := 'D_FRPSVO';
                            tpCalcFrete.Slf_Calcfretekm_Valor       := vFRPSVO75;
                            if vDES75 = 'U' Then
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'VL';
                            Elsif vDES75 = 'T' Then  
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'TX';
                            Else
                               vStatus := pkg_glb_common.Status_Erro;
                               vMessage := vMessage || 'Erro Na DESINENCIA DO FRETE ATE 75 ' || chr(10);                  
                            End If;   
                            tpCalcFrete.Slf_Calcfretekm_Valore      := 0;
                            tpCalcFrete.Slf_Calcfretekm_Desinenciae := 'TX';
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   
                            
                            
                            
                            
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 76;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 50000;
                            tpCalcFrete.Slf_Reccust_Codigo          := 'D_FRPSVO';
                            tpCalcFrete.Slf_Calcfretekm_Valor       := vFRPSVO75;
                            if vDES75 = 'U' Then
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'VL';
                            Elsif vDES75 = 'T' Then  
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'TX';
                            End If;   
                            tpCalcFrete.Slf_Calcfretekm_Valore      := vFRPSVO * 1000;
                            if vDES = 'U' Then
                               tpCalcFrete.Slf_Calcfretekm_Desinenciae := 'VL';
                            Elsif vDES = 'T' Then  
                               tpCalcFrete.Slf_Calcfretekm_Desinenciae := 'TX';
                            Else
                               vStatus := pkg_glb_common.Status_Erro;
                               vMessage := vMessage || 'Erro Na DESINENCIA DO FRETE ACIMA 75' || chr(10);                  
                            End If;                                                        

                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   


                            -- AdValorem
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 1;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 75;
                            tpCalcFrete.Slf_Reccust_Codigo          := 'D_ADVL';
                            tpCalcFrete.Slf_Calcfretekm_Valor       := vADVL;
                            if vDESADVL = 'U' Then
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'VL';
                            Elsif vDESADVL = 'T' Then  
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'TX';
                            Else
                               vStatus := pkg_glb_common.Status_Erro;
                               vMessage := vMessage || 'Erro Na DESINENCIA DO ADVL ' || chr(10);                  
                            End If;   
                            tpCalcFrete.Slf_Calcfretekm_Valore      := 0;
                            tpCalcFrete.Slf_Calcfretekm_Desinenciae := 'TX';
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   
                            
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 76;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 50000;
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   


                            -- Despacho
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 1;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 75;
                            tpCalcFrete.Slf_Reccust_Codigo          := 'D_DP';
                            tpCalcFrete.Slf_Calcfretekm_Valor       := vDP;
                            if vDESDP = 'U' Then
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'VL';
                            Elsif vDESDP = 'T' Then  
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'TX';
                            Else
                               vStatus := pkg_glb_common.Status_Erro;
                               vMessage := vMessage || 'Erro Na DESINENCIA DO DESPACHO ATE 75 ' || chr(10);                  
                            End If;   
                            tpCalcFrete.Slf_Calcfretekm_Valore      := 0;
                            tpCalcFrete.Slf_Calcfretekm_Desinenciae := 'TX';
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   
                            
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 76;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 50000;
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   


                            -- Despacho
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 1;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 75;
                            tpCalcFrete.Slf_Reccust_Codigo          := 'D_DP';
                            tpCalcFrete.Slf_Calcfretekm_Valor       := vDP;
                            if vDESDP = 'U' Then
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'VL';
                            Elsif vDESDP = 'T' Then  
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'TX';
                            Else
                               vStatus := pkg_glb_common.Status_Erro;
                               vMessage := vMessage || 'Erro Na DESINENCIA DO DESPACHO ATE 75 ' || chr(10);                  
                            End If;   
                            tpCalcFrete.Slf_Calcfretekm_Valore      := 0;
                            tpCalcFrete.Slf_Calcfretekm_Desinenciae := 'TX';
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   
                            
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 76;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 50000;
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   


                            -- Despacho
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 1;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 75;
                            tpCalcFrete.Slf_Reccust_Codigo          := 'D_OT3';
                            tpCalcFrete.Slf_Calcfretekm_Valor       := vOT3;
                            if vDESOT3 = 'U' Then
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'VL';
                            Elsif vDESOT3 = 'T' Then  
                               tpCalcFrete.Slf_Calcfretekm_Desinencia := 'TX';
                            Else
                               vStatus := pkg_glb_common.Status_Erro;
                               vMessage := vMessage || 'Erro Na DESINENCIA DO CRIS/OUTROS3 ATE 75 ' || chr(10);                  
                            End If;   
                            tpCalcFrete.Slf_Calcfretekm_Valore      := 0;
                            tpCalcFrete.Slf_Calcfretekm_Desinenciae := 'TX';
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   
                            
                            tpCalcFrete.Slf_Calcfretekm_Pesode      := 76;
                            tpCalcFrete.Slf_Calcfretekm_Pesoate     := 50000;
                            
                            Begin
                               insert into t_slf_calcfretekm values  tpCalcFrete;
                            exception
                              When DUP_VAL_ON_INDEX  Then
                                 vStatus := pkg_glb_common.Status_Erro;
                                 vMessage := vMessage || 'Verifique Duplicidade da Chave ' || chr(10) || 
                                             'TABELA - ' || tpCalcFrete.SLF_TABELA_CODIGO || chr(10) || 
                                             'SAQUE - ' || tpCalcFrete.SLF_TABELA_SAQUE || chr(10) ||
                                             'KMDE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMDE || chr(10) || 
                                             'KMATE - ' || tpCalcFrete.SLF_CALCFRETEKM_KMATE || chr(10) || 
                                             'PESODE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESODE || chr(10) || 
                                             'PESOATE - ' || tpCalcFrete.SLF_CALCFRETEKM_PESOATE || chr(10) || 
                                             'TPCALCULO - ' || tpCalcFrete.SLF_TPCALCULO_CODIGO || chr(10) || 
                                             'RECCUST - ' || tpCalcFrete.SLF_RECCUST_CODIGO || chr(10) || 
                                             'ORIGEM - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEM || chr(10) || 
                                             'DESTINO - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINO || chr(10) || 
                                             'ORIGEMI - ' || tpCalcFrete.SLF_CALCFRETEKM_ORIGEMI || chr(10) || 
                                             'DESTINOI - ' || tpCalcFrete.SLF_CALCFRETEKM_DESTINOI || chr(10);
                              End;   
                            
                            if vStatus <> pkg_glb_common.Status_Erro Then
                               commit;
                               vMessage := vMessage || '*********************************************************' || CHR(10);
                               vMessage := vMessage || 'ORIGEM       ' || vOrigem || '-' || vDescOrigem || CHR(10);
                               vMessage := vMessage || 'DESTINO      ' || vDestino || '-' || vDescDestino || CHR(10);
                               vMessage := vMessage || 'FRETE ATE 75 ' || f_mascara_valor(vFRPSVO75,10,2) || ' ' || vDES75 || CHR(10);
                               vMessage := vMessage || 'FRETE EXCED  ' || f_mascara_valor(vFRPSVO * 1000,10,2) || ' ' || vDES || ' POR TON' || CHR(10);
                               vMessage := vMessage || 'DESPACHO     ' || f_mascara_valor(vDP,10,2) || ' ' || vDESDP || CHR(10);
                               vMessage := vMessage || 'ADVL         ' || f_mascara_valor(vADVL,10,2) || ' ' || vDESADVL || CHR(10);
                               vMessage := vMessage || 'GRIS         ' || f_mascara_valor(vOT3,10,2) || ' ' || vDESOT3 || CHR(10);
                               vMessage := vMessage || '*********************************************************' || CHR(10);
                            End If;   

      



                           
                        End If;   
                                
                   End If;   
               End IF;                   
          Else
             vStatus := pkg_glb_common.Status_Erro;
             vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
             tpRecebido.Glb_Benasserec_Processado := Sysdate;
             tpRecebido.Glb_Benasserec_Status     := 'ER';
          End If;                                               

          if vAcao <> 'LISTAR' Then 
             wservice.pkg_glb_email.SP_ENVIAEMAIL('CADASTRAMENTO DE PRACA PONTO COM',
                                                  vMessage,
                                                  'tdv.producao@dellavolpe.com.br',
                                                  tpRecebido.glb_benasserec_origem);
          End If;                                        


   End sp_processa_IncPracaPTOCOM;
   
   Procedure sp_altera_pagamentoparacheque(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                          vStatus Out Char,
                                          vMessage Out Varchar2)
  As                                    
    vQryString    varchar2(500);
    vNumero       Char(6);
    vSerie        Char(2);
    vRota         Char(3);
    vSaque        Char(1);
    vContador     Number;
    vSeq          Number;
  ---------------------------------------------------------------------------
  ------------- CREATE BY JONATAS VELOSO SIQUEIRA 21/12/2018 ----------------
  ---------------------------------------------------------------------------   
  Begin           
     --Populo as variáveis, para recuperar os paramentros passados.
     vQryString := tpRecebido.GLB_BENASSEREC_ASSUNTO;
     vNumero    := tdvadm.fn_querystring(vQryString, 'NUMERO','=',';');
     vSerie     := tdvadm.fn_querystring(vQryString, 'SERIE','=',';');
     vRota      := tdvadm.fn_querystring(vQryString, 'ROTA','=',';');
    vSaque     := tdvadm.fn_querystring(vQryString, 'SAQUE','=',';');
     --Verifico se o usuário tem autorização.
     select count(*)
       into vContador
       from tdvadm.t_edi_planilhaaut p
      where p.edi_planilhacfg_codigo = 'ALTVFCHEQUE'
        and p.edi_planilhaaut_email = tpRecebido.glb_benasserec_origem;  
     
     if ( vContador > 0) Then
        BEGIN
                
            select TE.CON_CALCVALEFRETE_SEQ 
              into vSeq                     
              from tdvadm.t_con_calcvalefrete te,
                   tdvadm.t_con_calcvalefretetp tp 
             where te.con_conhecimento_codigo   = vNumero
               and te.glb_rota_codigo           = vRota
               and te.con_conhecimento_serie    = vSerie
               and te.con_valefrete_saque       = vSaque
               and te.usu_usuario_bloqueou is not null
               and te.con_calcvalefretetp_codigo = tp.con_calcvalefretetp_codigo
               and tp.con_calcvalefretetp_codpamcary is not null
               and 0 < (select count(*)
                          from tdvadm.t_con_valefrete t
                         where t.con_conhecimento_codigo = vNumero
                           and t.con_conhecimento_serie = vSerie
                           and t.glb_rota_codigo = vRota
                           and t.con_valefrete_saque = vSaque
                           and t.con_valefrete_status is null
                           and t.con_valefrete_impresso = 'S'); 

            UPDATE tdvadm.t_con_calcvalefrete te
               SET te.con_calcvalefrete_tipo = 'H'
             WHERE TE.CON_CONHECIMENTO_CODIGO = vNumero
               AND TE.CON_CONHECIMENTO_SERIE  = vSerie
               AND TE.GLB_ROTA_CODIGO         = vRota
               AND TE.CON_VALEFRETE_SAQUE     = vSaque
               AND TE.CON_CALCVALEFRETE_SEQ   = vSeq;
               
            vMessage := 'ALTERADO COM SUCESSO!';
            wservice.pkg_glb_email.SP_ENVIAEMAIL('Sucesso na alteração para pagamento no Cheque',
                                                 vMessage,
                                                 'tdv.producao@dellavolpe.com.br',
                                                 trim(tpRecebido.glb_benasserec_origem));
            tpRecebido.Glb_Benasserec_Processado := Sysdate;
            tpRecebido.Glb_Benasserec_Status     := 'OK';      
         
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
           vMessage := 'Não encontrado Verba Bloqueada' ||
                       chr(10) || 'Vale Frete: ' || vNumero || chr(10) ||
                       'Serie:      ' || vSerie || chr(10) || 'Rota: ' ||
                       vRota || chr(10) || 'Saque: ' || vSaque || chr(10);
           wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao realizar Exclusão de Previa',
                                                vMessage,
                                                'tdv.producao@dellavolpe.com.br',
                                                trim(tpRecebido.glb_benasserec_origem));
           tpRecebido.Glb_Benasserec_Processado := Sysdate;
           tpRecebido.Glb_Benasserec_Status     := 'ER'; 
          When OTHERS Then  
          -- Caso dê este problema, provavelmente é porque o select está retornando mais de um registro, uma opção para resolver seria
          -- passar também o tipo se é Saldo, Adiantamento ou outra tarifa...
           vMessage := 'Houve Algum problema na Rotina, Favor entrar em contato Com o Jonatas Do HelpDesk' ||
                       chr(10) || 'Vale Frete: ' || vNumero || chr(10) ||
                       'Serie:      ' || vSerie || chr(10) || 'Rota: ' ||
                       vRota || chr(10) || 'Saque: ' || vSaque || chr(10);
           wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao realizar Exclusão de Previa',
                                                vMessage,
                                                'tdv.producao@dellavolpe.com.br',
                                                trim(tpRecebido.glb_benasserec_origem));
           tpRecebido.Glb_Benasserec_Processado := Sysdate;
           tpRecebido.Glb_Benasserec_Status     := 'ER';
        End;
     Else
        vMessage := 'EMAIL NÃO AUTORIZADO PARA ALTERAÇÃO';
        wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao realizar Alteração para pagamento no Cheque',
                                             vMessage,
                                             'tdv.producao@dellavolpe.com.br',
                                             trim(tpRecebido.glb_benasserec_origem));
        tpRecebido.Glb_Benasserec_Processado := Sysdate;
        tpRecebido.Glb_Benasserec_Status     := 'ER';        
     end if;
     
     
  End sp_altera_pagamentoparacheque;
  
  Procedure sp_arm_reabrirplacamobile(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                              vStatus Out Char,
                              vMessage Out Varchar2)
  As                                    
    vQryString    varchar2(500);
    vPlaca        Char(7);
    vContador     Number;
    vVeicDisp     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
    vSeq          tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
    vFlagVF       tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_flagvalefrete%type;
    vEstagio      tdvadm.t_fcf_veiculodisp.arm_estagiocarregmob_codigo%type;
    
  ---------------------------------------------------------------------------
  ------------- CREATE BY JONATAS VELOSO SIQUEIRA 19/01/2019 ----------------
  ---------------------------------------------------------------------------   
  Begin           
     --Populo as variáveis, para recuperar os paramentros passados.
     vQryString := tpRecebido.GLB_BENASSEREC_ASSUNTO;
     vPlaca     := tdvadm.fn_querystring(vQryString, 'PLACA','=',';');
     --Verifico se o usuário tem autorização.
     select count(*)
       into vContador
       from tdvadm.t_edi_planilhaaut p
      where p.edi_planilhacfg_codigo = 'REABREPLACA'
        and p.edi_planilhaaut_email = tpRecebido.glb_benasserec_origem;  
     
     if ( vContador > 0) Then
        BEGIN
            -- PEGO O MAIOR VEICULO DISP 
            select vd.fcf_veiculodisp_codigo,
                   vd.fcf_veiculodisp_sequencia,
                   nvl(vd.fcf_veiculodisp_flagvalefrete,'N'),
                   nvl(vd.arm_estagiocarregmob_codigo,'N')
              into vVeicDisp, 
                   vSeq,
                   vFlagVF,
                   vEstagio       
              from tdvadm.t_fcf_veiculodisp vd
             where (vd.car_veiculo_placa = vPlaca
                or vd.frt_conjveiculo_codigo = vPlaca)
               and vd.fcf_veiculodisp_data = (select max(vei.fcf_veiculodisp_data)
                                               from tdvadm.t_fcf_veiculodisp vei
                                              where vei.car_veiculo_placa = vPlaca or vei.frt_conjveiculo_codigo = vPlaca);
                    
            vStatus := 'N'; -- Normal
        -- CASO TENHA SIDO PASSADO A PLACA OU CONJUNTO INCORRETO
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
           vMessage := 'Placa ou Conjunto Não Encontrado!' ||
                       chr(10) || 'Placa: ' || vPlaca || chr(10);
           tpRecebido.Glb_Benasserec_Processado := Sysdate;
           tpRecebido.Glb_Benasserec_Status     := 'ER'; 
           vStatus := 'E';
          When OTHERS Then  
           vMessage := 'Houve Algum problema na Rotina, Favor entrar em contato Com o Jonatas Veloso' ||
                       chr(10) || 'Placa: ' || vPlaca || chr(10);
           tpRecebido.Glb_Benasserec_Processado := Sysdate;
           tpRecebido.Glb_Benasserec_Status     := 'ER';
           vStatus := 'E';
        End;
     -- CASO O EMAIL NÃO TENHA LIBERAÇÃO
     Else 
        vMessage := 'EMAIL NÃO AUTORIZADO PARA REABRIR PLACA';
        tpRecebido.Glb_Benasserec_Processado := Sysdate;
        tpRecebido.Glb_Benasserec_Status     := 'ER';        
        vStatus := 'E';
     end if;
     
     IF(vStatus = 'N') THEN
       select count(*)
         into vContador
         from tdvadm.t_con_valefrete vf
        where vf.fcf_veiculodisp_codigo    = vVeicDisp
          and vf.fcf_veiculodisp_sequencia = vSeq
          and trim (vf.Con_Valefrete_Status) is null;
        
        IF(vContador > 0 or vFlagVF = 'S') THEN
          vMessage := 'Já Tem uma Vale de Frete para Criado! Impossível Reabrir!';
          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'ER';  
          vStatus := 'E';
        -- REABRINDO A PLACA
        ELSE
          IF (vEstagio = 'F') THEN
            UPDATE TDVADM.T_FCF_VEICULODISP VD
               SET VD.ARM_ESTAGIOCARREGMOB_CODIGO = 'R'
             WHERE VD.FCF_VEICULODISP_CODIGO    = vVeicDisp
               AND VD.FCF_VEICULODISP_SEQUENCIA = vSeq;
           
            UPDATE TDVADM.T_ARM_CARREGAMENTOVEIC CA
               SET CA.ARM_CARREGAMENTOVEIC_FINALIZ = 'N'
             WHERE CA.FCF_VEICULODISP_CODIGO    = vVeicDisp
               AND CA.FCF_VEICULODISP_SEQUENCIA = vSeq;
             
            COMMIT;
            vMessage := 'ALTERADO COM SUCESSO!';
            tpRecebido.Glb_Benasserec_Processado := Sysdate;
            tpRecebido.Glb_Benasserec_Status     := 'OK';
          ELSE 
            vMessage := 'PLACA NÃO ESTAVA FINALIZADA';
            tpRecebido.Glb_Benasserec_Processado := Sysdate;
            tpRecebido.Glb_Benasserec_Status     := 'ER';        
            vStatus := 'E';
          END IF;
        end if;
     END IF;    
     
     IF (vStatus = 'E') THEN
       wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO AO REABRIR PLACA',
                                            vMessage,
                                            'tdv.producao@dellavolpe.com.br',
                                            trim(tpRecebido.glb_benasserec_origem));
     ELSE 
       wservice.pkg_glb_email.SP_ENVIAEMAIL('SUCESSO AO REABRIR PLACA',
                                            vMessage,
                                            'tdv.producao@dellavolpe.com.br',
                                            trim(tpRecebido.glb_benasserec_origem));  
     END IF;
     
  End sp_arm_reabrirplacamobile;

procedure sp_arm_ocorestadia(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                vStatus Out Char,
                               vMessage Out Varchar2)
/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Faturamento
* PROGRAMA    : Coleta
* ANALISTA    : Victor, Kethlyn 
* PROGRAMADOR : Victor, Kethlyn
* CRIACAO     : 29/03/2019
* BANCO       : ORACLE
* SIGLAS      : ARM, CON, GLB, EDI
* DESCRICAO   : Realiza a troca de número ocorrência da coleta quando o conhecimento é para acerto
*             : de estadia sem vale de frete. 
---------------------------------------------------------------------------------------------------
*/


  As                                    
    vQryString  varchar2(500);
    vNumero     Char(6);
    vSerie      Char(2);
    vRota       Char(3);
    vColeta     Char(6);
    vCiclo      Char(3);
    vContador   Number;
    vContadorVf Number;
    vTitulo VARCHAR(50);
   
  Begin           
     --Populo as variáveis, para recuperar os paramentros passados.
     vQryString := tpRecebido.GLB_BENASSEREC_ASSUNTO;
     vNumero    := tdvadm.fn_querystring(vQryString, 'RPS','=',';');
     vSerie     := tdvadm.fn_querystring(vQryString, 'SERIE','=',';');
     vRota      := tdvadm.fn_querystring(vQryString, 'ROTA','=',';');
     vStatus   := 'N';
      
     
     --Verifico se o usuário tem autorização.
     select count(*)
       into vContador
       from tdvadm.t_edi_planilhaaut p
      where p.edi_planilhacfg_codigo = 'INCOCOR'
        and p.edi_planilhaaut_email = tpRecebido.glb_benasserec_origem;  
  
     select count(*)
       into vContadorVf
       from tdvadm.t_con_vfreteconhec vfc,
            tdvadm.t_con_valefrete vf
      where vfc.con_valefrete_codigo     = vf.con_conhecimento_codigo
        and vfc.con_conhecimento_serie   = vf.con_conhecimento_serie
        and vfc.glb_rota_codigo          = vf.glb_rota_codigo
        and vfc.con_valefrete_saque      = vf.con_valefrete_saque
        and nvl(vf.con_valefrete_status,'N') != 'C'
        and vfc.con_valefrete_codigo     = vNumero
        and vfc.con_valefrete_serie      = vSerie
        and vfc.glb_rota_codigovalefrete = vrota;
        
     If ( vContadorVf > 0) then
       
       vMessage := 'Documento já tem Vale de Frete, impossível prosseguir' || chr(10) || 
                  'RPS: '   || vNumero || chr(10) ||
                  'Serie: ' ||  vSerie || chr(10) ||
                  'Rota: '  ||   vRota || chr(10);
       vTitulo := 'Erro ao inserir ocorrência';
       vStatus := 'E';
        
     ELSif ( vContador > 0 ) Then
        BEGIN
          
          -- Busca através da RPS o número coleta e alimenta as variáveis.
          select co.arm_coleta_ncompra,
                 co.Arm_Coleta_Ciclo
            into vColeta,
                 vCiclo
            from tdvadm.t_con_conhecimento co
           where co.con_conhecimento_codigo = vNumero
             and co.con_conhecimento_serie  = vSerie
             and co.glb_rota_codigo = vRota ;
             
           -- Altera a ocorrência da coleta da RPS.
           update tdvadm.t_arm_coleta ct
              set ct.arm_coletaocor_codigo = '84'
            where ct.arm_coleta_ncompra  = vColeta
              and ct.arm_coleta_ciclo    = vCiclo;
             
           commit;
           
           vMessage := 'RPS: ' || vNumero || ' Serie: ' || vSerie || ' Rota: ' || vRota || ' Alterada para ocorrência 84.';
           vTitulo   := 'Ocorrência inserida com sucesso.';
       
        -- Retorna o erro caso não ache a RPS.
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
           vMessage := 'Não encontrado RPS' || chr(10) || 
                       'RPS: '   || vNumero || chr(10) ||
                       'Serie: ' ||  vSerie || chr(10) || 
                       'Rota: '  ||   vRota || chr(10);  
           vTitulo := 'Erro ao inserir ocorrência';
           vStatus := 'E';
           
         -- Caso dê algum outro erro, entro no exception abaixo.
         When OTHERS Then  
           vMessage := 'Houve algum problema na rotina, favor entrar em contato com o HelpDesk' || chr(10) || 
                       'RPS: '   || vNumero || chr(10) ||
                       'Serie: ' ||  vSerie || chr(10) ||
                       'Rota: '  ||   vRota || chr(10);
           vTitulo := 'Erro ao inserir ocorrência';
           vStatus := 'E';
        End;
   
     -- Retorna o erro caso o usuário não tenha o e-mail autorizado.    
     Else
        vMessage := 'Erro ao realizar Alteração de ocorrência, favor entrar em contato com o HelpDesk';
        vTitulo  := 'EMAIL NÃO AUTORIZADO PARA ALTERAÇÃO';  
        vStatus := 'E';   
     end if;
     
     -- Condição de retorno da mensagem de erro. 
     if (vStatus = 'E') THEN
        tpRecebido.Glb_Benasserec_Status     := 'ER'; 
     else  
        tpRecebido.Glb_Benasserec_Status     := 'OK'; 
     END if;
    
     wservice.pkg_glb_email.SP_ENVIAEMAIL(vTitulo,
                                          vMessage,
                                          'tdv.producao@dellavolpe.com.br',
                                          trim(tpRecebido.glb_benasserec_origem));
     tpRecebido.Glb_Benasserec_Processado := Sysdate;
     
  End sp_arm_ocorestadia;
  
  Procedure sp_con_geraanulador(P_PROTOCOLO in varchar2,
                                pStatus Out Char,
                                pMessage out clob) is
  /*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Administrativo
* PROGRAMA    : Anulador
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 25/11/2019
* BANCO       : ORACLE
* SIGLAS      : EDI, CON, GLB
* OWNERS      : TDVADM, RMADM
* DESCRICAO   : Processa o envio da planilha com a chave dos CTE's e gera o anulador na série "XXX"
*             : para o envio.
---------------------------------------------------------------------------------------------------
*/

 vTpRecebido rmadm.t_glb_benasserec%rowtype;
 vContador integer;
 vStatus   char;
 vMessage  clob;
 vTitulo   varchar2(100);
 
  begin
    
 vStatus  := 'N';
 vTitulo  := 'GERAR CTE ANULADOR';
    
  select *
    into vTpRecebido
    from rmadm.t_glb_benasserec be
   where be.glb_benasserec_chave = P_PROTOCOLO;
    
  select count (*)
   into vContador
   from tdvadm.t_edi_planilhaaut pl
  where pl.edi_planilhacfg_sistema = 'CTEANULA'
    and pl.edi_planilhaaut_email = vTpRecebido.glb_benasserec_origem;
    
    
    -- Verifico se o usuário possui permissão para executar o processo.   
    if (vContador > 0) then
         
       for c_msg in (select i.edi_integra_col01 chave
                       from tdvadm.t_edi_integra i
                      where i.edi_integra_protocolo = P_PROTOCOLO
                        and nvl(i.edi_integra_col01,0) <> 0)
     loop  
  
      tdvadm.sp_con_criaanulador (c_msg.chave,
                                  vStatus,
                                  vMessage);
                                  
     if vStatus = 'N' then
       pMessage := pMessage || ' CTE(s) anulador(es) emitido(s) com sucesso!!! ' || vMessage || chr(10);
       pStatus := vStatus;
       
       update rmadm.t_glb_benasserec be
          set be.glb_benasserec_status = 'OK',
              be.glb_benasserec_obs = pMessage
        where be.glb_benasserec_chave = P_PROTOCOLO;
        commit;
       
     else
       pMessage := pMessage || ' Não é possível emitir anulador(es), segue motivo: ' || vMessage || chr(10);
       pStatus := vStatus;
       
       update rmadm.t_glb_benasserec be
          set be.glb_benasserec_status = 'OK',
              be.glb_benasserec_obs = pMessage
        where be.glb_benasserec_chave = P_PROTOCOLO;
        commit;
       
     end if;
                        
     end loop;
  
    else
      
    pMessage:= 'VOCÊ NÃO TEM PERMISSÃO PARA EXECUTAR O PROCESSO, ENTRE EM CONTATO COM O SERVICE DESK';
    
       update rmadm.t_glb_benasserec be
          set be.glb_benasserec_status = 'OK',
              be.glb_benasserec_obs = pMessage
        where be.glb_benasserec_chave = P_PROTOCOLO;
        commit;
     
    end if;
    
    wservice.pkg_glb_email.SP_ENVIAEMAIL(vTitulo,
                                         pMessage,
                                         'rafael.aiti@dellavolpe.com.br',
                                         trim(vTpRecebido.glb_benasserec_origem));
    
    commit;
    
  end sp_con_geraanulador;
  
  Procedure sp_con_gerasubst(P_PROTOCOLO in varchar2,
                             pStatus Out Char,
                             pMessage out clob) is
  /*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Administrativo
* PROGRAMA    : Anulador
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 25/11/2019
* BANCO       : ORACLE
* SIGLAS      : EDI, CON, GLB
* OWNERS      : TDVADM, RMADM
* DESCRICAO   : Processa o envio da planilha com a chave dos CTE's e gera os substitutos na série "XXX"
*             : para o envio.
---------------------------------------------------------------------------------------------------
*/

 vTpRecebido rmadm.t_glb_benasserec%rowtype;
 vContador integer;
 vStatus   char;
 vMessage  clob;
 vTitulo   varchar2(100);
 
  begin
    
 vStatus  := 'N';
 vTitulo  := 'GERAR CTE SUBSTITUTO';
    
  select *
    into vTpRecebido
    from rmadm.t_glb_benasserec be
   where be.glb_benasserec_chave = P_PROTOCOLO;
    
  select count (*)
   into vContador
   from tdvadm.t_edi_planilhaaut pl
  where pl.edi_planilhacfg_sistema = 'CTESUBST'
    and pl.edi_planilhaaut_email = vTpRecebido.glb_benasserec_origem;
    
    
    -- Verifico se o usuário possui permissão para executar o processo.   
    if (vContador > 0) then
         
       for c_msg in (select i.edi_integra_col01 chave
                       from tdvadm.t_edi_integra i
                      where i.edi_integra_protocolo = P_PROTOCOLO
                        and nvl(i.edi_integra_col01,0) <> 0)
     loop  
  
      tdvadm.Sp_Con_Criasubstituto(c_msg.chave,
                                   vStatus,
                                   vMessage);
                                  
     if vStatus = 'N' then
       pMessage := pMessage || ' CTE(s) substituto(s) emitido(s) com sucesso!!! ' || vMessage || chr(10);
       pStatus := vStatus;
       
       update rmadm.t_glb_benasserec be
          set be.glb_benasserec_status = 'OK',
              be.glb_benasserec_obs = pMessage
        where be.glb_benasserec_chave = P_PROTOCOLO;
        commit;
       
     else
       pMessage := pMessage || ' Não é possível emitir substituto(s), segue motivo: ' || vMessage || chr(10);
       pStatus := vStatus;
       
       update rmadm.t_glb_benasserec be
          set be.glb_benasserec_status = 'OK',
              be.glb_benasserec_obs = pMessage
        where be.glb_benasserec_chave = P_PROTOCOLO;
        commit;
       
     end if;
                        
     end loop;
  
    else
      
    pMessage:= 'VOCÊ NÃO TEM PERMISSÃO PARA EXECUTAR O PROCESSO, ENTRE EM CONTATO COM O SERVICE DESK';
    
       update rmadm.t_glb_benasserec be
          set be.glb_benasserec_status = 'OK',
              be.glb_benasserec_obs = pMessage
        where be.glb_benasserec_chave = P_PROTOCOLO;
        commit;
     
    end if;
    
    wservice.pkg_glb_email.SP_ENVIAEMAIL(vTitulo,
                                         pMessage,
                                         'rafael.aiti@dellavolpe.com.br',
                                         trim(vTpRecebido.glb_benasserec_origem));
    
    commit;
    
  end sp_con_gerasubst;
  
  procedure sp_enviasemparar(TpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                                      pStatus Out Char,
                                                      pMessage out clob) is

/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Administrativo
* PROGRAMA    : Sem Parar TDV
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 20/11/2019
* BANCO       : ORACLE
* SIGLAS      : EDI, IPF, FRT
* OWNERS      : TDVADM, TDVIPF 
* DESCRICAO   : Processa o envio da planilha com as informações do Sem Parar e grava os registros
*             : na tabela para analise do setor de custo.
---------------------------------------------------------------------------------------------------
*/

 vContador     integer;
 vDuplicidade  integer;
 vPlacaExiste  integer;
 vTitulo       varchar(50);
 vContatmp     integer;
 vContaIntegra integer;
  
  begin

  pStatus := 'N';
  pMessage := '';
  vContador := 0;
  vDuplicidade := 0;
  vPlacaExiste := 0;
  vTitulo := 'PROCESSO SEM PARAR';
  TpRecebido.Glb_Benasserec_Status     := 'OK';
   
  --Verifico se existe liberação para o usuário enviar esse tipo de e-mail antes de executar o processo.   
       select count (*)
       into vContador
       from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = 'SEMPARAR'
        and pa.edi_planilhaaut_email  = TpRecebido.Glb_Benasserec_Origem;
        
        delete tdvipf.t_ipf_sparartmp;
        commit;
    
          --Monto o cursor para obter os dados da planilha que foram gravados na t_edi_integra
            for c_msg in  (select it.edi_integra_protocolo,
                                  it.edi_integra_sequencia,
                                  it.edi_integra_cliente,
                                  it.edi_integra_planilha,
                                  it.edi_integra_critica,
                                  it.edi_integra_processado,
                                  it.edi_integra_gravacao,
                                  it.edi_integra_col01 placa,
                                  it.edi_integra_col02 tag,
                                  it.edi_integra_col03 prefixo,
                                  it.edi_integra_col04 marca,
                                  it.edi_integra_col05 categoria,
                                  it.edi_integra_col06 data,
                                  it.edi_integra_col07 hora,
                                  it.edi_integra_col08 rodovia,
                                  it.edi_integra_col09 praca,
                          replace(it.edi_integra_col10,',','.') valor
                             from tdvadm.t_edi_integra it
                            where it.edi_integra_protocolo = tpRecebido.Glb_Benasserec_Chave
                              and trim(it.edi_integra_col01) <> 'PLACA')
                            
    loop
    
        if (vContador > 0) then
          
      --Verifico se já existe o registro na tabela do sem parar do IPF
           select count (*)
             into vDuplicidade
             from tdvipf.t_ipf_sparar sp
            where sp.ipf_sparar_placa = c_msg.placa
              and sp.ipf_sparar_data  = c_msg.data
              and sp.ipf_sparar_hora  = c_msg.hora
              and sp.ipf_sparar_tag   = c_msg.tag;
              
       --Verifico se a placa existe no nosso sistema.
            select count (*)
              into vPlacaExiste
              from tdvadm.t_frt_veiculo ve
             where trim (ve.frt_veiculo_placa) = c_msg.placa;
              
          if (vDuplicidade > 0) then
          
          --Caso o registro já exista na tabela.
          pMessage := pMessage || ' Registro do sem parar já existe e foi gravado no banco anteriormente! '
                               || ' Placa: ' || c_msg.placa || ' Data: ' || c_msg.data
                               || ' Hora: ' || c_msg.hora || ' Tag: ' || c_msg.tag || chr(10);
                       
          pStatus := 'E';
          
          else  
              
              if (vPlacaExiste = 0) then

                --Caso a placa não exista.
                pMessage := pMessage || ' Placa não existe no sistema TDV, verifique a placa ou entre em contato com setor operacional, Placa: '  || c_msg.placa || chr(10);
                
                pStatus := 'E';
              
              else

              insert into tdvipf.t_ipf_sparartmp
              values(c_msg.placa,
                     c_msg.tag,
                     c_msg.prefixo,
                     c_msg.marca,
                     c_msg.categoria,
                     c_msg.data,
                     c_msg.hora,
                     c_msg.rodovia,
                     c_msg.praca,
                     c_msg.valor);
                     commit;       
              
              end if;
              
          end if;
          
       --Atualizo a benasserec conforme o processo executado.
         
          TpRecebido.Glb_Benasserec_Obs := pMessage;
          TpRecebido.Glb_Benasserec_Processado := sysdate;
          
          If pStatus = 'N' Then
            
        update rmadm.t_glb_benasserec be
           set be.glb_benasserec_gravacao = sysdate,
               be.glb_benasserec_status = 'OK',
               be.glb_benasserec_obs = pMessage
         where be.glb_benasserec_chave = TpRecebido.Glb_Benasserec_Chave;
         
          Else
            
        update rmadm.t_glb_benasserec be
           set be.glb_benasserec_gravacao = sysdate,
               be.glb_benasserec_status = 'ER',
               be.glb_benasserec_obs = pMessage
         where be.glb_benasserec_chave = TpRecebido.Glb_Benasserec_Chave;
         
          End If;
        else            
          pMessage := 'VOCE NÃO POSSUI LIBERACAO PARA ESSE ENVIO, ENTRE EM CONTATO COM O SERVICE DESK';
        end if;
        
    end loop;
    
        pMessage := pMessage || ' Registros inseridos com sucesso!!!' ||chr(10);
    
    --Envio o e-mail para o usuário com as informações do que foi e não foi processado.
    
    wservice.pkg_glb_email.SP_ENVIAEMAIL(vTitulo,
                                         pMessage,
                                         'rafael.aiti@dellavolpe.com.br',
                                         trim(tpRecebido.glb_benasserec_origem));
    
    tpRecebido.Glb_Benasserec_Processado := Sysdate;

   insert into tdvipf.t_ipf_sparar
   select * from
   tdvipf.t_ipf_sparartmp;

    commit;

  end sp_enviasemparar;

procedure sp_transfctemanual(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                                      vStatus Out Char,
                                                      pMessage out varchar2) is

/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Operacional
* PROGRAMA    : CTE Digitação Manual
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 19/03/2019
* BANCO       : ORACLE
* SIGLAS      : ARM, CON
* DESCRICAO   : Realiza a transferência de CTE's sem embalagem (Digitação Manual) via aut-e para
*             : liberar o pagamento do motorista e lançamento no caixa.
---------------------------------------------------------------------------------------------------
*/

    vConhecimento tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
    vSerie        tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
    vRota         tdvadm.t_con_conhecimento.glb_rota_codigo%type;
    vMessage      clob;
    vCont         number;
    vContAux      number;
    vArmazem      tdvadm.t_arm_armazem.arm_armazem_codigo%type;
    vContador     number;
    vNumerovf     tdvadm.t_con_valefrete.con_conhecimento_codigo%type;
    vSerievf      tdvadm.t_con_valefrete.con_conhecimento_serie%type;
    vRotavf       tdvadm.t_con_Valefrete.glb_rota_codigo%type;
    vSaquevf      tdvadm.t_con_valefrete.con_valefrete_saque%type;
    
Begin    
  
       vConhecimento := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'CTE','=', ';');
       vSerie        := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'SERIE', '=', ';');
       vRota         := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'ROTA', '=', ';');
       vNumerovf     := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'VF','=',';');
       vSerievf      := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'SERIEVF','=',';');
       vRotavf       := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'ROTAVF', '=', ';');
       vSaquevf      := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'SAQUEVF','=',';');
       vArmazem      := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'ARMTRANSF', '=', ';');
       
--MSG=TRANSFCTE;CTE=165418;SERIE=A1;ROTA=160;VF=165418;SERIEVF=A1;ROTAVF=160;SAQUEVF=1;ARMTRANSF=06;
  
-- Verificar se esse usuário pode realizar o processo.

 select count(*)
       into vContador
       from tdvadm.t_edi_planilhaaut p
      where p.edi_planilhacfg_codigo = 'TRANSFCTE'
        and p.edi_planilhaaut_email = pTpRecebido.glb_benasserec_origem;

 if (vContador > 0) Then


-- Verificar se o CTE está autorizado e realmente é digitação manual

  select count (*)
    into vCont
    from  tdvadm.t_con_conhecimento co
    where co.con_conhecimento_codigo = vConhecimento
      and co.con_conhecimento_serie  = vserie
      and co.glb_rota_codigo         = vRota
      and trim (co.Arm_Carregamento_Codigo) is null
      and trim (co.con_conhecimento_flagcancelado) is null
      and co.con_conhecimento_serie <> 'XXX'
      and 0 = (select count (*) from
               tdvadm.t_arm_nota n
               where n.con_conhecimento_codigo = co.con_conhecimento_codigo
                 and n.con_conhecimento_serie  = co.con_conhecimento_serie
                 and n.glb_rota_codigo         = co.glb_rota_codigo);
                 
-- Verificar se o CTE já tem os comprovantes baixados

  select count (*)
    into vContAux
    from  tdvadm.t_con_conhecimento co
    where co.con_conhecimento_codigo = vConhecimento
      and co.con_conhecimento_serie  = vserie
      and co.glb_rota_codigo         = vRota
      and trim (co.Arm_Carregamento_Codigo) is null
      and trim (co.con_conhecimento_flagcancelado) is null
      and co.con_conhecimento_serie <> 'XXX'
      and 0 = (select count (*) from
               tdvadm.t_glb_compimagem n
               where n.con_conhecimento_codigo = co.con_conhecimento_codigo
                 and n.con_conhecimento_serie  = co.con_conhecimento_serie
                 and n.glb_rota_codigo         = co.glb_rota_codigo
                 and n.glb_subgrupoimagem_codigo = '02'
                 and n.glb_compimagem_arquivado = 'S');
                 
 if (vCont > 0) and (vContAux > 0) then
   
    -- Realiza alteração informando a transferência
    
   update tdvadm.t_con_vfreteconhec vf
      set vf.con_vfreteconhec_transfchekin = 'Sim',
          vf.arm_armazem_codigo            = vArmazem
    where vf.con_conhecimento_codigo  = vConhecimento
      and vf.con_conhecimento_serie   = vserie
      and vf.glb_rota_codigo          = vRota
      and vf.con_valefrete_codigo     = vNumerovf
      and vf.con_valefrete_serie      = vSerievf
      and vf.glb_rota_codigovalefrete = vRotavf
      and vf.con_valefrete_saque      = vSaquevf;
      
      commit;

    vMessage := 'CTE transferido para o armazém ' || vArmazem || '<br />';
    pTpRecebido.Glb_Benasserec_Processado := Sysdate;
    pTpRecebido.Glb_Benasserec_Status     := 'OK';        
    vStatus := 'N';
    
    wservice.pkg_glb_email.SP_ENVIAEMAIL('TRANSFERENCIA REALIZADA',
                                            vMessage,
                                            'grp.hd@dellavolpe.com.br',
                                            trim(ptpRecebido.glb_benasserec_origem));  

 else 
   
    vMessage := 'CTE não pode ser transferido, pois não é digitação manual ou tem comprovantes baixados';
    pTpRecebido.Glb_Benasserec_Status     := 'ER';
    
      wservice.pkg_glb_email.SP_ENVIAEMAIL('TRANSFERENCIA NAO REALIZADA',
                                            vMessage,
                                            'grp.hd@dellavolpe.com.br',
                                            trim(ptpRecebido.glb_benasserec_origem));   
 end if;
 
  end if;
 
 EXCEPTION
          WHEN NO_DATA_FOUND THEN
           vStatus := 'E';
           vMessage := 'Usuário não tem permissão para realizar a transferência';
           
  wservice.pkg_glb_email.SP_ENVIAEMAIL('TRANSFERENCIA NAO REALIZADA',
                                            vMessage,
                                            'grp.hd@dellavolpe.com.br',
                                            trim(ptpRecebido.glb_benasserec_origem));  
                                            
end sp_transfctemanual;

procedure sp_alteravolume(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                                vStatus Out Char,
                                                pMessage out varchar2) is
     
/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Operacional
* PROGRAMA    : Nota - FIFO
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 19/07/2019
* BANCO       : ORACLE
* SIGLAS      : ARM
* DESCRICAO   : Altera quantidade de volume da nota apenas para usuário liberado.
*             : Orientado apenas liberação para o setor central de ocorrência.
---------------------------------------------------------------------------------------------------
*/
    
      vEmbalagem tdvadm.t_arm_nota.arm_embalagem_numero%type;
      vQTDVOL    tdvadm.t_arm_nota.arm_nota_qtdvolume%type;
      vMessage   clob;
      vCont      number;
      vContador  number;
      
  begin
    
  vEmbalagem := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'EMBALAGEM','=', ';');
  vQTDVOL := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'QTDVOL','=', ';');   
  
    ----------EXEMPLO DE ASSUNTO--------------
    --MSG=ALTERAVOL;EMBALAGEM=2817567;QTDVOL=1;
    ------------------------------------------

  -- Verifica se o usuário tem permissão para realizar o processo

 select count(*)
   into vContador
   from tdvadm.t_edi_planilhaaut p
  where p.edi_planilhacfg_codigo = 'ALTERAVOL'
    and p.edi_planilhaaut_email = pTpRecebido.glb_benasserec_origem;
    
  if (vContador > 0) then
  
  
   -- Verifica se a nota realmente existe.
  select count (*)
    into vCont
    from tdvadm.t_arm_nota an
   where an.arm_embalagem_numero = vEmbalagem;
   
    if (vCont > 0) and (vContador > 0) then
      
    --Realiza a alteração na quantidade de volume da nota.
    
    update tdvadm.t_Arm_nota an
       set an.arm_nota_qtdvolume   = vQTDVOL
     where an.arm_embalagem_numero = vEmbalagem;
     
     commit;
     
     -- Monta a mensagem informando a alteração.
     
     vMessage := 'Quantidade de Volume da nota alterada '||  '<br/>';
     pTpRecebido.Glb_Benasserec_Processado := Sysdate;
     pTpRecebido.Glb_Benasserec_Status     := 'OK';        
     vStatus := 'N';
     
     -- Envia o email para o usuário quando realizada a alteração
     
     wservice.pkg_glb_email.SP_ENVIAEMAIL('REALIZADO COM SUCESSO',
                                        vMessage,
                                        'grp.hd@dellavolpe.com.br',
                                        trim(ptpRecebido.glb_benasserec_origem));
                                        
     else
       
     -- Envia o email para o usuário quando não realizada a alteração.
       
    vMessage := 'Não foi possível encontrar a nota/embalagem';
    pTpRecebido.Glb_Benasserec_Status     := 'ER';
    
      wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO AO ALTERAR QTD VOLUME',
                                            vMessage,
                                            'grp.hd@dellavolpe.com.br',
                                            trim(ptpRecebido.glb_benasserec_origem));   
     
     end if;
       
      end if;      
      
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
           vStatus := 'E';
           vMessage := 'Usuário não tem permissão para realizar alteração';
           
       -- Envia o email para o usuário quando realizada a alteração devido permissão.    
           
       wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO AO ALTERAR QTD VOLUME',
                                  vMessage,
                                  'grp.hd@dellavolpe.com.br',
                                  trim(ptpRecebido.glb_benasserec_origem));
      
  end sp_alteravolume;

   -------------------------------------------------------------------------------------------------------------
   -- Procedure utilizada para devolver lista de Saldo dos Tanques de Abastecimento                                           --
   -------------------------------------------------------------------------------------------------------------
   procedure spi_get_listaSaldoTanques( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                       pStatus out char,
                                       pMessage out varchar2
                               ) is
     vTanque tdvadm.t_frt_tanques.frt_tanques_codigo%Type;    
     vMeses  number;
     vCursor T_CURSOR;
      vLinha1       pkg_glb_SqlCursor.tpString1024;
      vLinha2       pkg_glb_SqlCursor.tpString1024;
     
     --Variáveis auxiliares
     vMessage   clob;
   Begin
     
   --Exemplo de QryString = MSG=LSTTANQUE;TANQUE=01;

     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'ER';
     
     Begin
       --recupero o numero do equipamento caso seja uma consulta especifica
       vTanque :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'TANQUE', '=', ';');
       vMeses  :=  to_number(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'MESES', '=', ';'));
       vMessage := empty_clob;
       if  vTanque is null Then
          vTanque := '99';
       End If;
       if vMeses is null Then
         vMeses := 72;    
       End if;
       
       tdvadm.pkg_frt_geral.sp_listaSaldoTanque(vTanque,vMeses, vCursor, pStatus, vMessage) ;
              
       --Executo a função responsável por me trazer a lista de equipamentos e placas de vinculação
       if ( pStatus =  pkg_glb_common.Status_Erro  ) then
         --caso ocorra algum erro, devolvo a mensagem
         pMessage := vMessage;
         return;
       end if;
       pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
       pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
       pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha2);
       for i in 1 .. vLinha2.count loop
          if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
             vMessage := vMessage || vLinha2(i);
          Else
             vMessage := vMessage || vLinha2(i) || chr(10);
          End if;
       End loop; 


       
       --envio o e-mail com os dados recuperados.
       wservice.pkg_glb_email.SP_ENVIAEMAIL('Saldo dos Tanques"',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem
                                             );
      --seto os paramentros de saida.
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'OK';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := '';
       
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao recuperar lista de MCT. ' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     
     
   end spi_get_listaSaldoTanques;                                                                  


   procedure SPI_Set_SistemaRota( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                  pStatus out char,
                                  pMessage out varchar2
                                ) is
     vSistema   tdvadm.t_edi_planilhaaut.edi_planilhacfg_sistema%type;
     vRota      tdvadm.t_glb_rota.glb_rota_codigo%type;
     vUsuario   tdvadm.t_usu_usuario.usu_usuario_codigo%type;
     vSegmentoAPL  tdvadm.t_usu_usuarioperfil.usu_segmento_codigo%type; 
     vSistemaAPL   tdvadm.t_usu_usuarioperfil.usu_sistema_codigo%type;
     vModuloAPL    tdvadm.t_usu_usuarioperfil.usu_modulo_codigo%type; 
     vAplicacaoAPL tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type;
     vAuxiliar     number;
     
     vCursor T_CURSOR;
      vLinha1       pkg_glb_SqlCursor.tpString1024;
      vLinha2       pkg_glb_SqlCursor.tpString1024;
     
     --Variáveis auxiliares
     vMessage   clob;
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'ER';
     pStatus := pkg_glb_common.Status_Nomal;
     
     Begin
       
     --Exemplo de QryString = MSG=HSMENU;SIST=CTEDIG;ROTA=033;USUARIO=

     
       vSistema :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'SIST', '=', ';');
       vRota    :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'ROTA', '=', ';');
       vUsuario :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'USUARIO', '=', ';');

       if vSistema is null Then
          pMessage := 'Sistema Não Informado...';
          pStatus := pkg_glb_common.Status_Erro; 
          Return;
       ElsIf vSistema = 'CTEDIG' then
          vSegmentoAPL  := '002';
          vSistemaAPL   := 'exp_usu_f';
          vModuloAPL    := 'expcadusuf';
          vAplicacaoAPL := 'comdigconh';
       
       End If;   

       vMessage := empty_clob;
       
       if vUsuario is null then
          vUsuario := 'TODOS';
       End If;
       If vRota is null Then
         vRota := 'TODAS';
       End If;
       
       If ( vUsuario = 'TODOS' ) and ( vRota = 'TODAS' ) Then
          pMessage := 'Voce Tem Que informar um USUARIO ou uma ROTA ...';
          pStatus := pkg_glb_common.Status_Erro; 
          return;
       End If;
         
          
          Begin
              insert into t_usu_usuarioperfil
              select vSegmentoAPL,
                     vSistemaAPL,
                     vModuloAPL,
                     vAplicacaoAPL,
                     'per_filial',
                     io.usu_usuario_codigo,
                     '3',
                     sysdate,
                     '0'
              from tdvadm.t_usu_usuario io
              where 0 = 0
                and trim(io.usu_usuario_codigo) = decode(trim(vUsuario),'TODOS',trim(io.usu_usuario_codigo),trim(vUsuario))
                and trim(io.glb_rota_codigo)    = decode(trim(vRota),'TODAS',trim(io.glb_rota_codigo),trim(vRota))
                and 0 = (select count(*)
                         from tdvadm.t_usu_usuarioperfil p
                         where trim(p.usu_segmento_codigo)  = Trim(vSegmentoAPL)
                           and trim(p.usu_sistema_codigo)   = Trim(vSistemaAPL)
                           and trim(p.usu_modulo_codigo)    = Trim(vModuloAPL)
                           and trim(p.usu_aplicacao_codigo) = Trim(vAplicacaoAPL)
                           and trim(p.usu_usuario_codigo)   = trim(io.usu_usuario_codigo));
              vAuxiliar := sql%rowcount;             
          exception
            when OTHERS Then
               pStatus :=  pkg_glb_common.Status_Erro;
               pMessage := 'Erro ao atribuir sistema...' || chr(10) || sqlerrm;
               Return;   
            End;                       

       
       --Executo a função responsável por me trazer a lista de equipamentos e placas de vinculação
       if ( pStatus =  pkg_glb_common.Status_Erro  ) then
         --caso ocorra algum erro, devolvo a mensagem
         pMessage := vMessage;
         return;
       end if;

       pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
       pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
       
       open vCursor for select p.usu_usuario_codigo usuario,
                               P.USU_USUARIOPERFIL_DTULTUTILIZA ultutiliacao,
                               p.usu_usuarioperfil_qtdeacess qtdevezes,
                               u.glb_rota_codigo rota,
                               'Liberado' Status
              from tdvadm.t_usu_usuarioperfil p,
                   tdvadm.t_usu_usuario u
              where 0 = 0
                and trim(p.usu_usuario_codigo) = trim(u.usu_usuario_codigo)
                and trim(u.usu_usuario_codigo) = decode(trim(vUsuario),'TODOS',trim(u.usu_usuario_codigo),trim(vUsuario))
                and trim(u.glb_rota_codigo)    = decode(trim(vRota),'TODAS',trim(u.glb_rota_codigo),trim(vRota))
                and trim(p.usu_segmento_codigo)  = trim(vSegmentoAPL)
                and trim(p.usu_sistema_codigo)   = trim(vSistemaAPL)
                and trim(p.usu_modulo_codigo)    = trim(vModuloAPL)
                and trim(p.usu_aplicacao_codigo) = trim(vAplicacaoAPL);
--                and trunc(p.usu_usuarioperfil_dtultutiliza) = trunc(sysdate);
       
       pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha2);
       for i in 1 .. vLinha2.count loop
          if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
             vMessage := vMessage || vLinha2(i);
          Else
             vMessage := vMessage || vLinha2(i) || chr(10);
          End if;
       End loop; 


       
       --envio o e-mail com os dados recuperados.
       wservice.pkg_glb_email.SP_ENVIAEMAIL('USUARIOS',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem || ';gmachado@dellavolpe.com.br'
                                             );
      --seto os paramentros de saida.
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'OK';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := '';
       
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro Liberando usuario . ' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     
     
   end SPI_Set_SistemaRota;                                                                  

/* Desativada em 06/11/2014 exclui a mesma da ppkg_con_rotinas_diarias
   procedure SPI_RodaPetransXXX( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                 pStatus out char,
                                 pMessage out varchar2
                               ) is
     vAuxiliar     number;
     
     vCursor T_CURSOR;
      vLinha1       pkg_glb_SqlCursor.tpString1024;
      vLinha2       pkg_glb_SqlCursor.tpString1024;
     
     --Variáveis auxiliares
     vMessage   clob;
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'ER';
     pStatus := pkg_glb_common.Status_Nomal;
     
     Begin
       
     --Exemplo de QryString = MSG=PETRANSXXX;RETROAGE=0

     
       vAuxiliar :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'RETROAGE', '=', ';');
 
       pkg_con_rotinasdiarias.SP_CON_ANALITICONEWXXXSR(nvl(vAuxiliar,0));   
       
       pTpRecebido.Glb_Benasserec_Status := 'OK';

       
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro Rodar PETRANS XXX . ' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     
     
   end SPI_RodaPetransXXX;                                                                  

*/

   procedure SPI_RodaDivCarreg(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                               pStatus out char,
                               pMessage out varchar2
                               ) is
     vAuxiliar     number;
     vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
     
     vCursor T_CURSOR;
      vLinha1       pkg_glb_SqlCursor.tpString1024;
      vLinha2       pkg_glb_SqlCursor.tpString1024;
     
     --Variáveis auxiliares
     vMessage   clob;
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'ER';
     pStatus := pkg_glb_common.Status_Nomal;
     
     Begin
       
     --Exemplo de QryString = MSG=DIVCARREG;CARREG=

     
       vCarregamento :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'CARREG', '=', ';');
 
       pkg_fifo_carregctrc.SP_CON_SEPARACARREG(vCarregamento,null,null,pStatus,vMessage);
       


       wservice.pkg_glb_email.SP_ENVIAEMAIL('DIVIDINDO CARREGAMENTO',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem );
      --seto os paramentros de saida.
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'OK';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := vMessage;

      
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro DIVIDIR CARREGAMENTO - ' || vCarregamento  || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     
     
   end SPI_RodaDivCarreg;                                                                  

   procedure spi_informaCartaAutorizada(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                        pStatus out char,
                                        pMessage out varchar2
                                       ) is
    
    vProtocolo    tdvadm.t_edi_integra.edi_integra_protocolo%type;
    vSequencia    number;
    vConhecimento tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
    vSerie        tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
    vRota         tdvadm.t_con_conhecimento.glb_rota_codigo%type;
    vStatus       tdvadm.T_CON_EVENTOCTE.con_ctestatus_codigo%type;
    vMessage     clob;
    vFinaliza     char(1); 
  Begin
     --seto o status para erro, e o processamento para hoje
     
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'ER';
     pStatus := pkg_glb_common.Status_Nomal;
     vFinaliza := 'N';
       
     --Exemplo de QryString = MSG=VERIFICACC;PROTOCOLO=243544;SEQUENCIA=1;CONHECIMENTO=1234134;SERIE=2435245;ROTA=344 

     
       vProtocolo    :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'PROTOCOLO', '=', ';');
       vSequencia    :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'SEQUENCIA', '=', ';');
       vConhecimento := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'CONHECIMENTO','=', ';');
       vSerie        := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'SERIE', '=', ';');
       vRota         := tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'ROTA', '=', ';');

       vMessage := vMessage || '<br />Conhecimento.: ' || vConhecimento || '<br />';
       vMessage := vMessage || 'Serie       .: ' || vserie || '<br />';
       vMessage := vMessage || 'Rota        .: ' || vRota || '<br />';

       Begin
            SELECT L.CON_CTESTATUS_CODIGO
               into vStatus
            FROM tdvadm.T_CON_EVENTOCTE L
            WHERE L.GLB_EVENTOSEFAZ_CODIGO  = '5'
              and l.con_conhecimento_codigo = vConhecimento
              and l.con_conhecimento_serie  = vSerie
              AND l.glb_rota_codigo         = vRota
              and l.con_eventocte_seqevento = vSequencia;
       Exception
         WHEN NO_DATA_FOUND Then
             vStatus := 'NE';
         End ;

       If vStatus = 'CO' Then
          vMessage := vMessage || 'Carta de correção autorizada pelo FISCO <br />'; 
          vFinaliza := 'S';
       ElsIf vStatus = 'CN' Then
          vMessage := vMessage || 'Carta de corrção rejeitada pelo FISCO <br />'; 
          vFinaliza := 'S';
       End If;
       
       If vFinaliza = 'S' Then

          wservice.pkg_glb_email.SP_ENVIAEMAIl('CONFIRMACAO DE CARTA DE CORRECAO',
                                                vMessage,
                                                'aut-e@dellavolpe.com.br',
                                                pTpRecebido.glb_benasserec_origem,
                                                'ksouza@dellavolpe.com.br');
          --seto os paramentros de saida.
          pTpRecebido.Glb_Benasserec_Processado := Sysdate;
          pTpRecebido.Glb_Benasserec_Status     := 'OK';
          pStatus := pkg_glb_common.Status_Nomal;
       Else
          pTpRecebido.Glb_Benasserec_Processado := null;
          pTpRecebido.Glb_Benasserec_Status     := 'AP';
          
       End If;

      
      pMessage := vMessage;


     
   end spi_informaCartaAutorizada;                                                                  



   procedure SPI_RodaJuntaCarreg(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                 pStatus out char,
                                 pMessage out varchar2
                                 ) is
     vAuxiliar     number;
     vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
     vTipo         char(3);
     vCursor T_CURSOR;
      vLinha1       pkg_glb_SqlCursor.tpString1024;
      vLinha2       pkg_glb_SqlCursor.tpString1024;
     
     --Variáveis auxiliares
     vMessage     clob;
     vMsgCriou    varchar2(100);
     vMsgFechou   varchar2(100);
     vMsgConferiu varchar2(100);
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'ER';
     pStatus := pkg_glb_common.Status_Nomal;
     
     Begin
       
     --Exemplo de QryString = MSG=JUNTACARREG;CARREG=

     
       vCarregamento :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'CARREG', '=', ';');
       vTipo         :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'TIPO', '=', ';');
       vTipo := nvl(vTipo,'XXX');
       if instr(vTipo,'A1') > 0 then
          vTipo := 'A1';
       Else  
          vTipo := 'XXX';
       End If;     

       pkg_fifo_carregctrc.SP_CON_JUNTACARREG(vCarregamento,vTipo,pStatus,vMessage);

/*       
--Implementar depois quem digitou a Nota
select  an.arm_nota_numero nota,
        an.glb_cliente_cgccpfremetente remetente,
        an.arm_nota_dtinclusao inclusao,
        an.usu_usuario_codigo,
        u.usu_usuario_nome nome,
        an.glb_cliente_cgccpfremetente remetente,
        an.glb_cliente_cgccpfdestinatario destinatario,
        an.glb_cliente_cgccpfsacado sacado
from t_arm_nota an,
     t_arm_carregamentodet cd,
     t_usu_usuario u
where cd.arm_carregamento_codigo = '576744'
  and an.arm_embalagem_numero = cd.arm_embalagem_numero
  and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
  and an.arm_embalagem_flag = cd.arm_embalagem_flag
  and an.usu_usuario_codigo = u.usu_usuario_codigo (+);
*/
       
       Begin 
       SELECT 'Criou - '  || C.USU_USUARIO_CRIOUCARREG || '-' || TRIM(CR.USU_USUARIO_NOME) || CHR(10),
              'Fechou - ' || C.USU_USUARIO_FECHOUCARREG || '-' || TRIM(FE.USU_USUARIO_NOME) || CHR(10),
              'Conferiu - ' ||C.USU_USUARIO_CONFERIUCARREG || '-' || TRIM(CO.USU_USUARIO_NOME) || CHR(10)
          into vMsgCriou,
               vMsgFechou,
               vMsgConferiu    
       FROM tdvadm.T_ARM_CARREGAMENTO C,
            tdvadm.T_USU_USUARIO CR,
            tdvadm.T_USU_USUARIO FE,
            tdvadm.T_USU_USUARIO CO
        WHERE C.ARM_CARREGAMENTO_CODIGO = vCarregamento
          AND C.USU_USUARIO_CRIOUCARREG = CR.USU_USUARIO_CODIGO
          AND C.USU_USUARIO_FECHOUCARREG = FE.USU_USUARIO_CODIGO
          AND C.USU_USUARIO_CONFERIUCARREG = CO.USU_USUARIO_CODIGO;
       exception
         WHEN NO_DATA_FOUND Then
           vMsgCriou    := 'Carregamento [' || vCarregamento || '] não existe....' || chr(10);
           vMsgFechou   := '';
           vMsgConferiu := '';
         End;  
       vMessage := vMessage || vMsgCriou || vMsgFechou || vMsgConferiu;
       wservice.pkg_glb_email.SP_ENVIAEMAIL('JUNTADO CARREGAMENTO',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem || ';ezpereira@dellavolpe.com.br'
                                             );
      --seto os paramentros de saida.
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'OK';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := vMessage;


       
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro JUNTANDO CARREGAMENTO - ' || vCarregamento  || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     
     
   end SPI_RodaJuntaCarreg;                                                                  



   -------------------------------------------------------------------------------------------------------------
   -- Procedure utilizada para devolver lista de Saldo dos Tanques de Abastecimento                                           --
   -------------------------------------------------------------------------------------------------------------
   --Exemplo de QryString = MSG=BLQLIB;ACAO=B;USU=jsantos;TPMOT=F;PLACA=BJU3443;CPF=06045040805;AVISO=Entrar em contato com Rastreamento (incidente);INICIO=26/06/2014;
   procedure spi_get_BloqueaLiberaMot( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                       pStatus out char,
                                       pMessage out varchar2
                               ) is
     tpBloqueio     tdvadm.t_por_eventualmsg%rowtype;
     vMeses  number;
     vCursor T_CURSOR;
      vLinha1       pkg_glb_SqlCursor.tpString1024;
      vLinha2       pkg_glb_SqlCursor.tpString1024;
      vAcao         char(1);
      vAuxiliar     number;
      vSeq          number;
     
     --Variáveis auxiliares
     vMessage   clob;
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'OK';
     pStatus := pkg_glb_common.Status_Nomal;
     
     Begin
       --Exemplo de QryString = MSG=BLQLIB;ACAO=B;CODDESBL=123341324;USU=jsantos;PLACA=BJU3443;CPF=06045040805;AVISO=Entrar em contato com Rastreamento (incidente);INICIO=26/06/2014;FIM=30/06/2014;
       
       --recupero o numero do equipamento caso seja uma consulta especifica
       vAcao                               := substr(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'ACAO', '=', ';'),1,1);
       tpBloqueio.Por_Eventualmsg_Codigo   :=  substr(lower(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'CODDESBL', '=', ';')),1,10);
       tpBloqueio.Usu_Usuario_Codigo       :=  substr(lower(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'USU', '=', ';')),1,10);
       tpBloqueio.Por_Eventualmsg_Placa    :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'PLACA', '=', ';');
       tpBloqueio.Por_Eventualmsg_Cpf      :=  rpad(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'CPF', '=', ';'),20);
       tpBloqueio.Por_Eventualmsg_Mensagem :=  trim(substr(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'AVISO', '=', ';'),1,200));
       tpBloqueio.Por_Eventualmsg_Dtinicio :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'INICIO', '=', ';');
       if tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'FIM', '=', ';') = '' Then
          tpBloqueio.Por_Eventualmsg_Dtfim := tpBloqueio.Por_Eventualmsg_Dtinicio + 360;
       Else   
          tpBloqueio.Por_Eventualmsg_Dtfim    :=  tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'FIM', '=', ';');
       End If;   

       vMessage := empty_clob;

       
       If nvl(vAcao,'X') not in ('B','L') Then
          vMessage := vMessage || 'Acao tem que ser (B) Bloqueia ou (L) Libera' || chr(10);
          pTpRecebido.Glb_Benasserec_Status := 'ER';
          pStatus := pkg_glb_common.Status_Erro;
       End If ; 
       
       
       If ( tpBloqueio.Usu_Usuario_Codigo is null ) and ( nvl(vAcao,'X') = 'B') Then
          vMessage := vMessage || 'Usuario Obrigatorio' || chr(10);
          pTpRecebido.Glb_Benasserec_Status := 'ER';
          pStatus := pkg_glb_common.Status_Erro;
       End If  ;
       
                


       if tpBloqueio.Por_Eventualmsg_Placa is null Then
          if tpBloqueio.Por_Eventualmsg_Cpf is null Then
             vMessage := vMessage || 'Placa ou CPF Obrigatorio' || chr(10);
             pTpRecebido.Glb_Benasserec_Status := 'ER';
             pStatus := pkg_glb_common.Status_Erro;
          End If;
       End If; 
       
       If ( tpBloqueio.Por_Eventualmsg_Dtinicio is null ) and ( nvl(vAcao,'X') = 'B' ) Then
          vMessage := vMessage || 'Data de Inicio Bloqueio Obrigatorio' || chr(10);
          pTpRecebido.Glb_Benasserec_Status := 'ER';
          pStatus := pkg_glb_common.Status_Erro;
       End If  ;
       
            
       If ( tpBloqueio.Por_Eventualmsg_Mensagem is null )  and ( nvl(vAcao,'X') = 'B' ) Then
          vMessage := vMessage || 'Mensagem Obrigatoria' || chr(10);
          pTpRecebido.Glb_Benasserec_Status := 'ER';
          pStatus := pkg_glb_common.Status_Erro;
       End If  ;
       
       If pTpRecebido.Glb_Benasserec_Status = 'OK' then

           If ( vAcao = 'B' ) Then
              select max(b.por_eventualmsg_codigo)
                 into tpBloqueio.Por_Eventualmsg_Codigo
             from tdvadm.t_por_eventualmsg b;
             tpBloqueio.Por_Eventualmsg_Codigo := lpad(tpBloqueio.Por_Eventualmsg_Codigo + 1,10,'0');
           End If;

          If ( tpBloqueio.Por_Eventualmsg_Codigo = '' ) and ( vAcao = 'L' ) Then
             vMessage := vMessage || 'Codigo não passado ' || tpBloqueio.Por_Eventualmsg_Placa || ' CPF ' || tpBloqueio.Por_Eventualmsg_Cpf || chr(10);
             pTpRecebido.Glb_Benasserec_Status := 'ER';
          End If  ;
          
          if pTpRecebido.Glb_Benasserec_Status = 'OK' then
              
             if vAcao = 'L' Then
                delete t_por_eventualmsg e
                where e.por_eventualmsg_codigo = tpBloqueio.Por_Eventualmsg_Codigo;
                commit;  
                vMessage := vMessage || 'Motorista COD BLOQ - ' || tpBloqueio.Por_Eventualmsg_Codigo || ' Liberado com Sucesso' || chr(10);
                pStatus := pkg_glb_common.Status_Nomal;
             Else
                tpBloqueio.Por_Eventualmsg_Bloqueia     := 'S';
                tpBloqueio.Por_Eventualmsg_Flagentrsaid := 'A';
                insert into t_por_eventualmsg
                values tpBloqueio;  
                commit;
                vMessage := vMessage || 'Motorista CPF - ' || tpBloqueio.Por_Eventualmsg_Cpf || ' PLACA - ' ||  tpBloqueio.Por_Eventualmsg_Placa || ' Bloqueado com Sucesso Codigo para Desbloqueio - MSG=BLQLIB;ACAO=L;CODDESBL=' || tpBloqueio.Por_Eventualmsg_Codigo || chr(10);
                pStatus := pkg_glb_common.Status_Nomal;
             End If;     
           
           
          End If;


       End If;

       
              
       --Executo a função responsável por me trazer a lista de equipamentos e placas de vinculação
       if ( pStatus =  pkg_glb_common.Status_Erro  ) then
         --caso ocorra algum erro, devolvo a mensagem
         pMessage := vMessage;
         return;
       end if;
       open vCursor for select b.por_eventualmsg_codigo CODIGO,
                               b.por_eventualmsg_placa PLACA,
                               f_mascara_cgccpf(trim(b.por_eventualmsg_cpf)) CPF,
                               b.usu_usuario_codigo USUBLOQ,
                               b.por_eventualmsg_dtinicio INICIOBLOQ,
                               b.por_eventualmsg_dtfim FIMBLOQ,
                               b.por_eventualmsg_mensagem MSG
                        from tdvadm.t_por_eventualmsg b 
                        where b.por_eventualmsg_cpf is not null
                          and trim(b.por_eventualmsg_dtfim) >= sysdate;
       
       pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
       pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
       pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha2);
       for i in 1 .. vLinha2.count loop
          if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
             vMessage := vMessage || vLinha2(i);
          Else
             vMessage := vMessage || vLinha2(i) || chr(10);
          End if;
       End loop; 


       
       --envio o e-mail com os dados recuperados.
       wservice.pkg_glb_email.SP_ENVIAEMAIL('Bloqueios / Liberação de Motorista',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem
                                             );
      --seto os paramentros de saida.
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'OK';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := '';
       
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao Bloquear Liberar Motorista ' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     
     
   end spi_get_BloqueaLiberaMot;                                                                  

   Procedure spi_processa_NOTATCN(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                 vStatus Out Char,
                                 vMessage Out clob)
   AS
     vQryString     varchar2(500);
     vContador      number;
     vProcessamento clob;
     vCriticas      clob;
     vMessage2      clob; 
     vParamsEntrada Clob;
     vParamsEntradaB Blob;
     vParamsSaida   clob;
     vNota          tdvadm.t_arm_nota.arm_nota_numero%type;
     vSerie         tdvadm.t_arm_nota.arm_nota_serie%type;
     vSequencia     tdvadm.t_arm_nota.arm_nota_sequencia%type;
     vRemetente     tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
     vTpEndRemet    tdvadm.t_arm_nota.glb_tpcliend_codremetente%type;
     vCFOP          tdvadm.t_glb_cfop.glb_cfop_codigo%type;
     vPeso          tdvadm.t_arm_nota.arm_nota_peso%type;
     vValor         tdvadm.t_arm_nota.arm_nota_valormerc%type;
     vNotaMae       tdvadm.t_arm_nota.arm_nota_numero%type;
     vSerieMae      tdvadm.t_arm_nota.arm_nota_serie%type;
     vEmitente      tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
     vChaveMae      tdvadm.t_arm_nota.arm_nota_chavenfe%type;
     vTpCarga       tdvadm.t_arm_nota.glb_tpcarga_codigo%type;
     vTpDoc         tdvadm.t_arm_nota.con_tpdoc_codigo%type;
     vUsuario       tdvadm.t_arm_nota.usu_usuario_codigo%type;
     vRota          tdvadm.t_arm_nota.glb_rota_codigo%type;
     vArmazem       tdvadm.t_arm_nota.arm_armazem_codigo%type;
     tpCarreg       tdvadm.t_arm_carregamento%rowtype;
     tpCarregDet    tdvadm.t_arm_carregamentodet%rowtype;
     tpCargaDet     tdvadm.t_arm_cargadet%rowtype;
     vAuxiliar      number;
     vCodigoBarra   char(44);
     vRetornoVazio  char(1);
     vAnoMes        char(4);
     vEmissao       char(10);
     vCteCLone      tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
     vCteNovo       tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
     vTpCalculo     tdvadm.t_slf_calcsolfrete.slf_tpcalculo_codigo%type;
     vSlf_Solfrete  tdvadm.t_slf_solfrete.slf_solfrete_codigo%type := '00065153';
     vSlf_Saque     tdvadm.t_slf_solfrete.slf_solfrete_saque%type; 
     vOrigem        tdvadm.t_con_conhecimento.con_conhecimento_localcoleta%type;
     vDestino       tdvadm.t_con_conhecimento.con_conhecimento_localentrega%type;
     vMercadoria    tdvadm.t_con_conhecimento.glb_mercadoria_codigo%type;
   Begin
   
      vStatus := pkg_glb_common.Status_Nomal;
      vMessage := chr(10);
      vParamsEntrada := empty_clob();
      vParamsSaida   := empty_clob();
      vProcessamento := empty_clob();
      vCriticas      := empty_clob();
      vCriticas := '<br>';
      vCriticas := pkg_glb_html.Assinatura;
      vCriticas := pkg_glb_html.fn_Titulo('CRITICAS');
      vCriticas := vCriticas || PKG_GLB_HTML.LinhaH;
      vCriticas := vCriticas || pkg_glb_html.fn_AbreLista;
      vProcessamento := pkg_glb_html.Assinatura;
         
      -- Verifica se realmente esta autorizado
      select count(*)
         into vContador
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = 'TICKET'
        and pa.edi_planilhacfg_sistema = 'TICKET'
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
      -- verifica se pode autorizar                      

      If vContador > 0 Then 
         vStatus     := 'N';
         vMessage    := '';
      Else
         vStatus     := 'E';
         vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Voce Não esta AUTORIZADO');
         tpRecebido.Glb_Benasserec_Processado := Sysdate;
         tpRecebido.Glb_Benasserec_Status     := 'ER';
      End If;

      vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));


      vCodigoBarra  := substr(Trim(tdvadm.fn_querystring(vQryString,'CODIGOBARRA','=',';')),1,44);
     
      If Length(trim(nvl(vCodigoBarra,'1'))) < 44 Then
         vStatus     := 'E';
         vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Codigo de Barras Obrigatorio');
         tpRecebido.Glb_Benasserec_Processado := Sysdate;
         tpRecebido.Glb_Benasserec_Status     := 'ER';
      Else
         If F_DIGCONTROLEMODCTE(SUBSTR(vCodigoBarra,1,43)) <> SUBSTR(vCodigoBarra,-1) THEN
             vStatus     := 'E';
             vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Digito Verificador da Barra não confere');
             tpRecebido.Glb_Benasserec_Processado := Sysdate;
             tpRecebido.Glb_Benasserec_Status     := 'ER';
         Else
            vAnoMes    := SubStr(vCodigoBarra,03,04);
            
            vRemetente := SubStr(vCodigoBarra,07,14);
            
            vRemetente := Trim(tdvadm.fn_querystring(vQryString,'REMETENTE','=',';'));
            
            vSerie     := SubStr(vCodigoBarra,23,03);
            vNota      := SubStr(vCodigoBarra,26,09);
            
            vEmissao  := substr(Trim(tdvadm.fn_querystring(vQryString,'EMISSAO','=',';')),1,10);
            If Length(trim(nvl(vEmissao,'1'))) < 10 Then
               vEmissao := to_char(sysdate,'dd/mm/yyyy');  
            End If;
            
            If to_char(to_date(vEmissao,'dd/mm/yyyy'),'yymm') <> vAnoMes then
               vStatus     := 'E';
               vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Data da Emissao Fora do Mes Informado no Codigo de Barra');
               tpRecebido.Glb_Benasserec_Processado := Sysdate;
               tpRecebido.Glb_Benasserec_Status     := 'ER';
            End If;
            
         End If;

      End If;

      
      

      If vStatus = 'N' Then
--       Exemplo MSG=TICKET;PESO=25000;VALOR=1345,50;TPEND=X;CODIGOBARRA=12345678901234567890123456789012345678901234;NMAE=1334;EMITENTE=61139432000172;RETORNOVAZIO=S


      vProcessamento := vProcessamento || '<br/><br />';
      vProcessamento := vProcessamento || pkg_glb_html.fn_Titulo('PROCESSAMENTO TICKET ' || vNota);
      vProcessamento := vProcessamento || PKG_GLB_HTML.LinhaH;
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_AbreLista;
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Comando Enviado ' || trim(tpRecebido.Glb_Benasserec_Assunto));
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Recepção do E-mail ' || to_char(tpRecebido.Glb_Benasserec_Gravacao,'dd/mm/yyyy hh24:mi:ss'));
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Lendo Parametros  ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));


       vNotaMae      := Trim(tdvadm.fn_querystring(vQryString,'NMAE','=',';'));
       vSerieMae     := Trim(tdvadm.fn_querystring(vQryString,'SERIEMAE','=',';'));
       vEmitente     := Trim(tdvadm.fn_querystring(vQryString,'EMITENTE','=',';'));
       vChaveMae     := Trim(tdvadm.fn_querystring(vQryString,'CHAVEMAE','=',';'));
       vRetornoVazio := Trim(tdvadm.fn_querystring(vQryString,'RETVZ','=',';'));
       If trim(vRetornoVazio) <> 'N' Then
          vRetornoVazio := 'S';
       End IF;
       vAuxiliar := nvl(length(trim(nvl(vSerieMae,''))),0);  
       if vAuxiliar = 0 Then
          Begin
             select an.arm_nota_serie 
               into vSerieMae
             From tdvadm.T_ARM_NOTA AN
             WHERE AN.ARM_NOTA_NUMERO = vNotaMae
               AND AN.GLB_CLIENTE_CGCCPFREMETENTE = vEmitente;  
          Exception
            WHEN NO_DATA_FOUND Then
               vStatus     := 'E';
               vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Nota MAE ' || vNotaMae || ' CNPJ ' || vEmitente || '. Não Encontrada!');
               tpRecebido.Glb_Benasserec_Processado := Sysdate;
               tpRecebido.Glb_Benasserec_Status     := 'ER';
              
            WHEN TOO_MANY_ROWS Then
               vStatus     := 'E';
               vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Nota MAE ' || vNotaMae || ' CNPJ ' || vEmitente || '. Duplicada Enviar a TAG => SERIEMAE !');
               tpRecebido.Glb_Benasserec_Processado := Sysdate;
               tpRecebido.Glb_Benasserec_Status     := 'ER';
          End;
       Else
          Begin
             select an.arm_nota_serie 
               into vSerieMae
             From tdvadm.T_ARM_NOTA AN
             WHERE AN.ARM_NOTA_NUMERO = vNotaMae
               and to_number(an.arm_nota_serie) = vSerieMae
               AND AN.GLB_CLIENTE_CGCCPFREMETENTE = vEmitente;  

             update tdvadm.T_ARM_NOTA AN
               set an.arm_nota_dtinclusao = trunc(sysdate - 1)
             WHERE AN.ARM_NOTA_NUMERO = vNotaMae
               and to_number(an.arm_nota_serie) = vSerieMae
               AND AN.GLB_CLIENTE_CGCCPFREMETENTE = vEmitente;  

          Exception
            WHEN NO_DATA_FOUND Then
               vStatus     := 'E';
               vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Nota MAE ' || vNotaMae || ' CNPJ ' || vEmitente || '. Não Encontrada!');
               tpRecebido.Glb_Benasserec_Processado := Sysdate;
               tpRecebido.Glb_Benasserec_Status     := 'ER';
          End;     
       End If;

       Begin
          vPeso        := replace(replace(Trim(tdvadm.fn_querystring(vQryString,'PESO','=',';')),',',''),'.','');
       exception
       When OTHERS Then
          vStatus := 'E';
          vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Peso Errado ou Não Informado!');
          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'ER';
       end;   

       Begin
          vValor := replace(replace(replace(Trim(tdvadm.fn_querystring(vQryString,'VALOR','=',';')),',','*'),'.',''),'*','.');
       exception
       When OTHERS Then
          vStatus     := 'E';
          vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Valor Errado ou Não Informado!');
          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'ER';
       end;   

--       Exemplo MSG=TICKET&NOTA=4612&SERIE=0&PESO=26070&VALOR=5598,27&CFOP=5032&TPCARGA=CA&TPDOC=99NMAE=0023&SERIEMAE=3&CHAVEMAE=3242343423434344343&EMITENTE=33592510007590&REMETENTE=99999948004206&TPEND=X&

       
       vTpEndRemet  := Trim(tdvadm.fn_querystring(vQryString,'TPEND','=',';'));
       vAuxiliar := nvl(length(trim(nvl(vTpEndRemet,''))),0);
       if vAuxiliar = 0  Then
          vTpEndRemet := 'X';
       End If;
       
       vCFOP        := Trim(tdvadm.fn_querystring(vQryString,'CFOP','=',';'));
       vAuxiliar := nvl(length(trim(nvl(vCFOP,''))),0);
       if vAuxiliar = 0  Then
          vCFOP := '3949';
       End If;

       vTpCarga     := Trim(tdvadm.fn_querystring(vQryString,'TPCARGA','=',';'));
       vAuxiliar := nvl(length(trim(nvl(vTpCarga,''))),0); 
       if vAuxiliar = 0  Then
          vTpCarga := 'CA';
       End If ;
       
       If vCodigoBarra is not null Then
          vTpDoc := substr(vCodigoBarra,21,2);
          vTpDoc := '99';
       Else
          vTpDoc       := Trim(tdvadm.fn_querystring(vQryString,'TPDOC','=',';'));
          vAuxiliar := nvl(length(trim(nvl(vTpDoc,''))),0);
          if vAuxiliar  = 0  Then
             vTpDoc := '99';
          End If ;
       End If;
       Begin
          select u.usu_usuario_codigo
            into vUsuario
          From tdvadm.t_usu_usuario u
          Where lower(u.usu_usuario_email) = tpRecebido.Glb_Benasserec_Origem;
       Exception
         When NO_DATA_FOUND Then
            vStatus := 'E';
            vMessage := 'Email ' || tpRecebido.Glb_Benasserec_Origem || ' Não Cadastrado...';
            vCriticas := vCriticas || vMessage;
         When DUP_VAL_ON_INDEX Then
            vStatus := 'E';
            vMessage := 'Email ' || tpRecebido.Glb_Benasserec_Origem || ' Cadastrada para mais de um Usuario...';
            vCriticas := vCriticas || vMessage;
         When OTHERS Then
            vStatus := 'E';
            vMessage := 'Erro ao definir usuario para email ' || tpRecebido.Glb_Benasserec_Origem || ' erro: ' || sqlerrm;
            vCriticas := vCriticas || vMessage;
         End ;

       -- Verificar a regra para colocar o usuario
       vRota        := '160';
       vArmazem     := '10';



       If vStatus <> 'E' Then
       

          vParamsEntrada := '';
          vParamsEntrada := vParamsEntrada || '<Parametros>';
          vParamsEntrada := vParamsEntrada || '   <Inputs>';
          vParamsEntrada := vParamsEntrada || '      <Input>';
          vParamsEntrada := vParamsEntrada || '	        <usuario>'|| trim(vUsuario) ||'</usuario>';
          vParamsEntrada := vParamsEntrada || '    		  <aplicacao>carreg</aplicacao>';
          vParamsEntrada := vParamsEntrada || '		      <rota>' || trim(vRota) || '</rota>';
          vParamsEntrada := vParamsEntrada || '		      <armazem>' || trim(vArmazem) || '</armazem>';
          vParamsEntrada := vParamsEntrada || '         <notamae>'|| trim(vNotaMae) ||'</notamae>';
          vParamsEntrada := vParamsEntrada || '         <seriemae>'|| trim(vSerieMae) ||'</seriemae>';
          vParamsEntrada := vParamsEntrada || '         <cnpjmae>' || trim(vEmitente) ||'</cnpjmae>';
          vParamsEntrada := vParamsEntrada || '         <chavemae>' || trim(vChaveMae) || '</chavemae>';
          vParamsEntrada := vParamsEntrada || '         <tpdocumento>' || trim(vTpDoc) || '</tpdocumento>';
          vParamsEntrada := vParamsEntrada || '         <emissao>' || trim(vEmissao) || '</emissao>';
          vParamsEntrada := vParamsEntrada || '         <codigobarra>' || trim(vCodigoBarra) || '</codigobarra>';
          vParamsEntrada := vParamsEntrada || '         <notavide>' || trim(vNota) || '</notavide>';
          vParamsEntrada := vParamsEntrada || '         <serievide>' || trim(vSerie) ||'</serievide>';
          vParamsEntrada := vParamsEntrada || '         <cnpjvide>' || trim(vRemetente) || '</cnpjvide>';
          vParamsEntrada := vParamsEntrada || '         <tpendcliente>' || trim(vTpEndRemet) || '</tpendcliente>';
          vParamsEntrada := vParamsEntrada || '         <tipocarga>' || trim(vTpCarga) || '</tipocarga>';
          vParamsEntrada := vParamsEntrada || '         <cfop>' ||  trim(vCFOP) || '</cfop>';
          vParamsEntrada := vParamsEntrada || '         <peso>' || trim(vPeso) || '</peso>';
          vParamsEntrada := vParamsEntrada || '         <valormerc>' || trim(vValor) || '</valormerc>';
          vParamsEntrada := vParamsEntrada || '		      <finaliza_coleta>S</finaliza_coleta>';
          vParamsEntrada := vParamsEntrada || '		      <criar_coleta>S</criar_coleta>';
          vParamsEntrada := vParamsEntrada || '      </Input>';
          vParamsEntrada := vParamsEntrada || '   </Inputs>';
          vParamsEntrada := vParamsEntrada || '</Parametros>';
        
--          insert into t_glb_sql values (vParamsEntrada,sysdate,'SIRLANO','XML ENTRADA');
--          commit;

          vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('inserindo Nota ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
          


          select max(n.arm_nota_sequencia)
          into vSequencia
          from tdvadm.t_arm_nota n
          where n.arm_nota_numero = vNota
            and trim(n.glb_cliente_cgccpfremetente) = vRemetente
            and to_number(n.arm_nota_serie) = to_number(nvl(vSerie,0));

          select count(*)
          into vAuxiliar
          from tdvadm.t_arm_notavide vide
          where vide.arm_notavide_numero = vNota
            and trim(vide.arm_notavide_cgccpfremetente) = vRemetente
            and to_number(vide.arm_notavide_serie) = to_number(nvl(vSerie,0))
            and 0 = (select count(*)
                       from tdvadm.t_arm_nota anota
                      where anota.arm_nota_numero = vide.arm_notavide_numero
                        and trim(anota.glb_cliente_cgccpfremetente) = trim(vide.arm_notavide_cgccpfremetente)
                        and anota.arm_nota_serie = vide.arm_notavide_serie);
          
          if(vAuxiliar > 0) then
              delete tdvadm.t_arm_notavide vide
              where vide.arm_notavide_numero = vNota
                 and trim(vide.arm_notavide_cgccpfremetente) = vRemetente
                 and to_number(vide.arm_notavide_serie) = to_number(nvl(vSerie,0))
                 and 0 = (select count(*)
                          from tdvadm.t_arm_nota anota
                          where anota.arm_nota_numero = vide.arm_notavide_numero
                            and trim(anota.glb_cliente_cgccpfremetente) = trim(vide.arm_notavide_cgccpfremetente)
                            and anota.arm_nota_serie = vide.arm_notavide_serie);              
              
--              tdvadm.pkg_hd_utilitario.SP_EXCLUI_NOTA_NOVO(vNota,vRemetente,'A',vSequencia,vStatus,vMessage2);             
          end if;
          
          tdvadm.pkg_fifo_recebimento.sp_InsertNotaVide(vParamsEntrada,
                                                        vStatus,
                                                        vMessage2,
                                                        vParamsSaida);
           

           
                             
          if vStatus <> 'N' Then
             vCriticas := vCriticas || pkg_glb_html.fn_ItensLista(trim(vMessage2));
          Else
             if trim(vMessage2) <> '' Then
                vCriticas := vCriticas || pkg_glb_html.fn_ItensLista(trim(vMessage2));
                vStatus := 'E';
             End If;   
          End IF;            
          
          if vStatus <> 'N' Then             
             tdvadm.pkg_hd_utilitario.SP_EXCLUI_NOTA_NOVO(vNota,vRemetente,'A',vSequencia,vStatus,vMessage2);             
             vMessage :=  vMessage || chr(10) || trim(vMessage2) || chr(10);
             if vStatus <> 'N' Then
                vCriticas := vCriticas || pkg_glb_html.fn_ItensLista(trim(vMessage2));
             End IF;            
          Else  
--             insert into t_glb_sql values (vParamsSaida,sysdate,'SIRLANO','XML SAIDA');
--             commit;

             vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Criando Carregamento ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
             For vCursor in (Select extractvalue(value(field), 'Table/ROWSET/row/embalagem_numero')           embalagem_numero,
                                    extractvalue(value(field), 'Table/ROWSET/row/embalagem_flag')             embalagem_flag,
                                    extractvalue(value(field), 'Table/ROWSET/row/embalagem_sequencia')        embalagem_sequencia,
                                    extractvalue(value(field), 'Table/ROWSET/row/Destino_CNPJ')               Destino_CNPJ,
                                    extractvalue(value(field), 'Table/ROWSET/row/Destino_tpCliente')          Destino_tpCliente,
                                    extractvalue(value(field), 'Table/ROWSET/row/Remetente_CNPJ')             Remetente_CNPJ,
                                    extractvalue(value(field), 'Table/ROWSET/row/Remetente_tpCliente')        Remetente_tpCliente
                             From Table(xmlsequence( Extract(xmltype.createXml(vParamsSaida) , '/Parametros/Output/Tables/Table'))) field
                             Where Trim( extractvalue(value(field), 'Table/@name') ) = 'dadosNota')
             loop
                vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Criado Embalagem :' ||vCursor.Embalagem_Numero);
                vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Criado Flag      :' ||vCursor.Embalagem_Flag);
                vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Criado Sequencia :' ||vCursor.Embalagem_Sequencia);
 
                tpCarreg.Arm_Armazem_Codigo                := vArmazem;
                tpCarreg.Fcf_Tpveiculo_Codigo              := '3';
                tpCarreg.Usu_Usuario_Crioucarreg           := vUsuario;
                tpCarreg.Arm_Carregamento_Qtdctrc          := 0;
                tpCarreg.Arm_Carregamento_Qtdimpctrc       := 0;
                tpCarreg.Arm_Carregamento_Flagmanifesto    := null;
                tpCarreg.Arm_Carregamento_Dtcria           := SYSDATE;
                tpCarregDet.Arm_Embalagem_Numero           := vCursor.Embalagem_Numero;
                tpCarregDet.Arm_Embalagem_Flag             := vCursor.Embalagem_Flag;
                tpCarregDet.Arm_Embalagem_Sequencia        := vCursor.Embalagem_Sequencia;
                tpCarregDet.Glb_Cliente_Cgccpfdestinatario := vCursor.Destino_Cnpj;
                tpCarregDet.Glb_Tpcliend_Coddestinatario   := vCursor.Destino_Tpcliente;
                tpCarregDet.Glb_Cliente_Cgccpfcodigo       := vCursor.Remetente_Cnpj;
                tpCarregDet.Glb_Tpcliend_Codigo            := vCursor.Remetente_Tpcliente;

                select max(to_number(ca.arm_carregamento_codigo)) + 1
                   into tpCarreg.Arm_Carregamento_Codigo
                from tdvadm.t_arm_carregamento ca;

                UPDATE TDVADM.T_ARM_NOTA AN
                   SET AN.CON_TPDOC_CODIGO = vTpDoc
                WHERE AN.ARM_EMBALAGEM_NUMERO = vCursor.Embalagem_Numero
                  AND AN.ARM_EMBALAGEM_FLAG = vCursor.Embalagem_Flag
                  AND AN.ARM_EMBALAGEM_SEQUENCIA = vCursor.Embalagem_Sequencia;            
                
                insert into t_arm_carregamento c values tpCarreg;
                commit;

                vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Criado Carregamento ' || tpCarreg.Arm_Carregamento_Codigo);

                tpCarregDet.Arm_Carregamento_Codigo := tpCarreg.Arm_Carregamento_Codigo;
                insert into t_arm_carregamentodet c values tpCarregDet;
                -- coloca o Carregamento na Embalagem
                update t_arm_embalagem eb
                   set eb.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo
                where eb.arm_embalagem_numero = vCursor.Embalagem_Numero
                  and eb.arm_embalagem_flag   = vCursor.Embalagem_Flag
                  and eb.arm_embalagem_sequencia = vCursor.Embalagem_Sequencia;   
                commit;
 
                select an.arm_carga_codigo,
                       an.arm_nota_sequencia,
                       an.arm_nota_numero,
                       an.glb_cliente_cgccpfremetente,
                       an.usu_usuario_codigo,
                       an.arm_embalagem_numero,
                       an.arm_embalagem_flag,
                       an.arm_embalagem_sequencia,
                       null
                  into tpCargaDet.Arm_Carga_Codigo,
                       tpCargaDet.Arm_Nota_Sequencia,
                       tpCargaDet.Arm_Nota_Numero,
                       tpCargaDet.Glb_Cliente_Cgccpfremetente,
                       tpCargaDet.Usu_Usuario_Codigo,
                       tpCargaDet.Arm_Embalagem_Numero,
                       tpCargaDet.Arm_Embalagem_Flag,
                       tpCargaDet.Arm_Embalagem_Sequencia, 
                       tpCargaDet.Glb_Ocorr_Id
                from tdvadm.t_arm_nota an
                where an.Arm_Embalagem_Numero = vCursor.Embalagem_Numero
                  and an.arm_embalagem_flag = vCursor.Embalagem_Flag
                  and an.arm_embalagem_sequencia = vCursor.Embalagem_Sequencia
                  and rownum = 1;
                  
                select count(*) + 1
                  into tpCargaDet.Arm_Cargadet_Seq
                from tdvadm.t_arm_cargadet cd
                where cd.arm_carga_codigo = tpCargaDet.Arm_Carga_Codigo;
                
                If tpCargaDet.Arm_Cargadet_Seq = 1 then
                   insert into tdvadm.t_arm_cargadet values tpCargaDet;
                End If;
                  
                vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Fechando Carregamento ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
                pkg_fifo_carregamento.SP_FECHA_CARREGAMENTO(tpCarreg.Arm_Carregamento_Codigo,
                                                            vArmazem,
                                                            vUsuario,
                                                            vStatus,
                                                            vMessage2);
                Begin
                if vStatus = 'N' Then
                   select c.con_conhecimento_codigo,
                          c.con_conhecimento_localcoleta,
                          c.con_conhecimento_localentrega
                      into vCteCLone,
                           vOrigem,
                           vDestino
                   from tdvadm.t_con_conhecimento c
                   where c.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;

                   vCteNovo := CON_SEQCONHECIMENTO_CODIGO.NEXTVAL;
                   
                   update tdvadm.t_con_conhecimento c
                     set c.con_conhecimento_obs = trim(c.con_conhecimento_obs) || ' Nota Mae [' || vNotaMae || '-' || vEmitente || '] '
                   where c.con_conhecimento_codigo = vCteCLone
                     and c.con_conhecimento_serie = 'XXX'
                     and c.glb_rota_codigo = vRota;

                   update tdvadm.t_con_nftransporta nf
                     set nf.con_tpdoc_codigo = '55'
                   where nf.con_conhecimento_codigo = vCteCLone
                     and nf.con_conhecimento_serie = 'XXX'
                     and nf.glb_rota_codigo = vRota;

                   If nvl(vRetornoVazio,'S') = 'S' Then 

                   tdvadm.pkg_con_ctrc.SP_CopiaMove_CTe(vCteCLone,
                                                        'XXX',
                                                        vRota,
                                                        vCteNovo,
                                                        'XXX',
                                                        vRota,
                                                        'C',
                                                        'N',
                                                        vStatus,
                                                        vMessage);  
                   If nvl(vStatus,'N') = 'N' Then
                      select max(sf.slf_solfrete_saque)
                        into vSlf_Saque
                      from tdvadm.t_slf_solfrete sf
                      where sf.slf_solfrete_codigo = vSlf_Solfrete
                        and nvl(sf.slf_solfrete_status,'N') <> 'S'
                        and sf.slf_solfrete_vigencia <= trunc(sysdate)
                        and sf.slf_solfrete_dataefetiva >= trunc(sysdate);
                       
                      select sf.glb_mercadoria_codigo
                        into vMercadoria
                      from tdvadm.t_slf_solfrete sf
                      where sf.slf_solfrete_codigo = vSlf_Solfrete
                        and sf.slf_solfrete_saque = vSlf_Saque;                        

                      select cs.slf_tpcalculo_codigo
                        into vTpCalculo
                      from tdvadm.t_slf_calcsolfrete cs
                      where cs.slf_solfrete_codigo = vSlf_Solfrete
                        and cs.slf_solfrete_saque = vSlf_Saque
                        and cs.slf_reccust_codigo = 'D_FRPSVO';
                        
                                                     
                        update tdvadm.t_con_conhecimento c
                        set c.con_conhecimento_cst = '00',
                            c.con_conhecimento_obs = 'CTe Gerado para Cobranca do Retorno Vazio Transporte de Carvao da Nota '|| vNota || ' CNPJ ' || vEmitente || ' ',
                            c.con_conhecimento_obslei = null,
                            c.con_conhecimento_tributacao = 'N',
                            c.glb_mercadoria_codigo = vMercadoria,
                            c.slf_solfrete_codigo = vSlf_Solfrete,
                            c.slf_solfrete_saque = vSlf_Saque,
                            c.con_conhecimento_localcoleta = vDestino,
                            c.glb_localidade_codigoorigem  = vDestino,
                            c.con_conhecimento_localentrega = vOrigem,
                            c.glb_localidade_codigodestino = vOrigem
                        where c.con_conhecimento_codigo = vCteNovo
                          and c.con_conhecimento_serie = 'XXX'
                          and c.glb_rota_codigo = vRota;
                        commit;  
                        update tdvadm.t_con_nftransporta nf
                          set nf.con_tpdoc_codigo = '99',
                              nf.con_nftransportada_chavenfe = null,
                              nf.con_nftransportada_numnfiscal = '1'|| substr(nf.con_nftransportada_numnfiscal,2)
                        where nf.con_conhecimento_codigo = vCteNovo
                          and nf.con_conhecimento_serie = 'XXX'
                          and nf.glb_rota_codigo = vRota;
                        
                        update tdvadm.t_con_calcconhecimento ca
                          set ca.slf_tpcalculo_codigo = vTpCalculo,
                              ca.con_calcviagem_valor = 0
                        where ca.con_conhecimento_codigo = vCteNovo
                          and ca.con_conhecimento_serie = 'XXX'
                          and ca.glb_rota_codigo = vRota
                          and ca.slf_reccust_codigo not in ('I_PSCOBRAD','S_PSCOBRAD');

                        update tdvadm.t_con_calcconhecimento ca
                          set ca.con_calcviagem_valor = (select sf.slf_calcsolfrete_valor
                                                         from tdvadm.t_slf_calcsolfrete sf
                                                         where sf.slf_solfrete_codigo = vSlf_Solfrete
                                                           and sf.slf_solfrete_saque = vSlf_Saque
                                                           and sf.slf_reccust_codigo = ca.slf_reccust_codigo)
                        where ca.con_conhecimento_codigo = vCteNovo
                          and ca.con_conhecimento_serie = 'XXX'
                          and ca.glb_rota_codigo = vRota
                          and ca.slf_reccust_codigo not in ('I_PSCOBRAD','S_PSCOBRAD');
                        commit;
                        
                        tdvadm.pkg_slf_calculos.SP_MONTA_FORMULA_CNHC(vTpCalculo,vCteNovo,'XXX',vRota,'N');

                   End If;                 
                   End If;
                   vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Carregamento Fechado com Sucesso...');
                Else
                   vCriticas := vCriticas || pkg_glb_html.fn_ItensLista(trim(vMessage2));
                End If;                   
                exception
                  When OTHERS Then
                    vCriticas := vCriticas;
                End; 
             End Loop;                           
          End If;  
          commit;
       End If;

    End If;

    vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Enviado Email ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));


    wservice.pkg_glb_email.SP_ENVIAEMAIL('Inclusao de Nota e Fechamento de Carregamento',
                                         vProcessamento || PKG_GLB_HTML.LinhaH || vCriticas,
                                         'aut-e@dellavolpe.com.br',
                                         tpRecebido.glb_benasserec_origem,
                                         'lixo@dellavolpe.com.br'--'grp.hd@dellavolpe.com.br' 
                                         );


/*

                     extractvalue(value(field), 'Table/Rowset/Row/notaStatus')                 notaStatus,
                     extractvalue(value(field), 'Table/Rowset/Row/coleta_Codigo')              coleta_Codigo, 
                     extractvalue(value(field), 'Table/Rowset/Row/coleta_Tipo')                coleta_Tipo, 
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Sequencia')             nota_sequencia, 
                     extractvalue(value(field), 'Table/Rowset/Row/nota_numero')                nota_numero,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_serie')                 nota_serie,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtEmissao')             nota_dtEmissao,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtSaida')               nota_dtSaida,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtEntrada')             nota_dtEntrada,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_chaveNFE')              nota_chaveNFE,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_pesoNota')              nota_pesoNota,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_pesoBalanca')           nota_pesoBalanca,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_altura')                nota_altura,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_largura')               nota_largura,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_comprimento')           nota_comprimento,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_cubagem')               nota_cubagem,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_EmpilhamentoFlag')      nota_EmpilhamentoFlag,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_EmpilhamentoQtde')      nota_EmpilhamentoQtde,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_descricao')             nota_descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_qtdeVolume')            nota_qtdeVolume,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_ValorMerc')             nota_ValorMerc,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisTp')              nota_RequisTp,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisCodigo')          nota_RequisCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisSaque')           nota_RequisSaque,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Contrato')              nota_Contrato,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_PO')                    nota_PO,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Di')                    nota_Di,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Vide')                  nota_Vide,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_flagPgto')              nota_flagPgto,
                     extractvalue(value(field), 'Table/Rowset/Row/carga_Codigo')               carga_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/carga_Tipo')                 carga_Tipo,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Sequencia')             vide_Sequencia,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Numero')                vide_Numero,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Cnpj')                  vide_Cnpj,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Serie')                 vide_Serie,
                     extractvalue(value(field), 'Table/Rowset/Row/mercadoria_codigo')          mercadoria_codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/mercadoria_descricao')       mercadoria_descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/cfop_Codigo')                cfop_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/cfop_Descricao')             cfop_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/rota_Codigo')                rota_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/rota_Descricao')             rota_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/armazem_Codigo')             armazem_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/armazem_Descricao')          armazem_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_RSocial')          Remetente_RSocial,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_CodCliente')       Remetente_CodCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_Endereco')         Remetente_Endereco,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_LocalCodigo')      Remetente_LocalCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_LocalDesc')        Remetente_LocalDesc,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_RSocial')            Destino_RSocial, 
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_CodCliente')         Destino_CodCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_Endereco')           Destino_Endereco,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_LocalCodigo')        Destino_LocalCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_LocalDesc')          Destino_LocalDesc,
                     extractvalue(value(field), 'Table/Rowset/Row/Sacado_CNPJ')                Sacado_CNPJ,
                     extractvalue(value(field), 'Table/Rowset/Row/Sacado_RSocial')             Sacado_RSocial,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_tpDoc_codigo')           tpDoc_codigo 
*/


   End spi_processa_NOTATCN;

   Procedure spi_processa_NOTANIQUEL(tpRecebido In Out rmadm.t_glb_benasseREC%Rowtype,
                                     vStatus Out Char,
                                     vMessage Out clob)
   AS
     vQryString     varchar2(500);
     vContador      number;
     vProcessamento clob;
     vCriticas      clob;
     vMessage2      clob; 
     vParamsEntrada Clob;
     vParamsEntradaB Blob;
     vParamsSaida   clob;
     vXmlImput      varchar2(1000);
     vXmlProdQ      varchar2(1000);
     vNota          tdvadm.t_arm_nota.arm_nota_numero%type;
     vEmitente      tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
     vClienteRemet  tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
     vClienteDest   tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
     vTpEndRemet    char(1);
     vTpEndDest     char(1);
     vLocalidadeo   tdvadm.t_glb_localidade.glb_localidade_codigo%type;
     vLocalidaded   tdvadm.t_glb_localidade.glb_localidade_codigo%type;
     vEmbalagem     tdvadm.t_arm_nota.arm_embalagem_numero%type;
     vEmbFlag       tdvadm.t_arm_nota.arm_embalagem_flag%type;
     vEmbSequencia  tdvadm.t_arm_nota.arm_embalagem_sequencia%type;
--     vSerie         tdvadm.t_arm_nota.arm_nota_serie%type;
     vSequencia     tdvadm.t_arm_nota.arm_nota_sequencia%type;
--     vCFOP          tdvadm.t_glb_cfop.glb_cfop_codigo%type;
--     vPeso          tdvadm.t_arm_nota.arm_nota_peso%type;
--     vValor         tdvadm.t_arm_nota.arm_nota_valormerc%type;
     vTpDoc         tdvadm.t_arm_nota.con_tpdoc_codigo%type;
     vUsuario       tdvadm.t_arm_nota.usu_usuario_codigo%type;
     tpCarreg       tdvadm.t_arm_carregamento%rowtype;
     tpCarregDet    tdvadm.t_arm_carregamentodet%rowtype;
     vAuxiliar      number;
     vCodigoBarra   char(44);
     vRetornoVazio  char(1);
     vKM            number;
     vPedido        varchar2(50);
     vPedidoVZ      varchar2(50);
     vCteCLone      tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
     vCteNovo       tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
     vTpCalculo     tdvadm.t_slf_calcsolfrete.slf_tpcalculo_codigo%type;
     vRota          tdvadm.t_arm_nota.glb_rota_codigo%type         := '175';
     vArmazem       tdvadm.t_arm_nota.arm_armazem_codigo%type      := '31';
     vSlf_Solfrete  tdvadm.t_slf_solfrete.slf_solfrete_codigo%type := '00065154';
     vSlf_Saque     tdvadm.t_slf_solfrete.slf_solfrete_saque%type; 
     vSlf_SolfreteV tdvadm.t_slf_solfrete.slf_solfrete_codigo%type := '00065155';
     vSlf_SaqueV    tdvadm.t_slf_solfrete.slf_solfrete_saque%type; 
     vOrigem        tdvadm.t_con_conhecimento.con_conhecimento_localcoleta%type;
     vDestino       tdvadm.t_con_conhecimento.con_conhecimento_localentrega%type;
     vMercadoria    tdvadm.t_con_conhecimento.glb_mercadoria_codigo%type;
     vInicio        number;
     vFim           number;
     vContrato      tdvadm.t_slf_contrato.slf_contrato_codigo%type;
     vOnde          varchar2(30);
     v1Status       char(1);
   Begin
   
      vStatus := pkg_glb_common.Status_Nomal;
      vMessage := chr(10);
      vParamsEntrada := empty_clob();
      vParamsSaida   := empty_clob();
      vProcessamento := empty_clob();
      vCriticas      := empty_clob();
      vCriticas := '<br>';
      vCriticas := pkg_glb_html.Assinatura;
      vCriticas := pkg_glb_html.fn_Titulo('CRITICAS');
      vCriticas := vCriticas || PKG_GLB_HTML.LinhaH;
      vCriticas := vCriticas || pkg_glb_html.fn_AbreLista;
      vProcessamento := pkg_glb_html.Assinatura;
         
      -- Verifica se realmente esta autorizado
      select count(*)
         into vContador
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = 'NIQUEL'
        and pa.edi_planilhacfg_sistema = 'NIQUEL'
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(tpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
      -- verifica se pode autorizar                      

      If vContador > 0 Then 
         vStatus     := 'N';
         vMessage    := '';
      Else
         vStatus     := 'E';
         vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Voce Não esta AUTORIZADO');
         tpRecebido.Glb_Benasserec_Processado := Sysdate;
         tpRecebido.Glb_Benasserec_Status     := 'ER';
      End If;

--       Exemplo MSG=NIQUEL;CODIGOBARRA=15170933592510007590550020000157331889371401;KM=1334;PEDIDO=123456778;PEDIDOVZ=23323345;RETORNOVAZIO=S

      vQryString  := trim(upper(tpRecebido.GLB_BENASSEREC_ASSUNTO));


      vCodigoBarra  := substr(Trim(tdvadm.fn_querystring(vQryString,'CODIGOBARRA','=',';')),1,44);
       vAuxiliar := Length(trim(nvl(vCodigoBarra,'1')));
       
      If Length(trim(nvl(vCodigoBarra,'1'))) < 44 Then
         vStatus     := 'E';
         vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Codigo de Barras Obrigatorio');
         tpRecebido.Glb_Benasserec_Processado := Sysdate;
         tpRecebido.Glb_Benasserec_Status     := 'ER';
      Else
         If F_DIGCONTROLEMODCTE(SUBSTR(vCodigoBarra,1,43)) <> SUBSTR(vCodigoBarra,-1) THEN
             vStatus     := 'E';
             vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Digito Verificador da Barra não confere');
             tpRecebido.Glb_Benasserec_Processado := Sysdate;
             tpRecebido.Glb_Benasserec_Status     := 'ER';
         Else
            vNota     := SubStr(vCodigoBarra,26,09);
            vTpDoc    := substr(vCodigoBarra,21,02);
            vEmitente := substr(vCodigoBarra,07,14);

         End If;

      End If;

      v1Status := nvl(trim(vStatus),'N');
      If nvl(trim(vStatus),'N') = 'N' Then

      vProcessamento := vProcessamento || '<br/><br />';
      vProcessamento := vProcessamento || pkg_glb_html.fn_Titulo('PROCESSAMENTO NIQUEL ' || vNota);
      vProcessamento := vProcessamento || PKG_GLB_HTML.LinhaH;
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_AbreLista;
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Comando Enviado ' || trim(tpRecebido.Glb_Benasserec_Assunto));
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Recepção do E-mail ' || to_char(tpRecebido.Glb_Benasserec_Gravacao,'dd/mm/yyyy hh24:mi:ss'));
      vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Lendo Parametros  ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));

       vRetornoVazio := Trim(tdvadm.fn_querystring(vQryString,'RETVZ','=',';'));
       If trim(vRetornoVazio) <> 'N' Then
          vRetornoVazio := 'S';
       End IF;


       vPedido := tdvadm.fn_querystring(vQryString,'PEDIDO','=',';');
       vPedidoVZ := tdvadm.fn_querystring(vQryString,'PEDIDOVZ','=',';');
 
       Begin
          vKM := replace(replace(replace(Trim(tdvadm.fn_querystring(vQryString,'KM','=',';')),',','*'),'.',''),'*','.');
       exception
       When OTHERS Then
          vStatus     := 'E';
          vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Km com erro ou nao informado!');
          tpRecebido.Glb_Benasserec_Processado := Sysdate;
          tpRecebido.Glb_Benasserec_Status     := 'ER';
       end;   

       Begin
          select u.usu_usuario_codigo
            into vUsuario
          From tdvadm.t_usu_usuario u
          Where lower(u.usu_usuario_email) = tpRecebido.Glb_Benasserec_Origem;
       Exception
         When NO_DATA_FOUND Then
            vStatus := 'E';
            vMessage := 'Email ' || tpRecebido.Glb_Benasserec_Origem || ' Não Cadastrado...';
            vCriticas := vCriticas || vMessage;
         When DUP_VAL_ON_INDEX Then
            vStatus := 'E';
            vMessage := 'Email ' || tpRecebido.Glb_Benasserec_Origem || ' Cadastrada para mais de um Usuario...';
            vCriticas := vCriticas || vMessage;
         When OTHERS Then
            vStatus := 'E';
            vMessage := 'Erro ao definir usuario para email ' || tpRecebido.Glb_Benasserec_Origem ;
            vCriticas := vCriticas || vMessage;
         End ;

       -- Verificar a regra para colocar o usuario

         Begin
         select cd.arm_carregamento_codigo,
                an.arm_nota_numero,
                an.glb_cliente_cgccpfremetente,
                an.arm_nota_sequencia
           into vAuxiliar,
                vNota,
                vClienteRemet,
                vSequencia
                
         from tdvadm.t_arm_nota an,
              tdvadm.t_arm_carregamentodet cd
         where an.arm_nota_chavenfe = vCodigoBarra
           and an.arm_embalagem_numero = cd.arm_embalagem_numero
           and an.arm_embalagem_flag = cd.arm_embalagem_flag
           and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia;
         exception
           when NO_DATA_FOUND Then
              vAuxiliar := 0;
           End;

         If vAuxiliar > 0 Then
             vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Nota Ja tem Carregamento ' || to_char(vAuxiliar) || ' ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
             vStatus := 'E';
         Else
            if vNota is not null Then
               tdvadm.pkg_hd_utilitario.SP_EXCLUI_NOTA_NOVO(vNota,vClienteRemet,'A',vSequencia,vStatus,vMessage2);
            End If;
         End If;

          select count(*)
            into vAuxiliar
          from tdvadm.t_xml_nfe nf
          where nf.xml_nfe_id = vCodigoBarra;
          
          If vAuxiliar = 0 Then
             vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Nota Sem XML ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
             vStatus := 'E';
           End If;      

       If nvl(vStatus,'N') <> 'E' Then
       

          vParamsEntrada := '';
        
--          insert into t_glb_sql values (vParamsEntrada,sysdate,'SIRLANO','XML ENTRADA');
--          commit;



          vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('inserindo Nota ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
          
          vParamsEntrada := '<Parametros>
                                <Inputs>
                                   <input/>
                                   <Input>
                                      <usuario>' || vUsuario || '</usuario>
                                      <aplicacao>carreg</aplicacao>
                                      <rota>' || vRota || '</rota>
                                      <armazem>' || vArmazem ||  '</armazem>
                                      <acao>B</acao>
                                      <tpBusca>2</tpBusca>
                                      <codBusca>' || vCodigoBarra || '</codBusca>
                                      <coleta></coleta>
                                   </Input>
                                </Inputs>
                             </Parametros>';

           
          tdvadm.pkg_fifo_recebimento.sp_insertnota(pparamsentrada => vParamsEntrada,
                                                    pstatus => vStatus,
                                                    pmessage => vMessage2,
                                                    pparamssaida => vParamsSaida);


                             
          if nvl(trim(vStatus),'N') <> 'N' Then
             vCriticas := vCriticas || pkg_glb_html.fn_ItensLista(trim(vMessage2));
          Else
             if trim(vMessage2) <> '' Then
                vCriticas := vCriticas || pkg_glb_html.fn_ItensLista(trim(vMessage2));
                vStatus := 'W';
             End If;   
      --       vImput := '<Parametros><Output><Tables><Table name="prodQuimicos"><ROWSET><row><Sequencia /><codOnu /><onu_desc /><onu_grpEmb /><onu_qtdeemb /><onu_pesoEmb /></row></ROWSET></Table><Table name="servadicionais"><ROWSET><row><Sequencia /><servad_cod /><servad_desc /><servad_cnpjctrc /><servad_tpcliend /><servad_ctrc /><servad_serie /><servad_chavecte /><servad_dtemisao /></row></ROWSET></Table><Table name="dadosNota"><ROWSET><row num=''1 ''><NotaStatus>N</NotaStatus><coleta_Codigo></coleta_Codigo><coleta_Tipo></coleta_Tipo><coleta_ocor></coleta_ocor><coleta_pedido></coleta_pedido><finaliza_digitacao></finaliza_digitacao><nota_tipo></nota_tipo><nota_Sequencia></nota_Sequencia><nota_numero>945340</nota_numero><nota_serie>002</nota_serie><nota_dtEmissao>31/08/2017</nota_dtEmissao><nota_dtSaida></nota_dtSaida><nota_dtEntrada></nota_dtEntrada><nota_chaveNFE>43170809216620000137550020009453401214730657</nota_chaveNFE><nota_pesoNota>79</nota_pesoNota><nota_pesoBalanca>79</nota_pesoBalanca><nota_altura></nota_altura><nota_largura></nota_largura><nota_comprimento></nota_comprimento><nota_cubagem></nota_cubagem><nota_EmpilhamentoFlag></nota_EmpilhamentoFlag><nota_EmpilhamentoQtde></nota_EmpilhamentoQtde><nota_descricao>Copo PP 180ml Branco Normatizado ABNT CX 2500un</nota_descricao><nota_qtdeVolume>20</nota_qtdeVolume><nota_ValorMerc>1570.27</nota_ValorMerc><nota_RequisTp></nota_RequisTp><nota_RequisCodigo></nota_RequisCodigo><nota_RequisSaque></nota_RequisSaque><nota_Contrato></nota_Contrato><nota_PO></nota_PO><nota_Di></nota_Di><nota_Vide></nota_Vide><nota_flagPgto></nota_flagPgto><carga_Codigo></carga_Codigo><carga_Tipo></carga_Tipo><vide_Sequencia></vide_Sequencia><vide_Numero></vide_Numero><vide_Cnpj></vide_Cnpj><vide_Serie></vide_Serie><mercadoria_codigo></mercadoria_codigo><mercadoria_descricao></mercadoria_descricao><cfop_Codigo>6403</cfop_Codigo><cfop_Descricao>Venda de Mercadoria Adquirida ou Recebida de Terceiros em Operacao com Mercadoria Sujeita Ao Regime de Substituicao Tributaria, Na Condicao de Contribuinte Substituto</cfop_Descricao><embalagem_numero></embalagem_numero><embalagem_flag></embalagem_flag><embalagem_sequencia></embalagem_sequencia><rota_Codigo></rota_Codigo><rota_Descricao></rota_Descricao><armazem_Codigo></armazem_Codigo><armazem_Descricao></armazem_Descricao><Remetente_CNPJ>09216620000137</Remetente_CNPJ><Remetente_RSocial>BR SUPPLY COMERCIO E DISTRIBUICAO  DE SUP S/A.</Remetente_RSocial><Remetente_tpCliente></Remetente_tpCliente><Remetente_CodCliente></Remetente_CodCliente><Remetente_Endereco></Remetente_Endereco><Remetente_LocalCodigo></Remetente_LocalCodigo><Remetente_LocalDesc></Remetente_LocalDesc><Destino_CNPJ>33592510004494</Destino_CNPJ><Destino_RSocial>VALE S/A</Destino_RSocial><Destino_tpCliente></Destino_tpCliente><Destino_CodCliente></Destino_CodCliente><Destino_Endereco></Destino_Endereco><Destino_LocalCodigo></Destino_LocalCodigo><Destino_LocalDesc></Destino_LocalDesc><Sacado_CNPJ></Sacado_CNPJ><Sacado_RSocial></Sacado_RSocial><nota_tpDoc_codigo></nota_tpDoc_codigo></row></ROWSET></Table><Table name="tpDocumento"><ROWSET><row num=''1'' > <con_tpdoc_codigo>08</con_tpdoc_codigo><Con_Tpdoc_Descricao>DTA(Despacho de Transito Aduaneiro)</Con_Tpdoc_Descricao><doc_default>55</doc_default></row><row num=''2'' > <con_tpdoc_codigo>13</con_tpdoc_codigo><Con_Tpdoc_Descricao>NF AVULSA</Con_Tpdoc_Descricao><doc_default>55</doc_default></row><row num=''3'' > <con_tpdoc_codigo>55</con_tpdoc_codigo><Con_Tpdoc_Descricao> NFE  S (Saida)</Con_Tpdoc_Descricao><doc_default>55</doc_default></row><row num=''4'' > <con_tpdoc_codigo>56</con_tpdoc_codigo><Con_Tpdoc_Descricao>NFE E (Entrada)</Con_Tpdoc_Descricao><doc_default>55</doc_default></row><row num=''5'' > <con_tpdoc_codigo>99</con_tpdoc_codigo><Con_Tpdoc_Descricao>Outros</Con_Tpdoc_Descricao><doc_default>55</doc_default></row></ROWSET></Table></Tables></Output></Parametros>';
             vAuxiliar := length(vParamsEntrada);
             vParamsEntrada := vParamsSaida;
              
             vInicio := instr(vParamsEntrada,'<Table name="dadosNota">');
             vFim := instr(vParamsEntrada,'</Table>',vInicio) + 10 ;

             vParamsEntrada := substr(vParamsEntrada,vInicio,(vFim-vInicio)-2);
                     
             vXmlImput := '<Parametros>
                              <Inputs>
                                 <Input>
                                    <usuario>' || vUsuario || '</usuario>
                                    <aplicacao>carreg</aplicacao>
                                    <rota>' || vRota || '</rota>
                                    <armazem>' || vArmazem ||  '</armazem>
                                    <acao>E</acao>
                                    <finaliza_coleta>N</finaliza_coleta>
                                    <criar_coleta>S</criar_coleta>
                                    <Tables>';


             vXmlProdQ := '<Table name="prodQuimicos">
                              <Rowset>
                                 <Row num="1">
                                    <codOnu>9999</codOnu>
                                    <DescOnu>PRODUTO QUIMICO SEM CLASSIFICA</DescOnu>
                                    <grp_Emb>SE</grp_Emb>
                                    <qtdeEmb>1</qtdeEmb>
                                    <pesoEmb>1</pesoEmb>
                                 </Row>
                              </Rowset>
                           </Table>';
                 
             vParamsEntrada := trim(vParamsEntrada) || vXmlProdQ;              

             vParamsEntrada := vXmlImput  || trim(vParamsEntrada) || '</Tables></Input></Inputs></Parametros>';

             vParamsEntrada := replace(vParamsEntrada,'<ROWSET>','<Rowset>');
             vParamsEntrada := replace(vParamsEntrada,'</ROWSET>','</Rowset>');
             vParamsEntrada := replace(vParamsEntrada,'<row num=''1 ''>','<Row num="1">');
             vParamsEntrada := replace(vParamsEntrada,'</row>','</Row>');
             vParamsEntrada := replace(vParamsEntrada,'<NotaStatus>','<notaStatus>');
             vParamsEntrada := replace(vParamsEntrada,'</NotaStatus>','</notaStatus>');
             vParamsEntrada := replace(vParamsEntrada,'<coleta_Tipo></coleta_Tipo>','<coleta_Tipo>E</coleta_Tipo>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_Sequencia></nota_Sequencia>','<nota_Sequencia>0</nota_Sequencia>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_EmpilhamentoFlag></nota_EmpilhamentoFlag>','<nota_EmpilhamentoFlag>N</nota_EmpilhamentoFlag>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_Contrato></nota_Contrato>','<nota_Contrato></nota_Contrato>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_Vide></nota_Vide>','<nota_Vide>0</nota_Vide>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_flagPgto></nota_flagPgto>','<nota_flagPgto>R</nota_flagPgto>');
             vParamsEntrada := replace(vParamsEntrada,'<carga_Codigo></carga_Codigo>','<carga_Codigo>0</carga_Codigo>');
             vParamsEntrada := replace(vParamsEntrada,'<carga_Tipo></carga_Tipo>','<carga_Tipo>CA</carga_Tipo>');
          --   vParamsEntrada := replace(vParamsEntrada,'<cfop_Codigo></cfop_Codigo>','<cfop_Codigo>6403</cfop_Codigo>');
             vParamsEntrada := replace(vParamsEntrada,'<rota_Codigo></rota_Codigo>','<rota_Codigo>' || vRota || '</rota_Codigo>');
             vParamsEntrada := replace(vParamsEntrada,'<armazem_Codigo></armazem_Codigo>','<armazem_Codigo>' || vArmazem || '</armazem_Codigo>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_tpDoc_codigo></nota_tpDoc_codigo>','<nota_tpDoc_codigo>55</nota_tpDoc_codigo>');
          --   vParamsEntrada := replace(vParamsEntrada,'','');



              select sf.slf_solfrete_saque,
                     sf.glb_mercadoria_codigo,
                     sf.glb_cliente_cgccpfcodigorem,
                     sf.glb_cliente_cgccpfcodigodes,
                     sf.slf_solfrete_contrato
                 into vSlf_Saque,
                      vMercadoria,
                      vClienteRemet,
                      vClienteDest,
                      vContrato
              from tdvadm.t_slf_solfrete sf
              where sf.slf_solfrete_codigo = vSlf_Solfrete
                and nvl(sf.slf_solfrete_status,'N') = 'N'
                and sf.slf_solfrete_saque = (select max(sf1.slf_solfrete_saque)
                                             from tdvadm.t_slf_solfrete sf1
                                             where sf1.slf_solfrete_codigo = sf.slf_solfrete_codigo
                                               and nvl(sf1.slf_solfrete_status,'N') = 'N');

          --<Remetente_CNPJ>09216620000137</Remetente_CNPJ>
              vTpEndRemet := 'X';
              select ce.glb_localidade_codigo
                into vLocalidadeo
              from tdvadm.t_glb_cliend ce
              where ce.glb_cliente_cgccpfcodigo = vClienteRemet
                and ce.glb_tpcliend_codigo =  vTpEndRemet;                          

          --<Destino_CNPJ>33592510004494</Destino_CNPJ>
              vTpEndDest := 'A';
              select ce.glb_localidade_codigo
                into vLocalidaded
              from tdvadm.t_glb_cliend ce
              where ce.glb_cliente_cgccpfcodigo = vClienteDest
                and ce.glb_tpcliend_codigo = vTpEndDest;                           


             vParamsEntrada := replace(vParamsEntrada,'<nota_Contrato></nota_Contrato>','<nota_Contrato>' || vContrato || '</nota_Contrato>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_RequisTp></nota_RequisTp>','<nota_RequisTp>S</nota_RequisTp>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_RequisCodigo></nota_RequisCodigo>','<nota_RequisCodigo>' || vSlf_Solfrete || '</nota_RequisCodigo>');
             vParamsEntrada := replace(vParamsEntrada,'<nota_RequisSaque></nota_RequisSaque>','<nota_RequisSaque>' || vSlf_Saque || '</nota_RequisSaque>');


             vParamsEntrada := replace(vParamsEntrada,'<mercadoria_codigo></mercadoria_codigo>','<mercadoria_codigo>' || vMercadoria || '</mercadoria_codigo>');
             vParamsEntrada := replace(vParamsEntrada,'<Remetente_tpCliente></Remetente_tpCliente>','<Remetente_tpCliente>' || vTpEndRemet || '</Remetente_tpCliente>');
             vParamsEntrada := replace(vParamsEntrada,'<Remetente_LocalCodigo></Remetente_LocalCodigo>','<Remetente_LocalCodigo>' || vLocalidadeo || '</Remetente_LocalCodigo>');
             -- Troco o CNPJ de Destino da nota para o Chines
             vParamsEntrada := replace(vParamsEntrada,'<Destino_CNPJ>' || trim(vClienteRemet) || '</Destino_CNPJ>','<Destino_CNPJ>' || trim(vClienteDest) || '</Destino_CNPJ>');
             vParamsEntrada := replace(vParamsEntrada,'<Destino_tpCliente></Destino_tpCliente>','<Destino_tpCliente>' || vTpEndDest || '</Destino_tpCliente>');
             vParamsEntrada := replace(vParamsEntrada,'<Destino_LocalCodigo></Destino_LocalCodigo>','<Destino_LocalCodigo>' || vLocalidaded || '</Destino_LocalCodigo>');
                  
            tdvadm.pkg_fifo_recebimento.sp_insertnota(pparamsentrada => vParamsEntrada,
                                                      pstatus => vStatus,
                                                      pmessage => vMessage2,
                                                      pparamssaida => vParamsSaida);

             
             
             
          vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Alterando Nota ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));

          
          if nvl(trim(vStatus),'N') = 'N' Then             
             select an.arm_embalagem_numero,
                    an.arm_embalagem_flag,
                    an.arm_embalagem_sequencia
               into vEmbalagem,
                    vEmbFlag,
                    vEmbSequencia
             from tdvadm.t_arm_nota an
             where an.arm_nota_chavenfe = vCodigoBarra;


                    tpCarreg.Arm_Armazem_Codigo                := vArmazem;
                    tpCarreg.Fcf_Tpveiculo_Codigo              := '3';
                    tpCarreg.Usu_Usuario_Crioucarreg           := vUsuario;
                    tpCarreg.Arm_Carregamento_Qtdctrc          := 0;
                    tpCarreg.Arm_Carregamento_Qtdimpctrc       := 0;
                    tpCarreg.Arm_Carregamento_Flagmanifesto    := null;
                    tpCarreg.Arm_Carregamento_Dtcria           := SYSDATE;
                    tpCarregDet.Arm_Embalagem_Numero           := vEmbalagem;
                    tpCarregDet.Arm_Embalagem_Flag             := vEmbFlag;
                    tpCarregDet.Arm_Embalagem_Sequencia        := vEmbSequencia;
                    tpCarregDet.Glb_Cliente_Cgccpfdestinatario := vClienteDest;
                    tpCarregDet.Glb_Tpcliend_Coddestinatario   := vTpEndDest;
                    tpCarregDet.Glb_Cliente_Cgccpfcodigo       := vClienteRemet;
                    tpCarregDet.Glb_Tpcliend_Codigo            := vTpEndRemet;

                    select max(to_number(ca.arm_carregamento_codigo)) + 1
                       into tpCarreg.Arm_Carregamento_Codigo
                    from tdvadm.t_arm_carregamento ca;

    /* Verificar qual o Tipo de Documento
                    UPDATE TDVADM.T_ARM_NOTA AN
                       SET AN.CON_TPDOC_CODIGO = vTpDoc
                    WHERE AN.ARM_EMBALAGEM_NUMERO = vEmbalagem
                      AND AN.ARM_EMBALAGEM_FLAG = vEmbFlag
                      AND AN.ARM_EMBALAGEM_SEQUENCIA = vEmbSequencia;            
    */                
                    insert into tdvadm.t_arm_carregamento c values tpCarreg;
                    commit;

                    tpCarregDet.Arm_Carregamento_Codigo := tpCarreg.Arm_Carregamento_Codigo;
                    insert into tdvadm.t_arm_carregamentodet c values tpCarregDet;
                    -- coloca o Carregamento na Embalagem
                    update tdvadm.t_arm_embalagem eb
                       set eb.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo
                    where eb.arm_embalagem_numero = vEmbalagem
                      and eb.arm_embalagem_flag   = vEmbFlag
                      and eb.arm_embalagem_sequencia = vEmbSequencia;   
                    commit;

                    vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Criado carregamento ' || tpCarreg.Arm_Carregamento_Codigo || ' ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
                    vOnde := 'Antes de Fechar';
                    tdvadm.pkg_fifo_carregamento.SP_FECHA_CARREGAMENTO(tpCarreg.Arm_Carregamento_Codigo,
                                                                       vArmazem,
                                                                       vUsuario,
                                                                       vStatus,
                                                                       vMessage2);

                   vOnde := 'Depois de Fechar'; 
                if nvl(trim(vStatus),'N') = 'N' Then
                    vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Carregamento Fechado ' || tpCarreg.Arm_Carregamento_Codigo || ' ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));

                   select c.con_conhecimento_codigo,
                          c.con_conhecimento_localcoleta,
                          c.con_conhecimento_localentrega
                      into vCteCLone,
                           vOrigem,
                           vDestino
                   from tdvadm.t_con_conhecimento c
                   where c.arm_carregamento_codigo = tpCarreg.Arm_Carregamento_Codigo;


                   vCteNovo := CON_SEQCONHECIMENTO_CODIGO.NEXTVAL;
                   
                   update tdvadm.t_con_conhecimento c
                     set c.con_conhecimento_obs = trim(c.con_conhecimento_obs) || ' Pedido ' || vPedido                    
                   where c.con_conhecimento_codigo = vCteCLone
                     and c.con_conhecimento_serie = 'XXX'
                     and c.glb_rota_codigo = vRota;

                   update tdvadm.t_con_nftransporta nf
                     set nf.con_tpdoc_codigo = '55'
                   where nf.con_conhecimento_codigo = vCteCLone
                     and nf.con_conhecimento_serie = 'XXX'
                     and nf.glb_rota_codigo = vRota;
                     
                   -- Altera o Valor do Frete
                   update tdvadm.t_con_calcconhecimento c
                     set c.con_calcviagem_valor = c.con_calcviagem_valor * vKm,
                         c.con_calcviagem_desinencia = 'VL'
                   where c.con_conhecimento_codigo = vCteCLone
                     and c.con_conhecimento_serie = 'XXX'
                     and c.glb_rota_codigo = vRota
                     and c.slf_reccust_codigo = 'D_FRPSVO';

                   vOnde := 'Calculando';  
                   tdvadm.pkg_slf_calculos.SP_MONTA_FORMULA_CNHC(vTpCalculo,vCteCLone,'XXX',vRota,'N');
      
                   If nvl(vRetornoVazio,'S') = 'S' Then

                   vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Criando retorno ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
                   vOnde := 'Fazendo Copia';
                   tdvadm.pkg_con_ctrc.SP_CopiaMove_CTe(vCteCLone,
                                                        'XXX',
                                                        vRota,
                                                        vCteNovo,
                                                        'XXX',
                                                        vRota,
                                                        'C',
                                                        'N',
                                                        vStatus,
                                                        vMessage);  
                   vOnde := 'Depois da Copia';
                   If nvl(trim(vStatus),'N') = 'N' Then
                      select max(sf.slf_solfrete_saque)
                        into vSlf_SaqueV
                      from tdvadm.t_slf_solfrete sf
                      where sf.slf_solfrete_codigo = vSlf_SolfreteV
                        and nvl(sf.slf_solfrete_status,'N') <> 'S'
                        and sf.slf_solfrete_vigencia <= trunc(sysdate)
                        and sf.slf_solfrete_dataefetiva >= trunc(sysdate);
                       
                      select sf.glb_mercadoria_codigo
                        into vMercadoria
                      from tdvadm.t_slf_solfrete sf
                      where sf.slf_solfrete_codigo = vSlf_SolfreteV
                        and sf.slf_solfrete_saque = vSlf_SaqueV;                        

                      select cs.slf_tpcalculo_codigo
                        into vTpCalculo
                      from tdvadm.t_slf_calcsolfrete cs
                      where cs.slf_solfrete_codigo = vSlf_SolfreteV
                        and cs.slf_solfrete_saque = vSlf_SaqueV
                        and cs.slf_reccust_codigo = 'D_FRPSVO';
                        
                     vOnde := 'Atuializando CTe Vazio';                         
                        update tdvadm.t_con_conhecimento c
                        set c.con_conhecimento_cst = '00',
                            c.con_conhecimento_obs = 'CTe Gerado para Cobranca do Retorno Vazio Transporte de Niquel da Nota '|| vNota || ' CNPJ ' || vEmitente || ' Pedido ' || vPedidoVZ ,
                            c.con_conhecimento_obslei = null,
                            c.con_conhecimento_tributacao = 'N',
                            c.glb_mercadoria_codigo = vMercadoria,
                            c.slf_solfrete_codigo = vSlf_SolfreteV,
                            c.slf_solfrete_saque = vSlf_SaqueV,
                            c.con_conhecimento_localcoleta = vDestino,
                            c.glb_localidade_codigoorigem  = vDestino,
                            c.con_conhecimento_localentrega = vOrigem,
                            c.glb_localidade_codigodestino = vOrigem
                        where c.con_conhecimento_codigo = vCteNovo
                          and c.con_conhecimento_serie = 'XXX'
                          and c.glb_rota_codigo = vRota;
                        commit;  
                        update tdvadm.t_con_nftransporta nf
                          set nf.con_tpdoc_codigo = '99',
                              nf.con_nftransportada_chavenfe = null,
                              nf.con_nftransportada_numnfiscal = '1'|| substr(nf.con_nftransportada_numnfiscal,2)
                        where nf.con_conhecimento_codigo = vCteNovo
                          and nf.con_conhecimento_serie = 'XXX'
                          and nf.glb_rota_codigo = vRota;
                        
                        update tdvadm.t_con_calcconhecimento ca
                          set ca.slf_tpcalculo_codigo = vTpCalculo,
                              ca.con_calcviagem_valor = 0
                        where ca.con_conhecimento_codigo = vCteNovo
                          and ca.con_conhecimento_serie = 'XXX'
                          and ca.glb_rota_codigo = vRota
                          and ca.slf_reccust_codigo not in ('I_PSCOBRAD','S_PSCOBRAD');

                        update tdvadm.t_con_calcconhecimento ca
                          set ca.con_calcviagem_valor = (select sf.slf_calcsolfrete_valor
                                                         from tdvadm.t_slf_calcsolfrete sf
                                                         where sf.slf_solfrete_codigo = vSlf_SolfreteV
                                                           and sf.slf_solfrete_saque = vSlf_SaqueV
                                                           and sf.slf_reccust_codigo = ca.slf_reccust_codigo)
                        where ca.con_conhecimento_codigo = vCteNovo
                          and ca.con_conhecimento_serie = 'XXX'
                          and ca.glb_rota_codigo = vRota
                          and ca.slf_reccust_codigo not in ('I_PSCOBRAD','S_PSCOBRAD');

                       -- Altera o Valor do Frete
                       update tdvadm.t_con_calcconhecimento c
                         set c.con_calcviagem_valor = c.con_calcviagem_valor * vKm,
                             c.con_calcviagem_desinencia = 'VL'
                       where c.con_conhecimento_codigo = vCteNovo
                         and c.con_conhecimento_serie = 'XXX'
                         and c.glb_rota_codigo = vRota
                         and c.slf_reccust_codigo = 'D_FRPSVO';


                        commit;
                        vOnde := 'Calculando';
                        tdvadm.pkg_slf_calculos.SP_MONTA_FORMULA_CNHC(vTpCalculo,vCteNovo,'XXX',vRota,'N');

                   End If;                 
                   End If;
                   vCriticas := vCriticas || pkg_glb_html.fn_ItensLista('Carregamento Fechado com Sucesso...');
                Else
                   vCriticas := vOnde || vCriticas || pkg_glb_html.fn_ItensLista(trim(vMessage2));
                End If;                   
                 -- ALURA
             End If;                           
          End If;  
          commit;
       End If;

    End If;

    vProcessamento := vProcessamento || PKG_GLB_HTML.fn_ItensLista('Enviado Email ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));


    wservice.pkg_glb_email.SP_ENVIAEMAIL('Inclusao de Nota e Fechamento de Carregamento',
                                         vProcessamento || PKG_GLB_HTML.LinhaH || vCriticas,
                                         'aut-e@dellavolpe.com.br',
                                         tpRecebido.glb_benasserec_origem );


/*

                     extractvalue(value(field), 'Table/Rowset/Row/notaStatus')                 notaStatus,
                     extractvalue(value(field), 'Table/Rowset/Row/coleta_Codigo')              coleta_Codigo, 
                     extractvalue(value(field), 'Table/Rowset/Row/coleta_Tipo')                coleta_Tipo, 
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Sequencia')             nota_sequencia, 
                     extractvalue(value(field), 'Table/Rowset/Row/nota_numero')                nota_numero,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_serie')                 nota_serie,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtEmissao')             nota_dtEmissao,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtSaida')               nota_dtSaida,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_dtEntrada')             nota_dtEntrada,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_chaveNFE')              nota_chaveNFE,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_pesoNota')              nota_pesoNota,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_pesoBalanca')           nota_pesoBalanca,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_altura')                nota_altura,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_largura')               nota_largura,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_comprimento')           nota_comprimento,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_cubagem')               nota_cubagem,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_EmpilhamentoFlag')      nota_EmpilhamentoFlag,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_EmpilhamentoQtde')      nota_EmpilhamentoQtde,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_descricao')             nota_descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_qtdeVolume')            nota_qtdeVolume,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_ValorMerc')             nota_ValorMerc,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisTp')              nota_RequisTp,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisCodigo')          nota_RequisCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_RequisSaque')           nota_RequisSaque,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Contrato')              nota_Contrato,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_PO')                    nota_PO,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Di')                    nota_Di,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_Vide')                  nota_Vide,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_flagPgto')              nota_flagPgto,
                     extractvalue(value(field), 'Table/Rowset/Row/carga_Codigo')               carga_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/carga_Tipo')                 carga_Tipo,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Sequencia')             vide_Sequencia,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Numero')                vide_Numero,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Cnpj')                  vide_Cnpj,
                     extractvalue(value(field), 'Table/Rowset/Row/vide_Serie')                 vide_Serie,
                     extractvalue(value(field), 'Table/Rowset/Row/mercadoria_codigo')          mercadoria_codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/mercadoria_descricao')       mercadoria_descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/cfop_Codigo')                cfop_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/cfop_Descricao')             cfop_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/rota_Codigo')                rota_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/rota_Descricao')             rota_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/armazem_Codigo')             armazem_Codigo,
                     extractvalue(value(field), 'Table/Rowset/Row/armazem_Descricao')          armazem_Descricao,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_RSocial')          Remetente_RSocial,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_CodCliente')       Remetente_CodCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_Endereco')         Remetente_Endereco,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_LocalCodigo')      Remetente_LocalCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/Remetente_LocalDesc')        Remetente_LocalDesc,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_RSocial')            Destino_RSocial, 
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_CodCliente')         Destino_CodCliente,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_Endereco')           Destino_Endereco,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_LocalCodigo')        Destino_LocalCodigo,
                     extractvalue(value(field), 'Table/Rowset/Row/Destino_LocalDesc')          Destino_LocalDesc,
                     extractvalue(value(field), 'Table/Rowset/Row/Sacado_CNPJ')                Sacado_CNPJ,
                     extractvalue(value(field), 'Table/Rowset/Row/Sacado_RSocial')             Sacado_RSocial,
                     extractvalue(value(field), 'Table/Rowset/Row/nota_tpDoc_codigo')           tpDoc_codigo 
*/


   End spi_processa_NOTANIQUEL;



   procedure SPI_ConfirmaComprovante( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                      pStatus out char,
                                      pMessage out clob
                                    ) is
     vAuxiliar  number;
     vInicio    integer;
     vTotal     integer;
     vChave     char(44);
     vDocumento char(10);
     vGrupoEconomico tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
     vRemetente    varchar2(100);
     vDestinatario varchar2(100);
     vOk        char(1);
     vMessageTemp  Varchar2(2000);
     vMessage     clob;
     vMessageLOC clob;
     vMessageNLOC clob;
     vTpImagem  tdvadm.t_glb_compimagem%rowtype; 
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'OK';
     pStatus := pkg_glb_common.Status_Nomal;
     vInicio := 1;
     vTotal := length(trim(pTpRecebido.Glb_Benasserec_Corpo));
     
     vMessageNLOC := empty_clob;
     vMessageLOC  := empty_clob;
     Begin
       
     --Exemplo de QryString = MSG=PETRANSXXX;RETROAGE=0
      vMessage := pkg_glb_html.Assinatura || '<br />';
      vMessage := vMessage || pkg_glb_html.fn_Titulo('Consulta de Comprovantes');
      vMessage := vMessage || pkg_glb_html.LinhaH;
      loop
        vChave := trim(substr(pTpRecebido.Glb_Benasserec_Corpo,vInicio,44));
        vOk := 'S';
        Begin
            vMessageTemp := '';
            vMessageTemp := vMessageTemp || pkg_glb_html.fn_AbreLista;
            vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista(vChave);
            vMessageTemp := vMessageTemp || pkg_glb_html.fn_AbreLista;
           select cte.con_conhecimento_codigo || '-' || cte.glb_rota_codigo,
                  cls.glb_grupoeconomico_codigo,
                  f_mascara_cgccpf(trim(clr.glb_cliente_cgccpfcodigo)) || '-' || trim(clr.glb_cliente_razaosocial),
                  f_mascara_cgccpf(trim(cld.glb_cliente_cgccpfcodigo)) || '-' || trim(cld.glb_cliente_razaosocial)
             into vDocumento,
                  vGrupoEconomico,
                  vRemetente,
                  vDestinatario
           from tdvadm.t_con_controlectrce cte,
                tdvadm.t_con_conhecimento c,
                tdvadm.t_glb_cliente cls,
                tdvadm.t_glb_cliente clr,
                tdvadm.t_glb_cliente cld
           where cte.con_controlectrce_chavesefaz = vChave
             and cte.con_conhecimento_codigo = c.con_conhecimento_codigo
             and cte.con_conhecimento_serie = c.con_conhecimento_serie
             and cte.glb_rota_codigo = c.glb_rota_codigo
             and c.glb_cliente_cgccpfsacado = cls.glb_cliente_cgccpfcodigo
             and c.glb_cliente_cgccpfremetente = clr.glb_cliente_cgccpfcodigo
             and c.glb_cliente_cgccpfdestinatario = cld.glb_cliente_cgccpfcodigo;
             vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Documento - ' || vDocumento);
             if pTpRecebido.Glb_Benasserec_Origem = 'm.martins@sap.com' Then
                if vGrupoEconomico <> '0020' Then
                   vOk := 'N';
                   vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Documento não e do GRUPO da VALE');
                End If;
             End If;
        exception
          When NO_DATA_FOUND Then
            vOk := 'N';
            vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Documento Não Encontrado');
        End;
        if vOk = 'S' Then
            Begin
                select ci.*
                  into vTpImagem
                from tdvadm.t_glb_compimagem ci,
                     tdvadm.t_con_controlectrce cte
                where ci.con_conhecimento_codigo = cte.con_conhecimento_codigo
                  and ci.con_conhecimento_serie = cte.con_conhecimento_serie
                  and ci.glb_rota_codigo = cte.glb_rota_codigo
                  and cte.con_controlectrce_chavesefaz = vChave
                  and ci.glb_grupoimagem_codigo = '04' -- Grupo Cte
                  and ci.glb_tpimagem_codigo = '0001' -- Frente
                  and ci.glb_subgrupoimagem_codigo = '02'; -- Comprovante
                vAuxiliar := 1;
            Exception
              When OTHERS Then
                vAuxiliar := 0;
              End;    
            if vAuxiliar = 0 Then  
                vOk := 'N';
                vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Frete Não Encontrado');
            Else          
                vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Acessar Frente Imagem - ' || coleta.pkg_web_auxiliar.fn_retornaLinkCTRC(vTpImagem.Con_Conhecimento_Codigo,vTpImagem.Glb_Rota_Codigo,vTpImagem.Con_Conhecimento_Serie,'F'));
                vMessageTemp := vMessageTemp || 'Remetente ' || vRemetente;
                vMessageTemp := vMessageTemp || 'Destinatario ' || vDestinatario;
                vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Disponivel ' || to_char(vTpImagem.Glb_Compimagem_Disponivel,'dd/mm/yyyy hh24:mi') || ' Feito por ' || vTpImagem.Usu_Usuario_Codigoconf);
            End If;          
            Begin
                select ci.*
                  into vTpImagem
                from tdvadm.t_glb_compimagem ci,
                     tdvadm.t_con_controlectrce cte
                where ci.con_conhecimento_codigo = cte.con_conhecimento_codigo
                  and ci.con_conhecimento_serie = cte.con_conhecimento_serie
                  and ci.glb_rota_codigo = cte.glb_rota_codigo
                  and cte.con_controlectrce_chavesefaz = vChave
                  and ci.glb_grupoimagem_codigo = '04' -- Grupo Cte
                  and ci.glb_tpimagem_codigo = '0002' -- Verso
                  and ci.glb_subgrupoimagem_codigo = '02'; -- Comprovante
                vAuxiliar := 1;
            Exception
              When OTHERS Then
                vAuxiliar := 0;
              End;    
            if vAuxiliar = 0 Then  
                vOk := 'N';
                vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Verso Não Encontrado');
            Else          
                vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Acessar Verso Imagem - ' || coleta.pkg_web_auxiliar.fn_retornaLinkCTRC(vTpImagem.Con_Conhecimento_Codigo,vTpImagem.Glb_Rota_Codigo,vTpImagem.Con_Conhecimento_Serie,'V'));
                vMessageTemp := vMessageTemp || pkg_glb_html.fn_ItensLista('Disponivel ' || to_char(vTpImagem.Glb_Compimagem_Disponivel,'dd/mm/yyyy hh24:mi') || ' Feito por ' || vTpImagem.Usu_Usuario_Codigoconf);
            End If;          
        End If;    
        vMessageTemp := vMessageTemp || pkg_glb_html.fn_FechaLista;
        vMessageTemp := vMessageTemp || pkg_glb_html.fn_FechaLista;
        vInicio := vInicio + 44;
        if vOk = 'S' Then
           VmessageLOC := VmessageLOC || vMessageTemp;
        Else
           VmessageNLOC := VmessageNLOC || vMessageTemp;
        End If;
        vMessageTemp := '';

        loop 
           vInicio := vInicio + 1;
           exit when f_enumerico(substr(pTpRecebido.Glb_Benasserec_Corpo,vInicio,1)) = 'S';
           exit When vInicio >= vTotal;
        End Loop;           
        exit when vInicio >= vTotal;
      end loop;
     

      vMessage := vMessage || pkg_glb_html.fn_Titulo('Documento Não Encontrados');
      vMessage := vMessage || pkg_glb_html.LinhaH;
      vMessage := vMessage || vMessageNLOC ;
      vMessage := vMessage || pkg_glb_html.LinhaH;
      vMessage := vMessage || pkg_glb_html.fn_Titulo('Documento Encontrados');
      vMessage := vMessage || pkg_glb_html.LinhaH;
      vMessage := vMessage || vMessageLOC ;
      vMessage := vMessage || pkg_glb_html.LinhaH;
      
       
       
     
       pTpRecebido.Glb_Benasserec_Status := 'OK';
       pMessage := vMessage;
       
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Erro Rodando Confirmação de Comprovantes . ' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
     End;
     
     wservice.pkg_glb_email.SP_ENVIAEMAIL('Consulta de comprovantes',
                                          pMessage,
                                          'aut-e@dellavolpe.com.br',
                                          pTpRecebido.glb_benasserec_origem);
     
     
   end SPI_ConfirmaComprovante;                                                                  



   procedure SPI_ConfirmaNotasEmbarcadas( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                          pStatus out char,
                                          pMessage out clob
                                        ) is
     vDestinatario varchar2(100);
     vMessage      varchar2(1000);
     vNotas        clob;
     vQryString    rmadm.t_glb_benasserec.GLB_BENASSEREC_ASSUNTO%type;
     vValeFrete    char(10);
     vContador     number;
     vPlaca        varchar2(20);
     vMotorista    varchar2(50);
     vEntrega      varchar2(50);
     vCPFMot       tdvadm.t_con_valefrete.con_valefrete_carreteiro%type;
     vCursor       PKG_EDI_PLANILHA.T_CURSOR;
     vLinha1       pkg_glb_SqlCursor.tpString1024;
     vEmissao      date;
     vSaque        tdvadm.t_con_valefrete.con_valefrete_saque%type;
     vGrupo        TDVADM.T_SLF_CLIREGRASEMAIL.GLB_GRUPOECONOMICO_CODIGO%type;
     vCnpj         TDVADM.T_SLF_CLIREGRASEMAIL.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
     vContrato     TDVADM.T_SLF_CLIREGRASEMAIL.SLF_CONTRATO_CODIGO%TYPE;
     i             iNTEGER;
     vEmail        varchar2(20000);
     vEmailCopia   varchar2(2000);
     vEmail1       varchar2(500);
     vEmail2       varchar2(500);
     vEmail3       varchar2(500);
     vSQL          varchar2(1000);
     vColunasQtde  varchar2(100)   := 'SELECT COUNT(*) ' || chr(10);
     vColunaseml   varchar2(200)   := 'SELECT DISTINCT E.SLF_CLIREGRASEMAIL_EMAIL EMAIL,E.SLF_CLIREGRASEMAIL_ENVIOINDIVIDUAL ENVIOINDIVIDUAL' || chr(10);
     vTabelas      varchar2(100)   := 'FROM TDVADM.T_SLF_CLIREGRASEMAIL E' || chr(10);
     vWhereFixo    varchar2(1000) := 'WHERE E.SLF_CLIREGRASEMAIL_ATIVO = ''S''' || chr(10);
     vWhereGRP     varchar2(1000) := '  AND E.GLB_GRUPOECONOMICO_CODIGO = ''<<GRP>>''' || chr(10);
     vWhereCNPJ    varchar2(1000) := '  AND E.GLB_CLIENTE_CGCCPFCODIGO = ''<<vCNPJ>>''' || chr(10);
     vWhereCTO     varchar2(1000) := '  AND E.SLF_CONTRATO_CODIGO = ''<<vCONTRATO>>''' || chr(10);
     vWhere        varchar2(1000);
     vAchou        integer;
     v_Email       varchar2(100);
     v_EmailIndividual char(1);
     c_email       T_CURSOR;

   Begin
     

--     vEmailCopia := '';
    
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'OK';
     pStatus := pkg_glb_common.Status_Nomal;
     vNotas  := empty_clob;
     Begin
       
--       Exemplo MSG=LISTNOTA;MINUTA=9876459871;GRUPO=0535


        vQryString  := trim(upper(pTpRecebido.GLB_BENASSEREC_ASSUNTO));

        if vQryString is null Then
           vQryString := 'MSG=LISTNOTA;MINUTA=1083481701;GRUPO=0612;CNPJ=05053020000306;CONTRATO=C2017010106';
           pTpRecebido.GLB_BENASSEREC_ASSUNTO := 'MSG=LISTNOTA;MINUTA=1083481701;GRUPO=0612;CNPJ=05053020000306;CONTRATO=C2017010106';
           vEmail := 'sdrumond@dellavolpe.com.br';
        End If;  
        
        vContador := 0;
        vValeFrete  := substr(Trim(tdvadm.fn_querystring(vQryString,'MINUTA','=',';')),1,10);
        vGrupo      := Trim(tdvadm.fn_querystring(vQryString,'GRUPO','=',';'));
        vCnpj       := Trim(tdvadm.fn_querystring(vQryString,'CNPJ','=',';'));
        vContrato   := Trim(tdvadm.fn_querystring(vQryString,'CONTRATO','=',';'));

        If vValeFrete <> '7480371971' Then

                    
          vWhere := vWhereFixo;   
          vWhere := vWhere || replace(vWhereGRP,'<<GRP>>',vGrupo);
          vWhere := vWhere || replace(vWhereCNPJ,'<<vCNPJ>>',vCnpj);
          vWhere := vWhere || replace(vWhereCTO,'<<vCONTRATO>>',vContrato);
          vSQL :=  vColunasQtde || vTabelas || vWhere;
          execute immediate vSql into vAchou;
          If vAchou = 0 Then
            
              vWhere := vWhereFixo;   
              vWhere := vWhere || replace(vWhereGRP,'<<GRP>>',vGrupo);
              vWhere := vWhere || replace(vWhereCNPJ,'<<vCNPJ>>',vCnpj);
              vSQL :=  vColunasQtde || vTabelas || vWhere;
              execute immediate vSql into vAchou;
              If vAchou = 0 Then

                  vWhere := vWhereFixo;   
                  vWhere := vWhere || replace(vWhereGRP,'<<GRP>>',vGrupo);
                  vWhere := vWhere || replace(vWhereCTO,'<<vCONTRATO>>',vContrato);
                  vSQL :=  vColunasQtde || vTabelas || vWhere;
                  execute immediate vSql into vAchou;
                  If vAchou = 0 Then
                   
                      vWhere := vWhereFixo;   
                      vWhere := vWhere || replace(vWhereCNPJ,'<<vCNPJ>>',vCnpj);
                      vWhere := vWhere || replace(vWhereCTO,'<<vCONTRATO>>',vContrato);
                      vSQL :=  vColunasQtde || vTabelas || vWhere;
                      execute immediate vSql into vAchou;
                      If vAchou = 0 Then

                          vWhere := vWhereFixo;   
                          vWhere := vWhere || replace(vWhereCNPJ,'<<vCNPJ>>',vCnpj);
                          vSQL :=  vColunasQtde || vTabelas || vWhere;
                          execute immediate vSql into vAchou;
                          If vAchou = 0 Then
                                
                              vWhere := vWhereFixo;   
                              vWhere := vWhere || replace(vWhereCTO,'<<vCONTRATO>>',vContrato);
                              vSQL :=  vColunasQtde || vTabelas || vWhere;
                              execute immediate vSql into vAchou;
                              If vAchou = 0 Then

                                  vWhere := vWhereFixo;   
                                  vWhere := vWhere || replace(vWhereGRP,'<<GRP>>',vGrupo);
                                  vSQL :=  vColunasQtde || vTabelas || vWhere;
                                  execute immediate vSql into vAchou;
                               
                              End If;

                          End If;


                       
                      End If;
                      
                  End If;

              End If;
          End If;
          
          vEmail := '';
          vSQL :=  vColunaseml || vTabelas || vWhere;
        End If;
         
       
        if pTpRecebido.glb_benasserec_origem not in ('tdv.operacao@dellavolpe.com.br','aut-e@dellavolpe.com.br') Then
           vEmail := vEmail || pTpRecebido.glb_benasserec_origem;
        End If;

        

        if  pTpRecebido.Glb_Benasserec_Origem in ('tdv.operacao@dellavolpe.com.br','aut-e@dellavolpe.com.br') Then
           select min(vf.con_valefrete_saque)
              into vSaque
           from tdvadm.t_con_valefrete vf
           WHERE VF.CON_CONHECIMENTO_CODIGO = SUBSTR(vValeFrete,1,6)
             AND VF.GLB_ROTA_CODIGO = SUBSTR(vValeFrete,7,3)
             and nvl(vf.con_valefrete_status,'N') = 'N'
             and nvl(vf.con_valefrete_impresso,'N') = 'S';
        Else
           vSaque  := SUBSTR(vValeFrete,10,1) ;
        End If;


        -- verifica se ja não existe alguma outra soliucitacação
        select count(*)
          into vContador
        from rmadm.t_glb_benasserec br
        where 0 = 0
          and br.glb_benasserec_origem = pTpRecebido.Glb_Benasserec_Origem
          and br.glb_benasserec_assunto = pTpRecebido.Glb_Benasserec_Assunto
          and br.glb_benasserec_status <> 'ER';
          
        if vContador > 1 then
           pTpRecebido.Glb_Benasserec_Status := 'ER';
           pMessage := 'Ja existe uma solictacao deste ROMANEIO ' || vValeFrete ;
           vEmail := '';
           return;
          
        End If;

        -- Primeiro Saque Valido e Rotas <> das 900
        if ( vSaque  = SUBSTR(vValeFrete,10,1) ) and ( SUBSTR(vValeFrete,7,1) <> '9' ) Then

        


        Begin
           select vf.con_valefrete_placa,
                  vf.con_valefrete_carreteiro ca,
                  vf.con_valefrete_datacadastro
             into vPlaca,
                  vCPFMot,
                  vEmissao
           from tdvadm.t_con_valefrete vf
           WHERE VF.CON_CONHECIMENTO_CODIGO = SUBSTR(vValeFrete,1,6)
             AND VF.GLB_ROTA_CODIGO = SUBSTR(vValeFrete,7,3) 
             AND VF.CON_VALEFRETE_SAQUE = SUBSTR(vValeFrete,10,1);

           if substr(vPlaca,1,3) = '000' Then
              select distinct m.frt_motorista_nome
                 into vMotorista
              from tdvadm.t_frt_motorista m
              where m.frt_motorista_cpf = vCPFMot
                and rownum = 1;         
           Else    
              select distinct ca.car_carreteiro_nome
                 into vMotorista
              from tdvadm.t_car_carreteiro ca
              where ca.car_carreteiro_cpfcodigo = vCPFMot
                and rownum = 1;         
           End If;
        exception
          When NO_DATA_FOUND Then
             vPlaca := 'VFERRADO';
             vEmail := 'sdrumond@dellavolpe.com.br';
        end;  
       
       
     --Exemplo de QryString = MSG=LISTNOTA;MINUTA=0549686301
     
     
        if vPlaca <> 'VFERRADO' Then


           vMessage := pkg_glb_html.Assinatura || '<br />';
           vMessage := vMessage || 'Use o Link abaixo para Gerar uma copia em EXCEL/PDF <br />';
           vMessage := vMessage || 'http://extranet.dellavolpe.com.br:6917/gerplanilha/get/result?codigoPlanilha=romVale' || 
                                   '&ValeFrete=' || SUBSTR(vValeFrete,1,6) || 
                                   '&Rota=' || SUBSTR(vValeFrete,7,3) || 
                                   '&Saque=' || SUBSTR(vValeFrete,10,1) || 
                                   '&GrupoEconomico=' || vGrupo ||
                                   '&usuarioChamou=aut-e <br /><br />';
           vMessage := vMessage || pkg_glb_html.fn_Titulo('MOTORISTA - ' || vMotorista );
           vMessage := vMessage || pkg_glb_html.LinhaH;
 
           pTpRecebido.Glb_Benasserec_Status := 'OK';
           pMessage := vMessage || vNotas || pkg_glb_html.LinhaH;
 
           vContador := 0;
           
           -- Conta pra ver tem tem nota
           
           
          SELECT count(*),
                 tdvadm.fn_busca_codigoibge(c.con_conhecimento_localentrega,'IBD') ENTREGA
              into vContador,
                   vEntrega
          FROM tdvadm.T_CON_VFRETECONHEC VFC
               ,tdvadm.T_CON_VALEFRETE VF
               ,tdvadm.T_CON_CONHECIMENTO C
               ,tdvadm.T_CON_NFTRANSPORTA NF
               ,tdvadm.T_ARM_COLETA CO
               ,tdvadm.T_ARM_NOTA NT
               ,tdvadm.T_GLB_CLIENTE CS
               ,tdvadm.T_GLB_CLIENTE CD
          WHERE VFC.CON_VALEFRETE_CODIGO = SUBSTR(vValeFrete,1,6)
            AND VFC.GLB_ROTA_CODIGOVALEFRETE = SUBSTR(vValeFrete,7,3) -- AJUSTADO POR JONATAS VELOSO 13/11/2018
            AND VFC.CON_VALEFRETE_SAQUE = SUBSTR(vValeFrete,10,1)     -- AJUSTADO POR JONATAS VELOSO 13/11/2018
            AND cS.glb_grupoeconomico_codigo = vGrupo
            AND CD.GLB_GRUPOECONOMICO_CODIGO = vGrupo
            -- Sirlano 03/02/2020
            -- Criticar o CNP e Contrato
            AND C.GLB_CLIENTE_CGCCPFSACADO = vCnpj
            AND NT.SLF_CONTRATO_CODIGO = vContrato
            AND VFC.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
            AND VFC.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
            AND VFC.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO

            AND VFC.CON_VALEFRETE_CODIGO = VF.CON_CONHECIMENTO_CODIGO
            AND VFC.CON_VALEFRETE_SERIE = VF.CON_CONHECIMENTO_SERIE
            AND VFC.GLB_ROTA_CODIGOVALEFRETE = VF.GLB_ROTA_CODIGO
            AND VFC.CON_VALEFRETE_SAQUE = VF.CON_VALEFRETE_SAQUE

            AND C.CON_CONHECIMENTO_CODIGO = NF.CON_CONHECIMENTO_CODIGO
            AND C.CON_CONHECIMENTO_SERIE = NF.CON_CONHECIMENTO_SERIE
            AND C.GLB_ROTA_CODIGO = NF.GLB_ROTA_CODIGO

            AND C.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA (+)
            AND C.ARM_COLETA_CICLO = CO.ARM_COLETA_CICLO (+)

            AND C.ARM_COLETA_NCOMPRA = NT.ARM_COLETA_NCOMPRA (+)
            AND C.ARM_COLETA_CICLO = NT.ARM_COLETA_CICLO (+)

            AND C.GLB_CLIENTE_CGCCPFSACADO = CS.GLB_CLIENTE_CGCCPFCODIGO
            AND c.Glb_Cliente_Cgccpfdestinatario = CD.GLB_CLIENTE_CGCCPFCODIGO
            and ROWNUM = 1 
         group by tdvadm.fn_busca_codigoibge(c.con_conhecimento_localentrega,'IBD');
                              
           if vContador = 0 Then
             vMessage := '';
             pTpRecebido.Glb_Benasserec_Status := 'ER';
             Return;
           End If;  

           open vCursor FOR SELECT DISTINCT RT.GLB_ROTA_CODIGO || '-' || TRIM(RT.GLB_ROTA_DESCRICAO) ROTA,
                                            nvl(nt.xml_notalinha_numdoc,CO.ARM_COLETA_PEDIDO) PEDIDO,
                                            nf.glb_cfop_codigo CFOP,
                                            nf.con_nftransportada_numnfiscal NF,
                                            NF.GLB_CLIENTE_CGCCPFCODIGO CNPJFORNEC,
                                            CR.GLB_CLIENTE_RAZAOSOCIAL FORNECEDOR,
                                            NF.CON_NFTRANSPORTADA_DTEMISSAO DTEMISSAONF,
                                            NF.CON_NFTRANSPORTADA_VOLUMES QTDEVOLUMES,
                                            NF.CON_NFTRANSPORTADA_PESO PESO,
                                            CO.ARM_COLETA_DTSOLICITACAO DTACIONTRANSP,
                                            co.arm_coleta_dtprogramacao DTCHEGTRANSP,
                                            TRUNC(VF.CON_VALEFRETE_DATACADASTRO) DTSAIDATRANSP,
                                            VF.CON_VALEFRETE_PLACA PLACAVEICULO,
                                            VFC.CON_CONHECIMENTO_CODIGO CTRC,
                                            nf.con_nftransportada_valor VALOR,
                                            'TIPO' TIPOTRANSP,
                                            NF.CON_NFTRANSPORTADA_CHAVENFE CHAVE,
                                            VF.CON_VALEFRETE_DATAPRAZOMAX PREVISAO,
                                            AR.ARM_ARMAZEM_DESCRICAO TRANSFERENCIA
                                            
                            FROM tdvadm.T_CON_VFRETECONHEC VFC
                                 ,tdvadm.T_CON_VALEFRETE VF
                                 ,tdvadm.T_CON_CONHECIMENTO C
                                 ,tdvadm.T_CON_NFTRANSPORTA NF
                                 ,tdvadm.T_ARM_COLETA CO
                                 ,tdvadm.T_ARM_NOTA NT
                                 ,tdvadm.T_GLB_CLIENTE CS
                                 ,tdvadm.T_GLB_CLIENTE CD
                                 ,tdvadm.T_GLB_CLIENTE CR
                                 ,tdvadm.T_GLB_ROTA RT
                                 ,tdvadm.t_Arm_Armazem AR
                                 ,tdvadm.t_arm_notacte ncte
                            WHERE VFC.CON_VALEFRETE_CODIGO                = SUBSTR(vValeFrete,1,6)  --Rafael AITI 14/11/2018 (substr estava errado)
                              AND VFC.GLB_ROTA_CODIGOVALEFRETE            = SUBSTR(vValeFrete,7,3)  --Rafael AITI 14/11/2018 (substr estava errado)
                              AND VFC.CON_VALEFRETE_SAQUE                 = SUBSTR(vValeFrete,10,1) --Rafael AITI 14/11/2018 (substr estava errado)
                              AND cS.glb_grupoeconomico_codigo            = vGrupo
                              AND CD.GLB_GRUPOECONOMICO_CODIGO            = vGrupo
                              AND VFC.CON_CONHECIMENTO_CODIGO             = C.CON_CONHECIMENTO_CODIGO
                              AND VFC.CON_CONHECIMENTO_SERIE              = C.CON_CONHECIMENTO_SERIE
                              AND VFC.GLB_ROTA_CODIGO                     = C.GLB_ROTA_CODIGO

                              -- Sirlano 03/02/2020
                              -- Criticar o CNP e Contrato
                              
                              AND C.GLB_CLIENTE_CGCCPFSACADO = vCnpj
                              AND NT.SLF_CONTRATO_CODIGO = vContrato


                              -- Sirlano em 26/09/2018
                              -- Coloquei a notacte
                               
                              and VFC.con_conhecimento_codigo              = ncte.con_conhecimento_codigo (+)
                              and VFC.con_conhecimento_serie               = ncte.con_conhecimento_serie (+)
                              and VFC.glb_rota_codigo                      = ncte.glb_rota_codigo (+)
                              and ncte.arm_notacte_codigo (+) = 'NO'

                              -- fim da notacte
                              
                              AND VFC.CON_VALEFRETE_CODIGO                = VF.CON_CONHECIMENTO_CODIGO
                              AND VFC.CON_VALEFRETE_SERIE                 = VF.CON_CONHECIMENTO_SERIE
                              AND VFC.GLB_ROTA_CODIGOVALEFRETE            = VF.GLB_ROTA_CODIGO
                              AND VFC.CON_VALEFRETE_SAQUE                 = VF.CON_VALEFRETE_SAQUE
                              AND VFC.GLB_ROTA_CODIGOVALEFRETE            = RT.GLB_ROTA_CODIGO
                              AND VFC.ARM_ARMAZEM_CODIGO                  = AR.ARM_ARMAZEM_CODIGO (+)
                              AND C.CON_CONHECIMENTO_CODIGO               = NF.CON_CONHECIMENTO_CODIGO
                              AND C.CON_CONHECIMENTO_SERIE                = NF.CON_CONHECIMENTO_SERIE
                              AND C.GLB_ROTA_CODIGO                       = NF.GLB_ROTA_CODIGO
                             
                             -- Sirlano em 26-09/2018
                             -- mudamos para a nota
                              AND nt.ARM_COLETA_NCOMPRA                    = CO.ARM_COLETA_NCOMPRA (+)
                              AND nt.ARM_COLETA_CICLO                      = CO.ARM_COLETA_CICLO (+)
                              
                             -- Klayton em 13/09/2018, quando temos notas agrupadas o cte só tem um numero-  
                             -- de coleta com isso o select trazia informações incorretas. mudei a ligação da t_arm_nota pela a chave da nfe.
                             -- desabilitei as duas linhas abaixo
                             /*AND C.ARM_COLETA_NCOMPRA                    = NT.ARM_COLETA_NCOMPRA (+)
                               AND C.ARM_COLETA_CICLO                      = NT.ARM_COLETA_CICLO   (+)*/
                             -- habilitei essa linha
                              and nf.con_nftransportada_chavenfe = nt.arm_nota_chavenfe(+)
                              
                              AND C.GLB_CLIENTE_CGCCPFREMETENTE    = CR.GLB_CLIENTE_CGCCPFCODIGO
                              AND C.GLB_CLIENTE_CGCCPFSACADO       = CS.GLB_CLIENTE_CGCCPFCODIGO
                              AND c.Glb_Cliente_Cgccpfdestinatario = CD.GLB_CLIENTE_CGCCPFCODIGO
                             order by nf.con_nftransportada_numnfiscal;
           
           pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
           pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
           pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha1);
           for i in 1 .. vLinha1.count loop
              if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                 pMessage := pMessage || vLinha1(i);
              Else
                 pMessage := pMessage || vLinha1(i) || chr(10);
              End if;
           End loop; 
        Else
          pTpRecebido.Glb_Benasserec_Status := 'ER';
          pMessage := '';
          vEmail := 'sdrumond@dellavolpe.com.br';
        End If;
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
     Else
         pTpRecebido.Glb_Benasserec_Status := 'ER';
         If SUBSTR(vValeFrete,7,1) <> '9' Then
            pMessage := 'Não e o Primeiro Saque Valido ' || vValeFrete ;
         Else
            pMessage := 'Rotas 9?? não tem Romaneio ' || vValeFrete ;
         End If;
         vEmail := '';
     End If;

  EXCEPTION
    when others then
       pStatus := pkg_glb_common.Status_Erro;
       pMessage := 'Erro Rodando Confirmação de Comprovantes . ' || chr(10) || 
                   '********************************************************************************' || chr(10) ||
                   sqlerrm || chr(10) ||
                   '********************************************************************************' || chr(10) ||
                   DBMS_UTILITY.format_error_backtrace || chr(10) ||
                   '********************************************************************************' || chr(10);
       vEmail := 'sdrumond@dellavolpe.com.br';

  End;
  
      If ( vAchou > 0 ) and ( nvl(vEmail,'a') <> 'sdrumond@dellavolpe.com.br' ) Then
       vEmail := ''; 
       open c_email FOR vSql;
       loop
             fetch c_email into v_Email,v_EmailIndividual;
             exit when c_email%notfound;               
                 
         If v_EmailIndividual = 'N' Then
            vEmail := vEmail || v_Email || ';';     
         Else
            wservice.pkg_glb_email.SP_ENVIAEMAIL('ROMANEIO - ' || vValeFrete || ' PLACA - ' || vPlaca || ' EMISSAO - ' || TO_CHAR(vEmissao,'DD/MM/YYYY') || ' ENTREGA - ' || vEntrega ,
                                                 pMessage,
                                                'aut-e@dellavolpe.com.br',
                                                 v_Email,
                                                'romaneiolog@dellavolpe.com.br');
         End If;
               
       End Loop;
                

        if length(trim(nvl(vEmail,'a'))) <> 1 Then
           
           wservice.pkg_glb_email.SP_ENVIAEMAIL('ROMANEIO - ' || vValeFrete || ' PLACA - ' || vPlaca || ' EMISSAO - ' || TO_CHAR(vEmissao,'DD/MM/YYYY') || ' ENTREGA - ' || vEntrega ,
                                                pMessage,
                                                'aut-e@dellavolpe.com.br',
                                                vEmail,
                                                'romaneiolog@dellavolpe.com.br');
        End If;

    End If;

  
end SPI_ConfirmaNotasEmbarcadas;                                                                  





   --Exemplo de QryString = MSG=PRODEB;PROP=06045040805;PLACA=CFS0030;DTINICIO=01/11/2014;DTFIM=30/11/2014;
   procedure spi_get_ProrrogarDebito( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                      pStatus out char,
                                      pMessage out varchar2
                                     ) is
     vCpfProp  tdvadm.t_car_contacorrente.car_proprietario_cgccpfcodigo%type;
     vNomeProp tdvadm.t_car_proprietario.car_proprietario_razaosocial%type;
     vPlaca    varchar2(20);
     vInicio   date;
     vFim      date;
     vCursor T_CURSOR;
     vLinha1       pkg_glb_SqlCursor.tpString1024;
     vLinha2       pkg_glb_SqlCursor.tpString1024;
     
     --Variáveis auxiliares
     vMessage   clob;
   Begin
     --seto o status para erro, e o processamento para hoje
     pTpRecebido.Glb_Benasserec_Processado := sysdate;
     pTpRecebido.Glb_Benasserec_Status := 'OK';
     pStatus := pkg_glb_common.Status_Nomal;
     
     Begin
       --Exemplo de QryString = MSG=PRODEB;PROP=06045040805;PLACA=CFS0030;DTINICIO=01/11/2014;DTFIM=30/11/2014;
       
       --recupero o numero do equipamento caso seja uma consulta especifica

       vMessage := empty_clob;
       vCpfProp := trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'PROP', '=', ';')); 
       vPlaca   := trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'PLACA', '=', ';'));
       vInicio  := to_date(trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'DTINICIO', '=', ';')),'dd/mm/yyyy');
       vFim     := to_date(trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto, 'DTFIM', '=', ';')),'dd/mm/yyyy');
        
       Begin
          select p.car_proprietario_razaosocial
            into vNomeProp
          from tdvadm.t_car_proprietario p
          where p.car_proprietario_cgccpfcodigo = vCpfProp;
       Exception
       When NO_DATA_FOUND Then
            vNomeProp := '';
            pTpRecebido.Glb_Benasserec_Status := 'ER';
            vMessage := vMessage || 'CNPJ ' || vCpfProp || ' NAO ENCONTADO' || chr(10);
            if  vPlaca <> '' Then
               Begin
                  select p.car_proprietario_razaosocial
                      into vNomeProp
                  from tdvadm.t_car_veiculo v,
                       tdvadm.t_car_proprietario p
                  where v.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo
                    and v.car_veiculo_placa = vPlaca
                    and v.car_veiculo_saque = (select max(v1.car_veiculo_saque)
                                               from tdvadm.t_car_veiculo v1
                                               where v1.car_veiculo_placa = v.car_veiculo_placa);
                  pTpRecebido.Glb_Benasserec_Status := 'OK';                             
               exception
                 When NO_DATA_FOUND Then
                     pTpRecebido.Glb_Benasserec_Status := 'ER';
                     vMessage := vMessage || 'PLACA  ' || vPlaca || ' NAO ENCONTADO' || chr(10);
               End;
            End IF;
         End;         


       If pTpRecebido.Glb_Benasserec_Status = 'OK' then

        vMessage := pkg_glb_html.Assinatura;
        vMessage := vMessage || pkg_glb_html.fn_Titulo('DEBITOS PRORROGADOS DE ' || vInicio || ' ATÉ ' || vFim);
        vMessage := vMessage || pkg_glb_html.fn_AbreLista;
        vMessage := vMessage || pkg_glb_html.fn_ItensLista(vCpfProp,null,vNomeProp);
        vMessage := vMessage || pkg_glb_html.fn_FechaLista;
       open vCursor for select min(trunc(cc.dtData)) data, 
                               cc.documento,
                               cc.tpdeb,
                               cc.operacao,
                               sum(cc.car_contacorrente_valor * decode(cc.car_contacorrente_tplancamento,'D',1,-1)) Saldo
                        from tdvadm.v_car_contacorrente cc
                        where 0 = 0
                          and cc.cpncnpjprop = vCpfProp
                          and 0 <> (select sum(cc1.car_contacorrente_valor * decode(cc1.car_contacorrente_tplancamento,'D',1,-1))
                                   from tdvadm.v_car_contacorrente cc1
                                   where 0 = 0
                                     and cc1.documento = cc.documento
                                     and cc1.tpdeb = cc.tpdeb
                                     and cc1.operacao = cc.operacao)
                        group by cc.documento,cc.tpdeb,cc.operacao
                        union
                        select trunc(sysdate) data,
                               'TOTAL' documento,
                               null tpdeb,
                               null operacao,
                               sum(cc.car_contacorrente_valor * decode(cc.car_contacorrente_tplancamento,'D',1,-1)) Saldo
                        from tdvadm.v_car_contacorrente cc
                        where 0 = 0
                          and cc.cpncnpjprop = vCpfProp
                        order by 1;
       
       pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
--       pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
       pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha2);
       for i in 1 .. vLinha2.count loop
          if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
             vMessage := vMessage || vLinha2(i);
          Else
             vMessage := vMessage || vLinha2(i) || chr(10);
          End if;
       End loop; 

       
       pTpRecebido.Glb_Benasserec_Status := 'LB';
       --envio o e-mail com os dados recuperados.
       wservice.pkg_glb_email.SP_ENVIAEMAIL('PRORROGACAO DE DEBITO',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem,
                                             'sdrumond@dellavolpe.com.br;gvolpe@dellavolpe.com.br;cfaria@dellavolpe.com.br;bbernardo@dellavolpe.com.br;gmachado@dellavolpe.com.br'
                                             );
      --seto os paramentros de saida.
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'LB';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := '';
     end If;  
     Exception
       --caso ocorra algum erro durante a execução da função, manda um e-mail pro Analista Rogerio
       when others then
         pStatus := pkg_glb_common.Status_Erro;
         pMessage := 'Errona Rotina de Prorrogação de Debito ' || chr(10) || 
                     '********************************************************************************' || chr(10) ||
                     sqlerrm || chr(10) ||
                     '********************************************************************************' || chr(10);
         wservice.pkg_glb_email.SP_ENVIAEMAIL('PRORROGACAO DE DEBITO',
                                               pMessage,
                                               'aut-e@dellavolpe.com.br',
                                               pTpRecebido.glb_benasserec_origem);
      pTpRecebido.Glb_Benasserec_Processado := Sysdate;
      pTpRecebido.Glb_Benasserec_Status     := 'ER';
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := '';

     End;
     
     
     
   end spi_get_ProrrogarDebito;                                                                  



-- MSG=PROCESSASAP;ACAO=CRIA;PROTOCOLO=54139;LIMITE=31/01/2015
procedure spi_CriaFaturaConciliada( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                   pStatus out char,
                                   pMessage out clob)
Is
  vNumeroFat   number;
  vCnpjPagante tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  tpFatura     tdvadm.t_con_fatura%rowtype;
  vProtocolo   tdvadm.t_edi_conciliacaosap.protocolo%type;
  vDtBaixa     date;
  vDtLimite    date;
  vContador    number;
  vTpRecebido  rmadm.t_glb_benasserec%rowtype;
  
Begin

   vTpRecebido := pTpRecebido;
   if vTpRecebido.Glb_Benasserec_Assunto is null Then
      vTpRecebido.Glb_Benasserec_Assunto := 'MSG=PROCESSASAP;ACAO=CRIA;PROTOCOLO=54187;LIMITE=31/01/2015'; 
      vTpRecebido.Glb_Benasserec_Origem := 'sdrumond@dellavolpe.com.br';
   End If;  
   vProtocolo := trim(tdvadm.fn_querystring(vTpRecebido.Glb_Benasserec_Assunto, 'PROTOCOLO', '=', ';'));
   vDtLimite  := trim(tdvadm.fn_querystring(vTpRecebido.Glb_Benasserec_Assunto, 'LIMITE', '=', ';')); 
   vContador := 0;
   vDtBaixa  := null;
   pStatus := pkg_glb_common.Status_Nomal;
   pMessage := empty_clob;
--  52612


-- Verifica se ja foi alguem faturando antes do processamento

   pMessage := 'Conhecimento Faturados Antes do Processamento' || chr(10);

   FOR C_BCDOC IN (SELECT DISTINCT 
                          i.PROTOCOLO,
                          i.TpDoc,
                          i.banco,
                          i.doccomptdv,
                          i.DATAPGTOREAL,
                          I.CTE   
                   FROM tdvadm.t_edi_conciliacaosap I
                   WHERE 0 = 0
                     AND I.PROTOCOLO       = vProtocolo
                     AND i.flagprocessa = 'S'
                     AND NVL(i.TpDoc,'ZP') <> 'ZP'
                     AND I.BANCO           <> '999'
                     AND TRIM(I.fatura)    = '-'
                     AND I.CTE IS NOT NULL
                   ORDER BY I.BANCO,
                            I.DOCCOMPTDV)

   LOOP
     Begin
      select f.*
        into tpFatura
      from tdvadm.t_con_fatura f,
           tdvadm.t_con_conhecimento c
      where 0 = 0
        and f.con_fatura_codigo        = c.con_fatura_codigo
        and f.con_fatura_ciclo         = c.con_fatura_ciclo
        and f.glb_rota_codigofilialimp = c.glb_rota_codigofilialimp
        and c.con_conhecimento_codigo = substr(C_BCDOC.CTE,5,6)
        and c.glb_rota_codigo = substr(C_BCDOC.CTE,1,3);
        pMessage := pMessage || 'Verifique o Cte - ' || C_BCDOC.CTE || ' Foi Faturado Fat:' || tpFatura.Con_Fatura_Codigo ||'-'||tpFatura.Glb_Rota_Codigofilialimp || ' por: ' || tpFatura.Usu_Usuario_Codigo || ' Em : ' || to_char(tpFatura.Con_Fatura_Dataemissao,'dd/mm/yyyy')   || chr(10); 
        pStatus := pkg_glb_common.Status_Erro;
    exception
       When NO_DATA_FOUND Then
          pMessage := pMessage;
       When TOO_MANY_ROWS Then
         pMessage := pMessage || 'Verifique o Cte - ' || C_BCDOC.CTE || ' Retornou mais de uma Fatura' || chr(10); 
     End;
   End Loop;


   if pStatus = pkg_glb_common.Status_Nomal Then
       
       pMessage := '';
     
       FOR C_BCDOC IN (SELECT DISTINCT 
                              i.PROTOCOLO,
                              i.TpDoc,
                              i.banco,
                              i.doccomptdv,
                              i.DATAPGTOREAL     
                       FROM tdvadm.t_edi_conciliacaosap I
                       WHERE 0 = 0
                         AND I.PROTOCOLO       = vProtocolo
                         AND i.flagprocessa = 'S'
                         AND NVL(i.TpDoc,'ZP') <> 'ZP'
                         AND I.BANCO           <> '999'
                         AND TRIM(I.fatura)    = '-'
                         AND I.CTE IS NOT NULL
                       ORDER BY I.BANCO,
                                I.DOCCOMPTDV)

       LOOP
          
          vCnpjPagante := '99999999999999999999';
          select max(to_number(f.con_fatura_codigo))
            into vNumeroFat
          from tdvadm.t_con_fatura f
          where f.glb_rota_codigofilialimp = '013';
          vNumeroFat := NVL(vNumeroFat,0);
          FOR C_FATURA IN (SELECT *
                           FROM tdvadm.t_edi_conciliacaosap I
                           WHERE 0 = 0
                             AND i.flagprocessa = 'S'
                             AND I.CTE IS NOT NULL
                             AND TRIM(I.fatura)    = '-'
                             AND I.PROTOCOLO       = C_BCDOC.PROTOCOLO
                             AND NVL(i.TpDoc,'ZP') <> 'ZP'
                             AND I.BANCO           = C_BCDOC.BANCO
                             AND I.DOCCOMPTDV      = C_BCDOC.DOCCOMPTDV)
          LOOP
            If ( vCnpjPagante <> '99999999999999999999' ) and ( vCnpjPagante <> C_FATURA.Sacado ) Then
               update t_con_fatura f
                 set f.con_fatura_valorcobrado = tpFatura.Con_Fatura_Valorcobrado,
                     f.con_fatura_status = 'I'
               where f.con_fatura_codigo        = tpFatura.Con_Fatura_Codigo
                 and f.con_fatura_ciclo         = tpFatura.Con_Fatura_Ciclo
                 and f.glb_rota_codigofilialimp = tpFatura.Glb_Rota_Codigofilialimp ; 
                 commit;
                 vContador := vContador + 1;
            End If;
            
            If vCnpjPagante <> C_FATURA.Sacado Then
               if to_char(c_bcdoc.DATAPGTOREAL,'yyyymm') = to_char(vDtLimite,'yyyymm') Then
                  vDtBaixa := c_bcdoc.DATAPGTOREAL;
               Else
                  vDtBaixa := vDtLimite;
               End If;  
               vNumeroFat := vNumeroFat + 1;
               vCnpjPagante := C_FATURA.Sacado;
               tpFatura.Con_Fatura_Codigo          := lpad(vNumeroFat,6,'0');
               tpFatura.Glb_Rota_Codigofilialimp   := '013';
               tpFatura.Con_Fatura_Ciclo           := pkg_con_fatura.fn_get_Ciclo(tpFatura.Glb_Rota_Codigofilialimp);
               tpFatura.Glb_Cliente_Cgccpfsacado   := C_FATURA.Sacado; 
               tpFatura.Con_Fatura_Serie           := 'A1';
               tpFatura.Con_Fatura_Datavenc        := vDtBaixa;
               tpFatura.Con_Fatura_Datapagto       := vDtBaixa; --c_bcdoc.datapgto;
               tpFatura.Con_Fatura_Dataemissao     := vDtBaixa; --Sysdate;     
               tpFatura.Con_Fatura_Datacanc        := null;   
               tpFatura.Con_Fatura_Valorcobrado    := 0;    
               tpFatura.Con_Fatura_Valorrecebido   := 0;
               tpFatura.Con_Fatura_Status          := null;
               tpFatura.Glb_Rota_Codigo            := '013';
               tpFatura.Glb_Condpag_Codigo         := '0001';
               tpFatura.Con_Fatura_Emissor         := 'sistema';
               tpFatura.Con_Fatura_Venccalc        := null;
               tpFatura.Con_Fatura_Criador         := 'sistema';
               tpFatura.Con_Fatura_Autorizador     := null;
               tpFatura.Con_Fatura_Desconto        := null;
               tpFatura.Con_Fatura_Dtlimtdesc      := null;
               tpFatura.Glb_Formaenvio_Codigo      := null;
               tpFatura.Con_Fatura_Dtenviodoc      := null;
               tpFatura.Con_Fatura_Tpdesconto      := null;
               tpFatura.Con_Fatura_Obsdesconto     := null;
               tpFatura.Con_Fatura_Obscancelamento := null;
               tpFatura.Con_Fatura_Reversao        := 'N';
               tpFatura.Con_Fatura_Descimposto     := null;
               tpFatura.Usu_Usuario_Codigo         := 'sistema';
               tpFatura.Con_Fatura_Obs             := 'Criacao automatica PROTOCOLO [' || vProtocolo || '] EDI-Vale BANCO-COMP ' || C_BCDOC.banco ||'-' || trim(C_BCDOC.doccomptdv) ||  ' DTPGTO '  || to_char(C_BCDOC.DATAPGTOREAL,'dd/mm/yyyy');
               tpFatura.Con_Fatura_Cabecalhofat    := null;
               insert into t_con_fatura
               values tpFatura;
            End If;
            
            tpFatura.Con_Fatura_Valorcobrado := tpFatura.Con_Fatura_Valorcobrado + C_FATURA.VALORTDV;
            UPDATE TDVADM.T_CON_CONHECIMENTO C
              SET C.CON_FATURA_CODIGO        = tpFatura.Con_Fatura_Codigo,
                  C.CON_FATURA_CICLO         = tpFatura.Con_Fatura_Ciclo,
                  C.GLB_ROTA_CODIGOFILIALIMP = tpFatura.Glb_Rota_Codigofilialimp
            WHERE C.CON_CONHECIMENTO_CODIGO = SUBSTR(C_FATURA.CTE,5,6)      
              AND C.GLB_ROTA_CODIGO         = SUBSTR(C_FATURA.CTE,1,3)
              AND C.CON_CONHECIMENTO_SERIE <> 'XXX';

            update t_edi_conciliacaosap cs
              set cs.fatura = tpFatura.Glb_Rota_Codigofilialimp ||'-'|| tpFatura.Con_Fatura_Codigo
            where cs.protocolo = C_FATURA.PROTOCOLO
              and cs.sequencia = C_FATURA.SEQUENCIA; 

          END LOOP;
          If vCnpjPagante <> '99999999999999999999' Then
             update t_con_fatura f
                 set f.con_fatura_valorcobrado = tpFatura.Con_Fatura_Valorcobrado,
                     f.con_fatura_status = 'I'
             where f.con_fatura_codigo        = tpFatura.Con_Fatura_Codigo
               and f.con_fatura_ciclo         = tpFatura.Con_Fatura_Ciclo
                 and f.glb_rota_codigofilialimp = tpFatura.Glb_Rota_Codigofilialimp ; 
                 commit;
                 vContador := vContador + 1;
          End IF;

       End Loop;  

       wservice.pkg_glb_email.SP_ENVIAEMAIL('PROCESSAMENTO CRIAÇÃO DE FATURA/TITULOS',
                                            ' Total de Faturas/Titulos Criadas ' || to_char(vContador),
                                            'aut-e@dellavolpe.com.br',
                                            trim(vTpRecebido.Glb_Benasserec_Origem));
  Else
       wservice.pkg_glb_email.SP_ENVIAEMAIL('PROBLEMAS NA CRIAÇÃO DE FATURA/TITULOS',
                                            pMessage,
                                            'aut-e@dellavolpe.com.br',
                                            trim(vTpRecebido.Glb_Benasserec_Origem));
    
  End If; 
     
End spi_CriaFaturaConciliada;                                  

-- MSG=PROCESSASAP;ACAO=BAIXA;PROTOCOLO=764535;LIMITE=31/01/2015
procedure spi_BaixaTitulosConciliada( pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                     pStatus out char,
                                     pMessage out varchar2)
Is
  vProtocolo   tdvadm.t_edi_conciliacaosap.protocolo%type;
  vAuxiliar   number;
  vCnpjPagante tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  tpFatura     tdvadm.t_con_fatura%rowtype;
  tpTitEvento  tdvadm.t_crp_titrecevento%rowtype;
  
  vFatura      tdvadm.t_con_fatura.con_fatura_codigo%type;
  vRotaFat     tdvadm.t_con_fatura.glb_rota_codigofilialimp%type;
  vErro        clob;
  vSaldo       number;
  vDtBaixa     date;
  vDtLimite    date;
  vContador    number;
  vTpRecebido  rmadm.t_glb_benasserec%rowtype;
  vSaqueTitulo tdvadm.t_crp_titreceber.crp_titreceber_saque%type;
Begin
   vTpRecebido := pTpRecebido;
   if vTpRecebido.Glb_Benasserec_Assunto is null Then
      vTpRecebido.Glb_Benasserec_Assunto := 'MSG=PROCESSASAP;ACAO=CRIA;PROTOCOLO=54187;LIMITE=31/01/2015'; 
      vTpRecebido.Glb_Benasserec_Origem := 'sdrumond@dellavolpe.com.br';
   End If;  

   vProtocolo := trim(tdvadm.fn_querystring(vTpRecebido.Glb_Benasserec_Assunto, 'PROTOCOLO', '=', ';'));
   vDtLimite  := trim(tdvadm.fn_querystring(vTpRecebido.Glb_Benasserec_Assunto, 'LIMITE', '=', ';')); 
   vDtBaixa  := null;
   if vDtLimite > sysdate Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Data Limite Maior que hoje.';
      return;
   End If;
   vAuxiliar := 0;
   vErro  := empty_clob;
   vContador := 0;
   FOR C_TITULOS IN (SELECT DISTINCT 
                            i.PROTOCOLO,
                            i.sequencia,
                            i.TpDoc,
                            I.SACADO,
                            I.FATURA,
                            I.datafatura, 
                            I.cte,
                            i.banco,
                            i.doccomptdv,
                            i.DATAPGTOREAL,
                            I.valortdv,
                            I.montantemoeda ,
                            I.valorpago,
                            i.valorpagon,
                            i.valorplan,
                            I.DESCONTO,
                            I.ACRESCIMO
                   FROM tdvadm.t_edi_conciliacaosap I
                   WHERE 0 = 0
                     AND I.PROTOCOLO       = vProtocolo
                     AND i.flagprocessa = 'S'
                     AND NVL(i.TpDoc,'ZP') <> 'ZP'
                     AND I.pago = 'N'
                     and nvl(i.datafatura,to_date(vDtLimite,'dd/mm/yyyy')) <= to_date(vDtLimite,'dd/mm/yyyy') 
                     AND I.DATABAIXA IS NULL 
                     AND I.BANCO           not in ('999','998','997','996')
                     AND TRIM(I.fatura)    <> '-'
                     AND I.CTE IS NOT NULL
                   ORDER BY I.FATURA,
                            I.BANCO,
                            I.DOCCOMPTDV)
   LOOP
     
      begin
          vFatura  :=  lpad(trim(substr(C_TITULOS.fatura,5,6)),6,'0');
          vRotaFat :=  substr(C_TITULOS.fatura,1,3);
          select substr(f.con_fatura_obs,1,100)
            into tpTitEvento.Crp_Titrecevento_Obs
          from tdvadm.t_con_fatura f
          where f.con_fatura_codigo        = vFatura
            and f.con_fatura_ciclo         = pkg_con_fatura.fn_get_Ciclo(vRotaFat)
            and f.glb_rota_codigofilialimp = vRotaFat;

          
          tpTitEvento.Crp_Titrecevento_Obs := substr('Baixado protocolo ['||vProtocolo||'] ' || trim(tpTitEvento.Crp_Titrecevento_Obs),1,100);
           
          tpTitEvento.Glb_Rota_Codigo              :=  substr(C_TITULOS.fatura,1,3);
          tpTitEvento.Crp_Titreceber_Numtitulo     :=  substr(C_TITULOS.fatura,5,6);
          tpTitEvento.Crp_Titreceber_Saque         :=  pkg_crp_titreceber.fn_get_saque(tpTitEvento.Glb_Rota_Codigo);


          tpTitEvento.Glb_Banco_Numero             := C_TITULOs.banco;
          
          select c.glb_agencia_numero,
                 c.glb_contas_numero
            into tpTitEvento.Glb_Agencia_Numero,
                 tpTitEvento.Glb_Contas_Numero 
          from tdvadm.t_glb_contas c
          where c.glb_banco_numero = tpTitEvento.Glb_Banco_Numero
            and c.glb_contas_defalt = 'S'
            and rownum = 1;
          
          tpTitEvento.Glb_Tpdoc_Codigo             := 'DEP';
          tpTitEvento.Crp_Titrecevento_Nrodoc      := trim(c_titulos.doccomptdv);
          tpTitEvento.Crp_Titrecevento_Autorizador := 'sistema';

           if to_char(C_TITULOs.DATAPGTOREAL,'yyyymm') = to_char(vDtLimite,'yyyymm') Then
              vDtBaixa := C_TITULOs.DATAPGTOREAL;
           Else
              vDtBaixa := vDtLimite;
           End If;  

          tpTitEvento.Crp_Titrecevento_Data        := vDtBaixa;

          tpTitEvento.Crp_Titrecevento_Datactb     := null;
          tpTitEvento.Usu_Usuario_Codigo           := 'sistema';
          tpTitEvento.Crp_Titrecevento_Datagrv     := sysdate;
          tpTitEvento.Crp_Titrecevento_Ccusto      := null;
          tpTitEvento.Crp_Titrecevento_Cresp       := null;
          tpTitEvento.Crp_Titreceber_Autorizador   := null;
          tpTitEvento.Crp_Titrecevento_Datacanc    := null;
          tpTitEvento.Usu_Usuario_Codigocanc       := null;
          tpTitEvento.Crp_Titrecevento_Obscanc     := null;
          tpTitEvento.Glb_Finalidade_Codigo        := null;
          tpTitEvento.Crp_Titrecevento_Refrctb     := null;
          tpTitEvento.Crp_Titrecevento_Dtconc      := sysdate;

          select max(nvl(ev.crp_titrecevento_seq,0)) + 1
            into tpTitEvento.Crp_Titrecevento_Seq
          from tdvadm.t_crp_titrecevento ev
          where ev.glb_rota_codigo          = tpTitEvento.Glb_Rota_Codigo
            and ev.crp_titreceber_numtitulo = tpTitEvento.Crp_Titreceber_Numtitulo 
            and ev.crp_titreceber_saque     = tpTitEvento.Crp_Titreceber_Saque;

          tpTitEvento.Crp_Titrecevento_Seq := nvl(tpTitEvento.Crp_Titrecevento_Seq,1);

              -- Evento para pAGAMENTO
              if substr(c_titulos.sacado,1,8) = '27063874' Then
                 tpTitEvento.Glb_Evento_Codigo := '0250';
              ElsIf substr(c_titulos.sacado,1,8) = '33931494' Then
                 tpTitEvento.Glb_Evento_Codigo := '0251';
              ElsIf substr(c_titulos.sacado,1,8) = '33592510' Then
                 tpTitEvento.Glb_Evento_Codigo := '0252';
              ElsIf substr(c_titulos.sacado,1,8) = '15144306' Then
                 tpTitEvento.Glb_Evento_Codigo := '0253';
              ElsIf substr(c_titulos.sacado,1,8) = '03327988' Then
                 tpTitEvento.Glb_Evento_Codigo := '0254';
              ElsIf substr(c_titulos.sacado,1,8) = '33931478' Then
                 tpTitEvento.Glb_Evento_Codigo := '0255';
              ElsIf substr(c_titulos.sacado,1,8) = '13531124' Then
                 tpTitEvento.Glb_Evento_Codigo := '0256';
              ElsIf substr(c_titulos.sacado,1,8) = '72372998' Then
                 tpTitEvento.Glb_Evento_Codigo := '0257';
              ElsIf substr(c_titulos.sacado,1,8) = '27240092' Then
                 tpTitEvento.Glb_Evento_Codigo := '0258';
              ElsIf substr(c_titulos.sacado,1,8) = '27251842' Then
                 tpTitEvento.Glb_Evento_Codigo := '0259';
              End If;   
              
              tpTitEvento.Glb_Evento_Codigo := '0001';

--          if C_TITULOs.DATAPGTOREAL <= '31/12/2014' Then
             tpTitEvento.Crp_Titrecevento_Dtevento       := vDtBaixa;
--          Else
--             tpTitEvento.Crp_Titrecevento_Dtevento       := C_TITULOs.DATAPGTOREAL;
--          End If;
          
          if nvl(c_titulos.valorpagoN,0) <> 0 Then
             tpTitEvento.Crp_Titrecevento_Valor       := abs(c_titulos.valorpagoN);
          Else   
             tpTitEvento.Crp_Titrecevento_Valor       := abs(c_titulos.valortdv) - abs(c_titulos.desconto) + abs(c_titulos.acrescimo);
          End If;   
--          Else
--             tpTitEvento.Crp_Titrecevento_Valor       := abs(c_titulos.valorplan);
--          End If;
          
          tpTitEvento.Crp_Titreceber_Rateio        := 'C';
          tpTitEvento.Crp_Titrecevento_Docrateio   := substr(C_TITULOS.Cte,5,6) || 'A1' || substr(C_TITULOS.Cte,1,3);

          insert into t_crp_titrecevento
          values tpTitEvento;

        BEGIN
          SELECT NVL(T.CRP_TITRECEBER_VLRCOBRADO, 0) +
                 NVL(T.CRP_TITRECEBER_VLRACRES, 0) +
                 NVL(T.CRP_TITRECEBER_DESPJUROS, 0) +
                 NVL(T.CRP_TITRECEBER_DESPCARTORIO, 0) +
                 NVL(T.CRP_TITRECEBER_DESPOUTROS, 0) -
                 NVL(T.CRP_TITRECEBER_DESCONTO, 0) -
                 NVL(T.CRP_TITRECEBER_VLRPGBANCO, 0)
            INTO vSALDO
            FROM tdvadm.T_CRP_TITRECEBER T
           WHERE T.CRP_TITRECEBER_NUMTITULO = tpTitEvento.Crp_Titreceber_Numtitulo
             AND T.CRP_TITRECEBER_SAQUE = tpTitEvento.Crp_Titreceber_Saque
             AND T.GLB_ROTA_CODIGO = tpTitEvento.Glb_Rota_Codigo;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            vSALDO := 0;
        END;


          SP_CRP_RATEIAEVENTO(tpTitEvento.Crp_Titreceber_Numtitulo,
                              tpTitEvento.Crp_Titreceber_Saque,
                              tpTitEvento.Glb_Rota_Codigo,
                              tpTitEvento.Crp_Titrecevento_Seq,
                              vSALDO,
                              tpTitEvento.Crp_Titreceber_Rateio,
                              tpTitEvento.Crp_Titrecevento_Docrateio);


          if nvl(c_titulos.desconto,0) <> 0 Then
          
              select max(nvl(ev.crp_titrecevento_seq,0)) + 1
                into tpTitEvento.Crp_Titrecevento_Seq
              from tdvadm.t_crp_titrecevento ev
              where ev.glb_rota_codigo          = tpTitEvento.Glb_Rota_Codigo
                and ev.crp_titreceber_numtitulo = tpTitEvento.Crp_Titreceber_Numtitulo 
                and ev.crp_titreceber_saque     = tpTitEvento.Crp_Titreceber_Saque;

              tpTitEvento.Crp_Titrecevento_Seq := nvl(tpTitEvento.Crp_Titrecevento_Seq,1);

              tpTitEvento.Crp_Titrecevento_Valor       := abs(c_titulos.desconto);

              tpTitEvento.Glb_Evento_Codigo            := '0004'; -- DESCONTO

              insert into t_crp_titrecevento
              values tpTitEvento;
        BEGIN
          SELECT NVL(T.CRP_TITRECEBER_VLRCOBRADO, 0) +
                 NVL(T.CRP_TITRECEBER_VLRACRES, 0) +
                 NVL(T.CRP_TITRECEBER_DESPJUROS, 0) +
                 NVL(T.CRP_TITRECEBER_DESPCARTORIO, 0) +
                 NVL(T.CRP_TITRECEBER_DESPOUTROS, 0) -
                 NVL(T.CRP_TITRECEBER_DESCONTO, 0) -
                 NVL(T.CRP_TITRECEBER_VLRPGBANCO, 0)
            INTO vSALDO
            FROM tdvadm.T_CRP_TITRECEBER T
           WHERE T.CRP_TITRECEBER_NUMTITULO = tpTitEvento.Crp_Titreceber_Numtitulo
             AND T.CRP_TITRECEBER_SAQUE = tpTitEvento.Crp_Titreceber_Saque
             AND T.GLB_ROTA_CODIGO = tpTitEvento.Glb_Rota_Codigo;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            vSALDO := 0;
        END;


          SP_CRP_RATEIAEVENTO(tpTitEvento.Crp_Titreceber_Numtitulo,
                              tpTitEvento.Crp_Titreceber_Saque,
                              tpTitEvento.Glb_Rota_Codigo,
                              tpTitEvento.Crp_Titrecevento_Seq,
                              vSALDO,
                              tpTitEvento.Crp_Titreceber_Rateio,
                              tpTitEvento.Crp_Titrecevento_Docrateio);

          
          End If;

          if nvl(c_titulos.acrescimo,0) <> 0 Then
          
              select max(nvl(ev.crp_titrecevento_seq,0)) + 1
                into tpTitEvento.Crp_Titrecevento_Seq
              from tdvadm.t_crp_titrecevento ev
              where ev.glb_rota_codigo          = tpTitEvento.Glb_Rota_Codigo
                and ev.crp_titreceber_numtitulo = tpTitEvento.Crp_Titreceber_Numtitulo 
                and ev.crp_titreceber_saque     = tpTitEvento.Crp_Titreceber_Saque;

              tpTitEvento.Crp_Titrecevento_Seq := nvl(tpTitEvento.Crp_Titrecevento_Seq,1);

              tpTitEvento.Crp_Titrecevento_Valor       := abs(c_titulos.acrescimo);

              -- Evento para Acrescimo
              tpTitEvento.Glb_Evento_Codigo            := '0005'; -- Acrescimo

              insert into t_crp_titrecevento
              values tpTitEvento;
        BEGIN
          SELECT NVL(T.CRP_TITRECEBER_VLRCOBRADO, 0) +
                 NVL(T.CRP_TITRECEBER_VLRACRES, 0) +
                 NVL(T.CRP_TITRECEBER_DESPJUROS, 0) +
                 NVL(T.CRP_TITRECEBER_DESPCARTORIO, 0) +
                 NVL(T.CRP_TITRECEBER_DESPOUTROS, 0) -
                 NVL(T.CRP_TITRECEBER_DESCONTO, 0) -
                 NVL(T.CRP_TITRECEBER_VLRPGBANCO, 0)
            INTO vSALDO
            FROM tdvadm.T_CRP_TITRECEBER T
           WHERE T.CRP_TITRECEBER_NUMTITULO = tpTitEvento.Crp_Titreceber_Numtitulo
             AND T.CRP_TITRECEBER_SAQUE = tpTitEvento.Crp_Titreceber_Saque
             AND T.GLB_ROTA_CODIGO = tpTitEvento.Glb_Rota_Codigo;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            vSALDO := 0;
        END;


          SP_CRP_RATEIAEVENTO(tpTitEvento.Crp_Titreceber_Numtitulo,
                              tpTitEvento.Crp_Titreceber_Saque,
                              tpTitEvento.Glb_Rota_Codigo,
                              tpTitEvento.Crp_Titrecevento_Seq,
                              vSALDO,
                              tpTitEvento.Crp_Titreceber_Rateio,
                              tpTitEvento.Crp_Titrecevento_Docrateio);


           End If;

          SELECT NVL(T.CRP_TITRECEBER_VLRCOBRADO, 0) +
                 NVL(T.CRP_TITRECEBER_VLRACRES, 0) +
                 NVL(T.CRP_TITRECEBER_DESPJUROS, 0) +
                 NVL(T.CRP_TITRECEBER_DESPCARTORIO, 0) +
                 NVL(T.CRP_TITRECEBER_DESPOUTROS, 0) -
                 NVL(T.CRP_TITRECEBER_DESCONTO, 0) -
                 NVL(T.CRP_TITRECEBER_VLRPGBANCO, 0)
            INTO vSALDO
            FROM tdvadm.T_CRP_TITRECEBER T
           WHERE T.CRP_TITRECEBER_NUMTITULO = tpTitEvento.Crp_Titreceber_Numtitulo
             AND T.CRP_TITRECEBER_SAQUE = tpTitEvento.Crp_Titreceber_Saque
             AND T.GLB_ROTA_CODIGO = tpTitEvento.Glb_Rota_Codigo;
            
           if vSALDO < 0 Then
              sp_crp_refazrateio(tpTitEvento.Crp_Titreceber_Numtitulo,tpTitEvento.Glb_Rota_Codigo,null);
           End If;           

             update t_edi_conciliacaosap c
               set c.pago = 'S',
                   c.datapgto = vDtBaixa,
                   c.databaixa = vDtBaixa,
                   c.flagprocessa = 'N',
                   c.obs = '#Baixa ' || trim(c.obs)
             where c.protocolo = c_titulos.protocolo
               and c.sequencia = c_titulos.sequencia; 

          vAuxiliar := vAuxiliar + 1;
--          if mod(vAuxiliar,100) = 0 Then
             commit;
--          End IF;
      exception
        When OTHERS Then
            -- colocar critica de erro
            vErro := sqlerrm;
            vAuxiliar := vAuxiliar;
        End ;
   End Loop;
   wservice.pkg_glb_email.SP_ENVIAEMAIL('PROCESSAMENTO BAIXA',
                                        ' Total de Titulos Baixados ' || to_char(vAuxiliar) || 'Protocolo: ' || vProtocolo || ' Data Limite: ' || vDtLimite, 
                                        'aut-e@dellavolpe.com.br',
                                        trim(vTpRecebido.Glb_Benasserec_Origem));
   
   commit;
End spi_BaixaTitulosConciliada;




procedure spi_ExecutaAutFat(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                            pStatus out char,
                            pMessage out varchar2)
Is
  vProtocolo  tdvadm.t_edi_conciliacaosap.protocolo%type;
  vContador   number;
--  vErro       clob;
  vTpRecebido  rmadm.t_glb_benasserec%rowtype;
  vXmlin      clob;
  vUsuario    tdvadm.t_usu_usuario.usu_usuario_codigo%type;
  vStatus     char(1);
  vMessage    clob;
  vCorpoEmail clob;
Begin
   vTpRecebido := pTpRecebido;
   if vTpRecebido.Glb_Benasserec_Assunto is null Then
      vTpRecebido.Glb_Benasserec_Assunto := 'MSG=AUTFAT;PROT=72295'; 
      vTpRecebido.Glb_Benasserec_Origem := 'tdv.cadastro@dellavolpe.com.br';
   End If;
   

   vProtocolo := trim(tdvadm.fn_querystring(vTpRecebido.Glb_Benasserec_Assunto, 'PROT', '=', ';'));

   vXmlin      := empty_clob;
   vMessage    := empty_clob;
   vCorpoEmail := empty_clob;  
   vContador := 0;
   -- Pegando quem solicitou
   
   Select rpad(trim(lower(I.EDI_INTEGRA_COL02)),10)
      into vUsuario
   From tdvadm.t_edi_integra I 
   Where I.EDI_INTEGRA_PROTOCOLO = vProtocolo
     and I.EDI_INTEGRA_COL01 = 'SOLICITANTE';

  
   
   vCorpoEmail := vCorpoEmail || pkg_glb_html.Assinatura;
   vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_Titulo('RESULTADO DO PROCESSAMENTO');
   
   FOR C_Cte IN (select lpad(trim(i.edi_integra_col02),6,'0') cte1,
                        upper(trim(i.edi_integra_col03)) sr1,
                        lpad(trim(i.edi_integra_col04),3,'0') rt1,
                        lpad(trim(i.edi_integra_col05),6,'0') cte2,
                        upper(trim(i.edi_integra_col06)) sr2, 
                        lpad(trim(i.edi_integra_col07),3,'0') rt2,
                        i.edi_integra_col08 rt3,
                        upper(trim(i.edi_integra_col09)) novafat,
                        i.edi_integra_col10 dtvencimento,
                        i.edi_integra_col11 desconto,
                        i.edi_integra_col12 acao,
                        to_char(i.edi_integra_processado,'dd/mm/yyyy') processado,
                        upper(trim(i.edi_integra_col13)) observacao,
                        I.EDI_INTEGRA_SEQUENCIA
                 from tdvadm.t_edi_integra i
                 Where I.EDI_INTEGRA_PROTOCOLO = vProtocolo
                   and i.edi_integra_col01 = 'DADOS'
                   and length(trim(i.edi_integra_col02)) > 1 )
   LOOP
      vXmlin := '';
      vXMLin := vXMLin || '<Parametros> ';
      vXMLin := vXMLin || '   <Inputs> ';
      vXMLin := vXMLin || '      <Input> ';
      vXMLin := vXMLin || '         <usuario>'     || vUsuario               || '</usuario>'; 
      vXMLin := vXMLin || '         <acao>'        || substr(C_Cte.Acao,1,2) || '</acao>';
      vXMLin := vXMLin || '         <cte1>'        || C_Cte.Cte1             || '</cte1>';
      vXMLin := vXMLin || '         <serie1>'      || C_Cte.Sr1              || '</serie1>';
      vXMLin := vXMLin || '         <rota1>'       || C_Cte.Rt1              || '</rota1>';
      vXMLin := vXMLin || '         <cte2>'        || C_Cte.Cte2             || '</cte2>';
      vXMLin := vXMLin || '         <serie2>'      || C_Cte.Sr2              || '</serie2>';
      vXMLin := vXMLin || '         <rota2>'       || C_Cte.Rt2              || '</rota2>';
      vXMLin := vXMLin || '         <vencimento>'  || C_Cte.Dtvencimento     || '</vencimento>';
      vXMLin := vXMLin || '         <dataemissao>' || C_Cte.Processado       || '</dataemissao>';
      vXMLin := vXMLin || '         <desconto>'    || C_Cte.Desconto         || '</desconto>';      
      vXMLin := vXMLin || '         <observacao>'  || C_Cte.Observacao       || '</observacao>';
      vXMLin := vXMLin || '      </Input> ';
      vXMLin := vXMLin || '   </Inputs> ';
      vXMLin := vXMLin || '</Parametros> ';

      pkg_crp_titreceber.sp_crp_AvaliaTroca(vXmlin,vStatus,vMessage);
      
      vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_AbreLista;
      vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_ItensLista('Acao ' ||  C_Cte.Acao);
      vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_AbreLista;
      vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_ItensLista(C_Cte.Cte1 || '-' || C_Cte.Sr1 || '-' || C_Cte.Rt1   );
      if vStatus = 'N' Then
         vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_ItensLista(vMessage);
      else
         vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_ItensLista(nvl(vMessage,'Finalizado com erro'));  
      end if;
      vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_FechaLista;
      vCorpoEmail := vCorpoEmail || pkg_glb_html.fn_FechaLista;
    
      if nvl(vStatus,'E') = 'N' Then -- Se N 
         update t_edi_integra i
           set I.edi_integra_critica = 'FF-Finalizado com Sucesso'
         Where I.EDI_INTEGRA_PROTOCOLO = vProtocolo
           and I.edi_integra_sequencia = C_Cte.Edi_Integra_Sequencia;
      ElsIf nvl(vStatus,'E') = 'W' Then -- Se N 
         update t_edi_integra i
           set I.edi_integra_critica = 'FF-Finalizado com Advertencia'
         Where I.EDI_INTEGRA_PROTOCOLO = vProtocolo
           and I.edi_integra_sequencia = C_Cte.Edi_Integra_Sequencia;
      Else
         update t_edi_integra i
           set I.edi_integra_critica = 'FE-Finalizado com erro-' || TRIM(vMessage)
         Where I.EDI_INTEGRA_PROTOCOLO = vProtocolo
           and I.edi_integra_sequencia = C_Cte.Edi_Integra_Sequencia;
      End If;
      
   End Loop;

   
   wservice.pkg_glb_email.SP_ENVIAEMAIL('PROCESSAMENTO PROTOCOLO - '|| vProtocolo ,
                                        vCorpoEmail,
                                        'aut-e@dellavolpe.com.br',
                                        trim(vTpRecebido.Glb_Benasserec_Origem),
                                        'grp.recebeautfat@dellavolpe.com.br');
   
   commit;
End spi_ExecutaAutFat;

Procedure sp_ExecutaAutFat2(pProtocolo in number)
  As
    ptprecebido rmadm.t_glb_benasserec%rowtype;
    vStatus char;
    vMessage varchar2(1000);
  Begin
    select *
      into ptprecebido
    from rmadm.t_glb_benasserec br
    where br.glb_benasserec_chave = pProtocolo;
    
      ptprecebido.Glb_Benasserec_Assunto := 'MSG=AUTFAT;PROT=' || trim(to_char(pProtocolo)); 
      ptprecebido.Glb_Benasserec_Origem := 'tdv.cadastro@dellavolpe.com.br';
    
    PKG_EDI_CONTROLE.spi_ExecutaAutFat(ptprecebido,vStatus,vMessage);
      
  End;
  
  Procedure SPi_INC_ACELORMITTAL(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                 pStatus out char,
                                 pMessage out varchar2,
                                 pChave in varchar2 default null)
    As
      vTpRecebido rmadm.t_glb_benasserec%rowtype;
      vHTML       clob := empty_clob;
      vHTMLSobrou clob := empty_clob;
      vLinha      clob := empty_clob;
      vColuna     clob := empty_clob;
      vTag        varchar2(20000);
      vInicio     integer := 0;
      vQtdeBytes  integer := 0;
      vFim        integer := 0;
      vAuxiliar   integer := 0;
      vQtdeTable  integer := 0;
      vContaTab   integer := 0;
      vTpArcelormittal tdvadm.t_edi_arcelormittal%rowtype;
      vSeq        integer := 0;
      vChave      varchar2(10);
    Begin

       pStatus := 'N';
       pMessage := '';
       
       vTpRecebido := pTpRecebido;
       if vTpRecebido.Glb_Benasserec_Assunto is null Then
          vChave := pChave;
          if vchave is null Then 
            return ;
          End If;  
          select *
            into vTpRecebido
          from rmadm.t_glb_benasserec br
          where br.glb_benasserec_chave = vChave;
--         delete t_glb_sql x where x.glb_sql_observacao = 'sirlano' and x.glb_sql_programa in ('Corpo','Linha','Coluna');
      
      -- se contiver somente a MSG será considerado que esta no corpo do email
--      vTpRecebido.Glb_Benasserec_Assunto := 'MSG=ACELORMITTAL'; 
      -- Se contiver um protocolo deve-se procurar no campo Memo da Tabela
          vTpRecebido.Glb_Benasserec_Assunto := 'MSG=ACELORMITTAL;PROT='|| vChave; 
--          vTpRecebido.Glb_Benasserec_Origem  := 'acelormittal@dellavolpe.com.br';
       End if;
      
       if vTpRecebido.Glb_Benasserec_Origem not in ('arcelormittal@dellavolpe.com.br','silvio.corona@arcelormittal.com.br') Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage := 'Remetente não autorizado' || chr(10);
       End If; 
   
       vHTML := vTpRecebido.Glb_Benasserec_Conteudoanexo;

      vQtdeTable :=  pkg_glb_html.fn_ContaTag(vHTML,'table');
      vAuxiliar := 0;
      vContaTab := 0;
--      vHTML := replace(vHTML,'<colgroup>','');

      -- igual a as duas antes de comecar
      vHTMLSobrou := vHTML;
      loop
          
          exit When vContaTab = vQtdeTable;

          -- pega a Proxima Tabela
          pkg_glb_html.sp_posicaoTag(vHTMLSobrou,'table',vInicio,vQtdeBytes);
          
          
          
          -- Pega a Regiao a ser processada
          vHTML       := substr(vHTMLSobrou,vInicio,vQtdeBytes);
          -- Ajusta o que sobrou na variavel 
          vHTMLSobrou := substr(vHTMLSobrou,vInicio + vQtdeBytes + 1);
          vSeq := 0;
--          insert into t_glb_sql values (vHTML,sysdate,'Corpo','sirlano');
    --      sp_ProximaTag(vHTML,vTag);
    --      vTag := vTag;
          loop

             pkg_glb_html.sp_ProximaLinha(vHTML,vLinha,'tr');
             

--             insert into t_glb_sql values (vLinha,sysdate,'Linha','sirlano');
--                exit when vLinha is null;

                    

--                insert into t_glb_sql values (vColuna,sysdate,'Coluna','sirlano');
--                   exit when vColuna is null;

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                if vLinha is null Then 
                   exit;
                End If;   
                if vColuna is null Then 
                   exit;
                End If;   
                if vSeq = 2000 Then 
                   exit;
                End If;   

                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Pedido       := vColuna; -- Pedido

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Itempedido   := vColuna; -- Ítem Pedido

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Qtdeped      :=  replace(replace(vColuna,'.',''),',','.'); -- Qtde Pedido

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Dtremessa    := replace(vColuna,'.','/'); -- Dt. Remessa Ítem PC

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Dtpedido     :=  replace(vColuna,'.','/'); -- Data Pedido

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Tpcompra     := vColuna; -- Tipo Doc. Compra

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Grpcompra    := vColuna; -- Grp. Compras

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Inconterms   := vColuna; -- Incoterms

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Material     := vColuna;  -- Material

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Ump          := vColuna; -- UMP

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Codfornec    := vColuna; -- Fornecedor 

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Descfornec   := vColuna; -- Descr. Fornecedor

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Centro       := vColuna; -- Centro

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Uf           := vColuna; -- Estado

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Cnpj         := vColuna; -- CGC

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Cidade       := vColuna; -- Cidade

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Descmaterial := vColuna; -- Descr. Material

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Fonefornec   := SUBSTR(vColuna,1,22); -- Telefone do Fornecedo

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Emailfornec  := vColuna; -- Email do Fornecedor

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Valorliquido := replace(replace(vColuna,'.',''),',','.'); -- Valor Líquido

                pkg_glb_html.sp_ProximaColuna(vLinha,vColuna,'td');
                vColuna := trim(glbadm.pkg_glb_xml.fn_VoltaXml(pkg_glb_html.fn_PegaConteudo(vColuna)));
                vColuna := replace(vColuna,chr(160),'');
                vTpArcelormittal.Edi_Arcelormittal_Moeda        := substr(vColuna,1,5); -- Moeda

                vTpArcelormittal.Edi_Arcelormittal_Contrato     := 'N';
                vTpArcelormittal.Edi_Arcelormittal_Tpcoleta     := 'N';
                vTpArcelormittal.Edi_Arcelormittal_Dtalteracao  := null;
                vTpArcelormittal.Usu_Usuario_Alterou            := null;
                vTpArcelormittal.Arm_Coleta_Nrcompra            := null;
                vTpArcelormittal.Arm_Coleta_Ciclo               := null;
                vTpArcelormittal.Edi_Integra_Gravacao           := sysdate;
                vTpArcelormittal.Edi_Integra_Planilha           := vTpRecebido.Glb_Benasserec_Fileanexo;
                vTpArcelormittal.Edi_Integra_Protocolo          := vTpRecebido.Glb_Benasserec_Chave;
                vTpArcelormittal.Edi_Integra_Sequencia          := vSeq;
                vTpArcelormittal.Edi_Integra_Cliente            := 'ARCELORMITTAL';
                if vSeq > 0 Then
                   vTpArcelormittal.Edi_Arcelormittal_Usado        := 'N';
                   vTpArcelormittal.Edi_Integra_Critica            := null;
                   vTpArcelormittal.Edi_Integra_Processado         := null;
                Else
                   vTpArcelormittal.Edi_Arcelormittal_Usado        := 'S';
                   vTpArcelormittal.Edi_Integra_Critica            := 'Cabecalho do table';
                   vTpArcelormittal.Edi_Integra_Processado         := sysdate;
                End If;   
                 
                IF vTpArcelormittal.Edi_Arcelormittal_Pedido IS NOT NULL AND vTpArcelormittal.Edi_Arcelormittal_Pedido <> 'Pedido' Then
                   select count(*)
                      into vAuxiliar
                   from tdvadm.t_edi_arcelormittal a
                   where a.edi_arcelormittal_pedido = vTpArcelormittal.Edi_Arcelormittal_Pedido
                     and a.edi_arcelormittal_itempedido = vTpArcelormittal.Edi_Arcelormittal_Itempedido;
                   if vAuxiliar = 0 Then  
                      insert into t_edi_arcelormittal values vTpArcelormittal;
                   End If;
                   vSeq := vSeq + 1;
                End If;   

          End Loop; -- Linha
          vContaTab := vContaTab + 1;
          commit;
      end Loop; -- Table
    
  End SPi_INC_ACELORMITTAL;  
  
  
  

  Procedure SPi_INC_MOTORISTA(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                              pStatus out char,
                              pMessage out varchar2,
                              pChave in varchar2 default null)
  As
    vSistema   varchar2(100);
    vMatricula varchar2(10);
    vEmail1 varchar2(200);
    vStatus char(1);
    vMessage varchar2(1000);
    vContador number;
    tpFRTMotorista tdvadm.t_frt_motorista%rowtype;
  Begin
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
       vEmail1 := 'sdrumond@dellavolpe.com.br';
       
      --Exemplo de QryString = MSG=INCMOTORISTA;MATRICULA=1243

       vMatricula := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'MATRICULA','=',';'));     
       vSistema   := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'MSG','=',';'));

      select count(*)
         into vContador
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = rpad(vSistema,12)
        and pa.edi_planilhacfg_sistema = rpad(vSistema,20)
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(pTpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
        If vContador > 0 Then 

           Begin
             
              select count(*)
                into vContador
              from tdvadm.t_frt_motorista m
              where m.FRT_MOTORISTA_MATRICULA = vMatricula;
              
              If vContador = 0 Then
                 select *
                   into tpFRTMotorista
                 from tdvadm.v_frt_motoristafpw x 
                 where x.FRT_MOTORISTA_MATRICULA = lpad(vMatricula,9,'0');
                 
                 tpFRTMotorista.Frt_Motorista_Codigo := lpad(tpFRTMotorista.Frt_Motorista_Codigo,4,'0');
                 
                 insert into tdvadm.t_frt_motorista m values tpFRTMotorista;
                 
                 pTpRecebido.Glb_Benasserec_Processado := Sysdate;
                 pTpRecebido.Glb_Benasserec_Status     := 'OK';
                 vStatus     := 'N';
                 vMessage    := chr(10) || chr(10) || 'Matricula  FPW ' || vMatricula || ' Matricula TDV ' || tpFRTMotorista.Frt_Motorista_Codigo ||  chr(10) ;
              Else
                 vStatus     := 'E';
                 vMessage    := chr(10) || chr(10) || 'Matricula  ' || vMatricula || ' já cadastrada...' || chr(10) ;
                 pTpRecebido.Glb_Benasserec_Processado := Sysdate;
                 pTpRecebido.Glb_Benasserec_Status     := 'ER';
              End If;    
               
           Exception
            When OTHERS Then
               vStatus     := 'E';
               vMessage    := chr(10) || chr(10) || 'Erro ORACLE ' || chr(10) || chr(10) || sqlerrm;
               pTpRecebido.Glb_Benasserec_Processado := Sysdate;
               pTpRecebido.Glb_Benasserec_Status     := 'ER';
            End;             
                                 
        Else
            vStatus     := 'E';
            vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
            pTpRecebido.Glb_Benasserec_Processado := Sysdate;
            pTpRecebido.Glb_Benasserec_Status     := 'ER';
        End If;                                               


        wservice.pkg_glb_email.SP_ENVIAEMAIL('INCLUSAO DE MOTORISTA',
                                             vMessage,
                                             'tdv.producao@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem,
                                             vEmail1);



    
  End SPi_INC_MOTORISTA;



  Procedure SPi_CAR_TIRABLOQUEIO(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                                 pStatus out char,
                                 pMessage out varchar2)
  As
    vSistema               varchar2(100);
    vCPF                   tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type;
    tpProprietarioSusp     tdvadm.t_car_proprietariosusp%rowtype;
    tpProprietarioSuspHist tdvadm.t_car_proprietariosusphist%rowtype;
    vEmail1 varchar2(200);
    vStatus char(1);
    vMessage varchar2(1000);
    vContador number;
  Begin
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
       vEmail1 := 'sdrumond@dellavolpe.com.br';
       
      --Exemplo de QryString = MSG=DESESOCIAL;CPF=12345678901
      
       vCPF := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'CPF','=',';'));     
       vSistema   := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'MSG','=',';'));

      select count(*)
         into vContador
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = rpad(vSistema,12)
        and pa.edi_planilhacfg_sistema = rpad(vSistema,20)
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(pTpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
        If vContador > 0 Then 

           Begin
             
              select *
                into tpProprietarioSusp
              from tdvadm.t_car_proprietariosusp ps
              where ps.car_proprietario_cgccpfcodigo = vCPF
                and ps.car_proprietariosusp_obs like '%eSocial%';
              
        
               tpProprietarioSuspHist.CAR_PROPRIETARIO_CPFCODIGO := tpProprietarioSusp.Car_Proprietario_Cgccpfcodigo;
               select max(ps.car_proprietariosusp_sequencia) + 1
                 into tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_SEQUENCIA
               from tdvadm.t_car_proprietariosusphist ps
               where ps.car_proprietario_cpfcodigo = vCPF;
               
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_SEQUENCIA := nvl(tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_SEQUENCIA,1);
               
               tpProprietarioSuspHist.GLB_CLIENTE_CGCCPFCODIGO := tpProprietarioSusp.Glb_Cliente_Cgccpfcodigo;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_REM := tpProprietarioSusp.Car_Proprietariosusp_Rem;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_SAC := tpProprietarioSusp.Car_Proprietariosusp_Sac;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_DEST := tpProprietarioSusp.Car_Proprietariosusp_Dest;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_DIAS := tpProprietarioSusp.Car_Proprietariosusp_Dias;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_DT := tpProprietarioSusp.Car_Proprietariosusp_Dt;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_BLOQUEIO := tpProprietarioSusp.Car_Proprietariosusp_Boqueio;
               tpProprietarioSuspHist.USU_USUARIO_CODIGO := tpProprietarioSusp.Usu_Usuario_Codigo;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_OBS := tpProprietarioSusp.Car_Proprietariosusp_Obs;
               tpProprietarioSuspHist.USU_USUARIO_CODIGODESB := 'jsantos';
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_DTGRAV := tpProprietarioSusp.Car_Proprietariosusp_Dtgrav;
               tpProprietarioSuspHist.CAR_PROPRIETARIOSUSP_DTBLOQ := sysdate;
           
           

              delete tdvadm.t_car_proprietariosusp ps
              where ps.car_proprietario_cgccpfcodigo = vCPF
                and ps.car_proprietariosusp_obs like '%eSocial%';
              
              insert into tdvadm.t_car_proprietariosusphist
              values tpProprietarioSuspHist;
           
        
  
                pTpRecebido.glb_benasserec_status      := 'OK';
                 vStatus     := 'N';
                 vMessage    := chr(10) || chr(10) || 'CPF  ' || vCPF || ' Liberado ! ' ||  chr(10) ;
               
           Exception
            When NO_DATA_FOUND Then
               vStatus     := 'E';
               vMessage    := chr(10) || chr(10) || 'CPF  ' || vCPF || ' Não estava bloqueado ! '  || chr(10) ;
               pTpRecebido.Glb_Benasserec_Processado := Sysdate;
               pTpRecebido.Glb_Benasserec_Status     := 'ER';
              
            When OTHERS Then
               vStatus     := 'E';
               vMessage    := chr(10) || chr(10) || 'Erro ORACLE ' || chr(10) || chr(10) || sqlerrm;
               pTpRecebido.Glb_Benasserec_Processado := Sysdate;
               pTpRecebido.Glb_Benasserec_Status     := 'ER';
            End;             
                                 
        Else
            vStatus     := 'E';
            vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
            pTpRecebido.Glb_Benasserec_Processado := Sysdate;
            pTpRecebido.Glb_Benasserec_Status     := 'ER';
        End If;                                               


        wservice.pkg_glb_email.SP_ENVIAEMAIL('DESBLOQUEIO eSocial',
                                             vMessage,
                                             'tdv.producao@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem,
                                             vEmail1);



    
  End SPi_CAR_TIRABLOQUEIO;


  Procedure spi_ARM_DTPEDIDO(pTpRecebido in out rmadm.t_glb_benasserec%rowtype,
                             pStatus out char,
                             pMessage out varchar2)
  As
    vSistema               varchar2(100);
    vColeta   tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
    vCiclo    tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
    vDT       tdvadm.t_arm_coleta.arm_coleta_centrodecusto%type;
    vPedido   tdvadm.t_arm_coleta.arm_coleta_pedido%type;
    vEmail1   varchar2(200);
    vStatus   char(1);
    vMessage  varchar2(1000);
    vContador number;
    vCritica  varchar2(1000);
    vErro     char(1);
  Begin
       vStatus := pkg_glb_common.Status_Nomal;
       vMessage := '';
       
       vEmail1 := 'sdrumond@dellavolpe.com.br';
       
      --Exemplo de QryString = MSG=DTPEDIDO;COLETA=999999;DT=12345678901;PEDIDO=55433445
      
       vSistema := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'MSG','=',';'));
       vColeta  := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'COLETA','=',';'));     
       vDT      := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'DT','=',';'));     
       vPedido  := Trim(tdvadm.fn_querystring(pTpRecebido.Glb_Benasserec_Assunto,'PEDIDO','=',';'));     
      
       vContador := length(trim(vDT));
       If vContador <> 7 Then
          vCritica := vCritica || 'DT ' || vDT  || ' com ' || to_char(vContador) || ' digitos. ' || chr(10); 
          vErro := 'S';
       End If;



      select count(*)
         into vContador
      from tdvadm.t_edi_planilhaaut pa
      where pa.edi_planilhacfg_codigo = rpad(vSistema,12)
        and pa.edi_planilhacfg_sistema = rpad(vSistema,20)
        and pa.edi_planilhaaut_autoriza = 'S'
        and instr(lower(pTpRecebido.Glb_Benasserec_Origem),pa.edi_planilhaaut_email) > 0 
        and pa.edi_planilhaaut_ativo = 'S'
        and pa.edi_planilhaaut_vigencia <= sysdate
        and pa.edi_planilhaaut_validate >= sysdate;
                  -- verifica se pode autorizar                      
        If vContador > 0 Then 

           Begin
             
                update tdvadm.t_arm_coleta co
                  set co.arm_coleta_centrodecusto = vDT,
                      co.arm_coleta_pedido = vPedido
                where co.arm_coleta_ncompra = vColeta
                  and co.arm_coleta_ciclo = '002';
             

                pTpRecebido.glb_benasserec_status      := 'OK';
                 vStatus     := 'N';
--                 vMessage    := chr(10) || chr(10) || 'CPF  ' || vCPF || ' Liberado ! ' ||  chr(10) ;
               
           Exception
            When NO_DATA_FOUND Then
               vStatus     := 'E';
--               vMessage    := chr(10) || chr(10) || 'CPF  ' || vCPF || ' Não estava bloqueado ! '  || chr(10) ;
               pTpRecebido.Glb_Benasserec_Processado := Sysdate;
               pTpRecebido.Glb_Benasserec_Status     := 'ER';
              
            When OTHERS Then
               vStatus     := 'E';
--               vMessage    := chr(10) || chr(10) || 'Erro ORACLE ' || chr(10) || chr(10) || sqlerrm;
               pTpRecebido.Glb_Benasserec_Processado := Sysdate;
               pTpRecebido.Glb_Benasserec_Status     := 'ER';
            End;             
                                 
        Else
            vStatus     := 'E';
            vMessage    := chr(10) || chr(10) || 'Voce Não esta AUTORIZADO' || chr(10) || chr(10);
            pTpRecebido.Glb_Benasserec_Processado := Sysdate;
            pTpRecebido.Glb_Benasserec_Status     := 'ER';
        End If;                                               


/*        wservice.pkg_glb_email.SP_ENVIAEMAIL('DESBLOQUEIO eSocial',
                                             vMessage,
                                             'tdv.producao@dellavolpe.com.br',
                                             pTpRecebido.glb_benasserec_origem,
                                             vEmail1);
*/


    
  End spi_ARM_DTPEDIDO;



   Procedure SP_GLB_INCBENASSEREC(P_XMLIN in clob/*,
                                  P_STATUS out char,
                                  P_MESSAGE out varchar2*/)  
    as
      tpRegBenasse rmadm.t_glb_benasserec%rowtype;
      vXML clob;
      vCorpo clob;
      vAnexo clob;
      vMarca char(1);
     Begin

/* exemplo do xml
<Parametros>
   <Imputs>
      <Imput>
         <chave>10</chave>
         <gravacao>01/11/2013 14:06:12</gravacao>
         <envio>30/12/1899</envio>
         <recebimento>Thu, 22 Aug 2013 18:09:12 -0300</recebimento>
         <origem>nfe@cmpc.com.br</origem>
         <NomeOrigem>Nota Fiscal Melhoramentos" </NomeOrigem>
         <destino>tdv.edirecebe@dellavolpe.com.br</destino>
         <NomeDestino></NomeDestino>
         <copia></copia>
         <NomeCopia></NomeCopia>
         <copiaoc></copiaoc>
         <Nomeoc></Nomeoc>
         <assunto>HOM- NFe N. 000284490 - Melhoramentos Papéis</assunto>
         <formato>0</formato>
         <cabecalho></cabecalho>
         <corpo>35130844145845001546550010002844901499663023
         </corpo>
         <TipoCorpo></TipoCorpo>
         <Prioridade>0</Prioridade>
         <qtdeanexo>1</qtdeanexo>
         <NomeAnexoOr>35130844145845001546550010002844901499663023-nfe.xml</NomeAnexoOr>
         <NomeAnexo>131101140612719.xml</NomeAnexo>
         <processado>01/11/2013 14:06:12</processado>
         <status>IN</status>
         <ipaddress></ipaddress>
         <protocolo></protocolo>
         <obs></obs>
         <acaoapos></acaoapos>
      </Imput>
   </Imputs>
</Parametros>
*/
    vXML :=  P_XMLIN;
     
     begin

     tpRegBenasse.Glb_Benasserec_Chave         := rmadm.SEQ_GLB_BENASSEREC.NEXTVAL;
     tpRegBenasse.Glb_Benasserec_Gravacao      := sysdate;
     tpRegBenasse.Glb_Benasserec_Origem        :=  trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'origem' )));
     tpRegBenasse.Glb_Benasserec_Assunto       := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'assunto' )));
     Begin
        vMarca := '1';
        vCorpo := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParamClob( vXML,'corpo' );
        vMarca := '2';
        vCorpo := Glbadm.pkg_glb_xml.fn_VoltaXml(vCorpo);
--        vCorpo := replace(vCorpo,chr(10),null);
        vMarca := '3';
        tpRegBenasse.Glb_Benasserec_Corpo   := vCorpo;

        vMarca := '4';
        vAnexo := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParamClob( vXML,'Anexo' );
        vMarca := '5';
        vAnexo := Glbadm.pkg_glb_xml.fn_VoltaXml(vAnexo);
--        vCorpo := replace(vCorpo,chr(10),null);
        vMarca := '6';
        tpRegBenasse.Glb_Benasserec_Conteudoanexo   := vAnexo;


     exception
       when OTHERS Then
         Begin
          insert into t_glb_sql (glb_sql_instrucao,glb_sql_dtgravacao,glb_sql_programa,glb_sql_observacao)
               values (P_XMLIN,sysdate,'email','sirlano Pegando o Corpo Falha no Corpo'||vMarca);
          commit; 
         exception
           When OTHERS Then
             tpRegBenasse.Glb_Benasserec_Corpo := vMarca || 'Erro Pegando Corpo 1 ao inserir Tamanho->' || length(vCorpo) || 'erro:' ||  sqlerrm; 
         End ;
          if tpRegBenasse.Glb_Benasserec_Corpo is null then
             tpRegBenasse.Glb_Benasserec_Corpo := vMarca || 'Erro Pegando Corpo 2 ao inserir Tamanho->' || length(vCorpo) || 'erro:' ||  sqlerrm; 
          End If;   
     End;   
     tpRegBenasse.Glb_Benasserec_Pathanexo     := null;
     tpRegBenasse.Glb_Benasserec_Fileanexo     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'NomeAnexo' ));
     tpRegBenasse.Glb_Benasserec_Dataenvior    := to_date(trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'gravacao' )),'dd/mm/yyyy hh24:mi:ss');
     tpRegBenasse.Glb_Benasserec_Destino       := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'destino' )));
     tpRegBenasse.Glb_Benasserec_Copia         := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'copia' )));
     tpRegBenasse.Glb_Benasserec_Seqanexo      := 1;
     tpRegBenasse.Glb_Benasserec_Status        := 'IN';
     tpRegBenasse.Glb_Benasserec_Fileanexoorig := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'NomeAnexoOr' )));
     tpRegBenasse.Glb_Benasserec_Ipaddress     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'ipaddress' ));

     if tpRegBenasse.Glb_Benasserec_Ipaddress is null then
        select trim(a.ip_address)
          into tpRegBenasse.Glb_Benasserec_Ipaddress 
        from tdvadm.v_glb_ambiente a;  
     End if;   

     tpRegBenasse.Glb_Benasserec_Id            := null;
     tpRegBenasse.Glb_Benasserec_Processado    := null;
     tpRegBenasse.Glb_Benasserec_Protocolo     := null;
     tpRegBenasse.Glb_Benasserec_Obs           := 'Gravado pelo Processo Della Volpe';
     insert into rmadm.t_glb_benasserec values tpRegBenasse;
     commit;    
     exception
       when OTHERS Then
          insert into t_glb_sql (glb_sql_instrucao,glb_sql_dtgravacao,glb_sql_programa,glb_sql_observacao)
               values (P_XMLIN,sysdate,'email','sirlano Inserindo FALHA GERAL erro:');
          commit; 
          Begin
            tpRegBenasse.Glb_Benasserec_Corpo := 'Erro ao inserir Com o Corpo ' || sqlerrm;
            insert into rmadm.t_glb_benasserec values tpRegBenasse;
            commit;    
          Exception
            When OTHERS Then
               tpRegBenasse.Glb_Benasserec_Corpo := sqlerrm;
            End;
          
      End;   
       
     End SP_GLB_INCBENASSEREC;



   Procedure SP_GLB_INCBENASSEREC2(P_XMLIN in clob,
                                   P_XMLIN2 in clob)  
    as
      tpRegBenasse rmadm.t_glb_benasserec%rowtype;
      vXML clob;
      vCorpo clob;
      vAnexo clob;
      vMarca char(1);
     Begin

/* exemplo do xml
<Parametros>
   <Imputs>
      <Imput>
         <chave>10</chave>
         <gravacao>01/11/2013 14:06:12</gravacao>
         <envio>30/12/1899</envio>
         <recebimento>Thu, 22 Aug 2013 18:09:12 -0300</recebimento>
         <origem>nfe@cmpc.com.br</origem>
         <NomeOrigem>Nota Fiscal Melhoramentos" </NomeOrigem>
         <destino>tdv.edirecebe@dellavolpe.com.br</destino>
         <NomeDestino></NomeDestino>
         <copia></copia>
         <NomeCopia></NomeCopia>
         <copiaoc></copiaoc>
         <Nomeoc></Nomeoc>
         <assunto>HOM- NFe N. 000284490 - Melhoramentos Papéis</assunto>
         <formato>0</formato>
         <cabecalho></cabecalho>
         <corpo>35130844145845001546550010002844901499663023
         </corpo>
         <TipoCorpo></TipoCorpo>
         <Prioridade>0</Prioridade>
         <qtdeanexo>1</qtdeanexo>
         <NomeAnexoOr>35130844145845001546550010002844901499663023-nfe.xml</NomeAnexoOr>
         <NomeAnexo>131101140612719.xml</NomeAnexo>
         <processado>01/11/2013 14:06:12</processado>
         <status>IN</status>
         <ipaddress></ipaddress>
         <protocolo></protocolo>
         <obs></obs>
         <acaoapos></acaoapos>
      </Imput>
   </Imputs>
</Parametros>
*/
    vXML :=  P_XMLIN;
     
     begin

     tpRegBenasse.Glb_Benasserec_Chave         := rmadm.SEQ_GLB_BENASSEREC.NEXTVAL;
     tpRegBenasse.Glb_Benasserec_Gravacao      := sysdate;
     tpRegBenasse.Glb_Benasserec_Origem        :=  trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'origem' )));
     tpRegBenasse.Glb_Benasserec_Assunto       := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'assunto' )));
     Begin
        vMarca := '1';
        vCorpo := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParamClob( vXML,'corpo' );
        vMarca := '2';
        vCorpo := Glbadm.pkg_glb_xml.fn_VoltaXml(vCorpo);
--        vCorpo := replace(vCorpo,chr(10),null);
        vMarca := '3';
        tpRegBenasse.Glb_Benasserec_Corpo   := vCorpo;

        vMarca := '4';
        vAnexo := P_XMLIN2;
        vMarca := '5';
--        vAnexo := Glbadm.pkg_glb_xml.fn_VoltaXml(vAnexo);
--        vCorpo := replace(vCorpo,chr(10),null);
        vMarca := '6';
        tpRegBenasse.Glb_Benasserec_Conteudoanexo   := vAnexo;


     exception
       when OTHERS Then
         Begin
          insert into t_glb_sql (glb_sql_instrucao,glb_sql_dtgravacao,glb_sql_programa,glb_sql_observacao)
               values (P_XMLIN,sysdate,'email','sirlano Pegando o Corpo Falha no Corpo'||vMarca);
          commit; 
         exception
           When OTHERS Then
             tpRegBenasse.Glb_Benasserec_Corpo := vMarca || 'Erro Pegando Corpo 1 ao inserir Tamanho->' || length(vCorpo) || 'erro:' ||  sqlerrm; 
         End ;
          if tpRegBenasse.Glb_Benasserec_Corpo is null then
             tpRegBenasse.Glb_Benasserec_Corpo := vMarca || 'Erro Pegando Corpo 2 ao inserir Tamanho->' || length(vCorpo) || 'erro:' ||  sqlerrm; 
          End If;   
     End;   
     tpRegBenasse.Glb_Benasserec_Pathanexo     := null;
     tpRegBenasse.Glb_Benasserec_Fileanexo     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'NomeAnexo' ));
     tpRegBenasse.Glb_Benasserec_Dataenvior    := to_date(trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'gravacao' )),'dd/mm/yyyy hh24:mi:ss');
     tpRegBenasse.Glb_Benasserec_Destino       := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'destino' )));
     tpRegBenasse.Glb_Benasserec_Copia         := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'copia' )));
     tpRegBenasse.Glb_Benasserec_Seqanexo      := 1;
     tpRegBenasse.Glb_Benasserec_Status        := 'IN';
     tpRegBenasse.Glb_Benasserec_Fileanexoorig := trim(glbadm.pkg_glb_xml.fn_VoltaXml(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'NomeAnexoOr' )));
     tpRegBenasse.Glb_Benasserec_Ipaddress     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vXML,'ipaddress' ));

     if tpRegBenasse.Glb_Benasserec_Ipaddress is null then
        select trim(a.ip_address)
          into tpRegBenasse.Glb_Benasserec_Ipaddress 
        from tdvadm.v_glb_ambiente a;  
     End if;   

     tpRegBenasse.Glb_Benasserec_Id            := null;
     tpRegBenasse.Glb_Benasserec_Processado    := null;
     tpRegBenasse.Glb_Benasserec_Protocolo     := null;
     tpRegBenasse.Glb_Benasserec_Obs           := 'Gravado pelo Processo Della Volpe';
     insert into rmadm.t_glb_benasserec values tpRegBenasse;
     commit;    
     exception
       when OTHERS Then
          insert into t_glb_sql (glb_sql_instrucao,glb_sql_dtgravacao,glb_sql_programa,glb_sql_observacao)
               values (P_XMLIN,sysdate,'email','sirlano Inserindo FALHA GERAL erro:');
          commit; 
          Begin
            tpRegBenasse.Glb_Benasserec_Corpo := 'Erro ao inserir Com o Corpo ' || sqlerrm;
            insert into rmadm.t_glb_benasserec values tpRegBenasse;
            commit;    
          Exception
            When OTHERS Then
               tpRegBenasse.Glb_Benasserec_Corpo := sqlerrm;
            End;
          
      End;   
       
     End SP_GLB_INCBENASSEREC2;    
     
  procedure sp_uti_rodou_aute(pTipo in char) is
     
      begin
          
        if pTipo = 'E' then
            
           update tdvadm.t_uti_analiseapp ap
              set ap.uti_analiseapp_dtatualizao = sysdate
            where ap.uti_analiseapp_id = '6';
             
        else 
            
          update tdvadm.t_uti_analiseapp ap
              set ap.uti_analiseapp_dtatualizao = sysdate
            where ap.uti_analiseapp_id = '7';

        end if;   
          
        commit;
  
   end sp_uti_rodou_aute;

   Procedure sp_bi_glb_processa(vSql in varchar2)
     As

      c_linhas      T_CURSOR;
      
      vContador     Number; -- auxiliar contador
      MSGORIGEM     rmadm.T_GLB_BENASSEMSG.GLB_BENASSEMSG_ORIGEM%TYPE; -- se veio por email ou torpedo
      vAnexo        char(1); -- se existe anexo na mensagem
      vExesso       Char(1); -- se houve excesso no recebimento de msg com anexo
      
      vEnviadosCA   Number; -- quatidade de emails ja enviados
--      vAutorizado   CHAR(1); -- se o recebimento de anexo esta autorizado
      MsgRet        clob; -- Texto da mensagem de retorno
      vStatus       char(01);
      vMessage      clob;
      tpBenasserec  rmadm.t_glb_benasserec%rowtype;  
      tpplanilhaaut tdvadm.t_edi_planilhaaut%rowtype;
      vAchouTarefa  char(1);
      protoc        rmadm.t_glb_benasserec.glb_benasserec_chave%type;
      Arqcsv        rmadm.t_glb_benasserec.glb_benasserec_fileanexo%type;      
--      vProcesso     char(1);
    
   Begin
          open c_linhas FOR vSql;
          loop
            Begin
                fetch c_linhas into tpBenasserec;
                exit when c_linhas%notfound;

                If length(trim(nvl(tpBenasserec.Glb_Benasserec_Destino,''))) = 0 then
                   
                   tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                   tpBenasserec.Glb_Benasserec_Status     := 'ER';
                   tpBenasserec.Glb_Benasserec_Obs := 'Não Tem Destinatario no Email';
                   tpplanilhaaut.edi_planilhaaut_permiteanexo := 'N';
                   tpplanilhaaut.edi_planilhaaut_autoriza := 'N';
                   tpplanilhaaut.edi_planilhaaut_limitdiario := 0;
                Else
             
                Begin
                  
                
                -- Limpa as imagens caso seja um JPG ou GIF
                if instr(upper(tpBenasserec.Glb_Benasserec_Fileanexo),'.JPG') > 0 or
                   instr(upper(tpBenasserec.Glb_Benasserec_Fileanexo),'.GIF') > 0 Then
                   tpBenasserec.Glb_Benasserec_Fileanexo := null;
                   tpBenasserec.Glb_Benasserec_Fileanexoorig := null;
                End If;
                
                  -- dependendo da Origem muda o Assunto
                  

    /*  retira em 26/12/2014
        Sirlano não e mais necessario a troca
                  if trim(tpBenasserec.Glb_Benasserec_Origem) in ('tdv.rj.pontoeletronico@dellavolpe.com.br',
                                                                  'tsantiago@dellavolpe.com.br') then
                    update rmadm.t_glb_benasserec b
                      set b.glb_benasserec_assunto = 'ADF'
                    where b.glb_benasserec_chave = tpBenasserec.Glb_Benasserec_Chave;

    */              
                  /**ACERTO NA INTEGRAÇÃO PARA O CLIENTE NOVA . COM**/
                  If trim(tpBenasserec.Glb_Benasserec_Origem) in ('notfis@corp.pontofrio.com') Then
                    update rmadm.t_glb_benasserec b
                      set b.glb_benasserec_assunto = 'NOVAPTOCOM'
                    where b.glb_benasserec_chave = tpBenasserec.Glb_Benasserec_Chave;
                     tpBenasserec.Glb_Benasserec_Assunto := 'NOVAPTOCOM';
                  
                  /**ACERTO NA INTEGRAÇÃO PARA O CLIENTE STAPLES**/   
                  ElsIf trim(tpBenasserec.Glb_Benasserec_Origem) in ('dellavolpe@staples.com.br') Then
                    update rmadm.t_glb_benasserec b
                      set b.glb_benasserec_assunto = 'EDISTAPLES'
                    where b.glb_benasserec_chave = tpBenasserec.Glb_Benasserec_Chave;
                     
                     tpBenasserec.Glb_Benasserec_Assunto := 'EDISTAPLES';
                     
                 /** ACERTO NA INTEGRAÇÃO PARA O CLIENTE MEHLORAMENTOS **/
                  ElsIf trim(tpBenasserec.Glb_Benasserec_Origem) in ('jobrun@cmpc.com.br','nfe@cmpc.com.br','tdv.edirecebe@dellavolpe.com.br') Then
                    update rmadm.t_glb_benasserec b
                      set b.glb_benasserec_assunto = 'EDIMELHORA'
                    where b.glb_benasserec_chave = tpBenasserec.Glb_Benasserec_Chave;
                     
                     tpBenasserec.Glb_Benasserec_Assunto := 'EDIMELHORA';       
                     
                  End if;   
                  
                  -- VERIFICA SE TEM AUTORIZAÇÃO PELO ASSUNTO NA INTEGRA DO EMAIL
                  Select *
                    into tpplanilhaaut
                  from tdvadm.t_edi_planilhaaut pa
                  where trim(pa.edi_planilhacfg_codigo) = trim(tpBenasserec.Glb_Benasserec_Assunto)
                    and trim(pa.edi_planilhacfg_sistema) = trim(tpBenasserec.Glb_Benasserec_Assunto)
                    and pa.edi_planilhaaut_ativo = 'S'
                    and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                    and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                    and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                Exception
                  When OTHERS Then  
                  Begin
                      -- VERIFICA SE TEM AUTORIZAÇÃO USANDO UMA QUERY STRING NO ASSUNTO NA INTEGRA DO EMAIL
                      Select *
                        into tpplanilhaaut
                      from tdvadm.t_edi_planilhaaut pa
                      where trim(pa.edi_planilhacfg_codigo) = (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))))
                        and trim(pa.edi_planilhacfg_sistema) = (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))))
                        and pa.edi_planilhaaut_ativo = 'S'
                        and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                        and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                        and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                  Exception
                    When OTHERS Then  
                        Begin
                            -- VERIFICA SE TEM AUTORIZAÇÃO USANDO O ASSUNTO NA INTEGRA DO EMAIL E SISTEMA DEFAUL
                            Select *
                              into tpplanilhaaut
                            from tdvadm.t_edi_planilhaaut pa
                            where trim(pa.edi_planilhacfg_codigo) = trim(tpBenasserec.Glb_Benasserec_Assunto)
                              and trim(pa.edi_planilhacfg_sistema) = 'DEFAULT'
                              and pa.edi_planilhaaut_ativo = 'S'
                              and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                              and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                              and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                        Exception
                          When OTHERS Then

                            Begin
                                  -- VERIFICA SE TEM AUTORIZAÇÃO USANDO UMA QUERY STRING NO ASSUNTO NA INTEGRA DO EMAIL
                               Select *
                                 into tpplanilhaaut
                               from tdvadm.t_edi_planilhaaut pa
                               where trim(pa.edi_planilhacfg_codigo) = 'SEMANEXO'
                                 and trim(pa.edi_planilhacfg_sistema) = (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))))
                                 and pa.edi_planilhaaut_ativo = 'S'
                                 and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                                 and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                                 and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                            Exception
                              When OTHERS Then
                                 begin
                            -- VERIFICA SE TEM AUTORIZAÇÃO COMO FORMULARIO XLX OU txt
                                    Select *
                                       into tpplanilhaaut
                                    from tdvadm.t_edi_planilhaaut pa
                                    where trim(pa.edi_planilhacfg_codigo) = 'FORMULARIO'
                                      and trim(pa.edi_planilhacfg_sistema) = 'DEFAULT'
                                      and pa.edi_planilhaaut_ativo = 'S'
                                      and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                                      and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                                      and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                                   
                                 exception
                                   WHEN OTHERS Then
                                       begin
                                  -- VERIFICA SE TEM AUTORIZAÇÃO COMO FORMULARIO XLX OU txt
                                          Select *
                                             into tpplanilhaaut
                                          from tdvadm.t_edi_planilhaaut pa
                                          where trim(pa.edi_planilhacfg_codigo) = 'FORMULARIOTX'
                                            and trim(pa.edi_planilhacfg_sistema) = 'DEFAULT'
                                            and pa.edi_planilhaaut_ativo = 'S'
                                            and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                                            and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                                            and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                                         
                                       exception
                                         WHEN OTHERS Then
                                           Begin
                                              If instr(upper(tpBenasserec.Glb_Benasserec_Fileanexo),'.HTM') > 0 Then
                                                  Select *
                                                     into tpplanilhaaut
                                                  from tdvadm.t_edi_planilhaaut pa
                                                  where trim(pa.edi_planilhacfg_codigo) = 'HTML'
                                                    and trim(pa.edi_planilhacfg_sistema) = 'DEFAULT'
                                                    and pa.edi_planilhaaut_ativo = 'S'
                                                    and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                                                    and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                                                    and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                                              Else
                                                 tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                                                 tpBenasserec.Glb_Benasserec_Status     := 'ER';
                                                 tpplanilhaaut.edi_planilhaaut_permiteanexo := 'N';
                                                 tpplanilhaaut.edi_planilhaaut_autoriza := 'N';
                                                 tpplanilhaaut.edi_planilhaaut_limitdiario := 0;
                                              End If;
                                             
                                           Exception
                                             When OTHERS Then
                                               Begin

                                                   Select *
                                                     into tpplanilhaaut
                                                   from tdvadm.t_edi_planilhaaut pa
                                                   where trim(pa.edi_planilhacfg_codigo) = 'FORMULRIOnaotem'
                                                     and trim(pa.edi_planilhacfg_sistema) = (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))))
                                                     and pa.edi_planilhaaut_ativo = 'S'
                                                     and instr(lower(trim(tpBenasserec.Glb_Benasserec_Origem)),lower(pa.edi_planilhaaut_email)) > 0
                                                     and pa.edi_planilhaaut_vigencia <= TRUNC(sysdate)
                                                     and pa.edi_planilhaaut_validate >= TRUNC(sysdate);
                                                 
                                               exception
                                                 When OTHERS Then

                                                     tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                                                     tpBenasserec.Glb_Benasserec_Status     := 'ER';
                                                     tpplanilhaaut.edi_planilhaaut_permiteanexo := 'N';
                                                     tpplanilhaaut.edi_planilhaaut_autoriza := 'N';
                                                    tpplanilhaaut.edi_planilhaaut_limitdiario := 0;
                                              End;
                                           End ;
                                       End;
                                 End;
                              End;                  
                          End;
                      End;
                 end ;
        
                vEnviadosCA  := 0;
                vExesso      := 'N';
                vAchouTarefa := 'N';
              -- Identifica a origem e se tem anexo e limites Default 
              If GLBADM.PKG_GLB_UTIL.F_ENUMERICO(tpBenasserec.GLB_BENASSEREC_ORIGEM) = 'S' THEN
                -- VEIO ATRAVES DE UM TORPEDO
                MSGORIGEM   := 'CT';
                -- Se veio por Torpedo Zera o Paramentro
                tpplanilhaaut.edi_planilhaaut_limitdiario := 0;
                -- Se veio por Torpedo força S
                tpplanilhaaut.edi_planilhaaut_autoriza := 'S';

                vAnexo      := 'N';
              Else
                -- VEIO ATRAVES DE UM EMAIL
                MSGORIGEM   := 'EM';
                If tpBenasserec.glb_benasserec_fileanexo is not null Then
                  -- se no nome do arquivo contiver acentos recusa o arquivo
                  If (instr(lower('?'),tpBenasserec.glb_benasserec_fileanexo) > 0) Then
                      vAnexo := 'A';
                  Else    
                     vAnexo    := 'S';
                  End If;   
                Else
                  vAnexo      := 'N';
                  -- se Não Tinha Anexo Zera o Limite 
                  tpplanilhaaut.edi_planilhaaut_limitdiario := 0;
    --              tpplanilhaaut.edi_planilhaaut_permiteanexo := 'S';
                End if;
                
                if vAnexo = 'S' Then
                  
                  SP_Verifica_AutorizaAnexo(tpBenasserec.Glb_Benasserec_Origem,
                                            tpBenasserec.Glb_Benasserec_Copia,
                                            tpBenasserec.Glb_Benasserec_Assunto,
                                            tpBenasserec.Glb_Benasserec_Fileanexo,
                                            tpplanilhaaut.edi_planilhaaut_permiteanexo,
                                            tpplanilhaaut.edi_planilhaaut_limitdiario,
                                            vExesso,
                                            vEnviadosCA);
                End if;
               
              End If;

              End If;
                          
              Begin
                  If vAnexo <> 'A'  and tpBenasserec.Glb_Benasserec_Status <> 'ER' Then
                      /* INICIO DO BLOCO DA SASCAR */
                      if (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'TRPLSASCAR') then
                        --Exemplo de QryString = MSG=TRPLSASCAR;EQP=200211622316;DE=GPC1933;PARA=ELQ1433;
                           sp_processa_TRPLSASCAR(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                      elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'LSTTANQUE') then
                        --Exemplo de QryString = MSG=LSTTANQUE;TANQUE=01;
                          spi_get_listaSaldoTanques( tpBenasserec, vStatus, vMessage);
                          vAchouTarefa := 'S';
                      elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'TRANSFCTE') then
                        --Exemplo de QryString = MSG=TRANSFCTE;CTE=999999;SERIE=A1;ROTA=011;VF=999999;SERIEVF=A1;ROTAVF='011';SAQUEVF='1';ARMTRANSF='07';
                          sp_transfctemanual( tpBenasserec, vStatus, vMessage);
                          vAchouTarefa := 'S';
                      elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'ALTERAVOL') then
                        --Exemplo de QryString = MSG=ALTERAVOL;EMBALAGEM=2817567;QTDVOL=1;
                          sp_alteravolume( tpBenasserec, vStatus, vMessage);
                          vAchouTarefa := 'S';       
                      elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'LSTSASCAR') then
                        --Exemplo de QryString = MSG=LSTSASCAR;EQP=200211622316;
                          spi_get_listaSascar( tpBenasserec, vStatus, vMessage);
                          vAchouTarefa := 'S';
                      /* INICIO DO BLOCO PARA RODAR CUSTO DA FROTA */
                      elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'CUSTOFROTA') then
                          --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=RODARCA;PARAM=DESP_RASTR;VLR=52876.98;                    
                          --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=PARAM;PARAM=DESP_RASTR;VLR=52876.98;                    
                          --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=LISTAFROTA;                    
                          --Exemplo de QryString = MSG=CUSTOFROTA;REF=201306;ACAO=LISTAPECAS;VLRLIM=4000;FROTA=2158;                   
                          spi_Set_CustoFrota( tpBenasserec, vStatus, vMessage);
                          vAchouTarefa := 'S';
                      /* INICIO DO BLOCO AUTORIZAÇÃO DE FECHAMENTO PRD QUIMICO */
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'PRDQUIMICO') then    
                       vAchouTarefa := 'S';
                       SPI_Set_AutCarregQuimico( tpBenasserec, vStatus, vMessage);
                           
                      /* INICIO BLOCO DE EXCLUSAO DO FATURAMENTO VALE */
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'EXPREVIAFAT') then
                        --Exemplo de QryString = MSG=EXPREVIAFAT;PREVIA=888888;DATA=02/08/2012;
                           sp_processa_EXPREVIAFAT(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                            
                      /* INICIO BLOCO DE ABERTURA / FECHAMENTO REFERENCIA CONTABIL */
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'REFCTB') then
                        --Exemplo de QryString = MSG=REFCTB;REF=201212;ACAO=ABRE;
                           sp_processa_REFCTB(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                           
                       /* INICIO BLOCO DE LIBERACAO PARAMETRO */
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'LIBERAPARAN') then
                        /*Exemplo de QryString = MSG=LIBERAPARAN;
                                                 SISTEMA=ANTTINDISP;
                                                 ACAO=TRAVA/LIBERA;
                                                 PARAM=ANTTINDISP;
                                                 ROTA=010;
                                                 USUARIO=JSANTOS;
                                                 VIGENCIA=01/01/0001; 
                        */
                                                 
                           sp_processa_Altparametro(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                           
                     /* INICIO DO BLOCO DE COLETAS PARA VALE FRETE ESTADIA*/      
                     elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'INCOCOR') then
                        --Exemplo de QryString = MSG=INCOCOR;RPS=000000;SERIE=A1;ROTA=028;
                          sp_arm_ocorestadia( tpBenasserec, vStatus, vMessage);
                          vAchouTarefa := 'S';
                            
                      Elsif UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'PONTOCOM' THEN
                       -- MSG=PONTOCOM;ORI=01000;DES=33000;FRPSVO75=67.49;DES75=U;FRPSVO=0.75;DES=TX;OT3=0.1;DESOT=%;ADVL=0.6;DESADVL=%;DP=12;DESDEP=U
                           sp_processa_IncPracaPTOCOM(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 

                      /* INICIO DO BLOCO DE CARROS AUTORIZADOS A FAZER COLETA */
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'AUTCOLETA') Or
                            (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'RES: MSG','=',';'))) = 'AUTCOLETA')
                        then
                        --Exemplo de QryString = MSG=AUTCOLETA;PLACA=EQP8103;VIG=01/10/2012;
                           sp_processa_AUTCOLETA(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                      
                      /* INICIO DO BLOCO DE LIBERAÇÃO DE CFOP */
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'LIBERACFOP') Or
                            (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'RES: MSG','=',';'))) = 'LIBERACFOP')
                        then
                        --Exemplo de QryString = MSG=AUTCOLETA;PLACA=EQP8103;VIG=01/10/2012;
                           sp_processa_AUTCOLETA(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                      /* INICIO DO BLOCO DE LIBERAR O VALE DE FRETE PARA SER PAGO NO CHEQUE   *** JONATAS VELOSO 02/01/2019 ***/
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'LIBCHEQUE') then
                        --Exemplo de QryString = MSG=LIBCHEQUE;NUMERO=888888;SERIE=A1;ROTA=011;SAQUE=1;
                           sp_altera_pagamentoparacheque(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                     
                     /* INICIO DO BLOCO PARA REABRIR O VEÍCULO DO COLETOR *** JONATAS VELOSO 19/01/2019 ***/
                     Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'REABREPLACA') then
                     --Exemplo de QryString = MSG=REABREPLACA;PLACA=SLT0001;
                        sp_arm_reabrirplacamobile(tpBenasserec,vStatus,vMessage);
                        vAchouTarefa := 'S'; 

                      /* INICO DO BLOCO PARA EXCLUIR LANAMENTOS DUPLICADOS DO CTF */
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'EXCTFDUP') then
                        --Exemplo de QryString = MSG=EXCTFDUP;CODCTF=85229022;ACERTO=45555802;FROTA=2062;
                           sp_processa_EXCTFDUP(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S';                   
                           
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'VOLTACARREG') then
                        --Exemplo de QryString = MSG=VOLTACARREG;CARREGAMENTO=85229022;DESCARREGA=N;EXCLUINOTA=N;
                           sp_processa_VOLTACARREG(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S';                   
                           
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'LIMPASYNCHRO') then
                            --Exemplo de QryString = MSG=LIMPASYNCHRO;CLIENTE=S;ENDERECO=S;DOCUMENTOS=S;NOTAS=S;ASSOCIADOS=S
                           sp_processa_LimpaSynchro(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S';                   
                           
                      /* INICO DO BLOCO PARA ENVIAR TORPEDO */
                      Elsif (UPPER(Trim(tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';'))) = 'ET') then
                        --Exemplo de QryString = MSG=ET;PLACA=BKU1287;ASSUNTO=SHDHD HD H DHD;
                           sp_processa_ET(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                       /* LIBERA O SISTEMA PARA A ROTA */
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'HSMENU') then    
                        --Exemplo de QryString = MSG=HSMENU;SIST=CTEDIG;ROTA=033;USUARIO=

                       vAchouTarefa := 'S';
                       SPI_Set_SistemaRota( tpBenasserec, vStatus, vMessage);
                           
                      /* INICIO BLOCO DE EXCLUSAO DO FATURAMENTO VALE */
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'PETRANSXXX') then    
                        --Exemplo de QryString = MSG=PETRANSXXX;RETROAGE=0

                       vAchouTarefa := 'S';
    --                   SPI_RodaPetransXXX( tpBenasserec, vStatus, vMessage);

                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'DIVCARREG') then    
                        --Exemplo de QryString = MSG=DIVCARREG;CARREG=

                       vAchouTarefa := 'S';
                       SPI_RodaDivCarreg( tpBenasserec, vStatus, vMessage);

                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'JUNTACARREG') then    
                        --Exemplo de QryString = MSG=JUNTACARREG;CARREG=

                       vAchouTarefa := 'S';
                       SPI_RodaJuntaCarreg( tpBenasserec, vStatus, vMessage);

                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'BLQLIB') then    
                          --Exemplo de QryString = MSG=BLQLIB;ACAO=B;USU=jsantos;TPMOT=F;PLACA=BJU3443;CPF=06045040805;AVISO=Entrar em contato com Rastreamento (incidente);INICIO=26/06/2014;
                       vAchouTarefa := 'S';
                       spi_get_BloqueaLiberaMot( tpBenasserec, vStatus, vMessage);
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'HABOBS') then 
                        vAchouTarefa := 'S';
                        pkg_hd_utilitario.SP_HD_HABOBS(tpBenasserec.GLB_BENASSEREC_ASSUNTO, vStatus, vMessage);
    --               Exemplo MSG=TICKET&NOTA=4612&PESO=26070&VALOR=5598,27&NMAE=0023&SERIEMAE=0&CHAVEMAE=3242343423434344343&EMITENTE=33592510007590&REMETENTE=99999948004206
    --               MSG=TICKET&NOTA=4612&PESO=26070&VALOR=5598,27&NMAE=0023&EMITENTE=33592510007590&REMETENTE=99999948004206
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'TICKET') then 
                        vAchouTarefa := 'S';
                        spi_processa_NOTATCN(tpBenasserec, vStatus, vMessage);

--       Exemplo MSG=NIQUEL;CODIGOBARRA=15170933592510007590550020000157331889371401;KM=1334;PEDIDO=123456778;PEDIDOVZ=23323345;RETORNOVAZIO=S
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'NIQUEL') then 
                        vAchouTarefa := 'S';
                        spi_processa_NOTANIQUEL(tpBenasserec, vStatus, vMessage);
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'CONFCOMPROV') then 
                        vAchouTarefa := 'S';
                        SPI_ConfirmaComprovante(tpBenasserec, vStatus, vMessage);
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'REENVIARPS') then 
                        vAchouTarefa := 'S';
                        tdvadm.pkg_hd_utilitario.sp_reenviarps(tpBenasserec.Glb_Benasserec_Assunto, vStatus, vMessage);
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'CADTARIFA') then 
                        vAchouTarefa := 'S';
                        tdvadm.pkg_hd_utilitario.SP_RJR_CADTARIFA(tpBenasserec.Glb_Benasserec_Assunto, vStatus, vMessage);
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'ALTCABRITO') then 
                        vAchouTarefa := 'S';
                        tdvadm.pkg_hd_utilitario.SP_HD_ALTCABRITO(tpBenasserec.Glb_Benasserec_Assunto, vStatus, vMessage);
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'SETMCADDRESS') then 
                        vAchouTarefa := 'S';
                        tdvadm.pkg_hd_utilitario.SP_INT_UpdateMacAddress(tpBenasserec.Glb_Benasserec_Assunto, vStatus, vMessage);
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'ALTCAIXA') then 
                        wservice.pkg_glb_email.SP_ENVIAEMAIL('NOTIFICAÇÃO DE ALTERAÇÃO DE CAIXA',
                                                              tpBenasserec.GLB_BENASSEREC_ASSUNTO,
                                                              'aut-e@dellavolpe.com.br',
                                                              trim(tpBenasserec.glb_benasserec_origem),
                                                              'ltarcha@dellavolpe.com.br');
                        vAchouTarefa := 'S';
                        tdvadm.pkg_hd_utilitario.sp_cax_trocacaixafeletroAute(tpBenasserec.Glb_Benasserec_Assunto, vStatus, vMessage);
                     --Exemplo de QryString = MSG=ALTCAIXA;DOCUMENTO=000000;SERIE=A1;ROTA=023;SAQUE=1;NOVAROTA=055;DATA=10/02/2015;
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'PRODEB') then 
                        vAchouTarefa := 'S';
                        spi_get_ProrrogarDebito(tpBenasserec, vStatus, vMessage);
                     -- MSG=PROCESSASAP;ACAO=CRIA;PROTOCOLO=764535;LIMITE=31/01/2015
                     -- MSG=PROCESSASAP;ACAO=BAIXA;PROTOCOLO=764535;LIMITE=31/01/2015
                     -- MSG=PROCESSASAP;ACAO=TUDO;PROTOCOLO=764535;LIMITE=31/01/2015
                     Elsif (tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'PROCESSASAP') then 
                        vAchouTarefa := 'S';
                        if tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'ACAO','=',';') = 'CRIA' Then
                           spi_CriaFaturaConciliada(tpBenasserec, vStatus, vMessage);
                        ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'ACAO','=',';') = 'BAIXA' Then
                           spi_BaixaTitulosConciliada(tpBenasserec, vStatus, vMessage);
                        ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'ACAO','=',';') = 'TUDO' Then
                           spi_CriaFaturaConciliada(tpBenasserec, vStatus, vMessage);
                           if vStatus = pkg_glb_common.Status_Nomal Then
                              spi_BaixaTitulosConciliada(tpBenasserec, vStatus, vMessage);
                           End If;
                        Else
                           vAchouTarefa := 'N';
                        End If;
                        if vStatus <> pkg_glb_common.Status_Nomal Then
                          tpBenasserec.Glb_Benasserec_Status     := 'ER';
                          tpBenasserec.Glb_Benasserec_Processado := sysdate;
                        End If;  
                     -- MSG=VERIFICACC;PROTOCOLO=243544;SEQUENCIA=1 
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'VERIFICACC' Then  
                           vAchouTarefa := 'S';                       
                           spi_informaCartaAutorizada(tpBenasserec, vStatus, vMessage);
                     -- MSG=AUTFAT;PROT=70293
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'AUTFAT' Then  
                           
                           vAchouTarefa := 'S';                       
                           spi_ExecutaAutFat(tpBenasserec, vStatus, vMessage);
                     
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'TRANSFVF' Then  
                           
                           vAchouTarefa := 'S';                       
                           PKG_HD_UTILITARIO.SP_SET_EmbTransferencia2(tpBenasserec.Glb_Benasserec_Assunto,vStatus,vMessage);

                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'LISTNOTA' Then  
                           
                           vAchouTarefa := 'S';     
                            spi_confirmanotasembarcadas(tpBenasserec, vStatus, vMessage);                  

                     --       Exemplo MSG=DELNOTA;NOTA=4612;SERIE=001;REMETENTE=33592510007590
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'DELNOTA' Then  
                           
                           vAchouTarefa := 'S';     
                           spi_processa_DELETANOTA(tpBenasserec, vStatus, vMessage);

                     --      Exemplo de QryString = MSG=INCMOTORISTA;MATRICULA=1243
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'INCMOTORISTA' Then  

                           vAchouTarefa := 'S';     
                           SPi_INC_MOTORISTA(tpBenasserec, vStatus, vMessage);

                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'LIBCOMPROV' Then  
                     
                           vAchouTarefa := 'S';   


                     -- MSG=PROCINCTAB;PROTOCOLO=503172                         
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'PROCINCTAB' Then

                           vAchouTarefa := 'S';   
                           
                                 -----NOVO PROCESSO DE SUBIR TABELA - RAFAEL AITI e SIRLANO DRUMOND 10/05/2019---------
                          
                          select tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'PROTOCOLO','=',';')
                            into protoc
                            from rmadm.t_glb_benasserec b
                           where b.glb_benasserec_chave = tpbenasserec.glb_benasserec_chave
                             and rownum = 1;
                           
                           select br.glb_benasserec_fileanexo
                             into Arqcsv
                             from rmadm.t_glb_benasserec br
                            where br.glb_benasserec_chave = protoc
                              and lower (br.glb_benasserec_fileanexo) like '%.csv%'
                              and rownum = 1;
                           
                          tdvadm.sp_TABFRETE_Criandotabelas(Arqcsv,
                                                           vStatus,
                                                           vMessage);
                                                                                   
                          if vStatus = 'N' then
                            
                          tdvadm.sp_tabfretecriandovalores(Arqcsv,
                                                           vStatus,
                                                           vMessage);
                          
                          end if;
                          
                          if vStatus = 'N' then                                                   
                                                     
                                wservice.pkg_glb_email.SP_ENVIAEMAIL('TABELA SUBIU COM SUCESSO' ||'-'|| tpbenasserec.glb_benasserec_origem,
                                           vMessage,
                                           'aut-e@dellavolpe.com.br',
                                           tpbenasserec.glb_benasserec_origem,
                                           'sdrumond@dellavolpe.com.br');
                          
                          end if;
                                                                     
                    /*      tdvadm.pkg_slf_tabelas.sp_CriaAtulizaTabela(tdvadm.fn_querystring(tpBenasserec.GLB_BENASSEREC_ASSUNTO,'PROTOCOLO','=',';'),
                                                                       vStatus, 
                                                                       vMessage);*/
                                                                       
                           -- F e para informar que chegou no final do processo
                           If vStatus = 'F' Then
                               tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                               tpBenasserec.Glb_Benasserec_Status     := 'OK';
                               tpBenasserec.Glb_Benasserec_Obs        := vMessage;
                           End If;

                     --Exemplo de QryString = MSG=DESESOCIAL;CPF=12345678901
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'DESESOCIAL' Then
                           vAchouTarefa := 'S';   
                           spi_CAR_TIRABLOQUEIO(tpBenasserec,
                                                vStatus, 
                                                vMessage);

                     --Exemplo de QryString = MSG=DTPEDIDO;COLETA=999999;DT=12345678901;PEDIDO=55433445
                     ElsIf tdvadm.fn_querystring(upper(tpBenasserec.GLB_BENASSEREC_ASSUNTO),'MSG','=',';') = 'DTPEDIDO' Then
                           vAchouTarefa := 'S';   
                           spi_ARM_DTPEDIDO(tpBenasserec,
                                            vStatus, 
                                            vMessage);

                     End if;
                      
                     if MSGORIGEM = 'CT' then
                          sp_processa_TORPEDO(tpBenasserec,vStatus,vMessage);
                           vAchouTarefa := 'S'; 
                           tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                           tpBenasserec.Glb_Benasserec_Status     := 'OK';
                     End if;
                      
                      if vAchouTarefa = 'N' then
                         if vAnexo = 'N' Then
                            -- volta ele para não autorizado caso não encontre outro porcesso
                            tpplanilhaaut.edi_planilhaaut_permiteanexo := 'N';
                            tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                            tpBenasserec.Glb_Benasserec_Status     := 'ER';
                         Else
                            If tpplanilhaaut.edi_planilhaaut_permiteanexo = 'N' Then   
                             tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                             tpBenasserec.Glb_Benasserec_Status     := 'ER';
                            End If;
                         End if;   
                      Else
                         if tpBenasserec.Glb_Benasserec_Status <> 'ER' Then
                            tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                            IF tpBenasserec.Glb_Benasserec_Status <> 'LB' Then
                               tpBenasserec.Glb_Benasserec_Status     := 'OK';
                            End If;   
                         End if;
                      End If;
                  Elsif vAnexo = 'A' Then -- Se no Anexo veio com acento
                      tpBenasserec.Glb_Benasserec_Status     := 'ER';
                      tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                  End If;
                  -- trata a resposta
                  if MSGORIGEM = 'EM' then

                    begin
                      

                      SP_Verifica_MsgRetorno(tpBenasserec,
                                             vAnexo,
                                             tpplanilhaaut.edi_planilhaaut_permiteanexo,
                                             tpplanilhaaut.edi_planilhaaut_autoriza,
                                             vExesso,
                                             vEnviadosCA,
                                             tpplanilhaaut.edi_planilhaaut_limitdiario,
                                             MsgRet);
                                         
                              
    --                  if trim(vMessage) <> '' Then
                         MsgRet :=  MsgRet || chr(10) || chr(10) ||
                                    '**********************************************************************' || chr(10) ||
                                    vMessage || chr(10) ||
                                    '**********************************************************************' || chr(10);
    --                  End if;  

                        if vAnexo = 'S' Then           
                           if (tpBenasserec.Glb_Benasserec_Status Not In ('AP')) then 
                              wservice.pkg_glb_email.SP_ENVIAEMAIL('RESPOSTA AUTOMATICO MACROS POR EMAIL',
                                                                   MsgRet,
                                                                   'aut-e@dellavolpe.com.br',
                                                                   trim(tpBenasserec.glb_benasserec_origem));
                           End If;                                     
                           if  ( tpBenasserec.Glb_Benasserec_Status Not In ('ER', 'OK','AP') ) then
                              tpBenasserec.Glb_Benasserec_Processado := Null;
                              tpBenasserec.Glb_Benasserec_Status     := 'AG';
                           End if;
                        End If;  
                    exception
                      when OTHERS Then
                        SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSEREC','N');
                        SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIM',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
                        MsgRet := 'Processo ' || tpBenasserec.Glb_Benasserec_Assunto || ' Codigo ' || tpBenasserec.Glb_Benasserec_Chave || chr(10) ;
                        MsgRet := MsgRet || ' - erroora - ' || SQLERRM || chr(10);
                        wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO NO ENVIO DO EMAIL',
                                                             MsgRet,
                                                             'aut-e@dellavolpe.com.br',
                                                             'sdrumond@dellavolpe.com.br');
                        tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                        tpBenasserec.Glb_Benasserec_Status     := 'IN';
                            
                    end;
                        
                    
                        
                  end if;
                      
                Exception
                  When Others Then
                    SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSEREC','N');
                    SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIM',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
                    if sqlcode <>  -29278 then
                       MsgRet := 'PKG_EDI_CONTROLE : ' || chr(10) ||
                                                         ' Enviado por ' || tpBenasserec.Glb_Benasserec_Origem || chr(10) ||
                                                         ' Assunto ' || chr(10) || tpBenasserec.Glb_Benasserec_Assunto || chr(10) ||
                                                         ' VERIFIQUE O ERRO ' || chr(10) ||
                                                         Sqlerrm || chr(10);
                    wservice.pkg_glb_email.SP_ENVIAEMAIL('RESPOSTA AUTOMATICO ERRO NO PROCESSAMENTO',
                                                         MsgRet,
                                                         'aut-e@dellavolpe.com.br',
                                                         tpBenasserec.Glb_Benasserec_Origem,
                                                         'sdrumond@dellavolpe.com.br');
                        tpBenasserec.Glb_Benasserec_Processado := Sysdate;
                        tpBenasserec.Glb_Benasserec_Status     := 'ER';
                        tpBenasserec.Glb_Benasserec_Obs        := MsgRet;
                    Else
                       update rmadm.t_glb_benasserec br
                          set br.glb_benasserec_processado = tpBenasserec.Glb_Benasserec_Processado,
                              br.glb_benasserec_status     = 'CT',
                              br.glb_benasserec_obs = MsgRet
                       where br.glb_benasserec_chave = tpBenasserec.glb_benasserec_chave;
                       commit;
                          
                    End if;    
                End;

               tpBenasserec.Glb_Benasserec_Obs        := MsgRet;  
               
               update rmadm.t_glb_benasserec br
                  set br.glb_benasserec_processado = tpBenasserec.Glb_Benasserec_Processado,
                      br.glb_benasserec_status     = tpBenasserec.Glb_Benasserec_Status,
                      br.glb_benasserec_obs        = tpBenasserec.Glb_Benasserec_Obs
               where br.glb_benasserec_chave       = tpBenasserec.glb_benasserec_chave;
               
               commit;
             exception
               When OTHERS Then
                 
                  wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO RODANDO BENSSSE REC',
                                                       'Chave ' || tpBenasserec.glb_benasserec_chave ||
                                                       'Erro ' || sqlerrm,
                                                       'aut-e@dellavolpe.com.br',
                                                       'grp.hd@dellavolpe.com.br',
                                                       'sdrumond@dellavolpe.com.br');

               End;
          end loop;
          Close c_linhas;

   End sp_bi_glb_processa;
   

   Procedure SP_BI_GLB_BENASSEREC as

/*
      vContador     Number; -- auxiliar contador
      MSGORIGEM     rmadm.T_GLB_BENASSEMSG.GLB_BENASSEMSG_ORIGEM%TYPE; -- se veio por email ou torpedo
      vAnexo        char(1); -- se existe anexo na mensagem
      vExesso       Char(1); -- se houve excesso no recebimento de msg com anexo
      
      vEnviadosCA   Number; -- quatidade de emails ja enviados
--      vAutorizado   CHAR(1); -- se o recebimento de anexo esta autorizado
      MsgRet        clob; -- Texto da mensagem de retorno
      vStatus       char(01);
      vMessage      clob;
      tpBenasserec  rmadm.t_glb_benasserec%rowtype;  
      tpplanilhaaut tdvadm.t_edi_planilhaaut%rowtype;
      vAchouTarefa  char(1);      
*/      

      vProcesso     char(1);
      
      vSql          varchar2(1000);



    begin
          
          vSql := 'Select *
                   From rmadm.t_glb_benasserec b
                   Where b.glb_benasserec_status in (''IN'',''AP'')
                     and b.glb_benasserec_processado is null
                     and NVL(b.glb_benasserec_assunto,''X'') not like ''MSG=NIQUEL%''
                     and NVL(b.glb_benasserec_assunto,''X'') not like ''MSG=TICKET%''
                   Order by b.glb_benasserec_chave';

          vProcesso := SYS_CONTEXT('PROCESSOUNICO','SP_BI_GLB_BENASSEREC') ;
          -- se ja estiver rodando não deixa rodar novamente
          If vProcesso = 'S' Then
             Return;
          End If;    

       -- tratamento de erro diverso
       -- para voltar o contexto para N
       begin
          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSEREC','S');
          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECINI',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));

          sp_bi_glb_processa(vSql);

      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSEREC','N');
      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIM',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));

    exception
      when OTHERS then
         SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSEREC','N');
         SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIM',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
         wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO RODANDO BENSSSE REC',
--                                              'Chave ' || tpBenasserec.glb_benasserec_chave ||
                                              'Erro ' || sqlerrm,
                                              'tdv.producao@dellavolpe.com.br',
                                              'grp.hd@dellavolpe.com.br');
      end ;

    end SP_BI_GLB_BENASSEREC;


   Procedure SP_BI_GLB_BENASSERECNIQUEL as

      vProcesso     char(1);
      vSql          varchar2(1000);
      
    begin
          
          vSql := 'Select *
                   From rmadm.t_glb_benasserec b
                   Where b.glb_benasserec_status in (''IN'')
                     and NVL(b.glb_benasserec_assunto,''X'') like ''MSG=NIQUEL%''
                     and b.glb_benasserec_processado is null
                   Order by b.glb_benasserec_chave';        

          vProcesso := SYS_CONTEXT('PROCESSOUNICO','SP_BI_GLB_BENASSERECNIQUEL') ;
          -- se ja estiver rodando não deixa rodar novamente
          If vProcesso = 'S' Then
             Return;
          End If;    

       -- tratamento de erro diverso
       -- para voltar o contexto para N
       begin
          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECNIQUEL','S');
          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECININIQUEL',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));

          sp_bi_glb_processa(vSql);

          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECNIQUEL','N');
          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIMNIQUEL',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));

    exception
      when OTHERS then
         SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECNIQUEL','N');
         SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIMNIQUEL',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
         wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO RODANDO BENSSSE REC',
--                                              'Chave ' || tpBenasserec.glb_benasserec_chave ||
                                              'Erro ' || sqlerrm,
                                              'tdv.producao@dellavolpe.com.br',
                                              'grp.hd@dellavolpe.com.br');
      end ;

    end SP_BI_GLB_BENASSERECNIQUEL;


   Procedure SP_BI_GLB_BENASSERECCARVAO as


      vProcesso     char(1);
      vSql          varchar2(1000);
      
    begin

        vSql := 'Select *
                 From rmadm.t_glb_benasserec b
                 Where b.glb_benasserec_status in (''IN'')
                   and b.glb_benasserec_processado is null
                   and NVL(b.glb_benasserec_assunto,''X'') like ''MSG=TICKET%''
                 Order by b.glb_benasserec_chave';
          
          vProcesso := SYS_CONTEXT('PROCESSOUNICO','SP_BI_GLB_BENASSERECCARVAO') ;
          -- se ja estiver rodando não deixa rodar novamente
          If vProcesso = 'S' Then
             Return;
          End If;    

       -- tratamento de erro diverso
       -- para voltar o contexto para N
       begin
          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECCARVAO','S');
          SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECINICARVAO',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));

          sp_bi_glb_processa(vSql);

      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECCARVAO','N');
      SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIMCARVAO',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));

    exception
      when OTHERS then
         SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECCARVAO','N');
         SYSTEM.pkg_glb_context.sp_set_vlr_PROCESSOUNICO('SP_BI_GLB_BENASSERECFIMCARVAO',TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'));
         wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO RODANDO BENSSSE REC',
--                                              'Chave ' || tpBenasserec.glb_benasserec_chave ||
                                              'Erro ' || sqlerrm,
                                              'tdv.producao@dellavolpe.com.br',
                                              'grp.hd@dellavolpe.com.br');
      end ;

    end SP_BI_GLB_BENASSERECCARVAO;



END PKG_EDI_CONTROLE;
/
