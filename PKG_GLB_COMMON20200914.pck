create or replace package PKG_GLB_COMMON is


/********************************************************************************************************************/
/*                                           RELA«√O DE TIPO P⁄BLICOS                                               */
/********************************************************************************************************************/ 


--Tipo utilizado para declaraÁ„o de Cursores.
TYPE T_CURSOR IS REF CURSOR;
  
--Tipo utilizado em retorno de FunÁıes.
Type tRetornoFunc  Is Record ( Status         Char(1),
                               Message        Varchar2(10000),
                               Status_Boolean Char(1),
                               Controle       Integer,
                               Xml            Clob,
                               StrCursor      Varchar2(32767)
                             );  


  Type tString Is Record ( pString VARCHAR2(2000));   

  Type tListString Is Table Of tString Index By Binary_Integer;                             

  Type tLetrasContainer Is Record ( pValor number);   

  Type tListLetraContainer Is Table Of tLetrasContainer Index By varchar2(1);                             

  
/********************************************************************************************************************/
/*                                         RELA«√O DE CONSTANTES P⁄BLICAS                                           */
/********************************************************************************************************************/ 
  --Constants utilizadas como retorno de Status. 
  Status_Nomal   Constant Char(1) := 'N';
  Status_Erro    Constant Char(1) := 'E';
  Status_Warning Constant Char(1) := 'W';  


  --Constants utilizadas como retorno booleano.
  Boolean_Sim   Constant Char(1) := 'S';
  Boolean_Nao   Constant Char(1) := 'N';
  

  -- Constante para Senha Menu
  -- original da forma que dava erro com o 4
--  cCaracter    Constant char(62) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
--  cCaracterInv Constant char(62) := '‰‚w¸ø}|{√„•¢!"#$%¿¬&,()*+ª´°ºΩ¨-ø∫™—./£[‹÷\˘˚ÚˆÙ∆Ê>≈ƒÏÓÔdÎÍlÂ‡';
  -- alterada
  cCaracter    Constant char(62) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  cCaracterInv Constant char(62) := '‰‚w¸=}|{√„•¢!"#$%¿¬&,()*+ª´°ºΩ¨-ø∫™—./£[‹÷\˘˚ÚˆÙ∆Ê>≈ƒÏÓÔdÎÍlÂ‡';
   
  cListaLimpaXML1 Constant char(62):= 'çøøÌ‡˛øø∫ø¥µ≥$±«Á√·ÈÛ˙‚ÙÍ„ı”’…ÃÕ¡¿‹⁄‘ ¬Æ¥Ωæ≤®øÿ∑∞∫• ™ºß£øø©°&';
  cListaLimpaXML2 Constant char(62):= '   ia          CcAaeouaoeaooOEIIAAUUOEA                    i ';

/********************************************************************************************************************/
/*                                         RELA«√O DE VARIAVEIS PUBLICAS                                           */
/********************************************************************************************************************/ 

-- Variaveis de ambiente para os Fechamentos

   vREFCONTABIL char(7) := '0000000';
   vDATACONTABIL DATE   := TO_DATE('01/01/1900','DD/MM/YYYY');

   vREFFIS  char(7) := '0000000';
   vDATAFIS DATE   := TO_DATE('01/01/1900','DD/MM/YYYY');

   vREFVFF  char(7) := '0000000';
   vDATAVFF DATE   := TO_DATE('01/01/1900','DD/MM/YYYY');
   
   --Vari·vel utilizada para saber quem est· chamando a vari·vel
   ChamadaIntenoTDV Char(01) := 'N';


  
 
/********************************************************************************************************************/
/*                                          RELA«√O DE FUN«’ES P⁄BLICAS                                             */
/********************************************************************************************************************/ 
--FunÁ„o utilizada para remover Acentros, Indicada para limpeza de arquivos XML.
FUNCTION Fn_Limpa_Campo( pCodigo Varchar2 ) Return Varchar2;

Function Fn_Limpa_Campocl(pCodigo clob) Return clob;


-- Para remover os carateres especiais do Telefone retornonado somente os numeros
FUNCTION Fn_Limpa_CampoTel(pstring  char,
                           pTrocaPNulo char default 'S') return char;


-- Retorna a proxima referencia no formato 'aaaamm'
FUNCTION Fn_Refr_Next(PRef IN CHAR) RETURN CHAR;

-- Retorna a referencia anterior no formato 'aaaamm'
FUNCTION Fn_Refr_Antr(PRef IN CHAR) RETURN CHAR;

--FuncÁ„o utilizada para recuperar determinado valor de um arquivo XML de entrada
FUNCTION Fn_GetParams_Xml( pXml Varchar2, pParams Char ) Return Varchar2;
  

FUNCTION Fn_IsNullorEmpty(P_VALUE IN VARCHAR2) return BOOLEAN;
  
FUNCTION Fn_GetPathPdf(P_TPCAMINHO IN VARCHAR2) RETURN VARCHAR2;  

FUNCTION Fn_Split(pValue VARCHAR2,pDelimiter CHAR) RETURN tListString;

FUNCTION Fn_QuotedStr(pVariavel In Varchar2) Return Varchar2;

function Fn_RetornaTAG(pQual in Char Default '0', -- 0 retorna a quantidade de TAG¥s
                       pString in Char, 
                       pSeparadorI in char default '<<',
                       pSeparadorF in char default '>>')
return char;                       


FUNCTION Fn_QueryString(P_QUERYSTRING CHAR,
                        P_SUBSTRING   CHAR,
                        P_IGUAL       CHAR DEFAULT '=',
                        P_SEPARADOR   CHAR DEFAULT '&',
                        P_POSICAO     NUMBER DEFAULT 1) RETURN Char;
 
  
FUNCTION Fn_Refresh return date;

FUNCTION Fn_getParams_XmlOut( pXml Varchar2, pParams  Char ) Return Varchar2;

FUNCTION Fn_glb_messagem(p_aplicacao in t_usu_aplicacao.usu_aplicacao_codigo%type,
                           p_mensagem  in t_glb_appmsg.glb_appmsg_mensagem%type,
                           p_codmsg    in t_glb_appmsg.glb_appmsg_mensagemcod%type) return char;
                         
function fn_VerificaDigContainer(pLacre in char) return char;


FUNCTION Fn_CalcCnpj(P_CODG CHAR) RETURN CHAR;

FUNCTION Fn_CalcCpf(P_CODG CHAR) RETURN STRING;
/********************************************************************************************************************/
/*                                          RELA«√O DE PROCEDUREA P⁄BLICAS                                          */
/********************************************************************************************************************/ 
Procedure Sp_TesteXml( PPARAMSENTRADA    In  Varchar2,
                       pStatus           out Char,
                       pMessage          Out Varchar2,
                       pParamsSaida      Out Varchar2
                      );

--Procedure utilizada para re-fazer imagens de CTRCs
procedure Sp_Refaz_ImgCtrc( pCtrc_DtSaida  in varchar2,
                            pStatus        out char,
                            pMessage       out Varchar2
                          );                        
                          
