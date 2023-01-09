create or replace package Pkg_Fcf_VeiculoDisp is
   procedure sp_set_fretememo(pSolveic     in tdvadm.t_fcf_solveic.fcf_solveic_cod%type,
                             pVDCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                             pVDSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                             pAcao        in Varchar2,
                             pStatus      out char,
                             pMessage     out varchar2);
  
   procedure sp_set_solveic(pQuery in varchar2,
                              pStatus out char,
                              pMessage out varchar2);

   procedure sp_VinculaDesvinculaFrete(pQuery in varchar2,                                       
                                       pStatus out char,
                                       pMessage out varchar2);                            

   /*
    * Busca Tipo do VeicDisp (RowType)
    */
    
   vMemoriaCalculo varchar2(20000);
    
   Function Fn_Get_VeiculoDispRowType(pCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                      pSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return t_fcf_veiculodisp%RowType;

   Function Fn_Get_DescricaoTpVeiculo(pCodigoTpVeiculo In t_Fcf_Veiculodisp.Fcf_Tpveiculo_Codigo%Type) return t_fcf_tpveiculo.fcf_tpveiculo_descricao%Type;      

   Function Fn_Get_DescricaoTpVeiculo2(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                       pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return t_fcf_tpveiculo.fcf_tpveiculo_descricao%Type;

   Function Fn_Busca_PlacaVeiculo(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                  pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return Varchar2;
                                  
   
   Function FN_GETPLACA(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                        pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return Varchar2;
                         
   Function Fn_Get_TpFrotaAgregadoOutros(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                         pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return Varchar2;   
            
   Function Fn_ContemValeFreteGerado(pVeicDispCodigo In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                     pVeicDispSeq    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Sequencia%Type) return char;   
   
   Function Fn_CriaVeicVirtual( pCarregamento in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                pTpVeiculo    In t_Fcf_Tpveiculo.Fcf_Tpveiculo_Codigo%Type) return char;     


  Function fn_retorna_solveic(pVDispCodigo in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                                     pVDispSeq    in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type)
        return tdvadm.t_fcf_solveic.fcf_solveic_cod%type;
        
  Function fn_retorna_solveicpart(pSolveic in tdvadm.t_fcf_solveic.fcf_solveic_cod%type) 
     return char;
        
  Function fn_retorna_solveicpartorig(pSolveic in tdvadm.t_fcf_solveic.fcf_solveic_cod%type) 
     return char;

  Function fn_retorna_solveicpartdest(pSolveic in tdvadm.t_fcf_solveic.fcf_solveic_cod%type) 
     return char;
     
  Function Fn_GetDataPorCodigoEstagio(pVeiculoDispCodigo In Tdvadm.t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%type,
                                      pEstagio           In Char) return Date;     
     
  function fn_recalculoMesaVF(pValeFreteCod    tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                              pValeFreteSr     tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                              pValeFreteRt     tdvadm.t_con_valefrete.glb_rota_codigo%type,
                              pValeFreteSq     tdvadm.t_con_valefrete.con_valefrete_saque%type) return number;

  function fn_memoriarecalculo(pValeFreteCod    tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                               pValeFreteSr     tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                               pValeFreteRt     tdvadm.t_con_valefrete.glb_rota_codigo%type,
                               pValeFreteSq     tdvadm.t_con_valefrete.con_valefrete_saque%type) return varchar2;


  
                                     
end Pkg_Fcf_VeiculoDisp;

 
/
create or replace package body Pkg_Fcf_VeiculoDisp is

   procedure sp_set_fretememo(pSolveic     in tdvadm.t_fcf_solveic.fcf_solveic_cod%type,
                             pVDCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                             pVDSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type,
                             pAcao        in Varchar2,
                             pStatus      out char,
                             pMessage     out varchar2)
  As
    

  -- local variables her
--  v_solusada number;
--  V_ARMAZENSTRAVADOS T_USU_PERFIL.USU_PERFIL_PARAT%TYPE;
--  v_forcaatualizacao  number;
--  vMsg  varchar2(1000);
--  vOrigemSolicitado  tdvadm.t_glb_localidade.glb_localidade_descricao%type;
--  vDestinoSolicitado tdvadm.t_glb_localidade.glb_localidade_descricao%type;
--  vOrigemSimulado    tdvadm.t_glb_localidade.glb_localidade_descricao%type;
--  vDestinoSimulado   tdvadm.t_glb_localidade.glb_localidade_descricao%type;
  
  /*    NOVO CONCEITO */
  -- Local variables here
  i integer;
  tpFretecarMemo   tdvadm.t_fcf_fretecarmemo%rowtype;
  tpSolVeic        tdvadm.t_fcf_solveic%rowtype;
--  tpvSolVeic       tdvadm.v_fcf_solveic%rowtype;
  vValorex         tdvadm.t_fcf_fretecarexc.fcf_fretecar_valor%type;
  vDesValorex      tdvadm.t_fcf_fretecarexc.fcf_fretecar_desinencia%type;
  vValorPart       tdvadm.t_fcf_solveicpart.fcf_solveicpart_valor%type;
  vValorporColeta  number;
  vValorporEntrega number;
  vPercentExpresso number;  
  vOrigem          tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vDestino         tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vOrigemI         tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vDestinoI        tdvadm.t_glb_localidade.glb_localidade_codigo%type;
  vDestinoV        tdvadm.t_glb_localidade.glb_localidade_codigo%type;

  vQtdeCol         number;
  vQtdeEntr        number;
  
begin

-- gravar log de idas e vindas

  
/* INICIO PROCESSO NOVO  */


  If pAcao = 'Descontratar' Then
     update tdvadm.t_fcf_fretecarmemo fm
       set fm.fcf_veiculodisp_codigo = null,
           fm.fcf_veiculodisp_sequencia = null,
           fm.fcf_fretecarmemo_eixos = null,
           fm.fcf_tpveiculo_codigo = null,
           fm.fcf_fretecarmemo_dtveicdisp = null,
           fm.glb_tpmotorista_codigo = null
     where fm.fcf_solveic_cod =  pSolveic;
     If sql%rowcount > 0 Then
        pStatus  := 'N';
        pMessage := 'Veiculo Desvinculado';
     Else
        pStatus  := 'E';
        pMessage := 'Solicitacao não encontrada';
     End If;   
     commit;
     return;     
  End If;
 
  select *
    into tpSolVeic
  from tdvadm.t_fcf_solveic s
  where s.fcf_solveic_cod = pSolveic;
  
  -- Pego os Valores quando existir alguma praça de exceção
  Begin
    select ex.fcf_fretecar_valor,
           ex.fcf_fretecar_desinencia
      into vValorex,
           vDesValorex
    from tdvadm.t_fcf_solveicdest vd,
         tdvadm.t_fcf_fretecarexc ex
    where vd.glb_localidade_codigo = ex.fcf_fretecar_localidade
      and trunc(ex.fcf_fretecar_vigencia) >= trunc(sysdate)
      and trunc(ex.fcf_fretecar_dtcadastro) <= trunc(sysdate)
      and vd.fcf_solveic_cod = pSolveic;
  exception
    When NO_DATA_FOUND Then
       vValorex := 0;
       vDesValorex := 'VL';
    End;

  -- Pego oos valores para as particularidades
  -- EX: MOP / RASTREADOR ....
  select sum(sp.fcf_solveicpart_valor)
    into vValorPart
  from tdvadm.t_fcf_solveicpart sp,
       tdvadm.t_fcf_particularidade p
  where sp.fcf_particularidade_cod = p.fcf_particularidade_cod
    and sp.fcf_solveic_cod = pSolveic;
  vValorPart := nvl(vValorPart,0);
  
  -- Pego os valores para pagamento das entregas e coletas
  Begin
      select nvl(p.usu_perfil_paran3,0),
             nvl(p.usu_perfil_paran6,0)
        into vValorporColeta,
             vValorporEntrega
      from tdvadm.t_usu_perfil p
      where p.usu_aplicacao_codigo = 'veicdisp'        
        and p.usu_perfil_ativo = 'S'
        and p.usu_perfil_codigo like trim('REGRAFRETE' || trim(tpSolVeic.FCF_TPVEICULO_CODIGO))
        and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                     from tdvadm.t_usu_perfil p1    
                                     where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                       and p1.usu_perfil_codigo = p.usu_perfil_codigo
                                       and p1.usu_perfil_vigencia <= tpSolVeic.FCF_SOLVEIC_DTCONTR);
        vValorporEntrega := nvl(vValorporEntrega,0);
        vValorporColeta  := nvl(vValorporColeta,0);
  exception
      When NO_DATA_FOUND Then
        vValorporEntrega := 0;
        vValorporColeta  := 0;
  End;

  -- Pego o Percentual para EXPRESSO
  If tpSolVeic.fcf_solveic_tpfrete = 'E' Then
    Begin 
      select nvl(p.usu_perfil_paran1,0)
        into vPercentExpresso
      from tdvadm.t_usu_perfil p
      where p.usu_aplicacao_codigo = 'veicdisp'
        and p.usu_perfil_codigo like 'PER_EXPRESSO'
        and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                     from tdvadm.t_usu_perfil p1    
                                     where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                       and p1.usu_perfil_codigo = p.usu_perfil_codigo
                                       and p1.usu_perfil_vigencia <= tpSolVeic.FCF_SOLVEIC_DTCONTR);
       If vPercentExpresso > 0 Then
          vPercentExpresso := (vPercentExpresso / 100);
       End If;
    exception
      When NO_DATA_FOUND Then
        vPercentExpresso := 0;
      End;
  Else
     vPercentExpresso := 0;
  End If;  

  -- Conta quantas origens e destinos tem
  select count(*)
     into vQtdeCol
  from tdvadm.t_fcf_solveicorig d
  where d.fcf_solveic_cod = tpSolVeic.fcf_solveic_cod;
  select count(*)
     into vQtdeEntr
  from tdvadm.t_fcf_solveicdest d
  where d.fcf_solveic_cod = tpSolVeic.fcf_solveic_cod;

  
  for c_msg in (select *
                from tdvadm.t_fcf_solveicorig o
                where o.fcf_solveic_cod = pSolveic
                order by o.fcf_solveicorig_ordem desc)
  Loop
     vOrigem  := c_msg.glb_localidade_codigo;
     vOrigemI := c_msg.glb_localidade_codigoIBGE;
  End Loop;
    
  If nvl(tpSolVeic.fcf_solveic_retornovazio,'N') = 'S' Then
      vQtdeEntr := vQtdeEntr - 1;
  End If;
  for c_msg in (select *
                from tdvadm.t_fcf_solveicdest d
                where d.fcf_solveic_cod = pSolveic
                order by d.fcf_solveicdest_ordem)
  Loop
     If c_msg.fcf_solveicdest_ordem = vQtdeEntr Then
        vDestino  := c_msg.glb_localidade_codigo;
        vDestinoI := c_msg.glb_localidade_codigoIBGE;
     Else
        --vDestinoV := c_msg.glb_localidade_codigo;
        -- Thiago -- variavel acima não está mais sendo utilizada
        vDestinoI := c_msg.glb_localidade_codigo;
     End If;
  End Loop;
  
  begin
     select *
       into tpFretecarMemo
     From tdvadm.t_fcf_fretecarmemo m
     where m.Fcf_Solveic_Cod = tpSolVeic.FCF_SOLVEIC_COD;
     
     --delete tdvadm.t_fcf_fretecarmemo m
     --where m.Fcf_Solveic_Cod = tpSolVeic.FCF_SOLVEIC_COD;
  Exception
    When NO_DATA_FOUND Then
      tpFretecarMemo.Fcf_Solveic_Cod := tpSolVeic.FCF_SOLVEIC_COD;
    End;
  
  -- Thiago - verificar a lógica desse select pois quando não existir na fretecar tem que dar um alerta
  
  --for c_msg in (select *
  --              from tdvadm.t_fcf_fretecar fc
  --              where fc.fcf_fretecar_origemi = vOrigemI
  --                --and fc.fcf_fretecar_destinoi = vDestinoI
  --                -- Thiago - alterado para coluna destino pq nao estamos passando o código IBGE
  --                and fc.fcf_fretecar_destino = vDestinoI
  --                and fc.fcf_tpveiculo_codigo = tpSolVeic.fcf_tpveiculo_codigo
  --                )
  --Loop

    -- Somente quando vincular um veiculo
    tpFretecarMemo.Fcf_Veiculodisp_Codigo           := pVDCodigo;--tpSolVeic.fcf_veiculodisp_codigo;
    tpFretecarMemo.Fcf_Veiculodisp_Sequencia        := pVDSequencia;--tpSolVeic.fcf_veiculodisp_sequencia;
    tpFretecarMemo.Fcf_Tpveiculo_Codigo             := tpSolVeic.fcf_tpveiculo_codigo;
    

    Begin
      select substr(tdvadm.fn_rettp_motorista(vd.car_veiculo_placa,vd.car_veiculo_saque,trunc(sysdate)),1,1),
             tdvadm.f_retornanumeixos(vd.car_veiculo_placa)
         into tpFretecarMemo.Glb_Tpmotorista_Codigo,
              tpfretecarMemo.Fcf_Fretecarmemo_Eixos
      from tdvadm.t_fcf_veiculodisp vd
      where vd.fcf_veiculodisp_codigo = pVDCodigo --tpFretecarMemo.Fcf_Veiculodisp_Codigo
        and vd.fcf_veiculodisp_sequencia = pVDSequencia; --tpFretecarMemo.Fcf_Veiculodisp_Sequencia;
    exception
      When NO_DATA_FOUND Then
         -- Verificar quando for FROTA        
         tpFretecarMemo.Glb_Tpmotorista_Codigo := 'X';
         tpfretecarMemo.Fcf_Fretecarmemo_Eixos := -1;
      End; 

    tpFretecarMemo.Fcf_Fretecarmemo_Dtveicdisp      := sysdate;



    -- Sistema de Solictação de acrescimo
--    tpFretecarMemo.Cad_Frete_Codigo                 := null;
    tpFretecarMemo.Fcf_Fretecarmemo_Acrescimo       := nvl(tpFretecarMemo.Fcf_Fretecarmemo_Acrescimo,0); 
    tpFretecarMemo.Fcf_Fretecarmemo_Ajudante        := nvl(tpFretecarMemo.Fcf_Fretecarmemo_Ajudante,0);
--    tpFretecarMemo.Fcf_Fretecarmemo_Dtcadfrete      := null;

    -- Verificar ANTT  
    tpFretecarMemo.Fcf_Tpfantt_Codigo               := nvl(tpFretecarMemo.Fcf_Tpfantt_Codigo,'01');
    tpfretecarMemo.Fcf_Antt_Valorf                  := NVL(tpfretecarMemo.Fcf_Antt_Valorf,0);   
    tpfretecarMemo.Fcf_Antt_Valorkm                 := NVL(tpfretecarMemo.Fcf_Antt_Valorkm,0);


    -- Somente quanto fizer um Vale de Frete
--    tpFretecarMemo.Con_Valefrete_Codigo             := null;
--    tpFretecarMemo.Con_Valefrete_Serie              := null;
--    tpFretecarMemo.Glb_Rota_Codigo                  := null;
--    tpFretecarMemo.Con_Valefrete_Saque              := null;
    tpfretecarMemo.Fcf_Fretecarmemo_Perigoso        := nvl(tpfretecarMemo.Fcf_Fretecarmemo_Perigoso,'N');
--    tpFretecarMemo.Fcf_Fretecarmemo_Dtvalefrete     := null;

/*
    tpFretecarMemo.Fcf_Tpveiculo_Codigo             := c_msg.fcf_tpveiculo_codigo;
    tpFretecarMemo.Fcf_Fretecar_Rowid               := c_msg.fcf_fretecar_rowid;
    tpFretecarMemo.Fcf_Fretecarmemo_Tpfrete         := tpSolVeic.fcf_solveic_tpfrete;
    tpFretecarMemo.Fcf_Fretecarmemo_Frete           := c_msg.fcf_fretecar_valor;
    tpFretecarMemo.Fcf_Fretecarmemo_Desinenciafrete := c_msg.fcf_fretecar_desinencia;
    tpFretecarMemo.Fcf_Fretecarmemo_Pedagio         := c_msg.fcf_fretecar_pedagio;
    tpFretecarMemo.Fcf_Fretecarmemo_Pedagionofrete  := c_msg.fcf_fretecar_pednofrete;
    tpFretecarMemo.Fcf_Fretecarmemo_Qtdeentrega     := vQtdeEntr; 
    tpFretecarMemo.Fcf_Fretecarmemo_Entrega         := vValorporEntrega * tpFretecarMemo.Fcf_Fretecarmemo_Qtdeentrega;
    tpFretecarMemo.Fcf_Fretecarmemo_Qtdecoleta      := vQtdeCol;
    tpFretecarMemo.Fcf_Fretecarmemo_Coleta          := vValorporColeta * tpFretecarMemo.Fcf_Fretecarmemo_Qtdecoleta;
    tpFretecarMemo.Fcf_Fretecarmemo_Excecao         := vValorex;   
    tpFretecarMemo.Fcf_Fretecarmemo_Particularidade := vValorPart;
    tpFretecarMemo.Fcf_Fretecarmemo_Percentexpr     := vPercentExpresso;
    tpFretecarMemo.Fcf_Fretecarmemo_Expresso        := vPercentExpresso * tpFretecarMemo.Fcf_Fretecarmemo_Frete ;
    tpFretecarMemo.Fcf_Fretecarmemo_Dtsolveic       := tpSolVeic.FCF_SOLVEIC_DTCONTR;
    tpFretecarMemo.Fcf_Fretecarmemo_Km              := c_msg.fcf_fretecar_km;
    tpfretecarMemo.Fcf_Antt_Retornovazio            := nvl(tpSolVeic.fcf_solveic_retornovazio,'N');
    tpfretecarMemo.Glb_Cep_Codigoretornovazio       := vDestinoV;
    tpfretecarMemo.Fcf_Antt_Container               := nvl(tpSolVeic.fcf_solveic_container ,'N');
    tpfretecarMemo.fcf_fretecarmemo_kmcoleta        := null;

    -- Caso mudar os eixos no veiculo disp recalcular
    for c_msg in (select a.slf_reccust_codigo,
                         a.fcf_antt_valor,
                         a.fcf_antt_desinencia,
                         a.fcf_antt_valorp,
                         a.fcf_antt_desinenciap
                  from tdvadm.t_fcf_antt a
                  where a.fcf_tpfantt_codigo = tpfretecarMemo.Fcf_Tpfantt_Codigo
                    and a.glb_tpmotorista_codigo = tpfretecarMemo.Glb_Tpmotorista_Codigo
                    and a.fcf_antt_nreixos = tpfretecarMemo.Fcf_Fretecarmemo_Eixos
                    and a.fcc_antt_ativo = 'S'
                    and a.fcf_antt_vigencia = (select max(a1.fcf_antt_vigencia)
                                               from tdvadm.t_fcf_antt a1
                                               where a1.fcf_tpfantt_codigo = a.fcf_tpfantt_codigo
                                                 and a1.slf_reccust_codigo = a.slf_reccust_codigo
                                                 and a1.glb_tpmotorista_codigo = a.glb_tpmotorista_codigo
                                                 and a1.fcf_antt_nreixos = a.fcf_antt_nreixos
                                                 and a1.fcc_antt_ativo = 'S'))
    loop


       If c_msg.slf_reccust_codigo = 'S_CCF' Then
          If NVL(tpFretecarMemo.fcf_fretecarmemo_perigoso,'N') = 'N' Then
             tpFretecarMemo.Fcf_Antt_Valorf := c_msg.fcf_antt_valor;
          Else
             tpFretecarMemo.Fcf_Antt_Valorf := c_msg.fcf_antt_valorp;
          End If;
       End If;
       If c_msg.slf_reccust_codigo = 'S_CCD' Then
          If NVL(tpFretecarMemo.fcf_fretecarmemo_perigoso,'N') = 'N' Then
             tpFretecarMemo.Fcf_Antt_Valorkm := c_msg.fcf_antt_valor;
          Else
             tpFretecarMemo.Fcf_Antt_Valorkm := c_msg.fcf_antt_valorp;
          End If;
       End if; 
      
    End Loop;
*/
                    
/*    
01  Carga Geral
02  Granel Solido
03  Granel Liquido
04  Neo Granel
05  Conteinerizada
06  Frigorificada
07  Carga Pressurizada
*/

    delete tdvadm.t_fcf_fretecarmemo fm where fm.fcf_solveic_cod = tpFretecarMemo.Fcf_Solveic_Cod;

    insert into tdvadm.t_fcf_fretecarmemo values tpFretecarMemo;
--        update tdvadm.t_fcf_solveic sv
--      set --sv.fcf_solveic_tpdesconto,
          --sv.fcf_solveic_kmcoletas ,
          --sv.fcf_solveic_utlfechada,
          --sv.fcf_solveic_obsacrescimo,
          --sv.fcf_solveic_obsvalefrete,
          --sv.fcf_solveic_desconto,

/* Como vou atualizar estas
          :NEW.fcf_solveic_tpfrete := tpFretecarMemo.Fcf_Fretecarmemo_Tpfrete;
          :NEW.fcf_fretecar_rowid := tpFretecarMemo.Fcf_Fretecar_Rowid;
          :NEW.fcf_solveic_qtdecoletas := tpFretecarMemo.Fcf_Fretecarmemo_Qtdecoleta;
          :NEW.fcf_solveic_qtdeentregas :=  tpFretecarMemo.Fcf_Fretecarmemo_Qtdeentrega;
          :NEW.fcf_solveic_valorfrete := tpFretecarMemo.Fcf_Fretecarmemo_Frete;
          :NEW.fcf_solveic_valorparticilaridade := vValorPart;
          :NEW.fcf_solveic_valorexcecao := vValorex;
          :NEW.fcf_solveic_acrescimo := ( tpFretecarMemo.Fcf_Fretecarmemo_Expresso )                       +
                                     ( vValorporColeta * tpFretecarMemo.Fcf_Fretecarmemo_Qtdecoleta )   +
                                     ( vValorporEntrega * tpFretecarMemo.Fcf_Fretecarmemo_Qtdeentrega ) + 
                                     ( tpFretecarMemo.Fcf_Fretecarmemo_Acrescimo );
          :NEW.fcf_solveic_pedagio := tpFretecarMemo.Fcf_Fretecarmemo_Pedagio;
          :NEW.fcf_solveic_pednofrete := tpFretecarMemo.Fcf_Fretecarmemo_Pedagionofrete;
          SELECT decode(tpFretecarMemo.Fcf_Fretecarmemo_Desinenciafrete,'TX','T','U')
             INTO :NEW.fcf_solveic_desinencia
          FROM DUAL;
--   where sv.fcf_solveic_cod = :new.fcf_solveic_cod;
*/
    
    commit;
  --End loop;
  
  
 




/***************************************************************************************************/  
    
  End sp_set_fretememo; 
    
   procedure sp_set_solveic(pQuery in varchar2,
                              pStatus out char,
                              pMessage out varchar2)
   As

   tpSolVeic         tdvadm.t_fcf_solveic%rowtype;
   tpSolVeicOrig     tdvadm.t_fcf_solveicorig%rowtype;
   tpSolVeicDest     tdvadm.t_fcf_solveicdest%rowtype;
   tpSolVeicPart     tdvadm.t_fcf_solveicpart%rowtype;
   tpSolVeicPassPor  tdvadm.t_fcf_solveicpassandopor%rowtype;
   tpSolVeicRetVazio tdvadm.t_fcf_solveicvazio%rowtype;   
   vSVRETVAZIO_COD   tdvadm.t_fcf_solveicvazio.glb_localidade_codigo%type;
   vOrigem    varchar2(300);
   vDestino   varchar2(300);   
   vPart      varchar2(100);
   vPassPor   varchar2(100);
   vRetVazio  varchar2(100);
   vRetornoVazio varchar2(100);
   vAuxiliar  varchar2(10);
   vAuxiliari number;
   tpFretecarMemo tdvadm.t_fcf_fretecarmemo%rowtype;   
   vParticularidade number;
   vPerigoso char(1);
   vTipoVazio tdvadm.t_fcf_solveicvazio.fcf_solveicretvazio_idaretorno%type;
   Begin
     Begin
        insert into tdvadm.t_glb_sql x values (pQuery,sysdate,'sp_set_solveic','CIOT');
        commit;
            tpSolVeic.Fcf_Solveic_Cod           := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVSOLVEIC_COD','=','*'), 'valor', '=', '|');   
            tpSolVeic.Fcf_Solveic_Peso          := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVPESO','=','*'), 'valor', '=', '|');
            tpSolVeic.Fcf_Solveic_Qtdentrega    := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVQTDENTREGA','=','*'), 'valor', '=', '|');
            tpSolVeic.Usu_Usuario_Soli          := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVUSUARIOSOLITACAO','=','*'), 'valor', '=', '|');

            tpSolVeic.Fcf_Solveic_Dtsoli        := to_date(TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVDTSOLI','=','*'), 'valor', '=', '|'),'dd/mm/yyyy hh24:mi:ss');

            tpSolVeic.Usu_Usuario_Contr         := null;--TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVUSUARIOCONTRATACAO','=','*'), 'valor', '=', '|');

            tpSolVeic.Fcf_Solveic_Dtcontr       := to_date(TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVDTCONTR','=','*'), 'valor', '=', '|'),'dd/mm/yyyy hh24:mi:ss');
            tpSolVeic.Fcf_Solveic_Dtprogramacao := to_date(TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVDTPROGRAMACAO','=','*'), 'valor', '=', '|'),'dd/mm/yyyy hh24:mi:ss');

            tpSolVeic.Usu_Usuario_Cancel        := null;--TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVUSUARIOCCANCELAMENTO','=','*'), 'valor', '=', '|');  

            tpSolVeic.Fcf_Solveic_Dtcancel      := to_date(TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVDTCANCEL','=','*'), 'valor', '=', '|'),'dd/mm/yyyy hh24:mi:ss');

            tpSolVeic.Fcf_Solveic_Obscancel     := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVOBSCANCEL','=','*'), 'valor', '=', '|');  
            tpSolVeic.Fcf_Solveic_Previsaodias  := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVPREVISAODIAS','=','*'), 'valor', '=', '|');  
            tpSolVeic.Fcf_Veiculodisp_Codigo    := null;--Trim(TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVVEICULODISP_CODIGO','=','*'), 'valor', '=', '|'));  
            tpSolVeic.Fcf_Veiculodisp_Sequencia := null;--Trim(TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVSEQUENCIA','=','*'), 'valor', '=', '|'));  
            tpSolVeic.Arm_Armazem_Codigo        := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVARMAZEM_CODIGO','=','*'), 'valor', '=', '|');
            tpSolVeic.Fcf_Tpveiculo_Codigo      := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVTPVEICULO_CODIGO','=','*'), 'valor', '=', '|');
            tpSolVeic.Fcf_Solveic_Hrprogramacao := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVHRPROGRAMACAO','=','*'), 'valor', '=', '|');
            tpSolVeic.Fcf_Solveic_Container     := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVCONTAINER','=','*'), 'valor', '=', '|');     
            tpSolVeic.Fcf_Solveic_Granelsolido  := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVGRANEL','=','*'), 'valor', '=', '|');     
            tpSolVeic.Fcf_Solveic_Retornovazio  := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVRETORNOVAZIO','=','*'), 'valor', '=', '|');     
            vSVRETVAZIO_COD                     := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVRETVAZIO_LOCALIDADE_COD','=','*'), 'valor', '=', '|');
            tpSolVeic.Slf_Contrato_Codigo       := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVCONTRATO','=','*'), 'valor', '=', '|');     
            tpSolVeic.Fcf_Solveic_Valorparticilaridade := null;
  /*                              
            'SVAplicacaoTDV=nome=SVAplicacaoTDV|tipo=String|valor=solveic*' + chr(10)+
            'SVVersaoAplicao=nome=SVVersaoAplicao|tipo=String|valor=' +  TDV_GLBLib.GetBuildInfo() +'*'+ chr(10);
  */

  --          tpSolVeic.Fcf_Solveic_Dtcontr

            /* linhas da vinculação da Mesa
            tpSolVeic.Fcf_Solveic_Tpdesconto,
            tpSolVeic.Fcf_Fretecar_Rowid,
            tpSolVeic.Fcf_Solveic_Qtdeentregas,
            tpSolVeic.Fcf_Solveic_Tpfrete,
            tpSolVeic.Fcf_Solveic_Obsacrescimo,
            tpSolVeic.Fcf_Solveic_Obsvalefrete,
            tpSolVeic.Fcf_Solveic_Qtdecoletas,
            tpSolVeic.Fcf_Solveic_Desconto,
            tpSolVeic.Fcf_Solveic_Valorfrete,
            tpSolVeic.Fcf_Solveic_Acrescimo,
            tpSolVeic.Fcf_Solveic_Kmcoletas,
            tpSolVeic.Fcf_Solveic_Utlfechada,
            tpSolVeic.Fcf_Solveic_Valorexcecao,
            tpSolVeic.Fcf_Solveic_Pedagio,
            tpSolVeic.Fcf_Solveic_Pednofrete,
            tpSolVeic.Fcf_Solveic_Desinencia
           */
           

           vOrigem       := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVORIGLOCALIDADE_CODIGO','=','*'), 'valor', '=', '|');   
           vDestino      := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVDESTLOCALIDADE_CODIGO','=','*'), 'valor', '=', '|');   
           vPart         := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVPART_COD','=','*'), 'valor', '=', '|');
           vPassPor      := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVPASSPOR_COD','=','*'), 'valor', '=', '|');
           vRetVazio     := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVRETVAZIO_COD','=','*'), 'valor', '=', '|');
           vRetornoVazio := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVRETORNOVAZIO','=','*'), 'valor', '=', '|');
           vTipoVazio    := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'SVVAZIO','=','*'), 'valor', '=', '|');
           


     dbms_output.put_line('Dentro da Proc Origem ' || vOrigem || '- Destino ' || vDestino || '- Part ' || vPart);


           tpSolVeic.Fcf_Solveic_Valorparticilaridade := tdvadm.F_EXTRAI(1,vPart,';');

           select max(sv.fcf_solveic_cod) + 1
              into tpSolVeic.Fcf_Solveic_Cod
           from tdvadm.t_fcf_solveic sv;
           /*
           begin 
           
             select *
               into tpFretecarMemo
             From tdvadm.t_fcf_fretecarmemo m
             where m.Fcf_Solveic_Cod = tpSolVeic.Fcf_Solveic_Cod;
             
           exception
             When NO_DATA_FOUND Then
               pStatus := '';
           end;
             
           delete tdvadm.t_fcf_fretecarmemo m
           where m.fcf_solveic_cod = tpSolVeic.Fcf_Solveic_Cod;
           */
           insert into tdvadm.t_fcf_solveic values tpSolVeic;
                    
           -- Thiago - 30/04/2020 - inclusão de dados na fretecarmemo
           Begin
             SELECT S.FCF_SOLVEIC_VALORPARTICILARIDADE
               INTO vParticularidade 
             FROM TDVADM.T_FCF_SOLVEIC S
             WHERE S.FCF_SOLVEIC_COD = tpSolVeic.Fcf_Solveic_Cod; 
            
             vParticularidade := nvl(vParticularidade, 0);
             if vParticularidade = 1 then
                vPerigoso := 'S';
             else
                vPerigoso := 'N';
             end if;
           Exception
             When NO_DATA_FOUND Then
                vPerigoso := 'N';
           End;
           
           tpFretecarMemo.Fcf_Solveic_Cod                   := tpSolVeic.Fcf_Solveic_Cod;
           tpFretecarMemo.Fcf_Fretecarmemo_Particularidade  := tpSolVeic.Fcf_Solveic_Valorparticilaridade;
           tpFretecarMemo.Fcf_Fretecarmemo_Dtsolveic        := tpSolVeic.Fcf_Solveic_Dtsoli;
           tpFretecarMemo.Fcf_Fretecarmemo_Perigoso         := vPerigoso;
           tpFretecarMemo.Fcf_Antt_Retornovazio             := tpSolVeic.Fcf_Solveic_Retornovazio;
           tpFretecarMemo.Fcf_Antt_Container                := tpSolVeic.Fcf_Solveic_Container;
           tpFretecarMemo.Arm_Armazem_Codigo                := tpSolVeic.Arm_Armazem_Codigo;
           tpFretecarMemo.Slf_Contrato_Codgo                := tpSolVeic.Slf_Contrato_Codigo;
           
           If tpSolVeic.Fcf_Solveic_Retornovazio = 'S' Then
              tpFretecarMemo.Glb_Cep_Codigoretornovazio := vSVRETVAZIO_COD;
           Else
              tpFretecarMemo.Glb_Cep_Codigoretornovazio := null;
           End If;
           
           insert into tdvadm.t_fcf_fretecarmemo values tpFretecarMemo;

           If length(trim(vOrigem)) >= 5 Then
              for vAuxiliari in 1..10
              loop
                 vAuxiliar := tdvadm.F_EXTRAI(vAuxiliari,vOrigem,';');
                 If nvl(vAuxiliar,'X') = 'X' Then
                    exit;
                 End If;

                select max(o.fcf_solveicorig_cod) + 1
                   into tpSolVeicOrig.fcf_solveicorig_cod
                from tdvadm.t_fcf_solveicorig o;

                tpSolVeicOrig.fcf_solveicorig_cod := nvl(tpSolVeicOrig.fcf_solveicorig_cod,1);

                tpSolVeicOrig.fcf_solveicorig_ordem     := vAuxiliari;
                tpSolVeicOrig.glb_localidade_codigo     := vAuxiliar;
                tpSolVeicOrig.glb_localidade_codigoibge := tdvadm.fn_busca_codigoibge(vAuxiliar,'IBC');
                tpSolVeicOrig.fcf_solveic_cod           := tpSolVeic.Fcf_Solveic_Cod;

                insert into tdvadm.t_fcf_solveicorig values tpSolVeicOrig;

                 
              end loop;
           End If; 
           


           If length(trim(vDestino)) >= 5 Then
              for vAuxiliari in 1..10
              loop
                 vAuxiliar := tdvadm.F_EXTRAI(vAuxiliari,vDestino,';');
                 If nvl(vAuxiliar,'X') = 'X' Then
                    exit;
                 End If;

                 select max(o.fcf_solveicDest_cod) + 1
                    into tpSolVeicDest.fcf_solveicdest_cod
                 from tdvadm.t_fcf_solveicdest o;
                 
                 tpSolVeicDest.fcf_solveicdest_cod := nvl(tpSolVeicDest.fcf_solveicdest_cod,1);
                   
                tpSolVeicDest.fcf_solveicdest_ordem     := vAuxiliari;
                tpSolVeicDest.glb_localidade_codigo     := vAuxiliar;
                tpSolVeicDest.glb_localidade_codigoibge := tdvadm.fn_busca_codigoibge(vAuxiliar,'IBC');
                tpSolVeicDest.fcf_solveic_cod           := tpSolVeic.Fcf_Solveic_Cod;
                insert into tdvadm.t_fcf_solveicdest values tpSolVeicDest;
                --commit;               
              end loop;
           End If; 


           If length(trim(vPart)) >= 1 Then
              for vAuxiliari in 1..10
              loop
                 vAuxiliar := tdvadm.F_EXTRAI(vAuxiliari,vPart,';');
                 If nvl(vAuxiliar,'X') = 'X' Then
                    exit;
                 End If;
                 
                 tpSolVeicPart.Fcf_Solveic_Cod         := tpSolVeic.Fcf_Solveic_Cod;
                 tpSolVeicPart.Fcf_Particularidade_Cod := vAuxiliar;

                 select fcf_particularidade_valor 
                   into tpSolVeicPart.Fcf_Solveicpart_Valor
                 from tdvadm.t_fcf_particularidade d
                 where d.fcf_particularidade_cod = tpSolVeicPart.Fcf_Particularidade_Cod;

                insert into tdvadm.t_fcf_solveicpart values tpSolVeicPart;
                 
              end loop;
           End If; 
           
           If (length(trim(vPassPor)) >= 1) AND (trim(vPassPor) <> '0') Then
              for vAuxiliari in 1..10
              loop
                 vAuxiliar := tdvadm.F_EXTRAI(vAuxiliari,vPassPor,';');
                 If nvl(vAuxiliar,'X') = 'X' Then
                    exit;
                 End If;
                 
                 SELECT TDVADM.SEQ_FCF_SOLVEICPASSPOR.NEXTVAL 
                   INTO tpSolVeicPassPor.Fcf_Solveicpassandopor_Cod
                 FROM DUAL;
                 
                 tpSolVeicPassPor.Fcf_Solveic_Cod            := tpSolVeic.Fcf_Solveic_Cod;
                 tpSolVeicPassPor.glb_localidade_codigo      := vAuxiliar;
                 tpSolVeicPassPor.glb_localidade_codigoibge  := tdvadm.fn_busca_codigoibge(vAuxiliar,'IBC');

                 select max(nvl(p.fcf_solveicpassandopor_cod, 0)) + 1
                    into tpSolVeicPassPor.Fcf_Solveicpassandopor_Cod
                 from tdvadm.t_fcf_solveicpassandopor p;
                
                tpSolVeicPassPor.Fcf_Solveicpassandopor_Cod := nvl( tpSolVeicPassPor.Fcf_Solveicpassandopor_Cod, 0 ) + 1;  
                insert into tdvadm.t_fcf_solveicpassandopor values tpSolVeicPassPor;
                 
              end loop;
           End If;
           
           -- Thiago - Alterado pois não estava entrando no if com essa condição
           -- If (length(trim(vRetVazio)) >= 1) AND (trim(vRetVazio) <> '0') AND (trim(vRetVazio) <> ';') Then
           If (trim(vRetVazio) = 0) Then
              for vAuxiliari in 1..10
              loop
                 vAuxiliar := tdvadm.F_EXTRAI(vAuxiliari,vRetVazio,';');
                 If nvl(vAuxiliar,'X') = 'X' Then
                    exit;
                 End If;
                 
                 tpSolVeicRetVazio.Fcf_Solveic_Cod              := tpSolVeic.Fcf_Solveic_Cod;
                 tpSolVeicRetVazio.Fcf_Solveicretvazio_Cod      := vAuxiliar;
                 -- Thiago - Incluidos os campos de localidade
                 tpSolVeicRetVazio.Glb_Localidade_Codigo        := vSVRETVAZIO_COD;
                 tpSolVeicRetVazio.Glb_Localidade_Codigoibge    := tdvadm.fn_busca_codigoibge(vSVRETVAZIO_COD,'IBC');
                 tpSolVeicRetVazio.Fcf_Solveicretvazio_Idaretorno := vTipoVazio;  

                 select max(nvl(r.Fcf_Solveicretvazio_Cod, 0)) 
                    into tpSolVeicRetVazio.Fcf_Solveicretvazio_Cod
                 from tdvadm.t_fcf_solveicvazio r;
                 
                tpSolVeicRetVazio.Fcf_Solveicretvazio_Cod :=  nvl(tpSolVeicRetVazio.Fcf_Solveicretvazio_Cod, 0)+1;
                insert into tdvadm.t_fcf_solveicvazio values tpSolVeicRetVazio;
                 
              end loop;
           End If;


      commit;

                         
      pStatus  := 'N';      
      pMessage := tpSolVeic.Fcf_Solveic_Cod || '-' || 'Solicitacao Criada Com Sucesso';      
    
    EXCEPTION
      WHEN OTHERS THEN
         pStatus  := tdvadm.pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao tentar criar a solicitação ' || chr(10) ||  Sqlerrm ;
      END;     

   End sp_set_solveic;
   
   procedure sp_VinculaDesvinculaFrete(pQuery in varchar2,                                       
                                       pStatus out char,
                                       pMessage out varchar2)
   As
     tpVeicDisp TDVADM.T_FCF_SOLVEIC%RowType;
     tpFreteCarMemo TDVADM.T_FCF_FRETECARMEMO%RowType;
     vTIPOVINCULO char(16);
     vC_QRYSTR            CLOB;
     vC_QRYSTR2           blob;
   Begin     
      
      Begin
          
          --vC_QRYSTR := glbadm.pkg_glb_blob.f_blob2clob(pQuery);
          -- Thiago 20/04/2021 - Incluido para testar versão atual da mesa e versão nova
          insert into tdvadm.t_glb_sql  values (pQuery,sysdate,'sp_VinculaDesvinculaFrete','vinculaDesvincula');
          
          vTIPOVINCULO                         := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDTIPOVINCULO','=','*'), 'valor', '=', '|');   
          tpVeicDisp.Fcf_Solveic_Cod           := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDSOLVEICCOD','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Fretecar_Rowid        := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDROWID','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Qtdeentregas  := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDQTDEENTREGAS','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Tpfrete       := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDTPFRETE','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Desconto      := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDDESCONTO','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Tpdesconto    := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDTPDESCONTO','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Valorfrete    := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDVALORFRETE','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Valorexcecao  := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDVALOREXCECAO','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Qtdecoletas   := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDQTDECOLETAS','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Kmcoletas     := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDKMCOLETAS','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Acrescimo     := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDACRESCIMO','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Pedagio       := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDPEDAGIO','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Pednofrete    := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDPEDNOFRETE','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Obsacrescimo  := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDOBSACRESCIMO','=','*'), 'valor', '=', '|');
          tpVeicDisp.Fcf_Solveic_Obsvalefrete  := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDOBSVALEFRETE','=','*'), 'valor', '=', '|');                    
          
          -- Thiago - 23/12/2020 - Inclusão de campos que estavam faltando 
          tpFreteCarMemo.Fcf_Fretecarmemo_Frete           := tpVeicDisp.Fcf_Solveic_Valorfrete;
          tpFreteCarMemo.Fcf_Fretecarmemo_Desinenciafrete := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDDESINENCIAFRETE','=','*'), 'valor', '=', '|');
          tpFreteCarMemo.Fcf_Fretecarmemo_Entrega         := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDENTREGA','=','*'), 'valor', '=', '|');
          tpFreteCarMemo.Fcf_Fretecarmemo_Coleta          := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDCOLETA','=','*'), 'valor', '=', '|');
          tpFreteCarMemo.Fcf_Fretecarmemo_Excecao         := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDEXCECAO','=','*'), 'valor', '=', '|');
          tpFreteCarMemo.Fcf_Fretecarmemo_Particularidade := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDPARTICULARIDADE','=','*'), 'valor', '=', '|');
          tpFreteCarMemo.Fcf_Fretecarmemo_Percentexpr     := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDPERCENTEXPR','=','*'), 'valor', '=', '|');
          tpFreteCarMemo.Fcf_Fretecarmemo_Expresso        := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDEXPRESSO','=','*'), 'valor', '=', '|');
          tpFreteCarMemo.Fcf_Fretecarmemo_Km              := TDVADM.fn_querystring(TDVADM.fn_querystring(pQuery,'VDKM','=','*'), 'valor', '=', '|');
          
          if NVL(tpVeicDisp.Fcf_Solveic_Cod, 0) <= 0 then
             pStatus  := 'N';
             pMessage := 'Código solicitação não encontrado.'; 
             
             Return;
          end if;
          
          if vTIPOVINCULO = 'VINCULA FRETE' then
            UPDATE T_FCF_SOLVEIC D 
               SET D.FCF_FRETECAR_ROWID       = tpVeicDisp.Fcf_Fretecar_Rowid,
                   D.FCF_SOLVEIC_QTDEENTREGAS = tpVeicDisp.Fcf_Solveic_Qtdeentregas,
                   D.FCF_SOLVEIC_TPFRETE      = tpVeicDisp.Fcf_Solveic_Tpfrete,
                   D.FCF_SOLVEIC_DESCONTO     = tpVeicDisp.Fcf_Solveic_Desconto,
                   D.FCF_SOLVEIC_TPDESCONTO   = tpVeicDisp.Fcf_Solveic_Tpdesconto,
                   D.FCF_SOLVEIC_VALORFRETE   = tpVeicDisp.Fcf_Solveic_Valorfrete,
                   D.Fcf_Solveic_Valorexcecao = tpVeicDisp.Fcf_Solveic_Valorexcecao,
                   D.FCF_SOLVEIC_QTDECOLETAS  = tpVeicDisp.Fcf_Solveic_Qtdecoletas,
                   D.FCF_SOLVEIC_KMCOLETAS    = tpVeicDisp.Fcf_Solveic_Kmcoletas,
                   D.FCF_SOLVEIC_ACRESCIMO    = tpVeicDisp.Fcf_Solveic_Acrescimo,
                   D.FCF_SOLVEIC_PEDAGIO      = tpVeicDisp.Fcf_Solveic_Pedagio,
                   D.FCF_SOLVEIC_PEDNOFRETE   = tpVeicDisp.Fcf_Solveic_Pednofrete,
                   D.FCF_SOLVEIC_OBSACRESCIMO = tpVeicDisp.Fcf_Solveic_Obsacrescimo,
                   D.FCF_SOLVEIC_OBSVALEFRETE = tpVeicDisp.Fcf_Solveic_Obsvalefrete
             WHERE D.FCF_SOLVEIC_COD = tpVeicDisp.Fcf_Solveic_Cod;      
             /* Thiago - Campos faltantes ainda no simulador
             F.FCF_FRETECARMEMO_FRETE           SIM_FCF_FRETECARMEMO_FRETE, -- 
             F.FCF_FRETECARMEMO_DESINENCIAFRETE SIM_FCF_FRETECARMEMO_DESINENCIAFRETE, --
             F.FCF_FRETECARMEMO_ENTREGA         SIM_FCF_FRETECARMEMO_ENTREGA, --
             F.FCF_FRETECARMEMO_COLETA          SIM_FCF_FRETECARMEMO_COLETA, --
             F.FCF_FRETECARMEMO_EXCECAO         SIM_FCF_FRETECARMEMO_EXCECAO, --
             F.FCF_FRETECARMEMO_PARTICULARIDADE SIM_FCF_FRETECARMEMO_PARTICULARIDADE, --
             F.FCF_FRETECARMEMO_PERCENTEXPR     SIM_FCF_FRETECARMEMO_PERCENTEXPR, --
             F.FCF_FRETECARMEMO_EXPRESSO        SIM_FCF_FRETECARMEMO_EXPRESSO, --
             F.FCF_FRETECARMEMO_KM              SIM_FCF_FRETECARMEMO_KM, --                           
            */
            -- Thiago - 30/04/2020 - Inclusão de informaçoes da mesa na fretecarmemo
                        
            --tpVeicDisp.Fcf_Veiculodisp_Codigo
            --tpVeicDisp.Fcf_Veiculodisp_Sequencia
            
            UPDATE T_FCF_FRETECARMEMO F
              SET F.FCF_VEICULODISP_CODIGO          = tpVeicDisp.Fcf_Veiculodisp_Codigo,
                  F.FCF_VEICULODISP_SEQUENCIA       = tpVeicDisp.Fcf_Veiculodisp_Sequencia,
                  F.FCF_TPVEICULO_CODIGO            = tpVeicDisp.Fcf_Tpveiculo_Codigo,
                  F.FCF_FRETECARMEMO_DTVEICDISP     = tpVeicDisp.Fcf_Solveic_Dtcontr, 
                  F.GLB_TPMOTORISTA_CODIGO          = NULL,--substr(tdvadm.fn_rettp_motorista(placa,
                                                      --                             saque,
                                                      --                             trunc(sysdate)
                                                      --                            ),
                                                      --   1,
                                                      --   1)
                                                      
                  -- Thiago - Inclusão de campos Simulador
                  F.FCF_FRETECAR_ROWID              = tpVeicDisp.Fcf_Fretecar_Rowid,
                  F.Fcf_Fretecarmemo_Tpfrete        = tpVeicDisp.Fcf_Solveic_Tpfrete,
                  F.Fcf_Fretecarmemo_Pedagio        = tpVeicDisp.Fcf_Solveic_Pedagio,
                  F.Fcf_Fretecarmemo_Pedagionofrete = tpVeicDisp.Fcf_Solveic_Pednofrete,
                  F.Fcf_Fretecarmemo_Qtdeentrega    = tpVeicDisp.Fcf_Solveic_Qtdeentregas,
                  F.Fcf_Fretecarmemo_Qtdecoleta     = tpVeicDisp.Fcf_Solveic_Qtdecoletas,
                  F.Fcf_Fretecarmemo_Excecao        = tpVeicDisp.Fcf_Solveic_Valorexcecao,
                  
                  -- Thiago - 23/12/2020 - Inclusão de campos que estavam faltando
                  F.FCF_FRETECARMEMO_FRETE           = tpFreteCarMemo.Fcf_Fretecarmemo_Frete,  
                  F.FCF_FRETECARMEMO_DESINENCIAFRETE = tpFreteCarMemo.Fcf_Fretecarmemo_Desinenciafrete, 
                  F.FCF_FRETECARMEMO_ENTREGA         = tpFreteCarMemo.Fcf_Fretecarmemo_Entrega, 
                  F.FCF_FRETECARMEMO_COLETA          = tpFreteCarMemo.Fcf_Fretecarmemo_Coleta, 
                  --F.FCF_FRETECARMEMO_EXCECAO         = tpFreteCarMemo.Fcf_Fretecarmemo_Excecao, 
                  F.FCF_FRETECARMEMO_PARTICULARIDADE = tpFreteCarMemo.Fcf_Fretecarmemo_Particularidade, 
                  F.FCF_FRETECARMEMO_PERCENTEXPR     = tpFreteCarMemo.Fcf_Fretecarmemo_Percentexpr, 
                  F.FCF_FRETECARMEMO_EXPRESSO        = tpFreteCarMemo.Fcf_Fretecarmemo_Expresso,
                  F.FCF_FRETECARMEMO_KM              = tpFreteCarMemo.Fcf_Fretecarmemo_Km, 
                  F.FCF_FRETECARMEMO_KMCOLETA        = tpVeicDisp.Fcf_Solveic_Kmcoletas  
            WHERE F.FCF_SOLVEIC_COD = tpVeicDisp.Fcf_Solveic_Cod;
            
            COMMIT;
            
            
            pStatus  := 'N';
            pMessage := 'Solicitação vinculada com sucesso.';
            
         elsif vTIPOVINCULO = 'DESVINCULA FRETE'then           
            UPDATE T_FCF_SOLVEIC D  
               SET D.FCF_FRETECAR_ROWID       = NULL,
                   D.FCF_SOLVEIC_QTDEENTREGAS = NULL,
                   D.FCF_SOLVEIC_TPFRETE      = NULL,
                   D.FCF_SOLVEIC_DESCONTO     = NULL,
                   D.FCF_SOLVEIC_TPDESCONTO   = NULL,
                   D.FCF_SOLVEIC_VALORFRETE   = NULL,
                   D.Fcf_Solveic_Valorexcecao = NULL,
                   D.FCF_SOLVEIC_QTDECOLETAS  = NULL,
                   D.FCF_SOLVEIC_KMCOLETAS    = NULL,
                   D.FCF_SOLVEIC_ACRESCIMO    = NULL,
                   D.FCF_SOLVEIC_PEDAGIO      = NULL,
                   D.FCF_SOLVEIC_PEDNOFRETE   = NULL,
                   D.FCF_SOLVEIC_OBSACRESCIMO = NULL,
                   D.FCF_SOLVEIC_OBSVALEFRETE = NULL
             WHERE D.FCF_SOLVEIC_COD = tpVeicDisp.Fcf_Solveic_Cod; 
            
            -- Thiago - 30/04/2020 - Limpeza de informações da mesa na fretecarmemo
            UPDATE T_FCF_FRETECARMEMO F
              SET F.FCF_VEICULODISP_CODIGO       = NULL,
                  F.FCF_VEICULODISP_SEQUENCIA    = NULL,
                  F.FCF_TPVEICULO_CODIGO         = NULL,
                  F.FCF_FRETECARMEMO_DTVEICDISP  = NULL, 
                  F.GLB_TPMOTORISTA_CODIGO       = NULL,
                  
                  -- Thiago - Inclusão de campos Simulador
                  F.FCF_FRETECAR_ROWID              = NULL,
                  F.Fcf_Fretecarmemo_Tpfrete        = NULL,
                  F.Fcf_Fretecarmemo_Pedagio        = NULL,
                  F.Fcf_Fretecarmemo_Pedagionofrete = NULL, 
                  F.Fcf_Fretecarmemo_Qtdeentrega    = NULL, 
                  F.Fcf_Fretecarmemo_Qtdecoleta     = NULL, 
                  F.Fcf_Fretecarmemo_Excecao        = NULL,
                  
                  -- Thiago - 23/12/2020 - Inclusão de campos que estavam faltando
                  F.FCF_FRETECARMEMO_FRETE           = NULL,  
                  F.FCF_FRETECARMEMO_DESINENCIAFRETE = NULL, 
                  F.FCF_FRETECARMEMO_ENTREGA         = NULL, 
                  F.FCF_FRETECARMEMO_COLETA          = NULL, 
                  --F.FCF_FRETECARMEMO_EXCECAO         = NULL,
                  F.FCF_FRETECARMEMO_PARTICULARIDADE = NULL, 
                  F.FCF_FRETECARMEMO_PERCENTEXPR     = NULL, 
                  F.FCF_FRETECARMEMO_EXPRESSO        = NULL,
                  F.FCF_FRETECARMEMO_KM              = NULL,
                  F.FCF_FRETECARMEMO_KMCOLETA        = NULL
            WHERE F.FCF_SOLVEIC_COD = tpVeicDisp.Fcf_Solveic_Cod;
            
            COMMIT; 
            
            pStatus  := 'N';
            pMessage := 'Solicitação desvinculada com sucesso.';    
         else
            pStatus  := 'E';
            pMessage := 'Nenhuma informação para ser atualizar.';
         end If;
         
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         pStatus  := tdvadm.pkg_glb_common.Status_Erro;
         pMessage := 'Solicitação não Encontrado';
      WHEN OTHERS THEN
         pStatus  := tdvadm.pkg_glb_common.Status_Erro;
         pMessage := 'Erro ao tentar alterar a solicitação ' || chr(10) ||  Sqlerrm ;
      END;
   End sp_VinculaDesvinculaFrete;
   
   /*
    * Busca Tipo do VeicDisp (RowType)
    */
   Function Fn_Get_VeiculoDispRowType(pCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                      pSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return t_fcf_veiculodisp%RowType
   As
     vVeicDispRowType t_fcf_veiculodisp%RowType;
   Begin
       Select *
         Into vVeicDispRowType
         From t_fcf_veiculodisp v
         where v.fcf_veiculodisp_codigo = pCodigo
           and v.fcf_veiculodisp_sequencia = pSequencia;
           
       return vVeicDispRowType;
   End Fn_Get_VeiculoDispRowType;
                                         
  
   Function Fn_Get_DescricaoTpVeiculo(pCodigoTpVeiculo In t_Fcf_Veiculodisp.Fcf_Tpveiculo_Codigo%Type) return t_fcf_tpveiculo.fcf_tpveiculo_descricao%Type
   As
   vTpDescricao t_Fcf_Tpveiculo.Fcf_Tpveiculo_Descricao%Type;
   Begin

     Begin
      Select t.fcf_tpveiculo_descricao
        into vTpDescricao
        from t_fcf_tpveiculo t
        where t.fcf_tpveiculo_codigo = pCodigoTpVeiculo;
     Exception
        When No_Data_Found Then
          vTpDescricao := '';
     End;  
     return vTpDescricao;
   End Fn_Get_DescricaoTpVeiculo;   
   
   Function Fn_Get_DescricaoTpVeiculo2(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                      pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return t_fcf_tpveiculo.fcf_tpveiculo_descricao%Type
   As
   vTpDescricao t_Fcf_Tpveiculo.Fcf_Tpveiculo_Descricao%Type;
   Begin

     Begin
       
      Select t.fcf_tpveiculo_descricao
        into vTpDescricao
        from t_fcf_veiculodisp v,
             t_fcf_tpveiculo t
        where v.fcf_tpveiculo_codigo = t.fcf_tpveiculo_codigo
          and v.fcf_veiculodisp_codigo = pVeicDispCodigo
          and v.fcf_veiculodisp_sequencia = pVeicDispSequencia;
          
     Exception
        When No_Data_Found Then
          vTpDescricao := '';
     End;  
     return vTpDescricao;
   End Fn_Get_DescricaoTpVeiculo2;  
   
   Function Fn_Busca_PlacaVeiculo(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                  pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return Varchar2
   As
      P_PLACA CHAR(8);
      VFRT_CONJVEICULO_CODIGO T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE;
   BEGIN
        BEGIN
        SELECT D.FRT_CONJVEICULO_CODIGO,
               D.CAR_VEICULO_PLACA
          INTO VFRT_CONJVEICULO_CODIGO,
               P_PLACA
          FROM T_FCF_VEICULODISP D
         WHERE D.FCF_VEICULODISP_CODIGO = pVeicDispCodigo
           AND D.FCF_VEICULODISP_SEQUENCIA = pVeicDispSequencia;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            VFRT_CONJVEICULO_CODIGO :=NULL;
            P_PLACA := NULL;
        END;

        IF P_PLACA IS NULL THEN
          BEGIN
            SELECT F_BUSCAPLACAFROTA(VFRT_CONJVEICULO_CODIGO)
              INTO P_PLACA
              FROM DUAL;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            P_PLACA := NULL;
            END;
        END IF;

        RETURN Trim(P_PLACA);       
   End fn_busca_placaveiculo;        
   
   Function FN_GETPLACA(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                        pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) 
   
   return Varchar2 AS
      vPLACA VARCHAR2(200);                       
   BEGIN
    SELECT T.PLACA
        INTO vPLACA
        FROM (  SELECT D.CAR_VEICULO_PLACA PLACA
                  FROM TDVADM.T_FCF_VEICULODISP D
                 WHERE D.FCF_VEICULODISP_CODIGO = pVeicDispCodigo
                   AND D.FCF_VEICULODISP_SEQUENCIA = pVeicDispSequencia
                   AND D.CAR_VEICULO_PLACA IS NOT NULL
                   AND D.FRT_CONJVEICULO_CODIGO IS NULL
                UNION
                SELECT B.FRT_VEICULO_PLACA PLACA
                  FROM TDVADM.T_FRT_CONTENG     A,
                       TDVADM.T_FRT_VEICULO     B,
                       TDVADM.T_FRT_MARMODVEIC  C,
                       TDVADM.T_FRT_TPVEICULO   D,
                       TDVADM.T_FCF_VEICULODISP VD
                 WHERE A.FRT_VEICULO_CODIGO = B.FRT_VEICULO_CODIGO
                   AND B.FRT_MARMODVEIC_CODIGO = C.FRT_MARMODVEIC_CODIGO
                   AND C.FRT_TPVEICULO_CODIGO = D.FRT_TPVEICULO_CODIGO
                   AND B.FRT_VEICULO_DATAVENDA IS NULL
                   AND D.FRT_TPVEICULO_TRACAO = 'S'
                   AND VD.FCF_VEICULODISP_CODIGO = pVeicDispCodigo
                   AND VD.FCF_VEICULODISP_SEQUENCIA = pVeicDispSequencia
                   AND VD.FRT_CONJVEICULO_CODIGO = A.FRT_CONJVEICULO_CODIGO
                   AND VD.CAR_VEICULO_PLACA IS NULL
                   AND VD.FRT_CONJVEICULO_CODIGO IS NOT NULL ) T;

       RETURN vPLACA;
   END FN_GETPLACA;
   
   
   Function Fn_Get_TpFrotaAgregadoOutros(pVeicDispCodigo    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                         pVeicDispSequencia In t_fcf_veiculodisp.fcf_veiculodisp_sequencia%Type) return Varchar2
   As
      P_PLACA CHAR(8);
      VFRT_CONJVEICULO_CODIGO T_FCF_VEICULODISP.FCF_VEICULODISP_CODIGO%TYPE;
   BEGIN
        BEGIN
        SELECT D.FRT_CONJVEICULO_CODIGO,
               D.CAR_VEICULO_PLACA
          INTO VFRT_CONJVEICULO_CODIGO,
               P_PLACA
          FROM T_FCF_VEICULODISP D
         WHERE D.FCF_VEICULODISP_CODIGO = pVeicDispCodigo
           AND D.FCF_VEICULODISP_SEQUENCIA = pVeicDispSequencia;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            VFRT_CONJVEICULO_CODIGO :=NULL;
            P_PLACA := NULL;
        END;

        IF P_PLACA IS NOT NULL THEN
           return 'AGREGADO';
        END IF;
        
        IF VFRT_CONJVEICULO_CODIGO IS NOT NULL THEN
           return 'FROTA';
        END IF;        

        RETURN NULL;       
   End Fn_Get_TpFrotaAgregadoOutros;                                       

   Function Fn_ContemValeFreteGerado(pVeicDispCodigo In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%Type,
                                     pVeicDispSeq    In t_Fcf_Veiculodisp.Fcf_Veiculodisp_Sequencia%Type) return char
   As
     vCount Integer;
   Begin
   
       Select Count(*)
          Into vCount
          From t_Fcf_Veiculodisp vd
          where vd.fcf_veiculodisp_codigo = pVeicDispCodigo
            and vd.fcf_veiculodisp_sequencia = pVeicDispSeq
            and vd.fcf_veiculodisp_flagvalefrete = 'S';  
            
       if vCount > 0 then
         return 'S';
       else
         return 'N';
       end if;
   
   End Fn_ContemValeFreteGerado;                                     

   /*******************************************************************************************************************
   * função utilizada para Criar um veiculo Virtual a partir de um carregamento e Tipo do Veículo                     *
   *******************************************************************************************************************/
   Function fn_CriaVeicVirtual( pCarregamento in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                pTpVeiculo    In t_Fcf_Tpveiculo.Fcf_Tpveiculo_Codigo%Type) return char is
   --Armazem para o veiculo virtual
   vArmaz_Virtual    tdvadm.t_arm_armazem.arm_armazem_codigo%type;
   --Rota para o Veiculo virtual
   vGlb_Rota_Virutal tdvadm.t_glb_rota.glb_rota_codigo%type;
   --Estado para o Veiculo virtual
   vUf_Virtual       tdvadm.t_glb_cliend.glb_estado_codigo%type;
   --Variável com o peso do carregamento
   vPesoCarreg       tdvadm.t_arm_carregamento.arm_carregamento_pesoreal%type;
   --Codigo do Veiculo virtual, essa variável será o retorno no final da função.
   vCodVeic_Virtual  tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
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
        raise_application_error(-20201, 'Carregamento não encontrado na busca do veiculo virtual.'||chr(13)||sqlerrm);
      
      /* Caso o Select retorne mais de uma linha, o que não deve ocorrer pois estou utilizado a chave primaria.  */
      WHEN TOO_MANY_ROWS THEN
        raise_application_error(-20202, 'Cursor com mais de uma linha.'||chr(13)||sqlerrm);
      
      /* Para qualquer outro tipo de erro */
      WHEN OTHERS THEN
        raise_application_error(-20203, 'Erro ao buscar Dados do carregamento'||chr(13)||sqlerrm);
    END;
    
    /* Após ter definido praticamente todos os dados para o veículo virtual, vou atribuir o Código do Veiculo */
    BEGIN
        select to_char(nvl(max(to_number(vd.fcf_veiculodisp_codigo)) + 1, 1)) 
         into vCodVeic_Virtual
         from t_fcf_veiculodisp vd ;
    EXCEPTION
      /* caso de algum tipo de erro... */
      WHEN OTHERS THEN
        raise_application_error(-20001, 'Erro ao buscar o código do veículo.'||chr(13)||sqlerrm);
    END;
    
    --Insiro os dados do novo veiuclo virtual, já com o carregamento, na tabela de Veiculos disponiveis
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
            pTpVeiculo,
            vArmaz_Virtual ,
            vCodVeic_Virtual,
            sysdate,
            vGlb_Rota_Virutal,
            pCarregamento,
            vUf_Virtual,
            'S',
            'sp_Desv' );
        
    EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(-20001, 'Erro ao tentar inserir Veículo virtual.'||chr(13)||sqlerrm);
    END;
    Commit;
    /* No final, retorno o Código do Veiculo virtual. Lembrando que para Veiculo virtual a seqüência sempre será zero. */
    return vCodVeic_Virtual;
  End;

  Function fn_retorna_solveic(pVDispCodigo in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type,
                              pVDispSeq    in tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type)
        return tdvadm.t_fcf_solveic.fcf_solveic_cod%type
    As
      vRetorno tdvadm.t_fcf_solveic.fcf_solveic_cod%type;
  Begin
     
      Begin 
          select sv.fcf_solveic_cod 
             into vRetorno
          from t_fcf_solveic sv
          where sv.fcf_veiculodisp_codigo = pVDispCodigo
            and sv.fcf_veiculodisp_sequencia = pVDispSeq;  
      exception
        When NO_DATA_FOUND Then
           vRetorno := '';
        end ; 
        
      return vRetorno;
       
     
    
  End fn_retorna_solveic;

  Function fn_retorna_solveicpartorig(pSolveic in tdvadm.t_fcf_solveic.fcf_solveic_cod%type) 
     return char
    As
      vRetorno varchar2(200);
    Begin
       vRetorno := '';
       for c_msg in (select fn_busca_codigoibge(o.glb_localidade_codigo,'LOD') origem
                     from t_fcf_solveicorig o
                     where o.fcf_solveic_cod = pSolveic
                       and o.fcf_solveicorig_ordem = 1
                    )
       loop
         vRetorno := vRetorno || c_msg.origem;
       End Loop;              
       
       return vRetorno;  
    
      
    End fn_retorna_solveicpartorig;


  Function fn_retorna_solveicpartdest(pSolveic in tdvadm.t_fcf_solveic.fcf_solveic_cod%type) 
     return char
    As
      vRetorno varchar2(200);
    Begin
       vRetorno := '';
       for c_msg in (select fn_busca_codigoibge(d.glb_localidade_codigo,'LOD') destino
                     from t_fcf_solveicdest d
                     where d.fcf_solveic_cod = pSolveic
                       and d.fcf_solveicdest_ordem = ( select max(d1.fcf_solveicdest_ordem)
                                                       from t_fcf_solveicdest d1
                                                       where d1.fcf_solveicdest_cod = d.fcf_solveicdest_cod )
 
                     )
       loop
         vRetorno := vRetorno || c_msg.destino;
       End Loop;              
       
       return vRetorno;  
    
      
    End fn_retorna_solveicpartdest;



  Function fn_retorna_solveicpart(pSolveic in tdvadm.t_fcf_solveic.fcf_solveic_cod%type) 
     return char
    As
      vRetorno varchar2(200);
    Begin
       vRetorno := '';
       for c_msg in (select p1.fcf_particularidade_descricao particularidade
                     from t_fcf_solveicpart sp1,
                          t_fcf_particularidade p1 
                     where sp1.fcf_solveic_cod = pSolveic
                       and sp1.fcf_particularidade_cod = p1.fcf_particularidade_cod 
                     )
       loop
         vRetorno := vRetorno || c_msg.particularidade || '/';
       End Loop;                    
       return vRetorno;  
    End fn_retorna_solveicpart;
    
    Function Fn_GetDataPorCodigoEstagio(pVeiculoDispCodigo In Tdvadm.t_Fcf_Veiculodisp.Fcf_Veiculodisp_Codigo%type,
                                        pEstagio           In Char) return Date
    As
      vResult Date;                                        
    Begin
        Begin
            if pEstagio = 'I' then    
            
                  SELECT min(T.DATA)
                         INTO vResult
                  FROM ( SELECT HH.ARM_HISTESTVEICDISP_DATA DATA
                            FROM tdvadm.t_arm_histestveicdisp hh
                            WHERE HH.FCF_VEICULODISP_CODIGO = pVeiculoDispCodigo --'2891990'
                              AND HH.ARM_ESTAGIOCARREGMOB_CODIGO = pEstagio -- 'I'
                          UNION
                          SELECT H.ARM_HISTESTVEICCARREG_DATA DATA
                            FROM ARMADM.T_ARM_HISTESTVEICCARREG H
                            WHERE H.FCF_VEICULODISP_CODIGO = pVeiculoDispCodigo --'2891990'
                              AND H.ARM_ESTAGIOCARREGMOB_CODIGO = pEstagio --'I' 
                       ) T;
            else
            
                  SELECT MAX(T.DATA)
                         INTO vResult
                  FROM ( SELECT HH.ARM_HISTESTVEICDISP_DATA DATA
                            FROM tdvadm.t_arm_histestveicdisp hh
                            WHERE HH.FCF_VEICULODISP_CODIGO = pVeiculoDispCodigo --'2891990'
                              AND HH.ARM_ESTAGIOCARREGMOB_CODIGO = pEstagio -- 'I'
                          UNION
                          SELECT H.ARM_HISTESTVEICCARREG_DATA DATA
                            FROM ARMADM.T_ARM_HISTESTVEICCARREG H
                            WHERE H.FCF_VEICULODISP_CODIGO = pVeiculoDispCodigo --'2891990'
                              AND H.ARM_ESTAGIOCARREGMOB_CODIGO = pEstagio --'I' 
                       ) T;        
            end if;
        Exception
          When No_Data_Found Then
            vResult := null;
        End;         
        return vResult;
    End Fn_GetDataPorCodigoEstagio;

function fn_recalculoMesaVF(pValeFreteCod    tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                            pValeFreteSr     tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                            pValeFreteRt     tdvadm.t_con_valefrete.glb_rota_codigo%type,
                            pValeFreteSq     tdvadm.t_con_valefrete.con_valefrete_saque%type) return number is

  -- 156166-A1-011
  -- 157345-A1-011
 
  vSolveic_Cod     tdvadm.t_fcf_solveic.fcf_solveic_cod%type;
  tpCadFrete       tdvadm.t_cad_frete%rowtype;
  tpSolVeic        tdvadm.t_fcf_solveic%rowtype;
  tpvSolVeic       tdvadm.v_fcf_solveic%rowtype;
  tpFreteCar       tdvadm.v_fcf_fretecarhist%rowtype;
  tpValeFrete      tdvadm.t_con_valefrete%rowtype;
  vTPVeiculo       tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_descricao%type;
  vPercentExp      number;
  vCadFrete        char(1);
  vFreteCalc       number;
  vAcrescimo       number;
  vAjudantes       number;
  vQtdeEntrega     number;
  vQtdeColeta      number; 
  vEntrega         number;
  vColeta          number; 
  vExcecao         number;
  vPedagio         number;
  vPednoFrete      char(1);
  vRetorno         number;
  i integer;
  
begin
--  :pMessage := 'Inicio' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss');
   vMemoriaCalculo := '';
   Begin
       select *
           into tpValeFrete
       from tdvadm.t_con_valefrete vf
       where vf.con_conhecimento_codigo = pValeFreteCod
         and vf.con_conhecimento_serie = pValeFreteSr
         and vf.glb_rota_codigo = pValeFreteRt
         and vf.con_valefrete_saque = pValeFreteSq;
   exception
     When NO_DATA_FOUND Then
        vMemoriaCalculo := 'Vale de Frete ' || pValeFreteCod || pValeFreteSr || pValeFreteRt || pValeFreteSq || ' Não existe!';
        return 0;
     End;
     
   Begin
      select s.*
         into tpSolVeic
      from tdvadm.t_fcf_solveic s
      where s.fcf_veiculodisp_codigo = tpValeFrete.Fcf_Veiculodisp_Codigo 
        and s.fcf_veiculodisp_sequencia = tpValeFrete.Fcf_Veiculodisp_Sequencia;
      select s.*
         into tpvSolVeic
      from tdvadm.v_fcf_solveic s
      where s.fcf_veiculodisp_codigo = tpValeFrete.Fcf_Veiculodisp_Codigo
        and s.fcf_veiculodisp_sequencia = tpValeFrete.Fcf_Veiculodisp_Sequencia;
   exception
     When NO_DATA_FOUND Then 
        vMemoriaCalculo := 'Solicitaco de Veiculo não encontrada para VEICDISP ' || tpValeFrete.Fcf_Veiculodisp_Codigo || '-' || tpValeFrete.Fcf_Veiculodisp_Sequencia || ' !';
        return 0;
     When TOO_MANY_ROWS Then
        vMemoriaCalculo := 'Solicitaco de Veiculo mais de uma linha VEICDISP ' || tpValeFrete.Fcf_Veiculodisp_Codigo || '-' || tpValeFrete.Fcf_Veiculodisp_Sequencia || ' !';
        return 0;
   end ;

   Begin
     select distinct *
        into tpFreteCar
     from tdvadm.v_fcf_fretecarhist fc
     where fc.fcf_fretecar_rowid = tpSolVeic.Fcf_Fretecar_Rowid
       and fc.FCF_FRETECAR_PEDNOFRETE is not null
       and fc.vigencia = (select max(fc1.vigencia)
                          from tdvadm.v_fcf_fretecarhist fc1
                          where fc1.codorig = fc.codorig
                            and fc1.coddest = fc.coddest
                            and fc1.codveic = fc.codveic
                            and fc1.vigencia <= tpValeFrete.Con_Valefrete_Datacadastro
                            and fc1.FCF_FRETECAR_PEDNOFRETE is not null);
   Exception
     When NO_DATA_FOUND Then
        vMemoriaCalculo := 'Problema ao recuperar valor do Frete !';
        return 0;
     When OTHERS Then
        raise_application_error(-20123,'Veja este rowid ' || tpSolVeic.Fcf_Fretecar_Rowid || chr(10) || sqlerrm); 
   End;
     

   Begin
       Select *
          into tpCadFrete
       from tdvadm.t_cad_frete cf
       where cf.fcf_solveic_cod = tpSolVeic.Fcf_Solveic_Cod
         and cf.fcf_fretecar_rowid = tpSolVeic.Fcf_Fretecar_Rowid
         and cf.cad_frete_status = 'AP';
       vCadFrete := 'S';
   Exception
     When NO_DATA_FOUND Then
        vCadFrete := 'N';
     When TOO_MANY_ROWS Then
       Select *
          into tpCadFrete
       from tdvadm.t_cad_frete cf
       where cf.fcf_solveic_cod = tpSolVeic.Fcf_Solveic_Cod
         and cf.fcf_fretecar_rowid = tpSolVeic.Fcf_Fretecar_Rowid
         and cf.cad_frete_status = 'AP'
         and rownum = 1;
       vCadFrete := 'D';
       
     End;

   vFreteCalc := tpFreteCar.Fcf_Fretecar_Valor;
   If tpSolVeic.Fcf_Solveic_Tpfrete = 'E' Then
      vFreteCalc := vFreteCalc * 1.2;  
   End If;
   vPedagio   := tpFreteCar.Fcf_Fretecar_Pedagio;
   vPednoFrete := tpFreteCar.Fcf_Fretecar_Pednofrete;
   vQtdeEntrega   := tpSolVeic.Fcf_Solveic_Qtdeentregas;
   If vQtdeEntrega > 0 Then
     vQtdeEntrega := vQtdeEntrega -1;
   end If;
   vQtdeColeta    := tpSolVeic.Fcf_Solveic_Qtdecoletas;
   If vQtdeColeta > 0 Then
     vQtdeColeta := vQtdeColeta -1;
   end If;
   i:= 0;
   for c_msg in (select p.usu_perfil_parat parat,
                        p.usu_perfil_paran1 VLRFIXOC,
                        p.usu_perfil_paran2 PERCC,
                        p.usu_perfil_paran3 VLRKMC,
                        p.usu_perfil_paran4 VLRFIXOE,
                        p.usu_perfil_paran5 PERCE,
                        p.usu_perfil_paran6 VLRKME
                 from tdvadm.t_usu_perfil p
                 where p.usu_aplicacao_codigo = 'veicdisp'
                   and p.usu_perfil_codigo = 'REGRAFRETE' || trim(tpSolVeic.Fcf_Tpveiculo_Codigo)
                   and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                               from tdvadm.t_usu_perfil p1
                                               where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                                 and p1.usu_perfil_codigo = p.usu_perfil_codigo
                                                 and p1.usu_perfil_vigencia <= sysdate))

   Loop
     i:= 1;
     if substr(c_msg.parat,1,2) = 'KF' Then
        vColeta  := vQtdeColeta  * c_msg.VLRKMC;
        vEntrega := vQtdeEntrega * c_msg.VLRFIXOE;
     Else
        vColeta := -1000;
        vEntrega := - 1000;
     End If;
   End Loop;
   If i = 0 Then
      vColeta  := 0;
      vEntrega := 0;
   End If;
   
   Begin
     Select v.fcf_tpveiculo_descricao
       into vTPVeiculo
     from tdvadm.t_fcf_tpveiculo v
     where v.fcf_tpveiculo_codigo = tpSolVeic.Fcf_Tpveiculo_Codigo;
   Exception
     When NO_DATA_FOUND Then
        vTPVeiculo := 'Não localizado';
     End;
   
   vExcecao   := tpSolVeic.Fcf_Solveic_Valorexcecao;

      vAcrescimo := 0;
      vAjudantes := 0;

--   If tpCadFrete.Cad_Frete_Status = 'AP' Then
      vAcrescimo := tpCadFrete.Cad_Frete_Vlraprovado;
      vAjudantes := tpCadFrete.Cad_Frete_Novovalor_Ajudante;
--   Else
--      vAcrescimo := 0;
--      vAjudantes := 0;
--   End If;         

   If tpCadFrete.Cad_Frete_Status = 'AP' Then
      vRetorno := vFreteCalc + vPedagio +  vEntrega + vColeta +  vExcecao + vAcrescimo + vAjudantes;
      If vPednoFrete = 'S' Then
         vRetorno := vRetorno - vPedagio;
      End If;
   Else
      vRetorno := vFreteCalc + vPedagio +  vEntrega + vColeta +  vExcecao;
   End If;

   vMemoriaCalculo := '---------------------- VALE FRETE ----------------------' || chr(10) ||
                      'DATA VF    : ' || to_char(tpValeFrete.Con_Valefrete_Datacadastro,'DD/MM/YYYY hh24:MI:SS') || chr(10) ||
                      'ORIGEM     : ' || tdvadm.fn_busca_codigoibge(tpvSolVeic.origemIBSO,'IBD') || chr(10) ||
                      'DESTINO    : ' || tdvadm.fn_busca_codigoibge(tpvSolVeic.destinoIBSO,'IBD') || chr(10) ||
                      'VEICULO    : ' || tpSolVeic.FCF_TPVEICULO_CODIGO || '-' || trim(vTPVeiculo) || chr(10) ||
                      'Frete      : ' || tdvadm.f_mascara_valor(tpValeFrete.Con_Valefrete_Frete,10,2) || chr(10) ||
                      'Pedagio    : ' || tdvadm.f_mascara_valor(tpValeFrete.Con_Valefrete_Pedagio,10,2) || chr(10) ||
                      '---------------------- MESA ----------------------' || chr(10) ||
                      'DATA MESA  : ' || to_char(tpFreteCar.datacad,'DD/MM/YYYY hh24:MI:SS') || chr(10) ||
                      'ORIGEM     : ' || tdvadm.fn_busca_codigoibge(tpFreteCar.codorig,'IBD') || chr(10) ||
                      'DESTINO    : ' || tdvadm.fn_busca_codigoibge(tpFreteCar.coddest,'IBD') || chr(10) ||
                      'VEICULO    : ' || tpFreteCar.codveic || '-' || trim(tpFreteCar.veiculo) || chr(10) ||
                      'Frete      : ' || tdvadm.f_mascara_valor(vFreteCalc,10,2) || chr(10) ||
                      'Pedagio    : ' || tdvadm.f_mascara_valor(vPedagio,10,2) || chr(10) ||
                      'PednoFrete : ' || vPednoFrete || chr(10) ||
                      '---------------------- SOLICITACAO ----------------------' || chr(10) ||
                      'DATA SOL   : ' || to_char(tpSolVeic.Fcf_Solveic_Dtsoli,'DD/MM/YYYY hh24:MI:SS') || chr(10) ||
                      'QtdeEntr   : ' || vQtdeEntrega || chr(10) ||
                      'Entrega    : ' || tdvadm.f_mascara_valor(vEntrega,10,2) || chr(10) ||
                      'QtdeCol    : ' || vQtdeColeta || chr(10) ||
                      'Coleta     : ' || tdvadm.f_mascara_valor(vColeta,10,2) || chr(10) ||
                      'Exceção    : ' || tdvadm.f_mascara_valor(vExcecao,10,2) || chr(10) ||
                      '---------------------- SOL ACRESCIMO ----------------------' || chr(10) ||
                      'Status     : ' || tpCadFrete.Cad_Frete_Status || chr(10) ||
                      'Acrescimo  : ' || tdvadm.f_mascara_valor(vAcrescimo,10,2) || chr(10) ||
                      'Ajudante   : ' || tdvadm.f_mascara_valor(vAjudantes,10,2) || chr(10) ||
                      'Verificar  : ' || vCadFrete || chr(10) ||
                      '------------------------------------------------------------' || chr(10) ||
                      'TOTAL PAGO : ' || tdvadm.f_mascara_valor(tpValeFrete.Con_Valefrete_Frete,10,2) || chr(10) ||
                      'TOTAL CALC : ' || tdvadm.f_mascara_valor(vRetorno,10,2) || chr(10) ;
                         

--   :pMessage := :pMessage || ' Fim ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss');


  return(vRetorno);
end fn_recalculoMesaVF;


 
  function fn_memoriarecalculo(pValeFreteCod    tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                               pValeFreteSr     tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                               pValeFreteRt     tdvadm.t_con_valefrete.glb_rota_codigo%type,
                               pValeFreteSq     tdvadm.t_con_valefrete.con_valefrete_saque%type) 
    return varchar2 is
    i number;
  Begin
     i := fn_recalculoMesaVF(pValeFreteCod,
                             pValeFreteSr,
                             pValeFreteRt,
                             pValeFreteSq);
     return vMemoriaCalculo;

  End fn_memoriarecalculo;


  



end Pkg_Fcf_VeiculoDisp;
/
