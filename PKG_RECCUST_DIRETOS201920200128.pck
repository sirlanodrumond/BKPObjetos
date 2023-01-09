create or replace package tdvipf.PKG_RECCUST_DIRETOS2019 is

  /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  *
  * SISTEMA      : [IPF] - INDICADORES DE PERFORMANCE FINANCEIRA 
  * OBJETIVO     : BIBLIOTECA DE FUNC?ES E PROCEDURES UTILIZADOS PARA COMPOR AS RECEITAS E CUSTOS DIRETOS DA FROTA, AGREGADOS E CARRETEIROS
  * PROGRAMA     : PKG_RECCUST_FROTA_DIRETA
  * ANALISTA     : ROBERTO PARIZ
  * PROGRAMADOR  : ROBERTO PARIZ
  * CRIACAO      : 01-12-2016
  * BANCO        : ORACLE
  *              :
  * ALTERACAO    :
  *              :
  * ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- ********************************************* PARAMETROS GLOBAIS *********************************************
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
   cPercentPis      Constant number := 0.0165;
   cPercentCofins   Constant number := 0.0760; 
   cPercentINSSEMP  Constant number := 0.2000;
   
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- ********************************************* FINAL DOS PARAMETROS GLOBAIS *********************************************
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

  -- TIPOS
  
Function fn_retornavalorrateado(pTpRetorno                          in char DEFAULT 'R',
                                                                                   --R - Valor Rateado, 
                                                                                   --F - Fator 
                                pTpRegistro                         in char,
                                                                            --STCCCT - RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
                                                                            --STCC   - RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
                                                                            --NTCC   - NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
                                                                            --NTCCCT - NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
                                pValor                              in number,
                                pglb_tpcentrocusto_criteriorat      in tdvadm.t_glb_centrocusto.glb_tpcentrocusto_criteriorat%type,
                                pglb_tpcentrocusto_ccrateio         in tdvadm.t_glb_centrocusto.glb_tpcentrocusto_ccrateio%type,

                                pipf_indicadores_qtdectechave       in number,
                                pipf_indicadores_qtdectecctot       in number,
                                pipf_indicadores_qtdectecontratotot in number,
                                pipf_indicadores_qtdectetot         in number,
                                pipf_indicadores_qtdevfchave        in number,
                                pipf_indicadores_qtdevfcctot        in number,
                                pipf_indicadores_qtdevfcontratotot  in number,
                                pipf_indicadores_qtdevftot          in number,
                                pratctfretepesochave                in number,
                                pRATCTFRETEPESOFROTACHAVE           in number,
                                pratctfretepesoccfrotatot           in number,
                                pratctfretepesocontratofrotatot     in number,
                                pratctfretepesofrotatot             in number,
                                pratctfretepesocctot                in number,
                                pratctfretepesocontratotot          in number,
                                pratctfretepesotot                  in number)
                                return number;
Procedure sp_carregaValeFrete(pReferencia in char); 
Procedure sp_carregaConhecimento(pReferencia in char);
Procedure sp_carregaPneus;
Procedure sp_calculaFimViagem;
procedure sp_carregaSemParar(pReferencia in char);
procedure sp_carregaMIX(pReferencia in char);
procedure sp_carregaIPVA(pReferencia in char);
procedure sp_carregaRastreamento(pReferencia in char);
procedure sp_carregaIndicadores(pReferencia in char);
procedure sp_carregaSeguro(pReferencia in char);
procedure sp_carregaCTFFrota(pReferencia in char);
procedure sp_carregaCTF;
Procedure sp_carregaVFreteConhec(pReferencia in char);
Procedure sp_carregaValoresAcumulados;
  function fn_retornaCentroCusto(pReferencia in char,
                                 pCentroCusto in tdvadm.t_slf_contrato.glb_centrocusto_codigo%type,
                                 pContrato    in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                                 pTipoRet     in char default 'C') -- (C)odigo
                                                                   -- (D)escricao
  Return varchar2;

Procedure sp_criaIndicadores(pPeriodo in char,
                             pStatus out char,
                             pMessage out varchar2);

Procedure sp_criaRECCUST(pPeriodo in char);

Procedure sp_criaCCContratoRateado(pPeriodo in char,
                                   pStatus out char,
                                   pMessage out varchar2);
Procedure sp_criaCCContratoRateado2(pPeriodo in char,
                                   pStatus out char,
                                   pMessage out varchar2);

 
END PKG_RECCUST_DIRETOS2019;

 
/
CREATE OR REPLACE PACKAGE BODY TDVIPF.PKG_RECCUST_DIRETOS2019 IS

/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : INDICADORES DE PERFORMANCE FINANCEIRA 
 * OBJETIVO     : CARREGAR OS VALES DE FRETE E CUSTOS/REFERENCIAS PERTINENTES A VIAGEM
 *                TAIS COMO : MIX
 *                            FRETE DA MESA
 *                            KM 
 *                            KM VAZIO
 *                            ESTADIA ???????
 *                            PNEUS
 *                             
 * ANALISTA     : SIRLANO 
 * PROGRAMADOR  : SIRLANO
 * CRIACAO      : 17/05/2019
 * BANCO        : ORACLE
 *              :
 * PROGRAMA     : SP_CARREGAVALEFRETE
 * PARAMETROS   : PREFERENCIA - ANOMES INDICANDO O INICO A SEDER PROCESSADO
 * RETORNO      : ALIMENTA A TABELA TDVIPF.T_IPF_VALEFRETE
 *              :
 * ALTERACAO    :
 *
 * ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 */

Function fn_contacaracter(pString varchar2,
                          pCaracter char)
  return number
Is  
  vpos integer;
  vQtde integer;
  vString varchar2(10000);
begin
  
    vpos := 0;
    vQtde := 0;
    vString := pString;
    loop
       vString := nvl(substr(vString,vpos+1),'');
       vpos := nvl(instr(vString,pCaracter,1),0);
      exit when vpos = 0;
      vQtde := vQtde + 1;
    end loop;
    
    return vQtde;
     
end;

Function fn_retornavalorrateado(pTpRetorno                          in char DEFAULT 'R',
                                                                                   --R - Valor Rateado, 
                                                                                   --F - Fator 
                                                                                   --F1 - Fator1
                                pTpRegistro                         in char,
                                                                            --STCCCT - RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
                                                                            --STCC   - RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
                                                                            --NTCC   - NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
                                                                            --NTCCCT - NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
                                pValor                              in number,
                                pglb_tpcentrocusto_criteriorat      in tdvadm.t_glb_centrocusto.glb_tpcentrocusto_criteriorat%type,
                                pglb_tpcentrocusto_ccrateio         in tdvadm.t_glb_centrocusto.glb_tpcentrocusto_ccrateio%type,

                                pipf_indicadores_qtdectechave       in number,
                                pipf_indicadores_qtdectecctot       in number,
                                pipf_indicadores_qtdectecontratotot in number,
                                pipf_indicadores_qtdectetot         in number,
                                pipf_indicadores_qtdevfchave        in number,
                                pipf_indicadores_qtdevfcctot        in number,
                                pipf_indicadores_qtdevfcontratotot  in number,
                                pipf_indicadores_qtdevftot          in number,
                                pratctfretepesochave                in number,
                                pRATCTFRETEPESOFROTACHAVE           in number,
                                pratctfretepesoccfrotatot           in number,
                                pratctfretepesocontratofrotatot     in number,
                                pratctfretepesofrotatot             in number,
                                pratctfretepesocctot                in number,
                                pratctfretepesocontratotot          in number,
                                pratctfretepesotot                  in number)
                                return number
Is
  vFator     number;
  vFator2    number;
  vValorRat  number;
  vnValor    number;
Begin
  
  -- Conta qunantos Centros de custos temos para rateio
  vFator := nvl(fn_contacaracter(pglb_tpcentrocusto_ccrateio,';'),0);

  Begin
      vFator := 0;
      If vFator > 0 Then
         vFator := vFator;
      ElsIf pglb_tpcentrocusto_criteriorat = 'nenhum' Then
        If pTpRegistro = 'NTCC' Then   -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
          vFator := pratctfretepesochave / pratctfretepesocctot;
        Else
           vFator := 1;
        End If;
      ElsIf pglb_tpcentrocusto_criteriorat = 'qtdevf' Then
        If pTpRegistro = 'STCC' Then      -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
            -- RATEIO DE CENTRO DE CUSTO RATEAVEIS PARA A FILIAL 
            vFator := pipf_indicadores_qtdevfcctot / pipf_indicadores_qtdevfTOT ;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := 1 * vFator;
            vnValor := pValor * vFator;
            vFator := pipf_indicadores_qtdevfchave / pipf_indicadores_qtdevfcctot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;
        ElsIf pTpRegistro = 'NTCC' Then   -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO  
            vFator := pipf_indicadores_qtdevfcctot / pipf_indicadores_qtdevfTOT ;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := 1 * vFator;
            vnValor := pValor * vFator;
            vFator := pipf_indicadores_qtdevfchave / pipf_indicadores_qtdevfcctot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;

        ElsIf pTpRegistro = 'STCCCT' Then    -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
            vFator := 1;
        ElsIf pTpRegistro = 'NTCCCT' Then -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
           vFator := 1;
        End If; 
      ElsIf pglb_tpcentrocusto_criteriorat = 'qtdecte' Then

        If pTpRegistro = 'STCC' Then      -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
            -- RATEIO DE CENTRO DE CUSTO RATEAVEIS PARA A FILIAL 
            vFator := pipf_indicadores_qtdectecctot / pipf_indicadores_qtdectetot ;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := 1 * vFator;
            vnValor := pValor * vFator;
            vFator := pipf_indicadores_qtdectechave / pipf_indicadores_qtdectecctot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;
        ElsIf pTpRegistro = 'NTCC' Then   -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO  
            vFator := pipf_indicadores_qtdectecctot / pipf_indicadores_qtdectetot ;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := 1 * vFator;
            vnValor := pValor * vFator;
            vFator := pipf_indicadores_qtdectechave / pipf_indicadores_qtdectecctot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;

        ElsIf pTpRegistro = 'STCCCT' Then    -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
            vFator := 1;
        ElsIf pTpRegistro = 'NTCCCT' Then -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
           vFator := 1;
        End If; 


      ElsIf pglb_tpcentrocusto_criteriorat = 'qtdefunc' Then
         vFator := 0;
      ElsIf pglb_tpcentrocusto_criteriorat = '%receitaF' Then

        If pTpRegistro = 'STCC' Then      -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
            -- RATEIO DE CENTRO DE CUSTO RATEAVEIS PARA A FILIAL 
            vFator := pratctfretepesoccfrotatot / pratctfretepesofrotatot;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := 1 * vFator;
            vnValor := pValor * vFator;
            vFator := pRATCTFRETEPESOFROTACHAVE / pratctfretepesoccfrotatot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;
        ElsIf pTpRegistro = 'NTCC' Then   -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO  
            vFator := pratctfretepesoccfrotatot / pratctfretepesofrotatot;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator,6),0);
            End If;
            vFator2 := 1 * vFator;
            vnValor := pValor * vFator;
            vFator := pRATCTFRETEPESOFROTACHAVE / pratctfretepesoccfrotatot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;

        ElsIf pTpRegistro = 'STCCCT' Then    -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
            vFator := pratctfretepesofrotachave / pRATCTFRETEPESOCONTRATOfrotaTOT;
        ElsIf pTpRegistro = 'NTCCCT' Then -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
           vFator := 1;
        End If; 

      ElsIf pglb_tpcentrocusto_criteriorat = 'ratreceita' Then
         If pTpRegistro = 'STCCCT' Then    -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
            vFator := pratctfretepesochave / pRATCTFRETEPESOCONTRATOTOT;
         ElsIf pTpRegistro = 'STCC' Then   -- RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
            vFator := pratctfretepesochave / pratctfretepesocctot;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := 1 * vFator;
            
            vnValor := pValor * vFator;
            vFator := pratctfretepesocctot / pratctfretepesotot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;

         ElsIf pTpRegistro = 'NTCC' Then   -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / SEM CONTRATO
            vFator := pratctfretepesochave / pratctfretepesocctot;
            if pTpRetorno = 'F1' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := 1 * vFator;
            vnValor := pValor * vFator;
            vFator := pratctfretepesocctot / pratctfretepesotot;
            if pTpRetorno = 'F2' Then
               return nvl(round(vFator * 1000000,6),0);
            End If;
            vFator2 := vFator2 * vFator;
            vnValor := vnValor * vFator;
            if pTpRetorno = 'R' Then
               return nvl(round(pValor * vFator2 ,6),0);
            End If;

         ElsIf pTpRegistro = 'NTCCCT' Then -- NÃO RATEAVEIS / TODOS / COM CENTRO DE CUSTO / COM CONTRATO
            vFator := 1;
         End If;
      Else
         vFator := -1;
      end If;
       
      vValorRat := nvl(round(pValor * vFator,6),0); 
      vFator := nvl(round(vFator * 1000000,6),0);

      if pTpRetorno = 'R' Then
         return nvl(round(vValorRat,6),0);
      Else
         If pTpRegistro in ('NTCC','STCC') Then
            return nvl(round(vFator2 * 1000000,6),0);
         Else  
            return vFator;
         End If;
      End If;
  exception
    When OTHERS Then
      return (sqlcode);
  End;    


  return 0;
End;                                

FUNCTION FN_RETORNAVALORFRETEBONUS(P_VF_NUMERO    IN TDVADM.T_CON_VALEFRETE.CON_CONHECIMENTO_CODIGO%TYPE,
                                   P_VF_SERIE     IN TDVADM.T_CON_VALEFRETE.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_VF_ROTA      IN TDVADM.T_CON_VALEFRETE.GLB_ROTA_CODIGO%TYPE,
                                   P_VF_SAQUE     IN TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE,
                                   P_FRETE        NUMBER,
                                   P_PERCENTUAL   NUMBER,
                                   P_TIPORETORNO  CHAR,
                                   P_ARRED        number default 0) -- B - RETORNO O BONUS F - RETORNO O FRETE
                                   RETURN NUMBER
IS
/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : INDICADORES DE PERFORMANCE FINANCEIRA 
 * OBJETIVO     : RETORNAR O VALOR DO BONUS
 * PROGRAMA     : FN_RETORNAVALORFRETEBONUS
 * ANALISTA     : Klayton Souza
 * PROGRAMADOR  : Klayton Souza  
 * CRIACAO      : 07/02/2019
 * BANCO        : ORACLE
 *              :
 * PARAMETROS   : P_VF_NUMERO         => NUEMRO DO VALE DE FRETE
 *              : P_VF_SERIE          => SERIE DO VALE DE FRETE
 *              : P_VF_ROTA           => ROTA DO VALE DE FRETE
 *              : P_VF_SAQUE          => SAQUE DO VALE DE FRETE
 *              : P_FRETE             => 
 *              : P_PERCENTUAL        => 
 *              : P_TIPORETORNO       => 
 *              : P_ARRED             => 
 *              :
 * RETORNO      : RETORNO DOS VALORES DO BONUS
 *              :
 * ALTERACAO    :
 *
 * ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 */
   V_FATOR                    NUMBER;
   V_RESULTPREFATOR1          NUMBER;
   V_RESULTCALCULANDOPREFATOR NUMBER;
   vMenorSaque                TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
BEGIN

  -- BUSCO O ULTIMO SAQUE VALIDO
  select min (kk.con_valefrete_saque)
    into vMenorSaque
    from tdvadm.t_con_valefrete kk
   where kk.con_conhecimento_codigo       = P_VF_NUMERO
     and kk.con_conhecimento_serie        = P_VF_SERIE
     and kk.glb_rota_codigo               = P_VF_ROTA
     and nvl(kk.con_valefrete_status,'N') = 'N';

  -- ANALISE DO ULTIMO SAQUE VALIDO, SO RETORNAR VALOR SE FOR O ULTIMO SAQUE VALIDO.
  if (vMenorSaque != P_VF_SAQUE) then
    return 0;
  end if;


   -- FAZENDO UMA CONTA USANDO COMO REFERENCIA 1.000 REAIS PARA CHEGAR NO FATOR

   V_RESULTPREFATOR1           := (1000 / ( 1 + (P_PERCENTUAL/100))) ;
   V_RESULTCALCULANDOPREFATOR  := V_RESULTPREFATOR1 * (P_PERCENTUAL/100);
   V_FATOR                     := V_RESULTCALCULANDOPREFATOR / 1000;
   
   IF P_TIPORETORNO = 'B' THEN
      RETURN ROUND((P_FRETE * V_FATOR)+0.5,nvl(P_ARRED,0));
   ELSIF P_TIPORETORNO = 'B2' THEN
      RETURN ROUND((ROUND((P_FRETE * ( 1 + (P_PERCENTUAL/100))+ 0.5),nvl(P_ARRED,0)) * V_FATOR)+0.5,nvl(P_ARRED,0));

   ELSE
      RETURN round((P_FRETE - (P_FRETE * V_FATOR))+ 0.5,nvl(P_ARRED,0));
   END IF;


END;


Procedure sp_carregaValeFrete(pReferencia in char)
  As 
    tpipf_valefrete tdvipf.t_ipf_valefrete%rowtype;
    tpipf_valefreteClear tdvipf.t_ipf_valefrete%rowtype;
    vInclui   char(1) := 'N';
    vPegaKM   char(1) := 'N';
    vAuxiliar integer;
    vSaqueAnt tdvadm.t_con_valefrete.con_valefrete_saque%type;
    vPlacaAnt tdvadm.t_con_valefrete.con_valefrete_placa%type;
    vOrigDest char(16);
    
