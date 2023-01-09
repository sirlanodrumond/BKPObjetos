create or replace package pkg_fifo_manifesto is
/****************************************************************************************
/* Versao: 14.12.17.1
/* Ultima alteracao: Incluso o Ciot no Manifesto, proc Sp_Get_MDFe retorna o Ciot !
/***************************************************************************************/

  Param       GlbAdm.Pkg_Glb_Wsinterfacedb.TpParamXml;
  Parametros  GlbAdm.Pkg_Glb_Wsinterfacedb.TpListaParamXml;
  
  Versao Varchar2(10) := '0';
  
  TYPE NotaAgregadoType IS RECORD( Peso t_arm_nota.arm_nota_peso%Type,
                                   PesoCobrado t_arm_nota.arm_coleta_pesocobrado%type,
                                   Valor t_arm_nota.arm_nota_valormerc%type,
                                   QtdeNF number);
                              
Procedure SP_AtualizaManifA1( pGlb_processo_codigo In tdvadm.t_glb_processodet.glb_processo_codigo%Type,
                              pGlb_processodet_id In tdvadm.t_glb_processodet.glb_processodet_id%Type
                            );
                            
--------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para Transformar Manifesto da serie XXX para serie A1                                      --
--------------------------------------------------------------------------------------------------------------------
/*
Procedure SP_TransfManifesto( pXmlIn In Varchar2,
                              pStatus Out Varchar2,
                              pMessage Out Varchar2,
                              pXmlOut Out Clob
                            );
*/  

Function Fn_Get_NovoNumeroManifestoXXX return Integer;
                          
