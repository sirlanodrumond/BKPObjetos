create or replace package Pkg_Fifo_ValeFrete is
/****************************************************************************************
/* Versao: 14.12.17.1
/* Ultima alteracao: Devido a Inclusao do Ciot no Manifesto, ValeFrete sera gerado antes 
                      do Manifesto. Proc Sp_Get_ValeFrete contem agora o Ciot do VF e 
                      tambem foram acrescentados as colunas CAR_PROPRIETARIO_CLASSANTT,
                      CAR_PROPRIETARIO_CLASSEQP e CAR_PROPRIETARIO_RNTRCDTVAL.
/***************************************************************************************/
                            
-- Proedure utilizada para recuperar lista de Vale de frete a Serem Gerados
/*Procedure SP_Get_VFreteNaoGerados( pXmlIn In Varchar2,
                                   pStatus Out Char,
                                   pMessage Out Varchar2,
                                   pXmlOut Out Clob
                                 );*/
                                 
-- Procedure utilizada para recuperar lista de Vales de Frete criados.
/*Procedure SP_Get_VFreteGerados( pXmlIn In Varchar2,
                                pStatus Out Varchar2,
                                pMessage Out Varchar2,
                                pXmlOut Out Clob
                              );  */

-- Procedure utilizada para criar um Vale de Frete
Procedure sp_cria_ValeFrete( pXmlIn In Varchar2,
                             pStatus Out Varchar2,
                             pMessage Out Varchar2
                           );
                           
--Procedure Sp_Get_VERIFICA_CTRC_MAN_PEND(P_COD_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
--                                        P_SEQ_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
--                                        pLogs Out Varchar2);                                                                
                                        
Procedure Sp_Verifica_CTRC_MDFe_Pend(P_COD_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                                      P_SEQ_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                                      pVerificaObrigatoriedadeMDFe In Char default 'N',
                                      pStatus  Out Char,
                                      pMessage Out Varchar);
                                     
Function Fn_Validos_CTRC_MDFe(pVeiculoDisp T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                              pSequencia   T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                              pParamMdfe In Char default 'N') return Char;
                                                                
Procedure Sp_Get_ValeFrete(pXmlIn   In Varchar2,
                           pXmlOut  Out Clob,
                           pStatus  Out Char,
                           pMessage Out varchar2);

Function Fn_PodeSumirAbaValeFrete(p_veicDisp in  t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                  p_veicSeq  in  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                                  p_vfnumero in  t_con_valefrete.con_conhecimento_codigo%type,
                                  p_vfserie  in  t_con_valefrete.con_conhecimento_serie%type,
                                  p_vfrota   in  t_con_valefrete.glb_rota_codigo%type,
                                  p_vfsaque  in  t_con_valefrete.con_valefrete_saque%type) return char;                           

end Pkg_Fifo_ValeFrete;

 
/
create or replace package body Pkg_Fifo_ValeFrete Is

  --Variáveis de Exceção
  vEx_ParamsIniciais Exception;
  vEx_Validacoes Exception;
--------------------------------------------------------------------------------------------------------------------
-- Função privara utilizada para devolver um xml, a partir da lista de Vale de Frete não ferados                   --
--------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_VFNaoGerados ( pListaVf In TDVADM.PKG_FIFO.tListaVFNaoGerado,
                                pTableName In Char,
                                pXmlOut Out Varchar2,
                                pMessage Out Varchar2
                               ) Return Boolean Is
 --Variável utilizada para montar o Xml de Retorno,
 --vMessage Varchar2(32000);                               
 
 --Variável utilizada para montar um Xml de retorno
 vXmlRetorno Varchar2(32000);
Begin
  --inicializa as variáveis que serão utilizadas nessa função
  --vMessage := '';
  vXmlRetorno := '';
  
 Begin
   --caso a lista tenha vindo sem nenhum registro
   If ( pListaVf.count  = 0 )  Then
     --monto um xml em brancl
     vXmlRetorno := '<row num="0" > '                 || 
                    '  <placa />'                     || 
                    '  <motorista />'                 ||
                    '  <tpveiculo />'                 ||
                    '  <observacao />'                ||
                    '  <desconto />'                  ||
                    '  <fcf_veiculodisp_codigo />'    ||
                    '  <fcf_veiculodisp_sequencia />' ||
                    '  <flag />'                      ||
                    '  <cod_carregamento />'          ||
                    '</row>';
   End If;
   
   --Lista com registro monto XML linha a linha
   If (pListaVf.count  > 0)  Then
     
     --entro em laço para poder montar o xml linha a linha
     For i In 1..pListaVf.count Loop
       vXmlRetorno := vXmlRetorno  ||
                      '<row num="' || Trim(to_char(i)) ||   '" > '                                                                                                       || 
                        glbadm.pkg_xml_common.FN_Xml_GetField('placa',                     pListaVf(i).placa,                     glbadm.pkg_xml_common.Field_Char )     ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('motorista',                 pListaVf(i).motorista,                 glbadm.pkg_xml_common.Field_Varchar2 ) ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('tpveiculo',                 pListaVf(i).tpveiculo,                 glbadm.pkg_xml_common.Field_Varchar2 ) ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('observacao',                pListaVf(i).observacao,                glbadm.pkg_xml_common.Field_Varchar2 ) ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('desconto',                  pListaVf(i).desconto,                  glbadm.pkg_xml_common.Field_valor )    ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('fcf_veiculodisp_codigo',    pListaVf(i).fcf_veiculodisp_codigo,    glbadm.pkg_xml_common.Field_Char )     ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('fcf_veiculodisp_sequencia', pListaVf(i).fcf_veiculodisp_sequencia, glbadm.pkg_xml_common.Field_Char )     ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('flag',                      pListaVf(i).flag,                      glbadm.pkg_xml_common.Field_Char )     ||
                        glbadm.pkg_xml_common.FN_Xml_GetField('cod_carregamento',          pListaVf(i).cod_carregamento,          glbadm.pkg_xml_common.Field_Char )     ||
                      '</row>' || chr(10) ;
     End Loop;              
   End If;
   
   --monto literalmente o Xml de retorno
   pXmlOut := '<table name="' || pTableName || '" > ' || vXmlRetorno || '</table>';
   pMessage := '';
   Return True;
   
 Exception
   --erro não previsto
   When Others Then
     pMessage:= 'Erro ao gerar xml a partir da lista de Vales de Frete não Gerados.' || chr(10) ||
                'Rotina: tdvadm.pkg_fifo_valefrete.fnp_xml_vfnaogerados(); ' || chr(10) ||
                'Erro Ora: ' || Sqlerrm;
     Return False;           
 End;  
End FNP_Xml_VFNaoGerados;                                  

--------------------------------------------------------------------------------------------------------------------
-- Proedure utilizada para recuperar lista de Vale de frete a Serem Gerados,                                      --
--------------------------------------------------------------------------------------------------------------------
/*Procedure SP_Get_VFreteNaoGerados( pXmlIn In Varchar2,
                                   pStatus Out Char,
                                   pMessage Out Varchar2,
                                   pXmlOut Out Clob
                                 ) Is
Begin
  
  pStatus := 'N';
  pMessage := '';
End SP_Get_VFreteNaoGerados;   */                                

--------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para recuperar lista de Vales de Frete criados.                                            --
--------------------------------------------------------------------------------------------------------------------
/*Procedure SP_Get_VFreteGerados( pXmlIn In Varchar2,
                                pStatus Out Varchar2,
                                pMessage Out Varchar2,
                                pXmlOut Out Clob
                              ) As
Begin
  pStatus := 'N';
  pMessage:= '';
End SP_Get_VFreteGerados; */

--------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para criar um Vale de Frete                                                                -- 
--------------------------------------------------------------------------------------------------------------------                              
Procedure sp_cria_ValeFrete( pXmlIn In Varchar2,
                             pStatus Out Varchar2,
                             pMessage Out Varchar2
                           ) Is
 --Variável utilizada para recuperar os paramentros passados via XML.
 vListaParams  glbadm.pkg_listas.tListaParamsString;                       
 
 --Variável utilizada para recuperar mensagens
 vMessage Varchar2(32000);     
 vStatus Char(1);
 vListaParams_Usu      Glbadm.Pkg_Listas.tListaUsuParametros;
 vVerificaObrigatoriedadeMDFe Char(1); 
 vOutras varchar2(100);
 vTeste boolean;
 vCriaValeFrete char(1);
 vMessage2 varchar2(1000);
Begin
  Begin

     insert into dropme(x,l) values('Felipexml',pXmlIn);
         
    --Recupero a lista de paramentros passadas por xml
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue(pXmlIn, vListaParams, vMessage) ) Then
      Raise vEx_ParamsIniciais; 
    End If;
    
   
    ---------------------------------------------------------------------------------------------------------
    --                      FASE DE VALIDAÇÕES PRÉ-CRIAÇÃO VALE DE FRETE                                   --
    ---------------------------------------------------------------------------------------------------------
    
    -- Diego Lirio | 17/10/2013
    -- Verifica se a Rota Gera Manifesto Eletronico....
    if Tdvadm.Pkg_Fifo_Manifesto.Fn_Is_MDFe( vListaParams('rota').value ) = 'S' Then
          -- Verifica se os Documentos gerados são corretos (MDFe e CTRC)
          if not Glbadm.Pkg_Listas.FN_Get_UsuParamtros('comvlfrete',
                                                       'jsantos',
                                                       '010',
                                                        vListaParams_Usu) then
                 return;                                      
          end if;     
          vVerificaObrigatoriedadeMDFe := vListaParams_Usu('LIBERAMDFE').TEXTO; 
          Tdvadm.Pkg_Fifo_ValeFrete.Sp_Verifica_CTRC_MDFe_Pend( vListaParams('fcf_veiculodisp_codigo').value, 
                                                                vListaParams('fcf_veiculodisp_sequencia').value,
                                                                vVerificaObrigatoriedadeMDFe,
                                                                vStatus,
                                                                vMessage);   
          
          if vStatus != 'N' Then
              Raise vEx_Validacoes;                                                   
          end if;       
     end if;       
    
    -- Função utilizada para validar os Destinos da solicitação x Destinos das embalagens.
    If ( Not tdvadm.pkg_fifo_validacoes.FN_Vld_DestSolicitado( vListaParams('fcf_veiculodisp_codigo').value, 
                                                               vListaParams('fcf_veiculodisp_sequencia').value,  
                                                               vMessage  ) ) Then
      --Lnaça a exceção.                                                        
      Raise vEx_Validacoes;
    End If;                                                               
        
    Begin
    -- Função utilizada para validar os Destinos da solicitação x Destinos das embalagens.
       vTeste := tdvadm.pkg_fifo_validacoes.FN_Vld_OrigSolicitado( vListaParams('fcf_veiculodisp_codigo').value, 
                                                                   vListaParams('fcf_veiculodisp_sequencia').value,  
                                                                   vListaParams('rota').value,
                                                                   vMessage  );
    exception
      When OTHERS Then
          vTeste :=  True;
      End;
    If ( Not vTeste ) Then
      --Lnaça a exceção.  

