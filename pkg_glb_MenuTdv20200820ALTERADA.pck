create or replace package pkg_glb_MenuTdv is

  CODIGO_MENU     Constant TDVADM.T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE := 'menu2012';
  CODIGO_LOGIN    Constant TDVADM.T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE := 'loginmenu';
  CODIGO_ATUALIZA Constant TDVADM.T_USU_APLICACAO.USU_APLICACAO_CODIGO%TYPE := 'atuloginMe';
  
/*  Type TAplicacao Is Record(Codigo    tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                            Path      tdvadm.t_usu_aplicacao.usu_aplicacao_path%type,
                            VersaoExe tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type,
                            VersaoDB  tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type
                            );  
  Type TListAplicacao Is Table Of TAplicacao Index By Binary_Integer;  */ 
  
  Type TUsuario is Record(USU_USUARIO_CODIGO         tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                          GLB_ROTA_CODIGO            tdvadm.t_usu_usuario.glb_rota_codigo%type,
                          USU_USUARIO_NOME           tdvadm.t_usu_usuario.usu_usuario_nome%type,
                          USU_USUARIO_TIMEOUT        tdvadm.t_usu_usuario.usu_usuario_timeout%type,
                          USU_USUARIO_SENHA          tdvadm.t_usu_usuario.usu_usuario_senha%type,
                          USU_USUARIO_SENHAEXPIRA    tdvadm.t_usu_usuario.usu_usuario_senhaexpira%type,
                          USU_VARSIS_TPCODIGO        tdvadm.t_usu_usuario.usu_varsis_tpcodigo%type,
                          GLB_ROTA_DESCRICAO         tdvadm.t_glb_rota.glb_rota_descricao%type,
                          USU_USUARIO_CRIP           tdvadm.t_usu_usuario.usu_usuario_crip%type,
                          INT_MAQUINAS_USUARIOADMIN  tdvadm.t_int_maquinas.int_maquinas_usuarioadmin%type,
                          INT_MAQUINAS_SENHAADMIN    tdvadm.t_int_maquinas.int_maquinas_senhaadmin%type,
                          INT_MAQUINAS_DOMINIO       tdvadm.t_int_maquinas.int_maquinas_dominio%type,
                          INT_MAQUINAS_INTERNO       tdvadm.t_int_maquinas.int_maquinas_interno%type);
  Type TListUsuario Is Table Of TUsuario Index By Binary_Integer;     
  
  Type TUsuVarSis is Record(USU_VARSIS_TPCODIGO      tdvadm.t_usu_varsis.usu_varsis_tpcodigo%type,
                            USU_VARSIS_IPFTP         tdvadm.t_usu_varsis.usu_varsis_ipftp%type,
                            USU_VARSIS_USER          tdvadm.t_usu_varsis.usu_varsis_user%type,
                            USU_VARSIS_SENHA         tdvadm.t_usu_varsis.usu_varsis_senha%type,
                            USU_VARSIS_PORT          tdvadm.t_usu_varsis.usu_varsis_port%type,
                            USU_VARSIS_TIMEOUT       tdvadm.t_usu_varsis.usu_varsis_timeout%type,
                            USU_VARSIS_DESTINOTMP    tdvadm.t_usu_varsis.usu_varsis_destinotmp%type);
  Type TListUsuVarSis Is Table Of TUsuVarSis Index By Binary_Integer;                            
                          
                           
  Procedure sp_get_PathMenuTdv( pPathMenu  Out tdvadm.t_usu_aplicacao.usu_aplicacao_path%Type,
                                pStatus  Out Char,
                                pMessage Out Varchar2 ); 
       
  
  Procedure sp_get_DadosMenuTdv( pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                 pStatus  Out Char,
                                 pMessage Out Varchar2 );

  Procedure sp_get_DadosLoginTdv( pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2 );

  Procedure sp_get_DadosAplicacao(pAppCodigo tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                                  pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,
                                  pStatus    Out Char,
                                  pMessage   Out Varchar2 );

  Procedure sp_get_AppVersionDB( pAppCod     in  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                                 pVersaoApp  Out tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type,
                                 pStatus     Out varchar2,
                                 pMessage    Out Varchar2 );

  Procedure sp_get_ChildApplication(pAppCod  in  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                                    pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2 );

  Procedure sp_InsertLogVersion(pPath    in  varchar2,
                                pStatus  Out Char,
                                pMessage Out Varchar2 );


  Procedure sp_get_SegmentoMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                    pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2 );

  Procedure sp_get_SistemaMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                   pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                   pStatus  Out Char,
                                   pMessage Out Varchar2 );

  Procedure sp_get_AplicacaoMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                     pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2 );

  Procedure sp_get_ModuloMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                  pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2 );

  Procedure sp_SendFavoriteToServer(pAppCode  in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type, 
                                    pUserName in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                    pQtdAcces in number,
                                    pOrdem    in number,
                                    pImgIndex in number,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2 );  
  
  Procedure sp_ValidateUserWeb(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                               pValid   Out Char, -- S=Validado com sucesso, N=usuario não validado
                               pStatus  Out Char,
                               pMessage Out Varchar2 );
    

  Procedure sp_ValidateMaquina(pMaquina in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                               pValid   Out Char, -- S=Validado com sucesso, N=usuario não validado
                               pStatus  Out Char,
                               pMessage Out Varchar2 );

/*  Procedure sp_UpdateMaquina(pMaquina in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                             pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                             pStatus  Out Char,
                             pMessage Out Varchar2 );*/

  Procedure sp_get_FavoriteFromServer(pUser      in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                      pTypeOrder in  char, -- F=FAvorite, M=MaxAccess
                                      pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,        
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2 );

  procedure sp_get_DataAlteracaoSenha(pUser      in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                      pDataAlt   Out varchar2,        
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2 );  

  procedure sp_get_DataAtualBanco(pDataAtu   Out varchar2,        
                                  pStatus    Out Char,
                                  pMessage   Out Varchar2);
                                  
  procedure sp_get_Usuario(pCodigo    in  varchar2,
                           pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                           pStatus    Out Char,
                           pMessage   Out Varchar2);                                  
                             
  procedure sp_verStatusPJ(pCodigo    in  varchar2,
                           pStatusPJ  Out varchar2,           
                           pStatus    Out Char,
                           pMessage   Out Varchar2);                           
                    
  procedure sp_get_Rotas(pCodigo    in  varchar2,
                         pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                         pStatus    Out Char,
                         pMessage   Out Varchar2);

  procedure sp_get_CpfUsuario(pCodigo    in  varchar2,
                              pCPF       Out varchar2,           
                              pStatus    Out Char,
                              pMessage   Out Varchar2);                           
              
  procedure sp_StatusFPW(pCpf       in  varchar2,
                         pStatusFpw Out number,           
                         pStatus    Out Char,
                         pMessage   Out Varchar2);
                   
  procedure sp_get_DescAlteracaoMenu(pDescricao Out varchar2,           
                                     pStatus    Out Char,
                                     pMessage   Out Varchar2);
  
  procedure sp_UpdateUser(pUsuario    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                          pVersaoMenu in  tdvadm.t_usu_usuario.USU_USUARIO_VERSAOMENU%type,
                          pRamal      in  tdvadm.t_usu_usuario.USU_USUARIO_RAMAL%type,
                          pDepto      in  tdvadm.t_usu_usuario.glb_departamento_codigo%type,
                          pEmail      in  tdvadm.t_usu_usuario.usu_usuario_email%type,
                          pCpf        in  tdvadm.t_usu_usuario.USU_USUARIO_CPF%type,            
                          pStatus     Out Char,
                          pMessage    Out Varchar2);
  
  procedure sp_get_DadosUsuario(pUsuario   in  varchar2,
                                pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                                pStatus    Out Char,
                                pMessage   Out Varchar2);
    
  procedure sp_get_Departamentos(pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                                 pStatus    Out Char,
                                 pMessage   Out Varchar2);
  
  procedure sp_get_SenhaCriptografada(pUsuario   in  varchar2,
                                      pSenha     Out tdvadm.t_usu_usuario.usu_usuario_senha%type,           
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2);
  
  procedure sp_UpdateSenhaUsuario(pUsuario          in  varchar2,            
                                  pNovaSenhaCript   in tdvadm.t_usu_usuario.usu_usuario_senha%type,           
                                  pNovaSenhaDeCript in tdvadm.t_usu_usuario.usu_usuario_senha%type,
                                  pDica             in tdvadm.t_usu_usuario.usu_usuario_dica%type,
                                  pStatus           Out Char,
                                  pMessage          Out Varchar2);
                      
  procedure sp_get_NomeCompleto(pUsuario      in  varchar2,
                                pNomeCompleto Out varchar2,           
                                pStatus       Out Char,
                                pMessage      Out Varchar2);                           

  procedure sp_get_DataNascimento(pUsuario        in  varchar2,
                                  pDataNascimento Out varchar2,           
                                  pStatus         Out Char,
                                  pMessage        Out Varchar2);                           

  procedure sp_get_DicaSenha(pUsuario in  varchar2,
                             pDica    Out varchar2,           
                             pStatus  Out Char,
                             pMessage Out Varchar2);                           
                    
  procedure sp_get_DadosFtp(pVarSisTpCodigo in  tdvadm.t_Usu_Varsis.usu_varsis_tpcodigo%type,
                            pCursor         Out tdvadm.pkg_glb_common.T_CURSOR,           
                            pStatus         Out Char,
                            pMessage        Out Varchar2);  
                    
  procedure sp_UpdateMaquina(pComputerName in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                             pUsuario      in tdvadm.t_usu_usuario.usu_usuario_codigo%type,           
                             pStatus     Out Char,
                             pMessage    Out Varchar2);
               
  procedure sp_UpdateUltimoLogonUsuario(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,          
                                        pStatus  Out Char,
                                        pMessage Out Varchar2);  

  procedure sp_UpdateApplicationUsuario(pUsuario     in tdvadm.t_usu_usuario.usu_usuario_codigo%type,          
                                        pApplication in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,        
                                        pStatus      Out Char,
                                        pMessage     Out Varchar2);  
  
  procedure sp_DeleteFavoritesFromDataBase(pUsuario     in tdvadm.t_usu_usuario.usu_usuario_codigo%type,          
                                           pApplication in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,        
                                           pStatus      Out Char,
                                           pMessage     Out Varchar2);  
                                           
  procedure sp_GravaAmbienteUsuario(pUsuario  in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                    pStatus   Out Char,
                                    pMessage  Out Varchar2);
                                           
  procedure sp_get_SituacaoCadastroUsuario(pUsuario   in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                           pSituacao  Out Char,           
                                           pStatus    Out Char,
                                           pMessage   Out Varchar2);
                                           
  Procedure sp_get_AplicacaoMenuPorModulo(pModulo   in  tdvadm.V_USU_USUARIOPERFIL_MNOVO.USU_MODULO_NOMEMENU%type,
                                          pSistema  in  tdvadm.V_USU_USUARIOPERFIL_MNOVO.USU_SISTEMANOMEMENU_DESCRICAO%type,
                                          pSegmento in  tdvadm.V_USU_USUARIOPERFIL_MNOVO.USU_SEGMENTO_NOMEMENU%type,
                                          pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                          pStatus  Out Char,
                                          pMessage Out Varchar2 );

  procedure sp_get_DadosAdminWindows(pMaquinaCodigo in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                                     pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2 );
                    
  procedure sp_get_MaquinaInterna(pNomeMaquina in varchar2,
                                  pInterna out char,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2 );
  
  procedure sp_get_VerificaAtualizacao(pVersaoExeMenu  varchar2,
                                       pVersaoExeLogin varchar2,
                                       pAtualiza      out char, -- S=Existe Atialização, N=Não existe atualização
                                       pStatus  Out Char,
                                       pMessage Out Varchar2 );
                         
  -- so para validar a validação da Versao
  function fn_vld_AppVersionDB(pAppCod     in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                               pVersaoApp  in tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type) return char;

  function fn_DesencriptaSenha(pSenhaCrip varchar2,
                               pRetorno  char default 'F')
        return varchar2 ;

  function fn_EncriptaSenha(pSenha     Varchar2,
                            pSenhaPai  varchar2 default 'AGED12')
        return varchar2 ;

  function fn_ValidaSenha(pUsuario tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                          pSenha   tdvadm.t_usu_usuario.usu_usuario_senha%type)
    return char;

  function fn_retornocaracter(p_tipo in char) return char;
                    
  procedure sp_AutenticaUsuario(pUsuario     in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                pSenha       in tdvadm.t_usu_usuario.usu_usuario_senha%type,
                                pAutenticado out char,
                                pStatus      out char,
                                pMessage     out varchar2);

  procedure sp_PermitirAcessoUsuario(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                     pAcesso  out char, -- S=Acesso Permitido, N=Acesso Negado     
                                     pStatus  out char,
                                     pMessage out varchar2);
                    
  procedure sp_get_Tarefas(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                           pMaquina in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                           pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                           pStatus  Out Char,
                           pMessage Out Varchar2);
                      
  procedure sp_Atualiza_Atualizador(pVersaoExeAtu  varchar2,
                                    pAtualiza      out char, -- S=Existe Atialização, N=Não existe atualização
                                    pStatus        Out Char,
                                    pMessage       Out Varchar2);
  
       
  procedure sp_executa_login(pUsuario        in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                             pMaquina        in  tdvadm.t_int_maquinas.int_maquinas_codigo%type,                           
                             pVersaoExeMenu  in  varchar2,
                             pVersaoExeLogin in  varchar2,
                             pVersaoExeAtu   in  varchar2,
                             pXmlRetorno     out clob,
                             pStatus         out char,
                             pMessage        out varchar2);
          
  function fn_get_Usuario(pCodigo in tdvadm.t_usu_usuario.usu_usuario_codigo%type) return TUsuario;
  
  function fn_get_UsuVarsis(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type) return TUsuVarSis;
  
  procedure sp_get_MontaMenu(pUsuario         in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                             pCursorSegmentos out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorSistemas  out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorModulos   out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorAplicacao out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorFavoritos out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorRotaUsuario out tdvadm.pkg_glb_common.T_CURSOR,
                             pXmlRetorno      out Clob,
                             pStatus          out char,
                             pMessage         out varchar2);
                            
  
  function fn_get_StatusUsuario(pUsuarioCodigo tdvadm.t_usu_usuario.usu_usuario_codigo%type) return char;

  Procedure sp_CopiaFavorito(pUsuarioOrigem in t_usu_aplicacaofavorita_mnovo.usu_usuario_codigo%type,
                             pUsuarioDestino in t_usu_aplicacaofavorita_mnovo.usu_usuario_codigo%type,
                             pTipo in char,
                             pApagaorigem in char Default 'N',
                             pStatus out Char,
                             pMessage out varchar2) ;
                          -- pTipo pode ser:
                          -- S - Sobrepor
                          -- M - Mesclar
                          -- pApagaorigem pode ser
                          -- S - Sim 
                          -- N - Nao 
  function fn_get_PermitirAcessoUsuario(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type) return char;

  
