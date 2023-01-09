create or replace package pkg_fifo_ctrc is

---------------------------------------------------------------------------------------------------------------
-- PROCEDURE UTILIZADA PARA POPULAR O GRID PRINCIPAL DA ABA DO CTRC.                                         --
--------------------------------------------------------------------------------------------------------------- 

QtdeDiasDisp Integer := 10;

Procedure sp_AtualizaGridCtrc( pParamsEntrada In Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2,
                                 pParamsSaida   Out Clob 
                               );                         
                               
Function FNP_Xml_ListaVeicContratados( pCodArmazem tdvadm.t_arm_armazem.arm_armazem_codigo%Type) Return pkg_fifo.tRetornoFunc;
                               
Function Fn_GetIndex_ImgEstagio(pEstagio In t_Arm_Estagiocarregmob.Arm_Estagiocarregmob_Codigo%Type) return Number;                               

---------------------------------------------------------------------------------------------------------------
-- PROCEDURE UTILIZADA PARA RETORNAR LISTA DE CONHECIMENTOS DE UM CARREGAMENTO.                              -- 
---------------------------------------------------------------------------------------------------------------
Procedure sp_AtalizaGridCtrcDet( pParamsEntrada   In   Varchar2, 
                                 pStatus          Out  Char,
                                 pMessage         Out  Varchar2,
                                 pParamsSaida     Out  Clob  
                                );

-- FUNÇÃO UTILIZADA PARA RETORNAR DADOS DE UM CARREGAMENTO A PARTIR DE UMA EMBALAGEM.                                 
Procedure sp_getVeicEmbalagens ( pEmbalagem   In tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                                 pStatus      Out Char,
                                 pMessage     Out Char,
                                 pCursor      Out pkg_fifo.T_CURSOR
                               );  
                               
Function FNP_Xml_ListaCtrcImp( pXmlEntrada   Char ) Return pkg_fifo.tRetornoFunc;                                                              

Function FNP_CTRC_Eletronico( pParamsEntrada Varchar2 ) Return pkg_fifo.tRetornoFunc;
Function FNP_CTRC_Formulario( pParamsEntrada Varchar2 ) Return pkg_fifo.tRetornoFunc;

-- Pocedure utilizada para efetuar a Impressão dos Conhecimentos atraves do processi de carragamento automático
Procedure SP_IMP_CTRCAUTOCARREG( pParamsEntrada  In Varchar2,
                                 pStatus         Out Char,
                                 pMessage        Out Varchar2,
                                 pParamsSaida    Out Clob
                                );
                                
-- Procedure utilizada para realizar vunculação de uma lista de carregamentos a um veiculos
procedure sp_set_VincListaCarreg( pParamsEntrada In Varchar2,
                                  pStatus        Out Char,
                                  pMessage       Out Varchar2,
                                  pParamsSaida   Out Clob 
                               ) ; 

-- Procedure utilizada para gerar manifesto.
Procedure sp_GerarManifesto( pParamsEntrada In Varchar2,
                             pStatus        Out Char,
                             pMessage       Out Varchar2
                           );                                                              

--procedure criada para ser utilizada na correção da tabela de viagem.
Procedure sp_corrigeViagem( pCarreg_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type, 
                            pStatus Out Char,
                            pMessage Out Varchar2
                           );                           

Function FNP_Get_DestVeicDisp( vFcf_veiculodisp_codigo In  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                               vFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type
                             ) Return Varchar2;                           


--Procedure utilizada para recuperar lista de veiculos contratados em um determinado armazem.
Procedure sp_get_Veiculos ( pArm_armazem_codigo In tdvadm.t_arm_armazem.arm_armazem_codigo%Type, 
                            pStatus Out Char,
                            pMessage Out Varchar2,
                            pCursor Out pkg_glb_common.T_CURSOR
                          );

/*                  
procedure Sp_GetVeicDispPorPlaca(pPlaca In Tdvadm.t_Fcf_Veiculodisp.Car_Veiculo_Placa%Type,
                                 pCursor Out pkg_arm_carregamento.T_Cursor,
                                 pStatus Out Char,
                                 pMessage Out Varchar2);
*/

Function FNP_VinculaCarregVeic( pCarreg_Codigo   tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                pVeic_Codigo     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pVeic_Sequencia  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pUsu_codigo      tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                                pAcao            Char,
                                pAplicacao       tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type  Default 'carreg'
                              ) Return pkg_fifo.tRetornoFunc;
                              
Procedure Sp_Contem_ManifGerado( pXmlIn   In  Varchar2,
                                 pContem  Out Char,
                                 pStatus  Out Char,
                                 pMessage Out Varchar2);  
                                 
Procedure Sp_Get_CarregCTRC(pXmlIn  In  Varchar2,
                            pXmlOut Out Clob ,
                            pStatus Out Char,
                            pMessage Out Varchar2);                                           
                                 
Procedure Sp_VinculaCarregVeicDisp(pXmlIn   In varchar2,
                                   pStatus  Out Char,
                                   pMessage Out varchar2);                                                   

Procedure Sp_DesvinculaCarregVeicDisp(pXmlIn   In varchar2,
                                      pStatus  Out Char,
                                      pMessage Out varchar2);
                                      
Procedure Sp_RotaPertenceArmazem(pXmlIn   In varchar2,
                                 pResult  Out Char,
                                 pStatus  Out Char,
                                 pMessage Out varchar2);
                                 
Procedure Sp_LoginConferencia(pUsuario in t_usu_usuario.usu_usuario_codigo%Type,
                              pSenha   in t_usu_usuario.usu_usuario_senha%Type,
                              pCarreg  in t_arm_Carregamento.Arm_Carregamento_Codigo%type,
                              pStatus  Out Char,
                              pMessage Out Varchar2);     
                              
Procedure Sp_GetCtrcDigManual_SemVF(pPlaca  In Varchar2,
                                    pCursor Out types.cursorType);
                                    
Procedure Sp_GetCtrcDigManual_PorCTRC(pConhecCodigo  In t_Con_Conhecimento.Con_Conhecimento_Codigo%Type,
                                      pConhecSerie   In t_Con_Conhecimento.Con_Conhecimento_Serie%Type,
                                      pConhecRota    In t_Con_Conhecimento.Glb_Rota_Codigo%Type,
                                      pCursor Out types.cursorType); 
                                      
Procedure Sp_GetCtrcDigManual_PorVeicD(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                       pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type,
                                       pCursor Out types.cursorType);     
                                       
Procedure Sp_VinculaCTRCVeicDisp(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                 pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type, 
                                 pConhecCodigo  In t_Con_Conhecimento.Con_Conhecimento_Codigo%Type,
                                 pConhecSerie   In t_Con_Conhecimento.Con_Conhecimento_Serie%Type,
                                 pConhecRota    In t_Con_Conhecimento.Glb_Rota_Codigo%Type,
                                 pUsuario       In t_con_veicconhec.usu_usuario_codigo%Type,
                                 pStatus  Out Varchar,
                                 pMessage Out Varchar2);    
                                 
Procedure Sp_DesvinculaCTRCVeicDisp(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                    pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type, 
                                    pConhecCodigo  In t_Con_Conhecimento.Con_Conhecimento_Codigo%Type,
                                    pConhecSerie   In t_Con_Conhecimento.Con_Conhecimento_Serie%Type,
                                    pConhecRota    In t_Con_Conhecimento.Glb_Rota_Codigo%Type,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2);   
                                    
Procedure Sp_GetCTRCTodosPorVeicDisp(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                     pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type,
                                     pCursor Out types.cursorType);                                                                                                                                                                                                                                   
               
end pkg_fifo_ctrc;

 
/
create or replace package body pkg_fifo_ctrc Is

-- TIPOS PRIVADOR 
--type tCarregSemVF is record ( vCarreg    tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type );


 -- Tipo utilizado para definir as ações possiveis 
 Type tAcoes Is Record ( Vinculacao_VeicCarreg Char(1) := 'V',
                        Desvinculacao_VeicCarreg Char(1) := 'D'
                       ); 
 vAcoes tAcoes;   
/*************************************************************************************************************/
/*                                               FUNÇÕES PRIVADAS                                            */
/*************************************************************************************************************/
---------------------------------------------------------------------------------------------------------------
-- Função privada utilizada para recuperar os destinos de um veiculos                                        --
---------------------------------------------------------------------------------------------------------------
Function FNP_Get_DestVeicDisp( vFcf_veiculodisp_codigo In  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                               vFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type
                             ) Return Varchar2 Is
 --Variável que será utilizada como retorno da função
 vRetorno Varchar2(10000);                             
Begin
  vRetorno := '';
  
  Begin
    For vCursor In ( Select 
                       dest.glb_localidade_codigoibge
                     From
                       t_fcf_solveic  sol,
                       t_fcf_solveicdest dest
                     Where
                       sol.fcf_solveic_cod = dest.fcf_solveic_cod
                       And sol.fcf_veiculodisp_codigo = vFcf_veiculodisp_codigo
                       And sol.fcf_veiculodisp_sequencia = vFcf_veiculodisp_sequencia
                    ) Loop                      
                      vRetorno := vRetorno || '''' || ',' || '''' || vcursor.glb_localidade_codigoibge;
                    End Loop;
                    
    --Devolvo a variável preenchida
    Return vRetorno;
    
  Exception
    --Caso ocorra algum erro 
    When Others Then
      Return '';
  End;  
End;                               


---------------------------------------------------------------------------------------------------------------
-- Função Privada utilizada para Gerar um arquivo XML, com os CTRCs, de um Carregamento                      --
---------------------------------------------------------------------------------------------------------------
Function FNP_Xml_CtrcCarreg(pCodCarreg Char) Return pkg_fifo.tRetornoFunc Is 

 --Variável que será utilizada como retorno da função.
 vRetorno  pkg_fifo.tRetornoFunc;
 vSerie Char(03);

Begin
  vRetorno.Controle := 0;

  Begin
    --Cursor que com os dados necessário com os CRTCS de um determinado carregamento.
    For vCursor In ( /*Select 
                      distinct
                         ctrc.con_conhecimento_codigo                                                    NumCtrc,
                         ctrc.glb_rota_codigo                                                            RotaCtrc,
                         ctrc.con_conhecimento_serie                                                     SerieCtrc, 
                         pkg_glb_common.FN_LIMPA_CAMPO(cRemet.Glb_Cliente_Razaosocial)              Remetente,
                         pkg_glb_common.FN_LIMPA_CAMPO(cDest.Glb_Cliente_Razaosocial )              Destino,
                         pkg_glb_common.FN_LIMPA_CAMPO(cSac.Glb_Cliente_Razaosocial )               Sacado,
                         ctrc.con_conhecimento_nrformulario                                              nrFormulario,
                         to_char(ctrc.con_conhecimento_dtembarque, 'dd/mm/yyyy')                         DtEmbarque,
                         ctrc.con_viagem_numero                                                          Viagem_num,
                         ctrc.con_viagam_saque                                                           Viagem_saq,
                         ctrc.glb_rota_codigoviagem                                                      Viagem_rota, 
                         
                        -- Decode( 
                          Decode(ctrc.con_conhecimento_serie, 'XXX', 0, 1)  --, 1, 
                              --   Decode(Nvl(ctrc.con_conhecimento_nrformulario, 'R'), 'R', 0, 1 ), 0 )   
                                  StatusImpres,
                                 
                         tdvadm.f_busca_conhec_tpformulario( ctrc.con_conhecimento_codigo,
                                                             ctrc.con_conhecimento_serie,
                                                             ctrc.glb_rota_codigo )                      tp_Documento,
                         tdvadm.f_busca_conhec_nf( ctrc.con_conhecimento_codigo,
                                                   ctrc.con_conhecimento_serie,
                                                   ctrc.glb_rota_codigo )                                 Notas,
                                                   
                        pkg_fifo_auxiliar.fn_removeAcentos( tdvadm.pkg_fifo.FN_CON_MSNCONHECIMENTO( ctrc.con_conhecimento_codigo,
                                                                ctrc.con_conhecimento_serie,
                                                                ctrc.glb_rota_codigo ) )                   Mensagem,
                        DECODE(FN_RETORNA_TPAMBCTE( ctrc.glb_rota_codigo ),1, 'S', 2, 'N')                ROTACTE
                        
                        
                    From 
                      tdvadm.t_con_conhecimento  CTRC,
                      tdvadm.t_glb_cliente       CDest,
                      tdvadm.t_glb_cliente       CRemet,
                      tdvadm.t_glb_cliente       CSac,
                      tdvadm.t_arm_carregamento  Carreg
                    Where
                     0=0
                     And ctrc.glb_cliente_cgccpfremetente = cRemet.Glb_Cliente_Cgccpfcodigo
                     And ctrc.glb_cliente_cgccpfdestinatario = cDest.Glb_Cliente_Cgccpfcodigo
                     And ctrc.glb_cliente_cgccpfsacado = cSac.Glb_Cliente_Cgccpfcodigo
                     And ctrc.arm_carregamento_codigo = Carreg.Arm_Carregamento_Codigo
                     And carreg.arm_carregamento_dtfinalizacao Is Null
                     And Trim(carreg.arm_carregamento_codigo) = Trim(pCodCarreg)
                     Order By 
                       ctrc.con_conhecimento_serie Desc,
                       ctrc.glb_rota_codigo, 
                       ctrc.con_conhecimento_codigo
                       */
                       
                    Select 
                      distinct
                        ctrc.con_conhecimento_codigo                                                    NumCtrc,
                         ctrc.glb_rota_codigo                                                            RotaCtrc,
                         ctrc.con_conhecimento_serie                                                     SerieCtrc, 
                         pkg_glb_common.FN_LIMPA_CAMPO(cRemet.Glb_Cliente_Razaosocial)              Remetente,
                         pkg_glb_common.FN_LIMPA_CAMPO(cDest.Glb_Cliente_Razaosocial )              Destino,
                         pkg_glb_common.FN_LIMPA_CAMPO(cSac.Glb_Cliente_Razaosocial )               Sacado,
                         ctrc.con_conhecimento_nrformulario                                              nrFormulario,
                         to_char(ctrc.con_conhecimento_dtembarque, 'dd/mm/yyyy')                         DtEmbarque,
                         ctrc.con_viagem_numero                                                          Viagem_num,
                         ctrc.con_viagam_saque                                                           Viagem_saq,
                         ctrc.glb_rota_codigoviagem                                                      Viagem_rota, 
                         -- 16/11/2021
                         -- Joao / sirlano
                         -- Indicando se o CTe e eletronico ou nao                         
                         Decode(TRIM(Tdvadm.Pkg_Con_Cte.FN_CTE_EELETRONICO(ctrc.Con_Conhecimento_Codigo,
                                                                           ctrc.Con_Conhecimento_Serie,
                                                                           ctrc.Glb_Rota_Codigo)),'S',1,0) 
                         -- substituiu o Decode Abaixo que o conceito esta errado
                          --Decode(ctrc.con_conhecimento_serie, 'XXX', 0, 1)  --, 1, 
                              --   Decode(Nvl(ctrc.con_conhecimento_nrformulario, 'R'), 'R', 0, 1 ), 0 )   
                                  StatusImpres,
                                                     
                         tdvadm.f_busca_conhec_tpformulario( ctrc.con_conhecimento_codigo,
                                                             ctrc.con_conhecimento_serie,
                                                             ctrc.glb_rota_codigo )                      tp_Documento,
                         tdvadm.f_busca_conhec_nf( ctrc.con_conhecimento_codigo,
                                                   ctrc.con_conhecimento_serie,
                                                   ctrc.glb_rota_codigo )                                 Notas,
                                                                       
                        pkg_fifo_auxiliar.fn_removeAcentos( tdvadm.pkg_fifo.FN_CON_MSNCONHECIMENTO( ctrc.con_conhecimento_codigo,
                                                                ctrc.con_conhecimento_serie,
                                                                ctrc.glb_rota_codigo ) )                   Mensagem,
                        DECODE(FN_RETORNA_TPAMBCTE( ctrc.glb_rota_codigo ),1, 'S', 2, 'N')                ROTACTE
                                            

                                            
                    From 
                      tdvadm.t_arm_carregamento  Carreg,
                      tdvadm.t_arm_carregamentodet det,
                      tdvadm.t_arm_nota            aNota,  
                      
                      tdvadm.t_con_conhecimento  CTRC,
                      tdvadm.t_glb_cliente       CDest,
                      tdvadm.t_glb_cliente       CRemet,
                      tdvadm.t_glb_cliente       CSac,
                      
                      

                      tdvadm.t_con_nftransporta    cNota
                    Where
                     0=0
                     And carreg.arm_carregamento_codigo = det.arm_carregamento_codigo

                     And det.arm_embalagem_numero = anota.arm_embalagem_numero
                     And det.arm_embalagem_flag = anota.arm_embalagem_flag
                     And det.arm_embalagem_sequencia = anota.arm_embalagem_sequencia

                      And lpad(anota.arm_nota_numero, 9, '0') = Lpad(Trim(cnota.con_nftransportada_numnfiscal), 9, '0') 
                      And Trim(anota.glb_cliente_cgccpfremetente) = Trim(cnota.glb_cliente_cgccpfcodigo)
                      And TRIM(anota.arm_nota_serie) = TRIM(cnota.con_nftransportada_serienf)
                     --And to_number(TRIM(anota.arm_nota_serie)) = to_Number(TRIM(cnota.con_nftransportada_serienf))