Function Fn_Contem_CTRCNaoEltronico(pVeicDisp t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                    pVeicSeq  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return Char;

Procedure Sp_Update_Impresso(pXmlIn In Varchar2,
                             pIsMDFe Out Char,
                             pStatus out Char,
                             pMessage Out Varchar2);   
                             
Procedure Sp_Update_Impresso__(pXmlIn In Varchar2,
                               pPrimeiroNumero Out t_Con_Manifesto.Con_Manifesto_Codigo%Type,  
                               pIsMDFe Out Char,
                               pStatus out Char,
                               pMessage Out Varchar2);                                
                             
function Fn_Get_NumeroManifesto(pRota in tdvadm.t_glb_rota.glb_rota_codigo%Type) return varchar2;                                                                                 
                            
Procedure Sp_Get_NumeroManifesto(pXmlIn  In  varchar2,
                                 pXmlOut Out Varchar2);
                
Procedure Sp_Insert_MDFe(pVeiculoDisp In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                         pVeiculoSeq  In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Sequencia%Type,
                         pRota        In Tdvadm.t_Glb_Rota.Glb_Rota_Codigo%Type,
                         pUsuario     In Tdvadm.t_Usu_Usuario.Usu_Usuario_Codigo%Type,
                         pStatus      Out Char,
                         pMessage     Out Varchar2,
                         pVFCiot      In Varchar2);

/*                 
Procedure Sp_Insere_MDFe(pCarregamento In Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type,
                         pRota         In Tdvadm.t_Glb_Rota.Glb_Rota_Codigo%Type,
                         pUsuario      In Tdvadm.t_Usu_Usuario.Usu_Usuario_Codigo%Type);   
*/                                                       

  Function Fn_Get_NotaAgregado(pVeiculoDisp In t_Arm_Carregamento.Fcf_Veiculodisp_Codigo%Type,
                               pVeiculoSeq  In t_Arm_Carregamento.Fcf_Veiculodisp_Sequencia%Type,
                               pUF          In Char) return NotaAgregadoType;

Function Fn_Is_MDFe(pRota in t_Glb_Rota.Glb_Rota_Codigo%Type) return Char;

PROCEDURE SP_CON_DISPMANIFESTO;

PROCEDURE SP_BUSCA_PROXIMOMANIFESTO(P_ROTA IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                    V_NUMERO OUT T_GLB_ROTA.CON_CONHECIMENTO_CODIGO%TYPE);
                               
  
  Function Fn_Manifesto_Gerado(pVeicDisp t_con_veicdispmanif.fcf_veiculodisp_codigo%Type,
                               pVeicSeq  t_con_veicdispmanif.fcf_veiculodisp_sequencia%Type) return Char;                               
                       
  Procedure Sp_Insert_Manifesto(pCarregamento In t_con_manifesto.arm_carregamento_codigo%Type,
                                pVeicDisp     In t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pVeicSeq      In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,    
                                pRota         In t_Con_Manifesto.Con_Manifesto_Rota%Type,
                                pUsuario      In t_con_manifesto.usu_usuario_codigo%Type,
                                pStatus       Out Char,
                                pMessage      Out Varchar2);  
                                
  
  Function Fn_CiotObrigatorio(pClassAntt In varchar2,
                              pClassEqp In varchar2,
                              pTipoMotorista In varchar2) return Varchar2;                                
          
  Procedure Sp_GerarManifesto(pXmlIn   In Varchar2,
                              pStatus  Out Char,
                              pMessage Out Varchar2);    
                              
  Procedure Sp_GerarManifesto(pVeicDisp in t_arm_carregamento.fcf_veiculodisp_codigo%Type,
                              pVeicSeq  in t_arm_carregamento.fcf_veiculodisp_sequencia%Type,
                              pUsuario  in t_Usu_Usuario.Usu_Usuario_Codigo%Type,
                              pRota     in t_Glb_Rota.Glb_Rota_Codigo%Type,
                              pStatus  Out Char,
                              pMessage Out Varchar2);                                                         
                              
  Procedure Sp_Get_MDfe(pXmlIn  In  Varchar2,
                        pXmlOut Out Clob ,
                        pStatus Out Char,
                        pMessage Out Varchar2);  
                        
  Procedure Sp_Get_Carregs(pXmlIn  In  Varchar2,
                           pXmlOut Out Clob ,
                           pStatus Out Char,
                           pMessage Out Varchar2);    
                           
Procedure Sp_Excluir_Manif(pManifesto Varchar2,
                           pSerie     Varchar2,
                           pRota      Varchar2);                                                
                        
  Procedure Sp_Excluir_Manifesto(pXmlIn In Varchar2,
                                 pStatus Out Char,
                                 pMessage Out Varchar2);
                                                             
  
  function Fn_ValeFreteGerado_MDFe(pManifesto Varchar2,
                                   pSerie     Varchar2,
                                   pRota      Varchar2) return Char;
                                   
  function Fn_ValeFreteGerado(pVeiculoDisp T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                              pSequencia   T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE) return Char;                                                                   
                                 
  Procedure Sp_Solicitar_Autorizacao(pXmlIn   In  Varchar2,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2);                                  

Procedure Sp_Get_StatusAutorizacao(pXmlIn In Varchar2,
                                   pXmlOut Out Clob,
                                   pStatus Out Char,
                                   pMessage Out Varchar2);  

Procedure Sp_Get_StatusAutorizacaoPlaca(pXmlIn In Varchar2,
                                        pXmlOut Out Clob,
                                        pStatus Out Char,
                                        pMessage Out Varchar2);
                                   
Procedure Sp_CancelarMDFe(pXmlIn   In  Varchar2,
                          pStatus  Out Char,
                          pMessage Out Varchar2) ;        

                          
Procedure Sp_Volta_AutorizacaoChave(pChave In Varchar2,
                                    pStatus Out Char,
                                    pMessage Out Varchar2);                          
                          
Procedure Sp_Volta_Autorizacao(pManifesto Varchar2,
                               pSerie     Varchar2,
                               pRota      Varchar2,
                               pStatus Out Char,
                               pMessage Out Varchar2);  
                               
Function Fn_Validos_CTRC_MDFe(pVeiculoDisp T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                              pSequencia   T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE) return Char;                               
                                 
                               
Procedure Sp_Get_ValeFrete(pXmlIn   In Varchar2,
                           pXmlOut  Out Clob,
                           pStatus  Out Char,
                           pMessage Out varchar2) ;  
                           
  Procedure Sp_Exclui_MDFeControleEnvio(pXmlIn   In Varchar2,
                                        pXmlOut  Out Clob,
                                        pStatus  Out Char,
                                        pMessage Out Varchar2);                                                                                                                                                                                                                                   

  Function Fn_ValidaGeracaoMDFeComNFS(pVeiculoDisp In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                      pVeiculoSeq  In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Sequencia%Type) return Char;

  procedure sp_ExecutaSelect(pCursor out tdvadm.pkg_glb_common.t_cursor);

end pkg_fifo_manifesto;

 
/
CREATE OR REPLACE package Body pkg_fifo_manifesto is
 --Variaveis utilizadas para administrac?o de excec?es.
 vEx_Select Exception;
 vEx_Cursor Exception;
       
--------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar dados do manifesto Serie XXX                                                --
--------------------------------------------------------------------------------------------------------------------
/* Comentado por Diego Lirio, somente gernado warnings

Procedure SP_Get_ManifestoXXX( pXmlIn In Varchar2,
                               pStatus Out Varchar2,
                               pMessage Out Varchar2,
                               pXmlOut Out Clob
                             ) As

Begin
  pstatus := 'N';  
End;
*/


--------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para Transformar Manifesto da serie XXX para serie A1                                      --
--------------------------------------------------------------------------------------------------------------------
/* Comentado por Diego Lirio, somente gernado warnings
Procedure SP_TransfManifesto( pXmlIn In Varchar2,
                              pStatus Out Varchar2,
                              pMessage Out Varchar2,
                              pXmlOut Out Clob
                            ) As
Begin
  
  pstatus := 'N';
  pMessage := 'Procedure em desenvolvimento';
  
End SP_TransfManifesto;                             
*/
--------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para passar todos os manifestos de um mesmo veiculos para serie A1,                        -- 
-- evitando que o usuario tenha que imprimir todos os documentos                                                  --
--------------------------------------------------------------------------------------------------------------------
Procedure SP_AtualizaManifA1( pGlb_processo_codigo In tdvadm.t_glb_processodet.glb_processo_codigo%Type,
                              pGlb_processodet_id In tdvadm.t_glb_processodet.glb_processodet_id%Type
                            ) As

 -- Variavel utilizada para recuperar dados da execuc?o
 vProcessoDet tdvadm.t_glb_processodet%Rowtype;
 
 --Variavel utilizada para recuperar / criar mensagens
 vMessage Varchar2(20000);
 
 --Variavel utilizada para recuperar o numero atual de manifesto.
 vCon_manifesto_codigo tdvadm.t_glb_rota.con_manifesto_codigo%Type;
 
 --Variavel de controle
 vControl Integer;
 
 vTerminal    v_glb_ambiente.terminal%type;
 vPrograma    v_glb_ambiente.PROGRAM%type;
 vOsUser      v_glb_ambiente.os_user%type;
 
 
Begin
  

  
  
  -- Klayton e Diego em 07/06/2013
  begin
    
    SELECT A.terminal,
           A.PROGRAM,
           A.os_user
      INTO vTerminal,
           vPrograma,
           vOsUser
      FROM V_GLB_AMBIENTE A;      
      
--    insert into dropme(x,a) values ('pkg_fifo_manifesto','vTerminal: '||vTerminal||' - vPrograma: '||vPrograma||' - vPrograma: '||vOsUser);
--    COMMIT;
  end;  
  
  
  
  --Inicializa as variaveis que ser?o utilizadas nessa procedure.
  vMessage := '';
  vControl := 0;
  
  Begin
    --Recupero os dados do processo
    Begin
      Select * Into vProcessoDet From t_glb_processodet proc
      Where proc.glb_processo_codigo = pGlb_processo_codigo
       And proc.glb_processodet_id = pGlb_processodet_id;
    
    Exception
      When no_data_found Then
        vMessage := ' Nao encontrei registro para o processo: ' || pGlb_processo_codigo || ' com ID: ' || pGlb_processodet_id;
        Raise vEx_Select;
    End;   
    
    Begin
      --Recupero o numero atual do manifesto.
      Select rota.con_manifesto_codigo 
      Into vCon_manifesto_codigo 
      From t_glb_rota rota
      Where rota.glb_rota_codigo = vProcessoDet.Glb_Processodet_Rota For Update;
    Exception
      When Others Then
        vMessage := 'Erro ao tentar recuperar codigo do ultimo manifesto valido. ' || chr(10) ||
                    'Erro ora: ' || Sqlerrm;
        Raise vEx_Select;
    End;   
    
    ------------------------------------------------------------------------------------------------------------------------
    -- A partir do Codigo do manifesto, vou buscar o numero do carregamento.                                              --
    -- A partir do Codigo do Carregamento, vou buscar o veiculo disponivel vinculado.                                     --
    -- A partir do Veiculo Disponivel vinculado, vou buscar todos os outros carregamentos vinculados a esse veiculo       --
    -- A partir da lista de carregamentos, vou buscar a lista de manifestos n?o impressos, e atualiza-los para serie A1.  --
    ------------------------------------------------------------------------------------------------------------------------
    For vCursor In ( Select m2.con_manifesto_codigo,
                            m2.con_manifesto_serie,
                            m2.con_manifesto_rota
                      From t_con_manifesto m2
                      Where 0=0
                        And m2.con_manifesto_serie = 'XXX'
                        And 0 < ( Select Count(*) From t_arm_carregamento c2
                                  Where 0=0
                                    And c2.arm_carregamento_codigo = m2.arm_carregamento_codigo
                                    And 0 < ( Select Count(*) From t_arm_carregamento c1
                                              Where 0=0
                                              And c2.fcf_veiculodisp_codigo = c1.fcf_veiculodisp_codigo
                                              And c2.fcf_veiculodisp_sequencia = c1.fcf_veiculodisp_sequencia
                                              And 0 < ( Select Count(*) From t_con_manifesto m1
                                                        Where m1.con_manifesto_codigo = vProcessoDet.Glb_Processodet_Codigo
                                                          And m1.con_manifesto_serie = vProcessoDet.Glb_Processodet_Serie
                                                          And m1.con_manifesto_rota = vProcessoDet.Glb_Processodet_Rota
                                                          And m1.arm_carregamento_codigo = c1.arm_carregamento_codigo
                                                      ))) ) Loop
                                                     
      --Incremento a variavel de controle
      vControl := vControl +1;
      
      --Incremento a variavel con o novo numero do manifesto;
      vCon_manifesto_codigo := lpad(vCon_manifesto_codigo +1, 6, '0');
      
      --Passo o manifesto corrente para a serie A1
      Update t_con_manifesto ma
        Set ma.con_manifesto_serie = 'A0', -- Aqui Diego alterou para A0
            ma.con_manifesto_codigo = vCon_manifesto_codigo
      Where ma.con_manifesto_codigo = vCursor.Con_Manifesto_Codigo
        And ma.con_manifesto_serie = vCursor.Con_Manifesto_Serie
        And ma.con_manifesto_rota = vCursor.Con_Manifesto_Rota;
        
    End Loop;             
    
    --Fora do laco, verifico se a variavel de control foi incrementada algum vez.
    If ( vControl = 0 ) Then
      --Caso n?o tenha sido encrementada, define uma mensagem
      vMessage := 'Cursor n?o encontrou nenhum registro.';
      Raise vEx_Cursor;
    End If;
    
    --Fora do laco, atualizo a tabela de rota, passando o ultimo numero de manifesto
    Update t_glb_rota rota
      Set rota.con_manifesto_codigo = vCon_manifesto_codigo
    Where rota.glb_rota_codigo = vProcessoDet.Glb_Processodet_Rota;
    
    --salvo todas as alterac?es realizadas.
    Commit;
    
    --Atualizo a tabela que administra a execuc?o do processo
    Update t_glb_processodet det
      Set det.glb_status_codigo = '05', --Finalizado com sucesso.
          det.glb_processodet_obs = vMessage
    Where 0=0
      And det.glb_processo_codigo = pGlb_processo_codigo
      And det.glb_processodet_id = pGlb_processodet_id;
    
  Exception
    --Nenhum registro de carregamento para ser impresso
    When vEx_Cursor Then
      --ativo o rollback, para liberar a tabela de rota, caso tenha sido executada apos o fechamento do loop;
      Rollback;

      --Atualiza a tabela que administra a execuc?o do processo
      Update t_glb_processodet det
        Set det.glb_status_codigo = '19', --Erro
            det.glb_processodet_obs = vMessage
      Where 0=0
        And det.glb_processo_codigo = pGlb_processo_codigo
        And det.glb_processodet_id = pGlb_processodet_id;
      
      
    --erro de busca
    When vEx_Select Then
      --Atualiza a tabela que administra a execuc?o do processo
      Update t_glb_processodet det
        Set det.glb_status_codigo = '02', --Erro
            det.glb_processodet_obs = vMessage
      Where 0=0
        And det.glb_processo_codigo = pGlb_processo_codigo
        And det.glb_processodet_id = pGlb_processodet_id;
    
    --Ocorrendo algum erro n?o esperado.
    When Others Then
      --Rolback para desfazer possiveis atualizac?es, e liberar a tabela de rota.
      Rollback;
      
      --Atualiza a tabela que administra a execuc?o do processo
      vMessage := Sqlerrm;
      Update t_glb_processodet det
        Set det.glb_status_codigo = '02', --Erro
            det.glb_processodet_obs = 'Erro ora: ' || vMessage
      Where 0=0
        And det.glb_processo_codigo = pGlb_processo_codigo
        And det.glb_processodet_id = pGlb_processodet_id;
  End;
  
End;  
                             
  
Procedure Sp_Update_Impresso(pXmlIn In Varchar2,
                             pIsMDFe Out Char,
                             pStatus out Char,
                             pMessage Out Varchar2)
/* ##########################################################################################
 ToDo...: Realizar Um Copy na t_con_manifesto, depois dar um update na t_con_veicdispmanif
           para serie A1/A0
 ##########################################################################################*/
-- Analista: Diego Lirio
-- Criado: 07/06/2013
-- Funcionalidade: Alterar Manifesto para impresso!                             
As
v_codigo_manifesto_update tdvadm.t_con_manifesto.con_manifesto_codigo%Type;
v_codigo_manifesto_atual tdvadm.t_con_manifesto.con_manifesto_codigo%Type;
v_usuario_imprimiu varchar2(10);
v_rota char(3);
v_serie char(2);
/* 
v_carreg t_arm_carregamento.arm_carregamento_codigo%Type;
v_veicDisp t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
v_veicSeq t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type;
*/

/*vRowManifesto t_con_manifesto%RowType;*/

Begin

    Select extractvalue(Value(V), 'Input/CodigoManifestoUpdate'),
           extractvalue(Value(V), 'Input/CodigoManifestoAtual'),
           extractvalue(Value(V), 'Input/Usuario'),
           extractvalue(Value(V), 'Input/Rota')
          into v_codigo_manifesto_update,
               v_codigo_manifesto_atual,
               v_usuario_imprimiu,
               v_rota
         From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V; 
                
   pIsMDFe := 'N';  
   if pIsMDFe = 'S' then
     v_serie := 'A0';
   else
     v_serie := 'A0';     
   end if;     
   /* 
    Select m.arm_carregamento_codigo
        Into v_carreg
        From T_CON_MANIFESTO m
         WHERE m.CON_MANIFESTO_CODIGO = v_codigo_manifesto_atual
           AND m.CON_MANIFESTO_SERIE = 'XXX'
           AND m.CON_MANIFESTO_ROTA = v_rota;   
    */           

   Begin               
        
/*         Select *
           Into vRowManifesto
           From t_con_manifesto m
           where m.con_manifesto_codigo = v_codigo_manifesto_atual;*/
       
--           insert into dropme(x,a) values ('Update_Manif',v_codigo_manifesto_update);
                       
               UPDATE T_CON_MANIFESTO
                  SET CON_MANIFESTO_CODIGO = v_codigo_manifesto_update,
                      CON_MANIFESTO_SERIE = v_serie,
                      CON_MANIFESTO_USUARIO_IMPRESSO = v_usuario_imprimiu
                WHERE CON_MANIFESTO_CODIGO = v_codigo_manifesto_atual
                  AND CON_MANIFESTO_SERIE = 'XXX'
                  AND CON_MANIFESTO_ROTA = v_rota;
               Commit;
       
               -- Imprime agora.... ('S' -> usado para manifesto n?o eletronico)
               pStatus := 'N';
               pMessage := 'OK';
               
               /*                       
               select c.fcf_veiculodisp_codigo,
                      c.fcf_veiculodisp_sequencia
                  into v_veicDisp,  
                       v_veicSeq
                  from t_arm_carregamento c
                  where c.arm_carregamento_codigo = v_carreg;                     
                      
               for manif in ( select *
                                from t_con_manifesto m
                                where m.arm_carregamento_codigo in (select c.arm_carregamento_codigo
                                                                      from t_arm_carregamento c
                                                                      where c.fcf_veiculodisp_codigo = v_veicDisp
                                                                        and c.fcf_veiculodisp_sequencia = v_veicSeq)
                                  and m.con_manifesto_serie = 'XXX')
               Loop                     
                   UPDATE T_CON_MANIFESTO
                      SET CON_MANIFESTO_CODIGO = Tdvadm.pkg_fifo_manifesto.Fn_Get_NumeroManifesto(v_rota),
                          CON_MANIFESTO_SERIE = v_serie,
                          CON_MANIFESTO_USUARIO_IMPRESSO = v_usuario_imprimiu
                    WHERE CON_MANIFESTO_CODIGO = manif.con_manifesto_codigo
                      AND CON_MANIFESTO_SERIE = 'XXX'
                      AND CON_MANIFESTO_ROTA = manif.con_manifesto_rota;                       
               End Loop;                                
               Commit;     
               */                                   
   Exception
     When Others Then
       pStatus := 'E';
       pMessage := sqlerrm;
       Rollback;
   End;  
End Sp_Update_Impresso;    

Function Fn_Contem_CTRCNaoEltronico(pVeicDisp t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                    pVeicSeq  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return Char
As
vCount Integer;
Begin                                    
        Select count(*)
          Into vCount
          From t_arm_carregamento c,
               t_con_conhecimento co
          where 0=0
            and c.arm_carregamento_codigo = co.arm_carregamento_codigo
            and c.fcf_veiculodisp_codigo = pVeicDisp
            and c.fcf_veiculodisp_sequencia = pVeicSeq
            and Tdvadm.Pkg_Con_Cte.FN_CTE_EELETRONICO(co.Con_Conhecimento_Codigo,co.Con_Conhecimento_Serie,co.Glb_Rota_Codigo) = 'N';                
        if vCount > 0 then
          return 'S';
        else
          return 'N';
        end if;            
End Fn_Contem_CTRCNaoEltronico;               

Function Fn_Get_NovoNumeroManifestoXXX return Integer
As
Begin
    return LPAD(CON_MANIFESTO_SEQUENCIA.NEXTVAL, 6, 0);
End Fn_Get_NovoNumeroManifestoXXX;

Procedure Sp_Update_Impresso__(pXmlIn In Varchar2,
                               pPrimeiroNumero Out t_Con_Manifesto.Con_Manifesto_Codigo%Type,
                               pIsMDFe Out Char,
                               pStatus out Char,
                               pMessage Out Varchar2)
/* ##########################################################################################
 ToDo...: Realizar Um Copy na t_con_manifesto, depois dar um update na t_con_veicdispmanif
           para serie A1/A0
 ##########################################################################################*/
-- Analista: Diego Lirio
-- Criado: 07/06/2013
-- Funcionalidade: Alterar Manifesto para impresso!                             
As
v_codigo_manifesto_update tdvadm.t_con_manifesto.con_manifesto_codigo%Type;
v_codigo_manifesto_atual tdvadm.t_con_manifesto.con_manifesto_codigo%Type;
v_usuario_imprimiu varchar2(10);
v_rota char(3);
v_serie char(2);
/*
v_carreg t_arm_carregamento.arm_carregamento_codigo%Type;
*/
v_veicDisp t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
v_veicSeq t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type;
vRowManifesto t_con_manifesto%RowType;
v_novo_numero char(1) := 'S';

vCount___ Number;
Begin

    Select extractvalue(Value(V), 'Input/CodigoManifestoUpdate'),
           extractvalue(Value(V), 'Input/CodigoManifestoAtual'),
           extractvalue(Value(V), 'Input/Usuario'),
           extractvalue(Value(V), 'Input/Rota')
          into v_codigo_manifesto_update,
               v_codigo_manifesto_atual,
               v_usuario_imprimiu,
               v_rota
         From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V; 
                
    pIsMDFe := 'N';  
    if pIsMDFe = 'S' then
      v_serie := 'A0';
    else
      v_serie := 'A0';     
    end if;     
     
    Select v.fcf_veiculodisp_codigo,
           v.fcf_veiculodisp_sequencia
      Into v_veicDisp,
           v_veicSeq     
      From t_con_veicdispmanif v
      where v.con_manifesto_codigo = v_codigo_manifesto_atual
        and v.con_manifesto_serie  = 'XXX'
        and v.con_manifesto_rota   = v_rota;
   
/*    Select m.arm_carregamento_codigo
        Into v_carreg
        From T_CON_MANIFESTO m
         WHERE m.CON_MANIFESTO_CODIGO = v_codigo_manifesto_atual
           AND m.CON_MANIFESTO_SERIE = 'XXX'
           AND m.CON_MANIFESTO_ROTA = v_rota;      */            

   Begin               
      
/*      For l in ( select m.*
                    From t_con_veicdispmanif v,
                         t_con_manifesto m
                    where v.fcf_veiculodisp_codigo = v_veicDisp
                      and v.fcf_veiculodisp_sequencia = v_veicSeq
                      and v.con_manifesto_codigo = m.con_manifesto_codigo
                      and v.con_manifesto_serie  = m.con_manifesto_serie
                      and v.con_manifesto_rota   = m.con_manifesto_rota )*/
      For l in ( select m.*
                   from t_con_manifesto m,
                        t_arm_carregamento c
                   where m.arm_carregamento_codigo  = c.arm_carregamento_codigo
                     and c.fcf_veiculodisp_codigo = v_veicDisp
                     and c.fcf_veiculodisp_sequencia = v_veicSeq
                     and m.con_manifesto_serie = 'XXX')                      
          -- no Manifesto com aquele veiculo para alterar todos...
      Loop

         Select Count(*)
           Into vCount___
           From t_con_manifesto m
           where trim(m.con_manifesto_codigo) = Trim(l.con_manifesto_codigo)
             and trim(m.con_manifesto_serie)  = 'XXX'
             and trim(m.con_manifesto_rota) = trim(v_rota);
        
/*         Select *
           Into vRowManifesto
           From t_con_manifesto m
           where trim(m.con_manifesto_codigo) = Trim(l.con_manifesto_codigo)
             and trim(m.con_manifesto_serie)  = 'XXX'
             and trim(m.con_manifesto_rota) = trim(v_rota);*/
             
         v_codigo_manifesto_update := Fn_Get_NumeroManifesto(v_rota);    
         
         if v_novo_numero = 'S' then    
             pPrimeiroNumero := v_codigo_manifesto_update;
         end if;         
         v_novo_numero := 'N';
           
         insert into t_con_manifesto 
                           Values( v_codigo_manifesto_update
                                  ,v_serie    
                                  ,l.Con_Manifesto_Rota
                                  ,l.usu_usuario_codigo
                                  ,v_usuario_imprimiu
                                  ,l.con_manifesto_placa
                                  ,l.con_manifesto_placasaque
                                  ,l.con_manifesto_dtemissao
                                  ,l.con_manifesto_pesonf
                                  ,vRowManifesto.con_manifesto_pesocobrado
                                  ,l.con_manifesto_vlrmercadoria
                                  ,l.con_manifesto_vlrfrete
                                  ,l.con_manifesto_obs
                                  ,l.con_manifesto_cpfmotorista
                                  ,l.con_manifesto_cubagemtotal
                                  ,l.con_manifesto_dtcriacao
                                  ,l.car_tpveiculo_codigo
                                  ,l.con_manifesto_quantitensnf
                                  ,l.glb_tpmotorista_codigo
                                  ,l.con_manifesto_status
                                  ,l.con_manifesto_destinatario
                                  ,l.glb_tpcliend_codigo
                                  ,l.arm_armazem_codigo
                                  ,l.con_manifesto_dtchegada
                                  ,l.con_manifesto_dtrecebimento
                                  ,l.con_manifesto_avarias
                                  ,l.con_manifesto_dtchegcelula
                                  ,l.con_manifesto_dtcheckin
                                  ,l.con_manifesto_dtgravcheckin
                                  ,l.arm_carregamento_codigo
                                  ,l.con_manifesto_localidade
                                  ,l.con_manifesto_ufdestino,
                                   l.con_manifesto_codciot);                       
/*               
               UPDATE T_CON_MANIFESTO
                  SET CON_MANIFESTO_CODIGO = v_codigo_manifesto_update,
                      CON_MANIFESTO_SERIE = v_serie,
                      CON_MANIFESTO_USUARIO_IMPRESSO = v_usuario_imprimiu
                WHERE CON_MANIFESTO_CODIGO = v_codigo_manifesto_atual
                  AND CON_MANIFESTO_SERIE = 'XXX'
                  AND CON_MANIFESTO_ROTA = v_rota;
*/                  
                  
               Update t_con_veicdispmanif v
                   set v.con_manifesto_codigo = v_codigo_manifesto_update,
                       v.con_manifesto_serie = v_serie
                   where v.con_manifesto_codigo = l.con_manifesto_codigo --v_codigo_manifesto_atual
                     and v.con_manifesto_serie = 'XXX'
                     and v.con_manifesto_rota = v_rota;   
                   
               Delete from t_con_manifesto mm
                  where mm.con_manifesto_codigo = l.con_manifesto_codigo --v_codigo_manifesto_atual
                    and mm.con_manifesto_serie = 'XXX'
                    and mm.con_manifesto_rota = v_rota;                      
         
      End Loop;     
      Commit;       
      
       -- Imprime agora.... ('S' -> usado para manifesto n?o eletronico)
       pStatus := 'N';
       pMessage := 'OK';               
       /*                       
       select c.fcf_veiculodisp_codigo,
              c.fcf_veiculodisp_sequencia
          into v_veicDisp,  
               v_veicSeq
          from t_arm_carregamento c
          where c.arm_carregamento_codigo = v_carreg;                     
                      
           for manif in ( select *
                            from t_con_manifesto m
                            where m.arm_carregamento_codigo in (select c.arm_carregamento_codigo
                                                                  from t_arm_carregamento c
                                                                  where c.fcf_veiculodisp_codigo = v_veicDisp
                                                                    and c.fcf_veiculodisp_sequencia = v_veicSeq)
                              and m.con_manifesto_serie = 'XXX')
           Loop                     
               UPDATE T_CON_MANIFESTO
                  SET CON_MANIFESTO_CODIGO = Tdvadm.pkg_fifo_manifesto.Fn_Get_NumeroManifesto(v_rota),
                      CON_MANIFESTO_SERIE = v_serie,
                      CON_MANIFESTO_USUARIO_IMPRESSO = v_usuario_imprimiu
                WHERE CON_MANIFESTO_CODIGO = manif.con_manifesto_codigo
                  AND CON_MANIFESTO_SERIE = 'XXX'
                  AND CON_MANIFESTO_ROTA = manif.con_manifesto_rota;                       
           End Loop;                                
           Commit;     
           */                                   
   Exception
     When Others Then
       pStatus := 'E';
       pMessage := sqlerrm;
       Rollback;
   End;  
   
   --Rollback;
   
End Sp_Update_Impresso__;   

function Fn_Get_NumeroManifesto(pRota in tdvadm.t_glb_rota.glb_rota_codigo%Type) return varchar2
  As
  vCodigo t_glb_rota.con_manifesto_codigo%type;
  Begin    
/*        
    select To_number(r.con_manifesto_codigo)+1
       into vCodigo
       FROM T_GLB_ROTA  r
       WHERE r.Glb_Rota_Codigo = pRota;       
    
    Update t_glb_rota r
      set r.con_manifesto_codigo = vCodigo
     where r.glb_rota_codigo = pRota;
    commit;      
*/   
    if 'S' = pkg_fifo_manifesto.Fn_Is_MDFe(pRota) then
       SP_BUSCA_PROXIMOMANIFESTO(pRota, vCodigo); --Fn_Get_NumeroManifesto(vRota);
    else
      SELECT LPad(To_Number(NVL(con_manifesto_codigo,0))+1,6, '0') NRMANIFESTO
         Into vCodigo
        FROM T_GLB_ROTA
        WHERE GLB_ROTA_CODIGO = pRota;

     UPDATE T_GLB_ROTA
          SET CON_MANIFESTO_CODIGO = vCodigo
        where glb_rota_codigo = pRota;
     Commit;      
    end if;
   /*
      SELECT LPad(To_Number(NVL(con_manifesto_codigo,0))+1,6, '0') NRMANIFESTO
         Into vCodigo
        FROM T_GLB_ROTA
        WHERE GLB_ROTA_CODIGO = pRota;

     UPDATE T_GLB_ROTA
          SET CON_MANIFESTO_CODIGO = vCodigo
        where glb_rota_codigo = pRota;
     Commit;
   */
       
      return LPad(To_Number(NVL(vCodigo,0)),6, '0');

  End Fn_Get_NumeroManifesto;

Procedure Sp_Get_NumeroManifesto(pXmlIn  In  varchar2,
                                 pXmlOut Out Varchar2)
-- Analista: Diego Lirio
-- Criado: 11/06/2013
-- Funcionalidade: Pega Numero do Manifesto quebrando por Rota(com xml de entrada e saida).                                 
  As
  vRota t_Glb_Rota.Glb_Rota_Codigo%Type;
  vNumero t_Glb_Rota.Con_Manifesto_Codigo%Type;
  Begin
      vRota := Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( pXmlIn,  'Rota' ); 
      vNumero := Fn_Get_NumeroManifesto(pRota => vRota);
      
      Param.ParamName  := 'Codigo';
      Param.ParamValue := vNumero;
      Parametros(1)    := Param;  
      
      pXmlOut := GlbAdm.Pkg_Glb_Wsinterfacedb.Fn_GeraXmlParams( Parametros );      
      
End Sp_Get_NumeroManifesto;

Procedure Sp_Insert_MDFe(pVeiculoDisp In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                         pVeiculoSeq  In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Sequencia%Type,
                         pRota        In Tdvadm.t_Glb_Rota.Glb_Rota_Codigo%Type,
                         pUsuario     In Tdvadm.t_Usu_Usuario.Usu_Usuario_Codigo%Type,
                         pStatus      Out Char,
                         pMessage     Out Varchar2,
                         pVFCiot      In Varchar2)
As
  v_sequencia Integer;
  vUF_aux Char(2);
  nf_agregado NotaAgregadoType;

  v_tp_motorista CHAR(1);
  v_placa         VARCHAR2(50);
  v_saque         VARCHAR2(50);
  v_frota         VARCHAR2(50);
  v_cpf           VARCHAR2(50);
  v_flag_virtual  CHAR(1);  
  mensagen        varchar2(50);
Begin
  
  Begin
        vUF_aux := 'XX';
        
        For dest in ( SELECT Distinct
                             --LO.GLB_LOCALIDADE_CODIGOIBGE,
                             --Lo.Glb_Estado_Codigo UF,
                             Case 
                                when carreg_det.arm_armazem_codigo_transf is not null 
                                  then Glbadm.Pkg_Arm_Armazem.Fn_Get_UfArmazem(carreg_det.arm_armazem_codigo_transf)                  
                                else Lod.Glb_Estado_Codigo
                             End UF,
                             ca.arm_carregamento_codigo carregamento,
                             co.con_conhecimento_codigo conhecimento,
                             co.con_conhecimento_serie  conhec_serie,
                             co.glb_rota_codigo conhec_rota
                             --Lo.Glb_Localidade_Codigo Localidade_Codigo
                             --nt.arm_nota_numero nota,
                             --nt.glb_cliente_cgccpfremetente cnpj,
                             --carreg_det.arm_carregamento_codigo
                        FROM TDVADM.T_ARM_EMBALAGEM E,
                             TDVADM.T_ARM_CARGADET CD,
                             TDVADM.T_ARM_NOTA NT,
                             TDVADM.T_GLB_CLIEND CE,
                             TDVADM.T_GLB_LOCALIDADE LO,
                             TDVADM.T_ARM_ARMAZEM A,
                             Tdvadm.t_Arm_Carregamentodet carreg_det,
                             Tdvadm.t_Arm_Carregamento ca,
                             tdvadm.t_con_conhecimento co,
                             TDVADM.T_GLB_LOCALIDADE lod
                       WHERE E.ARM_EMBALAGEM_NUMERO    = CD.ARM_EMBALAGEM_NUMERO
                         AND E.ARM_EMBALAGEM_FLAG      = CD.ARM_EMBALAGEM_FLAG
                         AND E.ARM_EMBALAGEM_SEQUENCIA = CD.ARM_EMBALAGEM_SEQUENCIA           
                         AND CD.ARM_NOTA_NUMERO        = NT.ARM_NOTA_NUMERO    
                         AND CD.ARM_NOTA_SEQUENCIA     = NT.ARM_NOTA_SEQUENCIA          
                         AND RPAD(NT.GLB_CLIENTE_CGCCPFDESTINATARIO,20) = CE.GLB_CLIENTE_CGCCPFCODIGO
                         AND NT.GLB_TPCLIEND_CODDESTINATARIO = CE.GLB_TPCLIEND_CODIGO           
                         AND CE.GLB_LOCALIDADE_CODIGO = LO.GLB_LOCALIDADE_CODIGO
                         AND NT.ARM_ARMAZEM_CODIGO = A.ARM_ARMAZEM_CODIGO
                         AND E.ARM_EMBALAGEM_NUMERO    = carreg_det.arm_embalagem_numero
                         AND E.ARM_EMBALAGEM_SEQUENCIA = carreg_det.arm_embalagem_sequencia
                         AND E.ARM_EMBALAGEM_FLAG      = carreg_det.arm_embalagem_flag
                         And carreg_det.arm_carregamento_codigo = ca.arm_carregamento_codigo
                         And co.arm_carregamento_codigo = ca.arm_carregamento_codigo
                         
                         and nt.con_conhecimento_codigo = co.con_conhecimento_codigo
                         and nt.con_conhecimento_serie  = co.con_conhecimento_serie
                         and nt.glb_rota_codigo         = co.glb_rota_codigo                            
                         
                         and ca.fcf_veiculodisp_codigo = pVeiculoDisp --'1774874' 
                         and ca.fcf_veiculodisp_sequencia = pVeiculoSeq --'0'
                         and 'NF' != TDVADM.f_busca_conhec_tpformulario(co.con_conhecimento_codigo, co.con_conhecimento_serie, co.glb_rota_codigo)
                         -- Klayton em 18/02/2016 pois estava problema nas transferencias
                         --and co.glb_localidade_codigodestino = lod.glb_localidade_codigo
                         and co.con_conhecimento_localentrega = lod.glb_localidade_codigo
                   
                         -- Alterac?o: MDF com ciot:
                         -- obs: Add Union para CTRCs Sem embalagem(dig manual) para gerar MDF.
                         -- Analista: Diego - Data: 08/01/2015                          
                        
                   Union                         
                                                     
                        Select lo.Glb_Estado_Codigo UF,
                               null carregamento,
                               co.con_conhecimento_codigo conhecimento,
                               co.con_conhecimento_serie  conhec_serie,
                               co.glb_rota_codigo conhec_rota
                                  
                          From t_con_veicconhec v,
                               t_con_conhecimento co,
                               t_glb_localidade lo
                          where v.fcf_veiculodisp_codigo = pVeiculoDisp 
                            and v.fcf_veiculodisp_sequencia = pVeiculoSeq                   
                            and v.con_conhecimento_codigo = co.con_conhecimento_codigo
                            and v.con_conhecimento_serie  = co.con_conhecimento_serie
                            and v.glb_rota_codigo         = co.glb_rota_codigo
                            -- Klayton em 18/02/2016 pois estava problema nas transferencias
                            -- and co.glb_localidade_codigodestino = lo.glb_localidade_codigo                         
                            and co.con_conhecimento_localentrega = lo.glb_localidade_codigo                         
                            and 'NF' != TDVADM.f_busca_conhec_tpformulario(co.con_conhecimento_codigo, co.con_conhecimento_serie, co.glb_rota_codigo) 
                        
                       Order by UF)
          Loop        
            
                  mensagen := '1';
                  nf_agregado := Fn_Get_NotaAgregado(pVeiculoDisp, pVeiculoSeq, dest.uf);
                  
                  if vUF_aux != dest.uf then
                      
                        mensagen := '2';
                        SELECT D.FCF_VEICULODISP_FLAGVIRTUAL,
                               D.FRT_CONJVEICULO_CODIGO,
                               D.CAR_CARRETEIRO_CPFCODIGO,
                               D.CAR_VEICULO_PLACA,
                               D.CAR_CARRETEIRO_SAQUE
                          Into v_flag_virtual,
                               v_frota,
                               v_cpf,
                               v_placa,
                               v_saque     
                          FROM T_FCF_VEICULODISP D
                         WHERE D.FCF_VEICULODISP_CODIGO = pVeiculoDisp
                           AND D.FCF_VEICULODISP_SEQUENCIA = pVeiculoSeq;    
                       mensagen := '3';    
                       if v_frota is not null then
                            v_tp_motorista := 'F';
                            Begin
                                SELECT MO.FRT_MOTORISTA_CPF CPF
                                  INTO v_cpf
                                  FROM T_FRT_CONJUNTO C, 
                                       T_FRT_CONJVEICULO CC, 
                                       T_FRT_MOTORISTA MO
                                 WHERE C.FRT_CONJVEICULO_CODIGO = CC.FRT_CONJVEICULO_CODIGO
                                   AND C.FRT_MOTORISTA_CODIGO = MO.FRT_MOTORISTA_CODIGO
                                   AND CC.FRT_CONJVEICULO_CODIGO = v_frota
                                   AND ROWNUM = 1
                                 GROUP BY MO.FRT_MOTORISTA_CPF;           
                                
                                 v_placa := v_frota;
                                 v_saque := '';
                            Exception
                              When Others Then
                                 v_cpf := null;   
                            End;  
                       end if;                                           
                  
                       v_sequencia := pkg_fifo_manifesto.Fn_Get_NovoNumeroManifestoXXX();
                                            
                        Insert into 
                        tdvadm.t_Con_Manifesto mdfe (mdfe.con_manifesto_codigo,
                                                     mdfe.con_manifesto_serie,
                                                     mdfe.con_manifesto_rota,
                                                     mdfe.con_manifesto_dtcriacao,
                                                     mdfe.usu_usuario_codigo,
                                                     mdfe.con_manifesto_pesonf,
                                                     mdfe.con_manifesto_pesocobrado,
                                                     mdfe.con_manifesto_vlrmercadoria,
                                                     mdfe.con_manifesto_quantitensnf,
                                                     mdfe.con_manifesto_cubagemtotal,
                                                     mdfe.car_tpveiculo_codigo,
                                                     --mdfe.arm_carregamento_codigo,
                                                     --mdfe.con_manifesto_localidade,
                                                     mdfe.con_manifesto_cpfmotorista,
                                                     mdfe.con_manifesto_placa,
                                                     mdfe.con_manifesto_placasaque,
                                                     mdfe.glb_tpmotorista_codigo,
                                                     mdfe.con_manifesto_ufdestino,
                                                     mdfe.con_manifesto_codciot 
                                                    )
                                     values(v_sequencia,
                                            'XXX',
                                            pRota,
                                            sysdate,
                                            pUsuario,
                                            replace(nf_agregado.Peso, ',', '.'),
                                            replace(nf_agregado.PesoCobrado, ',', '.'),
                                            replace(nf_agregado.Valor, ',', '.'),
                                            nf_agregado.QtdeNF,
                                            replace(0, ',', '.'),
                                            '01',
                                            --v_carregamento,
                                            --dest.localidade_codigo,
                                            v_cpf,
                                            v_placa,
                                            v_saque,
                                            v_tp_motorista,
                                            dest.UF,
                                            pVFCiot);   
                                                              
                         Insert into T_CON_VEICDISPMANIF(FCF_VEICULODISP_CODIGO,
                                                         FCF_VEICULODISP_SEQUENCIA,
                                                         CON_MANIFESTO_CODIGO,
                                                         CON_MANIFESTO_SERIE,
                                                         CON_MANIFESTO_ROTA,
                                                         USU_USUARIO_GEROU)
                                        Values (pVeiculoDisp, 
                                                pVeiculoSeq,
                                                v_sequencia, 
                                                'XXX', 
                                                pRota,
                                                pUsuario ); 
                        vUF_aux := dest.uf;
                  end if;
                  /*                                                                            
                  For conhec_carreg in (Select ca.arm_carregamento_codigo,
                                               co.con_conhecimento_codigo,
                                               co.con_conhecimento_serie,
                                               co.glb_rota_codigo
                                          from t_arm_carregamento ca,
                                               t_con_conhecimento co
                                          where 0=0
                                            and ca.arm_carregamento_dtfechamento Is Not Null
                                            and ca.fcf_veiculodisp_codigo Is Not Null
                                            and ca.arm_carregamento_dtfinalizacao is null
                                            and Trunc(ca.arm_carregamento_dtfechamento) >= Sysdate-30
                                            and ca.arm_carregamento_codigo = co.arm_carregamento_codigo
                                            and ca.fcf_veiculodisp_codigo = pVeiculoDisp
                                            and ca.fcf_veiculodisp_sequencia = pVeiculoSeq
                                           Order By ca.arm_carregamento_codigo)
                  Loop
                    */
                          Insert into 
                           t_con_docmdfe(con_manifesto_codigo,
                                         con_manifesto_serie,
                                         con_manifesto_rota,
                                         con_conhecimento_codigo,
                                         con_conhecimento_serie,
                                         glb_rota_codigo,
                                         arm_carregamento_codigo) 
                              values(v_sequencia,
                                     'XXX',
                                     pRota,
                                     dest.conhecimento, -- conhec_carreg.con_conhecimento_codigo,
                                     dest.conhec_serie, -- conhec_carreg.con_conhecimento_serie,
                                     dest.conhec_rota, -- conhec_carreg.glb_rota_codigo,
                                     dest.carregamento); -- conhec_carreg.arm_carregamento_codigo);                    
                  --End Loop;
          End Loop;
        
        pStatus := 'N';
        pMessage := 'Manifestos Gerados com sucesso';          
   
   Exception
     When Others Then
       Rollback;
       pStatus := 'E';
       pMessage := mensagen||sqlerrm;
   End;  
                        
End Sp_Insert_MDFe;                         

/*  
Procedure Sp_Insere_MDFe(pCarregamento In Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type,
                         pRota         In Tdvadm.t_Glb_Rota.Glb_Rota_Codigo%Type,
                         pUsuario      In Tdvadm.t_Usu_Usuario.Usu_Usuario_Codigo%Type
--                         pStatus       Out Char,
--                         pMessage      Out Varchar2
                         )
-- Analista: Diego Lirio
-- Criado: 14/06/2013
-- Funcionalidade: Insere o Manifesto Eletronico     
-- Referencia: Tdvadm.SP_INSERE_NOVOMANIFESTO                   
  As 
  v_carregamento Tdvadm.t_Arm_Carregamento.Arm_Carregamento_Codigo%Type;
  v_qtde_manifesto Number;
  v_tp_motorista CHAR(1);
  v_placa         VARCHAR2(50);
  v_saque         VARCHAR2(50);
  v_frota         VARCHAR2(50);
  v_cpf           VARCHAR2(50);
  v_flag_virtual  CHAR(1);  
  v_sequencia     CHAR(6);
  v_ufs           Varchar2(4000);
  v_conhec_codigo t_con_conhecimento.con_conhecimento_codigo%Type;
  v_conhec_serie t_con_conhecimento.con_conhecimento_serie%Type;  
  v_conhec_rota t_con_conhecimento.glb_rota_codigo%Type;    
  nf_agregado NotaAgregadoType;
  --vCountNfTransporta number;
  --vConhecCodigo Tdvadm.t_Con_Conhecimento.Con_Conhecimento_Codigo%Type;
  vVeicDisp t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
  vVeicSeq  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type;
  
  Cursor vCursor_Carregamentos IS -- Carregamentos Vinculados junto a um veiculo disponivel
     SELECT DISTINCT CA.ARM_CARREGAMENTO_CODIGO CARREGAMENTO
       FROM T_ARM_CARREGAMENTO CA, 
            T_FCF_VEICULODISP VD 
      WHERE (CA.ARM_CARREGAMENTO_DTFECHAMENTO IS NOT NULL)
        AND (CA.FCF_VEICULODISP_CODIGO = VD.FCF_VEICULODISP_CODIGO)
        and ( ca.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia )
        AND (CA.FCF_VEICULODISP_CODIGO IS NOT NULL)
        AND (CA.ARM_CARREGAMENTO_DTFINALIZACAO IS NULL)
        AND (TRUNC(CA.ARM_CARREGAMENTO_DTFECHAMENTO) >= SYSDATE - 30)
        AND CA.FCF_VEICULODISP_CODIGO = (SELECT CA2.FCF_VEICULODISP_CODIGO
                                         FROM T_ARM_CARREGAMENTO CA2
                                         WHERE CA2.ARM_CARREGAMENTO_CODIGO = pCarregamento)
      ORDER BY TO_NUMBER(CA.ARM_CARREGAMENTO_CODIGO);  
      
  Cursor vCursor_DestinoNF Is
      SELECT Distinct
             --LO.GLB_LOCALIDADE_CODIGOIBGE,
             --Lo.Glb_Estado_Codigo UF,
             Case 
                when carreg_det.arm_armazem_codigo_transf is not null 
                  then Glbadm.Pkg_Arm_Armazem.Fn_Get_UfArmazem(carreg_det.arm_armazem_codigo_transf)                  
                else Lo.Glb_Estado_Codigo
             End UF
             --Lo.Glb_Localidade_Codigo Localidade_Codigo
             --nt.arm_nota_numero nota,
             --nt.glb_cliente_cgccpfremetente cnpj,
             --carreg_det.arm_carregamento_codigo
        FROM TDVADM.T_ARM_EMBALAGEM E,
             TDVADM.T_ARM_CARGADET CD,
             TDVADM.T_ARM_NOTA NT,
             TDVADM.T_GLB_CLIEND CE,
             TDVADM.T_GLB_LOCALIDADE LO,
             TDVADM.T_ARM_ARMAZEM A,
             Tdvadm.t_Arm_Carregamentodet carreg_det 
       WHERE E.ARM_EMBALAGEM_NUMERO    = CD.ARM_EMBALAGEM_NUMERO
         AND E.ARM_EMBALAGEM_FLAG      = CD.ARM_EMBALAGEM_FLAG
         AND E.ARM_EMBALAGEM_SEQUENCIA = CD.ARM_EMBALAGEM_SEQUENCIA           
         AND CD.ARM_NOTA_NUMERO        = NT.ARM_NOTA_NUMERO    
         AND CD.ARM_NOTA_SEQUENCIA     = NT.ARM_NOTA_SEQUENCIA          
         AND RPAD(NT.GLB_CLIENTE_CGCCPFDESTINATARIO,20) = CE.GLB_CLIENTE_CGCCPFCODIGO
         AND NT.GLB_TPCLIEND_CODDESTINATARIO = CE.GLB_TPCLIEND_CODIGO           
         AND CE.GLB_LOCALIDADE_CODIGO = LO.GLB_LOCALIDADE_CODIGO
         AND NT.ARM_ARMAZEM_CODIGO = A.ARM_ARMAZEM_CODIGO
         AND E.ARM_EMBALAGEM_NUMERO    = carreg_det.arm_embalagem_numero
         AND E.ARM_EMBALAGEM_SEQUENCIA = carreg_det.arm_embalagem_sequencia
         AND E.ARM_EMBALAGEM_FLAG      = carreg_det.arm_embalagem_flag
         and carreg_det.arm_carregamento_codigo = v_carregamento --'384566  ' 
         -- carregamento(380450) com nf de transf
       Order by UF;
         
  Begin
     v_ufs := 'XX;';
     For carreg_for IN vCursor_Carregamentos Loop
         v_carregamento := carreg_for.carregamento;
         
        Begin 
          Select con.con_conhecimento_codigo,
                 con.con_conhecimento_serie,
                 con.glb_rota_codigo
            into v_conhec_codigo,
                 v_conhec_serie,
                 v_conhec_rota     
            from t_con_conhecimento con
            where con.arm_carregamento_codigo = v_carregamento; 
        Exception
          When No_Data_Found Then
            Raise_Application_Error(-20001, 'Conhecimento n?o encontrado por carregamento ' || v_carregamento || Chr(10) || sqlerrm);
        End;
        
        --nf_agregado := Fn_Get_NotaAgregado(v_carregamento);
         
        
     -- Altera Nota setando conhecimento, serie, Rota....
         update t_arm_nota no
           set no.con_conhecimento_codigo = (select co.con_conhecimento_codigo
                                               from t_arm_carregamento ca,
                                                    t_con_conhecimento co,
                                                    t_con_nftransporta nf                                             
                                              where ca.arm_carregamento_codigo = co.arm_carregamento_codigo
                                                and co.con_conhecimento_codigo = nf.con_conhecimento_codigo
                                                and co.con_conhecimento_serie = nf.con_conhecimento_serie
                                                and co.glb_rota_codigo = nf.glb_rota_codigo
                                                and lpad(to_char(no.arm_nota_numero),6,'0') = nf.con_nftransportada_numnfiscal
                                                and rpad(no.glb_cliente_cgccpfremetente,20) = nf.glb_cliente_cgccpfcodigo
                                                and ca.arm_carregamento_codigo = v_carregamento),
               no.con_conhecimento_serie  = (select co.con_conhecimento_serie
                                               from t_arm_carregamento ca,
                                                    t_con_conhecimento co,
                                                    t_con_nftransporta nf
                                              where ca.arm_carregamento_codigo = co.arm_carregamento_codigo
                                                and co.con_conhecimento_codigo = nf.con_conhecimento_codigo
                                                and co.con_conhecimento_serie = nf.con_conhecimento_serie
                                                and co.glb_rota_codigo = nf.glb_rota_codigo
                                                and lpad(to_char(no.arm_nota_numero),6,'0') = nf.con_nftransportada_numnfiscal
                                                and rpad(no.glb_cliente_cgccpfremetente,20) = nf.glb_cliente_cgccpfcodigo
                                                and ca.arm_carregamento_codigo = v_carregamento),
               no.glb_rota_codigo         = (select co.glb_rota_codigo
                                               from t_arm_carregamento ca,
                                                    t_con_conhecimento co,
                                                    t_con_nftransporta nf                                             
                                              where ca.arm_carregamento_codigo = co.arm_carregamento_codigo
                                                and co.con_conhecimento_codigo = nf.con_conhecimento_codigo
                                                and co.con_conhecimento_serie = nf.con_conhecimento_serie
                                                and co.glb_rota_codigo = nf.glb_rota_codigo
                                                and lpad(to_char(no.arm_nota_numero),6,'0') = nf.con_nftransportada_numnfiscal
                                                and rpad(no.glb_cliente_cgccpfremetente,20) = nf.glb_cliente_cgccpfcodigo
                                                and ca.arm_carregamento_codigo = v_carregamento)
         where 0 < (select count(*)
                      from t_arm_carregamento ca,
                           t_con_conhecimento co,
                           t_con_nftransporta nf                    
                     where ca.arm_carregamento_codigo = co.arm_carregamento_codigo
                       and co.con_conhecimento_codigo = nf.con_conhecimento_codigo
                       and co.con_conhecimento_serie = nf.con_conhecimento_serie
                       and co.glb_rota_codigo = nf.glb_rota_codigo
                       and lpad(to_char(no.arm_nota_numero), 6, '0') = nf.con_nftransportada_numnfiscal
                       and rpad(no.glb_cliente_cgccpfremetente, 20) = nf.glb_cliente_cgccpfcodigo
                       and ca.arm_carregamento_codigo = v_carregamento)
           and no.con_conhecimento_codigo is null;
           
           SELECT COUNT(*)
             INTO v_qtde_manifesto
             FROM T_CON_MANIFESTO MA
             WHERE MA.ARM_CARREGAMENTO_CODIGO = v_carregamento;             

           -- Se n?o existe manifesto
           if v_qtde_manifesto = 0 then
                  -- Analisar melhor esta rotina, Tdvadm.Sp_Arm_Nota_Ctrc -> Update na Nota.
                  Tdvadm.Sp_Arm_Nota_Ctrc(v_carregamento); 
                  v_tp_motorista := 'C'; 
                 
                  -- Veiculo Virtual ???
                  SELECT D.FCF_VEICULODISP_FLAGVIRTUAL,
                         D.FRT_CONJVEICULO_CODIGO,
                         D.CAR_CARRETEIRO_CPFCODIGO,
                         D.CAR_VEICULO_PLACA,
                         D.CAR_CARRETEIRO_SAQUE,
                         d.fcf_veiculodisp_codigo,
                         d.fcf_veiculodisp_sequencia
                    Into v_flag_virtual, 
                         v_frota, 
                         v_cpf, 
                         v_placa, 
                         v_saque,
                         vVeicDisp,
                         vVeicSeq
                    FROM T_FCF_VEICULODISP D
                   WHERE D.FCF_VEICULODISP_CODIGO = ( SELECT FCF_VEICULODISP_CODIGO
                                                        FROM T_ARM_CARREGAMENTO
                                                        WHERE ARM_CARREGAMENTO_CODIGO = v_carregamento
                                                        AND ROWNUM = 1)
                     AND D.FCF_VEICULODISP_SEQUENCIA = ( SELECT FCF_VEICULODISP_SEQUENCIA
                                                          FROM T_ARM_CARREGAMENTO
                                                          WHERE ARM_CARREGAMENTO_CODIGO = v_carregamento
                                                            AND ROWNUM = 1);
                                                            
                 if v_flag_virtual is null then
                     v_placa := '';
                     v_saque := '';
                     v_cpf   := '';
                 else
                     if v_frota is not null then
                          v_tp_motorista := 'F';
                          Begin
                              SELECT MO.FRT_MOTORISTA_CPF CPF
                                INTO v_cpf
                                FROM T_FRT_CONJUNTO C, 
                                     T_FRT_CONJVEICULO CC, 
                                     T_FRT_MOTORISTA MO
                               WHERE C.FRT_CONJVEICULO_CODIGO = CC.FRT_CONJVEICULO_CODIGO
                                 AND C.FRT_MOTORISTA_CODIGO = MO.FRT_MOTORISTA_CODIGO
                                 AND CC.FRT_CONJVEICULO_CODIGO = v_frota
                                 AND ROWNUM = 1
                               GROUP BY MO.FRT_MOTORISTA_CPF;           
                          
                               v_placa := v_frota;
                               v_saque := '';
                          Exception
                            When Others Then
                               v_cpf := null;   
                          End;  
                     end if;                 
                 end if;  
                 
                 for dest in vCursor_DestinoNF loop
                      EXIT WHEN vCursor_DestinoNF%NOTFOUND;
                      -- para cada nova UF cria um novo codigo de manifesto.                      
                      -- se ja contem um numero criado com esta uf reutiliza o mesmo para realizar o insert
                      if InStr(v_ufs, dest.uf) <= 0 then
                            BEGIN
                                SELECT LPAD(CON_MANIFESTO_SEQUENCIA.NEXTVAL, 6, 0) SEQUENCIA
                                  INTO v_sequencia
                                  FROM DUAL;
                                  
                                Insert into 
                                tdvadm.t_Con_Manifesto mdfe (mdfe.con_manifesto_codigo,
                                                             mdfe.con_manifesto_serie,
                                                             mdfe.con_manifesto_rota,
                                                             mdfe.con_manifesto_dtcriacao,
                                                             mdfe.usu_usuario_codigo,
                                                             mdfe.con_manifesto_pesonf,
                                                             mdfe.con_manifesto_pesocobrado,
                                                             mdfe.con_manifesto_vlrmercadoria,
                                                             mdfe.con_manifesto_quantitensnf,
                                                             mdfe.con_manifesto_cubagemtotal,
                                                             mdfe.car_tpveiculo_codigo,
                                                             --mdfe.arm_carregamento_codigo,
                                                             --mdfe.con_manifesto_localidade,
                                                             mdfe.con_manifesto_cpfmotorista,
                                                             mdfe.con_manifesto_placa,
                                                             mdfe.con_manifesto_placasaque,
                                                             mdfe.glb_tpmotorista_codigo,
                                                             mdfe.con_manifesto_ufdestino   
                                                            )
                                             values(v_sequencia,
                                                    'XXX',
                                                    pRota,
                                                    sysdate,
                                                    pUsuario,
                                                    replace(nf_agregado.Peso, ',', '.'),
                                                    replace(nf_agregado.PesoCobrado, ',', '.'),
                                                    replace(nf_agregado.Valor, ',', '.'),
                                                    nf_agregado.QtdeNF,
                                                    replace(0, ',', '.'),
                                                    '01',
                                                    --v_carregamento,
                                                    --dest.localidade_codigo,
                                                    v_cpf,
                                                    v_placa,
                                                    v_saque,
                                                    v_tp_motorista,
                                                    dest.UF);   
                                                    
                                 Insert into T_CON_VEICDISPMANIF(FCF_VEICULODISP_CODIGO,FCF_VEICULODISP_SEQUENCIA,
                                          CON_MANIFESTO_CODIGO,CON_MANIFESTO_SERIE,CON_MANIFESTO_ROTA,
                                          USU_USUARIO_GEROU)
                                      Values (vVeicDisp, vVeicSeq,
                                              v_sequencia, 'XXX', pRota,
                                              pUsuario );                                                         
                                                    
                                 v_ufs := v_ufs || dest.uf || ';';                                   
                                  
                            EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                 v_sequencia := '000001';
                            END; 
                       end if;
                      
                      /* 
                          INSERE UM MANIFESTO DE ACORDO COM A UF DE LOCALIDADE, 
                          PARA CADA UF DE LOCALIDADE UM MANIFESTO
                      *
                                          
                      Insert into 
                       t_con_docmdfe(con_manifesto_codigo,
                                     con_manifesto_serie,
                                     con_manifesto_rota,
                                     con_conhecimento_codigo,
                                     con_conhecimento_serie,
                                     glb_rota_codigo,
                                     arm_carregamento_codigo) 
                          values(v_sequencia,
                                 'XXX',
                                 pRota,
                                 v_conhec_codigo,
                                 v_conhec_serie,
                                 v_conhec_rota,
                                 v_carregamento);     
                                 
                      
                      /* 
                                 ToDo...: Diego Lirio
                                 
                                 Analisar criacao de tabela manifesto_veiculoDisponivel
                                 para fazer busca do manifesto !!!!
                      *
                               
                 
                                          
                      /*     Update na t_con_movimento                            
                      FOR C_CTRC IN (SELECT CO.GLB_ROTA_CODIGO,
                                            CO.CON_CONHECIMENTO_CODIGO,
                                            CO.CON_CONHECIMENTO_SERIE
                                       FROM T_CON_CONHECIMENTO CO, T_GLB_CLIEND EN
                                      WHERE CO.ARM_CARREGAMENTO_CODIGO = V_CARREGAMENTO
                                        AND CO.GLB_CLIENTE_CGCCPFDESTINATARIO =
                                            EN.GLB_CLIENTE_CGCCPFCODIGO
                                        AND CO.GLB_TPCLIEND_CODIGODESTINATARI =
                                            EN.GLB_TPCLIEND_CODIGO
                                        AND CO.CON_CONHECIMENTO_NRFORMULARIO IS NOT NULL
                                        AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
                                        AND CO.CON_CONHECIMENTO_DIGITADO = 'I'
                                        AND EN.GLB_LOCALIDADE_CODIGO =
                                            dest.localidade_codigo) LOOP
                        UPDATE T_ARM_MOVIMENTO
                           SET CON_MANIFESTO_CODIGO        = v_sequencia,
                               CON_MANIFESTO_SERIE         = 'XXX',
                               CON_MANIFESTO_ROTA          = pRota,
                               ARM_MOVIMENTO_MANIF_MARCADO = 'N'
                         WHERE CON_CONHECIMENTO_NUMERO = C_CTRC.CON_CONHECIMENTO_CODIGO
                           AND CON_CONHECIMENTO_SERIE = C_CTRC.CON_CONHECIMENTO_SERIE
                           AND GLB_ROTA_CONHECIMENTO = C_CTRC.GLB_ROTA_CODIGO;
                      END LOOP;    
                      *                                        
                                           
                 end loop;                                                          
                 
           end if;
         
         
     End Loop;
  End Sp_Insere_MDFe;  
  */
  
  Function Fn_Get_NotaAgregado(pVeiculoDisp In t_Arm_Carregamento.Fcf_Veiculodisp_Codigo%Type,
                               pVeiculoSeq  In t_Arm_Carregamento.Fcf_Veiculodisp_Sequencia%Type,
                               pUF          In Char) return NotaAgregadoType
    As
    nf      NotaAgregadoType;
    nf2     NotaAgregadoType;
    nfTotal NotaAgregadoType;
    uf char(2);
    Begin
      
       begin
         
         SELECT Distinct
                Case 
                   when carreg_det.arm_armazem_codigo_transf is not null 
                     then Glbadm.Pkg_Arm_Armazem.Fn_Get_UfArmazem(carreg_det.arm_armazem_codigo_transf)                  
                   else Lo.Glb_Estado_Codigo
                End UF,
                sum(nvl(nt.arm_nota_peso,0)) peso_total,
                sum(nvl(nt.arm_coleta_pesocobrado,0)) peso_cobrado_total,
                --nt.arm_coleta_vlmercadoria,
                sum(nvl(nt.arm_nota_valormerc,0)) valor_mercadoria_total,
                Count(*) qtde_nf       
          Into uf,
               nf.Peso,
               nf.PesoCobrado,
               nf.Valor,
               nf.QtdeNF               
           FROM TDVADM.T_ARM_EMBALAGEM E,
                TDVADM.T_ARM_CARGADET CD,
                TDVADM.T_ARM_NOTA NT,
                TDVADM.T_GLB_CLIEND CE,
                TDVADM.T_GLB_LOCALIDADE LO,
                TDVADM.T_ARM_ARMAZEM A,
                Tdvadm.t_Arm_Carregamentodet carreg_det,
                Tdvadm.t_Arm_Carregamento ca
                --,tdvadm.t_con_conhecimento co
          WHERE E.ARM_EMBALAGEM_NUMERO                      = CD.ARM_EMBALAGEM_NUMERO
            AND E.ARM_EMBALAGEM_FLAG                        = CD.ARM_EMBALAGEM_FLAG
            AND E.ARM_EMBALAGEM_SEQUENCIA                   = CD.ARM_EMBALAGEM_SEQUENCIA           
            AND CD.ARM_NOTA_NUMERO                          = NT.ARM_NOTA_NUMERO    
            AND CD.ARM_NOTA_SEQUENCIA                       = NT.ARM_NOTA_SEQUENCIA          
            AND RPAD(NT.GLB_CLIENTE_CGCCPFDESTINATARIO,20)  = CE.GLB_CLIENTE_CGCCPFCODIGO
            AND NT.GLB_TPCLIEND_CODDESTINATARIO             = CE.GLB_TPCLIEND_CODIGO           
            --AND CE.GLB_LOCALIDADE_CODIGO                    = LO.GLB_LOCALIDADE_CODIGO
            AND NT.ARM_NOTA_LOCALENTREGAL                    = LO.GLB_LOCALIDADE_CODIGO
            AND NT.ARM_ARMAZEM_CODIGO                       = A.ARM_ARMAZEM_CODIGO
            AND E.ARM_EMBALAGEM_NUMERO                      = carreg_det.arm_embalagem_numero
            AND E.ARM_EMBALAGEM_SEQUENCIA                   = carreg_det.arm_embalagem_sequencia
            AND E.ARM_EMBALAGEM_FLAG                        = carreg_det.arm_embalagem_flag
            And carreg_det.arm_carregamento_codigo          = ca.arm_carregamento_codigo
            --And co.arm_carregamento_codigo                  = ca.arm_carregamento_codigo
            and ca.fcf_veiculodisp_codigo                   = pVeiculoDisp --'1774874' 
            and ca.fcf_veiculodisp_sequencia                = pVeiculoSeq  --'0'
            And Case 
                when carreg_det.arm_armazem_codigo_transf is not null 
                  then Glbadm.Pkg_Arm_Armazem.Fn_Get_UfArmazem(carreg_det.arm_armazem_codigo_transf)                  
                else Lo.Glb_Estado_Codigo
            End = pUF--'BA'
               /*   Group By carreg_det.arm_armazem_codigo_transf,
                    Lo.Glb_Estado_Codigo  */
            GROUP BY Case 
                  when carreg_det.arm_armazem_codigo_transf is not null 
                      then Glbadm.Pkg_Arm_Armazem.Fn_Get_UfArmazem(carreg_det.arm_armazem_codigo_transf)                  
                    else Lo.Glb_Estado_Codigo
                 End
           Order by UF;         
       
       exception 
         when others then
           nf.Peso        := null;
           nf.PesoCobrado := null;
           nf.Valor       := null;
           nf.QtdeNF      := null;

       end;
       
       begin
         
         Select ld.glb_estado_codigo,
                sum(tr.con_nftransportada_peso),
                sum(tr.con_nftransportada_peso),
                sum(tr.con_nftransportada_valor),
                count(*)
           Into uf,
                nf2.Peso,
                nf2.PesoCobrado,
                nf2.Valor,
                nf2.QtdeNF    
           from t_con_veicconhec   vv,
                t_con_conhecimento ch,
                t_con_nftransporta tr,
                t_glb_localidade   ld
          where vv.fcf_veiculodisp_codigo       = pVeiculoDisp
            and vv.fcf_veiculodisp_sequencia    = pVeiculoSeq
            and vv.con_conhecimento_codigo      = ch.con_conhecimento_codigo
            and vv.con_conhecimento_serie       = ch.con_conhecimento_serie
            and vv.glb_rota_codigo              = ch.glb_rota_codigo
            and ch.con_conhecimento_codigo      = tr.con_conhecimento_codigo
            and ch.con_conhecimento_serie       = tr.con_conhecimento_serie
            and ch.glb_rota_codigo              = tr.glb_rota_codigo         
            and ch.glb_localidade_codigodestino = ld.glb_localidade_codigo
            and ld.glb_estado_codigo            = pUF
           group by ld.glb_estado_codigo ;
       
       exception 
         when others then
           nf2.Peso        := null;
           nf2.PesoCobrado := null;
           nf2.Valor       := null;
           nf2.QtdeNF      := null;
       end;
         
       nfTotal.Peso        := nvl(nf.Peso,0)         + nvl(nf2.Peso,0);
       nfTotal.PesoCobrado := nvl(nf.PesoCobrado,0)  + nvl(nf2.PesoCobrado,0);
       nfTotal.Valor       := nvl(nf.Valor,0)        + nvl(nf2.Valor,0);
       nfTotal.QtdeNF      := nvl(nf.QtdeNF,0)       + nvl(nf2.QtdeNF,0);
         
       return nfTotal;
         
    End Fn_Get_NotaAgregado;
    
 
  Function Fn_Is_MDFe(pRota in t_Glb_Rota.Glb_Rota_Codigo%Type) return Char
   -- Verifica se a Rota e Manifesto Eletronico...    
    As
    vTpAbm   Number; -- MDFe ou Antigo
    vRetorno char(1);
    Begin
              
      vTpAbm := Pkg_Con_Mdfe.fn_Con_MdfeTpAmb(pRota);
      
      if vTpAbm = 1 then -- 1 = MDFe
        vRetorno := 'S';
      else               -- 2 = MDF antigo
        vRetorno := 'N';
      end if;       

      return vRetorno;
        
    End Fn_Is_MDFe;
    
  PROCEDURE SP_CON_DISPMANIFESTO IS
  MANIFESTO INTEGER;
  V_ROTA       T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE;
  V_SERIE      T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  V_UTIL       T_CON_DISPONIVEL.CON_DISPONIVEL_UTILIZADO%TYPE;
  V_DTUTIL     T_CON_DISPONIVEL.CON_DISPONIVEL_DTUTILIZACAO%TYPE;
  v_contador   number;

  CURSOR DISPMANIFESTO IS
    SELECT * FROM T_CON_DISPMANIFESTO FOR UPDATE;

  CURSOR ROTAS IS
    SELECT R.GLB_ROTA_CODIGO CODIGO
      FROM T_GLB_ROTA R
     WHERE tdvadm.pkg_con_mdfe.fn_Con_MdfeTpAmb(R.GLB_ROTA_CODIGO) = 1;

  CURSOR C_MANIFESTO IS
    SELECT C.CON_MANIFESTO_CODIGO CODIGO
      FROM T_CON_MANIFESTO C
     WHERE trim(C.CON_MANIFESTO_ROTA)= trim(V_ROTA)
       AND TRIM(C.CON_MANIFESTO_SERIE)= TRIM(V_SERIE)
       AND C.CON_MANIFESTO_CODIGO < DECODE(C.CON_MANIFESTO_ROTA,'197','304489','999999')
     ORDER BY 1;

 BEGIN

  OPEN DISPMANIFESTO;

  --Deleto Manifestos que ja foram usados

  delete T_CON_DISPMANIFESTO d
   where ((d.con_dispmanifesto_dtutilizacao <= (sysdate - 1 / 72) and
         d.con_dispmanifesto_utilizado = 'S') or
         (d.con_dispmanifesto_dtutilizacao is null));

  FOR ROTA IN ROTAS LOOP
    V_ROTA := ROTA.CODIGO;

    -- ZERA OS CODIGOS PARA RECOMECAR CONTAGEM EM NOVA ROTA
    MANIFESTO := 0;

    -- DETERMINA QUAL E A SERIE DE EMISS?O DA ROTA
    BEGIN
        V_SERIE := 'A1';
    END;


    BEGIN
    FOR CTRC IN C_MANIFESTO LOOP
      IF MANIFESTO =-1 THEN
        -- VERIFICA SE E O PRIMEIRO CTRC DA LISTA E PEGA O SEU NUMERO
        MANIFESTO := TO_NUMBER(CTRC.CODIGO);
      ELSE
        MANIFESTO := MANIFESTO + 1;
        WHILE (TO_NUMBER(CTRC.CODIGO) - MANIFESTO) >= 1 LOOP
          BEGIN
            SELECT D.CON_DISPMANIFESTO_UTILIZADO,
                   D.CON_DISPMANIFESTO_DTUTILIZACAO
              INTO V_UTIL, V_DTUTIL
              FROM T_CON_DISPMANIFESTO D
             WHERE D.CON_DISPMANIFESTO_CODIGO=
                   LPAD(TRIM(TO_CHAR(MANIFESTO)), 6, '0')
               AND D.CON_DISPMANIFESTO_SERIE= V_SERIE
               AND D.GLB_ROTA_CODIGO= V_ROTA;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN

              select count(*)
                into v_contador
                from t_con_MANIFESTO M
               where M.CON_MANIFESTO_CODIGO =
                     LPAD(TRIM(TO_CHAR(MANIFESTO)), 6, '0')
                 and M.CON_MANIFESTO_SERIE = V_SERIE
                 and M.CON_MANIFESTO_ROTA = V_ROTA;
              if v_contador = 0  then
                INSERT INTO T_CON_DISPMANIFESTO
                  (CON_DISPMANIFESTO_CODIGO,
                   CON_DISPMANIFESTO_SERIE,
                   GLB_ROTA_CODIGO,
                   CON_DISPMANIFESTO_UTILIZADO,
                   CON_DISPMANIFESTO_DTUTILIZACAO)
                VALUES
                  (LPAD(TRIM(TO_CHAR(MANIFESTO)), 6, '0'),
                   V_SERIE,
                   V_ROTA,
                   NULL,
                   NULL);
              end if;
              V_UTIL   := NULL;
              V_DTUTIL := NULL;
          END;
          IF (V_UTIL = 'S') AND (TRUNC(V_DTUTIL) < TRUNC(SYSDATE) - 1) THEN
            select count(*)
              into v_contador
              from t_con_MANIFESTO M
             where M.CON_MANIFESTO_CODIGO =
                   LPAD(TRIM(TO_CHAR(MANIFESTO)), 6, '0')
               and M.CON_MANIFESTO_SERIE= V_SERIE
               and M.CON_MANIFESTO_ROTA= V_ROTA;
            if v_contador = 0 then
              UPDATE T_CON_DISPMANIFESTO D
                 SET D.CON_DISPMANIFESTO_UTILIZADO    = NULL,
                     D.CON_DISPMANIFESTO_DTUTILIZACAO = NULL
               WHERE D.CON_DISPMANIFESTO_CODIGO =
                     LPAD(TRIM(TO_CHAR(MANIFESTO)), 6, '0')
                 AND D.CON_DISPMANIFESTO_SERIE = V_SERIE
                 AND D.GLB_ROTA_CODIGO = V_ROTA;
            end if;
          END IF;
          MANIFESTO := MANIFESTO + 1;
        END LOOP;
      END IF;
    END LOOP;
    EXCEPTION WHEN OTHERS THEN
      Raise_application_error(-20001,V_ROTA||' erro = '||Sqlerrm);
    END;
/*    if (MANIFESTO > 0 ) then
    update t_glb_rota r
       set r.con_manifesto_codigo = MANIFESTO
     where r.glb_rota_codigo = v_rota;
    end if;*/
    COMMIT;

  END LOOP;
  CLOSE DISPMANIFESTO;
end SP_CON_DISPMANIFESTO;

 PROCEDURE SP_BUSCA_PROXIMOMANIFESTO(P_ROTA IN T_GLB_ROTA.GLB_ROTA_CODIGO%TYPE,
                                      V_NUMERO OUT T_GLB_ROTA.CON_CONHECIMENTO_CODIGO%TYPE)
  AS
  
  CURSOR C_DISPMANIFESTO IS
  SELECT *
    FROM T_CON_DISPMANIFESTO D
   WHERE D.GLB_ROTA_CODIGO = P_ROTA
     AND NVL(D.CON_DISPMANIFESTO_UTILIZADO,'N') = 'N'
     AND D.CON_DISPMANIFESTO_DTUTILIZACAO IS NULL
     FOR UPDATE OF D.CON_DISPMANIFESTO_CODIGO;  

  CURSOR C_ROTA IS
  SELECT R.CON_MANIFESTO_CODIGO
    FROM T_GLB_ROTA R
   WHERE R.GLB_ROTA_CODIGO = P_ROTA
     AND tdvadm.pkg_con_mdfe.fn_Con_MdfeTpAmb(p_rota)=1
  FOR UPDATE OF R.CON_MANIFESTO_CODIGO;

  V_PODESAIR INTEGER := 1; -- INDICA QUANTOS CTRC ENCONTROU, SAI DO LOOP SE FOR 0 (ZERO)

  BEGIN
     
     OPEN C_DISPMANIFESTO;
     OPEN C_ROTA;
     LOOP
     BEGIN
        SELECT MIN(D.CON_DISPMANIFESTO_CODIGO)
          INTO V_NUMERO
          FROM T_CON_DISPMANIFESTO D
         WHERE D.GLB_ROTA_CODIGO = P_ROTA
           AND NVL(D.CON_DISPMANIFESTO_UTILIZADO, 'N') = 'N'
           AND D.CON_DISPMANIFESTO_DTUTILIZACAO IS NULL;
          
        IF V_NUMERO IS NOT NULL THEN  
           UPDATE T_CON_DISPMANIFESTO D
              SET D.CON_DISPMANIFESTO_UTILIZADO    = 'S',
                  D.CON_DISPMANIFESTO_DTUTILIZACAO = SYSDATE
            WHERE D.CON_DISPMANIFESTO_CODIGO = V_NUMERO
              AND D.GLB_ROTA_CODIGO = P_ROTA;
        ELSE
           BEGIN
              
              SELECT TRIM(TO_CHAR(NVL(R.CON_MANIFESTO_CODIGO,0) + 1, '000000'))
                INTO V_NUMERO
                FROM T_GLB_ROTA R
               WHERE R.GLB_ROTA_CODIGO = P_ROTA;
                -- AND tdvadm.pkg_con_mdfe.fn_Con_MdfeTpAmb(p_rota) = 1;

              UPDATE T_GLB_ROTA R1
              SET R1.CON_MANIFESTO_CODIGO =  V_NUMERO
              WHERE  R1.GLB_ROTA_CODIGO = P_ROTA;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 V_NUMERO := '000000';
           END;
        
        END IF ;     

        COMMIT;  
     EXCEPTION WHEN NO_DATA_FOUND THEN 
        BEGIN
           SELECT TRIM(TO_CHAR(R.CON_MANIFESTO_CODIGO + 1, '000000'))
             INTO V_NUMERO
             FROM T_GLB_ROTA R
            WHERE R.GLB_ROTA_CODIGO = P_ROTA
              AND tdvadm.pkg_con_mdfe.fn_Con_MdfeTpAmb(p_rota) = 1;

           UPDATE T_GLB_ROTA R1
              SET R1.CON_MANIFESTO_CODIGO = V_NUMERO
            WHERE R1.GLB_ROTA_CODIGO = P_ROTA;
           COMMIT;
           
        EXCEPTION WHEN NO_DATA_FOUND THEN
           V_NUMERO := '000000';
        END;
     END;   

     IF V_NUMERO <> '000000' THEN
        SELECT COUNT(*)
          INTO V_PODESAIR
          FROM T_CON_MANIFESTO C
         WHERE C.CON_MANIFESTO_CODIGO = V_NUMERO
           AND C.CON_MANIFESTO_SERIE = 'A1'
           AND C.CON_MANIFESTO_ROTA = P_ROTA;
     ELSE
        V_PODESAIR := 0;
     END IF;         

         exit when (V_PODESAIR = 0);
     END LOOP;
     
     
     COMMIT;
     
     CLOSE C_DISPMANIFESTO;
     CLOSE C_ROTA;
     
  END SP_BUSCA_PROXIMOMANIFESTO;                         
  
  Function Fn_Manifesto_Gerado(pVeicDisp t_con_veicdispmanif.fcf_veiculodisp_codigo%Type,
                               pVeicSeq  t_con_veicdispmanif.fcf_veiculodisp_sequencia%Type) return Char
-- Analista: Diego Lirio
-- Criado: 14/06/2013
-- Funcionalidade: Verifica se Veiculo Esta com Manifesto gerado....      
-- Referencia: Tdvadm.Pkg_Con_Manifesto.Fn_Manifesto_Gerado(pVeicDisp,pVeicSeq)                           
  As
  vResult Char(1);
  --v_count_carreg_vinc Integer;
  --v_count_carreg_manif Integer;
  Begin
       Select Case count(*)
                When 0 Then 'N'
                Else 'S'
              End    
          Into vResult
          from t_con_veicdispmanif v
          where v.fcf_veiculodisp_codigo = pVeicDisp
            and v.fcf_veiculodisp_sequencia = pVeicSeq;
        
       /*    
       if vResult = 'S' Then
           Select Count(*)
             Into v_count_carreg_vinc
             From t_arm_carregamento c
             where c.fcf_veiculodisp_codigo = pVeicDisp
               and c.fcf_veiculodisp_sequencia = pVeicSeq;
           
           Select count(*)
             Into v_count_carreg_manif
             From t_con_docmdfe m
             where m.arm_carregamento_codigo In (Select cc.arm_carregamento_codigo
                                                  from t_arm_carregamento cc
                                                  where cc.fcf_veiculodisp_codigo = pVeicDisp
                                                    and cc.fcf_veiculodisp_sequencia = pVeicSeq);
                                                    
          If v_count_carreg_manif < v_count_carreg_vinc then
             vResult := 'F';
          end if;              
       End if;  
       */   
                 
       -- S => Gerado
       -- N => Nao Gerado
       -- F => Faltando a ser gerado.
       Return vResult;     
  End Fn_Manifesto_Gerado;   
  
  Procedure Sp_Insert_Manifesto(pCarregamento In t_con_manifesto.arm_carregamento_codigo%Type,
                                pVeicDisp     In t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pVeicSeq      In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pRota         In t_Con_Manifesto.Con_Manifesto_Rota%Type,
                                pUsuario      In t_con_manifesto.usu_usuario_codigo%Type,
                                pStatus       Out Char,
                                pMessage      Out Varchar2)
  As
  vSequencia Char(6);
  vFlagVirtual t_fcf_veiculodisp.fcf_veiculodisp_flagvirtual%Type;
  vFrota       t_fcf_veiculodisp.frt_conjveiculo_codigo%Type;
  vCpf         t_fcf_veiculodisp.car_carreteiro_cpfcodigo%Type;
  vPlaca       t_Fcf_Veiculodisp.Car_Veiculo_Placa%Type;
  vSaque       t_fcf_veiculodisp.car_carreteiro_saque%Type;
  vTpMotorista Char(1);
  Begin
    
      Begin    
          Tdvadm.Sp_Arm_Nota_Ctrc(pCarregamento);
          vTpMotorista := 'C';
          SELECT D.FCF_VEICULODISP_FLAGVIRTUAL,
                 D.FRT_CONJVEICULO_CODIGO,
                 D.CAR_CARRETEIRO_CPFCODIGO,
                 D.CAR_VEICULO_PLACA,
                 D.CAR_CARRETEIRO_SAQUE
            INTO vFlagVirtual, 
                 vFrota, 
                 vCpf, 
                 vPlaca, 
                 vSaque
            FROM T_FCF_VEICULODISP D
           WHERE D.FCF_VEICULODISP_CODIGO = pVeicDisp
             AND D.FCF_VEICULODISP_SEQUENCIA = pVeicSeq;      
      
          if nvl(vFlagVirtual, '') = '' THEN
                vPlaca := '';
                vSaque := '';
                vCPF   := '';
                -- SE N?O FOR VIRTUAL ELE VERIFICA SE E FROTA OU OUTROS
          ELSE
                --SE FOR FROTA ELE BUSCA PLACA SAQUE E CPF DO FROTA
                IF vFROTA IS NOT NULL THEN
                  vTpMotorista := 'F';
                  begin
                    SELECT MO.FRT_MOTORISTA_CPF CPF
                      INTO vCPF
                      FROM T_FRT_CONJUNTO C, T_FRT_CONJVEICULO CC, T_FRT_MOTORISTA MO
                     WHERE C.FRT_CONJVEICULO_CODIGO = CC.FRT_CONJVEICULO_CODIGO
                       AND C.FRT_MOTORISTA_CODIGO = MO.FRT_MOTORISTA_CODIGO
                       AND CC.FRT_CONJVEICULO_CODIGO = vFROTA
                       AND ROWNUM = 1
                     GROUP BY MO.FRT_MOTORISTA_CPF;
                    vPLACA := vFROTA;
                    vSAQUE := '';
                  exception
                    when no_data_found then
                      vCPF := null;
                  end;
                  --SE N?O FOR FROTA ELE PEGA OS DADOS DO CARRETEIRO
                END IF;
          END IF;    
      
          For localidade In (
                             SELECT CL.GLB_LOCALIDADE_CODIGO codigo
                                FROM T_ARM_CARREGAMENTO CA,
                                     t_arm_carregamentodet det,
                                     t_arm_nota nota,
                                     T_CON_CONHECIMENTO CO, 
                                     T_GLB_CLIEND CL
                               WHERE 
                                     0=0
                                 and ca.arm_carregamento_codigo = det.arm_carregamento_codigo
                                 and det.arm_embalagem_numero = nota.arm_embalagem_numero
                                 and det.arm_embalagem_flag = nota.arm_embalagem_flag
                                 and det.arm_embalagem_sequencia = nota.arm_embalagem_sequencia
                                 and nota.con_conhecimento_codigo = co.con_conhecimento_codigo
                                 and nota.con_conhecimento_serie = co.con_conhecimento_serie
                                 and nota.glb_rota_codigo = co.glb_rota_codigo
                                 AND TRIM(CO.GLB_CLIENTE_CGCCPFDESTINATARIO) = TRIM(CL.GLB_CLIENTE_CGCCPFCODIGO)
                                  AND TRIM(CO.GLB_TPCLIEND_CODIGODESTINATARI) = TRIM(CL.GLB_TPCLIEND_CODIGO)
                                  AND CA.ARM_CARREGAMENTO_CODIGO = pCarregamento
                             GROUP BY CL.GLB_LOCALIDADE_CODIGO
                            )
          Loop   
                BEGIN
                  vSequencia := pkg_fifo_manifesto.Fn_Get_NovoNumeroManifestoXXX();
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    vSequencia := '000001';
                END;
      
      
            /*INSERE UM MANIFESTO DE ACORDO COM A LOCALIDADE, PARA CADA LOCALIDADE UM MANIFESTO*/
            INSERT INTO T_CON_MANIFESTO
                            ( CON_MANIFESTO_CODIGO,
                              CON_MANIFESTO_SERIE,
                              CON_MANIFESTO_ROTA,
                              CON_MANIFESTO_DTCRIACAO,
                              USU_USUARIO_CODIGO,
                              CON_MANIFESTO_PESONF,
                              CON_MANIFESTO_PESOCOBRADO,
                              CON_MANIFESTO_VLRMERCADORIA,
                              CON_MANIFESTO_QUANTITENSNF,
                              CON_MANIFESTO_CUBAGEMTOTAL,
                              CAR_TPVEICULO_CODIGO,
                              ARM_CARREGAMENTO_CODIGO,
                              CON_MANIFESTO_LOCALIDADE,
                              CON_MANIFESTO_CPFMOTORISTA,
                              CON_MANIFESTO_PLACA,
                              CON_MANIFESTO_PLACASAQUE,
                              GLB_TPMOTORISTA_CODIGO)
                        VALUES
                           ( vSequencia,
                           'XXX',
                           pRota,
                           SYSDATE,
                           pUsuario,
                           REPLACE(0, ',', '.'),
                           REPLACE(0, ',', '.'),
                           REPLACE(0, ',', '.'),
                           REPLACE(0, ',', '.'),
                           REPLACE(0, ',', '.'),
                           '01',
                          pCarregamento,
                          localidade.codigo,
                          vCpf,
                          vPlaca,
                          vSaque,
                          vTpMotorista);  
                          
                Insert into T_CON_VEICDISPMANIF(FCF_VEICULODISP_CODIGO,FCF_VEICULODISP_SEQUENCIA,
                                                CON_MANIFESTO_CODIGO,CON_MANIFESTO_SERIE,CON_MANIFESTO_ROTA,
                                                USU_USUARIO_GEROU)
                                            Values (pVeicDisp, pVeicSeq,
                                                    vSequencia, 'XXX', pRota,
                                                    pUsuario );
                   /*                                 
                  FOR C_CTRC IN (SELECT CO.GLB_ROTA_CODIGO,
                                        CO.CON_CONHECIMENTO_CODIGO,
                                        CO.CON_CONHECIMENTO_SERIE
                                   FROM T_CON_CONHECIMENTO CO, T_GLB_CLIEND EN
                                  WHERE CO.ARM_CARREGAMENTO_CODIGO = V_CARREGAMENTO
                                    AND CO.GLB_CLIENTE_CGCCPFDESTINATARIO =
                                        EN.GLB_CLIENTE_CGCCPFCODIGO
                                    AND CO.GLB_TPCLIEND_CODIGODESTINATARI =
                                        EN.GLB_TPCLIEND_CODIGO
                                    AND CO.CON_CONHECIMENTO_NRFORMULARIO IS NOT NULL
                                    AND CO.CON_CONHECIMENTO_FLAGCANCELADO IS NULL
                                    AND CO.CON_CONHECIMENTO_DIGITADO = 'I'
                                    AND EN.GLB_LOCALIDADE_CODIGO =
                                        R_L0CALIDADE.GLB_LOCALIDADE_CODIGO) 
                  LOOP
                      UPDATE T_ARM_MOVIMENTO
                         SET CON_MANIFESTO_CODIGO        = V_SEQUENCIA,
                             CON_MANIFESTO_SERIE         = 'XXX',
                             CON_MANIFESTO_ROTA          = P_ROTA,
                             ARM_MOVIMENTO_MANIF_MARCADO = 'N'
                       WHERE CON_CONHECIMENTO_NUMERO = C_CTRC.CON_CONHECIMENTO_CODIGO
                         AND CON_CONHECIMENTO_SERIE = C_CTRC.CON_CONHECIMENTO_SERIE
                         AND GLB_ROTA_CONHECIMENTO = C_CTRC.GLB_ROTA_CODIGO;
                   END LOOP;                                               
                          */                                                   
            end Loop;  
            
            pStatus := 'N';
            pMessage := 'Manifesto gravado com sucesso.';
        
        Exception
          When Others Then
            pStatus := 'E';
            pMessage := 'Erro ao gravar Manifesto. Carregamento: ' || pCarregamento || ' - ' || sqlerrm;
        End;  
            
  End Sp_Insert_Manifesto;
  
  Function Fn_CiotObrigatorio(pClassAntt In varchar2,
                              pClassEqp In varchar2,
                              pTipoMotorista In varchar2) return Varchar2
  As
  Begin
       
        if (('ETC' = pClassAntt) and ('S' = pClassEqp)) Or
           (('TAC' = pClassAntt) and ('S' = pClassEqp)) then
           
               return 'S';

        elsif ('ETC' = pClassAntt) and ('N' = pClassEqp) then

                return 'N';
        else
            if ((pClassAntt = '') Or (pClassAntt Is null)) and ('FROTA' = pTipoMotorista) then
                
                    return 'N';
                
            elsif ((pClassAntt = '') Or (pClassAntt Is null)) and ('AGREGADO' = pTipoMotorista) then
              
                    return 'S';
            end if;
            return 'X';  
       end if;
  
       return 'N';
  End Fn_CiotObrigatorio;                          
  
  Procedure Sp_GerarManifesto(pXmlIn   In Varchar2,
                              pStatus  Out Char,
                              pMessage Out Varchar2)
  As
  vVeicDisp t_arm_carregamento.fcf_veiculodisp_codigo%Type;
  vVeicSeq  t_arm_carregamento.fcf_veiculodisp_sequencia%Type;
  vUsuario  t_Usu_Usuario.Usu_Usuario_Codigo%Type;
  vRota     t_Glb_Rota.Glb_Rota_Codigo%Type;  
  Begin   

       Begin
            -- Pega o Veiculo que contem os carregamento...
            Select extractvalue(Value(V), 'Input/VeiculoDisp'),
                   extractvalue(Value(V), 'Input/VeiculoSeq'),
                   extractvalue(Value(V), 'Input/Usuario'),
                   extractvalue(Value(V), 'Input/Rota')
                  into vVeicDisp,
                       vVeicSeq,
                       vUsuario,
                       vRota
                 From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;  
                 
            Sp_GerarManifesto(vVeicDisp, vVeicSeq, vUsuario, vRota, pStatus, pMessage);
            
       Exception 
         When Others Then
             Rollback;           
             pStatus := 'E';
             pMessage := 'Erro ao executar Sp_GerarManifesto. '||sqlerrm;           
       End;            

  End Sp_GerarManifesto;     
  
  Procedure Sp_GerarManifesto(pVeicDisp in t_arm_carregamento.fcf_veiculodisp_codigo%Type,
                              pVeicSeq  in t_arm_carregamento.fcf_veiculodisp_sequencia%Type,
                              pUsuario  in t_Usu_Usuario.Usu_Usuario_Codigo%Type,
                              pRota     in t_Glb_Rota.Glb_Rota_Codigo%Type,
                              pStatus  Out Char,
                              pMessage Out Varchar2)
  As
   vContem         Char(1);
   vCount          Integer;
   vMensagen       varchar2(2000);
   vVFCiot         varchar2(20);
   vCLASSANTT      varchar2(10);
   vCLASSEQP       varchar2(10);   
   vTipoMotorista  varchar2(20);
   vValidaGeracaoMDFeComNFS Char(1);
  Begin
      Begin
         /*      
           Select count(*)
             Into vCount
             From t_arm_carregamento c
             Where c.fcf_veiculodisp_codigo = vVeicDisp
               and c.fcf_veiculodisp_sequencia = vVeicSeq;
               
           if vCount > 0 Then
             pStatus := 'N';
             pMessage := 'Atenc?o: Todos os Manifestos Ja foram gerados!';
             return;             
           End if;                    
           */  
           
           vValidaGeracaoMDFeComNFS := Fn_ValidaGeracaoMDFeComNFS(pVeicDisp, pVeicSeq);
           if(vValidaGeracaoMDFeComNFS = 'N') then --'N'=Somnete NFS | 'W'=Gera MDFe
                pStatus := 'W';   
                pMessage := 'Veiculo Contem somente Nota Fiscal de Servico, n?o sera preciso gerar Manifesto para continuar o processo!';
                return;           
           end if;
           
           if Tdvadm.pkg_fifo_manifesto.Fn_Is_MDFe(pRota => pRota) = 'S' then
               -- Raise_Application_Error(-20001, 'MDFe n?o implantado!');
                vContem := Fn_Contem_CTRCNaoEltronico(pVeicDisp, pVeicSeq);
                -- Verifica se tem Conhecimentos n?o eletronicos...    
                if vContem = 'N' then
                  
                    Select Count(*)
                      Into vCount
                      From t_Con_Veicdispmanif vm
                      where vm.fcf_veiculodisp_codigo = pVeicDisp
                        and vm.fcf_veiculodisp_sequencia = pVeicSeq;
                        
                    if vCount <= 0 then    
                         vMensagen := 'Chegou aqui'||pVeicDisp;
                         
                         Select vfc.con_vfreteciot_numero
                           into vVFCiot
                           from t_con_valefrete vf,
                                t_con_vfreteciot vfc
                           where vf.con_conhecimento_codigo       = vfc.con_conhecimento_codigo (+)
                             and vf.con_conhecimento_serie        = vfc.con_conhecimento_serie  (+)
                             and vf.glb_rota_codigo               = vfc.glb_rota_codigo         (+)
                             and vf.con_valefrete_saque           = vfc.con_valefrete_saque     (+)
                             and vf.fcf_veiculodisp_codigo        = pVeicDisp
                             and vf.fcf_veiculodisp_sequencia     = pVeicSeq
                             and nvl(vf.con_valefrete_status,'N') = 'N';   
                         
                         -- validac?o de obrigatoriedade do Ciot p/ gerac?o do manifesto
                         if ( nvl(vVFCiot,'nullo') =  'nullo') then
                           
                                SELECT --ArmAdm.Pkg_Arm_Carregamento.Sp_GetNomeProprietario(vd.fcf_veiculodisp_codigo) Proprietario,
                                       PP.CAR_PROPRIETARIO_CLASSANTT,
                                       PP.CAR_PROPRIETARIO_CLASSEQP,
                                       --PP.CAR_PROPRIETARIO_RNTRCDTVAL,
                                       Pkg_Fcf_Veiculodisp.Fn_Get_TpFrotaAgregadoOutros(VD.FCF_VEICULODISP_CODIGO, VD.FCF_VEICULODISP_SEQUENCIA) FrotaAgreg
                                  INTO  vCLASSANTT,
                                        vCLASSEQP,
                                        vTipoMotorista     
                                  FROM TDVADM.T_FCF_VEICULODISP VD,
                                       tdvadm.T_CAR_VEICULO vca,
                                       tdvadm.T_CAR_PROPRIETARIO PP                                             
                                 WHERE vd.CAR_VEICULO_PLACA              = vca.CAR_VEICULO_PLACA                   (+)
                                   AND vd.CAR_VEICULO_SAQUE        	     = vca.CAR_VEICULO_SAQUE                   (+)
                                   AND vca.CAR_PROPRIETARIO_CGCCPFCODIGO = PP.CAR_PROPRIETARIO_CGCCPFCODIGO        (+)                                           
                                   And vd.fcf_veiculodisp_codigo         = pVeicDisp
                                   and vd.fcf_veiculodisp_sequencia      = pVeicSeq;                                  
                         
                             if (Fn_CiotObrigatorio(vCLASSANTT,vCLASSEQP,vTipoMotorista) = 'S') then
                                   pStatus := 'W';   
                                   pMessage := 'Ciot Obrigatorio!';
                                   return;                                        
                             end if;
                                  
                         end if;
                         
                         Sp_Insert_MDFe(pVeicDisp, pVeicSeq, pRota, pUsuario, pStatus, pMessage, vVFCiot);
                         
                    else
                        pStatus := 'W';   
                        pMessage := 'Veiculo ja possue manifesto Gerado!';
                        return;                      
                    end if;
                    
                    
                    if pStatus = 'E' Then
                       Rollback;
                       Raise_Application_Error(-20001, pMessage);
                    End if;
                 else
                    pStatus := 'W';   
                    pMessage := 'Ha conhecimentos n?o autorizados vinculados a esse veiculo!';
                    return;
                 end if;    
                             
           else
           
                 -- Loop: gera todos os manifesto atraves dos carregamentos veinculados com o mesmo!
                 For carregamento in (    
                                     Select c.arm_carregamento_codigo codigo
                                       From t_arm_carregamento c
                                       Where c.fcf_veiculodisp_codigo = pVeicDisp
                                         and c.fcf_veiculodisp_sequencia = pVeicSeq
                                     )
                 Loop
                     SELECT COUNT(*) 
                         Into vCount
                         FROM T_CON_MANIFESTO MA
                         WHERE MA.ARM_CARREGAMENTO_CODIGO = carregamento.codigo;     
                      -- Verifica se para este carregamento nao foi gerado Manifesto.
                      if 0 = vCount Then    
                         
--                           if Tdvadm.pkg_fifo_manifesto.Fn_Is_MDFe(pRota => pRota) = 'S' then
                               -- ToDo...: Realizar aki condicao na rota para inserir 
                               --          MDFe ou processo atual (pkg_fifo_manifesto.Sp_Insere_MDFe)
                               -- Analista: Diego Lirio                 
--                               Raise_Application_Error(-20001, 'MDFe n?o implantado!');
--                               pkg_fifo_manifesto.Sp_Insere_MDFe(carregamento.codigo, pRota, pUsuario);
--                           else
                               Sp_Insert_Manifesto(carregamento.codigo, pVeicDisp, pVeicSeq, pRota, pUsuario, pStatus, pMessage);                                 
--                           end if;                            
                      
                           if pStatus = 'E' Then
                             Rollback;
                             Raise_Application_Error(-20001, pMessage);
                           End if;
                      End if;
                 End Loop;
             end if;
                 
             pStatus := 'N';
             pMessage := 'Todos os Manifestos Gerados com sucesso!';
             Commit;
       Exception 
         When Others Then
             Rollback;           
             pStatus := 'E';
             pMessage := 'Erro ao Gerar Manifesto. ' ||vMensagen||' - '||dbms_utility.format_error_backtrace;           
       End;    
  End Sp_GerarManifesto;                                                            
  
  Procedure Sp_Get_VeiculosContratados(pArmazem In t_Arm_Armazem.Arm_Armazem_Codigo%Type,
                                       pCursor  Out Types.cursorType)
  As
  Begin
      Open pCursor For
        SELECT Distinct 
               S.FCF_VEICULODISP_CODIGO Veic_codigo,
               S.fcf_veiculodisp_sequencia Veic_sequencia,
               pkg_fifo_ctrc.Fn_GetIndex_ImgEstagio(S.ARM_ESTAGIOCARREGMOB_CODIGO) Veic_Estagio_Mobile,
               Case pkg_fifo_manifesto.fn_manifesto_gerado(s.fcf_veiculodisp_codigo, s.fcf_veiculodisp_sequencia)
                 When 'S' Then 0
                 When 'N' Then 9
               End Manifesto,
               Decode((select count(*)
                         from t_arm_carregamento ca
                        where ca.fcf_veiculodisp_codigo = s.fcf_veiculodisp_codigo
                          and ca.fcf_veiculodisp_sequencia = s.fcf_veiculodisp_sequencia), 0,
                       'Vazio',
                       'Carreg.') Veic_Status, 
               to_char(s.fcf_veiculodisp_data, 'dd/mm/yyyy hh24:mi:ss') Veic_Data,
               to_char((trunc(sysdate) - trunc(s.fcf_veiculodisp_data))) Veic_qtdeDiasDisp,
               FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO,
                                     S.FCF_VEICULODISP_SEQUENCIA) Veic_PLACA,
               pkg_fifo_auxiliar.fn_removeAcentos(FN_BUSCA_MOTORISTAVEICULO(S.FCF_VEICULODISP_CODIGO,
                                                                            S.FCF_VEICULODISP_SEQUENCIA)) Veic_Motorista,
               T.FCF_TPVEICULO_DESCRICAO Veic_Descricao,
               s.fcf_veiculodisp_ufdestino Veic_UfDestino,
               pkg_fifo_auxiliar.fn_removeAcentos(s.usu_usuario_cadastro) Veic_usuCadastro,
               sold.glb_localidade_codigoibge CodIbge
          FROM T_FCF_VEICULODISP S,
               T_FCF_TPVEICULO   T,
               T_FCF_SOLVEIC     SOL,
               T_FCF_SOLVEICDEST SOLD
         Where 0 = 0
           And S.FCF_VEICULODISP_CODIGO = SOL.FCF_VEICULODISP_CODIGO(+)
           AND S.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA(+)
           AND S.FCF_TPVEICULO_CODIGO = T.FCF_TPVEICULO_CODIGO
           AND S.FCF_OCORRENCIA_CODIGO IS NULL
           AND S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL
           AND S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL
           AND SOL.FCF_SOLVEIC_COD = SOLD.FCF_SOLVEIC_COD(+)
           And s.arm_armazem_codigo = Trim(pArmazem)
           And trunc(s.fcf_veiculodisp_data) >= trunc(Sysdate) - Tdvadm.Pkg_Fifo_Ctrc.QtdeDiasDisp;
                 
  End Sp_Get_VeiculosContratados;   
  
  Function Fn_GetXml_MDFe(pArmazem      In t_arm_armazem.arm_armazem_codigo%Type,
                          pCarregamento In t_Arm_Carregamento.Arm_Carregamento_Codigo%Type,
                          pPlaca        In Varchar2,
                          pDataInicio   In Varchar2,
                          pDataFim      In Varchar2,
                          pTF           In Varchar2,
                          pManifSerie   In Varchar2) return Clob
  As
  vXmlRetorno Clob;
  vCount Integer;  
  Begin
        
        
        vXmlRetorno := '';
        vCount := 0;
        For veic_manif_xxx in (     
                            Select Distinct
                                   Tdvadm.Fn_Busca_Placaveiculo(vd.FCF_VEICULODISP_CODIGO, vd.FCF_VEICULODISP_SEQUENCIA) PLACA,
                                   v.fcf_veiculodisp_codigo codigo,
                                   v.fcf_veiculodisp_sequencia sequencia,
                                   vd.fcf_veiculodisp_data data,
                                   nvl(Armadm.Pkg_Arm_Carregamento_Veic.Fn_GetDestinos(v.fcf_veiculodisp_codigo),'N?o encontrados') Destino,
                                   v.con_manifesto_codigo manif_codigo,
                                   v.con_manifesto_serie manif_serie,
                                   v.con_manifesto_rota manif_rota,
                                   m.con_manifesto_codciot ciot,
                                   Case  
                                     When v.con_manifesto_serie = 'XXX' then null
                                     When (v.con_manifesto_serie = 'A1') and (cm.con_mdfestatus_codigo is null) and (log.uti_logmdfe_codigo is not null) then 'RJ' 
                                     When (v.con_manifesto_serie = 'A1') and (cm.con_mdfestatus_codigo is null) then 'AG' 
                                     When cm.con_mdfestatus_codigo is not null then cm.con_mdfestatus_codigo
                                     Else null  
                                   End status           
                              From t_con_veicdispmanif v,
                                   t_arm_carregamento c,
                                   t_fcf_veiculodisp vd,
                                   t_con_manifesto m,
                                   t_con_controlemdfe cm,
                                   t_uti_logmdfe log,
                                   t_con_valefrete vf
                              where v.fcf_veiculodisp_codigo     = c.fcf_veiculodisp_codigo     (+)
                                and v.fcf_veiculodisp_sequencia  = c.fcf_veiculodisp_sequencia  (+)
                                and v.fcf_veiculodisp_codigo     = vd.fcf_veiculodisp_codigo
                                and v.fcf_veiculodisp_sequencia  = vd.fcf_veiculodisp_sequencia
                                and v.con_manifesto_codigo       = m.con_manifesto_codigo
                                and v.con_manifesto_serie        = m.con_manifesto_serie
                                and v.con_manifesto_rota         = m.con_manifesto_rota
                                and m.con_manifesto_codigo       = cm.con_manifesto_codigo      (+)
                                and m.con_manifesto_serie        = cm.con_manifesto_serie       (+)
                                and m.con_manifesto_rota         = cm.con_manifesto_rota        (+)
                                and m.con_manifesto_codigo       = log.uti_logmdfe_codigo       (+)
                                and m.con_manifesto_serie        = log.uti_logmdfe_serie        (+)
                                and m.con_manifesto_rota         = log.uti_logmdfe_rota         (+)                                
                                and vd.arm_armazem_codigo        = pArmazem
                               
                                And Case 
                                    when nvl(cm.con_mdfestatus_codigo,'AG') = 'OK'
                                      then nvl(cm.con_controlemdfe_dtretorno,sysdate)                 
                                    else sysdate
                                End  >= sysdate-2
                                
                                and ((c.arm_carregamento_codigo = pCarregamento and pTF = 'CA') --'442434'
                                  Or (Trim(Tdvadm.Fn_Busca_Placaveiculo(vd.FCF_VEICULODISP_CODIGO, vd.FCF_VEICULODISP_SEQUENCIA)) = pPlaca and pTF = 'PL' and TRUNC(vd.fcf_veiculodisp_data) >= trunc(sysdate-30)) --'JUW6430'
                                  Or (TRUNC(vd.fcf_veiculodisp_data) between pDataInicio and pDataFim and pTF = 'DT')
                                     ) 
                                and trim(v.con_manifesto_serie) = Nvl(pManifSerie, 'XXX')

                                and vd.fcf_veiculodisp_codigo = vf.Fcf_Veiculodisp_Codigo(+)
                                and vd.fcf_veiculodisp_sequencia = vf.fcf_veiculodisp_sequencia(+)
                                                                
                                --and nvl(vf.con_valefrete_impresso, 'N') = 'N'
                                
                                --and vd.fcf_veiculodisp_flagvalefrete is null
                                
                                and nvl(cm.con_mdfestatus_codigo, 'XX') != 'CA'
                                
                              Order by vd.fcf_veiculodisp_data   
                           ) Loop
                     vCount := vCount + 1;                           
                     vXmlRetorno := vXmlRetorno
                                      || '<row num="'            || To_Char(vCount)                        ||'" >'            ||
                                         '<Placa>'               || To_Char(veic_manif_xxx.placa)          || '</Placa>'      ||
                                         '<Codigo>'              || To_Char(veic_manif_xxx.codigo)         || '</Codigo>'     ||
                                         '<Sequencia>'           || To_Char(veic_manif_xxx.sequencia)      || '</Sequencia>'  ||
                                         '<Data>'                || To_Char(veic_manif_xxx.data)           || '</Data>'       ||
                                         '<Destino>'             || To_Char(veic_manif_xxx.Destino)        || '</Destino>'       ||
                                         '<Manifesto>'           || To_Char(veic_manif_xxx.manif_codigo)   || '</Manifesto>'  ||
                                         '<Manif_Serie>'         || To_Char(veic_manif_xxx.manif_serie)    || '</Manif_Serie>'||
                                         '<Manif_Rota>'          || To_Char(veic_manif_xxx.manif_rota)     || '</Manif_Rota>' ||
                                         '<con_manifesto_codciot>'|| To_Char(veic_manif_xxx.ciot)     || '</con_manifesto_codciot>' ||
                                         '<Status>'              || To_Char(veic_manif_xxx.status)         || '</Status>' ||
                                         '</row>';
         End Loop;     

         return vXmlRetorno;
  End Fn_GetXml_MDFe;                          
            
  Procedure Sp_Get_MDFe(pXmlIn  In  Varchar2,
                        pXmlOut Out Clob ,
                        pStatus Out Char,
                        pMessage Out Varchar2)                      