end pkg_glb_MenuTdv;

 
/
create or replace package body pkg_glb_MenuTdv is

  
  Procedure sp_get_PathMenuTdv( pPathMenu  Out tdvadm.t_usu_aplicacao.usu_aplicacao_path%Type,
                                pStatus    Out Char,
                                pMessage   Out Varchar2 )
  As
  Begin
    Begin
      
      Select ap.usu_aplicacao_path
        Into pPathMenu
        From tdvadm.t_usu_aplicacao ap
        Where ap.usu_aplicacao_codigo = rpad(Lower(pkg_glb_MenuTdv.CODIGO_MENU),10);    
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Path do MenuTdv gerada com sucesso!';
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar a path do MenuTdv, '||Sqlerrm;  
    End;
    
  End sp_get_PathMenuTdv;                                


  Procedure sp_get_DadosMenuTdv( pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                 pStatus  Out Char,
                                 pMessage Out Varchar2 )
  As
  Begin
    
    Begin

      Open pCursor For
      Select 
             ap.usu_aplicacao_descricao,
             ap.usu_aplicacao_nomemenu,
             ap.usu_aplicacao_relpath,
             ap.usu_aplicacao_path,
             ap.usu_aplicacao_codigo,
             trim(ap.usu_aplicacao_versao) usu_aplicacao_versao,
             ap.usu_aplicacao_dataversao
      From tdvadm.t_usu_aplicacao ap
      Where ap.usu_aplicacao_codigo = rpad(lower(pkg_glb_MenuTdv.CODIGO_MENU),10)
      And rownum = 1;

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Dados do MenuTdv gerado com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar dados do MenuTdv, '||Sqlerrm;  
    End;
    
  End;                                 

  Procedure sp_get_DadosLoginTdv( pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                 pStatus  Out Char,
                                 pMessage Out Varchar2 )
  As
  Begin
    
    Begin

      Open pCursor For
      Select 
             ap.usu_aplicacao_descricao,
             ap.usu_aplicacao_nomemenu,
             ap.usu_aplicacao_relpath,
             ap.usu_aplicacao_path,
             ap.usu_aplicacao_codigo,
             trim(ap.usu_aplicacao_versao) usu_aplicacao_versao,
             ap.usu_aplicacao_dataversao
      From tdvadm.t_usu_aplicacao ap
      Where ap.usu_aplicacao_codigo = rpad(lower(pkg_glb_menutdv.CODIGO_LOGIN),10)
      And rownum = 1;

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Dados do Login Menu tdv gerado com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar dados do LoginMenuTdv, '||Sqlerrm;  
    End;
    
  End sp_get_DadosLoginTdv;      

  Procedure sp_get_DadosAplicacao(pAppCodigo tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                                  pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,
                                  pStatus    Out Char,
                                  pMessage   Out Varchar2 )
  is
  begin
    
    begin
      
      open pCursor for
      SELECT * 
        FROM TDVADM.T_USU_APLICACAO a
       WHERE 0=0
         and a.USU_APLICACAO_CODIGO = rpad(lower(pAppCodigo),10); 
                                    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Dados da aplicação: '||pAppCodigo||' gerado com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar gerar dados da aplicação: '||pAppCodigo||', '||Sqlerrm;  
    End;
    
  End sp_get_DadosAplicacao;   

  Procedure sp_get_AppVersionDB( pAppCod     in  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                                 pVersaoApp  Out tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type,
                                 pStatus     Out varchar2,
                                 pMessage    Out Varchar2 )
  as
    VERSION_NOT_FOUND constant varchar2(30) := 'version not found';
  begin
    begin
      
      SELECT TRIM(nvl(A.USU_APLICACAO_VERSAO,VERSION_NOT_FOUND))
        INTO pVersaoApp 
        FROM T_USU_APLICACAO A
       WHERE A.USU_APLICACAO_CODIGO = rpad(lower(pAppCod),10);      
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Versão da aplicação obtida com sucesso!';      
    Exception 
      WHEN NO_DATA_FOUND THEN
        pStatus    := tdvadm.pkg_glb_common.Status_Nomal;     
        pVersaoApp := VERSION_NOT_FOUND;  
        pMessage   := pVersaoApp;
      When Others Then
        pVersaoApp := VERSION_NOT_FOUND;  
        pStatus  := tdvadm.pkg_glb_common.Status_Erro;
        pMessage := 'Erro ao tentar obter a versão da aplicação, '||Sqlerrm;  
    End;
  end sp_get_AppVersionDB;


  Procedure sp_get_ChildApplication(pAppCod  in  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                                    pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2 )
  as
  Begin
    
    Begin

      Open pCursor For
      SELECT AD.USU_APLICACAO_FILHO,
             A.USU_APLICACAO_PATH
        FROM T_USU_APLICACAODETALHE AD,T_USU_APLICACAO A
       WHERE 0=0
         and AD.USU_APLICACAO_FILHO = A.USU_APLICACAO_CODIGO
         AND trim(AD.USU_APLICACAO_CODIGO) = trim(pAppCod);
       
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Lista de aplicações filhas gerada com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar Lista de aplicações filhas, '||Sqlerrm;  
    End;
    
  End sp_get_ChildApplication;
  
  Procedure sp_InsertLogVersion(pPath    in  varchar2,
                                pStatus  Out Char,
                                pMessage Out Varchar2 )
  as
  begin
    
    begin
      
      --INSERT INTO DROPME(X,A) VALUES('Versionamento', substr(pPath,1,100));
      --commit;
      dbms_output.put_line(pPath);
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Log versão inserido com sucesso"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao inserir log versão, '||Sqlerrm;  
    End;
          
  end sp_InsertLogVersion;
  
  Procedure sp_get_SegmentoMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                    pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2 )
  as    
  begin  
    
    begin
      open pCursor for
      SELECT DISTINCT USU_SEGMENTO_NOMEMENU 
        FROM V_USU_USUARIOPERFIL_MNOVO V
       WHERE  0=0
         and V.Usu_Usuario_Codigo = rpad(lower(pUser),10)
       order by 1;
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;
      pMessage := 'Lista de SegmentoMenu gerada com sucesso"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar lista de SegmentoMenu, '||Sqlerrm;  
    End;
    
  end sp_get_SegmentoMenuView;     
  
  Procedure sp_get_SistemaMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                   pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                   pStatus  Out Char,
                                   pMessage Out Varchar2 )
  as    
  begin  
    
    begin
      open pCursor for
      SELECT distinct USU_SEGMENTO_NOMEMENU,
             USU_SISTEMANOMEMENU_DESCRICAO 
        FROM V_USU_USUARIOPERFIL_MNOVO V
       WHERE 0=0
         and V.Usu_Usuario_Codigo = rpad(lower(pUser),10) 
       order by 1;
            
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Lista de SistemaMenu gerada com sucesso"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar lista de SistemaMenu, '||Sqlerrm;  
    End;
    
  end sp_get_SistemaMenuView;   
                                   
  Procedure sp_get_AplicacaoMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                     pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2 )
  as    
  begin  
    
    begin
      open pCursor for
      SELECT distinct v.USU_SEGMENTO_NOMEMENU,
             v.USU_SISTEMANOMEMENU_DESCRICAO,
             v.USU_MODULO_NOMEMENU,
             v.USU_APLICACAO_NOMEMENU,
             v.USU_NIVEL_CODIGO,
             v.USU_APLICACAO_PATH,
             v.USU_APLICACAO_CODIGO, 
             v.USU_APLICACAO_RELPATH,
             trim(v.USU_APLICACAO_VERSAO) usu_aplicacao_versao,
             v.USU_MODULO_CODIGO,
             v.USU_APLICACAO_TIPO,
             v.USU_APLICACAO_URLWEB 
        FROM V_USU_USUARIOPERFIL_MNOVO V
      WHERE 0=0
        and V.Usu_Usuario_Codigo = rpad(lower(pUser),10) 
      order by 1, 2;          
      
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Lista de AplicacaoMenu gerada com sucesso"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar lista de AplicacaoMenu, '||Sqlerrm;  
    End;
    
  end sp_get_AplicacaoMenuView;   
                                     
  Procedure sp_get_ModuloMenuView(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                  pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2 )
  as    
  begin  
    
    begin
      open pCursor for
      SELECT distinct USU_SEGMENTO_NOMEMENU,
             USU_SISTEMANOMEMENU_DESCRICAO,
             USU_MODULO_NOMEMENU 
        FROM V_USU_USUARIOPERFIL_MNOVO V
       WHERE 0=0
         and V.Usu_Usuario_Codigo = rpad(lower(pUser),10) 
       order by 1;          
      
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Lista de ModuloMenu gerada com sucesso"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar lista de ModuloMenu, '||Sqlerrm;  
    End;
    
  end sp_get_ModuloMenuView;  
    
  Procedure sp_SendFavoriteToServer(pAppCode  in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type, 
                                    pUserName in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                    pQtdAcces in number,
                                    pOrdem    in number,
                                    pImgIndex in number,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2 )
  as
  begin

    begin

      INSERT INTO T_USU_APLICACAOFAVORITA_MNOVO(
             USU_APLICACAO_CODIGO,
             USU_USUARIO_CODIGO,
             USU_APLICACAOFAVORITA_QTDACES,
             USU_APLICACAOFAVORITA_ORDEM,
             USU_APLICACAOFAVORITA_IMGINDEX)
      VALUES(pAppCode,
             pUserName, 
             pQtdAcces,
             pOrdem,
             pImgIndex);
      commit;                        

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Favorito inserido com sucesso!"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao inserir favorito, '||Sqlerrm;  
    End;
    
  end sp_SendFavoriteToServer;                                      
  
  Procedure sp_ValidateUserWeb(pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                               pValid   Out Char, -- S=Validado com sucesso, N=usuario não validado
                               pStatus  Out Char,
                               pMessage Out Varchar2 )
  as
    vCount number;
  begin
  
    -- inicializando as variaveis/parametros de saida
    pValid := 'N';
    vCount := -1;  
  
    begin
      
      SELECT COUNT(*)
        into vCount
        FROM COLETA.USUARIO_WEB W, 
             TDVADM.T_USU_USUARIO U                        
       WHERE 0=0 
         and UPPER(TRIM(U.USU_USUARIO_CODIGO)) = W.DC_USUARIO
         AND NVL(upper(U.USU_USUARIO_WEB),'N') = 'S'
         AND U.USU_USUARIO_CODIGO = rpad(lower(pUser),10);
      
      if vCount > 0 then
         pValid := 'S';
       end if;
              
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'usuário web validado com sucesso!"';      
    Exception When Others Then
      pValid   := 'N';
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao validar usuário web, '||Sqlerrm;  
    End;
          
  end sp_ValidateUserWeb;                               
  
  Procedure sp_ValidateMaquina(pMaquina in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                               pValid   Out Char, -- S=Validado com sucesso, N=usuario não validado
                               pStatus  Out Char,
                               pMessage Out Varchar2)
  as
    vCount number;
  begin
    
  -- if (instr(pMaquina,'TDVMD')> 0 ) then
     
     insert into tdvadm.t_glb_sql
       (glb_sql_observacao, glb_sql_dtgravacao, glb_sql_programa)
     values
       (pMaquina, sysdate, 'testemenu');
     commit;
       
  -- end if;  
  
    -- inicializando as variaveis/parametros de saida
    pValid := 'N';
    vCount := -1;  
  
    begin
      
      Select count(*)
        into vCount
        from t_int_maquinas 
       where 0=0
         and trim(upper(INT_MAQUINAS_CODIGO)) = trim(UPPER(pMaquina));
      
      
      if vCount <= 0 then
         pValid   := 'N';
         pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
         pMessage := 'Computador[ '||pMaquina||' ] não tem autorização de acesso.'||
                     Chr(13)||
                     'Entre em contato com o ServiceDesk';
         return;               
       end if;

      pValid   := 'S';              
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Maquina validado com sucesso!"';      
    Exception When Others Then
      pValid   := 'N';
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao validar Maquina, '||Sqlerrm;  
    End;
    
  end sp_ValidateMaquina;                               
  
