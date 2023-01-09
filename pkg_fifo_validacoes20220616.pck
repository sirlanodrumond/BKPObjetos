create or replace package pkg_fifo_validacoes is

-- Função utilizada para validar um veiculo antes da vinculação de um carregamento
Function Fn_Vld_VeicVinculacao( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pArm_carregamento_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type Default '',
                                pMessage Out Varchar2
                              ) Return Boolean;

--Função utilizada para conferir se as origens da Solicitação está sendo atendida,                               
-- pelos destinos das embalagens vinculada ao veiculo, antes da criação do vale de frete.                               
Function FN_Vld_OrigSolicitado( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pRotaFilial  in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                pMessage Out Varchar2
                               ) Return Boolean;

--Função utilizada para conferir se os destinos da Solicitação está sendo atendida,                               
-- pelos destinos das embalagens vinculada ao veiculo, antes da criação do vale de frete.                               
Function FN_Vld_DestSolicitado( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pMessage Out Varchar2
                               ) Return Boolean;

-- Função utilizada para, validar uma exceção MOP para carregamento com produto quimico
Function FN_Vld_VeicDispMopp( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                              pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                              pMessage Out Varchar2
                            ) Return Boolean;
                            
--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para, validar uma exceção Expresso para carregamento com Nota Expressa.                       --
--------------------------------------------------------------------------------------------------------------------                            
Function FN_Vld_VeicDispExpresso( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                  pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                  pMessage Out Varchar2
                                ) Return Boolean;                            
                            
--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para validar um carregamento antes do fechamento.                                             -- 
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_Carregamento( pArm_carregamento_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                 pMessage Out Varchar2
                             ) Return Boolean;

--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para validar a embalagem antes de um carregamento                                             -- 
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_EmbalagemCarreg( pArm_carreamento_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                 pArm_embalagem_numero In tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                                 pArm_embalagem_sequencia In tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                                 pArm_embalagem_flag In tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                                 pMessage Out Varchar2
                               ) Return Boolean;
                             
                             
                                
Function FNP_Vld_CarregVeiculo( pArm_carregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                pFcf_veiculodisp_codigo tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pMessage Out Varchar2
                               ) Return Boolean;

--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para realizar validação da chave de um Cte                                                    --
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_ChaveCte( pDadosRedesp In pkg_fifo.tDadosRedespacho,
                          pMessage Out Varchar2
                         ) Return Boolean;  

-----------------------------------------------------------------------------------------------------------------
-- Função utilizada para validar Tratamento de embalagem.                                                      --
-----------------------------------------------------------------------------------------------------------------
Function FN_Vld_TratamentoEmb( pArm_embalagem_numero In tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                               pArm_embalagem_flag In tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                               pArm_embalagem_sequencia In tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                               pMessage Out Varchar2
                              ) Return Boolean;
                                                      
                     
end pkg_fifo_validacoes;

 
/
create or replace package body pkg_fifo_validacoes As

--Variáveis de exceção
vEx_Validacao Exception;

--------------------------------------------------------------------------------------------------------------------
--Função utilizada para verificar se o veiculo solicitado é do mesmo tipo do Veiculo disponibilizado.             --
--------------------------------------------------------------------------------------------------------------------
Function FNP_VerificaTpVeiculo( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pMessage Out Varchar2    
                              ) Return Boolean Is
 --Variável utilizada para recuperar os tipos dos veículos 
 vTpVeiculo_VeicDisp tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%Type;                              
 vDescVeic_VeicDisp tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_descricao%Type;
 vTpVeiculo_Solicitacao tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%Type;
 vDescVeic_Solicitacao tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_descricao%Type;

Begin
  --inicializa as variáveis utilizadas nessa função.
  vTpVeiculo_VeicDisp:= '';                               
  vDescVeic_VeicDisp:= ''; 
  vTpVeiculo_Solicitacao:= '';
  vDescVeic_Solicitacao:= ''; 
    
  Begin
    --Recupero os tipos de veiculos da solicitação e disponibilizado
    Select distinct
      vd.fcf_tpveiculo_codigo,
      tpVeicDisp.Fcf_Tpveiculo_Descricao,
      sol.fcf_tpveiculo_codigo,
      tpVeicSol.Fcf_Tpveiculo_Descricao
      
    Into
      vTpVeiculo_VeicDisp,
      vDescVeic_VeicDisp,
      vTpVeiculo_Solicitacao,
      vDescVeic_Solicitacao
        
    From
      tdvadm.t_fcf_veiculodisp  vd,
      tdvadm.t_fcf_solveic sol,
      tdvadm.t_fcf_tpveiculo tpVeicDisp,
      tdvadm.t_fcf_tpveiculo tpVeicSol
    Where 0=0
      And vd.fcf_veiculodisp_codigo = sol.fcf_veiculodisp_codigo(+)
      And vd.fcf_veiculodisp_sequencia = sol.fcf_veiculodisp_sequencia(+)
      And vd.fcf_tpveiculo_codigo = tpVeicDisp.Fcf_Tpveiculo_Codigo
      And sol.fcf_tpveiculo_codigo = tpVeicSol.Fcf_Tpveiculo_Codigo(+)
      
      And vd.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
      And vd.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia;
      
      
      IF(vTpVeiculo_Solicitacao IS NULL) THEN
         pMessage := 'Veiculo solicitado não vincuulado há nenhuma solicitação.' || chr(10) ||
                     'Vinculação com carregamento nao permitida.';
      Return False;           
      END IF;
      
    --verifico se o tipo de Veiculos são diferentes  
    If ( vTpVeiculo_Solicitacao != vTpVeiculo_VeicDisp ) Then
      --Seto os paramentros de saida 
      pMessage := 'Veiculo solicitado diferente do veiculo vinculado. ' || chr(10) ||
                  'Veiculo Solicitado: ' || Trim(vTpVeiculo_Solicitacao) || ' - ' || vDescVeic_Solicitacao || chr(10) ||
                  'Veiculo Vinculado: ' || Trim(vTpVeiculo_VeicDisp) || ' - ' || vDescVeic_VeicDisp || chr(10) || chr(10) ||
                  'Vinculação com carregamento nao permitida.';
      Return False;           
    End If;
    
    --seto os paramentros de saida
    pMessage := '';
    Return True;
    
  Exception
    --Caso ocorra algum erro não previsto.
    When Others Then
      pMessage := 'Erro ao validar tipo do veiculo. "Veiculo Solicitado X Veiculo Disponivel".' || chr(10) ||
                  'Veiculo Disponivel: ' || pFcf_veiculodisp_codigo || ' - Sequencia: '|| pFcf_veiculodisp_sequencia || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_validacoes.fnp_verificatpveiculo();' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return False;
  End;
  
  
End FNP_VerificaTpVeiculo; 

