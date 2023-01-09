create or replace procedure sp_gera_valefreteColeta(pJSColetas in varchar2,
                                                    pStatus    out char,
                                                    pMessage   out clob)
As                                                

   /* Exemplo JSON
      {"contrato":"C64563737377",
       "armazem":"42",
       "usuario":"jsantos",
       "coletas":[{"id":1,"coleta":"779555","ciclo":"004"},
                  {"id":2,"coleta":"838545","ciclo":"004"},
                  {"id":3,"coleta":"830724","ciclo":"004"},
                  {"id":4,"coleta":"776945","ciclo":"004"}]}
   */

  -- aplicar na producao
  -- Drop columns
--alter table T_FCF_FRETECARMEMO drop column arm_coleta_ciclo;
--alter table T_FCF_FRETECARMEMO modify arm_coleta_ncompra varCHAR2(200);


  TYPE T_CURSOR IS REF CURSOR;
  
  vPerctetp1  number := 90;
  vPerctetp2  number := 10;

  vQueryStringSV   varchar2(3000) := 'SVSOLVEIC_COD=nome=SVSOLVEIC_COD|tipo=String|valor=0*
                                      SVPESO=nome=SVPESO|tipo=String|valor=<<PESO>>*
                                      SVQTDENTREGA=nome=SVQTDENTREGA|tipo=String|valor=<<QTDENT>>*
                                      SVUSUARIOSOLITACAO=nome=SVUSUARIOSOLITACAO|tipo=String|valor=<<USUARIO>>*
                                      SVDTSOLI=nome=SVDTSOLI|tipo=String|valor=<<DTHORASOL>>*
                                      SVUSUARIOCONTRATACAO=nome=SVUSUARIOCONTRATACAO|tipo=String|valor=*
                                      SVDTCONTR=nome=SVDTCONTR|tipo=String|valor=*
                                      SVDTPROGRAMACAO=nome=SVDTPROGRAMACAO|tipo=String|valor=<<DTPROG>*
                                      SVUSUARIOCCANCELAMENTO=nome=SVUSUARIOCCANCELAMENTO|tipo=String|valor=*
                                      SVDTCANCEL=nome=SVDTCANCEL|tipo=String|valor=*
                                      SVOBSCANCEL=nome=SVOBSCANCEL|tipo=String|valor=*
                                      SVPREVISAODIAS=nome=SVPREVISAODIAS|tipo=String|valor=*
                                      SVVEICDISPCOD=nome=SVVEICDISPCOD|tipo=String|valor=*
                                      SVSEQUENCIA=nome=SVSEQUENCIA|tipo=String|valor=*
                                      SVARMAZEM_CODIGO=nome=SVARMAZEM_CODIGO|tipo=String|valor=<<ARMAZEM>>*
                                      SVTPVEICULO_CODIGO=nome=SVTPVEICULO_CODIGO|tipo=String|valor=<<CODVEIC>>*
                                      SVHRPROGRAMACAO=nome=SVHRPROGRAMACAO|tipo=String|valor=<<HORAPROG>>
                                      SVCONTAINER=nome=SVCONTAINER|tipo=String|valor=<<CONTAINER>>*
                                      SVGRANEL=nome=SVGRANEL|tipo=String|valor=N*
                                      SVRETORNOVAZIO=nome=SVRETORNOVAZIO|tipo=String|valor=*
                                      SVCONTRATO=nome=SVCONTRATO|tipo=String|valor=<<CONTRATO>>*
                                      SVAplicacaoTDV=nome=SVAplicacaoTDV|tipo=String|valor=solveic*
                                      SVVersaoAplicao=nome=SVVersaoAplicao|tipo=String|valor=21.2.1.0*
                                      SVDESTLOCALIDADE_CODIGO=nome=SVDESTLOCALIDADE_CODIGO|tipo=String|valor=<<LOCALIDADEORIG>>*
                                      SVORIGLOCALIDADE_CODIGO=nome=SVORIGLOCALIDADE_CODIGO|tipo=String|valor=<<LOCALIDADEDEST>>*
                                      SVPART_COD=nome=SVPART_COD|tipo=String|valor=<<PARTICULARIDADE>>*
                                      SVPASSPOR_COD=nome=SVPASSPOR_COD|tipo=String|valor=<<PASSANDOPOR>>*
                                      SVRETVAZIO_COD=nome=SVRETVAZIO_COD|tipo=String|valor=*
                                      SVRETVAZIO_LOCALIDADE_COD=nome=SVRETVAZIO_LOCALIDADE_COD|tipo=String|valor=*
                                      SVVAZIO=nome=SVVAZIO|tipo=String|valor=*';


  vQueryStringIntegra varchar2(3000) := 'IntegraTdv_Cod=nome=IntegraTdv_Cod|tipo=String|valor=<<CODINTEGRA>>*
                                         VFNumero=nome=VFNumero|tipo=String|valor=<<VFCODIGO>>*
                                         VFSerie=nome=VFSerie|tipo=String|valor=<<VFSERIE>>*
                                         VFRota=nome=VFRota|tipo=String|valor=<<VFROTA>>*
                                         VFSaque=nome=VFSaque|tipo=String|valor=<<VFSAQUE>>*
                                         VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=<<VFUSUARIO>>*
                                         VFRotaUsuarioTDV=nome=VFRotaUsuarioTDV|tipo=String|valor=<<VFUSUARIORT>>*
                                         VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*';



  vQueryStringAltValores varchar2(3000) := 'VFNumero=nome=VFNumero|tipo=String|valor=<<VFCODIGO>>*
                                            VFSerie=nome=VFSerie|tipo=String|valor=<<VFSERIE>>*
                                            VFRota=nome=VFRota|tipo=String|valor=<<VFROTA>>*
                                            VFSaque=nome=VFSaque|tipo=String|valor=<<VFSAQUE>>*
                                            VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=<<VFUSUARIO>>*
                                            VFRotaUsuarioTDV=nome=VFRotaUsuarioTDV|tipo=String|valor=<<VFUSUARIORT>>*
                                            VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*' ;




  vAuxiliarN        integer;
  vAuxiliarN1       integer;
  vChaveVf          varchar2(20);
  vColeta           tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo            tdvadm.t_arm_coleta.arm_coleta_ciclo%type;


  vFCF_Veicdisp     tdvadm.t_fcf_fretecarmemo.fcf_veiculodisp_codigo%type;
  vFCF_VeicdispSeq  tdvadm.t_fcf_fretecarmemo.fcf_veiculodisp_sequencia%type;

  vOrigemLOC        tdvadm.v_arm_coletaorigemdestinojava.origem%type;
  vDestinoLOC       tdvadm.v_arm_coletaorigemdestinojava.destino%type;
  vPASSANDOPORLOC   varchar2(200);

  vOrigem           tdvadm.v_arm_coletaorigemdestinojava.origem%type;
  vDestino          tdvadm.v_arm_coletaorigemdestinojava.destino%type;
  vPASSANDOPOR      varchar2(200);

  vFreteBase        number;
  vVeiculo          tdvadm.v_arm_coletaorigemdestinojava.codveiculo%type;
  vPlaca            tdvadm.v_arm_coletaorigemdestinojava.placa%type;
  vVeicDisp         tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
  vVeicDispSeq      tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
  vCriaSolicitacao  char(1);
  vVinculaMesa      char(1);
  vCriaVeiculoDisp  char(1);
  vVinculaVeiculo   char(1);
  vValeFrete        char(1);
  vValeFrete2       char(1);
  vIdVeiculo        tdvadm.t_con_freteoper.con_freteoper_id%type;
  vRotaIdVeiculo    tdvadm.t_con_freteoper.con_freteoper_rota%type;
  vCIOT             tdvadm.t_con_vfreteciot.con_vfreteciot_numero%type;
  vPESO             tdvadm.v_arm_coletaorigemdestinojava.pesoCol%Type;
  vQTDENT           integer;
  vUSUARIO          tdvadm.t_usu_usuario.usu_usuario_codigo%type;
  vRota             tdvadm.t_glb_rota.glb_rota_codigo%type;
  vDTHORASOL        tdvadm.v_arm_coletaorigemdestinojava.dtsolicitacao%type;
  vDTPROG           tdvadm.v_arm_coletaorigemdestinojava.dtprogramacao%type;
  vHORAPROG         tdvadm.v_arm_coletaorigemdestinojava.hrprogramacao%type;
  vARMAZEM          tdvadm.v_arm_coletaorigemdestinojava.codarmazem%type;
  vCODVEIC          tdvadm.v_arm_coletaorigemdestinojava.codveiculo%type;
  vCONTAINER        char(1);
  vCONTRATO         tdvadm.t_slf_contrato.slf_contrato_codigo%type;
  vLOCALIDADEORIG   varchar2(200);
  vLOCALIDADEDEST   varchar2(200);
  vPARTICULARIDADE  number; 
  tpFCF_MEMO        tdvadm.t_fcf_fretecarmemo%rowtype;
  tpValeFrete       tdvadm.t_con_valefrete%rowtype;
  tpVfreteConhec    tdvadm.t_con_vfreteconhec%rowtype;
  tpVfreteColeta    tdvadm.t_con_vfretecoleta%rowtype;
  tpVfreteCiot      tdvadm.t_con_vfreteciot%rowtype;
  vColetas          varchar2(200);
  vPROPRIETARIO     varchar2(50);
  vMARCA            varchar2(50);
  vLOCAL            varchar2(50);
  vUFVEICULO        varchar2(10);
  vNOMEMOTORISTA    varchar2(50);
  vRG               varchar2(20);
  vUFMOTORISTA      varchar2(10);
  vCNH              varchar2(20);
  vCNPJPagador      tdvadm.v_arm_coletaorigemdestinojava.cnpjpagadorferete%Type;
  vGRUPOSAC         tdvadm.v_arm_coletaorigemdestinojava.grupoecsac%type;

  vLocalColeta      tdvadm.t_con_valefrete.con_valefrete_localcarreg%type;
  vLocalEntrega     tdvadm.t_con_valefrete.con_valefrete_localdescarga%type;

  vDescBonus        tdvadm.t_slf_clienteregras.slf_clienteregras_bonus%type;
  vvaleped          tdvadm.t_slf_clienteregras.slf_clienteregras_valeped%type;
  vvazio            tdvadm.t_slf_clienteregras.slf_clienteregras_vazio%type;
  vpgtopedetp1      tdvadm.t_slf_clienteregras.slf_clienteregras_pgtopedetp1%type;
  vpgtopedetp2      tdvadm.t_slf_clienteregras.slf_clienteregras_pgtopedetp2%type;

  vImpExpdireserva  tdvadm.v_arm_coletaorigemdestinojava.impexpdireserva%type;
  vImpExprefcliente tdvadm.v_arm_coletaorigemdestinojava.impexprefcliente%type;
  vImpExpcontainer  tdvadm.v_arm_coletaorigemdestinojava.impexpcontainer%type;
  vImpExpobs        tdvadm.v_arm_coletaorigemdestinojava.impexpobs%type;
  vPedEtp1          number;
  vPedEtp2          number;
  
  vEixosVeiculo     number;  
  vClassAntt        tdvadm.t_car_proprietario.car_proprietario_classantt%type; 
  vImpExp           tdvadm.v_arm_coletaorigemdestinojava.normalimpexp%type;

  vP_QUERYSTR       varchar2(1000) := 'VFNumero=nome=VFNumero|tipo=String|valor=VFRETENR*
                                      VFSerie=nome=VFSerie|tipo=String|valor=VFRETESR*
                                      VFRota=nome=VFRota|tipo=String|valor=VFRETERT*
                                      VFSaque=nome=VFSaque|tipo=String|valor=VFRETESQ*
                                      VFUsuarioTDV=nome=VFUsuarioTDV|tipo=String|valor=VFRETEUSU*
                                      VFRotaUsuarioTDV=nome=VFRotaUsuarioTDV|tipo=String|valor=VFRETERT*
                                      VFAplicacaoTDV=nome=VFAplicacaoTDV|tipo=String|valor=comvlfrete*
                                      VFVersaoAplicao=nome=VFVersaoAplicao|tipo=String|valor=16.1.14.0*';
  vP_STATUS         char(1);
  vP_MESSAGE        varchar2(200);
  vP_CURSOR         T_CURSOR;
  vRotaViagem       tdvadm.t_vgm_viagem.glb_rota_codigo%type;
  vCodigoViagem       tdvadm.t_vgm_viagem.vgm_viagem_codigo%type;

   
  
 begin
  -- Test statements here

  -- Raise incluido para teste api
  --raise_application_error(-20001,'Credit Limit Exceeded');
  
  insert into tdvadm.t_glb_sql values (null,sysdate,'TRAVA SANTOS',pJSColetas);
  commit;
  
  pStatus := 'N';
  pMessage := empty_clob;
  vAuxiliarN  := 0;
  vAuxiliarN1 := 0;

  vPESO            := 0;
  vQTDENT          := 0;
  vLOCALIDADEORIG  := '';
  vLOCALIDADEDEST  := '';
  vColetas         := '';

  For c_msg in (SELECT rpad(x.JScoleta,6) JScoleta,
                       rpad(x.JSciclo,3) JSciclo,
                       JSON_VALUE(pJSColetas, '$.contrato') contratoFE,
                       JSON_VALUE(pJSColetas, '$.armazem') armazem,
                       JSON_VALUE(pJSColetas, '$.usuario') usuario,
                       c.*
                FROM tdvadm.v_arm_coletaorigemdestinojava c,
                     JSON_TABLE (pJSColetas,'$ .coletas [*]'
                            COLUMNS (JSColeta varchar2(6) PATH '$ .coleta',
                                     JSCiclo  varchar2(3) PATH '$ .ciclo')) AS x
                where c.coleta = x.JScoleta
                  and c.ciclo  = X.JSciclo)  
  loop
    If vColeta is null Then
      
       vColeta           := c_msg.coleta;
       vCiclo            := c_msg.ciclo;
       vImpExp           := c_msg.normalimpexp;

       vOrigemLOC        := c_msg.origemcalcloc ;
       vDestinoLOC       := c_msg.destinocalcloc;
       vPassandoPorLOC   := c_msg.passandoporloc ;
       vOrigem           := c_msg.origemcalc;
       vDestino          := c_msg.destinocalc;
       vPassandoPor      := c_msg.passandopor ;

       vVeiculo          := c_msg.codveiculo;
       vPlaca            := c_msg.placa ;
       vUSUARIO          := c_msg.usuario;
       vDTHORASOL        := c_msg.dtsolicitacao;
       vDTPROG           := c_msg.dtprogramacao;
       vHORAPROG         := c_msg.hrprogramacao;
       vARMAZEM          := c_msg.armazem;
       vCODVEIC          := c_msg.codveiculo;
       vCONTAINER        := 'N';
       vCONTRATO         := c_msg.contratoFe;
       vPARTICULARIDADE  := '';
       vCNPJPagador      := c_msg.cnpjpagadorferete;
       vGRUPOSAC         := c_msg.grupoecsac;
       vImpExpdireserva  := c_msg.impexpdireserva;
       vImpExprefcliente := c_msg.impexprefcliente;
       vImpExpcontainer  := c_msg.impexpcontainer;
       vImpExpobs        := c_msg.impexpobs;
       vLocalColeta      := c_msg.remetentecodcli;
       vLocalEntrega     := c_msg.destinatariocodcli; 

       vRotaViagem                              := c_msg.glb_rota_codigoviagem;
       vCodigoViagem                            := c_msg.vgm_viagem_codigo;
       
       Update tdvadm.t_arm_coleta co
         set co.slf_contrato_codigo = vCONTRATO
       where co.arm_coleta_ncompra = vColeta
         and co.arm_coleta_ciclo = vCiclo
         and co.slf_contrato_codigo is null;

       Begin
          -- Sirlano 14/12/2021
          -- Pegando a Rota correta.
          Select decode(r.glb_rota_emitedoc,'CTE',r.glb_rota_codigo,
                                            'NFS',r.glb_rota_codigo,r.glb_rota_caixa)
            into vRota
            from t_arm_coleta col,
                 t_arm_armazem arm,
                 t_glb_rota r
           where arm.arm_armazem_codigo = col.arm_armazem_codigo
             and col.arm_coleta_ncompra = vColeta
             And col.arm_coleta_ciclo = vCiclo
             and arm.glb_rota_codigo = r.glb_rota_codigo;
         If vRota >= '900' Then
            vRota := 'XXX';
         End If;
      exception
         when NO_DATA_FOUND Then
            vRota := 'XXX';
         End;