/*
-- Verificar se vai sdr implementado este abaixo

select vd.car_veiculo_placa placa,
       vd.frt_conjveiculo_codigo frota,
       svo.glb_localidade_codigo localidade,
       svo.glb_localidade_codigoibge IBGE,
       fn_busca_codigoibge(svo.glb_localidade_codigo,'LOD') descloc,
       fn_busca_codigoibge(svo.glb_localidade_codigo,'IBD') descIBGE
from t_fcf_solveic sv,
     t_fcf_solveicorig svo,
     t_fcf_veiculodisp vd
where sv.fcf_veiculodisp_codigo = '2378782'
  and sv.fcf_veiculodisp_sequencia = '0'
  and sv.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
  and sv.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
  and sv.fcf_solveic_cod = svo.fcf_solveic_cod
order by svo.fcf_solveicorig_ordem;

select vc.armazem,vc.carreg,vc.cte,vc.rota,vc.entcol, vc.origemdesc
from v_Arm_Verifcarreg vc
where vc.carreg in (select ca.arm_carregamento_codigo
                    from t_arm_carregamento ca
                    where ca.fcf_veiculodisp_codigo  = '2378782'
                       and ca.fcf_veiculodisp_sequencia = '0');
                       
*/

      if vListaParams('usuario').value not in ('ejbarbosa','armota') and vListaParams('rota').value not in ('021') Then 
         Begin
             select 'Placa [' || vd.car_veiculo_placa || '] - Conjunto [' || vd.frt_conjveiculo_codigo || ']'
                into vOutras           
             from  t_fcf_veiculodisp vd
             where vd.fcf_veiculodisp_codigo = rpad(trim(vListaParams('fcf_veiculodisp_codigo').value),7)
               and vd.fcf_veiculodisp_sequencia = rpad(trim(vListaParams('fcf_veiculodisp_sequencia').value),3);
         exception
           When OTHERS Then
              vOutras := 'Não achei placa';
           End ;  
         wservice.pkg_glb_email.SP_ENVIAEMAIL('VALIDANDO ORIGENS SOLICITACAO',vMessage || chr(10) || vOutras || chr(10) || 'Usuario ' || vListaParams('usuario').value,'aut-e@dellavolpe.com.br','bbernardo@dellavolpe.com.br');
      Else
        Raise vEx_Validacoes;
      End If;         
    End If;                                                               

    --Função utilizada para validar a solicitação de MOPP
    If ( Not tdvadm.pkg_fifo_validacoes.FN_Vld_VeicDispMopp( vListaParams('fcf_veiculodisp_codigo').value, 
                                                             vListaParams('fcf_veiculodisp_sequencia').value,  
                                                             vMessage  ) ) Then
      --Lnaça a exceção.                                                        
      Raise vEx_Validacoes;
    End If;              
    
    -- Implementado por: Diego/Sirlano
    -- Data: 04/07/2013
    -- Função utilizada para validar a solicitação de Expresso
    If ( Not tdvadm.pkg_fifo_validacoes.FN_Vld_VeicDispExpresso( vListaParams('fcf_veiculodisp_codigo').value, 
                                                                 vListaParams('fcf_veiculodisp_sequencia').value,  
                                                                 vMessage  ) ) Then
      --Lnaça a exceção.                                                        
      Raise vEx_Validacoes;
    End If;                                                      
    
    ---------------------------------------------------------------------------------------------------------
    --                             FASE DE CRIAÇÃO DO VALE DE FRETE                                        --
    ---------------------------------------------------------------------------------------------------------
    vCriaValeFrete := 'S'; 
    vMessage2 := '';   
    -- Verificando se existe um pedido de Acrescimo Aprovado
    for c_msg in (select cad.cad_frete_status status
    --                     ,cad.cad_frete_solicitacao
    --                     ,c.slf_contrato_descricao || '-' || cad.slf_contrato_codigo contrato
    --                     ,cad.fcf_tpcarga_codigo || '-' || tc.fcf_tpcarga_descricao carga
--                         ,cad.glb_localidade_origem || '-' || tdvadm.fn_busca_codigoibge(cad.glb_localidade_origem,'LOD') origem
--                         ,cad.glb_localidade_destino || '-' || tdvadm.fn_busca_codigoibge(cad.glb_localidade_destino,'LOD') destino
--                         ,cad.fcf_tpveiculo_codigo || '-' || tv.fcf_tpveiculo_descricao veiculo
--                         ,cad.cad_frete_pesoestimado peso
    --                     ,cad.cad_frete_km distancia
                         ,cad.cad_frete_jacadastrado frete
--                         ,cad.cad_frete_novovalor novovalor
--                         ,cad.cad_frete_novovalor_ajudante ajudante
--                         ,cad.cad_frete_aprovado aprovador
                         ,nvl(cad.cad_frete_vlraprovado,0) vlraprovado
                         ,cad.cad_frete_observacao observacao
    --                     ,cad.cad_frete_codigo acrescimo
    --                     ,sv.fcf_solveic_cod solicitacao
    --                     ,fc.fcf_fretecar_rowid IDFrete
                  from tdvadm.t_fcf_solveic sv,
                       tdvadm.t_fcf_fretecar fc,
                       tdvadm.t_cad_frete cad,
                       tdvadm.t_slf_contrato c,
                       tdvadm.t_fcf_tpcarga tc,
                       tdvadm.t_fcf_tpveiculo tv
                  where sv.fcf_veiculodisp_codigo = vListaParams('fcf_veiculodisp_codigo').value
                    and sv.fcf_veiculodisp_sequencia = vListaParams('fcf_veiculodisp_sequencia').value
                    and sv.fcf_fretecar_rowid = fc.fcf_fretecar_rowid
                    and fc.fcf_fretecar_rowid = cad.fcf_fretecar_rowid
                    and cad.fcf_tpcarga_codigo = tc.fcf_tpcarga_codigo
                    and cad.fcf_tpveiculo_codigo = tv.fcf_tpveiculo_codigo
                    and cad.slf_contrato_codigo = c.slf_contrato_codigo
                    and nvl(cad.cad_frete_vlraprovado,0) > 0)
     Loop
       
         If c_msg.status = 'AP' Then
            vCriaValeFrete := 'S';
            Update tdvadm.t_fcf_veiculodisp vd
               set vd.fcf_veiculodisp_acrescimo = c_msg.vlraprovado - c_msg.frete,
                   vd.fcf_veiculodisp_obsacrescimo = substr(c_msg.observacao,1,200) 
            where vd.fcf_veiculodisp_codigo = vListaParams('fcf_veiculodisp_codigo').value
              and vd.fcf_veiculodisp_sequencia = vListaParams('fcf_veiculodisp_sequencia').value;
         ElsIf c_msg.status = 'RJ' Then
            vCriaValeFrete := 'S';
            Update tdvadm.t_fcf_veiculodisp vd
               set vd.fcf_veiculodisp_acrescimo = 0,
                   vd.fcf_veiculodisp_obsacrescimo = substr(c_msg.observacao,1,200) 
            where vd.fcf_veiculodisp_codigo = vListaParams('fcf_veiculodisp_codigo').value
              and vd.fcf_veiculodisp_sequencia = vListaParams('fcf_veiculodisp_sequencia').value;
            vMessage2 := 'Acrescimo REJEITADO, gerando com Valor original da Mesa' || chr(10);
         ElsIf c_msg.status = 'AG' Then
            vCriaValeFrete := 'N';
            pStatus := 'E';
            pMessage := 'Aguardando Aprovação de Acrescimo Solicitado';      
            Return;             
         End If;
       
     End Loop;

    
    
    
    --Executo a procedure responsável por criar o Vale de Frete propriamente dito.
    sp_gera_valefrete( vListaParams('fcf_veiculodisp_codigo').value, 
                       vListaParams('fcf_veiculodisp_sequencia').value,
                       vListaParams('rota').value,
                       vListaParams('usuario').value,
                       '',
                       '',
                       '1',
                       '',
                       vStatus,
                       vMessage
                     );
                     
    --Seto os parametros de saida
    pStatus := vStatus;
    pMessage := vMessage2 || vMessage;                   

    ---------------------------------------------------------------------------------------------------------
    --                                 FASE DE PÓS-CRAÇÃO VALE DE FRETE                                    --
    ---------------------------------------------------------------------------------------------------------
    
    --Caso o Status tenha sido Normal
    If ( vStatus = 'N' ) Then
      -- atualizo a tabela de Veiculo disponivel, passando o flag de vale de frete.
      Update t_fcf_veiculodisp w
        Set w.Fcf_Veiculodisp_Flagvalefrete = 'S'
      Where w.fcf_veiculodisp_codigo = vListaParams('fcf_veiculodisp_codigo').value
        And w.fcf_veiculodisp_sequencia = vListaParams('fcf_veiculodisp_sequencia').value;
      
      Commit;  
    End If;
    

  Exception
    --Erro ao extrair parametros iniciais.
    When vEx_ParamsIniciais Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;
    
    When vEx_Validacoes Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := vMessage;
      Return;
    
   -- INSERT INTO t_JhowTchu (j,m)
   -- VALUES (2804, pXmlIn)  
      
    --Erro não previsto.
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao Tentar gerar Vale de Frete' || chr(10) ||
                  'Rotina: tdvadm.pkg_fifo_valefrete.sp_cria_valefrete();' || chr(10) ||
                  'Erro Ora: ' || Sqlerrm||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      Return;            
  End;
  
End sp_cria_ValeFrete;                