-- FunÁ„o utilizada para enviar e-mails, recebendo como paramentro o endereÁo e a mensagen a ser enviada                                
PROCEDURE Sp_EnviaEmail( pEndereco   in  char,
                         pAssunto    in  char,
                         pMensagem   in  varchar2
                       );                          
                      
 Procedure sp_ListaRota(P_Cursor  out T_Cursor) ;                      
                      
  
 PROCEDURE SP_GLB_ROTINASDIARIAS ; 
  
 procedure sp_consulta_cep( pCep in varchar2,
                            pTpRetorno in varchar2 default 'xml',
                            pRetorno out varchar2 );
 
 PROCEDURE SET_SISTEMAFECHAMENTO(pSistema in varchar2,
                                 pRefFechamento IN CHAR,
                                 pDtFechamento in date default sysdate,
                                 pStatus out char,
                                 pMessage out varchar2
                                );

 PROCEDURE SET_SISTEMAREABERTURA(pSistema in varchar2,
                                 pRefFechamento IN CHAR,
                                 pStatus out char,
                                 pMessage out varchar2
                                );                                

 function  GET_SISTEMAFECHAMENTO(pSistema in varchar2,
                                 pRetrono in char default 'D'
                                ) return varchar2;            

 Function Fn_IfThen(pCondicao Boolean,
                    pResultTrue Varchar2,
                    pResultFalse Varchar2) return Varchar2;

  FUNCTION FN_GET_DISTANCIA(P_LAT_A NUMBER,
                            P_LON_A NUMBER,
                            P_LAT_B NUMBER,
                            P_LON_B NUMBER) RETURN NUMBER;

  function fn_get_distanciaIBGE(pIBGEOri in v_glb_ibge.codmun%type,
                                pIBGEDes in v_glb_ibge.codmun%type)
     return number;
     
  function fn_get_distanciaLOC(pLocalidadeOri in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                               pLocalidadeDes in tdvadm.t_glb_localidade.glb_localidade_codigo%type)
     return number;

  function fn_get_logradouro_endereco(P_ENDERECO varchar2) return varchar2;

  function fn_get_numero_endereco(P_ENDERECO varchar2) return varchar2;

  function fn_get_complemento_endereco(P_ENDERECO varchar2) return varchar2;

  FUNCTION FN_CALCULA_IDADE(pDataInical in date,
                            pDataFinal  in date defaul sysdate,
                            pFormato    in char defual 'C')
     return varchar2;

end PKG_GLB_COMMON;

 
/
create or replace package body PKG_GLB_COMMON Is


   
----------------------------------------------------------------------------------------------------------------------
--FUN«√O UTILIZADA PARA REMOVER ACENTROS, INDICADA PARA LIMPEZA DE ARQUIVOS XML.                                    --
----------------------------------------------------------------------------------------------------------------------
Function Fn_Limpa_Campo(pCodigo Varchar2) Return Varchar2 Is

 --Vogais Maiusculas
 vEspecialMaiusc Char(31) := '¡√¬¿∆»… ÕÃŒ”‘“’⁄Ÿ€«&∫ß£ø©ø∑ø—‹';
 vTraduzMaiusc Char(31)   := 'AAAA EEEIIIOOOOUUUCE        NU'; 
 
 --Vogais Minusculas
 vEspecialMinusc Char(25) := '·„‚‡ËÈÍÌÏÓÛÙÚı˙˘˚¸Á™∫øÒÔ˝';
 vTraduzMinusc Char(25)   := 'aaaaeeeiiioooouuuucao ni '; 

 --Caracteres especiais. 
 vEspecialChar varchar2(100) := 'çøøøøø&¥µ≥*$#%∫±Æ¥Ω≤®øÿ∑∞•æ™º£øø©∑∫ø°?øÅ†¯Æ∞øøπ¢øø◊øø¶';
 vTraduzChar varchar(100)    := '      e                                       1   x  ';
 --Vari·vel utilizada como retorno da FunÁ„o
 vRetorno Varchar2(32700):= ''; 

Begin

  --Alimento a vari·vel vRetorno com o Paramentro de entrada para trabalhar apenas com uma vari·vel
  vRetorno := Trim(pCodigo);

  --Espeiciais Maiusculas
  vRetorno := Translate(vRetorno, vEspecialMaiusc, vTraduzMaiusc);
      
  --Especiais Minusculas
  vRetorno := Translate(vRetorno, vEspecialMinusc, vTraduzMinusc);
      
  --Epeciais Caracteres
  vRetorno := Translate(vRetorno, vEspecialChar, vTraduzChar);

  --Retorno a Vari·vel apÛs traduÁ„o
  Return vRetorno;
    
End FN_LIMPA_CAMPO; 


Function Fn_Limpa_Campocl(pCodigo clob) Return clob Is

 --Vogais Maiusculas
 vEspecialMaiusc Char(31) := '¡√¬¿∆»… ÕÃŒ”‘“’⁄Ÿ€«&∫ß£ø©ø∑ø—‹';
 vTraduzMaiusc Char(31)   := 'AAAA EEEIIIOOOOUUUCE        NU'; 
 
 --Vogais Minusculas
 vEspecialMinusc Char(25) := '·„‚‡ËÈÍÌÏÓÛÙÚı˙˘˚¸Á™∫øÒÔ˝';
 vTraduzMinusc Char(25)   := 'aaaaeeeiiioooouuuucao ni '; 

 --Caracteres especiais. 
 vEspecialChar varchar2(100) := 'çøøøøø&¥µ≥*$#%∫±Æ¥Ω≤®øÿ∑∞•æ™º£øø©∑∫ø°?øÅ†¯Æ∞øøπ¢øø◊øø';
 vTraduzChar varchar(100)    := '      e                                       1   x  ';

 --Vari·vel utilizada como retorno da FunÁ„o
 vRetorno clob := empty_clob; 
 vAuxiliar number := 0;
 vAuxiliarChar  varchar2(30000);
 VposIni  number := 1;

Begin
  vAuxiliar := length(pCodigo);
  
  loop

     vAuxiliarChar := substr(pCodigo,VposIni,30000);
     VposIni := VposIni + 30000;

     --Espeiciais Maiusculas
     vAuxiliarChar := Translate(vAuxiliarChar, vEspecialMaiusc, vTraduzMaiusc);
      
     --Especiais Minusculas
     vAuxiliarChar := Translate(vAuxiliarChar, vEspecialMinusc, vTraduzMinusc);
      
     --Epeciais Caracteres
     vAuxiliarChar := Translate(vAuxiliarChar, vEspecialChar, vTraduzChar);

     vRetorno :=  vRetorno || Trim(vAuxiliarChar);
    
    exit when VposIni >= vAuxiliar ;
  end loop;

  --Retorno a Vari·vel apÛs traduÁ„o
  Return vRetorno;
    
End FN_LIMPA_CAMPOcl; 



