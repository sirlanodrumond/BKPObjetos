CREATE OR REPLACE PACKAGE PKG_GLB_PCL IS
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

  c_VersaoFatura        CONSTANT VARCHAR2(20) := '13.11.18.0';
  c_VersaoValeFrete     CONSTANT VARCHAR2(20) := '18.8.3.0';   --'13.11.18.0';
  c_VersaoDiarioBordo   CONSTANT VARCHAR2(20) := '13.12.23.0'; --'13.11.25.0';
  c_VersaoRotograma     CONSTANT VARCHAR2(20) := '13.11.18.0';
  c_VersaoMarcaDagua    CONSTANT VARCHAR2(20) := '13.11.18.0';
  c_VersaoGerColeta     CONSTANT VARCHAR2(20) := '17.1.16.1';



 
 /* Typo utilizado como base para utilização dos Paramentros                                                                 */
  TYPE TpEstruturaCTRCFatrua IS RECORD (DIA         char(5),
                                        CTRC        tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                        SERIE       tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                        ROTA        tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                        NOTA        TDVADM.T_con_nftransporta.CON_NFTRANSPORTADA_NUMNFISCAL%type,
                                        REMETENTE   TDVADM.T_con_nftransporta.GLB_CLIENTE_CGCCPFCODIGO%type,
                                        PesoNota    TDVADM.T_con_nftransporta.CON_NFTRANSPORTADA_PESO%type,    
                                        ValorNota   TDVADM.T_con_nftransporta.CON_NFTRANSPORTADA_VALOR%type);

  TYPE TabCTRCFatura IS TABLE OF TpEstruturaCTRCFatrua INDEX BY BINARY_INTEGER; 


  TYPE TpEstruturaVerbas IS RECORD (Qtde      NUMBER,
                                    Verba     tdvadm.t_slf_reccust.slf_reccust_descricao%type,
                                    Valor     NUMBER);

  TYPE TabVerbas IS TABLE OF TpEstruturaVerbas INDEX BY BINARY_INTEGER; 




  -- Variavel Globais para rodar a procedure
  vXmlIn              varchar2(32000);
  vListaDados         glbadm.pkg_listas.tContainerPCL;
  vStatus             char(1);
  vMessage            varchar2(20000);

   
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

  procedure  SP_GLB_RETORNAPCL(P_XMLIN    In VARCHAR2,
                               P_ARQOUTT  in Out Clob,
                               P_ARQOUTB  Out Blob,
                               P_STATUS   OUT CHAR,
                               P_MESSAGE  OUT VARCHAR2);

  /*************************************************************************
  /* Fabiano Góes: 15/08/2013
  /* Criei este overload porque estava tendo problema no Delphi com 
  /* parametro Out BLOB, então executo a procedure depois faço
  /* select na tabela "tdvadm.t_glb_pcl" pra obter a mascara
  /*************************************************************************/                                    
  procedure  SP_GLB_RETORNAPCL_SEMMASC(P_XMLIN    In VARCHAR2,
                                       P_ARQOUTT  Out Clob,
                                       P_STATUS   OUT CHAR,
                                       P_MESSAGE  OUT VARCHAR2);

  procedure  SP_GLB_RETORNAPCL_SOMASC(P_XMLIN    In VARCHAR2,
                                        P_ARQOUTT  Out blob,
                                        P_STATUS   OUT CHAR,
                                        P_MESSAGE  OUT VARCHAR2);
                                      
  procedure  SP_RETDADODIARIOBORD(P_XMLIN      In  VARCHAR2,
                                  P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                                  P_STATUS     OUT CHAR,
                                  P_MESSAGE    OUT VARCHAR2);
                                   
  procedure  SP_RETDADOFATURA(P_XMLIN   In VARCHAR2,
                              P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                              P_STATUS  OUT CHAR,
                              P_MESSAGE OUT VARCHAR2);

  procedure  SP_RETDADOVALEFRETE(P_XMLIN      In  VARCHAR2,
                                 P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                                 P_STATUS     OUT CHAR,
                                 P_MESSAGE    OUT VARCHAR2);
  
  procedure SP_RETDADOGERCOLETA(P_XMLIN      In  VARCHAR2,
                                P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                                P_STATUS     OUT CHAR,
                                P_MESSAGE    OUT VARCHAR2);
  
  procedure SP_RETDADOCOLETA(P_XMLIN      In  VARCHAR2,
                             P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                             P_STATUS     OUT CHAR,
                             P_MESSAGE    OUT VARCHAR2);
                              

END PKG_GLB_PCL;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_GLB_PCL AS


 vRegua              char(400) := '*********1*********2*********3*********4*********5*********6*********7*********8*********9*********0*********1*********2*********3*********4*********5*********6*********7*********8*********9*********0*********1*********2*********3*********4*********5*********6*********7*********8*********9*********0*********1*********2*********3*********4*********5*********6*********7*********8*********9*********0';


  procedure  SP_RETDADODIARIOBORD(P_XMLIN      In  VARCHAR2,
                                  P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                                  P_STATUS     OUT CHAR,
                                  P_MESSAGE    OUT VARCHAR2)
  As
     plistaparams glbadm.pkg_listas.tlistausuparametros;
     vCodigo             tdvadm.t_con_valefrete.con_conhecimento_codigo%type;
     vSerie              tdvadm.t_con_valefrete.con_conhecimento_serie%type; 
     vRota               tdvadm.t_con_valefrete.glb_rota_codigo%type;
     vSaque              tdvadm.t_con_valefrete.con_valefrete_saque%type;
     vPclCodigo          tdvadm.t_glb_pcl.glb_pcl_codigo%type;
     vPclVersao          tdvadm.t_glb_pcl.glb_pcl_versao%type;
     tpLinhaValeFrete    tdvadm.t_con_valefrete%rowtype;
     i                   number;
     vFonteDefault       tdvadm.t_glb_pcl.glb_pcl_fonteform%type;
     vUsuarioTDV         char(10);
     vRotaUsuarioTDV     char(3);
     vAplicacaoTDV       char(10);
     vKm                 NUMBER;
     vDias               number;
     vKmPorDia           number;
     vPaginas            number;
     vDtInicial          Date := trunc(sysdate);
     vDtFinal            Date;
     vIdBarra            varchar2(47);
  Begin

   vCodigo             := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Codigo' ));
   vSerie              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Serie' ));
   vRota               := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Rota' ));
   vSaque              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Saque' ));
   vUsuarioTDV         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'UsuarioTDV' ));
   vRotaUsuarioTDV     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'RotaUsuarioTDV' ));
   vAplicacaoTDV       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Aplicacao' ));
   vPclCodigo          := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'PCL' ));
   vPclVersao          := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'PCLVersao' ));
   
   insert into dropme (a,l) values ('teste_Lucas',P_XMLIN); commit;
   
   if nvl(vPclCodigo,'S') = 'S' then
     vPclCodigo := 'DIARIOBORD';
   End If;
   if nvl(vPclVersao,'S') = 'S' Then
     vPclVersao := c_VersaoDiarioBordo;
   End if;
   


   P_LISTADADOS.delete; 
   P_STATUS :=  pkg_glb_common.Status_Nomal;
   P_MESSAGE := '';
   
  if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacaoTDV,
                                               vusuarioTDV,
                                               vRotaUsuarioTDV,
                                               plistaparams) Then
                                    
     P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
     P_MESSAGE := P_MESSAGE || '00 - Erro ao Buscar Parametros.' || chr(10);
  End if ;      
  
       Begin
          vKmPorDia := nvl(plistaparams('KMPRODIADB').NUMERICO1,0);
       exception
         when NO_DATA_FOUND Then
           vKmPorDia := 400;
         end;                           

       Select *
         into tpLinhaValeFrete
       From t_con_valefrete v
       where v.con_conhecimento_codigo = vCodigo
         and v.con_conhecimento_serie  = vSerie
         and v.glb_rota_codigo         = vRota
         and v.con_valefrete_saque     = vSaque;
        
        vDtInicial := trunc(tpLinhaValeFrete.Con_Valefrete_Datacadastro);
        vDtFinal   := f_diautil_proximo(trunc(tpLinhaValeFrete.Con_Valefrete_Dataprazomax));
        
       
         BEGIN
          SELECT Nvl(P.SLF_PERCURSO_KMTDV,0)
             INTO vKm
          FROM T_SLF_PERCURSO P
          WHERE P.GLB_LOCALIDADE_CODIGOORIGEM = tpLinhaValeFrete.Glb_Localidade_Codigoori
            AND P.GLB_LOCALIDADE_CODIGODESTINO = tpLinhaValeFrete.Glb_Localidade_Codigodes;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
               vKm := tpLinhaValeFrete.Con_Valefrete_Kmprevista;
           END ;   
            
           -- arredonda para cima e soma um dia
           
           vDias := round((vKm / vKmPorDia) + 1.5);
           if vDias < (vDtFinal - vDtInicial) Then
              vDias := (vDtFinal - vDtInicial);
           End If;   
             
           vPaginas := round((vDias / 4) + 0.5);

        if vPaginas > 4 Then
           P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
           P_MESSAGE := P_MESSAGE || '01 - Periodo da Viagem Supera 16 dias. Datas Inicial ' || vDtInicial || ' até ' || vDtFinal  || chr(10);
          
        End If;
          
      if P_STATUS <> PKG_GLB_COMMON.Status_Erro  Then


       Begin
       Select pcl.glb_pcl_fonteform
         into vFonteDefault
       from t_glb_pcl pcl
       where pcl.glb_pcl_codigo = vPclCodigo
         and pcl.glb_pcl_versao = vPclVersao;
       Exception
         when NO_DATA_FOUND Then 
            P_STATUS :=  pkg_glb_common.Status_Erro;
            P_MESSAGE := P_MESSAGE || 'Verifique a Versão do PCL ' || vPclCodigo || '-' || vPclVersao || chr(10) ;
         End;    
       i:= 1; -- quantidade de Paginas
       loop

            P_LISTADADOS(i).Pcl := vPclCodigo;
            P_LISTADADOS(i).Versao := vPclVersao;
            P_LISTADADOS(i).Sequencia := 1;
            P_LISTADADOS(i).Fonte  := vFonteDefault;
            vIdBarra := '004' || trim(vCodigo) || trim(substr(vSerie,2,1)) || trim(vRota) || trim(vSaque) || trim(lpad(i,2,'0')) || trim(lpad(vPaginas,2,'0')) ;
            P_LISTADADOS(i).linha('TITULO')  := 'DIARIO DE BORDO DA DELLA VOLPE';
            P_LISTADADOS(i).linha('NRDIARIO') := vIdBarra;
            P_LISTADADOS(i).linha('ORIGEMDESTINO') := 'ORIGEM - DESTINO - ' || TRIM(tpLinhaValeFrete.Con_Valefrete_Localcarreg)  || ' - ' || TRIM(tpLinhaValeFrete.Con_Valefrete_Localdescarga);
            P_LISTADADOS(i).linha('MOTORISTA') := NULL;  
            for vPropVeicMot in (SELECT P.CAR_PROPRIETARIO_CGCCPFCODIGO CNPJCPFPROP,
                                        P.CAR_PROPRIETARIO_RAZAOSOCIAL PROPRIETARIO,
                                        TRIM(P.CAR_PROPRIETARIO_RNTRC) || ' - VALIDADE - ' || TO_CHAR(P.CAR_PROPRIETARIO_RNTRCDTVAL,'DD/MM/YYYY') || ' - TP - ' || P.CAR_PROPRIETARIO_CLASSANTT RNTRC,
                                        V.CAR_VEICULO_PLACA PLACA,
                                        V.CAR_VEICULO_SAQUE SAQUE,
                                        V.CAR_VEICULO_ANOFABRIC ANO,
                                        MT.CAR_CARRETEIRO_CPFCODIGO CPFMOT,
                                        MT.CAR_CARRETEIRO_NOME MOTORISTA,
                                        DECODE(LENGTH(TRIM(P.CAR_PROPRIETARIO_CGCCPFCODIGO)),11,'CPF','CNPJ') TPPROP
                                 FROM T_CON_VALEFRETE VF,
                                      T_CAR_CARRETEIRO MT,
                                      T_CAR_PROPRIETARIO P,
                                      T_CAR_VEICULO V
                                 WHERE 0 = 0
                                   AND VF.CON_CONHECIMENTO_CODIGO = vCodigo --'016959'
                                   AND VF.CON_CONHECIMENTO_SERIE  = vSerie  -- 'A1'
                                   AND VF.GLB_ROTA_CODIGO         = vRota   -- '196'
                                   AND VF.CON_VALEFRETE_SAQUE     = vSaque  -- '1'
                                   AND VF.CON_VALEFRETE_PLACA          = V.CAR_VEICULO_PLACA (+)
                                   AND VF.CON_VALEFRETE_PLACASAQUE     = V.CAR_VEICULO_SAQUE (+)
                                   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO = P.CAR_PROPRIETARIO_CGCCPFCODIGO (+)
                                   AND VF.CON_VALEFRETE_CARRETEIRO     = MT.CAR_CARRETEIRO_CPFCODIGO (+)
                                   AND VF.CON_VALEFRETE_PLACA          = MT.CAR_VEICULO_PLACA (+)
                                   AND VF.CON_VALEFRETE_PLACASAQUE     = MT.CAR_VEICULO_SAQUE (+)
                                   AND MT.CAR_CARRETEIRO_SAQUE     = (SELECT MAX(MT1.CAR_CARRETEIRO_SAQUE)
                                                                      FROM T_CAR_CARRETEIRO MT1
                                                                      WHERE MT1.CAR_CARRETEIRO_CPFCODIGO = MT.CAR_CARRETEIRO_CPFCODIGO
                                                                        AND MT1.CAR_VEICULO_PLACA        = MT.CAR_VEICULO_PLACA
                                                                        AND MT1.CAR_VEICULO_SAQUE        = MT.CAR_VEICULO_SAQUE)
                                )
                      loop
                         P_LISTADADOS(i).linha('MOTORISTA') := 'MOTORISTA - ' || vPropVeicMot.Motorista;
                         P_LISTADADOS(i).linha('CPFMOT') := f_mascara_cgccpf(trim(vPropVeicMot.CPFMOT));
                         P_LISTADADOS(i).linha('PLACA') := 'PLACA - ' || vPropVeicMot.Placa;
                         P_LISTADADOS(i).linha('CATEGORIA') := 'CATEGORIA - ' || fn_rettp_motorista(vPropVeicMot.Placa,vPropVeicMot.Saque,tpLinhaValeFrete.Con_Valefrete_Datacadastro);
                      End loop;
                      
                      if P_LISTADADOS(i).linha('MOTORISTA') IS null Then
                          for vPropVeicMot in (SELECT '61139432000172' CNPJPROP,
                                                      'TRANSPORTES DELLA VOLPE' PROPRIETARIO,
                                                      V.FRT_VEICULO_PLACA PLACA,
                                                      NULL SAQUE,
                                                      V.FRT_VEICULO_ANOFABRICACAO ANO,
                                                      M.FRT_MOTORISTA_CPF CPFMOT,
                                                      M.FRT_MOTORISTA_NOME MOTORISTA,
                                                      'CNPJ'  TPPROP
                                               FROM T_CON_VALEFRETE VF,
                                                    T_FRT_CONTENG CE,
                                                    T_FRT_MOTORISTA M,
                                                    T_FRT_VEICULO V
                                               WHERE 0 = 0
                                                 AND VF.CON_CONHECIMENTO_CODIGO = vCodigo --'016959'
                                                 AND VF.CON_CONHECIMENTO_SERIE  = vSerie  -- 'A1'
                                                 AND VF.GLB_ROTA_CODIGO         = vRota   -- '196'
                                                 AND VF.CON_VALEFRETE_SAQUE     = vSaque  -- '1'
                                                 AND VF.CON_VALEFRETE_PLACA     = CE.FRT_CONJVEICULO_CODIGO
                                                 AND CE.FRT_VEICULO_CODIGO      = V.FRT_VEICULO_CODIGO
                                                 AND VF.CON_VALEFRETE_CARRETEIRO = M.FRT_MOTORISTA_CPF
                                                 AND 1 = (SELECT COUNT(*)
                                                          FROM T_FRT_VEICULO V1,
                                                               T_FRT_MARMODVEIC MM,
                                                               T_FRT_TPVEICULO TV
                                                          WHERE V1.FRT_VEICULO_CODIGO = CE.FRT_VEICULO_CODIGO     
                                                            AND V1.FRT_MARMODVEIC_CODIGO = MM.FRT_MARMODVEIC_CODIGO
                                                            AND MM.FRT_TPVEICULO_CODIGO = TV.FRT_TPVEICULO_CODIGO
                                                            AND TV.FRT_TPVEICULO_TRACAO = 'S' ) )
                                    loop
                                        P_LISTADADOS(i).linha('MOTORISTA') := 'MOTORISTA - ' || vPropVeicMot.Motorista;
                                        P_LISTADADOS(i).linha('CPFMOT') := f_mascara_cgccpf(trim(vPropVeicMot.CPFMOT));
                                        P_LISTADADOS(i).linha('PLACA') := 'PLACA - ' || vPropVeicMot.Placa;
                                        P_LISTADADOS(i).linha('CATEGORIA') := 'CATEGORIA - ' || fn_rettp_motorista(vPropVeicMot.Placa,vPropVeicMot.Saque,tpLinhaValeFrete.Con_Valefrete_Datacadastro);
                                    End loop;
                      
                      End If;

            P_LISTADADOS(i).linha('CODBARRA') := glbadm.pkg_glb_codigodebarra2.Code128(trim(vIdBarra));
            P_LISTADADOS(i).linha('IDBARRA')  := trim(vIdBarra) || ' Emitido: ' || to_char(sysdate,'dd/mm/yyyy hh24:mi');
            P_LISTADADOS(i).linha('DATA1') := to_char(vDtInicial,'dd/mm/yyyy');
            vDtInicial := vDtInicial + 1;
            P_LISTADADOS(i).linha('DATA2') := to_char(vDtInicial,'dd/mm/yyyy');
            vDtInicial := vDtInicial + 1;
            P_LISTADADOS(i).linha('DATA3') := to_char(vDtInicial,'dd/mm/yyyy');
            vDtInicial := vDtInicial + 1;
            P_LISTADADOS(i).linha('DATA4') := to_char(vDtInicial,'dd/mm/yyyy');
            vDtInicial := vDtInicial + 1;
            P_LISTADADOS(i).linha('TEXTO1') := 'Durante esta viagem realizei tempo maximo de jornada de 8 horas diarias ?';
            P_LISTADADOS(i).linha('TEXTO2') := null;
            P_LISTADADOS(i).linha('TEXTO3') := 'Durante esta viagem realizei intervalo minimo de 1 hora entre jornadas ?';
            P_LISTADADOS(i).linha('TEXTO4') := '(O Descanso pode ser dividido em dois intervalos, sendo um de 9 horas e outro de 2 horas, desde que ambos sejam ininterruptos)';
            P_LISTADADOS(i).linha('TEXTO5') := null;
            P_LISTADADOS(i).linha('TEXTO6') := 'Durante esta viagem realizei sempre intervalos minimos de 30 minutos pra descanso a cada 4 horas ininterruptas na conduca do veiculo ?';
            -- inicio do verso
            P_LISTADADOS(i).linha('LINHA00') := 'COMUNICADO DE NOTIFICACAO';
            P_LISTADADOS(i).linha('LINHA01') := 'Motorista foi notificado ?';
            P_LISTADADOS(i).linha('LINHA02') := 'De  Acordo  com  a  Lei  12.619/12  a  repeticao';
            P_LISTADADOS(i).linha('LINHA03') := 'das   irregularidade    na    Jornada    diaria,';
            P_LISTADADOS(i).linha('LINHA04') := 'intervalos  e  descansos  ou  outra nao prevista';
            P_LISTADADOS(i).linha('LINHA05') := 'em  nosso  regulamento  interno  ira  contribuir';
            P_LISTADADOS(i).linha('LINHA06') := 'desfavoravelmente em seu progresso nesta empresa.';
            P_LISTADADOS(i).linha('LINHA07') := '';
            P_LISTADADOS(i).linha('LINHA08') := '';
            P_LISTADADOS(i).linha('LINHA09') := '';
            P_LISTADADOS(i).linha('LINHA10') := '_____________________________________';
            P_LISTADADOS(i).linha('LINHA11') := substr(P_LISTADADOS(i).linha('MOTORISTA'),13);
            P_LISTADADOS(i).linha('LINHA12') := 'CPF - ' || P_LISTADADOS(i).linha('CPFMOT');

--           i:= -1;  
           i := i + 1;
            if ( i = -1) or ( i > nvl(vPaginas,1) ) Then
              Exit;
            End if;  
        end loop;   
      End If;
  End SP_RETDADODIARIOBORD;                              




  procedure  SP_RETDADOFATURA(P_XMLIN   In VARCHAR2,
                              P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                              P_STATUS  OUT CHAR,
                              P_MESSAGE OUT VARCHAR2)
  As
     plistaparams glbadm.pkg_listas.tlistausuparametros;
     vCodigo             varchar2(20);
     vRota               varchar2(20);  
     vCiclo              varchar2(20);
     vCapa               char(1);
     tpLinhaFatura       tdvadm.t_con_fatura%rowtype;
     tpLinhaSacado       tdvadm.t_glb_cliente%rowtype;
     tpLinhaSacadoEndU   tdvadm.t_glb_cliend%rowtype;
     tpLinhaSacadoEndPP  tdvadm.t_glb_cliend%rowtype;
     tpLinhaCTRC         TabCTRCFatura;
     tpLinhaVerbas       TabVerbas;
     vPosAux             number;
     vContador           number;
     vContadorReg        number;
     i                   number;
     vLinhaCtrc          Number; 
     vTotPg              number;
     vCtrcAnterior       varchar2(20);
     vJaVez              char(1);
     vFonteDefault       tdvadm.t_glb_pcl.glb_pcl_fonteform%type;
     vReimpressao        char(1);
     vTaxaAd             number;
     vTaxaFrete          number;
     vTotalFat           number;
     vUsuarioTDV         char(10);
     vRotaUsuarioTDV     char(3);
     vAplicacaoTDV       char(10);

  Begin

   vCodigo             := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Codigo' ));
   vRota               := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Rota' ));
   vCiclo              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Ciclo' ));
   vCapa               := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Capa' ));
   vReimpressao        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Reimpressao'));
   vUsuarioTDV         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'UsuarioTDV' ));
   vRotaUsuarioTDV     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'RotaUsuarioTDV' ));
   vAplicacaoTDV       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Aplicacao' ));
   
   P_LISTADADOS.delete; 
   P_STATUS  :=  pkg_glb_common.Status_Nomal;
   P_MESSAGE := '';

  if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacaoTDV,
                                               vusuarioTDV,
                                               vRotaUsuarioTDV,
                                               plistaparams) Then
                                    
     P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
     P_MESSAGE := P_MESSAGE || '00 - Erro ao Buscar Parametros.' || chr(10);
  End if ;                                 
   
   begin
      pkg_con_fatura.SP_FAT_CONTATAXASNEW(vCodigo, vCiclo, vRota, vTaxaAd, vTaxaFrete);
   exception when others then
      vTaxaAd    := 0; 
      vTaxaFrete := 0;
   end;  

      begin
      if vCapa = 'N' Then  
       Select *
         into tpLinhaFatura
       From t_con_fatura f
       where f.con_fatura_codigo = vCodigo
         and f.con_fatura_ciclo  = vCiclo
         and f.glb_rota_codigofilialimp = vRota;
      Else
       Select CON_FATURAGRUPO_CODIGO        CON_FATURA_CODIGO,
              CON_FATURAGRUPO_CICLO         CON_FATURA_CICLO,
              GLB_ROTA_CODIGOFILIALIMP      GLB_ROTA_CODIGOFILIALIMP,
              GLB_CLIENTE_CGCCPFSACADO      GLB_CLIENTE_CGCCPFSACADO,
              CON_FATURAGRUPO_SERIE         CON_FATURA_SERIE,
              CON_FATURAGRUPO_DATAVENC      CON_FATURA_DATAVENC,
              CON_FATURAGRUPO_DATAPAGTO     CON_FATURA_DATAPAGTO,
              CON_FATURAGRUPO_DATAEMISSAO   CON_FATURA_DATAEMISSAO,
              CON_FATURAGRUPO_DATACANC      CON_FATURA_DATACANC,
              CON_FATURAGRUPO_VALORCOBRADO  CON_FATURA_VALORCOBRADO,
              CON_FATURAGRUPO_VALORRECEBIDO CON_FATURA_VALORRECEBIDO,
              CON_FATURAGRUPO_STATUS        CON_FATURA_STATUS,
              GLB_ROTA_CODIGO               GLB_ROTA_CODIGO,
              GLB_CONDPAG_CODIGO            GLB_CONDPAG_CODIGO,
              CON_FATURAGRUPO_EMISSOR       CON_FATURA_EMISSOR,
              CON_FATURAGRUPO_VENCCALC      CON_FATURA_VENCCALC,
              CON_FATURAGRUPO_CRIADOR       CON_FATURA_CRIADOR,
              CON_FATURAGRUPO_AUTORIZADOR   CON_FATURA_AUTORIZADOR,
              CON_FATURAGRUPO_DESCONTO      CON_FATURA_DESCONTO,
              CON_FATURAGRUPO_DTLIMTDESC    CON_FATURA_DTLIMTDESC,
              GLB_FORMAENVIO_CODIGO         GLB_FORMAENVIO_CODIGO,
              CON_FATURAGRUPO_DTENVIODOC    CON_FATURA_DTENVIODOC,
              CON_FATURAGRUPO_TPDESCONTO    CON_FATURA_TPDESCONTO,
              CON_FATURAGRUPO_OBSDESCONTO   CON_FATURA_OBSDESCONTO,
              CON_FATURAGRUPO_OBSCANC       CON_FATURA_OBSCANCELAMENTO,
              null                          CON_FATURA_REVERSAO,
              CON_FATURAGRUPO_DESCIMPOSTO   CON_FATURA_DESCIMPOSTO,
              USU_USUARIO_CODIGO            USU_USUARIO_CODIGO,
              null                          CON_FATURA_OBS,
              null                          CON_FATURA_CABECALHOFAT
           into tpLinhaFatura
       From t_con_faturagrupo f
       where f.con_faturagrupo_codigo = vCodigo
         and f.con_faturagrupo_ciclo  = vCiclo
         and f.glb_rota_codigofilialimp = vRota;
      End If; 
      exception
        when NO_DATA_FOUND then
            P_STATUS := pkg_glb_common.Status_Erro;
            if vCapa = 'N' Then
               P_MESSAGE := 'Fatura não encontrada - ' || vCodigo ||'-'||vCiclo||'-'||vRota;
            Else
               P_MESSAGE := 'Capa de Fatura não encontrada - ' || vCodigo ||'-'||vCiclo||'-'||vRota;
            End If;   
            return;
        end;
        
       select *
         into tpLinhaSacado
       from t_glb_cliente cl
       where cl.glb_cliente_cgccpfcodigo =  tpLinhaFatura.Glb_Cliente_Cgccpfsacado;          
         

       begin
           select *
             into tpLinhaSacadoEndPP
           from t_glb_cliend cl
           where cl.glb_cliente_cgccpfcodigo =  tpLinhaFatura.Glb_Cliente_Cgccpfsacado
             and cl.glb_tpcliend_codigo = 'C';
       exception
         when NO_DATA_FOUND Then
               RAISE_APPLICATION_ERROR(-20001,'Verifique o tipo de endereço C do sacado');
       end;

       begin
           select *
             into tpLinhaSacadoEndU
           from t_glb_cliend cl
           where cl.glb_cliente_cgccpfcodigo =  tpLinhaFatura.Glb_Cliente_Cgccpfsacado
             and cl.glb_tpcliend_codigo = 'E'; 
       exception
         when NO_DATA_FOUND Then
             tpLinhaSacadoEndU := tpLinhaSacadoEndPP;
         end;    


    --pegando as Verbas 
    Begin
       if vCapa = 'N' Then
          Select COUNT(*) qtde,
