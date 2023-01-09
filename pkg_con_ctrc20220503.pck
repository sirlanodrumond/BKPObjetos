create or replace package pkg_con_ctrc is
 
/*******************************************************************************************************************************/
/*                                                  TIPOS                                                                      */
/*******************************************************************************************************************************/
TYPE T_CURSOR IS REF CURSOR;  


-- Variavel usada para não ter que ficar desabilitando trigres do CTe
vDeixaTirarImpressao char(1) := 'N';



 
/*******************************************************************************************************************************/
/*                                                CONSTANTES                                                                   */
/*******************************************************************************************************************************/
--Constants utilizadas para retorno de procedure
Status_Normal CONSTANT CHAR(1) := 'N';
Status_Erro   CONSTANT CHAR(1) := 'E';


/*******************************************************************************************************************************/
/*                                       LISTA DE PROCEDURE                                                                    */
/*******************************************************************************************************************************/


-- Responsavel para limpara periodicamente os XXX largados no sistema
PROCEDURE SP_LIMPA_CONHEC_XXX;

--Procedure utilizada para limpar as tabelas de imagem, quando o CTRC for cancelado.                                           
Procedure sp_con_limpaImg( pCTRC    In  tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type,
                           pRota    In  tdvadm.t_glb_rota.glb_rota_codigo%Type,
                           pSerie   In  tdvadm.t_con_conhecimento.con_conhecimento_serie%Type,
                           pStatus  Out Char,
                           pMessage Out Varchar2
                          );



/*******************************************************************************************************************************/
/*                                                 LISTA DE FUNÇÕES                                                            */
/*******************************************************************************************************************************/

-- se a soliticaao ou tabele for do tipo de carga DV esta funcoa retorno o ctrc que originou a carga
Function fn_busca_ctrcoriginaldev(pCTRC In tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type,
                                  pSerie In tdvadm.t_con_conhecimento.con_conhecimento_serie%Type,
                                  pRota  In tdvadm.t_con_conhecimento.glb_rota_codigo%Type) Return Varchar2;


/*******************************************************************************************************************************/
/*               INFORMAÇÕES QUE SÃO CARREGADAS NA ABERTURA DO PROJETO CONSULTA DE CONHECIMENTO                                */
/*******************************************************************************************************************************/
procedure sp_con_InitConsultaConhec(pRota          in tdvadm.t_glb_rota.glb_rota_codigo%type, -- rota passada pelo menu
                                    pUsuarioLocal  in tdvadm.t_usu_usuario.usu_usuario_codigo%type, -- usuário logado no menu
                                    pXmlOut        out clob);


procedure sp_get_CursorRotas(p_RotasAcesso in varchar2,  
                             p_cursor out SYS_REFCURSOR);

procedure sp_get_Localizacao(p_DataEmbarque in varchar2,  
                             p_Placa in varchar2,
                             p_Status out char,
                             p_Message out varchar2, 
                             p_Cursor out SYS_REFCURSOR);


procedure sp_executa_consulta(pXmlIn  in  varchar2,
                              pXmlOut out clob);


  procedure sp_get_ValorMesTransp(pDataInicial in char,
                                  pDataFinal   in char,
                                  pProjetado   in char,
                                  pRetirado    in varchar2,
                                  pRetorno     out T_CURSOR,
                                  pForcaProce  in char);


  /*
     Procedure usado para copiar ou mover conhecimentos
  */
  PROCEDURE SP_CopiaMove_CTe(V_NUMCONHEC_CLONE   IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                              V_SERIECONHEC_CLONE IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                              V_NUMROTA_CLONE     IN T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                              P_NUMCONHEC         IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                              P_SERIECONHEC       IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                              P_NUMROTA           IN T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                              P_TIPO              IN CHAR DEFAULT 'C',
                              P_AUTORIZADO        in char default 'N',
                              P_Status            OUT char,
                              P_Message           OUT varchar2);


  Procedure SP_ValidaCopia(pNumCte  IN  T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                           pSerie   IN  T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                           pRota    IN  T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                           pTipo    IN  char, -- (C)omplemento, (D)evolução
                           pObs     IN  varchar2
--                           ,pStatus  OUT char,
--                           pMessage OUT varchar2
                           );
                           
   PROCEDURE SP_CON_RETIRAIMPRESSAO(P_CON_CONHECIMENTO_CODIGO T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    P_CON_CONHECIMENTO_SERIE  T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    p_GLB_ROTA_CODIGO         T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE);
                           
  

   procedure SP_CON_CANCELACONHECIMENTO(P_CTRC                IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                        P_SERIE               IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                        P_ROTA                IN TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                        P_USUARIO             IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                        P_MOTIVO_CANCELAMENTO IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_CODIGO%TYPE,
                                        P_MOTIVO_DESC         IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_DESC%TYPE,
                                        P_PARAMETROS          IN CHAR DEFAULT 'carreg',
                                        P_STATUS              OUT CHAR,
                                        P_MESSAGEM            OUT VARCHAR2);
  
   
   PROCEDURE SP_CARREG_CONHECCANCELV200(P_CTRC                IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                        P_SERIE               IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                        P_ROTA                IN TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                        P_USUARIO             IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                        P_MOTIVO_CANCELAMENTO IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_CODIGO%TYPE,
                                        P_MOTIVO_DESC         IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_DESC%TYPE,
                                        P_PARAMETROS          IN CHAR DEFAULT 'comcanconh');
  
   PROCEDURE SP_CON_EFETIVACANCELAMENTO;
   
 
   Function fn_ClassificaCte(pCte    tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                             pCteSr  tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                             pCteRt  tdvadm.t_con_conhecimento.glb_rota_codigo%type)
   Return char;
  
end pkg_con_ctrc;

 
/
create or replace package body pkg_con_ctrc is

/********************************************************************************************************************************/
/*                                                LISTA DE PROCEDURE                                                            */
/********************************************************************************************************************************/

function IsNullOrEmpty(pValue varchar2) 
  return boolean
as
  vValue varchar2(2000);
  vNullOrEmpty boolean := False;
begin
  vValue := nvl(pValue, 'null');

  if (trim(vValue) = '') or (trim(vValue) = 'null') then
    vNullOrEmpty := True;
  end if;  
   
  return vNullOrEmpty;
end;

-- Responsavel para limpara periodicamente os XXX largados no sistema

PROCEDURE SP_LIMPA_CONHEC_XXX AS
  vt_conhecimento_codigo varchar2(8); -- codigo de conhecimento para o cursor
  vt_conhecimento_serie  varchar2(4); -- serie do conhecimento para o cursor
  vt_rota_codigo         char(3); -- rota do conhecimento para o cursor
  vContador   integer;
  vErro        varchar2(1000);
  NODEDLOCK       EXCEPTION;
  -- cursor para pegar os conhecimetos SERIE XXX NAO RECUPERADOS

-- A PEDIDO DO MOREIRA EM 08/10/2010
-- FOI COLOCADO A EXCLUSÃO PARA 15 DIAS 
-- TESTEMUNHAS KLAYTON/ SIRLANO / ROGERIO
  CURSOR c_CONHEC IS
    select A.con_conhecimento_codigo,
           A.con_conhecimento_serie,
           A.glb_rota_codigo
      from t_con_conhecimento A
     where 
       (A.con_conhecimento_serie = 'XXX'
       AND A.CON_FATURA_CODIGO IS NULL
--       AND A.GLB_ROTA_CODIGO not IN ('031', '033', '083')
--       and nvl(A.CON_CONHECIMENTO_DTEMISSAO,'01/01/1900') < TO_DATE(SYSDATE - 10, 'DD/MM/YYYY')
       AND A.ARM_CARREGAMENTO_CODIGO IS NULL
       )
       or 
       (A.con_conhecimento_serie = 'XXX'
--       AND A.CON_FATURA_CODIGO IS NULL
       AND A.ARM_CARREGAMENTO_CODIGO IS NOT NULL
--       AND A.GLB_ROTA_CODIGO = '020'
       and nvl(A.CON_CONHECIMENTO_DTEMISSAO,'01/01/1900') < TO_DATE(SYSDATE - 10, 'DD/MM/YYYY')
       )
       order by 1;

BEGIN
  vContador := 0;
  BEGIN
  who_called_me2;
  open c_conhec;
  LOOP
    FETCH c_CONHEC
      INTO vt_conhecimento_codigo, vt_conhecimento_serie, vt_rota_codigo;
    EXIT WHEN c_CONHEC%notfound;
    -----------------------------------------------------------------------------------------------
    Begin
      delete T_CON_VEICCONHEC    
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;

      delete T_CON_CTEENVIO
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;


      delete t_con_consigredespacho
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      delete t_con_nftransportaextra
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      delete t_con_nftransporta
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      delete t_con_calcconhecimento
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      delete t_con_conhecvped
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      delete t_con_conheccomplemento
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      delete t_con_conhecautorizador
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      delete t_con_conhecctb
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;

      delete t_Arm_Notacte
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;

      UPDATE T_ARM_NOTA
         SET CON_CONHECIMENTO_CODIGO = NULL,
             CON_CONHECIMENTO_SERIE  = NULL,
             GLB_ROTA_CODIGO         = NULL
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
    
      UPDATE T_CON_LOGGERACAO
         SET CON_CONHECIMENTO_CODIGO = NULL,
             CON_CONHECIMENTO_SERIE  = NULL,
             GLB_ROTA_CODIGO         = NULL
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
    
      delete t_con_vfreteconhec
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
    
      delete t_con_nffaturada 
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigoconhec = vt_rota_codigo;

      delete t_con_conhecfaturado
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigoconhec = vt_rota_codigo;
      
      delete wservice.t_wsd_xmlnfse
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      
      delete tdvadm.t_con_conhecimentoregesp
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      
      delete tdvadm.t_con_conheccfop
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;
      
      delete t_con_conhecimento
       where con_conhecimento_codigo = vt_conhecimento_codigo
         and con_conhecimento_serie = vt_conhecimento_serie
         and glb_rota_codigo = vt_rota_codigo;

      vContador := vContador + 1;      
      COMMIT;
      if vt_conhecimento_codigo = '745562' Then
        vErro := vErro;
      End If;
      If mod(vContador,100) = 0 then
         dbms_lock.sleep(15);
      End If;
    EXCEPTION
      WHEN OTHERS THEN
        vErro := SQLCODE || ' - ' || sqlerrm;
        rollback;
         IF SQLCODE = 00060 THEN
             RAISE NODEDLOCK;
         END IF;
    end;
  END LOOP;
     wservice.pkg_glb_email.SP_ENVIAEMAIL('LIMPEZA CTe NFSe Serie XXX',
                                          ' Total de documentos excluidos - ' || to_char(vContador) || chr(13),
                                          'aut-e@dellavolpe.com.br',
                                          'ksouza@dellavolpe.com.br');
                                                
  EXCEPTION
    WHEN NODEDLOCK THEN
        vErro := ' Erro durante o Processamento documentos excluidos - ' || to_char(vContador) || chr(13) || 
                 ' Erro no documento ' || vt_conhecimento_codigo ||'-'||vt_conhecimento_serie || '-' || vt_rota_codigo || chr(13) ||
                 ' Erro -> ' || sqlerrm || chr(13);
        wservice.pkg_glb_email.SP_ENVIAEMAIL('LIMPEZA CTe NFSe Serie XXX',
                                             vErro,
                                             'aut-e@dellavolpe.com.br',
                                             'sdrumond@dellavolpe.com.br;ksouza@dellavolpe.com.br');
                                                
    END;
  commit;

END SP_LIMPA_CONHEC_XXX;



---------------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para limpar as tabelas de imagem, quando o CTRC for cancelado.                                           --
---------------------------------------------------------------------------------------------------------------------------------  
Procedure sp_con_limpaImg( pCTRC    In  tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type,
                           pRota    In  tdvadm.t_glb_rota.glb_rota_codigo%Type,
                           pSerie   In  tdvadm.t_con_conhecimento.con_conhecimento_serie%Type,
                           pStatus  Out Char,
                           pMessage Out Varchar2
                          ) As
--variável de controle
 vCount Integer := 0;
 vRotaColeta  Char(1) := '';

Begin
  Begin
    --Primeiro verifico se o conhecimento já possui imagem arquivada
    Select 
       Count(*)
    Into 
       vCount
    From 
      tdvadm.t_glb_compimagem    img
    Where 
       0 = 0
      And img.glb_grupoimagem_codigo = '04'   -- Imagem de conhecimento
      And img.glb_tpimagem_codigo    = '0001' -- Para imagens do Grupo 04, o tipo '0001' quer dizer "Frente"
      And img.con_conhecimento_codigo = pCtrc
      And img.con_conhecimento_serie = pSerie
      And img.glb_rota_codigo = pRota;
      
  Exception
    --Caso ocorra algum erro na busca mostro na tela o erro.
    When Others Then
      pStatus := Status_Erro;
      pMessage := 'Erro ao tentar localizar imagen de notas.'|| chr(13)|| Sqlerrm;
      Return;
  End;          
  
  --Caso encontre algum registro excluo o registro da tabela.
  If vCount > 0 Then
    Begin
      --Excluo o registro encontrado. 
      Delete From tdvadm.t_glb_compimagem img
      Where 
          img.glb_grupoimagem_codigo  = '04'   -- Imagem de conhecimento
      And img.glb_tpimagem_codigo     = '0001' -- Para imagens do Grupo 04, o tipo '0001' quer dizer "Frente"
      And img.con_conhecimento_codigo = pCtrc
      And img.con_conhecimento_serie  = pSerie
      And img.glb_rota_codigo         = pRota;
      Commit;
    
     Exception
       When Others Then
         pStatus := Status_Erro;
         pMessage := 'Erro ao excluir registro de imagem.'||chr(13)||Sqlerrm;
    End;
  End If;
  
  Begin
    --Verifico se existe registro na tabela de controle de criação de imagem
    Select Count(*) Into vCount 
    From tdvadm.t_uti_ctepdf   pdf
    Where 
          pdf.uti_ctepdf_codigo = pCTRC   --CTRC Numero
      And pdf.uti_ctepdf_serie  = pSerie --CTRC Serie
      And pdf.glb_rota_codigo   = pRota;  --Rota CTRC
    
  Exception
    When Others Then
      pStatus := Status_erro;
      pMessage := 'Erro ao tentar localizar imagem do CTRC' ||chr(13)||Sqlerrm;
      Return;
  End;
  
  --Caso tenhamos algum registro na tabela de controle.
  If (vCount > 0) Then 
    Begin
      --Pego o valor do campo "Rota de Coleta"
      Select 
        ROTA.GLB_ROTA_COLETA 
      Into 
        vRotaColeta
      From 
         t_glb_rota  rota
      Where 
         rota.glb_rota_codigo = pRota;
       
      --Verifico se a rota é de coleta, para excluir o registro para gerar o pdf novamente.
      If  (vRotaColeta = 'S')  Then
        Delete tdvadm.t_uti_ctepdf pdf
        Where 
            pdf.uti_ctepdf_codigo = pCTRC   --CTRC Numero
        And pdf.uti_ctepdf_serie  = pSerie --CTRC Serie
        And pdf.glb_rota_codigo   = pRota;  --Rota CTRC
      End If;
    
    --caso ocorra algum erro devolve o código de erro, e uma mensagem de erro.
    Exception
      When Others Then
        pStatus := Status_erro;
        pMessage := 'Erro ao tentar limpar tabela de controle de criação de imagens.'||chr(13)||Sqlerrm;
        Return;
    End;
  End If;
  
  pStatus := status_normal;
  pMessage := '';
  
  
End  sp_con_limpaImg;                         

Function fn_busca_ctrcoriginaldev(pCTRC In tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type,
                                  pSerie In tdvadm.t_con_conhecimento.con_conhecimento_serie%Type,
                                  pRota  In tdvadm.t_con_conhecimento.glb_rota_codigo%Type)
   Return Varchar2 Is
   vCtrcRetorno Varchar2(2000);

   Cursor cCursor Is 
   Select c.con_conhecimento_codigo ctrcret,
          c.con_conhecimento_serie  serieret,
          c.glb_rota_codigo         rtret,
          '      ' ctrcor,
          '  ' serieor,
          '   ' rtor,
          c.con_conhecimento_dtgravacao gravacao,
          trim(c.slf_solfrete_codigo) || trim(c.slf_tabela_codigo) tabsolcod,  
          trim(c.slf_solfrete_saque)  || trim(c.slf_tabela_saque) tabsolsq,
          decode(NVL(c.slf_solfrete_codigo,'T'),'T','T','S') TIPO,
          nf.con_nftransportada_numnfiscal nota,
          nf.glb_cliente_cgccpfcodigo cnpj,
          '  ' tpcarga
   From t_con_conhecimento c,
        t_con_nftransporta nf
   Where 0 = 0
     And c.con_conhecimento_codigo = pCTRC
     And c.con_conhecimento_serie  = pSerie
     And c.glb_rota_codigo         = pRota
     And c.con_conhecimento_codigo = nf.con_conhecimento_codigo
     And c.con_conhecimento_serie  = nf.con_conhecimento_serie
     And c.glb_rota_codigo         = nf.glb_rota_codigo;

   vTpCursor cCursor%Rowtype;     

Begin
   
   vCtrcRetorno := '';
   Open cCursor;
   loop
      fetch cCursor
        into vTpCursor;
      exit when cCursor%notfound;

      If vTpCursor.TIPO = 'S' Then
         Select sf.glb_tpcarga_codigo
            Into vTpCursor.tpcarga
         From t_slf_solfrete sf 
         Where sf.slf_solfrete_codigo = vTpCursor.Tabsolcod
           And sf.slf_solfrete_saque  = vTpCursor.Tabsolsq;
      Else
         Select sf.glb_tpcarga_codigo
            Into vTpCursor.tpcarga
         From t_slf_tabela sf 
         Where sf.slf_tabela_codigo = vTpCursor.Tabsolcod
           And sf.slf_tabela_saque  = vTpCursor.Tabsolsq;
      End If;
      
      If vTpCursor.tpcarga = 'DV' Then
        
        Begin
          Select c.con_conhecimento_codigo,
                 c.con_conhecimento_serie,
                 c.glb_rota_codigo
            Into vTpCursor.Ctrcor,
                 vTpCursor.Serieor,
                 vTpCursor.Rtor
          From t_con_conhecimento c,
               t_con_nftransporta nf
          Where 0 = 0
            And nf.con_nftransportada_numnfiscal = vTpCursor.Nota
            And nf.glb_cliente_cgccpfcodigo      = vTpCursor.Cnpj
            And c.con_conhecimento_codigo <> vTpCursor.Ctrcret
            And c.glb_rota_codigo         <> vTpCursor.Rtret
            And c.con_conhecimento_dtgravacao = (Select Max(c1.con_conhecimento_dtgravacao)
                                                 From t_con_conhecimento c1,
                                                      t_con_nftransporta nf1
                                                 Where 0 = 0
                                                   And nf1.con_nftransportada_numnfiscal = nf.con_nftransportada_numnfiscal
                                                   And nf1.glb_cliente_cgccpfcodigo      = nf.glb_cliente_cgccpfcodigo
                                                   And c1.con_conhecimento_codigo = nf1.con_conhecimento_codigo
                                                   And c1.con_conhecimento_serie  = nf1.con_conhecimento_serie
                                                   And c1.glb_rota_codigo         = nf1.glb_rota_codigo
                                                   And c1.con_conhecimento_codigo <> vTpCursor.Ctrcret
                                                   And c1.glb_rota_codigo         <> vTpCursor.Rtret
                                                   And c1.con_conhecimento_dtgravacao <= vTpCursor.gravacao)
            And c.con_conhecimento_codigo = nf.con_conhecimento_codigo
            And c.con_conhecimento_serie  = nf.con_conhecimento_serie
            And c.glb_rota_codigo         = nf.glb_rota_codigo;
        exception      
          When NO_DATA_FOUND Then
            vTpCursor.Ctrcor := 'NLOC';
            vTpCursor.Serieor := Null;
            vTpCursor.Rtor := Null;
          When TOO_MANY_ROWS  Then            
            vTpCursor.Ctrcor := pCTRC;
            vTpCursor.Serieor := '2';
            vTpCursor.Rtor := pRota;
          End;  
         
        If ( instr(vCtrcRetorno,trim( 'NF' || vTpCursor.Nota || '-' ||   'CT' || vTpCursor.Ctrcor || vTpCursor.Serieor || vTpCursor.Rtor || '-')) = 0 )  Or  
          ( vCtrcRetorno Is Null )
          Then
           vCtrcRetorno := Trim('NF' || vTpCursor.Nota || '-' ||   'CT' || vTpCursor.Ctrcor || vTpCursor.Serieor || vTpCursor.Rtor || '-');   
        End If;   
      
      End If;
 
   End Loop; 
           
   Close cCursor;

   Return vCtrcRetorno;


  
