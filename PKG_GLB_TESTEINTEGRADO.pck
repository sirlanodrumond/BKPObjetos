CREATE OR REPLACE PACKAGE PKG_GLB_TESTEINTEGRADO IS
/***************************************************************************************************
 * ROTINA           :
 * PROGRAMA         :
 * ANALISTA         :
 * DESENVOLVEDOR    :
 * DATA DE CRIACAO  :
 * BANCO            :
 * EXECUTADO POR    :
 * ALIMENTA         :
 * FUNCINALIDADE    :
 * ATUALIZA         :
 * PARTICULARIDADES :                                           
 * PARAM. OBRIGAT.  :
 *                                                                                                  *
 ****************************************************************************************************/
  TYPE T_CURSOR IS REF CURSOR;
  STATUS_NORMAL         CONSTANT CHAR(1)      := 'N';
  STATUS_ERRO           CONSTANT CHAR(1)      := 'E';


/* 
  vXmlModeloNota varchar2(32000) := '<Parametros>
                                        <Inputs>
                                           <Input>
                                                        <Destino_CNPJ></Destino_CNPJ>
                                                        <Destino_RSocial></Destino_RSocial>
                                                        <Destino_tpCliente></Destino_tpCliente>
                                                        <Destino_CodCliente></Destino_CodCliente>
                                                        <Destino_Endereco></Destino_Endereco>
                                                        <Destino_LocalCodigo></Destino_LocalCodigo>
                                                        <Destino_LocalDesc></Destino_LocalDesc>
                                                        <Sacado_CNPJ></Sacado_CNPJ>
                                                        <Sacado_RSocial></Sacado_RSocial>
                                                        <nota_tpDoc_codigo>55</nota_tpDoc_codigo>
                                                    </Row></Rowset>
                                                 </Table>
                                              </Tables>
                                           </Input>
                                        </Inputs>
                                     </Parametros>';

*/


vXmlModeloVincVeiculo varchar2(1000) :=
'<Parametros>
  <Input>
     <VeiculoDisp>#pVeicDisp#</VeiculoDisp>
     <VeiculoSeq>#pSequencia#</VeiculoSeq>
     <Usuario>#pUsuario#</Usuario>
     <Rota>#pRota#</Rota>
     <Armazem>#pArmazem#</Armazem>
     <ListaCarregamento>
        <Carregamento row="1" codigo="#pCarreg#"/>
     </ListaCarregamento>
  </Input>
</Parametros>
';
  
vXmlModeloNota varchar2(32000) := 
'<Parametros>
 <rota>#vRota#</rota>
<Inputs>
<Input>
 <usuario>testeplsql</usuario>
 <aplicacao>carreg</aplicacao>
 <armazem>#vArmazem#</armazem>
 <acao>E</acao>
 <finaliza_coleta>S</finaliza_coleta>
 <criar_coleta>#vCriaColeta#</criar_coleta>
<Tables>
<Table name="prodQuimicos">
 <Rowset><Row num="1"><codOnu>#vOnu#</codOnu><DescOnu>#vOnuDescricao#</DescOnu><grp_Emb>#vOnuGRPEMB#</grp_Emb><qtdeEmb>1</qtdeEmb><pesoEmb>1</pesoEmb></Row></Rowset>
</Table>
<Table name="dadosNota">
 <Rowset><Row num="1">
 <notaStatus>N</notaStatus>
 <coleta_Codigo>#vColeta#</coleta_Codigo>
 <coleta_Tipo>#vColetaEntrega#</coleta_Tipo>
 <nota_Sequencia>0</nota_Sequencia>
 <nota_numero>#vNumeroNota#</nota_numero>
 <nota_serie>001</nota_serie>
 <nota_dtEmissao>#vDtEmissao#</nota_dtEmissao>
 <nota_dtSaida>#vDtSaida#</nota_dtSaida>
 <nota_dtEntrada></nota_dtEntrada>
 <nota_chaveNFE>#vNotaChave#</nota_chaveNFE>
 <nota_pesoNota>#vPeso#</nota_pesoNota>
 <nota_pesoBalanca>#vPesoBal#</nota_pesoBalanca>
 <nota_altura>0</nota_altura>
 <nota_largura>0</nota_largura>
 <nota_comprimento>0</nota_comprimento>
 <nota_cubagem>0</nota_cubagem>
 <nota_EmpilhamentoFlag>N</nota_EmpilhamentoFlag>
 <nota_EmpilhamentoQtde>0</nota_EmpilhamentoQtde>
 <nota_descricao>Nota Teste</nota_descricao>
 <nota_qtdeVolume>1</nota_qtdeVolume>
 <nota_ValorMerc>#vValorMercadoria#</nota_ValorMerc>
 <nota_RequisTp>#vTabSol#</nota_RequisTp>
 <nota_RequisCodigo>#vNumTabSol#</nota_RequisCodigo>
 <nota_RequisSaque>#vNumSQTabSol#</nota_RequisSaque>
 <nota_Contrato>#vContrato#</nota_Contrato>
 <nota_PO>0</nota_PO><nota_Di>
 </nota_Di><nota_Vide>0</nota_Vide>
 <nota_flagPgto>#vFlagPagador#</nota_flagPgto>
 <carga_Codigo>0</carga_Codigo>
 <carga_Tipo>#vTemCD#</carga_Tipo>
 <vide_Sequencia>0</vide_Sequencia>
 <vide_Numero>0</vide_Numero>
 <vide_Cnpj></vide_Cnpj>
 <vide_Serie></vide_Serie>
 <mercadoria_codigo>#vMercadoria#</mercadoria_codigo>
 <mercadoria_descricao>Mercadoria Teste</mercadoria_descricao>
 <cfop_Codigo>6949</cfop_Codigo>
 <cfop_Descricao>Outra Saida de Mercadoria ou Prestacao de Servico Nao Especificado</cfop_Descricao>
 <embalagem_numero>0</embalagem_numero>
 <embalagem_flag></embalagem_flag>
 <embalagem_sequencia>0</embalagem_sequencia>
 <rota_Codigo>#vRota#</rota_Codigo>
 <rota_Descricao></rota_Descricao>
 <armazem_Codigo>#vArmazem#</armazem_Codigo>
 <armazem_Descricao></armazem_Descricao>
 <Remetente_CNPJ>#vRemetente#</Remetente_CNPJ>
 <Remetente_RSocial></Remetente_RSocial>
 <Remetente_tpCliente>#vTpRemetente#</Remetente_tpCliente>
 <Remetente_CodCliente></Remetente_CodCliente>
 <Remetente_Endereco></Remetente_Endereco>
 <Remetente_LocalCodigo>#vLocalOrigem#</Remetente_LocalCodigo>
 <Remetente_LocalDesc></Remetente_LocalDesc>
 <Destino_CNPJ>#vDestinatario#</Destino_CNPJ>
 <Destino_RSocial></Destino_RSocial>
 <Destino_tpCliente>#vTpDestinatario#</Destino_tpCliente>
 <Destino_CodCliente></Destino_CodCliente>
 <Destino_Endereco></Destino_Endereco>
 <Destino_LocalCodigo>#vLocalDestino#</Destino_LocalCodigo>
 <Destino_LocalDesc></Destino_LocalDesc>
 <Sacado_CNPJ>#vSacado#</Sacado_CNPJ>
 <Sacado_RSocial></Sacado_RSocial>
 <nota_tpDoc_codigo>#vTpNota#</nota_tpDoc_codigo>
</Row>
</Rowset>
</Table>
</Tables>
</Input>
</Inputs>
</Parametros>';


vXmlModeloCriaCarreg varchar2(10000) := 
'<parametros>
   <inputs>
      <input>
         <tables>
            <table name="listaParams">
               <rowset><row num="0" param_name="conn" param_value="" table_name="listaParams"/>
                       <row num="1" param_name="url" param_value="*" table_name="listaParams"/>
                       <row num="2" param_name="arm_armazem_codigo" param_value="#vArmazem#" table_name="listaParams"/>
                       <row num="3" param_name="acao" param_value="CD" table_name="listaParams"/>
                       <row num="4" param_name="usuario" param_value="usuario" table_name="listaParams"/>
                       <row num="5" param_name="aplicacao" param_value="carreg" table_name="listaParams"/>
                       <row num="6" param_name="rota" param_value="#vRota#" table_name="listaParams"/>
                       <row num="7" param_name="versao" param_value="15.10.27.1" table_name="listaParams"/>
                       <row num="8" param_name="aowner" param_value="tdvadm" table_name="listaParams"/>
                       <row num="9" param_name="package_name" param_value="pkg_fifo_carregamento" table_name="listaParams"/>
                       <row num="10" param_name="procedure_name" param_value="sp_cria_carregamento" table_name="listaParams"/>
                       <row num="11" param_name="procedure_tpRetorno" param_value="status" table_name="listaParams"/>
             </rowset>
            </table>
            <table name="lista_embalagens">
               <rowset>
                       #vListaEmbalagens#
               </rowset>
            </table>
        </tables>
     </input>
  </inputs>
</parametros>';


vXmlModeloCalcValeFrete varchar2(10000) :=
'VFNumero=nome=VFNumero|tipo=String|valor=#valefrete#*
 VFSerie=nome=VFSerie|tipo=String|valor=#serie#*
 VFRota=nome=VFRota|tipo=String|valor=#rota#*
 VFSaque=nome=VFSaque|tipo=String|valor=#saque#*
 VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=#usuarioTdv#*
 VFRotaUsuarioTDV=nome=VFRotaUsuarioTDV|tipo=String|valor=#rotaUsuarioTDV#*
 VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*
 VFVersaoAplicao=nome=VFVersaoAplicao|tipo=String|valor=19.12.9.0*';

