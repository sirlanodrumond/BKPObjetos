CREATE OR REPLACE PACKAGE PKG_HD_UTILITARIO IS
/***************************************************************************************************
 * ROTINA           : DIVERSAS ROTINAS DO DIA A DIA
 * PROGRAMA         :
 * ANALISTA         : TODOS
 * DESENVOLVEDOR    :
 * DATA DE CRIACAO  : 23/03/2012
 * BANCO            : TDP
 * EXECUTADO POR    :
 * ALIMENTA         :
 * FUNCINALIDADE    :
 * ATUALIZA         :
 * PARTICULARIDADES :                                           
 * PARAM. OBRIGAT.  :
 *                                                                                                  *
 ****************************************************************************************************/
  TYPE T_CURSOR IS REF CURSOR;

-- USAR PS STATUS DA PKG_GLB_COMMON
--  STATUS_NORMAL         CONSTANT CHAR(1)      := 'N';
--  STATUS_ERRO           CONSTANT CHAR(1)      := 'E';
--  PKG_GLB_COMMON
 
 /* Typo utilizado como base para utilização dos Paramentros                                                                 */
 Type TpMODELO  is RECORD (CAMPO1         char(10),
                           CAMPO2         number(6));
                           
 
   
 
   PROCEDURE SP_CON_INCLUIFATCAPA(P_FATURACAP IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURAGRUPO_CODIGO%TYPE,
                                  P_CICLOCAP  IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURAGRUPO_CICLO%TYPE,
                                  P_ROTACAP   IN TDVADM.T_CON_FATURAGRUPOXFATURA.GLB_ROTA_CODIGOGRUPO%TYPE,
                                  P_FATURAFAT IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURA_CODIGO%TYPE,
                                  P_CICLOFAT  IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURA_CICLO%TYPE,
                                  P_ROTAFAT   IN TDVADM.T_CON_FATURAGRUPOXFATURA.GLB_ROTA_CODIGOFATURA%TYPE,
                                  P_ACAO      IN CHAR,
                                  P_MESSAGE   OUT VARCHAR2,
                                  P_STATUS    OUT CHAR);

  PROCEDURE SP_CON_VOLTAVERBASCTRC(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                                   P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE);

   PROCEDURE SP_CON_PERCENTAGREGADO(p_placa    in tdvadm.t_car_veiculo.car_veiculo_placa%type,
                                    p_percent  in TDVADM.t_usu_perfil.USU_PERFIL_PARAN1%TYPE,
                                    p_vigencia in TDVADM.t_usu_perfil.USU_PERFIL_VIGENCIA%TYPE,
                                    p_obs      in TDVADM.t_usu_perfil.USU_PERFIL_OBSERVACAO%TYPE,
                                    P_ACAO     IN CHAR,
                                    P_MESSAGE  OUT VARCHAR2,
                                    P_STATUS   OUT CHAR);
                                    

   -- usada pra des-reajustar uma tabela
   PROCEDURE sp_slf_desreajusta  ;
   
   -- atualiza aliquota ade uma tabela
   -- aliquota e o percentual de ICMS cobrado entre municipios
   -- vide tabela T_SLF_ICMS
   PROCEDURE SP_ATAULIZA_ALIQUOTA(P_NUMERO IN TDVADM.T_SLF_TABELA.SLF_TABELA_CODIGO%TYPE,
                                  P_SLF_TABSOL IN CHAR,
                                  P_STATUS   OUT CHAR,
                                  P_MESSAGE  OUT VARCHAR2);
                                  
  PROCEDURE SP_RJR_CADTARIFA(P_AREA IN CHAR,
                             P_TARIFA IN VARCHAR2,
                             P_VALOR IN NUMBER,
                             P_VIGENCIA IN DATE,
                             P_CARGA IN VARCHAR2,
                             P_VALORES OUT T_CURSOR,
                             P_STATUS OUT CHAR,                                           
                             P_MESSAGE OUT VARCHAR2);
                             
   PROCEDURE SP_FPW_CADCHAPEIRA(P_CHAPEIRA char,
                               P_MATRICULA number);
                               
   function fn_ordchapeira (p_1 char, --chapeira
                           p_2 number /*matricula*/)return integer;

   PROCEDURE SP_FRT_VERIFICAAGREGADO(P_PLACA IN CHAR,
                                     P_CURSOR OUT  T_CURSOR);

  PROCEDURE SP_RJR_ALTERARQ(P_MATRICULA IN TDVADM.T_FRT_AJUDANTES.FRT_AJUDANTE_MATRICULA%TYPE,
                            P_TIPO IN TDVADM.T_FRT_AJUDANTES.FRT_AJUDANTE_TIPO%TYPE,
                            P_AREA IN TDVADM.T_FRT_AJUDANTES.FRT_AJUDANTES_AREA%TYPE,
                            P_STATUS OUT CHAR,
                            P_MESSAGE OUT VARCHAR2);

  PROCEDURE SP_RJR_RETORNAAREA(P_AREAS OUT T_CURSOR,
                               P_STATUS OUT CHAR,
                               P_MESSAGE OUT VARCHAR2);
                               
   PROCEDURE SP_EXCLUI_NOTA_NOVO(pNOTA in number,
                                 pCNPJ in char,
                                 pTipo in char, -- A (Arm_Nota) X (Xml_Nota) T (Todas)
                                 pSEQUENCIA IN NUMBER,
                                 pMessage out varchar2,
                                 pStatus out char);
 
  PROCEDURE SP_EXCLUI_NOTA(pNOTA in number,
                           pCNPJ in char,
                           pTipo in char, -- A (Arm_Nota) X (Xml_Nota) T (Todas)
                           pMessage out varchar2,
                           pStatus out char);
                           
   procedure SP_RETORNACARREGAMENTO(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                  pStatus    out char,
                                  pMessage   out varchar2);


PROCEDURE SP_RJR_PREVIAAGREGADO(P_PDATADOC IN CHAR, -- Maior Data de Documento 
                                P_AREA     IN CHAR, -- Area a ser processado separado por ; ponto e virgula
                                P_PREVIA OUT T_CURSOR,
                                P_STATUS OUT CHAR,
                                P_MESSAGE OUT VARCHAR2);            
                                

 
Procedure sp_cax_trocacaixafeletronico(pDocumento in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                         pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                         pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                         pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%type,
                                         pNovaRota  in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                         pData      in date,
                                         pStatus out char,
                                         pMessage out varchar2,
                                         pCursor   out t_cursor
                                             );
                                             
Procedure sp_cax_trocacaixafeletronico2(pDocumento in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                        pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                        pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                        pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%type,
                                        pNovaRota  in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                        pData      in date,
                                        pStatus out char,
                                        pMessage out varchar2);

Procedure sp_arm_setalteraocorrencia(p_coletanumero in t_arm_coleta.arm_coleta_ncompra%type,
                                     p_coletaciclo in t_arm_coleta.arm_coleta_ciclo%type,
                                     p_coletaocorrencia in t_arm_coleta.arm_coletaocor_codigo%type,
                                     p_status out char,
                                     p_message out varchar2);
                                     
                                     

Procedure sp_arm_setaRPS             (p_conhec in T_CON_CONHECRPSNFE.CON_CONHECIMENTO_CODIGO%type,
                                     p_conhecRota in T_CON_CONHECRPSNFE.GLB_ROTA_CODIGO%type,
                                     p_conhecRPS in T_CON_CONHECRPSNFE.con_conhecrpsnfe_nfecodigo%type
                                     );

Procedure SP_REPROCESSAQUIMICOSR(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type); --Código do carregamento
                                                                                                                               
                  
Procedure SP_REPROCESSAQUIMICO(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type, --Código do carregamento
                               pStatus    out char,
                               pMessage   out Varchar2);
                               
                               
Procedure sp_reenviarps        (pBenasse    in Varchar2,
                                pStatus     out char,
                                pMessage    out Varchar2);

Procedure SP_HD_HABOBS     (pBenasse in rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                            pStatus  out char,
                            pMessage out Varchar2
                            );
                            
Procedure SP_HD_ALTCABRITO (pBenasse in rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                            pStatus  out char,
                            pMessage out Varchar2
                            );
PROCEDURE SP_RJR_CADTARIFA  (P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                             P_STATUS OUT CHAR,                                           
                             P_MESSAGE OUT VARCHAR2);
                             
PROCEDURE SP_INT_UpdateMacAddress (P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                                   P_STATUS OUT CHAR,                                           
                                   P_MESSAGE OUT VARCHAR2);
                                   
PROCEDURE SP_GET_IDJOBNDD (P_CODIGO  IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                           P_SERIE   IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                           P_ROTA    IN TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                           P_TIPO    IN CHAR,
                           P_ID      OUT INTEGER, 
                           P_STATUS  OUT CHAR,                                           
                           P_MESSAGE OUT VARCHAR2);

PROCEDURE   sp_limpa_campo(p_armazem     char,
                           p_Data date,
                           P_MESSAGE OUT VARCHAR2 );

function fn_GET_IDJOBNDD( P_DOCUMENTO IN NDD_NEW.TBLOGDOCUMENT.DOCUMENTNUMBER%type,
                          P_SERIE IN NDD_NEW.TBLOGDOCUMENT.SERIE%TYPE,
                          P_TIPO IN CHAR) return number;
                          
Procedure sp_cax_trocacaixafeletroAute(P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                                       pStatus out char,
                                       pMessage out varchar2);     

-- Pàra Arrumar as datas de Baixa automatica
Procedure sp_ArrumaDataBaixaAutomatica(pProtocolo in rmadm.t_glb_benasserec.glb_benasserec_chave%type,
                                       pStatus out char,
                                       pMessage out clob);
                                       

Function FN_Get_EmbTransferencia2(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                  pCon_conhecimento_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                  pGlb_rota_codigo in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                  pDataaSerVerificada in char default trunc(sysdate) ,
                                  pRetorno char default 'T') return char;
                                  
Procedure SP_SET_EmbTransferencia2(P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                                   pStatus out char,
                                   pMessage out CLOB
                                   );    

procedure sp_copiaNotasCarregTESTE(pCarregamento in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                   pStatus out char,
                                   pMessage out CLOB);

  procedure sp_ApagaNotasCarregTESTE(pCarregamento in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                   pStatus out char,
                                   pMessage out CLOB);
                                   
  function fn_get_email(pUsuario varchar2) return varchar2;
  
  PROCEDURE SP_CTE_REENVIACANCEL(P_CTE     IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%type,
                                                 P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                                 P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                                 P_STATUS  OUT CHAR,
                                                 P_MESSAGE OUT VARCHAR2);

 function fn_GET_SomaPeso(pArm          IN varchar2,
                          pDestinoCnpj IN varchar2,
                          pDetinoCidade IN varchar2) return float; 
                          
 function fn_get_rotaColeta (pColeta varchar2, pCiclo varchar) return varchar;
 
 function fn_get_CountColetasCobradas (pCtrc varchar2, pSerie varchar, pRota varchar2) return integer; 
 
 PROCEDURE SP_CTE_CADASTRAR_PLACA(P_CTE            IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%type,
                                   P_SERIE          IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA           IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                   P_CPF_CARRETEIRO IN T_CAR_CARRETEIRO.CAR_CARRETEIRO_CPFCODIGO%TYPE,
                                   P_PLACA          IN T_CAR_CARRETEIRO.CAR_VEICULO_PLACA%TYPE,
                                   P_CPF_FROTA      IN T_FRT_MOTORISTA.FRT_MOTORISTA_CPF%TYPE, 
                                   P_STATUS         OUT CHAR,
                                   P_MESSAGE        OUT VARCHAR2);
                                   
 PROCEDURE SP_Alterar_DataVenc     (P_Fatura         IN T_Con_Fatura.Con_Fatura_Codigo%type,
                                   P_Ciclo          IN T_Con_Fatura.Con_Fatura_Ciclo%TYPE,
                                   P_ROTA           IN T_con_Fatura.Glb_Rota_Codigofilialimp%TYPE,
                                   p_DataVenc       IN T_Con_Fatura.Con_Fatura_Datavenc%TYPE,
                                   P_STATUS         OUT CHAR,
                                   P_MESSAGE        OUT VARCHAR2);
                                   
PROCEDURE SP_LiberarFat            (P_Fatura         IN T_Con_Fatura.Con_Fatura_Codigo%type,
                                   P_ROTA           IN T_con_Fatura.Glb_Rota_Codigofilialimp%TYPE,
                                   P_STATUS         OUT CHAR,
                                   P_MESSAGE        OUT VARCHAR2);
                                  
Procedure SP_VERIFICA_CARREGAMENTO(P_COD_CARREGAMENTO In  TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%Type,
                                   P_ACAO             IN CHAR DEFAULT 'V', -- PODE SER (V) Verifica (C) Corrige
                                   P_STATUS           OUT CHAR,
                                   P_MESSAGE          OUT CLOB);

PROCEDURE SP_Insere_GrandeFluxo(pLocOrigem  IN tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                pLocDestino IN tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                pCnpjCli    IN tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                pTipo       in char,
                                pUsuario    in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                pVigencia   in varchar2,
                                P_STATUS    OUT CHAR,
                                P_MESSAGE   OUT VARCHAR2);
                                
PROCEDURE SP_ASN_REENVIAEVENTO (P_ASN     IN  TDVADM.T_COL_ASN.COL_ASN_NUMERO%type,
                                P_STATUS  OUT CHAR,
                                P_MESSAGE OUT VARCHAR2);

PROCEDURE SP_ARM_CARREGVAZIO     (P_CARREG     IN  TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%type,
                                  P_STATUS  OUT CHAR,
                                  P_MESSAGE OUT VARCHAR2);
                                  
Procedure Sp_cria_cargadet (pNota In t_Arm_Nota.Arm_Nota_Numero%Type,
                                 pCNPJ In t_arm_cargadet.glb_cliente_cgccpfremetente%Type,
                                 pSeq  In tdvadm.t_arm_nota.arm_nota_sequencia%type);                                  

procedure SP_CON_DESFATURAR;

function FN_ATUALIZA_PERCURSO_VALE (P_DATA IN TDVADM.T_GLB_TESTESTR.GLB_TESTESTR_DTGRAV%TYPE,
                                   P_ERRO OUT VARCHAR2) return varchar; 
                                   
function FN_ATUALIZA_PERCURSO_VLI (P_DATA IN TDVADM.T_GLB_TESTESTR.GLB_TESTESTR_DTGRAV%TYPE,
                                   P_ERRO OUT VARCHAR2) return varchar; 
                                   
FUNCTION FN_CORRIGE_FATOR_RATEIO(P_CARREG IN TDVADM.T_ARM_EMBALAGEM.ARM_CARREGAMENTO_CODIGO%TYPE,
                                 P_ERRO OUT VARCHAR2) RETURN VARCHAR; 
                                 
Procedure SP_SET_DTPROGFRACIONADOSEM(pPeriodo   in date);  

Procedure sp_criaverbacalccte(pConhecimento in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                              pSerie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                              pRota in tdvadm.t_con_conhecimento.glb_rota_codigo%type);
                              
Procedure sp_gercoleta_invalido;

PROCEDURE SP_ARM_DEDURACOLETAEMDUASNOTAS(pPeriodo in date);

PROCEDURE SP_JNT_TESTE(pPeriodo in date);

procedure sp_retira_impressao ( pValeFrete in tdvadm.t_con_valefrete.con_conhecimento_codigo%Type,
                                 pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%Type,
                                 pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%Type,
                                 pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%Type,
                                 pMensagem out varchar2);
                                 
Procedure sp_con_validapagamento ( pValeFrete in tdvadm.t_con_valefrete.con_conhecimento_codigo%Type,
                                   pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%Type,
                                   pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%Type,
                                   pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%Type,
                                   pMensagem out varchar2,
                                   pStatus out char );

Procedure sp_GLB_ATUALOCALSERVIDORIMG(pSistema   in  varchar2,
                                        pNovoLocal in varchar2,
                                        pQtdeCommit in integer default 1000,
                                        pStatus  out char,
                                        pMessage out varchar2);                                   
                                   

END PKG_HD_UTILITARIO;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_HD_UTILITARIO AS


   PROCEDURE SP_CON_INCLUIFATCAPA(P_FATURACAP IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURAGRUPO_CODIGO%TYPE,
                                  P_CICLOCAP  IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURAGRUPO_CICLO%TYPE,
                                  P_ROTACAP   IN TDVADM.T_CON_FATURAGRUPOXFATURA.GLB_ROTA_CODIGOGRUPO%TYPE,
                                  P_FATURAFAT IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURA_CODIGO%TYPE,
                                  P_CICLOFAT  IN TDVADM.T_CON_FATURAGRUPOXFATURA.CON_FATURA_CICLO%TYPE,
                                  P_ROTAFAT   IN TDVADM.T_CON_FATURAGRUPOXFATURA.GLB_ROTA_CODIGOFATURA%TYPE,
                                  P_ACAO      IN CHAR,
                                  P_MESSAGE   OUT VARCHAR2,
                                  P_STATUS    OUT CHAR) AS
     -- tipos de Acoes
     -- IF - Incluir uma Fatura na Capa
     -- EF - Excluir uma Fatura da Capa
     -- EC - Excluir uma Capa
     -- AC - Alterar o Numero de uma capa ( em desenvolvimento)

     vContador number;
     vReCalculaCapa Boolean;
     vValorFat number;
     vDesconto number;
  BEGIN
    
   vContador := 0;
   vReCalculaCapa :=  false;
   P_STATUS :=  pkg_glb_common.Status_Nomal;
   
   -- verifica se as acoes sao de (I)nclusao ou (E)xclusao
   IF ( P_ACAO <> 'IF' )  AND ( P_ACAO <> 'EF' ) and ( P_ACAO <> 'EC'  ) THEN
        P_MESSAGE := 'Parametro de Acao errado, Verificar. Passado -> ' || P_ACAO || ' -  Usar IF / EF / EC';
        P_STATUS  := PKG_GLB_COMMON.Status_Erro;
   END IF;     
   
   if P_STATUS =  pkg_glb_common.Status_Nomal then
      -- VERIFICA SE A CAPA EXISTE 
      SELECT COUNT(*)
        INTO vContador 
      FROM TDVADM.T_CON_FATURAGRUPO FG
      WHERE FG.CON_FATURAGRUPO_CODIGO   = P_FATURACAP
        AND FG.CON_FATURAGRUPO_CICLO    = P_CICLOCAP
        AND FG.GLB_ROTA_CODIGOFILIALIMP = P_ROTACAP;

      -- CASO NAO SEJA ENCONTRADO RETORNA ERRO
      IF vContador = 0 Then
        P_MESSAGE := 'Capa ' || P_FATURACAP || '-' || P_CICLOCAP || '-' || P_ROTACAP || ' Não Encontrada Favor Verificar';
        P_STATUS  := PKG_GLB_COMMON.Status_Erro;
      END IF;
               
      if P_STATUS =  pkg_glb_common.Status_Nomal then

          -- verificar se a fatura existe
          -- verificar se a mesma ja conta em outra capa
          -- verificar se ja esta paga ou parcilamente paga
          P_STATUS :=  pkg_glb_common.Status_Nomal;
      end if;


      if P_STATUS =  pkg_glb_common.Status_Nomal then


          if    p_acao = 'IF' then
              -- incluir a Fatura e tratar o erro
              begin
                INSERT INTO T_CON_FATURAGRUPOXFATURA FGF
                  (CON_FATURAGRUPO_CODIGO,
                  CON_FATURAGRUPO_CICLO,
                  GLB_ROTA_CODIGOGRUPO,
                  CON_FATURA_CODIGO,
                  CON_FATURA_CICLO,
                  GLB_ROTA_CODIGOFATURA)
                Values
                  (P_FATURACAP,
                  P_CICLOCAP, 
                  P_ROTACAP,  
                  P_FATURAFAT,
                  P_CICLOFAT, 
                  P_ROTAFAT);
                vReCalculaCapa :=  True; 
              exception
                when DUP_VAL_ON_INDEX then
                  P_MESSAGE := 'Fatura - ' || P_FATURAFAT || '-' || P_CICLOFAT || '-' || P_ROTAFAT || ' ja existe na Capa. Favor Verificar';
                  P_STATUS  := PKG_GLB_COMMON.Status_Erro;
                When others then
                  if  sqlcode = -2291 then
                      P_MESSAGE := 'Fatura - ' || P_FATURAFAT || '-' || P_CICLOFAT || '-' || P_ROTAFAT || ' Não Existe. Favor Verificar';
                      P_STATUS  := PKG_GLB_COMMON.Status_Erro;
                   Else
                      raise_application_error(-20001,sqlcode || '-' || sqlerrm);
                   end If;  
                    
              end;  
          ElsIf p_acao = 'EF' then
              --P_MESSAGE := 'Fatura ja existe na Capa ' || P_FATURAFAT || '-' || P_CICLOFAT || '-' || P_ROTAFAT || ' Favor Verificar';
              --P_STATUS  := PKG_GLB_COMMON.Status_Erro;
            BEGIN
              DELETE T_CON_FATURAGRUPOXFATURA FGF
               WHERE FGF.CON_FATURAGRUPO_CODIGO = P_FATURACAP
                 AND FGF.CON_FATURAGRUPO_CICLO = P_CICLOCAP
                 AND FGF.GLB_ROTA_CODIGOGRUPO = P_ROTACAP 
                 AND FGF.CON_FATURA_CODIGO = P_FATURAFAT
                 AND FGF.CON_FATURA_CICLO = P_CICLOFAT
                 AND FGF.GLB_ROTA_CODIGOFATURA = P_ROTAFAT;
              vReCalculaCapa :=  True;
            EXCEPTION
              WHEN OTHERS THEN
                raise_application_error(-20001,sqlcode || '-' || sqlerrm);                
            END;
          ElsIF p_acao = 'EC' then
              P_MESSAGE := 'Fatura ja existe na Capa ' || P_FATURAFAT || '-' || P_CICLOFAT || '-' || P_ROTAFAT || ' Favor Verificar';
              P_STATUS  := PKG_GLB_COMMON.Status_Erro;
          end if;
      end if; 
   END IF;  

   if P_STATUS =  pkg_glb_common.Status_Nomal then
      if vReCalculaCapa Then
         select sum(f.con_fatura_valorcobrado),
                sum(f.con_fatura_desconto)
           into vValorFat,
                vDesconto
         from t_con_faturagrupoxfatura fgf,
              t_con_fatura f
         WHERE FGf.Con_Faturagrupo_Codigo = P_FATURACAP
           AND FGf.Con_Faturagrupo_Ciclo  = P_CICLOCAP
           AND FGf.Glb_Rota_Codigogrupo   = P_ROTACAP
           and fgf.con_fatura_codigo      = f.con_fatura_codigo
           and fgf.con_fatura_ciclo       = f.con_fatura_ciclo
           and fgf.glb_rota_codigofatura  = f.glb_rota_codigofilialimp;

         update t_con_faturagrupo fg
           set fg.con_faturagrupo_valorcobrado = vValorFat,
               fg.con_faturagrupo_desconto = vDesconto
         WHERE FG.CON_FATURAGRUPO_CODIGO   = P_FATURACAP
           AND FG.CON_FATURAGRUPO_CICLO    = P_CICLOCAP
           AND FG.GLB_ROTA_CODIGOFILIALIMP = P_ROTACAP;

        commit;
        P_MESSAGE := 'Operacao completada ...';
        P_STATUS  := PKG_GLB_COMMON.Status_Nomal;
      end if;
   end if;
                
      
  END SP_CON_INCLUIFATCAPA;
  
   PROCEDURE SP_CON_VOLTAVERBASCTRC(P_CTRC  IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,

                                   P_SERIE IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA  IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE)
    
  AS
  BEGIN
          
      insert into t_con_calcconhecimento u1
      select CON_CONHECIMENTO_CODIGO,
      CON_CONHECIMENTO_SERIE,
      GLB_ROTA_CODIGO,
      SLF_RECCUST_CODIGO,
      SLF_TPCALCULO_CODIGO,
      GLB_MOEDA_CODIGO,
      CON_CALCVIAGEM_DESINENCIA,
      CON_CALCVIAGEM_REEMBOLSO,
      CON_CALCVIAGEM_VALOR,
      CON_CALCVIAGEM_TPRATEIO,
      CON_CONHECIMENTO_DTEMBARQUE,
      CON_CONHECIMENTO_ALTALTMAN,
      GLB_ROTA_CODIGOGENERICO,
      con_calcconhecimento_cocli 
      from t_con_calcconhecimentoold u
      where u.con_conhecimento_codigo = P_CTRC
        AND U.CON_CONHECIMENTO_SERIE  = P_SERIE
        and U.GLB_ROTA_CODIGO         = P_ROTA
        and u.con_conhecimento_dtinclusao = (select max(j.con_conhecimento_dtinclusao)
                                             from t_con_calcconhecimentoold j 
                                             where  j.con_conhecimento_codigo= u.con_conhecimento_codigo
                                               and j.con_conhecimento_serie=u.con_conhecimento_serie
                                               and j.glb_rota_codigo=u.glb_rota_codigo
                                               and j.slf_reccust_codigo=u.slf_reccust_codigo)
        and 0 = (select count(*)
                 from t_con_calcconhecimento ca
                 where ca.con_conhecimento_codigo = u.con_conhecimento_codigo
                   and ca.con_conhecimento_serie = u.con_conhecimento_serie
                   and ca.glb_rota_codigo = u.glb_rota_codigo
                   and ca.slf_reccust_codigo = u.slf_reccust_codigo);                                      
                                            


  END;


   PROCEDURE SP_CON_PERCENTAGREGADO(p_placa    in tdvadm.t_car_veiculo.car_veiculo_placa%type,
                                    p_percent  in TDVADM.t_usu_perfil.USU_PERFIL_PARAN1%TYPE,
                                    p_vigencia in TDVADM.t_usu_perfil.USU_PERFIL_VIGENCIA%TYPE,
                                    p_obs      in TDVADM.t_usu_perfil.USU_PERFIL_OBSERVACAO%TYPE,
                                    P_ACAO     IN CHAR,
                                    P_MESSAGE  OUT VARCHAR2,
                                    P_STATUS   OUT CHAR) 
     as
     -- tipos de Acoes
     -- IA - Incluir um Agregado
     -- AA - Altera o percentul do Agregado
     -- EA - Excluir o Agregado 
     -- VA - Verifica o Agragado
     -- EVF - Exclui Vigencias futuras

     vContador   number;
     vVigenciaFut   number;
     vpercentcad tdvadm.t_usu_perfil.usu_perfil_paran1%type;
     vVigencia   tdvadm.t_usu_perfil.usu_perfil_vigencia%type;
     vMinhaAcao  char(9);
     vRegParametro tdvadm.t_usu_perfil%rowtype;
     cAplicacao  CONSTANT char(10) := 'comvlfrete';
     cPrefPerfil CONSTANT char(11) := 'VLRAGREGPER';
  BEGIN
    
   vContador := 0;
   vPercentCad := 0;
   P_STATUS :=  pkg_glb_common.Status_Nomal;
   
   -- verifica se as acoes sao de (I)nclusao ou (E)xclusao
   IF ( P_ACAO <> 'IA' ) AND 
      ( P_ACAO <> 'AA' ) AND 
      ( P_ACAO <> 'EA' ) AND 
      ( P_ACAO <> 'VA' ) AND 
      ( P_ACAO <> 'EVF' ) THEN
        P_MESSAGE := 'Parametro de Acao errado, Verificar. Passado -> ' || P_ACAO || ' -  Usar IA / AA / EA / VA / EVF';
        P_STATUS  := PKG_GLB_COMMON.Status_Erro;
   END IF;     
   
   if P_STATUS =  pkg_glb_common.Status_Nomal then
         
      -- VERIFICA SE O VEICULO EXISTE.
      SELECT COUNT(*)
        INTO vContador
      FROM T_CAR_VEICULO V
      WHERE V.CAR_VEICULO_PLACA = p_placa;
      
      If vContador = 0 then
        P_MESSAGE := 'Veiculo não cadastrado! Placa -> ' || p_placa ;
        P_STATUS  := PKG_GLB_COMMON.Status_Erro;
      end if;
      
      if P_STATUS =  pkg_glb_common.Status_Nomal then
         -- verifica se o veiculo ja exite na tabela de parametros

         begin
           -- procura pela maior vigencia até o dia de hoje
             select *
                into vRegParametro
             from t_usu_perfil p
             where p.usu_aplicacao_codigo = cAplicacao
               and p.usu_perfil_codigo = cPrefPerfil || trim(p_placa)
               and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                            from t_usu_perfil p1
                                            where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                              and p1.usu_perfil_codigo = p.usu_perfil_codigo
                                              and p1.usu_perfil_vigencia <= sysdate);

              vpercentcad := vRegParametro.usu_perfil_paran1;
              vVigencia   := vRegParametro.usu_perfil_vigencia;                                              
              vMinhaAcao := 'Achou';                
          exception 
            when NO_DATA_FOUND then
                -- Crio meu Registro com o perfil padrao (default)
                   select *
                     into vRegParametro
                   from t_usu_perfil p 
                   where p.usu_aplicacao_codigo = cAplicacao
                     and p.usu_perfil_codigo    = cPrefPerfil
                     and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia) 
                                                  from t_usu_perfil p1
                                                  where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                                    and p1.usu_perfil_codigo = p.usu_perfil_codigo);
                 vpercentcad := null;
                 vVigencia   := null; 
                 vMinhaAcao := 'Nao Achou';
            when TOO_MANY_ROWS Then
               P_MESSAGE := 'Veiculo com mais de uma veigenci Ativa! Placa -> ' || p_placa ;
               P_STATUS  := PKG_GLB_COMMON.Status_Erro;
            end;
            -- verifca se existe uma data futura 
          select count(*)
            into vVigenciaFut
          from t_usu_perfil p
          where p.usu_aplicacao_codigo = cAplicacao
            and p.usu_perfil_codigo = cPrefPerfil || trim(p_placa)
            and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                         from t_usu_perfil p1
                                         where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                           and p1.usu_perfil_codigo = p.usu_perfil_codigo
                                           and p1.usu_perfil_vigencia > sysdate);

           if vVigenciaFut > 0 then
              if P_ACAO = 'EVF' then -- excluir Vigencias Futuras;
                -- vamos excluir
                delete t_Usu_Perfil p
                where p.usu_aplicacao_codigo = cAplicacao
                  and p.usu_perfil_codigo = cPrefPerfil || trim(p_placa)
                  and p.usu_perfil_vigencia > sysdate;

                P_MESSAGE := 'Operacao relaizada ....';
                P_STATUS  := PKG_GLB_COMMON.Status_Nomal;
              Else
                P_MESSAGE := 'Existem Vigencias Futuras favor usar a Acao EVF Excluir Vigencias Futuras';
                P_STATUS  := PKG_GLB_COMMON.Status_Erro;
              end if;  
           End if;
           
           if P_STATUS =  pkg_glb_common.Status_Nomal then
            
              If P_ACAO = 'IA' Then -- Incluir um Agregado

                If ( vpercentcad <> p_percent ) and ( vMinhaAcao = 'Achou' )  Then
                   P_MESSAGE := 'Ja existe Percentual de ' || to_char(vpercentcad,'999.09%')  || ' Cadastro para este Veiculo use Opcao AA Alterar Percentual';
                   P_STATUS  := PKG_GLB_COMMON.Status_Warning;
                Elsif vVigencia < p_vigencia and  ( vMinhaAcao = 'Achou' ) then
                   P_MESSAGE := 'Ja existe uma Vigencia cadastrada para este Veiculo use Opcao AA Alterar Percentual ou EA excluir Vigencia';
                   P_STATUS  := PKG_GLB_COMMON.Status_Warning;
                Elsif vMinhaAcao = 'Nao Achou' Then
                    vRegParametro.Usu_Perfil_Codigo   :=  cPrefPerfil || p_placa;
                    vRegParametro.Usu_Perfil_Paran1   := p_percent; 
                    vRegParametro.Usu_Perfil_Vigencia := p_vigencia;
                     vRegParametro.Usu_Perfil_Dtcad := sysdate;
 
                   insert into t_usu_perfil values vRegParametro;
                   P_MESSAGE := 'Operacao relaizada ....';
                   P_STATUS  := PKG_GLB_COMMON.Status_Nomal;
                Else
                   P_MESSAGE := 'Ja existe uma Vigencia cadastrada para este Veiculo use Opcao AA Alterar Percentual ou EA excluir Vigencia';
                   P_STATUS  := PKG_GLB_COMMON.Status_Warning;
                end if; 
              ElsIf P_ACAO = 'AA' Then -- Altera o percentul do Agregado
                  If ( vpercentcad = p_percent ) and ( vMinhaAcao = 'Achou' )  Then
                     P_MESSAGE := 'Ja existe Percentual de ' || to_char(vpercentcad,'999.09%')  || ' Cadastro para este Veiculo use Opcao AA Alterar Percentual';
                     P_STATUS  := PKG_GLB_COMMON.Status_Warning;
                   Elsif vVigencia < p_vigencia and  ( vMinhaAcao = 'Achou' ) then
                     P_MESSAGE := 'Ja existe uma Vigencia cadastrada para este Veiculo use Opcao AA Alterar Percentual ou EA excluir Vigencia';
                     P_STATUS  := PKG_GLB_COMMON.Status_Warning;
                   ElsIf ( vMinhaAcao = 'Achou' ) Then
    
                     vRegParametro.Usu_Perfil_Paran1   := p_percent; 
                     vRegParametro.Usu_Perfil_Vigencia := p_vigencia;
                     vRegParametro.Usu_Perfil_Dtcad := sysdate;
 
                     insert into t_usu_perfil values vRegParametro;

                     P_MESSAGE := 'Operacao relaizada ....';
                     P_STATUS  := PKG_GLB_COMMON.Status_Nomal;
                     
                   End If;   
                    end if;
              ElsIf P_ACAO = 'EA' Then -- Excluir o Agregado 

                   If vVigencia > p_vigencia and  ( vMinhaAcao = 'Achou' ) then
                     P_MESSAGE := 'Ja existe uma Vigencia Maior do que voce esta querendo alterar, Verifique a vigencia passada';
                     P_STATUS  := PKG_GLB_COMMON.Status_Warning;
                   ElsIf ( vMinhaAcao = 'Achou' ) Then
                     vRegParametro.Usu_Perfil_Vigencia := p_vigencia;
                     vRegParametro.Usu_Perfil_Dtcad := sysdate;
                      
                     insert into t_usu_perfil values vRegParametro;
                     P_MESSAGE := 'Operacao relaizada ....';
                     P_STATUS  := PKG_GLB_COMMON.Status_Nomal;
                     
              ElsIf P_ACAO = 'VA' Then -- Verifica o Agragado
                   
                  P_MESSAGE := 'Vigencia   -> ' || to_char(vRegParametro.Usu_Perfil_Vigencia,'dd/mm/yyyy') || chr(10) ||
                               'Cadastrada -> ' || to_char(vRegParametro.Usu_Perfil_Dtcad,'dd/mm/yyyy') || chr(10) ||
                               'Percentual -> ' || to_char(vRegParametro.Usu_Perfil_Paran1,'999.09%');
                  P_STATUS  := PKG_GLB_COMMON.Status_Nomal;

              End If;            

           End if;       

      end if;
   end if;
    if P_STATUS =  pkg_glb_common.Status_Nomal then
        commit;

        P_MESSAGE := 'Operacao completada ...';
        P_STATUS  := PKG_GLB_COMMON.Status_Nomal;
        
    end If;
   end SP_CON_PERCENTAGREGADO;
                                    

  PROCEDURE sp_slf_desreajusta IS
    CURSOR C_SLF IS
      SELECT S.SLF_SOLFRETE_CODIGO CODIGO,
             S.SLF_SOLFRETE_SAQUE SAQUE,
             C.SLF_CALCSOLFRETE_VALOR ALIQ
        FROM T_SLF_SOLFRETE S,
             T_GLB_LOCALIDADE O,
             T_GLB_LOCALIDADE D,
             T_SLF_CALCSOLFRETE C
       WHERE S.SLF_SOLFRETE_STATUS IS NULL
         AND S.SLF_SOLFRETE_ISENTO = 'N'
         AND S.SLF_SOLFRETE_VIGENCIA = TO_DATE('01/12/2005', 'DD/MM/YYYY')
         AND S.SLF_SOLFRETE_SAQUE = (SELECT MAX(M.SLF_SOLFRETE_SAQUE)
                                       FROM T_SLF_SOLFRETE M
                                      WHERE M.SLF_SOLFRETE_CODIGO = S.SLF_SOLFRETE_CODIGO)
         AND S.GLB_LOCALIDADE_CODIGOCOLETA = O.GLB_LOCALIDADE_CODIGO
         AND S.GLB_LOCALIDADE_CODIGOENTREGA = D.GLB_LOCALIDADE_CODIGO
         AND O.GLB_ESTADO_CODIGO = NVL('MG', O.GLB_ESTADO_CODIGO)
         AND D.GLB_ESTADO_CODIGO = NVL(NULL, D.GLB_ESTADO_CODIGO)
         AND C.SLF_SOLFRETE_CODIGO = S.SLF_SOLFRETE_CODIGO
         AND C.SLF_SOLFRETE_SAQUE = S.SLF_SOLFRETE_SAQUE
         AND C.SLF_RECCUST_CODIGO = 'S_ALICMS'
         AND C.SLF_TPCALCULO_CODIGO = '041'
         AND C.SLF_CALCSOLFRETE_VALOR = 0;
    
    V_ALIQUOTA NUMBER;
    V_PERCENTUAL NUMBER;
  BEGIN       
    FOR SLF IN C_SLF LOOP
      SELECT CS.SLF_CALCSOLFRETE_VALOR
        INTO V_ALIQUOTA
        FROM T_SLF_CALCSOLFRETE CS
       WHERE CS.SLF_SOLFRETE_CODIGO = SLF.CODIGO
         AND CS.SLF_SOLFRETE_SAQUE = LPAD(TRIM(TO_CHAR(TO_NUMBER(SLF.SAQUE) - 1)),4,'0')
         AND CS.SLF_RECCUST_CODIGO = 'S_ALICMS';
       
      -- ATUALIZAR AS VERBAS
      IF V_ALIQUOTA = 12 THEN
        V_PERCENTUAL := 1.0572;
      ELSIF V_ALIQUOTA = 19 THEN
        V_PERCENTUAL := 1.0627;
      ELSIF V_ALIQUOTA = 17 THEN
        V_PERCENTUAL := 1.0610;
      ELSIF V_ALIQUOTA = 5 THEN
        V_PERCENTUAL := 1.0526;
      ELSIF V_ALIQUOTA = 7 THEN
        V_PERCENTUAL := 1.0539;
      ELSIF V_ALIQUOTA = 0 THEN
        V_PERCENTUAL := 1.0498;
      ELSIF V_ALIQUOTA = 18 THEN
        V_PERCENTUAL := 1.0618;
      ELSIF V_ALIQUOTA = 3 THEN
        V_PERCENTUAL := 1.0515;
      ELSE
        V_PERCENTUAL := 1.0498;
      END IF;   

      -- PARA PEGAR AS VEBAS A SEREM REAJUSTADAS
      UPDATE T_SLF_CALCSOLFRETE
         SET SLF_CALCSOLFRETE_VALOR = ROUND(SLF_CALCSOLFRETE_VALOR / V_PERCENTUAL,2)
       WHERE SLF_SOLFRETE_CODIGO = SLF.CODIGO
         AND SLF_SOLFRETE_SAQUE  = SLF.SAQUE
         AND SLF_RECCUST_CODIGO  = 'D_FRPSVO';
    END LOOP;
    COMMIT;
  END sp_slf_desreajusta;


   PROCEDURE SP_ATAULIZA_ALIQUOTA(P_NUMERO IN TDVADM.T_SLF_TABELA.SLF_TABELA_CODIGO%TYPE,
                                  P_SLF_TABSOL IN CHAR,
                                  P_STATUS   OUT CHAR,
                                  P_MESSAGE  OUT VARCHAR2)
   is
     vCodigo  TDVADM.T_SLF_TABELA.SLF_TABELA_CODIGO%TYPE;
     vSaque   TDVADM.t_slf_tabela.slf_tabela_saque%type;
     vAliquota number;
     vTipo    TDVADM.T_SLF_TABELA.SLF_TABELA_TIPO%TYPE;
     vOrigem  t_glb_localidade.glb_localidade_codigo%type;
     vOrigemIBGE  t_glb_localidade.glb_localidade_codigoibge%type;
     vUFOrigem T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
     vDestino t_glb_localidade.glb_localidade_codigo%type;
     vDestinoIBGE t_glb_localidade.glb_localidade_codigoibge%type;
     vUFDestino T_GLB_ESTADO.GLB_ESTADO_CODIGO%TYPE;