End;   

/*******************************************************************************************************************************/
/*               INFORMAÇÕES QUE SÃO CARREGADAS NA ABERTURA DO PROJETO CONSULTA DE CONHECIMENTO                                */
/*******************************************************************************************************************************/
procedure sp_con_InitConsultaConhec(pRota          in tdvadm.t_glb_rota.glb_rota_codigo%type, -- rota passada pelo menu
                                    pUsuarioLocal  in tdvadm.t_usu_usuario.usu_usuario_codigo%type, -- usuário logado no menu
                                    pXmlOut        out clob)
is
  vCursorRota   SYS_REFCURSOR;
  vRotaGenerica tdvadm.t_glb_rota.glb_rota_codgenerico%type;
  vRotaAcesso   varchar2(2000);
  vStatus       char(1);
  vMessage      varchar2(2000);
  vAutRetImp    char(1);
  vRotasPesq    tdvadm.t_usu_perfil.usu_perfil_parat%type;
  vXmlPadrao    XmlType;
  vXmlout       XmlType;  
  vXmlPronto    XmlType;
  plistaparams glbadm.pkg_listas.tlistausuparametros;

begin

  /********************************************************************/
  /* Inicializo as variaveis como normal, caso ocorra erro sobreponho
  /********************************************************************/
  vStatus  := 'N';
  vMessage := 'Processamento Normal'; 

  if Not glbadm.pkg_listas.fn_get_usuparamtros('comconconh',
                                               pUsuarioLocal,
                                               pRota,
                                               plistaparams) Then
                                    
     vStatus  := 'E';
     vMessage := 'Erro ao Buscar Parametros'; 
  End if ;                                 

  begin
     vAutRetImp := plistaparams('RETIRAIMPRESSAO').texto;
  exception
    When NO_DATA_FOUND Then
      vAutRetImp := 'N';
    end;   

  begin
     vRotasPesq := trim(plistaparams('ROTASCONSULTA').texto);
  exception
    When NO_DATA_FOUND Then
      vRotasPesq := 'PROPRIA';
    end;   
  
--   RAISE_APPLICATION_ERROR(-20111,'Parametros ' || pUsuarioLocal ||',' || pRota || ',' || plistaparams('ROTASCONSULTA').texto);


  begin
    /********************************************************************/
    /* Obtenho a Rota genérica                                          */
    /********************************************************************/
    begin
      Select GLB_ROTA_CODGENERICO 
        into vRotaGenerica
        from t_glb_rota
       where trim(glb_rota_codigo) = trim(pRota); 
    exception when others then
      raise_application_error(-20001, 'Erro ao obter Rota Generica, '||chr(13)||sqlerrm);        
    end;
    --dbms_output.put_line('vRotaGenerica = '||vRotaGenerica);
    
    
    /********************************************************************/
    /* Busca todas as rotas cuja rota genérica seja a encontrada acima. */
    /********************************************************************/
    vRotaAcesso := '';
    -- Sempre ele Tera a propria Rota
    begin
      for item in( Select glb_rota_codigo 
                    from t_glb_rota
                   where trim(GLB_ROTA_CODGENERICO) = trim(vRotaGenerica))
      loop
        vRotaAcesso := vRotaAcesso || '''' || item.glb_rota_codigo || '''' || ',';  
      end loop;      
    exception when others then
      raise_application_error(-20001, 'Erro ao obter Rotas de Acesso, '||chr(13)||sqlerrm);   
    end;    

    If trim(vRotasPesq) = 'TODAS' Then
        begin
          for item in( select glb_rota_codigo
                        from t_glb_rota r
                        WHERE NVL(R.GLB_ROTA_EMITEDOC,'CAD') <> 'CAD')
--                       where r.glb_rota_cte = 'S' or r.glb_rota_nfe = 'S')
          loop
            vRotaAcesso := vRotaAcesso || '''' || item.glb_rota_codigo || '''' || ',';  
          end loop;      
        exception when others then
          raise_application_error(-20001, 'Erro ao obter Rotas de Acesso, '||chr(13)||sqlerrm);   
        end;    

    ElsIf ( vRotasPesq is not null ) and (vRotasPesq <> 'PROPRIA' ) Then
       vRotaAcesso := vRotaAcesso || replace(replace(vRotasPesq,' ',','),';',',') || ',';
    End if;
    
    --vRotaAcesso := '('|| substr(vRotaAcesso, 1, Length(vRotaAcesso)-1) ||')';       

    sp_get_CursorRotas(vRotaAcesso, vCursorRota);
    --dbms_output.put_line('vRotaAcesso = '||vRotaAcesso);
    
    -- Criando Xml padrão
    vXmlPadrao := pkg_glb_xml.fn_getXmlPadrao;     
  
    -- Criando Xml tabela Rotas
    pkg_glb_xml.sp_getxmltable('ROTAS', vCursorRota, vXmlOut, vStatus, vMessage);
        
   
    -- Criando Xml completo 
    pkg_glb_xml.Sp_SetXmlPadraoAddParam(vXmlPadrao, 'AutRetImp', vAutRetImp, vXmlPadrao, vStatus, vMessage);  
    pkg_glb_xml.Sp_SetXmlPadraoAddParam(vXmlPadrao, 'Status', vStatus, vXmlPadrao, vStatus, vMessage);
    pkg_glb_xml.Sp_SetXmlPadraoAddParam(vXmlPadrao, 'Message', vMessage, vXmlPadrao, vStatus, vMessage);
        
    pkg_glb_xml.Sp_SetXmlPadraoTable(vXmlPadrao, vXmlOut,'ROTAS', vXmlPronto, vStatus, vMessage);
    pXmlOut := vXmlPronto.GETCLOBVAL();     
    pXmlOut := Replace(pXmlOut, 'Outputs', 'OutPut');  
    --pXmlOut := Replace(pXmlOut, 'Rowset', 'ROWSET');
    pXmlOut := tdvadm.fn_limpa_campoxml(pXmlOut);
    
  exception when others then  
    vStatus  := 'E';
    vMessage := 'Erro ao tentar gerar dados iniciais para a consulta de conhecimento, '||chr(13)||sqlerrm;
    pXmlOut  := tdvadm.fn_limpa_campoxml('<Parametros><OutPut><Status>'||vStatus||'<Status><Message>'||vMessage||'</Message></OutPut></Parametros>');
  end;
  
  --dbms_output.put_line('vRotaGenerica: '||vRotaGenerica);
  --dbms_output.put_line('vRotaAcesso: '||vRotaAcesso);  
 
end sp_con_InitConsultaConhec;                                    


procedure sp_get_CursorRotas(p_RotasAcesso in varchar2,  
                             p_cursor out SYS_REFCURSOR)
as
begin
    /********************************************************************/
    /* Gerando cursor de rotas filtrado pelas rotas de acesso           */
    /********************************************************************/
    begin    
      open p_cursor for
      SELECT GLB_ROTA_CODIGO, 
             GLB_ROTA_DESCRICAO,
             GLB_ROTA_PREFIXO, 
             GLB_ROTA_CODIGO|| ' - ' ||
             SUBSTR(GLB_ROTA_PREFIXO,1,3)|| ' - ' ||
             GLB_ROTA_DESCRICAO CODIGO, GLB_ROTA_DESCRICAO|| ' - ' ||GLB_ROTA_CODIGO|| ' - ' ||
             SUBSTR(GLB_ROTA_PREFIXO,1,3) DESCRICAO, 
             SUBSTR(GLB_ROTA_PREFIXO,1,3)|| ' - ' ||GLB_ROTA_CODIGO|| ' - '||GLB_ROTA_DESCRICAO PREFIXO
        FROM T_GLB_ROTA R
       where 0=0
         and instr(p_RotasAcesso,GLB_ROTA_CODIGO) > 0
         --and GLB_ROTA_CODIGO in case when (p_RotaMenu != '020') and 
         --                                 (p_RotaMenu != '010') and 
         --                                 (p_RotaMenu != '015') then '('||p_RotasAcesso||')'
         --                            else p_RotaMenu
         --                       end     
       ORDER BY GLB_ROTA_CODIGO;
    exception when others then
      raise_application_error(-20001, 'Erro ao gerar cursor de rotas, '||chr(13)||sqlerrm);
    end;   
              
end;

procedure sp_get_Localizacao(p_DataEmbarque in varchar2,  
                             p_Placa in varchar2,
                             p_Status out char,
                             p_Message out varchar2, 
                             p_Cursor out SYS_REFCURSOR)
is
  vLocalizou integer;
  vEmbarque  date;
  vConjunto  varchar2(20);   
begin
  begin
    
    --insert into dropme(a,x) values('localização', 'p_DataEmbarque: '||p_DataEmbarque||' - '||'p_Placa: '||p_Placa);  commit;
  
    vEmbarque := to_date(substr(p_DataEmbarque,1,10), 'DD/MM/YYYY');
    vConjunto := SUBSTR(NVL(TDVADM.FN_RETCONJUNTO(p_Placa),p_Placa),1,7);
  
    open p_Cursor for
    select *
    from (select ATR_DTPOSICAO as DATA,
           TO_CHAR(ATR_DTPOSICAO,'DD/MM/YYYY HH:MI:SS') AS ATR_DTPOSICAO,
           ATR_MCT,
           ATR_MACRONUM,
           ATR_LANDMARK,
           trim(f_extrai(2,ATR_MSG,'_')) AS MSG,
           ATR_STATUS
      FROM V_ATR_POSICAOVEICULO V
     WHERE 0=0
       AND TRUNC(ATR_DTPOSICAO) >= trunc(vEmbarque)
       AND SUBSTR(F_RETORNAANTENA( TRIM(p_Placa) ),1,9) != '111111111'
       --and v.CONJUNTO = vConjunto
     order by 1 desc)
     where RowNum = 1; 

    select count(*) 
      into vLocalizou
      FROM V_ATR_POSICAOVEICULO V
     WHERE 0=0
       AND TRUNC(ATR_DTPOSICAO) >= trunc(vEmbarque)
       --AND SUBSTR(F_RETORNAANTENA( TRIM(p_Placa) ),1,9) != '111111111';
       and v.CONJUNTO = vConjunto;  
       
    if vLocalizou = 0 then
      p_Status  := 'W';
      p_Message := 'Veiculo sem AUTOTRAC';
      return;
    end if;

    p_Status  := 'N';
    p_Message := 'Localização obtida com sucesso!'; 
  exception when others then
    p_Status  := 'E';
    p_Message := 'Erro eo tentar obter localização para a placa: '||p_Placa||', '||chr(13)||sqlerrm;
  end;                             
end sp_get_Localizacao;                             
 
procedure sp_executa_consulta( pXmlIn  in  varchar2,
                               pXmlOut out clob)
as
  EmptyStr           varchar2(1) := '';
  vStatus            char(1);
  vMessage           varchar2(2000);
  vSQL               Clob;
  vNUM_NF            T_CON_NFTRANSPORTA.CON_NFTRANSPORTADA_NUMNFISCAL%type;
  vNUM_Cliente       T_CON_NFTRANSPORTA.CON_NFTRANSPORTADA_NUMERO%type;
  vNum_NFe           T_CON_CONHECRPSNFE.CON_CONHECRPSNFE_NFECODIGO%type;
  vMonitorado        Boolean := False;
  vOPCAO_REM         T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE := ' VALE';
  vOPCAO_CGC_REM     T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  vListaRemetente    varchar2(2000) := '(''02337456000177'')';
  vOPCAO_DEST        T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE := 'FLORESTAL VALE DO JEQUINHONHA LTDA';
  vOPCAO_CGC_DEST    T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  vListaDestinatario varchar2(2000) := '(''01972970000111'')';
