CREATE OR REPLACE PROCEDURE sp_cax_movimento_acc
  (p_datainicial IN CHAR,   /* Formatted by PL/Formatter v.1.1.13 on 2001/01/29 17:29  (05:29 PM) */
   p_datafinal IN CHAR,
   p_datacaixa IN CHAR
   )
AS
 /* 
 * ----------------------------------------------------------------------------------------------
 *
 * SISTEMA          : Acerto de Contas
 * PROGRAMA         : SP_CAX_MOVIMENTO_ACC
 * ANALISTA         : Roberto Pariz
 * PROGRAMADOR      : Roberto Pariz
 * CRIACAO          : 14-02-2007
 * BANCO            : ORACLE
 * ALIMENTA         : t_cax_movimento, T_ACC_ACCONTAS
 * SIGLAS           : ACC,CON,GLB,CAX
 * EXECUCAO         : SP_CAX_MOVIMENTO_ACC({DATA_INICIAL},{DATA_FINAL},{DATA_CA},{MODO},{SUBROTINAS})
 * ATUALIZA         : Movimentos de caixa referentes aos acertos de contas ja executados.
 * PARTICULARIDADES : DATA_INICIAL - A partir da qual serão considerados os acertos para transferencia
 *                  : DATA_INICIAL - Limite até o qual serão considerados os acertos para transferencia
 *                  : DATA_CAIXA   - Serão utilizados mes e ano desta data para localizar o ultimo caixa aberto 
 *                  :                dentro desta referencia.
 *                  :
 *                  : Exemplo: SP_CAX_MOVIMENTO_ACC('01/01/2007','31/01/2007','01/02/2007')
 *                  : Transfere os acertos de Janeiro para O caixa em aberto de Fevereiro
 *                  :
 * ALTERACAO        : Passou a transferir para o caixa, valores dos vazios constantes nos acertos.
 *                  : Roberto Pariz - 15/01/2015
 *                  : 
 *                  : Centro de Custo fixo para os Acertos 3069
 *                  : Sirlano - 15/02/2017
 *                  :
 *                  : Não insere mais o Vazio nos caixas
 *                  : Sirlano 09/03/2017
 *                  :
 *                  : Não será mais lancado a diferenca do Acerto de Contas e sim a Diferenca em Vales e Despesas
 *                  : Sirlano 09/03/2017
 * ----------------------------------------------------------------------------------------------
 */

-- v_caixa        date;
v_sequencia    integer;
v_caxdescricao varchar2(200);
v_acerto       t_acc_acontas.acc_acontas_numero%TYPE;
v_ciclo        t_acc_acontas.acc_contas_ciclo%TYPE;
v_motorista    varchar2(50);
v_vazio        number(10,2); 
v_frota        char(7);
pStatus        char(1) := 'N';
pMessage       varchar2(100);
vUsaCC         char(1);
vCentroCusto   tdvadm.t_cax_movimento.glb_centrocusto_codigo%type;
vTotalDespesas number;
vTotalVales    number; 
vDiferenca     number;
v_Caixa        date;
vAuxiliar      number;
vOpINSS_ISS    tdvadm.t_cax_operacao.cax_operacao_codigo%type;
vOpIRRF        tdvadm.t_cax_operacao.cax_operacao_codigo%type;

 -- ACERTO DE CONTAS 

 CURSOR c_acerto
 IS
    SELECT a.acc_acontas_numero, 
           a.acc_contas_ciclo,
           m.frt_motorista_nome, 
           a.frt_conjveiculo_codigo,
           a.acc_acontas_valor_receita,
           a.acc_acontas_valor_comissao,
           a.acc_acontas_diferenca
      FROM tdvadm.t_acc_acontas a,
           tdvadm.t_frt_motorista m
     WHERE a.frt_motorista_codigo = m.frt_motorista_codigo
       AND TRUNC (a.acc_acontas_data) BETWEEN to_date(p_datainicial,'dd/mm/yyyy') AND to_date(p_datafinal,'dd/mm/yyyy')
       AND NVL(a.acc_acontas_datatransf,'01/01/1900') = '01/01/1900';

 -- DESPESAS 

 CURSOR c_despesas IS
 SELECT d.cax_operacao_codigo,
        d.acc_despesas_numero,
        d.acc_despesas_valor,
        d.acc_acontas_numero,
        d.acc_despesas_inss,
        d.acc_despesas_irrf,
        glb_rota_codigo_operacao,
        d.acc_despesas_fornecedor,
        d.glb_fornecedor_cgccpf
   FROM tdvadm.t_acc_despesas d
  WHERE d.acc_acontas_numero = v_acerto
    AND d.acc_contas_ciclo = v_ciclo
    AND d.acc_debitado_flag = 'N';
    
 -- VALES 

 CURSOR c_vales IS
 SELECT v.cax_operacao_codigo,
        v.acc_vales_numero,
        v.glb_rota_codigo,
        v.acc_vales_valor,
        v.acc_acontas_numero,
        v.glb_rota_codigo_operacao,
        v.cax_boletim_data,
        v.glb_rota_codigocax,
        v.cax_movimento_sequencia
   FROM tdvadm.t_acc_vales v
  WHERE v.acc_acontas_numero = v_acerto
    AND v.acc_contas_ciclo = v_ciclo;

