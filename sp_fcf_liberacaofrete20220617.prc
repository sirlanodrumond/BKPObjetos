create or replace procedure sp_fcf_liberacaofrete(pEntrada in varchar2,
                                                         pID out char,
                                                         pStatus out char,
                                                         pMessage out clob) is
    type tpCurosr is REF CURSOR;
    i integer;
    vEntrada clob;
    vXmlSimulador clob;
    vXmlSaidaSimulador clob;
    vCorpoEmail varchar2(32000);
    vCursor tpCurosr;
    vStatus  char(1);
    vMessage varchar2(1000);
    vTabEmail clob;
    
    vRota    tdvadm.t_glb_rota.glb_rota_codigo%type;
    vVeiculo tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_descricao%type;
    vTipoFrete varchar2(20);
    vUsuario tdvadm.t_usu_usuario.usu_usuario_nome%type;
    vIDSolicitacao number;
    vNrEixos number;
    vCargaExpressa char(1);
    vtpFrete tdvadm.t_cad_frete%rowtype;
    vTpInfofrete tdvadm.t_cad_infofrete%rowtype;
    vLinha1       pkg_glb_SqlCursor.tpString1024;
    vGrupo       tdvadm.t_slf_clientecargas.glb_grupoeconomico_codigo%type;
    vCliente     tdvadm.t_slf_clientecargas.glb_cliente_cgccpfcodigo%type;
    vEmail   varchar2(2000);
    vDataCadastro date;

begin
   pStatus := 'N'; 
  If pEntrada is null Then
      vEntrada := empty_clob;
      vEntrada := '';
      vEntrada := vEntrada || '<Parametros>';
      vEntrada := vEntrada || '   <Inputs>';
      vEntrada := vEntrada || '      <Input>';
      vEntrada := vEntrada || '         <rota>021</rota>';
      vEntrada := vEntrada || '         <usuario>aejaraujo</usuario>';
      vEntrada := vEntrada || '         <armazem>06</armazem>';
      vEntrada := vEntrada || '         <solicitacao>ALTERAÇAO VF</solicitacao>';
      vEntrada := vEntrada || '         <tipofrete>NORMAL</tipofrete>';
      vEntrada := vEntrada || '         <contrato>C2017110116</contrato>';
      vEntrada := vEntrada || '         <cargatdv>11</cargatdv>';
      vEntrada := vEntrada || '         <cargaantt></cargaantt>';
      vEntrada := vEntrada || '         <idsimulador>17178</idsimulador>';
      vEntrada := vEntrada || '         <idsolicitacao>535148</idsolicitacao>';
      vEntrada := vEntrada || '         <origem>05571</origem>';
      vEntrada := vEntrada || '         <destino>66000</destino>';
      vEntrada := vEntrada || '         <passandopor>66000</passandopor>';
      vEntrada := vEntrada || '         <veiculo>1</veiculo>';
      vEntrada := vEntrada || '         <peso>25000</peso>';
      vEntrada := vEntrada || '         <km>2891</km>';
      vEntrada := vEntrada || '         <valoracrescimo>8000.00</valoracrescimo>';
      vEntrada := vEntrada || '         <valorajudante>0.00</valorajudante>';
      vEntrada := vEntrada || '         <autorizador>Alan Araujo</autorizador>';
      vEntrada := vEntrada || '      </Input>';
      vEntrada := vEntrada || '      <Tables>';
      vEntrada := vEntrada || '         <table name="infofrete" tipo="P">';
      vEntrada := vEntrada || '            <Rowset>';
      vEntrada := vEntrada || '               <row num="1">';
      vEntrada := vEntrada || '                  <data>26/07/2018</data>';
      vEntrada := vEntrada || '                  <fonte>AGENCIADOR</fonte>';
      vEntrada := vEntrada || '                  <valor>8200.00</valor>';
      vEntrada := vEntrada || '                  <nome>oiadskoadklçf</nome>';
      vEntrada := vEntrada || '                  <telefone>(11)97099-9803</telefone>';
      vEntrada := vEntrada || '                  <observacao>adsklçdaklçsklãdsf</observacao>';
      vEntrada := vEntrada || '               </row>';
      vEntrada := vEntrada || '            </Rowset>';
      vEntrada := vEntrada || '         </table>';
      vEntrada := vEntrada || '      </Tables>';
      vEntrada := vEntrada || '   </Inputs>';
      vEntrada := vEntrada || '</Parametros>';