--     cIbge   pkg_glb_common.T_CURSOR;
     vSQL    VARCHAR2(1000);
   BEGIN
     vCodigo := TRIM(LPAD(TO_NUMBER(P_NUMERO),8,'0')); 
     -- PEGA O MAIOR SAQUE E DEFINE QUEM VAI SER A ORIGEM / DESTINO
     If P_SLF_TABSOL = 'T' THEN 
        SELECT MAX(T.SLF_TABELA_SAQUE)
          INTO vSaque
        FROM T_SLF_TABELA T
        WHERE T.SLF_TABELA_CODIGO = vCodigo;

        SELECT T.SLF_TABELA_TIPO,
               LO.GLB_LOCALIDADE_CODIGO,
               LO.GLB_LOCALIDADE_CODIGOIBGE,
               LO.GLB_ESTADO_CODIGO
           INTO vTipo,
                vOrigem,
                vOrigemIBGE,
                vUFOrigem
        FROM T_SLF_TABELA T,
             t_glb_localidade lo
        WHERE T.SLF_TABELA_CODIGO = vCodigo
          AND T.SLF_TABELA_SAQUE = vSaque
          AND T.GLB_LOCALIDADE_CODIGO = LO.GLB_LOCALIDADE_CODIGO;
          
        IF vTipo = 'FOB' THEN
           vDestino     := vOrigem;
           vDestinoIBGE := vOrigemIBGE;
           vUFDestino   := vUFOrigem;
           vOrigem      := '';
           vOrigemIBGE  := '';
           vUFOrigem    := '';
        ELSE
           vDestino     := ''; 
           vDestinoIBGE := '';
           vUFDestino   := '';       
        END IF;
     Else
       
        SELECT MAX(T.SLF_SOLFRETE_SAQUE)
          INTO vSaque
        FROM T_SLF_SOLFRETE T
        WHERE T.SLF_SOLFRETE_CODIGO = vCodigo;

        SELECT LO.GLB_LOCALIDADE_CODIGO,
               LO.GLB_LOCALIDADE_CODIGOIBGE,
               LO.GLB_ESTADO_CODIGO,
               LD.GLB_LOCALIDADE_CODIGO,
               LD.GLB_LOCALIDADE_CODIGOIBGE,
               LD.GLB_ESTADO_CODIGO
          into  vOrigem,
                vOrigemIBGE,
                vUFOrigem,
                vDestino,
                vDestinoIBGE,
                vUFDestino
        FROM T_SLF_SOLFRETE SF,
             T_GLB_LOCALIDADE LO,
             T_GLB_LOCALIDADE LD
        WHERE SF.SLF_SOLFRETE_CODIGO = vCodigo
          AND SF.SLF_SOLFRETE_SAQUE  = vSaque
          AND SF.GLB_LOCALIDADE_CODIGOCOLETA = LO.GLB_LOCALIDADE_CODIGO
          AND SF.GLB_LOCALIDADE_CODIGOENTREGA = LD.GLB_LOCALIDADE_CODIGO;
        
     End if;     
   
     P_STATUS := PKG_GLB_COMMON.Status_Nomal;
     P_MESSAGE := '';
     FOR CIBGE IN (
                 SELECT LO.GLB_LOCALIDADE_CODIGO,
                        LO.GLB_ESTADO_CODIGO, 
                        LO.GLB_LOCALIDADE_DESCRICAO 
                 FROM T_SLF_TABELA T, 
                      T_GLB_LOCALIDADE LO 
                 WHERE T.SLF_TABELA_CODIGO = vCodigo
                   AND T.SLF_TABELA_SAQUE = vSaque
                   AND T.GLB_LOCALIDADE_CODIGO = LO.GLB_LOCALIDADE_CODIGO 
                   AND LO.GLB_LOCALIDADE_CODIGOIBGE IS NULL 
                 UNION 
                 SELECT LO.GLB_LOCALIDADE_CODIGO,
                        LO.GLB_ESTADO_CODIGO, 
                        LO.GLB_LOCALIDADE_DESCRICAO
                 FROM T_SLF_TABELADET TD ,
                      T_GLB_LOCALIDADE LO
                  WHERE TD.SLF_TABELA_CODIGO = vCodigo
                    AND TD.SLF_TABELA_SAQUE = vSaque
                    AND TD.GLB_LOCALIDADE_CODIGO = LO.GLB_LOCALIDADE_CODIGO 
                    AND LO.GLB_LOCALIDADE_CODIGOIBGE IS NULL 
                 UNION    
                 SELECT LO.GLB_LOCALIDADE_CODIGO,
                        LO.GLB_ESTADO_CODIGO, 
                        LO.GLB_LOCALIDADE_DESCRICAO
                 FROM T_SLF_SOLFRETE SF,
                      T_GLB_LOCALIDADE LO
                 WHERE SF.SLF_SOLFRETE_CODIGO = vCodigo
                   AND SF.SLF_SOLFRETE_SAQUE = vSaque
                   AND SF.GLB_LOCALIDADE_CODIGOCOLETA = LO.GLB_LOCALIDADE_CODIGO
                   AND LO.GLB_LOCALIDADE_CODIGOIBGE IS NULL
                 UNION
                 SELECT LD.GLB_LOCALIDADE_CODIGO,
                        LD.GLB_ESTADO_CODIGO, 
                        LD.GLB_LOCALIDADE_DESCRICAO
                 FROM T_SLF_SOLFRETE SF,
                      T_GLB_LOCALIDADE LD
                 WHERE SF.SLF_SOLFRETE_CODIGO = vCodigo
                   AND SF.SLF_SOLFRETE_SAQUE = vSaque
                   AND SF.GLB_LOCALIDADE_CODIGOENTREGA = LD.GLB_LOCALIDADE_CODIGO
                   AND LD.GLB_LOCALIDADE_CODIGOIBGE IS NULL
                     )
   LOOP
      P_MESSAGE := P_MESSAGE || CIBGE.GLB_LOCALIDADE_CODIGO || '-' || CIBGE.GLB_ESTADO_CODIGO || '-' || CIBGE.GLB_LOCALIDADE_DESCRICAO || CHR(10);
   END LOOP;
       
   IF LENGTH(TRIM(P_MESSAGE)) > 0 THEN
       P_STATUS := PKG_GLB_COMMON.Status_Erro;
        P_MESSAGE := 'FALTAM IBGE DAS LOCALIDADE ABAIXO' || CHR(10) || P_MESSAGE;
   END IF;
   
   IF P_STATUS <> PKG_GLB_COMMON.Status_Erro THEN

      IF P_SLF_TABSOL = 'T' THEN
         FOR CURTAB IN (
                       SELECT LO.GLB_LOCALIDADE_CODIGO,
                              LO.GLB_LOCALIDADE_CODIGOIBGE,
                              LO.GLB_ESTADO_CODIGO
                       FROM T_SLF_TABELADET TD ,
                            T_GLB_LOCALIDADE LO
                        WHERE TD.SLF_TABELA_CODIGO = vCodigo
                          AND TD.SLF_TABELA_SAQUE = vSaque
                          AND TD.GLB_LOCALIDADE_CODIGO = LO.GLB_LOCALIDADE_CODIGO 
                       )
         LOOP
             IF vTipo = 'FOB' THEN
                vOrigem     := CURTAB.GLB_LOCALIDADE_CODIGO;
                vOrigemIBGE := CURTAB.GLB_LOCALIDADE_CODIGOIBGE;
                vUFOrigem   := CURTAB.GLB_ESTADO_CODIGO;
             ELSE  
                vDestino     := CURTAB.GLB_LOCALIDADE_CODIGO;
                vDestinoIBGE := CURTAB.GLB_LOCALIDADE_CODIGOIBGE;
                vUFDestino   := CURTAB.GLB_ESTADO_CODIGO;
             END IF         ;

             if vOrigemIBGE = vDestinoIBGE then
                begin
                  select i.slf_iss_aliquota
                    into vAliquota
                  from t_slf_iss i
                  where i.glb_localidade_codigo = vOrigem
                    and i.slf_tpcalculo_codigo = '115'
                    and trunc(sysdate) between trunc(i.glb_iss_datainicio) and trunc(i.glb_iss_datafinal);
                exception
                  when NO_DATA_FOUND then
                    select i.slf_iss_aliquota
                      into vAliquota
                    from t_slf_iss i
                    where i.slf_tpcalculo_codigo = '115'
                      and i.slf_iss_default = 'S';
                  end;
             Else
               select i.slf_icms_aliquota
                 into vAliquota
               from t_slf_icms i  
               where i.glb_estado_codigoorigem = vUFOrigem
                 and i.glb_estado_codigodestino = vUFDestino
                 and i.slf_icms_dataefetiva = (select max(i2.slf_icms_dataefetiva)
                                               from t_slf_icms i2
                                               where i2.glb_estado_codigoorigem = i.glb_estado_codigoorigem
                                                 and i2.glb_estado_codigodestino = i.glb_estado_codigodestino
                                                 and trunc(i2.slf_icms_dataefetiva) <= trunc(sysdate));
             end if;   

             update t_slf_calctabela td
               set td.slf_calctabela_valor = vAliquota
             WHERE TD.SLF_TABELA_CODIGO = vCodigo
               AND TD.SLF_TABELA_SAQUE = vSaque
               and td.glb_localidade_codigo = CURTAB.GLB_LOCALIDADE_CODIGO
               and td.slf_reccust_codigo in ('S_ALICMS','S_ALISS');

         END LOOP;
         --PKG_SLF_TABELAS.SP_CALC_TOT_PRACA_TABELA(vCodigo,vSaque);

      ELSE

             if vOrigemIBGE = vDestinoIBGE then
                begin
                  select i.slf_iss_aliquota
                    into vAliquota
                  from t_slf_iss i
                  where i.glb_localidade_codigo = vOrigem
                    and i.slf_tpcalculo_codigo = '115'
                    and trunc(sysdate) between trunc(i.glb_iss_datainicio) and trunc(i.glb_iss_datafinal);
                exception
                  when NO_DATA_FOUND then
                    select i.slf_iss_aliquota
                      into vAliquota
                    from t_slf_iss i
                    where i.slf_tpcalculo_codigo = '115'
                      and i.slf_iss_default = 'S';
                  end;
             Else
               select i.slf_icms_aliquota
                 into vAliquota
               from t_slf_icms i  
               where i.glb_estado_codigoorigem = vUFOrigem
                 and i.glb_estado_codigodestino = vUFDestino
                 and i.slf_icms_dataefetiva = (select max(i2.slf_icms_dataefetiva)
                                               from t_slf_icms i2
                                               where i2.glb_estado_codigoorigem = i.glb_estado_codigoorigem
                                                 and i2.glb_estado_codigodestino = i.glb_estado_codigodestino
                                                 and trunc(i2.slf_icms_dataefetiva) <= trunc(sysdate));
             end if;   

             UPDATE T_SLF_CALCSOLFRETE SF
               SET SF.SLF_CALCSOLFRETE_VALOR = vAliquota
             WHERE SF.SLF_SOLFRETE_CODIGO = vCodigo
               AND SF.SLF_SOLFRETE_SAQUE  = vSaque;

        
      END IF;
 


                 

   END IF;

    
   END SP_ATAULIZA_ALIQUOTA;
   
    function fn_ordchapeira (p_1 char,p_2 number) return integer
    as
    /***************************************************************************************************
    * ROTINA           : fn_ordchapeira                                                                *
    * PROGRAMA         : anida não tem front end                                                       *
    * ANALISTA         : Ugo César e Roberto Pariz                                                     *
    * DESENVOLVEDOR    : Ugo César e Roberto Pariz                                                     *
    * DATA DE CRIACAO  : ??/??/2011                                                                    *
    * BANCO            : ORACLE-TDP                                                                    *
    * EXECUTADO POR    : enquanto não tem front end para o DP o helpdesk roda a procedure manualmente  *
    * ALIMENTA         : PKG_HD_UTILITARIO.SP_FPW_CADCHAPEIRA                                          *
    * FUNCINALIDADE    : dESCOBRIR UM NUMERO VAGO NA CHAPEIRA INFORMADA E RETORNAR A INFORMAÇÃO PARA A *
    *                    PROCEDURE QUE FAZ O CADASTRO                                                  *
    * ATUALIZA         :                                                                               *
    * PARTICULARIDADES : MATRICULA DE ESTAGIÁRIO É SEMPRE SUPERIOR A 80000000                          *                         
    * PARAM. OBRIGAT.  : P_1 (CHAPEIRA) E P_2 (MATRICULA)                                              *
    * PARAM. N OBRIG   :                                                                               *
    ****************************************************************************************************/

    VT_SEQUENCIA INTEGER := 0;
    VT_RETORNO   INTEGER := 0;
    VT_INTINI    INTEGER := 1;
    VT_INTFIM    INTEGER := 89;
    V_VERIFUNIQ  INTEGER := 0;

    CURSOR C_CHAP IS
    select * from TDVADM.t_fpw_chapeira fc
     where fc.fpw_chapeira_ordem >= VT_INTINI
       and fc.fpw_chapeira_ordem <= VT_INTFIM
       and fc.fpw_chapeira_codigo = p_1
      order by fc.fpw_chapeira_codigo,
              fc.fpw_chapeira_ordem;

    BEGIN

      IF P_2 >= 80000000 THEN
        VT_INTINI :=90;
        VT_INTFIM :=100;
      END IF;

      FOR R_CHAP IN C_CHAP LOOP
       IF VT_SEQUENCIA < VT_INTINI THEN
         IF R_CHAP.FPW_CHAPEIRA_ORDEM <> VT_INTINI THEN
           VT_RETORNO := VT_INTINI;
           RETURN VT_RETORNO;
         END IF;
         VT_SEQUENCIA := VT_INTINI;
       ELSE
         IF (R_CHAP.FPW_CHAPEIRA_ORDEM - VT_SEQUENCIA) > 1 THEN
           VT_RETORNO := VT_SEQUENCIA+1;
           RETURN VT_RETORNO;
         END IF;  
         VT_SEQUENCIA := R_CHAP.FPW_CHAPEIRA_ORDEM;
       END IF;   
      END LOOP;

      IF VT_SEQUENCIA = 0 THEN 
         VT_RETORNO := VT_INTINI;
      ELSE 
         VT_RETORNO := VT_INTINI+1;
      END IF;

      SELECT COUNT(*)
        INTO V_VERIFUNIQ
        FROM T_FPW_CHAPEIRA C
       WHERE C.FPW_CHAPEIRA_CODIGO = p_1
         AND C.FPW_CHAPEIRA_ORDEM = VT_RETORNO;
        
      IF V_VERIFUNIQ > 0 THEN
        SELECT MAX(F.FPW_CHAPEIRA_ORDEM) + 1
          INTO VT_RETORNO
          FROM T_FPW_CHAPEIRA F
         WHERE F.FPW_CHAPEIRA_ORDEM >= VT_INTINI
           AND F.FPW_CHAPEIRA_ORDEM <= VT_INTFIM
           AND F.FPW_CHAPEIRA_CODIGO = p_1;
      END IF;

    RETURN VT_RETORNO;

    END fn_ordchapeira;
    
  PROCEDURE SP_FPW_CADCHAPEIRA(P_CHAPEIRA char,
                               P_MATRICULA number)AS
  /***************************************************************************************************
  * ROTINA           : SP_FPW_CADCHAPEIRA                                                            *
  * PROGRAMA         : anida não tem front end                                                       *
  * ANALISTA         : Ugo César                                                                     *
  * DESENVOLVEDOR    : Ugo César                                                                     *
  * DATA DE CRIACAO  : ??/??/2011                                                                    *
  * BANCO            : ORACLE-TDP                                                                    *
  * EXECUTADO POR    : enquanto não tem front end para o DP o helpdesk roda a procedure manualmente  *
  * ALIMENTA         : AGUARDANDO PARA ALIMENTAR UM FRONT END                                        *
  * FUNCINALIDADE    : CADASTRAR O FUNCIONÁRIO NA CHAPEIRA INFORMADA                                 *
  * ATUALIZA         : T_FPW_CHAPEIRA                                                                *
  * PARTICULARIDADES : MATRICULA DE ESTAGIÁRIO É SEMPRE SUPERIOR A 80000000                          *                         
  * PARAM. OBRIGAT.  : P_CHAPEIRA E P_MATRICULA                                                      *
  * PARAM. N OBRIG   :                                                                               *
  ****************************************************************************************************/
    V_ORDEM INTEGER;
    V_NUMREG INTEGER;
    V_LOTACAO VARCHAR2(45);
    BEGIN
      /*INSERE OS REGISTROS DOS FUNCIONÁRIOS COM CONTRATOS
        RESCINDIDOS NA TABELA VOLTADA A ESSE FIM*/
      INSERT INTO t_fpw_chapeirarescisao
      SELECT *
        from t_fpw_chapeira c
       where C.fpw_chapeira_matricula in (select c2.fpw_chapeira_matricula
                                            from t_fpw_chapeira c2,
                                                 fpw.funciona f,
                                                 fpw.situacao s
                                           where c2.fpw_chapeira_matricula = f.fumatfunc
                                             and f.fucodsitu = s.stcodsitu
                                             and s.sttipositu = 'R');
      COMMIT;
      
      /*DEPOIS DE INSERIR NA TABELA DE RESCISÃO EU DELETO DA TABELA ORIGINAL*/
      DELETE from t_fpw_chapeira c
       where C.fpw_chapeira_matricula in (select c2.fpw_chapeira_matricula
                                            from t_fpw_chapeira c2,
                                                 fpw.funciona f,
                                                 fpw.situacao s
                                           where c2.fpw_chapeira_matricula = f.fumatfunc
                                             and f.fucodsitu = s.stcodsitu
                                             and s.sttipositu = 'R')
         AND C.FPW_CHAPEIRA_MATRICULA IN (SELECT C3.fpw_chapeira_matricula
                                            FROM T_fpw_chapeirarescisao C3);
      COMMIT;
      
      /*CONTADOR PARA VERIFICAR SE O FUNCIONÁRIO JA ESTÁ CADASTRADO*/
      select count(*)
        INTO V_NUMREG
        from t_fpw_chapeira ch,
             FPW.FUNCIONA F
       where CH.FPW_CHAPEIRA_MATRICULA = P_MATRICULA
         AND ch.fpw_chapeira_matricula = f.fumatfunc
         and ch.fpw_chapeira_empresa = f.fucodemp
         and ch.fpw_chapeira_codigo = P_CHAPEIRA;
      
      /*PEGA LOTACAO*/
      begin 
      SELECT l.lodesclot
        INTO V_LOTACAO
        FROM fpw.funciona f,
             fpw.lotacoes l
       where f.fumatfunc = P_MATRICULA
         and f.fucodlot = l.locodlot;
             
         EXCEPTION when NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20001, 'Matricula' || P_MATRICULA || 'Não encontrada!');
           end;
           
      
      /*PEGA ORDEM QUE SERÁ INSERIDA*/
      V_ORDEM := fn_ordchapeira(P_CHAPEIRA,P_MATRICULA);
          
      /*VERIFICA SE O CADASTRO JA EXISTIA*/
      IF V_NUMREG = 0 THEN
        /*VERIFICA SE A ORDEM É VÁLIDA*/
        IF (V_ORDEM >= 90 AND P_MATRICULA <= 80000000) OR (V_ORDEM > 100) THEN
          RAISE_APPLICATION_ERROR(-20001,'NÃO HÁ ORDEM/ESPAÇO DISPONÍVEL NA CHAPEIRA');
        ELSE/*SE TUDO ESTIVER OK, INSERE O VALOR DAS VARIÁVEIS E DAS COLUNAS DA TABELA DO FPW NA TABELA DAS CHAPEIRAS*/
          INSERT INTO T_FPW_CHAPEIRA
          select P_CHAPEIRA CHAPEIRA,
                 V_ORDEM ORDEM,
                 f.fumatfunc MATRICULA,
                 f.fucodemp EMPRESA,
                 V_LOTACAO LOTACAO,
                 f.funomfunc NOME,
                 sysdate DTCADASTRO
            from fpw.funciona f
           where f.fumatfunc = P_MATRICULA;
          COMMIT; 
        END IF;
      ELSE
        RAISE_APPLICATION_ERROR(-20001,'USUÁRIO JÁ CADASTRADO! MATRICULA: '||TO_CHAR(P_MATRICULA)||', '||V_LOTACAO);
      END IF;
  END SP_FPW_CADCHAPEIRA;
  
  PROCEDURE SP_RJR_CADTARIFA(P_AREA IN CHAR,
                             P_TARIFA IN VARCHAR2,
                             P_VALOR IN NUMBER,
                             P_VIGENCIA IN DATE,
                             P_CARGA IN VARCHAR2,
                             P_VALORES OUT T_CURSOR,
                             P_STATUS OUT CHAR,                                           
                             P_MESSAGE OUT VARCHAR2)AS
  
  /***************************************************************************************************
  * ROTINA           : Cadastro de Tarifas da Coca                                                   *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Ugo César                                                                     *
  * DESENVOLVEDOR    : Ugo César                                                                     *
  * DATA DE CRIACAO  : 04/09/2012                                                                    *
  * BANCO            : oracle-tdp                                                                    *
  * EXECUTADO POR    : helpdesk                                                                      *
  * ALIMENTA         : T_RJF_CARGAS                                                                  *
  * FUNCINALIDADE    :                                                                               *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES : Usado quando a Cris faz a leitura do RTT e é acusada tarifa não cadastrada    *
  * PARAM. OBRIGAT.  : P_AREA ; P_TARIFA ; P_VALOR ; P_CARGA                                         *
  ****************************************************************************************************/
  
    V_PARAMVALID NUMBER;
    V_TPCARGA CHAR(1);
    
  BEGIN
    SELECT COUNT(*)
      INTO V_PARAMVALID
      FROM RJRADM.T_RJR_AREA A
     WHERE trim(A.RJR_AREA_CODIGO) = trim(P_AREA);
    IF V_PARAMVALID > 0 THEN
      SELECT COUNT(*)
        INTO V_PARAMVALID
        FROM T_RJF_TABELAAGREGADOS TA
       WHERE trim(TA.RJF_CARGAS_AREA) = trim(P_AREA)
         AND trim(TA.RJF_TABELAAGREGADOS_TARIFA) = trim(P_TARIFA)
         AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                  FROM T_RJF_TABELAAGREGADOS TA1
                                                 WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                   AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                   AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA);
      IF V_PARAMVALID > 0 THEN
        SELECT COUNT(*)
          INTO V_PARAMVALID
          FROM T_RJF_TABELAAGREGADOS TA
         WHERE trim(TA.RJF_CARGAS_AREA) = trim(P_AREA)           
           AND trim(TA.RJF_TABELAAGREGADOS_TARIFA) = trim(P_TARIFA)
           AND trim(TA.RJF_TABELAAGREGADOS_VLRAGR) = trim(P_VALOR)
           AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                    FROM T_RJF_TABELAAGREGADOS TA1
                                                   WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                     AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                     AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA);
        IF V_PARAMVALID > 0 THEN
          SELECT DISTINCT TA.RJF_TIPOCARGAS_CODIGO
            INTO V_TPCARGA
            FROM T_RJF_TABELAAGREGADOS TA
           WHERE trim(TA.RJF_CARGAS_AREA) = trim(P_AREA)           
             AND trim(TA.RJF_TABELAAGREGADOS_TARIFA) = trim(P_TARIFA)
             AND trim(TA.RJF_TABELAAGREGADOS_VLRAGR) = trim(P_VALOR)
             AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                      FROM T_RJF_TABELAAGREGADOS TA1
                                                     WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                       AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                       AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA);
          BEGIN
            INSERT INTO T_RJF_CARGAS(RJF_CARGAS_CODIGO,
                                     RJF_CARGAS_AREA,
                                     RJF_TIPOCARGAS_CODIGO,
                                     RJF_CARGAS_VIGENCIA )
                              VALUES(trim(P_CARGA),
                                     trim(P_AREA),
                                     trim(V_TPCARGA),
                                     trim(P_VIGENCIA));
            COMMIT;
            P_STATUS := PKG_GLB_COMMON.Status_Nomal;
            P_MESSAGE := 'TARIFA CADASTRADA COM SUCESSO!';
          EXCEPTION
            WHEN OTHERS THEN
              P_STATUS := PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := 'ERRO AO CADASTRAR TARIFA! erro: ' || sqlerrm;
          END;
        ELSE
          P_STATUS := PKG_GLB_COMMON.Status_Erro;
          P_MESSAGE := 'VERIFIQUE O VALOR PASSADO! ' ||
                       ' AREA: ' || P_AREA ||
                       ' TARIFA ' || P_TARIFA || 
                       ' VALOR: ' || P_VALOR;
          OPEN P_VALORES FOR SELECT TA.RJF_CARGAS_AREA AREA,
                                     TA.RJF_TABELAAGREGADOS_TARIFA TARIFA,
                                     TA.RJF_TABELAAGREGADOS_VLRAGR VALOR
                              FROM T_RJF_TABELAAGREGADOS TA
                             WHERE TA.RJF_CARGAS_AREA = P_AREA           
                               AND TA.RJF_TABELAAGREGADOS_TARIFA = P_TARIFA
                               AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                                        FROM T_RJF_TABELAAGREGADOS TA1
                                                                       WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                                         AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                                         AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA);
        END IF;
      ELSE
        P_STATUS := PKG_GLB_COMMON.Status_Erro;
        P_MESSAGE := 'VERIFIQUE A TARIFA ! ' ||
                       ' AREA: ' || P_AREA ||
                       ' TARIFA ' || P_TARIFA || 
                       ' VALOR: ' || P_VALOR;
      END IF;
    ELSE
      P_STATUS := PKG_GLB_COMMON.Status_Erro;
      P_MESSAGE := 'VERIFIQUE A AREA PASSADA ! ' || 
                       ' AREA: ' || P_AREA ||
                       ' TARIFA ' || P_TARIFA || 
                       ' VALOR: ' || P_VALOR;
    END IF;
  END SP_RJR_CADTARIFA;


  PROCEDURE SP_FRT_VERIFICAAGREGADO(P_PLACA IN CHAR,
                                    P_CURSOR OUT  T_CURSOR)
  AS
  /**************************************************************************
  * ROTINA           : Verifica se a placa pode ser agragado ou não         *
  * PROGRAMA         :                                                      *
  * ANALISTA         : Sirlano                                              *
  * DESENVOLVEDOR    : Sirlano                                              *
  * DATA DE CRIACAO  : 27/09/2012                                           *
  * BANCO            : oracle-tdp                                           *
  * EXECUTADO POR    : helpdesk                                             *
  * ALIMENTA         :                                                      *
  * FUNCINALIDADE    :                                                      *
  * ATUALIZA         :                                                      *
  * PARTICULARIDADES :                                                      *
  * PARAM. OBRIGAT.  : P_PLACA                                              *
  ***************************************************************************/
  BEGIN                                    
  OPEN P_CURSOR FOR 
        select v.car_veiculo_placa placa,
             v.car_veiculo_saque saque,
             v.car_proprietario_cgccpfcodigo prop,
             v.car_veiculo_carreta_placa carreta,
             (select count(*)
              from t_frt_veiculo v
              where v.frt_veiculo_placa = v.car_veiculo_placa
                and v.frt_veiculo_datavenda is null) CAVALONAFROTA,
             (select count(*)
              from t_frt_veiculo v
              where v.frt_veiculo_placa = v.car_veiculo_carreta_placa
                and v.frt_veiculo_datavenda is null) CARRETANAFROTA,
              (select count(*)
               from t_atr_terminal t
               where t.atr_terminal_placa = v.car_veiculo_placa
                 and t.atr_terminal_dtretirado is null) TERMINALATR,
              (SELECT p.usu_perfil_paran1
               FROM T_USU_PERFIL p
               WHERE p.USU_APLICACAO_CODIGO = 'comvlfrete'
                 AND p.USU_PERFIL_CODIGO = 'VLRAGREGPER' ||v.car_veiculo_placa 
                 and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                              from T_USU_PERFIL p1
                                              where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                                and p1.usu_perfil_codigo = p.usu_perfil_codigo)
                 ) percplaca,
              (SELECT p.usu_perfil_paran1 
               FROM T_USU_PERFIL p
               WHERE p.USU_APLICACAO_CODIGO = 'comvlfrete'
                 AND p.USU_PERFIL_CODIGO = 'VLRAGREGPER'
                 and p.usu_perfil_vigencia = (select max(p1.usu_perfil_vigencia)
                                              from T_USU_PERFIL p1
                                              where p1.usu_aplicacao_codigo = p.usu_aplicacao_codigo
                                                and p1.usu_perfil_codigo = p.usu_perfil_codigo)
                 ) percdefault
      from t_car_veiculo v
      where v.car_veiculo_placa = P_PLACA;
  END;

  PROCEDURE SP_RJR_ALTERARQ(P_MATRICULA IN TDVADM.T_FRT_AJUDANTES.FRT_AJUDANTE_MATRICULA%TYPE,
                            P_TIPO IN TDVADM.T_FRT_AJUDANTES.FRT_AJUDANTE_TIPO%TYPE,
                            P_AREA IN TDVADM.T_FRT_AJUDANTES.FRT_AJUDANTES_AREA%TYPE,
                            P_STATUS OUT CHAR,
                            P_MESSAGE OUT VARCHAR2) AS
  /***************************************************************************************************
  * ROTINA           : ALTERAR RQ COCA-COLA                                                          *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Ugo César                                                                     *
  * DESENVOLVEDOR    : Ugo César                                                                     *
  * DATA DE CRIACAO  : 30/01/2013                                                                    *
  * BANCO            : oracle-tdp                                                                    *
  * EXECUTADO POR    : helpdesk                                                                      *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    :                                                                               *
  * ATUALIZA         : T_FRT_AJUDANTES                                                               *
  * PARTICULARIDADES : Usado quando O COMERCIAL SOLICITA A ALTERAÇÃO DE RQ                           *
  * PARAM. OBRIGAT.  : P_MATRICULA ; P_TIPO ; P_AREA                                                 *
  ****************************************************************************************************/
  
  V_NOME TDVADM.T_FRT_AJUDANTES.FRT_AJUDANTES_NOME%TYPE;
  
  BEGIN
    BEGIN
      SELECT A.FRT_AJUDANTES_NOME
        INTO V_NOME
        FROM TDVADM.T_FRT_AJUDANTES A
       WHERE A.FRT_AJUDANTE_MATRICULA = P_MATRICULA;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_STATUS := PKG_GLB_COMMON.Status_Erro;
        P_MESSAGE := 'Ajudante não encontrado. ERRO: ' || SQLERRM;
    END;
    BEGIN
      UPDATE TDVADM.T_FRT_AJUDANTES A
         SET A.FRT_AJUDANTE_TIPO = P_TIPO,
             A.FRT_AJUDANTES_AREA = P_AREA
       WHERE A.FRT_AJUDANTE_MATRICULA = P_MATRICULA;
      P_STATUS := PKG_GLB_COMMON.Status_Nomal;
      P_MESSAGE := 'Ajudante: "' || TRIM(V_NOME) || '" alterado para o tipo: ' || TRIM(P_TIPO) ||
                   ' e para a área: ' || TRIM(P_AREA);
    EXCEPTION
      WHEN OTHERS THEN
        P_STATUS := PKG_GLB_COMMON.Status_Erro;
        P_MESSAGE := 'ERRO: ' || SQLERRM;
    END;
  END SP_RJR_ALTERARQ;
  
  PROCEDURE SP_RJR_RETORNAAREA(P_AREAS OUT T_CURSOR,
                               P_STATUS OUT CHAR,
                               P_MESSAGE OUT VARCHAR2) AS
  /***************************************************************************************************
  * ROTINA           : DIVERSAS APLICAÇÕES ROTINAS COCA-COLA                                         *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Ugo César                                                                     *
  * DESENVOLVEDOR    : Ugo César                                                                     *
  * DATA DE CRIACAO  : 30/01/2013                                                                    *
  * BANCO            : oracle-tdp                                                                    *
  * EXECUTADO POR    : helpdesk                                                                      *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    :                                                                               *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *
  * PARAM. OBRIGAT.  :                                                                               *
  ****************************************************************************************************/
  
    
  BEGIN
    BEGIN
      OPEN P_AREAS FOR
        SELECT A.RJR_AREA_DESCRICAO AREA_DESC,
               A.RJR_AREA_CODIGO AREA_COD
          FROM RJRADM.T_RJR_AREA A;
    EXCEPTION      
      WHEN OTHERS THEN
        P_STATUS := PKG_GLB_COMMON.Status_Erro;
        P_MESSAGE := 'ERRO: ' || SQLERRM;
    END;
  END SP_RJR_RETORNAAREA;
  
  PROCEDURE SP_EXCLUI_NOTA_NOVO(pNOTA in number,
                                pCNPJ in char,
                                pTipo in char, -- A (Arm_Nota) X (Xml_Nota) T (Todas)
                                pSEQUENCIA IN NUMBER,
                                pMessage out varchar2,
                                pStatus out char)
       IS              
    vNrNotaXml  tdvadm.t_xml_nota.xml_nota_numero%type;                    
    vDtNotaXml  tdvadm.t_xml_nota.xml_nota_emissao%type;
    vNotaSq     tdvadm.t_arm_nota.arm_nota_sequencia%type;
    vEmb        tdvadm.t_arm_nota.arm_embalagem_numero%type;
    vEmbSeq     tdvadm.t_arm_nota.arm_embalagem_sequencia%type;
    vEmbFlag    tdvadm.t_arm_nota.arm_embalagem_flag%type;
    vCarg       tdvadm.t_arm_nota.arm_carga_codigo%type;
    vDetalhes   Varchar2(2000);
    vColeta     tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
    vCiclo      tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
  
  Begin

      pStatus := PKG_GLB_COMMON.Status_Nomal;
     
     IF NVL(pTipo,'Q') = 'A' OR NVL(pTipo,'XXX') = 'T' Then
        
        begin
          select ta.arm_embalagem_numero,
                 ta.arm_embalagem_sequencia,
                 ta.arm_embalagem_flag,
                 ta.arm_carga_codigo,
                 ta.arm_nota_sequencia,
                 ta.arm_coleta_ncompra,
                 ta.arm_coleta_ciclo
            into vEmb,
                 vEmbSeq,
                 vEmbFlag,
                 vCarg,
                 vNotaSq,
                 vColeta,
                 vCiclo
            from t_arm_nota ta
            where ta.arm_nota_numero = pNOTA
            and trim(ta.glb_cliente_cgccpfremetente)= trim(pCNPJ)
            AND TA.ARM_NOTA_SEQUENCIA = pSEQUENCIA
            AND ROWNUM <= 1 ;
            
        vDetalhes := dbms_utility.format_error_backtrace || ' - PKG_HD_UTILITARIO.SP_EXCLUI_NOTA - ' || 'Acao=D Nota=' || pNOTA || ' CNPJ='||pCNPJ || ' Sequencia='||vNotaSq;
        
        insert into t_glb_sql(glb_sql_instrucao,glb_sql_programa) 
          values(vDetalhes,'CARGA_DET_20150622');            
        
        delete T_ARM_CARGADET det
        where det.arm_nota_sequencia = vNotaSq;
          
          EXCEPTION
          when NO_DATA_FOUND then
            If pSEQUENCIA is not null Then
               SELECT VIDE.ARM_NOTAVIDE_SEQUENCIA
                 into vNotaSq
                 FROM T_ARM_NOTAVIDE VIDE
                 WHERE VIDE.ARM_NOTAVIDE_NUMERO = pNOTA
                   AND trim(VIDE.ARM_NOTAVIDE_CGCCPFREMETENTE) = trim(pCNPJ)
                   AND VIDE.ARM_NOTA_SEQUENCIA = pSEQUENCIA
                   AND ROWNUM <= 1 ;
            End If;
          
          WHEN OTHERS THEN
            pStatus  := PKG_GLB_COMMON.Status_Erro;
            pMessage := pMessage || CHR(10) || 'ERRO AO DELETAR ' || SQLERRM;
             
          END;
        
        
        BEGIN
          
        delete t_arm_notacte de
        where de.arm_nota_sequencia = vNotaSq;
        
        delete T_ARM_NOTAVIDE de
        where de.arm_notavide_sequencia = vNotaSq;
        
        delete T_ARM_NOTAPESAGEM p
        where p.arm_nota_sequencia = vNotaSq;
        
        delete T_ARM_NOTAPESAGEMITEM pe
        where pe.arm_nota_sequencia = vNotaSq;
        
        delete T_ARM_NOTAVIDE de
        where de.arm_nota_sequencia = vNotaSq;
        
        delete t_arm_notafichaemerg fe
        where fe.arm_nota_numero = pNOTA
          and fe.glb_cliente_cgccpfremetente = TRIM(pCNPJ)
          AND FE.ARM_NOTA_SEQUENCIA = pSEQUENCIA;
          
        delete T_ARM_NOTATPDOC doc
        where doc.arm_nota_numero = pNOTA
          and doc.glb_cliente_cgccpfremetente = TRIM(pCNPJ)
          AND DOC.ARM_NOTA_SEQUENCIA = pSEQUENCIA;
                
        FOR PN IN (SELECT *
                     FROM TDVADM.T_ARM_PRESENCARGANF N
                     WHERE N.arm_nota_sequencia = pSEQUENCIA )
        LOOP               
          DELETE TDVADM.T_ARM_PRESENCARGANFVOL V
          WHERE V.ARM_PRESENCARGANF_ID = PN.ARM_PRESENCARGANF_ID;
        END LOOP;  
        
        DELETE TDVADM.T_ARM_PRESENCARGANF PN
         WHERE PN.ARM_NOTA_SEQUENCIA = pSEQUENCIA;
         
        DELETE TDVADM.T_ARM_NOTAPRIORIZA NP
         WHERE NP.ARM_NOTA_SEQUENCIA = pSEQUENCIA;

       execute immediate 'alter trigger TG_BD_CONFERECARREGDET DISABLE';

        DELETE T_ARM_NOTA N
        WHERE N.ARM_NOTA_NUMERO = pNOTA
          AND N.GLB_CLIENTE_CGCCPFREMETENTE = TRIM(pCNPJ)
          AND N.ARM_NOTA_SEQUENCIA = pSEQUENCIA
          AND ROWNUM <= 1 ;
          
        EXCEPTION
          
          WHEN OTHERS THEN
            pStatus  := PKG_GLB_COMMON.Status_Erro;
            pMessage := pMessage || CHR(10) || 'ERRO AO DELETAR ' || SQLERRM;
             
          END;
     END IF;  
     
     IF pStatus <> PKG_GLB_COMMON.Status_Erro then
         IF NVL(pTipo,'Q') = 'X' OR NVL(pTipo,'XXX') = 'T' Then
            BEGIN
              SELECT DISTINCT N.XML_NOTA_NUMERO,
                       TRUNC (N.XML_NOTA_EMISSAO)
                INTO vNrNotaXml,
                     vDtNotaXml
              FROM T_XML_NOTA N
              WHERE N.XML_NOTA_NF = pNOTA
                AND N.XML_NOTA_SEQUENCIA = pSEQUENCIA
                AND trim(N.GLB_CLIENTE_CGCCPFREMETENTE) = TRIM(pCNPJ);