/*
                 DECODE(CA.SLF_RECCUST_CODIGO,'I_VLMR    ',' Mercadoria',
                                              'I_PSCOBRAD',' Peso Cobrado',
                                              'I_FRPSVO  ','Frete Valor',
--                                              'I_TTPV    ','Total',
                                              'I_VLICMS  ',' ICMS',
                                              'I_VLISS   ',' ISS',
                                              'I_CAT     ','CAT',
                                              'I_SEC     ','SEC',
                                              'I_ADVL    ','ADVL',
                                              'I_DP      ','Despacho',
                                              'I_PD      ','Pedagio',
                                              'I_SG      ','Seguro',
                                              'I_OT      ','Outros','NAO SEI') VERBA,
*/                                              
                DECODE(TRIM(CA.SLF_RECCUST_CODIGO),'D_VLRSEGUR',' MERCADORIA',
                                                   'I_PSCOBRAD',' PESO COBRADO',
                                                   'I_VLICMS',' ICMS',
                                                   'I_VLISS',' ISS',
                                                   rc.slf_reccust_descricao) VERBA,
                SUM(CA.CON_CALCVIAGEM_VALOR)  VALOR
              BULK COLLECT into tpLinhaVerbas
            from T_CON_CONHECIMENTO c,
                 T_CON_CALCCONHECIMENTO CA,
                 T_SLF_RECCUST RC
           where c.CON_FATURA_CODIGO        = vCodigo
             and c.CON_FATURA_CICLO         = vCiclo
             and c.GLB_ROTA_CODIGOFILIALIMP = vRota
             AND NVL(CA.CON_CALCVIAGEM_VALOR,0) > 0
             and c.CON_CONHECIMENTO_CODIGO = CA.CON_CONHECIMENTO_CODIGO
             and c.CON_CONHECIMENTO_SERIE  = CA.CON_CONHECIMENTO_SERIE
             and c.GLB_ROTA_CODIGO         =  CA.GLB_ROTA_CODIGO
             and ca.slf_reccust_codigo = rc.slf_reccust_codigo
             AND CA.SLF_RECCUST_CODIGO IN ('D_VLRSEGUR',
                                           'I_PSCOBRAD',
                                           'I_FRPSVO',
                                           'I_VLICMS',
                                           'I_VLISS',
                                           'I_CAT',
                                           'I_SEC',
                                           'I_ADVL',
                                           'I_DP',
                                           'I_PD',
                                           'I_SG',
                                           'I_OT')
           GROUP BY DECODE(TRIM(CA.SLF_RECCUST_CODIGO),'D_VLRSEGUR',' MERCADORIA',
                                                       'I_PSCOBRAD',' PESO COBRADO',
                                                       'I_VLICMS',' ICMS',
                                                       'I_VLISS',' ISS',
                                                       rc.slf_reccust_descricao)
           order by 2;                                        
       Else

          Select COUNT(*) qtde,
                 DECODE(CA.SLF_RECCUST_CODIGO,'I_VLMR    ',' MERCADORIA',
                                              'I_PSCOBRAD',' PESO COBRADO',
                                              'I_VLICMS  ',' ICMS',
                                              'I_VLISS   ',' ISS',
                                              rc.slf_reccust_descricao) VERBA,
                 SUM(CA.CON_CALCVIAGEM_VALOR)  VALOR
              BULK COLLECT into tpLinhaVerbas
            from T_CON_CONHECIMENTO c,
                 T_CON_CALCCONHECIMENTO CA,
                 T_SLF_RECCUST RC
           where c.CON_FATURA_CODIGO || c.CON_FATURA_CICLO || c.GLB_ROTA_CODIGOFILIALIMP in (select gf.con_fatura_codigo || gf.con_fatura_ciclo || gf.glb_rota_codigofatura
                                                                                             from t_con_faturagrupoxfatura gf 
                                                                                             where gf.con_faturagrupo_codigo = vCodigo
                                                                                               and gf.con_faturagrupo_ciclo = vCiclo
                                                                                               and gf.glb_rota_codigogrupo = vRota)
             AND NVL(CA.CON_CALCVIAGEM_VALOR,0) > 0
             and c.CON_CONHECIMENTO_CODIGO = CA.CON_CONHECIMENTO_CODIGO
             and c.CON_CONHECIMENTO_SERIE  = CA.CON_CONHECIMENTO_SERIE
             and c.GLB_ROTA_CODIGO         =  CA.GLB_ROTA_CODIGO
             and ca.slf_reccust_codigo = rc.slf_reccust_codigo
             AND CA.SLF_RECCUST_CODIGO IN ('I_VLMR',
                                           'I_PSCOBRAD',
                                           'I_FRPSVO',
                                           'I_VLICMS',
                                           'I_VLISS',
                                           'I_CAT',
                                           'I_SEC',
                                           'I_ADVL',
                                           'I_DP',
                                           'I_PD',
                                           'I_SG',
                                           'I_OT')
           GROUP BY DECODE(CA.SLF_RECCUST_CODIGO,'I_VLMR    ',' MERCADORIA',
                                                 'I_PSCOBRAD',' PESO COBRADO',
                                                 'I_VLICMS  ',' ICMS',
                                                 'I_VLISS   ',' ISS',
                                                 rc.slf_reccust_descricao)
           order by 2;                                        


         
       End If;  
    exception
       when NO_DATA_FOUND Then
            P_STATUS := pkg_glb_common.Status_Erro;
            P_MESSAGE := 'Não foram encontrados VERBAS dos CTRC para esta Fatura';            
       End;

       

       -- pegando a lista de conhecimentos
       if tpLinhaSacado.Glb_Cliente_Nfnafatura = 'S' Then
           begin
              if vCapa = 'N' Then 
                select to_char(c.con_conhecimento_dtembarque,'DD/MM'),
                       NVL(NFE.CON_CONHECRPSNFE_NFECODIGO,c.con_conhecimento_codigo) ,
                       c.con_conhecimento_serie,
                       c.glb_rota_codigo,
                       nf.CON_NFTRANSPORTADA_NUMNFISCAL,
                       nf.GLB_CLIENTE_CGCCPFCODIGO,
                       (select NVL(CA1.CON_CALCVIAGEM_VALOR,0)
                        from t_con_calcconhecimento ca1
                        where ca1.con_conhecimento_codigo = c.con_conhecimento_codigo
                          and ca1.con_conhecimento_serie  = c.con_conhecimento_serie
                          and ca1.glb_rota_codigo         = c.glb_rota_codigo
                          and ca1.slf_reccust_codigo = 'I_PSCOBRAD'),
                       NVL(CA.CON_CALCVIAGEM_VALOR,0)
                   BULK COLLECT into tpLinhaCTRC 
                from t_con_conhecimento c,
                     T_CON_CALCCONHECIMENTO CA,
                     t_con_nftransporta nf,
                     T_CON_CONHECRPSNFE NFE
                where c.con_fatura_codigo = vCodigo
                  and c.con_fatura_ciclo  = vCiclo
                  and c.glb_rota_codigofilialimp = vRota
                  and c.con_conhecimento_codigo = nf.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = nf.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = nfE.glb_rota_codigo (+)
                  and c.con_conhecimento_codigo = nfE.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = nfE.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = nf.glb_rota_codigo (+)
                  and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
                  AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV'
               order by 4,2,5;   
            Else
                select to_char(c.con_conhecimento_dtembarque,'DD/MM'),
                       NVL(NFE.CON_CONHECRPSNFE_NFECODIGO,c.con_conhecimento_codigo) ,
                       c.con_conhecimento_serie,
                       c.glb_rota_codigo,
                       nf.CON_NFTRANSPORTADA_NUMNFISCAL,
                       nf.GLB_CLIENTE_CGCCPFCODIGO,
                       (select NVL(CA1.CON_CALCVIAGEM_VALOR,0)
                        from t_con_calcconhecimento ca1
                        where ca1.con_conhecimento_codigo = c.con_conhecimento_codigo
                          and ca1.con_conhecimento_serie  = c.con_conhecimento_serie
                          and ca1.glb_rota_codigo         = c.glb_rota_codigo
                          and ca1.slf_reccust_codigo = 'I_PSCOBRAD'),
                       NVL(CA.CON_CALCVIAGEM_VALOR,0)
                   BULK COLLECT into tpLinhaCTRC 
                from t_con_conhecimento c,
                     T_CON_CALCCONHECIMENTO CA,
                     t_con_nftransporta nf,
                     T_CON_CONHECRPSNFE NFE
                where c.CON_FATURA_CODIGO || c.CON_FATURA_CICLO || c.GLB_ROTA_CODIGOFILIALIMP in (select gf.con_fatura_codigo || gf.con_fatura_ciclo || gf.glb_rota_codigofatura
                                                                                                  from t_con_faturagrupoxfatura gf 
                                                                                                  where gf.con_faturagrupo_codigo = vCodigo
                                                                                                    and gf.con_faturagrupo_ciclo = vCiclo
                                                                                                    and gf.glb_rota_codigogrupo = vRota)
                  and c.con_conhecimento_codigo = nf.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = nf.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = nfE.glb_rota_codigo (+)
                  and c.con_conhecimento_codigo = nfE.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = nfE.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = nf.glb_rota_codigo (+)
                  and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
                  AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV'
               order by 4,2,5;   
              
            End if;   
               vLinhaCtrc := 1;
           exception
             when NO_DATA_FOUND Then
                P_STATUS := pkg_glb_common.Status_Erro;
                P_MESSAGE := 'Não foram encontrados CTRC para esta Fatura';            
           End;
       Else
           begin
              If vCapa = 'N' then
                select to_char(c.con_conhecimento_dtembarque,'DD/MM'),
                       NVL(NFE.CON_CONHECRPSNFE_NFECODIGO,c.con_conhecimento_codigo) ,
                       c.con_conhecimento_serie,
                       c.glb_rota_codigo,
                       null CON_NFTRANSPORTADA_NUMNFISCAL,
                       null GLB_CLIENTE_CGCCPFCODIGO,
                       0 CON_NFTRANSPORTADA_PESO,    
                       NVL(CA.CON_CALCVIAGEM_VALOR,0)
                   BULK COLLECT into tpLinhaCTRC 
                from t_con_conhecimento c,
                     T_CON_CALCCONHECIMENTO CA,
                     T_CON_CONHECRPSNFE NFE
                where c.con_fatura_codigo = vCodigo
                  and c.con_fatura_ciclo  = vCiclo
                  and c.glb_rota_codigofilialimp = vRota
                  and c.glb_rota_codigo         = nfE.glb_rota_codigo (+)
                  and c.con_conhecimento_codigo = nfE.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = nfE.con_conhecimento_serie (+)
                  and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
                  AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV'
               order by 4,2,5;   
            Else
                select to_char(c.con_conhecimento_dtembarque,'DD/MM'),
                       NVL(NFE.CON_CONHECRPSNFE_NFECODIGO,c.con_conhecimento_codigo) ,
                       c.con_conhecimento_serie,
                       c.glb_rota_codigo,
                       null CON_NFTRANSPORTADA_NUMNFISCAL,
                       null GLB_CLIENTE_CGCCPFCODIGO,
                       0 CON_NFTRANSPORTADA_PESO,    
                       NVL(CA.CON_CALCVIAGEM_VALOR,0)
                   BULK COLLECT into tpLinhaCTRC 
                from t_con_conhecimento c,
                     T_CON_CALCCONHECIMENTO CA,
                     T_CON_CONHECRPSNFE NFE
                where c.CON_FATURA_CODIGO || c.CON_FATURA_CICLO || c.GLB_ROTA_CODIGOFILIALIMP in (select gf.con_fatura_codigo || gf.con_fatura_ciclo || gf.glb_rota_codigofatura
                                                                                                  from t_con_faturagrupoxfatura gf 
                                                                                                  where gf.con_faturagrupo_codigo = vCodigo
                                                                                                    and gf.con_faturagrupo_ciclo = vCiclo
                                                                                                    and gf.glb_rota_codigogrupo = vRota)
                  and c.glb_rota_codigo         = nfE.glb_rota_codigo (+)
                  and c.con_conhecimento_codigo = nfE.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = nfE.con_conhecimento_serie (+)
                  and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
                  and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
                  and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
                  AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV'
               order by 4,2,5;   
              
            End If;   
               vLinhaCtrc := 1;
           exception
             when NO_DATA_FOUND Then
                P_STATUS := pkg_glb_common.Status_Erro;
                P_MESSAGE := 'Não foram encontrados CTRC para esta Fatura';            
           End;
         
       End if;    
        
       if vCapa = 'N' Then  

            select count(*)
              into vTotPg
            from t_con_conhecimento c,
                 T_CON_CALCCONHECIMENTO CA,
                 t_con_nftransporta nf,
                 T_CON_CONHECRPSNFE NFE
            where c.con_fatura_codigo = vCodigo
              and c.con_fatura_ciclo  = vCiclo
              and c.glb_rota_codigofilialimp = vRota
              and c.con_conhecimento_codigo = nf.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = nf.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = nfE.glb_rota_codigo (+)
              and c.con_conhecimento_codigo = nfE.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = nfE.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = nf.glb_rota_codigo (+)
              and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
              AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV';
              
            select sum(ca.con_calcviagem_valor)
              into vTotalFat
            from t_con_conhecimento c,
                 T_CON_CALCCONHECIMENTO CA
            where c.con_fatura_codigo = vCodigo
              and c.con_fatura_ciclo  = vCiclo
              and c.glb_rota_codigofilialimp = vRota
              and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
              AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV';
       
              
       Else
         
            select count(*)
              into vTotPg
            from t_con_conhecimento c,
                 T_CON_CALCCONHECIMENTO CA,
                 t_con_nftransporta nf,
                 T_CON_CONHECRPSNFE NFE
                where c.CON_FATURA_CODIGO || c.CON_FATURA_CICLO || c.GLB_ROTA_CODIGOFILIALIMP in (select gf.con_fatura_codigo || gf.con_fatura_ciclo || gf.glb_rota_codigofatura
                                                                                                  from t_con_faturagrupoxfatura gf 
                                                                                                  where gf.con_faturagrupo_codigo = vCodigo
                                                                                                    and gf.con_faturagrupo_ciclo = vCiclo
                                                                                                    and gf.glb_rota_codigogrupo = vRota)
              and c.con_conhecimento_codigo = nf.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = nf.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = nfE.glb_rota_codigo (+)
              and c.con_conhecimento_codigo = nfE.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = nfE.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = nf.glb_rota_codigo (+)
              and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
              AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV';

            select sum(ca.con_calcviagem_valor)
              into vTotalFat
            from t_con_conhecimento c,
                 T_CON_CALCCONHECIMENTO CA
                where c.CON_FATURA_CODIGO || c.CON_FATURA_CICLO || c.GLB_ROTA_CODIGOFILIALIMP in (select gf.con_fatura_codigo || gf.con_fatura_ciclo || gf.glb_rota_codigofatura
                                                                                                  from t_con_faturagrupoxfatura gf 
                                                                                                  where gf.con_faturagrupo_codigo = vCodigo
                                                                                                    and gf.con_faturagrupo_ciclo = vCiclo
                                                                                                    and gf.glb_rota_codigogrupo = vRota)
              and c.con_conhecimento_codigo = CA.con_conhecimento_codigo (+)
              and c.con_conhecimento_serie  = CA.con_conhecimento_serie (+)
              and c.glb_rota_codigo         = CA.glb_rota_codigo (+)
              AND CA.SLF_RECCUST_CODIGO     = 'I_TTPV';
   
                            
       End If;
      -- Calcula Paginas
         if vTotPg <= 82 Then
            vTotPg := 1;
         Else 
           -- Retira total de Notas da Primeira Pagina
           vTotPg := vTotPg - 82;
           -- Pega o Inteiro da Divisão por 148 que é o limite
           -- que cabe nos outras paginas
           vTotPg := round((( vTotPg/148) + 0.5),0) + 1;
         End if;   
       
       
       select pcl.glb_pcl_fonteform
         into vFonteDefault
       from t_glb_pcl pcl
       where pcl.glb_pcl_codigo = 'FATURA'
         and pcl.glb_pcl_versao = c_VersaoFatura; 
       
       i:= 1; -- quantidade de Paginas

       loop
            P_LISTADADOS(i).Pcl    := 'FATURA';
            P_LISTADADOS(i).Versao := c_VersaoFatura;
            P_LISTADADOS(i).Fonte  := vFonteDefault;

            if i = 1 then -- Define qual formaulario ira usar
               P_LISTADADOS(i).Sequencia := 1;
            Else
               P_LISTADADOS(i).Sequencia := 2;
            End if;   
            
            P_LISTADADOS(i).linha('CABECFAT1')         := 'Rua LIDICE, 22 - PARQUE NOVO MUNDO - CEP 02174-010 - SÃO PAULO - SP';
            P_LISTADADOS(i).linha('CABECFAT2')         := 'PABX  (11) 2967-8500   -     FAX:  (11) 2967-8501  /  8502  /  8593';
            P_LISTADADOS(i).linha('CABECFAT3')         := 'http://www.dellavolep.com.br';
            P_LISTADADOS(i).linha('CABECFAT4')         := 'INSCRIÇÃO NO CNPJ : 61.139.432/0001-72';
            P_LISTADADOS(i).linha('CABECFAT5')         := 'INSCRICAO ESTADUAL : 104.338.196.110';
            P_LISTADADOS(i).linha('LIVRETEXT')                := vRegua;
            P_LISTADADOS(i).linha('LIVRECAB')                 := vRegua;
            
      /*    --DADOS DE PINDA
        
            P_LISTADADOS(i).linha('CABECFAT1')         := 'AV.PROF.MANOEL CESAR RIBEIRO.4104 - JARDIM HELOINA - CEP 12411010 - PINDAMONHANGABA - SP';
            P_LISTADADOS(i).linha('CABECFAT2')         := 'PABX  (12)3643-2911   -     FAX:  (12) 3643-2911';
            P_LISTADADOS(i).linha('CABECFAT3')         := 'http://www.dellavolep.com.br';
            P_LISTADADOS(i).linha('CABECFAT4')         := 'INSCRIÇÃO NO CNPJ : 61.139.432/0069-60';
            P_LISTADADOS(i).linha('CABECFAT5')         := 'INSCRICAO ESTADUAL : 104.338.196.110';
            P_LISTADADOS(i).linha('LIVRETEXT')                := vRegua;
            P_LISTADADOS(i).linha('LIVRECAB')                 := vRegua;*/

        
           if vReimpressao <> 'S' Then 
              P_LISTADADOS(i).linha('CON_FATURA_CODIGO')        := substr(tpLinhaFatura.Con_Fatura_Codigo,1,3) || '.' || substr(tpLinhaFatura.Con_Fatura_Codigo,4,3) || '-' || tpLinhaFatura.Con_Fatura_Ciclo;
           Else
              P_LISTADADOS(i).linha('CON_FATURA_CODIGO')        := tpLinhaFatura.Con_Fatura_Codigo || '-' || tpLinhaFatura.Con_Fatura_Ciclo;
           End If;   
           
           
            P_LISTADADOS(i).linha('CON_FATURA_DATAEMISSAO')   := to_char(tpLinhaFatura.Con_Fatura_Dataemissao,'dd/mm/yyyy');
            if to_char(tpLinhaFatura.Con_Fatura_Dataemissao,'dd/mm/yyyy') = to_char(tpLinhaFatura.Con_Fatura_Datavenc,'dd/mm/yyyy') Then
               P_LISTADADOS(i).linha('CON_FATURA_DATAVENC')      := 'C/APRESENT.';
            Else
               P_LISTADADOS(i).linha('CON_FATURA_DATAVENC')      := to_char(tpLinhaFatura.Con_Fatura_Datavenc,'dd/mm/yyyy');
            End if;   
            -- mudei para a soma dos Cte na Fatura
            -- 20/12/2013
            -- Sirlano
            -- Caso o Valor for diferente deixo igual na fatura. 
            if tpLinhaFatura.Con_Fatura_Codigo = '900103' then
                vTotalFat := 12346.13 ;
            Elsif tpLinhaFatura.Con_Fatura_Codigo = '900104' Then
                vTotalFat := 3669.08 ;
            Else
                vTotalFat := vTotalFat;
            end IF;                  
            P_LISTADADOS(i).linha('CON_FATURA_VALORCOBRADO')  := vTotalFat ;-- tpLinhaFatura.Con_Fatura_Valorcobrado;
            P_LISTADADOS(i).linha('GLB_ROTA_CODIGOFILIALIMP') := tpLinhaFatura.Glb_Rota_Codigofilialimp;
            P_LISTADADOS(i).linha('LIVRECAB')         := 'FOLHAS';
            P_LISTADADOS(i).linha('LIVRETEXT')         := 'Pag.' || to_char(i) || '/' || to_char(vTotPg);

            -- Estes dados são somente para a primeira pagina
            if i = 1 Then 

                -- Dados Do Sacado
                P_LISTADADOS(i).linha('SACNOME')      := tpLinhaSacado.Glb_Cliente_Razaosocial;
                P_LISTADADOS(i).linha('SACCNPJ')      := tpLinhaSacado.Glb_Cliente_Cgccpfcodigo;
                P_LISTADADOS(i).linha('SACINSCRICAO') := tpLinhaSacado.Glb_Cliente_Ie;
                -- Endereço do Sacado
                P_LISTADADOS(i).linha('SACENDERECO')  := tpLinhaSacadoEndU.Glb_Cliend_Endereco;
                P_LISTADADOS(i).linha('SACCEP')       := tpLinhaSacadoEndU.Glb_Cep_Codigo;
                P_LISTADADOS(i).linha('SACMUN')       := tpLinhaSacadoEndU.Glb_Cliend_Cidade || '-' || tpLinhaSacadoEndU.Glb_Estado_Codigo;
                P_LISTADADOS(i).linha('SACUF')        := '';
                -- Praca de Pagamento 
                P_LISTADADOS(i).linha('SACENDERECOPGTO')  := tpLinhaSacadoEndpp.Glb_Cliend_Endereco;
                P_LISTADADOS(i).linha('SACCEPPGTO')     := tpLinhaSacadoEndpp.Glb_Cep_Codigo;
                P_LISTADADOS(i).linha('SACPRACAPGTO')   := tpLinhaSacadoEndpp.Glb_Cliend_Cidade || '-' || tpLinhaSacadoEndpp.Glb_Estado_Codigo;
                P_LISTADADOS(i).linha('SACUFPRACAPGTO') := '';


                if tpLinhaFatura.Con_Fatura_Desconto > 0 then
                   P_LISTADADOS(i).linha('CON_FATURA_DESCONTO')      := tpLinhaFatura.Con_Fatura_Desconto;
                   P_LISTADADOS(i).linha('CON_FATURA_DTLIMTDESC')    := to_char(tpLinhaFatura.Con_Fatura_Dtlimtdesc,'dd/mm/yyyy');
                End If;
                
                if NVL(trim(tpLinhaFatura.Con_Fatura_Obsdesconto),'NULLO') <> 'NULLO'  then 
                   P_LISTADADOS(i).linha('CONDESPECIAL1')            := substr(tpLinhaFatura.Con_Fatura_Obsdesconto,1,35);
                   P_LISTADADOS(i).linha('CONDESPECIAL2')            := substr(tpLinhaFatura.Con_Fatura_Obsdesconto,36,40);
                   P_LISTADADOS(i).linha('CONDESPECIAL3')            := substr(tpLinhaFatura.Con_Fatura_Obsdesconto,77,40);
                   P_LISTADADOS(i).linha('CONDESPECIAL4')            := substr(tpLinhaFatura.Con_Fatura_Obsdesconto,118,40);
                   P_LISTADADOS(i).linha('CONDESPECIAL5')            := substr(tpLinhaFatura.Con_Fatura_Obsdesconto,159,40);
                End IF;