--                     And cnota.con_conhecimento_codigo = ctrc.con_conhecimento_codigo
--                     And cnota.con_conhecimento_serie = ctrc.con_conhecimento_serie
--                     And cnota.glb_rota_codigo = ctrc.glb_rota_codigo
                     
                     
                     And ctrc.glb_cliente_cgccpfremetente = cRemet.Glb_Cliente_Cgccpfcodigo
                     And ctrc.glb_cliente_cgccpfdestinatario = cDest.Glb_Cliente_Cgccpfcodigo
                     And ctrc.glb_cliente_cgccpfsacado = cSac.Glb_Cliente_Cgccpfcodigo
                     
                     And ctrc.arm_carregamento_codigo = Carreg.Arm_Carregamento_Codigo
                     
                     And carreg.arm_carregamento_dtfinalizacao Is Null
                     And carreg.arm_carregamento_codigo = pCodCarreg
                     Order By 
                       ctrc.con_conhecimento_serie Desc,
                       ctrc.glb_rota_codigo, 
                       ctrc.con_conhecimento_codigo
   
   
   
                          
                              
                   )
    Loop
      --Incrementa a variável que vai cuidar do número da linha
      vRetorno.Controle := vRetorno.Controle +1;
      
      --Monta o Arquivo Xml própriamente dito, alimentando as linhas com os valores do Cursor. 
      vRetorno.Xml := vRetorno.Xml || '<row num=#'     || Trim( to_char(vRetorno.Controle) )    || '#>';
      vRetorno.Xml := vRetorno.Xml || '<Numctrc>'      || Trim( vCursor.Numctrc )      || '</Numctrc>'     ;
      vRetorno.Xml := vRetorno.Xml || '<Rotactrc>'     || Trim( vCursor.Rotactrc )     || '</Rotactrc>'    ;
      vSerie := vCursor.Seriectrc;
      vRetorno.Xml := vRetorno.Xml || '<serieCtrc>'    ||  ' ' || vSerie    || '</serieCtrc>'    ;
      vRetorno.Xml := vRetorno.Xml || '<Viagem_Num>'   || Trim( vCursor.Viagem_Num )   || '</Viagem_Num>'    ;
      vRetorno.Xml := vRetorno.Xml || '<Viagem_Saq>'   || Trim( vCursor.Viagem_Saq )   || '</Viagem_Saq>'    ;
      vRetorno.Xml := vRetorno.Xml || '<Viagem_Rota>'  || Trim( vCursor.Viagem_Rota )  || '</Viagem_Rota>'    ;
      vRetorno.Xml := vRetorno.Xml || '<Remetente>'    || Trim( vCursor.Remetente )    || '</Remetente>'   ;
      vRetorno.Xml := vRetorno.Xml || '<Destino>'      || Trim( vCursor.Destino )      || '</Destino>'     ;
      vRetorno.Xml := vRetorno.Xml || '<Sacado>'       || Trim( vCursor.Sacado )       || '</Sacado>'      ;
      vRetorno.Xml := vRetorno.Xml || '<nrFormulario>' || Trim( vCursor.Nrformulario ) || '</nrFormulario>'  ;
      vRetorno.Xml := vRetorno.Xml || '<Dtembarque>'   || Trim( vCursor.Dtembarque )   || '</Dtembarque>'  ;
      vRetorno.Xml := vRetorno.Xml || '<Statusimpres>' || Trim( vCursor.Statusimpres ) || '</Statusimpres>';
      vRetorno.Xml := vRetorno.Xml || '<Tp_Documento>' || Trim( vCursor.Tp_Documento ) || '</Tp_Documento>';
      vRetorno.Xml := vRetorno.Xml || '<Notas>'        || Trim( vCursor.Notas )        || '</Notas>'       ;
      vRetorno.Xml := vRetorno.Xml || '<Mensagem>'     || Trim( vCursor.Mensagem )     || '</Mensagem>'    ;
      vRetorno.Xml := vRetorno.Xml || '<Rotacte>'      || Trim( vCursor.Rotacte )      || '</Rotacte>'     ;
      vRetorno.Xml := vRetorno.Xml || '</row>';
    End Loop;
    
    --Caso o Select não encontre nada, preciso montar um arquivo XML sem nenhum registro.
    If  vRetorno.Controle = 0 Then
      vRetorno.Xml := vRetorno.Xml || '<row num=#0#> '  ;
      vRetorno.Xml := vRetorno.Xml || '<Numctrc />'     ;
      vRetorno.Xml := vRetorno.Xml || '<Rotactrc />'    ;
      vRetorno.Xml := vRetorno.Xml || '<serieCtrc />'   ;
      vRetorno.Xml := vRetorno.Xml || '<Viagem_Num />'  ;
      vRetorno.Xml := vRetorno.Xml || '<Viagem_Saq />'  ;
      vRetorno.Xml := vRetorno.Xml || '<Viagem_Rota />' ;
      vRetorno.Xml := vRetorno.Xml || '<Remetente />'   ;
      vRetorno.Xml := vRetorno.Xml || '<Destino />'     ;
      vRetorno.Xml := vRetorno.Xml || '<Sacado />'      ;
      vRetorno.Xml := vRetorno.Xml || '<nrFormulario />';
      vRetorno.Xml := vRetorno.Xml || '<Dtembarque />'  ;
      vRetorno.Xml := vRetorno.Xml || '<Statusimpres />';
      vRetorno.Xml := vRetorno.Xml || '<Tp_Documento />';
      vRetorno.Xml := vRetorno.Xml || '<Notas />'       ;
      vRetorno.Xml := vRetorno.Xml || '<Mensagem />'    ;
      vRetorno.Xml := vRetorno.Xml || '<Rotacte />'     ;
      vRetorno.Xml := vRetorno.Xml || '</row>'          ;
    End If;
    
    --Executa o Replace para mudar os caracteres conringas.
    vRetorno.Xml := Replace(vRetorno.Xml, '§', '''');
    vRetorno.Xml := Replace(vRetorno.Xml, '#', '"');
    
    --Seta as variáveis de retorno para positivo, para garantir a transmissão do arquivo XML.
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
  Exception
    When Others Then
      --Caso ocorra algum erro, registro no paramentro de saida o erro a mensagem.
       vRetorno.Status := pkg_fifo.Status_Erro;
       vRetorno.Message := 'Erro ao gerar relação dos Ctrc do Carregamento ' || Trim( pCodCarreg );
       vRetorno.Xml := '';
  End;    
  
  Return vRetorno;
  
End FNP_Xml_CtrcCarreg;   

---------------------------------------------------------------------------------------------------------------
-- Função Privada utilizada para gerar Xml, com os Ctrc Não Eletronicos para Impressão no FrontEnd.          --
---------------------------------------------------------------------------------------------------------------
Function FNP_Xml_ListaCtrcImp( pXmlEntrada   Char ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada como retorno da função.
 vRetorno   pkg_fifo.tRetornoFunc;
 
Begin
  vRetorno.Xml := '';
  vRetorno.Status := '';
  vRetorno.Controle := 0;
  Begin
    --Corro um laço no arquivo xml passado como paramentros, pegando os números dos CTRC "impressos".
    For vCursorForm In ( Select 
                           ExtractValue(Value(field), 'row/ctrc_codigo' ) ctrc_codigo,
                           ExtractValue(Value(field), 'row/ctrc_serie' )  ctrc_serie,
                           ExtractValue(Value(field), 'row/ctrc_rota' )   ctrc_rota
                         From
                           Table(xmlsequence( Extract(xmltype.createXml(pXmlEntrada) , '/Parametros/Inputs/input/Tables/Table/ROWSET/row'))) field
                        ) 
                       Loop
                          --Atualizo o CTRC, passo o flag de digitado para I
                          Update t_con_conhecimento w
                            SET W.CON_CONHECIMENTO_DIGITADO = 'I'
                          Where w.con_conhecimento_codigo = vCursorForm.Ctrc_Codigo
                            And w.con_conhecimento_serie  = vCursorForm.Ctrc_Serie
                            And w.glb_rota_codigo         = vCursorForm.Ctrc_Rota;   
                            Commit;                      
                            
                         --Dentro do Laço de Ctrc Impressso, vou abrir outro laço apenas para pegar os dados do CTRC e montar um arquivo xml.
                         For vCursorImpForm In ( Select
                                ctrc.con_conhecimento_codigo        ctrcCodigo,
                                ctrc.con_conhecimento_serie         ctrcSerie,
                                ctrc.glb_rota_codigo                ctrcRota,   
                                ctrc.Slf_Solfrete_Codigo            SolFreteCodigo,
                                ctrc.Slf_Solfrete_Saque             SolFreteSaque,
                                ctrc.Slf_Tabela_Codigo              TabCodigo,
                                ctrc.Slf_Tabela_Saque               TabSaque,
                                ctrc.Glb_Localidade_Codigoorigem    LocOrigem,
                                ctrc.Glb_Localidade_Codigodestino   LocDestino,
                                ctrc.Glb_Rota_Codigoimpressao       RotaImpressao,
                                ctrc.Glb_Cliente_Cgccpfremetente    CnpjRemet,
                                ctrc.Glb_Tpcliend_Codigoremetente   TpCnpjRemet,
                                ctrc.Glb_Cliente_Cgccpfdestinatario CnpjDestino,
                                ctrc.Glb_Tpcliend_Codigodestinatari TpCnpjDestino,
                                ctrc.Glb_Cliente_Cgccpfsacado       CnpjSacado,
                                pkg_glb_common.FN_LIMPA_CAMPO( destino.Glb_Cliente_Razaosocial )     RazaoDestino,
                                pkg_glb_common.FN_LIMPA_CAMPO( ctrc.Con_Conhecimento_Obs )           CtrcObs,
                                ctrc.Con_Conhecimento_Localcoleta   LocalColeta,
                                ctrc.Con_Conhecimento_Localentrega  LocalEntrega,
                                ctrc.Con_Viagem_Numero              ViagemNum,
                                To_char(ctrc.Con_Viagam_Saque)      ViagemSaque,
                                ctrc.Glb_Rota_Codigoviagem          ViagemRota,
                                to_char(ctrc.Con_Conhecimento_Dtembarque, 'dd/mm/yyyy')    DtEmbarque,
                                ctrc.Glb_Mercadoria_Codigo          Mercadoria,
                                ctrc.Glb_Embalagem_Codigo           CodEmbalagem,
                                ctrc.Prg_Progcarga_Codigo           ProgCarga,
                                ctrc.Con_Conhecimento_Cfo           Cfo,
                                ctrc.Con_Conhecimento_Autoriseg     Autorizador,
                                tb.Slf_Tabela_Tipo                  TipoCarga,
                                rd.Con_Consigredespacho_Flagcr      CONSIGREDESP
                              From
                                tdvadm.t_con_conhecimento     ctrc,
                                tdvadm.t_glb_cliente          Destino,
                                tdvadm.t_Slf_Tabela           TB,
                                tdvadm.t_Con_Consigredespacho RD    
                              Where 
                                0=0
                                And ctrc.glb_cliente_cgccpfdestinatario = Destino.Glb_Cliente_Cgccpfcodigo
                                
                                AND CTRC.SLF_TABELA_CODIGO = TB.SLF_TABELA_CODIGO(+)
                                AND CTRC.GLB_ROTA_CODIGO   = TB.GLB_ROTA_CODIGO(+)
                                AND CTRC.SLF_TABELA_SAQUE  = TB.SLF_TABELA_SAQUE(+)
                                
                                AND CTRC.CON_CONHECIMENTO_CODIGO = RD.CON_CONHECIMENTO_CODIGO(+)
                                AND CTRC.CON_CONHECIMENTO_SERIE  = RD.CON_CONHECIMENTO_SERIE(+)
                                AND CTRC.GLB_ROTA_CODIGO         = RD.GLB_ROTA_CODIGO(+)
                                
                                And ctrc.con_conhecimento_codigo = Trim( vCursorForm.Ctrc_Codigo )
                                And ctrc.con_conhecimento_serie  = Trim( vCursorForm.Ctrc_Serie )
                                And ctrc.glb_rota_codigo         = Trim( vCursorForm.Ctrc_Rota )
                              )  
                              Loop
                                --Incrementa a variável de controle para representar a linha do arquivo XML
                                vRetorno.Controle := vRetorno.Controle +1;
                                
                                --Monta a linha do Arquivo Xml, que será responsável pela impressão dos CTRCs de formulário.
                                vRetorno.Xml := vRetorno.Xml || '<row num=#'       || Trim(to_char(vRetorno.Controle))|| '#> ';
                                vRetorno.Xml := vRetorno.Xml || '<linha>'          || Trim(to_char(vRetorno.Controle))|| '</linha>'     ;
                                vRetorno.Xml := vRetorno.Xml || '<Ctrccodigo>'     || vCursorImpForm.Ctrccodigo       || '</Ctrccodigo>'     ;
                                vRetorno.Xml := vRetorno.Xml || '<ctrcSerie>'      || vCursorImpForm.ctrcSerie        || '</ctrcSerie>'      ;
                                vRetorno.Xml := vRetorno.Xml || '<ctrcRota>'       || vCursorImpForm.ctrcRota         || '</ctrcRota>'       ;
                                vRetorno.Xml := vRetorno.Xml || '<SolFreteCodigo>' || vCursorImpForm.SolFreteCodigo   || '</SolFreteCodigo>' ;
                                vRetorno.Xml := vRetorno.Xml || '<SolFreteSaque>'  || vCursorImpForm.SolFreteSaque    || '</SolFreteSaque>'  ;
                                vRetorno.Xml := vRetorno.Xml || '<LocOrigem>'      || vCursorImpForm.LocOrigem        || '</LocOrigem>'      ;
                                vRetorno.Xml := vRetorno.Xml || '<LocDestino>'     || vCursorImpForm.LocDestino       || '</LocDestino>'     ;
                                vRetorno.Xml := vRetorno.Xml || '<RotaImpressao>'  || vCursorImpForm.RotaImpressao    || '</RotaImpressao>'  ;
                                vRetorno.Xml := vRetorno.Xml || '<CnpjRemet>'      || vCursorImpForm.CnpjRemet        || '</CnpjRemet>'      ;
                                vRetorno.Xml := vRetorno.Xml || '<TpCnpjRemet>'    || vCursorImpForm.Tpcnpjremet      || '</TpCnpjRemet>'    ;
                                vRetorno.Xml := vRetorno.Xml || '<CnpjDestino>'    || vCursorImpForm.CnpjDestino      || '</CnpjDestino>'    ;
                                vRetorno.Xml := vRetorno.Xml || '<TpCnpjDestino>'  || vCursorImpForm.TpCnpjDestino    || '</TpCnpjDestino>'  ;
                                vRetorno.Xml := vRetorno.Xml || '<CnpjSacado>'     || vCursorImpForm.CnpjSacado       || '</CnpjSacado>'     ;
                                vRetorno.Xml := vRetorno.Xml || '<RazaoDestino>'   || vCursorImpForm.RazaoDestino     || '</RazaoDestino>'   ;
                                vRetorno.Xml := vRetorno.Xml || '<TabCodigo>'      || vCursorImpForm.TabCodigo        || '</TabCodigo>'      ;
                                vRetorno.Xml := vRetorno.Xml || '<TabSaque>'       || vCursorImpForm.TabSaque         || '</TabSaque>'       ;
                                vRetorno.Xml := vRetorno.Xml || '<CtrcObs>'        || vCursorImpForm.CtrcObs          || '</CtrcObs>'        ;
                                vRetorno.Xml := vRetorno.Xml || '<LocalColeta>'    || vCursorImpForm.LocalColeta      || '</LocalColeta>'    ;
                                vRetorno.Xml := vRetorno.Xml || '<LocalEntrega>'   || vCursorImpForm.LocalEntrega     || '</LocalEntrega>'   ;
                                vRetorno.Xml := vRetorno.Xml || '<ViagemNum>'      || vCursorImpForm.ViagemNum        || '</ViagemNum>'      ;
                                vRetorno.Xml := vRetorno.Xml || '<ViagemSaque>'    || vCursorImpForm.ViagemSaque      || '</ViagemSaque>'    ;
                                vRetorno.Xml := vRetorno.Xml || '<ViagemRota>'     || vCursorImpForm.ViagemRota       || '</ViagemRota>'     ;
                                vRetorno.Xml := vRetorno.Xml || '<DtEmbarque>'     || vCursorImpForm.DtEmbarque       || '</DtEmbarque>'     ;
                                vRetorno.Xml := vRetorno.Xml || '<Mercadoria>'     || vCursorImpForm.Mercadoria       || '</Mercadoria>'     ;
                                vRetorno.Xml := vRetorno.Xml || '<CodEmbalagem>'   || vCursorImpForm.CodEmbalagem     || '</CodEmbalagem>'   ;
                                vRetorno.Xml := vRetorno.Xml || '<ProgCarga>'      || vCursorImpForm.ProgCarga        || '</ProgCarga>'      ;
                                vRetorno.Xml := vRetorno.Xml || '<Cfo>'            || vCursorImpForm.Cfo              || '</Cfo>'            ;
                                vRetorno.Xml := vRetorno.Xml || '<Autorizador>'    || vCursorImpForm.Autorizador      || '</Autorizador>'    ;
                                vRetorno.Xml := vRetorno.Xml || '<TipoCarga>'      || vCursorImpForm.TipoCarga        || '</TipoCarga>'      ;
                                vRetorno.Xml := vRetorno.Xml || '<CONSIGREDESP>'   || vCursorImpForm.CONSIGREDESP     || '</CONSIGREDESP>'   ;
                                vRetorno.Xml := vRetorno.Xml || '</row> ';   
                                
                                
                                 
                                         
                              End Loop;
                       End Loop;


  Exception
    When Others Then
      vRetorno.Status  := pkg_glb_common.Status_Erro;
      vRetorno.Message := 'Erro na lista de CTRCs Impressos.' || chr(13) || 
                           Sqlerrm                            || chr(13) || 
                           dbms_utility.format_call_stack;
      Return vRetorno;                      
  End;                       


  --Caso a variável de controle esteja com o valor Zerado, quer dizer que não teve nenhum ctrc impresso de rota não eletronica
  If (vRetorno.Controle = 0 ) Then
    --Gera um Arquivo XML em branco.
    vRetorno.Xml := vRetorno.Xml || '<row num=#0#>'      ;
    vRetorno.Xml := vRetorno.Xml || '<linha />'          ; 
    vRetorno.Xml := vRetorno.Xml || '<Ctrccodigo />'     ;
    vRetorno.Xml := vRetorno.Xml || '<ctrcSerie />'      ;
    vRetorno.Xml := vRetorno.Xml || '<ctrcRota />'       ;
    vRetorno.Xml := vRetorno.Xml || '<SolFreteCodigo />' ;
    vRetorno.Xml := vRetorno.Xml || '<SolFreteSaque />'  ;
    vRetorno.Xml := vRetorno.Xml || '<LocOrigem />'      ;
    vRetorno.Xml := vRetorno.Xml || '<LocDestino />'     ;
    vRetorno.Xml := vRetorno.Xml || '<RotaImpressao />'  ;
    vRetorno.Xml := vRetorno.Xml || '<CnpjRemet />'      ;
    vRetorno.Xml := vRetorno.Xml || '<TpCnpjRemet />'    ;
    vRetorno.Xml := vRetorno.Xml || '<CnpjDestino />'    ;
    vRetorno.Xml := vRetorno.Xml || '<TpCnpjDestino />'  ;
    vRetorno.Xml := vRetorno.Xml || '<CnpjSacado />'     ;
    vRetorno.Xml := vRetorno.Xml || '<RazaoDestino />'   ;
    vRetorno.Xml := vRetorno.Xml || '<TabCodigo />'      ;
    vRetorno.Xml := vRetorno.Xml || '<TabSaque />'       ;
    vRetorno.Xml := vRetorno.Xml || '<CtrcObs />'        ;
    vRetorno.Xml := vRetorno.Xml || '<LocalColeta />'    ;
    vRetorno.Xml := vRetorno.Xml || '<LocalEntrega />'   ;
    vRetorno.Xml := vRetorno.Xml || '<ViagemNum />'      ;
    vRetorno.Xml := vRetorno.Xml || '<ViagemSaque />'    ;
    vRetorno.Xml := vRetorno.Xml || '<ViagemRota />'     ;
    vRetorno.Xml := vRetorno.Xml || '<DtEmbarque />'     ;
    vRetorno.Xml := vRetorno.Xml || '<Mercadoria />'     ;
    vRetorno.Xml := vRetorno.Xml || '<CodEmbalagem />'   ;
    vRetorno.Xml := vRetorno.Xml || '<ProgCarga />'      ;
    vRetorno.Xml := vRetorno.Xml || '<Cfo />'            ;
    vRetorno.Xml := vRetorno.Xml || '<Autorizador />'    ;
    vRetorno.Xml := vRetorno.Xml || '<TipoCarga />'      ;
    vRetorno.Xml := vRetorno.Xml || '<CONSIGREDESP />'   ;
    vRetorno.Xml := vRetorno.Xml || '</row> '           ;    
  End If;                     

  --Seta as variáveis para positivo e retorno o arquivo gerado.
  vRetorno.Status := pkg_fifo.Status_Normal;
  vRetorno.Message := '';
  Return vRetorno;
  
End FNP_Xml_ListaCtrcImp;  

--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para gerar arquivo Xml, com lista de carregamentos sem Vale de Frete, a partir de um armazem. -- 
--------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_CarregSemVF(pArmazem tdvadm.t_arm_armazem.arm_armazem_codigo%Type ) Return pkg_fifo.tRetornoFunc Is                              
 --Variável que será utilizada como returno da Função.
 vRetorno  pkg_fifo.tRetornoFunc;
 vlinha    CLOB;

Begin
  --Inicia as variáveis para garantir que não trará lixo.
  vRetorno.Controle := 0;
  vRetorno.Xml := '';
  
  Begin
    For vCursor In  ( SELECT 
                        DISTINCT 
                        CA.ARM_CARREGAMENTO_CODIGO                                                                         carreg_codigo,
                        Trim( TO_CHAR( CA.ARM_CARREGAMENTO_DTFECHAMENTO, 'dd/mm/yyyy hh24:mi:ss'))                         carreg_dtFechamento, 
                        to_char( CA.ARM_CARREGAMENTO_PESOCOBRADO )                                                         carreg_PesoCobrado,  
                        to_char( CA.ARM_CARREGAMENTO_PESOREAL )                                                            carreg_pesoReal,  
                        To_char( CA.ARM_CARREGAMENTO_QTDCTRC )                                                             carreg_qtdeCtrc, 
                        to_char( CA.ARM_CARREGAMENTO_QTDIMPCTRC )                                                          carreg_qtdeCtrcImp, 
                        to_char( CA.ARM_CARREGAMENTO_QTDCTRC, '9909') ||' / '|| to_char(CA.ARM_CARREGAMENTO_QTDIMPCTRC, '9909') carreg_ctrcs, 
                        Trim( to_char( CA.ARM_CARREGAMENTO_DTVIAGEM, 'dd/mm/yyyy hh24:mi:ss'))                             carreg_DtViagem, 
                        Trim( to_char( CA.ARM_CARREGAMENTO_DTENTREGA, 'dd/mm/yyyy hh24:mi:ss'))                            carreg_DtEntrega, 
                        FN_PLACA_DOCARREG(CA.ARM_CARREGAMENTO_CODIGO)                                                      ctrcs_placa, 
                        CA.FCF_VEICULODISP_CODIGO                                                                          veic_codigo,
                        ca.fcf_veiculodisp_sequencia                                                                       veic_seq,
                        ca.arm_carregamento_destembs                                                                       carreg_destino,
                        --decode( (Select Count(*) From t_con_manifesto m
                        --  Where m.arm_carregamento_codigo = ca.arm_carregamento_codigo ), 0, '9', '0')                     carreg_manifesto,
                        decode( (Select Count(*) From t_con_docmdfe m
                           Where m.arm_carregamento_codigo = ca.arm_carregamento_codigo ), 0, '9', '0')                    carreg_manifesto,
                        decode( nvl(Trim(vd.car_veiculo_placa), 'R'), 'R', (
                        decode(nvl(Trim(vd.frt_conjveiculo_codigo), 'R'), 'R', '', Trim(vd.frt_conjveiculo_codigo) )), 
                        Trim(vd.car_veiculo_placa))  Carreg_placa,
                        FN_BUSCA_PLACAVEICULO(vd.FCF_VEICULODISP_CODIGO, vd.FCF_VEICULODISP_SEQUENCIA)                     PLACA,
                        decode(nvl(ca.arm_carregamento_flagmanifesto, 'R'), 'R', '9', 'S', '1')                            manifesto_flagObrg,
                        ca.arm_carregamemcalc_codigo calc
                          
--                        FN_ARM_GETDESTINOCARREGEMB(ca.arm_carregamento_codigo ,'T','C','T')                   IbgeDest 
                      FROM 
                        T_ARM_CARREGAMENTO CA,
                        T_FCF_VEICULODISP VD   
--                        T_CON_CONHECIMENTO CO
                      Where
                        0=0
                        And CA.ARM_CARREGAMENTO_DTFECHAMENTO IS NOT Null
                        
                        and CA.FCF_VEICULODISP_CODIGO  = VD.FCF_VEICULODISP_CODIGO
                        and ca.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
                        
--                        And CA.ARM_CARREGAMENTO_CODIGO = CO.ARM_CARREGAMENTO_CODIGO
                        and CA.FCF_VEICULODISP_CODIGO  IS NOT Null
                        
                        --------- Vale de Frete Nao Gerado !!! -------
                        And CA.ARM_CARREGAMENTO_DTFINALIZACAO IS Null
                        And Vd.FCF_VEICULODISP_FLAGVALEFRETE IS NULL
                        --and ca.arm_carregamento_codigo = '481047'
                        ----------------------------------------------                        
                        and CA.ARM_ARMAZEM_CODIGO = Trim(pArmazem)
                        And TRUNC(CA.ARM_CARREGAMENTO_DTFECHAMENTO) >=  Trunc(Sysdate) - 60
                        
                        ORDER BY TO_NUMBER(CA.ARM_CARREGAMENTO_CODIGO)
                        
                     ) Loop
                     
       vRetorno.Controle := vRetorno.Controle +1;
       --Monta o Arquivo XML.

       vlinha := '<row num=#'            || to_char(vRetorno.Controle)    ||'# >' ||
                 '<carreg_codigo>'       || vCursor.carreg_codigo         || '</carreg_codigo>' ||
                 '<carreg_dtFechamento>' || vCursor.carreg_dtFechamento   || '</carreg_dtFechamento>' ||
                 '<carreg_PesoCobrado>'  || vCursor.carreg_PesoCobrado    || '</carreg_PesoCobrado>' ||
                 '<carreg_pesoReal>'     || vCursor.carreg_pesoReal       || '</carreg_pesoReal>' ||
                 '<carreg_qtdeCtrc>'     || vCursor.carreg_qtdeCtrc       || '</carreg_qtdeCtrc>' ||
                 '<carreg_qtdeCtrcImp>'  || vCursor.carreg_qtdeCtrcImp    || '</carreg_qtdeCtrcImp>' ||
                 '<carreg_ctrcs>'        || vCursor.carreg_ctrcs          || '</carreg_ctrcs>' ||
                 '<carreg_DtViagem>'     || vCursor.carreg_DtViagem       || '</carreg_DtViagem>' ||
                 '<carreg_DtEntrega>'    || vCursor.carreg_DtEntrega      || '</carreg_DtEntrega>' ||
                 '<carreg_Placa>'        || vCursor.Carreg_Placa          || '</carreg_Placa>' ||
                 '<Placa>'               || vCursor.Placa                 || '</Placa>' ||
                 '<ctrcs_placa>'         || vcursor.ctrcs_placa           || '</ctrcs_placa>' || 
                 '<veic_codigo>'         || vCursor.veic_codigo           || '</veic_codigo>' ||
                 '<veic_seq>'            || vCursor.veic_seq              || '</veic_seq>' ||
                 '<IbgeDest>'            || Trim(vCursor.Carreg_Destino ) || '</IbgeDest>' ||
                 '<carreg_manifesto>'    || vCursor.Carreg_Manifesto      || '</carreg_manifesto>' ||
                 '<manifesto_flagObrg>'  || vCursor.Manifesto_Flagobrg    || '</manifesto_flagObrg>' || 
                 '<carreg_calc>'         || vCursor.Calc                  || '</carreg_calc>' ||
                 '</row>';
         vRetorno.Xml := vRetorno.Xml || vlinha;


      
/* anterior
       vRetorno.Xml := vRetorno.Xml || '<row num=#'            || to_char(vRetorno.Controle)    ||'# >';
       vRetorno.Xml := vRetorno.Xml || '<carreg_codigo>'       || vCursor.carreg_codigo         || '</carreg_codigo>'       ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_dtFechamento>' || vCursor.carreg_dtFechamento   || '</carreg_dtFechamento>' ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_PesoCobrado>'  || vCursor.carreg_PesoCobrado    || '</carreg_PesoCobrado>'  ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_pesoReal>'     || vCursor.carreg_pesoReal       || '</carreg_pesoReal>'     ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_qtdeCtrc>'     || vCursor.carreg_qtdeCtrc       || '</carreg_qtdeCtrc>'     ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_qtdeCtrcImp>'  || vCursor.carreg_qtdeCtrcImp    || '</carreg_qtdeCtrcImp>'  ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_ctrcs>'        || vCursor.carreg_ctrcs          || '</carreg_ctrcs>'        ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_DtViagem>'     || vCursor.carreg_DtViagem       || '</carreg_DtViagem>'     ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_DtEntrega>'    || vCursor.carreg_DtEntrega      || '</carreg_DtEntrega>'    ;
       vRetorno.Xml := vRetorno.Xml || '<carreg_Placa>'        || vCursor.carreg_Placa          || '</carreg_Placa>'        ;
       vRetorno.Xml := vRetorno.Xml || '<veic_codigo>'         || vCursor.veic_codigo           || '</veic_codigo>'         ;
       vRetorno.Xml := vRetorno.Xml || '<veic_seq>'            || vCursor.veic_seq              || '</veic_seq>'            ;
       vRetorno.Xml := vRetorno.Xml || '<IbgeDest>'            || Trim(vCursor.Carreg_Destino ) || '</IbgeDest>'            ;
--       vRetorno.Xml := vRetorno.Xml || '<IbgeDest>'            || ' '  || '</IbgeDest>'            ;
       vRetorno.Xml := vRetorno.Xml || '</row>';
*/       
     End Loop;   
     
     --Caso o Select não tenha trago nenhuma linha, monto um arquivo sem registro apenas para não dar erro no DELPHI.
      If vRetorno.Controle = 0 Then
        vRetorno.Xml := vRetorno.Xml || '<row num=#0#>'          ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_codigo />'      ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_dtFechamento />';
        vRetorno.Xml := vRetorno.Xml || '<carreg_PesoCobrado />' ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_pesoReal />'    ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_qtdeCtrc />'    ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_qtdeCtrcImp />' ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_ctrcs />'       ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_DtViagem />'    ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_DtEntrega />'   ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_Placa />'       ;
        vRetorno.Xml := vRetorno.Xml || '<Placa/>'       ;
        vRetorno.Xml := vRetorno.Xml || '<ctrcs_placa />'       ;
        vRetorno.Xml := vRetorno.Xml || '<veic_codigo />'        ;
        vRetorno.Xml := vRetorno.Xml || '<veic_seq />'           ;
        vRetorno.Xml := vRetorno.Xml || '<IbgeDest />'           ;
        vRetorno.Xml := vRetorno.Xml || '<carreg_manifesto />'   ;
        vRetorno.Xml := vRetorno.Xml || '<manifesto_flagObrg />'   ;

        
        vRetorno.Xml := vRetorno.Xml || '</row>';
     End If;
     vRetorno.Status := pkg_fifo.Status_Normal;
  Exception
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao gerar arquivo Xml Carregamento sem Vale Frete.' || Sqlerrm;
  End;    
   
 
  Return vRetorno;
  
End FNP_Xml_CarregSemVF;

Function Fn_GetIndex_ImgEstagio(pEstagio In t_Arm_Estagiocarregmob.Arm_Estagiocarregmob_Codigo%Type) return Number
  As
  vResult Number;
  Begin
      vResult :=
      Case pEstagio
          When 'I' Then 14
          When 'R' Then 15
          When 'L' Then 16                
          When 'A' Then 17
          When 'C' Then 18
          When 'F' Then 19
          Else 99
       End;          
      Return vResult;    
  End Fn_GetIndex_ImgEstagio;

--------------------------------------------------------------------------------------------------------------------
-- Fução utilizada para gerar arquivo XML com relação dos veiuclos contratados por um determinado armazem.        --
--------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_ListaVeicContratados( pCodArmazem tdvadm.t_arm_armazem.arm_armazem_codigo%Type) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada para o retorno da função.
 vRetorno pkg_fifo.tRetornoFunc;
Begin

 --Primeiro zero valores da Variável de retorno apenas para garantir que não vou pegar lixo.
 vRetorno.Status := '';
 vRetorno.Xml    := '';
 vRetorno.Controle := 0;
 Begin
    --crio um laço em um cursor para pegar todos os veiculos contratados em um armazem.
    For vCursor In ( SELECT 
                       Distinct
                         S.FCF_VEICULODISP_CODIGO                                  Veic_codigo,
                         S.fcf_veiculodisp_sequencia                               Veic_sequencia,
                         pkg_fifo_ctrc.Fn_GetIndex_ImgEstagio(S.ARM_ESTAGIOCARREGMOB_CODIGO) Veic_Estagio_Mobile,
                         Case pkg_fifo_manifesto.fn_manifesto_gerado(s.fcf_veiculodisp_codigo, s.fcf_veiculodisp_sequencia) 
                            When 'S' Then 0
                            When 'N' Then 9
                            When 'F' Then 20
                         End Manifesto,
                         Decode(( select count(*)
                                  from t_arm_carregamento ca
                                  where ca.fcf_veiculodisp_codigo = 
                                        s.fcf_veiculodisp_codigo
                                   and ca.fcf_veiculodisp_sequencia =
                                       s.fcf_veiculodisp_sequencia ), 0, 'Vazio', 'Carreg.') Veic_Status,
                                       
                         to_char(s.fcf_veiculodisp_data, 'dd/mm/yyyy hh24:mi:ss')    Veic_Data,
                         to_char((trunc(sysdate) - trunc(s.fcf_veiculodisp_data)))   Veic_qtdeDiasDisp,                 
                         FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO,
                                               S.FCF_VEICULODISP_SEQUENCIA)           Veic_PLACA,
                         pkg_fifo_auxiliar.fn_removeAcentos(FN_BUSCA_MOTORISTAVEICULO( S.FCF_VEICULODISP_CODIGO,                                
                                                    S.FCF_VEICULODISP_SEQUENCIA) )    Veic_Motorista,                  
                         T.FCF_TPVEICULO_DESCRICAO                                    Veic_Descricao,
                         s.fcf_veiculodisp_ufdestino                                  Veic_UfDestino,
                         pkg_fifo_auxiliar.fn_removeAcentos( s.usu_usuario_cadastro)  Veic_usuCadastro,
                         sold.glb_localidade_codigoibge                               CodIbge  
                    FROM 
                      T_FCF_VEICULODISP S,
                      T_FCF_TPVEICULO   T,
                      T_FCF_SOLVEIC     SOL,
                      T_FCF_SOLVEICDEST SOLD,
                      T_ARM_ESTAGIOCARREGMOB EST
                    Where
                      0=0 
                     And S.FCF_VEICULODISP_CODIGO    = SOL.FCF_VEICULODISP_CODIGO(+)
                     AND S.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA(+)
                     AND S.FCF_TPVEICULO_CODIGO = T.FCF_TPVEICULO_CODIGO
                     AND S.FCF_OCORRENCIA_CODIGO IS NULL                                                    
                     AND S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL                                              
                     AND S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL    
                     AND SOL.FCF_SOLVEIC_COD = SOLD.FCF_SOLVEIC_COD(+) 
                     And s.arm_armazem_codigo = Trim(pCodArmazem)
                     and s.arm_estagiocarregmob_codigo = EST.ARM_ESTAGIOCARREGMOB_CODIGO (+)
                     and NVL(est.arm_estagiocarregmob_ordem,99) >= 4 -- (4) Conferido ou (5) Finalizado
                     And trunc(s.fcf_veiculodisp_data) >= trunc(Sysdate)-QtdeDiasDisp                                    
--                     Order By to_char((trunc(sysdate) - trunc(s.fcf_veiculodisp_data))) Desc
                   ) 
    Loop
      --Incremento a variável que controla-ra o número da linha
      vRetorno.Controle := vRetorno.Controle +1;
      vRetorno.Xml := vRetorno.Xml || '<row num=§'          || to_char(vRetorno.Controle) || '§>'
                                   || '<Veic_Codigo>'       || vCursor.Veic_Codigo        || '</Veic_Codigo>'       
                                   || '<Veic_Sequencia>'    || vCursor.Veic_Sequencia     || '</Veic_Sequencia>'    
                                   || '<Veic_Status>'       || vCursor.Veic_Status        || '</Veic_Status>'       
                                   || '<Veic_Data>'         || vCursor.Veic_Data          || '</Veic_Data>'         
                                   || '<Veic_Qtdediasdisp>' || vCursor.Veic_Qtdediasdisp  || '</Veic_Qtdediasdisp>' 
                                   || '<Veic_Placa>'        || vCursor.Veic_Placa         || '</Veic_Placa>'        
                                   || '<Veic_Motorista>'    || vCursor.Veic_Motorista     || '</Veic_Motorista>'    
                                   || '<Veic_Descricao>'    || vCursor.Veic_Descricao     || '</Veic_Descricao>'    
                                   || '<Veic_Ufdestino>'    || vCursor.Veic_Ufdestino     || '</Veic_Ufdestino>'    
                                   || '<Veic_Usucadastro>'  || vCursor.Veic_Usucadastro   || '</Veic_Usucadastro>'  
                                   || '<Codibge>'           || vCursor.Codibge            || '</Codibge>'           
                                   || '<Veic_Estagio_Mobile>'|| To_Char(vCursor.Veic_Estagio_Mobile) || '</Veic_Estagio_Mobile>'
                                   || '<Manifesto>'          || To_Char(vCursor.Manifesto) || '</Manifesto>'
                                   || '</row>';
    End Loop;
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
                 
  Exception
    --Caso ocorra algum erro encerra o processamento, e mostra mensagem na tela.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := '(704) ' || pCodArmazem ||'-'|| QtdeDiasDisp || 'Erro ao gerar o arquivo  XML. '|| chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack;
      Return vRetorno;
  End;  
  
  --caso o cursor retorno vazio, gero um arquivo XML sem nenhum registro.
  If vRetorno.Controle = 0 Then
    vRetorno.Xml := vRetorno.Xml || '<row num=#0#>';
    vRetorno.Xml := vRetorno.Xml || '<Veic_Codigo />'       ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Sequencia />'    ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Status />'       ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Data />'         ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Qtdediasdisp />' ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Placa />'        ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Motorista />'    ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Descricao />'    ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Ufdestino />'    ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Usucadastro />'  ;
    vRetorno.Xml := vRetorno.Xml || '<Codibge />'           ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Estagio_Mobile>99</Veic_Estagio_Mobile>';   
    vRetorno.Xml := vRetorno.Xml || '<Manifesto>9</Manifesto>'; 
    vRetorno.Xml := vRetorno.Xml || '</row>';
    
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
  End If;
  
  --retorno a variável com resultado da função.
  Return vRetorno;
  
End FNP_Xml_ListaVeicContratados;

---------------------------------------------------------------------------------------------------------------
-- Função utilizada para gerar arquivo XML dos carregamento vinculados a um determinado veiculo.             --            
---------------------------------------------------------------------------------------------------------------
Function FNP_Xml_VeicCarreg( pArmazem tdvadm.t_arm_armazem.arm_armazem_codigo%Type ) Return pkg_fifo.tRetornoFunc Is
 --Variável utilizada para retorno da função.
 vRetorno pkg_fifo.tRetornoFunc;
Begin
  
 --Limpo as variáveis que vou utilizar para garantir que não pegar nenhum lixo.
 vRetorno.Status   := '';
 vRetorno.Message  := '';
 vRetorno.Controle := 0;
 
 Begin
   --Crio um laço de repetição para poder pegar todos os registro do cursor gerado.
   For vCursor In ( SELECT 
                      ca.arm_carregamento_codigo                                          Carreg_codigo,
                      to_char(ca.arm_carregamento_dtfechamento, 'dd/mm/yyyy hh24:mi:ss')  Carreg_DtFechamento,
                      to_char(ca.arm_carregamento_dtviagem, 'dd/mm/yyyy hh24:mi:ss')      Carreg_dtViagem,
                      ca.fcf_veiculodisp_codigo                                           Veic_codigo ,
                      ca.fcf_veiculodisp_sequencia                                        Veic_sequencia
                    FROM 
                      T_ARM_CARREGAMENTO CA,
                      t_fcf_veiculodisp  Veic
                    
                    WHERE 
                      0=0
                      And ca.fcf_veiculodisp_codigo = veic.fcf_veiculodisp_codigo
                      And ca.fcf_veiculodisp_sequencia = veic.fcf_veiculodisp_sequencia 
--                      And Trunc(veic.fcf_veiculodisp_data) >= Trunc(Sysdate)-10
                      And Trunc(ca.arm_carregamento_dtfechamento) >= Trunc(Sysdate)-20

                      And veic.fcf_veiculodisp_flagvirtual Is Null
                      And veic.fcf_veiculodisp_flagvalefrete Is Null
                      And veic.fcf_ocorrencia_codigo Is Null
                      And ca.arm_armazem_codigo = Trim(pArmazem)
                    ORDER BY 
                      ca.arm_carregamento_codigo
                  )
    Loop
      --Incrementa a variável de controle de linha
      vRetorno.Controle := vRetorno.Controle + 1;
      vRetorno.Xml := vRetorno.Xml || '<row num=§'            || to_char( vRetorno.Controle ) || '§>'                    
                                   || '<Carreg_Codigo>'       || vCursor.Carreg_Codigo        || '</Carreg_Codigo>'       
                                   || '<Carreg_Dtfechamento>' || vCursor.Carreg_Dtfechamento  || '</Carreg_Dtfechamento>' 
                                   || '<Carreg_Dtviagem>'     || vCursor.Carreg_Dtviagem      || '</Carreg_Dtviagem>'     
                                   || '<Veic_Codigo>'         || vCursor.Veic_Codigo          || '</Veic_Codigo>'         
                                   || '<Veic_Sequencia>'      || vCursor.Veic_Sequencia       || '</Veic_Sequencia>'      
                                   || '</row>';
    End Loop;              
  Exception
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao gerar XML de Veiculos contratados.' || chr(13) ||Sqlerrm || chr(13) || dbms_utility.format_call_stack;
      Return vRetorno;
  End;
  
  If vRetorno.Controle = 0 Then
    vRetorno.Xml := vRetorno.Xml || '<row num=#0#>'           ;
    vRetorno.Xml := vRetorno.Xml || '<Carreg_Codigo />'       ;
    vRetorno.Xml := vRetorno.Xml || '<Carreg_Dtfechamento />' ;
    vRetorno.Xml := vRetorno.Xml || '<Carreg_Dtviagem />'     ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Codigo />'         ;
    vRetorno.Xml := vRetorno.Xml || '<Veic_Sequencia />'      ;
    vRetorno.Xml := vRetorno.Xml || '</row>'                  ;
  End If;
  
  vRetorno.Status := pkg_fifo.Status_Normal;
  vRetorno.Message := '';
  Return vRetorno;
  
End FNP_Xml_VeicCarreg;  


----------------------------------------------------------------------------------------------------------------------------
-- Função utilizada para realizar as operações necessárias para mudar o Ctrc / Nf da serie XXX para Serie de Doc Impresso --
----------------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_CTRCImpress( pParamsEntrada   Varchar2 ) Return PKG_FIFO.tRetornoFunc Is
  -- para sabe quem me chamou
  call_stack  varchar2(4096) default dbms_utility.format_call_stack;
  vAuxiliar Integer;
  
 --Variáveus utilizadas para recuperar os valores enviados pelo frontEnd.
 vUsuario    tdvadm.t_usu_usuario.usu_usuario_codigo%Type:= '';
 vRota       tdvadm.t_glb_rota.glb_rota_codigo%Type:= '';
 vAplicacao  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type := '';
 vCarreg     tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type:= '';
 vNrForm     Varchar2(06) := '';
 vSerieForm  Char(02) := '';
 
 --Variável utilizada para gerar o CTRC.
 vCtrcFinal    tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type := '';
 vSerieFinal   tdvadm.t_glb_rota.glb_rota_codigo%Type := '';
 vTpFormulario Varchar2(30):= '';
 
 --Variável utilizado para controlar o pulo do formulário.
 vCount Integer := 0;
 
 --Variável que será utilizada como retorno da Função
 vRetorno  pkg_fifo.tRetornoFunc;
 
 vMessage Varchar2(5000);
 vStatus  Char(1);
 

  vXmlSaida  Varchar2(32000) := '';
 
Begin
  --Limpo as variável que serão utilizadas apenas para garantir que não vou pegar lixo.
  vRetorno.Controle := 0;
  
  
  Begin
    --Select que será utilizado para para poder extrair as variáveis do paramentro de entrada,
    Select 
      extractvalue(value(field), 'input/usuario'),
      extractvalue(value(field), 'input/rota'),
      extractvalue(value(field), 'input/aplicacao'),
      extractValue(Value(Field), 'input/carregamento' ),
      extractValue(Value(Field), 'input/num_formulario' ),
      extractValue(Value(Field), 'input/serie_formulario' )
    Into 
     vUsuario,
     vRota,
     vAplicacao,
     vCarreg,
     vNrForm,
     vSerieForm
    from 
     Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input'))) field;  
  Exception
   --Caso ocorra algum erro, dou a informação na tela, junto com o erro Ora + a arvore tracada pelo Call_stack
   When Others Then
     vRetorno.Status := pkg_fifo.Status_Erro;
     vRetorno.Message := 'Erro ao tentar extrar Variáveis do Paramentro de Entrada.' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack ;
     Return vRetorno;
  End;
 
  --Agora vou buscar os formulário que tenha sido selecionados.
  For vCursorForm In ( Select 
                          ExtractValue(Value(Field), 'row/ctrc_codigo' )  ctrc_codigo,
                          ExtractValue(Value(Field), 'row/ctrc_rota' )    ctrc_rota,
                          ExtractValue(Value(Field), 'row/ctrc_serie' )   ctrc_serie,
                          ExtractValue(Value(Field), 'row/StatusImp' )    StatusImp,
                          ExtractValue(Value(Field), 'row/rotaCte' )      rotaCte,
                          ExtractValue(Value(Field), 'row/tpFormulario' ) tpFormulario,
                          ExtractValue(Value(Field), 'row/viagem_num' )   Viagem_num,
                          ExtractValue(Value(Field), 'row/viagem_saq' )   Viagem_saq,
                          ExtractValue(Value(Field), 'row/viagem_rota' )  Viagem_rota
                          
                        From
                          Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input/Tables/Table/ROWSET/row'))) field
                     ) 
                     Loop
                       

    --Primeiro Verifico se o documento já foi impresso.
    If Trim(vCursorForm.Ctrc_Serie) <> 'XXX' Then
      vRetorno.Status := 'E';
      vRetorno.Controle := vRetorno.Controle +1;
      vRetorno.Message := vRetorno.Message || to_char( vRetorno.Controle, '09' ) || ' - Documento já impresso. Doc. Número: '|| vCursorForm.Ctrc_Codigo || ' Rota: ' || vCursorForm.Ctrc_Rota || chr(13);
      Return vRetorno;
    End If;
    
    --Caso o Ctrc não tenha sido impresso,Inicio o processo.
    If Trim(vCursorForm.Ctrc_Serie) = 'XXX' Then
      --define a Série do Documento.
      If Trim(vCursorForm.Ctrc_Rota) = '530' Then
        vSerieFinal := 'A0';
      Else
        vSerieFinal := 'A1';
      End If;  
      
      --Roda a procedure que vai buscar o próximo DOCUMENTO para a ROTA.
      Begin
        --Limpa a variável que receberá o Codigo CTRC definitivo.
        vCtrcFinal :=  '';
        
        --Rodo a Busca Próximo para pegar o número do próximo conhecimento.
        sp_busca_proximoctrc( vCursorform.Ctrc_Rota, vCtrcFinal );

      Exception
        --Caso de algum erro ao buscar o próximo Código, encerra o processamento.
        When Others Then
          vRetorno.Status := pkg_fifo.Status_Erro;
          vRetorno.Message := 'Erro ao executar a procedure "SP_BUSCA_PRÓXIMO"."' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack;  
          Return vRetorno;
      End; 
      
      --Efetua validação, apenas para ter certeza de que o código trago pela buscaProximo não é nulo.
      If ( ( Trim(vCtrcFinal) = '000000' ) Or ( nvl(Trim( vCtrcFinal), 0) = 0 ) ) Then
        --Caso o valor seja inválido, encerra o processamento.
        vRetorno.Status  := pkg_fifo.Status_Erro;
        vRetorno.Message := 'Erro ao gerar a procedure "SP_BUSCA_PRÓXIMO". '|| chr(13) || 'Código gerado inválido.' || sqlerrm;
        Return vRetorno;
      End If;   
      
      /*//////////////////////////////////////////////////////////////////////////////////////
      //                                  ROTA ELETRONICA                                   //
      //////////////////////////////////////////////////////////////////////////////////////*/
      --Verifico se a Rota do Documento, é uma rota Eletronica
      If ( FN_RETORNA_TPAMBCTE( vCursorForm.Ctrc_Rota ) = '1' ) Then
        
        Begin
          --Caso a Rota seja eletronica, verifico se Existe Documento pendente.
          SP_CON_VALIDAROTACTE( vCursorForm.Ctrc_Rota, vStatus, vMessage );
        
          --Caso tenha retornado erro, finaliza o processamento, mostra na tela o erro, junto com possíveis erros encontrados até aqui.
          If vStatus = pkg_fifo.Status_Erro Then
            vRetorno.Controle := vRetorno.Controle +1;
            vRetorno.Message := vRetorno.Message || to_char( vRetorno.Controle, '09') || ' - ' || vMessage; 
            Return vRetorno;
          End If;
        
          --Reseto a variável de Numero de formulário.
          vNrForm := '';
        Exception
          When Others Then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Controle := vRetorno.Controle +1;
            vRetorno.Message := vRetorno.Message || to_char( vRetorno.Controle, 09) || ' - Erro ao Validar rota CTE.' || chr(13)|| Sqlerrm || chr(13) || dbms_utility.format_call_stack;  
            Return vRetorno;
        End; 
        
        --Sendo uma rota de CTE Validada, preciso de um xml sem valor. Assim não vai dar erro quando for buscar os formulários impressos
        vXmlSaida := vXmlSaida || '<row num=§0§>' ;
        vXmlSaida := vXmlSaida || '<ctrc_codigo />';
        vXmlSaida := vXmlSaida || '<ctrc_serie />';
        vXmlSaida := vXmlSaida || '<ctrc_rota />';
        vXmlSaida := vXmlSaida || '</row>';
         
      End If;
      
      
      /*//////////////////////////////////////////////////////////////////////////////////////
      //                                  ROTA NÃO ELETRONICA                               //
      //////////////////////////////////////////////////////////////////////////////////////*/
      --Verifico se a Rota do Documento, é uma rota Não Eletronica
      If ( FN_RETORNA_TPAMBCTE( vCursorForm.Ctrc_Rota ) = '2' ) Then
        
        --Verifico o tipo do Formulário que será utilizado.
        vTpFormulario := F_BUSCA_CONHEC_TPFORMULARIO( vCursorForm.Ctrc_Codigo,
                                                      vCursorForm.Ctrc_Serie,
                                                      vCursorForm.Ctrc_Rota
                                                    );
                                                    
        --Define o número do formulário que dever ser utilizado. Número do Formulário definido mais a Variável de controle.
        vNrForm := lpad( to_number(vNrForm)+ vCount , 6 , '0'  );
        
        --incrementa a variável que controla o número do formulario.
        vCount := vCount +1;

        --Verifica se o Formulário já foi utilizado. 
        If (fn_busca_proximoformulario( vCursorForm.Ctrc_Rota, vNrForm ) <> 1 ) Then
          --Caso já tenha sido utiliza, encerro o processo, retornando erro.
          vRetorno.Status := pkg_fifo.Status_Erro;
          vRetorno.Controle := vRetorno.Controle +1;
          vRetorno.Message := vRetorno.Message || to_char(vRetorno.Controle, 09)  || ' - Erro ao validar o formulário: ' || vNrForm;
          
          Return vRetorno;
        End If;
        
        --Monto uma linha de um arquivo XML para ser utilizado como retorno, XML de CTRCs impressos em FORMULÁRIOS.
        vXmlSaida := vXmlSaida || '<row num=§'    || to_char(vCount+1)     ||'§ >' ;
        vXmlSaida := vXmlSaida || '<ctrc_codigo>' || vCtrcFinal            || '</ctrc_codigo>';
        vXmlSaida := vXmlSaida || '<ctrc_serie>'  || vSerieFinal           || '</ctrc_serie>';
        vXmlSaida := vXmlSaida || '<ctrc_rota>'   || vCursorForm.Ctrc_Rota || '</ctrc_rota>';
        vXmlSaida := vXmlSaida || '</row>';
      End If;
      
      Begin
        --Série definitiva, Codigo CTRc definitiva, e dados de viagem. De pose desses dados, rodo MOVE_DADOS
        sp_move_dados_cnhc_viag( trim(vCursorForm.Ctrc_Codigo),   --Codigo de Ctrc Série XXX
                                 trim(vCtrcFinal),                --Código Ctrc Final
                                 trim(vSerieFinal),               --Série Final
                                 trim(vCursorform.Viagem_Num),    --Código de Viagem do Ctrc XXX
                                 trim(vCursorForm.Viagem_Saq),    --Saque de Viagem do Ctrc XXX
                                 trim(vCursorForm.Viagem_Rota),   --Rota de Viagem do Ctrc XXX
                                 trim(vNrForm)
                               ); 

         vAuxiliar := 0;                              
         select count(*)
           into vAuxiliar
         from t_con_conhecimento c
         where c.con_conhecimento_codigo = vCursorForm.Ctrc_Codigo
           and c.con_conhecimento_serie = 'XXX';

         if vAuxiliar > 0 Then
             wservice.pkg_glb_email.SP_ENVIAEMAIL('1 FALHA PROCESSO EM MASSA. '||'CTe XXX - ' || vCursorForm.Ctrc_Codigo || ' - CTe A1 - ' || vCtrcFinal ||' - Rota - ' || vCursorForm.Viagem_Rota,
                                                  'CTe XXX - ' || vCursorForm.Ctrc_Codigo || 
                                                  ' - CTe A1 - ' || vCtrcFinal || 
                                                  ' - Rota - ' || vCursorForm.Viagem_Rota || chr(10) ||
                                                  'Rotina - pkg_fifo_ctrc.FNP_Xml_CTRCImpress linha 1006' || chr(10) ||
                                                  'Trilha - ' || call_stack,
                                                  'aut-e@dellavolpe.com.br',
                                                  'ksouza@dellavolpe.com.br;ddamaceno@dellavolpe.com.br');
         End If;                                     


      Exception
        When Others Then
          --se der algum erro ao rodar a move. Encerra o processamento.
          vRetorno.Status := pkg_fifo.Status_Erro;
          vRetorno.Controle := vRetorno.Controle + 1;
          vRetorno.Message := vRetorno.Message || to_char(vRetorno.Controle, 09) ||' - Erro ao rodar ao Gerar CTE.' || chr(13)|| Sqlerrm || chr(13) || dbms_utility.format_call_stack;
          Return vRetorno;
      End;
          
         
    End If; --Fim do if que verifica se o documento está na série XXX
   
  End Loop;   
  
  vRetorno.Xml := vRetorno.Xml || '<Parametros><Inputs><input><Tables><Table name=#ListCtrcForms#><ROWSET>';
  vRetorno.Xml := vRetorno.Xml || vXmlSaida;
  vRetorno.Xml := vRetorno.Xml || '</ROWSET></Table></Tables></input></Inputs></Parametros>';
   
  vRetorno.Xml := Replace( vRetorno.Xml, '§', '''');
  vRetorno.Xml := Replace( vRetorno.Xml, '#', '"'); 
  
  vRetorno.Status := pkg_fifo.Status_Normal;
  Return vRetorno;
 
End FNP_Xml_CTRCImpress; 

---------------------------------------------------------------------------------------------------------------
--Função utilizada para atualizar a quantia de CTRC Impressoes e Não impressos a partir de um Armazem
---------------------------------------------------------------------------------------------------------------
Function FNP_AtualizaQtdeCtrc( pArm_armazem_codigo In tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                               pMessage Out Varchar2
                              ) Return Boolean Is 
 --Variável que será utilizada para criar / recuperar mensagens
 --vMessage Varchar2(10000); 
 
 --Variáveis utilizadas para recuperar a quantia de CTRCs
 vQtdeCtrc    number  := 0;
 vQtdeCtrcImp number := 0;
 
 
Begin
  --inicializo as variáveis utilizadas nessa função.
  --vMessage := '';

  Begin
     
    For vCursor In ( SELECT 
                        ca.arm_carregamento_codigo  Carregamento,
                        ca.arm_carregamento_qtdctrc  QtdeCtrc,
                        ca.arm_carregamento_qtdimpctrc QtdeCtrcImp
                      FROM 
                        T_ARM_CARREGAMENTO CA
                      Where
                        0=0
                        And CA.ARM_CARREGAMENTO_DTFECHAMENTO IS NOT Null
                        and CA.FCF_VEICULODISP_CODIGO  IS NOT Null
                        And CA.ARM_CARREGAMENTO_DTFINALIZACAO IS Null
                        and CA.Arm_Armazem_Codigo = pArm_armazem_codigo
                        And TRUNC(CA.ARM_CARREGAMENTO_DTFECHAMENTO) >= SYSDATE-10
                   )
                   Loop
                     --Pego a Quantia de CTRC de um carregamento.
                    Select Count(*) Into vQtdeCtrc
                    From t_arm_carregamentodet det
                    Where det.arm_carregamento_codigo = vCursor.Carregamento;
                    
                    Select Count(*) Into vQtdeCtrcImp
                    From t_arm_nota n,  t_arm_carregamentodet d
                    Where n.arm_embalagem_numero = d.arm_embalagem_numero
                     And n.arm_embalagem_flag = d.arm_embalagem_flag
                     And n.arm_embalagem_sequencia = d.arm_embalagem_sequencia
                     And d.arm_carregamento_codigo = vCursor.Carregamento
                     -- Joao / sirlano
                     -- Atualizando QTDE de CTe AUTORIZADOS
  --                   And n.con_conhecimento_serie <> 'XXX';
                     And  trim(Tdvadm.Pkg_Con_Cte.FN_CTE_EELETRONICO(n.Con_Conhecimento_Codigo,
                                                                     n.Con_Conhecimento_Serie,
                                                                     n.Glb_Rota_Codigo)) = 'S';
                     
                     Begin
                       --Verifico se as quantias de ctrc e qtde de ctrcs impressão são diferentes das atuais do Carregamento
                       if ( vQtdeCtrc <> vCursor.Qtdectrc ) or ( vQtdeCtrcImp <> vCursor.Qtdectrcimp ) then
                       
                       --Atualizo as quantidades de CTRCs do carregamento.
                       Update tdvadm.t_arm_carregamento w
                         Set w.arm_carregamento_qtdctrc = vQtdeCtrc,
                           w.arm_carregamento_qtdimpctrc = vQtdeCtrcImp
                        Where w.arm_carregamento_codigo = vCursor.Carregamento;
                        
                       end if;
                     
                     Exception
                       When Others Then
                         Rollback;
                         pMessage := 'Erro ao atualizar os dados dos CTRC';
                         Return False;

                     End;
                       
                   
                     
                   End Loop;


                   For vCursor In ( SELECT 
                                           ca.arm_carregamento_codigo  Carregamento
                      FROM 
                        T_ARM_CARREGAMENTO CA
                      Where
                        0=0
                        And CA.ARM_CARREGAMENTO_DTFECHAMENTO IS Null
                        And CA.ARM_CARREGAMENTO_DTFINALIZACAO IS Null
                        and CA.Arm_Armazem_Codigo = pArm_armazem_codigo
                   )
                   Loop
                       Update tdvadm.t_arm_carregamento w
                         Set w.arm_carregamento_qtdctrc = 0,
                           w.arm_carregamento_qtdimpctrc = 0
                       Where w.arm_carregamento_codigo = vCursor.Carregamento;
                     
                   end loop;
  Exception 
    When Others Then
      Rollback;
      pMessage := 'Erro ao buscar CTRCs do armazem ' || pArm_armazem_codigo;
      Return False;
  End;  
  
  --Caso o processamento tenha chegado ate aqui é porque não ocorreu nenhum erro.
  --salvo as alterações e seto a variável de retorno para Normal, e limpo a variável de mensagem.
  Commit;
  pMessage := '';
  Return True;
  
  
End FNP_AtualizaQtdeCtrc;    

---------------------------------------------------------------------------------------------------------------
-- Função utilizada para atualizar a quantia de CTRC Impressos a partir de um Carregamento
---------------------------------------------------------------------------------------------------------------
Function FNP_AtualizarCtrcImp( pCodCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type) Return pkg_fifo.tRetornoFunc Is
vQtdeCtrc  Integer := 0;
vQtdeCtrcImp Integer := 0;
--vQtdeCtrcPlaca Integer := 0;

vRetorno  pkg_fifo.tRetornoFunc;
--vManifesto Char(01);

Begin
  --vManifesto := '';
  
  
  --quantia de Ctrc de um carregamento.
 Select Count(*) Into vQtdeCtrc
 From tdvadm.t_con_conhecimento c
 Where c.arm_carregamento_codigo = pCodCarregamento;
 
 -- Quantia de ctrc Impressos.
 Select Count(*) Into vQtdeCtrcImp
 From tdvadm.t_con_conhecimento c
 Where c.arm_carregamento_codigo = pCodCarregamento
 -- 16/11/2021
 -- Joao / Sirlano
   and trim(Tdvadm.Pkg_Con_Cte.FN_CTE_EELETRONICO(c.Con_Conhecimento_Codigo,
                                                  c.Con_Conhecimento_Serie,
                                                  c.Glb_Rota_Codigo)) = 'S';
  --And c.con_conhecimento_serie <> 'XXX'; 
 
  Begin
    --Atualiza a quantia de CTRCs
    Update tdvadm.t_arm_carregamento w
      Set w.arm_carregamento_qtdctrc = vQtdeCtrc,
          w.arm_carregamento_qtdimpctrc = vQtdeCtrcImp

    Where w.arm_carregamento_codigo = pCodCarregamento;
    
    Commit;
    
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
    Return vRetorno;
      
  Exception
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao atualizar quantidade de Documentos. ' || Sqlerrm;
      Return vRetorno;
  End;
  

End FNP_AtualizarCtrcImp;                              
              
---------------------------------------------------------------------------------------------------------------
-- função utilizada para realizar a vinculação e Desvinculção entre um carregamento e um Veiculo.            --
---------------------------------------------------------------------------------------------------------------
Function FNP_VinculaCarregVeic( pCarreg_Codigo   tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                pVeic_Codigo     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pVeic_Sequencia  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pUsu_codigo      tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                                pAcao            Char,
                                pAplicacao       tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type  Default 'carreg'
                              ) Return pkg_fifo.tRetornoFunc Is
                              
 --Variável utilizada para retorno da função.
 vRetorno pkg_fifo.tRetornoFunc;
 
 --Variável que será utilizada quando precisar de um veículo virtual. "Desvinculação.";
 vCodVeic_Virtual  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type := ''; 
 
 --Códigos de Veiculos
 vVeic_codigo   tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type:= '';
 vVeic_Sequencia tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type := '';
 
 --Variável de controle 
 vControl integer;
Begin
  --Primeiro limpo as variáveis que vou utilizar para garantir que não vou pegar lixo.
  vRetorno.Status := '';
  vRetorno.Controle := 0;
  vRetorno.Message := ''; 
  
  
  Begin
      --Caso a Ação esteja apontada para vinculação
      If ( pAcao =  vAcoes.Vinculacao_VeicCarreg ) Then
        /*  A Ação de VINCULAR um Veiculo a um carregamento, consiste em:
           1º Atualizar a tabela de Carregamento, retirando um Veiculo virtual, por um veiculo real.
           2º Atualizar a Tabela de Veiculo adicionando o código do carregamento.
           3º Atualizar a tabela de viagem com os códigos do motorista e veículos.
           4º Adicionar a placa do veiculo em todos os conhecimentos NÃO IMPRESSO, que estão no carregamento.
           
           já existe uma procedure pronta e testada que faz muito bem esse trabalho.
           SP_MESA_ADDVEICNOCARREG, como paramentro deve ser passado, o Código e a sequencia do veículo, código do carregamento e o usuario que está executando
        */
        Begin
          tdvadm.sp_mesa_addveicnocarreg( Trim(pVeic_Codigo),
                                          Trim(pVeic_Sequencia),
                                          Trim(pCarreg_Codigo),
                                          Trim(pUsu_codigo)
                                        );
          vRetorno.Status := pkg_fifo.Status_Normal;
          vRetorno.Message := '';


 
         Commit;
        Exception
          When Others Then
            vRetorno.Status := pkg_fifo.Status_Erro;
            vRetorno.Message := 'Erro ao tentar vincular veiculo ao carregamento '|| pCarreg_Codigo || chr(13) || Sqlerrm;
            Rollback;
      --      Insert Into dropme (a, l) Values ('Erro ao vincular carregamento '|| pCarreg_Codigo, vRetorno.Message);
       --     Commit;
            
            Return vRetorno;
        End;                                  
      End If;
      
      --Caso a Ação esteja apontada para desvinculação.
      If ( pAcao = vAcoes.Desvinculacao_VeicCarreg) Then
        /*   A Ação de DESVINCULAR um VEICULO de um CARREGAMENTO, consiste em:
             1º Criar um veiculo virtual para substituir o veiculo real.
             2º Retirar o Código do Veiculo do carregamento.
             3º Retirar o Código do Carregamento da tabela de Veiculo Disp.
             4º Atualizar a tabela de viagem, retirando os dados do Veiculo e motorista.
             5º Retirar dos Conhecimentos ainda não impressos, o código do Veículo.        */
        
        --Verifico se o Carregamento e o Veiculo passado, estão vinculados.
        
        --verifico se está vindo do projeto mobile
        If trim(lower(pAplicacao)) = 'carregmob' Then
          Begin
            Select w.fcf_veiculodisp_codigo,
                   w.fcf_veiculodisp_sequencia
              Into vVeic_codigo,
                   vVeic_Sequencia 
              From t_arm_carregamento w
            Where w.arm_carregamento_codigo = pCarreg_Codigo; 
          Exception
            When Others Then
              vRetorno.Status := pkg_glb_common.Status_Erro;
              vRetorno.Message := 'Erro ao buscar código de Veiculo para o projeto Mobile';
              Return vRetorno;
          End;     
          
        Else
          vVeic_codigo := pVeic_Codigo;
          vVeic_Sequencia := pVeic_Sequencia;  
        End If;
        
        select Count(*)
          into vRetorno.Controle
          from t_con_veicdispmanif vm
          where vm.fcf_veiculodisp_codigo = pVeic_Codigo
            and vm.fcf_veiculodisp_sequencia = pVeic_Sequencia;
        if vRetorno.Controle > 0 then
           vRetorno.Status  := pkg_fifo.Status_Erro;
           vRetorno.Message := 'Erro ao desvincular carregamento.'||chr(13)||
                               'Veículo possui Manifesto Gerado.';
           Return vRetorno;       
        end if;
            
        Select 
          count(*) into vRetorno.Controle
        FROM 
          t_arm_carregamento t
        where 
          0=0
          And t.arm_carregamento_codigo   = pCarreg_Codigo
          and t.fcf_veiculodisp_codigo    = vVeic_codigo
          and t.fcf_veiculodisp_sequencia = vVeic_Sequencia;
          
         --Caso não exista nenhum carregamento, suspendo a procedure e retorno uma mensagem para o usuario 
         if vRetorno.Controle = 0 then
           vRetorno.Status  := pkg_fifo.Status_Erro;
           vRetorno.Message := 'Erro ao desvincular carregamento.'||
                                chr(13)||chr(13)||
                               'Não existe carregamento vinculado ao veículo informado.';
           Return vRetorno;
         end if;
         
         -- Verificao o Estagio do Carregamento antes de Deixar Desvincular
         -- verifica se existe um veiculo real 
         
         if pAplicacao != 'carregmob' then
               select count(*) 
                  into vControl
               from t_fcf_veiculodisp vd,
                    t_arm_estagiocarregmob est
               where vd.fcf_veiculodisp_codigo    = vVeic_codigo
                 and vd.fcf_veiculodisp_sequencia = vVeic_Sequencia
                 and VD.arm_estagiocarregmob_codigo = EST.ARM_ESTAGIOCARREGMOB_CODIGO (+)
                 and NVL(est.arm_estagiocarregmob_ordem,0) >= 4; -- (4) Conferido ou (5) Finalizado
               
               if vControl > 0 Then
                 vRetorno.Status  := pkg_fifo.Status_Erro;
                 vRetorno.Message := 'PROBLEMA ao desvincular carregamento.'||
                                      chr(10)||chr(10)||
                                     'O Carregamento foi Feito pelo Coletor e se encontra Conferido ou Finalizado.';
                 Return vRetorno;
               end if;
         end if;
            
         
         
         --Gero um veiculo virtual, Usando como paramentro o próprio carregamento por questões de peso.
         vCodVeic_Virtual := pkg_fifo.fn_CriaVeicVirtual( pCarreg_Codigo);
         
         --Verifico se existe registro na tabela de carremantoveic
         
          Select Count(*) Into vControl 
          From T_ARM_CARREGAMENTOVEIC veic
          Where veic.arm_carregamento_codigo = pCarreg_Codigo;
          
          If ( vControl  >  0 )  Then
            Delete T_ARM_CARREGAMENTOVEIC veic
            Where veic.Arm_Carregamento_Codigo = pCarreg_Codigo;
          End If;
         
         --Atualizo o Carregamento, "Substituo o Veiculo vinculado ao Veículo virtual que acabei de criar.
          update  t_arm_carregamento t
           set t.fcf_veiculodisp_codigo     = vCodVeic_Virtual,
               t.fcf_veiculodisp_sequencia  = '0',
               t.car_veiculo_placa          = null
           where
                  t.arm_carregamento_codigo   = pCarreg_Codigo
              and t.fcf_veiculodisp_codigo    = vVeic_codigo
              and t.fcf_veiculodisp_sequencia = vVeic_Sequencia;
          
          --É necessarui também retirar o código do carregamento da Tabela de Veículo.
           update t_fcf_veiculodisp t
            set t.arm_carregamento_codigo = null
           where 
                t.fcf_veiculodisp_codigo    = vVeic_codigo
            and t.fcf_veiculodisp_sequencia = vVeic_Sequencia;
        
          Begin
            --Agora preciso de um laço de repetição para pegar todos os Conhecimentos,QUE AINDA NÃO FORAM IMPRESSOS. para retirar o Veiculo.
            For vCursor In ( Select 
                              ctrc.con_conhecimento_codigo,
                              ctrc.con_conhecimento_serie,
                              ctrc.glb_rota_codigo,
                              ctrc.arm_carregamento_codigo,
                              viagem.con_viagem_numero,
                              viagem.glb_rota_codigoviagem,
                              ctrc.con_conhecimento_placa
                             from 
                              t_con_conhecimento ctrc,
                              t_con_viagem   viagem
                             where 
                               0=0
                               And ctrc.con_viagem_numero        = viagem.con_viagem_numero
                               and ctrc.glb_rota_codigoviagem    = viagem.glb_rota_codigoviagem
                               and nvl(ctrc.con_conhecimento_digitado, 'I') <> 'I'
                               and Trim(ctrc.arm_carregamento_codigo) = Trim(pCarreg_Codigo)
                           )
            Loop
              
              -- retiro também os dados do Veiculo da Viagem 
              update t_con_viagem tv
                set 
                  tv.CAR_CARRETEIRO_CPFCODIGO   = null,
                  tv.CAR_CARRETEIRO_SAQUE			  = null,
                  tv.FRT_MOTORISTA_CODIGO			  = null,
                  tv.FRT_CONJVEICULO_CODIGO			= null,
                  tv.CON_VIAGEM_CPFCODIGO			  = null,
                  tv.CON_VIAGEM_CPFSAQUE			  = null,
                  tv.CON_VIAGEM_FRTMOTORISTA		= null,	
                  tv.CON_VIAGEM_CONJVEICULO			= null,
                  tv.CON_VIAGEM_PLACA			      = null,
                  tv.CON_VIAGEM_PLACASAQUE			= Null
              Where
                  tv.con_viagem_numero         = vCursor.Con_Viagem_Numero
                and tv.glb_rota_codigoviagem     = vCursor.Glb_Rota_Codigoviagem;
                
              --Atualizo os conhecimentos retirando a placa do Veiculo dos Conhecimentos
              update t_con_conhecimento ctrc
                set ctrc.con_conhecimento_placa   = Null
              where 
                  ctrc.con_conhecimento_codigo    = vCursor.Con_Conhecimento_Codigo
                and ctrc.con_conhecimento_serie   = vCursor.Con_Conhecimento_Serie
                and ctrc.glb_rota_codigo          = vCursor.Glb_Rota_Codigo;
            End Loop;                   
          
            Commit;
            vRetorno.Status := pkg_fifo.Status_Normal;
            vRetorno.Message := '';
          Exception
            When Others Then
              vRetorno.Status := pkg_fifo.Status_Erro;
              vRetorno.Message := 'Erro ao tentar desvincular o Veiculo do Carregamento.' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack;
              Return vRetorno; 
          End;
      End If;
  Exception
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := sqlerrm;    
  End;
  
 Return vRetorno;
   
  
  
End FNP_VinculaCarregVeic;

---------------------------------------------------------------------------------------------------------------
-- Função utilizada para verificar se o Armazem pertence a Rota Passada.
---------------------------------------------------------------------------------------------------------------
Function FNP_VerificaArmaRota( pRota    tdvadm.t_glb_rota.glb_rota_codigo%Type,
                               pArmazem tdvadm.t_arm_armazem.arm_armazem_codigo%Type 
                             ) Return pkg_fifo.tRetornoFunc Is
  vRetorno   pkg_fifo.tRetornoFunc;
Begin
  vRetorno.Controle := 0;  
  Begin
    Select 
      Count(*) Into vRetorno.Controle
    From 
      t_arm_armazem   armazem
    Where 
      0=0
      And armazem.arm_armazem_codigo = pArmazem
      And armazem.glb_rota_codigo = pRota;
      
    If vRetorno.Controle > 0 Then
      vRetorno.Status := pkg_fifo.Status_Normal;
      vRetorno.Message := '';
    Else
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Armazem não pertence a rota que você está logado.';
    End If; 
  Exception
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Erro ao tentar localizar Armazem.';
  End;
  
  Return vRetorno;        
  
End;  

---------------------------------------------------------------------------------------------------------------
--FUNÇÃO UTILIZADA PARA IMPRIMIR OS CTRC / NOTAS ELETRONICOS.                                                --
---------------------------------------------------------------------------------------------------------------
Function FNP_CTRC_Eletronico( pParamsEntrada Varchar2 ) Return pkg_fifo.tRetornoFunc Is
  -- para sabe quem me chamou
  call_stack  varchar2(4096) default dbms_utility.format_call_stack;
  vAuxiliar Integer;
  
  -- Variaveis das diferencas
  vAuxiliarF Integer; -- Frete
  vAuxiliarA Integer; -- ADVL
  vAuxiliarP Integer; -- Pedagio

 --Variável que será utilizada como retorno.
 vRetorno   pkg_fifo.tRetornoFunc;
 
 --Variáveis utilizadas para capturar paramentros vindos do XML
 vRota    tdvadm.t_glb_rota.glb_rota_codigo%Type                  :='';
 vSerie   tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type  := '';
 vCarreg  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type  := '';
 
 --Variáveis finais.
 vCtrcCodigoFinal  tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type := '';
 vCtrcSerieFinal   tdvadm.t_con_conhecimento.con_conhecimento_serie%Type := '';

 --Variável utilizada para recuperar dados do CTRC XXX
 vCtrc_Codigo    tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type:= '';
 vViagem_Codigo  tdvadm.t_con_conhecimento.con_viagem_numero%Type      := ''; 
 vViagem_Saque   tdvadm.t_con_conhecimento.con_viagam_saque%Type; 
 vViagem_Rota    tdvadm.t_con_conhecimento.glb_rota_codigoviagem%Type  := '';
 
 
 --Variável utilizada para gerar o SQL de busca de todos os CTRC da mesma rota e mesma série.
 vSelect   Varchar2(32000);
 
 cCursorCTRC   pkg_fifo.T_CURSOR;
 
 vMessage Varchar2(32000);
 
 plistaparams glbadm.pkg_listas.tlistausuparametros;

 vUsuario tdvadm.t_usu_usuario.usu_usuario_codigo%type;
 
 vBloqueiacomdiferenca char(1);
 
vCarregVirtual tdvadm.t_arm_carregamento.arm_carregamento_flagvirtual%type;

Begin
  

  --Limpar as variáveis apenas garantir que não vou pegar lixo.
  vRetorno.Status  := '';
  vRetorno.Message := '';
  
  --Busco os paramentros que são passados quando o CTRC é de rota Eletronica.
  Begin
    Select 
     extractValue(Value(LinhaCtrc),    'ctrc/ctrc_rota')      ctrc_rota,
     extractValue(Value(LinhaCtrc),    'ctrc/ctrc_serie')     ctrc_serie,
     extractValue(Value(DadosBasicos), 'input/carregamento')  carregamento
    Into
      vRota,
      vSerie,
      vCarreg
    From 
      Table(xmlsequence(Extract(xmltype.createXml( pParamsEntrada ), '/Parametros/Inputs/input/ctrcs/ctrc'))) LinhaCtrc,
      Table(xmlsequence(Extract(xmltype.createXml( pParamsEntrada ), '/Parametros/Inputs/input'))) DadosBasicos;
  Exception
    --Caso ocorra algum erro, finalizo o processamento e defino uma mensagem de erro.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Não foi possível localizar as dados passados por paramentros.';
      Return vRetorno;
  End;

   Begin
       select ca.usu_usuario_fechoucarreg
         into vUsuario
       from tdvadm.t_arm_carregamento ca
       where ca.arm_carregamento_codigo = vCarreg;

       if glbadm.pkg_listas.fn_get_usuparamtros('carreg',
                                                vUsuario,
                                                vRota,
                                                plistaparams,
                                                'TODOS',
                                                sysdate) Then
          BEGIN
             vBloqueiacomdiferenca := upper(trim(plistaparams('ERROSIMULADORCALC').texto));
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
               vBloqueiacomdiferenca := 'N';
            END;   
       Else
          vBloqueiacomdiferenca := 'E';
       End If;
   exception
     When OTHERS Then
       vBloqueiacomdiferenca := 'O';
     End;

   


  -- libera a partir das 17:59

      SELECT sum(abs( nvl(S.CS278_SIMULADOR_FRETE,0) - fn_busca_conhec_verba(S.CON_CONHECIMENTO_CODIGO,S.CON_CONHECIMENTO_SERIE,S.GLB_ROTA_CODIGO,'R_FRPSVOMR')))
          INTO vAuxiliarF
      FROM TDVSVA.T_CS278_SIMULADOR S
      WHERE 0 = 0
      --  and S.CS278_SIMULADOR_PROCESSO IS NOT NULL
        and s.slf_contrato_codigo in ('2781910','2781910/M','C2014030105','C5900011012'/*,'5100006176','C5100006176'*/)
        and nvl(s.cs278_simulador_calculado,'X') <> 'L'
        and substr(s.arm_carregamento_tpcarga,1,2) not in ('13','14','MA')
        and s.arm_carregamento_codigo = vCarreg
/*        and 0 < ( select count(*)
                  from t_con_conhecimento c
                  where c.con_conhecimento_codigo = s.con_conhecimento_codigo
                    and c.con_conhecimento_serie = s.con_conhecimento_serie
                    and c.glb_rota_codigo = s.glb_rota_codigo
                    and c.glb_cliente_cgccpfremetente not in (select cl.glb_cliente_cgccpfcodigo from t_xml_clientelib cl where cl.xml_clientelib_rateia = 'S' and cl.fcf_tpcarga_codigo = '11' and cl.xml_clientelib_ativo = 'S' ))
*/        and ( nvl(S.CS278_SIMULADOR_FRETE,0) = 0 
         or abs( nvl(S.CS278_SIMULADOR_FRETE,0) - fn_busca_conhec_verba(S.CON_CONHECIMENTO_CODIGO,S.CON_CONHECIMENTO_SERIE,S.GLB_ROTA_CODIGO,'R_FRPSVOMR')) > 1 );
                 


             
      SELECT sum(abs( nvl(S.Cs278_Simulador_Pedagio,0) - fn_busca_conhec_verba(S.CON_CONHECIMENTO_CODIGO,S.CON_CONHECIMENTO_SERIE,S.GLB_ROTA_CODIGO,'I_PD')))
          INTO vAuxiliarP
      FROM TDVSVA.T_CS278_SIMULADOR S
      WHERE 0 = 0
      --  and S.CS278_SIMULADOR_PROCESSO IS NOT NULL
        and s.slf_contrato_codigo in ('2781910','2781910/M','C2014030105','C5900011012'/*,'5100006176','C5100006176'*/)
        and nvl(s.cs278_simulador_calculado,'X') <> 'L'
        and substr(s.arm_carregamento_tpcarga,1,2) not in ('13','14','MA')
        and s.arm_carregamento_codigo = vCarreg
/*        and 0 < ( select count(*)
                  from t_con_conhecimento c
                  where c.con_conhecimento_codigo = s.con_conhecimento_codigo
                    and c.con_conhecimento_serie = s.con_conhecimento_serie
                    and c.glb_rota_codigo = s.glb_rota_codigo
                    and c.glb_cliente_cgccpfremetente not in (select cl.glb_cliente_cgccpfcodigo from t_xml_clientelib cl where cl.xml_clientelib_rateia = 'S' and cl.fcf_tpcarga_codigo = '11' and cl.xml_clientelib_ativo = 'S' ))
*/        and abs( nvl(S.Cs278_Simulador_Pedagio,0) - fn_busca_conhec_verba(S.CON_CONHECIMENTO_CODIGO,S.CON_CONHECIMENTO_SERIE,S.GLB_ROTA_CODIGO,'I_PD')) > 1 ;
                 
      

      SELECT sum(abs( nvl(S.Cs278_Simulador_Advl,0) - fn_busca_conhec_verba(S.CON_CONHECIMENTO_CODIGO,S.CON_CONHECIMENTO_SERIE,S.GLB_ROTA_CODIGO,'I_ADVL')))
          INTO vAuxiliarA
      FROM TDVSVA.T_CS278_SIMULADOR S
      WHERE 0 = 0
      --  and S.CS278_SIMULADOR_PROCESSO IS NOT NULL
        and s.slf_contrato_codigo in ('2781910','2781910/M','C2014030105','C5900011012'/*,'5100006176','C5100006176'*/)
        and nvl(s.cs278_simulador_calculado,'X') <> 'L'
        and substr(s.arm_carregamento_tpcarga,1,2) not in ('13','14','MA')
        and s.arm_carregamento_codigo = vCarreg
/*        and 0 < ( select count(*)
                  from t_con_conhecimento c
                  where c.con_conhecimento_codigo = s.con_conhecimento_codigo
                    and c.con_conhecimento_serie = s.con_conhecimento_serie
                    and c.glb_rota_codigo = s.glb_rota_codigo
                    and c.glb_cliente_cgccpfremetente not in (select cl.glb_cliente_cgccpfcodigo from t_xml_clientelib cl where cl.xml_clientelib_rateia = 'S' and cl.fcf_tpcarga_codigo = '11' and cl.xml_clientelib_ativo = 'S' ))
*/        and abs( nvl(S.Cs278_Simulador_Advl,0) - fn_busca_conhec_verba(S.CON_CONHECIMENTO_CODIGO,S.CON_CONHECIMENTO_SERIE,S.GLB_ROTA_CODIGO,'I_ADVL')) > 1 ;
                 


    
  IF NVL(vAuxiliarF,0) > 2  Then
     vRetorno.Status := pkg_fifo.Status_Erro;
     vRetorno.Message := vRetorno.Message || 'FRETES    => ' || tdvadm.f_mascara_valor(vAuxiliarF,10,2) || '<br />' ;
  END iF;         
 
  IF NVL(vAuxiliarP,0) > 2  tHEN
     vRetorno.Status := pkg_fifo.Status_Erro;
     vRetorno.Message :=  vRetorno.Message || 'PEDAGIOS => ' || tdvadm.f_mascara_valor(vAuxiliarP,10,2) || '<br />';
  END iF;         

  IF NVL(vAuxiliarA,0) > 0  tHEN
     vRetorno.Status := pkg_fifo.Status_Erro;
     vRetorno.Message :=  vRetorno.Message || 'ADVL     => ' || tdvadm.f_mascara_valor(vAuxiliarA,10,2) || '<br />';
  END iF;         

   
     if ( to_number(to_char(sysdate,'hh24')) between 6 and 17 ) and -- das 06:01 ate as 17:59
        ( to_number(to_char(sysdate,'d')) between 2 and 6 ) and -- de Segunda a Sexta
        TO_CHAR(sysdate,'YYYYMMDD') NOT IN ('20151224','20151225','20151231','20161201','20160420','20161114','20161115') Then
     -- Se esta dentro do horario de expediente e de segunda a sexta
        vRetorno.Status := vRetorno.Status;
     Else 
   -- Se passou do Horario muda o Status so para apresentr a mensagem
        If vRetorno.Status = pkg_fifo.Status_Erro Then
           vRetorno.Status := pkg_fifo.Status_Normal;
       end If;
     End If;

      If NVL(vAuxiliarF,0) + NVL(vAuxiliarP,0) + NVL(vAuxiliarA,0) > 2 then
         If vRetorno.Status <> pkg_fifo.Status_Normal Then
            vRetorno.Message :=  'Bloqueia = ' || vBloqueiacomdiferenca || '<br />' ||
                                 'Horario  = ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '<br />' ||
                                 'Usuario  = ' || vUsuario ||  '<br />' ||
                                 'Rota     = ' || vRota    || '<br />' ||
                                 'RE-CALCULO - PROCESSO PARADO - Procurar a TI ' || '<br />' || 
                                 vRetorno.Message ; 
            wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO DE CALCULO Carregamento ' || vCarreg ,
                                                 vRetorno.Message,
                                                 'aut-e@dellavolpe.com.br',
--                                                 'sdrumond@dellavolpe.com.br',
                                                 'lixo@dellavolpe.com.br');
             If vBloqueiacomdiferenca = 'S' Then 
                vRetorno.Message := replace(vRetorno.Message,'<br />',chr(10));
                Return vRetorno;
             End If;   
         Else
            vRetorno.Message :=  'Bloqueia = ' || vBloqueiacomdiferenca || '<br />' ||
                                 'Horario  = ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '<br />' ||
                                 'Usuario  = ' || vUsuario ||  '<br />' ||
                                 'Rota     = ' || vRota    || '<br />'  ||
                                 'RE-CALCULO - ALERTA. CTE SERA IMPRESSO COM ERRO ! ' || '<br />' || 
                                 vRetorno.Message ; 
            wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO DE CALCULO APOS HORARIO Carregamento ' || vCarreg,
                                                 vRetorno.Message,
                                                 'aut-e@dellavolpe.com.br',