--       raise_application_error(-20001,c_msg.glb_rota_codigoviagem);
       tpVfreteCiot.Con_Vfreteciot_Numero       := c_msg.vgm_vgciot_numero ;
       tpVfreteCiot.Con_Vfreteciot_Protocolo    := c_msg.vgm_vgciot_protocolo;
       tpVfreteCiot.Con_Vfreteciot_Id           := c_msg.vgm_vgciot_id ;
       tpVfreteCiot.Con_Vfreteciot_Idcliente    := c_msg.vgm_vgciot_idcliente;
       tpVfreteCiot.Con_Vfreteciot_Tppagamento  := c_msg.vgm_vgciot_tppagamento;
       tpVfreteCiot.Con_Vfreteciot_Flagcancel   := c_msg.vgm_vgciot_flagcancel; 
       tpVfreteCiot.con_Vfreteciot_Data         := c_msg.vgm_vgciot_data ;
       tpVfreteCiot.Con_Vfreteciot_Flagimprime  := null;
       tpVfreteCiot.Con_Vfreteciot_Flagaltera   := null;
       tpVfreteCiot.Con_Vfreteciot_Flagprocesal := null;

    End If;
    vAuxiliarN := vAuxiliarN + 1;
    
    Begin
       select c.con_conhecimento_codigo || '-' || c.con_conhecimento_serie || '-' || c.glb_rota_codigo || '-' || c.con_valefrete_saque
         into vChaveVf
       from tdvadm.t_con_vfreteciot c
       where c.con_vfreteciot_numero = tpVfreteCiot.Con_Vfreteciot_Numero
         and c.con_vfreteciot_protocolo = tpVfreteCiot.Con_Vfreteciot_Protocolo
         and c.Con_Vfreteciot_Idcliente = tpVfreteCiot.Con_Vfreteciot_Idcliente;
    Exception
       When NO_DATA_FOUND Then
          vChaveVf := 'NE'; -- Não encontrado
       When TOO_MANY_ROWS Then
          vChaveVf := 'VL'; -- Varias Linhas
    End ;  
       
    If vChaveVf <> 'NE' then
       pStatus := 'E';
       If vChaveVf = 'VL' Then
          pMessage := pMessage || 'PROBLEMAS CIOT JA USANDO VARIAS VEZES ' || vRotaViagem || chr(10);      
       Else
          pMessage := pMessage || 'CIOT JA USANDO no VALE DE FRETE ' || vChaveVf || chr(10);      
       End If;
    End If;
    
    If vRota = 'XXX' Then
       pStatus := 'E';
       pMessage := pMessage || 'Verificar Rota de Caixa para Rota Coleta ' || vRotaViagem || chr(10);      
    End If;
   
    If vCONTRATO is null Then
       pStatus := 'E';
       pMessage := pMessage || 'CONTRATO NAO SELECIONADO' || chr(10);      
    End If;
    

    vLOCALIDADEORIG  := vLOCALIDADEORIG || c_msg.origemcalc || ';';
    vLOCALIDADEDEST  := vLOCALIDADEDEST || c_msg.destinocalc || ';';
    vPESO            := vPESO + c_msg.pesocol;
    vQTDENT          := vQTDENT + 1;
    
  
    
    If vCNPJPagador <> c_msg.cnpjpagadorferete Then
       pStatus := 'E';
       pMessage := pMessage || 'VARIOS SACADOS' || chr(10);      
    End If;

    If nvl(c_msg.Frete,0) = 0 Then
       pStatus := 'E';
       pMessage := pMessage || '***********   VERIFIQUE   ***********' || chr(10) ||
                               '          PROBLEMAS NA MESA          ' || chr(10) || 
                               '*************************************' || chr(10) ||
                               ' Sem Frete p/ Contrato - ' || c_msg.contratoFe  || chr(10) ||
                               '              Origem  - ' || trim(c_msg.origemcalcloc)  || chr(10) || 
                               '              Destino - ' || trim(c_msg.destinocalcloc) || chr(10) || 
                               '              Pas Por - ' || trim(c_msg.passandoporloc) || chr(10) ||
                               '              veiculo - ' || c_msg.codveiculo || chr(10) ;    
    End If;
     
    If nvl(trim(c_msg.codocorrencia),'XX') not in ('XX','55')  Then
       pStatus := 'E';
       pMessage := pMessage || vColeta || '-' || 'Ocorrencia - ' || c_msg.ocorrencia  || chr(10);      
    End If;

    If vOrigem <> c_msg.origemcalc Then
       pStatus := 'E';