begin
  begin
    vSQL := '';
    vSQL := vSQL||'SELECT DISTINCT C.CON_CONHECIMENTO_CODIGO, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_SERIE, ';
    vSQL := vSQL||'       C.GLB_ROTA_CODIGO, ';
    vSQL := vSQL||'       C.GLB_CLIENTE_CGCCPFREMETENTE, ';
    vSQL := vSQL||'       C.GLB_CLIENTE_CGCCPFDESTINATARIO, ';
    vSQL := vSQL||'       C.GLB_CLIENTE_CGCCPFSACADO, ';
    vSQL := vSQL||'       C.GLB_TPCLIEND_CODIGOREMETENTE, ';
    vSQL := vSQL||'       C.GLB_TPCLIEND_CODIGODESTINATARI, ';
    vSQL := vSQL||'       pkg_con_cte.fn_cte_emailenviado(c.con_conhecimento_codigo,c.con_conhecimento_serie,c.glb_rota_codigo) Email_CTE, ';
    vSQL := vSQL||'       C.GLB_MERCADORIA_CODIGO ||''-''||MERC.GLB_MERCADORIA_DESCRICAO MERC, ';
    vSQL := vSQL||'       C.GLB_EMBALAGEM_CODIGO  ||''-''||EMB.GLB_EMBALAGEM_DESCRICAO  EMB, ';
    vSQL := vSQL||'       LOC1.GLB_LOCALIDADE_DESCRICAO||''-''||LOC1.GLB_ESTADO_CODIGO ||''-''|| C.CON_CONHECIMENTO_LOCALCOLETA ORIGEM, ';
    vSQL := vSQL||'       LOC2.GLB_LOCALIDADE_DESCRICAO||''-''||LOC2.GLB_ESTADO_CODIGO ||''-''|| C.CON_CONHECIMENTO_LOCALENTREGA DESTINO, ';
    vSQL := vSQL||'       C.GLB_LOCALIDADE_CODIGODESTINO, ';
    vSQL := vSQL||'       C.GLB_LOCALIDADE_CODIGOORIGEM, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_LOCALCOLETA, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_LOCALENTREGA, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_DTEMISSAO, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_DTEMBARQUE, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_DTGRAVACAO, ';
    vSQL := vSQL||'       C.CON_VIAGEM_NUMERO, ';
    vSQL := vSQL||'       C.GLB_ROTA_CODIGOVIAGEM , ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_EMISSOR, ';
    vSQL := vSQL||'       C.SLF_SOLFRETE_CODIGO, ';
    vSQL := vSQL||'       C.SLF_SOLFRETE_SAQUE, ';
    vSQL := vSQL||'       C.SLF_TABELA_CODIGO, ';
    vSQL := vSQL||'       C.SLF_TABELA_SAQUE, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_OBS, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_FLAGCANCELADO , ';
    vSQL := vSQL||'       C.PRG_PROGCARGA_CODIGO, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_HORASAIDA, ';
    vSQL := vSQL||'       C.CON_FATURA_CODIGO, ';
    vSQL := vSQL||'       C.CON_FATURA_CICLO, ';
    vSQL := vSQL||'       C.GLB_ROTA_CODIGOFILIALIMP, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_PLACA, ';
    vSQL := vSQL||'       PSCOBRAD.CON_CALCVIAGEM_VALOR PESO, ';
    vSQL := vSQL||'       TTPV.CON_CALCVIAGEM_VALOR TOTALCONHEC, ';
    vSQL := vSQL||'       CTCR.CON_CALCVIAGEM_VALOR CCARRET, ';
    vSQL := vSQL||'       CTCR.CON_CALCVIAGEM_DESINENCIA TIPOCCARRET, ';
    vSQL := vSQL||'       NF.CON_NFTRANSPORTADA_NUMERO, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_ENTREGA, ';
    vSQL := vSQL||'       C.CON_CONHECIMENTO_ATRAZO, ';
    vSQL := vSQL||'       C.CON_VALEFRETE_CODIGO, ';
    vSQL := vSQL||'       C.CON_VALEFRETE_SERIE , ';
    vSQL := vSQL||'       C.GLB_ROTA_CODIGOVALEFRETE, ';
    vSQL := vSQL||'       C.CON_VALEFRETE_SAQUE, ';
    vSQL := vSQL||'       NFe.Con_Conhecrpsnfe_Nfecodigo, ';
    vSQL := vSQL||'       C.ARM_CARREGAMENTO_CODIGO, ';
    vSQL := vSQL||'       DECODE(C.CON_CONHECIMENTO_DIGITADO,''I'',''IMPRESSO'',''D'',''DIGITADO'',''N'',''INUTILIZADO'',''DIGITADO'') IMPRESSO ';
    vSQL := vSQL||'FROM   T_CON_CONHECIMENTO C, ';
    vSQL := vSQL||'       T_GLB_EMBALAGEM EMB, ';
    vSQL := vSQL||'       T_GLB_MERCADORIA MERC, ';
    vSQL := vSQL||'       T_GLB_LOCALIDADE LOC1, ';
    vSQL := vSQL||'       T_GLB_LOCALIDADE LOC2, ';
    vSQL := vSQL||'       V_CON_I_PSCOBRAD PSCOBRAD, ';
    vSQL := vSQL||'       V_CON_I_CTCR CTCR, ';
    vSQL := vSQL||'       V_CON_I_TTPV TTPV, ';
    vSQL := vSQL||'       T_GLB_ROTA D, ';
    vSQL := vSQL||'       T_CON_NFTRANSPORTA NF, ';
    vSQL := vSQL||'       T_CON_CONHECRPSNFE NFe ';
    vSQL := vSQL||'WHERE  C.GLB_EMBALAGEM_CODIGO            = EMB.GLB_EMBALAGEM_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.GLB_MERCADORIA_CODIGO           = MERC.GLB_MERCADORIA_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_LOCALCOLETA    = LOC1.GLB_LOCALIDADE_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_LOCALENTREGA   = LOC2.GLB_LOCALIDADE_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_CODIGO         = PSCOBRAD.CON_CONHECIMENTO_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_SERIE          = PSCOBRAD.CON_CONHECIMENTO_SERIE(+) '; 
    vSQL := vSQL||'  AND  C.GLB_ROTA_CODIGO                 = PSCOBRAD.GLB_ROTA_CODIGO(+) ';   
    vSQL := vSQL||'  AND  C.GLB_ROTA_CODIGO                 = D.GLB_ROTA_CODIGO(+) ';                        
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_CODIGO         = CTCR.CON_CONHECIMENTO_CODIGO(+) ';  
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_SERIE          = CTCR.CON_CONHECIMENTO_SERIE(+) ';
    vSQL := vSQL||'  AND  C.GLB_ROTA_CODIGO                 = CTCR.GLB_ROTA_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_CODIGO         = TTPV.CON_CONHECIMENTO_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_SERIE          = TTPV.CON_CONHECIMENTO_SERIE(+) ';  
    vSQL := vSQL||'  AND  C.GLB_ROTA_CODIGO                 = TTPV.GLB_ROTA_CODIGO(+) ';  
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_SERIE          <> ''XXX''';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_CODIGO         = NF.CON_CONHECIMENTO_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_SERIE          = NF.CON_CONHECIMENTO_SERIE(+) ';
    vSQL := vSQL||'  AND  C.GLB_ROTA_CODIGO                 = NF.GLB_ROTA_CODIGO(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_CODIGO         = NFe.Con_Conhecimento_Codigo(+) ';
    vSQL := vSQL||'  AND  C.CON_CONHECIMENTO_SERIE          = NFe.Con_Conhecimento_Serie(+) '; 
    vSQL := vSQL||'  AND  C.GLB_ROTA_CODIGO                 = NFe.Glb_Rota_Codigo(+) ';  

    /****************************************************************************************************
    *** Se o usuário digitou um numero de [Nota] para consulta
    ****************************************************************************************************/
    If not IsNullOrEmpty(vNUM_NF)then
      vSQL := vSQL||'  AND  LPAD(NF.CON_NFTRANSPORTADA_NUMNFISCAL,9,''0'') = '''||TRIM(vNUM_NF)||'''';
    end if;

    /****************************************************************************************************
    *** Se o usuário digitou um numero de [Cliente] para consulta
    ****************************************************************************************************/
    if not IsNullOrEmpty(vNUM_Cliente) then
      vSQL := vSQL||'  AND  NF.CON_NFTRANSPORTADA_NUMERO = '||TRIM(vNUM_Cliente);
    end if;

    /****************************************************************************************************
    *** Se o usuário digitou um numero de [NFe] para consulta
    ****************************************************************************************************/
    if not IsNullOrEmpty(vNum_NFe) then
      vSQL := vSQL||'  AND  NFe.Con_Conhecrpsnfe_Nfecodigo = '''||TRIM(vNum_NFe)||'''';
    end if;

    /****************************************************************************************************
    *** Se o usuário selecionou o checkbox Monitorado para consulta
    ****************************************************************************************************/
    if vMonitorado Then
      vSQL := vSQL||'  AND  SUBSTR(F_RETORNAANTENA(C.CON_CONHECIMENTO_PLACA, C.CON_CONHECIMENTO_DTEMBARQUE, ''''S'''||'),1,9) != ''''111111111''';
     end if;

    If not IsNullOrEmpty(vOPCAO_REM) then
      If IsNullOrEmpty(vOPCAO_CGC_REM) THEN
        vSQL := vSQL||'  AND  C.GLB_CLIENTE_CGCCPFREMETENTE IN '||vListaRemetente;
      else
        vSQL := vSQL||'  AND  C.GLB_CLIENTE_CGCCPFREMETENTE = '''||vOPCAO_CGC_REM||'''';
      end if;
    end if;
    
    If not IsNullOrEmpty(vOPCAO_DEST) then
      If IsNullOrEmpty(vOPCAO_CGC_DEST) THEN
        vSQL := vSQL||'  AND  C.GLB_CLIENTE_CGCCPFDESTINATARIO IN '||vListaDestinatario;
      else
        vSQL := vSQL||'  AND  C.GLB_CLIENTE_CGCCPFDESTINATARIO = '''||vOPCAO_CGC_DEST||'''';
      end if;
    end if;
    
    /**
          If Trim(L_OPCAO_SAC.Caption) <>  '' then
          Begin
               If Trim(L_OPCAO_CGC_SAC.Caption) = '' THEN
                  Sql.Add('AND C.GLB_CLIENTE_CGCCPFSACADO IN '+ Frm_ConsultaCliente.ListaSacado )
               else
                   Sql.Add('AND C.GLB_CLIENTE_CGCCPFSACADO = ''' + L_OPCAO_CGC_SAC.Caption + '''');
          end;

          If (DE_DATA_INICIAL.Text <> '  /  /    ') and (DE_DATA_FINAL.Text <>  '  /  /    ') then
             Sql.Add('AND C.CON_CONHECIMENTO_DTEMBARQUE BETWEEN '+'to_Date('+''''+DE_DATA_INICIAL.Text+''''+','+''''+'dd/mm/yyyy'+''''+')'+ ' AND '+'to_Date('+''''+DE_DATA_FINAL.Text+''''+','+''''+'dd/mm/yyyy'+''''+')');

          if RxDBLookupCombo_ROTA.Value <> '' then
             Sql.Add('AND C.GLB_ROTA_CODIGO = '''+RxDBLookupCombo_ROTA.Value+'''');

          if RxDBLookupCombo_ROTA.Value <> EmptyStr then // se selecionou uma rota
            Sql.Add('AND C.GLB_ROTA_CODIGO = '+ QuotedStr( RxDBLookupCombo_ROTA.Value ) )
          else if (RxDBLookupCombo_ROTA.Value = EmptyStr) and ((rota <> '020') and (rota <> '010') and (rota <> '015'))  then
             Sql.Add('AND C.GLB_ROTA_CODIGO IN '+V_Rota_Acesso_consulta);

          // inseri agora

          if RxDBLC_Prefixo.Text <> '' then
             Sql.Add('AND D.GLB_ROTA_PREFIXO = ''' + Dtm_Cons_Data.Q_ROTAGLB_ROTA_PREFIXO.Value + '''');

          // ate aqui 27/09/2000 Catarina

          if Trim(E_Conhecimento.Text) <> '' then
          begin
             Sql.Add('AND C.CON_CONHECIMENTO_CODIGO >= '''+E_Conhecimento.Text+'''');
             Sql.Add('AND C.CON_CONHECIMENTO_CODIGO <= '''+E_Conhecimento_F.Text+'''');
          end;

          if Trim(E_SERIE.text)<> '' then
             Sql.Add('AND C.CON_CONHECIMENTO_SERIE = '''+E_SERIE.Text+'''');

          if E_Origem.text <> '' then
             Sql.Add('AND C.CON_CONHECIMENTO_LOCALCOLETA = '''+E_Origem.text+'''');

          if E_Destino.text <> '' then
             Sql.Add('AND C.CON_CONHECIMENTO_LOCALENTREGA = '''+E_Destino.text+'''');



          if E_Carregamento.text <> '' then
             Sql.Add('AND C.ARM_CARREGAMENTO_CODIGO = '''+E_Carregamento.text+'''');
    **/
    
    dbms_output.put_line( vSQL );
    vStatus  := 'N';
    vMessage := 'Consulta executada com sucesso!';
  exception when others then
    vStatus  := 'E';
    vMessage := 'Erro ao executar consulta de CTRC, '||chr(13)||sqlerrm;
  end;
end;                               
   -- teste fabiano
/*   insert into dropme(a,x) 
   values('testejava', 'Data = '||sysdate||
   ' - pDataInicial = '||pDataInicial||
   ' - pDataFinal = '||pDataFinal||
   ' - pProjetado = '||pProjetado||
   ' - pRetirado = '||pRetirado); commit;
*/   
  
  procedure sp_get_ValorMesTransp(pDataInicial in char,
                                  pDataFinal   in char,
                                  pProjetado   in char,
                                  pRetirado    in varchar2,
                                  pRetorno     out T_CURSOR,
                                  pForcaProce  in char)
  as
     vDataInicial     Date;
     vDataFinal       Date;
     vProjetado       Date;
     vVlrAcumulado    number;
     vVlrMedia        number;
     vVlrProjetado    number;
     vIdProcessamento tdvadm.t_con_vmtransportado.con_vmtransportado_id%type;
     vIdSaveProces    tdvadm.t_con_vmtransportado.con_vmtransportado_id%type;
  begin
    
   EXECUTE IMMEDIATE ('ALTER SESSION SET nls_date_format = ''DD/MM/YYYY''');
     
   -- Formatação de parametros para consulta
   begin
      vDataInicial := to_date(pDataInicial,'DD/MM/YYYY');
   exception
     when OTHERS Then
        vDataInicial := to_date(sysdate,'DD/MM/YYYY');
   end;
    
   begin
      vDataFinal   := to_date(pDataFinal,'DD/MM/YYYY');
   exception
     when OTHERS Then
        vDataFinal := to_date(sysdate,'DD/MM/YYYY');
   end;

   begin
      vProjetado   := to_date(pProjetado,'DD/MM/YYYY');
   exception
     when OTHERS Then
        vProjetado := to_date(sysdate,'DD/MM/YYYY');
   end;
    
   
   if (nvl(pForcaProce,'N') = 'N' ) then
     -- verifico se existe algum processamento ja realizado para as datas executadas.
     begin
       
       select max(l.con_vmtransportado_id)
         into vIdProcessamento
         from tdvadm.t_con_vmtransportado l
        where trunc(l.con_vmtransportado_dtinicial)   = vDataInicial
          and trunc(l.con_vmtransportado_dtfinal)     = vDataFinal  
          and trunc(l.con_vmtransportado_dtprojetada) = vProjetado;
     
     exception when no_data_found then
       
       vIdProcessamento := null;
       
     end;  
     
     -- se existi processamento para a data solicitada, enviamos o relatorio ja solicitado
     if (vIdProcessamento is not null) then
       
       open pRetorno for
       select to_char(        l.con_vmsalvo_embarque,'DD/MM/YYYY')      as con_vlrmestransp_embarque,
              f_mascara_valor(l.con_vmsalvo_valor,20,2)                 as con_vlrmestransp_valor,
              f_mascara_valor(l.con_vmsalvo_dias,5,0)                   as con_vlrmestransp_dias,
              f_mascara_valor(l.con_vmsalvo_diastotal,5,0)              as con_vlrmestransp_diastotal,
              f_mascara_valor(l.con_vmsalvo_diasproj,5,0)               as con_vlrmestransp_diasproj,
              f_mascara_valor(l.con_vmsalvo_retirar,20,2)               as con_vlrmestransp_retirar,
              to_char(        l.con_vmsalvo_dtprojetado,'DD/MM/YYYY')   as dtprojetado,
              f_mascara_valor(l.con_vmsalvo_acumulado,20,2)             as con_vlrmestransp_acumulado,
              f_mascara_valor(l.con_vmsalvo_media,20,2)                 as con_vlrmestransp_media,
              f_mascara_valor(l.con_vmsalvo_projetado,20,2)             as con_vlrmestransp_projetado,
              t.con_vmtransportado_dtexecutado                          as dtexecucao
         from tdvadm.t_con_vmsalvo l,
              tdvadm.t_con_vmtransportado t
        where l.con_vmtransportado_id = vIdProcessamento
          and l.con_vmtransportado_id = t.con_vmtransportado_id
        order by l.con_vmsalvo_id;
        
        return;
     
     end if;  
     
   end if;
   
   -- deleto tabela de processamento final.
   -- limpa antes de criar novamente só pra garantir 
   delete from t_con_vlrmestransp; 
    
   -- carrego tabela de processamento para realizar o calculo dos campo.
   insert into t_con_vlrmestransp
    SELECT B.CON_CONHECIMENTO_DTEMBARQUE con_vlrmestransp_embarque,
           SUM(NVL(A.CON_CALCVIAGEM_VALOR,0)) con_vlrmestransp_VALOR,
           F_DD_DIASUTEIS(vDataInicial,B.CON_CONHECIMENTO_DTEMBARQUE ,'F') con_vlrmestransp_DIAS,
           F_DD_DIASUTEIS(vDataInicial,vDataFinal,'F') con_vlrmestransp_DIASTotal,
           F_DD_DIASUTEIS(vDataInicial,vProjetado,'F') con_vlrmestransp_DIASProj,
           nvl(to_number(pRetirado),0) con_vlrmestransp_RETIRAR,
           vProjetado AS con_vlrmestransp_dtPROJETADO,
           0 con_vlrmestransp_acumulado,
           0 con_vlrmestransp_media,
           0 con_vlrmestransp_projetado,
           0 con_vlrmestransp_abatimento ,
           0 con_vlrmestransp_abacumulado ,
           0 con_vlrmestransp_abmedia ,
           0 con_vlrmestransp_abprojetado 
     FROM T_CON_CONHECIMENTO B,
          T_CON_CALCCONHECIMENTO A
     WHERE 0=0 
       and trunc(B.CON_CONHECIMENTO_DTEMBARQUE) >= vDataInicial
       AND trunc(B.CON_CONHECIMENTO_DTEMBARQUE) <= vDataFinal
       AND B.CON_CONHECIMENTO_SERIE <> 'XXX'
       AND B.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
       AND A.CON_CONHECIMENTO_CODIGO = B.CON_CONHECIMENTO_CODIGO
       AND A.CON_CONHECIMENTO_SERIE = B.CON_CONHECIMENTO_SERIE
       AND A.GLB_ROTA_CODIGO = B.GLB_ROTA_CODIGO
       AND a.SLF_RECCUST_CODIGO = 'I_TTPV'
      GROUP BY B.CON_CONHECIMENTO_DTEMBARQUE
      ORDER BY B.CON_CONHECIMENTO_DTEMBARQUE;
    
   -- realiza processamento dos campos calculados
   vVlrAcumulado := 0;
   vVlrMedia     := 0;
   vVlrProjetado := 0;
   for c_cursor in (select * from t_con_vlrmestransp)
     loop        
         vVlrAcumulado := vVlrAcumulado + c_cursor.con_vlrmestransp_valor;
         vVlrMedia     := round(vVlrAcumulado / case c_cursor.con_vlrmestransp_dias
                                                  when 0 then 1
                                                  else  c_cursor.con_vlrmestransp_dias 
                                                end    ,2);
         vVlrProjetado := round(vVlrMedia * c_cursor.con_vlrmestransp_DIASProj,2) - c_cursor.con_vlrmestransp_retirar ;
         update t_con_vlrmestransp p
           set p.con_vlrmestransp_acumulado = vVlrAcumulado,
               p.con_vlrmestransp_media     = vVlrMedia,
               p.con_vlrmestransp_projetado = vVlrProjetado
         where p.con_vlrmestransp_embarque = c_cursor.con_vlrmestransp_embarque;      
     End Loop;

   begin
     
     -- Salvando parametros de processamento
     vIdSaveProces := tdvadm.seq_con_vmtransportado.nextval;
     insert into tdvadm.t_con_vmtransportado
       (con_vmtransportado_id,
        con_vmtransportado_dtinicial,
        con_vmtransportado_dtfinal,
        con_vmtransportado_dtprojetada,
        con_vmtransportado_dtexecutado)
     values
       (vIdSaveProces, vDataInicial, vDataFinal, vProjetado, sysdate);
       
     -- salvando processamento.
     for p_cursor in (select to_char(p.con_vlrmestransp_embarque,'DD/MM/YYYY')      as con_vlrmestransp_embarque,
                             p.con_vlrmestransp_valor                               as con_vlrmestransp_valor,
                             p.con_vlrmestransp_dias                                as con_vlrmestransp_dias,
                             p.con_vlrmestransp_diastotal                           as con_vlrmestransp_diastotal,
                             p.con_vlrmestransp_diasproj                            as con_vlrmestransp_diasproj,
                             p.con_vlrmestransp_retirar                             as con_vlrmestransp_retirar,
                             to_char(p.con_vlrmestransp_dtprojetado,'DD/MM/YYYY')   as dtprojetado,
                             p.con_vlrmestransp_acumulado                           as con_vlrmestransp_acumulado,
                             p.con_vlrmestransp_media                               as con_vlrmestransp_media,
                             p.con_vlrmestransp_projetado                           as con_vlrmestransp_projetado      
                        from tdvadm.t_con_vlrmestransp p)
     loop
       
       insert into tdvadm.t_con_vmsalvo
         (con_vmsalvo_id,
          con_vmsalvo_acumulado,
          con_vmsalvo_dtprojetado,
          con_vmsalvo_dias,
          con_vmsalvo_diasproj,
          con_vmsalvo_diastotal,
          con_vmsalvo_embarque,
          con_vmsalvo_media,
          con_vmsalvo_projetado,
          con_vmsalvo_retirar,
          con_vmsalvo_valor,
          con_vmtransportado_id)
       values
         (tdvadm.seq_con_vmsalvo.nextval,
          p_cursor.con_vlrmestransp_acumulado,
          p_cursor.dtprojetado,
          p_cursor.con_vlrmestransp_dias,
          p_cursor.con_vlrmestransp_diasproj,
          p_cursor.con_vlrmestransp_diastotal,
          p_cursor.con_vlrmestransp_embarque,
          p_cursor.con_vlrmestransp_media,
          p_cursor.con_vlrmestransp_projetado,
          p_cursor.con_vlrmestransp_retirar,
          p_cursor.con_vlrmestransp_valor,
          vIdSaveProces);
          
     end loop;                     
     
   exception when others then
     delete tdvadm.t_con_vmsalvo ll where ll.con_vmtransportado_id = vIdSaveProces;
     delete tdvadm.t_con_vmtransportado l where l.con_vmtransportado_id = vIdSaveProces;
   end;  
   
   commit;             
   
   -- retorna procesamento.
   open pRetorno for 
   select to_char(p.con_vlrmestransp_embarque,'DD/MM/YYYY')      as con_vlrmestransp_embarque,
          f_mascara_valor(p.con_vlrmestransp_valor,20,2)         as con_vlrmestransp_valor,
          f_mascara_valor(p.con_vlrmestransp_dias,5,0)           as con_vlrmestransp_dias,
          f_mascara_valor(p.con_vlrmestransp_diastotal,5,0)      as con_vlrmestransp_diastotal,
          f_mascara_valor(p.con_vlrmestransp_diasproj,5,0)       as con_vlrmestransp_diasproj,
          f_mascara_valor(p.con_vlrmestransp_retirar,20,2)       as con_vlrmestransp_retirar,
          to_char(p.con_vlrmestransp_dtprojetado,'DD/MM/YYYY')   as dtprojetado,
          f_mascara_valor(p.con_vlrmestransp_acumulado,20,2)     as con_vlrmestransp_acumulado,
          f_mascara_valor(p.con_vlrmestransp_media,20,2)         as con_vlrmestransp_media,
          f_mascara_valor(p.con_vlrmestransp_projetado,20,2)     as con_vlrmestransp_projetado,
          sysdate                                                as dtexecucao     
     from tdvadm.t_con_vlrmestransp p;

  End sp_get_ValorMesTransp;


  PROCEDURE SP_CopiaMove_CTe (V_NUMCONHEC_CLONE   IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                              V_SERIECONHEC_CLONE IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                              V_NUMROTA_CLONE     IN T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                              P_NUMCONHEC         IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                              P_SERIECONHEC       IN T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                              P_NUMROTA           IN T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                              P_TIPO              IN CHAR DEFAULT 'C',
                              P_AUTORIZADO        in char default 'N',
                              P_Status            OUT char,
                              P_Message           OUT varchar2)
 IS

--      V_TEXTOC         VARCHAR2(2000);
--      V_TEXTOC2        VARCHAR2(2000);
--      V_TEXTOC3        VARCHAR2(2000);
--      V_TEXTOU         VARCHAR2(2000);
--      V_TEXTOI         VARCHAR2(2000);
--      V_TEXTOI2        VARCHAR2(2000);
--      V_TEXTOD         VARCHAR2(2000);
      W_EXISTE         number;
      V_EXISTE_CONHEC  NUMBER;
      V_NOTA_OU_CONHEC VARCHAR2(100);
      V_CONTADOR       INTEGER;
      V_XMLNFSE        INTEGER;
      V_ARMNOTA        INTEGER;
      V_ARMNOTACte     INTEGER;
      V_EXISTEDOCFAT   INTEGER;
      vTerminal        v_glb_ambiente.terminal%type; 
--      vEnviaEle        t_con_conhecimento.con_conhecimento_enviaele%type; 
--      vTpCalculo       t_con_calcconhecimento.slf_tpcalculo_codigo%type;
--      vNumReferencia   varchar2(200);  
      V_NUMCONHEC      T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
      V_SERIECONHEC    T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
      V_NUMROTA        T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE;
      V_TIPO           CHAR(1);
      V_AUTORIZADO     CHAR(1);
      vColeta          tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
      vCiclo           tdvadm.t_arm_coleta.arm_coleta_ciclo%type;

    /*cursor
    select distinct tc.TABLE_NAME
    from dba_tab_columns tc
    where ( tc.COLUMN_NAME like '%CON_CONHECIMENTO_CODIGO%'
      and tc.OWNER = 'TDVADM'
      and (tc.TABLE_NAME like 'T_%' ))
      AND tc.TABLE_NAME NOT like '%TEMP%'
      AND tc.TABLE_NAME NOT like '%BKP%'
      AND tc.TABLE_NAME NOT like '%BCKP%'
      AND tc.TABLE_NAME NOT like '%OLD'
      AND tc.TABLE_NAME NOT like '%TMP'
    */




    BEGIN
    P_Status := pkg_glb_common.Status_Nomal;
    P_Message := ''; 
    WHO_CALLED_ME2;


    V_NUMCONHEC   := NVL(P_NUMCONHEC,V_NUMCONHEC_CLONE);
    V_SERIECONHEC := NVL(P_SERIECONHEC,'XXX'); 
    V_NUMROTA     := NVL(P_NUMROTA,V_NUMROTA_CLONE);
    V_TIPO        := NVL(P_TIPO,'C');
    V_AUTORIZADO  := NVL(P_AUTORIZADO,'N');



--         DBMS_OUTPUT.put_line(to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||' Inicio SP_COPIA_DADOS_CNHC_P_CNHC.'); 

        /********************************************************/
        /********** EXCEÇÃO PARA COPIA DOS DOCS DE MG ***********/
        /********************************************************/
        
        begin
          
          SELECT lower(v.terminal)
            into vTerminal
            fROM V_GLB_AMBIENTE v;
            
       
        end;
        
        /********************************************************/

      BEGIN
        SELECT COUNT(*)
          INTO W_EXISTE
          FROM T_CON_CONHECIMENTO CO
         WHERE CO.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
           AND CO.CON_CONHECIMENTO_SERIE = V_SERIECONHEC_CLONE
           AND CO.GLB_ROTA_CODIGO = V_NUMROTA_CLONE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          W_EXISTE := 0;
      END;

      
      /****************************************************************/
      /*     KLAYTON 01/12/2011 CONTO SE A CTRC/CTE ESTA FATURAD      */
      /****************************************************************/
      BEGIN
      
      SELECT COUNT(*)
      INTO V_EXISTEDOCFAT
      FROM T_CON_CONHECIMENTO K
      WHERE K.CON_CONHECIMENTO_CODIGO    = V_NUMCONHEC_CLONE
        AND K.CON_CONHECIMENTO_SERIE     = V_SERIECONHEC_CLONE
        AND K.GLB_ROTA_CODIGO            = V_NUMROTA_CLONE
        AND NVL(K.CON_FATURA_CODIGO,'N') <> 'N' ;
      
      EXCEPTION WHEN OTHERS THEN
        P_Status := pkg_glb_common.Status_Erro;
        P_Message := 'Erro ao Copiar Conhecimento. Proc= "SP_COPIA_DADOS_CNHC_P_CNHC" Erro= '||SQLERRM;
        Return;
      END;    
      
      /****************************************************************/
      /*              SE ESTIVER FATURADO BLOQUEIO A COPIA            */
      /****************************************************************/