-------------------------------------------------------------------------------
--  FUN«√O UTILIZADA PARA caracteres dos telefones, deixando somente numeros  -
-------------------------------------------------------------------------------
function Fn_Limpa_CampoTel(pstring  char,
                           pTrocaPNulo char default 'S') return char as

 vEspecialChar Char(18) := '()-_.<>\|{}[]: ' || ''''||chr(10)||chr(13);
 vTraduzChar Char(18)   := '                  ';
 vTraduzNull Char(18)   := 'ßßßßßßßßßßßßßßßßßß';
 vRetorno Varchar2(12)  := ''; 

begin

  if pTrocaPNulo = 'N' then
     vRetorno := trim(substr(Translate(FN_LIMPA_CAMPO(pstring), vEspecialChar, vTraduzChar),1,12));
  Else
     vRetorno := trim(substr(Translate(FN_LIMPA_CAMPO(pstring), vEspecialChar, vTraduzNull),1,12));
     vRetorno := replace(vRetorno,'ß','');
  End If;   

  return vRetorno;

end;

---------------------------------------------------------------------------------------------------------------------------
-- FunÁ„o utilizada para retornar a proxima referencia no formato "AAAAMM"
----------------------------------------------------------------------------------------------------------------------------

Function Fn_Refr_Next(PRef IN Char) Return Char Is

 vMes Char(2) := substr(pref,5,2);
 vAno Char(4) := substr(pref,1,4);

begin
  If vMes = '12' then
     vMes := '01';
     vAno := trim(to_char(vAno+1,'0000'));  
  Else
     vMes := trim(to_char(vMes+1,'00'));
  End If;
  return vAno||vMes;
end;

---------------------------------------------------------------------------------------------------------------------------
-- FunÁ„o utilizada para retornar a referencia anterior no formato "AAAAMM"
----------------------------------------------------------------------------------------------------------------------------

Function Fn_Refr_Antr(PRef IN Char) Return Char Is

 vMes Char(2) := substr(pref,5,2);
 vAno Char(4) := substr(pref,1,4);

begin
  If vMes = '01' then
     vMes := '12';
     vAno := trim(to_char(vAno-1,'0000'));  
  Else
     vMes := trim(to_char(vMes-1,'00'));
  End If;
  return vAno||vMes;
end;

---------------------------------------------------------------------------------------------------------------------------
-- FuncÁ„o utilizada para recuperar determinado valor de um arquivo XML de entrada.                                       --
----------------------------------------------------------------------------------------------------------------------------
Function Fn_GetParams_Xml( pXml     Varchar2,
                           pParams  Char ) Return Varchar2 Is
 --Vari·vel utilizada para gerar a busca.
 vString Varchar2(32000);
 
 --Vari·vel utilizada como retorno da funÁ„o.
 vParamsRetorno  Varchar2(100);
Begin
  --Vale lembrar que os nodes devem estar em caixa baixa.
  vString := '';
  vString := vString || ' Select  ';
  vString := vString || '   Trim(extractvalue(value(field), ßinput/' || pParams ||'ß ))';
  vString := vString || ' from ';
  vString := vString || '   Table(xmlsequence( Extract(xmltype.createXml(ß'|| pXml || 'ß) , ß/parametros/inputs/inputß))) field';  

  --troco o caracter coringas 'ß'  por aspas simples.
  vString := Replace(vString, 'ß', '''');
  

  Begin
    --Executo a funÁ„o passando para a variavel de retorno o parametro definido.
    Execute Immediate Trim(vString) Into vParamsRetorno;
  Exception
    --Caso n„o encontre, devolvo em branco, para n„o gerar erro.
    When no_data_found Then
    vParamsRetorno := '';
  End;  
  
  --Retorno a vari·vel preenchida ou n„o.
  Return Trim(vParamsRetorno);

End FN_getParams_Xml; 



FUNCTION Fn_IsNullorEmpty(P_VALUE IN VARCHAR2) return BOOLEAN
  AS
    V_RETURN BOOLEAN;
  BEGIN
    V_RETURN := FALSE;
    
    IF (P_VALUE IS NULL) OR (P_VALUE = ' ') THEN
      V_RETURN := TRUE;  
    END IF;
    
    RETURN V_RETURN;
  END FN_ISNULLOREMPTY; 


FUNCTION Fn_GetPathPdf(P_TPCAMINHO IN VARCHAR2) RETURN VARCHAR2 AS
  vLocal tdvadm.t_usu_perfil.usu_perfil_parat%type;
BEGIN
  select p.usu_perfil_parat 
    into vLocal
  from t_usu_perfil p
  where p.usu_aplicacao_codigo = 'IMAGENSLOCAL';  
  
  IF P_TPCAMINHO = 'DB' THEN
     RETURN vLocal || '04\'|| to_char(SYSDATE,'YYYYMM')||'\';     
  ELSIF P_TPCAMINHO = 'SER' THEN
     RETURN vLocal || '04\'|| to_char(SYSDATE,'YYYYMM');
  ELSE
     RETURN '';
  END IF;    
  
  
END FN_GETPATHPDF;  
----------------------------------------------------------------------------------------------------------------------------
-- FuncÁ„o utilizada para recuperar uma lista de String                           .                                       --
----------------------------------------------------------------------------------------------------------------------------

FUNCTION Fn_Split(pValue VARCHAR2,pDelimiter CHAR)
  RETURN tListString AS
  
  vList       tListString;
  vStrTemp    varchar2(2000);
  vIndexFist  INTEGER;
  vIndexLast  INTEGER;
  vIndexList  INTEGER;
  vOcor       BOOLEAN;
  vValue      VARCHAR2(2000);
  vDelimiter  CHAR(1);
BEGIN
 
 vOcor      := FALSE;
 vIndexFist := 1;
 vIndexList := 1;
 vDelimiter := nvl(pDelimiter,';');
 
 SELECT 
   CASE 
     WHEN substr(pValue,1,1) = vDelimiter THEN substr(pValue,2,LENGTH(pValue)-1)
     ELSE pValue
   END 
   INTO vValue
 FROM dual;  
 
 SELECT 
   CASE 
     WHEN substr(vValue,-1) = vDelimiter THEN vValue
     ELSE vValue||vDelimiter
   END 
   INTO vValue
 FROM dual; 
     
 WHILE NOT (vOcor)
 LOOP
  
  vIndexLast := INSTR(vValue,vDelimiter,vIndexFist);
  
  IF vIndexLast > 0 THEN
    
    vStrTemp := substr(vValue,vIndexFist,vIndexLast-vIndexFist);
    vList(vIndexList).pString := vStrTemp;
    
    vIndexFist := vIndexLast+1;
    
    IF INSTR(vValue,vDelimiter,vIndexFist) = 0 THEN
       vOcor := TRUE; 
    ELSE
       vIndexList := vIndexList+1;
    END IF;      
     
  END IF;  
      
 END LOOP;    
  
 RETURN vList;
   
END fn_Split;


Function  Fn_QuotedStr(pVariavel In Varchar2) Return Varchar2 As
Begin
  
  Return '''' || Trim(pVariavel) || '''';
  
End fn_QuotedStr;

function Fn_RetornaTAG(pQual in Char Default '0', -- 0 retorna a quantidade de TAG¥s
                       pString in Char, 
                       pSeparadorI in char default '<<',
                       pSeparadorF in char default '>>')
return char is
  vContador   number;
  vPosInicial number;
  vPosFinal   number;
  vRetorno    varchar2(50);
  vTamanho    number;
  vSeparadorI  varchar2(5);
  vSeparadorF  varchar2(5);
  
  
  
Begin
   vSeparadorI := nvl(pSeparadorI,'<<');
   vSeparadorF := nvl(pSeparadorF,'>>');
   vContador := 0;
   vPosInicial := instr(pString,vSeparadorI);
   if vPosInicial > 0 Then
      vContador := 1;
   End If;   
    
   loop
      if pQual = vContador then
        Exit;
      End If;  
      vPosInicial :=  instr(pString,vSeparadorI,vPosInicial + length(vSeparadorI));
      if vPosInicial = 0 Then
         exit;
      Else
         vContador := vContador + 1;
      End If;   
   End Loop;
   
   if  pQual > vContador Then
      return ''; 
   End If;
   

   if pQual = '0' Then
      vRetorno := to_char(vContador);
   Else  
     if vPosInicial > 0 Then
        vPosFinal := instr(pString,vSeparadorF,vPosInicial);
     End If;
     vPosInicial := vPosInicial + length(vSeparadorI); 
     vTamanho := vPosFinal - vPosInicial;
     vRetorno := substr(pString,vPosInicial,vTamanho);
   End If;

   Return vRetorno;

End Fn_RetornaTAG;                       
                       