Else
   vEntrada := pEntrada;
End If;
--rota
--tipofrete

  --insert into tdvadm.t_glb_sql values (vEntrada,sysdate,'ACRESCIMO','ACRESCIMO');
 -- commit;
  
  vtpFrete.Cad_Frete_Codigo := TDVADM.SEQ_CAD_FRETE.NEXTVAL;
  vtpFrete.Cad_Frete_Data := sysdate;

  vtpFrete.Glb_Localidade_Origem := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'origem' ));
  vtpFrete.Cad_Frete_Origem := tdvadm.fn_busca_codigoibge(vtpFrete.Glb_Localidade_Origem,'LOD');
  vtpFrete.Glb_Localidade_Destino := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'destino' ));
  vtpFrete.Cad_Frete_Destino := tdvadm.fn_busca_codigoibge(vtpFrete.Glb_Localidade_Destino,'LOD'); 
  
  -- Thiago - 08/01/2021 - Inclusão do passando por
  vtpFrete.Glb_Localidade_Passandopor := '99999';--trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'passandopor' ));
  vtpFrete.Cad_Frete_Passandopor      := tdvadm.fn_busca_codigoibge(vtpFrete.Glb_Localidade_Passandopor,'LOD'); 

  vtpFrete.Cad_Frete_Km := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'km' )); 
  vtpFrete.Cad_Frete_Novovalor := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'valoracrescimo' )); 
  vtpFrete.Cad_Frete_Vlraprovado := vtpFrete.Cad_Frete_Novovalor;

  vtpFrete.Cad_Frete_Solicitacao := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'solicitacao' ));

  Select a.arm_armazem_codigo || '-' || a.arm_armazem_descricao
    into vtpFrete.Cad_Frete_Armazem
  From tdvadm.t_arm_armazem a
  where a.arm_armazem_codigo = trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'armazem' ));

  vtpFrete.Fcf_Tpcarga_Codigo := nvl(trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'cargatdv' )),'02');
  vtpFrete.Fcf_Tpveiculo_Codigo := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'veiculo' ));
  vtpFrete.Usu_Usuario_Codigo := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'usuario' ));
  
  Select u.usu_usuario_nome
    into vUsuario
  from tdvadm.t_usu_usuario u
  where u.usu_usuario_codigo = vtpFrete.Usu_Usuario_Codigo;
  
  vtpFrete.Cad_Frete_Aprovado := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'autorizador' ));
  vtpFrete.Cad_Frete_Novovalor_Ajudante := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'valorajudante' ));
  
  Select c.slf_contrato_descricao
    into vtpFrete.Cad_Frete_Cliente
  from tdvadm.t_slf_contrato c
  where c.slf_contrato_codigo = trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'contrato' ));
  
  vtpFrete.Cad_Frete_Usualterastatus := null;
  vtpFrete.Cad_Frete_Dtaltstatus := sysdate;
  vtpFrete.Slf_Contrato_Codigo := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'contrato' ));
  vtpFrete.Cad_Frete_Pesoestimado := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'peso' ));
  vtpFrete.Cad_Frete_Tipocargaantt := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'cargaantt' ));
  vtpFrete.Fcf_Fretecar_Rowid := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'idsimulador' ));
  vTpfrete.Fcf_Solveic_Cod := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'idsolicitacao' ));
  vtpFrete.Cad_Frete_Status := 'AG';

  vTipoFrete := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'tipofrete' ));

  vtpFrete.Cad_Frete_Observacao := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam( vEntrada,'observacao' ));


  If vTipoFrete = 'NORMAL' Then
     vCargaExpressa := 'N';
  Else
     vCargaExpressa := 'S';
  End If;

  If vtpFrete.Fcf_Fretecar_Rowid is not null Then
     -- 04/05/2022 - Sirlano
     -- Validacao quando muda o FRETE
     Begin
        select fc.fcf_fretecar_valor
          into vtpFrete.Cad_Frete_Jacadastrado
        from tdvadm.t_fcf_fretecar fc
        where fc.fcf_fretecar_rowid = vtpFrete.Fcf_Fretecar_Rowid;
     Exception
        When NO_DATA_FOUND Then
           pStatus := 'E';
           pMessage := pMessage || ' RowID Invalido, Frete deve ter sido alterado. DESVINCULAR e VINCULAR NOVAMNTE NO SIMULADOR' || chr(10);
        End;
  Else
    vtpFrete.Cad_Frete_Jacadastrado := 0;
  End If;