/*
Procedure Sp_Get_VERIFICA_CTRC_MAN_PEND(P_COD_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                                        P_SEQ_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                                        pLogs Out Varchar2)
 As                                        
  V_CONTADOR1 NUMBER;
  V_CONTADOR2 NUMBER;
  V_CONTADOR3 NUMBER;
  
  i integer := 0;
  --vResulString      PKG_GLB_COMMON.tliststring;
  vLogs varchar2(4000);  
  
BEGIN
  V_CONTADOR1 := 0;
  V_CONTADOR2 := 0;
  V_CONTADOR3 := 0;
  BEGIN
--  VERIFICA SE EXISTE CONHECIMENTO PARA SER IMPRESSO
    SELECT COUNT(*)
      INTO V_CONTADOR1
      FROM T_CON_CONHECIMENTO CO
     WHERE CO.CON_CONHECIMENTO_SERIE = 'XXX'
       AND CO.ARM_CARREGAMENTO_CODIGO IN
           (SELECT VD.ARM_CARREGAMENTO_CODIGO
              FROM T_FCF_VEICULODISP VD
             WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
               AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_CONTADOR1 := 0;
    WHEN OTHERS THEN
      V_CONTADOR1 := 0;
  END;
  --SE FOR PREENCHIDO A VARIAVEL V_CONTADOR1 ELE NEM PASSA
  --VERIFICA SE EXISTEM MANIFESTOS A SEREM IMPRESSOS
  IF V_CONTADOR1 = 0 THEN
    BEGIN
      SELECT COUNT(*)
        INTO V_CONTADOR2
        FROM T_CON_MANIFESTO CO
       WHERE CO.CON_MANIFESTO_SERIE = 'XXX'
         AND CO.ARM_CARREGAMENTO_CODIGO IN
             (SELECT VD.ARM_CARREGAMENTO_CODIGO
                FROM T_FCF_VEICULODISP VD
               WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                 AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CONTADOR2 := 0;
      WHEN OTHERS THEN
        V_CONTADOR2 := 0;
    END;
  Else
    i := i +1;
    vLogs := '- Existem conhecimentos a serem Impressos! '||Chr(10);
  END IF;

  IF V_CONTADOR1 = 0 AND V_CONTADOR2 = 0 THEN
    BEGIN
      --VERIFICA SE EXISTEM NESSES CARREGAMENTOS CONHECIMENTOS QUE FORAM IMPRESSOS SEM PLACA
      SELECT (SELECT COUNT(*)
                FROM T_CON_CONHECIMENTO CO
               WHERE CO.CON_CONHECIMENTO_PLACA IS null
                 AND CO.ARM_CARREGAMENTO_CODIGO IN
                     (SELECT VD.ARM_CARREGAMENTO_CODIGO
                        FROM T_FCF_VEICULODISP VD
                       WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                         AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO)) CONHECIMENTOS_SEM_PLACA,
             
             --VERIFICA SE EXISTEM MANIFESTOS A SEREM IMPRESSOS
             (SELECT COUNT(*)
                FROM T_CON_MANIFESTO CO
               WHERE CO.CON_MANIFESTO_SERIE = 'XXX'
                 AND CO.ARM_CARREGAMENTO_CODIGO IN
                     (SELECT VD.ARM_CARREGAMENTO_CODIGO
                        FROM T_FCF_VEICULODISP VD
                       WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                         AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO)) MANIFESTO_COM_SERIE_XXX,
             
             --VERIFICA SEM MANIFESTOS IMPRESSOS
             (SELECT COUNT(*)
                FROM T_CON_MANIFESTO CO
               --WHERE CO.CON_MANIFESTO_SERIE = 'A1'
               WHERE (CO.CON_MANIFESTO_SERIE = 'A0' or CO.CON_MANIFESTO_SERIE = 'A1')
                 AND CO.ARM_CARREGAMENTO_CODIGO IN
                     (SELECT VD.ARM_CARREGAMENTO_CODIGO
                        FROM T_FCF_VEICULODISP VD
                       WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                         AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO)) MANIFESTO_COM_SERIE_A1
        INTO V_CONTADOR1, V_CONTADOR2, V_CONTADOR3
        FROM DUAL;
        
        if V_CONTADOR1 > 0 then
          i := i +1;
          vLogs := vLogs || '- Existem Conhecimentos impressos sem Placa! '||Chr(10);
        end if; 
        
        if V_CONTADOR2 > 0 then
          i := i +1;          
          vLogs := vLogs || '- Existem Manifestos a serem impressos! '||Chr(10);
        end if;        
        
        if V_CONTADOR3 = 0 then
          i := i +1;          
          vLogs := vLogs || '- Não Existem Manifestos impressos! '||Chr(10);
        end if;          
        
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CONTADOR1 := 0;
        V_CONTADOR2 := 0;
        V_CONTADOR3 := 0;
      WHEN OTHERS THEN
        V_CONTADOR1 := 0;
        V_CONTADOR2 := 0;
        V_CONTADOR3 := 0;
    END;
  END IF;
  
  
  --vResulString := pkg_glb_common.fn_split(vLogs,';');
  
  pLogs := vLogs;
  
  
  --  V_CONTADOR1 = 0 V_CONTADOR2 = 0 V_CONTADOR3 = 0 SIGNIFICA QUE FORAM IMPRESSOS TODOS CONHECIMENTOS COM PLACA
  --IF ((V_CONTADOR1 = 0) AND (V_CONTADOR2 = 0) AND (V_CONTADOR3 = 0)) OR
  -- V_CONTADOR1 > 0 V_CONTADOR2 = 0 V_CONTADOR3 > 0 SIGNIFICA QUE FORAM GERADOS MANIFESTOS E QUE JA FORAM IMPRESSOS
  --   ((V_CONTADOR1 > 0) AND (V_CONTADOR2 = 0) AND (V_CONTADOR3 > 0)) OR
  -- GEROU MANIFESTO E CTRC COM PLACA IMPRESSOS   
  --   ((V_CONTADOR1 = 0) AND (V_CONTADOR2 = 0) AND (V_CONTADOR3 > 0)) THEN
    --RETURN('N');
  --  return;
  --ELSE
    --RETURN('E');
  --  return;
  --END IF;
END;                                 
*/  

-- Atual Validando o MDF-e
Procedure Sp_Verifica_CTRC_MDFe_Pend(P_COD_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                                      P_SEQ_VEICULO T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                                      pVerificaObrigatoriedadeMDFe In Char default 'N',
                                      pStatus  Out Char,
                                      pMessage Out Varchar)
As                                    
-- Analista: Diego Lirio
-- Criado: 06/08/2013
-- Funcionalidade: Válidação para proseguir Geração do Vale Frete....      
--                  Se pStatus retornar 'W' não passou pela validação; Motivos estarão na pMessage.
--                  Se pStatus retornar 'N' passou pela validação
-- Referencia: Tdvadm.Pkg_Con_Manifesto.Fn_Manifesto_Gerado(pVeicDisp,pVeicSeq)  
  vConhecimentosSerieXXX Integer;
  vQtdeConhecimento      Integer;
  --vManifestosPendentes Integer;
  --vCodManifestosPedentes varchar2(10);
  vConhecimentosNaoEletronicos Integer;
  --vManifestosExiste Integer;
  
  vQtdeNfServico Integer;
  vQtdeNfTotal   Integer;
  
  vCTeConferidos Integer := 0;
  
  --vVeicDispRowType t_Fcf_Veiculodisp%Rowtype;
  