begin
--  delete tdvipf.t_ipf_valefrete;
  for c_msg in (select vf.con_conhecimento_codigo,
                       vf.con_conhecimento_serie,
                       vf.glb_rota_codigo,
                       vf.con_valefrete_saque,
                       vf.con_catvalefrete_codigo,
                       vf.con_catvalefrete_codigo || '-' || cat.con_catvalefrete_descricao con_catvalefrete_descricao,
                       vf.glb_localidade_codigoori,
                       vf.glb_localidade_codigodes,
                       vf.glb_localidade_origemvazio,
                       vf.glb_localidade_destinovazio,
                       vf.glb_tpmotorista_codigo,
                       vf.con_valefrete_carreteiro,
                       vf.con_valefrete_placa,
                       vf.con_valefrete_placasaque,
                       vf.frt_conjveiculo_codigo,
                       vf.con_valefrete_dataprazomax,
                       vf.con_valefrete_dataemissao,
                       vf.con_valefrete_datacadastro,
                       vf.con_valefrete_custocarreteiro,
                       vf.con_valefrete_tipocusto,
                       vf.con_valefrete_pesocobrado,
                       vf.con_valefrete_pedagio,
                       vf.con_valefrete_outros,
                       vf.con_valefrete_status,
                       vf.con_valefrete_impresso,
                       vf.cax_boletim_data,
                       vf.glb_rota_codigocx,
                       (select count(*)
                        from tdvadm.t_con_vfreteconhec vfc
                        where vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                          and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                          and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                          and vfc.con_valefrete_saque = vf.con_valefrete_saque) qtdecte,
                       (select count(*)
                        from tdvadm.t_con_vfreteconhec vfc,
                             tdvadm.t_con_conhecimento c,
                             tdvadm.t_arm_coleta co
                        where vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                          and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                          and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                          and vfc.con_valefrete_saque = vf.con_valefrete_saque
                          and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                          and vfc.con_conhecimento_serie = c.con_conhecimento_serie
                          and vfc.glb_rota_codigo = c.glb_rota_codigo
                          and c.arm_coleta_ncompra = co.arm_coleta_ncompra
                          and c.arm_coleta_ciclo = co.arm_coleta_ciclo
                          and co.arm_coleta_tpcoleta <> 'N') qtdecteEX,


                       (select sum(ca.con_calcviagem_valor)
                        from tdvadm.t_con_vfreteconhec vfc,
                             tdvadm.t_con_conhecimento c,
                             tdvadm.t_con_calcconhecimento ca
                        where vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                          and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                          and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                          and vfc.con_valefrete_saque = vf.con_valefrete_saque
                          and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                          and vfc.con_conhecimento_serie = c.con_conhecimento_serie
                          and vfc.glb_rota_codigo = c.glb_rota_codigo
                          and c.con_conhecimento_codigo = ca.con_conhecimento_codigo
                          and c.con_conhecimento_serie = ca.con_conhecimento_serie
                          and c.glb_rota_codigo = ca.glb_rota_codigo
                          and ca.slf_reccust_codigo = 'I_PSCOBRAD') PesoTotalCTe,
                       (select sum(ca.con_calcviagem_valor)
                        from tdvadm.t_con_vfreteconhec vfc,
                             tdvadm.t_con_conhecimento c,
                             tdvadm.t_con_calcconhecimento ca
                        where vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                          and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                          and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                          and vfc.con_valefrete_saque = vf.con_valefrete_saque
                          and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                          and vfc.con_conhecimento_serie = c.con_conhecimento_serie
                          and vfc.glb_rota_codigo = c.glb_rota_codigo
                          and c.con_conhecimento_codigo = ca.con_conhecimento_codigo
                          and c.con_conhecimento_serie = ca.con_conhecimento_serie
                          and c.glb_rota_codigo = ca.glb_rota_codigo
                          and ca.slf_reccust_codigo = 'D_VLRSEGUR') VlrMercTotalCTe,
                       (select min(to_char(vf1.con_valefrete_datacadastro,'YYYYMM'))
                        from tdvadm.t_con_valefrete vf1
                        where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                          and vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                          and vf1.glb_rota_codigo         = vf.glb_rota_codigo
                          and vf1.cax_boletim_data is not null
                          and nvl(vf1.con_valefrete_status,'N') = 'N'
                          and vf1.con_valefrete_placa = vf.con_valefrete_placa) REFPR,
                       (select min(vf1.con_valefrete_saque)
                        from tdvadm.t_con_valefrete vf1
                        where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                          and vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                          and vf1.glb_rota_codigo         = vf.glb_rota_codigo
                          and vf1.cax_boletim_data is not null
                          and nvl(vf1.con_valefrete_status,'N') = 'N'
                          and vf1.con_valefrete_placa = vf.con_valefrete_placa) SQMENORPL,

                       (select min(vf1.con_valefrete_saque)
                        from tdvadm.t_con_valefrete vf1
                        where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                          and vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                          and vf1.glb_rota_codigo         = vf.glb_rota_codigo
                          and vf1.cax_boletim_data is not null
                          and nvl(vf1.con_valefrete_status,'N') = 'N'
                          and vf1.Glb_Localidade_Codigoori = VF.GLB_LOCALIDADE_CODIGOORI
                          AND VF1.GLB_LOCALIDADE_CODIGODES = VF.GLB_LOCALIDADE_CODIGODES) SQMENORloc,

                       (select max(vf1.con_valefrete_saque)
                        from tdvadm.t_con_valefrete vf1
                        where vf1.con_conhecimento_codigo = vf.con_conhecimento_codigo
                          and vf1.con_conhecimento_serie  = vf.con_conhecimento_serie
                          and vf1.glb_rota_codigo         = vf.glb_rota_codigo
                          and nvl(vf1.con_valefrete_status,'N') = 'N'
                          and vf1.cax_boletim_data is not null
                          and vf1.con_valefrete_placa = vf.con_valefrete_placa) SQMAIOR,
                       (select count(*)
                        from tdvadm.t_con_valefrete vf
                        where vf.con_conhecimento_codigo = vf.con_conhecimento_codigo
                         and vf.con_conhecimento_serie = vf.con_conhecimento_serie
                          and vf.glb_rota_codigo = vf.glb_rota_codigo
                          and vf.cax_boletim_data is not null
                          and vf.con_catvalefrete_codigo = '17'
                          and nvl(vf.con_valefrete_status,'N') = 'N'
                          and vf.con_valefrete_placa = vf.con_valefrete_placa) TEMBONUS,
                       vf.fcf_fretecar_rowid                        
                from tdvadm.t_con_valefrete vf,
                     tdvadm.t_con_catvalefrete cat
                where to_char(vf.con_valefrete_datacadastro,'yyyymm') <= pReferencia
                  and to_char(vf.con_valefrete_datacadastro,'yyyymm') >= '201701'
                  and vf.con_catvalefrete_codigo = cat.con_catvalefrete_codigo
                  and nvl(vf.con_valefrete_status,'N') = 'N'
                  and 0 = (select count(*)
                           from tdvipf.t_ipf_valefrete cvf
                           where cvf.ipf_valefrete_chave = vf.con_conhecimento_codigo || vf.con_conhecimento_serie || vf.glb_rota_codigo || vf.con_valefrete_saque)
--                  and vf.con_conhecimento_codigo = '122656'
--                  and vf.glb_rota_codigo = '011'
                  )
  Loop
     vInclui := 'N';
     vPegaKM := 'N';

     If c_msg.cax_boletim_data is not null Then
        vInclui := 'S';
     End If;     
     If c_msg.con_catvalefrete_codigo = '10' and c_msg.glb_tpmotorista_codigo = 'A' Then
        vInclui := 'S';
     End If;
     If c_msg.glb_tpmotorista_codigo = 'F' and TDVADM.FN_GET_TPVEICULO(c_msg.con_valefrete_placa,c_msg.con_valefrete_datacadastro) = 'UTILITARIO' Then
        vInclui := 'S';
     End If;


     If ( c_msg.con_valefrete_saque = c_msg.sqmenorPL ) Then
        vPegaKM := 'S';
     End If;

     If ( c_msg.con_valefrete_saque = c_msg.sqmenorlOC ) Then
        vPegaKM := 'S';
     End If;
        
     If c_msg.con_catvalefrete_codigo in ('17', --Estadia
                                          '14'  -- Bonus CTRC
                                              ) Then  
        vPegaKM := 'N';
        
     End If;

    
     If vInclui = 'S' Then
    
        tpipf_valefrete := tpipf_valefreteClear;
        
        
        
        tpipf_valefrete.ipf_valefrete_referencia      := c_msg.REFPR;
        tpipf_valefrete.ipf_valefrete_chave           := c_msg.con_conhecimento_codigo || c_msg.con_conhecimento_serie || c_msg.glb_rota_codigo || c_msg.con_valefrete_saque ; 
        tpipf_valefrete.ipf_valefrete_codigo          := c_msg.con_conhecimento_codigo ; 
        tpipf_valefrete.ipf_valefrete_serie           := c_msg.con_conhecimento_serie ; 
        tpipf_valefrete.ipf_valefrete_rota            := c_msg.glb_rota_codigo ; 
        tpipf_valefrete.ipf_valefrete_saque           := c_msg.con_valefrete_saque ; 
        tpipf_valefrete.con_catvalefrete_codigo       := c_msg.con_catvalefrete_codigo ; 
        tpipf_valefrete.con_catvalefrete_descricao    := c_msg.con_catvalefrete_descricao ; 
        tpipf_valefrete.ipf_valefrete_status          := nvl(c_msg.con_valefrete_status,'N') ;
        tpipf_valefrete.ipf_valefrete_impresso        := nvl(c_msg.con_valefrete_impresso,'N') ;
        tpipf_valefrete.ipf_valefrete_cteqtde         := nvl(c_msg.qtdecte,0);
        tpipf_valefrete.ipf_valefrete_cteqtdeex       := nvl(c_msg.qtdecteex,0);

        tpipf_valefrete.ipf_valefrete_ctevlrmerctotal := nvl(c_msg.VlrMercTotalCTe,0);
        tpipf_valefrete.ipf_valefrete_ctepesototal    := nvl(c_msg.PesoTotalCTe,0);

        tpipf_valefrete.ipf_valefrete_origem          := c_msg.glb_localidade_codigoori ; 
        tpipf_valefrete.ipf_valefrete_locorigem       := tdvadm.fn_busca_codigoibge(c_msg.glb_localidade_codigoori,'IBD');
        tpipf_valefrete.ipf_valefrete_destino         := c_msg.glb_localidade_codigodes ; 
        tpipf_valefrete.ipf_valefrete_locdestino      := tdvadm.fn_busca_codigoibge(c_msg.glb_localidade_codigodes,'IBD');
        tpipf_valefrete.ipf_valefrete_origemvazio     := c_msg.glb_localidade_origemvazio;
        tpipf_valefrete.ipf_valefrete_locorigemvazio  := tdvadm.fn_busca_codigoibge(c_msg.glb_localidade_origemvazio,'IBD');
        tpipf_valefrete.ipf_valefrete_destinovazio    := c_msg.glb_localidade_destinovazio;
        tpipf_valefrete.ipf_valefrete_locdestinovazio := tdvadm.fn_busca_codigoibge(c_msg.glb_localidade_destinovazio,'IBD');
        tpipf_valefrete.glb_tpmotorista_codigo        := c_msg.glb_tpmotorista_codigo ; 

        tpipf_valefrete.ipf_valefrete_motoristacpf    := c_msg.con_valefrete_carreteiro ; 
        tpipf_valefrete.ipf_valefrete_placa           := c_msg.con_valefrete_placa ; 
        tpipf_valefrete.ipf_valefrete_placasaque      := c_msg.con_valefrete_placasaque ; 
          
        tpipf_valefrete.frt_conjveiculo_codigo        := c_msg.frt_conjveiculo_codigo;
          
        If tpipf_valefrete.ipf_valefrete_status <> 'C' Then
              
            If tpipf_valefrete.glb_tpmotorista_codigo <> 'F' Then
               Begin
                  select c.car_carreteiro_nome
                    into tpipf_valefrete.ipf_valefrete_motoristanome
                  from tdvadm.t_car_carreteiro c
                  where c.car_carreteiro_cpfcodigo = tpipf_valefrete.ipf_valefrete_motoristacpf
                    and rownum = 1;
               Exception
                  when OTHERS Then
                    tpipf_valefrete.ipf_valefrete_motoristanome := substr(sqlerrm,1,50);
                  End;

               Begin
                 select v.car_proprietario_cgccpfcodigo,
                        p.car_proprietario_razaosocial
                    into tpipf_valefrete.ipf_valefrete_proprietariocpf,
                         tpipf_valefrete.ipf_valefrete_proprietarionome
                 from tdvadm.t_car_veiculo v,
                      tdvadm.t_car_proprietario p
                 where v.car_proprietario_cgccpfcodigo = p.car_proprietario_cgccpfcodigo
                   and v.car_veiculo_placa = tpipf_valefrete.ipf_valefrete_placa
                   and v.car_veiculo_saque = tpipf_valefrete.ipf_valefrete_placasaque;
               Exception
                 When OTHERS Then
                     tpipf_valefrete.ipf_valefrete_proprietarionome := substr(sqlerrm,1,50);
                 end; 
            Else
               Begin
                  select m.frt_motorista_nome
                    into tpipf_valefrete.ipf_valefrete_motoristanome
                  from tdvadm.t_frt_motorista m
                  where m.frt_motorista_cpf = tpipf_valefrete.ipf_valefrete_motoristacpf
                    and nvl(m.frt_motorista_dtdesligamento,trunc(c_msg.con_valefrete_datacadastro)) = (select max(nvl(m1.frt_motorista_dtdesligamento,trunc(c_msg.con_valefrete_datacadastro)))
                                                                                                       from tdvadm.t_frt_motorista m1
                                                                                                       where m1.frt_motorista_cpf = tpipf_valefrete.ipf_valefrete_motoristacpf
                                                                                                         and nvl(m1.frt_motorista_dtdesligamento,trunc(c_msg.con_valefrete_datacadastro)) >= trunc(c_msg.con_valefrete_datacadastro));
               exception
               when OTHERS Then
                    tpipf_valefrete.ipf_valefrete_motoristanome := substr(sqlerrm,1,50);
               end;
               tpipf_valefrete.ipf_valefrete_proprietariocpf := '61139432000172';
               tpipf_valefrete.ipf_valefrete_proprietarionome := 'TANSPORTES DELLA VOLPE SA COM IND';

               If substr(c_msg.con_valefrete_placa,1,3) = '000' Then
                  tpipf_valefrete.frt_conjveiculo_codigo     := c_msg.con_valefrete_placa ; 
                  tpipf_valefrete.ipf_valefrete_placa        := trim(tdvadm.pkg_frtcar_veiculo.FN_GET_PLACA(c_msg.con_valefrete_placa,c_msg.con_valefrete_datacadastro,'CAV'));
               End If;   

            End If;
              

            -- Somente para Frota e Agragado
               If tpipf_valefrete.glb_tpmotorista_codigo in ('F','A') Then

                  Begin
                     select v.frt_veiculo_codigo
                        into tpipf_valefrete.frt_veiculo_codigo
                     From tdvadm.t_frt_veiculo v
                     where v.frt_veiculo_placa = tpipf_valefrete.ipf_valefrete_placa
                       and trunc(nvl(v.frt_veiculo_datavenda,sysdate)) >= trunc(c_msg.con_valefrete_datacadastro)
                       and trunc(nvl(v.frt_veiculo_datavenda,sysdate)) = (select max(trunc(nvl(v1.frt_veiculo_datavenda,sysdate)) )
                                                                          from tdvadm.t_frt_veiculo v1 
                                                                          where v1.frt_veiculo_placa = v.frt_veiculo_placa
                                                                            and trunc(nvl(v1.frt_veiculo_datavenda,sysdate)) >= trunc(c_msg.con_valefrete_datacadastro) ); 
                  exception
                    When OTHERS Then
                       tpipf_valefrete.frt_veiculo_codigo := null;   
                    End; 
                 
                  If tpipf_valefrete.glb_tpmotorista_codigo in ('A') Then
                     tpipf_valefrete.frt_conjveiculo_codigo := tpipf_valefrete.frt_veiculo_codigo;
                  End If;
                 
               Else     
                  tpipf_valefrete.frt_veiculo_codigo := null; 
               End If;
             
              
            tpipf_valefrete.fcf_tpveiculo_codigo := tdvadm.pkg_frtcar_veiculo.FN_RETFCFTPVEICULO(c_msg.con_valefrete_placa,c_msg.con_valefrete_datacadastro);
              
            If tpipf_valefrete.fcf_tpveiculo_codigo = 'NE' Then

               Begin
                  SELECT TV.FCF_TPVEICULO_CODIGO
                     into tpipf_valefrete.fcf_tpveiculo_codigo
                  FROM TDVADM.T_CAR_VEICULO V,
                       TDVADM.T_CAR_TPVEICULO TV
                  WHERE V.CAR_TPVEICULO_CODIGO = TV.CAR_TPVEICULO_CODIGO
                    AND V.CAR_VEICULO_PLACA = tpipf_valefrete.ipf_valefrete_placa
                    AND V.CAR_VEICULO_SAQUE = tpipf_valefrete.ipf_valefrete_placasaque;
               exception
                 When OTHERS Then
                     tpipf_valefrete.fcf_tpveiculo_codigo := 'NE';
                 End;
            End If;
              
            If tpipf_valefrete.fcf_tpveiculo_codigo <> 'NE' Then
               select x.fcf_tpveiculo_descricao
                  into tpipf_valefrete.fcf_tpveiculo_descricao
               from tdvadm.t_fcf_tpveiculo x
               where x.fcf_tpveiculo_codigo = tpipf_valefrete.fcf_tpveiculo_codigo;
            end If;
              
            If tpipf_valefrete.fcf_tpveiculo_codigo <> 'NE' Then
               Begin   
                  select tv.fcf_tpveiculo_nreixos 
                     into tpipf_valefrete.ipf_valefrete_eixos
                  from tdvadm.t_fcf_tpveiculo tv 
                  where tv.fcf_tpveiculo_codigo = tpipf_valefrete.fcf_tpveiculo_codigo;
               exception
                 When OTHERS then
                    tpipf_valefrete.ipf_valefrete_eixos := 0;
                 End;
            End If;    
            -- Criar o PegaKM (S/N)
            -- Criar o mudou placa
            -- Criar o mudou orig x Dest
              


            If  vPegaKM = 'S' Then
                begin
                   select max(p.slf_percurso_km)
                      into tpipf_valefrete.ipf_valefrete_kmperc
                   from tdvadm.t_slf_percurso p
                   where p.glb_localidade_codigoorigemi = RPAD(tdvadm.fn_busca_codigoibge(tpipf_valefrete.ipf_valefrete_origem,'IBC'),8)
                     and p.glb_localidade_codigodestinoi = RPAD(tdvadm.fn_busca_codigoibge(tpipf_valefrete.ipf_valefrete_destino,'IBC'),8);         

                   If tpipf_valefrete.ipf_valefrete_kmperc is null Then
                      Begin
                         select max(p.slf_percurso_km)
                            into tpipf_valefrete.ipf_valefrete_kmperc
                         from tdvadm.t_slf_percurso p
                         where p.glb_localidade_codigoorigem = RPAD(tpipf_valefrete.ipf_valefrete_origem,8)
                           and p.glb_localidade_codigodestino = RPAD(tpipf_valefrete.ipf_valefrete_destino,8);         
                          
                      exception
                        When NO_DATA_FOUND Then
                            tpipf_valefrete.ipf_valefrete_kmperc := 0;
                        End;
                       
                   end If;
                     
                       
                exception
                  When OTHERS Then
                      tpipf_valefrete.ipf_valefrete_kmperc := 0;
                  End;
                begin
                   select max(p.slf_percurso_km)
                      into tpipf_valefrete.ipf_valefrete_kmvazio
                   from tdvadm.t_slf_percurso p
                   where p.glb_localidade_codigoorigemi = RPAD(tdvadm.fn_busca_codigoibge(tpipf_valefrete.ipf_valefrete_origemvazio,'IBC'),8)
                     and p.glb_localidade_codigodestinoi = RPAD(tdvadm.fn_busca_codigoibge(tpipf_valefrete.ipf_valefrete_destinovazio,'IBC'),8);         


                   If tpipf_valefrete.ipf_valefrete_kmperc is null Then
                      Begin
                         select max(p.slf_percurso_km)
                            into tpipf_valefrete.ipf_valefrete_kmvazio
                         from tdvadm.t_slf_percurso p
                         where p.glb_localidade_codigoorigem = RPAD(tpipf_valefrete.ipf_valefrete_origemvazio,8)
                           and p.glb_localidade_codigodestino = RPAD(tpipf_valefrete.ipf_valefrete_origemvazio,8);         
                          
                      exception
                        When NO_DATA_FOUND Then
                            tpipf_valefrete.ipf_valefrete_kmvazio := 0;
                        End;
                       
                   end If;

                exception
                  When OTHERS Then
                      tpipf_valefrete.ipf_valefrete_kmvazio := 0;
                  End;
            Else
               tpipf_valefrete.ipf_valefrete_kmperc := 0;
               tpipf_valefrete.ipf_valefrete_kmvazio := 0;

               /* Verifica se o Vale de Frete ja teve seu Bonus Enitido.
                  Caso ja tenha n?o calcula o possivel Bonus
               */
                  
               if c_msg.TEMBONUS = 0 Then                 
                 tpipf_valefrete.ipf_valefrete_provbonus :=  FN_RETORNAVALORFRETEBONUS(c_msg.CON_CONHECIMENTO_CODIGO, 
                                                                                       c_msg.CON_CONHECIMENTO_SERIE,
                                                                                       c_msg.GLB_ROTA_CODIGO,
                                                                                       c_msg.CON_VALEFRETE_SAQUE,
                                                                                       c_msg.CON_VALEFRETE_CUSTOCARRETEIRO,
                                                                                       tdvadm.VFPERCENT_CALC_BONUS,
                                                                                       'B2');                            
               Else
                 tpipf_valefrete.ipf_valefrete_provbonus := 0;
               End If;  
               
               
            End If;
           

                
            tpipf_valefrete.ipf_valefrete_previsaofimviag := c_msg.con_valefrete_dataprazomax ; 
            tpipf_valefrete.ipf_valefrete_emissao         := c_msg.con_valefrete_dataemissao ; 
            tpipf_valefrete.ipf_valefrete_cadastro        := c_msg.con_valefrete_datacadastro ; 
            If tpipf_valefrete.glb_tpmotorista_codigo = 'C' Then
               tpipf_valefrete.ipf_valefrete_fimviagem := c_msg.con_valefrete_dataprazomax;
               tpipf_valefrete.ipf_tpfimviagem_codigo  := '02'; -- assumindo a previsao de entrega
               tpipf_valefrete.ipf_valefrete_chavefv   := null;
            Else
               tpipf_valefrete.ipf_valefrete_fimviagem := null ; 
               tpipf_valefrete.ipf_tpfimviagem_codigo  := null;
               tpipf_valefrete.ipf_valefrete_chavefv   := null;
            End If;


             
            If nvl(c_msg.con_valefrete_status,'N') = 'N' Then 
               tpipf_valefrete.ipf_valefrete_frete           := c_msg.con_valefrete_custocarreteiro;
               If c_msg.con_valefrete_tipocusto = 'T' Then
                  Begin
                    -- erro quanto o custo supera R$ 1.000000,00
                     tpipf_valefrete.ipf_valefrete_frete        := round(c_msg.con_valefrete_custocarreteiro * c_msg.con_valefrete_pesocobrado,2);
                  exception
                  when OTHERS Then
                     raise_application_error(-20002,tpipf_valefrete.ipf_valefrete_chave);
                  End;
               End If;   
            Else
               tpipf_valefrete.ipf_valefrete_frete := 0;
            End If;    

            tpipf_valefrete.ipf_valefrete_fretemesa     := 0 ;
            tpipf_valefrete.ipf_valefrete_pedmesa      := 0 ;

            begin
                select fc.fcf_fretecar_valor,
                       fc.fcf_fretecar_pedagio
                  into tpipf_valefrete.ipf_valefrete_fretemesa,
                       tpipf_valefrete.ipf_valefrete_pedmesa
                from tdvadm.t_fcf_fretecar fc
                where fc.fcf_fretecar_rowid = c_msg.fcf_fretecar_rowid;        
            exception
              When NO_DATA_FOUND Then
                  tpipf_valefrete.ipf_valefrete_fretemesa := 0;
                  tpipf_valefrete.ipf_valefrete_pedmesa  := 0;
              End;



            tpipf_valefrete.ipf_valefrete_pedagio         := nvl(c_msg.con_valefrete_pedagio,0) ; 
            tpipf_valefrete.ipf_valefrete_fretesp         := tpipf_valefrete.ipf_valefrete_frete - tpipf_valefrete.ipf_valefrete_pedmesa; 
            tpipf_valefrete.ipf_valefrete_outros          := c_msg.con_valefrete_outros ; 
            tpipf_valefrete.ipf_valefrete_insspartemp     := ( tpipf_valefrete.ipf_valefrete_fretesp * cPercentINSSEMP ) ; 
            tpipf_valefrete.ipf_valefrete_estadia         := 0 ; 
            tpipf_valefrete.ipf_valefrete_caixa           := c_msg.cax_boletim_data ; 
            tpipf_valefrete.ipf_valefrete_caixart         := c_msg.glb_rota_codigocx ; 
            tpipf_valefrete.ipf_valefrete_dtprocessamento := sysdate ; 


            tpipf_valefrete.ipf_valefrete_pneu          := 0 ; 
            tpipf_valefrete.ipf_valefrete_MIXKM         := 0 ; 
            tpipf_valefrete.ipf_valefrete_MIXQUEIMA     := 0 ; 
            tpipf_valefrete.Ipf_Valefrete_Ctfcustokm    := 0 ; 
            tpipf_valefrete.Ipf_Valefrete_Ctfcustolt    := 0 ; 
            tpipf_valefrete.ipf_valefrete_sparar        := 0 ;
            tpipf_valefrete.ipf_valefrete_contabilizado := NULL; -- Ver se sera necessario mesmo


            Begin
               insert into tdvipf.t_ipf_valefrete values tpipf_valefrete;
            exception
              WHEN OTHERS Then
                 raise_application_error(-20100,tpipf_valefrete.ipf_valefrete_chave || chr(10) || sqlerrm);
              End;
            
        End If;
      End If;
      commit;
  End Loop;
  commit;

