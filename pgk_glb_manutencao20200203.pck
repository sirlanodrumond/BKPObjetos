create or replace package glbadm.pgk_glb_manutencao is

--------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para excluir, limpar, organizar, gerar log de alguns processos.                                   --
--Essa procedure é executada através do job nº , uma vez por dia, as 00hs                                               --
--------------------------------------------------------------------------------------------------------------------------
Procedure SP_MNT_Diaria( pData  in Date,
                         pStatus out char );

--Procedure utilizada para atualizar o Flag de DescBonus na tabela de Vale de Frete.
procedure sp_atz_DescBonusVF( pStatus out char,
                              pMessage out varchar2
                            ); 
                            
-- Procedure utilizada para Cancelar Vales de Frete, emitidos e não impressos dentro do prazo.
--procedure sp_lmp_SemImpressaoVF( pStatus out char,
--                                 pMessage out varchar2
--                            ); 

--Procedure Aplidada de Lixeiro que passa A noite.
procedure sp_Manutencao(pDataExec  in date);

-- Procedure que atualiza as tabelas do Eclick, são rodadas pelo sp_manutencao
procedure sp_Atualizado_eclick;

 

--Procedure que será executada uma vez por hora.
procedure SP_MANUTENCAO_HORA;


end pgk_glb_manutencao;

 
/
create or replace package body glbadm.pgk_glb_manutencao is


-- Grupo Que geram " ROMANEIO DE NOTAS "
-- CRIADO PARAMETRO CONTENDO A LISTA DOS GRUPOS, CASO NÂO SEJA ENCONTRADO, USARÁ ESTE DEFAULT
cnGruposListaNota varchar2(200) := '0006;0020;0074;0534;0535;0541;0565;0567;0569;0570;0597;0612;0613;0614;0628;0630;0632;0633;0634;0639;0643;0647;0615';
                        
--------------------------------------------------------------------------------------------------------------------------------
-- Procedure Aplidada de "LIXEIRO QUE PASSA A NOITE" pelo Sirlano                                                               --
-- Essa proceure é executada pelo Job 2579, que está programado para passar uma vez por dia, as 00:00 Trunc(sysdate),         --         
-- eu adiciono aqui todos os processos que eu quero que sejam realizados uma vez por dia.                                     --
--------------------------------------------------------------------------------------------------------------------------------     
PROCEDURE SP_MANUTENCAO(PDATAEXEC  IN DATE) IS
 --Variáveis utilizadas para executar as procedure de manutenção
 vStatus char(01);
 vMessage varchar2(30000);
 vMessage2 varchar2(30000);
 vCorpoEmail clob;

 
 --Variável utilizada apenas para administrar as pessoas que receberão e-mail de confirmação do procedimento.
 vDestinoEmails tdvadm.t_uti_infomail.uti_infomail_endmaildestinatar%type;
 vAuxiliar number;
BEGIN
 --Inicializo as variáveis que serão utilizadas nessa procedure
 vStatus := '';
 vMessage := '';
 vDestinoEmails := '';
 vCorpoEmail := empty_clob;
 
 
 /***************************************************************/
 /*    update de atualizacao do SIMPLES NACIONAL                */
 /***************************************************************/
 
 


update tdvadm.t_car_proprietario p
  set p.car_proprietario_optsimples = (select decode(nvl(substr(c.omn_consulta_situacao,1,3),'NÃO'),'NÃO','N','S')
                                       from tdvadm.t_omn_consulta c
                                       where c.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo
                                         and c.omn_consulta_status = 'OK'
                                         and trunc(c.omn_consulta_data) >= to_date('01/01/2018','dd/mm/yyyy')
                                         and trunc(c.omn_consulta_data) <= to_date(sysdate,'dd/mm/yyyy')
                                         and c.omn_consulta_nomefonte = 'RECEITA_SIMPLES'
                                         and c.omn_consulta_id = (select max(c1.omn_consulta_id)
                                                                  from tdvadm.t_omn_consulta c1
                                                                  where c1.car_proprietario_cgccpfcodigo = c.car_proprietario_cgccpfcodigo) )
where p.car_proprietario_cgccpfcodigo in (select distinct c.car_proprietario_cgccpfcodigo 
                                          from tdvadm.t_omn_consulta c,
                                               tdvadm.t_car_proprietario p2
                                          where c.car_proprietario_cgccpfcodigo = p2.car_proprietario_cgccpfcodigo
                                            and c.omn_consulta_status = 'OK'
                                            and trunc(c.omn_consulta_data) >= to_date('01/01/2018','dd/mm/yyyy')
                                            and trunc(c.omn_consulta_data) <= to_date(sysdate,'dd/mm/yyyy')
                                            and c.omn_consulta_nomefonte = 'RECEITA_SIMPLES' 
                                            and c.omn_consulta_id = (select max(c1.omn_consulta_id)
                                                                  from tdvadm.t_omn_consulta c1
                                                                  where c1.car_proprietario_cgccpfcodigo = c.car_proprietario_cgccpfcodigo)
                                            and p2.car_proprietario_optsimples <> decode(nvl(substr(c.omn_consulta_situacao,1,3),'NÃO'),'NÃO','N','S'));

commit;                                           

 
  /***********************************************************************************************************************************/
  /*   ROTINA QUE MANDA OS PERCURSOS INCLUIDOS NO DIA ANTERIOR
  /***********************************************************************************************************************************/

    vCorpoEmail := null;
    for c_msg in (select distinct 
                  --an.arm_nota_numero nota,
                  --an.glb_cliente_cgccpfremetente remet,
                  --an.arm_nota_serie serie,
                  an.arm_nota_localcoletal coleta,
                  an.arm_nota_localentregal entrega,
                  an.slf_contrato_codigo contrato,
                  p.slf_percurso_datacadastro dtcadastro,
                  p.slf_percuso_descricao percurso
            from tdvadm.t_arm_nota an,
                 tdvadm.t_slf_percurso p
            where an.arm_nota_localcoletal = p.glb_localidade_codigoorigem (+)
              and an.arm_nota_localentregal = p.glb_localidade_codigodestino (+)
              and an.slf_contrato_codigo = 'C2018010119'
              and trunc(p.slf_percurso_datacadastro) >= trunc(PDATAEXEC))
    Loop
       vCorpoEmail := vCorpoEmail || c_msg.percurso || chr(10);
    End Loop;
   
     If vCorpoEmail is not null Then
         wservice.pkg_glb_email.SP_ENVIAEMAIL('NOVOS PERCURSOS',
                                              vCorpoEmail,
                                              'aut-e@dellavolpe.com.br',
                                              'rayaraujo@dellavolpe.com.br;mabreu@dellavolpe.com.br');
       
     End If;



    
    tdvadm.pkg_slf_percurso.sp_slf_informaPercurso('0020',1,vStatus,vCorpoEmail);
    If vStatus = 'N' Then
       wservice.pkg_glb_email.SP_ENVIAEMAIL('NOVOS PERCURSOS',
                                            vCorpoEmail,
                                            'aut-e@dellavolpe.com.br',
                                            'tiago.bernardes@vale.com;cteresponse@vale.com;vini;vinicius.esteves@vale.com',
                                            'sdrumond@dellavolpe.com.br');
    End If;
 
  /***********************************************************************************************************************************/
  /*  Rotina inserir uma ocorrencia nas coletas não usadas.
  /*  Sera usada a Ocorrencia 72                                                                           */                                                                            
  /*                                                                                                                                 */                                                                           
  /***********************************************************************************************************************************/
   
  For C_MSG in (SELECT CO.ARM_COLETA_NCOMPRA,
                       CO.ARM_COLETA_CICLO,
                       CO.ARM_COLETA_DTSOLICITACAO,
                       (select count(*)
                        from tdvadm.t_xml_coleta xo
                        where xo.arm_coleta_ncompra = co.arm_coleta_ncompra
                          and xo.arm_coleta_ciclo = co.arm_coleta_ciclo
                          and xo.xml_coleta_tipodoc = 'ASN') qtdeASN,
                       (select count(*)
                        from tdvadm.t_xml_coleta xo
                        where xo.arm_coleta_ncompra = co.arm_coleta_ncompra
                          and xo.arm_coleta_ciclo = co.arm_coleta_ciclo
                          and xo.xml_coleta_tipodoc = 'ASNR') qtdeASNR
                          
                FROM tdvadm.T_ARM_COLETA CO
                WHERE 0 = 0
                  and co.arm_coletaocor_codigo is null
                  and co.arm_coleta_dtprogramacao <= sysdate - 90
                  and 0 = (SELECT COUNT(*)
                           FROM tdvadm.t_Arm_Nota AN
                           WHERE AN.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA
                             AND AN.ARM_COLETA_CICLO = CO.ARM_COLETA_CICLO)
                  AND 0 = (SELECT COUNT(*)
                           FROM tdvadm.t_CON_CONHECIMENTO AN
                           WHERE AN.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA
                             AND AN.ARM_COLETA_CICLO = CO.ARM_COLETA_CICLO))
   loop
     