--                AND N.XML_NOTA_GRAVADO = 'TDV';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 pStatus  := PKG_GLB_COMMON.Status_Erro;
                 pMessage := substr((pMessage || CHR(10) || 'Nota não encontrada no XML'),1,30000);
              WHEN OTHERS THEN 
                 pStatus  := PKG_GLB_COMMON.Status_Erro;
                 pMessage := pMessage || CHR(10) || 'ERRO AO LOCALIZAR NOTA NO XML ' || SQLERRM;
              END;
            IF pStatus <> PKG_GLB_COMMON.Status_Erro then
                BEGIN
                   PKG_XML_NOTA.SP_XML_EXCLUINOTAMONITOR(vNrNotaXml,
                                                         vDtNotaXml,
                                                         TRIM(pCNPJ),
                                                         'jsantos',
                                                         pStatus,
                                                         pMessage);
                EXCEPTION
                  WHEN OTHERS THEN
                    pStatus  := PKG_GLB_COMMON.Status_Erro;
                    pMessage := 'ERRO AO EXCLUIER NOTA NO XML ' || SQLERRM;
                  END;
            END IF;   
         END IF; 
      END IF;    
           IF pStatus <> PKG_GLB_COMMON.Status_Erro then

        pkg_arm_gercoleta.Sp_Set_TrocaOcorrenciaColeta(vColeta,
                                                       vCiclo,
                                                       '',
                                                       pStatus, 
                                                       pMessage);                                                       
      END IF;
      
      --Limpa data e hora de acompanhamento da coleta de nota em armazém.
        
        IF pStatus <> PKG_GLB_COMMON.Status_Erro then
          update tdvadm.t_arm_coletaacompanhamento ac
             set  ac.arm_coletaacompanhamento_dthr = null 
           where  ac.arm_coleta_ncompra = vColeta
             and  ac.arm_coleta_ciclo = vCiclo
             and  ac.arm_coletaevento_id = '3';
             
         --Limpa data de fechamento da coleta para aparecer no gerenciador de coleta.
              update tdvadm.t_arm_coleta ac
             set  ac.arm_coleta_dtfechamento = null 
           where  ac.arm_coleta_ncompra = vColeta
             and  ac.arm_coleta_ciclo = vCiclo;
             
         END IF;
         
         COMMIT;   
         
         execute immediate 'alter trigger TG_BD_CONFERECARREGDET ENABLE';
    
  End SP_EXCLUI_NOTA_NOVO;         
  
  PROCEDURE SP_EXCLUI_NOTA(pNOTA in number,
                           pCNPJ in char,
                           pTipo in char, -- A (Arm_Nota) X (Xml_Nota) T (Todas)
                           pMessage out varchar2,
                           pStatus out char)
       IS              
    vNrNotaXml  tdvadm.t_xml_nota.xml_nota_numero%type;                    
    vDtNotaXml  tdvadm.t_xml_nota.xml_nota_emissao%type;
    vNotaSq     tdvadm.t_arm_nota.arm_nota_sequencia%type;
    vEmb        tdvadm.t_arm_nota.arm_embalagem_numero%type;
    vEmbSeq     tdvadm.t_arm_nota.arm_embalagem_sequencia%type;
    vEmbFlag    tdvadm.t_arm_nota.arm_embalagem_flag%type;
    vCarg       tdvadm.t_arm_nota.arm_carga_codigo%type;
    vDetalhes   Varchar2(2000);
    vChave      tdvadm.t_arm_nota.arm_nota_chavenfe%type;
  Begin

      pStatus := tdvadm.PKG_GLB_COMMON.Status_Erro;
      pStatus := 'Rotina DESATIVADA usar SP_EXCLUI_NOTA_NOVO';
      return;
     IF NVL(pTipo,'Q') = 'A' OR NVL(pTipo,'XXX') = 'T' Then
        
        begin
          select ta.arm_embalagem_numero,
                 ta.arm_embalagem_sequencia,
                 ta.arm_embalagem_flag,
                 ta.arm_carga_codigo,
                 ta.arm_nota_sequencia,
                 ta.arm_nota_chavenfe
            into vEmb,
                 vEmbSeq,
                 vEmbFlag,
                 vCarg,
                 vNotaSq,
                 vChave
            from tdvadm.t_arm_nota ta
            where ta.arm_nota_numero = pNOTA
            and trim(ta.glb_cliente_cgccpfremetente)= trim(pCNPJ)
            AND ROWNUM <= 1 ;
        
        delete tdvadm.T_ARM_CARGADET det
        where det.arm_nota_sequencia = vNotaSq;
          
        vDetalhes := dbms_utility.format_error_backtrace || ' - PKG_HD_UTILITARIO.SP_EXCLUI_NOTA - ' || 'Acao=D Nota=' || pNOTA || ' CNPJ='||pCNPJ || ' Sequencia='||vNotaSq;
        
        insert into t_glb_sql(glb_sql_instrucao,glb_sql_programa) 
          values(vDetalhes,'CARGA_DET_20150622');
        
          EXCEPTION
          when NO_DATA_FOUND then
            
            SELECT VIDE.ARM_NOTAVIDE_SEQUENCIA
              into vNotaSq
              FROM T_ARM_NOTAVIDE VIDE
              WHERE VIDE.ARM_NOTAVIDE_NUMERO = pNOTA
                AND trim(VIDE.ARM_NOTAVIDE_CGCCPFREMETENTE) = trim(pCNPJ)
                AND ROWNUM <= 1 ;
          
          WHEN OTHERS THEN
            pStatus  := PKG_GLB_COMMON.Status_Erro;
            pMessage := pMessage || CHR(10) || 'ERRO AO DELETAR ' || SQLERRM;
             
          END;
        
        
        BEGIN
        
        delete T_ARM_NOTAVIDE de
        where de.arm_nota_sequencia = vNotaSq;
        delete T_ARM_NOTAVIDE de
        where de.arm_notavide_sequencia = vNotaSq;
        
        delete t_arm_notafichaemerg fe
        where fe.arm_nota_numero = pNOTA
          and fe.glb_cliente_cgccpfremetente = TRIM(pCNPJ);
          
        delete T_ARM_NOTATPDOC doc
        where doc.arm_nota_numero = pNOTA
          and doc.glb_cliente_cgccpfremetente = TRIM(pCNPJ);
        
        delete t_arm_notapesagemitem npi
        where npi.arm_nota_chavenfe = vChave;
        
        delete t_arm_notapesagem np
        where np.arm_nota_chavenfe = vChave;
                  
        DELETE T_ARM_NOTA N
        WHERE N.ARM_NOTA_NUMERO = pNOTA
          AND N.GLB_CLIENTE_CGCCPFREMETENTE = TRIM(pCNPJ)
          AND ROWNUM <= 1 ;
        EXCEPTION
          WHEN OTHERS THEN
            pStatus  := PKG_GLB_COMMON.Status_Erro;
            pMessage := pMessage || CHR(10) || 'ERRO AO DELETAR ' || SQLERRM;
             
          END;
     END IF;  
     
     IF pStatus <> PKG_GLB_COMMON.Status_Erro then
         IF NVL(pTipo,'Q') = 'X' OR NVL(pTipo,'XXX') = 'T' Then
            BEGIN
              SELECT DISTINCT N.XML_NOTA_NUMERO,
                       TRUNC (N.XML_NOTA_EMISSAO)
                INTO vNrNotaXml,
                     vDtNotaXml
              FROM T_XML_NOTA N
              WHERE N.XML_NOTA_NF = pNOTA
                AND trim(N.GLB_CLIENTE_CGCCPFREMETENTE) = TRIM(pCNPJ);
