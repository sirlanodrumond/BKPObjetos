create or replace package migdv.pkg_migracao_sap2 is


   Function Get_CPFCNPJ_Parceiro(pCodParc in varchar2,pTipoParcTDV in varchar2) Return char;

   Function Get_TIPO_PARCEIRO(pCodParc in varchar2,pTipoParc in varchar2) Return char;

   Procedure SP_BWTDV_Integra_BP;

   Procedure SP_BWTDV_integra_CTE;

end pkg_migracao_sap2;
/
CREATE OR REPLACE PACKAGE BODY MIGDV.pkg_migracao_sap2 IS

/*
-- Add/modify columns 
alter table T_CAR_PROPRIETARIO add car_proprietario_codbp varchar2(20);
-- Add comments to the columns 
comment on column T_CAR_PROPRIETARIO.car_proprietario_codbp
  is 'Codigo BP do Proprietario';

-- Add/modify columns 
alter table T_CAR_CARRETEIRO add car_carreteiro_codbp varchar2(20);
-- Add comments to the columns 
comment on column T_CAR_CARRETEIRO.car_carreteiro_codbp
  is 'Codigo BP do Carreteiro';

-- Add/modify columns 
alter table T_FRT_MOTORISTA add frt_motorista_codbp varchar2(20);
-- Add comments to the columns 
comment on column T_FRT_MOTORISTA.frt_motorista_codbp
  is 'Codigo BP do Motorista';
  
-- Add/modify columns 
alter table T_GLB_CLIENTE add glb_cliente_codbp varchar2(20);
-- Add comments to the columns 
comment on column T_GLB_CLIENTE.glb_cliente_codbp
  is 'Codigo BP do Cliente';
alter table T_GLB_CLIENTE modify glb_grupoeconomico_codigoseg null;

-- Add/modify columns 
alter table tdvadm.T_GLB_CLIEND add glb_cliend_codbp varchar2(20);
-- Add comments to the columns 
comment on column T_GLB_CLIEND.glb_cliend_codbp
  is 'Codigo BP do Cliente no tipo';


-- Add/modify columns 
alter table T_CON_CONHECIMENTO add con_conhecimento_docnum varchar2(20);
-- Add comments to the columns 
comment on column T_CON_CONHECIMENTO.con_conhecimento_docnum
  is 'Numero do Documento SAP';

-- Drop indexes 
drop index FK_CLIEND_LOCALIDADEIE;
-- Enable/Disable primary, unique and foreign key constraints 
alter table T_GLB_CLIEND
  disable constraint FK_CLIEND_LOCALIDADE;
alter table T_GLB_CLIEND
  disable constraint FK_CLIEND_LOCALIDADEIE;
  
*/

Function Get_CPFCNPJ_Parceiro(pCodParc in varchar2,pTipoParcTDV in varchar2) Return char as
   vAuxiliar integer;
   CPF_CNPJ  varchar2(20);   
Begin

    if pTipoParcTDV = 'Cliente' Then
       Begin
          select cl.glb_cliente_cgccpfcodigo,count(*)
            into CPF_CNPJ,
                 vAuxiliar
          from tdvadm.t_glb_cliente cl
          where cl.glb_cliente_codbp = pCodParc
          group by cl.glb_cliente_cgccpfcodigo;
       Exception
          When NO_DATA_FOUND Then
             vAuxiliar := 0;
       End;
       If vAuxiliar > 0 Then
          Return CPF_CNPJ;
       Else
          RETURN pCodParc;
       End If;
    Else
       RETURN 'TpERRADO';   
    End If;   
    
End Get_CPFCNPJ_Parceiro;

Function Get_TIPO_PARCEIRO(pCodParc in varchar2,pTipoParc in varchar2) Return char as
   vAuxiliar integer;
   CPF_CNPJ  varchar2(15);   
Begin
   If pTipoParc Is null Then
      select count(*)
        into vAuxiliar
      From migdv.v_sap_cteparceiro p
      where p.COD_PARCEIRO = pCodParc;
      If vAuxiliar > 0 Then
         Return 'Cliente';
      Else
         Begin
            select bp.CPF_CNPJ
              into CPF_CNPJ
            from migdv.v_sap_bp bp 
            where bp.COD_PARCEIRO = pCodParc;
            If substr(CPF_CNPJ,1,8) = '61139432' Then
               Return 'Filial';
            Else
               Return 'Verificar';
            End If;
         Exception
            When OTHERS Then
               Return 'ERRO'; 
            End;
         Return 'Verificar';
      End If;   
   Else
      Return pTipoParc;
   End If;
End Get_TIPO_PARCEIRO;

Procedure SP_BWTDV_Integra_BP
   As
  i integer;
  TpProprietario tdvadm.t_car_proprietario%rowtype;
  TpCarreteiro   tdvadm.t_car_carreteiro%rowtype;
  TpFrota        tdvadm.t_frt_motorista%rowtype;
  TpCliente      tdvadm.t_glb_cliente%rowType;
  TpCliEnd   tdvadm.t_glb_cliend%rowType;
  TpClienteCont  tdvadm.t_glb_clicont%rowType;
    