--       If C_MSG.qtdeASN = 0 then
          update tdvadm.t_arm_coleta co
            set co.arm_coletaocor_codigo = '72',
                co.arm_coleta_dtfechamento = sysdate
           where co.arm_coleta_ncompra = c_msg.arm_coleta_ncompra
             and co.arm_coleta_ciclo = c_msg.arm_coleta_ciclo;
--       End If;
     
   End Loop;
  
   commit;                       
  
  





  /***********************************************************************************************************************************/
  /*  Rotina para Atualizar o Ranking de Cliente Remetente                                                                           */                                                                            
  /*                                                                                                                                 */                                                                           
  /***********************************************************************************************************************************/
  begin
    --define os endereços que receberá mensagem de confirmação.

    
    vDestinoEmails := '';
    vDestinoEmails := vDestinoEmails || 'jmoreira@dellavolpe.com.br;';
    vDestinoEmails := vDestinoEmails || 'rnovak@dellavolpe.com.br;';
    vDestinoEmails := vDestinoEmails || 'ksouza@dellavolpe.com.br;';
    

    --Executo a procedure correspondente.
    tdvadm.sp_acum_remetentecolocacao(trim(to_char(sysdate,'yyyymm')));
    tdvadm.sp_acum_sacadocolocacao(trim(to_char(sysdate,'yyyymm')));
    
    vMessage := 'Rodou o Mes ' || trim(to_char(sysdate,'mm'));
    
    

    
    tdvadm.sp_acum_remetentecolocacao(trim(to_char(ADD_MONTHS(sysdate,-1),'yyyymm')));
    tdvadm.sp_acum_sacadocolocacao(trim(to_char(ADD_MONTHS(sysdate,-1),'yyyymm')));
    
    vMessage := vMessage||' e o Mes ' || trim(to_char(add_months(sysdate,-1),'mm'));
    vStatus  := 'N';
 
    
 
    --Envio o e-mail com a confirmação da operação.
    wservice.pkg_glb_email.SP_ENVIAEMAIL('Rotina executada pelo Lixeiro - Atauliza Posicao Cliente Remetente',
                                        'Status da Rotina: ' || vStatus || chr(13) ||  'Mensagem: ' || vMessage,
                                        'aut-e@dellavolpe.com.br',
                                        Trim(vDestinoEmails));
                      
  Exception
    --Caso ocorra algum erro que impessa a execução da procedure envia o e-mail avisando
    when others then
    wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro na rotina executada pelo Lixeiro',
                                        'A rotina "sp_acum_remetentecolocacao", não foi executada corretamente. ' || chr(13) || sqlerrm || chr(13) || chr(13) ||    
                                        'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações',
                                        'aut-e@dellavolpe.com.br',
                                        Trim(vDestinoEmails));
  end; 
  



  /***********************************************************************************************************************************/
  /* Primeiro procedimento será a atualização do Flag de DescBonus.                                                                  */
  /* Essa ação foi solicitado pelo Sirlano, por e-mail "27/03/2012 14:17"                                                            */
  /* Procedimento apenas deve ser desativado quando o Front-End do Vale de Frete cobrir essa necessidade.                            */
  /* E-mails relacionados: ;                                                                               */ 
  /***********************************************************************************************************************************/
  begin
    --define os endereços que receberá mensagem de confirmação.
    vDestinoEmails := '';
    
    --Executo a procedure correspondente.
    pgk_glb_manutencao.sp_atz_DescBonusVF(vStatus, vMessage );
  
    --Envio o e-mail com a confirmação da operação.
    if vDestinoEmails <> '' then
       wservice.pkg_glb_email.SP_ENVIAEMAIL('Rotina executada pelo Lixeiro - Atz Bonus VF',
                                            'Status da Rotina: ' || vStatus || chr(13) ||  'Mensagem: ' || vMessage,
                                            'aut-e@dellavolpe.com.br',
                                            Trim(vDestinoEmails));
    End If;
  Exception
    --Caso ocorra algum erro que impessa a execução da procedure envia o e-mail avisando
    when others then
      wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro na rotina executada pelo Lixeiro',
                                           'A rotina "pgk_glb_manutencao.sp_atz_DescBonusVF", não foi executada corretamente. ' || chr(13) || sqlerrm || chr(13) || chr(13) || 'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações',
                                           'aut-e@dellavolpe.com.br',
                                           'sdrumond@dellavolpe.com.br');
  end;  
 

  /*******************************************************************************************************************************************************************/
  /*  Bloco utilizado para excluir todos os vales, com as seguintes condições.                                                                                       */ 
  /*  Vales Não impressos e imputados no sistema a mais de 5 dias.                                                                                                   */
  /*  Vales Impressos mas não entrados no caixa, inputados no sistema a mais de 15 dias.                                                                             */
  /*******************************************************************************************************************************************************************/
  begin
    vDestinoEmails := '';
    vDestinoEmails := vDestinoEmails || 'tdv.spexpedicao@dellavolpe.com.br;';
    vDestinoEmails := vDestinoEmails || 'grp.hd@dellavolpe.com.br;';
    
    
    -- VLN = Vales não Impressos
    -- VLI = Vales Impressos.
    
    --Executa a procedure que vai excluir os vales não impressos.
    tdvadm.pkg_acc_vales.sp_ExcluirVales('VLN', PDATAEXEC, vStatus, vMessage);
    
    --Executo a Procedure que vai excluir os vales impressos e não pagos
    tdvadm.pkg_acc_vales.sp_ExcluirVales('VLI', PDATAEXEC, vStatus, vMessage2);
    
     --Envio o e-mail com a confirmação da operação.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Exclusao Vales',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina de exclusão dos vales não Impressos (5 dias) : ' || vMessage || chr(13) ||
                         'Mensagem gerada pela rotina de exclusão dos vales Impressoa e não pagos (15 dias): ' || vMessage2 
                        );
    
    
  Exception
    --caso ocorra algum erro durante a execução da procedure de exclusão de vales.
    when others then 
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           vDestinoEmails,
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "tdvadm.pkg_acc_vales.sp_ExcluirValesF", não foi executada corretamente. ' || chr(13) || sqlerrm || chr(13) || chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                        );
  end;
  