--------------------------------------------------------------------------------------------------------------------
--Função utilizada para verificar se o carregamento pode ser vinculado ao Veiculo contratado.                     --
--------------------------------------------------------------------------------------------------------------------
Function FNP_Vld_CarregVeiculo( pArm_carregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                pFcf_veiculodisp_codigo tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pMessage Out Varchar2
                               ) Return Boolean Is

 --Variáveis auxiliares utilizadas definir paramentros de saida
 vMessage Varchar2(32000);   
 vStatus Boolean;
 
 --Variáveis utilizada para recuperar dados da Embalagem
 vArm_nota_numero tdvadm.t_arm_nota.arm_nota_numero%Type;
 vGlb_cliente_cgccpfcodigo tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type;
 vGlb_cliente_razaosocial tdvadm.t_glb_cliente.glb_cliente_razaosocial%Type;
 vArm_Armazem  tdvadm.t_arm_armazem.arm_armazem_codigo%type;
 --Variável de controle.
 vControl Integer;  
 vControlEx Integer;   
 vLinha Integer;                       
 vLocDestIBGE v_glb_ibge.nomeex%type;
 --Cursor utilizada para recuperar todos os destinos das embalagens do carregamento
 Cursor vvCursor 
 ( vvArm_carregamento_codigo tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type ) Is
   Select 
     pkg_fifo_carregamento.FN_Get_DestEmbalagem( det.arm_embalagem_numero,
                                              det.arm_embalagem_flag,
                                              det.arm_embalagem_sequencia,
                                              'L'
                                            ) DestEmbLoc,
                                            
     pkg_fifo_carregamento.FN_Get_DestEmbalagem( det.arm_embalagem_numero,
                                              det.arm_embalagem_flag,
                                              det.arm_embalagem_sequencia,
                                              'I'
                                            ) DestEmbIBGE,                                            
     det.arm_embalagem_numero,
     det.arm_embalagem_flag,
     det.arm_embalagem_sequencia                                           
   From
     tdvadm.t_arm_carregamento carreg,
     tdvadm.t_arm_carregamentodet det
   Where
     carreg.arm_carregamento_codigo = det.arm_carregamento_codigo
    And carreg.arm_carregamento_codigo = vvArm_carregamento_codigo;
 
  
Begin
 
-- if pArm_carregamento = '693249' Then
--    raise_application_error(-20001,pFcf_veiculodisp_codigo||'-'||pFcf_veiculodisp_sequencia);
-- End If;

  vMessage := '';
  vStatus := True;
  vLinha := 0; 
  
  Begin
    --Entro loop para percorrer todas os destinos das embalagens do carregamento.
    For vCursor In vvCursor( pArm_carregamento ) Loop
      --limpo a avariável para não correr o risco de pegar lixo
      vControl := 0;  
      vControlEx := 0;
      
      --verifico se a Localidade possui exceção
      Select Count(*) Into vControlEx
      From t_fcf_fretecarexc ex
      Where Trim(ex.fcf_fretecar_localidade) = Trim(vCursor.Destembloc); 
      
      --caso tenha alguma exceção, preciso ir pelo código de localidade.
      If ( vControlEx > 0 ) Then
        Select 
          Count(*) Into vControl
        From
          T_FCF_VEICULODISP VEIC,
          T_FCF_SOLVEIC  SOL,
          T_FCF_SOLVEICDEST SOLDEST
        Where  
          VEIC.FCF_VEICULODISP_CODIGO = SOL.FCF_VEICULODISP_CODIGO
          And VEIC.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA
          And SOL.FCF_SOLVEIC_COD = SOLDEST.FCF_SOLVEIC_COD
          And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
          And veic.FCF_VEICULODISP_SEQUENCIA = pFcf_veiculodisp_sequencia
          And Trim(soldest.glb_localidade_codigo) = Trim(vCursor.Destembloc);
      End If;
      
      --Caso não tenha nenhuma exceção, utilizo o código do ibge
      If ( vControlEx = 0 ) Then
        Select 
          Count(*) Into vControl
        From
          T_FCF_VEICULODISP VEIC,
          T_FCF_SOLVEIC  SOL,
          T_FCF_SOLVEICDEST SOLDEST

        Where  
          VEIC.FCF_VEICULODISP_CODIGO = SOL.FCF_VEICULODISP_CODIGO
          And VEIC.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA
          And SOL.FCF_SOLVEIC_COD = SOLDEST.FCF_SOLVEIC_COD
          And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
          And veic.FCF_VEICULODISP_SEQUENCIA = pFcf_veiculodisp_sequencia
          And Trim(soldest.glb_localidade_codigoibge) = Trim(vCursor.Destembibge);  
      End If;
      
        
      --Caso a variável chegue zerada, quer dizer que o destino da embalagem não foi selecionado.
      If ( vControl = 0 ) Then
        --seto a variável auxiliar para false.
        vStatus := False;
        
        --incremento a variável de linha.
        vLinha := vLinha +1;
        
        --Recupero dados da nota.
        Select
          nota.arm_nota_numero, 
          remet.glb_cliente_cgccpfcodigo,
          remet.glb_cliente_razaosocial,
          nota.arm_armazem_codigo
        Into
          vArm_nota_numero,
          vGlb_cliente_cgccpfcodigo,
          vGlb_cliente_razaosocial,
          vArm_Armazem
        From
          tdvadm.t_arm_nota Nota,
          tdvadm.t_glb_cliente Remet
        Where   
          Trim(nota.glb_cliente_cgccpfremetente) = Trim(remet.glb_cliente_cgccpfcodigo)
          And nota.arm_embalagem_numero = vCursor.Arm_Embalagem_Numero
          And nota.arm_embalagem_flag = vCursor.Arm_Embalagem_Flag
          And nota.arm_embalagem_sequencia = vCursor.Arm_Embalagem_Sequencia;
   
       begin 
       select trim(substr(trim(ib.nomeex) || '-' || trim(ib.ufsigla),1,50))
          into vLocDestIBGE
        from v_glb_ibge ib
        where ib.codmun =  vCursor.Destembibge;
        exception
          when NO_DATA_FOUND then
             vLocDestIBGE := 'IBGE não  Localizado';
          End;   
          
        --monto a linha da mensagem
        
        vMessage := trim(substr(vMessage || Trim(to_char(vLinha)) || '- ' ||
                                'Nt:' || Trim(to_char(vArm_nota_numero)) || '-' ||
--                                'CNPJ: ' || Trim(vGlb_cliente_cgccpfcodigo) || ' - ' ||
--                                'Nome: ' || Trim(vGlb_cliente_razaosocial) || ' - ' ||
                                'E.:' || Trim(to_char(vCursor.Arm_Embalagem_Numero)) || '-' ||
                                'Dest:' || vLocDestIBGE || chr(10) 
--                              ||  'Veiculo: ' || trim(pFcf_veiculodisp_codigo)  || ' - ' || 
--                                'Sequencia: ' || Trim(pFcf_veiculodisp_sequencia)
                           ,1,31800));  
      End If;  
      
    End Loop;

    --Verifico se a variável de status chegou negativa
    If ( vStatus = False ) Then
      If vArm_Armazem in ('42','18') Then
         vStatus := True;
         vLinha := 0;
      Else
      
         vMessage := 'CARREGAMENTO ' || Trim( to_char(PARM_CARREGAMENTO)) || ' NAO PODE SER VINCULADO AO VEICULO SELECIONADO.' || CHR(10) ||
                     'Notas com destinos nao planejados na solicitacao: TOTAL ' || to_char(vLinha) || chr(10) ||  
                     vMessage;
      End IF;
    End If;
    
    --Seto os paramentros de saida.
    pMessage := vMessage;
    Return vStatus;
    
  Exception
    --Erro não esperado.
    When Others Then
      pMessage := 'Erro ao validar Vinculo do Carregamento ao veiculo selecionado.' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_validacoes.fnp_vld_carragveiculo(); ' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return False;              
  End;
  