--                                                 'sdrumond@dellavolpe.com.br',
                                                 'lixo@dellavolpe.com.br');
            vAuxiliarF := 0;
            vAuxiliarP := 0;
            vAuxiliarA := 0;
            vRetorno.Status := 'N';
            vRetorno.Message := '';
         End If;
      End If;

      vRetorno.Message := replace(vRetorno.Message,'<br />',chr(10));

      If vBloqueiacomdiferenca = 'S' Then
         vRetorno.Status := vRetorno.Status;
      Else 
  -- Se passou do Horario muda o Status so para apresentr a mensagem
        -- If vRetorno.Status = pkg_fifo.Status_Erro Then
            vRetorno.Status := pkg_fifo.Status_Normal;
            vRetorno.Message := '';
        -- end If;
      End If;




/*  
     if vCarreg = '318899' then
        raise_application_error(-20001,pParamsEntrada);
     end if;
  
*/  
  select 
    carreg.arm_carregamento_flagvirtual into vCarregVirtual
  from 
   t_arm_carregamento carreg
  where
    carreg.arm_carregamento_codigo = vCarreg; 
  
  --Antes de realizar a impressão verifico se as notas estão dentro do prazo.
  If ( Not tdvadm.pkg_fifo_validadoresnota.FN_Valida_PrazoNota( vCarreg, vMessage) ) Then
    vRetorno.Status := pkg_fifo.Status_Erro;
    vRetorno.Message := substr(vMessage, 1,4000);
    Return vRetorno;
  End If;
  
  --Existe algumas validações, mas apenas para deszencargo, vou olhar se documento passado não está impresso
  If Trim(vSerie) <> 'XXX' Then
    --interrompo o processamento e envio mensagem de erro.
    vRetorno.Status := pkg_fifo.Status_Erro;
    vRetorno.Message := 'Documento já impresso.' || dbms_utility.format_call_stack;
    Return vRetorno;
  End If;
  
  --Defino a Série Final
  If Trim(vRota) = '530' Then
    vCtrcSerieFinal := 'A0';
  Else
    vCtrcSerieFinal := 'A1';
  End If;
  
  --Verifico se a rota é realmente rota CTE 
  If ( fn_retorna_tpambcte(vRota) = '1' ) Then

    --Verifico se nessa rota, existe algum documento pendente.
    tdvadm.pkg_con_cte.sp_con_validarotacte( vRota, vRetorno.Status, vRetorno.Message);
    
    --Caso o retorno da procedure não seja normal, retorno o status e a mensagem gerada.
    If vRetorno.Status <> pkg_fifo.Status_Normal Then
      Return vRetorno;
    End If;
    
    --Monto o sql, que vai me trazer todos os CTRC do carregamento passado por paramentros.
    vSelect := '';
    vSelect := vSelect || ' SELECT                                                   ';
    vSelect := vSelect || '    c.con_conhecimento_codigo ,                           ';
    vSelect := vSelect || '    c.con_viagem_numero,                                  ';
    vSelect := vSelect || '    c.con_viagam_saque,                                   ';
    vSelect := vSelect || '    c.glb_rota_codigoviagem                              ';
    vSelect := vSelect || ' FROM                                                     ';
    vSelect := vSelect || '    tdvadm.t_con_conhecimento   c                         ';  
    vSelect := vSelect || ' WHERE                                                    ';
    vSelect := vSelect || '      0=0                                                 ';
    vSelect := vSelect || '  and Trim(c.arm_carregamento_codigo) = §'    || Trim(vCarreg) || '§  ';
    vSelect := vSelect || '  And c.glb_rota_codigo = §'            || vRota   || '§  ';
    vSelect := vSelect || '  And c.con_conhecimento_serie = §'     || vSerie  || '§  ';

    --Retira os caracteres coringas
    vSelect := Replace(vSelect, '§', '''');
    
    Begin
      --Abro o Cursor 
      Open cCursorCTRC For vSelect;
      
      Loop
        --Transfiro os dados do cursor para as variáveis.
        Fetch cCursorCTRC Into  vCtrc_Codigo,
                                vViagem_Codigo,
                                vViagem_Saque,
                                vViagem_Rota;
        
        --Sai do Cursor quando chegar no final do cursor.
        Exit When cCursorCTRC%Notfound;
        
        --Rodo a procedure que vai me trazer o número Final do CTRC
        sp_busca_proximoctrc( vRota, vCtrcCodigoFinal );
        
        --Efetua validação, apenas para ter certeza de que o código trago pela buscaProximo não é nulo.
        If ( ( Trim(vCtrcCodigoFinal) = '000000' ) Or ( nvl(Trim( vCtrcCodigoFinal), 0) = 0 ) ) Then
          --Caso o valor seja inválido, encerra o processamento.
          vRetorno.Status  := pkg_fifo.Status_Erro;
          vRetorno.Message := 'Erro ao gerar a procedure "SP_BUSCA_PRÓXIMO". '|| chr(13) || 'Código gerado inválido.';
          Return vRetorno;
        End If;   
        
        --rodo a procedure que vai literalmente gerar o CTRC, sp_move_dados_cnhc_viag
        tdvadm.sp_move_dados_cnhc_viag( vCtrc_Codigo,       --CODIGO CTRC Série XXX
                                        vCtrcCodigoFinal,   --CODIGO CTRC Final
                                        vCtrcSerieFinal,    --Série Final
                                        vViagem_Codigo,     --Código de Viagem do CTRC XXX
                                        vViagem_Saque,      --Saque da Viagem do CTRC XXX
                                        vViagem_Rota        --Rota da Viagem do CTRC XXX
                                       ); 

         vAuxiliar := 0;                              
         select count(*)
           into vAuxiliar
         from t_con_conhecimento c
         where c.con_conhecimento_codigo = vCtrc_Codigo
           and c.con_conhecimento_serie = 'XXX';

         if vAuxiliar > 0 Then
             wservice.pkg_glb_email.SP_ENVIAEMAIL('2 FALHA PROCESSO EM MASSA. '||'CTe XXX - ' || vCtrc_Codigo || ' - CTe A1 - ' || vCtrcCodigoFinal || ' - Rota - ' || vViagem_Rota,
                                                  'CTe XXX - ' || vCtrc_Codigo || 
                                                  ' - CTe A1 - ' || vCtrcCodigoFinal || 
                                                  ' - Rota - ' || vViagem_Rota || chr(10) ||
                                                  'Rotina - pkg_fifo_ctrc.FNP_CTRC_Eletronico linha 16001' || chr(10) ||
                                                  'Trilha - ' || call_stack,
                                                  'aut-e@dellavolpe.com.br',
                                                  'ksouza@dellavolpe.com.br;ddamaceno@dellavolpe.com.br');
         End If;                                     
         
/*        if nvl(vCarregVirtual, 'N') <> 'S' then
          Update t_con_conhecimento w
          Set w.con_conhecimento_digitado = 'I' 
           Where w.con_conhecimento_codigo = vCtrc_Codigo
            And w.con_conhecimento_serie = vCtrcSerieFinal
            And w.glb_rota_codigo = vViagem_Rota;
        end if;  */
          Commit;                    
                    
         
                                      
      End Loop;
      
      --fecha o Cursor.
      Close cCursorCTRC;
      
      
      
    Exception
    --Caso ocorra algum erro durante o processo busca dos DOCUMENTOS.
      When Others Then
        vRetorno.Status := pkg_fifo.Status_Erro;
        vRetorno.Message := 'Erro ao buscar Documentos para processamento.' ||chr(13) || Sqlerrm ||chr(13)|| dbms_utility.format_error_backtrace;
        Return vRetorno;
    End;
    
    --Chegando até aqui, seto a variável de retorno, para normal, e limpo a variavel de mensagem.
    vRetorno.Status := pkg_fifo.Status_Normal;
    vRetorno.Message := '';
    
    --Gero um XML em Branco, que vai representar os CTRC gerados em forms.
    --Isso para garantir que Não vai gerar erro no FRONT-END
    vRetorno.Xml := vRetorno.Xml || '<Parametros><Inputs><input><Tables><Table name="ListCtrcForms"><ROWSET>';
    vRetorno.Xml := vRetorno.Xml || '<row num="0">' ;
    vRetorno.Xml := vRetorno.Xml || '<ctrc_codigo />';
    vRetorno.Xml := vRetorno.Xml || '<ctrc_serie />';
    vRetorno.Xml := vRetorno.Xml || '<ctrc_rota />';
    vRetorno.Xml := vRetorno.Xml || '</row>';
    vRetorno.Xml := vRetorno.Xml || '</ROWSET></Table></Tables></input></Inputs></Parametros>';
  End If;
  
  
  
  


  --retorno a variável
  Return vRetorno;
  
End FNP_CTRC_Eletronico;  

---------------------------------------------------------------------------------------------------------------
--Função utilizada para imprimir os CTRCs não Eletronicos.                                                   --
---------------------------------------------------------------------------------------------------------------
Function FNP_CTRC_Formulario( pParamsEntrada Varchar2 ) Return pkg_fifo.tRetornoFunc Is
  -- para sabe quem me chamou
  call_stack  varchar2(4096) default dbms_utility.format_call_stack;
  vAuxiliar Integer;

  --Variável utilizada como retorno da função.
  vRetorno   pkg_fifo.tRetornoFunc;
  
  --Variáveis utilizadas para buscar dados enviados via paramentros.
  vRotaCte     Char(1):= '';
  vRotaCtrc    tdvadm.t_glb_rota.glb_rota_codigo%Type:= '';
  vFormNumero  Char(06) := '';
  vFromSerie   Char(03) := '';
  vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type := '';
  
  --Variáveis utilizadas para definir valores finais.
  vCtrc_SerieFinal    tdvadm.t_con_conhecimento.con_conhecimento_serie%Type := '';
  vCtrc_CodigoFinal   tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type := '';
  vTpFormulario       Varchar(20) := '';
  vViagem_Numero      tdvadm.t_con_conhecimento.con_viagem_numero%Type := '';
  vViagem_Saque       tdvadm.t_con_conhecimento.con_viagam_saque%Type := '';
  vViagem_Rota        tdvadm.t_con_conhecimento.glb_rota_codigoviagem%Type := '';
  
  --Variável de controle.
  vCount   Integer := 0;
  
  --Variável utilizada para gerar o arquivo XML de saida.
  vXmlSaida   Clob;

Begin
  --Limpo as Variáveis que serão utilizadas 
  
  Begin
    --Busco os dados básicos para iniciar do paramentro para iniciar as validações.
    Select 
      extractvalue(value(field), 'input/rota_cte'),
      extractvalue(value(field), 'input/rota_ctrc'),
      extractvalue(value(field), 'input/form_numero'),
      extractValue(Value(Field), 'input/form_serie'),
      extractValue(Value(Field), 'input/carregamento')
      
    Into 
      vRotaCte,
      vRotaCtrc,
      vFormNumero,
      vFromSerie,
      vCarregamento
    from 
      Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input'))) field;  
     
  Exception
    --caso ocorra qualquer tipo de erro, seto a variável de retorno para erro, defino mensagem, e encerro processamento.
    When Others Then
      vRetorno.Status := pkg_fifo.Status_Erro;
      vRetorno.Message := 'Não foi possivel recuperar valores passados por paramentros ' || chr(13) || dbms_utility.format_call_stack;
      Return vRetorno;
  End;    
  
  --Defino a Série final do CTRC
  If Trim( vRotaCtrc ) = '530' Then
    vCtrc_SerieFinal := 'A0';
  Else
    vCtrc_SerieFinal := 'A1';
  End If;
  
  --verifico se a Rota realmente de CTRC de Formulário
  If fn_retorna_tpambcte( vRotaCtrc ) = '2' Then
    
    --vou percorrer um laço para pegar os números dos CTRC passados 
    Begin
      For vCtrcForms In ( Select 
                           extractvalue(value(field), 'ctrc')  CodCtrc
                          From
                           Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input/ctrcs/ctrc'))) field
                         )
                         Loop
                           Begin
                             --Pego o código do CTRC passado e faço a busca de todos os dados que eu preciso.
                             Select 
                               ctrc.con_viagem_numero,
                               ctrc.con_viagam_saque,
                               ctrc.glb_rota_codigoviagem
                             Into 
                                vViagem_Numero,
                                vViagem_Saque,
                                vViagem_Rota
                                
                             From
                               T_con_conhecimento  ctrc
                             Where
                               ctrc.con_conhecimento_codigo = vCtrcForms.Codctrc
                               And ctrc.glb_rota_codigo = vRotaCtrc
                               And ctrc.con_conhecimento_serie = 'XXX';
                             
                           Exception
                             --caso ocorra algum erro na busca do ctrc.
                             When Others Then
                               vRetorno.Status := pkg_fifo.Status_Erro;
                               vRetorno.Message := 'Erro ao buscar ctrc '|| vCtrcForms.Codctrc || chr(13) || 'Processo interrompido';
                               Return vRetorno;
                           End;  
                           
                           --Define o número do formulário que dever ser utilizado. Número do Formulário definido mais a Variável de controle.
                           vFormNumero := lpad( to_number(vFormNumero)+ vCount , 6 , '0'  );
                           
                           --Válido o número do formulario que acabei de criar, o resultado da função precisa ser 1
                           If fn_busca_proximoformulario(vRotaCtrc, vFormNumero) <> 1 Then
                             --caso retorne erro, encerra o processamento e mostra a informação para o usuario.
                             vRetorno.Status := pkg_fifo.Status_Erro;
                             vRetorno.Message := 'Rota :'||vRotaCtrc||' Formulário '|| vFormNumero || ' não validado. '||chr(13)|| 'Processo interrompido.';
                             Return vRetorno;
                           
                           Else --Caso o retorno da função seja = 1, dou continuidade ao processo.
                             --Rodo a procedure que vai me trazer o código final para o CTRC.
                             vCtrc_CodigoFinal := '';
                             sp_busca_proximoctrc( vRotaCtrc, vCtrc_CodigoFinal );
                             
                             --uma validação simples do código retornado, apenas para ter certeza o o número não retornou zerado
                             If ( nvl(Trim(vCtrc_CodigoFinal), '0') = '0' ) Or (Trim(vCtrc_CodigoFinal) = '000000' ) Then
                               --Caso o valor seja inválido, encerra o processamento.
                               vRetorno.Status  := pkg_fifo.Status_Erro;
                               vRetorno.Message := 'Erro ao gerar a procedure "SP_BUSCA_PRÓXIMO". '|| chr(13) || 'Código gerado inválido.';
                               Return vRetorno;
                             End If;
                             
                             --Busco o tipo de Formuário apenas para mostrar para o usuario o tipo de Documento que será impresso.
                             vTpFormulario := tdvadm.F_BUSCA_CONHEC_TPFORMULARIO(vCtrcForms.Codctrc, 'XXX', vRotaCtrc );
                             
                             --rodo a procedure que vai transformar o CTRC de série XXX para série de Documento Impresso
                             Begin
                               sp_move_dados_cnhc_viag( vCtrcForms.Codctrc,   --Ctrc da Série XXX
                                                        vCtrc_CodigoFinal,    --Ctrc Código Final
                                                        vCtrc_SerieFinal,     --Ctrc Série Final
                                                        vViagem_Numero,       --Código de Viagem 
                                                        vViagem_Saque,        --Saque da Viagem 
                                                        vViagem_Rota,         --Rota da Viagem
                                                        vFormNumero           --Número do Formulário
                                                      );
                               vAuxiliar := 0;                              
                               select count(*)
                                 into vAuxiliar
                               from t_con_conhecimento c
                               where c.con_conhecimento_codigo = vCtrcForms.Codctrc
                                 and c.con_conhecimento_serie = 'XXX';

                               if vAuxiliar > 0 Then
                                   wservice.pkg_glb_email.SP_ENVIAEMAIL('3 FALHA PROCESSO EM MASSA. '||vCtrcForms.Codctrc ||'CTe XXX - ' || vCtrcForms.Codctrc ||' - CTe A1 - ' || vCtrc_CodigoFinal ||' - Rota - ' || vViagem_Rota,
                                                                        ' CTe XXX - ' || vCtrcForms.Codctrc || 
                                                                        ' - CTe A1 - ' || vCtrc_CodigoFinal || 
                                                                        ' - Rota - ' || vViagem_Rota || chr(10) ||
                                                                        'Rotina - pkg_fifo_ctrc.FNP_CTRC_Formulario linha 1810' || chr(10) ||
                                                                        'Trilha - ' || call_stack,
                                                                        'aut-e@dellavolpe.com.br',
                                                                        'ksouza@dellavolpe.com.br;ddamaceno@dellavolpe.com.br');
                               End If;                                     

                                                      
                               
                             Exception
                               When Others Then
                                 vRetorno.Status := pkg_fifo.Status_Erro;
                                 vRetorno.Message := 'Erro ao rodar a sp_move_dados_cnhc_viag.'|| chr(13) ||
                                                     'Documento: '|| vCtrc_CodigoFinal || chr(13) ||
                                                     'Formulario: '|| vFormNumero || chr(13) || Sqlerrm;
                                 Return vRetorno;                    
                             End;
                             --Chegando até aqui...passei por todos o processo sem erro. Inclusive com formulário validado.
                             --Guardo a linha com os dados finais para gerar Xml para impressão do CTRC.
                             --Monto uma linha de um arquivo XML para ser utilizado como retorno, XML de CTRCs impressos em FORMULÁRIOS.
                             vXmlSaida := vXmlSaida || '<row num=§'    || to_char(vCount+1)     ||'§ >' ;
                             vXmlSaida := vXmlSaida || '<ctrc_codigo>' || vCtrc_CodigoFinal     || '</ctrc_codigo>';
                             vXmlSaida := vXmlSaida || '<ctrc_serie>'  || vCtrc_SerieFinal      || '</ctrc_serie>';
                             vXmlSaida := vXmlSaida || '<ctrc_rota>'   || vRotaCtrc             || '</ctrc_rota>';
                             vXmlSaida := vXmlSaida || '</row>';
                           End If;
                           --Incremento a variável de controle.
                           vCount := 1;
                       End Loop;
      --Monto o xml
      vRetorno.Xml := vRetorno.Xml || '<Parametros><Inputs><input><Tables><Table name=#ListCtrcForms#><ROWSET>';
      vRetorno.Xml := vRetorno.Xml || vXmlSaida;
      vRetorno.Xml := vRetorno.Xml || '</ROWSET></Table></Tables></input></Inputs></Parametros>';
  
      --Retiro os Caracteres utilizados como coringa.
      vRetorno.Xml := Replace( vRetorno.Xml, '§', '''');
      vRetorno.Xml := Replace( vRetorno.Xml, '#', '"');
      
      --Vou Mostrar para o Usuario o formulário que deverá ser utilizado.
      vRetorno.Message := 'Utilize o formulario de: ' || Case vTpFormulario
                                                          When 'NF'   Then 'Nota Fiscal de Servico'
                                                          When 'CTRC' Then '"C.T.R.C."'
                                                         End;
      
     vRetorno.Status := pkg_fifo.Status_Normal;                       
                       
    Exception
      --caso ocorra qualquer erro não tratado durante o processo, encerro o processamento e mostro mensagem gerada,
      When Others Then
        vRetorno.Status := pkg_fifo.Status_Erro;
        vRetorno.Message := 'Não foi possível gerar ctrc. '|| chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack;
        Return vRetorno;
    End;                       
  End If;
/* 
  vRetorno.Status := pkg_fifo.Status_Erro;
  vRetorno.Message:= vRetorno.Message ||
  'POCESSO EM DESENVOLVIMENTO. ' || chr(13) ||
                     'Rota CTE: ' || vRotaCte       || chr(13) ||
                     'Rota CTRC: ' || vRotaCtrc || chr(13) ||
                     'Formulario Número: '|| vFormNumero || chr(13) ||
                     'Formulario Série: ' || vFromSerie;
                     
  */
  Return vRetorno;
End FNP_CTRC_Formulario;  

---------------------------------------------------------------------------------------------------------------
--função Privada utilizada para baixar carregamentos que tenha sido vinculados através do processo mobile 
---------------------------------------------------------------------------------------------------------------
Function FNP_BaixaCarregVincMobile( pCarreg_Codigo   tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                    pUsuario_codigo  tdvadm.t_usu_usuario.usu_usuario_codigo%Type
                                  ) Return Char Is
 --Variável de controle                                   
 vControl Integer;
 
 --Variáveis utilizadas para atualizar o veiculo disp.
 vVeiculo_Codigo  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
 vVeiculo_Seq     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type;
Begin
  --inicializo as variaveis que serão utilizadas nessa função
  vControl := 0;
  
  Begin
    --verifico se o carregamento teve interação do Sistema Mobile
    Select 
      Count(*) Into vControl
    From 
      t_arm_carregamentoveic veic
    Where
      veic.arm_carregamento_codigo = pCarreg_Codigo;  

  Exception
    --caso ocorra algum erro durante a busca do carregamento.
    When Others Then
      raise_application_error(-20001, 'Erro ao buscar carregamento');
  End;
  
  --caso não tenha encontrado nenhum registro simplesmente saio da função
  If vControl = 0 Then
    Return pkg_glb_common.Status_Nomal;
  End If;
  
  --Caso tenha encontrado alguma interação do sistema mobile
  If vControl > 0  Then
    Begin
      --Flego para "S" dando finalização ao processo, adiciona data e usuario que fechou.
      Update t_arm_carregamentoveic veic
        Set 
          veic.usu_usuario_baixou = pUsuario_codigo,
          veic.arm_carregamentoveic_dtbaixa = Sysdate,
          veic.arm_carregamentoveic_finaliz = 'S'
      Where
        veic.arm_carregamento_codigo = pCarreg_Codigo;   
        
      Begin
        --vou buscar o veiculo disp, para alterar seu status.
        Select 
          veic.fcf_veiculodisp_codigo,
          veic.fcf_veiculodisp_sequencia
        Into
          vVeiculo_Codigo,
          vVeiculo_Seq  
        From 
          t_arm_carregamentoveic  veic
        Where
          veic.arm_carregamento_codigo = pCarreg_Codigo; 
          
        --Após encontrar os dados do veiculo disp, mudo o flag para "F", para dar como finalizado o processo.  
        Update t_fcf_veiculodisp veic
          Set
            veic.arm_estagiocarregmob_codigo = 'F'
        Where 
          veic.fcf_veiculodisp_codigo = vVeiculo_Codigo
          And veic.fcf_veiculodisp_sequencia = vVeiculo_Seq;  

      Exception     
        --Caso ocorral algum erro na busca dos dados do veiculo para baixa.
        When no_data_found Then
          raise_application_error(-20001, 'Veiculo Disp Não Encontrado');
        
        When Others Then
           raise_application_error(-20001, 'Erro ao buscar veiculo');      
      End;  
      
      --finalizo a função.  
      Return pkg_glb_common.Status_Nomal;
        
    Exception
      --caso ocorra algum erro durante a atualização do carregamento
      When Others Then
        raise_application_error(-20001, 'Erro ao tentar baixar Carregamento Mobile');
    End;      
    
  End If;
    
End FNP_BaixaCarregVincMobile;    

---------------------------------------------------------------------------------------------------------------
-- Função utilizada para recuperar os destinos de um veiculo, a partir do Veiculo disp                       --
---------------------------------------------------------------------------------------------------------------
Function FNP_Get_DestVeiculos( pfcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                               pfcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type
                              ) Return Varchar2 Is
 --Variável que será utilizada como retorno da função
 vRetorno Varchar2(1000);
                               
Begin
  vRetorno := '';
  
  For vCursor In ( Select 
                     dest.glb_localidade_codigoibge
                   From
                     tdvadm.t_fcf_solveic veic,
                     tdvadm.t_fcf_solveicdest dest
                   Where 
                     veic.fcf_solveic_cod = dest.fcf_solveic_cod
                     And veic.fcf_veiculodisp_codigo = pfcf_veiculodisp_codigo
                     And veic.fcf_veiculodisp_sequencia = pfcf_veiculodisp_sequencia
                  )
                  Loop
                    vRetorno := vRetorno || '''' || ',' || '''' || vCursor.Glb_Localidade_Codigoibge;
                    
                  End Loop;   

  --devolve a variável preenchida                  
  Return vRetorno;
  
End FNP_Get_DestVeiculos;                               
                                    


---------------------------------------------------------------------------------------------------------------
-- PROCEDURE UTILIZADA PARA POPULAR O GRID PRINCIPAL DA ABA DO CTRC.                                         --
---------------------------------------------------------------------------------------------------------------
Procedure sp_AtualizaGridCtrc(  pParamsEntrada In Varchar2,
                                pStatus        Out Char,
                                pMessage       Out Varchar2,
                                pParamsSaida   Out Clob 
                               ) As
 --Variável que será utilizada como retorno da procedure.
 vXmlRetorno Clob;
 vXmlCarregSemVF Clob;
 vXmlListaVeics   Clob;
 vXmlListaVeicCarreg Clob;
 
 --Função utilizada para recuperar valores após execução de um função.
 vRetorno pkg_fifo.tRetornoFunc;
 
 --Variável utilizada para recuperar os valores enviado através do paramentro de entrada.
 vUsuario    tdvadm.t_usu_usuario.usu_usuario_codigo%Type:= '';
 vAplicacao  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type:= '';
 vRota       tdvadm.t_glb_rota.glb_rota_codigo%Type := '';
 vArmazem    tdvadm.t_Arm_armazem.arm_armazem_codigo%Type := '';
 
 --Variáveis utilizadas executar procedure que fará a vinculação do Carregamento a um veiculo.
 vCarregamento     tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type := '';
 vVeic_codigo      tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type := '';
 vVeic_Seq         tdvadm.t_fcf_veiculoDisp.fcf_veiculodisp_sequencia%Type := '';
 
 --Variavel que vai indicar a ação a ser executada.  "V = Vinculação", "D = Desvinculação", "A = Atualização"
 vAcao Char(1):= '';
 
Begin
--  pStatus := 'W';
--   pMessage := pParamsEntrada;
--   Return;



 Begin
    --Select que será utilizado para para poder extrair as variáveis do paramentro de entrada,
    
    --Raise_application_Error('Desativado pela T.I.', -20001);
    
    Select 
       Trim( extractvalue(value(field), 'input/usuario')),
       Trim( extractvalue(value(field), 'input/aplicacao')),
       trim( extractvalue(value(field), 'input/rota')),
       Trim( extractValue(Value(Field), 'input/Aramzem')),
       Trim( extractValue(Value(Field), 'input/Carregamento' )),
       Trim( extractValue(Value(Field), 'input/veic_codigo')),
       Trim( extractValue(Value(Field), 'input/veic_sequencia')),
       Trim( extractValue(Value(field), 'input/acao'))
     Into 
       vUsuario,
       vAplicacao,
       vRota, 
       vArmazem,
       vCarregamento,
       vVeic_codigo,
       vVeic_Seq,
       vAcao
     from 
       Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input'))) field; 
 
 Exception
   When no_data_found Then
     --Caso não tenha conseguido recuperar os valores, mudo o formato do XML.
    Select 
     Trim( extractvalue(value(field), 'Input/usuario')),
     Trim( extractvalue(value(field), 'Input/aplicacao')),
     trim( extractvalue(value(field), 'Input/rota')),
     Trim( extractValue(Value(Field), 'Input/Aramzem')),
     Trim( extractValue(Value(Field), 'Input/Carregamento' )),
     Trim( extractValue(Value(Field), 'Input/veic_codigo')),
     Trim( extractValue(Value(Field), 'Input/veic_sequencia')),
     Trim( extractValue(Value(field), 'Input/acao'))
   Into 
     vUsuario,
     vAplicacao,
     vRota, 
     vArmazem,
     vCarregamento,
     vVeic_codigo,
     vVeic_Seq,
     vAcao
   from 
     Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Input'))) field;  

   --Caso ocorra algum erro, dou a informação na tela, junto com o erro Ora + a arvore tracada pelo Call_stack
   When Others Then
     pStatus := 'E';
     pMessage := 'Erro ao tentar extrar Variáveis do Paramentro de Entrada.' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack ;
     Return;
 End;

   if vUsuario = 'jsantos2' then
     pStatus := 'E';
     pMessage := pParamsEntrada;
    return;
  end if;

 
 
 /*If vAplicacao = 'carregmob' Then
   Insert Into dropme (a, l) Values ('teste diegao', pParamsEntrada);
   Commit;
 End If;*/

 
  --Caso a Variável "Ação", esteja solicitando uma vinculação ou Desvinculação, rodo a funcção de Vinculação.
  If ( vAcao In ('V', 'D') ) Then     
    --if (Tdvadm.Pkg_Fifo_Manifesto.Fn_Is_MDFe(vRota) = 'S') and (Tdvadm.Pkg_Fifo_Manifesto.Fn_Manifesto_Gerado(vVeic_codigo, vVeic_Seq) = 'S') then

    if (Tdvadm.Pkg_Fifo_Manifesto.Fn_Manifesto_Gerado(vVeic_codigo, vVeic_Seq) = 'S') then
        pStatus := 'E';
        pMessage := 'Veículo contem Manifesto Gerado!! VeicDisp: ' || vVeic_codigo || ' vVeic_Seq: ' || vVeic_Seq ;
        Return;      
    end if;  
    vRetorno := FNP_VinculaCarregVeic( vCarregamento,  --Código do Carregamento
                                       vVeic_codigo,   --Código de Veiculo
                                       vVeic_Seq,      --Sequencia do Veiculo.
                                       vUsuario,       --Usuario responsável pela atualização.
                                       vAcao, 
                                       vAplicacao
                                     );                                     
    --Caso a variável tenha retornado com erro, mostro o erro na tela, e encerro o processamento.
    If vRetorno.Status  = pkg_fifo.Status_Erro Then
      pStatus := vRetorno.Status;
      pMessage := vRetorno.Message;
      Return;
    End If;       
     --executo a função que vai atualizar a quantia de Ctrc de cada Carregamento de Um armazem.
  --  vRetorno := fnp_atualizarCtrcImp( vCarregamento );
    
    --Caso gere algum erro, encerro o processamento e mostro na tela a mensagem de erro.
    If vRetorno.Status = pkg_fifo.Status_Erro Then
      pStatus := pkg_fifo.Status_Erro;
      pMessage := vRetorno.Message;
      Return;
    End If;
    
    if vAplicacao = 'carregmob' then
      pStatus := vRetorno.Status;
      pMessage := vRetorno.Message;
      return;      
    end if;
        
  End If;
  
  --Caso a Ação seja do tipo "A", quer dizer que foi apenas uma atualização das informações do GRID
  If (vAcao = 'A') Then
    --Rodo a função responsável por atualizar as informações de QTde de CTRC dos carregamentos desse armazem.
    If  ( Not FNP_AtualizaQtdeCtrc( Trim(vArmazem), vRetorno.Message ) ) Then
      vRetorno.Status := 'E';
      Return;  
    End If;
    
  End If;

 
   --Executo a Procedure que vai garar o Xml com os Carregamento sem Vale de Frete.
   vRetorno := FNP_Xml_CarregSemVF(Trim(vArmazem));
      
   --Caso a Variável tenha retornardo erro, Encerro processamento e mostro mensagem de erro.
   If vRetorno.Status = pkg_fifo.Status_Erro Then
     pStatus := vRetorno.Status;
     pMessage := vRetorno.Message;
     Return;
   End If;
   
   --Caso a Variável retorno com processamento normal. Transfiro os dados para a Variável própria.
   If vRetorno.Status = pkg_fifo.Status_Normal Then
     vXmlCarregSemVF := vRetorno.Xml;
   End If;
   
   --Exceuto a função que vai gerar o Xml com os Veiculos contratados para o Armazem solicitado.
   vRetorno:= FNP_Xml_ListaVeicContratados( Trim(vArmazem) );
   
   --Caso a Variável tenha retornado erro, encerro o processamento e mostro mensagem de erro.
   If vRetorno.Status = Pkg_Fifo.Status_Erro Then
     pStatus := vRetorno.Status;
     pMessage := vRetorno.Message;
     Return;
   End If;
   
   --Caso a variável tenha retornar normal, transfiro os dados para a variável própria.
   If vRetorno.Status = pkg_fifo.Status_Normal Then
     vXmlListaVeics := Trim(vRetorno.Xml);
   End If;
   
   --Executo a função que vai gerar xml com os Veiculos contratados para o Armazem e já carregados.
   vRetorno := FNP_Xml_VeicCarreg( Trim(vArmazem) );
   
   --Caso a Veriáve tenha retornado algum erro, encerro o processamento, e mostro a mensagem
   If vRetorno.Status = pkg_fifo.Status_Erro Then
     pStatus := vRetorno.Status;
     pMessage := vRetorno.Message;
     Return;
   End If;
   
   --caso a variável tenha retornado com processamento normal, transfiro o xml para uma variável apropriada.
   If vRetorno.Status = pkg_fifo.Status_Normal Then
     vXmlListaVeicCarreg := vRetorno.Xml;
   End If;
   
   --Monta o arquivo propriamente dito.
   vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
   
   vXmlRetorno := vXmlRetorno || '<Table name=#CarregSemVF#><ROWSET>'     || vXmlCarregSemVF     || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#VeicCont#><ROWSET>'        || vXmlListaVeics      || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#VeicContCarreg#><ROWSET>'  || vXmlListaVeicCarreg || '</ROWSET></Table>';
   
   vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
   --Substitui os carecteres "CORINGAS"
   vXmlRetorno := Replace(vXmlRetorno, '#', '"');
   vXmlRetorno := Replace(vXmlRetorno, '§', '''');
 
 
 --Finaliza a Procedure.
 pStatus := 'N';
 pMessage := '';
 pParamsSaida := vXmlRetorno;
 
End sp_AtualizaGridCtrc; 


---------------------------------------------------------------------------------------------------------------
-- PROCEDURE UTILIZADA PARA ATUALIZAR O GRID DO FORMULÁRIO DE CTRCDET.                                       --
---------------------------------------------------------------------------------------------------------------
Procedure sp_AtalizaGridCtrcDet( pParamsEntrada  In  Varchar2, 
                                 pStatus         Out Char,
                                 pMessage        Out Varchar2,
                                 pParamsSaida    Out Clob  ) As

--Variável utilizada para recuperar os valores enviado através do paramentro de entrada. 
   vUsuario      tdvadm.t_usu_usuario.usu_usuario_codigo%Type:= '';
   vAplicacao    tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type := '';
   vRota         tdvadm.t_glb_rota.glb_rota_codigo%Type := '';
   vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type := '';
   vTpRota       Char(01):= '';
   vAuxiliar     number;
   
 vXmlCtrcForms Clob;
 vXmlCtrcAtual Clob;
 vXmlRetorno   Clob;
 
 --Variável utilizada para retorno de Funções.
 vRetornoFunc   pkg_fifo.tRetornoFunc;
 
 vCtrc_Codigo tdvadm.t_con_conhecimento.con_conhecimento_codigo%Type := '';
 vCtrc_Serie  tdvadm.t_con_conhecimento.con_conhecimento_serie%Type := '';
 vCtrc_Rota   tdvadm.t_glb_rota.glb_rota_codigo%Type := '';
 
 vLinha    Varchar2(5000) := '';

Begin
  

  

  Begin
    --Select que será utilizado para para poder extrair as variáveis do paramentro de entrada,
    Select 
       Trim(extractvalue(value(field), 'input/usuario')),
       Trim(extractvalue(value(field), 'input/aplicacao')),
       Trim(extractvalue(value(field), 'input/rota')),
       Trim(extractValue(Value(Field), 'input/carregamento' )),
       Trim(extractValue(Value(Field), 'input/rota_cte' ))         
     Into 
       vUsuario,
       vAplicacao,
       vRota, 
       vCarregamento,
       vTpRota
     from 
       Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input'))) field;  

     insert into TDVADM.T_GLB_SQL (GLB_SQL_INSTRUCAO,GLB_SQL_DTGRAVACAO,GLB_SQL_PROGRAMA) values (pParamsEntrada,SYSDATE,'sp_AtalizaGridCtrcDet - ' ||  vCarregamento);

  Exception
    --Caso ocorra algum erro, dou a informação na tela, junto com o erro Ora + a arvore tracada pelo Call_stack
    When Others Then
      pStatus := 'E';
      pMessage := 'Erro ao tentar extrar Variáveis do Paramentro de Entrada.' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack ;
      Return;
  End;
  
  IF ( vUsuario = 'jsantosX') THEN
    pMessage := pParamsEntrada;
    pStatus := 'E';
    RETURN;
  END IF;
  
/*  If Trim(vCarregamento) = '124674' Then
    pMessage := pParamsEntrada;
    pStatus := 'W';
    
    insert into dropme (a, l) values ( 'Carregamento 124674', pParamsEntrada);
    commit;
    Return;
  End If;*/

  Begin

    --Se a Variável tpRota, Estiver nula, quer dizer que não estou enviando para impressão, 
    --apenas atualizando o GRID da CTRC, por isso, verifico se tem mais de um conhecimento para a mesma nota
    If nvl( Trim(vTpRota), 'R') = 'R' Then
          -- verificar aqui se existe regra para este ctrc,
          -- hoje 25/10 ocorreu um problema onde tinha um Carregamento
          -- com mais de uma nota emitindo Nota Fiscal de Servico
          -- Sirlano / Flavia 
      For vQtdeCtrc In ( SELECT COUNT(*) qtdeCtrc,
                         NF.CON_NFTRANSPORTADA_NUMNFISCAL,                             
                         NF.GLB_CLIENTE_CGCCPFCODIGO,                                  
                         co.glb_cliente_cgccpfsacado,
                         sum((select count(*)
                          from t_arm_notacte nct
                          where nct.con_conhecimento_codigo = co.con_conhecimento_codigo
                            and nct.con_conhecimento_serie = co.con_conhecimento_serie
                            and nct.glb_rota_codigo = co.glb_rota_codigo
                            and nct.arm_notacte_codigo in ('CO','RP'))) ctecol,
                         sum((select count(*)
                          from tdvadm.t_arm_nota nct
                          where nct.con_conhecimento_codigo = co.con_conhecimento_codigo
                            and nct.con_conhecimento_serie = co.con_conhecimento_serie
                            and nct.glb_rota_codigo = co.glb_rota_codigo
                            and nct.glb_tpcarga_codigo in ('CO','RP'))) notacol
                       FROM 
                         T_CON_CONHECIMENTO CO, 
                         T_CON_NFTRANSPORTA NF
                         
                       WHERE 
                         0=0
                         And CO.CON_CONHECIMENTO_CODIGO = NF.CON_CONHECIMENTO_CODIGO      
                         AND CO.CON_CONHECIMENTO_SERIE = NF.CON_CONHECIMENTO_SERIE        
                         AND CO.GLB_ROTA_CODIGO = NF.GLB_ROTA_CODIGO    
                         AND co.con_conhecimento_flagcancelado is null                  
                         AND CO.ARM_CARREGAMENTO_CODIGO = vCarregamento
                       GROUP BY 
                         NF.CON_NFTRANSPORTADA_NUMNFISCAL, 
                         NF.GLB_CLIENTE_CGCCPFCODIGO, 
                         co.glb_cliente_cgccpfsacado  
                        )
                        Loop
                          --Caso o campo QtdeCtrd seja maior que 1, quer dizer que foi gerado mais de um conhecimento para a mesma nota.
                          --Critério, Nota com o mesmo númer, mesmo Remetente e mesmo sacado, dentro desse carregamento.
                     --     if (vCarregamento <> '4168319') then
                          If ( (vQtdeCtrc.Qtdectrc - vQtdeCtrc.ctecol) > 1) and ( vQtdeCtrc.notacol = 0 )  Then
                            pStatus := pkg_fifo.Status_Erro; 
                            pMessage := 'Ocorreu algum erro ao gerar os conhecimentos!'   || chr(13) ||
                                        'Conhecimento(s) pode(em) ter sido duplicado(s)!' || chr(13) ||
                                        'Volte com o carregamento e tente fechar novamente! ssd' ;
                            Return;            
                          End If;
                       --   End If;
                        End Loop;                     
    End If;
  Exception
   --Caso ocorra algum erro, mostro a mensage na tela.
   When Others Then
     pStatus := pkg_fifo.Status_Erro;
     pMessage := 'Erro ao tentar verificar duplicidade de conhecimento.' || chr(13) || Sqlerrm  || chr(13) || dbms_utility.format_call_stack;
     Return;
  End;
  
  --Caso o Tipo da rota não seja Nulo, quer dizer que tenho conhecimentos para serem impressos.
  If nvl( Trim(vTpRota), 'R') <> 'R' Then    
    
  --verifico se é rota 197, antes das 8 da manha do dia 27
  If ( ( vRota = '999' ) And 
       ( Trunc(Sysdate) = '27/11/2012')  And
       ( to_char(Sysdate, 'hh24') < 8 ) 
     )  Then
    pStatus  := 'N';
    pMessage := 'Filial travada para impressão de CTRC' || chr(10) ||
                'Servico disponível a partir das 8:00hs. ';
    Return;             
  End If;
    
    
    --SE O TIPO DE ROTA FOR "S", QUER DIZER QUE É ROTA ELETRNONICA.
    If Trim(vTpRota) = 'S' Then
      --Rodo a Função responsável por gerar os CTEs.
      vRetornoFunc := FNP_CTRC_Eletronico(pParamsEntrada);
      
      --Caso o retorno da função não tenha sido Normal
      If vRetornoFunc.Status <> pkg_fifo.Status_Normal Then
        --Seto as variáveis de retorno e mensagem, com as informações geradas dentro da função, e encerro o processamento.
        pStatus := vRetornoFunc.Status;
        pMessage := vRetornoFunc.Message;
        Return;
      End If;
    End If;
    
    --Se o tipo da Rota for "N" quer dizer que não é rota eletronica.
    If Trim(vTpRota) = 'N' Then
      
      --Rodo a função responsável por gerar os CTRC de formulários.
      vRetornoFunc := FNP_CTRC_Formulario( pParamsEntrada );
      
      --Caso o retorno da função não tenha sido normal
      If vRetornoFunc.Status <> pkg_fifo.Status_Normal Then
        --Seto as variáveis de retorno e mensagem, com as informações geradas dentro da função, e encerro o processamento.
        pStatus := vRetornoFunc.Status;
        pMessage := vRetornoFunc.Message;
        Return;
      Else
        pMessage := vRetornoFunc.Message;
      End If;
    End If;
    
  End If;
  
    
  --Executo a função que gera arquivo xml dos ctrc de formulário, passando o xml gerado pela função de impressão.
  vRetornoFunc := FNP_Xml_ListaCtrcImp( vRetornoFunc.Xml);
     
  --Caso gere algum erro, encerro o processamento e mostro na tela.
  If vRetornoFunc.Status = pkg_fifo.Status_Erro Then
    pStatus := pkg_fifo.Status_Erro;
    pMessage := vRetornoFunc.Message;
    Return;
  End If;
     
  -- Verifica se ja existe Conferencia antes de mandar imprimir.
  select count(*)
    into vAuxiliar
  from T_Arm_Carregamento c
  Where c.arm_carregamento_codigo = vCarregamento
    and c.usu_usuario_conferiucarreg is not null;
  -- Se não achou e porque não foi conferido
  if vAuxiliar = 0 and  vTpRota is not null Then
--    insert into t_glb_sql values (pParamsEntrada,sysdate,'ATALIZA','ATALIZA');
    vRetornoFunc.Message := 'Carregamento não conferido...[pkg_fifo_ctrc.sp_AtalizaGridCtrcDet]';
    pStatus := pkg_fifo.Status_Erro;
    pMessage := vRetornoFunc.Message;
  End If;      
    
    
  
  --ocorrendo tudo bem, guardo o novo XML em uma variável propria.
  If vRetornoFunc.Status = pkg_fifo.Status_Normal Then
    vXmlCtrcForms := vRetornoFunc.Xml;
  End If;
  
  --Executo a Função que vai gerar o Xml com os CTRCs de um Carregamento.
  vRetornoFunc := FNP_Xml_CtrcCarreg(vCarregamento);
    
  --Caso o retorno da Função retorno erro, encerro o processamento, e encerro o processamento.
  If vRetornoFunc.Status = pkg_fifo.Status_Erro Then
    pStatus := vRetornoFunc.Status;
    pMessage := vRetornoFunc.Message;
    Return;
  End If;
    
    --Caso o retorno da Função retorne normal, atribuo o Xml gerado a variavel Saída.
    If vRetornoFunc.Status = pkg_fifo.Status_Normal Then
      vXmlCtrcAtual := vRetornoFunc.Xml;
    End If;
     
         --Monta o arquivo propriamente dito.
   vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
   vXmlRetorno := vXmlRetorno || '<Table name=#CtrcDet#><ROWSET>'   || vXmlCtrcAtual || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#FormsImpr#><ROWSET>' || vXmlCtrcForms || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
   --Substitui os carecteres "CORINGAS"
   vXmlRetorno := Replace(vXmlRetorno, '#', '"');
   vXmlRetorno := Replace(vXmlRetorno, '§', '''');
   

 --Finaliza a Procedure.
 pStatus := pkg_fifo.Status_Normal;
 pParamsSaida := vXmlRetorno;  
  
End sp_AtalizaGridCtrcDet;  

--------------------------------------------------------------------------------------------------------------------
-- Pocedure utilizada para efetuar a Impressão dos Conhecimentos atraves do processi de carragamento automático   --
--------------------------------------------------------------------------------------------------------------------
Procedure SP_IMP_CTRCAUTOCARREG( pParamsEntrada  In Varchar2,
                                 pStatus         Out Char,
                                 pMessage        Out Varchar2,
                                 pParamsSaida    Out Clob
                                ) Is
  --Variável utilizada para recuperar os valores enviado através do paramentro de entrada. 
  vUsuario      tdvadm.t_usu_usuario.usu_usuario_codigo%Type:= '';
  vAplicacao    tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type := '';
  vRota         tdvadm.t_glb_rota.glb_rota_codigo%Type := '';
  vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type := '';
  vTpRota       Char(01):= '';

  vXmlCtrcForms Clob;
  vXmlCtrcAtual Clob;
  vXmlRetorno   Clob;
  
   --Variável que será utilizada como retorno.
 vRetorno   pkg_fifo.tRetornoFunc;
                                
Begin
 /* pStatus := 'W';
  pMessage := pParamsEntrada;
  Return;*/
  Begin
    --Select que será utilizado para para poder extrair as variáveis do paramentro de entrada,
    Select 
       extractvalue(value(field), 'input/usuario'),
       extractvalue(value(field), 'input/aplicacao'),
       extractvalue(value(field), 'input/rota'),
       extractValue(Value(Field), 'input/carregamento' ),
       extractValue(Value(Field), 'input/rota_cte' )         
     Into 
       vUsuario,
       vAplicacao,
       vRota, 
       vCarregamento,
       vTpRota
     from 
       Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/Parametros/Inputs/input'))) field;  

  Exception
    --Caso ocorra algum erro, dou a informação na tela, junto com o erro Ora + a arvore tracada pelo Call_stack
    When Others Then
      pStatus := 'E';
      pMessage := 'Erro ao tentar extrar Variáveis do Paramentro de Entrada.' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack ;
      Return;
  End;
  
  --Caso a rota seja uma rota de CTE
  If Trim(vTpRota) = 'S' Then
    --roda a função resposável por imprimir os CTRCs eletronicos.
    vRetorno := FNP_CTRC_Eletronico( pParamsEntrada);
    
    --Caso a função retorne algum erro devolve mensagem de erro.
    If vRetorno.Status <> pkg_glb_common.Status_Nomal Then
      pStatus := vRetorno.Status;
      pMessage := vRetorno.Message;
      Return;
    End If;  
  End If;
  
  --Caso a rota seha uma rota de Formulário.
  If Trim(vTpRota) = 'N' Then
    --Rodo a função responsável por imprimir os CTRCs formulários.
    vRetorno := FNP_CTRC_Formulario(pParamsEntrada);
    
    --caso a função retorne algum erro, devolve a mensafe de erro.
    If vRetorno.Status <> pkg_glb_common.Status_Nomal Then
      pStatus := vRetorno.Status;
      pMessage := vRetorno.Message;
      Return;
    End If;
  End If;
  
  
 --Executo a função que gera arquivo xml dos ctrc de formulário, passando o xml gerado pela função de impressão.
  vRetorno := FNP_Xml_ListaCtrcImp( vRetorno.Xml );
     
  --Caso gere algum erro, encerro o processamento e mostro na tela.
  If vRetorno.Status <> pkg_glb_common.Status_Nomal Then
    pStatus  := vRetorno.Status;
    pMessage := vRetorno.Message;
    Return;
  End If;
  
  
  --Monta o arquivo propriamente dito.
  vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
  vXmlRetorno := vXmlRetorno || '<Table name=#FormsImpr#><ROWSET>' || vRetorno.Xml || '</ROWSET></Table>';
  vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
  --Substitui os carecteres "CORINGAS"
  vXmlRetorno := Replace(vXmlRetorno, '#', '"');
  vXmlRetorno := Replace(vXmlRetorno, '§', '''');
  vXmlRetorno := pkg_fifo_auxiliar.fn_removeAcentos( vXmlRetorno );
  
  pStatus := pkg_glb_common.Status_Nomal;
  pMessage := '';
  pParamsSaida := Trim( vXmlRetorno );

End SP_IMP_CTRCAUTOCARREG;  

---------------------------------------------------------------------------------------------------------------
-- FUNÇÃO UTILIZADA PARA RETORNAR DADOS DE UM CARREGAMENTO A PARTIR DE UMA EMBALAGEM.                        --
---------------------------------------------------------------------------------------------------------------
Procedure sp_getVeicEmbalagens ( pEmbalagem   In tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                                 pStatus      Out Char,
                                 pMessage     Out Char,
                                 pCursor      Out pkg_fifo.T_CURSOR
                               ) Is
 --Variável utilizada para rodar a função que traz os veiculos de um armazem.
 vRetorno   pkg_fifo.tRetornoFunc;                               
 
 vCodArmazem   tdvadm.t_arm_armazem.arm_armazem_codigo%Type;
 vCodDestino    tdvadm.t_glb_localidade.glb_localidade_codigoibge%Type;
 
 --Variável do tipo de uma linha, utilizada para popular uma tabela temporária.
 vLinhaCursor    coleta.t_tmp_auxiliar%Rowtype;
Begin
  
  --limpara as variávei apenas para garantir que não vou trazer nenhum lixo
  vRetorno.Status   := '';
  vRetorno.Message  := '';
  vRetorno.Controle := 0;
  
  --Busco o codigo do Armazem, para pegar todos os veiculos cadastros naquele armazem.
  --Codigo de IBGE, para filtrar os veiculos com mesmo destino da embalagem.
  Select 
    emb.arm_armazem_codigo,
    loc.glb_localidade_codigoibge
  Into 
    vCodArmazem,
    vCodDestino
  From
    t_arm_embalagem   emb,
    T_ARM_NOTA        NOTA,
    T_GLB_CLIEND      DESTINO,
    t_glb_localidade   loc
  Where
    EMB.ARM_EMBALAGEM_NUMERO = NOTA.ARM_EMBALAGEM_NUMERO
    And EMB.ARM_EMBALAGEM_SEQUENCIA = NOTA.ARM_EMBALAGEM_SEQUENCIA
    And EMB.ARM_EMBALAGEM_FLAG = NOTA.ARM_EMBALAGEM_FLAG
    
    And Trim(NOTA.GLB_CLIENTE_CGCCPFDESTINATARIO) = tRIM(DESTINO.GLB_CLIENTE_CGCCPFCODIGO)
    And  NOTA.GLB_TPCLIEND_CODDESTINATARIO = DESTINO.GLB_TPCLIEND_CODIGO
    
    And DESTINO.GLB_LOCALIDADE_CODIGO = LOC.GLB_LOCALIDADE_CODIGO
    And emb.arm_embalagem_numero = pEmbalagem
    And emb.arm_embalagem_sequencia = ( Select Max(e.arm_embalagem_sequencia) From t_arm_embalagem e
                                        Where e.arm_embalagem_numero = emb.arm_embalagem_numero
                                       );

  
  --Percorro um cursor, para buscar todos os veiculos cadastrados no armazem em questão.
  For vCursorVeic  In ( SELECT 
                         Distinct
                          S.FCF_VEICULODISP_CODIGO                                   Veic_codigo,
                           S.fcf_veiculodisp_sequencia                               Veic_sequencia,
                           FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO,
                                                 S.FCF_VEICULODISP_SEQUENCIA)         Veic_PLACA,
                           pkg_fifo_auxiliar.fn_removeAcentos(FN_BUSCA_MOTORISTAVEICULO( S.FCF_VEICULODISP_CODIGO,                                
                                                                                         S.FCF_VEICULODISP_SEQUENCIA) )    Veic_Motorista, 
                           T.FCF_TPVEICULO_DESCRICAO                                  Veic_Descricao,
                           sold.glb_localidade_codigoibge                             CodIbge  
                        FROM 
                          T_FCF_VEICULODISP S,
                          T_FCF_TPVEICULO   T,
                          T_FCF_SOLVEIC     SOL,
                          T_FCF_SOLVEICDEST SOLD
                        Where
                          0=0 
                         And S.FCF_VEICULODISP_CODIGO    = SOL.FCF_VEICULODISP_CODIGO
                         AND S.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA
                         AND S.FCF_TPVEICULO_CODIGO = T.FCF_TPVEICULO_CODIGO
                         AND S.FCF_OCORRENCIA_CODIGO IS NULL                                                    
                         AND S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL                                              
                         AND S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL    
                         AND SOL.FCF_SOLVEIC_COD = SOLD.FCF_SOLVEIC_COD(+) 
                         And s.arm_armazem_codigo = Trim(vCodArmazem)
                         And trunc(s.fcf_veiculodisp_data) >= trunc(Sysdate)-3
                         -- **** Acrescentado por Diego, para Buscar somente os nao Finalizados! ****
                         And nvl(s.arm_estagiocarregmob_codigo, '$') <> 'F'
                         -- ***************************************************************************
                     ) Loop
                         --Caso o codigo do IBGE do veiculos (Destino) bata com o Codigo de IBGE  da embalage,
                         If vCursorVeic.CodIbge = vCodDestino Then
                           --Incremento a variável de controle.
                            vRetorno.Controle := vRetorno.Controle +1;

                            --Populo a variável de linha que será utilizada para o insert.
                            vLinhaCursor.Aux_Str01  := vCursorVeic.Veic_codigo;
                            vLinhaCursor.Aux_Str02  := vCursorVeic.Veic_sequencia;
                            vLinhaCursor.Aux_Str03  := vCursorVeic.Veic_PLACA;
                            vLinhaCursor.Aux_Str04  := vCursorVeic.Veic_Motorista;
                            vLinhaCursor.Aux_Str05  := vCursorVeic.Veic_Descricao;
                            vLinhaCursor.Aux_Str06  := vCursorVeic.CodIbge;

                            --Populo a tabela temporária para gerar o cursor de saida.
                            Insert Into coleta.t_tmp_auxiliar Values vLinhaCursor;
                            
                         End If;
                         
                       End Loop;
               
  --Caso a variável de controle seja maior que zero, quer dizer que encontrei veiculo com o mesmo 
  --destino da embalagem
   If vRetorno.Controle > 0 Then
     --Comito a tabela e seto a variável de saida para Normal e limpo a variável de mensagem
     Commit;
     pStatus := pkg_fifo.Status_Normal;
     pMessage := '';
                 
     --Abro o cursor com o conteudo da tabela temporária.
     Open pCursor  For 
       Select 
         aux.aux_str01  veic_Codigo,
         aux.aux_str02  Veic_sequencia,
         aux.aux_str03  Veic_placa,
         aux.aux_str04  veic_motorista,
         aux.aux_str05  veic_descricao,
         aux.aux_str06  veic_codIBGE
       From 
         coleta.t_tmp_auxiliar aux;
   Else
     --Caso a variável de controle seja igual a zero, seto a variável de retorno para erro, e defino  mensagem de retorno.
     pStatus := pkg_fifo.Status_Erro;
     pMessage := 'Não foi localizado nenhum veiculo para essa embalagem.';
     Open pCursor  For 
       Select 
         'X'  veic_Codigo,
         '0'  Veic_sequencia,
         'X'  Veic_placa,
         'X'  veic_motorista,
         'X'  veic_descricao,
         'X'  veic_codIBGE
       From 
         coleta.t_tmp_auxiliar aux;     
   End If;
End;              

---------------------------------------------------------------------------------------------------------------
-- utilizada para realizar vunculação de uma lista de carregamentos a um veiculos
---------------------------------------------------------------------------------------------------------------
procedure sp_set_VincListaCarreg( pParamsEntrada In Varchar2,
                                  pStatus        Out Char,
                                  pMessage       Out Varchar2,
                                  pParamsSaida   Out Clob 
                               ) As                
 --Variáveis utilizadas para recuperar dados enviadas por paramentros
 vAplicacao   tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type;
 vUsuario     tdvadm.t_usu_usuario.usu_usuario_codigo%type;
 vRota        tdvadm.t_glb_rota.glb_rota_codigo%type;
 vArmazem     tdvadm.t_arm_armazem.arm_armazem_codigo%type;
 vManifesto   char(01);
 vAcao        Char(01);
 
 vVeic_codigo  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
 vVeic_seq     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
 
 --Variável do tipo cursor que será utilizada para recuperar os carregamentos
 vCursorCarreg  pkg_glb_common.T_CURSOR;
 
 --Variável utilizada para retorno da função.
 vRetornoFunc pkg_fifo.tRetornoFunc;
 
 --Variáveis que serão utilizadas para receber arquivos xml
 vXmlCarregSemVF     cLob;
 vXmlListaVeics      cLob;
 vXmlListaVeicCarreg cLob;
 vXmlRetorno         cLob;
 
 --Variável utilizada para recuperar mensagens.
 vMessage Varchar2(32000); 
  
 vAuxiliar varchar2(100);
 
Begin
  
  --insert Into dropme d (a,x) values('VINC_CARREG_VEIC', pParamsEntrada);COMMIT;

  --inicializa as variáveis que serão utilizadas nessa procedure.
  vAplicacao := '';
  vUsuario := '';
  vRota := '';
  vVeic_codigo := '';
  vVeic_seq := '';
  vAcao := '';
  
  --Populo as variáveis com os valores que foram passados por paramentros.
  vAplicacao   := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'aplicacao');
  vUsuario     := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'usuario');
  vRota        := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'rota');
  vArmazem     := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'armazem');
  vVeic_codigo := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'veiculo_codigo');
  vVeic_seq    := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'veiculo_seq');
  vManifesto   := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'manifesto');
  vAcao        := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'acao');
  
  if Trim(Lower(vUsuario)) = 'jsantos2' then
    pMessage := pParamsEntrada;
    pStatus := 'W';
    return;
  end if;
  
  if (Tdvadm.Pkg_Fifo_Manifesto.Fn_Manifesto_Gerado(vVeic_codigo, vVeic_Seq) = 'S') then
      pStatus := 'E';
      pMessage := 'Veículo contem Manifesto Gerado!!';
      Return;      
  end if;  

  Begin  
    --Abro o cursor para recuperar o codigo dos carregamentos.
    vAuxiliar := 'Antes do Cursor';
    for vCursorCarreg in ( Select 
                             extractvalue(value(field),      'carregamento/@carreg_codigo') carreg,
                             extractvalue(value(field),      'carregamento/@linha') Linha
                           from
                             Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/parametros/inputs/input/lista_carregs/carregamento'))) field
                          ) loop --entro em loop para executar a vinculação um carregamento de cada vez.
                            
      --------------------------------------------------------------------------------------
      --                        Validações Antes da Vinculação                            --
      --------------------------------------------------------------------------------------    
      If ( vAcao = vAcoes.Vinculacao_VeicCarreg ) Then
         --Executo a função responsável por valida veiculos e embalagens.
        vAuxiliar := 'Antes de Validar Vinclulo Veiculo';

        If ( Not tdvadm.pkg_fifo_validacoes.Fn_Vld_VeicVinculacao( vVeic_codigo, 
                                                                   vVeic_seq, 
                                                                   vCursorCarreg.Carreg, 
                                                                   vMessage ) ) Then                                                                   
          --caso retorne com erro, passo os paramentros de saida, e finalizo processamento                                                                   
          pMessage := vMessage;
          pStatus := pkg_glb_common.Status_Erro;
          Return;
        End If;  
      End If;

      --Utilizo a Função Privada para executar a vinculação de cada carregamento ao veiculo passado
     vAuxiliar := 'Antes de Vincular Veiculo';
      vRetornoFunc := FNP_VinculaCarregVeic( Trim(vCursorCarreg.Carreg),
                                             Trim(vVeic_codigo),
                                             Trim(vVeic_seq),
                                             Trim(vUsuario),
                                             vAcao,
                                             Trim(vAplicacao)
                                            ); 
                                                                      
      --caso ocorra algum erro durante alguma vinculação,
      if vRetornoFunc.Status <> pkg_glb_common.Status_Nomal then
                                  
        --encerro o processamento e lanço mensagem de erro gerada na função.
        pStatus := vRetornoFunc.Status;
        pMessage := vRetornoFunc.Message;
        return;
      else
        --ocorrendo tudo bem, com a vinculação do carregamento, verifico se o usuario quer gerar manifesto
        if vManifesto = 'S' then
              --caso sim, rodo a procedure responsável em gerar o manifesto.

             vAuxiliar := 'Antes de Inserir Manifesto';
              
              -- Diego Lirio - 24/09/2013
              -- Alteração: Geração do manifesto Sendo agora por veículo nao mais por Carregamento
             
              --tdvadm.sp_insere_novomanifesto( Trim(vCursorCarreg.Carreg), 
              --                                Trim(vRota),
              --                                Trim(vUsuario)
              --                               );    
              
              Tdvadm.Pkg_Fifo_Manifesto.Sp_GerarManifesto(vVeic_codigo, vVeic_seq, vUsuario, vRota, pStatus, pMessage);
        end if;
      end if;  
    end loop; --encerro o loop.
  Exception
    --caso ocorra algum erro durante a abertura ou processamento do cursor.
    when others then 
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao executar vinculação.' || ' Posicao ' || vAuxiliar || chr(10) || Sqlerrm || chr(13) || dbms_utility.format_call_stack;
      return;
  end;
  
   --Executo a Procedure que vai garar o Xml com os Carregamento sem Vale de Frete.
   vRetornoFunc := FNP_Xml_CarregSemVF(Trim(vArmazem));
      
   --Caso a Variável tenha retornardo erro, Encerro processamento e mostro mensagem de erro.
   If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal Then
     pStatus  := vRetornoFunc.Status;
     pMessage := vRetornoFunc.Message;
     Return;
   else
     --ou transfere o Xml para a variavel específica
     vXmlCarregSemVF := Trim(vRetornoFunc.Xml);
   End If;
   
   --Exceuto a função que vai gerar o Xml com os Veiculos contratados para o Armazem solicitado.
   vRetornoFunc := FNP_Xml_ListaVeicContratados( Trim(vArmazem) );
  
   --Caso a Variável tenha retornado erro, encerro o processamento e mostro mensagem de erro.
   If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal then
     pStatus := vRetornoFunc.Status;
     pMessage := vRetornoFunc.Message;
     Return;
   else
     --ou transfere o Xml para a variável específica
     vXmlListaVeics := Trim(vRetornoFunc.Xml);
   End If;
   
   
   --Executo a função que vai gerar xml com os Veiculos contratados para o Armazem e já carregados.
   vRetornoFunc := FNP_Xml_VeicCarreg( Trim(vArmazem) );
   
   --Caso a Veriáve tenha retornado algum erro, encerro o processamento, e mostro a mensagem
   If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal then
     pStatus := vRetornoFunc.Status;
     pMessage := vRetornoFunc.Message;
     Return;
   else
     --ou transfere o Xml para a variável específica
     vXmlListaVeicCarreg := vRetornoFunc.Xml;
   End If;
   
   
   --Monta o arquivo propriamente dito.
   vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
   
   vXmlRetorno := vXmlRetorno || '<Table name=#CarregSemVF#><ROWSET>'     || vXmlCarregSemVF     || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#VeicCont#><ROWSET>'        || vXmlListaVeics      || '</ROWSET></Table>';
   vXmlRetorno := vXmlRetorno || '<Table name=#VeicContCarreg#><ROWSET>'  || vXmlListaVeicCarreg || '</ROWSET></Table>';
   
   vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
   --Substitui os carecteres "CORINGAS"
   vXmlRetorno := Replace(vXmlRetorno, '#', '"');
   vXmlRetorno := Replace(vXmlRetorno, '§', '''');
 
 
  --Finaliza a Procedure.
  pStatus := 'N';
  pMessage := '';
  pParamsSaida := vXmlRetorno;
  
end sp_set_VincListaCarreg;                                 


---------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para gerar manifesto.                                                                 -- 
---------------------------------------------------------------------------------------------------------------
Procedure sp_GerarManifesto( pParamsEntrada In Varchar2,
                             pStatus        Out Char,
                             pMessage       Out Varchar2
                           ) As
 --Variáveis utilizadas para capturar valores que foram passados por paramentros.
 vAplicacao tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type;
 vUsuario   tdvadm.t_usu_usuario.usu_usuario_codigo%Type;
 vRota      tdvadm.t_glb_rota.glb_rota_codigo%Type;
 vVersaoNova    varchar2(10);
                   
 --variável de controle          
 vControl Char(10);                           
 
 vCarreg t_arm_carregamento.arm_carregamento_codigo%Type;
 
Begin
  --Inicializa as variáveis que serão utilizadas na execução dessa procedure
  vAplicacao := '';
  vUsuario   := '';
  vRota      := '';
  
  --Popula as variáveis com os paramentros que estão no arquivo XML
  vAplicacao := Trim(pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'aplicacao'));
  vUsuario   := Trim(pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'usuario'));
  vRota      := Trim(pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'rota'));
  vVersaoNova    := Trim(pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'versao_nova'));
  
  --insert into dropme (a,x) values('8596;'||vRota, pParamsEntrada);commit; 
  