--                   P_LISTADADOS(i).linha('CON_FATURA_OBSDESCONTO1')  := substr(vRegua,1,50);
--                   P_LISTADADOS(i).linha('CON_FATURA_OBSDESCONTO2')  := substr(vRegua,1,50);
--                   P_LISTADADOS(i).linha('CON_FATURA_OBSDESCONTO3')  := substr(vRegua,1,50);
--                   P_LISTADADOS(i).linha('CON_FATURA_OBSDESCONTO4')  := substr(vRegua,1,50);



               vContador := 1;
               vContadorReg := 1;
               vJaVez := 'N';
               loop
                 begin
                if ( substr(tpLinhaVerbas(vContadorReg).VERBA,1,1) <> ' ' ) and ( vJaVez = 'N' ) Then
                    P_LISTADADOS(i).linha('VERBASQTDE'  || TRIM(TO_CHAR(vContador))) := null; --'****************************************';
                    P_LISTADADOS(i).linha('VERBASESPEC' || TRIM(TO_CHAR(vContador))) := null; --'***********************************************************************';
                    P_LISTADADOS(i).linha('VERBASTAXA'  || TRIM(TO_CHAR(vContador))) := null; --'****************************************';
                    P_LISTADADOS(i).linha('VERBASVALOR' || TRIM(TO_CHAR(vContador))) := null; --'****************************************';
                    vContador := vContador + 1;
                    vJaVez := 'S';
                End if; 
                
                                 
                P_LISTADADOS(i).linha('VERBASQTDE'  || TRIM(TO_CHAR(vContador))) := tpLinhaVerbas(vContadorReg).QTDE;
                P_LISTADADOS(i).linha('VERBASESPEC' || TRIM(TO_CHAR(vContador))) := tpLinhaVerbas(vContadorReg).VERBA;
                
                 
                P_LISTADADOS(i).linha('VERBASTAXA'  || TRIM(TO_CHAR(vContador))) := '0';
                
                if tpLinhaVerbas(vContadorReg).VERBA = 'FRETE PESO VOLUME TOTAL' then
                   P_LISTADADOS(i).linha('VERBASTAXA'  || TRIM(TO_CHAR(vContador))) := f_mascara_valor(vTaxaFrete,15,2);
                end if;  
                
                if tpLinhaVerbas(vContadorReg).VERBA = 'FRETE VALOR TOTAL' then
                   P_LISTADADOS(i).linha('VERBASTAXA'  || TRIM(TO_CHAR(vContador))) := f_mascara_valor(vTaxaAd,15,4);
                end if;  

                P_LISTADADOS(i).linha('VERBASVALOR' || TRIM(TO_CHAR(vContador))) := tpLinhaVerbas(vContadorReg).VALOR;
                vContador := vContador + 1; 
                vContadorReg := vContadorReg + 1;
                If vContador > 10 Then
                   EXIT;
                End If;   
                 exception
                   when NO_DATA_FOUND Then
                      exit;
                   end;
                end loop;   

          P_LISTADADOS(i).linha('SOMADASVERBAS') :=  vTotalFat; -- tpLinhaFatura.Con_Fatura_Valorcobrado;
          P_LISTADADOS(i).linha('VALORLIQUIDO')  :=  (vTotalFat - nvl(tpLinhaFatura.Con_Fatura_Desconto,0)) ;  -- (tpLinhaFatura.Con_Fatura_Valorcobrado - nvl(tpLinhaFatura.Con_Fatura_Desconto,0)) ;

--          if (tpLinhaFatura.Con_Fatura_Valorcobrado - nvl(tpLinhaFatura.Con_Fatura_Desconto,0)) > 0  Then
          if (vTotalFat - nvl(tpLinhaFatura.Con_Fatura_Desconto,0)) > 0  Then
--             P_LISTADADOS(i).linha('EXTENSO1') := glbadm.pkg_glb_common.fn_extenso_monetario((tpLinhaFatura.Con_Fatura_Valorcobrado - nvl(tpLinhaFatura.Con_Fatura_Desconto,0)));
             P_LISTADADOS(i).linha('EXTENSO1') := glbadm.pkg_glb_common.fn_extenso_monetario((vTotalFat - nvl(tpLinhaFatura.Con_Fatura_Desconto,0)));
             IF LENGTH(P_LISTADADOS(i).linha('EXTENSO1')) > 80 then
                vPosAux := instr(substr(P_LISTADADOS(i).linha('EXTENSO1'),1,80),' ',-1);
                P_LISTADADOS(i).linha('EXTENSO2') := substr(P_LISTADADOS(i).linha('EXTENSO1'),vPosAux+1);
                P_LISTADADOS(i).linha('EXTENSO1') := substr(P_LISTADADOS(i).linha('EXTENSO1'),1,vPosAux);               
             end if;   
          Else
                P_LISTADADOS(i).linha('EXTENSO1') := rpad('*',120,'*');               
                P_LISTADADOS(i).linha('EXTENSO2') := rpad('*',120,'*');               
          End If;   


    --      P_LISTADADOS(i).linha('PERCTINSS') := '*****';
    --      P_LISTADADOS(i).linha('VLRINSS')   := '*****';

      End if;


      P_LISTADADOS(i).linha('NOMECOLUNA1') := 'CTe/NFS';
      P_LISTADADOS(i).linha('NOMECOLUNA2') := 'CTe/NFS';

      vContador := 1;
      vCtrcAnterior := 'sirlano';
      loop
         begin
           
            
            P_LISTADADOS(i).linha('CTRCDIA'   || lpad(vContador,3,'0')) := tpLinhaCTRC(vlinhaCtrc).DIA;
            if tpLinhaCTRC(vlinhaCtrc).CTRC ||'-'||tpLinhaCTRC(vlinhaCtrc).ROTA = '644265-197' then
               P_LISTADADOS(i).linha('CTRCDOC'   || lpad(vContador,3,'0')) := 'MEDIA DE 11/03';
            Else   
               P_LISTADADOS(i).linha('CTRCDOC'   || lpad(vContador,3,'0')) := tpLinhaCTRC(vlinhaCtrc).CTRC ||'-'||tpLinhaCTRC(vlinhaCtrc).ROTA||'-CTE';
            End If;   
            if tpLinhaCTRC(vlinhaCtrc).CTRC ||'-'||tpLinhaCTRC(vlinhaCtrc).ROTA = '644265-197' then
               P_LISTADADOS(i).linha('CTRCNOTA'  || lpad(vContador,3,'0')) := 'a 20/03';
            Else 
               P_LISTADADOS(i).linha('CTRCNOTA'  || lpad(vContador,3,'0')) := tpLinhaCTRC(vlinhaCtrc).NOTA;
            End If; 
            P_LISTADADOS(i).linha('CTRCPESO'  || lpad(vContador,3,'0')) := tpLinhaCTRC(vlinhaCtrc).PESONOTA;
            if trim(vCtrcAnterior) <> trim(tpLinhaCTRC(vlinhaCtrc).CTRC ||'-'||tpLinhaCTRC(vlinhaCtrc).ROTA) ||'-CTE' Then
               P_LISTADADOS(i).linha('CTRCVALOR' || lpad(vContador,3,'0')) := tpLinhaCTRC(vlinhaCtrc).VALORNOTA;
               vCtrcAnterior := trim(tpLinhaCTRC(vlinhaCtrc).CTRC ||'-'||tpLinhaCTRC(vlinhaCtrc).ROTA) ||'-CTE';
            Else
               P_LISTADADOS(i).linha('CTRCVALOR' || lpad(vContador,3,'0')) := null;
            End if;   
            vContador := vContador + 1;   
            vlinhaCtrc := vlinhaCtrc + 1;
             exception
               when NO_DATA_FOUND Then
                  i := -1; -- Indica que acabou
                  exit;
               end;
               if ( i = 1 ) and ( vContador > 82 )  Then
                  i := i + 1;
                  exit;
               ElsIf ( i > 1 ) and ( vContador > 148 )   then
                  i := i + 1;
                  exit;
               End if;
            end loop;   
            if i = -1 Then
              Exit;
            End if;  
      end loop;
      
      if ( vTotalFat  <> tpLinhaFatura.Con_Fatura_Valorcobrado ) and ( vCapa = 'N' ) Then
         update t_con_fatura f
           set f.con_fatura_valorcobrado = vTotalFat
         where f.con_fatura_codigo = vCodigo
           and f.con_fatura_ciclo  = vCiclo
           and f.glb_rota_codigofilialimp = vRota;
      End If;
      
      If ( nvl(tpLinhaFatura.Con_Fatura_Status,'N') <> 'I' ) and ( vCapa = 'S' ) Then
         update tdvadm.t_con_faturagrupo fg
           set fg.con_faturagrupo_status = 'I'
         where fg.con_faturagrupo_codigo = tpLinhaFatura.Con_Fatura_Codigo
           and fg.con_faturagrupo_ciclo = tpLinhaFatura.Con_Fatura_Ciclo
           and fg.glb_rota_codigofilialimp = tpLinhaFatura.Glb_Rota_Codigofilialimp;
      End If;        
      
  End SP_RETDADOFATURA;                              

  procedure  SP_RETDADOVALEFRETE(P_XMLIN      In  VARCHAR2,
                                 P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                                 P_STATUS     OUT CHAR,
                                 P_MESSAGE    OUT VARCHAR2)
  As
     plistaparams        glbadm.pkg_listas.tlistausuparametros;
     vCodigo             tdvadm.t_con_valefrete.con_conhecimento_codigo%type;
     vSerie              tdvadm.t_con_valefrete.con_conhecimento_serie%type; 
     vRota               tdvadm.t_con_valefrete.glb_rota_codigo%type;
     vSaque              tdvadm.t_con_valefrete.con_valefrete_saque%type;
     tpLinhaValeFrete    tdvadm.t_con_valefrete%rowtype;
     vContadoReimpressao number;
     vPosAux             number;
     vContador           number;
     i                   number;
     i2                  number;
     iParou              number;
     tpLinhaCTRC         TabCTRCFatura;
     vFonteDefault       tdvadm.t_glb_pcl.glb_pcl_fonteform%type;
     tpFilial            tdvadm.t_glb_rota%rowtype;
     vCIOT               tdvadm.t_con_vfreteciot.con_vfreteciot_numero%type;
     vQtdeDoc            number;
     vQtedeDANFE         number;
     vListaCTeAtivos     varchar2(32000);
     vListaEntregas      varchar2(600);
     vAuxiliarN          number;
     vTamLinhaDOC        number := 156;
     vTamLinhaCONDESP    number := 133;
     vTamLinhaCONDOBS    number := 170;
     vUsuarioTDV         char(10);
     vRotaUsuarioTDV     char(3);
     vAplicacaoTDV       char(10);
     vVersaoAplicao      char(10);
     vGrupoEstadia       tdvadm.t_usu_perfil.usu_perfil_parat%type;
     vClienteEstadia     tdvadm.t_usu_perfil.usu_perfil_parat%type;
     vCodEstadia         char(3);
     vOBSEstadia         tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type;
     vOBSContrato        varchar2(300);
     vDiariodeBordo      char(1);
     vListaDiario        glbadm.pkg_listas.tContainerPCL;
     vXMLLinha           clob;
     vStatus             char(1);
     vMessage            varchar2(32000);
     vFrota              char(1);
     vCategoria          tdvadm.t_con_catvalefrete.con_catvalefrete_descricao%type;
     vVlrTarifa          number;
     vDescontoZerado     char(1) := 'N';
     vTipoMotorista      char(17);
     vMSG_CONTRATADO     tdvadm.t_usu_perfil.usu_perfil_parat%type;
  Begin
   vFrota              := 'N';
   vCodigo             := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Codigo' ));
   vSerie              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Serie' ));
   vRota               := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Rota' ));
   vSaque              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Saque' ));
   vUsuarioTDV         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'UsuarioTDV' ));
   vRotaUsuarioTDV     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'RotaUsuarioTDV' ));
   vAplicacaoTDV       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Aplicacao' ));
   vVersaoAplicao      := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'VersaoAplicao' ));
   vDiariodeBordo      := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'DiarioBordo' ));

   P_LISTADADOS.delete; 
   P_STATUS :=  pkg_glb_common.Status_Nomal;
   P_MESSAGE := '';
   
   
   --insert into tdvadm.t_glb_testestr(glb_testestr_1,glb_testeclob_1) values ('KLAYTON',P_XMLIN);
   --COMMIT;
   
  if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacaoTDV,
                                               vusuarioTDV,
                                               vRotaUsuarioTDV,
                                               plistaparams) Then
                                    
     P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
     P_MESSAGE := P_MESSAGE || '00 - Erro ao Buscar Parametros.' || chr(10);
  End if ;  
  
  
     
                                    

      Select *
        into tpLinhaValeFrete
        From t_con_valefrete v
       where v.con_conhecimento_codigo = vCodigo
         and v.con_conhecimento_serie  = vSerie
         and v.glb_rota_codigo         = vRota
         and v.con_valefrete_saque     = vSaque;               
       
      begin
     
       if (plistaparams('VLRAGREGPER'||tpLinhaValeFrete.Con_Valefrete_Placa).NUMERICO1 = 0)then
          vDescontoZerado := 'S';
       else
          vDescontoZerado := 'N';
       end if;
   
      exception when others then
         vDescontoZerado := 'N';
      end;     
 
       Select *
         into tpFilial
       From t_glb_rota rt
       where rt.glb_rota_codigo =  vRota;  
       
       begin
       select vc.con_vfreteciot_numero
         into vCIOT
       from t_con_vfreteciot vc
       where vc.con_conhecimento_codigo = vCodigo
         and vc.con_conhecimento_serie  = vSerie
         and vc.glb_rota_codigo         = vRota
         and vc.con_valefrete_saque     = vSaque;
       exception
         when NO_DATA_FOUND then 
            vCIOT := null;
         End;  
         
       Begin
          select cvf.con_catvalefrete_descricao
            into vCategoria
          from t_con_catvalefrete cvf
          where cvf.con_catvalefrete_codigo = tpLinhaValeFrete.Con_Catvalefrete_Codigo;
       Exception
         When NO_DATA_FOUND Then
            vCategoria := tpLinhaValeFrete.Con_Catvalefrete_Codigo || '-NAO CADASTRADA';
         End ;   


       select sum(nvl(vf.con_calcvalefrete_valor,0))
         into vVlrTarifa
       from t_con_calcvalefrete vf
       where vf.con_conhecimento_codigo = vCodigo
         and vf.con_conhecimento_serie  = vSerie
         and vf.glb_rota_codigo         = vRota
         and vf.con_valefrete_saque     = vSaque
         and vf.con_calcvalefretetp_codigo in ('06','07');
         
       vVlrTarifa := nvl(vVlrTarifa,0); 
       
       select count(*)
         into vQtdeDoc
       from t_con_vfreteconhec vcc
       where vcc.con_conhecimento_codigo = vCodigo
         and vcc.con_conhecimento_serie  = vSerie
         and vcc.glb_rota_codigo         = vRota
         and vcc.con_valefrete_saque     = vSaque;
           

       SELECT count(*) 
          into vQtedeDANFE
       FROM tdvadm.t_con_vfreteconhec vcc,
            tdvadm.t_con_nftransporta nf
       where vcc.con_conhecimento_codigo = vCodigo
         and vcc.con_conhecimento_serie  = vSerie
         and vcc.glb_rota_codigo         = vRota
         and vcc.con_valefrete_saque     = vSaque
         and vcc.con_conhecimento_codigo = nf.con_conhecimento_codigo
         and vcc.con_conhecimento_serie = nf.con_conhecimento_serie
         and vcc.glb_rota_codigo = nf.glb_rota_codigo;
  
       Select pcl.glb_pcl_fonteform
         into vFonteDefault
       from t_glb_pcl pcl
       where pcl.glb_pcl_codigo = 'VALEFRETE'
         and pcl.glb_pcl_versao = c_VersaoValeFrete;  
       i:= 1; -- quantidade de Paginas
       loop
            P_LISTADADOS(i).linha('VIA1') := 'ADIANTAMENTO';
            P_LISTADADOS(i).linha('VIA2') := 'PROPRIETARIO';
            P_LISTADADOS(i).linha('VIA3') := 'SALDO';
            P_LISTADADOS(i).linha('CATEGORIA') := vCategoria;

            P_LISTADADOS(i).Pcl := 'VALEFRETE';
            P_LISTADADOS(i).Versao := c_VersaoValeFrete;
            P_LISTADADOS(i).Fonte  := vFonteDefault;

            if i = 1 then -- Define qual formaulario ira usar
               P_LISTADADOS(i).Sequencia := 1;
            Else
               P_LISTADADOS(i).Sequencia := 2;
            End if;   
            

            select count(*)
              into vContadoReimpressao
            from t_con_valefretereimp ri
            where ri.con_conhecimento_codigo = vCodigo
              and ri.con_conhecimento_serie = vSerie
              and ri.glb_rota_codigo = vRota
              and ri.con_valefrete_saque = vSaque;

            P_LISTADADOS(i).linha('CABEC1')        := '';
            P_LISTADADOS(i).linha('CABEC2')        := tdvadm.f_mascara_cgccpf(trim(tpFilial.glb_rota_cgc)) || ' - ' || trim(tpFilial.glb_rota_descricao);
            P_LISTADADOS(i).linha('CABEC3')        := trim(tpFilial.glb_rota_endereco);  
            P_LISTADADOS(i).linha('CABEC4')        := trim(tpFilial.glb_rota_cidade) || ' - ' || trim(tpFilial.glb_estado_codigo);
            P_LISTADADOS(i).linha('CABEC5')        := 'EMISSAO - ' || to_char(tpLinhaValeFrete.Con_Valefrete_Dataemissao,'dd/mm/yyyy') || ' EMISSOR - ' || trim(tpLinhaValeFrete.Con_Valefrete_Emissor);
            P_LISTADADOS(i).linha('VALEFRETE')     := vCodigo || '-' || vSerie || '-' || vRota || '-' || vSaque;
            if vContadoReimpressao > 0 Then
               P_LISTADADOS(i).linha('VALEFRETE') := P_LISTADADOS(i).linha('VALEFRETE') || '   -   [' || trim(to_char(vContadoReimpressao + 1)) || ' REIMPRESSAO]' ;
            End If;    
              
            P_LISTADADOS(i).linha('CIOT')          := vCIOT;
            P_LISTADADOS(i).linha('CODIGODEBARRA') := glbadm.pkg_glb_codigodebarra2.Code128('003' || trim(vCodigo) || trim(SUBSTR(trim(vSerie),2,1)) || trim(vRota) || trim(vSaque));

            P_LISTADADOS(i).linha('MOTORISTA') := null;
            for vPropVeicMot in (SELECT P.CAR_PROPRIETARIO_CGCCPFCODIGO CNPJPROP,
                                        P.CAR_PROPRIETARIO_RAZAOSOCIAL PROPRIETARIO,
                                        TRIM(P.CAR_PROPRIETARIO_RNTRC) || ' - VALIDADE - ' || TO_CHAR(P.CAR_PROPRIETARIO_RNTRCDTVAL,'DD/MM/YYYY') || ' - TP - ' || P.CAR_PROPRIETARIO_CLASSANTT RNTRC,
                                        V.CAR_VEICULO_PLACA PLACA,
                                        v.car_veiculo_saque SAQUE,
                                        V.CAR_VEICULO_ANOFABRIC ANO,
                                        MT.CAR_CARRETEIRO_CPFCODIGO CPFMOT,
                                        MT.CAR_CARRETEIRO_NOME MOTORISTA,
                                        DECODE(LENGTH(TRIM(P.CAR_PROPRIETARIO_CGCCPFCODIGO)),11,'CPF','CNPJ') TPPROP                                 
                                 FROM T_CON_VALEFRETE VF,
                                      T_CAR_CARRETEIRO MT,
                                      T_CAR_PROPRIETARIO P,
                                      T_CAR_VEICULO V
                                 WHERE 0 = 0
                                   AND VF.CON_CONHECIMENTO_CODIGO = vCodigo --'016959'
                                   AND VF.CON_CONHECIMENTO_SERIE  = vSerie  -- 'A1'
                                   AND VF.GLB_ROTA_CODIGO         = vRota   -- '196'
                                   AND VF.CON_VALEFRETE_SAQUE     = vSaque  -- '1'
                                   AND VF.CON_VALEFRETE_PLACA          = V.CAR_VEICULO_PLACA (+)
                                   AND VF.CON_VALEFRETE_PLACASAQUE     = V.CAR_VEICULO_SAQUE (+)
                                   AND V.CAR_PROPRIETARIO_CGCCPFCODIGO = P.CAR_PROPRIETARIO_CGCCPFCODIGO (+)
                                   AND VF.CON_VALEFRETE_CARRETEIRO     = MT.CAR_CARRETEIRO_CPFCODIGO (+)
                                   AND VF.CON_VALEFRETE_PLACA          = MT.CAR_VEICULO_PLACA (+)
                                   AND VF.CON_VALEFRETE_PLACASAQUE     = MT.CAR_VEICULO_SAQUE (+)
                                   AND MT.CAR_CARRETEIRO_SAQUE     = (SELECT MAX(MT1.CAR_CARRETEIRO_SAQUE)
                                                                      FROM T_CAR_CARRETEIRO MT1
                                                                      WHERE MT1.CAR_CARRETEIRO_CPFCODIGO = MT.CAR_CARRETEIRO_CPFCODIGO
                                                                        AND MT1.CAR_VEICULO_PLACA        = MT.CAR_VEICULO_PLACA
                                                                        AND MT1.CAR_VEICULO_SAQUE        = MT.CAR_VEICULO_SAQUE)
                                )
                      loop
                          vFrota := 'N';
                          vTipoMotorista := fn_rettp_motorista(vPropVeicMot.Placa,
                                                               vPropVeicMot.Saque,
                                                               tpLinhaValeFrete.Con_Valefrete_Datacadastro); 
                          P_LISTADADOS(i).linha('RNTRC')         := vPropVeicMot.Rntrc;
                          P_LISTADADOS(i).linha('LBCNPJCPF')     := vPropVeicMot.Tpprop;
                          P_LISTADADOS(i).linha('PROPRIETARIO')  := vPropVeicMot.Proprietario;
                          P_LISTADADOS(i).linha('PROPCNPJCPF')   := vPropVeicMot.Cnpjprop;
                          P_LISTADADOS(i).linha('PLACA')         := vPropVeicMot.Placa;
                          P_LISTADADOS(i).linha('ANOVEIC')       := vPropVeicMot.Ano;
                          P_LISTADADOS(i).linha('EIXOS')         := trim('EIXOS: ' || tdvadm.F_RETORNANUMEIXOS(vPropVeicMot.Placa));
                          P_LISTADADOS(i).linha('LBCPF')         := 'CPF';
                          P_LISTADADOS(i).linha('MOTORISTA')     := vPropVeicMot.Motorista;
                          P_LISTADADOS(i).linha('MOTCPF')        := vPropVeicMot.Cpfmot;
                          P_LISTADADOS(i).linha('CODIGOFROTAAGREG') := vTipoMotorista || ' - ' || fn_retcodfa(vPropVeicMot.Placa);                         
                          P_LISTADADOS(i).linha('OBSANTT1') := '- O contratado, neste ato, concorda com os valores negociados, aceitando o frete pago de acordo com as especificações deste transporte quanto à quantidade,';
                          P_LISTADADOS(i).linha('OBSANTT2') := '  peso e volumes, conforme Resolucao 5.820/2018 - ANTT.';
                      End loop;                                            
                      
                      if P_LISTADADOS(i).linha('MOTORISTA') IS null Then
                          for vPropVeicMot in (SELECT '61139432000172' CNPJPROP,
                                                      (select TRIM(P2.CAR_PROPRIETARIO_RNTRC) || ' - VALIDADE - ' || TO_CHAR(P2.CAR_PROPRIETARIO_RNTRCDTVAL,'DD/MM/YYYY') || ' - TP - ' || P2.CAR_PROPRIETARIO_CLASSANTT FROM T_CAR_PROPRIETARIO P2 WHERE  P2.CAR_PROPRIETARIO_CGCCPFCODIGO = '61139432000172' ) RNTRC,
                                                      'TRANSPORTES DELLA VOLPE' PROPRIETARIO,
                                                      V.FRT_VEICULO_PLACA PLACA,
                                                      NULL SAQUE,
                                                      V.FRT_VEICULO_ANOFABRICACAO ANO,
                                                      M.FRT_MOTORISTA_CPF CPFMOT,
                                                      M.FRT_MOTORISTA_NOME MOTORISTA,
                                                      'CNPJ'  TPPROP,
                                                      ce.frt_conjveiculo_codigo
                                               FROM TDVADM.T_CON_VALEFRETE VF,
                                                    TDVADM.T_FRT_CONTENG CE,
                                                    TDVADM.T_FRT_MOTORISTA M,
                                                    TDVADM.T_FRT_VEICULO V
                                               WHERE 0 = 0
                                                 AND VF.CON_CONHECIMENTO_CODIGO = vCodigo --'016959'
                                                 AND VF.CON_CONHECIMENTO_SERIE  = vSerie  -- 'A1'
                                                 AND VF.GLB_ROTA_CODIGO         = vRota   -- '196'
                                                 AND VF.CON_VALEFRETE_SAQUE     = vSaque  -- '1'
                                                 AND VF.CON_VALEFRETE_PLACA     = CE.FRT_CONJVEICULO_CODIGO
                                                 AND CE.FRT_VEICULO_CODIGO      = V.FRT_VEICULO_CODIGO
                                                 AND VF.CON_VALEFRETE_CARRETEIRO = M.FRT_MOTORISTA_CPF
                                                 AND 1 = (SELECT COUNT(*)
                                                          FROM TDVADM.T_FRT_VEICULO V1,
                                                               TDVADM.T_FRT_MARMODVEIC MM,
                                                               TDVADM.T_FRT_TPVEICULO TV
                                                          WHERE V1.FRT_VEICULO_CODIGO = CE.FRT_VEICULO_CODIGO     
                                                            AND V1.FRT_MARMODVEIC_CODIGO = MM.FRT_MARMODVEIC_CODIGO
                                                            AND MM.FRT_TPVEICULO_CODIGO = TV.FRT_TPVEICULO_CODIGO
                                                            AND TV.FRT_TPVEICULO_TRACAO = 'S' ) )
                                    loop
                                        vFrota := 'S';
                                        vTipoMotorista := 'FROTA';
                                        P_LISTADADOS(i).linha('RNTRC')         := vPropVeicMot.Rntrc;
                                        P_LISTADADOS(i).linha('LBCNPJCPF')     := vPropVeicMot.Tpprop;
                                        P_LISTADADOS(i).linha('PROPRIETARIO')  := vPropVeicMot.Proprietario;
                                        P_LISTADADOS(i).linha('PROPCNPJCPF')   := vPropVeicMot.Cnpjprop;
                                        P_LISTADADOS(i).linha('PLACA')         := vPropVeicMot.Placa;
                                        P_LISTADADOS(i).linha('ANOVEIC')       := vPropVeicMot.Ano;
                                        P_LISTADADOS(i).linha('EIXOS')         := trim('EIXOS: ' || tdvadm.F_RETORNANUMEIXOS(vPropVeicMot.Placa));
                                        P_LISTADADOS(i).linha('LBCPF')         := 'CPF';
                                        P_LISTADADOS(i).linha('MOTORISTA')     := vPropVeicMot.Motorista;
                                        P_LISTADADOS(i).linha('MOTCPF')        := vPropVeicMot.Cpfmot;
                                        P_LISTADADOS(i).linha('CODIGOFROTAAGREG') := 'FROTA - ' || vPropVeicMot.frt_conjveiculo_codigo;
                                        -- Se FROTA SERÁ COLOCADO COMO VIAGEM
                                        P_LISTADADOS(i).linha('CIOT')          := '/- Viagem : ' ||  vCIOT;
                                        P_LISTADADOS(i).linha('OBSANTT1') := '';
                                        P_LISTADADOS(i).linha('OBSANTT2') := '';
                                        
                                    End loop;
                      
                      End If;

            
            P_LISTADADOS(i).linha('LOCCARGA')      := tpLinhaValeFrete.Con_Valefrete_Localcarreg;
            P_LISTADADOS(i).linha('LOCDESCARGA')   := tpLinhaValeFrete.Con_Valefrete_Localdescarga;
            P_LISTADADOS(i).linha('QTDEENTREGAS')  := tpLinhaValeFrete.Con_Valefrete_Entregas;
            P_LISTADADOS(i).linha('KMPREVISTA')    := tpLinhaValeFrete.Con_Valefrete_Kmprevista;
            P_LISTADADOS(i).linha('QTDDOC')        := trim(to_char(vQtdeDoc)) || ' DANFE ' || trim(to_char(vQtedeDANFE));
            P_LISTADADOS(i).linha('PSREAL')        := 'PI:' || tpLinhaValeFrete.Con_Valefrete_Pesoindicado;