begin
  -- Test statements here
  
  For c_msg in (SELECT x.* 
                FROM MIGDV.V_SAP_BP x
                where x.NOME_PARCEIRO is not null
                order by x.TIPO_PARCEIRO )
  Loop
     If ( c_msg.cpf_cnpj is Not null ) and
        ( tdvadm.f_enumerico(c_msg.cod_parceiro)  = 'S' ) Then
        Begin
           If ( ( c_msg.tipo_parceiro = 'Agregado' ) or ( c_msg.tipo_parceiro = 'Terceiros/Dedicado' ) ) Then

              TpProprietario.Car_Proprietario_Cgccpfcodigo := c_msg.cpf_cnpj;
              TpProprietario.Car_Proprietario_Razaosocial  := c_msg.nome_parceiro;
              TpProprietario.Car_Proprietario_Telefone     := trim(substr(c_msg.telefone,1,20));
              TpProprietario.Car_Proprietario_Endereco     := c_msg.rua;
              TpProprietario.Car_Proprietario_Numero       := trim(substr(c_msg.numero,1,5));
              TpProprietario.Car_Proprietario_Complemento  := null; --c_msg.;
              TpProprietario.Car_Proprietario_Bairro       := c_msg.bairro;
              TpProprietario.Car_Proprietario_Cidade       := c_msg.cidade;
              TpProprietario.Glb_Estadoproprietario_Codigo := substr(c_msg.uf,1,2);
              TpProprietario.Car_Proprietario_Cep          := trim(replace(c_msg.cep,'-',''));
              TpProprietario.Car_Proprietario_Dner_Codigo  := null; --c_msg.;
              TpProprietario.Car_Proprietario_Dtcadastro   := nvl(to_date(c_msg.data_cadastro,'yyyymmdd'),to_char(sysdate,'DD/MM/YYYY'));
              TpProprietario.Car_Proprietario_Bip          := null; --c_msg.;
              TpProprietario.t_Car_Tipopessoa              := c_msg.tppessoa;
              TpProprietario.Car_Proprietario_Tipopessoa   := c_msg.tppessoa; 
              TpProprietario.Car_Proprietario_Celular      := trim(substr(c_msg.telefone,1,20));
              TpProprietario.Car_Proprietario_User         := c_msg.user_cadastro;
              TpProprietario.Car_Proprietario_Rotauser     := null; --c_msg.;
              TpProprietario.Car_Proprietario_Filiacao_Mae := null; -- PRECISO
              TpProprietario.Car_Proprietario_Rgcodigo     := null; --c_msg.;
              TpProprietario.Car_Proprietario_Rgemissao    := null; --c_msg.;
              TpProprietario.Car_Proprietario_Rgcidade     := null; --c_msg.;
              TpProprietario.Glb_Estadorg_Codigo           := null; --c_msg.;
              TpProprietario.Car_Proprietario_Contato      := null; -- PRECISO
              TpProprietario.Car_Proprietario_Telefonecom  := null; --c_msg.; 
              TpProprietario.Car_Proprietario_Contatocom   := null; --c_msg.;
              TpProprietario.Car_Proprietario_Rntrc        := null; -- PRECISO
              TpProprietario.Car_Proprietario_Classantt    := null; -- PRECISO
              TpProprietario.Car_Proprietario_Classeqp     := null; -- PRECISO
              TpProprietario.Car_Proprietario_Classdt      := null; -- PRECISO
              TpProprietario.Car_Proprietario_Rntrcdtval   := null; -- PRECISO
              TpProprietario.Car_Proprietario_Codibge      := substr(c_msg.domicilio_fiscal,4,7);
              TpProprietario.Car_Proprntrcst_Codigo        := null; --c_msg.;
              TpProprietario.Car_Proprietario_Dtincialded  := null; --c_msg.;
              TpProprietario.Car_Proprietario_Saldocc      := null; --c_msg.;
              If ( c_msg.tppessoa = 'J' ) Then
                 If c_msg.data_entrada_simples is null Then
                    TpProprietario.Car_Proprietario_Optsimples   := 'N';
                 Else
                    TpProprietario.Car_Proprietario_Optsimples   := 'S';
                 End If;
                 TpProprietario.Car_Proprietario_Ie           := nvl(c_msg.inscr_estadual,'ISENTO');
                 TpProprietario.Car_Proprietario_Datanasc     := null;
                 TpProprietario.Car_Proprietario_Inps_Codigo  := null;
              Else
                 TpProprietario.Car_Proprietario_Optsimples   := 'N';
                 TpProprietario.Car_Proprietario_Ie           := null;
                 TpProprietario.Car_Proprietario_Datanasc     := nvl(to_date(c_msg.data_nascimento,'yyyymmdd'),to_char(sysdate,'DD/MM/YYYY'));
                 TpProprietario.Car_Proprietario_Inps_Codigo  := null; -- PRECISO
              End If;   

              update tdvadm.t_car_proprietario x
                set x.car_proprietario_codbp        = TpProprietario.Car_Proprietario_Codbp,
                    x.car_proprietario_razaosocial  = TpProprietario.car_proprietario_razaosocial,
                    x.car_proprietario_telefone     = TpProprietario.car_proprietario_telefone,
                    x.car_proprietario_endereco     = TpProprietario.car_proprietario_endereco,
                    x.car_proprietario_bairro       = TpProprietario.car_proprietario_bairro,
                    x.car_proprietario_cidade       = TpProprietario.car_proprietario_cidade,
                    x.glb_estadoproprietario_codigo = TpProprietario.glb_estadoproprietario_codigo,
                    x.car_proprietario_cep          = TpProprietario.car_proprietario_cep,
                    x.car_proprietario_dner_codigo  = TpProprietario.car_proprietario_dner_codigo,
                    x.car_proprietario_inps_codigo  = TpProprietario.car_proprietario_inps_codigo,
                    x.car_proprietario_dtcadastro   = TpProprietario.car_proprietario_dtcadastro,
                    x.car_proprietario_bip          = TpProprietario.car_proprietario_bip,
                    x.t_car_tipopessoa              = TpProprietario.t_car_tipopessoa,
                    x.car_proprietario_tipopessoa   = TpProprietario.car_proprietario_tipopessoa,
                    x.car_proprietario_celular      = TpProprietario.car_proprietario_celular,
                    x.car_proprietario_user         = TpProprietario.car_proprietario_user,
                    x.car_proprietario_rotauser     = TpProprietario.car_proprietario_rotauser,
                    x.car_proprietario_datanasc     = TpProprietario.car_proprietario_datanasc,
                    x.car_proprietario_filiacao_mae = TpProprietario.car_proprietario_filiacao_mae,
                    x.car_proprietario_rgcodigo     = TpProprietario.car_proprietario_rgcodigo,
                    x.car_proprietario_rgemissao    = TpProprietario.car_proprietario_rgemissao,
                    x.car_proprietario_rgcidade     = TpProprietario.car_proprietario_rgcidade,
                    x.car_proprietario_contato      = TpProprietario.car_proprietario_contato,
                    x.car_proprietario_telefonecom  = TpProprietario.car_proprietario_telefonecom,
                    x.car_proprietario_contatocom   = TpProprietario.car_proprietario_contatocom,
                    x.glb_estadorg_codigo           = TpProprietario.glb_estadorg_codigo,
                    x.car_proprietario_rntrc        = TpProprietario.car_proprietario_rntrc,
                    x.car_proprietario_ie           = TpProprietario.car_proprietario_ie,
                    x.car_proprietario_classantt    = TpProprietario.car_proprietario_classantt,
                    x.car_proprietario_classeqp     = TpProprietario.car_proprietario_classeqp,
                    x.car_proprietario_classdt      = TpProprietario.car_proprietario_classdt,
                    x.car_proprietario_rntrcdtval   = TpProprietario.car_proprietario_rntrcdtval,
                    x.car_proprietario_codibge      = TpProprietario.car_proprietario_codibge,
                    x.car_proprietario_numero       = TpProprietario.car_proprietario_numero,
                    x.car_proprietario_complemento  = TpProprietario.car_proprietario_complemento,
                    x.car_proprntrcst_codigo        = TpProprietario.car_proprntrcst_codigo,
                    x.car_proprietario_dtincialded  = TpProprietario.car_proprietario_dtincialded,
                    x.car_proprietario_saldocc      = TpProprietario.car_proprietario_saldocc,
                    x.car_proprietario_optsimples   = TpProprietario.car_proprietario_optsimples
              where x.car_proprietario_cgccpfcodigo = TpProprietario.car_proprietario_cgccpfcodigo;
              If sql%rowcount = 0 Then
                 insert into tdvadm.t_car_proprietario values TpProprietario;
              End If;
           ElsIf  ( c_msg.tipo_parceiro = 'Compras / Vendas' )  Then
              If substr(c_msg.cpf_cnpj,1,3) <> '999' Then
                 TpCliente.Glb_Cliente_Nacional         := 'N';
              Else
                 TpCliente.Glb_Cliente_Nacional         := 'I';
              End If;
              TpCliente.Glb_Cliente_Cgccpfcodigo     := c_msg.cpf_cnpj;
              TpCliente.Glb_Cliente_Codbp            := c_msg.cod_parceiro;
              TpCliente.Glb_Cliente_Codbp            := c_msg.cod_parceiro;
              TpCliente.Glb_Cliente_Razaosocial      := c_msg.nome_parceiro;
              TpCliente.Glb_Vendfrete_Codigo         := null;
              TpCliente.Glb_Cliente_Tppessoa         := c_msg.tppessoa;
              TpCliente.Glb_Rota_Codigo              := null;
              TpCliente.Glb_Cliente_Situacao         := 'N';
              TpCliente.Glb_Cliente_Qtdtitvenc       := null; 
              TpCliente.Glb_Cliente_Vltotvenc        := null;
              TpCliente.Glb_Cliente_Prazomedvenc     := null; 
              TpCliente.Glb_Cliente_Prazomedpagto    := null;
              TpCliente.Glb_Cliente_Dtutlmov         := null; 
              TpCliente.Glb_Cliente_Dtcadastro       := nvl(to_date(c_msg.data_cadastro,'yyyymmdd'),to_char(sysdate,'DD/MM/YYYY'));
              TpCliente.Glb_Cliente_Obs              := '';
              TpCliente.Glb_Cliente_Opercad          := c_msg.user_cadastro; 
              TpCliente.Glb_Cliente_Operalt          := c_msg.user_modif;
              TpCliente.Glb_Cliente_Tpboleto         := null;
              TpCliente.Crp_Tpcarteria_Codigo        := null;
              TpCliente.Glb_Cliente_Diaatrazo        := null;
              TpCliente.Glb_Cliente_Classsac         := null;
              TpCliente.Glb_Cliente_Nfnafatura       := null;
              TpCliente.Glb_Banco_Numero             := null;
              TpCliente.Glb_Cliente_Controlanf       := null;
              TpCliente.Glb_Cliente_Tiporateio       := null;
              TpCliente.Glb_Cliente_Descinss         := 'N';
              TpCliente.Glb_Ramoatividade_Codigo     := '99'; -- PRECISO
              If c_msg.inscr_estadual is null Then
                 TpCliente.Glb_Cliente_Ieisento         := 'S';
              Else 
                 TpCliente.Glb_Cliente_Ieisento         := 'N';
              End IF;
              TpCliente.Glb_Cliente_Dtultmovsac      := null;
              TpCliente.Glb_Cliente_Dtultmovrem      := null;
              TpCliente.Glb_Cliente_Dtultmovdest     := null;
              TpCliente.Glb_Cliente_Tribisento       := null;
              TpCliente.Glb_Cliente_Regimeespvp      := null;
              TpCliente.Glb_Cliente_Dtalteracao      := null;
              TpCliente.Glb_Cliente_Agrupasepara     := null;
              TpCliente.Glb_Grupoeconomico_Codigoseg := '9999';
              TpCliente.Glb_Grupoeconomico_Codigo    := '9999'; -- PRECISO
              TpCliente.Glb_Cliente_Tipodesconto     := null;
              TpCliente.Glb_Cliente_Percdesconto     := null;
              TpCliente.Glb_Grupoeconomico_Codigoctb := null;
              TpCliente.Glb_Cliente_Emailcontrole    := c_msg.email;
              TpCliente.Arm_Armazem_Codigo           := null; 
              TpCliente.Glb_Cliente_Ctrcimg          := null;
              TpCliente.Glb_Cliente_Notaimg          := null;
              TpCliente.Glb_Cliente_Vlrlimite        := null;
              TpCliente.Glb_Cliente_Estiva           := null;
              TpCliente.Glb_Cliente_Cnae             := null; -- Preciso
              TpCliente.Glb_Cliente_Higienizado      := sysdate;
              TpCliente.Glb_Cliente_Exigecomprovante := null;
              TpCliente.Glb_Cliente_Issret           := null;
              TpCliente.Glb_Cliente_Fechacoleta      := null;
              TpCliente.Glb_Cliente_Vigencia         := null;
              TpCliente.Glb_Cliente_Flagverificaend  := null;
              TpCliente.Glb_Cliente_Estadia          := null;
              TpCliente.Glb_Cliente_Colreqaut        := null;
              TpCliente.Codigo_Usual                 := null;
              TpCliente.Arm_Armazem_Codigofca        := null;
              TpCliente.Glb_Cliente_Naocont          := null;

              If c_msg.data_entrada_simples is null Then
                 TpCliente.Glb_Cliente_Optsimples       := 'N';
              Else
                 TpCliente.Glb_Cliente_Optsimples       := 'S';
              End If;
              If ( c_msg.tppessoa = 'J' ) Then
                 TpCliente.Glb_Cliente_Ie               := nvl(c_msg.inscr_estadual,'ISENTO');
                 TpCliente.Glb_Cliente_Im               := null;
              Else
                 TpCliente.Glb_Cliente_Ie               := null;
                 TpCliente.Glb_Cliente_Im               := null;
              End If;   


              TpCliEnd.Glb_Cliente_Cgccpfcodigo := c_msg.cpf_cnpj;
              TpCliEnd.Glb_Cliend_Codbp         := c_msg.cod_parceiro;
              TpCliEnd.Glb_Tpcliend_Codigo      := 'E';
              TpCliEnd.Glb_Pais_Codigo          := 'BRA';  -- PRECISO
              TpCliEnd.Glb_Estado_Codigo        := c_msg.uf;
              TpCliEnd.Glb_Cliend_Endereco      := c_msg.rua;
              TpCliEnd.Glb_Cliend_Complemento   := c_msg.Bairro;
              TpCliEnd.Glb_Cliend_Cidade        := c_msg.cidade;
              TpCliEnd.Glb_Cep_Codigo           := trim(replace(c_msg.cep,'-',''));
              -- Ver quando nao existir
              TpCliEnd.Glb_Localidade_Codigo    := trim(replace(c_msg.cep,'-','')); 
              TpCliEnd.Glb_Cliend_Codcliente    := substr(c_msg.cod_parceiro,1,15); -- PRECISO
              TpCliEnd.Arm_Regiao_Codigo        := null; 
              TpCliEnd.Arm_Regiao_Metropolitana := null;
              TpCliEnd.Arm_Subregiao_Codigo     := null;
              TpCliEnd.Xml_Cep_Cvrd             := trim(replace(c_msg.cep,'-',''));
              TpCliEnd.Glb_Cliend_Email         := c_msg.email;
              TpCliEnd.Glb_Cliend_Latitude      := null;
              TpCliEnd.Glb_Cliend_Longitude     := null;
              TpCliEnd.Glb_Cliend_Logo          := null;
              TpCliEnd.Glb_Portaria_Id          := null;
              TpCliEnd.Glb_Cliend_Ie            := c_msg.inscr_estadual;
              TpCliEnd.Glb_Cliend_Im            := null;
              TpCliEnd.Glb_Cliend_Higienizado   := sysdate;
              TpCliEnd.Usu_Usuario_Criou        := c_msg.user_cadastro;
              TpCliEnd.Usu_Usuario_Alterou      := c_msg.user_modif;
              TpCliEnd.Glb_Cliend_Dtcriacao     := nvl(to_date(c_msg.data_cadastro,'yyyymmdd'),to_char(sysdate,'DD/MM/YYYY'));
              If c_msg.data_modif is null Then
                 TpCliEnd.Glb_Cliend_Dtalteracao   := null;
              Else
                 TpCliEnd.Glb_Cliend_Dtalteracao   := to_date(nvl(c_msg.data_modif,to_char(sysdate,'yyyymmdd')),'yyyymmdd');
              End If;
              -- Ver quando nao existir
              TpCliEnd.Glb_Localidade_Codigoie  := trim(replace(c_msg.cep,'-',''));
              TpCliEnd.Glb_Cliend_Numero        := null;
              TpCliEnd.Glb_Cliente_Cnpjaux      := null;

              update tdvadm.t_glb_cliente c
                set c.glb_cliente_codbp            = TpCliente.Glb_Cliente_Codbp           ,
                    c.glb_cliente_nacional         = TpCliente.glb_cliente_nacional        , 
                    c.glb_cliente_razaosocial      = TpCliente.glb_cliente_razaosocial     ,
                    c.glb_vendfrete_codigo         = TpCliente.glb_vendfrete_codigo        ,
                    c.glb_cliente_tppessoa         = TpCliente.glb_cliente_tppessoa        ,
                    c.glb_cliente_ie               = TpCliente.glb_cliente_ie              ,
                    c.glb_cliente_im               = TpCliente.glb_cliente_im              ,
                    c.glb_rota_codigo              = TpCliente.glb_rota_codigo             ,
                    c.glb_cliente_situacao         = TpCliente.glb_cliente_situacao        ,
                    c.glb_cliente_qtdtitvenc       = TpCliente.glb_cliente_qtdtitvenc      ,
                    c.glb_cliente_vltotvenc        = TpCliente.glb_cliente_vltotvenc       ,
                    c.glb_cliente_prazomedvenc     = TpCliente.glb_cliente_prazomedvenc    ,
                    c.glb_cliente_prazomedpagto    = TpCliente.glb_cliente_prazomedpagto   ,
                    c.glb_cliente_dtutlmov         = TpCliente.glb_cliente_dtutlmov        ,
                    c.glb_cliente_dtcadastro       = TpCliente.glb_cliente_dtcadastro      ,
                    c.glb_cliente_obs              = TpCliente.glb_cliente_obs             ,
                    c.glb_cliente_opercad          = TpCliente.glb_cliente_opercad         ,
                    c.glb_cliente_operalt          = TpCliente.glb_cliente_operalt         ,
                    c.glb_cliente_tpboleto         = TpCliente.glb_cliente_tpboleto        ,
                    c.crp_tpcarteria_codigo        = TpCliente.crp_tpcarteria_codigo       ,
                    c.glb_cliente_diaatrazo        = TpCliente.glb_cliente_diaatrazo       ,
                    c.glb_cliente_classsac         = TpCliente.glb_cliente_classsac        ,
                    c.glb_cliente_nfnafatura       = TpCliente.glb_cliente_nfnafatura      ,
                    c.glb_banco_numero             = TpCliente.glb_banco_numero            ,
                    c.glb_cliente_controlanf       = TpCliente.glb_cliente_controlanf      ,
                    c.glb_cliente_tiporateio       = TpCliente.glb_cliente_tiporateio      ,
                    c.glb_cliente_descinss         = TpCliente.glb_cliente_descinss        ,
                    c.glb_ramoatividade_codigo     = TpCliente.glb_ramoatividade_codigo    ,
                    c.glb_cliente_ieisento         = TpCliente.glb_cliente_ieisento        ,
                    c.glb_cliente_dtultmovsac      = TpCliente.glb_cliente_dtultmovsac     ,
                    c.glb_cliente_dtultmovrem      = TpCliente.glb_cliente_dtultmovrem     ,
                    c.glb_cliente_dtultmovdest     = TpCliente.glb_cliente_dtultmovdest    ,
                    c.glb_cliente_tribisento       = TpCliente.glb_cliente_tribisento      ,
                    c.glb_cliente_regimeespvp      = TpCliente.glb_cliente_regimeespvp     ,
                    c.glb_cliente_dtalteracao      = TpCliente.glb_cliente_dtalteracao     ,
                    c.glb_cliente_agrupasepara     = TpCliente.glb_cliente_agrupasepara    ,
                    c.glb_grupoeconomico_codigoseg = TpCliente.glb_grupoeconomico_codigoseg,
                    c.glb_grupoeconomico_codigo    = TpCliente.glb_grupoeconomico_codigo   ,
                    c.glb_cliente_tipodesconto     = TpCliente.glb_cliente_tipodesconto    ,
                    c.glb_cliente_percdesconto     = TpCliente.glb_cliente_percdesconto    ,
                    c.glb_grupoeconomico_codigoctb = TpCliente.glb_grupoeconomico_codigoctb,
                    c.glb_cliente_emailcontrole    = TpCliente.glb_cliente_emailcontrole   ,
                    c.arm_armazem_codigo           = TpCliente.arm_armazem_codigo          ,
                    c.glb_cliente_ctrcimg          = TpCliente.glb_cliente_ctrcimg         ,
                    c.glb_cliente_notaimg          = TpCliente.glb_cliente_notaimg         ,
                    c.glb_cliente_vlrlimite        = TpCliente.glb_cliente_vlrlimite       ,
                    c.glb_cliente_estiva           = TpCliente.glb_cliente_estiva          ,
                    c.glb_cliente_cnae             = TpCliente.glb_cliente_cnae            ,
                    c.glb_cliente_higienizado      = TpCliente.glb_cliente_higienizado     ,
                    c.glb_cliente_exigecomprovante = TpCliente.glb_cliente_exigecomprovante,
                    c.glb_cliente_issret           = TpCliente.glb_cliente_issret          ,
                    c.glb_cliente_fechacoleta      = TpCliente.glb_cliente_fechacoleta     ,
                    c.glb_cliente_vigencia         = TpCliente.glb_cliente_vigencia        ,
                    c.glb_cliente_flagverificaend  = TpCliente.glb_cliente_flagverificaend ,
                    c.glb_cliente_estadia          = TpCliente.glb_cliente_estadia         ,
                    c.glb_cliente_colreqaut        = TpCliente.glb_cliente_colreqaut       ,
                    c.codigo_usual                 = TpCliente.codigo_usual                ,
                    c.arm_armazem_codigofca        = TpCliente.arm_armazem_codigofca       ,
                    c.glb_cliente_naocont          = TpCliente.glb_cliente_naocont         ,
                    c.glb_cliente_optsimples       = TpCliente.glb_cliente_optsimples      
                 Where c.glb_cliente_cgccpfcodigo = TpCliente.Glb_Cliente_Cgccpfcodigo;
                 If sql%rowcount = 0 Then
                    insert into tdvadm.t_glb_cliente values TpCliente;