/*  if vRota = '021' then
      insert into dropme (a,x) values('8596', pParamsEntrada);commit;  
      Raise_application_error(-20001, 'Erro, ramal 8596');
  end if;  */
  
    
  --entra em Laço para recuperar os Códigos dos Carregamentos.
  Begin
    For vCursorCarregs In ( Select 
                              ExtractValue(Value(field), 'carregamento/@linha')         Carreg_linha,
                              ExtractValue(Value(field), 'carregamento/@carreg_codigo') Carreg_Codigo    
                            From
                             Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/parametros/inputs/input/lista_carregs/carregamento'))) field
                           )  
                           Loop
                             --Dentro do loop, executa a procedure responsável por criar o manifesto.
                             Begin
                               
                               -- ToDo...: Realizar aki condicao na rota para inserir 
                               --          MDFe ou processo atual (pkg_fifo_manifesto.Sp_Insere_MDFe)
                               -- Analista: Diego Lirio
                               if Tdvadm.Pkg_Fifo_Manifesto.Fn_Is_MDFe(pRota => vRota) = 'S' then
                                   Raise_Application_Error(-20001, 'MDFe não implantado!');
                               else
                                   tdvadm.sp_insere_novomanifesto( vCursorCarregs.Carreg_Codigo,
                                                                   vRota,
                                                                   vUsuario,
                                                                   vVersaoNova
                                                             );                                    
                               end if;                                                             
                     
                               Begin
                                 --executa a função que vai verificar / baixar carregamentos mobile
                                vControl := pkg_fifo_ctrc.FNP_BaixaCarregVincMobile( vCursorCarregs.Carreg_Codigo, 
                                                                          vUsuario
                                                                         );
                                                                        
                                -- ToDo...: Diego Lirio Funcao para remedio Temp... 
                                vCarreg := vCursorCarregs.Carreg_Codigo;                                      
                                 
                               Exception
                                 When Others Then
                                   pStatus := pkg_glb_common.Status_Erro;
                                   pMessage := 'Erro: ' || Sqlerrm;
                               End;
                                                           
                                                             
                             Exception
                               --caso ocorra algum erro, lança mensagem de erro, e finaliza processamento.
                               When Others Then
                                 pStatus := pkg_glb_common.Status_Erro;
                                 pMessage := 'Erro ao gerar manifesto. ' || chr(13) || Sqlerrm;
                                 Return;
                             End;
                           End Loop;
       -- ToDo...: Diego Lirio Funcao para remedio Temp...
       --pkg_fifo_manifesto.Sp_Remedio_Temp_VF(vcarreg,  pStatus, pMessage);                  
  Exception
    --caso ocorra algum erro durante o processo de abertura e tratamento do cursor de extração XML
    When Others Then
      --Encerro a procedure, e envio mensagem de erro.
      pStatus:= pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao abrir/tratar cursor XML' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack;
      Return;
  End;

  -- Seta os valores passados para os paramentros de saida.
  pStatus  := pkg_glb_common.Status_Nomal;
  pMessage := 'Manifesto gerado com sucesso.';
   