vXmlModeloIDMesa varchar2(10000) :=
'<parametros>
  <inputs>
    <input>
      <usuario>#pUsuario#</usuario>
      <aplicacao>mesa</aplicacao>
      <rota>#pRota#</rota>
      <tpOperacao>V</tpOperacao>
      <tpMotorista>1</tpMotorista>
      <codfrota_agreg>#pPlaca#</codfrota_agreg>
      <placaSaque>0000</placaSaque>
      <codMotor_cpf>#pMotorista#</codMotor_cpf>
      <saqueMotor>0000</saqueMotor>
      <gerenciadora>1</gerenciadora>
      <motor_proprietario>N</motor_proprietario>
      <motor_cadGerenciadora>N</motor_cadGerenciadora>
      <propr_cadGerenciadora>N</propr_cadGerenciadora>
      <motor_tpPgtoFrete>0</motor_tpPgtoFrete>
      <prop_tpPgtoFrete>0</prop_tpPgtoFrete>
      <prop_freteCartao>#pCartao#</prop_freteCartao> -- 4417810326447019
      <ciot_dtInicial>#pDataIni#</ciot_dtInicial>
      <ciot_dtFinal>#pDAtaFim#</ciot_dtFinal>
    </input>
  </inputs>
</parametros>';

vXmlModeloIDMesaFrota varchar2(10000) :=
'<parametros>
  <inputs>
    <input>
      <usuario>#pUsuario#</usuario>
      <aplicacao>veicdisp</aplicacao>
      <rota>#pRota#</rota>
      <tpOperacao>V</tpOperacao>
      <tpMotorista>0</tpMotorista>
      <codfrota_agreg>#pPlaca#</codfrota_agreg>
      <gerenciadora>1</gerenciadora>
      <motor_proprietario>N</motor_proprietario>
      <motor_cadGerenciadora>N</motor_cadGerenciadora>
      <propr_cadGerenciadora>N</propr_cadGerenciadora>
      <motor_tpPgtoFrete>0</motor_tpPgtoFrete>
      <prop_tpPgtoFrete>2</prop_tpPgtoFrete>
      <ciot_dtInicial>#pDataIni#</ciot_dtInicial>
      <ciot_dtFinal>#pDAtaFim#</ciot_dtFinal>
    </input>
  </inputs>
</parametros>';

vXmlModeloIDMesaAGCA varchar2(10000) :=
'<parametros>
  <inputs>
    <input>
      <usuario>#pUsuario#</usuario>
      <aplicacao>veicdisp</aplicacao>
      <rota>#pRota#</rota>
      <tpOperacao>V</tpOperacao>
      <tpMotorista>1</tpMotorista>
      <codfrota_agreg>#pPlaca#</codfrota_agreg>
      <placaSaque>#pPlacaSaque#</placaSaque>
      <codMotor_cpf>#pMotorista#</codMotor_cpf>
      <saqueMotor>#pMotoristaSaque#</saqueMotor>
      <gerenciadora>1</gerenciadora>
      <motor_proprietario>N</motor_proprietario>
      <motor_cadGerenciadora>N</motor_cadGerenciadora>
      <propr_cadGerenciadora>N</propr_cadGerenciadora>
      <cartao_pedagio>#pCartaoPedagio#</cartao_pedagio>
      <motor_tpPgtoFrete>0</motor_tpPgtoFrete>
      <prop_tpPgtoFrete>0</prop_tpPgtoFrete>
      <prop_freteCartao>#pCartao#</prop_freteCartao> -- 4417810326447019
      <ciot_dtInicial>#pDataIni#</ciot_dtInicial>
      <ciot_dtFinal>#pDAtaFim#</ciot_dtFinal>
    </input>
  </inputs>
</parametros>';




vXmlModeloCriaCiot varchar2(10000) :=
'IntegraTdv_Cod=nome=IntegraTdv_Cod|tipo=String|valor=18*
 VFNumero=nome=VFNumero|tipo=String|valor=#pCodigoVF#*
 VFSerie=nome=VFSerie|tipo=String|valor=#pSerieVF#*
 VFRota=nome=VFRota|tipo=String|valor=#pRotaVF#*
 VFSaque=nome=VFSaque|tipo=String|valor=#pSaqueVF#*
 VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=#pUsuario#*
 VFRotaUsuarioTDV=nome=VFRotaUsuarioTDV|tipo=String|valor=#pRota#*
 VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*' ;


  Type TpParametros is Record (vXml              varchar2(32000),
                               vColetaEntrega    char(1) := '',
                               vCriaColeta       char(1) := 'S',
--                               vColeta           tdvadm.t_arm_coleta.arm_coleta_ncompra%type := '',
                               vTpNota           tdvadm.t_con_tpdoc.con_tpdoc_codigo%type := '99',
                               vNotaChave        tdvadm.t_arm_nota.arm_nota_chavenfe%type := '',
                               vNumeroNota       number,
                               vMercadoria       tdvadm.t_glb_mercadoria.glb_mercadoria_codigo%Type := '54',
                               vContrato         tdvadm.t_slf_contrato.slf_contrato_codigo%type := '',
                               vTabSol           char(1) := '',
                               vNumTabSol        tdvadm.t_slf_tabela.slf_tabela_codigo%type := '',
                               vNumSQTabSol      tdvadm.t_slf_tabela.slf_tabela_saque%type := '',
                               vDtEmissao        date := trunc(sysdate),
                               vDtSaida          date := trunc(sysdate),
                               vFlagPagador      char(1),
                               vSacado           tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                               vRemetente        tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                               vTpRemetente      tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                               vNomeRemetente    tdvadm.t_glb_cliente.glb_cliente_razaosocial%type,
                               vLocalRem         tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                               vDestinatario     tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                               vTpDestinatario   tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                               vNomeDestinatario tdvadm.t_glb_cliente.glb_cliente_razaosocial%type,
                               vLocalDes         tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                               vPeso             number,
                               vPesoBal          number,
                               vValorMercadoria  number,
                               vTpCArga          tdvadm.t_fcf_tpcarga.fcf_tpcarga_codigo%type := '02',
                               vTpVeiculo        tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%type := '9  ',
                               vTpVeiculoGRID    tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%type := '0  ',
                               vTemQuimico       char(1) := 'N',
                               vEExpresso        char(1) := 'N',
                               vTransferencia    char(1) := 'N',
                               vTemCD            char(2) := 'FF', 
                               ValorCte          number,
                               ValorColeta       number,
                               vRota             tdvadm.t_glb_rota.glb_rota_codigo%type,
                               vArmazem          tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               vUsuario          tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                               vTagEmbalagens    varchar2(200),
                               vEmbNumero        tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                               vEmbFlag          tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                               vEmbSequencia     tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                               vArmColeta        tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                               vArmColetaCiclo   tdvadm.t_arm_coleta.arm_coleta_ciclo%type,
                               vOnu              tdvadm.t_glb_onu.glb_onu_codigo%type,
                               vOnuGRPEMB        tdvadm.t_glb_onu.glb_onu_grpemb%type,
                               vOnuDescricao     tdvadm.t_glb_onu.glb_onu_produto%type,
                               vCarregamento     tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                               vVeicDisp         tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                               vVeicDispSeq      tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                               vUFDestino        tdvadm.t_glb_estado.glb_estado_codigo%type,
                               vPesoCArreg       tdvadm.t_arm_carregamento.arm_carregamento_pesocobrado%type,
                               vPlaca            tdvadm.t_fcf_veiculodisp.car_veiculo_placa%type,
                               vConjunto         tdvadm.t_fcf_veiculodisp.frt_conjveiculo_codigo%type,
                               vPlacaMotorista   tdvadm.t_fcf_veiculodisp.car_carreteiro_cpfcodigo%type
                               
                              );

  Type TypeLstParametros is Table Of PKG_GLB_TESTEINTEGRADO.TpParametros Index By Binary_Integer;


 
  cTpLotacao    Constant char(2) := '01';
  cTpFracionado Constant char(2) := '02';

  cCarreta    Constant char(3) := '1  ';
  cTruck      Constant char(3) := '3  ';
  c3_4        Constant char(3) := '7  ';
  cUtilitario Constant char(3) := '22 ';
  cFracionado Constant char(3) := '9  ';
  cToco       Constant char(3) := '4  ';
  cVAN        Constant char(3) := '8  ';
  cCarro      Constant char(3) := '23 ';
  
  cArmazemSP constant char(1) := '0';
  cArmazemRJ constant char(1) := '1';
  cArmazemMG constant char(1) := '2';
  cArmazemES constant char(1) := '3';
  cArmazemMA constant char(1) := '4';
  cArmazemPA constant char(1) := '5';
  cArmazemBA constant char(1) := '6';
  cArmazemPR constant char(1) := '7';

  cSaoPaulo      constant char(1) := 'A'; -- 01000 - SP
  cRiodeJaneiro  constant char(1) := 'B'; -- 20000 - RJ
  cContagem      constant char(1) := 'C'; -- 32000 - MG
  cBeloHorizonte constant char(1) := 'D'; -- 30000 - MG
  cParauapebas   constant char(1) := 'E'; -- 68515 - PA
  cSalobo        constant char(1) := 'F'; -- 68517 - PA
  cDivinopolis   constant char(1) := 'G'; -- 35500 - MG
  cVitoria       constant char(1) := 'I'; -- 29000 - ES
  cPiracicaba    constant char(1) := 'J'; -- 13400 - SP
  cGuarulhos     constant char(1) := 'K'; -- 07000 - SP
  cItapetininga  constant char(1) := 'L'; -- 18200 - SP
  cAraraquara    constant char(1) := 'M'; -- 14800 - SP
  cCuritiba      constant char(1) := 'N'; -- 80000 - PR
  cDiadema       constant char(1) := 'O'; -- 09900 - SP
  
  cFornec01      constant char(20) := '00000000000001'; 
  cFornec02      constant char(20) := '00000000000002'; 
  cFornec03      constant char(20) := '00000000000003'; 
  cFornec04      constant char(20) := '00000000000004'; 
  cFornec05      constant char(20) := '00000000000005'; 
  cFornec06      constant char(20) := '00000000000006'; 
  cFornec07      constant char(20) := '00000000000007'; 
  cFornec08      constant char(20) := '00000000000008'; 
  cFornec09      constant char(20) := '00000000000009'; 
  cFornec10      constant char(20) := '00000000000010'; 
  cFornec11      constant char(20) := '00000000000011'; 
  cFornec12      constant char(20) := '00000000000012'; 
  cFornec13      constant char(20) := '00000000000013'; 
  cFornec14      constant char(20) := '00000000000014'; 
  cFornec15      constant char(20) := '00000000000015'; 
  cFornec16      constant char(20) := '00000000000016'; 
  cFornec17      constant char(20) := '00000000000017'; 
  cFornec18      constant char(20) := '00000000000018'; 
  cFornec19      constant char(20) := '00000000000019'; 
  cFornec20      constant char(20) := '00000000000020'; 
 