--                    dbms_output.put_line('Cliente - BP - ' || c_msg.cod_parceiro || ' - Inserido');
--                 Else
--                    dbms_output.put_line('Cliente - BP - ' || c_msg.cod_parceiro || ' - Atualizado');
                 End If; 

                 for i in 1..3
                 loop
                    -- Gravar tipos E / X / C
                    If i = 1 Then
                       TpCliEnd.Glb_Tpcliend_Codigo := 'E';
                    ElsIf i = 2 Then
                       TpCliEnd.Glb_Tpcliend_Codigo := 'X';
                    ElsIf i = 3 Then
                       TpCliEnd.Glb_Tpcliend_Codigo := 'C';
                    End If;                 
                    
                    If c_msg.cod_parceiro = '1000000001' Then
                       c_msg.cod_parceiro := c_msg.cod_parceiro;
                    End If;
                    update tdvadm.t_glb_cliend ce
                      set ce.glb_cliend_codbp         = TpCliEnd.glb_cliend_codbp         ,
                          ce.glb_pais_codigo          = TpCliEnd.glb_pais_codigo          ,
                          ce.glb_estado_codigo        = TpCliEnd.glb_estado_codigo        ,
                          ce.glb_cliend_endereco      = TpCliEnd.glb_cliend_endereco      ,
                          ce.glb_cliend_complemento   = TpCliEnd.glb_cliend_complemento   ,
                          ce.glb_cliend_cidade        = TpCliEnd.glb_cliend_cidade        ,
                          ce.glb_cep_codigo           = TpCliEnd.glb_cep_codigo           ,
                          ce.glb_localidade_codigo    = TpCliEnd.glb_localidade_codigo    , 
                          ce.glb_cliend_codcliente    = TpCliEnd.glb_cliend_codcliente    ,
                          ce.arm_regiao_codigo        = TpCliEnd.arm_regiao_codigo        ,
                          ce.arm_regiao_metropolitana = TpCliEnd.arm_regiao_metropolitana ,
                          ce.arm_subregiao_codigo     = TpCliEnd.arm_subregiao_codigo     ,
                          ce.xml_cep_cvrd             = TpCliEnd.xml_cep_cvrd             ,
                          ce.glb_cliend_email         = TpCliEnd.glb_cliend_email         ,
                          ce.glb_cliend_latitude      = TpCliEnd.glb_cliend_latitude      ,
                          ce.glb_cliend_longitude     = TpCliEnd.glb_cliend_longitude     ,
                          ce.glb_cliend_logo          = TpCliEnd.glb_cliend_logo          ,
                          ce.glb_portaria_id          = TpCliEnd.glb_portaria_id          ,
                          ce.glb_cliend_ie            = TpCliEnd.glb_cliend_ie            ,
                          ce.glb_cliend_im            = TpCliEnd.glb_cliend_im            ,
                          ce.glb_cliend_higienizado   = TpCliEnd.glb_cliend_higienizado   ,
                          ce.usu_usuario_criou        = TpCliEnd.usu_usuario_criou        ,
                          ce.usu_usuario_alterou      = TpCliEnd.usu_usuario_alterou      ,
                          ce.glb_cliend_dtcriacao     = TpCliEnd.glb_cliend_dtcriacao     ,
                          ce.glb_cliend_dtalteracao   = TpCliEnd.glb_cliend_dtalteracao   ,
                          ce.glb_localidade_codigoie  = TpCliEnd.glb_localidade_codigoie  ,
                          ce.glb_cliend_numero        = TpCliEnd.glb_cliend_numero        ,
                          ce.glb_cliente_cnpjaux      = TpCliEnd.glb_cliente_cnpjaux      
                    Where ce.glb_cliente_cgccpfcodigo = TpCliEnd.Glb_Cliente_Cgccpfcodigo
                      and ce.glb_tpcliend_codigo      = TpCliEnd.Glb_Tpcliend_Codigo;
                       
                    If sql%rowcount = 0  Then
                       insert into tdvadm.t_glb_cliend values TpCliEnd;