--            P_LISTADADOS(i).linha('PSLOTACAO')     := tpLinhaValeFrete.Con_Valefrete_Pesocobrado
            P_LISTADADOS(i).linha('PSCONTRATADO')  := 'PC:' || tpLinhaValeFrete.Con_Valefrete_Pesocobrado;
            P_LISTADADOS(i).linha('VERBASA1')      := null;
            P_LISTADADOS(i).linha('VALORA1')       := null;           

            If vVlrTarifa = 0 Then
               P_LISTADADOS(i).linha('VERBASA2')      := null; --'FRETE';
               P_LISTADADOS(i).linha('VALORA2')       := null; -- nvl(tpLinhaValeFrete.Con_Valefrete_Frete,0);
               P_LISTADADOS(i).linha('VERBASA3')      := 'ADIANTAMENTO';
               -- Thiago 21/08/2019 Verifica tipo de motorista se for Frota tira cálculo do pedágio               
               If  vTipoMotorista = 'FROTA' Then
                  P_LISTADADOS(i).linha('VALORA3')       := nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0);
               Else
                  P_LISTADADOS(i).linha('VALORA3')       := nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0) - nvl(tpLinhaValeFrete.Con_Valefrete_Pedagio,0);
               End If;               
            Else
               P_LISTADADOS(i).linha('VERBASA2')      := 'ADIANTAMENTO';
               If nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0) - nvl(tpLinhaValeFrete.Con_Valefrete_Pedagio,0) > 0  Then
                  P_LISTADADOS(i).linha('VALORA2')       := nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0) - nvl(tpLinhaValeFrete.Con_Valefrete_Pedagio,0) - vVlrTarifa;
               Else
                  P_LISTADADOS(i).linha('VALORA2')       := nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0) - nvl(tpLinhaValeFrete.Con_Valefrete_Pedagio,0);
               End If;
               P_LISTADADOS(i).linha('VERBASA3')      := 'TARIFAS';
               P_LISTADADOS(i).linha('VALORA3')       := vVlrTarifa;
            End If;
              -- Thiago 21/08/2019 Verifica tipo de motorista se for Frota não mostra pedágio
              If  vTipoMotorista <> 'FROTA' Then  
                 P_LISTADADOS(i).linha('VERBASA4')      := 'PEDAGIO';
                 P_LISTADADOS(i).linha('VALORA4')       := nvl(tpLinhaValeFrete.Con_Valefrete_Pedagio,0);
              End If;
                 
            P_LISTADADOS(i).linha('VERBASA5')      := null;
            P_LISTADADOS(i).linha('VALORA5')       := null;
            if length(trim(P_LISTADADOS(i).linha('CIOT')))  > 0 Then
               P_LISTADADOS(i).linha('VERBASA6')      := 'PAGO EM CARTAO';
            Else   
               P_LISTADADOS(i).linha('VERBASA6')      := 'TOTAL A PAGAR';
            End If;   
            P_LISTADADOS(i).linha('VALORA6')       := nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0);

            if tpLinhaValeFrete.Con_Valefrete_Valorcomdesconto > 0 Then
               vPosAux := 3;
            Else
               vPosAux := 1;
            End If;   

            If vFrota = 'N' Then
                for vVerbas in (SELECT C.CON_CALCVALEFRETETP_DESCRICAO,
                                       V.CON_CALCVALEFRETE_VALOR,
                                       C.CON_CALCVALEFRETETP_TPLANC,
                                       C.CON_CALCVALEFRETETP_SOMA,
                                       C.CON_CALCVALEFRETETP_TPVERBA,
                                       C.CON_CALCVALEFRETETP_SOMALIQ,
                                       C.CON_CALCVALEFRETETP_CODIGO
                                FROM T_CON_CALCVALEFRETE V,
                                     T_CON_CALCVALEFRETETP C
                                WHERE V.CON_CONHECIMENTO_CODIGO = vCodigo
                                  AND V.CON_CONHECIMENTO_SERIE  = vSerie
                                  AND V.GLB_ROTA_CODIGO         = vRota
                                  AND V.CON_VALEFRETE_SAQUE     = vSaque
                                  AND V.CON_CALCVALEFRETETP_CODIGO = C.CON_CALCVALEFRETETP_CODIGO  
                                  AND C.CON_CALCVALEFRETETP_ATIVO = 'S'
                                  AND V.CON_CALCVALEFRETE_VALOR <> 0
                                  AND c.con_calcvalefretetp_codigo = C.con_calcvalefretetp_codigo
                                  AND c.con_calcvalefretetp_imprime = 'S'
                                order by C.con_calcvalefretetp_ordemimp 
                                )
                loop
                  
                

                   if vVerbas.Con_Calcvalefretetp_Codigo = '05' Then -- Desconto Agregado
                      
                      if (tpLinhaValeFrete.Con_Valefrete_Valorcomdesconto > 0) Then
                         P_LISTADADOS(i).linha('VERBAS01')      := 'Frete Total';
                         P_LISTADADOS(i).linha('VALORVB01')     := nvl(tpLinhaValeFrete.Con_Valefrete_Frete,0) + nvl(tpLinhaValeFrete.con_valefrete_pedagio,0);
                         P_LISTADADOS(i).linha('VERBAS02')      := TRIM(vVerbas.Con_Calcvalefretetp_Descricao);            
                         P_LISTADADOS(i).linha('VALORVB02')     := nvl(vVerbas.Con_Calcvalefrete_Valor,0);
                      End If;
                   
                   Elsif ((vVerbas.Con_Calcvalefretetp_Codigo = '00') and ( vDescontoZerado = 'S' )) then
                   
                         P_LISTADADOS(i).linha('VERBAS01')      := 'Frete Total';
                         P_LISTADADOS(i).linha('VALORVB01')     := nvl(tpLinhaValeFrete.Con_Valefrete_Frete,0) + nvl(tpLinhaValeFrete.con_valefrete_pedagio,0);
                      
                   ElsIf ( tpLinhaValeFrete.Con_Valefrete_Valorcomdesconto > 0 ) and 
                         ( vVerbas.Con_Calcvalefretetp_Codigo = '00' ) Then -- Valor Bruto
                     -- Se for coom Desconto ignora o tipo 00
                     vPosAux := vPosAux; 
                   ElsIf( nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0) - nvl(tpLinhaValeFrete.Con_Valefrete_Pedagio,0) = 0 ) and 
                        ( vVerbas.Con_Calcvalefretetp_Codigo = '01' ) and  -- Adiantamento
                        ( vVlrTarifa > 0 ) Then
                     -- Se Tiver Tarifa e não tiver Adiantamento não imprime a Linha adiantamento
                     vPosAux := vPosAux; 
                   Else
                      P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := TRIM(vVerbas.Con_Calcvalefretetp_Descricao);
                      if vVerbas.Con_Calcvalefretetp_Tplanc = 'C' Then 
                         P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(vVerbas.Con_Calcvalefrete_Valor,0);
                      Else
                         P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(vVerbas.Con_Calcvalefrete_Valor,0) * -1;
                      End If;   
                      vPosAux := vPosAux + 1;
                   End If;   
                end loop;
            Else
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Frete';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Frete,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Adiantamento';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Adiantamento,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Pedagio';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Pedagio,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Estiva';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Valorestiva,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Vazio';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Valorvazio,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Enlonamento';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Enlonamento,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Estadia';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Estadia,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Multa/Desconto';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Multa,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Outros';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Outros,0);
               vPosAux := vPosAux + 1;
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := 'Liquido';
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := nvl(tpLinhaValeFrete.Con_Valefrete_Valorliquido,0);
               vPosAux := vPosAux + 1;
            End If;    
            vContador := vPosAux;
/*   
     -- colocar Regua na Verbas que faltam
            for vPosAux in vContador..25
            loop
               P_LISTADADOS(i).linha('VERBAS' || TRIM(LPAD(vPosAux,2,'0')))  := vRegua;
               P_LISTADADOS(i).linha('VALORVB' || TRIM(LPAD(vPosAux,2,'0'))) := vRegua;
            end loop;
            
*/              

            vGrupoEstadia   := plistaparams('MSG_ESTADIAG').Texto;
                                          
            vClienteEstadia := plistaparams('MSG_ESTADIAC').Texto;
                                          
            vCodEstadia     := tdvadm.pkg_con_valefrete.fn_PegaCodEstadia(vCodigo,vSerie,vRota,vSaque,vClienteEstadia,vGrupoEstadia);
            vOBSEstadia     := plistaparams('MSG_ESTADIA' || vCodEstadia).Texto;
            vMSG_CONTRATADO := plistaparams('MSG_CONTRATADO').texto;
            vOBSContrato    := nvl(vMSG_CONTRATADO, '');
                               /*'Durante o percurso da carga, por motivo de segurança é necessário que '||
                               'o contratado esteja conectado ao app della volpe de posicionamento da carga, '||
                               'mínimo de 3 posiçoes diárias. Caso contrário não haverá pagamento de bônus.';*/

            P_LISTADADOS(i).linha('PRAZO')         := TO_CHAR(tpLinhaValeFrete.Con_Valefrete_Dataprazomax,'DD/MM/YYYY');
            P_LISTADADOS(i).linha('HORA')          := TO_CHAR(tpLinhaValeFrete.Con_Valefrete_Horaprazomax,'HH24:MI');


            i2 := 0;
            if length(trim(tpLinhaValeFrete.Con_Valefrete_Condespeciais)) > 0 Then
               vAuxiliarN := trunc(length(tpLinhaValeFrete.Con_Valefrete_Condespeciais) / vTamLinhaCONDESP) + 1 ;
               loop
                 P_LISTADADOS(i).linha('CONDESP' || lpad(i2+1,1,'0') ) := trim(SUBSTR(tpLinhaValeFrete.Con_Valefrete_Condespeciais,(i2 * vTamLinhaCONDESP)+1,vTamLinhaCONDESP));
                 i2 := i2 + 1;
                 exit when vAuxiliarN = i2;
               end loop;
            End If;
              
            iParou := i2 + 1;
            i2 := 0;
            -- fazer Select para pegar o tamanho
            -- Pegar o tamanho das consicoes especiais
            -- colocar na variavel vTamLinhaCONDOBS
            -- Durante o TESTE vamos colocar o abaixo
            vTamLinhaCONDOBS := 190;
            
            if length(trim(vOBSEstadia)) > 0 Then
               vAuxiliarN := trunc(length(vOBSEstadia) / vTamLinhaCONDOBS) + 1 ;
               loop
                 P_LISTADADOS(i).linha('CONDESP' || lpad(iParou+1,1,'0') ) := trim(SUBSTR(vOBSEstadia,(i2 * vTamLinhaCONDOBS)+1,vTamLinhaCONDOBS));
                 i2 := i2 + 1;
                 iParou := iParou + 1;
                 exit when vAuxiliarN = i2;
               end loop;
               iParou := iParou + 1;
--               P_LISTADADOS(i).linha('CONDESP' || lpad(iParou+1,1,'0') ) := '2.O contratado, neste ato, concorda com os valores negociados, aceitando o frete pago de acordo com as especificações deste transporte quanto à quantidade, peso e volumes';
            End If;

            -- Thiago 10/09/2019 - Loop criado para destacar frase em uma nova linha
            iParou := i2 + 1;
            i2 := 0;
            if length(trim(vOBSContrato)) > 0 Then
               vAuxiliarN := trunc(length(vOBSContrato) / vTamLinhaCONDOBS) + 1 ;
               loop
                 P_LISTADADOS(i).linha('CONDESP' || lpad(iParou+1,1,'0') ) := trim(SUBSTR(vOBSContrato,(i2 * vTamLinhaCONDOBS)+1,vTamLinhaCONDOBS));
                 i2 := i2 + 1;
                 iParou := iParou + 1;
                 exit when vAuxiliarN = i2;
               end loop;
               iParou := iParou + 1;
--               P_LISTADADOS(i).linha('CONDESP' || lpad(iParou+1,1,'0') ) := '2.O contratado, neste ato, concorda com os valores negociados, aceitando o frete pago de acordo com as especificações deste transporte quanto à quantidade, peso e volumes';
            End If;


       
            i2 := 0;
            vListaCTeAtivos := 'ATIVOS -> ' || pkg_con_valefrete.fn_ListaAtivos(vCodigo,vSerie,vRota,vSaque);
            if length(trim(vListaCTeAtivos)) > 10 Then
               vAuxiliarN := trunc(length(vListaCTeAtivos) / vTamLinhaDOC) + 1 ;
               loop
                 P_LISTADADOS(i).linha('DOCATIVO' || lpad(i2+1,2,'0') ) := trim(SUBSTR(vListaCTeAtivos,(i2 * vTamLinhaDOC)+1,vTamLinhaDOC));
                 i2 := i2 + 1;
                 exit when vAuxiliarN = i2;
               end loop;
            End If;
              

            iParou := i2;
            i2 := 0;
            vListaCTeAtivos := 'CTe / NFs -> ' || pkg_con_valefrete.fn_ListaCte(vCodigo,vSerie,vRota,vSaque);
            if length(trim(vListaCTeAtivos)) > 13 Then
               vAuxiliarN := trunc(length(vListaCTeAtivos) / vTamLinhaDOC) + 1 ;
               loop
                 P_LISTADADOS(i).linha('DOCATIVO' || lpad(iParou+1,2,'0') ) := trim(SUBSTR(vListaCTeAtivos,(i2 * vTamLinhaDOC)+1,vTamLinhaDOC));
                 i2 := i2 + 1;
                 iParou := iParou + 1;
                 exit when vAuxiliarN = i2;
               end loop;
            End If;
            
            iParou := iParou + 1;
            -- Incluindo as Observações 
            P_LISTADADOS(i).linha('DOCATIVO' || lpad(iParou+1,2,'0') ) := trim(tpLinhaValeFrete.Con_Valefrete_Obrigacoes);

            iParou := iParou + 2;
            -- Colocando as Entregas 
            i2 := 1;
--            vListaEntregas := 'ENTREGAS -> ' || tdvadm.pkg_con_valefrete.fn_ListaClienteEntregas(vCodigo,vSerie,vRota,vSaque,'N',vStatus,vMessage);
            for c_msg in (select ve.entrega,ve.dtagendada,count(*) qtde 
                          from tdvadm.v_con_vfreteentrega ve
                          where ve.vf = vCodigo
                            and ve.rt = vRota
                            and ve.sr = vSerie
                            and ve.sq = vSaque
                          group by ve.entrega,ve.dtagendada
                          order by ve.dtagendada,ve.entrega)
            Loop
               If i2 = 1 then
                  P_LISTADADOS(i).linha('DOCATIVO' || lpad(iParou+1,2,'0') ) := 'Entregas - ' || lpad(i2,2,'0') || '-' || rpad(c_msg.entrega,30) || ' - ' || c_msg.dtagendada || ' - Qtde - ' || to_char(c_msg.qtde) ;
               Else 
                  P_LISTADADOS(i).linha('DOCATIVO' || lpad(iParou+1,2,'0') ) := rpad('-',15) || '- ' || lpad(i2,2,'0') || '-' || rpad(c_msg.entrega,30) || ' - ' || c_msg.dtagendada || ' - Qtde - ' || to_char(c_msg.qtde);
               End If;
               i2 := i2 + 1;
               iParou := iParou + 1;
            End Loop;

--            P_LISTADADOS(i).linha('DOCATIVO' || lpad(iParou+1,2,'0') ) := trim(vListaEntregas);

            

            P_LISTADADOS(i).linha('CONTRATO01')    := 'CONTRATO DE TRANSPORTE RODOVIÁRIO DE BENS - CONDIÇÕES GERAIS';
            P_LISTADADOS(i).linha('CONTRATO02')    := 'CONTRATO PARTICULAR DE TRANSPORTE RODOVIÁRIO DE BENS,(CARGAS) QUE ENTRE SI, FAZEM A CONTRATANTE TRANSPORTES DELLA VOLPE S/A COMÉRICIO E INDÚSTRIA, E O';
            P_LISTADADOS(i).linha('CONTRATO03')    := 'CONTRATADO IDENTIFICADO PRESENTE INSTRUMENTO, SOB AS CLÁUSULAS E CONDIÇÕES A SEGUIR:';
            P_LISTADADOS(i).linha('CONTRATO04')    := '1. O OBJETO DO PRESENTE CONTRATO É A REALIZAÇÃO DA PRESTAÇÃO DOS SERVIÇOS DE TRANSPORTE RODOVIÁRIO DE BENS (CARGAS) DOS MATERIAIS ENTREGUES PELA CONTRATANTE AO CONTRATADO, AMBOS';
            P_LISTADADOS(i).linha('CONTRATO05')    := '   IDENTIFICADOS NO ANVERSO DO PRESENTE CONTRATO';
            P_LISTADADOS(i).linha('CONTRATO06')    := '2. DAS OBRIGAÇÕES E RESPONSABILIDADES DA CONTRATANTE';
            P_LISTADADOS(i).linha('CONTRATO07')    := '   2.1 - FORNECER AO CONTRATADO TODA A DOCUMENTAÇÃO DA MERCADORIA A SER TRANSPORTADA, BEM COMO A DOCUMENTAÇÃO RELATIVA AO TRANSPORTE, TUDO EM CONFORMIDADE COM A LEGISLAÇÃO PERTINENTE EM VIGOR.';
            P_LISTADADOS(i).linha('CONTRATO08')    := '   2.2 - ASSUMIR O ÔNUS E A RESPONSABILIDADE DO SEGURO OBRIGATÓRIO DE CARGAS:';
            P_LISTADADOS(i).linha('CONTRATO09')    := '   2.3 - EFETUAR O PAGAMENTO CONTRA A APRESENTAÇÃO DAS VIAS EXIGIDAS, DO VALOR LÍQUIDO CONSTANTE NO ANVERSO DESTE, DO RECIBO DE QUITAÇÃO REFERENTE A PRESTAÇÃO DOS SERVIÇOS CONTRATADOS.';
            P_LISTADADOS(i).linha('CONTRATO10')    := '3. DAS OBRIGAÇÕES E RESPONSABILIDADES DO(A) CONTRATADO(A)';
            P_LISTADADOS(i).linha('CONTRATO11')    := '   3.1 - CONSERVAR OS MATERIAIS QUE LHE SÃO CONFIADOS PARA O TRANSPORTE NAS MESMAS CONDIÇÕES EM QUE OS RECEBEU;';
            P_LISTADADOS(i).linha('CONTRATO12')    := '   3.2 - COMUNICAR IMEDIATAMENTE A CONTRATANTE QUAISQUER ANORMALIDADES OCORRIDAS DURANTE O TRANSPORTE, USANDO PARA ISTO OS TELEFONES CONSTANTES DO ENVELOPE DENOMINADO PARTICULAR DA DELLA VOLPE, QUE LHE ESTÁ SENDO';
            P_LISTADADOS(i).linha('CONTRATO13')    := '         ENTREGUE:';