Procedure sp_soparadebug;

Function fn_TrocaNota(pXml in varchar2,
                      LstParametros in PKG_GLB_TESTEINTEGRADO.TpParametros) return varchar2;

Procedure sp_LimpaTestesCarreg(pNota in tdvadm.t_arm_nota.arm_nota_numero%type,
                               pApagaCTe in char default 'S',
                               pApagaVF  in Char default 'S');

Procedure sp_CriaFornecedore(pRecria char default 'N');

Procedure sp_CriaNotas(pLstParametros in Out  TypeLstParametros,
                       pStatus        out Char,
                       pMessage       out varchar2);

Procedure sp_ArrumaColeta(pLstParametros in Out  TypeLstParametros,
                          pStatus        out Char,
                          pMessage       out varchar2);

Procedure sp_CriaCarregamento(pLstParametros in Out  TypeLstParametros,
                              pStatus        out Char,
                              pMessage       out varchar2);
                            
Procedure sp_ValidaValores(pLstParametros in Out  TypeLstParametros,
                           pStatus        out Char,
                           pMessage       out varchar2);
                       
Procedure sp_criaTesteCarreg(p_carregamento in tdvadm.t_Arm_Carregamento.arm_carregamento_codigo%type,
                             p_codigoTeste  out number);

 

/*
BEGIN
   BLOCO DE INSTRUCOES
EXCEPTION
  WHEN DUP_VAL_ON_INDEX  THEN       -- ORA-00001   You attempted to create a duplicate value in a field restricted by a unique index.
  WHEN TIMEOUT_ON_RESOURCE  THEN    -- ORA-00051 	A resource timed out, took too long.
  WHEN TRANSACTION_BACKED_OUT  THEN -- ORA-00061 	The remote portion of a transaction has rolled back.
  WHEN INVALID_CURSOR  THEN         -- ORA-01001 	The cursor does not yet exist. The cursor must be OPENed before any FETCH cursor or CLOSE cursor operation.
  WHEN NOT_LOGGED_ON  THEN          -- ORA-01012 	You are not logged on.
  WHEN LOGIN_DENIED  THEN           -- ORA-01017 	Invalid username/password.
  WHEN NO_DATA_FOUND  THEN          -- ORA-01403 	No data was returned
  WHEN TOO_MANY_ROWS  THEN          -- ORA-01422 	You tried to execute a SELECT INTO statement and more than one row was returned.
  WHEN ZERO_DIVIDE  THEN            -- ORA-01476 	Divide by zero error.
  WHEN INVALID_NUMBER  THEN         -- ORA-01722 	Converting a string to a number was unsuccessful.
  WHEN STORAGE_ERROR  THEN          -- ORA-06500 	Out of memory.
  WHEN PROGRAM_ERROR  THEN          -- ORA-06501 	
  WHEN VALUE_ERROR  THEN            -- ORA-06502 	You tried to perform an operation and there was a error on a conversion, truncation, or invalid constraining of numeric or character data.
  WHEN ROWTYPE_MISMATCH  THEN       -- ORA-06504 	 
  WHEN CURSOR_ALREADY_OPEN  THEN    -- ORA-06511 	The cursor is already open.
  WHEN ACCESS_INTO_NULL  THEN       -- ORA-06530 	 
  WHEN COLLECTION_IS_NULL  THEN     -- ORA-06531    
  WHEN OTHERS THEN
END;

*/

                                    

END PKG_GLB_TESTEINTEGRADO;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_GLB_TESTEINTEGRADO AS



Procedure sp_soparadebug
  as 
    i number;
  Begin
    i := i;
  End sp_soparadebug;

Function fn_TrocaNota(pXml in varchar2,
                      LstParametros in PKG_GLB_TESTEINTEGRADO.TpParametros) return varchar2
  As
    vXml varchar2(32000);
    vLocalOrigem  tdvadm.t_arm_nota.glb_localidade_codigoorigem%type;
    vLocalDestino tdvadm.t_arm_nota.glb_localidade_codigoorigem%type;
  
  Begin
    dbms_output.put_line('Entrando fn_TrocaNota');
    
   vXml := pXml; 
   vXml := Replace(vXml,'#vColeta#',          trim(LstParametros.vArmColeta)) ;
   vXml := Replace(vXml,'#vColetaEntrega#',   trim(LstParametros.vColetaEntrega)) ;
   vXml := Replace(vXml,'#vCriaColeta#',      trim(LstParametros.vCriaColeta)) ;
   vXml := Replace(vXml,'#vTpNota#',          trim(LstParametros.vTpNota)) ;
   vXml := Replace(vXml,'#vNotaChave#',       trim(LstParametros.vNotaChave)) ;
   vXml := Replace(vXml,'#vNumeroNota#',      trim(to_char(LstParametros.vNumeroNota))) ;
   vXml := Replace(vXml,'#vRota#',            trim(LstParametros.vRota)) ;
   vXml := Replace(vXml,'#vArmazem#',         trim(LstParametros.vArmazem)) ;
   vXml := Replace(vXml,'#vUsuario#',         trim(LstParametros.vUsuario)) ;
   vXml := Replace(vXml,'#vMercadoria#',      trim(LstParametros.vMercadoria)) ;
   vXml := Replace(vXml,'#vContrato#',        trim(LstParametros.vContrato)) ;
   vXml := Replace(vXml,'#vTabSol#',          trim(LstParametros.vTabSol)) ;
   vXml := Replace(vXml,'#vNumTabSol#',       trim(LstParametros.vNumTabSol)) ;
   vXml := Replace(vXml,'#vNumSQTabSol#',     trim(LstParametros.vNumSQTabSol)) ;
   vXml := Replace(vXml,'#vDtEmissao#',       trim(to_char(LstParametros.vDtEmissao,'dd/mm/yyyy'))) ;
   vXml := Replace(vXml,'#vDtSaida#',         trim(to_char(LstParametros.vDtSaida,'dd/mm/yyyy'))) ;
   vXml := Replace(vXml,'#vFlagPagador#',     trim(LstParametros.vFlagPagador)) ;
   vXml := Replace(vXml,'#vSacado#',          trim(LstParametros.vSacado)) ;
   vXml := Replace(vXml,'#vRemetente#',       trim(LstParametros.vRemetente)) ;
   vXml := Replace(vXml,'#vTpRemetente#',     trim(LstParametros.vTpRemetente)) ;
   vXml := Replace(vXml,'#vNomeRemetente#',   trim(LstParametros.vNomeRemetente)) ;
   vXml := Replace(vXml,'#vDestinatario#',    trim(LstParametros.vDestinatario)) ;
   vXml := Replace(vXml,'#vTpDestinatario#',  trim(LstParametros.vTpDestinatario)) ;
   vXml := Replace(vXml,'#vNomeDestinatario#',trim(LstParametros.vNomeDestinatario)) ;
   vXml := Replace(vXml,'#vPeso#',            trim(to_char(LstParametros.vPeso))) ;
   vXml := Replace(vXml,'#vPesoBal#',         trim(to_char(LstParametros.vPesoBal))) ;
   vXml := Replace(vXml,'#vValorMercadoria#', trim(to_char(LstParametros.vValorMercadoria))) ;
   
   if LstParametros.vTemQuimico = 'S' Then
      vXml := Replace(vXml,'#vOnu#',             trim(LstParametros.vOnu)) ;
      vXml := Replace(vXml,'#vOnuGRPEMB#',       trim(LstParametros.vOnuGRPEMB)) ;
      vXml := Replace(vXml,'#vOnuDescricao#',    trim(LstParametros.vOnuDescricao)) ;
   Else
      vXml := Replace(vXml,'#vOnu#',         '9999' ) ;
      vXml := Replace(vXml,'#vOnuGRPEMB#',   'SE' ) ;
   End If;   
   vXml := Replace(vXml,'#vTemCD#',           trim(LstParametros.vTemCD)) ;
   
   -- Paga Localidade de Origem para completar
      select ce.glb_localidade_codigo
        into vLocalOrigem
      from t_glb_cliend ce
      where ce.glb_cliente_cgccpfcodigo = LstParametros.vRemetente
        and ce.glb_tpcliend_codigo = LstParametros.vTpRemetente;

      select ce.glb_localidade_codigo
        into vLocalDestino
      from t_glb_cliend ce
      where ce.glb_cliente_cgccpfcodigo = LstParametros.vDestinatario
        and ce.glb_tpcliend_codigo = LstParametros.vTpDestinatario;

   vXml := Replace(vXml,'#vLocalOrigem#',           trim(vLocalOrigem)) ;
   vXml := Replace(vXml,'#vLocalDestino#',           trim(vLocalDestino)) ;
   
   
   
   Return vXml; 
   
  End ;