/*  Procedure sp_UpdateMaquina(pMaquina in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                             pUser    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                             pStatus  Out Char,
                             pMessage Out Varchar2 )
  as
  begin
   
    begin
      
      Update t_int_maquinas 
         set INT_MAQUINAS_DESCRICAO = pUser||' - '||sysdate
       where trim(lower(INT_MAQUINAS_CODIGO)) = trim(lower(pMaquina));
      commit;
              
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Maquina atualizada com sucesso!"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao atualizar Maquina, '||Sqlerrm;  
    End;
    
  end sp_UpdateMaquina;  */                               
                    
  Procedure sp_get_FavoriteFromServer(pUser      in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                      pTypeOrder in  char, -- F=FAvorite, M=MaxAccess    
                                      pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,    
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2 )
  as
  begin                         
    
    begin             
      
      open pCursor for
      SELECT distinct TRIM(F.USU_APLICACAO_CODIGO) APP_CODE,
             TRIM(F.USU_USUARIO_CODIGO) USERNAME,
             TRIM(F.USU_APLICACAOFAVORITA_QTDACES) QTDACCESS,
             TRIM(F.USU_APLICACAOFAVORITA_ORDEM) ORDEM,   
             TRIM(A.USU_APLICACAO_NOMEMENU) APP_DESCRIPTION,
             TRIM(A.USU_APLICACAO_PATH) APP_PATH,
             TRIM(F.USU_APLICACAOFAVORITA_IMGINDEX) IMGINDEX,
             A.USU_NIVEL_CODIGO NIVEL,
             TRIM(A.USU_APLICACAO_RELPATH) REL_PATH
        FROM T_USU_APLICACAOFAVORITA_MNOVO F, V_USU_USUARIOPERFIL_MNOVO A
       WHERE A.USU_APLICACAO_CODIGO = F.USU_APLICACAO_CODIGO
         AND A.USU_USUARIO_CODIGO = F.USU_USUARIO_CODIGO
         AND F.USU_USUARIO_CODIGO = rpad(lower(pUser),10)
        order by case 
                   when upper(pTypeOrder) = 'F' then ORDEM
                   when upper(pTypeOrder) = 'M' then QTDACCESS
                 end; 

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Favoritos do usuario gerado com sucesso!"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar Favoritos do usuario, '||Sqlerrm;  
    End;
  
  end sp_get_FavoriteFromServer;  
               
  procedure sp_get_DataAlteracaoSenha(pUser      in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                      pDataAlt   Out varchar2,        
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2 )
  as
  begin
    begin
      
      SELECT U.USU_USUARIO_DATA_ALTERASENHA
        into pDataAlt
        FROM T_USU_USUARIO U 
       WHERE U.USU_USUARIO_CODIGO = pUser;
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Data de alteração da senha obtida com sucesso!"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter a data de alteração de senha, '||Sqlerrm;  
    End;
        
  end sp_get_DataAlteracaoSenha;                                      
  
  procedure sp_get_DataAtualBanco(pDataATu   Out varchar2,        
                                  pStatus    Out Char,
                                  pMessage   Out Varchar2)
  as
  begin
    begin
      select to_char(sysdate, 'DD/MM/YYYY hh24:MI:ss')
        into pDataAtu
       from dual;
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Data atual do banco obtida com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ai tentar obter a data atual do banco, '||Sqlerrm;  
    End;       
  end sp_get_DataAtualBanco;                                    
  
  procedure sp_get_Usuario(pCodigo    in  varchar2,
                           pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                           pStatus    Out Char,
                           pMessage   Out Varchar2)
--  Procedure sp_get_Usuario(pXmlIn   In  Varchar,
--                           pXmlOut  Out Clob,
--                           pStatus  Out varchar2,
--                           pMessage Out Varchar2)
  is
    vExist      integer;
    --vCodigo     tdvadm.t_usu_usuario.usu_usuario_codigo%type;
    --vTblUsuario CLob; 
  begin
    begin
      --vCodigo := glbadm.pkg_glb_wsinterfacedb.Fn_GetParam(pXmlIn, 'Usuario');
      SELECT count(*)
        into vExist
        FROM T_USU_USUARIO U
       WHERE 0=0
         and USU_USUARIO_CODIGO = rpad(lower(pCodigo),10);
         --and TRIM(lower(USU_USUARIO_CODIGO)) = lower(trim(vCodigo));
         
      if vExist = 0 then
        pStatus  := 'W';      
        --pMessage := 'Usuário: '||vCodigo||', não localizado';
        pMessage := 'Usuário: '||pCodigo||', não localizado';
        open pCursor for select sysdate from dual;
        return;               
      end if;            
    
      open pCursor for
      SELECT U.USU_USUARIO_CODIGO,
             U.GLB_ROTA_CODIGO,   
             U.USU_USUARIO_NOME,
             nvl(U.USU_USUARIO_TIMEOUT, 30) USU_USUARIO_TIMEOUT,
             U.USU_USUARIO_SENHA,
             U.USU_USUARIO_SENHAEXPIRA,             
             nvl(U.USU_VARSIS_TPCODIGO, 2) USU_VARSIS_TPCODIGO,
             R.GLB_ROTA_DESCRICAO,
             u.usu_usuario_crip,
             nvl(I.INT_MAQUINAS_USUARIOADMIN,'Administrador') INT_MAQUINAS_USUARIOADMIN,
             nvl(I.INT_MAQUINAS_SENHAADMIN,'fiona') INT_MAQUINAS_SENHAADMIN,
             nvl(I.INT_MAQUINAS_DOMINIO,'TDVPROD') INT_MAQUINAS_DOMINIO,
             nvl(I.INT_MAQUINAS_INTERNO,'N') INT_MAQUINAS_INTERNO
        FROM TDVADM.T_USU_USUARIO U,
             TDVADM.T_GLB_ROTA R,
             TDVADM.T_INT_MAQUINAS I
       WHERE 0=0 
         --and TRIM(lower(USU_USUARIO_CODIGO)) = lower(trim(vCodigo))        
         and U.USU_USUARIO_CODIGO = rpad(lower(pCodigo),10)
         and U.USU_USUARIO_CODIGO = rpad(lower(I.INT_MAQUINAS_OSUSER(+)),10)
         and U.GLB_ROTA_CODIGO = R.GLB_ROTA_CODIGO
         and rownum = 1;
    
/*      vTblUsuario:= '<Table name="Usuario"><ROWSET>';
      for linha in (
      SELECT U.USU_USUARIO_CODIGO,
             U.GLB_ROTA_CODIGO,   
             U.USU_USUARIO_NOME,
             U.USU_USUARIO_TIMEOUT,
             U.USU_USUARIO_SENHA,
             U.USU_USUARIO_SENHAEXPIRA,             
             U.USU_VARSIS_TPCODIGO,
             R.GLB_ROTA_DESCRICAO
        FROM T_USU_USUARIO U,
             T_GLB_ROTA R
       WHERE 0=0 
         and TRIM(lower(USU_USUARIO_CODIGO)) = lower(trim(vCodigo))        
         and U.GLB_ROTA_CODIGO = R.GLB_ROTA_CODIGO )
      loop
         vTblUsuario := vTblUsuario||'<ROW num="1">';
         vTblUsuario := vTblUsuario||'<USU_USUARIO_CODIGO>'||linha.USU_USUARIO_CODIGO||'</USU_USUARIO_CODIGO>';
         vTblUsuario := vTblUsuario||'<GLB_ROTA_CODIGO>'||linha.GLB_ROTA_CODIGO||'</GLB_ROTA_CODIGO>';
         vTblUsuario := vTblUsuario||'<USU_USUARIO_NOME>'||linha.USU_USUARIO_NOME||'</USU_USUARIO_NOME>';
         vTblUsuario := vTblUsuario||'<USU_USUARIO_TIMEOUT>'||linha.USU_USUARIO_TIMEOUT||'</USU_USUARIO_TIMEOUT>';
         vTblUsuario := vTblUsuario||'<USU_USUARIO_SENHA>'||linha.USU_USUARIO_SENHA||'</USU_USUARIO_SENHA>';
         vTblUsuario := vTblUsuario||'<USU_USUARIO_SENHAEXPIRA>'||linha.USU_USUARIO_SENHAEXPIRA||'</USU_USUARIO_SENHAEXPIRA>';
         vTblUsuario := vTblUsuario||'<USU_VARSIS_TPCODIGO>'||linha.USU_VARSIS_TPCODIGO||'</USU_VARSIS_TPCODIGO>';
         vTblUsuario := vTblUsuario||'<GLB_ROTA_DESCRICAO>'||linha.GLB_ROTA_DESCRICAO||'</GLB_ROTA_DESCRICAO>';
         vTblUsuario := vTblUsuario||'</ROW>';         
      end loop;                
      vTblUsuario:= vTblUsuario||'</ROWSET></Table>';*/
      
      pStatus    := tdvadm.pkg_glb_common.Status_Nomal;      
      --pMessage   := 'Dados do usuário '||vCodigo||' gerado com sucesso!';      
      pMessage   := 'Dados do usuário '||pCodigo||' gerado com sucesso!';
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      --pMessage := 'Erro ao tentar gerar dados do usuário:'||vCodigo||' , '||Sqlerrm;  
      pMessage := 'Erro ao tentar gerar dados do usuário:'||pCodigo||' , '||Sqlerrm;
    End;    
    --pXmlOut := '<Parametros><Output>'     ||              
    --           '<Status>'   ||pStatus     ||'</Status>' ||
    --           '<Message>'  ||pMessage    ||'</Message>'||
    --           '<Tables>'   ||vTblUsuario ||'</Tables>' ||
    --           '</Output></Parametros>';     
  end sp_get_Usuario;                           
  
  procedure sp_verStatusPJ(pCodigo    in  varchar2,
                           pStatusPJ  Out varchar2,           
                           pStatus    Out Char,
                           pMessage   Out Varchar2)
