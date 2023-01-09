create or replace package migdv.pkg_migracao_sap is


vDATA_CORTE    DATE         := to_date('01/01/2019','dd/mm/yyyy');  
vDATA_GOLIVE   DATE         := to_date('31/05/2020','dd/mm/yyyy'); 
vTIPO_ENDERECO CHAR(1)      := 'E';                                  
vVALOR_VENCIDO VARCHAR2(50) := '0'; 
vCOD_COMPANHIA CHAR(4)      := '1000';   
vREFER_CTB     char(6)      := '202005';
vCodigoEmpresa char(1)      := '1';
vMoeda         char(3)      := 'BRL';  
vPais          char(2)      := 'BR';
pQtdeCommit    integer      := 1000;

Type TpCliRed  is RECORD (ChaveSap     nvarchar2(80),
                          CPFCNPJ      migdv.v_pessoassap.GLB_CLIENTE_CGCCPFCODIGO%type,
                          Tipo         char(3),      
                          ie           migdv.v_pessoassap.IE%type,
                          im           migdv.v_pessoassap.im%type,
                          RG           migdv.v_pessoassap.RG%type,
                          INSS         migdv.v_pessoassap.INSS%type,
                          MATRICULA    migdv.v_pessoassap.MATRICULA%type,
                          Tipo2        migdv.v_pessoassap.TIPO2%type,        
                          cbo          migdv.v_pessoassap.cbo%type,
                          dtnascimento migdv.v_pessoassap.dtnascimento%type);

-- RESPONSÁVEL POR CHAMAR TODAS AS PROCEDURES DE IMPORTAÇÃO 
-- E DEFINIR AS CONSTANTES DO PAKAGE                                       

Function get_data_golive return date;

FUNCTION FC_REPETICAO_VERIFICAR (p_dsc_string  varchar)
RETURN number;

function IS_NUMBER(pValor in varchar2)
    return number;

Function fn_coloca_owner(pQuery varchar2,pOwner varchar2)
     return varchar2;
     
Function fn_busca_codigoSAP(pClienteTDV in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                            pTipoendereco in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                            pTipo       in varchar2) return varchar2;


procedure SP_SAP_PRINCIPAL(PDATA_CORTE IN VARCHAR2,
                           PRESULTADO OUT Char,
                           PMENSAGEM OUT VARCHAR2);
    
procedure SP_SAP_INSERE_ZONATRANSPORTE;
                     
procedure SP_SAP_INSERE_LINHATRANSPORTE;

procedure SP_SAP_INSERE_LINHA_MEIO_TRANSPORTE;
           
-- Insere Bancos na tabela BANK_MASTER_S_BNKA 
procedure SP_SAP_INSEREBANCO(PBANCO IN CHAR,
                             PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2);


procedure SP_SAP_BANCO_TODOS(PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2);




-- Insere Banco da tabela CUSTOMER_S_CUST_BANK_DATA 
procedure SP_SAP_INSERE_BANK_DATA(PIDCLIENTE IN VARCHAR2,
                                  PCPFCNPJ IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                  PRESULTADO OUT Char,
                                  PMENSAGEM OUT VARCHAR2);

    
procedure SP_CUSTOMER_S_CUST_SALES_DATA;

procedure SP_CUSTOMER_S_CUST_SALES_PARTNER;

       
procedure SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO(PIDFORNECEDOR IN CHAR,
                                                  PTIPO         IN CHAR,
                                                  PTIPOPFPJ     IN CHAR,
                                                  PRESULTADO OUT Char,
                                                  PMENSAGEM OUT VARCHAR2);
                               

procedure SP_SAP_INSERECLIENTE(PDATA_CORTE IN VARCHAR2,
                               PTIPO_ENDERECO IN CHAR,
                               PRESULTADO OUT Char,
                               PMENSAGEM OUT VARCHAR2);
                                        
                                 
procedure SP_SAP_INSEREDADOSFINANCEIROS(PIDCLIENTE IN VARCHAR2,
                                        PDOCUMENTO IN CHAR,
                                        PRESULTADO OUT Char,
                                        PMENSAGEM OUT VARCHAR2);                                  
                                        
procedure SP_SAP_INSERE_ROLES(PTpClient IN TpCliRed,
                              PTIPO_ROLE IN CHAR,
                              PRESULTADO OUT Char,
                              PMENSAGEM OUT VARCHAR2);

procedure SP_SAP_INSERE_TAXNUMBERS(PTpClient in TpCliRed,
                                   PTIPO      in CHAR DEFAULT 'TODOS',
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2);

                              
procedure SP_SAP_INSERECONTATO(PCliRed IN TpCliRed,
                               PRESULTADO OUT Char,
                               PMENSAGEM OUT VARCHAR2);
                                                
procedure SP_SAP_INSEREDOCUMENTO(PCliRed IN TpCliRed,
                                 PRESULTADO OUT Char,
                                 PMENSAGEM OUT VARCHAR2);

procedure SP_SAP_INSERE_CLIENTE_ENDERECO_ADICIONAL(PIDCLIENTE IN CHAR,
                                                   tpEndAdicional IN MIGDV.CUSTOMER_S_ADDRESS%ROWTYPE,
                                                   PRESULTADO OUT Char,
                                                   PMENSAGEM OUT VARCHAR2);

-- Insere Dados bancários do Fornecedor                                           
procedure SP_SAP_INSERE_FORNECEDOR_SUPP_BANK(PIDFORNECEDOR IN CHAR,
                                             PRESULTADO OUT Char,
                                             PMENSAGEM OUT VARCHAR2);
                                   

-- Insere Endereços adicionais do Fornecedor                                           
procedure SP_SAP_INSERE_FORNECEDOR_ENDERECO_ADICIONAL(PIDFORNECEDOR IN CHAR,
                                                      PRESULTADO OUT Char,
                                                      PMENSAGEM OUT VARCHAR2);
                                   
-- Insere Ativo Fixo da empresa
procedure SP_SAP_INSERE_ATIVOS_FIXO(PIDATIVO IN CHAR,
                                    PRESULTADO OUT Char,
                                    PMENSAGEM OUT VARCHAR2);


-- Insere valoração do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_VALORACAO(PIDATIVO IN CHAR,
                                        PRESULTADO OUT Char,
                                        PMENSAGEM OUT VARCHAR2);

                                         
-- Insere data de entrada e exercício do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_DATAENTRADA(PIDATIVO IN CHAR,
                                          PRESULTADO OUT Char,
                                          PMENSAGEM OUT VARCHAR2);

-- Insere Equipamento
procedure SP_SAP_INSERE_EQUIPAMENTO(PRESULTADO OUT Char,
                                    PMENSAGEM OUT VARCHAR2);

-- Insere Local de Instalação
procedure SP_SAP_INSERE_LOCAL_INSTALACAO(tpLOCAL MIGDV.FUNC_LOC_S_FUN_LOCATION%ROWTYPE,
                                         PRESULTADO OUT Char,
                                         PMENSAGEM OUT VARCHAR2);

-- Insere PNEU
procedure SP_SAP_INSERE_PNEU(PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2);

-- Insere RASTREADOR
procedure SP_SAP_INSERE_RASTREADOR(PIDMATERIAL IN CHAR,
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2);                                   
                                   
-- Insere SEM PARAR
procedure SP_SAP_INSERE_SEM_PARAR(PIDMATERIAL IN CHAR,
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2);

-- Insere MIX
procedure SP_SAP_INSERE_MIX(PIDMATERIAL IN CHAR,
                            PRESULTADO OUT Char,
                            PMENSAGEM OUT VARCHAR2);                                   

-- Insere Material
procedure SP_SAP_INSERE_MATERIAL(PIDMATERIAL IN CHAR,
                                 PRESULTADO OUT Char,
                                 PMENSAGEM OUT VARCHAR2);

                                          
-- Insere Unidade de medida do Material
procedure SP_SAP_INSERE_MATERIAL_UNIDADE_MEDIDA(P_TPMATERIAL_S_MARM IN MIGDV.MATERIAL_S_MARM%ROWTYPE,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);

-- Insere Dados de localização do Material
procedure SP_SAP_INSERE_MATERIAL_DADOS_LOCALIZACAO(P_TPMATERIAL_S_MARD IN MIGDV.MATERIAL_S_MARD%ROWTYPE,
                                                   PRESULTADO OUT Char,
                                                   PMENSAGEM OUT VARCHAR2);


-- Insere Classificação fiscal do Material
procedure SP_SAP_INSERE_MATERIAL_CLASSIFICACAO_FISCAL(P_TPMATERIAL_S_MLAN IN MIGDV.MATERIAL_S_MLAN%ROWTYPE,
                                                      PRESULTADO OUT Char,
                                                      PMENSAGEM OUT VARCHAR2);


-- Insere Lista de descrições do Material
procedure SP_SAP_INSERE_MATERIAL_LISTA_DESCRICAO(P_TPMATERIAL_S_MAKT IN MIGDV.MATERIAL_S_MAKT%ROWTYPE,
                                                 PRESULTADO OUT Char,
                                                 PMENSAGEM OUT VARCHAR2);


-- Insere Documentos Contas Pagar
procedure SP_SAP_INSERE_CONTAS_PAGAR_DOCUMENTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);



-- Insere Documentos Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);


procedure SP_SAP_INSERE_GL_BALANCES_RAZAO(PRESULTADO OUT Char,
                                          PMENSAGEM OUT VARCHAR2);

procedure SP_SAP_INSERE_RECURSO(PRESULTADO OUT Char,
                                PMENSAGEM OUT VARCHAR2);

procedure sp_RodaIntegracao(pDATA_CORTE       in char, 
                            pTIPO_ENDERECO    in char,
                            pIDMATERIAL       in char, 
                            pRodaBanco        in char default 'NN',  
                            pRazao            in char default 'NN',              
                            pRodaCli          in char default 'NN',
                            pRodaCliVendor    in char default 'NN',         
                            pRodaCliVend      in char default 'NN', 
                            pRodaCliSD        in char default 'NN',
                            pRodaCliPART      in char default 'NN',
                            pRodaEqp          in char default 'NN',
                            pRodaMat          in char default 'NN',
                            pRodaZLMTransp    in char default 'NN',                 
                            pRodaContaReceber in char default 'NN',
                            pRodaContaPagar   in char default 'NN');

Procedure sp_MigrandoTDVxSAP(pQtdecommit     in integer default 100,
                             pGrupoEconomico in char default 'N',
                             pAtivo          in char default 'N',
                             pRazao          in char default 'N', 
                             pBanco          in char default 'N',
                             pCliente        in char default 'N',
                             pClienteReduz   in char default 'N',
                             pSales          in char default 'N',
                             pPARTNER        in char default 'N',
                             pVendor         in char default 'N',
                             pVend           in char default 'N',
                             pEquipamento    in char default 'N',
                             pMaterial       in char default 'N',
                             pMeioTransp     in char default 'N',
                             pContaPagar     in char default 'N',
                             pContaReceber   in char default 'N',
                             pRecurso        in char default 'N');


Procedure Sp_AtualizaControle;

end pkg_migracao_sap;
/
CREATE OR REPLACE PACKAGE BODY MIGDV.pkg_migracao_sap IS
  vErro varchar2(1000);
  vIdCustomer    number       := 0;
  vIdVendor      number       := 0;
  vIdVend        number       := 0;

  tpCUSTOMER_S_CUST_GEN MIGDV.CUSTOMER_S_CUST_GEN%ROWTYPE;   
  tpEndAdicional MIGDV.CUSTOMER_S_ADDRESS%ROWTYPE;    
  tpVEND_EXT_S_SUPPL_GEN MIGDV.VEND_EXT_S_SUPPL_GEN%ROWTYPE; 
  tpVENDOR_S_SUPPL_GEN MIGDV.VENDOR_S_SUPPL_GEN%ROWTYPE; 


/*
  --- Atualizando o SAP
declare country
  i integer;
  tpDado migdv.customer_s_cust_gen%rowtype;
  type tpCurosr is REF CURSOR;
  vCursor1 tpCurosr;
begin
   i := 0;
   
   delete migdv.customer_s_cust_gen;
   commit;
   open vCursor1 FOR select * from migdv2.customer_s_cust_gen;
   loop
     fetch vCursor1 into tpDado;
        exit when vCursor1%notfound;
     insert into migdv.customer_s_cust_gen@database_tdx values tpDado;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then
        commit;
     End If;
   end loop;
   close vCursor1;
   commit;
End ;
*/



/*

update MIGDV.V_CONTROLE v
  set v.qtde = (select t.NUM_ROWS
                from migdv.v_controle_v t
                where t.tabela = v.tabela);
commit;
select *
from migdv.v_controle v
where v.qtde <> 0;

*/

/*

update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(replace(ce.glb_cliend_endereco,'RODOVIA','ROD'),'RODOVIAa','ROD')
where ( instr(ce.glb_cliend_endereco, 'ROD') > 0  or  instr(ce.glb_cliend_endereco, 'BR') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,' ROD','ROD')
where ( instr(ce.glb_cliend_endereco, 'ROD') > 0  or  instr(ce.glb_cliend_endereco, 'BR') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 116','BR-116')
where ( instr(ce.glb_cliend_endereco, 'ROD') > 0  or  instr(ce.glb_cliend_endereco, 'BR') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 101','BR-101')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 110','BR-110')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 135','BR-135')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 153','BR-153')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 163','BR-163')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 174','BR-174')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 242','BR-242')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 262','BR-262')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 230','BR-230')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 265','BR-265')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 316','BR-316')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 324','BR-324')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 381','BR-381')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 470','BR-470')
where instr(ce.glb_cliend_endereco, 'BR ') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR101','BR-101')
where instr(ce.glb_cliend_endereco, 'BR101') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR153','BR-153')
where instr(ce.glb_cliend_endereco, 'BR153') > 0 ;
commit;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR230','BR-230')
where instr(ce.glb_cliend_endereco, 'BR230') > 0 ;
update tdvadm.t_glb_cliend ce
  set ce.glb_cliend_endereco = replace(ce.glb_cliend_endereco,'BR 470','BR-470')
where instr(ce.glb_cliend_endereco, 'BR 470') > 0 ;
commit;

update tdvadm.t_glb_cliCONT ce
  set ce.GLB_CLICONT_CONTATO = replace(replace(replace(replace(replace(replace(replace(ce.GLB_CLICONT_CONTATO,'SR.',''),'SRA.',''),'SRTA.',''),'SRTA .',''),'SR,',''),'SRA,',''),'SRS.','');
  

update tdvadm.t_glb_cliCONT ce
  set ce.GLB_CLICONT_CONTATO = TRIM(replace(replace(replace(ce.GLB_CLICONT_CONTATO,'SRA',''),'SRTA',''),'SR',''));
*/


--update tdvadm.t_glb_cliente cl
--  set cl.glb_cliente_dtultmovsac = nvl((select max(c.con_conhecimento_dtembarque) from tdvadm.t_con_conhecimento c where c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo),cl.glb_cliente_dtcadastro),
--      cl.glb_cliente_dtultmovrem = nvl((select max(c.con_conhecimento_dtembarque) from tdvadm.t_con_conhecimento c where c.glb_cliente_cgccpfremetente = cl.glb_cliente_cgccpfcodigo),cl.glb_cliente_dtcadastro),
--      cl.glb_cliente_dtultmovdest =  nvl((select max(c.con_conhecimento_dtembarque) from tdvadm.t_con_conhecimento c where c.glb_cliente_cgccpfdestinatario = cl.glb_cliente_cgccpfcodigo),cl.glb_cliente_dtcadastro);
--commit;      

-- ARRUMAR A GLB_PAIS_SIGLASAP NA TABELA DE PAISES
-- update tdvadm.t_glb_cliente cli
--  set cli.glb_cliente_dtutlmov = greatest(NVL(CLI.glb_cliente_dtultmovsac, SYSDATE-pQtdecommit), 
--                                          NVL(CLI.glb_cliente_dtultmovrem, SYSDATE-pQtdecommit),
--                                          NVL(CLI.glb_cliente_dtultmovdest, SYSDATE-pQtdecommit));
-- COMMIT;
-- C.GLB_CLIEND_COMPLEMENTO acima de 40 posicoes na tabela de cliente
                                          
/*
-- fAZER PARA PIS
update tdvadm.t_glb_cliente cl
  set cl.glb_cliente_ie = null
where trim(cl.glb_cliente_ie) = '0' 
   or trim(cl.glb_cliente_ie) = '00' 
   or trim(cl.glb_cliente_ie) = '000' 
   or trim(cl.glb_cliente_ie) = '0000' 
   or trim(cl.glb_cliente_ie) = '00000' 
   or trim(cl.glb_cliente_ie) = '000000'
   or trim(cl.glb_cliente_ie) = '0000000'
   or trim(cl.glb_cliente_ie) = '00000000'
   or trim(cl.glb_cliente_ie) = '000000000'
   or trim(cl.glb_cliente_ie) = '0000000000'
   or trim(cl.glb_cliente_ie) = '00000000000'
   or trim(cl.glb_cliente_ie) = '000000000000'
   or trim(cl.glb_cliente_ie) = '0000000000000'
   or trim(cl.glb_cliente_ie) = '00000000000000'
   or trim(cl.glb_cliente_ie) = '000000000000000'
   or trim(cl.glb_cliente_ie) = '0000000000000000'
   or trim(cl.glb_cliente_ie) = '00000000000000000'
   or trim(cl.glb_cliente_ie) = '000000000000000000'
   or trim(cl.glb_cliente_ie) = '0000000000000000000'
   or trim(cl.glb_cliente_ie) = '00000000000000000000';
    
update tdvadm.t_glb_cliente cl
  set cl.glb_cliente_im = null
where trim(cl.glb_cliente_im) = '0' 
   or trim(cl.glb_cliente_im) = '00' 
   or trim(cl.glb_cliente_im) = '000' 
   or trim(cl.glb_cliente_im) = '0000' 
   or trim(cl.glb_cliente_im) = '00000' 
   or trim(cl.glb_cliente_im) = '000000'
   or trim(cl.glb_cliente_im) = '0000000'
   or trim(cl.glb_cliente_im) = '00000000'
   or trim(cl.glb_cliente_im) = '000000000'
   or trim(cl.glb_cliente_im) = '0000000000'
   or trim(cl.glb_cliente_im) = '00000000000'
   or trim(cl.glb_cliente_im) = '000000000000'
   or trim(cl.glb_cliente_im) = '0000000000000'
   or trim(cl.glb_cliente_im) = '00000000000000'
   or trim(cl.glb_cliente_im) = '000000000000000'
   or trim(cl.glb_cliente_im) = '0000000000000000'
   or trim(cl.glb_cliente_im) = '00000000000000000'
   or trim(cl.glb_cliente_im) = '000000000000000000'
   or trim(cl.glb_cliente_im) = '0000000000000000000'
   or trim(cl.glb_cliente_im) = '00000000000000000000';
   
*/



tpEQUIPMENT_S_EQUI MIGDV.EQUIPMENT_S_EQUI%ROWTYPE;                                        
tpEQUIPMENT_S_EQUI2 MIGDV.EQUIPMENT_S_EQUI%ROWTYPE;     

Function get_data_golive return date as
Begin
    return migdv.pkg_migracao_sap.vDATA_GOLIVE;
End get_data_golive;   
  

FUNCTION FC_REPETICAO_VERIFICAR (p_dsc_string  varchar)
RETURN number AS 

    v_num_tamanho   integer;
    v_num_ini_teste number(3) := 2;
    v_ind_status    number(1) := 2;
    v_dsc_posicao   char(1);

BEGIN

    v_num_tamanho := length(p_dsc_string);
    v_dsc_posicao := substr(p_dsc_string, 1, 1);

    for i in 1..v_num_tamanho 
    loop
        if  substr(p_dsc_string, v_num_ini_teste, 1) <> v_dsc_posicao then
            v_ind_status := 1;
        end if;
        v_num_ini_teste := v_num_ini_teste + 1;        
    end loop;

    RETURN v_ind_status;
END FC_REPETICAO_VERIFICAR;


function IS_NUMBER(pValor in varchar2)
    return number
As
Begin
   If glbadm.pkg_glb_util.f_enumerico(pValor) = 'S' Then
      return 1;
   Else
     return 2;
   End If;  
End IS_NUMBER;

Function fn_coloca_owner(pQuery varchar2,pOwner varchar2)
     return varchar2
As
  vQuery Varchar2(2000);
Begin
  vQuery := pQuery;
  for c_msg in (select upper(c.tabela)          tabela from migdv.v_controle c union
                select 'IS_NUMBER'              tabela from dual union
                select 'META_DOMINIO_COLUNA'    tabela from dual union
                select 'FC_REPETICAO_VERIFICAR' tabela from dual 
                )


  Loop
     If c_msg.tabela in ('IS_NUMBER','FC_REPETICAO_VERIFICAR') Then
        vQuery := replace(upper(vQuery),' ' || c_msg.tabela,' ' || 'migdv.pkg_migracao_sap.' || c_msg.tabela);  
        vQuery := replace(upper(vQuery),'(' || c_msg.tabela,'(' || 'migdv.pkg_migracao_sap.' || c_msg.tabela);  
     Else
        vQuery := replace(upper(vQuery),' ' || c_msg.tabela,' ' || pOwner || '.' || c_msg.tabela);  
     End If;
  End Loop;
  
  Return vQuery;    
   
   
End fn_coloca_owner;

Function fn_busca_codigoSAP(pClienteTDV in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                            pTipoendereco in tdvadm.t_glb_cliend.glb_tpcliend_codigo%type,
                            pTipo       in varchar2) return varchar2
 As
  vRetorno migdv.customer_s_cust_gen.kunnr%type;
Begin
  
  vRetorno := null; 
  Begin
      If pTipo IN ('CLI','PRO') Then
          select min(kunnr)
            into vRetorno
          from migdv.customer_s_cust_gen g  
          where trim(g.SORTL) = trim(pClienteTDV)
            and substr(g.namorg4,1,1) = pTipoendereco ;
          If pTipoendereco = 'C' and vRetorno is null Then
             select min(kunnr)
                into vRetorno
             from migdv.customer_s_cust_gen g  
             where trim(g.SORTL) = trim(pClienteTDV);              
          End If;    
      Else
          select min(lifnr) 
            into vRetorno
          from migdv.vendor_s_suppl_gen g  
          where trim(g.SORTL) = trim(pClienteTDV)
            and substr(g.name4,1,1) = pTipoendereco;
          If vRetorno is null Then
             select min(lifnr) 
               into vRetorno
             from migdv.vendor_s_suppl_gen g  
             where trim(g.SORTL) = trim(pClienteTDV);
          End If;
      End If;
  exception
    When OTHERS Then
      vRetorno := null;
    End ;
  Return vRetorno;

End fn_busca_codigoSAP;


-- RESPONSÁVEL POR CHAMAR TODAS AS PROCEDURES DE IMPORTAÇÃO 
-- E DEFINIR AS CONSTANTES DO PAKAGE
procedure SP_SAP_PRINCIPAL(PDATA_CORTE IN VARCHAR2,
                           PRESULTADO OUT Char,
                           PMENSAGEM OUT VARCHAR2) is
begin
    /* CENTRALIZAÇÃO DAS CONSTANTES DO PACOTE */
    vDATA_CORTE    := '01/01/2019';
    vTIPO_ENDERECO := 'E';
    vVALOR_VENCIDO := '0';
    vCOD_COMPANHIA := 'pQtdecommit';

end SP_SAP_PRINCIPAL;


procedure SP_SAP_INSERE_ZONATRANSPORTE
  IS
   i integer;
   tpZonaTransporte migdv.zona_transporte%rowtype;
Begin
  
   For c_msg in (select distinct *
                 from (SELECT TRIM(L.GLB_LOCALIDADE_CODIGO) cod_zonatransporte,
                              l.glb_localidade_cepdef,
                              SUBSTR(TRIM(L.GLB_ESTADO_CODIGO) || '-' || TRIM(L.GLB_LOCALIDADE_DESCRICAO),1,20) nom_zonatransporte,
                              vPais cod_pais,
                              TRIM((SELECT MIN(fc.glb_cepfaixa_inic) FROM TDVADM.t_Glb_Cepfaixa2 fc where fc.glb_localidade_codigo = l.glb_localidade_codigo )) num_ini_faixa_cep,
                              TRIM((SELECT MIN(fc.glb_cepfaixa_inic) FROM TDVADM.t_Glb_Cepfaixa2 fc where fc.glb_localidade_codigo = l.glb_localidade_codigo )) num_fim_faixa_cep,
                              TRIM((SELECT MIN(fc.glb_cepfaixa_inic) FROM TDVADM.t_Glb_Cepfaixa fc where l.glb_localidade_cepdef between fc.glb_cepfaixa_inic and fc.glb_cepfaixa_fim )) num_ini_faixa_cep2,
                              TRIM((SELECT MIN(fc.glb_cepfaixa_inic) FROM TDVADM.t_Glb_Cepfaixa fc where l.glb_localidade_cepdef between fc.glb_cepfaixa_inic and fc.glb_cepfaixa_fim )) num_fim_faixa_cep2
                 FROM TDVADM.T_GLB_LOCALIDADE L
                 WHERE l.glb_localidade_codigo in (select f.fcf_fretecar_origem from tdvadm.t_fcf_fretecar f union
                                                   select f.fcf_fretecar_destino from tdvadm.t_fcf_fretecar f )))
   Loop
     tpZonaTransporte.COD_ZONATRANSPORTE := c_msg.cod_zonatransporte;
     tpZonaTransporte.NOM_ZONATRANSPORTE := substr(c_msg.nom_zonatransporte,1,20);
     tpZonaTransporte.COD_PAIS           := c_msg.cod_pais;
     If c_msg.num_ini_faixa_cep is not null Then
        tpZonaTransporte.NUM_INI_FAIXA_CEP  := c_msg.num_ini_faixa_cep;
     Elsif c_msg.num_ini_faixa_cep2 is not null Then
        tpZonaTransporte.NUM_INI_FAIXA_CEP  := c_msg.num_ini_faixa_cep2;
     Else
        tpZonaTransporte.NUM_INI_FAIXA_CEP  := c_msg.glb_localidade_cepdef;
     End If;

     If c_msg.num_ini_faixa_cep is not null Then
        tpZonaTransporte.NUM_FIM_FAIXA_CEP  := c_msg.num_fim_faixa_cep;
     Elsif c_msg.num_ini_faixa_cep2 is not null Then
        tpZonaTransporte.NUM_FIM_FAIXA_CEP  := c_msg.num_fim_faixa_cep2;
     Else
        tpZonaTransporte.NUM_FIM_FAIXA_CEP  := c_msg.glb_localidade_cepdef;
     End If;
 
     If tpZonaTransporte.NUM_INI_FAIXA_CEP is not null and
        tpZonaTransporte.NUM_FIM_FAIXA_CEP is not null Then
        insert into migdv.zona_transporte values tpZonaTransporte; 
     Else
        dbms_output.put_line(c_msg.cod_zonatransporte);
     End If;
     i := i +1;
     If mod(i,pQtdecommit) = 0 Then
        commit;
     End If; 
   End Loop;
   commit;     
  
End SP_SAP_INSERE_ZONATRANSPORTE;


procedure SP_SAP_INSERE_LINHATRANSPORTE
  IS
   tpLinhTransporte migdv.linha_transporte%rowtype;
   i integer;
Begin
  
   For c_msg in (select distinct trim(fc.codorig) || trim(fc.coddest)  cod_linha_transporte ,
                        trim(fc.codorig) cod_zonatransporte_a ,
                        trim(fc.coddest) cod_zonatransporte_b 
                 from tdvadm.v_fcf_fretecar fc
                 where 0 = 0)
   Loop
     tpLinhTransporte.cod_linha_transporte := c_msg.cod_linha_transporte;
     tpLinhTransporte.cod_zonatransporte_a := c_msg.cod_zonatransporte_a;
     tpLinhTransporte.cod_zonatransporte_b := c_msg.cod_zonatransporte_b;

     insert into migdv.linha_transporte values tpLinhTransporte; 
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then
        commit;
     End If; 
   End Loop;
   commit;  
End SP_SAP_INSERE_LINHATRANSPORTE;


procedure SP_SAP_INSERE_LINHA_MEIO_TRANSPORTE
  IS
   tpLinha_Meio_Transporte migdv.linha_meio_transp%rowtype;
   i integer;
Begin
  
   For c_msg in (select distinct 
                        trim(fc.codorig) || trim(fc.coddest)  cod_linha_transporte ,
                        'ZTM01' cod_meio_transporte,
/* Trocado para um unico tipo 17/06/2020
   Conforme reuniao feita com Dantas, Alan, Vania, Jonatas e Rodrigo (Atos)
                        decode(fc.fcf_tpveiculo_codigo || '-' || fc.veiculo,'1  -CARRETA (ate 25ton)'      ,'ZTM02',
                                                                            '2  -BI-TREM'                  ,'ZTM02',
                                                                            '12 -CARRETA (ate 27ton)'      ,'ZTM02',
                                                                            '13 -CARRETA (acima 27001 ton)','ZTM02',
                                                                            '14 -VANDERLEA'                ,'ZTM02',
                                                                            '15 -RODO-TREM'                ,'ZTM02',
                                                                            '17 -CARRETA FIXA'             ,'ZTM02',
                                                                            '20 -BUG 20'                   ,'ZTM02',
                                                                            '21 -BUG 40'                   ,'ZTM02',
                                                                            '24 -Cavalo 4 x 2'             ,'ZTM02',
                                                                            '26 -VANDERLEA BASCULANTE'     ,'ZTM02',
                                                                            '31 -CARRETA PRANCHA REBAIXADA','ZTM02',
                                                                            '32 -CARRETA 14m'              ,'ZTM02',
                                                                            '34 -JULIETA'                  ,'ZTM02',
                                                                            '36 -CJ 4 EIXOS (CARRETA)'     ,'ZTM02',
                    
                                                                            '3  -TRUCK (até 14 ton)'       ,'ZTM01',
                                                                            '16 -BI-TRUCK'                 ,'ZTM01',
                                                                            '35 -TRUCK PRANCHA'            ,'ZTM01',
                                                                            '4  -TOCO (ate 5,5 ton)'       ,'ZTM03',
                                                                            '5  -FIORINO'                  ,'ZTM03',
                                                                            '6  -MOTO'                     ,'ZTM03',
                                                                            '7  -3/4 (ate 2,5 ton)'        ,'ZTM03',
                                                                            '8  -VAN'                      ,'ZTM03',
                                                                            '9  -SEM VEICULO (FRACIONADO)' ,'ZTM03',
                                                                            '10 -S10'                      ,'ZTM03',
                                                                            '11 -MALOTE'                   ,'ZTM03',
                                                                            '18 -PEQUENO PORTE (ate 500kg)','ZTM03',
                                                                            '19 -KIA BONGO'                ,'ZTM03',
                                                                            '22 -UTILITARIO (até 1,5 ton)' ,'ZTM03',
                                                                            '23 -PEQUENO PORTE (ate 50kg)' ,'ZTM03',
                                                                            '28 -SPRINTER'                 ,'ZTM03',
                                                                            '29 -PICK-UP'                  ,'ZTM03',
                                                                            '30 -VUC (1 a 3 ton)'          ,'ZTM03',
                                                                            '33 -608'                      ,'ZTM03',fc.fcf_tpveiculo_codigo) cod_meio_transporte,
*/
                        '20200101' dta_ini_validade ,
                        '20401231' dta_fim_validade ,
                        'S' ind_duracao_fixa ,
                        'S' ind_fixar_distr,
                        fc.km qtd_km_distancia ,
                        round((fc.km/500)+0.5,0) qtd_hrs_viagem  
                 From tdvadm.v_fcf_fretecar fc
                 where 0 = 0
                   and fc.km = (select max(fc1.km)
                                from tdvadm.v_fcf_fretecar fc1
                                where fc1.codorig = fc.codorig
                                  and fc1.coddest = fc.coddest)
                                  )
   Loop
     
     tpLinha_Meio_Transporte.COD_LINHA_TRANSPORTE := c_msg.COD_LINHA_TRANSPORTE;
     tpLinha_Meio_Transporte.COD_MEIO_TRANSPORTE  := c_msg.COD_MEIO_TRANSPORTE;
     tpLinha_Meio_Transporte.DTA_INI_VALIDADE     := c_msg.DTA_INI_VALIDADE;
     tpLinha_Meio_Transporte.DTA_FIM_VALIDADE     := c_msg.DTA_FIM_VALIDADE;
     tpLinha_Meio_Transporte.IND_DURACAO_FIXA     := c_msg.IND_DURACAO_FIXA;
     tpLinha_Meio_Transporte.IND_FIXAR_DISTR      := c_msg.IND_FIXAR_DISTR;
     tpLinha_Meio_Transporte.QTD_KM_DISTANCIA     := c_msg.QTD_KM_DISTANCIA;
     tpLinha_Meio_Transporte.QTD_HRS_VIAGEM       := c_msg.QTD_HRS_VIAGEM; 

     insert into migdv.linha_meio_transp values tpLinha_Meio_Transporte; 
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then
        commit;
     End If; 
   End Loop;
   commit;  
End SP_SAP_INSERE_LINHA_MEIO_TRANSPORTE;







-- Inseri Bancos na tabela BANK_MASTER_S_BNKA 
procedure SP_SAP_INSEREBANCO(PBANCO IN CHAR,
                             PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2) is
   i integer;
vCount Integer;
tpBANK_MASTER_S_BNKA MIGDV.BANK_MASTER_S_BNKA%ROWTYPE; 
begin
  vCount := 0;

      FOR vCursor IN (
        SELECT DISTINCT 
               B.GLB_BANCO_NUMERO  BANCO_NUMERO,
               B.GLB_BANCO_NOME     BANCO_NOME,
               A.GLB_AGENCIA_NUMERO AGENCIA_NUMERO,
               A.GLB_AGENCIA_NOME   AGENCIA_NOME
        FROM TDVADM.T_GLB_BANCO B,
             TDVADM.T_GLB_AGENCIA A,
             TDVADM.T_GLB_CONTAS C
        WHERE B.GLB_BANCO_NUMERO = A.GLB_BANCO_NUMERO
          AND A.GLB_BANCO_NUMERO = C.GLB_BANCO_NUMERO
          AND A.GLB_AGENCIA_NUMERO = C.GLB_AGENCIA_NUMERO
          AND B.GLB_BANCO_ATIVO = 'S'
          AND B.GLB_BANCO_NUMERO = PBANCO
      )  
      Loop
        
          SELECT COUNT(*)
          INTO vCount
          FROM MIGDV.BANK_MASTER_S_BNKA
          WHERE EXISTS (SELECT * FROM MIGDV.BANK_MASTER_S_BNKA 
                        WHERE BANKL =  TRIM(vCursor.BANCO_NUMERO) || TRIM(vCursor.AGENCIA_NUMERO));
                      
          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
          IF vCount = 0 Then                                                                      
 
            tpBANK_MASTER_S_BNKA.BANKS := vPais; -- Obrigatório(S) - Chave do país do banco
            tpBANK_MASTER_S_BNKA.BANKL := LPAD(TRIM(PBANCO), 3, '0') || TRIM(vCursor.AGENCIA_NUMERO); -- Obrigatório(S) - Chave do banco, composta pelo número do banco (com dígito) concatenado com o número da agência (sem dígito)
            tpBANK_MASTER_S_BNKA.BANKA := TRIM(vCursor.BANCO_NOME) || ' - AG ' || LPAD(TRIM(vCursor.AGENCIA_NUMERO), 5, '0'); -- Obrigatório(S) - Nome da agência / banco que identifica esta unidade.
            tpBANK_MASTER_S_BNKA.PROVZ := 'SP / ' || vCursor.AGENCIA_NOME; -- Obrigatório(N) - UF do Banco / Agencia
            tpBANK_MASTER_S_BNKA.STRAS := ' '; -- Obrigatório(N) - Endereço do Banco / Agencia
            tpBANK_MASTER_S_BNKA.ORT01 := ' '; -- Obrigatório(N) - Cidade do Banco / Agencia
            tpBANK_MASTER_S_BNKA.BNKLZ := NVL(LPAD(TRIM(vCursor.BANCO_NUMERO), 3, '0'), ' '); -- Obrigatório(N) - Número do banco
              
            begin
               INSERT INTO MIGDV.BANK_MASTER_S_BNKA VALUES tpBANK_MASTER_S_BNKA;
               i := i + 1;
               If mod(i,pQtdecommit) = 0 Then
                  commit;
               End If; 
            exception
              When OTHERS Then
                 vErro := sqlerrm;
                 rollback;
                 insert into tdvadm.t_glb_sql values (vErro,
                                                      sysdate,
                                                      'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                      'SP_SAP_INSEREBANCO - Banco - ' || LPAD(TRIM(PBANCO), 3, '0') || ' - Agencia ' || vCursor.AGENCIA_NOME);
                commit;
              End;
            
            COMMIT;
            
            PRESULTADO := 'N';
            PMENSAGEM  := 'Banco inserido com sucesso na tabela do SAP: ';

          End If;
      End Loop;
      commit;     

end SP_SAP_INSEREBANCO;


procedure SP_SAP_BANCO_TODOS(PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2) is
   i integer;
vBanco CHAR;
begin
  FOR vCursor IN (    
        SELECT distinct B.GLB_BANCO_NUMERO 
        FROM TDVADM.T_GLB_BANCO B
        WHERE 0 < (select count(*)
                   from tdvadm.t_cpg_chequebanco t
                   where t.glb_banco_numero = b.glb_banco_numero)
           or 0 < (select count(*)
                   from tdvadm.t_crp_titreceber t
                   where t.glb_banco_numero = b.glb_banco_numero)
           or 0 < (select count(*)
                   from tdvadm.t_glb_cliente cl
                   where cl.glb_banco_numero = b.glb_banco_numero)
  )
  LOOP
    SP_SAP_INSEREBANCO(vCursor.GLB_BANCO_NUMERO, PRESULTADO, PMENSAGEM);
  END LOOP;
  
end SP_SAP_BANCO_TODOS;




-- Insere Banco da tabela CUSTOMER_S_CUST_BANK_DATA 
procedure SP_SAP_INSERE_BANK_DATA(PIDCLIENTE IN VARCHAR2,
                                  PCPFCNPJ IN TDVADM.T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE,
                                  PRESULTADO OUT Char,
                                  PMENSAGEM OUT VARCHAR2) is
vCount Integer;
tpBANK_MASTER_S_BNKA_DATA MIGDV.CUSTOMER_S_CUST_BANK_DATA%ROWTYPE; 
vBanco TDVADM.T_GLB_CLIENTE.GLB_BANCO_NUMERO%TYPE;
vSiglaPais TDVADM.T_GLB_PAIS.GLB_PAIS_SIGLASAP%TYPE;

vBancoNumero TDVADM.T_GLB_BANCO.GLB_BANCO_NUMERO%TYPE;
vAgencia     TDVADM.T_GLB_AGENCIA.GLB_AGENCIA_NUMERO%TYPE;
vContaNumero TDVADM.T_GLB_CONTAS.GLB_CONTAS_NUMERO%TYPE;
vBancoNome   TDVADM.T_GLB_BANCO.GLB_BANCO_NOME%TYPE;
   i integer;

begin
  vCount := 0;
  
  SELECT DISTINCT
         CLI.GLB_BANCO_NUMERO,
         vPais GLB_PAIS_SIGLASAP
   INTO vBanco,
        vSiglaPais
  FROM TDVADM.T_GLB_CLIENTE CLI
  WHERE CLI.GLB_CLIENTE_CGCCPFCODIGO = PCPFCNPJ;
  
    Begin
    SELECT B.GLB_BANCO_NUMERO  BANCO_NUMERO,
           B.GLB_BANCO_NOME     BANCO_NOME,
           A.GLB_AGENCIA_NUMERO AGENCIA_NUMERO,
           C.GLB_CONTAS_NUMERO  CONTA_NUMERO
           --A.GLB_AGENCIA_NOME   AGENCIA_NOME
      INTO vBancoNumero,
           vBancoNome,
           vAgencia,
           vContaNumero
    FROM TDVADM.T_GLB_BANCO B,
         TDVADM.T_GLB_AGENCIA A,
         TDVADM.T_GLB_CONTAS C
    WHERE B.GLB_BANCO_NUMERO = A.GLB_BANCO_NUMERO
      AND A.GLB_BANCO_NUMERO = C.GLB_BANCO_NUMERO
      AND A.GLB_AGENCIA_NUMERO = C.GLB_AGENCIA_NUMERO
      AND B.GLB_BANCO_ATIVO = 'S'
      AND B.GLB_BANCO_NUMERO = vBanco
      AND ROWNUM = 1; -- COLOCADO TEMPORARIAMENTE PARA RETORNAR SO 1 REGISTRO
   exception
     when Others Then
        vBancoNumero := ' ';
        vBancoNome   := ' ';
        vAgencia     := ' ';
        vContaNumero := ' ';
   End;
      
  --)  
  --Loop
        
      SELECT COUNT(*)
      INTO vCount
      FROM MIGDV.CUSTOMER_S_CUST_BANK_DATA B
      WHERE EXISTS (SELECT * FROM MIGDV.CUSTOMER_S_CUST_BANK_DATA 
                    WHERE BANKL =  TRIM(vBancoNumero) || TRIM(vAgencia))
        AND B.KUNNR = PIDCLIENTE;
                      
      PRESULTADO := 'N';
      PMENSAGEM  := ''; 
                    
      IF (NVL(vCount, 0) = 0) and (NVL(Trim(vBancoNumero), '000') <> '000') Then
            
        tpBANK_MASTER_S_BNKA_DATA.KUNNR        := PIDCLIENTE; -- Obrigatório(S) - Identificador do cliente
        tpBANK_MASTER_S_BNKA_DATA.BANKS        := NVL(vSiglaPais, ' '); -- Obrigatório(N) - País do banco
        tpBANK_MASTER_S_BNKA_DATA.BANKL        := LPAD(RTRIM(vBancoNumero),3,'0') || TRIM(vAgencia); -- Obrigatório(N) - Identificador do Banco/Agencia
        tpBANK_MASTER_S_BNKA_DATA.BANKN        := NVL(vContaNumero, ' '); -- Obrigatório(N) - Conta (Acc. No. ou IBAN)
        tpBANK_MASTER_S_BNKA_DATA.IBAN         := ' '; -- Obrigatório(N) - ""IBAN, conforme padrão de identidade internacional de contas bancárias; composto por:2 caracteres alfanuméricos que correspondem ao código do País;2 dígitos verificadores, que estão na faixa de faixa de 02 a 98;8 caracteres numéricos que se referem à identificação da instituição financeira (ISPB);5 caracteres numéricos correspondentes à identificação da agência bancária (sem o dígito verificador);10 caracteres numéricos que correspondem a numeração da conta bancária do cliente, incluindo o dígito verificador;1 caractere alfanumérico referente ao tipo de conta;1 caractere alfanumérico relacionado à identificação do titular da conta seguindo a ordem da listagem de titulares ( sendo ¿1¿ usado para primeiro ou único titular, ¿2¿ para o segundo titular... ¿A¿ para o décimo titular, e assim por diante, usando os caracteres alfabéticos de ¿A¿ a ¿Z¿ para os titulares a partir do décimo).""
        tpBANK_MASTER_S_BNKA_DATA.BKONT        := ' '; -- Obrigatório(N) - Chave de controle do banco
        tpBANK_MASTER_S_BNKA_DATA.KOINH        := ' '; -- Obrigatório(N) - Nome do titular da conta
        tpBANK_MASTER_S_BNKA_DATA.EBPP_ACCNAME := NVL(vBancoNome, ' '); -- Obrigatório(N) - Nome da conta
        tpBANK_MASTER_S_BNKA_DATA.XEZER        := ' '; -- Obrigatório(N) - Indicador de Autorização de Cobrança
              
        INSERT INTO MIGDV.CUSTOMER_S_CUST_BANK_DATA VALUES tpBANK_MASTER_S_BNKA_DATA;
        PRESULTADO := 'N';
        PMENSAGEM  := 'Informação do banco inserida com sucesso na tabela do SAP';

      End If;
  --End Loop;
