create or replace package pkg_fifo is

/************************************************************************************************************************/
/*                               TIPO CRIADOS PARA SEREM UTILIZADOS PELO FIFO                                           */
/************************************************************************************************************************/
TYPE T_CURSOR IS REF CURSOR; 

/************************************************************************************************************************/
/*                                    TIPOS UTILIZADOS PELO VALE DE FRETE                                               */
/************************************************************************************************************************/

--Função utilizada para gerar o sql, com lista de Vales de Frete a serem gerados.
Type tVFreteNaoGerados Is Record( Placa                     Char(07),
                                  Motorista                 Varchar2(100),
                                  TPVEICULO                 varchar2(40),
                                  OBSERVACAO                Varchar2(200),
                                  DESCONTO                  Number(10,2),
                                  FCF_VEICULODISP_CODIGO    Char(07), 
                                  FCF_VEICULODISP_SEQUENCIA Char(03),
                                  FLAG                      Char(01),
                                  COD_CARREGAMENTO          Char(07)
                                );

--Tipo Lista de vales de fretes não gerados.
Type tListaVFNaoGerado Is Table Of tVFreteNaoGerados Index By Binary_Integer;

/************************************************************************************************************************/
/*                                    TIPOS UTILIZADOS PELO RECEBIMENTO                                                 */
/************************************************************************************************************************/
--tipo utilizada para recuperar dados de clientes.
Type tDadosCliente Is Record ( glb_cliente_cgccpfcodigo t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                               glb_cliente_razaosocial  t_glb_cliente.glb_cliente_razaosocial%Type,
                               glb_tpcliend_codigo      t_glb_cliend.glb_tpcliend_codigo%Type,
                               glb_cliend_codcliente    t_glb_cliend.glb_cliend_codcliente%Type,
                               glb_cliend_cidade        t_glb_cliend.glb_cliend_cidade%Type,
                               glb_estado_codigo        t_glb_cliend.glb_estado_codigo%Type,
                               glb_localidade_codigo    t_glb_cliend.glb_localidade_codigo%Type,
                               glb_localidade_codigoie  t_glb_cliend.glb_localidade_codigoie%Type,
                               glb_localidade_descricao t_glb_localidade.glb_localidade_descricao%Type
                               
                             );   

--Tipo de lista de dados de clientes.
Type tListaDadosCliente Is Table Of tDadosCliente Index By Binary_Integer;

--Tipo utilizada para recuperação de dados de nota
Type tDadosLancNota Is Record ( arm_coleta_ncompra              tdvadm.t_arm_coleta.arm_coleta_ncompra%Type,
                                arm_coleta_ciclo                tdvadm.t_arm_coleta.arm_coleta_ciclo%Type,
                                glb_cliente_cgccpfremetente     tdvadm.t_arm_coleta.glb_cliente_cgccpfcodigocoleta%Type,
                                glb_tpcliend_codigocoleta       tdvadm.t_arm_coleta.glb_tpcliend_codigocoleta%Type,
                                glb_cliente_cgccpfdestinatario  tdvadm.t_arm_coleta.glb_cliente_cgccpfcodigoentreg%Type,
                                glb_tpcliend_codigoentrega      tdvadm.t_arm_coleta.glb_tpcliend_codigoentrega%Type
                                
                              );

-- Tipo utilizado para receber dados de Servicos adicionais.
Type tDadosRedespacho Is Record ( arm_notaredespacho_cnpjctrc   tdvadm.t_arm_notaredespacho.arm_notaredespacho_cnpjctrc%Type,
                                  arm_notaredespacho_tpcliend   tdvadm.t_arm_notaredespacho.arm_notaredespacho_tpcliend%Type,
                                  arm_notaredespacho_ctrc       tdvadm.t_arm_notaredespacho.arm_notaredespacho_ctrc%Type,
                                  arm_notaredespacho_serie      tdvadm.t_arm_notaredespacho.arm_notaredespacho_serie%Type,
                                  arm_notaredespacho_chavecte   tdvadm.t_arm_notaredespacho.arm_notaredespacho_chavecte%Type, 
                                  arm_notaredespacho_dtemissao  tdvadm.t_arm_notaredespacho.arm_notaredespacho_dtemissao%Type,
                                  arm_notaservadd_codigo        tdvadm.t_arm_notaredespacho.arm_notaservadd_codigo%Type
                                );  

/************************************************************************************************************************/
/*                                    TIPOS UTILIZADOS PELO CARREGAMENTO                                                */
/************************************************************************************************************************/
--Tipo utilizado para definir estrutura do XML de localidade
Type tDadosLocalidade Is Record ( glb_localidade_codigo      t_glb_localidade.glb_localidade_codigo%Type,
                                  glb_localidade_descricao   t_glb_localidade.glb_localidade_descricao%Type,
                                  glb_localidade_codigoibge  t_glb_localidade.glb_localidade_codigoibge%Type,
                                  quantidade                 Integer,
                                  quantNaoFinalizadas        Integer
                                );  

--Tipo de lista de localidade.
Type tListaLocalidade Is Table Of tDadosLocalidade Index By Binary_Integer;  

--Tipo utilizada para definir estrutura do Xml de Relação de notas não carregadas.
Type tNotaNCarreg Is Record  ( arm_nota_numero                tdvadm.t_arm_nota.arm_nota_numero%Type,
                               glb_cliente_cgccpfdestinatario tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%Type,
                               glb_cliend_codcliente          tdvadm.t_glb_cliend.glb_cliend_codcliente%Type, 
                               glb_cliente_razaosociald       tdvadm.t_glb_cliente.glb_cliente_razaosocial%Type,
                               glb_localidade_codigo          tdvadm.t_glb_localidade.glb_localidade_codigo%Type,
                               glb_localidade_descricao       tdvadm.t_glb_localidade.glb_localidade_descricao%Type,
                               glb_cliente_cgccpfremetente    tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%Type,
                               glb_cliente_razaosocialr       tdvadm.t_glb_cliente.glb_cliente_razaosocial%Type,
                               arm_embalagem_numero           tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                               arm_embalagem_flag             tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                               arm_embalagem_sequencia        tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                               Finalizada                     Varchar2(100),
                               TempoLimite                    Varchar2(50)
                             );
                              

--Tipo de lista de notas não carregadas.
Type tListaNotaNCarreg Is Table Of tNotaNCarreg Index By Binary_Integer;


/************************************************************************************************************************/

/************************************************************************************************************************/
/*                                    TIPOS UTILIZADOS PELO FECHAMENTO EM MASSA                                         */
/************************************************************************************************************************/
--Tipo utilizado para recuperar dados de um processo de fechamento
Type tDadosProcesso Is Record ( glb_processo_codigo        Char(03),
                                glb_processodet_id         Number, 
                                glb_processodet_dtcria     Varchar2(20),
                                glb_status_descricao       Varchar2(50),
                                glb_status_flagfinal       Char(01),
                                glb_processodet_dtinicial  Varchar2(50),
                                glb_processodet_dtfinal    Varchar2(50),
                                qtde_notas                 Number,
                                qtde_Notas_Finalizada      Number,
                                qtde_Notas_NaoFinal        Number
                                );
--Tipo de lista de dados de processo.
Type tListaDadosProcesso Is Table Of tDadosProcesso Index By Binary_Integer;                                

Type tDadosProcesso2 Is Record ( glb_processo_codigo        Char(03),
                                glb_processodet_id         Number, 
                                arm_carregamento_codigo    t_arm_carregamento.arm_carregamento_codigo%Type,
                                glb_processodet_dtcria     Varchar2(20),
                                glb_status_descricao       Varchar2(50),
                                glb_status_flagfinal       Char(01),
                                glb_processodet_dtinicial  Varchar2(50),
                                glb_processodet_dtfinal    Varchar2(50),
                                qtde_notas                 Number,
                                qtde_Notas_Finalizada      Number,
                                qtde_Notas_NaoFinal        Number
                                );

Type tListaDadosProcesso2 Is Table Of tDadosProcesso2 Index By Binary_Integer; 


--Tipo utilizado para criar recuperar dados de detalhe de um processo  
Type tDadosProcessoDet  Is Record ( glb_processo_codigo          Char(03),
                                    glb_processodet_id           Number,
                                    arm_carregstatus_seq         Number,
                                    arm_nota_numero              Number,
                                    glb_cliente_cgccpfremetente  Varchar2(25),
                                    glb_cliente_razaosocialRemet Varchar2(50),
                                    glb_cliente_cgccpfDestino    Varchar2(25),
                                    glb_cliente_razaosocialDest  Varchar2(50),
                                    Glb_Localidade_Codigo        Char(08),
                                    Glb_Localidade_Descricao     Varchar2(50),
                                    arm_movimento_datanfentrada  Varchar2(25),
                                    arm_nota_dtrecebimento       Varchar2(25),
                                    glb_status_descricao         Char(50),
                                    Arm_Carregstatus_Dtreg       Varchar2(25),
                                    Arm_Carregstatus_Montcarreg  Varchar2(25),
                                    Arm_Carregstatus_Fechamento  Varchar2(25),
                                    Arm_Carregstatus_Libemb      Varchar2(25),
                                    arm_carregstatus_impressao   Varchar2(25),
                                    Arm_Carregstatus_Obs         Varchar2(255)
                                  );


--Tipo de lista de detalhe de dados de processo.
Type tListaDadosProcessoDet Is Table Of tDadosProcessoDet Index By Binary_Integer;
                                    

/************************************************************************************************************************/

 

--Criei esse tipo para poder utilizar funções com retorno padrão.
TYPE tRetornoFunc is record ( Status           Char(01),
                              Message          Varchar2(5000),
                              Controle         Integer,
                              Status_Booleano  Char(1),
                              Xml              Clob,
                              QtdeErro         Integer,
                              MsgErro          Varchar2(32000),
                              qtdeAlerta       Integer,
                              MsgAlerta        Varchar2(32000)
                             ); 

--Record utilizado como estrutura para demonstrar erros
Type tRecErros Is Record ( Codigo         Integer,
                           Texto          Varchar2(5000) );

--Tabela utilizada para guardar os erros encontrados na validação
Type tListaErros IS TABLE OF tRecErros INDEX BY BINARY_INTEGER; 

--
Type tDadosProdutosQuimicos Is Record ( onu_codigo              tdvadm.t_glb_onu.glb_onu_codigo%Type,
                                        onu_grpEmb              tdvadm.t_glb_onu.glb_onu_grpemb%Type,
                                        onu_qtdeEmb             Number,
                                        onu_peso                Number(10,3),
                                        Status  char(1),
                                        Message varchar2(5000)
                                      ); 
         



--Record com todos os dados que envolvem uma nota-fiscal para ser utilizado pelo Recebimento
Type tDadosNota Is Record ( NotaStatus              Char(1),
                            
                            --Dados da Coleta
                            criar_coleta            Char(1),
                            coleta_Codigo           tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                            coleta_Ciclo            tdvadm.t_arm_coleta.arm_coleta_ciclo%Type, 
                            coleta_Pedido           tdvadm.t_arm_coleta.arm_coleta_pedido%Type, 
                            coleta_Tipo             tdvadm.t_arm_coleta.arm_coleta_tpcompra%type,
                            coleta_ocor             tdvadm.t_arm_coleta.arm_coletaocor_codigo%type,
                            finaliza_digitacao      char(1),
                            --Dados da Nota Fiscal
                            nota_Tipo               tdvadm.t_arm_nota.arm_nota_tipo%Type,
                            nota_Sequencia          tdvadm.t_arm_nota.arm_nota_sequencia%type, 
                            nota_numero             tdvadm.t_arm_nota.arm_nota_numero%type,
                            nota_serie              tdvadm.t_arm_nota.arm_nota_serie%type,
                            nota_dtEmissao          tdvadm.t_arm_nota.arm_movimento_datanfentrada%type,
                            nota_dtSaida            tdvadm.t_arm_nota.arm_nota_dtrecebimento%type,
                            nota_dtEntrada          tdvadm.t_arm_nota.arm_nota_dtinclusao%type,
                            nota_chaveNFE           tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                            nota_pesoNota           tdvadm.t_arm_nota.arm_nota_peso%type,
                            nota_pesoBalanca        tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                            nota_altura             tdvadm.t_arm_nota.arm_nota_altura%type,
                            nota_largura            tdvadm.t_arm_nota.arm_nota_largura%type, 
                            nota_comprimento        tdvadm.t_arm_nota.arm_nota_comprimento%type, 
                            nota_cubagem            tdvadm.t_arm_nota.arm_nota_cubagem%type,
                            nota_EmpilhamentoFlag   tdvadm.t_arm_nota.arm_nota_flagemp%type,
                            nota_EmpilhamentoQtde   tdvadm.t_arm_nota.arm_nota_empqtde%type,
                            nota_descricao          tdvadm.t_arm_nota.arm_nota_mercadoria%type, 
                            nota_qtdeVolume         tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                            nota_ValorMerc          tdvadm.t_arm_nota.arm_nota_valormerc%type,
                            nota_RequisTp           tdvadm.t_arm_nota.arm_nota_tabsol%type, 
                            nota_RequisCodigo       tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                            nota_RequisSaque        tdvadm.t_arm_nota.arm_nota_tabsolsq%type,
                            nota_Contrato           tdvadm.t_arm_nota.slf_contrato_codigo%type,
                            nota_PO                 tdvadm.t_arm_nota.xml_notalinha_numdoc%type,
                            nota_Di                 tdvadm.t_arm_nota.arm_nota_di%type, 
                            nota_Vide               tdvadm.t_arm_nota.arm_nota_vide%type,
                            nota_flagPgto           tdvadm.t_arm_nota.arm_nota_flagpgto%Type,
                            nota_qtdelimitada       tdvadm.t_arm_nota.arm_nota_qtdelimit%type,
                            
                            --Dados da Carga
                            carga_Codigo            tdvadm.t_arm_carga.arm_carga_codigo%Type,
                            carga_Tipo              tdvadm.t_Arm_carga.glb_tpcarga_codigo%Type,

                            --Dados de Vide Nota
                            vide_Sequencia          tdvadm.t_arm_nota.arm_nota_sequencia%type,
                            vide_Numero             tdvadm.t_arm_nota.arm_nota_numero%type,
                            vide_Cnpj               tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                            vide_Serie              tdvadm.t_arm_nota.arm_nota_serie%type, 

                            --Dados da Mercadoria
                            mercadoria_codigo       tdvadm.t_glb_mercadoria.glb_mercadoria_codigo%type,
                            mercadoria_descricao    tdvadm.t_glb_mercadoria.glb_mercadoria_descricao%type,
                            
                            --Dados de CFOP
                            cfop_Codigo             tdvadm.t_glb_cfop.glb_cfop_codigo%type,
                            cfop_Descricao          tdvadm.t_glb_cfop.glb_cfop_descricao%type,
                            
                            --Dados de Embalagem 
                            embalagem_numero        tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                            embalagem_flag          tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                            embalagem_sequencia     tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                            
                            --Dados da Rota
                            rota_Codigo             tdvadm.t_glb_rota.glb_rota_codigo%type,
                            rota_Descricao          tdvadm.t_glb_rota.glb_rota_descricao%type,
                            
                            --Dados do Armazem 
                            armazem_Codigo          tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                            armazem_Descricao       tdvadm.t_arm_armazem.arm_armazem_descricao%type,
                            
                            --Dados de Remetente
                            Remetente_CNPJ          tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                            Remetente_RSocial       tdvadm.t_glb_cliente.glb_cliente_razaosocial%Type,
                            Remetente_tpCliente     tdvadm.t_glb_cliend.glb_tpcliend_codigo%Type,
                            Remetente_CodCliente    tdvadm.t_glb_cliend.glb_cliend_codcliente%Type,
                            Remetente_Endereco      tdvadm.t_glb_cliend.glb_cliend_endereco%Type,
                            
                            Remetente_LocalCodigo     tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                            Remetente_LocalDesc       tdvadm.t_glb_localidade.glb_localidade_descricao%type,
                            
                            --Dados de Destino
                            Destino_CNPJ            tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                            Destino_RSocial         tdvadm.t_glb_cliente.glb_cliente_razaosocial%Type,
                            Destino_tpCliente       tdvadm.t_glb_cliend.glb_tpcliend_codigo%Type,
                            Destino_CodCliente      tdvadm.t_glb_cliend.glb_cliend_codcliente%Type,
                            Destino_Endereco        tdvadm.t_glb_cliend.glb_cliend_endereco%Type,
                            
                            Destino_LocalCodigo     tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                            Destino_LocalDesc       tdvadm.t_glb_localidade.glb_localidade_descricao%type,
                            
                            --Dados do Sacado
                            Sacado_CNPJ             tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                            Sacado_RSocial          tdvadm.t_glb_cliente.glb_cliente_razaosocial%type,
                            Sacado_tpCliente        tdvadm.t_glb_cliend.glb_tpcliend_codigo%Type,
                            
                            --Código Onu 
                            Onu_Codigo             tdvadm.t_glb_onu.glb_onu_codigo%Type,
                            Onu_GrpEmb             tdvadm.t_glb_onu.glb_onu_grpemb%Type,
                            Onu_Flag               Char(1),
                            
                            --Dados de redespacho
                            DadosRedespacho tDadosRedespacho,
                            
                            --Tipo de Documento
                            nota_tpDocumento       tdvadm.t_con_tpdoc.con_tpdoc_codigo%Type,
                            
                            usu_usuario_codigo     tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                            
                            -- Dados dos CTe
                            Cte_Original           char(11),
                            Cte_Devolucao          char(11),
                            Cte_Reentrega          char(11),
                            Cte_Anulador           char(11),
                            Cte_Substituto         char(11),
                            Cte_ColCancelada       char(11),
                            ctrc_localColeta       varchar2(20),
                            
                            
                            Status  char(1),
                            Message varchar2(5000)
                           ); 
                            

--Record que será utilizado para passagem dos dados da Nota Fiscal para Validação.
Type tDadosNotaValidacao Is Record ( NumeroNota   tdvadm.t_arm_nota.arm_nota_numero%type,
                                     DtEmissao    varchar2(20),
                                     DtSaida      varchar2(20),
                                     dtEntrada    date,
                                     Nota_serie    tdvadm.t_arm_nota.arm_nota_serie%Type,
                                     
                                     CnpjRemet    tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                                     TpEndRemet   tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,
                                     Remetente_LocalCodigo     tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                     Origem_LocalCodigo        tdvadm.t_glb_localidade.glb_localidade_codigo%type,

                                     CnpjDestino  tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                                     TpEndDestino tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type,
                                     Destino_LocalCodigo     tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                     
                                     tpSacado       char(1),
                                     CnpjSacado   tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%Type,
                                     
                                     PesoNota     tdvadm.t_arm_nota.arm_nota_peso%type,
                                     PesoBalanca  tdvadm.t_arm_nota.arm_nota_pesobalanca%Type,
                                     
                                     Coleta       tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                                     Coleta_Ciclo tdvadm.t_arm_coleta.arm_coleta_ciclo%Type,
                                     TpColeta     tdvadm.t_arm_nota.arm_coleta_tpcompra%type,

                                     TpCarga      tdvadm.t_arm_nota.glb_tpcarga_codigo%type,
                                     
                                     FlagEmp      tdvadm.t_arm_nota.arm_nota_flagemp%type,
                                     QtdeEmp      tdvadm.t_arm_nota.arm_nota_empqtde%type,
                                     
                                     Mercadoria   tdvadm.t_arm_nota.glb_mercadoria_codigo%type,
                                     VlrMercad    tdvadm.t_arm_nota.arm_nota_valormerc%type,
                                     QtdeVolume   tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                                     
                                     
                                     ChaveNfe     tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                                     
                                     Cfop         tdvadm.t_arm_nota.glb_cfop_codigo%type,
                                     Contrato     tdvadm.t_arm_nota.slf_contrato_codigo%type,
                                     TpRequis     tdvadm.t_arm_nota.arm_nota_tabsol%type,
                                     RequisCod    tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                                     SaqueRequis  tdvadm.t_arm_nota.arm_nota_tabsolsq%type,
                                     NotaVide     tdvadm.t_arm_nota.arm_nota_vide%type,
                                     
                                     
                                     
                                     Usuario      tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                                     Aplicacao    tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type,
                                     Rota         tdvadm.t_glb_rota.glb_rota_codigo%Type,
                                     Armazem      tdvadm.t_arm_armazem.arm_armazem_codigo%Type    ,

                                     --Tipo de Documento
                                     nota_tpDocumento       tdvadm.t_con_tpdoc.con_tpdoc_codigo%Type,

                                     nota_qtdelimitada      tdvadm.t_arm_nota.arm_nota_qtdelimit%type,

                                     nota_Sequencia         tdvadm.t_arm_nota.arm_nota_sequencia%type,
                                     con_tpdoc_codbarra     tdvadm.T_CON_TPDOC.con_tpdoc_codbarra%type
                                   );

/************************************************************************************************************************/
/*                               CONSTANTES UTILIZADAS PELO FIFO                                                        */
/************************************************************************************************************************/
  --Constant vazia 
  Empty CONSTANT CHAR(1) := '';
  
  --Constants para serem utilizados como retorno para as procedures.
  Status_Normal CONSTANT CHAR(1) := 'N';
  Status_Erro   CONSTANT CHAR(1) := 'E';
  
  --Nome da Aplicação.
  NomeAplicacao  constant char(06) := 'carreg';
  
  --BOOLEANO COMO CHAR
  BOOLEAN_SIM CONSTANT CHAR(1) := 'S';
  BOOLEAN_NAO CONSTANT CHAR(1) := 'N'; 

/************************************************************************************************************************/
/*                               VARIAVEIS UTILIZADAS PELO FIFO                                                        */
/************************************************************************************************************************/
  -- Usando para passar o motivo de nao poder voltar o carregamento
  vMSGFuncRetornaCarreg  varchar2(32000);

/************************************************************************************************************************/
/*                       PROCEDURES PÚBLICAS PARA O PROJETO OU NÃO CLASSIFICADAS                                        */
/************************************************************************************************************************/
/************************************************************************************************************************/
/*                                    TIPOS UTILIZADOS PELO CARREGAMENTO                                                */
/************************************************************************************************************************/
/************************************************************************************************************************/
/*                               PROCEDURES UTILIZADAS PELA ABA DO CARREGAMENTO                                         */
/************************************************************************************************************************/
FUNCTION FN_GET_NOTALIBERADA(pArmEmbalagemNumero IN tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                              pArmEmbalagemSeq IN tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type) RETURN CHAR;

PROCEDURE sp_getChaveNfe( pChaveNfe in tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                               pStatus      out char,
                               pMessage     out varchar2,
                               pCursor      out tdvadm.pkg_fifo.T_CURSOR);

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 13-01-2016
* Alimenta          : Variável de saída pFreteDedicado
* Funcionalidade    : Verifica se o frete é uma transferência VLI e Dedicado
* Particularidades  :
* Param.Obrigatórios: pArm_Embalgem_Numero, pArm_Embalagem_Sequencia
*********************************************************************************************/                                        
Procedure sp_FreteDedicado(     pArm_Embalagem_Numero In Varchar2,
                                pArm_Embalagem_Sequencia In Varchar2,
                                pFreteDedicado Out Char,
                                pStatus Out Char,
                                pMessage Out Varchar2);

Procedure sp_GetTiposEmerg(     pArm_Carregamento_Codigo In Varchar2,
                                pEmbalagem in Varchar2,
                                pSeqEmbalagem in Varchar2,
                                pQuimico Out Char,
                                pNQuimico Out Char,
                                pStatus Out Char,
                                pMessage Out Varchar2);

Procedure sp_getNumContrSacado( pGlb_cliente_cgccpfcodigo In  Varchar2,
                                pCursor Out pkg_fifo.T_CURSOR,
                                pStatus  Out Char, 
                                pMessage Out Varchar2);
                                
Procedure sp_getNumContrSolicitacao( pSlf_solfrete_codigo In  Varchar2,
                                     pCursor Out pkg_fifo.T_CURSOR,
                                     pStatus  Out Char, 
                                     pMessage Out Varchar2);

PROCEDURE SP_GET_ASN_NUM_COLETA(pNumColeta IN t_xml_coleta.xml_coleta_numero%type,
                                pCursor out pkg_fifo.T_CURSOR,
                                pStatus      OUT CHAR,
                                PMessage     OUT VARCHAR2);
                                     

Procedure sp_getNumContrTabela( pSlf_tabela_codigo In  Varchar2,
                                pCursor Out pkg_fifo.T_CURSOR,
                                pStatus  Out Char, 
                                pMessage Out Varchar2);                                                                     

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 08-01-2016
* Alimenta          : Cursor
* Funcionalidade    : Procedure utilizada para retornar um cursor com os dados das embalagens ainda não carregadas
                      Essa proceure é utilizada para popular o grid superior da aba FIFO - "Carregamento"
                      O corpo dessa procedure está no package "pkg_fifo_CARREGAMENTO"
                      Nesta versão, foi adicionado o filtro por contrato                      
* Particularidades  :
* Param.Obrigatórios: pDataIni, pDataFim, pContrato
*********************************************************************************************/

Procedure sp_ListaCarregamentoEmbContr( pArmazem In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                         pDataIni In  Varchar2,
                                         pDataFim In  Varchar2,
                                         pContrato In Varchar2,
                                         pArm_Coleta_NCompra In Varchar2,
                                         pArm_Coleta_Ciclo In Varchar2,
                                         pTipoCarga In Varchar2,
                                         pCursor  Out T_CURSOR,
                                         pStatus  Out Char,
                                         pMessage Out Varchar2);

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 14-01-2016
* Alimenta          : Retorna True ou False
* Funcionalidade    : Verifica se os CNPJS são do grupo economico VLI
* Particularidades  :
* Param.Obrigatórios: pArm_Carregamento_Codigo
*********************************************************************************************/
  FUNCTION FN_TransferenciaVli(pCnpjOrig IN Varchar2, pCnpjDest IN Varchar2) Return Boolean; 

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 11-01-2016
* Alimenta          : Cursor com os dados da nota e do contrato de um carregamento
* Funcionalidade    : Verifica se existem fretes dedicados ou outros em um carregamento
* Particularidades  :
* Param.Obrigatórios: pCodigoCarregamento
*********************************************************************************************/
Procedure sp_getNumContr(                pCodigoCarregamento In  Varchar2,
                                         pCursor  Out T_CURSOR,
                                         pStatus  Out Char,
                                         pMessage Out Varchar2);

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 13-01-2016
* Alimenta          : Variável de saída pFreteDedidado, pFreteOutros
* Funcionalidade    : Verifica se existem fretes dedicados ou outros em um carregamento
* Particularidades  :
* Param.Obrigatórios: pArm_Carregamento_Codigo
*********************************************************************************************/                                        
Procedure sp_GetTiposFrete(     pArm_Carregamento_Codigo In Varchar2,
                                pFreteDedicado Out Char,
                                pFreteOutros Out Char,
                                pStatus Out Char,
                                pMessage Out Varchar2);

-- Procedure para prorrogar notas vencidas
-- Anderson Fábio
-- 17/03/2016
procedure SP_AUTORIZA_NF(pArm_Nota_Numero in tdvadm.t_arm_notaliberacao.arm_nota_numero%type,
                         pGlb_cliente_cgcCpfCodigo in tdvadm.t_arm_notaliberacao.glb_cliente_cgccpfcodigo%type,
                         pArm_Nota_Serie in tdvadm.t_arm_notaliberacao.arm_nota_serie%type,
                         parm_notaLiberacao_dtlib in tdvadm.t_arm_notaliberacao.arm_notaliberacao_dtlib%type,
                         parm_notaLiberacao_Validade in tdvadm.t_Arm_Notaliberacao.arm_notaliberacao_validade%type,
                         parm_notaLiberacao_origem in tdvAdm.t_Arm_NotaLiberacao.Arm_Notaliberacao_Origem%type,
                         parm_notaLiberacao_usuario in tdvadm.t_arm_notaliberacao.usu_usuario_codigo%type,
                         pStatus       out char,
                         pMessage      out Varchar2
                         );
                         
Procedure sp_ListaFilial( pUsuApp  In  tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                          pCursor  Out T_CURSOR,
                          pStatus  Out Char,
                          pMessage Out Varchar2);
                          
--Procedure utilizada para administrar a Trava do Sistema                                                                                     
Procedure sp_TravaFIFO( pParamsEntrada In  Varchar2,
                        pStatus        Out Char,
                        pMessage       Out Varchar2,
                        pParamsSaida   Out Clob
                       );  
                          

/************************************************************************************************************************/
/*                               PROCEDURES UTILIZADAS PELA ABA DO CARREGAMENTO                                         */
/************************************************************************************************************************/
--Procedure utilizada para popular o Gride de Embalagens na Aba do "Fifo - 'Carregamento'" 
Procedure sp_ListaCarregamentoEmbalagem( pArmazem In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                         pDataIni In  Varchar2,
                                         pDataFim In  Varchar2,
                                         pCursor  Out T_CURSOR,
                                         pStatus  Out Char,
                                         pMessage Out Varchar2);
                                         
/* Procedure que retorna um cursor com as notas a partir de uma embalagem  */
procedure sp_getNotaEmbalagens( pNumEmb in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                                pSeqEmb in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                                pFlagemb in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                                pStatus  out char,
                                pMessagem out varchar2,
                                pCursor out pkg_fifo.T_CURSOR );

/* procedure que retorna um cursor com detalhes de embalagem a partir de um carregamento */
procedure sp_getEmbCarregamento( pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pStatus    out char,
                                 pMessage   out varchar2,
                                 pCursor    out tdvadm.pkg_fifo.T_CURSOR );
                                                                                                         

--Procedure utilizada para buscar dados da Nota tendo os paramentros presentes na Aba do Carregamento
procedure sp_getDadosNotaCarreg( pNumNota   in  tdvadm.t_arm_nota.arm_nota_numero%type,
                                 pCnpjRemet in  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                 pEmbNumero in  tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                                 pEmbFlag   in  tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                                 pEmbSeq    in  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                                 pColeta    in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                                 pCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pStatus    out char,
                                 pMessage   out varchar2,
                                 pCursor    out T_CURSOR );

--Procedure utilizada para buscar dados da Nota tendo os paramentros presentes na Aba do Carregamento
procedure sp_getDadosNotaCarreg2( pNumNota   in  tdvadm.t_arm_nota.arm_nota_numero%type,
                                 pCnpjRemet in  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                 pEmbNumero in  tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                                 pEmbFlag   in  tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                                 pEmbSeq    in  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                                 pColeta    in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                                 pCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pCnpjDest  in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type, 
                                 pStatus    out char,
                                 pMessage   out varchar2,
                                 pCursor    out T_CURSOR );
--Procedure utilizada para buscar os carregamentos de um Armazem
procedure sp_getCarregamentos( pCodArmazem   in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pStatus      out char,
                               pMessage     out varchar2,
                               pCursor      out T_CURSOR);

                               

--Procedure utilizada para excluir um carregamento                               
procedure sp_excluiCarregamento( pCodCarregamento in  tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pStatus          out char,
                                 pMessage         out varchar2);
                               
                               
--Procedure utilizada para vincular as Embalagens em um carregamento 
procedure sp_VinculaEmbCarreg( pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                               pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                               pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                               pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                               pStatus       out char,
                               pMessage     out varchar2);


--Procedure utilizada para vincular uma lista de embalagens a um carregamento.
Procedure sp_VincListaEmbCarreg( pParamsEntrada In Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2
                               );