--  Procedure sp_verStatusPJ(pXmlIn   In  Varchar,
--                           pXmlOut  Out Clob,
--                           pStatus  Out varchar2,
--                           pMessage Out Varchar2)
  is
    --vStatusPJ tdvadm.t_usu_usuario.usu_usuario_tppessoa%type;
    --vCodigo   tdvadm.t_usu_usuario.usu_usuario_codigo%type;
  begin
    
    begin     
      --vCodigo := glbadm.pkg_glb_wsinterfacedb.Fn_GetParam(pXmlIn, 'Usuario');
      SELECT NVL(USU_USUARIO_TPPESSOA,'X')
        --into vStatusPJ
        into pStatusPJ
        FROM T_USU_USUARIO
       WHERE 0=0
         --and lower(trim(USU_USUARIO_CODIGO)) = lower(trim(vCodigo));
         and USU_USUARIO_CODIGO = rpad(lower(pCodigo),10);

      --pStatusPJ := vStatusPJ;  
      pStatus   := tdvadm.pkg_glb_common.Status_Nomal;      
      --pMessage  := 'Status PJ do usuário: '||vCodigo||' obtido com sucesso!';    
      pMessage  := 'Status PJ do usuário: '||pCodigo||' obtido com sucesso!';
    Exception 
      when no_data_found then
        pStatus   := 'W';
        --pMessage  := 'Usuario: '||vCodigo||' não localizado, '||Sqlerrm;          
        pMessage  := 'Usuario: '||pCodigo||' não localizado, '||Sqlerrm;
      When Others Then
        pStatus   := tdvadm.pkg_glb_common.Status_Erro;
        --pMessage  := 'Erro ao tentar obter Status PJ para o usuário:'||vCodigo||' , '||Sqlerrm;  
        pMessage  := 'Erro ao tentar obter Status PJ para o usuário:'||pCodigo||' , '||Sqlerrm;
    End;       
    --pXmlOut := '<Parametros><Output>'     ||
    --           '<StatusPJ>' ||vStatusPJ  ||'</StatusPJ>'||
    --           '<Status>'   ||pStatus    ||'</Status>'   ||
    --           '<Message>'  ||pMessage   ||'</Message>'  ||
    --           '</Output></Parametros>';        
  end sp_verStatusPJ;                                                                                
  
  procedure sp_get_CpfUsuario(pCodigo    in  varchar2,
                              pCPF       Out varchar2,           
                              pStatus    Out Char,
                              pMessage   Out Varchar2)
--  Procedure sp_get_CpfUsuario(pXmlIn   In  Varchar,
--                              pXmlOut  Out Clob,
--                              pStatus  Out varchar2,
--                              pMessage Out Varchar2)
  is
    vCodigo tdvadm.t_usu_usuario.usu_usuario_codigo%type;
    vCpf    varchar2(20);    
  begin
    begin     
      
      --vCodigo := glbadm.pkg_glb_wsinterfacedb.Fn_GetParam(pXmlIn, 'Usuario');  
      vCodigo := pCodigo;
    
      SELECT U.USU_USUARIO_CPF
        into vCpf
        FROM T_USU_USUARIO U
       WHERE 0=0 
         and U.USU_USUARIO_CODIGO = rpad(lower(vCodigo),10);
 
      pCpf      := vCpf;         
      pStatus   := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage  := 'Status do usuário: '||vCodigo||' obtido com sucesso!';               
      
    Exception 
      when no_data_found then
        pStatus   := 'W';
        pMessage  := 'Usuario: '||vCodigo||' não localizado, '||Sqlerrm;          
      When Others Then
        pStatus   := tdvadm.pkg_glb_common.Status_Erro;
        pMessage  := 'Erro ao tentar obter Status para o usuário:'||vCodigo||' , '||Sqlerrm;  
    End;  
    