/*******************************************************************************************************************************************************************/
/* Bloco utilizado para atualizar os RNTRCs cadastrados.
/*******************************************************************************************************************************************************************/
  begin
    vDestinoEmails := '';
    
    --executo a procedure responsável por realizar a atualização dos RNTRCs.
    tdvadm.pkg_cfe_validamotor.sp_atualizaConsRntrc( sysdate,
                                                     vStatus,
                                                     vMessage
                                                   );
    
    --Caso o retorno não seja Normal, forço um erro.
    if vStatus <> tdvadm.pkg_glb_common.Status_Nomal then
      raise_application_error(-20001, vMessage);
    end if;  

    If vDestinoEmails <> '' Then
       --Envio o e-mail com a confirmação da operação.
       tdvadm.sp_enviamail( 'SEQUENCIAL',
                            Trim(vDestinoEmails),
                            'Rotina executada pelo Lixeiro - Atz RNTRC',
                            'Status da Rotina: ' || vStatus || chr(13) ||  
                            'Mensagem gerada pela rotina: ' || chr(13) || vMessage
                           );
    End IF;

  exception
    --Caso ocorra algum erro, envia o e-mail com o erro gerado.
    when others then
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           vDestinoEmails,
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "tdvadm.pkg_cfe_validamotor.sp_atualizaConsRntrc", não foi executada corretamente. ' || chr(13) || 
                           sqlerrm || chr(13) || 
                           chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                        );

      
  end;
  
/*******************************************************************************************************************************************************************/
/* Bloco utilizado para atribuir permissões para o Tracking para novos usuarios "WEB"                                                                              */                 
/*******************************************************************************************************************************************************************/
  Begin
    vDestinoEmails := '';
    vDestinoEmails := vDestinoEmails ||  'jdonega@dellavolpe.com.br;'; --Daiane
    vDestinoEmails := vDestinoEmails ||  'tdv.spkpi4@dellavolpe.com.br;'; --Kate
    
    --Limpo as variáveis que serão utilizadas nesse bloco.
    vStatus := '';
    vMessage := '';
    
    -- Executo a procedure utilizada para atribuir as permissões 
    coleta.pkg_web.SP_SET_PermTracking( Trunc(PDATAEXEC) -3, vStatus, vMessage); 
    
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Atz Perms Tracking',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "coleta.pkg_web.SP_SET_PermTracking"' 
                        );




  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "coleta.pkg_web.SP_SET_PermTracking", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  
  
/******************************************************************************/
/* Sirlano                                                                    */
/* Bloco utilizado para Re-Calcular os Custos de Ctrc com Margem menor que 5% */                 
/* Impementada em 16/04/2013                                                  */
/******************************************************************************/
  Begin
    vDestinoEmails := '';
    vDestinoEmails := vDestinoEmails ||  'jmoreira@dellavolpe.com.br;';
    
    --Limpo as variáveis que serão utilizadas nesse bloco.
    vStatus := '';
    vMessage := '';
    -- Margem Utilizada
    vAuxiliar := 5;
    -- Executo a procedure utilizada para atribuir as permissões 
      tdvadm.pkg_con_valefrete.SP_RecalculaCusto(vAuxiliar,'000', vStatus, vMessage);
    
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Recalculo de Custos Margem menor que ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_con_valefrete.SP_RecalculaCusto"' 
                        );




  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "tdvadm.pkg_con_valefrete.SP_RecalculaCusto", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  


/******************************************************************************/
/* Klayton                                                                    */
/* Bloco util. para rodas a rotina de Exclusão de CTRC na serie XXX > 10 Dias */                 
/* Impementada em 10/09/2013                                                  */
/******************************************************************************/
  Begin
    vDestinoEmails := '';
    vDestinoEmails := vDestinoEmails ||  'ksouza@dellavolpe.com.br;';
    
    --Limpo as variáveis que serão utilizadas nesse bloco.
    vStatus := '';
    vMessage := '';
    -- Margem Utilizada
    vAuxiliar := 5;
    -- Executo a procedure utilizada para atribuir as permissões 
      tdvadm.pkg_con_ctrc.SP_LIMPA_CONHEC_XXX;
    
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro  - Limpeza de CTRC na serie XXX com mais de 10 dias',
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo sistema' 
                        );




  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro - Limpeza de CTRC na serie XXX com mais de 10 dias',
                           'A rotina "tdvadm.sp_limpa_conhec_xxx", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) ||chr(13) ||'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  

  sp_Atualizado_eclick;
  

  /*****************************************************************************************************/
  /* ROBERTO                                                                                           */
  /* Bloco util. para rodar a rotina de Exclusão de Vales de frete com emissão > 5 dias e não impressos*/                 
  /* Impementada em 10/09/2013                                                                         */
  /*****************************************************************************************************/
    begin
    --define os endereços que receberá mensagem de confirmação ou erro.
    vDestinoEmails := '';
    vDestinoEmails := vDestinoEmails || 'ksouza@dellavolpe.com.br;';
    vDestinoEmails := vDestinoEmails || 'rpariz@dellavolpe.com.br;';
    vDestinoEmails := vDestinoEmails || 'grp.hd@dellavolpe.com.br;';
    
    --Executo a procedure correspondente.
    tdvadm.sp_lmp_semimpressaovf(5);

    --Limpa tabela T_GLB_AMBIENTELOGON 