/*  XmlIn de Ex: 
    
   <Parametros>    
      <Input>        
         <Armazem>10</Armazem>        
         <Carregamento></Carregamento>        
         <Placa></Placa>        
         <DataInicio>12/12/2016</DataInicio>        
         <DataFim>12/12/2016</DataFim>        
         <TipoFiltro>DT</TipoFiltro>    
      </Input>
   </Parametros>        
   
    TipoFiltro:
          CA: Filtro por Carregamento        
          PL: Filtro por Placa        
          DT: Filtro por Periodo                            
*/                        
  As
  vCarregamento t_Arm_Carregamento.Arm_Carregamento_Codigo%Type;
  vArmazem      t_arm_armazem.arm_armazem_codigo%Type;
  vPlaca Varchar2(7);
  vRota Char(3);
  vDataInicio Varchar2(10);
  vDataFim Varchar2(10);
  vTF Varchar2(5);  
  vManifXXX Clob;
  vManifAutorizados Clob;
  vXmlRetorno Clob;
  --vCount Integer;
  Begin
    
--  insert into Dropme (a,x) values('MDF-E',pXmlIn);commit;
    
       
    Begin
        Select extractvalue(Value(V), 'Input/Armazem'),
               Nvl(extractvalue(Value(V), 'Input/Carregamento'), '000'),
               trim(extractvalue(Value(V), 'Input/Placa')),
               extractvalue(Value(V), 'Input/DataInicio'),
               extractvalue(Value(V), 'Input/DataFim'),
               extractvalue(Value(V), 'Input/TipoFiltro'),
               extractvalue(Value(V), 'Input/Rota')
              into vArmazem,
                   vCarregamento,
                   vPlaca,
                   vDataInicio,
                   vDataFim,
                   vTF,
                   vRota
             From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;   
             
         if Nvl(vCarregamento,'000') != -1000 then 
             -- Utilizado pelo Fifo
             vManifXXX         := Fn_GetXml_MDFe(vArmazem, vCarregamento, vPlaca, vDataInicio, vDataFim, vTF, 'XXX');
             vManifAutorizados := Fn_GetXml_MDFe(vArmazem, vCarregamento, vPlaca, vDataInicio, vDataFim, vTF, 'A1');
         else
             -- Utilizado pelo MDFeAvulso...                          
             vManifXXX         := Pkg_Con_Mdfeavulso.Fn_GetXml_MDFe(vRota, vPlaca, vDataInicio, vDataFim, vTF, 'XXX');           
             vManifAutorizados := Pkg_Con_Mdfeavulso.Fn_GetXml_MDFe(vRota, vPlaca, vDataInicio, vDataFim, vTF, 'A1');  
         end if;

                         
        --vXmlRetorno := Replace(vXmlRetorno, '#', '"');     
        
        pStatus := 'N';
        pMessage := 'OK';        
        
    /*Select distinct
           c.arm_carregamento_codigo carregamento,
           c.arm_armazem_codigo armazem,
           c.car_veiculo_placa veiculo,
           c.arm_carregamento_mobile mobile,
           c.arm_carregamento_dtfechamento,
           c.arm_carregamento_dtviagem
      From t_con_veicdispmanif vm,
           t_con_manifesto m,
           t_arm_carregamento c
      where vm.con_manifesto_codigo = m.con_manifesto_codigo
        and vm.con_manifesto_serie  = m.con_manifesto_serie
        and vm.con_manifesto_rota   = m.con_manifesto_rota
        and c.arm_carregamento_codigo = m.arm_carregamento_codigo
        and vm.fcf_veiculodisp_codigo in ( Select c.fcf_veiculodisp_codigo
                                           From t_arm_carregamento c
                                           where c.arm_carregamento_codigo = '442434')
        and vm.fcf_veiculodisp_sequencia in ( Select c.fcf_veiculodisp_sequencia
                                                From t_arm_carregamento c
                                                where c.arm_carregamento_codigo = '442434')      ;    */  
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
                                       <Table name="MDFe_Gerados_XXX"><RowSet>'|| vManifXXX         || '</RowSet></Table>
                                       <Table name="MDFe_Gerados_Aut"><RowSet>'|| vManifAutorizados || '</RowSet></Table>
                                 </Tables>
                           </OutPut>
                     </Parametros>';    
    pXmlOut := Pkg_Glb_Common.FN_LIMPA_CAMPocl(vXmlRetorno);     
                                           
  End Sp_Get_MDfe;
  
  Procedure Sp_Get_Carregs(pXmlIn  In  Varchar2,
                           pXmlOut Out Clob ,
                           pStatus Out Char,
                           pMessage Out Varchar2)                      