--            P_LISTADADOS(i).linha('CONTRATO14')    := '   3.3 - SUJEITAR-SE E CONCORDAR COM OS DESCONTOS DECORRENTES DE QUEBRAS OU AVARIAS COM AS MERCADORIAS TRANSPORTADAS, BEM COMO COM A DIFERENÇA DO PESO FALTANTA NA ENTREGA, QUE EXCEDER AOS LIMITES LEGAIS, CUJOS VALORES';
--            P_LISTADADOS(i).linha('CONTRATO15')    := '         SERÃO DEDUZIDOS A TÍTULO DE REDUÇÃO DO FRETE A PAGAR;';
            P_LISTADADOS(i).linha('CONTRATO14')    := '   3.3 - RESSARCIR A CONTRATANTE  EM  CASOS  DE QUEBRAS OU AVARIAS COM  AS  MERCADORIAS TRANSPORTADAS, BEM COMO FALTA E/OU EXTRAVIO DE MERCADORIA NA ENTREGA. ALÉM DE MULTAS POR EXCESSO DE PESO. OS VALORES ENVOLVIDOS';
            P_LISTADADOS(i).linha('CONTRATO15')    := '         SERÃO DESCONTADOS DO SALDO DE FRETE A PAGAR PELA  CONTRATANTE AO CONTRATADO';
            P_LISTADADOS(i).linha('CONTRATO16')    := '   3.4 - COMPROMISSO DE RECEBER O SALDO DO FRETE CONSTANTE NESTE CONTRATO JUNTO À MATRIZ OU FILIAIS ATÉ O QUINTO DIA ÚTIL, APÓS A ENTREGA DA MERCADORIA AO DESTINATÁRIO; CASO VENHA A RECEBER APÓS O ';
            P_LISTADADOS(i).linha('CONTRATO17')    := '         QUINTO DIA E ATÉ O DÉCIMO DIA, SERÁ DESCONTADO DO CONTRATADO, VALOR EQUIVALENTE A 15% DO FRETE BRUTO CONTRATADO, E APÓS O DÉCIMO DIA, HAVERÁ UM DESCONTO DE 25% DO FRETE BRUTO CONTRATADO;';
            P_LISTADADOS(i).linha('CONTRATO18')    := '   3.5 - TODAS AS DESPESAS DECORRENTES DOS SERVIÇOS ORA CONTRATADOS SERÃO POR CONTA E RESPONSABILIDADE DO CONTRATADO - TCA, INCLUSIVE ENCARGOS SOCIAIS, TRABALHISTAS, PREVIDENCIÁRIOS, COMBUSTÍVEIS, PNEUS, MANUTENÇÃO, ';
            P_LISTADADOS(i).linha('CONTRATO19')    := '         REPAROS E ETC.';
            P_LISTADADOS(i).linha('CONTRATO20')    := '   3.6 - CONDIÇÕES DE PAGAMENTO DE ESTADIAS NOS TERMOS DA LEI Nº 11.442/07, CONFORME PACTUADO E DESCRITO NO CAMPO OBSERVAÇÕES.';
            P_LISTADADOS(i).linha('CONTRATO21')    := '   3.7 - O PRESENTE CONTRATO É DE ORDEM COMERCIAL, ASSIM, CASO O CONTRATADO CHEGUE FORA DA DATA INDICADA PELO CLIENTE DA CONTRATANTE, APLICAR-SE-Á AO CONTRATADO MULTA DE 20% (VINTE POR CENTO) SOBRE O VALOR DO FRETE,';
            P_LISTADADOS(i).linha('CONTRATO22')    := '         CONSIDERANDO PARA TANTO, O HORÁRIO DE CHEGADA NA CÉLULA FISCAL, COMPREENDIDO ENTRE 07:30 ATÉ 14:00 HORAS. DEMAIS DESTINOS QUE NÃO SEJA CÉLULA FISCAL, HORÁRIO ENTRE 07:30 ATÉ 15:00 HORAS.';
            P_LISTADADOS(i).linha('CONTRATO23')    := '   3.8 - APRESENTAR PARA RECEBIMENTO DO SALDO LÍQUIDO DO FRETE A 1ª E 3ª VIAS DESTE, ACOMPANHADO DA VIA COMPROVANTE DE ENTREGA DO CONHECIMENTO DE TRANSPORTE, CANHOTOS DE NOTAS FISCAIS E OUTROS DOCUMENTOS EXIGIDOS PELOS';
            P_LISTADADOS(i).linha('CONTRATO24')    := '         CLIENTES DA CONTRATANTE';
            P_LISTADADOS(i).linha('CONTRATO25')    := '4. E ASSIM, POR ESTAREM JUSTOS E CONTRATADOS. FIRMAM O PRESENTE CONTRATO NO ANVERSO DESTE, ELEGENDO O FORO DE SÃO PAULO, ESTADO DE SÃO PAULO, PARA DIRIMIR AS DÚVIDAS DO MESMO.';


 
--           i:= -1;  
           i := i + 1;
            if ( i = -1) or ( i > 2 ) Then
              Exit;
            End if;  
        end loop;   

  End SP_RETDADOVALEFRETE;                              


  procedure  SP_GLB_RETORNAPCL(P_XMLIN    In VARCHAR2,
                               P_ARQOUTT  In Out Clob,
                               P_ARQOUTB  Out Blob,
                               P_STATUS   OUT CHAR,
                               P_MESSAGE  OUT VARCHAR2)

    as   
     plistaparams glbadm.pkg_listas.tlistausuparametros;
     vPCL                tdvadm.t_glb_pcl.glb_pcl_codigo%type;
     vPCLVersao          tdvadm.t_glb_pcl.glb_pcl_versao%type;
     vUsuarioTDV         tdvadm.t_usu_usuario.usu_usuario_codigo%type;
     vRotaUsuarioTDV     tdvadm.t_usu_usuario.glb_rota_codigo%type;
     vAplicacaoTDV       tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type;
     vVersaoAplicacao    tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
     vProcedureAplicacao varchar2(50);
     vContador           number;
     i                   number;
     iSequencia          number;
     vExecutar           varchar2(2000);
     vComando            varchar2(50);
     vDados              varchar2(2000);
     vTeste              char(1);
     vAuxiliar           number;
     vDiarioBordo        char(1);
     
     vCodigoVF t_con_valefrete.con_conhecimento_codigo%Type;
     vSerie    t_con_valefrete.con_conhecimento_serie%Type;
     vRota     t_con_valefrete.glb_rota_codigo%Type;
     vSaque    t_con_valefrete.con_valefrete_saque%Type;
     tpAudit   tdvadm.t_grd_audit%rowtype;
     v_ARQOUTB blob;
   Begin

-- Negar durante os testes
--   vTeste := 'S';
   

   -- exemplo fatura
IF P_XMLIN = 'FATURA' Then
   vXmlin := '';
   vXmlin := vXmlin || '<Parametros> ';
   vXmlin := vXmlin || '   <Input> ';
   vXmlin := vXmlin || '      <PCL>FATURA</PCL> ';
   vXmlin := vXmlin || '      <PCLVersao>' || c_VersaoFatura ||'</PCLVersao> ';
   vXmlin := vXmlin || '      <Codigo>054036</Codigo> ';
   vXmlin := vXmlin || '      <Serie></Serie> ';
   vXmlin := vXmlin || '      <Rota>015</Rota> ';     
   vXmlin := vXmlin || '      <Saque></Saque> ';     
   vXmlin := vXmlin || '      <Ciclo>1</Ciclo> ';  
   vXmlin := vXmlin || '      <DiarioBordo>N</DiarioBordo> ';
   vXmlin := vXmlin || '      <Capa>S</Capa> ';  
   vXmlin := vXmlin || '      <UsuarioTDV>jsantos</UsuarioTDV> ';
   vXmlin := vXmlin || '      <RotaUsuarioTDV>010</RotaUsuarioTDV> ';
   vXmlin := vXmlin || '      <Aplicacao>comfatura</Aplicacao> ';
   vXmlin := vXmlin || '      <VersaoAplicao>13.1.23.1</VersaoAplicao> ';
   vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
   vXmlin := vXmlin || '   </Input> ';
   vXmlin := vXmlin || '</Parametros> ';
ElsIF P_XMLIN = 'VALEFRETEF' Then
   -- exemplo Vale de Frete
   vXmlin := '';
   vXmlin := vXmlin || '<Parametros> ';
   vXmlin := vXmlin || '   <Input> ';
   vXmlin := vXmlin || '      <PCL>VALEFRETE</PCL> ';
   vXmlin := vXmlin || '      <PCLVersao>' || c_VersaoValeFrete || '</PCLVersao> ';
   vXmlin := vXmlin || '      <Codigo>029914</Codigo> ';
   vXmlin := vXmlin || '      <Serie>A0</Serie> ';
   vXmlin := vXmlin || '      <Rota>530</Rota> ';     
   vXmlin := vXmlin || '      <Saque>1</Saque> ';     
   vXmlin := vXmlin || '      <Ciclo></Ciclo> ';  
   vXmlin := vXmlin || '      <DiarioBordo>S</DiarioBordo> ';
   vXmlin := vXmlin || '      <UsuarioTDV>jsantos</UsuarioTDV> ';
   vXmlin := vXmlin || '      <RotaUsuarioTDV>010</RotaUsuarioTDV> ';
   vXmlin := vXmlin || '      <Aplicacao>comvlfrete</Aplicacao> ';
   vXmlin := vXmlin || '      <VersaoAplicao>13.1.23.1</VersaoAplicao> ';
   vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
   vXmlin := vXmlin || '   </Input> ';
   vXmlin := vXmlin || '</Parametros> ';
ElsIF P_XMLIN = 'VALEFRETEA' Then
   -- exemplo Vale de Frete
   vXmlin := '';
   vXmlin := vXmlin || '<Parametros> ';
   vXmlin := vXmlin || '   <Input> ';
   vXmlin := vXmlin || '      <PCL>VALEFRETE</PCL> ';
   vXmlin := vXmlin || '      <PCLVersao>' || c_VersaoValeFrete || '</PCLVersao> ';
   vXmlin := vXmlin || '      <Codigo>574018</Codigo> ';
   vXmlin := vXmlin || '      <Serie>A1</Serie> ';
   vXmlin := vXmlin || '      <Rota>021</Rota> ';     
   vXmlin := vXmlin || '      <Saque>1</Saque> ';     
   vXmlin := vXmlin || '      <Ciclo></Ciclo> ';  
   vXmlin := vXmlin || '      <DiarioBordo>S</DiarioBordo> ';
   vXmlin := vXmlin || '      <UsuarioTDV>jsantos</UsuarioTDV> ';
   vXmlin := vXmlin || '      <RotaUsuarioTDV>010</RotaUsuarioTDV> ';
   vXmlin := vXmlin || '      <Aplicacao>comvlfrete</Aplicacao> ';
   vXmlin := vXmlin || '      <VersaoAplicao>13.1.23.1</VersaoAplicao> ';
   vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
   vXmlin := vXmlin || '   </Input> ';
   vXmlin := vXmlin || '</Parametros> ';
ElsIF substr(P_XMLIN,1,10) = 'VALEFRETEC' Then
   -- exemplo Vale de Frete
   vXmlin := '';
   vXmlin := vXmlin || '<Parametros> ';
   vXmlin := vXmlin || '   <Input> ';
   vXmlin := vXmlin || '      <PCL>VALEFRETE</PCL> ';
   vXmlin := vXmlin || '      <PCLVersao>' || c_VersaoValeFrete || '</PCLVersao> ';
   vXmlin := vXmlin || '      <Codigo>015831</Codigo> ';/*850816*/
   vXmlin := vXmlin || '      <Serie>A1</Serie> ';
   vXmlin := vXmlin || '      <Rota>198</Rota> ';/*021*/     
   vXmlin := vXmlin || '      <Saque>1</Saque> ';     
   vXmlin := vXmlin || '      <Ciclo></Ciclo> ';  
   vXmlin := vXmlin || '      <DiarioBordo>S</DiarioBordo> ';
   vXmlin := vXmlin || '      <UsuarioTDV>jsantos</UsuarioTDV> ';
   vXmlin := vXmlin || '      <RotaUsuarioTDV>010</RotaUsuarioTDV> ';
   vXmlin := vXmlin || '      <Aplicacao>comvlfrete</Aplicacao> ';
   vXmlin := vXmlin || '      <VersaoAplicao>13.1.23.1</VersaoAplicao> ';
   vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
   vXmlin := vXmlin || '   </Input> ';
   vXmlin := vXmlin || '</Parametros> ';
ElsIF P_XMLIN = 'DIARIO' Then
-- DIARIO DE BORDO
   vXmlin := '';
   vXmlin := vXmlin || '<Parametros> ';
   vXmlin := vXmlin || '   <Input> ';
   vXmlin := vXmlin || '      <PCL>DIARIOBORD</PCL> '; --
--   vXmlin := vXmlin || '      <PCLVersao>13.12.23.0</PCLVersao> ';
   vXmlin := vXmlin || '      <PCLVersao>' || c_VersaoDiarioBordo || '</PCLVersao> ';
   vXmlin := vXmlin || '      <Codigo>015938</Codigo> '; --
   vXmlin := vXmlin || '      <Serie>A1</Serie> '; --
   vXmlin := vXmlin || '      <Rota>237</Rota> ';    -- 
   vXmlin := vXmlin || '      <Saque>1</Saque> ';     --
   vXmlin := vXmlin || '      <Ciclo></Ciclo> ';  
   vXmlin := vXmlin || '      <DiarioBordo>S</DiarioBordo> ';
   vXmlin := vXmlin || '      <UsuarioTDV>jsantos</UsuarioTDV> ';
   vXmlin := vXmlin || '      <RotaUsuarioTDV>010</RotaUsuarioTDV> ';
   vXmlin := vXmlin || '      <Aplicacao>comvlfrete</Aplicacao> ';
   vXmlin := vXmlin || '      <VersaoAplicao>13.1.23.1</VersaoAplicao> ';
   vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
   vXmlin := vXmlin || '   </Input> ';
   vXmlin := vXmlin || '</Parametros> ';
   
ElsIF P_XMLIN = 'GERCOLETA' Then
  
   vXmlin := '';
   vXmlin := vXmlin || '<Parametros> ';
   vXmlin := vXmlin || '   <Input> ';
   vXmlin := vXmlin || '     <PCL>GERCOLETA</PCL>';
   vXmlin := vXmlin || '      <PCLVersao>' || c_VersaoGerColeta || '</PCLVersao> ';
   vXmlin := vXmlin || '      <Coleta>020252</Coleta> ';
   vXmlin := vXmlin || '      <Ciclo>003</Ciclo> ';
   vXmlin := vXmlin || '      <UsuarioTDV>jsantos</UsuarioTDV> ';
   vXmlin := vXmlin || '      <RotaUsuarioTDV>010</RotaUsuarioTDV> ';
   vXmlin := vXmlin || '      <Aplicacao>gercoleta</Aplicacao> ';
   vXmlin := vXmlin || '      <VersaoAplicao>13.1.23.1</VersaoAplicao> ';
   vXmlin := vXmlin || '      <ProcedureAplicacao></ProcedureAplicacao> ';
   vXmlin := vXmlin || '   </Input> ';
   vXmlin := vXmlin || '</Parametros> ';
   
End If;  

if instr(P_XMLIN,'MASCARA') > 0 Then
   vTeste := 'M'; -- Somente Mascara
ElsIf length(trim(P_XMLIN)) > 50 Then 
   vTeste := 'N';
   vXmlin := P_XMLIN;  
Else
   vTeste := 'N'; 
End if ;   


   vPCL                := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'PCL' ));
   vPCLVersao          := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'PCLVersao' ));
   vUsuarioTDV         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'UsuarioTDV' ));
   vRotaUsuarioTDV     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'RotaUsuarioTDV' ));
   vAplicacaoTDV       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Aplicacao' ));
   vVersaoAplicacao    := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'VersaoAplicacao' ));
   vProcedureAplicacao := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'ProcedureAplicacao' ));
   vDiarioBordo        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'DiarioBordo' ));
   vCodigoVF           := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Codigo' ));   
   vSerie              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Serie' ));
   vRota               := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Rota' ));
   vSaque              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin,'Saque' ));         


   P_STATUS  := pkg_glb_common.Status_Nomal;
   P_MESSAGE := 'Processo Normal';
   vListaDados.delete(); 
/*  if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacaoTDV,
                                               vusuarioTDV,
                                               vRotaUsuarioTDV,
                                               plistaparams) Then
                                    
     P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
     P_MESSAGE := P_MESSAGE || '00 - Erro ao Buscar Parametros.' || chr(10);
  End if ;                                 
*/
  
   -- Validando compos Abrigatorios
   if nvl(trim(vPCL),'') = '' Then
      P_STATUS  := pkg_glb_common.Status_Erro;
      P_MESSAGE := 'Codigo do PCL Obrigatorio ' || chr(10);
   end if;       
   
   if vPCL <> 'VFRETEDIAR' Then
      P_ARQOUTT := empty_clob();
   Else
      vPCL := 'DIARIOBORD';
   End If;   
   
   -- Preenchendo quando não passados
   If nvl(trim(vPCLVersao),'N') = 'N' Then
      begin
        select pcl.glb_pcl_versao
          into vPCLVersao
        from t_glb_pcl pcl
        where pcl.glb_pcl_codigo = vPCL
--          and pcl.glb_pcl_sequencia = '0'
          and pcl.glb_pcl_ativo = 'S'
          AND PCL.GLB_PCL_CRIACAO = (SELECT MAX(PCL1.GLB_PCL_CRIACAO)
                                     FROM T_GLB_PCL PCL1
                                     WHERE PCL1.GLB_PCL_CODIGO = PCL.GLB_PCL_CODIGO
                                       AND PCL1.GLB_PCL_ATIVO = 'S');
       exception
         when NO_DATA_FOUND Then
           vPCLVersao := '';
           P_STATUS  := pkg_glb_common.Status_Erro;
           P_MESSAGE := 'Versao do PCL não Encontrada ou Codigo do PCL Errado ' || vPCL || chr(10);
         When OTHERS Then
           vPCLVersao := '';
           P_STATUS  := pkg_glb_common.Status_Erro;
           P_MESSAGE := 'Erro para identificar a Versao do PCL ' || vPCL || ' - erro - ' || sqlerrm + chr(10);
         End;   
   Else
      vContador := 0;
      select count(*)
          into vContador
      from t_glb_pcl pcl
      where pcl.glb_pcl_codigo = vPCL
        and pcl.glb_pcl_versao = vPCLVersao
        and pcl.glb_pcl_ativo = 'S';

      if vContador = 0 Then
         P_STATUS  := pkg_glb_common.Status_Erro;
         P_MESSAGE := 'PCL não Encontrado ou Codigo do PCL Errado -' || vPCL || '-' || vPCLVersao || '-' || chr(10);
      end if;             
   End if;     

   if P_STATUS <> pkg_glb_common.Status_Erro Then 
      vExecutar   := 'begin '|| chr(10) ||
                     ' TDVADM.PKG_GLB_PCL.SP_RETDADO' || vPCL ||'(TDVADM.PKG_GLB_PCL.vXmlin,'     || chr(10) ||
                     '                                            TDVADM.PKG_GLB_PCL.vListaDados,'|| chr(10) ||
                     '                                            TDVADM.PKG_GLB_PCL.vStatus,'    || chr(10) ||
                     '                                            TDVADM.PKG_GLB_PCL.vMessage);  '|| chr(10) ||
                     'end;';
                     
          if vTeste <> 'M' then  -- Diferente de Somente Mascara                          
             execute immediate (vExecutar); 
             P_STATUS := TDVADM.PKG_GLB_PCL.vStatus;
             P_MESSAGE := TDVADM.PKG_GLB_PCL.vMessage || chr(10);
          Else

               Select pcl.glb_pcl_fonteform
                 into vListaDados(1).Fonte
               from t_glb_pcl pcl
               where pcl.glb_pcl_codigo = vPCL
                 and pcl.glb_pcl_versao = c_VersaoValeFrete;  

               for C_LINHA in (select pcl.glb_pcllinha_campo,
                                      pcl.glb_pcllinha_sequencia
                               from t_glb_pcllinha pcl
                          where pcl.glb_pcl_codigo = vPCL
    --                        and pcl.glb_pcl_sequencia = '0'
                            and pcl.glb_pcl_versao = vPCLVersao
                            order by pcl.glb_pcllinha_sequencia,pcl.glb_pcllinha_ordem)
          loop         
               -- preenche a lista vazia         
               vListaDados(C_LINHA.glb_pcllinha_sequencia).Pcl := vPCL;
               vListaDados(C_LINHA.glb_pcllinha_sequencia).Versao := c_VersaoValeFrete;
               vListaDados(C_LINHA.glb_pcllinha_sequencia).Sequencia := 1;
               vListaDados(C_LINHA.glb_pcllinha_sequencia).linha(C_LINHA.glb_pcllinha_campo) := null;
               
          End loop;
          P_STATUS := pkg_glb_common.Status_Nomal;



                 
          End If;
          
      if P_STATUS = pkg_glb_common.Status_Nomal Then
             for C_LINHA in (select pcl.glb_pcl_mascarab
                             from t_glb_pcl pcl
                             where pcl.glb_pcl_codigo = vPCL
    --                           and pcl.glb_pcl_sequencia = '0'
                               and pcl.glb_pcl_versao = vPCLVersao
                               and pcl.glb_pcl_ativo = 'S')
             loop                  
                P_ARQOUTB := C_LINHA.glb_pcl_mascarab;
             End loop;
          iSequencia := 1;
          loop

              begin
                -- Testa somente para verificar se existe mais alguma sequeincia a ser impressa
                if vListaDados(iSequencia).Pcl is not null Then
                   i := 0;
                End If;   
              exception
                when NO_DATA_FOUND then
                   exit;
                End;
                  
              for C_LINHA in (select pcl.glb_pcllinha_campo,
                                     pcl.glb_pcllinha_envianulo,
                                     pcl.glb_pcllinha_comando comando,
                                     nvl(pcl.glb_pcllinha_tamanho,30) tamanho,
                                     pcl.glb_pcllinha_eixoy linha,
                                     pcl.glb_pcllinha_eixox coluna,
                                     nvl(ef1.PCL_efeitos_codigo,'00') efeitocodigo1,
                                     nvl(ef1.PCL_efeitos_comandoi,'') efeitoi1,
                                     nvl(ef1.PCL_efeitos_comandof,'') efeitof1,
                                     nvl(ef2.PCL_efeitos_codigo,'00') efeitocodigo2,
                                     nvl(ef2.PCL_efeitos_comandoi,'') efeitoi2,
                                     nvl(ef2.PCL_efeitos_comandof,'') efeitof2,
                                     nvl(ef3.PCL_efeitos_codigo,'00') efeitocodigo3,
                                     nvl(ef3.PCL_efeitos_comandoi,'') efeitoi3,
                                     nvl(ef3.PCL_efeitos_comandof,'') efeitof3,
                                     nvl(m.glb_mascara_codigo,'00') mascaracodigo,
                                     trim(nvl(m.glb_mascara_mascara,'')) mascara,
                                     nvl(pr.glb_preenche_codigo,'00') preenchecodigo,
                                     trim(nvl(pr.glb_preenche_caracter,'')) preenchecar,
                                     trim(nvl(pr.glb_preenche_alinhamento,'')) preencheali,
                                     (select f.pcl_fontes_comando || chr(27) || '(s' || f.pcl_fontes_codigo || 
                                                                                        decode(nvl(tr.pcl_fontestraco_codigo,'X'),'X','','t' || tr.pcl_fontestraco_codigo) || 
                                                                                        decode(nvl(e.pcl_fontesestilo_codigo,'X'),'X','','b' || e.pcl_fontesestilo_codigo) || 
                                                                                        decode(nvl(ta.pcl_fontestam_codigo,  'X'),'X','','s' || replace(trim(to_char(to_number(ta.pcl_fontestam_codigo),'90.00')),'18.46','18.46h0')) || 
                                                                                        decode(nvl(ec.pcl_fontesec_codigo,   'X'),'X','','v' || ec.pcl_fontesec_codigo) ||
                                                                                        'P' Fonte
                                      from t_pcl_fontes f,
                                           t_pcl_fontesestilo e,
                                           t_pcl_fontestam ta, 
                                           t_pcl_fontestraco tr,
                                           T_PCL_FONTESEC ec
                                      where 0 = 0
                                        and f.pcl_fontes_codigo = e.pcl_fontes_codigo
                                        and f.pcl_fontes_codigo = ta.pcl_fontes_codigo (+)
                                        and f.pcl_fontes_codigo = ec.pcl_fontes_codigo (+)
                                        and f.pcl_fontes_codigo = tr.pcl_fontes_codigo (+)
                                        and f.pcl_fontes_codigo (+) = pcl.pcl_fontes_codigo 
                                        and e.pcl_fontes_codigo (+) = pcl.pcl_fontes_codigo 
                                        and e.pcl_fontesestilo_codigo (+) = pcl.pcl_fontesestilo_codigo 
                                        and ta.pcl_fontes_codigo (+) = pcl.pcl_fontes_codigo
                                        and ta.pcl_fontestam_codigo (+) = pcl.pcl_fontestam_codigo
                                        and tr.pcl_fontes_codigo (+) = pcl.pcl_fontes_codigo
                                        and tr.pcl_fontestraco_codigo (+) = pcl.pcl_fontestraco_codigo
                                        and ec.pcl_fontes_codigo (+) = pcl.pcl_fontes_codigo
                                        and ec.pcl_fontesec_codigo (+) = pcl.pcl_fontesec_codigo) Fonte
                              from t_glb_pcl pc,
                                   t_glb_pcllinha pcl,
                                   t_PCL_efeitos ef1,
                                   t_PCL_efeitos ef2,
                                   t_PCL_efeitos ef3,
                                   t_glb_mascara m,
                                   t_glb_preenche pr
                                  where 0 = 0
                                    and pc.glb_pcl_codigo = vListaDados(iSequencia).Pcl
                                    and pc.glb_pcl_versao = vListaDados(iSequencia).Versao
                                    and pc.glb_pcl_codigo = pcl.glb_pcl_codigo
                                    and pc.glb_pcl_versao = pcl.glb_pcl_versao
                                    and pcl.glb_pcllinha_sequencia = vListaDados(iSequencia).Sequencia
                                    and pcl.PCL_efeitos_codigo1  = ef1.PCL_efeitos_codigo (+)
                                    and pcl.PCL_efeitos_codigo2  = ef2.PCL_efeitos_codigo (+)
                                    and pcl.PCL_efeitos_codigo3  = ef3.PCL_efeitos_codigo (+)
                                    and pcl.glb_preenche_codigo = pr.glb_preenche_codigo (+)
                                    and pcl.glb_mascara_codigo  = m.glb_mascara_codigo (+)
                                  order by pcl.glb_pcllinha_sequencia,pcl.glb_pcllinha_ordem)   
                loop
                  begin
                  
                  if  c_linha.glb_pcllinha_campo = 'Linha28' then
                    c_linha.glb_pcllinha_campo := c_linha.glb_pcllinha_campo;
                  end if;
                  
                  
                   if c_linha.glb_pcllinha_campo = 'CODBARRA' Then 
                      i := i;
                   End If;
                  i := i + 1;
                  vComando := '';
                  if i = 2 Then -- Depois da Assinatura do PCL
                     P_ARQOUTT := P_ARQOUTT || vListaDados(iSequencia).Fonte || chr(13) || chr(10);
                  End if;   
                  if c_linha.coluna <> 0 then  
                     vComando := c_linha.comando || trim(to_char(c_linha.coluna)) || 'x' || trim(to_char(c_linha.linha)) || 'Y';
                  Else
                     vComando := c_linha.comando ;
                  End if ;
                  -- Caso De NO_DATA_FOUND aqui e porque acabou os Registros
                     vDados := substr(vListaDados(iSequencia).Linha(c_linha.glb_pcllinha_campo),1,c_linha.tamanho);

                     if  vDados is not null Then
                        If c_linha.mascaracodigo = '01' Then -- Telefone
                           vDados := vDados;
                        ElsIf c_linha.mascaracodigo = '02' Then -- CNPJ
                           vDados := f_mascara_cgccpf(trim(vDados));
                        ElsIf c_linha.mascaracodigo = '03' Then -- CEP
                           vDados := rpad(trim(vDados),10,'0');
                           vDados := substr(vDados,1,5) || '-' || substr(vDados,-3,3);
                        ElsIf c_linha.mascaracodigo <> '00' Then
                           if ( c_linha.mascara is not null ) Then
                              -- Tenta converter para numero se der erro deixa passar o dado como veio.
                              begin
                                if c_linha.glb_pcllinha_campo = 'CTRCVALOR001' Then
                                  vAuxiliar := to_number(vDados);
                                End if ;
                                vAuxiliar := to_number(vDados);
                                vDados :=  rpad(trim(replace(replace(replace(to_char(nvl(vDados,0),c_linha.mascara),',','*'),'.',','),'*','.')),c_linha.tamanho) ;
                              exception
                                when OTHERS Then
                                    vDados := vDados;
                                End;
                           End if;
                        End if;   

                        if c_linha.preencheali = 'D' then
                           vDados := rpad(trim(vDados),c_linha.tamanho,nvl(c_linha.preenchecar,' '));
                        Elsif c_linha.preencheali = 'E' then
                           vDados := lpad(trim(vDados),c_linha.tamanho,nvl(c_linha.preenchecar,' '));
                        Elsif c_linha.preencheali = 'C' then
                           vDados := rpad(lpad(trim(vDados),c_linha.tamanho/2,nvl(c_linha.preenchecar,' ')),c_linha.tamanho/2,nvl(c_linha.preenchecar,' '));
                        Elsif c_linha.preencheali = 'TD' then
                           vDados := rtrim(vDados);
                        Elsif c_linha.preencheali = 'TE' then
                           vDados := ltrim(vDados);
                        Elsif c_linha.preencheali = 'TA' then
                           vDados := trim(vDados);
                        Else
                           vDados := vDados;
                        End if;                       