-- Procedure utilizada para retirar transferência de uma embalagem 
procedure sp_RetiraTransfEmb(  pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                               pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                               pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                               pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                               pStatus       out char,
                               pMessage      out varchar2);

--Procedure utilizada descarregar uma embalagem                                                                       
procedure sp_DescarregaEmb( pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                            pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                            pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                            pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                            pStatus       out char,
                            pMessage      out varchar2);

--Procedure utilizada para efeturar transferência de embalagem
Procedure sp_TransfereEmb(  pUsuario      in varchar2 default null,
                            pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                            pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                            pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                            pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                            pArmTransf    In tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                            pStatus       out char,
                            pMessage      out varchar2);


--PROCEDURE UTILIZADA PARA FECHAR O CARREGAMENTO
Procedure SP_FECHA_CARREGAMENTO( P_COD_CARREGAMENTO    In TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%Type,
                                 P_COD_ARMAZEM         In TDVADM.T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%Type,
                                 P_USUARIO             In TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%Type,
                                 PSTATUS              Out Char,
                                 PMESSAGE              Out Varchar2  );  

------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para verificar se existe Notas para Chekin para Um determinado Armazem                          --
------------------------------------------------------------------------------------------------------------------------
Procedure sp_verificaCheckin ( pUsuario    In  tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                               pCodArmazem In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                               pRota       In  tdvadm.t_glb_rota.glb_rota_codigo%Type,
                               pStatus     Out Char,
                               pMessage    Out Varchar2
                             );

/************************************************************************************************************************/
/* RELAÇÃO DE PROCEDURES UTILIZADA NAS ROTINAS DE CHEKIN                                                                */
/************************************************************************************************************************/


-- Procedure utilizada para gerar relação de embalagens transferidas para o Armazem do usuario.
Procedure sp_getEmbTransferidas( pUsuario In Varchar2 Default null,
                                 pParamsEntrada In Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2,
                                 pParamsSaida   Out Clob );
                             
/************************************************************************************************************************/
/*                               PROCEDURES UTILIZADAS PELA ABA DO CTRC                                                 */
/************************************************************************************************************************/
--Procedure utilizada para popular o Grid Principal da Aba CTRC.
Procedure sp_AtualizaGridCtrc( pParamsEntrada In Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2,
                                 pParamsSaida   Out Clob 
                               );
                                 
--Procedure utilizada para atualizar o Grid do formulário CTRCDET.
Procedure sp_AtalizaGridCtrcDet( pParamsEntrada  In  Varchar2,
                                 pStatus         Out Char,
                                 pMessage        Out Varchar2,
                                 pParamsSaida    Out Clob
                               );  

-- Procedure utilizada para realizar vunculação de uma lista de carregamentos a um veiculos
procedure sp_set_VincListaCarreg( pParamsEntrada In Varchar2,
                                  pStatus        Out Char,
                                  pMessage       Out Varchar2,
                                  pParamsSaida   Out Clob 
                               ); 
                               
-- Procedure utilizada para gerar manifesto.                               
Procedure sp_GerarManifesto( pParamsEntrada In Varchar2,
                             pStatus        Out Char,
                             pMessage       Out Varchar2
                           );

--Procedure utilizada para retornar um carregamento da Aba do CTRc para a Aba do Fifo.
Procedure sp_RetCarrgFifo( pParamsEntrada  In Varchar2,
                           pStatus    out char,
                           pMessage   out Varchar2);                                                                                         
                       
/************************************************************************************************************************/
/*                               PROCEDURES UTILIZADAS PELA ABA DO RECEBIMENTO                                          */
/************************************************************************************************************************/
Procedure SP_RECEB_GETNOTAS( pParamsEntrada   In Varchar2,
                             pStatus          Out Char,
                             pMessage         Out Varchar2,
                             pParamsSaida     Out Clob);

-- Procedure utilizada para definir os tipos de documentos possíveis de busca 
Procedure sp_getTpDocBusca( pUsuario    In  Char,
                            pArmazem    In  Char,
                            pStatus     Out Char,
                            pMessage    Out Varchar2,
                            pCursor     Out t_cursOR );

-- Procedure utilizada para buscar dados iniciais para inclusão de uma nota fiscal
procedure sp_getDadosIniciais( pArmazem     in   tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pUsuario     in   char,
                               pCodBusca    in   char,
                               pTpCodBusca  in   char,
                               pStatus      out  char,
                               pMessage     out  varchar2,
                               pCursor      out  T_CURSOR);
                               
-- Procedure que retorna um cursor com os dados de Remetente e destinatario a partir do número de uma coleta 
procedure sp_getDadosPedido( pColeta  in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                               pArmazem in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pStatus  out char,
                               pMessage out varchar2,
                               pCursor  out T_CURSOR );


-- Procedure que retorna um cursor com os dados de Remetente e destinatario a partir do número de uma coleta 
procedure sp_getDadosColeta( pColeta  in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                             pArmazem in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                             pStatus  out char,
                             pMessage out varchar2,
                             pCursor  out T_CURSOR );

-- Procedure utilizada para buscar dados de uma Nota Fiscal, a partir da chave NFE
procedure sp_getDadosNota_chaveNFE( pChaveNfe  in  char,
                                    pStatus    out char,
                                    pMessage   out varchar2,
                                    pCursor    out pkg_fifo.T_CURSOR);
                                    
--Procedure utilizada para buscar lista de notas
procedure sp_getVideNota( pCnpj in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                          pStatus out char,
                          pMessage out varchar2,
                          pCursor out tdvadm.pkg_fifo.T_CURSOR );
                          
                          


Procedure sp_InsertNota( pParamsEntrada In blob, 
                         pStatus         Out Char,
                         pMessage       Out Varchar2,
                         pParamsSaida    Out Clob  );
                                                   
                                 

                                          
  Procedure sp_ListaAlmoxarifados(pCursor  Out T_CURSOR,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2);

  Procedure sp_ExistParametroUsuario(pUsuario In  tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                                     pPerfil  In  Varchar2,
                                     pCursor  Out T_CURSOR,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2);

  Procedure sp_ListaParametros(pUsuario    In  T_USU_APLICACAOPERFIL.USU_USUARIO_CODIGO%TYPE,
                               pRota       In  T_USU_APLICACAOPERFIL.GLB_ROTA_CODIGO%TYPE,
                               pCursor     Out TYPES.cursorType,
                               pStatus     Out Char,
                               pMessage    Out Varchar2);

  Procedure sp_ListaCarregamento(pArmazem  In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                 pCursor   Out T_CURSOR,
                                 pStatus   Out Char,
                                 pMessage  Out Varchar2);
                                 
  Procedure sp_GetPesos(pCursor  Out T_Cursor,
                        pStatus  Out Char,
                        pMessage Out Varchar2);
                        
  Procedure sp_ListaCarregamentoCTRC(pArmazem  In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                     pCursor   Out T_CURSOR,
                                     pStatus   Out Char,
                                     pMessage  Out Varchar2);
                                     
  Procedure sp_ListaFifoManifesto(pArmazem      In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                  pDataIni      In  Varchar2,
                                  pDataFin      In  Varchar2,
                                  pCarregamento In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                  pSerie        In  tdvadm.t_con_manifesto.Con_Manifesto_Serie%Type,
                                  pCursor       Out T_Cursor,
                                  pStatus       Out Char,
                                  pMessage      Out Varchar2);                                                           
                                  
  Procedure sp_NovoCarregamento(pArmazem      In  TDVADM.T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%TYPE,             
                                pUsuario      In  TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                pCarregamento Out TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,
                                pStatus       Out Char,
                                pMessage      Out Varchar2);
                                
  Procedure sp_Carregar(pCarregamento  In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                        pEmbNumero     In  tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                        pEmbFlag       In  tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                        pEmbSequencia  In  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                        pStatus        Out Char,
                        pMessage       Out Varchar2);                                
                        
/*  Procedure sp_ExcluiCarregamento(pCarregamento  In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                  pStatus        Out Char,
                                  pMessage       Out Varchar2);   */                     

  Procedure sp_RetiraEmbalagem(pCarregamento  In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                               pEmbNumero     In  tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                               pEmbFlag       In  tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                               pEmbSequencia  In  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                               pStatus        Out Char,
                               pMessage       Out Varchar2);  
                               
/* procedure responsável por conferir se a Nota Fiscal está sendo emitida contra uma empresa fora do mesmo estado */
  Procedure sp_ConfEstadoNf( pCnpjRemetente in tdvadm.t_glb_cliend.glb_cliente_cgccpfcodigo%type,
                             pTpRemetente   in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                             pCnpjDestino   in tdvadm.t_glb_cliend.glb_cliente_cgccpfcodigo%type,
                             pTpDestino     in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                             pStatus        out char,
                             pMessage       out varchar2);

/* Procedure responsável apenas para retornar a quantidade de carregamento está vinculado ao motorista */
  Procedure sp_CarregVeiculo( pCodVeiculo  in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                              pSequencia   in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                              pCursor      out T_CURSOR );

/* Procedure responsável desvincular um carregamento de um motorista */                              
  Procedure sp_DesvinculaCarreg( pCarregCodigo in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pCodVeiculo   in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                 pSequencia    in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                                 pStatus       out char, 
                                 pMessage      out varchar2  );

/* Procedure responsável por retornar todos os veiculos contratados em um determinado armazem */                                 
  Procedure sp_retorna_VeicContratados( pCodCarregamento In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                        pArmazem         In tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                        pStatus          Out Char,
                                        pMessage         Out Varchar2,
                                        pCursor          Out  T_CURSOR);
                                 
 /* função utilizada para Criar um veiculo Virtual a partir de um carregamento. */                                 
  function fn_CriaVeicVirtual( pCarregamento in  tdvadm.t_arm_carregamento.arm_carregamento_codigo%type) return char;
  
  /* Procedure utilizada por retornar um cursor com o dados para preencher a Tela "Cadastro de Embalagens->ALX",  */

                               
  
 /* Procedure responsável Validar Notas Fiscais - Entrada direto pelo recebimento. */ 
 PROCEDURE SP_VALIDA_NF(P_DATA            in  varchar2,
                         P_NOTA            in TDVADM.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                         P_NRCOLETA        IN TDVADM.T_ARM_COLETA.ARM_COLETA_NCOMPRA%TYPE,
                         P_CFOP            IN TDVADM.T_GLB_CFOP.GLB_CFOP_CODIGO%TYPE,
                         P_CONTRATO        IN TDVADM.T_ARM_NOTA.SLF_CONTRATO_CODIGO%TYPE,
                         P_CNPJ_DEST       IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFDESTINATARIO%TYPE,
                         P_DEST_TPEND      IN TDVADM.T_ARM_NOTA.GLB_TPCLIEND_CODDESTINATARIO%TYPE,
                         P_CNPJ_REMET      IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                         P_REMET_TPEND     IN TDVADM.T_ARM_NOTA.GLB_TPCLIEND_CODDESTINATARIO%TYPE,
                         P_CNPJ_SACADO     IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFDESTINATARIO%TYPE, -- CNPJ DO DO SACADO IREMOS TROCAR DEPOIS O NOME DA VARIAVEL
                         P_TPSOLTAB        In Char Default 'T',
                         P_TABELASOL       In TDVADM.T_SLF_TABELA.SLF_TABELA_CODIGO%Type Default '00000000',
                         P_SQTABELASOL     In TDVADM.T_SLF_TABELA.SLF_TABELA_SAQUE%Type Default '0000',
                         P_DATAEMISS       in  varchar2 , -- data de emissão da nota
                         P_TPCOLETA        in tdvadm.t_arm_coleta.arm_coleta_tpcompra%type, -- tipo da coleta. /valores esperados definidos por parametros
                         pStatus           out char,
                         pMessage          out varchar2);
                         