End FNP_Vld_CarregVeiculo;                               

--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para validar um veiculo antes da vinculação de um carregamento                                --      
--------------------------------------------------------------------------------------------------------------------
Function Fn_Vld_VeicVinculacao( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pArm_carregamento_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type Default '',
                                pMessage Out Varchar2
                              ) Return Boolean Is
 --Variável utilizada para recuperar mensagens de outras funçãoes
 vMessage Varchar2(32000);
                               
Begin
--If pArm_carregamento_codigo = '604276'  Then
--  raise_application_error(-20100,pFcf_veiculodisp_codigo||'-'||pFcf_veiculodisp_sequencia);
-- Return True;
--End If;
  Begin
    --Valido o tipo de veiculo 
    --Validação simples, verifico se o Veiculo Disponivel é o mesmo veiculo da solicitação.
    pMessage := '1';
    If ( Not fnp_VerificaTpVeiculo(pFcf_veiculodisp_codigo, pFcf_veiculodisp_sequencia, vMessage) ) Then
      --caso a validação não retorne verdadeiro, lanço a exceção de validação
      Raise vEx_Validacao;
      
    End If; 
    
    --Valido o destino das embalagens x Destino do Veiculo.
    pMessage := '2';
    If ( Not FNP_Vld_CarregVeiculo(pArm_carregamento_codigo, pFcf_veiculodisp_codigo, pFcf_veiculodisp_sequencia, vMessage) ) Then
      --caso a validação não retorne verdadeodo, lanço a exceção.
      Raise vEx_Validacao;
      
    End If;
    
    --Passando por todas as validações, seto os paramentros de saida
    pMessage := '';
    Return True;
    
  Exception
    --Exceção de Validação ( Exceção lançado quando alguma validação tenha retornado false );
    When vEx_Validacao Then
      pMessage := vMessage;
      Return False;
    
    --caso ocorra algum não previsto durante o processo de validação.
    When Others Then
      pMessage := pMessage || 'Erro ao validar o veículo antes da vinculacao com carregamento.' || chr(10) ||
                              'Rotina: tdvadm.pkg_fifo_validacoes.fn_vld_veicvinculacao();' || chr(10) ||
                              'Erro Ora: ' ||  Sqlerrm;
      Return False;            
  End;
End Fn_Vld_VeicVinculacao;   



--------------------------------------------------------------------------------------------------------------------
--Função utilizada para conferir se as origens da Solicitação está sendo atendida,                               --
-- pelas Origens das embalagens vinculada ao veiculo, antes da criação do vale de frete.                         --      
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_OrigSolicitado( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pRotaFilial  in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                pMessage Out Varchar2
                               ) Return Boolean Is
                               
                               
 --Cursor utilizada para recuperar todos os destinos da solicitação
 Cursor vCursorOrigSol ( vFcf_veiculodisp_codigo tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                         vFcf_veiculodisp_sequencia tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type
                       ) Is Select 
                              Distinct SOLORIG.glb_localidade_codigo,
                                       SOLORIG.glb_localidade_codigoibge 
                              
                              
                            From
                              T_FCF_VEICULODISP VEIC,
                              T_FCF_SOLVEIC  SOL,
                              t_Fcf_Solveicorig SOLORIG
                            Where  
                              VEIC.FCF_VEICULODISP_CODIGO = SOL.FCF_VEICULODISP_CODIGO
                              And VEIC.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA
                              And SOL.FCF_SOLVEIC_COD = SOLorig.FCF_SOLVEIC_COD
                              And veic.fcf_veiculodisp_codigo = vFcf_veiculodisp_codigo
                              And veic.FCF_VEICULODISP_SEQUENCIA = vFcf_veiculodisp_sequencia;
                               
 --Variável de controle
 vControl    Integer; 
 vControlCte Integer; 
 vTotalCte   Integer;
 vLinha      Integer;
 vControlEx  Integer;
 vLocArmazem tdvadm.t_glb_localidade.glb_localidade_codigo%type;
 vUFArmazem  tdvadm.t_glb_estado.glb_estado_codigo%type;
 
 --Variável utilizada para montar mensagem
 vMessage Varchar(32000);
 vStatus Boolean;
 
 vOrigemEmbalagem varchar2(100);
 vOrigemCursor    varchar2(100);
 vLiberaUFSEMFILIAL char(1) := 'N';
 --Variável utilizada para recuperar descrição da localidade.
 vLocDesc tdvadm.t_glb_localidade.glb_localidade_descricao%Type;
Begin
--  Return True;
  
  --inicializo as variáveis que serão utilizadas.
  vMessage:= '';
  vStatus := True;
  vLocDesc := '';
  vLinha := 0;
  --28/04/2022 - Sirlano
  -- Implementando o Parametro
  select count(*)
    into vControl
  From tdvadm.t_usu_perfil p
  where p.usu_aplicacao_codigo = '0000000000'
    and p.usu_perfil_codigo = 'VLD_IMPOSTO_ANTECIPADO'
    and p.usu_perfil_ativo = 'S'
    and instr(p.usu_perfil_parat,trim(pFcf_veiculodisp_codigo)) > 0
    and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                 from tdvadm.t_usu_perfil p1
                                 where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                   and p1.usu_perfil_codigo = p.usu_perfil_codigo
                                   and p1.usu_perfil_ativo = 'S');
  vLiberaUFSEMFILIAL := 'N';
  If vControl > 0 then
     vLiberaUFSEMFILIAL := 'S';
  End If;
  Begin
     select a.glb_localidade_codigo,
            l.glb_estado_codigo
        into vLocArmazem,
             vUFArmazem
     from tdvadm.t_fcf_veiculodisp vd,
          tdvadm.t_arm_armazem a,
          tdvadm.t_glb_localidade l
     where vd.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo 
       and vd.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
       and vd.arm_armazem_codigo = a.arm_armazem_codigo
       and a.glb_localidade_codigo = l.glb_localidade_codigo;
  exception
     When OTHERS Then
        vLocArmazem := Null;
        vUFArmazem  := null;
     End;

  
  Begin
    --entro em laçõ para recuperar os destinos da solicitação.
    For vCursor In vCursorOrigSol ( pFcf_veiculodisp_codigo, 
                                    pFcf_veiculodisp_sequencia 
                                  )  Loop
      --limpo a variável de controle, para garantir que não peguei nenhum tipo de linho.
      vControl := 0;   
      vControlEx := 0;
      -- 18/04/2022 - Sirlano
      -- Verifica se a UF da ORIGEM solicitada e a mesma da UF do Arqmazem
      If vUFArmazem <> substr((fn_busca_codigoibge(vCursor.Glb_Localidade_Codigo,'IBD')),1,2) Then
         If ( trunc(sysdate) <= to_date('25/04/2022','dd/mm/yyyy') ) and 
            ( substr((fn_busca_codigoibge(vCursor.Glb_Localidade_Codigo,'IBD')),1,2) = 'DF' ) Then
            -- 20/04/2022 Sirlano
            -- Chamado #281618 Liberado pelo Dr. Laerte Até dia 25 caso seja carregamento em Brasilia-DF
            vMessage := vMessage;
         Else
           iF vLiberaUFSEMFILIAL = 'N' Then
              vStatus := False;
              vMessage := 'UF da Localidade ' || Trim(fn_busca_codigoibge(vCursor.Glb_Localidade_Codigo,'IBD')) || ' Diferente da UF do Armazem ' || vUFArmazem;
              pMessage := vMessage;
              Return vStatus;
           End If;
         End If;
      End If;
      --Verifico se a localidade possui alguma exceção.
      Select Count(*) Into vControlEx
      From t_fcf_fretecarexc ex
      Where ex.fcf_fretecar_localidade = vCursor.Glb_Localidade_Codigo;
      
      --Caso a localidade possua uma exceção,
      If ( vControlEx > 0 ) Then
        --Verifico entre as notas, vinculadas a esse veiculo, temos o destido corrente.
        Select
          count(*) Into vControl
        From
          tdvadm.t_fcf_veiculodisp veic,
          tdvadm.t_Arm_carregamento carreg,
          tdvadm.t_arm_carregamentodet carregdet,
          tdvadm.t_arm_nota nota,
          tdvadm.t_arm_embalagem eb
        Where 
          veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
          And nota.glb_rota_codigo = pRotaFilial
          And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
          And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
          And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
          And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
          And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
          And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
          And carregdet.arm_embalagem_sequencia = nota.Arm_Embalagem_Sequencia
          And carregdet.arm_embalagem_numero = eb.arm_embalagem_numero
          And carregdet.arm_embalagem_flag = eb.arm_embalagem_flag
          And carregdet.arm_embalagem_sequencia = eb.Arm_Embalagem_Sequencia