FUNCTION Fn_QueryString(P_QUERYSTRING CHAR,
                        P_SUBSTRING   CHAR,
                        P_IGUAL       CHAR DEFAULT '=',
                        P_SEPARADOR   CHAR DEFAULT '&',
                        P_POSICAO     NUMBER DEFAULT 1)
RETURN CHAR IS
  V_INICIOQSTRING       INTEGER;
  V_FIMQSTRING          INTEGER;
  V_IGUALQSTRING        INTEGER;
  V_TAMQSTRING          INTEGER;
  i                     INTEGER;
  vArgumento            varchar2(100);
  vIgual                char(1);
  vSeparador            char(1);
  vPosicao              integer;
BEGIN

  V_INICIOQSTRING := 0;
  vIgual := nvl(P_IGUAL,'=');
  vSeparador := nvl(P_SEPARADOR,'&');
  vPosicao   := nvl(P_POSICAO,1);
   
  if instr(TRIM(P_SUBSTRING),TRIM(vIgual)) <> length(TRIM(P_SUBSTRING)) Then
     vArgumento := TRIM(P_SUBSTRING)||TRIM(vIgual);
  else
     vArgumento := P_SUBSTRING; 
  end if;   
  
  V_INICIOQSTRING := INSTR(P_QUERYSTRING,vArgumento);
--V_INICIOQSTRING := INSTR(P_QUERYSTRING,P_SUBSTRING);


  IF V_INICIOQSTRING > 0  THEN
      V_IGUALQSTRING := INSTR(P_QUERYSTRING,vIgual,V_INICIOQSTRING);
      V_FIMQSTRING := INSTR(P_QUERYSTRING,vSeparador,V_IGUALQSTRING);
      IF V_FIMQSTRING = 0 THEN
         V_FIMQSTRING := LENGTH(P_QUERYSTRING) + 1;
      END IF;   
      V_TAMQSTRING := V_FIMQSTRING - V_IGUALQSTRING;
      RETURN SUBSTR(P_QUERYSTRING,V_IGUALQSTRING + 1,V_TAMQSTRING-1);
  ELSE
    RETURN '';
  END IF;    
End FN_QUERYSTRING;

FUNCTION Fn_Refresh return date
   is
     vReturn date;
   begin
     select sysdate
       into vReturn
       from dual;
     return vReturn;
end Fn_Refresh;

----------------------------------------------------------------------------------------------------------------------------
-- FuncÁ„o utilizada para recuperar determinado valor de um arquivo XML de entrada.                                       --
----------------------------------------------------------------------------------------------------------------------------
Function Fn_getParams_XmlOut( pXml     Varchar2,
                              pParams  Char ) Return Varchar2 Is
 --Vari·vel utilizada para gerar a busca.
 vString Varchar2(32000);
 
 --Vari·vel utilizada como retorno da funÁ„o.
 vParamsRetorno  Varchar2(100);