procedure SP_VALIDA_NotaFiscal(   p_NumNota       in tdvadm.t_Arm_Nota.arm_nota_numero%type,                            --integer
                                  p_DataSaida     in varchar2,
                                  p_DataEmissao   in varchar2,
                                  p_ChaveNfe      In Char,
                                  p_Cnpj_Dest     in tdvadm.t_Arm_Nota.glb_cliente_cgccpfdestinatario%type,             --varchar2(20)
                                  p_TpEnd_Dest    in tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type,               --char(01)
                                  p_Cnpj_Remet    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,                --varchar2(20)
                                  p_TpEnd_Remet   in tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,                  --char(01)
                                  p_Cnpj_Sacado   in tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,                   --varchar2(20)
                                  p_TpRequis      in char, -- T = Tabela | S = Solicitação
                                  p_CodRequis     in tdvadm.t_slf_tabela.slf_tabela_codigo%type Default '00000000',     --char(08)
                                  p_SaqueRequis   in tdvadm.t_slf_tabela.slf_tabela_saque%type Default  '0000',         --char(04)
                                  p_Contrato      in tdvadm.t_arm_nota.slf_contrato_codigo%type,                        --varchar2(15)
                                  p_Cfop          in tdvadm.t_glb_cfop.glb_cfop_codigo%type,                            --varchar2(04)
                                  p_Coleta        in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,                       --char(06)
                                  p_Armazem       in tdvadm.t_arm_armazem.arm_armazem_codigo%type,                      --char(02)
                                  p_Rota          In tdvadm.t_glb_rota.glb_rota_codigo%Type,                            --Char(03)
                                  p_CodOrigem     in tdvadm.t_glb_localidade.glb_localidade_codigo%type,                --char(08)
                                  p_CodDestino    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,                --char(08)
                                  p_Usuario       In tdvadm.t_usu_usuario.usu_usuario_codigo%Type,                      --char(10) 
                                  pStatus         out char,
                                  pMessage        out varchar2 );

  
  /* FUNCÃO VALIDA SE UM CARREGAMENTO PROVENIENTE DE ROTA DE CTE PODE SER VOLTADO PARA O FIFO. */
   FUNCTION FN_CON_PODEVOLTARCARREG(P_CODCARREG IN T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE)RETURN CHAR;
  
  /* FUNCÃO RETORNA A MENSAGEM DE IMPRESSO DE UM CTE / CTRC*/
   FUNCTION FN_CON_MSNCONHECIMENTO(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                   P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN VARCHAR2;
                                   
  /* Procedure Responsável por informar ao FrontEnd se o carregamento, em rota de CTE, pode voltar para o fifo */ 
  procedure sp_RetornaCarrgamento(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                  pStatus    out char,
                                  pMessage   out varchar2 );
  
  /* FUNCÃO RETORNA A ROTA DO CARREGAMENTO                                                                */
  FUNCTION FN_CON_RETORNAROTACARREG(P_CODCARREGAMENTO IN T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,P_TIPO in CHAR default 'C')RETURN Char;                                
  
  
  
  /* Procedure utilizada apenas para retornar os dados de um cliente a partir de um CNPJ */                                       
  procedure sp_retornaDadosCliente( pCnpj    in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                    pStatus  out char,
                                    pMessage out varchar2,
                                    pCursor out T_CURSOR );
                                    
  /* Procedure utilizada apenas para retornar a descrição CFOP, a partir de um código */                                    
  procedure sp_retornaDescCFOP ( pCFOP   in tdvadm.t_glb_cfop.glb_cfop_codigo%type,
                                 pstatus   out char,
                                 pMessage  out varchar2,
                                 pCursor out T_CURSOR );
                                 
  /* procedure utilizada apenas para retornar o maior saque de uma solicitação ou de uma tabela */
  procedure sp_retornaMoirSaqTabSol(pTpReferencia  in char,
                                    pCodReferencia in char,
                                    pStatus        out char,
                                    pMessage       out varchar2,
                                    pCursor        out t_cursor );
                                    
  /* Procedure responsável por retornar cursor que servirá para alimentar o Grid de Carregamento na aba "FIFO" */                                    
  procedure sp_DadosCarregamento( pCodVeiculo      in tdvadm.t_arm_carregamento.fcf_veiculodisp_codigo%type,
                                  pArmazem         in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                                  pStatus         out char,
                                  pMessage        out varchar2,
                                  pCursor         out t_cursor );
                                  
  /* Procedure responsável por retornar um cursor que alimentará o Grid Principal "RECEBIMENTO" */                                  
  procedure sp_getNotasRecebimentos( pNumNota      in  char,
                                     pCnpj         in  char,
                                     pEmbalagem    in  char,
                                     pCarregamento in  char,
                                     pColeta       in  char,
                                     pPo           in  char,
                                     pDataIni      in  char,
                                     pDataFim      in  char,
                                     pAxo          in  char,
                                     pArmazem      in  char,
                                     pCursor       out T_CURSOR,
                                     pStatus       out char,
                                     pMessage      out varchar2);
                                       
  /* Procedure responsável por retornar o SAQUE da Tabela ou Solicitação */                                      
  procedure sp_getSaque_TabSol( pTpRequisicao in char,
                                pNrRequisicao in char,
                                pStatus       out char,
                                pMessage      out varchar2,
                                pCursor       out t_cursor );
                                
                                
  /* Procedure utilizada para retornar um cursor contendo "Código, Estado e Cidade" de uma localidade */ 
  procedure sp_buscaLocalidade(pLocalidade   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                               pArmazem      in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pCnpj         in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                               pTpEnd        in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                               pStatus       out char,
                               pMessage      out varchar2,
                               pCursor       out T_CURSOR );
 

  /* Procedure utilizada para buscar Código e descrição de armazem, Código e Descrição de Rota, a partir do código do Armazem ou Rota   */
  procedure sp_buscaArmazemRota( pCodArmazem   in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pRota         in tdvadm.t_glb_rota.glb_rota_codigo%type,
                               pStatus       out char, 
                               pMessage      out varchar2,
                               pCursor       out T_CURSOR );
                               
    procedure sp_getNotaFiscal( pNumNota       in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCnpjRemetente in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pCnpjDestino   in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pNumColeta     in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pNumEmbalagem  in tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pStatus        out char,
                            pMessage       out varchar2,
                            pCursor        out T_CURSOR); 

  /* Procedue utilizada para buscar a Descrição e os tipos de embalagem, a partir de um código da onu                                   */
  procedure sp_buscaDadosOnu(pCodOnu        in tdvadm.t_glb_onu.glb_onu_codigo%type,
                             pStatus        out char,
                             pMessage       out varchar2,
                             pCursor        out t_cursor );
                             
procedure sp_inserirDadosNota( pOrigemNota   in char,                                                  --Ação a ser tomada "Inserção / Edição"
                               pSequencia    in tdvadm.t_arm_nota.arm_nota_sequencia%type,             --Sequencia para t_arm_nota
                               pNota         in tdvadm.t_arm_nota.arm_nota_numero%type,                --Numero da Nota Fiscal  
                               pSerie        in tdvadm.t_arm_nota.arm_nota_serie%type,                 --Série para a Nota Fiscal 
                               pDtEmissao    in varchar2,                                              --Data de Emissão da Nota 
                               pDtSaida      in varchar2,                                              --Data de Saida da Nota
                               pTpNota       in tdvadm.t_arm_nota.arm_nota_tipo%type,                  --Tipo da Nota "Fifo=D"
                               pRota         in tdvadm.t_arm_nota.glb_rota_codigo%type,                 
                               pArmazem      in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                               pTpCarga      in tdvadm.t_arm_nota.glb_tpcarga_codigo%type,
                               pCnpjRemet    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pTpEndRemet   in tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,
                               pCnpjDestino  in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type, 
                               pTpEndDestino in tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type,
                               pCnpjOutros   in varchar2,
                               pSacado       in char,                                                  --Tipo de Sacado / FlagPgto "R=Remetente", "D=Destino", "O=Outros"
                               pLocOrigem    in tdvadm.t_arm_nota.glb_localidade_codigoorigem%type,    --Codigo de Localidade de Origem
                               pLocDestino   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,    --Codigo de Localidade de Destino
                               pAltura       in tdvadm.t_arm_nota.arm_nota_altura%type,                --Altura 
                               pLargura      in tdvadm.t_arm_nota.arm_nota_largura%type,               --Largura
                               pComprimento  in tdvadm.t_arm_nota.arm_nota_comprimento%type,           --Comprimento
                               pFlagEmp      in tdvadm.t_arm_nota.arm_nota_flagemp%type,
                               pQtdeEmp      in tdvadm.t_arm_nota.arm_nota_empqtde%type,
                               pMercadoria   in tdvadm.t_arm_nota.glb_mercadoria_codigo%type,
                               pVlrMercad    in tdvadm.t_arm_nota.arm_nota_valormerc%type,
                               pDescricao    In tdvadm.t_arm_nota.arm_nota_mercadoria%Type,
                               pQtdeVolume   in tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                               pPesoNota     in tdvadm.t_arm_nota.arm_nota_peso%type,
                               pPesoBalanca  in tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                               pCubagem      in tdvadm.t_arm_nota.arm_nota_cubagem%type,
                               pChaveNfe     in tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                               pCfop         in tdvadm.t_arm_nota.glb_cfop_codigo%type,
                               pDi           in tdvadm.t_arm_nota.arm_nota_di%type,
                               pContrato     in tdvadm.t_arm_nota.slf_contrato_codigo%type,
                               pTpRequis     in tdvadm.t_arm_nota.arm_nota_tabsol%type,
                               pRequisCod    in tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                               pSaqueRequis  in tdvadm.t_arm_nota.arm_nota_tabsolsq%type,
                               pCodOnu       in tdvadm.t_arm_nota.arm_nota_onu%type,
                               pGrpEmbOnu    in tdvadm.t_arm_nota.arm_nota_grpemb%type,
                               pColeta       in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                               pTpColeta     in tdvadm.t_arm_nota.arm_coleta_tpcompra%type,
                               pPO           in tdvadm.t_arm_nota.xml_notalinha_numdoc%type,     
                               pNotaVide     in tdvadm.t_arm_nota.arm_nota_vide%type,
                               pUsuario      in tdvadm.t_arm_nota.usu_usuario_codigo%type,             --Usuario que está fazendo a inserção da nota
                               pVideSeq      In Integer,
                               pVideNumNota  In Integer,
                               pVideSerie    In Char,
                               pVideCnpj     In Char,
                               pStatus       out char,
                               pMessage      out Varchar2 );
                           
  /**************************************************************************************************************************************/
  /* Procedure utilizada para buscar a Descrição das Mercadorias. A busca só pode retornar um registro                                  */                           
  /**************************************************************************************************************************************/
  procedure sp_buscadDescMerc( pCodMercadoria  in tdvadm.t_glb_mercadoria.glb_mercadoria_codigo%type,
                               pStatus         out char,
                               pMessage        out varchar2,
                               pCursor         out T_CURSOR);
 
  /**************************************************************************************************************************/
  /* Procedure responsável por excluir a nota fiscal                                                                        */                            
  /**************************************************************************************************************************/
  procedure sp_excluirNota( pUsuario         in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                            pRota            in tdvadm.t_glb_rota.glb_rota_codigo%type,
                            pNumeroNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pDataEmissao     in varchar2,
                            pCnpjRemetente   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pCnpjDestino     in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pColeta          in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pEmbalagem       in tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pStatus          out char,
                            pMessage         out varchar2 );
                            
procedure sp_criaCarregamento2( pCodArmazem   in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                                pUsuario      in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                pCodCarreg    Out Varchar2,
                                pStatus       out char,
                                pMessage      out Varchar2
                                );
                            
-- Procedure que será utilizada como ancoragem.
Procedure SP_Execute( pXmlIn in Varchar2,
                      pXmlOut out clob
                     );

 -- Procedure Utilizada para verificar se existe alguma Regra ou Tabela / Solicitacao para o Cliente.
 Procedure SP_GET_REGRACONTRATO( pParamsEntrada   In Varchar2,
                                 pStatus          Out Char,
                                 pMessage         Out Varchar2,
                                 pParamsSaida     Out Clob);

 -- Funcao simplificada para uso do Procedure acima.
 Function fn_Get_TemREGRACONTRATO(pCNpj    in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                  pColeta  in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                  pEntrega in tdvadm.t_glb_localidade.glb_localidade_codigo%type)
    Return char;

  -- pROCEDURA PARA RETORNAR O TIPO DE CARGA PARA A TELA DE NOTAS DO RECEBIMENTO
 Procedure SP_GET_TPCARGA( pCursor out tdvadm.pkg_fifo.T_CURSOR,
                           pStatus out char,
                           pMessage out varchar2);

end pkg_fifo;
/
create or replace package body pkg_fifo is

--sp_arm_retornaDadosColeta

/************************************************************************************************************************/
/*                       PROCEDURES PÚBLICAS PARA O PROJETO OU NÃO CLASSIFICADAS                                        */
/************************************************************************************************************************/

/************************************************************************************************************************/
/*                       PROCEDURES PÚBLICAS PARA O PROJETO OU NÃO CLASSIFICADAS                                        */
/************************************************************************************************************************/
/************************************************************************************************************************/
/*                          PROCEDURES UTILIZADAS PELA ABA DO CARREGAMENTO DO FIFO                                      */
/************************************************************************************************************************/

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 05-02-2016
* Alimenta          : Cursor com a Embalagem capturada através da chave NFE
* Funcionalidade    : 
* Particularidades  :
* Param.Obrigatórios: pChaveNfe
*********************************************************************************************/
PROCEDURE sp_getChaveNfe( pChaveNfe in tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                               pStatus      out char,
                               pMessage     out varchar2,
                               pCursor      out tdvadm.pkg_fifo.T_CURSOR) as
                               
BEGIN
  begin
    pStatus := tdvadm.pkg_fifo.Status_Normal;
    pMessage := '';
    /* Cursor com relação de carregamentos não fechados, de um determindado armazem */
    -- 04/05/2022 - Sirlano
    -- Coloquei para pegar a maior sequencia da nota
    open pCursor for
      SELECT
         N.Arm_Nota_Chavenfe ChaveNfe,
         N.Arm_Embalagem_Numero Embalagem_Numero 
      FROM tdvadm.t_Arm_Nota N
      Where N.Arm_Nota_Chavenfe = pChaveNfe
        and n.arm_nota_sequencia = (select max(n1.arm_nota_sequencia)
                                    From t_Arm_Nota N1
                                    Where n1.arm_nota_chavenfe = n.arm_nota_chavenfe);
         
      pStatus :=  pkg_fifo.Status_Normal;
      pMessage := '';         
  exception
    when others then
      pStatus := tdvadm.pkg_fifo.Status_Erro;
      pMessage := 'Erro ao gerar cursor com dados basicosde carregamento. '||chr(13)|| sqlerrm;
   end;    
  

END sp_getChaveNfe;

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 13-01-2016
* Alimenta          : Variável de saída pFreteDedicado
* Funcionalidade    : Verifica se o frete é uma transferência VLI e Dedicado
* Particularidades  :
* Param.Obrigatórios: pArm_Embalgem_Numero, pArm_Embalagem_Sequencia
*********************************************************************************************/
Procedure sp_FreteDedicado(     pArm_Embalagem_Numero In Varchar2,
                                pArm_Embalagem_Sequencia In Varchar2,
                                pFreteDedicado Out Char,
                                pStatus Out Char,
                                pMessage Out Varchar2) 
AS
vCnpjOrig t_arm_nota.Glb_Cliente_Cgccpfremetente%type;
vCnpjDest t_arm_nota.Glb_Cliente_Cgccpfdestinatario%type;                            
Begin
  Begin
      select nf.glb_cliente_cgccpfremetente, nf.glb_cliente_cgccpfdestinatario
      into vCnpjOrig, vCnpjDest
      from t_Arm_nota nf 
      where nf.arm_embalagem_numero = pArm_Embalagem_Numero
      and nf.Arm_Embalagem_Sequencia= pArm_Embalagem_Sequencia;

     if( FN_TransferenciaVli(vCnpjOrig,vCnpjDest) = true ) Then 
       pkg_fifo_carregamento.sp_VliFreteDedicado(pArm_Embalagem_Numero,
                                                  pArm_Embalagem_Sequencia,
                                                  pFreteDedicado,
                                                  pStatus,
                                                  pMessage); 
     Else
        pFreteDedicado := 'N';                                              
        pStatus :=  pkg_fifo.Status_Normal;
        pMessage := '';
     End if;
  Exception When Others Then
    pStatus := STATUS_ERRO;
    pMessage := dbms_utility.format_error_backtrace;
  End;
End sp_FreteDedicado;                                


/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 13-01-2016
* Alimenta          : Variável de saída pFreteDedidado, pFreteOutros
* Funcionalidade    : Verifica se existem fretes dedicados ou outros em um carregamento
* Particularidades  :
* Param.Obrigatórios: pArm_Carregamento_Codigo
*********************************************************************************************/
                                         
Procedure sp_GetTiposFrete(     pArm_Carregamento_Codigo In Varchar2,
                                pFreteDedicado Out Char,
                                pFreteOutros Out Char,
                                pStatus Out Char,
                                pMessage Out Varchar2)
AS
vFreteDedicado Char;
Begin
  Begin
    pFreteDedicado := 'N';
    pFreteOutros   := 'N';
    declare Cursor CurCarreg is
    
    select x.glb_cliente_cgccpfcodigo GLB_CLIENTE_CGCCPFREMETENTE, x.glb_cliente_cgccpfdestinatario, x.arm_embalagem_numero, x.arm_embalagem_sequencia
    from t_arm_carregamentodet x where trim(x.arm_carregamento_codigo) = pArm_Carregamento_Codigo;

    Begin
      for RegCarreg in CurCarreg 
        Loop
          if( FN_TransferenciaVli(RegCarreg.GLB_CLIENTE_CGCCPFREMETENTE,RegCarreg.Glb_CLIENTE_CGCCPFDESTINATARIO) = true ) Then 
            pkg_fifo_carregamento.sp_VLIGetTiposFrete( RegCarreg.arm_embalagem_numero ,RegCarreg.Arm_Embalagem_sequencia,
                              pFreteDedicado,
                              pFreteOutros,
                              pStatus,
                              pMessage);    
          End If;
        End Loop;
    End;
    
    pStatus :=  pkg_fifo.Status_Normal;
    pMessage := '';
  Exception When Others Then
    pStatus := Status_ERRO;
    pMessage:= dbms_utility.format_error_backtrace;
  End;
End sp_GetTiposFrete;                                

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 01/03/2016
* Alimenta          : Variável de saída pQuimico e pNQuimico
* Funcionalidade    : Verifica se existem Produtos Quimicos e Não Quimicos no Carregamento
* Particularidades  :
* Param.Obrigatórios: pArm_Carregamento_Codigo
*********************************************************************************************/
                                         
Procedure sp_GetTiposEmerg(     pArm_Carregamento_Codigo In Varchar2,
                                pEmbalagem in Varchar2,
                                pSeqEmbalagem in Varchar2,
                                pQuimico Out Char,
                                pNQuimico Out Char,
                                pStatus Out Char,
                                pMessage Out Varchar2)
AS
vQuimico  Varchar2(50);
vNQuimico  Varchar2(50);
cnpj Varchar(50);
Begin
  Begin
    vQuimico := 'N';
    vNQuimico   := 'N';

    
    declare Cursor CurCnpj is
    
    select distinct(x.glb_cliente_cgccpfsacado) as cnpj 
    from t_arm_nota x where trim(x.arm_embalagem_numero) = pEmbalagem 
    and x.Arm_Embalagem_Sequencia = pSeqEmbalagem;
    
    Begin
      for RegCnpj in CurCnpj
        Loop
        if( trim(RegCnpj.cnpj) in ('61409892000335','61409892021766') ) Then 
             pkg_fifo_carregamento.sp_CBAGetTiposEmerg( pEmbalagem ,
                                pSeqEmbalagem,
                                pQuimico,
                                pNQuimico,
                                pStatus,
                                pMessage);    
              if( pQuimico  = 'S' ) Then
                  vQuimico := 'S';
              End If;
              if( pNQuimico = 'S' ) Then
                  vNQuimico:= 'S';
              End If;
            End If;
          
        End Loop;
    End;
    

    
    declare Cursor CurCarreg is

    select nt.glb_cliente_cgccpfsacado GLB_CLIENTE_CGCCPFSACADO, x.glb_cliente_cgccpfdestinatario, x.arm_embalagem_numero, x.arm_embalagem_sequencia
    from t_arm_carregamentodet x,
    t_arm_nota nt
    
    where nt.arm_carregamento_codigo = x.arm_carregamento_codigo
    and trim(x.arm_carregamento_codigo) = pArm_Carregamento_Codigo;

    Begin
      for RegCarreg in CurCarreg 
        Loop
          if( trim(RegCarreg.GLB_CLIENTE_CGCCPFSacado) in ('61409892000335','61409892021766') ) Then 
            pkg_fifo_carregamento.sp_CBAGetTiposEmerg( RegCarreg.arm_embalagem_numero ,RegCarreg.Arm_Embalagem_sequencia,
                              pQuimico,
                              pNQuimico,
                              pStatus,
                              pMessage);    
            if( pQuimico  = 'S' ) Then
                vQuimico := 'S';
            End If;
            if( pNQuimico = 'S' ) Then
                vNQuimico:= 'S';
            End If;
          End If;
        End Loop;
    End;
    pQuimico := vQuimico;
    pNQuimico := vNQuimico;    
    pStatus :=  pkg_fifo.Status_Normal;
    pMessage := '';
  Exception When Others Then
    pStatus := Status_ERRO;
    pMessage:= dbms_utility.format_error_backtrace;
  End;
End sp_GetTiposEmerg;  


/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 08-01-2016
* Alimenta          : Cursor
* Funcionalidade    : Procedure utilizada para retornar um cursor com os dados das embalagens ainda não carregadas
                      Essa proceure é utilizada para popular o grid superior da aba FIFO - "Carregamento"
                      O corpo dessa procedure está no package "pkg_fifo_CARREGAMENTO"
                      Nesta versão, foi adicionado o filtro por contrato                      
* Particularidades  :
* Param.Obrigatórios: pDataIni, pDataFim, pContrato
*********************************************************************************************/

Procedure sp_ListaCarregamentoEmbContr(pArmazem In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                        pDataIni  In  Varchar2,
                                        pDataFim  In  Varchar2,
                                        pContrato In Varchar2,
                                        pArm_Coleta_NCompra In Varchar2,
                                        pArm_Coleta_Ciclo In Varchar2,
                                        pTipoCarga In Varchar2,                                        
                                        pCursor  Out T_CURSOR,
                                        pStatus  Out Char,
                                        pMessage Out Varchar2) As
vCliente Varchar2(50);                                        
vTipoCarga Varchar(50);
vCNPJ_ORIG T_ARM_Nota.Glb_Cliente_Cgccpfremetente%Type;
vCNPJ_DEST T_ARM_Nota.Glb_Cliente_Cgccpfdestinatario%Type;
vUsuario tdvadm.v_glb_ambiente.os_user%type;
vMaquina tdvadm.v_glb_ambiente.terminal%type;
vPrograma varchar2(25) := 'prj_carregamento.exe';
vQtdeSessoes integer;
Begin
  Begin

  vCliente := 'DEFAULT';
  
  -- Verifica quantas sessoes o usuario tem abertas no fifo
  select a.os_user,
         a.terminal
    into vUsuario,
         vMaquina
  from tdvadm.v_glb_ambiente a; 
  
  select count(*)
    into vQtdeSessoes
  from tdvadm.v_kill_sessoes k
  where k.PROGRAM = vPrograma
    and k.OSUSER = vUsuario;
    
  
  If vQtdeSessoes >= 5 Then
    pStatus  := 'E';
    pMessage := 'EXCEDEU O NUMERO MAXIMO DE SESSOES ABERTAS DO FIFO. QTDE - ' || TRIM(TO_CHAR(vQtdeSessoes));
    return;
  End If;   
  

    
  if( pArm_Coleta_NCompra <> '%' ) Then 
      Begin
        declare cursor curVli is
        SELECT x.Glb_Cliente_Cgccpfremetente as Remetente,
                x.Glb_Cliente_Cgccpfdestinatario as Destinatario
         FROM T_ARM_NOTA X, t_glb_cliente cli 
         WHERE X.ARM_COLETA_NCOMPRA = PARM_COLETA_NCOMPRA 
         AND   X.ARM_COLETA_CICLO = PARM_COLETA_CICLO
         AND   X.Glb_Cliente_Cgccpfsacado = cli.glb_cliente_cgccpfcodigo
         AND cli.glb_grupoeconomico_codigo = '0074';
        BEGIN
          for RegVli in curVli 
              loop
              if( pArm_Coleta_NCompra <> '%' and pkg_fifo.FN_TransferenciaVli(RegVli.Remetente, RegVli.Destinatario) = true) Then
                   vCliente := 'VLI';
                   exit;
              end if;
            end loop;
        End; 
      END;
   End if;
  
   if(pTipoCarga = '%') Then
     vTipoCarga := '''01'',''02'',''03'',''DD'',''FF''';
   End If;
   -- Chama a procedure de acordo com o Cliente                                          
   if( vCliente = 'VLI' ) Then
     pkg_fifo_Carregamento.sp_VliListaCarregEmbContr( pArmazem,     
                                                       pDataIni,
                                                       pDataFim,
                                                       pContrato,
                                                       pTipoCarga,
                                                       pCursor,
                                                       pStatus,
                                                       pMessage
                                                     );
   End If;
   if( vCliente = 'DEFAULT' ) Then
     pkg_fifo_carregamento.sp_DEF_ListaCarregEmbContr( pArmazem,
                                                         pDataIni,
                                                         pDataFim,
                                                         pContrato,
                                                         pTipoCarga,
                                                         pCursor,
                                                         pStatus,
                                                         pMessage
                                                       );
   End If;
  Exception WHEN OTHERS THEN
    pStatus := STATUS_ERRO;
    pMessage := dbms_utility.format_error_backtrace; 
  End;  
End sp_ListaCarregamentoEmbContr; 
/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 14-01-2016
* Alimenta          : Retorna True ou False
* Funcionalidade    : Verifica se os CNPJS são do grupo economico VLI
* Particularidades  :
* Param.Obrigatórios: 
*********************************************************************************************/
  FUNCTION FN_TransferenciaVli(pCnpjOrig IN Varchar2, pCnpjDest IN Varchar2) Return Boolean 
  IS
   vGrupo1 Varchar2(10);
   vGrupo2 Varchar2(10);
  BEGIN  
    
  select x.glb_grupoeconomico_codigo into vGrupo1
  from t_glb_cliente x
  where trim(x.glb_cliente_cgccpfcodigo) = trim(pCnpjOrig);
  
  select x.glb_grupoeconomico_codigo into vGrupo2
  from t_glb_cliente x
  where trim(x.glb_cliente_cgccpfcodigo) = trim(pCnpjDest);
  
  if( vGrupo1 = vGrupo2 ) Then
    Return true;
  else
    Return false;
  End If;
  END FN_TransferenciaVli;
  

/********************************************************************************************
* Programa          : FIFO
* Desenvolvedor     : Anderson Fábio
* Data de Criação   : 11-01-2016
* Alimenta          : Cursor com os dados da nota e do contrato de um carregamento
* Funcionalidade    : Verifica se existem fretes dedicados ou outros em um carregamento
* Particularidades  :
* Param.Obrigatórios: pCodigoCarregamento
*********************************************************************************************/
Procedure sp_getNumContr(               pCodigoCarregamento In  Varchar2,
                                        pCursor  Out T_CURSOR,
                                        pStatus  Out Char,
                                        pMessage Out Varchar2) 
As
Begin
  Begin
  pkg_fifo_carregamento.sp_getNumContr( pCodigoCarregamento,
                                        pCursor,
                                        pStatus,
                                        pMessage
                                        );
  EXCEPTION WHEN OTHERS THEN
    pStatus := STATUS_ERRO;
    pMessage := dbms_utility.format_error_backtrace;
  End;
End sp_getNumContr; 

------------------------------------------------------------------------------------------------------------------------
-- Procedure responsável por retorna um cursor com os dados da Filial                                                 --
------------------------------------------------------------------------------------------------------------------------
PROCEDURE SP_LISTAFILIAL( pUsuApp  In  tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                          pCursor  Out T_CURSOR,         
                          PStatus  Out Char,
                          pMessage Out Varchar2) as
BEGIN
  ---------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para retornar um cursor com os dados da Filial passando como paramentro o Usuaário          --
  -- Essa proceure é utilizada para popular o combo que fica no formulário principal, na carga do sistema            --
  -- O corpo dessa procedure está no package "pkg_fifo_AUXILIAR                                                      --  
  ---------------------------------------------------------------------------------------------------------------------
  pkg_fifo_AUXILIAR.SP_LISTAFILIAL( PUSUAPP, 
                                    PCURSOR, 
                                    PSTATUS, 
                                    PMESSAGE 
                                  );
    
END SP_LISTAFILIAL;

------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para administrar a Trava do Sistema                                                            --                            
------------------------------------------------------------------------------------------------------------------------
Procedure sp_TravaFIFO( pParamsEntrada In  Varchar2,
                        pStatus        Out Char,
                        pMessage       Out Varchar2,
                        pParamsSaida   Out Clob
                       ) Is 
Begin
  pStatus := pkg_glb_common.Status_Warning;
  pMessage := 'Procedure em Desenvolvimento';
  
End;                         

/************************************************************************************************************************/
/*                          PROCEDURES UTILIZADAS PELA ABA DO CARREGAMENTO DO FIFO                                      */
/************************************************************************************************************************/
------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para popular o Gride de Embalagens na Aba do "Fifo - 'Carregamento'"                           --
------------------------------------------------------------------------------------------------------------------------
Procedure sp_ListaCarregamentoEmbalagem(pArmazem In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                        pDataIni In  Varchar2,
                                        pDataFim In  Varchar2,
                                        pCursor  Out T_CURSOR,
                                        pStatus  Out Char,
                                        pMessage Out Varchar2) As
Begin
  ---------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para retornar um cursor com os dados das embalagens ainda não carregadas              --
  -- Essa proceure é utilizada para popular o grid superior da aba FIFO - "Carregamento"                       --
  -- O corpo dessa procedure está no package "pkg_fifo_CARREGAMENTO"                                           --  
  ---------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_ListaCarregamentoEmbalagem( pArmazem,
                                                       pDataIni,
                                                       pDataFim,
                                                       pCursor,
                                                       pStatus,
                                                       pMessage
                                                     );
    
End sp_ListaCarregamentoEmbalagem; 

------------------------------------------------------------------------------------------------------------------------
-- Procedure que retorna um cursor com as notas a partir de uma embalagem                                             --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getNotaEmbalagens( pNumEmb  in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                                pSeqEmb  in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                                pFlagemb in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                                pStatus   out char,
                                pMessagem out varchar2,
                                pCursor   out pkg_fifo.T_CURSOR ) as
begin
  ---------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para retornar um cursor com os dados das nota a partir de uma embalagem               --
  -- O corpo dessa procedure está no package "pkg_fifo_CARREGAMENTO"                                           --  
  ---------------------------------------------------------------------------------------------------------------
   pkg_fifo_carregamento.sp_getNotaEmbalagens( pNumEmb,
                                               pSeqEmb,
                                               pFlagemb,
                                               pStatus,
                                               pMessagem,
                                               pCursor);
  
  
end sp_getNotaEmbalagens;

------------------------------------------------------------------------------------------------------------------------
-- procedure que retorna um cursor com detalhes de embalagem a partir de um carregamento                              --
------------------------------------------------------------------------------------------------------------------------ 
procedure sp_getEmbCarregamento( pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pStatus    out char,
                                 pMessage   out varchar2,
                                 pCursor    out tdvadm.pkg_fifo.T_CURSOR ) as
begin
  ---------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para retornar um cursor com os dados das embalagens  a partir de um Carregamento      --
  -- O corpo dessa procedure está no package "pkg_fifo_CARREGAMENTO"                                           --  
  ---------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_getEmbCarregamento( pCodCarreg,
                                               pStatus,
                                               pMessage,
                                               pCursor );
end sp_getEmbCarregamento;                                 
                                

------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para buscar dados da Nota tendo os paramentros presentes na Aba do Carregamento                --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getDadosNotaCarreg( pNumNota   in  tdvadm.t_arm_nota.arm_nota_numero%type,
                                 pCnpjRemet in  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                 pEmbNumero in  tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                                 pEmbFlag   in  tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                                 pEmbSeq    in  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                                 pColeta    in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                                 pCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pStatus    out char,
                                 pMessage   out varchar2,
                                 pCursor    out T_CURSOR ) AS
BEGIN
  ---------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para retornar Cursor com dados de Notas Fiscais,                                            --
  -- Essa procedure será utilizada na ABA CARREGAMENTO DO FIFO                                                       --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                    -- 
  ---------------------------------------------------------------------------------------------------------------------
  TDVADM.pkg_fifo_CARREGAMENTO.SP_GETDADOSNOTACARREG( pNumNota,
                                                      pCnpjRemet,
                                                      pEmbNumero,
                                                      pEmbFlag,
                                                      pEmbSeq,
                                                      pColeta,
                                                      pCarreg,
                                                      pStatus,
                                                      pMessage,
                                                      pCursor);
END SP_GETDADOSNOTACARREG;                                 

------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para buscar dados da Nota tendo os paramentros presentes na Aba do Carregamento                --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getDadosNotaCarreg2( pNumNota   in  tdvadm.t_arm_nota.arm_nota_numero%type,
                                 pCnpjRemet in  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                 pEmbNumero in  tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                                 pEmbFlag   in  tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                                 pEmbSeq    in  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                                 pColeta    in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                                 pCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pCnpjDest  in  tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                 pStatus    out char,
                                 pMessage   out varchar2,
                                 pCursor    out T_CURSOR ) AS
BEGIN
  ---------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para retornar Cursor com dados de Notas Fiscais,                                            --
  -- Essa procedure será utilizada na ABA CARREGAMENTO DO FIFO                                                       --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                    -- 
  ---------------------------------------------------------------------------------------------------------------------

 TDVADM.pkg_fifo_CARREGAMENTO.SP_GETDADOSNOTACARREG2( pNumNota,
                                                      pCnpjRemet,
                                                      pEmbNumero,
                                                      pEmbFlag,
                                                      pEmbSeq,
                                                      pColeta,
                                                      pCarreg,
                                                      pCnpjDest,
                                                      pStatus,
                                                      pMessage,
                                                      pCursor);
END SP_GETDADOSNOTACARREG2;   

------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para buscar os carregamentos de um Armazem                                                     --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getcarregamentos( pCodArmazem   in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pStatus      out char,
                               pMessage     out varchar2,
                               pCursor      out T_CURSOR) as
begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para retornar um cursor com os dados básicos de um carregamento.                               --
  -- Essa procedure é utilizada para popular o grid de carregamentos não fechados "ABA CARREGAMENTO" do fifo            --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  tdvadm.pkg_fifo_carregamento.SP_GETCARREGAMENTOS( pCodArmazem,
                     pStatus,
                     pMessage,
                     pCursor);  
  
END SP_GETCARREGAMENTOS;    


-- Procedure para prorrogar notas vencidas
-- Anderson Fábio
-- 17/03/2016
procedure SP_AUTORIZA_NF(pArm_Nota_Numero in tdvadm.t_arm_notaliberacao.arm_nota_numero%type,
                         pGlb_cliente_cgcCpfCodigo in tdvadm.t_arm_notaliberacao.glb_cliente_cgccpfcodigo%type,
                         pArm_Nota_Serie in tdvadm.t_arm_notaliberacao.arm_nota_serie%type,
                         parm_notaLiberacao_dtlib in tdvadm.t_arm_notaliberacao.arm_notaliberacao_dtlib%type,
                         parm_notaLiberacao_Validade in tdvadm.t_Arm_Notaliberacao.arm_notaliberacao_validade%type,
                         parm_notaLiberacao_origem in tdvAdm.t_Arm_NotaLiberacao.Arm_Notaliberacao_Origem%type,
                         parm_notaLiberacao_usuario in tdvadm.t_arm_notaliberacao.usu_usuario_codigo%type,
                         pStatus       out char,
                         pMessage      out Varchar2
                         )
as                                                  
Begin
  Begin                                                
  insert into t_Arm_Notaliberacao 
  (Arm_Nota_Numero, Glb_Cliente_Cgccpfcodigo, Arm_Nota_Serie, arm_NotaLiberacao_dtlib, arm_notaLiberacao_validade,
  arm_notaliberacao_origem, usu_usuario_codigo)
  values
  (pArm_Nota_Numero, pGlb_Cliente_Cgccpfcodigo, pArm_Nota_Serie, parm_NotaLiberacao_dtlib, parm_notaLiberacao_validade,
  parm_notaliberacao_origem, parm_notaLiberacao_usuario);

    pStatus := Status_Normal;
    pMessage := '' ;
    Commit;
  Exception
    When Others Then
      pStatus := pkg_fifo.Status_Normal;
      pMessage := 'Erro ao criar autorizacao de nfe.'||chr(13)||Sqlerrm;
  End;

End SP_AUTORIZA_NF;
------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para criar um carregamento                                                                     --
------------------------------------------------------------------------------------------------------------------------
procedure sp_criaCarregamento2( pCodArmazem   in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                                pUsuario      in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                pCodCarreg    Out Varchar2,
                                pStatus       out char,
                                pMessage      out Varchar2
                                ) As
 vNumCarreg Integer;                               
Begin
  -- pkg_fifo.sp_criaCarregamento2
  Begin
    /* pega o maior numero do carregamento +1 para ser o novo carregamento */
    Select Max(to_number(arm_carregamento_codigo)) +1 
    Into vNumCarreg 
    from t_arm_carregamento;
    
    /* Cria o novo carregamento. */
    Insert Into t_arm_carregamento ( arm_carregamento_codigo,
                                     arm_armazem_codigo, 
                                     usu_usuario_crioucarreg 
                                    ) 
                                    Values
                                    (
                                      vNumCarreg,
                                      pCodArmazem,
                                      pUsuario
                                    );
    /* Não ocorrendo nenhum erro, encerra a procedure */
    pStatus := Status_Normal;
    pMessage := '' ;
    
    pCodCarreg := vNumCarreg;
    Commit;
    
    
    
  Exception
    When Others Then
      pStatus := pkg_fifo.Status_Normal;
      pCodCarreg := '';
      pMessage := 'Erro ao criar carregamento.'||chr(13)||Sqlerrm;
  End;
         
end sp_criaCarregamento2;                               

Procedure sp_getNumContrTabela( pSlf_tabela_codigo In  Varchar2,
                                pCursor Out pkg_fifo.T_CURSOR,
                                pStatus  Out Char, 
                                pMessage Out Varchar2)
Is
Begin
  begin
    Open pCursor For
         select x.slf_tabela_contrato as slf_contrato_codigo
         from t_slf_tabela x
         where x.slf_tabela_codigo = pSlf_tabela_codigo;
         
      pStatus := pkg_fifo.Status_Normal;
      pMessage := '';         
   exception
     when others then
       pStatus := pkg_fifo.Status_Erro;
       pMessage := dbms_utility.format_error_backtrace;
    end;
End;

Procedure sp_getNumContrSolicitacao( pSlf_solfrete_codigo In  Varchar2,
                                     pCursor Out pkg_fifo.T_CURSOR,
                                     pStatus  Out Char, 
                                     pMessage Out Varchar2)
Is
Begin
  begin
    Open pCursor For
         select x.slf_solfrete_contrato
         from t_slf_solfrete x
         where x.slf_solfrete_codigo = pSlf_solfrete_codigo;
         
      pStatus := pkg_fifo.Status_Normal;
      pMessage := '';         
   exception
     when others then
       pStatus := pkg_fifo.Status_Erro;
       pMessage := dbms_utility.format_error_backtrace;
    end;
End;

Procedure sp_getNumContrSacado( pGlb_cliente_cgccpfcodigo In  Varchar2,
                                pCursor Out pkg_fifo.T_CURSOR,
                                pStatus  Out Char, 
                                pMessage Out Varchar2)
Is
Begin
  begin
    Open pCursor For
         select x.slf_contrato_codigo,c.slf_contrato_descricao
         from tdvadm.t_Glb_Clientecontrato x,
              tdvadm.t_slf_contrato c
         where trim(x.glb_cliente_cgccpfcodigo) = trim(pGlb_cliente_cgccpfcodigo)
           and x.glb_clientecontrato_ativo = 'S'
           and x.slf_contrato_codigo = c.slf_contrato_codigo
         order by x.glb_clientecontrato_dtcadastro;
         
      pStatus := pkg_fifo.Status_Normal;
      pMessage := '';         
   exception
     when others then
       pStatus := pkg_fifo.Status_Erro;
       pMessage := dbms_utility.format_error_backtrace;
    end;
End;


------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para excluir um carregamento                                                                   --
------------------------------------------------------------------------------------------------------------------------
procedure sp_excluiCarregamento( pCodCarregamento in  tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pStatus          out char,
                                 pMessage         out varchar2) as
begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada excluir um carregamento pelo fifo                                                              --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_excluiCarregamento( pCodCarregamento,
                                               pStatus,
                                               pMessage
                                             );
  
  
end;                           

------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para vincular as Embalagens em um carregamento                                                  --
------------------------------------------------------------------------------------------------------------------------
procedure sp_VinculaEmbCarreg( pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                               pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                               pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                               pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                               pStatus       out char,
                               pMessage      out varchar2) as 
begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada vincular uma embalagem a um carregamento, e atualiza os pesos nos carregamentos                --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_VinculaEmbCarreg( pCodCarreg,
                                             pNumEmb,
                                             pFlgEmb,
                                             pSeqEmb,
                                             pStatus,
                                             pMessage
                                           );
end sp_VinculaEmbCarreg; 

--Procedure utilizada para vincular uma lista de embalagens a um carregamento.
Procedure sp_VincListaEmbCarreg( pParamsEntrada In Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2
                               ) As
Begin                               
  pkg_fifo_carregamento.sp_VincListaEmbCarreg( pParamsEntrada,
                                               pStatus,
                                               pMessage
                                              );                                 
End sp_VincListaEmbCarreg;                                              

------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para retirar transferência de uma embalagem                                                    --
------------------------------------------------------------------------------------------------------------------------
procedure sp_RetiraTransfEmb(  pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                               pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                               pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                               pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                               pStatus       out char,
                               pMessage      out varchar2) as
begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada pare retirnar a transferência de uma embalagem                                                 --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_RetiraTransfEmb( pCodCarreg,
                                            pNumEmb,
                                            pFlgEmb,
                                            pSeqEmb,
                                            pStatus,
                                            pMessage);
                                      
  
end sp_RetiraTransfEmb;                                  

------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada descarregar uma embalagem                                                                       --
------------------------------------------------------------------------------------------------------------------------
procedure sp_DescarregaEmb( pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                            pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                            pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                            pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                            pStatus       out char,
                            pMessage      out varchar2) as 
begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada pare descarregar a embalagem                                                                   --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_DescarregaEmb( pCodCarreg,
                                          pNumEmb,
                                          pFlgEmb,
                                          pSeqEmb,
                                          pStatus,
                                          pMessage );
end sp_DescarregaEmb;

/***************************************************************************************************************/
/* RELAÇÃO DE PROCEDURES UTILIZADA NAS ROTINAS DE CHEKIN                                                       */
/***************************************************************************************************************/

  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para gerar relação de embalagens transferidas para o Armazem do usuario.                       --       
  ------------------------------------------------------------------------------------------------------------------------
Procedure sp_getEmbTransferidas( pUsuario In Varchar2 Default null,
                                 pParamsEntrada In Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2,
                                 pParamsSaida   Out Clob ) As
Begin                                 
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada gerar lista de embalagens transferidas para o armazem do usuário.                              --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_getEmbTransferidas( pUsuario,
                                               pParamsEntrada,
                                               pStatus, 
                                               pMessage,
                                               pParamsSaida
                                              );

End;



/*
#########################################################################################################################                                                                                                                         
##                                 PROCEDURES UTILIZADAS PELA ABA DO CTRC                                              ##
#########################################################################################################################/*
/************************************************************************************************************************/
/** PROCEDURE UTILIZADA PARA POPULAR O GRID PRINCIPAL DA ABA CTRC.                                                     **/  
/************************************************************************************************************************/
Procedure sp_AtualizaGridCtrc( pParamsEntrada In Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2,
                                 pParamsSaida   Out Clob 
                               ) As
Begin
  
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada gerar lista de carregamento sem emitir Vale de Frete.                                          --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CTRC"                                                               --
  ------------------------------------------------------------------------------------------------------------------------
  pkg_fifo_ctrc.sp_AtualizaGridCtrc( pParamsEntrada, pStatus, pMessage, pParamsSaida );
  
End;  

/************************************************************************************************************************/
/** PROCEDURE UTILIZADA PARA ATUALIZAR O GRID DO FORMULÁRIO CTRCDET.                                                   **/ 
/************************************************************************************************************************/
Procedure sp_AtalizaGridCtrcDet( pParamsEntrada  In   Varchar2,
                                 pStatus         Out  Char,
                                 pMessage        Out  Varchar2,
                                 pParamsSaida    Out  Clob  
                                ) As

Begin
  
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada relizar atualização no grid CTRCDET. 
  pkg_fifo_ctrc.sp_AtalizaGridCtrcDet( pParamsEntrada, pStatus, pMessage, pParamsSaida);
  
End sp_AtalizaGridCtrcDet;

/************************************************************************************************************************/
/** PROCEDURE UTILIZADA PARA REALIZAR VUNCULAÇÃO DE UMA LISTA DE CARREGAMENTOS A UM VEICULOS                          **/ 
/************************************************************************************************************************/
procedure sp_set_VincListaCarreg( pParamsEntrada In Varchar2,
                                  pStatus        Out Char,
                                  pMessage       Out Varchar2,
                                  pParamsSaida   Out Clob 
                               ) As                
begin

  --Procedure utilizada para realizar uma vinculação de vários carregamentos em um único veiculos.
  --o retorno é um XML com 3 tabelas, que devem atualizar os tres grids da aba do CTRC no fifo.
  --o corpo da procedure está no package "pkg_fifo_CTRC"
  pkg_fifo_ctrc.sp_set_VincListaCarreg( pParamsEntrada,
                                        pStatus,
                                        pMessage,
                                        pParamsSaida
                                      );
  
end sp_set_VincListaCarreg; 

/************************************************************************************************************************/
/** PROCEDURE UTILIZADA PARA GERAR MANIFESTO.                                                                          **/ 
/************************************************************************************************************************/
Procedure sp_GerarManifesto( pParamsEntrada In Varchar2,
                             pStatus        Out Char,
                             pMessage       Out Varchar2
                           ) As                              
Begin
   --Essa procedure é acionado através do botão "Gerar Manifesto" que está na Aba CTRC do FIFO.
   --Tem como paramentro de entrada um arquivo XML com todos os carregamentos, mais os dados básicos 
   --como aplicação, usuario e rota. A procedure entra em laço lendo carregamento a carregamento e 
   --executando a procedure "SP_INSERE_NOVOMANIFESTO". 
   pkg_fifo_ctrc.sp_GerarManifesto( pParamsEntrada, 
                                    pStatus,
                                    pMessage
                                  );
End;

/************************************************************************************************************************/
/* Procedure utilizada para retornar um carregamento da Aba do CTRc para a Aba do Fifo.                                */
/************************************************************************************************************************/
Procedure sp_RetCarrgFifo( pParamsEntrada  In Varchar2,
                           pStatus    out char,
                           pMessage   out Varchar2) As
                           
  --Variável utilizada para recuperar os parametros passados via XML
  vUsuario        tdvadm.t_usu_usuario.usu_usuario_codigo%Type;                           
  vRotaUsuario    tdvadm.t_glb_rota.glb_rota_codigo%Type;
  vAplicacao      tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type;
  vCarreg_codigo  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type;
  vArmazem        tdvadm.t_arm_armazem.arm_armazem_codigo%Type;
  vPodeVoltar     char(1);
  vNotaSequencia  tdvadm.t_arm_nota.arm_nota_sequencia%type;
  vAuxiliar       Integer;
Begin
  --Inicializa as variáveis utilizadas 
  vUsuario := '';
  vRotaUsuario := '';
  vAplicacao := '';
  vCarreg_codigo := '';
  
  --Popula as Variáveis de paramentros.
  vUsuario       := pkg_glb_common.FN_getParams_Xml( lower(pParamsEntrada), 'usuario');
  vRotaUsuario   := pkg_glb_common.FN_getParams_Xml( lower(pParamsEntrada), 'rota');
  vAplicacao     := pkg_glb_common.FN_getParams_Xml( lower(pParamsEntrada), 'aplicacao');
  vCarreg_codigo := pkg_glb_common.FN_getParams_Xml( lower(pParamsEntrada), 'carreg_codigo');
  
  vPodeVoltar := FN_CON_PODEVOLTARCARREG(vCarreg_codigo);
  pStatus := 'N';
  
/* exemplo do xml de entrada

<Parametros>
   <Inputs>
      <input>
         <usuario>ccruz</usuario>
         <rota>160</rota>
         <aplicacao>Carreg</aplicacao>
         <carreg_codigo>1103752</carreg_codigo>
      </input>
   </Inputs>
</Parametros>

*/


  If ( vPodeVoltar = 'S') Then
    Begin
      select a.arm_armazem_codigo
        into vArmazem
        from t_arm_armazem a
        where a.glb_rota_codigo = vRotaUsuario
        and a.arm_armazem_ativo = 'S';
      Exception 
        When NO_DATA_FOUND Then
            pStatus  := Status_erro;
            pMessage := 'Favor Trocar Verificar sua Rota antes de Entrar no FIFO. Voce Esta usando a Rota ' || vRotaUsuario || ' que não tem ARMAZEM CADASTRADO!';
        End;  
      
      If pStatus <> Status_erro Then
          sp_exclui_xxx_do_carreg_teste(vCarreg_codigo);

          UPDATE T_ARM_CARREGAMENTO T
            SET T.ARM_CARREGAMENTO_QTDCTRC = '0',
                T.ARM_CARREGAMENTO_DTFECHAMENTO = null,
                T.ARM_CARREGAMENTO_QTDIMPCTRC = '0'
           WHERE 
             trim(T.ARM_CARREGAMENTO_CODIGO) = trim(vCarreg_codigo);          

           delete tdvadm.t_arm_notacte nct where trim(nct.arm_carregamento_codigo) = trim(vCarreg_codigo);  

            update tdvadm.t_arm_nota an
              set an.con_conhecimento_codigo = null,
                  an.con_conhecimento_serie = null,
                  an.glb_rota_codigo = null
            where (an.arm_embalagem_numero,
                   an.arm_embalagem_flag,
                   an.arm_embalagem_sequencia) in (select cd.arm_embalagem_numero,
                                                          cd.arm_embalagem_flag,
                                                          cd.arm_embalagem_sequencia
                                                   from tdvadm.t_arm_carregamentodet cd
                                                   where trim(cd.arm_carregamento_codigo) = trim(vCarreg_codigo))
              and an.con_conhecimento_serie = 'XXX';


          
          Begin
          -- Grava historico...
          Armadm.Pkg_Arm_Carregamento.SP_SET_HISTORICO(TRIM(vCarreg_codigo), 
                                                       'Carregamento liberado p/ fechar novamente', 
                                                       vUsuario, 
                                                       vArmazem, 
                                                       Armadm.Pkg_Arm_Carregamento.ESTAGIO_CONFERIDO, 
                                                       pStatus, 
                                                       pMessage);      
          
          pStatus:= status_normal;
          pMessage := 'Carregamento desmontado com sucesso e devolvido para a Aba do Fifo.';
      Exception 
        When Others Then
          pStatus := status_erro;
          pMessage:= 'Erro ao retornar carregamento para o fifo' || chr(13) || 'INFORMAR - ROTAUSUARIO - ' || vRotaUsuario || '-'  || sqlerrm;
        End;
     End If;

  ElsIf vPodeVoltar in ('M','D','R') Then  -- memoria de Calculo/Devolucao/Reentrega
    Begin
      sp_exclui_xxx_do_carreg_teste(vCarreg_codigo);
      
      if vPodeVoltar = 'D' Then
        select n.arm_nota_sequencia
           into vNotaSequencia
         from t_arm_notacte ncte,
              t_arm_nota n,
              t_arm_carregamentodet cd
         where cd.arm_carregamento_codigo = vCarreg_codigo
           and ncte.arm_notacte_codigo = 'DE'
           and ncte.arm_nota_numero             = n.arm_nota_numero
           and ncte.glb_cliente_cgccpfremetente = rpad(n.glb_cliente_cgccpfremetente,20)
           and ncte.arm_nota_serie              = n.arm_nota_serie
           and ncte.arm_nota_sequencia          = n.arm_nota_sequencia
           and n.arm_embalagem_numero    = cd.arm_embalagem_numero
           and n.arm_embalagem_flag      = cd.arm_embalagem_flag
           and n.arm_embalagem_sequencia = cd.arm_embalagem_sequencia;
      Elsif vPodeVoltar = 'R' Then
        select n.arm_nota_sequencia
           into vNotaSequencia
         from t_arm_notacte ncte,
              t_arm_nota n,
              t_arm_carregamentodet cd
         where cd.arm_carregamento_codigo = vCarreg_codigo
           and ncte.arm_notacte_codigo = 'RE'
           and ncte.arm_nota_numero             = n.arm_nota_numero
           and ncte.glb_cliente_cgccpfremetente = rpad(n.glb_cliente_cgccpfremetente,20)
           and ncte.arm_nota_serie              = n.arm_nota_serie
           and ncte.arm_nota_sequencia          = n.arm_nota_sequencia
           and n.arm_embalagem_numero    = cd.arm_embalagem_numero
           and n.arm_embalagem_flag      = cd.arm_embalagem_flag
           and n.arm_embalagem_sequencia = cd.arm_embalagem_sequencia;
      End If;
      

      
      FOR Carreg_Emb IN (select det.arm_carregamento_codigo,
                                det.arm_embalagem_numero,
                                det.arm_embalagem_flag,
                                det.arm_embalagem_sequencia
                         from t_arm_carregamentodet det
                         where det.arm_carregamento_codigo = vCarreg_codigo)
      Loop                     
         sp_DescarregaEmb(Carreg_Emb.Arm_Carregamento_Codigo,
                          Carreg_Emb.Arm_Embalagem_Numero,
                          Carreg_Emb.Arm_Embalagem_Flag,
                          Carreg_Emb.Arm_Embalagem_Sequencia,
                          pStatus,
                          pMessage);
      End Loop;      

      if vPodeVoltar in ('D','R') Then

-- Somente se Descarregar a nota que sera apagado o Registro
--         delete t_arm_notacte ncte
--         where ncte.arm_nota_sequencia = vNotaSequencia
--           and ncte.arm_notacte_codigo = decode(vPodeVoltar,'D','DE','RE');

         delete t_arm_carregamento_hist h
         where h.arm_carregamento_codigo = vCarreg_codigo;

         delete t_arm_carregamentodet h
         where h.arm_carregamento_codigo = vCarreg_codigo;

         update t_arm_carregamento h
           set h.fcf_veiculodisp_codigo = null,
               h.fcf_veiculodisp_sequencia = null
         where h.arm_carregamento_codigo = vCarreg_codigo;

         delete t_fcf_veiculodisp h
         where h.arm_carregamento_codigo = vCarreg_codigo;

         delete T_ARM_CARREGSTATUS h
         where h.arm_carregamento_codigo = vCarreg_codigo;

         delete t_arm_carregamento h
         where h.arm_carregamento_codigo = vCarreg_codigo;
      End If;   

      pStatus:= status_normal;
      pMessage := 'Carregamento desmontado e Embalagens liberadas com sucesso e devolvido para a Aba do Fifo.';
    Exception 
      When Others Then
        pStatus := status_erro;
        pMessage:= 'Erro ao retornar carregamento para o fifo' || chr(13) || 'INFORMAR - ' || sqlerrm;
      End;
  else
    pStatus := status_erro;
    pMessage:= 'Carregamento não pode retornar ao FIFO.' || Chr(13) || pkg_fifo.vMSGFuncRetornaCarreg;
  End If;
  
  if pStatus <> status_erro Then
     UPDATE TDVADM.T_ARM_CARREGAMENTO c
        SET C.USU_USUARIO_CONFERIUCARREG = NULL,
            C.ARM_CARREGAMENTO_DTCONFERENCIA = NULL
     WHERE C.ARM_CARREGAMENTO_CODIGO = vCarreg_codigo;
     -- Volta Estagio caso esteje como 'F'Finalizado...
     UPDATE TDVADM.T_ARM_CARREGAMENTO c
        SET C.ARM_ESTAGIOCARREGMOB_CODIGO = 'C'
     WHERE C.ARM_CARREGAMENTO_CODIGO = vCarreg_codigo
       and C.ARM_ESTAGIOCARREGMOB_CODIGO = 'F'
       AND C.ARM_CARREGAMENTO_MOBILE = 'S';

     COMMIT;     
  Else
     Rollback;
  End If;   
 

End sp_RetCarrgFifo;                           

------------------------------------------------------------------------------------------------------------------------
/**********************************************************************************************************************/
Procedure sp_DescarregaEmbagens( pParamsEntrada In  Varchar2,
                                 pStatus        Out Char,
                                 pMessage       Out Varchar2,
                                 pParamsSaida   Out Clob
                               ) As
   vParamsentrada  sys.xmltype;                               
   
   vUsuario   tdvadm.t_usu_usuario.usu_usuario_codigo%Type;
   vRota      tdvadm.t_glb_rota.glb_rota_codigo%Type;
   vAplicacao tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type;
   
   
Begin
  vParamsEntrada := xmltype.createxml(pParamsentrada); 
  
    Select 
     extractvalue(value(field), 'input/usuario'),
     extractvalue(value(field), 'input/rota'),
     extractvalue(value(field), 'input/aplicacao')
   Into 
     vUsuario,
     vRota, 
     vAplicacao
   from 
     Table(xmlsequence( Extract(vParamsEntrada  , '/Parametros/Inputs/input'))) field;
     
     RAISE_APPLICATION_ERROR(-20001, 'Usuario: '|| vusuario || ' Rota: '|| vRota || ' Aplicacao: '|| vAplicacao );

  
    
End;



------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para efeturar transferência de embalagem                                                        --
------------------------------------------------------------------------------------------------------------------------
Procedure sp_TransfereEmb( pUsuario      in varchar2 default null,
                           pCodCarreg    in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                           pNumEmb       in tdvadm.t_arm_embalagem.arm_embalagem_numero%type,
                           pFlgEmb       in tdvadm.t_arm_embalagem.arm_embalagem_flag%type,
                           pSeqEmb       in tdvadm.t_arm_embalagem.arm_embalagem_sequencia%type,
                           pArmTransf    In tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                           pStatus       out char,
                           pMessage      out varchar2) As
Begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para transferir embalagem                                                                      --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  pkg_fifo_carregamento.sp_TransfereEmb( pUsuario, 
                                         pCodCarreg,
                                         pNumEmb,
                                         pFlgEmb,
                                         pSeqEmb,
                                         pArmTransf,
                                         pStatus,
                                         pMessage);
End sp_TransfereEmb;

------------------------------------------------------------------------------------------------------------------------
--PROCEDURE UTILIZADA PARA FECHAR O CARREGAMENTO                                                                      --
------------------------------------------------------------------------------------------------------------------------
Procedure SP_FECHA_CARREGAMENTO( P_COD_CARREGAMENTO    In TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%Type,
                                 P_COD_ARMAZEM         In TDVADM.T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%Type,
                                 P_USUARIO             In TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%Type,
                                 PSTATUS              Out Char,
                                 PMESSAGE              Out Varchar2  ) As
Begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para fechar o CARREGAMENTO                                                                     -- 
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  tdvadm.pkg_fifo_Carregamento.SP_FECHA_CARREGAMENTO( P_COD_CARREGAMENTO,
                                                      P_COD_ARMAZEM,
                                                      P_USUARIO,
                                                      PSTATUS,
                                                      PMESSAGE );
End;                                                              


------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para verificar se existe Notas para Chekin para Um determinado Armazem                          --
------------------------------------------------------------------------------------------------------------------------
Procedure sp_verificaCheckin ( pUsuario    In  tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                               pCodArmazem In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                               pRota       In  tdvadm.t_glb_rota.glb_rota_codigo%Type,
                               pStatus     Out Char,
                               pMessage    Out Varchar2
                             ) As
Begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada verificar se existe embalagens transferidas para o armazen do usuario.                         -- 
  -- O corpo da procedure está no PACKOTE "pkg_fifo_CARREGAMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
   pkg_fifo_carregamento.sp_verificaCheckin( pUsuario,
                                             pCodArmazem,
                                             pRota,
                                             pStatus,
                                             pMessage
                                           );
  
End;                             

                            
/************************************************************************************************************************/
/*                               PROCEDURES UTILIZADAS PELA ABA DO RECEBIMENTO                                          */
/************************************************************************************************************************/

--PROCEDURE XML, UTILIZADA PARA RECUPERAR DADOS DE NOTAS FISCAIS.
Procedure SP_RECEB_GETNOTAS( pParamsEntrada   In Varchar2,
                             pStatus          Out Char,
                             pMessage         Out Varchar2,
                             pParamsSaida     Out Clob) As
Begin
     insert into tdvadm.t_glb_sql
    (glb_sql_instrucao, glb_sql_dtgravacao, glb_sql_programa)
  values
    (pParamsEntrada, sysdate, 'testeoracle');
  
  --PROCEDURE UTILIZADA PARA RECUPERAR DADOS DE NOTAS FISCAIS. 
  pkg_fifo_RECEBIMENTO.SP_RECEB_GETNOTAS( pParamsEntrada, pStatus, pMessage, pParamsSaida);
  
End SP_RECEB_GETNOTAS;  
                             


-- PROCEDURE XML
-- procedure usada para inserir a nota finda do RECEBIMENTO com o Tipo de escolha COLETA , XML ou NENHUM
Procedure sp_InsertNota( pParamsEntrada In blob, 
                         pStatus         Out Char,
                         pMessage       Out Varchar2,
                         pParamsSaida    Out Clob  ) As
Begin
--  insert into tdvadm.t_glb_sql values (pParamsEntrada,sysdate,'ENTRADA RECEBIMENTO','XML DE ENTRADA');
  tdvadm.pkg_fifo_recebimento.sp_InsertNota( pParamsEntrada, pStatus, pMessage, pParamsSaida);
  
End;                         
                                                   
------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para definir os tipos de documentos possíveis de busca                                         --
------------------------------------------------------------------------------------------------------------------------
Procedure sp_getTpDocBusca( pUsuario    In  Char,
                            pArmazem    In  Char,
                            pStatus     Out Char,
                            pMessage    Out Varchar2,
                            pCursor     Out t_cursOR ) As
Begin
  Begin
    pStatus := Status_normal;
    pMessage := '';
    Open pCursor For  
      Select '1' id, 'COLETA'    chave From dual
 union
      Select '2' id, 'COLETA + Chave Nfe' chave From dual
 union
      Select '3' id, 'ASN + Chave de Busca'    chave From dual
 union
      Select '4' id, 'Nota Mae - NOTA;CNPJ;SR'  chave From dual
      ;
      
      
  Exception
    When Others Then
      pStatus := Status_erro;
      pMessage := '';
    End;

End;                            


------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para buscar dados iniciais para inclusão de uma nota fiscal                                    --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getDadosIniciais( pArmazem     in   tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pUsuario     in   char,
                               pCodBusca    in   char,
                               pTpCodBusca  in   char,
                               pStatus      out  char,
                               pMessage     out  varchar2,
                               pCursor      out  T_CURSOR) as
 vTpCodConsulta char(1):= '';                               
begin
  --Caso o parametro Tipo de Busca, esteja com o código '1='Coleta - Chave NFE'
  if nvl(Trim(pTpCodBusca), 'R') = '1' then
    --Se o Código de Busca tiver 44 caracteres, quer dizer que foi passado uma chave nfe. "Busco Dados da Nota"
    if length( Trim(pCodBusca) ) = 44 then
      vTpCodConsulta := 'N';
    --Se o Código de Busca tiver 6 caracteres, quer dizer que foi passado um Número de Coleta.
    Elsif length( Trim(pCodBusca) ) = 6 then
      vTpCodConsulta := 'C';
    Elsif f_enumerico( Trim(pCodBusca) ) = 'S' then
      vTpCodConsulta := 'P';
      pStatus := 'E';
      pMessage := 'ERRO';
      return;
    end if;
    --Caso o 
  else 
    --Se o tipo de Busca não estiver em branco, repasso o código passado, para a variável de busca.
    vTpCodConsulta := Trim(pTpCodBusca);
  end if;
  
  if Trim(vTpCodConsulta) = 'P' then
    sp_getDadosPedido( pCodBusca, pArmazem, pStatus, pMessage, pCursor);
  end if;
  
  
  if Trim(vTpCodConsulta) = 'C' then
    sp_getDadosColeta( pCodBusca, pArmazem, pStatus, pMessage, pCursor);
  end if;
  
  
  
  if Trim(vTpCodConsulta) = 'N' then
    sp_getDadosNota_chaveNFE( pCodBusca, pStatus, pMessage, pCursor );
  end if;


end;                               

------------------------------------------------------------------------------------------------------------------------ 
-- Procedure que retorna um cursor com os dados de Remetente e destinatario a partir do número de uma coleta          --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getDadosPedido( pColeta  in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                               pArmazem in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pStatus  out char,
                               pMessage out varchar2,
                               pCursor  out T_CURSOR ) as
BEGIN

  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para gerar um cursor com os dados da Coleta,                                                   -- 
  -- O corpo da procedure está no PACKOTE "pkg_fifo_RECEBIMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  pStatus := 'E';
  pMessage := 'Em Construção';
/*  tdvadm.pkg_fifo_recebimento.sp_getDadosColeta( pColeta,
                                                 pArmazem,
                                                 pStatus,
                                                 pMessage,
                                                 pCursor );
*/END sp_getDadosPedido;     
  


------------------------------------------------------------------------------------------------------------------------ 
-- Procedure que retorna um cursor com os dados de Remetente e destinatario a partir do número de uma coleta          --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getDadosColeta( pColeta  in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,
                               pArmazem in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pStatus  out char,
                               pMessage out varchar2,
                               pCursor  out T_CURSOR ) as
BEGIN

  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para gerar um cursor com os dados da Coleta,                                                   -- 
  -- O corpo da procedure está no PACKOTE "pkg_fifo_RECEBIMENTO"                                                       --
  ------------------------------------------------------------------------------------------------------------------------
  tdvadm.pkg_fifo_recebimento.sp_getDadosColeta( pColeta,
                                                 pArmazem,
                                                 pStatus,
                                                 pMessage,
                                                 pCursor );
  pMessage := 'erro';
  pStatus := 'E';
  
END sp_getDadosColeta;     




------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para buscar dados de uma Nota Fiscal, a partir da chave NFE                                    --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getDadosNota_chaveNFE( pChaveNfe  in  char,
                                    pStatus    out char,
                                    pMessage   out varchar2,
                                    pCursor    out pkg_fifo.T_CURSOR   ) as
begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para gerar um cursor com os dados da nota fiscal, tendo como parametro de busca a chaveNFE     --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_RECEBIMENTO"                                                        --
  ------------------------------------------------------------------------------------------------------------------------
  /*pkg_fifo_recebimento.sp_getDadosNota_chaveNFE( pChaveNfe,
                                                 pStatus,
                                                 pMessage,
                                                 pCursor
                                                 );
  
  */
  pStatus := 'E';
  pMessage := 'Procedure desativada';
end sp_getDadosNota_chaveNFE;

------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para buscar lista de notas                                                                      --
------------------------------------------------------------------------------------------------------------------------
procedure sp_getVideNota( pCnpj in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                          pStatus out char,
                          pMessage out varchar2,
                          pCursor out tdvadm.pkg_fifo.T_CURSOR ) as
begin
  ------------------------------------------------------------------------------------------------------------------------
  -- Procedure utilizada para gerar um cursor lista de notas, para ser escolhida uma para ser tratada como Nota-Mãe     --
  -- O corpo da procedure está no PACKOTE "pkg_fifo_RECEBIMENTO"                                                        --
  ------------------------------------------------------------------------------------------------------------------------
  tdvadm.pkg_fifo_recebimento.sp_getVideNota( pCnpj,
                                              pStatus,
                                              pMessage,
                                              pCursor );

  
end sp_getVideNota;    

------------------------------------------------------------------------------------------------------------------------
--Procedure utilizada para Validar Nota Fiscal                                                                        --
------------------------------------------------------------------------------------------------------------------------
procedure SP_VALIDA_NotaFiscal(   p_NumNota       in tdvadm.t_Arm_Nota.arm_nota_numero%type,                            --integer
                                  p_DataSaida     in varchar2,
                                  p_DataEmissao   in varchar2,
                                  p_ChaveNfe      In Char,
                                  p_Cnpj_Dest     in tdvadm.t_Arm_Nota.glb_cliente_cgccpfdestinatario%type,             --varchar2(20)
                                  p_TpEnd_Dest    in tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type,               --char(01)
                                  p_Cnpj_Remet    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,                --varchar2(20)
                                  p_TpEnd_Remet   in tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,                  --char(01)
                                  p_Cnpj_Sacado   in tdvadm.t_arm_nota.glb_cliente_cgccpfsacado%type,                   --varchar2(20)
                                  p_TpRequis      in char, -- T = Tabela | S = Solicitação
                                  p_CodRequis     in tdvadm.t_slf_tabela.slf_tabela_codigo%type Default '00000000',     --char(08)
                                  p_SaqueRequis   in tdvadm.t_slf_tabela.slf_tabela_saque%type Default  '0000',         --char(04)
                                  p_Contrato      in tdvadm.t_arm_nota.slf_contrato_codigo%type,                        --varchar2(15)
                                  p_Cfop          in tdvadm.t_glb_cfop.glb_cfop_codigo%type,                            --varchar2(04)
                                  p_Coleta        in tdvadm.t_arm_coleta.arm_coleta_ncompra%type,                       --char(06)
                                  p_Armazem       in tdvadm.t_arm_armazem.arm_armazem_codigo%type,                      --char(02)
                                  p_Rota          In tdvadm.t_glb_rota.glb_rota_codigo%Type,                            --Char(03)
                                  p_CodOrigem     in tdvadm.t_glb_localidade.glb_localidade_codigo%type,                --char(08)
                                  p_CodDestino    in tdvadm.t_glb_localidade.glb_localidade_codigo%type,                --char(08)
                                  p_Usuario       In tdvadm.t_usu_usuario.usu_usuario_codigo%Type,                      --char(10) 
                                  pStatus         out char,
                                  pMessage        out varchar2 ) As
                                  
     
 vMessage  Varchar2(5000) := '';                             
 vMessage2 Varchar2(5000) := '';
Begin

 

  /* Primeiro faço a validação da chave nfe */
  /*tdvadm.pkg_fifo_validadoresnota.sp_validaChaveNfe( p_Usuario,
                                                     p_Rota,
                                                     p_ChaveNfe,
                                                     p_Cnpj_Remet,
                                                     p_TpEnd_Remet,
                                                     p_Cnpj_Dest,
                                                     p_TpEnd_Dest,
                                                     pStatus,
                                                     vMessage );*/
  
  If ( pStatus = pkg_fifo.Status_Normal ) Then
         SP_VALIDA_NF( p_DataSaida,
                       p_NumNota,
                       p_Coleta,
                       p_Cfop,
                       p_Contrato,
                       p_Cnpj_Dest,
                       p_TpEnd_Dest,
                       p_Cnpj_Remet,
                       p_TpEnd_Remet,
                       p_Cnpj_Sacado,
                       p_TpRequis,
                       p_CodRequis,
                       p_SaqueRequis,
                       p_DataEmissao,
                       p_Coleta,
                       pStatus,
                       vMessage2
                     );  
  End If;
  If ( nvl(Trim(vMessage), 'R' ) = 'R') And  ( nvl(Trim(vMessage), 'R' ) = 'R') Then
    pMessage := 'Nota Validada com sucesso';
  Else
    pMessage := Trim(vMessage) || chr(13) || Trim(vMessage2);    
  End If;
 


end SP_VALIDA_NotaFiscal;


  Procedure sp_ListaAlmoxarifados(pCursor  Out T_CURSOR,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2)
  Is
  Begin
    Begin
      Open pCursor For
      Select Distinct Trim(tdvadm.fn_limpa_campo2(D.GLB_CLIEND_CODCLIENTE)) ALX
      From T_GLB_CLIEND D
      Where D.GLB_CLIEND_CODCLIENTE IS NOT Null
      Order By 1;
      
      pStatus  := Status_Normal;
      pMessage := 'Lista de Almoxarifados gerada com sucesso!';
    Exception When Others Then
      pStatus  := Status_Erro;
      pMessage := 'Erro ao tentar gerar lista de Almoxarifados, '||Sqlerrm;  
    End;
  End sp_ListaAlmoxarifados;                                  
    
  Procedure sp_ExistParametroUsuario(pUsuario In  tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                                     pPerfil  In  Varchar2,
                                     pCursor  Out T_CURSOR,
                                     pStatus  Out Char,
                                     pMessage Out Varchar2)
  Is
  Begin
    Begin 
      Open pCursor For     
      Select P.USU_APLICACAO_CODIGO aplicacao,
             P.USU_PERFIL_CODIGO perfil,
             P.USU_APLICACAOPERFIL_PARAT param                                     
      From T_USU_APLICACAOPERFIL P                           
      Where P.USU_APLICACAO_CODIGO = 'carreg'               
      And P.USU_USUARIO_CODIGO = pUsuario
      And P.USU_PERFIL_CODIGO In (pPerfil);
           
      pStatus  := Status_Normal;
      pMessage := 'Parametro verificado com sucesso!!';
    Exception When Others Then
      pStatus  := Status_Erro;
      pMessage := 'Erro ao tentar verificar parametro para o usuario, '||Sqlerrm;  
    End;
  End sp_ExistParametroUsuario;                                     
    
  Procedure sp_ListaParametros(pUsuario    In  T_USU_APLICACAOPERFIL.USU_USUARIO_CODIGO%TYPE,
                               pRota       In  T_USU_APLICACAOPERFIL.GLB_ROTA_CODIGO%TYPE,
                               pCursor     Out TYPES.cursorType,
                               pStatus     Out Char,
                               pMessage    Out Varchar2)
  Is
  Begin
    Begin
     
      SP_USU_PARAMETROS('carreg', pUsuario, pRota, pCursor);
     
      pStatus  := Status_Normal;
      pMessage := 'Lista de Parametros gerada com sucesso!';
    Exception When Others Then
      pStatus  := Status_Erro;
      pMessage := 'Erro ao tentar gerar Lista de Parametros, '||Sqlerrm;  
    End;            
    
  End sp_ListaParametros;                                
  
  
  Procedure sp_ListaCarregamento(pArmazem  In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                 pCursor   Out T_CURSOR,
                                 pStatus   Out Char,
                                 pMessage  Out Varchar2)
  Is
  Begin
    Begin
      Open pCursor For
      Select C.ARM_CARREGAMENTO_CODIGO,          
             C.CAR_VEICULO_PLACA,                
             fn_ToMaskPeso(C.ARM_CARREGAMENTO_PESOCOBRADO) ARM_CARREGAMENTO_PESOCOBRADO,     
             fn_ToMaskPeso(C.ARM_CARREGAMENTO_PESOREAL) ARM_CARREGAMENTO_PESOREAL,        
             C.FCF_TPVEICULO_CODIGO,             
             fn_ToMaskPeso(C.ARM_CARREGAMENTO_PESOBALANCA) ARM_CARREGAMENTO_PESOBALANCA,     
             C.CAR_VEICULO_SAQUE,                
             fn_ToMaskPeso(c.ARM_CARREGAMENTO_PESOCUBADO) ARM_CARREGAMENTO_PESOCUBADO,      
             c.FRT_CONJVEICULO_CODIGO,           
             to_date(nvl(c.ARM_CARREGAMENTO_DTFECHAMENTO, '01/01/0001')) ARM_CARREGAMENTO_DTFECHAMENTO,    
             c.FCF_VEICULODISP_CODIGO,           
             c.FCF_VEICULODISP_SEQUENCIA,        
             c.ARM_CARREGAMENTO_QTDCTRC,         
             c.ARM_CARREGAMENTO_QTDIMPCTRC,      
             c.ARM_CARREGAMENTO_DTVIAGEM,        
             c.ARM_CARREGAMENTO_ORDEMENTREGA,    
             c.ARM_CARREGAMENTO_DTENTREGA,       
             c.ARM_CARREGAMENTO_FLAGMANIFESTO,   
             c.ARM_ARMAZEM_CODIGO,               
             c.ARM_CARREGAMENTO_DTFINALIZACAO,   
             c.ARM_CARREGAMENTO_AUTORIZASPOT,
             c.arm_carregamento_mobile,
             c.arm_estagiocarregmob_codigo     
      From T_ARM_CARREGAMENTO C              
      where C.arm_carregamento_dtfechamento is null and nvl(c.arm_carregamento_qtdctrc,0) = 0
      And C.ARM_ARMAZEM_CODIGO = pArmazem
      And ( (nvl(C.ARM_CARREGAMENTO_MOBILE,Status_Normal)<>'S')  Or ( (nvl(C.ARM_CARREGAMENTO_MOBILE,Status_Normal)='S') And (nvl(C.ARM_ESTAGIOCARREGMOB_CODIGO,'I')='F') ))
      order by to_number(arm_carregamento_codigo);
    
      pStatus  := Status_Normal;
      pMessage := 'Lista de Carregamento gerada com sucesso!';
    Exception When Others Then
      pStatus  := Status_Erro;
      pMessage := 'Erro ao tentar gerar Lista de Carregamento, '||Sqlerrm;  
    End;      
  End;                                 
  
  Procedure sp_GetPesos(pCursor  Out T_Cursor, pStatus  Out Char, pMessage Out Varchar2)
  Is
  Begin
    Begin
      Open pCursor For
      Select TPV.FCF_TPVEICULO_DESCRICAO VEICULO,                           
             TPC.fcf_tpcargadescricao    TP_VEICULO,                        
             LC.FCF_LIMITECARGAS_FAIXAI  FAIXA_INI,                         
             LC.FCF_LIMITECARGAS_FAIXAF  FAIXA_FIN                          
      From T_FCF_LIMITECARGAS LC, T_FCF_TPCARGA TPC, T_FCF_TPVEICULO TPV  
      Where LC.FCF_TPCARGA_CODIGO = TPC.FCF_TPCARGA_CODIGO                 
      And LC.FCF_TPVEICULO_CODIGO = TPV.FCF_TPVEICULO_CODIGO             
      And LC.GLB_GRUPOECONOMICO_CODIGO = '0020'
      Order By LC.FCF_LIMITECARGAS_FAIXAI;
      
      pStatus  := Status_Normal;
      pMessage := 'Lista de Pesos gerada com sucesso!';
    Exception When Others Then
      pStatus  := Status_Erro;
      pMessage := 'Erro ao tentar gerar Lista de Pesos, '||Sqlerrm;  
    End;      
  End sp_GetPesos;                                 
                        
  Procedure sp_ListaCarregamentoCTRC(pArmazem  In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                     pCursor   Out T_CURSOR,
                                     pStatus   Out Char,
                                     pMessage  Out Varchar2)
  Is
  Begin
    Begin
      Open pCursor For
        Select Distinct Trim(Ca.Arm_Carregamento_Codigo) Arm_Carregamento_Codigo,
                        nvl(to_char(Ca.Arm_Carregamento_Dtfechamento,'dd/mm/yyyy hh24:mi:ss'),empty) Arm_Carregamento_Dtfechamento,
                        fn_ToMaskPeso(Ca.Arm_Carregamento_Pesocobrado) Arm_Carregamento_Pesocobrado,
                        fn_ToMaskPeso(Ca.Arm_Carregamento_Pesoreal) Arm_Carregamento_Pesoreal,
                        Trim(Fn_Placa_Docarreg(Ca.Arm_Carregamento_Codigo)) Con_Conhecimento_Placa,
                        Ca.Arm_Carregamento_Qtdctrc,
                        Ca.Arm_Carregamento_Qtdimpctrc,
                        Ca.Arm_Carregamento_Qtdctrc|| ' / ' ||Ca.Arm_Carregamento_Qtdimpctrc Ctrc,
                        nvl(to_char(Ca.Arm_Carregamento_Dtviagem,'dd/mm/yyyy hh24:mi:ss'),empty) Arm_Carregamento_Dtviagem,
                        nvl(to_char(Ca.Arm_Carregamento_Dtentrega,'dd/mm/yyyy hh24:mi:ss'), empty) Arm_Carregamento_Dtentrega,
                        Ca.Fcf_Veiculodisp_Codigo
          From t_Arm_Carregamento Ca, 
               t_Fcf_Veiculodisp Vd, 
               t_Con_Conhecimento Co
         Where (Ca.Arm_Carregamento_Dtfechamento Is Not Null)
           And (Ca.Fcf_Veiculodisp_Codigo = Vd.Fcf_Veiculodisp_Codigo)
           And (Ca.Arm_Carregamento_Codigo = Co.Arm_Carregamento_Codigo)
           And (Ca.Fcf_Veiculodisp_Codigo Is Not Null)
           And (Ca.Arm_Carregamento_Dtfinalizacao Is Null)
           And (Ca.Arm_Armazem_Codigo = pArmazem)
           And (Trunc(Ca.Arm_Carregamento_Dtfechamento) >= Sysdate - 15)
         Order By 1;
         
      pStatus  := Status_Normal;
      pMessage := 'Lista de Carregamento|CTRC gerada com sucesso!';
    Exception When Others Then
      pStatus  := Status_Erro;
      pMessage := 'Erro ao tentar gerar Lista de Carregamento|CTRC, '||Sqlerrm;  
    End;      
  End sp_ListaCarregamentoCTRC;                                     

  Procedure sp_ListaFifoManifesto(pArmazem      In  tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                  pDataIni      In  Varchar2,
                                  pDataFin      In  Varchar2,
                                  pCarregamento In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                  pSerie        In  tdvadm.t_con_manifesto.Con_Manifesto_Serie%Type,
                                  pCursor       Out T_Cursor,
                                  pStatus       Out Char,
                                  pMessage      Out Varchar2)
  Is
  Begin
    Begin
      Open pCursor For
      Select Ma.Con_Manifesto_Codigo,
             Ma.Con_Manifesto_Serie,
             Ma.Con_Manifesto_Rota,
             Ma.Usu_Usuario_Codigo,
             Ma.Con_Manifesto_Usuario_Impresso,
             Ma.Con_Manifesto_Placa,
             Ma.Con_Manifesto_Placasaque,
             nvl(to_char(Ma.Con_Manifesto_Dtemissao,'dd/mm/yyyy hh24:mi:ss'),empty) Con_Manifesto_Dtemissao,
             fn_ToMaskPeso(Ma.Con_Manifesto_Pesonf) Con_Manifesto_Pesonf,
             fn_ToMaskPeso(Ma.Con_Manifesto_Pesocobrado) Con_Manifesto_Pesocobrado,
             Ma.Con_Manifesto_Vlrmercadoria,
             Ma.Con_Manifesto_Vlrfrete,
             Ma.Con_Manifesto_Obs,
             Ma.Con_Manifesto_Cpfmotorista,
             Ma.Con_Manifesto_Cubagemtotal,
             nvl(to_char(Ma.Con_Manifesto_Dtcriacao,'dd/mm/yyyy hh24:mi:ss'),empty) Con_Manifesto_Dtcriacao,
             Ma.Car_Tpveiculo_Codigo,
             Ma.Con_Manifesto_Quantitensnf,
             Ma.Glb_Tpmotorista_Codigo,
             Ma.Con_Manifesto_Status,
             Ma.Con_Manifesto_Destinatario,
             Ma.Glb_Tpcliend_Codigo,
             Ma.Arm_Armazem_Codigo,
             nvl(to_char(Ma.Con_Manifesto_Dtchegada,'dd/mm/yyyy hh24:mi:ss'),empty) Con_Manifesto_Dtchegada,
             nvl(to_char(Ma.Con_Manifesto_Dtrecebimento,'dd/mm/yyyy hh24:mi:ss'),empty) Con_Manifesto_Dtrecebimento,
             Ma.Con_Manifesto_Avarias,
             nvl(to_char(Ma.Con_Manifesto_Dtchegcelula,'dd/mm/yyyy hh24:mi:ss'),empty) Con_Manifesto_Dtchegcelula,
             nvl(to_char(Ma.Con_Manifesto_Dtcheckin,'dd/mm/yyyy hh24:mi:ss'),empty) Con_Manifesto_Dtcheckin,
             nvl(to_char(Ma.Con_Manifesto_Dtgravcheckin,'dd/mm/yyyy hh24:mi:ss'),empty) Con_Manifesto_Dtgravcheckin,
             Ma.Arm_Carregamento_Codigo,
             Ma.Con_Manifesto_Localidade
        From t_Con_Manifesto Ma, 
             t_Arm_Carregamento Ca
       Where Ca.Arm_Carregamento_Codigo = Ma.Arm_Carregamento_Codigo
         And Ma.Con_Manifesto_Usuario_Impresso Is Null
         And Ma.Con_Manifesto_Serie = pSerie
         And Ca.Arm_Armazem_Codigo = '06'--pArmazem
         And trunc(ma.CON_MANIFESTO_DTCRIACAO) >= trunc(Sysdate-30)--pDataIni
         And trunc(ma.CON_MANIFESTO_DTCRIACAO) <= trunc(Sysdate);--pDataFin
         --And CA.ARM_CARREGAMENTO_CODIGO = pCarregamento;
         --And 0 = 1
        
      pStatus  := Status_Normal;
      pMessage := 'Lista FifoManifesto gerada com sucesso!';
    Exception When Others Then
      pStatus  := Status_Erro;
      pMessage := 'Erro ao tentar gerar Lista FifoManifesto, '||Sqlerrm;  
    End;            
  End sp_ListaFifoManifesto;                                  

  Procedure sp_NovoCarregamento(pArmazem      In  TDVADM.T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%TYPE,             
                                pUsuario      In  TDVADM.T_USU_USUARIO.USU_USUARIO_CODIGO%TYPE,
                                pCarregamento Out TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,
                                pStatus       Out Char,
                                pMessage      Out Varchar2)
  Is
  Begin
    Begin
      armadm.pkg_arm_carregamento.SP_GET_NOVOCARREGAMENTO(pArmazem,Null,pUsuario,Status_Normal,pCarregamento,pStatus,pMessage);
    Exception When Others Then
      pStatus := Status_Erro;
      pMessage:= 'Erro ao tentar executar "pkg_fifo.sp_NovoCarregamento", '||Sqlerrm;       
    End;
  End sp_NovoCarregamento;                                

  Procedure sp_Carregar(pCarregamento  In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                        pEmbNumero     In  tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                        pEmbFlag       In  tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                        pEmbSequencia  In  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                        pStatus        Out Char,
                        pMessage       Out Varchar2)
  Is
  Begin
    Begin
      tdvadm.sp_carreg_carrega(pCarregamento,pEmbNumero,pEmbFlag,pEmbSequencia);
      
      tdvadm.SP_CARREG_ATUALIZA_PESOS(pCarregamento);
      
      pStatus := Status_Normal; 
      pMessage:= 'Embalagem carregada com sucesso!';
    Exception When Others Then
      pStatus := Status_Erro;
      pMessage:= 'Erro ao tentar executar "pkg_fifo.sp_Carregar", '||Sqlerrm;       
    End;   
  End sp_Carregar;                        

/*  
  Procedure sp_ExcluiCarregamento(pCarregamento  In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                  pStatus        Out Char,
                                  pMessage       Out Varchar2)
  Is
  Begin
    Begin
      tdvadm.sp_exclui_carregamento(pCarregamento);
      pStatus := Status_Normal; 
      pMessage:= 'Carregamento excluido com sucesso!!';
    Exception When Others Then
      pStatus := Status_Erro;
      pMessage:= 'Erro ao tentar executar "pkg_fifo.sp_ExcluiCarregamento", '||Sqlerrm;       
    End;       
  End sp_ExcluiCarregamento;  */                                

  Procedure sp_RetiraEmbalagem(pCarregamento  In  tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                               pEmbNumero     In  tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                               pEmbFlag       In  tdvadm.t_arm_embalagem.arm_embalagem_flag%Type,
                               pEmbSequencia  In  tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type,
                               pStatus        Out Char,
                               pMessage       Out Varchar2)
  Is
  Begin
    Begin
      tdvadm.sp_carreg_tiraembcarreg(pCarregamento,pEmbNumero,pEmbFlag,pEmbSequencia);
      
      tdvadm.SP_CARREG_ATUALIZA_PESOS(pCarregamento);
      
      pStatus := Status_Normal; 
      pMessage:= 'Embalagem retirada com sucesso!!';
    Exception When Others Then
      pStatus := Status_Erro;
      pMessage:= 'Erro ao tentar executar "pkg_fifo.sp_RetiraEmbalagem", '||Sqlerrm;       
    End;       
  End sp_RetiraEmbalagem;                                 
                          
  /*******************************************************************************************************************
  * Procedure responsável por conferir se a Nota Fiscal está sendo emitida contra uma empresa fora do mesmo estado   *
  *******************************************************************************************************************/
  Procedure sp_ConfEstadoNf( pCnpjRemetente in tdvadm.t_glb_cliend.glb_cliente_cgccpfcodigo%type,
                             pTpRemetente   in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                             pCnpjDestino   in tdvadm.t_glb_cliend.glb_cliente_cgccpfcodigo%type,
                             pTpDestino     in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                             pStatus        out char, 
                             pMessage       out varchar2 ) as

   vUfDestino   char(02):= '';
   vUfRemetente char(02):= '';                           
  begin
     /* Alimento a Variável vUfRemetente */
    select 
      remetente.glb_estado_codigo  into  vUfRemetente   
    from 
      tdvadm.t_glb_cliend remetente
    where
      remetente.glb_cliente_cgccpfcodigo = pCnpjRemetente
      and remetente.glb_tpcliend_codigo  = pTpRemetente;
      
      /* Alimento a Variável vUfDestino */
      Select 
        Destino.Glb_Estado_Codigo into vUfDestino
      from
        tdvadm.t_glb_cliend  Destino
      where
        Destino.Glb_Cliente_Cgccpfcodigo = pCnpjDestino
        and Destino.Glb_Tpcliend_Codigo  = pTpDestino;
      
   begin
     if ( Trim(lower(vUfDestino))  =  Trim(lower(vUfRemetente))  ) then
       pStatus := Status_Normal;
       pMessage := '';
       
     else
       pStatus := Status_Erro;
       pMessage := 'Chave NFE, Campo de preenchimento obrigatório.'||
                    chr(13)||chr(13)||
                   'O endereço do Remetente e do Destinatário não ficam no mesmo estado.';
     end if;
     
   Exception when others then
     pStatus :=  Status_Erro;
     
     RAISE_APPLICATION_ERROR(-20001,'Erro:'||CHR(13)||SQLERRM);
   end;
         
  end; 

  /*******************************************************************************************************************
  * Procedure responsável apenas para retornar a quantidade de carregamento está vinculado ao motorista              *
  *******************************************************************************************************************/
    Procedure sp_CarregVeiculo( pCodVeiculo  in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                pSequencia   in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                                pCursor      out T_CURSOR )  as
    begin
      
      open pCursor for
        SELECT 
          ca.arm_carregamento_codigo,
          ca.arm_carregamento_dtfechamento,
          ca.arm_carregamento_dtviagem,
          ca.fcf_veiculodisp_codigo,
          ca.fcf_veiculodisp_sequencia

        FROM 
          T_ARM_CARREGAMENTO CA
        WHERE 
            CA.FCF_VEICULODISP_CODIGO = pCodVeiculo
        AND CA.FCF_VEICULODISP_SEQUENCIA = pSequencia
        ORDER BY 
          ca.arm_carregamento_codigo;
    end;     
    
  /*******************************************************************************************************************
  * Procedure responsável desvincular um carregamento de um motorista                                                *
  *******************************************************************************************************************/
  Procedure sp_DesvinculaCarreg( pCarregCodigo in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                 pCodVeiculo   in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                 pSequencia    in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type,
                                 pStatus       out char, 
                                 pMessage      out varchar2  ) as
   vCount integer := 0; 

   vCodVeic_Virtual  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type :=  fn_CriaVeicVirtual(pCarregCodigo);
   
   

   /* cursor que trará todos os conhecimento que não foram impressos, para que seja 
      retirado os dados do motorista */
   cursor vCursor is
    Select 
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
         ctrc.con_viagem_numero        = viagem.con_viagem_numero
     and ctrc.glb_rota_codigoviagem    = viagem.glb_rota_codigoviagem
     and nvl(ctrc.con_conhecimento_digitado, 'I') <> 'I'
     and ctrc.arm_carregamento_codigo = pCarregCodigo;
  begin
    
    /* Primeiro verifico se existe um carregamento vinculado ao veiculo passado. */
    SELECT 
      count(*) into vCount 
    FROM 
      t_arm_carregamento t
    where 
      t.arm_carregamento_codigo = pCarregCodigo
      and t.fcf_veiculodisp_codigo = pCodVeiculo
      and t.fcf_veiculodisp_sequencia = pSequencia;
      
     /* Caso não exista nenhum carregamento, suspendo a procedure e retorno uma mensagem para o usuario */
     if vCount < 1 then
       pStatus := Status_Erro;
       pMessage := 'Erro ao desvincular carregamento.'||
                   chr(13)||chr(13)||
                   'Não existe carregamento vinculado ao veículo informado.';
       return;
     end if;
       
    begin
      /* Troca o Código a Sequencia e a Placa da tabela de Carregamento, e coloca o código do Veiculo Virtual */
       update  t_arm_carregamento t
          set t.fcf_veiculodisp_codigo     = vCodVeic_Virtual,
              t.fcf_veiculodisp_sequencia  = '0',
              t.car_veiculo_placa          = null
       where
              t.arm_carregamento_codigo   = pCarregCodigo
          and t.fcf_veiculodisp_codigo    = pCodVeiculo
          and t.fcf_veiculodisp_sequencia = pSequencia;
          
        /* Retira o Código do carregamento da tabela de veiculo disponivel. */
        update t_fcf_veiculodisp t
          set t.arm_carregamento_codigo = null
        where 
                t.fcf_veiculodisp_codigo    = pCodVeiculo
            and t.fcf_veiculodisp_sequencia = pSequencia;
            
         /* percorrer o cursor, para retirar os dados do motorista dos conhecimento não impressos, e das 
            viagens. */
            for cCursor in vCursor loop
              exit when vCursor%notfound;
               
              /* retiro também os dados do Veiculo da Viagem */
              update t_con_viagem tv
                set 
                  tv.CAR_CARRETEIRO_CPFCODIGO   = null,
                  tv.CAR_CARRETEIRO_SAQUE       = null,
                  tv.FRT_MOTORISTA_CODIGO       = null,
                  tv.FRT_CONJVEICULO_CODIGO     = null,
                  tv.CON_VIAGEM_CPFCODIGO       = null,
                  tv.CON_VIAGEM_CPFSAQUE        = null,
                  tv.CON_VIAGEM_FRTMOTORISTA    = null, 
                  tv.CON_VIAGEM_CONJVEICULO     = null,
                  tv.CON_VIAGEM_PLACA           = null,
                  tv.CON_VIAGEM_PLACASAQUE      = null
              WHERE
                  tv.con_viagem_numero         = cCursor.Con_Viagem_Numero
                  and tv.glb_rota_codigoviagem = cCursor.Glb_Rota_Codigoviagem;
                  
              
               /* Retiro a placa do veiculo do Conhecimento. Utilizo os dados do Cursor, pois posso ter 
                  conhecimentos já impressos e não impressos dentro de um mesmo carregamento. */
              update t_con_conhecimento ctrc
                set ctrc.con_conhecimento_placa   = null
              where ctrc.con_conhecimento_codigo  = cCursor.Con_Conhecimento_Codigo
                and ctrc.con_conhecimento_serie   = cCursor.Con_Conhecimento_Serie
                and ctrc.glb_rota_codigo          = cCursor.Glb_Rota_Codigo;
            end loop;

            
        commit;    
       /* Não ocorrendo nenhum erro, concluo a procedure, com status positivo e mensagem de sucesso. */
       pStatus  := Status_Normal;
       pmessage := 'Carregamento '||pCarregCodigo || chr(13) ||
                   'Foi desvinculado do veiculo '|| pCodVeiculo || ' na sequencia '|| pSequencia ;
    
    Exception when others then
     pStatus :=  Status_Erro;
--     return;
     RAISE_APPLICATION_ERROR(-20001,'Erro:'||CHR(13)||SQLERRM);
   end;         
    
  end;

  /*******************************************************************************************************************
  * função utilizada para Criar um veiculo Virtual a partir de um carregamento                                       *
  *******************************************************************************************************************/
  Function fn_CriaVeicVirtual( pCarregamento in  tdvadm.t_arm_carregamento.arm_carregamento_codigo%type) return char is
   --Armazem para o veiculo virtual
   vArmaz_Virtual    tdvadm.t_arm_armazem.arm_armazem_codigo%type;
   --Rota para o Veiculo virtual
   vGlb_Rota_Virutal tdvadm.t_glb_rota.glb_rota_codigo%type;
   --Estado para o Veiculo virtual
   vUf_Virtual       tdvadm.t_glb_cliend.glb_estado_codigo%type;
   --Variável com o peso do carregamento
   vPesoCarreg       tdvadm.t_arm_carregamento.arm_carregamento_pesoreal%type;
   --Variável utilizada para guardar o código do tipo que será atribuido para o Veiculo Virtual.
   vCodTpVeiculo_virutal   tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%type;

   --Codigo do Veiculo virtual, essa variável será o retorno no final da função.
   vCodVeic_Virtual  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
   -- Controle para nao ficar um LOOP infinito
   vContaLoop  integer := 0;
   vLimiteLoop Integer := 10;
  Begin
    /* Select utilizado para pegar o Armazem, rota e Uf de Destino do Veiculo Virtual.
      E o Peso do carregamento para definir o tipo de veículo.  */
    BEGIN
      select 
        carreg.arm_armazem_codigo,
        arm.glb_rota_codigo,
        ufdest.glb_estado_codigo, 
        carreg.arm_carregamento_pesoreal
      into
        vArmaz_Virtual,
        vGlb_Rota_Virutal,
        vUf_Virtual,
        vPesoCarreg
      from 
        tdvadm.t_arm_carregamento carreg,
        tdvadm.t_arm_armazem      arm,
        tdvadm.t_arm_embalagem    emb,
        tdvadm.t_glb_cliend       ufDest
      where 
        carreg.arm_carregamento_codigo               = pCarregamento
        and carreg.arm_armazem_codigo                = arm.arm_armazem_codigo
        and carreg.arm_carregamento_codigo           = emb.arm_carregamento_codigo
        and Trim(emb.glb_cliente_cgccpfdestinatario) = Trim(ufdest.glb_cliente_cgccpfcodigo)
        and emb.glb_tpcliend_coddestinatario         = ufdest.glb_tpcliend_codigo
        and rownum =1;
        
    EXCEPTION
      /* Caso o Select não retorne nenhum registro */
      WHEN NO_DATA_FOUND THEN 
        raise_application_error(-20101, 'Carregamento [' || pCarregamento || '] não encontrado na busca do veiculo virtual.'||chr(13)||sqlerrm);
      
      /* Caso o Select retorne mais de uma linha, o que não deve ocorrer pois estou utilizado a chave primaria.  */
      WHEN TOO_MANY_ROWS THEN
        raise_application_error(-20102, 'Cursor com mais de uma linha.'||chr(13)||sqlerrm);
      
      /* Para qualquer outro tipo de erro */
      WHEN OTHERS THEN
        raise_application_error(-20103, 'Erro ao buscar Dados do carregamento:'||pCarregamento||chr(13)||sqlerrm);
    END;
    
    
    --tipo de Veiculo para ser utilizado como virtual.
    --Primeiro com o peso do carregamento, e com a sigla FIF para sistema, pega a descricao do veiculo.
    -- Desativado em 06/04/2018 Sirlano
    -- Não usamos mais este conceito
/*    
    BEGIN
      select 
        w.fcf_tpveiculo_codigo 
      into 
        vCodTpVeiculo_virutal 
      from 
        t_fcf_tpveiculo w
      where 
        w.fcf_tpveiculo_descricao = nvl( Trim ((select p.int_parametros_codigo 
                                                from tdvadm.t_int_parametros p
                                                where p.int_parametros_minimo <= vPesoCarreg
                                                and p.int_parametros_maximo >= vPesoCarreg
                                                and p.int_parametros_sistema = 'FIF')), 'BI-TREM' );
       vCodTpVeiculo_virutal := '0 ';                                              
    EXCEPTION
      -- Caso o Select não retorne nenhum registro 
      WHEN NO_DATA_FOUND THEN
        raise_application_error(-20001, 'Tipo de Veiculo não encontrado.'||chr(13)||sqlerrm);
        
      --  Caso o Select retorne mais de uma linha. Não vejo como isso poderia                                                        
      WHEN TOO_MANY_ROWS THEN
        raise_application_error(-20001, 'Cursor com mais de uma linha.'||chr(13)||sqlerrm);
      
      WHEN OTHERS THEN
        raise_application_error(-20001, 'Erro ao buscar o Tipo de Veiculo.'||chr(13)||sqlerrm);
    END; 
*/    
    vCodTpVeiculo_virutal := '0 ';    
    
    /* Após ter definido praticamente todos os dados para o veículo virtual, vou atribuir o Código do Veiculo */
    

    --Insiro os dados do novo veiuclo virtual, já com o carregamento, na tabela de Veiculos disponiveis
    

    BEGIN
        select to_char(nvl(max(to_number(vd.fcf_veiculodisp_codigo)) + 1, 1)) 
         into vCodVeic_Virtual
         from t_fcf_veiculodisp vd;
    EXCEPTION
      /* caso de algum tipo de erro... */
      WHEN OTHERS THEN
        raise_application_error(-20001, 'Erro ao buscar o código do veículo.'||chr(13)||sqlerrm);
    END;

    Loop
        BEGIN
          insert into tdvadm.t_fcf_veiculodisp vd
            ( vd.FCF_VEICULODISP_SEQUENCIA,
              vd.FCF_TPVEICULO_CODIGO,
              vd.ARM_ARMAZEM_CODIGO,          
              vd.FCF_VEICULODISP_CODIGO,      
              vd.FCF_VEICULODISP_DATA,        
              vd.GLB_ROTA_CODIGO,             
              vd.ARM_CARREGAMENTO_CODIGO,     
              vd.FCF_VEICULODISP_UFDESTINO,   
              vd.FCF_VEICULODISP_FLAGVIRTUAL, 
              vd.USU_USUARIO_CADASTRO)
                values
              (
                '0',
                vCodTpVeiculo_virutal,
                vArmaz_Virtual ,
                vCodVeic_Virtual ,
                sysdate,
                vGlb_Rota_Virutal,
                pCarregamento,
                vUf_Virtual,
                'S',
                'sp_Desv' );
              exit;
           
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX  THEN
              vContaLoop := vContaLoop + 1;
              If vContaLoop > vLimiteLoop Then
                 raise_application_error(-20001,'LOOP Atingiu o Limite de INSERCAO na VEICULODISP, tabela pode estar travada!');
              End If;

             BEGIN
               select to_char(nvl(max(to_number(vd.fcf_veiculodisp_codigo)) + 1, 1)) 
                  into vCodVeic_Virtual
               from t_fcf_veiculodisp vd;
            EXCEPTION
              /* caso de algum tipo de erro... */
              WHEN OTHERS THEN
                raise_application_error(-20001, 'Erro ao buscar o código do veículo.'||chr(13)||sqlerrm);
            END;
         WHEN OTHERS THEN
            raise_application_error(-20001, 'Erro ao tentar inserir Veículo virtual.'||chr(13)||sqlerrm);
        END;
    End Loop;
    Commit;
    /* No final, retorno o Código do Veiculo virtual. Lembrando que para Veiculo virtual a seqüência sempre será zero. */
    return vCodVeic_Virtual;
  End;
  
  /*******************************************************************************************************************
  * Procedure responsável por retornar todos os veiculos contratados em um determinado armazem                       *
  *******************************************************************************************************************/
  Procedure sp_retorna_VeicContratados( pCodCarregamento In tdvadm.t_arm_carregamento.arm_carregamento_codigo%Type,
                                      pArmazem         In tdvadm.t_arm_armazem.arm_armazem_codigo%Type,
                                      pStatus          Out Char,
                                      pMessage         Out Varchar2,
                                      pCursor          Out  T_CURSOR) As
    /* Caso seja passado o código do carregamento, busco todos os código de IBGE daquele carregamento. */                                      
    vCodIBGECarreg  Varchar2(1000):= substr(Tdvadm.Fn_Arm_Getdestinocarregemb(pCodCarregamento,'T','C','T'), 03);
  Begin
    BEGIN 
      pstatus := Status_normal;
      pMessage := '';
    
      Open pCursor For
        SELECT distinct 
          (trunc(sysdate) - trunc(s.fcf_veiculodisp_data)) QtdDias,                 
                S.*,                                                                               
              decode((select count(*)                                                            
                       from t_arm_carregamento ca                                                
                      where ca.fcf_veiculodisp_codigo = s.fcf_veiculodisp_codigo                 
                        and ca.fcf_veiculodisp_sequencia =                                       
                            s.fcf_veiculodisp_sequencia),                                        
                     0,                                                                          
                     'Vazio',                                                                  
                     'Carreg.') Veic,                                                          
              T.FCF_TPVEICULO_DESCRICAO,                                                         
              T.FCF_TPVEICULO_LOTACAO,                                                           
              FN_BUSCA_PLACAVEICULO(S.FCF_VEICULODISP_CODIGO,                                    
                                    S.FCF_VEICULODISP_SEQUENCIA) PLACA,                          
              FN_BUSCA_MOTORISTAVEICULO(S.FCF_VEICULODISP_CODIGO,                                
                                        S.FCF_VEICULODISP_SEQUENCIA) MOTORISTA,                  
              (SELECT NVL(SUM(CA.ARM_CARREGAMENTO_PESOCOBRADO), NULL)                            
                 FROM T_ARM_CARREGAMENTO CA                                                      
                WHERE CA.FCF_VEICULODISP_CODIGO = S.FCF_VEICULODISP_CODIGO                       
                  AND CA.FCF_VEICULODISP_SEQUENCIA = S.FCF_VEICULODISP_SEQUENCIA) PESOCOBRADO,   
              (SELECT NVL(SUM(CA.ARM_CARREGAMENTO_PESOCUBADO), NULL)                             
                 FROM T_ARM_CARREGAMENTO CA                                                      
                WHERE CA.FCF_VEICULODISP_CODIGO = S.FCF_VEICULODISP_CODIGO                       
                  AND CA.FCF_VEICULODISP_SEQUENCIA = S.FCF_VEICULODISP_SEQUENCIA) PESOCUBADO,    
              (SELECT NVL(SUM(CA.ARM_CARREGAMENTO_PESOBALANCA), NULL)                            
                 FROM T_ARM_CARREGAMENTO CA                                                      
                WHERE CA.FCF_VEICULODISP_CODIGO = S.FCF_VEICULODISP_CODIGO                       
                  AND CA.FCF_VEICULODISP_SEQUENCIA = S.FCF_VEICULODISP_SEQUENCIA) PESOBALANCA,   
              (SELECT NVL(SUM(CA.ARM_CARREGAMENTO_PESOREAL), NULL)                               
                 FROM T_ARM_CARREGAMENTO CA                                                      
                WHERE CA.FCF_VEICULODISP_CODIGO = S.FCF_VEICULODISP_CODIGO                       
                  AND CA.FCF_VEICULODISP_SEQUENCIA = S.FCF_VEICULODISP_SEQUENCIA) PESOREAL
                  

         FROM T_FCF_VEICULODISP S,                                                               
              T_FCF_TPVEICULO   T,                                                               
              T_FCF_SOLVEIC     SOL,                                                             
              T_FCF_SOLVEICDEST SOLD

        WHERE S.FCF_VEICULODISP_CODIGO    = SOL.FCF_VEICULODISP_CODIGO                              
          AND S.FCF_VEICULODISP_SEQUENCIA = SOL.FCF_VEICULODISP_SEQUENCIA                        
          
          AND S.FCF_TPVEICULO_CODIGO = T.FCF_TPVEICULO_CODIGO                                    
          
          AND S.FCF_OCORRENCIA_CODIGO IS NULL                                                    
          AND S.FCF_VEICULODISP_FLAGVIRTUAL IS NULL                                              
          AND S.FCF_VEICULODISP_FLAGVALEFRETE IS NULL    
          
          AND SOL.FCF_SOLVEIC_COD = SOLD.FCF_SOLVEIC_COD 
         And s.arm_armazem_codigo = pArmazem
         And  
           Case  
                When nvl(Trim(pCodCarregamento), Status_Normal) <> Status_Normal  And instr(vCodIBGECarreg, sold.glb_localidade_codigoibge ) > 0  Then 1   
                When nvl(Trim(pCodCarregamento), Status_Normal) = Status_Normal   And 0=0  Then 1  
              Else 0
           End = 1
           
           order by 1 desc; 
           
    /* Caso ocorra algum erro na abertura do cursor, seta o paramentro pStatus para "E", para impedir o frontEnd de abrir um cursor
       que não exista. */
    EXCEPTION 
      WHEN OTHERS THEN
        pStatus  := Status_erro;
        pMessage := 'Erro ao abrir o Relação de motoristas contratados.';
      end;
       
  End;
  
  /*******************************************************************************************************************
  * Procedure responsável Validar Notas Fiscais - Entrada direto pelo recebimento.                                   *
  *******************************************************************************************************************/
  PROCEDURE SP_VALIDA_NF(P_DATA            in  varchar2,
                         P_NOTA            in TDVADM.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                         P_NRCOLETA        IN TDVADM.T_ARM_COLETA.ARM_COLETA_NCOMPRA%TYPE,
                         P_CFOP            IN TDVADM.T_GLB_CFOP.GLB_CFOP_CODIGO%TYPE,
                         P_CONTRATO        IN TDVADM.T_ARM_NOTA.SLF_CONTRATO_CODIGO%TYPE,
                         P_CNPJ_DEST       IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFDESTINATARIO%TYPE,
                         P_DEST_TPEND      IN TDVADM.T_ARM_NOTA.GLB_TPCLIEND_CODDESTINATARIO%TYPE,
                         P_CNPJ_REMET      IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                         P_REMET_TPEND     IN TDVADM.T_ARM_NOTA.GLB_TPCLIEND_CODDESTINATARIO%TYPE,
                         P_CNPJ_SACADO     IN TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFDESTINATARIO%TYPE, -- CNPJ DO DO SACADO IREMOS TROCAR DEPOIS O NOME DA VARIAVEL
                         P_TPSOLTAB        In Char Default 'T',
                         P_TABELASOL       In TDVADM.T_SLF_TABELA.SLF_TABELA_CODIGO%Type Default '00000000',
                         P_SQTABELASOL     In TDVADM.T_SLF_TABELA.SLF_TABELA_SAQUE%Type Default '0000',
                         P_DATAEMISS       in  varchar2 , -- data de emissão da nota
                         P_TPCOLETA        in tdvadm.t_arm_coleta.arm_coleta_tpcompra%type, -- tipo da coleta. /valores esperados definidos por parametros
                         pStatus           out char,
                         pMessage          out varchar2) is           

  -- VARIAVEIS AUXILIARES
   
  V_CONTINUA        INTEGER; -- CONTADOR DE REGISTROS VALIDADOS   
  V_ALX             TDVADM.T_GLB_CLIEND.GLB_CLIEND_CODCLIENTE%TYPE; --ALMOXERIFADO DESTINO
  V_GRUPO_ECONOMICO TDVADM.T_GLB_CLIENTE.GLB_GRUPOECONOMICO_CODIGO%TYPE; --GRUPO ECONOMICO
  V_CNPJ_DE_VENDA   CHAR; --VARIAVEL QUE SE FOR 1 SIGNIFICA QUE E CNPJ DE VENDA
  V_CNPJ_LIVRES     T_USU_PARAMETROTMP.TEXTO%TYPE;
  V_PARAMETRO       T_USU_PERFIL.USU_PERFIL_CODIGO%TYPE;
  V_PARAMTEXTO      T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;
  V_CIF_SACADO_VALE Boolean;
  V_EXISTENOTA      INTEGER;
  P_NOTANUMEROXML   T_XML_NOTA.XML_NOTA_NUMERO%TYPE;
  V_COLETAENTREGA   Char(1);
  V_ORIGEM          T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%Type;
  V_DESTINO         T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%Type;
  V_LOCARMAZEM      T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%Type;
  V_ARMAZEM         T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%Type;
  V_REMCLICOL       T_GLB_CLIEND.GLB_CLIENTE_CGCCPFCODIGO%Type;
  V_REMENDCOL       T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%Type;
  V_REMLOCCOL       T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%Type;
  V_DESCLICOL       T_GLB_CLIEND.GLB_CLIENTE_CGCCPFCODIGO%Type;
  V_DESENDCOL       T_GLB_CLIEND.GLB_TPCLIEND_CODIGO%Type;
  V_DESLOCCOL       T_GLB_CLIEND.GLB_LOCALIDADE_CODIGO%Type;

  CURSOR C_PARAMETROS IS
    SELECT P.PERFIL, P.TEXTO
      FROM T_USU_PARAMETROTMP P
     WHERE P.USUARIO = 'jsantos'
       AND P.APLICACAO = 'spValidaNf'
       and P.ROTA = '010';
       
vListaCnpjLiber Varchar2(32000);       

Begin
  
-------------------------------------------------------------------------------------------------------------------
-- VALIDAÇÃO DA DATA NA NOTA FISCAL.                                                                             -- 
-------------------------------------------------------------------------------------------------------------------
  --Data de Saida da nota não pode ser maior que 4 dias
  if ( to_date(P_DATA,'dd/mm/yyyy') < trunc(sysdate) - 4 ) then
      pStatus := Status_Erro;
      pMessage  := 'Data da Nota a menor em 4 dias ! Verifique ' || to_char(to_date(p_data,'dd/mm/yyyy'),'dd/mm/yyyy');  
      Return;
  End if;
    
  -- Data de Emissão da Nota não pode ser maior que 30 dias.
  if ( to_date(P_DATAEMISS,'dd/mm/yyyy') < trunc(sysdate) - 30 ) then
      pStatus := Status_Erro;
      pMessage  := 'Data de emissão da Nota maior que 30 dias ! Verifique ' || to_char(to_date(P_DATAEMISS,'dd/mm/yyyy'),'dd/mm/yyyy');  
      Return;
  End if;
  
  --Data de emissão não pode ser maior que a data de hoje.
  if ( to_date(P_DATA,'dd/mm/yyyy') > trunc(sysdate) ) then
      pStatus := Status_Erro;
      pMessage  := 'Data Maoir que hoje ! Verifique ' || to_char(to_date(p_data,'dd/mm/yyyy'),'dd/mm/yyyy');  
      Return;
  End if;

  --Data de Saida não pode ser maior que hoje.
  if ( to_date(P_DATAEMISS,'dd/mm/yyyy') > trunc(sysdate) ) then
      pStatus := Status_Erro;
      pMessage  := 'Data Maoir que hoje ! Verifique ' || to_char(to_date(P_DATAEMISS,'dd/mm/yyyy'),'dd/mm/yyyy');  
      Return;
  End if;
  
  --Verifico se o Código da Coleta foi passado.
  If nvl(Trim(P_NRCOLETA), 'R') = 'R' Then
    pStatus := Status_erro;
    pMessage := 'Não Foi passado o Número da Coleta';
    Return;
  End If;
  



  --Não estou utilizando um parametro porque a lista de CNPJ ocupa mais espaço do que o permitido 
  --para o campo "TEXTO" da tabela de paramentros.
  vListaCnpjLiber := '15144306000199,15144306003104,15144306003295,15144306003376,15144306006553,
                      15144306006987,15144306007010,15144306007606,15144306007959,15144306008254,
                      15144306008416,15144306009226,33896291000105,34151100000645,33931478000275,
                      00924429000922,03327988000139,06166794000144,17500224000246,33592510007590,
                      33592510001550,33592510037074,33592510007590,33592510042400,33592510007590,
                      33592510007752,33592510000901,33592510042663,01891403000130,34151100001455,
                      12094570000410,75086785000166,88613856000183,62499405000173,03327988000196,
                      529405330000157,33592510002793,030327988000439,72840002000108,09257877000218,
                      0332798800439,42423079001002,03327988000439,38619045000111,15134695000414,
                      03327988000439,04151690000483,03553344000116,03553344000469,09257877000137,
                      00924429000175,04151690000211,15144306007010,15144306006987,15144306007959,
                      15144306003295,15144306003104,15144306007606,15144306008416,15144306000199,
                      15144306003376,15144306006553,15144306008254,15144306009226,15144306006553,
                      15144306006987,15144306007959,15144306004186,
                      33931486003318'; -- coloquei agora a vale fertilizantes



  if ((trim(P_NRCOLETA) = '') or (P_NRCOLETA is null)) then
  pStatus := Status_Erro;
  pMessage  := 'E OBRIGADO DIGITAR O NUMERO DE COLETA';
  Return;
  ELSE

  -- PEGA PARAMETROS
  -- passei qualquer coisa somente para pegar os parametros globais
  sp_usu_parametrossc('spValidaNf', 'jsantos', '010');

  OPEN C_PARAMETROS;
  LOOP
    FETCH C_PARAMETROS
      INTO V_PARAMETRO, V_PARAMTEXTO;
    EXIT WHEN C_PARAMETROS%NOtFOUND;
  
    IF V_PARAMETRO = 'CNPJ_RECEB' Then  V_CNPJ_LIVRES := V_PARAMTEXTO;
       Exit;
    END IF;
    
  END LOOP;
  CLOSE C_PARAMETROS;
  

  --Adicionei na lista de Cnpj Liberados a Lista relacionada acima.
  vListaCnpjLiber := vListaCnpjLiber || V_CNPJ_LIVRES;


  --VERIFICA SE O GRUPO ECONOMICO DO SACADO E DA VALE
  IF (nvl(INSTR(Trim(vListaCnpjLiber), Trim(P_CNPJ_SACADO)),0) = 0) Then 
    BEGIN
      SELECT CL.GLB_GRUPOECONOMICO_CODIGO
        INTO V_GRUPO_ECONOMICO
        FROM T_GLB_CLIENTE CL
       WHERE trim(CL.GLB_CLIENTE_CGCCPFCODIGO) = TRIM(P_CNPJ_SACADO);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_GRUPO_ECONOMICO := '9999';
    END;
  ELSE
    V_GRUPO_ECONOMICO := '9999';
  END IF;

  -- PEGA SE A NOTA E CFOP DE VENDA
  BEGIN
    SELECT DECODE(NVL(CF.GLB_CFOP_FLAGVENDA, Status_Normal), 'S', '1', '0')
      INTO V_CNPJ_DE_VENDA
      FROM T_GLB_CFOP CF
     WHERE CF.GLB_CFOP_CODIGO = P_CFOP;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_CNPJ_DE_VENDA := '0';
  END;


  
  V_CIF_SACADO_VALE := ((V_GRUPO_ECONOMICO = '0020') AND (P_CNPJ_REMET = P_CNPJ_SACADO));

  -- SE GRUPO 0020 VALE E CFOP DE VENDA ENTRA
  IF ((V_GRUPO_ECONOMICO = '0020') AND (V_CNPJ_DE_VENDA = '1') AND (NOT(V_CIF_SACADO_VALE))) THEN
  
    -- VERIFICA SE O CNPJ ESTA LIBERAD
    SELECT count(*)
      INTO V_CONTINUA
      FROM V_WEB_AUTORIZAEXTERNO_CNPJ A
     WHERE TRIM(A.WEB_AUTORIZAEXTERNO_CODIGOREG) = TRIM(P_CNPJ_REMET)
       AND P_DATA BETWEEN A.WEB_AUTORIZAEXTERNO_PERINI AND
           A.WEB_AUTORIZAEXTERNO_PERFIM
       AND NVL(A.WEB_AUTORIZAEXTERNO_FLGPROCES, Status_Normal) = Status_Normal;
  
/*
    Processo de Digitação do XML (Quadren) foi liberado confore reuniao hoje 27/11/2013
    entre Fernanda Botelho , Geliades e Cristiane Ferreira 
    E apos comunicado passado a todas as filiais pela Elaine Gerente do RH
    Sirlano
   
*/   

    if sysdate >= to_date('28/11/2013 00:00:01') Then
       V_CONTINUA := 1;
    End If;   
    

    -- CONTINUA A CRITICA SE NAO ACHAR CNPJ LIBERADO
    IF V_CONTINUA = 0 THEN
       
       SELECT COUNT(*)
       INTO V_CONTINUA
       FROM T_ARM_COLETA CO
       WHERE CO.ARM_COLETA_NCOMPRA = P_NRCOLETA
       AND CO.GLB_TPCARGA_CODIGO = 'EX';
    
    IF V_CONTINUA = 0 THEN
      -- VERIFICA SE NOTA ESTA COMO EXCLUIDA
      SELECT COUNT(*)
        INTO V_CONTINUA
        FROM T_XML_NOTA N
       WHERE TRIM(N.XML_NOTA_NF) = TRIM(P_NOTA)
            -- AND TRUNC(N.XML_NOTA_EMISSAO) = P_DATA
         AND N.XML_NOTA_STATUS IN ('EX', 'NO', 'EC')
         AND N.XML_NOTA_NOTA = 'S'
         AND TRIM(N.GLB_CLIENTE_CGCCPFREMETENTE) = TRIM(P_CNPJ_REMET);
    
      -- CONTINUA A CRITICA SE N?O ACHAR NOTA EXCLUIDA        
      IF V_CONTINUA = 0 THEN
      
        -- VERIFICA SE ASN ESTA LIBERADA
        SELECT count(*)
          INTO V_CONTINUA
          FROM V_WEB_AUTORIZAEXTERNO_ASN A
         WHERE TRIM(A.WEB_AUTORIZAEXTERNO_CODIGOREG) = TRIM(P_NRCOLETA);
      
        -- CONTINUA A CRITCA SE NAO ACHAR ASN LIBERADA
        IF V_CONTINUA = 0 THEN
        
          -- VERIFICA SE EXISTE COLETA LIBERADA
          SELECT count(*)
            INTO V_CONTINUA
            FROM V_WEB_AUTORIZAEXTERNO_COLETA A
           WHERE TRIM(A.WEB_AUTORIZAEXTERNO_CODIGOREG) = TRIM(P_NRCOLETA);
        
          -- CONTINUA A CRITICA SE NA ACHAR A COLETA 
          IF V_CONTINUA = 0 THEN
            -- VERIFICA SE EXISTE NOTA LIBERADA
          
            SELECT count(*)
              INTO V_CONTINUA
              FROM V_WEB_AUTORIZAEXTERNO_NF A
             WHERE A.WEB_AUTORIZAEXTERNO_CODIGOREG =
                   lpad(TRIM(P_NOTA), 6, '0')
               AND TRIM(A.WEB_AUTORIZAEXTERNO_CNPJ) = TRIM(P_CNPJ_REMET);
          
            -- CONTINUA A CRITICA SE NAO ACHAR NOTA LIBERADA
            IF V_CONTINUA = 0 THEN
            
              pStatus := Status_Erro;
              pMessage  := 'NOTA NAO LIBERADA PASSE PELO QUADREM'  
                            || CHR(13)||'Grupo Economico :' || V_GRUPO_ECONOMICO
                            || CHR(13)||'Sacado: ' || P_CNPJ_SACADO;
                                                                   
            
            ELSE
              -- VERIFICA NOTA
            
              pStatus := Status_Normal;
              pMessage  := 'NOTA LIBERADA PELA PELA WEB';
            END IF; -- FIM VERIFICA NOTA
          
          ELSE
            -- VERIFICA COLETA
          
            pStatus := Status_Normal;
            pMessage  := 'COLETA LIBERADA PELA WEB';
          END IF; -- FIM VERIFICA COLETA 
        
        ELSE
          -- VERIFICA ASN
        
          pStatus := Status_Normal;
          pMessage  := 'ASN LIBERADA PELA WEB';
        END IF; -- FIM VERIFICA ASN LIBERADA
      
      ELSE
        -- VERIFICA NOTA EXCLUIDA
        pStatus := Status_Normal;
        pMessage  := 'NOTA LIBERADA ou EXCLUIDA COM MAIS DE UMA HORA';
      END IF; -- FIM VERIFICA NOTA EXCLUIDA
    
    ELSE 
        pStatus :=Status_Normal;
        pMessage := 'COLETA EXPRESSA, VALIDADA COM SUCESSO';
    END IF;
    ELSE
      -- VERIFICA SE CNPJ ESTA LIBERADO
    
      pStatus := Status_Normal;
      pMessage  := 'CNPJ LIBERADO PELA WEB NESTE PERIODO';
    
    END IF; -- FIM VERIFICA CNPJ
  
   
  ELSE
    -- VEIRICA GRUPO E CFOP
  
    pStatus := Status_Normal;
    pMessage  := '';
  
  END IF; -- FIM VEIRICA GRUPO E CFOP  
  END IF;

/*
  V_ORIGEM          T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%Type;
  V_DESTINO         T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%Type;
*/  

  If pStatus = Status_Normal Then
    begin
    Select SUBSTR(CO.ARM_COLETA_TIPO,1,1),
           CO.ARM_ARMAZEM_CODIGO,
           A.GLB_LOCALIDADE_CODIGO,
           cr.glb_cliente_cgccpfcodigo,
           cr.glb_tpcliend_codigo,
           cr.glb_localidade_codigo,
           cd.glb_cliente_cgccpfcodigo,
           cd.glb_tpcliend_codigo,
           cd.glb_localidade_codigo
       Into V_COLETAENTREGA,
            V_ARMAZEM,
            V_LOCARMAZEM,
            V_REMCLICOL,
            V_REMENDCOL,
            V_REMLOCCOL,
            V_DESCLICOL,
            V_DESENDCOL,            
            V_DESLOCCOL
    From t_arm_coleta co,
         T_ARM_ARMAZEM A,
         T_GLB_CLIEND CR,
         T_GLB_CLIEND CD
    Where co.arm_coleta_ncompra = P_NRCOLETA
      And CO.ARM_ARMAZEM_CODIGO = A.ARM_ARMAZEM_CODIGO (+)
      And CO.GLB_CLIENTE_CGCCPFCODIGOCOLETA = CR.GLB_CLIENTE_CGCCPFCODIGO (+)
      And CO.GLB_TPCLIEND_CODIGOCOLETA = CR.GLB_TPCLIEND_CODIGO (+)
      And CO.GLB_CLIENTE_CGCCPFCODIGOENTREG = CD.GLB_CLIENTE_CGCCPFCODIGO (+)
      And CO.GLB_TPCLIEND_CODIGOENTREGA = CD.GLB_TPCLIEND_CODIGO (+);
    exception
      when NO_DATA_FOUND then
         V_COLETAENTREGA := null;
         V_ARMAZEM := null;
         V_LOCARMAZEM := null;
         V_REMCLICOL := null;
         V_REMENDCOL := null;
         V_REMLOCCOL := null;
         V_DESCLICOL := null;
         V_DESENDCOL := null;    
         V_DESLOCCOL := null;
      End;

    begin      
    Select CE.GLB_LOCALIDADE_CODIGO
      Into V_ORIGEM
    From T_GLB_CLIEND CE
    Where CE.GLB_CLIENTE_CGCCPFCODIGO = P_CNPJ_DEST
      And CE.GLB_TPCLIEND_CODIGO = P_DEST_TPEND;
    exception
      when NO_DATA_FOUND then
         V_ORIGEM := null;
      end;

    begin
    Select CE.GLB_LOCALIDADE_CODIGO
      Into V_DESTINO
    From T_GLB_CLIEND CE
    Where CE.GLB_CLIENTE_CGCCPFCODIGO = P_CNPJ_REMET
      And CE.GLB_TPCLIEND_CODIGO = P_REMET_TPEND;
    exception
      when NO_DATA_FOUND then
         V_DESTINO := null;
      end;

  End If;

    
  IF pStatus <> Status_Erro THEN
  begin
     SELECT COUNT(*)
       INTO V_EXISTENOTA
     FROM T_XML_NOTA N
     WHERE N.XML_NOTA_NF = to_number(P_NOTA)
       AND trunc(N.XML_NOTA_EMISSAO) =  to_date(P_DATA, 'dd/mm/yyyy');
--       AND trunc(N.XML_NOTA_EMISSAO) =  to_date(P_DATAEMISS, 'dd/mm/yyyy');
  exception
    when others then
      RAISE_APPLICATION_ERROR(-20001, 'Erro Data:'||P_DATAEMISS ||chr(13)||'Nota '||P_NOTA||sqlerrm);
      
    end;

     IF V_EXISTENOTA > 0 THEN
 
--        Raise_Application_Error(-20001,'sirlano -' || P_NOTA || '-' || P_DATA);
        BEGIN
            SELECT distinct N.XML_NOTA_NUMERO
              INTO P_NOTANUMEROXML
            FROM T_XML_NOTA N    
            WHERE N.XML_NOTA_NF = to_number(P_NOTA)
              AND N.XML_NOTA_EMISSAO = P_DATA
--              AND N.XML_NOTA_EMISSAO = P_DATAEMISS
              AND N.XML_NOTA_DTINCLUSAO = (SELECT MAX(N1.XML_NOTA_DTINCLUSAO)
                                           FROM T_XML_NOTA N1
                                           WHERE N1.XML_NOTA_NF = N.XML_NOTA_NF
                                             AND N1.XML_NOTA_EMISSAO = N.XML_NOTA_EMISSAO);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             V_EXISTENOTA := 0;
          WHEN OTHERS THEN 
             V_EXISTENOTA := 0;
        END;      
    

     END IF; 
       
     IF V_EXISTENOTA > 0 THEN
     
        UPDATE T_XML_NOTA N
        SET N.XML_NOTA_EMISSAO = TRUNC(N.XML_NOTA_EMISSAO) + (V_EXISTENOTA / 1000)
        WHERE N.XML_NOTA_NUMERO = P_NOTANUMEROXML
          AND N.XML_NOTA_EMISSAO = P_DATA;
--          AND N.XML_NOTA_EMISSAO = P_DATAEMISS;
                    
        UPDATE T_XML_NOTALINHA N
        SET N.XML_NOTA_EMISSAO = TRUNC(N.XML_NOTA_EMISSAO) + (V_EXISTENOTA / 1000)
        WHERE N.XML_NOTA_NUMERO = P_NOTANUMEROXML
          AND N.XML_NOTA_EMISSAO = P_DATA;
--          AND N.XML_NOTA_EMISSAO = P_DATAEMISS;

        UPDATE T_XML_NOTAPARCEIRO N
        SET N.XML_NOTA_EMISSAO = TRUNC(N.XML_NOTA_EMISSAO) + (V_EXISTENOTA / 1000)
        WHERE N.XML_NOTA_NUMERO = P_NOTANUMEROXML
          AND N.XML_NOTA_EMISSAO = P_DATA;
--          AND N.XML_NOTA_EMISSAO = P_DATAEMISS;

        UPDATE T_XML_NOTAPARCEIRO N
        SET N.XML_NOTA_EMISSAO = TRUNC(N.XML_NOTA_EMISSAO) + (V_EXISTENOTA / 1000)
        WHERE N.XML_NOTA_NUMERO = P_NOTANUMEROXML
          AND N.XML_NOTA_EMISSAO = P_DATA;
--          AND N.XML_NOTA_EMISSAO = P_DATAEMISS;
        commit;  
     END IF;     
 
  END IF;


END;
                                      
  
  /***************************************************************************************************
  *   Função Verifica de o Carregamento pode voltar para o FIFO                                      *
  ****************************************************************************************************/
  FUNCTION FN_CON_PODEVOLTARCARREG(P_CODCARREG IN T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE)RETURN CHAR IS
  /***************************************************************************************************
  * ROTINA           : FN_CON_CTECARREG                                                              *
  * PROGRAMA         : pkg_fifo                                                                      *
  * ANALISTA         : Klayton Anselmo - KSOUZA                                                      *
  * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                      *
  * DATA DE CRIACAO  : 02/03/2011                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    :                                                                               *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    : VALIDAR SE UM CARREGAMENTO PODE VOLTAR PARA O FIFO                            *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *                                           
  * PARAM. OBRIGAT.  : P_CODCARREG                                                                   *
  ****************************************************************************************************/

  V_ARM_ARMAZEN  T_ARM_ARMAZEM.ARM_ARMAZEM_CODIGO%TYPE;
  V_FLAGACEITO   T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CODSTENV%TYPE;
  V_DATARETORNO  T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_DTRETORNO%TYPE;
  V_PODEVOLTAR   CHAR(1);
  V_CTENAOGERADO INTEGER;
  V_ROTACTE      T_GLB_ROTA.GLB_ROTA_CTE%TYPE;
  vDataFinalizacao tdvadm.t_Arm_Carregamento.arm_carregamento_dtfinalizacao%type;
  vDataFechamento  tdvadm.t_Arm_Carregamento.arm_carregamento_dtfechamento%type;
  vUsuCriou        tdvadm.t_Arm_Carregamento.usu_usuario_crioucarreg%type;
  vUsuFechou       tdvadm.t_Arm_Carregamento.usu_usuario_fechoucarreg%type;
  vMobile          tdvadm.t_Arm_Carregamento.arm_carregamento_mobile%type; 
  vMemoriaCalculo  tdvadm.t_arm_carregamento.ARM_CARREGAMEMCALC_CODIGO%type;
  vQtdeManif       Integer;  
  vAuxiliar        integer;
  vDevRee          tdvadm.t_arm_notacte.arm_notacte_codigo%type;
  vAplicacao       v_glb_ambiente.PROGRAM%type;
  vQtdeVF          integer;
  BEGIN
        select lower(PROGRAM)
           into vAplicacao
        from v_glb_ambiente;
           
        -- VARIAVEL INDICA SE PODE VOLTAR O CARREGAMENTO
        V_PODEVOLTAR   := 'S';

        pkg_fifo.vMSGFuncRetornaCarreg := '';
        -- ROTA DO ARMAZEM
        -- verificando se ja esta finalizado com Vale de frete impresso
        Begin

           -- Sirlano 20/05/2016 verificando se tem Vale de Frete
           select count(*)
             into vQtdeVF
           from t_con_valefrete vf,
                t_arm_carregamento ca
           where ca.arm_carregamento_codigo = P_CODCARREG
             and vf.fcf_veiculodisp_codigo = ca.fcf_veiculodisp_codigo 
             and vf.fcf_veiculodisp_sequencia = ca.fcf_veiculodisp_sequencia;
             
            
           If vQtdeVF > 0 Then             
               V_PODEVOLTAR := 'N';
               pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Vale de Frete Gerado para o Carregamento ' || P_CODCARREG || chr(10);
           End If;         

          
           -- Sirlano em 27/03/2014
           -- coloquei a contagem somente para cte nao cancelados
           
           -- Klayton em 31/08/2015
           -- considera somente se mdfe estiver aceito.
           -- se der algum problema de regra, reavalizar esse processo.
           Select Count(*)
             into vQtdeManif
             from t_con_docmdfe      dm,
                  t_con_conhecimento c,
                  t_con_controlemdfe cm  
             where dm.arm_carregamento_codigo                 = P_CODCARREG
               and dm.con_conhecimento_codigo                 = c.con_conhecimento_codigo (+)
               and dm.con_conhecimento_serie                  = c.con_conhecimento_serie  (+)
               and dm.glb_rota_codigo                         = c.glb_rota_codigo         (+)
               and nvl(c.con_conhecimento_flagcancelado,'N')  = 'N'
               and dm.con_manifesto_codigo                    = cm.con_manifesto_codigo   (+)
               and dm.con_manifesto_serie                     = cm.con_manifesto_serie    (+)
               and dm.con_manifesto_rota                      = cm.con_manifesto_rota     (+)
               and nvl(cm.con_mdfestatus_codigo,'KK')         = 'OK';

           if vQtdeManif > 0 then
               V_PODEVOLTAR := 'N';
               pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Manifesto Gerado para o Carregamento ' || P_CODCARREG || chr(10);
           end if;  
        
           SELECT AR.ARM_ARMAZEM_CODIGO,
                  ar.usu_usuario_crioucarreg,
                  AR.ARM_CARREGAMENTO_DTFECHAMENTO,
                  ar.usu_usuario_fechoucarreg,
                  AR.ARM_CARREGAMENTO_DTFINALIZACAO,
                  nvl(ar.arm_carregamento_mobile,'N'),
                  ar.ARM_CARREGAMEMCALC_CODIGO
             INTO V_ARM_ARMAZEN,
                  vUsuCriou,
                  vDataFechamento,
                  vUsuFechou,
                  vDataFinalizacao,
                  vMobile,
                  vMemoriaCalculo
             FROM T_ARM_CARREGAMENTO AR
             WHERE AR.ARM_CARREGAMENTO_CODIGO = P_CODCARREG;
             If V_ARM_ARMAZEN is null then
                V_PODEVOLTAR := 'N';
                pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Falta Codigo do Armazem no Carregamento - TI' || chr(10);
             End if;    

             IF vUsuCriou IS NOT NULL THEN
                pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Carregamento Criado por  ' || vUsuCriou || chr(10);
             END IF;

             IF vDataFechamento IS NOT NULL THEN
                pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Carregamento Fechado em ' || to_char(vDataFechamento,'dd/mm/yyyy') || ' por ' || vUsuFechou || chr(10);
             END IF;

             IF vUsuFechou IS NOT NULL THEN
                pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Carregamento Fechado por  ' || vUsuFechou || chr(10);
             END IF;

             IF vDataFinalizacao IS NOT NULL THEN
                V_PODEVOLTAR   := 'N';
                pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Carregamento Finalizado em ' || to_char(vDataFinalizacao,'dd/mm/yyyy') || chr(10);
             END IF;    
             
             IF vMobile = 'S' THEN
--                if instr(vAplicacao,'prj_carregamento') = 0 Then                
                   pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Carregamento Gerado no MOBILE' || chr(10);
--                Else
--                   pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Carregamento Gerado no MOBILE' || chr(10);
--                   V_PODEVOLTAR   := 'N';
--               End If;   
             Else
                pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Carregamento Gerado no FIFO' || chr(10);
                  
             END IF;
             
             if vMemoriaCalculo is not null Then
                -- Verifica se o mesmo ja foi dividido em varios carregamentos.
                -- Antes de Liberar.
                select count(*)
                  into vAuxiliar
                from t_arm_carregamento ca
                where ca.arm_carregamemcalc_codigo =  vMemoriaCalculo;
                 
                -- Sirlano 
                -- 31/07/2017
                -- Não usa mais memoria de Calculo
                if vAuxiliar = -1 Then
                   V_PODEVOLTAR := 'M'; -- memoria de Calculo
                End If;   
                
                if V_PODEVOLTAR = 'M' Then
                   pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Carregamento Possui Memoria de Calculo nr. ' || vMemoriaCalculo || chr(10);
                Else
                   pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Carregamento Possui Memoria de Calculo nr. ' || vMemoriaCalculo || chr(10);
                End If;   
             End If;  
             
             If V_PODEVOLTAR = 'S' Then
                 Begin
                     select distinct(ncte.arm_notacte_codigo)
                       into vDevRee
                     from t_arm_notacte ncte,
                          t_arm_nota n,
                          t_arm_carregamentodet cd
                     where cd.arm_carregamento_codigo = P_CODCARREG
                       and ncte.arm_notacte_codigo <> 'NO'
                       and ncte.arm_nota_numero             = n.arm_nota_numero
                       and ncte.glb_cliente_cgccpfremetente = rpad(n.glb_cliente_cgccpfremetente,20)
                       and ncte.arm_nota_serie              = n.arm_nota_serie
                       and ncte.arm_nota_sequencia          = n.arm_nota_sequencia
                       and n.arm_embalagem_numero    = cd.arm_embalagem_numero
                       and n.arm_embalagem_flag      = cd.arm_embalagem_flag
                       and n.arm_embalagem_sequencia = cd.arm_embalagem_sequencia;
                       if vDevRee = 'RE' Then
                          V_PODEVOLTAR := 'R';
                       ElsIf vDevRee = 'DE' Then
                          V_PODEVOLTAR := 'D';
                       End If;   
                 Exception
                   When NO_DATA_FOUND Then
                      V_PODEVOLTAR := V_PODEVOLTAR;
                   End ;  
             End If;  
         exception
           When NO_DATA_FOUND Then
               pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Carregamento Não encontado  ' || P_CODCARREG || chr(10);
               V_PODEVOLTAR := 'N';
           End;    
         
         
         
             
             
        -- PEGO SE É UMA ROTA DE CTE      
        begin
           SELECT NVL(R.GLB_ROTA_CTE,'N')
             INTO V_ROTACTE
             FROM T_GLB_ROTA R
            WHERE R.GLB_ROTA_CODIGO = (SELECT AM.GLB_ROTA_CODIGO
                                         FROM T_ARM_ARMAZEM AM
                                         WHERE AM.ARM_ARMAZEM_CODIGO = V_ARM_ARMAZEN);
       exception
         when NO_DATA_FOUND Then
            V_PODEVOLTAR := 'N';
            pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Rota do Armazem nao Identificada ' || V_ARM_ARMAZEN || chr(10);
         End;
           
            
                
        -- VARIAVEL INDICA SE TEM REGISTROS NA NÃO GERADOS;
        V_CTENAOGERADO := 0;
       
        IF V_ROTACTE = 'S' THEN
           -- CURSOR DOS CTE'S DO CARREGAMENTO, PEGO SOMENTE OS CTE DA ROTA PARA ELIMINAR AS TRANSFERENCIAS
            FOR CTE_CARREG IN (SELECT C.CON_CONHECIMENTO_CODIGO,
                                   C.CON_CONHECIMENTO_SERIE,
                                   C.GLB_ROTA_CODIGO
                              FROM T_CON_CONHECIMENTO C
                             WHERE C.ARM_CARREGAMENTO_CODIGO = P_CODCARREG
                               --não deixo os conhecimentos gerados a partir do processo automatico
                               and 0 = ( select count(*)
                                         from 
                                           tdvadm.t_arm_carregamentodet det,
                                           tdvadm.t_arm_embalagem emb
                                         where
                                           det.arm_embalagem_numero = emb.arm_embalagem_numero
                                           and det.arm_embalagem_flag = emb.arm_embalagem_flag
                                           and det.arm_embalagem_sequencia = emb.arm_embalagem_sequencia
                                           and nvl(emb.arm_carregamento_flagvirtual, 'N') = 'S'
                                             
                                       )    
                               AND C.GLB_ROTA_CODIGO = (SELECT A.GLB_ROTA_CODIGO
                                                          FROM T_ARM_ARMAZEM A
                                                          WHERE A.ARM_ARMAZEM_CODIGO = V_ARM_ARMAZEN))
            LOOP
                -- SE FOR SERIE XXX SIGNIFICA QUE ELE JA FOI CANCELADO OU AINDA NÃO FOI IMPRESSO
                IF CTE_CARREG.CON_CONHECIMENTO_SERIE <> 'XXX' THEN
                   BEGIN
                        -- VERIFICO NA TABELA DE CONTROLE DO CTE PARA SABER SE ELE JA FOI ACEITO OU AINDA NÃO RESPONDIDO
                        SELECT NVL(CT.CON_CONTROLECTRCE_CODSTENV,'999'),
                                   CT.CON_CONTROLECTRCE_DTRETORNO
                          INTO V_FLAGACEITO,
                               V_DATARETORNO
                          FROM T_CON_CONTROLECTRCE CT
                         WHERE CT.CON_CONHECIMENTO_CODIGO = CTE_CARREG.CON_CONHECIMENTO_CODIGO
                           AND CT.CON_CONHECIMENTO_SERIE  = CTE_CARREG.CON_CONHECIMENTO_SERIE
                           AND CT.GLB_ROTA_CODIGO         = CTE_CARREG.GLB_ROTA_CODIGO;

                  EXCEPTION WHEN NO_DATA_FOUND THEN
                       -- VEIFICO SE ESTA CTE'S NÃO GERADOS
                       SELECT COUNT(*)
                         INTO V_CTENAOGERADO
                         FROM T_UTI_LOGCTE LO
                        WHERE LO.UTI_LOGCTE_CODIGO      = CTE_CARREG.CON_CONHECIMENTO_CODIGO
                          AND LO.UTI_LOGCTE_SERIE       = CTE_CARREG.CON_CONHECIMENTO_SERIE
                          AND LO.UTI_LOGCTE_ROTA_CODIGO = CTE_CARREG.GLB_ROTA_CODIGO;
                  END;

                       IF V_CTENAOGERADO <= 0 THEN
                          IF (V_FLAGACEITO = '999') AND (V_DATARETORNO IS NULL) THEN
                              V_PODEVOLTAR := 'N';
                              pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - CTe ja Gereado,Aguarde Retorno da SEFAZ' || chr(10);
                          END IF;    
                              
                          IF (V_FLAGACEITO = '100') AND (V_DATARETORNO IS NOT NULL) THEN
                              V_PODEVOLTAR := 'N';
                              pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - CTE Aceito, Cancele antes de Retornar' || chr(10);
                             
                          END IF;
                             
                          IF (V_FLAGACEITO <> '100') AND (V_DATARETORNO IS NOT NULL) THEN
                              SELECT CASE WHEN V_PODEVOLTAR = 'S' THEN 'S'
                                          ELSE 'N'
                                          END PODE
                                INTO V_PODEVOLTAR
                                FROM DUAL; 
                          END IF;
                       ELSE
                           SELECT CASE WHEN V_PODEVOLTAR = 'S' THEN 'S'
                                       ELSE 'N'
                                       END PODE2
                                INTO V_PODEVOLTAR
                                FROM DUAL;
                       END IF;
                 
                 ELSE  
                     SELECT CASE WHEN V_PODEVOLTAR = 'S' THEN 'S'
                                 WHEN V_PODEVOLTAR = 'D' THEN 'D'                               
                                 WHEN V_PODEVOLTAR = 'R' THEN 'R'                               
                                 ELSE 'N'
                                      END PODE2
                                INTO V_PODEVOLTAR
                                FROM DUAL;           
                 END IF; 
                 
                 IF V_PODEVOLTAR = 'N' THEN
                    RETURN V_PODEVOLTAR;        
                 END IF;     
            END LOOP;
        
        ELSE
            FOR CTRC_CARREG IN (SELECT CO.CON_CONHECIMENTO_NRFORMULARIO P_NUMFORMULARIO,
                                       CO.CON_CONHECIMENTO_SERIE P_SERIE
                                  FROM T_CON_CONHECIMENTO CO
                                  WHERE CO.ARM_CARREGAMENTO_CODIGO = P_CODCARREG
                                    AND CO.GLB_ROTA_CODIGO = (SELECT AR.GLB_ROTA_CODIGO
                                                                FROM T_ARM_ARMAZEM AR
                                                               WHERE AR.ARM_ARMAZEM_CODIGO = (SELECT C.ARM_ARMAZEM_CODIGO
                                                                                                FROM T_ARM_CARREGAMENTO C
                                                                                               WHERE C.ARM_CARREGAMENTO_CODIGO = P_CODCARREG)))
            LOOP
                IF (CTRC_CARREG.P_NUMFORMULARIO IS NULL) AND (CTRC_CARREG.P_SERIE = 'XXX') THEN
                   SELECT CASE WHEN V_PODEVOLTAR = 'S' THEN 'S'
                          ELSE 'N'
                          END PODE2
                     INTO V_PODEVOLTAR
                     FROM DUAL;
                ELSE
                    V_PODEVOLTAR := 'N';
                    pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - CTRC/CTe Impresso Cancele antes' || chr(10);                    
                END IF;
                
                IF V_PODEVOLTAR = 'N' THEN
                    RETURN V_PODEVOLTAR;        
                END IF;
                    
            END LOOP;    

        END IF;    
        
        if V_PODEVOLTAR = 'S' Then 
            insert into t_arm_cargadet
            select n.arm_carga_codigo,
                   '1',
                   n.arm_nota_numero,
                   n.arm_embalagem_numero,
                   n.arm_embalagem_flag,
                   n.usu_usuario_codigo,
                   n.arm_nota_sequencia,
                   n.arm_embalagem_sequencia,
                   n.glb_cliente_cgccpfremetente,
                   null
            from t_arm_nota n,
                 t_arm_carregamentodet cdd
            where cdd.arm_carregamento_codigo = P_CODCARREG
              and n.arm_embalagem_numero = cdd.arm_embalagem_numero
              and n.arm_embalagem_flag = cdd.arm_embalagem_flag
              and n.arm_embalagem_sequencia =  cdd.arm_embalagem_sequencia
              and 0 = (select count(*)
                       from t_arm_cargadet cdet
                       where cdet.arm_carga_codigo = n.arm_carga_codigo
                         and cdet.arm_cargadet_seq = '1');
        End If;
        
        RETURN V_PODEVOLTAR;
  END FN_CON_PODEVOLTARCARREG;
  
  
  FUNCTION FN_CON_MSNCONHECIMENTO(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                  P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                  P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)RETURN VARCHAR2 IS
 /***************************************************************************************************
   * ROTINA           : FN_CON_MSNCONHECIMENTO                                                       *
   * PROGRAMA         : pkg_fifo                                                                     *
   * ANALISTA         : Klayton Anselmo - KSOUZA                                                     *
   * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                     *
   * DATA DE CRIACAO  : 03/03/2011                                                                   *
   * BANCO            : ORACLE-TDP                                                                   *
   * EXECUTADO POR    :                                                                              *
   * ALIMENTA         :                                                                              *
   * FUNCINALIDADE    : RETORNA A MENSAGEM DO CTE / CTRC                                             *
   * ATUALIZA         :                                                                              *
   * PARTICULARIDADES :                                                                              *                                           
   * PARAM. OBRIGAT.  : P_CTRC, P_SERIE, P_ROTA                                                      *
  ***************************************************************************************************/
  V_RETORNO             VARCHAR2(250);
  V_ROTACTE             T_GLB_ROTA.GLB_ROTA_CTE%TYPE;
  V_NUNFORM             T_CON_CONHECIMENTO.CON_CONHECIMENTO_NRFORMULARIO%TYPE;
  V_CTENAOGERADO        INTEGER;
  V_FLAGACEITO          T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CODSTENV%TYPE;
  V_FLAGACEITOCancel    T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_CODSTCANCEL%TYPE;
  V_DATARET             T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_DTRETORNO%TYPE;
  V_MESSAGECTE          T_GLB_CTEMSNGRET.GLB_CTEMSGRET_DESCRICAO%TYPE;
  V_DATARETCancel       T_CON_CONTROLECTRCE.CON_CONTROLECTRCE_DTRETORNO%TYPE;
  
BEGIN
      -- PARA SABER SE É ROTA DE CTE
      If P_ROTA <> '021' Then
        SELECT RT.GLB_ROTA_CTE
        INTO V_ROTACTE
        FROM T_GLB_ROTA RT
        WHERE RT.GLB_ROTA_CODIGO = P_ROTA;
      Else
        V_ROTACTE := 'S';
      End If;  
        
        
        

        IF V_ROTACTE = 'S' THEN
           BEGIN
             -- VERIFICO NA TABELA DE CONTROLE DO CTE PARA SABER SE ELE JA FOI ACEITO OU AINDA NÃO RESPONDIDO
             SELECT NVL(CT.CON_CONTROLECTRCE_CODSTENV, '999'),
                    CT.CON_CONTROLECTRCE_DTRETORNO,
                    NVL(CT.CON_CONTROLECTRCE_CODSTCANCEL, '999'),
                    CT.CON_CONTROLECTRCE_DTRETCANCEL
               INTO V_FLAGACEITO,
                    V_DATARET,   
                    V_FLAGACEITOCancel,
                    V_DATARETCancel
               FROM T_CON_CONTROLECTRCE CT
              WHERE CT.CON_CONHECIMENTO_CODIGO = P_CTRC
                AND CT.CON_CONHECIMENTO_SERIE  = P_SERIE
                AND CT.GLB_ROTA_CODIGO         = P_ROTA;

                IF V_FLAGACEITO = '100' THEN
                   
                   if V_FLAGACEITOCancel = '101' then
                      V_RETORNO := 'CANCELADO';
                   else  
                      V_RETORNO := 'OK';
                   end if;      
                   
                ELSE
                   IF (V_FLAGACEITO <> '999') AND (V_DATARET IS NOT NULL) THEN
                      SELECT B.GLB_CTEMSGRET_DESCRICAO
                        INTO V_MESSAGECTE
                        FROM T_GLB_CTEMSNGRET B
                        WHERE B.GLB_CTEMSGRET_CODIGOMENSAGEN = V_FLAGACEITO;

                        V_RETORNO:= SUBSTR(V_MESSAGECTE,1,250);
                   ELSE
                        V_RETORNO := 'AGUARDANDO RETORNO';
                   END IF;
                END IF;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               -- VEIFICO SE ESTA CTE'S NÃO GERADOS
               SELECT COUNT(*)
                 INTO V_CTENAOGERADO
                 FROM T_UTI_LOGCTE LO
                WHERE LO.UTI_LOGCTE_CODIGO      = P_CTRC
                  AND LO.UTI_LOGCTE_SERIE       = P_SERIE
                  AND LO.UTI_LOGCTE_ROTA_CODIGO = P_ROTA;
                  
                 IF V_CTENAOGERADO >= 1 THEN
                    V_RETORNO := 'NÃO GERADO';        
                 END IF;
                 
                 IF P_SERIE = 'XXX' THEN
                     V_RETORNO := 'NÃO IMPRESSO';       
                 END IF;     
           END;
        ELSE
            SELECT NVL(TRIM(CC.CON_CONHECIMENTO_NRFORMULARIO),'NULO')
              INTO V_NUNFORM
              FROM T_CON_CONHECIMENTO CC
             WHERE CC.CON_CONHECIMENTO_CODIGO = P_CTRC
               AND CC.CON_CONHECIMENTO_SERIE  = P_SERIE
               AND CC.GLB_ROTA_CODIGO         = P_ROTA;

             IF (P_SERIE <> 'XXX') AND(TRIM(V_NUNFORM) <> 'NULO') THEN
                V_RETORNO := 'OK';
             ELSE
                V_RETORNO := 'NAO IMPRESSO';
             END IF;
        END IF;
        
   RETURN V_RETORNO;
 END FN_CON_MSNCONHECIMENTO;

  /*************************************************************************************************************
  * Procedure Responsável por informar ao FrontEnd se o carregamento, em rota de CTE, pode voltar para o fifo  *
  /************************************************************************************************************/
  procedure sp_RetornaCarrgamento(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                  pStatus    out char,
                                  pMessage   out Varchar2) as
            
                                             
     vContador  number;
     vArmazem   tdvadm.t_arm_armazem.arm_armazem_codigo%type;
  begin    
    pStatus := 'E';
    pMessage := 'Versão indevida' || chr(13) || 'Favor forçe uma atualização do Carregamento';
--    Return;
    -- inicializo o variavel para a minha seção
    pkg_fifo.vMSGFuncRetornaCarreg := 'sirlano';
    If (FN_CON_PODEVOLTARCARREG(pCodCarreg) = 'S') Then
      Begin
        select c.arm_armazem_codigo
          into vArmazem
        from t_arm_carregamento c
        where c.arm_carregamento_codigo = pCodCarreg;   
        sp_exclui_xxx_do_carreg_teste(pCodCarreg);
        select count(*)
          into vContador
       from t_con_conhecimento  cc
       where cc.arm_carregamento_codigo = pCodcarreg  
         and  cc.con_conhecimento_serie = 'XXX';
         
       if vContador <> 0  then  
          pStatus:= pkg_glb_common.Status_Erro;
          pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'BLQ - Não foram excluidos todos os ctrc s SERIE XXX' || chr(10) ;
       ELSE   
         select count(*)
            into vContador
         from t_con_conhecimento  cc,
              t_arm_armazem a
         where cc.arm_carregamento_codigo = pCodcarreg
           and a.arm_armazem_codigo = vArmazem
           and ( ( cc.glb_rota_codigo = a.glb_rota_codigo ) or (cc.glb_rota_codigo = a.glb_rota_codigonf ) );
      end if ;     
       
       if vcontador = 0 then
         update t_arm_carregamento tac
           set tac.arm_carregamento_dtfechamento = null ,
               tac.usu_usuario_fechoucarreg = null ,
               tac.arm_carregamento_qtdctrc = 0 ,
               tac.arm_carregamento_qtdimpctrc = 0 ,
               tac.arm_carregamento_dtcria =  GREATEST(tac.arm_carregamento_dtcria,sysdate - 10)               
         where tac.arm_carregamento_codigo = pCodCarreg;
         
         pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Limpando dados do Carregamento' || chr(10);
         update t_arm_nota tan
           set  tan.con_conhecimento_codigo = null,
                tan.con_conhecimento_serie  = null,
                tan.glb_rota_codigo         = null
         where  tan.arm_carregamento_codigo = pCodcarreg
           and  tan.con_conhecimento_serie = 'XXX';
         
         pkg_fifo.vMSGFuncRetornaCarreg := pkg_fifo.vMSGFuncRetornaCarreg || 'INF - Limpando ctrcs serie XXX das  notas' || chr(10);
         
         delete tdvsva.t_cs278_simulador s where s.arm_carregamento_codigo = pCodcarreg and s.arm_armazem_codigo = vArmazem ;
       IF pStatus <> pkg_glb_common.Status_Erro Then         
          commit;
       end if;    
          pStatus:= pkg_glb_common.Status_Nomal;
          pMessage := '';
       Else
         pStatus:= pkg_glb_common.Status_Erro;
          pMessage := 'EXISTEM CONHECIMENTOS NO CARREGAMENTO';
       End if;   
      Exception 
        When Others Then
          pStatus := status_erro;
          pMessage:= 'Erro ao retornar carregamento para o fifo' || chr(10) || 'INFORMAR - ' || sqlerrm;
          
     End;
     else
       pStatus := status_erro;
       pMessage:= 'Carregamento não pode retornar ao FIFO.' || chr(10) ;
      pStatus := 'N';
      
    End If;
       pMessage:= pMessage || 
                  '**************************************************************' || chr(10) ||
                  pkg_fifo.vMSGFuncRetornaCarreg  || chr(10) ||
                  '**************************************************************' || chr(10);
    
    
    
  end;
  
  FUNCTION FN_CON_RETORNAROTACARREG(P_CODCARREGAMENTO IN T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%TYPE,P_TIPO in CHAR default 'C')RETURN CHAR IS
  /***************************************************************************************************
   * ROTINA           : FN_CON_RETORNAROTACARREG                                                     *
   * PROGRAMA         : pkg_fifo                                                                     *
   * ANALISTA         : Klayton Anselmo - KSOUZA                                                     *
   * DESENVOLVEDOR    : Klayton Anselmo - KSOUZA                                                     *
   * DATA DE CRIACAO  : 03/03/2011                                                                   *
   * BANCO            : ORACLE-TDP                                                                   *
   * EXECUTADO POR    :                                                                              *
   * ALIMENTA         :                                                                              *
   * FUNCINALIDADE    : RETORNA A ROTA DO CARREGAMENTO                                               *
   * ATUALIZA         :                                                                              *
   * PARTICULARIDADES :                                                                              *                                           
   * PARAM. OBRIGAT.  : P_CODCARREGAMENTO                                                            *
   * ALTERACOES       : Sirlano 18/09/2017                                                           *
   *                  : Inclui um Parametro para retornar a Rota de (C)Te ou de (N)FSe               *
  ***************************************************************************************************/
  V_ROTA varchar2(15);
  BEGIN
     V_ROTA := 'XXX';
     If nvl(P_TIPO,'C') = 'C' Then
          SELECT AR.GLB_ROTA_CODIGO
            INTO V_ROTA
          FROM tdvadm.T_ARM_ARMAZEM AR
          WHERE AR.ARM_ARMAZEM_CODIGO = (SELECT CR.ARM_ARMAZEM_CODIGO
                                         FROM T_ARM_CARREGAMENTO CR
                                         WHERE CR.ARM_CARREGAMENTO_CODIGO = P_CODCARREGAMENTO);
     ElsIf nvl(P_TIPO,'C') = 'N' Then
          SELECT AR.GLB_ROTA_CODIGONF
            INTO V_ROTA
          FROM tdvadm.T_ARM_ARMAZEM AR
          WHERE AR.ARM_ARMAZEM_CODIGO = (SELECT CR.ARM_ARMAZEM_CODIGO
                                         FROM T_ARM_CARREGAMENTO CR
                                         WHERE CR.ARM_CARREGAMENTO_CODIGO = P_CODCARREGAMENTO);
     End If;
  Return V_ROTA;
  END FN_CON_RETORNAROTACARREG;     
  
                                     

  /*************************************************************************************************************/ 
  /* Procedure utilizada apenas para retornar os dados de um cliente a partir de um CNPJ                       */                                       
  /*************************************************************************************************************/ 
  procedure sp_retornaDadosCliente( pCnpj    in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                    pStatus  out char,
                                    pMessage out varchar2,
                                    pCursor out T_CURSOR ) as
   /* Variável de controle */
   vCount integer := 0;                                    
  begin
    begin
      pStatus:= Status_normal;
      pMessage:= '';
      
      /* Primeiro eu vejo se o cnpj foi encontrado na base */
      Select count(*) into vCount from tdvadm.t_glb_cliente c 
      where c.glb_cliente_cgccpfcodigo = pCnpj;
      
      /* Caso não encontre nenhum endereço */
      if ( vCount = 0 ) then
        pStatus:= Status_Erro;
        pMessage:= 'Não encontrado dados de Cliente através do CNPJ '|| pCnpj;
        return;
      end if;
      
      /* Caso seja encontrado mais de um registro com o mesmo CNPJ, estou imaginando que por algum motivo, o usuario consiga entrar com o prefixo */
      if (vCount > 1) then
        pStatus := Status_Erro;
        pMessage:= 'Foram encontrados mais de um cliente com o mesmo CNPJ.'||chr(13)||'Entre em contato com o responsável por Cadastro';
        return;
      end if;
      
      /* Em condições normais, o select deve encontar apenas um registro por cnpj */
      if (vCount = 1) then
        pStatus:= Status_normal;
        pMessage:= '';
        
        /* Montagem do cursor. envio todos os endereços cadastrados em um determinado CNPJ. */        
        open pCursor for
          SELECT
            cliente.glb_cliente_cgccpfcodigo   cnpj,
            cliente.glb_cliente_razaosocial    rsocial,
            endCli.Glb_Tpcliend_Codigo         tpCliend,
            endCli.Glb_Cliend_Endereco         endereco,
            endCli.Glb_Cliend_Codcliente       CodCliente
          FROM
            tdvadm.t_glb_cliente Cliente,
            tdvadm.t_glb_cliend  endCli
          WHERE 
            cliente.glb_cliente_cgccpfcodigo = endCli.Glb_Cliente_Cgccpfcodigo
            and cliente.glb_cliente_cgccpfcodigo = pCnpj;
      end if;
      
      
    exception
      when others then
        pStatus := Status_erro;
        pMessage:= 'Erro ao buscar os dados do Cliente.';
    end;
    
  end sp_retornaDadosCliente;
  
  /*************************************************************************************************************/
  /* Procedure utilizada apenas para retornar a descrição CFOP, a partir de um código                          */  
  /*************************************************************************************************************/
  procedure sp_retornaDescCFOP ( pCFOP    in  tdvadm.t_glb_cfop.glb_cfop_codigo%type,
                                   pStatus  out char,
                                   pMessage out varchar2,
                                   pCursor  out T_CURSOR ) As
      /* Variável de controle */                              
      vCount integer := 0;                                   
    begin
      begin
        /* Primeiro verifico se existe para código passado uma descrição */
        select count(*) into vCount 
        from t_glb_cfop c
        where c.glb_cfop_codigo = pCfop;
        
        if ( vCount = 0 ) then
          pStatus := Status_erro;
          pMessage := 'Não existe Descrição para o código passado.';
        end if;
        
        /* Caso encontre o código CFOP, devolve o cursor com a descrição */
        if ( vCount = 1) then
          pStatus := Status_normal;
          pMessage := '';
          
          /* estrutura do cursor que será devolvido. */
          open pCursor for 
           Select 
             c.glb_cfop_codigo     codigo, 
             c.glb_cfop_descricao  descricao
            from 
              t_glb_cfop c
           where c.glb_cfop_codigo = pcfop;
        end if;
        
        
      exception 
        /* caso ocorra qualquer erro.. */
        when others then
          pStatus := Status_erro;
          pMessage := 'Erro ao tentar localizar Descrição CFOP';
        end;
      
    end sp_retornaDescCFOP;     
    
  /*************************************************************************************************************/
  /* procedure utilizada apenas para retornar o maior saque de uma solicitação ou de uma tabela                */
 /*************************************************************************************************************/
  procedure sp_retornaMoirSaqTabSol(pTpReferencia  in char,
                                    pCodReferencia in char,
                                    pStatus        out char,
                                    pMessage       out varchar2,
                                    pCursor        out t_cursor ) as
   vSaq varchar2(10);
  BEGIN
    begin
    /* Caso o Tipo de referência seja do tipo T, Pego o maior saque da Tabela passada pelo CodReferencia */
     if ( Trim(pTpReferencia) = 'T' ) then
       select max(ta1.slf_tabela_saque)                                 
         into vSaq from t_slf_tabela ta1                                          
       where ta1.slf_tabela_codigo = pCodReferencia   
         and ta1.slf_tabela_vigencia = (SELECT MAX(ta2.slf_tabela_vigencia)
                                        FROM t_slf_tabela ta2
                                        WHERE  ta2.slf_tabela_vigencia <= trunc(sysdate)
                                        And ta2.slf_tabela_codigo = ta1.slf_tabela_codigo);
     end if;   
     
     /* Caso o Tipo de Referência seja do Tipo 'S', pego o maior saque da Solicitação passada pelo CodReferencia  */
     if ( Trim(pTpReferencia) = 'S' ) then
       select max(sf1.slf_solfrete_saque)                               
        into vSaq  from t_slf_solfrete sf1                                        
       where sf1.slf_solfrete_codigo = pCodReferencia
        and sf1.slf_solfrete_dataefetiva >= trunc(sysdate)
        AND sf1.slf_solfrete_vigencia <= trunc(sysdate);
     end if;
     
     /* Caso encontre o saque, devolvo um cusror apenas com o numerco do saque */   
     if ( nvl(Trim(vsaq), 'R') <> 'R' ) then
       pStatus := Status_normal;
       pMessage := '';
       open pCursor for
        select vSaq Saque from dual;
     else
       /* Caso não encontre, envio o status de erro, e a mesnage de não ter encontrado. */
       Open pCursor For Select 't' "Saque" From dual;
      pStatus := Status_erro;
      pMessage := 'Tabela ou Solicitação não encontrada.';
     end if; 
   exception 
     /* caso ocorra qualquer tipo de erro, devolvo o status e a mensagem de erro */
      when others Then
        Open pCursor For Select 't' From dual;
        pStatus:= Status_erro;
        pMessage := 'Erro ao tentar localizar Tabela ou solicitação.';
    end;
    
  END sp_retornaMoirSaqTabSol;
  
  
  /* Procedure responsável por retornar cursor que servirá para alimentar o Grid de Carregamento na aba "FIFO" */                                    
  procedure sp_DadosCarregamento( pCodVeiculo      in tdvadm.t_arm_carregamento.fcf_veiculodisp_codigo%type,
                                  pArmazem         in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                                  pStatus         out char,
                                  pMessage        out varchar2,
                                  pCursor         out t_cursor ) as
  begin
    open pCursor for select sysdate + 0.004 from dual;
     /*SELECT ARM_CARREGAMENTO_CODIGO,             
       CAR_VEICULO_PLACA,                   
       ARM_CARREGAMENTO_PESOCOBRADO,        
       ARM_CARREGAMENTO_PESOREAL,           
       FCF_TPVEICULO_CODIGO,                
       ARM_CARREGAMENTO_PESOBALANCA,        
       CAR_VEICULO_SAQUE,                   
       ARM_CARREGAMENTO_PESOCUBADO,         
       FRT_CONJVEICULO_CODIGO,              
       ARM_CARREGAMENTO_DTFECHAMENTO,       
       FCF_VEICULODISP_CODIGO,              
       FCF_VEICULODISP_SEQUENCIA,           
       ARM_CARREGAMENTO_QTDCTRC,            
       ARM_CARREGAMENTO_QTDIMPCTRC,         
       ARM_CARREGAMENTO_DTVIAGEM,           
       ARM_CARREGAMENTO_ORDEMENTREGA,       
       ARM_CARREGAMENTO_DTENTREGA,          
       ARM_CARREGAMENTO_FLAGMANIFESTO,      
       ARM_ARMAZEM_CODIGO,                  
       ARM_CARREGAMENTO_DTFINALIZACAO,      
       ARM_CARREGAMENTO_AUTORIZASPOT        
  FROM T_ARM_CARREGAMENTO C                 
  where  
    c.arm_carregamento_dtfechamento is null 
    and nvl(c.arm_carregamento_qtdctrc,0) = 0 
    
     AND C.ARM_ARMAZEM_CODIGO = pArmazem*/


/*    And ( (nvl(C.ARM_CARREGAMENTO_MOBILE, 'N') <> 'S')  --Não ter vindo do carregamento MOBILE
           Or ( (nvl(C.ARM_CARREGAMENTO_MOBILE,  'N')= 'S'  --Caso tenha vindo do carregamrnyo MOBILE
                  And ( (nvl(C.ARM_ESTAGIOCARREGMOB_CODIGO, 'I')= 'F') or (nvl(C.ARM_ESTAGIOCARREGMOB_CODIGO, 'I')= 'C')    ))
*/
/*    order by to_number(arm_carregamento_codigo); */


    
  
  end;
  
  /* PROCEDURE UTILIZADA PARA POPULAR O GRID PRINCIPAL DO RECEBIMENTO
  MA
  
   */
  procedure sp_getNotasRecebimentos( pNumNota      in  char,
                                     pCnpj         in  char,
                                     pEmbalagem    in  char,
                                     pCarregamento in  char,
                                     pColeta       in  char,
                                     pPo           in  char,
                                     pDataIni      in  char,
                                     pDataFim      in  char,
                                     pAxo          in  char,
                                     pArmazem      in  char,
                                     pCursor       out T_CURSOR,
                                     pStatus       out char,
                                     pMessage      out varchar2) AS
  begin
     pkg_fifo_recebimento.sp_getNotasRecebimentos( pNumNota,
                                                   pCnpj,
                                                   pEmbalagem,
                                                   pCarregamento,
                                                   pColeta,
                                                   pPo,
                                                   pDataIni,
                                                   pDataFim,
                                                   pAxo,
                                                   pArmazem,
                                                   pCursor,
                                                   pStatus,
                                                   pMessage
                                                  );  
    
  end;  
  
 /*************************************************************************************************************/
 /* Procedure responsável por retornar o SAQUE da Tabela ou Solicitação                                       */
 /*************************************************************************************************************/
  procedure sp_getSaque_TabSol( pTpRequisicao in char,
                                pNrRequisicao in char,
                                pStatus       out char,
                                pMessage      out varchar2,
                                pCursor       out t_cursor ) AS
  vSaq integer := '0';
  Begin
   begin  
     /* caso a Requisição seja uma tabela */
    if ( lower(Trim(pTpRequisicao)) = 't' ) then
       select max(ta1.slf_tabela_saque) into vSaq
       from tdvadm.t_slf_tabela ta1                                          
       where ta1.slf_tabela_codigo = pNrRequisicao
--       and ta1.slf_tabela_vigencia <= trunc(sysdate);                 
         and ta1.slf_tabela_vigencia = (SELECT MAX(ta2.slf_tabela_vigencia)
                                        FROM t_slf_tabela ta2
                                        WHERE  ta2.slf_tabela_vigencia <= trunc(sysdate)
                                        And ta2.slf_tabela_codigo = ta1.slf_tabela_codigo);
    end if;
    
    /* caso a requisição seja uma solicitação */
    if ( lower(Trim(pTpRequisicao)) = 's' ) then
      pStatus := 'N';
       select max(sf1.slf_solfrete_saque) into vSaq                               
         from tdvadm.t_slf_solfrete sf1                                        
        where sf1.slf_solfrete_codigo = pNrRequisicao
          and sf1.slf_solfrete_dataefetiva >= trunc(sysdate)
          AND sf1.slf_solfrete_vigencia <= trunc(SYSDATE);
    end if;
    
    if nvl(to_char(vSaq), 'R') = 'R' then
      pMessage := 'Saque não encontrado.';
      vSaq := null;
      pStatus := Status_erro;
    else
      pMessage := '';
      pStatus := Status_Normal;  
      open pCursor for
      select vSaq "Saque" from dual;

    end if;
    
      
  
    
    exception 
      when others then
        /* Caso ocorra qualquer tipo de erro, mostro na tela o motivo do erro */
        pStatus := Status_erro;
        pMessage := 'Erro ao buscar o Saque '|| sqlerrm;
    end;
    
  end sp_getSaque_TabSol;  
  
  /*************************************************************************************************************/
  /* Procedure utilizada para retornar um cursor contendo "Código, Estado e Cidade" de uma localidade          */
  /*************************************************************************************************************/
  procedure sp_buscaLocalidade(pLocalidade   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                               pArmazem      in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                               pCnpj         in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                               pTpEnd        in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                               pStatus       out char,
                               pMessage      out varchar2,
                               pCursor       out T_CURSOR ) AS 
  Begin
    /*-----------------------------------------------------------------------------------------------------------*/
    /* Procedure utilizada para retornar um cursor com "Código, estado e cidade" de uma localidade utilizado     */
    /* como paramentro, o próprio Código de Localidade, um Cnpj + Tipo de Endereço ou Código de Armazem.         */ 
    /* O corpo dessa procedure está no package "pkg_fifo_AUXILIAR                                                */  
    /*-----------------------------------------------------------------------------------------------------------*/
    pkg_fifo_auxiliar.sp_buscaLocalidade( pLocalidade, 
                                          pArmazem, 
                                          pCnpj, 
                                          pTpEnd, 
                                          pStatus, 
                                          pMessage, 
                                          pCursor);
    
  end sp_buscaLocalidade;
  
  /**************************************************************************************************************************************/
  /* Procedure utilizada para buscar Código e descrição de armazem, Código e Descrição de Rota, a partir do código do Armazem ou Rota   */
  /**************************************************************************************************************************************/
  procedure sp_buscaArmazemRota( pCodArmazem   in tdvadm.t_arm_armazem.arm_armazem_codigo%type,
                                 pRota         in tdvadm.t_glb_rota.glb_rota_codigo%type,
                                 pStatus       out char, 
                                 pMessage      out varchar2,
                                 pCursor       out T_CURSOR ) as  
  begin
    /*-----------------------------------------------------------------------------------------------------------*/
    /* Procedure utilizada para retornar um cursor com "Codigo +Descricao de armazem e Rota" como paramentro     */
    /* o código de uma rota ou de um armazem                                                                     */ 
    /* O corpo dessa procedure está no package "pkg_fifo_AUXILIAR                                                */  
    /*-----------------------------------------------------------------------------------------------------------*/
    
    pkg_fifo_auxiliar.sp_buscaArmazemRota( pCodArmazem,
                                           pRota,
                                           pStatus,
                                           pMessage,
                                           pCursor);
    
  end sp_buscaArmazemRota;       
  
  procedure sp_getNotaFiscal( pNumNota       in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pCnpjRemetente in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pCnpjDestino   in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pNumColeta     in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pNumEmbalagem  in tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pStatus        out char,
                            pMessage       out varchar2,
                            pCursor        out T_CURSOR) as
  begin
    pkg_fifo_recebimento.sp_getNotaFiscal( pNumNota,
                                           pCnpjRemetente,
                                           pCnpjDestino,
                                           pNumColeta,
                                           pNumEmbalagem,
                                           pStatus, 
                                           pMessage,
                                           pCursor);

    
  end;       
  
  /**************************************************************************************************************************************/
  /* Procedue utilizada para buscar a Descrição e os tipos de embalagem, a partir de um código da onu                                   */
  /**************************************************************************************************************************************/
  procedure sp_buscaDadosOnu(pCodOnu        in tdvadm.t_glb_onu.glb_onu_codigo%type,
                             pStatus        out char,
                             pMessage       out varchar2,
                             pCursor        out t_cursor ) as
  begin
    /*-----------------------------------------------------------------------------------------------------------*/
    /* Procedure utilizada para retornar um cursor com "Código, descrição e tipo de embalagem" de produtos ONU   */
    /* passando como paramentro o código da onu.                                                                 */ 
    /* O corpo dessa procedure está no package "pkg_fifo_AUXILIAR                                                */  
    /*-----------------------------------------------------------------------------------------------------------*/
    pkg_fifo_auxiliar.sp_buscaDadosOnu( pCodOnu, 
                                        pStatus, 
                                        pMessage, 
                                        pCursor);
  end sp_buscaDadosOnu;                            
  

   
------------------------------------------------------------------------------------------------------------------------
-- procedure utilizada para Validar e em seguida inserir os dados de uma nota fiscal "T_ARM_NOTA"                     --   
------------------------------------------------------------------------------------------------------------------------
procedure sp_inserirDadosNota( pOrigemNota   in char,                                                  --Ação a ser tomada "Inserção / Edição"
                               pSequencia    in tdvadm.t_arm_nota.arm_nota_sequencia%type,             --Sequencia para t_arm_nota
                               pNota         in tdvadm.t_arm_nota.arm_nota_numero%type,                --Numero da Nota Fiscal  
                               pSerie        in tdvadm.t_arm_nota.arm_nota_serie%type,                 --Série para a Nota Fiscal 
                               pDtEmissao    in varchar2,                                              --Data de Emissão da Nota 
                               pDtSaida      in varchar2,                                              --Data de Saida da Nota
                               pTpNota       in tdvadm.t_arm_nota.arm_nota_tipo%type,                  --Tipo da Nota "Fifo=D"
                               pRota         in tdvadm.t_arm_nota.glb_rota_codigo%type,                 
                               pArmazem      in tdvadm.t_arm_nota.arm_armazem_codigo%type,
                               pTpCarga      in tdvadm.t_arm_nota.glb_tpcarga_codigo%type,
                               pCnpjRemet    in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                               pTpEndRemet   in tdvadm.t_arm_nota.glb_tpcliend_codremetente%type,
                               pCnpjDestino  in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type, 
                               pTpEndDestino in tdvadm.t_arm_nota.glb_tpcliend_coddestinatario%type,
                               pCnpjOutros   in varchar2,
                               pSacado       in char,                                                  --Tipo de Sacado / FlagPgto "R=Remetente", "D=Destino", "O=Outros"
                               pLocOrigem    in tdvadm.t_arm_nota.glb_localidade_codigoorigem%type,    --Codigo de Localidade de Origem
                               pLocDestino   in tdvadm.t_glb_localidade.glb_localidade_codigo%type,    --Codigo de Localidade de Destino
                               pAltura       in tdvadm.t_arm_nota.arm_nota_altura%type,                --Altura 
                               pLargura      in tdvadm.t_arm_nota.arm_nota_largura%type,               --Largura
                               pComprimento  in tdvadm.t_arm_nota.arm_nota_comprimento%type,           --Comprimento
                               pFlagEmp      in tdvadm.t_arm_nota.arm_nota_flagemp%type,
                               pQtdeEmp      in tdvadm.t_arm_nota.arm_nota_empqtde%type,
                               pMercadoria   in tdvadm.t_arm_nota.glb_mercadoria_codigo%type,
                               pVlrMercad    in tdvadm.t_arm_nota.arm_nota_valormerc%type,
                               pDescricao    In tdvadm.t_arm_nota.arm_nota_mercadoria%Type,
                               pQtdeVolume   in tdvadm.t_arm_nota.arm_nota_qtdvolume%type,
                               pPesoNota     in tdvadm.t_arm_nota.arm_nota_peso%type,
                               pPesoBalanca  in tdvadm.t_arm_nota.arm_nota_pesobalanca%type,
                               pCubagem      in tdvadm.t_arm_nota.arm_nota_cubagem%type,
                               pChaveNfe     in tdvadm.t_arm_nota.arm_nota_chavenfe%type,
                               pCfop         in tdvadm.t_arm_nota.glb_cfop_codigo%type,
                               pDi           in tdvadm.t_arm_nota.arm_nota_di%type,
                               pContrato     in tdvadm.t_arm_nota.slf_contrato_codigo%type,
                               pTpRequis     in tdvadm.t_arm_nota.arm_nota_tabsol%type,
                               pRequisCod    in tdvadm.t_arm_nota.arm_nota_tabsolcod%type,
                               pSaqueRequis  in tdvadm.t_arm_nota.arm_nota_tabsolsq%type,
                               pCodOnu       in tdvadm.t_arm_nota.arm_nota_onu%type,
                               pGrpEmbOnu    in tdvadm.t_arm_nota.arm_nota_grpemb%type,
                               pColeta       in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                               pTpColeta     in tdvadm.t_arm_nota.arm_coleta_tpcompra%type,
                               pPO           in tdvadm.t_arm_nota.xml_notalinha_numdoc%type,     
                               pNotaVide     in tdvadm.t_arm_nota.arm_nota_vide%type,
                               pUsuario      in tdvadm.t_arm_nota.usu_usuario_codigo%type,             --Usuario que está fazendo a inserção da nota
                               pVideSeq      In Integer,
                               pVideNumNota  In Integer,
                               pVideSerie    In Char,
                               pVideCnpj     In Char,
                               pStatus       out char,
                               pMessage      out Varchar2
                                ) As
     Begin
      
       pkg_fifo_recebimento.sp_inserirDadosNota( pOrigemNota,
                                                 pSequencia,
                                                 pNota,  
                                                 pSerie, 
                                                 pDtEmissao, 
                                                 pDtSaida,
                                                 pTpNota,
                                                 pRota,                 
                                                 pArmazem,
                                                 pTpCarga,
                                                 pCnpjRemet,
                                                 pTpEndRemet,
                                                 pCnpjDestino, 
                                                 pTpEndDestino,
                                                 pCnpjOutros,
                                                 pSacado,
                                                 pLocOrigem,
                                                 pLocDestino,
                                                 pAltura, 
                                                 pLargura,
                                                 pComprimento,
                                                 pFlagEmp,
                                                 pQtdeEmp,
                                                 pMercadoria,
                                                 pVlrMercad,
                                                 pDescricao,
                                                 pQtdeVolume,
                                                 pPesoNota,
                                                 pPesoBalanca,
                                                 pCubagem,
                                                 pChaveNfe,
                                                 pCfop,
                                                 pDi,
                                                 pContrato,
                                                 pTpRequis,
                                                 pRequisCod,
                                                 pSaqueRequis,
                                                 pCodOnu,
                                                 pGrpEmbOnu,
                                                 pColeta,
                                                 pTpColeta,
                                                 pPO,     
                                                 pNotaVide,
                                                 pUsuario,
                                                 pVideSeq,
                                                 pVideNumNota,
                                                 pVideSerie,
                                                 pVideCnpj,
                                                 pStatus,
                                                 pMessage );

     End sp_inserirDadosNota;
     
  /**************************************************************************************************************************************/
  /* Procedure utilizada para buscar a Descrição das Mercadorias. A busca só pode retornar um registro                                  */                           
  /**************************************************************************************************************************************/
  procedure sp_buscadDescMerc( pCodMercadoria  in tdvadm.t_glb_mercadoria.glb_mercadoria_codigo%type,
                               pStatus         out char,
                               pMessage        out varchar2,
                               pCursor         out T_CURSOR) as
  begin
    /*-----------------------------------------------------------------------------------------------------------*/
    /* Procedure utilizada para retornar um cursor com  a descrição de uma mercadoria "T_GLB_MERCADORIA"         */
    /* passando como paramentro o código da MERCADORIA.                                                          */ 
    /* O corpo dessa procedure está no package "pkg_fifo_AUXILIAR                                                */  
    /*-----------------------------------------------------------------------------------------------------------*/
    pkg_fifo_AUXILIAR.sp_buscadDescMerc( pCodMercadoria, pStatus,  pMessage, pCursor );                         
    

  end sp_buscadDescMerc;
  
  /**************************************************************************************************************************/
  /* Procedure responsável por excluir a nota fiscal                                                                        */                            
  /**************************************************************************************************************************/
  procedure sp_excluirNota( pUsuario         in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                            pRota            in tdvadm.t_glb_rota.glb_rota_codigo%type,
                            pNumeroNota      in tdvadm.t_arm_nota.arm_nota_numero%type,
                            pDataEmissao     in varchar2,
                            pCnpjRemetente   in tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type,
                            pCnpjDestino     in tdvadm.t_arm_nota.glb_cliente_cgccpfdestinatario%type,
                            pColeta          in tdvadm.t_arm_nota.arm_coleta_ncompra%type,
                            pEmbalagem       in tdvadm.t_arm_nota.arm_embalagem_numero%type,
                            pStatus          out char,
                            pMessage         out varchar2 ) as
  begin
     /*-----------------------------------------------------------------------------------------------------------*/
    /* Procedure utilizada para excluir um registro na tabela t_arm_nota                                         */
    /* O corpo dessa procedure está no package "pkg_fifo_RECEBIMENTO                                             */  
    /*-----------------------------------------------------------------------------------------------------------*/

pStatus := 'E';
PMESSAGE := 'PROCEDURE DESATIVADA';

/*    pkg_fifo_recebimento.sp_excluirNota( pUsuario,
                                         pRota,
                                         pNumeroNota,
                                         pDataEmissao,
                                         pCnpjRemetente,
                                         pCnpjDestino,
                                         pColeta,
                                         pEmbalagem,
                                         pStatus,
                                         pMessage);
  */
  end sp_excluirNota;                            
                            


----------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada como ancoragem para o FIFO                                                                               --
----------------------------------------------------------------------------------------------------------------------------------
Procedure sp_execute( pXmlIn in Varchar2,
                      pXmlOut out clob
                     ) AS

 --Variável utilizada para armazenar o comando.
 vCommand varchar2(5000);
 
 --Variáveis Auxiliares que serão utilizadas na execução de procedures
 vStatus char(01);
 vMessage varchar2(5000);
 vXmlout clob;
 vProcName Varchar2(500);
 
 --Constantes utilizadas para definir o tipo de procedure que será executada.
 Retorno_Xml Constant char(03) := 'xml';
 Retorno_Status constant char(06) := 'status';
 
 --Variável de lista de paramentros
 vListaParams glbadm.pkg_listas.tListaParamsString;
Begin
  
  Execute immediate ( ' ALTER SESSION set NLS_DATE_FORMAT = "DD/MM/YYYY" ' );
  --Inicilizao as variáveis que serão utilizadas nessa procedure.
  vProcName:= '';
  vCommand := '';
  vStatus := '';
  vMessage := '';
  vXmlout := empty_clob();
  vListaParams.delete();
 
  Begin
    --Recupero os paramentros passados através do Xml de entrada.
    If ( Not glbadm.pkg_listas.FN_Get_ListaParamsValue( pXmlIn, vListaParams, vMessage) ) Then
      --caso ocorra algum erro, devolvo o erro e encerro o processamento
      pXmlOut := glbadm.pkg_xml_common.Fn_Xml_Retorno( tdvadm.pkg_glb_common.Status_Erro, vMessage ); 
    End If;

    --Monto o nome da procedure para facilitar o debug
    vProcName := Trim( vListaParams('aowner').value )       || '.' ||
                 Trim( vListaParams('package_name').value ) || '.' ||
                 Trim( vListaParams('procedure_name').value );
    
    --Verifico se a procedure vai retornar Xml
    if ( trim(vListaParams('procedure_tpRetorno').value) = Retorno_Xml ) then
      --Monto o comando que será utilizado na execução da procedure
      vCommand := ' begin  ' || vProcName ||  '( :pXmlEntrada, :Status, :Message, :pXmlRetorno); end; ';
      
      --Executo o comando propriamente dito, passando os paramentros. 
      execute immediate  vCommand  using in pXmlIn, in out vStatus, in out vMessage, in out vXmlout;
      
      --Caso o Retorno seja Normal
      if ( vStatus = pkg_glb_common.Status_Nomal ) then
        --Transfiro o XML para o paramentro de retorno.
        pXmlOut := vXmlout;
      end if;
      
      --Caso o retorno seja erro, devolve mensagem de erro
      if ( vStatus = pkg_glb_common.Status_Erro ) then
        pXmlOut := glbadm.pkg_xml_common.Fn_Xml_Retorno(vStatus, pkg_glb_common.FN_LIMPA_CAMPO(vMessage));
      end if;
    end if;
    
    --Verifico se a procedure vai retornar apenas o Status.
    if ( trim(vListaParams('procedure_tpRetorno').value) = Retorno_Status ) then
      --Monto o comando que será utilizado na execução da procedure
      vCommand := ' begin  ' || Trim(vProcName) || '( :pXmlEntrada, :Status, :Message); end; ';
      
      --Executo o comando propriamente dito, passando os paramentros. 
      execute immediate  vCommand  using in pXmlIn, in out vStatus, in out vMessage;
      
      --indiferente ao resultado, monto um xml com os paramentros de saida.
      pXmlOut := glbadm.pkg_xml_common.Fn_Xml_Retorno( vStatus, pkg_glb_common.FN_LIMPA_CAMPO( vMessage) );
    end if;
    
  Exception
    --caso ocorra algum erro durante a execução da procedure
    when others then
      --gera o xml de retorno
      pXmlOut := glbadm.pkg_xml_common.Fn_Xml_Retorno(pkg_glb_common.Status_Erro, 'Erro: ' ||sqlerrm );
  End;

END sp_execute;


 Procedure SP_GET_REGRACONTRATO( pParamsEntrada   In Varchar2,
                                 pStatus          Out Char,
                                 pMessage         Out Varchar2,
                                 pParamsSaida     Out Clob)
 As
   vUsuario       tdvadm.t_usu_usuario.usu_usuario_codigo%type;
   vRotaUsuario   tdvadm.t_glb_rota.glb_rota_codigo%type;
   vAplicacao     tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type;
   vVersaoAplicacao tdvadm.t_usu_aplicacao.usu_aplicacao_versao%type;
   vCNPJSacado    tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type;
   vGrupo         tdvadm.t_glb_grupoeconomico.glb_grupoeconomico_codigo%type;
   vContrato      tdvadm.t_slf_contrato.slf_contrato_codigo%type;
   vLocalColetai  tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
   vLocalEntregai tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
   vLocalColeta   tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vLocalEntrega  tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vAuxiliar      number;
   vXmlin         varchar2(20000);
Begin

  if pParamsEntrada is null Then
     vXmlin := '';
     vXmlin := vXmlin || '<Parametros> ';
     vXmlin := vXmlin || '   <Input> ';
     vXmlin := vXmlin || '      <usuario></usuario> ';
     vXmlin := vXmlin || '      <rota></rota> ';
     vXmlin := vXmlin || '      <aplicacao></aplicacao> ';     
     vXmlin := vXmlin || '      <versaoaplicacao></versaoaplicacao> ';     
     vXmlin := vXmlin || '      <cnpjcpfsacado>57599581000147</cnpjcpfsacado> ';     
     vXmlin := vXmlin || '      <grupo></grupo> ';  
     vXmlin := vXmlin || '      <contrato></contrato> ';
     vXmlin := vXmlin || '      <localcoleta></localcoleta> ';  
     vXmlin := vXmlin || '      <localentrega></localentrega> ';
     vXmlin := vXmlin || '   </Input> ';
     vXmlin := vXmlin || '</Parametros> ';
  Else
     vXmlin := pParamsEntrada;  
  End If; 


  pStatus          := pkg_glb_common.Status_Nomal;
  pMessage         := null;

  vUsuario         := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'usuario'));
  vRotaUsuario     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'rota'));
  vAplicacao       := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'aplicacao'));
  vVersaoAplicacao := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'versaoaplicacao'));
  vCNPJSacado      := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'cnpjcpfsacado'));
  vGrupo           := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'grupo'));
  vContrato        := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'contrato'));
  vLocalColeta     := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'localcoleta'));
  vLocalEntrega    := trim(Glbadm.pkg_glb_WsInterfaceDB.Fn_GetParam(vXmlin, 'localentrega'));

  vGrupo := nvl(vGrupo,pkg_fifo_carregctrc.QualquerGrupo);
  vContrato := nvl(vContrato,pkg_fifo_carregctrc.QualquerGrupo);
  vLocalColeta  := nvl(vLocalColeta,'99999');
  vLocalEntrega := nvl(vLocalEntrega,'99999');
  If vLocalColeta <> '99999' Then
     vLocalColetai  := fn_busca_codigoibge(vLocalColeta,'IBC');
  Else
     vLocalColetai  := '9999999';
  End If;   
  If vLocalEntrega <> '99999' Then
     vLocalEntregai  := fn_busca_codigoibge(vLocalEntrega,'IBC');
  Else
     vLocalEntregai  := '9999999';
  End If;   
  
  -- Pesquisa se existe alguma Regra com os Dados passado
  select count(*)
    into vAuxiliar
  from t_slf_clientecargas cc
  where cc.glb_grupoeconomico_codigo = decode(vGrupo,pkg_fifo_carregctrc.QualquerGrupo,cc.glb_grupoeconomico_codigo,vGrupo) 
    and cc.glb_cliente_cgccpfcodigo  = decode(vCNPJSacado,pkg_fifo_carregctrc.QualquerGrupo,cc.glb_cliente_cgccpfcodigo,vCNPJSacado)
    and cc.slf_contrato_codigo       = decode(vContrato,pkg_fifo_carregctrc.QualquerGrupo,cc.slf_contrato_codigo,vContrato); 
  
  -- Comeca a Testar individual;
  if vAuxiliar = 0 Then
     -- Pegar a Regra que é usado no fechamento do Carregamento
     vAuxiliar := 0;
     
     
     if vAuxiliar > 0 Then
        pMessage := nvl(pMessage,'Achei Regra');
     End If;
     -- Verifica se foiu criado alguma Solicitação para ele
     If vAuxiliar = 0 Then
        Select count(*)
          into vAuxiliar
        From t_slf_solfrete sf
        where sf.glb_cliente_cgccpfcodigosac  = vCNPJSacado
          and sf.glb_localidade_codigocoleta  = decode(vLocalColeta,'99999',sf.glb_localidade_codigocoleta,vLocalColeta)
          and sf.glb_localidade_codigoentrega = decode(vLocalEntrega,'99999',sf.glb_localidade_codigoentrega,vLocalEntrega)
          and sf.slf_solfrete_saque = (select max(sf1.slf_solfrete_saque)
                                       from t_slf_solfrete sf1
                                       where sf1.slf_solfrete_codigo = sf.slf_solfrete_codigo
                                         and trunc(sf1.slf_solfrete_vigencia) <= trunc(sysdate)   
                                         and sf.slf_solfrete_dataefetiva = (select min(sf2.slf_solfrete_dataefetiva)
                                                                            from t_slf_solfrete sf2
                                                                            where sf2.slf_solfrete_codigo = sf1.slf_solfrete_codigo
                                                                              and trunc(sf2.slf_solfrete_vigencia) < trunc(sysdate)));
        -- Pesquisa pelo Codigo do IBGE
        If vAuxiliar = 0 Then
           Select count(*)
             into vAuxiliar
           From t_slf_solfrete sf
           where sf.glb_cliente_cgccpfcodigosac  = vCNPJSacado
             and fn_busca_codigoibge(sf.glb_localidade_codigocoleta,'IBC')  = decode(vLocalColetai,'9999999',fn_busca_codigoibge(sf.glb_localidade_codigocoleta,'IBC'),vLocalColetai)
             and fn_busca_codigoibge(sf.glb_localidade_codigoentrega,'IBC') = decode(vLocalEntregai,'9999999',fn_busca_codigoibge(sf.glb_localidade_codigoentrega,'IBC'),vLocalEntregai)
             and sf.slf_solfrete_saque = (select max(sf1.slf_solfrete_saque)
                                          from t_slf_solfrete sf1
                                          where sf1.slf_solfrete_codigo = sf.slf_solfrete_codigo
                                            and trunc(sf1.slf_solfrete_vigencia) <= trunc(sysdate)   
                                            and sf.slf_solfrete_dataefetiva = (select min(sf2.slf_solfrete_dataefetiva)
                                                                               from t_slf_solfrete sf2
                                                                               where sf2.slf_solfrete_codigo = sf1.slf_solfrete_codigo
                                                                                 and trunc(sf2.slf_solfrete_vigencia) < trunc(sysdate)));
        End If; 

     End If;
     
     if vAuxiliar > 0 then
        pMessage := nvl(pMessage,'Achei Regra Por Solicitacao'); 
     End If;
     
     -- Procura se existe uma tabela no modo antigo CIF
     If vAuxiliar = 0 Then
        
        Select count(*)
          into vAuxiliar
        From t_slf_tabela ta
        where ta.glb_cliente_cgccpfcodigo = vCNPJSacado
          and nvl(ta.slf_tabela_status,'N') = 'N' 
          and trunc(ta.slf_tabela_vigencia) <= trunc(sysdate)
          and ta.slf_tabela_tipo = 'CIF'
          and ta.glb_localidade_codigo = decode(vLocalColeta,'99999', ta.glb_localidade_codigo, vLocalColeta) 
          and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                     from t_slf_tabela ta1
                                     where ta1.slf_tabela_codigo = ta.slf_tabela_codigo 
                                       and nvl(ta1.slf_tabela_status,'N') = nvl(ta.slf_tabela_status,'N') 
                                       and trunc(ta1.slf_tabela_vigencia) <= trunc(sysdate)
                                       and ta1.slf_tabela_tipo = ta.slf_tabela_tipo )
          and 0 < (select count(*)
                   from t_slf_tabeladet td
                   where td.slf_tabela_codigo = ta.slf_tabela_codigo
                     and td.slf_tabela_saque = ta.slf_tabela_saque  
                     and td.glb_localidade_codigo = decode(vLocalEntrega,'99999',td.glb_localidade_codigo,vLocalEntrega));                            
                                       
        If vAuxiliar =  0 then
            Select count(*)
              into vAuxiliar
            From t_slf_tabela ta
            where ta.glb_cliente_cgccpfcodigo = vCNPJSacado
              and nvl(ta.slf_tabela_status,'N') = 'N' 
              and trunc(ta.slf_tabela_vigencia) <= trunc(sysdate)
              and ta.slf_tabela_tipo = 'CIF'
              and fn_busca_codigoibge(ta.glb_localidade_codigo,'IBC') = decode(vLocalColetai,'9999999',fn_busca_codigoibge(ta.glb_localidade_codigo,'IBC'),vLocalColetai)
              and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                         from t_slf_tabela ta1
                                         where ta1.slf_tabela_codigo = ta.slf_tabela_codigo 
                                           and nvl(ta1.slf_tabela_status,'N') = nvl(ta.slf_tabela_status,'N') 
                                           and trunc(ta1.slf_tabela_vigencia) <= trunc(sysdate)
                                           and ta1.slf_tabela_tipo = ta.slf_tabela_tipo )
              and 0 < (select count(*)
                       from t_slf_tabeladet td
                       where td.slf_tabela_codigo = ta.slf_tabela_codigo
                         and td.slf_tabela_saque = ta.slf_tabela_saque  
                         and fn_busca_codigoibge(td.glb_localidade_codigo,'IBC') = decode(vLocalEntregai,'9999999',fn_busca_codigoibge(td.glb_localidade_codigo,'IBC'),vLocalEntregai));                            
        End If;
     
     End If;    

     if vAuxiliar > 0 then
        pMessage := nvl(pMessage,'Achei Regra Por TABELA CIF'); 
     End If;

     -- Procura se existe uma tabela no modo antigo FOB
     If vAuxiliar = 0 Then
        
        Select count(*)
          into vAuxiliar
        From t_slf_tabela ta
        where ta.glb_cliente_cgccpfcodigo = vCNPJSacado
          and nvl(ta.slf_tabela_status,'N') = 'N' 
          and trunc(ta.slf_tabela_vigencia) <= trunc(sysdate)
          and ta.slf_tabela_tipo = 'FOB'
          and ta.glb_localidade_codigo = decode(vLocalEntrega,'99999', ta.glb_localidade_codigo, vLocalEntrega) 
          and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                     from t_slf_tabela ta1
                                     where ta1.slf_tabela_codigo = ta.slf_tabela_codigo 
                                       and nvl(ta1.slf_tabela_status,'N') = nvl(ta.slf_tabela_status,'N') 
                                       and trunc(ta1.slf_tabela_vigencia) <= trunc(sysdate)
                                       and ta1.slf_tabela_tipo = ta.slf_tabela_tipo )
          and 0 < (select count(*)
                   from t_slf_tabeladet td
                   where td.slf_tabela_codigo = ta.slf_tabela_codigo
                     and td.slf_tabela_saque = ta.slf_tabela_saque  
                     and td.glb_localidade_codigo = decode(vLocalColeta,'99999',td.glb_localidade_codigo,vLocalColeta));                            
                                       
        If vAuxiliar =  0 then
            Select count(*)
              into vAuxiliar
            From t_slf_tabela ta
            where ta.glb_cliente_cgccpfcodigo = vCNPJSacado
              and nvl(ta.slf_tabela_status,'N') = 'N' 
              and trunc(ta.slf_tabela_vigencia) > trunc(sysdate)
              and ta.slf_tabela_tipo = 'FOB'
              and fn_busca_codigoibge(ta.glb_localidade_codigo,'IBC') = decode(vLocalEntregai,'9999999',fn_busca_codigoibge(ta.glb_localidade_codigo,'IBC'),vLocalEntregai)
              and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                         from t_slf_tabela ta1
                                         where ta1.slf_tabela_codigo = ta.slf_tabela_codigo 
                                           and nvl(ta1.slf_tabela_status,'N') = nvl(ta.slf_tabela_status,'N') 
                                           and trunc(ta1.slf_tabela_vigencia) > trunc(sysdate)
                                           and ta1.slf_tabela_tipo = ta.slf_tabela_tipo )
              and 0 < (select count(*)
                       from t_slf_tabeladet td
                       where td.slf_tabela_codigo = ta.slf_tabela_codigo
                         and td.slf_tabela_saque = ta.slf_tabela_saque  
                         and fn_busca_codigoibge(td.glb_localidade_codigo,'IBC') = decode(vLocalColetai,'9999999',fn_busca_codigoibge(td.glb_localidade_codigo,'IBC'),vLocalColetai));                            
        End If;
     
     End If;    

     if vAuxiliar > 0 then
        pMessage := nvl(pMessage,'Achei Regra Por TABELA FOB'); 
     End If;

  End If;

  If vAuxiliar > 0 then
     pStatus       := pkg_glb_common.Status_Nomal;
  Else
     pStatus       := pkg_glb_common.Status_Erro;
     pMessage      := 'Não Achei Regra'; 
  End If;