--          and nota.arm_embalagem_numero is not nul
          And Trim( pkg_fifo_carregamento.FN_Get_OrigtEmbalagem( nota.arm_embalagem_numero, 
                                                                nota.arm_embalagem_flag,
                                                                nota.arm_embalagem_sequencia,
                                                                'L'  ) ) = Trim(vCursor.Glb_Localidade_Codigo);
      End If;
      
      -- 18/04/2022 - Sirlano
      -- Verifica se a Localidade tem que ser diferente da do Proprio Armazem
     If vCursor.Glb_Localidade_Codigo <> vLocArmazem Then 
            --Caso não tenha nenhuma exceção, utilizo o código do IBGE
            If ( vControlEx = 0 ) Then
              --Verifico entre as notas, vinculadas a esse veiculo, temos o destido corrente.
      /*        Select
                count(*) Into vControl
              From
                t_fcf_veiculodisp veic,
                t_Arm_carregamento carreg,
                t_arm_carregamentodet carregdet,
                t_arm_nota nota
              Where 
                veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
                And nota.glb_rota_codigo = pRotaFilial
                And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
                And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
                And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
                And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
                And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
                And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
                And carregdet.arm_embalagem_sequencia = nota.Arm_Embalagem_Sequencia
                And Trim( pkg_fifo_carregamento.FN_Get_OrigtEmbalagem( nota.arm_embalagem_numero, 
                                                                      nota.arm_embalagem_flag,
                                                                      nota.arm_embalagem_sequencia,
                                                                      'I'  ) ) = Trim(fn_busca_codigoibge(vCursor.Glb_Localidade_Codigo,'IBC'));
      */  
              vControl := 0;
              for c_msg in (Select nota.arm_embalagem_numero, 
                                   nota.arm_embalagem_flag,
                                   nota.arm_embalagem_sequencia
                            From
                              tdvadm.t_fcf_veiculodisp veic,
                              tdvadm.t_Arm_carregamento carreg,
                              tdvadm.t_arm_carregamentodet carregdet,
                              tdvadm.t_arm_nota nota
                            Where 
                              veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
                              And nota.glb_rota_codigo = pRotaFilial
                              And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
                              And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
                              And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
                              And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
                              And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
                              And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
                              And carregdet.arm_embalagem_sequencia = nota.Arm_Embalagem_Sequencia)
                Loop 
                  vOrigemEmbalagem := Trim(pkg_fifo_carregamento.FN_Get_OrigtEmbalagem(c_msg.arm_embalagem_numero,
                                                                                       c_msg.arm_embalagem_flag,
                                                                                       c_msg.arm_embalagem_sequencia,
                                                                                       'I'  ) );
                  vOrigemCursor    := Trim(fn_busca_codigoibge(vCursor.Glb_Localidade_Codigo,'IBC'));
                   
                  If vOrigemEmbalagem  = vOrigemCursor   Then
                     vControl := vControl + 1;
                  End If;                                                     
                 End Loop;

          End If;
     Else 
        vControl := 1;
     End If;
        
      
      ---------------------------------------------------------------------------------------
      --                            BUSCA POR EXCEÇÕES.                                    --
      ---------------------------------------------------------------------------------------      
      --caso não encontre a localidade, vejo, se a localidade está em alguma exceção.
      -- Mudar para as Origens da Solicitação e nao os Destinos
      If vControl = 0 Then
          Select Count(*) Into vControl
          From  v_arm_excecaodestsol ex
          Where Trim(ex.glb_localidade_codigo) = Trim(vCursor.Glb_Localidade_Codigo)
            And ex.dtInicial <= Trunc(Sysdate) 
            And ex.dtFinal >= Trunc(Sysdate);
      End If;      
      
      ---------------------------------------------------------------------------------------
      -- Verifico se so existe CTe de outra Rota.
      -- Se for Isto retorno a localidade da filial
      If ( vControl = 0 ) Then
        Select
          count(*) Into vControlCte
        From
          t_fcf_veiculodisp veic,
          t_Arm_carregamento carreg,
          t_arm_carregamentodet carregdet,
          t_arm_nota nota
        Where 
          veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
          And nota.glb_rota_codigo = pRotaFilial
          And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
          And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
          And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
          And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
          And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
          And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
          And carregdet.arm_embalagem_sequencia = nota.Arm_Embalagem_Sequencia;
      
        If ( vControlCte = 0 ) Then 
        -- Significa que soi tem CTe de outras Rotas.
        -- Pega a Localidade do Armazem para comparar
        
           Select Count(distinct an.glb_rota_codigo || an.con_conhecimento_codigo)
             into vTotalCte
           from t_Arm_carregamento ca,
                t_arm_armazem a,
                t_arm_nota an,
                t_arm_carregamentodet cd
           where ca.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
             and ca.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia   
             and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
             and cd.arm_embalagem_numero = an.arm_embalagem_numero
             and cd.arm_embalagem_flag = an.arm_embalagem_flag
             and cd.arm_embalagem_sequencia = an.arm_embalagem_sequencia
             and ca.arm_armazem_codigo = a.arm_armazem_codigo
             and trim(a.glb_localidade_codigo) = Trim(vCursor.Glb_Localidade_Codigo);
        
           Select Count(distinct an.glb_rota_codigo || an.con_conhecimento_codigo)
             into vTotalCte
           from t_Arm_carregamento ca,
                t_arm_armazem a,
                t_arm_nota an,
                t_arm_carregamentodet cd
           where ca.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
             and ca.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia   
             and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
             and cd.arm_embalagem_numero = an.arm_embalagem_numero
             and cd.arm_embalagem_flag = an.arm_embalagem_flag
             and cd.arm_embalagem_sequencia = an.arm_embalagem_sequencia
             and an.glb_rota_codigo <> pRotaFilial
             and ca.arm_armazem_codigo = a.arm_armazem_codigo
             and trim(a.glb_localidade_codigo) = Trim(vCursor.Glb_Localidade_Codigo);

           -- So tem conhecimento de outra rota
           if vTotalCte = vControlCte Then
              vControl := 1;
           End IF;


        End If;
    
     
      End If;



      
            
      --Caso a variável esteja Zerada, não foi encontrado o destino na solicitação, entre os destinos das notas.
      If ( vControl = 0 ) Then
        --seto a variável de status para false, e monto a mensagem com a localidade.
        vStatus := False;
        
        --Incremento a variável de linha, apenas para contar a quantia de destinos não atendida
        vLinha := vLinha +1;
        
        --Busco a descrição da localidade não localizada.
        Select 
          loc.glb_localidade_descricao
        Into vLocDesc  
        From 
          t_glb_localidade loc
        Where
          loc.glb_localidade_codigo = vCursor.Glb_Localidade_Codigo;  
        
        --Monto a mensagem de retorno.
        vMessage := vMessage || Trim(to_char(vlinha)) || ' - ' || Trim(vCursor.Glb_Localidade_Codigo) || ' - ' || Trim(vLocDesc) || ' - IBGE: ' || VcURSOR.Glb_Localidade_Codigoibge || chr(10) ;
      End If;  
      
    End Loop;
    -- Probelma com a Tatiana Cariacica
    -- -- Felipe 24/01/2015
    if pFcf_veiculodisp_codigo = '2165622'  Then
       vStatus := True;
    End If;
    
    --Caso a variável de status tenha sido mudada para false.
    If (vStatus = false) Then
      --monto a mensagem de retorno.
      vMessage := 'As Origens definidos na Solicitacao de Frete, não foram atendidas atraves das notas vinculadas.' || chr(10) ||
                  'Abaixo relacao das origens nao atendidos. ' || chr(10) ||
                  vMessage || chr(10) ||
                  'Veiculo: ' || pFcf_veiculodisp_codigo || ' Sequencia: ' || pFcf_veiculodisp_sequencia||' - '||pRotaFilial;
    End If;
    
    --Seto os paramentros de saida.
    pMessage := vMessage;
    Return vStatus;
    
  Exception 
    --Erro não esperado
    When Others Then
      pMessage:= 'Erro ao tentar validar Origens Solicitacao x Destinos Notas. ' || chr(10) ||
                 'Rotina: tdvadm.pkg_fifo_validacoes.fn_vld_origsolicitado(); ' || chr(10) ||
                 'Erro ora: ' || Sqlerrm;
      Return False;           
  End;
  