--       pMessage := pMessage || 'Dif Origem ' || vColeta || '-' || trim(vOrigem) || '/' || c_msg.coleta || '-' || c_msg.origemcalc || chr(10);
         pMessage := pMessage || 'Origens DIF' || chr(10);
    End If;

    If vDestino <> c_msg.destinocalc Then
       pStatus := 'E';
--       pMessage := pMessage || 'Dif Destino ' || vColeta || '-' || trim(vDestino) || '/' || c_msg.coleta || '-' || c_msg.destinocalc || chr(10);
         pMessage := pMessage || 'Destinos DIF' || chr(10);
    End If;

    If vPassandoPor <> c_msg.PassandoPor Then
       pStatus := 'E';
--       pMessage := pMessage || 'Dif PassPor ' || vColeta || '-' || trim(vPassandoPor) || '/' || c_msg.coleta || '-' || c_msg.PassandoPor || chr(10);
       pMessage := pMessage || 'PassPor DIF' || Chr(10);
    End If;

    If vVeiculo <> c_msg.codveiculo Then
       pStatus := 'E';
--       pMessage := pMessage || 'Dif Veiculo ' || vColeta || '-' || trim(vVeiculo) || '/' || c_msg.coleta || '-' || c_msg.codveiculo || chr(10);
       pMessage := pMessage || 'Veiculo DIF' || chr(10);
    End If;
    
    -- Verifica se existe uma mesa para o Veiculo
    If ( vplaca is null ) and ( vImpExp = 'E' ) Then
       pStatus := 'E';
--       pMessage := pMessage || 'Sem Veiculo ' || vColeta || chr(10);
       pMessage := pMessage || 'Sem Veiculo na Coleta ' || chr(10);

    End If;
   

    vColeta      := c_msg.coleta;
    vCiclo       := c_msg.ciclo;
    vColetas     := vColetas || c_msg.coleta || c_msg.ciclo || ';'; 
  End Loop;
  
  
  If vAuxiliarN = 0 Then
     pStatus := 'E';
     pMessage := pMessage || 'Erro - Verifique Coletas' || chr(10);
     dbms_output.put_line(pMessage);
     return;      
  End If;

  If pStatus = 'E' Then
     dbms_output.put_line('Erro' || chr(10) || pMessage);
     return;
  End If;
  
  vCriaSolicitacao := 'N';
  vCriaVeiculoDisp := 'N';
  vVinculaMesa     := 'N';
  vVinculaVeiculo  := 'N';  
  vValeFrete       := 'N';
  vValeFrete2      := 'N';
  -- Pega os Dados da FreteCarMemo
  Begin
  
      -- Mudar para fetch
      Begin
      select fm.*
        into tpFCF_MEMO
      from tdvadm.t_fcf_fretecarmemo fm,
           tdvadm.t_fcf_veiculodisp vd,
           tdvadm.t_fcf_solveic sv,
           tdvadm.t_fcf_fretecar fc
      where fm.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo(+)
        and fm.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia(+)
        and fm.fcf_solveic_cod = sv.fcf_solveic_cod(+)
        and ( vd.car_veiculo_placa = vplaca or vd.frt_conjveiculo_codigo = vplaca ) 
        and nvl(vd.fcf_veiculodisp_flagvalefrete,'N') = 'N'
        and sv.usu_usuario_cancel is null
        and fm.fcf_fretecar_rowid = fc.fcf_fretecar_rowid 
        and fc.fcf_fretecar_origemi = vOrigem
        and fc.fcf_fretecar_destinoi = vDestino
        and fc.fcf_fretecar_passandopori = vPassandoPor
        and fm.arm_coleta_ncompra is null
        and instr(vColetas,nvl(fm.arm_coleta_ncompra,'XXXXXX')) = 0;
      exception
          When NO_DATA_FOUND Then
             pStatus := 'E';
             pMessage := pMessage || '***********   VERIFIQUE   ***********' || chr(10) ||
                                     '        PROBLEMAS NO VINCULO         ' || chr(10) || 
                                     '*************************************' || chr(10) ||
                                     'Não Encontrado FRETE para esta VIAGEM /[' || vplaca || ']/[' || vOrigem || ']/[' || vDestino || ']/[' || vPassandoPor || ']/[' || vColetas;
             return;             
          End;                     
        
        If vCONTRATO is null Then
           vCONTRATO := trim(tpFCF_MEMO.Slf_Contrato_Codgo);
        End If;        

       select count(*)
         into vAuxiliarN
       from tdvadm.t_slf_contrato c
       where c.slf_contrato_codigo = vCONTRATO;
       If vAuxiliarN = 0 Then
          pStatus := 'E';
          pMessage := pMessage || 'CONTRATO Ñ EXISTE - ' || trim(vCONTRATO) || chr(10);      
       End If;
       
       If vCNPJPagador is not null Then
          select count(*)
            into vAuxiliarN
          from tdvadm.t_glb_clientecontrato cc
          where cc.glb_cliente_cgccpfcodigo = rpad(vCNPJPagador,20)
            and cc.slf_contrato_codigo = vCONTRATO;

          If vAuxiliarN = 0 Then
             pStatus := 'E';
             pMessage := pMessage || 'Verifique CNPJ - ' || vCNPJPagador || ' CONTR - ' || trim(vCONTRATO) || chr(10);      
          End If;
       End If;

        
        -- Verifica se Existe uma Solicitacao
        If tpFCF_MEMO.Fcf_Solveic_Cod is null Then
           vCriaSolicitacao := 'S';
        Else
           -- Verificar se todos os destinos estão cumpridos na coleta
           vCriaSolicitacao := 'N';
        End If;

        -- Verifica se Veiculo esta cadastrado na Mesa 
        If tpFCF_MEMO.Fcf_Veiculodisp_Codigo is null Then
           vCriaVeiculoDisp := 'N';
           pStatus := 'E';
           pMessage := pMessage || 'Sem Vinvulo na Mesa' || chr(10);
           dbms_output.put_line(pMessage);
        Else
           vCriaVeiculoDisp := 'N';

           select vd.con_freteoper_id,
                  vd.con_freteoper_rota,
                  tv.fcf_tpveiculo_nreixos
               into vIdVeiculo,
                    vRotaIdVeiculo,
                    vEixosVeiculo
           from tdvadm.t_fcf_veiculodisp vd,
                tdvadm.t_Fcf_Tpveiculo tv
           where vd.fcf_tpveiculo_codigo = tv.fcf_tpveiculo_codigo
             and vd.fcf_veiculodisp_codigo = tpFCF_MEMO.Fcf_Veiculodisp_Codigo
             and vd.fcf_veiculodisp_sequencia = tpFCF_MEMO.fcf_veiculodisp_sequencia;
           If Trim(pkg_cfe_frete.FN_GET_IDVALIDO(vIdVeiculo, vRotaIdVeiculo)) <> 'OK' Then
              pStatus := 'E';
              pMessage := pMessage || 'Veiculo/Proprietario ID nao VALIDO' || chr(10);
              dbms_output.put_line(pMessage);
           End If;
        End If; 

        -- Verifica se existe vinculo da Solicitação com a MESA            
        If tpFCF_MEMO.Fcf_Fretecar_Rowid is null Then
           vVinculaMesa     := 'S';
        Else
           vVinculaMesa     := 'N';
        End If;

        -- Verifica se foram criados os Vales de Frete
        If tpFCF_MEMO.Con_Valefrete_Codigo is null Then
            vValeFrete       := 'S';
        Else 
            vValeFrete       := 'N';
        End If;

        -- Verifica se foram criados os Vales de Frete 2
        If tpFCF_MEMO.Con_Valefrete_Codigo2 is null Then
            vValeFrete2       := 'S';
        Else 
            vValeFrete2       := 'N';
        End If;

  exception
    When NO_DATA_FOUND Then
       vCriaSolicitacao := 'S';
       vVinculaMesa     := 'S';
       vCriaVeiculoDisp := 'S';
       vVinculaVeiculo  := 'S';  
       vValeFrete       := 'S';
       vValeFrete2      := 'S';
    End; 
  
-- Verifica o Pedagio
  begin
     IF trim(vPassandoPorLOC) <> '99999' Then  