BEGIN

     --EXECUTE IMMEDIATE('alter trigger TG_BIU_E_TRAVA_PROPNAOCAD disable');
     
---------     DELETE t_cax_movimento;

  -- PEGA O BOLETIM DO ULTIMO CAIXA QUE ESTA EM ABERTO
  -- Que contenha algum documento que não seja vale transferido das filiais
  
  select max(b.CAX_BOLETIM_DATA) BOLETIM
    into v_caixa 
    from tdvadm.t_cax_boletim b,
         tdvadm.t_cax_movimento m
   WHERE b.GLB_ROTA_CODIGO = '015'
     --AND b.CAX_BOLETIM_STATUS IN ('A','R')
     -- Pega o Primeiro dia do mes
     and b.CAX_BOLETIM_DATA >= TRUNC(last_day(add_months(p_datafinal,-1))+1)
     -- Pega caixas menores que hoje
     AND b.CAX_BOLETIM_DATA <= TRUNC(SYSDATE)
     and b.glb_rota_codigo = m.glb_rota_codigo
     and b.cax_boletim_data = m.cax_boletim_data
     and m.cax_operacao_codigo not in ('1127','2412');

      

  If v_caixa Is Not Null Then
 
     update tdvadm.t_cax_boletim b
       set b.cax_boletim_status = 'R'
     where b.GLB_ROTA_CODIGO = '015'
       and b.cax_boletim_data = v_caixa;

  Else
      select max(b.CAX_BOLETIM_DATA) BOLETIM
        into v_caixa 
        from tdvadm.t_cax_boletim b,
             tdvadm.t_cax_movimento m
       WHERE b.GLB_ROTA_CODIGO = '015'
         AND b.CAX_BOLETIM_STATUS IN ('A','R')
         AND b.CAX_BOLETIM_DATA <= TRUNC(SYSDATE)
         and b.glb_rota_codigo = m.glb_rota_codigo
         and b.cax_boletim_data = m.cax_boletim_data;
  End If;    

  if v_caixa is null then
      raise_application_error(-20001,'Não ha caixa aberto para receber a transferencia!');
  end if;
  
  
  /**************************************************************************************/
           -- Verifico se existe fechamento de acerto nesta data
           select count(*)
             into vAuxiliar
           from tdvadm.t_acc_acontas ac
           where ac.acc_acontas_datatransf = v_caixa;

           If vAuxiliar > 0 Then
              -- remove as linhas do Acerto.

              tdvadm.pkg_ctb_caixa.vReversaoCaixa015 := 'S';
              -- para que as Trigger TDVADM.TG_BD_CAX_MOVIMENTO, TDVADM.TG_BUD_ACC_ACONTAS nao atrapalhe

              delete tdvadm.t_cax_movimento m
              where m.cax_boletim_data = v_caixa
                and m.glb_rota_codigo = '015'
                and m.cax_movimento_origem = 'O'
                and m.cax_movimento_contabil = 'S'
                and m.cax_movimento_usuario = 'jsantos';
                
              update tdvadm.t_cax_movimento m
                set m.cax_movimento_documentoref = null
              where m.cax_movimento_documentoref in (select ac.acc_acontas_numero || '-' || ac.acc_contas_ciclo 
                                                     from tdvadm.t_acc_acontas ac 
                                                     where ac.acc_acontas_datatransf = v_caixa);
           
              update tdvadm.t_acc_acontas ac
                set  ac.acc_acontas_datatransf = null
              where ac.acc_acontas_datatransf = v_caixa ; 

              tdvadm.pkg_ctb_caixa.vReversaoCaixa015 := 'N';
           End If;                 