Begin
  --Vale lembrar que os nodes devem estar em caixa baixa.
  vString := '';
  vString := vString || ' Select  ';
  vString := vString || '   Trim(extractvalue(value(field), ßoutput/' || pParams ||'ß ))';
  vString := vString || ' from ';
  vString := vString || '   Table(xmlsequence( Extract(xmltype.createXml(ß'|| pXml || 'ß) , ß/parametros/outputß))) field';  

  --troco o caracter coringas 'ß'  por aspas simples.
  vString := Replace(vString, 'ß', '''');
  

  Begin
    --Executo a funÁ„o passando para a variavel de retorno o parametro definido.
    Execute Immediate Trim(vString) Into vParamsRetorno;
  Exception
    --Caso n„o encontre, devolvo em branco, para n„o gerar erro.
    When no_data_found Then
    vParamsRetorno := '';
  End;  
  
  --Retorno a vari·vel preenchida ou n„o.
  Return Trim(vParamsRetorno);

End FN_getParams_XmlOut; 


function Fn_glb_messagem(p_aplicacao in t_usu_aplicacao.usu_aplicacao_codigo%type,
                         p_mensagem  in t_glb_appmsg.glb_appmsg_mensagem%type,
                         p_codmsg    in t_glb_appmsg.glb_appmsg_mensagemcod%type) return char is
                         
vMsgRetorno t_glb_mensagem.glb_mensagem_descricao%type;
begin
  
  begin
    
    select l.glb_mensagem_descricao
      into vMsgRetorno
      from t_glb_appmsg m,
           t_glb_mensagem l
     where m.glb_mensagem_codigo    = l.glb_mensagem_codigo
       and m.glb_appmsg_mensagemcod = p_codmsg
       and m.usu_aplicacao_codigo   = p_aplicacao;
       
  exception when No_data_found then
      begin 
         select l.glb_mensagem_descricao
            into vMsgRetorno
            from t_glb_appmsg m,
                 t_glb_mensagem l
           where m.glb_mensagem_codigo              = l.glb_mensagem_codigo
             and trim(upper(m.glb_appmsg_mensagem)) = trim(upper(p_mensagem))
             and m.usu_aplicacao_codigo             = p_aplicacao;
     exception when No_data_found then
       vMsgRetorno := 'Mensagem de ajuda n„o identificada!';
     end;  
  end;
  
  return vMsgRetorno;

end fn_glb_messagem;

function fn_VerificaDigContainer(pLacre in char) return char
Is
  vValores tListLetraContainer;
  vLacre char(10);
  vPosicao number := 1;
  vPotencia number := 0;
  vDigito   char(1);
  vValorDigito number;
  vValorTotal number;
  vDidVerificado number;
Begin

   if pLacre is Not null Then
      if length(trim(pLacre)) <>  11 Then
         return 'E';
      End If;
      vLacre := upper(substr(pLacre,1,10));
   Else
      vLacre := 'HOYU751013';
   End If;         



-- (salta-se o 11 e seus m˙ltiplos 22 e 33) 
  vValores('A').pValor := 10;
  vValores('B').pValor := 12; 
  vValores('C').pValor := 13;
  vValores('D').pValor := 14;
  vValores('E').pValor := 15;
  vValores('F').pValor := 16;
  vValores('G').pValor := 17;
  vValores('H').pValor := 18;
  vValores('I').pValor := 19;
  vValores('J').pValor := 20;
  vValores('K').pValor := 21;
  vValores('L').pValor := 23;
  vValores('M').pValor := 24;
  vValores('N').pValor := 25;
  vValores('O').pValor := 26;
  vValores('P').pValor := 27;
  vValores('Q').pValor := 28;
  vValores('R').pValor := 29;
  vValores('S').pValor := 30;
  vValores('T').pValor := 31;
  vValores('U').pValor := 32;
  vValores('V').pValor := 34;
  vValores('W').pValor := 35;
  vValores('X').pValor := 36;
  vValores('Y').pValor := 37;
  vValores('Z').pValor := 38;

   

-- Multiplica-se cada dÌgito por uma potÍncia de 2 (de 0 atÈ 9), soma-se os resultados e calcula-se o resultado mÛdulo de 11 (resto da divis„o inteira por 11). 

-- Exemplo: HOYU751013 6 (dÌgito verificador 6) 
 vValorTotal := 0;
 vPotencia := 0;
 vPosicao  := 1;
 loop

   vDigito := substr(vLacre,vPosicao,1);
   
   if f_enumerico(vDigito) = 'S' Then
      vValorDigito := to_number(vDigito);
   Else
      vValorDigito := vValores(vDigito).pValor;
   End If;
   
   vValorTotal := vValorTotal + ( vValorDigito * (2**vPotencia) );
   
   vPotencia := vPotencia + 1;
   vPosicao  := vPosicao + 1;
   
   exit when vPosicao = 11 ;
 end loop; 
 
 vDidVerificado := (vValorTotal mod 11);
 
 if substr(pLacre,vPosicao,1) = vDidVerificado Then
    Return 'S';
 Else
    Return 'N';
 End If;   
 
End fn_VerificaDigContainer;

FUNCTION Fn_CalcCnpj(P_CODG CHAR) RETURN CHAR

IS

VT_CNPJ CHAR(14);
VT_REST INTEGER;
VT_PDIG INTEGER;
VT_SDIG INTEGER;

BEGIN
  IF LENGTH(TRIM(P_CODG)) <> 12 THEN
    RETURN 'ERRO';
  ELSE
    VT_CNPJ := REPLACE(REPLACE(REPLACE(P_CODG,'.'),'/'),'-');
    VT_REST  := MOD((5*SUBSTR(VT_CNPJ,1,1))+
                   (4*SUBSTR(VT_CNPJ,2,1))+
                   (3*SUBSTR(VT_CNPJ,3,1))+
                   (2*SUBSTR(VT_CNPJ,4,1))+
                   (9*SUBSTR(VT_CNPJ,5,1))+
                   (8*SUBSTR(VT_CNPJ,6,1))+
                   (7*SUBSTR(VT_CNPJ,7,1))+
                   (6*SUBSTR(VT_CNPJ,8,1))+
                   (5*SUBSTR(VT_CNPJ,9,1))+
                   (4*SUBSTR(VT_CNPJ,10,1))+
                   (3*SUBSTR(VT_CNPJ,11,1))+
                   (2*SUBSTR(VT_CNPJ,12,1)),11);

    IF VT_REST IN (0,1) THEN
      VT_PDIG := 0;
    ELSE
      VT_PDIG := 11-VT_REST;
    END IF;


    VT_REST  := MOD((6*SUBSTR(VT_CNPJ,1,1))+
                    (5*SUBSTR(VT_CNPJ,2,1))+
                    (4*SUBSTR(VT_CNPJ,3,1))+
                    (3*SUBSTR(VT_CNPJ,4,1))+
                    (2*SUBSTR(VT_CNPJ,5,1))+
                    (9*SUBSTR(VT_CNPJ,6,1))+
                    (8*SUBSTR(VT_CNPJ,7,1))+
                    (7*SUBSTR(VT_CNPJ,8,1))+
                    (6*SUBSTR(VT_CNPJ,9,1))+
                    (5*SUBSTR(VT_CNPJ,10,1))+
                    (4*SUBSTR(VT_CNPJ,11,1))+
                    (3*SUBSTR(VT_CNPJ,12,1))+
                    (2*VT_PDIG),11);

    IF VT_REST IN (0,1) THEN
      VT_SDIG := 0;
    ELSE
      VT_SDIG := 11-VT_REST;
    END IF;

    RETURN VT_PDIG||VT_SDIG ;

  END IF;
END Fn_CalcCnpj;

FUNCTION Fn_CalcCpf(P_CODG CHAR) RETURN STRING

IS

VT_CPF  CHAR(14);
VT_REST INTEGER;
VT_PDIG INTEGER;
VT_SDIG INTEGER;

BEGIN
  IF LENGTH(TRIM(P_CODG)) <> 9 THEN
    RETURN '**';
  ELSE
    VT_CPF  := replace(replace(P_CODG,'.'),'-');
    VT_REST  := MOD((10*SUBSTR(VT_CPF,1,1))+
                    (9*SUBSTR(VT_CPF,2,1))+
                    (8*SUBSTR(VT_CPF,3,1))+
                    (7*SUBSTR(VT_CPF,4,1))+
                    (6*SUBSTR(VT_CPF,5,1))+
                    (5*SUBSTR(VT_CPF,6,1))+
                    (4*SUBSTR(VT_CPF,7,1))+
                    (3*SUBSTR(VT_CPF,8,1))+
                    (2*SUBSTR(VT_CPF,9,1)),11);

    IF VT_REST IN (0,1) THEN
      VT_PDIG := 0;
    ELSE
      VT_PDIG := 11-VT_REST;
    END IF;

    VT_REST  := MOD((11*SUBSTR(VT_CPF,1,1))+
                    (10*SUBSTR(VT_CPF,2,1))+
                    (9*SUBSTR(VT_CPF,3,1))+
                    (8*SUBSTR(VT_CPF,4,1))+
                    (7*SUBSTR(VT_CPF,5,1))+
                    (6*SUBSTR(VT_CPF,6,1))+
                    (5*SUBSTR(VT_CPF,7,1))+
                    (4*SUBSTR(VT_CPF,8,1))+
                    (3*SUBSTR(VT_CPF,9,1))+
                    (2*VT_PDIG),11);

    IF VT_REST IN (0,1) THEN
      VT_SDIG := 0;
    ELSE
      VT_SDIG := 11-VT_REST;
    END IF;

    RETURN VT_PDIG||VT_SDIG;
  END IF;
END Fn_CalcCpf;

----------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para re-fazer imagens de CTRCs                                                                     --
----------------------------------------------------------------------------------------------------------------------------
Procedure Sp_TesteXml( PPARAMSENTRADA    In  Varchar2,
                       pStatus           out Char,
                       pMessage          Out Varchar2,
                       pParamsSaida      Out Varchar2
                      ) Is 

 vTeste sys.xmltype;                      
Begin
  
pStatus := 'W';
PmESSAGE := 'ERRO';

 vteste := XMLTYPE.CREATEXML(PPARAMSENTRADA);
 
For vCursor In ( Select 
                  extractvalue(value(field), 'ABASTECIMENTOSRow/INDICE') Indice,
                  extractvalue(value(field), 'ABASTECIMENTOSRow/NUMABAST') NumAbast
                from 
                  Table(xmlsequence( Extract(vteste , '/ABASTECIMENTOS/ABASTECIMENTOSRow'))) field

                  
               ) 
               Loop
                 PPARAMSSAIDA := PPARAMSSAIDA ||'Indice: '    || vCursor.Indice   || ' - ' || 
                                                'Num Abast.: '|| vCursor.NumAbast || chr(13) ;
               End Loop;   
               
  pStatus := 'N';
  pMessage := 'ok';               

End;

procedure Sp_Refaz_ImgCtrc( pCtrc_DtSaida  in varchar2,
                            pStatus        out char,
                            pMessage       out Varchar2
                          ) is
                          
  --Cursor de busca dos CTRC para reprocessamento
  cursor vCursor is
    select
      ctrc.con_conhecimento_codigo,
      ctrc.con_conhecimento_serie,
      ctrc.glb_rota_codigo
    from
      t_con_conhecimento ctrc  
    where
     0=0
      and Trunc(ctrc.con_conhecimento_horasaida) = to_date(pCtrc_DtSaida, 'dd/mm/yyyy')
      and ctrc.con_conhecimento_serie <> 'XXX'
      and 0 < ( Select count(*) from t_glb_cliente cli
                where cli.glb_cliente_cgccpfcodigo = ctrc.glb_cliente_cgccpfdestinatario
                and cli.glb_grupoeconomico_codigo = '0020'
               )
                  
      and 0 < ( select Count(*) from t_glb_rota rota
                where rota.glb_rota_codigo = ctrc.glb_rota_codigo
                 and rota.glb_rota_coleta = 'S'
               )
                  
    order by 
        ctrc.glb_rota_codigo,
        ctrc.con_conhecimento_codigo;

  --Vari·veis utilizada para o fetch do cursor
  vCtrc_Codigo   tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
  vCtrc_Serie    tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
  vCtrc_Rota     tdvadm.t_con_conhecimento.glb_rota_codigo%type; 
  
  --Vari·veis inteiras que serao utilizadas como controle
  vCount integer;                         
begin
  vCount := 0;

  Begin
    --Abro o cursor
    open vCursor;
    
    --entro em loop para poder percorrer o cursor
    loop
      --utilizo do fetch para poder recuperar valores do cursor
      fetch vCursor into vCtrc_Codigo,
                         vCtrc_Serie,
                         vCtrc_Rota;
      
      --garanto a saida do loop, ao final do cursor.
      exit when vCursor%notfound;
      
      --Deleto a linha da tabela de Arquivo de imagem
      delete 
        t_glb_compimagem imgCtrc
      where 
        0=0
        and imgCtrc.Con_Conhecimento_Codigo = vCtrc_Codigo
        and imgCtrc.Con_Conhecimento_Serie  = vCtrc_Serie
        and imgCtrc.Glb_Rota_Codigo         = vCtrc_Rota
        and imgCtrc.Glb_Grupoimagem_Codigo  = '04' --Conhecimento
        and imgCtrc.Glb_Tpimagem_Codigo     = '0001'  --Frente
        and imgCtrc.Glb_Tparquivo_Codigo    = '0004'; --PDF                   
        
      BEGIN  
        --Retiro o Flag da tabela de geraÁ„o de imagem.
        update  tdvadm.t_uti_ctepdf pdf 
          set pdf.uti_ctepdf_flagenvio = ''
        where
          0=0
          and pdf.uti_ctepdf_codigo = vCtrc_Codigo
          and pdf.uti_ctepdf_serie  = vCtrc_Serie
          and pdf.glb_rota_codigo   = vCtrc_Rota;
      EXCEPTION
        WHEN OTHERS THEN
          pStatus := pkg_glb_common.Status_Erro;
          pMessage := 'erro ao atualizar tabela.';
          RETURN;

      END;    
      
      --Salva as alteraÁıes.
      commit;
      
      --Incrementa a vari·vel de controle.
      vCount := vCount + 1;    
    end loop;
    
    --Fecha o cursor.
    close vCursor;
    
    --Seta os valores para os paramentros de saida;
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage := 'Foram atualizadas ' || to_char(vCount) || ' Registros.'; 

  Exception
    --caso ocorra algum erro, seta os paramentros de saida e mostra o erro na mensagem, encerra o processamento
    when others then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao abir o cursor' || sqlerrm;
      return;
  end;  
end SP_Refaz_ImgCtrc;                             


-----------------------------------------------------------------------------------------------------------------
-- FunÁ„o utilizada para enviar e-mails, recebendo como paramentro o endereÁo e a mensagen a ser enviada       --
-----------------------------------------------------------------------------------------------------------------
PROCEDURE Sp_EnviaEmail( pEndereco   in  char,
                         pAssunto    in  char,
                         pMensagem   in  varchar2
                       ) is

 --Vari·vel utilizada para montar a mensagem.
 vMessage  varchar2(2000);
Begin

 vMessage := pMensagem || chr(13) || chr(13) || chr(13) ||
             'E-MAIL ENVIADO ATRAV…S DE PROCESSO AUTOM¡TICO WORKFLOW DELLAVOLPE.' || chr(13) ||
             'FAVOR N√O RESPONDA ESSE E-MAIL.';
 
   Insert Into tdvadm.t_uti_infomail( uti_infomail_codigo,
                                       uti_infomail_nomeremetente,
                                       uti_infomail_assunto,
                                       uti_infomail_endmaildestinatar,
                                       uti_infomail_memo 
                                       ) 
                                       Values
                                       ( 'SEQUENCIAL',
                                         'IntegraÁ„o Sascar DellaVolpe',
                                         pAssunto,
                                         pEndereco,
                                         Trim(vMessage)
                                       );  
   Commit;
   
 
end SP_EnviaEmail;
 
      

      

 Procedure sp_ListaRota(P_Cursor  out T_Cursor) is
  begin
    begin
      open p_cursor for
          select 
            trim(ro.glb_rota_codigo)||' | '||trim(ro.glb_rota_descricao)||' | '||trim(ro.glb_estado_codigo) ROTA
          from t_glb_rota ro;
      
    end;

  end sp_ListaRota;    


  PROCEDURE SP_GLB_ROTINASDIARIAS
  IS 
  BEGIN  
    UPDATE T_ATR_ULTPOSICAO UP
      SET UP.CON_CONHECIMENTO_CODIGO = NULL,
          UP.CON_CONHECIMENTO_SERIE = NULL,
          UP.GLB_ROTA_CODIGO = NULL,
          UP.CON_VALEFRETE_SAQUE = NULL,
          UP.GLB_CLIENTE_CGCCPFCODIGOSAC = NULL,
          UP.GLB_CLIENTE_CGCCPFCODIGOREM = NULL,
          UP.GLB_CLIENTE_CGCCPFCODIGODES = NULL,
          UP.GLB_GRUPOECONOMICO_CODIGOS  = NULL,
          UP.GLB_GRUPOECONOMICO_CODIGOR  = NULL,
          UP.GLB_GRUPOECONOMICO_CODIGOD  = NULL
    WHERE 0 < (SELECT COUNT(*)
                from t_con_valefrete vf
                WHERE VF.con_conhecimento_codigo = UP.con_conhecimento_codigo
                  AND VF.con_conhecimento_serie  = UP.con_conhecimento_serie
                  AND VF.glb_rota_codigo         = UP.glb_rota_codigo
                  AND VF.con_valefrete_saque     = UP.con_valefrete_saque     
                  AND vf.con_valefrete_dataprazomax + 1 < trunc(SYSDATE));
    COMMIT;
    
    PKG_FRT_FROTA.SP_FRT_MONTAMEDIA;
    
  END SP_GLB_ROTINASDIARIAS;


 procedure sp_consulta_cep( pCep in varchar2,
                            pTpRetorno in varchar2 default 'xml',
                            pRetorno out varchar2 ) as
   req   utl_http.req;
   resp  utl_http.resp;
   value VARCHAR2(1024);
   vTpRetorno varchar2(20);
   vUrl varchar2(1024);
 begin
    BEGIN
      vTpRetorno := pTpRetorno; 
      if vTpRetorno is null then
         vTpRetorno := 'xml';  
      end if;
       
      vUrl := 'http://webservice.kinghost.net/web_cep.php?'||'auth=937acaa63f3d3525a527392bfec55b8e'||
              '&formato='||vTpRetorno||
              '&cep='||pCep;
      
      --dbms_network_acl_admin.assign_acl ('utl_tcp.xml',vUrl,80,80)  ;
      req := utl_http.begin_request( vUrl );
      utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
      resp := utl_http.get_response(req);
      LOOP
        utl_http.read_line(resp, value, TRUE);
        --dbms_output.put_line(value);
        pRetorno := pRetorno||value;
      END LOOP;
      utl_http.end_response(resp);
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        utl_http.end_response(resp);
    END;     
 end sp_consulta_cep;     

  

/*               fechamentos dos sistemas  TDV  */

 PROCEDURE SET_SISTEMAFECHAMENTO(pSistema in varchar2,
                                 pRefFechamento IN CHAR,
                                 pDtFechamento in date default sysdate,
                                 pStatus out char,
                                 pMessage out varchar2
                                )
 as
 Begin 

    IF pSistema NOT IN ('FPW','CTB','FIS','VFF','CPG','CAX','CRP','VFC','CON','COC','CAX015') THEN
       pStatus := pkg_glb_common.Status_Erro;
       pMessage := 'Sistema n„o Existe';  
    ELSE
       pStatus := pkg_glb_common.Status_Nomal;
       UPDATE T_USU_PERFIL P
       SET P.USU_PERFIL_PARAT = pRefFechamento,
           P.USU_PERFIL_PARAD1 = pDtFechamento
       WHERE P.USU_PERFIL_CODIGO = 'REFFECHAMENTO' || pSistema
         and p.usu_perfil_parat = TO_CHAR(add_monthS(TO_DATE(pRefFechamento,'YYYYMM'),-1),'YYYYMM');
       IF SQL%ROWCOUNT = 0 THEN 
          pStatus := pkg_glb_common.Status_Erro;
          pMessage := 'Problemas na AtualizaÁ„o ou Sistema n„o Existe';  
       end if;   
    END IF;

 End SET_SISTEMAFECHAMENTO;

 PROCEDURE SET_SISTEMAREABERTURA(pSistema in varchar2,
                                 pRefFechamento IN CHAR,
                                 pStatus out char,
                                 pMessage out varchar2
                                )
 as
 Begin 

    IF pSistema NOT IN ('FPW','CTB','FIS','VFF','CPG','CAX','CRP','VFC','CON','COC','CAX015') THEN
       pStatus := pkg_glb_common.Status_Erro;
       pMessage := 'Sistema n„o Existe';  
    ELSE
       
       if pkg_glb_common.GET_SISTEMAFECHAMENTO(pSistema,'R') = pRefFechamento Then
          pStatus := pkg_glb_common.Status_Nomal;
          UPDATE T_USU_PERFIL P
          SET P.USU_PERFIL_PARAT = TO_CHAR(ADD_MONTHS(TO_DATE(P.USU_PERFIL_PARAT,'YYYYMM'),-1),'YYYYMM'),
              P.USU_PERFIL_PARAD1 = sysdate
          WHERE P.USU_PERFIL_CODIGO = 'REFFECHAMENTO' || pSistema;
          IF SQL%ROWCOUNT = 0 THEN 
             pStatus := pkg_glb_common.Status_Erro;
             pMessage := 'Problemas na AtualizaÁ„o ou Sistema n„o Existe';  
          end if;   
       Else
          pStatus := pkg_glb_common.Status_Erro;
          pMessage := 'Referencia Errado ou n„o È a Ultima. A ultima È => ' || pkg_glb_common.GET_SISTEMAFECHAMENTO(pSistema,'R');  
       end if;   
    END IF;

 End SET_SISTEMAREABERTURA;

 function  GET_SISTEMAFECHAMENTO(pSistema in varchar2,
                                 pRetrono in char default 'D'
                                ) return varchar2
 as
  vPESQ CHAR(1) := 'N';
  vREF  CHAR(07);
  vDATA CHAR(10);  
 Begin 
    
    IF pSistema NOT IN ('FPW','CTB','FIS','VFF','CPG','CAX','CRP','VFC','CON','COC','CAX015') THEN
       vDATA := '01/01/4700';  
       vREF  := '000000'; 
    ELSE


       IF PKG_GLB_COMMON.vREFCONTABIL <> '0000000' THEN
          vREF := PKG_GLB_COMMON.vREFCONTABIL;
          vDATA := PKG_GLB_COMMON.vDATACONTABIL;
       ELSIF PKG_GLB_COMMON.vREFFIS <> '0000000' THEN
          vREF := PKG_GLB_COMMON.vREFFIS;
          vDATA := PKG_GLB_COMMON.vDATAFIS;
       ELSIF PKG_GLB_COMMON.vREFVFF <> '0000000' THEN
          vREF := PKG_GLB_COMMON.vREFVFF;
          vDATA := PKG_GLB_COMMON.vDATAVFF;
       ELSE
          vPESQ := 'S';
       END IF;      
      
       IF vPESQ = 'S' THEN
          BEGIN
            select p.usu_perfil_parat referencia,
                   p.usu_perfil_parad1 data
              INTO vREF,
                   vDATA
            from t_usu_perfil p
            where p.usu_aplicacao_codigo = '0000000000'
              and trim(p.usu_perfil_codigo) = 'REFFECHAMENTO' || pSistema;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN 
               vDATA := '01/01/4700';  
               vREF  := '000001'; 
          End; 
       END IF;   
       if pSistema = 'CON' Then
          if vDATA = '01/01/4700' Then
             vDATA := '06/05/2013';
             vREF  := '201304';
          end if;
       End If;
    
    END IF;   

    if pRetrono = 'R' Then
       return vREF;
    Else
       return vDATA;
    End if;      

 End GET_SISTEMAFECHAMENTO;

 Function Fn_IfThen(pCondicao Boolean,
                    pResultTrue Varchar2,
                    pResultFalse Varchar2) return Varchar2
 As
 Begin
     if pCondicao Then
       return pResultTrue;
     else
       return pResultFalse;
     end if;
 End Fn_IfThen;                    

----------------------------------------------------------------------------------------------------------------------
-- FunÁ„o utilizada deixar uma string entre aspas simples. Baseada na funÁ„o quotstr do DELPHI
----------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_GET_DISTANCIA(P_LAT_A NUMBER,
                            P_LON_A NUMBER,
                            P_LAT_B NUMBER,
                            P_LON_B NUMBER) RETURN NUMBER
  AS
      V_ARCO_AB   NUMBER;
      V_ARCO_BC   NUMBER;
      V_ARCO_AC   NUMBER;
      V_PI        NUMBER;
      V_ARCCOS    NUMBER;
      V_RESULT    NUMBER;
      V_DISTANCIA NUMBER;
  BEGIN
      IF (P_LAT_A = P_LAT_B) AND (P_LON_A = P_LON_B) THEN
          RETURN 0;
      END IF;
      V_PI := 3.14159;
      -- PEGA OS ARCOS E CONVERTE PARA RADIANO  
      V_ARCO_AC := ((90 - P_LAT_A) * V_PI) / 180;
      V_ARCO_BC := ((90 - P_LAT_B) * V_PI) / 180;
      V_ARCO_AB := ((P_LON_A - (P_LON_B)) * V_PI) / 180;
      
      -- APLICA-SE A FORNULA
      V_ARCCOS := ((COS(V_ARCO_AC) * COS(V_ARCO_BC)) + (SIN(V_ARCO_AC) * SIN(V_ARCO_BC) * COS(V_ARCO_AB)));
      
      -- TRANSFORMA O RESULTADO NOVAMENTE PARA GRAUS
      V_RESULT := ((ACOS(V_ARCCOS)) * 180) / V_PI;
      
      -- 40.030 E O DIAMETRO DA TERRA
      -- MULTIPLICA-SE PELO RESULTADO EM GRAUS E DIVIDE POR 360 (CIRCUNFERENCIA)
      -- MULTIPLICA-SE POR 1000 PARA OBTER A DISTANCIA EM KM
      V_DISTANCIA := ROUND(((40.030 * V_RESULT) / 360) * 1000,2); 
      
      RETURN V_DISTANCIA;
  END FN_GET_DISTANCIA;

  function fn_get_distanciaLOC(pLocalidadeOri in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                               pLocalidadeDes in tdvadm.t_glb_localidade.glb_localidade_codigo%type)
     return number
  As
    vLatitudeOri  v_glb_ibge.latitude%type;
    vLongitudeOri v_glb_ibge.longitude%type;
    vLatitudeDes  v_glb_ibge.latitude%type;
    vLongitudeDes v_glb_ibge.longitude%type;
  Begin
    Begin
      select i.latitude,
             i.longitude
        into vLatitudeOri,
             vLongitudeOri
      from t_glb_localidade l,
           v_glb_ibge i
      where l.glb_localidade_codigoibge = i.codmun
        and l.glb_localidade_codigo = pLocalidadeOri;
    Exception
      When NO_DATA_FOUND Then
         vLatitudeOri  := 0;  
         vLongitudeOri := 0;      
      End ; 
    Begin
      select i.latitude,
             i.longitude
        into vLatitudeDes,
             vLongitudeDes
      from t_glb_localidade l,
           v_glb_ibge i
      where l.glb_localidade_codigoibge = i.codmun
        and l.glb_localidade_codigo = pLocalidadeDes;
    Exception
      When NO_DATA_FOUND Then
         vLatitudeDes  := 0;  
         vLongitudeDes := 0;      
      End ; 
    
    return FN_GET_DISTANCIA(vLatitudeOri,vLongitudeOri,vLatitudeDes,vLongitudeDes); 
  
    
  End fn_get_distanciaLOC;


  function fn_get_distanciaIBGE(pIBGEOri in v_glb_ibge.codmun%type,
                                pIBGEDes in v_glb_ibge.codmun%type)
     return number
  As
    vLatitudeOri  v_glb_ibge.latitude%type;
    vLongitudeOri v_glb_ibge.longitude%type;
    vLatitudeDes  v_glb_ibge.latitude%type;
    vLongitudeDes v_glb_ibge.longitude%type;
  Begin
    Begin
      select i.latitude,
             i.longitude
        into vLatitudeOri,
             vLongitudeOri
      from v_glb_ibge i
      where i.codmun = pIBGEOri;
    Exception
      When NO_DATA_FOUND Then
         vLatitudeOri  := 0;  
         vLongitudeOri := 0;      
      End ; 
    Begin
      select i.latitude,
             i.longitude
        into vLatitudeDes,
             vLongitudeDes
      from v_glb_ibge i
      where i.codmun = pIBGEDes;
    Exception
      When NO_DATA_FOUND Then
         vLatitudeDes  := 0;  
         vLongitudeDes := 0;      
      End ; 
    
    return FN_GET_DISTANCIA(vLatitudeOri,vLongitudeOri,vLatitudeDes,vLongitudeDes); 
  
    
  End fn_get_distanciaIBGE;

  function fn_get_logradouro_endereco(P_ENDERECO varchar2)
     return varchar2
  As 
    vLogradouro varchar2(50);    
  Begin
     select UPPER(REGEXP_REPLACE(SUBSTR(REPLACE(P_ENDERECO, 'N∫', ''),
                                   1,
                                   DECODE(REGEXP_INSTR(REPLACE(P_ENDERECO, 'N∫', ''),

                                                       '\d+',
                                                       1,
                                                       1,
                                                       0,
                                                       'i'),
                                          0,
                                          LENGTH(REPLACE(P_ENDERECO, 'N∫', '')) + 1,
                                          regexp_instr(REPLACE(P_ENDERECO, 'N∫', ''),
                                                       '\d+',
                                                       1,
                                                       1,
                                                       0,
                                                       'i')) - 1),
                            '[,]\s$',
                            '')) LOGRADOURO
     INTO vLogradouro 
     FROM DUAL;
     return vLogradouro;
  End;      

  function fn_get_numero_endereco(P_ENDERECO varchar2)
     return varchar2
  As     
    vNumero varchar2(50);
  Begin      
     SELECT REGEXP_SUBSTR(replace(P_ENDERECO, '.', ''), '\d+', 1, 1, 'i') numero 
     INTO vNumero
     FROM DUAL;
     
     return vNumero;
  End;   
     
  function fn_get_complemento_endereco(P_ENDERECO varchar2)
     return varchar2
  As  
    vComplemento varchar2(50);   
  Begin       
      SELECT UPPER(REGEXP_REPLACE(REGEXP_SUBSTR(replace(P_ENDERECO, '.', ''),
                                          '.+',
                                          DECODE(REGEXP_INSTR(replace(P_ENDERECO, '.', ''),
                                                              '\d+',
                                                              1,
                                                              1,
                                                              1,
                                                              'i'),
                                                 0,
                                                 LENGTH(replace(P_ENDERECO, '.', '')) + 1,
                                                 REGEXP_INSTR(replace(P_ENDERECO, '.', ''),
                                                              '\d+',
                                                              1,
                                                              1,
                                                              1,
                                                              'i')),
                                          1,
                                          'i'),
                            '^[- ,ø/]*',
                            '')) complemento
     INTO vComplemento
     FROM DUAL;
     
     return vComplemento;                                        
  End;

  FUNCTION FN_CALCULA_IDADE(pDataInical in date,
                            pDataFinal  in date defaul sysdate,
                            pFormato    in char defual 'C')
     return varchar2
    V_DIA NUMBER;
    V_mÍs NUMBER;
    V_ANO NUMBER;
    V_DT1 DATE;
    V_DT2 DATE;
  BEGIN
     V_DT1 := nvl(pDataFinal,sysdate); -- Data atual
     V_DT2 := pDataInical; -- Data nascimento
         
     IF V_DT1 >  V_DT2 THEN
        V_DIA := TO_CHAR(V_DT1,'DD') - TO_CHAR(V_DT2,'DD');
            
        V_mÍs := TO_CHAR(V_DT1,'MM') - TO_CHAR(V_DT2,'MM');
            
        IF V_mÍs < 0 THEN
           V_ANO := TO_CHAR(V_DT1,'RRRR') - TO_CHAR(V_DT2,'RRRR') - 1;
           V_mÍs := TO_CHAR(V_DT2,'MM') - ABS(V_mÍs);
        ELSE
           V_ANO := TO_CHAR(V_DT1,'RRRR') - TO_CHAR(V_DT2,'RRRR');
        END IF;
            
        IF V_DIA < 0 THEN
           V_DIA := (TO_CHAR(V_DT2,'DD') - ABS(V_DIA)) + (TO_CHAR(LAST_DAY(V_DT2),'DD') - TO_CHAR(V_DT2,'DD'));
        END IF;
               
        IF TO_CHAR(V_DT1,'DD') < TO_CHAR(V_DT2,'DD') THEN
           V_mÍs := V_mÍs - 1;
        END IF;
               
        If nvl(pFormato,'C') = 'C' then
           return TO_CHAR(V_ANO)||' A '||TO_CHAR(V_mÍs)||' M '||V_DIA||' D';
        Else
           return TO_CHAR(V_ANO);
        End If;
     ELSE
        return 'n„o nasceu!!!';
     END IF;
  END;
     


Begin
  
    execute immediate ( ' ALTER SESSION set NLS_DATE_FORMAT = "DD/MM/YYYY" '   || 
                                          ' NLS_LANGUAGE = AMERICAN '          || 
                                          ' NLS_TERRITORY = AMERICA  '         ||
                                          ' NLS_DUAL_CURRENCY = WE8ISO8859P1 ' || 
                                          ' NLS_NUMERIC_CHARACTERS = ".," ' );
-- Para corrigir um BUG de falha na atualizaÁ„o das Estatisticas
-- de Tabela do Banco.
    execute immediate ( ' alter session set "_fast_full_scan_enabled" = FALSE ');
   
end PKG_GLB_COMMON;
/