--                        if c_linha.fonte is not null Then
--                           P_ARQOUTT := P_ARQOUTT || c_linha.fonte;
--                        End if;

                        -- Se houve algum efeito volta a Fonte do Formulario
                        if c_linha.fonte is not null Then
                           P_ARQOUTT := P_ARQOUTT || to_char( vComando || 
                                                              c_linha.efeitoi3 || 
                                                              c_linha.efeitoi2 || 
                                                              c_linha.efeitoi1 || 
                                                              c_linha.fonte    ||
                                                              vDados || 
                                                              vListaDados(iSequencia).Fonte ||
                                                              c_linha.efeitof1 || 
                                                              c_linha.efeitof2 || 
                                                              c_linha.efeitof3 ) || chr(13) || chr(10);
                       
                       Else
                           P_ARQOUTT := P_ARQOUTT || to_char( vComando || 
                                                              c_linha.efeitoi3 || 
                                                              c_linha.efeitoi2 || 
                                                              c_linha.efeitoi1 || 
                                                              vDados || 
                                                              c_linha.efeitof1 || 
                                                              c_linha.efeitof2 || 
                                                              c_linha.efeitof3 ) || chr(13) || chr(10);
                         
                       End if; 
                     Else  
                        -- Se for teste envia o nome da coluna para o PCL
                        if  ( vTeste <> 'N' ) and ( C_LINHA.glb_pcllinha_envianulo = 'N' ) Then 
                            vDados := c_linha.glb_pcllinha_campo;
--                            if c_linha.fonte is not null Then
--                               P_ARQOUTT := P_ARQOUTT || c_linha.fonte;
--                            End if;

                        if c_linha.fonte is not null Then
                           P_ARQOUTT := P_ARQOUTT || to_char( vComando || 
                                                              c_linha.efeitoi3 || 
                                                              c_linha.efeitoi2 || 
                                                              c_linha.efeitoi1 || 
                                                              c_linha.fonte    ||
                                                              vDados || 
                                                              vListaDados(iSequencia).Fonte ||
                                                              c_linha.efeitof1 || 
                                                              c_linha.efeitof2 || 
                                                              c_linha.efeitof3 ) || chr(13) || chr(10);
                       
                       Else
                           P_ARQOUTT := P_ARQOUTT || to_char( vComando || 
                                                              c_linha.efeitoi3 || 
                                                              c_linha.efeitoi2 || 
                                                              c_linha.efeitoi1 || 
                                                              vDados || 
                                                              c_linha.efeitof1 || 
                                                              c_linha.efeitof2 || 
                                                              c_linha.efeitof3 ) || chr(13) || chr(10);
                         
                       End if; 
                          
                        End if;  
                        
                        if C_LINHA.glb_pcllinha_envianulo = 'S' Then
                           P_ARQOUTT := P_ARQOUTT || to_char(TRIM(vComando || 
                                                                  c_linha.efeitoi3 || 
                                                                  c_linha.efeitoi2 || 
                                                                  c_linha.efeitoi1 || 
                                                                  c_linha.efeitof1 || 
                                                                  c_linha.efeitof2 || 
                                                                  c_linha.efeitof3 )) || chr(13) || chr(10);
                        End if;
                     End If;      
                  exception
                    when NO_DATA_FOUND Then
                        -- Se for teste envia o nome da coluna para o PCL
                        if ( vTeste <> 'N' ) and ( C_LINHA.glb_pcllinha_envianulo = 'N' ) Then 
                            vDados := c_linha.glb_pcllinha_campo;
--                            if c_linha.fonte is not null Then
--                               P_ARQOUTT := P_ARQOUTT || c_linha.fonte;
--                            End If;                            
                        if c_linha.fonte is not null Then
                           P_ARQOUTT := P_ARQOUTT || to_char( vComando || 
                                                              c_linha.efeitoi3 || 
                                                              c_linha.efeitoi2 || 
                                                              c_linha.efeitoi1 || 
                                                              c_linha.fonte    ||
                                                              vDados || 
                                                              vListaDados(iSequencia).Fonte ||
                                                              c_linha.efeitof1 || 
                                                              c_linha.efeitof2 || 
                                                              c_linha.efeitof3 ) || chr(13) || chr(10);
                       
                       Else
                           P_ARQOUTT := P_ARQOUTT || to_char( vComando || 
                                                              c_linha.efeitoi3 || 
                                                              c_linha.efeitoi2 || 
                                                              c_linha.efeitoi1 || 
                                                              vDados || 
                                                              c_linha.efeitof1 || 
                                                              c_linha.efeitof2 || 
                                                              c_linha.efeitof3 ) || chr(13) || chr(10);
                         
                       End if; 
                          
                        End if;  
                       if C_LINHA.glb_pcllinha_envianulo = 'S' Then
                          P_ARQOUTT := P_ARQOUTT || to_char(TRIM(vComando || 
                                                                 c_linha.efeitoi3 || 
                                                                 c_linha.efeitoi2 || 
                                                                 c_linha.efeitoi1 || 
                                                                 c_linha.efeitof1 || 
                                                                 c_linha.efeitof2 || 
                                                                 c_linha.efeitof3  )) || chr(13) || chr(10);
                       End If;   
                    end;
                end loop; 
                

                If i = -1 Then -- Acabou os registros   
                   exit;
                Else
                   iSequencia := iSequencia + 1;
                end if;  
          end loop;     
      End if;    
   End if; 
   
   if (vPCL = 'DIARIOBORD') and (P_STATUS = pkg_glb_common.Status_Nomal) then
       Begin
        if pkg_con_valefrete.fn_DiarioBordoEmitido(vCodigoVF,
                                                   vSerie,
                                                   vRota,
                                                   vSaque) = 'L' Then
         
           tpAudit.Uti_Audit_Tabela        := 'DIARIOBORDO';
           tpAudit.Uti_Audit_Acao          := 'IMPRIMIR';
           tpAudit.Uti_Audit_Valoranterior := 'Não Impresso' || '-' || vCodigoVF || '-' || vSerie || '-' || vRota || '-' || vSaque  ;
           tpAudit.Uti_Audit_Valoratual    := 'Impresso';
           tpAudit.Uti_Audit_Datagravacao  := sysdate;
           select a.terminal,
                  a.ip_address,
                  a.PROGRAM,
                  a.os_user,
                  a.terminal       
             into tpAudit.Uti_Audit_Terminal,
                  tpAudit.Uti_Audit_User,
                  tpAudit.Uti_Audit_Programa,
                  tpAudit.Uti_Audit_Ouser,
                  tpAudit.Uti_Audit_Maquina
           from v_glb_ambiente a;
          insert into t_grd_audit a
          values tpAudit;
         End If;            
          
        Update t_con_valefrete v
           set v.con_valefrete_diariobordo = 'S'
         where v.con_conhecimento_codigo = vCodigoVF
           and v.con_conhecimento_serie = vSerie
           and v.glb_rota_codigo = vRota
           and v.con_valefrete_saque = vSaque;
        commit;   
       Exception
         When Others Then
           P_STATUS  := 'E';
           P_MESSAGE := 'Erro ao Atualizar Vale Frete para Emitido a Impressão do Diario de Bordo: ' || sqlerrm;
           Rollback;
       End;
   end if;
   
   
 --   insert into dropme(a,l) values('FATURA', P_ARQOUT); commit;
   End SP_GLB_RETORNAPCL;

  procedure  SP_GLB_RETORNAPCL_SEMMASC(P_XMLIN    In VARCHAR2,
                                       P_ARQOUTT  Out Clob,
                                       P_STATUS   OUT CHAR,
                                       P_MESSAGE  OUT VARCHAR2)

    as   
    
    v_ARQOUTT blob;

   Begin
        SP_GLB_RETORNAPCL(P_XMLIN,
                          P_ARQOUTT,
                          v_ARQOUTT,
                          P_STATUS,
                          P_MESSAGE);
   
  End SP_GLB_RETORNAPCL_SEMMASC;

  procedure  SP_GLB_RETORNAPCL_SOMASC(P_XMLIN    In VARCHAR2,
                                      P_ARQOUTT  Out blob,
                                      P_STATUS   OUT CHAR,
                                      P_MESSAGE  OUT VARCHAR2)

    as   
    
    v_ARQOUTT clob;

   Begin
        SP_GLB_RETORNAPCL(P_XMLIN,
                          v_ARQOUTT,
                          P_ARQOUTT,
                          P_STATUS,
                          P_MESSAGE);
                          
         P_ARQOUTT := glbadm.pkg_glb_blob.f_CLOB2BLOB(v_ARQOUTT,P_ARQOUTT);
   
  End SP_GLB_RETORNAPCL_SOMASC;
  
      procedure SP_RETDADOGERCOLETA(P_XMLIN      In  VARCHAR2,
                                P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                                P_STATUS     OUT CHAR,
                                P_MESSAGE    OUT VARCHAR2)