BEGIN

  vConhecimentosSerieXXX := 0;
  vConhecimentosNaoEletronicos := 0;
  
  vQtdeConhecimento := 0;
  
  --vManifestosPendentes := 0;
  --vManifestosExiste := 0;
  pStatus := 'X';
  pMessage := ''; 
         
  Begin          
          --vVeicDispRowType := Pkg_Fcf_Veiculodisp.Fn_Get_VeiculoDispRowType(P_COD_VEICULO, P_SEQ_VEICULO); 
          ------------------- CTRC -----------------------
          -- Verifica se existem conhecimentos a serem impressos !!!
          Select Count(*)
            Into vConhecimentosSerieXXX
            From t_Con_Conhecimento co
            Where co.con_conhecimento_serie = 'XXX'
              and co.arm_carregamento_codigo In (Select ca.arm_carregamento_codigo
                                                   from t_arm_carregamento ca
                                                   where ca.fcf_veiculodisp_codigo = P_COD_VEICULO
                                                     and ca.fcf_veiculodisp_sequencia = P_SEQ_VEICULO);
          if vConhecimentosSerieXXX > 0 then
              pStatus := 'W';
              pMessage := pMessage || 'Existem Conhecimento Não Impressos!;';                                                                   
          elsif vConhecimentosSerieXXX <= 0 then        
                -- Verifica se existem alguns conhecimentos não eletronicos....                                
                Select count(*)
                  Into vConhecimentosNaoEletronicos
                  From t_arm_carregamento c,
                       t_con_conhecimento co
                  where 0=0
                    and c.arm_carregamento_codigo = co.arm_carregamento_codigo
                    and c.fcf_veiculodisp_codigo = P_COD_VEICULO
                    and c.fcf_veiculodisp_sequencia = P_SEQ_VEICULO
                    and Tdvadm.Pkg_Con_Cte.FN_CTE_EELETRONICO(co.Con_Conhecimento_Codigo,co.Con_Conhecimento_Serie,co.Glb_Rota_Codigo) = 'N'
                    and rownum = 1;
                    
                if vConhecimentosNaoEletronicos > 0 then
                      pStatus := 'W';
                      pMessage := pMessage || 'Existem Conhecimento Não Eletrônicos!;';
                end if;  
          end if;                                 

          ------------------- fim CTRC -----------------------                                                




          ------------------- Conferencia de CT-e ------------
          
          -- TODO: vinculo com veicdisp somente para pega o armazem gerado, esta em teste para SP, retirar filtro por armazem                    
          --if vVeicDispRowType.Arm_Armazem_Codigo = '06' then
              Select Count(*)
                Into vCTeConferidos
                From t_fcf_veicdispconfcte v
                Where v.fcf_veicdispconfcte_status = 'F'
                  and v.fcf_veiculodisp_codigo = P_COD_VEICULO
                  and v.fcf_veiculodisp_sequencia = P_SEQ_VEICULO;              
              
              if vCTeConferidos = 0 then
                  pStatus := 'W';
                  pMessage := pMessage || 'Conferência de Conhecimento pendente ou não finalizada!;';            
              end if;    
          --end if;
          ------------------- fim Conferencia de CT-e ------------          
          
          
          
          ------------------- NF --------------------------          
          -- pega qtde de nf (total)
          select Count(*)
            into vQtdeNfTotal
            from t_fcf_veiculodisp v,
                 t_arm_carregamento c,
                 t_con_conhecimento co
            where v.fcf_veiculodisp_codigo = P_COD_VEICULO
              and v.fcf_veiculodisp_sequencia = P_SEQ_VEICULO   
              and v.fcf_veiculodisp_codigo = c.fcf_veiculodisp_codigo
              and v.fcf_veiculodisp_sequencia = c.fcf_veiculodisp_sequencia    
              and c.arm_carregamento_codigo = co.arm_carregamento_codigo;              
          -- pega qtde de nf de serviço
          select Count(*)
            into vQtdeNfServico
            from t_fcf_veiculodisp v,
                 t_arm_carregamento c,
                 t_con_conhecimento co
            where v.fcf_veiculodisp_codigo = P_COD_VEICULO
              and v.fcf_veiculodisp_sequencia = P_SEQ_VEICULO
              and v.fcf_veiculodisp_codigo = c.fcf_veiculodisp_codigo
              and v.fcf_veiculodisp_sequencia = c.fcf_veiculodisp_sequencia    
              and c.arm_carregamento_codigo = co.arm_carregamento_codigo
              and 'NF' = TDVADM.f_busca_conhec_tpformulario(co.con_conhecimento_codigo, co.con_conhecimento_serie, co.glb_rota_codigo);
          ------------------- Fim NF ----------------------          
                  
          
                  Select count(*)
                    Into vQtdeConhecimento
                    From t_arm_carregamento c,
                         t_con_conhecimento co
                    where 0=0
                      and c.arm_carregamento_codigo = co.arm_carregamento_codigo
                      and c.fcf_veiculodisp_codigo = P_COD_VEICULO
                      and c.fcf_veiculodisp_sequencia = P_SEQ_VEICULO;  
                  /*****
                  N => gera todos mdfe
                  L => Se conhecimento > 1 gera MDFe
                  T => MDFe nao é obrigatorio (libera validação)
                  *****/                  
                  
                  /*   Alteração: Diego 01/12/2014, geração do manifesto será após geração VF
                  
                  if --(vVerificaObrigatoriedadeMDFe != 'N') Or 
                     ((pVerificaObrigatoriedadeMDFe = 'L') and (vQtdeConhecimento = 1)) Or
                     (pVerificaObrigatoriedadeMDFe = 'T') then
                        if pStatus = 'X' then
                             pStatus := 'N';
                             pMessage := 'Veiculo válido com sucesso!';
                        end if;         
                        return;              
                  end if;
                  
                  */
          
          
          
          /*   Alteração: Diego 01/12/2014, geração do manifesto será após geração VF
          
          -- Verifica MDFe somente se existem NF além SERVICO.
          if (vQtdeNfTotal != 0) and (vQtdeNfTotal != vQtdeNfServico) then
                  --------------------- MDFe --------------------------
                  -- Verifica se existem Manifsto a serem impressos !!!    
                  Select Count(*)
                    Into vManifestosExiste
                    From t_con_veicdispmanif vm
                    where vm.fcf_veiculodisp_codigo =  P_COD_VEICULO
                      and vm.fcf_veiculodisp_sequencia = P_SEQ_VEICULO;   
                  if vManifestosExiste = 0 then
                      pStatus := 'W';
                      pMessage := pMessage || 'Veículo não contém Manifesto Gerado.;';            
                  end if;
                                                         
                  SELECT max(m.con_manifesto_codigo),count(*)
                    INTO vCodManifestosPedentes,
                         vManifestosPendentes
                    FROM t_con_manifesto m,
                         t_con_veicdispmanif v
                   WHERE m.CON_MANIFESTO_SERIE = 'XXX'
                     AND m.con_manifesto_codigo = v.con_manifesto_codigo
                     and m.con_manifesto_serie  = v.con_manifesto_serie
                     and m.con_manifesto_rota   = v.con_manifesto_rota
                     and v.fcf_veiculodisp_codigo = P_COD_VEICULO
                     and v.fcf_veiculodisp_sequencia = P_SEQ_VEICULO;
                     
                  if vManifestosPendentes > 0 then
                      pStatus := 'W';
                      pMessage := pMessage || 'Existem ' || to_char(vManifestosPendentes) || ' Manifesto na Série XXX (Não Autorizados)...ex : [' || vCodManifestosPedentes || '] Veiculo [' || P_COD_VEICULO || '-' || P_SEQ_VEICULO || '];';
                  end if;   
                     
                  -- Se Todos os Manifesto estiverem Solicitados a Autorização, Verifica se
                  --  todos Foram Autorizados ou se há algum Rejeitado.           
                  If vManifestosPendentes = 0 then    
                       SELECT max(m.con_manifesto_codigo),count(*)
                           INTO vCodManifestosPedentes,
                                vManifestosPendentes
                         From t_Con_Manifesto m,
                              t_Con_Controlemdfe cm,
                              t_con_veicdispmanif v
                        where m.con_manifesto_codigo = cm.con_manifesto_codigo(+)
                          and m.con_manifesto_serie  = cm.con_manifesto_serie(+)
                          and m.con_manifesto_rota   = cm.con_manifesto_rota(+)
                          
                          -- Alteracao: Diego - 19/12/2013 
                          -- Liberado o Encerrados: Estudar Exceção dos Encerrados.
                          and nvl(cm.con_mdfestatus_codigo, 'XX') Not In('OK', 'EN')
                          
                          and m.con_manifesto_codigo = v.con_manifesto_codigo
                          and m.con_manifesto_serie  = v.con_manifesto_serie
                          and m.con_manifesto_rota   = v.con_manifesto_rota
                          and m.con_manifesto_serie  = 'A1'
                          and v.fcf_veiculodisp_codigo = P_COD_VEICULO
                          
                          -- Alteracao: Diego 16/12/2013
                          -- Temp.: Veiculo 1836147 viajou sem VF, 
                          --         e realizou a baixa do mdf antes de ser emitido o VF.
                          --         Liberado para realizar o pagto. Retirar após o processo concluido!
                          -- >>>>>>>>>>>>>>> and v.fcf_veiculodisp_codigo != '1836147'
                          
                          and v.fcf_veiculodisp_sequencia = P_SEQ_VEICULO;   
                          
                       if vManifestosPendentes > 0 then
                            pStatus := 'W';
                            pMessage := pMessage || 'Existem ' || to_char(vManifestosPendentes) || ' Manifesto na Série A1 (Solicitados e não Autorizados)...ex : [' || vCodManifestosPedentes || '] Veiculo [' || P_COD_VEICULO || '-' || P_SEQ_VEICULO || '];';
                       end if;   
                  end if; 
                  
                  if '1852854' = P_COD_VEICULO then
                       pStatus := 'X';
                  end if;                 
                   
           end if;
          --------------------- MDFe --------------------------
          */
          
          if pStatus = 'X' then
               pStatus := 'N';
               pMessage := 'Veiculo válido com sucesso!';
          end if;                                                              
  Exception
    When Others Then
      pStatus := 'E';
      pMessage := 'Erro ao Verificar Validação: ' || sqlerrm;
  End;


  /*
  V_CONTADOR1 := 0;
  V_CONTADOR2 := 0;
  V_CONTADOR3 := 0;
  BEGIN
--  VERIFICA SE EXISTE CONHECIMENTO PARA SER IMPRESSO
    SELECT COUNT(*)
      INTO V_CONTADOR1
      FROM T_CON_CONHECIMENTO CO
     WHERE CO.CON_CONHECIMENTO_SERIE = 'XXX'
       AND CO.ARM_CARREGAMENTO_CODIGO IN
           (SELECT VD.ARM_CARREGAMENTO_CODIGO
              FROM T_FCF_VEICULODISP VD
             WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
               AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_CONTADOR1 := 0;
    WHEN OTHERS THEN
      V_CONTADOR1 := 0;
  END;
  --SE FOR PREENCHIDO A VARIAVEL V_CONTADOR1 ELE NEM PASSA
  --VERIFICA SE EXISTEM MANIFESTOS A SEREM IMPRESSOS
  IF V_CONTADOR1 = 0 THEN
    BEGIN
      SELECT COUNT(*)
        INTO V_CONTADOR2
        FROM T_CON_MANIFESTO CO
       WHERE CO.CON_MANIFESTO_SERIE = 'XXX'
         AND CO.ARM_CARREGAMENTO_CODIGO IN
             (SELECT VD.ARM_CARREGAMENTO_CODIGO
                FROM T_FCF_VEICULODISP VD
               WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                 AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CONTADOR2 := 0;
      WHEN OTHERS THEN
        V_CONTADOR2 := 0;
    END;
  END IF;

  IF V_CONTADOR1 = 0 AND V_CONTADOR2 = 0 THEN
    BEGIN
      --VERIFICA SE EXISTEM NESSES CARREGAMENTOS CONHECIMENTOS QUE FORAM IMPRESSOS SEM PLACA
      SELECT (SELECT COUNT(*)
                FROM T_CON_CONHECIMENTO CO
               WHERE CO.CON_CONHECIMENTO_PLACA IS null
                 AND CO.ARM_CARREGAMENTO_CODIGO IN
                     (SELECT VD.ARM_CARREGAMENTO_CODIGO
                        FROM T_FCF_VEICULODISP VD
                       WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                         AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO)) CONHECIMENTOS_SEM_PLACA,
             
             --VERIFICA SE EXISTEM MANIFESTOS A SEREM IMPRESSOS
             (SELECT COUNT(*)
                FROM T_CON_MANIFESTO CO
               WHERE CO.CON_MANIFESTO_SERIE = 'XXX'
                 AND CO.ARM_CARREGAMENTO_CODIGO IN
                     (SELECT VD.ARM_CARREGAMENTO_CODIGO
                        FROM T_FCF_VEICULODISP VD
                       WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                         AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO)) MANIFESTO_COM_SERIE_XXX,
             
             --VERIFICA SEM MANIFESTOS IMPRESSOS
             (SELECT COUNT(*)
                FROM T_CON_MANIFESTO CO
               --WHERE CO.CON_MANIFESTO_SERIE = 'A1'
               WHERE CO.CON_MANIFESTO_SERIE = 'A1'
                 AND CO.ARM_CARREGAMENTO_CODIGO IN
                     (SELECT VD.ARM_CARREGAMENTO_CODIGO
                        FROM T_FCF_VEICULODISP VD
                       WHERE VD.FCF_VEICULODISP_CODIGO = P_COD_VEICULO
                         AND VD.FCF_VEICULODISP_SEQUENCIA = P_SEQ_VEICULO)) MANIFESTO_COM_SERIE_A1
        INTO V_CONTADOR1, V_CONTADOR2, V_CONTADOR3
        FROM DUAL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CONTADOR1 := 0;
        V_CONTADOR2 := 0;
        V_CONTADOR3 := 0;
      WHEN OTHERS THEN
        V_CONTADOR1 := 0;
        V_CONTADOR2 := 0;
        V_CONTADOR3 := 0;
    END;
  END IF;
  --  V_CONTADOR1 = 0 V_CONTADOR2 = 0 V_CONTADOR3 = 0 SIGNIFICA QUE FORAM IMPRESSOS TODOS CONHECIMENTOS COM PLACA
  IF ((V_CONTADOR1 = 0) AND (V_CONTADOR2 = 0) AND (V_CONTADOR3 = 0)) OR
  -- V_CONTADOR1 > 0 V_CONTADOR2 = 0 V_CONTADOR3 > 0 SIGNIFICA QUE FORAM GERADOS MANIFESTOS E QUE JA FORAM IMPRESSOS
     ((V_CONTADOR1 > 0) AND (V_CONTADOR2 = 0) AND (V_CONTADOR3 > 0)) OR
  -- GEROU MANIFESTO E CTRC COM PLACA IMPRESSOS   
     ((V_CONTADOR1 = 0) AND (V_CONTADOR2 = 0) AND (V_CONTADOR3 > 0)) THEN
    RETURN('N');
  ELSE
    RETURN('E');
  END IF;
  */
  