End FN_Vld_OrigSolicitado;  





--------------------------------------------------------------------------------------------------------------------
--Função utilizada para conferir se os destinos da Solicitação está sendo atendida,                               --
-- pelos destinos das embalagens vinculada ao veiculo, antes da criação do vale de frete.                         --      
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_DestSolicitado( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                pMessage Out Varchar2
                               ) Return Boolean Is
                               
                               
 --Cursor utilizada para recuperar todos os destinos da solicitação
 Cursor vCursorDestSol ( vFcf_veiculodisp_codigo tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                         vFcf_veiculodisp_sequencia tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type
                       ) Is Select 
                              Distinct soldest.glb_localidade_codigo,
                              soldest.glb_localidade_codigoibge 
                              
                              
                            From
                              T_FCF_VEICULODISP VEIC,
                              T_FCF_SOLVEIC  SOL,
                              T_FCF_SOLVEICDEST SOLDEST
                            Where  
                              VEIC.FCF_VEICULODISP_CODIGO = SOL.FCF_VEICULODISP_CODIGO
                              And VEIC.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA
                              And SOL.FCF_SOLVEIC_COD = SOLDEST.FCF_SOLVEIC_COD
                              And veic.fcf_veiculodisp_codigo = vFcf_veiculodisp_codigo
                              And veic.FCF_VEICULODISP_SEQUENCIA = vFcf_veiculodisp_sequencia;
                               
 --Variável de controle
 vControl Integer;  
 vLinha Integer;
 vControlEx Integer;
 
 --Variável utilizada para montar mensagem
 vMessage Varchar(32000);
 vStatus Boolean;
 
 --Variável utilizada para recuperar descrição da localidade.
 vLocDesc tdvadm.t_glb_localidade.glb_localidade_descricao%Type;
Begin
--  Return True;
  
  --inicializo as variáveis que serão utilizadas.
  vMessage:= '';
  vStatus := True;
  vLocDesc := '';
  vLinha := 0;
  
  Begin
    --entro em laçõ para recuperar os destinos da solicitação.
    For vCursor In vCursorDestSol ( pFcf_veiculodisp_codigo, 
                                    pFcf_veiculodisp_sequencia 
                                  )  Loop
      --limpo a variável de controle, para garantir que não peguei nenhum tipo de linho.
      vControl := 0;   
      vControlEx := 0;
      
      --Verifico se a localidade possui alguma exceção.
      Select Count(*) Into vControlEx
      From t_fcf_fretecarexc ex
      Where ex.fcf_fretecar_localidade = vCursor.Glb_Localidade_Codigo;
      
      --Caso a localidade possua uma exceção,
      If ( vControlEx > 0 ) Then
        --Verifico entre as notas, vinculadas a esse veiculo, temos o destido corrente.
        Select
          count(*) Into vControl
        From
          tdvadm.t_fcf_veiculodisp veic,
          tdvadm.t_Arm_carregamento carreg,
          tdvadm.t_arm_carregamentodet carregdet,
          tdvadm.t_arm_nota nota,
          tdvadm.t_glb_cliend dest
        Where 
          veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
          And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
          And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
          And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
          And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
          And carregdet.arm_embalagem_sequencia = nota.Arm_Embalagem_Sequencia
          And trim(dest.glb_cliente_cgccpfcodigo) = Trim(nota.glb_cliente_cgccpfdestinatario)
          And dest.glb_tpcliend_codigo = nota.glb_tpcliend_coddestinatario
          
          And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
          And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
--          and trim(nota.arm_nota_localentregal) = Trim(vCursor.Glb_Localidade_Codigo);
          
          And Trim( pkg_fifo_carregamento.FN_Get_DestEmbalagem( nota.arm_embalagem_numero, 
                                                                nota.arm_embalagem_flag,
                                                                nota.arm_embalagem_sequencia,
                                                                'L'  ) ) = Trim(vCursor.Glb_Localidade_Codigo);
      End If;
      
      --Caso não tenha nenhuma exceção, utilizo o código do IBGE
      If ( vControlEx = 0 ) Then
        --Verifico entre as notas, vinculadas a esse veiculo, temos o destido corrente.
        Select
          count(*) Into vControl
        From
          tdvadm.t_fcf_veiculodisp veic,
          tdvadm.t_Arm_carregamento carreg,
          tdvadm.t_arm_carregamentodet carregdet,
          tdvadm.t_arm_nota nota,
          tdvadm.t_glb_cliend dest
        Where 
          veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
          And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
          And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
          And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
          And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
          And carregdet.arm_embalagem_sequencia = nota.Arm_Embalagem_Sequencia
          And trim(dest.glb_cliente_cgccpfcodigo) = Trim(nota.glb_cliente_cgccpfdestinatario)
          And dest.glb_tpcliend_codigo = nota.glb_tpcliend_coddestinatario
          And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
          And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