/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Operacional
* PROGRAMA    : Impressão de Coleta PCL
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 26/06/2020
* BANCO       : ORACLE
* SIGLAS      : ARM, CON, GLB
* DESCRICAO   : Monta a estrutura para impressão da coleta via PCL.
---------------------------------------------------------------------------------------------------
*/

 -- Declaro todas as variáveis que serão utilizadas.
  As
  vFonteDefault       tdvadm.t_glb_pcl.glb_pcl_fonteform%type;
  plistaparams        glbadm.pkg_listas.tlistausuparametros;
  vVersaoCod          tdvadm.t_glb_pcl.glb_pcl_versao%type;
  vPCLCod             tdvadm.t_glb_pcl.glb_pcl_codigo%type;
  -- Variaveis Coleta
  vColeta             tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo              tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
  vArmazem            tdvadm.t_arm_coleta.arm_armazem_codigo%type;
  vRota               tdvadm.t_arm_armazem.glb_rota_codigo%type;
  vDataEmissao        tdvadm.t_arm_coleta.arm_coleta_dtsolicitacao%type;
  vFone               tdvadm.t_arm_coleta.arm_coleta_fonesolic%type;
  vEmail              tdvadm.t_arm_coleta.arm_coleta_emailsolic%type;
  vObsCol             tdvadm.t_Arm_Coleta.arm_coleta_obs%type;
  vNota               tdvadm.t_col_asn.col_asn_numeronfe%type;
  
  -- Variaveis usuarios/aplicacao
  vUsuarioTDV         char(10);
  vRotaUsuarioTDV     char(3);
  vAplicacaoTDV       char(10);
  vVersaoAplicao      char(10);
  
  --Variaveis CIOT
  vCiot               tdvadm.t_con_vfreteciot.con_vfreteciot_numero%type;
  
  --Variaveis de Controle
  vContador           number;
  vControle           integer;
  i                   number;
  vLinha              varchar2(1000);
  
  --Variaveis de Emitente
  vEndFilial      varchar2(100);--tdvadm.t_glb_rota.glb_rota_endereco%type;    
  vBairroFilial   tdvadm.t_glb_rota.glb_rota_procedencia%type;
  vUfFilial       tdvadm.t_glb_rota.glb_estado_codigo%type;
  vCEPFilial      tdvadm.t_glb_rota.glb_rota_cep%type;   
  vIEFilial       tdvadm.t_glb_rota.glb_rota_ie%type;
  vCidadeFilial   tdvadm.t_glb_localidade.glb_localidade_descricao%type;
  vFoneFilial     tdvadm.t_glb_rota.glb_rota_fone%type;
  vCNPJFilial     tdvadm.t_glb_rota.glb_rota_cgc%type;
  vCnae           tdvadm.t_glb_rota.glb_rota_cae%type;
  vPO             tdvadm.t_arm_coleta.arm_coleta_pedido%type;
  
  --Variaveis do Remetente
  vRazSocialRem   tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vEndRem         tdvadm.t_glb_cliend.glb_cliend_endereco%type;
  vCidadeRem      tdvadm.t_glb_cliend.glb_cliend_cidade%type;
  vIERem          tdvadm.t_glb_cliente.glb_cliente_ie%type;
  vCodRem         tdvadm.t_glb_cliend.glb_cliend_codcliente%type;
  vBairroRem      tdvadm.t_glb_cliend.glb_cliend_complemento%type;
  vUFRem          tdvadm.t_glb_cliend.glb_estado_codigo%type;
  vCEPRem         tdvadm.t_glb_cliend.glb_cep_codigo%type;
  vCNPJRem        tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  
  --Variaveis do Destinatario
  vRazSocialDest  tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vEndDest        tdvadm.t_glb_cliend.glb_cliend_endereco%type;
  vCidadeDest     tdvadm.t_glb_cliend.glb_cliend_cidade%type;
  vIEDest         tdvadm.t_glb_cliente.glb_cliente_ie%type;
  vCodDest        tdvadm.t_glb_cliend.glb_cliend_codcliente%type;
  vBairroDest     tdvadm.t_glb_cliend.glb_cliend_complemento%type;
  vUFDest         tdvadm.t_glb_cliend.glb_estado_codigo%type;
  vCEPDest        tdvadm.t_glb_cliend.glb_cep_codigo%type;
  vCNPJDest       tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  
  --Variaveis do Local de coleta
  vRazSocialCol   tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vEndCol         tdvadm.t_glb_cliend.glb_cliend_endereco%type;
  vCidadeCol      tdvadm.t_glb_cliend.glb_cliend_cidade%type;
  vIECol          tdvadm.t_glb_cliente.glb_cliente_ie%type;
  vCodCol         tdvadm.t_glb_cliend.glb_cliend_codcliente%type;
  vBairroCol      tdvadm.t_glb_cliend.glb_cliend_complemento%type;
  vUFCol          tdvadm.t_glb_cliend.glb_estado_codigo%type;
  vCEPCol         tdvadm.t_glb_cliend.glb_cep_codigo%type;
  vCNPJCol        tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vTPEndCol       tdvadm.t_glb_cliend.glb_tpcliend_codigo%type;
  
  --Variaveis da Placa e Motorista
  vPlaca          tdvadm.t_arm_coleta_motorista.arm_coleta_motorista_placa%type;
  vPlacaCarreta   tdvadm.t_arm_coleta_motorista.arm_coleta_motorista_placa%type;
  vPlacaSQ        tdvadm.t_arm_coleta_motorista.arm_coleta_motorista_placasaqu%type;
  vPlaca2         tdvadm.t_arm_coleta_motorista.arm_coleta_placa2%type;
  vPlaca2SQ       tdvadm.t_arm_coleta_motorista.arm_coleta_placa2saque%type;
  vCPFMOT         tdvadm.t_arm_coleta_motorista.arm_coleta_carreteiro%type;
  vMotNome        varchar2(50);
  vRGMot          tdvadm.t_frt_motorista.frt_motorista_rgcodigo%type;
  vCNHMot         tdvadm.t_frt_motorista.frt_motorista_cnhcodigo%type;
  vProntuarioMot  tdvadm.t_frt_motorista.frt_motorista_prontuariocod%type;
  vMarcaModelo    varchar2(70);
  vCidadePlaca    tdvadm.t_frt_veiculo.frt_veiculo_placacidade%type;
  vUFPlaca        tdvadm.t_frt_veiculo.glb_estado_codigo%type;
  vMOTSaque       tdvadm.t_car_carreteiro.car_carreteiro_saque%type;
  vFrota          tdvadm.t_frt_conteng.frt_conjveiculo_codigo%type;
  
  --Variaveis do Proprietario
  vPropCNPJCPF   tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type;
  vPropRazao     tdvadm.t_car_proprietario.car_proprietario_razaosocial%type;
  vPropANTT      tdvadm.t_car_proprietario.car_proprietario_classantt%type;
  vProprietario  tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type;
  vTamanho       integer := 0;
  vQtdeLinhas    number  := 0;
  vLinhaLoop     integer := 1;
  vLengthIni     integer := 1;
  vLengthObs     integer := 135;
  vLengthRodape  integer := 134;
  
  -- barra
  vIdBarra            varchar2(47);
  vRegimeEspecial  tdvadm.t_arm_armazem.arm_armazem_regimeespecial%type;
  begin
  i:= 1; -- Quantidade de Paginas.  
  P_LISTADADOS.delete; 
  P_STATUS  :=  pkg_glb_common.Status_Nomal;
  P_MESSAGE := '';
  
    
       select pcl.glb_pcl_fonteform,
              pcl.glb_pcl_codigo,
              pcl.glb_pcl_versao
         into vFonteDefault,
              vPCLCod,
              vVersaoCod
       from t_glb_pcl pcl
       where pcl.glb_pcl_codigo = 'GERCOLETA'
         and pcl.glb_pcl_versao = '17.1.16.1';
         
            P_LISTADADOS(i).Pcl        := vPCLCod;
            P_LISTADADOS(i).Versao     := vVersaoCod;
            P_LISTADADOS(i).Fonte      := vFonteDefault;
            P_LISTADADOS(i).Sequencia  := '1';
   
  -- Preencho as variáveis inicias com os dados passados no XML.
   vColeta             := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Coleta' ));
   vCiclo              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Ciclo' ));
   vUsuarioTDV         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'UsuarioTDV' ));
   vRotaUsuarioTDV     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'RotaUsuarioTDV' ));
   vAplicacaoTDV       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Aplicacao' ));
   vVersaoAplicao      := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'VersaoAplicao' ));
   vControle           := 1;
   P_STATUS            := 'N';
   vNota               := '0';
   --Verifico se os parâmetros são validos.
     if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacaoTDV,
                                                  vusuarioTDV,
                                                  vRotaUsuarioTDV,
                                                  plistaparams) Then
                                    
     P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
     P_MESSAGE := P_MESSAGE || '00 - Erro ao Buscar Parametros.' || chr(10);
  End if ;

       
       -- Pego os dados da FILIAL EMITENTE
       select trim(fn_limpa_campo(substr(replace(r.glb_rota_endereco,',',''),1,60))) ||'-'|| NVL(trim(r.glb_rota_codcentury),'0'),                                                        
              substr(r.glb_rota_procedencia,1,60),                                                                                                                               
              rpad(trim(r.glb_rota_cep),8,'0'),                                                                 
              r.glb_rota_cgc,
              r.glb_rota_ie,
              lr.glb_localidade_descricao,                                                
              lpad(replace(replace(replace(replace(trim(r.glb_rota_fone),'-',''),'(',''),')',''),' ',''),12,'0'),
              r.glb_estado_codigo,
              r.glb_rota_cae,
              CO.ARM_COLETA_PEDIDO
         into vEndFilial,   
              vBairroFilial,
              vCEPFilial,   
              vCNPJFilial,
              vIEFilial,    
              vCidadeFilial,
              vFoneFilial,
              vUfFilial,
              vCnae,
              vPO
        from tdvadm.t_arm_armazem ar,
             tdvadm.t_glb_rota    r,
             tdvadm.t_arm_coleta  co,
             tdvadm.t_glb_localidade lr
       where co.arm_armazem_codigo = ar.arm_armazem_codigo
         and r.glb_rota_codigo     = ar.glb_rota_codigo
         and co.arm_coleta_ncompra = vColeta
         and co.arm_coleta_ciclo   = vCiclo
         and r.glb_localidade_codigo = lr.glb_localidade_codigo;
         
       
       -- Alimento os dados do EMITENTE para a impressão da coleta.  
       P_LISTADADOS(i).linha('ENDERECO')           := vEndFilial;
       P_LISTADADOS(i).linha('BAIRRO')             := vBairroFilial;
       P_LISTADADOS(i).linha('CIDADE')             := vCidadeFilial||'-'||vUfFilial;
       P_LISTADADOS(i).linha('CEP')                := vCEPFilial;
       P_LISTADADOS(i).linha('FONE')               := vFoneFilial;
       P_LISTADADOS(i).linha('CNPJ')               := vCNPJFilial;
       P_LISTADADOS(i).linha('INSCEST')            := vIEFilial;
       P_LISTADADOS(i).linha('CNAE')               := vCnae;
       
       vIdBarra := glbadm.pkg_glb_codigodebarra2.Code128(trim(vColeta) || trim(vCiclo));
         
       P_LISTADADOS(i).linha('BARCODE')            := vIdBarra;                          
       
       P_LISTADADOS(i).linha('ORDEMPO')            := NVL(vPO,' ');

     
       -- Alimento as variáveis da COLETA 
       select co.arm_armazem_codigo,
              ar.glb_rota_codigo,
              co.arm_coleta_dtsolicitacao,
              nvl(vc.con_vfreteciot_numero,'0'),
              co.arm_coleta_fonesolic,
              co.arm_coleta_emailsolic,
              co.arm_coleta_obs
         into vArmazem,
              vRota,
              vDataEmissao,
              vCiot,
              vFone, 
              vEmail,
              vObsCol
         from tdvadm.t_arm_coleta       co,
              tdvadm.t_arm_armazem      ar,
              tdvadm.t_con_vfretecoleta vf,
              tdvadm.t_con_vfreteciot   vc
        where co.arm_armazem_codigo          = ar.arm_armazem_codigo
          and co.arm_coleta_ncompra          = vf.arm_coleta_ncompra(+)
          and co.arm_coleta_ciclo            = vf.arm_coleta_ciclo(+)
          and vf.con_valefrete_codigo        = vc.con_conhecimento_codigo(+)
          and vf.glb_rota_codigovalefrete    = vc.glb_rota_codigo(+)
          and vf.con_valefrete_saque         = vc.con_valefrete_saque(+)
          and co.arm_coleta_ncompra = vColeta
          and co.arm_coleta_ciclo   = vCiclo;
          
          select A.ARM_ARMAZEM_REGIMEESPECIAL 
         into vRegimeEspecial
       from tdvadm.t_arm_armazem a       
       where a.arm_armazem_codigo = vArmazem;
       
       -- Campo rodapé sera inserido o campo do regime especial
       WHILE (vLinhaLoop <= 2) LOOP
         
         P_LISTADADOS(i).linha('RODAPELINHA'||lpad(vLinhaLoop,2,'0')) := substr(vRegimeEspecial,vLengthIni,vLengthRodape);
              vLinhaLoop                                                       := vLinhaLoop + 1;
              
              vLengthIni := vLengthIni + vLengthRodape;
              
              if (vLinhaLoop > 2) Then
              
                 Exit;
              
              End if;
       END LOOP;
       
        -- Reinicio as variaveis 
       vLinhaLoop  := 1;
       vLengthIni  := 1;
          
          -- Alimento os dados da COLETA para a impressão.
          P_LISTADADOS(i).linha('NUMERO')            := vColeta||'-'||vCiclo;
          P_LISTADADOS(i).linha('DATAEMISS')         := TO_CHAR(sysdate, 'DD/MM/YYYY');--vDataEmissao;
          P_LISTADADOS(i).linha('CIOT')              := vCiot;
          P_LISTADADOS(i).linha('ARMAZ_ROTA')        := LPAD(vArmazem,3,0) ||' / '|| vRota;
          P_LISTADADOS(i).linha('SERIE')             := vCiclo;
          P_LISTADADOS(i).linha('SUB')               := '';
          P_LISTADADOS(i).linha('VIA')               := '1';

          
          /*********************************************************************/
          /********************** CAMPO DE OBSERVAÇÃO  *************************/
          /*********************************************************************/
          Begin
            
            vTamanho    := length(vObsCol);
            vQtdeLinhas := round(vTamanho/vLengthObs,0);
            vQtdeLinhas := vQtdeLinhas + MOD(vTamanho, vLengthObs);
                        
            WHILE (vLinhaLoop <= vQtdeLinhas) LOOP
              
              P_LISTADADOS(i).linha('OBSERVACAOLINHA'||lpad(vLinhaLoop,2,'0')) := substr(vObsCol,vLengthIni-1,vLengthObs);
              vLinhaLoop                                                       := vLinhaLoop + 1;
              
              vLengthIni := vLengthIni + vLengthObs;
              
              if (vLinhaLoop > 13) Then
              
                 Exit;
              
              End if;
              
            
            END LOOP;
                         
          End;
          /*********************************************************************/
          
          -- Alimento as variáveis com os dados do REMETENTE
          select cl.glb_cliente_razaosocial,
                 cr.glb_cliend_endereco,
                 cr.glb_cliend_cidade,
                 cl.glb_cliente_ie,
                 cr.glb_cliend_codcliente,
                 cr.glb_cliend_complemento,
                 cr.glb_estado_codigo,
                 cr.glb_cep_codigo,
                 cl.glb_cliente_cgccpfcodigo
            into vRazSocialRem,
                 vEndRem,        
                 vCidadeRem,     
                 vIERem,         
                 vCodRem,        
                 vBairroRem,     
                 vUFRem,         
                 vCEPRem,        
                 vCNPJRem       
            from tdvadm.t_arm_coleta  co,
                 tdvadm.t_glb_cliente cl,
                 tdvadm.t_glb_cliend  cr
           where trim (co.glb_cliente_cgccpfcodigocoleta) = trim (cl.glb_cliente_cgccpfcodigo)
             and trim (co.glb_cliente_cgccpfcodigocoleta) = trim (cr.glb_cliente_cgccpfcodigo)
             and co.glb_tpcliend_codigocoleta             = cr.glb_tpcliend_codigo
             and co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo   = vCiclo;
             
             -- Alimento os dados do REMETENTE para a impressão da coleta.
             P_LISTADADOS(i).linha('RAZAOSOCIAL1') := vRazSocialRem;
             P_LISTADADOS(i).linha('CODIGO1')      := vCodRem;
             P_LISTADADOS(i).linha('ENDERECO1')    := vEndRem;   
             P_LISTADADOS(i).linha('BAIRRO1')      := vBairroRem;   
             P_LISTADADOS(i).linha('MUNICIPIO1')   := vCidadeRem;      
             P_LISTADADOS(i).linha('UF1')          := vUFRem;   
             P_LISTADADOS(i).linha('CEP1')         := vCEPRem;       
             P_LISTADADOS(i).linha('INSCEST1')     := vIERem;      
             P_LISTADADOS(i).linha('CNPJ1')        := vCNPJRem;      
             
              -- Alimento as variáveis com os dados do DESTINATARIO
          select cl.glb_cliente_razaosocial,
                 cd.glb_cliend_endereco,
                 cd.glb_cliend_cidade,
                 cl.glb_cliente_ie,
                 cd.glb_cliend_codcliente,
                 cd.glb_cliend_complemento,
                 cd.glb_estado_codigo,
                 cd.glb_cep_codigo,
                 cl.glb_cliente_cgccpfcodigo
            into vRazSocialDest,
                 vEndDest,        
                 vCidadeDest,     
                 vIEDest,         
                 vCodDest,        
                 vBairroDest,     
                 vUFDest,         
                 vCEPDest,        
                 vCNPJDest       
            from tdvadm.t_arm_coleta  co,
                 tdvadm.t_glb_cliente cl,
                 tdvadm.t_glb_cliend  cd
           where trim (co.glb_cliente_cgccpfcodigoentreg) = trim (cl.glb_cliente_cgccpfcodigo)
             and trim (co.glb_cliente_cgccpfcodigoentreg) = trim (cd.glb_cliente_cgccpfcodigo)
             and co.glb_tpcliend_codigoentrega            = cd.glb_tpcliend_codigo
             and co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo   = vCiclo;
           
          -- Alimento os dados do DESTINATARIO para a impressão da coleta. 
          P_LISTADADOS(i).linha('RAZAOSOCIAL2') := vRazSocialDest;
          P_LISTADADOS(i).linha('CODIGO2')      := vCodDest;
          P_LISTADADOS(i).linha('ENDERECO2')    := vEndDest;    
          P_LISTADADOS(i).linha('BAIRRO2')      := vBairroDest;    
          P_LISTADADOS(i).linha('MUNICIPIO2')   := vCidadeDest;    
          P_LISTADADOS(i).linha('UF2')          := vUFDest;    
          P_LISTADADOS(i).linha('CEP2')         := vCEPDest;       
          P_LISTADADOS(i).linha('INSCEST2')     := vIEDest;       
          P_LISTADADOS(i).linha('CNPJ2')        := vCNPJDest;     
          
          --Verifica se tem PARCEIRO DE COLETA, local de coleta diferente do remetente
          
          select count (*)
            into vContador
            from tdvadm.t_arm_coletaparceiro cl
           where cl.arm_coleta_ncompra = vColeta
             and cl.arm_coleta_ciclo   = vCiclo
             and cl.arm_coletatppar_codigo = 'CC';
        
        --Caso tenha, alimento as variáveis com dados do parceiro.  
          if vContador > 0 then
           
          -- Pego CNPJ e Tipo de Endereço
          
           select cl.glb_cliente_cgccpfpar,
                  cl.glb_tpcliend_codigopar
            into vCNPJCol,
                 vTPEndCol
            from tdvadm.t_arm_coletaparceiro cl
           where cl.arm_coleta_ncompra = vColeta
             and cl.arm_coleta_ciclo   = vCiclo
             and cl.arm_coletatppar_codigo = 'CC';
             
            --Alimentao variáveis LOCAL DE COLETA
           select cl.glb_cliente_razaosocial,
                  ce.glb_cliend_endereco,
                  ce.glb_cliend_cidade,
                  ce.glb_cliend_ie,
                  ce.glb_cliend_codcliente,
                  ce.glb_cliend_complemento,
                  ce.glb_estado_codigo,
                  ce.glb_cep_codigo,
                  ce.glb_cliente_cgccpfcodigo
             into vRazSocialCol,
                  vEndCol,      
                  vCidadeCol,   
                  vIECol,       
                  vCodCol,      
                  vBairroCol,   
                  vUFCol,       
                  vCEPCol,      
                  vCNPJCol     
               from tdvadm.t_glb_cliente cl,
                    tdvadm.t_glb_Cliend ce
              where trim(cl.glb_cliente_cgccpfcodigo) = trim(ce.glb_cliente_cgccpfcodigo)
                and ce.glb_tpcliend_codigo            = vTPEndCol
                and ce.glb_cliente_cgccpfcodigo       = vCNPJCol;
           
              select cl.glb_cliente_razaosocial,
                 cr.glb_cliend_endereco,
                 cr.glb_cliend_cidade,
                 cl.glb_cliente_ie,
                 cr.glb_cliend_codcliente,
                 cr.glb_cliend_complemento,
                 cr.glb_estado_codigo,
                 cr.glb_cep_codigo,
                 cl.glb_cliente_cgccpfcodigo
            into vRazSocialCol,
                 vEndCol,        
                 vCidadeCol,     
                 vIECol,         
                 vCodCol,        
                 vBairroCol,     
                 vUFCol,         
                 vCEPCol,        
                 vCNPJCol       
            from tdvadm.t_glb_cliente cl,
                 tdvadm.t_glb_cliend  cr
           where rpad (cl.glb_cliente_cgccpfcodigo,'20',' ') = vCNPJCol
             and cr.glb_tpcliend_codigo             = vTPEndCol
             and trim (cr.glb_cliente_cgccpfcodigo) = trim (cl.glb_cliente_cgccpfcodigo);
           
                
            --Alimento variáveis utilizando os dados do parceiro da coleta.
            
            P_LISTADADOS(i).linha('RAZAOSOCIAL3') := vRazSocialCol;
            P_LISTADADOS(i).linha('CODIGO3')      := vCodCol;
            P_LISTADADOS(i).linha('ENDERECO3')    := vEndCol;      
            P_LISTADADOS(i).linha('BAIRRO3')      := vBairroCol;   
            P_LISTADADOS(i).linha('MUNICIPIO3')   := vCidadeCol;   
            P_LISTADADOS(i).linha('UF3')          := vUFCol; 
            P_LISTADADOS(i).linha('CEP3')         := vCEPCol;  
            P_LISTADADOS(i).linha('INSCEST3')     := vIECol;       
            P_LISTADADOS(i).linha('CNPJ3')        := vCNPJCol; 
            P_LISTADADOS(i).linha('CONTATO3')     := vEmail;
            P_LISTADADOS(i).linha('TELEFONE3')    := vFone;
                
         
          else 
            --Caso não tenha parceiro de coleta, utilizo os mesmos dados do REMETENTE.
              
            P_LISTADADOS(i).linha('RAZAOSOCIAL3') := vRazSocialRem;
            P_LISTADADOS(i).linha('CODIGO3')      := vCodRem;
            P_LISTADADOS(i).linha('ENDERECO3')    := vEndRem;
            P_LISTADADOS(i).linha('BAIRRO3')      := vBairroRem;   
            P_LISTADADOS(i).linha('MUNICIPIO3')   := vCidadeRem;
            P_LISTADADOS(i).linha('UF3')          := vUFRem; 
            P_LISTADADOS(i).linha('CEP3')         := vCEPRem;
            P_LISTADADOS(i).linha('INSCEST3')     := vIERem;
            P_LISTADADOS(i).linha('CNPJ3')        := vCNPJRem; 
            P_LISTADADOS(i).linha('CONTATO3')     := vEmail;
            P_LISTADADOS(i).linha('TELEFONE3')    := vFone;
          
          end if;
          
              
     --Monto cursor para pegar dados da coleta e montar a lista
     for c_msg in (select rpad(b.arm_coleta_ncompra_volume,14,' ')    volume,
                          rpad(a.arm_coleta_dtsolicitacao,12,' ')     dtemissao,
                          rpad(b.arm_coletancompra_mercadoria,84,' ') mercadoria,
                          rpad(replace(TRIM(to_char(b.arm_coleta_ncompra_peso,'999999.000')),'.',','),10,' ')      peso
                    from tdvadm.t_Arm_coleta        a,
                         tdvadm.t_arm_coletancompra b
                  where a.arm_coleta_ncompra = vColeta
                    and a.arm_coleta_ciclo  = vCiclo
                    and a.arm_coleta_ncompra = b.arm_coletancompra
                    and a.arm_coleta_ciclo   = b.arm_coleta_ciclo)
         
                    
       loop

         
         
         vControle := vControle + 1;
       
       begin
          select nvl(an.col_asn_numeronfe,'0')
            into vNota
            from tdvadm.t_col_asn an
           where an.arm_coleta_ncompra = vColeta
             and an.arm_coleta_ciclo   = vCiclo
             and an.col_asn_idnimbi = (select max (ab.col_asn_idnimbi)
                                         from tdvadm.t_col_asn ab
                                        where ab.arm_coleta_ncompra = an.arm_coleta_ncompra
                                          and ab.arm_coleta_ciclo   = ab.arm_coleta_ciclo); 
       exception when others then
         vNota := '0';
       end;
       
           vLinha := c_msg.volume || rpad(vNota,14,' ') || c_msg.dtemissao || c_msg.mercadoria || c_msg.peso;
       
           -- Alimento os dados passando quantidade de volume, nota, data de emissão, mercadoria e peso
           P_LISTADADOS(i).linha('Linha'||(vControle)) := vLinha;

           -- Caso tiver mais de 30 registros, saio do loop, pois na impressão da coleta só pode ter no máximo 30 na lista.
           if vControle = 28 then
             exit;
           end if;
           

           
       end loop; 
       
      --Conto quantos volumes tem para essa coleta.
       select sum(a.arm_coleta_ncompra_volume)
         into vContador
         from tdvadm.t_arm_coletancompra a
        where a.arm_coletancompra = vColeta
          and a.arm_coleta_ciclo  = vCiclo;
       
       -- Quantidade Total de Volumes
       P_LISTADADOS(i).linha('QUANTIDADET') := vContador;
      
       
       -- Somo o peso total das notas
       select sum (a.arm_coleta_ncompra_peso)
         into vContador
         from tdvadm.t_arm_coletancompra a
        where a.arm_coletancompra = vColeta
          and a.arm_coleta_ciclo  = vCiclo;
       
       --Peso total das notas.
       P_LISTADADOS(i).linha('PESOT') := vContador;
      
      -- Alimento as variveis com dados da placa e motorista baseado no vinculo com a coleta.
      begin
       select mt.arm_coleta_motorista_placa,
              mt.arm_coleta_motorista_placasaqu,
              mt.arm_coleta_placa2,
              mt.arm_coleta_placa2saque,
              mt.arm_coleta_carreteiro
         into vPlaca,    
              vPlacaSQ,  
              vPlaca2,   
              vPlaca2SQ, 
              vCPFMOT
         from tdvadm.t_arm_coleta_motorista mt
        where mt.arm_coleta_ncompra = vColeta
          and mt.arm_coleta_ciclo   = vCiclo
          and rownum = '1';
       exception when others then
         P_MESSAGE := 'Coleta sem motorista vinculado';
         P_STATUS  := 'E';
         return;
       end;   
         
        --Verifica se é frota pela placa
          select count (*)
            into vContador
           from tdvadm.t_frt_veiculo ve
          where ve.frt_veiculo_placa = vPlaca
            and ve.frt_veiculo_datavenda is null;
            
        --Verifica se é frota pelo CPF   
         select count (*)
            into vContador
           from tdvadm.t_frt_motorista ve
          where ve.frt_motorista_cpf = vCPFMOT;
          
         --Se for frota, pego os dados nas tabelas de frota
          if vContador > 0 then
            
          --Alimento variaveis dados da placa
            select ve.frt_veiculo_placa,
                   ma.frt_marmodveic_marca,
                   ve.frt_veiculo_placacidade,
                   ve.glb_estado_codigo,
                   cg.frt_conjveiculo_codigo
              into vPlaca,
                   vMarcaModelo,
                   vCidadePlaca,
                   vUFPlaca,
                   vFrota
              from tdvadm.t_frt_veiculo    ve,
                   tdvadm.t_frt_marmodveic ma,
                   tdvadm.t_frt_conteng    cg
             where ve.frt_marmodveic_codigo = ma.frt_marmodveic_codigo
               and (ve.frt_veiculo_placa     = vPlaca
                    or cg.frt_conjveiculo_codigo = vPlaca)
               and substr(ve.frt_veiculo_codigo,1) not like '%A%'
               and ve.frt_veiculo_codigo    = cg.frt_veiculo_codigo
               AND SUBSTR(ve.FRT_VEICULO_CODIGO, 1,1) = 'C'
               and rownum = '1';
               
            select ve.frt_veiculo_placa
              into vPlacaCarreta                   
              from tdvadm.t_frt_veiculo    ve,
                   tdvadm.t_frt_marmodveic ma,
                   tdvadm.t_frt_conteng    cg
             where ve.frt_marmodveic_codigo = ma.frt_marmodveic_codigo
               and (ve.frt_veiculo_placa     = vPlaca
                    or cg.frt_conjveiculo_codigo = vPlaca)
               and substr(ve.frt_veiculo_codigo,1) not like '%A%'
               and ve.frt_veiculo_codigo    = cg.frt_veiculo_codigo               
               and rownum = '1';   
               
          
          --Alimento variaveis dados motorista
            select substr(mo.frt_motorista_nome,0,24),
                   mo.frt_motorista_rgcodigo,
                   mo.frt_motorista_cnhcodigo,
                   mo.frt_motorista_prontuariocod
              into vMotNome,
                   vRGMot,
                   vCNHMot,
                   vProntuarioMot
              from tdvadm.t_frt_motorista mo
             where mo.frt_motorista_cpf = vCPFMOT
               and rownum = '1';
              
            --Alimentos os dados com as informações do Frota (Frota,Motorista,Proprietario).
            
            P_LISTADADOS(i).linha('FROTA')          := vFrota;
            P_LISTADADOS(i).linha('PLACA')          := vPlaca;
            P_LISTADADOS(i).linha('CARRETA')        := vPlacaCarreta;
            P_LISTADADOS(i).linha('MARCA')          := substr(vMarcaModelo, 1, 25);
            P_LISTADADOS(i).linha('MUNICIPIO4')     := vCidadePlaca;
            P_LISTADADOS(i).linha('UF4')            := vUFPlaca;
            P_LISTADADOS(i).linha('MOTORISTA')      := substr(vMotNome, 1, 29);
            P_LISTADADOS(i).linha('CPF')            := vCPFMOT;
            P_LISTADADOS(i).linha('RG')             := vRGMot;
            P_LISTADADOS(i).linha('CNH')            := vCNHMot;
            P_LISTADADOS(i).linha('PRONTUARIO')     := vProntuarioMot;
            P_LISTADADOS(i).linha('MOP')            := '';
            P_LISTADADOS(i).linha('PROPRIETARIO')   := 'TRANSPORTES DELLA VOLPE S A';
            P_LISTADADOS(i).linha('CPF2')           := '61139432000172';
            P_LISTADADOS(i).linha('CATANTT')        := 'ETC';
            P_LISTADADOS(i).linha('PESOINFO')       := '';
            P_LISTADADOS(i).linha('CC')             := '';
            P_LISTADADOS(i).linha('AJUDANTES')      := '';
          else
            
          -- Alimento as váriaveis pegando da base de carreteiro se não for frota, essa tabela também serve para agregados.
             select ve.car_veiculo_marca ||'-'|| ve.car_veiculo_tipo,
                    ve.car_veiculo_placacidade,
                    ve.glb_estadoveiculo_codigo,
                    ve.car_proprietario_cgccpfcodigo
               into vMarcaModelo,
                    vCidadePlaca,
                    vUFPlaca,
                    vProprietario
               from tdvadm.t_car_veiculo ve
              where ve.car_veiculo_placa = vPlaca
                and ve.car_veiculo_saque = vPlacaSQ;   
         
         --Pego os dados do motorista baseado no último saque da ficha.       
              select cr.car_carreteiro_nome,
                     cr.car_carreteiro_rgcodigo,
                     cr.car_carreteiro_cnhcodigo,
                     cr.car_carreteiro_prontuariocodig
                into vMotNome,
                     vRGMot,
                     vCNHMot,
                     vProntuarioMot
                from tdvadm.t_car_carreteiro cr
               where cr.car_carreteiro_cpfcodigo = vCPFMOT
                 and cr.car_carreteiro_saque     = (select max (ca.car_carreteiro_saque)
                                                      from tdvadm.t_car_Carreteiro ca
                                                     where ca.car_carreteiro_cpfcodigo = cr.car_carreteiro_cpfcodigo);
         
        -- Alimento os dados com informações da placa e do motorista.                                             
         P_LISTADADOS(i).linha('FROTA')          := ''; 
         P_LISTADADOS(i).linha('PLACA')          := vPlaca;
         P_LISTADADOS(i).linha('CARRETA')        := vPlaca2;
         P_LISTADADOS(i).linha('MARCA')          := substr(vMarcaModelo, 1, 25);
         P_LISTADADOS(i).linha('MUNICIPIO4')     := vCidadePlaca;
         P_LISTADADOS(i).linha('UF4')            := vUFPlaca;
         P_LISTADADOS(i).linha('MOTORISTA')      := substr(vMotNome, 1, 29);
         P_LISTADADOS(i).linha('CPF')            := vCPFMOT;
         P_LISTADADOS(i).linha('RG')             := vRGMot;
         P_LISTADADOS(i).linha('CNH')            := vCNHMot;             
         P_LISTADADOS(i).linha('PRONTUARIO')     := vProntuarioMot;         
         
         --Alimento as variáveis com informações do proprietário do veículo
         select pr.car_proprietario_razaosocial,
                pr.car_proprietario_cgccpfcodigo,
                pr.car_proprietario_classantt
           into vPropRazao,         
                vProprietario,
                vPropANTT 
           from tdvadm.t_Car_proprietario pr
          where pr.car_proprietario_cgccpfcodigo = vProprietario;
          
         --Alimento os dados baseado nas informações do proprietário. 
          P_LISTADADOS(i).linha('PROPRIETARIO')   := substr(vPropRazao, 1, 33);
          P_LISTADADOS(i).linha('CPF2')           := vProprietario;
          P_LISTADADOS(i).linha('CATANTT')        := vPropANTT;
          P_LISTADADOS(i).linha('PESOINFO')       := '';
          P_LISTADADOS(i).linha('CC')             := '';
          P_LISTADADOS(i).linha('AJUDANTES')      := '';
          
         end if;
         
         P_LISTADADOS(i).linha('AJUDANTES')      := '';
          
        --Altero a coleta informando que foi impressa.  
          update tdvadm.t_arm_coleta co
             set co.usu_usuario_codigo_impresso = vUsuarioTDV,
                 co.arm_coleta_dtimp            = sysdate
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo   = vCiclo;
         commit;
          
       
  end SP_RETDADOGERCOLETA;                                                             

  procedure SP_RETDADOCOLETA(P_XMLIN      In  VARCHAR2,
                             P_LISTADADOS OUT glbadm.pkg_listas.tContainerPCL,      
                             P_STATUS     OUT CHAR,
                             P_MESSAGE    OUT VARCHAR2)