--                       dbms_output.put_line('Cliend  - BP - ' || c_msg.cod_parceiro || ' Tipo ' || TpCliEnd.Glb_Tpcliend_Codigo || ' - Inserido');
--                    Else
--                       dbms_output.put_line('Cliend  - BP - ' || c_msg.cod_parceiro || ' Tipo ' || TpCliEnd.Glb_Tpcliend_Codigo || ' - Atualizado');
                    End If;
                    
              end loop;  

           ElsIf  ( c_msg.tipo_parceiro = 'Empregado' )  Then
              c_msg.tipo_parceiro := c_msg.tipo_parceiro;
      /*        If ( x.tppessoa = 'J' ) Then
              Else
              End If;   
      */
           ElsIf  ( c_msg.tipo_parceiro = 'Frota' )  Then
              c_msg.tipo_parceiro := c_msg.tipo_parceiro;
      /*        If ( x.tppessoa = 'J' ) Then
              Else
              End If;   
      */


           End If;
           
           
        exception
         When OTHERS Then
            dbms_output.put_line('COD_BP ' || c_msg.cod_parceiro || ' CNPJ ' || c_msg.cpf_cnpj);
            dbms_output.put_line('Erro ' || sqlerrm);
            dbms_output.put_line('ERRO 2 ' || dbms_utility.format_error_backtrace);
        End;   
     Else
        If c_msg.cpf_cnpj is null Then
           dbms_output.put_line('Parceiro - BP - ' || rpad(c_msg.cod_parceiro,10) || ' Tipo ' || rpad(c_msg.tipo_parceiro,20) || ' - CPF/CNPJ NULO');
        End If;
        If tdvadm.f_enumerico(c_msg.cod_parceiro)  = 'N' Then
           dbms_output.put_line('Parceiro - BP - ' || rpad(c_msg.cod_parceiro,10) || ' Tipo ' || rpad(c_msg.tipo_parceiro,20) || ' - COD BP INVALIDO');
        End If;
     End If;
     commit;
  End Loop;