/*      IF ( V_EXISTEDOCFAT >=1 ) AND (V_AUTORIZADO = 'N') THEN
        P_Status := pkg_glb_common.Status_Erro;
        P_Message := 'Conhecimento já Faturado impossivel Copiar / Mover!';
        Return;
      END IF;  */
/*      IF ( V_SERIECONHEC_CLONE = 'XXX' ) Then
        P_Status := pkg_glb_common.Status_Erro;
        P_Message := 'Conhecimento Serie XXX impossivel Copiar / Mover!';
        Return;
      End If;
        */
      IF W_EXISTE > 0 THEN
      
      Begin


        
    /*    SELECT COUNT(*)
          INTO W_EXISTE
          FROM DBA_TABLES T
         WHERE T.TABLE_NAME = 'T_WSD_XMLNFSETMP'
           AND T.OWNER = 'WSERVICE';*/
           
    /*    SELECT COUNT(*)
          INTO W_EXISTE
          FROM TAB T
         WHERE TNAME = 'T_WSD_XMLNFSETMP';
        IF W_EXISTE = 1 THEN
          EXECUTE IMMEDIATE (REPLACE(V_TEXTOD,
                                     'ARQUIVO',
                                     'T_WSD_XMLNFSE'));
        END IF;*/
      
        /*VERIFICA SE JA EXISTE ESTE CONHECIMENTO*/
        BEGIN
          SELECT COUNT(*)
            INTO V_EXISTE_CONHEC
            FROM T_CON_CONHECIMENTO CO
           WHERE CO.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC
             AND CO.CON_CONHECIMENTO_SERIE = V_SERIECONHEC
             AND CO.GLB_ROTA_CODIGO = V_NUMROTA;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_EXISTE_CONHEC := 0;
        END;
      
        /* ESTA ACONTECENDO DE FAZER UMA COPIA PRO XXX E O CONHECIMENTO JA EXISTIR. 
        SE EXISTIR COMO XXX ELE DEIXA PASSAR MAS EXCLUI O EXISTENTE PARA INSERIR UM NOVO */
        IF ((V_EXISTE_CONHEC = 0) OR (V_SERIECONHEC = 'XXX')) THEN
          IF V_SERIECONHEC = 'XXX' THEN
             SP_EXCLUI_XXX_CTRC_ROTA(V_NUMCONHEC, V_NUMROTA);
          END IF;
          
          
           
          INSERT INTO tdvadm.T_CON_CONHECIMENTO
             SELECT V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    SLF_SOLFRETE_CODIGO,
                    SLF_SOLFRETE_SAQUE,
                    SLF_TABELA_CODIGO,
                    SLF_TABELA_SAQUE,
                    PRG_PROGCARGA_CODIGO,
                    PRG_PROGCARGADET_SEQUENCIA,
                    GLB_ROTA_CODIGOPROGCARGADET,
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
                    CON_CONHECIMENTO_LOCALCOLETA,
                    CON_CONHECIMENTO_LOCALENTREGA,
                    GLB_LOCALIDADE_CODIGOORIGEM,
                    GLB_LOCALIDADE_CODIGODESTINO,
                    CON_CONHECIMENTO_DTINCLUSAO,
                    CON_CONHECIMENTO_DTALTERACAO,
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
                    CON_CONHECIMENTO_KILOMETRAGEM,
                    CON_CONHECIMENTO_LOTE,
                    CON_CONHECIMENTO_TPREGISTRO,
                    CON_CONHECIMENTO_DTGRAVACAO,
                    null CON_FATURA_CODIGO,
                    null CON_FATURA_CICLO,
                    null GLB_ROTA_CODIGOFILIALIMP,
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
                    GLB_ROTA_CODIGOGENERICO,
                    CON_CONHECIMENTO_VLRINDENIZ,
                    CON_CONHECIMENTO_PESOINDENIZ,
                    CON_CONHECIMENTO_FATURAINDENIZ,
                    CON_CONHECIMENTO_DTVENCINDENIZ,
                    CON_CONHECIMENTO_AVARIAS,
                    CON_CONHECIMENTO_ESCOAMENTO,
                    CON_CONHECIMENTO_DTCHEGMATRIZ,
                    null CON_VALEFRETE_CODIGO,
                    null CON_VALEFRETE_SERIE,
                    null GLB_ROTA_CODIGOVALEFRETE,
                    null CON_VALEFRETE_SAQUE,
                    GLB_GERRISCO_CODIGO,
                    CON_CONHECIMENTO_CODLIBERACAO,
                    CON_CONHECIMENTO_AUTORISEG,
                    CON_CONHECIMENTO_CFO,
                    CON_CONHECIMENTO_TRIBUTACAO,
                    CON_CONHECIMENTO_TPCOMPLEMENTO,
                    CON_CONHECIMENTO_DTTRANSF,
                    CON_CONHECIMENTO_NRFORMULARIO,
                    CON_CONHECIMENTO_DTRECEBIMENTO,
                    CON_CONHECIMENTO_DTCHEGCELULA,
                    ARM_COLETA_NCOMPRA,
                    CON_CONHECIMENTO_DTENVSEG,
                    CON_CONHECIMENTO_DTENVEDI,
                    CON_CONHECIMENTO_DTSAIDACELULA,
                    CON_CONHECIMENTO_DTCHEGALMOX,
                    CON_CONHECIMENTO_DTINICARGA,
                    CON_CONHECIMENTO_DTFIMCARGA,
                    USU_USUARIO_SAIDA,
                    USU_USUARIO_BAIXA,
                    CON_CONHECIMENTO_OBSLEI,
                    CON_CONHECIMENTO_OBSCLIENTE,
                    GLB_ROTA_CODIGORECEITA,
                    CON_CONHECIMENTO_DTNFE,
                    CON_CONHECIMENTO_DTCHECKIN,
                    CON_CONHECIMENTO_DTGRAVCHECKIN,
                    ARM_CARREGAMENTO_CODIGO,
                    CON_CONHECIMENTO_TERMINAL,
                    CON_CONHECIMENTO_OSUSER,
                    CON_CONHECIMENTO_ENVIAELE,
                    ARM_COLETA_CICLO,
                    SLF_SOLFRETE_OBSSOLICITACAO,
                    CON_CONHECIMENTO_RGMESP,
                    CON_CONHECIMENTO_CST,
                    ARM_CARREGAMENTO_CODIGOPR
              FROM T_CON_CONHECIMENTO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
        
          /********************************************/
          /*** PREENCHE NA VARIAVEL VERIFICANDO  SE ***/ /*PORPS*/
          /*** E UM CONHECIMENTO OU UMA NOTA FISCAL ***/
          /********************************************/
          BEGIN
            SELECT F_BUSCA_CONHEC_TPFORMULARIO(V_NUMCONHEC_CLONE,
                                               V_SERIECONHEC_CLONE,
                                               V_NUMROTA_CLONE)
              INTO V_NOTA_OU_CONHEC
              FROM DUAL;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_NOTA_OU_CONHEC := NULL;
          END;
        
          /************************************************************/
          /*** SE A SERIE FOR DIFERENTE DE XXX E N?O FOR NOTA FICAL ***/
          /********* QUE ELE VAI RODAR ESSA ROTINA PARA TIRAR *********/ /*PORPS*/
          /*************** A  IMPRESS?O DO CONHECIMENTO ***************/
          /************************************************************/
          IF ((V_SERIECONHEC = 'XXX') AND
             (TRIM(NVL(V_NOTA_OU_CONHEC, 'X')) <> 'NF')) THEN
          
             sp_con_retiraimpressao(V_NUMCONHEC, V_SERIECONHEC, V_NUMROTA);
          
          END IF;
          
          insert into tdvadm.t_Con_Conheccomplemento
           SELECT V_NUMCONHEC,
                  V_SERIECONHEC,
                  V_NUMROTA,
                  CON_CONHECIMENTO_CODIGOORIGEM,
                  CON_CONHECIMENTO_SERIEORIGEM,
                  GLB_ROTA_CODIGOORIGEM
           from tdvadm.t_Con_Conheccomplemento
           WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
             AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
             AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
          

          insert into tdvadm.T_CON_CALCCONHECIMENTO
           SELECT V_NUMCONHEC,
                  V_SERIECONHEC,
                  V_NUMROTA,
                  SLF_RECCUST_CODIGO,
                  SLF_TPCALCULO_CODIGO,
                  GLB_MOEDA_CODIGO,
                  CON_CALCVIAGEM_DESINENCIA,
                  CON_CALCVIAGEM_REEMBOLSO,
                  CON_CALCVIAGEM_VALOR,
                  CON_CALCVIAGEM_TPRATEIO,
                  CON_CONHECIMENTO_DTEMBARQUE,
                  CON_CONHECIMENTO_ALTALTMAN,
                  GLB_ROTA_CODIGOGENERICO,
                  CON_CALCCONHECIMENTO_COCLI
           from tdvadm.T_CON_CALCCONHECIMENTO
           WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
             AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
             AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
        
        
          insert into tdvadm.T_CON_CONSIGREDESPACHO
           SELECT V_NUMCONHEC,
                  V_SERIECONHEC,
                  V_NUMROTA,
                  CON_CONSIGREDESPACHO_FLAGCR,
                  CON_CONSIGREDESPACHO_EMPRESA,
                  CON_CONSIGREDESPACHO_ENDERECO,
                  CON_CONSIGREDESPACHO_MUNICIPIO,
                  CON_CONSIGREDESPACHO_CGCCPF,
                  CON_CONSIGREDESPACHO_IE,
                  CON_CONSIGREDESPACHO_UF,
                  CON_CONSIGREDESPACHO_ETIQUETA,
                  CON_CONSIGREDESPACHO_FRETECOBR,
                  CON_CONSIGREDESPACHO_REDFRETE,
                  CON_CONSIGREDESPACHO_CONHEC,
                  CON_TPDOC_CODIGO,
                  GLB_TPCLIEND_CODIGO,
                  CON_CONSIGREDESPACHO_SERIEDOC,
                  CON_CONSIGREDESPACHO_DTEMISSAO,
                  CON_CONSIGREDESPACHO_CHAVECTE
           from tdvadm.T_CON_CONSIGREDESPACHO
           WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
             AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
             AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;

            SELECT KK.Arm_Coleta_Ncompra,
                   KK.Arm_Coleta_Ciclo         
              INTO vColeta,
                   vCiclo 
              FROM tdvadm.T_CON_CONHECIMENTO KK
             WHERE KK.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND KK.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND KK.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE ;

        
          INSERT INTO tdvadm.T_CON_NFTRANSPORTA
             SELECT V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
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
                    GLB_CFOP_CODIGO,
                    CON_NFTRANSPORTADA_VALORBSICMS,
                    CON_NFTRANSPORTADA_VALORICMS,
                    CON_NFTRANSPORTADA_VLBSICMSST,
                    CON_NFTRANSPORTADA_VLICMSST,
                    CON_NFTRANSPORTADA_CHAVENFE,
                    CON_TPDOC_CODIGO,
                    CON_NFTRANSPORTADA_DTEMISSAO,
                    CON_NFTRANSPORTADA_DTSAIDA,
                    CON_NFTRANSPORTADA_SERIENF,
                    GLB_ONU_CODIGO,
                    GLB_ONU_GRPEMB,
                    vColeta,
                    vCiclo
              FROM tdvadm.T_CON_NFTRANSPORTA
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO = V_NUMROTA_CLONE;

          If V_SERIECONHEC <> 'XXX' Then
        
            INSERT INTO tdvadm.T_CON_CONHECFATURADO
               SELECT V_NUMCONHEC,
                      V_SERIECONHEC,
                      V_NUMROTA,
                      CON_FATURA_CODIGO,
                      CON_FATURA_CICLO,
                      GLB_ROTA_CODIGOFILIALIMP,
                      GLB_ROTA_CODIGOTITREC,
                      CRP_TITRECEBER_NUMTITULO,
                      CRP_TITRECEBER_SAQUE,
                      CON_CONHECIMENTO_DTEMBARQUE,
                      CON_CONHECIMENTO_VALOR,
                      CON_CONHECIMENTO_CGCCPFSACADO,
                      CON_CONHECFATURADO_PAGO,
                      CON_CONHECFATURADO_COMPROVANTE,
                      CON_CONHECFATURADO_VALORPAGO,
                      CON_CONHECFATURADO_DTBAIXA,
                      CON_CONHECFATURADO_DESCONTO,
                      CON_CONHECFATURADO_VLRACRES,
                      CON_CONHECFATURADO_DESPCART,
                      CON_CONHECFATURADO_DESPJUROS,
                      CON_CONHECFATURADO_DESPOUTROS
                FROM T_CON_CONHECFATURADO
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGOCONHEC = V_NUMROTA_CLONE;
          
            INSERT INTO tdvadm.T_CON_NFFATURADA
               SELECT V_NUMCONHEC,
                      V_SERIECONHEC,
                      V_NUMROTA,
                      CON_FATURA_CODIGO,
                      CON_FATURA_CICLO,
                      GLB_ROTA_CODIGOFILIALIMP,
                      GLB_ROTA_CODIGOTITREC,
                      CRP_TITRECEBER_NUMTITULO,
                      CRP_TITRECEBER_SAQUE,
                      GLB_ROTA_CODIGO,
                      CON_NFTRANSPORTADA_NUMNFISCAL,
                      GLB_EMBALAGEM_CODIGO,
                      CON_NFTTRANSPORTA_MERCADORIA,
                      CON_NFFATURADA_PAGO,
                      CON_NFFATURADA_VALOR,
                      CON_NFFATURADA_VALORPAGO,
                      CON_NFFATURADA_PESO,
                      CON_NFFATURADA_JUROS,
                      CON_NFFATURADA_DTBAIXA,
                      CON_NFFATURADA_DESCONTO,
                      CON_NFFATURADA_VLRACRES,
                      CON_NFFATURADA_DESPCART,
                      CON_NFFATURADA_DESPOUTROS
                FROM tdvadm.T_CON_NFFATURADA
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGOCONHEC = V_NUMROTA_CLONE;
          
            INSERT INTO tdvadm.T_CON_HISTCONHECFATURADO
             SELECT CRP_TITRECEBER_SAQUE,
                    CRP_TITRECEBER_NUMTITULO,
                    GLB_ROTA_CODIGOTITREC,
                    CON_FATURA_CICLO,
                    V_NUMCONHEC,
                    V_SERIECONHEC,
                    CON_FATURA_CODIGO,
                    V_NUMROTA,
                    GLB_ROTA_CODIGOFILIALIMP,
                    CON_HISTCONHECFATURADO_SEQ,
                    CON_HISTCONHECFATURADO_DTBAIXA,
                    CON_HISTCONHECFATURADO_VALORPA,
                    CON_HISTCONHECFATURADO_DESCONT,
                    CON_HISTCONHECFATURADO_VLRACRE,
                    CON_HISTCONHECFATURADO_DESPCAR,
                    CON_HISTCONHECFATURADO_DESPJUR,
                    CON_HISTCONHECFATURADO_DESPOUT
                FROM T_CON_HISTCONHECFATURADO
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO = V_NUMROTA_CLONE;
          
            INSERT INTO tdvadm.T_CON_HISTNFFATURADA
             SELECT CON_NFTTRANSPORTA_MERCADORIA,
                    GLB_EMBALAGEM_CODIGO,
                    CON_NFTRANSPORTADA_NUMNFISCAL,
                    CRP_TITRECEBER_SAQUE,
                    CRP_TITRECEBER_NUMTITULO,
                    GLB_ROTA_CODIGOTITREC,
                    GLB_ROTA_CODIGOFILIALIMP,
                    CON_FATURA_CODIGO,
                    V_NUMROTA,
                    V_NUMCONHEC,
                    V_SERIECONHEC,
                    CON_FATURA_CICLO,
                    CON_HISTNFFATURADA_SEQ,
                    GLB_ROTA_CODIGOCONHEC,
                    CON_HISTNFFATURADA_DTBAIXA,
                    CON_HISTNFFATURADA_VALORPAGO,
                    CON_HISTNFFATURADA_DESCONTO,
                    CON_HISTNFFATURADA_VLRACRES,
                    CON_HISTNFFATURADA_DESPCART,
                    CON_HISTNFFATURADA_DESPOUTROS
                FROM T_CON_HISTNFFATURADA
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGOCONHEC   = V_NUMROTA_CLONE;
        
            insert into tdvadm.t_con_conhecctb 
             select V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    CON_CONHECCTB_ID,
                    CON_CONHECCTB_DATACTB,
                    CON_CONHECCTB_DATAFISCAL,
                    CON_CONHECIMENTO_DTEMBARQUE,
                    CON_CONHECCTB_ROTA_RECEITA,
                    CON_CONHECCTB_ROTA_FISCAL,
                    CON_CONHECCTB_VALOR,
                    CON_CONHECCTB_VALOR_INSS,
                    CON_CONHECCTB_VALOR_ICMS,
                    CON_CONHECCTB_REF,
                    CON_CONHECCTB_EX,
                    CON_CONHECCTB_FLAGCANCELADO,
                    CON_CONHECCTB_OBSERVACAO,
                    CON_CONHECCTB_SACADO,
                    CON_CONHECCTB_VALOR_PEDAGIO,
                    GLB_CENTROCUSTO_CODIGO,
                    GLB_CENTROCUSTO_CODIGOC,
                    con_conhecctb_aliquota_icms,
                    CON_CONHECCTB_ALIQUOTA_ISS 
               from tdvadm.t_con_conhecctb 
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

            insert into tdvadm.T_CON_VFRETECONHEC 
             select CON_VALEFRETE_CODIGO,
                    CON_VALEFRETE_SERIE,
                    GLB_ROTA_CODIGOVALEFRETE,
                    CON_VALEFRETE_SAQUE,
                    V_NUMROTA,
                    V_NUMCONHEC,
                    V_SERIECONHEC,
                    CON_VFRETECONHEC_RECALCULA,
                    SLF_TPCALCULO_CODIGO,
                    CON_VFRETECONHEC_SALDO,
                    CON_VFRETECONHEC_PEDAGIO,
                    CON_VFRETECONHEC_RATEIORECEITA,
                    CON_VFRETECONHEC_RATEIOFRETE,
                    CON_VFRETECONHEC_RATEIOPEDAGIO,
                    CON_VFRETECONHEC_DTENTREGA,
                    CON_VFRETECONHEC_RATEIOICMISS,
                    CON_VFRETECONHEC_DTGRAVACAO,
                    CON_VFRETECONHEC_USUMAQ,
                    CON_VFRETECONHEC_TRANSFCHEKIN,
                    ARM_ARMAZEM_CODIGO
               from tdvadm.T_CON_VFRETECONHEC
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;
            
          End If; 

            insert into tdvadm.T_CON_VEICCONHEC 
             select FCF_VEICULODISP_CODIGO,
                    FCF_VEICULODISP_SEQUENCIA,
                    V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    CON_VEICCONHEC_DATA,
                    USU_USUARIO_CODIGO
               from tdvadm.T_CON_VEICCONHEC
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

          
            insert into tdvadm.T_CON_CTEENVIO 
             select V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    GLB_FORMAENVIO_CODIGO,
                    CON_CTEENVIO_DTENVIO
               from tdvadm.T_CON_CTEENVIO
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

            insert into tdvadm.T_BER_CONHECBERCOS 
             select BER_LOCADOR_CODIGO,
                    BER_MOVBERCOS_NUMERONF,
                    V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    BER_CONHECBERCOS_DATA,
                    BER_CONHECBERCOS_SEQ
               from tdvadm.T_BER_CONHECBERCOS
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

        
            insert into tdvadm.T_CON_NFTRANSPORTAEXTRA 
             select V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    CON_NFTRANSPORTADA_NUMNFISCAL,
                    GLB_EMBALAGEM_CODIGO,
                    CON_NFTTRANSPORTA_MERCADORIA,
                    CON_NFTRANSPORTA_DTEMISSAO,
                    CON_NFTRANSPORTA_DATA2,
                    CON_NFTRANSPORTA_STRING1,
                    CON_NFTRANSPORTA_STRING2,
                    CON_NFTRANSPORTA_STRING3,
                    CON_NFTRANSPORTA_STRING4,
                    CON_NFTRANSPORTA_NUMBER1,
                    CON_NFTRANSPORTA_NUMBER2,
                    CON_NFTRANSPORTA_NUMBER3,
                    CON_NFTRANSPORTA_NUMBER4,
                    CON_NFTRANSPORTA_SERIE,
                    CON_NFTRANSPORTA_DATA1,
                    GLB_ONU_CODIGO,
                    GLB_ONU_GRPEMB
               from tdvadm.T_CON_NFTRANSPORTAEXTRA
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

        
            insert into tdvadm.T_CON_CONHECVPED 
             select V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    GLB_CLIENTE_CGCCPFCODIGO,
                    GLB_CLIENTEREGESP_CODIGO,
                    CON_FPAGTOMOTPED_CODIGO,
                    CON_FCOBPED_CODIGO,
                    CON_MODALIDADEPED_CODIGO,
                    CON_CONHECVPED_TRANSACAO,
                    CON_CONHECVPED_VALOR,
                    CON_CONHECIMENTO_VALORTDV,
                    CON_CONHECIMENTO_DTGRAVACAO
               from tdvadm.T_CON_CONHECVPED
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

            insert into tdvadm.T_CON_CONHECGSRMOV 
             select GSR_GERRISCO_CODIGO,
                    GSR_GERRISCOPROD_CODIGO,
                    GSR_MOVIMENTO_CPFCODIGO,
                    GSR_MOVIMENTO_DTCONSULTA,
                    GLB_TPMOTORISTA_CODIGO,
                    GSR_MOVIMENTO_CODLIBERACAO,
                    V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    CON_VALEFRETE_SAQUE,
                    CON_CONHECGSRMOV_TPDOC,
                    CON_CONHECGSRMOV_DTGRAVACAO
               from tdvadm.T_CON_CONHECGSRMOV
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

        
            insert into tdvadm.T_CON_CONHECAUTORIZADOR 
             select V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    CON_CONHECIMENTO_AUTORIZADOR,
                    CON_CONHECIMENTO_TXTAUTORIZADO
               from tdvadm.T_CON_CONHECAUTORIZADOR
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

        
            insert into tdvadm.T_UTI_CONTROLEENVIO 
             select UTI_CONTROLEENVIO_ARQUIVO,
                    ARM_MOVIMENTO_NFENTRADA,
                    GLB_CLIENTE_CGCCPFREMETENTE,
                    V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    UTI_CONTROLEENVIO_DTENVIO,
                    UTI_CONTROLEENVIO_DTINTEGRA
               from tdvadm.T_UTI_CONTROLEENVIO
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