/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Operacional
* PROGRAMA    : Impressão de Coleta PCL
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 26/06/2020
* BANCO       : ORACLE
* SIGLAS      : ARM, CON, GLB
* DESCRICAO   : Monta a estrutura para impressão da coleta via PCL.
---------------------------------------------------------------------------------------------------
*/

 -- Declaro todas as variáveis que serão utilizadas.
  As
  
  plistaparams glbadm.pkg_listas.tlistausuparametros;
  -- Variaveis Coleta
  vColeta             tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo              tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
  vArmazem            tdvadm.t_arm_coleta.arm_armazem_codigo%type;
  vRota               tdvadm.t_arm_armazem.glb_rota_codigo%type;
  vDataEmissao        tdvadm.t_arm_coleta.arm_coleta_dtsolicitacao%type;
  vFone               tdvadm.t_arm_coleta.arm_coleta_fonesolic%type;
  vEmail              tdvadm.t_arm_coleta.arm_coleta_emailsolic%type;
  
  -- Variaveis usuarios/aplicacao
  vUsuarioTDV         char(10);
  vRotaUsuarioTDV     char(3);
  vAplicacaoTDV       char(10);
  vVersaoAplicao      char(10);
  
  --Variaveis CIOT
  vCiot               tdvadm.t_con_vfreteciot.con_vfreteciot_numero%type;
  
  --Variaveis de Controle
  vContador           number;
  vControle           integer;
  i                   number;
  
  --Variaveis de Emitente
  vEndFilial      tdvadm.t_glb_rota.glb_rota_endereco%type;    
  vBairroFilial   tdvadm.t_glb_rota.glb_rota_procedencia%type;
  vCEPFilial      tdvadm.t_glb_rota.glb_rota_cep%type;   
  vIEFilial       tdvadm.t_glb_rota.glb_rota_ie%type;
  vCidadeFilial   tdvadm.t_glb_localidade.glb_localidade_descricao%type;
  vFoneFilial     tdvadm.t_glb_rota.glb_rota_fone%type;
  vCNPJFilial     tdvadm.t_glb_rota.glb_rota_cgc%type;
  
  --Variaveis do Remetente
  vRazSocialRem   tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vEndRem         tdvadm.t_glb_cliend.glb_cliend_endereco%type;
  vCidadeRem      tdvadm.t_glb_cliend.glb_cliend_cidade%type;
  vIERem          tdvadm.t_glb_cliente.glb_cliente_ie%type;
  vCodRem         tdvadm.t_glb_cliend.glb_cliend_codcliente%type;
  vBairroRem      tdvadm.t_glb_cliend.glb_cliend_complemento%type;
  vUFRem          tdvadm.t_glb_cliend.glb_estado_codigo%type;
  vCEPRem         tdvadm.t_glb_cliend.glb_cep_codigo%type;
  vCNPJRem        tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  
  --Variaveis do Destinatario
  vRazSocialDest  tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vEndDest        tdvadm.t_glb_cliend.glb_cliend_endereco%type;
  vCidadeDest     tdvadm.t_glb_cliend.glb_cliend_cidade%type;
  vIEDest         tdvadm.t_glb_cliente.glb_cliente_ie%type;
  vCodDest        tdvadm.t_glb_cliend.glb_cliend_codcliente%type;
  vBairroDest     tdvadm.t_glb_cliend.glb_cliend_complemento%type;
  vUFDest         tdvadm.t_glb_cliend.glb_estado_codigo%type;
  vCEPDest        tdvadm.t_glb_cliend.glb_cep_codigo%type;
  vCNPJDest       tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  
  --Variaveis do Local de coleta
  vRazSocialCol   tdvadm.t_glb_cliente.glb_cliente_razaosocial%type;
  vEndCol         tdvadm.t_glb_cliend.glb_cliend_endereco%type;
  vCidadeCol      tdvadm.t_glb_cliend.glb_cliend_cidade%type;
  vIECol          tdvadm.t_glb_cliente.glb_cliente_ie%type;
  vCodCol         tdvadm.t_glb_cliend.glb_cliend_codcliente%type;
  vBairroCol      tdvadm.t_glb_cliend.glb_cliend_complemento%type;
  vUFCol          tdvadm.t_glb_cliend.glb_estado_codigo%type;
  vCEPCol         tdvadm.t_glb_cliend.glb_cep_codigo%type;
  vCNPJCol        tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
  vTPEndCol       tdvadm.t_glb_cliend.glb_tpcliend_codigo%type;
  
  --Variaveis da Placa e Motorista
  vPlaca          tdvadm.t_arm_coleta_motorista.arm_coleta_motorista_placa%type;
  vPlacaSQ        tdvadm.t_arm_coleta_motorista.arm_coleta_motorista_placasaqu%type;
  vPlaca2         tdvadm.t_arm_coleta_motorista.arm_coleta_placa2%type;
  vPlaca2SQ       tdvadm.t_arm_coleta_motorista.arm_coleta_placa2saque%type;
  vCPFMOT         tdvadm.t_arm_coleta_motorista.arm_coleta_carreteiro%type;
  vMotNome        varchar2(50);
  vRGMot          tdvadm.t_frt_motorista.frt_motorista_rgcodigo%type;
  vCNHMot         tdvadm.t_frt_motorista.frt_motorista_cnhcodigo%type;
  vProntuarioMot  tdvadm.t_frt_motorista.frt_motorista_prontuariocod%type;
  vMarcaModelo    varchar2(70);
  vCidadePlaca    tdvadm.t_frt_veiculo.frt_veiculo_placacidade%type;
  vUFPlaca        tdvadm.t_frt_veiculo.glb_estado_codigo%type;
  vMOTSaque       tdvadm.t_car_carreteiro.car_carreteiro_saque%type;
  
  --Variaveis do Proprietario
  vPropCNPJCPF   tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type;
  vPropRazao     tdvadm.t_car_proprietario.car_proprietario_razaosocial%type;
  vPropANTT      tdvadm.t_car_proprietario.car_proprietario_classantt%type;
  vProprietario   tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%type;
  begin
   
  -- Preencho as variáveis inicias com os dados passados no XML.
   vColeta             := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Coleta' ));
   vCiclo              := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Ciclo' ));
   vUsuarioTDV         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'UsuarioTDV' ));
   vRotaUsuarioTDV     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'RotaUsuarioTDV' ));
   vAplicacaoTDV       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'Aplicacao' ));
   vVersaoAplicao      := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(P_XMLIN,'VersaoAplicao' ));
   vControle           := 2;
   P_STATUS            := 'N';
   --Verifico se os parâmetros são validos.
     if Not glbadm.pkg_listas.fn_get_usuparamtros(vAplicacaoTDV,
                                                  vusuarioTDV,
                                                  vRotaUsuarioTDV,
                                                  plistaparams) Then
                                    
     P_STATUS :=  PKG_GLB_COMMON.Status_Erro;
     P_MESSAGE := P_MESSAGE || '00 - Erro ao Buscar Parametros.' || chr(10);
  End if ;
  
     i:= 1; -- Quantidade de Paginas.
       
       -- Pego os dados da FILIAL EMITENTE
       select trim(fn_limpa_campo(substr(replace(r.glb_rota_endereco,',',''),1,60))) ||'-'|| NVL(trim(r.glb_rota_codcentury),'0'),                                                        
              substr(r.glb_rota_procedencia,1,60),                                                                                                                               
              rpad(trim(r.glb_rota_cep),8,'0'),                                                                 
              r.glb_rota_cgc,
              r.glb_rota_ie,
              lr.glb_localidade_descricao,                                                
              lpad(replace(replace(replace(replace(trim(r.glb_rota_fone),'-',''),'(',''),')',''),' ',''),12,'0')
         into vEndFilial,   
              vBairroFilial,
              vCEPFilial,   
              vCNPJFilial,
              vIEFilial,    
              vCidadeFilial,
              vFoneFilial  
        from tdvadm.t_arm_armazem ar,
             tdvadm.t_glb_rota    r,
             tdvadm.t_arm_coleta  co,
             tdvadm.t_glb_localidade lr
       where co.arm_armazem_codigo = ar.arm_armazem_codigo
         and r.glb_rota_codigo     = ar.glb_rota_codigo
         and co.arm_coleta_ncompra = vColeta
         and co.arm_coleta_ciclo   = vCiclo
         and r.glb_localidade_codigo = lr.glb_localidade_codigo;
       
       -- Alimento os dados do EMITENTE para a impressão da coleta.  
       P_LISTADADOS(i).linha('ENDERECO') := vEndFilial;
       P_LISTADADOS(i).linha('BAIRRO')   := vBairroFilial;
       P_LISTADADOS(i).linha('CIDADE')   := vCEPFilial;
       P_LISTADADOS(i).linha('CEP')      := vCNPJFilial;
       P_LISTADADOS(i).linha('FONE')     := vIEFilial;
       P_LISTADADOS(i).linha('CNPJ')     := vCidadeFilial;
       P_LISTADADOS(i).linha('INSCEST')  := vFoneFilial;
       P_LISTADADOS(i).linha('CNAE')     := 'CNAE';
      
     
       -- Alimento as variáveis da COLETA 
       select co.arm_armazem_codigo,
              ar.glb_rota_codigo,
              co.arm_coleta_dtsolicitacao,
              nvl(vc.con_vfreteciot_numero,'0'),
              co.arm_coleta_fonesolic,
              co.arm_coleta_emailsolic
         into vArmazem,
              vRota,
              vDataEmissao,
              vCiot,
              vFone, 
              vEmail
         from tdvadm.t_arm_coleta       co,
              tdvadm.t_arm_armazem      ar,
              tdvadm.t_con_vfretecoleta vf,
              tdvadm.t_con_vfreteciot   vc
        where co.arm_armazem_codigo          = ar.arm_armazem_codigo
          and co.arm_coleta_ncompra          = vf.arm_coleta_ncompra(+)
          and co.arm_coleta_ciclo            = vf.arm_coleta_ciclo(+)
          and vf.con_valefrete_codigo        = vc.con_conhecimento_codigo(+)
          and vf.glb_rota_codigovalefrete    = vc.glb_rota_codigo(+)
          and vf.con_valefrete_saque         = vc.con_valefrete_saque(+)
          and co.arm_coleta_ncompra = vColeta
          and co.arm_coleta_ciclo   = vCiclo;
          
          -- Alimento os dados da COLETA para a impressão.
          P_LISTADADOS(i).linha('NUMERO')     := vColeta;
          P_LISTADADOS(i).linha('DATAEMISS')  := vDataEmissao;
          P_LISTADADOS(i).linha('CIOT')       := vCiot;
          P_LISTADADOS(i).linha('ARMAZ_ROTA') := vArmazem ||'-'|| vRota;
          P_LISTADADOS(i).linha('SERIE')      := '';
          P_LISTADADOS(i).linha('SUB')        := '';
          P_LISTADADOS(i).linha('VIA')        := '';
          
          -- Alimento as variáveis com os dados do REMETENTE
          select cl.glb_cliente_razaosocial,
                 cr.glb_cliend_endereco,
                 cr.glb_cliend_cidade,
                 cl.glb_cliente_ie,
                 cr.glb_cliend_codcliente,
                 cr.glb_cliend_complemento,
                 cr.glb_estado_codigo,
                 cr.glb_cep_codigo,
                 cl.glb_cliente_cgccpfcodigo
            into vRazSocialRem,
                 vEndRem,        
                 vCidadeRem,     
                 vIERem,         
                 vCodRem,        
                 vBairroRem,     
                 vUFRem,         
                 vCEPRem,        
                 vCNPJRem       
            from tdvadm.t_arm_coleta  co,
                 tdvadm.t_glb_cliente cl,
                 tdvadm.t_glb_cliend  cr
           where trim (co.glb_cliente_cgccpfcodigocoleta) = trim (cl.glb_cliente_cgccpfcodigo)
             and trim (co.glb_cliente_cgccpfcodigocoleta) = trim (cr.glb_cliente_cgccpfcodigo)
             and co.glb_tpcliend_codigocoleta             = cr.glb_tpcliend_codigo
             and co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo   = vCiclo;
             
             -- Alimento os dados do REMETENTE para a impressão da coleta.
             P_LISTADADOS(i).linha('RAZAOSOCIAL1') := vRazSocialRem;
             P_LISTADADOS(i).linha('CODIGO1')      := vCodRem;
             P_LISTADADOS(i).linha('ENDERECO1')    := vEndRem;   
             P_LISTADADOS(i).linha('BAIRRO1')      := vBairroRem;   
             P_LISTADADOS(i).linha('MUNICIPIO1')   := vCidadeRem;      
             P_LISTADADOS(i).linha('UF1')          := vUFRem;   
             P_LISTADADOS(i).linha('CEP1')         := vCEPRem;       
             P_LISTADADOS(i).linha('INSCEST1')     := vIERem;      
             P_LISTADADOS(i).linha('CNPJ1')        := vCNPJRem;      
             
              -- Alimento as variáveis com os dados do DESTINATARIO
          select cl.glb_cliente_razaosocial,
                 cd.glb_cliend_endereco,
                 cd.glb_cliend_cidade,
                 cl.glb_cliente_ie,
                 cd.glb_cliend_codcliente,
                 cd.glb_cliend_complemento,
                 cd.glb_estado_codigo,
                 cd.glb_cep_codigo,
                 cl.glb_cliente_cgccpfcodigo
            into vRazSocialDest,
                 vEndDest,        
                 vCidadeDest,     
                 vIEDest,         
                 vCodDest,        
                 vBairroDest,     
                 vUFDest,         
                 vCEPDest,        
                 vCNPJDest       
            from tdvadm.t_arm_coleta  co,
                 tdvadm.t_glb_cliente cl,
                 tdvadm.t_glb_cliend  cd
           where trim (co.glb_cliente_cgccpfcodigoentreg) = trim (cl.glb_cliente_cgccpfcodigo)
             and trim (co.glb_cliente_cgccpfcodigoentreg) = trim (cd.glb_cliente_cgccpfcodigo)
             and co.glb_tpcliend_codigoentrega            = cd.glb_tpcliend_codigo
             and co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo   = vCiclo;
           
          -- Alimento os dados do DESTINATARIO para a impressão da coleta. 
          P_LISTADADOS(i).linha('RAZAOSOCIAL2') := vRazSocialDest;
          P_LISTADADOS(i).linha('CODIGO2')      := vCodDest;
          P_LISTADADOS(i).linha('ENDERECO2')    := vEndDest;    
          P_LISTADADOS(i).linha('BAIRRO2')      := vBairroDest;    
          P_LISTADADOS(i).linha('MUNICIPIO2')   := vCidadeDest;    
          P_LISTADADOS(i).linha('UF2')          := vUFDest;    
          P_LISTADADOS(i).linha('CEP2')         := vCEPDest;       
          P_LISTADADOS(i).linha('INSCEST2')     := vIEDest;       
          P_LISTADADOS(i).linha('CNPJ2')        := vCNPJDest;     
          
          --Verifica se tem PARCEIRO DE COLETA, local de coleta diferente do remetente
          select count (*)
            into vContador
            from tdvadm.t_arm_coletaparceiro cl
           where cl.arm_coleta_ncompra = vColeta
             and cl.arm_coleta_ciclo   = vCiclo
             and cl.arm_coletatppar_codigo = 'CC';
        
        --Caso tenha, alimento as variáveis com dados do parceiro.  
          if vContador > 0 then
           
          -- Pego CNPJ e Tipo de Endereço
           select cl.glb_cliente_cgccpfpar,
                  cl.glb_tpcliend_codigopar
            into vCNPJCol,
                 vTPEndCol
            from tdvadm.t_arm_coletaparceiro cl
           where cl.arm_coleta_ncompra = vColeta
             and cl.arm_coleta_ciclo   = vCiclo
             and cl.arm_coletatppar_codigo = 'CC';
            
            --Alimentao variáveis LOCAL DE COLETA
           select cl.glb_cliente_razaosocial,
                  ce.glb_cliend_endereco,
                  ce.glb_cliend_cidade,
                  ce.glb_cliend_ie,
                  ce.glb_cliend_codcliente,
                  ce.glb_cliend_complemento,
                  ce.glb_estado_codigo,
                  ce.glb_cep_codigo,
                  ce.glb_cliente_cgccpfcodigo
             into vRazSocialCol,
                  vEndCol,      
                  vCidadeCol,   
                  vIECol,       
                  vCodCol,      
                  vBairroCol,   
                  vUFCol,       
                  vCEPCol,      
                  vCNPJCol     
               from tdvadm.t_glb_cliente cl,
                    tdvadm.t_glb_Cliend ce
              where trim(cl.glb_cliente_cgccpfcodigo) = trim(ce.glb_cliente_cgccpfcodigo)
                and ce.glb_tpcliend_codigo            = vTPEndCol
                and ce.glb_cliente_cgccpfcodigo       = vCNPJCol;
                
                
          --Alimento variáveis utilizando os dados do parceiro da coleta.
          
          P_LISTADADOS(i).linha('RAZAOSOCIAL3') := vRazSocialCol;
          P_LISTADADOS(i).linha('CODIGO3')      := vCodCol;
          P_LISTADADOS(i).linha('ENDERECO3')    := vEndCol;      
          P_LISTADADOS(i).linha('BAIRRO3')      := vBairroCol;   
          P_LISTADADOS(i).linha('MUNICIPIO3')   := vCidadeCol;   
          P_LISTADADOS(i).linha('UF3')          := vUFCol; 
          P_LISTADADOS(i).linha('CEP3')         := vCEPCol;  
          P_LISTADADOS(i).linha('INSCEST3')     := vIECol;       
          P_LISTADADOS(i).linha('CNPJ3')        := vCNPJCol; 
          P_LISTADADOS(i).linha('CONTATO3')     := vEmail;
          P_LISTADADOS(i).linha('TELEFONE3')    := vFone;
                
         
          else
            
          --Caso não tenha parceiro de coleta, utilizo os mesmos dados do DESTINATÁRIO.
            
          P_LISTADADOS(i).linha('RAZAOSOCIAL3') := vRazSocialDest;
          P_LISTADADOS(i).linha('CODIGO3')      := vEndDest;
          P_LISTADADOS(i).linha('ENDERECO3')    := vCidadeDest;   
          P_LISTADADOS(i).linha('BAIRRO3')      := vIEDest;       
          P_LISTADADOS(i).linha('MUNICIPIO3')   := vCodDest;      
          P_LISTADADOS(i).linha('UF3')          := vBairroDest;   
          P_LISTADADOS(i).linha('CEP3')         := vUFDest;       
          P_LISTADADOS(i).linha('INSCEST3')     := vCEPDest;      
          P_LISTADADOS(i).linha('CNPJ3')        := vCNPJDest;
          P_LISTADADOS(i).linha('CONTATO3')     := vFone;
          P_LISTADADOS(i).linha('TELEFONE3')    := vEmail;
          
          end if;
              
     --Monto cursor para pegar dados da coleta e montar a lista
     for c_msg in (select a.arm_coleta_ncompra_volume    volume,
                          b.arm_nota_numero              nota,
                          b.arm_nota_dtinclusao          dtemissao,
                          a.arm_coletancompra_mercadoria mercadoria,
                          a.arm_coleta_ncompra_peso      peso
                    from tdvadm.t_arm_coletancompra a,
                         tdvadm.t_Arm_nota          b
                  where a.arm_coletancompra = vColeta
                    and a.arm_coleta_ciclo  = vCiclo
                    and a.arm_coletancompra = b.arm_coleta_ncompra
                    and a.arm_coleta_ciclo  = b.arm_coleta_ciclo)            
                    
       loop
           -- Alimento os dados passando quantidade de volume, nota, data de emissão, mercadoria e peso
           P_LISTADADOS(i).linha('Linha'||lpad(vControle,2,0)) := c_msg.volume ||'*'|| c_msg.nota ||'*'|| c_msg.dtemissao ||'*'|| c_msg.mercadoria ||'*'|| c_msg.peso;
           vControle := vControle + 1;
           
           -- Caso tiver mais de 30 registros, saio do loop, pois na impressão da coleta só pode ter no máximo 30 na lista.
           if vControle = 30 then
             exit;
           end if;
           
       end loop; 
       
      --Conto quantos volumes tem para essa coleta.
       select sum(a.arm_coleta_ncompra_volume)
         into vContador
         from tdvadm.t_arm_coletancompra a
        where a.arm_coletancompra = vColeta
          and a.arm_coleta_ciclo  = vCiclo;
       
       -- Quantidade Total de Volumes
       P_LISTADADOS(i).linha('QUANTIDADET') := vContador;
      
       --Conto quantas notas tem para a coleta. 
       select count (*)
         into vContador
         from tdvadm.t_arm_nota no
        where no.arm_coleta_ncompra = vColeta
          and no.arm_coleta_ciclo  = vCiclo;
       
        -- Quantidade Total de Notas
       P_LISTADADOS(i).linha('NºNFET')      := vContador;
       P_LISTADADOS(i).linha('EMISSAOT')    := vContador;
       
       --Conto quantas mercadorias tem para a coleta.
       select count (*)
         into vContador
         from tdvadm.t_arm_coletancompra a
        where a.arm_coletancompra = vColeta
          and a.arm_coleta_ciclo  = vCiclo;
        
        -- Quantidade Total de mercadoria.  
       P_LISTADADOS(i).linha('CONTEUDOT') := vContador;   
       
       -- Somo o peso total das notas
       select sum(a.arm_nota_peso)
         into vContador
         from tdvadm.t_arm_nota a
        where a.arm_coleta_ncompra = vColeta
          and a.arm_coleta_ciclo  = vCiclo;
       
       --Peso total das notas.
       P_LISTADADOS(i).linha('PESOT') := vContador;
      
      -- Alimento as variveis com dados da placa e motorista baseado no vinculo com a coleta.
      begin
       select mt.arm_coleta_motorista_placa,
              mt.arm_coleta_motorista_placasaqu,
              mt.arm_coleta_placa2,
              mt.arm_coleta_placa2saque,
              mt.arm_coleta_carreteiro
         into vPlaca,    
              vPlacaSQ,  
              vPlaca2,   
              vPlaca2SQ, 
              vCPFMOT
         from tdvadm.t_arm_coleta_motorista mt
        where mt.arm_coleta_ncompra = vColeta
          and mt.arm_coleta_ciclo   = vCiclo
          and rownum = '1';
       exception when others then
         P_MESSAGE := 'Coleta sem motorista vinculado';
         P_STATUS  := 'E';
       end;   
         
        --Verifica se é frota pela placa
          select count (*)
            into vContador
           from tdvadm.t_frt_veiculo ve
          where ve.frt_veiculo_placa = vPlaca
            and ve.frt_veiculo_datavenda is null;
            
        --Verifica se é frota pelo CPF   
         select count (*)
            into vContador
           from tdvadm.t_frt_motorista ve
          where ve.frt_motorista_cpf = vCPFMOT;
          
         --Se for frota, pego os dados nas tabelas de frota
          if vContador > 0 then
            
          --Alimento variaveis dados da placa
            select ma.frt_marmodveic_marca || ma.frt_marmodveic_modelo,
                   ve.frt_veiculo_placacidade,
                   ve.glb_estado_codigo
              into vMarcaModelo,
                   vCidadePlaca,
                   vUFPlaca
              from tdvadm.t_frt_veiculo    ve,
                   tdvadm.t_frt_marmodveic ma
             where ve.frt_marmodveic_codigo = ma.frt_marmodveic_codigo
               and ve.frt_veiculo_placa     = vPlaca
               and substr(ve.frt_veiculo_codigo,1) not like '%A%'
               and rownum = '1';
          
          --Alimento variaveis dados motorista
            select mo.frt_motorista_nome,
                   mo.frt_motorista_rgcodigo,
                   mo.frt_motorista_cnhcodigo,
                   mo.frt_motorista_prontuariocod
              into vMotNome,
                   vRGMot,
                   vCNHMot,
                   vProntuarioMot
              from tdvadm.t_frt_motorista mo
             where mo.frt_motorista_cpf = vCPFMOT
               and rownum = '1';
              
            --Alimentos os dados com as informações do Frota (Frota,Motorista,Proprietario).
            
            P_LISTADADOS(i).linha('FROTA')          := vPlaca;
            P_LISTADADOS(i).linha('PLACA')          := vPlaca;
            P_LISTADADOS(i).linha('CARRETA')        := vPlaca2;
            P_LISTADADOS(i).linha('MARCA')          := vMarcaModelo;
            P_LISTADADOS(i).linha('MUNICIPIO4')     := vCidadePlaca;
            P_LISTADADOS(i).linha('UF4')            := vUFPlaca;
            P_LISTADADOS(i).linha('MOTORISTA')      := vMotNome;
            P_LISTADADOS(i).linha('CPF')            := vCPFMOT;
            P_LISTADADOS(i).linha('RG')             := vRGMot;
            P_LISTADADOS(i).linha('CNH')            := vCNHMot;
            P_LISTADADOS(i).linha('PRONTUARIO')     := vProntuarioMot;
            P_LISTADADOS(i).linha('MOP')            := '';
            P_LISTADADOS(i).linha('PROPRIETARIO')   := 'TRANSPORTES DELLA VOLPE S A';
            P_LISTADADOS(i).linha('CPF2')           := '61139432000172';
            P_LISTADADOS(i).linha('CATANTT')        := 'ETC';
            P_LISTADADOS(i).linha('PESOINFO')       := '';
            P_LISTADADOS(i).linha('CC')             := '';
            P_LISTADADOS(i).linha('AJUDANTES')      := '';
          else
            
          -- Alimento as váriaveis pegando da base de carreteiro se não for frota, essa tabela também serve para agregados.
             select ve.car_veiculo_marca ||'-'|| ve.car_veiculo_tipo,
                    ve.car_veiculo_placacidade,
                    ve.glb_estadoveiculo_codigo,
                    ve.car_proprietario_cgccpfcodigo
               into vMarcaModelo,
                    vCidadePlaca,
                    vUFPlaca,
                    vProprietario
               from tdvadm.t_car_veiculo ve
              where ve.car_veiculo_placa = vPlaca
                and ve.car_veiculo_saque = vPlacaSQ;   
         
         --Pego os dados do motorista baseado no último saque da ficha.       
              select cr.car_carreteiro_nome,
                     cr.car_carreteiro_rgcodigo,
                     cr.car_carreteiro_cnhcodigo,
                     cr.car_carreteiro_prontuariocodig
                into vMotNome,
                     vRGMot,
                     vCNHMot,
                     vProntuarioMot
                from tdvadm.t_car_carreteiro cr
               where cr.car_carreteiro_cpfcodigo = vCPFMOT
                 and cr.car_carreteiro_saque     = (select max (ca.car_carreteiro_saque)
                                                      from tdvadm.t_car_Carreteiro ca
                                                     where ca.car_carreteiro_cpfcodigo = cr.car_carreteiro_cpfcodigo);
         
        -- Alimento os dados com informações da placa e do motorista.                                             
         P_LISTADADOS(i).linha('FROTA')          := vPlaca; 
         P_LISTADADOS(i).linha('PLACA')          := vPlaca;
         P_LISTADADOS(i).linha('CARRETA')        := vPlaca2;
         P_LISTADADOS(i).linha('MARCA')          := vMarcaModelo;
         P_LISTADADOS(i).linha('MUNICIPIO4')     := vCidadePlaca;
         P_LISTADADOS(i).linha('UF4')            := vUFPlaca;
         P_LISTADADOS(i).linha('MOTORISTA')      := vMotNome;
         P_LISTADADOS(i).linha('CPF')            := vCPFMOT;
         P_LISTADADOS(i).linha('RG')             := vRGMot;
         P_LISTADADOS(i).linha('CNH')            := vCNHMot;             
         P_LISTADADOS(i).linha('PRONTUARIO')     := vProntuarioMot;
         
         
         --Alimento as variáveis com informações do proprietário do veículo
         select pr.car_proprietario_razaosocial,
                pr.car_proprietario_cgccpfcodigo,
                pr.car_proprietario_classantt
           into vPropRazao,         
                vProprietario,
                vPropANTT 
           from tdvadm.t_Car_proprietario pr
          where pr.car_proprietario_cgccpfcodigo = vProprietario;
          
         --Alimento os dados baseado nas informações do proprietário. 
          P_LISTADADOS(i).linha('PROPRIETARIO')   := vPropRazao; 
          P_LISTADADOS(i).linha('CPF2')           := vProprietario;
          P_LISTADADOS(i).linha('CATANTT')        := vPropANTT;
          P_LISTADADOS(i).linha('PESOINFO')       := '';
          P_LISTADADOS(i).linha('CC')             := '';
          P_LISTADADOS(i).linha('AJUDANTES')      := '';
          
         end if;
         
         P_LISTADADOS(i).linha('AJUDANTES')      := '';
          
        --Altero a coleta informando que foi impressa.  
          update tdvadm.t_arm_coleta co
             set co.usu_usuario_codigo_impresso = vUsuarioTDV,
                 co.arm_coleta_dtimp            = sysdate
           where co.arm_coleta_ncompra = vColeta
             and co.arm_coleta_ciclo   = vCiclo;
         commit;
          
       
  end SP_RETDADOCOLETA;                                                             

END PKG_GLB_PCL;
/