/*  
    XmlIn de Ex: 
    
        <Parametros>
          <Input>
            <VeiculoDisp>1764554</VeiculoDisp>
            <Sequencia>0</Sequencia>
          </Input>
        </Parametros>                            
*/                        
  As
  vVeicDisp t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%type;
  vVeicSeq  t_Fcf_Veiculodisp.Fcf_Veiculodisp_Sequencia%Type;
  vLinha Clob;
  vXmlRetorno Clob;
  vCount Integer;
  Begin
    
    Begin
        Select extractvalue(Value(V), 'Input/VeiculoDisp'),
               extractvalue(Value(V), 'Input/Sequencia')
              into vVeicDisp,
                   vVeicSeq
             From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;  
         
        vLinha := '';
        vCount := 0;
        For carreg in (     
                                Select c.*,
                                       WSERVICE.PKG_WSD_CARREGAMENTO.FN_GET_DESTINOSOLICITACAO(c.fcf_solveic_cod) Destino
                                  From t_Arm_Carregamento c
                                  where c.fcf_veiculodisp_codigo = vVeicDisp --'1764554'
                                    and c.fcf_veiculodisp_sequencia = vVeicSeq --'0'
                           ) 
        Loop
                     vCount := vCount + 1;                           
                     vLinha := vLinha
                                      || '<row num="'          || To_Char(vCount)                                       ||'" >'                  ||
                                         '<Carregamento>'      || Trim(To_Char(carreg.arm_carregamento_codigo))         || '</Carregamento>'     ||
                                         '<Armazem>'           || Trim(To_Char(carreg.arm_armazem_codigo))              || '</Armazem>'          ||
                                         '<Criou>'             || Trim(To_Char(carreg.usu_usuario_crioucarreg))         || '</Criou>'            ||
                                         '<Data_Fechamento>'   || Trim(To_Char(carreg.arm_carregamento_dtfechamento))   || '</Data_Fechamento>'  ||                                         
                                         '<Data_Finalizacao>'  || Trim(To_Char(carreg.arm_carregamento_dtfinalizacao))  || '</Data_Finalizacao>' ||                                         
                                         '<Destino>'           || Trim(To_Char(carreg.Destino))                         || '</Destino>' ||
                                         '<Mobile>'            || Case Nvl(carreg.arm_carregamento_mobile,'N')
                                                                    when 'N' then 'Nao'
                                                                    when 'S' then 'Sim'
                                                                    else 'Nao'
                                                                  End                                                   || '</Mobile>'           ||
                                         '<Qtde_CTRC>'         || Trim(To_Char(carreg.arm_carregamento_qtdctrc))        || '</Qtde_CTRC>'        ||
                                         '</row>';
         End Loop;             
        
         vXmlRetorno := '<Parametros>
                               <OutPut>
                                     <Tables>
                                           <Table name="CARREGS"><RowSet>'|| vLinha || '</RowSet></Table>
                                     </Tables>
                               </OutPut>
                         </Parametros>';     
                         
        --vXmlRetorno := Replace(vXmlRetorno, '#', '"');     
        pXmlOut := vXmlRetorno;
        
        pStatus := 'N';
        pMessage := 'OK';        
    Exception 
      When Others Then
        pStatus := 'E';
        pMessage := sqlerrm ;
    End;                                                         
  End Sp_Get_Carregs;
  