end sp_carregaValeFrete;

Function fn_ret_ipfConhec(pConhecimento in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                          pSerie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                          pRota in tdvadm.t_con_conhecimento.glb_rota_codigo%type)
   return  tdvipf.t_ipf_conhec%rowtype
Is
  tpipf_conhec  tdvipf.t_ipf_conhec%rowtype;
  vFatorTiraImp number;
  vAnulado      char(11);
  vAnulador     char(11);
  vSubstituido  char(11);
  vSubstituto   char(11);
  vCFOP         char(4);
  vTabSol       tdvadm.t_con_conhecimento.slf_tabela_codigo%type;
  vTabSolSQ     tdvadm.t_con_conhecimento.slf_tabela_saque%type;
  
Begin
   for c_msg in (select *
                 from tdvadm.t_con_conhecimento c
                 where c.con_conhecimento_codigo = pConhecimento
                   and c.con_conhecimento_serie = pSerie
                   and c.glb_rota_codigo = pRota)
   Loop
      tpipf_conhec.ipf_conhec_chave          := pConhecimento || pSerie || pRota;
      tpipf_conhec.ipf_conhec_codigo         := pConhecimento;
      tpipf_conhec.ipf_conhec_serie          := pSerie;
      tpipf_conhec.ipf_conhec_rota           := pRota;

      Begin
          select c.glb_cliente_cgccpfsacado,
                 cl.glb_grupoeconomico_codigo || '-' || trim(ge.glb_grupoeconomico_nome) grupo,
                 c.glb_mercadoria_codigo,
                 c.con_conhecimento_dtembarque,
                 c.con_conhecimento_entrega,
                 c.con_conhecimento_localcoleta,
                 c.con_conhecimento_localentrega,
                 co.arm_coleta_tpcoleta,

                 (select ca.con_conhecimento_codigoorigem || ca.con_conhecimento_serieorigem || ca.glb_rota_codigoorigem
                  from tdvadm.t_con_conhecanula ca
                  where ca.con_conhecimento_codigo = c.con_conhecimento_codigo
                    and ca.con_conhecimento_serie = c.con_conhecimento_serie
                    and ca.glb_rota_codigo = c.glb_rota_codigo
                    and ca.con_conhecimento_serie <> 'XXX') anulado,

                 (select ca.con_conhecimento_codigoorigem || ca.con_conhecimento_serieorigem || ca.glb_rota_codigoorigem
                  from tdvadm.t_con_conhecsubst ca
                  where ca.con_conhecimento_codigo = c.con_conhecimento_codigo
                    and ca.con_conhecimento_serie = c.con_conhecimento_serie
                    and ca.glb_rota_codigo = c.glb_rota_codigo
                    and ca.con_conhecimento_serie <> 'XXX') substituido,


                 (select ca.con_conhecimento_codigo || ca.con_conhecimento_serie || ca.glb_rota_codigo
                  from tdvadm.t_con_conhecanula ca
                  where ca.con_conhecimento_codigoorigem = c.con_conhecimento_codigo
                    and ca.con_conhecimento_serieorigem = c.con_conhecimento_serie
                    and ca.glb_rota_codigoorigem = c.glb_rota_codigo
                    and ca.con_conhecimento_serie <> 'XXX') anulador,

                 (select ca.con_conhecimento_codigo || ca.con_conhecimento_serie || ca.glb_rota_codigo
                  from tdvadm.t_con_conhecsubst ca
                  where ca.con_conhecimento_codigoorigem = c.con_conhecimento_codigo
                    and ca.con_conhecimento_serieorigem = c.con_conhecimento_serie
                    and ca.glb_rota_codigoorigem = c.glb_rota_codigo
                    and ca.con_conhecimento_serie <> 'XXX') SUBTITUTO,

                 c.con_conhecimento_cfo,
                 CO.FCF_TPVEICULO_CODIGO,
                 (SELECT TV.FCF_TPVEICULO_DESCRICAO
                  FROM TDVADM.T_FCF_TPVEICULO TV
                  WHERE TV.FCF_TPVEICULO_CODIGO = CO.FCF_TPVEICULO_CODIGO) DESCVEIC,
                 c.slf_tabela_codigo,
                 c.slf_tabela_saque,
                 r.glb_centrocusto_codigo
            into tpipf_conhec.ipf_conhec_sacado,
                 tpipf_conhec.ipf_conhec_grupoec,
                 tpipf_conhec.glb_mercadoria_codigo,
                 tpipf_conhec.ipf_conhec_dtemissao,
                 tpipf_conhec.ipf_conhec_dtentrega,
                 tpipf_conhec.ipf_conhec_origem,
                 tpipf_conhec.ipf_conhec_destino,
                 tpipf_conhec.ipf_conhec_colexpressa,
                 vAnulado,
                 vSubstituido,
                 vAnulador,
                 vSubstituto,
                 vCFOP,
                 tpipf_conhec.ipf_conhec_tpveiccol,
                 tpipf_conhec.ipf_conhec_descveiccol,
                 vTabSol,
                 vTabSolSQ,
                 tpipf_conhec.ipf_conhec_centrocusto
          from tdvadm.t_con_conhecimento c,
               tdvadm.t_glb_cliente cl,
               tdvadm.t_glb_grupoeconomico ge,
               tdvadm.t_arm_coleta co,
               tdvadm.t_glb_rota r
          where c.con_conhecimento_codigo = pConhecimento
            and c.con_conhecimento_serie = pSerie
            and c.glb_rota_codigo = pRota
            and c.glb_rota_codigo = r.glb_rota_codigo
            and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
            and cl.glb_grupoeconomico_codigo = ge.glb_grupoeconomico_codigo
            and c.arm_coleta_ncompra = co.arm_coleta_ncompra (+)
            and c.arm_coleta_ciclo = co.arm_coleta_ciclo (+);
      Exception
        When Others Then

              select c.glb_cliente_cgccpfsacado,
                     cl.glb_grupoeconomico_codigo || '-' || trim(ge.glb_grupoeconomico_nome) grupo,
                     c.glb_mercadoria_codigo,
                     c.con_conhecimento_dtembarque,
                     c.con_conhecimento_entrega,
                     c.con_conhecimento_localcoleta,
                     c.con_conhecimento_localentrega,
                     co.arm_coleta_tpcoleta,

                     'verificar' anulado,

                     'verificar' substituido,


                     'verificar' anulador,

                     'verificar' SUBTITUTO,

                     c.con_conhecimento_cfo,
                     CO.FCF_TPVEICULO_CODIGO,
                     (SELECT TV.FCF_TPVEICULO_DESCRICAO
                      FROM TDVADM.T_FCF_TPVEICULO TV
                      WHERE TV.FCF_TPVEICULO_CODIGO = CO.FCF_TPVEICULO_CODIGO) DESCVEIC,
                     c.slf_tabela_codigo,
                     c.slf_tabela_saque,
                     r.glb_centrocusto_codigo 
                into tpipf_conhec.ipf_conhec_sacado,
                     tpipf_conhec.ipf_conhec_grupoec,
                     tpipf_conhec.glb_mercadoria_codigo,
                     tpipf_conhec.ipf_conhec_dtemissao,
                     tpipf_conhec.ipf_conhec_dtentrega,
                     tpipf_conhec.ipf_conhec_origem,
                     tpipf_conhec.ipf_conhec_destino,
                     tpipf_conhec.ipf_conhec_colexpressa,
                     vAnulado,
                     vSubstituido,
                     vAnulador,
                     vSubstituto,
                     vCFOP,
                     tpipf_conhec.ipf_conhec_tpveiccol,
                     tpipf_conhec.ipf_conhec_descveiccol,
                     vTabSol,
                     vTabSolSQ,
                     tpipf_conhec.ipf_conhec_centrocusto
              from tdvadm.t_con_conhecimento c,
                   tdvadm.t_glb_cliente cl,
                   tdvadm.t_glb_grupoeconomico ge,
                   tdvadm.t_arm_coleta co,
                   tdvadm.t_glb_rota r
              where c.con_conhecimento_codigo = pConhecimento
                and c.con_conhecimento_serie = pSerie
                and c.glb_rota_codigo = pRota
                and c.glb_rota_codigo = r.glb_rota_codigo
                and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                and cl.glb_grupoeconomico_codigo = ge.glb_grupoeconomico_codigo
                and c.arm_coleta_ncompra = co.arm_coleta_ncompra (+)
                and c.arm_coleta_ciclo = co.arm_coleta_ciclo (+);

        End;
      If pConhecimento = '030364' Then
         vFatorTiraImp := vFatorTiraImp;
      End If;
      
      
      
     If tpipf_conhec.ipf_conhec_tpveiccol is null Then
        Begin
           select ta.fcf_tpveiculo_codigo
             into tpipf_conhec.ipf_conhec_tpveiccol
           from tdvadm.t_slf_tabela ta
           where ta.slf_tabela_codigo = vTabSol
             and ta.slf_tabela_saque = vTabSolSQ;

           If tpipf_conhec.ipf_conhec_tpveiccol is null Then
              Begin
                 SELECT TV.FCF_TPVEICULO_DESCRICAO
                   into  tpipf_conhec.ipf_conhec_descveiccol
                 FROM TDVADM.T_FCF_TPVEICULO TV
                 WHERE TV.FCF_TPVEICULO_CODIGO = tpipf_conhec.ipf_conhec_tpveiccol;
              exception
                When NO_DATA_FOUND Then
                   tpipf_conhec.ipf_conhec_tpveiccol := null;
                   tpipf_conhec.ipf_conhec_descveiccol := null;
               End;   
          End If;
        Exception
          When NO_DATA_FOUND Then
             tpipf_conhec.ipf_conhec_tpveiccol := null;
             tpipf_conhec.ipf_conhec_descveiccol := null;
          End;  
    
     End If;
      
      If vAnulado is not null Then
         tpipf_conhec.ipf_conhec_tipocte    := 'Anulador';
      ElsIf vSubstituido is not null Then
         tpipf_conhec.ipf_conhec_tipocte    := 'Substituto';
      ElsIf ( vAnulador is not null ) or ( vsubstituido is not null ) Then 
         tpipf_conhec.ipf_conhec_tipocte    := 'Anulado';
      Else
         tpipf_conhec.ipf_conhec_tipocte    := 'Normal';
      End If;
      
      tpipf_conhec.ipf_conhec_anulado     := vAnulado;
      tpipf_conhec.ipf_conhec_substituido := vSubstituido;
      tpipf_conhec.ipf_conhec_anulador    := vAnulador;
      tpipf_conhec.ipf_conhec_substituto  := vSubstituto;
      tpipf_conhec.ipf_conhec_cfop        := vCFOP;

      

      tpipf_conhec.ipf_conhec_contrato := TRIM(TDVADM.PKG_SLF_UTILITARIOS.FN_RETORNA_CONTRATO(pConhecimento,pSerie,pRota));

      tpipf_conhec.ipf_conhec_locorigem := TRIM(TDVADM.FN_BUSCA_CODIGOIBGE(tpipf_conhec.ipf_conhec_origem,'IBD'));
      tpipf_conhec.ipf_conhec_locdestino := TRIM(TDVADM.FN_BUSCA_CODIGOIBGE(tpipf_conhec.Ipf_Conhec_Destino,'IBD'));

      tpipf_conhec.ipf_conhec_idviagem       := '';

      tpipf_conhec.ipf_conhec_pesoreal       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_PSREAL');
      tpipf_conhec.ipf_conhec_pesocob        := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_PSCOBRAD');

      tpipf_conhec.ipf_conhec_vlrmerc        := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_VLMR');
      tpipf_conhec.ipf_conhec_vlrmercsegur   := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_VLRSEGUR');

      tpipf_conhec.ipf_conhec_kmper          := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'S_KMPER');
      tpipf_conhec.ipf_conhec_kmcol          := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'S_KMCOL');

      tpipf_conhec.ipf_conhec_aliquota       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'S_ALICMS');
      If nvl(tpipf_conhec.ipf_conhec_aliquota,0) = 0 Then
         tpipf_conhec.ipf_conhec_aliquota := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'S_ALISS');
      End If;
       
      

      tpipf_conhec.ipf_conhec_baseimposto    := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_BSCLICMS');
      If nvl(tpipf_conhec.ipf_conhec_baseimposto,0) = 0 Then
         tpipf_conhec.ipf_conhec_baseimposto    := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_BSCLISS');
      End If;

      tpipf_conhec.ipf_conhec_vlrimposto     := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_VLICMS');
      If nvl(tpipf_conhec.ipf_conhec_vlrimposto,0) = 0 Then
         tpipf_conhec.ipf_conhec_vlrimposto     := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_VLISS');
      End If;

      tpipf_conhec.ipf_conhec_totalprestacao := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_TTPV');

      tpipf_conhec.ipf_conhec_piscofins      := ( tpipf_conhec.ipf_conhec_totalprestacao * cPercentPis ) +
                                                ( tpipf_conhec.ipf_conhec_totalprestacao * cPercentCofins );

      vFatorTiraImp := ( 100 - tpipf_conhec.ipf_conhec_aliquota ) / 100;

      tpipf_conhec.ipf_conhec_fretepesoci    := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_FRPSVO','V');