/*    pXmlOut := '<Parametros><Output>'||
               '<Cpf>'    ||vCpf    ||'</Cpf>'    ||
               '<Status>' ||pStatus ||'</Status>' ||
               '<Message>'||pMessage||'</Message>'||
               '</Output></Parametros>';*/
         
  end sp_get_CpfUsuario;                         
  
  procedure sp_get_Rotas(pCodigo    in  varchar2,
                         pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                         pStatus    Out Char,
                         pMessage   Out Varchar2)
  is
    vExist integer;
  begin
    begin
      
      SELECT count(*)
        into vExist
        FROM V_GLB_USUARIOROTA
       WHERE 0=0
         and USU_USUARIO_CODIGO = rpad(lower(pCodigo),10);
         
      if vExist = 0 then
        pStatus  := 'W';      
        pMessage := 'Rotas não localizadas para o usuário: '||pCodigo;
        return;               
      end if;            
    
      open pCursor for
      SELECT GLB_ROTA_CODIGO, 
             GLB_ROTA_DESCRICAO 
        FROM V_GLB_USUARIOROTA v
       WHERE 0=0
         and USU_USUARIO_CODIGO = rpad(lower(pCodigo),10)
         order by 1;
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Rotas obtidas com sucesso para o usuário: '||pCodigo;      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter rotas do usuário:'||pCodigo||' , '||Sqlerrm;  
    End;    
  end sp_get_Rotas; 
  
  procedure sp_StatusFPW(pCpf       in  varchar2,
                         pStatusFpw Out number,           
                         pStatus    Out Char,
                         pMessage   Out Varchar2)  
  is
  begin
    begin
      SELECT COUNT(*)
        into pStatusFpw
        FROM FPW.FUNCIONA F, FPW.SITUACAO S, FPW.LOTACOES L
       WHERE 0=0
         and F.FUCODSITU = S.STCODSITU 
         and F.FUCODLOT = L.LOCODLOT  
         and S.STTIPOSITU <> 'R'     
         and trim(F.FUCPF) = trim(pCpf);
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;           
      pMessage := 'Status FPW para o cpf: '||pCpf||' obtido com sucesso!';
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;  
      pMessage := 'Erro ao tentar obter Status no FPW do cpf:'||pCpf||' , '||Sqlerrm;
    End;          
  end sp_StatusFPW;                         

  procedure sp_get_DescAlteracaoMenu(pDescricao Out varchar2,           
                                     pStatus    Out Char,
                                     pMessage   Out Varchar2)
  is
  begin
    begin
      
      SELECT USU_APLICACAO_DESCALTERACAO 
        into pDescricao
        FROM T_USU_APLICACAO a
       WHERE a.USU_APLICACAO_CODIGO = rpad(lower(pkg_glb_MenuTdv.CODIGO_MENU),10);
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Descrição de alteração do Menu obtida com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter as descrições de alterações do Menu, '||sqlerrm;  
    End;            
  end sp_get_DescAlteracaoMenu;                                     
  
  procedure sp_UpdateUser(pUsuario    in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                          pVersaoMenu in  tdvadm.t_usu_usuario.USU_USUARIO_VERSAOMENU%type,
                          pRamal      in  tdvadm.t_usu_usuario.USU_USUARIO_RAMAL%type,
                          pDepto      in  tdvadm.t_usu_usuario.glb_departamento_codigo%type,
                          pEmail      in  tdvadm.t_usu_usuario.usu_usuario_email%type,
                          pCpf        in  tdvadm.t_usu_usuario.USU_USUARIO_CPF%type,            
                          pStatus     Out Char,
                          pMessage    Out Varchar2)
  is
  begin
    begin
    
      UPDATE T_USU_USUARIO U 
         SET U.USU_USUARIO_VERSAOMENU  = pVersaoMenu,
             U.USU_USUARIO_RAMAL       = pRamal,
             U.GLB_DEPARTAMENTO_CODIGO = pDepto,
             U.USU_USUARIO_EMAIL       = pEmail,
             U.USU_USUARIO_CPF         = pCpf
       WHERE U.USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);      
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Usuário: '||pUsuario||' atualizado com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar atualizar dados do usuario: '||pUsuario||', '||sqlerrm;  
    End;        
  end sp_UpdateUser;                          
                  
  procedure sp_get_DadosUsuario(pUsuario   in  varchar2,
                                pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                                pStatus    Out Char,
                                pMessage   Out Varchar2)
  is
  begin
    begin
      open pCursor for
       SELECT NVL(U.USU_USUARIO_CODIGO,' '),
              NVL(U.USU_USUARIO_VERSAOMENU,' '),
              NVL(U.USU_USUARIO_RAMAL,' '),
              NVL(U.GLB_DEPARTAMENTO_CODIGO,' '),
              NVL(U.USU_USUARIO_EMAIL,' '),
              NVL(U.USU_USUARIO_CPF,' ')           
         FROM T_USU_USUARIO U
        where 0=0
          and USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Dados do Usuário: '||pUsuario||' obtido com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter dados do usuario: '||pUsuario||', '||sqlerrm;  
    End;        
  end sp_get_DadosUsuario;                                
  
  procedure sp_get_Departamentos(pCursor    Out tdvadm.pkg_glb_common.T_CURSOR,           
                                pStatus    Out Char,
                                pMessage   Out Varchar2)
  is
  begin
    begin
      open pCursor for
      SELECT LPAD(TRIM(D.GLB_DEPARTAMENTO_CODIGO), 2,'0') ID,
             D.GLB_DEPARTAMENTO_DESCRICAO DESCRICAO 
        FROM T_GLB_DEPARTAMENTO D
       ORDER BY D.GLB_DEPARTAMENTO_DESCRICAO;

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Lista de Departamento obtida com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter lista de Departamentos, '||sqlerrm;  
    End;        
  end sp_get_Departamentos;  
                
  procedure sp_get_SenhaCriptografada(pUsuario   in  varchar2,
                                      pSenha     Out tdvadm.t_usu_usuario.usu_usuario_senha%type,           
                                      pStatus    Out Char,
                                      pMessage   Out Varchar2)
  is
  begin
    begin
   
     select u.usu_usuario_senha
       into pSenha       
       from t_usu_usuario u 
      where u.usu_usuario_codigo = rpad(lower(pUsuario),10);  
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Senha do usuario: '||pUsuario||' obtida com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter a senha do usuario: '||pUsuario||', '||sqlerrm;  
    End;        
  end sp_get_SenhaCriptografada;                                      
  
  procedure sp_UpdateSenhaUsuario(pUsuario          in  varchar2,            
                                  pNovaSenhaCript   in tdvadm.t_usu_usuario.usu_usuario_senha%type,           
                                  pNovaSenhaDeCript in tdvadm.t_usu_usuario.usu_usuario_senha%type,
                                  pDica             in tdvadm.t_usu_usuario.usu_usuario_dica%type,
                                  pStatus           Out Char,
                                  pMessage          Out Varchar2)
  is
  begin
    begin
      UPDATE T_USU_USUARIO U
         SET U.USU_USUARIO_SENHA = pNovaSenhaCript,
             u.usu_usuario_data_alterasenha = sysdate,
             u.usu_usuario_dica = pDica                       
       WHERE 0=0
         and U.USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);
   
        -- Alterando a Senha
      begin
        execute immediate 'alter user '||pUsuario||' identified by '||pNovaSenhaDeCript; 
        execute immediate 'grant user to '||pUsuario;  
      exception when others then
        pStatus  := tdvadm.pkg_glb_common.Status_Erro;      
        pMessage := 'Erro ao tentar alterar a senha de banco do usuário: '||pUsuario;                
      end;
  
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Senha do usuario: '||pUsuario||' atualizada com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar atualizar a senha do usuario: '||pUsuario||', '||sqlerrm;  
    End;    
  end sp_UpdateSenhaUsuario;                                  
                    
  procedure sp_get_NomeCompleto(pUsuario      in  varchar2,
                                pNomeCompleto Out varchar2,           
                                pStatus       Out Char,
                                pMessage      Out Varchar2)
  is
    vCpf tdvadm.t_usu_usuario.usu_usuario_cpf%type;
  begin
    begin
                
      SELECT nvl(trim(U.USU_USUARIO_CPF),null)
        into vCpf
        FROM T_USU_USUARIO U
       WHERE 0=0 
         and U.USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);
    
      select F.FUNOMFUNC
        into pNomeCompleto
        from fpw.funciona F          
       WHERE 0=0
         and trim(f.fucpf) = trim(vCpf)
         and F.Fudtadmis = (select max(ff.fudtadmis) 
                            from fpw.funciona ff
                            where trim(ff.fucpf) = f.fucpf);
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Nome completo do usuario: '||pUsuario||' obtido com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter o nome completo do usuario: '||pUsuario||', '||sqlerrm;  
    End;    
      
  end sp_get_NomeCompleto;                                                       
  

  procedure sp_get_DataNascimento(pUsuario        in  varchar2,
                                  pDataNascimento Out varchar2,           
                                  pStatus         Out Char,
                                  pMessage        Out Varchar2)
  is
    vCpf tdvadm.t_usu_usuario.usu_usuario_cpf%type;
  begin
    begin
      
      SELECT nvl(trim(U.USU_USUARIO_CPF),null)
        into vCpf
        FROM T_USU_USUARIO U
       WHERE 0=0 
         and U.USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);    
    
      select F.FUDTNASC --to_char(F.FUDTNASC, 'DD/MM/YYYY hh24:MI:ss')
        into pDataNascimento
        from fpw.funciona F          
       WHERE 0=0
         and trim(f.fucpf) = trim(vCpf)
         and F.Fudtadmis = (select max(ff.fudtadmis) 
                            from fpw.funciona ff
                            where trim(ff.fucpf) = f.fucpf);         
                                  
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Data de Nascimento do usuario: '||pUsuario||' obtida com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter a Data de Nascimento do usuario: '||pUsuario||', '||sqlerrm;  
    End;    
      
  end sp_get_DataNascimento;                                                       
                    
  procedure sp_get_DicaSenha(pUsuario in  varchar2,
                             pDica    Out varchar2,           
                             pStatus  Out Char,
                             pMessage Out Varchar2)
  is
  begin
    begin
      SELECT US.USU_USUARIO_DICA
        into pDica
        FROM T_USU_USUARIO US
       WHERE 0=0
         and US.USU_USUARIO_CODIGO = rpad(lower(pUsuario),10)
        GROUP BY US.USU_USUARIO_DICA;
                                           
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Dica de Senha do usuario: '||pUsuario||' obtida com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter a dica de senha do usuario: '||pUsuario||', '||sqlerrm;  
    End;      
  end sp_get_DicaSenha;                        
             
  procedure sp_get_DadosFtp(pVarSisTpCodigo in  tdvadm.t_Usu_Varsis.usu_varsis_tpcodigo%type,
                            pCursor         Out tdvadm.pkg_glb_common.T_CURSOR,           
                            pStatus         Out Char,
                            pMessage        Out Varchar2)
  is
  begin
    begin     
      open pCursor for
      SELECT * 
        FROM T_USU_VARSIS 
       WHERE 0=0
         and USU_VARSIS_TPCODIGO = pVarSisTpCodigo;

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Dados de FTP gerados com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar dados de FTP'||sqlerrm;  
    End;            
  end sp_get_DadosFtp;                                
  

  procedure sp_UpdateMaquina(pComputerName in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                             pUsuario      in tdvadm.t_usu_usuario.usu_usuario_codigo%type,           
                             pStatus     Out Char,
                             pMessage    Out Varchar2)
  is
  begin
    begin
      
      Update t_int_maquinas
         set INT_MAQUINAS_DESCRICAO = pUsuario||' - '||to_char(sysdate, 'DD/MM/YYYY hh24:MI:ss')
       where INT_MAQUINAS_CODIGO = pComputerName;
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Maquina atualizada com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar atualizar a maquina: '||pComputerName||', '||sqlerrm;  
    End;      
  end sp_UpdateMaquina;                            

  procedure sp_UpdateUltimoLogonUsuario(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,          
                                        pStatus  Out Char,
                                        pMessage Out Varchar2)
  is
  begin
    begin
      
      UPDATE T_USU_USUARIO
         SET USU_USUARIO_DATAULTIMOLOGIN = SYSDATE
       WHERE USU_USUARIO_CODIGO = rpad(lower(pUsuario),10); 

      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Ultimo logon do usuario: '||pUsuario||' atualizado com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar atualizar o ultimo login do usuario: '||pUsuario||', '||sqlerrm;  
    End;     
  end sp_UpdateUltimoLogonUsuario;                                        
  
  procedure sp_UpdateApplicationUsuario(pUsuario     in tdvadm.t_usu_usuario.usu_usuario_codigo%type,          
                                        pApplication in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,        
                                        pStatus      Out Char,
                                        pMessage     Out Varchar2)
  is
  begin
    begin
      
      UPDATE T_USU_USUARIOPERFIL a
         SET USU_USUARIOPERFIL_DTULTUTILIZA = SYSDATE
       WHERE a.USU_APLICACAO_CODIGO = rpad(lower(pApplication),10)
         and USU_USUARIO_CODIGO     = rpad(lower(pUsuario),10);

      UPDATE T_USU_APLICACAO
         SET USU_APLICACAO_DTULTUTILIZA = SYSDATE
       WHERE USU_APLICACAO_CODIGO = rpad(lower(pApplication),10);    
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Aplicação: '||pApplication||' atualizado com sucesso para o usuario: '||pUsuario;      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar atualizar a aplicação: '||pApplication||' para o usuario: '||pUsuario||', '||sqlerrm;  
    End;      
  end sp_UpdateApplicationUsuario;                                        
  
  procedure sp_DeleteFavoritesFromDataBase(pUsuario     in tdvadm.t_usu_usuario.usu_usuario_codigo%type,          
                                           pApplication in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,        
                                           pStatus      Out Char,
                                           pMessage     Out Varchar2)
  is
  begin
    begin  
    
      DELETE 
        FROM T_USU_APLICACAOFAVORITA_MNOVO F 
       WHERE F.USU_USUARIO_CODIGO = rpad(lower(pUsuario),10)
         AND F.USU_APLICACAO_CODIGO = rpad(lower(pApplication),10);    
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Aplicação: '||pApplication||' deletada do favoritos para o usuario: '||pUsuario;      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar deletar a aplicação: '||pApplication||' do favoritos para o usuario: '||pUsuario||', '||sqlerrm;  
    End;      
  end;              
  
  procedure sp_GravaAmbienteUsuario(pUsuario  in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                    pStatus   Out Char,
                                    pMessage  Out Varchar2)
  is
    vMaquina tdvadm.t_int_maquinas.int_maquinas_codigo%type;
  begin
    begin
      
      begin
        select a.terminal
          into vMaquina
          from v_glb_ambiente a;
      exception  when no_data_found then
        vMaquina := null;
      end;
    
      delete from t_glb_ambienteusuario au
       where 0=0
         --and lower(trim(au.usuario))  = lower(trim(pUsuario))
         and au.terminal = lower(trim(vMaquina));
      commit;
    
      INSERT INTO tdvadm.t_glb_ambienteusuario(
      select pUsuario usuario,
             a.*
        from v_glb_ambiente a
      );
      commit;
      
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Ambiente do usuário gravado com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar gravar o ambiente do usuario, '||sqlerrm;  
    End;            
  end sp_GravaAmbienteUsuario;                            
                               
  
  procedure sp_get_SituacaoCadastroUsuario(pUsuario   in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                           pSituacao  Out Char,           
                                           pStatus    Out Char,
                                           pMessage   Out Varchar2) 
  is
    vEmail tdvadm.t_usu_usuario.usu_usuario_email%type;
  begin
    begin
      -- Conforme solicitação do Sirlano o email operacional do usuario passa a ser obrigatório
      -- assim toda vez que o usuario tentar logar no sistema será verificado e caso não tenha
      -- email cadastrado na t_usu_usuario será solicitado que o usuario atualize seus dados
      begin
        SELECT nvl(trim(u.usu_usuario_email), null)
          into vEmail
          FROM T_USU_USUARIO U
         where 0=0
           and USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);        
      exception when others then
        vEmail := null;  
      end;
      
      pSituacao := 'N'; -- N = Normal
      if vEmail is null then
         pSituacao := 'E'; -- E = Erro
      end if;
           
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Situação cadastral do usuario verificada com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar verificar situação cadastral do usuario, '||sqlerrm;  
    End;         
  end;                                        
    
  Procedure sp_get_AplicacaoMenuPorModulo(pModulo   in  tdvadm.V_USU_USUARIOPERFIL_MNOVO.USU_MODULO_NOMEMENU%type,
                                          pSistema  in  tdvadm.V_USU_USUARIOPERFIL_MNOVO.USU_SISTEMANOMEMENU_DESCRICAO%type,
                                          pSegmento in  tdvadm.V_USU_USUARIOPERFIL_MNOVO.USU_SEGMENTO_NOMEMENU%type,
                                          pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                          pStatus  Out Char,
                                          pMessage Out Varchar2 )
  as    
  begin  
    
    begin
      open pCursor for
      SELECT distinct v.USU_SEGMENTO_NOMEMENU,
             v.USU_SISTEMANOMEMENU_DESCRICAO,
             v.USU_MODULO_NOMEMENU,
             v.USU_APLICACAO_NOMEMENU,
             v.USU_NIVEL_CODIGO,
             v.USU_APLICACAO_PATH,
             v.USU_APLICACAO_CODIGO, 
             v.USU_APLICACAO_RELPATH, 
             trim(v.USU_APLICACAO_VERSAO) usu_aplicacao_versao,
             v.USU_MODULO_CODIGO,
             v.USU_APLICACAO_URLWEB
        FROM V_USU_USUARIOPERFIL_MNOVO V
      WHERE 0=0
        and V.USU_MODULO_NOMEMENU = lower(trim(pModulo)) 
        and v.USU_NIVEL_CODIGO = (select max(vv.USU_NIVEL_CODIGO)
                                  from V_USU_USUARIOPERFIL_MNOVO vv
                                  where 0=0
                                  and vv.USU_APLICACAO_CODIGO = v.USU_APLICACAO_CODIGO) 
        and v.USU_SEGMENTO_NOMEMENU = pSegmento
        and v.USU_SISTEMANOMEMENU_DESCRICAO = pSistema                                         
      order by 1;          
      
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Lista de AplicacaoMenu gerada com sucesso"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao gerar lista de AplicacaoMenu, '||Sqlerrm;  
    End;
    
  end sp_get_AplicacaoMenuPorModulo;   
    
  procedure sp_get_DadosAdminWindows(pMaquinaCodigo in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                                     pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2 )
  is
  begin    
    begin      
      
      open pCursor for
      select m.int_maquinas_usuarioadmin,
             m.int_maquinas_senhaadmin,
             m.int_maquinas_dominio
      from tdvadm.t_int_maquinas m
      where 0=0
      and upper(trim(m.int_maquinas_codigo)) = upper(trim(pMaquinaCodigo));
    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Dados do Administrador do Windows gerado com sucesso!"';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar obter dados do Administrador do Windows, '||Sqlerrm;  
    End;  
  end sp_get_DadosAdminWindows;                                            




  function fn_vld_AppVersionDB(pAppCod     in tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type,
                               pVersaoApp  in tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type)
     return char
  is
    vVersaoApp tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
    vStatus    char;
    vMessage   Varchar2(200);
  Begin                                  
     sp_get_AppVersionDB(pAppCod,vVersaoApp,vStatus,vMessage);
     if vStatus = pkg_glb_common.Status_Nomal Then
        if trim(vVersaoApp) = trim(pVersaoApp) Then
           return 'S';
        Else
           return 'N';
        End if;
     Else
        return 'ER';   
     End if;          
  End fn_vld_AppVersionDB;

  procedure sp_get_MaquinaInterna(pNomeMaquina in varchar2,
                                  pInterna out char,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2 )
  is
  begin
    begin
      
      select upper(m.int_maquinas_interno)
        into pInterna
        from tdvadm.t_int_maquinas m
       where 0=0
         and trim(upper(m.int_maquinas_codigo)) = trim(upper(pNomeMaquina));
         
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Consulta executada com sucesso!';      
    Exception When Others Then
      pStatus  := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := sqlerrm;  
      pInterna := 'N';
    End;             
  end;                                  

  procedure sp_get_VerificaAtualizacao(pVersaoExeMenu  varchar2,
                                       pVersaoExeLogin varchar2,
                                       pAtualiza      out char, -- S=Existe Atialização, N=Não existe atualização
                                       pStatus  Out Char,
                                       pMessage Out Varchar2 )
  is
    vVersaoDBMenu  tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
    vVersaoDBLogin tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
    vExist boolean;
  begin
    begin
          
      select ap.usu_aplicacao_versao 
        into vVersaoDBMenu
        from tdvadm.t_usu_aplicacao ap
       where 0=0
         and ap.usu_aplicacao_codigo = rpad(lower(pkg_glb_MenuTdv.CODIGO_MENU),10);
         
      select ap.usu_aplicacao_versao 
        into vVersaoDBLogin
        from tdvadm.t_usu_aplicacao ap
       where 0=0
         and ap.usu_aplicacao_codigo = rpad(lower(pkg_glb_MenuTdv.CODIGO_LOGIN),10);
      
      vExist := (trim(pVersaoExeMenu) != trim(vVersaoDBMenu)) or (trim(pVersaoExeLogin) != trim(vVersaoDBLogin));
      
      if vExist then 
        pAtualiza := 'S';
      else 
        pAtualiza := 'N';
      end if;
         
      --insert into tdvadm.dropme(a,x) values('Menu', 
      --'pVersaoExeMenu = '||pVersaoExeMenu||' >>> pVersaoExeLogin: '||pVersaoExeLogin||' >>> pAtualiza: '||pAtualiza);
      --commit;      
      
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Verificação de Atualização executada com sucesso!';      
    Exception When Others Then
      pStatus   := tdvadm.pkg_glb_common.Status_Erro;
      pMessage  := sqlerrm;  
      pAtualiza := 'N';
    End;     
  end sp_get_VerificaAtualizacao;                                       