/*********************************************************************************************************/  
  
  

--  v_caixa := to_date('13/02/2015');


  v_sequencia := 0;
  v_caxdescricao := '';
  vUsaCC         := 'N';
  vCentroCusto   := '3066'; -- FROTAS PROPRIA CAVALO
  
  -- CALCULA SEQUENCIA PARA ENTRADAS NO CAIXA 

  SELECT NVL(MAX (m.cax_movimento_sequencia) + 1, 1)
    INTO v_sequencia
    FROM tdvadm.t_cax_movimento m
   WHERE TRUNC (m.cax_boletim_data) = v_caixa
     and m.glb_rota_codigo = '015';
   IF v_sequencia IS NULL
   THEN
      v_sequencia := 1;
   END IF;

   -- PROCESSA DADOS DOS ACERTOS DE CONTAS
     
   FOR r_acerto IN c_acerto LOOP

     -- VARIAVEIS DO ACERTO DE CONTAS

     v_acerto    := r_acerto.acc_acontas_numero;
     v_ciclo     := r_acerto.acc_contas_ciclo;
     v_motorista := r_acerto.frt_motorista_nome;
     v_frota     := r_acerto.frt_conjveiculo_codigo;

     -- Não será mais incluido no Caixa o Vazio
     If to_date(v_caixa,'dd/mm/yyyy') <= to_date('28/02/2017') Then 
         BEGIN
            select sum(nvl(mvz.frt_movvazio_valor,0)),
                   mt.frt_motorista_nome
              into v_vazio,
                   v_motorista
              from t_frt_movvazio mvz,
                   t_frt_motorista mt
             where mvz.frt_motorista_codigo = mt.frt_motorista_codigo
               and mvz.acc_acontas_numero = v_acerto
               and mvz.acc_contas_ciclo   = v_ciclo
              group by mt.frt_motorista_nome;
          EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_vazio := 0;
            WHEN TOO_MANY_ROWS Then
--               v_vazio := 30;
--               v_motorista := 'EDUARDO SOARES'; 
                 raise_application_error(-20011,'Verificar este acerto ' ||  v_acerto || '-' || v_ciclo);
          END;

          IF V_VAZIO > 0 THEN

            -- COMPOSIÇÃO DO HISTORICO DE VAZIOS

            SELECT o.cax_operacao_historico,
                   o.cax_operacao_ccusto
              INTO v_caxdescricao,
                   vUsaCC
              FROM tdvadm.t_cax_operacao o
             WHERE o.cax_operacao_codigo      = '2000'
               AND o.glb_rota_codigo_operacao = '015';

            v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (v_motorista));
            v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (v_frota));
            v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
            v_caxdescricao := substr(v_caxdescricao,1,50);

            -- INSERE DADOS DOS VAZIOS 

            INSERT INTO tdvadm.t_cax_movimento (glb_rota_codigo,
                                             cax_boletim_data,
                                             cax_movimento_sequencia,
                                             glb_rota_codigo_ccust,
                                             glb_rota_codigo_referencia,
                                             glb_rota_codigo_operacao,
                                             cax_movimento_documento,
                                             cax_operacao_codigo,
                                             cax_movimento_historico,
                                             cax_movimento_valor,
                                             cax_movimento_frend,
                                             cax_movimento_usuario,
                                             cax_movimento_historicoc,
                                             cax_movimento_historicop,
                                             glb_centrocusto_codigo,
                                             cax_movimento_contabil,
                                             cax_movimento_origem,
                                             cax_movimento_documentoref 
                                            )
                                    VALUES ('015',
                                            v_caixa,
                                            v_sequencia,
                                            '015',
                                            '015',
                                            '015',
                                            v_acerto,
                                            '2000',
                                            substr(v_caxdescricao,1,50),
                                            v_vazio,
                                            'N',
                                            'jsantos',
                                            v_motorista,
                                            trim(substr(v_caxdescricao,1,50)),
                                            decode(vUsaCC,'S',vCentroCusto,null),
                                            'S',
                                            'O',
                                            r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
                                            );

            v_sequencia := v_sequencia + 1;                     
            end if;
        End If;
      --INSERE DADOS DAS DESPESAS

      vTotalDespesas := 0;
      FOR r_despesas IN c_despesas LOOP

        -- COMPOSIÇÃO DO HISTORICO DE DESPESAS
 
          SELECT o.cax_operacao_historico,
                 o.cax_operacao_ccusto
            INTO v_caxdescricao,
                 vUsaCC
          FROM t_cax_operacao O
         WHERE cax_operacao_codigo      = r_despesas.cax_operacao_codigo
           AND glb_rota_codigo_operacao = r_despesas.glb_rota_codigo_operacao;
           
           If r_despesas.cax_operacao_codigo = '2046' Then
              vOpINSS_ISS := '1037';
              vOpIRRF     := '1036';
           Else
              vOpINSS_ISS := '1112';
              vOpIRRF     := '1111';
           End If;   

        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#0',trim (r_despesas.acc_despesas_numero));