--          and trim(nota.arm_nota_localentregai) = Trim(vCursor.Glb_Localidade_Codigoibge);
          And Trim( pkg_fifo_carregamento.FN_Get_DestEmbalagem( nota.arm_embalagem_numero, 
                                                                nota.arm_embalagem_flag,
                                                                nota.arm_embalagem_sequencia,
                                                                'I'  ) ) = Trim(vCursor.Glb_Localidade_Codigoibge);
      End If;
      
      
        
      
      ---------------------------------------------------------------------------------------
      --                            BUSCA POR EXCEÇÕES.                                    --
      ---------------------------------------------------------------------------------------      
      --caso não encontre a localidade, vejo, se a localidade está em alguma exceção.
      If vControl = 0 Then
          Select Count(*) Into vControl
          From  v_arm_excecaodestsol ex
          Where Trim(ex.glb_localidade_codigo) = Trim(vCursor.Glb_Localidade_Codigo)
            And ex.dtInicial <= Trunc(Sysdate) 
            And ex.dtFinal >= Trunc(Sysdate);
      End If;      
      
      ---------------------------------------------------------------------------------------
      
            
      --Caso a variável esteja Zerada, não foi encontrado o destino na solicitação, entre os destinos das notas.
      If ( vControl = 0 ) Then
        --seto a variável de status para false, e monto a mensagem com a localidade.
        vStatus := False;
        
        --Incremento a variável de linha, apenas para contar a quantia de destinos não atendida
        vLinha := vLinha +1;
        
        --Busco a descrição da localidade não localizada.
        Select 
          loc.glb_localidade_descricao
        Into vLocDesc  
        From 
          t_glb_localidade loc
        Where
          loc.glb_localidade_codigo = vCursor.Glb_Localidade_Codigo;  
        
        --Monto a mensagem de retorno.
        vMessage := vMessage || Trim(to_char(vlinha)) || ' - ' || Trim(vCursor.Glb_Localidade_Codigo) || ' - ' || Trim(vLocDesc) || ' - IBGE: ' || VcURSOR.Glb_Localidade_Codigoibge || chr(10) ;
      End If;  
      
    End Loop;
    -- Probelma com a Tatiana Cariacica
    -- -- Felipe 24/01/2015
    if pFcf_veiculodisp_codigo = '2165622'  Then
       vStatus := True;
    End If;
    
    --Caso a variável de status tenha sido mudada para false.
    If (vStatus = false) Then
      --monto a mensagem de retorno.
      vMessage := 'Os destinos definidos na Solicitacao de Frete, não foram atendidas atraves das notas vinculadas.' || chr(10) ||
                  'Abaixo relacao dos destinos nao atendidos. ' || chr(10) ||
                  vMessage || chr(10) ||
                  'Veiculo: ' || pFcf_veiculodisp_codigo || ' Sequencia: ' || pFcf_veiculodisp_sequencia;
    End If;
    
    --Seto os paramentros de saida.
    pMessage := vMessage;
    Return vStatus;
    
  Exception 
    --Erro não esperado
    When Others Then
      pMessage:= 'Erro ao tentar validar Destinos Solicitacao x Destinos Notas. ' || chr(10) ||
                 'Rotina: tdvadm.pkg_fifo_validacoes.fn_vld_destsolicitado(); ' || chr(10) ||
                 'Erro ora: ' || Sqlerrm;
      Return False;           
  End;
  
End FN_Vld_DestSolicitado;  

--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para, validar uma exceção MOP para carregamento com produto quimico.                          --
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_VeicDispMopp( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                              pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                              pMessage Out Varchar2
                            ) Return Boolean Is
 --Variável utilizada para saber se o veiculo possui Particularidade de MOPP
 vMopp Integer;
 
 --Variável utilizada para recuperar quantidade de produtos quimicos 
 vQtdePrdQuimico Integer;
 
 --Variáveis auxiliares, utilizadas para gerar paramentro de saida.
 vStatus Boolean;
 vMessage Varchar2(32000);
Begin

  vMopp := 0;
  vQtdePrdQuimico := 0;
  vStatus := True;
  vMessage := '';
  
  Begin
    --Verifico se foi atribuido uma particularidade de MOPP para o veiculo.
    Select 
      Count(*) Into vMopp
    From
      tdvadm.t_fcf_veiculodisp veic,
      tdvadm.t_fcf_solveic sol,
      tdvadm.t_fcf_solveicpart  part
    Where veic.fcf_veiculodisp_codigo = sol.fcf_veiculodisp_codigo
      And veic.fcf_veiculodisp_sequencia = sol.fcf_veiculodisp_sequencia
      And sol.fcf_solveic_cod = part.fcf_solveic_cod
      And part.fcf_particularidade_cod = 1 -- chumbou Mopp
      And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
      And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia; 
      
    --Se a Varivel for maior que zero, 
    If ( vMopp > 0 ) Then
      --verifico se entre as notas vinculados ao veiculo, alguma possui produto quimico.
      Select
        Count(*) Into vQtdePrdQuimico
      From
        tdvadm.t_fcf_veiculodisp veic,
        tdvadm.t_arm_carregamento carreg,
        tdvadm.t_arm_carregamentodet carregdet,
        tdvadm.t_arm_nota nota,
        tdvadm.t_arm_notafichaemerg emerg
      Where  
        veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
        And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
        And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
        And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
        And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
        And carregdet.arm_embalagem_sequencia = nota.arm_embalagem_sequencia
        And nota.arm_nota_numero = emerg.arm_nota_numero(+)
        And nota.glb_cliente_cgccpfremetente = emerg.glb_cliente_cgccpfremetente(+)
        And nota.arm_nota_serie = emerg.arm_nota_serie(+)
        And emerg.glb_onu_codigo <> '9999'
        And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
        And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia;
    End If;
    
    --Caso o veiculo possua particularidade de mopp, mas nenhum carregamento possua nota com produto quimico.
    If ( vMopp > 0 ) And (vQtdePrdQuimico = 0 ) Then
      vStatus := False;
      vMessage := 'Foi solicitado motorista com MOPP.' || chr(10) ||
                  'Nenhum carregamento possui Nota Fiscal com produto quimico.' || chr(10) || chr(10) ||
                  'Vale de frete nao pode ser gerado.'; 
    End If;
    
    --seto os paramentros de saida.
    pMessage := vMessage;
    Return vStatus;
    
  Exception
    When Others Then
      pMessage := 'Erro ao tentar validar  ';
      Return False;
  End;
End FN_Vld_VeicDispMopp;


--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para, validar uma exceção Expresso para carregamento com Nota Expressa.                       --
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_VeicDispExpresso( pFcf_veiculodisp_codigo In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%Type,
                                  pFcf_veiculodisp_sequencia In tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                                  pMessage Out Varchar2
                                ) Return Boolean Is
 --Variável utilizada para saber se o veiculo possui Particularidade de MOPP
 vExpresso Integer;
 
 --Variável utilizada para recuperar quantidade de produtos quimicos 
 vQtdeExpresso Integer;
 
 --Variáveis auxiliares, utilizadas para gerar paramentro de saida.
 vStatus Boolean;
 vMessage Varchar2(32000);