End  sp_GerarManifesto;                                   


--procedure criada para ser utilizada na correção da tabela de viagem.
Procedure sp_corrigeViagem( pCarreg_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type, 
                            pStatus Out Char,
                            pMessage Out Varchar2
                           ) As

  --Variáveis utilizadas para buscar os códigos do veiculo disp.
  vVeicDisp_Codigo  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
  vVeicDisp_Seq tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type;
  
  --Variáveis utilizadas para recuperar dados do motorista.
  P_PROPRIETARIO   Varchar2(50);
  P_MARCA          Varchar2(50);
  P_PLACA          Varchar2(50);
  P_LOCAL          Varchar2(50);
  P_UF_VEICULO     Varchar2(50);
  P_NOMEMOTORISTA  Varchar2(50);
  P_RG             Varchar2(50);
  P_CPF            Varchar2(50);
  P_UF_MOTORISTA   Varchar2(50);
  P_CNH            Varchar2(50);
  P_TPMOTORISTA    Varchar2(50);
  P_PLACA_SAQUE    Varchar2(50);
  
  
  
  --Cursor utilizado para buscar todos os ctrcs vinculados a esse veiculo.
  Cursor vCursor 
  ( pVeiculoDisp_Codigo  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
    pVeiculoDisp_Seq     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type
  ) Is
  Select
    co.con_viagem_numero,
    co.glb_rota_codigoviagem,
    co.con_conhecimento_codigo,
    co.glb_rota_codigo
  FROM 
    T_CON_CONHECIMENTO CO
   WHERE CO.ARM_CARREGAMENTO_CODIGO In ( SELECT CA.ARM_CARREGAMENTO_CODIGO
                                         FROM T_ARM_CARREGAMENTO CA
                                         WHERE CA.FCF_VEICULODISP_CODIGO = pVeiculoDisp_Codigo
                                         AND CA.FCF_VEICULODISP_SEQUENCIA = pVeiculoDisp_Seq
                                        ); 
  