End SP_GET_REGRACONTRATO;

Function fn_Get_TemREGRACONTRATO(pCNpj    in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                 pColeta  in tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                 pEntrega in tdvadm.t_glb_localidade.glb_localidade_codigo%type)
    Return char
  As
   vXmlin varchar2(2000);
   vStatus char(1);
   vMessage varchar2(1000);
   vXmlOut varchar2(2000);
 Begin

     vXmlin := '';
     vXmlin := vXmlin || '<Parametros> ';
     vXmlin := vXmlin || '   <Input> ';
     vXmlin := vXmlin || '      <usuario></usuario> ';
     vXmlin := vXmlin || '      <rota></rota> ';
     vXmlin := vXmlin || '      <aplicacao></aplicacao> ';     
     vXmlin := vXmlin || '      <versaoaplicacao></versaoaplicacao> ';     
     vXmlin := vXmlin || '      <cnpjcpfsacado>' || pCNpj  || '</cnpjcpfsacado> ';     
     vXmlin := vXmlin || '      <grupo></grupo> ';  
     vXmlin := vXmlin || '      <contrato></contrato> ';
     vXmlin := vXmlin || '      <localcoleta>' || pColeta  || '</localcoleta> ';  
     vXmlin := vXmlin || '      <localentrega>' || pEntrega  || '</localentrega> ';
     vXmlin := vXmlin || '   </Input> ';
     vXmlin := vXmlin || '</Parametros> ';
       
     SP_GET_REGRACONTRATO(vXmlin,vStatus,vMessage,vXmlOut);
     
     if nvl(vStatus,'E') = 'N' Then 
        return 'S';
     Else  
        return 'N';
     End If;
 
   
 End fn_Get_TemREGRACONTRATO;
                                   