Begin

  vExpresso := 0;
  vQtdeExpresso := 0;
  vStatus := True;
  vMessage := '';
  
  Begin
    --Verifico se foi atribuido uma particularidade de MOPP para o veiculo.
    Select 
      Count(*) Into vExpresso
    From
      tdvadm.t_fcf_veiculodisp veic
    Where 0=0
      And veic.fcf_veiculodisp_tpfrete = 'E' -- Solicitou um frete expresso..
      And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
      And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia; 
      
    --Se a Varivel for maior que zero, 
    If ( vExpresso > 0 ) Then
      --verifico se entre as notas vinculados ao veiculo, alguma possui produto quimico.
      Select
        Count(*) Into vQtdeExpresso
      From
        tdvadm.t_fcf_veiculodisp veic,
        tdvadm.t_arm_carregamento carreg,
        tdvadm.t_arm_carregamentodet carregdet,
        tdvadm.t_arm_nota nota,
        TDVADM.T_ARM_COLETA CO
      Where  
        veic.fcf_veiculodisp_codigo = carreg.fcf_veiculodisp_codigo
        And veic.fcf_veiculodisp_sequencia = carreg.fcf_veiculodisp_sequencia
        And carreg.arm_carregamento_codigo = carregdet.arm_carregamento_codigo
        And carregdet.arm_embalagem_numero = nota.arm_embalagem_numero
        And carregdet.arm_embalagem_flag = nota.arm_embalagem_flag
        And carregdet.arm_embalagem_sequencia = nota.arm_embalagem_sequencia
        And veic.fcf_veiculodisp_codigo = pFcf_veiculodisp_codigo
        And veic.fcf_veiculodisp_sequencia = pFcf_veiculodisp_sequencia
        AND NOTA.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA (+)
        AND NOTA.ARM_COLETA_CICLO = CO.ARM_COLETA_CICLO (+)
        And ( ( substr(NVL(nota.glb_tpcarga_codigo,'FF'), 1,1) = 'E' ) OR 
              ( SUBSTR(NVL(CO.GLB_TPCARGA_CODIGO ,'FF'),1,1) = 'E'  ) OR
              ( SUBSTR(NVL(CO.Arm_Coleta_Tpcoleta ,'C'),1,1) = 'E'  ) );
    End If;
    
    --Caso o veiculo possua particularidade de mopp, mas nenhum carregamento possua nota com produto quimico.
    If ( vExpresso > 0 ) And (vQtdeExpresso = 0 ) Then
      vStatus := False;
      vMessage := 'Foi solicitado veículo com carga expressa.' || chr(10) ||
                  'Nenhum carregamento possui Nota Fiscal modalidade expressa.' || chr(10) || chr(10) ||
                  'Vale de frete nao pode ser gerado.'; 
    End If;
    
    --seto os paramentros de saida.
    pMessage := vMessage;
    Return vStatus;
    
  Exception
    When Others Then
      pMessage := 'Erro ao tentar validar  ';
      Return False;
  End;
End FN_Vld_VeicDispExpresso;

--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para validar um carregamento antes do fechamento.                                             -- 
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_Carregamento( pArm_carregamento_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                 pMessage Out Varchar2
                                ) Return Boolean Is
 --Variável de controle
 vControl Integer;
Begin
  --inicializa as variáveis 
  vControl := 0;
  
  Begin
    --verifico se no carregamento possui embalagens vinculadas
    Select Count(*) Into vControl
    From
      tdvadm.t_arm_carregamento carreg,
      tdvadm.t_arm_carregamentodet det
    Where
      0=0
      And carreg.arm_carregamento_codigo = pArm_carregamento_codigo
      And carreg.arm_carregamento_codigo = det.arm_carregamento_codigo;
      
    --Caso a variavel de controle retorne mais de 0, temos embalagens possíveis de fechamento.
    If ( vControl > 0 ) Then
      pMessage := 'Carregamento ' || pArm_carregamento_codigo  || '  possui: ' || Trim(to_char(vControl)) || ' embalagens prontas para fechamento.' ;
      Return True;
    End If;
    
    --caso a variável de controle retorne 0, quer dizer que não temos nenhuma embalagem possivel de fechamento.
    If ( vControl = 0 ) Then
      pMessage := 'Carregamento ' || pArm_carregamento_codigo || ' não possui nenhuma embalagem possivel de fechamento.' ;
      Return False;
    End If;
                     
  Exception
    --caso ocorra algum erro não esperado
    When Others Then
      pMessage := 'Erro ao validar embalagens para fechamento.' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_validacoes.fn_vld_embcarregamento(); ' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return False;             
  End;  
  
End FN_Vld_Carregamento; 


--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para validar a embalagem antes de um carregamento                                             -- 
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_EmbalagemCarreg( pArm_carreamento_codigo In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                 pArm_embalagem_numero In tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                                 pArm_embalagem_sequencia In tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                                 pArm_embalagem_flag In tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                                 pMessage Out Varchar2
                               ) Return Boolean Is 
 --Variável inteira, utilizada para controlete de erro.
 vControlErro Integer;
 
 --Variável string, utilizada para montar mensagem
 vMessage Varchar2(30000);
 
 --Variável de controle
 vControl Integer;
                                
Begin
  --inicializo as variáveis que serão utilizadas nessa função
  vControlErro := 0;
  vMessage := 0;
  vControl := 0;
  
  Begin
    --Verifico se a embalagem está registrada para para processo automático
    Select Count(*) Into vControl
    From t_arm_carregamentoaut aut
    Where aut.arm_embalagem_numero = pArm_embalagem_numero
      And aut.arm_embalagem_flag = pArm_embalagem_flag
      And aut.arm_embalagem_sequencia = pArm_embalagem_sequencia
      And 0 = ( Select Count(*) From t_glb_status status
                Where status.glb_status_codigo = aut.glb_status_codigoproc
                 And nvl(status.glb_status_flagfinal, 'r') <> 'S'
               );
    
    --Caso a embalagem já esteja registrada para fechamento automático.
    If ( vControl > 0 ) Then
      vControlErro := vControlErro + 1;
      vMessage := vMessage || lpad(vControlErro, 2, '0') || ' - Embalagem ' || pArm_embalagem_numero || ' relacionada para fechamento automatico.' || chr(10);
    End If;
    
    
    --Caso a variável de erro tenha sido implementada.
    If ( vControlErro > 0 ) Then
      --Define a mensagem de retorno
      pMessage := vMessage;
      Return False;
    End If;
    
    --seto os paramentros de saida
    Return True;
    
  Exception
    --erro não previsto.
    When Others Then
      pMessage := 'Erro ao validar embalagem para carregamento.' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_validacoes.fn_vld_embalagemcarreg()' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return False;            
  End;
  
  
End;                                  

--------------------------------------------------------------------------------------------------------------------
-- Função utilizada para realizar validação da chave de um Cte                                                    --
--------------------------------------------------------------------------------------------------------------------
Function FN_Vld_ChaveCte( pDadosRedesp In pkg_fifo.tDadosRedespacho,
                          pMessage Out Varchar2
                         ) Return Boolean Is
 --Variável utilizada para gerar mensagem
 vMessage Varchar2(20000);                         
 
 --Variável contadora de erros
 vControl Integer;