exception
When OTHERS Then
   dbms_output.put_line('Erro ' || sqlerrm);
   dbms_output.put_line('ERRO 2 ' || dbms_utility.format_error_backtrace);
      
end SP_BWTDV_Integra_BP;

Procedure SP_BWTDV_integra_CTE As
   tpConhecimento     tdvadm.t_con_conhecimento%RowType;
   tpCalcConhecimento tdvadm.t_con_calcconhecimento%Rowtype;
   tpNFTransportada   tdvadm.t_con_nftransporta%RowType;
   tpViagem           tdvadm.t_con_conhecimento%RowType;
   vAuxiliar          Integer;
   vErro              char(1);
   Begin
      
      For C_msg_cte in (Select *
                        from migdv.v_sap_cte c
                        --where c.DATA_CRIACAO >= to_char(to_date('01/08/2022','dd/mm/yyyy'),'yyyymmdd')
                       )
      Loop
         Begin
            vErro := 'N';
            tpConhecimento.Con_Conhecimento_Docnum         := c_msg_cte.docnum;
            TpConhecimento.CON_CONHECIMENTO_CODIGO         := substr(c_msg_cte.num_cte,-8,8);
            TpConhecimento.CON_CONHECIMENTO_SERIE          := c_msg_cte.serie;
            TpConhecimento.GLB_ROTA_CODIGO                 := substr(c_msg_cte.cod_filial,-3,3);
            TpConhecimento.SLF_SOLFRETE_CODIGO             := null;
            TpConhecimento.SLF_SOLFRETE_SAQUE              := null;
            TpConhecimento.SLF_TABELA_CODIGO               := null;
            TpConhecimento.SLF_TABELA_SAQUE                := null;
            TpConhecimento.PRG_PROGCARGA_CODIGO            := null;
            TpConhecimento.PRG_PROGCARGADET_SEQUENCIA      := null;
            TpConhecimento.GLB_ROTA_CODIGOPROGCARGADET     := null;
            for c_msg_parceiro in (select *
                                   from migdv.v_sap_cteparceiro cp
                                   where cp.DOCNUM = c_msg_cte.docnum)
            Loop
               If    c_msg_parceiro.COD_TP_PARCEIRO = 'AG' Then	--Emissor da ordem
                  TpConhecimento.GLB_CLIENTE_CGCCPFSACADO := TpConhecimento.GLB_CLIENTE_CGCCPFSACADO;
               ElsIf c_msg_parceiro.COD_TP_PARCEIRO= 'RG' Then	--Pagador
                  TpConhecimento.GLB_CLIENTE_CGCCPFSACADO       := pkg_migracao_sap2.Get_CPFCNPJ_Parceiro(c_msg_parceiro.COD_PARCEIRO,'Cliente');
               ElsIf c_msg_parceiro.COD_TP_PARCEIRO = 'U6' Then	--	Remetente
                 TpConhecimento.GLB_CLIENTE_CGCCPFREMETENTE     := pkg_migracao_sap2.Get_CPFCNPJ_Parceiro(c_msg_parceiro.COD_PARCEIRO,'Cliente');
                 TpConhecimento.GLB_TPCLIEND_CODIGOREMETENTE    := 'X';
               ElsIf c_msg_parceiro.COD_TP_PARCEIRO = 'WE' Then	--	Recebedor mercadoria
                  TpConhecimento.GLB_CLIENTE_CGCCPFDESTINATARIO := pkg_migracao_sap2.Get_CPFCNPJ_Parceiro(c_msg_parceiro.COD_PARCEIRO,'Cliente');
                  TpConhecimento.GLB_TPCLIEND_CODIGODESTINATARI := 'X';
               End If;

            End Loop;

            TpConhecimento.CON_VIAGEM_NUMERO               := null; --c_msg.;
            TpConhecimento.GLB_ROTA_CODIGOVIAGEM           := null; --c_msg.;
            TpConhecimento.CON_VIAGAM_SAQUE                := null; --c_msg.;
            
            TpConhecimento.GLB_MERCADORIA_CODIGO           := null; --c_msg.; -- PRECISO
            TpConhecimento.GLB_EMBALAGEM_CODIGO            := null; --c_msg.;
            TpConhecimento.GLB_ROTA_CODIGOIMPRESSAO        := null; --c_msg.; 
            
            TpConhecimento.CON_CONHECIMENTO_LOCALCOLETA    := null; --c_msg.; -- PRECISO
            TpConhecimento.CON_CONHECIMENTO_LOCALENTREGA   := null; --c_msg.; -- PRECISO
            TpConhecimento.GLB_LOCALIDADE_CODIGOORIGEM     := null; --c_msg.; -- PRECISO
            TpConhecimento.GLB_LOCALIDADE_CODIGODESTINO    := null; --c_msg.; -- PRECISO

            TpConhecimento.CON_CONHECIMENTO_DTINCLUSAO     := :old.CON_CONHECIMENTO_DTINCLUSAO;
            TpConhecimento.CON_CONHECIMENTO_DTALTERACAO    := :old.CON_CONHECIMENTO_DTALTERACAO;
            TpConhecimento.CON_CONHECIMENTO_DTEMISSAO      := :old.CON_CONHECIMENTO_DTEMISSAO;
            TpConhecimento.CON_CONHECIMENTO_QTDEENTREGA    := null; --c_msg.; 
            TpConhecimento.CON_CONHECIMENTO_NUMVIAGENS     := null; --c_msg.; 
            TpConhecimento.CON_CONHECIMENTO_FLAGRECOLHIME  := null; --c_msg.; 
            TpConhecimento.CON_CONHECIMENTO_FLAGCORTESIA   := null; --c_msg.; 
            If nvl(c_msg_cte.cancelado,'N') <> 'X' Then
               TpConhecimento.CON_CONHECIMENTO_FLAGCANCELADO  := 'N';
            Else 
               TpConhecimento.CON_CONHECIMENTO_FLAGCANCELADO  := 'S';
            End If;
            TpConhecimento.CON_CONHECIMENTO_FLAGBLOQUEADO  := null; --c_msg.; 
            TpConhecimento.CON_CONHECIMENTO_DTEMBARQUE     := null; --c_msg.; -- PRECISO
            TpConhecimento.CON_CONHECIMENTO_HORASAIDA      := null; --c_msg.; -- PRECISO
            Begin
            TpConhecimento.CON_CONHECIMENTO_OB
            TpConhecimento.CON_CONHECIMENTO_EMISSOR        := :old.CON_CONHECIMENTO_EMISSOR;
            TpConhecimento.CON_CONHECIMENTO_TPFRETE        := :old.CON_CONHECIMENTO_TPFRETE;
            TpConhecimento.CON_CONHECIMENTO_KILOMETRAGEM   := :old.CON_CONHECIMENTO_KILOMETRAGEM;
            TpConhecimento.CON_CONHECIMENTO_LOTE           := :old.CON_CONHECIMENTO_LOTE;
            TpConhecimento.CON_CONHECIMENTO_TPREGISTRO     := :old.CON_CONHECIMENTO_TPREGISTRO;
            TpConhecimento.CON_CONHECIMENTO_DTGRAVACAO     := :old.CON_CONHECIMENTO_DTGRAVACAO;
            TpConhecimento.CON_FATURA_CODIGO               := :old.CON_FATURA_CODIGO;
            TpConhecimento.CON_FATURA_CICLO                := :old.CON_FATURA_CICLO;
            TpConhecimento.GLB_ROTA_CODIGOFILIALIMP        := :old.GLB_ROTA_CODIGOFILIALIMP;
            TpConhecimento.CON_CONHECIMENTO_TPFAN          := :old.CON_CONHECIMENTO_TPFAN;
            TpConhecimento.CON_CONHECIMENTO_REDFRETE       := :old.CON_CONHECIMENTO_REDFRETE;
            TpConhecimento.CON_CONHECIMENTO_FLAGCOMPLEMEN  := :old.CON_CONHECIMENTO_FLAGCOMPLEMEN;
            TpConhecimento.CON_CONHECIMENTO_FLAGESTADIA    := :old.CON_CONHECIMENTO_FLAGESTADIA;
            TpConhecimento.GLB_ALTMAN_SEQUENCIA            := :old.GLB_ALTMAN_SEQUENCIA;
            TpConhecimento.CON_CONHECIMENTO_DIGITADO       := :old.CON_CONHECIMENTO_DIGITADO;
            TpConhecimento.CON_CONHECIMENTO_PLACA          := :old.CON_CONHECIMENTO_PLACA;
            TpConhecimento.CON_CONHECIMENTO_VENCIMENTO     := :old.CON_CONHECIMENTO_VENCIMENTO;
            TpConhecimento.CON_CONHECIMENTO_ENTREGA        := :old.CON_CONHECIMENTO_ENTREGA;
            TpConhecimento.CON_CONHECIMENTO_ATRAZO         := :old.CON_CONHECIMENTO_ATRAZO;
            TpConhecimento.CON_CONHECIMENTO_OBSDTENTREGA   := :old.CON_CONHECIMENTO_OBSDTENTREGA;
            TpConhecimento.GLB_ROTA_CODIGOGENERICO         := :old.GLB_ROTA_CODIGOGENERICO;
            TpConhecimento.CON_CONHECIMENTO_VLRINDENIZ     := :old.CON_CONHECIMENTO_VLRINDENIZ;
            TpConhecimento.CON_CONHECIMENTO_PESOINDENIZ    := :old.CON_CONHECIMENTO_PESOINDENIZ;
            TpConhecimento.CON_CONHECIMENTO_FATURAINDENIZ  := :old.CON_CONHECIMENTO_FATURAINDENIZ;
            TpConhecimento.CON_CONHECIMENTO_DTVENCINDENIZ  := :old.CON_CONHECIMENTO_DTVENCINDENIZ;
            TpConhecimento.CON_CONHECIMENTO_AVARIAS        := :old.CON_CONHECIMENTO_AVARIAS;
            TpConhecimento.CON_CONHECIMENTO_ESCOAMENTO     := :old.CON_CONHECIMENTO_ESCOAMENTO;
            TpConhecimento.CON_CONHECIMENTO_DTCHEGMATRIZ   := :old.CON_CONHECIMENTO_DTCHEGMATRIZ;
            TpConhecimento.CON_VALEFRETE_CODIGO            := :old.CON_VALEFRETE_CODIGO;
            TpConhecimento.CON_VALEFRETE_SERIE             := :old.CON_VALEFRETE_SERIE;
            TpConhecimento.GLB_ROTA_CODIGOVALEFRETE        := :old.GLB_ROTA_CODIGOVALEFRETE;
            TpConhecimento.CON_VALEFRETE_SAQUE             := :old.CON_VALEFRETE_SAQUE;
            TpConhecimento.GLB_GERRISCO_CODIGO             := :old.GLB_GERRISCO_CODIGO;
            TpConhecimento.CON_CONHECIMENTO_CODLIBERACAO   := :old.CON_CONHECIMENTO_CODLIBERACAO;
            TpConhecimento.CON_CONHECIMENTO_AUTORISEG      := :old.CON_CONHECIMENTO_AUTORISEG;
            TpConhecimento.CON_CONHECIMENTO_CFO            := :old.CON_CONHECIMENTO_CFO;
            TpConhecimento.CON_CONHECIMENTO_TRIBUTACAO     := :old.CON_CONHECIMENTO_TRIBUTACAO;
            TpConhecimento.CON_CONHECIMENTO_TPCOMPLEMENTO  := :old.CON_CONHECIMENTO_TPCOMPLEMENTO;
            TpConhecimento.CON_CONHECIMENTO_DTTRANSF       := :old.CON_CONHECIMENTO_DTTRANSF;
            TpConhecimento.CON_CONHECIMENTO_NRFORMULARIO   := :old.CON_CONHECIMENTO_NRFORMULARIO;
            TpConhecimento.CON_CONHECIMENTO_DTRECEBIMENTO  := :old.CON_CONHECIMENTO_DTRECEBIMENTO;
            TpConhecimento.CON_CONHECIMENTO_DTCHEGCELULA   := :old.CON_CONHECIMENTO_DTCHEGCELULA;
            TpConhecimento.ARM_COLETA_NCOMPRA              := :old.ARM_COLETA_NCOMPRA;
            TpConhecimento.CON_CONHECIMENTO_DTENVSEG       := :old.CON_CONHECIMENTO_DTENVSEG;
            TpConhecimento.CON_CONHECIMENTO_DTENVEDI       := :old.CON_CONHECIMENTO_DTENVEDI;
            TpConhecimento.CON_CONHECIMENTO_DTSAIDACELULA  := :old.CON_CONHECIMENTO_DTSAIDACELULA;
            TpConhecimento.CON_CONHECIMENTO_DTCHEGALMOX    := :old.CON_CONHECIMENTO_DTCHEGALMOX;
            TpConhecimento.CON_CONHECIMENTO_DTINICARGA     := :old.CON_CONHECIMENTO_DTINICARGA;
            TpConhecimento.CON_CONHECIMENTO_DTFIMCARGA     := :old.CON_CONHECIMENTO_DTFIMCARGA;
            TpConhecimento.USU_USUARIO_SAIDA               := :old.USU_USUARIO_SAIDA;
            TpConhecimento.USU_USUARIO_BAIXA               := :old.USU_USUARIO_BAIXA;
            TpConhecimento.CON_CONHECIMENTO_OBSLEI         := :old.CON_CONHECIMENTO_OBSLEI;
            TpConhecimento.CON_CONHECIMENTO_OBSCLIENTE     := :old.CON_CONHECIMENTO_OBSCLIENTE;
            TpConhecimento.GLB_ROTA_CODIGORECEITA          := :old.GLB_ROTA_CODIGORECEITA;
            TpConhecimento.CON_CONHECIMENTO_DTNFE          := :old.CON_CONHECIMENTO_DTNFE;
            TpConhecimento.CON_CONHECIMENTO_DTCHECKIN      := :old.CON_CONHECIMENTO_DTCHECKIN;
            TpConhecimento.CON_CONHECIMENTO_DTGRAVCHECKIN  := :old.CON_CONHECIMENTO_DTGRAVCHECKIN;
            TpConhecimento.ARM_CARREGAMENTO_CODIGO         := :old.ARM_CARREGAMENTO_CODIGO;
            TpConhecimento.CON_CONHECIMENTO_TERMINAL       := :old.CON_CONHECIMENTO_TERMINAL;
            TpConhecimento.CON_CONHECIMENTO_OSUSER         := :old.CON_CONHECIMENTO_OSUSER;
            TpConhecimento.CON_CONHECIMENTO_ENVIAELE       := :old.CON_CONHECIMENTO_ENVIAELE;
            TpConhecimento.ARM_COLETA_CICLO                := :old.ARM_COLETA_CICLO;
            TpConhecimento.SLF_SOLFRETE_OBSSOLICITACAO     := :old.SLF_SOLFRETE_OBSSOLICITACAO;
            TpConhecimento.CON_CONHECIMENTO_RGMESP         := :old.CON_CONHECIMENTO_RGMESP;
            TpConhecimento.CON_CONHECIMENTO_CST            := :old.CON_CONHECIMENTO_CST;
            TpConhecimento.ARM_CARREGAMENTO_CODIGOPR       := :old.ARM_CARREGAMENTO_CODIGOPR;