--                AND N.XML_NOTA_GRAVADO = 'TDV';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 pStatus  := PKG_GLB_COMMON.Status_Erro;
                 pMessage := substr((pMessage || CHR(10) || 'Nota não encontrada no XML'),1,30000);
              WHEN OTHERS THEN 
                 pStatus  := PKG_GLB_COMMON.Status_Erro;
                 pMessage := pMessage || CHR(10) || 'ERRO AO LOCALIZAR NOTA NO XML ' || SQLERRM;
              END;
            IF pStatus <> PKG_GLB_COMMON.Status_Erro then
                BEGIN
                   PKG_XML_NOTA.SP_XML_EXCLUINOTAMONITOR(vNrNotaXml,
                                                         vDtNotaXml,
                                                         TRIM(pCNPJ),
                                                         'jsantos',
                                                         pStatus,
                                                         pMessage);
                EXCEPTION
                  WHEN OTHERS THEN
                    pStatus  := PKG_GLB_COMMON.Status_Erro;
                    pMessage := 'ERRO AO EXCLUIER NOTA NO XML ' || SQLERRM;
                  END;
            END IF;   
         END IF; 
      END IF;    
      IF pStatus <> PKG_GLB_COMMON.Status_Erro then
         COMMIT;
      END IF;   
    
  End SP_EXCLUI_NOTA;                       

PROCEDURE SP_RJR_PREVIAAGREGADO(P_PDATADOC IN CHAR, -- Maior Data de Documento 
                                P_AREA     IN CHAR, -- Area a ser processado separado por ; ponto e virgula
                                P_PREVIA   OUT T_CURSOR,
                                P_STATUS   OUT CHAR,
                                P_MESSAGE  OUT VARCHAR2) AS
  /***************************************************************************************************
  * ROTINA           : DIVERSAS APLICAÇÕES ROTINAS COCA-COLA                                         *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Sirlano Drumond                                                                   *
  * DESENVOLVEDOR    : Sirlano Drumond                                                                     *
  * DATA DE CRIACAO  : 30/01/2013                                                                    *
  * BANCO            : oracle-tdp                                                                    *
  * EXECUTADO POR    : helpdesk                                                                      *
  * ALIMENTA         :                                                                               *
  * FUNCINALIDADE    :                                                                               *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *
  * PARAM. OBRIGAT.  :                                                                               *
  ****************************************************************************************************/
  
    
  BEGIN
    BEGIN
      OPEN P_PREVIA FOR
        SELECT P.RJR_DOCUMENTO_DATA  DATA,
               P.RJR_DOCUMENTO_NUMERODOC ROMANEIO,
               P.RJR_VEICULO_CODIGOCLIENTE ITEM,
               P.RJR_AREA_CODIGO AREA,
               P.VALOR ,
               P.VENCIMENTO 
          FROM RJRADM.V_RJR_IMPORTAROMANEIOSMOVOCORR P
         WHERE P.RJR_DOCUMENTO_DATA <= P_PDATADOC
           AND instr(upper(trim(P_AREA)),upper(trim(P.RJR_AREA_CODIGO))) > 0;    
   EXCEPTION      
      WHEN OTHERS THEN
        P_STATUS := PKG_GLB_COMMON.Status_Erro;
        P_MESSAGE := 'ERRO: ' || SQLERRM;
    END;
  END SP_RJR_PREVIAAGREGADO;
  
  
  --Função que chama a procedure do pkg_fifo: tdvadm.pkg_fifo.sp_RetornaCarrgamento
  Procedure SP_RETORNACARREGAMENTO(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type, --Código do carregamento
                                         pStatus    out char,
                                         pMessage   out Varchar2) as
                                         
                                         
                                  
     begin
              tdvadm.pkg_fifo.sp_RetornaCarrgamento(pCodCarreg,pStatus,pMessage);
              delete tdvadm.t_arm_notacte c
              where c.arm_carregamento_codigo = pCodCarreg;
                                             
     end;

     
  Procedure sp_cax_trocacaixafeletronico(pDocumento in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                         pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                         pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                         pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%type,
                                         pNovaRota  in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                         pData      in date,
                                         pStatus out char,
                                         pMessage out varchar2,
                                         pCursor  out T_cursor
                                         ) as     
                                        
begin                                         
                                         
  pkg_ctb_caixa.sp_cax_trocacaixafeletronico(pdocumento,
                                             pserie,
                                             prota,
                                             psaque,
                                             pnovarota,
                                             pdata,
                                             pstatus,
                                             pMessage,
                                             pCursor); 
                                             
                                               
                                              
                                             
                                             
END sp_cax_trocacaixafeletronico;


  Procedure sp_cax_trocacaixafeletronico2(pDocumento in tdvadm.t_con_valefrete.con_conhecimento_codigo%type,
                                         pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%type,
                                         pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                         pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%type,
                                         pNovaRota  in tdvadm.t_con_valefrete.glb_rota_codigo%type,
                                         pData      in date,
                                         pStatus out char,
                                         pMessage out varchar2
                                         ) as     
vCursor pkg_glb_common.T_CURSOR;
                                        
begin                                         
                                         
  pkg_ctb_caixa.sp_cax_trocacaixafeletronico(pdocumento,
                                             pserie,
                                             prota,
                                             psaque,
                                             pnovarota,
                                             pdata,
                                             pstatus,
                                             pMessage,
                                             vCursor); 
                                             
                                               
                                              
                                             
                                             
END sp_cax_trocacaixafeletronico2;


--Esta procedure é executada apenas quando a ocorrência da coleta é 54, as demais são retiradas
--pelo KPI.
procedure sp_arm_setalteraocorrencia(p_coletanumero in t_arm_coleta.arm_coleta_ncompra%type,
                                      p_coletaciclo in t_arm_coleta.arm_coleta_ciclo%type,
                                      p_coletaocorrencia in t_arm_coleta.arm_coletaocor_codigo%type,
                                      p_status out char,
                                      p_message out varchar2) as
vdate date;
vCount number;
V_TEXTO varchar2(2000);
begin

      begin
        
            select count(*)
              into vCount
              from t_arm_Coleta ta
             where trim(ta.arm_coleta_ncompra) = trim(p_coletanumero)
               and trim(ta.arm_coleta_ciclo) = trim(p_coletaciclo)
               and ta.arm_coletaocor_codigo in ('54','55');
         
         IF(vCount <> 1) then
            p_status := 'E';
            p_message := 'NÃO ENCONTREI NENHUMA COLETA COM A OCORRENCIA 54 e/ou 55. Erro: ' || Sqlerrm;
         end if;

       IF (vCount = 1) THEN
        
        V_TEXTO := 'ALTER TRIGGER TG_BU_ARM_COLETAOCOR DISABLE';
        EXECUTE IMMEDIATE (V_TEXTO);
        
        
        
         update t_arm_coleta n
            set n.arm_coletaocor_codigo = p_coletaocorrencia
          where n.arm_coleta_ncompra = p_coletanumero
            and n.arm_coleta_ciclo = p_coletaciclo;
            commit;
            
            
          V_TEXTO := 'ALTER TRIGGER TG_BU_ARM_COLETAOCOR ENABLE';
          EXECUTE IMMEDIATE (V_TEXTO);      


            p_status:= 'N';
            p_message := 'Processamento normal';

        END IF;


      EXCEPTION
        when others then
         vdate := to_date('25/11/2013','dd/mm/YYYY');
         p_status := 'E';
         p_message := 'Erro ao executar sp_arm_setalteraocorrencia. Erro: '|| Sqlerrm;
      end;
end sp_arm_setalteraocorrencia;

Procedure sp_arm_setaRPS(p_conhec in T_CON_CONHECRPSNFE.CON_CONHECIMENTO_CODIGO%type,--conhec dellavolpe
                         p_conhecRota in T_CON_CONHECRPSNFE.GLB_ROTA_CODIGO%type,--rota TDV
                         p_conhecRPS in T_CON_CONHECRPSNFE.con_conhecrpsnfe_nfecodigo%type -- conhecPrefeitura
                         ) as
                                     
vCount number;
   begin
       begin
           select count(*)
           into vCount
           from T_CON_CONHECRPSNFE nf
           where nf.con_conhecimento_codigo=p_conhec
           and nf.glb_rota_codigo=p_conhecRota;
       
               if(vCount>0) then
           
                      update T_CON_CONHECRPSNFE n
                       set n.con_conhecrpsnfe_nfecodigo = p_conhecRPS
                       where n.con_conhecimento_codigo=p_conhec
                       and n.glb_rota_codigo=p_conhecRota;
                       commit;
                           
                      
            
                 else 
                       
                       INSERT INTO T_CON_CONHECRPSNFE n
                        (n.con_conhecimento_codigo,
                         n.con_conhecimento_serie,
                         n.glb_rota_codigo,
                         n.con_conhecrpsnfe_nfecodigo)                                        
                         Values
                               (p_conhec,
                                p_conhecRota, 
                                'A1',  
                                 p_conhecRPS);
                       
                       
                           
                    
              end if;
          end;
    end sp_arm_setaRPS;  
             
            
  Procedure SP_REPROCESSAQUIMICOSR(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type) --Código do carregamento
     as
     vStatus char;
     vMessage varchar2(1000);    
  Begin
     SP_REPROCESSAQUIMICO(pCodCarreg,
                          vStatus,
                          vMessage);
    
  End SP_REPROCESSAQUIMICOSR ;
    
  Procedure SP_REPROCESSAQUIMICO(pCodCarreg in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type, --Código do carregamento
                                 pStatus    out char,
                                 pMessage   out Varchar2) as
                                         
   vChaveQuimica varchar2(30);
   vChavetab number;
   vAssunto rmadm.t_glb_benasserec.glb_benasserec_assunto%type;
     begin


        begin
            select (Trim(tdvadm.fn_querystring(r.GLB_BENASSEREC_ASSUNTO,'ChaveQuimica','=',';'))) ChaveQuimica ,
                   r.glb_benasserec_chave ChaveTab,
                   r.GLB_BENASSEREC_ASSUNTO
                   into vChaveQuimica,
                        vChavetab,
                        vAssunto
            from rmadm.t_glb_benasserec r
            where (Trim(tdvadm.fn_querystring(r.GLB_BENASSEREC_ASSUNTO,'Msg','=',';'))) = 'PrdQuimico'
              and r.GLB_BENASSEREC_ASSUNTO like '%' || pCodCarreg || '%'
              and r.glb_benasserec_chave = (select max(r1.glb_benasserec_chave)
                                            from rmadm.t_glb_benasserec r1  
                                            where Trim(tdvadm.fn_querystring(r1.GLB_BENASSEREC_ASSUNTO,'Msg','=',';')) = 'PrdQuimico'
                                              and r1.GLB_BENASSEREC_ASSUNTO like '%' || pCodCarreg || '%');

            update t_arm_notafichaemerg fe
              set fe.arm_notafichaemerg_codcli = vChaveQuimica,
                  fe.glb_onuclascli_codigo = '00'                 
            where fe.arm_nota_sequencia in (select n.arm_nota_sequencia
                                            from t_arm_nota n
                                            where n.arm_carregamento_codigo = pCodCarreg);

            update rmadm.t_glb_benasserec r
              set r.glb_benasserec_status = 'IN',
                  r.glb_benasserec_processado = null
            where r.glb_benasserec_chave = vChavetab;
            pStatus := pkg_glb_common.Status_Nomal;
            pMessage := 'ReProcessamento Ativado.' || chr(10) ;
        exception
          when OTHERS Then
            pStatus := pkg_glb_common.Status_Erro;
            pMessage := 'Verifique o Erro ' || sqlerrm  || chr(10) ;
          End;               
          
          pMessage := pMessage || vAssunto;
                            
   end SP_REPROCESSAQUIMICO;
   
   
   
   
Procedure sp_reenviarps        (pBenasse in Varchar2,
                                pStatus  out char,
                                pMessage out Varchar2
                                ) as
                                
/***************************************************************************************************
      * ROTINA           : REENVIA RPS                  *
      * PROGRAMA         :                                                                               *
      * ANALISTA         : Lucas Tarcha                                                                  *
      * DESENVOLVEDOR    : Lucas Tarcha                                                                     *
      * DATA DE CRIACAO  : 07/04/2014                                                      *
      * BANCO            : oracle-tdp                                                                    *
      * EXECUTADO POR    : helpdesk                                                                      *
      * ALIMENTA         :                                                                               *
      * FUNCINALIDADE    : permitir que o usuario pelo aut-e reenvie as RPS.                                                                               *
      * ATUALIZA         :                                                                               *
      * PARTICULARIDADES :                                                                               *
      * PARAM. OBRIGAT.  :                                                                               *
****************************************************************************************************/    

vTipo   char(1);
vCount  integer;
vRps    tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
vSerie  tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
vRota   tdvadm.t_con_conhecimento.glb_rota_codigo%type;                                
      
      
begin
  
   vRps     := LPAD((UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'RPS','=',';')))),6,'0'); 
   vSerie   := UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'SERIE','=',';')));
   vRota    := UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'ROTA','=',';')));
           
           
    begin
            select lo.slf_tpcalculo_formulario
              into vTipo
            from t_con_calcconhecimento tt,
                 t_slf_tpcalculo lo
            where tt.con_conhecimento_codigo = lpad(trim(vRps),6,'0')
            and tt.con_conhecimento_serie    = trim(vSerie)
            and tt.glb_rota_codigo           = trim(vRota)
            and tt.slf_reccust_codigo='I_TTPV'
            and tt.slf_tpcalculo_codigo=lo.slf_tpcalculo_codigo
            and lo.slf_tpcalculo_calculomae='S';
     exception
            when NO_DATA_FOUND then
               pStatus := pkg_glb_common.Status_Erro;
               pMessage := 'Falha ao localizar conhecimento' || sqlerrm;
                  
     end;
    
                  
      if upper(vTipo) = 'C' then
        pStatus := pkg_glb_common.Status_Erro;
        pMessage := 'A Rps está com imposto de conhecimento! ' || sqlerrm;
      else
         if vRota = '028' then
           --Verifica existencia do doc. na rota 028
           select count(*)
           into vCount
           from t_con_conhecimento tt
           where tt.con_conhecimento_codigo = lpad(trim(vRps),6,'0')
           and tt.con_conhecimento_serie    = trim(vSerie)
           and tt.glb_rota_codigo           = trim(vRota);
               
               
           if vCount > 0 then 
           --retira dtnfe para que seja reenviada.
             update t_con_conhecimento tt
             set tt.con_conhecimento_dtnfe = ''
             where tt.con_conhecimento_codigo = lpad(trim(vRps),6,'0')
             and tt.con_conhecimento_serie    = trim(vSerie)
             and tt.glb_rota_codigo           = trim(vRota);
             commit;
                 
              pStatus := pkg_glb_common.Status_Nomal;
              pMessage := 'Rps Reenviada!';
           else
             pStatus := pkg_glb_common.Status_Erro;
             pMessage := 'Numero de RPS não consta na T_con_conhecimento, Verifique o servidor 240';
           end if;    
               
              
               
         else
               
             select count(*)
             into vCount
             from wservice.t_wsd_xmlnfse se
             where se.con_conhecimento_codigo = lpad(trim(vRps),6,'0')
             and   se.con_conhecimento_serie  = trim(vSerie)
             and   se.glb_rota_codigo         = trim(vRota);
                 
             if vCount > 0 then
               delete from wservice.t_wsd_xmlnfse se
               where se.con_conhecimento_codigo = lpad(trim(vRps),6,'0')
               and   se.con_conhecimento_serie  = trim(vSerie)
               and   se.glb_rota_codigo         = trim(vRota);
               commit;
                   
               pStatus := pkg_glb_common.Status_Nomal;
               pMessage := 'Rps Reenviada!';
                 
             else
               pStatus := pkg_glb_common.Status_Erro;
               pMessage := 'Numero de RPS não consta na wservice.t_wsd_xmlnfse verifique o serviço no servidor 100';
             end if;
               
              
               
         end if; 
      end if;
 
END sp_reenviarps;
  
  
Procedure SP_HD_HABOBS     (pBenasse in rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                            pStatus  out char,
                            pMessage out Varchar2
                                ) as
                                
/***************************************************************************************************
      * ROTINA           : REENVIA RPS                  *
      * PROGRAMA         :                                                                               *
      * ANALISTA         : Lucas Tarcha                                                                  *
      * DESENVOLVEDOR    : Lucas Tarcha                                                                     *
      * DATA DE CRIACAO  : 24/07/2014                                                                    *
      * BANCO            : oracle-tdp                                                                    *
      * EXECUTADO POR    : helpdesk                                                                      *
      * ALIMENTA         :                                                                               *
      * FUNCINALIDADE    :                                                                               *
      * ATUALIZA         :                                                                               *
      * PARTICULARIDADES :                                                                               *
      * PARAM. OBRIGAT.  :                                                                               *
****************************************************************************************************/    
vNumDoc char(8);
vSq     char(4);
vTpDoc  char(1);
vAuxiliar integer;
vHab    char(1);

        begin
          
           vNumDoc := LPAD((UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'NUMDOC','=',';')))),8,'0'); 
           vSq     := LPAD((UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'SAQUE','=',';')))),4,'0');
           vTpDoc  := (UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'TPDOC','=',';'))));
           vHab    := (UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'HAB','=',';'))));
           
           
             BEGIN
               
               IF(vTpDoc = 'T') then
                  update t_slf_tabela la
                  set la.slf_tabela_imprimeobsctrc = vHab
                  where la.slf_tabela_codigo = vNumDoc
                  and la.slf_tabela_saque = vSq;
                  vAuxiliar := sql%rowcount;
               elsif(vTpDoc = 'S') then
                 
                  update t_slf_solfrete te
                  set te.slf_solfrete_imprimeobsctrc = vHab
                  where te.slf_solfrete_codigo = vNumDoc
                  and te.slf_solfrete_saque = vSq;
                  vAuxiliar := sql%rowcount;
                  
               else 
                  pStatus := pkg_glb_common.Status_Erro;
                  pMessage := 'ASSUNTO SEM TIPO DE DOCUMENTO!';
                  
               end if;
               
               if(vAuxiliar > 0) then
                 pStatus := pkg_glb_common.Status_Nomal;
                 pMessage := 'N';
                 commit;
               else
                 pStatus := pkg_glb_common.Status_Erro;
                 pMessage := 'ERRO AO HABILITAR SOL/TAB';
                 rollback; 
               end if;
              
            /*exception 
              when others then
                 pStatus := pkg_glb_common.Status_Erro;
                 pMessage := 'ERRO AO HABILITAR SOL/TAB';*/
                  
            end;  

       end SP_HD_HABOBS;
       
Procedure SP_HD_ALTCABRITO (pBenasse in rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                            pStatus  out char,
                            pMessage out Varchar2
                                ) as
                                
/***************************************************************************************************
      * ROTINA           : REENVIA RPS                  *
      * PROGRAMA         :                                                                               *
      * ANALISTA         : Lucas Tarcha                                                                  *
      * DESENVOLVEDOR    : Lucas Tarcha                                                                     *
      * DATA DE CRIACAO  : 24/07/2014                                                                    *
      * BANCO            : oracle-tdp                                                                    *
      * EXECUTADO POR    : helpdesk                                                                      *
      * ALIMENTA         :                                                                               *
      * FUNCINALIDADE    :                                                                               *
      * ATUALIZA         :                                                                               *
      * PARTICULARIDADES :                                                                               *
      * PARAM. OBRIGAT.  :                                                                               *
****************************************************************************************************/

vMatricula   char(8);
vTipoCabrito char(1);
vAuxiliar    integer;

      begin
          
          vMatricula   := (UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'MATRICULA','=',';'))));
          vTipoCabrito := (UPPER(Trim(tdvadm.fn_querystring(upper(pBenasse),'TPCABRITO','=',';'))));
          
          BEGIN 
            
            SELECT count(*)
            into vAuxiliar
            FROM t_frt_ajudantes  aj
            where aj.frt_ajudante_matricula = vMatricula;
            
            if(vAuxiliar = 0) or (vTipoCabrito not in ('N','C')) then
                pStatus := pkg_glb_common.Status_Erro;
                pMessage := 'VERIFIQUE A MATRICULA E O TIPO DE CABRITO';
                return;
            end if;
            
          
          
            UPDATE t_frt_ajudantes  aj
            SET AJ.FRT_AJUDANTE_TIPOESP = vTipoCabrito
            where aj.frt_ajudante_matricula = vMatricula;
            vAuxiliar := sql%rowcount;
            
            if(vAuxiliar > 0) then
                 pStatus := pkg_glb_common.Status_Nomal;
                 pMessage := 'N';
                 commit;
               else
                 pStatus := pkg_glb_common.Status_Erro;
                 pMessage := 'ERRO AO ALTERAR CABRITO';
                 rollback; 
               end if;
            
             END;

         

       end SP_HD_ALTCABRITO;

PROCEDURE SP_RJR_CADTARIFA  (P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                             P_STATUS OUT CHAR,                                           
                             P_MESSAGE OUT VARCHAR2)AS
  
  /***************************************************************************************************
  * ROTINA           : Cadastro de Tarifas da Coca                                                   *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Lucas/Felipe                                                                     *
  * DESENVOLVEDOR    : Lucas/Felipe
  * DATA DE CRIACAO  : 08/10/2014                                                                    *
  * BANCO            : oracle-tdp                                                                    *
  * EXECUTADO POR    : helpdesk                                                                      *
  * ALIMENTA         : T_RJF_CARGAS                                                                  *
  * FUNCINALIDADE    :                                                                               *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES : Usado quando a Cris faz a leitura do RTT e é acusada tarifa não cadastrada    *
  * PARAM. OBRIGAT.  : P_Benasse                                                                     *
  ****************************************************************************************************/
    
    V_AREA        rjradm.t_rjr_area.rjr_area_codigo%type;
    V_TARIFA      tdvadm.t_rjf_tabelaagregados.rjf_tabelaagregados_tarifa%type;
    V_VALOR       tdvadm.t_rjf_tabelaagregados.rjf_tabelaagregados_vlragr%type;
    V_VIGENCIA    tdvadm.T_RJF_CARGAS.rjf_cargas_vigencia%type;
    V_CARGA       varchar2(20);
    V_PARAMVALID NUMBER;
    V_TPCARGA CHAR(1);
    
    /*MSG=CADTARIFA;AREA=C;TARIFA=ROTA NORMAL;VALOR=507,14;VIGENCIA=25/09/2014;CARGA=DPA9;*/
    
  BEGIN
    
    V_AREA     := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'AREA','=',';'))));
    V_TARIFA   := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'TARIFA','=',';'))));
    V_VALOR    := TO_NUMBER(replace(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'VALOR','=',';')),',','.'));
    V_VIGENCIA := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'VIGENCIA','=',';'))));
    V_CARGA    := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'CARGA','=',';'))));
    
    SELECT COUNT(*)
      INTO V_PARAMVALID
      FROM RJRADM.T_RJR_AREA A
     WHERE trim(A.RJR_AREA_CODIGO) = trim(V_AREA);
    IF V_PARAMVALID > 0 THEN
      SELECT COUNT(*)
        INTO V_PARAMVALID
        FROM T_RJF_TABELAAGREGADOS TA
       WHERE trim(TA.RJF_CARGAS_AREA) = trim(V_AREA)
         AND trim(TA.RJF_TABELAAGREGADOS_TARIFA) = trim(V_TARIFA)
         AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                  FROM T_RJF_TABELAAGREGADOS TA1
                                                 WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                   AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                   AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA);
      IF V_PARAMVALID > 0 THEN
        SELECT COUNT(*)
          INTO V_PARAMVALID
          FROM T_RJF_TABELAAGREGADOS TA
         WHERE trim(TA.RJF_CARGAS_AREA) = trim(V_AREA)           
           AND trim(TA.RJF_TABELAAGREGADOS_TARIFA) = trim(V_TARIFA)
           AND trim(TA.RJF_TABELAAGREGADOS_VLRAGR) = trim(V_VALOR)
           AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                    FROM T_RJF_TABELAAGREGADOS TA1
                                                   WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                     AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                     AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA);
        IF V_PARAMVALID > 0 THEN
          SELECT DISTINCT TA.RJF_TIPOCARGAS_CODIGO
            INTO V_TPCARGA
            FROM T_RJF_TABELAAGREGADOS TA
           WHERE trim(TA.RJF_CARGAS_AREA) = trim(V_AREA)           
             AND trim(TA.RJF_TABELAAGREGADOS_TARIFA) = trim(V_TARIFA)
             AND trim(TA.RJF_TABELAAGREGADOS_VLRAGR) = trim(V_VALOR)
             AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                      FROM T_RJF_TABELAAGREGADOS TA1
                                                     WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                       AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                       AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA);
          BEGIN
            INSERT INTO T_RJF_CARGAS(RJF_CARGAS_CODIGO,
                                     RJF_CARGAS_AREA,
                                     RJF_TIPOCARGAS_CODIGO,
                                     RJF_CARGAS_VIGENCIA )
                              VALUES(trim(V_CARGA),
                                     trim(V_AREA),
                                     trim(V_TPCARGA),
                                     trim(V_VIGENCIA));
            COMMIT;
            P_STATUS := PKG_GLB_COMMON.Status_Nomal;
            P_MESSAGE := 'TARIFA CADASTRADA COM SUCESSO!';
          EXCEPTION
            WHEN OTHERS THEN
              P_STATUS := PKG_GLB_COMMON.Status_Erro;
              P_MESSAGE := 'ERRO AO CADASTRAR TARIFA! erro: ' || sqlerrm;
          END;
        ELSE
          
                       
          --CURSOR P_VALORES IS ();
                                                                                   
          P_STATUS := PKG_GLB_COMMON.Status_Erro;
          P_MESSAGE := 'VERIFIQUE O VALOR PASSADO! ' ||
                       ' AREA: ' || V_AREA ||
                       ' TARIFA: ' || V_TARIFA || 
                       ' VALOR PASSADO: ' || V_VALOR ||
                       ' VALORES CADASTRADOS NO SISTEMA: ';
          
          FOR VALORES IN  (SELECT TA.RJF_CARGAS_AREA AREA,
                                     TA.RJF_TABELAAGREGADOS_TARIFA TARIFA,
                                     TA.RJF_TABELAAGREGADOS_VLRAGR VALOR
                              FROM T_RJF_TABELAAGREGADOS TA
                             WHERE TA.RJF_CARGAS_AREA = V_AREA           
                               AND TA.RJF_TABELAAGREGADOS_TARIFA = V_TARIFA
                               AND TA.RJF_TABELAAGREGADOS_VIGENCIA = (SELECT MAX(TA1.RJF_TABELAAGREGADOS_VIGENCIA)
                                                                        FROM T_RJF_TABELAAGREGADOS TA1
                                                                       WHERE TA1.RJF_CARGAS_AREA = TA.RJF_CARGAS_AREA
                                                                         AND TA1.RJF_TIPOCARGAS_CODIGO = TA.RJF_TIPOCARGAS_CODIGO
                                                                         AND TA1.RJF_TABELAAGREGADOS_TARIFA = TA.RJF_TABELAAGREGADOS_TARIFA) )
         LOOP
          
              
              P_MESSAGE := P_MESSAGE || ' ' || VALORES.VALOR || ';' ;
              
          END LOOP;  
           
          
                                                                                     
        END IF;
      ELSE
        P_STATUS := PKG_GLB_COMMON.Status_Erro;
        P_MESSAGE := 'VERIFIQUE A TARIFA ! ' ||
                       ' AREA: ' || V_AREA ||
                       ' TARIFA ' || V_TARIFA || 
                       ' VALOR: ' || V_VALOR;
      END IF;
    ELSE
      P_STATUS := PKG_GLB_COMMON.Status_Erro;
      P_MESSAGE := 'VERIFIQUE A AREA PASSADA ! ' || 
                       ' AREA: ' || V_AREA ||
                       ' TARIFA ' || V_TARIFA || 
                       ' VALOR: ' || V_VALOR;
    END IF;
  END SP_RJR_CADTARIFA;