function fn_DesencriptaSenha(pSenhaCrip varchar2,
                             pRetorno  char default 'F')
  return varchar2
Is
  vSenha       varchar2(20);
  vSenhaPai    varchar2(20);
  vSenhaLimpa  varchar2(40);
  i            number;
  vFimPai      char(1);
  vFimFilho    char(1);
Begin
  vSenhaLimpa := translate(pSenhaCrip,pkg_glb_common.cCaracterInv,pkg_glb_common.cCaracter);
  i := 1;
  vSenha := '';
  vSenhaPai := '';
  vFimPai   := 'N';
  vFimFilho  := 'N';
 
    loop
    exit when ( ( vFimPai || vFimFilho = 'SS' ) or i > length(trim(vSenhaLimpa)) ); 
    
    if ( substr(vSenhaLimpa,i,1) <> '_' )  and ( vFimPai = 'N' ) Then
       vSenhaPai := trim(vSenhaPai) || substr(vSenhaLimpa,i,1);
       i := i + 1;
    Else
       vFimPai := 'S';
    End If;
    if substr(vSenhaLimpa,i,1) = '_'  Then
       i := i + 1;
       vFimPai := 'S';
    End if;
    if ( substr(vSenhaLimpa,i,1) <> ':' ) and ( vFimFilho = 'N' ) Then
       vSenha    := trim(vSenha) || substr(vSenhaLimpa,i,1);
       i := i + 1;
    Else
       vFimFilho := 'S';
    End if;
    if substr(vSenhaLimpa,i,1) = ':'  Then
       i := i + 1;
       vFimFilho := 'S';
    End if;

  end loop;
  if pRetorno = 'F' Then
     return trim(vSenha);
  Else
     return trim(vSenhaPai);
  End if;      
  
End fn_DesencriptaSenha;
  
function fn_EncriptaSenha(pSenha     Varchar2,
                          pSenhaPai  varchar2 default 'AGED12')
   return varchar2                        
is
  vSenhaJunta  varchar2(50);
  i            number;
  vFimPai      char(1);
  vFimFilho    char(1);
Begin
  
  vFimPai   := 'N';
  vFimFilho := 'N';
  vSenhaJunta := '';
  i := 1;
  if length(trim(pSenha)) > 0 Then
    loop
      exit when ( vFimPai || vFimFilho = 'SS');
/*      
 if i <= Length(trim(pSenhaPai)) then
          vSenhaJunta := trim(vSenhaJunta) || substr(pSenhaPai,i,1);
          if i <= length(trim(pSenha)) Then
             vSenhaJunta := trim(vSenhaJunta) || substr(pSenha,i,1);
          end if;   
       Elsif i > Length(trim(pSenhaPai)) then
          vSenhaJunta := trim(vSenhaJunta) || '_' ;
          vSenhaJunta := trim(vSenhaJunta) || substr(pSenha,i);
          exit;
       End if;   
*/
       if i <= Length(trim(pSenhaPai)) then
          vSenhaJunta := trim(vSenhaJunta) || substr(pSenhaPai,i,1);
       Else
          vSenhaJunta := trim(vSenhaJunta) || '_' ;
          vFimPai := 'S';
       End if;

       if i <= length(trim(pSenha)) Then
             vSenhaJunta := trim(vSenhaJunta) || substr(pSenha,i,1);
       Else
             vSenhaJunta := trim(vSenhaJunta) || ':';
             vFimFilho := 'S';
       end if;          
       i := i + 1;
    end loop;
    return translate(trim(vSenhaJunta),pkg_glb_common.cCaracter,pkg_glb_common.cCaracterInv);
  else
    return '';  
  End if;    
  
  
  