-- Trocado para o Beneficiario do RPA em 01/03/2017
--        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (v_motorista));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (r_despesas.acc_despesas_fornecedor));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (v_frota));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
        v_caxdescricao := substr(v_caxdescricao,1,50);

        -- INSERT DO VALOR DAS DESPESAS MAIS IMPOSTOS NO MOVIMENTO NO CAIXA
        vTotalDespesas := vTotalDespesas + NVL(r_despesas.acc_despesas_valor,0)+NVL(r_despesas.acc_despesas_inss,0)+NVL(r_despesas.acc_despesas_irrf,0);
        INSERT INTO tdvadm.t_cax_movimento (
                    glb_rota_codigo,
                    cax_boletim_data,
                    cax_movimento_sequencia,
                    glb_rota_codigo_ccust,
                    glb_rota_codigo_referencia,
                    glb_rota_codigo_operacao,
                    cax_movimento_documento,
                    cax_operacao_codigo,
                    cax_movimento_historico,
                    cax_movimento_valor,
                    cax_movimento_frend,
                    cax_movimento_usuario,
                    cax_movimento_historicoc,
                    cax_movimento_historicop,
                    glb_centrocusto_codigo,
                    cax_movimento_contabil,
                    cax_movimento_origem,
                    cax_movimento_documentoref,
                    cax_movimento_cgccpf,
                    cax_movimento_favorecido   
                    )
             VALUES (
                '015',
                v_caixa,
                v_sequencia,
                '015',
                '015',
                r_despesas.glb_rota_codigo_operacao,
                r_despesas.acc_acontas_numero,
                r_despesas.cax_operacao_codigo,
                trim(substr(v_caxdescricao,1,50)),
                NVL(r_despesas.acc_despesas_valor,0)+NVL(r_despesas.acc_despesas_inss,0)+NVL(r_despesas.acc_despesas_irrf,0),
                'N',
                'jsantos',
                v_motorista,
                trim(substr(v_caxdescricao,1,50)),
                decode(vUsaCC,'S',vCentroCusto,null),
                'S',
                'O',
                r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo,
                r_despesas.glb_fornecedor_cgccpf,
                r_despesas.acc_despesas_fornecedor);
        v_sequencia := v_sequencia + 1;


        -- INSERT DO VALOR DO INSS DAS DESPESAS NO MOVIMENTO NO CAIXA

        IF NVL(r_despesas.acc_despesas_inss,0) <> 0 THEN

          vTotalDespesas := vTotalDespesas - r_despesas.acc_despesas_inss;
          INSERT INTO t_cax_movimento (
                      glb_rota_codigo,
                      cax_boletim_data,
                      cax_movimento_sequencia,
                      glb_rota_codigo_ccust,
                      glb_rota_codigo_referencia,
                      glb_rota_codigo_operacao,
                      cax_movimento_documento,
                      cax_operacao_codigo,
                      cax_movimento_historico,
                      cax_movimento_valor,
                      cax_movimento_frend,
                      cax_movimento_usuario,
                      cax_movimento_historicoc,
                      cax_movimento_historicop,
                      glb_centrocusto_codigo,
                      cax_movimento_contabil,
                      cax_movimento_origem,
                      cax_movimento_documentoref,
                      cax_movimento_cgccpf,
                      cax_movimento_favorecido   
                      )
               VALUES (
                  '015',
                  v_caixa,
                  v_sequencia,
                  '015',
                  '015',
                  '000',
                  r_despesas.acc_acontas_numero,
                  vOpINSS_ISS,
                  trim(substr(v_caxdescricao,1,50)),
                  NVL(r_despesas.acc_despesas_inss,0),
                  'N',
                  'jsantos',
                  v_motorista,
                  trim(substr(v_caxdescricao,1,50)),
                  decode(vUsaCC,'S',vCentroCusto,null),
                  'S',
                  'O',
                  r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo,
                  r_despesas.glb_fornecedor_cgccpf,
                  r_despesas.acc_despesas_fornecedor );
          v_sequencia := v_sequencia + 1;

        END IF;

        -- INSERT DO VALOR DO IRRF DAS DESPESAS NO MOVIMENTO NO CAIXA

        IF NVL(r_despesas.acc_despesas_irrf,0) <> 0 THEN

          vTotalDespesas := vTotalDespesas - r_despesas.acc_despesas_irrf;
          INSERT INTO t_cax_movimento (
                      glb_rota_codigo,
                      cax_boletim_data,
                      cax_movimento_sequencia,
                      glb_rota_codigo_ccust,
                      glb_rota_codigo_referencia,
                      glb_rota_codigo_operacao,
                      cax_movimento_documento,
                      cax_operacao_codigo,
                      cax_movimento_historico,
                      cax_movimento_valor,
                      cax_movimento_frend,
                      cax_movimento_usuario,
                      cax_movimento_historicoc,
                      cax_movimento_historicop,
                      glb_centrocusto_codigo,
                      cax_movimento_contabil,
                      cax_movimento_origem,
                      cax_movimento_documentoref,
                      cax_movimento_cgccpf,
                      cax_movimento_favorecido   
                      )
               VALUES (
                  '015',
                  v_caixa,
                  v_sequencia,
                  '015',
                  '015',
                  '000',
                  r_despesas.acc_acontas_numero,
                  vOpIRRF,
                  trim(substr(v_caxdescricao,1,50)),
                  NVL(r_despesas.acc_despesas_irrf,0),
                  'N',
                  'jsantos',
                  v_motorista,
                  trim(substr(v_caxdescricao,1,50)),
                  decode(vUsaCC,'S',vCentroCusto,null),
                  'S',
                  'O',
                  r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo,
                  r_despesas.glb_fornecedor_cgccpf,
                  r_despesas.acc_despesas_fornecedor);
          v_sequencia := v_sequencia + 1;

        END IF;

        END LOOP; -- DESPESAS

      --INSERE DADOS DOS VALES
      vTotalVales := 0;
      FOR r_vales IN c_vales LOOP

        -- COMPOSIÇÃO DO HISTORICO DOS VALES
 
         SELECT o.cax_operacao_historico,
                o.cax_operacao_ccusto
           INTO v_caxdescricao,
                vUsaCC
          FROM t_cax_operacao O
         WHERE cax_operacao_codigo      = '2600'
           AND glb_rota_codigo_operacao = '000';

        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#0',trim (v_acerto));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (v_motorista));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (v_frota));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
        v_caxdescricao := substr(v_caxdescricao,1,50);

        -- INSERT DO MOVIMENTO NO CAIXA - BAIXA DO VALE POR ACERTO DE CONTAS
        vTotalVales := vTotalVales + r_vales.acc_vales_valor;
        INSERT INTO t_cax_movimento (
                    glb_rota_codigo,
                    cax_boletim_data,
                    cax_movimento_sequencia,
                    glb_rota_codigo_ccust,
                    glb_rota_codigo_referencia,
                    glb_rota_codigo_operacao,
                    cax_movimento_documento,
                    cax_operacao_codigo,
                    cax_movimento_historico,
                    cax_movimento_valor,
                    cax_movimento_frend,
                    cax_movimento_usuario,
                    cax_movimento_historicoc,
                    cax_movimento_historicop,
                    glb_centrocusto_codigo,
                    cax_movimento_contabil,
                    cax_movimento_origem,
                    cax_movimento_documentoref 
                    )
             VALUES (
                '015',
                v_caixa,
                v_sequencia,
                '015',
                '015',
                '000',
                r_vales.acc_vales_numero,
                '2600',
                trim(substr(v_caxdescricao,1,50)),
                r_vales.acc_vales_valor,
                'N',
                'jsantos',
                v_motorista,
                trim(substr(v_caxdescricao,1,50)),
                decode(vUsaCC,'S',vCentroCusto,null),
                'S',
                'O',
                r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
                );
        v_sequencia := v_sequencia + 1;

        -- COMPOSIÇÃO DO HISTORICO DOS VALES
 
          SELECT o.cax_operacao_historico,
                 o.cax_operacao_ccusto
            INTO v_caxdescricao,
                 vUsaCC
          FROM t_cax_operacao O
         WHERE cax_operacao_codigo      = '1300'
           AND glb_rota_codigo_operacao = '000';

        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#0',trim (r_vales.acc_vales_numero));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (v_motorista));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (v_frota));
        v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
        v_caxdescricao := substr(v_caxdescricao,1,50);

        -- INSERT DO MOVIMENTO NO CAIXA - ENTRADA DO VALE POR ACERTO DE CONTAS

        INSERT INTO t_cax_movimento (
                    glb_rota_codigo,
                    cax_boletim_data,
                    cax_movimento_sequencia,
                    glb_rota_codigo_ccust,
                    glb_rota_codigo_referencia,
                    glb_rota_codigo_operacao,
                    cax_movimento_documento,
                    cax_operacao_codigo,
                    cax_movimento_historico,
                    cax_movimento_valor,
                    cax_movimento_frend,
                    cax_movimento_usuario,
                    cax_movimento_historicoc,
                    cax_movimento_historicop,
                    glb_centrocusto_codigo,
                    cax_movimento_contabil,
                    cax_movimento_origem,
                    cax_movimento_documentoref 
                    )
             VALUES (
                '015',
                v_caixa,
                v_sequencia,
                '015',
                '015',
                '000',
                v_acerto,
                '1300',
                trim(substr(v_caxdescricao,1,50)),
                r_vales.acc_vales_valor,
                'N',
                'jsantos',
                v_motorista,
                trim(substr(v_caxdescricao,1,50)),
                decode(vUsaCC,'S',vCentroCusto,null),
                'S',
                'O',
                r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
                );
        v_sequencia := v_sequencia + 1;

         update tdvadm.t_cax_movimento m
           set m.cax_movimento_documentoref = r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
         where m.glb_rota_codigo = '015'