--    delete TDVADM.T_GLB_AMBIENTELOGON lg
--     where l."data" <= trunc(sysdate-30);
  
    --Envio o e-mail com a confirmação da operação.
    wservice.pkg_glb_email.SP_ENVIAEMAIL('Rotina executada pelo Lixeiro - Vale frete não impresso!',
                                         'Status da Rotina: ' || 'N' || chr(13) ||  'Mensagem: ' ||'Rotina executada com sucesso!' ,
                                         'aut-e@dellavolpe.com.br',
                                         Trim(vDestinoEmails));
   Exception
    --Caso ocorra algum erro que impessa a execução da procedure envia o e-mail avisando
    when others then
      wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro na rotina executada pelo Lixeiro',
                                           'A rotina "pgk_glb_manutencao.sp_lmp_semimpressaovf", não foi executada corretamente. ' || chr(13) || sqlerrm || chr(13) || chr(13) || 'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações',
                                           'aut-e@dellavolpe.com.br',
                                           Trim(vDestinoEmails));
   end;  
  
    
    -- Limpando as tabelas de Bloqueio, Jogando para o Historico

    insert into tdvadm.t_car_proprietariosusphist 
    select p.car_proprietario_cgccpfcodigo,
           p.Car_Proprietariosusp_Sequencia,
           p.GLB_CLIENTE_CGCCPFCODIGO,
           p.CAR_PROPRIETARIOSUSP_REM,
           p.CAR_PROPRIETARIOSUSP_SAC,
           p.CAR_PROPRIETARIOSUSP_DEST,
           p.CAR_PROPRIETARIOSUSP_DIAS,
           p.CAR_PROPRIETARIOSUSP_DT,
           p.Car_Proprietariosusp_Boqueio,
           p.USU_USUARIO_CODIGO,
           p.CAR_PROPRIETARIOSUSP_OBS,
           p.usu_usuario_codigo,
           SYSDATE,
           p.car_proprietariosusp_dtgrav
    from tdvadm.t_car_proprietariosusp p
    where ( nvl(p.car_proprietariosusp_dias,0) <> 0
       and trunc(nvl(p.car_proprietariosusp_dt,sysdate) + nvl(p.car_proprietariosusp_dias,0)) < trunc(sysdate) )
       and 0 = (select count(*)
               from tdvadm.t_car_proprietariosusphist ph
               where ph.car_proprietario_cpfcodigo = p.car_proprietario_cgccpfcodigo
    --             and ph.glb_cliente_cgccpfcodigo = p.glb_cliente_cgccpfcodigo
                 and ph.car_proprietariosusp_sequencia = p.car_proprietariosusp_sequencia);
    delete tdvadm.t_car_proprietariosusp p
    where ( nvl(p.car_proprietariosusp_dias,0) <> 0
       and trunc(nvl(p.car_proprietariosusp_dt,sysdate) + nvl(p.car_proprietariosusp_dias,0)) < trunc(sysdate) );

       
    insert into tdvadm.t_car_veiculosusphist
    select p.CAR_VEICULO_PLACA,
           p.CAR_VEICULOSUSP_SEQUENCIA,
           p.GLB_CLIENTE_CGCCPFCODIGO,
           p.CAR_VEICULOSUSP_REM,
           p.CAR_VEICULOSUSP_SAC,
           p.CAR_VEICULOSUSP_DEST,
           p.CAR_VEICULOSUSP_DIAS,
           p.CAR_VEICULOSUSP_DT,
           p.CAR_VEICULOSUSP_BLOQUEIO,
           p.USU_USUARIO_CODIGO,
           p.CAR_VEICULOSUSP_OBS,
           p.usu_usuario_codigo,
           SYSDATE,
           p.car_veiculosusp_dtgravacao   
    from tdvadm.t_car_veiculosusp p
    where ( nvl(p.car_veiculosusp_dias,0) <> 0
       and trunc(nvl(p.car_veiculosusp_dt,sysdate) + nvl(p.car_veiculosusp_dias,0)) < trunc(sysdate) )
       and 0 = (select count(*)
               from tdvadm.t_car_veiculosusphist ph
               where ph.car_veiculo_placa = p.car_veiculo_placa
                 and ph.car_veiculosusp_sequencia = p.car_veiculosusp_sequencia);

    delete tdvadm.t_car_veiculosusp p
    where ( nvl(p.car_veiculosusp_dias,0) <> 0
       and trunc(nvl(p.car_veiculosusp_dt,sysdate) + nvl(p.car_veiculosusp_dias,0)) < trunc(sysdate) );


    insert into tdvadm.t_car_carreteirosusphist 
    select c.car_carreteiro_cpfcodigo,
           c.car_carreteirosusp_sequencia,
           c.GLB_CLIENTE_CGCCPFCODIGO,
           c.CAR_CARRETEIROSUSP_REM,
           c.CAR_CARRETEIROSUSP_SAC,
           c.CAR_CARRETEIROSUSP_DEST,
           c.CAR_CARRETEIROSUSP_DIAS,
           c.CAR_CARRETEIROSUSP_DT,
           c.CAR_CARRETEIROSUSP_BLOQUEIO,
           c.USU_USUARIO_CODIGO,
           c.CAR_CARRETEIROSUSP_OBS,
           c.usu_usuario_codigo,
           SYSDATE,
           c.car_carreteirosusp_dtgravacao
    from tdvadm.t_car_carreteirosusp c             
    where (nvl(c.car_carreteirosusp_dias,0) <> 0
       and trunc(nvl(c.car_carreteirosusp_dt,sysdate) + nvl(c.car_carreteirosusp_dias,0)) < trunc(sysdate))
      and 0 = ( select count(*)
                from tdvadm.t_car_carreteirosusphist cs
                where cs.car_carreteiro_cpfcodigo = c.car_carreteiro_cpfcodigo
                  and cs.car_carreteirosusp_sequencia = c.car_carreteirosusp_sequencia );


    delete tdvadm.t_car_carreteirosusp c             
    where nvl(c.car_carreteirosusp_dias,0) <> 0
       and trunc(nvl(c.car_carreteirosusp_dt,sysdate) + nvl(c.car_carreteirosusp_dias,0)) < trunc(sysdate); 



   

END SP_MANUTENCAO;


procedure sp_Atualizado_eclick
  as
   vStatus char(01);
   vMessage varchar2(30000);
   vMessage2 varchar2(30000);
   vMesAnoI  char(7);
   vMesAnoF  char(7);
   --Variável utilizada apenas para administrar as pessoas que receberão e-mail de confirmação do procedimento.
   vDestinoEmails tdvadm.t_uti_infomail.uti_infomail_endmaildestinatar%type;
   vAuxiliar number;
Begin
  
  
/******************************************************************************/
/* Sirlano                                                                    */
/* Bloco utilizado para Alimentar tabelas do Eclick                           */                 
/* Impementada em 02/08/2013                                                  */
/******************************************************************************/
  Begin
    vDestinoEmails := '';
    vDestinoEmails := vDestinoEmails ||  'grp.kpi@dellavolpe.com.br;';
    
    --Limpo as variáveis que serão utilizadas nesse bloco.
    vStatus := '';
    vMessage := '';
    vMessage2 := 'tdvadm.pkg_ope_frota.SP_Set_Motoristas';
    -- Executo a procedure utilizada para atribuir as permissões 
   
    tdvadm.pkg_ope_frota.SP_Set_Motoristas(vStatus,vMessage);
    
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Tabelas do Eclik ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_ope_frota.SP_Set_Motoristas"' 
                        );
  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  
  
  Begin
    vStatus := '';
    vMessage := '';
    vMessage2 := 'tdvadm.pkg_ope_frota.sp_set_cadastrogeral';
    tdvadm.pkg_ope_frota.sp_set_cadastrogeral(vStatus,vMessage);
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Tabelas do Eclik ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_ope_frota.sp_set_cadastrogeral"' 
                        );

  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  
  

  Begin
    vStatus := '';
    vMessage := '';
    vMessage2 := 'tdvadm.pkg_ope_frota.SP_Get_Desengatados';
    tdvadm.pkg_ope_frota.SP_Get_Desengatados(vStatus,vMessage);
   
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Tabelas do Eclik ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_ope_frota.sp_set_cadastrogeral"' 
                        );

  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  

  Begin
    vStatus := '';
    vMessage := '';
    vMessage2 := 'tdvadm.pkg_ope_frota.SP_SET_DADOSHODOMETRO';
    tdvadm.pkg_ope_frota.SP_SET_DADOSHODOMETRO(vStatus,vMessage);
   
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Tabelas do Eclik ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_ope_frota.sp_set_cadastrogeral"' 
                        );

  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  


  Begin
    vStatus := '';
    vMessage := '';
    vMessage2 := 'tdvadm.pkg_ope_frota.SP_SET_MOTORISTAS';
    tdvadm.pkg_ope_frota.SP_SET_MOTORISTAS(vStatus,vMessage);
   
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Tabelas do Eclik ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_ope_frota.sp_set_cadastrogeral"' 
                        );

  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  

  Begin
    vStatus := '';
    vMessage := '';
    vMessage2 := 'tdvadm.pkg_ope_frota.SP_Get_OS';
    tdvadm.pkg_ope_frota.SP_Get_OS(sysdate,vStatus,vMessage);
   
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Tabelas do Eclik ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_ope_frota.sp_set_cadastrogeral"' 
                        );

  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  


  Begin
    vStatus := '';
    vMessage := '';
    vMessage2 := 'tdvadm.pkg_ope_frota.sp_set_Produtividade';
    tdvadm.pkg_ope_frota.sp_set_Produtividade(sysdate,vStatus,vMessage);
   
    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Tabelas do Eclik ' || trim(to_char(vAuxiliar)) || '%',
                         'Status da Rotina: ' || vStatus || chr(13) ||  
                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "tdvadm.pkg_ope_frota.sp_set_cadastrogeral"' 
                        );

  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  