/* 25/02/2022 - Sirlano
   Passei a usar a funcao.
   
         Select max(nvl(cp.slf_percursoped_valoreixo,0))
           into vPedEtp1
         from tdvadm.t_slf_percursoped cp
         where cp.slf_percursoped_origemi = tdvadm.fn_busca_codigoibge(trim(vOrigemLOC),'IBC')
           and cp.slf_percursoped_destinoi = tdvadm.fn_busca_codigoibge(trim(vPassandoPorLOC),'IBC')
           and cp.slf_percursoped_atualizacao = (select max(cp.slf_percursoped_atualizacao)
                                                 from tdvadm.t_slf_percursoped cp
                                                 where cp.slf_percursoped_origemi = tdvadm.fn_busca_codigoibge(trim(vOrigemLOC),'IBC')
                                                   and cp.slf_percursoped_destinoi = tdvadm.fn_busca_codigoibge(trim(vPassandoPorLOC),'IBC'));

         Select max(nvl(cp.slf_percursoped_valoreixo,0))
           into vPedEtp2
         from tdvadm.t_slf_percursoped cp
         where cp.slf_percursoped_origemi = tdvadm.fn_busca_codigoibge(trim(vPassandoPorLOC),'IBC')
           and cp.slf_percursoped_destinoi = tdvadm.fn_busca_codigoibge(trim(vDestinoLOC),'IBC')
           and cp.slf_percursoped_atualizacao = (select max(cp.slf_percursoped_atualizacao)
                                                 from tdvadm.t_slf_percursoped cp
                                                 where cp.slf_percursoped_origemi = tdvadm.fn_busca_codigoibge(trim(vPassandoPorLOC),'IBC')
                                                   and cp.slf_percursoped_destinoi = tdvadm.fn_busca_codigoibge(trim(vDestinoLOC),'IBC'));

*/

         vPedEtp1 := tdvadm.f_busca_pedagio_percurso_atu(vOrigemLOC,vPassandoPorLOC);
         vPedEtp2 := tdvadm.f_busca_pedagio_percurso_atu(vPassandoPorLOC,vDestinoLOC);

         vPedEtp1 := nvl(vPedEtp1,0);
         vPedEtp2 := nvl(vPedEtp2,0);
     
         vPedEtp1 :=  vPedEtp1 * vEixosVeiculo;
         vPedEtp2 :=  vPedEtp2 * vEixosVeiculo;
     
         -- 03/03/2022 - Sirlano / Rezende
         -- Para que nao seja calculado valor negativo do pedagio
         If (nvl(tpFCF_MEMO.Fcf_Fretecarmemo_Pedagio,0) = 0) Then 
            vPedEtp1 := 0;
            vPedEtp2 := 0;
         ElsIf vPedEtp1 >= nvl(tpFCF_MEMO.Fcf_Fretecarmemo_Pedagio,0) then
            vPedEtp1 := nvl(tpFCF_MEMO.Fcf_Fretecarmemo_Pedagio,0);
            vPedEtp2 := 0;
         ElsIf vPedEtp1 < nvl(tpFCF_MEMO.Fcf_Fretecarmemo_Pedagio,0) then
            vPedEtp1 := vPedEtp1;
            vPedEtp2 := nvl(tpFCF_MEMO.Fcf_Fretecarmemo_Pedagio,0) - vPedEtp1;
         End If;
     Else
         vPedEtp1 := nvl(tpFCF_MEMO.Fcf_Fretecarmemo_Pedagio,0);
         vPedEtp2 := 0;
     End If;
  exception
    When OTHERS Then
       vPedEtp1 := 0;
       vPedEtp2 := 0;
    End;




  If ( vCriaSolicitacao = 'S' )  Then
     pStatus := 'E';
     pMessage := pMessage || 'Sem SOLICITACAO' || chr(10);
     dbms_output.put_line(pMessage);
--  Else
--     pMessage := pMessage || 'Solicitacao Ok' || chr(10);
--     dbms_output.put_line(pMessage);
  End If; 


  -- 
  If ( vVinculaMesa = 'S' )  Then
     pStatus := 'E';
     pMessage := pMessage || 'SOLICITACAO sem SIMULADOR' || chr(10);
     dbms_output.put_line(pMessage);
--  Else
--     pMessage := pMessage || 'FRETE Simulador ok' || chr(10);
--     dbms_output.put_line(pMessage);
  End If;


     If vImpExp = 'I' Then


        SELECT count(*)
--               VV.CON_CONHECIMENTO_CODIGO,
--               VV.CON_CONHECIMENTO_SERIE,
--               VV.GLB_ROTA_CODIGO
           into vAuxiliarN 
        FROM T_CON_VEICCONHEC VV,
             T_CON_CONHECIMENTO CC
        WHERE VV.FCF_VEICULODISP_CODIGO                  = tpFCF_MEMO.Fcf_Veiculodisp_Codigo
          AND VV.FCF_VEICULODISP_SEQUENCIA               = tpFCF_MEMO.Fcf_Veiculodisp_Sequencia   
          AND VV.CON_CONHECIMENTO_CODIGO                 = CC.CON_CONHECIMENTO_CODIGO
          AND VV.CON_CONHECIMENTO_SERIE                  = CC.CON_CONHECIMENTO_SERIE
          AND VV.GLB_ROTA_CODIGO                         = CC.GLB_ROTA_CODIGO
          AND NVL(CC.CON_CONHECIMENTO_FLAGCANCELADO,'N') = 'N';

    
        If vAuxiliarN = 0 Then
           pStatus := 'E';
           pMessage := pMessage || 'Coleta Sem CONHECIMENTO' || chr(10);
           dbms_output.put_line(pMessage);
        End If;
        
            

     End If;






     -- Colocar o CNPJ
     tpValeFrete.glb_cliente_cgccpfcodigo       := null;
     tpValeFrete.con_valefrete_impresso         := null;
     tpValeFrete.con_valefrete_fifo             := 'N';
     tpValeFrete.usu_usuario_codigo             := vUSUARIO;

     tpValeFrete.con_valefrete_datacadastro     := sysdate;
     tpValeFrete.con_valefrete_dataemissao      := sysdate;
     tpValeFrete.con_valefrete_emissor          := '';

     tpValeFrete.con_valefrete_dataprazomax     := vDTPROG;
     tpValeFrete.con_valefrete_horaprazomax     := to_date(to_char(sysdate,'DD/MM/YYYY') || ' ' || vHORAPROG,'dd/mm/yyyy HH24:MI');


    /*PEGO OS DADOS DO VEICULO*/
    tdvadm.sp_busca_fcfveiculodisp(tpFCF_MEMO.Fcf_Veiculodisp_Codigo,
                                   vPROPRIETARIO,
                                   vMARCA,
                                   tpValeFrete.Con_Valefrete_Placa,
                                   vLOCAL,
                                   vUFVEICULO,
                                   vNOMEMOTORISTA,
                                   vRG,
                                   tpValeFrete.Con_Valefrete_Carreteiro,
                                   vUFMOTORISTA,
                                   vCNH,
                                   tpValeFrete.Glb_Tpmotorista_Codigo,
                                   tpValeFrete.Con_Valefrete_Placasaque);


    If ( vImpExp = 'E' ) Then
       If ( vPROPRIETARIO <> 'TRANSPORTES DELLA VOLPE S/A' )  Then
          Begin
             Select max(p.car_proprietario_classantt)
                 into vClassAntt
             from tdvadm.t_car_proprietario p
             where p.car_proprietario_cgccpfcodigo = (select cv.car_proprietario_cgccpfcodigo
                                                      from tdvadm.t_car_veiculo cv
                                                      where cv.car_veiculo_placa = tpValeFrete.Con_Valefrete_Placa
                                                        and cv.car_veiculo_saque = tpValeFrete.Con_Valefrete_Placasaque);
          exception
            When OTHERS Then
              vClassAntt := 'TAC';
            End;
          If ( tpVfreteCiot.Con_Vfreteciot_Numero is null ) and ( vClassAntt <> 'ETC' )  Then
             pStatus := 'E';
             pMessage := pMessage || 'CIOT nao emcontrado' || chr(10);      
          End If;
          -- 25/02/2022 - Sirlano, INCLUIDO
          If ( tpVfreteCiot.Con_Freteoper_Rota <> tpValeFrete.Glb_Rota_Codigo ) Then
             pStatus := 'E';
             pMessage := pMessage || 'ROTA DO CCIOT ' || tpVfreteCiot.Con_Freteoper_Rota || chr(10) ||
                                     'DIFERENTE DA ROTA DO VALEFRETE ' || tpValeFrete.Glb_Rota_Codigo || chr(10);      
          End If;
          -- FIM
       End If;
    End If;

    If ( vValeFrete = 'S' ) AND ( pStatus <> 'E' ) Then

       If trim(vPassandoPor) =  '9999999' Then
          vValeFrete2 := 'N';
          vPerctetp1  := 100;
          vPerctetp2  := 0;
       End If;    
       
      -- pMessage := pMessage || 'Gera VF 2 ' || vValeFrete2 || chr(10);

     -- Veiculo

     tpValeFrete.con_valefrete_tipotransporte   := 'T';
     If substr(tpValeFrete.Con_Valefrete_Placa,1,3) = '000' Then
        tpValeFrete.frt_conjveiculo_codigo         := tpValeFrete.Con_Valefrete_Placa;
     Else
        tpValeFrete.frt_conjveiculo_codigo         := '';
     End If;
     tpValeFrete.fcf_veiculodisp_codigo         := tpFCF_MEMO.Fcf_Veiculodisp_Codigo;
     tpValeFrete.fcf_veiculodisp_sequencia      := tpFCF_MEMO.Fcf_Veiculodisp_Sequencia;
     tpValeFrete.con_valefrete_optsimples       := 'N';


     -- Pega os parametros do contrato
     
     Begin
       select distinct x.slf_clienteregras_valeped,
              x.slf_clienteregras_vazio,
              x.slf_clienteregras_pgtopedetp1,
              x.slf_clienteregras_pgtopedetp2
           into vvaleped,
                vvazio,
                vpgtopedetp1,
                vpgtopedetp2
       from tdvadm.t_slf_clienteregras x
       where x.slf_contrato_codigo = vCONTRATO
         and x.slf_clienteregras_vigencia = (select max(x1.slf_clienteregras_vigencia)
                                             from tdvadm.t_slf_clienteregras x1
                                             where x1.slf_contrato_codigo = x.slf_contrato_codigo);
        vvaleped := 'S';
     exception
       When OTHERS Then
          vvaleped     := '';
          vvazio       := '';
          vpgtopedetp1 := '';
          vpgtopedetp2 := '';
       End;

     tpValeFrete.con_valefrete_descbonus        := tdvadm.PKG_CON_VALEFRETE.Fn_VerificaDescBonus(vCONTRATO,tpValeFrete.Glb_Tpmotorista_Codigo);
 
     tpValeFrete.con_valefrete_descbonus := nvl(tpValeFrete.con_valefrete_descbonus,'S');



     If tpValeFrete.con_valefrete_descbonus = 'S' Then
        tpValeFrete.Con_Valefrete_Condespeciais := 'RECEBER COMISSÃO S/BONUS DE R$ 0,00';
     Else
        tpValeFrete.con_valefrete_condespeciais :=  '';
     End If;
     -- Pesos
     tpValeFrete.con_valefrete_pesoindicado     := vPESO/1000;
     tpValeFrete.con_valefrete_pesocobrado      := vPESO/1000;
     tpValeFrete.con_valefrete_lotacao          := vPESO/1000;
     
     If ( vvaleped = 'S' )  Then
        tpValeFrete.con_valefrete_pgvpedagio       := 'S';
     Else
        tpValeFrete.con_valefrete_pgvpedagio       := 'N';
     End If;       
     If (vpgtopedetp1 = 'CLI' ) Then
        tpValeFrete.con_valefrete_pgvpedagio       := 'S';
        tpValeFrete.con_valefrete_pedpgcli         := 'S';
     Else 
        tpValeFrete.con_valefrete_pedpgcli         := 'N';
     End If; 



     -- Valores
     tpValeFrete.fcf_fretecar_rowid             := tpFCF_MEMO.Fcf_Fretecar_Rowid;
     -- Todas as Verbas
     vFreteBase                                 := tpFCF_MEMO.Fcf_Fretecarmemo_Frete +
                                                   tpFCF_MEMO.Fcf_Fretecarmemo_Entrega +
                                                   tpFCF_MEMO.Fcf_Fretecarmemo_Coleta +
                                                   tpFCF_MEMO.Fcf_Fretecarmemo_Excecao +
                                                   -- 03/05/2022 Sirlano
                                                   -- incluindo o acrescimo no FRETE
                                                   TPfcf_memo.Fcf_Fretecarmemo_Acrescimo +
                                                   tpFCF_MEMO.Fcf_Fretecarmemo_Particularidade +
                                                   tpFCF_MEMO.Fcf_Fretecarmemo_Expresso;
     -- Para duas etapas pagar 80%                                              
     tpValeFrete.con_valefrete_freteoriginal    := vFreteBase * ( vPerctetp1 / 100) ;
     tpValeFrete.con_valefrete_pedagiooriginal  := vPedEtp1;

     -- tirar
     If nvl(tpValeFrete.con_valefrete_pedpgcli,'N') = 'N' Then
        tpValeFrete.con_valefrete_pedagio          := vPedEtp1;
     Else
        tpValeFrete.con_valefrete_pedagio          := 0;
     End If;
     tpValeFrete.con_valefrete_custocarreteiro  := tpValeFrete.con_valefrete_freteoriginal +
                                                   tpValeFrete.con_valefrete_pedagio;

     tpValeFrete.con_valefrete_tipocusto        := 'U';
     tpValeFrete.con_valefrete_frete            := tpValeFrete.con_valefrete_custocarreteiro;