Procedure Sp_Excluir_Manif(pManifesto Varchar2,
                           pSerie     Varchar2,
                           pRota      Varchar2)
as
Begin                            
                            
      For carreg in (Select doc_m.arm_carregamento_codigo codigo
                       From t_Con_Docmdfe doc_m
                      where doc_m.con_manifesto_codigo = pManifesto
                        and doc_m.con_manifesto_serie = pSerie
                        and doc_m.con_manifesto_rota = pRota)
      Loop
          if carreg.codigo is not null then
            UPDATE T_ARM_CARREGAMENTO c
               SET c.ARM_CARREGAMENTO_DTFINALIZACAO = null
             WHERE c.ARM_CARREGAMENTO_CODIGO = carreg.codigo;                    
          end if;
      End Loop;
                            
      Delete from t_con_docmdfe doc_m
      where doc_m.con_manifesto_codigo = pManifesto
        and doc_m.con_manifesto_serie = pSerie
        and doc_m.con_manifesto_rota = pRota;
        
            
      delete from t_con_veicdispmanif  v 
        where v.con_manifesto_codigo = pManifesto
          and v.con_manifesto_serie = pSerie
          and v.con_manifesto_rota = pRota;        
                            
      DELETE T_CON_MANIFESTO m
        where m.con_manifesto_codigo = pManifesto
          and m.con_manifesto_serie = pSerie
          and m.con_manifesto_rota = pRota; 
           