/*

  Begin
    vMesAnoF := to_char(sysdate,'mm/yyyy');
    vStatus := '';
    vMessage := '';
    vDestinoEmails := 'grp.kpi@dellavolpe.com.br';
    vMessage2 := 'tdvadm.pkg_eck_transdados.SP_CARGAECLICK_COLETASMes';
    tdvadm.pkg_eck_transdados.SP_CARGAECLICK_COLETASMes('01/' || vMesAnoF);
    
    vMesAnoI := to_char(add_months(sysdate,-1),'mm/yyyy');
    tdvadm.pkg_eck_transdados.SP_CARGAECLICK_COLETASMes('01/' || vMesAnoI);

    vMesAnoI := to_char(add_months(sysdate,-2),'mm/yyyy');
    tdvadm.pkg_eck_transdados.SP_CARGAECLICK_COLETASMes('01/' || vMesAnoI);

    --Envio e-mail da mensagem que foi gerada.
    tdvadm.sp_enviamail( 'SEQUENCIAL',
                         Trim(vDestinoEmails),
                         'Rotina executada pelo Lixeiro - Carga de Coletas no Eclik',
--                         'Status da Rotina: ' || vStatus || chr(13) ||  
--                         'Mensagem gerada pela rotina: ' || chr(13) || vMessage || chr(13) || chr(13) ||
                         'Não responda esse e-mail, mensagem gerada automáticamente pelo WorkFlow ao executar a rotina: "' || vMessage2 || '"' 
                        );

  Exception
    When Others Then
      --Envio o e-mail com a confirmação da operação.
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
  
    
    
  End;  

   Begin
      eclick.SP_ECK_CARGA_STAGESLA(to_char(to_date('01'||vMesAnoI,'dd/mm/yyyy'),'dd/mm/yyyy') ,
                                   to_char(Last_day(to_date('01'||vMesAnoF,'dd/mm/yyyy')),'dd/mm/yyyy'));
   Exception
     When OTHERS Then
       vMessage2 := 'eclick.SP_ECK_CARGA_STAGESLA';
      tdvadm.sp_enviamail( 'SEQUENCIAL',
                           Trim(vDestinoEmails),
                           'Erro na rotina executada pelo Lixeiro',
                           'A rotina "' || vMessage2 || '", não foi executada corretamente. ' || chr(13) || 
                            sqlerrm || chr(13) || 
                            chr(13) ||
                           'Certifique-se que não terei o mesmo erro amanhã, pois um erro no Lixeiro poderá prejudicar outras operações'
                          );
     End ;


*/   



End sp_Atualizado_eclick;

--------------------------------------------------------------------------------------------------------------------------------     
-- Função utilizada para excluir todas as notas fiscais lançadas no sistema com a solicitação 55899
--------------------------------------------------------------------------------------------------------------------------------     
Function fni_Excluir_NotasCarreg( pNota_Seq  tdvadm.t_arm_nota.arm_nota_sequencia%Type ) Return Varchar2 Is
  --variável que será utilizada no retorno da função
  vRetorno  Varchar2(32000);
  
  --Variável que será utilizada para guardar o código do carregamento da embalagem

  
  --Variáveis utilizada para recuperar dados da nota fiscal
  vNota_Numero   tdvadm.t_arm_nota.arm_nota_numero%Type;
  
Begin
  Begin
    
    Begin
      Select 
       nota.arm_nota_numero 
      Into 
        vNota_Numero
      From 
        tdvadm.t_arm_nota  nota
      Where
        nota.arm_nota_sequencia = pNota_Seq;  
    End;
   
    Return vRetorno;
  Exception
    --se ocorre algum erro durante o processo, devolvo a mensagem gerada.
    When Others  Then
      raise_application_error(-20001, Sqlerrm);
  
  End;  

  
End;   

--------------------------------------------------------------------------------------------------------------------------------     
-- Função utilizada para retornar a mensagem a ser gravada nas condiçoes epeciais do vale de frete apos cancelamento 
--------------------------------------------------------------------------------------------------------------------------------     
Function fni_Cond_Espec( p_Cond tdvadm.t_con_valefrete.con_valefrete_condespeciais%Type, p_Msg char ) Return Varchar2 Is

  --variável que será utilizada no retorno da função
  vRetorno  tdvadm.t_con_valefrete.con_valefrete_condespeciais%Type;

  --variável que contem o tamanho maximo que o retorno da funçao pode ter
  vLimite  integer;
    
Begin

  -- Verifica o tamanho maximo da coluna que recebera o retorno

--  select nvl(tb.data_length,0) 
--    into vLimite
--    from dba_tab_cols tb
--   where tb.table_name = 'T_CON_VALEFRETE'
--   and tb.column_name = 'CON_VALEFRETE_CONDESPECIAIS';
  
  Begin
    
    if length(trim(nvl(p_Cond,''))) = 0 then
      vRetorno := trim(p_Msg);             
    else 
      vRetorno := substr(trim(p_Msg)||' - '||trim(p_Cond),1,vLimite);      
    end if;    

    Return vRetorno;

  Exception
    --se ocorre algum erro durante o processo, devolvo a mensagem gerada.
    When Others  Then
      raise_application_error(-20001, Sqlerrm);
  
  End;  
  
End;   

--------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para excluir, limpar, organizar, gerar log de alguns processos.                                   --
--Essa procedure é executada através do job nº , uma vez por dia, as 00hs                                               --
--------------------------------------------------------------------------------------------------------------------------
Procedure SP_MNT_Diaria( pData  in Date,
                         pStatus out char ) Is

Begin
 pStatus := to_char(pData, 'DD/MM/YYYY'); 
    
End SP_MNT_Diaria;  

--------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para atualizar o Flag de DescBonus na tabela de Vale de Frete.                                    --
-- Procedure será executada pelo Lixeiro, até o frontEnd do Vale de Frete cobrir essa situação                          --
--------------------------------------------------------------------------------------------------------------------------
procedure sp_atz_DescBonusVF( pStatus out char,
                              pMessage out varchar2
                            ) is
 --Variável utilizada apenas para contar a quantia de vale que serão atualizadas
 vCount integer;
 
 --Variável utilizada para facilitar a criação do log
 vLogOperacao   tdvadm.t_log_system%rowtype;
 