--     tpValeFrete.con_valefrete_adiantamento     := tpValeFrete.con_valefrete_pedagio;   
     
--     tpValeFrete.con_valefrete_adiantamento     := tpValeFrete.con_valefrete_frete * 0.80;
     tpValeFrete.con_valefrete_adiantamento     := 0;
     If tpValeFrete.con_valefrete_adiantamento  < tpValeFrete.con_valefrete_pedagio Then
        tpValeFrete.con_valefrete_adiantamento     := tpValeFrete.con_valefrete_pedagio;   
     End If;
                                                   



     tpValeFrete.con_valefrete_irrf             := 0;
     tpValeFrete.con_valefrete_inss             := 0;
     tpValeFrete.con_valefrete_sestsenat        := 0; 
     tpValeFrete.con_valefrete_valorliquido     := tpValeFrete.con_valefrete_frete - tpValeFrete.con_valefrete_adiantamento;

     tpValeFrete.con_valefrete_reembolso        := 0;
     tpValeFrete.con_valefrete_multa            := 0;
     tpValeFrete.con_valefrete_valorestiva      := 0;
     tpValeFrete.con_valefrete_valorvazio       := 0;
     tpValeFrete.con_valefrete_valorrateio      := 0;
     tpValeFrete.con_valefrete_valorcomdesconto := 0;
     tpValeFrete.con_valefrete_cofins           := 0;
     tpValeFrete.con_valefrete_csll             := 0;
     tpValeFrete.con_valefrete_pis              := 0;
     tpValeFrete.con_valefrete_avaria           := 0;
     tpValeFrete.con_valefrete_enlonamento      := 0;
     tpValeFrete.con_valefrete_estadia          := 0;
     tpValeFrete.con_valefrete_outros           := 0;


     -- Localidades
     tpValeFrete.glb_localidade_codigoori       := vOrigemLOC;
     tpValeFrete.glb_localidade_codigodes       := vDestinoloc;
     tpValeFrete.glb_localidade_codigopasspor   := vPASSANDOPORloc;
     tpValeFrete.con_valefrete_localcarreg      := vLocalColeta;
     tpValeFrete.con_valefrete_localdescarga    := vLocalEntrega;
     tpValeFrete.con_valefrete_kmprevista       := 0;
     tpValeFrete.glb_localidade_codigo          := vOrigemLOC;
     tpValeFrete.glb_localidade_origemvazio     := null;
     tpValeFrete.glb_localidade_destinovazio    := null;


     tpValeFrete.con_viagem_numero              := null;
     tpValeFrete.glb_rota_codigoviagem          := null;
     tpValeFrete.con_valefrete_conhecimentos    := null;
     tpValeFrete.con_valefrete_nfs              := null;
     tpValeFrete.con_valefrete_entregas         := 1;
     tpValeFrete.con_valefrete_prazocontr       := null;
     tpValeFrete.con_valefrete_percmulta        := null;

     tpValeFrete.con_valefrete_datachegada      := null;
     tpValeFrete.con_valefrete_horachegada      := null;

     tpValeFrete.con_valefrete_caixa            := null;
     tpValeFrete.con_valefrete_datapagto        := null;
     tpValeFrete.con_valefrete_berconf          := null;
     tpValeFrete.con_valefrete_bercoqtde        := null;
     tpValeFrete.con_valefrete_bercoqtdepino    := null;
     tpValeFrete.con_valefrete_postorazaosocial := null;
     tpValeFrete.con_valefrete_comprovante      := null;
     tpValeFrete.con_valefrete_status           := null;
     tpValeFrete.pos_cadastro_cgc               := null;
     -- Caixa e Acerto
     tpValeFrete.cax_boletim_data               := null;
     tpValeFrete.cax_movimento_sequencia        := null;
     tpValeFrete.glb_rota_codigocx              := null;
     tpValeFrete.acc_acontas_numero             := null;
     tpValeFrete.acc_contas_ciclo               := null;
     tpValeFrete.con_valefrete_datarecebimento  := null;
     tpValeFrete.acc_acontas_tpdoc              := null;

     tpValeFrete.frt_movvazio_numero            := null;
     tpValeFrete.glb_rota_codigovazio           := null;
     tpValeFrete.usu_usuario_codigovalidador    := null;
     tpValeFrete.usu_usuario_codigo_autoriza    := null;
     tpValeFrete.con_valefrete_dtautoriza       := null;
     tpValeFrete.con_valefrete_dtchegcelula     := null;
     tpValeFrete.con_valefrete_adtanterior      := null;
     tpValeFrete.con_conhecimento_codigoch      := null;
     tpValeFrete.con_conhecimento_seriech       := null;
     tpValeFrete.glb_rota_codigoch              := null;
     tpValeFrete.con_valefrete_saquech          := null;
     tpValeFrete.con_valefretedet_seq           := null;
     tpValeFrete.usu_usuario_codalteracao       := null;
     tpValeFrete.con_valefrete_dep              := null;
     tpValeFrete.con_valefrete_dtcheckin        := null;
     tpValeFrete.con_valefrete_dtgravcheckin    := null;
     tpValeFrete.con_valefrete_dthoraimpressao  := null;
     tpValeFrete.con_valefrete_obs              := '' ;      
     

     -- Ver a DIRECAO DO PEDAGIO
     If tpValeFrete.con_valefrete_pedpgcli = 'S' Then
        tpValeFrete.con_valefrete_obrigacoes := 'Vale Pedagio pago pelo Cliente ';
     Else
        tpValeFrete.con_valefrete_obrigacoes := null;
     End If;
     
     
     
     tpValeFrete.con_valefrete_obrigacoes :=  substr(tpValeFrete.con_valefrete_obrigacoes ||' [' || trim(vImpExpcontainer) || ']' ||
                                                                                            ' [' || trim(vImpExpdireserva) || ']' ||
                                                                                            ' [' || trim(vImpExprefcliente) || ']' ||
                                                                                            trim(vImpExpobs),1,199);


     tpValeFrete.con_valefrete_obscaixa := '';


     tpValeFrete.glb_rota_codigoapresent        := null;
     tpValeFrete.glb_rota_codigoapresentold     := null;
     tpValeFrete.usu_usuario_codigortapresent   := null;
     tpValeFrete.con_valefrete_percetdes        := null;
     tpValeFrete.con_subcatvalefrete_codigo     := null;
     tpValeFrete.con_valefrete_diariobordo      := null;
     tpValeFrete.con_valefrete_qtdereimp        := null;
     tpValeFrete.con_valefrete_forcatarifa      := null;
     tpValeFrete.con_valefrete_docref           := null;

     tpValeFrete.con_conhecimento_codigo        := tdvadm.fn_busca_buracaoVF(vRota);
     tpValeFrete.con_conhecimento_serie         := 'A1';
     tpValeFrete.glb_rota_codigo                := vRota;
     tpValeFrete.con_valefrete_saque            := '1';
     tpValeFrete.con_catvalefrete_codigo        := '01';
     
     -- Primeira Etapa 
     Begin
        -- Primeiro VF
        Insert into tdvadm.t_con_valefrete vf values tpValeFrete;