Procedure sp_LimpaTestesCarreg(pNota in tdvadm.t_arm_nota.arm_nota_numero%type,
                               pApagaCTe in char default 'S',
                               pApagaVF  in Char default 'S')
  As  
    vEmbalagem tdvadm.t_arm_embalagem.arm_embalagem_numero%type;
    vEmbFlag   tdvadm.t_arm_embalagem.arm_embalagem_flag%type;
    vEmbSeq    tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type;
    vCarreg    tdvadm.t_arm_embalagem.arm_carga_codigo%type;
    vCarregamento tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
    i integer;
    i2 integer;
    vListaCarreg glbadm.pkg_listas.tListaCarregamento;
    tpUsuario    tdvadm.t_usu_usuario%rowtype;
    vVeicDisp    tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
    vVeicDispSeq tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
    vErrg        varchar2(2000);
 Begin
    dbms_output.put_line('Entrando sp_LimpaTestesCarreg');
     -- Crifica se ja existe o usuario testesql, se nao ciar o mesmo
     select count(*)
       into i
     from tdvadm.t_usu_usuario u
     where u.usu_usuario_codigo = 'testeplsql';
     If i = 0 then
        tpUsuario.Usu_Usuario_Codigo := 'testeplsql';
        tpUsuario.Glb_Rota_Codigo := '011';
        tpUsuario.Usu_Usuario_Nome := 'Teste Integrado PLSQL';
        tpUsuario.Usu_Usuario_Crip := 'N';
        tpUsuario.Usu_Usuario_Senhaexpira := 'N';
        tpUsuario.Usu_Usuario_Cpf := '00000000000';
        tpUsuario.Usu_Usuario_Senha := 'testeplsql';
        insert into tdvadm.t_usu_usuario values tpUsuario;
     End If;
     i  := 1;
     i2 := 1;
     
     Loop
        for c_msg in (select n.arm_embalagem_numero,
                             n.arm_embalagem_flag,
                             n.arm_embalagem_sequencia,
                             n.arm_carga_codigo, 
                             n.arm_carregamento_codigo,
                             n.arm_nota_sequencia,
                             n.con_conhecimento_codigo,
                             n.con_conhecimento_serie,
                             n.glb_rota_codigo,
                             n.arm_coleta_ncompra,
                             n.arm_coleta_ciclo
                      from tdvadm.t_arm_nota n
                      where trim(n.usu_usuario_codigo) IN ('testeplsql')
                        and n.arm_nota_numero = decode(nvl(pNota,'000000000'),'000000000',n.arm_nota_numero,pNota))
        Loop
          
            
            
            delete T_ARM_CARGADET ca
            where ca.arm_carga_codigo = c_msg.arm_carga_codigo;
            
            delete t_arm_carregamentodet cd   
            where cd.arm_embalagem_numero = c_msg.arm_embalagem_numero
              and cd.arm_embalagem_flag = c_msg.arm_embalagem_flag
              and cd.arm_embalagem_sequencia = c_msg.arm_embalagem_sequencia
              and cd.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;

            delete tdvadm.t_arm_notapesagemitem p
            where p.arm_nota_sequencia = c_msg.arm_nota_sequencia;  

            delete tdvadm.t_arm_notapesagem p
            where p.arm_nota_sequencia = c_msg.arm_nota_sequencia;  
            
            update tdvadm.t_arm_janelacons c
               set c.arm_janelacons_qtdectenfs = 0
            where c.arm_janelacons_sequencia = (select n.arm_janelacons_sequencia 
                                                from tdvadm.t_arm_nota n 
                                                where n.arm_nota_sequencia = c_msg.arm_nota_sequencia);
            
            delete tdvadm.t_arm_notacte nc
            where nc.arm_nota_sequencia = c_msg.arm_nota_sequencia;  
            
            delete tdvadm.T_ARM_PRESENCARGANF x
            where x.arm_nota_sequencia = c_msg.arm_nota_sequencia;  
            
            delete tdvadm.t_arm_nota n
            where n.arm_nota_sequencia = c_msg.arm_nota_sequencia;  
            
            update tdvadm.t_arm_coleta co
              set co.arm_coletaocor_codigo = null
            where co.arm_coleta_ncompra = c_msg.arm_coleta_ncompra
              and co.Arm_Coleta_Ciclo = c_msg.arm_coleta_ciclo;
            
            delete tdvadm.t_arm_embalagem eb
            where eb.arm_embalagem_numero = c_msg.arm_embalagem_numero
              and eb.arm_embalagem_flag = c_msg.arm_embalagem_flag
              and eb.arm_embalagem_sequencia = c_msg.arm_embalagem_sequencia;


            delete tdvadm.t_arm_carga ca
            where ca.arm_carga_codigo = c_msg.arm_carga_codigo;
              
            begin
                select c.fcf_veiculodisp_codigo,
                       c.fcf_veiculodisp_sequencia 
                  into vVeicDisp,
                       vVeicDispSeq
                from tdvadm.t_arm_carregamento c
                where c.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;
                
                delete tdvadm.t_fcf_solveicorig d
                where d.fcf_solveic_cod in (select sv.fcf_solveic_cod
                                            from tdvadm.t_fcf_solveic sv
                                            where sv.fcf_veiculodisp_codigo = vVeicDisp
                                              and sv.fcf_veiculodisp_sequencia = vVeicDispSeq);
                
                DELETE TDVADM.T_FCF_VEICULODISPDEST SV
                where sv.fcf_veiculodisp_codigo = vVeicDisp
                  and sv.fcf_veiculodisp_sequencia = vVeicDispSeq;
                
                delete tdvadm.t_fcf_solveicdest d
                where d.fcf_solveic_cod in (select sv.fcf_solveic_cod
                                            from tdvadm.t_fcf_solveic sv
                                            where sv.fcf_veiculodisp_codigo = vVeicDisp
                                              and sv.fcf_veiculodisp_sequencia = vVeicDispSeq);

                delete tdvadm.t_fcf_solveic sv
                where sv.fcf_veiculodisp_codigo = vVeicDisp
                  and sv.fcf_veiculodisp_sequencia = vVeicDispSeq;
                
                 
                update tdvadm.t_arm_carregamento ca
                  set ca.fcf_veiculodisp_codigo = null,
                      ca.fcf_veiculodisp_sequencia = null
                where ca.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;
                
                delete tdvadm.t_fcf_veiculodisp v
                where v.fcf_veiculodisp_codigo = vVeicDisp;
                    
            End;
             
            begin
               
               delete  T_ARM_CARREGSTATUS c             
               where c.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;
               
               delete t_arm_carregamento_hist c
               where c.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;
               
               update t_arm_carregamento c
                 set c.fcf_veiculodisp_codigo = null,
                     c.fcf_veiculodisp_sequencia = null
               where c.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;
               
               delete t_fcf_veiculodisp vd
               where vd.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;

               update tdvadm.t_con_conhecimento c
                 set c.arm_carregamento_codigo = null
               where c.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;
                
               delete t_arm_carregamentodet c
               where c.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;

               delete t_arm_carregamento c
               where c.arm_carregamento_codigo = c_msg.arm_carregamento_codigo;

            Exception
              When OTHERS Then
                  vListaCarreg(i2).arm_carregamento_codigo := c_msg.arm_carregamento_codigo;
                  i2 := i2 + 1;
                  vErrg := sqlerrm;
                
              End ;
              
              if pApagaCTe = 'S' Then
                 sp_limpa_conhec(c_msg.con_conhecimento_codigo,c_msg.glb_rota_codigo,c_msg.con_conhecimento_serie);
              End If;
              If pApagaVF = 'S' Then
                
                for c_msg2 in (select distinct vfc.con_valefrete_codigo,
                                               vfc.con_valefrete_serie,
                                               vfc.glb_rota_codigovalefrete,
                                               vfc.con_valefrete_saque
                               from tdvadm.t_con_vfreteconhec vfc
                               where vfc.con_conhecimento_codigo = c_msg.con_conhecimento_codigo
                                 and vfc.con_conhecimento_serie  = c_msg.con_conhecimento_serie
                                 and vfc.glb_rota_codigo         = c_msg.glb_rota_codigo)
                 Loop
                 
                    UPDATE T_FCF_VEICULODISP VD
                       SET VD.FCF_VEICULODISP_FLAGVALEFRETE = null
                    WHERE VD.FCF_VEICULODISP_CODIGO    = vVeicDisp
                      AND VD.FCF_VEICULODISP_SEQUENCIA = vVeicDispSeq;  
                    
                    dbms_output.put_line('Limpando Veiculo Disp ' || sql%rowcount);
                
                    delete tdvadm.t_con_vfreteentrega v
                    where v.con_conhecimento_codigo = c_msg2.con_valefrete_codigo
                      and v.con_conhecimento_serie  = c_msg2.con_valefrete_serie
                      and v.glb_rota_codigo         = c_msg2.glb_rota_codigovalefrete
                      and v.con_valefrete_saque     = c_msg2.con_valefrete_saque;

                    delete tdvadm.t_con_vfreteconhec v
                    where v.con_valefrete_codigo     = c_msg2.con_valefrete_codigo
                      and v.con_valefrete_serie      = c_msg2.con_valefrete_serie
                      and v.glb_rota_codigovalefrete = c_msg2.glb_rota_codigovalefrete
                      and v.con_valefrete_saque      = c_msg2.con_valefrete_saque;

                    dbms_output.put_line('deletando VfreteConhec ' || sql%rowcount);

                    delete tdvadm.t_con_calcvalefrete v
                    where v.con_conhecimento_codigo = c_msg2.con_valefrete_codigo
                      and v.con_conhecimento_serie  = c_msg2.con_valefrete_serie
                      and v.glb_rota_codigo         = c_msg2.glb_rota_codigovalefrete
                      and v.con_valefrete_saque     = c_msg2.con_valefrete_saque;

                    dbms_output.put_line('deletando CalcValeFrete ' || sql%rowcount);

                    delete tdvadm.t_con_valefrete v
                    where v.con_conhecimento_codigo = c_msg2.con_valefrete_codigo
                      and v.con_conhecimento_serie  = c_msg2.con_valefrete_serie
                      and v.glb_rota_codigo         = c_msg2.glb_rota_codigovalefrete
                      and v.con_valefrete_saque     = c_msg2.con_valefrete_saque;
                    dbms_output.put_line('deletando ValeFrete ' || sql%rowcount);
                 End Loop;
              End If;
              
              
              
            
        End Loop;
        i := i + 1;
        i := 20;
        exit When i = 20;
        
     End Loop;     
     
     if i2 > 1 Then
        i := 1;
        loop   
           Begin
               delete  T_ARM_CARREGSTATUS c             
               where c.arm_carregamento_codigo = vListaCarreg(i).arm_carregamento_codigo;
               delete t_arm_carregamento_hist c
               where c.arm_carregamento_codigo = vListaCarreg(i).arm_carregamento_codigo;
               update t_arm_carregamento c
                 set c.fcf_veiculodisp_codigo = null,
                     c.fcf_veiculodisp_sequencia = null
               where c.arm_carregamento_codigo = vListaCarreg(i).arm_carregamento_codigo;
               delete t_fcf_veiculodisp vd
               where vd.arm_carregamento_codigo = vListaCarreg(i).arm_carregamento_codigo;
               delete t_arm_carregamento c
               where c.arm_carregamento_codigo = vListaCarreg(i).arm_carregamento_codigo;
           exception
             When OTHERS Then
                i := i;
             End;
           exit When i = i2;
           i := i + 1;
        End Loop;
     End If;           

     delete tdvadm.t_arm_janelacons jc
     where 0 = (select count(*) from tdvadm.t_arm_nota an where an.arm_janelacons_sequencia = jc.arm_janelacons_sequencia);        
    
  End sp_LimpaTestesCarreg;