/*
            insert into tdvadm.T_CON_CONHECCFOP 
             select V_NUMCONHEC,
                    V_SERIECONHEC,
                    V_NUMROTA,
                    CON_CONHECCFOP_CODIGO,
                    CON_CONHECCFOP_CODIGO2
               from tdvadm.T_CON_CONHECCFOP
               WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                 AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                 AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

*/                  
          
    /*      EXECUTE IMMEDIATE (replace(V_TEXTOC3, 'ARQUIVO', 'T_WSD_XMLNFSE'));
          EXECUTE IMMEDIATE (replace(V_TEXTOU, 'ARQUIVO', 'T_WSD_XMLNFSE'));
          EXECUTE IMMEDIATE (replace(V_TEXTOI2, 'ARQUIVO', 'T_WSD_XMLNFSE'));*/
        
          IF V_TIPO = 'M' THEN
            -- SE ESTIVER MOVENDO
            

            DELETE T_CON_HISTNFFATURADA
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGOCONHEC   = V_NUMROTA_CLONE;
          
            DELETE T_CON_HISTCONHECFATURADO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
          
            DELETE T_CON_NFFATURADA
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGOCONHEC   = V_NUMROTA_CLONE;
          
            DELETE T_CON_CONHECFATURADO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGOCONHEC   = V_NUMROTA_CLONE;

            DELETE T_CON_VEICCONHEC
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO   = V_NUMROTA_CLONE;

            DELETE t_Con_Conhecvped
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND glb_rota_codigo         = V_NUMROTA_CLONE;
            
            DELETE T_CON_CONHECGSRMOV
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND glb_rota_codigo         = V_NUMROTA_CLONE;

            DELETE T_CON_CTEENVIO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND glb_rota_codigo         = V_NUMROTA_CLONE;
          
          DELETE T_CON_NFTRANSPORTAEXTRA H
             WHERE H.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND H.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND H.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
               
            DELETE T_CON_NFTRANSPORTA
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
             
          
            DELETE T_CON_CALCCONHECIMENTO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
          
            DELETE T_CON_LOGGERACAO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
          
            DELETE T_CON_CONSIGREDESPACHO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
          
            DELETE T_CON_CONHECCTB
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
          
            delete t_con_vfreteconhec c
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
               
            delete TDVADM.T_CON_CONHECCFOP c
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
                  
               
               
    /*        DELETE WSERVICE.T_WSD_XMLNFSE W
             WHERE W.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND W.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND W.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;   */
               
               
                  
           SELECT COUNT(*)
             INTO V_XMLNFSE
             FROM WSERVICE.T_WSD_XMLNFSE X
            WHERE X.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
              AND X.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
              AND X.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE; 
              
              IF V_XMLNFSE = 1 THEN
                
                UPDATE WSERVICE.T_WSD_XMLNFSE W
                   SET W.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC,
                       W.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC,
                       W.GLB_ROTA_CODIGO         = V_NUMROTA
                 WHERE W.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                   AND W.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                   AND W.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
              
              END IF;   
              
              
             SELECT COUNT(*)
             INTO V_ARMNOTA
             FROM T_ARM_NOTA X
            WHERE X.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
              AND X.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
              AND X.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE; 
              
             IF V_ARMNOTA = 1 THEN
                
                UPDATE T_ARM_NOTA W
                   SET W.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC,
                       W.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC,
                       W.GLB_ROTA_CODIGO         = V_NUMROTA
                 WHERE W.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                   AND W.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                   AND W.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
                 
                 if (sql%rowcount > 1) then
                     raise_application_error(-20001, 'Conhecimento em mais de uma nota na t_arm_nota'||chr(13)||dbms_utility.format_error_stack);
                 end if;
              END IF; 
              
              
              
              
           SELECT COUNT(*)
             INTO V_ARMNOTActe
             FROM T_ARM_NOTActe X
            WHERE X.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
              AND X.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
              AND X.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE; 
              
--             IF V_ARMNOTActe = 1 THEN
                
                UPDATE T_ARM_NOTActe W
                   SET W.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC,
                       W.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC,
                       W.GLB_ROTA_CODIGO         = V_NUMROTA
                 WHERE W.CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
                   AND W.CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
                   AND W.GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;
              
--              END IF;       
              
               
          
            DELETE T_CON_CONHECIMENTO
             WHERE CON_CONHECIMENTO_CODIGO = V_NUMCONHEC_CLONE
               AND CON_CONHECIMENTO_SERIE  = V_SERIECONHEC_CLONE
               AND GLB_ROTA_CODIGO         = V_NUMROTA_CLONE;     
               

          
          END IF;
        
        END IF;
      
        -- EXEC SP_COPIA_DADOS_CNHC_P_CNHC('006353','A1','460','X06353','A1','460','C')
        COMMIT;
        
      exception
        When OTHERS Then
         
            raise_application_error(-20001,'COPIANDO CTE ' || sqlerrm );
        end;  
      END IF;
      
--      DBMS_OUTPUT.put_line(to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||' Final SP_COPIA_DADOS_CNHC_P_CNHC.');
  
  END SP_CopiaMove_CTe;


  Procedure SP_ValidaCopia(pNumCte  IN  T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                           pSerie   IN  T_CON_CALCCONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                           pRota    IN  T_CON_CALCVIAGEMDET.GLB_ROTA_CODIGOVIAGEM%TYPE,
                           pTipo    IN  char, -- (C)omplemento, (D)evolução
                           pObs     IN  varchar2
--                           ,pStatus  OUT char,
--                           pMessage OUT varchar2
                           )
    is
       vStatus    char(1);
       vMessage   varchar2(32000);
       vTpCalculo tdvadm.t_con_calcconhecimento.slf_tpcalculo_codigo%type;
    Begin
        vStatus  := pkg_glb_common.Status_Nomal;
        vMessage := '';
        If nvl(pTipo,'X') = 'X' Then 
           vStatus  := pkg_glb_common.Status_Erro;
           vMessage := 'Tipo de Copia Obrigatorio (C)omplemento ou (D)evolucao';
           Return ;
        End If;
        
        pkg_con_ctrc.SP_CopiaMove_CTe(pNumCte,
                                      pSerie,
                                      pRota,
                                      pNumCte,
                                      'XXX',
                                      pRota,   
                                      'C',     -- Copia
                                      'S',     -- Autorizado
                                      vStatus,
                                      vMessage);

        if vStatus <> pkg_glb_common.Status_Nomal Then 
           vStatus  := pkg_glb_common.Status_Erro;
           vMessage := vMessage;
           Return;           
        End If;

        SP_CON_RETIRAIMPRESSAO(pNumCte,
                               'XXX',
                               pRota);
        
         
        -- Insere a referencia do Complemento
        insert into t_con_conheccomplemento
        (con_conhecimento_codigo,
         con_conhecimento_serie,
         glb_rota_codigo,
         con_conhecimento_codigoorigem,
         con_conhecimento_serieorigem,
         glb_rota_codigoorigem)
        Values
        (pNumCte,
         'XXX',
         pRota,
         pNumCte,
         pSerie,
         pRota);
         
         -- INCLUI NA OBSERVAÇÃO A MENSAGEM DE COMPLEMENTO                                       
         UPDATE T_CON_CONHECIMENTO C
           SET C.CON_CONHECIMENTO_OBS = 'REFERENTE AO COMPLEMENTO DO CTe-' || pNumCte || ' SERIE-' || pRota || ' ' || nvl(pObs,'') || ' ',
               c.con_conhecimento_flagcomplemen = 'S',
               c.con_conhecimento_dtemissao = trunc(sysdate),
               c.con_conhecimento_dtalteracao = trunc(sysdate),
               c.con_conhecimento_dtenvedi = null,
               c.con_conhecimento_dtsaidacelula = null,
               c.con_conhecimento_dtenvseg = null,
               c.con_conhecimento_dtrecebimento = null,
               c.con_conhecimento_dttransf = null,
               c.con_conhecimento_dtinclusao = null,
               c.con_conhecimento_dtchegcelula = null,
               c.con_conhecimento_dtnfe = null,
               c.con_conhecimento_dtcheckin = null,
               c.con_conhecimento_dtgravcheckin = null,
               c.con_conhecimento_dtgravacao = sysdate,
               c.con_conhecimento_vencimento = null,
               c.con_conhecimento_entrega = null,
               c.con_conhecimento_dtfimcarga = null,
               c.con_conhecimento_dtchegalmox = null,
               c.con_conhecimento_dtembarque = trunc(sysdate),
               c.con_conhecimento_dtchegmatriz = null,
               c.con_conhecimento_dtinicarga = null,
               c.con_conhecimento_horasaida = null,
               c.con_conhecimento_dtvencindeniz = null
         where c.con_conhecimento_codigo = pNumCte
           and c.con_conhecimento_serie  = 'XXX'
           and c.glb_rota_codigo         = pRota;
            

         -- Zera as Verbas do Conhecimento
         update t_con_calcconhecimento ca
           set ca.con_calcviagem_valor = 0,
               ca.con_calcviagem_desinencia = 'VL'
         where ca.con_conhecimento_codigo = pNumCte
           and ca.con_conhecimento_serie  = 'XXX'
           and ca.glb_rota_codigo         = pRota
           and substr(ca.slf_reccust_codigo,1,2) = 'D_';
           
/*         -- Coloca peso de 1 Tonelado
         update t_con_calcconhecimento ca
           set ca.con_calcviagem_valor = 1
         where ca.con_conhecimento_codigo = pNumCte
           and ca.con_conhecimento_serie  = 'XXX'
           and ca.glb_rota_codigo         = pRota
           and ca.slf_reccust_codigo = 'I_PSCOBRAD';
*/
         -- Pega o Tipo de Calculo
         select CA.SLF_TPCALCULO_CODIGO
           into vTpCalculo
         from t_con_calcconhecimento ca
         where ca.con_conhecimento_codigo = pNumCte
           and ca.con_conhecimento_serie  = 'XXX'
           and ca.glb_rota_codigo         = pRota
           and ca.slf_reccust_codigo = 'I_TTPV';
           
         -- Recalcula as Verbas  
         PKG_SLF_CALCULOS.SP_MONTA_FORMULA_CNHC(vTpCalculo,
                                                pNumCte,
                                                'XXX',
                                                pRota);

         Commit;   
         
           

    End SP_ValidaCopia;



   PROCEDURE SP_CON_RETIRAIMPRESSAO(P_CON_CONHECIMENTO_CODIGO T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                    P_CON_CONHECIMENTO_SERIE  T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                    p_GLB_ROTA_CODIGO         T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE) AS
        V_TEXTO VARCHAR2(200);
      BEGIN
         
       vDeixaTirarImpressao := 'S';

--        V_TEXTO := 'ALTER TRIGGER TG_CON_CONHECIMENTO DISABLE';
--        EXECUTE IMMEDIATE (V_TEXTO);
--        V_TEXTO := 'ALTER TRIGGER TG_CON_CONHECIMENTOB DISABLE';
--        EXECUTE IMMEDIATE (V_TEXTO);

        BEGIN
          UPDATE T_CON_CONHECIMENTO C
             SET C.CON_CONHECIMENTO_DIGITADO     = 'D',
                 C.CON_CONHECIMENTO_NRFORMULARIO = NULL
           WHERE C.CON_CONHECIMENTO_CODIGO = P_CON_CONHECIMENTO_CODIGO
             AND C.CON_CONHECIMENTO_SERIE = P_CON_CONHECIMENTO_SERIE
             AND C.GLB_ROTA_CODIGO = p_GLB_ROTA_CODIGO;
        
        EXCEPTION
          WHEN OTHERS THEN
             vDeixaTirarImpressao := 'N';
--             V_TEXTO := 'ALTER TRIGGER TG_CON_CONHECIMENTO ENABLE';
--             EXECUTE IMMEDIATE (V_TEXTO);
--             V_TEXTO := 'ALTER TRIGGER TG_CON_CONHECIMENTOB ENABLE';
--             EXECUTE IMMEDIATE (V_TEXTO);
          
            RAISE_APPLICATION_ERROR(-20001,
                                    'ERRO: IMPRESS?O N?O FOI RETIRADA ' ||
                                    P_CON_CONHECIMENTO_CODIGO ||
                                    P_CON_CONHECIMENTO_SERIE || p_GLB_ROTA_CODIGO ||
                                    ' ERRO - ' || SQLERRM);
        END;

        vDeixaTirarImpressao := 'N';