--      tpipf_conhec.ipf_conhec_fretepesosi    := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_FRPSVO','V');
      tpipf_conhec.ipf_conhec_fretepesosi  := round(tpipf_conhec.ipf_conhec_fretepesoci * vFatorTiraImp,2);

      tpipf_conhec.ipf_conhec_fretevalorci   := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_ADVL','V');
--      tpipf_conhec.ipf_conhec_fretevalorsi   := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_ADVL','V');
      tpipf_conhec.ipf_conhec_fretevalorsi  := round(tpipf_conhec.ipf_conhec_fretevalorci * vFatorTiraImp,2);

      tpipf_conhec.ipf_conhec_pedagioci      := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_PD','V');
--      tpipf_conhec.ipf_conhec_pedagiosi      := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_PD','V');
      tpipf_conhec.ipf_conhec_pedagiosi  := round(tpipf_conhec.ipf_conhec_pedagioci * vFatorTiraImp,2);

      tpipf_conhec.ipf_conhec_despachaoci    := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_DP','V');
--      tpipf_conhec.ipf_conhec_despachosi     := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_DP','V');
      tpipf_conhec.ipf_conhec_despachosi  := round(tpipf_conhec.ipf_conhec_despachaoci * vFatorTiraImp,2);

      tpipf_conhec.ipf_conhec_seguroci       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_SG','V');
--      tpipf_conhec.ipf_conhec_segurosi       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_SG','V');
      tpipf_conhec.ipf_conhec_segurosi  := round(tpipf_conhec.ipf_conhec_seguroci * vFatorTiraImp,2);

      tpipf_conhec.ipf_conhec_outrosci       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_OT','V');
--      tpipf_conhec.ipf_conhec_outrossi       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_OT1','V') +
--                                                tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_OT2','V') +
--                                                tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_OT3','V');
      tpipf_conhec.ipf_conhec_outrossi  := round(tpipf_conhec.ipf_conhec_outrosci * vFatorTiraImp,2);

      tpipf_conhec.ipf_conhec_cargadescci    := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_CAT','V'); 
--      tpipf_conhec.ipf_conhec_cargadescsi    := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_ESCOLTA','V') +
--                                                tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_CARGA','V') +
--                                                tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_DESCARGA','V');
      tpipf_conhec.ipf_conhec_cargadescsi  := round(tpipf_conhec.ipf_conhec_cargadescci * vFatorTiraImp,2);

      tpipf_conhec.ipf_conhec_colentci       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'I_SEC','V');
--      tpipf_conhec.ipf_conhec_colentsi       := tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_ENTREGA','V') +
--                                                tdvadm.fn_busca_conhec_verba(pConhecimento,pSerie,pRota,'D_COLETA','V');
      tpipf_conhec.ipf_conhec_colentsi  := round(tpipf_conhec.ipf_conhec_colentci * vFatorTiraImp,2);
      
      

     tpipf_conhec.ipf_conhec_codcontrato := tdvadm.pkg_slf_utilitarios.fn_retorna_contratoCod(tpipf_conhec.ipf_conhec_codigo,tpipf_conhec.ipf_conhec_serie,tpipf_conhec.ipf_conhec_rota);
     tpipf_conhec.ipf_conhec_cccontrato  := tdvadm.pkg_slf_utilitarios.fn_retorna_contratoCC(tpipf_conhec.ipf_conhec_codigo,tpipf_conhec.ipf_conhec_serie,tpipf_conhec.ipf_conhec_rota);
 
      
      
      

/*      Begin
         select *
         from tdvadm.t_con_conhecanula          
      exception
        When NO_DATA_FOUND Then
           tpipf_conhec.ipf_conhec_tipocte := 'Normal';
        End;
*/      
      return tpipf_conhec;
     
   End Loop;
  
End fn_ret_ipfConhec;                           



Procedure sp_carregaConhecimento(pReferencia in char)
  As
  tpipf_conhec tdvipf.t_ipf_conhec%rowtype;
  vAuxiliar integer := 0;
Begin

--   delete tdvipf.t_ipf_conhec;
   for c_msg in (select c.con_conhecimento_codigo,
                        c.con_conhecimento_serie,
                        c.glb_rota_codigo,
                        c.con_conhecimento_flagcancelado
                 from tdvadm.t_con_conhecimento c
                 where to_char(c.con_conhecimento_dtembarque,'yyyymm') <= pReferencia
                   and to_char(c.con_conhecimento_dtembarque,'yyyymm') >= '201701'    
                   and c.con_conhecimento_serie <> 'XXX'
                   and nvl(c.con_conhecimento_flagcancelado,'N') = 'N'
/*                   and 0 = (select count(*) from tdvadm.t_con_conhecsubst s
                            where s.con_conhecimento_codigo = c.con_conhecimento_codigo and s.con_conhecimento_serie = c.con_conhecimento_serie and s.glb_rota_codigo = c.glb_rota_codigo) 
                   and 0 = (select count(*) from tdvadm.t_con_conhecsubst s
                            where s.con_conhecimento_codigoorigem  = c.con_conhecimento_codigo and s.con_conhecimento_serieorigem  = c.con_conhecimento_serie and s.glb_rota_codigoorigem  = c.glb_rota_codigo) 
*/                   and 0 = (select count(*) from tdvipf.t_ipf_conhec i
                            where i.ipf_conhec_chave = c.con_conhecimento_codigo || c.con_conhecimento_serie || c.glb_rota_codigo))
   Loop
     
      tpipf_conhec := fn_ret_ipfConhec(c_msg.con_conhecimento_codigo,
                                       c_msg.con_conhecimento_serie,
                                       c_msg.glb_rota_codigo
                                       ); 

      Insert into tdvipf.t_ipf_conhec values tpipf_conhec;
      vAuxiliar := vAuxiliar + 1;
      If mod(vAuxiliar,100) = 0 Then
         commit;   
      End If;   
   End Loop;                            
   commit;


End sp_carregaConhecimento;  

Function fn_ret_ipfVFreteConhec(pValeFrete    in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                pSerieVF      in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                pRotaVF       in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                pSaqaue       in tdvadm.t_con_valefrete.con_valefrete_saque%type, 
                                pConhecimento in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                pSerie        in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                pRota         in tdvadm.t_con_conhecimento.glb_rota_codigo%type)
   return  tdvipf.t_Ipf_Reccust%rowtype
Is
  tpIpf_Reccust tdvipf.t_Ipf_Reccust%rowtype;

Begin
   Begin
      select vf.ipf_valefrete_referencia
        into tpIpf_Reccust.Ipf_Reccust_Referencia
      from tdvipf.t_ipf_valefrete vf
      where vf.ipf_valefrete_chave  = pValeFrete || pSerieVF || pRotaVF || pSaqaue;
   Exception
     when NO_DATA_FOUND Then
        tpIpf_Reccust.Ipf_Reccust_Referencia := '999999';
     End;
   
   tpIpf_Reccust.Ipf_Valefrete_Chave := pValeFrete || pSerieVF || pRotaVF || pSaqaue;
   tpIpf_Reccust.Ipf_Conhec_Chave    := pConhecimento || pSerie || pRota;

   for c_msg in (select *
                 from tdvipf.t_ipf_conhec c
                 where c.ipf_conhec_chave = tpIpf_Reccust.Ipf_Conhec_Chave)
   Loop
     
      tpIpf_Reccust.Ipf_Conhec_Chave := tpIpf_Reccust.Ipf_Conhec_Chave;
      
   End Loop;

   for c_msg in (select *
                 from tdvipf.t_ipf_valefrete v
                 where v.ipf_valefrete_chave = tpIpf_Reccust.Ipf_Valefrete_Chave)
   Loop

      tpIpf_Reccust.Ipf_Valefrete_Chave := tpIpf_Reccust.Ipf_Valefrete_Chave;
      
   End Loop;
      
   
   return tpIpf_Reccust;
     
  
End fn_ret_ipfVFreteConhec;                           


Procedure sp_carregaVFreteConhec(pReferencia in char)
  As
  tpIpf_Reccust tdvipf.t_Ipf_Reccust%rowtype;
  vAuxiliar integer := 0;
Begin

--   delete tdvipf.t_Ipf_Reccust;
   for c_msg in (select v.con_valefrete_codigo,
                        v.con_valefrete_serie,
                        v.glb_rota_codigovalefrete,
                        v.con_valefrete_saque,
                        v.con_conhecimento_codigo,
                        v.con_conhecimento_serie,
                        v.glb_rota_codigo,
                        (select count(*)
                         from tdvipf.t_ipf_conhec c
                         where c.ipf_conhec_chave = v.con_conhecimento_codigo || v.con_conhecimento_serie || v.glb_rota_codigo) qtdecte,
                        (select count(*)
                         from tdvipf.t_ipf_valefrete c
                         where c.ipf_valefrete_chave = v.con_valefrete_codigo || v.con_valefrete_serie || v.glb_rota_codigovalefrete || v.con_valefrete_saque) qtdevf
                 from tdvadm.t_con_vfreteconhec v
                 where to_char(v.con_vfreteconhec_dtgravacao,'YYYYMM') <= pReferencia
                   and to_char(v.con_vfreteconhec_dtgravacao,'YYYYMM') >= '201701'
                   and 0 < ( select count(*)
                             from tdvadm.t_con_valefrete vf
                             where vf.con_conhecimento_codigo = v.con_valefrete_codigo
                               and vf.con_conhecimento_serie  = v.con_valefrete_serie
                               and vf.glb_rota_codigo         = v.glb_rota_codigovalefrete
                               and vf.con_valefrete_saque     = v.con_valefrete_saque
                               and nvl(vf.con_valefrete_status,'N') = 'N')
                   and 0 < (select count(*)
                            from tdvadm.t_con_conhecimento ct
                            where ct.con_conhecimento_codigo = v.con_conhecimento_codigo
                              and ct.con_conhecimento_serie = v.con_conhecimento_serie
                              and ct.glb_rota_codigo = v.glb_rota_codigo
                              and nvl(ct.con_conhecimento_flagcancelado,'N') = 'N')
                   and 0 = (select count(*)
                            from tdvipf.t_Ipf_Reccust vfc
                            where vfc.ipf_valefrete_chave = trim(v.con_valefrete_codigo) || trim(v.con_valefrete_serie) || trim(v.glb_rota_codigovalefrete) || trim(v.con_valefrete_saque)
                              and vfc.ipf_conhec_chave = trim(v.con_conhecimento_codigo) || trim(v.con_conhecimento_serie) || trim(v.glb_rota_codigo)))
   Loop
     
      tpIpf_Reccust := fn_ret_ipfVFreteConhec(c_msg.con_valefrete_codigo,
                                              c_msg.con_valefrete_serie,
                                              c_msg.glb_rota_codigovalefrete,
                                              c_msg.con_valefrete_saque,
                                              c_msg.con_conhecimento_codigo,
                                              c_msg.con_conhecimento_serie,
                                              c_msg.glb_rota_codigo); 

      If tpIpf_Reccust.Ipf_Reccust_Referencia is not null Then
         Insert into tdvipf.t_Ipf_Reccust values tpIpf_Reccust;
      Else
         dbms_output.put_line('VFC ' || c_msg.con_valefrete_codigo || '-' ||  
                                        c_msg.con_valefrete_serie || '-' ||  
                                        c_msg.glb_rota_codigovalefrete || '-' ||  
                                        c_msg.con_valefrete_saque || '-' ||  
                                        c_msg.con_conhecimento_codigo || '-' ||  
                                        c_msg.con_conhecimento_serie || '-' ||  
                                        c_msg.glb_rota_codigo || '-' ||  
                                        'erro - ' || sqlerrm);
      End If;   

      
      update tdvipf.t_ipf_conhec c
        set c.ipf_conhec_kmtotvf = null,
            c.ipf_conhec_pesototvf = null
      where (C.IPF_CONHEC_CODIGO,
             C.IPF_CONHEC_SERIE,
             C.IPF_CONHEC_ROTA) IN (SELECT VFC.CON_CONHECIMENTO_CODIGO,
                                           VFC.CON_CONHECIMENTO_SERIE,
                                           VFC.GLB_ROTA_CODIGO
                                    FROM TDVADM.T_CON_VFRETECONHEC VFC
                                    WHERE VFC.CON_VALEFRETE_CODIGO = c_msg.con_valefrete_codigo
                                      AND VFC.CON_VALEFRETE_SERIE = c_msg.con_valefrete_serie
                                      AND VFC.GLB_ROTA_CODIGOVALEFRETE = c_msg.glb_rota_codigovalefrete
                                      AND VFC.CON_VALEFRETE_SAQUE = c_msg.con_valefrete_saque);
        
      vAuxiliar := vAuxiliar + 1;
      If mod(vAuxiliar,100) = 0 Then
         commit;   
      End If;   
   End Loop;                            
   commit;

End sp_carregaVFreteConhec;  


Procedure sp_carregaValoresAcumulados
  As
  tpIpf_Reccust tdvipf.t_Ipf_Reccust%rowtype;
  vAuxiliar integer := 0 ;
  vkmtotvf   tdvipf.t_ipf_conhec.ipf_conhec_kmtotvf%type;
  vpesototvf tdvipf.t_ipf_conhec.ipf_conhec_pesototvf%type;
  vQtdeVF    tdvipf.t_ipf_conhec.ipf_conhec_qtdevf%type;
  
Begin

   for c_msg in (select v.ipf_conhec_chave, 
                        v.ipf_conhec_codigo,
                        v.ipf_conhec_serie,
                        v.ipf_conhec_rota,
                        v.rowid
                 from tdvipf.t_ipf_conhec v,
                      tdvipf.t_ipf_reccust r
                 where v.ipf_conhec_chave = r.ipf_conhec_chave
--                   and r.ipf_valefrete_chave like '122656A1011%'
                   and ( nvl(v.ipf_conhec_kmtotvf,0) = 0 OR nvl(v.IPF_CONHEC_PESOTOTVF,0) = 0 ) )
   Loop
      select sum(NVL(vf.Ipf_Valefrete_Kmperc,0)),
             SUM(NVL(CT.IPF_CONHEC_PESOCOB,0)),
             count(distinct vf.ipf_valefrete_chave)
        into vkmtotvf,
             vpesototvf,
             vQtdeVF
      from tdvipf.t_ipf_reccust rc,
           tdvipf.t_ipf_valefrete vf,
           TDVIPF.T_IPF_CONHEC CT
      where RC.IPF_VALEFRETE_CHAVE = VF.IPF_VALEFRETE_CHAVE (+)
        AND RC.IPF_CONHEC_CHAVE = CT.IPF_CONHEC_CHAVE (+) 
        AND rc.ipf_conhec_chave = c_msg.ipf_conhec_chave;
   
   
      
      update tdvipf.t_ipf_conhec cc
        set cc.ipf_conhec_kmtotvf = vkmtotvf,
            CC.IPF_CONHEC_PESOTOTVF = vpesototvf,
            cc.IPF_CONHEC_qtdevf = vQtdeVF
      where cc.rowid = c_msg.rowid;

      vAuxiliar := vAuxiliar +1;
      If mod(vAuxiliar,100) = 0 Then
         commit;   
      End If;   
      
   End Loop;

   commit;
   
End sp_carregaValoresAcumulados;