End Sp_Excluir_Manif;      
  
  Procedure Sp_Excluir_Manifesto(pXmlIn In Varchar2,
                                 pStatus Out Char,
                                 pMessage Out Varchar2)
  -- Exclui o Manifesto...                                  
  As  
  vVeicDisp t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type;
  vVeicSeq  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type;
  vCount Integer;
  --vCarregamento t_Arm_Carregamento.Arm_Carregamento_Codigo%type;
  Begin
       
        Select extractvalue(Value(V), 'Input/VeiculoDisp'),
               extractvalue(Value(V), 'Input/VeiculoSeq')
              into vVeicDisp,
                   vVeicSeq
             From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;  
     
        Select count(*)
          Into vCount
          From t_con_veicdispmanif v
          where v.fcf_veiculodisp_codigo = vVeicDisp
            and v.fcf_veiculodisp_sequencia = vVeicSeq
            and v.con_manifesto_serie = 'A1';
  
        If vCount > 0 then
           pStatus := 'E';
           pMessage := 'Existem manifesto autorizados vinculados a este veiculo. Para continuar o processo cancele a Autorizac?o de todos!';
           return;
        end if;
  
        Begin       
            For manifs in ( Select *
                              from t_con_veicdispmanif  v 
                              where v.fcf_veiculodisp_codigo = vVeicDisp
                                and v.fcf_veiculodisp_sequencia = vVeicSeq)
            Loop 
              
                --if manifs.con_manifesto_serie = 'XXX' then                    
            
                   /*
                        delete from t_con_veicdispmanif  v 
                          where v.con_manifesto_codigo = manifs.con_manifesto_codigo
                            and v.con_manifesto_serie = manifs.con_manifesto_serie
                            and v.con_manifesto_rota = manifs.con_manifesto_rota;
                            
                            
                        For carreg in (Select doc_m.arm_carregamento_codigo codigo
                                         From t_Con_Docmdfe doc_m
                                        where doc_m.con_manifesto_codigo = manifs.con_manifesto_codigo
                                          and doc_m.con_manifesto_serie = manifs.con_manifesto_serie
                                          and doc_m.con_manifesto_rota = manifs.con_manifesto_rota)
                        Loop
                              UPDATE T_ARM_CARREGAMENTO c
                                 SET c.ARM_CARREGAMENTO_DTFINALIZACAO = null
                               WHERE c.ARM_CARREGAMENTO_CODIGO = carreg.codigo;                    
                        End Loop;
                            
                        Delete from t_con_docmdfe doc_m
                          where doc_m.con_manifesto_codigo = manifs.con_manifesto_codigo
                            and doc_m.con_manifesto_serie = manifs.con_manifesto_serie
                            and doc_m.con_manifesto_rota = manifs.con_manifesto_rota;
                            
                        DELETE T_CON_MANIFESTO m
                          where m.con_manifesto_codigo = manifs.con_manifesto_codigo
                            and m.con_manifesto_serie = manifs.con_manifesto_serie
                            and m.con_manifesto_rota = manifs.con_manifesto_rota;
                     */
                     pkg_fifo_manifesto.Sp_Excluir_Manif(manifs.con_manifesto_codigo,
                                                         manifs.con_manifesto_serie,
                                                         manifs.con_manifesto_rota);
                                                             
                 --else
                 --  Raise_Application_Error(-20001, 'Existem manifestos na serie A1, cancele a autorizac?o de todos vinculado a esse veiculo.');        
                 --end if;           
            End Loop; 
            
            Commit; 
            pStatus := 'N';
            pMessage := 'Manifestos Cancelados com sucesso';              
        Exception
          When Others Then
            Rollback;
            pStatus := 'E';
            pMessage := substr(sqlerrm, 1, 2000);
        End;  
                
  End Sp_Excluir_Manifesto;   
  
  function Fn_ValeFreteGerado_MDFe(pManifesto Varchar2,
                                   pSerie     Varchar2,
                                   pRota      Varchar2) return Char
  As                                   
-- Analista: Diego Lirio
-- Criado: 30/06/2013
-- Funcionalidade: Verifica se Veiculo Esta com Vale de Frete gerado atraves do MDFe....      
-- Referencia: Tdvadm.Pkg_Con_Manifesto.Fn_Manifesto_Gerado(pVeicDisp,pVeicSeq)                                      
  vCount Integer;
  Begin
        Select count(*)
          Into vCount
          From t_con_veicdispmanif v,
               t_fcf_veiculodisp vd
          where v.con_manifesto_codigo = pManifesto
            and v.con_manifesto_serie  = pSerie
            and v.con_manifesto_rota   = pRota
            and v.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
            and v.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
            and Nvl(vd.fcf_veiculodisp_flagvalefrete, 'N') = 'S';   
        if vCount > 0 then
            return 'S';
        else
            return 'N';
        end if;    
  End Fn_ValeFreteGerado_MDFe; 
  
  function Fn_ValeFreteGerado(pVeiculoDisp T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                              pSequencia   T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE) return Char
  As
-- Analista: Diego Lirio
-- Criado: 26/06/2013
-- Funcionalidade: Verifica se Veiculo Esta com Vale de Frete gerado....      
-- Referencia: Tdvadm.Pkg_Con_Manifesto.Fn_Manifesto_Gerado(pVeicDisp,pVeicSeq)    
  vCount Integer;
  Begin
        Select count(*)
          Into vCount
          From t_con_veicdispmanif v,
               t_fcf_veiculodisp vd
          where 0=0
            and v.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
            and v.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia          
            and v.fcf_veiculodisp_codigo = pVeiculoDisp
            and v.fcf_veiculodisp_sequencia = pSequencia
            and Nvl(vd.fcf_veiculodisp_flagvalefrete, 'N') = 'S';   
        if vCount > 0 then
            return 'S';
        else
            return 'N';
        end if;    
  End Fn_ValeFreteGerado;       
  
  Procedure Sp_Solicitar_Autorizacao(pXmlIn   In  Varchar2,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2)As
 


/*
 <Parametros>   
    <Input>      
        <Manifesto>503905</Manifesto>      
        <Serie>XXX</Serie>      
        <Rota>021</Rota>   
    </Input>
 </Parametros>
*/  
  vStatus           char(1);
  vMessage          varchar2(2000);
  vManifesto        tdvadm.t_Con_Manifesto.Con_Manifesto_Codigo%Type;
  vSerie            tdvadm.t_Con_Manifesto.Con_Manifesto_Serie%Type;
  vRota             tdvadm.t_con_manifesto.con_manifesto_rota%Type;   
  vRowManifesto     tdvadm.t_con_manifesto%RowType;
  vNewNumberManif   Varchar2(10);
  --vCount Integer;
  Begin
       Select extractvalue(Value(V), 'Input/Manifesto'),
              extractvalue(Value(V), 'Input/Serie'),
              extractvalue(Value(V), 'Input/Rota')
         into vManifesto,
              vSerie,
              vRota
        From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V; 
         
       Begin   
        if vSerie != 'XXX' then
            pStatus := 'E';
            pMessage := 'N?o e Possivel Solicitar Autorizac?o desse manifesto porque o mesmo esta na Serie: '||vSerie; 
            return;
        end if;  
        
 