--        V_TEXTO := 'ALTER TRIGGER TG_CON_CONHECIMENTO ENABLE';
--        EXECUTE IMMEDIATE (V_TEXTO);
--        V_TEXTO := 'ALTER TRIGGER TG_CON_CONHECIMENTOB ENABLE';
--        EXECUTE IMMEDIATE (V_TEXTO);
        COMMIT;
  
  END SP_CON_RETIRAIMPRESSAO;

   PROCEDURE SP_CON_CANCELACONHECIMENTO(P_CTRC                IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                        P_SERIE               IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                        P_ROTA                IN TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                        P_USUARIO             IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                        P_MOTIVO_CANCELAMENTO IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_CODIGO%TYPE,
                                        P_MOTIVO_DESC         IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_DESC%TYPE,
                                        P_PARAMETROS          IN CHAR DEFAULT 'carreg',
                                        P_STATUS              OUT CHAR,
                                        P_MESSAGEM            OUT VARCHAR2) IS
    
    /*Contador que faz varios count para verificar existencia de registros na tabela*/
    V_CONTADOR                  INTEGER;

    /*Armazena o proximo numero de conhecimento "XXX" trazendo a sequence*/
    V_NRCTRC                    T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;

    /*FLAG QUE ARMAZENA "S" OU "N" PARA VER SE EXCLUI O CTRC OU  SIMPLESMENTE COPIA CANCELANDO*/
    V_FLAG                      T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_FISICO%TYPE;

    /*Numero do formulario*/
    V_NR_FORMULARIO             T_CON_CONHECIMENTO.CON_CONHECIMENTO_NRFORMULARIO%TYPE;

    /*Armazena o motivo do cancelamento*/
    V_MOTIVO_CANCELAMENTO       TDVADM.T_CON_CONHECCANCEL.CON_CONHECCANCEL_OUTROS%TYPE;

    V_CTRCXML                   INTEGER;
    V_DTEMBARQUE                T_CON_CONHECIMENTO.CON_CONHECIMENTO_DTEMBARQUE%TYPE;

    --Variáveis utilizadas para auxiliar a procedure de limpeza de imagem.
    vStatus                     char(1):= '';
    vMessage                    Varchar2(32000):= '';
     /***********************************************
          12/04/2021 - LUCAS DOS SANTOS
          INCLUIDO A VALIDAÇÃO DE CTE FATURADO E 
          CONTABILIZADO.        
      ***********************************************/
    V_CTB                        char(1); -- variavel para indentificar contabilização.
    V_FATURADO                   char(1); --variavel para verificar se esta contabilizado.
    
  begin

    BEGIN
      
      
        /************************************/
        /* PEGO A DATA DE EMBARQUE          */
        /************************************/
        /***********************************************
          12/04/2021 - LUCAS DOS SANTOS
          INCLUIDO A VALIDAÇÃO DE CTE FATURADO E 
          CONTABILIZADO.        
        ***********************************************/
        
        
        BEGIN
             SELECT NVL(TRUNC(CC.CON_CONHECIMENTO_DTEMBARQUE),TRUNC(SYSDATE)),
                    DECODE (NVL (CC.Con_Fatura_Codigo,'000000'),'000000','N','S'),
                    DECODE (NVL (CT.CON_CONHECIMENTO_CODIGO,'000000'),'000000','N','S')
               INTO V_DTEMBARQUE, 
                    V_FATURADO,
                    V_CTB
               FROM TDVADM.T_CON_CONHECIMENTO CC,
                    TDVADM.T_CON_CONHECCTB CT                   
              WHERE CC.CON_CONHECIMENTO_CODIGO       = P_CTRC
                AND Trim(CC.CON_CONHECIMENTO_SERIE)  = P_SERIE
                AND CC.GLB_ROTA_CODIGO               = P_ROTA
                AND CC.CON_CONHECIMENTO_CODIGO       = CT.CON_CONHECIMENTO_CODIGO (+)
                AND CC.CON_CONHECIMENTO_SERIE        = CT.CON_CONHECIMENTO_SERIE (+)
                AND CC.GLB_ROTA_CODIGO               = CT.GLB_ROTA_CODIGO (+);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             P_STATUS:= 'E';
             P_MESSAGEM:= 'CTE NAO EXISTE!';
             V_DTEMBARQUE := TRUNC(SYSDATE);
        END;
        if P_STATUS!= 'N' THEN
           Return;
        End if;
        --Verificar se o mesmo esta faturado.
        IF V_FATURADO = 'S' THEN
           P_STATUS:= 'E';
           P_MESSAGEM:= 'CTE FATURADO IMPOSSIVEL PROSSEGUIR';
        END IF;
        --Verificar se o mesmo esta contabilizado.
        IF V_CTB = 'S' THEN
           P_STATUS:= 'E';
           P_MESSAGEM:= 'CTE CONTABILIZADO IMPOSSIVEL PROSSEGUIR';
        END IF;
        if P_STATUS!= 'N' THEN
           Return;
        End if;
        
        /*  FIM 12/04/2021 - LUCAS */
                   
       /******************************************************************/
       /** Setando para ocorrencia 99 nas coletas que compoem o CTe     **/
       /******************************************************************/
       begin
         
         pkg_arm_gercoleta.sp_set_limpaocorrenciaCte(P_CTRC, 
                                                     P_SERIE, 
                                                     P_ROTA, 
                                                     '99', 
                                                     vStatus, 
                                                     vMessage);
       end;
       /******************************************************************/
       /******************************************************************/
       /******************************************************************/   
        
        
        
      /***************************************************/
      /*Pega o numero do formulario atual do conhecimento*/
      /***************************************************/
      SELECT CO.CON_CONHECIMENTO_NRFORMULARIO
        INTO V_NR_FORMULARIO
        FROM T_CON_CONHECIMENTO CO
       WHERE CO.CON_CONHECIMENTO_CODIGO = P_CTRC
         AND Trim(CO.CON_CONHECIMENTO_SERIE) = P_SERIE
         AND CO.GLB_ROTA_CODIGO = P_ROTA;

      /*****************************************************/
      /*Pega a flag pera verificar se saiu no fisico ou não*/
      /*****************************************************/
      BEGIN
        SELECT M.CON_CONHECCANCELMOTIVO_FISICO
          INTO V_FLAG
          FROM T_CON_CONHECCANCELMOTIVO M
         WHERE M.CON_CONHECCANCELMOTIVO_CODIGO = P_MOTIVO_CANCELAMENTO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  'Não foi identificado o motivo do cancelamento');
      END;

      /******************************************************/
      /*Pega o proximo sa sequence de nr de conhecimento XXX*/
      /******************************************************/
      SELECT CON_SEQCONHECIMENTO_CODIGO.NEXTVAL 
        INTO V_NRCTRC 
        FROM DUAL;

      /***************************************************************************/
      /*** Insere em todas as tabelas de conhecimentos uma copia com serie XXX ***/
      /***************************************************************************/
      INSERT INTO T_CON_CONHECIMENTO
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGO,
         GLB_ROTA_CODIGOPROGCARGADET,
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
         CON_CONHECIMENTO_DTENVSEG,
         CON_CONHECIMENTO_DTENVEDI,
         CON_CONHECIMENTO_OBSLEI,
         CON_CONHECIMENTO_OBSCLIENTE,
         GLB_ROTA_CODIGORECEITA,
         CON_CONHECIMENTO_DTNFE,
         CON_CONHECIMENTO_DTCHECKIN,
         CON_CONHECIMENTO_DTGRAVCHECKIN,
         ARM_CARREGAMENTO_CODIGO)
        SELECT V_NRCTRC,
               'XXX',
               P_ROTA,
               GLB_ROTA_CODIGOPROGCARGADET,
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
               SUBSTR(CON_CONHECIMENTO_OBS, 1, 2000),
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
               NULL,
               NULL,
               NULL,
               NULL,
               GLB_GERRISCO_CODIGO,
               CON_CONHECIMENTO_CODLIBERACAO,
               CON_CONHECIMENTO_AUTORISEG,
               CON_CONHECIMENTO_DTRECEBIMENTO,
               CON_CONHECIMENTO_DTCHEGCELULA,
               ARM_COLETA_NCOMPRA,
               arm_coleta_ciclo,
               CON_CONHECIMENTO_DTENVSEG,
               CON_CONHECIMENTO_DTENVEDI,
               CON_CONHECIMENTO_OBSLEI,
               CON_CONHECIMENTO_OBSCLIENTE,
               GLB_ROTA_CODIGORECEITA,
               CON_CONHECIMENTO_DTNFE,
               CON_CONHECIMENTO_DTCHECKIN,
               CON_CONHECIMENTO_DTGRAVCHECKIN,
               ARM_CARREGAMENTO_CODIGO
          FROM T_CON_CONHECIMENTO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND Trim(CON_CONHECIMENTO_SERIE) = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

      INSERT INTO T_CON_NFTRANSPORTA
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
         GLB_CFOP_CODIGO,
         CON_NFTRANSPORTADA_VALORBSICMS,
         CON_NFTRANSPORTADA_VALORICMS,
         CON_NFTRANSPORTADA_VLBSICMSST,
         CON_NFTRANSPORTADA_VLICMSST,
         CON_NFTRANSPORTADA_CHAVENFE,
         CON_TPDOC_CODIGO,
         CON_NFTRANSPORTADA_DTEMISSAO,
         CON_NFTRANSPORTADA_DTSAIDA,
         CON_NFTRANSPORTADA_SERIENF,
         GLB_ONU_CODIGO,
         GLB_ONU_GRPEMB)
        SELECT V_NRCTRC,
               'XXX',
               P_ROTA,
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
               GLB_CFOP_CODIGO,
               CON_NFTRANSPORTADA_VALORBSICMS,
               CON_NFTRANSPORTADA_VALORICMS,
               CON_NFTRANSPORTADA_VLBSICMSST,
               CON_NFTRANSPORTADA_VLICMSST,
               CON_NFTRANSPORTADA_CHAVENFE,
               CON_TPDOC_CODIGO,
               CON_NFTRANSPORTADA_DTEMISSAO,
               CON_NFTRANSPORTADA_DTSAIDA,
               CON_NFTRANSPORTADA_SERIENF,
               GLB_ONU_CODIGO,
               GLB_ONU_GRPEMB
          FROM T_CON_NFTRANSPORTA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND Trim(CON_CONHECIMENTO_SERIE) = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

      INSERT INTO T_CON_NFTRANSPORTAEXTRA
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGO,
         CON_NFTRANSPORTADA_NUMNFISCAL,
         GLB_EMBALAGEM_CODIGO,
         CON_NFTTRANSPORTA_MERCADORIA,
         CON_NFTRANSPORTA_DTEMISSAO,
         CON_NFTRANSPORTA_DATA2,
         CON_NFTRANSPORTA_STRING1,
         CON_NFTRANSPORTA_STRING2,
         CON_NFTRANSPORTA_STRING3,
         CON_NFTRANSPORTA_STRING4,
         CON_NFTRANSPORTA_NUMBER1,
         CON_NFTRANSPORTA_NUMBER2,
         CON_NFTRANSPORTA_NUMBER3,
         CON_NFTRANSPORTA_NUMBER4,
         CON_NFTRANSPORTA_SERIE,
         CON_NFTRANSPORTA_DATA1,
         GLB_ONU_CODIGO,
         GLB_ONU_GRPEMB)
         SELECT V_NRCTRC,
                'XXX',
                P_ROTA,
                CON_NFTRANSPORTADA_NUMNFISCAL,
                GLB_EMBALAGEM_CODIGO,
                CON_NFTTRANSPORTA_MERCADORIA,
                CON_NFTRANSPORTA_DTEMISSAO,
                CON_NFTRANSPORTA_DATA2,
                CON_NFTRANSPORTA_STRING1,
                CON_NFTRANSPORTA_STRING2,
                CON_NFTRANSPORTA_STRING3,
                CON_NFTRANSPORTA_STRING4,
                CON_NFTRANSPORTA_NUMBER1,
                CON_NFTRANSPORTA_NUMBER2,
                CON_NFTRANSPORTA_NUMBER3,
                CON_NFTRANSPORTA_NUMBER4,
                CON_NFTRANSPORTA_SERIE,
                CON_NFTRANSPORTA_DATA1,
                GLB_ONU_CODIGO,
                GLB_ONU_GRPEMB
           FROM T_CON_NFTRANSPORTAEXTRA
          WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
            AND Trim(CON_CONHECIMENTO_SERIE)  = P_SERIE
            AND GLB_ROTA_CODIGO         = P_ROTA;

      INSERT INTO T_CON_CONHECFATURADO
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGOCONHEC,
         CON_FATURA_CODIGO,
         CON_FATURA_CICLO,
         GLB_ROTA_CODIGOFILIALIMP,
         GLB_ROTA_CODIGOTITREC,
         CRP_TITRECEBER_NUMTITULO,
         CRP_TITRECEBER_SAQUE,
         CON_CONHECIMENTO_DTEMBARQUE,
         CON_CONHECIMENTO_VALOR,
         CON_CONHECIMENTO_CGCCPFSACADO,
         CON_CONHECFATURADO_PAGO,
         CON_CONHECFATURADO_COMPROVANTE,
         CON_CONHECFATURADO_VALORPAGO,
         CON_CONHECFATURADO_DTBAIXA,
         CON_CONHECFATURADO_DESCONTO,
         CON_CONHECFATURADO_VLRACRES,
         CON_CONHECFATURADO_DESPCART,
         CON_CONHECFATURADO_DESPJUROS,
         CON_CONHECFATURADO_DESPOUTROS)
        SELECT V_NRCTRC,
               'XXX',
               P_ROTA,
               CON_FATURA_CODIGO,
               CON_FATURA_CICLO,
               GLB_ROTA_CODIGOFILIALIMP,
               GLB_ROTA_CODIGOTITREC,
               CRP_TITRECEBER_NUMTITULO,
               CRP_TITRECEBER_SAQUE,
               CON_CONHECIMENTO_DTEMBARQUE,
               CON_CONHECIMENTO_VALOR,
               CON_CONHECIMENTO_CGCCPFSACADO,
               CON_CONHECFATURADO_PAGO,
               CON_CONHECFATURADO_COMPROVANTE,
               CON_CONHECFATURADO_VALORPAGO,
               CON_CONHECFATURADO_DTBAIXA,
               CON_CONHECFATURADO_DESCONTO,
               CON_CONHECFATURADO_VLRACRES,
               CON_CONHECFATURADO_DESPCART,
               CON_CONHECFATURADO_DESPJUROS,
               CON_CONHECFATURADO_DESPOUTROS
          FROM T_CON_CONHECFATURADO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND Trim(CON_CONHECIMENTO_SERIE) = P_SERIE
           AND GLB_ROTA_CODIGOCONHEC = P_ROTA;

      INSERT INTO T_CON_NFFATURADA
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGOCONHEC,
         CON_FATURA_CODIGO,
         CON_FATURA_CICLO,
         GLB_ROTA_CODIGOFILIALIMP,
         GLB_ROTA_CODIGOTITREC,
         CRP_TITRECEBER_NUMTITULO,
         CRP_TITRECEBER_SAQUE,
         GLB_ROTA_CODIGO,
         CON_NFTRANSPORTADA_NUMNFISCAL,
         GLB_EMBALAGEM_CODIGO,
         CON_NFTTRANSPORTA_MERCADORIA,
         CON_NFFATURADA_PAGO,
         CON_NFFATURADA_VALOR,
         CON_NFFATURADA_VALORPAGO,
         CON_NFFATURADA_PESO,
         CON_NFFATURADA_JUROS,
         CON_NFFATURADA_DTBAIXA,
         CON_NFFATURADA_DESCONTO,
         CON_NFFATURADA_VLRACRES,
         CON_NFFATURADA_DESPCART,
         CON_NFFATURADA_DESPOUTROS)
        SELECT V_NRCTRC,
               'XXX',
               P_ROTA,
               CON_FATURA_CODIGO,
               CON_FATURA_CICLO,
               GLB_ROTA_CODIGOFILIALIMP,
               GLB_ROTA_CODIGOTITREC,
               CRP_TITRECEBER_NUMTITULO,
               CRP_TITRECEBER_SAQUE,
               GLB_ROTA_CODIGO,
               CON_NFTRANSPORTADA_NUMNFISCAL,
               GLB_EMBALAGEM_CODIGO,
               CON_NFTTRANSPORTA_MERCADORIA,
               CON_NFFATURADA_PAGO,
               CON_NFFATURADA_VALOR,
               CON_NFFATURADA_VALORPAGO,
               CON_NFFATURADA_PESO,
               CON_NFFATURADA_JUROS,
               CON_NFFATURADA_DTBAIXA,
               CON_NFFATURADA_DESCONTO,
               CON_NFFATURADA_VLRACRES,
               CON_NFFATURADA_DESPCART,
               CON_NFFATURADA_DESPOUTROS
          FROM T_CON_NFFATURADA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND Trim(CON_CONHECIMENTO_SERIE) = P_SERIE
           AND GLB_ROTA_CODIGOCONHEC = P_ROTA;

      INSERT INTO T_CON_HISTCONHECFATURADO
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGO,
         CRP_TITRECEBER_SAQUE,
         CRP_TITRECEBER_NUMTITULO,
         GLB_ROTA_CODIGOTITREC,
         CON_FATURA_CICLO,
         CON_FATURA_CODIGO,
         GLB_ROTA_CODIGOFILIALIMP,
         CON_HISTCONHECFATURADO_SEQ,
         CON_HISTCONHECFATURADO_DTBAIXA,
         CON_HISTCONHECFATURADO_VALORPA,
         CON_HISTCONHECFATURADO_DESCONT,
         CON_HISTCONHECFATURADO_VLRACRE,
         CON_HISTCONHECFATURADO_DESPCAR,
         CON_HISTCONHECFATURADO_DESPJUR,
         CON_HISTCONHECFATURADO_DESPOUT)
        SELECT V_NRCTRC,
               'XXX',
               P_ROTA,
               CRP_TITRECEBER_SAQUE,
               CRP_TITRECEBER_NUMTITULO,
               GLB_ROTA_CODIGOTITREC,
               CON_FATURA_CICLO,
               CON_FATURA_CODIGO,
               GLB_ROTA_CODIGOFILIALIMP,
               CON_HISTCONHECFATURADO_SEQ,
               CON_HISTCONHECFATURADO_DTBAIXA,
               CON_HISTCONHECFATURADO_VALORPA,
               CON_HISTCONHECFATURADO_DESCONT,
               CON_HISTCONHECFATURADO_VLRACRE,
               CON_HISTCONHECFATURADO_DESPCAR,
               CON_HISTCONHECFATURADO_DESPJUR,
               CON_HISTCONHECFATURADO_DESPOUT
          FROM T_CON_HISTCONHECFATURADO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

      INSERT INTO T_CON_CALCCONHECIMENTO
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGO,
         SLF_RECCUST_CODIGO,
         SLF_TPCALCULO_CODIGO,
         GLB_MOEDA_CODIGO,
         CON_CALCVIAGEM_DESINENCIA,
         CON_CALCVIAGEM_REEMBOLSO,
         CON_CALCVIAGEM_VALOR,
         CON_CALCVIAGEM_TPRATEIO,
         CON_CONHECIMENTO_DTEMBARQUE,
         CON_CONHECIMENTO_ALTALTMAN,
         GLB_ROTA_CODIGOGENERICO)
        (SELECT V_NRCTRC,
                'XXX',
                P_ROTA,
                SLF_RECCUST_CODIGO,
                SLF_TPCALCULO_CODIGO,
                GLB_MOEDA_CODIGO,
                CON_CALCVIAGEM_DESINENCIA,
                CON_CALCVIAGEM_REEMBOLSO,
                CON_CALCVIAGEM_VALOR,
                CON_CALCVIAGEM_TPRATEIO,
                CON_CONHECIMENTO_DTEMBARQUE,
                CON_CONHECIMENTO_ALTALTMAN,
                GLB_ROTA_CODIGOGENERICO
           FROM T_CON_CALCCONHECIMENTO
          WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
            AND CON_CONHECIMENTO_SERIE = P_SERIE
            AND GLB_ROTA_CODIGO = P_ROTA);

      INSERT INTO T_CON_HISTNFFATURADA
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGOCONHEC,
         CON_NFTRANSPORTADA_NUMNFISCAL,
         GLB_EMBALAGEM_CODIGO,
         CON_NFTTRANSPORTA_MERCADORIA,
         CRP_TITRECEBER_SAQUE,
         CRP_TITRECEBER_NUMTITULO,
         GLB_ROTA_CODIGOTITREC,
         GLB_ROTA_CODIGOFILIALIMP,
         CON_FATURA_CODIGO,
         CON_FATURA_CICLO,
         CON_HISTNFFATURADA_SEQ,
         CON_HISTNFFATURADA_DTBAIXA,
         CON_HISTNFFATURADA_VALORPAGO,
         CON_HISTNFFATURADA_DESCONTO,
         CON_HISTNFFATURADA_VLRACRES,
         CON_HISTNFFATURADA_DESPCART,
         CON_HISTNFFATURADA_DESPOUTROS)
        SELECT V_NRCTRC,
               'XXX',
               P_ROTA,
               CON_NFTRANSPORTADA_NUMNFISCAL,
               GLB_EMBALAGEM_CODIGO,
               CON_NFTTRANSPORTA_MERCADORIA,
               CRP_TITRECEBER_SAQUE,
               CRP_TITRECEBER_NUMTITULO,
               GLB_ROTA_CODIGOTITREC,
               GLB_ROTA_CODIGOFILIALIMP,
               CON_FATURA_CODIGO,
               CON_FATURA_CICLO,
               CON_HISTNFFATURADA_SEQ,
               CON_HISTNFFATURADA_DTBAIXA,
               CON_HISTNFFATURADA_VALORPAGO,
               CON_HISTNFFATURADA_DESCONTO,
               CON_HISTNFFATURADA_VLRACRES,
               CON_HISTNFFATURADA_DESPCART,
               CON_HISTNFFATURADA_DESPOUTROS
          FROM T_CON_HISTNFFATURADA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGOCONHEC = P_ROTA;

      INSERT INTO T_CON_CONHECIMENTOREGESP(
             CON_CONHECIMENTO_CODIGO,
             CON_CONHECIMENTO_SERIE,
             GLB_ROTA_CODIGO,
             CON_CONHECIMENTOREGESP_DATA,
             CON_CONHECIMENTOREGESP_CODIGO)
             SELECT V_NRCTRC,
                    'XXX',
                    P_ROTA,
                    CON_CONHECIMENTOREGESP_DATA,
                    CON_CONHECIMENTOREGESP_CODIGO
               FROM T_CON_CONHECIMENTOREGESP
              WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
                AND CON_CONHECIMENTO_SERIE  = P_SERIE
                AND GLB_ROTA_CODIGO         = P_ROTA;
             
      UPDATE T_ARM_MOVIMENTO MO
         SET MO.CON_CONHECIMENTO_NUMERO = NULL,
             MO.CON_CONHECIMENTO_SERIE  = NULL,
             MO.CON_CONHECIMENTO_CODIGO = NULL,
             MO.CON_CONHECIMENTO_SERIE2 = NULL,
             MO.GLB_ROTA_CONHECIMENTO   = NULL
       WHERE MO.CON_CONHECIMENTO_CODIGO = P_CTRC
         AND MO.CON_CONHECIMENTO_SERIE2 = P_SERIE
         AND MO.GLB_ROTA_CONHECIMENTO = P_ROTA;

      /**************************************************************************************/
      /*Retira o Número do Conhecimento da Série A1, e atualiza para o Novo CTRC "Série XXX"*/
      /**************************************************************************************/
      UPDATE T_ARM_NOTA
         SET CON_CONHECIMENTO_SERIE  = 'XXX',
             GLB_ROTA_CODIGO         = P_ROTA,
             CON_CONHECIMENTO_CODIGO = V_NRCTRC
       WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
         AND CON_CONHECIMENTO_SERIE  = P_SERIE
         AND GLB_ROTA_CODIGO         = P_ROTA;

      
      UPDATE T_ARM_NOTACTE
         SET CON_CONHECIMENTO_SERIE  = 'XXX',
             GLB_ROTA_CODIGO         = P_ROTA,
             CON_CONHECIMENTO_CODIGO = V_NRCTRC
       WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
         AND CON_CONHECIMENTO_SERIE  = P_SERIE
         AND GLB_ROTA_CODIGO         = P_ROTA;
      
      



      /*********************************************************/
      /*Verifica a flag se o conhecimento saiu no fisico ou não*/
      /*********************************************************/
      IF (V_FLAG) = 'S' THEN

        UPDATE T_CON_CONHECIMENTO A
           SET A.CON_CONHECIMENTO_FLAGCANCELADO = 'S'
         WHERE A.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND A.CON_CONHECIMENTO_SERIE = P_SERIE
           AND A.GLB_ROTA_CODIGO = P_ROTA;
           
           

        UPDATE T_CON_CALCCONHECIMENTO
           SET CON_CALCVIAGEM_VALOR = 0
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

      ELSIF (V_FLAG) = 'N' THEN

        DELETE T_UTI_LOGCTE CT
         WHERE CT.UTI_LOGCTE_CODIGO       = P_CTRC
           AND CT.UTI_LOGCTE_SERIE        = P_SERIE
           AND CT.UTI_LOGCTE_ROTA_CODIGO  = P_ROTA;

        DELETE T_CON_CONTROLECTRCE CT
         WHERE CT.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CT.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND CT.GLB_ROTA_CODIGO         = P_ROTA;

       DELETE WSERVICE.T_WSD_XMLNFSE F
         WHERE F.CON_CONHECIMENTO_CODIGO  = P_CTRC
           AND F.CON_CONHECIMENTO_SERIE   = P_SERIE
           AND F.GLB_ROTA_CODIGO          = P_ROTA;
           
       DELETE  T_CON_CONHECSUBST CS
         WHERE CS.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CS.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND CS.GLB_ROTA_CODIGO         = P_ROTA;    

        DELETE T_CON_CONHECVPED V
         WHERE V.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND V.CON_CONHECIMENTO_SERIE = P_SERIE
           AND V.GLB_ROTA_CODIGO = P_ROTA;

        DELETE T_CON_HISTNFFATURADA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGOCONHEC = P_ROTA;

        DELETE T_CON_HISTCONHECFATURADO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

        DELETE T_CON_NFFATURADA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGOCONHEC = P_ROTA;

        DELETE T_CON_CONHECFATURADO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGOCONHEC = P_ROTA;

        DELETE T_CON_NFTRANSPORTA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

           DELETE T_CON_NFTRANSPORTAEXTRA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

        DELETE T_CON_CALCCONHECIMENTO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;

        DELETE T_CON_LOGGERACAO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;

        DELETE T_CON_CONSIGREDESPACHO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;

        DELETE T_CON_CONHECIMENTOREGESP
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;
        
        DELETE T_CON_CONHECCOMPLEMENTO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;

        DELETE T_CON_CONHECCFOP
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;
           
         DELETE T_CON_CONHECANULA
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;
           
        DELETE T_CON_CONHECSUBST
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;  
           
        DELETE T_CON_EVENTOCTE     
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;  
        
        DELETE T_CON_VEICCONHEC
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;      
           

        DELETE T_CON_CONHECIMENTO
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE  = P_SERIE
           AND GLB_ROTA_CODIGO         = P_ROTA;

      ELSE
        RAISE_APPLICATION_ERROR(-20001,
                                chr(13) ||
                                'N?o foi possivel identificar o tipo de cancelamento escolhido!');
      END IF;

      /***************************************************************/
      /*Verica se o motivo de cancelamento escolhido exige Observação*/
      /***************************************************************/
      BEGIN
        SELECT COUNT(*)
          INTO V_CONTADOR
          FROM T_CON_CONHECCANCELMOTIVO MO
         WHERE MO.CON_CONHECCANCELMOTIVO_CODIGO = P_MOTIVO_CANCELAMENTO
           AND MO.CON_CONHECCANCELMOTIVO_EXIGOBS = 'S';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_CONTADOR := 0;
      END;

      IF V_CONTADOR = 0 THEN
        V_MOTIVO_CANCELAMENTO := '';
      ELSE
        V_MOTIVO_CANCELAMENTO := P_MOTIVO_DESC;
      END IF;

      SP_CON_RETIRAIMPRESSAO(V_NRCTRC, 'XXX', P_ROTA);

      SELECT COUNT(*)
          INTO V_CTRCXML
          FROM T_XML_CTRC C
         WHERE C.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND C.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND C.GLB_ROTA_CODIGO         = P_ROTA
           AND C.XML_CTRC_GRAVADO        = 'TDV';

      IF V_CTRCXML > 0 THEN
        UPDATE T_XML_CTRC CC
           SET CC.XML_CTRC_FLAGCANCEL = 'S',
               CC.XML_CTRC_DATACANCEL = SYSDATE
         WHERE CC.CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CC.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND CC.GLB_ROTA_CODIGO         = P_ROTA
           AND CC.XML_CTRC_GRAVADO        = 'TDV';
      END IF;

      Update T_CON_CONHECCTB
         Set CON_CONHECCTB_FLAGCANCELADO = 'S'
         WHERE CON_CONHECIMENTO_CODIGO = P_CTRC
           AND CON_CONHECIMENTO_SERIE = P_SERIE
           AND GLB_ROTA_CODIGO = P_ROTA;

      INSERT INTO T_CON_CONHECCANCEL
        (CON_CONHECIMENTO_CODIGO,
         CON_CONHECIMENTO_SERIE,
         GLB_ROTA_CODIGO,
         CON_CONHECCANCEL_NRVEZES,
         CON_CONHECCANCELMOTIVO_CODIGO,
         CON_CONHECCANCEL_DATA,
         USU_USUARIO_CODIGO,
         CON_CONHECCANCEL_OUTROS,
         CON_CONHECIMENTO_NRFORMULARIO,
         con_conheccancel_dataemb
         )
      VALUES
        (P_CTRC,
         P_SERIE,
         P_ROTA,
         (SELECT COUNT(*) + 1h
            FROM T_CON_CONHECCANCEL CC
           WHERE CC.CON_CONHECIMENTO_CODIGO = P_CTRC
             AND CC.CON_CONHECIMENTO_SERIE = P_SERIE
             AND CC.GLB_ROTA_CODIGO = P_ROTA),
         P_MOTIVO_CANCELAMENTO,
         SYSDATE,
         P_USUARIO,
         V_MOTIVO_CANCELAMENTO||' - Documento é um CTe.',
         V_NR_FORMULARIO,
         V_DTEMBARQUE);
      
      commit;

       --Rogerio dia 01/06/2011
       --Para rodar essa procedure o CTRC deve ter sido cancelado,com motivo de cancelamento FÍSICO
       --Excluo o Registro de arquivamento da Imagem "T_GLB_COMPIMAGEM, Limpo os flags de controle de criação de imagem de CTRC

      If (V_FLAG = 'N') Then
         
         pkg_con_ctrc.sp_con_limpaImg( P_CTRC, P_ROTA, P_SERIE, vStatus, vMessage );

         --Caso o vStatus retorno como 'E (Erro', quer dizer que não consegui completar o processo.
         If (vStatus = 'E') Then
           raise_application_error(-20001, chr(13)||vMessage);
         End If;

       End  If;
       

       
       

      P_STATUS   := pkg_glb_common.Status_Nomal;  
      P_MESSAGEM := 'Processamento Normal';
       

    EXCEPTION WHEN OTHERS THEN
      P_STATUS   := pkg_glb_common.Status_Erro;  
      P_MESSAGEM := 'Erro ao executar PKG_CON_CTRC.SP_CON_CANCELACONHECIMENTO. Erro: '||sqlerrm||' - '||dbms_utility.format_error_backtrace;
      rollback;
    END;  

  END SP_CON_CANCELACONHECIMENTO;
   
   PROCEDURE SP_CARREG_CONHECCANCELV200(P_CTRC                IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                        P_SERIE               IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                        P_ROTA                IN TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                        P_USUARIO             IN TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                        P_MOTIVO_CANCELAMENTO IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_CODIGO%TYPE,
                                        P_MOTIVO_DESC         IN TDVADM.T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_DESC%TYPE,
                                        P_PARAMETROS          IN CHAR DEFAULT 'comcanconh') IS
    /**********************************************************************************************
     * ROTINA           : SP_CARREG_CONHECCANCELV200                                              *
     * PROGRAMA         : Cancelamento de conhecimento                                            *
     * ANALISTA         : Porpeta                                                                 *
     * DESENVOLVEDOR    : Porpeta                                                                 *
     * DATA DE CRIACAO  : 20/10/2009                                                              *
     * BANCO            : ORACLE-TDP                                                              *
     * EXECUTADO POR    : prj_carregamento.exe, prj_conheccancel.exe                              *
     * FUNCINALIDADE    : Rotina responsavel por cancelar o conhecimento passado como parametro   *
     * PARTICULARIDADES : Tanto pode cancelar um conhecimento, como dizer que ele não saiu        *
     *                     no fisico e o mesmo ser excluido                                       *
     * PARAM. OBRIGAT.  : Todos                                                                   *
     **********************************************************************************************/

    /*Contador que faz varios count para verificar existencia de registros na tabela*/
    vContadorCteExiste                 integer;
    vContadorVFExiste                  integer;
    vContadorExisteCold                integer;
    vContadorExisteMdfe                integer;
    vFlag                              T_CON_CONHECCANCELMOTIVO.CON_CONHECCANCELMOTIVO_FISICO%TYPE; /*FLAG QUE ARMAZENA "S" OU "N" PARA VER SE EXCLUI O CTRC OU  SIMPLESMENTE COPIA CANCELANDO*/
    vEviaDocEletronico                 t_con_conhecimento.con_conhecimento_enviaele%type;
    /*Armazena o Numero do valefrete rota caso exista um valefrete gerado para o conhecimento para informa o usuario*/
    vValeFrete                         T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE;
    vRotaValeFrete                     T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE;

    /*Variavel que armazena o numero de fatura caso o conhecimento ja esteje faturado*/
    vFatura                            T_CON_CONHECIMENTO.CON_FATURA_CODIGO%TYPE;

    /*Rota de Cte*/
    vRotaCte                           T_GLB_ROTA.GLB_ROTA_CTE%TYPE;
    vRotaNfse                          T_GLB_ROTA.GLB_ROTA_CTE%TYPE;
    
    /*Codigo de mensagem de retorno da Sefaz*/
    vMsgCte                            T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CODSTENV%TYPE;

    /*Data de autorização do Cte*/
    vDataAut                           T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_DTRETORNO%TYPE;

    vDataDeEmbarque                    T_CON_CONHECIMENTO.CON_CONHECIMENTO_DTEMBARQUE%TYPE;

    --Variáveis utilizadas para auxiliar a procedure de limpeza de imagem.
    vStatus                            Char(1):= '';
    vMessage                           Varchar2(32000):= '';
    vExisteNaoGerado                   INTEGER :=0;
    vSeqEvento                         integer :=0;
    vExisteEvento                      integer :=0;
    vCodLiberado                       CHAR(1);
    vMsgSEFAZ                          T_GLB_CTEMSNGRET.GLB_CTEMSGRET_DESCRICAO%TYPE;
    vCarregamento                      T_Con_Conhecimento.Arm_Carregamento_Codigo%type;
  BEGIN
        /************************************/
        /* SE CTE EXISTE                    */
        /************************************/
        begin

          begin
            select count(*)
              into vContadorCteExiste
              from t_con_conhecimento co
             where co.con_conhecimento_codigo        = p_ctrc
               and trim(co.con_conhecimento_serie)   = p_serie
               and co.glb_rota_codigo                = p_rota;
          exception
            when no_data_found then
              vContadorCteExiste := -1;
          end;

          if vContadorCteExiste <= 0 then
            raise_application_error(-20001,'Não existe o conhecimento que voce esta tentando cancelar!'   ||chr(13) ||
                                           'CTe - ' || P_CTRC || ' Serie - ' || P_SERIE || ' Rota - ' || P_ROTA  ||CHR(13) || '-' || 
                                           TO_CHAR(vContadorCteExiste) ||CHR(13) || SQLERRM);
          else
            
            select ch.arm_carregamento_codigo
              into vCarregamento
              from t_con_conhecimento ch
             where ch.con_conhecimento_codigo = p_ctrc
               and ch.con_conhecimento_serie  = p_serie 
               and ch.glb_rota_codigo         = p_rota;
           
            
            if ( (vCarregamento is not null) and (P_PARAMETROS = 'comcanconh') ) THEN
              
               raise_application_error(-20001,'Conhecimento tem carregamento só pode ser cancelado pelo FIFO|||');

            end if;      
               
          end if;

        end;

        /************************************/
        /* PEGO A DATA DE EMBARQUE          */
        /************************************/
        begin
             select nvl(trunc(cc.con_conhecimento_dtembarque),trunc(sysdate)),
                    NVL(cc.con_conhecimento_enviaele,'N')
               into vDataDeEmbarque,
                    vEviaDocEletronico
               from t_con_conhecimento cc
              where cc.con_conhecimento_codigo       = p_ctrc
                and trim(cc.con_conhecimento_serie)  = p_serie
                and cc.glb_rota_codigo               = p_rota;
        exception
          when no_data_found then
               vDataDeEmbarque := trunc(sysdate);
        end;

        /************************************/
        /* FECHAMENTO CONTABIL              */
        /************************************/
        begin
          
          if f_verificafechamento(nvl(vdatadeembarque,sysdate),'CON') = 'S' then

             raise_application_error(-20001,'Sistema de Conhecimento / Nota Fiscal de serviço bloqueado para alterações no mês '|| to_char(vDataDeEmbarque,'MM/YYYY')||' Procure a gerência ADM!');

          end if;
        
        end;
        
        /************************************/
        /* VERIFICAÇÃO DO VALE FRETE        */
        /************************************/
        begin

          vValeFrete      := '';
          vRotaValeFrete  := '';

          BEGIN

            select b.con_conhecimento_codigo,
                   b.glb_rota_codigo
              into vValeFrete,
                   vRotaValeFrete
              from t_con_vfreteconhec a,
                   t_con_valefrete b
             where a.con_conhecimento_codigo      = p_ctrc
               and trim(a.con_conhecimento_serie) = p_serie
               and a.glb_rota_codigo              = p_rota
               and a.con_valefrete_codigo         = b.con_conhecimento_codigo
               and trim(a.con_valefrete_serie)    = b.con_conhecimento_serie
               and a.glb_rota_codigovalefrete     = b.glb_rota_codigo
               and a.con_valefrete_saque          = b.con_valefrete_saque
               and NVL(TRIM(b.con_valefrete_status),'N') = 'N';

            vContadorVFExiste := 1;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              vContadorVFExiste := 0;

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20001,
                                    chr(13) ||
                                    'Existem valefres gerados para esse conhecimento' ||
                                    chr(13) || 'Valefrete: ' || vValeFrete || '' ||
                                    CHR(13) || 'Rota: ' || vRotaValeFrete);
          END;

          IF vContadorVFExiste > 0 THEN
             RAISE_APPLICATION_ERROR(-20001,
                                     chr(13) ||
                                     'Ja existe um valefre gerado para esse conhecimento' ||
                                     chr(13) || 'Valefrete: ' || vValeFrete || '' ||
                                     CHR(13) || 'Rota: ' || vRotaValeFrete);
          END IF;

        end;
        
        /************************************/
        /* VERIFICO O MOTIVO DE REJEIÇÃO    */
        /************************************/                    
        begin

          begin
            select m.con_conheccancelmotivo_fisico
              into vFlag
              from t_con_conheccancelmotivo m
             where m.con_conheccancelmotivo_codigo = p_motivo_cancelamento;
          exception
            when no_data_found then
              raise_application_error(-20001,
                                      'Não foi identificado o motivo do cancelamento');
          end;

        end;
        

        /************************************/
        /* VERIFICAÇÃO DO MDFE              */
        /************************************/
        begin

            select count(*)
              into vContadorExisteMdfe
              from t_con_controlemdfe a,
                   t_con_docmdfe doc
             where doc.con_conhecimento_codigo      = p_ctrc
               and doc.con_conhecimento_serie       = p_serie
               and doc.glb_rota_codigo              = p_rota
               and doc.con_manifesto_codigo         = a.con_manifesto_codigo
               and doc.con_manifesto_serie          = a.con_manifesto_serie
               and doc.con_manifesto_rota           = a.con_manifesto_rota
               and a.con_mdfestatus_codigo          in ('AG','OK','EN','AC','EE','EC','AE','RJ')
               and doc.con_manifesto_serie          = 'A1';

          IF (vContadorExisteMdfe > 0) and (p_ctrc not in ('577534','577535','577536')) THEN
             RAISE_APPLICATION_ERROR(-20001,chr(13) || 'Conhecimento ja esta vinculado a um veiculo no MDFE, desvincule ou cancele o MDFE e tente novamente!');
          END IF;

        end;
        
        
        /************************************/
        /* VERIFICAÇÃO DA FATURA            */
        /************************************/
        begin

          select nvl(con_fatura_codigo, 'XXX')
            into vfatura
            from t_con_conhecimento
           where con_conhecimento_codigo      = p_ctrc
             and trim(con_conhecimento_serie) = p_serie
             and glb_rota_codigo              = p_rota;

          IF vFatura <> 'XXX' THEN
            RAISE_APPLICATION_ERROR(-20001,'Atenção. Conhecimento ja faturado. FATURA N.' ||
                                    vFatura || '- CTe ' || P_CTRC || ' ROTA - ' ||P_ROTA);
          END IF;

        end;

        /************************************/
        /* SE É ROTA DE CTE                 */
        /************************************/
        begin
          select decode(fn_retorna_tpambcte(p_rota),1,'S',2,'N')
            into vRotaCte
            from dual;
        end;
        
        /************************************/
        /* SE É ROTA DE NFSE                */  
        /************************************/  
        begin
          select decode(count(*),0,'N','S')
            into vRotaNfse
            from wservice.t_glb_rotaservicourl l
           where l.glb_rota_codigo    = p_rota
             and l.glb_tpservico_cod  = 'ENVIARLOTE';
        end;      
        
        /************************************/
        /* COD MSG TABELA DE CONTROLE CTE   */
        /************************************/
        begin
          
          if (vRotaCte = 'S') and (vRotaNfse = 'N') then
            
            begin

                select nvl(TRIM(ct.con_controlectrce_codstenv),'000'),
                       nvl(ct.con_controlectrce_dtretorno,'')
                  into vMsgCte,
                       vDataAut
                  from t_con_controlectrce ct
                 where ct.con_conhecimento_codigo       = p_ctrc
                   and trim(ct.con_conhecimento_serie)  = p_serie
                   and ct.glb_rota_codigo               = p_rota;

            exception when no_data_found then
             vMsgCte   := '000';
             vDataAut  := NULL;

                 /******************************************/
                 /*  VERIFICO SE O CONHECIMENTO NÃO GERADO */
                 /******************************************/
                 begin
                   
                     select count(*)
                       into vExisteNaoGerado
                       from t_uti_logcte lo,
                            t_con_conhecimento ch
                      where lo.uti_logcte_codigo             = ch.con_conhecimento_codigo
                        and lo.uti_logcte_serie              = ch.con_conhecimento_serie
                        and lo.uti_logcte_rota_codigo        = ch.glb_rota_codigo
                        and ch.con_conhecimento_codigo       = p_ctrc
                        and trim(ch.con_conhecimento_serie)  = p_serie
                        and ch.glb_rota_codigo               = p_rota;

                 exception when others then
                   vExisteNaoGerado := 0;
                 end;
            end;
            
            /**********************************************************************/
            /** VERIFICO SE O COD DE INTEGRAÇÃO ESTA LIBERADA PARA CANCELAMENTO  **/
            /**********************************************************************/
            IF vMsgCte <> '000' then
               
               begin   
                                  
                 select nvl(ll.glb_ctemsgret_libcancel,'N'),
                        ll.glb_ctemsgret_descricao
                   into vCodLiberado,
                        vMsgSEFAZ
                   from t_glb_ctemsngret ll
                  where trim(ll.glb_ctemsgret_codigomensagen) = trim(vMsgCte);

               exception when others then
                 vCodLiberado := 'N';
                 vMsgSEFAZ    := '';
               end;  
            
            end if;   
            
          end if;
          
        end;  
        

        
        /************************************/
        /* VERIFICO SE ELE EXISTE NO COLD   */
        /************************************/
        begin
           select count(*)
             into vContadorExisteCold
             from ndd_new.cold_producao cc
            where to_number(cc.ide_serie) = to_number(p_rota)
              and to_number(cc.ide_nct)   = to_number(p_ctrc);
        end;

        /************************************/
        /* VERIFICAÇÃO PARA CANCELAMENTO    */
        /************************************/
        begin


          IF (vRotaCte = 'S') AND (vRotaNfse = 'N') THEN
              
              /*****************************************************************/
              /* SE CTE ACEITO TENTO CANCELAR = 100(Autorizado o Uso do Cte)   */
              /*****************************************************************/
              if (vMsgCte = '100')                                   then

                 /**************************************************************/
                 /*    Prazo de cancelamento de 7 DIAS                         */
                 /**************************************************************/
                 IF (SYSDATE - vDataAut) < 7 THEN
                    
                    /********************************************************************/   
                    /* CTE´S AUTORIZADOS NÃO PODEM CANCELADOS O FLAG NÃO SAIU NO FISICO */
                    /********************************************************************/
                    IF (vFlag = 'N') THEN
                       RAISE_APPLICATION_ERROR(-20001,chr(13) ||
                                               'Este conhecimento ja foi autorizado não pode ser cancelado com o motido "Conhecimento Não saiu no fisico"!!' ||chr(13) ||
                                               'Cte - ' || P_CTRC || ' SR - ' || P_SERIE || ' ROTA - ' || P_ROTA);

                    END IF;
                    
                    /*********************************************/
                    /* REGISTRA EVENTO PARA CANCEL DO CTE DO CTE */
                    /*********************************************/
                    BEGIN

                      if (vMsgCte = '100') then
                        
                        if tdvadm.F_VERIFICAFECHAMENTO(vDataDeEmbarque,'CON') = 'S' then
                         
                          RAISE_APPLICATION_ERROR(-20001,chr(13) ||
                                                  'Contabilidade fechadada, CTE não pode ser cancelado.' ||chr(13) ||
                                                  'Cte - ' || P_CTRC || ' Serie - ' || P_SERIE || ' Rota - ' || P_ROTA);
                                               
                        else                       

                         select count(*)
                           into vExisteEvento
                           from t_con_eventocte ev
                          where ev.con_conhecimento_codigo = P_CTRC
                            and ev.con_conhecimento_serie  = P_SERIE
                            and ev.glb_rota_codigo         = P_ROTA
                            and ev.glb_eventosefaz_codigo  = 4;

                         if vExisteEvento > 0 then
                            RAISE_APPLICATION_ERROR(-20001,chr(13) ||
                                                    'Este conhecimento ja tem um evento de cancelamento registrado e ainda não foi processado.' ||chr(13) ||
                                                    'Cte - ' || P_CTRC || ' Serie - ' || P_SERIE || ' Rota - ' || P_ROTA);

                         end if;
                             
                        end if;

                         select count(*)
                           into vSeqEvento
                           from t_con_eventocte ev
                          where ev.con_conhecimento_codigo = P_CTRC
                            and ev.con_conhecimento_serie  = P_SERIE
                            and ev.glb_rota_codigo         = P_ROTA;

                         insert into t_con_eventocte
                           (con_conhecimento_codigo,
                            con_conhecimento_serie,
                            glb_rota_codigo,
                            con_eventocte_seqevento,
                            glb_eventosefaz_codigo,
                            usu_usuario_codigo,
                            con_eventocte_dtcadastro,
                            con_conheccancelmotivo_codigo )
                         values
                           (P_CTRC,
                            P_SERIE,
                            P_ROTA,
                            vSeqEvento+1,
                            4,
                            P_USUARIO,
                            sysdate,
                            P_MOTIVO_CANCELAMENTO);

                      end if;

                    END;

                 ELSE
                     
                   RAISE_APPLICATION_ERROR(-20001,'Cte: '||P_CTRC||' Serie: '||P_SERIE||' Rota: '||P_ROTA||' Ja esta autorizado a mais de 7 dias, impossivel cancelamento!');  
                 
                 END IF;
              
              
              /*****************************************************************/
              /*  SE CTE TEVE RESPOSTA E ELA É <> DE 100(AUTORIZADO)           */
              /*****************************************************************/   
              elsif (vMsgCte <> '100') and ( vDataaut is not null)   then
                
                if P_MOTIVO_CANCELAMENTO <> '00' then
                   RAISE_APPLICATION_ERROR(-20001,chr(13) ||'Cte não Autorizado, Selecione o motivo "CTe NÃO AUTORIZADO" para realizar o cancelamento!!' ||
                                                  chr(13) ||'Cte - ' || P_CTRC || ' SR - ' || P_SERIE || ' ROTA - ' || P_ROTA);
                end if;
                
                
                /***************************************************************/
                /* SE EXISTE NO COLD, BLOQUEAMOS                               */
                /***************************************************************/
                if vContadorExisteCold > 0 then
                   RAISE_APPLICATION_ERROR(-20001, chr(13) ||'CTe ja existe no Cold, impossivel cancelamento!');  
                end if;  
                
                /***************************************************************/
                /*SÓ CANCELO O CTE CASO O COD DE RETORNO DA SEFAZ FOR LIBERADO */
                /***************************************************************/
                IF (trim(NVL(vCodLiberado,'N')) <> 'S') THEN
                  RAISE_APPLICATION_ERROR(-20001, chr(13) ||
                                          '*******************************************************************************' || chr(13) ||
                                          'Rota de CTe, o Cod da mensagem de retorno não esta liberada para cancelamento!!' || chr(13) ||
                                          'Cte - ' || P_CTRC || ' SR - ' || P_SERIE || ' ROTA - ' || P_ROTA || chr(13) ||
                                          'MSG-SEFAZ - ' || trim(vMsgCte) || '-' || TRIM(vMsgSEFAZ) || chr(13) ||
                                          '*******************************************************************************');

                else

                  pkg_con_ctrc.sp_con_cancelaconhecimento(P_CTRC,
                                                          P_SERIE,
                                                          P_ROTA,
                                                          P_USUARIO,
                                                          P_MOTIVO_CANCELAMENTO,
                                                          P_MOTIVO_DESC,
                                                          P_PARAMETROS,
                                                          vStatus,
                                                          vMessage);

                  if (vStatus <> pkg_glb_common.Status_Nomal) then
                     RAISE_APPLICATION_ERROR(-20001,'Erro ao cancelar o Documento: '||P_CTRC||' Serie: '||P_SERIE||' Rota: '||P_ROTA||' Erro.:'||vMessage);
                  end if;


                END IF;   

              
                /****************************************************************/
                /*  SE CTE NÃO TEVE RESPOSTA E ELA É <> DE 100(AUTORIZADO)      */
                /****************************************************************/
              elsif (vMsgCte = '000') and ( vDataaut is null)        then
                 
                /***************************************************************/
                /* SE EXISTE NO COLD, BLOQUEAMOS                               */
                /***************************************************************/
                if vContadorExisteCold > 0 then
                   RAISE_APPLICATION_ERROR(-20001, chr(13) ||'CTe ja existe no Cold, impossivel cancelamento!');  
                end if;  
                
                /***************************************************************/
                /* verificação se o documento esta na aba de não gerados       */
                /***************************************************************/                
                if (vExisteNaoGerado = 0) and (nvl(vEviaDocEletronico,'N') = 'S') then
                     
                     RAISE_APPLICATION_ERROR(-20001,chr(13) ||'Este Cte ainda não teve resposta da Sefaz, não podera ser cancelado!!' ||
                                                    chr(13) ||'Cte - ' || P_CTRC || ' SR - ' || P_SERIE || ' ROTA - ' || P_ROTA);     
                 
                   
                else
                    
                     if P_MOTIVO_CANCELAMENTO <> '00' then
                        RAISE_APPLICATION_ERROR(-20001,chr(13) ||'Cte não Gerado, Selecione o motivo "CTe NÃO AUTORIZADO" para realizar o cancelamento!!' ||
                                                       chr(13) ||'Cte - ' || P_CTRC || ' SR - ' || P_SERIE || ' ROTA - ' || P_ROTA);
                     end if;

                     pkg_con_ctrc.sp_con_cancelaconhecimento(P_CTRC,
                                                             P_SERIE,
                                                             P_ROTA,
                                                             P_USUARIO,
                                                             P_MOTIVO_CANCELAMENTO,
                                                             P_MOTIVO_DESC,
                                                             P_PARAMETROS,
                                                             vStatus,
                                                             vMessage);

                    if (vStatus <> pkg_glb_common.Status_Nomal) then
                       RAISE_APPLICATION_ERROR(-20001,'Erro ao cancelar o Documento: '||P_CTRC||' Serie: '||P_SERIE||' Rota: '||P_ROTA||' Erro.:'||vMessage);
                    end if;
                 
                end if;
             
              
              else
                RAISE_APPLICATION_ERROR(-20001,'Regra para cancelamento não definida, procure o Help-Desk!, pkg_con_ctrc.SP_CARREG_CONHECCANCELV200');
              end if;

          ELSE
             
             /***************************************************************/
             /* SE EXISTE NO COLD, BLOQUEAMOS                               */
             /***************************************************************/
             If (vContadorExisteCold > 0) Then
                RAISE_APPLICATION_ERROR(-20001, chr(13) ||'CTe ja existe no Cold, impossivel cancelamento!');  
             End If;

             IF P_MOTIVO_CANCELAMENTO IN ('00','05') THEN
                RAISE_APPLICATION_ERROR(-20001,'Motivo de Cancelamento só pode ser usado para rota de Cte!!');
             END IF;

             pkg_con_ctrc.sp_con_cancelaconhecimento(P_CTRC,
                                                     P_SERIE,
                                                     P_ROTA,
                                                     P_USUARIO,
                                                     P_MOTIVO_CANCELAMENTO,
                                                     P_MOTIVO_DESC,
                                                     P_PARAMETROS,
                                                     vStatus,
                                                     vMessage);

             if (vStatus <> pkg_glb_common.Status_Nomal) then
                RAISE_APPLICATION_ERROR(-20001,'Erro ao cancelar o Documento: '||P_CTRC||' Serie: '||P_SERIE||' Rota: '||P_ROTA||' Erro.:'||vMessage);
             end if;

          END IF;

        end;

  END SP_CARREG_CONHECCANCELV200;
  
   PROCEDURE SP_CON_EFETIVACANCELAMENTO IS
   /********************************************************************************************** 
    * ROTINA           : SP_CON_EFETIVACANCELAMENTO                                              *
    * PROGRAMA         : Job                                                                     *
    * ANALISTA         : Klaytom                                                                 *
    * DESENVOLVEDOR    : Klayton                                                                 *
    * DATA DE CRIACAO  : 21/05/2014                                                              *
    * BANCO            : ORACLE-TDP                                                              *
    * EXECUTADO POR    :                                                                         *
    * FUNCINALIDADE    :                                                                         *
    * PARTICULARIDADES :                                                                         *
    **********************************************************************************************/
   vStatus        char(1);
   vMessage       varchar2(2000);
   vConfimaCancel integer;
   vEmailOrigem  varchar2(1000) := 'tdv.operacao@dellavolpe.com.br';
   vEmailDestino varchar2(1000) := 'grp.hd@dellavolpe.com.br';
   vEmailCopias  varchar2(2000) := 'ksouza@dellavolpe.com.br';
   BEGIN

     /****************************************************************************************/
     /** CURSOR PARA PEGAR OS EVENTOS QUE JA FORAM PROCESSADOS PARA EFETIVAR O CANCELAMENTO **/
     /****************************************************************************************/
     for p_cursor in (select l.con_conhecimento_codigo,
                             l.con_conhecimento_serie,
                             l.glb_rota_codigo,
                             l.con_eventocte_seqevento,
                             l.usu_usuario_codigo,
                             l.con_conheccancelmotivo_codigo
                        from t_con_eventocte l
                       where l.glb_eventosefaz_codigo           = 4
                         and nvl(l.con_eventocte_flagenvio,'S') = 'S'
                         and nvl(l.con_eventocte_flagret ,'S')  = 'S'
                         and l.con_eventocte_dtproces           is null)
     loop
       
         /*******************************************************/
         /** VERIFICO SE AINDA NÃO FOI PROCESSADO              **/
         /*******************************************************/ 
         select count(*)
           into vConfimaCancel
           from t_con_eventocte ee
          where ee.con_conhecimento_codigo          = p_cursor.con_conhecimento_codigo
            and ee.con_conhecimento_serie           = p_cursor.con_conhecimento_serie
            and ee.glb_rota_codigo                  = p_cursor.glb_rota_codigo
            and ee.con_eventocte_seqevento          = p_cursor.con_eventocte_seqevento
            and nvl(ee.con_eventocte_flagenvio,'N') = 'S'
            and nvl(ee.con_eventocte_flagret,'N')   = 'S'
            and ee.con_eventocte_dtproces           is null;
          
         if (vConfimaCancel > 0) then
          
            
            /*******************************************************/
            /**            EFETIVA O CANCELAMENTO                 **/
            /*******************************************************/
            
            vStatus  := null;
            vMessage := null; 
            
            pkg_con_ctrc.sp_con_cancelaconhecimento(p_cursor.con_conhecimento_codigo,
                                                    p_cursor.con_conhecimento_serie,
                                                    p_cursor.glb_rota_codigo,
                                                    p_cursor.usu_usuario_codigo,
                                                    p_cursor.con_conheccancelmotivo_codigo,
                                                    null,
                                                    null,
                                                    vStatus,
                                                    vMessage);                                 	            

            if (nvl(vStatus,'E') <> pkg_glb_common.Status_Nomal) then  
              
               wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao efetivar o cancelamento.', 
                                                    'Documento.:'||p_cursor.con_conhecimento_codigo||'-'||p_cursor.con_conhecimento_serie||'-'||p_cursor.glb_rota_codigo||' Erro: '||vMessage, 
                                                    vEmailOrigem, 
                                                    vEmailDestino, 
                                                    vEmailCopias);
                       
            else
              
              /*****************************************************************/
              /** ATUALIZO A TABELA COM A DATA DA EFETICVAÇÃO DO CANCELAMENTO **/  
              /*****************************************************************/
              update t_con_eventocte ev
                 set ev.con_eventocte_dtproces  = sysdate
               where ev.con_conhecimento_codigo = p_cursor.con_conhecimento_codigo
                 and ev.con_conhecimento_serie  = p_cursor.con_conhecimento_serie
                 and ev.glb_rota_codigo         = p_cursor.glb_rota_codigo
                 and ev.con_eventocte_seqevento = p_cursor.con_eventocte_seqevento;
                     
            end if;
        
        end if;          
     
     end loop;
     
     commit;
   
   END SP_CON_EFETIVACANCELAMENTO;


   Procedure sp_AjustaCarregamento
     As
      vExite number;
      vUpdadte number;
      vMemo    tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
   Begin
    
     return;         
   
         for item in(SELECT *
                     FROM V_GLB_TMP X
                     WHERE X.con_conhecimento_dtembarque >= SYSDATE - 360 
                     and ( ( trim(nvl(x.arm_carregamento_codigopr,'X')) <> 
                      Case 
                        When glbadm.pkg_glb_util.F_ENUMERICO(trim(X.carreglog)) = 'S' Then trim(X.carreglog) 
                          Else trim(nvl(x.arm_carregamento_codigopr,'X'))
                      End 
                      and trim(nvl(x.arm_carregamento_codigopr,'X')) <>
                      Case glbadm.pkg_glb_util.F_ENUMERICO(trim(X.carregobs)) 
                        When 'S' Then trim(x.carregobs) 
                          Else trim(nvl(x.arm_carregamento_codigopr,'X'))
                      End ) or ( nvl(x.arm_carregamento_codigopr,'NENC') = 'NENC' ) )  )
      loop
          vUpdadte := 0;
          vExite   := 0;
        
             if glbadm.pkg_glb_util.F_ENUMERICO(trim(item.carreglog)) = 'S' Then  
                 select count(*)
                   into vExite
                 from t_arm_carregamento c,
                      t_arm_armazem a
                 where c.arm_armazem_codigo = a.arm_armazem_codigo
                   and ( a.glb_rota_codigo = item.glb_rota_codigo or a.glb_rota_codigonf = item.glb_rota_codigo)
                   and trim(c.arm_carregamento_codigo) = trim(item.carreglog);
                 If vExite = 1 Then
                    update t_con_conhecimento c
                      set c.arm_carregamento_codigopr = trim(item.carreglog)
                    where c.con_conhecimento_codigo = item.con_conhecimento_codigo
                      and c.con_conhecimento_serie = item.con_conhecimento_serie
                      and c.glb_rota_codigo = item.glb_rota_codigo;
                 End If;
             End If; 
          
          vUpdadte := nvl(Sql%rowcount,0);
          If vExite = 0 Then
             vUpdadte := 0;
          End If;
 
          If nvl(vUpdadte,0) = 0 Then
              if glbadm.pkg_glb_util.F_ENUMERICO(trim(item.carregobs)) = 'S' Then
                 select count(*)
                   into vExite
                 from t_arm_carregamento c,
                      t_arm_armazem a
                 where c.arm_armazem_codigo = a.arm_armazem_codigo
                   and ( a.glb_rota_codigo = item.glb_rota_codigo or a.glb_rota_codigonf = item.glb_rota_codigo)
                   and trim(c.arm_carregamento_codigo) = trim(item.carregobs);
                 If vExite = 1 Then
                    update t_con_conhecimento c
                      set c.arm_carregamento_codigopr = trim(item.carregobs)
                    where c.con_conhecimento_codigo = item.con_conhecimento_codigo
                      and c.con_conhecimento_serie = item.con_conhecimento_serie
                      and c.glb_rota_codigo = item.glb_rota_codigo;
                 End If;
              End If;
          End If;
         
          vUpdadte := nvl(Sql%rowcount,0);
          If vExite = 0 Then
             vUpdadte := 0;
          End If;
          
          if nvl(vUpdadte,0) = 0 Then
            Begin
             select ca.arm_carregamemcalc_codigo
               into vMemo
             from t_arm_carregamento ca
             where ca.arm_carregamento_codigo = item.arm_carregamento_codigo;

            update t_con_conhecimento c
              set c.arm_carregamento_codigopr = trim(vMemo)
            where c.con_conhecimento_codigo = item.con_conhecimento_codigo
              and c.con_conhecimento_serie = item.con_conhecimento_serie
              and c.glb_rota_codigo = item.glb_rota_codigo;
            vUpdadte := Sql%rowcount; 
            Exception
              When OTHERS Then
                 vUpdadte := 0;
              End;
          End If;
          
          If nvl(vUpdadte,0) = 0 Then
             update t_con_conhecimento c
                set c.arm_carregamento_codigopr = 'NENC'
             where c.con_conhecimento_codigo = item.con_conhecimento_codigo
               and c.con_conhecimento_serie = item.con_conhecimento_serie
               and c.glb_rota_codigo = item.glb_rota_codigo;
          End If;

          commit;
      End Loop;
   

   
   
   
     
   End sp_AjustaCarregamento ;


   Function fn_ClassificaCte(pCte    tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                             pCteSr  tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                             pCteRt  tdvadm.t_con_conhecimento.glb_rota_codigo%type)
   Return char
     -- Retornos
     -- NO - Normal
     -- RE - Reentrega
     -- DE - Devolucao
     -- CO - Coleta
     -- NE - Não Encontrado
     -- MN - Muitas Notas
     -- SB - Substituido
   AS