PROCEDURE SP_INT_UpdateMacAddress (P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                                   P_STATUS OUT CHAR,                                           
                                   P_MESSAGE OUT VARCHAR2)AS
                                   
	/****************************************************************************************************
  * ROTINA           : Cadastro de Tarifas da Coca                                                   *
  * PROGRAMA         :                                                                               *
  * ANALISTA         : Lucas/Felipe                                                                  *
  * DESENVOLVEDOR    : Lucas/Felipe                                                                  *
  * DATA DE CRIACAO  : 14/11/2014                                                                    *
  * BANCO            : oracle-tdp                                                                    *
  * EXECUTADO POR    : helpdesk                                                                      *
  * ALIMENTA         : T_INT_MAQUINAS                                                                *
  * FUNCINALIDADE    : alimentar a coluna de mc address                                              *
  * ATUALIZA         :                                                                               *
  * PARTICULARIDADES :                                                                               *
  * PARAM. OBRIGAT.  : P_Benasse                                                                     *
 ****************************************************************************************************/
    vMaquina varchar2(150);
    vMcAddress varchar2(150);
    vAux integer;
 begin   
    vMaquina   := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'HOSTNAME','=',';'))));   
    vMcAddress := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'MCADDRESS','=',';'))));
    
    begin
       
       select count(*)
       into vAux
       from t_int_maquinas maq
       where trim(maq.int_maquinas_codigo) = vMaquina;
       
       if(vAux > 0 and nvl(vMcAddress,'N') <> 'N')then
           
           update t_int_maquinas maq
           set maq.int_maquinas_macaddress = vMcAddress
           where maq.int_maquinas_codigo   = vMaquina;
           
           P_STATUS := PKG_GLB_COMMON.Status_Nomal;
           P_MESSAGE := 'MCADDRESS CADASTRADO COM SUCESSO!';
           
           commit;
           RETURN;
       elsif(vAux = 0 )then
           
           insert into t_int_maquinas (int_maquinas_codigo , int_maquinas_descricao, int_maquinas_macaddress) values (vMaquina , 'MAQUINA ANTES NÃO CADASTRADA', vMcAddress);
           COMMIT;
           P_STATUS := PKG_GLB_COMMON.Status_Nomal;
           P_MESSAGE := 'MCADDRESS/MAQUINA CADASTRADO COM SUCESSO!';
           RETURN;
           
       end if;
 exception when others then
   P_STATUS  := PKG_GLB_COMMON.Status_Erro;
   P_MESSAGE := 'ERRO AO CADASTRAR';
 end;
end SP_INT_UpdateMacAddress;

PROCEDURE SP_GET_IDJOBNDD (P_CODIGO  IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE,
                           P_SERIE   IN TDVADM.T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                           P_ROTA    IN TDVADM.T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                           P_TIPO    IN CHAR,
                           P_ID      OUT INTEGER, 
                           P_STATUS  OUT CHAR,                                           
                           P_MESSAGE OUT VARCHAR2) AS
      
    vID INTEGER;
                                                  
