create or replace package migdv.pkg_migracao_sap2 is


vDATA_CORTE    DATE         := to_date('01/01/2019','dd/mm/yyyy');  
vTIPO_ENDERECO CHAR(1)      := 'E';                                  
vVALOR_VENCIDO VARCHAR2(50) := '0'; 
vCOD_COMPANHIA CHAR(4)      := '1000';   


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

-- RESPONS�VEL POR CHAMAR TODAS AS PROCEDURES DE IMPORTA��O 
-- E DEFINIR AS CONSTANTES DO PAKAGE                                       


Function fn_busca_codigoSAP(pClienteTDV in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
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


-- Insere quando � Cliente e Fornecedor                                             
procedure SP_SAP_INSERE_FORNECEDOR_CLI(PKUNNR     IN CHAR,
                                       PREF_KUNNR IN CHAR,
                                       PRESULTADO OUT Char,
                                       PMENSAGEM  OUT VARCHAR2);

-- Insere quando � apenas Fornecedor                                           
procedure SP_SAP_INSERE_FORNECEDOR(PDATA_CORTE IN CHAR,
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2);
                                   

                                  
-- Insere Dados banc�rios do Fornecedor                                           
procedure SP_SAP_INSERE_FORNECEDOR_SUPP_BANK(PIDFORNECEDOR IN CHAR,
                                             PRESULTADO OUT Char,
                                             PMENSAGEM OUT VARCHAR2);
                                   

-- Insere Impostos Retido do documento Fornecedor
procedure SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO(PIDFORNECEDOR IN CHAR,
                                                  PRESULTADO OUT Char,
                                                  PMENSAGEM OUT VARCHAR2);


-- Insere Endere�os adicionais do Fornecedor                                           
procedure SP_SAP_INSERE_FORNECEDOR_ENDERECO_ADICIONAL(PIDFORNECEDOR IN CHAR,
                                                      PRESULTADO OUT Char,
                                                      PMENSAGEM OUT VARCHAR2);
                                   
-- Insere Ativo Fixo da empresa
procedure SP_SAP_INSERE_ATIVOS_FIXO(PIDATIVO IN CHAR,
                                    PRESULTADO OUT Char,
                                    PMENSAGEM OUT VARCHAR2);


-- Insere valora��o do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_VALORACAO(PIDATIVO IN CHAR,
                                        PRESULTADO OUT Char,
                                        PMENSAGEM OUT VARCHAR2);

                                         
-- Insere data de entrada e exerc�cio do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_DATAENTRADA(PIDATIVO IN CHAR,
                                          PRESULTADO OUT Char,
                                          PMENSAGEM OUT VARCHAR2);

-- Insere Equipamento
procedure SP_SAP_INSERE_EQUIPAMENTO(PRESULTADO OUT Char,
                                    PMENSAGEM OUT VARCHAR2);

-- Insere Local de Instala��o
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

-- Insere Dados de localiza��o do Material
procedure SP_SAP_INSERE_MATERIAL_DADOS_LOCALIZACAO(P_TPMATERIAL_S_MARD IN MIGDV.MATERIAL_S_MARD%ROWTYPE,
                                                   PRESULTADO OUT Char,
                                                   PMENSAGEM OUT VARCHAR2);


-- Insere Classifica��o fiscal do Material
procedure SP_SAP_INSERE_MATERIAL_CLASSIFICACAO_FISCAL(P_TPMATERIAL_S_MLAN IN MIGDV.MATERIAL_S_MLAN%ROWTYPE,
                                                      PRESULTADO OUT Char,
                                                      PMENSAGEM OUT VARCHAR2);


-- Insere Lista de descri��es do Material
procedure SP_SAP_INSERE_MATERIAL_LISTA_DESCRICAO(P_TPMATERIAL_S_MAKT IN MIGDV.MATERIAL_S_MAKT%ROWTYPE,
                                                 PRESULTADO OUT Char,
                                                 PMENSAGEM OUT VARCHAR2);


-- Insere Documentos Contas Pagar
procedure SP_SAP_INSERE_CONTAS_PAGAR_DOCUMENTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);


-- Insere Impostos do documento Contas Pagar
procedure SP_SAP_INSERE_CONTAS_PAGAR_IMPOSTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);

                                                 
-- Insere Impostos Retido do documento Contas Pagar
procedure SP_SAP_INSERE_CONTAS_PAGAR_IMPOSTOS_RETIDO(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);


-- Insere Documentos Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);


-- Insere Impostos do documento Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_IMPOSTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);

-- Insere Impostos Retidos do documento Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_IMPOSTOS_RETIDO(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2);


end pkg_migracao_sap2;
/
CREATE OR REPLACE PACKAGE BODY MIGDV.pkg_migracao_sap2 IS
  vErro varchar2(10000);

--PRODPERIGOSO EXERCITO - Z023
--Licenca especial PP - Z024
--Tipo de VEiculo ( TRUCK / CARRETA ) Z013 
--CNH - Z001
--MOPE - Z002
--CARGA INDIVISIVEL - Z003
--PIS - Z005
--RNTRC - Z008
--CARTAO - ZCAR Pamcary
--MATRICULA - Z011


-- Grant/Revoke object privileges 
--grant select, references on FUNCIONA to MIGDV with grant option;
--grant select, references on MUNICIP to MIGDV with grant option;
--grant select, references on CARGOS to MIGDV with grant option;
--grant select, references on SITUACAO to MIGDV with grant option;

/*
Codigos dos 
� 1099 - INSS Carreteiros;
� 1218 - SEST Carreteiros;
� 1221 - SENAT Carreteiros;
� 0588 - IRRF Carreteiros;
� 1162 - INSS Retido de Fornecedores PESSOA JUR�DICA;
� 1099 - INSS Retido de Fornecedores PESSOA F�SICA � RPAs;
� 1708 - IRRF Retido de Fornecedores PESSOA JUR�DICA;
� 0588 - IRRF Retido de Fornecedores PESSOA F�SICA � RPAs;
� 3208 - IRRF Retido de Fornecedores PESSOA F�SICA � ALUGUEL;
� 5952 - CSRF Retido de Fornecedores PESSOA JUR�DICA;
� 5960 - Cofins Retido, relacionado ao c�digo 5952, quando n�o houver a reten��o de PIS ou CSLL;
� 5979 - PIS Retido, relacionado ao c�digo 5952, quando n�o houver a reten��o da Cofins ou CSLL;
� 5987 - CSLL Retido, relacionado ao c�digo 5952, quando n�o houver a reten��o de PIS ou Cofins;
� 1300 - ISS retido de Fornecedores Pessoa Jur�dica;
*/


/*
update tdvadm.t_glb_cliCONT ce
  set ce.GLB_CLICONT_CONTATO = replace(replace(replace(replace(replace(replace(replace(ce.GLB_CLICONT_CONTATO,'SR.',''),'SRA.',''),'SRTA.',''),'SRTA .',''),'SR,',''),'SRA,',''),'SRS.','');
  

update tdvadm.t_glb_cliCONT ce
  set ce.GLB_CLICONT_CONTATO = TRIM(replace(replace(replace(ce.GLB_CLICONT_CONTATO,'SRA',''),'SRTA',''),'SR',''));
*/



-- ARRUMAR A GLB_PAIS_SIGLASAP NA TABELA DE PAISES
-- update tdvadm.t_glb_cliente cli
--  set cli.glb_cliente_dtutlmov = greatest(NVL(CLI.glb_cliente_dtultmovsac, SYSDATE-1000), 
--                                          NVL(CLI.glb_cliente_dtultmovrem, SYSDATE-1000),
--                                          NVL(CLI.glb_cliente_dtultmovdest, SYSDATE-1000));
-- COMMIT;
-- C.GLB_CLIEND_COMPLEMENTO acima de 40 posicoes na tabela de cliente
                                          
/*

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

Function fn_busca_codigoSAP(pClienteTDV in tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                            pTipo       in varchar2) return varchar2
 As
  vRetorno migdv.customer_s_cust_gen.kunnr%type;
Begin
  
  vRetorno := null; 
  Begin
      If pTipo = 'CLI' Then
          select kunnr
            into vRetorno
          from migdv.customer_s_cust_gen g  
          where g.SORTL = trim(pClienteTDV);
      Else
          select lifnr 
            into vRetorno
          from migdv.vendor_s_suppl_gen g  
          where g.SORTL = trim(pClienteTDV);
      End If;
  exception
    When OTHERS Then
      vRetorno := null;
    End ;
  Return vRetorno;

End fn_busca_codigoSAP;


-- RESPONS�VEL POR CHAMAR TODAS AS PROCEDURES DE IMPORTA��O 
-- E DEFINIR AS CONSTANTES DO PAKAGE
procedure SP_SAP_PRINCIPAL(PDATA_CORTE IN VARCHAR2,
                           PRESULTADO OUT Char,
                           PMENSAGEM OUT VARCHAR2) is
begin
    /* CENTRALIZA��O DAS CONSTANTES DO PACOTE */
    vDATA_CORTE    := '01/01/2019';
    vTIPO_ENDERECO := 'E';
    vVALOR_VENCIDO := '0';
    vCOD_COMPANHIA := '1000';

end SP_SAP_PRINCIPAL;


procedure SP_SAP_INSERE_ZONATRANSPORTE
  IS
   tpZonaTransporte migdv.zona_transporte%rowtype;