PROCEDURE SP_GET_ASN_NUM_COLETA(pNumColeta   IN t_xml_coleta.xml_coleta_numero%type,
                                pCursor      out pkg_fifo.T_CURSOR,
                                pStatus      OUT CHAR,
                                PMessage     OUT VARCHAR2)AS
  begin
    
    Open pCursor For  
    select x.arm_coleta_ncompra
      from t_Xml_Coleta x
     where x.xml_coleta_numero = pNumColeta
    
    union
    
    select l.arm_coleta_ncompra
      from tdvadm.t_col_asn l
      where l.col_asn_numero = pNumColeta
        and l.col_asn_id     = (select max(kk.col_asn_id)
                                  from tdvadm.t_col_asn kk
                                 where kk.col_asn_id = l.col_asn_id
                                   and kk.col_asnstatus_id = '3');
      
      pStatus  := pkg_fifo.Status_Normal;
      pMessage := '';         
      
   exception
     when others then
       pStatus := pkg_fifo.Status_Erro;
       pMessage := dbms_utility.format_error_backtrace;
    end;
    

    
FUNCTION FN_GET_NOTALIBERADA(pArmEmbalagemNumero IN tdvadm.t_arm_embalagem.arm_embalagem_numero%Type,
                              pArmEmbalagemSeq IN tdvadm.t_arm_embalagem.arm_embalagem_sequencia%Type) RETURN CHAR AS