END Sp_Verifica_CTRC_MDFe_Pend;                 
 
Function Fn_Validos_CTRC_MDFe(pVeiculoDisp T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE,
                              pSequencia   T_FCF_VEICULODISP.FCF_VEICULODISP_SEQUENCIA%TYPE,
                              pParamMdfe In Char default 'N') return Char
As
vResult Char(1);
vStatus Char(1);
vMessage Varchar(1000);
Begin
   vResult := 'N';
   Sp_Verifica_CTRC_MDFe_Pend(pVeiculoDisp, pSequencia, pParamMdfe, vStatus, vMessage);
   if vStatus = 'N' then
      vResult := 'S';
   end if;
   return vResult;
End Fn_Validos_CTRC_MDFe;   

Procedure Sp_Get_ValeFrete(pXmlIn   In Varchar2,
                           pXmlOut  Out Clob,
                           pStatus  Out Char,
                           pMessage Out varchar2)                           
As
  vCarregamento                t_Arm_Carregamento.Arm_Carregamento_Codigo%Type;
  vPlaca                       Varchar2(7);
  vArmazem                     Varchar2(10);
  vDataInicio                  Varchar2(10);
  vDataFim                     Varchar2(10);
  vTF                          Varchar2(5); 
  vAuxiliar                    Integer;
  vCount                       Integer;  
  vCount2                      Integer; 
  vCount3                      Integer; 
  vLinha                       Clob;  
  vLinhaVF                     CLOB;
  --vLinhaVF2                    CLOB;
  vListaParams                 Glbadm.Pkg_Listas.tListaUsuParametros;
  vVerificaObrigatoriedadeMDFe Char(1);
  --vAuxiliar number;
  --vAuxiliarVF number;
Begin
  