*/
         If length(trim(tpConhecimento.Glb_Cliente_Cgccpfremetente)) = 10 Then
            dbms_output.put_line('COD_DOCUMENTO ' || c_msg_cte.docnum || ' CTE ' || c_msg_cte.num_cte || '/' || c_msg_cte.cod_filial || ' PROBLEMAS REMETENTE    BP - ' || trim(tpConhecimento.Glb_Cliente_Cgccpfremetente));
            vErro := 'S';
         End If;
         If length(trim(tpConhecimento.Glb_Cliente_Cgccpfdestinatario)) = 10 Then
            dbms_output.put_line('COD_DOCUMENTO ' || c_msg_cte.docnum || ' CTE ' || c_msg_cte.num_cte || '/' || c_msg_cte.cod_filial || ' PROBLEMAS DESTINATARIO BP - ' || trim(tpConhecimento.Glb_Cliente_Cgccpfdestinatario));
            vErro := 'S';
         End If;
         If length(trim(tpConhecimento.Glb_Cliente_Cgccpfsacado)) = 10 Then
            dbms_output.put_line('COD_DOCUMENTO ' || c_msg_cte.docnum || ' CTE ' || c_msg_cte.num_cte || '/' || c_msg_cte.cod_filial || ' PROBLEMAS SACADO       BP - ' || trim(tpConhecimento.Glb_Cliente_Cgccpfsacado));
            vErro := 'S';
         End If;

         If vErro = 'N' Then
            update tdvadm.t_con_conhecimento c 
              set c.CON_CONHECIMENTO_CODIGO        = TpConhecimento.CON_CONHECIMENTO_CODIGO,
                  c.CON_CONHECIMENTO_SERIE         = TpConhecimento.CON_CONHECIMENTO_SERIE,
                  c.GLB_ROTA_CODIGO                = TpConhecimento.GLB_ROTA_CODIGO,
                  c.SLF_SOLFRETE_CODIGO            = TpConhecimento.SLF_SOLFRETE_CODIGO,
                  c.SLF_SOLFRETE_SAQUE             = TpConhecimento.SLF_SOLFRETE_SAQUE,
                  c.SLF_TABELA_CODIGO              = TpConhecimento.SLF_TABELA_CODIGO,
                  c.SLF_TABELA_SAQUE               = TpConhecimento.SLF_TABELA_SAQUE,
                  c.PRG_PROGCARGA_CODIGO           = TpConhecimento.PRG_PROGCARGA_CODIGO,
                  c.PRG_PROGCARGADET_SEQUENCIA     = TpConhecimento.PRG_PROGCARGADET_SEQUENCIA,
                  c.GLB_ROTA_CODIGOPROGCARGADET    = TpConhecimento.GLB_ROTA_CODIGOPROGCARGADET,
                  c.GLB_CLIENTE_CGCCPFREMETENTE    = TpConhecimento.GLB_CLIENTE_CGCCPFREMETENTE,
                  c.GLB_TPCLIEND_CODIGOREMETENTE   = TpConhecimento.GLB_TPCLIEND_CODIGOREMETENTE,
                  c.GLB_CLIENTE_CGCCPFDESTINATARIO = TpConhecimento.GLB_CLIENTE_CGCCPFDESTINATARIO,
                  c.GLB_TPCLIEND_CODIGODESTINATARI = TpConhecimento.GLB_TPCLIEND_CODIGODESTINATARI,
                  c.GLB_CLIENTE_CGCCPFSACADO       = TpConhecimento.GLB_CLIENTE_CGCCPFSACADO,
                  c.CON_VIAGEM_NUMERO              = TpConhecimento.CON_VIAGEM_NUMERO,
                  c.GLB_ROTA_CODIGOVIAGEM          = TpConhecimento.GLB_ROTA_CODIGOVIAGEM,
                  c.CON_VIAGAM_SAQUE               = TpConhecimento.CON_VIAGAM_SAQUE,
                  c.GLB_MERCADORIA_CODIGO          = TpConhecimento.GLB_MERCADORIA_CODIGO,
                  c.GLB_EMBALAGEM_CODIGO           = TpConhecimento.GLB_EMBALAGEM_CODIGO,
                  c.GLB_ROTA_CODIGOIMPRESSAO       = TpConhecimento.GLB_ROTA_CODIGOIMPRESSAO,
                  c.CON_CONHECIMENTO_LOCALCOLETA   = TpConhecimento.CON_CONHECIMENTO_LOCALCOLETA,
                  c.CON_CONHECIMENTO_LOCALENTREGA  = TpConhecimento.CON_CONHECIMENTO_LOCALENTREGA,
                  c.GLB_LOCALIDADE_CODIGOORIGEM    = TpConhecimento.GLB_LOCALIDADE_CODIGOORIGEM,
                  c.GLB_LOCALIDADE_CODIGODESTINO   = TpConhecimento.GLB_LOCALIDADE_CODIGODESTINO,
                  c.CON_CONHECIMENTO_DTINCLUSAO    = TpConhecimento.CON_CONHECIMENTO_DTINCLUSAO,
                  c.CON_CONHECIMENTO_DTALTERACAO   = TpConhecimento.CON_CONHECIMENTO_DTALTERACAO,
                  c.CON_CONHECIMENTO_DTEMISSAO     = TpConhecimento.CON_CONHECIMENTO_DTEMISSAO,
                  c.CON_CONHECIMENTO_QTDEENTREGA   = TpConhecimento.CON_CONHECIMENTO_QTDEENTREGA,
                  c.CON_CONHECIMENTO_NUMVIAGENS    = TpConhecimento.CON_CONHECIMENTO_NUMVIAGENS,
                  c.CON_CONHECIMENTO_FLAGRECOLHIME = TpConhecimento.CON_CONHECIMENTO_FLAGRECOLHIME,
                  c.CON_CONHECIMENTO_FLAGCORTESIA  = TpConhecimento.CON_CONHECIMENTO_FLAGCORTESIA,
                  c.CON_CONHECIMENTO_FLAGCANCELADO = TpConhecimento.CON_CONHECIMENTO_FLAGCANCELADO,
                  c.CON_CONHECIMENTO_FLAGBLOQUEADO = TpConhecimento.CON_CONHECIMENTO_FLAGBLOQUEADO,
                  c.CON_CONHECIMENTO_DTEMBARQUE    = TpConhecimento.CON_CONHECIMENTO_DTEMBARQUE,
                  c.CON_CONHECIMENTO_HORASAIDA     = TpConhecimento.CON_CONHECIMENTO_HORASAIDA,
                  c.CON_CONHECIMENTO_OBS           = TpConhecimento.CON_CONHECIMENTO_OBS,
                  c.CON_CONHECIMENTO_EMISSOR       = TpConhecimento.CON_CONHECIMENTO_EMISSOR,
                  c.CON_CONHECIMENTO_TPFRETE       = TpConhecimento.CON_CONHECIMENTO_TPFRETE,
                  c.CON_CONHECIMENTO_KILOMETRAGEM  = TpConhecimento.CON_CONHECIMENTO_KILOMETRAGEM,
                  c.CON_CONHECIMENTO_LOTE          = TpConhecimento.CON_CONHECIMENTO_LOTE,
                  c.CON_CONHECIMENTO_TPREGISTRO    = TpConhecimento.CON_CONHECIMENTO_TPREGISTRO,
                  c.CON_CONHECIMENTO_DTGRAVACAO    = TpConhecimento.CON_CONHECIMENTO_DTGRAVACAO,
                  c.CON_FATURA_CODIGO              = TpConhecimento.CON_FATURA_CODIGO,
                  c.CON_FATURA_CICLO               = TpConhecimento.CON_FATURA_CICLO,
                  c.GLB_ROTA_CODIGOFILIALIMP       = TpConhecimento.GLB_ROTA_CODIGOFILIALIMP,
                  c.CON_CONHECIMENTO_TPFAN         = TpConhecimento.CON_CONHECIMENTO_TPFAN,
                  c.CON_CONHECIMENTO_REDFRETE      = TpConhecimento.CON_CONHECIMENTO_REDFRETE,
                  c.CON_CONHECIMENTO_FLAGCOMPLEMEN = TpConhecimento.CON_CONHECIMENTO_FLAGCOMPLEMEN,
                  c.CON_CONHECIMENTO_FLAGESTADIA   = TpConhecimento.CON_CONHECIMENTO_FLAGESTADIA,
                  c.GLB_ALTMAN_SEQUENCIA           = TpConhecimento.GLB_ALTMAN_SEQUENCIA,
                  c.CON_CONHECIMENTO_DIGITADO      = TpConhecimento.CON_CONHECIMENTO_DIGITADO,
                  c.CON_CONHECIMENTO_PLACA         = TpConhecimento.CON_CONHECIMENTO_PLACA,
                  c.CON_CONHECIMENTO_VENCIMENTO    = TpConhecimento.CON_CONHECIMENTO_VENCIMENTO,
                  c.CON_CONHECIMENTO_ENTREGA       = TpConhecimento.CON_CONHECIMENTO_ENTREGA,
                  c.CON_CONHECIMENTO_ATRAZO        = TpConhecimento.CON_CONHECIMENTO_ATRAZO,
                  c.CON_CONHECIMENTO_OBSDTENTREGA  = TpConhecimento.CON_CONHECIMENTO_OBSDTENTREGA,
                  c.GLB_ROTA_CODIGOGENERICO        = TpConhecimento.GLB_ROTA_CODIGOGENERICO,
                  c.CON_CONHECIMENTO_VLRINDENIZ    = TpConhecimento.CON_CONHECIMENTO_VLRINDENIZ,
                  c.CON_CONHECIMENTO_PESOINDENIZ   = TpConhecimento.CON_CONHECIMENTO_PESOINDENIZ,
                  c.CON_CONHECIMENTO_FATURAINDENIZ = TpConhecimento.CON_CONHECIMENTO_FATURAINDENIZ,
                  c.CON_CONHECIMENTO_DTVENCINDENIZ = TpConhecimento.CON_CONHECIMENTO_DTVENCINDENIZ,
                  c.CON_CONHECIMENTO_AVARIAS       = TpConhecimento.CON_CONHECIMENTO_AVARIAS,
                  c.CON_CONHECIMENTO_ESCOAMENTO    = TpConhecimento.CON_CONHECIMENTO_ESCOAMENTO,
                  c.CON_CONHECIMENTO_DTCHEGMATRIZ  = TpConhecimento.CON_CONHECIMENTO_DTCHEGMATRIZ,
                  c.CON_VALEFRETE_CODIGO           = TpConhecimento.CON_VALEFRETE_CODIGO,
                  c.CON_VALEFRETE_SERIE            = TpConhecimento.CON_VALEFRETE_SERIE,
                  c.GLB_ROTA_CODIGOVALEFRETE       = TpConhecimento.GLB_ROTA_CODIGOVALEFRETE,
                  c.CON_VALEFRETE_SAQUE            = TpConhecimento.CON_VALEFRETE_SAQUE,
                  c.GLB_GERRISCO_CODIGO            = TpConhecimento.GLB_GERRISCO_CODIGO,
                  c.CON_CONHECIMENTO_CODLIBERACAO  = TpConhecimento.CON_CONHECIMENTO_CODLIBERACAO,
                  c.CON_CONHECIMENTO_AUTORISEG     = TpConhecimento.CON_CONHECIMENTO_AUTORISEG,
                  c.CON_CONHECIMENTO_CFO           = TpConhecimento.CON_CONHECIMENTO_CFO,
                  c.CON_CONHECIMENTO_TRIBUTACAO    = TpConhecimento.CON_CONHECIMENTO_TRIBUTACAO,
                  c.CON_CONHECIMENTO_TPCOMPLEMENTO = TpConhecimento.CON_CONHECIMENTO_TPCOMPLEMENTO,
                  c.CON_CONHECIMENTO_DTTRANSF      = TpConhecimento.CON_CONHECIMENTO_DTTRANSF,
                  c.CON_CONHECIMENTO_NRFORMULARIO  = TpConhecimento.CON_CONHECIMENTO_NRFORMULARIO,
                  c.CON_CONHECIMENTO_DTRECEBIMENTO = TpConhecimento.CON_CONHECIMENTO_DTRECEBIMENTO,
                  c.CON_CONHECIMENTO_DTCHEGCELULA  = TpConhecimento.CON_CONHECIMENTO_DTCHEGCELULA,
                  c.ARM_COLETA_NCOMPRA             = TpConhecimento.ARM_COLETA_NCOMPRA,
                  c.CON_CONHECIMENTO_DTENVSEG      = TpConhecimento.CON_CONHECIMENTO_DTENVSEG,
                  c.CON_CONHECIMENTO_DTENVEDI      = TpConhecimento.CON_CONHECIMENTO_DTENVEDI,
                  c.CON_CONHECIMENTO_DTSAIDACELULA = TpConhecimento.CON_CONHECIMENTO_DTSAIDACELULA,
                  c.CON_CONHECIMENTO_DTCHEGALMOX   = TpConhecimento.CON_CONHECIMENTO_DTCHEGALMOX,
                  c.CON_CONHECIMENTO_DTINICARGA    = TpConhecimento.CON_CONHECIMENTO_DTINICARGA,
                  c.CON_CONHECIMENTO_DTFIMCARGA    = TpConhecimento.CON_CONHECIMENTO_DTFIMCARGA,
                  c.USU_USUARIO_SAIDA              = TpConhecimento.USU_USUARIO_SAIDA,
                  c.USU_USUARIO_BAIXA              = TpConhecimento.USU_USUARIO_BAIXA,
                  c.CON_CONHECIMENTO_OBSLEI        = TpConhecimento.CON_CONHECIMENTO_OBSLEI,
                  c.CON_CONHECIMENTO_OBSCLIENTE    = TpConhecimento.CON_CONHECIMENTO_OBSCLIENTE,
                  c.GLB_ROTA_CODIGORECEITA         = TpConhecimento.GLB_ROTA_CODIGORECEITA,
                  c.CON_CONHECIMENTO_DTNFE         = TpConhecimento.CON_CONHECIMENTO_DTNFE,
                  c.CON_CONHECIMENTO_DTCHECKIN     = TpConhecimento.CON_CONHECIMENTO_DTCHECKIN,
                  c.CON_CONHECIMENTO_DTGRAVCHECKIN = TpConhecimento.CON_CONHECIMENTO_DTGRAVCHECKIN,
                  c.ARM_CARREGAMENTO_CODIGO        = TpConhecimento.ARM_CARREGAMENTO_CODIGO,
                  c.CON_CONHECIMENTO_TERMINAL      = TpConhecimento.CON_CONHECIMENTO_TERMINAL,
                  c.CON_CONHECIMENTO_OSUSER        = TpConhecimento.CON_CONHECIMENTO_OSUSER,
                  c.CON_CONHECIMENTO_ENVIAELE      = TpConhecimento.CON_CONHECIMENTO_ENVIAELE,
                  c.ARM_COLETA_CICLO               = TpConhecimento.ARM_COLETA_CICLO,
                  c.SLF_SOLFRETE_OBSSOLICITACAO    = TpConhecimento.SLF_SOLFRETE_OBSSOLICITACAO,
                  c.CON_CONHECIMENTO_RGMESP        = TpConhecimento.CON_CONHECIMENTO_RGMESP,
                  c.CON_CONHECIMENTO_CST           = TpConhecimento.CON_CONHECIMENTO_CST,
                  c.ARM_CARREGAMENTO_CODIGOPR      = TpConhecimento.ARM_CARREGAMENTO_CODIGOPR
            Where c.con_conhecimento_docnum        = tpConhecimento.Con_Conhecimento_Docnum;
            If sql%rowcount = 0 Then
               insert into tdvadm.t_con_conhecimento values tpConhecimento;
            End If;
         End If;
         return;
         
         Exception
            When OTHERS Then
               dbms_output.put_line('COD_DOCUMENTO ' || c_msg_cte.docnum || ' CTE ' || c_msg_cte.num_cte || '/' || c_msg_cte.cod_filial);
               dbms_output.put_line('Erro ' || sqlerrm);
               dbms_output.put_line('ERRO 2 ' || dbms_utility.format_error_backtrace);
               return;
            End;
      End Loop;
   exception
      When OTHERS Then
         dbms_output.put_line('Erro ' || sqlerrm);
         dbms_output.put_line('ERRO ' || dbms_utility.format_error_backtrace);
   End SP_BWTDV_integra_CTE;

/*
Procedure SP_BWTDV_ As
   -- Tipos
   Begin
      
      For C_msg in ()
      Loop
         Begin
            
         
         Exception
            When OTHERS Then
               dbms_output.put_line('COD_BP ' || c_msg.cod_parceiro || ' CNPJ ' || c_msg.cpf_cnpj);
               dbms_output.put_line('Erro ' || sqlerrm);
               dbms_output.put_line('ERRO 2 ' || dbms_utility.format_error_backtrace);
            End;
      End Loop
   exception
      When OTHERS Then
         dbms_output.put_line('Erro ' || sqlerrm);
         dbms_output.put_line('ERRO ' || dbms_utility.format_error_backtrace);
      End;      
   End SP_BWTDV_;
*/


END pkg_migracao_sap2;
/