Procedure sp_CriaFornecedore(pRecria char default 'N')
  As
   i number;
   vAuxiliar number;
   tpCliente  tdvadm.t_glb_cliente%rowtype;
   tpCliend   tdvadm.t_glb_cliend%rowtype;
  Begin

    dbms_output.put_line('Entrando sp_CriaFornecedore');
    
--    sp_LimpaTestesCarreg;
    i := 1;
    tpCliente.Glb_Cliente_Nacional         := 'N'; 
    tpCliente.Glb_Vendfrete_Codigo         := null;
    tpCliente.Glb_Cliente_Tppessoa         := 'J'; 
    tpCliente.Glb_Cliente_Im               := null;
    tpCliente.Glb_Rota_Codigo              := '021';
    tpCliente.Glb_Cliente_Situacao         := 'A';
    tpCliente.Glb_Cliente_Qtdtitvenc       := 0;
    tpCliente.Glb_Cliente_Vltotvenc        := 0;
    tpCliente.Glb_Cliente_Prazomedvenc     := 0;
    tpCliente.Glb_Cliente_Prazomedpagto    := 0;
    tpCliente.Glb_Cliente_Dtutlmov         := null;
    tpCliente.Glb_Cliente_Dtcadastro       := sysdate;  
    tpCliente.Glb_Cliente_Obs              := 'Cliente Criado para Teste';
    tpCliente.Glb_Cliente_Opercad          := null;
    tpCliente.Glb_Cliente_Operalt          := null;
    tpCliente.Glb_Cliente_Tpboleto         := null;
    tpCliente.Crp_Tpcarteria_Codigo        := null;
    tpCliente.Glb_Cliente_Diaatrazo        := null;
    tpCliente.Glb_Cliente_Classsac         := null;
    tpCliente.Glb_Cliente_Nfnafatura       := 'S'; 
    tpCliente.Glb_Banco_Numero             := '237';
    tpCliente.Glb_Cliente_Controlanf       := 'S';
    tpCliente.Glb_Cliente_Tiporateio       := 'V';
    tpCliente.Glb_Cliente_Descinss         := 'N';
    tpCliente.Glb_Ramoatividade_Codigo     := '99';
    tpCliente.Glb_Cliente_Ieisento         := 'N';
    tpCliente.Glb_Cliente_Dtultmovsac      := null;
    tpCliente.Glb_Cliente_Dtultmovrem      := null;
    tpCliente.Glb_Cliente_Dtultmovdest     := null;
    tpCliente.Glb_Cliente_Tribisento       := 'N';
    tpCliente.Glb_Cliente_Regimeespvp      := null;
    tpCliente.Glb_Cliente_Dtalteracao      := SYSDATE;
    tpCliente.Glb_Cliente_Agrupasepara     := 'N';
    tpCliente.Glb_Grupoeconomico_Codigoseg := '9999';
    tpCliente.Glb_Grupoeconomico_Codigo    := '9999';
    tpCliente.Glb_Cliente_Tipodesconto     := null;
    tpCliente.Glb_Cliente_Percdesconto     := null;
    tpCliente.Glb_Grupoeconomico_Codigoctb := '9999';
    tpCliente.Glb_Cliente_Emailcontrole    := null;
    tpCliente.Arm_Armazem_Codigo           := null;
    tpCliente.Glb_Cliente_Ctrcimg          := 'N';
    tpCliente.Glb_Cliente_Notaimg          := 'N';
    tpCliente.Glb_Cliente_Vlrlimite        := 500000;
    tpCliente.Glb_Cliente_Estiva           := 'N';
    tpCliente.Glb_Cliente_Cnae             := null;
    tpCliente.Glb_Cliente_Higienizado      := sysdate; 
    tpCliente.Glb_Cliente_Exigecomprovante := 'N';
    tpCliente.Glb_Cliente_Issret           := 'N'; 
    tpCliente.Glb_Cliente_Fechacoleta      := 'C';
    tpCliente.Glb_Cliente_Vigencia         := null;
    tpCliente.Glb_Cliente_Flagverificaend  := 'S';
    tpCliente.Glb_Cliente_Estadia          := 'N';
    tpCliente.Glb_Cliente_Colreqaut        := 'N';
    -- Cria 20 Cliente " Fornecedore "
    loop
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIENTE CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20);
       
       if vAuxiliar = 1 and nvl(pRecria,'N') = 'S' Then
          delete t_glb_cliend ce
          where ce.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20);
          delete t_glb_clicont cc
          where cc.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20);
          delete t_glb_clienteseg cs
          where cs.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20);
          delete t_glb_cliente cl
          where cl.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20);
          vAuxiliar := 0;
       End If;
           
       if vAuxiliar = 0 Then
       
          tpCliente.Glb_Cliente_Cgccpfcodigo     := lpad(i,14,'0');
          tpCliente.Glb_Cliente_Razaosocial      := 'Fornecedor ' || to_char(i) || ' Teste';
          tpCliente.Glb_Cliente_Ie               := lpad(i,11,'0');

          insert into t_glb_cliente values tpCliente;
       End If;
       exit when i = 20;
       i := i + 1;
    End Loop;
    
    -- Cria o Tipo de Endereço Defaul
    i := 1;
    tpCliend.Glb_Cliend_Endereco      := null;
    tpCliend.Glb_Cliend_Complemento   := null;
    tpCliend.Glb_Cep_Codigo           := null;
    tpCliend.Arm_Regiao_Codigo        := null;
    tpCliend.Arm_Regiao_Metropolitana := null;
    tpCliend.Arm_Subregiao_Codigo     := null;
    tpCliend.Xml_Cep_Cvrd             := 'X';
    tpCliend.Glb_Cliend_Email         := null;
    tpCliend.Glb_Cliend_Latitude      := null;
    tpCliend.Glb_Cliend_Longitude     := null;
    tpCliend.Glb_Cliend_Logo          := null;
    tpCliend.Glb_Portaria_Id          := null;
    tpCliend.Glb_Cliend_Im            := null;
    tpCliend.Glb_Cliend_Higienizado   := null;
    tpCliend.Usu_Usuario_Criou        := 'testeplsql';
    tpCliend.Usu_Usuario_Alterou      := 'testeplsql';
    tpCliend.Glb_Cliend_Dtcriacao     := sysdate;
    tpCliend.Glb_Cliend_Dtalteracao   := null;
    tpCliend.Glb_Cliend_Numero        := null;
    tpCliend.Glb_Cliente_Cnpjaux      := null;
    loop
    
       if vAuxiliar > 0 AND nvl( pRecria,'N') = 'S'  Then
          Delete T_GLB_CLIEND CL where CL.GLB_CLIENTE_CGCCPFCODIGO = lpad(i,14,'0');
       End If;

       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cSaoPaulo;
       If vAuxiliar = 0 Then              
--  cSaoPaulo      constant char(1) := 'A'; -- 01000 - SP
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cSaoPaulo;
       tpCliend.Glb_Localidade_Codigo    := '01000';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'SP';
       tpCliend.Glb_Cliend_Cidade        := 'SAO PAULO';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '01000';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cRiodeJaneiro;
       iF vAuxiliar = 0 Then
--  cRiodeJaneiro  constant char(1) := 'B'; -- 20000 - RJ
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cRiodeJaneiro;
       tpCliend.Glb_Localidade_Codigo    := '20000';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'RJ';
       tpCliend.Glb_Cliend_Cidade        := 'RIO DE JANEIRO';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '20000';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cContagem;
       iF vAuxiliar = 0 Then
--  cContagem      constant char(1) := 'C'; -- 32000 - MG
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cContagem;
       tpCliend.Glb_Localidade_Codigo    := '32000';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'MG';
       tpCliend.Glb_Cliend_Cidade        := 'CONTAGEM';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '32000';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cBeloHorizonte;
       iF vAuxiliar = 0 Then
--  cBeloHorizonte constant char(1) := 'D'; -- 30000 - MG
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cBeloHorizonte;
       tpCliend.Glb_Localidade_Codigo    := '30000';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'MG';
       tpCliend.Glb_Cliend_Cidade        := 'BELO HORIZONTE';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '30000';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cParauapebas;
       iF vAuxiliar = 0 Then
--  cParauapebas   constant char(1) := 'E'; -- 68515 - PA
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cParauapebas;
       tpCliend.Glb_Localidade_Codigo    := '68515';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'PA';
       tpCliend.Glb_Cliend_Cidade        := 'PARAUAPEBAS';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '68515';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cSalobo;
       iF vAuxiliar = 0 Then
--  cSalobo        constant char(1) := 'F'; -- 68517 - PA
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cSalobo;
       tpCliend.Glb_Localidade_Codigo    := '68517';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'PA';
       tpCliend.Glb_Cliend_Cidade        := 'SALOBO';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '68517';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cDivinopolis;
       iF vAuxiliar = 0 Then
--  cDivinopolis   constant char(1) := 'G'; -- 35500 - MG
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cDivinopolis;
       tpCliend.Glb_Localidade_Codigo    := '35500';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'MG';
       tpCliend.Glb_Cliend_Cidade        := 'DIVINOPOLIS';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '35500';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cVitoria;
       iF vAuxiliar = 0 Then
--  cVitoria       constant char(1) := 'I'; -- 29000 - ES
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cVitoria;
       tpCliend.Glb_Localidade_Codigo    := '29000';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'ES';
       tpCliend.Glb_Cliend_Cidade        := 'VITORIA';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '29000';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cPiracicaba;
       iF vAuxiliar = 0 Then
--  cPiracicaba    constant char(1) := 'J'; -- 13400 - SP
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cPiracicaba;
       tpCliend.Glb_Localidade_Codigo    := '13400';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'SP';
       tpCliend.Glb_Cliend_Cidade        := 'PIRACICABA';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '13400';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cGuarulhos;
       iF vAuxiliar = 0 Then