vJanelaConsSequencia Number;
vDataFim Date;
begin

select x.arm_janelacons_sequencia into vJanelaConsSequencia from t_arm_nota x
where x.arm_embalagem_numero = pArmEmbalagemNumero
and x.arm_embalagem_sequencia = pArmEmbalagemSeq;
  
select x.arm_janelacons_dtfim  into vDataFim
from t_arm_janelacons x
where x.arm_janelacons_sequencia = vJanelaConsSequencia;
    
if( Sysdate > vDataFim ) Then
    return 'S';
else
    return 'N';    
End if;

end FN_GET_NOTALIBERADA;


 Procedure SP_GET_TPCARGA( pCursor out tdvadm.pkg_fifo.T_CURSOR,
                           pStatus out char,
                           pMessage out varchar2) AS
 Begin
    pStatus := tdvadm.pkg_fifo.Status_Normal;
    pMessage := '';
    open pCursor for select ca.arm_tpcarga_codigo,
                            ca.arm_tpcarga_descricao,
                            ca.arm_tpcarga_default
                     from t_arm_tpcarga ca
                     order by ca.arm_tpcarga_ordem;
     pStatus := pkg_fifo.Status_Normal;
     pMessage := '';
 exception
    when others then
       pStatus := tdvadm.pkg_fifo.Status_Erro;
       pMessage := 'Erro ao gerar cursor com dados de T_Arm_TPCarga. '||chr(13)|| sqlerrm;
 End;




    
end pkg_fifo;
/