--        rollback;
        update tdvadm.t_fcf_fretecarmemo m
          set m.con_valefrete_codigo =  tpValeFrete.con_conhecimento_codigo,
              m.con_valefrete_serie = tpValeFrete.con_conhecimento_serie,
              m.glb_rota_codigo = tpValeFrete.Glb_Rota_Codigo,
              m.con_valefrete_saque = tpValeFrete.Con_Valefrete_Saque,
              m.arm_coleta_ncompra = vColetas,
              m.fcf_fretecarmemo_pedagioetp1 = tpValeFrete.Con_Valefrete_Pedagio,
              m.fcf_fretecarmemo_valepedagio = tpValeFrete.Con_Valefrete_Pgvpedagio,
              m.fcf_fretecarmemo_pedagioetp1tdvcli = tpValeFrete.Con_Valefrete_Pedpgcli,
              m.fcf_fretecarmemo_dtvalefrete = tpValeFrete.Con_Valefrete_Datacadastro
        where m.fcf_solveic_cod = tpFCF_MEMO.Fcf_Solveic_Cod;

        update tdvadm.t_fcf_veiculodisp vd
          set vd.fcf_veiculodisp_flagvalefrete = 'S'
        where vd.fcf_veiculodisp_codigo = tpValeFrete.Fcf_Veiculodisp_Codigo
          and vd.fcf_veiculodisp_sequencia = tpValeFrete.Fcf_Veiculodisp_Sequencia;

        for c_msg in (select DISTINCT C.CON_CONHECIMENTO_CODIGO,
                                      C.CON_CONHECIMENTO_SERIE,
                                      C.GLB_ROTA_CODIGO,
                                      C.CON_CONHECIMENTO_DTEMBARQUE,
                                      CALC.SLF_TPCALCULO_CODIGO
                        from tdvadm.t_fcf_fretecarmemo m,
                           tdvadm.t_fcf_veiculodisp vd,
                           tdvadm.t_arm_carregamento ca,
                           tdvadm.t_arm_carregamentodet cd,
                           TDVADM.T_CON_CONHECIMENTO C,
                           t_con_calcconhecimento caLC,
                           tdvadm.t_arm_nota nt
                      where m.fcf_veiculodisp_codigo = tpFCF_MEMO.Fcf_Veiculodisp_Codigo
                        AND M.FCF_VEICULODISP_SEQUENCIA = tpFCF_MEMO.Fcf_Veiculodisp_Sequencia   
                        and m.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
                        and m.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
                        and m.fcf_veiculodisp_codigo = ca.fcf_veiculodisp_codigo
                        and m.fcf_veiculodisp_sequencia = ca.fcf_veiculodisp_sequencia
                        and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
                        and cd.arm_embalagem_numero = nt.arm_embalagem_numero
                        and cd.arm_embalagem_flag = nt.arm_embalagem_flag
                        and cd.arm_embalagem_sequencia = nt.arm_embalagem_sequencia
                        AND NT.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
                        AND NT.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
                        AND NT.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
                        AND NT.CON_CONHECIMENTO_CODIGO = CALC.CON_CONHECIMENTO_CODIGO
                        AND NT.CON_CONHECIMENTO_SERIE = CALC.CON_CONHECIMENTO_SERIE
                        AND NT.GLB_ROTA_CODIGO = CALC.GLB_ROTA_CODIGO
                        AND CALC.SLF_RECCUST_CODIGO = 'D_FRPSVO')
        Loop
           tpVfreteConhec.Con_Valefrete_Codigo           := tpValeFrete.Con_Conhecimento_Codigo;
           tpVfreteConhec.Con_Valefrete_Serie            := tpValeFrete.Con_Conhecimento_Serie;
           tpVfreteConhec.Glb_Rota_Codigovalefrete       := tpValeFrete.Glb_Rota_Codigo;
           tpVfreteConhec.Con_Valefrete_Saque            := tpValeFrete.Con_Valefrete_Saque;
           tpVfreteConhec.Glb_Rota_Codigo                := c_msg.glb_rota_codigo;
           tpVfreteConhec.Con_Conhecimento_Codigo        := c_msg.con_conhecimento_codigo;
           tpVfreteConhec.Con_Conhecimento_Serie         := c_msg.con_conhecimento_serie;
           tpVfreteConhec.Con_Vfreteconhec_Recalcula     := 'S';
           tpVfreteConhec.Slf_Tpcalculo_Codigo           := c_msg.slf_tpcalculo_codigo;
           tpVfreteConhec.Con_Vfreteconhec_Saldo         := 0;
           tpVfreteConhec.Con_Vfreteconhec_Pedagio       := 0;
           tpVfreteConhec.Con_Vfreteconhec_Rateioreceita := 0; 
           tpVfreteConhec.Con_Vfreteconhec_Rateiofrete   := 0;
           tpVfreteConhec.Con_Vfreteconhec_Rateiopedagio := 0;
           tpVfreteConhec.Con_Vfreteconhec_Dtentrega     := null;
           tpVfreteConhec.Con_Vfreteconhec_Rateioicmiss  := 0;
           tpVfreteConhec.Con_Vfreteconhec_Dtgravacao    := sysdate;
           tpVfreteConhec.Con_Vfreteconhec_Usumaq        := null;
           tpVfreteConhec.Con_Vfreteconhec_Transfchekin  := null;
           tpVfreteConhec.Arm_Armazem_Codigo             := null;
        
           insert into tdvadm.t_con_vfreteconhec
           values tpVfreteConhec;
        
        End Loop;


        For c_msg in (SELECT rpad(x.JScoleta,6) JScoleta,
                             rpad(x.JSciclo,3) JSciclo,
                             JSON_VALUE(pJSColetas, '$.contrato') contratoFE,
                             JSON_VALUE(pJSColetas, '$.armazem') armazem,
                             JSON_VALUE(pJSColetas, '$.usuario') usuario,
                             c.*
                      FROM tdvadm.v_arm_coletaorigemdestinojava c,
                           JSON_TABLE (pJSColetas,'$ .coletas [*]'
                                  COLUMNS (JSColeta varchar2(6) PATH '$ .coleta',
                                           JSCiclo  varchar2(3) PATH '$ .ciclo')) AS x
                      where c.coleta = x.JScoleta
                        and c.ciclo  = X.JSciclo)  
        loop
           tpVfreteColeta.Con_Valefrete_Codigo       := tpValeFrete.con_conhecimento_codigo;
           tpVfreteColeta.Con_Valefrete_Serie        := tpValeFrete.con_conhecimento_serie;
           tpVfreteColeta.Glb_Rota_Codigovalefrete   := tpValeFrete.Glb_Rota_Codigo;
           tpVfreteColeta.Con_Valefrete_Saque        := tpValeFrete.Con_Valefrete_Saque;
           tpVfreteColeta.Arm_Coleta_Ncompra         := c_msg.coleta;
           tpVfreteColeta.Arm_Coleta_Ciclo           := c_msg.ciclo;
           tpVfreteColeta.Con_Vfretecoleta_Recalcula := 'S';
           insert into tdvadm.t_con_vfretecoleta values tpVfreteColeta;

           Update tdvadm.t_arm_coleta co
              set co.slf_contrato_codigo = c_msg.contratoFE
           where co.arm_coleta_ncompra = c_msg.coleta
             and co.arm_coleta_ciclo = c_msg.ciclo
             and co.slf_contrato_codigo is null;


        End Loop;


        commit;
        -- Calcula as Verbas do Vale de Frete

        vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETENR',tpValeFrete.Con_Conhecimento_Codigo);
        vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETESR',tpValeFrete.Con_Conhecimento_Serie);
        vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETERT',tpValeFrete.Glb_Rota_Codigo);
        vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETESQ',tpValeFrete.Con_Valefrete_Saque);
        vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETEUSU',tpValeFrete.Usu_Usuario_Codigo);

            Begin
               PKG_CON_VALEFRETE.sp_con_CalcValefrete(p_vfnumero   => tpValeFrete.Con_Conhecimento_Codigo,
                                                      p_vfserie    => tpValeFrete.Con_Conhecimento_Serie,
                                                      p_vfrota     => tpValeFrete.Glb_Rota_Codigo,
                                                      p_vfsaque    => tpValeFrete.Con_Valefrete_Saque,
                                                      p_DescDebito => 'S',
                                                      p_status     => vP_STATUS,
                                                      p_message    => vP_MESSAGE);
               Commit;
            Exception
              When OTHERS Then
--                pMessage := pMessage  || '*** ERRO CALCULANDO ***'|| chr(10); 
                tpVfreteColeta.Con_Vfretecoleta_Recalcula := tpVfreteColeta.Con_Vfretecoleta_Recalcula;
              End;
            Begin
               PKG_CON_VALEFRETE.SP_CON_ATUCALCVALEFRETE(vP_QUERYSTR,
                                                         vP_STATUS,
                                                         vP_MESSAGE,
                                                         vP_CURSOR);
            
               Commit;
            Exception
              When OTHERS Then