--  cGuarulhos     constant char(1) := 'K'; -- 07000 - SP
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cGuarulhos;
       tpCliend.Glb_Localidade_Codigo    := '07000';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'SP';
       tpCliend.Glb_Cliend_Cidade        := 'GUARULHOS';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '07000';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cItapetininga;
       iF vAuxiliar = 0 Then
--  cItapetininga  constant char(1) := 'L'; -- 18200 - SP
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cItapetininga;
       tpCliend.Glb_Localidade_Codigo    := '18200';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'SP';
       tpCliend.Glb_Cliend_Cidade        := 'ITAPETININGA';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '18200';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cAraraquara;
       iF vAuxiliar = 0 Then
--  cAraraquara    constant char(1) := 'M'; -- 14800 - SP
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cAraraquara;
       tpCliend.Glb_Localidade_Codigo    := '14800';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'SP';
       tpCliend.Glb_Cliend_Cidade        := 'ARARAQUARA';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '14800';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cCuritiba;
       iF vAuxiliar = 0 Then
--  cCuritiba      constant char(1) := 'N'; -- 80000 - PR
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cCuritiba;
       tpCliend.Glb_Localidade_Codigo    := '80000';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'PR';
       tpCliend.Glb_Cliend_Cidade        := 'CURITIBA';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '80000';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If; 
       SELECT COUNT(*)
         into vAuxiliar
       FROM T_GLB_CLIEND CL
       WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(lpad(i,14,'0'),20)
         AND CL.GLB_TPCLIEND_CODIGO = cDiadema;
       iF vAuxiliar = 0 Then
--  cDiadema       constant char(1) := 'O'; -- 09900 - SP
       tpCliend.Glb_Cliente_Cgccpfcodigo := lpad(i,14,'0');
       tpCliend.Glb_Tpcliend_Codigo      := cDiadema;
       tpCliend.Glb_Localidade_Codigo    := '09900';
       tpCliend.Glb_Pais_Codigo          := 'BRA';
       tpCliend.Glb_Estado_Codigo        := 'SP';
       tpCliend.Glb_Cliend_Cidade        := 'DIADENA';
       tpCliend.Glb_Cliend_Codcliente    := null;
       tpCliend.Glb_Localidade_Codigoie  := '09900';
       tpCliend.Glb_Cliend_Ie            := lpad(i,11,'0');
       insert into t_glb_cliend values tpCliend;
       End If;

       
       exit when i = 20;
       i := i + 1;
   End Loop;           

     
  End sp_CriaFornecedore;

Procedure sp_CriaNotas(pLstParametros in Out  TypeLstParametros,
                       pStatus        out Char,
                       pMessage       out varchar2)
  As
     vAuxiliar integer;
     i integer;
     vvparamssaida   clob;
     vSeqNota        tdvadm.t_arm_nota.arm_nota_sequencia%type;
  Begin
    dbms_output.put_line('Entrando sp_CriaNota');
    pStatus := pkg_glb_testeintegrado.STATUS_NORMAL;
    pMessage := '';
    i := 1;
    
   loop 
     Begin
       if Not pLstParametros(i).vNumeroNota = 0 Then
          -- Copia os paramentros para os outro itens
          pLstParametros(i).vRota    := pLstParametros(i).vRota;
          pLstParametros(i).vUsuario := pLstParametros(i).vUsuario;
          pLstParametros(i).vArmazem := pLstParametros(i).vArmazem;
          vAuxiliar := i;
       End If;
     Exception
       When NO_DATA_FOUND Then
          exit;
       End;
   
       Begin
         select cl.glb_cliente_razaosocial
           into pLstParametros(i).vNomeRemetente   
         from t_glb_cliente cl
         where  cl.glb_cliente_cgccpfcodigo = pLstParametros(i).vRemetente; 
       exception
         When NO_DATA_FOUND Then
             pLstParametros(i).vNomeRemetente := '';
         End ;

       Begin
         select cl.glb_cliente_razaosocial
           into pLstParametros(i).vNomeDestinatario   
         from t_glb_cliente cl
         where  cl.glb_cliente_cgccpfcodigo = pLstParametros(i).vDestinatario; 
       exception
         When NO_DATA_FOUND Then
             pLstParametros(i).vNomeDestinatario := '';
         End ;

       pLstParametros(i).vXml := PKG_GLB_TESTEINTEGRADO.vXmlModeloNota;
       pLstParametros(i).vXml := PKG_GLB_TESTEINTEGRADO.fn_TrocaNota(pLstParametros(i).vXml,pLstParametros(i));
         
--       insert into t_glb_sql values (pLstParametros(i).vXml,sysdate,'TESTE','TESTE');
--       commit;


      pkg_fifo_recebimento.sp_insertnota(pLstParametros(i).vXml,
                                         pStatus,
                                         pMessage,
                                         vvparamssaida);

       If pStatus = 'N' Then
          select n.arm_nota_sequencia
             into vSeqNota
          from tdvadm.t_arm_nota n
          where n.arm_nota_numero = pLstParametros(i).vNumeroNota
            and n.glb_cliente_cgccpfremetente = trim(pLstParametros(i).vRemetente)
            and n.glb_cliente_cgccpfsacado = trim(pLstParametros(i).vSacado)
          ;

          update tdvadm.t_arm_nota an
            set an.arm_nota_dtetiqueta = sysdate
          where an.arm_nota_sequencia = vSeqNota;
          
          tdvadm.pkg_fifo_recebimento.SP_INSERT_NOTA_SEM_PESAGEM(vSeqNota,
                                                                 pLstParametros(i).vUsuario,
                                                                 'TESTE CRIACAO',
                                                                 pStatus,
                                                                 pMessage);