/*        
        if pkg_fifo_manifesto.Fn_ValeFreteGerado_MDFe(vManifesto, vSerie, vRota) = 'S' then
            pStatus := 'W';
            pMessage := 'Manifesto com este veiculo ja esta com Vale Frete Gerado!';
            return;
        end if;*/
            
        Select *
          Into vRowManifesto
          From tdvadm.t_con_manifesto m
         where m.con_manifesto_codigo = vManifesto
           and m.con_manifesto_serie = vSerie
           and m.con_manifesto_rota = vRota;  
            
        vNewNumberManif := Fn_Get_NumeroManifesto(vRota);
            
         insert into tdvadm.t_con_manifesto 
                           Values( vNewNumberManif
                                  ,'A1'    
                                  ,vRowManifesto.Con_Manifesto_Rota
                                  ,vRowManifesto.usu_usuario_codigo
                                  ,vRowManifesto.CON_MANIFESTO_USUARIO_IMPRESSO
                                  ,vRowManifesto.con_manifesto_placa
                                  ,vRowManifesto.con_manifesto_placasaque
                                  ,vRowManifesto.con_manifesto_dtemissao
                                  ,vRowManifesto.con_manifesto_pesonf
                                  ,vRowManifesto.con_manifesto_pesocobrado
                                  ,vRowManifesto.con_manifesto_vlrmercadoria
                                  ,vRowManifesto.con_manifesto_vlrfrete
                                  ,vRowManifesto.con_manifesto_obs
                                  ,vRowManifesto.con_manifesto_cpfmotorista
                                  ,vRowManifesto.con_manifesto_cubagemtotal
                                  ,vRowManifesto.con_manifesto_dtcriacao
                                  ,vRowManifesto.car_tpveiculo_codigo
                                  ,vRowManifesto.con_manifesto_quantitensnf
                                  ,vRowManifesto.glb_tpmotorista_codigo
                                  ,vRowManifesto.con_manifesto_status
                                  ,vRowManifesto.con_manifesto_destinatario
                                  ,vRowManifesto.glb_tpcliend_codigo
                                  ,vRowManifesto.arm_armazem_codigo
                                  ,vRowManifesto.con_manifesto_dtchegada
                                  ,vRowManifesto.con_manifesto_dtrecebimento
                                  ,vRowManifesto.con_manifesto_avarias
                                  ,vRowManifesto.con_manifesto_dtchegcelula
                                  ,vRowManifesto.con_manifesto_dtcheckin
                                  ,vRowManifesto.con_manifesto_dtgravcheckin
                                  ,vRowManifesto.arm_carregamento_codigo
                                  ,vRowManifesto.con_manifesto_localidade
                                  ,vRowManifesto.con_manifesto_ufdestino
                                  ,vRowManifesto.Con_Manifesto_Codciot);  
                                  
          Update tdvadm.t_Con_Veicdispmanif vdm
             set vdm.con_manifesto_codigo = vNewNumberManif,
                 vdm.con_manifesto_serie  = 'A1'
           where vdm.con_manifesto_codigo = vManifesto
             and vdm.con_manifesto_serie  = vSerie
             and vdm.con_manifesto_rota   = vRota;
              
          Update tdvadm.t_con_docmdfe dm
             set dm.con_manifesto_codigo = vNewNumberManif,
                 dm.con_manifesto_serie  = 'A1'
           where dm.con_manifesto_codigo = vManifesto
             and dm.con_manifesto_serie  = vSerie
             and dm.con_manifesto_rota   = vRota;     
              
          Delete tdvadm.t_con_manifesto mm
           where mm.con_manifesto_codigo = vManifesto
             and mm.con_manifesto_serie  = vSerie
             and mm.con_manifesto_rota   = vRota;    
           
          tdvadm.Pkg_Con_Mdfe.sp_Con_MdfeGeraChave(vNewNumberManif, 
                                                   'A1', 
                                                   vRota, 
                                                   pStatus, 
                                                   pMessage); 
          
          tdvadm.pkg_con_mdfe.Sp_Con_ValidaMdfe(vNewNumberManif, 
                                                'A1', 
                                                vRota, 
                                                vStatus, 
                                                vMessage);
          
          if (vStatus != 'N') then
             
             pStatus  := 'N';
             pMessage := 'Manifesto: ' || vManifesto || ' solicitado com sucesso.'||chr(13)||
                         'Novo Numero: ' || vNewNumberManif ||Chr(13)||' Serie: A1. ' ||vMessage;
          
          else
            
             pStatus  := 'N';
             pMessage := 'Manifesto: ' || vManifesto || ' solicitado com sucesso.'||chr(13)||
                         'Novo Numero: ' || vNewNumberManif ||Chr(13)||' Serie: A1';
              
          end if;  
                
         
                       
          Commit;                                                                   
          Exception When Others Then
              RollBack;
              pStatus := 'E';
              pMessage := 'Erro na tentativa de solicitar uma autorizac?o do Manifesto: ' ||
                            vManifesto || Chr(13) ||
                            'Novo: ' || vNewNumberManif  || ' - ' || sqlerrm;
          End;      
                
  End Sp_Solicitar_Autorizacao;                                                        
  
Procedure Sp_Get_StatusAutorizacao(pXmlIn In Varchar2,
                                   pXmlOut Out Clob,
                                   pStatus Out Char,
                                   pMessage Out Varchar2)

As
vManifesto t_con_controlemdfe.con_manifesto_codigo%Type;
vSerie     t_con_controlemdfe.con_manifesto_codigo%Type;
vRota      t_con_controlemdfe.con_manifesto_codigo%Type;
vXmlRetorno Clob;
vCount      Integer;   
vLinha      Clob;

vCodigoCancelAutorizacao t_con_mdfemensagen.con_mdfemensagen_codigo%Type;
vUFDestino t_con_manifesto.con_manifesto_ufdestino%type;
vUFOrigem  t_glb_rota.glb_estado_codigo%Type;
vPlaca     Char(7);

Begin
  
       Select trim(extractvalue(Value(V), 'Input/Manifesto')),
              trim(extractvalue(Value(V), 'Input/Serie')),
              trim(extractvalue(Value(V), 'Input/Rota'))
             into vManifesto,
                  vSerie,
                  vRota
            From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V; 


      vLinha := '';
      vCount := 0;  
      -- Verifica o Codigo do Erro.
          Begin
              Select nvl(ma.con_mdfemensagen_codigo,0) codigo_cancelar_autorizacao,
                     m.con_manifesto_placa Placa,
                     m.con_manifesto_ufdestino destino,
                     rt.glb_estado_codigo origem
                 Into vCodigoCancelAutorizacao,
                      vPlaca,
                      vUFDestino,
                      vUFOrigem
                 From t_Con_Controlemdfe c,
                      t_con_mdfestatus   s,
                      t_con_mdfemensagen ma,
                      t_con_manifesto m,
                      T_GLB_ROTA RT
                 Where c.con_mdfestatus_codigo     = s.con_mdfestatus_codigo
                   and c.con_controlemdfe_codstenv = ma.con_mdfemensagen_codigo(+)                       
                   and c.con_manifesto_codigo      = m.con_manifesto_codigo
                   and c.con_manifesto_serie       = m.con_manifesto_serie
                   and c.con_manifesto_rota        = m.con_manifesto_rota
                   and rt.glb_rota_codigo          = m.con_manifesto_rota
                   --and ma.con_mdfemensagen_codigo = '610'                       
                   and trim(c.con_manifesto_codigo) = vManifesto
                   and trim(c.con_manifesto_serie)  = vSerie
                   and trim(c.con_manifesto_rota)   = vRota;
           Exception
             When Others Then
               vCodigoCancelAutorizacao := 0;
           End;         
      -- Se for de n?o encerramento mostra o Manifesto nao encerrado.     
      -- Retorna os manifesto em Aberto

       for status in (
                       Select  s.con_mdfestatus_codigo    ||' - '|| s.con_mdfestatus_descricao status_atual_tdv,
                               ma.con_mdfemensagen_codigo ||' - '||ma.con_mdfemensagen_descricao || ' (' ||to_char(c.con_controlemdfe_dtretorno, 'dd/MM/yyyy hh24:mi:ss')||')' autorizacao,
                               Decode(nvl(c.con_controlemdfe_dtretcancel, '11/11/1111'),'11/11/1111','', mc.con_mdfemensagen_codigo ||' - '||mc.con_mdfemensagen_descricao || ' (' ||to_char(c.con_controlemdfe_dtretcancel, 'dd/MM/yyyy hh24:mi:ss')||')') cancelamento,
                               Decode(nvl(c.con_controlemdfe_dtretencerra, '11/11/1111'),'11/11/1111','', me.con_mdfemensagen_codigo ||' - '||me.con_mdfemensagen_descricao || ' (' ||to_char(c.con_controlemdfe_dtretencerra, 'dd/MM/yyyy hh24:mi:ss')||')') encerramento
                         From t_Con_Controlemdfe c,
                              t_con_mdfestatus   s,
                              t_con_mdfemensagen ma,
                              t_con_mdfemensagen mc,
                              t_con_mdfemensagen me
                         Where c.con_mdfestatus_codigo          = s.con_mdfestatus_codigo
                           and c.con_controlemdfe_codstenv      = ma.con_mdfemensagen_codigo(+)
                           and c.con_controlemdfe_codstcancel   = mc.con_mdfemensagen_codigo(+)
                           and c.con_controlemdfe_codstencerra  = me.con_mdfemensagen_codigo(+)
                           and trim(c.con_manifesto_codigo) = vManifesto
                           and trim(c.con_manifesto_serie)  = vSerie
                           and trim(c.con_manifesto_rota)   = vRota
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(status.status_atual_tdv)) || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim(status.autorizacao))      || '</Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim(status.cancelamento))     || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(status.encerramento))     || '</Encerramento>' ||
                              '</row>';      
       End Loop;

   if vCodigoCancelAutorizacao in ('610','462','611','662') then
       for manifesto in (
           SELECT 'Documento pendente de encerramento.:' ||trim(L.CON_MANIFESTO_CODIGO)||'-'||trim(L.CON_MANIFESTO_SERIE)||' - '||trim(L.CON_MANIFESTO_ROTA) Documento,
                       RT.GLB_ESTADO_CODIGO         Uf_Origem,
                       L.CON_MANIFESTO_UFDESTINO    Uf_Destino
                  fROM T_CON_MANIFESTO L,
                       T_CON_CONTROLEMDFE CC,
                       T_CON_MDFESTATUS ST,
                       T_GLB_ROTA RT
                  WHERE L.CON_MANIFESTO_CODIGO                              = CC.CON_MANIFESTO_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = CC.CON_MANIFESTO_SERIE
                    AND L.CON_MANIFESTO_ROTA                                = CC.CON_MANIFESTO_ROTA
                    AND CC.CON_MDFESTATUS_CODIGO                            = ST.CON_MDFESTATUS_CODIGO
                    AND L.CON_MANIFESTO_ROTA                                = RT.GLB_ROTA_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = 'A1'
                    AND PKG_CON_MDFE.fn_Con_MdfeTpAmb(L.CON_MANIFESTO_ROTA) = '1'
                    AND CC.CON_MDFESTATUS_CODIGO   IN ('EE','OK')
                    AND L.CON_MANIFESTO_PLACA      IN (vPlaca)
                    --AND RT.GLB_ESTADO_CODIGO       = vUFOrigem
                    --AND L.CON_MANIFESTO_UFDESTINO  = vUFDestino
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(manifesto.Documento))     || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim('UF Origem: '  || manifesto.uf_origem))     || '                                                        </Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim('UF Destino: ' ||manifesto.uf_destino))    || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(''))                      || '</Encerramento>' ||
                              '</row>';      
       End Loop;  
   end if; 
   
   if vCodigoCancelAutorizacao in ('686') then
       for manifesto in (
           SELECT 'Documento pendente de encerramento.:' ||trim(L.CON_MANIFESTO_CODIGO)||'-'||trim(L.CON_MANIFESTO_SERIE)||' - '||trim(L.CON_MANIFESTO_ROTA) Documento,
                       RT.GLB_ESTADO_CODIGO         Uf_Origem,
                       L.CON_MANIFESTO_UFDESTINO    Uf_Destino
                  fROM TDVADM.T_CON_MANIFESTO L,
                       TDVADM.T_CON_CONTROLEMDFE CC,
                       TDVADM.T_CON_MDFESTATUS ST,
                       TDVADM.T_GLB_ROTA RT
                  WHERE L.CON_MANIFESTO_CODIGO                              = CC.CON_MANIFESTO_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = CC.CON_MANIFESTO_SERIE
                    AND L.CON_MANIFESTO_ROTA                                = CC.CON_MANIFESTO_ROTA
                    AND CC.CON_MDFESTATUS_CODIGO                            = ST.CON_MDFESTATUS_CODIGO
                    AND L.CON_MANIFESTO_ROTA                                = RT.GLB_ROTA_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = 'A1'
                    AND PKG_CON_MDFE.fn_Con_MdfeTpAmb(L.CON_MANIFESTO_ROTA) = '1'
                    AND CC.CON_MDFESTATUS_CODIGO                            IN ('EE','OK')
                    AND (TRUNC(SYSDATE) - CC.CON_CONTROLEMDFE_DTGRAV)       >= 30
                    AND CC.CON_CONTROLEMDFE_DTGRAV                          >= '01/06/2017'
                    AND CC.CON_MANIFESTO_ROTA	                               = vRota
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(manifesto.Documento))     || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim('UF Origem: '  || manifesto.uf_origem))     || '                                                        </Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim('UF Destino: ' ||manifesto.uf_destino))    || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(''))                      || '</Encerramento>' ||
                              '</row>';      
       End Loop;  
   end if;     
   
   -- Log Controle de Cancelamento TDV.
       for log in (
                       Select  lm.uti_logmdfe_logerro status_atual_tdv,
                               '' autorizacao,
                               '' cancelamento,
                               '' encerramento
                         From t_uti_logmdfe lm
                         where trim(lm.uti_logmdfe_codigo) = vManifesto
                           and trim(lm.uti_logmdfe_serie)  = vSerie
                           and trim(lm.uti_logmdfe_rota)   = vRota
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(log.status_atual_tdv)) || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim(log.autorizacao))      || '</Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim(log.cancelamento))     || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(log.encerramento))     || '</Encerramento>' ||
                              '</row>';      
       End Loop;      
   -- Sem Log/Mensagem
   if vCount = 0 then
             vLinha := vLinha
                       || '<row num="'              || To_Char(vCount)                      || '" >'  ||
                              '<Status_Atual_TDV>'  || 'Sem Log' || '</Status_Atual_TDV>'   ||
                              '<Autorizacao>'       || ''        || '</Autorizacao>'        ||                              
                              '<Cancelamento>'      || ''        || '</Cancelamento>'       ||                              
                              '<Encerramento>'      || ''        || '</Encerramento>'       ||
                          '</row>';       
   end if;
   
   pStatus := 'N';
   pMessage := 'OK';     
       
   vXmlRetorno :=               '<Parametros>';
   vXmlRetorno := vXmlRetorno ||     '<OutPut>';
   vXmlRetorno := vXmlRetorno ||          '<Status>' ||pStatus ||'</Status>';
   vXmlRetorno := vXmlRetorno ||          '<Message>'||pMessage||'</Message>';   
   vXmlRetorno := vXmlRetorno ||          '<Tables>';
   vXmlRetorno := vXmlRetorno ||               '<Table name="Status"><RowSet>'|| vLinha || '</RowSet></Table>';
   vXmlRetorno := vXmlRetorno ||          '</Tables>';
   vXmlRetorno := vXmlRetorno ||     '</OutPut>';
   vXmlRetorno := vXmlRetorno ||'</Parametros>';          
   
   pXmlOut := PKG_GLB_COMMON.FN_LIMPA_CAMPO(vXmlRetorno);

End Sp_Get_StatusAutorizacao;

Procedure Sp_Get_StatusAutorizacaoPlaca(pXmlIn In Varchar2,
                                        pXmlOut Out Clob,
                                        pStatus Out Char,
                                        pMessage Out Varchar2)

As
vManifesto t_con_controlemdfe.con_manifesto_codigo%Type;
vSerie     t_con_controlemdfe.con_manifesto_codigo%Type;
vRota      t_con_controlemdfe.con_manifesto_codigo%Type;
vXmlRetorno Clob;
vCount      Integer;   
vLinha      Clob;

vCodigoCancelAutorizacao t_con_mdfemensagen.con_mdfemensagen_codigo%Type;
vUFDestino t_con_manifesto.con_manifesto_ufdestino%type;
vUFOrigem  t_glb_rota.glb_estado_codigo%Type;
vPlaca     Char(7);

Begin
  
       Select trim(extractvalue(Value(V), 'Input/Manifesto')),
              trim(extractvalue(Value(V), 'Input/Serie')),
              trim(extractvalue(Value(V), 'Input/Rota')),
              trim(extractvalue(Value(V), 'Input/Placa'))
             into vManifesto,
                  vSerie,
                  vRota,
                  vPlaca
            From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V; 


      vLinha := '';
      vCount := 0;  
      -- Verifica o Codigo do Erro.
      If nvl(vManifesto,'NAOPASSADO') <> 'NAOPASSADO' Then
          Begin
              Select nvl(ma.con_mdfemensagen_codigo,0) codigo_cancelar_autorizacao,
                     m.con_manifesto_placa Placa,
                     m.con_manifesto_ufdestino destino,
                     rt.glb_estado_codigo origem
                 Into vCodigoCancelAutorizacao,
                      vPlaca,
                      vUFDestino,
                      vUFOrigem
                 From t_Con_Controlemdfe c,
                      t_con_mdfestatus   s,
                      t_con_mdfemensagen ma,
                      t_con_manifesto m,
                      T_GLB_ROTA RT
                 Where c.con_mdfestatus_codigo     = s.con_mdfestatus_codigo
                   and c.con_controlemdfe_codstenv = ma.con_mdfemensagen_codigo(+)                       
                   and c.con_manifesto_codigo      = m.con_manifesto_codigo
                   and c.con_manifesto_serie       = m.con_manifesto_serie
                   and c.con_manifesto_rota        = m.con_manifesto_rota
                   and rt.glb_rota_codigo          = m.con_manifesto_rota
                   --and ma.con_mdfemensagen_codigo = '610'                       
                   and trim(c.con_manifesto_codigo) = vManifesto
                   and trim(c.con_manifesto_serie)  = vSerie
                   and trim(c.con_manifesto_rota)   = vRota;
           Exception
             When Others Then
               vCodigoCancelAutorizacao := 0;
           End;         
      -- Se for de n?o encerramento mostra o Manifesto nao encerrado.     
      -- Retorna os manifesto em Aberto

       for status in (
                       Select  s.con_mdfestatus_codigo    ||' - '|| s.con_mdfestatus_descricao status_atual_tdv,
                               ma.con_mdfemensagen_codigo ||' - '||ma.con_mdfemensagen_descricao || ' (' ||to_char(c.con_controlemdfe_dtretorno, 'dd/MM/yyyy hh24:mi:ss')||')' autorizacao,
                               Decode(nvl(c.con_controlemdfe_dtretcancel, '11/11/1111'),'11/11/1111','', mc.con_mdfemensagen_codigo ||' - '||mc.con_mdfemensagen_descricao || ' (' ||to_char(c.con_controlemdfe_dtretcancel, 'dd/MM/yyyy hh24:mi:ss')||')') cancelamento,
                               Decode(nvl(c.con_controlemdfe_dtretencerra, '11/11/1111'),'11/11/1111','', me.con_mdfemensagen_codigo ||' - '||me.con_mdfemensagen_descricao || ' (' ||to_char(c.con_controlemdfe_dtretencerra, 'dd/MM/yyyy hh24:mi:ss')||')') encerramento
                         From t_Con_Controlemdfe c,
                              t_con_mdfestatus   s,
                              t_con_mdfemensagen ma,
                              t_con_mdfemensagen mc,
                              t_con_mdfemensagen me
                         Where c.con_mdfestatus_codigo          = s.con_mdfestatus_codigo
                           and c.con_controlemdfe_codstenv      = ma.con_mdfemensagen_codigo(+)
                           and c.con_controlemdfe_codstcancel   = mc.con_mdfemensagen_codigo(+)
                           and c.con_controlemdfe_codstencerra  = me.con_mdfemensagen_codigo(+)
                           and trim(c.con_manifesto_codigo) = vManifesto
                           and trim(c.con_manifesto_serie)  = vSerie
                           and trim(c.con_manifesto_rota)   = vRota
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(status.status_atual_tdv)) || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim(status.autorizacao))      || '</Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim(status.cancelamento))     || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(status.encerramento))     || '</Encerramento>' ||
                              '</row>';      
       End Loop;
   End If;      

   if ( vCodigoCancelAutorizacao in ('610','462','611','662') and nvl(vPlaca,'NPASSAD') <> 'NPASSAD' ) or
      ( nvl(vManifesto,'NAOPASSADO') = 'NAOPASSADO' and nvl(vPlaca,'NPASSAD') <> 'NPASSAD' ) then
       for manifesto in (
           SELECT 'Documento pendente de encerramento.:' ||trim(L.CON_MANIFESTO_CODIGO)||'-'||trim(L.CON_MANIFESTO_SERIE)||' - '||trim(L.CON_MANIFESTO_ROTA) Documento,
                       RT.GLB_ESTADO_CODIGO         Uf_Origem,
                       L.CON_MANIFESTO_UFDESTINO    Uf_Destino
                  fROM T_CON_MANIFESTO L,
                       T_CON_CONTROLEMDFE CC,
                       T_CON_MDFESTATUS ST,
                       T_GLB_ROTA RT
                  WHERE L.CON_MANIFESTO_CODIGO                              = CC.CON_MANIFESTO_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = CC.CON_MANIFESTO_SERIE
                    AND L.CON_MANIFESTO_ROTA                                = CC.CON_MANIFESTO_ROTA
                    AND CC.CON_MDFESTATUS_CODIGO                            = ST.CON_MDFESTATUS_CODIGO
                    AND L.CON_MANIFESTO_ROTA                                = RT.GLB_ROTA_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = 'A1'
                    AND PKG_CON_MDFE.fn_Con_MdfeTpAmb(L.CON_MANIFESTO_ROTA) = '1'
                    AND CC.CON_MDFESTATUS_CODIGO   IN ('EE','OK')
                    AND L.CON_MANIFESTO_PLACA      IN (vPlaca)
                    --AND RT.GLB_ESTADO_CODIGO       = vUFOrigem
                    --AND L.CON_MANIFESTO_UFDESTINO  = vUFDestino
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(manifesto.Documento))     || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim('UF Origem: '  || manifesto.uf_origem))     || '                                                        </Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim('UF Destino: ' ||manifesto.uf_destino))    || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(''))                      || '</Encerramento>' ||
                              '</row>';      
       End Loop;  
   end if; 
   
   if vCodigoCancelAutorizacao in ('686') and nvl(vRota,'999') <> '999' then
       for manifesto in (
           SELECT 'Documento pendente de encerramento.:' ||trim(L.CON_MANIFESTO_CODIGO)||'-'||trim(L.CON_MANIFESTO_SERIE)||' - '||trim(L.CON_MANIFESTO_ROTA) Documento,
                       RT.GLB_ESTADO_CODIGO         Uf_Origem,
                       L.CON_MANIFESTO_UFDESTINO    Uf_Destino
                  fROM TDVADM.T_CON_MANIFESTO L,
                       TDVADM.T_CON_CONTROLEMDFE CC,
                       TDVADM.T_CON_MDFESTATUS ST,
                       TDVADM.T_GLB_ROTA RT
                  WHERE L.CON_MANIFESTO_CODIGO                              = CC.CON_MANIFESTO_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = CC.CON_MANIFESTO_SERIE
                    AND L.CON_MANIFESTO_ROTA                                = CC.CON_MANIFESTO_ROTA
                    AND CC.CON_MDFESTATUS_CODIGO                            = ST.CON_MDFESTATUS_CODIGO
                    AND L.CON_MANIFESTO_ROTA                                = RT.GLB_ROTA_CODIGO
                    AND L.CON_MANIFESTO_SERIE                               = 'A1'
                    AND PKG_CON_MDFE.fn_Con_MdfeTpAmb(L.CON_MANIFESTO_ROTA) = '1'
                    AND CC.CON_MDFESTATUS_CODIGO                            IN ('EE','OK')
                    AND (TRUNC(SYSDATE) - CC.CON_CONTROLEMDFE_DTGRAV)       >= 30
                    AND CC.CON_CONTROLEMDFE_DTGRAV                          >= '01/06/2017'
                    AND CC.CON_MANIFESTO_ROTA	                               = vRota
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(manifesto.Documento))     || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim('UF Origem: '  || manifesto.uf_origem))     || '                                                        </Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim('UF Destino: ' ||manifesto.uf_destino))    || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(''))                      || '</Encerramento>' ||
                              '</row>';      
       End Loop;  
   end if;     
   
   -- Log Controle de Cancelamento TDV.
   If nvl(vManifesto,'NAOPASSADO') <> 'NAOPASSADO' Then   
       for log in (
                       Select  lm.uti_logmdfe_logerro status_atual_tdv,
                               '' autorizacao,
                               '' cancelamento,
                               '' encerramento
                         From t_uti_logmdfe lm
                         where trim(lm.uti_logmdfe_codigo) = vManifesto
                           and trim(lm.uti_logmdfe_serie)  = vSerie
                           and trim(lm.uti_logmdfe_rota)   = vRota
                     )
       Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                           || '<row num="'              || To_Char(vCount)                        || '" >'             ||
                                  '<Status_Atual_TDV>'  || To_Char(trim(log.status_atual_tdv)) || '</Status_Atual_TDV>'   ||
                                  '<Autorizacao>'       || To_Char(trim(log.autorizacao))      || '</Autorizacao>'  ||                              
                                  '<Cancelamento>'      || To_Char(trim(log.cancelamento))     || '</Cancelamento>' ||                              
                                  '<Encerramento>'      || To_Char(trim(log.encerramento))     || '</Encerramento>' ||
                              '</row>';      
       End Loop;      
   End If;
   -- Sem Log/Mensagem
   if vCount = 0 then
             vLinha := vLinha
                       || '<row num="'              || To_Char(vCount)                      || '" >'  ||
                              '<Status_Atual_TDV>'  || 'Sem Log' || '</Status_Atual_TDV>'   ||
                              '<Autorizacao>'       || ''        || '</Autorizacao>'        ||                              
                              '<Cancelamento>'      || ''        || '</Cancelamento>'       ||                              
                              '<Encerramento>'      || ''        || '</Encerramento>'       ||
                          '</row>';       
   end if;
   
   pStatus := 'N';
   pMessage := 'OK';     
       
   vXmlRetorno :=               '<Parametros>';
   vXmlRetorno := vXmlRetorno ||     '<OutPut>';
   vXmlRetorno := vXmlRetorno ||          '<Status>' ||pStatus ||'</Status>';
   vXmlRetorno := vXmlRetorno ||          '<Message>'||pMessage||'</Message>';   
   vXmlRetorno := vXmlRetorno ||          '<Tables>';
   vXmlRetorno := vXmlRetorno ||               '<Table name="Status"><RowSet>'|| vLinha || '</RowSet></Table>';
   vXmlRetorno := vXmlRetorno ||          '</Tables>';
   vXmlRetorno := vXmlRetorno ||     '</OutPut>';
   vXmlRetorno := vXmlRetorno ||'</Parametros>';          
   
   pXmlOut := PKG_GLB_COMMON.FN_LIMPA_CAMPO(vXmlRetorno);