--           and m.cax_boletim_data = r_vales.cax_boletim_data
           and m.glb_rota_codigo_referencia = r_vales.glb_rota_codigo
           and m.cax_movimento_documento = r_vales.acc_vales_numero
           and m.cax_movimento_valor = r_vales.acc_vales_valor
           and m.cax_operacao_codigo = '1127';


        END LOOP; -- VALES

      -- INSERT DO RESULTADO DO ACERTO DE CONTAS
      
      -- Verifica a Diferença
      
      If  v_acerto in ('30004375','30004496','30004518','30004568') Then
          v_acerto := v_acerto;
      End If;

      
      vDiferenca := vTotalVales - vTotalDespesas;
        
      If to_date(v_caixa,'dd/mm/yyyy') > to_date('28/02/2017','dd/mm/yyyy') Then  
          if vDiferenca <> 0 then

            if vDiferenca > 0 then
              
              SELECT o.cax_operacao_historico,
                     o.cax_operacao_ccusto
                INTO v_caxdescricao,
                     vUsaCC
                FROM t_cax_operacao O
               WHERE cax_operacao_codigo = '2120'
                 AND glb_rota_codigo_operacao = '000';
              
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#0',trim ('AC:'||r_acerto.acc_acontas_numero));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (r_acerto.frt_motorista_nome));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (r_acerto.frt_conjveiculo_codigo));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
              v_caxdescricao := substr(v_caxdescricao,1,50);

              INSERT INTO t_cax_movimento (
                          glb_rota_codigo,
                          cax_boletim_data,
                          cax_movimento_sequencia,
                          glb_rota_codigo_ccust,
                          glb_rota_codigo_referencia,
                          glb_rota_codigo_operacao,
                          cax_movimento_documento,
                          cax_operacao_codigo,
                          cax_movimento_historico,
                          cax_movimento_valor,
                          cax_movimento_frend,
                          cax_movimento_usuario,
                          cax_movimento_historicoc,
                          cax_movimento_historicop,
                          glb_centrocusto_codigo,
                          cax_movimento_contabil,
                          cax_movimento_origem,
                          cax_movimento_documentoref 
                          )
                   VALUES (
                          '015',
                          v_caixa,
                          v_sequencia,
                          '015',
                          '015',
                          '000',
                          r_acerto.acc_acontas_numero,
                          '2120',
                          trim(substr(v_caxdescricao,1,50)),
                          abs(vDiferenca),
                          'N',
                          'jsantos',
                           v_motorista,
                           trim(substr(v_caxdescricao,1,50)),
                           decode(vUsaCC,'S',vCentroCusto,null),
                           'S',
                           'O',
                           r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
                          );
            else
              SELECT o.cax_operacao_historico,
                     o.cax_operacao_ccusto
                INTO v_caxdescricao,
                     vUsaCC
                FROM t_cax_operacao O
               WHERE cax_operacao_codigo = '1057'
                 AND glb_rota_codigo_operacao = '000';
                   
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#0',trim ('AC:'||r_acerto.acc_acontas_numero));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (r_acerto.frt_motorista_nome));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (r_acerto.frt_conjveiculo_codigo));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
              v_caxdescricao := substr(v_caxdescricao,1,50);

                INSERT INTO tdvadm.t_cax_movimento (
                            glb_rota_codigo,
                            cax_boletim_data,
                            cax_movimento_sequencia,
                            glb_rota_codigo_ccust,
                            glb_rota_codigo_referencia,
                            glb_rota_codigo_operacao,
                            cax_movimento_documento,
                            cax_operacao_codigo,
                            cax_movimento_historico,
                            cax_movimento_valor,
                            cax_movimento_frend,
                            cax_movimento_usuario,
                            cax_movimento_historicoc,
                            cax_movimento_historicop,
                            glb_centrocusto_codigo,
                            cax_movimento_contabil,
                            cax_movimento_origem,
                            cax_movimento_documentoref 
                            )
                     VALUES (
                            '015',
                             v_caixa,
                             v_sequencia,
                             '015',
                             '015',
                             '000',
                             r_acerto.acc_acontas_numero,
                             '1057',
                             trim(substr(v_caxdescricao,1,50)),
                             abs(vDiferenca),
                             'N',
                             'jsantos',
                             v_motorista,
                             trim(substr(v_caxdescricao,1,50)),
                             decode(vUsaCC,'S',vCentroCusto,null),
                             'S',
                             'O',
                             r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
                             );
              end if;        
            end if;     
      Else
          if r_acerto.acc_acontas_diferenca <> 0 then

            if r_acerto.acc_acontas_diferenca > 0 then
              
              SELECT o.cax_operacao_historico,
                     o.cax_operacao_ccusto
                INTO v_caxdescricao,
                     vUsaCC
                FROM t_cax_operacao O
               WHERE cax_operacao_codigo = '2120'
                 AND glb_rota_codigo_operacao = '000';
              
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#0',trim ('AC:'||r_acerto.acc_acontas_numero));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (r_acerto.frt_motorista_nome));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (r_acerto.frt_conjveiculo_codigo));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
              v_caxdescricao := substr(v_caxdescricao,1,50);

              INSERT INTO t_cax_movimento (
                          glb_rota_codigo,
                          cax_boletim_data,
                          cax_movimento_sequencia,
                          glb_rota_codigo_ccust,
                          glb_rota_codigo_referencia,
                          glb_rota_codigo_operacao,
                          cax_movimento_documento,
                          cax_operacao_codigo,
                          cax_movimento_historico,
                          cax_movimento_valor,
                          cax_movimento_frend,
                          cax_movimento_usuario,
                          cax_movimento_historicoc,
                          cax_movimento_historicop,
                          glb_centrocusto_codigo,
                          cax_movimento_contabil,
                          cax_movimento_origem,
                          cax_movimento_documentoref 
                          )
                   VALUES (
                          '015',
                          v_caixa,
                          v_sequencia,
                          '015',
                          '015',
                          '000',
                          r_acerto.acc_acontas_numero,
                          '2120',
                          trim(substr(v_caxdescricao,1,50)),
                          abs(r_acerto.acc_acontas_diferenca),
                          'N',
                          'jsantos',
                           v_motorista,
                           trim(substr(v_caxdescricao,1,50)),
                           decode(vUsaCC,'S',vCentroCusto,null),
                           'S',
                           'O',
                           r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
                          );
            else
              SELECT o.cax_operacao_historico,
                     o.cax_operacao_ccusto
                INTO v_caxdescricao,
                     vUsaCC
                FROM t_cax_operacao O
               WHERE cax_operacao_codigo = '1057'
                 AND glb_rota_codigo_operacao = '000';
                   
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#0',trim ('AC:'||r_acerto.acc_acontas_numero));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#3',trim (r_acerto.frt_motorista_nome));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#6',trim (r_acerto.frt_conjveiculo_codigo));
              v_caxdescricao := REPLACE (trim (v_caxdescricao),'#7', '015');
              v_caxdescricao := substr(v_caxdescricao,1,50);

                INSERT INTO tdvadm.t_cax_movimento (
                            glb_rota_codigo,
                            cax_boletim_data,
                            cax_movimento_sequencia,
                            glb_rota_codigo_ccust,
                            glb_rota_codigo_referencia,
                            glb_rota_codigo_operacao,
                            cax_movimento_documento,
                            cax_operacao_codigo,
                            cax_movimento_historico,
                            cax_movimento_valor,
                            cax_movimento_frend,
                            cax_movimento_usuario,
                            cax_movimento_historicoc,
                            cax_movimento_historicop,
                            glb_centrocusto_codigo,
                            cax_movimento_contabil,
                            cax_movimento_origem,
                            cax_movimento_documentoref 
                            )
                     VALUES (
                            '015',
                             v_caixa,
                             v_sequencia,
                             '015',
                             '015',
                             '000',
                             r_acerto.acc_acontas_numero,
                             '1057',
                             trim(substr(v_caxdescricao,1,50)),
                             abs(r_acerto.acc_acontas_diferenca),
                             'N',
                             'jsantos',
                             v_motorista,
                             trim(substr(v_caxdescricao,1,50)),
                             decode(vUsaCC,'S',vCentroCusto,null),
                             'S',
                             'O',
                             r_acerto.acc_acontas_numero || '-' || r_acerto.acc_contas_ciclo
                             );
              end if;        
            end if;     
      End If; 
        v_sequencia := v_sequencia + 1;

      UPDATE tdvadm.t_acc_acontas a
         SET acc_acontas_datatransf = v_caixa
       WHERE a.acc_acontas_numero = r_acerto.acc_acontas_numero
         and a.acc_contas_ciclo = r_acerto.acc_contas_ciclo;
        

   END LOOP;

   tdvadm.SP_CAX_FECHAMENTOMes('015',v_Caixa);   

--   UPDATE t_acc_acontas
--      SET acc_acontas_datatransf = SYSDATE
--    WHERE acc_acontas_data BETWEEN p_datainicial AND p_datafinal
--      AND acc_acontas_datatransf IS NULL;

   -- inicia a atualização dos vales pagos nos caixas das filiais
   
--   Temos um JOB que roda a cada tres dia
--   pkg_ctb_caixa.sp_set_ReplicaOperacao_Tst(p_datainicial,p_datafinal,v_caixa,pStatus,pMessage);
   
   if pStatus =  pkg_glb_common.Status_Nomal then
      COMMIT;
   Else
      raise_application_error(-20001,chr(10) ||
                                     '**************************************************************' || chr(10) ||
                                     trim(pMessage) || chr(10) ||
                                     '**************************************************************' || chr(10));
   end if;   

   --EXECUTE IMMEDIATE('alter trigger TG_BIU_E_TRAVA_PROPNAOCAD enable');
  
END;

 
/