/*          tdvadm.PKG_ARM_NOTAPESAGEM.Sp_Update_FinalizaNotaPesagem2(pLstParametros(i).vUsuario,
                                                                    pLstParametros(i).vNumeroNota,
                                                                    pLstParametros(i).vRemetente,
                                                                    pLstParametros(i).vNotaChave,
                                                                    pLstParametros(i).vPesoBal,
                                                                    pStatus,
                                                                    pMessage);
*/

          If upper(trim(pMessage)) <> upper(trim('Nota Liberada não pode ser mais Pesada!')) Then
             pStatus := nvl(pStatus,'N');
          Else
             pStatus := 'N';
          End If;  
       
       End If;       


    --   :vstatus := trim(:vstatus);
        
       -- Se ocorreu tudo bam na criacao da Nota
       if pStatus <> 'N' Then
          dbms_output.put_line('Nota ' || pLstParametros(i).vNumeroNota || ' Remetente ' || pLstParametros(i).vRemetente || CHR(10) || pMessage );
          pStatus := 'E';
       End If;
       
       i := i + 1;
   End Loop;
  
  End sp_CriaNotas;

  Procedure sp_ArrumaColeta(pLstParametros in Out  TypeLstParametros,
                            pStatus        out Char,
                            pMessage       out varchar2)
    As
      i Integer;
      vAuxiliar  integer;
    Begin

    dbms_output.put_line('Entrando sp_ArrumaColeta');

     pStatus := 'N';
     pMessage := '';
     i := 1;  
     loop 
       Begin
         if Not pLstParametros(i).vNumeroNota = 0 Then
            vAuxiliar := i;
         End If;
       Exception
         When NO_DATA_FOUND Then
          exit;
         End;
       -- Verifica se nota e Coleta estão Criadas
         Begin
            select n.arm_embalagem_numero,
                   n.arm_embalagem_flag,
                   n.arm_embalagem_sequencia,
                   n.arm_coleta_ncompra,
                   n.arm_coleta_ciclo
              into pLstParametros(i).vEmbNumero,
                   pLstParametros(i).vEmbFlag,
                   pLstParametros(i).vEmbSequencia,
                   pLstParametros(i).vArmColeta,
                   pLstParametros(i).vArmColetaCiclo
            from t_arm_nota n,
                 t_arm_coleta c
            where 0 = 0
              and n.arm_nota_numero = pLstParametros(i).vNumeroNota
              and n.glb_cliente_cgccpfremetente = trim(pLstParametros(i).vRemetente)
              and n.arm_nota_serie = '001'
              and n.arm_coleta_ncompra = c.arm_coleta_ncompra
              and n.arm_coleta_ciclo = c.arm_coleta_ciclo;
              vAuxiliar := 1;
         Exception When OTHERS Then
            vAuxiliar := 0;
         End; 
           
         if vAuxiliar = 0 Then            
            dbms_output.put_line('Nota ' || pLstParametros(i).vNumeroNota || ' Remetente ' || pLstParametros(i).vRemetente || ' não criou coleta ');
            pStatus := 'E';
         End If;  

         -- Arruma os Dados na Coleta
         if pStatus = 'N' Then
            if pLstParametros(i).vEExpresso = 'S' Then
               pLstParametros(i).vEExpresso := 'E';
            Else
               pLstParametros(i).vEExpresso := 'N';  
            End If;
            
            if pLstParametros(i).vTpCArga = PKG_GLB_TESTEINTEGRADO.cTpLotacao Then
               update t_arm_coleta co
                 set co.fcf_tpcarga_codigo = pLstParametros(i).vTpCArga,
                     co.fcf_tpveiculo_codigo = pLstParametros(i).vTpVeiculo,
                     co.arm_coleta_tpcoleta = pLstParametros(i).vEExpresso,
                     co.arm_coleta_flagquimico = pLstParametros(i).vTemQuimico,
                     co.arm_coleta_entcoleta = pLstParametros(i).vColetaEntrega,
                     co.arm_coleta_placa = DECODE(pLstParametros(i).vColetaEntrega,'C','SLF0001',NULL),
                     co.arm_coleta_tpcompra = decode(pLstParametros(i).vColetaEntrega,'C','FOB','FCA')
                where co.arm_coleta_ncompra = pLstParametros(i).vArmColeta
                  and co.arm_coleta_ciclo = pLstParametros(i).vArmColetaCiclo;     
                vAuxiliar := sql%rowcount;
                if vAuxiliar = 0 Then
                   dbms_output.put_line('Nota ' || pLstParametros(i).vNumeroNota || ' Remetente ' || pLstParametros(i).vRemetente || ' Coleta ' || pLstParametros(i).vArmColeta || ' não foi atualizada...' );
                   pStatus := 'E';
                End If;
            ElsIf pLstParametros(i).vTpCArga = PKG_GLB_TESTEINTEGRADO.cTpFracionado Then
               update t_arm_coleta co
                 set co.fcf_tpcarga_codigo = pLstParametros(i).vTpCArga,
                     co.fcf_tpveiculo_codigo = null,
                     co.arm_coleta_tpcoleta = pLstParametros(i).vEExpresso,
                     co.arm_coleta_flagquimico = pLstParametros(i).vTemQuimico,
                     co.arm_coleta_entcoleta = pLstParametros(i).vColetaEntrega,
                     co.arm_coleta_placa = DECODE(pLstParametros(i).vColetaEntrega,'C','SLF0001',NULL),
                     co.arm_coleta_tpcompra = decode(pLstParametros(i).vColetaEntrega,'C','FOB','FCA')
                where co.arm_coleta_ncompra = pLstParametros(i).vArmColeta
                  and co.arm_coleta_ciclo = pLstParametros(i).vArmColetaCiclo;     
                vAuxiliar := sql%rowcount;
                if vAuxiliar = 0 Then
                   dbms_output.put_line('Nota ' || pLstParametros(i).vNumeroNota || ' Remetente ' || pLstParametros(i).vRemetente || ' Coleta ' || pLstParametros(i).vArmColeta || ' não foi atualizada...' );
                   pStatus := 'E';
                End If;
            End If;
         End If;
         
         i := i + 1;
      End Loop;
      commit;

    End sp_ArrumaColeta;
    

  Procedure sp_CriaCarregamento(pLstParametros in Out  TypeLstParametros,
                                pStatus        out Char,
                                pMessage       out varchar2)
    As
      i Integer;
      vAuxiliar  integer;
      vListaEmbalagens varchar2(10000);
      vXmlCriaCarreg   Clob;
      vXmlCriaCarregbl blob;
      vXmlCriaCarregblin blob;
      vCarregamento    tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;
      vVeicDispCod     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
      vVeicDispSeq     tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
    Begin

    dbms_output.put_line('Entrando sp_CriaCarregamento');

     pStatus := 'N';
     pMessage := '';
     i := 1;  
     loop 
       Begin
         if Not pLstParametros(i).vNumeroNota = 0 Then
            vAuxiliar := i;
         End If;
       Exception
         When NO_DATA_FOUND Then
          exit;
         End;
         -- Alimenta lista de Embalagens para criar Carregamento
         if pStatus = 'N' Then
            vListaEmbalagens := vListaEmbalagens || '<row num="' || trim(to_char(i)) || '" arm_embalagem_numero="' || pLstParametros(i).vEmbNumero || '" arm_embalagem_flag="' || pLstParametros(i).vEmbFlag  || '" arm_embalagem_sequencia="' || pLstParametros(i).vEmbSequencia  || '" table_name="lista_embalagens"/>';     
         End If;
         i := i + 1;
           
      End Loop; 

   If pStatus = 'N' then
      -- Cria o Carregamento
      vXmlCriaCarreg := pkg_glb_testeintegrado.vXmlModeloCriaCarreg;
      vXmlCriaCarreg := replace(vXmlCriaCarreg,'#vRota#',pLstParametros(1).vRota);
      vXmlCriaCarreg := replace(vXmlCriaCarreg,'#vArmazem#',pLstParametros(1).vArmazem);
      vXmlCriaCarreg := replace(vXmlCriaCarreg,'#vListaEmbalagens#',vListaEmbalagens);
     
   
      tdvadm.pkg_fifo_carregamento.sp_cria_carregamento(vXmlCriaCarreg,
                                                        pStatus,
                                                        pmessage);


      if pStatus <> 'N' Then
         dbms_output.put_line('Erro Criando Carregagmento ' || chr(10) || pmessage);
         vCarregamento := '';
         pStatus := 'E';
      Else
         Begin
             select cd.arm_carregamento_codigo,
                    ca.fcf_veiculodisp_codigo,
                    ca.fcf_veiculodisp_sequencia
               into vCarregamento,
                    vVeicDispCod,
                    vVeicDispSeq
             from t_arm_carregamentodet cd,
                  t_arm_carregamento ca
             where cd.arm_embalagem_numero = pLstParametros(1).vEmbNumero
               and cd.arm_embalagem_flag = pLstParametros(1).vEmbFlag
               and cd.arm_embalagem_sequencia = pLstParametros(1).vEmbSequencia
               and cd.arm_carregamento_codigo = ca.arm_carregamento_codigo
               and ca.arm_armazem_codigo = pLstParametros(1).vArmazem;

             dbms_output.put_line('Carregamento Criado ' || vCarregamento || chr(10));

             if vVeicDispCod is null Then
                vVeicDispCod := tdvadm.pkg_fifo.fn_CriaVeicVirtual(vCarregamento);
                vVeicDispSeq := '0';
             End If;  
             update t_arm_carregamento ca
                set ca.fcf_veiculodisp_codigo =  vVeicDispCod,
                    ca.fcf_veiculodisp_sequencia = vVeicDispSeq,
                    ca.Arm_Carregamento_Flagvirtual = 'S'
             where ca.arm_carregamento_codigo = vCarregamento;
             -- Atualiza os Pesos
            pStatus :=  pkg_fifo_carregamento.FN_CARREG_ATUALIZA_PESOS(vCarregamento );
            if pStatus <> 'N' Then
               dbms_output.put_line('Erro Atualizando os pesos do Carregamento Nota ' || pLstParametros(1).vNumeroNota || ' Remetente ' || pLstParametros(1).vRemetente || chr(10) || ' erro: ' || sqlerrm || chr(10) || pmessage);
               pStatus := 'E';
            End IF;
         exception
           When OTHERS Then
              dbms_output.put_line('Erro tentando recuperar o codigo do Carregamento da Nota ' || pLstParametros(1).vNumeroNota || ' Remetente ' || pLstParametros(1).vRemetente || chr(10) || ' erro: ' || sqlerrm || chr(10) || pmessage);
              pStatus := 'E';
           End ; 
      End If;
    End If;
    
       -- Arruma os Dados de Veiculo No GRID quando informado
    if pStatus = 'N' Then
       if pLstParametros(1).vTpVeiculoGRID is not null Then 
          if vVeicDispCod is not null Then
              update t_fcf_veiculodisp vd
                set vd.fcf_tpveiculo_codigo = pLstParametros(1).vTpVeiculoGRID
              where vd.fcf_veiculodisp_codigo = vVeicDispCod
                and vd.fcf_veiculodisp_sequencia = vVeicDispSeq;
          Else
             dbms_output.put_line('Veiculo Disponivel não foi criado ' || chr(10) || pmessage);
             pStatus := 'E';
          end If;
       End If;
       
    End If;       
     
   
   -- Fecha o Carregamento
   If pStatus = 'N' then
      pkg_fifo_carregamento.SP_FECHA_CARREGAMENTO(vCarregamento,pLstParametros(1).vArmazem,pLstParametros(1).vUsuario,pStatus,pmessage);
      if pStatus <> 'N' Then
         dbms_output.put_line('Erro Fechado Carregamento ' || vCarregamento || chr(10) || pmessage);
         pStatus := 'E';
         pLstParametros(1).vCarregamento := '';
      Else
         pLstParametros(1).vCarregamento := vCarregamento;
      End If;
      
      If pStatus = 'N' Then
         select count(*)
           into vAuxiliar
         from tdvadm.t_con_conhecimento c
         where c.arm_carregamento_codigo = vCarregamento
           and c.con_conhecimento_serie = 'XXX';
         If vAuxiliar = 0 then 
            pStatus := 'E';
            pMessage := 'CTe nao gerados para o carregamento ' || vCarregamento ;
         End If;
      End If;
   End If;   




   
  End sp_CriaCarregamento ;    



  Procedure sp_ValidaValores(pLstParametros in Out  TypeLstParametros,
                             pStatus        out Char,
                             pMessage       out varchar2)
    As
      i Integer;
      vAuxiliar  integer;
      vVlrCte   number;
      vVlrCol   number;
    Begin

    dbms_output.put_line('Entrando sp_ValidaValores');

     pStatus := 'N';
     pMessage := '';
     i := 1;  
     loop 
       Begin
         if Not pLstParametros(i).vNumeroNota = 0 Then
            vAuxiliar := i;
         End If;
       Exception
         When NO_DATA_FOUND Then
          exit;
         End;

         -- Faz outro loop para ver os valores de Cada Nota
         i := 1;
         loop
           Begin
             if Not pLstParametros(i).vNumeroNota = 0 Then
                vAuxiliar := i;
             End If;
           Exception
             When NO_DATA_FOUND Then
                exit;
             End;
         
           select fn_busca_conhec_verba(n.con_conhecimento_codigo,n.con_conhecimento_serie,n.glb_rota_codigo,'R_FRPSVOMR'),
                  fn_busca_conhec_verba(n.con_conhecimento_codigo,n.con_conhecimento_serie,n.glb_rota_codigo,'D_OT1')
             into vVlrCte,
                  vVlrCol
           from t_arm_nota n
           Where n.arm_nota_numero = pLstParametros(i).vNumeroNota
             and n.glb_cliente_cgccpfremetente = trim(pLstParametros(i).vRemetente)
             and n.arm_nota_serie = '001'
             and n.arm_armazem_codigo = pLstParametros(1).vArmazem;
             
           If ( abs( vVlrCte - pLstParametros(i).ValorCte) > 1 ) or ( abs( vVlrCol - pLstParametros(i).ValorColeta) > 1 )  Then
              dbms_output.put_line('Nota [' || pLstParametros(i).vNumeroNota || '] Remetente [' || pLstParametros(i).vRemetente || '] Calculo errado ' || chr(10) ||
                                   'CTe Valor Esperado [' || to_char(pLstParametros(i).ValorCte) || '] Valor Calculado [' || to_char(vVlrCte) || '] ' || chr(10) ||
                                   'Col Valor Esperado [' || to_char(pLstParametros(i).ValorColeta) || '] Valor Calculado [' || to_char(vVlrCol) || '] ');
              pStatus := 'E';
           end If;  
           
           
           
           
           
           i := i + 1;
         End Loop;
         
        --if pStatus = 'N' then
        --    PKG_GLB_TESTEINTEGRADO.sp_LimpaTestesCarreg;
        -- End If;


     End Loop;
     
  End sp_ValidaValores;


  Procedure sp_criaTesteCarreg(p_carregamento in tdvadm.t_Arm_Carregamento.arm_carregamento_codigo%type,
                               p_codigoTeste  out number)
   As
     tpTabTeste tdvadm.t_glb_testefifo%rowtype;
     vAuxiliar  integer := 1;
  Begin

  dbms_output.put_line('Entrando sp_criaTesteCarreg');
    
  Select max(t.glb_testefifo_codigo) + 1
     into tpTabTeste.Glb_Testefifo_Codigo
  from tdvadm.t_glb_testefifo t;
  
  tpTabTeste.Glb_Testefifo_Codigo    := nvl(tpTabTeste.Glb_Testefifo_Codigo,1);
  p_codigoTeste                      := tpTabTeste.Glb_Testefifo_Codigo;
  
  select a.glb_rota_codigo,
         a.arm_armazem_codigo,
         ca.usu_usuario_crioucarreg
    into tpTabTeste.glb_testefifo_vrota,
         tpTabTeste.glb_testefifo_varmazem,
         tpTabTeste.glb_testefifo_vusuario
  from t_arm_carregamento ca,
       t_arm_armazem a
  where ca.arm_carregamento_codigo = p_carregamento
    and ca.arm_armazem_codigo = a.arm_armazem_codigo;
    
   tpTabTeste.glb_testefifo_vusuario := 'testeplsql';

   for cMsg in (select an.arm_coleta_ncompra,
                       an.arm_coleta_ciclo,
                       an.arm_nota_numero, 
                       an.con_tpdoc_codigo,
                       an.arm_nota_chavenfe,
                       ta.slf_tabela_contrato,
                       sf.slf_solfrete_contrato,
                       an.arm_nota_tabsol,
                       an.arm_nota_tabsolcod,
                       an.arm_nota_tabsolsq,  
                       an.arm_nota_flagpgto,
                       an.glb_cliente_cgccpfsacado,
                       an.glb_cliente_cgccpfremetente,
                       an.glb_tpcliend_codremetente,
                       an.glb_cliente_cgccpfdestinatario,
                       an.glb_tpcliend_coddestinatario,
                       an.arm_nota_peso,
                       an.arm_nota_pesobalanca,
                       an.arm_nota_valormerc,
                       an.arm_nota_onu,
                       an.glb_tpcarga_codigo,
                       co.arm_coleta_tpcoleta,
                       co.arm_coleta_entcoleta,
                       an.arm_coleta_vlmercadoria,
                       co.fcf_tpcarga_codigo,
                       co.fcf_tpveiculo_codigo,
                       an.con_conhecimento_codigo,
                       an.con_conhecimento_serie,
                       an.glb_rota_codigo,
                       an.glb_mercadoria_codigo
                from t_arm_nota an,
                     t_arm_carregamentodet cd,
                     t_slf_tabela ta,
                     t_slf_solfrete sf,
                     t_arm_coleta co
                where 0 = 0
                  and cd.arm_carregamento_codigo = p_carregamento
                  and an.arm_embalagem_numero    = cd.arm_embalagem_numero 
                  and an.arm_embalagem_flag      = cd.arm_embalagem_flag
                  and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
                  and an.arm_nota_tabsolcod      = ta.slf_tabela_codigo (+)
                  and an.arm_nota_tabsolsq       = ta.slf_tabela_saque (+)
                  and an.arm_nota_tabsolcod      = sf.slf_solfrete_codigo  (+)
                  and an.arm_nota_tabsolsq       = sf.slf_solfrete_saque  (+)
                  and an.arm_coleta_ncompra      = co.arm_coleta_ncompra
                  and an.arm_coleta_ciclo        = co.arm_coleta_ciclo )
   Loop

       tpTabTeste.glb_testefifo_vtpnota         := cMsg.Con_Tpdoc_Codigo;
       tpTabTeste.glb_testefifo_vnumeronota     := vAuxiliar;
       tpTabTeste.glb_testefifo_vnotachave      := cMsg.arm_nota_chavenfe;

       tpTabTeste.glb_testefifo_vtpnota         := '99';
       tpTabTeste.glb_testefifo_vnumeronota     := vAuxiliar;
       tpTabTeste.glb_testefifo_vnotachave      := '';


       tpTabTeste.Glb_Testefifo_Sequencia       := vAuxiliar;
       tpTabTeste.glb_testefifo_vcoleta         := cMsg.arm_coleta_ncompra;
       tpTabTeste.glb_testefifo_vflagpagador    := cMsg.arm_nota_flagpgto;
       tpTabTeste.glb_testefifo_vsacado         := cMsg.glb_cliente_cgccpfsacado;
       tpTabTeste.glb_testefifo_vremetente      := cMsg.glb_cliente_cgccpfremetente;
       tpTabTeste.glb_testefifo_vtpremetente    := cMsg.glb_tpcliend_codremetente;
       tpTabTeste.glb_testefifo_vdestinatario   := cMsg.glb_cliente_cgccpfdestinatario;
       tpTabTeste.glb_testefifo_vtpdestinatario := cMsg.glb_tpcliend_coddestinatario;
       tpTabTeste.glb_testefifo_vpeso           := cMsg.arm_nota_peso;
       tpTabTeste.glb_testefifo_vpesobal        := cMsg.arm_nota_pesobalanca;
       tpTabTeste.glb_testefifo_vmercadoria     := cMsg.Glb_Mercadoria_Codigo;
       tpTabTeste.glb_testefifo_vvalormercadori := cMsg.arm_nota_valormerc;

       if cMsg.arm_nota_onu <> '9999' Then
          tpTabTeste.glb_testefifo_vtemquimico := 'S';
       Else
          tpTabTeste.glb_testefifo_vtemquimico := 'N';
       End If; 
       
       tpTabTeste.glb_testefifo_veexpresso      := cMsg.arm_coleta_tpcoleta;
       tpTabTeste.glb_testefifo_vtemcd          := cMsg.glb_tpcarga_codigo;
       tpTabTeste.glb_testefifo_vcoletaentrega  := cMsg.arm_coleta_entcoleta;
       tpTabTeste.glb_testefifo_vtpcarga        := cMsg.fcf_tpcarga_codigo;
       tpTabTeste.glb_testefifo_vtpveiculo      := cMsg.fcf_tpveiculo_codigo;
       tpTabTeste.glb_testefifo_vtpveiculogrid  := null;

       tpTabTeste.glb_testefifo_vnumtabsol      := cMsg.arm_nota_tabsolcod;
       tpTabTeste.glb_testefifo_vnumsqtabsol    := cMsg.arm_nota_tabsolsq;
       If cMsg.arm_nota_tabsol = 'T' Then
          tpTabTeste.glb_testefifo_vcontrato       := cMsg.slf_tabela_contrato;
       Else
          tpTabTeste.glb_testefifo_vcontrato       := cMsg.Slf_Solfrete_Contrato;
       End If;
       tpTabTeste.glb_testefifo_vtabsol         := null;
       tpTabTeste.glb_testefifo_vnumtabsol      := null;
       tpTabTeste.glb_testefifo_vnumsqtabsol    := null;
       tpTabTeste.glb_testefifo_vdtemissao      := sysdate;
       tpTabTeste.glb_testefifo_vdtsaida        := sysdate;

       tpTabTeste.glb_testefifo_vcriacoleta := 'N';
       tpTabTeste.glb_testefifo_vtransferencia := 'N';
       
       if cMsg.Con_Conhecimento_Codigo is not null Then
          tpTabTeste.glb_testefifo_valorcte := fn_busca_conhec_verba(cMsg.con_conhecimento_codigo,cMsg.con_conhecimento_serie,cMsg.glb_rota_codigo,'R_FRPSVOMR');
          tpTabTeste.glb_testefifo_valorcoleta := 0;
       End If;



       vAuxiliar := vAuxiliar + 1;

       insert into t_glb_testefifo values tpTabTeste; 

   End Loop;                  
   
   commit;