/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : INDICADORES DE PERFORMANCE FINANCEIRA 
 * OBJETIVO     : CARREGAR OS CODIGOS DOS PNEUS PARA CADA VEICULO VALE DE FRETE PARA SER USADO NO CUSTO DA VIAGEM
 *                USANDO A TABELA DE TFVIPF.T_IPF_PNEU
 *                             
 * ANALISTA     : SIRLANO 
 * PROGRAMADOR  : SIRLANO
 * CRIACAO      : 17/05/2019
 * BANCO        : ORACLE
 *              :
 * PROGRAMA     : sp_carregaPneus
 * PARAMETROS   : NENHUM
 * RETORNO      : ALIMENTA A TABELA TDVIPF.T_IPF_VFRETEPNEU
 *              :
 * ALTERACAO    :
 *
 * ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 */

Procedure sp_carregaPneus
As
  tpipf_vfretepneu      tdvipf.t_ipf_vfretepneu%rowtype;
  tpipf_vfretepneuClear tdvipf.t_ipf_vfretepneu%rowtype;
  vAuxiliar integer := 0;   
Begin
    delete tdvipf.t_ipf_vfretepneu;
    for c_vf in (select vf.ipf_valefrete_chave chave,
                        vf.ipf_valefrete_placa placa,
                        vf.frt_conjveiculo_codigo conj,
                        trunc(vf.ipf_valefrete_cadastro) cadastro
                 from tdvipf.t_ipf_valefrete vf
                 where 0 = (select count(*)
                             from tdvipf.t_ipf_vfretepneu vfp
                             where vfp.ipf_valefrete_chave = vf.ipf_valefrete_chave))
    Loop
       for c_msg in (select m.frt_veiculo_codigo,
                            m.pne_posiçãoroda_codigo || '-' || p.pne_posiçãoroda_descrição posicaoeixo,

                            m.pne_pneus_codigo,
                            hv.pne_marmodpneu_codigo,
                            mm.pne_marmodpneu_descricao,
                            m.pne_movimento_vida,
                            m.pne_movimento_data,
                            m.pne_movimento_datadigitacao
                     from tdvadm.t_pne_movimento m,
                          tdvadm.t_pne_posiçãoroda p,
                          tdvadm.t_pne_histvida hv,
                          tdvadm.t_pne_marmodpneu mm
                     where 0 = 0
                       and m.pne_posiçãoroda_codigo = p.pne_posiçãoroda_codigo (+)
                       and m.pne_pneus_codigo = hv.pne_pneus_codigo
                       and m.pne_movimento_vida = hv.pne_histvida_vida
                       and hv.pne_marmodpneu_codigo = mm.pne_marmodpneu_codigo
--                       and vf.frt_conjveiculo_codigo = 'A006165'
                       and m.frt_veiculo_codigo in (select ce.COD_VEICULO
                                                    from tdvadm.v_frt_histcontengate ce
                                                    where ce.CONJUNTO = c_vf.conj 
--                                                      and ce.CONJUNTO = 'A006165'
                                                      and trunc(c_vf.cadastro) between ce.DATA_ENGATE and ce.DATA_DESENGATE)
                       and m.pne_movimento_sequencia = (select max(m1.pne_movimento_sequencia)
                                                        from tdvadm.t_pne_movimento m1
                                                        where m1.frt_veiculo_codigo = m.frt_veiculo_codigo
                                                          and m1.pne_posiçãoroda_codigo = m.pne_posiçãoroda_codigo
                                                          and m1.pne_movimento_data <= trunc(c_vf.cadastro)))   
       Loop  

          tpipf_vfretepneu := tpipf_vfretepneuClear;
          tpipf_vfretepneu.ipf_valefrete_chave        := c_vf.chave;
          tpipf_vfretepneu.frt_veiculo_codigo         := c_msg.frt_veiculo_codigo;
          tpipf_vfretepneu.ipf_valefrete_placa        := c_vf.placa;
          tpipf_vfretepneu.pne_pneu_codigo            := c_msg.pne_pneus_codigo;
          tpipf_vfretepneu.ipf_pneu_vida              := c_msg.pne_movimento_vida;
          tpipf_vfretepneu.pne_marca_codigo           := c_msg.pne_marmodpneu_codigo;
          tpipf_vfretepneu.ipf_vfretepneu_posicaoeixo := substr(c_msg.posicaoeixo,1,50);
          tpipf_vfretepneu.ipf_pneu_periodoi          := c_vf.cadastro;
          tpipf_vfretepneu.ipf_pneu_periodof          := c_vf.cadastro;
          tpipf_vfretepneu.ipf_valefrete_km           := 0;
          tpipf_vfretepneu.pne_pneu_valor             := 0;
          tpipf_vfretepneu.ipf_pneu_kmrodadom         := 0;
          tpipf_vfretepneu.ipf_pneu_valorm            := 0;
          tpipf_vfretepneu.ipf_vfretepneu_dtcadastro  := sysdate;
          begin
             insert into tdvipf.t_ipf_vfretepneu values tpipf_vfretepneu;         
          exception
            when OTHERS Then
               dbms_output.put_line('PNEUS C - ' || c_vf.conj || ' P- ' || c_msg.pne_pneus_codigo || 'Cad- ' || c_vf.cadastro || ' Vida- ' || c_msg.pne_movimento_vida || chr(10) || sqlerrm);
            End;

          vAuxiliar := vAuxiliar +1;
          If mod(vAuxiliar,100) = 0 Then
             commit;      
          End If;   
      End Loop;
   end Loop;
   commit;
End sp_carregaPneus;



/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 *
 * SISTEMA      : INDICADORES DE PERFORMANCE FINANCEIRA 
 * OBJETIVO     : PESQUISA O PROXIMO VALE DE FRETE PARA A PLACA E PEGA COMO DATA DE FIM DE VIAGEM
 *                USANDO A TABELA DE TFVIPF.T_IPF_VALEFRETE
 *                             
 * ANALISTA     : SIRLANO 
 * PROGRAMADOR  : SIRLANO
 * CRIACAO      : 17/05/2019
 * BANCO        : ORACLE
 *              :
 * PROGRAMA     : sp_calculaFimViagem
 * PARAMETROS   : NENHUM
 * RETORNO      : ATUALIZA A TABELA TDVIPF.T_IPF_VALEFRETE
 *              :
 * ALTERACAO    :
 *
 * ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 */

Procedure sp_calculaFimViagem
As
  vDataFimViagem  tdvipf.t_ipf_valefrete.ipf_valefrete_fimviagem%type;
  vChaveFimViagem tdvipf.t_ipf_valefrete.ipf_valefrete_chavefv%type;
  vtpfimviagem    tdvipf.t_ipf_valefrete.ipf_tpfimviagem_codigo%type;
  vAuxiliar number := 0;
Begin

   for c_msg in (select vf.ipf_valefrete_chave,
                        vf.ipf_valefrete_codigo,
                        vf.ipf_valefrete_serie,
                        vf.ipf_valefrete_rota,
                        vf.ipf_valefrete_saque,
                        vf.ipf_valefrete_placa,
                        vf.frt_conjveiculo_codigo,
                        vf.ipf_valefrete_cadastro,
                        vf.glb_tpmotorista_codigo,
                        vf.rowid
                 from tdvipf.t_ipf_valefrete vf
                 where vf.ipf_valefrete_fimviagem is null
                   and vf.glb_tpmotorista_codigo in ('F','A')
--                   and vf.ipf_valefrete_codigo = '782294'
                )

   Loop
      
      vDataFimViagem := null;
      vChaveFimViagem := null;
      vtpfimviagem := '01';
     
      for c_msg1 in (select vf.con_conhecimento_codigo || vf.con_conhecimento_serie || vf.glb_rota_codigo || vf.con_valefrete_saque ipf_valefrete_chavefv,
                            vf.con_catvalefrete_codigo,
                            --vf.con_valefrete_kmprevista,
                            vf.con_valefrete_datacadastro,
                            --vf.cax_boletim_data,
                            --vf.acc_acontas_numero,
                            vf.con_valefrete_obs
                     from tdvadm.t_con_valefrete vf
                     where vf.con_valefrete_placa = decode(TRIM(c_msg.glb_tpmotorista_codigo),'F',c_msg.frt_conjveiculo_codigo,c_msg.ipf_valefrete_placa)
                       and vf.con_valefrete_datacadastro > c_msg.ipf_valefrete_cadastro
                       and vf.con_valefrete_datacadastro < vf.con_valefrete_datacadastro + 30
                       and vf.con_conhecimento_codigo <> c_msg.ipf_valefrete_codigo
                       and nvl(vf.con_valefrete_status,'N') = 'N'
                     --  and nvl(vf.con_valefrete_impresso,'N') = 'S'
/*  retirado a critica a pedido do Dantas em 24/05/2019
                       and (select count(*)
                            from tdvadm.t_con_vfreteconhec vfc
                            where vfc.con_valefrete_codigo = vf.con_conhecimento_codigo
                              and vfc.con_valefrete_serie = vf.con_conhecimento_serie
                              and vfc.glb_rota_codigovalefrete = vf.glb_rota_codigo
                              and vfc.con_valefrete_saque = vf.con_valefrete_saque) > 0
*/                    )
      Loop
         If c_msg1.con_valefrete_datacadastro < nvl(vDataFimViagem,sysdate) Then
            vDataFimViagem := c_msg1.con_valefrete_datacadastro;
            vChaveFimViagem := c_msg1.ipf_valefrete_chavefv;
         End If;
      end Loop;
      
      If vDataFimViagem is null and vChaveFimViagem is null Then
         vtpfimviagem := '00';
      End If;
      
      update tdvipf.t_ipf_valefrete vv
        set vv.ipf_valefrete_fimviagem = vDataFimViagem,
            vv.ipf_tpfimviagem_codigo = vtpfimviagem,
            vv.ipf_valefrete_chavefv = vChaveFimViagem
      where vv.rowid = c_msg.rowid;      

      vAuxiliar := vAuxiliar +1;
      If mod(vAuxiliar,100) = 0 Then
         commit;
      End If;

  End Loop;
  Commit;
  
End sp_calculaFimViagem;


procedure sp_carregaSemParar(pReferencia in char)
As
  vtVlrSemParar tdvipf.t_ipf_valefrete.ipf_valefrete_sparar%type;
  vAuxiliar number := 0;
  VlrSparardrr tdvipf.t_ipf_drtreccust.ipf_drt_sparar%type;
  vContaGeral number;
  vVlrSPararTotal tdvipf.t_ipf_drtreccust.ipf_drt_sparar%type;
  vAuxSparar number;
  vValorTotalSP tdvipf.t_Ipf_Drtreccust.ipf_drt_sparar%type;
Begin

   for c_msg in (select vf.ipf_valefrete_chave,
                        vf.ipf_valefrete_codigo,
                        vf.ipf_valefrete_serie,
                        vf.ipf_valefrete_rota,
                        vf.ipf_valefrete_saque,
                        vf.ipf_valefrete_placa,
                        vf.frt_conjveiculo_codigo,
                        vf.ipf_valefrete_cadastro,
                        vf.ipf_valefrete_fimviagem,
                        vf.glb_tpmotorista_codigo,
                        vf.rowid
                 from tdvipf.t_ipf_valefrete vf
                 where nvl(vf.ipf_valefrete_sparar,0) <= 0
                   and vf.ipf_valefrete_fimviagem is not null
                   and vf.glb_tpmotorista_codigo in ('F')
--                   and vf.ipf_valefrete_codigo = '782294'
                )

   Loop
      
      vtVlrSemParar := 0;

      SELECT SUM(SP.IPF_SPARAR_VALOR)
        INTO vtVlrSemParar
      FROM tdvipf.T_IPF_SPARAR SP
      WHERE SP.IPF_SPARAR_DATA >= c_msg.ipf_valefrete_cadastro
         AND SP.IPF_SPARAR_DATA <=  c_msg.ipf_valefrete_fimviagem
         AND TRIM(SP.IPF_SPARAR_PLACA) = c_msg.ipf_valefrete_placa;
         
      update tdvipf.t_ipf_valefrete vf
        set vf.ipf_valefrete_sparar = nvl(vtVlrSemParar,0)
      where vf.rowid = c_msg.rowid;   
      
      vAuxiliar := vAuxiliar +1;
      If mod(vAuxiliar,100) = 0 Then
         commit;  
      End If;
     
   End Loop;
   
      for c_frt in (select sp.ipf_sparar_placa placa,
                           sum(sp.ipf_sparar_valor) valor
                     from tdvipf.t_ipf_sparar sp
                    where to_char(sp.ipf_sparar_data,'yyyymm') = pReferencia
                     group by sp.ipf_sparar_placa)
        
   loop  
   
   select count (*)
     into vAuxSparar
     from tdvipf.t_ipf_drtreccust dr
    where dr.ipf_drt_placa = c_frt.placa
      and dr.ipf_drt_referencia = pReferencia;
      
      if vAuxSparar > 0 then
   
      update tdvipf.t_ipf_drtreccust dr
         set dr.ipf_drt_sparar = c_frt.valor
       where dr.ipf_drt_placa = c_frt.placa
         and dr.ipf_drt_referencia = pReferencia
         and dr.ipf_drt_placa <> '9999999';
         
       else
         
            insert into tdvipf.t_ipf_drtreccust
             values(pReferencia,
                    c_frt.placa,
                    'NENC',
                    '',
                    '',
                    '',
                    '',
                    '',
                    c_frt.valor,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '');
          
         
       end if;
      commit;   
   end loop;
   
      select count (*)
       into vContaGeral
       from tdvipf.t_ipf_drtreccust dr
      where dr.ipf_drt_referencia = pReferencia
        and dr.ipf_drt_placa = '9999999';
        
   select sum (dr.ipf_drt_sparar)
     into vValorTotalSP
     from tdvipf.t_ipf_drtreccust dr
    where dr.ipf_drt_referencia = pReferencia
      and dr.ipf_drt_placa <> '9999999';

       if vContaGeral > 0 then
        
      update tdvipf.t_ipf_drtreccust dr
         set dr.ipf_drt_sparar = vValorTotalSP
       where dr.ipf_drt_placa = '9999999'
         and dr.ipf_drt_referencia = pReferencia;
       else
           
           insert into tdvipf.t_ipf_drtreccust
             values(pReferencia,
                    '9999999',
                    '9999999',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    vValorTotalSP,
                    '',
                    '');
                  
          end if;
     
   commit;  
End sp_carregaSemParar;


procedure sp_carregaMIX(pReferencia in char)
As
  vtVlrQueima tdvipf.t_ipf_valefrete.ipf_valefrete_mixqueima%type;
  vtVlrKM     tdvipf.t_ipf_valefrete.ipf_valefrete_mixkm%type;
  vAuxiliar number := 0;
  vDataIni  char(19);
  vDataFim  char(19);
  vValorFrota tdvipf.t_ipf_valefrete.ipf_valefrete_mixkm%type;
  vValorTotal tdvipf.t_ipf_indicadoresfrota.ipf_indicadoresfrota_kmtotalref%type;
  vContaGeral number;
  vContaFrota number;
