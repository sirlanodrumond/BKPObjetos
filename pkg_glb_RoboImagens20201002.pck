create or replace package pkg_glb_RoboImagens is

  TYPE T_CURSOR IS REF CURSOR;
  
  procedure sp_CorrigirNumeroNota(pNFOld     in tdvadm.t_glb_nfimagem.con_nftransportada_numnfiscal%type,
                                  pNFNew     in tdvadm.t_glb_nfimagem.con_nftransportada_numnfiscal%type,           
                                  pCNPJ      in tdvadm.t_glb_nfimagem.glb_cliente_cgccpfcodigo%type,
                                  pStatus    out char,
                                  pMessage   out varchar2);

  procedure sp_UpdateControleImagensNF(pNF        in tdvadm.t_glb_controleimagens.numero%type,
                                       pCNPJ      in tdvadm.t_glb_controleimagens.cnpj%type,
                                       pImgStatus in tdvadm.t_glb_controleimagens.imagem%type,
                                       pStatus    out char,
                                       pMessage   out varchar2);
  
  procedure sp_UpdateControleImagensCTRC(pCTRC      in tdvadm.t_glb_controleimagens.numero%type,
                                         pRota      in tdvadm.t_glb_controleimagens.rota%type,
                                         pImgStatus in tdvadm.t_glb_controleimagens.imagem%type,
                                         pStatus    out char,
                                         pMessage   out varchar2);  
  
  procedure sp_GetImgCTRC(pCursor  out T_CURSOR,
                          pStatus  out char,
                          pMessage out varchar2);

  procedure sp_GetImgNF(pCursor  out T_CURSOR,
                        pStatus  out char,
                        pMessage out varchar2);
  
  procedure sp_GetImgVF(pCursor  out T_CURSOR,
                        pStatus  out char,
                        pMessage out varchar2);
  
  procedure sp_GetTpArquivo(pCursor  out T_CURSOR,
                            pStatus  out char,
                            pMessage out varchar2);
                            
  procedure sp_GetParametros(pCursor  out T_CURSOR,
                            pStatus   out char,
                            pMessage  out varchar2);        

  procedure sp_GetAcaoLimpeza(pQueryStr  in  clob,
                              pCursor    out T_CURSOR,
                              pStatus    out char,
                              pMessage   out varchar2);

  procedure sp_ProgramaReprocessa(pQueryStr  in  clob,
                                  pStatus    out char,
                                  pMessage   out varchar2);

  function fn_ExistImagem(pArquivo in varchar2) return clob;                                                
  
  FUNCTION FN_QUERYSTRING(P_QUERYSTRING CHAR,
                          P_SUBSTRING   CHAR,
                          P_IGUAL       CHAR DEFAULT '=',
                          P_SEPARADOR   CHAR DEFAULT '&') RETURN CHAR;
                             
  procedure sp_LimpaBaseImagem(pTipo in char);  

  procedure sp_devolve_chave(P_GRUPO IN VARCHAR2,
                             P_NOMEARQ   IN VARCHAR2,
                             P_RETORNO   OUT VARCHAR2);                           