Begin
  
   For c_msg in (select distinct *
                 from (SELECT TRIM(L.GLB_LOCALIDADE_CODIGO) cod_zonatransporte,
                              l.glb_localidade_cepdef,
                              SUBSTR(TRIM(L.GLB_ESTADO_CODIGO) || '-' || TRIM(L.GLB_LOCALIDADE_DESCRICAO),1,20) nom_zonatransporte,
                              'BR' cod_pais,
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
     commit;     
   End Loop;
  
End SP_SAP_INSERE_ZONATRANSPORTE;


procedure SP_SAP_INSERE_LINHATRANSPORTE
  IS
   tpLinhTransporte migdv.linha_transporte%rowtype;
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
     commit;     
   End Loop;
  
End SP_SAP_INSERE_LINHATRANSPORTE;


procedure SP_SAP_INSERE_LINHA_MEIO_TRANSPORTE
  IS
   tpLinha_Meio_Transporte migdv.linha_meio_transp%rowtype;
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
                    
                                                                            '3  -TRUCK (at� 14 ton)'       ,'ZTM01',
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
                                                                            '22 -UTILITARIO (at� 1,5 ton)' ,'ZTM03',
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
                 where 0 = 0)
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
     commit;     
   End Loop;
  
End SP_SAP_INSERE_LINHA_MEIO_TRANSPORTE;







-- Inseri Bancos na tabela BANK_MASTER_S_BNKA 
procedure SP_SAP_INSEREBANCO(PBANCO IN CHAR,
                             PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2) is
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
 
            tpBANK_MASTER_S_BNKA.BANKS := 'BR'; -- Obrigat�rio(S) - Chave do pa�s do banco
            tpBANK_MASTER_S_BNKA.BANKL := LPAD(TRIM(PBANCO), 3, '0') || TRIM(vCursor.AGENCIA_NUMERO); -- Obrigat�rio(S) - Chave do banco, composta pelo n�mero do banco (com d�gito) concatenado com o n�mero da ag�ncia (sem d�gito)
            tpBANK_MASTER_S_BNKA.BANKA := TRIM(vCursor.BANCO_NOME) || ' - AG ' || LPAD(TRIM(vCursor.AGENCIA_NUMERO), 5, '0'); -- Obrigat�rio(S) - Nome da ag�ncia / banco que identifica esta unidade.
            tpBANK_MASTER_S_BNKA.PROVZ := 'SP / ' || vCursor.AGENCIA_NOME; -- Obrigat�rio(N) - UF do Banco / Agencia
            tpBANK_MASTER_S_BNKA.STRAS := ' '; -- Obrigat�rio(N) - Endere�o do Banco / Agencia
            tpBANK_MASTER_S_BNKA.ORT01 := ' '; -- Obrigat�rio(N) - Cidade do Banco / Agencia
            tpBANK_MASTER_S_BNKA.BNKLZ := NVL(LPAD(TRIM(vCursor.BANCO_NUMERO), 3, '0'), ' '); -- Obrigat�rio(N) - N�mero do banco
              
            begin
               INSERT INTO MIGDV.BANK_MASTER_S_BNKA VALUES tpBANK_MASTER_S_BNKA;
               commit;
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
                    

end SP_SAP_INSEREBANCO;


procedure SP_SAP_BANCO_TODOS(PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2) is
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
begin
  vCount := 0;
  
  SELECT DISTINCT
         CLI.GLB_BANCO_NUMERO,
         'BR' GLB_PAIS_SIGLASAP
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
            
        tpBANK_MASTER_S_BNKA_DATA.KUNNR        := PIDCLIENTE; -- Obrigat�rio(S) - Identificador do cliente
        tpBANK_MASTER_S_BNKA_DATA.BANKS        := NVL(vSiglaPais, ' '); -- Obrigat�rio(N) - Pa�s do banco
        tpBANK_MASTER_S_BNKA_DATA.BANKL        := LPAD(RTRIM(vBancoNumero),3,'0') || TRIM(vAgencia); -- Obrigat�rio(N) - Identificador do Banco/Agencia
        tpBANK_MASTER_S_BNKA_DATA.BANKN        := NVL(vContaNumero, ' '); -- Obrigat�rio(N) - Conta (Acc. No. ou IBAN)
        tpBANK_MASTER_S_BNKA_DATA.IBAN         := ' '; -- Obrigat�rio(N) - ""IBAN, conforme padr�o de identidade internacional de contas banc�rias; composto por:2 caracteres alfanum�ricos que correspondem ao c�digo do Pa�s;2 d�gitos verificadores, que est�o na faixa de faixa de 02 a 98;8 caracteres num�ricos que se referem � identifica��o da institui��o financeira (ISPB);5 caracteres num�ricos correspondentes � identifica��o da ag�ncia banc�ria (sem o d�gito verificador);10 caracteres num�ricos que correspondem a numera��o da conta banc�ria do cliente, incluindo o d�gito verificador;1 caractere alfanum�rico referente ao tipo de conta;1 caractere alfanum�rico relacionado � identifica��o do titular da conta seguindo a ordem da listagem de titulares ( sendo �1� usado para primeiro ou �nico titular, �2� para o segundo titular... �A� para o d�cimo titular, e assim por diante, usando os caracteres alfab�ticos de �A� a �Z� para os titulares a partir do d�cimo).""
        tpBANK_MASTER_S_BNKA_DATA.BKONT        := ' '; -- Obrigat�rio(N) - Chave de controle do banco
        tpBANK_MASTER_S_BNKA_DATA.KOINH        := ' '; -- Obrigat�rio(N) - Nome do titular da conta
        tpBANK_MASTER_S_BNKA_DATA.EBPP_ACCNAME := NVL(vBancoNome, ' '); -- Obrigat�rio(N) - Nome da conta
        tpBANK_MASTER_S_BNKA_DATA.XEZER        := ' '; -- Obrigat�rio(N) - Indicador de Autoriza��o de Cobran�a
              
        INSERT INTO MIGDV.CUSTOMER_S_CUST_BANK_DATA VALUES tpBANK_MASTER_S_BNKA_DATA;
        COMMIT;      
        PRESULTADO := 'N';
        PMENSAGEM  := 'Informa��o do banco inserida com sucesso na tabela do SAP';

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
                       '01' spart
                from migdv.meta_dominio_coluna d,
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
     Begin
        INSERT INTO MIGDV.CUSTOMER_S_CUST_SALES_DATA VALUES TpTAB;
        commit;
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


     If MOD(I,1000) = 0 Then
       commit;
     End If;
   END lOOP
   commit;
   
end SP_CUSTOMER_S_CUST_SALES_DATA;


procedure SP_SAP_INSERECLIENTE(PDATA_CORTE IN VARCHAR2,
                               PTIPO_ENDERECO IN CHAR,
                               PRESULTADO OUT Char,
                               PMENSAGEM OUT VARCHAR2) is
                                        
vCount Integer;
vPosicao varchar2(130);
vIdentificadorCli number;                                        
tpCUSTOMER_S_CUST_GEN MIGDV.CUSTOMER_S_CUST_GEN%ROWTYPE;   
tpEndAdicional MIGDV.CUSTOMER_S_ADDRESS%ROWTYPE;    
tpVEND_EXT_S_SUPPL_GEN MIGDV.VEND_EXT_S_SUPPL_GEN%ROWTYPE; 
tpVENDOR_S_SUPPL_GEN MIGDV.VENDOR_S_SUPPL_GEN%ROWTYPE; 
vCliente char(20);     
vCliRed  TpCliRed;                            
begin    
    FOR vCursor IN (
/*      SELECT distinct s.tab_cidade,
                                    s.tab_estado,
                                    s.tab_pais,
                                    trim(s.tab_cep) tab_cep,
                                    s.tab_endereco,
                                    s.tab_cpf_cnpj,
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
                                    s.tipo,
                                    s.tipo_endereco
                    FROM migdv.v_pessoasSAP S
                    WHERE S.DATA_CORTE >= to_date(PDATA_CORTE,'dd/mm/yyyy') 
                      AND S.TIPO_ENDERECO = trim(PTIPO_ENDERECO)
                      and s.TIPO = 'CLI'
--                      and s.tab_cpf_cnpj in ('58256946768','89678583704','77941047772','00401430740','03376522790')     
                      and 0 = (select count(*)
                               from migdv.customer_s_cust_gen g
                               where trim(g.SORTL) = trim(s.GLB_CLIENTE_CGCCPFCODIGO))
                    union
*/                    SELECT distinct s.tab_cidade,
                                    s.tab_estado,
                                    s.tab_pais,
                                    trim(s.tab_cep) tab_cep,
                                    s.tab_endereco,
                                    s.tab_cpf_cnpj,
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
                                    s.tipo,
                                    s.tipo_endereco
                    FROM migdv.v_pessoasSAP S
                    WHERE S.DATA_CORTE >= to_date(PDATA_CORTE,'dd/mm/yyyy') 
                      AND S.TIPO_ENDERECO = trim(PTIPO_ENDERECO)
                      and s.TIPO <> 'CLI'
--                      and s.tab_cpf_cnpj in ('58256946768','89678583704','77941047772','00401430740','03376522790')     
                      and 0 = (select count(*)
                               from migdv.vendor_s_suppl_gen g
                               where trim(g.SORTL) = trim(s.GLB_CLIENTE_CGCCPFCODIGO))

                   order by 28
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
        
        If vCursor.Tipo IN ('CLI') Then
            for vCursor2 in (
                select C.KUNNR
                INTO vIdentificadorCli
                FROM MIGDV.CUSTOMER_S_CUST_GEN C
                order by to_number(C.KUNNR) desc
              )
              loop
                vIdentificadorCli := vCursor2.Kunnr;
                exit;
              end loop;


            vIdentificadorCli := nvl(vIdentificadorCli, 0)+1;
            
            tpCUSTOMER_S_CUST_GEN.KUNNR         := vIdentificadorCli; /* Obrigat�rio(S) - Identificador do Cliente */
            tpCUSTOMER_S_CUST_GEN.BU_GROUP      := '00001';  /* Obrigat�rio(S) - Agrupamento de Parceiro (Fixo 00001) */
            tpCUSTOMER_S_CUST_GEN.KTOKD         := ' '; /* Obrigat�rio(N) (S) - Grupo de Contas do Cliente */
            tpCUSTOMER_S_CUST_GEN.NAMORG1       := SUBSTR(vCursor.TAB_RAZAOSOCIAL, 1, 40); /* Obrigat�rio(N) - Nome*/
            tpCUSTOMER_S_CUST_GEN.NAMORG2       := substr(NVL(SUBSTR(vCursor.TAB_RAZAOSOCIAL, 41, LENGTH(vCursor.TAB_RAZAOSOCIAL)), ' '),1,40); /* Obrigat�rio(N) (S) - Nome 2*/
            tpCUSTOMER_S_CUST_GEN.NAMORG3       := ' '; /* Obrigat�rio(N) - Nome 3*/
            tpCUSTOMER_S_CUST_GEN.NAMORG4       := ' '; /* Obrigat�rio(N) - Nome 4*/
            tpCUSTOMER_S_CUST_GEN.SORTL         := NVL(trim(vCursor.TAB_CPF_CNPJ), '0'); /* Obrigat�rio(N) - Termo de Pesquisa 1*/
            tpCUSTOMER_S_CUST_GEN.MCOD2         := ' '; /* Obrigat�rio(N) - Termo de Pesquisa 2*/
            tpCUSTOMER_S_CUST_GEN.FOUND_DAT     := ' '; /* Obrigat�rio(N) -  Data da funda��o*/
            tpCUSTOMER_S_CUST_GEN.LIQUID_DAT    := ' '; /* Obrigat�rio(N) -  Data de liquida��o*/
            tpCUSTOMER_S_CUST_GEN.KUKLA         := '00001';    /* Obrigat�rio(N) -  Classifica��o do Cliente (Fixo 00001) */
            tpCUSTOMER_S_CUST_GEN.SUFRAMA       := ' '; /* Obrigat�rio(N) - C�digo Suframa */
            tpCUSTOMER_S_CUST_GEN.CNAE          := ' '; /* Obrigat�rio(N) - CNAE */
            tpCUSTOMER_S_CUST_GEN.CRTN          := ' '; /* Obrigat�rio(N) - N�mero CRT */
            tpCUSTOMER_S_CUST_GEN.ICMSTAXPAY    := ' '; /* Obrigat�rio(N) - Contribuinte do ICMS */
            tpCUSTOMER_S_CUST_GEN.DECREGPC      := ' '; /* Obrigat�rio(N) - Regime de Declara��o para PIS / COFINS */
            tpCUSTOMER_S_CUST_GEN.STREET        := NVL(substr(vCursor.LIMPO_LOGRADOURO,1,60), ' '); /* Obrigat�rio(N) - Nome do Logradouro do endere�o principal.*/
            tpCUSTOMER_S_CUST_GEN.HOUSE_NUM1    := NVL(substr(vCursor.LIMPO_NUMERO,1,10), ' '); /* Obrigat�rio(N) - N�mero do Endere�o */
            tpCUSTOMER_S_CUST_GEN.CITY2         := substr(NVL(vCursor.BAIRRO, ' '),1,40); --**verificar /* Obrigat�rio(N) - Bairro do endere�o principal */ 
            if vCursor.CEP_ENDERECO is not null Then
               If trim(vCursor.TAB_CEP) <> '-' Then
                  tpCUSTOMER_S_CUST_GEN.POST_CODE1 := trim(vCursor.TAB_CEP); -- **verificar 00000 NAO MANDAR NADA/* Obrigat�rio(N) - CEP do endere�o principal */
               Else
                  tpCUSTOMER_S_CUST_GEN.POST_CODE1 := ' ';   
               End If;
            Else
               tpCUSTOMER_S_CUST_GEN.POST_CODE1 := ' ';   
            End If;
            tpCUSTOMER_S_CUST_GEN.CITY1         := NVL(TRIM(substr(vCursor.TAB_CIDADE,1,40)), ' '); /* Obrigat�rio(N) - Cidade do endere�o principal */
            tpCUSTOMER_S_CUST_GEN.COUNTRY       := NVL(vCursor.SIGLA_SAP, ' '); /* Obrigat�rio(S) - Pa�s do endere�o principal */
            tpCUSTOMER_S_CUST_GEN.REGION        := NVL(substr(vCursor.TAB_ESTADO,1,80), ' '); /* Obrigat�rio(N) - Estado/UF do endere�o principal */ 
            tpCUSTOMER_S_CUST_GEN.STR_SUPPL1    := vCursor.ESTADO; -- /* Obrigat�rio(N) - Segundo campo de logradouro do endere�o principal do cliente */
            tpCUSTOMER_S_CUST_GEN.HOUSE_NO2     := NVL(SUBSTR(vCursor.LIMPO_COMPLEMENTO,1, 10), ' '); /* Obrigat�rio(N) - Complemento do Endere�o principal do cliente */
            tpCUSTOMER_S_CUST_GEN.PO_BOX        := ' '; /* Obrigat�rio(N) - Caixa postal */
            tpCUSTOMER_S_CUST_GEN.POST_CODE2    := ' '; /* Obrigat�rio(N) - CEP da caixa postal */
            tpCUSTOMER_S_CUST_GEN.PO_BOX_LOC    := ' '; /* Obrigat�rio(N) - Cidade da Caixa postal */
            tpCUSTOMER_S_CUST_GEN.POBOX_CTRY    := ' '; /* Obrigat�rio(N) - Pa�s da caixa postal */
            tpCUSTOMER_S_CUST_GEN.PO_BOX_REG    := ' '; /* Obrigat�rio(N) - Estado/UF da caixa postal */ 
            tpCUSTOMER_S_CUST_GEN.LANGU_CORR    := 'PT'; /* Obrigat�rio(N) - Idioma */
            tpCUSTOMER_S_CUST_GEN.TELNR_LONG    := ' '; /* Obrigat�rio(N) - Telefone */ 
            tpCUSTOMER_S_CUST_GEN.TELNR_LONG_2  := ' '; /* Obrigat�rio(N) - Telefone Adicional 2 */
            tpCUSTOMER_S_CUST_GEN.TELNR_LONG_3  := ' '; /* Obrigat�rio(N) - Telefone Adicional 3 */
            tpCUSTOMER_S_CUST_GEN.MOBILE_LONG   := ' '; /* Obrigat�rio(N) - Celular */
            tpCUSTOMER_S_CUST_GEN.MOBILE_LONG_2 := ' '; /* Obrigat�rio(N) - Celular adicional 2 */
            tpCUSTOMER_S_CUST_GEN.MOBILE_LONG_3 := ' '; /* Obrigat�rio(N) - Celular adicional 3 */
            tpCUSTOMER_S_CUST_GEN.FAXNR_LONG    := ' '; /* Obrigat�rio(N) - Fax */
            tpCUSTOMER_S_CUST_GEN.FAXNR_LONG_2  := ' '; /* Obrigat�rio(N) - Fax adicional 2 */
            tpCUSTOMER_S_CUST_GEN.FAXNR_LONG_3  := ' '; /* Obrigat�rio(N) - Fax adicional 3 */
            tpCUSTOMER_S_CUST_GEN.SMTP_ADDR     := ' '; /* Obrigat�rio(N) - Email */
            tpCUSTOMER_S_CUST_GEN.SMTP_ADDR_2   := ' '; /* Obrigat�rio(N) - E-mail adicional 2 */
            tpCUSTOMER_S_CUST_GEN.SMTP_ADDR_3   := ' '; /* Obrigat�rio(N) - E-mail adicional 3 */
            tpCUSTOMER_S_CUST_GEN.URI_TYP       := ' '; /* Obrigat�rio(N) - Tipo de Comunica��o */
            tpCUSTOMER_S_CUST_GEN.URI_ADDR      := ' '; /* Obrigat�rio(N) - Web Site */
            tpCUSTOMER_S_CUST_GEN.SPERR         := ' '; /* Obrigat�rio(N) - Bloqueio de Postagem - Central */
            tpCUSTOMER_S_CUST_GEN.COLLMAN       := ' '; /* Obrigat�rio(N) - Gerenciamento de Cobran�a ativo */
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
            INSERT INTO MIGDV.CUSTOMER_S_CUST_GEN VALUES tpCUSTOMER_S_CUST_GEN;
            
            COMMIT;
        ElsIf vCursor.Tipo IN ('PRO','CAR','FOR','FPW') Then

            for vCursor2 in (
                select C.LIFNR
                INTO vIdentificadorCli
                FROM MIGDV.VENDOR_S_SUPPL_GEN C
                order by to_number(C.LIFNR) desc
              )
              loop
                vIdentificadorCli := vCursor2.LIFNR;
                exit;
              end loop;

          vIdentificadorCli := nvl(vIdentificadorCli,0) + 1;          

          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
            tpVENDOR_S_SUPPL_GEN.BPKIND := ' '; 
           
            tpVENDOR_S_SUPPL_GEN.LIFNR         := vIdentificadorCli; -- Obrigat�rio(S) - Identificador do Fornecedor
            If vCursor.Tipo IN ('PRO') Then
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00002'; -- Obrigat�rio(S) - Agrupamento de Parceiro (fixo 00001)
               If vCursor.Tipo2 = 'C' Then
                  tpVENDOR_S_SUPPL_GEN.BPKIND := 'Z002'; -- Terceiros/Dedicado
               ElsIf vCursor.Tipo2 = 'A' Then
                  tpVENDOR_S_SUPPL_GEN.BPKIND := 'Z004'; -- Agregado
               Else
                  tpVENDOR_S_SUPPL_GEN.BPKIND := ' ';
               end If;
            ElsIf vCursor.Tipo IN ('CAR') Then
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00003'; -- Obrigat�rio(S) - Agrupamento de Parceiro (fixo 00001)
               If vCursor.Tipo2 = 'C' Then
                  tpVENDOR_S_SUPPL_GEN.BPKIND := 'Z002'; -- Terceiros/Dedicado
               ElsIf vCursor.Tipo2 = 'A' Then
                  tpVENDOR_S_SUPPL_GEN.BPKIND := 'Z004'; -- Agregado
               Else
                  tpVENDOR_S_SUPPL_GEN.BPKIND := ' ';
               end If;
            ElsIf vCursor.Tipo IN ('FOR') Then
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00004'; -- Obrigat�rio(S) - Agrupamento de Parceiro (fixo 00001)
               tpVENDOR_S_SUPPL_GEN.BPKIND := ' ';
            ElsIf vCursor.Tipo IN ('FPW') Then
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00005'; -- Obrigat�rio(S) - Agrupamento de Parceiro (fixo 00001)
               tpVENDOR_S_SUPPL_GEN.BPKIND        := 'Z003'; -- Frota
            Else
               tpVENDOR_S_SUPPL_GEN.BU_GROUP      := ' '; 
               tpVENDOR_S_SUPPL_GEN.BPKIND        := ' '; 
            End If;    
            tpVENDOR_S_SUPPL_GEN.NAME_FIRST    := SUBSTR(vCursor.TAB_RAZAOSOCIAL, 1, 35); -- Obrigat�rio(N) - Nome
            tpVENDOR_S_SUPPL_GEN.NAME_LAST     := substr(NVL(SUBSTR(vCursor.TAB_RAZAOSOCIAL, 36, LENGTH(vCursor.TAB_RAZAOSOCIAL)), ' '),1,35); -- Obrigat�rio(N) - Nome 2 
            tpVENDOR_S_SUPPL_GEN.NAME3         := ' '; -- Obrigat�rio(N) - Nome 3
            tpVENDOR_S_SUPPL_GEN.NAME4         := ' '; -- Obrigat�rio(N) - Nome 4
            tpVENDOR_S_SUPPL_GEN.SORTL         := NVL(trim(vCursor.TAB_CPF_CNPJ), '0'); -- Obrigat�rio(N) - Termo de Pesquisa 1
            tpVENDOR_S_SUPPL_GEN.MCOD2         := SUBSTR(trim(vCursor.TAB_RAZAOSOCIAL), 1, 20); -- Obrigat�rio(N) - Termo de Pesquisa 2
            tpVENDOR_S_SUPPL_GEN.FOUND_DAT     := ' '; -- Obrigat�rio(N) - Data da funda��o
            tpVENDOR_S_SUPPL_GEN.LIQUID_DAT    := ' '; -- Obrigat�rio(N) - Data de liquida��o
            tpVENDOR_S_SUPPL_GEN.MIN_COMP      := ' '; -- Obrigat�rio(N) - Indicador de micro empresa
            tpVENDOR_S_SUPPL_GEN.COMSIZE       := ' '; -- Obrigat�rio(N) - Tamanho da empresa
            tpVENDOR_S_SUPPL_GEN.DECREGPC      := ' '; -- Obrigat�rio(N) - Regime de Declara��o para PIS / COFINS
            tpVENDOR_S_SUPPL_GEN.CNAE          := ' '; -- Obrigat�rio(N) - CNAE
            tpVENDOR_S_SUPPL_GEN.CRTN          := ' '; -- Obrigat�rio(N) - N�mero CRT
            tpVENDOR_S_SUPPL_GEN.ICMSTAXPAY    := ' '; -- Obrigat�rio(N) - Contribuinte do ICMS
            tpVENDOR_S_SUPPL_GEN.STREET        := NVL(substr(vCursor.LIMPO_LOGRADOURO,1,60), ' '); -- Obrigat�rio(N) - Nome do logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.HOUSE_NUM1    := NVL(substr(vCursor.LIMPO_NUMERO,1,10), ' ');  -- Obrigat�rio(N) - N�mero do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.CITY2         := substr(NVL(vCursor.BAIRRO, ' '),1,40); -- Obrigat�rio(N) - Bairro do endere�o do fornecedor
            if vCursor.CEP_ENDERECO is not null Then
               If trim(vCursor.TAB_CEP) <> '-' Then
                  tpCUSTOMER_S_CUST_GEN.POST_CODE1 := trim(vCursor.TAB_CEP); -- **verificar 00000 NAO MANDAR NADA/* Obrigat�rio(N) - CEP do endere�o principal */
               Else
                  tpVENDOR_S_SUPPL_GEN.POST_CODE1 := ' ';   
               End If;
            Else
               tpVENDOR_S_SUPPL_GEN.POST_CODE1 := ' ';   
            End If;
            tpVENDOR_S_SUPPL_GEN.CITY1         := NVL(TRIM(substr(vCursor.TAB_CIDADE,1,40)), ' '); -- Obrigat�rio(N) - Cidade do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.COUNTRY       := NVL(vCursor.SIGLA_SAP, ' '); -- Obrigat�rio(S) - Pa�s* do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.REGION        := NVL(substr(vCursor.TAB_ESTADO,1,80), ' '); -- Obrigat�rio(N) - Estado/UF do endere�o do fornecedor 
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL1    := vCursor.ESTADO; -- Obrigat�rio(N) - Segundo campo de logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL2    := ' '; -- Obrigat�rio(N) - Terceiro campo de logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.HOUSE_NO2     := NVL(SUBSTR(vCursor.LIMPO_COMPLEMENTO,1, 10), ' '); -- Obrigat�rio(N) - Complemento do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL3    := ' '; -- Obrigat�rio(N) - Logradouro 4
            tpVENDOR_S_SUPPL_GEN.LOCATION      := ' '; -- Obrigat�rio(N) - Logradouro 5
            tpVENDOR_S_SUPPL_GEN.PO_BOX        := ' '; -- Obrigat�rio(N) - Caixa postal
            tpVENDOR_S_SUPPL_GEN.PO_BOX_CIT    := ' '; -- Obrigat�rio(N) - Cidade da Caixa postal
            tpVENDOR_S_SUPPL_GEN.POBOX_CTRY    := ' '; -- Obrigat�rio(N) - Pa�s da caixa postal
            tpVENDOR_S_SUPPL_GEN.PO_BOX_REG    := ' '; -- Obrigat�rio(N) - Estado/UF da caixa postal
            tpVENDOR_S_SUPPL_GEN.LANGU_CORR    := 'PT'; -- Obrigat�rio(N) - Idioma
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG    := ' '; -- Obrigat�rio(N) - Telefone padr�o
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG_2  := ' '; -- Obrigat�rio(N) - Telefone Adicional 2
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG_3  := ' '; -- Obrigat�rio(N) - Telefone Adicional 3
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG   := ' '; -- Obrigat�rio(N) - Celular padr�o
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG_2 := ' '; -- Obrigat�rio(N) - Celular adicional 2
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG_3 := ' '; -- Obrigat�rio(N) - Celular adicional 3
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG    := ' '; -- Obrigat�rio(N) - Fax padr�o
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG_2  := ' '; -- Obrigat�rio(N) - Fax adicional 2
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG_3  := ' '; -- Obrigat�rio(N) - Fax adicional 3
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR     := ' '; -- Obrigat�rio(N) - E-mail padr�o
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR_2   := ' '; -- Obrigat�rio(N) - E-mail adicional 2
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR_3   := ' '; -- Obrigat�rio(N) - E-mail adicional 3
            tpVENDOR_S_SUPPL_GEN.SPERR         := ' '; -- Obrigat�rio(N) - Bloqueio de Postagem - Central
            Begin
               tpVENDOR_S_SUPPL_GEN.RG := nvl(vCursor.Rg,' ');
            exception
              When OTHERS Then
                 tpVENDOR_S_SUPPL_GEN.RG := ' ';
              End;

            INSERT INTO MIGDV.VENDOR_S_SUPPL_GEN VALUES tpVENDOR_S_SUPPL_GEN;
            COMMIT;

        End If;
        PRESULTADO := 'N';
        PMENSAGEM  := 'Cliente inserido com sucesso';
        
        If vCursor.Tipo IN ('???') Then

             for c_msg in (select LIFNR
                           from MIGDV.VEND_EXT_S_SUPPL_GEN x
                           order by TO_NUMBER(x.LIFNR) desc)
             Loop
                tpVEND_EXT_S_SUPPL_GEN.LIFNR := c_msg.lifnr;  -- Obrigat�rio(S) - Identificador do Fornecedor  
                exit;
             End loop;

             tpVEND_EXT_S_SUPPL_GEN.LIFNR := TO_NUMBER(nvl(tpVEND_EXT_S_SUPPL_GEN.LIFNR,'0')) + 1;
             
             tpVEND_EXT_S_SUPPL_GEN.KUNNR := vCursor.Tipo;      -- Obrigat�rio(N) - Identificador do Cliente
             tpVEND_EXT_S_SUPPL_GEN.REF_KUNNR := vIdentificadorCli; -- Obrigat�rio(N) - Identificador do Cliente de refer�ncia
             tpVEND_EXT_S_SUPPL_GEN.BPKIND    :=  ' '; -- Matricula quando funcionario

              LOOP
                SELECT COUNT(*)
                  INTO vCount
                FROM MIGDV.VEND_EXT_S_SUPPL_GEN V
                WHERE V.LIFNR = tpVEND_EXT_S_SUPPL_GEN.LIFNR;
              exit when ( vCount = 0 ) ;
              tpVEND_EXT_S_SUPPL_GEN.LIFNR := TO_NUMBER(tpVEND_EXT_S_SUPPL_GEN.LIFNR) + 1;
             end loop;            
             
             vPosicao := 'MIGDV.VENDOR_S_SUPPL_GEN - ' || tpCUSTOMER_S_CUST_GEN.SORTL  ;
             INSERT INTO MIGDV.VEND_EXT_S_SUPPL_GEN VALUES tpVEND_EXT_S_SUPPL_GEN;
             COMMIT;

             vIdentificadorCli := tpVEND_EXT_S_SUPPL_GEN.LIFNR;

--           SP_SAP_INSERE_FORNECEDOR_CLI(vCursor.Tipo,vIdentificadorCli,PRESULTADO, PMENSAGEM);    
--        ElsIf vCursor.Tipo IN ('FOR') Then
--           SP_SAP_INSERE_FORNECEDOR() 
        End If;
        
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
       If vCursor.Tipo = 'CLI' Then
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
             WHERE C.GLB_CLIENTE_CGCCPFCODIGO = vCursor.Tab_Cpf_Cnpj
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
                  If trim(vCursorEndAdicional.TAB_CEP) <> '-' Then
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
                     If ( vCount = 0 ) and ( length(trim(nvl(tpEndAdicional.street,' '))) <> 0 ) is not null Then
                        SP_SAP_INSERE_CLIENTE_ENDERECO_ADICIONAL(vIdentificadorCli, tpEndAdicional, PRESULTADO, PMENSAGEM);
                     End IF;
                  End If;
               exception
                 When Others Then
                    vPosicao := vPosicao || ' Nem Rodou';
                 End;   
           END LOOP;     
-- Conforme conversado com Ana em 27/05/2020 n�o sera mais preenchido
--           vPosicao := 'SP_SAP_INSERE_BANK_DATA - ' || tpCUSTOMER_S_CUST_GEN.SORTL ;
--           SP_SAP_INSERE_BANK_DATA(vIdentificadorCli, vCursor.GLB_CLIENTE_CGCCPFCODIGO, PRESULTADO, PMENSAGEM);
           vPosicao := 'SP_SAP_INSEREDADOSFINANCEIROS - ' || tpCUSTOMER_S_CUST_GEN.SORTL ;
           SP_SAP_INSEREDADOSFINANCEIROS(vIdentificadorCli, vCursor.TAB_CPF_CNPJ, PRESULTADO, PMENSAGEM);
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
        
        tpCUSTOMER_S_CUST_COMPANY.KUNNR    := PIDCLIENTE; --Obrigat�rio(S) - Identificador do cliente*
        tpCUSTOMER_S_CUST_COMPANY.BUKRS    := '1'; --Obrigat�rio(S) - C�digo da companhia*
        tpCUSTOMER_S_CUST_COMPANY.SPERR    := ' '; --Obrigat�rio(N) - Bloqueio de Postagem
        tpCUSTOMER_S_CUST_COMPANY.ZAHLS    := 'N'; --Obrigat�rio(N) - Bloqueio de pagamento
        tpCUSTOMER_S_CUST_COMPANY.MAHNA    := ' '; --Obrigat�rio(N) - Procedimento de advert�ncia
        tpCUSTOMER_S_CUST_COMPANY.MANSP    := ' '; --Obrigat�rio(N) - Bloqueio de advert�ncia
        tpCUSTOMER_S_CUST_COMPANY.KNRMA    := ' '; --Obrigat�rio(N) - Destinat�rio de advert�ncia
        tpCUSTOMER_S_CUST_COMPANY.MADAT    := ' '; --Obrigat�rio(N) - �ltimo aviso de cobran�a
        tpCUSTOMER_S_CUST_COMPANY.GMVDT    := ' '; --Obrigat�rio(N) - Data dos procedimentos legais de cobran�a
        tpCUSTOMER_S_CUST_COMPANY.MAHNS    := '0'; --Obrigat�rio(N) - N�vel de advert�ncia
        tpCUSTOMER_S_CUST_COMPANY.TLFNS    := NVL(SUBSTR(vTelefone,1,30), ' '); --Obrigat�rio(N) - telefone 
        tpCUSTOMER_S_CUST_COMPANY.TLFXS    := NVL(SUBSTR(vFax,1,30), ' '); --Obrigat�rio(N) - Fax
        tpCUSTOMER_S_CUST_COMPANY.ZTERM    := ' '; --Obrigat�rio(N) - Termos de pagamento
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_01 := ' '; --Obrigat�rio(N) - Forma de Pagamento 1
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_02 := ' '; --Obrigat�rio(N) - Forma de Pagamento 2
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_03 := ' '; --Obrigat�rio(N) - Forma de Pagamento 3
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_04 := ' '; --Obrigat�rio(N) - Forma de Pagamento 4
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_05 := ' '; --Obrigat�rio(N) - Forma de Pagamento 5
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_06 := ' '; --Obrigat�rio(N) - Forma de Pagamento 6
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_07 := ' '; --Obrigat�rio(N) - Forma de Pagamento 7
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_08 := ' '; --Obrigat�rio(N) - Forma de Pagamento 8
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_09 := ' '; --Obrigat�rio(N) - Forma de Pagamento 9
        tpCUSTOMER_S_CUST_COMPANY.ZWELS_10 := ' '; --Obrigat�rio(N) - Forma de Pagamento 10
        tpCUSTOMER_S_CUST_COMPANY.AKONT    := ' '; --Obrigat�rio(S) - Conta de reconcilia��o*
        Begin                        
           INSERT INTO MIGDV.CUSTOMER_S_CUST_COMPANY VALUES tpCUSTOMER_S_CUST_COMPANY;
                commit;
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
          
        COMMIT;
          
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
             

 i integer;
 vTipo_Role migdv.CUSTOMER_S_ROLES.BP_ROLE%type;
 vChaveSap MIGDV.CUSTOMER_S_CUST_TAXNUMBERS.KUNNR%type;
begin
  i := 1;
  vChaveSap := PTpClient.ChaveSap;
  loop
 
    -- Se nao Foi passado um tipo especifico de ROLE
     If nvl(PTIPO_ROLE,'TODAS') = 'TODAS' Then
        If i = 1 Then
           vTipo_Role := 'CL'; -- cliente 
        ElsIf i = 2 Then
           vTipo_Role := 'COL_MAN'; -- Gerenciamento de cobrancas 
        ElsIf i = 3 Then
           vTipo_Role := 'CL_CTB'; -- Contabilidade Financeira
        End If;
      Else -- Se passou um tipo especifico usa
         vTipo_Role := PTIPO_ROLE;
         i := 3;
      End If;  
         
      If PTpClient.Tipo = 'CLI' Then 
         tpCUSTOMER_S_ROLES.KUNNR   := vChaveSap;
         tpCUSTOMER_S_ROLES.BP_ROLE := vTipo_Role;  
         INSERT INTO MIGDV.CUSTOMER_S_ROLES VALUES tpCUSTOMER_S_ROLES;
      ElsIf PTpClient.Tipo IN ('???') Then
         tpVEND_EXT_S_ROLES.LIFNR := vChaveSap;
         tpVEND_EXT_S_ROLES.BP_ROLE := vTipo_Role;
         insert into MIGDV.VEND_EXT_S_ROLES values tpVEND_EXT_S_ROLES;
      ElsIf PTpClient.Tipo IN ('PRO','CAR','FOR','FPW') Then
         tpVENDOR_S_ROLES.LIFNR   := vChaveSap;
         tpVENDOR_S_ROLES.BP_ROLE := vTipo_Role;
         INSERT INTO MIGDV.VENDOR_S_ROLES VALUES tpVENDOR_S_ROLES;
      End If;
      COMMIT;
         
      exit when i = 3;
      i := i + 1;
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
        vTAXNUM := trim(PTpClient.IE);
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

     If PTpClient.Tipo in ('CLI') Then

        SELECT COUNT(*)
          INTO vCount
        FROM MIGDV.CUSTOMER_S_CUST_TAXNUMBERS
        WHERE KUNNR = vChaveSap
          and TAXTYPE = vTAXTYPE;
         
        If vCount = 0 Then
           tpCUSTOMER_S_CUST_TAXNUMBERS.KUNNR   := vChaveSap; -- Obrigat�rio(S) - Identificador do Cliente
           tpCUSTOMER_S_CUST_TAXNUMBERS.TAXTYPE := vTAXTYPE;  -- Obrigat�rio(S) - Tipo do documento do cliente (CPF, CNPJ, RG, RNE, IM, IE)
           tpCUSTOMER_S_CUST_TAXNUMBERS.TAXNUM  := vTAXNUM;   -- Obrigat�rio(S) - N�mero do documento
           If vTAXNUM is not null Then  
              INSERT INTO MIGDV.CUSTOMER_S_CUST_TAXNUMBERS VALUES tpCUSTOMER_S_CUST_TAXNUMBERS;
              COMMIT;
           End If;
        End If;
         
     ElsIf PTpClient.Tipo in ('PRO','CAR','FOR','FPW') Then
        SELECT COUNT(*)
           INTO vCount
        FROM MIGDV.VENDOR_S_Suppl_Taxnumbers
        WHERE lifnr  = vChaveSap
          and TAXTYPE = vTAXTYPE;
                    
        IF vCount = 0 Then
           tpVENDOR_S_Suppl_Taxnumbers.lifnr   := vChaveSap; -- Obrigat�rio(S) - Identificador do Cliente
           tpVENDOR_S_Suppl_Taxnumbers.TAXTYPE := vTAXTYPE;  -- Obrigat�rio(S) - Tipo do documento do cliente (CPF, CNPJ, RG, RNE, IM, IE)
           tpVENDOR_S_Suppl_Taxnumbers.TAXNUM  := vTAXNUM;   -- Obrigat�rio(S) - N�mero do documento

           If vTAXNUM is not null Then  
              INSERT INTO MIGDV.VENDOR_S_Suppl_Taxnumbers VALUES tpVENDOR_S_Suppl_Taxnumbers;
              COMMIT;
           End If;
        End If;
     ElsIf PTpClient.Tipo in ('???') Then
        SELECT COUNT(*)
           INTO vCount
        FROM MIGDV.Vend_Ext_s_Suppl_Taxnumbers x
        WHERE lifnr  = vChaveSap
          and TAXTYPE = vTAXTYPE;
                    
        IF vCount = 0 Then
           tpvend_ext_s_suppl_taxnumbers.lifnr   := vChaveSap; -- Obrigat�rio(S) - Identificador do Cliente
           tpvend_ext_s_suppl_taxnumbers.TAXTYPE := vTAXTYPE;  -- Obrigat�rio(S) - Tipo do documento do cliente (CPF, CNPJ, RG, RNE, IM, IE)
           tpvend_ext_s_suppl_taxnumbers.TAXNUM  := vTAXNUM;   -- Obrigat�rio(S) - N�mero do documento

           If vTAXNUM is not null Then  
              INSERT INTO MIGDV.vend_ext_s_suppl_taxnumbers VALUES tpVENDOR_S_Suppl_Taxnumbers;
              COMMIT;
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
                                            'SP_SAP_INSERE_TAXNUMBERS - Tipo ' || PTpClient.Tipo || ' - Cliente - ' || vChaveSap || ' - Type ' || vTAXTYPE);

                commit;

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
      If PCliRed.Tipo = 'CLI' Then
         delete MIGDV.CUSTOMER_S_CUST_CONT CO
         where co.KUNNR = PCliRed.ChaveSap;
--      ElsIf PCliRed IN ('PRO','CAR','FOR','FPW') Then
      End IF;
      FOR vCursor IN (SELECT PC.SEQ,
                             PC.CNPJCPF,
                             PC.CONTATO,
                             PC.PRIMEIRO_NOME,
                             PC.ULTIMO_NOME,
                             PC.FONE,
                             PC.DEPARTAMENTO,
                             PC.CELULAR,
                             PC.FAX,
                             PC.EMAIL,
                             PC.OBS,
                             PC.TIPO
                      FROM MIGDV.V_PESSOASCONTSAP PC    
                      WHERE PC.CNPJCPF = PCliRed.CPFCNPJ)
      Loop
        
                      
          PRESULTADO := 'N';
          PMENSAGEM  := '';
          
          
         
         If PCliRed.Tipo = 'CLI' Then
            tpCUSTOMER_S_CUST_CONT.KUNNR     := PCliRed.ChaveSap; -- Obrigat�rio(S) - Identificador do Cliente
            tpCUSTOMER_S_CUST_CONT.PARNR     := LPAD(vIndCont, 10, '0');--'0000000001';--vIdentificadorContato; -- Obrigat�rio(S) - ID do contato
            tpCUSTOMER_S_CUST_CONT.TITLE     := ' '; -- Obrigat�rio(N) - T�tulo
            tpCUSTOMER_S_CUST_CONT.VNAME     := nvl(vCursor.PRIMEIRO_NOME, ' '); -- Obrigat�rio(N) - Primeiro nome
            tpCUSTOMER_S_CUST_CONT.LNAME     := nvl(vCursor.ULTIMO_NOME, ' '); -- Obrigat�rio(N) - �ltimo nome
            tpCUSTOMER_S_CUST_CONT.LANGUCORR := ' '; -- Obrigat�rio(N) - Idioma correspondente
            tpCUSTOMER_S_CUST_CONT.ABTNR     := nvl(vCursor.DEPARTAMENTO, ' '); -- Obrigat�rio(N) - Departamento
            tpCUSTOMER_S_CUST_CONT.PAFKT     := ' '; -- Obrigat�rio(N) - Fun��o
            tpCUSTOMER_S_CUST_CONT.PAVIP     := ' '; -- Obrigat�rio(N) - VIP
            tpCUSTOMER_S_CUST_CONT.COUNTRY   := ' '; -- Obrigat�rio(N) - Pa�s
            tpCUSTOMER_S_CUST_CONT.REGION    := ' '; -- Obrigat�rio(N) - Estado/UF do contato
            tpCUSTOMER_S_CUST_CONT.POSTLCD   := ' '; -- Obrigat�rio(N) - CEP
            tpCUSTOMER_S_CUST_CONT.CITY      := ' '; -- Obrigat�rio(N) - Cidade
            tpCUSTOMER_S_CUST_CONT.STREET    := ' '; -- Obrigat�rio(N) - Logradouro
            tpCUSTOMER_S_CUST_CONT.HOUSE_NO  := ' '; -- Obrigat�rio(N) - N�mero do endere�o
            tpCUSTOMER_S_CUST_CONT.TEL_NO    := nvl(vCursor.FONE, ' '); -- Obrigat�rio(N) - N�mero de telefone: DDD + n�mero
            tpCUSTOMER_S_CUST_CONT.MOBILE_NO := nvl(vCursor.CELULAR, ' '); -- Obrigat�rio(N) - N�mero de telefone: DDD + n�mer 
            tpCUSTOMER_S_CUST_CONT.FAX_NO    := nvl(vCursor.FAX, ' '); -- Obrigat�rio(N) - N�mero de fax: DDD + n�mero
            tpCUSTOMER_S_CUST_CONT.E_MAIL    := nvl(vCursor.EMAIL, ' '); -- Obrigat�rio(N) - Endere�o de e-mail
              
            INSERT INTO MIGDV.CUSTOMER_S_CUST_CONT VALUES tpCUSTOMER_S_CUST_CONT;
            COMMIT;
            vIndCont := vIndCont + 1;
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
      If PCliRed.Tipo <> 'CLI' Then
         delete MIGDV.VENDOR_S_SUPPL_IDENT VI
         where VI.LIFNR = PCliRed.ChaveSap;
--      ElsIf PCliRed IN ('PRO','CAR','FOR','FPW') Then
      End IF;
     
                      
          PRESULTADO := 'N';
          PMENSAGEM  := '';
          
          
         
         If PCliRed.Tipo <> 'CLI' Then
            tpVENDOR_S_SUPPL_IDENT.LIFNR := PCliRed.ChaveSap;

/*            If PCliRed.RG is not null Then
               tpVENDOR_S_SUPPL_IDENT.LIFNR := PCliRed.ChaveSap;
               tpVENDOR_S_SUPPL_IDENT.TYPE  := 'ZRG';
               tpVENDOR_S_SUPPL_IDENT.IDNUMBER := PCliRed.RG;            
               insert into MIGDV.VENDOR_S_SUPPL_IDENT values tpVENDOR_S_SUPPL_IDENT;
            End If; 
*/

            If PCliRed.INSS is not null Then
               tpVENDOR_S_SUPPL_IDENT.LIFNR := PCliRed.ChaveSap;
               tpVENDOR_S_SUPPL_IDENT.TYPE  := 'Z005'; -- PIS
               tpVENDOR_S_SUPPL_IDENT.IDNUMBER := PCliRed.INSS;            
               insert into MIGDV.VENDOR_S_SUPPL_IDENT values tpVENDOR_S_SUPPL_IDENT;
            End If; 
            If PCliRed.MATRICULA is not null Then
               tpVENDOR_S_SUPPL_IDENT.LIFNR := PCliRed.ChaveSap;
               tpVENDOR_S_SUPPL_IDENT.TYPE  := 'Z011'; -- Matricula
               tpVENDOR_S_SUPPL_IDENT.IDNUMBER := PCliRed.MATRICULA;            
               insert into MIGDV.VENDOR_S_SUPPL_IDENT values tpVENDOR_S_SUPPL_IDENT;
            End If; 
         End If;   
         commit; 
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
    --tpCUSTOMER_S_ADDRESS.KUNNR         := PIDCLIENTE; -- Obrigat�rio(S) - Identificador do cliente
    tpCUSTOMER_S_ADDRESS.BU_ADEXT      := MIGDV.S_SAP_ENDERECO.NEXTVAL;
    
    tpCUSTOMER_S_ADDRESS.STREET        := NVL(substr(tpEndAdicional.STREET,1,59), ' '); -- Obrigat�rio(S) - Nome do Logradouro do endere�o adicional do cliente
    tpCUSTOMER_S_ADDRESS.HOUSE_NUM1    := substr(tpEndAdicional.HOUSE_NUM1,1,10); -- Obrigat�rio(N) - N�mero do endere�o adicional do cliente
    tpCUSTOMER_S_ADDRESS.CITY2         := substr(tpEndAdicional.CITY2,1,40); -- Obrigat�rio(N) - Bairro do endere�o adicional do cliente
    tpCUSTOMER_S_ADDRESS.POST_CODE1    := NVL(tpEndAdicional.POST_CODE1, ' '); -- Obrigat�rio(N) - CEP do endere�o adicional do cliente
    
    tpCUSTOMER_S_ADDRESS.CITY1         := ' '; -- Obrigat�rio(N) - Cidade do endere�o adicional do cliente
    tpCUSTOMER_S_ADDRESS.COUNTRY       := substr(tpEndAdicional.COUNTRY,1,80);--'BR'; -- Obrigat�rio(N) - Pa�s do cliente
    tpCUSTOMER_S_ADDRESS.REGION        := substr(tpEndAdicional.REGION,1,80); -- **Colocar estado - UF-- Obrigat�rio(N) - Estado/UF do endere�o adicional do cliente
    tpCUSTOMER_S_ADDRESS.STR_SUPPL1    := ' '; -- Obrigat�rio(N) - Segundo campo de logradouro do endere�o adicional do cliente
    tpCUSTOMER_S_ADDRESS.HOUSE_NO2     := NVL(SUBSTR(tpEndAdicional.HOUSE_NO2,1, 10), ' '); -- Obrigat�rio(N) - Complemento do Endere�o adicional do cliente
    tpCUSTOMER_S_ADDRESS.PO_BOX        := ' '; -- Obrigat�rio(N) - Caixa postal
    tpCUSTOMER_S_ADDRESS.POST_CODE2    := ' '; -- Obrigat�rio(N) - CEP da caixa postal
    tpCUSTOMER_S_ADDRESS.PO_BOX_LOC    := ' '; -- Obrigat�rio(N) - Cidade da Caixa postal
    tpCUSTOMER_S_ADDRESS.POBOX_CTRY    := ' '; -- Obrigat�rio(N) - Pa�s da Caixa postal
    tpCUSTOMER_S_ADDRESS.PO_BOX_REG    := ' '; -- Obrigat�rio(N) - Estado da caixa postal
    tpCUSTOMER_S_ADDRESS.LANGU_CORR    := 'PT'; -- Obrigat�rio(N) - Idioma
    tpCUSTOMER_S_ADDRESS.TELNR_LONG    := ' '; -- Obrigat�rio(N) - Telefone
    tpCUSTOMER_S_ADDRESS.TELNR_LONG_2  := ' '; -- Obrigat�rio(N) - Telefone Adicional 2
    tpCUSTOMER_S_ADDRESS.TELNR_LONG_3  := ' '; -- Obrigat�rio(N) - Telefone Adicional 3
    tpCUSTOMER_S_ADDRESS.MOBILE_LONG   := ' '; -- Obrigat�rio(N) - Celular
    tpCUSTOMER_S_ADDRESS.MOBILE_LONG_2 := ' '; -- Obrigat�rio(N) - Celular adicional 2
    tpCUSTOMER_S_ADDRESS.MOBILE_LONG_3 := ' '; -- Obrigat�rio(N) - Celular adicional 3
    tpCUSTOMER_S_ADDRESS.FAXNR_LONG    := ' '; -- Obrigat�rio(N) - Fax
    tpCUSTOMER_S_ADDRESS.FAXNR_LONG_2  := ' '; -- Obrigat�rio(N) - Fax adicional 2
    tpCUSTOMER_S_ADDRESS.FAXNR_LONG_3  := ' '; -- Obrigat�rio(N) - Fax adicional 3
    tpCUSTOMER_S_ADDRESS.SMTP_ADDR     := ' '; -- Obrigat�rio(N) - Email
    tpCUSTOMER_S_ADDRESS.SMTP_ADDR_2   := ' '; -- Obrigat�rio(N) - E-mail adicional 2
    tpCUSTOMER_S_ADDRESS.SMTP_ADDR_3   := ' '; -- Obrigat�rio(N) - E-mail adicional 3
    tpCUSTOMER_S_ADDRESS.URI_TYP       := ' '; -- Obrigat�rio(N) - Tipo de Comunica��o
    tpCUSTOMER_S_ADDRESS.URI_ADDR      := ' '; -- Obrigat�rio(N) - Web Site
              
    INSERT INTO MIGDV.CUSTOMER_S_ADDRESS VALUES tpCUSTOMER_S_ADDRESS;
    COMMIT;
            
    PRESULTADO := 'N';
    PMENSAGEM  := 'Endere�o adicional inserido com sucesso.';  
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


-- Insere quando � Cliente e Fornecedor 
procedure SP_SAP_INSERE_FORNECEDOR_CLI(PKUNNR     IN CHAR,
                                       PREF_KUNNR IN CHAR,
                                       PRESULTADO OUT Char,
                                       PMENSAGEM  OUT VARCHAR2) is
vCount Integer;
tpVEND_EXT_S_SUPPL_GEN MIGDV.VEND_EXT_S_SUPPL_GEN%ROWTYPE; 
begin
   vCount := 0;
   PRESULTADO := 'N';
   PMENSAGEM  := ''; 
   
   for c_msg in (select LIFNR
                 from MIGDV.VENDOR_S_SUPPL_GEN x
                 order by x.LIFNR desc)
   Loop
      tpVEND_EXT_S_SUPPL_GEN.LIFNR := c_msg.lifnr;  -- Obrigat�rio(S) - Identificador do Fornecedor  
      exit;
   End loop;

   tpVEND_EXT_S_SUPPL_GEN.LIFNR := nvl(tpVEND_EXT_S_SUPPL_GEN.LIFNR,0) + 1;
   
   tpVEND_EXT_S_SUPPL_GEN.KUNNR := PKUNNR;      -- Obrigat�rio(N) - Identificador do Cliente
   tpVEND_EXT_S_SUPPL_GEN.REF_KUNNR := PREF_KUNNR; -- Obrigat�rio(N) - Identificador do Cliente de refer�ncia
   
   begin
      INSERT INTO MIGDV.VEND_EXT_S_SUPPL_GEN VALUES tpVEND_EXT_S_SUPPL_GEN;
      COMMIT;
   exception
     when OTHERS Then
        vErro := sqlerrm;
       rollback;
       insert into tdvadm.t_glb_sql values (vErro,
                                            sysdate,
                                            'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                            'SP_SAP_INSERE_FORNECEDOR_CLI - Cliente - ' || PREF_KUNNR);
                commit;
--          dbms_output.put_line('Aqui 2' || PREF_KUNNR);
       End; 
end SP_SAP_INSERE_FORNECEDOR_CLI;




-- Insere quando � apenas Fornecedor  
procedure SP_SAP_INSERE_FORNECEDOR(PDATA_CORTE IN CHAR,
                                   PRESULTADO OUT Char,
                                   PMENSAGEM OUT VARCHAR2) is
vCount Integer;
tpVENDOR_S_SUPPL_GEN MIGDV.VENDOR_S_SUPPL_GEN%ROWTYPE; 
begin
  vCount := 0;

      FOR vCursor IN ( 
        -- Fornecedores BGM   
        SELECT F.CODIGOFORN, -- PK
               F.NRFORN,
               F.CODOPERFISCAL,
               F.CODTPDESPESA,
               F.CODIGOUF,
               F.CODCLASSFISC,
               F.RSOCIALFORN,
               F.NFANTASIAFORN,
               F.ENDERECOFORN,
               TDVADM.PKG_GLB_COMMON.fn_get_numero_endereco(F.Enderecoforn) LIMPO_NUMERO,
               F.BAIRROFORN,
               F.CIDADEFORN,
               F.CEPFORN,
               F.TELEFONEFORN,
               F.FAXFORN,
               F.HOMEPAGEFORN,
               F.EMAILFORN,
               F.TPINSCRICAOFORN,
               F.NRINSCRICAOFORN,
               F.INSCESTADUALFORN,
               F.CONTATOFORN,
               F.OBSERVACAOFORN,
               F.CONDICAOFORN,
               F.DATAULTIMOMOVTOFORN,
               F.CONDPGTOFORN,
               F.INSCMUNICIPALFORN,
               F.TIPOFORN,
               F.CODBANCOFORN,
               F.CODAGENCIAFORN,
               F.DVAGENCIAFORN,
               F.CODCONTABCOFORN,
               F.DVCONTABCOFORN,
               F.TIPOCONTABCO,
               F.CONTRIBUINTEICMS,
               F.ATIVOSNAP,
               F.NRMUNICIPIO,
               F.CODIGOAUX1,
               F.CODFORNMATRIZ,
               F.UTILIZAINSCMATRIZPE,
               F.SIGLA_PAIS,
               F.CODATIVIDADE,
               F.NRRNTRC,
               F.VALIDADERNTRC,
               F.PERCJUROS,
               F.PERCDESCONTO,
               F.DTCADASTROFORN,
               F.CODSITUACAO,
               F.CODAVALIACAO,
               F.CODSEGNEG,
               F.CODAGREGULADO,
               F.CODINSTALACAO,
               F.ATIV_ECONOMICA,
               F.CODMUNIC,
               F.INF_ADICIONAIS,
               F.NR_ENDERECO,
               F.COMPLFORN,
               F.AUTONOMO,
               F.CODINTPROAUT,
               F.CONSULTOU_CNPJ_RECEITA,
               F.FORN_OPT_SIMPLES_NACIONAL,
               F.AVALIADOPELORANKFORN,
               F.EMAILRANKFORN,
               F.TIPO_EMPRESA,
               F.RAMOEMPRESA,
               F.DT_ULT_ALTERACAO,
               F.USR_ULT_ALTERACAO,
               F.NOME_FAV_FORN,
               F.TPINSCR_FAV_FORN,
               F.NRINSCR_FAV_FORN,
               F.CONTRIBUINTECPRB 
        FROM BGM.BGM_FORNECEDOR F
        WHERE F.DTCADASTROFORN >= vDATA_CORTE
      )  
      Loop
          
          SELECT COUNT(*)
          INTO vCount
          FROM MIGDV.VENDOR_S_SUPPL_GEN
          WHERE EXISTS (SELECT * FROM MIGDV.VENDOR_S_SUPPL_GEN
                        WHERE LIFNR =  'xxxx');
                      
          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
          IF NVL(vCount, 0) = 0 Then
            PRESULTADO := 'E';
            PMENSAGEM  := 'N�o foi poss�vel localizar o fornecedor: ' || sqlerrm;       
            
            tpVENDOR_S_SUPPL_GEN.LIFNR         := ' '; -- Obrigat�rio(S) - Identificador do Fornecedor
            tpVENDOR_S_SUPPL_GEN.BU_GROUP      := '00001'; -- Obrigat�rio(S) - Agrupamento de Parceiro (fixo 00001)
            tpVENDOR_S_SUPPL_GEN.NAME_FIRST    := vCursor.Rsocialforn; -- Obrigat�rio(N) - Nome
            tpVENDOR_S_SUPPL_GEN.NAME_LAST     := vCursor.Rsocialforn; -- Obrigat�rio(N) - Nome 2 
            tpVENDOR_S_SUPPL_GEN.NAME3         := ' '; -- Obrigat�rio(N) - Nome 3
            tpVENDOR_S_SUPPL_GEN.NAME4         := ' '; -- Obrigat�rio(N) - Nome 4
            tpVENDOR_S_SUPPL_GEN.SORTL         := ' '; -- Obrigat�rio(N) - Termo de Pesquisa 1
            tpVENDOR_S_SUPPL_GEN.MCOD2         := ' '; -- Obrigat�rio(N) - Termo de Pesquisa 2
            tpVENDOR_S_SUPPL_GEN.FOUND_DAT     := ' '; -- Obrigat�rio(N) - Data da funda��o
            tpVENDOR_S_SUPPL_GEN.LIQUID_DAT    := ' '; -- Obrigat�rio(N) - Data de liquida��o
            tpVENDOR_S_SUPPL_GEN.MIN_COMP      := ' '; -- Obrigat�rio(N) - Indicador de micro empresa
            tpVENDOR_S_SUPPL_GEN.COMSIZE       := ' '; -- Obrigat�rio(N) - Tamanho da empresa
            tpVENDOR_S_SUPPL_GEN.DECREGPC      := ' '; -- Obrigat�rio(N) - Regime de Declara��o para PIS / COFINS
            tpVENDOR_S_SUPPL_GEN.CNAE          := ' '; -- Obrigat�rio(N) - CNAE
            tpVENDOR_S_SUPPL_GEN.CRTN          := ' '; -- Obrigat�rio(N) - N�mero CRT
            tpVENDOR_S_SUPPL_GEN.ICMSTAXPAY    := vCursor.Contribuinteicms; -- Obrigat�rio(N) - Contribuinte do ICMS
            tpVENDOR_S_SUPPL_GEN.STREET        := vCursor.Enderecoforn; -- Obrigat�rio(N) - Nome do logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.HOUSE_NUM1    := vCursor.LIMPO_NUMERO; -- Obrigat�rio(N) - N�mero do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.CITY2         := substr(vCursor.Bairroforn,1,40); -- Obrigat�rio(N) - Bairro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.POST_CODE1    := vCursor.Cepforn; -- Obrigat�rio(N) - CEP do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.CITY1         := vCursor.Cidadeforn; -- Obrigat�rio(N) - Cidade do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.COUNTRY       := vCursor.Sigla_Pais; -- Obrigat�rio(S) - Pa�s* do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.REGION        := vCursor.Codigouf; -- Obrigat�rio(N) - Estado/UF do endere�o do fornecedor 
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL1    := ' '; -- Obrigat�rio(N) - Segundo campo de logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL2    := ' '; -- Obrigat�rio(N) - Terceiro campo de logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.HOUSE_NO2     := ' '; -- Obrigat�rio(N) - Complemento do endere�o do fornecedor
            tpVENDOR_S_SUPPL_GEN.STR_SUPPL3    := ' '; -- Obrigat�rio(N) - Logradouro 4
            tpVENDOR_S_SUPPL_GEN.LOCATION      := ' '; -- Obrigat�rio(N) - Logradouro 5
            tpVENDOR_S_SUPPL_GEN.PO_BOX        := ' '; -- Obrigat�rio(N) - Caixa postal
            tpVENDOR_S_SUPPL_GEN.PO_BOX_CIT    := ' '; -- Obrigat�rio(N) - Cidade da Caixa postal
            tpVENDOR_S_SUPPL_GEN.POBOX_CTRY    := ' '; -- Obrigat�rio(N) - Pa�s da caixa postal
            tpVENDOR_S_SUPPL_GEN.PO_BOX_REG    := ' '; -- Obrigat�rio(N) - Estado/UF da caixa postal
            tpVENDOR_S_SUPPL_GEN.LANGU_CORR    := ' '; -- Obrigat�rio(N) - Idioma
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG    := ' '; -- Obrigat�rio(N) - Telefone padr�o
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG_2  := ' '; -- Obrigat�rio(N) - Telefone Adicional 2
            tpVENDOR_S_SUPPL_GEN.TELNR_LONG_3  := ' '; -- Obrigat�rio(N) - Telefone Adicional 3
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG   := ' '; -- Obrigat�rio(N) - Celular padr�o
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG_2 := ' '; -- Obrigat�rio(N) - Celular adicional 2
            tpVENDOR_S_SUPPL_GEN.MOBILE_LONG_3 := ' '; -- Obrigat�rio(N) - Celular adicional 3
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG    := vCursor.Faxforn; -- Obrigat�rio(N) - Fax padr�o
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG_2  := ' '; -- Obrigat�rio(N) - Fax adicional 2
            tpVENDOR_S_SUPPL_GEN.FAXNR_LONG_3  := ' '; -- Obrigat�rio(N) - Fax adicional 3
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR     := vCursor.Emailforn; -- Obrigat�rio(N) - E-mail padr�o
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR_2   := ' '; -- Obrigat�rio(N) - E-mail adicional 2
            tpVENDOR_S_SUPPL_GEN.SMTP_ADDR_3   := ' '; -- Obrigat�rio(N) - E-mail adicional 3
            tpVENDOR_S_SUPPL_GEN.SPERR         := ' '; -- Obrigat�rio(N) - Bloqueio de Postagem - Central
              
            INSERT INTO MIGDV.VENDOR_S_SUPPL_GEN VALUES tpVENDOR_S_SUPPL_GEN;
            COMMIT;

          End If;
      End Loop;
  
end SP_SAP_INSERE_FORNECEDOR;


                                                    
                                   
-- Insere Dados banc�rios do Fornecedor                                           
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
            PMENSAGEM  := 'N�o foi poss�vel localizar o fornecedor: ' || sqlerrm;       
            
            tpVENDOR_S_SUPP_BANK.LIFNR   := ' '; -- Obrigat�rio(S) - Identificador do Fornecedor
            tpVENDOR_S_SUPP_BANK.BANKS := ' '; -- Obrigat�rio(S) - Chave do pa�s do banco *
            tpVENDOR_S_SUPP_BANK.BANKL := ' '; -- Obrigat�rio(N) - Identificador do Banco / Ag�ncia
            tpVENDOR_S_SUPP_BANK.BANKN := ' '; -- Obrigat�rio(N) - N� da conta
            tpVENDOR_S_SUPP_BANK.IBAN := ' '; -- Obrigat�rio(N) - IBAN
            tpVENDOR_S_SUPP_BANK.XEZER := ' '; -- Obrigat�rio(N) - Indicador de Autoriza��o de Cobran�a
            tpVENDOR_S_SUPP_BANK.KOINH := ' '; -- Obrigat�rio(N) - Nome do titular da conta
            tpVENDOR_S_SUPP_BANK.EBPP_ACCNAME := ' '; -- Obrigat�rio(N) - Nome do titular da conta
            
             
              
            INSERT INTO MIGDV.VENDOR_S_SUPP_BANK VALUES tpVENDOR_S_SUPP_BANK;
            COMMIT;

          End If;
      End Loop;
  
end SP_SAP_INSERE_FORNECEDOR_SUPP_BANK;
                                           
-- Insere Impostos Retidos do documento Fornecedor
procedure SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO(PIDFORNECEDOR IN CHAR,
                                                  PRESULTADO OUT Char,
                                                  PMENSAGEM OUT VARCHAR2) is
vCount Integer;
tpVENDOR_S_SUPPL_WITH_TAX MIGDV.VENDOR_S_SUPPL_WITH_TAX%ROWTYPE; 
begin
  vCount := 0;

      FOR vCursor IN (    
        SELECT DISTINCT
               B.*
        FROM MIGDV.VENDOR_S_SUPPL_WITH_TAX B
      )  
      Loop
                     
          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
          IF NVL(vCount, 0) = 0 Then
            PRESULTADO := 'E';
            PMENSAGEM  := 'N�o foi poss�vel localizar o fornecedor: ' || sqlerrm;       
            
            tpVENDOR_S_SUPPL_WITH_TAX.LIFNR     := ' '; -- Obrigat�rio(S) - Identificador do Fornecedor
            tpVENDOR_S_SUPPL_WITH_TAX.BUKRS     := ' '; -- Obrigat�rio(S) - C�digo da companhia*
            tpVENDOR_S_SUPPL_WITH_TAX.WITHT     := ' '; -- Obrigat�rio(S) - Tipo de imposto retido na fonte *
            tpVENDOR_S_SUPPL_WITH_TAX.WT_WITHCD := ' '; -- Obrigat�rio(N) - C�digo do imposto retido na fonte
            tpVENDOR_S_SUPPL_WITH_TAX.WT_SUBJCT := ' '; -- Obrigat�rio(N) - Objeto do imposto
            tpVENDOR_S_SUPPL_WITH_TAX.WT_WTSTCD := ' '; -- Obrigat�rio(N) - N�mero de identifica��o do imposto retido na fonte
              
            INSERT INTO MIGDV.VENDOR_S_SUPPL_WITH_TAX VALUES tpVENDOR_S_SUPPL_WITH_TAX;
            COMMIT;

          End If;
      End Loop;
  
end SP_SAP_INSERE_FORNECEDOR_IMPOSTO_RETIDO;

                                 
-- Insere Endere�os adicionais do fornecedor                                           
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
          Sirlano vai falar com o Thiago sobre os Fornecedores que s�o tamb�m clientes
          */            
          PRESULTADO := 'N';
          PMENSAGEM  := ''; 
                    
          IF NVL(vCount, 0) = 0 Then
            PRESULTADO := 'E';
            PMENSAGEM  := 'N�o foi poss�vel localizar o fornecedor: ' || sqlerrm;       
            
            tpVENDOR_S_SUPPL_ADDR.LIFNR         := ' '; -- Obrigat�rio(S) - Identificador do Fornecedor
            tpVENDOR_S_SUPPL_ADDR.BU_ADEXT      := ' '; -- Obrigat�rio(S) - Identificador do endere�o externo *
            tpVENDOR_S_SUPPL_ADDR.STREET        := ' '; -- Obrigat�rio(N) - Nome do logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.HOUSE_NUM1    := ' '; -- Obrigat�rio(N) - N�mero do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.CITY2         := ' '; -- Obrigat�rio(N) - Bairro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.POST_CODE1    := ' '; -- Obrigat�rio(N) - CEP do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.CITY1         := ' '; -- Obrigat�rio(N) - Cidade do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.COUNTRY       := ' '; -- Obrigat�rio(S) - Pa�s do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.REGION        := ' '; -- Obrigat�rio(N) - Estado/UF do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.STR_SUPPL1    := ' '; -- Obrigat�rio(N) - Segundo campo de logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.STR_SUPPL2    := ' '; -- Obrigat�rio(N) - Terceiro campo de logradouro do endere�o do fornecedor
            tpVENDOR_S_SUPPL_ADDR.HOUSE_NO2     := ' '; -- Obrigat�rio(N) - Caixa postal
            tpVENDOR_S_SUPPL_ADDR.PO_BOX        := ' '; -- Obrigat�rio(N) - Caixa postal
            tpVENDOR_S_SUPPL_ADDR.PO_BOX_CIT    := ' '; -- Obrigat�rio(N) - Cidade da Caixa Postal
            tpVENDOR_S_SUPPL_ADDR.POBOX_CTRY    := ' '; -- Obrigat�rio(N) - Pa�s da caixa postal
            tpVENDOR_S_SUPPL_ADDR.PO_BOX_REG    := ' '; -- Obrigat�rio(N) - Estado/UF da caixa postal
            tpVENDOR_S_SUPPL_ADDR.LANGU_CORR    := ' '; -- Obrigat�rio(N) - Idioma
            tpVENDOR_S_SUPPL_ADDR.TELNR_LONG    := ' '; -- Obrigat�rio(N) - Telefone padr�o
            tpVENDOR_S_SUPPL_ADDR.TELNR_LONG_2  := ' '; -- Obrigat�rio(N) - Telefone Adicional 2
            tpVENDOR_S_SUPPL_ADDR.TELNR_LONG_3  := ' '; -- Obrigat�rio(N) - Telefone Adicional 3
            tpVENDOR_S_SUPPL_ADDR.MOBILE_LONG   := ' '; -- Obrigat�rio(N) - Celular padr�o
            tpVENDOR_S_SUPPL_ADDR.MOBILE_LONG_2 := ' '; -- Obrigat�rio(N) - Celular adicional 2
            tpVENDOR_S_SUPPL_ADDR.MOBILE_LONG_3 := ' '; -- Obrigat�rio(N) - Celular adicional 2
            tpVENDOR_S_SUPPL_ADDR.FAXNR_LONG    := ' '; -- Obrigat�rio(N) - Fax padr�o
            tpVENDOR_S_SUPPL_ADDR.FAXNR_LONG_2  := ' '; -- Obrigat�rio(N) - Fax adicional 2
            tpVENDOR_S_SUPPL_ADDR.FAXNR_LONG_3  := ' '; -- Obrigat�rio(N) - Fax adicional 3
            tpVENDOR_S_SUPPL_ADDR.SMTP_ADDR     := ' '; -- Obrigat�rio(N) - Email padr�o
            tpVENDOR_S_SUPPL_ADDR.SMTP_ADDR_2   := ' '; -- Obrigat�rio(N) - Email adicional 2
            tpVENDOR_S_SUPPL_ADDR.SMTP_ADDR_3   := ' '; -- Obrigat�rio(N) - Email adicional 3
              
            INSERT INTO MIGDV.VENDOR_S_SUPPL_ADDR VALUES tpVENDOR_S_SUPPL_ADDR;
            COMMIT;

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
      /*SELECT AINDA N�O EST� DEFINIDO*/
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
        
        tpFIXED_ASSET_S_KEY.BUKRS      := ' '; -- Obrigat�rio(S) - C�digo da companhia*
        tpFIXED_ASSET_S_KEY.ANLN1      := vIdentificadorAtivo;  -- Obrigat�rio(S) - Identificador de ativo externo / do legado
        tpFIXED_ASSET_S_KEY.ANLKL      := ' '; -- Obrigat�rio(S) - Classe de ativos*
        tpFIXED_ASSET_S_KEY.TXT50      := ' '; -- Obrigat�rio(N) - Descri��o do ativo *
        tpFIXED_ASSET_S_KEY.TXA50_MORE := ' '; -- Obrigat�rio(N) - Descri��o do ativo 2
        tpFIXED_ASSET_S_KEY.SERNR      := ' '; -- Obrigat�rio(N) - N�mero de s�rie
        tpFIXED_ASSET_S_KEY.INVNR      := ' '; -- Obrigat�rio(N) - Identificador do Invent�rio
        tpFIXED_ASSET_S_KEY.MENGE      := ' '; -- Obrigat�rio(N) - Quantidade
        tpFIXED_ASSET_S_KEY.MEINS      := ' '; -- Obrigat�rio(N) - Unidade de medida b�sica
                                             
        INSERT INTO MIGDV.FIXED_ASSET_S_KEY VALUES tpFIXED_ASSET_S_KEY;
        
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Ativo inserido com sucesso';
        
        
    END LOOP;        
    
end SP_SAP_INSERE_ATIVOS_FIXO;                                         


-- Insere valora��o do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_VALORACAO(PIDATIVO IN CHAR,
                                        PRESULTADO OUT Char,
                                        PMENSAGEM OUT VARCHAR2) is

vIdentificadorAtivo number;                                        
tpFIXED_ASSET_S_NETWORTHVALUATIO MIGDV.FIXED_ASSET_S_NETWORTHVALUATIO%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA N�O EST� DEFINIDO*/
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
        
        tpFIXED_ASSET_S_NETWORTHVALUATIO.BUKRS            := ' '; -- Obrigat�rio(S) - C�digo da companhia*
        tpFIXED_ASSET_S_NETWORTHVALUATIO.ANLN1            := vIdentificadorAtivo;  -- Obrigat�rio(S) - Identificador de ativo externo / do legado
        tpFIXED_ASSET_S_NETWORTHVALUATIO.PROP_IND         := ' '; -- Obrigat�rio(N) - Indicador de Propriedade
        tpFIXED_ASSET_S_NETWORTHVALUATIO.MAN_PROP_VAL     := ' '; -- Obrigat�rio(N) - Valor do imposto sobre patrim�nio l�quido manual
        tpFIXED_ASSET_S_NETWORTHVALUATIO.CURRENCY         := ' '; -- Obrigat�rio(N) - Identificador da moeda (formato ISO)
        tpFIXED_ASSET_S_NETWORTHVALUATIO.MAN_PROP_VAL_IND := ' '; -- Obrigat�rio(N) - Valor do imposto sobre patrim�nio l�quido - manual
                                         
        INSERT INTO MIGDV.FIXED_ASSET_S_NETWORTHVALUATIO VALUES tpFIXED_ASSET_S_NETWORTHVALUATIO;
        
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Ativo valora��o inserido com sucesso';
        
        
    END LOOP; 

end SP_SAP_INSERE_ATIVO_VALORACAO;       

                                          
-- Insere data de entrada e exerc�cio do Ativo Fixo
procedure SP_SAP_INSERE_ATIVO_DATAENTRADA(PIDATIVO IN CHAR,
                                          PRESULTADO OUT Char,
                                          PMENSAGEM OUT VARCHAR2) is

vIdentificadorAtivo number;                                        
tpFIXED_ASSET_S_POSTINGINFORMATI MIGDV.FIXED_ASSET_S_POSTINGINFORMATI%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA N�O EST� DEFINIDO */
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
        
        tpFIXED_ASSET_S_POSTINGINFORMATI.BUKRS := ' '; -- Obrigat�rio(S) - C�digo da companhia*
        tpFIXED_ASSET_S_POSTINGINFORMATI.ANLN1 := vIdentificadorAtivo;  -- Obrigat�rio(S) - Identificador de ativo externo / do legado
        tpFIXED_ASSET_S_POSTINGINFORMATI.AKTIV := ' '; -- Obrigat�rio(S) - Data de Capitaliza��o de Ativos *
        tpFIXED_ASSET_S_POSTINGINFORMATI.DEAKT := ' '; -- Obrigat�rio(N) - Data de desativa��o
        tpFIXED_ASSET_S_POSTINGINFORMATI.GPLAB := ' '; -- Obrigat�rio(N) - Data de obsol�ncia planejada
        tpFIXED_ASSET_S_POSTINGINFORMATI.BSTDT := ' '; -- Obrigat�rio(N) - Data do pedido de compra do ativo
                                         
        INSERT INTO MIGDV.FIXED_ASSET_S_POSTINGINFORMATI VALUES tpFIXED_ASSET_S_POSTINGINFORMATI;
        
        COMMIT;
        
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
begin
  
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
                                                    'RETROESCAVADEIRA','0110406401', -- MANUTEN��O
                                                    'CARRO DIRETORIA','0110301001', -- CORPORATIVO
                                                    'GUINCHO','0110406401', -- MANUTEN��O
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
--                                                    'I', -- RE bens im�veis
--                                                    'M', -- Sistema t�cnico - padr�o
--                                                    'F', -- Local de instala��o fixo
--                                                    'P', -- Recapadora
--                                                    'X', -- Eixo
                                                    M.FRT_MARCMODAPELIDO_DESCRICAO) FLTYP,


             DECODE(M.FRT_MARCMODAPELIDO_DESCRICAO, 'NAO DEFINIDO','1000', -- Tipo equipam.  1000
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
                                                    'NAO SEI','1000', -- Tipo equipam.  1000
                                                    'SAVEIRO','FL_SAVEIRO', -- SAVEIRO
                                                    'TANQ','1000', -- Tipo equipam.  1000
                                                    'TBAU','TRUCK_F4X2', -- CAMINH�O TRUCK 2428E
                                                    'TSIDER','TRUCK_F4X2', -- CAMINH�O TRUCK 2428E
                                                    'TSIMPLES','TRUCK_F4X2', -- CAMINH�O TRUCK 2428E
                                                    'UTILITARIO','FL_GOL', -- GOL
                                                    'VAND','1000', -- Tipo equipam.  1000
                                                    'RETROESCAVADEIRA','RET_ESCAV', -- RETROESCAVADEIRA
                                                    'CARRO DIRETORIA','FL_LEXUS', -- LEXUS
                                                    'GUINCHO','1000', -- Tipo equipam.  1000
                                                    'MOTO','1000', -- Tipo equipam.  1000
                                      -- '1000', -- Tipo equipam.  1000
                                      -- '1230', -- Guind.torre > 100 tm
                                      -- '1380', -- Tratores de esteira
                                      -- '2000', -- Tipo equipam.   2000
                                      -- '5100', -- Armamento / f�rma
                                      -- '9000', -- Equipamento inform.
                                      -- '9100', -- Motores
                                      -- '9200', -- Compressores rotats.
                                      -- '9300', -- Radiadores
                                      -- '9400', -- V�lvulas
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
                                      -- 'TRUCK_F4X2', -- CAMINH�O TRUCK 2428E
                                      -- 'TRUCK_F6X2', -- CAMINH�O TRUCK 2429
                                      -- 'TRUCK_V6X2', -- CAMINH�O VW 24280 CR
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
          tpEQUIPMENT_S_EQUI.EQUNR     := vCursor.PLACA; -- Obrigat�rio(S) - Identificador do equipamento no Legado
          tpEQUIPMENT_S_EQUI.EQTYP     := vCursor.EQTYP;  -- Obrigat�rio(S) - Categoria de equipamento *
          tpEQUIPMENT_S_EQUI.EQKTX     := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' '); -- Obrigat�rio(S) - Descri��o do equipamento
          tpEQUIPMENT_S_EQUI.EQART     := vCursor.EQART; -- Obrigat�rio(N) - Tipo de objeto t�cnico
          tpEQUIPMENT_S_EQUI.BEGRU     := '0001'; -- OU 0002 VERIFICAR -- Obrigat�rio(N) - Grupo de autoriza��o de objeto t�cnico
          tpEQUIPMENT_S_EQUI.DATAB     := vCursor.DT_AQUISICAO; -- YYYYMMDD - Obrigat�rio(S) - Data de validade inicial
          tpEQUIPMENT_S_EQUI.GROES     := ' '; -- Obrigat�rio(N) - Tamanho / dimens�o
          tpEQUIPMENT_S_EQUI.BRGEW     := NVL(vCursor.PESO_VEICULO,' '); -- Obrigat�rio(N) - Peso do objeto 
          If tpEQUIPMENT_S_EQUI.BRGEW = ' ' Then
             tpEQUIPMENT_S_EQUI.GEWEI     := ' '; -- Obrigat�rio(N) - Unidade de peso (formato ISO)
          Else
             tpEQUIPMENT_S_EQUI.GEWEI     := vCursor.UNIDADE; -- Obrigat�rio(N) - Unidade de peso (formato ISO)
          End If;
          tpEQUIPMENT_S_EQUI.INVNR     := ' '; -- Obrigat�rio(N) - Identificador de invent�rio
          tpEQUIPMENT_S_EQUI.INBDT     :=  vCursor.DT_AQUISICAO; -- Obrigat�rio(N) - Data de in�cio do objeto t�cnico
          tpEQUIPMENT_S_EQUI.ANSWT     := NVL(vCursor.VALOR_AQUISICAO, 0); -- Obrigat�rio(N) - Valor de aquisi��o
          tpEQUIPMENT_S_EQUI.WAERS     := 'BRL'; -- Obrigat�rio(N) - Identificador da moeda (formato ISO)
          tpEQUIPMENT_S_EQUI.HERST     := NVL(vCursor.MARCA, ' '); -- Obrigat�rio(N) - Fabricante do ativo
          tpEQUIPMENT_S_EQUI.HERLD     := 'BR'; -- Obrigat�rio(N) - Pa�s de fabrica��o
          tpEQUIPMENT_S_EQUI.TYPBZ     := NVL(vCursor.MODELO, ' '); -- Obrigat�rio(N) - N�mero do modelo do fabricante
          tpEQUIPMENT_S_EQUI.BAUJJ     := NVL(TRIM(vCursor.ANOFABRICACAO), ' '); -- Obrigat�rio(N) - Ano de fabrica��o
          tpEQUIPMENT_S_EQUI.BAUMM     := ' '; -- Obrigat�rio(N) - M�s de fabrica��o
          tpEQUIPMENT_S_EQUI.MAPAR     := ' '; -- Obrigat�rio(N) - N�mero da pe�a do fabricante (part number)
          tpEQUIPMENT_S_EQUI.SERGE     := NVL(TRIM(vCursor.CHASSI), ' '); -- Obrigat�rio(N) - N�mero de s�rie do fabricante
          tpEQUIPMENT_S_EQUI.SORTFIELD := ' '; -- Obrigat�rio(N) - Campo de Classifica��o
          tpEQUIPMENT_S_EQUI.BUKRS     := '1'; -- Obrigat�rio(N) - C�digo da companhia
          tpEQUIPMENT_S_EQUI.ANLNR     := ' '; -- Obrigat�rio(N) - Identificador do ativo principal
          tpEQUIPMENT_S_EQUI.KOSTL     := vCursor.KOSTL; -- Obrigat�rio(N) - Centro de custo
          tpEQUIPMENT_S_EQUI.TPLNR     := ' '; -- Obrigat�rio(N) - Identificador do Local de Instala��o
          tpEQUIPMENT_S_EQUI.MATNR     := ' '; -- Obrigat�rio(N) - Identificador de Material
          tpEQUIPMENT_S_EQUI.GERNR     := NVL(SUBSTR(vCursor.CHASSI, 1, 18), ' '); -- Obrigat�rio(N) - N�mero de s�rie
                                         
           -- Select para encontrar ve�culo de tracao que est� engatado
             FOR vCursorEngate IN(
                 select ce.frt_conjveiculo_codigo conjunto
                 from TDVADM.t_frt_conteng ce,
                      TDVADM.t_frt_veiculo v,
                      TDVADM.T_FRT_MARMODVEIC A, 
                      tdvadm.t_frt_tpveiculo tv,
                      TDVADM.T_FRT_MARCMODAPELIDO M
                 where 0 = 0
                   AND V.FRT_MARMODVEIC_CODIGO = A.FRT_MARMODVEIC_CODIGO 
                   AND A.FRT_MARCMODAPELIDO_CODIGO = M.FRT_MARCMODAPELIDO_CODIGO (+)
                   and a.frt_tpveiculo_codigo = tv.frt_tpveiculo_codigo
                   and tv.frt_tpveiculo_tracao = 'S'
                   AND ce.frt_veiculo_codigo = v.frt_veiculo_codigo
                   AND ce.frt_veiculo_codigo = vCursor.VEIC_CODIGO -- c�digo do ve�culo
                                  )
             LOOP
                tpEQUIPMENT_S_EQUI.TPLNR := vCursorEngate.conjunto;
             End Loop;

          begin
              INSERT INTO MIGDV.EQUIPMENT_S_EQUI VALUES tpEQUIPMENT_S_EQUI;
              COMMIT;

            IF vCursor.TRACAO = 'SIM' THEN
            -- Inicio Local de instalacao
                 tpFUNC_LOC_S_FUN_LOCATION.EXTERNAL_NUMBER := tpEQUIPMENT_S_EQUI.TPLNR; -- Obrigat�rio(S) - Identificador do local de instala��o (sequencial ou identificador do legado)
              /*CAMPO TPLKZ - COLOCAMOS 1 EM CONVERSA COM A ANA FOI DITO QUE COMO N�O TEMOS MAIS DE 
                UM LOCAL DE INSTALA��O PODEMOS MANDAR 1
              */
                 tpFUNC_LOC_S_FUN_LOCATION.TPLKZ      := 'D_V'; -- Obrigat�rio(S) - Indicador de estrutura do local de instala��o
                 tpFUNC_LOC_S_FUN_LOCATION.FLTYP      := vCursor.FLTYP; -- Obrigat�rio(S) - Categoria do local de instala��o
                 tpFUNC_LOC_S_FUN_LOCATION.ALKEY      := ' '; -- Obrigat�rio(N) - Sistema de etiquetagem para locais de instala��o
                 tpFUNC_LOC_S_FUN_LOCATION.KTX01      := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' '); -- Obrigat�rio(N) - Descri��o do objeto t�cnico
                 tpFUNC_LOC_S_FUN_LOCATION.EQART      := vCursor.EQART; -- Obrigat�rio(N) - Tipo de objeto t�cnico
                 tpFUNC_LOC_S_FUN_LOCATION.INVNR      := ''; -- Obrigat�rio(N) - N�mero de invent�rio
                 tpFUNC_LOC_S_FUN_LOCATION.BRGEW      := NVL(vCursor.PESO_VEICULO,' '); -- Obrigat�rio(N) - Peso do objeto
                 If tpFUNC_LOC_S_FUN_LOCATION.BRGEW = ' ' Then
                    tpFUNC_LOC_S_FUN_LOCATION.GEWEI      := ' '; -- Obrigat�rio(N) - Unidade de peso (formato ISO)
                 Else
                    tpFUNC_LOC_S_FUN_LOCATION.GEWEI      := vCursor.UNIDADE; -- Obrigat�rio(N) - Unidade de peso (formato ISO)
                 End If;
                 tpFUNC_LOC_S_FUN_LOCATION.GROES      := ' '; -- Obrigat�rio(N) - Tamanho / dimens�o
                 tpFUNC_LOC_S_FUN_LOCATION.INBDT      := vCursor.DT_AQUISICAO; -- Obrigat�rio(N) - Data de in�cio do objeto t�cnico
                 tpFUNC_LOC_S_FUN_LOCATION.SORTFIELD  := ' '; -- Obrigat�rio(N) - Campo de Classifica��o
                 tpFUNC_LOC_S_FUN_LOCATION.BUKRS      := '1'; -- Obrigat�rio(N) - C�digo da companhia
                 tpFUNC_LOC_S_FUN_LOCATION.GSBER      :=  '0001'; -- Estrutura -- Obrigat�rio(N) - �rea de trabalho
                 tpFUNC_LOC_S_FUN_LOCATION.KOSTL      := vCursor.KOSTL; -- Obrigat�rio(N) - Centro de custo
              
                 SP_SAP_INSERE_LOCAL_INSTALACAO(tpFUNC_LOC_S_FUN_LOCATION, PRESULTADO, PMENSAGEM);         
            
                 -- Fim local de instalacao
              End If; 
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
    END LOOP;
    