Begin

   for c_msg in (select vf.ipf_valefrete_chave,
                        vf.ipf_valefrete_codigo,
                        vf.ipf_valefrete_serie,
                        vf.ipf_valefrete_rota,
                        vf.ipf_valefrete_saque,
                        vf.ipf_valefrete_placa,
                        vf.frt_conjveiculo_codigo,
                        vf.ipf_valefrete_cadastro,
                        vf.ipf_valefrete_fimviagem,
                        vf.glb_tpmotorista_codigo,
                        vf.rowid
                 from tdvipf.t_ipf_valefrete vf
                 where 0 = 0
                   -- nvl(vf.ipf_valefrete_sparar,0) <= 0
                   and vf.ipf_valefrete_fimviagem is not null
                   and vf.glb_tpmotorista_codigo in ('F')
--                   and vf.ipf_valefrete_codigo = '782294'
                )

   Loop
      
      If c_msg.ipf_valefrete_codigo = '040456' Then
         vAuxiliar := vAuxiliar;
      End If;
      
      vDataIni := to_char(c_msg.ipf_valefrete_cadastro,'dd/mm/yyyy hh24:mi:ss');
      vDataFim := to_char(c_msg.ipf_valefrete_fimviagem,'dd/mm/yyyy hh24:mi:ss');
      If length(trim(vDataIni)) = 10 Then
         vDataIni := vDataIni || ' 00:00:00';
      End If;

      If length(trim(vDataIni)) = 10 Then
         vDataFim := vDataFim || ' 00:00:00';
      End If;

    Begin
    SELECT SUM(MC.FRT_INTMIXCONSUMO_CONSUMO),
           SUM(MC.FRT_INTMIXCONSUMO_KMRODADO)
      INTO vtVlrQueima,
           vtVlrKM
      FROM TDVADM.T_FRT_INTMIXCONSUMO MC,
           TDVADM.T_FRT_INTMIXVEICULO MV
     WHERE MV.FRT_INTMIXVEICULO_ID = MC.FRT_INTMIXVEICULO_ID
       AND MV.FRT_INTMIXVEICULO_PLACA = c_msg.ipf_valefrete_placa
       AND MC.FRT_INTMIXCONSUMO_DATA >= to_date(vDataIni,'dd/mm/yyyy hh24:mi:ss')
       AND MC.FRT_INTMIXCONSUMO_DATA <= to_date(vDataFim,'dd/mm/yyyy hh24:mi:ss');
   exception
     when OTHERS Then
        vtVlrQueima := 0;
        vtVlrKM := 0;
     End;
     
     
    Begin
    SELECT SUM(MC.FRT_INTMIXCONSUMO_KMRODADO)
      INTO vValorFrota
      FROM TDVADM.T_FRT_INTMIXCONSUMO MC,
           TDVADM.T_FRT_INTMIXVEICULO MV
     WHERE MV.FRT_INTMIXVEICULO_ID = MC.FRT_INTMIXVEICULO_ID
       AND MV.FRT_INTMIXVEICULO_PLACA = c_msg.ipf_valefrete_placa
       AND to_char(MC.FRT_INTMIXCONSUMO_DATA,'yyyymm')  = pReferencia;
   exception
     when OTHERS Then
        vValorFrota := 0;
     End;
            
      update tdvipf.t_ipf_valefrete vf
        set vf.ipf_valefrete_mixqueima = vtVlrQueima,
            vf.ipf_valefrete_mixkm = vtVlrKM
      where vf.rowid = c_msg.rowid;
      
      vAuxiliar := vAuxiliar +1;
      If mod(vAuxiliar,100) = 0 Then
         commit;  
      End If;
   End Loop;   
            
    for c_frt in (select dr.ipf_drt_referencia,
                         dr.ipf_drt_placa
                    from tdvipf.t_ipf_drtreccust dr
                   where dr.ipf_drt_referencia = pReferencia
                     and dr.ipf_drt_placa <> '9999999')
                   
   loop
     
      select count (*)
        into vContaFrota
        from tdvadm.t_frt_veiculo    ve,
             tdvadm.t_frt_conteng    cj,
             tdvadm.t_frt_marmodveic ma,
             tdvadm.t_frt_tpveiculo  tp
       where ve.frt_veiculo_codigo = cj.frt_veiculo_codigo
         and trunc(nvl(ve.frt_veiculo_datavenda, sysdate)) >= trunc(sysdate)
         and ve.frt_marmodveic_codigo = ma.frt_marmodveic_codigo
         and ma.frt_tpveiculo_codigo = tp.frt_tpveiculo_codigo
         and tp.frt_tpveiculo_tracao = 'S'
         and substr(ve.frt_veiculo_codigo, 1, 2) <> 'A0'
         and ve.frt_veiculo_placa = c_frt.ipf_drt_placa
         and ma.frt_marmodveic_modelo not in
             ('BIZ 125 ES', 'SR', 'GOL 1.0 PLUS', 'SR');
     
    if vContaFrota > 0 then
      
     SELECT SUM(MC.FRT_INTMIXCONSUMO_KMRODADO)
      INTO vValorFrota
      FROM TDVADM.T_FRT_INTMIXCONSUMO MC,
           TDVADM.T_FRT_INTMIXVEICULO MV
     WHERE MV.FRT_INTMIXVEICULO_ID = MC.FRT_INTMIXVEICULO_ID
       AND MV.FRT_INTMIXVEICULO_PLACA = c_frt.ipf_drt_placa
       AND to_char(MC.FRT_INTMIXCONSUMO_DATA,'yyyymm')  = pReferencia;     
     
     update tdvipf.t_ipf_indicadoresfrota id
        set id.ipf_indicadoresfrota_kmchave = vValorFrota
      where id.ipf_indicadoresfrota_placa = c_frt.ipf_drt_placa
        and id.ipf_indicadoresfrota_referencia = pReferencia;      
         
      update tdvipf.t_ipf_drtreccust dr
         set dr.ipf_drt_km = vValorFrota
       where dr.ipf_drt_placa = c_frt.ipf_drt_placa
         and dr.ipf_drt_referencia = pReferencia;
         
      end if;     
      
   end loop;
   
     begin
    SELECT SUM(MC.FRT_INTMIXCONSUMO_KMRODADO)
      INTO vValorTotal
      FROM TDVADM.T_FRT_INTMIXCONSUMO MC,
           TDVADM.T_FRT_INTMIXVEICULO MV
     WHERE MV.FRT_INTMIXVEICULO_ID = MC.FRT_INTMIXVEICULO_ID
       AND to_char(MC.FRT_INTMIXCONSUMO_DATA,'yyyymm') = pReferencia;
   exception
     when OTHERS Then
        vValorTotal := vValorTotal;
     End;

     update tdvipf.t_ipf_indicadoresfrota id
        set id.ipf_indicadoresfrota_kmtotalref = vValorTotal
      where id.ipf_indicadoresfrota_referencia = pReferencia;

      select count (*)
        into vContaGeral
        from tdvipf.t_ipf_drtreccust dr
       where dr.ipf_drt_referencia = pReferencia
         and dr.ipf_drt_placa = '9999999';
      
      if vContaGeral > 0 then
        
      update tdvipf.t_ipf_drtreccust dr
         set dr.ipf_drt_km = vValorTotal
       where dr.ipf_drt_placa = '9999999'
         and dr.ipf_drt_referencia = pReferencia;
       else
           
           insert into tdvipf.t_ipf_drtreccust
             values(pReferencia,
                    '9999999',
                    '9999999',
                    '',
                    vValorTotal,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '');
                  
          end if;
   commit;  
End sp_carregaMIX;

procedure sp_carregaIPVA(pReferencia in char)
/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Custos
* PROGRAMA    : IPVA Frotas
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 20/11/2019
* BANCO       : ORACLE
* SIGLAS      : IPF, FRT, CTB
* OWNERS      : TDVADM, TDVIPF 
* DESCRICAO   : Verifico todos os lançamentos contábeis realizados na conta relacionada a pagamento
*             : de IPVA dos veículos da frota e gravo na tabela para analise do setor de custos.
---------------------------------------------------------------------------------------------------
*/
As
--Declaro todas as variáveis que serão utilizadas.
vPlaca          tdvadm.t_frt_veiculo.frt_veiculo_placa%type;
vPlacaExiste    number;
vPlacaSemIPVA   number;
vContador       number;
vFrota          char(7);
vFrotaAux       char(7);
vMessage        clob;
vAuxiliar       char(1);
vValorTotal     number(14,2);
vStatus         char(1);
vContaLanc      number;
vRefAux         char(4);
vCodVeic        tdvadm.t_frt_veiculo.frt_veiculo_codigo%type;
vValorTotalRef  number(14,2);
vContaGeral     number;
vContaFrota     number;

 Begin
   
 vStatus := 'N';
   
    --Monto o cursor para pegar a placa e codigo do frota daquela refência passada.
   for c_msg in (select m.ctb_movimento_descricao descricao, 
                        substr(m.ctb_movimento_descricao,instr(m.ctb_movimento_descricao,'FROTA')+11,7) placa,
                        m.ctb_movimento_valor valor
                   from tdvadm.t_ctb_movimento m 
                  where m.ctb_pconta_codigo_partida = '330513053300'
                    and m.ctb_movimento_tvalor = 'D'
                    and m.ctb_referencia_codigo_partida = pReferencia
                     and instr(m.ctb_movimento_descricao,'IPVA FROTA') <> 0)

                    
    loop
      
      -- Igualo as variaveis conforme os dados que busco no cursor
       vPlaca := c_msg.Placa;
       
       begin
       -- Pego o codigo do veiculo.
       select ve.frt_veiculo_codigo
         into vCodVeic
         from tdvadm.t_frt_veiculo ve
        where ve.frt_veiculo_placa = vPlaca
          and trunc(nvl(ve.frt_veiculo_datavenda,sysdate)) >= trunc (sysdate)
          and substr(ve.frt_veiculo_codigo,1,2) <> 'A0';
          exception
            when others then
              vCodVeic := vCodVeic;
         end;
       
          
       begin
       -- Pego o código do conjunto no histórico    
       select hi.frt_conjveiculo_codigo
         into vFrotaAux
         from tdvadm.t_frt_histconteng hi
        where hi.frt_veiculo_codigo = vCodVeic
          and hi.frt_conteng_dataengate = (select min (hi.frt_conteng_dataengate)
                                             from tdvadm.t_frt_histconteng hg
                                            where hg.frt_veiculo_codigo = hi.frt_veiculo_codigo)
          and rownum = 1;
          exception
            when others then
              vFrotaAux := null;
         end;
       
       
       if vFrotaAux is null then
         
       begin
       --Pego o código do conjunto na conteng se não tiver no histórico
       select cj.frt_conjveiculo_codigo
        into vFrota
        from tdvadm.t_frt_veiculo ve,
             tdvadm.t_frt_conteng cj,
             tdvadm.t_frt_marmodveic ma,
             tdvadm.t_frt_tpveiculo tp
       where ve.frt_veiculo_codigo = cj.frt_veiculo_codigo
         and ve.frt_marmodveic_codigo = ma.frt_marmodveic_codigo
         and ma.frt_tpveiculo_codigo = tp.frt_tpveiculo_codigo
         and tp.frt_tpveiculo_tracao = 'S'
         and substr(ve.frt_veiculo_codigo,1,2) <> 'A0'
         and ve.frt_veiculo_placa = vPlaca
         and rownum = 1;
         exception
           when others then
             vFrota := 'NENC';
         end;
         
         end if;
       
       -- Alimento a variavel para verificar se a placa existe no banco.
       select count (*)
         into vPlacaExiste
         from tdvadm.t_frt_veiculo ve
        where ve.frt_veiculo_placa = vPlaca
          and (ve.frt_veiculo_datavenda is null or to_char(ve.frt_veiculo_datavenda,'yyyymm') < pReferencia);
        
        /* Alimento a variavel para verificar se existe alguma placa que não tem o 
           IPVA lançado naquela refência. */
      select count (*)
        into vPlacaSemIPVA
        from tdvadm.t_frt_veiculo ve
       where (ve.frt_veiculo_datavenda is null or to_char(ve.frt_veiculo_datavenda,'yyyymm') < pReferencia)
         and ve.frt_veiculo_placa = vPlaca
         and (select count (*)
                from tdvadm.t_ctb_movimento m 
               where m.ctb_pconta_codigo_partida = '330513053300'
                 and m.ctb_movimento_tvalor = 'D'
                 and instr(m.ctb_movimento_descricao,vPlaca) <> 0
                 and m.ctb_referencia_codigo_partida = pReferencia
                 and ve.frt_veiculo_placa = vPlaca
                 and instr(m.ctb_movimento_descricao,'IPVA FROTA') <> 0) = 0;
       
      -- Alimento variavel para utilizar referencia baseada apenas no ano.
      select substr (pReferencia,0,4)
        into vRefAux
        from dual;
      
      -- Verifico quantos lançamentos de IPVA existem para a placa naquele ano.
      select count (*)
        into vContaLanc
        from tdvadm.t_ctb_movimento m 
       where m.ctb_pconta_codigo_partida = '330513053300'
         and m.ctb_movimento_tvalor = 'D'
         and instr(m.ctb_movimento_descricao,vPlaca) <> 0
         and (m.ctb_referencia_codigo_partida) >= vRefAux
         and instr(m.ctb_movimento_descricao,'IPVA FROTA') <> 0;        
        
        -- Verifico se já existe registro para essa placa e referencia.
       select count (*)
         into vAuxiliar
         from tdvipf.t_ipf_drtreccust dr
        where dr.ipf_drt_placa = vPlaca
          --and dr.ipf_drt_conjunto = vFrota
          and dr.ipf_drt_referencia = pReferencia;
        
        -- Somo o valor total lançado de IPVA para a placa naquele ano.
        select sum (m.ctb_movimento_valor)
          into vValorTotal
          from tdvadm.t_ctb_movimento m 
         where m.ctb_pconta_codigo_partida = '330513053300'
           and m.ctb_movimento_tvalor = 'D'
           and instr(m.ctb_movimento_descricao,vPlaca) <> 0
           and m.ctb_referencia_codigo_partida >= vRefAux
           and instr(m.ctb_movimento_descricao,'IPVA FROTA') <> 0;
         
        -- Somo o valor total lançado de IPVA na referemcia independente da placa.   
        select sum (m.ctb_movimento_valor)
          into vValorTotalRef
          from tdvadm.t_ctb_movimento m 
         where m.ctb_pconta_codigo_partida = '330513053300'
           and m.ctb_movimento_tvalor = 'D'
           and m.ctb_referencia_codigo_partida = pReferencia
           and instr(m.ctb_movimento_descricao,'IPVA FROTA') <> 0;
           
         -- Verifico se existe o valor total lançado na placa 9999999.
         
         select count (*)
           into vContaGeral
           from tdvipf.t_ipf_drtreccust dr
          where dr.ipf_drt_referencia = pReferencia
            and dr.ipf_drt_placa = '9999999';
          
          --Caso tenha o registro geral do valor de IPVA para a referência  
          if vContaGeral > 0 then  
           
          -- Coloco o valor total de IPVA lançado para a Referencia.
           update tdvipf.t_ipf_drtreccust id
              set id.ipf_drt_ipva = vValorTotalRef
            where id.ipf_drt_referencia = pReferencia
              and id.ipf_drt_placa = '9999999';
              
          else
            
          -- Insiro o registro para a referência colocando os valores
          insert into tdvipf.t_ipf_drtreccust
             values(pReferencia,
                    '9999999',
                    '9999999',
                    '',
                    '',
                    '',
                    '',
                    vValorTotalRef,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    vContaLanc,
                    '');
                  
          end if;
        
      select count (*)
        into vContaFrota
        from tdvadm.t_frt_veiculo    ve,
             tdvadm.t_frt_conteng    cj,
             tdvadm.t_frt_marmodveic ma,
             tdvadm.t_frt_tpveiculo  tp
       where ve.frt_veiculo_codigo = cj.frt_veiculo_codigo
         and trunc(nvl(ve.frt_veiculo_datavenda, sysdate)) >= trunc(sysdate)
         and ve.frt_marmodveic_codigo = ma.frt_marmodveic_codigo
         and ma.frt_tpveiculo_codigo = tp.frt_tpveiculo_codigo
         and tp.frt_tpveiculo_tracao = 'S'
         and substr(ve.frt_veiculo_codigo, 1, 2) <> 'A0'
         and ve.frt_veiculo_placa = vPlaca
         and ma.frt_marmodveic_modelo not in
             ('BIZ 125 ES', 'SR', 'GOL 1.0 PLUS', 'SR');   
        
     if vContaFrota > 0 then
       --Se a placa existir no banco e o IPVA estiver lançado inicio as proximas validações.
        if vPlacaExiste > 0 and vPlacaSemIPVA = 0 then
          
          /* Se placa tem IPVA lançado e o registro ainda não existe com placa, conjunto
             e refência, executo o insert na tabela*/
          if  vAuxiliar = 0 then
            
             insert into tdvipf.t_ipf_drtreccust dr
             values(pReferencia,
                    vPlaca,
                    vFrota,
                    '',
                    '',
                    '',
                    '',
                    vValorTotal,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    vContaLanc,
                    '');
                    
          --Caso já exista o registro, apenas realizo um update para atualizar os valores
          else         
           
           update tdvipf.t_ipf_drtreccust dr
              set dr.ipf_drt_ipva = vValorTotal,
                  dr.ipf_drt_qtdlancipva = vContaLanc
            where dr.ipf_drt_referencia = pReferencia
              and dr.ipf_drt_placa = vPlaca;
              --and dr.ipf_drt_conjunto = vFrota;
           
          end if;
          
        else
           
          --Caso a placa não exista, gravo uma mensagem e passo ao setor do custo.
          if vPlacaExiste = 0 then
           
           vMessage := vMessage || chr(10) || 'A placa ' || vPlaca || ' não está cadastrada no sistema ou já tem data de venda porém está com IPVA lançado após venda, favor verificar com contabilidade e operacional ' || chr(10);
           vStatus  := 'E';
           
          --Caso a placa não tenha IPVA lançado na referência, gravo uma mensagem e passo ao setor do custo.
          elsif vPlacaSemIPVA > 0 then
            
          vMessage := vMessage || chr(10) || 'A placa ' || vPlaca || ' não tem IPVA lançado nessa referência, dúvidas entre em contato com a contabilidade ' || chr(10);
          vStatus  := 'E';
          
          end if;
          
        end if;
        
        -- Verifico se houve alguma critica e envio o e-mail com a validação.
     end if;
    end loop;
    
       if vStatus = 'E' then
         
        vMessage := 'Foi possivel processar o IPVA dos frotas na referência ' || pReferencia || ' com sucesso, SEGUE CRITICAS: ' ||chr(10)|| vMessage;
        
         wservice.pkg_glb_email.SP_ENVIAEMAIL('Carrega IPVA',
                                              vMessage,
                                              'rafael.aiti@dellavolpe.com.br',
                                              'jose.dantas@dellavolpe.com.br');
                                              
       -- Caso não tenha nenhuma critica, apenas envio informando que o IPVA foi carregado.
        else
          vMessage := 'Foi possivel processar o IPVA dos frotas na referência ' || pReferencia || ' com sucesso';
          
         wservice.pkg_glb_email.SP_ENVIAEMAIL('Carrega IPVA',
                                              vMessage,
                                              'rafael.aiti@dellavolpe.com.br',
                                              'jose.dantas@dellavolpe.com.br');
        end if;
        
       commit;

end sp_carregaIPVA;

procedure sp_carregaSeguro(pReferencia in char)
/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Custos
* PROGRAMA    : Seguro Frota
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 11/12/2019
* BANCO       : ORACLE
* SIGLAS      : IPF, FRT, CTB
* OWNERS      : TDVADM, TDVIPF 
* DESCRICAO   : Somo todos os lançamentos contábeis da conta de seguro da frota e alimento a
*             : tabela de diretos na placa 9999999 (Sem Placa, Totais)
---------------------------------------------------------------------------------------------------
*/
as
--Declaro as variaveis
vValorSeguro tdvipf.t_ipf_drtreccust.ipf_drt_rastreamento%type;
vContaDrr number;

  begin
-- Começo somando o valor total de seguro para aquela referência.
select sum (a.ctb_movimento_valor)
 into vValorSeguro
 from tdvadm.t_ctb_movimento a
where a.ctb_pconta_codigo_cpartida = '111111300001'
  and a.ctb_referencia_codigo_partida = pReferencia
  and a.glb_centrocusto_codigo = '3069';
  
-- Verifico se já existe na tabela de diretos a placa 9999999 (Custo Total, sem placa) com a referencia.
  select count (*)
    into vContaDrr
    from tdvipf.t_ipf_drtreccust dt
   where dt.ipf_drt_referencia = pReferencia
     and dt.ipf_drt_placa = '9999999';

-- Caso existir, realizo um update.  
  if vContaDrr > 0  then
  
  update tdvipf.t_ipf_drtreccust dr
     set dr.ipf_drt_seguro = vValorSeguro
   where dr.ipf_drt_referencia = pReferencia
     and dr.ipf_drt_placa = '9999999';
     
--Caso não tenha, insiro o registro na tabela.
  else
     insert into tdvipf.t_ipf_drtreccust dr
     values(pReferencia,
            '9999999',
            '9999999',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            vValorSeguro,
            '',
            '',
            '',
            '',
            '',
            '');
  end if;
  