--  INSERT INTO dropme (a, l) values ('jonatas/gustavo',pXmlIn); commit;

  Select extractvalue(Value(V), 'Input/Armazem'),
         extractvalue(Value(V), 'Input/Carregamento'),
         extractvalue(Value(V), 'Input/Placa'),
         extractvalue(Value(V), 'Input/DataInicio'),
         extractvalue(Value(V), 'Input/DataFim'),
         extractvalue(Value(V), 'Input/TipoFiltro')
    into vArmazem,
         vCarregamento,
         vPlaca,
         vDataInicio,
         vDataFim,
         vTF
    From TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;  
            
  Begin
    
    if not Glbadm.Pkg_Listas.FN_Get_UsuParamtros('comvlfrete',
                                                 'jsantos',
                                                 '010',
                                                 vListaParams) then
       return;
                                             
    end if;     
    
    vVerificaObrigatoriedadeMDFe := vListaParams('LIBERAMDFE').TEXTO;    
       
    -- Lista Veiculos disponiveis para a geração de Vale de Frete.
    vCount := 0;
    vLinha := '';
    For veic in (     
                           SELECT DISTINCT FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO, S.FCF_VEICULODISP_SEQUENCIA) PLACA,      
                                           S.FCF_VEICULODISP_DATA data,                    
                                           FN_BUSCA_MOTORISTAVEICULO(S.FCF_VEICULODISP_CODIGO, S.FCF_VEICULODISP_SEQUENCIA) MOTORISTA,                  
                                           T.FCF_TPVEICULO_DESCRICAO TPVEICULO,                                               
                                           S.FCF_VEICULODISP_OBS OBSERVACAO,                                                  
                                           S.FCF_VEICULODISP_DESCONTO DESCONTO,                                               
                                           S.FCF_VEICULODISP_CODIGO,                                                          
                                           S.FCF_VEICULODISP_SEQUENCIA,                                                       
                                           --Tdvadm.Fn_Verifica_Ctrc_Man_Pend(S.FCF_VEICULODISP_CODIGO, S.FCF_VEICULODISP_SEQUENCIA) FLAG,                       
                                           Fn_Validos_CTRC_MDFe(S.FCF_VEICULODISP_CODIGO, S.FCF_VEICULODISP_SEQUENCIA, vVerificaObrigatoriedadeMDFe) FLAG,                                              
                                           --FN_RETORNA_CARREGS_DO_VEIC(S.FCF_VEICULODISP_CODIGO, S.FCF_VEICULODISP_SEQUENCIA) COD_CARREGAMENTO           
                                           s.fcf_veiculodisp_codigo VeiculoDisp,
                                           s.fcf_veiculodisp_sequencia Sequencia                                           
                             FROM T_FCF_VEICULODISP S, T_FCF_TPVEICULO T, T_ARM_CARREGAMENTO C                                
                            WHERE (T.FCF_TPVEICULO_CODIGO = S.FCF_TPVEICULO_CODIGO)                                           
                              AND (S.FCF_OCORRENCIA_CODIGO IS NULL)                                                           
                              AND (S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL)                                                     
                              AND (S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL)                                                   
                              AND (S.FCF_VEICULODISP_CODIGO = C.FCF_VEICULODISP_CODIGO)                                       
                              AND (S.FCF_VEICULODISP_SEQUENCIA = C.FCF_VEICULODISP_SEQUENCIA)                                 
                              AND (S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL)                                                   

                              AND (S.ARM_ARMAZEM_CODIGO = vArmazem)


                              and ((vTF = 'PL' and trim(FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO, S.FCF_VEICULODISP_SEQUENCIA)) like '%'|| trim(vPlaca) ||'%')
                                Or (vTF = 'CA' and trim(FN_RETORNA_CARREGS_DO_VEIC(S.FCF_VEICULODISP_CODIGO, S.FCF_VEICULODISP_SEQUENCIA)) like trim(vCarregamento))
                                Or (vTF = 'DT' and trunc(c.arm_carregamento_dtfechamento) between trim(vDataInicio) and trim(vDataFim)))
                       ) Loop
                 vCount := vCount + 1;                           
                 vLinha := vLinha
                                  || '<row num="'        || To_Char(vCount)            ||'" >'            ||
                                     '   <Placa>'        || To_Char(veic.placa)        || '</Placa>'      ||
                                     '   <Data>'         || To_Char(veic.data)         || '</Data>'       ||
                                     '   <Motorista>'    || To_Char(veic.motorista)    || '</Motorista>'  ||
                                     '   <TPVeiculo>'    || To_Char(veic.tpveiculo)    || '</TPVeiculo>'  ||
                                     '   <Desconto>'     || To_Char(veic.desconto)     || '</Desconto>'   ||
                                     '   <Observacao>'   || To_Char(veic.observacao)   || '</Observacao>' ||
                                     '   <Flag>'         || To_Char(veic.Flag)         || '</Flag>'       ||
                                     '   <VeiculoDisp>'  || To_Char(veic.VeiculoDisp)  || '</VeiculoDisp>'||
                                     '   <Sequencia>'    || To_Char(veic.Sequencia)    || '</Sequencia>'  ||                                         
                                     '</row>';
     End Loop;    

    -- Lista dos Vales de Frete gerados normalmente(Embalagens do próprio Armazem).
    vCount := 0;
    vLinhaVF := '';
    For veic in (     
                       SELECT VF.CON_VALEFRETE_PLACA||' - 1' PLACA, 
                              VF.CON_CONHECIMENTO_CODIGO CTRC,                              
                              VF.CON_CONHECIMENTO_SERIE SERIE,                               
                              VF.GLB_ROTA_CODIGO ROTA,
                              VF.CON_VIAGEM_NUMERO VIAGEM,                                    
                              VF.CON_VALEFRETE_SAQUE SAQUE,                                      
                              VF.CON_VALEFRETE_LOCALCARREG ORIGEM,   
                              VF.CON_VALEFRETE_LOCALDESCARGA DESTINO,
                              VF.CON_VALEFRETE_KMPREVISTA KM, 
                              VF.CON_VALEFRETE_PESOINDICADO PESO,   
                              VF.CON_VALEFRETE_PESOCOBRADO COBRADO, 
                              VF.CON_VALEFRETE_ENTREGAS QTDE_ENTREGAS,  
                              VF.CON_VALEFRETE_DATAPRAZOMAX PRAZO_MAX,
                              VF.CON_VALEFRETE_ADIANTAMENTO ADIANTAMENTO,  
                              VF.CON_VALEFRETE_IMPRESSO IMPRESSO, 
                              VF.USU_USUARIO_CODIGO USUARIO,  
                              VF.CON_VALEFRETE_CUSTOCARRETEIRO FRETE_CARRET,  
                              VF.CON_VALEFRETE_PEDAGIO PEDAGIO,             
                              VF.FCF_VEICULODISP_CODIGO,
                              VF.FCF_VEICULODISP_SEQUENCIA,
                              pkg_fifo_manifesto.fn_manifesto_gerado(VF.fcf_veiculodisp_codigo, VF.fcf_veiculodisp_sequencia) Manifesto,
                              vc.con_vfreteciot_numero con_vfreteciot_numero, -- TODO: Retirar NVL
                              decode(PP.CAR_PROPRIETARIO_CLASSANTT,'CTC','TAC',PP.CAR_PROPRIETARIO_CLASSANTT) CAR_PROPRIETARIO_CLASSANTT,
                              PP.CAR_PROPRIETARIO_CLASSEQP,
                              PP.CAR_PROPRIETARIO_RNTRCDTVAL,
                              Pkg_Fcf_Veiculodisp.Fn_Get_TpFrotaAgregadoOutros(VD.FCF_VEICULODISP_CODIGO, VD.FCF_VEICULODISP_SEQUENCIA) FrotaAgreg
                                                 
                         FROM T_CON_VALEFRETE VF, 
                              T_ARM_CARREGAMENTO CAR, 
                              T_CON_CONHECIMENTO CO,
                              t_con_vfreteciot vc,
                              T_FCF_VEICULODISP VD,
                              tdvadm.T_CAR_VEICULO vca,
                              tdvadm.T_CAR_PROPRIETARIO PP                                   
                        WHERE (VF.CON_CONHECIMENTO_CODIGO = CO.CON_CONHECIMENTO_CODIGO)              
                          AND (VF.CON_CONHECIMENTO_SERIE  = CO.CON_CONHECIMENTO_SERIE)                
                          AND (VF.GLB_ROTA_CODIGO         = CO.GLB_ROTA_CODIGO)                              
                          AND TRUNC(VF.CON_VALEFRETE_DATACADASTRO) >= TRUNC(SYSDATE-10)
                          AND ((VF.CON_VALEFRETE_IMPRESSO IS NULL) or (Pkg_Fifo_ValeFrete.Fn_PodeSumirAbaValeFrete(vd.fcf_veiculodisp_codigo,
                                                                                                                   vd.fcf_veiculodisp_sequencia,
                                                                                                                   vf.con_conhecimento_codigo,
                                                                                                                   vf.con_conhecimento_serie,
                                                                                                                   vf.glb_rota_codigo,
                                                                                                                   vf.con_valefrete_saque) <> 'S'))                                    
                          AND (CAR.ARM_CARREGAMENTO_CODIGO = CO.ARM_CARREGAMENTO_CODIGO)             
                          
                          and nvl(vf.con_valefrete_status,'N') = 'N'
                          And vf.con_conhecimento_codigo = vc.con_conhecimento_codigo(+)
                          and vf.con_conhecimento_serie  = vc.con_conhecimento_serie(+)
                          and vf.glb_rota_codigo         = vc.glb_rota_codigo(+)
                          and vf.con_valefrete_saque     = vc.con_valefrete_saque(+)

                          And vf.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo(+)
                          And vf.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia(+)
                          AND vd.CAR_VEICULO_PLACA = vca.CAR_VEICULO_PLACA(+)
                          AND vd.CAR_VEICULO_SAQUE = vca.CAR_VEICULO_SAQUE(+)
                          AND vca.CAR_PROPRIETARIO_CGCCPFCODIGO = PP.CAR_PROPRIETARIO_CGCCPFCODIGO(+)                                                                                                       
                          
                          AND (CAR.arm_armazem_codigo = trim(vArmazem))

                          AND ((vTF = 'PL' and trim(VF.CON_VALEFRETE_PLACA) LIKE '%' || trim(vPlaca) || '%')
                            Or (vTF = 'CA' and CAR.ARM_CARREGAMENTO_CODIGO = vCarregamento)
                            Or (vTF = 'DT' AND TRUNC(CAR.ARM_CARREGAMENTO_DTFECHAMENTO) between trim(vDataInicio) and trim(vDataFim)))
                        Order by VF.CON_VALEFRETE_PLACA
                       ) Loop
                 vCount := vCount + 1;                           
                 vLinhaVF := vLinhaVF
                                  || '<row num="'        || To_Char(vCount)             ||'" >'             ||
                                     '   <Placa>'        || To_Char(veic.placa)         || '</Placa>'       ||
                                     '   <CTRC>'         || To_Char(veic.CTRC)          || '</CTRC>'        ||
                                     '   <Serie>'        || To_Char(veic.Serie)         || '</Serie>'       ||
                                     '   <Rota>'         || To_Char(veic.Rota)          || '</Rota>'        ||
                                     '   <Viagem>'       || To_Char(veic.Viagem)        || '</Viagem>'      ||
                                     '   <Saque>'        || To_Char(veic.Saque)         || '</Saque>'       ||
                                     '   <Origem>'       || To_Char(veic.Origem)        || '</Origem>'      ||
                                     '   <Destino>'      || To_Char(veic.Destino)       || '</Destino>'     ||
                                     '   <KM>'           || To_Char(veic.KM)            || '</KM>'          ||         
                                     '   <Peso>'         || To_Char(veic.Peso)          || '</Peso>'        ||
                                     '   <Cobrado>'      || To_Char(veic.Cobrado)       || '</Cobrado>'     ||
                                     '   <Qtde_Entrega>' || To_Char(veic.QTDE_ENTREGAS) || '</Qtde_Entrega>'||
                                     '   <Prazo_Max>'    || To_Char(veic.Prazo_Max)     || '</Prazo_Max>'   ||
                                     '   <Adiantamento>' || To_Char(veic.Adiantamento)  || '</Adiantamento>'||
                                     '   <Impresso>'     || To_Char(veic.Impresso)      || '</Impresso>'    ||
                                     '   <Usuario>'      || To_Char(veic.Usuario)       || '</Usuario>'     ||                                
                                     '   <Frete_Carret>' || To_Char(veic.FRETE_CARRET)  || '</Frete_Carret>'||
                                     '   <Pedagio>'      || To_Char(veic.Pedagio)       || '</Pedagio>'     ||
                                     
                                     '   <FCF_VEICULODISP_CODIGO>'    ||To_Char(veic.fcf_veiculodisp_codigo)       ||'</FCF_VEICULODISP_CODIGO>'||
                                     '   <FCF_VEICULODISP_SEQUENCIA>' ||To_Char(veic.FCF_VEICULODISP_SEQUENCIA)    ||'</FCF_VEICULODISP_SEQUENCIA>'||
                                     '   <Manifesto>'                 || To_Char(veic.Manifesto)                   || '</Manifesto>'  ||
                                     '   <con_vfreteciot_numero>'     || To_Char(veic.con_vfreteciot_numero)       || '</con_vfreteciot_numero>'  ||
                                     '   <CAR_PROPRIETARIO_CLASSANTT>'|| To_Char(veic.CAR_PROPRIETARIO_CLASSANTT)  || '</CAR_PROPRIETARIO_CLASSANTT>'  ||
                                     '   <CAR_PROPRIETARIO_CLASSEQP>' || To_Char(veic.CAR_PROPRIETARIO_CLASSEQP)   || '</CAR_PROPRIETARIO_CLASSEQP>'  ||
                                     '   <CAR_PROPRIETARIO_RNTRCDTVAL>'|| To_Char(veic.CAR_PROPRIETARIO_RNTRCDTVAL)|| '</CAR_PROPRIETARIO_RNTRCDTVAL>'  ||
                                     '   <FrotaAgreg>'                || To_Char(veic.FrotaAgreg)                  || '</FrotaAgreg>'  ||
                                     '</row>';
     End Loop;            
     
    -- Lista dos Vales de Frete gerados a partir de um CT-e feito pela Dig Manual(Sem Carreagemento).
    vCount2   := 0;
    For veic in (     
                       SELECT VF.CON_VALEFRETE_PLACA||' - 2' PLACA, 
                              VF.CON_CONHECIMENTO_CODIGO CTRC,                              
                              VF.CON_CONHECIMENTO_SERIE SERIE,                               
                              VF.GLB_ROTA_CODIGO ROTA,
                              VF.CON_VIAGEM_NUMERO VIAGEM,                                    
                              VF.CON_VALEFRETE_SAQUE SAQUE,                                      
                              VF.CON_VALEFRETE_LOCALCARREG ORIGEM,   
                              VF.CON_VALEFRETE_LOCALDESCARGA DESTINO,
                              VF.CON_VALEFRETE_KMPREVISTA KM, 
                              VF.CON_VALEFRETE_PESOINDICADO PESO,   
                              VF.CON_VALEFRETE_PESOCOBRADO COBRADO, 
                              VF.CON_VALEFRETE_ENTREGAS QTDE_ENTREGAS,  
                              VF.CON_VALEFRETE_DATAPRAZOMAX PRAZO_MAX,
                              VF.CON_VALEFRETE_ADIANTAMENTO ADIANTAMENTO,  
                              VF.CON_VALEFRETE_IMPRESSO IMPRESSO, 
                              VF.USU_USUARIO_CODIGO USUARIO,  
                              VF.CON_VALEFRETE_CUSTOCARRETEIRO FRETE_CARRET,  
                              VF.CON_VALEFRETE_PEDAGIO PEDAGIO,             
                              VF.FCF_VEICULODISP_CODIGO,
                              VF.FCF_VEICULODISP_SEQUENCIA,
                              pkg_fifo_manifesto.fn_manifesto_gerado(VF.fcf_veiculodisp_codigo, VF.fcf_veiculodisp_sequencia) Manifesto,
                              vc.con_vfreteciot_numero con_vfreteciot_numero, -- TODO: Retirar NVL
                              decode(PP.CAR_PROPRIETARIO_CLASSANTT,'CTC','TAC',PP.CAR_PROPRIETARIO_CLASSANTT) CAR_PROPRIETARIO_CLASSANTT,
                              PP.CAR_PROPRIETARIO_CLASSEQP,
                              PP.CAR_PROPRIETARIO_RNTRCDTVAL,
                              Pkg_Fcf_Veiculodisp.Fn_Get_TpFrotaAgregadoOutros(VD.FCF_VEICULODISP_CODIGO, VD.FCF_VEICULODISP_SEQUENCIA) FrotaAgreg
                              -- Flag MDF obrig esta no frontEnd, de acordo com o ETC/TAC/CTC e Equiparado(S/N)
                         FROM T_CON_VALEFRETE VF,
                              T_CON_CONHECIMENTO CO,
                              T_CON_VFRETECIOT VC,
                              T_FCF_VEICULODISP VD,
                              TDVADM.T_CAR_VEICULO VCA,
                              TDVADM.T_CAR_PROPRIETARIO PP,
                              T_ARM_ARMAZEM AR                                   
                        WHERE NVL(VF.CON_VALEFRETE_FIFO,'N') = 'S'
                          AND (VF.CON_CONHECIMENTO_CODIGO            = CO.CON_CONHECIMENTO_CODIGO)              
                          AND (VF.CON_CONHECIMENTO_SERIE             = CO.CON_CONHECIMENTO_SERIE)                
                          AND (VF.GLB_ROTA_CODIGO                    = CO.GLB_ROTA_CODIGO)                              
                          --AND (VF.CON_VALEFRETE_IMPRESSO IS NULL)
                          AND ((VF.CON_VALEFRETE_IMPRESSO IS NULL) or (Pkg_Fifo_ValeFrete.Fn_PodeSumirAbaValeFrete(vd.fcf_veiculodisp_codigo,
                                                                                                                   vd.fcf_veiculodisp_sequencia,
                                                                                                                   vf.con_conhecimento_codigo,
                                                                                                                   vf.con_conhecimento_serie,
                                                                                                                   vf.glb_rota_codigo,
                                                                                                                   vf.con_valefrete_saque) <> 'S'))
                          and nvl(vf.con_valefrete_status,'N') = 'N'
                          And vf.con_conhecimento_codigo             = vc.con_conhecimento_codigo(+)
                          and vf.con_conhecimento_serie              = vc.con_conhecimento_serie(+)
                          and vf.glb_rota_codigo                     = vc.glb_rota_codigo(+)
                          and vf.con_valefrete_saque                 = vc.con_valefrete_saque(+)

                          And vf.fcf_veiculodisp_codigo              = vd.fcf_veiculodisp_codigo(+)
                          And vf.fcf_veiculodisp_sequencia           = vd.fcf_veiculodisp_sequencia(+)
                          AND vd.CAR_VEICULO_PLACA                   = vca.CAR_VEICULO_PLACA(+)
                          AND vd.CAR_VEICULO_SAQUE                   = vca.CAR_VEICULO_SAQUE(+)
                          AND vca.CAR_PROPRIETARIO_CGCCPFCODIGO      = PP.CAR_PROPRIETARIO_CGCCPFCODIGO(+)                                                                                                       
                          AND VF.GLB_ROTA_CODIGO                     = AR.GLB_ROTA_CODIGO
                          AND (AR.arm_armazem_codigo                 = vArmazem)
                          AND CO.ARM_CARREGAMENTO_CODIGO             IS NULL

                          AND ((vTF = 'PL' and trim(VF.CON_VALEFRETE_PLACA) LIKE '%' || trim(vPlaca) || '%')
                            Or (vTF = 'DT' AND TRUNC(vf.con_valefrete_datacadastro) between trim(vDataInicio) and trim(vDataFim)))
                        Order by VF.CON_VALEFRETE_PLACA
                       ) Loop
                 vCount2 := vCount2 + 1;                           
                 vLinhaVF := vLinhaVF
                                  || '<row num="'        || To_Char(vCount)             ||'" >'             ||
                                     '   <Placa>'        || To_Char(veic.placa)         || '</Placa>'       ||
                                     '   <CTRC>'         || To_Char(veic.CTRC)          || '</CTRC>'        ||
                                     '   <Serie>'        || To_Char(veic.Serie)         || '</Serie>'       ||
                                     '   <Rota>'         || To_Char(veic.Rota)          || '</Rota>'        ||
                                     '   <Viagem>'       || To_Char(veic.Viagem)        || '</Viagem>'      ||
                                     '   <Saque>'        || To_Char(veic.Saque)         || '</Saque>'       ||
                                     '   <Origem>'       || To_Char(veic.Origem)        || '</Origem>'      ||
                                     '   <Destino>'      || To_Char(veic.Destino)       || '</Destino>'     ||
                                     '   <KM>'           || To_Char(veic.KM)            || '</KM>'          ||         
                                     '   <Peso>'         || To_Char(veic.Peso)          || '</Peso>'        ||
                                     '   <Cobrado>'      || To_Char(veic.Cobrado)       || '</Cobrado>'     ||
                                     '   <Qtde_Entrega>' || To_Char(veic.QTDE_ENTREGAS) || '</Qtde_Entrega>'||
                                     '   <Prazo_Max>'    || To_Char(veic.Prazo_Max)     || '</Prazo_Max>'   ||
                                     '   <Adiantamento>' || To_Char(veic.Adiantamento)  || '</Adiantamento>'||
                                     '   <Impresso>'     || To_Char(veic.Impresso)      || '</Impresso>'    ||
                                     '   <Usuario>'      || To_Char(veic.Usuario)       || '</Usuario>'     ||                                
                                     '   <Frete_Carret>' || To_Char(veic.FRETE_CARRET)  || '</Frete_Carret>'||
                                     '   <Pedagio>'      || To_Char(veic.Pedagio)       || '</Pedagio>'     ||
                                     
                                     '   <FCF_VEICULODISP_CODIGO>'    ||To_Char(veic.fcf_veiculodisp_codigo)       ||'</FCF_VEICULODISP_CODIGO>'||
                                     '   <FCF_VEICULODISP_SEQUENCIA>' ||To_Char(veic.FCF_VEICULODISP_SEQUENCIA)    ||'</FCF_VEICULODISP_SEQUENCIA>'||
                                     '   <Manifesto>'                 || To_Char(veic.Manifesto)                   || '</Manifesto>'  ||
                                     '   <con_vfreteciot_numero>'     || To_Char(veic.con_vfreteciot_numero)       || '</con_vfreteciot_numero>'  ||
                                     '   <CAR_PROPRIETARIO_CLASSANTT>'|| To_Char(veic.CAR_PROPRIETARIO_CLASSANTT)  || '</CAR_PROPRIETARIO_CLASSANTT>'  ||
                                     '   <CAR_PROPRIETARIO_CLASSEQP>' || To_Char(veic.CAR_PROPRIETARIO_CLASSEQP)   || '</CAR_PROPRIETARIO_CLASSEQP>'  ||
                                     '   <CAR_PROPRIETARIO_RNTRCDTVAL>'|| To_Char(veic.CAR_PROPRIETARIO_RNTRCDTVAL)|| '</CAR_PROPRIETARIO_RNTRCDTVAL>'  ||
                                     '   <FrotaAgreg>'                || To_Char(veic.FrotaAgreg)                  || '</FrotaAgreg>'  ||
                                     '</row>';
     End Loop;            
        
    -- Lista de Vales de Frete gerados a partir de Embalagens provenientes de transferencia(VF com um novo saque de um rota diferente).
    vCount3 := 0;
    For veic in ( SELECT VF.CON_VALEFRETE_PLACA PLACA, 
                             VF.CON_CONHECIMENTO_CODIGO CTRC,                              
                             VF.CON_CONHECIMENTO_SERIE SERIE,                               
                             VF.GLB_ROTA_CODIGO ROTA,
                             VF.CON_VIAGEM_NUMERO VIAGEM,                                    
                             VF.CON_VALEFRETE_SAQUE SAQUE,                                      
                             VF.CON_VALEFRETE_LOCALCARREG ORIGEM,   
                             VF.CON_VALEFRETE_LOCALDESCARGA DESTINO,
                             VF.CON_VALEFRETE_KMPREVISTA KM, 
                             VF.CON_VALEFRETE_PESOINDICADO PESO,   
                             VF.CON_VALEFRETE_PESOCOBRADO COBRADO, 
                             VF.CON_VALEFRETE_ENTREGAS QTDE_ENTREGAS,  
                             VF.CON_VALEFRETE_DATAPRAZOMAX PRAZO_MAX,
                             VF.CON_VALEFRETE_ADIANTAMENTO ADIANTAMENTO,  
                             VF.CON_VALEFRETE_IMPRESSO IMPRESSO, 
                             VF.USU_USUARIO_CODIGO USUARIO,  
                             VF.CON_VALEFRETE_CUSTOCARRETEIRO FRETE_CARRET,  
                             VF.CON_VALEFRETE_PEDAGIO PEDAGIO,             
                             VF.FCF_VEICULODISP_CODIGO,
                             VF.FCF_VEICULODISP_SEQUENCIA,
                             pkg_fifo_manifesto.fn_manifesto_gerado(VF.fcf_veiculodisp_codigo, VF.fcf_veiculodisp_sequencia) Manifesto,
                             vc.con_vfreteciot_numero con_vfreteciot_numero, -- TODO: Retirar NVL
                             decode(PP.CAR_PROPRIETARIO_CLASSANTT,'CTC','TAC',PP.CAR_PROPRIETARIO_CLASSANTT) CAR_PROPRIETARIO_CLASSANTT,
                             PP.CAR_PROPRIETARIO_CLASSEQP,
                             PP.CAR_PROPRIETARIO_RNTRCDTVAL,
                             Pkg_Fcf_Veiculodisp.Fn_Get_TpFrotaAgregadoOutros(VD.FCF_VEICULODISP_CODIGO, VD.FCF_VEICULODISP_SEQUENCIA) FrotaAgreg
                                                     
                        FROM T_CON_VALEFRETE VF, 
                             T_ARM_CARREGAMENTO CAR, 
                             T_CON_CONHECIMENTO CO,
                             t_con_vfreteciot vc,
                             T_FCF_VEICULODISP VD,
                             tdvadm.T_CAR_VEICULO vca,
                             tdvadm.T_CAR_PROPRIETARIO PP                                   
                       WHERE (VF.CON_CONHECIMENTO_CODIGO = CO.CON_CONHECIMENTO_CODIGO)              
                         AND (VF.CON_CONHECIMENTO_SERIE = CO.CON_CONHECIMENTO_SERIE)                
                         AND (VF.GLB_ROTA_CODIGO = CO.GLB_ROTA_CODIGO)                              
                         --AND (VF.CON_VALEFRETE_IMPRESSO IS NULL)                                    
                         AND ((VF.CON_VALEFRETE_IMPRESSO IS NULL) or (Pkg_Fifo_ValeFrete.Fn_PodeSumirAbaValeFrete(vd.fcf_veiculodisp_codigo,
                                                                                                                  vd.fcf_veiculodisp_sequencia,
                                                                                                                  vf.con_conhecimento_codigo,
                                                                                                                  vf.con_conhecimento_serie,
                                                                                                                  vf.glb_rota_codigo,
                                                                                                                  vf.con_valefrete_saque) <> 'S'))
                         and nvl(vf.con_valefrete_status,'N') = 'N'
                         AND (CAR.ARM_CARREGAMENTO_CODIGO      = CO.ARM_CARREGAMENTO_CODIGO)
                         And vf.con_conhecimento_codigo     	 = vc.con_conhecimento_codigo(+)
                         and vf.con_conhecimento_serie         = vc.con_conhecimento_serie(+)
                         and vf.glb_rota_codigo                = vc.glb_rota_codigo(+)
                         and vf.con_valefrete_saque            = vc.con_valefrete_saque(+)
                         And vf.fcf_veiculodisp_codigo         = vd.fcf_veiculodisp_codigo(+)
                         And vf.fcf_veiculodisp_sequencia      = vd.fcf_veiculodisp_sequencia(+)
                         AND vd.CAR_VEICULO_PLACA              = vca.CAR_VEICULO_PLACA(+)
                         AND vd.CAR_VEICULO_SAQUE              = vca.CAR_VEICULO_SAQUE(+)
                         AND vca.CAR_PROPRIETARIO_CGCCPFCODIGO = PP.CAR_PROPRIETARIO_CGCCPFCODIGO(+)        
                         and trunc(vf.con_valefrete_datacadastro) >= trunc(sysdate-5)                                                                                               
                         
                         AND (CAR.arm_armazem_codigo <> vArmazem)

                         AND ((vTF = 'PL' and trim(VF.CON_VALEFRETE_PLACA) LIKE '%' || trim(vPlaca) || '%')
                           --Or (vTF = 'CA' and CAR.ARM_CARREGAMENTO_CODIGO = vCarregamento)
                           --Or (vTF = 'DT' AND TRUNC(CAR.ARM_CARREGAMENTO_DTFECHAMENTO) between vDataInicio and vDataFim)
                           )
                       Order by VF.CON_VALEFRETE_PLACA
                           ) Loop
                     vCount3  := vCount3 + 1;                           
                     vLinhaVF := vLinhaVF
                                      || '<row num="'        || To_Char(vCount)             ||'" >'             ||
                                         '   <Placa>'        || To_Char(veic.placa)         || '</Placa>'       ||
                                         '   <CTRC>'         || To_Char(veic.CTRC)          || '</CTRC>'        ||
                                         '   <Serie>'        || To_Char(veic.Serie)         || '</Serie>'       ||
                                         '   <Rota>'         || To_Char(veic.Rota)          || '</Rota>'        ||
                                         '   <Viagem>'       || To_Char(veic.Viagem)        || '</Viagem>'      ||
                                         '   <Saque>'        || To_Char(veic.Saque)         || '</Saque>'       ||
                                         '   <Origem>'       || To_Char(veic.Origem)        || '</Origem>'      ||
                                         '   <Destino>'      || To_Char(veic.Destino)       || '</Destino>'     ||
                                         '   <KM>'           || To_Char(veic.KM)            || '</KM>'          ||         
                                         '   <Peso>'         || To_Char(veic.Peso)          || '</Peso>'        ||
                                         '   <Cobrado>'      || To_Char(veic.Cobrado)       || '</Cobrado>'     ||
                                         '   <Qtde_Entrega>' || To_Char(veic.QTDE_ENTREGAS) || '</Qtde_Entrega>'||
                                         '   <Prazo_Max>'    || To_Char(veic.Prazo_Max)     || '</Prazo_Max>'   ||
                                         '   <Adiantamento>' || To_Char(veic.Adiantamento)  || '</Adiantamento>'||
                                         '   <Impresso>'     || To_Char(veic.Impresso)      || '</Impresso>'    ||
                                         '   <Usuario>'      || To_Char(veic.Usuario)       || '</Usuario>'     ||                                
                                         '   <Frete_Carret>' || To_Char(veic.FRETE_CARRET)  || '</Frete_Carret>'||
                                         '   <Pedagio>'      || To_Char(veic.Pedagio)       || '</Pedagio>'     ||
                                         
                                         '   <FCF_VEICULODISP_CODIGO>'    ||To_Char(veic.fcf_veiculodisp_codigo)       ||'</FCF_VEICULODISP_CODIGO>'||
                                         '   <FCF_VEICULODISP_SEQUENCIA>' ||To_Char(veic.FCF_VEICULODISP_SEQUENCIA)    ||'</FCF_VEICULODISP_SEQUENCIA>'||
                                         '   <Manifesto>'                 || To_Char(veic.Manifesto)                   || '</Manifesto>'  ||
                                         '   <con_vfreteciot_numero>'     || To_Char(veic.con_vfreteciot_numero)       || '</con_vfreteciot_numero>'  ||
                                         '   <CAR_PROPRIETARIO_CLASSANTT>'|| To_Char(veic.CAR_PROPRIETARIO_CLASSANTT)  || '</CAR_PROPRIETARIO_CLASSANTT>'  ||
                                         '   <CAR_PROPRIETARIO_CLASSEQP>' || To_Char(veic.CAR_PROPRIETARIO_CLASSEQP)   || '</CAR_PROPRIETARIO_CLASSEQP>'  ||
                                         '   <CAR_PROPRIETARIO_RNTRCDTVAL>'|| To_Char(veic.CAR_PROPRIETARIO_RNTRCDTVAL)|| '</CAR_PROPRIETARIO_RNTRCDTVAL>'  ||
                                         '   <FrotaAgreg>'                || To_Char(veic.FrotaAgreg)                  || '</FrotaAgreg>'  ||
                                         '</row>';
         End Loop;   
    pXmlOut := '' ;
    --vAuxiliar   := 0;
    --vAuxiliarVF := 0;
    --vAuxiliar   := length(vLinha);
    --vAuxiliarVF := length(vLinhavf);
    