/*
select x.glb_testefifo_codigo,
       x.glb_testefifo_sequencia,
       x.glb_testefifo_vrota,
       x.glb_testefifo_varmazem,
       x.glb_testefifo_vusuario,
       x.glb_testefifo_vcriacoleta,
       x.glb_testefifo_vcoleta,
       x.glb_testefifo_vnumeronota,
       x.glb_testefifo_vtpnota,
       x.glb_testefifo_vnotachave,
       x.glb_testefifo_vcontrato,
       x.glb_testefifo_vflagpagador,
       x.glb_testefifo_vsacado,
       x.glb_testefifo_vremetente,
       x.glb_testefifo_vtpremetente,
       x.glb_testefifo_vdestinatario,
       x.glb_testefifo_vtpdestinatario,
       x.glb_testefifo_vpeso,
       x.glb_testefifo_vpesobal,
       x.glb_testefifo_vvalormercadori,
       x.glb_testefifo_vtransferencia,
       x.glb_testefifo_vtemquimico,
       x.glb_testefifo_veexpresso,
       x.glb_testefifo_vtpcarga,
       x.glb_testefifo_vtpveiculo,
       x.glb_testefifo_vtpveiculogrid,
       x.glb_testefifo_vtemcd,
       x.glb_testefifo_vcoletaentrega,
       x.glb_testefifo_valorcte,
       x.glb_testefifo_valorcoleta,
       x.glb_testefifo_vmercadoria,
       x.glb_testefifo_vtabsol,
       x.glb_testefifo_vnumtabsol,
       x.glb_testefifo_vnumsqtabsol,
       x.glb_testefifo_vdtemissao,
       x.glb_testefifo_vdtsaida
from t_glb_testefifo x;

*/

    
  End; 

                       
END PKG_GLB_TESTEINTEGRADO;
/