End Sp_Get_StatusAutorizacaoPlaca;



Procedure Sp_CancelarMDFe(pXmlIn   In  Varchar2,
                          pStatus  Out Char,
                          pMessage Out Varchar2)    
  As
/*
<Parametros>   
  <Input>      
     <Manifesto>220972</Manifesto>      
     <Serie>A1</Serie>      
     <Rota>021</Rota>      
     <Usuario>jsantos</Usuario>   
  </Input>
</Parametros>
*/  
  vManifesto  t_Con_Manifesto.Con_Manifesto_Codigo%Type;
  vSerie      t_Con_Manifesto.Con_Manifesto_Serie%Type;
  vRota       t_con_manifesto.con_manifesto_rota%Type;  
  vCount      Integer;
  vDataAut    Date;
  vStatus     Varchar2(10);   
  vUsuario    t_usu_usuario.usu_usuario_codigo%Type;
  vCodStatus  T_con_controlemdfe.Con_Controlemdfe_Codstenv%Type;
  Begin
    Begin
       Select extractvalue(Value(V), 'Input/Manifesto'),
              extractvalue(Value(V), 'Input/Serie'),
              extractvalue(Value(V), 'Input/Rota'),
              extractvalue(Value(V), 'Input/Usuario')              
             into vManifesto,
                  vSerie,
                  vRota,
                  vUsuario
            From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V; 
       
        /*if pkg_fifo_manifesto.Fn_ValeFreteGerado_MDFe(vManifesto, vSerie, vRota) = 'S' then
            pStatus := 'W';
            pMessage := 'Manifesto com este veiculo ja esta com Vale Frete Gerado!';
            return;
        end if;   */    
        
      begin
        
      Select cm.con_controlemdfe_dtretorno,
             cm.con_mdfestatus_codigo
           into vDataAut,
                vStatus
           From t_con_controlemdfe cm
           where cm.con_manifesto_codigo = vManifesto
             and cm.con_manifesto_serie  = vSerie
             and cm.con_manifesto_rota   = vRota;         
     exception WHEN NO_DATA_FOUND THEN
      vStatus := 'RJ';
     end;          
             
       Select Count(*)
         into vCount     
         from t_con_eventomdfe e
         where e.con_manifesto_codigo = vManifesto
           and e.con_manifesto_serie  = vSerie
           and e.con_manifesto_rota   = vRota;          
           
       if (vCount > 0) and (vStatus != 'EC') then
         pStatus := 'W';
         pMessage := 'Manifesto ja foi solicitado cancelamento';
         return;
       else                        
           -- Para Autorizado       
           if vStatus In ('OK', 'EC') then     
            
                    if sysdate-vDataAut > 1 then
                         pStatus := 'W';
                         pMessage := 'N?o e possivel cancelar Manifesto Eletronico: ' || vManifesto || ' .' ||
                                     chr(13)||'Foi autorizado a mais que 24 horas. Data da autorizac?o: ' || To_Char(vDataAut, 'dd/MM/yyyy hh24:mi:ss'); 
                         return;
                    end if;
                      --vNewNumberManif := Fn_Get_NovoNumeroManifestoXXX();                          
                      Insert Into t_con_eventomdfe e values( vManifesto, 
                                                             vSerie, 
                                                             vRota, 
                                                             (Select nvl(max(ee.con_eventomdfe_seqevento),0)+1
                                                                from t_con_eventomdfe ee
                                                               where ee.con_manifesto_codigo = vManifesto
                                                                 and ee.con_manifesto_serie  = vSerie
                                                                 and ee.con_manifesto_rota   = vRota), 
                                                             1, 
                                                             vUsuario, 
                                                             sysdate, 
                                                             null, 
                                                             null);

                       Update t_con_controlemdfe cm
                         set cm.con_mdfestatus_codigo = 'AC'
                         where cm.con_manifesto_codigo = vManifesto
                           and cm.con_manifesto_serie  = vSerie
                           and cm.con_manifesto_rota   = vRota;
                             
                       Update t_con_manifesto cm
                         set cm.con_manifesto_status = 'C'
                         where cm.con_manifesto_codigo = vManifesto
                           and cm.con_manifesto_serie  = vSerie
                           and cm.con_manifesto_rota   = vRota;           

                       pStatus := 'N';
                       pMessage := 'Solicitac?o de cancelamento do manifesto '|| vManifesto ||' executada com sucesso!' || ' - Data da autorizac?o: ' || To_Char(vDataAut, 'dd/MM/yyyy hh24:mi:ss');  
                       Commit;
            -- Para Rejeitado              
           elsif vStatus = 'RJ' then    
                     
                     Begin
                         Select cm.con_controlemdfe_codstenv
                          Into vCodStatus
                          from t_con_controlemdfe cm
                         where cm.con_manifesto_codigo = vManifesto
                           and cm.con_manifesto_serie  = vSerie
                           and cm.con_manifesto_rota   = vRota;            
                     Exception
                       When No_Data_Found Then
                         vCodStatus := '000'; -- Nao Encontrado    
                     End;
                       
                     if vCodStatus in ('225','999','204','462','610','611','662','686') then
                        pStatus := 'W';
                        pMessage := 'Proibido cancelamento para esse Codigo de autorizac?o(225, 999, 204, 462, 610, 611, 662, 686). Contate o Help Desk!';
                        return;  
                     end if;
                      
                     Sp_Volta_Autorizacao(vManifesto, vSerie, vRota, pStatus, pMessage);
                     if pStatus = 'N' Then    
                       
                         Delete t_Con_Docmdfe doc   
                         where doc.con_manifesto_codigo = vManifesto
                           and doc.con_manifesto_serie  = vSerie
                           and doc.con_manifesto_rota   = vRota;                        
                         
                         Delete from t_con_controlemdfe cm
                         where cm.con_manifesto_codigo = vManifesto
                           and cm.con_manifesto_serie  = vSerie
                           and cm.con_manifesto_rota   = vRota;
/*                           
                         Delete from t_con_tempchaveman t
                         where t.con_tempchaveman_codigo = vManifesto
                           and t.con_tempchaveman_serie  = vSerie
                           and t.con_tempchaveman_rota   = vRota;  */                         
                           
                         Delete t_Con_Manifesto m   
                         where m.con_manifesto_codigo = vManifesto
                           and m.con_manifesto_serie  = vSerie
                           and m.con_manifesto_rota   = vRota;                             
                           
                         Commit;
                         pStatus := 'N';
                         pMessage := 'Manifesto Rejeitado: ' || vManifesto || '. Cancelado com sucesso!';  
                                                
                      else
                         Rollback;
                      end if;    
           end if;
        End If;
   Exception 
     When Others Then
       pStatus := 'E';
       pMessage := sqlerrm||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;  
       Rollback;       
   End;   
End Sp_CancelarMDFe;   

Procedure Sp_Volta_AutorizacaoChave(pChave In Varchar2,
                                    pStatus Out Char,
                                    pMessage Out Varchar2)
As
 vManif Varchar2(100);
 vSerie Varchar2(10);
 vRota Varchar2(3);  
Begin
  Select m.con_manifesto_codigo,
         m.con_manifesto_serie,
         m.con_manifesto_rota
    Into vManif,
         vSerie,
         vRota     
    From t_con_controlemdfe  m
    where m.con_controlemdfe_chaveaces = pChave;  
    
    Sp_Volta_Autorizacao(vManif, vserie, vrota, pstatus, pmessage);
    
End Sp_Volta_AutorizacaoChave;                                    

Procedure Sp_Volta_Autorizacao(pManifesto Varchar2,
                               pSerie     Varchar2,
                               pRota      Varchar2,
                               pStatus Out Char,
                               pMessage Out Varchar2)                         
As
vManif t_Con_Manifesto%RowType;
vVeicManif t_con_veicdispmanif%RowType;
vNewNumberManif Integer;
Begin
  Begin
    
       Select m.*
         Into vManif
         From t_con_manifesto m
         where trim(m.con_manifesto_codigo) = trim(pManifesto)
           and trim(m.con_manifesto_serie)  = trim(pSerie)
           and m.con_manifesto_rota   = pRota;
           
       vNewNumberManif := pkg_fifo_manifesto.Fn_Get_NovoNumeroManifestoXXX();
           
       Insert Into t_con_manifesto m 
                Values ( vNewNumberManif,
                         'XXX',--vManif.Con_Manifesto_Serie,
                         vManif.Con_Manifesto_Rota,
                         vManif.Usu_Usuario_Codigo,
                         vManif.Con_Manifesto_Usuario_Impresso,
                         vManif.Con_Manifesto_Placa,
                         vManif.Con_Manifesto_Placasaque,
                         vManif.Con_Manifesto_Dtemissao,
                         vManif.Con_Manifesto_Pesonf,
                         vManif.Con_Manifesto_Pesocobrado,
                         vManif.Con_Manifesto_Vlrmercadoria,
                         vManif.Con_Manifesto_Vlrfrete,
                         vManif.Con_Manifesto_Obs,
                         vManif.Con_Manifesto_Cpfmotorista,
                         vManif.Con_Manifesto_Cubagemtotal,
                         SYSDATE,
                         vManif.Car_Tpveiculo_Codigo,
                         vManif.Con_Manifesto_Quantitensnf,
                         vManif.Glb_Tpmotorista_Codigo,
                         null, --vManif.Con_Manifesto_Status,
                         vManif.Con_Manifesto_Destinatario,
                         vManif.Glb_Tpcliend_Codigo,
                         vManif.Arm_Armazem_Codigo,
                         vManif.Con_Manifesto_Dtchegada,
                         vManif.Con_Manifesto_Dtrecebimento,
                         vManif.Con_Manifesto_Avarias,
                         vManif.Con_Manifesto_Dtchegcelula,
                         vManif.Con_Manifesto_Dtcheckin,
                         vManif.Con_Manifesto_Dtgravcheckin,
                         vManif.Arm_Carregamento_Codigo,
                         vManif.Con_Manifesto_Localidade,
                         vManif.Con_Manifesto_Ufdestino,
                         null
                       );
                          
         Insert Into t_con_docmdfe 
           Select vNewNumberManif, --m.con_manifesto_codigo
                  'XXX', --m.con_manifesto_serie
                  m.con_manifesto_rota,
                  m.con_conhecimento_codigo,
                  m.con_conhecimento_serie,
                  m.glb_rota_codigo,
                  m.arm_carregamento_codigo
              from t_con_docmdfe m
              where m.con_manifesto_codigo = pManifesto
                and m.con_manifesto_serie = pSerie
                and m.con_manifesto_rota = pRota;
                
         select *
           into vVeicManif
           from t_con_veicdispmanif v
           where trim(v.con_manifesto_codigo) = trim(pManifesto)
             and trim(v.con_manifesto_serie) = trim(pSerie)
             and trim(v.con_manifesto_rota) = trim(pRota);
        
        insert into t_con_veicdispmanif values(vVeicManif.Fcf_Veiculodisp_Codigo,
                                               vVeicManif.Fcf_Veiculodisp_Sequencia,
                                               vNewNumberManif,
                                               'XXX',
                                               vVeicManif.Con_Manifesto_Rota,
                                               vVeicManif.Con_Veicdispmanif_Data,
                                               vVeicManif.Usu_Usuario_Gerou);
                  
        delete from t_con_veicdispmanif v
           where trim(v.con_manifesto_codigo) = trim(pManifesto)
             and trim(v.con_manifesto_serie) = trim(pSerie)
             and trim(v.con_manifesto_rota) = trim(pRota); 
                                     
        commit;                                        
                                               
            
        pStatus := 'N';
        pMessage := 'Manifesto retornado com sucesso!';     
    Exception
        When Others Then
           pStatus := 'E';
           pMessage := sqlerrm;  
           Rollback;
    End;              
                 
End Sp_Volta_Autorizacao;   

Function Fn_Validos_CTRC_MDFe(pVeiculoDisp T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                              pSequencia   T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE) return Char
As
Begin
   return tdvadm.pkg_fifo_valefrete.Fn_Validos_CTRC_MDFe(pVeiculoDisp,pSequencia);
End Fn_Validos_CTRC_MDFe;                                    

Procedure Sp_Get_ValeFrete(pXmlIn   In Varchar2,
                           pXmlOut  Out Clob,
                           pStatus  Out Char,
                           pMessage Out varchar2)                           
As
Begin
       Tdvadm.Pkg_Fifo_Valefrete.Sp_Get_ValeFrete(pXmlIn,pXmlOut,pStatus,pMessage);            
  End Sp_Get_ValeFrete;  

  Procedure Sp_Exclui_MDFeControleEnvio(pXmlIn   In Varchar2,
                                        pXmlOut  Out Clob,
                                        pStatus  Out Char,
                                        pMessage Out Varchar2)
  -- Exclui o ControleMDFe...                                  
  As  
  vManifesto tdvadm.t_con_controlemdfe.con_manifesto_codigo%Type;
  vSerie     tdvadm.t_con_controlemdfe.con_manifesto_serie%Type;
  vRota      tdvadm.t_con_controlemdfe.con_manifesto_rota%Type;
  vStatus    tdvadm.t_con_controlemdfe.con_mdfestatus_codigo%Type;
  vStatus2   char(1) := 'N';
  vMessage2  varchar2(2000);
  vCount     Integer;
  Begin
       
        Select extractvalue(Value(V), 'Input/Manifesto'),
               extractvalue(Value(V), 'Input/Serie'),
               extractvalue(Value(V), 'Input/Rota')
          into vManifesto,
               vSerie,
               vRota
         From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;  
        
        Begin
           
           Begin
             
                Select c.con_mdfestatus_codigo
                  Into vStatus
                  From tdvadm.t_con_controlemdfe c
                 where c.con_manifesto_codigo = vManifesto
                   and c.con_manifesto_serie  = vSerie
                   and c.con_manifesto_rota   = vRota;
                   
           Exception When No_Data_Found Then
              
              select count(*)
                Into vCount
                from tdvadm.t_uti_logmdfe lm
               where lm.uti_logmdfe_codigo = vManifesto
                 and lm.uti_logmdfe_serie  = vSerie
                 and lm.uti_logmdfe_rota   = vRota;  
              
              if vCount > 0 then
                 vStatus := 'RJ';
              end if;
              
           End;                  
              
      
           If vStatus = 'RJ' then
             
             Delete tdvadm.t_uti_logmdfe ll
              where ll.uti_logmdfe_codigo = vManifesto
                and ll.uti_logmdfe_serie  = vSerie
                and ll.uti_logmdfe_rota   = vRota;
               
             Delete tdvadm.t_con_controlemdfe c
              where c.con_manifesto_codigo = vManifesto
                and c.con_manifesto_serie  = vSerie
                and c.con_manifesto_rota   = vRota;
           
             Commit; 
             
             
            tdvadm.pkg_con_mdfe.Sp_Con_ValidaMdfe(vManifesto,
                                                  vSerie,
                                                  vRota,
                                                  vStatus2,  
                                                  vMessage2);
            
            
            if (vStatus2 != 'N') then
              
              pStatus := 'N';
              pMessage := 'Envio na base de dados retirado com sucesso, sera reenviado um nova solicitacao de autorizacao. '||vMessage2;          
            
            else
              
              pStatus := 'N';
              pMessage := 'Envio na base de dados retirado com sucesso, sera reenviado um nova solicitacao de autorizacao';          
            
            end if;                                          
             
             
           
           
           else
           
             pStatus := 'E';
             pMessage := 'Somente possivel reenviar manifesto com Status Rejeitado (RJ)';                                            
           
           end if;
           
         
                
        Exception When Others Then
        
          pStatus  := 'E';
          pMessage := 'Envio da solicitacao de autorizacao do Manifesto nao Encontrado.' || chr(13) || sqlerrm;
        
        End;  
        
        pXmlOut := '<Parametros>'||
                         '<OutPut>'||
                             '<Status>'||pStatus||'</Status>'||
                             '<Message>'||pMessage||'</Message>'||
                         '</OutPut>'||
                     '</Parametros>';          
                
  End Sp_Exclui_MDFeControleEnvio;     

  Function Fn_ValidaGeracaoMDFeComNFS(pVeiculoDisp In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                      pVeiculoSeq  In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Sequencia%Type) return Char
  As
  vQtdeNfServico Integer;
  vQtdeNfTotal   Integer;  
  Begin
          ------------------- NF --------------------------          
          -- pega qtde de nf (total)
          select Count(*)
            into vQtdeNfTotal
            from t_fcf_veiculodisp v,
                 t_arm_carregamento c,
                 t_con_conhecimento co
            where v.fcf_veiculodisp_codigo = pVeiculoDisp
              and v.fcf_veiculodisp_sequencia = pVeiculoSeq   
              and v.fcf_veiculodisp_codigo = c.fcf_veiculodisp_codigo
              and v.fcf_veiculodisp_sequencia = c.fcf_veiculodisp_sequencia    
              and c.arm_carregamento_codigo = co.arm_carregamento_codigo;              
          -- pega qtde de nf de servico
          select Count(*)
            into vQtdeNfServico
            from t_fcf_veiculodisp v,
                 t_arm_carregamento c,
                 t_con_conhecimento co
            where v.fcf_veiculodisp_codigo = pVeiculoDisp
              and v.fcf_veiculodisp_sequencia = pVeiculoSeq
              and v.fcf_veiculodisp_codigo = c.fcf_veiculodisp_codigo
              and v.fcf_veiculodisp_sequencia = c.fcf_veiculodisp_sequencia    
              and c.arm_carregamento_codigo = co.arm_carregamento_codigo
              and 'NF' = TDVADM.f_busca_conhec_tpformulario(co.con_conhecimento_codigo, co.con_conhecimento_serie, co.glb_rota_codigo);
          ------------------- Fim NF ----------------------           
          -- Verifica MDFe somente se existem NF alem SERVICO.
          if (vQtdeNfTotal != 0) and (vQtdeNfTotal != vQtdeNfServico) then
             return 'W'; -- Deve gerar MDFe
          else
             return 'N'; -- Somente de servicos 
          end if;          
          
  End Fn_ValidaGeracaoMDFeComNFS;                              

  procedure sp_ExecutaSelect(pCursor out tdvadm.pkg_glb_common.t_cursor)
  is
  begin
    
    open pCursor for
    select * 
    from t_glb_rota;
    
    dbms_output.put_line('executado com sucesso');
    
  end sp_ExecutaSelect; 
          
end pkg_fifo_manifesto;
/