end pkg_glb_RoboImagens;

 
/
create or replace package body pkg_glb_RoboImagens is

  procedure sp_CorrigirNumeroNota(pNFOld     in tdvadm.t_glb_nfimagem.con_nftransportada_numnfiscal%type,
                                  pNFNew     in tdvadm.t_glb_nfimagem.con_nftransportada_numnfiscal%type,           
                                  pCNPJ      in tdvadm.t_glb_nfimagem.glb_cliente_cgccpfcodigo%type,
                                  pStatus    out char,
                                  pMessage   out varchar2)
  as
  begin
    begin
    Update t_glb_nfimagem n 
       set n.con_nftransportada_numnfiscal = pNFNew
     where n.con_nftransportada_numnfiscal = pNFOld
       and n.glb_cliente_cgccpfcodigo = pCNPJ;
      commit;
         
      pStatus  := 'N';      
      pMessage := 'Numero de nota corrigido com sucesso!';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;
  end sp_CorrigirNumeroNota; 
                                  

  procedure sp_UpdateControleImagensNF(pNF        in tdvadm.t_glb_controleimagens.numero%type,
                                       pCNPJ      in tdvadm.t_glb_controleimagens.cnpj%type,
                                       pImgStatus in tdvadm.t_glb_controleimagens.imagem%type,
                                       pStatus    out char,
                                       pMessage   out varchar2)
  as
  begin
    begin
      Update t_glb_controleimagens
         set imagem = pImgStatus
       where tipo = 'NF'
         and numero = pNF
         and cnpj = pCNPJ;
      commit;
         
      pStatus  := 'N';      
      pMessage := 'Imagem de NF atualizada com sucesso!';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;
  end sp_UpdateControleImagensNF; 

  procedure sp_UpdateControleImagensCTRC(pCTRC      in tdvadm.t_glb_controleimagens.numero%type,
                                         pRota      in tdvadm.t_glb_controleimagens.rota%type,
                                         pImgStatus in tdvadm.t_glb_controleimagens.imagem%type,
                                         pStatus    out char,
                                         pMessage   out varchar2)
  as
  begin
    begin
      Update t_glb_controleimagens
         set imagem = pImgStatus
       where tipo = 'CTRC'
         and numero = pCTRC
         and rota = pRota;
      commit;   
      pStatus  := 'N';      
      pMessage := 'Imagem de CTRC atualizada com sucesso!';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;
  end sp_UpdateControleImagensCTRC;                            


  procedure sp_GetImgCTRC(pCursor  out T_CURSOR,
                          pStatus  out char,
                          pMessage out varchar2)
  as
  begin
    begin
      
      open pCursor for
      select c.con_conhecimento_codigo,                            
             c.con_conhecimento_serie,                             
             c.glb_rota_codigo,                                    
             c.glb_grupoimagem_codigo,                             
             c.glb_tpimagem_codigo,                                
             c.glb_tparquivo_codigo,                               
             c1.con_conhecimento_dtembarque,                       
             c.glb_compimagem_tamanho tamanho,
             c.glb_compimagem_hash,
             c.glb_compimagem_hashb64                      
        from t_glb_compimagem c,                                   
             t_con_conhecimento c1                                 
       where 0=0
         and nvl(c.glb_compimagem_arquivado, 'N') != 'S'           
         and nvl(c.glb_compimagem_expirado, 'N') != 'S' 
         and c.con_conhecimento_codigo = c1.con_conhecimento_codigo
         and c.con_conhecimento_serie = c1.con_conhecimento_serie  
         and trunc(c.glb_compimagem_dtgravacao) >= trunc(sysdate-7)
         and nvl(c.glb_compimagem_tamanho,-1) > 0 
         and c.glb_rota_codigo = c1.glb_rota_codigo;           
          
      pStatus  := 'N';      
      pMessage := 'Lista de imagens CTRC geradas com sucesso';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;
  end sp_GetImgCTRC;                          

  procedure sp_GetImgNF(pCursor  out T_CURSOR,
                        pStatus  out char,
                        pMessage out varchar2)
  as
  begin
    begin
      
      open pCursor for
      select n.con_nftransportada_numnfiscal,         
             n.glb_cliente_cgccpfcodigo,              
             n.glb_grupoimagem_codigo,                
             n.glb_tpimagem_codigo,                   
             n.glb_tparquivo_codigo,                  
             n.glb_nfimagem_dtgravacao,               
             n.glb_nfimagem_tamanho tamanho,
             n.glb_nfimagem_hash,
             n.glb_nfimagem_hashb64           
        from t_glb_nfimagem n                         
       where 0=0
         and trunc(n.glb_nfimagem_dtgravacao) >= trunc(sysdate-7)
         and nvl(n.glb_nfimagem_tamanho,-1) > 0
         and nvl(n.glb_nfimagem_arquivado, 'N') != 'S'
         and nvl(n.glb_nfimagem_expirado, 'N') != 'S';        
          
      pStatus  := 'N';      
      pMessage := 'Lista de imagens NF geradas com sucesso';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;
  end sp_GetImgNF;                          
 
  procedure sp_GetImgVF(pCursor  out T_CURSOR,
                        pStatus  out char,
                        pMessage out varchar2)
  as
  begin
    begin
      
      open pCursor for
      select n.con_conhecimento_codigo,
             n.con_conhecimento_serie,
             n.glb_rota_codigo,
             n.con_valefrete_saque,
             n.glb_vfimagem_codcliente,
             n.glb_grupoimagem_codigo,                
             n.glb_tpimagem_codigo,                   
             n.glb_tparquivo_codigo,                  
             n.glb_vfimagem_dtgravacao,               
             n.glb_vfimagem_tamanho tamanho,
             n.glb_vfimagem_hash,
             n.glb_vfimagem_hashb64           
        from t_glb_vfimagem n                         
       where 0=0
         and trunc(n.glb_vfimagem_dtgravacao) >= trunc(sysdate-7)
         and nvl(n.glb_vfimagem_tamanho,-1) > 0
         and nvl(n.glb_vfimagem_arquivado, 'N') != 'S';        
          
      pStatus  := 'N';      
      pMessage := 'Lista de imagens VF geradas com sucesso';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;
  end sp_GetImgVF;
   
  procedure sp_GetTpArquivo(pCursor  out T_CURSOR,
                            pStatus  out char,
                            pMessage out varchar2)
  as
  begin
    begin
      open pCursor for
      select glb_tparquivo_codigo,    
             glb_tparquivo_extensao,  
             glb_tparquivo_descricao  
        from t_glb_tparquivo;      
          
      pStatus  := 'N';      
      pMessage := 'Lista de tipos de arquivos geradas com sucesso';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;

  end sp_GetTpArquivo;                            

  procedure sp_GetParametros(pCursor  out T_CURSOR,
                            pStatus  out char,
                            pMessage out varchar2)
  as
    vLocalIMG tdvadm.t_usu_perfil.usu_perfil_parat%type;
    vServerFTP tdvadm.t_usu_perfil.usu_perfil_parat%type;
  begin
    begin
      
      select p.usu_perfil_parat
        into vServerFTP
      From t_usu_perfil p
      where p.usu_perfil_codigo = 'SERVFTP';

      select p.usu_perfil_parat
        into vLocalIMG
      From t_usu_perfil p
      where p.usu_perfil_codigo = 'IMAGENSLOCAL';
      
      
      
      open  pCursor for
      select 
        'ACESSOPARAMETRO' ACESSOPARAMETRO,
        'False' EXIBIRINFO,
        '|' || vServerFTP || 'conhecimento\img160\|' || vServerFTP || 'conhecimento\img196\|' || vServerFTP || 'conhecimento\img185\|' || vServerFTP || 'conhecimento\img197\|' || vServerFTP || 'conhecimento\img460\|' || vServerFTP || 'conhecimento\|' || vServerFTP || 'conhecimento\' FONTECAMINHO,
        vLocalIMG IMAGENSLOCAL,
        'N' INDEBUG,
        '1' INTERVALO, -- 1 minuto
        '180' INTERVALO_LIMPEZA, -- 1 = 1 minuto, 60 = 1 hora,  180 = 3 horas
        'S' RUN_ARQUIVA, -- roda processo de arquivamento
        'S' RUN_LIMPEZA, -- roda processo de limpeza
        'oracle-tdp' BANCO,
        'aged12' SENHA,
        'tdvadm' USUARIO,
        '.JPG;.PDF' FILTER_ESTENCAO,
        '.INF' NAO_MEXER,
        'True' VERIFICACTRC,
        'True' VERIFICANF,
        'True' VERIFICAVF
      from dual;
    
      pStatus  := 'N';      
      pMessage := 'Lista de parametros obtida com sucesso';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;
    
  end sp_GetParametros;                            

  procedure sp_GetAcaoLimpeza(pQueryStr  in  clob,
                              pCursor    out T_CURSOR,
                              pStatus    out char,
                              pMessage   out varchar2)
  as
    vExecute      char(1);
    vArquivo      varchar2(1000);
    vDestino      varchar2(2000);    
    vExistDB      char(1);
    vArquivadoDB  char(1);
    vResultExist  clob;
    vTamanhoDisco number;
    vTamanhoDB    number;
    vDataArquivo  varchar2(20);
    vLocalServer  varchar2(2000);
    vDiasArquivo  number;
    vRootDestino  varchar2(2000) := 'C:\Limpeza_RoboImagem\';
    vDiasLimite   integer := 7;
    -- QueryString 
    -- :pquerystr := 'NomeArquivo=nome=NomeArquivo|tipo=String|valor=023528A12610400010002*DataArquivo=nome=DataArquivo|tipo=String|valor=15/02/2012*TamanhoArquivo=nome=TamanhoArquivo|tipo=String|valor=18*';
  begin
    begin  
      /**************************************************************
      / Extraio os parametros da QueryString 
      /**************************************************************/      
      vArquivo      := pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(pQueryStr,'NomeArquivo','=','*'), 'valor', '=', '|');
      vTamanhoDisco := pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(pQueryStr,'TamanhoArquivo','=','*'), 'valor', '=', '|');
      vDataArquivo  := pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(pQueryStr,'DataArquivo','=','*'), 'valor', '=', '|');      
      
      vResultExist  := pkg_glb_roboimagens.fn_ExistImagem(vArquivo);
      vTamanhoDB    := nvl(pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(vResultExist,'TamanhoDB','=','*'), 'valor', '=', '|'),0);
      vLocalServer  := nvl(pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(vResultExist,'LocalServer','=','*'), 'valor', '=', '|'),null);
      vExistDB      := nvl(pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(vResultExist,'ExistDB','=','*'), 'valor', '=', '|'),'N');
      vArquivadoDB  := nvl(pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(vResultExist,'ArquivadoDB','=','*'), 'valor', '=', '|'),'N');
      
      vDiasArquivo  := trunc(sysdate) - to_date(vDataArquivo,'DD/MM/YYYY');
      
     
      /***************************************************************************************
      / Inicializo as variaveis de retorno do cursor antes de aplicar as regras
      / inicializo vExecute=N porque se não entrar em nenhuma regra será devolvido como ação
      / N=None e não será aplicada nenhuma ação para aquele arquivo
      /***************************************************************************************/      
      vExecute := 'N'; -- N = None, não exevuta nenhuma ação
      vDestino := null;   
            
      /***************************************************************************************
      / Regra: "SemCadastro" 
      / # Se Arquivo [não encontrado] na base de dados, 
      / Ação >>> Deve ser deletado do diretório de pesquisa do Robo 
      /***************************************************************************************/      
      if (upper(nvl(vExistDB,'N')) = 'N') and (vDiasArquivo > 1) then -->> Não existe registro dessa imagem no banco
        begin
          vExecute := 'D'; -- D = Deleta arquivo no servidor, M = Move arquivo na origem para uma pasta de destino passada no campo destino
          vDestino := vRootDestino||'SemCadastro\';
          pStatus  := 'N';      
          pMessage := 'Arquivo [não localizado] na base de dados';     
        end;
              
      /***************************************************************************************
      / Regra: "Expiradas"
      / >>> se chegou neste teste é porque existe bi banco <<<
      / # Se Existe o registro no banco, 
      / # A imagem em disco já atingiu o limite de dias de criação
      / Ação >>> o arquivo deve ser movido para a pasta: "Expiradas"   
      /***************************************************************************************/
      elsif (vDiasArquivo > vDiasLimite) then ------------------------>> A imagem em disco já atingiu o tempo limite  
        begin                                                        
          vExecute := 'D'; -- D = Deleta arquivo no servidor 
          vDestino := vRootDestino||'Expiradas\';
          pStatus  := 'N';      
          pMessage := 'Arquivo [localizado] na base de dados, porem já atingiu o tempo limite da criação do arquivo';            
        end;       
                          
      /***************************************************************************************
      / Regra: "Incompletas"
      / # Se Existe o registro no banco, 
      / # Se o tamanho da imagem em disco for [menor] que no banco(com uma margem de 10%) e
      / # A imagem em disco já atingiu o limite de dias de criação
      / Ação >>> o arquivo deve ser movido para a pasta: "Incompletas"
      /***************************************************************************************/
      elsif (upper(nvl(vExistDB,'N')) = 'S') and ------------------->> Existe no banco
            (vTamanhoDisco < vTamanhoDB - (vTamanhoDB / 100)) and -->> O tamanho em disco [não] confere com o tamanho em banco
            (vDiasArquivo > vDiasLimite) then ---------------------->> A imagem em disco já atingiu o tempo limite                           
        begin
          vExecute := 'D'; -- D = Deleta arquivo no servidor, M = Move arquivo na origem para uma pasta de destino passada no campo destino
          vDestino := vRootDestino||'Incompletas\';
          pStatus  := 'N';      
          pMessage := 'Arquivo [localizado] na base de dados porém com tamanho incompleto em disco';                                
        end;             
        
      /***************************************************************************************
      / Regra: "Arquivada"
      / # Se Existe o registro no banco, 
      / # Se o tamanho da imagem em disco for [igual] que no banco(com uma margem de 10%) e
      / # Se a Flag se arquivo for igual "S"
      / # Se o campo "LocalServer" estiver preenchidou
      / Ação >>> deve ser verificado na Path "LocalServer" se existe a imagem
      /      >>> se não existir, atualizar a tabela para "Reprocessamento"    
      /***************************************************************************************/
      elsif (vExistDB = 'S') and ------------------------------------->> Existe no banco
            (vTamanhoDisco >= vTamanhoDB - (vTamanhoDB / 100))  and -->> O tamanho da imagem em disco confere com o tamento em banco 
            (vArquivadoDB = 'S') and -------------------------------->> Flag de arquivo = S
            (vLocalServer is not null) then ----------------------->> Path da imagem ok no banco
            --(vDiasArquivo > vDiasLimite) then ---------------------->> A imagem em disco já atingiu o tempo limite  
        begin                                                        
          vExecute := 'A'; -- A = Arquivadas - será executada uma verificação se a amagem existe no destivo, se existir será movida da origem para arquivadas 
          vDestino := vRootDestino||'Arquivadas\';
          pStatus  := 'N';      
          pMessage := 'Arquivo [localizado] na base de dados, deve ser movida para arquivadas';            
        end;
        
      /***************************************************************************************
      / Regra: "Reprocessa"
      / # Se Existe o registro no banco, 
      / # Se o tamanho da imagem em disco for [igual] que no banco(com uma margem de 10%) e
      / # Se a Flag se arquivo for igual "S"
      / # Se o campo "LocalServer" estiver preenchido
      / Ação >>> deve ser verificado na Path "LocalServer" se existe a imagem
      /      >>> se não existir, atualizar a tabela para "Reprocessamento"    
      /***************************************************************************************/
      elsif (vExistDB = 'S') and ------------------------------------->> Existe no banco
            (vTamanhoDisco >= vTamanhoDB - (vTamanhoDB / 100))  and -->> O tamanho da imagem em disco confere com o tamento em banco 
            ((vArquivadoDB != 'S') or (vLocalServer is null)) then --->> Flag de arquivado != S ou Path da imagem ok no banco
            --(vDiasArquivo > vDiasLimite) then ---------------------->> A imagem em disco já atingiu o tempo limite  
        begin                                                        
          vExecute := 'R'; -- R = Reprocessar
          vDestino := vRootDestino||'Reprocessar\';
          pStatus  := 'N';      
          pMessage := 'Arquivo [localizado] na base de dados, Deve executar o reprocessamento';            
        end;        
        
      /***************************************************************************************
      / Regra: "Nenhuma"
      / Se não encontrou em nenhuma condição de regra
      / Ação >>> N=None e não será aplicada nenhuma ação para aquele arquivo
      /***************************************************************************************/                      
      else   
        vExecute := 'N'; -- N = None, não executa nenhuma ação
        vDestino := null;        
        pStatus  := 'N';      
        pMessage := 'Nenhuma regra pré-definida pra este arquivo';                      
      end if;
    
      open pCursor for
      select vExecute ExecuteAcao,
             vDestino DestinoArquivo,
             vLocalServer LocalServer
        from dual;          
      
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm;  
    end;  
  end sp_GetAcaoLimpeza;                              


  /**************************************************************
  / Retorno uma QueryString com algumas informações,
  / se Existe gravo na querystring os dados do registro
  /**************************************************************/
  function fn_ExistImagem(pArquivo in varchar2) 
    return clob 
  as
    vQryStr       clob;
    vExist        char(1); -- S=Existe, N=Não Existe, E=Erro
    vCount        integer;
    vPINI         integer;
    vSize         integer;
    vSelect       varchar2(2000);
    vSQL          varchar2(2000);
    vWhere        varchar2(2000);
    vCampoNome    varchar2(1000);
    vCampoValue   varchar2(1000);
    vTamanhoDB    number;
    vArquivadoDB  char(1);
    vLocalServer  varchar2(2000);
    vPrefixoCampo varchar2(100);
    vTpArquivo    tdvadm.t_glb_tparquivo.glb_tparquivo_codigo%type;
    vTpImagem     tdvadm.t_glb_tpimagem.glb_tpimagem_codigo%type;
    vGrupoImagem  tdvadm.t_glb_keyimagem.glb_grupoimagem_codigo%type;
    vTableName    varchar2(1000);
  begin  
    vExist := 'N';    
    begin
      vTpArquivo   := nvl(substr(pArquivo,-4,4),'N');
      vTpImagem    := nvl(substr(pArquivo,-8,4),'N');
      vGrupoImagem := nvl(substr(pArquivo,-10,2),'N');
                              
      dbms_output.put_line('vTpArquivo = '||vTpArquivo);
      dbms_output.put_line('vTpImagem = '||vTpImagem);
      dbms_output.put_line('vGrupoImagem = '||vGrupoImagem);
      
      if vTpArquivo = 'N' or vTpImagem = 'N' or vGrupoImagem = 'N' then
        vExist := 'N';  
      else
        begin
          /**************************************************************
          / ***** Busco o nome da tabela que deve ser pesquisado
          /**************************************************************/
          begin
            select gi.glb_grupoimagem_tablename
              into vTableName      
              from tdvadm.t_glb_grupoimagem gi
             where 0=0
               and gi.glb_grupoimagem_codigo = vGrupoImagem;
          exception when no_data_found then
            vExist     := 'N';  
            vTableName := null;
            vCount     := 0;
          end;
          
          if vTableName is not null then                      
            /**************************************************************
            / ***** Monto o Prefixo do nome de campo 
            /**************************************************************/
            vPrefixoCampo := Replace(vTableName, 'T_', '') || '_';
            
            /**************************************************************
            / ***** Monto o bloco de select do SQL
            /**************************************************************/      
            vSelect := '';
            vSelect := vSelect||'select count(*), ';
            vSelect := vSelect||'       '||vPrefixoCampo||'TAMANHO, ';
            vSelect := vSelect||'       '||vPrefixoCampo||'ARQUIVADO, ';
            vSelect := vSelect||'       '||vPrefixoCampo||'LOCALSERVIDOR ';
            vSelect := vSelect||'  from '||vTableName;
            vSelect := vSelect||' where 0=0 ';      
                   
            /**************************************************************
            / ***** Monto o bloco Where do SQL
            /**************************************************************/      
            vWhere := null;
            for item in (      
            select ki.glb_keyimagem_campo, ki.glb_keyimagem_pini, ki.glb_keyimagem_size
              from tdvadm.t_glb_keyimagem ki
             where 0=0 
               and ki.glb_grupoimagem_codigo = vGrupoImagem
             order by ki.glb_grupoimagem_ordem )
            loop
              vPINI      := item.glb_keyimagem_pini;
              vSize      := item.glb_keyimagem_size;
              vCampoNome := item.glb_keyimagem_campo;
              vCampoValue:= substr(pArquivo, vPini, vSize);
              vWhere := vWhere||' and '||vCampoNome||' = '''||vCampoValue||'''';  
            end loop;
            
            /**************************************************************
            / ***** Monto o Select completo que será executado para pesquisa
            /**************************************************************/            
            vSQL := '';
            vSQL := vSQL||vSelect ||' ';
            vSQL := vSQL||vWhere  ||' ';
            vSQL := vSQL||' and glb_grupoimagem_codigo = '''||vGrupoImagem||'''';
            vSQL := vSQL||' and glb_tpimagem_codigo    = '''||vTpImagem   ||'''';
            vSQL := vSQL||' and glb_tparquivo_codigo   = '''||vTpArquivo  ||'''';  
            vSQL := vSQL||'group by '||vPrefixoCampo||'TAMANHO, ';
            vSQL := vSQL||'         '||vPrefixoCampo||'ARQUIVADO, ';
            vSQL := vSQL||'         '||vPrefixoCampo||'LOCALSERVIDOR';
                                
            Dbms_Output.put_line(vSQL);   
            begin     
              execute immediate vSQL 
              into vCount,
                   vTamanhoDB,
                   vArquivadoDB,
                   vLocalServer;
            exception when no_data_found then
              vCount := 0;   
              vExist := 'N';
            end;
            
          end if; -- if vTableName is not null then
          
        end; -- end begin
        
        if vCount > 0 then 
          vExist := 'S'; 
        else 
          vExist := 'N'; 
        end if;         
        
      end if;           
      
      vQryStr := '';
      vQryStr := vQryStr||'ExistDB=nome=ExistDB|tipo=String|valor='||vExist||'*';
      vQryStr := vQryStr||'TamanhoDB=nome=TamanhoDB|tipo=String|valor='||vTamanhoDB||'*';
      vQryStr := vQryStr||'ArquivadoDB=nome=ArquivadoDB|tipo=String|valor='||vArquivadoDB||'*';
      vQryStr := vQryStr||'LocalServer=nome=LocalServer|tipo=String|valor='||vLocalServer||'*';
               
    exception when others then
      dbms_output.put_line('ERRO >> '||sqlerrm);
    end;
    
    return vQryStr;
  end fn_ExistImagem;   
  
  procedure sp_ProgramaReprocessa(pQueryStr  in  clob,
                                  pStatus    out char,
                                  pMessage   out varchar2)
  as
    vTpArquivo    tdvadm.t_glb_tparquivo.glb_tparquivo_codigo%type;
    vTpImagem     tdvadm.t_glb_tpimagem.glb_tpimagem_codigo%type;
    vGrupoImagem  tdvadm.t_glb_keyimagem.glb_grupoimagem_codigo%type;  
    vArquivo      varchar2(1000);
    vTableName    varchar2(1000);
    vUpdate       varchar2(2000);
    vSQL          varchar2(2000);
    vWhere        varchar2(2000);
    vCampoNome    varchar2(1000);
    vCampoValue   varchar2(1000);   
    vPrefixoCampo varchar2(100);
    vPINI         integer;
    vSize         integer;     
  begin
    begin
      vArquivo      := pkg_glb_roboimagens.fn_querystring(pkg_glb_roboimagens.fn_querystring(pQueryStr,'NomeArquivo','=','*'), 'valor', '=', '|');
      
      vTpArquivo   := substr(vArquivo,-4,4);      
      vTpImagem    := substr(vArquivo,-8,4);
      vGrupoImagem := substr(vArquivo,-10,2);      
      
      /**************************************************************
      / ***** Busco o nome da tabela que deve ser pesquisado
      /**************************************************************/
      select gi.glb_grupoimagem_tablename
        into vTableName      
        from tdvadm.t_glb_grupoimagem gi
       where 0=0
         and gi.glb_grupoimagem_codigo = vGrupoImagem;      
      
      /**************************************************************
      / ***** Monto o Prefixo do nome de campo 
      /**************************************************************/
      vPrefixoCampo := Replace(vTableName, 'T_', '') || '_';
      
      /**************************************************************
      / ***** Monto o bloco de update
      /**************************************************************/      
      vUpdate := '';
      vUpdate := vUpdate||'update '||vTableName;
      vUpdate := vUpdate||'   set '||vPrefixoCampo||'ARQUIVADO = null, ';
      vUpdate := vUpdate||'       '||vPrefixoCampo||'LOCALSERVIDOR = null, ';
      vUpdate := vUpdate||'       '||vPrefixoCampo||'EXPIRADO = ''N''';
      vUpdate := vUpdate||' where 0=0 ';     
      
      /**************************************************************
      / ***** Monto o bloco Where do update
      /**************************************************************/      
      vWhere := null;
      for item in (      
      select ki.glb_keyimagem_campo, ki.glb_keyimagem_pini, ki.glb_keyimagem_size
        from tdvadm.t_glb_keyimagem ki
       where 0=0 
         and ki.glb_grupoimagem_codigo = vGrupoImagem
       order by ki.glb_grupoimagem_ordem )
      loop
        vPINI      := item.glb_keyimagem_pini;
        vSize      := item.glb_keyimagem_size;
        vCampoNome := item.glb_keyimagem_campo;
        vCampoValue:= substr(vArquivo, vPini, vSize);
        vWhere := vWhere||' and '||vCampoNome||' = '''||vCampoValue||'''';  
      end loop;      
           
      /**************************************************************
      / ***** Monto o update completo que será executado
      /**************************************************************/            
      vSQL := '';
      vSQL := vSQL||vUpdate ||' ';
      vSQL := vSQL||vWhere  ||' ';
      vSQL := vSQL||' and glb_grupoimagem_codigo = '''||vGrupoImagem||'''';
      vSQL := vSQL||' and glb_tpimagem_codigo    = '''||vTpImagem   ||'''';
      vSQL := vSQL||' and glb_tparquivo_codigo   = '''||vTpArquivo  ||'''';  
                          
      Dbms_Output.put_line(vSQL);        
      execute immediate vSQL;      
            
      pStatus  := 'N';
      pMessage := 'Imagem programada para reprocessamento';
    exception when others then
      pStatus  := 'E';
      pMessage := sqlerrm; 
    end;
  end sp_ProgramaReprocessa;                     
    
  
  FUNCTION FN_QUERYSTRING(P_QUERYSTRING CHAR,
                          P_SUBSTRING   CHAR,
                          P_IGUAL       CHAR DEFAULT '=',
                          P_SEPARADOR   CHAR DEFAULT '&')
  RETURN CHAR IS
    V_INICIOQSTRING INTEGER;
    V_FIMQSTRING INTEGER;
    V_IGUALQSTRING INTEGER;
    V_TAMQSTRING INTEGER;
  BEGIN
    V_INICIOQSTRING := INSTR(P_QUERYSTRING,P_SUBSTRING);

    IF V_INICIOQSTRING > 0  THEN
        V_IGUALQSTRING := INSTR(P_QUERYSTRING,P_IGUAL,V_INICIOQSTRING);
        V_FIMQSTRING := INSTR(P_QUERYSTRING,P_SEPARADOR,V_IGUALQSTRING);
        IF V_FIMQSTRING = 0 THEN
           V_FIMQSTRING := LENGTH(P_QUERYSTRING) + 1;
        END IF;   
        V_TAMQSTRING := V_FIMQSTRING - V_IGUALQSTRING;
        RETURN SUBSTR(P_QUERYSTRING,V_IGUALQSTRING + 1,V_TAMQSTRING-1);
    ELSE
      RETURN '';
    END IF;    
  End FN_QUERYSTRING;  


  /********************************************************************
  * pTipo = E=Expriradas, D=Deletar, A=Ambas, N=Nenhum
  ********************************************************************/
  procedure sp_LimpaBaseImagem(pTipo in char)
  as
    vDiasExpirado integer := 7;
    vDiasDeleta   integer := 7;
  begin
    begin
      
      /**********************************/
      /*** Altera flag para expiradas ***/
      /**********************************/
      if nvl(pTipo,'N') in ('A','E') then
        
        /*** Notas ***/
        update t_glb_nfimagem nf
           set nf.glb_nfimagem_expirado = 'S'
         where 0=0
           and (trunc(sysdate) - trunc( nf.glb_nfimagem_dtgravacao )) > vDiasExpirado
           and nf.glb_nfimagem_tamanho <= 0
           and nvl(nf.glb_nfimagem_arquivado,'N') = 'N'
           and nvl(nf.glb_nfimagem_expirado,'N') = 'N';         
        commit;
        
        /*** CTRC ***/
        update t_glb_compimagem ci
           set ci.glb_compimagem_expirado = 'S'
         where 0=0
           and (trunc(sysdate) - trunc( ci.glb_compimagem_dtgravacao )) > vDiasExpirado
           and ci.glb_compimagem_tamanho <= 0
           and nvl(ci.glb_compimagem_arquivado,'N') = 'N'
           and nvl(ci.glb_compimagem_expirado,'N') = 'N';  
        commit;  
        
        /*** VF ***/
        update t_glb_vfimagem vi
           set vi.glb_vfimagem_expirado = 'S'
         where 0=0
           and (trunc(sysdate) - trunc( vi.glb_vfimagem_dtgravacao )) > vDiasExpirado
           and vi.glb_vfimagem_tamanho <= 0
           and nvl(vi.glb_vfimagem_arquivado,'N') = 'N'
           and nvl(vi.glb_vfimagem_expirado,'N') = 'N';  
        commit;                
        
      end if;
                 
      /**********************************/
      /*** Deleta registros *************/
      /**********************************/
      if nvl(pTipo,'N') in ('A','D') then
        
        /*** Notas ***/
        delete from t_glb_nfimagem nf
         where 0=0
           and (trunc(sysdate) - trunc( nf.glb_nfimagem_dtgravacao )) > vDiasDeleta
           and nf.glb_nfimagem_tamanho <= 0
           and nvl(nf.glb_nfimagem_arquivado,'N') = 'N'
           and nvl(nf.glb_nfimagem_expirado,'N') = 'S';         
        commit;
        
        /*** CTRC ***/
        delete from t_glb_compimagem ci
         where 0=0
           and (trunc(sysdate) - trunc( ci.glb_compimagem_dtgravacao )) > vDiasDeleta
           and ci.glb_compimagem_tamanho <= 0
           and nvl(ci.glb_compimagem_arquivado,'N') = 'N'
           and nvl(ci.glb_compimagem_expirado,'N') = 'S';  
        commit; 
        
        /*** VF ***/
        delete from t_glb_vfimagem vi
         where 0=0
           and (trunc(sysdate) - trunc( vi.glb_vfimagem_dtgravacao )) > vDiasDeleta
           and vi.glb_vfimagem_tamanho <= 0
           and nvl(vi.glb_vfimagem_arquivado,'N') = 'N'
           and nvl(vi.glb_vfimagem_expirado,'N') = 'S';  
        commit;         
        
      end if;      
          
    exception when others then
      tdvadm.pkg_glb_log.sp_GravaLog(sqlerrm,'roboimagem');
    end;
  end;
  
  procedure sp_devolve_chave(P_GRUPO IN VARCHAR2,
                             P_NOMEARQ   IN VARCHAR2,
                             P_RETORNO   OUT VARCHAR2)
   
  AS 
  vConhecimento tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
  vChave1 TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  vChave2 TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  vChave3 TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE;
  vChave4 TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
  vChave5 TDVADM.T_GLB_VFIMAGEM.GLB_VFIMAGEM_CODCLIENTE%TYPE;
  vChave6 TDVADM.T_CON_NFTRANSPORTA.CON_NFTRANSPORTADA_NUMNFISCAL%TYPE;
  vChave7 TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  vChaveRetorno TDVADM.T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CHAVESEFAZ%TYPE;
  vChaveRetorno2 TDVADM.T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CHAVESEFAZ%TYPE;
  vExisteValeFrete integer;
  BEGIN
     -- exemplo de nome 
     --099505A1170040001000202
     
     
    -- vale frete 
    --conhecimento
    --serie
    --rota
    --saque
    --sequencia
    
    -- PARAMETRO - P_GRUPO
    -- 04 - CONHECINEMTO   - T_GLB_COMPIMAGEM
    -- 05 - NOTA FISCAL    - T_GLB_NFIMAGEM
    -- 10 - COMPR ESTADIA  - T_GLB_VFIMAGEM
    -- 11 - OUTROS COMPROV - T_GLB_VFIMAGEM
    
    if NVL(P_NOMEARQ, 'X') = 'X' THEN
      P_RETORNO := '';
      RETURN;
    END IF;          
    
    IF NVL(P_GRUPO, 'X') <> 'X' THEN
      IF P_GRUPO = '04' THEN -- CONHECIMENTO --099505A1170040001000202
          vChave1 := substr(P_NOMEARQ, 1, 6); -- CONHECIMENTO
          vChave2 := substr(P_NOMEARQ, 7, 2); -- SERIE
          vChave3 := substr(P_NOMEARQ, 9, 3); -- ROTA
    
          BEGIN
            SELECT N.CON_CONTROLECTRCE_CHAVESEFAZ,
                   C.CON_CONHECIMENTO_CODIGO || C.CON_CONHECIMENTO_SERIE || C.GLB_ROTA_CODIGO
              INTO vChaveRetorno,
                   vChaveRetorno2
            FROM TDVADM.T_CON_CONHECIMENTO C, TDVADM.T_CON_CONTROLECTRCE N
            WHERE C.CON_CONHECIMENTO_CODIGO = N.CON_CONHECIMENTO_CODIGO (+)
              AND C.CON_CONHECIMENTO_SERIE = N.CON_CONHECIMENTO_SERIE (+)
              AND C.GLB_ROTA_CODIGO = N.GLB_ROTA_CODIGO (+)
              AND C.CON_CONHECIMENTO_CODIGO = vChave1
              AND C.CON_CONHECIMENTO_SERIE = vChave2
              AND C.GLB_ROTA_CODIGO = vChave3;
              
              P_RETORNO := NVL(vChaveRetorno,vChaveRetorno2);
              
          EXCEPTION WHEN no_data_found THEN    
            P_RETORNO := '';
          END;
          
      ELSIF (P_GRUPO = '05') THEN
        BEGIN -- numero nota, cnpj, serie
          --05
          -- caminho onde estao gravadas as imagens
          --\\stnas01\Backups\imagens\05 
          --35200566617499000199550010000040821201290388
          --na tabela t_glb_keyimagem esta 1, 7 
          --porem fazendo teste vi que esta pegando um numero do cnpj por isso diminui um numero
          vChave6 := substr(P_NOMEARQ, 1, 6); -- NUMNFISCAL 
          --na tabela esta t_glb_keyimagem 7, 14 
          --porem fazendo teste vi que esta pegando um numero do cnpj por isso diminui um numero
          vChave7 := substr(P_NOMEARQ, 7, 14); -- CNPJ
          
          SELECT C.CON_NFTRANSPORTADA_CHAVENFE
            INTO vChaveRetorno
          FROM T_CON_NFTRANSPORTA C
          WHERE substr(C.CON_NFTRANSPORTADA_NUMNFISCAL,-6) = vChave6
            AND lpad(trim(C.GLB_CLIENTE_CGCCPFCODIGO), 14, '0') =
                lpad(trim(vChave7), 14, '0');           
                
          P_RETORNO := vChaveRetorno;
              
          EXCEPTION WHEN no_data_found THEN    
            P_RETORNO := '';
          END;        
        
      ELSIF (P_GRUPO = '10') OR (P_GRUPO = '11') THEN
        BEGIN 
          --10
          --332293A10113A1000010002          
          --11
          --032874A12371A1100010002
          vChave1 := substr(P_NOMEARQ, 1, 6); -- CONHECIMENTO
          vChave2 := substr(P_NOMEARQ, 7, 2); -- SERIE
          vChave3 := substr(P_NOMEARQ, 9, 3); -- ROTA
          vChave4 := substr(P_NOMEARQ, 12, 1); -- SAQUE
          vChave5 := substr(P_NOMEARQ, 13, 1); -- SEQUENCIA
          
          
          select count(*)
           into vExisteValeFrete
           from t_con_valefrete vf
          where vf.con_conhecimento_codigo = vChave1
            and vf.con_conhecimento_serie  = vChave2
            and vf.glb_rota_codigo         = vChave3
            and vf.con_valefrete_saque     = vChave4
            and vf.con_catvalefrete_codigo = vChave5
            and nvl(vf.con_valefrete_status,'N') = 'N';


         if (vExisteValeFrete > 0) then
            P_RETORNO := vChave1 || vChave2 || vChave3 || vChave4 || vChave5 ;
         else
            P_RETORNO := '';
         end if;
           
          -- + vSequencia
              
          EXCEPTION WHEN no_data_found THEN    
            P_RETORNO := '';
          END;
                          
      END IF;
    END IF;
    
    --P_RETORNO := '01234567890123456789012345678901234567890123';
  END sp_devolve_chave;
--Begin
--  EXECUTE IMMEDIATE('ALTER SESSION SET NLS_DATE_FORMAT="DD/MM/YYYY"');     
end pkg_glb_RoboImagens;
/