begin
  --Inicializa as variáveis que serão utilizadas nessa procedure.
  vCount := 0;
  vLogOperacao.Usu_Aplicacao_Codigo := 'prj_manut';
  vLogOperacao.Log_Macro_Codigo := 'VFrete_Bonus';
  vLogOperacao.Log_System_Campochave := 'Atualização de Flag Bonus';
  
  
  Begin
    begin
      --Abro um cursor com os Vales de Frete que serão atualizados.
      for vCursor in ( select 
                         vf.con_conhecimento_codigo,
                         vf.con_conhecimento_serie,
                         vf.glb_rota_codigo,
                         vf.con_valefrete_saque
                       from 
                         tdvadm.t_con_valefrete vf
                       where 0 = 0
                         and  vf.con_valefrete_datacadastro >= '01/03/2012'
                         and nvl(vf.con_valefrete_descbonus,'N') = 'N'
                         and ( vf.con_valefrete_condespeciais like '%BONUS PAGAVEL SOMENTE NA FILIAL OU MATRIZ%'
                         or vf.con_valefrete_condespeciais like '%RECEBER COMISSÃO S/BONUS DE R$%')
                         and vf.con_valefrete_status is null
                         and vf.con_valefrete_impresso = 'S'
                         and vf.glb_rota_codigo in (select r.glb_rota_codigo
                                                   from t_glb_rota r
                                                   where r.glb_rota_calcbonus = 'S')
                      )
                      loop
                         --Escrevo a hora do inicio da operação e inicio a mensagem do log
                          vLogOperacao.Log_System_Datahora := sysdate;
                          vLogOperacao.Log_System_Message := vCursor.Con_Conhecimento_Codigo || '|' ||
                                                             vCursor.Con_Conhecimento_Serie  || '|' ||
                                                             vCursor.Glb_Rota_Codigo         || '|' ||
                                                             vCursor.Con_Valefrete_Saque     || '|' ||
                                                             To_char(sysdate, 'dd/mm/yyyy hh24:mi:ss');
                                                             
                        --incremento a variável contadora.
                        vCount := vCount +1;
                        begin
                          --Atualiza o flag do Vale de Frete.
                          update tdvadm.t_con_valefrete vfrete
                            set vFrete.Con_Valefrete_Descbonus = 'S'
                          where
                            0=0
                            and vfrete.con_conhecimento_codigo = vCursor.Con_Conhecimento_Codigo
                            and vfrete.con_conhecimento_serie  = vCursor.Con_Conhecimento_Serie
                            and vfrete.glb_rota_codigo = vCursor.Glb_Rota_Codigo
                            and vfrete.con_valefrete_saque = vCursor.Con_Valefrete_Saque;
                            
                          --comito o update para ter certeza que não vai ocorrer nenhum erro.
                          commit;
                          
                          --Defino o logo como informativo, e não adiciono "OK" como observação.
                          vLogOperacao.Log_Tipo_Codigo := 'I';
                          vLogOperacao.Log_System_Message :=   vLogOperacao.Log_System_Message || '|' || 'OK' || '|';
                        Exception
                          --Caso ocorra algum erro durante a atualização registra o log de erro.
                          when others then
                            --Descrevo o log com erro, e defino uma observação.
                            vLogOperacao.Log_Tipo_Codigo := 'E';
                            vLogOperacao.Log_System_Message := vLogOperacao.Log_System_Message || '|' ||'Erro: ' || sqlerrm || '|';
                        end;
                        Begin
                          --insiro o registro de log.
                          insert into tdvadm.t_log_system ( usu_aplicacao_codigo, 
                                                            log_system_datahora, 
                                                            log_tipo_codigo, 
                                                            log_macro_codigo,
                                                            log_system_campochave,
                                                            log_system_message
                                                          )
                                                          values
                                                          ( vLogOperacao.Usu_Aplicacao_Codigo,
                                                            vLogOperacao.Log_System_Datahora,
                                                            vLogOperacao.Log_Tipo_Codigo,
                                                            vLogOperacao.Log_Macro_Codigo,
                                                            vLogOperacao.Log_System_Campochave,
                                                            vLogOperacao.Log_System_Message
                                                          );  
                          commit;
                        Exception
                          when others then
                            raise_application_error(-20001, 'Erro ao gerar Log.' || chr(13) || sqlerrm );
                        end;  
                        
                      end loop; 
    Exception
      when others then
        raise_application_error(-20001, 'Erro ao tratar o cursor de Vale de Frete' || chr(13) || sqlerrm);                  
    End;                        
                      
  Exception 
    --caso ocorra algum erro durante o processamento, devolve o erro gerado.
    when others then
      pStatus := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro: ' || sqlerrm;
      return;
  End;  
  
  --Caso a procedure tenha sido realizada com sucesso.
  pStatus := tdvadm.pkg_glb_common.Status_Nomal;
  pMessage := 'Foram atualizados ' || trim(to_char(vCount)) || ' vale(s) de frete. '|| chr(13) ||
              'Rotina: glbadm.pgk_glb_manutencao.sp_atz_DescBonusVF'               || chr(13) ||
              'Dia: ' || to_char(sysdate, 'dd/mm/yyyy'); 
  
end sp_atz_DescBonusVF;  

/*
--------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para Cancelar Vales de Frete, emitidos e não impressos dentro do prazo.                          --
-- Procedure só será executada pelo Lixeiro - Roberto Pariz - 26/07/2013                                                --
--------------------------------------------------------------------------------------------------------------------------
procedure sp_lmp_SemImpressaoVF( pStatus out char,
                                 pMessage out varchar2
                               ) is
 --Variável utilizada apenas para contar a quantia de vales de frete que serão cancelados
 vCount integer;
 
 --Variável utilizada para facilitar a criação do log
 vLogOperacao   tdvadm.t_log_system%rowtype;

 -- 
 vCond tdvadm.t_con_valefrete.con_valefrete_condespeciais%type; 
 
begin
  --Inicializa as variáveis que serão utilizadas nessa procedure.
  vCount := 0;
  vLogOperacao.Usu_Aplicacao_Codigo := 'prj_manut';
  vLogOperacao.Log_Macro_Codigo := 'VFrete_Prazos';
  vLogOperacao.Log_System_Campochave := 'Vales de frete fora do prazo!';
  
  
  Begin
    begin
      --Abro um cursor com os Vales de Frete que serão atualizados.
      for vCursor in ( select 
                         vf.con_conhecimento_codigo,
                         vf.con_conhecimento_serie,
                         vf.glb_rota_codigo,
                         vf.con_valefrete_saque,
                         vf.con_valefrete_condespeciais
                       from 
                         tdvadm.t_con_valefrete vf,
                         tdvadm.t_con_vfreteciot vfc
                       where 0 = 0
                         and vf.con_conhecimento_codigo = vfc.con_conhecimento_codigo(+)
                         and vf.con_conhecimento_serie  = vfc.con_conhecimento_serie(+)
                         and vf.glb_rota_codigo         = vfc.glb_rota_codigo(+)
                         and vf.con_valefrete_saque     = vfc.con_valefrete_saque(+)
                         and vf.con_valefrete_datacadastro >= trunc(sysdate-5) -- pegar parametro
                         and nvl(vf.con_valefrete_status,'N')   = 'N'
                         and nvl(vf.con_valefrete_impresso,'N') = 'N'
                      )
                      loop
                         --Escrevo a hora do inicio da operação e inicio a mensagem do log
                          vLogOperacao.Log_System_Datahora := sysdate;
                          vLogOperacao.Log_System_Message := vCursor.Con_Conhecimento_Codigo || '|' ||
                                                             vCursor.Con_Conhecimento_Serie  || '|' ||
                                                             vCursor.Glb_Rota_Codigo         || '|' ||
                                                             vCursor.Con_Valefrete_Saque     || '|' ||
                                                             To_char(sysdate, 'dd/mm/yyyy hh24:mi:ss');
                                                             
                        --incremento a variável contadora.
                        vCount := vCount +1;
                        begin
                          --Atualiza o flag do Vale de Frete.
                          
                          vCond := fni_Cond_Espec(vCursor.Con_Valefrete_Condespeciais,'Cancelado Pelo Sistema! - Prazo para impressão excedido!');

                          update tdvadm.t_con_valefrete vfrete
                            set vFrete.Con_Valefrete_Status = 'C',
                                vFrete.Con_Valefrete_Condespeciais = vCond
                          where
                            0=0
                            and vfrete.con_conhecimento_codigo = vCursor.Con_Conhecimento_Codigo
                            and vfrete.con_conhecimento_serie  = vCursor.Con_Conhecimento_Serie
                            and vfrete.glb_rota_codigo         = vCursor.Glb_Rota_Codigo
                            and vfrete.con_valefrete_saque     = vCursor.Con_Valefrete_Saque;
                            
                          --comito o update para ter certeza que não vai ocorrer nenhum erro.
                          commit;
                          
                          --Defino o logo como informativo, e não adiciono "OK" como observação.
                          vLogOperacao.Log_Tipo_Codigo := 'I';
                          vLogOperacao.Log_System_Message :=   vLogOperacao.Log_System_Message || '|' || 'OK' || '|';
                        Exception
                          --Caso ocorra algum erro durante a atualização registra o log de erro.
                          when others then
                            --Descrevo o log com erro, e defino uma observação.
                            vLogOperacao.Log_Tipo_Codigo := 'E';
                            vLogOperacao.Log_System_Message := vLogOperacao.Log_System_Message || '|' ||'Erro: ' || sqlerrm || '|';
                        end;
                        Begin
                          --insiro o registro de log.
                          insert into tdvadm.t_log_system ( usu_aplicacao_codigo, 
                                                            log_system_datahora, 
                                                            log_tipo_codigo, 
                                                            log_macro_codigo,
                                                            log_system_campochave,
                                                            log_system_message
                                                          )
                                                          values
                                                          ( vLogOperacao.Usu_Aplicacao_Codigo,
                                                            vLogOperacao.Log_System_Datahora,
                                                            vLogOperacao.Log_Tipo_Codigo,
                                                            vLogOperacao.Log_Macro_Codigo,
                                                            vLogOperacao.Log_System_Campochave,
                                                            vLogOperacao.Log_System_Message
                                                          );  
                          commit;
                        Exception
                          when others then
                            raise_application_error(-20001, 'Erro ao gerar Log.' || chr(13) || sqlerrm );
                        end;  
                        
                      end loop; 
    Exception
      when others then
        raise_application_error(-20001, 'Erro ao tratar o cursor de Vale de Frete' || chr(13) || sqlerrm);                  
    End;                        
                      
  Exception 
    --caso ocorra algum erro durante o processamento, devolve o erro gerado.
    when others then
      pStatus := tdvadm.pkg_glb_common.Status_Erro;
      pMessage := 'Erro: ' || sqlerrm;
      return;
  End;  
  
  --Caso a procedure tenha sido realizada com sucesso.
  pStatus := tdvadm.pkg_glb_common.Status_Nomal;
  pMessage := 'Foram atualizados ' || trim(to_char(vCount)) || ' vale(s) de frete. '|| chr(13) ||
              'Rotina: glbadm.pgk_glb_manutencao.sp_lmp_SemImpressaoVF'             || chr(13) ||
              'Dia: ' || to_char(sysdate, 'dd/mm/yyyy'); 
  
end sp_lmp_SemImpressaoVF;  
*/