/*    If ( vAuxiliar > 32000 ) or  ( vAuxiliarVF > 32000 ) Then
        pStatus  := 'E';
        pMessage := 'Selecionou mutas linhas. Utilize mais Filtros de Pesquisa.';                            
    Else    
*/
        
        vAuxiliar := nvl(length(trim(vLinhavf)),0);
        If vAuxiliar < 32000 Then
           vLinhavf := Tdvadm.Pkg_Glb_Common.Fn_Limpa_Campo(vLinhavf);
        Else
           vLinhavf := Tdvadm.Pkg_Glb_Common.Fn_Limpa_Campocl(vLinhavf);
        End If;
        
        vAuxiliar := nvl(length(trim(vLinha)),0);
        If vAuxiliar < 32000 Then
           vLinha   := Tdvadm.Pkg_Glb_Common.Fn_Limpa_Campo(vLinha);
        Else
           vLinha   := Tdvadm.Pkg_Glb_Common.Fn_Limpa_Campocl(vLinha);
        End If;
        
        pXmlOut := '<Parametros>
                              <OutPut>
                                    <Tables>
                                          <Table name="ValeFrete_a_Gerar"><RowSet>'|| vLinha    || '</RowSet></Table>
                                          <Table name="ValeFrete_Gerados"><RowSet>'|| vLinhavf  || '</RowSet></Table>
                                    </Tables>
                              </OutPut>
                  </Parametros>';    
                    
        pStatus  := 'N';
        pMessage := 'OK';                            