Begin
  vVeicDisp_Codigo := '';
  vVeicDisp_Seq := '';

  --Vou buscar o código do veiculodisp
  Begin

    Select
     car.fcf_veiculodisp_codigo,
     car.fcf_veiculodisp_sequencia
    Into
      vVeicDisp_Codigo,
      vVeicDisp_Seq
    From
      tdvadm.t_arm_carregamento car
    Where
      car.arm_carregamento_codigo = pCarreg_codigo;
  Exception
    When no_data_found Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Não foi possivel localizar o veiculo Disp.';
      Return;
    
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar localizar veiculo disp.' || chr(13) || Sqlerrm;
      Return;
  End;
  
  --busco dados do motorista
  tdvadm.SP_BUSCA_FCFVEICULODISP( vVeicDisp_Codigo,
                                  P_PROPRIETARIO,
                                  P_MARCA,
                                  P_PLACA,
                                  P_LOCAL,
                                  P_UF_VEICULO,
                                  P_NOMEMOTORISTA,
                                  P_RG,
                                  P_CPF,
                                  P_UF_MOTORISTA,
                                  P_CNH,
                                  P_TPMOTORISTA,
                                  P_PLACA_SAQUE
                                );
  
   If Trim(P_TPMOTORISTA) = 'F' Then
     For cCursor In vCursor( vVeicDisp_Codigo,
                             vVeicDisp_Seq
                           ) 
                                                     
                           Loop
                             dbms_output.put_line( ccursor.con_conhecimento_codigo || ' - ' || ccursor.glb_rota_codigo );
                             Begin
                              Update t_con_viagem viag
                                Set viag.frt_conjveiculo_codigo = Trim(P_PLACA),
                                    viag.frt_motorista_codigo = (select m.frt_motorista_codigo 
                                                                         from t_frt_motorista m  
                                                                         where Trim(m.frt_motorista_cpf) = trim(P_CPF)
                                                                         and m.frt_motorista_comissao = 'S'
                                                                         and m.frt_motorista_dtdesligamento is null ),
                                    viag.car_carreteiro_cpfcodigo = Null,
                                    viag.car_carreteiro_saque = Null,
                                    viag.con_viagem_placa = Null,
                                    viag.con_viagem_placasaque = Null

                               WHERE Trim(viag.CON_VIAGEM_NUMERO) = Trim(cCursor.Con_Viagem_Numero)
                               AND Trim(viag.GLB_ROTA_CODIGOVIAGEM) = Trim(ccursor.glb_rota_codigoviagem);
                               
                               Commit;

                            Exception
                              When Others Then
                                raise_application_error(-20001, 'Erro');
                            End;

                           End Loop;
                            
   
      End If;                                