--------------------------------------------------------------------------------------------------------------------------------
-- PROCEDURE QUE SERÁ DE MANUTENÇÃO QUE SERÁ RODADA DE HORA EM HORA.                                                          --
--------------------------------------------------------------------------------------------------------------------------------
procedure SP_MANUTENCAO_HORA is
 --Variáveis utilizadas para executar as procedure de manutenção
 vStatus char(01);
 vMessage clob;
 vMessage2 clob;
 vCorpoEmail clob;
 vAuxiliarDt date;
 vListaRomaneio tdvadm.t_usu_aplicacaoperfil.usu_aplicacaoperfil_parat%type;

 --Variável utilizada apenas para administrar as pessoas que receberão e-mail de confirmação do procedimento.
 vDestinoEmails tdvadm.t_uti_infomail.uti_infomail_endmaildestinatar%type;
 
 --Variáveis que serão utilizadas para controlar o tempo do processo.
 vInicio date;
 vDia  integer;
 vHora integer;
 
 --Variável de exceção
 vEx_Executa exception;
 
 --Variável de controle
 vControl integer;
 vContador integer;
 begin
  vMessage  := empty_clob; 
  vMessage2 := empty_clob; 
  --inicializa as variáveis 
  vDia:= 0;
  vHora:= 0;
  vControl := 0;
  
  --Recupero os valores de dia e hora.
  vHora := to_number( to_char(sysdate, 'HH24') );
  vDia := to_number( to_char(sysdate, 'D') ); 


 vStatus := '';
 vDestinoEmails := '';
 vCorpoEmail := empty_clob;
 
  /***********************************************************************************************************************************/
  /*   ROTINA QUE MANDA OS PERCURSOS INCLUIDOS NO DIA ANTERIOR
  /***********************************************************************************************************************************/
    
    tdvadm.pkg_slf_percurso.sp_slf_informaPercurso('0020',0,vStatus,vCorpoEmail);
    If vStatus = 'N' Then
       wservice.pkg_glb_email.SP_ENVIAEMAIL('NOVOS PERCURSOS',
                                            vCorpoEmail,
                                            'aut-e@dellavolpe.com.br',
                                            'tiago.bernardes@vale.com;cteresponse@vale.com;vinicius.esteves@vale.com',
                                            'sdrumond@dellavolpe.com.br');
    End If;
 




-- Ver com o Klayton se ele colocaou a regra no ROBO e retirar daqui
update tdvadm.t_arm_coleta c
  set c.arm_coleta_cnpjsolicitante = c.glb_cliente_cgccpfcodigocoleta,
      c.arm_coleta_pagadorfrete = 'R'
where c.arm_coleta_dtsolicitacao >= to_date('10/10/2015','dd/mm/yyyy')
  and c.xml_coleta_numero is not null
  and c.arm_coleta_cnpjsolicitante is null
  AND 0 < (SELECT COUNT(*)
           FROM tdvadm.T_GLB_CLIENTE CL
           WHERE CL.GLB_CLIENTE_CGCCPFCODIGO =  c.glb_cliente_cgccpfcodigocoleta
             AND CL.GLB_GRUPOECONOMICO_CODIGO in ('0020','0074'));

update tdvadm.t_arm_coleta c
  set c.arm_coleta_cnpjsolicitante = c.glb_cliente_cgccpfcodigoentreg,
      c.arm_coleta_pagadorfrete = 'D'
where c.arm_coleta_dtsolicitacao >= to_date('10/10/2015','dd/mm/yyyy')
  and c.xml_coleta_numero is not null
  and c.arm_coleta_cnpjsolicitante is null
  AND 0 < (SELECT COUNT(*)
           FROM tdvadm.T_GLB_CLIENTE CL
           WHERE CL.GLB_CLIENTE_CGCCPFCODIGO =  c.glb_cliente_cgccpfcodigoentreg
             AND CL.GLB_GRUPOECONOMICO_CODIGO in ('0020','0074'));
commit;


 ------------------------------------------------------------------------------------------------
 -- ROTINA UTILIZADA PARA INFORMAR EQUIPAMENTOS DA EMPRESA SASCAR, QUE NÃO RECEBERAM SINAL DE  --
 -- POSICIONAMENTO DENTRO DE UM INTERVALO DE 1 HORA.                                           --    
 ------------------------------------------------------------------------------------------------
 begin
    --Se for final de semana, ou se a hora for antes das 8 ou depois das 18
    if ( ( vDia in (1, 7) ) or  ( (vHora < 8 ) or ( vHora > 18 ) ) )  then
      --lanço a exceção de não operção.
      raise vEx_Executa;
    end if;



   --seto o inicio do processo.
   vInicio := sysdate;
   
   --Relação dos endereços que receberão mensagens.
   vDestinoEmails:= '';
   --vDestinoEmails:= vDestinoEmails || 'vsaraiva@dellavolpe.com.br;';
   vDestinoEmails:= vDestinoEmails || 'rastreamento@dellavolpe.com.br;';
   vDestinoEmails:= vDestinoEmails || 'fribeiro@dellavolpe.com.br;';