end sp_carregaSeguro;

procedure sp_carregaRastreamento(pReferencia in char)
/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Custos
* PROGRAMA    : Rastreamento Frota
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 11/12/2019
* BANCO       : ORACLE
* SIGLAS      : IPF, FRT, CTB
* OWNERS      : TDVADM, TDVIPF 
* DESCRICAO   : Somo todos os lançamentos contábeis da conta de rastreamento do centro de custo 3068
*             : e alimento na tabela de diretos.
---------------------------------------------------------------------------------------------------
*/

as
--Declaro as variaveis
vValorRast tdvipf.t_ipf_drtreccust.ipf_drt_rastreamento%type;
vContaDrr number;

  begin
-- Começo somando o valor total de rastreamento para aquela referência e realizo um update.
select sum (a.ctb_movimento_valor)
 into vValorRast
 from tdvadm.t_ctb_movimento a
where a.ctb_pconta_codigo_cpartida = '330515079070'
  and a.ctb_referencia_codigo_partida = pReferencia
  and a.glb_centrocusto_codigo = '3068';
  
-- Verifico se já existe na tabela de diretos a placa 9999999 (Custo Total, sem placa) com a referencia.
  select count (*)
    into vContaDrr
    from tdvipf.t_ipf_drtreccust dt
   where dt.ipf_drt_referencia = pReferencia
     and dt.ipf_drt_placa = '9999999';

-- Caso existir, realizo um update.  
  if vContaDrr > 0  then
  
  update tdvipf.t_ipf_drtreccust dr
     set dr.ipf_drt_rastreamento = vValorRast
   where dr.ipf_drt_referencia = pReferencia
     and dr.ipf_drt_placa = '9999999';
     
--Caso não tenha, insiro o registro na tabela.
  else
     insert into tdvipf.t_ipf_drtreccust dr
     values(pReferencia,
            '9999999',
            '9999999',
            '',
            '',
            '',
            '',
            '',
            '',
            vValorRast,
            '',
            '',
            '',
            '',
            '',
            '',
            '');
  end if;

end sp_carregaRastreamento;

procedure sp_carregaCTFFrota(pReferencia in char)

/*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Custos
* PROGRAMA    : CTF Frota
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 11/12/2019
* BANCO       : ORACLE
* SIGLAS      : IPF, FRT, ACC
* OWNERS      : TDVADM, TDVIPF 
* DESCRICAO   : Carrego os valores da tabela de integração do abastecimento do CTF e gravo
*             : os registros nas tabelas do custo da frota para apresentar no relatório.
---------------------------------------------------------------------------------------------------
*/

as

 --Declaro as variaveis
vContaFrota  number;
vMessage     clob;
vStatus      char(1);
vPlaca       tdvipf.t_ipf_drtreccust.ipf_drt_placa%type;
vPlacaExiste number;
vValorTotal  number;
vLitroTotal  number;

 -- Monto o curso para obter os dados de plava, valor e quantidade naquela referência.
 
 begin
   
 vStatus := 'N';
 
   for c_msg in (select ab.acc_abastecimento_placa placa,
                        sum(ab.acc_abastecimento_valor) valor,
                        sum(ab.acc_abastecimento_quantidade) litro
                 from tdvadm.t_acc_abastecimento ab
                 where to_char(ab.acc_abastecimento_data,'yyyymm') = pReferencia
                 group by ab.acc_abastecimento_placa)
                 
    loop             
      
    -- Igualo a variável da placa conforme os dados que eu retorno no cursor.           
       
     vPlaca := c_msg.placa;         
      
    -- Alimento a variável verificando se a placa está dentro das condições de frota.
               
        select count (*)
        into vContaFrota
        from tdvadm.t_frt_veiculo    ve,
             tdvadm.t_frt_conteng    cj,
             tdvadm.t_frt_marmodveic ma,
             tdvadm.t_frt_tpveiculo  tp
       where ve.frt_veiculo_codigo = cj.frt_veiculo_codigo
         and trunc(nvl(ve.frt_veiculo_datavenda, sysdate)) >= trunc(sysdate)
         and ve.frt_marmodveic_codigo = ma.frt_marmodveic_codigo
         and ma.frt_tpveiculo_codigo = tp.frt_tpveiculo_codigo
         and tp.frt_tpveiculo_tracao = 'S'
         and substr(ve.frt_veiculo_codigo, 1, 2) <> 'A0'
         and ve.frt_veiculo_placa = vPlaca
         and ma.frt_marmodveic_modelo not in
             ('BIZ 125 ES', 'SR', 'GOL 1.0 PLUS', 'SR');
             
     -- Alimento a variavel para verificar se a placa existe no banco.
     
       select count (*)
         into vPlacaExiste
         from tdvadm.t_frt_veiculo ve
        where ve.frt_veiculo_placa = vPlaca
          and (ve.frt_veiculo_datavenda is null or to_char(ve.frt_veiculo_datavenda,'yyyymm') < pReferencia);
     
     -- Caso as duas confições forem maior que zero, inicio o processo.
     
       if vContaFrota > 0 and vPlacaExiste > 0 then
      
     -- Coloco o valor e litro para a placa na referência.
        
       update tdvipf.t_ipf_drtreccust d
          set d.ipf_drt_combustivelvalor = c_msg.valor,
              d.ipf_drt_combustivellitro = c_msg.litro
        where d.ipf_drt_placa <> '9999999'
          and d.ipf_drt_placa = vPlaca
          and d.ipf_drt_referencia = pReferencia;
       
     vMessage := 'Foi carregado o CTF dos frotas com sucesso!!!';
       
       else
         
     --Caso a placa não exista, gravo uma mensagem e passo ao setor do custo.
           
           vMessage := vMessage || chr(10) || 'A placa ' || vPlaca || ' não está cadastrada no sistema ou já tem data de venda porém está com IPVA lançado após venda, favor verificar com contabilidade e operacional ' || chr(10);
           vStatus  := 'E';
     
       end if;    
       
     end loop;    
     
     
     select sum(ab.acc_abastecimento_valor),
            sum(ab.acc_abastecimento_quantidade)
       into vValorTotal,
            vLitroTotal
       from tdvadm.t_acc_abastecimento ab
      where to_char(ab.acc_abastecimento_data,'yyyymm') = pReferencia;
     
          -- Coloco o valor e litro total independente da placa naquela referência.
     
        update tdvipf.t_ipf_drtreccust d
           set d.ipf_drt_combustivelvalor = vValorTotal,
               d.ipf_drt_combustivellitro = vLitroTotal
         where d.ipf_drt_placa = '9999999'
           and d.ipf_drt_referencia = pReferencia;
          
     
            wservice.pkg_glb_email.SP_ENVIAEMAIL('Carrega CTF',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             'jose.dantas@dellavolpe.com.br');      
  
end sp_carregaCTFFrota;

procedure sp_carregaIndicadores(pReferencia in char)
  /*
*------------------------------------------------------------------------------------------------
* SISTEMA     : Custos
* PROGRAMA    : Indicadores Frota
* ANALISTA    : Rafael Aiti
* PROGRAMADOR : Rafael Aiti
* CRIACAO     : 11/12/2019
* BANCO       : ORACLE
* SIGLAS      : IPF, FRT, CTB
* OWNERS      : TDVADM, TDVIPF 
* DESCRICAO   : Carrego os valores na tabela de indicadores visando os calculos que serão feitos e 
*             : a geração do relatório do custo geral da frota.
---------------------------------------------------------------------------------------------------
*/
as
--Declaro as variáveis
vContaFrota     number;
vKMTotal        tdvipf.t_ipf_drtreccust.ipf_drt_km%type;
vIPVATotal      tdvipf.t_ipf_drtreccust.ipf_drt_ipva%type;
vRastTotal      tdvipf.t_ipf_drtreccust.ipf_drt_rastreamento%type;
vSeguroTotal    tdvipf.t_ipf_drtreccust.ipf_drt_seguro%type;
vSPararTotal    tdvipf.t_ipf_drtreccust.ipf_drt_sparar%type;
vContaAux       number;

begin
-- Insiro os registros na tabela de indicadores frota com as informações da placa da tabela de diretos.
   begin
    insert into tdvipf.t_ipf_indicadoresfrota
    select dr.ipf_drt_referencia,
           dr.ipf_drt_placa,
           '',
           '',
           '',
           '',
           '',
           '',
           '',
           '',
           ''
      from tdvipf.t_ipf_drtreccust dr
     where dr.ipf_drt_referencia = pReferencia
       and (select count (*)
             from tdvipf.t_ipf_indicadoresfrota ic
            where ic.ipf_indicadoresfrota_referencia = dr.ipf_drt_referencia
              and ic.ipf_indicadoresfrota_placa      = dr.ipf_drt_placa) = 0;
     
     --Alimento as variaveis dos totais
     select dt.ipf_drt_km,
            dt.ipf_drt_ipva,
            dt.ipf_drt_rastreamento,
            dt.ipf_drt_seguro
       into vKMTotal, 
            vIPVATotal,
            vRastTotal,  
            vSeguroTotal
       from tdvipf.t_ipf_drtreccust dt
      where dt.ipf_drt_referencia = pReferencia
        and dt.ipf_drt_placa = '9999999';
        
    -- Pego valor total do sem parar.    
     select sum (dr.ipf_drt_sparar)
       into vSPararTotal
       from tdvipf.t_ipf_drtreccust dr
      where dr.ipf_drt_referencia = pReferencia
        and dr.ipf_drt_placa = '9999999';

     
     -- Realizo o update inserindo os valores totais na tabela de indicadores.
     update tdvipf.t_ipf_indicadoresfrota id
        set id.ipf_indicadoresfrota_kmtotalref   = vKMTotal,
            id.ipf_indicadoresfrota_ipvatotal    = vIPVATotal,
            id.ipf_indicadoresfrota_rastreamento = vRastTotal,
            id.ipf_indicadoresfrota_segurototal  = vSeguroTotal,
            id.ipf_indicadoresfrota_sparartotal  = vSPararTotal
      where id.ipf_indicadoresfrota_referencia = pReferencia;
      
      -- Monto cursor para pegar indicador de quantidade de lançamentos na placa no ano.
      for c_msg in (select dr.ipf_drt_placa placa,
                           dr.ipf_drt_qtdlancipva qtdipva
                      from tdvipf.t_ipf_drtreccust dr
                     where dr.ipf_drt_referencia = pReferencia
                       and dr.ipf_drt_placa <> '9999999')
                       
       loop
         
       -- Realizo o update na tabela de indicadores colocando os valores.
          update tdvipf.t_ipf_indicadoresfrota id
             set id.ipf_indicadores_qtdlancipva = c_msg.qtdipva
           where id.ipf_indicadoresfrota_referencia = pReferencia
             and id.ipf_indicadoresfrota_placa = c_msg.placa;
       
       end loop;                 
     
    exception
      when others then
        vContaFrota := vContaFrota;
    end;
    
    commit;
    
    select count (*)
      into vContaFrota
     from tdvipf.t_ipf_indicadoresfrota id
    where id.ipf_indicadoresfrota_referencia = pReferencia;
    
    update tdvipf.t_ipf_indicadoresfrota it
       set it.ipf_indicadoresfrota_qtdtotalveic = vContaFrota
     where it.ipf_indicadoresfrota_referencia = pReferencia;
 
end sp_carregaIndicadores;

procedure sp_carregaCTF
As
  vtVlrLitroKM     tdvipf.t_ipf_valefrete.ipf_valefrete_ctfcustoKM%type;
  vtVlrLitroLT     tdvipf.t_ipf_valefrete.ipf_valefrete_ctfcustoLT%type;
  vtKMTotalMIX     number;
  vtVlrTotalCTF    number;
  vAuxiliar number := 0;
  vDataI  date;
  vDataF  date;
Begin

   for c_msg in (select vf.ipf_valefrete_chave,
                        vf.ipf_valefrete_codigo,
                        vf.ipf_valefrete_serie,
                        vf.ipf_valefrete_rota,
                        vf.ipf_valefrete_saque,
                        vf.ipf_valefrete_placa,
                        vf.frt_conjveiculo_codigo,
                        vf.ipf_valefrete_cadastro,
                        vf.ipf_valefrete_fimviagem,
                        vf.glb_tpmotorista_codigo,
                        vf.ipf_valefrete_mixkm,
                        vf.rowid
                 from tdvipf.t_ipf_valefrete vf
                 where nvl(vf.ipf_valefrete_sparar,0) <= 0
                   and vf.ipf_valefrete_fimviagem is not null
                   and vf.glb_tpmotorista_codigo in ('F')
--                   and vf.ipf_valefrete_codigo = '782294'
                )

   Loop
      

      vDataI := to_date('01/' || to_char(c_msg.ipf_valefrete_cadastro,'MM/YYYY') , 'DD/MM/YYYY');
      vDataF := last_day(c_msg.ipf_valefrete_fimviagem); 

      BEGIN
         SELECT ABST_JAN.VALOR / (ABST_JAN.KM_ATUAL - ABST_JAN.KM_ANTERIOR) CUSTO_KM,
                ABST_JAN.VALOR / ABST_JAN.QTDE CUSTO_LT,
                ABST_JAN.VALOR
            INTO vtVlrLitrokm,
                 vtVlrLitroLT,
                 vtVlrTotalCTF
         FROM (SELECT TO_CHAR(AB.ACC_ABASTECIMENTO_DATA,'YYYYMM') REFR,
                      AB.FRT_CONJVEICULO_CODIGO VEICULO,
                      AB.POS_CADASTRO_CGC POSTO,
                      MAX((SELECT MAX(TRUNC(AB1.ACC_ABASTECIMENTO_DATA+1))
                           FROM TDVADM.T_ACC_ABASTECIMENTO AB1
                           WHERE AB1.FRT_CONJVEICULO_CODIGO = AB.FRT_CONJVEICULO_CODIGO
                             AND TO_NUMBER(AB1.ACC_ABASTECIMENTO_KM) < TO_NUMBER(AB.ACC_ABASTECIMENTO_KM)
                             AND TRUNC(AB1.ACC_ABASTECIMENTO_DATA) = (SELECT MAX(TRUNC(AB2.ACC_ABASTECIMENTO_DATA))
                                                                      FROM TDVADM.T_ACC_ABASTECIMENTO AB2
                                                                      WHERE AB2.FRT_CONJVEICULO_CODIGO = AB.FRT_CONJVEICULO_CODIGO
                                                                        AND TO_NUMBER(AB2.ACC_ABASTECIMENTO_KM) <= TO_NUMBER(AB.ACC_ABASTECIMENTO_KM)
                                                                        AND TRUNC(AB2.ACC_ABASTECIMENTO_DATA) < TRUNC(AB.ACC_ABASTECIMENTO_DATA)))) DATA_ANTERIOR,
                      TRUNC(AB.ACC_ABASTECIMENTO_DATA) DATA_ATUAL,
                      SUM(AB.ACC_ABASTECIMENTO_QUANTIDADE) QTDE,
                      ROUND(SUM(AB.ACC_ABASTECIMENTO_VALOR) / SUM(AB.ACC_ABASTECIMENTO_QUANTIDADE),2) V_LITRO,
                      SUM(AB.ACC_ABASTECIMENTO_VALOR) VALOR,
                      MAX((SELECT MAX(AB1.ACC_ABASTECIMENTO_KM)
                           FROM TDVADM.T_ACC_ABASTECIMENTO AB1
                           WHERE AB1.FRT_CONJVEICULO_CODIGO = AB.FRT_CONJVEICULO_CODIGO
                             AND TO_NUMBER(AB1.ACC_ABASTECIMENTO_KM) < TO_NUMBER(AB.ACC_ABASTECIMENTO_KM)
                             AND TRUNC(AB1.ACC_ABASTECIMENTO_DATA) = (SELECT MAX(TRUNC(AB2.ACC_ABASTECIMENTO_DATA))
                                                                      FROM TDVADM.T_ACC_ABASTECIMENTO AB2
                                                                      WHERE AB2.FRT_CONJVEICULO_CODIGO = AB.FRT_CONJVEICULO_CODIGO
                                                                        AND TO_NUMBER(AB2.ACC_ABASTECIMENTO_KM) <= TO_NUMBER(AB.ACC_ABASTECIMENTO_KM)
                                                                        AND TRUNC(AB2.ACC_ABASTECIMENTO_DATA) < TRUNC(AB.ACC_ABASTECIMENTO_DATA)))) KM_ANTERIOR,
                      MAX(AB.ACC_ABASTECIMENTO_KM) KM_ATUAL,
                      SUBSTR(TDVADM.PKG_FRTCAR_VEICULO.FN_GET_PLACA(AB.FRT_CONJVEICULO_CODIGO,AB.ACC_ABASTECIMENTO_DATA),1,7) PLACA,
                      COUNT(*) QTDEAB
               FROM TDVADM.T_ACC_ABASTECIMENTO AB
               WHERE AB.ACC_ABASTECIMENTO_DATA >= vDataI
                 AND AB.ACC_ABASTECIMENTO_DATA <= vDataF
                 AND AB.FRT_CONJVEICULO_CODIGO = c_msg.frt_conjveiculo_codigo
               GROUP BY TO_CHAR(AB.ACC_ABASTECIMENTO_DATA,'YYYYMM'),
                        AB.FRT_CONJVEICULO_CODIGO,
                        TRUNC(AB.ACC_ABASTECIMENTO_DATA),
                        AB.POS_CADASTRO_CGC,
                        SUBSTR(TDVADM.PKG_FRTCAR_VEICULO.FN_GET_PLACA(AB.FRT_CONJVEICULO_CODIGO,AB.ACC_ABASTECIMENTO_DATA),1,7)
               ORDER BY AB.FRT_CONJVEICULO_CODIGO,
                        TRUNC(AB.ACC_ABASTECIMENTO_DATA),
                        AB.POS_CADASTRO_CGC) ABST_JAN,
                        TDVADM.T_POS_CADASTRO P
         WHERE P.POS_CADASTRO_CGC(+) = ABST_JAN.POSTO
           AND ABST_JAN.DATA_ANTERIOR <= vDataI
           AND ABST_JAN.DATA_ATUAL >= vDataI;
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
           vtVlrLitrokm := 0;
           vtVlrLitrolt := 0;
        WHEN OTHERS THEN
           vtVlrLitrokm := 0;
           vtVlrLitrolt := 0;
           dbms_output.put_line('CTF' || '-' || c_msg.frt_conjveiculo_codigo || '-' || c_msg.ipf_valefrete_cadastro || '-' || c_msg.ipf_valefrete_fimviagem );
      END;

  


    SELECT SUM(MC.FRT_INTMIXCONSUMO_KMRODADO)
      INTO vtKMTotalMIX
      FROM TDVADM.T_FRT_INTMIXCONSUMO MC,
           TDVADM.T_FRT_INTMIXVEICULO MV
     WHERE MV.FRT_INTMIXVEICULO_ID = MC.FRT_INTMIXVEICULO_ID
       AND MV.FRT_INTMIXVEICULO_PLACA = c_msg.ipf_valefrete_placa
       AND trunc(MC.FRT_INTMIXCONSUMO_DATA) >= to_date(vDataI,'dd/mm/yyyy')
       AND trunc(MC.FRT_INTMIXCONSUMO_DATA) <= to_date(vDataF,'dd/mm/yyyy');      

      If vtKMTotalMIX = 0 Then
         vtKMTotalMIX        := 1;
      End If;   
      update tdvipf.t_ipf_valefrete vf
        set vf.ipf_valefrete_ctfcustokm = vtVlrLitrokm,
            vf.ipf_valefrete_ctfcustolt = vtVlrLitroLT,
            vf.ipf_valefrete_ctfcusto = (vtVlrTotalCTF / nvl(vtKMTotalMIX,1)) * c_msg.ipf_valefrete_mixkm 
      where vf.rowid = c_msg.rowid;
      
      vAuxiliar := vAuxiliar +1;
      If mod(vAuxiliar,100) = 0 Then
         commit;  
      End If;


   End Loop;   
    
    
    