BEGIN
  
    BEGIN 
      
      IF (TRIM(P_TIPO) = 'C') THEN
        
        SELECT JB.ID
          INTO vID
          FROM NDD_NEW.TBNDDJOB JB,
               TDVADM.T_CON_CONHECIMENTO CO
         WHERE CO.CON_CONHECIMENTO_CODIGO = P_CODIGO
           AND CO.CON_CONHECIMENTO_SERIE  = P_SERIE
           AND CO.GLB_ROTA_CODIGO         = P_ROTA
           AND TRIM(JB.JOBNAME)           = REPLACE(REPLACE(REPLACE(PKG_CON_CTE.FN_GET_LOCALIMP(CO.CON_CONHECIMENTO_CODIGO, CO.CON_CONHECIMENTO_SERIE, CO.GLB_ROTA_CODIGO),'E:\ENTRADA\',''),'\',''),'_1_','_');
           
           P_STATUS  := 'OK';
       ELSIF (TRIM(P_TIPO) = 'M') THEN
       
        SELECT JB.ID
          INTO vID
          FROM T_CON_MANIFESTO MD,     
               NDD_NEW.TBNDDJOB JB                                
         WHERE MD.CON_MANIFESTO_CODIGO      = P_CODIGO                    
           AND TRIM(MD.CON_MANIFESTO_SERIE) = P_SERIE
           AND TRIM(MD.CON_MANIFESTO_ROTA)  = P_ROTA
           AND TRIM(JB.JOBNAME)        = REPLACE(REPLACE(REPLACE(PKG_CON_MDFE.fn_Con_MdfeRetPastaProces(P_CODIGO,P_SERIE,P_ROTA),'M:\PRODUCAO\ENTRADA\',''),'\',''),'_','_MDFE_');
       
           P_STATUS  := 'OK';
        ELSE
          P_STATUS  := PKG_GLB_COMMON.Status_Erro;
          P_MESSAGE := 'FAVOR DEFINIR O TIPO M - MANIFESTO C - CONHECIMCENTO';      
       END IF;
       
       P_ID := nvl(vID,0);
     
  EXCEPTION WHEN OTHERS THEN 
     P_STATUS  := PKG_GLB_COMMON.Status_Erro;
     P_MESSAGE := 'ERRO AO BUSCAR ID ' || REPLACE(REPLACE(REPLACE(PKG_CON_MDFE.fn_Con_MdfeRetPastaProces(P_CODIGO,P_SERIE,P_ROTA),'M:\PRODUCAO\ENTRADA\',''),'\',''),'_','_MDFE_');
     --raise_application_error(-20001,sqlcode || '-' || sqlerrm);
  END;
          
END SP_GET_IDJOBNDD;

PROCEDURE   sp_limpa_campo(p_armazem     char,
                           p_Data date,
                           P_MESSAGE OUT VARCHAR2 ) as

  
  
  CURSOR c_coleta is 
    select col.*
    from t_arm_coleta col,
         t_arm_coletancompra mer
    where col.arm_coleta_ncompra     = mer.arm_coletancompra
    and col.arm_coleta_ciclo         = mer.arm_coleta_ciclo
    and col.arm_coleta_dtprogramacao = p_Data
    and col.arm_armazem_codigo       = p_armazem;  
  
  v_stringcaracteres1 varchar2(200);
  v_stringcaracteres2 varchar2(100);
  v_string            varchar2(20000);
  x                   integer;
  v_posicao           integer;
  v_caracter          char(1);
begin
  
     -- v_stringcaracteres1 := 'qwertyuiopsdfghjklçzxcvbnm1234567890-¤Æ¿!¿»þ¿¿º¿´µ()/³_".<>;*$#@%\|{}±Ã[]áéóúâôêãõÓ:ÕÉÌÍÁÀÜÚÔÊÂ®´½¾²¨?¿Ø·°º¥ ª¼§£¿¿©¡&' || ''''||chr(10)||chr(13)||chr(10);
     -- v_stringcaracteres2 := '                           e        aeoaeouaoO OEIIAAUUOEAOBS                                 ';
      v_string            := '';
      X                   := 1;
      for coleta in c_coleta loop
        
          WHILE X < (LENGTH(coleta.arm_coleta_obs) + 1) LOOP
              v_caracter := substr(coleta.arm_coleta_obs, x, 1);
           --   v_posicao  := instr(lower(v_stringcaracteres1), lower(v_caracter));
              
              if ASCII(v_caracter) > 127 /*and ASCII(v_caracter) not in (128,130,131,134,135,146,147,148,153,161,162,163,164,165,167,168,169,170,174,176,177,178,179,180,181,183,186,187,188,189,190,191,192,193,194,195,198,201,202,204,205,211,212,213,216,218,220,225,226,227,233,234,243,244,245,250,254)*/ then
                P_MESSAGE := P_MESSAGE || '     ' || substr(coleta.arm_coleta_ncompra,0,6) || '    ' || v_caracter;
                P_MESSAGE := substr(P_MESSAGE,0,3000);
              end if;
              x := x + 1;

          END LOOP;
          x := 0;
      end loop;

end sp_limpa_campo;

function fn_GET_IDJOBNDD( P_DOCUMENTO IN NDD_NEW.TBLOGDOCUMENT.DOCUMENTNUMBER%type,
                          P_SERIE IN NDD_NEW.TBLOGDOCUMENT.SERIE%TYPE,
                          P_TIPO IN CHAR) return number
as
v_job number;
begin
  
 begin
    --  v_job := 0;
      SELECT distinct(jb.id)
        into v_job
        FROM NDD_NEW.TBNDDJOB JB,                           
             NDD_NEW.TBLOGDOCUMENT TGD
       WHERE 0=0
         AND JB.ID = TGD.JOBID
         AND TGD.DOCUMENTNUMBER = P_DOCUMENTO
         AND TGD.SERIE          = P_SERIE
         and to_date(substr(tgd.emissiondate,1,9),'DD/MM/YY')   >= (sysdate - 365)
         and ((jb.jobname like '%MDFE%' and P_TIPO = 'M') or
                                                             (jb.jobname not like '%MDFE%' and P_TIPO = 'C'));
       return v_job;
 exception when others then
      --raise_application_error(-20001,'ERRO AO BUSCAR ID');
      return '9999';
 end;
end;


Procedure sp_cax_trocacaixafeletroAute(P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                                           pStatus out char,
                                           pMessage out varchar2
                                           ) as     
vCursor pkg_glb_common.T_CURSOR;

vDocumento tdvadm.t_con_valefrete.con_conhecimento_codigo%type;
vSerie     tdvadm.t_con_valefrete.con_conhecimento_serie%type;
vRota      tdvadm.t_con_valefrete.glb_rota_codigo%type;
vSaque     tdvadm.t_con_valefrete.con_valefrete_saque%type;
vNovaRota  tdvadm.t_con_valefrete.glb_rota_codigo%type;
vData      Date;
                                        
begin
  --MSG=CADTARIFA;DOCUMENTO=000000;SERIE=A1;ROTA=023;NOVAROTA=055;DATA=10/02/2015;
  vDocumento := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'DOCUMENTO','=',';')))); 
  vSerie     := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'SERIE','=',';'))));
  vRota      := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'ROTA','=',';'))));                                        
  vSaque     := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'SAQUE','=',';'))));
  vNovaRota  := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'NOVAROTA','=',';')))); 
  vData      := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'DATA','=',';'))));                                        

  pkg_ctb_caixa.sp_cax_trocacaixafeletronico(vDocumento,
                                             vserie,
                                             vrota,
                                             vsaque,
                                             vNovaRota,
                                             vData,
                                             pstatus,
                                             pMessage,
                                             vCursor); 
                                             
                                               
                                              
                                             
                                             
END sp_cax_trocacaixafeletroAute;
        

Procedure sp_ArrumaDataBaixaAutomatica(pProtocolo in rmadm.t_glb_benasserec.glb_benasserec_chave%type,
                                       pStatus out char,
                                       pMessage out clob)
 As
   vAuxiliar number;                                       
Begin

     pStatus  := pkg_glb_common.Status_Nomal;
     pMessage :=  '';


     FOR CProtocolo IN (select sap.cte,
                               sap.fatura,
                               sap.databaixa,
                               sap.datapgtoreal, 
                               sap.valorplan,
                               sap.valortdv 
                        from t_edi_conciliacaosap sap
                        where sap.protocolo = pProtocolo
                          and sap.obs like '#Baixa%')
   LOOP
  
       update t_con_fatura f 
          set f.con_fatura_datavenc    = cProtocolo.Datapgtoreal,
              f.con_fatura_datapagto   = cProtocolo.Datapgtoreal,
              f.con_fatura_dataemissao = cProtocolo.Datapgtoreal
       where f.glb_rota_codigofilialimp = substr(cProtocolo.Fatura,1,3)
         and f.con_fatura_codigo = substr(cProtocolo.Fatura,5,6);
        
       vAuxiliar := sql%rowcount;
       
       If vAuxiliar = 0 Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage :=  pMessage || 'Não Achou Registro para Fatura ' || cProtocolo.Fatura || chr(10);
       End If;
       
       update t_crp_titreceber f 
         set f.crp_titreceber_dtgeracao    = cProtocolo.Datapgtoreal,
             f.crp_titreceber_dtvencimento = cProtocolo.Datapgtoreal,
             f.crp_titreceber_dtprevpag    = cProtocolo.Datapgtoreal
       where f.glb_rota_codigofilialimp = substr(cProtocolo.Fatura,1,3)
         and f.con_fatura_codigo = substr(cProtocolo.Fatura,5,6);

       vAuxiliar := sql%rowcount;
       
       If vAuxiliar = 0 Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage :=  pMessage || 'Não Achou Registro para o Titulo ' || cProtocolo.Fatura || chr(10);
       End If;

       update t_crp_titrecevento f 
         set f.crp_titrecevento_data     = cProtocolo.Datapgtoreal,
             f.crp_titrecevento_dtevento = cProtocolo.Datapgtoreal      
       where f.glb_rota_codigo = substr(cProtocolo.Fatura,1,3)
         and f.crp_titreceber_numtitulo = substr(cProtocolo.Fatura,5,6)
         and substr(f.crp_titrecevento_docrateio,9,3) || substr(f.crp_titrecevento_docrateio,1,6)  = replace(cProtocolo.Cte,'-','');

       vAuxiliar := sql%rowcount;
       
       If vAuxiliar = 0 Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage :=  pMessage || 'Não Achou Registro para RecEvento Titulo ' || cProtocolo.Fatura || ' Cte ' || cProtocolo.Cte || chr(10);
       End If;

       update t_con_conhecfaturado f 
          set f.con_conhecfaturado_dtbaixa = cProtocolo.Datapgtoreal
       where f.glb_rota_codigoconhec || '-' || f.con_conhecimento_codigo = cProtocolo.Cte;
       
       vAuxiliar := sql%rowcount;
       
       If vAuxiliar = 0 Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage :=  pMessage || 'Não Achou Registro para Conhecfaturado Cte ' || cProtocolo.Cte || chr(10);
       End If;

       if pStatus = pkg_glb_common.Status_Erro Then
          return;
       End If;
   End Loop;
   
   if pStatus = pkg_glb_common.Status_Nomal Then
      commit;
   End If;   
   

  
End sp_ArrumaDataBaixaAutomatica; 

Function FN_Get_EmbTransferencia2(pCon_conhecimento_codigo in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                                  pCon_conhecimento_serie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                                  pGlb_rota_codigo in tdvadm.t_con_conhecimento.glb_rota_codigo%type,
                                  pDataaSerVerificada in char default trunc(sysdate) ,
                                  pRetorno char default 'T') return char is
 --Variável de controle
 vControl            integer;                
 vCarregamento       tdvadm.t_arm_carregamento.arm_carregamento_codigo%type;                 
 vDataaSerVerificada CHAR(10) := nvl(pDataaSerVerificada,trunc(sysdate));
 vRetorno            varchar2(30);
 vChave              varchar2(30);
 vContador           number;
 vArmTransferencia   tdvadm.t_arm_carregamentodet.arm_armazem_codigo_transf%type;
 vArmCarreg          tdvadm.t_arm_armazem.arm_armazem_codigo%type;
 vArmNota            tdvadm.t_arm_armazem.arm_armazem_codigo%type;
 vCarregDevolucao    tdvadm.t_arm_carregamento.ARM_CARREGAMENTO_CODIGO%type;
 vRotaArmazem        tdvadm.t_glb_rota.glb_rota_codigo%type;
 vRotaCte            tdvadm.t_glb_rota.glb_rota_codigo%type; 

begin
  vControl := 0;

  Begin

  SELECT N.CON_CONHECIMENTO_CODIGO                || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO ,
         count(DISTINCT N.CON_CONHECIMENTO_CODIGO || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO),             
         DET.arm_armazem_codigo_transf,
         ca.arm_armazem_codigo armcarreg,
         n.arm_armazem_codigo armnota,
         nvl(C.ARM_CARREGAMENTO_CODIGO, 'Devoluc') CARREGAMENTO,
         AM.GLB_ROTA_CODIGO ROTAARM,
         C.GLB_ROTA_CODIGO ROTACTE         
--         Decode(nvl(DET.arm_armazem_codigo_transf, 'R'),'R',Decode(ca.arm_armazem_codigo,n.arm_armazem_codigo,Decode(nvl(C.ARM_CARREGAMENTO_CODIGO, 'D'),'D','Devolucao','Não'),DECODE(AM.GLB_ROTA_CODIGO,C.GLB_ROTA_CODIGO,'Transf. chekin feito','Normal')),'Sim') Transferencia
  
/*  SELECT N.CON_CONHECIMENTO_CODIGO                || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO ,
         count(DISTINCT N.CON_CONHECIMENTO_CODIGO || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO),             
         Decode(nvl(DET.arm_armazem_codigo_transf, 'R'),'R',Decode(ca.arm_armazem_codigo,n.arm_armazem_codigo,Decode(nvl(C.ARM_CARREGAMENTO_CODIGO, 'D'),'D','Devolucao','Não'),DECODE(AM.GLB_ROTA_CODIGO,C.GLB_ROTA_CODIGO,'Transf. chekin feito','Normal')),'Sim') Transferencia
*/
    into vChave   ,
         vContador,
         vArmTransferencia,
         vArmCarreg,
         vArmNota,
         vCarregDevolucao,
         vRotaArmazem,
         vRotaCte
--         ,vRetorno
    from t_arm_nota n,
         t_arm_carregamentodet det,
         t_arm_carregamento     ca,
         t_arm_cargadet         cd,
         t_con_conhecimento      c,
         t_arm_armazem          am,
         t_arm_embalagem       emb
    where 0 = 0
      and cd.arm_carga_codigo            = n.arm_carga_codigo
      and ca.arm_armazem_codigo          = am.arm_armazem_codigo
      and cd.arm_nota_numero             = n.arm_nota_numero
      and cd.glb_cliente_cgccpfremetente = n.glb_cliente_cgccpfremetente
      and cd.arm_nota_sequencia          = n.arm_nota_sequencia
      and cd.arm_embalagem_numero        = det.arm_embalagem_numero
      and cd.arm_embalagem_flag          = det.arm_embalagem_flag
      and cd.arm_embalagem_sequencia     = det.arm_embalagem_sequencia
      and det.arm_carregamento_codigo    = ca.arm_carregamento_codigo
      and n.con_conhecimento_codigo      = c.con_conhecimento_codigo
      and n.con_conhecimento_serie       = c.con_conhecimento_serie
      and n.glb_rota_codigo              = c.glb_rota_codigo
      and emb.arm_embalagem_numero        = n.arm_embalagem_numero
      and emb.arm_embalagem_flag          = n.arm_embalagem_flag
      and emb.arm_embalagem_sequencia     = n.arm_embalagem_sequencia
      and n.con_conhecimento_codigo      = pCon_conhecimento_codigo
      and n.con_conhecimento_serie       = pCon_conhecimento_serie 
      and n.glb_rota_codigo              = pGlb_rota_codigo
      and ca.arm_carregamento_codigo     =  (select cc.arm_carregamento_codigo
                                           from t_arm_carregamento cc,
                                               t_arm_carregamentodet det 
                                           where 0 =0 
                                             and trunc(cc.arm_carregamento_dtcria) <= nvl(pDataaSerVerificada,trunc(sysdate))
                                             and det.arm_carregamento_codigo        = cc.arm_carregamento_codigo
                                             and det.arm_embalagem_numero           = n.arm_embalagem_numero
                                             and det.arm_embalagem_flag             = n.arm_embalagem_flag
                                             and det.arm_embalagem_sequencia        = n.arm_embalagem_sequencia
                                             and cc.arm_carregamento_dtcria         = (select max(cc1.arm_carregamento_dtcria)
                                                                                      from t_arm_carregamento cc1,
                                                                                           t_arm_carregamentodet det1 
                                                                                       where 0 =0 
                                                                                         and trunc(cc1.arm_carregamento_dtcria) <= nvl(pDataaSerVerificada,trunc(sysdate))
                                                                                         and det1.arm_carregamento_codigo        = cc1.arm_carregamento_codigo
                                                                                         and det1.arm_embalagem_numero           = n.arm_embalagem_numero
                                                                                         and det1.arm_embalagem_flag             = n.arm_embalagem_flag
                                                                                         and det1.arm_embalagem_sequencia        = n.arm_embalagem_sequencia
                                                                                         and emb.arm_armazem_codigo              <> cc1.arm_armazem_codigo))
                                          
      group by N.CON_CONHECIMENTO_CODIGO || N.CON_CONHECIMENTO_SERIE || N.GLB_ROTA_CODIGO,
               DET.arm_armazem_codigo_transf,
               ca.arm_armazem_codigo,
               n.arm_armazem_codigo,
               nvl(C.ARM_CARREGAMENTO_CODIGO, 'Devoluc'),
               AM.GLB_ROTA_CODIGO,
               C.GLB_ROTA_CODIGO;
--              Decode(nvl(DET.arm_armazem_codigo_transf, 'R'),'R',Decode(ca.arm_armazem_codigo,n.arm_armazem_codigo,Decode(nvl(C.ARM_CARREGAMENTO_CODIGO, 'D'),'D','Devolucao','Não'),DECODE(AM.GLB_ROTA_CODIGO,C.GLB_ROTA_CODIGO,'Transf. chekin feito','Normal')),'Sim');                                    

      if vContador > 1 Then
         vRetorno := vChave;
      End If;     

     if nvl(vArmTransferencia,'R') = 'R' Then 
         if vArmCarreg = vArmNota  Then
            if nvl(vCarregDevolucao,'D') = 'D' Then
               vRetorno := 'Devolucao';
             Else
               vRetorno := 'Não';
             End If;  
          Else
             if vRotaArmazem = vRotaCte then
                vRetorno := 'Transf. chekin feito';
             Else
               vRetorno := 'Normal' ;
             End If;  
         End If;
      Else
         vRetorno := 'Sim';
      End If  ; 



    
  Exception
    --When NO_DATA_FOUND Then
    --caso ocorra algum erro não previsto.
    --w    
   
    when others then
--      raise_application_error(-20001, 'Erro ao validar transferência' || chr(13) || sqlerrm);
        vRetorno := 'Não';
    end;
   
  if nvl(pRetorno,'T') = 'T' Then
     return nvl(vRetorno,'N');
  Else
     return vArmTransferencia;
  End If;   
  
end FN_Get_EmbTransferencia2 ;

Procedure SP_SET_EmbTransferencia2(P_BENASSE IN rmadm.t_glb_benasserec.glb_benasserec_assunto%type,
                                   pStatus out char,
                                   pMessage out CLOB
                                   ) as     

vValeFrete          tdvadm.t_con_valefrete.con_conhecimento_codigo%type;
vSerieValeFrete     tdvadm.t_con_valefrete.con_conhecimento_serie%type;
vRotaValeFrete      tdvadm.t_con_valefrete.glb_rota_codigo%type;
vSaque              tdvadm.t_con_valefrete.con_valefrete_saque%type;
vConhecimento       tdvadm.t_con_conhecimento.con_conhecimento_codigo%type;
vSerieConhecimento  tdvadm.t_con_conhecimento.con_conhecimento_serie%type;
vRotaConhecimento   tdvadm.t_con_conhecimento.glb_rota_codigo%type;
vStatusTransf       CHAR(3);
                                        
begin
  --MSG=CADTARIFA;DOCUMENTO=000000;SERIE=A1;ROTA=023;NOVAROTA=055;DATA=10/02/2015;
  vValeFrete          := LPAD((UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'VALEFRETE','=',';')))),6,'0'); 
  vSerieValeFrete     := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'SERIEVF','=',';'))));
  vRotaValeFrete      := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'ROTAVF','=',';'))));                                        
  vSaque              := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'SAQUEVF','=',';'))));
  vConhecimento       := LPAD((UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'CONHECIMENTO','=',';')))),6,'0'); 
  vSerieConhecimento  := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'SERIECON','=',';'))));        
  vRotaConhecimento   := (UPPER(Trim(tdvadm.fn_querystring(upper(P_BENASSE),'ROTACON','=',';')))); 
  
  
  update t_con_vfreteconhec c
     set c.con_vfreteconhec_transfchekin = pkg_hd_utilitario.FN_Get_EmbTransferencia2(c.con_conhecimento_codigo,
                                                                                      c.con_conhecimento_serie,
                                                                                      c.glb_rota_codigo,
                                                                                      trunc(c.con_vfreteconhec_dtgravacao),
                                                                                      'T'),
         c.arm_armazem_codigo            = pkg_hd_utilitario.FN_Get_EmbTransferencia2(c.con_conhecimento_codigo,
                                                                                      c.con_conhecimento_serie,
                                                                                      c.glb_rota_codigo,
                                                                                      trunc(c.con_vfreteconhec_dtgravacao),
                                                                                      'A')
   where 0 = 0
     and c.con_valefrete_codigo       = vValeFrete
     and c.con_valefrete_serie        = vSerieValeFrete
     and c.glb_rota_codigovalefrete   = vRotaValeFrete
     and c.con_valefrete_saque        = vSaque
     and c.con_conhecimento_codigo    = vConhecimento      
     and c.con_conhecimento_serie     = vSerieConhecimento 
     and c.glb_rota_codigo            = vRotaConhecimento;
     
  BEGIN 
  
      select c.con_vfreteconhec_transfchekin
        into vStatusTransf
      from t_con_vfreteconhec c
      where 0 = 0
         and c.con_valefrete_codigo       = vValeFrete
         and c.con_valefrete_serie        = vSerieValeFrete
         and c.glb_rota_codigovalefrete   = vRotaValeFrete
         and c.con_valefrete_saque        = vSaque
         and c.con_conhecimento_codigo    = vConhecimento      
         and c.con_conhecimento_serie     = vSerieConhecimento 
         and c.glb_rota_codigo            = vRotaConhecimento;
         
  EXCEPTION WHEN NO_DATA_FOUND THEN
   pStatus := 'E';
   pMessage := 'Conhecimento: ' || vConhecimento || ', não existe no Vale de frete: ' || vValeFrete || '-' || vSerieValeFrete || '-' || vRotaValeFrete || '-' || vSaque || '.';
   
   
  END;
   
     
  if(sql%rowcount = 1)then
     pMessage := 'Vale de Frete ' || vValeFrete || ' Alterado para Transferencia = ' || vStatusTransf;
     pStatus := 'N';
  end if; 
                                             
END sp_set_EmbTransferencia2;                                       

procedure sp_copiaNotasCarregTESTE(pCarregamento in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                   pStatus out char,
                                   pMessage out CLOB)

  AS
    vTpCarga           tdvadm.t_arm_carga%rowtype;
    vTpCargaDet        tdvadm.t_arm_cargadet%rowtype;
    vTpEmbalagem       tdvadm.t_arm_embalagem%rowtype;
    vTpCarregamento    tdvadm.t_arm_carregamento%rowtype;
    vTpCarregamentoDet tdvadm.t_arm_carregamentodet%rowtype;
    vTpNota            tdvadm.t_arm_nota%rowtype;
    vTpNotaFichaEmerg  tdvadm.t_arm_notafichaemerg%rowtype;
    vTemFichaEmerg     char(1);
    vMsg               varchar2(600);
    
  Begin
     pStatus        := pkg_glb_common.Status_Nomal;
     pMessage       := empty_clob;
     vTemFichaEmerg := 'N';
     select *
       into vTpCarregamento
     from t_arm_carregamento ca  
     where ca.arm_carregamento_codigo = pCarregamento;
     
     select max(to_number(ca.arm_carregamento_codigo)) + 1
       into vTpCarregamento.Arm_Carregamento_Codigo
     from t_arm_carregamento ca;
     
     pMessage := 'Criado o Carregamento [' ||vTpCarregamento.Arm_Carregamento_Codigo || ']';
     
     vTpCarregamento.Arm_Carregamemcalc_Codigo      := vTpCarregamento.Arm_Carregamento_Codigo;
     vTpCarregamento.Car_Veiculo_Placa              := null;
     vTpCarregamento.Car_Veiculo_Saque              := null;
     vTpCarregamento.Arm_Carregamento_Dtfechamento  := null;
     vTpCarregamento.Usu_Usuario_Fechoucarreg       := null;
     vTpCarregamento.Fcf_Veiculodisp_Codigo         := null;
     vTpCarregamento.Fcf_Veiculodisp_Sequencia      := null;
     vTpCarregamento.Arm_Carregamento_Qtdctrc       := 0;
     vTpCarregamento.Arm_Carregamento_Qtdimpctrc    := 0;
     vTpCarregamento.Arm_Carregamento_Flagmanifesto := 'N';
     vTpCarregamento.Arm_Carregamento_Dtfinalizacao := null;
     vTpCarregamento.Usu_Usuario_Conferiucarreg     := null;
     vTpCarregamento.Arm_Carregamento_Dtconferencia := null;
     vTpCarregamento.Arm_Carregamento_Flagvirtual   := 'S';
     
     insert into t_arm_carregamento values vTpCarregamento;
      
       
     FOR cNotas IN ( select *
                     from t_arm_nota n
                     where n.arm_carregamento_codigo = pCarregamento)
   LOOP

       select *
         into vTpCarregamentoDet
       from t_arm_carregamentodet det
       where det.arm_carregamento_codigo = pCarregamento
         and det.arm_embalagem_numero    = cNotas.Arm_Embalagem_Numero
         and det.arm_embalagem_flag      = cNotas.Arm_Embalagem_Flag
         and det.arm_embalagem_sequencia = cNotas.Arm_Embalagem_Sequencia;


       select *
         into vTpCarga
       from t_arm_carga ca
       where ca.arm_carga_codigo = cNotas.Arm_Carga_Codigo;

       select *
         into vTpCargaDet
       from t_arm_cargadet ca
       where ca.arm_carga_codigo        = cNotas.Arm_Carga_Codigo
         and ca.arm_embalagem_numero    = cNotas.Arm_Embalagem_Numero
         and ca.arm_embalagem_flag      = cNotas.Arm_Embalagem_Flag
         and ca.arm_embalagem_sequencia = cNotas.Arm_Embalagem_Sequencia;

       select *
         into vTpEmbalagem
       from t_arm_embalagem eb
       where eb.arm_embalagem_numero    = cNotas.Arm_Embalagem_Numero
         and eb.arm_embalagem_flag      = cNotas.Arm_Embalagem_Flag
         and eb.arm_embalagem_sequencia = cNotas.Arm_Embalagem_Sequencia;

       Begin
          select *
            into vTpNotaFichaEmerg
          from t_arm_notafichaemerg fe
          where fe.arm_nota_sequencia = cNotas.Arm_Nota_Sequencia
            and fe.arm_notafichaemerg_seqficha = 1;
          vTemFichaEmerg := 'S';
       Exception
         When NO_DATA_FOUND Then
            vTemFichaEmerg := 'N';
       End;

       select *
         into vTpNota
       From t_arm_nota n
       where n.arm_nota_sequencia = cNotas.Arm_Nota_Sequencia;
       
       select max(n.Arm_Nota_Sequencia) + 1
         into vTpNota.Arm_Nota_Sequencia
       from t_arm_nota n;  
          
       select max(ca.arm_carga_codigo) + 1 
         into vTpCarga.Arm_Carga_Codigo
       from t_arm_carga ca;
       
       select max(eb.arm_embalagem_numero) + 1
         into vTpEmbalagem.Arm_Embalagem_Numero
       from t_arm_embalagem eb
       where eb.arm_embalagem_flag      = cNotas.Arm_Embalagem_Flag;
       vTpEmbalagem.Arm_Embalagem_Sequencia := 1;
       vTpEmbalagem.Arm_Carregamento_Codigo := vTpCarregamento.Arm_Carregamento_Codigo;
       
       
       vTpCargaDet.Arm_Carga_Codigo        := vTpCarga.Arm_Carga_Codigo;
       vTpCargaDet.Arm_Cargadet_Seq        := 1;
       vTpCargaDet.Arm_Embalagem_Numero    := vTpEmbalagem.Arm_Embalagem_Numero;
       vTpCargaDet.Arm_Embalagem_Flag      := vTpEmbalagem.Arm_Embalagem_Flag;
       vTpCargaDet.Arm_Embalagem_Sequencia := vTpEmbalagem.Arm_Embalagem_Sequencia;
       
       vTpNota.Con_Conhecimento_Codigo     := null;
       vTpNota.Con_Conhecimento_Serie      := null;
       vTpNota.Glb_Rota_Codigo             := null;
       vTpNota.Arm_Carregamento_Codigo     := vTpCarregamento.Arm_Carregamento_Codigo;
       vTpNota.Arm_Embalagem_Numero        := vTpCargaDet.Arm_Embalagem_Numero;
       vTpNota.Arm_Embalagem_Flag          := vTpCargaDet.Arm_Embalagem_Flag;
       vTpNota.Arm_Embalagem_Sequencia     := vTpCargaDet.Arm_Embalagem_Sequencia;
       vTpNota.Arm_Carga_Codigo            := vTpCargaDet.Arm_Carga_Codigo;
       vTpNota.Arm_Carregamento_Codigo     := null;   
       vTpNota.Arm_Nota_Numero             := vTpNota.Arm_Nota_Numero - 100;
       vTpNota.Arm_Nota_Dtinclusao         := sysdate;
       vTpNota.Arm_Movimento_Datanfentrada := sysdate;
       vTpNota.Arm_Nota_Dtrecebimento      := sysdate;
       
       if vTemFichaEmerg = 'S' Then
          vTpNotaFichaEmerg.Arm_Nota_Sequencia := vTpNota.Arm_Nota_Sequencia;
          vTpNotaFichaEmerg.Arm_Nota_Numero    := vTpNota.Arm_Nota_Numero;
       End If;


       vTpCargaDet.Arm_Nota_Numero         := vTpNota.Arm_Nota_Numero;
       vTpCargaDet.Arm_Nota_Sequencia      := vTpNota.Arm_Nota_Sequencia;
       vTpCargaDet.Arm_Carga_Codigo        := vTpCarga.Arm_Carga_Codigo;
       vTpCargaDet.Arm_Cargadet_Seq        := 1;
       vTpCargaDet.Arm_Embalagem_Numero    := vTpEmbalagem.Arm_Embalagem_Numero;
       vTpCargaDet.Arm_Embalagem_Flag      := vTpEmbalagem.Arm_Embalagem_Flag;
       vTpCargaDet.Arm_Embalagem_Sequencia := vTpEmbalagem.Arm_Embalagem_Sequencia;

       insert into t_arm_embalagem values vTpEmbalagem;
       insert into t_arm_carga     values vTpCarga;
       insert into t_arm_nota      values vTpNota;
       if vTemFichaEmerg = 'S' Then
          insert into t_arm_notafichaemerg fe values vTpNotaFichaEmerg;
       End If;
       insert into t_arm_cargadet  values vTpCargaDet;  

       
       vTpCarregamentoDet.Arm_Carregamento_Codigo       := vTpCarregamento.Arm_Carregamento_Codigo;
       vTpCarregamentoDet.Arm_Embalagem_Numero          := vTpNota.Arm_Embalagem_Numero;
       vTpCarregamentoDet.Arm_Embalagem_Flag            := vTpNota.Arm_Embalagem_Flag;
       vTpCarregamentoDet.Arm_Embalagem_Sequencia       := vTpNota.Arm_Embalagem_Sequencia;
       vTpCarregamentoDet.Arm_Carregamentodet_Flagtrans := null;
       vTpCarregamentoDet.Arm_Armazem_Codigo_Transf     := null;
       
       insert into t_arm_carregamentodet values vTpCarregamentoDet;
       
   END LOOP;
   
   
   commit;
   
  exception
    When OTHERS Then
      vMsg := sqlerrm;
      rollback; 
   
   
  End sp_copiaNotasCarregTESTE;

  procedure sp_ApagaNotasCarregTESTE(pCarregamento in tdvadm.t_arm_carregamento.arm_carregamento_codigo%type,
                                   pStatus out char,
                                   pMessage out CLOB)

  AS
    vAuxiliar number;
    vVeicudispCod tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_codigo%type;
    vVeicudispSeq tdvadm.t_fcf_veiculodisp.fcf_veiculodisp_sequencia%type;
    
  Begin

     pStatus := pkg_glb_common.Status_Nomal;
     pMessage := '';

     FOR cNotas IN ( select *
                     from t_arm_nota n
                     where n.arm_carregamento_codigo = pCarregamento)
     LOOP

         delete t_arm_notafichaemerg fe
         where fe.arm_nota_sequencia = cNotas.Arm_Nota_Sequencia;
         
         delete t_arm_carregamentodet det
         where det.arm_carregamento_codigo = pCarregamento
           and det.arm_embalagem_numero    = cNotas.Arm_Embalagem_Numero
           and det.arm_embalagem_flag      = cNotas.Arm_Embalagem_Flag
           and det.arm_embalagem_sequencia = cNotas.Arm_Embalagem_Sequencia;
           
         delete t_arm_cargadet det
         where det.arm_carga_codigo = cNotas.Arm_Carga_Codigo
           and det.arm_embalagem_numero    = cNotas.Arm_Embalagem_Numero
           and det.arm_embalagem_flag      = cNotas.Arm_Embalagem_Flag
           and det.arm_embalagem_sequencia = cNotas.Arm_Nota_Sequencia
           and det.arm_nota_sequencia      = Cnotas.Arm_Nota_Sequencia;

         delete t_arm_nota n
         where n.arm_nota_sequencia = Cnotas.Arm_Nota_Sequencia;

         delete t_arm_carga ca
         where ca.arm_carga_codigo = cNotas.Arm_Carga_Codigo;
         
         delete t_Arm_Embalagem e
         where e.arm_embalagem_numero    = cNotas.Arm_Embalagem_Numero
           and e.arm_embalagem_flag      = cNotas.Arm_Embalagem_Flag
           and e.arm_embalagem_sequencia = cNotas.Arm_Nota_Sequencia;
           


     End Loop;

     delete t_arm_carregamento_hist h
     where h.arm_carregamento_codigo = pCarregamento;
  
     delete t_arm_carregamentodet h
     where h.arm_carregamento_codigo = pCarregamento;
  
     update t_fcf_veiculodisp vd
       set vd.arm_carregamento_codigo = null
     where vd.arm_carregamento_codigo = pCarregamento;   
     
     select c.fcf_veiculodisp_codigo,
            c.fcf_veiculodisp_sequencia
       into vVeicudispCod,
            vVeicudispSeq
     from t_arm_carregamento c
     where c.arm_carregamento_codigo = pCarregamento;      

     update t_fcf_veiculodisp vd
       set vd.arm_carregamento_codigo = null
     where vd.fcf_veiculodisp_codigo = vVeicudispCod
       and vd.fcf_veiculodisp_sequencia = vVeicudispSeq;
       
     update t_arm_carregamento c
       set c.fcf_veiculodisp_codigo = null,
           c.fcf_veiculodisp_sequencia = null
     where c.arm_carregamento_codigo = pCarregamento; 
                   
     delete t_fcf_veiculodisp vd
     where vd.fcf_veiculodisp_codigo = vVeicudispCod
       and vd.fcf_veiculodisp_sequencia = vVeicudispSeq;      

     delete t_arm_carregamento det
     where det.arm_carregamento_codigo = pCarregamento;

     Commit;
      
 exception
    When OTHERS Then
   
       pStatus := pkg_glb_common.Status_Erro;
       pMessage := 'Erro : ' || sqlerrm;
       rollback; 
  
  End sp_ApagaNotasCarregTESTE;
  
 
  Procedure Sp_DeleteMovimento(pXmlMovimento In Varchar2,                
                               pStatus    Out Char,
                               pMessage   Out Varchar2)
  Is
  Begin
      almadm.pkg_alm_movimentoproduto_est.Sp_DeleteMovimento(pXmlMovimento,
                                                             pStatus,
                                                             pMessage);
      
     
  End Sp_DeleteMovimento;
  
  function fn_get_email(pUsuario varchar2) return varchar2
    as
  
  vEmail varchar(200);
  
  begin
    
    begin
      select nvl(i.usu_usuario_email,'Usuario ' || pUsuario || ' Não contem e-mail em seu cadastro')
      into vEmail
      from t_usu_usuario i
      where i.usu_usuario_codigo = rpad(pUsuario, 10, ' ') ;
    
    exception when NO_DATA_FOUND then
       vEmail := '';
    end;
    return vEmail;
  end fn_get_email;
  
  PROCEDURE SP_CTE_REENVIACANCEL(P_CTE     IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%type,
                                                 P_SERIE   IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                                 P_ROTA    IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                                 P_STATUS  OUT CHAR,
                                                 P_MESSAGE OUT VARCHAR2) AS
VTESTE CHAR(1);
BEGIN
 
  begin
         
  --*****************************************
  --* Jonatas Veloso Siqueira 11/11/2015    *
  --* Reenviar Cancelamento do CTE          *
  --* Nas condições que esta no repositório *
  --*****************************************
  
  --*****************************************
  --*           MENSAGEM DE ERRO            *
  --* A data do evento não pode ser menor   *
  --* que a data de autorização do CT-e     *
  --*****************************************
     
    UPDATE T_CON_CONTROLECTRCE CE
       SET CE.CON_CONTROLECTRCE_DTSOLCANCEL     = NULL,
           CE.CON_CONTROLECTRCE_DTRETCANCEL     = NULL,    --Adicionado 18/01/2016
           CE.CON_CONTROLECTRCE_XMLRETCANC      = NULL     --Adicionado 18/07/2016 pois, retornava a mesma mensagem
           --CE.CON_CONTROLECTRCE_NPROTCANCEL     = NULL 
           --CE.CON_CONTROLECTRCE_CODSTCANCEL     = NULL   
     WHERE CE.CON_CONHECIMENTO_CODIGO           = P_CTE
       AND CE.CON_CONHECIMENTO_SERIE            = P_SERIE
       AND CE.GLB_ROTA_CODIGO                   = P_ROTA;
       
       
    UPDATE T_CON_EVENTOCTE E
       SET E.CON_EVENTOCTE_FLAGENVIO            = 'N'
           --E.CON_CONHECCANCELMOTIVO_CODIGO      = NULL    --Adicionado 18/01/2016 Para cumprir as condições
           --                                                 PKG_CON_CTRC line 3462 
     WHERE E.CON_CONHECIMENTO_CODIGO            = P_CTE
       AND E.CON_CONHECIMENTO_SERIE             = P_SERIE
       AND E.GLB_ROTA_CODIGO                    = P_ROTA;
  
    
    P_STATUS  := 'N'; 
    P_MESSAGE := 'Processamento Normal!'; 
  
  exception when others then
    
      P_STATUS  := 'E'; 
      P_MESSAGE := 'Erro ao executar SP_CTE_REENVIACANCEL. Erro.: '||sqlerrm; 
  
  end; 
  
END SP_CTE_REENVIACANCEL;

function fn_GET_SomaPeso( pArm          IN varchar2,
                          pDestinoCnpj IN varchar2,
                          pDetinoCidade IN varchar2) return float
as
v_sum float;
v_erro varchar(2000);
begin
  
 begin
   
    Select sum(col.nota_pesobalac)
     into v_sum
     From V_KPI_ANALISECOLETA col
    Where instr(col.armazem, pArm) > 0
      and col.nota_numero is not null
      and col.valefrete = '--'
      and col.coleta_dtsolic > sysdate - 90 /*Quando alterar aqui, alterar tambem na tdvadm.pkg_hd_utilitario .fn_GET_SomaPeso*/
      and nvl(col.ctrc_serie, 'X') <> 'XXX'      
      and trim(col.coleta_cnpjdest)    = trim(pDestinoCnpj)
      and trim(col.coleta_ciddestino)  = trim(pDetinoCidade)
    group by trim(col.coleta_cnpjdest),
             trim(col.coleta_ciddestino);
             
/*   Select sum(col.nota_pesobalac)
     into v_sum
     From V_KPI_ANALISECOLETA col
    Where instr(col.armazem, pArm) > 0
      and col.coleta_ciddestino  = rpad(pDestinoCnpj, 20, ' ')
      and col.coleta_ciddestino  = pDetinoCidade
      and col.nota_numero is not null
      and col.valefrete = '--'
      and col.ctrc_serie <> 'XXX'
      and col.coleta_dtsolic > sysdate - 60
    group by trim(col.coleta_cnpjdest),
             trim(col.coleta_ciddestino);*/
             
/*   Where instr(col.armazem, '06') > 0--
      and col.nota_numero is not null--
      and col.valefrete = '--' --
      and col.coleta_dtsolic > sysdate - 60 --
      and col.ctrc_serie <> 'XXX'*/
    
    return v_sum;
 exception
   when others then
     v_erro := sqlerrm;
     return -1;
 end;
end;

  function fn_get_rotaColeta (pColeta varchar2, pCiclo varchar) return varchar
  as
  /***************************************************************************************************
  * ROTINA           : fn_get_rotaMotorista                                                          *
  * PROGRAMA         : anida não tem front end                                                       *
  * ANALISTA         : Lucas Tarcha Marchetto                                                        *
  * DESENVOLVEDOR    : Lucas Tarcha Marchetto                                                        *
  * DATA DE CRIACAO  : 29/01/2016                                                                    *
  * EXECUTADO POR    : Gerenciador de coleta/Cadastro de coleta                                      *
  * FUNCINALIDADE    : Descobre a Rota que o motorista deve seguir para fazer a coleta               *
  ****************************************************************************************************/

  vRotaMotorista     tdvadm.t_arm_rotacoleta.arm_rotacoleta_descricao%type;
  vCepColeta         integer;
  vDeterminaTpBusca  integer;
  BEGIN
    begin
      select to_number(en.glb_cep_codigo)
      into vCepColeta
      from t_arm_coleta ta,
           t_glb_cliend en
      where ta.glb_cliente_cgccpfcodigocoleta = en.glb_cliente_cgccpfcodigo
        and ta.glb_tpcliend_codigocoleta      = en.glb_tpcliend_codigo
        and ta.arm_coleta_ncompra = pColeta
        and ta.arm_coleta_ciclo   = pCiclo;
        
      /* Para São Paulo Capital buscamos pela faixa CEP que estão nessa tabela,
         Caso Não encontre, Admito que seja Grande São Paulo e busco pela Localidade*/
      --begin   
      
        select ta.arm_rotacoleta_descricao
        into vRotaMotorista
        from t_arm_faixacep t,
             t_arm_rotacoleta ta
        where t.arm_rotacoleta_id = ta.arm_rotacoleta_id
          and vCepColeta between t.arm_faixacep_cepini and t.arm_faixacep_cepfim;
    
    exception
       /*Caso não encontre nenhuma faixa(Que não esteja cadastrada)*/
       when no_data_found then
            return 'OUTROS';       
       when others then    
           return 'Coleta:' || pColeta || ' ' || sqlerrm || vCepColeta ;
      end;

  RETURN vRotaMotorista;

  END fn_get_rotaColeta;
  
  function fn_get_CountColetasCobradas (pCtrc varchar2, pSerie varchar, pRota varchar2) return integer
  as

  v_count  integer;
  v_aux    integer;
  Cursor v_cursor is select * from t_Arm_nota ta
                      where ta.con_conhecimento_codigo = pCtrc
                      and ta.con_conhecimento_serie    = pSerie
                      and ta.glb_rota_codigo           = pRota;
  BEGIN
  
    
    v_count := 0;
    v_aux   := 0;
    for i in v_cursor loop
        
        select count(*)
          into v_aux
        from t_arm_coleta ta
        where ta.arm_coleta_ncompra = i.arm_coleta_ncompra
          and ta.arm_coleta_ciclo   = i.arm_coleta_ciclo
          and ta.arm_coleta_entcoleta = 'C';
          
          v_count := v_count + v_aux;
          
    end loop;
       
   

  RETURN v_count;

  END fn_get_CountColetasCobradas;    
  
  
  PROCEDURE SP_CTE_CADASTRAR_PLACA(P_CTE            IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%type,
                                   P_SERIE          IN T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE,
                                   P_ROTA           IN T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE,
                                   P_CPF_CARRETEIRO IN T_CAR_CARRETEIRO.CAR_CARRETEIRO_CPFCODIGO%TYPE,
                                   P_PLACA          IN T_CAR_CARRETEIRO.CAR_VEICULO_PLACA%TYPE,
                                   P_CPF_FROTA      IN T_FRT_MOTORISTA.FRT_MOTORISTA_CPF%TYPE, 
                                   P_STATUS         OUT CHAR,
                                   P_MESSAGE        OUT VARCHAR2) AS

VVIAGEM CHAR(10);
VVIAGEM_ROTA CHAR(3);
VSAQUE_CARRETEIRO CHAR(4);
VSAQUE_PLACA CHAR(4);
VCODIGO_FROTA CHAR(4);
VCONJUNTO_VEICULO CHAR(7);

BEGIN
 
  begin
         
  --*****************************************
  --* Gustavo Vocatore 27/04/2016    *
  --* Cadastrar Placa no CTRC        *
  --*****************************************
  
  
    SELECT CO.CON_VIAGEM_NUMERO,
              CO.GLB_ROTA_CODIGO 
       INTO   VVIAGEM,
              VVIAGEM_ROTA  
       FROM TDVADM.T_CON_CONHECIMENTO CO
       WHERE CO.CON_CONHECIMENTO_CODIGO = P_CTE
       AND   CO.CON_CONHECIMENTO_SERIE  = P_SERIE
       AND   CO.GLB_ROTA_CODIGO         = P_ROTA;
  

   if P_CPF_CARRETEIRO IS NOT NULL Then
            
    SELECT MAX(CA.CAR_CARRETEIRO_SAQUE),
              MAX(CA.CAR_VEICULO_SAQUE)
       INTO  VSAQUE_CARRETEIRO,
             VSAQUE_PLACA
       FROM TDVADM.T_CAR_CARRETEIRO CA
       WHERE CA.CAR_CARRETEIRO_CPFCODIGO = P_CPF_CARRETEIRO
       AND CA.CAR_VEICULO_PLACA = P_PLACA;
       
       
    UPDATE TDVADM.T_CON_VIAGEM V
       SET V.CAR_CARRETEIRO_CPFCODIGO   =  P_CPF_CARRETEIRO,
           V.CAR_CARRETEIRO_SAQUE       =  VSAQUE_CARRETEIRO,
           V.CON_VIAGEM_PLACA           =  P_PLACA,
           V.CON_VIAGEM_PLACASAQUE      =  VSAQUE_PLACA
       WHERE V.CON_VIAGEM_NUMERO        =  VVIAGEM
       AND   V.GLB_ROTA_CODIGOVIAGEM    =  VVIAGEM_ROTA;
       
          
       P_STATUS  := 'N'; 
       P_MESSAGE := 'Processamento Normal!'; 
           
       
   End If;
   
   if P_CPF_FROTA IS NOT NULL Then
          
     SELECT M.FRT_MOTORISTA_CODIGO
       INTO VCODIGO_FROTA
       FROM TDVADM.T_FRT_MOTORISTA M
       WHERE M.FRT_MOTORISTA_CPF = P_CPF_FROTA
       AND M.FRT_MOTORISTA_DTCADASTRO = (SELECT MAX(K.FRT_MOTORISTA_DTCADASTRO)
                                         FROM TDVADM.T_FRT_MOTORISTA K
                                         WHERE K.FRT_MOTORISTA_CPF =  P_CPF_FROTA);
       
     SELECT CO.FRT_CONJVEICULO_CODIGO
       INTO VCONJUNTO_VEICULO
       FROM TDVADM.T_FRT_MOTORISTA M,
            TDVADM.T_FRT_CONJUNTO C,
            TDVADM.T_FRT_CONJVEICULO CO
       WHERE TRIM (M.FRT_MOTORISTA_CODIGO)   = TRIM (C.FRT_MOTORISTA_CODIGO)
       AND   TRIM (C.FRT_CONJVEICULO_CODIGO) = TRIM (CO.FRT_CONJVEICULO_CODIGO)
       AND   TRIM (M.FRT_MOTORISTA_CODIGO)   = TRIM (VCODIGO_FROTA);

       
       
     UPDATE TDVADM.T_CON_VIAGEM V
       SET   V.CON_VIAGEM_CPFCODIGO     =  P_CPF_FROTA,
             V.FRT_MOTORISTA_CODIGO     =  VCODIGO_FROTA ,
             V.CAR_CARRETEIRO_CPFCODIGO = NULL,
             V.FRT_CONJVEICULO_CODIGO  =  VCONJUNTO_VEICULO
       WHERE V.CON_VIAGEM_NUMERO        =  VVIAGEM
       AND   V.GLB_ROTA_CODIGOVIAGEM    =  VVIAGEM_ROTA;
           
       
     
    P_STATUS  := 'N'; 
    P_MESSAGE := 'Processamento Normal!'; 
       
       
   End If;

  
  exception when others then
    
      P_STATUS  := 'E'; 
      P_MESSAGE := 'Erro ao executar SP_CTE_CADASTRAR_PLACA. Erro.: '||sqlerrm; 
  
  end; 
  
END SP_CTE_CADASTRAR_PLACA;


PROCEDURE SP_Alterar_DataVenc     (P_Fatura         IN T_Con_Fatura.Con_Fatura_Codigo%type,
                                   P_Ciclo          IN T_Con_Fatura.Con_Fatura_Ciclo%TYPE,
                                   P_ROTA           IN T_con_Fatura.Glb_Rota_Codigofilialimp%TYPE,
                                   p_DataVenc       IN T_Con_Fatura.Con_Fatura_Datavenc%TYPE,
                                   P_STATUS         OUT CHAR,
                                   P_MESSAGE        OUT VARCHAR2) AS


BEGIN
  
 
  begin
         
  --******************************************************
  --* Gustavo Vocatore e Erik Montesante 13/05/2016  *
  --* Alterar a data de vencimento da fatura e do titulo *
  --******************************************************
  
  
    update t_con_fatura f
    set f.con_fatura_datavenc = p_DataVenc 
    where f.con_fatura_codigo = P_Fatura
    and f.con_fatura_ciclo    = P_Ciclo
    and f.glb_rota_codigofilialimp = P_ROTA;
    
    update t_crp_titreceber e 
    set e.crp_titreceber_dtvencimento = P_DataVenc
    where e.con_fatura_codigo = P_Fatura
    and  e.con_fatura_ciclo  = P_Ciclo
    and  e.glb_rota_codigofilialimp = P_ROTA;
    
     
    P_STATUS  := 'N'; 
    P_MESSAGE := 'Processamento Normal!'; 
       
      

  
  exception when others then
    
      P_STATUS  := 'E'; 
      P_MESSAGE := 'Erro ao executar SP_Alterar_Venc. Erro.: '||sqlerrm; 
  
  end; 
  
END SP_Alterar_DataVenc;


PROCEDURE SP_LiberarFat            (P_Fatura         IN T_Con_Fatura.Con_Fatura_Codigo%type,
                                   P_ROTA           IN T_con_Fatura.Glb_Rota_Codigofilialimp%TYPE,
                                   P_STATUS         OUT CHAR,
                                   P_MESSAGE        OUT VARCHAR2) AS


BEGIN
  
 
  begin
         
  --******************************************************************************
  --* Gustavo Vocatore e Erik Montesante 13/05/2016  *
  --* insere os dados quando o faturamento pede para liberar a impressão da fatura *
  --******************************************************************************
  
  
    insert into t_con_fatliberacaoedi values (trim(P_Fatura),'X',trim(P_ROTA),SYSDATE);
    commit;
    
    
    
     
    P_STATUS  := 'N'; 
    P_MESSAGE := 'Processamento Normal!'; 
       
      

  
  exception when others then
    
      P_STATUS  := 'E'; 
      P_MESSAGE := 'Erro ao executar SP_LiberarFat. Erro.: '||sqlerrm; 
  
  end; 
  
END SP_LiberarFat;


Procedure SP_VERIFICA_CARREGAMENTO(P_COD_CARREGAMENTO In  TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%Type,
                                   P_ACAO             IN CHAR DEFAULT 'V', -- PODE SER (V) Verifica (C) Corrige
                                   P_STATUS           OUT CHAR,
                                   P_MESSAGE          OUT CLOB)
As
  vMsg clob;
Begin 

   
   P_STATUS := 'N';
   P_MESSAGE := empty_clob;  
   vMsg := empty_clob;
   
   vMsg := 'Verificando CARGA DET' || chr(10);
   for c_msg in (select an.arm_nota_numero,
                        an.glb_cliente_cgccpfremetente,
                        an.arm_embalagem_numero,
                        an.arm_embalagem_sequencia,
                        cd.arm_carregamento_codigo
                 from tdvadm.t_arm_nota an,
                      tdvadm.t_arm_carregamentodet cd
                 where an.arm_embalagem_numero = cd.arm_embalagem_numero
                   and an.arm_embalagem_flag = cd.arm_embalagem_flag
                   and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
                   and cd.arm_carregamento_codigo = ''
                   and 0 = (select count(*)
                            from tdvadm.t_arm_cargadet cd
                            where cd.arm_carga_codigo = an.arm_carga_codigo))
   loop
     vMsg := vMsg || 'NT [' || c_msg.arm_nota_numero || '] ' ||
                     'REM [' || c_msg.glb_cliente_cgccpfremetente || '] ' || 
                     'EMB [' || trim(to_char(c_msg.arm_embalagem_numero)) || '/' || trim(to_char(c_msg.arm_embalagem_sequencia)) || chr(10)  ;
   End Loop;
   
   P_MESSAGE := P_MESSAGE || vMsg;      
   
   
/*   
insert into tdvadm.t_arm_cargadet
select an.arm_carga_codigo,
       1,
       an.arm_nota_numero,
       an.arm_embalagem_numero,
       an.arm_embalagem_flag,
       an.usu_usuario_codigo,
       an.arm_nota_sequencia,
       an.arm_embalagem_sequencia,
       an.glb_cliente_cgccpfremetente,
       null
from tdvadm.t_arm_nota an,
     tdvadm.t_arm_carregamentodet cd
where an.arm_embalagem_numero = cd.arm_embalagem_numero
  and an.arm_embalagem_flag = cd.arm_embalagem_flag
  and an.arm_embalagem_sequencia = cd.arm_embalagem_sequencia
  and cd.arm_carregamento_codigo = ''
  and 0 = (select count(*)
           from tdvadm.t_arm_cargadet cd
           where cd.arm_carga_codigo = an.arm_carga_codigo);

*/   
   

End SP_VERIFICA_CARREGAMENTO;



PROCEDURE SP_Insere_GrandeFluxo(pLocOrigem  IN tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                pLocDestino IN tdvadm.t_glb_localidade.glb_localidade_codigo%type,
                                pCnpjCli    IN tdvadm.t_glb_cliente.glb_cliente_cgccpfcodigo%type,
                                pTipo       in char,
                                pUsuario    in tdvadm.t_usu_usuario.usu_usuario_codigo%type,
                                pVigencia   in varchar2,
                                P_STATUS    OUT CHAR,
                                P_MESSAGE   OUT VARCHAR2)
   AS
  vAuxiliar number;
Begin  
  P_STATUS := 'N';
  P_MESSAGE := '';
   
  select count(*)
    into vAuxiliar
  from tdvadm.t_glb_localidade lo
  where lo.glb_localidade_codigo = pLocOrigem;
  If vAuxiliar = 0 Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'Localidade ORIGEM nao existe ' || chr(10);
  End If;

  select count(*)
    into vAuxiliar
  from tdvadm.t_glb_localidade lo
  where lo.glb_localidade_codigo = pLocOrigem
    and glbadm.pkg_glb_util.F_ENUMERICO(lo.glb_localidade_codigoibge) = 'S';

  If vAuxiliar = 0 Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'IBGE ORIGEM nao existe ' || chr(10);
  End If;
    
  If vAuxiliar = 0 Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'Localidade ORIGEM nao existe ' || chr(10);
  End If;

  select count(*)
    into vAuxiliar
  from tdvadm.t_glb_localidade lo
  where lo.glb_localidade_codigo = pLocDestino;
  If vAuxiliar = 0 Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'Localidade DESTINO nao existe ' || chr(10);
  End If;
  
  select count(*)
    into vAuxiliar
  from tdvadm.t_glb_localidade lo
  where lo.glb_localidade_codigo = pLocDestino
    and glbadm.pkg_glb_util.F_ENUMERICO(lo.glb_localidade_codigoibge) = 'S';

  If vAuxiliar = 0 Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'IBGE DESTINO nao existe ' || chr(10);
  End If;

  If upper(pTipo) Not in ('L','A','F') Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'Tipo tem que ser (L) Lotacao (A) Ambos (F) Fracionado ' || chr(10);
  End If;
  
  select count(*)
    into vAuxiliar
  from tdvadm.t_usu_usuario lo
  where lo.usu_usuario_codigo = pUsuario;

  If vAuxiliar = 0 Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'Usuario não Existe ' || chr(10);
  End If;
  

  select count(*)
    into vAuxiliar
  from tdvadm.t_glb_cliente cl
  where cl.glb_cliente_cgccpfcodigo = pCnpjCli;

  If vAuxiliar = 0 Then
     P_STATUS := 'E';
     P_MESSAGE := P_MESSAGE || 'Cliente não Existe ' || chr(10);
  End If;
  

  
  If upper(pTipo) in ('A','L') Then
     insert into tdvadm.t_xml_clientelib cl
       (glb_cliente_cgccpfcodigo,
        xml_clientelib_dtvigencia,
        xml_clientelib_ativo,
        xml_clientelib_flagporto,
        xml_clientelib_flaggf,
        usu_usuario_codigo,
        xml_clientelib_flagaeroporto,
        glb_localidade_codigoori,
        glb_localidade_codigodes,
        fcf_tpcarga_codigo)
     Values
       (pCnpjCli,
        pVigencia,
        'S',
        'N',
        'S',
        pUsuario,
        'N',
        pLocOrigem,
        pLocDestino,
        '11');
  End If;    

  If upper(pTipo) in ('A','F') Then
     insert into tdvadm.t_xml_clientelib cl
       (glb_cliente_cgccpfcodigo,
        xml_clientelib_dtvigencia,
        xml_clientelib_ativo,
        xml_clientelib_flagporto,
        xml_clientelib_flaggf,
        usu_usuario_codigo,
        xml_clientelib_flagaeroporto,
        glb_localidade_codigoori,
        glb_localidade_codigodes,
        fcf_tpcarga_codigo)
     Values
       (pCnpjCli,
        pVigencia,
        'S',
        'N',
        'S',
        pUsuario,
        'N',
        pLocOrigem,
        pLocDestino,
        '12');
  End If;    


  
End SP_Insere_GrandeFluxo;


PROCEDURE SP_ASN_REENVIAEVENTO (P_ASN     IN  TDVADM.T_COL_ASN.COL_ASN_NUMERO%type,
                                  P_STATUS  OUT CHAR,
                                  P_MESSAGE OUT VARCHAR2) AS
                                                 
ID_ASN NUMBER(19);
ID_ARQ NUMBER(19);    
                                         
BEGIN

  Begin
  
  --*****************************************
  --* Rafael Aiti 24/08/2017    *
  --* Reenviar Evento ASN       *
  --*****************************************

  
  
 -- TABELA ABAIXO PARA PEGAR O ID DA ASN
  
    SELECT A.COL_ASN_ID     
      INTO ID_ASN   
      FROM TDVADM.T_COL_ASN A
     WHERE A.COL_ASN_NUMERO = P_ASN;
       
     
     SELECT A.COL_ASNARQUIVO_ID
       INTO ID_ARQ
       FROM TDVADM.T_COL_ASNARQUIVO A
      WHERE A.COL_ASN_ID = ID_ASN;
      
   UPDATE TDVADM.T_COL_ASNEVENTO EV
      SET EV.COL_ASNEVENTO_DTREQUEST = NULL,
          EV.COL_ASNEVENTO_DTRESPONSE = NULL,
          EV.COL_ASNEVENTO_PAYLOADREQUEST = NULL,
          EV.COL_ASNEVENTO_PAYLOADRESPONSE = NULL,
          EV.COL_ASNSTATUSEVT_ID = NULL
      WHERE EV.COL_ASNSTATUSEVT_ID = '2'
      AND EV.COL_ASNARQUIVO_ID = ID_ARQ;

EXCEPTION WHEN NO_DATA_FOUND THEN 
  
      P_STATUS:= 'E';
      P_MESSAGE:= 'Não foi possível localizar a ASN';

        WHEN OTHERS THEN       
      
      P_STATUS:='E';
      P_MESSAGE:= 'Erro na procedure';
END;      
      
END SP_ASN_REENVIAEVENTO;

PROCEDURE SP_ARM_CARREGVAZIO     (P_CARREG     IN  TDVADM.T_ARM_CARREGAMENTO.ARM_CARREGAMENTO_CODIGO%type,
                                  P_STATUS  OUT CHAR,
                                  P_MESSAGE OUT VARCHAR2) AS
                           
   vAuxiliar integer;
BEGIN

  --*****************************************
  --*     Rafael Aiti 07/03/2017    *
  --* Corrigir Carregamento Vazio   *
  --*****************************************
  
  
  P_MESSAGE := '';
  P_STATUS := 'N';
  vAuxiliar := 0;
  
  for c_msg in (SELECT NOTA.CON_CONHECIMENTO_CODIGO,
                       NOTA.CON_CONHECIMENTO_SERIE,
                       NOTA.GLB_ROTA_CODIGO,
                       CTE.ARM_CARREGAMENTO_CODIGO,
                       CTE.CON_CONHECIMENTO_DTEMBARQUE,
                       CA.ARM_CARREGAMENTO_DTCRIA
                FROM  TDVADM.T_ARM_CARREGAMENTODET CD,
                      TDVADM.T_ARM_NOTA NOTA,
                      TDVADM.T_CON_CONHECIMENTO CTE,
                      TDVADM.T_ARM_CARREGAMENTO CA
                WHERE CD.ARM_CARREGAMENTO_CODIGO = P_CARREG
                AND   NOTA.ARM_EMBALAGEM_NUMERO = CD.ARM_EMBALAGEM_NUMERO
                AND   NOTA.ARM_EMBALAGEM_FLAG = CD.ARM_EMBALAGEM_FLAG
                AND   NOTA.ARM_EMBALAGEM_SEQUENCIA = CD.ARM_EMBALAGEM_SEQUENCIA
                AND   NOTA.CON_CONHECIMENTO_CODIGO = CTE.CON_CONHECIMENTO_CODIGO
                AND   NOTA.CON_CONHECIMENTO_SERIE = CTE.CON_CONHECIMENTO_SERIE
                AND   NOTA.GLB_ROTA_CODIGO = CTE.GLB_ROTA_CODIGO
                AND   CD.ARM_CARREGAMENTO_CODIGO = CA.ARM_CARREGAMENTO_CODIGO)
                
    loop
  
    IF (c_msg.arm_carregamento_codigo is null) 
      or (c_msg.arm_carregamento_dtcria + 60 < c_msg.con_conhecimento_dtembarque)
      
      
      THEN
       
      UPDATE TDVADM.T_CON_CONHECIMENTO CTE
      SET CTE.ARM_CARREGAMENTO_CODIGO = P_CARREG
      WHERE CTE.CON_CONHECIMENTO_CODIGO = c_msg.con_conhecimento_codigo
      AND   CTE.CON_CONHECIMENTO_SERIE  = c_msg.con_conhecimento_serie
      AND   CTE.GLB_ROTA_CODIGO         = c_msg.glb_rota_codigo;
        
      P_MESSAGE := P_MESSAGE || C_MSG.CON_CONHECIMENTO_CODIGO || '-' || C_MSG.GLB_ROTA_CODIGO || CHR(10);      
      vAuxiliar := vAuxiliar + 1;
      
     END IF;

    End Loop;
    
--    if LENGTH(TRIM(P_MESSAGE)) >= 10 Then
    If vAuxiliar > 0 Then
       P_MESSAGE := 'CTe Alterados ' || chr(10) || P_MESSAGE;
       commit;
    Else
       P_MESSAGE := 'Nenhum CTe Alterado'; 
    End If;
    
    
    END SP_ARM_CARREGVAZIO;
 
    Procedure Sp_cria_cargadet (pNota In t_Arm_Nota.Arm_Nota_Numero%Type,
                                pCNPJ In t_arm_cargadet.glb_cliente_cgccpfremetente%Type,
                                pSeq  In tdvadm.t_arm_nota.arm_nota_sequencia%type)

  --*****************************************
  --*     Rafael Aiti 10/04/2018    *--
  --* Criar o registro na cargadet  *--
  --*****************************************

As
  vRowNota t_Arm_Nota%RowType;  
begin
  
  Select n.*
     Into vRowNota
     From t_arm_nota n
     where n.arm_nota_numero = pNota
       and trim(n.glb_cliente_cgccpfremetente) = trim(pCNPJ)
       and n.arm_nota_sequencia = pSeq
       and n.arm_nota_dtinclusao = (Select max(nn.arm_nota_dtinclusao)
                                       from t_arm_nota nn
                                       where nn.arm_nota_numero = n.arm_nota_numero
                                         and nn.glb_cliente_cgccpfremetente = n.glb_cliente_cgccpfremetente);
  
  
     insert into t_arm_cargadet (arm_carga_codigo,
                                 arm_cargadet_seq,
                                 arm_nota_numero,
                                 arm_embalagem_numero,
                                 arm_embalagem_flag,
                                 usu_usuario_codigo,
                                 arm_nota_sequencia,
                                 arm_embalagem_sequencia,
                                 glb_cliente_cgccpfremetente) 
      values( vRowNota.Arm_Carga_Codigo, 
              1,
              vRowNota.Arm_Nota_Numero,
              vRowNota.arm_embalagem_numero,
              vRowNota.Arm_Embalagem_Flag, 
              'jsantos',
              vRowNota.Arm_Nota_Sequencia,
              vRowNota.Arm_Embalagem_Sequencia,
              vRowNota.Glb_Cliente_Cgccpfremetente);  
  
End Sp_cria_cargadet;


procedure SP_CON_DESFATURAR
  as
  vStatus char(1);
  vMessage varchar2(1000);
Begin
  
   for c_msg in (select c.con_conhecimento_codigo,
                        c.con_conhecimento_serie,
                        c.glb_rota_codigo  
                 from tdvadm.t_con_conhecimento c
                 where c.con_conhecimento_dtembarque >= '01/01/2018'
                   and c.con_conhecimento_serie <> 'XXX'
                   and c.con_conhecimento_flagcancelado is null
                   and c.con_fatura_codigo is null
                   and 0 < (select count(*)
                            from tdvadm.t_con_fatura f
                            where f.con_fatura_codigo = c.con_conhecimento_codigo
                              and f.con_fatura_ciclo = '1'
                              and f.glb_rota_codigofilialimp = c.glb_rota_codigo)
                   and 0 < (select count(*)
                            from tdvadm.t_crp_titreceber tr
                            where tr.crp_titreceber_numtitulo = c.con_conhecimento_codigo
                              and tr.glb_rota_codigo = c.glb_rota_codigo))
  Loop
    
      tdvadm.pkg_con_fatura.SP_CON_DESFATURAR(c_msg.con_conhecimento_codigo,
                                              '1',
                                              c_msg.glb_rota_codigo,
                                              'F',
                                              vStatus,
                                              vMessage);
     If vStatus = 'E' Then
        vMessage := vMessage;
     End If;                                               
  End Loop;

  
End SP_CON_DESFATURAR;


FUNCTION FN_ATUALIZA_PERCURSO_VALE(P_DATA IN TDVADM.T_GLB_TESTESTR.GLB_TESTESTR_DTGRAV%TYPE,
                                   P_ERRO OUT VARCHAR2) RETURN VARCHAR AS
  vQtdePercurso integer;
  vQtdePercursoNormal integer;     
  vOrigemI tdvadm.t_slf_percurso.glb_localidade_codigoorigemi%type;
  vDestI   tdvadm.t_slf_percurso.glb_localidade_codigodestinoi%type;
  vDesc    tdvadm.t_slf_percurso.slf_percuso_descricao%type;
  vLocOriEst tdvadm.t_glb_localidade.glb_estado_codigo%type;
  vLocOriDesc tdvadm.t_glb_localidade.glb_localidade_descricao%type;
  vLocOriIbge tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
  vLocDestEst tdvadm.t_glb_localidade.glb_estado_codigo%type;
  vLocDestDesc tdvadm.t_glb_localidade.glb_localidade_descricao%type; 
  vLocDestIbge tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
  
begin
  -- Test statements here
  for p_cursor in (select t.glb_testestr_1,
                          t.glb_testestr_2,
                          t.glb_testestr_3,
                          t.glb_testestr_id
                     from tdvadm.t_glb_testestr t
                     where trunc(t.glb_testestr_dtgrav) = TRUNC(P_DATA))
  loop
    
    
     select count(*)
       into vQtdePercurso     
       from tdvadm.t_slf_percurso_2781910 pe
      where trim(pe.glb_localidade_codigoorigem)  = trim(p_cursor.glb_testestr_1)
        and trim(pe.glb_localidade_codigodestino) = trim(p_cursor.glb_testestr_2);
        
    BEGIN    
      IF(vQtdePercurso > 0) THEN
        UPDATE TDVADM.T_SLF_PERCURSO_2781910 U
           SET U.SLF_PERCURSO_KM = p_cursor.glb_testestr_3
         WHERE trim(U.GLB_LOCALIDADE_CODIGOORIGEM)  = trim(p_cursor.glb_testestr_1) 
           AND trim(U.GLB_LOCALIDADE_CODIGODESTINO) = trim(p_cursor.glb_testestr_2);
        COMMIT;
      ELSE
        BEGIN
          SELECT per.slf_percuso_descricao,
                 per.glb_localidade_codigoorigemi,
                 per.glb_localidade_codigodestinoi
            INTO vDesc,
                 vOrigemI,
                 vDestI
            from tdvadm.t_slf_percurso per
           where trim (per.glb_localidade_codigoorigem) = trim (p_cursor.glb_testestr_1)
             and trim (per.glb_localidade_codigodestino) = trim (p_cursor.glb_testestr_2)
             group by per.slf_percuso_descricao,
                 per.glb_localidade_codigoorigemi,
                 per.glb_localidade_codigodestinoi;
                                  
          BEGIN 
            INSERT INTO TDVADM.T_SLF_PERCURSO_2781910 VALUES (
                p_cursor.glb_testestr_1 || p_cursor.glb_testestr_2,
                vDesc,
                p_cursor.glb_testestr_1,
                p_cursor.glb_testestr_2,
                p_cursor.glb_testestr_3,
                'jsantos',
                sysdate,
                p_cursor.glb_testestr_3,
                vOrigemI,
                vDestI,
                NULL,
                'S',
                sysdate);
          EXCEPTION 
             WHEN  OTHERS THEN
               DBMS_OUTPUT.put_line ('NÃO FOI POSSÍVEL CADASTRAR KM');
          END;
          
          
        EXCEPTION 
           WHEN  NO_DATA_FOUND THEN
                ------------------------------------------------------------------
                ------ CADASTRAR NOVO, CASO NÃO EXISTA NA T_SLF_PERCURSO ---------
                ------------------------------------------------------------------
                select locorigem.Glb_Estado_Codigo,
                       locorigem.Glb_Localidade_Descricao,
                       locorigem.glb_localidade_codigoibge
                  into vLocOriEst, vLocOriDesc, vLocOriIbge
                  from tdvadm.t_glb_localidade locorigem
                 where TRIM(locorigem.glb_localidade_codigo) = TRIM(p_cursor.glb_testestr_1);
                
                select locdest.glb_estado_codigo,
                       locdest.glb_localidade_descricao,
                       locdest.glb_localidade_codigoibge
                  into vLocDestEst, vLocDestDesc,vLocDestIbge
                 from tdvadm.t_glb_localidade locdest
                where TRIM(locdest.Glb_Localidade_Codigo) = TRIM(p_cursor.glb_testestr_2);
            
          BEGIN 
              insert  into tdvadm.t_slf_percurso_2781910 values (
                     p_cursor.glb_testestr_1 || p_cursor.glb_testestr_2,
                     vLocOriEst || '-' || vLocOriDesc || '-' || vLocDestEst || '-'|| vLocDestDesc,
                     p_cursor.glb_testestr_1,
                     p_cursor.glb_testestr_2,
                     p_cursor.glb_testestr_3,
                    'jsantos',
                     sysdate,
                    p_cursor.glb_testestr_3,
                    vLocOriIbge,
                    vLocDestIbge,
                    NULL,
                    'S',
                    sysdate);
                    
          EXCEPTION  
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line ('NÃO FOI POSSSÍVEL CRIAR UM REGISTO NA TABELA TDVADM.T_SLF_PERCURSO_2781910' || p_cursor.glb_testestr_1||' - '||p_cursor.glb_testestr_2);
          END; 
        END;    
      END IF;    
    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('ERRO AO INSERIR/ATUALIZAR PERCURSO' || p_cursor.glb_testestr_1||' - '||p_cursor.glb_testestr_2||' - '||p_cursor.glb_testestr_3);
    END;
        	     
    dbms_output.put_line(p_cursor.glb_testestr_1||' - '||p_cursor.glb_testestr_2||' - '||p_cursor.glb_testestr_3||' - vQtdePercurso.: '||vQtdePercurso);
  end loop;
  return P_ERRO;
  
 end FN_ATUALIZA_PERCURSO_VALE;
 
 
FUNCTION FN_ATUALIZA_PERCURSO_VLI(P_DATA IN TDVADM.T_GLB_TESTESTR.GLB_TESTESTR_DTGRAV%TYPE,
                                   P_ERRO OUT VARCHAR2) RETURN VARCHAR AS
  vQtdePercurso integer;
  vQtdePercursoNormal integer;     
  vOrigemI tdvadm.t_slf_percurso.glb_localidade_codigoorigemi%type;
  vDestI   tdvadm.t_slf_percurso.glb_localidade_codigodestinoi%type;
  vDesc    tdvadm.t_slf_percurso.slf_percuso_descricao%type;
  vLocOriEst tdvadm.t_glb_localidade.glb_estado_codigo%type;
  vLocOriDesc tdvadm.t_glb_localidade.glb_localidade_descricao%type;
  vLocOriIbge tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
  vLocDestEst tdvadm.t_glb_localidade.glb_estado_codigo%type;
  vLocDestDesc tdvadm.t_glb_localidade.glb_localidade_descricao%type; 
  vLocDestIbge tdvadm.t_glb_localidade.glb_localidade_codigoibge%type;
  
begin
  -- Test statements here
  for p_cursor in (select t.glb_testestr_1,
                          t.glb_testestr_2,
                          t.glb_testestr_3,
                          t.glb_testestr_id
                     from tdvadm.t_glb_testestr t
                     where trunc(t.glb_testestr_dtgrav) = TRUNC(P_DATA))
  loop
    
    
     select count(*)
       into vQtdePercurso     
       from tdvadm.t_slf_percurso_91566 pe
      where trim(pe.glb_localidade_codigoorigem)  = trim(p_cursor.glb_testestr_1)
        and trim(pe.glb_localidade_codigodestino) = trim(p_cursor.glb_testestr_2);
        
    BEGIN    
      IF(vQtdePercurso > 0) THEN
        UPDATE TDVADM.T_SLF_PERCURSO_91566 U
           SET U.SLF_PERCURSO_KM = p_cursor.glb_testestr_3
         WHERE trim(U.GLB_LOCALIDADE_CODIGOORIGEM)  = trim(p_cursor.glb_testestr_1) 
           AND trim(U.GLB_LOCALIDADE_CODIGODESTINO) = trim(p_cursor.glb_testestr_2);
        COMMIT;
      ELSE
        BEGIN
          SELECT per.slf_percuso_descricao,
                 per.glb_localidade_codigoorigemi,
                 per.glb_localidade_codigodestinoi
            INTO vDesc,
                 vOrigemI,
                 vDestI
            from tdvadm.t_slf_percurso per
           where trim (per.glb_localidade_codigoorigem) = trim (p_cursor.glb_testestr_1)
             and trim (per.glb_localidade_codigodestino) = trim (p_cursor.glb_testestr_2)
             group by per.slf_percuso_descricao,
                 per.glb_localidade_codigoorigemi,
                 per.glb_localidade_codigodestinoi;
                                  
          BEGIN 
            INSERT INTO TDVADM.T_SLF_PERCURSO_91566 VALUES (
                p_cursor.glb_testestr_1 || p_cursor.glb_testestr_2,
                vDesc,
                p_cursor.glb_testestr_1,
                p_cursor.glb_testestr_2,
                p_cursor.glb_testestr_3,
                'jsantos',
                sysdate,
                p_cursor.glb_testestr_3,
                vOrigemI,
                vDestI,
                NULL,
                'S',
                sysdate);
          EXCEPTION 
             WHEN  OTHERS THEN
               DBMS_OUTPUT.put_line ('NÃO FOI POSSÍVEL CADASTRAR KM');
          END;
          
          
        EXCEPTION 
           WHEN  NO_DATA_FOUND THEN
                ------------------------------------------------------------------
                ------ CADASTRAR NOVO, CASO NÃO EXISTA NA T_SLF_PERCURSO ---------
                ------------------------------------------------------------------
                select locorigem.Glb_Estado_Codigo,
                       locorigem.Glb_Localidade_Descricao,
                       locorigem.glb_localidade_codigoibge
                  into vLocOriEst, vLocOriDesc, vLocOriIbge
                  from tdvadm.t_glb_localidade locorigem
                 where TRIM(locorigem.glb_localidade_codigo) = TRIM(p_cursor.glb_testestr_1);
                
                select locdest.glb_estado_codigo,
                       locdest.glb_localidade_descricao,
                       locdest.glb_localidade_codigoibge
                  into vLocDestEst, vLocDestDesc,vLocDestIbge
                 from tdvadm.t_glb_localidade locdest
                where TRIM(locdest.Glb_Localidade_Codigo) = TRIM(p_cursor.glb_testestr_2);
            
          BEGIN 
              insert  into tdvadm.t_slf_percurso_91566 values (
                     p_cursor.glb_testestr_1 || p_cursor.glb_testestr_2,
                     vLocOriEst || '-' || vLocOriDesc || '-' || vLocDestEst || '-'|| vLocDestDesc,
                     p_cursor.glb_testestr_1,
                     p_cursor.glb_testestr_2,
                     p_cursor.glb_testestr_3,
                    'jsantos',
                     sysdate,
                    p_cursor.glb_testestr_3,
                    vLocOriIbge,
                    vLocDestIbge,
                    NULL,
                    'S',
                    sysdate);
                    
          EXCEPTION  
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line ('NÃO FOI POSSSÍVEL CRIAR UM REGISTO NA TABELA TDVADM.T_SLF_PERCURSO_2781910' || p_cursor.glb_testestr_1||' - '||p_cursor.glb_testestr_2);
          END; 
        END;    
      END IF;    
    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('ERRO AO INSERIR/ATUALIZAR PERCURSO' || p_cursor.glb_testestr_1||' - '||p_cursor.glb_testestr_2||' - '||p_cursor.glb_testestr_3);
    END;
               
    dbms_output.put_line(p_cursor.glb_testestr_1||' - '||p_cursor.glb_testestr_2||' - '||p_cursor.glb_testestr_3||' - vQtdePercurso.: '||vQtdePercurso);
  end loop;
  return P_ERRO;
  
 end FN_ATUALIZA_PERCURSO_VLI;
 
 
FUNCTION FN_CORRIGE_FATOR_RATEIO(P_CARREG IN TDVADM.T_ARM_EMBALAGEM.ARM_CARREGAMENTO_CODIGO%TYPE,
                                   P_ERRO OUT VARCHAR2) RETURN VARCHAR AS
                                   
   
-- FUNÇÃO CRIADA POR FELIPE SOUSA E JONATAS VELOSO

 P_EMB_CARRG NUMBER;
 V_CONTA_EMB INTEGER;
 V_EMBALAGEM    TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE;
 V_NOTA         TDVADM.T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE;
 V_REMETENTE    TDVADM.T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE;
 V_JANELA       TDVADM.T_ARM_NOTA.ARM_JANELACONS_SEQUENCIA%TYPE;
 V_CHAVENFE     TDVADM.T_ARM_NOTA.ARM_NOTA_CHAVENFE%TYPE;
 V_PESO_BALANCA TDVADM.T_ARM_NOTA.ARM_NOTA_PESOBALANCA%TYPE; 
 V_PESO_NOTA    TDVADM.T_ARM_NOTA.ARM_NOTA_PESO%TYPE; 
 V_PESO_JANELA  TDVADM.T_ARM_JANELACONS.ARM_JANELACONS_PESOCONS%TYPE;    
 V_PESO_JANELACONS TDVADM.T_ARM_JANELACONS.ARM_JANELACONS_PESOCONS%TYPE;                            
 

BEGIN
  FOR P_EMB_CARRG IN (SELECT EMB.ARM_EMBALAGEM_NUMERO EMB_NUMERO
                         FROM TDVADM.T_ARM_EMBALAGEM EMB
                        WHERE EMB.ARM_CARREGAMENTO_CODIGO = P_CARREG) LOOP
                        
    BEGIN  
      V_PESO_JANELA := 0;
                            
      SELECT NOTA.ARM_NOTA_NUMERO,
             NOTA.GLB_CLIENTE_CGCCPFREMETENTE,
             NOTA.ARM_JANELACONS_SEQUENCIA,
             NOTA.ARM_NOTA_CHAVENFE,
             TRUNC(NOTA.ARM_NOTA_PESOBALANCA),
             TRUNC(NOTA.ARM_NOTA_PESO)
        INTO V_NOTA,
             V_REMETENTE,
             V_JANELA,
             V_CHAVENFE,
             V_PESO_BALANCA,
             V_PESO_NOTA
        FROM TDVADM.T_ARM_NOTA NOTA
       WHERE NOTA.ARM_EMBALAGEM_NUMERO = P_EMB_CARRG.EMB_NUMERO;

        
      IF (V_PESO_BALANCA <> V_PESO_NOTA) THEN 

        UPDATE TDVADM.T_ARM_NOTA NUP
           SET NUP.ARM_NOTA_PESO = V_PESO_BALANCA
         WHERE NUP.ARM_EMBALAGEM_NUMERO = P_EMB_CARRG.EMB_NUMERO;
        COMMIT;
           
        UPDATE TDVADM.T_ARM_NOTAPESAGEM PE
           SET PE.ARM_NOTA_PESO             = V_PESO_BALANCA,
               PE.ARM_NOTAPESAGEM_PESOTOTAL = V_PESO_BALANCA
         WHERE PE.ARM_NOTA_CHAVENFE = V_CHAVENFE;
        COMMIT;
      END IF;
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('Não encontrado na t_arm_nota, Embalagem: ' || P_EMB_CARRG.EMB_NUMERO );
      WHEN  OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE ('Embalagem não foi localizada' || P_EMB_CARRG.EMB_NUMERO);
    END;
     
      
    BEGIN
      SELECT SUM(TRUNC(NOTA2.ARM_NOTA_PESOBALANCA))
        INTO V_PESO_JANELA
        FROM TDVADM.T_ARM_NOTA NOTA2
       WHERE NOTA2.ARM_JANELACONS_SEQUENCIA = V_JANELA;
         
      SELECT JANELACO.ARM_JANELACONS_PESOCONS
        INTO V_PESO_JANELACONS
        FROM TDVADM.T_ARM_JANELACONS JANELACO
       WHERE JANELACO.ARM_JANELACONS_SEQUENCIA = V_JANELA;
         
      IF (V_PESO_JANELA <> V_PESO_JANELACONS) THEN
        UPDATE TDVADM.T_ARM_JANELACONS JC
           SET JC.ARM_JANELACONS_PESOCONS = V_PESO_JANELA
         WHERE JC.ARM_JANELACONS_SEQUENCIA = V_JANELA;
        COMMIT;
      END IF;
        
    EXCEPTION  
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não encontrado JANELA: ' || V_JANELA);
    END;

  END LOOP;
  RETURN 'N';
END FN_CORRIGE_FATOR_RATEIO;

PROCEDURE SP_SET_DTPROGFRACIONADOSEM(pPeriodo in date) AS
   vNovaDtProgramacao date;
   vAntigaDtProgramacao date;
   vHoraProgramacao tdvadm.t_arm_coleta.arm_coleta_hrprogramacao%type;
   vHora number; -- Para definição de regra por hora
   vHorasAtras number; -- Para pegar as coletas
   vColetaNum tdvadm.t_Arm_coleta.arm_coleta_ncompra%type;
   vColetaCiclo tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
   vPeriodo date;
begin
--------------------------------------------------------------------------------------------------
------- CREATE BY JONATAS VELOSO SIQUEIRA ----------- COLOCAR A DATA DE PROGRAMAÇÃO DA COLETA ----
------------------ 29/10/2018 ----------------------- CONFORME A REGRA DO FRACIONADO SEMANAL -----
--------------------------------------------------------------------------------------------------                                                

    if (pPeriodo is null)then
      vPeriodo := sysdate;
    else 
      vPeriodo := pPeriodo;
    end if;

    select c.usu_perfil_parat
      into vHorasAtras 
      From tdvadm.t_usu_perfil c
     where c.usu_perfil_codigo = 'COLPROGRAIZEN';

    for p_cursor in (SELECT C.ARM_COLETA_DTPROGRAMACAO + DECODE((cc.slf_cargascliente_semanacol-TO_CHAR(C.ARM_COLETA_DTPROGRAMACAO,'D')),-1,6
                                                                                                                       ,-2,5
                                                                                                                       ,-3,4
                                                                                                                       ,-4,3
                                                                                                                       ,-5,2
                                                                                                                       ,-6,1
                                                                                                                       ,(cc.slf_cargascliente_semanacol-TO_CHAR(C.ARM_COLETA_DTPROGRAMACAO,'D'))) novaDtProgramacao,
                             C.ARM_COLETA_DTPROGRAMACAO dtProgramacao,
                             c.arm_coleta_hrprogramacao horaProgramacao,
                             c.arm_coleta_ciclo coletaCiclo,
                             c.arm_coleta_ncompra coletaNum                                                                                                          
                        FROM TDVADM.T_ARM_COLETA C
                             ,tdvadm.t_slf_cargascliente cc
                       WHERE 0=0
                         and c.FCF_TPCARGA_CODIGO = '31'
                         and c.arm_coleta_dtgravacao >= TO_DATE(to_char(vPeriodo - (vHorasAtras/24), 'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
                         and trim(c.arm_coleta_cnpjpagadorferete) = trim(cc.glb_cliente_cgccpfcodigofor))LOOP
                        
    BEGIN  
    
    -- CASO SEJA A MESMA DATA JÁ EXISTENTE E A HORA DA PROGRAMAÇÃO SEJA MAIOR DO QUE O COMBINADO, INCLUIREMOS UMA SEMANA   
    -- CASO PRECISE COLOCAR REGRA DE HORÁRIO
    /**********************************************************
    IF(vNovaDtProgramacao = vAntigaDtProgramacao) then
      IF(to_number(substr(vHoraProgramacao,1,2)) >= vHora) then
        vNovaDtProgramacao := vNovaDtProgramacao+7;
      end if;
    end if;
    ************************************************************/  
         
    UPDATE TDVADM.T_ARM_COLETA C
       SET C.ARM_COLETA_DTPROGRAMACAO = p_cursor.novadtprogramacao
     WHERE C.ARM_COLETA_NCOMPRA = p_cursor.coletanum
       AND C.ARM_COLETA_CICLO   = p_cursor.coletaciclo;
         
    EXCEPTION
      when NO_DATA_FOUND then
        -- PARA NÃO FAZER NADA, CASO NÃO ENCONTRE FRACIONADO SEMANAL
        p_cursor.novadtprogramacao := NULL;
    End;  
  END LOOP;
END SP_SET_DTPROGFRACIONADOSEM;

Procedure sp_criaverbacalccte(pConhecimento in tdvadm.t_con_conhecimento.con_conhecimento_codigo%type,
                              pSerie in tdvadm.t_con_conhecimento.con_conhecimento_serie%type,
                              pRota in tdvadm.t_con_conhecimento.glb_rota_codigo%type)
 as                              
  i integer;
  vAliquota tdvadm.t_con_calcconhecimento.con_calcviagem_valor%type;
begin
  -- Pega os dados de cada CTe
  for c_msg in (select distinct c.con_conhecimento_codigo,
                                c.glb_rota_codigo,
                                c.con_conhecimento_serie, 
                                ca.slf_tpcalculo_codigo,
                                c.con_conhecimento_dtembarque,
                                lo.glb_estado_codigo uforig,
                                c.con_conhecimento_localcoleta,
                                ld.glb_estado_codigo ufdest,
                                c.con_conhecimento_localentrega,
                                tc.slf_tpcalculo_formulario
                from tdvadm.t_con_calcconhecimento ca,
                     tdvadm.t_con_conhecimento c,
                     tdvadm.t_slf_tpcalculo tc,
                     tdvadm.t_glb_localidade lo,
                     tdvadm.t_glb_localidade ld
                where c.con_conhecimento_codigo = ca.con_conhecimento_codigo
                  and c.con_conhecimento_serie = ca.con_conhecimento_serie
                  and c.glb_rota_codigo = ca.glb_rota_codigo
                  and ca.slf_tpcalculo_codigo = tc.slf_tpcalculo_codigo 
                  and tc.slf_tpcalculo_calculomae = 'S'
                  and c.con_conhecimento_localcoleta = lo.glb_localidade_codigo
                  and c.con_conhecimento_localentrega = ld.glb_localidade_codigo
                  and c.con_conhecimento_codigo = pConhecimento
                  and c.con_conhecimento_serie = pSerie
                  and c.glb_rota_codigo = pRota)
  Loop
       -- Devolvo as verbas apagadas
       insert into tdvadm.t_con_calcconhecimento
       SELECT c_msg.con_conhecimento_codigo,
              c_msg.con_conhecimento_serie,
              c_msg.glb_rota_codigo,
              CA.SLF_RECCUST_CODIGO,
              c_msg.slf_tpcalculo_codigo,
              '0001',
              RC.SLF_RECCUST_DESINECIA,
              NULL,
              0,
              '*',
              c_msg.con_conhecimento_dtembarque,
              NULL,
              NULL,
              null
       FROM TDVADM.T_SLF_CALCULO CA,
            TDVADM.T_SLF_RECCUST RC
       WHERE CA.SLF_TPCALCULO_CODIGO = c_msg.slf_tpcalculo_codigo
         AND CA.SLF_RECCUST_CODIGO = RC.SLF_RECCUST_CODIGO
         AND 0 = (SELECT COUNT(*)
                  FROM TDVADM.T_CON_CALCCONHECIMENTO C
                  WHERE C.CON_CONHECIMENTO_CODIGO = c_msg.con_conhecimento_codigo
                    AND C.CON_CONHECIMENTO_SERIE = c_msg.con_conhecimento_serie
                    AND C.GLB_ROTA_CODIGO = c_msg.glb_rota_codigo
                    AND C.SLF_RECCUST_CODIGO = CA.SLF_RECCUST_CODIGO);  

      -- Pega Aliquota de ICMS ou ISS
      If c_msg.slf_tpcalculo_formulario = 'C' Then
         select ic.slf_icms_aliquota
           into vAliquota
         from tdvadm.t_slf_icms ic
         where ic.glb_estado_codigoorigem = c_msg.uforig
           and ic.glb_estado_codigodestino = c_msg.ufdest
           and ic.slf_icms_dataefetiva = (select max(ic2.slf_icms_dataefetiva)
                                          from tdvadm.t_slf_icms ic2
                                          where ic2.glb_estado_codigoorigem = ic.glb_estado_codigoorigem
                                            and ic2.glb_estado_codigodestino = ic.glb_estado_codigodestino);
        update tdvadm.t_con_calcconhecimento ca
          set ca.con_calcviagem_valor = vAliquota
        where ca.con_conhecimento_codigo = c_msg.con_conhecimento_codigo
          and ca.con_conhecimento_serie = c_msg.con_conhecimento_serie
          and ca.glb_rota_codigo = c_msg.glb_rota_codigo
          and ca.slf_reccust_codigo = 'S_ALICMS'; 
      Else
        Begin
           select iss.slf_iss_aliquota
            into vAliquota
           from tdvadm.t_slf_iss iss
           where iss.glb_localidade_codigo = c_msg.con_conhecimento_localcoleta
             and c_msg.con_conhecimento_dtembarque between iss.glb_iss_datainicio and iss.glb_iss_datafinal;
        exception
          when NO_DATA_FOUND Then
             select iss.slf_iss_aliquota
               into vAliquota
             from tdvadm.t_slf_iss iss
             where iss.slf_iss_default = 'S';
          End;   
        update tdvadm.t_con_calcconhecimento ca
          set ca.con_calcviagem_valor = vAliquota
        where ca.con_conhecimento_codigo = c_msg.con_conhecimento_codigo
          and ca.con_conhecimento_serie = c_msg.con_conhecimento_serie
          and ca.glb_rota_codigo = c_msg.glb_rota_codigo
          and ca.slf_reccust_codigo = 'S_ALISS'; 
             
      End If;
      -- Calculo as Verbas
      TDVADM.PKG_SLF_CALCULOS.SP_MONTA_FORMULA_CNHC(c_msg.slf_tpcalculo_codigo,
                                                    c_msg.con_conhecimento_codigo,
                                                    c_msg.con_conhecimento_serie,
                                                    c_msg.glb_rota_codigo);
      
  
    
  End Loop;

end;


                              
Procedure sp_gercoleta_invalido as
  vStatus char;
  
  --------------------------------------RAFAEL AITI----------------------------------------------
  -----------------------CORRIGIR CARACTER INVALIDO NO GERENCIADOR DE COLETA---------------------
  --------------------------------------27/12/2018-----------------------------------------------
  begin
    
   update tdvadm.t_arm_coleta c
  set c.arm_coleta_obs = tdvadm.fn_limpa_campo2(c.arm_coleta_obs),
  c.arm_coleta_solicitante = tdvadm.fn_limpa_campo2(c.arm_coleta_solicitante),
  c.arm_coleta_fonesolic = tdvadm.fn_limpa_campo2(c.arm_coleta_fonesolic)
  where trunc(c.arm_coleta_dtprogramacao) >= sysdate - 30;
commit;

  update tdvadm.t_arm_coletancompra nc
  set nc.arm_coletancompra_mercadoria = tdvadm.fn_limpa_campo2(nc.arm_coletancompra_mercadoria)
  where ( nc.arm_coletancompra,
  nc.arm_coleta_ciclo) in (select c.arm_coleta_ncompra,
  c.arm_coleta_ciclo
  from tdvadm.t_arm_coleta c
  where trunc(c.arm_coleta_dtprogramacao) >= sysdate - 30);
commit;

 update tdvadm.t_arm_coleta c
  set c.arm_coleta_obs = tdvadm.fn_limpa_campo3(c.arm_coleta_obs),
  c.arm_coleta_solicitante = tdvadm.fn_limpa_campo3(c.arm_coleta_solicitante),
  c.arm_coleta_fonesolic = tdvadm.fn_limpa_campo3(c.arm_coleta_fonesolic)
  where trunc(c.arm_coleta_dtprogramacao) >= sysdate - 30;
commit;

  update tdvadm.t_arm_coletancompra nc
  set nc.arm_coletancompra_mercadoria = tdvadm.fn_limpa_campo3(nc.arm_coletancompra_mercadoria)
  where ( nc.arm_coletancompra,
  nc.arm_coleta_ciclo) in (select c.arm_coleta_ncompra,
  c.arm_coleta_ciclo
  from tdvadm.t_arm_coleta c
  where trunc(c.arm_coleta_dtprogramacao) >= sysdate - 30);
commit;

exception
  WHEN OTHERS Then
    vStatus := 'ERRO';
    
end sp_gercoleta_invalido;

PROCEDURE SP_ARM_DEDURACOLETAEMDUASNOTAS(pPeriodo in date) AS
   vColetaNum tdvadm.t_Arm_coleta.arm_coleta_ncompra%type;
   vColetaCiclo tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
   vContaEmail integer;
   vPeriodo date;
   vMessage varchar2(5000);
  
  begin
  ---------------------------------------------------------------------------------------------------
  ------- CREATE BY JONATAS VELOSO SIQUEIRA ----------- VER OS CASOS COM DUAS NOTAS COM A MESMA  ----
  ------------------ 10/01/2019 ----------------------- COLETA DA VALE, E NOS INFORMAR. -------------
  ---------------------------------------------------------------------------------------------------                                                
                     
    if (pPeriodo is null)then
      vPeriodo := sysdate;
    else 
      vPeriodo := pPeriodo;
    end if;
    
    vContaEmail := 0;

    FOR p_cursor in ( SELECT *
                        FROM (SELECT A.ARM_COLETA_NCOMPRA,
                                     A.ARM_COLETA_CICLO,
                                     COUNT(*) CONTAGEM
                                FROM TDVADM.T_COL_ASN A,
                                     TDVADM.T_ARM_NOTA N
                               WHERE A.ARM_COLETA_NCOMPRA = N.ARM_COLETA_NCOMPRA
                                 AND A.ARM_COLETA_CICLO   = N.ARM_COLETA_CICLO
                                 AND N.ARM_NOTA_DTINCLUSAO >= vPeriodo-(1/24)
                                 AND A.COL_ASN_DTGRAVACAO = (SELECT MAX(C2.COL_ASN_DTGRAVACAO)
                                                               FROM TDVADM.T_COL_ASN C2
                                                              WHERE C2.ARM_COLETA_NCOMPRA = A.ARM_COLETA_NCOMPRA
                                                                AND C2.ARM_COLETA_CICLO   = A.ARM_COLETA_CICLO)
                               GROUP BY A.ARM_COLETA_NCOMPRA,
                                        A.ARM_COLETA_CICLO) L
                       WHERE L.CONTAGEM >= 2)LOOP
                        
      BEGIN  
        vContaEmail := 1;  
        vColetaNum  := p_cursor.arm_coleta_ncompra;
        vColetaCiclo := p_cursor.arm_coleta_ciclo;    
    
      End;  
    END LOOP;
    
    IF(vContaEmail >= 1) then
      
        
       vMessage := 'Coleta: ' || vColetaNum || ' Ciclo: ' || vColetaCiclo ;
       wservice.pkg_glb_email.SP_ENVIAEMAIL('Coleta em mais de uma nota',
                                            vMessage,
                                            'tdv.producao@dellavolpe.com.br',
                                            trim('jonatas.veloso@dellavolpe.com.br;dgmoreira@dellavolpe.com.br'));
    ELSE
      vMessage := '';
    End if;
    
  
END SP_ARM_DEDURACOLETAEMDUASNOTAS;

PROCEDURE SP_JNT_TESTE(pPeriodo in date) AS
  vPeriodo date;
BEGIN
  BEGIN  
    INSERT INTO t_usu_usuario (usu_usuario_codigo) values ('jvsiqueira');
    commit;
  EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN
      vPeriodo := pPeriodo;
    when OTHERS THEN
      vPeriodo := pPeriodo;
  END;
END SP_JNT_TESTE;


 procedure sp_retira_impressao ( pValeFrete in tdvadm.t_con_valefrete.con_conhecimento_codigo%Type,
                                 pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%Type,
                                 pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%Type,
                                 pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%Type,
                                 pMensagem out varchar2) as
 
 /***************************************************************************************************
  * ROTINA           : sp_retira_impressao                                                           *
  * DESENVOLVIDA POR : Felipe Sousa                                                                  *
  * DATA DE CRIACAO  : 28/06/2019                                                                    *
  * FUNCINALIDADE    : Ritirar impressão do vale de frete                                            *
  ****************************************************************************************************/ 
  
  vImpresso tdvadm.t_con_valefrete.con_valefrete_impresso%Type;
  

 begin 
  
  select count (*)
    into vImpresso
    from tdvadm.t_con_valefrete v
   where v.con_conhecimento_codigo = pValeFrete
     and v.con_conhecimento_serie  = pSerie
     and v.glb_rota_codigo         = pRota
     and v.con_valefrete_saque     = pSaque
     and trim (v.con_valefrete_impresso)  = 'S';
   
 if (vImpresso > 0)  then
   
 execute immediate 'alter trigger tdvadm.TG_BIUD_VALEFRETEs disable';  
   
     update tdvadm.t_con_valefrete va
        set va.con_valefrete_impresso = null
      where va.con_conhecimento_codigo = pValeFrete
        and va.con_conhecimento_serie  = pSerie
        and va.glb_rota_codigo         = pRota
        and va.con_valefrete_saque     = pSaque;
        commit;
        
  pMensagem := 'RETIRADO COM SUCESSO';
    
  execute immediate 'alter trigger tdvadm.TG_BIUD_VALEFRETEs enable';
  
  else
    
  pMensagem := ('ERRO AO RETIRAR IMPRESSÃO DO VALE FRETE '|| pValeFrete||'-'||pSerie||'-'||pRota||'-'||pSaque|| ' NÃO ESTA IMPRESSO OU NÃO EXISTE');
   
  end if;
  
end sp_retira_impressao;

 /***************************************************************************************************
  * ROTINA           : sp_con_validapagamento                                                        *
  * DESENVOLVIDA POR : Felipe Sousa                                                                  *
  * DATA DE CRIACAO  : 12/08/2019                                                                    *
  * FUNCINALIDADE    : Validar os valores da aba CONTRATADO x FRETE ELETRONICO                       *
  * OBS              : É uma validação somente para pagamentos em cartão                             *
  ****************************************************************************************************/
  

Procedure sp_con_validapagamento ( pValeFrete in tdvadm.t_con_valefrete.con_conhecimento_codigo%Type,
                                   pSerie     in tdvadm.t_con_valefrete.con_conhecimento_serie%Type,
                                   pRota      in tdvadm.t_con_valefrete.glb_rota_codigo%Type,
                                   pSaque     in tdvadm.t_con_valefrete.con_valefrete_saque%Type,
                                   pMensagem out varchar2,
                                   pStatus out char ) as
                                   
  -- Varialves para entrar no primero IF
  vTp                                tdvadm.t_con_calcvalefrete.con_calcvalefretetp_codigo%Type;
  
  --- Variaveis de valores
  vAdtVf                             tdvadm.t_con_valefrete.con_valefrete_adiantamento%Type;
  vPedVf                             tdvadm.t_con_valefrete.con_valefrete_pedagio%Type;
  vSaldoVf                           tdvadm.t_con_valefrete.con_valefrete_valorliquido%Type;
  vSdCalc                            tdvadm.t_con_calcvalefrete.con_calcvalefrete_valor%Type;
  vAdtCalc                           tdvadm.t_con_calcvalefrete.con_calcvalefrete_valor%Type;

  --- Variaveis de descrição
  vTpdesAdt                          tdvadm.t_con_calcvalefretetp.con_calcvalefretetp_descricao%Type;
  vTpdesSd                           tdvadm.t_con_calcvalefretetp.con_calcvalefretetp_descricao%Type;
  

 begin
    
    select count (*)
      into vTp       
      from tdvadm.t_con_calcvalefrete cvf
     where cvf.con_conhecimento_codigo   = pValeFrete
       and cvf.con_conhecimento_serie    = pSerie
       and cvf.glb_rota_codigo           = pRota
       and cvf.con_valefrete_saque       = pSaque
       and cvf.con_calcvalefretetp_codigo in ('01','20');
   
 If  vTp in ('20','01')  then -- somente para pagamento de saldo e adiantemento.
   
 -- Deixando os paramentros de saida com status normal
 
  pMensagem := 'Normal';
  pStatus   := pkg_glb_common.Status_Nomal;
  
  -- Buscando os valores que estão na t_con_valefrete
  
  select
        nvl(vf.con_valefrete_adiantamento,0),
        nvl(vf.con_valefrete_pedagio,0),
        nvl(vf.con_valefrete_valorliquido,0)
  into  vAdtVf,
        vPedVf,
        vSaldoVf
  from tdvadm.t_con_valefrete vf
  where vf.con_conhecimento_codigo  = pValeFrete
  and vf.con_conhecimento_serie     = pSerie
  and vf.glb_rota_codigo            = pRota
  and vf.con_valefrete_saque        = pSaque;

--- Buscando o valor do adiantemento na t_con_calcvalefrete

  select nvl (cal.con_calcvalefrete_valor,0),
         tp.con_calcvalefretetp_descricao
     into vAdtCalc,
          vTpdesAdt
     from tdvadm.t_con_calcvalefrete cal,
          tdvadm.t_con_calcvalefretetp tp
    where cal.con_conhecimento_codigo    = pValeFrete
      and cal.con_conhecimento_serie     = pSerie
      and cal.glb_rota_codigo            = pRota
      and cal.con_valefrete_saque        = pSaque
      and cal.con_calcvalefretetp_codigo = '01' 
      and tp.con_calcvalefretetp_codigo  = cal.con_calcvalefrete_tipo; 
 
--- Buscando o valor do saldo na t_con_calcvalefrete
  

  select nvl (cal.con_calcvalefrete_valor,0),
         tp.con_calcvalefretetp_descricao
     into vSdCalc,
          vTpdesSd
     from tdvadm.t_con_calcvalefrete cal,
          tdvadm.t_con_calcvalefretetp tp
    where cal.con_conhecimento_codigo    = pValeFrete
      and cal.con_conhecimento_serie     = pSerie
      and cal.glb_rota_codigo            = pRota
      and cal.con_valefrete_saque        = pSaque
      and cal.con_calcvalefretetp_codigo = '20' 
      and tp.con_calcvalefretetp_codigo  = cal.con_calcvalefrete_tipo;   
     
     end if;
  
     /************************************************************/
     /***   SE VALOR PARC ADTO <> VALOR ADTO ABA CONTRATADOS   ***/
     /************************************************************/ 
             
    if  ((vTp = '20') and (vAdtVf-vPedVf <> vAdtCalc)) then
                                 
      pMensagem := ( 'O valor do '|| vTpdesAdt ||'esta com divergencia entre aba contratodos e frete eletronico! Valor que esta na aba contratodos é de ' ||vAdtVf-vPedVf||'já na aba do frete eletronico esta com o valor de ' ||vAdtCalc);
      pStatus   := pkg_glb_common.Status_Erro;
      return;
        
    end if;
     
       
   /************************************************************/
   /***   SE VALOR PARC SALD <> VALOR SALD ABA CONTRATADOS   ***/
   /************************************************************/
     
    if (vTp = '20') and (vSaldoVf  <> vSdCalc) then
                                 
        pMensagem := ( 'O valor do '|| vTpdesSd ||'esta com divergencia entre aba contratodos e frete eletronico! Valor que esta na aba contratodos é de ' ||vSaldoVf ||' já na aba do frete eletronico esta com o valor de '|| vSdCalc);
        pStatus   := pkg_glb_common.Status_Erro;
        return;
          
       end if;     
      
      
 end sp_con_validapagamento;
 
 Procedure sp_GLB_ATUALOCALSERVIDORIMG(pSistema   in  varchar2,
                                        pNovoLocal in varchar2,
                                        pQtdeCommit in integer default 1000,
                                        pStatus  out char,
                                        pMessage out varchar2)
  As                                      
    i integer;
    
  begin
    pStatus := 'N';
    If nvl(pNovoLocal,'ERR') = 'ERR' Then
       pStatus := 'E';
       pMessage := 'Parametros Errados';
    End If;
    If pStatus = 'N' Then
        If nvl(pSistema,'ERR') = 'CTE' Then
           -- Atualiza tabela de Conhecimento
            for c_msg in (select ci.rowid,
                                 ci.glb_compimagem_localservidor
                          from tdvadm.t_glb_compimagem ci
                          where ci.glb_compimagem_localservidor <> pNovoLocal
                          order by ci.glb_compimagem_disponivel desc)
            Loop
               
              c_msg.glb_compimagem_localservidor := pNovoLocal || SubStr(c_msg.glb_compimagem_localservidor,(length(c_msg.glb_compimagem_localservidor)-10),11);
            
              update tdvadm.t_glb_compimagem ci
                set ci.glb_compimagem_localservidor = c_msg.glb_compimagem_localservidor
              where ci.rowid = c_msg.rowid;
              i := i + 1;
              if mod(i,pQtdeCommit) = 0 Then
                commit;
              End If;
            End Loop;
        ElsIf nvl(pSistema,'ERR') = 'VF' Then
          -- Atualiza tabela dos Vales de Frete
            for c_msg in (select ci.rowid,
                                 ci.glb_vfimagem_localservidor
                          from tdvadm.t_glb_vfimagem ci
                          where nvl(ci.glb_vfimagem_localservidor,'XXX') <> pNovoLocal
                          order by ci.glb_vfimagem_disponivel desc)
            Loop
              update tdvadm.t_glb_vfimagem ci
                set ci.glb_vfimagem_localservidor = pNovoLocal || SubStr(c_msg.glb_vfimagem_localservidor,(length(c_msg.glb_vfimagem_localservidor)-10),11)
              where ci.rowid = c_msg.rowid;
              i := i + 1;
              if mod(i,pQtdeCommit) = 0 Then
                commit;
              End If;
            End Loop;
        End If;
        -- Gravacao Final;
        Commit;
        pMessage := 'Foram atualizadas ' || lpad(i,5,'0') || ' Imagens...';
    End If;
  exception
    When OTHERS Then
       pStatus := 'E';
       pMessage := 'Erro Inesperado ' || sqlerrm;
  end sp_GLB_ATUALOCALSERVIDORIMG;
   

END PKG_HD_UTILITARIO;
/