End fn_EncriptaSenha;

    function fn_ValidaSenha(pUsuario tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                            pSenha   tdvadm.t_usu_usuario.usu_usuario_senha%type)
      return char
      is
      vTpSenha  tdvadm.t_usu_usuario.usu_usuario_crip%type;
      vSenhaTab tdvadm.t_usu_usuario.usu_usuario_senha%type;
      vSenha    tdvadm.t_usu_usuario.usu_usuario_senha%type;
      
    begin 
      
      begin
          select u.usu_usuario_crip,
                 u.usu_usuario_senha 
            into vTpSenha,
                 vSenhaTab
          from tdvadm.t_usu_usuario u
          where u.usu_usuario_codigo = pUsuario;       
      exception
        when NO_DATA_FOUND Then
           vTpSenha  := null;
           vSenhaTab := null;
      End;   
      
      if nvl(vTpSenha,'NE') = 'C' then
         vSenha := trim(fn_DesencriptaSenha(vSenhaTab,'F'));
         if pSenha = vSenha Then
            return pkg_glb_common.Status_Nomal;
         Else
            return pkg_glb_common.Status_Erro;
         End if;      
      ElsIf nvl(vTpSenha,'NE') = 'NE' then
         return pkg_glb_common.Status_Erro;
      Else
         return pkg_glb_common.Status_Warning;
      END IF;  
      
    End fn_ValidaSenha;                          

  function fn_retornocaracter(p_tipo in char) return char
    is
  Begin
      if p_tipo = 'INV' Then
         return pkg_glb_common.cCaracterInv;
      else
         return pkg_glb_common.cCaracter;
      End if;      
  End;   
      
  procedure sp_AutenticaUsuario(pUsuario     in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                pSenha       in tdvadm.t_usu_usuario.usu_usuario_senha%type,
                                pAutenticado out char,
                                pStatus      out char,
                                pMessage     out varchar2)
  is
  begin    
    /*******************************************************************/
    /* Fabiano - 09/05/2013
    /* Criei uma procedure só pra poder usar as bibliotecas C#
    /* pAutenticado:
    /* S = Sim >>> Autenticado com sucesso
    /* N = Não >>> Não autenticado
    /*******************************************************************/
    begin
      if nvl(pkg_glb_menutdv.fn_ValidaSenha(pUsuario, pSenha),'E') = 'N' then
        pAutenticado := 'S';
        pStatus      := 'N';
        pMessage     := 'Usuário Autenticado com sucesso!';
      else
        pAutenticado := 'N';
        pStatus      := 'W';
        pMessage     := 'Usuário/Senha inválido!';                
      end if;
    exception when others then
      pAutenticado := 'N';
      pStatus      := 'E';
      pMessage     := 'Erro ao autenticar usuário: '||sqlerrm;
    end;
  end sp_AutenticaUsuario;                                
  
  /*********************************************************************************************
  /* Fabiano Góes - 26/07/2013
  /* fiz essa procedure pra unificar a regra das 2 procedures: StatusFpw e StatusPJ
  /*********************************************************************************************/
  procedure sp_PermitirAcessoUsuario(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                     pAcesso  out char, -- S=Acesso Permitido, N=Acesso Negado     
                                     pStatus  out char,
                                     pMessage out varchar2)
  as
    vSituacao varchar2(2000) := ''; -- inicialino pra evitar o null
    vSitFPW   FPW.SITUACAO.STDESCSITU%TYPE := null;
    vExistFPW Boolean := True;
    vDtValidade date;
  begin
    begin
      pAcesso := 'N'; -- inicializo com acesso negado até que se prove contrário
      /*************************************************************************
      /* verifico se o usuário é terceiro ou temporario
      /*************************************************************************/
      begin
        SELECT case NVL(u.USU_USUARIO_TPPESSOA,'X')
                 when 'T' then 'S' -- acesso permitido
                 else 'X' -- acesso negado, será verificado situação no fpw
               end
          into pAcesso
          FROM T_USU_USUARIO u
         WHERE 0=0
           and USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);

      /*************************************************************************
      /* se for Temporario ou Terceiro verifico se o usuário esta valido
      /* Incluido para verfificar validade do usuario em 14/01/2014 Roberto Pariz
      /*************************************************************************/
  
       if pAcesso = 'T' then
        SELECT NVL(u.usu_usuario_dtvalidade,'01/01/0001')
          into vDtValidade
          FROM T_USU_USUARIO u
         WHERE 0=0
           and USU_USUARIO_CODIGO = rpad(lower(pUsuario),10);
     
       if vDtValidade >= trunc(sysdate) then 
            pAcesso := 'S';
          vSituacao := '"Acesso Permitido"'; 
       else 
           pAcesso := 'N';
         vSituacao := '"1-Acesso Negado para o usuário: ['||pUsuario||']" - Situação: Usuário com a Validade Vencida!"';
         end if;
       end if;
     
      exception when no_data_found then
        pAcesso := 'X';
      end;
      
      /*************************************************************************
      /* se não é Temporario ou Terceiro verifico a situação no FPW
      /*************************************************************************/
      if pAcesso = 'X' then
        -- verifica se existe alguma ocorrencia para o Fucnionario
        Begin
            select distinct oc.TPSITU,
                   oc.SITUACAO
               into pAcesso,
                    vSitFPW
            from fpw.ocorfunc ocf,
                 fpw.funciona f,
                 tdvadm.v_fpw_ocorrencia oc,
                 tdvadm.t_usu_usuario u
            where 0 = 0
              and u.usu_usuario_codigo = rpad(trim(pUsuario),10)
              and F.FUCPF = to_number(trim(u.usu_usuario_cpf))
              and f.fumatfunc = ocf.ofmatfunc
              and ocf.ofcodocorr = oc.CODOCOR
              and f.fudtadmis = (select max(f1.fudtadmis)
                                 from fpw.funciona f1
                                 where f1.fucpf = f.fucpf) 
              and to_char(sysdate,'yyyymmdd') between ocf.ofdtinioco + 5 and ocf.ofdtfinoco - 5;
              vExistFPW := True;
              
              vSituacao := case pAcesso when 
                             'S' then '"Acesso Permitido"' 
                             else '"2- Acesso Negado para o usuário: ['||pUsuario||']" - Situação: '||vSitFPW 
                           end;               
              
        exception
          When NO_DATA_FOUND Then
             -- Se não encontrou muda para X e verifica a funciona com a Situação
             pAcesso := 'X';
          when others then
            -- Vou tratar um possivel erro depois 
            pAcesso := 'X'; -- acesso negado
          End;
      End If;
               
      if pAcesso = 'X' then
        begin
          SELECT case COUNT(*)
                   when 0 then 'N' -- acesso negado
                   else 'S' -- acesso permitido
                 end
                 case 
            into pAcesso
            FROM FPW.FUNCIONA F, 
                 FPW.SITUACAO S, 
                 t_usu_usuario u
           WHERE 0=0
             and F.FUCODSITU = S.STCODSITU  
             and S.STTIPOSITU <> 'R'   
             and to_number(trim(F.FUCPF)) = to_number(trim(u.usu_usuario_cpf))
              and f.fudtadmis = (select max(f1.fudtadmis)
                                 from fpw.funciona f1
                                 where f1.fucpf = f.fucpf) 
             and u.usu_usuario_codigo = rpad(lower(pUsuario),10);       
                          
        exception 
          when no_data_found then
            vExistFPW := False;
            pAcesso   := 'N'; -- acesso negado
            pMessage  := 'usuário não localizado no FPW!';                     
          when others then 
            pAcesso := 'N'; -- acesso negado
            raise_application_error(-20001, 'Erro ao validar dados no FPW, '||sqlerrm);
        end;                             
        
      end if;
           
      if ( vExistFPW ) and ( upper(nvl(pAcesso, 'X')) != 'S' ) and ( nvl(vSitFPW,'X') = 'X' )  then
        
        begin
          SELECT s.stdescsitu
            into vSitFPW
            FROM FPW.FUNCIONA F, 
                 FPW.SITUACAO S, 
                 t_usu_usuario u
           WHERE 0=0
             and F.FUCODSITU = S.STCODSITU      
             and to_number(trim(F.FUCPF)) = to_number(trim(u.usu_usuario_cpf))
             and u.usu_usuario_codigo = rpad(lower(pUsuario),10)
             and f.fudtadmis = (select max(f1.fudtadmis)
                                 from fpw.funciona f1
                                 where f1.fucpf = f.fucpf);
                       
        exception when others then
          pAcesso := 'N';
          pStatus := 'E';
          pMessage:= sqlerrm;  
        end;
        
        vSituacao := case pAcesso when 
                        'S' then '"Acesso Permitido"' 
                        else '"3 - Acesso Negado para o usuário: ['||pUsuario||']" - Situação: '||vSitFPW 
                     end;        
      end if;                  
      
      pStatus   := 'N'; 
      pMessage := vSituacao;
              
    exception when others then
      pAcesso  := 'N';
      pStatus  := 'E';
      pMessage := sqlerrm;
    end;
  end sp_PermitirAcessoUsuario;                                     
  
  procedure sp_get_Tarefas(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                           pMaquina in tdvadm.t_int_maquinas.int_maquinas_codigo%type,
                           pCursor  Out tdvadm.pkg_glb_common.T_CURSOR,
                           pStatus  Out Char,
                           pMessage Out Varchar2)
  is
  begin
    begin
      
      open pCursor for
      select 1 ID,
             'TNSNames' Nome,
             'TNSNames' Descricao,
             'tnsnames.ora' ArquivoDownload,
             '' PathLocal,
             'N' Executa,
             pMaquina Maquina,
             pUsuario Usuario,
             'N' Concluido,
             0 Tentativas,
             sysdate DataCadastro,
             null DataConcluido
      from dual;        
      
      pStatus  := 'N'; -- Normal
      pMessage := 'Tarefas obtidas com sucesso!';
    exception when others then
      pStatus  := 'E'; -- Erro
      pMessage := sqlerrm;
    end;
    
  end sp_get_Tarefas;                             
  
  
  procedure sp_Atualiza_Atualizador(pVersaoExeAtu  varchar2,
                                    pAtualiza      out char, -- S=Existe Atialização, N=Não existe atualização
                                    pStatus        Out Char,
                                    pMessage       Out Varchar2 )
  is
    vVersaoDBAtu tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
  begin
   
   begin
          
      select ap.usu_aplicacao_versao 
        into vVersaoDBAtu
        from tdvadm.t_usu_aplicacao ap
       where 0=0
         and ap.usu_aplicacao_codigo = rpad(lower(pkg_glb_MenuTdv.CODIGO_ATUALIZA),10);        
      
      if (trim(pVersaoExeAtu) != trim(vVersaoDBAtu)) then
        pAtualiza:= 'S';
      else
        pAtualiza := 'N';
      end if;
                    
      pStatus  := tdvadm.pkg_glb_common.Status_Nomal;      
      pMessage := 'Verificação de Atualização executada com sucesso!';      
    Exception When Others Then
      pStatus   := tdvadm.pkg_glb_common.Status_Erro;
      pMessage  := sqlerrm;  
      pAtualiza := 'N';
    End;     
    
  end sp_Atualiza_Atualizador;                                       
  
  
  
  procedure sp_executa_login(pUsuario        in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                             pMaquina        in  tdvadm.t_int_maquinas.int_maquinas_codigo%type,                           
                             pVersaoExeMenu  in  varchar2,
                             pVersaoExeLogin in  varchar2,
                             pVersaoExeAtu   in  varchar2,
                             pXmlRetorno     out clob,
                             pStatus         out char,
                             pMessage        out varchar2)
  is 
    vMaquinaValida        char(1) := 'N';
    vPermiteAcesso        char(1) := 'N';    
    pExistAtuMenuLogin    char(1) := 'N';
    pExistAtuAtualizador  char(1) := 'N';
    vPermiteAcessoMessage varchar2(1000);    
    vUsuario              TUsuario;
    vVersaoMenu           tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;    
    vVersaoLogin          tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
    vVersaoAtu            tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
  begin
    begin
      
      /*** Valida Maquina ******************************************************************************/
      sp_ValidateMaquina(pMaquina, vMaquinaValida, pStatus, pMessage);
            
      /*** Grava Ambiente ******************************************************************************/
      sp_GravaAmbienteUsuario(pUsuario, pStatus, pMessage);
      
      /*** Permite acesso Usuário **********************************************************************/
      sp_PermitirAcessoUsuario(pUsuario, vPermiteAcesso, pStatus, vPermiteAcessoMessage);
      
      /*** Verifica atualização para o Menu e Login ****************************************************/
      sp_get_VerificaAtualizacao(pVersaoExeMenu, pVersaoExeLogin, pExistAtuMenuLogin, pStatus, pMessage);
      
      /*** Verifica Atualização do Atualizado **********************************************************/
      sp_Atualiza_Atualizador(pVersaoExeAtu, pExistAtuAtualizador, pStatus, pMessage); 
      
      /*** Atualiza a T_INT_MAQUINAS *******************************************************************/
      sp_UpdateMaquina(pMaquina, pUsuario, pStatus, pMessage);
      
      /*** Atualiza a Aplicação x Usuario **************************************************************/      
      sp_UpdateApplicationUsuario(pUsuario, pkg_glb_MenuTdv.CODIGO_LOGIN, pStatus, pMessage);

      /*** Obtenho as versões das aplicações no banco **************************************************/
      sp_get_AppVersionDB(pkg_glb_MenuTdv.CODIGO_MENU, vVersaoMenu, pStatus, pMessage);      
      sp_get_AppVersionDB(pkg_glb_MenuTdv.CODIGO_LOGIN, vVersaoLogin, pStatus, pMessage);
      sp_get_AppVersionDB(pkg_glb_MenuTdv.CODIGO_ATUALIZA, vVersaoAtu, pStatus, pMessage);
      
      /*** Obtem dados do Usuário **********************************************************************/
      vUsuario := fn_get_Usuario(pUsuario);      
      
      /*** Crio o XML com todos os dados de retorno ****************************************************/
      pXmlRetorno := '';
      pXmlRetorno := pXmlRetorno || '<Parametros>';      
      pXmlRetorno := pXmlRetorno || '<Outputs>';
      pXmlRetorno := pXmlRetorno || '<Output>';                  
      
      pXmlRetorno := pXmlRetorno || '<ValidateMaquina>'||vMaquinaValida||'</ValidateMaquina>';
      pXmlRetorno := pXmlRetorno || '<PermiteAcessoUsuario>'||vPermiteAcesso||'</PermiteAcessoUsuario>';
      pXmlRetorno := pXmlRetorno || '<ExistAtuMenuLogin>'||pExistAtuMenuLogin||'</ExistAtuMenuLogin>';
      pXmlRetorno := pXmlRetorno || '<ExistAtuAtualizador>'||pExistAtuAtualizador||'</ExistAtuAtualizador>';
      pXmlRetorno := pXmlRetorno || '<PermiteAcessoMessage>'||vPermiteAcessoMessage||'</PermiteAcessoMessage>';

      pXmlRetorno := pXmlRetorno || '<VersaoExeMenu>'||pVersaoExeMenu||'</VersaoExeMenu>';
      pXmlRetorno := pXmlRetorno || '<VersaoExeLogin>'||pVersaoExeLogin||'</VersaoExeLogin>';
      pXmlRetorno := pXmlRetorno || '<VersaoExeAtu>'||pVersaoExeAtu||'</VersaoExeAtu>';
      pXmlRetorno := pXmlRetorno || '<VersaoDBMenu>'||vVersaoMenu||'</VersaoDBMenu>';
      pXmlRetorno := pXmlRetorno || '<VersaoDBLogin>'||vVersaoLogin||'</VersaoDBLogin>';
      pXmlRetorno := pXmlRetorno || '<VersaoDBAtu>'||vVersaoAtu||'</VersaoDBAtu>';

      pXmlRetorno := pXmlRetorno || '<USU_USUARIO_CODIGO>'||trim(vUsuario.USU_USUARIO_CODIGO)||'</USU_USUARIO_CODIGO>';
      pXmlRetorno := pXmlRetorno || '<GLB_ROTA_CODIGO>'||trim(vUsuario.GLB_ROTA_CODIGO)||'</GLB_ROTA_CODIGO>';
      pXmlRetorno := pXmlRetorno || '<USU_USUARIO_NOME>'||trim(vUsuario.USU_USUARIO_NOME)||'</USU_USUARIO_NOME>';
      pXmlRetorno := pXmlRetorno || '<USU_USUARIO_TIMEOUT>'||trim(vUsuario.USU_USUARIO_TIMEOUT)||'</USU_USUARIO_TIMEOUT>';
      pXmlRetorno := pXmlRetorno || '<USU_USUARIO_SENHA>'||trim(vUsuario.USU_USUARIO_SENHA)||'</USU_USUARIO_SENHA>';
      pXmlRetorno := pXmlRetorno || '<USU_USUARIO_SENHAEXPIRA>'||trim(vUsuario.USU_USUARIO_SENHAEXPIRA)||'</USU_USUARIO_SENHAEXPIRA>';
      pXmlRetorno := pXmlRetorno || '<USU_VARSIS_TPCODIGO>'||trim(vUsuario.USU_VARSIS_TPCODIGO)||'</USU_VARSIS_TPCODIGO>';
      pXmlRetorno := pXmlRetorno || '<GLB_ROTA_DESCRICAO>'||vUsuario.GLB_ROTA_DESCRICAO||'</GLB_ROTA_DESCRICAO>';
      pXmlRetorno := pXmlRetorno || '<USU_USUARIO_CRIP>'||vUsuario.USU_USUARIO_CRIP||'</USU_USUARIO_CRIP>';
      pXmlRetorno := pXmlRetorno || '<INT_MAQUINAS_USUARIOADMIN>'||vUsuario.INT_MAQUINAS_USUARIOADMIN||'</INT_MAQUINAS_USUARIOADMIN>';
      pXmlRetorno := pXmlRetorno || '<INT_MAQUINAS_SENHAADMIN>'||vUsuario.INT_MAQUINAS_SENHAADMIN||'</INT_MAQUINAS_SENHAADMIN>';
      pXmlRetorno := pXmlRetorno || '<INT_MAQUINAS_DOMINIO>'||vUsuario.INT_MAQUINAS_DOMINIO||'</INT_MAQUINAS_DOMINIO>';
      pXmlRetorno := pXmlRetorno || '<INT_MAQUINAS_INTERNO>'||vUsuario.INT_MAQUINAS_INTERNO||'</INT_MAQUINAS_INTERNO>';      
            
      pXmlRetorno := pXmlRetorno || '</Output>';      
      pXmlRetorno := pXmlRetorno || '</Outputs>';
      pXmlRetorno := pXmlRetorno || '</Parametros>';
      
      pStatus  := 'N';
      pMessage := 'OK';  
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;
    end;
  end sp_executa_login;                             
    
  function fn_get_Usuario(pCodigo in tdvadm.t_usu_usuario.usu_usuario_codigo%type) 
    return TUsuario
  is
    vUsuario       TUsuario;
    vCursorUsuario tdvadm.pkg_glb_common.T_CURSOR;
    vStatus        char(1);
    vMessage       varchar2(1000);
  begin
    
      sp_get_Usuario(pCodigo, vCursorUsuario, vStatus, vMessage);
      LOOP
        FETCH vCursorUsuario
        INTO vUsuario.USU_USUARIO_CODIGO,       
             vUsuario.GLB_ROTA_CODIGO,          
             vUsuario.USU_USUARIO_NOME,         
             vUsuario.USU_USUARIO_TIMEOUT,      
             vUsuario.USU_USUARIO_SENHA,        
             vUsuario.USU_USUARIO_SENHAEXPIRA,  
             vUsuario.USU_VARSIS_TPCODIGO,      
             vUsuario.GLB_ROTA_DESCRICAO,       
             vUsuario.USU_USUARIO_CRIP,         
             vUsuario.INT_MAQUINAS_USUARIOADMIN,
             vUsuario.INT_MAQUINAS_SENHAADMIN,  
             vUsuario.INT_MAQUINAS_DOMINIO,     
             vUsuario.INT_MAQUINAS_INTERNO;
        EXIT WHEN vCursorUsuario%NOtFOUND;
      end loop;  
  
    return vUsuario;  
  end fn_get_Usuario;
  
  function fn_get_UsuVarsis(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type) 
    return TUsuVarSis 
  is
    vUsuVarSis    TUsuVarSis;
    vCodigoVarSis number;
  begin
    
    begin      
      select u.usu_varsis_tpcodigo
      into vCodigoVarSis
      from tdvadm.t_usu_usuario u
      where 0=0
      and u.usu_usuario_codigo = rpad(lower(pUsuario),10);      
    exception when others then
      vCodigoVarSis := 2; -- 2 = externo, caso não consiga obter o código correto
    end;
  
    select v.usu_varsis_tpcodigo,
           v.usu_varsis_ipftp,
           v.usu_varsis_user,
           v.usu_varsis_senha,
           v.usu_varsis_port,
           v.usu_varsis_timeout,
           v.usu_varsis_destinotmp
    into vUsuVarSis.USU_VARSIS_TPCODIGO,
         vUsuVarSis.USU_VARSIS_IPFTP,
         vUsuVarSis.USU_VARSIS_USER,
         vUsuVarSis.USU_VARSIS_SENHA,
         vUsuVarSis.USU_VARSIS_PORT,
         vUsuVarSis.USU_VARSIS_TIMEOUT,
         vUsuVarSis.USU_VARSIS_DESTINOTMP
    from tdvadm.t_usu_varsis v
    where 0=0
    and v.usu_varsis_tpcodigo = nvl(vCodigoVarSis, 2);
    
    return vUsuVarSis;
    
  end;
  
  procedure sp_get_MontaMenu(pUsuario           in  tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                             pCursorSegmentos   out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorSistemas    out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorModulos     out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorAplicacao   out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorFavoritos   out tdvadm.pkg_glb_common.T_CURSOR,
                             pCursorRotaUsuario out tdvadm.pkg_glb_common.T_CURSOR,
                             pXmlRetorno        out Clob,
                             pStatus            out char,
                             pMessage           out varchar2)
  is
    vObjUsuario    TUsuario;
    vObjUsuVarSis  TUsuVarSis;
    vTagUsuario    varchar2(2000);
    vTagMaquina    varchar2(2000);
    vTagVarSis     varchar2(2000);
  begin
    begin
      
      sp_get_SegmentoMenuView(pUsuario, pCursorSegmentos, pStatus, pMessage);
      
      sp_get_SistemaMenuView(pUsuario, pCursorSistemas, pStatus, pMessage);
      
      sp_get_ModuloMenuView(pUsuario, pCursorModulos, pStatus, pMessage);
      
      sp_get_AplicacaoMenuView(pUsuario, pCursorAplicacao, pStatus, pMessage); 
      
      sp_Get_FavoriteFromServer(pUsuario, 'F', pCursorFavoritos, pStatus, pMessage);
      
      sp_get_Rotas(pUsuario, pCursorRotaUsuario, pStatus, pMessage);
      
      vObjUsuario := fn_get_Usuario(pUsuario);     
      vTagUsuario := '<USUARIO>';
      vTagUsuario := vTagUsuario || '<USU_USUARIO_CODIGO>'||trim(vObjUsuario.USU_USUARIO_CODIGO)||'</USU_USUARIO_CODIGO>';
      vTagUsuario := vTagUsuario || '<GLB_ROTA_CODIGO>'||trim(vObjUsuario.GLB_ROTA_CODIGO)||'</GLB_ROTA_CODIGO>';
      vTagUsuario := vTagUsuario || '<USU_USUARIO_NOME>'||trim(vObjUsuario.USU_USUARIO_NOME)||'</USU_USUARIO_NOME>';
      vTagUsuario := vTagUsuario || '<USU_USUARIO_TIMEOUT>'||trim(vObjUsuario.USU_USUARIO_TIMEOUT)||'</USU_USUARIO_TIMEOUT>';
      vTagUsuario := vTagUsuario || '<USU_USUARIO_SENHA>'||trim(vObjUsuario.USU_USUARIO_SENHA)||'</USU_USUARIO_SENHA>';
      vTagUsuario := vTagUsuario || '<USU_USUARIO_SENHAEXPIRA>'||trim(vObjUsuario.USU_USUARIO_SENHAEXPIRA)||'</USU_USUARIO_SENHAEXPIRA>';
      vTagUsuario := vTagUsuario || '<USU_VARSIS_TPCODIGO>'||trim(vObjUsuario.USU_VARSIS_TPCODIGO)||'</USU_VARSIS_TPCODIGO>';
      vTagUsuario := vTagUsuario || '<GLB_ROTA_DESCRICAO>'||vObjUsuario.GLB_ROTA_DESCRICAO||'</GLB_ROTA_DESCRICAO>';
      vTagUsuario := vTagUsuario || '<USU_USUARIO_CRIP>'||vObjUsuario.USU_USUARIO_CRIP||'</USU_USUARIO_CRIP>';
      vTagUsuario := vTagUsuario || '</USUARIO>';
      
      vTagMaquina := '<MAQUINA>';
      vTagMaquina := vTagMaquina || '<INT_MAQUINAS_USUARIOADMIN>'||vObjUsuario.INT_MAQUINAS_USUARIOADMIN||'</INT_MAQUINAS_USUARIOADMIN>';
      vTagMaquina := vTagMaquina || '<INT_MAQUINAS_SENHAADMIN>'||vObjUsuario.INT_MAQUINAS_SENHAADMIN||'</INT_MAQUINAS_SENHAADMIN>';
      vTagMaquina := vTagMaquina || '<INT_MAQUINAS_DOMINIO>'||vObjUsuario.INT_MAQUINAS_DOMINIO||'</INT_MAQUINAS_DOMINIO>';
      vTagMaquina := vTagMaquina || '<INT_MAQUINAS_INTERNO>'||vObjUsuario.INT_MAQUINAS_INTERNO||'</INT_MAQUINAS_INTERNO>';      
      vTagMaquina := vTagMaquina || '</MAQUINA>';
            
      vObjUsuVarSis := fn_get_UsuVarsis(vObjUsuario.USU_USUARIO_CODIGO); 
      vTagVarSis    := '<VARSIS>';
      vTagVarSis    := vTagVarSis  || '<USU_VARSIS_TPCODIGO>'||vObjUsuVarSis.USU_VARSIS_TPCODIGO||'</USU_VARSIS_TPCODIGO>';
      vTagVarSis    := vTagVarSis  || '<USU_VARSIS_IPFTP>'||vObjUsuVarSis.USU_VARSIS_IPFTP||'</USU_VARSIS_IPFTP>';
      vTagVarSis    := vTagVarSis  || '<USU_VARSIS_USER>'||vObjUsuVarSis.USU_VARSIS_USER||'</USU_VARSIS_USER>';      
      vTagVarSis    := vTagVarSis  || '<USU_VARSIS_SENHA>'||vObjUsuVarSis.USU_VARSIS_SENHA||'</USU_VARSIS_SENHA>';      
      vTagVarSis    := vTagVarSis  || '<USU_VARSIS_PORT>'||vObjUsuVarSis.USU_VARSIS_PORT||'</USU_VARSIS_PORT>';            
      vTagVarSis    := vTagVarSis  || '<USU_VARSIS_TIMEOUT>'||vObjUsuVarSis.USU_VARSIS_TIMEOUT||'</USU_VARSIS_TIMEOUT>';      
      vTagVarSis    := vTagVarSis  || '<USU_VARSIS_DESTINOTMP>'||vObjUsuVarSis.USU_VARSIS_DESTINOTMP||'</USU_VARSIS_DESTINOTMP>';      
      vTagVarSis    := vTagVarSis  || '</VARSIS>';
      
      pXmlRetorno := '';
      pXmlRetorno := pXmlRetorno || '<Parametros>';      
      pXmlRetorno := pXmlRetorno || '<Outputs>';
      pXmlRetorno := pXmlRetorno || '<Output>';                  
      pXmlRetorno := pXmlRetorno || vTagUsuario;
      pXmlRetorno := pXmlRetorno || vTagMaquina;
      pXmlRetorno := pXmlRetorno || vTagVarSis;
      pXmlRetorno := pXmlRetorno || '</Output>';      
      pXmlRetorno := pXmlRetorno || '</Outputs>';
      pXmlRetorno := pXmlRetorno || '</Parametros>';     
      
    
      pStatus  := 'N';
      pMessage := 'sucesso!!';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;
    end;  
  end sp_get_MontaMenu;                               

  function fn_get_StatusUsuario(pUsuarioCodigo tdvadm.t_usu_usuario.usu_usuario_codigo%type) 
    return char -- A = Ativo, I = Inativo
  as
    vAcesso  char(1); -- S=Acesso Permitido, N=Acesso Negado
    vStatus  char(1);
    vMessage varchar2(1000);
    vReturn  char(1);
  begin
    
    sp_PermitirAcessoUsuario(pUsuarioCodigo, vAcesso, vStatus, vMessage);
    if vStatus != 'N' then
       raise_application_error(-20001, vMessage);     
    end if;
    
    vReturn := case nvl(vAcesso, 'N')
                 when 'N' then 'I'
                 else 'A'
               end;
    
    return vReturn;
  end fn_get_StatusUsuario;