--                pMessage := pMessage  || '*** ERRO NA CALC ***'|| chr(10); 
                tpVfreteColeta.Con_Vfretecoleta_Recalcula := tpVfreteColeta.Con_Vfretecoleta_Recalcula;
              End;

        update tdvadm.t_fcf_veiculodisp vd
          set vd.fcf_veiculodisp_flagvalefrete = 'S'
        where vd.fcf_veiculodisp_codigo = tpValeFrete.Fcf_Veiculodisp_Codigo
          and vd.fcf_veiculodisp_sequencia = tpValeFrete.Cax_Movimento_Sequencia;
         

        -- Pega o Vale fe Frete para o CIOT
        If tpVfreteCiot.Con_Vfreteciot_Numero Is not null Then
           tpVfreteCiot.Con_Conhecimento_Codigo     := tpValeFrete.con_conhecimento_codigo;
           tpVfreteCiot.Con_Conhecimento_Serie      := tpValeFrete.con_conhecimento_serie;
           tpVfreteCiot.Glb_Rota_Codigo             := tpValeFrete.Glb_Rota_Codigo;
           tpVfreteCiot.Con_Valefrete_Saque         := tpValeFrete.Con_Valefrete_Saque;
           tpVfreteCiot.Con_Freteoper_Id            := vIdVeiculo;
           tpVfreteCiot.Con_Freteoper_Rota          := vRotaIdVeiculo;
           insert into tdvadm.t_con_vfreteciot values tpVfreteCiot;

           update t_vgm_viagem v
             set v.vgm_viagem_dtfechamento = sysdate
           where v.vgm_viagem_codigo = vCodigoViagem
             and v.glb_rota_codigo = vRotaViagem;
           commit;

           Begin  
              vQueryStringIntegra := replace(vQueryStringIntegra,'<<CODINTEGRA>>','35');
              vQueryStringIntegra := replace(vQueryStringIntegra,'<<VFCODIGO>>',tpValeFrete.Con_Conhecimento_Codigo);
              vQueryStringIntegra := replace(vQueryStringIntegra,'<<VFSERIE>>',tpValeFrete.Con_Conhecimento_Serie);
              vQueryStringIntegra := replace(vQueryStringIntegra,'<<VFROTA>>',tpValeFrete.Glb_Rota_Codigo);
              vQueryStringIntegra := replace(vQueryStringIntegra,'<<VFSAQUE>>',tpValeFrete.Con_Valefrete_Saque);
              vQueryStringIntegra := replace(vQueryStringIntegra,'<<VFUSUARIO>>',tpValeFrete.Usu_Usuario_Codigo);
              vQueryStringIntegra := replace(vQueryStringIntegra,'<<VFUSUARIORT>>',tpValeFrete.Glb_Rota_Codigo);


              -- 02/03/2022 - Sirlano
              -- Habilitando a alteração de valores para evitar o pagamento do ciot da Coleta
              vQueryStringAltValores := replace(vQueryStringAltValores,'<<VFCODIGO>>',tpValeFrete.Con_Conhecimento_Codigo);
              vQueryStringAltValores := replace(vQueryStringAltValores,'<<VFSERIE>>',tpValeFrete.Con_Conhecimento_Serie);
              vQueryStringAltValores := replace(vQueryStringAltValores,'<<VFROTA>>',tpValeFrete.Glb_Rota_Codigo);
              vQueryStringAltValores := replace(vQueryStringAltValores,'<<VFSAQUE>>',tpValeFrete.Con_Valefrete_Saque);
              vQueryStringAltValores := replace(vQueryStringAltValores,'<<VFUSUARIO>>',tpValeFrete.Usu_Usuario_Codigo);
              vQueryStringAltValores := replace(vQueryStringAltValores,'<<VFUSUARIORT>>',tpValeFrete.Glb_Rota_Codigo);

              tdvadm.pkg_con_valefrete.SP_CON_SETALTERACAOVLR(P_QUERYSTR => vQueryStringAltValores ,
                                                              P_STATUS   => vP_STATUS,
                                                              P_MESSAGE  => vP_MESSAGE);
              pMessage := pMessage || vP_MESSAGE;
              If vP_STATUS <> 'N' Then
                 pStatus := 'E';
              End If;
           
--              PKG_CFE_FRETE.SP_SET_ALTERARCIOT(vQueryStringIntegra ,
--                                               vIdVeiculo,
--                                               vRotaIdVeiculo,
--                                               vP_MESSAGE,
--                                               vP_MESSAGE );
           Exception
             When OTHERS Then
--               pMessage := pMessage  || '*** ERRO ALTERANDO CIOT ***'|| chr(10) || sqlerrm; 
               tpVfreteColeta.Con_Vfretecoleta_Recalcula := tpVfreteColeta.Con_Vfretecoleta_Recalcula;
             End;




        End If;
        
       pMessage := pMessage || 'Gerado Vale de Frete nr ' || tpValeFrete.con_conhecimento_codigo || '-' || tpValeFrete.con_conhecimento_serie || '-' || tpValeFrete.Glb_Rota_Codigo || '-' || tpValeFrete.Con_Valefrete_Saque || chr(10);
     Exception
       When OTHERS Then
         pStatus := 'E';
         rollback;
         pMessage := pMessage || 'Erro Gerando VF - Erro ' || sqlerrm || chr(10);
       End;     

     -- Segunda Etapa
     Begin

        If vValeFrete2 = 'S' Then


            tpValeFrete.Con_Valefrete_Saque               := '2';
            If ( vvaleped = 'S' )  Then
               tpValeFrete.con_valefrete_pgvpedagio       := 'S';
            Else
               tpValeFrete.con_valefrete_pgvpedagio       := 'N';
            End If;       

            If (vpgtopedetp2 = 'CLI' ) Then
               tpValeFrete.con_valefrete_pgvpedagio       := 'S';
               tpValeFrete.con_valefrete_pedpgcli         := 'S';
            Else 
               tpValeFrete.con_valefrete_pedpgcli         := 'N';
            End If; 


           tpValeFrete.con_catvalefrete_codigo        := '09';
            
            -- Para duas etapas pagar 20%                                              
            tpValeFrete.con_valefrete_freteoriginal    := vFreteBase * ( vPerctetp2 / 100 ) ;
               -- Ver como vai pegar o pedagio da segunda etapa
            tpValeFrete.con_valefrete_pedagiooriginal  := vPedEtp2;


         -- Ver a DIRECAO DO PEDAGIO
         If tpValeFrete.con_valefrete_pedpgcli = 'S' Then
            tpValeFrete.con_valefrete_obrigacoes := 'Vale Pedagio pago pelo Cliente ';
            tpValeFrete.con_valefrete_pedagio          := 0;
         Else
            tpValeFrete.con_valefrete_obrigacoes := null;
            tpValeFrete.con_valefrete_pedagio          := vPedEtp2;
         End If;
         tpValeFrete.con_valefrete_obrigacoes :=  substr(tpValeFrete.con_valefrete_obrigacoes ||' [' || trim(vImpExpcontainer) || ']' ||
                                                                                                ' [' || trim(vImpExpdireserva) || ']' ||
                                                                                                ' [' || trim(vImpExprefcliente) || ']' ||
                                                                                                trim(vImpExpobs),1,199);


    --        tpValeFrete.con_valefrete_pedagio          := 0;
            tpValeFrete.con_valefrete_custocarreteiro  := tpValeFrete.con_valefrete_freteoriginal +
                                                          tpValeFrete.con_valefrete_pedagio;
                                                          
            tpValeFrete.con_valefrete_tipocusto        := 'U';
            tpValeFrete.con_valefrete_frete            := tpValeFrete.con_valefrete_custocarreteiro;

    --        tpValeFrete.con_valefrete_adiantamento     := tpValeFrete.con_valefrete_pedagio;   