-- 022532 A1 237
-- 022533 A1 237
-- 830728 A1 197
-- 830908 A1 197
-- 798196 A1 021
-- 798236 A1 021

  i integer;
  vCte    tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
  vCteSr  tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
  vCteRt  tdvadm.t_con_conhecimento.glb_rota_codigo%type;
  vNota   tdvadm.t_con_nftransporta.con_nftransportada_numnfiscal%type;
  vRemte  tdvadm.t_con_nftransporta.glb_cliente_cgccpfcodigo%type;
  vSerie  tdvadm.t_con_nftransporta.con_nftransportada_serienf%type;
  vStatus char(2);
begin
  -- Test statements here
  Begin
     select con_nftransportada_numnfiscal,
            glb_cliente_cgccpfcodigo,
            con_nftransportada_serienf
       into vNota,
            vRemte,
            vSerie
     from tdvadm.t_con_nftransporta nf
     where nf.con_conhecimento_codigo = pCte
       and nf.con_conhecimento_serie = pCteSr
       and nf.glb_rota_codigo = pCteRt;
  Exception
    When NO_DATA_FOUND Then
        vStatus := 'NE';
    When TOO_MANY_ROWS Then
        vStatus := 'MN';
    End;

    IF vStatus is null Then
       Select count(*)
          into i
       from tdvadm.t_con_nftransporta nf
       where nf.con_nftransportada_numnfiscal = vNota
         and nf.glb_cliente_cgccpfcodigo = vRemte
         and nf.con_nftransportada_serienf = vSerie
         and 0 = (select count(*)
                  from tdvadm.t_arm_notacte nct
                  where nct.con_conhecimento_codigo = nf.con_conhecimento_codigo
                    and nct.con_conhecimento_serie = nf.con_conhecimento_serie
                    and nct.glb_rota_codigo = nf.glb_rota_codigo
                    and nct.arm_notacte_codigo <> 'NO');
       If i = 2 Then
          Select nf.con_conhecimento_codigo,
                 nf.con_conhecimento_serie,
                 nf.glb_rota_codigo
            into vCte,
                 vCteSr,
                 vCteRt
          from tdvadm.t_con_nftransporta nf
          where nf.con_nftransportada_numnfiscal = vNota
            and nf.glb_cliente_cgccpfcodigo = vRemte
            and nf.con_nftransportada_serienf = vSerie
            and nf.con_conhecimento_codigo <> pCte
            and nf.con_conhecimento_serie = pCteSr
            and nf.glb_rota_codigo = pCteRt
            and rownum = 1;
          If pCte > vCte Then
             vStatus := 'SB';
          Else
             vStatus := 'NO';
          End If;  
       ElsIf i = 1 Then
          Begin
             select nct.arm_notacte_codigo
                 into vStatus
             from tdvadm.t_arm_notacte nct
             where nct.con_conhecimento_codigo = pCte
               and nct.con_conhecimento_serie = pCteSr
               and nct.glb_rota_codigo = pCteRt;
          Exception
            When NO_DATA_FOUND Then
               vStatus := 'NO';
            End;
       Else
          vStatus := 'MN';
       End If;
      
   End If;
   
   Return vStatus;
   
end;
     



end pkg_con_ctrc;
/