Begin
  --inicializa as variáveis que serão utilizadas nessa função.
  vMessage := '';
  vControl := 0;
  
  Begin
    --verifico se a chave possui 44 posições
    If ( length(Trim(pDadosRedesp.arm_notaredespacho_chavecte)) != 44 ) Then
      --incremento a variável contadora
      vControl := vControl +1;
      
      --Registro mensagem de erro.
      vMessage := vMessage || to_char(vControl) || ' - Chave Cte deve possuir 44 posições.' || chr(10);
    End If;

    --verifico se o cnpj da transportadora bate com o CNPJ da chave.
    If ( substr(Trim(pDadosRedesp.arm_notaredespacho_chavecte), 7, 14) != Trim(pDadosRedesp.arm_notaredespacho_cnpjctrc) ) Then
      --incremento a variável contadora
      vControl := vControl +1;
      
      --Registro mensagem de erro.
      vMessage := vMessage || to_char(vControl) || ' - CTRC, não pertence a transportadora indicada.' || chr(10);
    End If;
    
    --Verifico se o número do conhecimento, bate com o número registrado na chave
    If ( substr(Trim(pDadosRedesp.arm_notaredespacho_chavecte), 29, 6) != Trim(pDadosRedesp.arm_notaredespacho_ctrc)  )  Then
      --incremento a variável contadora
      vControl := vControl +1;
      
      --Registro mensagem de erro.
      vMessage := vMessage || to_char(vControl) || ' - Numero do CTRC invalido.' || chr(10);
    End If;
    
    --Verifico se o mes/ano indicado na chave, bate com o da data indicada
    If ( substr(Trim(pDadosRedesp.arm_notaredespacho_chavecte), 3, 4) != to_char(pDadosRedesp.arm_notaredespacho_dtemissao, 'yymm') ) Then
      --incremento a variável contadora
      vControl := vControl +1;
      
      --Registro mensagem de erro.
      vMessage := vMessage || to_char(vControl) || ' - Data indicada como emissão do CTRC terceiro, invalida.' || chr(10);
    End If;
    
   
    --Verifico se algum erro foi registradona variável de controle
    If ( vControl > 0 ) Then
      --lanço a exceção de erro de validação
      Raise vEx_Validacao;
      
    End If;
    
    
    --Seto os paramentros de saida
    pMessage := '';
    Return True;
    
  Exception
    --Exceção de validação 
    When vEx_Validacao Then
      pMessage := 'ERROS ENCONTRADOS AO VALIDAR CHAVE DO CTRC DE TERCEIRO ' || CHR(10) ||
                  vMessage;
      Return False;
      
    --Caso ocorra algum erro não esperado
    When Others Then
      pMessage := 'Erro ao validar chave do cte. ' || chr(10) ||
                  'tdvadm.pkg_fifo_validacoes.fn_vld_chavecte(); ' || chr(10) ||
                  'Erro Ora: ' || Sqlerrm;
      Return False;             
  End;
  
End FN_Vld_ChaveCte;   

-----------------------------------------------------------------------------------------------------------------
-- Função utilizada para validar Tratamento de embalagem.                                                      --
-----------------------------------------------------------------------------------------------------------------
Function FN_Vld_TratamentoEmb( pArm_embalagem_numero In tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                               pArm_embalagem_flag In tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                               pArm_embalagem_sequencia In tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                               pMessage Out Varchar2
                              ) Return Boolean Is 
 --Variável utilizada para saber se tem algum processo não finalizado. 
 vCountProcNaoFinal Integer;
 vOcorrenciacol tdvadm.t_arm_coletaocor.arm_coletaocor_codigo%type;
 vFlagFinaliza tdvadm.t_arm_coletaocor.arm_coletaocor_finaliza%type;
 vFlagEncerraDig tdvadm.t_arm_coletaocor.arm_coletaocor_encerradig%type;
 vNota tdvadm.t_arm_nota.arm_nota_numero%type;
 vColeta tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
 vCiclo tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
Begin
  --inicializa as variáveis que serão utilizados nessa função
  vCountProcNaoFinal := 0;
  
  Begin
    --Verifico se a embalagem está em algum processo não finalizado.
    Select Count(*) Into vCountProcNaoFinal 
    From t_arm_carregstatus st
    Where st.arm_embalagem_numero = pArm_embalagem_numero
     And st.arm_embalagem_flag = pArm_embalagem_flag
     And st.arm_embalagem_sequencia = pArm_embalagem_sequencia
     And 0 = ( Select Count(*) From t_glb_status status
                Where status.glb_status_codigo = st.glb_status_codigoproc
                 And nvl(status.glb_status_flagfinal, 'r') != 'S'
              );
     
     --Caso tenha encontrado algum registro, 
     If ( vCountProcNaoFinal > 0 )  Then
       pMessage := 'Embalagem : ' || trim(to_char(pArm_embalagem_numero)) || ' esta registrada em um processo nao finalizado.';
       Return False;
     End If;   
     -- Testa se a Coleta esta finalizada
     Begin
         Select n.arm_nota_numero,
                n.arm_coleta_ncompra,
                n.arm_coleta_ciclo,
                oc.arm_coletaocor_codigo,
                oc.arm_coletaocor_finaliza,
                oc.arm_coletaocor_encerradig
                  into vNota,
                       vColeta,
                       vCiclo,
                       vOcorrenciacol,
                       vFlagFinaliza,
                       vFlagEncerraDig
           from t_arm_nota n,
                t_arm_coleta c,
                t_arm_coletaocor oc
         where n.arm_embalagem_numero = pArm_embalagem_numero
           and n.arm_embalagem_flag = pArm_embalagem_flag
           and n.arm_embalagem_sequencia = pArm_embalagem_sequencia
           and n.arm_coleta_ncompra = c.arm_coleta_ncompra (+)
           and n.arm_coleta_ciclo = c.arm_coleta_ciclo (+)
           and c.arm_coletaocor_codigo = oc.arm_coletaocor_codigo (+);
         If vColeta is null then
             pMessage := 'Embalagem : ' || trim(to_char(pArm_embalagem_numero)) || ' Nota : ' || trim(to_char(vNota)) || ' Sem Coleta';
             return False;
         ElsIf vOcorrenciacol is null Then
             pMessage := 'Coleta : ' || vColeta || '-' || vCiclo || ' Não encerrada.';
             pMessage := '';
             return True;
         ElsIf vOcorrenciacol is Not Null Then
            if vFlagFinaliza = 'N' and vFlagEncerraDig = 'N' Then
                pMessage := 'Coleta : ' || vColeta || '-' || vCiclo || ' Não encerrada.';
                pMessage := '';
                return True;
            End If;
         End If;       
     Exception
       When NO_DATA_FOUND Then
          pMessage := 'Embalagem : ' || trim(to_char(pArm_embalagem_numero)) || ' Sem Nota.';
          return False;
       End; 


     
     --Seto os paramentros de retorno.
     pMessage := '';
     Return True;
    
  Exception
    --erro não esperado
    When Others Then
      pMessage := 'Erro ao tentar validar operação com embalagens' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_carregamento.fn_vld_tratamentoemb(); ' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return False;
  End;

End FN_Vld_TratamentoEmb;                                              
                        


End pkg_fifo_validacoes;
/