End sp_corrigeViagem;


-- ....

---------------------------------------------------------------------------------------------------------
--Procedure utilizada para recuperar lista de veiculos contratados em um determinado armazem.
---------------------------------------------------------------------------------------------------------
Procedure sp_get_Veiculos ( pArm_armazem_codigo In tdvadm.t_arm_armazem.arm_armazem_codigo%Type, 
                            pStatus Out Char,
                            pMessage Out Varchar2,
                            pCursor Out pkg_glb_common.T_CURSOR
                          ) Is 
Begin
  Begin
    --Seto os paramentros de saida
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage:= '';
    
    -- abro o cursor com o select com os veiculos contratados nos ultimos dois dias 
    -- sem vale de frete emitido
    -- sem ocorrências
    -- e com estágio mobile nulo.
    Open pCursor For
      sELECT 
       Distinct
         S.FCF_VEICULODISP_CODIGO                                  Veic_codigo,
         S.fcf_veiculodisp_sequencia                               Veic_sequencia,
                                             
         to_char(s.fcf_veiculodisp_data, 'dd/mm/yyyy hh24:mi:ss')    Veic_Data,
         to_char((trunc(sysdate) - trunc(s.fcf_veiculodisp_data)))   Veic_qtdeDiasDisp,                 
         FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO,
                               S.FCF_VEICULODISP_SEQUENCIA)           Veic_PLACA,
         pkg_fifo_auxiliar.fn_removeAcentos(FN_BUSCA_MOTORISTAVEICULO( S.FCF_VEICULODISP_CODIGO,                                
                                    S.FCF_VEICULODISP_SEQUENCIA) )    Veic_Motorista,                  
         T.FCF_TPVEICULO_DESCRICAO                                    Veic_Descricao,
         s.fcf_veiculodisp_ufdestino                                  Veic_UfDestino,
         pkg_fifo_auxiliar.fn_removeAcentos( s.usu_usuario_cadastro)  Veic_usuCadastro,
         pkg_fifo_ctrc.FNP_Get_DestVeicDisp(s.fcf_veiculodisp_codigo, s.fcf_veiculodisp_sequencia) Destino,
         solic.fcf_solveic_cod,
         s.arm_estagiocarregmob_codigo
       
                                
      FROM 
        T_FCF_VEICULODISP S,
        T_FCF_TPVEICULO   T,
        T_FCF_SOLVEIC     solic
      Where
        0=0 
        AND S.FCF_TPVEICULO_CODIGO = T.FCF_TPVEICULO_CODIGO
        And s.fcf_veiculodisp_codigo = solic.fcf_veiculodisp_codigo
        And s.fcf_veiculodisp_sequencia = solic.fcf_veiculodisp_sequencia
        AND S.FCF_OCORRENCIA_CODIGO IS NULL                                                    
        AND S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL                                              
        AND S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL    
        And s.arm_armazem_codigo = pArm_armazem_codigo
        And nvl(s.arm_estagiocarregmob_codigo, 'r') = 'r'
        And trunc(s.fcf_veiculodisp_data) >= trunc(Sysdate)-3
      Order by 5;
    
  Exception
    --caso ocorra algum erro, seto os paramentros de saida com mensagem de erro.
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao recuperar lista de veiculos contratados para o armazem: ' || pArm_armazem_codigo  || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_ctrc.sp_get_veiculos()' || chr(10) ||
                  'Erro Ora: ' || Sqlerrm; 
      Return;
  End;
End sp_get_Veiculos;         

/*
procedure Sp_GetVeicDispPorPlaca(pPlaca In Tdvadm.t_Fcf_Veiculodisp.Car_Veiculo_Placa%Type,
                                 pCursor Out pkg_arm_carregamento.T_Cursor,
                                 pStatus Out Char,
                                 pMessage Out Varchar2)
As
VCOUNT NUMBER;
Begin
  
    SELECT COUNT(*)                               
      INTO VCOUNT
      FROM 
        tdvadm.T_FCF_VEICULODISP S,
        tdvadm.T_FCF_TPVEICULO   T,
        tdvadm.T_FCF_SOLVEIC     solic
    Where
      0=0 
      AND S.FCF_TPVEICULO_CODIGO = T.FCF_TPVEICULO_CODIGO
      And s.fcf_veiculodisp_codigo = solic.fcf_veiculodisp_codigo
      And s.fcf_veiculodisp_sequencia = solic.fcf_veiculodisp_sequencia
      AND S.FCF_OCORRENCIA_CODIGO IS NULL                                                    
      AND S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL                                              
      AND S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL    
      And (s.car_veiculo_placa = pPlaca or trim(tdvadm.fn_get_conjdata(pPlaca)) = trim(s.frt_conjveiculo_codigo))
      And s.arm_estagiocarregmob_codigo is not null
      And s.arm_estagiocarregmob_codigo Not In('F');
      
  if VCOUNT = 0 then
    pStatus := 'E';
    pMessage := 'Não há veículo disppnivel com esta placa.';
  else
    pStatus := 'N';
    pMessage := 'Veículo disponivel encontrado em andamento.';    
  end if;    

  Open pCursor For
    SELECT 
     Distinct
       S.FCF_VEICULODISP_CODIGO                                  Veic_codigo,
       S.fcf_veiculodisp_sequencia                               Veic_sequencia,
                     
                                             
       to_char(s.fcf_veiculodisp_data, 'dd/mm/yyyy hh24:mi:ss')    Veic_Data,
       to_char((trunc(sysdate) - trunc(s.fcf_veiculodisp_data)))   Veic_qtdeDiasDisp,                 
       tdvadm.FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO,
                             S.FCF_VEICULODISP_SEQUENCIA)           Veic_PLACA,
       tdvadm.pkg_fifo_auxiliar.fn_removeAcentos(tdvadm.FN_BUSCA_MOTORISTAVEICULO( S.FCF_VEICULODISP_CODIGO,                                

                                  S.FCF_VEICULODISP_SEQUENCIA) )    Veic_Motorista,                  
       T.FCF_TPVEICULO_DESCRICAO                                    Veic_Descricao,
       s.fcf_veiculodisp_ufdestino                                  Veic_UfDestino,
       tdvadm.pkg_fifo_auxiliar.fn_removeAcentos( s.usu_usuario_cadastro)  Veic_usuCadastro,
       tdvadm.pkg_fifo_ctrc.FNP_Get_DestVeicDisp(s.fcf_veiculodisp_codigo, s.fcf_veiculodisp_sequencia) Destino,
       solic.fcf_solveic_cod,
       s.arm_estagiocarregmob_codigo
    FROM 
      tdvadm.T_FCF_VEICULODISP S,
      tdvadm.T_FCF_TPVEICULO   T,
      tdvadm.T_FCF_SOLVEIC     solic
    Where
      0=0 
      AND S.FCF_TPVEICULO_CODIGO = T.FCF_TPVEICULO_CODIGO
      And s.fcf_veiculodisp_codigo = solic.fcf_veiculodisp_codigo
      And s.fcf_veiculodisp_sequencia = solic.fcf_veiculodisp_sequencia
      AND S.FCF_OCORRENCIA_CODIGO IS NULL                                                    
      AND S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL                                              
      AND S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL    
      And (s.car_veiculo_placa = pPlaca or trim(tdvadm.fn_get_conjdata(pPlaca)) = trim(s.frt_conjveiculo_codigo))
      And s.arm_estagiocarregmob_codigo is not null
      And s.arm_estagiocarregmob_codigo Not In('F');
            
End Sp_GetVeicDispPorPlaca; 
*/                                

Procedure Sp_Contem_ManifGerado( pXmlIn   In  Varchar2,
                                 pContem  Out Char,
                                 pStatus  Out Char,
                                 pMessage Out Varchar2)
As
  vVeicDisp t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
  vVeicSeq  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type;
Begin
      Select extractvalue(Value(V), 'Input/VeiculoDisponivel'),
               extractvalue(Value(V), 'Input/Sequencia')
              into vVeicDisp,
                   vVeicSeq
             From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V; 
       
       pContem := Tdvadm.Pkg_Fifo_Manifesto.Fn_Manifesto_Gerado(vVeicDisp, vVeicSeq);
       pStatus := 'N';
       pMessage := 'OK';       
       
End Sp_Contem_ManifGerado;                                  

-- Novo Cte

Procedure Sp_Get_CarregCTRC(pXmlIn  In  Varchar2,
                            pXmlOut Out Clob ,
                            pStatus Out Char,
                            pMessage Out Varchar2)                      
/*  XmlIn de Ex:     

        <Parametros>
          <Input>
            <Armazem>06</Armazem>
          </Input>
        </Parametros>                            
*/                        
  As
  vArmazem t_arm_armazem.arm_armazem_codigo%Type;
  vXmlRetorno Clob;
  vCount Integer;
  Begin
    Begin
        Select extractvalue(Value(V), 'Input/Armazem')
              into vArmazem
             From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;   
        vCount := 0;     
        For carregamentos in ( SELECT DISTINCT 
                                      CA.ARM_CARREGAMENTO_CODIGO                                                                         carreg_codigo,
                                      Trim( TO_CHAR( CA.ARM_CARREGAMENTO_DTFECHAMENTO, 'dd/mm/yyyy hh24:mi:ss'))                         carreg_dtFechamento, 
                                      to_char( CA.ARM_CARREGAMENTO_PESOCOBRADO )                                                         carreg_PesoCobrado,  
                                      to_char( CA.ARM_CARREGAMENTO_PESOREAL )                                                            carreg_pesoReal,  
                                      To_char( CA.ARM_CARREGAMENTO_QTDCTRC )                                                             carreg_qtdeCtrc, 
                                      to_char( CA.ARM_CARREGAMENTO_QTDIMPCTRC )                                                          carreg_qtdeCtrcImp, 
                                      to_char( CA.ARM_CARREGAMENTO_QTDCTRC, '9909') ||' / '|| to_char(CA.ARM_CARREGAMENTO_QTDIMPCTRC, '9909') carreg_ctrcs, 
                                      Trim( to_char( CA.ARM_CARREGAMENTO_DTVIAGEM, 'dd/mm/yyyy hh24:mi:ss'))                             carreg_DtViagem, 
                                      Trim( to_char( CA.ARM_CARREGAMENTO_DTENTREGA, 'dd/mm/yyyy hh24:mi:ss'))                            carreg_DtEntrega, 
                                      FN_PLACA_DOCARREG(CA.ARM_CARREGAMENTO_CODIGO)                                                      ctrcs_placa, 
                                      Decode(vd.fcf_veiculodisp_flagvirtual,'S', '', CA.FCF_VEICULODISP_CODIGO||'-'||ca.fcf_veiculodisp_sequencia) veic_disp,
                                      ca.arm_carregamento_destembs                                                                       carreg_destino,
                                      decode( (Select Count(*) From t_con_docmdfe m
                                        Where m.arm_carregamento_codigo = ca.arm_carregamento_codigo ), 0, 9, 0)  carreg_manifesto,
                                      FN_BUSCA_PLACAVEICULO(vd.FCF_VEICULODISP_CODIGO, vd.FCF_VEICULODISP_SEQUENCIA)                     PLACA,
                                      decode(nvl(ca.arm_carregamento_flagmanifesto, 'R'), 'R', '9', 'S', '1')                            manifesto_flagObrg,
                                      ca.arm_carregamemcalc_codigo calc,
                                      0  selected
                                    FROM T_ARM_CARREGAMENTO CA,
                                         T_FCF_VEICULODISP VD   
                                    Where 0=0
                                      And CA.ARM_CARREGAMENTO_DTFECHAMENTO IS NOT Null
                                      and CA.FCF_VEICULODISP_CODIGO  = VD.FCF_VEICULODISP_CODIGO
                                      and ca.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
                                      and CA.FCF_VEICULODISP_CODIGO  IS NOT Null
                                      And CA.ARM_CARREGAMENTO_DTFINALIZACAO IS Null
                                      And Vd.FCF_VEICULODISP_FLAGVALEFRETE IS NULL
                                      and CA.ARM_ARMAZEM_CODIGO = Trim(vArmazem)
                                      And TRUNC(CA.ARM_CARREGAMENTO_DTFECHAMENTO) >=  Trunc(Sysdate) - 60
                                      ORDER BY TO_NUMBER(CA.ARM_CARREGAMENTO_CODIGO)
                           ) 
         Loop
                     vCount := vCount + 1;                           
                     vXmlRetorno := vXmlRetorno
                                      || '<row num="'            || To_Char(vCount)                        ||'" >'            ||
                                         '<carreg_codigo>'       || To_Char(carregamentos.carreg_codigo)  || '</carreg_codigo>'      ||
                                         '<carreg_dtFechamento>' || To_Char(carregamentos.carreg_dtFechamento) || '</carreg_dtFechamento>'     ||
                                         '<carreg_PesoCobrado>'  || To_Char(carregamentos.carreg_PesoCobrado)  || '</carreg_PesoCobrado>'  ||
                                         '<carreg_pesoReal>'     || To_Char(carregamentos.carreg_pesoReal)     || '</carreg_pesoReal>'       ||
                                         '<carreg_qtdeCtrc>'     || To_Char(carregamentos.carreg_qtdeCtrc)     || '</carreg_qtdeCtrc>'       ||
                                         '<carreg_qtdeCtrcImp>'  || To_Char(carregamentos.carreg_qtdeCtrcImp)  || '</carreg_qtdeCtrcImp>'  ||
                                         '<carreg_ctrcs>'        || To_Char(carregamentos.carreg_ctrcs)        || '</carreg_ctrcs>'||
                                         '<carreg_DtViagem>'     || To_Char(carregamentos.carreg_DtViagem)     || '</carreg_DtViagem>' ||
                                         '<carreg_DtEntrega>'    || To_Char(carregamentos.carreg_DtEntrega)    || '</carreg_DtEntrega>' ||
                                         '<ctrcs_placa>'         || To_Char(carregamentos.ctrcs_placa)         || '</ctrcs_placa>' ||
                                         '<veic_disp>'           || To_Char(carregamentos.veic_disp)           || '</veic_disp>' ||
                                         '<carreg_destino>'      || To_Char(carregamentos.carreg_destino)      || '</carreg_destino>' ||
                                         '<carreg_manifesto>'    || To_Char(carregamentos.carreg_manifesto)    || '</carreg_manifesto>' ||
                                         '<PLACA>'               || To_Char(carregamentos.PLACA)               || '</PLACA>' ||                                          
                                         '<manifesto_flagObrg>'  || To_Char(carregamentos.manifesto_flagObrg)  || '</manifesto_flagObrg>' ||                                         
                                         '<calc>'                || To_Char(carregamentos.calc)                || '</calc>' ||                                         
                                         '<selected>'            || To_Char(carregamentos.selected)            || '</selected>' ||
                                         '</row>';
                    vCount := vCount + 1;                     
         End Loop;      
        
        pStatus := 'N';
        pMessage := 'OK';        
        
    Exception 
      When Others Then
        pStatus := 'E';
        pMessage := sqlerrm ;
    End;                  
    
         
     vXmlRetorno := '<Parametros>
                           <OutPut>
                                 <Status>' ||pStatus ||'</Status>
                                 <Message>'||pMessage||'</Message>                               
                                 <Tables>
                                       <Table name="CarregCTRCs"><RowSet>'|| vXmlRetorno || '</RowSet></Table>
                                 </Tables>
                           </OutPut>
                     </Parametros>';    
    pXmlOut := Pkg_Glb_Common.FN_LIMPA_CAMPO(vXmlRetorno);     
                                           
End Sp_Get_CarregCTRC;      

Procedure Sp_VinculaCarregVeicDisp(pXmlIn   In varchar2,
                                   pStatus  Out Char,
                                   pMessage Out varchar2) 
As
 vVeicDisp tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
 vVeicSeq  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
 vUsuario  t_usu_usuario.usu_usuario_codigo%Type;
 vRota     t_Glb_Rota.Glb_Rota_Codigo%Type;
 vArmazem  t_arm_armazem.arm_armazem_codigo%type;
 vEstagio  t_fcf_veiculodisp.arm_estagiocarregmob_codigo%Type;
 vVFGer    t_fcf_veiculodisp.fcf_veiculodisp_flagvalefrete%Type;
 
 /* Variavel criada para verificar se a coleta e´importacao ou exportacao 
    JOAO JR / SIRLANO - 17/11/2021 - CH.221017 
 */
/*
-- modelo do XML
<Parametros>
   <Input>      
      <VeiculoDisp>8669404</VeiculoDisp>      
      <VeiculoSeq>0</VeiculoSeq>      
      <Usuario>acbsantos</Usuario>      
      <Rota>460</Rota>      
      <Armazem>13</Armazem>      
      <ListaCarregamento>         
         <Carregamento row="0" codigo="4193875"/>      
      </ListaCarregamento>   
   </Input>
</Parametros>
*/ 
 
 vImpExp   tdvadm.t_arm_coleta.arm_coleta_normalimpexp%Type;   
Begin
    Select extractvalue(Value(V), 'Input/VeiculoDisp'),
           extractvalue(Value(V), 'Input/VeiculoSeq'),
           extractvalue(Value(V), 'Input/Usuario'),
           extractvalue(Value(V), 'Input/Rota'),
           extractvalue(Value(V), 'Input/Armazem')
          into vVeicDisp,
               vVeicSeq,
               vUsuario,
               vRota,
               vArmazem
         From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;
--         insert into dropme m (a, l) values ('Teste_01/12/2015', pXmlIn); commit;

--    insert into t_glb_sql values (pXmlIn,sysdate,'sirlano','vincula');
--    commit;

      -- Alteração a Pedido do Chaves 23/02/2015
      -- Diego Lirio | Bruno Bernardo