-- sp_PermitirAcessoUsuario
  
  Procedure sp_CopiaFavorito(pUsuarioOrigem in t_usu_aplicacaofavorita_mnovo.usu_usuario_codigo%type,
                             pUsuarioDestino in t_usu_aplicacaofavorita_mnovo.usu_usuario_codigo%type,
                             pTipo in char,
                             pApagaorigem in char Default 'N',
                             pStatus out Char,
                             pMessage out varchar2) 
                          -- pTipo pode ser:
                          -- S - Sobrepor
                          -- M - Mesclar
                          -- pApagaorigem pode ser
                          -- S - Sim 
                          -- N - Nao 
   is
     vApagaOrigem char(1);
     vAuxiliar number;
   Begin
     pStatus := pkg_glb_common.Status_Nomal;
     pMessage := '';
     if nvl(pTipo,'X') not in ('S','M') then
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := pMessage || 'Tipo da Copia Não Definido use : (S) - Sobrepor e (M) - Mesclar!' || chr(10);
     End If;
     vApagaOrigem := nvl(pApagaorigem,'N');
     if vApagaOrigem not in ('S','N') then
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := pMessage || 'Opção Valida para Apaga na Origem e S ou N !' || chr(10);
     End If;
     
     -- Verifica se os usuarios existem
     select count(*)
       into vAuxiliar
     from t_usu_usuario u
     where u.usu_usuario_codigo =  pUsuarioOrigem;
     if vAuxiliar = 0  Then
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := pMessage || 'Usuario Origem ' || pUsuarioOrigem || ' não existe !' || chr(10);
     End If;

     select count(*)
       into vAuxiliar
     from t_usu_usuario u
     where u.usu_usuario_codigo =  pUsuarioDestino;
     if vAuxiliar = 0  Then
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := pMessage || 'Usuario Destino ' || pUsuarioDestino || ' não existe !' || chr(10);
     End If;

    -- Verifica se a Origem tem Perfil
     select count(*)
       into vAuxiliar
     from t_usu_aplicacaofavorita_mnovo u
     where u.usu_usuario_codigo =  pUsuarioOrigem;
     if vAuxiliar = 0  Then
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := pMessage || 'Usuario Origem ' || pUsuarioOrigem || ' não tem favorito !' || chr(10);
     End If;
     

     if pStatus <> pkg_glb_common.Status_Erro Then
        If pTipo = 'S' Then
           delete t_usu_aplicacaofavorita_mnovo f
           where f.usu_usuario_codigo = pUsuarioDestino;
           pMessage := pMessage || 'Apagou Favoritos antigos do Destino ' || pUsuarioDestino || '!' || chr(10);
        End If;   
        insert into t_usu_aplicacaofavorita_mnovo 
        select f.usu_aplicacao_codigo,
               pUsuarioDestino,
               0,
               0,
               f.usu_aplicacaofavorita_imgindex
        from t_usu_aplicacaofavorita_mnovo f
        where 0 = 0
          and f.usu_usuario_codigo = pUsuarioOrigem
          and 0 = ( select count(*)
                    from t_usu_aplicacaofavorita_mnovo f1
                    where f1.usu_aplicacao_codigo = f.usu_aplicacao_codigo
                      and f1.usu_usuario_codigo = pUsuarioDestino);
        pMessage := pMessage || 'incluiu os novos Favoritos para o Destino ' || pUsuarioDestino || '!' || chr(10);
     End If;     
     if vApagaOrigem = 'S' Then
        delete  t_usu_aplicacaofavorita_mnovo f
        where f.usu_usuario_codigo = pUsuarioOrigem;
        pMessage := pMessage || 'Apagou Favoritos do usuario Origem! ' || pUsuarioOrigem || '!' || chr(10);
     End If;
     if pStatus = pkg_glb_common.Status_Nomal Then
        commit;
     End If;                 
     
   End sp_CopiaFavorito;                          
                          
function fn_get_PermitirAcessoUsuario(pUsuario in tdvadm.t_usu_usuario.usu_usuario_codigo%type) 
    return char
  is
    vAcesso  char(1);
    vStatus  char(1);
    vMessage varchar2(1000);
  begin
    sp_PermitirAcessoUsuario(pUsuario,vAcesso,vStatus,vMessage);
    return vAcesso;
  end fn_get_PermitirAcessoUsuario;

end pkg_glb_MenuTdv;
/