/*
  Begin
      Select fa.fcf_antt_valoreixo
         into vtpFrete.Fcf_Fretecar_Vlrantt
      from tdvadm.t_fcf_antt fa
      where fa.fcf_tpfantt_codigo = vtpFrete.Cad_Frete_Tipocargaantt
        AND vtpFrete.Cad_Frete_Km between fa.fcf_antt_kmde and fa.fcf_antt_kmate;
  exception
    When NO_DATA_FOUND then
       vtpFrete.Fcf_Fretecar_Vlrantt := 0;
    End;
*/  

   If pStatus = 'N' Then
        vtpFrete.Fcf_Fretecar_Vlrantt := 0 ;
          Select tv.fcf_tpveiculo_nreixos,
                 tv.fcf_tpveiculo_descricao
            into vNrEixos,
                 vVeiculo
          From tdvadm.t_fcf_tpveiculo tv
          where tv.fcf_tpveiculo_codigo = vtpFrete.Fcf_Tpveiculo_Codigo;
          
          vtpFrete.Fcf_Fretecar_Vlrantt := ( vtpFrete.Fcf_Fretecar_Vlrantt * vtpFrete.Cad_Frete_Km ) * vNrEixos;






        vtpFrete.Cad_Frete_Semicms := 0;
        vtpFrete.Cad_Frete_Margemcadastrado := 0; 
        vtpFrete.Cad_Frete_Margemnovo := 0;
        vtpFrete.Cad_Frete_Valorkm := 0;
      --  vtpFrete.Cad_Frete_Datafrete :=
      --  vtpFrete.Cad_Frete_Valefrete := 

        
         begin
          select distinct cc.glb_cliente_cgccpfcodigo,
                 cc.glb_grupoeconomico_codigo
            into vCliente,
                 vGrupo
          from tdvadm.t_slf_clientecargas cc
          where cc.slf_contrato_codigo = vtpFrete.Slf_Contrato_Codigo
          and   rownum = 1;
          
        EXCEPTION 
          WHEN  NO_DATA_FOUND THEN
             vCliente := '999999999999';
             vGrupo := '9999';
          END;
          
              

          vXmlSimulador := vXmlSimulador || '<Parametros> ';
          vXmlSimulador := vXmlSimulador || '   <Inputs> ';
          vXmlSimulador := vXmlSimulador || '      <Input> ';
          vXmlSimulador := vXmlSimulador || '         <usuario>sdrumond</usuario>'; /*obrigatorio*/
          vXmlSimulador := vXmlSimulador || '         <cnpj>' || vCliente || '</cnpj>'; /*obrigatorio*/
          vXmlSimulador := vXmlSimulador || '         <grupo>' || vGrupo || '</grupo>';
          vXmlSimulador := vXmlSimulador || '         <contrato>' || vtpFrete.Slf_Contrato_Codigo || '</contrato>';
          vXmlSimulador := vXmlSimulador || '         <origem>' || vtpFrete.Glb_Localidade_Origem  || '</origem>';
          vXmlSimulador := vXmlSimulador || '         <destino>' || vtpFrete.Glb_Localidade_Destino  || '</destino>';
          vXmlSimulador := vXmlSimulador || '         <veiculo>' || vtpFrete.Fcf_Tpveiculo_Codigo  || '</veiculo>';
          vXmlSimulador := vXmlSimulador || '         <peso>' || vtpFrete.Cad_Frete_Pesoestimado  || '</peso>';
          vXmlSimulador := vXmlSimulador || '         <mercadoria>1000</mercadoria>';
          vXmlSimulador := vXmlSimulador || '         <onu>9999</onu>';
          vXmlSimulador := vXmlSimulador || '         <expresso>' || vCargaExpressa || '</expresso>';
          vXmlSimulador := vXmlSimulador || '      </Input> ';
      --    vXmlSimulador := vXmlSimulador || '      <Tables>'; 
      --    vXmlSimulador := vXmlSimulador || '         <table name="listaColetas" tipo="P">';
      --    vXmlSimulador := vXmlSimulador || '            <Rowset>';
      --    vXmlSimulador := vXmlSimulador || '               <row num="1">';
      --    vXmlSimulador := vXmlSimulador || '                  <arm_coleta_ncompra>845604</arm_coleta_ncompra>';
      --    vXmlSimulador := vXmlSimulador || '                  <arm_coleta_ciclo>001</arm_coleta_ciclo>';
      --    vXmlSimulador := vXmlSimulador || '               </row>';
      --    vXmlSimulador := vXmlSimulador || '               <row num="2">';
      --    vXmlSimulador := vXmlSimulador || '                  <arm_coleta_ncompra>845323</arm_coleta_ncompra>';
      --    vXmlSimulador := vXmlSimulador || '                  <arm_coleta_ciclo>001</arm_coleta_ciclo>';
      --    vXmlSimulador := vXmlSimulador || '               </row>';
      --    vXmlSimulador := vXmlSimulador || '            </Rowset>';
      --    vXmlSimulador := vXmlSimulador || '         </table>';
      --    vXmlSimulador := vXmlSimulador || '      </Tables>';
          vXmlSimulador := vXmlSimulador || '   </Inputs> ';
          vXmlSimulador := vXmlSimulador || '</Parametros> '; 


      --ALTERAÇAO VF
      --ALTERAÇAO PERCURSO
      --NOVO PERCURSO
         If vtpFrete.Cad_Frete_Solicitacao = 'NOVO PERCURSO' Then
            vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_Titulo('CRIACAO DE FRETE NA MESA');
         ElsIf vtpFrete.Cad_Frete_Solicitacao = 'ALTERAÇAO PERCURSO' Then
            vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_Titulo('ALTERACAO DE VALOR NO PERCURSO');
         ElsIf vtpFrete.Cad_Frete_Solicitacao = 'ALTERAÇAO VF' Then
            vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_Titulo('ACRESCIMO PARA A VIAGEM');
         End If;
         
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.LinhaH;
         
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_AbreLista;
         
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('STATUS : ','S','AGUARDANDO');
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('TIPO FRETE : ','S',vTipoFrete);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('CONTRATO : ','S',vtpFrete.Slf_Contrato_Codigo);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('CLIENTE : ','S',vtpFrete.Cad_Frete_Cliente);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('ORIGEM : ','S',vtpFrete.Cad_Frete_Origem);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('DESTINO : ','S',vtpFrete.Cad_Frete_Destino);
       
         Begin
             select fc.fcf_fretecar_dtcadastro
               into vDataCadastro
             from tdvadm.t_fcf_fretecar fc
             where fc.fcf_fretecar_rowid = vtpFrete.Fcf_Fretecar_Rowid;
         exception
           When NO_DATA_FOUND Then
              vDataCadastro := null;
           End ;
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('DATA CADASTRO  : ','S',to_char(vDataCadastro,'DD/MM/YYYY'));
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('VALOR CADASTRADO : ','S',tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Jacadastrado,10,2));
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('PESO : ','S',tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Pesoestimado,10,0) || ' KG' );
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('KM : ','S',tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Km,10,0));
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('EIXOS : ','S',vNrEixos);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('VEICULO : ','S', vVeiculo);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('USUARIO : ','S',vUsuario);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('ARMAZEM : ','S',vtpFrete.Cad_Frete_Armazem);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('APROVADOR : ','S',vtpFrete.Cad_Frete_Aprovado);
         /* Thiago - 24/05/2021 - Solicitado para ser removido Dantas - Custos */
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_ItensLista('OBSERVAÇÃO : ','S',vtpFrete.Cad_Frete_Observacao);
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_FechaLista;
         
         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.LinhaH;

      /*    tdvadm.pkg_fifo_carregctrc.sp_simulador(vXmlSimulador,
                                                  vXmlSaidaSimulador,
                                                  vStatus,
                                                  vMessage);
      */
        /* Thiago - 24/05/2021 - Solicitado para ser removido Dantas - Custos */
        /* 
        If vtpFrete.Fcf_Fretecar_Rowid is Not null Then
         open vCursor for Select extractvalue(value(field), 'simulado/titulo') titulo,
      --                        extractvalue(value(field), 'simulado/kmDe') kmDe,
      --                        extractvalue(value(field), 'simulado/kmAte') kmAte,
      --                        extractvalue(value(field), 'simulado/pesoDe') pesoDe,
      --                        extractvalue(value(field), 'simulado/pesoAte') pesoAte,
      --                        extractvalue(value(field), 'simulado/tabTdv') tabTdv,
      --                        extractvalue(value(field), 'simulado/saqTdv') saqTdv,
      --                        extractvalue(value(field), 'simulado/tipo') tipo,
      --                        extractvalue(value(field), 'simulado/veiculo') veiculo,
      --                        extractvalue(value(field), 'simulado/tipoCarga') tipoCarga,
      --                        extractvalue(value(field), 'simulado/valor') valor,
      --                        extractvalue(value(field), 'simulado/limite') limite,
      --                        extractvalue(value(field), 'simulado/valorExcedente') valorExcedente,
      --                        extractvalue(value(field), 'simulado/valorFixo') valorFixo,
                              tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Jacadastrado,20,2) "Valor Cadastrado",
                              tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Novovalor,20,2) "Novo Valor",
                              tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Novovalor_Ajudante,10,2) "Valor Ajudante",
                              tdvadm.f_mascara_valor(extractvalue(value(field), 'simulado/valorCalculado'),20,2) "Frete Empresa",
                              tdvadm.f_mascara_valor(round(vtpFrete.Cad_Frete_Novovalor / vtpFrete.Cad_Frete_Km,2),10,2) "Valor KM",
                              round(((extractvalue(value(field), 'simulado/valorCalculado') / vtpFrete.Cad_Frete_Jacadastrado )-1)* 100,2) || '%' "Margem Cadastrado",
                              decode(nvl(vtpFrete.Cad_Frete_Novovalor,0),0,0,round(((extractvalue(value(field), 'simulado/valorCalculado') / vtpFrete.Cad_Frete_Novovalor )-1)* 100,2)) || '%' "Margem Novo"
      --                        extractvalue(value(field), 'simulado/codigoCliente') codigoCliente,
      --                        extractvalue(value(field), 'simulado/perctOutb') perctOutb,
      --                        extractvalue(value(field), 'simulado/perctTrans') perctTrans,
      --                        extractvalue(value(field), 'simulado/soTransf') soTransf
                        From Table(xmlsequence( Extract(xmltype.createXml(vXmlSaidaSimulador) , 'simulador/simulados/simulado'))) field
                        where nvl(extractvalue(value(field), 'simulado/valorCalculado'),0) > 0;


        Else
         open vCursor for Select extractvalue(value(field), 'simulado/titulo') titulo,
      --                        extractvalue(value(field), 'simulado/kmDe') kmDe,
      --                        extractvalue(value(field), 'simulado/kmAte') kmAte,
      --                        extractvalue(value(field), 'simulado/pesoDe') pesoDe,
      --                        extractvalue(value(field), 'simulado/pesoAte') pesoAte,
      --                        extractvalue(value(field), 'simulado/tabTdv') tabTdv,
      --                        extractvalue(value(field), 'simulado/saqTdv') saqTdv,
      --                        extractvalue(value(field), 'simulado/tipo') tipo,
      --                        extractvalue(value(field), 'simulado/veiculo') veiculo,
      --                        extractvalue(value(field), 'simulado/tipoCarga') tipoCarga,
      --                        extractvalue(value(field), 'simulado/valor') valor,
      --                        extractvalue(value(field), 'simulado/limite') limite,
      --                        extractvalue(value(field), 'simulado/valorExcedente') valorExcedente,
      --                        extractvalue(value(field), 'simulado/valorFixo') valorFixo,
                              tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Jacadastrado,20,2) "Valor Cadastrado",
                              tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Novovalor,20,2) "Valor Novo",
                              tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Novovalor_Ajudante,10,2) "Valor Ajudante",
                              tdvadm.f_mascara_valor(extractvalue(value(field), 'simulado/valorCalculado'),20,2) "Frete Empresa",
                              tdvadm.f_mascara_valor(round(vtpFrete.Cad_Frete_Novovalor / vtpFrete.Cad_Frete_Km,2),10,2) "Valor KM",
                              round(((extractvalue(value(field), 'simulado/valorCalculado') / vtpFrete.Cad_Frete_Jacadastrado )-1)* 100,2) || '%' "Margem Cadastrado",
                              decode(nvl(vtpFrete.Cad_Frete_Novovalor,0),0,0,round(((extractvalue(value(field), 'simulado/valorCalculado') / vtpFrete.Cad_Frete_Novovalor )-1)* 100,2)) || '%' "Margem Novo"
      --                        extractvalue(value(field), 'simulado/codigoCliente') codigoCliente,
      --                        extractvalue(value(field), 'simulado/perctOutb') perctOutb,
      --                        extractvalue(value(field), 'simulado/perctTrans') perctTrans,
      --                        extractvalue(value(field), 'simulado/soTransf') soTransf
                        From Table(xmlsequence( Extract(xmltype.createXml(vXmlSaidaSimulador) , 'simulador/simulados/simulado'))) field
                        where nvl(extractvalue(value(field), 'simulado/valorCalculado'),0) > 0;

        End If;
        */

        insert into tdvadm.t_glb_sql values (vXmlSaidaSimulador,sysdate,'SIMULADOR','SIMULADORRESULTADO');
        commit;

        /* Thiago - 24/05/2021 - Solicitado para ser removido Dantas - Custos */
        --vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_Titulo('FRETE SIMULADO PARA O NOVO VALOR');
        vTabEmail := empty_clob; 
        pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
        pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
        /* Thiago - 24/05/2021 - Solicitado para ser removido Dantas - Custos */
        --pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha1);
        i := 1;
        for i in 1 .. vLinha1.count loop
           if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
              vTabEmail := vTabEmail || vLinha1(i);
           Else
               vTabEmail := vTabEmail || vLinha1(i) || chr(10);
           End if;
        End loop; 
        
        If i < 2 Then
          vTabEmail := vTabEmail || '</table>';
        End If; 

       /* Thiago - 24/05/2021 - Solicitado para ser removido Dantas - Custos */ 
        --vCorpoEmail := vCorpoEmail || vTabEmail;
        
        /* Thiago - 24/05/2021 - Solicitado para ser removido Dantas - Custos */
        --vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.LinhaH;
        
        /* Thiago - 24/05/2021 - Solicitado para ser removido Dantas - Custos */ 
        vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_Titulo('REFERENCIA TABELA ANTT');

        open vCursor for  select tp.fcf_tpfantt_descricao carga,
                                 '1' faixa,
                                 tdvadm.f_mascara_valor(( 0 * vNrEixos ) * vtpFrete.Cad_Frete_Km,20,2) valor,
                                 tdvadm.f_mascara_valor(vtpFrete.Cad_Frete_Novovalor,20,2) Novovalor,
                                 tdvadm.f_mascara_valor((( 0 * vNrEixos ) * vtpFrete.Cad_Frete_Km) - vtpFrete.Cad_Frete_Novovalor,20,2) diferenca
                          from tdvadm.t_fcf_antt an,
                               tdvadm.t_fcf_tpfantt tp
                          where an.fcf_tpfantt_codigo in ('01','03','10')
                            
      --                      and vtpFrete.Cad_Frete_Km between an.fcf_antt_kmde and an.fcf_antt_kmate
                            and an.fcf_tpfantt_codigo = tp.fcf_tpfantt_codigo; 

        vTabEmail := empty_clob; 
        pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
        pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
        pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha1);
        for i in 1 .. vLinha1.count loop
           if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
              vTabEmail := vTabEmail || vLinha1(i);
           Else
               vTabEmail := vTabEmail || vLinha1(i) || chr(10);
           End if;
        End loop; 

        vCorpoEmail := vCorpoEmail || vTabEmail;

         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.LinhaH;


        --vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.fn_Titulo('FONTES DE INFORMACAO');

         open vCursor for Select extractvalue(value(field), 'row/data') Data,
                                 extractvalue(value(field), 'row/fonte') Descricao,
                                 extractvalue(value(field), 'row/valor') Valor,
                                 extractvalue(value(field), 'row/nome') Nome,
                                 extractvalue(value(field), 'row/observacao') Observacao,
                                 extractvalue(value(field), 'row/telefone') Telefone
                           From Table(xmlsequence( Extract(xmltype.createXml(vEntrada) , 'Parametros/Inputs/Tables/table[@name="infofrete"]/Rowset/row'))) field;

        vTabEmail := empty_clob; 
        pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
        pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
        pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha1);
        for i in 1 .. vLinha1.count loop
           if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
              vTabEmail := vTabEmail || vLinha1(i);
           Else
               vTabEmail := vTabEmail || vLinha1(i) || chr(10);
           End if;
        End loop; 

        vCorpoEmail := vCorpoEmail || vTabEmail;

         vCorpoEmail := vCorpoEmail || tdvadm.pkg_glb_html.LinhaH;

         Select substr(p.usu_perfil_parat,instr(p.usu_perfil_parat,';') + 1)
           into vEmail
         from tdvadm.t_usu_perfil p
         where p.usu_aplicacao_codigo = 'veicdisp'
           and p.usu_perfil_codigo like 'AUTORIZADOR%'
           and instr(p.usu_perfil_parat,vtpFrete.Cad_Frete_Aprovado) > 0; 
         
         vEmail := vEmail ;
         
        wservice.pkg_glb_email.SP_ENVIAEMAIL('FRETE [' || vtpFrete.Cad_Frete_Codigo ||  '] - Aguardando',
                                             vCorpoEmail,
                                             'aut-e@dellavolpe.com.br',
                                             vEmail,
                                             'tdv.validafrete@dellavolpe.com.br');
      /*-- TDP_PRD
        INSERT INTO WSERVICE.T_GLB_EMAILPEND@TDP_PRD
          VALUES 
        (wservice.seq_glb_emailpend.nextval,
         'FRETE TDX',
         vCorpoEmail,
         'aut-e@dellavolpe.com.br',
         'sdrumond@dellavolpe.com.br;alan.araujo@dellavolpe.com.br',
         null,
         null,
         sysdate,
         null);
      */
         Insert into tdvadm.t_cad_frete values vtpFrete;

         for c_msg in (Select extractvalue(value(field), 'row/data') Data,
                              extractvalue(value(field), 'row/fonte') Descricao,
                              extractvalue(value(field), 'row/valor') Valor,
                              extractvalue(value(field), 'row/nome') nome,
                              extractvalue(value(field), 'row/observacao') observacao,
                              extractvalue(value(field), 'row/telefone') telefone
                        From Table(xmlsequence( Extract(xmltype.createXml(vEntrada) , 'Parametros/Inputs/Tables/table[@name="infofrete"]/Rowset/row'))) field)
         Loop
           
            vTpInfofrete.Cad_Infofrete_Codigo := tdvadm.seq_cad_infofrete.nextval;
            vTpInfofrete.Cad_Frete_Codigo := vtpFrete.Cad_Frete_Codigo;
            vTpInfofrete.Cad_Infofrete_Data := c_msg.data;
            vTpInfofrete.Cad_Infofrete_Descricao := c_msg.descricao;
            vTpInfofrete.Cad_Infofrete_Nome := c_msg.nome;
            vTpInfofrete.Cad_Infofrete_Telefone := c_msg.telefone;
            vTpInfofrete.Cad_Infofrete_Valor := c_msg.valor;
            vTpInfofrete.Cad_Infofrete_Observacao := c_msg.observacao;

            Insert into tdvadm.t_cad_infofrete values vTpInfofrete;
           
         End Loop;
         

         commit;   

         pID := vtpFrete.Cad_Frete_Codigo;
         pMessage := vCorpoEmail;

   End If;





  
end sp_fcf_liberacaofrete;
/