end sp_carregaCTF;    

  function fn_retornaCentroCusto(pReferencia in char,
                                 pCentroCusto in tdvadm.t_slf_contrato.glb_centrocusto_codigo%type,
                                 pContrato    in tdvadm.t_slf_contrato.slf_contrato_codigo%type,
                                 pTipoRet     in char default 'C') -- (C)odigo
                                                                   -- (D)escricao
  Return varchar2
  As
      vCentroCusto     tdvadm.t_glb_centrocusto.glb_centrocusto_codigo%type;
      VDescCentroCusto tdvadm.t_glb_centrocusto.glb_centrocusto_descricao%type;
    Begin
      
    If pReferencia >= '201901' Then
      If trim(pContrato) = '5304' Then vCentroCusto := '4030';
      Else vCentroCusto := trim(pCentroCusto); -- Mantem o Parametro de Entrada
      End If;
      
      If    vCentroCusto = '4021' Then vCentroCusto := '4011'; --  SAO PAULO
      ElsIf vCentroCusto = '4055' Then vCentroCusto := '4057'; --  CAMACARI
      ElsIf vCentroCusto = '4048' Then vCentroCusto := '4030'; --  TRINDADE
      ElsIf vCentroCusto = '4083' Then vCentroCusto := '4030'; --  CAMPOS(RIO DE JANEIRO)
      ElsIf vCentroCusto = '4090' Then vCentroCusto := '4070'; --  JATAÍ
      ElsIf vCentroCusto = '4153' Then vCentroCusto := '4187'; --  ITABIRA
      ElsIf vCentroCusto = '4174' Then vCentroCusto := '4170'; --  BARCARENA
      ElsIf vCentroCusto = '4186' Then vCentroCusto := '4185'; --  CACHOEIRO DO ITAPEMIRIM
      ElsIf vCentroCusto = '4189' Then vCentroCusto := '4187'; --  CONTAGEM
      ElsIf vCentroCusto = '4191' Then vCentroCusto := '4187'; --  DIVINOPOLIS
      ElsIf vCentroCusto = '4330' Then vCentroCusto := '4051'; --  SENHOR DO BONFIM
      ElsIf vCentroCusto = '4630' Then vCentroCusto := '4620'; --  AMERICANA
      ElsIf vCentroCusto = '4750' Then vCentroCusto := '4740'; --  CAARAPO
      Else vCentroCusto := vCentroCusto; -- Mantem o Parametro de Entrada
      End If;    
    End If;

    Begin
       select cc.glb_centrocusto_descricao
        into vdesccentrocusto
       from tdvadm.t_glb_centrocusto cc
       where cc.glb_centrocusto_codigo = vcentrocusto
         and rownum = 1;
    exception
      When NO_DATA_FOUND Then
         vdesccentrocusto := null;
      When TOO_MANY_ROWS Then
        vdesccentrocusto := 'retmaisde1linha';
      End;

    If pTipoRet = 'C' Then
       return vcentrocusto;
    Else
       return vdesccentrocusto;
    End If;

  End fn_retornaCentroCusto;



Procedure sp_criaRECCUST(pPeriodo in char)
  As
begin
  delete tdvipf.t_ipf_reccust i
  where i.ipf_reccust_referencia =  '999999';
  commit;
  tdvipf.PKG_RECCUST_DIRETOS2019.sp_carregaValeFrete(pReferencia => pPeriodo);
  commit;
  tdvipf.PKG_RECCUST_DIRETOS2019.sp_carregaConhecimento(pReferencia => pPeriodo);
  commit;
  tdvipf.pkg_reccust_diretos2019.sp_calculafimviagem;
  wservice.pkg_glb_email.SP_ENVIAEMAIL('ACABOU','FIM VIAGEM ate ' || pPeriodo ,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
  commit;
  tdvipf.pkg_reccust_diretos2019.sp_carregasemparar(pReferencia => pPeriodo);
  wservice.pkg_glb_email.SP_ENVIAEMAIL('ACABOU','SEM PARAR ate ' || pPeriodo ,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
  commit;
  tdvipf.pkg_reccust_diretos2019.sp_carregamix(pReferencia => pPeriodo);
  wservice.pkg_glb_email.SP_ENVIAEMAIL('ACABOU','MIX ate ' || pPeriodo ,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
  commit;
  tdvipf.pkg_reccust_diretos2019.sp_carregactf;
  wservice.pkg_glb_email.SP_ENVIAEMAIL('ACABOU','CTF ate ' || pPeriodo ,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
  commit;
  tdvipf.pkg_reccust_diretos2019.sp_carregaVFreteConhec(preferencia => pPeriodo);
  wservice.pkg_glb_email.SP_ENVIAEMAIL('ACABOU','VFRETECONHEC ate ' || pPeriodo ,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
  commit;
  tdvipf.pkg_reccust_diretos2019.sp_carregaValoresAcumulados;
  wservice.pkg_glb_email.SP_ENVIAEMAIL('ACABOU','VALORES ACUMULADOS ate ' || pPeriodo ,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
  commit;
  wservice.pkg_glb_email.SP_ENVIAEMAIL('ACABOU','FIM ate ' || pPeriodo ,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
  commit;

end sp_criaRECCUST;  

Procedure sp_criaIndicadores(pPeriodo in char,
                             pStatus out char,
                             pMessage out varchar2)
  As
    vAuxiliar integer;
  Begin
      select count(*)
         into vAuxiliar
      from TDVIPF.V_IPF_RECCUST R1
      where r1.ipf_reccust_referencia = pPeriodo;
      If vAuxiliar = 0 Then
         pStatus := 'E';
         pMessage := 'Rateio das Receitas e Despesas da Referecia ' || pPeriodo || ' não gerado!';
         return;
      End If;

--    drop table   tdvipf.t_ipf_indicadoresc;
--    create table tdvipf.t_ipf_indicadoresc
--    As
    delete tdvipf.t_ipf_indicadoresc x
    where x.IPF_RECCUST_REFERENCIA = pPeriodo;
    insert into tdvipf.t_ipf_indicadoresc
    SELECT R.IPF_RECCUST_REFERENCIA,
           R.IPF_VALEFRETE_CENTROCUSTO,
    --       R.IPF_CONHEC_CONTRATO,
           R.IPF_CONHEC_CCCONTRATO,
           COUNT(DISTINCT R.IPF_CONHEC_CHAVE) IPF_INDICADORES_QTDECTECHAVE,
           MAX((SELECT COUNT(DISTINCT R1.IPF_CONHEC_CHAVE) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) IPF_INDICADORES_QTDECTECCTOT,
           MAX((SELECT COUNT(DISTINCT R1.IPF_CONHEC_CHAVE) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) IPF_INDICADORES_QTDECTECONTRATOTOT,
           MAX((SELECT COUNT(DISTINCT R1.IPF_CONHEC_CHAVE) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) IPF_INDICADORES_QTDECTETOT,
           COUNT(DISTINCT SUBSTR(R.IPF_VALEFRETE_CHAVE,1,11)) IPF_INDICADORES_QTDEVFCHAVE,
           MAX((SELECT COUNT(DISTINCT SUBSTR(R1.IPF_VALEFRETE_CHAVE,1,11)) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) IPF_INDICADORES_QTDEVFCCTOT,
           MAX((SELECT COUNT(DISTINCT SUBSTR(R1.IPF_VALEFRETE_CHAVE,1,11)) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) IPF_INDICADORES_QTDEVFCONTRATOTOT,
           MAX((SELECT COUNT(DISTINCT SUBSTR(R1.IPF_VALEFRETE_CHAVE,1,11)) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) IPF_INDICADORES_QTDEVFTOT,
           SUM(R.RATCTFRETEPESO) RATCTFRETEPESOCHAVE,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOFROTACHAVE,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOCCFROTATOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOCONTRATOFROTATOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOFROTATOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESONFROTACHAVE,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOCCNFROTATOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOCONTRATONFROTATOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESONFROTATOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
            AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOCCTOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
            AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOCONTRATOTOT,
           MAX((SELECT SUM(R1.RATCTFRETEPESO) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATCTFRETEPESOTOT,
           SUM(R.RATVFFRETESP) RATVFFRETESPCHAVE,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPFROTACHAVE,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPCCFROTATOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPCONTRATOFROTATOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.GLB_TPMOTORISTA_CODIGO = 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPFROTATOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPNFROTACHAVE,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPCCNFROTATOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPCONTRATONFROTATOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.GLB_TPMOTORISTA_CODIGO <> 'F'
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPNFROTATOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CENTROCUSTO = R.IPF_VALEFRETE_CENTROCUSTO 
            AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPCCTOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_CONHEC_CCCONTRATO = R.IPF_CONHEC_CCCONTRATO 
            AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPCONTRATOTOT,
           MAX((SELECT SUM(R1.RATVFFRETESP) 
            FROM TDVIPF.V_IPF_RECCUST R1 
            WHERE R1.IPF_RECCUST_REFERENCIA = R.IPF_RECCUST_REFERENCIA 
              AND R1.IPF_VALEFRETE_CAIXA IS NOT NULL)) RATVFFRETESPTOT
    FROM TDVIPF.V_IPF_RECCUST R
    WHERE 0 = 0
      AND R.IPF_RECCUST_REFERENCIA = pPeriodo
      AND R.IPF_VALEFRETE_CAIXA IS NOT NULL
    GROUP BY R.IPF_RECCUST_REFERENCIA,
             R.IPF_VALEFRETE_CENTROCUSTO,
             R.IPF_CONHEC_CCCONTRATO;        
    commit;

  End sp_criaIndicadores;

Procedure sp_criaCCContratoRateado(pPeriodo in char,
                                   pStatus out char,
                                   pMessage out varchar2)
  As
    vAuxiliar integer;
  Begin 
      select count(*)
         into vAuxiliar
      from tdvipf.t_ipf_indicadoresc i
      where i.ipf_reccust_referencia = pPeriodo;
      
      If vAuxiliar = 0 Then
         pStatus := 'E';
         pMessage := 'Indicadores da referencia ' || pPeriodo || ' não gerado!';
         return;
      End If;
        

--      drop table tdvipf.t_ipf_centrocustorateado;
--      create table tdvipf.t_ipf_centrocustorateado
--      as
      delete tdvipf.t_ipf_centrocustorateado x
      where x.referencia = pPeriodo;
      
      insert into tdvipf.t_ipf_centrocustorateado
      select 'NTCCCT' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontratosint x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato <> '9999'
        and x.referencia     = i.ipf_reccust_referencia
        and x.codcentrocusto = i.ipf_valefrete_centrocusto
        and x.codcccontrato  = i.ipf_conhec_cccontrato
        and x.glb_tpcentrocusto_rateavel = 'N'
        ;
      commit;


      insert into tdvipf.t_ipf_centrocustorateado
      select 'NTCC  ' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontratosint x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato  = '9999'
        and x.referencia     = i.ipf_reccust_referencia
        and x.codcentrocusto = i.ipf_valefrete_centrocusto
      --  and x.codcccontrato  = i.ipf_conhec_cccontrato
        and x.glb_tpcentrocusto_rateavel = 'N'
      ;
      commit;


      insert into tdvipf.t_ipf_centrocustorateado
      select 'STCCCT' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontratosint x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato <> '9999'
        and x.glb_tpcentrocusto_rateavel = 'S'
        and x.referencia     = i.ipf_reccust_referencia
        -- Para os rateaveis = a SIM não temos o centro de custo do VALE DE FRETE
      --  and x.codcentrocusto = i.ipf_valefrete_centrocusto
        and x.codcccontrato  = i.ipf_conhec_cccontrato
      ;
      commit;

      insert into tdvipf.t_ipf_centrocustorateado
      select 'STCCCT' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontratosint x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
      --  and x.ctb_movimento_documento = '0000001'
      --  and x.ctb_movimento_dsequencia = 196
        and x.ccrateio <> 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato <> '9999'
        and x.glb_tpcentrocusto_rateavel = 'S'
        and x.referencia     = i.ipf_reccust_referencia
        -- Para os rateaveis = a SIM não temos o centro de custo do VALE DE FRETE
        and instr(x.ccrateio,i.ipf_valefrete_centrocusto) > 0
      --  and x.codcccontrato  = i.ipf_conhec_cccontrato
      ;
      commit;

      insert into tdvipf.t_ipf_centrocustorateado
      select 'STCC  ' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontratosint x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato  = '9999'
        and x.glb_tpcentrocusto_rateavel = 'S'
        and x.referencia     = i.ipf_reccust_referencia
        -- Para os rateaveis = a SIM não temos o centro de custo do VALE DE FRETE
      --  and x.codcentrocusto = i.ipf_valefrete_centrocusto
      --  and x.codcccontrato  = i.ipf_conhec_cccontrato
      ;
      commit;

    

  End sp_criaCCContratoRateado;


Procedure sp_criaCCContratoRateado2(pPeriodo in char,
                                   pStatus out char,
                                   pMessage out varchar2)
  As
    vAuxiliar integer;
  Begin 
      select count(*)
         into vAuxiliar
      from tdvipf.t_ipf_indicadoresc i
      where i.ipf_reccust_referencia = pPeriodo;
      
      If vAuxiliar = 0 Then
         pStatus := 'E';
         pMessage := 'Indicadores da referencia ' || pPeriodo || ' não gerado!';
         return;
      End If;
        

--      drop table tdvipf.t_ipf_centrocustorateado;
--      create table tdvipf.t_ipf_centrocustorateado
--      as
      delete tdvipf.t_ipf_centrocustorateado x
      where x.referencia = pPeriodo;
      commit;
      
      insert into tdvipf.t_ipf_centrocustorateado
      select 'NTCCCT' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontrato x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato <> '9999'
        and x.referencia     = i.ipf_reccust_referencia
        and x.codcentrocusto = i.ipf_valefrete_centrocusto
        and x.codcccontrato  = i.ipf_conhec_cccontrato
        and x.glb_tpcentrocusto_rateavel = 'N'
        ;
      commit;


      insert into tdvipf.t_ipf_centrocustorateado
      select 'NTCC  ' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontrato x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato  = '9999'
        and x.referencia     = i.ipf_reccust_referencia
        and x.codcentrocusto = i.ipf_valefrete_centrocusto
      --  and x.codcccontrato  = i.ipf_conhec_cccontrato
        and x.glb_tpcentrocusto_rateavel = 'N'
      ;
      commit;


      insert into tdvipf.t_ipf_centrocustorateado
      select 'STCC  ' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontrato x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato <> '9999'
        and x.glb_tpcentrocusto_rateavel = 'S'
        and x.referencia     = i.ipf_reccust_referencia
        -- Para os rateaveis = a SIM não temos o centro de custo do VALE DE FRETE
      --  and x.codcentrocusto = i.ipf_valefrete_centrocusto
--        and x.codcccontrato  = i.ipf_conhec_cccontrato
      ;
      commit;

      insert into tdvipf.t_ipf_centrocustorateado
      select 'STCC  ' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontrato x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
      --  and x.ctb_movimento_documento = '0000001'
      --  and x.ctb_movimento_dsequencia = 196
        and x.ccrateio <> 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato <> '9999'
        and x.glb_tpcentrocusto_rateavel = 'S'
        and x.referencia     = i.ipf_reccust_referencia
        -- Para os rateaveis = a SIM não temos o centro de custo do VALE DE FRETE
        and instr(x.ccrateio,i.ipf_valefrete_centrocusto) > 0
      --  and x.codcccontrato  = i.ipf_conhec_cccontrato
      ;
      commit;

      insert into tdvipf.t_ipf_centrocustorateado
      select 'STCC  ' tipo,x.*,i.*
      from tdvipf.v_ipf_centrocustocontrato x,
           tdvipf.t_ipf_indicadoresc i
      where x.referencia = pPeriodo
        and x.ccrateio = 'TODOS'
        and x.codcentrocusto <> '9999'
        and x.codcccontrato  = '9999'
        and x.glb_tpcentrocusto_rateavel = 'S'
        and x.referencia     = i.ipf_reccust_referencia
        -- Para os rateaveis = a SIM não temos o centro de custo do VALE DE FRETE
      --  and x.codcentrocusto = i.ipf_valefrete_centrocusto
      --  and x.codcccontrato  = i.ipf_conhec_cccontrato
      ;
      commit;

    

  End sp_criaCCContratoRateado2;

END PKG_RECCUST_DIRETOS2019;
/