--   vDestinoEmails:= vDestinoEmails || 'tdv.siimg@dellavolpe.com.br';
   
   
   --busco todas as 
   if (tdvadm.pkg_scr_integracao.FNP_Mct_SemSinal(vMessage)) then
     -- Defino cabeçalho da mensagen caso a função seja executada corretamente.
     vMessage := 'ABAIXO RELAÇÃO DOS EQUIPAMENTOS DA SASCAR QUE NÃO RECEBERÃO SINAIS A MAIS DE 5 HORAS.' || chr(10)|| chr(10)
                 || vMessage || chr(13) || chr(13) 
                 || 'rotina executada: tdvadm.pkg_scr_integracao.fnp_mct_semsinal' || chr(13) 
                 || 'E-MAIL ENVIADO ATRAVÉS DE PROCESSO AUTOMÁTICO WORKFLOW DELLAVOLPE.'|| chr(13)|| 'FAVOR NÃO RESPONDA ESSE E-MAIL.' 
                 || chr(13) || chr(13) 
                 || 'Tempo utilizado para processamento: ' || tdvadm.Fn_Calcula_Tempodecorrido(vInicio, sysdate, 'H');
                 
   
   end if;
   
   
   wservice.pkg_glb_email.SP_ENVIAEMAIL('Sascar sem sinal a mais de 5 HORAS.',
                                        vMessage,
                                        'aut-e@dellavolpe.com.br',
                                        Trim(vDestinoEmails)); 
                       
     
 Exception
   --caso não seja necessária a execução da rotina
   when vEx_Executa then  
     --Simplesmente limpo a variável de control
     vControl := 0;
 end;
 
 Begin
   --Rotina criada pelo Sirlano, que deve ser executada de hora em hora;
   tdvadm.sp_con_infproblemas('0041', vStatus, vMessage);
 end;
   Begin
 
      select ap.usu_aplicacaoperfil_parat
        into vListaRomaneio
        from tdvadm.t_usu_aplicacaoperfil ap
       where ap.usu_aplicacao_codigo = '0000000000'
         and trim(ap.usu_perfil_codigo) = 'LISTAPARAMETROS';
    Exception when NO_DATA_FOUND THEN
      vListaRomaneio := cnGruposListaNota;
    end;

      for vCursor in (select distinct trunc(vf.con_valefrete_datacadastro) cadvalefrete,
                             cl.glb_grupoeconomico_codigo,
                             vfc.con_valefrete_codigo,
                             vfc.glb_rota_codigovalefrete,
                             vfc.con_valefrete_serie,
                             vfc.con_valefrete_saque,
                    --       c.con_conhecimento_dtembarque embcte,
                             cl.glb_cliente_razaosocial cliente,
                             'MSG=LISTNOTA;MINUTA=' || vfc.con_valefrete_codigo || vfc.glb_rota_codigovalefrete ||  vfc.con_valefrete_saque ||';GRUPO='||cl.glb_grupoeconomico_codigo || ';CNPJ='||trim(c.glb_cliente_cgccpfsacado)||';CONTRATO='||trim(tdvadm.pkg_slf_utilitarios.fn_retorna_contratoCod(c.con_conhecimento_codigo,c.con_conhecimento_serie,c.glb_rota_codigo)) assunto
                      from tdvadm.t_con_conhecimento c,
                           tdvadm.t_glb_cliente cl,
                           tdvadm.t_con_vfreteconhec vfc,
                           tdvadm.t_con_valefrete vf
                      where 0 = 0
                        and c.con_conhecimento_codigo = vfc.con_conhecimento_codigo
                        and c.con_conhecimento_serie = vfc.con_conhecimento_serie
                        and c.glb_rota_codigo = vfc.glb_rota_codigo
                        and vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                        and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                        and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                        and vfc.con_valefrete_saque = vf.con_valefrete_saque
                        and trunc(vf.con_valefrete_datacadastro) > '08/12/2015'
                        and vf.con_valefrete_datacadastro >= sysdate - 10
                        and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                        and instr(vListaRomaneio,cl.glb_grupoeconomico_codigo) > 0
                        and nvl(vf.con_valefrete_impresso,'N') = 'S'
                        and vf.con_valefrete_status is null
                        and 0 = (select count(*)
                                 from rmadm.t_glb_benasserec br
                                 where substr(br.glb_benasserec_assunto,1,29) = 'MSG=LISTNOTA;MINUTA=' || vfc.con_valefrete_codigo || vfc.glb_rota_codigovalefrete
                                   and br.glb_benasserec_status in ('OK','IN'))
                      order by 1)
      loop


           
          SELECT count(*)
              into vContador
          FROM tdvadm.T_CON_VFRETECONHEC VFC
               ,tdvadm.T_CON_VALEFRETE VF
               ,tdvadm.T_CON_CONHECIMENTO C
               ,tdvadm.T_CON_NFTRANSPORTA NF
               ,tdvadm.T_ARM_COLETA CO
               ,tdvadm.T_ARM_NOTA NT
               ,tdvadm.T_GLB_CLIENTE CS
               ,tdvadm.T_GLB_CLIENTE CD
          WHERE VFC.CON_VALEFRETE_CODIGO = vCursor.con_valefrete_codigo
            AND VFC.GLB_ROTA_CODIGOVALEFRETE = vCursor.glb_rota_codigovalefrete
            AND VFC.CON_VALEFRETE_SAQUE = vCursor.con_valefrete_saque
            AND cS.glb_grupoeconomico_codigo = vCursor.glb_grupoeconomico_codigo
            AND CD.GLB_GRUPOECONOMICO_CODIGO = vCursor.glb_grupoeconomico_codigo
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
            AND c.Glb_Cliente_Cgccpfdestinatario = CD.GLB_CLIENTE_CGCCPFCODIGO;


         If vContador > 0 Then
            wservice.pkg_glb_email.SP_ENVIAEMAIL(vCursor.assunto,
                                                 'automatico',
                                                 'tdv.operacao@dellavolpe.com.br',
                                                 'aut-e@dellavolpe.com.br');
         End If;

      End Loop;
 
      -- Atualizar a Tabela T_Glb_ClienteSeg, colocando os dados da T_glb_cliente
      
      insert into tdvadm.t_glb_clienteseg
      select co.glb_cliente_cgccpfcodigo,nvl(co.glb_rota_codigo,'010'),sysdate
      from tdvadm.t_glb_cliente co
      where 0 = 0
      and 0=(select count (*)
              from tdvadm.t_glb_clienteseg ca
              where ca.glb_cliente_cgccpfcodigo = co.glb_cliente_cgccpfcodigo);
      
     commit;
     
     
     vMessage := '';
     for vCursor in (select c.con_conhecimento_dtembarque data,
                            c.con_conhecimento_codigo cte,
                            c.con_conhecimento_serie sr,
                            c.glb_rota_codigo rt,
                            co.fcf_tpveiculo_codigo veiccol,
                            ta.fcf_tpveiculo_codigo veictab,
                            c.arm_coleta_ncompra coleta,
                            c.arm_coleta_ciclo ciclo
                     from tdvadm.t_con_conhecimento c,
                          tdvadm.t_slf_tabela ta,
                          tdvadm.t_arm_coleta co
                     where c.con_conhecimento_dtembarque >= '18/07/2017'
                       and c.slf_tabela_codigo = ta.slf_tabela_codigo
                       and c.slf_tabela_saque = ta.slf_tabela_saque
                       and ta.slf_tabela_contrato = 'C1041226000'
                       and ta.fcf_tpcarga_codigo = '01'
                       and ta.fcf_tpveiculo_codigo <> co.fcf_tpveiculo_codigo
                       and c.arm_coleta_ncompra = co.arm_coleta_ncompra
                       and c.arm_coleta_ciclo = co.arm_coleta_ciclo)
     loop

        vMessage := vMessage || to_char(vCursor.Data,'dd/mm/yyyy') || ' CONHECIMENTO - ' || vCursor.Cte || vCursor.Sr || vCursor.Rt || 'VCte ' || vCursor.Veictab || ' VCol ' || vCursor.Veiccol || chr(10); 
       
       
     End Loop;
     
   If vMessage <> '' Then
      wservice.pkg_glb_email.SP_ENVIAEMAIL('THYSSEN - VEICULOS DIFERENTES',
                                           vMessage,
                                           'aut-e@dellavolpe.com.br',
                                           'rayaraujo@dellavolpe.com.br'); 
   End IF;

     


end SP_MANUTENCAO_HORA;  


End pgk_glb_manutencao;
/