--            tpValeFrete.con_valefrete_adiantamento     := tpValeFrete.con_valefrete_frete * 0.80;
            tpValeFrete.con_valefrete_adiantamento     := 0;
            If tpValeFrete.con_valefrete_adiantamento  < tpValeFrete.con_valefrete_pedagio Then
               tpValeFrete.con_valefrete_adiantamento     := tpValeFrete.con_valefrete_pedagio;   
            End If;

            tpValeFrete.con_valefrete_irrf             := 0;
            tpValeFrete.con_valefrete_inss             := 0;
            tpValeFrete.con_valefrete_sestsenat        := 0; 
            tpValeFrete.con_valefrete_valorliquido     := tpValeFrete.con_valefrete_frete - tpValeFrete.con_valefrete_adiantamento;

            tpValeFrete.con_valefrete_reembolso        := 0;
            tpValeFrete.con_valefrete_multa            := 0;
            tpValeFrete.con_valefrete_valorestiva      := 0;
            tpValeFrete.con_valefrete_valorvazio       := 0;
            tpValeFrete.con_valefrete_valorrateio      := 0;
            tpValeFrete.con_valefrete_valorcomdesconto := 0;
            tpValeFrete.con_valefrete_cofins           := 0;
            tpValeFrete.con_valefrete_csll             := 0;
            tpValeFrete.con_valefrete_pis              := 0;
            tpValeFrete.con_valefrete_avaria           := 0;
            tpValeFrete.con_valefrete_enlonamento      := 0;
            tpValeFrete.con_valefrete_estadia          := 0;
            tpValeFrete.con_valefrete_outros           := 0;

            tpValeFrete.con_valefrete_condespeciais    := '';

            dbms_lock.sleep(10);
            commit;
            -- Segundo VF
            Insert into tdvadm.t_con_valefrete vf values tpValeFrete;
    --        rollback;
            update tdvadm.t_fcf_fretecarmemo m
              set m.con_valefrete_codigo2 =  tpValeFrete.con_conhecimento_codigo,
                  m.con_valefrete_serie2 = tpValeFrete.con_conhecimento_serie,
                  m.glb_rota_codigo2 = tpValeFrete.Glb_Rota_Codigo,
                  m.con_valefrete_saque2 = tpValeFrete.Con_Valefrete_Saque,
                  m.fcf_fretecarmemo_pedagioetp2 = tpValeFrete.Con_Valefrete_Pedagio,
                  m.fcf_fretecarmemo_pedagioetp2tdvcli = tpValeFrete.Con_Valefrete_Pedpgcli,
                  m.fcf_fretecarmemo_dtvalefrete = tpValeFrete.Con_Valefrete_Datacadastro
            where m.fcf_solveic_cod = tpFCF_MEMO.Fcf_Solveic_Cod;

            update tdvadm.t_fcf_veiculodisp vd
              set vd.fcf_veiculodisp_flagvalefrete = 'S'
            where vd.fcf_veiculodisp_codigo = tpValeFrete.Fcf_Veiculodisp_Codigo
              and vd.fcf_veiculodisp_sequencia = tpValeFrete.Fcf_Veiculodisp_Sequencia;


            for c_msg in (select DISTINCT C.CON_CONHECIMENTO_CODIGO,
                                          C.CON_CONHECIMENTO_SERIE,
                                          C.GLB_ROTA_CODIGO,
                                          C.CON_CONHECIMENTO_DTEMBARQUE,
                                          CALC.SLF_TPCALCULO_CODIGO
                            from tdvadm.t_fcf_fretecarmemo m,
                               tdvadm.t_fcf_veiculodisp vd,
                               tdvadm.t_arm_carregamento ca,
                               tdvadm.t_arm_carregamentodet cd,
                               TDVADM.T_CON_CONHECIMENTO C,
                               t_con_calcconhecimento caLC,
                               tdvadm.t_arm_nota nt
                          where m.fcf_veiculodisp_codigo = tpFCF_MEMO.Fcf_Veiculodisp_Codigo
                            AND M.FCF_VEICULODISP_SEQUENCIA = tpFCF_MEMO.Fcf_Veiculodisp_Sequencia   
                            and m.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
                            and m.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia
                            and m.fcf_veiculodisp_codigo = ca.fcf_veiculodisp_codigo
                            and m.fcf_veiculodisp_sequencia = ca.fcf_veiculodisp_sequencia
                            and ca.arm_carregamento_codigo = cd.arm_carregamento_codigo
                            and cd.arm_embalagem_numero = nt.arm_embalagem_numero
                            and cd.arm_embalagem_flag = nt.arm_embalagem_flag
                            and cd.arm_embalagem_sequencia = nt.arm_embalagem_sequencia
                            AND NT.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
                            AND NT.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
                            AND NT.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
                            AND NT.CON_CONHECIMENTO_CODIGO = CALC.CON_CONHECIMENTO_CODIGO
                            AND NT.CON_CONHECIMENTO_SERIE = CALC.CON_CONHECIMENTO_SERIE
                            AND NT.GLB_ROTA_CODIGO = CALC.GLB_ROTA_CODIGO
                            AND CALC.SLF_RECCUST_CODIGO = 'D_FRPSVO')
            Loop
               tpVfreteConhec.Con_Valefrete_Codigo           := tpValeFrete.Con_Conhecimento_Codigo;
               tpVfreteConhec.Con_Valefrete_Serie            := tpValeFrete.Con_Conhecimento_Serie;
               tpVfreteConhec.Glb_Rota_Codigovalefrete       := tpValeFrete.Glb_Rota_Codigo;
               tpVfreteConhec.Con_Valefrete_Saque            := tpValeFrete.Con_Valefrete_Saque;
               tpVfreteConhec.Glb_Rota_Codigo                := c_msg.glb_rota_codigo;
               tpVfreteConhec.Con_Conhecimento_Codigo        := c_msg.con_conhecimento_codigo;
               tpVfreteConhec.Con_Conhecimento_Serie         := c_msg.con_conhecimento_serie;
               tpVfreteConhec.Con_Vfreteconhec_Recalcula     := 'S';
               tpVfreteConhec.Slf_Tpcalculo_Codigo           := c_msg.slf_tpcalculo_codigo;
               tpVfreteConhec.Con_Vfreteconhec_Saldo         := 0;
               tpVfreteConhec.Con_Vfreteconhec_Pedagio       := 0;
               tpVfreteConhec.Con_Vfreteconhec_Rateioreceita := 0; 
               tpVfreteConhec.Con_Vfreteconhec_Rateiofrete   := 0;
               tpVfreteConhec.Con_Vfreteconhec_Rateiopedagio := 0;
               tpVfreteConhec.Con_Vfreteconhec_Dtentrega     := null;
               tpVfreteConhec.Con_Vfreteconhec_Rateioicmiss  := 0;
               tpVfreteConhec.Con_Vfreteconhec_Dtgravacao    := sysdate;
               tpVfreteConhec.Con_Vfreteconhec_Usumaq        := null;
               tpVfreteConhec.Con_Vfreteconhec_Transfchekin  := null;
               tpVfreteConhec.Arm_Armazem_Codigo             := null;
            
               insert into tdvadm.t_con_vfreteconhec
               values tpVfreteConhec;
            
            End Loop;



            For c_msg in (SELECT rpad(x.JScoleta,6) JScoleta,
                                 rpad(x.JSciclo,3) JSciclo,
                                 JSON_VALUE(pJSColetas, '$.contrato') contratoFE,
                                 JSON_VALUE(pJSColetas, '$.armazem') armazem,
                                 JSON_VALUE(pJSColetas, '$.usuario') usuario,
                                 c.*
                          FROM tdvadm.v_arm_coletaorigemdestinojava c,
                               JSON_TABLE (pJSColetas,'$ .coletas [*]'
                                      COLUMNS (JSColeta varchar2(6) PATH '$ .coleta',
                                               JSCiclo  varchar2(3) PATH '$ .ciclo')) AS x
                          where c.coleta = x.JScoleta
                            and c.ciclo  = X.JSciclo)  
            loop
               tpVfreteColeta.Con_Valefrete_Codigo       := tpValeFrete.con_conhecimento_codigo;
               tpVfreteColeta.Con_Valefrete_Serie        := tpValeFrete.con_conhecimento_serie;
               tpVfreteColeta.Glb_Rota_Codigovalefrete   := tpValeFrete.Glb_Rota_Codigo;
               tpVfreteColeta.Con_Valefrete_Saque        := tpValeFrete.Con_Valefrete_Saque;
               tpVfreteColeta.Arm_Coleta_Ncompra         := c_msg.coleta;
               tpVfreteColeta.Arm_Coleta_Ciclo           := c_msg.ciclo;
               tpVfreteColeta.Con_Vfretecoleta_Recalcula := 'S';
               insert into tdvadm.t_con_vfretecoleta values tpVfreteColeta;

               Update tdvadm.t_arm_coleta co
                  set co.slf_contrato_codigo = c_msg.contratoFE
               where co.arm_coleta_ncompra = c_msg.coleta
                 and co.arm_coleta_ciclo = c_msg.ciclo
                 and co.slf_contrato_codigo is null;
            End Loop;
            

            commit;
            vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETENR',tpValeFrete.Con_Conhecimento_Codigo);
            vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETESR',tpValeFrete.Con_Conhecimento_Serie);
            vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETERT',tpValeFrete.Glb_Rota_Codigo);
            vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETESQ',tpValeFrete.Con_Valefrete_Saque);
            vP_QUERYSTR := replace(vP_QUERYSTR,'VFRETEUSU',tpValeFrete.Usu_Usuario_Codigo);

            Begin
               PKG_CON_VALEFRETE.sp_con_CalcValefrete(p_vfnumero   => tpValeFrete.Con_Conhecimento_Codigo,
                                                      p_vfserie    => tpValeFrete.Con_Conhecimento_Serie,
                                                      p_vfrota     => tpValeFrete.Glb_Rota_Codigo,
                                                      p_vfsaque    => tpValeFrete.Con_Valefrete_Saque,
                                                      p_DescDebito => 'S',
                                                      p_status     => vP_STATUS,
                                                      p_message    => vP_MESSAGE);
              commit;                                         
            Exception
              When OTHERS Then
--                pMessage := pMessage  || '*** ERRO CALCULANDO ***'|| chr(10); 
                tpVfreteColeta.Con_Vfretecoleta_Recalcula := tpVfreteColeta.Con_Vfretecoleta_Recalcula;
              End;
            Begin
               PKG_CON_VALEFRETE.SP_CON_ATUCALCVALEFRETE(vP_QUERYSTR,
                                                         vP_STATUS,
                                                         vP_MESSAGE,
                                                         vP_CURSOR);
            
              commit;                                         

            Exception
              When OTHERS Then
--                pMessage := pMessage  || '*** ERRO NA CALC ***'|| chr(10); 
                tpVfreteColeta.Con_Vfretecoleta_Recalcula := tpVfreteColeta.Con_Vfretecoleta_Recalcula;
              End;
               
              pMessage := pMessage || 'Gerado Vale de Frete nr ' || tpValeFrete.con_conhecimento_codigo || '-' || tpValeFrete.con_conhecimento_serie || '-' || tpValeFrete.Glb_Rota_Codigo || '-' || tpValeFrete.Con_Valefrete_Saque || chr(10);

              
        End If;               

        update tdvadm.t_fcf_veiculodisp vd
          set vd.fcf_veiculodisp_flagvalefrete = 'S'
        where vd.fcf_veiculodisp_codigo = tpValeFrete.Fcf_Veiculodisp_Codigo
          and vd.fcf_veiculodisp_sequencia = tpValeFrete.Cax_Movimento_Sequencia;

        commit;
     Exception
       When OTHERS Then
         pStatus := 'E';
         rollback;
         pMessage := pMessage || 'Erro Gerando VF - Erro ' || sqlerrm || chr(10);
       End;     
     
  End If;

  If pStatus <> 'E' Then
     dbms_output.put_line(pMessage);
  Else
     dbms_output.put_line('Erro' || chr(10) || pMessage);
  End If;




end;
/