/*    Select vd.arm_estagiocarregmob_codigo,
             vd.fcf_veiculodisp_flagvalefrete
       into vEstagio,
            vVFGer
       from t_fcf_veiculodisp vd
       where vd.fcf_veiculodisp_codigo = vVeicDisp
         and vd.fcf_veiculodisp_sequencia = vVeicSeq;
    if vEstagio != null then
        pStatus := 'E';
        pMessage := 'Veículo Criado pelo coletor de Dados, poderá somente ser vinculado Veículo/Carrega pelo mesmo!!';
        Return;       
    end if; */    
         
    /*
     * Valida se Veiculo possui Vale de Frete Gerado...
     */
    if Pkg_Fcf_Veiculodisp.Fn_ContemValeFreteGerado(vVeicDisp, vVeicSeq) = 'S' then
        pStatus := 'E';
        pMessage := 'Veículo contem Vale de Frete Gerado';
        return;
    end if;
    
    /*
     * Valida se Veiculo possui Manifesto Gerado...
     */    
    if Tdvadm.Pkg_Fifo_Manifesto.Fn_Manifesto_Gerado(vVeicDisp, vVeicSeq) = 'S' then
        pStatus := 'E';
        pMessage := 'Veículo contem Manifesto Gerado!!';
        Return;      
    end if;      
    
    For carregamento in ( Select extractvalue(Value(V), 'Carregamento/@codigo') Codigo
                           From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input/ListaCarregamento/Carregamento '))) V ) 
    Loop
        Begin       
            -- Validacoes   
            If ( Not tdvadm.pkg_fifo_validacoes.Fn_Vld_VeicVinculacao( vVeicDisp, 
                                                                       vVeicSeq, 
                                                                       carregamento.Codigo, 
                                                                       pMessage ) ) Then
              pStatus := pkg_glb_common.Status_Erro;
              Return;
            End If;            
            tdvadm.sp_mesa_addveicnocarreg(vVeicDisp, vVeicSeq, carregamento.Codigo, vUsuario);
        Exception
          When Others Then
            pStatus := pkg_fifo.Status_Erro;
            pMessage := 'Erro ao tentar vincular veiculo ao carregamento '|| carregamento.Codigo || chr(13) || Sqlerrm;
            Rollback;
            Return;
        End;  
    End Loop;
    
      /******** Sirlano 23/04/2021
                Para a Filial de Santos
                Mudando o Veiculo da Coleta  ***********************/
    -- sE ele gosta da ideia  deixar
--    If (vArmazem = '42' ) AND ( TO_NUMBER(TO_CHAR(SYSDATE,'YYYMMDDHH24MISS')) > 2029021230000 ) Then 
    -- se ele nao gostar deixar esta
    If (vArmazem in ('42','18') ) Then  

        /* JOAO JR / SIRLANO - 17/11/2021 - CH.221017 */ 
        select  z.arm_coleta_normalimpexp
          into vImpExp 
        from tdvadm.t_arm_coleta z
        where (z.arm_coleta_ncompra, 
               z.arm_coleta_ciclo) in (select nt.arm_coleta_ncompra, 
                                              nt.arm_coleta_ciclo
                                       from tdvadm.t_fcf_veiculodisp     vd,
                                            tdvadm.t_arm_carregamento    ca,
                                            tdvadm.t_arm_carregamentodet cd,
                                            tdvadm.t_arm_nota            nt
                                       where vd.fcf_veiculodisp_codigo = vVeicDisp
                                         and vd.fcf_veiculodisp_sequencia = vVeicSeq
                                         and vd.fcf_veiculodisp_codigo = ca.fcf_veiculodisp_codigo
                                         and vd.fcf_veiculodisp_sequencia = ca.fcf_veiculodisp_sequencia
                                         and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
                                         and cd.arm_embalagem_numero = nt.arm_embalagem_numero
                                         and cd.arm_embalagem_flag = nt.arm_embalagem_flag
                                         and cd.arm_embalagem_sequencia = nt.arm_embalagem_sequencia);          

    --   if nvl(vImpExp, 'N') <> 'I' then -- somente se for diferente de importacao
           
           delete tdvadm.t_arm_coleta_motorista cm
           where (cm.arm_coleta_ncompra,
                  cm.arm_coleta_ciclo) in (select nt.arm_coleta_ncompra,
                                                  nt.arm_coleta_ciclo
                                           from tdvadm.t_fcf_veiculodisp vd,
                                                tdvadm.t_arm_carregamento ca,
                                                tdvadm.t_arm_carregamentodet cd,
                                                tdvadm.t_arm_nota nt
                                           where vd.fcf_veiculodisp_codigo = vVeicDisp
                                             and vd.fcf_veiculodisp_sequencia = vVeicSeq
                                             and vd.fcf_veiculodisp_codigo = ca.fcf_veiculodisp_codigo
                                             and vd.fcf_veiculodisp_sequencia = ca.fcf_veiculodisp_sequencia
                                             and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
                                             and cd.arm_embalagem_numero = nt.arm_embalagem_numero
                                             and cd.arm_embalagem_flag = nt.arm_embalagem_flag
                                             and cd.arm_embalagem_sequencia = nt.arm_embalagem_sequencia);
           
           delete tdvadm.T_CON_VEICCONHEC m
           where m.fcf_veiculodisp_codigo =  vVeicDisp
             and m.fcf_veiculodisp_sequencia = vVeicSeq;

           insert into tdvadm.t_arm_coleta_motorista
           select distinct nt.arm_coleta_ncompra,
                  nvl(vd.car_carreteiro_cpfcodigo,m.frt_motorista_cpf) arm_coleta_carreteiro, 
                  nvl(vd.car_veiculo_placa,vd.frt_conjveiculo_codigo) arm_coleta_motorista_placa ,
                  vd.car_veiculo_saque arm_coleta_motorista_placasaqu ,
                   null usu_usuario_codigo_prog ,
                  null con_freteoper_id ,
                  null con_freteoper_rota ,
                  /* 
                     JOAO JR / SIRLANO - 13/11/2021 - CH.221017

                     funcao usada para pegar a placa do veiculo disponivel,
                     anteriormente estes campos eram gravados como nullo 
                     arm_coleta_placa2 e arm_coleta_placa3       
                  */                  
                  tdvadm.fn_get_placaVd(vVeicDisp,vVeicSeq,'CAR') arm_coleta_placa2 ,
                  null arm_coleta_placa2saque ,
                  tdvadm.fn_get_placaVd(vVeicDisp,vVeicSeq,'CA2') arm_coleta_placa3 ,
                  null arm_coleta_placa3saque ,
                  sysdate arm_coleta_motorista_cadastro ,
                  nt.arm_coleta_ciclo
           from tdvadm.t_fcf_veiculodisp vd,
                tdvadm.t_arm_carregamento ca,
                tdvadm.t_arm_carregamentodet cd,
                tdvadm.t_arm_nota nt,
                tdvadm.t_frt_conjunto cj,
                tdvadm.t_frt_motorista m
           where vd.fcf_veiculodisp_codigo = vVeicDisp
             and vd.fcf_veiculodisp_sequencia = vVeicSeq
             and vd.fcf_veiculodisp_codigo = ca.fcf_veiculodisp_codigo
             and vd.fcf_veiculodisp_sequencia = ca.fcf_veiculodisp_sequencia
             and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
             and cd.arm_embalagem_numero = nt.arm_embalagem_numero
             and cd.arm_embalagem_flag = nt.arm_embalagem_flag
             and cd.arm_embalagem_sequencia = nt.arm_embalagem_sequencia
             and vd.frt_conjveiculo_codigo = cj.frt_conjveiculo_codigo (+)
             and cj.frt_motorista_codigo = m.frt_motorista_codigo (+)
             and 0 = (select count(*)
                      from tdvadm.t_arm_coleta_motorista m
                      where m.arm_coleta_ncompra = nt.arm_coleta_ncompra
                        and m.arm_coleta_ciclo = nt.arm_coleta_ciclo);
         

           insert into tdvadm.T_CON_VEICCONHEC
           select distinct vd.fcf_veiculodisp_codigo,
                  vd.fcf_veiculodisp_sequencia,
                  nt.con_conhecimento_codigo,
                  nt.con_conhecimento_serie,
                  nt.glb_rota_codigo,
                  sysdate,
                  'sistema'
           from tdvadm.t_fcf_veiculodisp vd,
                tdvadm.t_arm_carregamento ca,
                tdvadm.t_arm_carregamentodet cd,
                tdvadm.t_arm_nota nt
           where vd.fcf_veiculodisp_codigo = vVeicDisp
             and vd.fcf_veiculodisp_sequencia = vVeicSeq
             and vd.fcf_veiculodisp_codigo = ca.fcf_veiculodisp_codigo
             and vd.fcf_veiculodisp_sequencia = ca.fcf_veiculodisp_sequencia
             and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
             and cd.arm_embalagem_numero = nt.arm_embalagem_numero
             and cd.arm_embalagem_flag = nt.arm_embalagem_flag
             and cd.arm_embalagem_sequencia = nt.arm_embalagem_sequencia
             and 0 = (select count(*)
                      from tdvadm.T_CON_VEICCONHEC m
                      where m.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
                        and m.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
                        and m.con_conhecimento_codigo = nt.con_conhecimento_codigo
                        and m.con_conhecimento_serie = nt.con_conhecimento_serie
                        and m.glb_rota_codigo = nt.glb_rota_codigo); 
     --  end if;

    End If;
/***********************  FIM   ********************************/

    
    
    
    
    
    pStatus := pkg_fifo.Status_Normal;
    pMessage := 'Carregamento(s) Vinculado com sucesso com Veículo Disponivel ['||vVeicDisp||'-'||vVeicSeq||']';            
    Commit;
End Sp_VinculaCarregVeicDisp;                                   
                                   
Procedure Sp_DesvinculaCarregVeicDisp(pXmlIn   In varchar2,
                                      pStatus  Out Char,
                                      pMessage Out varchar2) 
As
 vVeicDisp tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
 vVeicSeq  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
 vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type;
 vVeicDispVirtual tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
 vUsuario  t_usu_usuario.usu_usuario_codigo%Type;
 vCount    Integer;
Begin
    Begin
        Select extractvalue(Value(V), 'Input/VeiculoDisp'),
               extractvalue(Value(V), 'Input/VeiculoSeq'),
               extractvalue(Value(V), 'Input/Usuario'),
               extractvalue(Value(V), 'Input/Carregamento')
              into vVeicDisp,
                   vVeicSeq,
                   vUsuario,
                   vCarregamento
             From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;    

        if Tdvadm.Pkg_Fifo_Manifesto.Fn_Manifesto_Gerado(vVeicDisp, vVeicSeq) = 'S' then
            pStatus := 'E';
            pMessage := 'Veículo contem Manifesto Gerado!!';
            Return;      
        end if; 
        
        -- Verifica se há realmente o vinculo
        Select Count(*) 
          Into vCount
          FROM t_arm_carregamento t
         where 0=0
           and t.arm_carregamento_codigo   = vCarregamento
           and t.fcf_veiculodisp_codigo    = vVeicDisp
           and t.fcf_veiculodisp_sequencia = vVeicSeq;           
         if vCount = 0 then
           pStatus  := pkg_fifo.Status_Erro;
           pMessage := 'Erro ao desvincular carregamento.'||chr(13)||
                         'Não existe carregamento vinculado ao veículo informado.';
           Return;
         end if;     
         
         -- Verificao o Estagio do Carregamento antes de Deixar Desvincular
         -- verifica se existe um veiculo real   
         
         /* ANALISAR POR DIEGO
         select count(*) 
            into vCount
         from t_fcf_veiculodisp vd--,
              --t_arm_estagiocarregmob est
         where vd.fcf_veiculodisp_codigo    = vVeicDisp
           and vd.fcf_veiculodisp_sequencia = vVeicSeq
           --and VD.arm_estagiocarregmob_codigo = EST.ARM_ESTAGIOCARREGMOB_CODIGO (+)
           and vd.arm_estagiocarregmob_codigo is not null;  --NVL(est.arm_estagiocarregmob_ordem,0) >= 4; -- (4) Conferido ou (5) Finalizado         
         if vCount > 0 Then
           Select Count(*) 
             Into vCount
             From t_arm_carregamentoveic cv
             where cv.arm_carregamento_codigo = vCarregamento
               and cv.fcf_veiculodisp_codigo = vVeicDisp   
               and cv.fcf_veiculodisp_sequencia = vVeicSeq; 
           -- se retornar carregamento-foi feito pelo Mobile e não poderá ser desvinculado!!!
           --  ao menos que seje desvinculado pelo mobile...      
           if vCount > 0 then           
               pStatus  := pkg_fifo.Status_Erro;
               pMessage := 'Erro ao desvincular carregamento.'||chr(10)||
                               'O Carregamento foi Feito pelo Coletor.';-- e se encontra Conferido ou Finalizado.';
           end if;
           Return;
         end if;  
         */          
         
                
         select count(*) 
            into vCount
         from t_fcf_veiculodisp vd--,
              --t_arm_estagiocarregmob est
         where vd.fcf_veiculodisp_codigo    = vVeicDisp
           and vd.fcf_veiculodisp_sequencia = vVeicSeq
           --and VD.arm_estagiocarregmob_codigo = EST.ARM_ESTAGIOCARREGMOB_CODIGO (+)
           and vd.arm_estagiocarregmob_codigo is not null;  --NVL(est.arm_estagiocarregmob_ordem,0) >= 4; -- (4) Conferido ou (5) Finalizado         
         if vCount > 0 Then
           Select Count(*) 
             Into vCount
             From t_arm_carregamentoveic cv
             where cv.arm_carregamento_codigo = vCarregamento
               and cv.fcf_veiculodisp_codigo = vVeicDisp   
               and cv.fcf_veiculodisp_sequencia = vVeicSeq;            
           if vCount > 0 then           
               pStatus  := pkg_fifo.Status_Erro;
               pMessage := 'Erro ao desvincular carregamento.'||chr(10)||
                               'O Carregamento foi Feito pelo Coletor.';-- e se encontra Conferido ou Finalizado.';
               Return;
           end if;               
         end if;     
         
         -- Gero um veiculo virtual, Usando como paramentro o próprio carregamento por questões de peso.
         vVeicDispVirtual := pkg_fifo.fn_CriaVeicVirtual( vCarregamento);
         
         -- Deleta da T_ARM_CARREGAMENTOVEIC (Mobile utiliza)
         Select Count(*) 
           Into vCount 
          From T_ARM_CARREGAMENTOVEIC veic
          Where veic.arm_carregamento_codigo = vCarregamento;            
          If vCount > 0 Then
            Delete T_ARM_CARREGAMENTOVEIC veic
            Where veic.Arm_Carregamento_Codigo = vCarregamento;
          End If;     
          
          update  t_arm_carregamento t
           set t.fcf_veiculodisp_codigo     = vVeicDispVirtual,
               t.fcf_veiculodisp_sequencia  = '0',
               t.car_veiculo_placa          = null
           where t.arm_carregamento_codigo   = vCarregamento
             and t.fcf_veiculodisp_codigo    = vVeicDisp
             and t.fcf_veiculodisp_sequencia = vVeicSeq;
                
          --É necessarui também retirar o código do carregamento da Tabela de Veículo.
          update t_fcf_veiculodisp t
            set t.arm_carregamento_codigo = null
           where t.fcf_veiculodisp_codigo    = vVeicDisp
             and t.fcf_veiculodisp_sequencia = vVeicSeq;      
             
          Begin
            --Agora preciso de um laço de repetição para pegar todos os 
            --  Conhecimentos,QUE AINDA NÃO FORAM IMPRESSOS. para retirar o Veiculo.
            For vCursor In ( Select ctrc.con_conhecimento_codigo,
                                    ctrc.con_conhecimento_serie,
                                    ctrc.glb_rota_codigo,
                                    ctrc.arm_carregamento_codigo,
                                    viagem.con_viagem_numero,
                                    viagem.glb_rota_codigoviagem,
                                    ctrc.con_conhecimento_placa
                             from t_con_conhecimento ctrc,
                                  t_con_viagem   viagem
                             where 0=0
                               And ctrc.con_viagem_numero        = viagem.con_viagem_numero
                               and ctrc.glb_rota_codigoviagem    = viagem.glb_rota_codigoviagem
                               and nvl(ctrc.con_conhecimento_digitado, 'I') <> 'I'
                               and Trim(ctrc.arm_carregamento_codigo) = Trim(vCarregamento)
                           )
            Loop
                  
              -- retiro também os dados do Veiculo da Viagem 
              update t_con_viagem tv
                set 
                  tv.CAR_CARRETEIRO_CPFCODIGO   = null,
                  tv.CAR_CARRETEIRO_SAQUE			  = null,
                  tv.FRT_MOTORISTA_CODIGO			  = null,
                  tv.FRT_CONJVEICULO_CODIGO			= null,
                  tv.CON_VIAGEM_CPFCODIGO			  = null,
                  tv.CON_VIAGEM_CPFSAQUE			  = null,
                  tv.CON_VIAGEM_FRTMOTORISTA		= null,	
                  tv.CON_VIAGEM_CONJVEICULO			= null,
                  tv.CON_VIAGEM_PLACA			      = null,
                  tv.CON_VIAGEM_PLACASAQUE			= Null
              Where
                  tv.con_viagem_numero         = vCursor.Con_Viagem_Numero
                and tv.glb_rota_codigoviagem     = vCursor.Glb_Rota_Codigoviagem;
                    
              --Atualizo os conhecimentos retirando a placa do Veiculo dos Conhecimentos
              update t_con_conhecimento ctrc
                set ctrc.con_conhecimento_placa = Null
              where ctrc.con_conhecimento_codigo = vCursor.Con_Conhecimento_Codigo
                and ctrc.con_conhecimento_serie = vCursor.Con_Conhecimento_Serie
                and ctrc.glb_rota_codigo = vCursor.Glb_Rota_Codigo;
            End Loop;                   
              
            Commit;
            pStatus := pkg_fifo.Status_Normal;
            pMessage := 'Desvinculado com sucesso!!!';
          Exception
            When Others Then
              pStatus := pkg_fifo.Status_Erro;
              pMessage := 'Erro ao tentar desvincular o Veiculo do Carregamento.' || chr(13) || Sqlerrm || chr(13) || dbms_utility.format_call_stack;
          End;  
     Exception
       When Others Then
          pStatus := pkg_fifo.Status_Erro;
          pMessage := sqlerrm;         
     End;       
        
End Sp_DesvinculaCarregVeicDisp;

Procedure Sp_RotaPertenceArmazem(pXmlIn   In varchar2,
                                 pResult  Out Char,
                                 pStatus  Out Char,
                                 pMessage Out varchar2)
As
vArmazem t_arm_armazem.arm_armazem_codigo%type;
vRota    t_glb_rota.glb_rota_codigo%Type;
vCount Integer;
Begin

    Select trim(extractvalue(Value(V), 'Input/Armazem')),
           trim(extractvalue(Value(V), 'Input/Rota'))
          into vArmazem,
               vRota
         From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;  

    select count(*) 
     into vCount
     from t_arm_armazem ar
    where ar.arm_armazem_codigo = vArmazem
      and ((ar.glb_rota_codigo = vRota) or (ar.glb_rota_codigonf = vRota)); 
    
    if vCount > 0 then
       pResult := 'S';
    else
       pResult := 'N';
    end if;
    pStatus := 'N';
    pMessage := 'OK';     
End Sp_RotaPertenceArmazem;                          


Procedure Sp_Update_Conferecia(pUsuarioConferiu in t_usu_usuario.usu_usuario_codigo%Type,
                               pCarregamento    in t_arm_carregamento.arm_carregamento_codigo%Type,
                               pStatus  Out Char,
                               pMessage Out Varchar2)
As
Begin
    Begin
        Update t_arm_carregamento c
           set c.usu_usuario_conferiucarreg = pUsuarioConferiu,
               c.arm_carregamento_dtconferencia = sysdate
          where c.arm_carregamento_codigo = pCarregamento
            AND 0 = (SELECT COUNT(*)
                     FROM T_CON_CONHECIMENTO CTE
                     WHERE CTE.ARM_CARREGAMENTO_CODIGO = C.ARM_CARREGAMENTO_CODIGO
                       AND CTE.CON_CONHECIMENTO_DIGITADO = 'I');
        Commit;
        pStatus := 'N';
        pMessage := 'Conferido com sucesso!';
    Exception
      When Others Then
        Rollback;
        pStatus := 'E';
        pMessage := sqlerrm;
    End;
End Sp_Update_Conferecia; 

Procedure Sp_LoginConferencia(pUsuario in t_usu_usuario.usu_usuario_codigo%Type,
                              pSenha   in t_usu_usuario.usu_usuario_senha%Type,
                              pCarreg  in t_arm_Carregamento.Arm_Carregamento_Codigo%type,
                              pStatus  Out Char,
                              pMessage Out Varchar2)
As
vIsLoginValid Char(1);
Begin
    Begin
        vIsLoginValid := Pkg_Glb_Menutdv.fn_ValidaSenha(pUsuario, pSenha);
        if vIsLoginValid = 'N' then -- N -> Normal
            Sp_Update_Conferecia(pUsuario, pCarreg, pStatus, pMessage);
        else -- W ou E -> Warning ou Error
            pStatus := 'E';
            pMessage := 'Usuario ou senha invalido!';          
        end if;
    Exception
      When Others Then
        pStatus := 'E';
        pMessage := sqlerrm;
    End;
End Sp_LoginConferencia; 

Procedure Sp_GetCtrcDigManual_SemVF(pPlaca  In Varchar2,
                                    pCursor Out types.cursorType)
As
Begin
  
   Open pCursor For
    SELECT K.CON_CONHECIMENTO_CODIGO,
           K.CON_CONHECIMENTO_SERIE,
           K.GLB_ROTA_CODIGO,
           K.CON_CONHECIMENTO_DTEMBARQUE,
           K.CON_CONHECIMENTO_PLACA
      FROM T_CON_CONHECIMENTO K
     WHERE K.PRG_PROGCARGA_CODIGO    IS NULL
       AND K.CON_CONHECIMENTO_PLACA  = pPlaca
       AND K.CON_CONHECIMENTO_DTEMBARQUE BETWEEN TRUNC(SYSDATE - 180) AND TRUNC(SYSDATE)
       AND NVL(K.CON_CONHECIMENTO_FLAGCANCELADO, 'N') = 'N'
       AND 0 = (select count(*)
                  from t_con_vfreteconhec kk
                 where kk.con_conhecimento_codigo = k.con_conhecimento_codigo
                   and kk.con_conhecimento_serie  = k.con_conhecimento_serie
                   and kk.glb_rota_codigo         = k.glb_rota_codigo);
       
End Sp_GetCtrcDigManual_SemVF;      

Procedure Sp_GetCtrcDigManual_PorCTRC(pConhecCodigo  In t_Con_Conhecimento.Con_Conhecimento_Codigo%Type,
                                      pConhecSerie   In t_Con_Conhecimento.Con_Conhecimento_Serie%Type,
                                      pConhecRota    In t_Con_Conhecimento.Glb_Rota_Codigo%Type,
                                      pCursor Out types.cursorType)
As
Begin
  
   Open pCursor For
    SELECT K.CON_CONHECIMENTO_CODIGO,
           K.CON_CONHECIMENTO_SERIE,
           K.GLB_ROTA_CODIGO,
           K.CON_CONHECIMENTO_DTEMBARQUE,
           K.CON_CONHECIMENTO_PLACA,
           Case nvl(K.Con_Conhecimento_Flagcancelado,'N')
             When 'S' Then 'Sim' 
             When 'N' Then 'Não'
           end Con_Conhecimento_Flagcancelado
      FROM T_CON_CONHECIMENTO K
     WHERE K.CON_CONHECIMENTO_CODIGO = lpad(pConhecCodigo,6,'0')
       AND K.CON_CONHECIMENTO_SERIE  = pConhecSerie
       AND K.GLB_ROTA_CODIGO         = pConhecRota   
       And K.Arm_Carregamento_Codigo is null           
       AND K.CON_CONHECIMENTO_DTEMBARQUE BETWEEN TRUNC(SYSDATE - 180) AND TRUNC(SYSDATE)
       AND 0 = (select count(*)
                  from t_con_vfreteconhec kk
                 where kk.con_conhecimento_codigo = k.con_conhecimento_codigo
                   and kk.con_conhecimento_serie  = k.con_conhecimento_serie
                   and kk.glb_rota_codigo         = k.glb_rota_codigo)
       AND NVL(K.CON_CONHECIMENTO_FLAGCANCELADO, 'N') = 'N';
       
End Sp_GetCtrcDigManual_PorCTRC;   

Procedure Sp_GetCtrcDigManual_PorVeicD(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                       pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type,
                                       pCursor Out types.cursorType)
As
Begin
  
   Open pCursor For
    SELECT K.CON_CONHECIMENTO_CODIGO,
           K.CON_CONHECIMENTO_SERIE,
           K.GLB_ROTA_CODIGO,
           K.CON_CONHECIMENTO_DTEMBARQUE,
           K.CON_CONHECIMENTO_PLACA
      FROM T_CON_CONHECIMENTO K,
           t_con_veicconhec vc
     WHERE K.CON_VALEFRETE_CODIGO IS NULL
       AND K.ARM_CARREGAMENTO_CODIGO IS NULL
       AND K.PRG_PROGCARGA_CODIGO IS NULL
       AND K.CON_CONHECIMENTO_CODIGO = Vc.CON_CONHECIMENTO_CODIGO
       AND K.CON_CONHECIMENTO_SERIE  = Vc.CON_CONHECIMENTO_SERIE
       AND K.GLB_ROTA_CODIGO         = Vc.GLB_ROTA_CODIGO
       AND Vc.FCF_VEICULODISP_CODIGO = pVeicDispCodigo
       AND Vc.FCF_VEICULODISP_SEQUENCIA = pVeicDispSequencia
       AND K.CON_CONHECIMENTO_DTEMBARQUE BETWEEN TRUNC(SYSDATE - 180) AND TRUNC(SYSDATE)
       AND NVL(K.CON_CONHECIMENTO_FLAGCANCELADO, 'N') = 'N';
       
End Sp_GetCtrcDigManual_PorVeicD;  

Procedure Sp_VinculaCTRCVeicDisp(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                 pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type, 
                                 pConhecCodigo  In t_Con_Conhecimento.Con_Conhecimento_Codigo%Type,
                                 pConhecSerie   In t_Con_Conhecimento.Con_Conhecimento_Serie%Type,
                                 pConhecRota    In t_Con_Conhecimento.Glb_Rota_Codigo%Type,
                                 pUsuario       In t_con_veicconhec.usu_usuario_codigo%Type,
                                 pStatus  Out Varchar,
                                 pMessage Out Varchar2)                                 
As
vVeicDispCTRC t_con_veicconhec%RowType;
Begin
    vVeicDispCTRC.Fcf_Veiculodisp_Codigo := pVeicDispCodigo;
    vVeicDispCTRC.Fcf_Veiculodisp_Sequencia := pVeicDispSequencia;
    vVeicDispCTRC.Con_Conhecimento_Codigo := pConhecCodigo;
    vVeicDispCTRC.Con_Conhecimento_Serie := pConhecSerie;
    vVeicDispCTRC.Glb_Rota_Codigo := pConhecRota;
    vVeicDispCTRC.Usu_Usuario_Codigo := pUsuario;
    vVeicDispCTRC.Con_Veicconhec_Data := sysdate;
    
    if(Pkg_Con_Mdfeavulso.Fn_Vinc_VeicDispCTRC(vVeicDispCTRC))then
       pStatus := 'N';
       pMessage := 'Conhecimento vinculado com sucesso!!!';
    end if;
    
End Sp_VinculaCTRCVeicDisp;     

Procedure Sp_DesvinculaCTRCVeicDisp(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                    pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type, 
                                    pConhecCodigo  In t_Con_Conhecimento.Con_Conhecimento_Codigo%Type,
                                    pConhecSerie   In t_Con_Conhecimento.Con_Conhecimento_Serie%Type,
                                    pConhecRota    In t_Con_Conhecimento.Glb_Rota_Codigo%Type,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2)                                 
As
vVeicDispCTRC t_con_veicconhec%RowType;
Begin
    vVeicDispCTRC.Fcf_Veiculodisp_Codigo := pVeicDispCodigo;
    vVeicDispCTRC.Fcf_Veiculodisp_Sequencia := pVeicDispSequencia;
    vVeicDispCTRC.Con_Conhecimento_Codigo := pConhecCodigo;
    vVeicDispCTRC.Con_Conhecimento_Serie := pConhecSerie;
    vVeicDispCTRC.Glb_Rota_Codigo := pConhecRota;
    
    if(Pkg_Con_Mdfeavulso.Fn_Desvinc_VeicDispCTRC(vVeicDispCTRC))then
       pStatus := 'N';
       pMessage := 'Conhecimento desvinculado com sucesso!!!';
    end if;
    
End Sp_DesvinculaCTRCVeicDisp;   

Procedure Sp_GetCTRCTodosPorVeicDisp(pVeicDispCodigo    In t_con_veicdispvf.fcf_veiculodisp_codigo%Type,
                                     pVeicDispSequencia In t_con_veicdispvf.fcf_veiculodisp_sequencia%Type,
                                     pCursor Out types.cursorType)
As
Begin
  
   Open pCursor For
    SELECT 
           'Digitação Manual' Origem,
           K.CON_CONHECIMENTO_CODIGO,
           K.CON_CONHECIMENTO_SERIE,
           K.GLB_ROTA_CODIGO,
           K.CON_CONHECIMENTO_DTEMBARQUE,
           nvl(K.CON_CONHECIMENTO_PLACA, 'Não encontrado no Cte') CON_CONHECIMENTO_PLACA,
           --Pkg_Con_Conhecimento.Fn_Is_Transferencia(k.con_conhecimento_codigo, k.con_conhecimento_serie, k.glb_rota_codigo) Transf           
           Pkg_Con_Conhecimento.Fn_Is_TransfArmazem(k.con_conhecimento_codigo, k.con_conhecimento_serie, k.glb_rota_codigo) Transf
      FROM TDVADM.T_CON_CONHECIMENTO K,
           TDVADM.t_con_veicconhec vc,
           TDVADM.T_CON_CALCCONHECIMENTO CA,
           TDVADM.T_SLF_TPCALCULO TC
     WHERE K.CON_CONHECIMENTO_CODIGO = Vc.CON_CONHECIMENTO_CODIGO(+)
       AND K.CON_CONHECIMENTO_SERIE  = Vc.CON_CONHECIMENTO_SERIE(+)
       AND K.GLB_ROTA_CODIGO         = Vc.GLB_ROTA_CODIGO(+)
       AND K.CON_CONHECIMENTO_CODIGO = CA.CON_CONHECIMENTO_CODIGO(+)
       AND K.CON_CONHECIMENTO_SERIE  = CA.CON_CONHECIMENTO_SERIE(+)
       AND K.GLB_ROTA_CODIGO         = CA.GLB_ROTA_CODIGO(+)
       AND CA.SLF_RECCUST_CODIGO = 'I_TTPV'
       AND CA.SLF_TPCALCULO_CODIGO = TC.SLF_TPCALCULO_CODIGO
--       AND TC.SLF_TPCALCULO_FORMULARIO = 'C'
       AND Vc.FCF_VEICULODISP_CODIGO = pVeicDispCodigo
       AND Vc.FCF_VEICULODISP_SEQUENCIA = pVeicDispSequencia
       AND K.CON_CONHECIMENTO_DTEMBARQUE BETWEEN TRUNC(SYSDATE - 180) AND TRUNC(SYSDATE)
       
     Union 
    /*
     * @diegolirio 06/08/2017
     * Codigo alterado(comentado) porque Notas que vieram de transferencia nao mostrava na conferencia do ctrc, 
     *   vinculo do ctrc está no carregamento antigo e não no carregamento atual
     *   
    SELECT 'Carregamento' Origem,
           K.CON_CONHECIMENTO_CODIGO,
           K.CON_CONHECIMENTO_SERIE,
           K.GLB_ROTA_CODIGO,
           K.CON_CONHECIMENTO_DTEMBARQUE,
           nvl(K.CON_CONHECIMENTO_PLACA, 'Não encontrado no Cte') CON_CONHECIMENTO_PLACA,
           --Pkg_Con_Conhecimento.Fn_Is_Transferencia(k.con_conhecimento_codigo, k.con_conhecimento_serie, k.glb_rota_codigo) Transf
           Pkg_Con_Conhecimento.Fn_Is_TransfArmazem(k.con_conhecimento_codigo, k.con_conhecimento_serie, k.glb_rota_codigo) Transf
      FROM T_CON_CONHECIMENTO K,
           t_Arm_Carregamento ca
      where k.arm_carregamento_codigo = ca.arm_carregamento_codigo
        and ca.fcf_veiculodisp_codigo = pVeicDispCodigo
        and ca.fcf_veiculodisp_sequencia = pVeicDispSequencia
        AND K.CON_CONHECIMENTO_DTEMBARQUE BETWEEN TRUNC(SYSDATE - 180) AND TRUNC(SYSDATE)
       Order by 7;
    */

    SELECT DISTINCT
           'Carregamento' Origem,
           CO.CON_CONHECIMENTO_CODIGO,
           CO.CON_CONHECIMENTO_SERIE,
           CO.GLB_ROTA_CODIGO,
           CO.CON_CONHECIMENTO_DTEMBARQUE,
           nvl(CO.CON_CONHECIMENTO_PLACA, 'Não encontrado no Cte') CON_CONHECIMENTO_PLACA,
           --Pkg_Con_Conhecimento.Fn_Is_Transferencia(k.con_conhecimento_codigo, k.con_conhecimento_serie, k.glb_rota_codigo) Transf
           tdvadm.Pkg_Con_Conhecimento.Fn_Is_TransfArmazem(CO.con_conhecimento_codigo, CO.con_conhecimento_serie, CO.glb_rota_codigo) Transf
      FROM TDVADM.T_ARM_CARREGAMENTO C,
           TDVADM.T_ARM_CARREGAMENTODET CD,
           TDVADM.T_ARM_EMBALAGEM E,
           TDVADM.T_ARM_NOTA N,
           TDVADM.T_CON_CONHECIMENTO CO,
           TDVADM.T_CON_CALCCONHECIMENTO CA,
           TDVADM.T_SLF_TPCALCULO TC
      WHERE C.FCF_VEICULODISP_CODIGO = pVeicDispCodigo
        AND C.FCF_VEICULODISP_SEQUENCIA = pVeicDispSequencia
        AND C.ARM_CARREGAMENTO_CODIGO = CD.ARM_CARREGAMENTO_CODIGO
        AND E.ARM_CARREGAMENTO_CODIGO = CD.ARM_CARREGAMENTO_CODIGO
        AND E.ARM_EMBALAGEM_NUMERO    = N.ARM_EMBALAGEM_NUMERO
        AND E.ARM_EMBALAGEM_FLAG      = N.ARM_EMBALAGEM_FLAG
        AND E.ARM_EMBALAGEM_SEQUENCIA = N.ARM_EMBALAGEM_SEQUENCIA
        AND CO.CON_CONHECIMENTO_CODIGO= N.CON_CONHECIMENTO_CODIGO
        AND CO.CON_CONHECIMENTO_SERIE = N.CON_CONHECIMENTO_SERIE
        AND CO.GLB_ROTA_CODIGO        = N.GLB_ROTA_CODIGO
        AND CO.CON_CONHECIMENTO_CODIGO = CA.CON_CONHECIMENTO_CODIGO(+)
        AND CO.CON_CONHECIMENTO_SERIE  = CA.CON_CONHECIMENTO_SERIE(+)
        AND CO.GLB_ROTA_CODIGO         = CA.GLB_ROTA_CODIGO(+)
        AND CA.SLF_RECCUST_CODIGO = 'I_TTPV'
        AND CA.SLF_TPCALCULO_CODIGO = TC.SLF_TPCALCULO_CODIGO
--        AND TC.SLF_TPCALCULO_FORMULARIO = 'C'
        AND 0 = (SELECT COUNT(*)
                 FROM TDVADM.T_ARM_NOTACTE NC
                 WHERE NC.CON_CONHECIMENTO_CODIGO = CO.CON_CONHECIMENTO_CODIGO
                   AND NC.CON_CONHECIMENTO_SERIE = CO.CON_CONHECIMENTO_SERIE
                   AND NC.GLB_ROTA_CODIGO = CO.GLB_ROTA_CODIGO
                   AND NC.ARM_NOTACTE_CODIGO = 'CO')

      Order By 7;
            
       
End Sp_GetCTRCTodosPorVeicDisp;                        

End pkg_fifo_ctrc;
/