--    End If;   
  Exception
    When Others Then
      pStatus := 'E';
      pMessage := sqlerrm||' - '||dbms_utility.format_error_backtrace;
  End;     
            
End Sp_Get_ValeFrete;  

Function Fn_PodeSumirAbaValeFrete(p_veicDisp in  t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                  p_veicSeq  in  t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                                  p_vfnumero in  t_con_valefrete.con_conhecimento_codigo%type,
                                  p_vfserie  in  t_con_valefrete.con_conhecimento_serie%type,
                                  p_vfrota   in  t_con_valefrete.glb_rota_codigo%type,
                                  p_vfsaque  in  t_con_valefrete.con_valefrete_saque%type) return char is 
vQtdeMdfe          integer;
vQtdeMdfeAut       integer;
vQtdeMdfeCancel    integer;
vQtdeMdfeEncerra   integer;
--vQtdeCteCarga      integer;
vPodeSumir         char(1);
--vValeFreteImpresso char(1);
vQtdeDocumentos    integer;
begin
  
 /* if (p_veicDisp = '2073028') then
    return 'S';
  end if;  */
  
  select count(*)
    into vQtdeDocumentos
    from t_con_vfreteconhec k
   where k.con_valefrete_codigo       = p_vfnumero
     and k.con_valefrete_serie        = p_vfserie 
     and k.glb_rota_codigovalefrete   = p_vfrota  
     and k.con_valefrete_saque        = p_vfsaque;
           
  select count(*)
    into vQtdeMdfe
    from t_con_veicdispmanif l
   where l.fcf_veiculodisp_codigo    = p_veicDisp
     and l.fcf_veiculodisp_sequencia = p_veicSeq;
 
  select count(*)
    into vQtdeMdfeAut
    from t_con_veicdispmanif l,
         t_con_controlemdfe cc
   where l.fcf_veiculodisp_codigo    = p_veicDisp
     and l.fcf_veiculodisp_sequencia = p_veicSeq
     and l.con_manifesto_codigo      = cc.con_manifesto_codigo
     and l.con_manifesto_serie       = cc.con_manifesto_serie
     and l.con_manifesto_rota        = cc.con_manifesto_rota
     and cc.con_mdfestatus_codigo    = 'OK';
     
  select count(*)
    into vQtdeMdfeCancel
    from t_con_veicdispmanif l,
         t_con_controlemdfe cc
   where l.fcf_veiculodisp_codigo    = p_veicDisp
     and l.fcf_veiculodisp_sequencia = p_veicSeq
     and l.con_manifesto_codigo      = cc.con_manifesto_codigo
     and l.con_manifesto_serie       = cc.con_manifesto_serie
     and l.con_manifesto_rota        = cc.con_manifesto_rota
     and cc.con_mdfestatus_codigo    = 'CA';
  
  select count(*)
    into vQtdeMdfeEncerra
    from t_con_veicdispmanif l,
         t_con_controlemdfe cc
   where l.fcf_veiculodisp_codigo    = p_veicDisp
     and l.fcf_veiculodisp_sequencia = p_veicSeq
     and l.con_manifesto_codigo      = cc.con_manifesto_codigo
     and l.con_manifesto_serie       = cc.con_manifesto_serie
     and l.con_manifesto_rota        = cc.con_manifesto_rota
     and cc.con_mdfestatus_codigo    = 'EN';

  If (vQtdeMdfe > 0) then
  
    if (vQtdeMdfe = vQtdeMdfeAut) then
    
       vPodeSumir := 'S';
    
    else
    
       vPodeSumir := 'N';
    
    end if;  
  
  else
    
    if (vQtdeDocumentos = 1) then
      
      vPodeSumir := 'S';
      
    else
      
      vPodeSumir := 'N';
      
    end if;
    
  end if;
  
  return vPodeSumir;  
  
end Fn_PodeSumirAbaValeFrete;                                      
                                  
 
End Pkg_Fifo_ValeFrete;
/