End SP_SAP_INSERE_EQUIPAMENTO;


-- Insere Local de Instala��o
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
        tpFUNC_LOC_S_FUN_LOCATION.EXTERNAL_NUMBER := tpLOCAL.EXTERNAL_NUMBER; -- Obrigat�rio(S) - Identificador do local de instala��o (sequencial ou identificador do legado)
        tpFUNC_LOC_S_FUN_LOCATION.TPLKZ           := NVL(tpLOCAL.TPLKZ,' '); -- Obrigat�rio(S) - Indicador de estrutura do local de instala��o
        tpFUNC_LOC_S_FUN_LOCATION.FLTYP           := tpLOCAL.FLTYP; -- Obrigat�rio(S) - Categoria do local de instala��o
        tpFUNC_LOC_S_FUN_LOCATION.ALKEY           := tpLOCAL.ALKEY; -- Obrigat�rio(N) - Sistema de etiquetagem para locais de instala��o
        tpFUNC_LOC_S_FUN_LOCATION.KTX01           := tpLOCAL.KTX01; -- Obrigat�rio(N) - Descri��o do objeto t�cnico
        tpFUNC_LOC_S_FUN_LOCATION.EQART           := tpLOCAL.EQART; -- Obrigat�rio(N) - Tipo de objeto t�cnico
        tpFUNC_LOC_S_FUN_LOCATION.INVNR           := NVL(tpLOCAL.INVNR, ' '); -- Obrigat�rio(N) - N�mero de invent�rio
        tpFUNC_LOC_S_FUN_LOCATION.BRGEW           := tpLOCAL.BRGEW;  -- Obrigat�rio(N) - Peso do objeto
        tpFUNC_LOC_S_FUN_LOCATION.GEWEI           := tpLOCAL.GEWEI; -- Obrigat�rio(N) - Unidade de peso (formato ISO)
        tpFUNC_LOC_S_FUN_LOCATION.GROES           := tpLOCAL.GROES; -- Obrigat�rio(N) - Tamanho / dimens�o
        tpFUNC_LOC_S_FUN_LOCATION.INBDT           := tpLOCAL.INBDT; -- Obrigat�rio(N) - Data de in�cio do objeto t�cnico
        tpFUNC_LOC_S_FUN_LOCATION.SORTFIELD       := tpLOCAL.SORTFIELD; -- Obrigat�rio(N) - Campo de Classifica��o
        tpFUNC_LOC_S_FUN_LOCATION.BUKRS           := tpLOCAL.BUKRS; -- Obrigat�rio(N) - C�digo da companhia
        tpFUNC_LOC_S_FUN_LOCATION.GSBER           := tpLOCAL.GSBER; -- Obrigat�rio(N) - �rea de trabalho
        tpFUNC_LOC_S_FUN_LOCATION.KOSTL           := tpLOCAL.KOSTL; -- Obrigat�rio(N) - Centro de custo
                                         
        Begin
           INSERT INTO MIGDV.FUNC_LOC_S_FUN_LOCATION VALUES tpFUNC_LOC_S_FUN_LOCATION;
           COMMIT; 
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
        PMENSAGEM  := 'Local de instala��o inserido com sucesso';
   END IF;