exception
   When others then
            
        vErro := sqlerrm;
        rollback;
         
        insert into tdvadm.t_glb_sql values (vErro,
                                             sysdate,
                                             'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                             'SP_SAP_INSERE_BANK_DATA - Cliente - ' || PCPFCNPJ || ' - Banco ' || vBanco);
                commit;

--        dbms_output.put_line ('Cliente - ' || PCPFCNPJ || ' - Banco ' || vBanco);
--        dbms_output.put_line ('Erro: ' || sqlerrm);
end SP_SAP_INSERE_BANK_DATA;

procedure SP_CUSTOMER_S_CUST_SALES_DATA
  Is 
  
  -- Local variables here
  i integer;
  TpTAB MIGDV.CUSTOMER_S_CUST_SALES_DATA%ROWTYPE;
begin
  -- Test statements here
  I := 0;
  DELETE MIGDV.CUSTOMER_S_CUST_SALES_DATA;
  COMMIT;
  for c_msg in (select G.KUNNR,
                       D.NOM_DOMINIO vkorg,
                       '10' vtweg,
                       '01' spart,
                       vMoeda WAERS
                from migdv.meta_dominio_coluna@database_tdx d,
                     migdv.customer_s_cust_gen g
                where d.nom_view = 'CUSTOMER_S_CUST_SALES_DATA'
                  and d.nom_coluna = 'VKORG'
                --  and 0 = (select count(*)
                --           from migdv.CUSTOMER_S_CUST_SALES_DATA m
                --           where m.KUNNR = g.KUNNR
                --             and m.VKORG = d.nom_dominio)
               )
   LOOP
     I:= I + 1;
     TpTAB.KUNNR := C_MSG.KUNNR;
     TpTAB.VKORG := C_MSG.VKORG;
     TpTAB.VTWEG := C_MSG.VTWEG;
     TpTAB.SPART := C_MSG.SPART;
     TpTAB.waers := C_MSG.WAERS;
     Begin
        INSERT INTO MIGDV.CUSTOMER_S_CUST_SALES_DATA VALUES TpTAB;
--        commit;
     exception
        When others then
            
             vErro := sqlerrm;
             rollback;
             insert into tdvadm.t_glb_sql values (vErro,
                                                  sysdate,
                                                  'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                  'SP_CUSTOMER_S_CUST_SALES_DATA - Cliente - ' || C_MSG.KUNNR || ' - Filial ' || C_MSG.VKORG);
             commit;
     End;


     If MOD(I,pQtdecommit) = 0 Then
       commit;
     End If;
   END lOOP
   commit;
   
end SP_CUSTOMER_S_CUST_SALES_DATA;



procedure SP_CUSTOMER_S_CUST_SALES_PARTNER
  Is 
  
  -- Local variables here
  i integer;
  TpTAB MIGDV.CUSTOMER_S_CUST_SALES_PARTNER%ROWTYPE;
begin
  -- Test statements here
  I := 0;
  DELETE MIGDV.CUSTOMER_S_CUST_SALES_PARTNER;
  COMMIT;
  for c_msg in (select G.KUNNR,
                       D.NOM_DOMINIO vkorg,
                       '10' vtweg,
                       '01' spart,
                       vMoeda WAERS
                from migdv.meta_dominio_coluna@database_tdx d,
                     migdv.customer_s_cust_gen g
                where d.nom_view = 'CUSTOMER_S_CUST_SALES_DATA'
                  and d.nom_coluna = 'VKORG'
                --  and 0 = (select count(*)
                --           from migdv.CUSTOMER_S_CUST_SALES_DATA m
                --           where m.KUNNR = g.KUNNR
                --             and m.VKORG = d.nom_dominio)
               )
   LOOP
     TpTAB.KUNNR := C_MSG.KUNNR;
     TpTAB.VKORG := C_MSG.VKORG;
     TpTAB.VTWEG := C_MSG.VTWEG;
     TpTAB.SPART := C_MSG.SPART;
     Begin
        TpTAB.Parvw := 'PC'; -- Sacado
        INSERT INTO MIGDV.CUSTOMER_S_CUST_SALES_PARTNER VALUES TpTAB;
        TpTAB.Parvw := 'RF'; -- Recebedor de Faturas
        INSERT INTO MIGDV.CUSTOMER_S_CUST_SALES_PARTNER VALUES TpTAB;
        TpTAB.Parvw := 'PG'; -- Pagador
        INSERT INTO MIGDV.CUSTOMER_S_CUST_SALES_PARTNER VALUES TpTAB;
        TpTAB.Parvw := 'WE'; -- Destinatario
        INSERT INTO MIGDV.CUSTOMER_S_CUST_SALES_PARTNER VALUES TpTAB;
        I:= I + 4;
     exception
        When others then
            
             vErro := sqlerrm;
             rollback;
             insert into tdvadm.t_glb_sql values (vErro,
                                                  sysdate,
                                                  'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                  'SP_CUSTOMER_S_CUST_SALEST_PARTNER - Cliente - ' || C_MSG.KUNNR || ' - Filial ' || C_MSG.VKORG);
             commit;
     End;


     If MOD(I,pQtdecommit) = 0 Then
       commit;
     End If;
   END lOOP
   commit;
   
end SP_CUSTOMER_S_CUST_SALES_PARTNER;



-- Insere Impostos Retidos do documento Fornecedor
procedure SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO(PIDFORNECEDOR IN CHAR,
                                                  PTIPO         IN CHAR,
                                                  PTIPOPFPJ     IN CHAR,
                                                  PRESULTADO OUT Char,
                                                  PMENSAGEM OUT VARCHAR2) is
vCount Integer;

tpVENDOR_S_SUPPL_WITH_TAX   MIGDV.VENDOR_S_SUPPL_WITH_TAX%ROWTYPE; 
tpVend_Ext_s_Suppl_With_Tax MIGDV.Vend_Ext_s_Suppl_With_Tax%ROWTYPE; 
begin

/*
Codigos dos 
¿ 1162 - INSS Retido de Fornecedores PESSOA JURÍDICA;
¿ 1099 - INSS Retido de Fornecedores PESSOA FÍSICA ¿ RPAs;
¿ 0588 - IRRF Retido de Fornecedores PESSOA FÍSICA ¿ RPAs;
¿ 3208 - IRRF Retido de Fornecedores PESSOA FÍSICA ¿ ALUGUEL;
¿ 5952 - CSRF Retido de Fornecedores PESSOA JURÍDICA;
¿ 1300 - ISS retido de Fornecedores Pessoa Jurídica;
*/


    tpVENDOR_S_SUPPL_WITH_TAX.LIFNR     := PIDFORNECEDOR; -- Obrigatório(S) - Identificador do Fornecedor
    tpVENDOR_S_SUPPL_WITH_TAX.BUKRS     := vCodigoEmpresa; -- Obrigatório(S) - Código da companhia*

    tpVend_Ext_s_Suppl_With_Tax.LIFNR     := PIDFORNECEDOR; -- Obrigatório(S) - Identificador do Fornecedor
    tpVend_Ext_s_Suppl_With_Tax.BUKRS     := vCodigoEmpresa; -- Obrigatório(S) - Código da companhia*

    for vCount in 1..10
    loop
      If PTIPO in ('PRO') Then
         If PTIPOPFPJ = 'F' Then
            If vCount = 1 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '1099'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT     := 'INSS Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '1099'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 2 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '1218 '; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT     := 'SEST Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '1218'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 3 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '1221 '; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT     := 'SENAT Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '1221'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 4 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '0588'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT     := 'IRRF Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '0588'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            Else
              Return;
            End If;
         ElsIf PTIPOPFPJ = 'J' Then
            If vCount = 1 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '1708'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT     := 'IRRF Retido de Fornecedores PESSOA JURÍDICA'; -- Obrigatório(N) - Objeto do imposto
                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '1708'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 2 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '5960 '; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT     := 'Cofins Retido,relacionado ao código 5952,quando não houver a ret de PIS ou CSLL'; -- Obrigatório(N) - Objeto do imposto

                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '5960'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 3 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '5979'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT     := 'PIS Retido,relacionado ao código 5952,quando não houver a ret da Cofins ou CSLL'; -- Obrigatório(N) - Objeto do imposto
                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '5979'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 4 Then
                tpVend_Ext_s_Suppl_With_Tax.WT_WITHCD := '5987'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVend_Ext_s_Suppl_With_Tax.WITHT      := 'CSLL Retido,relacionado ao código 5952,quando não houver ret de PIS ou Cofins'; -- Obrigatório(N) - Objeto do imposto
                tpVend_Ext_s_Suppl_With_Tax.WT_WTSTCD := '5987'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            Else
              Return;
            End If;
          Else
            Return;
          End If; 
      End If;

      If PTIPO in ('CAR','FOR','BGM','FPW') Then
         If PTIPOPFPJ = 'F' Then
            tpVENDOR_S_SUPPL_WITH_TAX.WT_SUBJCT     := 'F'; -- Obrigatório(S) - Tipo de imposto retido na fonte *
            If vCount = 1 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '1099'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := 'INSS Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '1099'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 2 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '1218 '; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := 'SEST Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '1218'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 3 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '1221 '; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := 'SENAT Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '1221'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 4 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '0588'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := 'IRRF Carreteiros'; -- Obrigatório(N) - Objeto do imposto
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '0588'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            Else
              Return;
            End If;
         ElsIf PTIPOPFPJ = 'J' Then
            tpVENDOR_S_SUPPL_WITH_TAX.WT_SUBJCT     := 'J'; -- Obrigatório(S) - Tipo de imposto retido na fonte *
            If vCount = 1 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '1708'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := 'IRRF Retido de Fornecedores PESSOA JURÍDICA'; -- Obrigatório(N) - Objeto do imposto
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '1708'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 2 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '5960 '; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := 'Cofins Retido,relacionado ao código 5952,quando não houver a ret de PIS ou CSLL'; -- Obrigatório(N) - Objeto do imposto

                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '5960'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 3 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '5979'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := 'PIS Retido,relacionado ao código 5952,quando não houver a ret da Cofins ou CSLL'; -- Obrigatório(N) - Objeto do imposto
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '5979'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            ElsIf vCount = 4 Then
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := '5987'; -- Obrigatório(N) - Código do imposto retido na fonte
                tpVENDOR_S_SUPPL_WITH_TAX.WITHT      := 'CSLL Retido,relacionado ao código 5952,quando não houver ret de PIS ou Cofins'; -- Obrigatório(N) - Objeto do imposto
                tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := '5987'; -- Obrigatório(N) - Número de identificação do imposto retido na fonte
            Else
              Return;
            End If;
          Else
            Return;
          End If; 
      Else
        Return;
      End If;

      INSERT INTO MIGDV.VENDOR_S_SUPPL_WITH_TAX VALUES tpVENDOR_S_SUPPL_WITH_TAX;
      
    end loop;

end SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO;



procedure SP_SAP_INSERECLIENTE(PDATA_CORTE IN VARCHAR2,
                               PTIPO_ENDERECO IN CHAR,
                               PRESULTADO OUT Char,
                               PMENSAGEM OUT VARCHAR2) is
                                        
vCount Integer;
vPosicao varchar2(130);
vIdentificadorCli number;                                        
vCliente char(20);     
vCliRed  TpCliRed;  
i    integer;
                          
begin    

   for vCursor2 in (select C.KUNNR
                    FROM MIGDV.CUSTOMER_S_CUST_GEN C
                    order by to_number(C.KUNNR) desc
                    )
   loop
      vIdCustomer := vCursor2.Kunnr;
      exit;
   end loop;
   
   
   for vCursor2 in (Select C.LIFNR
                    FROM MIGDV.VENDOR_S_SUPPL_GEN C
                    order by to_number(C.LIFNR) desc
                    )
   loop
      vIdVendor := vCursor2.LIFNR;
      exit;
   end loop;

   for c_msg in (select LIFNR
                 from MIGDV.VEND_EXT_S_SUPPL_GEN x
                 order by TO_NUMBER(x.LIFNR) desc)
   Loop
      vIdVend := c_msg.lifnr;  -- Obrigatório(S) - Identificador do Fornecedor  
      exit;
   End loop;

    i := 0;

    FOR vCursor IN (
                    SELECT distinct '1' ordem,
                                    s.tab_cidade,
                                    s.tab_estado,
                                    s.tab_pais,
                                    trim(s.tab_cep) tab_cep,
                                    s.tab_endereco,
                                    s.tab_cpf_cnpj,
                                    decode(length(trim(s.tab_cpf_cnpj)),11,'X',' ') pessoaFJ,
                                    s.tab_codcliente,
                                    s.tab_razaosocial,
                                    s.tab_grupoeconomico,
                                    s.cep_endereco,
                                    s.valor_vencido,
                                    s.limpo_logradouro,
                                    s.limpo_numero,
                                    s.limpo_complemento,
                                    s.bairro,
                                    s.banco_numero,
                                    s.sigla_sap,
                                    s.estado,
                                    s.glb_cliente_cgccpfcodigo,
                                    s.ie,
                                    s.im,
                                    s.RG,
                                    s.INSS,
                                    s.MATRICULA,
                                    s.TIPO2,
                                    s.cbo,
                                    s.dtnascimento,
                                    s.CRTN,
                                    s.tipo,
                                    s.CFOPSAP,
                                    s.tipo_endereco,
                                    s.glb_portaria_id,
                                    s.nacional
                    FROM migdv.v_pessoasSAP S
                    WHERE S.DATA_CORTE >= to_date(PDATA_CORTE,'dd/mm/yyyy') 
--                       Sirlano 02/09/2020
--                       E para inserir todos os endereços e criar 1 BP para cada endereco
--                      AND S.TIPO_ENDERECO = trim(PTIPO_ENDERECO)
--                      and s.ie = 'ISENTO'
                      and s.TIPO in ('CLI','PRO')
                        and s.tab_estado is not null
--                      and s.TAB_CPF_CNPJ in ('26412499000138','08049002000187')
                      and 0 = (select count(*)
                               from migdv.customer_s_cust_gen g
                               where trim(g.SORTL) = trim(s.GLB_CLIENTE_CGCCPFCODIGO)
                                 and substr(g.namorg4,1,1) = s.TIPO_ENDERECO)
                    union
                    SELECT distinct '2' ordem,
                                    s.tab_cidade,
                                    s.tab_estado,
                                    s.tab_pais,
                                    trim(s.tab_cep) tab_cep,
                                    s.tab_endereco,
                                    s.tab_cpf_cnpj,
                                    decode(length(trim(s.tab_cpf_cnpj)),11,'X',' ') pessoaFJ,
                                    s.tab_codcliente,
                                    s.tab_razaosocial,
                                    s.tab_grupoeconomico,
                                    s.cep_endereco,
                                    s.valor_vencido,
                                    s.limpo_logradouro,
                                    s.limpo_numero,
                                    s.limpo_complemento,
                                    s.bairro,
                                    s.banco_numero,
                                    s.sigla_sap,
                                    s.estado,
                                    s.glb_cliente_cgccpfcodigo,
                                    s.ie,
                                    s.im,
                                    s.RG,
                                    s.INSS,
                                    s.MATRICULA,
                                    s.TIPO2,
                                    s.cbo,
                                    s.dtnascimento,
                                    s.CRTN,
                                    s.tipo,
                                    s.CFOPSAP,
                                    s.tipo_endereco,
                                    s.glb_portaria_id,
                                    s.nacional
                    FROM migdv.v_pessoasSAP S
                    WHERE S.DATA_CORTE >= to_date(PDATA_CORTE,'dd/mm/yyyy') 
                      AND S.TIPO_ENDERECO = trim(PTIPO_ENDERECO)
                      and s.tab_estado is not null
                      and s.TIPO NOT IN ('CLI','PRO')
--                      and s.TAB_CPF_CNPJ in ('26412499000138','08049002000187')
                      and 0 = (select count(*)
                               from migdv.vendor_s_suppl_gen v
                               where trim(v.SORTL) = trim(s.GLB_CLIENTE_CGCCPFCODIGO)
                                 and substr(v.name4,1,1) = s.TIPO_ENDERECO)
                   order by 1,29
                   )
    LOOP
      Begin
        vPosicao := 'NOVO - ' || NVL(trim(vCursor.TAB_CPF_CNPJ), '0');
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        vCliRed.ChaveSap     := null;
        vCliRed.CPFCNPJ      := NVL(trim(vCursor.TAB_CPF_CNPJ), '0');
        vCliRed.Tipo         := vCursor.Tipo;
        vCliRed.Tipo2        := vCursor.Tipo2;
        vCliRed.RG           := nvl(vCursor.RG,' ');
        vCliRed.INSS         := vCursor.INSS;
        vCliRed.Matricula    := vCursor.Matricula;
        vCliRed.ie           := vCursor.IE;
        vCliRed.im           := vCursor.IM;
        vCliRed.cbo          := vCursor.CBO;
        vCliRed.dtnascimento := vCursor.dtnascimento;
        
        If vCursor.Tipo IN ('CLI','PRO') Then
            vIdCustomer := nvl(vIdCustomer,0) + 1;
            vIdentificadorCli := vIdCustomer;
            
            
            
            tpCUSTOMER_S_CUST_GEN.KUNNR         := vIdentificadorCli; /* Obrigatório(S) - Identificador do Cliente */
            tpCUSTOMER_S_CUST_GEN.BU_GROUP      := '00001';  /* Obrigatório(S) - Agrupamento de Parceiro (Fixo 00001) */
            tpCUSTOMER_S_CUST_GEN.KTOKD         := ' '; /* Obrigatório(N) (S) - Grupo de Contas do Cliente */
             
            tpCUSTOMER_S_CUST_GEN.Natpers       := vCursor.pessoaFJ;
            tpCUSTOMER_S_CUST_GEN.NAMORG1       := nvl(SUBSTR(vCursor.TAB_RAZAOSOCIAL, 1, 40),' '); /* Obrigatório(N) - Nome*/
            tpCUSTOMER_S_CUST_GEN.NAMORG2       := NVL(SUBSTR(vCursor.TAB_RAZAOSOCIAL, 41),' '); /* Obrigatório(N) (S) - Nome 2*/
            tpCUSTOMER_S_CUST_GEN.Cfopc         := vCursor.cfopSap;
            tpCUSTOMER_S_CUST_GEN.NAMORG3       := vCursor.TAB_CPF_CNPJ; /* Obrigatório(N) - Nome 3*/
            tpCUSTOMER_S_CUST_GEN.NAMORG4       := vCursor.tipo_endereco ||'|'||vCursor.tab_codcliente||'|'||vCursor.glb_portaria_id || '|' || vCursor.Tipo; /* Obrigatório(N) - Nome 4*/
            tpCUSTOMER_S_CUST_GEN.SORTL         := NVL(trim(vCursor.TAB_CPF_CNPJ), '0'); /* Obrigatório(N) - Termo de Pesquisa 1*/
            tpCUSTOMER_S_CUST_GEN.MCOD2         := ' '; /* Obrigatório(N) - Termo de Pesquisa 2*/
            tpCUSTOMER_S_CUST_GEN.FOUND_DAT     := ' '; /* Obrigatório(N) -  Data da fundação*/
            tpCUSTOMER_S_CUST_GEN.LIQUID_DAT    := ' '; /* Obrigatório(N) -  Data de liquidação*/
            tpCUSTOMER_S_CUST_GEN.KUKLA         := '00001';    /* Obrigatório(N) -  Classificação do Cliente (Fixo 00001) */
            tpCUSTOMER_S_CUST_GEN.SUFRAMA       := ' '; /* Obrigatório(N) - Código Suframa */
            tpCUSTOMER_S_CUST_GEN.CNAE          := ' '; /* Obrigatório(N) - CNAE */
            tpCUSTOMER_S_CUST_GEN.CRTN          := vCursor.CRTN; /* Obrigatório(N) - Número CRT */
            tpCUSTOMER_S_CUST_GEN.ICMSTAXPAY    := ' '; /* Obrigatório(N) - Contribuinte do ICMS */
            tpCUSTOMER_S_CUST_GEN.DECREGPC      := ' '; /* Obrigatório(N) - Regime de Declaração para PIS / COFINS */
            tpCUSTOMER_S_CUST_GEN.STREET        := NVL(substr(vCursor.LIMPO_LOGRADOURO,1,60), ' '); /* Obrigatório(N) - Nome do Logradouro do endereço principal.*/
            tpCUSTOMER_S_CUST_GEN.HOUSE_NUM1    := NVL(substr(vCursor.LIMPO_NUMERO,1,10), ' '); /* Obrigatório(N) - Número do Endereço */
            tpCUSTOMER_S_CUST_GEN.CITY2         := substr(NVL(vCursor.BAIRRO, ' '),1,40); --**verificar /* Obrigatório(N) - Bairro do endereço principal */ 
            if vCursor.CEP_ENDERECO is not null Then
               If trim(nvl(vCursor.TAB_CEP,'-')) <> '-' Then
                  tpCUSTOMER_S_CUST_GEN.POST_CODE1 := trim(vCursor.TAB_CEP); -- **verificar 00000 NAO MANDAR NADA/* Obrigatório(N) - CEP do endereço principal */
               Else
                  tpCUSTOMER_S_CUST_GEN.POST_CODE1 := '02174-010';   
               End If;
            Else
               tpCUSTOMER_S_CUST_GEN.POST_CODE1 := '02174-010';   
            End If;
            If tpCUSTOMER_S_CUST_GEN.POST_CODE1 = '02174-010' Then
               tpCUSTOMER_S_CUST_GEN.CITY1         := 'SAO PAULO'; /* Obrigatório(N) - Cidade do endereço principal */
               tpCUSTOMER_S_CUST_GEN.COUNTRY       := 'BR'; /* Obrigatório(S) - País do endereço principal */
               tpCUSTOMER_S_CUST_GEN.REGION        := 'SP'; /* Obrigatório(N) - Estado/UF do endereço principal */ 
               tpCUSTOMER_S_CUST_GEN.STR_SUPPL1    := 'SP'; -- /* Obrigatório(N) - Segundo campo de logradouro do endereço principal do cliente */
               tpCUSTOMER_S_CUST_GEN.HOUSE_NO2     := ' '; /* Obrigatório(N) - Complemento do Endereço principal do cliente */
            Else
               tpCUSTOMER_S_CUST_GEN.CITY1         := NVL(TRIM(substr(vCursor.TAB_CIDADE,1,40)), ' '); /* Obrigatório(N) - Cidade do endereço principal */
               tpCUSTOMER_S_CUST_GEN.COUNTRY       := NVL(vCursor.SIGLA_SAP, ' '); /* Obrigatório(S) - País do endereço principal */
               tpCUSTOMER_S_CUST_GEN.REGION        := NVL(substr(vCursor.TAB_ESTADO,1,80), ' '); /* Obrigatório(N) - Estado/UF do endereço principal */ 
               tpCUSTOMER_S_CUST_GEN.STR_SUPPL1    := nvl(vCursor.ESTADO,tpCUSTOMER_S_CUST_GEN.REGION); -- /* Obrigatório(N) - Segundo campo de logradouro do endereço principal do cliente */
               tpCUSTOMER_S_CUST_GEN.HOUSE_NO2     := NVL(SUBSTR(vCursor.LIMPO_COMPLEMENTO,1, 10), ' '); /* Obrigatório(N) - Complemento do Endereço principal do cliente */
            End If;
            tpCUSTOMER_S_CUST_GEN.PO_BOX        := ' '; /* Obrigatório(N) - Caixa postal */
            tpCUSTOMER_S_CUST_GEN.POST_CODE2    := ' '; /* Obrigatório(N) - CEP da caixa postal */
            tpCUSTOMER_S_CUST_GEN.PO_BOX_LOC    := ' '; /* Obrigatório(N) - Cidade da Caixa postal */
            tpCUSTOMER_S_CUST_GEN.POBOX_CTRY    := ' '; /* Obrigatório(N) - País da caixa postal */
            tpCUSTOMER_S_CUST_GEN.PO_BOX_REG    := ' '; /* Obrigatório(N) - Estado/UF da caixa postal */ 
            tpCUSTOMER_S_CUST_GEN.LANGU_CORR    := 'PT'; /* Obrigatório(N) - Idioma */
            tpCUSTOMER_S_CUST_GEN.TELNR_LONG    := ' '; /* Obrigatório(N) - Telefone */ 
            tpCUSTOMER_S_CUST_GEN.TELNR_LONG_2  := ' '; /* Obrigatório(N) - Telefone Adicional 2 */
            tpCUSTOMER_S_CUST_GEN.TELNR_LONG_3  := ' '; /* Obrigatório(N) - Telefone Adicional 3 */
            tpCUSTOMER_S_CUST_GEN.MOBILE_LONG   := ' '; /* Obrigatório(N) - Celular */
            tpCUSTOMER_S_CUST_GEN.MOBILE_LONG_2 := ' '; /* Obrigatório(N) - Celular adicional 2 */
            tpCUSTOMER_S_CUST_GEN.MOBILE_LONG_3 := ' '; /* Obrigatório(N) - Celular adicional 3 */
            tpCUSTOMER_S_CUST_GEN.FAXNR_LONG    := ' '; /* Obrigatório(N) - Fax */
            tpCUSTOMER_S_CUST_GEN.FAXNR_LONG_2  := ' '; /* Obrigatório(N) - Fax adicional 2 */
            tpCUSTOMER_S_CUST_GEN.FAXNR_LONG_3  := ' '; /* Obrigatório(N) - Fax adicional 3 */
            tpCUSTOMER_S_CUST_GEN.SMTP_ADDR     := ' '; /* Obrigatório(N) - Email */
            tpCUSTOMER_S_CUST_GEN.SMTP_ADDR_2   := ' '; /* Obrigatório(N) - E-mail adicional 2 */
            tpCUSTOMER_S_CUST_GEN.SMTP_ADDR_3   := ' '; /* Obrigatório(N) - E-mail adicional 3 */
            tpCUSTOMER_S_CUST_GEN.URI_TYP       := ' '; /* Obrigatório(N) - Tipo de Comunicação */
            tpCUSTOMER_S_CUST_GEN.URI_ADDR      := ' '; /* Obrigatório(N) - Web Site */
            tpCUSTOMER_S_CUST_GEN.SPERR         := ' '; /* Obrigatório(N) - Bloqueio de Postagem - Central */
            tpCUSTOMER_S_CUST_GEN.COLLMAN       := ' '; /* Obrigatório(N) - Gerenciamento de Cobrança ativo */
            Begin
               tpCUSTOMER_S_CUST_GEN.RG := nvl(vCursor.Rg,' ');
            exception
              When OTHERS Then
                 tpCUSTOMER_S_CUST_GEN.RG := ' ';
              End;
            If trim(tpCUSTOMER_S_CUST_GEN.SORTL) = '37826087805' Then 
               tpCUSTOMER_S_CUST_GEN.SORTL := tpCUSTOMER_S_CUST_GEN.SORTL;
            End If;                               
            vPosicao := 'MIGDV.CUSTOMER_S_CUST_GEN - ' || tpCUSTOMER_S_CUST_GEN.SORTL;

            If tpCUSTOMER_S_CUST_GEN.Street = ' ' Then
               tpCUSTOMER_S_CUST_GEN.house_num1 := ' ';
               tpCUSTOMER_S_CUST_GEN.house_no2  := ' ';
            End If;  

            If vCursor.nacional = 'I' Then
               If tpCUSTOMER_S_CUST_GEN.country = vPais Then
                  tpCUSTOMER_S_CUST_GEN.country := ' ';
               End If;
               tpCUSTOMER_S_CUST_GEN.region := 'EX';
               tpCUSTOMER_S_CUST_GEN.Street := 'Internacional';
               tpCUSTOMER_S_CUST_GEN.house_num1 := '9';
               tpCUSTOMER_S_CUST_GEN.house_no2  := '9';
               tpCUSTOMER_S_CUST_GEN.Sortl      := ' ';
            End If;  

            if tpCUSTOMER_S_CUST_GEN.POST_CODE1 Is null Then
               tpCUSTOMER_S_CUST_GEN.POST_CODE1 := ' ';
            End If;
            If tpCUSTOMER_S_CUST_GEN.country =  ' ' Then
               tpCUSTOMER_S_CUST_GEN.country := tpCUSTOMER_S_CUST_GEN.country;
            end If;
            INSERT INTO MIGDV.CUSTOMER_S_CUST_GEN VALUES tpCUSTOMER_S_CUST_GEN;
            i := i + 1;
            commit;
        End If;
        If vCursor.Tipo IN ('PRO') then

             vIdvend := nvl(vIdvend,0) + 1;

             tpVEND_EXT_S_SUPPL_GEN.LIFNR := vIdvend;
             
             tpVEND_EXT_S_SUPPL_GEN.KUNNR := tpCUSTOMER_S_CUST_GEN.Kunnr;      -- Obrigatório(N) - Identificador do Cliente
             tpVEND_EXT_S_SUPPL_GEN.REF_KUNNR := tpCUSTOMER_S_CUST_GEN.NAMORG1; -- Obrigatório(N) - Identificador do Cliente de referência
             If vCursor.Tipo2 = 'C' Then
                tpVEND_EXT_S_SUPPL_GEN.BPKIND := 'Z002'; -- Terceiros/Dedicado
             ElsIf vCursor.Tipo2 = 'A' Then
                tpVEND_EXT_S_SUPPL_GEN.BPKIND := 'Z004'; -- Agregado
             End If; 

             vPosicao := 'MIGDV.VENDOR_S_SUPPL_GEN - ' || tpCUSTOMER_S_CUST_GEN.SORTL  ;
             INSERT INTO MIGDV.VEND_EXT_S_SUPPL_GEN VALUES tpVEND_EXT_S_SUPPL_GEN;
             i := i + 1;
             commit;
             
             vIdentificadorCli := tpVEND_EXT_S_SUPPL_GEN.LIFNR;

             SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO(tpVEND_EXT_S_SUPPL_GEN.LIFNR,
                                                     vCursor.Tipo,
                                                     vCursor.pessoaFJ,
                                                     PRESULTADO,
                                                     PMENSAGEM);



--           SP_SAP_INSERE_FORNECEDOR_CLI(vCursor.Tipo,vIdentificadorCli,PRESULTADO, PMENSAGEM);    
--        ElsIf vCursor.Tipo IN ('FOR','BGM') Then
--           SP_SAP_INSERE_FORNECEDOR() 
        End If;

        If vCursor.Tipo IN ('CAR','FOR','BGM','FPW') Then



          vIdVendor := nvl(vIdVendor,0) + 1;
          vIdentificadorCli := vIdVendor;          

          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
            tpVENDOR_S_SUPPL_GEN.BPKIND := ' '; 
           
            tpVENDOR_S_SUPPL_GEN.LIFNR         := vIdentificadorCli; -- Obrigatório(S) - Identificador do Fornecedor
            If vCursor.Tipo IN ('CAR') Then
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00003'; -- Obrigatório(S) - Agrupamento de Parceiro (fixo 00001)
               If vCursor.Tipo2 = 'C' Then
                  tpVENDOR_S_SUPPL_GEN.BPKIND := 'Z002'; -- Terceiros/Dedicado
               ElsIf vCursor.Tipo2 = 'A' Then
                  tpVENDOR_S_SUPPL_GEN.BPKIND := 'Z004'; -- Agregado
               Else
                  tpVENDOR_S_SUPPL_GEN.BPKIND := ' ';
               end If;
            ElsIf vCursor.Tipo IN ('FOR','BGM') Then
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00004'; -- Obrigatório(S) - Agrupamento de Parceiro (fixo 00001)
               tpVENDOR_S_SUPPL_GEN.BPKIND := ' ';
            ElsIf vCursor.Tipo IN ('FPW') Then
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00005'; -- Obrigatório(S) - Agrupamento de Parceiro (fixo 00001)
               tpVENDOR_S_SUPPL_GEN.BPKIND        := 'Z003'; -- Frota
            Else
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := ' '; 
               tpVENDOR_S_SUPPL_GEN.BPKIND        := ' '; 
            End If;    
            tpVENDOR_S_SUPPL_GEN.Natpers       := vCursor.pessoaFJ;
            tpVENDOR_S_SUPPL_GEN.NAME_FIRST    := SUBSTR(vCursor.TAB_RAZAOSOCIAL, 1, 35); -- Obrigatório(N) - Nome
            tpVENDOR_S_SUPPL_GEN.NAME_LAST     := NVL(SUBSTR(vCursor.TAB_RAZAOSOCIAL, 36),' '); -- Obrigatório(N) - Nome 2 
            tpVENDOR_S_SUPPL_GEN.NAME3         := vCursor.TAB_CPF_CNPJ; -- Obrigatório(N) - Nome 3
            tpVENDOR_S_SUPPL_GEN.NAME4         := vCursor.tipo_endereco ||'|'||vCursor.tab_codcliente||'|'||vCursor.glb_portaria_id || '|' || vCursor.Tipo; -- Obrigatório(N) - Nome 4
            tpVENDOR_S_SUPPL_GEN.SORTL         := NVL(trim(vCursor.TAB_CPF_CNPJ), '0'); -- Obrigatório(N) - Termo de Pesquisa 1
            tpVENDOR_S_SUPPL_GEN.MCOD2         := SUBSTR(trim(vCursor.TAB_RAZAOSOCIAL), 1, 20); -- Obrigatório(N) - Termo de Pesquisa 2
            tpVENDOR_S_SUPPL_GEN.Cfopc         := vCursor.cfopSap;
            tpVENDOR_S_SUPPL_GEN.FOUND_DAT     := ' '; -- Obrigatório(N) - Data da fundação
            tpVENDOR_S_SUPPL_GEN.LIQUID_DAT    := ' '; -- Obrigatório(N) - Data de liquidação
            tpVENDOR_S_SUPPL_GEN.MIN_COMP      := ' '; -- Obrigatório(N) - Indicador de micro empresa
            tpVENDOR_S_SUPPL_GEN.COMSIZE       := ' '; -- Obrigatório(N) - Tamanho da empresa
            tpVENDOR_S_SUPPL_GEN.DECREGPC      := ' '; -- Obrigatório(N) - Regime de Declaração para PIS / COFINS
            tpVENDOR_S_SUPPL_GEN.CNAE          := ' '; -- Obrigatório(N) - CNAE
            tpVENDOR_S_SUPPL_GEN.CRTN          := vCursor.CRTN; -- Obrigatório(N) - Número CRT
            tpVENDOR_S_SUPPL_GEN.ICMSTAXPAY    := ' '; -- Obrigatório(N) - Contribuinte do ICMS
            tpVENDOR_S_SUPPL_GEN.STREET        := NVL(substr(vCursor.LIMPO_LOGRADOURO,1,60), ' '); -- Obrigatório(N) - Nome do logradouro do endereço do fornecedor
            tpVENDOR_S_SUPPL_GEN.HOUSE_NUM1    := NVL(substr(vCursor.LIMPO_NUMERO,1,10), ' ');  -- Obrigatório(N) - Número do endereço do fornecedor
            tpVENDOR_S_SUPPL_GEN.CITY2         := substr(NVL(vCursor.BAIRRO, ' '),1,40); -- Obrigatório(N) - Bairro do endereço do fornecedor
            if vCursor.CEP_ENDERECO is not null Then
               If trim(nvl(vCursor.TAB_CEP,'-')) <> '-' Then
                  tpCUSTOMER_S_CUST_GEN.POST_CODE1 := trim(vCursor.TAB_CEP); -- **verificar 00000 NAO MANDAR NADA/* Obrigatório(N) - CEP do endereço principal */
               Else
                  tpVENDOR_S_SUPPL_GEN.POST_CODE1 := '02174-010';   
               End If;
            Else
               tpVENDOR_S_SUPPL_GEN.POST_CODE1 := '02174-010';   
            End If;
            If tpVENDOR_S_SUPPL_GEN.POST_CODE1 = '02174-010' Then
               tpVENDOR_S_SUPPL_GEN.CITY1         := 'SAO PAULO'; /* Obrigatório(N) - Cidade do endereço principal */
               tpVENDOR_S_SUPPL_GEN.COUNTRY       := 'BR'; /* Obrigatório(S) - País do endereço principal */
               tpVENDOR_S_SUPPL_GEN.REGION        := 'SP'; /* Obrigatório(N) - Estado/UF do endereço principal */ 
               tpVENDOR_S_SUPPL_GEN.STR_SUPPL1    := 'SP'; -- /* Obrigatório(N) - Segundo campo de logradouro do endereço principal do cliente */
               tpVENDOR_S_SUPPL_GEN.HOUSE_NO2     := ' '; /* Obrigatório(N) - Complemento do Endereço principal do cliente */
            Else
               tpVENDOR_S_SUPPL_GEN.CITY1         := NVL(TRIM(substr(vCursor.TAB_CIDADE,1,40)), ' '); -- Obrigatório(N) - Cidade do endereço do fornecedor
               tpVENDOR_S_SUPPL_GEN.COUNTRY       := NVL(vCursor.SIGLA_SAP, ' '); -- Obrigatório(S) - País* do endereço do fornecedor
               tpVENDOR_S_SUPPL_GEN.REGION        := NVL(substr(vCursor.TAB_ESTADO,1,80), ' '); -- Obrigatório(N) - Estado/UF do endereço do fornecedor 
               tpVENDOR_S_SUPPL_GEN.STR_SUPPL1    := NVL(vCursor.ESTADO,tpVENDOR_S_SUPPL_GEN.REGION); -- Obrigatório(N) - Segundo campo de logradouro do endereço do fornecedor
               tpVENDOR_S_SUPPL_GEN.HOUSE_NO2     := NVL(SUBSTR(vCursor.LIMPO_COMPLEMENTO,1, 10), ' '); -- Obrigatório(N) - Complemento do endereço do fornecedor
            End If;
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL2    := ' '; -- Obrigatório(N) - Terceiro campo de logradouro do endereço do fornecedor
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL3    := ' '; -- Obrigatório(N) - Logradouro 4
            tpVENDOR_S_SUPPL_GEN.LOCATION      := ' '; -- Obrigatório(N) - Logradouro 5
            tpVENDOR_S_SUPPL_GEN.PO_BOX        := ' '; -- Obrigatório(N) - Caixa postal
            tpVENDOR_S_SUPPL_GEN.PO_BOX_CIT    := ' '; -- Obrigatório(N) - Cidade da Caixa postal
            tpVENDOR_S_SUPPL_GEN.POBOX_CTRY    := ' '; -- Obrigatório(N) - País da caixa postal
            tpVENDOR_S_SUPPL_GEN.PO_BOX_REG    := ' '; -- Obrigatório(N) - Estado/UF da caixa postal
            tpVENDOR_S_SUPPL_GEN.LANGU_CORR    := 'PT'; -- Obrigatório(N) - Idioma
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG    := ' '; -- Obrigatório(N) - Telefone padrão
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG_2  := ' '; -- Obrigatório(N) - Telefone Adicional 2
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG_3  := ' '; -- Obrigatório(N) - Telefone Adicional 3
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG   := ' '; -- Obrigatório(N) - Celular padrão
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG_2 := ' '; -- Obrigatório(N) - Celular adicional 2
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG_3 := ' '; -- Obrigatório(N) - Celular adicional 3
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG    := ' '; -- Obrigatório(N) - Fax padrão
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG_2  := ' '; -- Obrigatório(N) - Fax adicional 2
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG_3  := ' '; -- Obrigatório(N) - Fax adicional 3
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR     := ' '; -- Obrigatório(N) - E-mail padrão
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR_2   := ' '; -- Obrigatório(N) - E-mail adicional 2
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR_3   := ' '; -- Obrigatório(N) - E-mail adicional 3
            tpVENDOR_S_SUPPL_GEN.SPERR         := ' '; -- Obrigatório(N) - Bloqueio de Postagem - Central
            Begin
               tpVENDOR_S_SUPPL_GEN.RG := nvl(vCursor.Rg,' ');
            exception
              When OTHERS Then
                 tpVENDOR_S_SUPPL_GEN.RG := ' ';
              End;

            If tpVENDOR_S_SUPPL_GEN.Street = ' ' Then
               tpVENDOR_S_SUPPL_GEN.house_num1 := ' ';
               tpVENDOR_S_SUPPL_GEN.house_no2  := ' ';
            End If;  

            If vCursor.nacional = 'I' Then
               If tpVENDOR_S_SUPPL_GEN.country = vPais Then
                  tpVENDOR_S_SUPPL_GEN.country := ' ';
               End If;
               tpVENDOR_S_SUPPL_GEN.region     := 'EX';
               tpVENDOR_S_SUPPL_GEN.Street     := 'Internacional';
               tpVENDOR_S_SUPPL_GEN.house_num1 := '9';
               tpVENDOR_S_SUPPL_GEN.house_no2  := '9';
               tpVENDOR_S_SUPPL_GEN.SORTL      := ' ';
            End If;  

            If tpVENDOR_S_SUPPL_GEN.COUNTRY =  ' ' Then
               tpVENDOR_S_SUPPL_GEN.COUNTRY := tpVENDOR_S_SUPPL_GEN.COUNTRY;
            End If;

            INSERT INTO MIGDV.VENDOR_S_SUPPL_GEN VALUES tpVENDOR_S_SUPPL_GEN;
            i := i + 1; 
            commit;
        End If;


        SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO(tpVENDOR_S_SUPPL_GEN.Lifnr,
                                                vCursor.Tipo,
                                                vCursor.pessoaFJ,
                                                PRESULTADO,
                                                PMENSAGEM);
                                                

        PRESULTADO := 'N';
        PMENSAGEM  := 'Cliente inserido com sucesso';
        
        vCliRed.ChaveSap := vIdentificadorCli;
       
        vPosicao := 'ROLES - ' || vCliRed.ChaveSap || '-' || vCursor.Tipo  ;
        SP_SAP_INSERE_ROLES(vCliRed,'TODAS', PRESULTADO, PMENSAGEM); 
        vPosicao := 'SP_SAP_INSERE_TAXNUMBERS - ' || vCliRed.ChaveSap  || '-' || vCursor.Tipo  ;
        SP_SAP_INSERE_TAXNUMBERS(vCliRed,'TODOS',PRESULTADO, PMENSAGEM);
        vPosicao := 'SP_SAP_INSERECONTATO - ' || vCliRed.ChaveSap  || '-' || vCursor.Tipo  ;
        SP_SAP_INSERECONTATO(vCliRed,PRESULTADO, PMENSAGEM);
        vPosicao := 'SP_SAP_INSEREDOCUMENTO - ' || vCliRed.ChaveSap  || '-' || vCursor.Tipo  ;
        Begin
           SP_SAP_INSEREDOCUMENTO(vCliRed,PRESULTADO, PMENSAGEM);
        Exception
          When OTHERS Then
            vErro := sqlerrm;
            rollback;

            insert into tdvadm.t_glb_sql values (vErro,
                                                 sysdate,
                                                 'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                 vPosicao);
                commit;
--            dbms_output.put_line(vPosicao);
--            dbms_output.put_line(sqlerrm);
          End;
       If vCursor.Tipo IN ('CLI','PRO') Then
          FOR vCursorEndAdicional IN (                                        
             SELECT DISTINCT
                    C.GLB_CLIEND_CIDADE TAB_CIDADE,
                    C.GLB_ESTADO_CODIGO TAB_ESTADO,
                    C.GLB_PAIS_CODIGO TAB_PAIS,
                    substr(lpad(trim(C.GLB_CEP_CODIGO),8,'0'),1,5) || '-' || substr(lpad(trim(C.GLB_CEP_CODIGO),8,'0'),-3,3) TAB_CEP,
                    C.GLB_CLIEND_ENDERECO TAB_ENDERECO,
                    C.GLB_CLIENTE_CGCCPFCODIGO TAB_CPF_CNPJ,
--                    C.GLB_CLIEND_CODCLIENTE,
                    CLI.GLB_CLIENTE_RAZAOSOCIAL TAB_RAZAOSOCIAL,
                    CLI.GLB_GRUPOECONOMICO_CODIGO TAB_GRUPOECONOMICO,
                 
/*                    (SELECT COUNT(DISTINCT CO.CON_CONHECIMENTO_CODIGO ||
                                 CO.GLB_ROTA_CODIGO)
                      FROM TDVADM.T_CON_CONHECIMENTO CO
                     WHERE (CO.GLB_CLIENTE_CGCCPFREMETENTE = C.GLB_CLIENTE_CGCCPFCODIGO AND
                           CO.GLB_TPCLIEND_CODIGOREMETENTE = C.GLB_TPCLIEND_CODIGO)
                        OR (CO.GLB_CLIENTE_CGCCPFDESTINATARIO = C.GLB_CLIENTE_CGCCPFCODIGO AND
                           CO.GLB_TPCLIEND_CODIGODESTINATARI = C.GLB_TPCLIEND_CODIGO)) QTE_CTE,
*/                              
                    (SELECT P.T_CEP_CEPLOG_UF || '-' || P.T_CEP_CEPLOG_TIPO || ' ' || P.T_CEP_CEPLOG_NOME_OFICIAL
                     FROM TDVADM.t_cep_ceplog P
                     WHERE P.T_CEP_CEPLOG_CEP = TRIM(C.GLB_CEP_CODIGO)) CEP_ENDERECO,
                 
                    CLI.GLB_CLIENTE_VLTOTVENC VALOR_VENCIDO,
                 
                    TDVADM.PKG_GLB_COMMON .fn_get_logradouro_endereco(c.GLB_CLIEND_ENDERECO) LIMPO_LOGRADOURO,
                    TDVADM.PKG_GLB_COMMON.fn_get_numero_endereco(c.GLB_CLIEND_ENDERECO) LIMPO_NUMERO,
                    TDVADM.PKG_GLB_COMMON.fn_get_complemento_endereco(c.GLB_CLIEND_ENDERECO) LIMPO_COMPLEMENTO,
                    C.GLB_CLIEND_COMPLEMENTO BAIRRO,
                    CLI.GLB_BANCO_NUMERO BANCO_NUMERO,
--                    C.ROWID,
                    P.GLB_PAIS_SIGLASAP SIGLA_SAP,
                    L.GLB_ESTADO_CODIGO ESTADO,
                    CLI.GLB_CLIENTE_CGCCPFCODIGO
             FROM TDVADM.T_GLB_CLIEND C, 
                  TDVADM.T_GLB_CLIENTE CLI, 
                  TDVADM.T_GLB_PAIS P,
                  TDVADM.T_GLB_LOCALIDADE L
                   /*  Sirlano
                       02/09/2020 colocado para nao trazer os endereços 
                       sera 1 BP para cada ENDERECO 
                   */
             WHERE c.glb_cliente_cgccpfcodigo = 'X' -- Colocado para nao trazer enderços adicionais
               and C.GLB_CLIENTE_CGCCPFCODIGO = vCursor.Tab_Cpf_Cnpj
               and C.GLB_CLIENTE_CGCCPFCODIGO = CLI.GLB_CLIENTE_CGCCPFCODIGO 
               AND C.GLB_TPCLIEND_CODIGO <> PTIPO_ENDERECO
               AND C.GLB_LOCALIDADE_CODIGO = L.GLB_LOCALIDADE_CODIGO 
               AND C.GLB_PAIS_CODIGO = P.GLB_PAIS_CODIGO
               AND P.GLB_PAIS_SIGLASAP  IS NOT NULL
               and length(trim(nvl(TDVADM.PKG_GLB_COMMON .fn_get_logradouro_endereco(c.GLB_CLIEND_ENDERECO),' '))) > 3
           )
           LOOP
               vCliente := vCursor.Tab_Cpf_Cnpj;
               -- verificar endereco
               tpEndAdicional.KUNNR      := TRIM(TO_CHAR(vIdentificadorCli));
               tpEndAdicional.STREET     := vCursorEndAdicional.LIMPO_LOGRADOURO;
               tpEndAdicional.COUNTRY    := vCursorEndAdicional.Sigla_Sap;
               tpEndAdicional.HOUSE_NUM1 := nvl(trim(vCursorEndAdicional.Limpo_Numero), ' ');
               tpEndAdicional.HOUSE_NO2  := nvl(substr( trim(vCursorEndAdicional.Limpo_Complemento), 1, 10 ), ' ');
               tpEndAdicional.CITY2      := substr(nvl(vCursorEndAdicional.BAIRRO, ' '),1,40);
               If vCursorEndAdicional.CEP_ENDERECO is not null Then
                  If trim(nvl(vCursorEndAdicional.TAB_CEP,',')) <> '-' Then
                     tpEndAdicional.POST_CODE1 := trim(vCursorEndAdicional.TAB_CEP);
                  Else
                     tpEndAdicional.POST_CODE1 := ' ';
                  End If;
                  tpEndAdicional.POST_CODE1 := ' ';
               End If;  
               
               tpEndAdicional.REGION     := vCursorEndAdicional.ESTADO;
               
               vPosicao := 'SP_SAP_INSERE_CLIENTE_ENDERECO_ADICIONAL - ' || tpCUSTOMER_S_CUST_GEN.SORTL ;
               Begin
                  select count(*)
                     into vCount
                  from migdv.CUSTOMER_S_CUST_GEN cg
                  where cg.street = tpEndAdicional.street
                    and cg.house_num1 = tpEndAdicional.house_num1
                    and cg.kunnr = tpEndAdicional.KUNNR;
                  If vCount = 0 Then
                     select count(*)
                        into vCount
                     from MIGDV.CUSTOMER_S_ADDRESS cg
                     where cg.street = tpEndAdicional.street
                       and cg.house_num1 = tpEndAdicional.house_num1
                       and cg.kunnr = tpEndAdicional.KUNNR;
                     
                     If  vCount = 0  Then 

                        If tpEndAdicional.Street = ' ' Then
                           tpEndAdicional.house_num1 := ' ';
                           tpEndAdicional.house_no2  := ' ';
                        End If;   

                        If tpEndAdicional.country <> vPais Then
                           tpEndAdicional.region     := 'EX';
                           tpEndAdicional.Street     := 'Internacional';
                           tpEndAdicional.house_num1 := '9';
                           tpEndAdicional.house_no2  := '9';
                        End If; 
                        
                        If ( length(trim(nvl(tpEndAdicional.street,' '))) <> 0 ) is not null Then
                           SP_SAP_INSERE_CLIENTE_ENDERECO_ADICIONAL(vIdentificadorCli, tpEndAdicional, PRESULTADO, PMENSAGEM);
                           commit;
                        End If;
                        
                     End IF;
                  End If;
               exception
                 When Others Then
                    vPosicao := vPosicao || ' Nem Rodou';
                End;   
           END LOOP;     
-- Conforme conversado com Ana em 27/05/2020 não sera mais preenchido
--           vPosicao := 'SP_SAP_INSERE_BANK_DATA - ' || tpCUSTOMER_S_CUST_GEN.SORTL ;
--           SP_SAP_INSERE_BANK_DATA(vIdentificadorCli, vCursor.GLB_CLIENTE_CGCCPFCODIGO, PRESULTADO, PMENSAGEM);
           vPosicao := 'SP_SAP_INSEREDADOSFINANCEIROS - ' || tpCUSTOMER_S_CUST_GEN.SORTL ;
           SP_SAP_INSEREDADOSFINANCEIROS(vIdentificadorCli, vCursor.TAB_CPF_CNPJ, PRESULTADO, PMENSAGEM);
           commit;
        End If;
     exception
       When others Then
        vErro := sqlerrm;
        rollback;
        insert into tdvadm.t_glb_sql values (vErro,
                                             sysdate,
                                             'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                             vPosicao);
                commit;
--         dbms_output.put_line(vPosicao);
--         dbms_output.put_line(sqlerrm);
       end;
     If mod(i,pQtdecommit) = 0 Then
        commit;
     End If; 


   END LOOP;
   COMMIT;

   
    PRESULTADO := '';
    PMENSAGEM  := ' ' || sqlerrm;       
exception
  When Others Then
      vErro := sqlerrm;
      rollback;
      insert into tdvadm.t_glb_sql values (vErro,
                                           sysdate,
                                           'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                           vPosicao);
                commit;
--    dbms_output.put_line(vPosicao);
--    dbms_output.put_line(sqlerrm);
end SP_SAP_INSERECLIENTE;



procedure SP_SAP_INSEREDADOSFINANCEIROS(PIDCLIENTE IN VARCHAR2,
                                        PDOCUMENTO IN CHAR,
                                        PRESULTADO OUT Char,
                                        PMENSAGEM OUT VARCHAR2) is
                                        
tpCUSTOMER_S_CUST_COMPANY MIGDV.CUSTOMER_S_CUST_COMPANY%ROWTYPE;         
vTelefone TDVADM.T_GLB_CLICONT.GLB_CLICONT_FONE%TYPE;
vFax      TDVADM.T_GLB_CLICONT.GLB_CLICONT_FAX%TYPE;   
vCount number;                   
begin  
  /*  
    FOR vCursor IN (                                        
      SELECT 
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
       */   
       
     SELECT Count(*)
      INTO vCount
     FROM TDVADM.T_GLB_CLICONT C
     WHERE C.GLB_CLIENTE_CGCCPFCODIGO = PDOCUMENTO
       and length(trim(c.glb_cliente_cgccpfcodigo)) <> 11;
        
     vCount := NVL(vCount, 0);
          
     IF (NVL(PIDCLIENTE, 'X') <> 'X') AND (vCount <> 0) THEN
        SELECT C.GLB_CLICONT_FONE,
               C.GLB_CLICONT_FAX
        INTO vTelefone,
             vFax
        FROM TDVADM.T_GLB_CLICONT C
        WHERE C.GLB_CLIENTE_CGCCPFCODIGO = PDOCUMENTO
        -- Verificar com Sirlano quais tipos de contatos vamos colocar
          AND ROWNUM =1;        
        
        tpCUSTOMER_S_CUST_COMPANY.KUNNR    := PIDCLIENTE; --Obrigatório(S) - Identificador do cliente*
        tpCUSTOMER_S_CUST_COMPANY.BUKRS    := vCodigoEmpresa; --Obrigatório(S) - Código da companhia*
        tpCUSTOMER_S_CUST_COMPANY.SPERR    := ' '; --Obrigatório(N) - Bloqueio de Postagem
        tpCUSTOMER_S_CUST_COMPANY.ZAHLS    := 'N'; --Obrigatório(N) - Bloqueio de pagamento
        tpCUSTOMER_S_CUST_COMPANY.MAHNA    := ' '; --Obrigatório(N) - Procedimento de advertência
        tpCUSTOMER_S_CUST_COMPANY.MANSP    := ' '; --Obrigatório(N) - Bloqueio de advertência
        tpCUSTOMER_S_CUST_COMPANY.KNRMA    := ' '; --Obrigatório(N) - Destinatário de advertência
        tpCUSTOMER_S_CUST_COMPANY.MADAT    := ' '; --Obrigatório(N) - Último aviso de cobrança
        tpCUSTOMER_S_CUST_COMPANY.GMVDT    := ' '; --Obrigatório(N) - Data dos procedimentos legais de cobrança
        tpCUSTOMER_S_CUST_COMPANY.MAHNS    := '0'; --Obrigatório(N) - Nível de advertência
        tpCUSTOMER_S_CUST_COMPANY.TLFNS    := NVL(SUBSTR(vTelefone,1,30), ' '); --Obrigatório(N) - telefone 
        tpCUSTOMER_S_CUST_COMPANY.TLFXS    := NVL(SUBSTR(vFax,1,30), ' '); --Obrigatório(N) - Fax
        tpCUSTOMER_S_CUST_COMPANY.ZTERM    := 'A Vista'; --Obrigatório(N) - Termos de pagamento
        -- ZWELS_NN
        -- Z ¿ DARF
        -- B ¿ Boleto Fornecedor
        -- O ¿ Tributos e Concessionaria
        -- C- Cheque
        -- X ¿ Caixa Filial Fundo Fixo
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_01 := 'D'; -- D ¿ Boleto Cliente
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_02 := 'U'; -- U-Transferencia
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_03 := '0'; -- 0 ¿ Carteira Della Volpe
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_04 := ' '; --Obrigatório(N) - Forma de Pagamento 4
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_05 := ' '; --Obrigatório(N) - Forma de Pagamento 5
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_06 := ' '; --Obrigatório(N) - Forma de Pagamento 6
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_07 := ' '; --Obrigatório(N) - Forma de Pagamento 7
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_08 := ' '; --Obrigatório(N) - Forma de Pagamento 8
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_09 := ' '; --Obrigatório(N) - Forma de Pagamento 9
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_10 := ' '; --Obrigatório(N) - Forma de Pagamento 10
        tpCUSTOMER_S_CUST_COMPANY.AKONT    := '11201001'; --Obrigatório(S) - Conta de reconciliação*
        Begin                        
           INSERT INTO MIGDV.CUSTOMER_S_CUST_COMPANY VALUES tpCUSTOMER_S_CUST_COMPANY;
        exception
           When others then
            
             vErro := sqlerrm;
             rollback;
             insert into tdvadm.t_glb_sql values (vErro,
                                                  sysdate,
                                                  'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                  'SP_SAP_INSEREDADOSFINANCEIROS - Cliente - ' || PIDCLIENTE );
                commit;
        End;
          
        PRESULTADO := 'N';
        PMENSAGEM  := 'Dados financeiros inserido com sucesso.';
        
     END IF;     
   /*    
   END LOOP;
  */ 
      

end SP_SAP_INSEREDADOSFINANCEIROS;

procedure SP_SAP_INSERE_ROLES(PTpClient IN TpCliRed,
                              PTIPO_ROLE IN CHAR,
                              PRESULTADO OUT Char,
                              PMENSAGEM OUT VARCHAR2) is

 tpCUSTOMER_S_ROLES MIGDV.CUSTOMER_S_ROLES%ROWTYPE;                                        
 tpVEND_EXT_S_ROLES MIGDV.VEND_EXT_S_ROLES%ROWTYPE;                                        
 tpVENDOR_S_ROLES MIGDV.VENDOR_S_ROLES%ROWTYPE; 
             

 ir integer;
 vTipo_Role varchar2(50);
 vChaveSap MIGDV.CUSTOMER_S_CUST_TAXNUMBERS.KUNNR%type;
begin
  ir := 1;
  vChaveSap := PTpClient.ChaveSap;
  loop
 
    -- Se nao Foi passado um tipo especifico de ROLE
     If nvl(PTIPO_ROLE,'TODAS') = 'TODAS' Then
        If ir = 1 Then
           If PTpClient.Tipo IN ('CLI','PRO','CAR','FOR','BGM','FPW') Then
              vTipo_Role := 'CL'; -- cliente 
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 2 Then
           If PTpClient.Tipo IN ('CLI','PRO','CAR','FOR','BGM','FPW') Then
              vTipo_Role := 'COL_MAN'; -- Gerenciamento de cobrancas 
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 3 Then
           If PTpClient.Tipo IN ('CLI','PRO','CAR','FPW') Then
              vTipo_Role := 'CL_CTB'; -- Contabilidade Financeira
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 4 Then 
           If PTpClient.Tipo IN ('FOR','BGM') Then
              vTipo_Role := 'FN'; -- Fornecedor
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 5 Then  
           If PTpClient.Tipo IN ('FOR','BGM') Then
              vTipo_Role := 'FN_CTB'; -- Contabilidade Financeira
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 6 Then
           If PTpClient.Tipo IN ('FOR','BGM') Then
              vTipo_Role := 'FLVN01'; -- Fornec. Complemento
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 7 Then
           If PTpClient.Tipo IN ('CAR','FPW') Then
              vTipo_Role := 'MTRST'; -- Motorista
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 8 Then
           If PTpClient.Tipo IN ('FOR','BGM') Then
              vTipo_Role := 'BBP006'; -- Emissor de Fatura
           Else
              vTipo_Role := 'X';
           End If;
        ElsIf ir = 9 Then
           If PTpClient.Tipo IN ('FOR','BGM') Then
              vTipo_Role := 'CRM004'; -- Recebedor de Fatura
           Else
              vTipo_Role := 'X';
           End If;
--        ElsIf ir = 10 
--           If PTpClient.Tipo IN ('CLI','PRO','CAR','FOR','BGM','FPW') Then
--              vTipo_Role := 'CRM010'; -- Transportadora
--           Else
--              vTipo_Role := '';
--           End If;
        End If;
      Else -- Se passou um tipo especifico usa
         vTipo_Role := PTIPO_ROLE;
         ir := 10;
      End If;  
      
      If vTipo_Role <> 'X' Then   
         If PTpClient.Tipo IN ('CLI','PRO') Then 
            tpCUSTOMER_S_ROLES.KUNNR   := vChaveSap;
            tpCUSTOMER_S_ROLES.BP_ROLE := vTipo_Role;  
            INSERT INTO MIGDV.CUSTOMER_S_ROLES VALUES tpCUSTOMER_S_ROLES;
            If PTpClient.Tipo IN ('PRO') Then
               tpVEND_EXT_S_ROLES.LIFNR := vChaveSap;
               tpVEND_EXT_S_ROLES.BP_ROLE := vTipo_Role;
               insert into MIGDV.VEND_EXT_S_ROLES values tpVEND_EXT_S_ROLES;
            End If;
         ElsIf PTpClient.Tipo IN ('CAR','FOR','BGM','FPW') Then
            tpVENDOR_S_ROLES.LIFNR   := vChaveSap;
            tpVENDOR_S_ROLES.BP_ROLE := vTipo_Role;
            INSERT INTO MIGDV.VENDOR_S_ROLES VALUES tpVENDOR_S_ROLES;
         End If;
      End If;   
      exit when ir = 10;
      ir := ir + 1;
   end loop;

   PRESULTADO := 'N';
   PMENSAGEM  := 'Roles inserida com sucesso';
 exception
    When others then
       vErro := sqlerrm;
       rollback;
       insert into tdvadm.t_glb_sql values (vErro,
                                            sysdate,
                                            'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                            'SP_SAP_INSERE_ROLES - Tipo ' || PTpClient.Tipo || ' - Cliente - ' || vChaveSap || ' - Tipo Role ' || vTipo_Role);
                commit;

end SP_SAP_INSERE_ROLES;


procedure SP_SAP_INSERE_TAXNUMBERS(PTpClient in TpCliRed,
                                   PTIPO      in CHAR DEFAULT 'TODOS',
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2) is
   vCount Integer;
   i      Integer;
   tpCUSTOMER_S_CUST_TAXNUMBERS  MIGDV.CUSTOMER_S_CUST_TAXNUMBERS%ROWTYPE; 
   tpVENDOR_S_Suppl_Taxnumbers   migdv.vendor_s_suppl_taxnumbers%Rowtype;
   tpvend_ext_s_suppl_taxnumbers migdv.vend_ext_s_suppl_taxnumbers%RowType;
   vChaveSap MIGDV.CUSTOMER_S_CUST_TAXNUMBERS.KUNNR%type;
   vTAXNUM   MIGDV.CUSTOMER_S_CUST_TAXNUMBERS.TAXNUM%type;
   vTAXTYPE  MIGDV.CUSTOMER_S_CUST_TAXNUMBERS.TAXTYPE%type;
   vTIPO   varchar2(20);
begin



  PRESULTADO := 'N';
  PMENSAGEM  := ''; 

  vChaveSap := PTpClient.ChaveSap;

  If PTIPO in ('TODOS','CNPJCPF') Then 
     i := 1;
  ElsIf PTIPO in ('IE') Then
     i := 2;
  ElsIf PTIPO in ('IM') Then
     i := 3;
  End If;

  Loop
     If i = 1 Then
        vTipo := 'CNPJCPF';
     Elsif i = 2 Then
        vTipo := 'IE';
     Elsif i = 3 Then
        vTipo := 'IM';
     End If;
     vChaveSap := PTpClient.ChaveSap;
     If vTipo in ('TODOS','CNPJCPF') Then
        If LENGTH(trim(PTpClient.CPFCNPJ)) = 11 Then
           vTAXTYPE := 'CPF';
        Else
           vTAXTYPE := 'CNPJ';
        End If;
        vTAXNUM := trim(PTpClient.CPFCNPJ);
     ElsIf ( vTipo in ('TODOS','IE') ) and ( LENGTH(trim(PTpClient.CPFCNPJ)) <> 11 ) Then
        vTAXTYPE := 'IE';
        vTAXNUM := upper(trim(PTpClient.IE));
        -- Valida se o IE esta bom

--        If LENGTH(TRIM(vTAXNUM)) > 3 AND 
--           substr(TRIM(vTAXNUM),1,3) <> '000' 
           
--        End If;
     ElsIf ( vTipo in ('TODOS','IM') ) and ( LENGTH(trim(PTpClient.CPFCNPJ)) <> 11 )  Then
        vTAXTYPE := 'IM';
        vTAXNUM := trim(PTpClient.IM);
        -- Valida se o IM esta bom 
--        iF tdvadm.f_enumerico(TRIM(vCursor.IM)) = 'S' Then
          
--        End If;
        
     End If;

     If PTpClient.Tipo in ('CLI','PRO') Then

        SELECT COUNT(*)
          INTO vCount
        FROM MIGDV.CUSTOMER_S_CUST_TAXNUMBERS
        WHERE KUNNR = vChaveSap
          and TAXTYPE = vTAXTYPE;
         
        If vCount = 0 Then
           tpCUSTOMER_S_CUST_TAXNUMBERS.KUNNR   := vChaveSap; -- Obrigatório(S) - Identificador do Cliente
           tpCUSTOMER_S_CUST_TAXNUMBERS.TAXTYPE := vTAXTYPE;  -- Obrigatório(S) - Tipo do documento do cliente (CPF, CNPJ, RG, RNE, IM, IE)
           tpCUSTOMER_S_CUST_TAXNUMBERS.TAXNUM  := vTAXNUM;   -- Obrigatório(S) - Número do documento

           If length(nvl(trim(vTAXNUM),'.')) > 5   and 
              instr(vTAXNUM,'111111') = 0          and   
              instr(vTAXNUM,'222222') = 0          and   
              instr(vTAXNUM,'333333') = 0          and   
              instr(vTAXNUM,'444444') = 0          and   
              instr(vTAXNUM,'123456') = 0          and   
              instr(vTAXNUM,'654321') = 0          Then  
              if ( vTAXNUM = 'ISENTO' ) Then
                 vTAXNUM := 'ISENTO';
              End If;   
              If ( vTAXNUM = 'ISENTO' ) or  ( tdvadm.f_enumerico(vTAXNUM) = 'S' and to_number(nvl(trim(vTAXNUM),0)) <> 0 ) Then
                 INSERT INTO MIGDV.CUSTOMER_S_CUST_TAXNUMBERS VALUES tpCUSTOMER_S_CUST_TAXNUMBERS;
              End If;
           End If;
        End If;
         
     ElsIf PTpClient.Tipo in ('CAR','FOR','BGM','FPW') Then
        SELECT COUNT(*)
           INTO vCount
        FROM MIGDV.VENDOR_S_Suppl_Taxnumbers
        WHERE lifnr  = vChaveSap
          and TAXTYPE = vTAXTYPE;
                    
        IF vCount = 0 Then
           
           tpVENDOR_S_Suppl_Taxnumbers.lifnr   := vChaveSap; -- Obrigatório(S) - Identificador do Cliente
           tpVENDOR_S_Suppl_Taxnumbers.TAXTYPE := vTAXTYPE;  -- Obrigatório(S) - Tipo do documento do cliente (CPF, CNPJ, RG, RNE, IM, IE)
           tpVENDOR_S_Suppl_Taxnumbers.TAXNUM  := vTAXNUM;   -- Obrigatório(S) - Número do documento

           If length(nvl(trim(vTAXNUM),'.')) > 5   and 
              instr(vTAXNUM,'111111') = 0          and   
              instr(vTAXNUM,'222222') = 0          and   
              instr(vTAXNUM,'333333') = 0          and   
              instr(vTAXNUM,'444444') = 0          and   
              instr(vTAXNUM,'123456') = 0          and   
              instr(vTAXNUM,'654321') = 0          Then  
              if ( vTAXNUM = 'ISENTO' ) Then
                 vTAXNUM := 'ISENTO';
              End If;   
              If ( vTAXNUM = 'ISENTO' ) or  ( tdvadm.f_enumerico(vTAXNUM) = 'S' and to_number(nvl(trim(vTAXNUM),0)) <> 0 ) Then
                 INSERT INTO MIGDV.VENDOR_S_Suppl_Taxnumbers VALUES tpVENDOR_S_Suppl_Taxnumbers;
              End If;
           End If;
        End If;
     ElsIf PTpClient.Tipo in ('???') Then
        SELECT COUNT(*)
           INTO vCount
        FROM MIGDV.Vend_Ext_s_Suppl_Taxnumbers x
        WHERE lifnr  = vChaveSap
          and TAXTYPE = vTAXTYPE;
                    
        IF vCount = 0 Then
           tpvend_ext_s_suppl_taxnumbers.lifnr   := vChaveSap; -- Obrigatório(S) - Identificador do Cliente
           tpvend_ext_s_suppl_taxnumbers.TAXTYPE := vTAXTYPE;  -- Obrigatório(S) - Tipo do documento do cliente (CPF, CNPJ, RG, RNE, IM, IE)
           tpvend_ext_s_suppl_taxnumbers.TAXNUM  := vTAXNUM;   -- Obrigatório(S) - Número do documento

           If length(nvl(trim(vTAXNUM),'.')) > 5   and 
              instr(vTAXNUM,'111111') = 0          and   
              instr(vTAXNUM,'222222') = 0          and   
              instr(vTAXNUM,'333333') = 0          and   
              instr(vTAXNUM,'444444') = 0          and   
              instr(vTAXNUM,'123456') = 0          and   
              instr(vTAXNUM,'654321') = 0          Then  
              if ( vTAXNUM = 'ISENTO' ) Then
                 vTAXNUM := 'ISENTO';
              End If;   
              If ( vTAXNUM = 'ISENTO' ) or  ( tdvadm.f_enumerico(vTAXNUM) = 'S' and to_number(nvl(trim(vTAXNUM),0)) <> 0 ) Then
                 INSERT INTO MIGDV.vend_ext_s_suppl_taxnumbers VALUES tpVENDOR_S_Suppl_Taxnumbers;
              End If; 
           End If;
        End If; 

     End IF;  

     If PTIPO <> 'TODOS' Then
        i := 3;
     End If;

     exit when i = 3;
     
     i := i + 1;
     
  end loop;

  PRESULTADO := 'N';
  PMENSAGEM  := 'Registro inserido com sucesso.';
 exception
    When others then
       vErro := sqlerrm;
       rollback;
       insert into tdvadm.t_glb_sql values (vErro,
                                            sysdate,
                                            'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                            'SP_SAP_INSERE_TAXNUMBERS - Tipo ' || PTpClient.Tipo || ' - Cliente - ' || vChaveSap || ' - Type ' || vTAXTYPE || ' - Valor ' || vTAXNUM);

       commit;
       if vChaveSap > 1500 Then
          PRESULTADO := 'X';
       End If;  
       If PRESULTADO = 'X' Then
          return;
       End If;
       

end SP_SAP_INSERE_TAXNUMBERS;

procedure SP_SAP_INSERECONTATO(PCliRed IN TpCliRed,
                               PRESULTADO OUT Char,
                               PMENSAGEM OUT VARCHAR2) is
vCount Integer;
vIndCont Integer;
vIdentificadorContato number; 
tpCUSTOMER_S_CUST_CONT MIGDV.CUSTOMER_S_CUST_CONT%ROWTYPE; 
begin
  vCount := 0;
  vIndCont := 1;
      If PCliRed.Tipo IN ('CLI','PRO') Then
         delete MIGDV.CUSTOMER_S_CUST_CONT CO
         where co.KUNNR = PCliRed.ChaveSap;
--      ElsIf PCliRed IN ('PRO','CAR','FOR','BGM','FPW') Then
      End IF;
      FOR vCursor IN (SELECT distinct 
--                             PC.SEQ,
                             PC.CNPJCPF,
                             --PC.CONTATO,
                             PC.PRIMEIRO_NOME,
                             PC.ULTIMO_NOME,
                             PC.DEPARTAMENTO,
                             PC.FONE,
                             PC.CELULAR,
                             PC.FAX,
                             PC.EMAIL,
--                             PC.OBS,
                             PC.TIPO
                      FROM MIGDV.V_PESSOASCONTSAP PC    
                      WHERE trim(PC.CNPJCPF) = trim(PCliRed.CPFCNPJ))
      Loop
        
                      
          PRESULTADO := 'N';
          PMENSAGEM  := '';
          
        
         If PCliRed.Tipo IN ('CLI','PRO') Then
              -- Precisa ser visto como vai ficar o email de envio do CTe
            If trim(nvl(vCursor.PRIMEIRO_NOME, ' ')) <> 'EMLCTE'  Then
                tpCUSTOMER_S_CUST_CONT.KUNNR     := PCliRed.ChaveSap; -- Obrigatório(S) - Identificador do Cliente
                tpCUSTOMER_S_CUST_CONT.PARNR     := LPAD(vIndCont, 10, '0');--'0000000001';--vIdentificadorContato; -- Obrigatório(S) - ID do contato
                tpCUSTOMER_S_CUST_CONT.TITLE     := ' '; -- Obrigatório(N) - Título
                tpCUSTOMER_S_CUST_CONT.VNAME     := nvl(vCursor.PRIMEIRO_NOME, ' '); -- Obrigatório(N) - Primeiro nome
                tpCUSTOMER_S_CUST_CONT.LNAME     := nvl(vCursor.ULTIMO_NOME, ' '); -- Obrigatório(N) - Último nome
                tpCUSTOMER_S_CUST_CONT.LANGUCORR := ' '; -- Obrigatório(N) - Idioma correspondente
                tpCUSTOMER_S_CUST_CONT.ABTNR     := nvl(vCursor.DEPARTAMENTO, ' '); -- Obrigatório(N) - Departamento
                tpCUSTOMER_S_CUST_CONT.PAFKT     := ' '; -- Obrigatório(N) - Função
                tpCUSTOMER_S_CUST_CONT.PAVIP     := ' '; -- Obrigatório(N) - VIP
                tpCUSTOMER_S_CUST_CONT.COUNTRY   := ' '; -- Obrigatório(N) - País
                tpCUSTOMER_S_CUST_CONT.REGION    := ' '; -- Obrigatório(N) - Estado/UF do contato
                tpCUSTOMER_S_CUST_CONT.POSTLCD   := ' '; -- Obrigatório(N) - CEP
                tpCUSTOMER_S_CUST_CONT.CITY      := ' '; -- Obrigatório(N) - Cidade
                tpCUSTOMER_S_CUST_CONT.STREET    := ' '; -- Obrigatório(N) - Logradouro
                tpCUSTOMER_S_CUST_CONT.HOUSE_NO  := ' '; -- Obrigatório(N) - Número do endereço
                tpCUSTOMER_S_CUST_CONT.TEL_NO    := nvl(vCursor.FONE, ' '); -- Obrigatório(N) - Número de telefone: DDD + número
                tpCUSTOMER_S_CUST_CONT.MOBILE_NO := nvl(vCursor.CELULAR, ' '); -- Obrigatório(N) - Número de telefone: DDD + númer 
                tpCUSTOMER_S_CUST_CONT.FAX_NO    := nvl(vCursor.FAX, ' '); -- Obrigatório(N) - Número de fax: DDD + número
                tpCUSTOMER_S_CUST_CONT.E_MAIL    := nvl(vCursor.EMAIL, ' '); -- Obrigatório(N) - Endereço de e-mail
                  
                If ( tpCUSTOMER_S_CUST_CONT.tel_no <> ' ' )    or 
                   ( tpCUSTOMER_S_CUST_CONT.e_mail <> ' ' )    or 
                   ( tpCUSTOMER_S_CUST_CONT.MOBILE_NO <> ' ' ) or 
                   ( tpCUSTOMER_S_CUST_CONT.FAX_NO <> ' ' )    Then
                   INSERT INTO MIGDV.CUSTOMER_S_CUST_CONT VALUES tpCUSTOMER_S_CUST_CONT;
                   vIndCont := vIndCont + 1;
                End If;
            End If;
         End If;   
         PRESULTADO := 'N';
         PMENSAGEM  := 'Contato cliente inserido com sucesso.';
            
      End Loop;
                    
 exception
    When others then
       vErro := sqlerrm;
       rollback;
       insert into tdvadm.t_glb_sql values (vErro,
                                            sysdate,
                                            'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                            'SP_SAP_INSERECONTATO - Tipo ' || PCliRed.Tipo || ' - Cliente - ' || PCliRed.ChaveSap );
                commit;


end SP_SAP_INSERECONTATO;

procedure SP_SAP_INSEREDOCUMENTO(PCliRed IN TpCliRed,
                                 PRESULTADO OUT Char,
                                 PMENSAGEM OUT VARCHAR2) is
vCount Integer;
vIndCont Integer;
vIdentificadorContato number; 
tpVENDOR_S_SUPPL_IDENT MIGDV.VENDOR_S_SUPPL_IDENT%ROWTYPE; 
tpVEND_EXT_S_SUPPL_IDENT MIGDV.VEND_EXT_S_SUPPL_IDENT%ROWTYPE;

begin
  vCount := 0;
  vIndCont := 1;
  PRESULTADO := 'N';
  PMENSAGEM  := '';


      If PCliRed.Tipo NOT IN ('CLI','PRO') Then
         delete MIGDV.VENDOR_S_SUPPL_IDENT VI
         where VI.LIFNR = PCliRed.ChaveSap;
--      ElsIf PCliRed IN ('PRO','CAR','FOR','BGM','FPW') Then
      End IF;
          
-- Z002 - Mov. e operação de produtos perigosos
-- Z003 - Carga indivisível
-- Z006 - Exame Médico
-- Z009 - Integração
-- Z010 - Tacógrafo
-- Z014 - Acuidade visual
-- Z015 - Admissional
-- Z016 - Audiometria
-- Z017 - Clínico
-- Z018 - Eletrocardiograma
-- Z019 - Eletroencefalograma
-- Z020 - Psicológico
-- Z021 - Toxicológico
-- Z022 - IBAMA
-- Z023 - Min. Da Defesa Exército Brasileiro
-- Z024 - Licença Esp. De Tran. De Prod. Per.
-- Z025 - Liberação Ger. de Risco
-- ZCAR - Nº Cartão
-- ZCIO - Nº CIOT Periódico
          
         
         If PCliRed.Tipo IN ('CLI','PRO') Then
         -- Z005 - Nº do PIS
         -- Z008 - RNTRC
            If TRIM(NVL(PCliRed.INSS,' ')) <> '' Then
               tpVEND_EXT_S_SUPPL_IDENT.LIFNR := PCliRed.ChaveSap;
               tpVEND_EXT_S_SUPPL_IDENT.TYPE  := 'Z005'; -- PIS
               tpVEND_EXT_S_SUPPL_IDENT.IDNUMBER := PCliRed.INSS;            
               insert into MIGDV.VEND_EXT_S_SUPPL_IDENT values tpVEND_EXT_S_SUPPL_IDENT;
            End If; 
         ElsIf PCliRed.Tipo = 'FPW' Then
         -- Z011 - Matrícula
         -- Z012 - Situação
         -- Z004 - Férias
         -- Z013 - Tipo de veículo
         -- Z001 - Carteira nacional de habilitação (CNH)
         -- Z026 - Número de Formulário (CNH)
            If PCliRed.MATRICULA is not null Then
               tpVENDOR_S_SUPPL_IDENT.LIFNR := PCliRed.ChaveSap;
               tpVENDOR_S_SUPPL_IDENT.TYPE  := 'Z011'; -- Matricula
               tpVENDOR_S_SUPPL_IDENT.IDNUMBER := PCliRed.MATRICULA;            
               insert into MIGDV.VENDOR_S_SUPPL_IDENT values tpVENDOR_S_SUPPL_IDENT;
            End If; 
         ElsIf PCliRed.Tipo = 'CAR' Then
         -- Z001 - Carteira nacional de habilitação (CNH)
         -- Z026 - Número de Formulário (CNH)
            vCount := vCount;
         End If;
            
         PRESULTADO := 'N';
         PMENSAGEM  := 'Contato cliente inserido com sucesso.';
            
 exception
    When others then
       vErro := sqlerrm;
       rollback;
       insert into tdvadm.t_glb_sql values (vErro,
                                            sysdate,
                                            'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                            'SP_SAP_INSEREDOCUMENTO - Tipo ' || PCliRed.Tipo || ' - Cliente - ' || PCliRed.ChaveSap || ' - Type ' || tpVENDOR_S_SUPPL_IDENT.TYPE);

                commit;

end SP_SAP_INSEREDOCUMENTO;



procedure SP_SAP_INSERE_CLIENTE_ENDERECO_ADICIONAL(PIDCLIENTE IN CHAR,
                                                   tpEndAdicional IN MIGDV.CUSTOMER_S_ADDRESS%ROWTYPE,
                                                   PRESULTADO OUT Char,
                                                   PMENSAGEM OUT VARCHAR2) is
vCount Integer;
tpCUSTOMER_S_ADDRESS MIGDV.CUSTOMER_S_ADDRESS%ROWTYPE; 
begin
  vCount := 0;

  tpCUSTOMER_S_ADDRESS := tpEndAdicional;
        
  SELECT COUNT(*)
  INTO vCount
  FROM MIGDV.CUSTOMER_S_ADDRESS CO
  WHERE CO.KUNNR = PIDCLIENTE;
                      
  PRESULTADO := 'N';
  PMENSAGEM  := ''; 
                    
  IF NVL(vCount, 0) = 0 Then                                                                                       
    --tpCUSTOMER_S_ADDRESS.KUNNR         := PIDCLIENTE; -- Obrigatório(S) - Identificador do cliente
    tpCUSTOMER_S_ADDRESS.BU_ADEXT      := MIGDV.S_SAP_ENDERECO.NEXTVAL;
    
    tpCUSTOMER_S_ADDRESS.STREET        := NVL(substr(tpEndAdicional.STREET,1,59), ' '); -- Obrigatório(S) - Nome do Logradouro do endereço adicional do cliente
    tpCUSTOMER_S_ADDRESS.HOUSE_NUM1    := substr(tpEndAdicional.HOUSE_NUM1,1,10); -- Obrigatório(N) - Número do endereço adicional do cliente
    tpCUSTOMER_S_ADDRESS.CITY2         := substr(tpEndAdicional.CITY2,1,40); -- Obrigatório(N) - Bairro do endereço adicional do cliente
    tpCUSTOMER_S_ADDRESS.POST_CODE1    := NVL(tpEndAdicional.POST_CODE1, ' '); -- Obrigatório(N) - CEP do endereço adicional do cliente
    
    tpCUSTOMER_S_ADDRESS.CITY1         := ' '; -- Obrigatório(N) - Cidade do endereço adicional do cliente
    tpCUSTOMER_S_ADDRESS.COUNTRY       := substr(tpEndAdicional.COUNTRY,1,80);--'BR'; -- Obrigatório(N) - País do cliente
    tpCUSTOMER_S_ADDRESS.REGION        := substr(tpEndAdicional.REGION,1,80); -- **Colocar estado - UF-- Obrigatório(N) - Estado/UF do endereço adicional do cliente
    tpCUSTOMER_S_ADDRESS.STR_SUPPL1    := ' '; -- Obrigatório(N) - Segundo campo de logradouro do endereço adicional do cliente
    tpCUSTOMER_S_ADDRESS.HOUSE_NO2     := NVL(SUBSTR(tpEndAdicional.HOUSE_NO2,1, 10), ' '); -- Obrigatório(N) - Complemento do Endereço adicional do cliente
    tpCUSTOMER_S_ADDRESS.PO_BOX        := ' '; -- Obrigatório(N) - Caixa postal
    tpCUSTOMER_S_ADDRESS.POST_CODE2    := ' '; -- Obrigatório(N) - CEP da caixa postal
    tpCUSTOMER_S_ADDRESS.PO_BOX_LOC    := ' '; -- Obrigatório(N) - Cidade da Caixa postal
    tpCUSTOMER_S_ADDRESS.POBOX_CTRY    := ' '; -- Obrigatório(N) - País da Caixa postal
    tpCUSTOMER_S_ADDRESS.PO_BOX_REG    := ' '; -- Obrigatório(N) - Estado da caixa postal
    tpCUSTOMER_S_ADDRESS.LANGU_CORR    := 'PT'; -- Obrigatório(N) - Idioma
    tpCUSTOMER_S_ADDRESS.TELNR_LONG    := ' '; -- Obrigatório(N) - Telefone
    tpCUSTOMER_S_ADDRESS.TELNR_LONG_2  := ' '; -- Obrigatório(N) - Telefone Adicional 2
    tpCUSTOMER_S_ADDRESS.TELNR_LONG_3  := ' '; -- Obrigatório(N) - Telefone Adicional 3
    tpCUSTOMER_S_ADDRESS.MOBILE_LONG   := ' '; -- Obrigatório(N) - Celular
    tpCUSTOMER_S_ADDRESS.MOBILE_LONG_2 := ' '; -- Obrigatório(N) - Celular adicional 2
    tpCUSTOMER_S_ADDRESS.MOBILE_LONG_3 := ' '; -- Obrigatório(N) - Celular adicional 3
    tpCUSTOMER_S_ADDRESS.FAXNR_LONG    := ' '; -- Obrigatório(N) - Fax
    tpCUSTOMER_S_ADDRESS.FAXNR_LONG_2  := ' '; -- Obrigatório(N) - Fax adicional 2
    tpCUSTOMER_S_ADDRESS.FAXNR_LONG_3  := ' '; -- Obrigatório(N) - Fax adicional 3
    tpCUSTOMER_S_ADDRESS.SMTP_ADDR     := ' '; -- Obrigatório(N) - Email
    tpCUSTOMER_S_ADDRESS.SMTP_ADDR_2   := ' '; -- Obrigatório(N) - E-mail adicional 2
    tpCUSTOMER_S_ADDRESS.SMTP_ADDR_3   := ' '; -- Obrigatório(N) - E-mail adicional 3
    tpCUSTOMER_S_ADDRESS.URI_TYP       := ' '; -- Obrigatório(N) - Tipo de Comunicação
    tpCUSTOMER_S_ADDRESS.URI_ADDR      := ' '; -- Obrigatório(N) - Web Site
              

    If Not ( 
             ( instr(tpCUSTOMER_S_ADDRESS.street, 'ROD') > 0 or instr(tpCUSTOMER_S_ADDRESS.street, vPais) > 0 ) and 
               tpCUSTOMER_S_ADDRESS.street not like 'R %'   and 
               tpCUSTOMER_S_ADDRESS.street not like 'RUA %' and 
               tpCUSTOMER_S_ADDRESS.street not like 'AV %'  and 
               tpCUSTOMER_S_ADDRESS.street not like '%KM%'  and 
               length (tpCUSTOMER_S_ADDRESS.street) < 10 
           ) Then
       INSERT INTO MIGDV.CUSTOMER_S_ADDRESS VALUES tpCUSTOMER_S_ADDRESS;
    End If;
    
    PRESULTADO := 'N';
    PMENSAGEM  := 'Endereço adicional inserido com sucesso.';  
  End If;
 
EXCEPTION
  When others Then
     vErro := sqlerrm;
       rollback;
     insert into tdvadm.t_glb_sql values (vErro,
                                          sysdate,
                                          'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                          'SP_SAP_INSERE_CLIENTE_ENDERECO_ADICIONAL - Cliente - ' || PIDCLIENTE);
                commit;
--     dbms_output.put_line('End Adicional - ' || PIDCLIENTE);

end SP_SAP_INSERE_CLIENTE_ENDERECO_ADICIONAL;

-- Insere Dados bancários do Fornecedor                                           
procedure SP_SAP_INSERE_FORNECEDOR_SUPP_BANK(PIDFORNECEDOR IN CHAR,
                                             PRESULTADO OUT Char,
                                             PMENSAGEM OUT VARCHAR2) is
vCount Integer;
tpVENDOR_S_SUPP_BANK MIGDV.VENDOR_S_SUPP_BANK%ROWTYPE; 
begin
  vCount := 0;

      FOR vCursor IN (    
        SELECT DISTINCT
               B.*
        FROM MIGDV.VENDOR_S_SUPP_BANK B
      )  
      Loop
                     
          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
          IF NVL(vCount, 0) = 0 Then
            PRESULTADO := 'E';
            PMENSAGEM  := 'Não foi possível localizar o fornecedor: ' || sqlerrm;       
            
            tpVENDOR_S_SUPP_BANK.LIFNR   := ' '; -- Obrigatório(S) - Identificador do Fornecedor
            tpVENDOR_S_SUPP_BANK.BANKS := ' '; -- Obrigatório(S) - Chave do país do banco *
            tpVENDOR_S_SUPP_BANK.BANKL := ' '; -- Obrigatório(N) - Identificador do Banco / Agência
            tpVENDOR_S_SUPP_BANK.BANKN := ' '; -- Obrigatório(N) - Nº da conta
            tpVENDOR_S_SUPP_BANK.IBAN := ' '; -- Obrigatório(N) - IBAN
            tpVENDOR_S_SUPP_BANK.XEZER := ' '; -- Obrigatório(N) - Indicador de Autorização de Cobrança
            tpVENDOR_S_SUPP_BANK.KOINH := ' '; -- Obrigatório(N) - Nome do titular da conta
            tpVENDOR_S_SUPP_BANK.EBPP_ACCNAME := ' '; -- Obrigatório(N) - Nome do titular da conta
            
             
              
            INSERT INTO MIGDV.VENDOR_S_SUPP_BANK VALUES tpVENDOR_S_SUPP_BANK;

          End If;
      End Loop;
  
end SP_SAP_INSERE_FORNECEDOR_SUPP_BANK;
                                           
                                 
-- Insere Endereços adicionais do fornecedor                                           
procedure SP_SAP_INSERE_FORNECEDOR_ENDERECO_ADICIONAL(PIDFORNECEDOR IN CHAR,
                                                      PRESULTADO OUT Char,
                                                      PMENSAGEM OUT VARCHAR2) is 
vCount Integer;
tpVENDOR_S_SUPPL_ADDR MIGDV.VENDOR_S_SUPPL_ADDR%ROWTYPE; 
begin
  vCount := 0;

      FOR vCursor IN (    
        SELECT DISTINCT
               A.*
        FROM MIGDV.VENDOR_S_SUPPL_ADDR A
      )  
      Loop
          /*
          Sirlano vai falar com o Thiago sobre os Fornecedores que são também clientes
          */            
          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
          IF NVL(vCount, 0) = 0 Then
            PRESULTADO := 'E';
            PMENSAGEM  := 'Não foi possível localizar o fornecedor: ' || sqlerrm;       
            
            tpVENDOR_S_SUPPL_ADDR.LIFNR         := ' '; -- Obrigatório(S) - Identificador do Fornecedor
            tpVENDOR_S_SUPPL_ADDR.BU_ADEXT      := ' '; -- Obrigatório(S) - Identificador do endereço externo *
            tpVENDOR_S_SUPPL_ADDR.STREET        := ' '; -- Obrigatório(N) - Nome do logradouro do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.HOUSE_NUM1    := ' '; -- Obrigatório(N) - Número do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.CITY2         := ' '; -- Obrigatório(N) - Bairro do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.POST_CODE1    := ' '; -- Obrigatório(N) - CEP do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.CITY1         := ' '; -- Obrigatório(N) - Cidade do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.COUNTRY       := ' '; -- Obrigatório(S) - País do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.REGION        := ' '; -- Obrigatório(N) - Estado/UF do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.STR_SUPPL1    := ' '; -- Obrigatório(N) - Segundo campo de logradouro do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.STR_SUPPL2    := ' '; -- Obrigatório(N) - Terceiro campo de logradouro do endereço do fornecedor
            tpVENDOR_S_SUPPL_ADDR.HOUSE_NO2     := ' '; -- Obrigatório(N) - Caixa postal
            tpVENDOR_S_SUPPL_ADDR.PO_BOX        := ' '; -- Obrigatório(N) - Caixa postal
            tpVENDOR_S_SUPPL_ADDR.PO_BOX_CIT    := ' '; -- Obrigatório(N) - Cidade da Caixa Postal
            tpVENDOR_S_SUPPL_ADDR.POBOX_CTRY    := ' '; -- Obrigatório(N) - País da caixa postal
            tpVENDOR_S_SUPPL_ADDR.PO_BOX_REG    := ' '; -- Obrigatório(N) - Estado/UF da caixa postal
            tpVENDOR_S_SUPPL_ADDR.LANGU_CORR    := ' '; -- Obrigatório(N) - Idioma
            tpVENDOR_S_SUPPL_ADDR.TELNR_LONG    := ' '; -- Obrigatório(N) - Telefone padrão
            tpVENDOR_S_SUPPL_ADDR.TELNR_LONG_2  := ' '; -- Obrigatório(N) - Telefone Adicional 2
            tpVENDOR_S_SUPPL_ADDR.TELNR_LONG_3  := ' '; -- Obrigatório(N) - Telefone Adicional 3
            tpVENDOR_S_SUPPL_ADDR.MOBILE_LONG   := ' '; -- Obrigatório(N) - Celular padrão
            tpVENDOR_S_SUPPL_ADDR.MOBILE_LONG_2 := ' '; -- Obrigatório(N) - Celular adicional 2
            tpVENDOR_S_SUPPL_ADDR.MOBILE_LONG_3 := ' '; -- Obrigatório(N) - Celular adicional 2
            tpVENDOR_S_SUPPL_ADDR.FAXNR_LONG    := ' '; -- Obrigatório(N) - Fax padrão
            tpVENDOR_S_SUPPL_ADDR.FAXNR_LONG_2  := ' '; -- Obrigatório(N) - Fax adicional 2
            tpVENDOR_S_SUPPL_ADDR.FAXNR_LONG_3  := ' '; -- Obrigatório(N) - Fax adicional 3
            tpVENDOR_S_SUPPL_ADDR.SMTP_ADDR     := ' '; -- Obrigatório(N) - Email padrão
            tpVENDOR_S_SUPPL_ADDR.SMTP_ADDR_2   := ' '; -- Obrigatório(N) - Email adicional 2
            tpVENDOR_S_SUPPL_ADDR.SMTP_ADDR_3   := ' '; -- Obrigatório(N) - Email adicional 3
              
            INSERT INTO MIGDV.VENDOR_S_SUPPL_ADDR VALUES tpVENDOR_S_SUPPL_ADDR;

          End If;
      End Loop;
  
end SP_SAP_INSERE_FORNECEDOR_ENDERECO_ADICIONAL;
                                   
                                                     
-- Insere Ativo Fixo da empresa
procedure SP_SAP_INSERE_ATIVOS_FIXO(PIDATIVO IN CHAR,
                                    PRESULTADO OUT Char,
                                    PMENSAGEM OUT VARCHAR2) is

vIdentificadorAtivo number;                                        
tpFIXED_ASSET_S_KEY MIGDV.FIXED_ASSET_S_KEY%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA NÃO ESTÁ DEFINIDO*/
      SELECT *             
      FROM MIGDV.FIXED_ASSET_S_KEY C
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
        for vCursor2 in (
            select C.ANLN1
            INTO vIdentificadorAtivo
            FROM MIGDV.FIXED_ASSET_S_KEY C
            order by to_number(C.ANLN1) desc
          )
          loop
            vIdentificadorAtivo := vCursor2.ANLN1;
            exit;
          end loop;
          
        vIdentificadorAtivo := nvl(vIdentificadorAtivo, 0)+1;
        
        tpFIXED_ASSET_S_KEY.BUKRS      := vCodigoEmpresa; -- Obrigatório(S) - Código da companhia*
        tpFIXED_ASSET_S_KEY.ANLN1      := vIdentificadorAtivo;  -- Obrigatório(S) - Identificador de ativo externo / do legado
        tpFIXED_ASSET_S_KEY.ANLKL      := ' '; -- Obrigatório(S) - Classe de ativos*
        tpFIXED_ASSET_S_KEY.TXT50      := ' '; -- Obrigatório(N) - Descrição do ativo *
        tpFIXED_ASSET_S_KEY.TXA50_MORE := ' '; -- Obrigatório(N) - Descrição do ativo 2
        tpFIXED_ASSET_S_KEY.SERNR      := ' '; -- Obrigatório(N) - Número de série
        tpFIXED_ASSET_S_KEY.INVNR      := ' '; -- Obrigatório(N) - Identificador do Inventário
        tpFIXED_ASSET_S_KEY.MENGE      := ' '; -- Obrigatório(N) - Quantidade
        tpFIXED_ASSET_S_KEY.MEINS      := ' '; -- Obrigatório(N) - Unidade de medida básica
                                             
        INSERT INTO MIGDV.FIXED_ASSET_S_KEY VALUES tpFIXED_ASSET_S_KEY;
        
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Ativo inserido com sucesso';
        
        
    END LOOP;        
    
end SP_SAP_INSERE_ATIVOS_FIXO;                                         


-- Insere valoração do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_VALORACAO(PIDATIVO IN CHAR,
                                        PRESULTADO OUT Char,
                                        PMENSAGEM OUT VARCHAR2) is

vIdentificadorAtivo number;                                        
tpFIXED_ASSET_S_NETWORTHVALUATIO MIGDV.FIXED_ASSET_S_NETWORTHVALUATIO%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA NÃO ESTÁ DEFINIDO*/
      SELECT *             
      FROM MIGDV.FIXED_ASSET_S_NETWORTHVALUATIO C
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
        for vCursor2 in (
            select C.ANLN1
            INTO vIdentificadorAtivo
            FROM MIGDV.FIXED_ASSET_S_NETWORTHVALUATIO C
            order by to_number(C.ANLN1) desc
          )
          loop
            vIdentificadorAtivo := vCursor2.ANLN1;
            exit;
          end loop;
          
        vIdentificadorAtivo := nvl(vIdentificadorAtivo, 0)+1;
        
        tpFIXED_ASSET_S_NETWORTHVALUATIO.BUKRS            := vCodigoEmpresa; -- Obrigatório(S) - Código da companhia*
        tpFIXED_ASSET_S_NETWORTHVALUATIO.ANLN1            := vIdentificadorAtivo;  -- Obrigatório(S) - Identificador de ativo externo / do legado
        tpFIXED_ASSET_S_NETWORTHVALUATIO.PROP_IND         := ' '; -- Obrigatório(N) - Indicador de Propriedade
        tpFIXED_ASSET_S_NETWORTHVALUATIO.MAN_PROP_VAL     := ' '; -- Obrigatório(N) - Valor do imposto sobre patrimônio líquido manual
        tpFIXED_ASSET_S_NETWORTHVALUATIO.CURRENCY         := ' '; -- Obrigatório(N) - Identificador da moeda (formato ISO)
        tpFIXED_ASSET_S_NETWORTHVALUATIO.MAN_PROP_VAL_IND := ' '; -- Obrigatório(N) - Valor do imposto sobre patrimônio líquido - manual
                                         
        INSERT INTO MIGDV.FIXED_ASSET_S_NETWORTHVALUATIO VALUES tpFIXED_ASSET_S_NETWORTHVALUATIO;
        
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Ativo valoração inserido com sucesso';
        
        
    END LOOP; 

end SP_SAP_INSERE_ATIVO_VALORACAO;       

                                          
-- Insere data de entrada e exercício do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_DATAENTRADA(PIDATIVO IN CHAR,
                                          PRESULTADO OUT Char,
                                          PMENSAGEM OUT VARCHAR2) is

vIdentificadorAtivo number;                                        
tpFIXED_ASSET_S_POSTINGINFORMATI MIGDV.FIXED_ASSET_S_POSTINGINFORMATI%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA NÃO ESTÁ DEFINIDO */
      SELECT *             
      FROM MIGDV.FIXED_ASSET_S_POSTINGINFORMATI C
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
        for vCursor2 in (
            select C.ANLN1
            INTO vIdentificadorAtivo
            FROM MIGDV.FIXED_ASSET_S_POSTINGINFORMATI C
            order by to_number(C.ANLN1) desc
          )
          loop
            vIdentificadorAtivo := vCursor2.ANLN1;
            exit;
          end loop;
          
        vIdentificadorAtivo := nvl(vIdentificadorAtivo, 0)+1;
        
        tpFIXED_ASSET_S_POSTINGINFORMATI.BUKRS := vCodigoEmpresa; -- Obrigatório(S) - Código da companhia*
        tpFIXED_ASSET_S_POSTINGINFORMATI.ANLN1 := vIdentificadorAtivo;  -- Obrigatório(S) - Identificador de ativo externo / do legado
        tpFIXED_ASSET_S_POSTINGINFORMATI.AKTIV := ' '; -- Obrigatório(S) - Data de Capitalização de Ativos *
        tpFIXED_ASSET_S_POSTINGINFORMATI.DEAKT := ' '; -- Obrigatório(N) - Data de desativação
        tpFIXED_ASSET_S_POSTINGINFORMATI.GPLAB := ' '; -- Obrigatório(N) - Data de obsolência planejada
        tpFIXED_ASSET_S_POSTINGINFORMATI.BSTDT := ' '; -- Obrigatório(N) - Data do pedido de compra do ativo
                                         
        INSERT INTO MIGDV.FIXED_ASSET_S_POSTINGINFORMATI VALUES tpFIXED_ASSET_S_POSTINGINFORMATI;
        
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Ativo de data entrada inserido com sucesso';
        
        
    END LOOP; 
    
end SP_SAP_INSERE_ATIVO_DATAENTRADA; 
                                          


-- Insere Equipamento
procedure SP_SAP_INSERE_EQUIPAMENTO(PRESULTADO OUT Char,
                                    PMENSAGEM OUT VARCHAR2) is
                                          
vIdentificadorEquipamento number;     
vCount number;                                   
tpFUNC_LOC_S_FUN_LOCATION MIGDV.FUNC_LOC_S_FUN_LOCATION%ROWTYPE; 
   i integer;
begin
  

--tp equipamento  descrição         range de  até 

--       A        Cavalo agregado   A000001 A999999 
--       C        Cavalo frota      C0001 C9999 
--       E        Empilhadeira      E001  E999  
--       K        Caminhão          K0001 K9999 
--       L        Frota leve        L001  L999  
--       P        Pneus             P000001 P999999 solicitada alteração dia 18.09, ainda vai ser alterado para P0000001 a P9999999
--       R        Semi reboque      R0000001  R9999999  
--       V        Retroescavadeira  V001  V999  

--   Local de Instalação: aqui não tem um range específico, pois a definição é diferente, segue um layout. Mas foram criados os tipos de local de instalação conforme abaixo, com o range de numeração com layout e tamanho igual a XXXXXXXXXXXXXXXXXXXX
--   Porque o local de instalação pode ter números, letras e alguns caracteres especiais como ¿ ou /

--   Tp local de instalação  Descrição
--            A              Cavalo agregado
--            C              Cavalo frota
--            E              Empilhadeira
--            F              Local de instalação fixo
--            K              Truck
--            L              Frota leve
--            M              Sistema técnico - padrão
--            P              Recapadora
--            R              Semi-reboque
--            X              Eixo


  
    FOR vCursor IN (   
      SELECT DECODE(M.FRT_MARCMODAPELIDO_DESCRICAO, 'NAO DEFINIDO', '', M.FRT_MARCMODAPELIDO_DESCRICAO) || ' - ' || A.FRT_MARMODVEIC_DESCRICAO DESCRICAO,
             V.FRT_VEICULO_PLACA PLACA,
             V.FRT_VEICULO_PBT PESO_VEICULO,
             V.FRT_VEICULO_ANOFABRICACAO ANOFABRICACAO,
             TO_CHAR(NVL(V.FRT_VEICULO_DATAQUISICAO, TRUNC(SYSDATE)), 'YYYYMMDD') DT_AQUISICAO,
             V.FRT_VEICULO_CHASSIS CHASSI,
             V.FRT_VEICULO_CODIGO VEIC_CODIGO,
             DECODE(M.FRT_MARCMODAPELIDO_DESCRICAO, 'NAO DEFINIDO', 'ND', 
                                                    'AGREGADO','A', -- Cavalo Agregado
                                                    'AGREGADO TRUCADO','A', -- Cavalo Agregado
                                                    'APOIO','L', -- Frota Leve
                                                    'BASC','R', -- Semi Reboque
                                                    'BIT','C', -- Cavalo Frota
                                                    'CARRETA SEM TRACAO','R', -- Semi Reboque
                                                    'CAV 4x2','C', -- Cavalo Frota
                                                    'CAV 6x2','C', -- Cavalo Frota
                                                    'CBUG20','R', -- Semi Reboque
                                                    'CBUG40','R', -- Semi Reboque
                                                    'CLONG 14','R', -- Semi Reboque
                                                    'CLONG 15','R', -- Semi Reboque
                                                    'CSIDER','R', -- Semi Reboque
                                                    'CSIMPLES','R', -- Semi Reboque
                                                    'EMPILHADEIRA','E', -- Empilhadeira
                                                    'GOL','L', -- Frota Leve
                                                    'NAO SEI','NS',
                                                    'SAVEIRO','L', -- Frota Leve
                                                    'TANQ','R', -- Semi Reboque
                                                    'TBAU','K',  -- Truck
                                                    'TSIDER','K', -- Truck
                                                    'TSIMPLES','K', -- Truck
                                                    'UTILITARIO','L', -- Frota Leve
                                                    'VAND','R', -- Semi Reboque
                                                    'RETROESCAVADEIRA','V', -- Retroescavadeira
                                                    'CARRO DIRETORIA','CD',
                                                    'GUINCHO','GG',
                                                    'MOTO','MM',
                                                    M.FRT_MARCMODAPELIDO_DESCRICAO) EQTYP, 
             DECODE(M.FRT_MARCMODAPELIDO_DESCRICAO, 'NAO DEFINIDO','1530406001', -- GERENCIAM.  OPE
                                                    'AGREGADO','1530406201', -- ATENDIMENTO AGR
                                                    'AGREGADO TRUCADO','1530406201', -- ATENDIMENTO AGR
                                                    'APOIO','1530407101', -- ARMAZEM
                                                    'BASC','1530407001', -- FROTA CARRETAS
                                                    'BIT','1530406901', -- FROTA PROPRIA C
                                                    'CARRETA SEM TRACAO','1530407001', -- FROTA CARRETAS
                                                    'CAV 4x2','1530406901', -- FROTA PROPRIA C
                                                    'CAV 6x2','1530406901', -- FROTA PROPRIA C
                                                    'CBUG20','1530407001', -- FROTA CARRETAS
                                                    'CBUG40','1530407001', -- FROTA CARRETAS
                                                    'CLONG 14','1530407001', -- FROTA CARRETAS
                                                    'CLONG 15','1530407001', -- FROTA CARRETAS
                                                    'CSIDER','1530407001', -- FROTA CARRETAS
                                                    'CSIMPLES','1530407001', -- FROTA CARRETAS
                                                    'EMPILHADEIRA','1530407101', -- ARMAZEM
                                                    'GOL','1530407101', -- ARMAZEM
                                                    'NAO SEI','1530406001', -- GERENCIAM.  OPE
                                                    'SAVEIRO','1530407101', -- ARMAZEM
                                                    'TANQ','1530407001', -- FROTA CARRETAS
                                                    'TBAU','1530407001', -- FROTA CARRETAS
                                                    'TSIDER','1530407001', -- FROTA CARRETAS
                                                    'TSIMPLES','1530407001', -- FROTA CARRETAS
                                                    'UTILITARIO','1530407101', -- ARMAZEM
                                                    'VAND','1530407001', -- FROTA CARRETAS
                                                    'RETROESCAVADEIRA','0110406401', -- MANUTENÇÃO
                                                    'CARRO DIRETORIA','0110301001', -- CORPORATIVO
                                                    'GUINCHO','0110406401', -- MANUTENÇÃO
                                                    'MOTO','1530407101', -- ARMAZEM
                                                    M.FRT_MARCMODAPELIDO_DESCRICAO) KOSTL, 
             'KG' UNIDADE,
             DECODE(M.FRT_MARCMODAPELIDO_DESCRICAO, 'NAO DEFINIDO','S', -- Local cliente
                                                    'AGREGADO','A', -- Cavalo agregado
                                                    'AGREGADO TRUCADO','A', -- Cavalo agregado
                                                    'APOIO','L', -- Frota leve
                                                    'BASC','S', -- Local cliente
                                                    'BIT','C', -- Cavalo frota
                                                    'CARRETA SEM TRACAO','R', -- Semi-reboque
                                                    'CAV 4x2','C', -- Cavalo frota
                                                    'CAV 6x2','C', -- Cavalo frota
                                                    'CBUG20','R', -- Semi-reboque
                                                    'CBUG40','R', -- Semi-reboque
                                                    'CLONG 14','R', -- Semi-reboque
                                                    'CLONG 15','R', -- Semi-reboque
                                                    'CSIDER','R', -- Semi-reboque
                                                    'CSIMPLES','R', -- Semi-reboque
                                                    'EMPILHADEIRA','E', -- Empilhadeira
                                                    'GOL','L', -- Frota leve
                                                    'NAO SEI','S', -- Local cliente
                                                    'SAVEIRO','L', -- Frota leve
                                                    'TANQ','K', -- Truck
                                                    'TBAU','K', -- Truck
                                                    'TSIDER','K', -- Truck
                                                    'TSIMPLES','K', -- Truck
                                                    'UTILITARIO','L', -- Frota leve
                                                    'VAND','L', -- Frota leve
                                                    'RETROESCAVADEIRA','S', -- Local cliente
                                                    'CARRO DIRETORIA','S', -- Local cliente
                                                    'GUINCHO','S', -- Local cliente
                                                    'MOTO','L', -- Frota leve
--                                                    'I', -- RE bens imóveis
--                                                    'M', -- Sistema técnico - padrão
--                                                    'F', -- Local de instalação fixo
--                                                    'P', -- Recapadora
--                                                    'X', -- Eixo
                                                    M.FRT_MARCMODAPELIDO_DESCRICAO) FLTYP,


             DECODE(M.FRT_MARCMODAPELIDO_DESCRICAO, 'NAO DEFINIDO','pQtdecommit', -- Tipo equipam.  pQtdecommit
                                                    'AGREGADO','CAV_DF6X2F', -- CAV MEC DAF FTS440
                                                    'AGREGADO TRUCADO','CAV_DF6X2F', -- CAV MEC DAF FTS440
                                                    'APOIO','FL_GOL', -- GOL
                                                    'BASC','CAV_DF6X2F', -- CAV MEC DAF FTS440
                                                    'BIT','CAV_DF6X2F', -- CAV MEC DAF FTS440
                                                    'CARRETA SEM TRACAO','CTA_SPLES', -- CARRETA SIMPLES 12 M
                                                    'CAV 4x2','CAV_SC4X2P', -- CAV MEC TOC SC P340
                                                    'CAV 6x2','CAV_SC6X2G', -- CAV MEC TRC SC G380
                                                    'CBUG20','CTA_BUG20', -- CARRETA P.C. BUG 20P
                                                    'CBUG40','CTA_BUG40', -- CARRETA P.C. BUG 40P
                                                    'CLONG 14','CTA_VAND', -- CARRETA CS VAND 14 M
                                                    'CLONG 15','CTA_VANDL', -- CARRETA CS VAND 15 M
                                                    'CSIDER','CTA_SIDER', -- CARRETA  BAU SIDER
                                                    'CSIMPLES','CTA_SPLES', -- CARRETA SIMPLES 12 M
                                                    'EMPILHADEIRA','EMPILH_12T', -- EMPILHADEIRA 12T
                                                    'GOL','FL_GOL', -- GOL
                                                    'NAO SEI','pQtdecommit', -- Tipo equipam.  pQtdecommit
                                                    'SAVEIRO','FL_SAVEIRO', -- SAVEIRO
                                                    'TANQ','pQtdecommit', -- Tipo equipam.  pQtdecommit
                                                    'TBAU','TRUCK_F4X2', -- CAMINHÃO TRUCK 2428E
                                                    'TSIDER','TRUCK_F4X2', -- CAMINHÃO TRUCK 2428E
                                                    'TSIMPLES','TRUCK_F4X2', -- CAMINHÃO TRUCK 2428E
                                                    'UTILITARIO','FL_GOL', -- GOL
                                                    'VAND','pQtdecommit', -- Tipo equipam.  pQtdecommit
                                                    'RETROESCAVADEIRA','RET_ESCAV', -- RETROESCAVADEIRA
                                                    'CARRO DIRETORIA','FL_LEXUS', -- LEXUS
                                                    'GUINCHO','pQtdecommit', -- Tipo equipam.  pQtdecommit
                                                    'MOTO','pQtdecommit', -- Tipo equipam.  pQtdecommit
                                      -- 'pQtdecommit', -- Tipo equipam.  pQtdecommit
                                      -- '1230', -- Guind.torre > 100 tm
                                      -- '1380', -- Tratores de esteira
                                      -- '2000', -- Tipo equipam.   2000
                                      -- '5100', -- Armamento / fôrma
                                      -- '9000', -- Equipamento inform.
                                      -- '9100', -- Motores
                                      -- '9200', -- Compressores rotats.
                                      -- '9300', -- Radiadores
                                      -- '9400', -- Válvulas
                                      -- '9500', -- Bombas
                                      -- '9600', -- Secador
                                      -- '9700', -- Caixa de velocidades
                                      -- '9800', -- Radiador
                                      -- 'AERONAVE', -- AERONAVE
                                      -- 'AGREGADO', -- AGREGADO
                                      -- 'CAV_DF6X2F', -- CAV MEC DAF FTS440
                                      -- 'CAV_DF6X2S', -- CAV MEC DAF FTS460
                                      -- 'CAV_DF6X4F', -- CAV MEC DAF FTT440
                                      -- 'CAV_DF6X4T', -- CAV MEC DAF FTT460
                                      -- 'CAV_MAN6X2', -- CAV MEC MAN TGX440
                                      -- 'CAV_MAN6X4', -- CAV MEC MAN TGX440
                                      -- 'CAV_SC4X2P', -- CAV MEC TOC SC P340
                                      -- 'CAV_SC6X2G', -- CAV MEC TRC SC G380
                                      -- 'CAV_SC6X2R', -- CAV MEC TRC SC R440
                                      -- 'CAV_SC6X4G', -- CAV MEC TRC SC G380
                                      -- 'CAV_SC6X4R', -- CAV MEC TRC SC R440
                                      -- 'CTA_BASC', -- CARRETA BASCULANTE
                                      -- 'CTA_BITREM', -- CARRETA BI-TREM
                                      -- 'CTA_BUG20', -- CARRETA P.C. BUG 20P
                                      -- 'CTA_BUG40', -- CARRETA P.C. BUG 40P
                                      -- 'CTA_SIDER', -- CARRETA  BAU SIDER
                                      -- 'CTA_SPLES', -- CARRETA SIMPLES 12 M
                                      -- 'CTA_TANQUE', -- CARRETA TANQUE
                                      -- 'CTA_VAND', -- CARRETA CS VAND 14 M
                                      -- 'CTA_VANDL', -- CARRETA CS VAND 15 M
                                      -- 'EMPILH_12T', -- EMPILHADEIRA 12T
                                      -- 'EMPILH_20T', -- EMPILHADEIRA 20T
                                      -- 'EMPILH_22T', -- EMPILHADEIRA 22T
                                      -- 'EMPILH_2T', -- EMPILHADEIRA 2T
                                      -- 'EMPILH_37T', -- EMPILHADEIRA 37T
                                      -- 'EMPILH_3T', -- EMPILHADEIRA 3T
                                      -- 'EMPILH_45T', -- EMPILHADEIRA 45T
                                      -- 'EMPILH_6T', -- EMPILHADEIRA 6T
                                      -- 'FL_AMAROK', -- AMAROK 4X4
                                      -- 'FL_BIZ', -- HONDA BIZ
                                      -- 'FL_CAMRY', -- TOYOTA CAMRY
                                      -- 'FL_DOBLO', -- FIAT DOBLO
                                      -- 'FL_GOL', -- GOL
                                      -- 'FL_LEXUS', -- LEXUS
                                      -- 'FL_ONIBUS', -- FORD MICROONIBUS
                                      -- 'FL_S10', -- S10
                                      -- 'FL_SAVEIRO', -- SAVEIRO
                                      -- 'FL_SONATA', -- HYUNDAI SONATA
                                      -- 'FL_SPIN', -- SPIN
                                      -- 'FL_TRANSIT', -- FORD TRANSIT
                                      -- 'PNEU', -- Pneus
                                      -- 'RET_ESCAV', -- RETROESCAVADEIRA
                                      -- 'SEMI_REB2E', -- SEMI REBOQUE 2 EIXOS
                                      -- 'SEMI_REB3E', -- SEMI REBOQUE 3 EIXOS
                                      -- 'TRUCK_F4X2', -- CAMINHÃO TRUCK 2428E
                                      -- 'TRUCK_F6X2', -- CAMINHÃO TRUCK 2429
                                      -- 'TRUCK_V6X2', -- CAMINHÃO VW 24280 CR
                                      -- 'TR_TRATOR', -- TRATOR
                                                    M.FRT_MARCMODAPELIDO_DESCRICAO) EQART, -- Veridicar com o KEY USER o que seria
             A.FRT_MARMODVEIC_MARCA MARCA,
             A.FRT_MARMODVEIC_MODELO MODELO,
             DECODE(T.FRT_TPVEICULO_TRACAO, 'S', 'SIM', 
                                            'N', 'NAO', 'NAO') TRACAO,
             V.Frt_Veiculo_Valoraquisicao VALOR_AQUISICAO
      FROM TDVADM.T_FRT_VEICULO V,
           TDVADM.T_FRT_MARMODVEIC A, 
           TDVADM.T_FRT_MARCMODAPELIDO M,
           TDVADM.T_FRT_TPVEICULO T
      WHERE V.FRT_MARMODVEIC_CODIGO = A.FRT_MARMODVEIC_CODIGO 
        AND A.FRT_MARCMODAPELIDO_CODIGO = M.FRT_MARCMODAPELIDO_CODIGO (+)
        AND T.FRT_TPVEICULO_CODIGO = A.FRT_TPVEICULO_CODIGO
        and v.frt_veiculo_codigo = (select max(vv.frt_veiculo_codigo)
                                    from tdvadm.t_frt_veiculo vv
                                    where vv.frt_veiculo_placa = v.frt_veiculo_placa
                                      and vv.frt_veiculo_datavenda is null)
--        and V.FRT_VEICULO_PLACA = 'NSQ7032'
        AND V.FRT_VEICULO_DATAVENDA IS NULL
      ORDER BY T.FRT_TPVEICULO_TRACAO DESC
    )
    LOOP
    
       If trim(vCursor.EQTYP) not in ('CD', -- Carro da Diretoria
                                      'GG', -- Guincho
                                      'ND', -- 
                                      'MM'  -- Moto
                                     ) Then
          tpEQUIPMENT_S_EQUI := tpEQUIPMENT_S_EQUI2;
          tpEQUIPMENT_S_EQUI.EQUNR     := vCursor.PLACA; -- Obrigatório(S) - Identificador do equipamento no Legado
          tpEQUIPMENT_S_EQUI.EQTYP     := vCursor.EQTYP;  -- Obrigatório(S) - Categoria de equipamento *
          tpEQUIPMENT_S_EQUI.EQKTX     := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' '); -- Obrigatório(S) - Descrição do equipamento
          tpEQUIPMENT_S_EQUI.EQART     := vCursor.EQART; -- Obrigatório(N) - Tipo de objeto técnico
          tpEQUIPMENT_S_EQUI.BEGRU     := '0001'; -- OU 0002 VERIFICAR -- Obrigatório(N) - Grupo de autorização de objeto técnico
          tpEQUIPMENT_S_EQUI.DATAB     := vCursor.DT_AQUISICAO; -- YYYYMMDD - Obrigatório(S) - Data de validade inicial
          tpEQUIPMENT_S_EQUI.GROES     := ' '; -- Obrigatório(N) - Tamanho / dimensão
          tpEQUIPMENT_S_EQUI.BRGEW     := NVL(vCursor.PESO_VEICULO,0); -- Obrigatório(N) - Peso do objeto 
          If tpEQUIPMENT_S_EQUI.BRGEW = 0 Then
             tpEQUIPMENT_S_EQUI.GEWEI     := ' '; -- Obrigatório(N) - Unidade de peso (formato ISO)
          Else
             tpEQUIPMENT_S_EQUI.GEWEI     := vCursor.UNIDADE; -- Obrigatório(N) - Unidade de peso (formato ISO)
          End If;
          tpEQUIPMENT_S_EQUI.INVNR     := ' '; -- Obrigatório(N) - Identificador de inventário
          tpEQUIPMENT_S_EQUI.INBDT     :=  vCursor.DT_AQUISICAO; -- Obrigatório(N) - Data de início do objeto técnico
          tpEQUIPMENT_S_EQUI.ANSWT     := NVL(vCursor.VALOR_AQUISICAO, 0); -- Obrigatório(N) - Valor de aquisição
          If tpEQUIPMENT_S_EQUI.ANSWT <> 0 Then
             tpEQUIPMENT_S_EQUI.WAERS     := vMoeda; -- Obrigatório(N) - Identificador da moeda (formato ISO)
          Else
             tpEQUIPMENT_S_EQUI.WAERS     := ' '; -- Obrigatório(N) - Identificador da moeda (formato ISO)
          End If;
          tpEQUIPMENT_S_EQUI.HERST     := NVL(vCursor.MARCA, ' '); -- Obrigatório(N) - Fabricante do ativo
          tpEQUIPMENT_S_EQUI.HERLD     := vPais; -- Obrigatório(N) - País de fabricação
          tpEQUIPMENT_S_EQUI.TYPBZ     := NVL(vCursor.MODELO, ' '); -- Obrigatório(N) - Número do modelo do fabricante
          tpEQUIPMENT_S_EQUI.BAUJJ     := NVL(TRIM(vCursor.ANOFABRICACAO), ' '); -- Obrigatório(N) - Ano de fabricação
          tpEQUIPMENT_S_EQUI.BAUMM     := ' '; -- Obrigatório(N) - Mês de fabricação
          tpEQUIPMENT_S_EQUI.MAPAR     := ' '; -- Obrigatório(N) - Número da peça do fabricante (part number)
          tpEQUIPMENT_S_EQUI.SERGE     := NVL(TRIM(vCursor.CHASSI), ' '); -- Obrigatório(N) - Número de série do fabricante
          tpEQUIPMENT_S_EQUI.SORTFIELD := ' '; -- Obrigatório(N) - Campo de Classificação
          tpEQUIPMENT_S_EQUI.BUKRS     := vCodigoEmpresa; -- Obrigatório(N) - Código da companhia
          tpEQUIPMENT_S_EQUI.ANLNR     := ' '; -- Obrigatório(N) - Identificador do ativo principal
          tpEQUIPMENT_S_EQUI.KOSTL     := vCursor.KOSTL; -- Obrigatório(N) - Centro de custo
          tpEQUIPMENT_S_EQUI.TPLNR     := ' '; -- Obrigatório(N) - Identificador do Local de Instalação
          tpEQUIPMENT_S_EQUI.MATNR     := ' '; -- Obrigatório(N) - Identificador de Material
          tpEQUIPMENT_S_EQUI.GERNR     := NVL(SUBSTR(vCursor.CHASSI, 1, 18), ' '); -- Obrigatório(N) - Número de série
                                         
           -- Select para encontrar veículo de tracao que está engatado
             FOR vCursorEngate IN(
                 select ce.frt_conjveiculo_codigo conjunto,
                        cv.frt_conjveiculo_descrição,
                        ce.frt_conteng_dataengate
                 from TDVADM.t_frt_conteng ce,
                      TDVADM.t_frt_veiculo v,
                      TDVADM.T_FRT_MARMODVEIC A, 
                      tdvadm.t_frt_tpveiculo tv,
                      TDVADM.T_FRT_MARCMODAPELIDO M,
                      tdvadm.t_frt_conjveiculo cv
                 where 0 = 0
                   AND V.FRT_MARMODVEIC_CODIGO = A.FRT_MARMODVEIC_CODIGO 
                   AND A.FRT_MARCMODAPELIDO_CODIGO = M.FRT_MARCMODAPELIDO_CODIGO (+)
                   and a.frt_tpveiculo_codigo = tv.frt_tpveiculo_codigo
                   and cv.frt_conjveiculo_codigo = ce.frt_conjveiculo_codigo
                   and tv.frt_tpveiculo_tracao = 'S'
                   AND ce.frt_veiculo_codigo = v.frt_veiculo_codigo
                   AND ce.frt_veiculo_codigo = vCursor.VEIC_CODIGO -- código do veículo
                                  )
             LOOP
                tpEQUIPMENT_S_EQUI.TPLNR := vCursorEngate.conjunto;

                 tpFUNC_LOC_S_FUN_LOCATION.EXTERNAL_NUMBER := vCursorEngate.conjunto; -- Obrigatório(S) - Identificador do local de instalação (sequencial ou identificador do legado)
                 tpFUNC_LOC_S_FUN_LOCATION.TPLKZ      := 'D_V'; -- Obrigatório(S) - Indicador de estrutura do local de instalação
                 tpFUNC_LOC_S_FUN_LOCATION.FLTYP      := vCursor.FLTYP; -- Obrigatório(S) - Categoria do local de instalação
                 tpFUNC_LOC_S_FUN_LOCATION.ALKEY      := ' '; -- Obrigatório(N) - Sistema de etiquetagem para locais de instalação
                 tpFUNC_LOC_S_FUN_LOCATION.KTX01      := NVL(SUBSTR(vCursorEngate.frt_conjveiculo_descrição, 1, 40), ' '); -- Obrigatório(N) - Descrição do objeto técnico
                 tpFUNC_LOC_S_FUN_LOCATION.EQART      := vCursor.EQART; -- Obrigatório(N) - Tipo de objeto técnico
                 tpFUNC_LOC_S_FUN_LOCATION.INVNR      := ''; -- Obrigatório(N) - Número de inventário
                 tpFUNC_LOC_S_FUN_LOCATION.BRGEW      := 0; -- Obrigatório(N) - Peso do objeto
                 tpFUNC_LOC_S_FUN_LOCATION.GEWEI      := ' '; -- Obrigatório(N) - Unidade de peso (formato ISO)
                 tpFUNC_LOC_S_FUN_LOCATION.GROES      := ' '; -- Obrigatório(N) - Tamanho / dimensão
                 tpFUNC_LOC_S_FUN_LOCATION.INBDT      := vCursorEngate.frt_conteng_dataengate; -- Obrigatório(N) - Data de início do objeto técnico
                 tpFUNC_LOC_S_FUN_LOCATION.SORTFIELD  := ' '; -- Obrigatório(N) - Campo de Classificação
                 tpFUNC_LOC_S_FUN_LOCATION.BUKRS      := vCodigoEmpresa; -- Obrigatório(N) - Código da companhia
                 tpFUNC_LOC_S_FUN_LOCATION.GSBER      :=  '0001'; -- Estrutura -- Obrigatório(N) - Área de trabalho
                 tpFUNC_LOC_S_FUN_LOCATION.KOSTL      := vCursor.KOSTL; -- Obrigatório(N) - Centro de custo
              
                 SP_SAP_INSERE_LOCAL_INSTALACAO(tpFUNC_LOC_S_FUN_LOCATION, PRESULTADO, PMENSAGEM);         
                 exit;

             End Loop;

          begin

              If tpEQUIPMENT_S_EQUI.eqtyp in ('A', 'C', 'E', 'L', 'K', 'R', 'V') Then
                 -- Se for os caminhoes não manda o Peso
                 tpEQUIPMENT_S_EQUI.gewei := ' ';
                 tpEQUIPMENT_S_EQUI.brgew := 0;
              End If;
              
              --54-Número de Série do Fabricante (campo SERGE) preenchido com zeros 
              If ( Length(trim(tpEQUIPMENT_S_EQUI.Serge)) < 17 ) Then
                 tpEQUIPMENT_S_EQUI.Serge := ' '; -- Número de Série do Fabricante
              End If;              
              If ( instr( trim(tpEQUIPMENT_S_EQUI.Serge),'00000000') > 0 ) or
                 ( instr( trim(tpEQUIPMENT_S_EQUI.Serge),'00000000') > 0 ) Then
                 tpEQUIPMENT_S_EQUI.Serge := ' '; -- Número de Série do Fabricante
              End If;
              --59-Número de Série do Equipamento (campo GERNR) preenchido com zeros 
              If Length(trim(tpEQUIPMENT_S_EQUI.gernr)) < 17 Then
                 tpEQUIPMENT_S_EQUI.gernr := ' '; -- Número de Série do Equipamento
              End If;              
              If ( instr( trim(tpEQUIPMENT_S_EQUI.gernr),'00000000') > 0 ) or
                 ( instr( trim(tpEQUIPMENT_S_EQUI.gernr),'00000000') > 0 ) Then
                 tpEQUIPMENT_S_EQUI.gernr := ' '; -- Número de Série do Equipamento
              End If;

              --62-Grupo de Identificador da Moeda (campo WAERS) preenchido sem valor informado (campo ANSWT). Informar a moeda quando valor informado no campo Valor de Aquisição (ANSWT) 
              iF ( tpEQUIPMENT_S_EQUI.ANSWT is null  or  tpEQUIPMENT_S_EQUI.ANSWT = 0) Then
                 tpEQUIPMENT_S_EQUI.WAERS := ' ';
              End If;
              
                 
              INSERT INTO MIGDV.EQUIPMENT_S_EQUI VALUES tpEQUIPMENT_S_EQUI;


--            IF vCursor.TRACAO = 'SIM' THEN
            -- Inicio Local de instalacao
                 tpFUNC_LOC_S_FUN_LOCATION.EXTERNAL_NUMBER := tpEQUIPMENT_S_EQUI.TPLNR; -- Obrigatório(S) - Identificador do local de instalação (sequencial ou identificador do legado)
              /*CAMPO TPLKZ - COLOCAMOS 1 EM CONVERSA COM A ANA FOI DITO QUE COMO NÃO TEMOS MAIS DE 
                UM LOCAL DE INSTALAÇÃO PODEMOS MANDAR 1
              */
                 tpFUNC_LOC_S_FUN_LOCATION.TPLKZ      := 'D_V'; -- Obrigatório(S) - Indicador de estrutura do local de instalação
                 tpFUNC_LOC_S_FUN_LOCATION.FLTYP      := vCursor.FLTYP; -- Obrigatório(S) - Categoria do local de instalação
                 tpFUNC_LOC_S_FUN_LOCATION.ALKEY      := ' '; -- Obrigatório(N) - Sistema de etiquetagem para locais de instalação
                 tpFUNC_LOC_S_FUN_LOCATION.KTX01      := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' '); -- Obrigatório(N) - Descrição do objeto técnico
                 tpFUNC_LOC_S_FUN_LOCATION.EQART      := vCursor.EQART; -- Obrigatório(N) - Tipo de objeto técnico
                 tpFUNC_LOC_S_FUN_LOCATION.INVNR      := ''; -- Obrigatório(N) - Número de inventário
                 tpFUNC_LOC_S_FUN_LOCATION.BRGEW      := NVL(vCursor.PESO_VEICULO,0); -- Obrigatório(N) - Peso do objeto
                 If tpFUNC_LOC_S_FUN_LOCATION.BRGEW = 0 Then
                    tpFUNC_LOC_S_FUN_LOCATION.GEWEI      := ' '; -- Obrigatório(N) - Unidade de peso (formato ISO)
                 Else
                    tpFUNC_LOC_S_FUN_LOCATION.GEWEI      := vCursor.UNIDADE; -- Obrigatório(N) - Unidade de peso (formato ISO)
                 End If;
                 tpFUNC_LOC_S_FUN_LOCATION.GROES      := ' '; -- Obrigatório(N) - Tamanho / dimensão
                 tpFUNC_LOC_S_FUN_LOCATION.INBDT      := vCursor.DT_AQUISICAO; -- Obrigatório(N) - Data de início do objeto técnico
                 tpFUNC_LOC_S_FUN_LOCATION.SORTFIELD  := ' '; -- Obrigatório(N) - Campo de Classificação
                 tpFUNC_LOC_S_FUN_LOCATION.BUKRS      := vCodigoEmpresa; -- Obrigatório(N) - Código da companhia
                 tpFUNC_LOC_S_FUN_LOCATION.GSBER      :=  '0001'; -- Estrutura -- Obrigatório(N) - Área de trabalho
                 tpFUNC_LOC_S_FUN_LOCATION.KOSTL      := vCursor.KOSTL; -- Obrigatório(N) - Centro de custo
              
                 SP_SAP_INSERE_LOCAL_INSTALACAO(tpFUNC_LOC_S_FUN_LOCATION, PRESULTADO, PMENSAGEM);         
            
                 -- Fim local de instalacao
--              End If; 
          exception
          When OThers Then
             vErro := sqlerrm;
             rollback;
             insert into tdvadm.t_glb_sql values (vErro,
                                                  sysdate,
                                                  'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                  'SP_SAP_INSERE_EQUIPAMENTO - Placa - ' || tpEQUIPMENT_S_EQUI.TPLNR);
                commit;
            
          End;        

          PRESULTADO := 'N';
          PMENSAGEM  := 'Equipamento inserido com sucesso';
        
      End If;   
      i := i + 1;
      If mod(i,pQtdecommit) = 0 Then
         commit;
      End If; 

    END LOOP;
    commit;

End SP_SAP_INSERE_EQUIPAMENTO;


-- Insere Local de Instalação
procedure SP_SAP_INSERE_LOCAL_INSTALACAO(tpLOCAL MIGDV.FUNC_LOC_S_FUN_LOCATION%ROWTYPE,
                                         PRESULTADO OUT Char,
                                         PMENSAGEM OUT VARCHAR2) is
                                         
vIdentificadorInstalacao number;  
vRegEncontrados number;                                      
tpFUNC_LOC_S_FUN_LOCATION MIGDV.FUNC_LOC_S_FUN_LOCATION%ROWTYPE;                                        
begin
   SELECT COUNT(*) 
   INTO vRegEncontrados
   FROM MIGDV.FUNC_LOC_S_FUN_LOCATION L
   WHERE L.EXTERNAL_NUMBER = tpLOCAL.EXTERNAL_NUMBER;
   
   vRegEncontrados := NVL(vRegEncontrados, 0);
   IF vRegEncontrados = 0 THEN
        tpFUNC_LOC_S_FUN_LOCATION.EXTERNAL_NUMBER := tpLOCAL.EXTERNAL_NUMBER; -- Obrigatório(S) - Identificador do local de instalação (sequencial ou identificador do legado)
        tpFUNC_LOC_S_FUN_LOCATION.TPLKZ           := NVL(tpLOCAL.TPLKZ,' '); -- Obrigatório(S) - Indicador de estrutura do local de instalação
        tpFUNC_LOC_S_FUN_LOCATION.FLTYP           := tpLOCAL.FLTYP; -- Obrigatório(S) - Categoria do local de instalação
        tpFUNC_LOC_S_FUN_LOCATION.ALKEY           := tpLOCAL.ALKEY; -- Obrigatório(N) - Sistema de etiquetagem para locais de instalação
        tpFUNC_LOC_S_FUN_LOCATION.KTX01           := tpLOCAL.KTX01; -- Obrigatório(N) - Descrição do objeto técnico
        tpFUNC_LOC_S_FUN_LOCATION.EQART           := tpLOCAL.EQART; -- Obrigatório(N) - Tipo de objeto técnico
        tpFUNC_LOC_S_FUN_LOCATION.INVNR           := NVL(tpLOCAL.INVNR, ' '); -- Obrigatório(N) - Número de inventário
        tpFUNC_LOC_S_FUN_LOCATION.BRGEW           := tpLOCAL.BRGEW;  -- Obrigatório(N) - Peso do objeto
        tpFUNC_LOC_S_FUN_LOCATION.GEWEI           := tpLOCAL.GEWEI; -- Obrigatório(N) - Unidade de peso (formato ISO)
        tpFUNC_LOC_S_FUN_LOCATION.GROES           := tpLOCAL.GROES; -- Obrigatório(N) - Tamanho / dimensão
        tpFUNC_LOC_S_FUN_LOCATION.INBDT           := tpLOCAL.INBDT; -- Obrigatório(N) - Data de início do objeto técnico
        tpFUNC_LOC_S_FUN_LOCATION.SORTFIELD       := tpLOCAL.SORTFIELD; -- Obrigatório(N) - Campo de Classificação
        tpFUNC_LOC_S_FUN_LOCATION.BUKRS           := vCodigoEmpresa; -- Obrigatório(N) - Código da companhia
        tpFUNC_LOC_S_FUN_LOCATION.GSBER           := tpLOCAL.GSBER; -- Obrigatório(N) - Área de trabalho
        tpFUNC_LOC_S_FUN_LOCATION.KOSTL           := tpLOCAL.KOSTL; -- Obrigatório(N) - Centro de custo
                                         
        Begin
           INSERT INTO MIGDV.FUNC_LOC_S_FUN_LOCATION VALUES tpFUNC_LOC_S_FUN_LOCATION;
        exception       
          When OThers Then
             vErro := sqlerrm;
             rollback;
             insert into tdvadm.t_glb_sql values (vErro,
                                                  sysdate,
                                                  'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                  'SP_SAP_INSERE_LOCAL_INSTALACAO - Placa - ' || tpLOCAL.EXTERNAL_NUMBER);
                commit;
            
          End;        
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Local de instalação inserido com sucesso';
   END IF;
End SP_SAP_INSERE_LOCAL_INSTALACAO;


-- Insere PNEU
procedure SP_SAP_INSERE_PNEU(PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2) IS 
   i integer;
begin
  PRESULTADO := 'E';
  PMENSAGEM  := '';
  
    -- Inicio inserindo Pneu
    FOR vCursor2 IN (
      SELECT P.PNE_PNEUS_CODIGO CODIGO,
             P.PNE_PNEUS_SERIE SERIE,
             P.PNE_PNEUS_VALORCOMPRA VALORAQUISICAO,
             M.PNE_MARMODPNEU_DESCRICAO DESCRICAO,
             M.PNE_MARMODPNEU_FABRICANTE FABRICANTE,
             P.FRT_VEICULO_CODIGO codveiculo,
             v.frt_veiculo_placa placa,
             TO_CHAR(NVL(P.PNE_PNEUS_DATACOMPRA, TRUNC(SYSDATE)), 'YYYYMMDD') DT_AQUISICAO,
             M.PNE_MARMODPNEU_CODIGO MODELOCOD,
             'PNEU' EQART -- Pneus 
      FROM TDVADM.T_PNE_PNEUS P, 
           TDVADM.T_PNE_MARMODPNEU M,
           tdvadm.t_frt_veiculo v 
      WHERE P.PNE_MARMODPNEU_CODIGO = M.PNE_MARMODPNEU_CODIGO
        AND P.FRT_VEICULO_CODIGO = V.FRT_VEICULO_CODIGO (+)          
        and p.pne_pneus_status is null
    )
    LOOP
      -- Busca pela placa
      tpEQUIPMENT_S_EQUI := tpEQUIPMENT_S_EQUI2;
      tpEQUIPMENT_S_EQUI.EQUNR     := vCursor2.CODIGO; -- Obrigatório(S) - Identificador do equipamento no Leg
      tpEQUIPMENT_S_EQUI.EQTYP     := 'P'; -- Obrigatório(S) - Categoria de equipamento *
      tpEQUIPMENT_S_EQUI.EQKTX     := NVL(SUBSTR(vCursor2.DESCRICAO, 1, 40), ' '); -- Obrigatório(S) - Descrição do equipamento
      tpEQUIPMENT_S_EQUI.EQART     := vCursor2.EQART; -- Obrigatório(N) - Tipo de objeto técnico
      tpEQUIPMENT_S_EQUI.BEGRU     := ' '; -- Obrigatório(N) - Grupo de autorização de objeto técnico
      tpEQUIPMENT_S_EQUI.DATAB     := vCursor2.DT_AQUISICAO; -- Obrigatório(S) - Data de validade inicial
      tpEQUIPMENT_S_EQUI.GROES     := ' '; -- Obrigatório(N) - Tamanho / dimensão
      tpEQUIPMENT_S_EQUI.BRGEW     := 0; -- Obrigatório(N) - Peso do objeto 
      tpEQUIPMENT_S_EQUI.GEWEI     := ' '; -- Obrigatório(N) - Unidade de peso (formato ISO)
      tpEQUIPMENT_S_EQUI.INVNR     := ' '; -- Obrigatório(N) - Identificador de inventário
      tpEQUIPMENT_S_EQUI.INBDT     := vCursor2.DT_AQUISICAO; -- Obrigatório(N) - Data de início do objeto técnico
      tpEQUIPMENT_S_EQUI.ANSWT     := NVL(vCursor2.VALORAQUISICAO, 0); -- Obrigatório(N) - Valor de aquisição
      tpEQUIPMENT_S_EQUI.WAERS     := vMoeda; -- Obrigatório(N) - Identificador da moeda (formato ISO)
      tpEQUIPMENT_S_EQUI.HERST     := NVL(vCursor2.FABRICANTE, ' '); -- Obrigatório(N) - Fabricante do ativo
      tpEQUIPMENT_S_EQUI.HERLD     := vPais; -- Obrigatório(N) - País de fabricação
      tpEQUIPMENT_S_EQUI.TYPBZ     := NVL(TO_CHAR(vCursor2.MODELOCOD), ' '); -- Obrigatório(N) - Número do modelo do fabricante
      tpEQUIPMENT_S_EQUI.BAUJJ     := ' '; -- Obrigatório(N) - Ano de fabricação
      tpEQUIPMENT_S_EQUI.BAUMM     := ' '; -- Obrigatório(N) - Mês de fabricação
      tpEQUIPMENT_S_EQUI.MAPAR     := ' '; -- Obrigatório(N) - Número da peça do fabricante (part number)
      tpEQUIPMENT_S_EQUI.SERGE     := NVL(TRIM(vCursor2.SERIE), ' '); -- Obrigatório(N) - Número de série do fabricante
      tpEQUIPMENT_S_EQUI.SORTFIELD := ' '; -- Obrigatório(N) - Campo de Classificação
      tpEQUIPMENT_S_EQUI.BUKRS     := vCodigoEmpresa; -- Obrigatório(N) - Código da companhia
      tpEQUIPMENT_S_EQUI.ANLNR     := 0; -- Obrigatório(N) - Identificador do ativo principal
      If length(trim(nvl(vCursor2.codveiculo,' '))) > 3 Then 
         tpEQUIPMENT_S_EQUI.KOSTL     := '0110406501'; -- CONTROLE DE PNE -- Obrigatório(N) - Centro de custo
      Else
         tpEQUIPMENT_S_EQUI.KOSTL     := '0110406404'; -- BORRACHARIA -- Obrigatório(N) - Centro de custo
      End If;
      tpEQUIPMENT_S_EQUI.TPLNR     := nvl(vCursor2.Placa, ' '); -- Obrigatório(N) - Identificador do Local de Instalação
      tpEQUIPMENT_S_EQUI.MATNR     := vCursor2.CODIGO; -- Obrigatório(N) - Identificador de Material
      -- Número de série - Foi informado pelo Thiago da borracharia que não será migrado para o SAP
      tpEQUIPMENT_S_EQUI.GERNR     := ' ';--NVL(SUBSTR(vCursor2.SERIE, 1, 18), ' '); -- Obrigatório(N) - Número de série
                                              
      INSERT INTO MIGDV.EQUIPMENT_S_EQUI VALUES tpEQUIPMENT_S_EQUI;
      i := i + 1; 
      If mod(i,pQtdecommit) = 0 Then
         commit;
      End If; 
      
      PRESULTADO := 'N';
      PMENSAGEM  := 'PNEU INSERIDO COM SUCESSO.';
    END LOOP;
    commit;
    -- Fim Inserindo Pneu     
  
End SP_SAP_INSERE_PNEU;

-- Insere RASTREADOR
procedure SP_SAP_INSERE_RASTREADOR(PIDMATERIAL IN CHAR,
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2) IS 
begin
  PRESULTADO := '';
  PMENSAGEM  := '';
End SP_SAP_INSERE_RASTREADOR;                                   
                                   
-- Insere SEM PARAR
procedure SP_SAP_INSERE_SEM_PARAR(PIDMATERIAL IN CHAR,
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2) IS 
begin
  PRESULTADO := 'E';
  PMENSAGEM  := '';
  
    -- Inicio inserindo SEM PARAR
    --FOR vCursor2 IN (
      /*
      SELECT P.PNE_PNEUS_CODIGO CODIGO,
             P.PNE_PNEUS_SERIE SERIE,
             P.PNE_PNEUS_VALORCOMPRA VALORAQUISICAO,
             M.PNE_MARMODPNEU_DESCRICAO DESCRICAO,
             M.PNE_MARMODPNEU_FABRICANTE FABRICANTE,
             P.FRT_VEICULO_CODIGO codveiculo,
             v.frt_veiculo_placa placa,
             M.PNE_MARMODPNEU_CODIGO MODELOCOD
      FROM TDVADM.T_PNE_PNEUS P, 
           TDVADM.T_PNE_MARMODPNEU M,
           tdvadm.t_frt_veiculo v 
      WHERE P.PNE_MARMODPNEU_CODIGO = M.PNE_MARMODPNEU_CODIGO
        AND P.FRT_VEICULO_CODIGO = V.FRT_VEICULO_CODIGO (+)          
        and p.pne_pneus_status is null
      */
      
      --SELECT --MAX(p.ipf_sparar_data),
      --       p.ipf_sparar_tag CODIGO,
      --       p.ipf_sparar_placa PLACA,
             
      --       '' SERIE,
      --       '' VALORAQUISICAO,
      --       '' DESCRICAO,
      --       '' FABRICANTE,
      --       '' codveiculo,
      --       '' MODELOCOD
      --FROM tdvipf.t_ipf_sparar p
      --WHERE p.ipf_sparar_tag = '0002785417'
      --GROUP BY  p.ipf_sparar_tag;
    --)
    --LOOP
      -- Busca pela placa
      /*
      tpEQUIPMENT_S_EQUI := tpEQUIPMENT_S_EQUI2;
      tpEQUIPMENT_S_EQUI.EQUNR     := vCursor2.CODIGO; -- Obrigatório(S) - Identificador do equipamento no Leg
      tpEQUIPMENT_S_EQUI.EQTYP     := 'P'; -- Obrigatório(S) - Categoria de equipamento *
      tpEQUIPMENT_S_EQUI.EQKTX     := NVL(SUBSTR(vCursor2.DESCRICAO, 1, 40), ' '); -- Obrigatório(S) - Descrição do equipamento
      tpEQUIPMENT_S_EQUI.EQART     := 'NAO SEI'; -- Obrigatório(N) - Tipo de objeto técnico
      tpEQUIPMENT_S_EQUI.BEGRU     := 'NAO SEI'; -- Obrigatório(N) - Grupo de autorização de objeto técnico
      tpEQUIPMENT_S_EQUI.DATAB     := 'NAO SEI'; -- Obrigatório(S) - Data de validade inicial
      tpEQUIPMENT_S_EQUI.GROES     := ' '; -- Obrigatório(N) - Tamanho / dimensão
      tpEQUIPMENT_S_EQUI.BRGEW     := 0; -- Obrigatório(N) - Peso do objeto 
      tpEQUIPMENT_S_EQUI.GEWEI     := ' '; -- Obrigatório(N) - Unidade de peso (formato ISO)
      tpEQUIPMENT_S_EQUI.INVNR     := ' '; -- Obrigatório(N) - Identificador de inventário
      tpEQUIPMENT_S_EQUI.INBDT     := ' '; -- Obrigatório(N) - Data de início do objeto técnico
      tpEQUIPMENT_S_EQUI.ANSWT     := NVL(vCursor2.VALORAQUISICAO, 0); -- Obrigatório(N) - Valor de aquisição
      tpEQUIPMENT_S_EQUI.WAERS     := vMoeda; -- Obrigatório(N) - Identificador da moeda (formato ISO)
      tpEQUIPMENT_S_EQUI.HERST     := NVL(vCursor2.FABRICANTE, ' '); -- Obrigatório(N) - Fabricante do ativo
      tpEQUIPMENT_S_EQUI.HERLD     := vPais; -- Obrigatório(N) - País de fabricação
      tpEQUIPMENT_S_EQUI.TYPBZ     := NVL(TO_CHAR(vCursor2.MODELOCOD), ' '); -- Obrigatório(N) - Número do modelo do fabricante
      tpEQUIPMENT_S_EQUI.BAUJJ     := ' '; -- Obrigatório(N) - Ano de fabricação
      tpEQUIPMENT_S_EQUI.BAUMM     := ' '; -- Obrigatório(N) - Mês de fabricação
      tpEQUIPMENT_S_EQUI.MAPAR     := ' '; -- Obrigatório(N) - Número da peça do fabricante (part number)
      tpEQUIPMENT_S_EQUI.SERGE     := NVL(TRIM(vCursor2.SERIE), ' '); -- Obrigatório(N) - Número de série do fabricante
      tpEQUIPMENT_S_EQUI.SORTFIELD := 'NAO SEI'; -- Obrigatório(N) - Campo de Classificação
      tpEQUIPMENT_S_EQUI.BUKRS     := vCodigoEmpresa; -- Obrigatório(N) - Código da companhia
      tpEQUIPMENT_S_EQUI.ANLNR     := 0; -- Obrigatório(N) - Identificador do ativo principal
      tpEQUIPMENT_S_EQUI.KOSTL     := 'NAO SEI'; -- Obrigatório(N) - Centro de custo
      tpEQUIPMENT_S_EQUI.TPLNR     := nvl(vCursor2.Placa, ' '); -- Obrigatório(N) - Identificador do Local de Instalação
      tpEQUIPMENT_S_EQUI.MATNR     := vCursor2.CODIGO; -- Obrigatório(N) - Identificador de Material
      -- Número de série - Foi informado pelo Thiago da borracharia que não será migrado para o SAP
      tpEQUIPMENT_S_EQUI.GERNR     := ' ';--NVL(SUBSTR(vCursor2.SERIE, 1, 18), ' '); -- Obrigatório(N) - Número de série
                                              
      INSERT INTO MIGDV.EQUIPMENT_S_EQUI VALUES tpEQUIPMENT_S_EQUI;
      COMMIT;
      
      PRESULTADO := 'N';
      PMENSAGEM  := 'PNEU INSERIDO COM SUCESSO.';
      */
    --END LOOP;
    -- Fim Inserindo SEM PARAR
End SP_SAP_INSERE_SEM_PARAR;

-- Insere MIX
procedure SP_SAP_INSERE_MIX(PIDMATERIAL IN CHAR,
                            PRESULTADO OUT Char,
                            PMENSAGEM OUT VARCHAR2) IS 
begin
  PRESULTADO := '';
  PMENSAGEM  := '';
End SP_SAP_INSERE_MIX; 
                            
-- Insere Material
procedure SP_SAP_INSERE_MATERIAL(PIDMATERIAL IN CHAR,
                                 PRESULTADO OUT Char,
                                 PMENSAGEM OUT VARCHAR2) is
                                 
vIdentificadorMaterial number;                                        
tpMATERIAL_S_MARA MIGDV.MATERIAL_S_MARA%ROWTYPE; -- Dados do Material 
tpMATERIAL_S_MARM MIGDV.MATERIAL_S_MARM%ROWTYPE; -- não vou preencher mais conforme #1165
tpMATERIAL_S_MARD MIGDV.MATERIAL_S_MARD%ROWTYPE; -- Informado pela ana que no momento não vamos gerar dados para essa estrutura
tpMATERIAL_S_MLAN MIGDV.MATERIAL_S_MLAN%ROWTYPE; -- Dados de classificação fiscal do material
tpMATERIAL_S_MAKT MIGDV.MATERIAL_S_MAKT%ROWTYPE; -- Lista de descrições do material
tpMATERIAL_S_MBEW migdv.MATERIAL_S_MBEW%rowtype; -- Dados Contabeis
   i integer;
begin  
    FOR vCursor IN (   
      SELECT M.CODIGOMATINT,
             M.CODIGOINTERNOMATERIAL CODIGOINTERNOMATERIAL,            
             M.DIGITOVERMAT,             
             M.DESCRICAOMAT DESCRICAO,
             'PT' IDIOMA,       
             vPais PAIS,  
             '0001' BWKEY, -- Planta Localizacao
             '0001' werks, -- Planta -- 0001	TDV São Paulo - SP
                                     -- 0127	TDV Parauapebas - PA
                                     -- 0019  TDV Santos
                                     -- 0070  TV Contagem
             'TDV São Paulo' LGORT,
             decode(M.TPMATERIAL,'D','ZADM',   -- Material de escritorio
                                 'M','ZMANUT', -- Pecas de Manutencao
                                 'P','ZMANUT', -- Pecas de Manutencao
                                 'N','ZPNEU',  -- Pneu
                                 'O','ZMANUT', -- Pecas de Manutencao
                                 'T','ZMANUT', -- Pecas de Manutencao
                                 M.TPMATERIAL) GROUP_,           
                                 -- ZTM_A - Material para Armazenagem ( do Cliente)
                                 -- ZTM_M - Material de Transporte ( Produto transportado do Cliente)
                                 -- ZATIVO - Ativo Fixo
                                 -- ZMOVEIS - 
                                 -- ZRH -
             decode(M.TPMATERIAL,'D','3108', -- Materiais e Equipamentos
                                 'M','1100', -- Peças para Manutenção de
                                 'P','1100', -- Peças para Manutenção de
                                 'N','1100', -- Peças para Manutenção de
                                 'O','1100', -- Peças para Manutenção de
                                 'T','1100', -- Peças para Manutenção de
                                 M.TPMATERIAL) BKLAS,
                                 -- 1104 - Combustível
                                 -- 3101 - Lubrificantes
                                 -- 3102 - Gás para Empilhadeiras
                                 -- 3231 - Materiais de Limpeza
             M.CODIGOUM UNIDADE_MEDIDA,
             M.CODIGOUMCOMPRA UNIDADE_MEDIDA_COMPRA,
             decode(M.TPMATERIAL,'D','HIBE', -- Mat. aux de consumo
                                 'M','ZTDV', -- Pecas de Manutencao Alterado Chamado #1164  'ERSA', -- Pecas de reposicao
                                 'P','ZTDV', -- Pecas de Manutencao
                                 'N','ZTDV', -- Pecas de Manutencao Alterado Chamado #1164  'ERSA', -- Pecas de reposicao
                                 'O','ZTDV',
                                 'T','ZTDV', -- Pecas de Manutencao Alterado Chamado #1164  'ERSA', -- Pecas de reposicao
                                 M.TPMATERIAL) TIPO_MATERIAL,
             decode(M.TPMATERIAL,'D','ZADM'  , -- Material de escritorio
                                 'M','ZMANUT', -- Pecas de manutencao
                                 'P','ZMANUT', -- Pecas de Manutencao
                                 'N','ZPNEU' , -- Pneu
                                 'O','ZMANUT',-- Pecas de Manutencao Alterado Chamado #1164 'YBFA10', -- Bens de baixo valor
                                 'T','ZMANUT',-- Pecas de Manutencao Alterado Chamado #1164 'YBFA10', -- Bens de baixo valor
                                 M.TPMATERIAL) MATKL,
             M.CODIGOANP ANP,
             M.PESOBRUTO PESOBRUTO,
             M.PESOLIQUIDO PESOLIQUIDO,
             M.CODEAN CODEAN,
             M.CODEANTRIB
      FROM BGM.EST_CADMATERIAL M
      --WHERE M.DATACADASTROMAT  >= TO_DATE('01/06/2019', 'dd/mm/yyyy')
    )
    LOOP
        for vCursor2 in (
            select C.MATNR
            INTO vIdentificadorMaterial
            FROM MIGDV.MATERIAL_S_MARA C
            order by to_number(C.MATNR) desc
          )
          loop
            vIdentificadorMaterial := vCursor2.MATNR;
            exit;
          end loop;
          
        vIdentificadorMaterial := nvl(vIdentificadorMaterial, 0)+1;
        
        tpMATERIAL_S_MARA.MATNR    := vIdentificadorMaterial; -- Obrigatório(S) - Identificador do Material
        tpMATERIAL_S_MARA.SPRAS    := vCursor.IDIOMA; -- Obrigatório(S) - Chave de idioma *
        tpMATERIAL_S_MARA.MAKTX    := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' ');--vCursor.Descricaomat; -- Obrigatório(S) - Descrição do material*
        tpMATERIAL_S_MARA.MBRSH    := 'T';--indica setor de transporte Ana falou para mandar T-- Obrigatório(S) - Setor industrial*
        tpMATERIAL_S_MARA.MTART    := NVL(vCursor.TIPO_MATERIAL, ' ');--vCursor.Tpmaterial; -- Obrigatório(S) - Tipo de material*
        tpMATERIAL_S_MARA."GROUP"  := '01'; -- Obrigatório(N) - Visualizações de material
        tpMATERIAL_S_MARA.MATKL    := vCursor.MATKL; -- Obrigatório(N) - Grupo de material
        tpMATERIAL_S_MARA.EAN11    := NVL(vCursor.CODEAN,'00000000000'); -- Obrigatório(N) - Identificador internacional do artigo (EAN / UPC)
        tpMATERIAL_S_MARA.NUMTP    := ' '; -- Obrigatório(N) - Categoria EAN
        tpMATERIAL_S_MARA.MEINS    := NVL(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigatório(S) - Unidade de medida básica (formato ISO) *
        tpMATERIAL_S_MARA.BISMT    := vCursor.CODIGOINTERNOMATERIAL; -- Obrigatório(N) - Número de material no legado
        tpMATERIAL_S_MARA.BRGEW    := 0; -- Obrigatório(N) - Peso bruto
        tpMATERIAL_S_MARA.NTGEW    := 0; -- Obrigatório(N) - Peso líquido
        tpMATERIAL_S_MARA.GEWEI    := ' '; -- Obrigatório(N) - Unidade de Peso
        tpMATERIAL_S_MARA.VOLUM    := 0; -- Obrigatório(N) - Volume
        tpMATERIAL_S_MARA.VOLEH    := 0; -- Obrigatório(N) - Unidade de volume
        tpMATERIAL_S_MARA.GROES    := ' '; -- Obrigatório(N) - Tamanho / dimensões
        tpMATERIAL_S_MARA.LAENG    := 0; -- Obrigatório(N) - comprimento
        tpMATERIAL_S_MARA.BREIT    := 0; -- Obrigatório(N) - Largura
        tpMATERIAL_S_MARA.HOEHE    := 0; -- Obrigatório(N) - Altura
        tpMATERIAL_S_MARA.MEABM    := ' '; -- Obrigatório(N) - Unidade para comprimento / largura / altura (ISO)
        tpMATERIAL_S_MARA.KZKFG    := ' '; -- Obrigatório(N) - O material é configurável
        tpMATERIAL_S_MARA.ANP      := ' '; -- Obrigatório(N) - Código ANP
        tpMATERIAL_S_MARA.BSTME    :=  NVL(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigatório(N) - Unidade de ordem (formato ISO)
        tpMATERIAL_S_MARA.MFRPN    := ' '; -- Obrigatório(N) - Número da peça de fabricante (part number)
        tpMATERIAL_S_MARA.MFRNR    := ' '; -- Obrigatório(N) - Número do fabricante
        tpMATERIAL_S_MARA.MPROF    := ' '; -- NAO SERA USADO NA DELLA VOLPE-- Obrigatório(N) - Perfil da peça
        tpMATERIAL_S_MARA.ETIAR    := ' '; -- NAO SERA USADO NA DELLA VOLPE-- Obrigatório(N) - Tipo de etiqueta
        tpMATERIAL_S_MARA.ETIFO    := ' '; -- NAO SERA USADO NA DELLA VOLPE -- Obrigatório(N) - Formulário de etiqueta

        If tpMATERIAL_S_MARA.VOLUM = 0 Then
           tpMATERIAL_S_MARA.VOLEH := ' ';
        End If;
                                          
        INSERT INTO MIGDV.MATERIAL_S_MARA VALUES tpMATERIAL_S_MARA;
                
/*   não vou preencher mais conforme #1165
  
      -- Unidades de medida do material 
        tpMATERIAL_S_MARM.MATNR := vIdentificadorMaterial; -- Obrigatório(S) - Identificador do Material
        tpMATERIAL_S_MARM.MEINH := NVL(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigatório(S) - Unidade de medida alternativa (formato ISO) *
        tpMATERIAL_S_MARM.UMREN := 1; -- Obrigatório(S) - Denominador para conversão em unidade base *
        tpMATERIAL_S_MARM.UMREZ := 1; -- Obrigatório(S) - Numerador para conversão em unidade base *
        tpMATERIAL_S_MARM.EAN11 := NVL(vCursor.CODEAN,'00000000000'); -- Obrigatório(N) - Número internacional do artigo (EAN / UPC)
        tpMATERIAL_S_MARM.NUMTP := ' '; -- Obrigatório(N) - Categoria EAN
        tpMATERIAL_S_MARM.LAENG := 0; -- Obrigatório(N) - comprimento
        tpMATERIAL_S_MARM.BREIT := 0; -- Obrigatório(N) - Largura 
        tpMATERIAL_S_MARM.HOEHE := 0; -- Obrigatório(N) - Altura
        tpMATERIAL_S_MARM.MEABM := nvl(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigatório(N) - Unidade para comprimento / largura / altura (ISO) 
        tpMATERIAL_S_MARM.VOLUM := 0; -- Obrigatório(N) - Volume
        tpMATERIAL_S_MARM.VOLEH := nvl(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigatório(N) - Unidade de volume
        tpMATERIAL_S_MARM.BRGEW := ' '; -- Obrigatório(N) - Peso bruto
        tpMATERIAL_S_MARM.GEWEI := ' '; -- Obrigatório(N) - Unidade de Peso
        
        SP_SAP_INSERE_MATERIAL_UNIDADE_MEDIDA(tpMATERIAL_S_MARM, PRESULTADO, PMENSAGEM);
*/        

        -- Dados de localização do Material 
        /* Informado pela ana que no momento não vamos gerar dados para essa estrutura
        tpMATERIAL_S_MARD.MATNR := vIdentificadorMaterial; -- Obrigatório(S) - Identificador do Material
        tpMATERIAL_S_MARD.WERKS := ' '; -- SOLICITADO PARA ENVIAR EM BRANCO-- Obrigatório(S) - Planta
        tpMATERIAL_S_MARD.LGORT := ' '; -- SOLICITADO PARA ENVIAR EM BRANCO-- Obrigatório(S) - Local de armazenamento*werks
        
        SP_SAP_INSERE_MATERIAL_DADOS_LOCALIZACAO(tpMATERIAL_S_MARD, PRESULTADO, PMENSAGEM);
        */ 
        -- Dados de classificação fiscal do material.
        tpMATERIAL_S_MLAN.MATNR  := vIdentificadorMaterial; -- Obrigatório(S) - Identificador do Material
        tpMATERIAL_S_MLAN.ALAND  := vCursor.PAIS; -- Obrigatório(S) - País de partida *
        tpMATERIAL_S_MLAN.TATYP1 := '1'; -- Obrigatório(S) - Categoria fiscal 1 *
        tpMATERIAL_S_MLAN.TAXM1  := '1'; -- Obrigatório(S) - Classificação fiscal 1 *
        tpMATERIAL_S_MLAN.TATYP2 := ' '; -- Obrigatório(N) - Categoria fiscal 2
        tpMATERIAL_S_MLAN.TAXM2  := ' '; -- Obrigatório(N) - Classificação fiscal 2
        tpMATERIAL_S_MLAN.TATYP3 := ' '; -- Obrigatório(N) - Categoria fiscal 3
        tpMATERIAL_S_MLAN.TAXM3  := ' '; -- Obrigatório(N) - Classificação fiscal 3
        tpMATERIAL_S_MLAN.TATYP4 := ' '; -- Obrigatório(N) - Categoria fiscal 4
        tpMATERIAL_S_MLAN.TAXM4  := ' '; -- Obrigatório(N) - Classificação fiscal 4
        tpMATERIAL_S_MLAN.TATYP5 := ' '; -- Obrigatório(N) - Categoria fiscal 5
        tpMATERIAL_S_MLAN.TAXM5  := ' '; -- Obrigatório(N) - Classificação fiscal 5
        tpMATERIAL_S_MLAN.TATYP6 := ' '; -- Obrigatório(N) - Categoria fiscal 6
        tpMATERIAL_S_MLAN.TAXM6  := ' '; -- Obrigatório(N) - Classificação fiscal 6
        tpMATERIAL_S_MLAN.TAXIM  := ' '; -- Obrigatório(N) - Código de imposto para material (Compras) 
        
        SP_SAP_INSERE_MATERIAL_CLASSIFICACAO_FISCAL(tpMATERIAL_S_MLAN, PRESULTADO, PMENSAGEM);
        
        -- Lista de descrições do material 
        tpMATERIAL_S_MAKT.MATNR := vIdentificadorMaterial; -- Obrigatório(S) - Identificador do Material                
        tpMATERIAL_S_MAKT.SPRAS := 'PT'; -- Obrigatório(S) - Identificador do Idioma
        tpMATERIAL_S_MAKT.MAKTX := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' ');  -- Obrigatório(S) - Descrição do material  
        
        SP_SAP_INSERE_MATERIAL_LISTA_DESCRICAO(tpMATERIAL_S_MAKT, PRESULTADO, PMENSAGEM);


        -- Dados Contabeis
        tpMATERIAL_S_MBEW.Matnr := vIdentificadorMaterial; --identificador do material
        tpMATERIAL_S_MBEW.Bwkey := vcursor.bwkey; -- área de avaliação
        tpMATERIAL_S_MBEW.Bklas := vCursor.bklas; -- classe de avaliação
        tpMATERIAL_S_MBEW.Vprsv := 'v'; -- indicador de controle de preços. 
                                        -- domínio: s - standart 
                                        --          v - preço médio variável / preço unitário periódico
        tpMATERIAL_S_MBEW.Mtuse := '2'; -- utilização do material. 
                                        -- domínio: 0 - revenda; 
                                        --          2 - consumo; 
                                        --          3 - imobilizado; 
                                        --          4 - consumo para atividade principal
        tpMATERIAL_S_MBEW.Mtorg := '0'; -- origem do material.
                                        -- domínio 0 - nacional, exceto indicados nos códigos 3, 4, 5 e 8; 
                                        --         1 - estrangeiro importação direta; 
                                        --         2 - estrangeiro aquisição mercado interno; 
                                        --         3 - nacional com quota de importação entre 40 e 70%, inclusive
                                        --         4 - nacional com incentivo de imposto
                                        --         5 - nacional com conteúdo de importação inferior ou igual a 40%
                                        --         8 - nacional com quota de importação maior que 70%


       insert into migdv.MATERIAL_S_MBEW values tpMATERIAL_S_MBEW;
              
        PRESULTADO := 'N';
        PMENSAGEM  := 'Material inserido com sucesso';        

        i := i + 1;
        If mod(i,pQtdecommit) = 0 Then
           commit;
        End If; 
       
   END LOOP; 
   commit;
End SP_SAP_INSERE_MATERIAL;

-- Insere Unidade de medida do Material
procedure SP_SAP_INSERE_MATERIAL_UNIDADE_MEDIDA(P_TPMATERIAL_S_MARM IN MIGDV.MATERIAL_S_MARM%ROWTYPE,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
vIdentificadorMaterial number;      
vCount number;                                       
begin    
    SELECT COUNT(*)
      INTO vCount             
    FROM MIGDV.MATERIAL_S_MARM C
    WHERE C.MATNR = P_TPMATERIAL_S_MARM.MATNR;
    
    vCount := NVL(vCount, 0);
              
    IF vCount = 0 THEN
                                                       
      INSERT INTO MIGDV.MATERIAL_S_MARM VALUES P_TPMATERIAL_S_MARM;
                
      PRESULTADO := 'N';
      PMENSAGEM  := 'Unidade de medida inserido com sucesso';
    END IF;   
End SP_SAP_INSERE_MATERIAL_UNIDADE_MEDIDA;


-- Insere Dados de localização do Material
procedure SP_SAP_INSERE_MATERIAL_DADOS_LOCALIZACAO(P_TPMATERIAL_S_MARD IN MIGDV.MATERIAL_S_MARD%ROWTYPE,
                                                   PRESULTADO OUT Char,
                                                   PMENSAGEM OUT VARCHAR2) is
vIdentificadorMaterial number;                                        
vCount number;
begin

    SELECT COUNT(*)
      INTO vCount
    FROM MIGDV.MATERIAL_S_MARD C
    WHERE C.MATNR = P_TPMATERIAL_S_MARD.MATNR;
    
    vCount := NVL(vCount, 0);
              
    IF vCount = 0 THEN
                                         
      INSERT INTO MIGDV.MATERIAL_S_MARD VALUES P_TPMATERIAL_S_MARD;
              
      PRESULTADO := 'N';
      PMENSAGEM  := 'Dados da localização do material inserido com sucesso';        
    END IF;
  
End SP_SAP_INSERE_MATERIAL_DADOS_LOCALIZACAO;


-- Insere Classificação fiscal do Material
procedure SP_SAP_INSERE_MATERIAL_CLASSIFICACAO_FISCAL(P_TPMATERIAL_S_MLAN IN MIGDV.MATERIAL_S_MLAN%ROWTYPE,
                                                      PRESULTADO OUT Char,
                                                      PMENSAGEM OUT VARCHAR2) is
vIdentificadorMaterial number;
vCount number;                                        
begin

    SELECT COUNT(*)   
      INTO vCount          
    FROM MIGDV.MATERIAL_S_MLAN C
    WHERE C.MATNR = P_TPMATERIAL_S_MLAN.MATNR;
   
    vCount := NVL(vCount, 0);
              
    IF vCount = 0 THEN                  
        INSERT INTO MIGDV.MATERIAL_S_MLAN VALUES P_TPMATERIAL_S_MLAN;
                
        PRESULTADO := 'N';
        PMENSAGEM  := 'Classificação fiscal do material inserido com sucesso';        
        
    END IF; 
    
End SP_SAP_INSERE_MATERIAL_CLASSIFICACAO_FISCAL;


-- Insere Lista de descrições do Material
procedure SP_SAP_INSERE_MATERIAL_LISTA_DESCRICAO(P_TPMATERIAL_S_MAKT IN MIGDV.MATERIAL_S_MAKT%ROWTYPE,
                                                 PRESULTADO OUT Char,
                                                 PMENSAGEM OUT VARCHAR2) is
vIdentificadorMaterial number;                                        
vCount number;                                        
begin
      SELECT COUNT(*)  
        INTO vCount           
      FROM MIGDV.MATERIAL_S_MAKT C
      WHERE C.MATNR = P_TPMATERIAL_S_MAKT.MATNR;
    
      vCount := NVL(vCount, 0);
              
      IF vCount = 0 THEN                                         
        INSERT INTO MIGDV.MATERIAL_S_MAKT VALUES P_TPMATERIAL_S_MAKT;
        
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Lista de descricoes do material inserido com sucesso';        
        
      END IF;
    
End SP_SAP_INSERE_MATERIAL_LISTA_DESCRICAO;

-- Insere Documentos Contas Pagar
procedure SP_SAP_INSERE_CONTAS_PAGAR_DOCUMENTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
   vIdentificadorCompanhia number;                                        
   tpOPEN_ITEM_AP_S_BSIK MIGDV.OPEN_ITEM_AP_S_BSIK%ROWTYPE;
   tpOPEN_ITEM_AP_S_BSET MIGDV.OPEN_ITEM_AP_S_BSET%ROWTYPE;
   tpOPEN_ITEM_AP_S_WITH_ITEM MIGDV.OPEN_ITEM_AP_S_WITH_ITEM%rowtype;

   i integer;
   vContador  integer;
begin
    i := 0;
    
    delete tdvadm.t_glb_sql s
    where s.glb_sql_observacao like '%SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS%';
    delete MIGDV.OPEN_ITEM_AP_S_BSIK;
    delete MIGDV.OPEN_ITEM_AP_S_BSET;
    delete MIGDV.OPEN_ITEM_AP_S_WITH_ITEM;

    select count(*)
      into i
    from MIGDV.T_TDV_CONTAAPAGAR x
    where x.datagolive = migdv.pkg_migracao_sap.get_data_golive;
    If i = 0 then
--    drop table MIGDV.T_TDV_CONTAAPAGAR;
--    create table MIGDV.T_TDV_CONTAAPAGAR as
       insert into MIGDV.T_TDV_CONTAAPAGAR
       select x.TIPO,
              x.ANO,
              x.DATA_EMISSÃO,
              x.DATA_CADASTRO,
              x.DOCUMENTO,
              x.SERIE,
              x.ROTA,
              x.SQ,
              x.CPF_CNPJ,
              x.NOME,
              round(x.IR,2),
              round(x.INSS,2),
              round(x.PARTEEMPINSS,2),
              round(x.SESTSENAT,2),
              round(x.PIS,2),
              round(x.COFINS,2),
              round(x.CSLL,2),
              round(x.MULTAS,2),
              x.GERACAO,
              x.ADIANTAMENTO_DATA,
              round(x.ADIANTAMENTO_VALOR,2),
              x.PEDAGIO_DATA,
              round(x.PEDAGIO_VALOR,2),
              x.PARCELAS_DATA,
              round(x.PARCELAS_VALOR,2),
              x.CANC,
              round(x.VALOR,2),
              round(x.SALDO,2),
              x.Bloqueio,
              x.DATAGOLIVE
       from migdv.V_CTB_CONTASAPAGARVF x;
       insert into MIGDV.T_TDV_CONTAAPAGAR
       Select x.tipo,
              x.ano,
              x.data_emissão,
              x.DATA_CADASTRO,
              x.TITULO,
              x.serie,
              x.ROTA,
              x.SQ,
              x.CNPJ,
              x.RAZAO_SOCIAL,
              round(x.IR,2),
              round(x.INSS,2),
              round(x.parteempinss,2),
              round(x.sestsenat,2),
              round(x.pis,2),
              round(x.cofins,2),
              round(x.CSLL,2),
              round(x.multa,2),
              x.geracao,
              x.adiantamento_data,
              round(x.adiantamento_valor,2),
              x.pedagio_data,
              round(x.pedagio_valor,2),
              x.parcelas_data,
              round(x.parcelas_valor,2),
              x.canc,
              round(x.valor,2),
              round(x.SALDO,2),
              x.bloqueio,
              x.datagolive
       from migdv.V_CTB_CONTASAPAGARCP x;
       
    End If;
    commit;
    
    FOR vCursor IN (select distinct *
                    from MIGDV.T_TDV_CONTAAPAGAR x
                    where x.datagolive = migdv.pkg_migracao_sap.get_data_golive
                    order by x.tipo,x.rota,x.documento)
    LOOP
        
        tpOPEN_ITEM_AP_S_BSIK.LIFNR := migdv.pkg_migracao_sap.fn_busca_codigoSAP(vCursor.Cpf_Cnpj,'E','BGM') ; -- Obrigatório(S) - Identificador do Cliente  
        if tpOPEN_ITEM_AP_S_BSIK.LIFNR is null Then
           tpOPEN_ITEM_AP_S_BSIK.LIFNR := migdv.pkg_migracao_sap.fn_busca_codigoSAP(vCursor.Cpf_Cnpj,'E','FOR') ; -- Obrigatório(S) - Identificador do Cliente  
        End If;     

       If tpOPEN_ITEM_AP_S_BSIK.LIFNR is not null Then
          Begin 
       
             tpOPEN_ITEM_AP_S_BSIK.BUKRS := vCodigoEmpresa; -- Obrigatório(S) - Código da companhia*
             tpOPEN_ITEM_AP_S_BSIK.WAERS := vMoeda ; -- Obrigatório(S) - Moeda do Documento
             tpOPEN_ITEM_AP_S_BSIK.HWAER := vMoeda ; -- Obrigatório(S) - Moeda local*
             tpOPEN_ITEM_AP_S_BSIK.HWAE2 := ' ' ; -- Obrigatório(N) - Moeda local 2
             tpOPEN_ITEM_AP_S_BSIK.DMBE2 := 0 ; -- Obrigatório(N) - Montante na moeda local 2
             tpOPEN_ITEM_AP_S_BSIK.HWAE3 := ' ' ; -- Obrigatório(N) - Moeda local 3
             tpOPEN_ITEM_AP_S_BSIK.DMBE3 := 0 ; -- Obrigatório(N) - Montante na moeda local 3
             tpOPEN_ITEM_AP_S_BSIK.MWSKZ := ' ' ; -- Obrigatório(N) - Código de Imposto
             tpOPEN_ITEM_AP_S_BSIK.ZLSPR := ' ' ; -- Obrigatório(N) - Bloqueio de pagamento

             tpOPEN_ITEM_AP_S_BSIK.BLART := vCursor.Tipo ; -- Obrigatório(S) - Tipo de documento*
             tpOPEN_ITEM_AP_S_BSIK.PRCTR := vCursor.Rota ; -- Obrigatório(N) - Centro de lucro
             tpOPEN_ITEM_AP_S_BSIK.BLDAT := to_char(vCursor.Data_Emissão,'YYYYMMDD') ; -- Obrigatório(S) - Data do documento* 
             tpOPEN_ITEM_AP_S_BSIK.BUDAT := to_char(vCursor.Data_Cadastro,'YYYYMMDD') ; -- Obrigatório(S) - Data de postagem*

             If tpOPEN_ITEM_AP_S_BSIK.BLART = 'VFRETE' Then
                tpOPEN_ITEM_AP_S_BSIK.XBLNR := vCursor.Documento || vCursor.Serie || vCursor.Rota || vCursor.Sq; -- Obrigatório(S) - Número do documento de referência *
                tpOPEN_ITEM_AP_S_BSIK.BKTXT := ' ' ; -- Obrigatório(N) - Texto do cabeçalho
                tpOPEN_ITEM_AP_S_BSIK.SGTXT := 'VF Total ' || to_char(vCursor.Valor) ; -- Obrigatório(N) - Texto do item
                If vCursor.Bloqueio is not null Then
                   tpOPEN_ITEM_AP_S_BSIK.SGTXT := tpOPEN_ITEM_AP_S_BSIK.SGTXT || ' Bloqueado em ' || to_char(vCursor.Bloqueio,'DD/MM/YYYY') ; -- Obrigatório(N) - Texto do item
                   tpOPEN_ITEM_AP_S_BSIK.ZLSPR := 'S' ; -- Obrigatório(N) - Bloqueio de pagamento
                Else
                   tpOPEN_ITEM_AP_S_BSIK.ZLSPR := ' ' ; -- Obrigatório(N) - Bloqueio de pagamento
                End If;
                -- DE PARA DAS CONTAS
                tpOPEN_ITEM_AP_S_BSIK.GKONT := '99900007' ; -- Obrigatório(S) - Conta de compensação *

             ElsIf tpOPEN_ITEM_AP_S_BSIK.BLART = 'CPAGAR' Then
                tpOPEN_ITEM_AP_S_BSIK.XBLNR := substr(trim(vCursor.Documento) || trim(vCursor.Cpf_Cnpj),1,16); -- Obrigatório(S) - Número do documento de referência *
                tpOPEN_ITEM_AP_S_BSIK.BKTXT := ' ' ; -- Obrigatório(N) - Texto do cabeçalho
                tpOPEN_ITEM_AP_S_BSIK.SGTXT := 'Contas a Pagar' ; -- Obrigatório(N) - Texto do item

                tpOPEN_ITEM_AP_S_BSIK.ZLSPR := ' ' ; -- Obrigatório(N) - Bloqueio de pagamento

                -- DE PARA DAS CONTAS
                tpOPEN_ITEM_AP_S_BSIK.GKONT := '99900007' ; -- Obrigatório(S) - Conta de compensação *
                
             End If;
            
             tpOPEN_ITEM_AP_S_BSIK.WRBTR := vCursor.Saldo ; -- Obrigatório(S) - Montante na moeda do documento
             tpOPEN_ITEM_AP_S_BSIK.DMBTR := vCursor.Saldo ; -- Obrigatório(S) - Montante na moeda local
             -- Ver as prestações
             tpOPEN_ITEM_AP_S_BSIK.ZFBDT := to_char(sysdate,'yyyymmdd') ; -- Obrigatório(N) - Data base
             tpOPEN_ITEM_AP_S_BSIK.ZLSCH := ' ' ; -- Obrigatório(N) - Método de pagamento
             tpOPEN_ITEM_AP_S_BSIK.ZTERM := ' ' ; -- Obrigatório(N) - Termos de pagamento
           
             INSERT INTO MIGDV.OPEN_ITEM_AP_S_BSIK VALUES tpOPEN_ITEM_AP_S_BSIK;

          
             If to_char(vCursor.Data_Cadastro,'YYYYMM') = vREFER_CTB Then

                tpOPEN_ITEM_AP_S_WITH_ITEM.BUKRS      := tpOPEN_ITEM_AP_S_BSIK.BUKRS; -- Obrigatório(S) - Código da companhia*
                tpOPEN_ITEM_AP_S_WITH_ITEM.Xblnr      := tpOPEN_ITEM_AP_S_BSIK.Xblnr; -- Obrigatório(S) - Número do documento de referência *
                tpOPEN_ITEM_AP_S_WITH_ITEM.Lifnr      := tpOPEN_ITEM_AP_S_BSIK.LIFNR; -- Obrigatório(S) - Identificador do Fornecedor*
                tpOPEN_ITEM_AP_S_WITH_ITEM.Bas_Amt_Tc := vCursor.Valor ;-- montante base do imposto retido na fonte - moeda do documento
                tpOPEN_ITEM_AP_S_WITH_ITEM.Bas_Amt_Lc := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Man_Amt_Lc := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Awh_Amt_Lc := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Bas_Amt_L2 := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Man_Amt_L2 := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Awh_Amt_L2 := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Bas_Amt_L3 := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Man_Amt_L3 := 0;--
                tpOPEN_ITEM_AP_S_WITH_ITEM.Awh_Amt_L3 := 0;--


                tpOPEN_ITEM_AP_S_WITH_ITEM.Wt_Type := ' ';-- tipo de imposto retido na fonte *
                If vCursor.Inss > 0 Then
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Wt_Type    := 'INSS';
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Wt_Code    := '1099'; -- Obrigatório(S) - código do imposto retido na fonte
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Man_Amt_Tc := 0;-- valor do imposto retido na fonte inserido manualmente - moeda do documento
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Awh_Amt_Tc := vCursor.Inss;-- valor do imposto retido na fonte já retido - moeda do documento
                   Insert into migdv.open_item_ap_s_with_item values tpOPEN_ITEM_AP_S_WITH_ITEM;
                End If;            
                
                If vCursor.Sestsenat > 0 Then
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Wt_Type    := 'SESTSENAT';
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Wt_Code    := '1099'; -- Obrigatório(S) - código do imposto retido na fonte
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Man_Amt_Tc := 0;-- valor do imposto retido na fonte inserido manualmente - moeda do documento
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Awh_Amt_Tc := vCursor.Sestsenat;-- valor do imposto retido na fonte já retido - moeda do documento
                   Insert into migdv.open_item_ap_s_with_item values tpOPEN_ITEM_AP_S_WITH_ITEM;
                End If;            
                
                If vCursor.Ir > 0 Then 
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Wt_Type    := 'IR';
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Wt_Code    := '0588'; -- Obrigatório(S) - código do imposto retido na fonte
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Man_Amt_Tc := 0;-- valor do imposto retido na fonte inserido manualmente - moeda do documento
                   tpOPEN_ITEM_AP_S_WITH_ITEM.Awh_Amt_Tc := vCursor.Ir;-- valor do imposto retido na fonte já retido - moeda do documento
                   Insert into migdv.open_item_ap_s_with_item values tpOPEN_ITEM_AP_S_WITH_ITEM;
                End If; 

                
             End If;


             If to_char(vCursor.Data_Cadastro,'YYYYMM') = vREFER_CTB Then

                -- Grava os impostos  
                tpOPEN_ITEM_AP_S_BSET.BUKRS := tpOPEN_ITEM_AP_S_BSIK.BUKRS; -- Obrigatório(S) - Código da companhia* 
                tpOPEN_ITEM_AP_S_BSET.XBLNR := tpOPEN_ITEM_AP_S_BSIK.Xblnr; -- Obrigatório(S) - Número do documento de referência *
                tpOPEN_ITEM_AP_S_BSET.LIFNR := tpOPEN_ITEM_AP_S_BSIK.LIFNR; -- Obrigatório(S) - Identificador do Fornecedor*
                tpOPEN_ITEM_AP_S_BSET.FWBAS := vCursor.Valor; -- Obrigatório(S) - Montante base do imposto - Moeda do documento
                tpOPEN_ITEM_AP_S_BSET.HWBAS := 0; -- Obrigatório(N) - Montante base do imposto - moeda local 
                tpOPEN_ITEM_AP_S_BSET.HWSTE := 0; -- Obrigatório(N) - Valor do imposto - moeda local 
                tpOPEN_ITEM_AP_S_BSET.H2BAS := 0; -- Obrigatório(N) - Montante base do imposto - moeda local 2
                tpOPEN_ITEM_AP_S_BSET.H2STE := 0; -- Obrigatório(N) - Valor do imposto - moeda local 2
                tpOPEN_ITEM_AP_S_BSET.H3BAS := 0; -- Obrigatório(N) - Montante base do imposto - moeda local 3
                tpOPEN_ITEM_AP_S_BSET.H3STE := 0; -- Obrigatório(N) - Valor do imposto - moeda local 3
                vContador := 0;
                If vCursor.Inss > 0  Then
                   tpOPEN_ITEM_AP_S_BSET.MWSKZ := '1099'; -- Obrigatório(S) - Código de Imposto*
                   tpOPEN_ITEM_AP_S_BSET.HKONT := '99900007'; -- Obrigatório(S) - Conta fiscal *
                   tpOPEN_ITEM_AP_S_BSET.GKONT2 := '99900007'; -- Obrigatório(S) - Conta do Razão para Compensação
                   tpOPEN_ITEM_AP_S_BSET.FWSTE := vCursor.Inss; -- Obrigatório(S) - Valor do imposto  - moeda do documento
                   vContador := vContador + 1;
                   tpOPEN_ITEM_AP_S_BSET.BUZEI := lpad(vContador,3,'0');
                   INSERT INTO MIGDV.OPEN_ITEM_AP_S_BSET VALUES tpOPEN_ITEM_AP_S_BSET;
                End If;
                If vCursor.Sestsenat > 0  Then
                   tpOPEN_ITEM_AP_S_BSET.MWSKZ := '1099'; -- Obrigatório(S) - Código de Imposto*
                   tpOPEN_ITEM_AP_S_BSET.HKONT := '99900007'; -- Obrigatório(S) - Conta fiscal *
                   tpOPEN_ITEM_AP_S_BSET.GKONT2 := '99900007'; -- Obrigatório(S) - Conta do Razão para Compensação
                   tpOPEN_ITEM_AP_S_BSET.FWSTE := vCursor.Sestsenat; -- Obrigatório(S) - Valor do imposto  - moeda do documento
                   vContador := vContador + 1;
                   tpOPEN_ITEM_AP_S_BSET.BUZEI := lpad(vContador,3,'0');
                   INSERT INTO MIGDV.OPEN_ITEM_AP_S_BSET VALUES tpOPEN_ITEM_AP_S_BSET;
                End If;
                If vCursor.Ir > 0  Then
                   tpOPEN_ITEM_AP_S_BSET.MWSKZ  := '0588'; -- Obrigatório(S) - Código de Imposto*
                   tpOPEN_ITEM_AP_S_BSET.HKONT  := '99900007'; -- Obrigatório(S) - Conta fiscal *
                   tpOPEN_ITEM_AP_S_BSET.GKONT2 := '99900007'; -- Obrigatório(S) - Conta do Razão para Compensação
                   tpOPEN_ITEM_AP_S_BSET.FWSTE  := vCursor.Ir; -- Obrigatório(S) - Valor do imposto  - moeda do documento
                   vContador := vContador + 1;
                   tpOPEN_ITEM_AP_S_BSET.BUZEI := lpad(vContador,3,'0');
                   INSERT INTO MIGDV.OPEN_ITEM_AP_S_BSET VALUES tpOPEN_ITEM_AP_S_BSET;
                End If; 

             End If;
             
             i := i + 1;
             If mod(i,pQtdecommit) = 0 Then
             commit;
             End If; 

          Exception
             When Others Then
                vErro := sqlerrm;
                rollback;
                insert into tdvadm.t_glb_sql values (vErro,
                                                     sysdate,
                                                     'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                     'SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS - ' || vCursor.Tipo || '-' || vCursor.documento  || '-' || vCursor.rota || '-' || vCursor.sq  );
                 commit;
          End;
       End If;

       PRESULTADO := 'N';
       PMENSAGEM  := 'Documentos contas pagar inserido com sucesso';        
    END LOOP;
    commit;
      
end SP_SAP_INSERE_CONTAS_PAGAR_DOCUMENTOS;


-- Insere Documentos Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
vIdentificadorCompanhia number;                                        
tpOPEN_ITEM_AR_S_BSID MIGDV.OPEN_ITEM_AR_S_BSID%ROWTYPE;                                        
tpGL_BALANCES_S_BSIS  migdv.gl_balances_s_bsis%rowtype;
   i integer;
begin

    delete tdvadm.t_glb_sql s
    where s.glb_sql_observacao like '%SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS%';
    delete MIGDV.Open_Item_Ar_s_Bsid;
    delete MIGDV.OPEN_ITEM_Ar_S_BSET;
    delete MIGDV.OPEN_ITEM_Ar_S_WITH_ITEM;

    select count(*)
      into i
    from MIGDV.T_TDV_CONTAARECEBER x
    where x.datagolive = migdv.pkg_migracao_sap.get_data_golive;
    If i = 0 Then
       insert into migdv.t_tdv_contaareceber
       select x.tipo,
              x.CTRC,
              x.SR,
              x.ROTA,
              x.EMBARQUE,
              x.CONTRATO,
              x.GRUPO,
              x.CNPJ,
              x.RAZAO_SOCIAL,
              x.TITULO,
              x.SQ,
              x.ROTA_TIT,
              x.EMISSAO,
              x.VENCIMENTO,
              x.BAIXA,
              x.PAGO,
              x.VALORTIT,
              x.VALOR,
              x.PAGAMENTOS,
              x.DESCONTO,
              x.ACRESCIMO,
              x.JUROS,
              x.SALDO,
              x.ISS,
              x.Retido,
              x.DATAGOLIVE
       from migdv.V_CTB_FATURADO x;
       insert into migdv.t_tdv_contaareceber
       select x.tipo,
              x.CTRC,
              x.SR,
              x.ROTA,
              x.embarque,
              x.contrato,
              x.grupo,
              x.CNPJ,
              x.RAZAO_SOCIAL,
              x.titulo,
              x.SQ,
              x.ROTA_TIT,
              x.EMISSAO,
              x.VENCIMENTO,
              x.baixa,
              x.pago,
              x.VALORTIT,
              x.VALOR,
              x.pagamentos,
              x.descontos,
              x.acrescimo,
              x.juros,
              x.saldo,
              x.ISS,
              x.RETIDO,
              x.DATAGOLIVE
       from migdv.v_ctb_afaturar x;
       commit;
    End If;    



        

    FOR vCursor IN (select *
                    from migdv.t_tdv_contaareceber x
                    where x.datagolive = migdv.pkg_migracao_sap.get_data_golive 
                    order by x.tipo)
    LOOP

        tpOPEN_ITEM_AR_S_BSID.Kunnr := migdv.pkg_migracao_sap.fn_busca_codigoSAP(vCursor.Cnpj,'C','CLI') ; -- Obrigatório(S) - Identificador do Cliente  

        tpOPEN_ITEM_AR_S_BSID.BLART := vCursor.Tipo ; -- Obrigatório(S) - Tipo de documento*
            
        If tpOPEN_ITEM_AR_S_BSID.BLART = 'AFATURAR' Then
           tpOPEN_ITEM_AR_S_BSID.XBLNR := vCursor.Rota ||vCursor.Ctrc ; -- Obrigatório(S) - Número do documento de referência *
           tpOPEN_ITEM_AR_S_BSID.ZLSPR := 'S' ; -- Obrigatório(N) - Bloqueio de pagamento
           tpOPEN_ITEM_AR_S_BSID.PRCTR := vCursor.Rota ; -- Obrigatório(N) - Centro de lucro
           tpOPEN_ITEM_AR_S_BSID.BLDAT := to_char(vCursor.Embarque,'yyymmdd') ; -- Obrigatório(S) - Data do documento* 
           tpOPEN_ITEM_AR_S_BSID.BUDAT := to_char(vCursor.Embarque,'yyymmdd') ; -- Obrigatório(S) - Data de postagem*
        ElsIf tpOPEN_ITEM_AR_S_BSID.BLART = 'FATURADO' Then
           tpOPEN_ITEM_AR_S_BSID.XBLNR := vCursor.Rota_Tit||vCursor.Titulo ; -- Obrigatório(S) - Número do documento de referência *
           tpOPEN_ITEM_AR_S_BSID.ZLSPR := 'N' ; -- Obrigatório(N) - Bloqueio de pagamento
           tpOPEN_ITEM_AR_S_BSID.PRCTR := vCursor.Rota_Tit ; -- Obrigatório(N) - Centro de lucro
           tpOPEN_ITEM_AR_S_BSID.BLDAT := to_char(vCursor.Emissao,'yyymmdd') ; -- Obrigatório(S) - Data do documento* 
           tpOPEN_ITEM_AR_S_BSID.BUDAT := to_char(vCursor.Emissao,'yyymmdd') ; -- Obrigatório(S) - Data de postagem*
        End If;

         
        If tpOPEN_ITEM_AR_S_BSID.Kunnr is not null Then         
            tpOPEN_ITEM_AR_S_BSID.BUKRS :=   vCodigoEmpresa ; -- Obrigatório(S) - Código da companhia*

            -- DE PARA DAS CONTAS
            tpOPEN_ITEM_AR_S_BSID.GKONT := '99900007' ; -- Obrigatório(S) - Conta de compensação *


            tpOPEN_ITEM_AR_S_BSID.BKTXT := ' ' ; -- Obrigatório(N) - Texto do cabeçalho
            tpOPEN_ITEM_AR_S_BSID.SGTXT := ' ' ; -- Obrigatório(N) - Texto do item
            tpOPEN_ITEM_AR_S_BSID.WAERS := vMoeda ; -- Obrigatório(S) - Moeda do Documento
            tpOPEN_ITEM_AR_S_BSID.WRBTR := vCursor.Saldo ; -- Obrigatório(S) - Montante na moeda do documento
            tpOPEN_ITEM_AR_S_BSID.HWAER := vMoeda ; -- Obrigatório(S) - Moeda local*
            tpOPEN_ITEM_AR_S_BSID.DMBTR := vCursor.Saldo ; -- Obrigatório(S) - Montante na moeda local
            tpOPEN_ITEM_AR_S_BSID.HWAE2 := ' ' ; -- Obrigatório(N) - Moeda local 2
            tpOPEN_ITEM_AR_S_BSID.DMBE2 := 0 ; -- Obrigatório(N) - Montante na moeda local 2
            tpOPEN_ITEM_AR_S_BSID.HWAE3 := ' ' ; -- Obrigatório(N) - Moeda local 3
            tpOPEN_ITEM_AR_S_BSID.DMBE3 := 0 ; -- Obrigatório(N) - Montante na moeda local 3
            tpOPEN_ITEM_AR_S_BSID.MWSKZ := ' ' ; -- Obrigatório(N) - Código de Imposto
            tpOPEN_ITEM_AR_S_BSID.ZTERM := ' ' ; -- Obrigatório(N) - Termos de pagamento
            tpOPEN_ITEM_AR_S_BSID.ZFBDT := ' ' ; -- Obrigatório(N) - Data base
            tpOPEN_ITEM_AR_S_BSID.ZLSCH := ' ' ; -- Obrigatório(N) - Método de pagamento
            
            Begin 
               INSERT INTO MIGDV.OPEN_ITEM_AR_S_BSID VALUES tpOPEN_ITEM_AR_S_BSID;
            Exception
              When Others Then
           vErro := sqlerrm;
           rollback;
           insert into tdvadm.t_glb_sql values (vErro,
                                                sysdate,
                                                'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                'SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS - Titulo ' || tpOPEN_ITEM_AR_S_BSID.XBLNR );
                 commit;
              End;
           
/*
            tpGL_BALANCES_S_BSIS.BLART := vCursor.BLART;  -- Obrigatório(S) - Tipo de documento*
            tpGL_BALANCES_S_BSIS.BUKRS := vCodigoEmpresa;  -- Obrigatório(S) - Código da companhia*
            tpGL_BALANCES_S_BSIS.XBLNR := vCursor.XBLNR;  -- Obrigatório(S) - Número do documento de referência *
            tpGL_BALANCES_S_BSIS.DOCLN := ' ';            -- Obrigatório(N) -Número do item do documento
            tpGL_BALANCES_S_BSIS.HKONT := vCursor.GKONT;  -- Obrigatório(S) - Conta GL*
            tpGL_BALANCES_S_BSIS.GKONT := vCursor.GKONT;  -- Obrigatório(S) - Compensar conta do Razão *
            tpGL_BALANCES_S_BSIS.BLDAT := vCursor.BLDAT;  -- Obrigatório(S) - Data do documento*
            tpGL_BALANCES_S_BSIS.BUDAT := vCursor.BUDAT;  -- Obrigatório(S) - Data de postagem*
            tpGL_BALANCES_S_BSIS.BKTXT := vCursor.BKTXT;  -- Obrigatório(N) - Texto do cabeçalho
            tpGL_BALANCES_S_BSIS.SGTXT := vCursor.SGTXT;  -- Obrigatório(N) - Texto do item
            tpGL_BALANCES_S_BSIS.WRBTR := vCursor.WRBTR;  -- Obrigatório(S) - Valor em moeda do documento * 
            tpGL_BALANCES_S_BSIS.DMBTR := vCursor.Saldo;  -- Obrigatório(S) - Valor em moeda local *
            tpGL_BALANCES_S_BSIS.FWBAS := vCursor.Saldo;  -- Obrigatório(N) - Montante base do imposto na moeda do documento
            tpGL_BALANCES_S_BSIS.HWBAS := vCursor.Saldo;  -- Obrigatório(N) - Montante base do imposto na moeda local
            tpGL_BALANCES_S_BSIS.WAERS := vMoeda;  -- Obrigatório(S) - Moeda do documento *
            tpGL_BALANCES_S_BSIS.HWAER := vMoeda;  -- Obrigatório(S) - Moeda local*
            tpGL_BALANCES_S_BSIS.MWSKZ := ' ';            -- Obrigatório(N) - Código de Imposto
            tpGL_BALANCES_S_BSIS.TXJCD := ' ';            -- Obrigatório(N) - Jurisdição Fiscal
            tpGL_BALANCES_S_BSIS.KOSTL := ' ';            -- Obrigatório(N) - Centro de custo
            tpGL_BALANCES_S_BSIS.ZUONR := ' ';            -- Obrigatório(N) - Número da tarefa
            tpGL_BALANCES_S_BSIS.RMVCT := trunc(sysdate); -- Obrigatório(N) - Tipo de transação
            tpGL_BALANCES_S_BSIS.VALUT := ' ';            -- Obrigatório(N) - Data do valor
            tpGL_BALANCES_S_BSIS.HBKID := ' ';            -- Obrigatório(N) - Tecla de Atalho para o Banco
            Begin 
               INSERT INTO MIGDV.GL_BALANCES_S_BSIS VALUES tpGL_BALANCES_S_BSIS;
            Exception
              When Others Then
                 vErro := sqlerrm;
                 rollback;
                 insert into tdvadm.t_glb_sql values (vErro,
                                                      sysdate,
                                                      'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                                      'SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS - Saldo - Titulo ' || vCursor.BLART || '-' || vCursor.XBLNR);
                 commit;
              End;
*/                                                             
       
       End If;     
          
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Documentos contas a receber inserido com sucesso';        

        i := i + 1;
        If mod(i,pQtdecommit) = 0 Then
           commit;
        End If; 
        
        
    END LOOP;
    commit;
    
end SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS;




procedure SP_SAP_INSERE_GL_BALANCES_RAZAO(PRESULTADO OUT Char,
                                          PMENSAGEM OUT VARCHAR2) is
Begin
    PRESULTADO := 'N';
    PMENSAGEM := '';
    Begin
    insert into migdv.gl_balances_s_bsis
    select * from migdv.v_Gl_Balances_s_Bsis b
    where b.WRBTR <> 0;
    commit;
    Exception
      When Others Then
         rollback;
         PRESULTADO := 'E';
         PMENSAGEM := 'Erro : ' || sqlerrm;
      End ;
End SP_SAP_INSERE_GL_BALANCES_RAZAO;


procedure SP_SAP_INSERE_RECURSO(PRESULTADO OUT Char,
                                PMENSAGEM OUT VARCHAR2) is
  tpRecurso             migdv.recurso%rowtype;
  tpQualificacaoRecurso migdv.qualif_recurso%rowtype;
  i  integer;
Begin
    PRESULTADO := 'N';
    PMENSAGEM := '';
    i := 0;
    Begin
    for c_msg in (select *
                  from migdv.v_recurso r)
    Loop  

       If  c_msg.Nom_Recurso <> ' ' Then
        tpRecurso.Idt_Recurso            := c_msg.Idt_Recurso;
        tpRecurso.Nom_Recurso            := c_msg.Nom_Recurso;
        tpRecurso.Ind_Tipo_Frota         := c_msg.Ind_Tipo_Frota;
        tpRecurso.Idt_Propr_Terceiro     := c_msg.Idt_Propr_Terceiro;
        tpRecurso.Cod_Meio_Transporte    := c_msg.Cod_Meio_Transporte;
        tpRecurso.Qtd_Recurso_Individual := c_msg.Qtd_Recurso_Individual;
        tpRecurso.Dta_Ini_Validade       := c_msg.Dta_Ini_Validade;
        tpRecurso.Nom_Classe_Recurso     := c_msg.Nom_Classe_Recurso;
        tpRecurso.Cod_Grupo_Veiculo      := c_msg.Cod_Grupo_Veiculo;
        tpRecurso.Cod_Tipo_Veiculo       := c_msg.Cod_Tipo_Veiculo;
        tpRecurso.Dta_Construcao         := c_msg.Dta_Construcao;
        tpRecurso.Num_Placa_Veiculo      := c_msg.Num_Placa_Veiculo;
        tpRecurso.Idt_Motorista_Padrao   := c_msg.Idt_Motorista_Padrao;
        tpRecurso.Cod_Condicao_Recurso   := c_msg.Cod_Condicao_Recurso;
        tpRecurso.Num_Renavam            := c_msg.Num_Renavam;
        tpRecurso.Qtd_Capac_Massa        := c_msg.Qtd_Capac_Massa;
        tpRecurso.Cod_Medida_Massa       := c_msg.Cod_Medida_Massa;
        tpRecurso.Qtd_Capac_Volume       := c_msg.Qtd_Capac_Volume;
        tpRecurso.Cod_Medida_Volume      := c_msg.Cod_Medida_Volume;
        tpRecurso.Qtd_Capac_Comprimento  := c_msg.Qtd_Capac_Comprimento;
        tpRecurso.Cod_Medida_Comprimento := c_msg.Cod_Medida_Comprimento;
        tpRecurso.Qtd_Capac_Peso_Carga   := c_msg.Qtd_Capac_Peso_Carga;
        tpRecurso.Cod_Medida_Peso        := c_msg.Cod_Medida_Peso;
        tpRecurso.Qtd_Capac_Vol_Carga    := c_msg.Qtd_Capac_Vol_Carga;
        tpRecurso.Cod_Medida_Vol_Carga   := c_msg.Cod_Medida_Vol_Carga;
        tpRecurso.Qtd_Compr_Area_Carga   := c_msg.Qtd_Compr_Area_Carga;
        tpRecurso.Cod_Medida_Compr_Area  := c_msg.Cod_Medida_Compr_Area;
        tpRecurso.Qtd_Larg_Area_Carga    := c_msg.Qtd_Larg_Area_Carga;
        tpRecurso.Cod_Medida_Larg_Area   := c_msg.Cod_Medida_Larg_Area;
        tpRecurso.Qtd_Alt_Area_Carga     := c_msg.Qtd_Alt_Area_Carga;
        tpRecurso.Cod_Medida_Alt_Area    := c_msg.Cod_Medida_Alt_Area;
        tpRecurso.Qtd_Tara               := c_msg.Qtd_Tara;
        tpRecurso.Cod_Medida_Tara        := c_msg.Cod_Medida_Tara;
        tpRecurso.Qtd_Peso_Bruto_Max     := c_msg.Qtd_Peso_Bruto_Max;
        tpRecurso.Cod_Medida_Bruto_Max   := c_msg.Cod_Medida_Bruto_Max;
        tpRecurso.Qtd_Eixos              := c_msg.Qtd_Eixos;
        tpRecurso.Qtd_Dist_Eixo          := c_msg.Qtd_Dist_Eixo;
        tpRecurso.Cod_Medida_Dist_Eixo   := c_msg.Cod_Medida_Dist_Eixo;
        tpRecurso.Qtd_Carga_Max_Eixo     := c_msg.Qtd_Carga_Max_Eixo;
        tpRecurso.Cod_Medida_Max_Eixo    := c_msg.Cod_Medida_Max_Eixo;
        tpRecurso.Num_Diametro_Roda      := c_msg.Num_Diametro_Roda;
        tpRecurso.Cod_Medida_Diametro    := c_msg.Cod_Medida_Diametro;
        tpRecurso.Cod_Tipo_Engate        := c_msg.Cod_Tipo_Engate;
        tpRecurso.Num_Temperatura_Min    := c_msg.Num_Temperatura_Min;
        tpRecurso.Num_Temperatura_Max    := c_msg.Num_Temperatura_Max;
        tpRecurso.Cod_Medida_Temperatura := c_msg.Cod_Medida_Temperatura;
        tpRecurso.Ind_Ventilacao         := c_msg.Ind_Ventilacao;
        tpRecurso.Nom_Apelido            := c_msg.Nom_Apelido;
        tpRecurso.Num_Certificado        := c_msg.Num_Certificado;
        tpRecurso.Num_Chassis            := c_msg.Num_Chassis;
        tpRecurso.Idt_Rec_Carreta_01     := c_msg.Idt_Rec_Carreta_01;
        tpRecurso.Idt_Rec_Carreta_02     := c_msg.Idt_Rec_Carreta_02;
        tpRecurso.Idt_Rec_Carreta_03     := c_msg.Idt_Rec_Carreta_03;
        tpRecurso.Dta_Ini_Liber_Coleta   := C_msg.Dta_Ini_Liber_Coleta;
        tpRecurso.Dta_Fim_Liber_Coleta   := c_msg.Dta_Fim_Liber_Coleta;
                     
        insert into migdv.recurso values tpRecurso; 

        i := i + 1;

        tpQualificacaoRecurso.Idt_Recurso        := tpRecurso.Idt_Recurso;
        tpQualificacaoRecurso.Nom_Qualif_Recurso := 'ANO';
        tpQualificacaoRecurso.Dsc_Qualif_Recurso := trim(substr(c_msg.QUAL_ANO,1,40));
        If tpQualificacaoRecurso.Dsc_Qualif_Recurso <> ' ' Then
           insert into migdv.qualif_recurso values tpQualificacaoRecurso;
        End If;

        tpQualificacaoRecurso.Idt_Recurso        := tpRecurso.Idt_Recurso;
        tpQualificacaoRecurso.Nom_Qualif_Recurso := 'CIDADE';
        tpQualificacaoRecurso.Dsc_Qualif_Recurso := trim(substr(c_msg.QUAL_CIDADE,1,40));
        If tpQualificacaoRecurso.Dsc_Qualif_Recurso <> ' ' Then
           insert into migdv.qualif_recurso values tpQualificacaoRecurso;
        End If;

        tpQualificacaoRecurso.Idt_Recurso        := tpRecurso.Idt_Recurso;
        tpQualificacaoRecurso.Nom_Qualif_Recurso := 'UF';
        tpQualificacaoRecurso.Dsc_Qualif_Recurso := trim(substr(c_msg.QUAL_UF,1,40));
        If tpQualificacaoRecurso.Dsc_Qualif_Recurso <> ' ' Then
           insert into migdv.qualif_recurso values tpQualificacaoRecurso;
        End If;

        tpQualificacaoRecurso.Idt_Recurso        := tpRecurso.Idt_Recurso;
        tpQualificacaoRecurso.Nom_Qualif_Recurso := 'COR';
        tpQualificacaoRecurso.Dsc_Qualif_Recurso := trim(substr(c_msg.QUAL_COR,1,40));
        If tpQualificacaoRecurso.Dsc_Qualif_Recurso <> ' ' Then
           insert into migdv.qualif_recurso values tpQualificacaoRecurso;
        End If;
         
        tpQualificacaoRecurso.Idt_Recurso        := tpRecurso.Idt_Recurso;
        tpQualificacaoRecurso.Nom_Qualif_Recurso := 'MARCA';
        tpQualificacaoRecurso.Dsc_Qualif_Recurso := trim(substr(c_msg.QUAL_MARCA,1,40));
        If tpQualificacaoRecurso.Dsc_Qualif_Recurso <> ' ' Then
           insert into migdv.qualif_recurso values tpQualificacaoRecurso;
        End If;

        tpQualificacaoRecurso.Idt_Recurso        := tpRecurso.Idt_Recurso;
        tpQualificacaoRecurso.Nom_Qualif_Recurso := 'LICENCA COLETEIRO';
        tpQualificacaoRecurso.Dsc_Qualif_Recurso := trim(substr(c_msg.QUAL_COLETEIRO,1,40));
        If tpQualificacaoRecurso.Dsc_Qualif_Recurso <> ' ' Then
           insert into migdv.qualif_recurso values tpQualificacaoRecurso;
        End If;

        tpQualificacaoRecurso.Idt_Recurso        := tpRecurso.Idt_Recurso;
        tpQualificacaoRecurso.Nom_Qualif_Recurso := 'LICENCA DEDICADO';
        tpQualificacaoRecurso.Dsc_Qualif_Recurso := trim(substr(c_msg.QUAL_DEDICADO,1,40));
        If tpQualificacaoRecurso.Dsc_Qualif_Recurso <> ' ' Then
           insert into migdv.qualif_recurso values tpQualificacaoRecurso;
        End If;

      End If;


        If mod(i,pQtdecommit) = 0 Then
           commit;
        End If;
        

    End Loop;
    commit;
    Exception
      When Others Then
         rollback;
         PRESULTADO := 'E';
         PMENSAGEM := 'Erro : ' || to_char(i) || ' - ' || sqlerrm;
      End ;

End SP_SAP_INSERE_RECURSO;



procedure sp_RodaIntegracao(pDATA_CORTE       in char, 
                            pTIPO_ENDERECO    in char,
                            pIDMATERIAL       in char, 
                            pRodaBanco        in char default 'NN',  
                            pRazao            in char default 'NN',              
                            pRodaCli          in char default 'NN',
                            pRodaCliVendor    in char default 'NN',         
                            pRodaCliVend      in char default 'NN', 
                            pRodaCliSD        in char default 'NN',
                            pRodaCliPART      in char default 'NN',
                            pRodaEqp          in char default 'NN',
                            pRodaMat          in char default 'NN',
                            pRodaZLMTransp    in char default 'NN',                 
                            pRodaContaReceber in char default 'NN',
                            pRodaContaPagar   in char default 'NN')
Is
  
  TempoI migdv.v_controle.inicio%type;
  TempoF migdv.v_controle.termino%type;
  Tempo  migdv.v_controle.tempo%type;
  PRESULTADO char(1);
  PMENSAGEM clob;
begin

   delete tdvadm.t_glb_sql s
   where s.glb_sql_programa like 'PKG_MIGRACAO_SAP%';
   commit;

   If nvl(substr(nvl(pRodaBanco,'NN'),1,1),'N') = 'S' Then
      TempoI := sysdate;
      delete FROM MIGDV.BANK_MASTER_S_BNKA; 
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null where c.tabela like 'BANK_MASTER_S_%';
      commit;
   End If;
   
   If nvl(substr(nvl(pRodaBanco,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = SYSDATE,c.termino = null,c.tempo = null where c.tabela like 'BANK_MASTER_S_%';
      TempoI := SYSDATE;
      commit;
      migdv.pkg_migracao_sap.SP_SAP_BANCO_TODOS(PRESULTADO => PRESULTADO,
                                                PMENSAGEM => PMENSAGEM);
      TempoF := SYSDATE;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo where c.tabela like 'BANK_MASTER_S_%';
      commit;
   End If;

   If nvl(substr(nvl(pRazao,'NN'),1,1),'N') = 'S' Then
      TempoI := sysdate;
      delete FROM MIGDV.Gl_Balances_s_Bsis; 
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null where c.tabela like 'GL_BALANCES%';
      commit;
   End If;

   If nvl(substr(nvl(pRazao,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = SYSDATE,c.termino = null,c.tempo = null where c.tabela like 'GL_BALANCES%';
      TempoI := SYSDATE;
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_GL_BALANCES_RAZAO(PRESULTADO => PRESULTADO,
                                                             PMENSAGEM => PMENSAGEM);
      TempoF := SYSDATE;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo where c.tabela like 'GL_BALANCES%';
      commit;
   End If;



   If nvl(substr(nvl(pRodaCli,'NN'),1,1),'N') = 'S' Then
      TempoI := sysdate;
      DELETE FROM MIGDV.CUSTOMER_S_CUST_GEN;
      DELETE FROM MIGDV.CUSTOMER_S_CUST_TAXNUMBERS;
      DELETE FROM MIGDV.CUSTOMER_S_CUST_CONT; 
      DELETE FROM MIGDV.CUSTOMER_S_ADDRESS;        
      DELETE FROM MIGDV.CUSTOMER_S_ROLES; 
      DELETE FROM MIGDV.CUSTOMER_S_CUST_COMPANY;
      update migdv.v_controle c 
            set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null 
      where c.tabela like 'CUSTOMER_S_%' 
        and trim(c.tabela) not in ('CUSTOMER_S_CUST_SALES_DATA','CUSTOMER_S_CUST_SALES_PARTNER');

      commit;
   End If;

   If nvl(substr(nvl(pRodaCliVendor,'NN'),1,1),'N') = 'S' Then
      DELETE FROM MIGDV.VENDOR_S_SUPPL_GEN;
      DELETE FROM MIGDV.VENDOR_S_SUPPL_TAXNUMBERS;
      DELETE FROM MIGDV.VENDOR_S_SUPPL_ADDR;        
      DELETE FROM MIGDV.VENDOR_S_ROLES; 
      DELETE FROM MIGDV.VENDOR_S_SUPPL_WITH_TAX;
      DELETE FROM MIGDV.VENDOR_S_SUPP_BANK;
      DELETE FROM MIGDV.VENDOR_S_SUPPL_IDENT;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE c.tabela like 'VENDOR_S_%';
      commit;
   End If;

   If nvl(substr(nvl(pRodaCliVend,'NN'),1,1),'N') = 'S' Then
      DELETE FROM MIGDV.VEND_EXT_S_SUPPL_GEN;
      DELETE FROM MIGDV.VEND_EXT_S_SUPPL_TAXNUMBERS;
      DELETE FROM MIGDV.VEND_EXT_S_SUPPL_ADDR;
      DELETE FROM MIGDV.VEND_EXT_S_ROLES;
      DELETE FROM MIGDV.VEND_EXT_S_SUPPL_BANK;
      DELETE FROM MIGDV.VEND_EXT_S_SUPPL_WITH_TAX;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE c.tabela like 'VEND_EXT_S_%';

      commit;
   End If;

   If nvl(substr(nvl(pRodaCli,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = SYSDATE,c.termino = null,c.tempo = null where c.tabela like 'CUSTOMER_S_%' and trim(c.tabela) not in ('CUSTOMER_S_CUST_SALES_DATA','CUSTOMER_S_CUST_SALES_PARTNER');
   End If;
   If nvl(substr(nvl(pRodaCliVendor,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = SYSDATE,c.termino = null,c.tempo = null WHERE c.tabela like 'VENDOR_S_%';
   End If;
   If nvl(substr(nvl(pRodaCliVend,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = SYSDATE,c.termino = null,c.tempo = null WHERE c.tabela like 'VEND_EXT_S_%';
   End If;
   commit;

   If nvl(substr(nvl(pRodaCli,'NN'),2,1),'N') = 'S' or 
      nvl(substr(nvl(pRodaCliVendor,'NN'),2,1),'N') = 'S' or
      nvl(substr(nvl(pRodaCliVend,'NN'),2,1),'N') = 'S' Then
      TempoI := SYSDATE;
      migdv.pkg_migracao_sap.SP_SAP_INSERECLIENTE(PDATA_CORTE => PDATA_CORTE,
                                                  PTIPO_ENDERECO => PTIPO_ENDERECO,
                                                  PRESULTADO => PRESULTADO,
                                                  PMENSAGEM => PMENSAGEM);
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
   End If;




   If nvl(substr(nvl(pRodaCli,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo where c.tabela like 'CUSTOMER_S_%' and trim(c.tabela) not in ('CUSTOMER_S_CUST_SALES_DATA','CUSTOMER_S_CUST_SALES_PARTNER');
   End If;
   If nvl(substr(nvl(pRodaCliVendor,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE c.tabela like 'VENDOR_S_%';
   End If;
   If nvl(substr(nvl(pRodaCliVend,'NN'),2,1),'N') = 'S' Then
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE c.tabela like 'VEND_EXT_S_%';
   End If;
   commit;


   If nvl(substr(nvl(pRodaCliSD,'NN'),1,1),'N') = 'S' Then
      DELETE FROM MIGDV.CUSTOMER_S_CUST_SALES_DATA;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_DATA');
      commit;
   End If;
 
   If nvl(substr(nvl(pRodaCliSD,'NN'),2,1),'N') = 'S' Then

      TempoI := sysdate;
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = null,c.tempo = null WHERE trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_DATA');
      commit;
      migdv.pkg_migracao_sap.SP_CUSTOMER_S_CUST_SALES_DATA;
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_DATA');
      commit;
   End If;

   If nvl(substr(nvl(pRodaCliPART,'NN'),1,1),'N') = 'S' Then
      DELETE FROM MIGDV.CUSTOMER_S_CUST_SALES_PARTNER;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_PARTNER');
      commit;
   End If;
 
   If nvl(substr(nvl(pRodaCliPART,'NN'),2,1),'N') = 'S' Then

      TempoI := sysdate;
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = null,c.tempo = null WHERE trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_PARTNER');
      commit;
      migdv.pkg_migracao_sap.SP_CUSTOMER_S_CUST_SALES_PARTNER;
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_PARTNER');
      commit;
   End If;




   
   If nvl(substr(nvl(pRodaEqp,'NN'),1,1),'N') = 'S' Then
      TempoI := sysdate;
      DELETE FROM MIGDV.EQUIPMENT_S_EQUI;
      DELETE FROM MIGDV.FUNC_LOC_S_FUN_LOCATION;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE trim(c.tabela) in ('EQUIPMENT_S_EQUI',
                                                                                                                        'FUNC_LOC_S_FUN_LOCATION');
      commit;
   End If;

   If nvl(substr(nvl(pRodaEqp,'NN'),2,1),'N') = 'S' Then
      TempoI := sysdate;
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = null,c.tempo = null WHERE trim(c.tabela) in ('EQUIPMENT_S_EQUI',
                                                                                                                          'FUNC_LOC_S_FUN_LOCATION');
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_EQUIPAMENTO(PRESULTADO => PRESULTADO,
                                                       PMENSAGEM => PMENSAGEM);
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE trim(c.tabela) in ('EQUIPMENT_S_EQUI',
                                                                                                                                 'FUNC_LOC_S_FUN_LOCATION');
      commit;
   End If;



         
   If nvl(substr(nvl(pRodaMat,'NN'),1,1),'N') = 'S' Then
      TempoI := sysdate;
      DELETE FROM MIGDV.MATERIAL_S_MARA;
      DELETE FROM MIGDV.MATERIAL_S_MARM;
      DELETE FROM MIGDV.MATERIAL_S_MARD;
      DELETE FROM MIGDV.MATERIAL_S_MLAN;
      DELETE FROM MIGDV.MATERIAL_S_MAKT;
      DELETE FROM MIGDV.MATERIAL_S_MBEW;      
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE c.tabela like 'MATERIAL_S_%';
      commit;
   End If;

   If nvl(substr(nvl(pRodaMat,'NN'),2,1),'N') = 'S' Then
      TempoI := sysdate;
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = null,c.tempo = null WHERE c.tabela like 'MATERIAL_S_%';
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_MATERIAL(PIDMATERIAL => PIDMATERIAL,
                                                    PRESULTADO => PRESULTADO,
                                                    PMENSAGEM => PMENSAGEM);
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE c.tabela like 'MATERIAL_S_%';
      commit;
   End If;


   
   If nvl(substr(nvl(pRodaZLMTransp,'NN'),1,1),'N') = 'S' Then
      DELETE FROM MIGDV.ZONA_TRANSPORTE;
      DELETE FROM MIGDV.LINHA_TRANSPORTE;
      DELETE FROM MIGDV.LINHA_MEIO_TRANSP;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE trim(c.tabela) in ('ZONA_TRANSPORTE',
                                                                                                                        'LINHA_TRANSPORTE',
                                                                                                                        'LINHA_MEIO_TRANSP');
      commit;
   End If;

   If nvl(substr(nvl(pRodaZLMTransp,'NN'),2,1),'N') = 'S' Then
      TempoI := sysdate;
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = null WHERE trim(c.tabela) in ('ZONA_TRANSPORTE',
                                                                                                                            'LINHA_MEIO_TRANSP');
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_ZONATRANSPORTE;
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_LINHATRANSPORTE;
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_LINHA_MEIO_TRANSPORTE;
      commit;
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE trim(c.tabela) in ('ZONA_TRANSPORTE',
                                                                                                                             'LINHA_MEIO_TRANSP');
      commit;
   End If;


   If nvl(substr(nvl(pRodaContaPagar,'NN'),1,1),'N') = 'S' Then
      DELETE FROM MIGDV.OPEN_ITEM_AP_S_BSET;
      DELETE FROM MIGDV.OPEN_ITEM_AP_S_BSIK;
      DELETE FROM MIGDV.OPEN_ITEM_AP_S_WITH_ITEM;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE trim(c.tabela) like 'OPEN_ITEM_AP_S_%';
      commit;
      
   End If;
   If nvl(substr(nvl(pRodaContaPagar,'NN'),2,1),'N') = 'S' Then
      TempoI := sysdate;
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = null,c.tempo = null WHERE c.tabela like 'OPEN_ITEM_AP%';
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_CONTAS_PAGAR_DOCUMENTOS(PIDCOMPANHIA => PIDMATERIAL,
                                                                   PRESULTADO => PRESULTADO,
                                                                   PMENSAGEM => PMENSAGEM);
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE c.tabela like 'OPEN_ITEM_AP%';
      commit;
   End If;

   If nvl(substr(nvl(pRodaContaReceber,'NN'),1,1),'N') = 'S' Then
      DELETE FROM MIGDV.OPEN_ITEM_AR_S_BSET;
      DELETE FROM MIGDV.OPEN_ITEM_AR_S_BSID;
      DELETE FROM MIGDV.OPEN_ITEM_AR_S_WITH_ITEM;
      update migdv.v_controle c set c.qtde = 0,c.inicio = null,c.termino = null,c.tempo = null WHERE trim(c.tabela) like 'OPEN_ITEM_AR_S_%';
      commit;
      
   End If;

   If nvl(substr(nvl(pRodaContaReceber,'NN'),2,1),'N') = 'S' Then
      TempoI := sysdate;
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = null,c.tempo = null WHERE c.tabela like 'OPEN_ITEM_AR%';
      commit;
      migdv.pkg_migracao_sap.SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS(PIDCOMPANHIA => PIDMATERIAL,
                                                                     PRESULTADO => PRESULTADO,
                                                                     PMENSAGEM => PMENSAGEM);
      TempoF := sysdate;
      Tempo := tdvadm.fn_calcula_tempodecorrido(TempoI,TempoF,'H');
      update migdv.v_controle c set c.qtde = 0,c.inicio = TempoI,c.termino = TempoF,c.tempo = Tempo WHERE c.tabela like 'OPEN_ITEM_AR%';
      commit;
   End If;


End sp_RodaIntegracao;


Procedure sp_MigrandoTDVxSAP(pQtdecommit     in integer default 100,
                             pGrupoEconomico in char default 'N',
                             pAtivo          in char default 'N',
                             pRazao          in char default 'N', 
                             pBanco          in char default 'N',
                             pCliente        in char default 'N',
                             pClienteReduz   in char default 'N',
                             pSales          in char default 'N',
                             pPARTNER        in char default 'N',
                             pVendor         in char default 'N',
                             pVend           in char default 'N',
                             pEquipamento    in char default 'N',
                             pMaterial       in char default 'N',
                             pMeioTransp     in char default 'N',
                             pContaPagar     in char default 'N',
                             pContaReceber   in char default 'N',
                             pRecurso        in char default 'N')
  
Is
  tpDBANK_MASTER_S_BNKA             migdv.BANK_MASTER_S_BNKA%rowtype;

  tpDCUSTOMER_S_ADDRESS             migdv.CUSTOMER_S_ADDRESS%rowtype;
  tpDCUSTOMER_S_CUST_COMPANY        migdv.CUSTOMER_S_CUST_COMPANY%rowtype;
  tpDCUSTOMER_S_CUST_CONT           migdv.CUSTOMER_S_CUST_CONT%rowtype;
  tpDCUSTOMER_S_CUST_GEN            migdv.CUSTOMER_S_CUST_GEN%rowtype;
  tpDCUSTOMER_S_CUST_TAXNUMBERS     migdv.CUSTOMER_S_CUST_TAXNUMBERS%rowtype;
  tpDCUSTOMER_S_ROLES               migdv.CUSTOMER_S_ROLES%rowtype;

  tpDTST_CUSTOMER_S_CUST_GEN        migdv.TST_CUSTOMER_S_CUST_GEN%rowtype;
  tpDTST_CUSTOMER_S_CUST_TAXNUMBERS migdv.TST_CUSTOMER_S_CUST_TAXNUMBERS%rowtype;
  tpDTST_CUSTOMER_S_ROLES           migdv.TST_CUSTOMER_S_ROLES%rowtype;



  tpDCUSTOMER_S_CUST_SALES_DATA     migdv.CUSTOMER_S_CUST_SALES_DATA%rowtype;

  tpDCUSTOMER_S_CUST_SALES_PARTNER  migdv.CUSTOMER_S_CUST_SALES_PARTNER%rowtype;

  tpDcustrel_s_but050               migdv.custrel_s_but050%rowtype;
  
  tpDVENDOR_S_ROLES                 migdv.VENDOR_S_ROLES%rowtype;
  tpDVENDOR_S_SUPPL_GEN             migdv.VENDOR_S_SUPPL_GEN%rowtype;
  tpDVENDOR_S_SUPPL_IDENT           migdv.VENDOR_S_SUPPL_IDENT%rowtype;
  tpDVENDOR_S_SUPPL_TAXNUMBERS      migdv.VENDOR_S_SUPPL_TAXNUMBERS%rowtype;
  tpDVENDOR_S_SUPPL_WITH_TAX        migdv.VENDOR_S_SUPPL_WITH_TAX%rowtype;

  tpDVend_Ext_s_Roles               migdv.vend_ext_s_roles%rowtype;
  tpDVend_Ext_s_Suppl_Gen           migdv.vend_ext_s_suppl_gen%rowtype;
  tpDVend_Ext_s_Suppl_Ident         migdv.vend_ext_s_suppl_ident%rowtype;
  tpDVend_Ext_s_Suppl_Taxnumbers    migdv.vend_ext_s_suppl_taxnumbers%rowtype;
  tpDVend_Ext_s_Suppl_With_Tax      migdv.vend_ext_s_suppl_with_tax%rowtype;

  tpDEQUIPMENT_S_EQUI               migdv.EQUIPMENT_S_EQUI%rowtype;
  tpDFUNC_LOC_S_FUN_LOCATION        migdv.FUNC_LOC_S_FUN_LOCATION%rowtype;

  tpDMATERIAL_S_MAKT                migdv.MATERIAL_S_MAKT%rowtype;
  tpDMATERIAL_S_MARA                migdv.MATERIAL_S_MARA%rowtype;
  tpDMATERIAL_S_MLAN                migdv.MATERIAL_S_MLAN%rowtype;
  tpDMATERIAL_S_MBEW                migdv.MATERIAL_S_MBEW%rowtype;

  tpDOPEN_ITEM_AP_S_BSIK            migdv.OPEN_ITEM_AP_S_BSIK%rowtype;
  tpDOPEN_ITEM_AP_S_BSET            migdv.OPEN_ITEM_AP_S_BSET%rowtype;
  tpDOPEN_ITEM_AP_S_WITH_ITEM       migdv.OPEN_ITEM_AP_S_WITH_ITEM%rowtype;

  tpDOPEN_ITEM_AR_S_BSID            migdv.Open_Item_Ar_s_Bsid%rowtype;
  tpDOPEN_ITEM_AR_S_BSET            migdv.oPEN_ITEM_AR_S_BSET%rowtype;
  tpDOPEN_ITEM_AR_S_WITH_ITEM       migdv.OPEN_ITEM_AR_S_WITH_ITEM%rowtype;

  tpDLINHA_MEIO_TRANSP              migdv.LINHA_MEIO_TRANSP%rowtype;
  tpDLINHA_TRANSPORTE               migdv.LINHA_TRANSPORTE%rowtype;
  tpDZONA_TRANSPORTE                migdv.ZONA_TRANSPORTE%rowtype;
  
  tpDGL_BALANCES_S_BSIS             migdv.GL_BALANCES_S_BSIS%rowtype;

  tpDRECURSO                        migdv.RECURSO%rowtype;
  tpDQUALIF_RECURSO                 migdv.QUALIF_RECURSO%rowtype;



  tpDFIXED_ASSET_S_CUM_VAL          migdv.FIXED_ASSET_S_CUM_VAL%rowtype;
  tpDFIXED_ASSET_S_DEPR             migdv.FIXED_ASSET_S_DEPR%rowtype;
  tpDFIXED_ASSET_S_KEY              migdv.FIXED_ASSET_S_KEY%rowtype;
  tpDFIXED_ASSET_S_NETWORTHVALUATIO migdv.FIXED_ASSET_S_NETWORTHVALUATIO%rowtype;
  tpDFIXED_ASSET_S_ORIGIN           migdv.FIXED_ASSET_S_ORIGIN%rowtype;
  tpDFIXED_ASSET_S_POSTINGINFORMATI migdv.FIXED_ASSET_S_POSTINGINFORMATI%rowtype;
  tpDFIXED_ASSET_S_POST_VAL         migdv.FIXED_ASSET_S_POST_VAL%rowtype;
  tpDFIXED_ASSET_S_REALESTATE       migdv.FIXED_ASSET_S_REALESTATE%rowtype;
  tpDFIXED_ASSET_S_TIMEDEPENDENTDAT migdv.FIXED_ASSET_S_TIMEDEPENDENTDAT%rowtype;


  i integer;
  type tpCurosr is REF CURSOR;
  vCursor1 tpCurosr;
begin
   i := 0;


If nvl(pGrupoEconomico,'N') = 'S' Then
   delete migdv.custrel_s_but050@database_tdx;
   commit;

   --  ************************** 
   Begin
  i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTREL_S_BUT050');

 commit; open vCursor1 FOR select * from migdv.custrel_s_but050;
   loop
     fetch vCursor1 into tpDcustrel_s_but050;
        exit when vCursor1%notfound;

     insert into migdv.custrel_s_but050@database_tdx values tpDcustrel_s_but050;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTREL_S_BUT050');
        commit;
     End If;
   end loop; commit;
   close vCursor1;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTREL_S_BUT050');
   commit;



  exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
End If;

If nvl(pAtivo,'N') = 'S' Then
   delete migdv.FIXED_ASSET_S_CUM_VAL@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_DEPR@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_KEY@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_NETWORTHVALUATIO@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_ORIGIN@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_POSTINGINFORMATI@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_POST_VAL@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_REALESTATE@database_tdx;
   commit;
   delete migdv.FIXED_ASSET_S_TIMEDEPENDENTDAT@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_CUM_VAL');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_CUM_VAL;
   i := 0;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_CUM_VAL;
        exit when vCursor1%notfound;

     insert into migdv.FIXED_ASSET_S_CUM_VAL@database_tdx values tpDFIXED_ASSET_S_CUM_VAL;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_CUM_VAL');
        commit;
     End If;
   end loop; commit;

  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_CUM_VAL');

   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = 0,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_DEPR');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_DEPR;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_DEPR;
        exit when vCursor1%notfound;
   
     tpDFIXED_ASSET_S_DEPR.Ndjar := lpad(trim(tpDFIXED_ASSET_S_DEPR.Ndjar),3,'0');
     tpDFIXED_ASSET_S_DEPR.Ndper := lpad(trim(tpDFIXED_ASSET_S_DEPR.Ndper),3,'0');
     tpDFIXED_ASSET_S_DEPR.Ndabj := lpad(trim(tpDFIXED_ASSET_S_DEPR.Ndabj),3,'0');
     tpDFIXED_ASSET_S_DEPR.Ndabp := lpad(trim(tpDFIXED_ASSET_S_DEPR.Ndabp),3,'0');
     tpDFIXED_ASSET_S_DEPR.Vmnth := lpad(trim(tpDFIXED_ASSET_S_DEPR.Vmnth),3,'0');

     insert into migdv.FIXED_ASSET_S_DEPR@database_tdx values tpDFIXED_ASSET_S_DEPR;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_DEPR');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_DEPR');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

  
    --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_DEPR');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_KEY;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_KEY;
        exit when vCursor1%notfound;
   
    tpDFIXED_ASSET_S_KEY.Anlkl := trim(nvl(trim(tpDFIXED_ASSET_S_KEY.Anlkl),tpDFIXED_ASSET_S_KEY.Txt50));
    tpDFIXED_ASSET_S_KEY.Main_Descript := nvl(tpDFIXED_ASSET_S_KEY.Main_Descript,' ');
    
     insert into migdv.FIXED_ASSET_S_KEY@database_tdx values tpDFIXED_ASSET_S_KEY;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_KEY');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_KEY');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_NETWORTHVALUATIO');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_NETWORTHVALUATIO;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_NETWORTHVALUATIO;
        exit when vCursor1%notfound;

     insert into migdv.FIXED_ASSET_S_NETWORTHVALUATIO@database_tdx values tpDFIXED_ASSET_S_NETWORTHVALUATIO;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_NETWORTHVALUATIO');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_NETWORTHVALUATIO');
   
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_ORIGIN');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_ORIGIN;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_ORIGIN;
        exit when vCursor1%notfound;

     insert into migdv.FIXED_ASSET_S_ORIGIN@database_tdx values tpDFIXED_ASSET_S_ORIGIN;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_ORIGIN');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_ORIGIN');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

   Begin
     i := 0 ;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_POSTINGINFORMATI');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_POSTINGINFORMATI;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_POSTINGINFORMATI;
        exit when vCursor1%notfound;

     insert into migdv.FIXED_ASSET_S_POSTINGINFORMATI@database_tdx values tpDFIXED_ASSET_S_POSTINGINFORMATI;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_POSTINGINFORMATI');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_POSTINGINFORMATI');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 


   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_POST_VAL');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_POST_VAL;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_POST_VAL;
        exit when vCursor1%notfound;

     tpDFIXED_ASSET_S_POST_VAL.Last_Posted_Depr_Period := nvl(lpad(trim(tpDFIXED_ASSET_S_POST_VAL.Last_Posted_Depr_Period),3,'0'),'000');

     insert into migdv.FIXED_ASSET_S_POST_VAL@database_tdx values tpDFIXED_ASSET_S_POST_VAL;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_POST_VAL');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_POST_VAL');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

   Begin
     i := 0 ;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_REALESTATE');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_REALESTATE;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_REALESTATE;
        exit when vCursor1%notfound;

     insert into migdv.FIXED_ASSET_S_REALESTATE@database_tdx values tpDFIXED_ASSET_S_REALESTATE;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_REALESTATE');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_REALESTATE');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FIXED_ASSET_S_TIMEDEPENDENTDAT');
   commit; open vCursor1 FOR select * from migdv.FIXED_ASSET_S_TIMEDEPENDENTDAT;
   loop
     fetch vCursor1 into tpDFIXED_ASSET_S_TIMEDEPENDENTDAT;
        exit when vCursor1%notfound;

     insert into migdv.FIXED_ASSET_S_TIMEDEPENDENTDAT@database_tdx values tpDFIXED_ASSET_S_TIMEDEPENDENTDAT;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_TIMEDEPENDENTDAT');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FIXED_ASSET_S_TIMEDEPENDENTDAT');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 


End If;

If nvl(pRazao,'N') = 'S' Then
   delete migdv.GL_BALANCES_S_BSIS@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('GL_BALANCES_S_BSIS');
   commit; open vCursor1 FOR select * from migdv.GL_BALANCES_S_BSIS;
   loop
     fetch vCursor1 into tpDGL_BALANCES_S_BSIS;
        exit when vCursor1%notfound;

     insert into migdv.GL_BALANCES_S_BSIS@database_tdx values tpDGL_BALANCES_S_BSIS;

     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('GL_BALANCES_S_BSIS');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('GL_BALANCES_S_BSIS');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

End If;

If nvl(pBanco,'N') = 'S' Then
   delete migdv.BANK_MASTER_S_BNKA@database_tdx;
   commit;
   --  ************************** 
   Begin
     i := 0 ;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('BANK_MASTER_S_BNKA');
   commit; open vCursor1 FOR select * from migdv.BANK_MASTER_S_BNKA;
   loop
     fetch vCursor1 into tpDBANK_MASTER_S_BNKA;
        exit when vCursor1%notfound;
     insert into migdv.BANK_MASTER_S_BNKA@database_tdx values tpDBANK_MASTER_S_BNKA;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('BANK_MASTER_S_BNKA');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('BANK_MASTER_S_BNKA');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

End If;

If nvl(pCliente,'N') = 'S' Then
   delete migdv.CUSTOMER_S_ADDRESS@database_tdx;
   commit;
   delete migdv.CUSTOMER_S_CUST_COMPANY@database_tdx;
   commit;
   delete migdv.CUSTOMER_S_CUST_CONT@database_tdx;
   commit;
   delete migdv.CUSTOMER_S_CUST_GEN@database_tdx;
   commit;
   delete migdv.CUSTOMER_S_CUST_TAXNUMBERS@database_tdx;
   commit;
   delete migdv.CUSTOMER_S_ROLES@database_tdx;
   commit;
   
   update migdv.v_controle c 
        set c.qtdetdh = 0,c.inicioh = null,c.terminoh = null,c.tempoh = null 
  where c.tabela like 'CUSTOMER_S_%' 
    and trim(c.tabela) not in ('CUSTOMER_S_CUST_SALES_DATA','CUSTOMER_S_CUST_SALES_PARTNER');

  

   --  ************************** 
   i := 0;
   update migdv.v_controle c 
        set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_CUST_GEN');
  commit;
   commit; open vCursor1 FOR select * from migdv.CUSTOMER_S_CUST_GEN x where x.post_code1 <> ' ' and x.country <> ' ';
   loop
       Begin
         fetch vCursor1 into tpDCUSTOMER_S_CUST_GEN;
            exit when vCursor1%notfound;

         insert into migdv.CUSTOMER_S_CUST_GEN@database_tdx values tpDCUSTOMER_S_CUST_GEN;
         
         i := i + 1;
         If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_GEN');
            commit;
         End If;
       exception
         When OTHERS Then
--            ROLLBACK;  
            DBMS_OUTPUT.put_line('CUSTOMER_S_CUST_GEN');
            DBMS_OUTPUT.put_line(SQLERRM);
            If i >= 3 Then
               return;
            End If;
         End;
   end loop; commit;
   commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_GEN');
   close vCursor1;
   commit;
   --  ************************** 
   i := 0;
   update migdv.v_controle c 
        set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_ADDRESS');

   commit; open vCursor1 FOR select * from migdv.CUSTOMER_S_ADDRESS x where x.post_code1 <> ' ';
   loop
   Begin
     fetch vCursor1 into tpDCUSTOMER_S_ADDRESS;
        exit when vCursor1%notfound;
     insert into migdv.CUSTOMER_S_ADDRESS@database_tdx values tpDCUSTOMER_S_ADDRESS;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_ADDRESS');
        commit;
     End If;
   exception
     When OTHERS Then
        ROLLBACK;  
        DBMS_OUTPUT.put_line('CUSTOMER_S_ADDRESS');
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   end loop; commit;
   close vCursor1;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_ADDRESS');
   commit;

   --  ************************** 
   i := 0;
   update migdv.v_controle c 
        set c.qtdetdh = 0,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_CUST_COMPANY');

   commit; open vCursor1 FOR select * from migdv.CUSTOMER_S_CUST_COMPANY;
   loop
   Begin
     fetch vCursor1 into tpDCUSTOMER_S_CUST_COMPANY;
        exit when vCursor1%notfound;
     insert into migdv.CUSTOMER_S_CUST_COMPANY@database_tdx values tpDCUSTOMER_S_CUST_COMPANY;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_COMPANY');
        commit;
     End If;
   exception
     When OTHERS Then
        ROLLBACK;  
        DBMS_OUTPUT.put_line('CUSTOMER_S_CUST_COMPANY');
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_COMPANY');
   close vCursor1;
   commit;
   --  ************************** 
   i := 0;
   update migdv.v_controle c 
        set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_CUST_CONT');
   commit; open vCursor1 FOR select * from migdv.CUSTOMER_S_CUST_CONT;
   loop
   Begin
     fetch vCursor1 into tpDCUSTOMER_S_CUST_CONT;
        exit when vCursor1%notfound;
     insert into migdv.CUSTOMER_S_CUST_CONT@database_tdx values tpDCUSTOMER_S_CUST_CONT;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_CONT');
        commit;
     End If;
   exception
     When OTHERS Then
        ROLLBACK;  
        DBMS_OUTPUT.put_line('CUSTOMER_S_CUST_CONT');
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_CONT');
   close vCursor1;
   commit;
   --  ************************** 
   i := 0;
   update migdv.v_controle c 
        set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_CUST_TAXNUMBERS');

   commit; open vCursor1 FOR select * from migdv.CUSTOMER_S_CUST_TAXNUMBERS;
   loop
   Begin
     fetch vCursor1 into tpDCUSTOMER_S_CUST_TAXNUMBERS;
        exit when vCursor1%notfound;
     insert into migdv.CUSTOMER_S_CUST_TAXNUMBERS@database_tdx values tpDCUSTOMER_S_CUST_TAXNUMBERS;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_TAXNUMBERS');
        commit;
     End If;
   exception
     When OTHERS Then
        ROLLBACK;  
        DBMS_OUTPUT.put_line('CUSTOMER_S_CUST_TAXNUMBERS');
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_TAXNUMBERS');
   close vCursor1;
   commit;

   --  ************************** 
   i := 0;
   update migdv.v_controle c 
        set c.qtdetdh = 0,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_ROLES');
   commit; open vCursor1 FOR select distinct * from migdv.CUSTOMER_S_ROLES;
   loop
   Begin
     fetch vCursor1 into tpDCUSTOMER_S_ROLES;
        exit when vCursor1%notfound;
     insert into migdv.CUSTOMER_S_ROLES@database_tdx values tpDCUSTOMER_S_ROLES;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_ROLES');
        commit;
     End If;
   exception
     When OTHERS Then
        ROLLBACK;  
        DBMS_OUTPUT.put_line('CUSTOMER_S_ROLES');
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_ROLES');
   close vCursor1;
   commit;
   --  ************************** 


End If;


If nvl(pClienteReduz,'N') = 'S' Then

   delete migdv.TST_CUSTOMER_S_CUST_GEN@database_tdx;
   commit;
   delete migdv.TST_CUSTOMER_S_CUST_TAXNUMBERS@database_tdx;
   commit;
   delete migdv.TST_CUSTOMER_S_ROLES@database_tdx;

   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('TST_CUSTOMER_S_CUST_GEN');
   commit; open vCursor1 FOR select x.kunnr,
                            x.bu_group,
                            x.ktokd,
                            x.namorg1,
                            x.namorg2,
                            x.namorg3,
                            x.namorg4,
                            x.sortl,
                            x.mcod2,
                            x.found_dat,
                            x.liquid_dat,
                            x.kukla,
                            x.suframa,
                            x.rg,
                            x.cnae,
                            x.crtn,
                            x.icmstaxpay,
                            x.decregpc,
                            x.street,
                            x.house_num1,
                            x.city2,
                            x.post_code1,
                            x.city1,
                            x.country,
                            x.region,
                            x.str_suppl1,
                            x.house_no2,
                            x.po_box,
                            x.post_code2,
                            x.po_box_loc,
                            x.pobox_ctry,
                            x.po_box_reg,
                            x.langu_corr,
                            x.telnr_long,
                            x.telnr_long_2,
                            x.telnr_long_3,
                            x.mobile_long,
                            x.mobile_long_2,
                            x.mobile_long_3,
                            x.faxnr_long,
                            x.faxnr_long_2,
                            x.faxnr_long_3,
                            x.smtp_addr,
                            x.smtp_addr_2,
                            x.smtp_addr_3,
                            x.uri_typ,
                            x.uri_addr,
                            x.sperr,
                            x.collman
                     from migdv.CUSTOMER_S_CUST_GEN x 
                     where x.kunnr in (select X.KUNNR
                                       from migdv.CUSTOMER_S_CUST_GEN x,
                                            TDVADM.V_CNPJ_CARGASIMPLES C
                                       WHERE TRIM(X.SORTL) = TRIM(C.cnpj)
                                         and x.post_code1 <> ' ');
   loop
     fetch vCursor1 into tpDTST_CUSTOMER_S_CUST_GEN;
        exit when vCursor1%notfound;

     insert into migdv.TST_CUSTOMER_S_CUST_GEN@database_tdx values tpDTST_CUSTOMER_S_CUST_GEN;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('TST_CUSTOMER_S_CUST_GEN');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('TST_CUSTOMER_S_CUST_GEN');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
  --************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('TST_CUSTOMER_S_CUST_TAXNUMBERS');
   commit; open vCursor1 FOR select x.kunnr,
                            x.taxtype,
                            x.taxnum 
                     from migdv.CUSTOMER_S_CUST_TAXNUMBERS x
                     where x.kunnr in (select X.KUNNR
                                       from migdv.CUSTOMER_S_CUST_GEN x,
                                            TDVADM.V_CNPJ_CARGASIMPLES C
                                       WHERE TRIM(X.SORTL) = TRIM(C.cnpj)
                                         and x.post_code1 <> ' ');

   loop
     fetch vCursor1 into tpDTST_CUSTOMER_S_CUST_TAXNUMBERS;
        exit when vCursor1%notfound;
     insert into migdv.TST_CUSTOMER_S_CUST_TAXNUMBERS@database_tdx values tpDTST_CUSTOMER_S_CUST_TAXNUMBERS;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('TST_CUSTOMER_S_CUST_TAXNUMBERS');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('TST_CUSTOMER_S_CUST_TAXNUMBERS');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('TST_CUSTOMER_S_ROLES');
   commit; open vCursor1 FOR select distinct x.kunnr, 
                                     x.bp_role 
                     from migdv.CUSTOMER_S_ROLES x
                     where x.kunnr in (select X.KUNNR
                                       from migdv.CUSTOMER_S_CUST_GEN x,
                                            TDVADM.V_CNPJ_CARGASIMPLES C
                                       WHERE TRIM(X.SORTL) = TRIM(C.cnpj)
                                         and x.post_code1 <> ' ');
   loop
     fetch vCursor1 into tpDTST_CUSTOMER_S_ROLES;
        exit when vCursor1%notfound;
     insert into migdv.TST_CUSTOMER_S_ROLES@database_tdx values tpDTST_CUSTOMER_S_ROLES;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('TST_CUSTOMER_S_ROLES');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('TST_CUSTOMER_S_ROLES');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 


End If;

If nvl(pSales,'N') = 'S' Then
  
   delete migdv.CUSTOMER_S_CUST_SALES_DATA@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_DATA');
   commit; open vCursor1 FOR select * from migdv.CUSTOMER_S_CUST_SALES_DATA;
   loop
     fetch vCursor1 into tpDCUSTOMER_S_CUST_SALES_DATA;
        exit when vCursor1%notfound;
-- Ana MUDOU
     insert into migdv.CUSTOMER_S_CUST_SALES_DATA@database_tdx values tpDCUSTOMER_S_CUST_SALES_DATA;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_DATA');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_DATA');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
End If;

If nvl(pPARTNER,'N') = 'S' Then
  
   delete migdv.CUSTOMER_S_CUST_SALES_PARTNER@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_PARTNER');
   commit; open vCursor1 FOR select * from migdv.CUSTOMER_S_CUST_SALES_PARTNER;
   loop
     fetch vCursor1 into tpDCUSTOMER_S_CUST_SALES_PARTNER;
        exit when vCursor1%notfound;
-- Ana MUDOU
     insert into migdv.CUSTOMER_S_CUST_SALES_PARTNER@database_tdx values tpDCUSTOMER_S_CUST_SALES_PARTNER;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_PARTNER');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('CUSTOMER_S_CUST_SALES_PARTNER');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
End If;




If nvl(pVendor,'N') = 'S' Then
  
   delete migdv.VENDOR_S_ROLES@database_tdx;
   commit;
   delete migdv.VENDOR_S_SUPPL_GEN@database_tdx;
   commit;
   delete migdv.VENDOR_S_SUPPL_IDENT@database_tdx;
   commit;
   delete migdv.VENDOR_S_SUPPL_TAXNUMBERS@database_tdx;
   commit;
   delete migdv.VENDOR_S_SUPPL_WITH_TAX@database_tdx;
   commit;

   --  ************************** 

   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VENDOR_S_SUPPL_GEN');
   commit; open vCursor1 FOR select * from migdv.VENDOR_S_SUPPL_GEN x where x.post_code1 <> ' ' and x.country <> ' ';
   loop
     fetch vCursor1 into tpDVENDOR_S_SUPPL_GEN;
        exit when vCursor1%notfound;
        
     insert into migdv.VENDOR_S_SUPPL_GEN@database_tdx values tpDVENDOR_S_SUPPL_GEN;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_GEN');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_GEN');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        commit;
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 


   --  ************************** 
 Begin
   i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VENDOR_S_SUPPL_WITH_TAX');
   commit; open vCursor1 FOR select * from migdv.VENDOR_S_SUPPL_WITH_TAX;
   loop
     fetch vCursor1 into tpDVENDOR_S_SUPPL_WITH_TAX;
        exit when vCursor1%notfound;
     insert into migdv.VENDOR_S_SUPPL_WITH_TAX@database_tdx values tpDVENDOR_S_SUPPL_WITH_TAX;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_WITH_TAX');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_WITH_TAX');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VENDOR_S_ROLES');
   commit; open vCursor1 FOR select distinct * from migdv.VENDOR_S_ROLES;
   loop
     fetch vCursor1 into tpDVENDOR_S_ROLES;
        exit when vCursor1%notfound;
     insert into migdv.VENDOR_S_ROLES@database_tdx values tpDVENDOR_S_ROLES;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_ROLES');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_ROLES');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VENDOR_S_SUPPL_IDENT');
   commit; open vCursor1 FOR select * from migdv.VENDOR_S_SUPPL_IDENT;
   loop
     fetch vCursor1 into tpDVENDOR_S_SUPPL_IDENT;
        exit when vCursor1%notfound;
     insert into migdv.VENDOR_S_SUPPL_IDENT@database_tdx values tpDVENDOR_S_SUPPL_IDENT;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_IDENT');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_IDENT');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = 0,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VENDOR_S_SUPPL_TAXNUMBERS');
   commit; open vCursor1 FOR select * from migdv.VENDOR_S_SUPPL_TAXNUMBERS;
   loop
     fetch vCursor1 into tpDVENDOR_S_SUPPL_TAXNUMBERS;
        exit when vCursor1%notfound;
     insert into migdv.VENDOR_S_SUPPL_TAXNUMBERS@database_tdx values tpDVENDOR_S_SUPPL_TAXNUMBERS;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_TAXNUMBERS');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VENDOR_S_SUPPL_TAXNUMBERS');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
  


End If;

If nvl(pVend,'N') = 'S' Then
  
   delete migdv.Vend_Ext_s_Roles@database_tdx;
   commit;
   delete migdv.Vend_Ext_s_Suppl_Gen@database_tdx;
   commit;
   delete migdv.Vend_Ext_s_Suppl_Ident@database_tdx;
   commit;
   delete migdv.Vend_Ext_s_Suppl_Taxnumbers@database_tdx;
   commit;
   delete migdv.Vend_Ext_s_Suppl_With_Tax@database_tdx;
   commit;

   --  ************************** 
 Begin
   i := 0 ;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_WITH_TAX');
   commit; open vCursor1 FOR select * from migdv.VEND_EXT_S_SUPPL_WITH_TAX;
   loop
     fetch vCursor1 into tpDvend_ext_s_suppl_with_tax;
        exit when vCursor1%notfound;
     insert into migdv.VEND_EXT_S_SUPPL_WITH_TAX@database_tdx values tpDvend_ext_s_suppl_with_tax;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_WITH_TAX');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_WITH_TAX');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VEND_EXT_S_ROLES');
   commit; open vCursor1 FOR select distinct * from migdv.VEND_EXT_S_ROLES;
   loop
     fetch vCursor1 into tpDvend_ext_s_roles;
        exit when vCursor1%notfound;
     insert into migdv.VEND_EXT_S_ROLES@database_tdx values tpDvend_ext_s_roles;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_ROLES');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_ROLES');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_GEN');
   commit; open vCursor1 FOR select * from migdv.VEND_EXT_S_SUPPL_GEN x ;
   loop
     fetch vCursor1 into tpDvend_ext_s_suppl_gen;
        exit when vCursor1%notfound;
     insert into migdv.VEND_EXT_S_SUPPL_GEN@database_tdx values tpDvend_ext_s_suppl_gen;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_GEN');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_GEN');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_IDENT');
   commit; open vCursor1 FOR select * from migdv.VEND_EXT_S_SUPPL_IDENT;
   loop
     fetch vCursor1 into tpDvend_ext_s_suppl_ident;
        exit when vCursor1%notfound;
     insert into migdv.VEND_EXT_S_SUPPL_IDENT@database_tdx values tpDvend_ext_s_suppl_ident;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_IDENT');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_IDENT');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_TAXNUMBERS');
   commit; open vCursor1 FOR select * from migdv.VEND_EXT_S_SUPPL_TAXNUMBERS;
   loop
     fetch vCursor1 into tpDvend_ext_s_suppl_taxnumbers;
        exit when vCursor1%notfound;
     insert into migdv.vend_ext_s_suppl_taxnumbers@database_tdx values tpDvend_ext_s_suppl_taxnumbers;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_TAXNUMBERS');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('VEND_EXT_S_SUPPL_TAXNUMBERS');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
  


End If;


If nvl(pEquipamento,'N') = 'S' then

   delete migdv.EQUIPMENT_S_EQUI@database_tdx;
   commit;
   delete migdv.FUNC_LOC_S_FUN_LOCATION@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('EQUIPMENT_S_EQUI');
   commit; open vCursor1 FOR select * from migdv.EQUIPMENT_S_EQUI;
   loop
     fetch vCursor1 into tpDEQUIPMENT_S_EQUI;
        exit when vCursor1%notfound;
     insert into migdv.EQUIPMENT_S_EQUI@database_tdx values tpDEQUIPMENT_S_EQUI;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('EQUIPMENT_S_EQUI');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('EQUIPMENT_S_EQUI');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('FUNC_LOC_S_FUN_LOCATION');
   commit; open vCursor1 FOR select * from migdv.FUNC_LOC_S_FUN_LOCATION;
   loop
     fetch vCursor1 into tpDFUNC_LOC_S_FUN_LOCATION;
        exit when vCursor1%notfound;
     
     If tpDFUNC_LOC_S_FUN_LOCATION.EXTERNAL_NUMBER <> ' ' Then
        insert into migdv.FUNC_LOC_S_FUN_LOCATION@database_tdx values tpDFUNC_LOC_S_FUN_LOCATION;
     End If;   
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FUNC_LOC_S_FUN_LOCATION');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('FUNC_LOC_S_FUN_LOCATION');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

End If;

If nvl(pMaterial,'N') = 'S' Then
  
   delete migdv.MATERIAL_S_MAKT@database_tdx;
   delete migdv.MATERIAL_S_MARA@database_tdx;
   delete migdv.MATERIAL_S_MLAN@database_tdx;
   delete migdv.MATERIAL_S_MBEW@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('MATERIAL_S_MAKT');
   commit; open vCursor1 FOR select * from migdv.MATERIAL_S_MAKT;
   loop
     fetch vCursor1 into tpDMATERIAL_S_MAKT;
        exit when vCursor1%notfound;
     insert into migdv.MATERIAL_S_MAKT@database_tdx values tpDMATERIAL_S_MAKT;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MAKT');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MAKT');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('MATERIAL_S_MARA');
   commit; open vCursor1 FOR select * from migdv.MATERIAL_S_MARA;
   loop
     fetch vCursor1 into tpDMATERIAL_S_MARA;
        exit when vCursor1%notfound;
     insert into migdv.MATERIAL_S_MARA@database_tdx values tpDMATERIAL_S_MARA;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MARA');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MARA');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('MATERIAL_S_MLAN');
   commit; open vCursor1 FOR select * from migdv.MATERIAL_S_MLAN;
   loop
     fetch vCursor1 into tpDMATERIAL_S_MLAN;
        exit when vCursor1%notfound;
     insert into migdv.MATERIAL_S_MLAN@database_tdx values tpDMATERIAL_S_MLAN;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MLAN');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MLAN');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('MATERIAL_S_MBEW');
   commit; open vCursor1 FOR select * from migdv.MATERIAL_S_MBEW;
   loop
     fetch vCursor1 into tpDMATERIAL_S_MBEW;
        exit when vCursor1%notfound;
     insert into migdv.MATERIAL_S_MBEW@database_tdx values tpDMATERIAL_S_MBEW;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MBEW');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('MATERIAL_S_MBEW');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

End If;

If nvl(pMeioTransp,'N') = 'S' Then

   delete migdv.LINHA_MEIO_TRANSP@database_tdx;
   delete migdv.LINHA_TRANSPORTE@database_tdx;
   delete migdv.ZONA_TRANSPORTE@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('LINHA_MEIO_TRANSP');
   commit; open vCursor1 FOR select * from migdv.LINHA_MEIO_TRANSP;
   loop
     fetch vCursor1 into tpDLINHA_MEIO_TRANSP;
        exit when vCursor1%notfound;
     insert into migdv.LINHA_MEIO_TRANSP@database_tdx values tpDLINHA_MEIO_TRANSP;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('LINHA_MEIO_TRANSP');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('LINHA_MEIO_TRANSP');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('LINHA_TRANSPORTE');
   commit; open vCursor1 FOR select * from migdv.LINHA_TRANSPORTE;
   loop
     fetch vCursor1 into tpDLINHA_TRANSPORTE;
        exit when vCursor1%notfound;
     insert into migdv.LINHA_TRANSPORTE@database_tdx values tpDLINHA_TRANSPORTE;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('LINHA_TRANSPORTE');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('LINHA_TRANSPORTE');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('ZONA_TRANSPORTE');
   commit; open vCursor1 FOR select * from migdv.ZONA_TRANSPORTE;
   loop
     fetch vCursor1 into tpDZONA_TRANSPORTE;
        exit when vCursor1%notfound;
     insert into migdv.ZONA_TRANSPORTE@database_tdx values tpDZONA_TRANSPORTE;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('ZONA_TRANSPORTE');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('ZONA_TRANSPORTE');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 

End If;

If nvl(pContaPagar,'N') = 'S' Then
   delete migdv.OPEN_ITEM_AP_S_BSIK@database_tdx;
   delete migdv.Open_Item_Ap_s_Bset@database_tdx;
   delete migdv.Open_Item_Ap_s_With_Item@database_tdx;
   commit;
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_WITH_ITEM');
   commit; open vCursor1 FOR select * from migdv.OPEN_ITEM_AP_S_WITH_ITEM X ;
   loop
     fetch vCursor1 into tpDOpen_Item_Ap_s_With_Item;
        exit when vCursor1%notfound;
     begin
        insert into migdv.Open_Item_Ap_s_With_Item@database_tdx values tpDOpen_Item_Ap_s_With_Item;
     exception
       When OTHERS then
          DBMS_OUTPUT.put_line('OPEN_ITEM_AP_S_WITH_ITEM - ' || tpDOpen_Item_Ap_s_With_Item.Xblnr   || chr(10) || SQLERRM);
       End ;
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_WITH_ITEM');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_WITH_ITEM');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line('Open_Item_Ap_s_With_Item - ' || tpDOpen_Item_Ap_s_With_Item.Xblnr   || chr(10) || SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_BSIK');
   commit; open vCursor1 FOR select distinct * from migdv.OPEN_ITEM_AP_S_BSIK X ;
   loop
     fetch vCursor1 into tpDOPEN_ITEM_AP_S_BSIK;
        exit when vCursor1%notfound;
     begin
        insert into migdv.OPEN_ITEM_AP_S_BSIK@database_tdx values tpDOPEN_ITEM_AP_S_BSIK;
     exception
       When OTHERS then
         DBMS_OUTPUT.put_line('Open_Item_Ap_s_Bsik - ' || tpDOpen_Item_Ap_s_Bsik.Xblnr || chr(10) || SQLERRM);
         i := i + 1;
       End ;
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_BSIK');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_BSIK');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line('Open_Item_Ap_s_Bsik - ' || tpDOpen_Item_Ap_s_Bsik.Xblnr || chr(10) || SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_BSET');
   commit; open vCursor1 FOR select * from migdv.OPEN_ITEM_AP_S_BSET X ;
   loop
     fetch vCursor1 into tpDOpen_Item_Ap_s_Bset;
        exit when vCursor1%notfound;
     begin
        insert into migdv.Open_Item_Ap_s_Bset@database_tdx values tpDOpen_Item_Ap_s_Bset;
     exception
       When OTHERS then
         DBMS_OUTPUT.put_line('Open_Item_Ap_s_Bset - ' || tpDOpen_Item_Ap_s_Bset.Xblnr || '-' || tpDOPEN_ITEM_AP_S_BSET.BUZEI  || chr(10) || SQLERRM);
         i := i + 1;
       End ;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_BSET');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AP_S_BSET');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line('Open_Item_Ap_s_Bset - ' || tpDOpen_Item_Ap_s_Bset.Xblnr || '-' || tpDOPEN_ITEM_AP_S_BSET.BUZEI  || chr(10) || SQLERRM);
     End;

End If;

If nvl(pContaReceber,'N') = 'S' Then
  
   delete migdv.Open_Item_Ar_s_Bsid@database_tdx;
   delete migdv.oPEN_ITEM_AR_S_BSET@database_tdx;
   delete migdv.OPEN_ITEM_AR_S_WITH_ITEM@database_tdx;
   commit;

   --  ************************** 


   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('OPEN_ITEM_AR_S_BSID');
   commit; open vCursor1 FOR select * from migdv.OPEN_ITEM_AR_S_BSID X ;
   loop
     fetch vCursor1 into tpDOpen_Item_Ar_s_Bsid;
        exit when vCursor1%notfound;
     begin
        insert into migdv.Open_Item_Ar_s_Bsid@database_tdx values tpDOpen_Item_Ar_s_Bsid;
     exception
       When OTHERS then
        DBMS_OUTPUT.put_line('Open_Item_Ar_s_Bsid - ' || tpDOpen_Item_Ar_s_Bsid.Xblnr || chr(10) || SQLERRM);
         i := i + 1;
       End ;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AR_S_BSID');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('OPEN_ITEM_AR_S_BSID');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line('Open_Item_Ar_s_Bsid - ' || tpDOpen_Item_Ar_s_Bsid.Xblnr || chr(10) || SQLERRM);
     End;

   --  ************************** 

End If;

If nvl(pRecurso,'N') = 'S' Then
  
   delete migdv.recurso@database_tdx;
   delete migdv.qualif_recurso@database_tdx;
   commit;

   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('RECURSO');
   commit; open vCursor1 FOR select * from migdv.RECURSO X ;
   loop
     fetch vCursor1 into tpDrecurso;
        exit when vCursor1%notfound;
     insert into migdv.recurso@database_tdx values tpDrecurso;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('RECURSO');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('RECURSO');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 
   Begin
     i := 0;
  update migdv.v_controle c 
     set c.qtdetdh = 0,c.inicioh = sysdate,c.terminoh = null,c.tempoh = null 
  where trim(c.tabela) in ('QUALIF_RECURSO');
   commit; open vCursor1 FOR select * from migdv.QUALIF_RECURSO X ;
   loop
     fetch vCursor1 into tpDQUALIF_RECURSO;
        exit when vCursor1%notfound;
     insert into migdv.qualif_recurso@database_tdx values tpDQUALIF_RECURSO;
     
     i := i + 1;
     If mod(i,pQtdecommit) = 0 Then commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('QUALIF_RECURSO');
        commit;
     End If;
   end loop; commit;
  update migdv.v_controle c 
     set c.qtdetdh = i,c.terminoh = sysdate,c.tempoh = tdvadm.fn_calcula_tempodecorrido(c.inicioh,sysdate,'H')
  where trim(c.tabela) in ('QUALIF_RECURSO');
   close vCursor1;
   commit;
   exception
     When OTHERS Then
        DBMS_OUTPUT.put_line(SQLERRM);
     End;
   --  ************************** 


End If;

End sp_MigrandoTDVxSAP;


Procedure Sp_AtualizaControle
  AS
  vScriptModelo varchar2(500) := 'select count(*) from migdv.TABELADBLINK';
  vScript       varchar2(500) ;
  vQtde   integer;
begin
  -- Test statements here
  for c_msg in (select x.tabela
                from migdv.v_controle x
                where to_char(nvl(x.termino,sysdate),'YYYYMMDDHH24MISS') >= TO_CHAR(nvl(x.atualizacao,sysdate),'YYYYMMDDHH24MISS') +10
                )
  Loop
    vScript := replace(vScriptModelo,'TABELA',c_msg.tabela);
    vScript := replace(vScript,'DBLINK','');
    Begin
       execute immediate vScript into vQtde;
       update migdv.v_controle x
         set x.qtde = vQtde,
             x.atualizacao = sysdate,
             x.tempo = tdvadm.fn_calcula_tempodecorrido(x.inicio,nvl(x.termino,sysdate),'H')
       where x.tabela = c_msg.tabela;
       commit;
    exception
      When OTHERS Then
         dbms_output.put_line(vScript || chr(10) || sqlerrm);
      End;
  End Loop;
  
  for c_msg in (select x.tabela
                from migdv.v_controle x
                where to_char(nvl(x.terminoh,sysdate),'YYYYMMDDHH24MISS') >= TO_CHAR(nvl(x.atualizacaoh,sysdate),'YYYYMMDDHH24MISS') +10
               )
  Loop
    vScript := replace(vScriptModelo,'TABELA',c_msg.tabela);
    vScript := replace(vScript,'DBLINK','@database_tdx');
    Begin
        execute immediate vScript into vQtde;
        update migdv.v_controle x
          set x.qtdetdh = vQtde,
              x.atualizacaoh = sysdate,
              x.tempoh = tdvadm.fn_calcula_tempodecorrido(x.inicioh,nvl(x.terminoh,sysdate),'H')
        where x.tabela = c_msg.tabela;
        commit;
    exception
      When OTHERS Then
         dbms_output.put_line(vScript || chr(10) || sqlerrm);
      End;
  End Loop;
  
--  open :vCursor for select x.*,x.qtde - x.qtdetdh dif
--                    from migdv.v_controle x
--                    where x.grupo like '%(DM)%'
--                      and x.tabela like '%_GEN%'
--                    ;
 

End Sp_AtualizaControle;


END pkg_migracao_sap;
/