End SP_SAP_INSERE_LOCAL_INSTALACAO;


-- Insere PNEU
procedure SP_SAP_INSERE_PNEU(PRESULTADO OUT Char,
                             PMENSAGEM OUT VARCHAR2) IS 
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
      tpEQUIPMENT_S_EQUI.EQUNR     := vCursor2.CODIGO; -- Obrigat�rio(S) - Identificador do equipamento no Leg
      tpEQUIPMENT_S_EQUI.EQTYP     := 'P'; -- Obrigat�rio(S) - Categoria de equipamento *
      tpEQUIPMENT_S_EQUI.EQKTX     := NVL(SUBSTR(vCursor2.DESCRICAO, 1, 40), ' '); -- Obrigat�rio(S) - Descri��o do equipamento
      tpEQUIPMENT_S_EQUI.EQART     := vCursor2.EQART; -- Obrigat�rio(N) - Tipo de objeto t�cnico
      tpEQUIPMENT_S_EQUI.BEGRU     := ' '; -- Obrigat�rio(N) - Grupo de autoriza��o de objeto t�cnico
      tpEQUIPMENT_S_EQUI.DATAB     := vCursor2.DT_AQUISICAO; -- Obrigat�rio(S) - Data de validade inicial
      tpEQUIPMENT_S_EQUI.GROES     := ' '; -- Obrigat�rio(N) - Tamanho / dimens�o
      tpEQUIPMENT_S_EQUI.BRGEW     := ' '; -- Obrigat�rio(N) - Peso do objeto 
      tpEQUIPMENT_S_EQUI.GEWEI     := ' '; -- Obrigat�rio(N) - Unidade de peso (formato ISO)
      tpEQUIPMENT_S_EQUI.INVNR     := ' '; -- Obrigat�rio(N) - Identificador de invent�rio
      tpEQUIPMENT_S_EQUI.INBDT     := vCursor2.DT_AQUISICAO; -- Obrigat�rio(N) - Data de in�cio do objeto t�cnico
      tpEQUIPMENT_S_EQUI.ANSWT     := NVL(vCursor2.VALORAQUISICAO, 0); -- Obrigat�rio(N) - Valor de aquisi��o
      tpEQUIPMENT_S_EQUI.WAERS     := 'BRL'; -- Obrigat�rio(N) - Identificador da moeda (formato ISO)
      tpEQUIPMENT_S_EQUI.HERST     := NVL(vCursor2.FABRICANTE, ' '); -- Obrigat�rio(N) - Fabricante do ativo
      tpEQUIPMENT_S_EQUI.HERLD     := 'BR'; -- Obrigat�rio(N) - Pa�s de fabrica��o
      tpEQUIPMENT_S_EQUI.TYPBZ     := NVL(TO_CHAR(vCursor2.MODELOCOD), ' '); -- Obrigat�rio(N) - N�mero do modelo do fabricante
      tpEQUIPMENT_S_EQUI.BAUJJ     := ' '; -- Obrigat�rio(N) - Ano de fabrica��o
      tpEQUIPMENT_S_EQUI.BAUMM     := ' '; -- Obrigat�rio(N) - M�s de fabrica��o
      tpEQUIPMENT_S_EQUI.MAPAR     := ' '; -- Obrigat�rio(N) - N�mero da pe�a do fabricante (part number)
      tpEQUIPMENT_S_EQUI.SERGE     := NVL(TRIM(vCursor2.SERIE), ' '); -- Obrigat�rio(N) - N�mero de s�rie do fabricante
      tpEQUIPMENT_S_EQUI.SORTFIELD := ' '; -- Obrigat�rio(N) - Campo de Classifica��o
      tpEQUIPMENT_S_EQUI.BUKRS     := '1'; -- Obrigat�rio(N) - C�digo da companhia
      tpEQUIPMENT_S_EQUI.ANLNR     := 0; -- Obrigat�rio(N) - Identificador do ativo principal
      If length(trim(nvl(vCursor2.codveiculo,' '))) > 3 Then 
         tpEQUIPMENT_S_EQUI.KOSTL     := '0110406501'; -- CONTROLE DE PNE -- Obrigat�rio(N) - Centro de custo
      Else
         tpEQUIPMENT_S_EQUI.KOSTL     := '0110406404'; -- BORRACHARIA -- Obrigat�rio(N) - Centro de custo
      End If;
      tpEQUIPMENT_S_EQUI.TPLNR     := nvl(vCursor2.Placa, ' '); -- Obrigat�rio(N) - Identificador do Local de Instala��o
      tpEQUIPMENT_S_EQUI.MATNR     := vCursor2.CODIGO; -- Obrigat�rio(N) - Identificador de Material
      -- N�mero de s�rie - Foi informado pelo Thiago da borracharia que n�o ser� migrado para o SAP
      tpEQUIPMENT_S_EQUI.GERNR     := ' ';--NVL(SUBSTR(vCursor2.SERIE, 1, 18), ' '); -- Obrigat�rio(N) - N�mero de s�rie
                                              
      INSERT INTO MIGDV.EQUIPMENT_S_EQUI VALUES tpEQUIPMENT_S_EQUI;
      COMMIT;
      
      PRESULTADO := 'N';
      PMENSAGEM  := 'PNEU INSERIDO COM SUCESSO.';
    END LOOP;
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
      tpEQUIPMENT_S_EQUI.EQUNR     := vCursor2.CODIGO; -- Obrigat�rio(S) - Identificador do equipamento no Leg
      tpEQUIPMENT_S_EQUI.EQTYP     := 'P'; -- Obrigat�rio(S) - Categoria de equipamento *
      tpEQUIPMENT_S_EQUI.EQKTX     := NVL(SUBSTR(vCursor2.DESCRICAO, 1, 40), ' '); -- Obrigat�rio(S) - Descri��o do equipamento
      tpEQUIPMENT_S_EQUI.EQART     := 'NAO SEI'; -- Obrigat�rio(N) - Tipo de objeto t�cnico
      tpEQUIPMENT_S_EQUI.BEGRU     := 'NAO SEI'; -- Obrigat�rio(N) - Grupo de autoriza��o de objeto t�cnico
      tpEQUIPMENT_S_EQUI.DATAB     := 'NAO SEI'; -- Obrigat�rio(S) - Data de validade inicial
      tpEQUIPMENT_S_EQUI.GROES     := ' '; -- Obrigat�rio(N) - Tamanho / dimens�o
      tpEQUIPMENT_S_EQUI.BRGEW     := 0; -- Obrigat�rio(N) - Peso do objeto 
      tpEQUIPMENT_S_EQUI.GEWEI     := ' '; -- Obrigat�rio(N) - Unidade de peso (formato ISO)
      tpEQUIPMENT_S_EQUI.INVNR     := ' '; -- Obrigat�rio(N) - Identificador de invent�rio
      tpEQUIPMENT_S_EQUI.INBDT     := ' '; -- Obrigat�rio(N) - Data de in�cio do objeto t�cnico
      tpEQUIPMENT_S_EQUI.ANSWT     := NVL(vCursor2.VALORAQUISICAO, 0); -- Obrigat�rio(N) - Valor de aquisi��o
      tpEQUIPMENT_S_EQUI.WAERS     := 'BRL'; -- Obrigat�rio(N) - Identificador da moeda (formato ISO)
      tpEQUIPMENT_S_EQUI.HERST     := NVL(vCursor2.FABRICANTE, ' '); -- Obrigat�rio(N) - Fabricante do ativo
      tpEQUIPMENT_S_EQUI.HERLD     := 'BR'; -- Obrigat�rio(N) - Pa�s de fabrica��o
      tpEQUIPMENT_S_EQUI.TYPBZ     := NVL(TO_CHAR(vCursor2.MODELOCOD), ' '); -- Obrigat�rio(N) - N�mero do modelo do fabricante
      tpEQUIPMENT_S_EQUI.BAUJJ     := ' '; -- Obrigat�rio(N) - Ano de fabrica��o
      tpEQUIPMENT_S_EQUI.BAUMM     := ' '; -- Obrigat�rio(N) - M�s de fabrica��o
      tpEQUIPMENT_S_EQUI.MAPAR     := ' '; -- Obrigat�rio(N) - N�mero da pe�a do fabricante (part number)
      tpEQUIPMENT_S_EQUI.SERGE     := NVL(TRIM(vCursor2.SERIE), ' '); -- Obrigat�rio(N) - N�mero de s�rie do fabricante
      tpEQUIPMENT_S_EQUI.SORTFIELD := 'NAO SEI'; -- Obrigat�rio(N) - Campo de Classifica��o
      tpEQUIPMENT_S_EQUI.BUKRS     := '1'; -- Obrigat�rio(N) - C�digo da companhia
      tpEQUIPMENT_S_EQUI.ANLNR     := 0; -- Obrigat�rio(N) - Identificador do ativo principal
      tpEQUIPMENT_S_EQUI.KOSTL     := 'NAO SEI'; -- Obrigat�rio(N) - Centro de custo
      tpEQUIPMENT_S_EQUI.TPLNR     := nvl(vCursor2.Placa, ' '); -- Obrigat�rio(N) - Identificador do Local de Instala��o
      tpEQUIPMENT_S_EQUI.MATNR     := vCursor2.CODIGO; -- Obrigat�rio(N) - Identificador de Material
      -- N�mero de s�rie - Foi informado pelo Thiago da borracharia que n�o ser� migrado para o SAP
      tpEQUIPMENT_S_EQUI.GERNR     := ' ';--NVL(SUBSTR(vCursor2.SERIE, 1, 18), ' '); -- Obrigat�rio(N) - N�mero de s�rie
                                              
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
tpMATERIAL_S_MARA MIGDV.MATERIAL_S_MARA%ROWTYPE;    
tpMATERIAL_S_MARM MIGDV.MATERIAL_S_MARM%ROWTYPE;
tpMATERIAL_S_MARD MIGDV.MATERIAL_S_MARD%ROWTYPE;
tpMATERIAL_S_MLAN MIGDV.MATERIAL_S_MLAN%ROWTYPE;
tpMATERIAL_S_MAKT MIGDV.MATERIAL_S_MAKT%ROWTYPE;
begin  
    FOR vCursor IN (   
      SELECT M.CODIGOMATINT,
             M.CODIGOINTERNOMATERIAL CODIGOINTERNOMATERIAL,            
             M.DIGITOVERMAT,             
             M.DESCRICAOMAT DESCRICAO,
             'PT' IDIOMA,       
             'BR' PAIS,      
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
                                 'O','YBFA10', -- Bens de baixo valor
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
        
        tpMATERIAL_S_MARA.MATNR    := vIdentificadorMaterial; -- Obrigat�rio(S) - Identificador do Material
        tpMATERIAL_S_MARA.SPRAS    := vCursor.IDIOMA; -- Obrigat�rio(S) - Chave de idioma *
        tpMATERIAL_S_MARA.MAKTX    := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' ');--vCursor.Descricaomat; -- Obrigat�rio(S) - Descri��o do material*
        tpMATERIAL_S_MARA.MBRSH    := 'T';--indica setor de transporte Ana falou para mandar T-- Obrigat�rio(S) - Setor industrial*
        tpMATERIAL_S_MARA.MTART    := NVL(vCursor.TIPO_MATERIAL, ' ');--vCursor.Tpmaterial; -- Obrigat�rio(S) - Tipo de material*
        tpMATERIAL_S_MARA."GROUP"  := '01'; -- Obrigat�rio(N) - Visualiza��es de material
        tpMATERIAL_S_MARA.MATKL    := vCursor.MATKL; -- Obrigat�rio(N) - Grupo de material
        tpMATERIAL_S_MARA.EAN11    := NVL(vCursor.CODEAN,'00000000000'); -- Obrigat�rio(N) - Identificador internacional do artigo (EAN / UPC)
        tpMATERIAL_S_MARA.NUMTP    := ' '; -- Obrigat�rio(N) - Categoria EAN
        tpMATERIAL_S_MARA.MEINS    := NVL(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigat�rio(S) - Unidade de medida b�sica (formato ISO) *
        tpMATERIAL_S_MARA.BISMT    := vCursor.CODIGOINTERNOMATERIAL; -- Obrigat�rio(N) - N�mero de material no legado
        tpMATERIAL_S_MARA.BRGEW    := ' '; -- Obrigat�rio(N) - Peso bruto
        tpMATERIAL_S_MARA.NTGEW    := 0; -- Obrigat�rio(N) - Peso l�quido
        tpMATERIAL_S_MARA.GEWEI    := ' '; -- Obrigat�rio(N) - Unidade de Peso
        tpMATERIAL_S_MARA.VOLUM    := 0; -- Obrigat�rio(N) - Volume
        tpMATERIAL_S_MARA.VOLEH    := 0; -- Obrigat�rio(N) - Unidade de volume
        tpMATERIAL_S_MARA.GROES    := ' '; -- Obrigat�rio(N) - Tamanho / dimens�es
        tpMATERIAL_S_MARA.LAENG    := 0; -- Obrigat�rio(N) - comprimento
        tpMATERIAL_S_MARA.BREIT    := 0; -- Obrigat�rio(N) - Largura
        tpMATERIAL_S_MARA.HOEHE    := 0; -- Obrigat�rio(N) - Altura
        tpMATERIAL_S_MARA.MEABM    := ' '; -- Obrigat�rio(N) - Unidade para comprimento / largura / altura (ISO)
        tpMATERIAL_S_MARA.KZKFG    := ' '; -- Obrigat�rio(N) - O material � configur�vel
        tpMATERIAL_S_MARA.ANP      := ' '; -- Obrigat�rio(N) - C�digo ANP
        tpMATERIAL_S_MARA.BSTME    :=  NVL(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigat�rio(N) - Unidade de ordem (formato ISO)
        tpMATERIAL_S_MARA.MFRPN    := ' '; -- Obrigat�rio(N) - N�mero da pe�a de fabricante (part number)
        tpMATERIAL_S_MARA.MFRNR    := ' '; -- Obrigat�rio(N) - N�mero do fabricante
        tpMATERIAL_S_MARA.MPROF    := ' '; -- NAO SERA USADO NA DELLA VOLPE-- Obrigat�rio(N) - Perfil da pe�a
        tpMATERIAL_S_MARA.ETIAR    := ' '; -- NAO SERA USADO NA DELLA VOLPE-- Obrigat�rio(N) - Tipo de etiqueta
        tpMATERIAL_S_MARA.ETIFO    := ' '; -- NAO SERA USADO NA DELLA VOLPE -- Obrigat�rio(N) - Formul�rio de etiqueta
                                          
        INSERT INTO MIGDV.MATERIAL_S_MARA VALUES tpMATERIAL_S_MARA;
        COMMIT;
                
/*   n�o vou preencher mais conforme #1165
  
      -- Unidades de medida do material 
        tpMATERIAL_S_MARM.MATNR := vIdentificadorMaterial; -- Obrigat�rio(S) - Identificador do Material
        tpMATERIAL_S_MARM.MEINH := NVL(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigat�rio(S) - Unidade de medida alternativa (formato ISO) *
        tpMATERIAL_S_MARM.UMREN := 1; -- Obrigat�rio(S) - Denominador para convers�o em unidade base *
        tpMATERIAL_S_MARM.UMREZ := 1; -- Obrigat�rio(S) - Numerador para convers�o em unidade base *
        tpMATERIAL_S_MARM.EAN11 := NVL(vCursor.CODEAN,'00000000000'); -- Obrigat�rio(N) - N�mero internacional do artigo (EAN / UPC)
        tpMATERIAL_S_MARM.NUMTP := ' '; -- Obrigat�rio(N) - Categoria EAN
        tpMATERIAL_S_MARM.LAENG := 0; -- Obrigat�rio(N) - comprimento
        tpMATERIAL_S_MARM.BREIT := 0; -- Obrigat�rio(N) - Largura 
        tpMATERIAL_S_MARM.HOEHE := 0; -- Obrigat�rio(N) - Altura
        tpMATERIAL_S_MARM.MEABM := nvl(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigat�rio(N) - Unidade para comprimento / largura / altura (ISO) 
        tpMATERIAL_S_MARM.VOLUM := 0; -- Obrigat�rio(N) - Volume
        tpMATERIAL_S_MARM.VOLEH := nvl(vCursor.UNIDADE_MEDIDA, ' '); -- Obrigat�rio(N) - Unidade de volume
        tpMATERIAL_S_MARM.BRGEW := ' '; -- Obrigat�rio(N) - Peso bruto
        tpMATERIAL_S_MARM.GEWEI := ' '; -- Obrigat�rio(N) - Unidade de Peso
        
        SP_SAP_INSERE_MATERIAL_UNIDADE_MEDIDA(tpMATERIAL_S_MARM, PRESULTADO, PMENSAGEM);
*/        
        -- Dados de localiza��o do Material 
        /* Informado pela ana que no momento n�o vamos gerar dados para essa estrutura
        tpMATERIAL_S_MARD.MATNR := vIdentificadorMaterial; -- Obrigat�rio(S) - Identificador do Material
        tpMATERIAL_S_MARD.WERKS := ' '; -- SOLICITADO PARA ENVIAR EM BRANCO-- Obrigat�rio(S) - Planta
        tpMATERIAL_S_MARD.LGORT := ' '; -- SOLICITADO PARA ENVIAR EM BRANCO-- Obrigat�rio(S) - Local de armazenamento*werks
        
        SP_SAP_INSERE_MATERIAL_DADOS_LOCALIZACAO(tpMATERIAL_S_MARD, PRESULTADO, PMENSAGEM);
        */ 
        -- Dados de classifica��o fiscal do material.
        tpMATERIAL_S_MLAN.MATNR  := vIdentificadorMaterial; -- Obrigat�rio(S) - Identificador do Material
        tpMATERIAL_S_MLAN.ALAND  := vCursor.PAIS; -- Obrigat�rio(S) - Pa�s de partida *
        tpMATERIAL_S_MLAN.TATYP1 := '1'; -- Obrigat�rio(S) - Categoria fiscal 1 *
        tpMATERIAL_S_MLAN.TAXM1  := '1'; -- Obrigat�rio(S) - Classifica��o fiscal 1 *
        tpMATERIAL_S_MLAN.TATYP2 := ' '; -- Obrigat�rio(N) - Categoria fiscal 2
        tpMATERIAL_S_MLAN.TAXM2  := ' '; -- Obrigat�rio(N) - Classifica��o fiscal 2
        tpMATERIAL_S_MLAN.TATYP3 := ' '; -- Obrigat�rio(N) - Categoria fiscal 3
        tpMATERIAL_S_MLAN.TAXM3  := ' '; -- Obrigat�rio(N) - Classifica��o fiscal 3
        tpMATERIAL_S_MLAN.TATYP4 := ' '; -- Obrigat�rio(N) - Categoria fiscal 4
        tpMATERIAL_S_MLAN.TAXM4  := ' '; -- Obrigat�rio(N) - Classifica��o fiscal 4
        tpMATERIAL_S_MLAN.TATYP5 := ' '; -- Obrigat�rio(N) - Categoria fiscal 5
        tpMATERIAL_S_MLAN.TAXM5  := ' '; -- Obrigat�rio(N) - Classifica��o fiscal 5
        tpMATERIAL_S_MLAN.TATYP6 := ' '; -- Obrigat�rio(N) - Categoria fiscal 6
        tpMATERIAL_S_MLAN.TAXM6  := ' '; -- Obrigat�rio(N) - Classifica��o fiscal 6
        tpMATERIAL_S_MLAN.TAXIM  := ' '; -- Obrigat�rio(N) - C�digo de imposto para material (Compras) 
        
        SP_SAP_INSERE_MATERIAL_CLASSIFICACAO_FISCAL(tpMATERIAL_S_MLAN, PRESULTADO, PMENSAGEM);
        
        -- Lista de descri��es do material 
        tpMATERIAL_S_MAKT.MATNR := vIdentificadorMaterial; -- Obrigat�rio(S) - Identificador do Material                
        tpMATERIAL_S_MAKT.SPRAS := 'PT'; -- Obrigat�rio(S) - Identificador do Idioma
        tpMATERIAL_S_MAKT.MAKTX := NVL(SUBSTR(vCursor.DESCRICAO, 1, 40), ' ');  -- Obrigat�rio(S) - Descri��o do material  
        
        SP_SAP_INSERE_MATERIAL_LISTA_DESCRICAO(tpMATERIAL_S_MAKT, PRESULTADO, PMENSAGEM);
              
        PRESULTADO := 'N';
        PMENSAGEM  := 'Material inserido com sucesso';        
       
   END LOOP; 
   
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
      COMMIT;
                
      PRESULTADO := 'N';
      PMENSAGEM  := 'Unidade de medida inserido com sucesso';
    END IF;   
End SP_SAP_INSERE_MATERIAL_UNIDADE_MEDIDA;


-- Insere Dados de localiza��o do Material
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
      COMMIT;              
              
      PRESULTADO := 'N';
      PMENSAGEM  := 'Dados da localiza��o do material inserido com sucesso';        
    END IF;
  
End SP_SAP_INSERE_MATERIAL_DADOS_LOCALIZACAO;


-- Insere Classifica��o fiscal do Material
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
        COMMIT;        
                
        PRESULTADO := 'N';
        PMENSAGEM  := 'Classifica��o fiscal do material inserido com sucesso';        
        
    END IF; 
    
End SP_SAP_INSERE_MATERIAL_CLASSIFICACAO_FISCAL;


-- Insere Lista de descri��es do Material
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
        COMMIT;
        
        
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
begin
   
    FOR vCursor IN (select *
                    from migdv.v_contaapagar )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
       
        tpOPEN_ITEM_AP_S_BSIK.BUKRS := vCursor.BUKRS; -- Obrigat�rio(S) - C�digo da companhia*
        tpOPEN_ITEM_AP_S_BSIK.XBLNR := vCursor.XBLNR; -- Obrigat�rio(S) - N�mero do documento de refer�ncia *
        tpOPEN_ITEM_AP_S_BSIK.LIFNR := migdv.pkg_migracao_sap2.fn_busca_codigoSAP(vCursor.car_proprietario_cgccpfcodigo,'CAR') ; -- Obrigat�rio(S) - Identificador do Fornecedor*
        tpOPEN_ITEM_AP_S_BSIK.GKONT := vCursor.GKONT ; -- Obrigat�rio(S) - Conta de compensa��o *
        tpOPEN_ITEM_AP_S_BSIK.BLART := vCursor.BLART ; -- Obrigat�rio(S) - Tipo de documento*
        tpOPEN_ITEM_AP_S_BSIK.BLDAT := vCursor.BLDAT ; -- Obrigat�rio(S) - Data do documento* 
        tpOPEN_ITEM_AP_S_BSIK.BUDAT := vCursor.BUDAT ; -- Obrigat�rio(S) - Data de postagem*
        tpOPEN_ITEM_AP_S_BSIK.BKTXT := vCursor.BKTXT ; -- Obrigat�rio(N) - Texto do cabe�alho
        tpOPEN_ITEM_AP_S_BSIK.SGTXT := vCursor.SGTXT ; -- Obrigat�rio(N) - Texto do item
        tpOPEN_ITEM_AP_S_BSIK.WAERS := vCursor.WAERS ; -- Obrigat�rio(S) - Moeda do Documento
        tpOPEN_ITEM_AP_S_BSIK.WRBTR := vCursor.WRBTR ; -- Obrigat�rio(S) - Montante na moeda do documento
        tpOPEN_ITEM_AP_S_BSIK.HWAER := vCursor.HWAER ; -- Obrigat�rio(S) - Moeda local*
        tpOPEN_ITEM_AP_S_BSIK.DMBTR := vCursor.DMBTR ; -- Obrigat�rio(S) - Montante na moeda local
        tpOPEN_ITEM_AP_S_BSIK.HWAE2 := vCursor.HWAE2 ; -- Obrigat�rio(N) - Moeda local 2
        tpOPEN_ITEM_AP_S_BSIK.DMBE2 := vCursor.DMBE2 ; -- Obrigat�rio(N) - Montante na moeda local 2
        tpOPEN_ITEM_AP_S_BSIK.HWAE3 := vCursor.HWAE3 ; -- Obrigat�rio(N) - Moeda local 3
        tpOPEN_ITEM_AP_S_BSIK.DMBE3 := vCursor.DMBE3 ; -- Obrigat�rio(N) - Montante na moeda local 3
        tpOPEN_ITEM_AP_S_BSIK.MWSKZ := vCursor.MWSKZ ; -- Obrigat�rio(N) - C�digo de Imposto
        tpOPEN_ITEM_AP_S_BSIK.ZTERM := substr(vCursor.ZTERM,1,80) ; -- Obrigat�rio(N) - Termos de pagamento
        tpOPEN_ITEM_AP_S_BSIK.ZFBDT := nvl(vCursor.ZFBDT,sysdate) ; -- Obrigat�rio(N) - Data base
        tpOPEN_ITEM_AP_S_BSIK.ZLSCH := vCursor.ZLSCH ; -- Obrigat�rio(N) - M�todo de pagamento
        tpOPEN_ITEM_AP_S_BSIK.ZLSPR := vCursor.ZLSPR ; -- Obrigat�rio(N) - Bloqueio de pagamento
        tpOPEN_ITEM_AP_S_BSIK.PRCTR := vCursor.PRCTR ; -- Obrigat�rio(N) - Centro de lucro
                                                         
        Begin 
           If ( nvl(tpOPEN_ITEM_AP_S_BSIK.LIFNR,'n') <> 'n' ) and ( vCursor.WRBTR > 0 ) Then                         
              INSERT INTO MIGDV.OPEN_ITEM_AP_S_BSIK VALUES tpOPEN_ITEM_AP_S_BSIK;
              commit;
           End If;
        Exception
          When Others Then
       vErro := sqlerrm;
       rollback;
       insert into tdvadm.t_glb_sql values (vErro,
                                            sysdate,
                                            'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                            'SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS - Titulo ' || vCursor.BLART || '-' || vCursor.XBLNR);
                commit;
          End;

        
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Documentos contas pagar inserido com sucesso';        
        
    END LOOP;
  
end SP_SAP_INSERE_CONTAS_PAGAR_DOCUMENTOS;

-- Insere Impostos do documento Contas Pagar
procedure SP_SAP_INSERE_CONTAS_PAGAR_IMPOSTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
vIdentificadorCompanhia number;                                        
tpOPEN_ITEM_AP_S_BSET MIGDV.OPEN_ITEM_AP_S_BSET%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA N�O EST� DEFINIDO */
      SELECT *             
      FROM MIGDV.OPEN_ITEM_AP_S_BSET C
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
        for vCursor2 in (
            select C.BUKRS
              INTO vIdentificadorCompanhia
            FROM MIGDV.OPEN_ITEM_AP_S_BSET C
            order by to_number(C.BUKRS) desc
          )
          loop
            vIdentificadorCompanhia := vCursor2.BUKRS;
            exit;
          end loop;
          
        vIdentificadorCompanhia := nvl(vIdentificadorCompanhia, 0)+1;
        
        tpOPEN_ITEM_AP_S_BSET.BUKRS := vIdentificadorCompanhia; -- Obrigat�rio(S) - C�digo da companhia* 
        tpOPEN_ITEM_AP_S_BSET.XBLNR := ' '; -- Obrigat�rio(S) - N�mero do documento de refer�ncia *
        tpOPEN_ITEM_AP_S_BSET.LIFNR := ' '; -- Obrigat�rio(S) - Identificador do Fornecedor*
        tpOPEN_ITEM_AP_S_BSET.BUZEI := ' '; -- Obrigat�rio(S) - N�mero do item de linha de imposto *
        tpOPEN_ITEM_AP_S_BSET.HKONT := ' '; -- Obrigat�rio(S) - Conta fiscal *
        tpOPEN_ITEM_AP_S_BSET.GKONT2 := ' '; -- Obrigat�rio(S) - Conta do Raz�o para Compensa��o
        tpOPEN_ITEM_AP_S_BSET.MWSKZ := ' '; -- Obrigat�rio(S) - C�digo de Imposto*
        tpOPEN_ITEM_AP_S_BSET.FWBAS := ' '; -- Obrigat�rio(S) - Montante base do imposto - Moeda do documento
        tpOPEN_ITEM_AP_S_BSET.FWSTE := ' '; -- Obrigat�rio(S) - Valor do imposto  - moeda do documento
        tpOPEN_ITEM_AP_S_BSET.HWBAS := ' '; -- Obrigat�rio(N) - Montante base do imposto - moeda local 
        tpOPEN_ITEM_AP_S_BSET.HWSTE := ' '; -- Obrigat�rio(N) - Valor do imposto - moeda local 
        tpOPEN_ITEM_AP_S_BSET.H2BAS := ' '; -- Obrigat�rio(N) - Montante base do imposto - moeda local 2
        tpOPEN_ITEM_AP_S_BSET.H2STE := ' '; -- Obrigat�rio(N) - Valor do imposto - moeda local 2
        tpOPEN_ITEM_AP_S_BSET.H3BAS := ' '; -- Obrigat�rio(N) - Montante base do imposto - moeda local 3
        tpOPEN_ITEM_AP_S_BSET.H3STE := ' '; -- Obrigat�rio(N) - Valor do imposto - moeda local 3
                                                         
        INSERT INTO MIGDV.OPEN_ITEM_AP_S_BSET VALUES tpOPEN_ITEM_AP_S_BSET;
        
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Impostos documentos contas a pagar inserido com sucesso';        
        
    END LOOP;
  
end SP_SAP_INSERE_CONTAS_PAGAR_IMPOSTOS;
                                                 
-- Insere Impostos Retido do documento Contas Pagar
procedure SP_SAP_INSERE_CONTAS_PAGAR_IMPOSTOS_RETIDO(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
vIdentificadorCompanhia number;                                        
tpOPEN_ITEM_AP_S_WITH_ITEM MIGDV.OPEN_ITEM_AP_S_WITH_ITEM%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA N�O EST� DEFINIDO */
      SELECT *             
      FROM MIGDV.OPEN_ITEM_AP_S_WITH_ITEM C
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
        for vCursor2 in (
            select C.BUKRS
              INTO vIdentificadorCompanhia
            FROM MIGDV.OPEN_ITEM_AP_S_WITH_ITEM C
            order by to_number(C.BUKRS) desc
          )
          loop
            vIdentificadorCompanhia := vCursor2.BUKRS;
            exit;
          end loop;
          
        vIdentificadorCompanhia := nvl(vIdentificadorCompanhia, 0)+1;
        
        tpOPEN_ITEM_AP_S_WITH_ITEM.BUKRS      := vIdentificadorCompanhia; -- Obrigat�rio(S) - C�digo da companhia* 
        tpOPEN_ITEM_AP_S_WITH_ITEM.XBLNR      := ' '; -- Obrigat�rio(S) - N�mero do documento de refer�ncia *
        tpOPEN_ITEM_AP_S_WITH_ITEM.LIFNR      := ' '; -- Obrigat�rio(S) - Identificador do Fornecedor*
        tpOPEN_ITEM_AP_S_WITH_ITEM.WT_TYPE    := ' '; -- Obrigat�rio(S) - Tipo de imposto retido na fonte *
        tpOPEN_ITEM_AP_S_WITH_ITEM.WT_CODE    := ' '; -- Obrigat�rio(N) - C�digo do imposto retido na fonte
        tpOPEN_ITEM_AP_S_WITH_ITEM.BAS_AMT_TC := ' '; -- Obrigat�rio(S) - Montante base do imposto retido na fonte - moeda do documento
        tpOPEN_ITEM_AP_S_WITH_ITEM.MAN_AMT_TC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda do documento
        tpOPEN_ITEM_AP_S_WITH_ITEM.AWH_AMT_TC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda do documento 
        tpOPEN_ITEM_AP_S_WITH_ITEM.BAS_AMT_LC := ' '; -- Obrigat�rio(N) - Montante base do imposto retido na fonte - moeda local
        tpOPEN_ITEM_AP_S_WITH_ITEM.MAN_AMT_LC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda local
        tpOPEN_ITEM_AP_S_WITH_ITEM.AWH_AMT_LC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda local
        tpOPEN_ITEM_AP_S_WITH_ITEM.BAS_AMT_L2 := ' '; -- Obrigat�rio(N) - Montante base do imposto retido na fonte - moeda local 2
        tpOPEN_ITEM_AP_S_WITH_ITEM.MAN_AMT_L2 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda local 2
        tpOPEN_ITEM_AP_S_WITH_ITEM.AWH_AMT_L2 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda local 2
        tpOPEN_ITEM_AP_S_WITH_ITEM.BAS_AMT_L3 := ' '; -- Obrigat�rio(N) - Montante base do imposto retido na fonte - moeda local 3
        tpOPEN_ITEM_AP_S_WITH_ITEM.MAN_AMT_L3 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda local 3
        tpOPEN_ITEM_AP_S_WITH_ITEM.AWH_AMT_L3 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda local 3
                                                         
        INSERT INTO MIGDV.OPEN_ITEM_AP_S_WITH_ITEM VALUES tpOPEN_ITEM_AP_S_WITH_ITEM;
        
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Impostos retidos documentos contas a pagar inserido com sucesso';        
        
    END LOOP;
  
end SP_SAP_INSERE_CONTAS_PAGAR_IMPOSTOS_RETIDO;

-- Insere Documentos Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
vIdentificadorCompanhia number;                                        
tpOPEN_ITEM_AR_S_BSID MIGDV.OPEN_ITEM_AR_S_BSID%ROWTYPE;                                        
tpGL_BALANCES_S_BSIS  migdv.gl_balances_s_bsis%rowtype;

begin
    FOR vCursor IN (select *
                    from migdv.v_contaareceber )
    LOOP
         
        tpOPEN_ITEM_AR_S_BSID.BUKRS := vCursor.BUKRS ; -- Obrigat�rio(S) - C�digo da companhia*
        tpOPEN_ITEM_AR_S_BSID.XBLNR := vCursor.XBLNR ; -- Obrigat�rio(S) - N�mero do documento de refer�ncia *
        tpOPEN_ITEM_AR_S_BSID.KUNNR := migdv.pkg_migracao_sap2.fn_busca_codigoSAP(vCursor.glb_cliente_cgccpfcodigo,'CLI') ; -- Obrigat�rio(S) - Identificador do Cliente
        tpOPEN_ITEM_AR_S_BSID.GKONT := vCursor.GKONT ; -- Obrigat�rio(S) - Conta de compensa��o *
        tpOPEN_ITEM_AR_S_BSID.BLART := vCursor.BLART ; -- Obrigat�rio(S) - Tipo de documento*
        tpOPEN_ITEM_AR_S_BSID.BLDAT := vCursor.BLDAT ; -- Obrigat�rio(S) - Data do documento* 
        tpOPEN_ITEM_AR_S_BSID.BUDAT := vCursor.BUDAT ; -- Obrigat�rio(S) - Data de postagem*
        tpOPEN_ITEM_AR_S_BSID.BKTXT := vCursor.BKTXT ; -- Obrigat�rio(N) - Texto do cabe�alho
        tpOPEN_ITEM_AR_S_BSID.SGTXT := vCursor.SGTXT ; -- Obrigat�rio(N) - Texto do item
        tpOPEN_ITEM_AR_S_BSID.WAERS := vCursor.WAERS ; -- Obrigat�rio(S) - Moeda do Documento
        tpOPEN_ITEM_AR_S_BSID.WRBTR := vCursor.WRBTR ; -- Obrigat�rio(S) - Montante na moeda do documento
        tpOPEN_ITEM_AR_S_BSID.HWAER := vCursor.HWAER ; -- Obrigat�rio(S) - Moeda local*
        tpOPEN_ITEM_AR_S_BSID.DMBTR := vCursor.DMBTR ; -- Obrigat�rio(S) - Montante na moeda local
        tpOPEN_ITEM_AR_S_BSID.HWAE2 := vCursor.HWAE2 ; -- Obrigat�rio(N) - Moeda local 2
        tpOPEN_ITEM_AR_S_BSID.DMBE2 := vCursor.DMBE2 ; -- Obrigat�rio(N) - Montante na moeda local 2
        tpOPEN_ITEM_AR_S_BSID.HWAE3 := vCursor.HWAE3 ; -- Obrigat�rio(N) - Moeda local 3
        tpOPEN_ITEM_AR_S_BSID.DMBE3 := vCursor.DMBE3 ; -- Obrigat�rio(N) - Montante na moeda local 3
        tpOPEN_ITEM_AR_S_BSID.MWSKZ := vCursor.MWSKZ ; -- Obrigat�rio(N) - C�digo de Imposto
        tpOPEN_ITEM_AR_S_BSID.ZTERM := substr(vCursor.ZTERM,1,80) ; -- Obrigat�rio(N) - Termos de pagamento
        tpOPEN_ITEM_AR_S_BSID.ZFBDT := nvl(vCursor.ZFBDT,sysdate) ; -- Obrigat�rio(N) - Data base
        tpOPEN_ITEM_AR_S_BSID.ZLSCH := vCursor.ZLSCH ; -- Obrigat�rio(N) - M�todo de pagamento
        tpOPEN_ITEM_AR_S_BSID.ZLSPR := vCursor.ZLSPR ; -- Obrigat�rio(N) - Bloqueio de pagamento
        tpOPEN_ITEM_AR_S_BSID.PRCTR := vCursor.PRCTR ; -- Obrigat�rio(N) - Centro de lucro
        
        Begin 
           If ( nvl(trim(tpOPEN_ITEM_AR_S_BSID.KUNNR),'n') <> 'n' ) and ( vCursor.WRBTR > 0 )  Then                         
              INSERT INTO MIGDV.OPEN_ITEM_AR_S_BSID VALUES tpOPEN_ITEM_AR_S_BSID;
              commit;
           End IF;
        Exception
          When Others Then
       vErro := sqlerrm;
       rollback;
       insert into tdvadm.t_glb_sql values (vErro,
                                            sysdate,
                                            'PKG_MIGRACAO_SAP ' || to_char(sysdate,'YYYYMMDDHH24MI'),
                                            'SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS - Titulo ' || vCursor.BLART || '-' || vCursor.XBLNR);
             commit;
          End;


        tpGL_BALANCES_S_BSIS.BLART := vCursor.BLART;  -- Obrigat�rio(S) - Tipo de documento*
        tpGL_BALANCES_S_BSIS.BUKRS := vCursor.BUKRS;  -- Obrigat�rio(S) - C�digo da companhia*
        tpGL_BALANCES_S_BSIS.XBLNR := vCursor.XBLNR;  -- Obrigat�rio(S) - N�mero do documento de refer�ncia *
        tpGL_BALANCES_S_BSIS.DOCLN := ' ';            -- Obrigat�rio(N) -N�mero do item do documento
        tpGL_BALANCES_S_BSIS.HKONT := vCursor.GKONT;  -- Obrigat�rio(S) - Conta GL*
        tpGL_BALANCES_S_BSIS.GKONT := vCursor.GKONT;  -- Obrigat�rio(S) - Compensar conta do Raz�o *
        tpGL_BALANCES_S_BSIS.BLDAT := vCursor.BLDAT;  -- Obrigat�rio(S) - Data do documento*
        tpGL_BALANCES_S_BSIS.BUDAT := vCursor.BUDAT;  -- Obrigat�rio(S) - Data de postagem*
        tpGL_BALANCES_S_BSIS.BKTXT := vCursor.BKTXT;  -- Obrigat�rio(N) - Texto do cabe�alho
        tpGL_BALANCES_S_BSIS.SGTXT := vCursor.SGTXT;  -- Obrigat�rio(N) - Texto do item
        tpGL_BALANCES_S_BSIS.WRBTR := vCursor.WRBTR;  -- Obrigat�rio(S) - Valor em moeda do documento * 
        tpGL_BALANCES_S_BSIS.DMBTR := vCursor.Saldo;  -- Obrigat�rio(S) - Valor em moeda local *
        tpGL_BALANCES_S_BSIS.FWBAS := vCursor.Saldo;  -- Obrigat�rio(N) - Montante base do imposto na moeda do documento
        tpGL_BALANCES_S_BSIS.HWBAS := vCursor.Saldo;  -- Obrigat�rio(N) - Montante base do imposto na moeda local
        tpGL_BALANCES_S_BSIS.WAERS := vCursor.WAERS;  -- Obrigat�rio(S) - Moeda do documento *
        tpGL_BALANCES_S_BSIS.HWAER := vCursor.WAERS;  -- Obrigat�rio(S) - Moeda local*
        tpGL_BALANCES_S_BSIS.MWSKZ := ' ';            -- Obrigat�rio(N) - C�digo de Imposto
        tpGL_BALANCES_S_BSIS.TXJCD := ' ';            -- Obrigat�rio(N) - Jurisdi��o Fiscal
        tpGL_BALANCES_S_BSIS.KOSTL := ' ';            -- Obrigat�rio(N) - Centro de custo
        tpGL_BALANCES_S_BSIS.ZUONR := ' ';            -- Obrigat�rio(N) - N�mero da tarefa
        tpGL_BALANCES_S_BSIS.RMVCT := trunc(sysdate); -- Obrigat�rio(N) - Tipo de transa��o
        tpGL_BALANCES_S_BSIS.VALUT := ' ';            -- Obrigat�rio(N) - Data do valor
        tpGL_BALANCES_S_BSIS.HBKID := ' ';            -- Obrigat�rio(N) - Tecla de Atalho para o Banco
                                                         
        Begin 
           If ( nvl(trim(tpOPEN_ITEM_AR_S_BSID.KUNNR),'n') <> 'n' ) and ( vCursor.WRBTR > 0 )  Then                         
              INSERT INTO MIGDV.GL_BALANCES_S_BSIS VALUES tpGL_BALANCES_S_BSIS;
              commit;
           End If;
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
            
          
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Documentos contas a receber inserido com sucesso';        
        
    END LOOP;
  
end SP_SAP_INSERE_CONTAS_RECEBER_DOCUMENTOS;


-- Insere Impostos do documento Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_IMPOSTOS(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
vIdentificadorCompanhia number;                                        
tpOPEN_ITEM_AR_S_BSET MIGDV.OPEN_ITEM_AR_S_BSET%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA N�O EST� DEFINIDO */
      SELECT *             
      FROM MIGDV.OPEN_ITEM_AR_S_BSET C
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
        for vCursor2 in (
            select C.BUKRS
              INTO vIdentificadorCompanhia
            FROM MIGDV.OPEN_ITEM_AR_S_BSET C
            order by to_number(C.BUKRS) desc
          )
          loop
            vIdentificadorCompanhia := vCursor2.BUKRS;
            exit;
          end loop;
          
        vIdentificadorCompanhia := nvl(vIdentificadorCompanhia, 0)+1;
        
        tpOPEN_ITEM_AR_S_BSET.BUKRS  := vIdentificadorCompanhia; -- Obrigat�rio(S) - C�digo da companhia* 
        tpOPEN_ITEM_AR_S_BSET.XBLNR  := ' '; -- Obrigat�rio(S) - N�mero do documento de refer�ncia *
        tpOPEN_ITEM_AR_S_BSET.KUNNR  := ' '; -- Obrigat�rio(S) - Identificador do Cliente
        tpOPEN_ITEM_AR_S_BSET.BUZEI  := ' '; -- Obrigat�rio(S) - N�mero do item de linha de imposto *
        tpOPEN_ITEM_AR_S_BSET.HKONT  := ' '; -- Obrigat�rio(S) - Conta fiscal *
        tpOPEN_ITEM_AR_S_BSET.GKONT2 := ' '; -- Obrigat�rio(S) - Conta do Raz�o para Compensa��o
        tpOPEN_ITEM_AR_S_BSET.MWSKZ  := ' '; -- Obrigat�rio(S) - C�digo de Imposto*
        tpOPEN_ITEM_AR_S_BSET.FWBAS  := ' '; -- Obrigat�rio(S) - Montante base do imposto - Moeda do documento
        tpOPEN_ITEM_AR_S_BSET.FWSTE  := ' '; -- Obrigat�rio(S) - Valor do imposto  - moeda do documento
        tpOPEN_ITEM_AR_S_BSET.HWBAS  := ' '; -- Obrigat�rio(N) - Montante base do imposto - moeda local 
        tpOPEN_ITEM_AR_S_BSET.HWSTE  := ' '; -- Obrigat�rio(N) - Valor do imposto - moeda local 
        tpOPEN_ITEM_AR_S_BSET.H2BAS  := ' '; -- Obrigat�rio(N) - Montante base do imposto - moeda local 2
        tpOPEN_ITEM_AR_S_BSET.H2STE  := ' '; -- Obrigat�rio(N) - Valor do imposto - moeda local 2
        tpOPEN_ITEM_AR_S_BSET.H3BAS  := ' '; -- Obrigat�rio(N) - Montante base do imposto - moeda local 3
        tpOPEN_ITEM_AR_S_BSET.H3STE  := ' '; -- Obrigat�rio(N) - Valor do imposto - moeda local 3
                                                         
        INSERT INTO MIGDV.OPEN_ITEM_AR_S_BSET VALUES tpOPEN_ITEM_AR_S_BSET;
        
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Impostos documentos contas a receber inserido com sucesso';        
        
    END LOOP;
end SP_SAP_INSERE_CONTAS_RECEBER_IMPOSTOS;

                                                 
-- Insere Impostos Retidos do documento Contas Receber
procedure SP_SAP_INSERE_CONTAS_RECEBER_IMPOSTOS_RETIDO(PIDCOMPANHIA IN CHAR,
                                                PRESULTADO OUT Char,
                                                PMENSAGEM OUT VARCHAR2) is
vIdentificadorCompanhia number;                                        
tpOPEN_ITEM_AR_S_WITH_ITEM MIGDV.OPEN_ITEM_AR_S_WITH_ITEM%ROWTYPE;                                        
begin
    FOR vCursor IN (   
      /*SELECT AINDA N�O EST� DEFINIDO */
      SELECT *             
      FROM MIGDV.OPEN_ITEM_AR_S_WITH_ITEM C
    )
    LOOP
        --SELECT MAX(to_number(C.KUNNR)) 
        --  INTO vIdentificadorCli
        --FROM MIGDV.CUSTOMER_S_CUST_GEN C;
        
        for vCursor2 in (
            select C.BUKRS
              INTO vIdentificadorCompanhia
            FROM MIGDV.OPEN_ITEM_AR_S_WITH_ITEM C
            order by to_number(C.BUKRS) desc
          )
          loop
            vIdentificadorCompanhia := vCursor2.BUKRS;
            exit;
          end loop;
          
        vIdentificadorCompanhia := nvl(vIdentificadorCompanhia, 0)+1;
        
        tpOPEN_ITEM_AR_S_WITH_ITEM.BUKRS      := vIdentificadorCompanhia; -- Obrigat�rio(S) - C�digo da companhia* 
        tpOPEN_ITEM_AR_S_WITH_ITEM.XBLNR      := ' '; -- Obrigat�rio(S) - N�mero do documento de refer�ncia *
        tpOPEN_ITEM_AR_S_WITH_ITEM.KUNNR      := ' '; -- Obrigat�rio(S) - Identificador do Cliente
        tpOPEN_ITEM_AR_S_WITH_ITEM.WT_TYPE    := ' '; -- Obrigat�rio(S) - Tipo de imposto retido na fonte *
        tpOPEN_ITEM_AR_S_WITH_ITEM.WT_CODE    := ' '; -- Obrigat�rio(N) - C�digo do imposto retido na fonte
        tpOPEN_ITEM_AR_S_WITH_ITEM.BAS_AMT_TC := ' '; -- Obrigat�rio(S) - Montante base do imposto retido na fonte - moeda do documento
        tpOPEN_ITEM_AR_S_WITH_ITEM.MAN_AMT_TC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda do documento
        tpOPEN_ITEM_AR_S_WITH_ITEM.AWH_AMT_TC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda do documento 
        tpOPEN_ITEM_AR_S_WITH_ITEM.BAS_AMT_LC := ' '; -- Obrigat�rio(N) - Montante base do imposto retido na fonte - moeda local
        tpOPEN_ITEM_AR_S_WITH_ITEM.MAN_AMT_LC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda local
        tpOPEN_ITEM_AR_S_WITH_ITEM.AWH_AMT_LC := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda local
        tpOPEN_ITEM_AR_S_WITH_ITEM.BAS_AMT_L2 := ' '; -- Obrigat�rio(N) - Montante base do imposto retido na fonte - moeda local 2
        tpOPEN_ITEM_AR_S_WITH_ITEM.MAN_AMT_L2 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda local 2
        tpOPEN_ITEM_AR_S_WITH_ITEM.AWH_AMT_L2 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda local 2
        tpOPEN_ITEM_AR_S_WITH_ITEM.BAS_AMT_L3 := ' '; -- Obrigat�rio(N) - Montante base do imposto retido na fonte - moeda local 3
        tpOPEN_ITEM_AR_S_WITH_ITEM.MAN_AMT_L3 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte inserido manualmente - moeda local 3
        tpOPEN_ITEM_AR_S_WITH_ITEM.AWH_AMT_L3 := ' '; -- Obrigat�rio(N) - Valor do imposto retido na fonte j� retido - moeda local 3
                                                         
        INSERT INTO MIGDV.OPEN_ITEM_AR_S_WITH_ITEM VALUES tpOPEN_ITEM_AR_S_WITH_ITEM;
        
        COMMIT;
        
        PRESULTADO := 'N';
        PMENSAGEM  := 'Impostos retidos documentos contas a receber inserido com sucesso';        
        
    END LOOP;
end SP_SAP_INSERE_CONTAS_RECEBER_IMPOSTOS_RETIDO;


END pkg_migracao_sap2;
/
