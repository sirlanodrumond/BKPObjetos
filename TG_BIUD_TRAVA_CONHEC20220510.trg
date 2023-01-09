CREATE OR REPLACE TRIGGER TG_BIUD_TRAVA_CONHEC
BEFORE INSERT OR UPDATE OR DELETE ON TDVADM.T_CON_CONHECIMENTO
FOR EACH ROW

DECLARE
  erro_status exception;
  V_CLIENTE_SITUACAO CHAR(1);
  V_REGIMEESP_VP     T_GLB_CLIENTE.GLB_CLIENTE_REGIMEESPVP%TYPE;
  V_MODALIDADE_VP    T_CON_MODALIDADEPED.CON_MODALIDADEPED_CODIGO%TYPE;
  V_FCOBPED_VP       T_CON_FCOBPED.CON_FCOBPED_CODIGO%TYPE;
  nTOTAL             INTEGER;
  v_contador         integer;
  V_CNPJ             VARCHAR(30);
  V_VLRLIMITE        T_GLB_CLIENTE.GLB_CLIENTE_VLRLIMITE%TYPE;
  V_VLTOTVENC        T_GLB_CLIENTE.GLB_CLIENTE_VLTOTVENC%TYPE;
  V_PROGRAM          V_GLB_AMBIENTE.PROGRAM%TYPE;
  vMSG               clob;
  vTpCarga           TDVADM.T_FCF_TPCARGA.FCF_TPCARGA_CODIGO%TYPE;
  vVenc              date;
  vTipo              char(1);
  /**************** Thiago - 08/11/2019 - *************
  -- Variável criada para verificar se existe        --
  -- mercadoria antes de inserir o conhecimento      --
  ****************************************************/
  V_GLB_MERCADORIA_CODIGO TDVADM.T_GLB_MERCADORIA.GLB_MERCADORIA_CODIGO%TYPE;
  V_MERCADORIA_COD        TDVADM.T_GLB_MERCADORIA.GLB_MERCADORIA_CODIGO%TYPE;
BEGIN

  
  IF NOT(((:NEW.GLB_ROTA_CODIGO in ('216','198')) AND (:NEW.CON_CONHECIMENTO_SERIE = 'A0')))  AND  
     NOT ((:NEW.GLB_ROTA_CODIGO IN ('027') AND (:NEW.CON_CONHECIMENTO_SERIE = 'A1')))       THEN   
     nTOTAL := 0;
     if not  (:new.glb_mercadoria_codigo is null and :old.glb_mercadoria_codigo is not null)  then
        SELECT A.PROGRAM
           INTO V_PROGRAM
        FROM V_GLB_AMBIENTE A;
        

        IF INSERTING OR UPDATING THEN
           -- Sirlano / Joao
           -- 28/06/2021
           -- Verificando se a tabela ou solictação esta Vencida ou Suspensa
           vTipo := 'X';
           If ( :new.con_conhecimento_serie = 'XXX' ) and (:new.con_conhecimento_flagcancelado is null )  Then  
              If :new.slf_solfrete_codigo is not null Then
                 Begin
                   Select sf.slf_solfrete_dataefetiva
                   into vVenc
                   from tdvadm.t_slf_solfrete sf
                   where sf.slf_solfrete_codigo = :new.slf_solfrete_codigo
                     and sf.slf_solfrete_saque = :new.slf_solfrete_saque;
                     vTipo := 'S';
                 Exception
                   When NO_DATA_FOUND then
                     vVenc := null;
                     vTipo := 'X';
                   End;
              Else
                 BEGIN
                    SELECT DECODE(NVL(TA.SLF_TABELA_STATUS,'N'),'S',SYSDATE-10,SYSDATE)
                       INTO vVenc
                    FROM tdvadm.T_SLF_TABELA TA
                    WHERE TA.SLF_TABELA_CODIGO = :NEW.SLF_TABELA_CODIGO
                      AND TA.SLF_TABELA_SAQUE = :NEW.SLF_TABELA_SAQUE;
                      vTipo := 'T';
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       vVenc := trunc(sysdate);
                       vTipo := 'X';
                    END ;  
              End If;
              If vTipo <> 'X' Then
                 If trunc(vVenc) < trunc(sysdate) Then
                    -- Vencido 
                    If vTipo = 'S' then
                       raise_application_error(-20113,'**********************************************' || chr(10) ||
                                                      'SOLICITACAO VENCIDA, REVALIDE PARA CONTINUAR' || chr(10) ||
                                                      '**********************************************' || chr(10));
                    Else
                       raise_application_error(-20113,'*****************************************' || chr(10) ||
                                                      'TABELA VENCIDA, REVALIDE PARA CONTINUAR' || chr(10) ||
                                                      '*****************************************' || chr(10));
                    End If;
                 End If;
              End IF; 
           End IF; 
           
           IF :NEW.GLB_ROTA_CODIGO <> '180' THEN
              BEGIN
                 SELECT C.GLB_CLIENTE_SITUACAO,
                        C.GLB_CLIENTE_REGIMEESPVP,
                        C.GLB_CLIENTE_VLRLIMITE,
                        C.GLB_CLIENTE_VLTOTVENC
                   INTO V_CLIENTE_SITUACAO, 
                        V_REGIMEESP_VP, 
                        V_VLRLIMITE, 
                        V_VLTOTVENC
                 FROM T_GLB_CLIENTE C
                 WHERE C.GLB_CLIENTE_CGCCPFCODIGO = :NEW.GLB_CLIENTE_CGCCPFSACADO;
    
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     V_CLIENTE_SITUACAO := 'N';
                     V_REGIMEESP_VP     := NULL;
                     V_VLRLIMITE        := 0;
                     V_VLTOTVENC        := 0;
                 END;
              If :new.con_conhecimento_dtembarque < Sysdate -2 Then
                 V_CLIENTE_SITUACAO := 'N';
              End If;       

              V_CNPJ := :NEW.GLB_CLIENTE_CGCCPFSACADO;
              IF (V_CLIENTE_SITUACAO = 'I') THEN
                 raise_application_error(-20001,'********************************************************' || chr(10) ||
                                                'CNPJ : ' || f_mascara_cgccpf(TRIM(:NEW.GLB_CLIENTE_CGCCPFSACADO)) || ', BLOQUEADO PELA MATRIZ, NÃO EMITIR DOCUMENTO....' || chr(10) ||
                                                'CTRC/ROTA' || :NEW.CON_CONHECIMENTO_CODIGO || '/' || :NEW.CON_CONHECIMENTO_serie || '/' || :NEW.GLB_ROTA_CODIGO || chr(10) ||
                                                '********************************************************' || chr(10));
              END IF;
   
              IF (V_VLRLIMITE < V_VLTOTVENC)  and  
                 (:old.con_conhecimento_digitado <> :new.con_conhecimento_digitado ) AND 
                 (:new.con_conhecimento_digitado = 'I' ) THEN
                 raise_application_error(-20001,'*****************************************************************************' || chr(10) ||
                                                'SACADO '||f_mascara_cgccpf(TRIM(:NEW.GLB_CLIENTE_CGCCPFSACADO))||' ATINGIU SEU LIMITE ' || chr(10) || 
                                                'PROCURE SETOR:CONTAS A RECEBER NA MATRIZ - SALDO RESTANTE ' || f_mascara_valor(V_VLRLIMITE - V_VLTOTVENC,15,2) || chr(10) ||
                                                '*****************************************************************************' || chr(10));
             END IF;
             
             /**************** Thiago - 08/11/2019 Verifica mercadoria **************
             -- Rotina criada para verificar se o código da mercadoria existe na   --
             -- tabela de mercadoria                                               --
             ***********************************************************************/             
             IF (NVL(:new.con_conhecimento_digitado,'N') = 'S')  THEN
               
                 IF NVL(:new.glb_mercadoria_codigo, '') <> '' THEN
                     BEGIN
                         SELECT M.GLB_MERCADORIA_CODIGO
                           INTO V_GLB_MERCADORIA_CODIGO
                         FROM TDVADM.T_GLB_MERCADORIA M
                         WHERE M.GLB_MERCADORIA_CODIGO = :new.glb_mercadoria_codigo;
                     EXCEPTION WHEN NO_DATA_FOUND THEN
                         V_GLB_MERCADORIA_CODIGO := NULL;
                     END;
                     
                     IF V_GLB_MERCADORIA_CODIGO IS NULL THEN
                        RAISE_APPLICATION_ERROR(-20001,
                                                'Código de mercadoria: ' || :new.glb_mercadoria_codigo ||
                                                ' não existe na tabela de mercadoria.');
                     END IF;
                 ELSE
                     BEGIN
                          IF :new.Slf_Solfrete_Codigo IS NOT NULL THEN
                              SELECT S.GLB_MERCADORIA_CODIGO
                                INTO V_GLB_MERCADORIA_CODIGO
                              FROM TDVADM.t_Slf_Solfrete S
                              WHERE S.Slf_Solfrete_Codigo = :new.Slf_Solfrete_Codigo
                                and S.SLF_SOLFRETE_SAQUE  = :new.slf_solfrete_saque;
                          ELSE
                              SELECT T.GLB_MERCADORIA_CODIGO
                                INTO V_GLB_MERCADORIA_CODIGO
                              FROM TDVADM.t_Slf_Tabela T
                              WHERE T.SLF_TABELA_CODIGO = :new.Slf_Tabela_Codigo
                                and T.SLF_TABELA_SAQUE  = :new.slf_tabela_saque;
                          END IF;
                      EXCEPTION WHEN NO_DATA_FOUND THEN
                          V_GLB_MERCADORIA_CODIGO := NULL;
                      END;
                     
                     IF V_GLB_MERCADORIA_CODIGO IS NULL THEN 
                          RAISE_APPLICATION_ERROR(-20001,
                                                      'Código de mercadoria vazio');
                                                      
                     ELSE
                         BEGIN 
                             SELECT M.GLB_MERCADORIA_CODIGO
                               INTO V_MERCADORIA_COD
                             FROM TDVADM.T_GLB_MERCADORIA M
                             WHERE M.GLB_MERCADORIA_CODIGO = :new.glb_mercadoria_codigo;
                         EXCEPTION WHEN NO_DATA_FOUND THEN
                             V_MERCADORIA_COD := NULL;
                         END;
                         
                         IF V_MERCADORIA_COD IS NULL THEN
                            RAISE_APPLICATION_ERROR(-20001,
                                                    'Código de mercadoria: ' || :new.glb_mercadoria_codigo ||
                                                    ' não existe na tabela de mercadoria.');
                         END IF;
                         
                     END IF;
                 END IF;
             END IF;             
             /**************** Thiago - 08/11/2019 - Verifica mercadoria *************
             -- Fim Rotina                                                          --
             ************************************************************************/
             
             -- SE FOR DIGITAC?O MANUAL
             IF :NEW.PRG_PROGCARGA_CODIGO IS NULL THEN
                -- VERIFICA SE ROTA TEM VALE PEDADIO
                SELECT COUNT(*)
                  INTO v_contador
                FROM T_GLB_ROTA R
                WHERE R.GLB_ROTA_CODIGO = :OLD.GLB_ROTA_CODIGO;

                ntotal := nTOTAL + v_contador;
              /*       IF nTOTAL > 0 THEN
              
                        BEGIN
                           IF :NEW.SLF_SOLFRETE_CODIGO IS NOT NULL THEN
                              SELECT ST.CON_MODALIDADEPED_CODIGO,
                                     ST.CON_FCOBPED_CODIGO
                                INTO V_MODALIDADE_VP,
                                     V_FCOBPED_VP
                              FROM T_SLF_SOLFRETE ST
                              WHERE ST.SLF_SOLFRETE_CODIGO = :NEW.SLF_SOLFRETE_CODIGO
                                AND ST.SLF_SOLFRETE_SAQUE = :NEW.SLF_SOLFRETE_SAQUE;
                                
                           ELSIF :NEW.SLF_TABELA_CODIGO IS NOT NULL THEN
                              SELECT ST.CON_MODALIDADEPED_CODIGO,
                                     ST.CON_FCOBPED_CODIGO
                                INTO V_MODALIDADE_VP,
                                     V_FCOBPED_VP
                              FROM T_SLF_TABELA ST       
                              WHERE ST.SLF_TABELA_CODIGO = :NEW.SLF_TABELA_CODIGO
                                AND ST.SLF_TABELA_SAQUE = :NEW.SLF_TABELA_SAQUE;
                           ELSE
                               V_MODALIDADE_VP := '01'; -- DEMONSTRA NO CTRC E INCLUI NO TOTAL DA PRESTACAO
                               V_FCOBPED_VP := '00'; -- COBRADO NO CTRC
                               
                           END IF;
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           V_MODALIDADE_VP := '01';  -- DEMONSTRA NO CTRC E INCLUI NO TOTAL DA PRESTACAO
                           V_FCOBPED_VP := '00';  -- COBRADO NO CTRC
                        END;
                        SELECT COUNT(*)
                          INTO nTOTAL
                        FROM T_CON_CONHECVPED V
                        WHERE V.CON_CONHECIMENTO_CODIGO = :NEW.CON_CONHECIMENTO_CODIGO
                          AND V.CON_CONHECIMENTO_SERIE = :NEW.CON_CONHECIMENTO_SERIE
                          AND V.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO;
                        IF nTOTAL = 0 THEN  
                           INSERT INTO T_CON_CONHECVPED
                              (CON_CONHECIMENTO_CODIGO,
                               CON_CONHECIMENTO_SERIE,
                               GLB_ROTA_CODIGO,
                               GLB_CLIENTE_CGCCPFCODIGO,
                               GLB_CLIENTEREGESP_CODIGO,
                               CON_FPAGTOMOTPED_CODIGO,
                               CON_FCOBPED_CODIGO,
                               CON_MODALIDADEPED_CODIGO,
                               CON_CONHECVPED_TRANSACAO,
                               CON_CONHECVPED_VALOR,
                               CON_CONHECIMENTO_VALORTDV,
                               CON_CONHECIMENTO_DTGRAVACAO)
                           VALUES
                              (:NEW.CON_CONHECIMENTO_CODIGO,
                               :NEW.CON_CONHECIMENTO_SERIE,
                               :NEW.GLB_ROTA_CODIGO,
                               :NEW.GLB_CLIENTE_CGCCPFSACADO,
                               SUBSTR(V_REGIMEESP_VP,1,10),
                               NULL,
                               V_FCOBPED_VP,
                               V_MODALIDADE_VP,
                               NULL,
                               0,
                               0,
                               SYSDATE); 
                       END IF;     
                     END IF;    
              */
             END IF;
  
             SELECT COUNT(*)
               INTO v_contador
             FROM T_CTB_LOGTRANSF L
             WHERE L.CTB_LOGTRANSF_SISTEMA = 'CON'
               AND CTB_LOGTRANSF_REFERENCIA >= TO_CHAR(:NEW.CON_CONHECIMENTO_DTEMBARQUE, 'YYYYMM');
            
             nTOTAL := nTOTAL + v_contador;
        END IF;
     END IF;

     -- validando vale de frete
     IF (NVL(:NEW.CON_VALEFRETE_CODIGO, 'S') <>
        NVL(:OLD.CON_VALEFRETE_CODIGO, 'S')) OR
       (NVL(:NEW.CON_VALEFRETE_SAQUE, 'S') <>
        NVL(:OLD.CON_VALEFRETE_SAQUE, 'S')) OR
       (NVL(:NEW.CON_VALEFRETE_SERIE, 'S') <>
        NVL(:OLD.CON_VALEFRETE_SERIE, 'S')) OR
       (NVL(:NEW.GLB_ROTA_CODIGOVALEFRETE, 'S') <>
        NVL(:OLD.GLB_ROTA_CODIGOVALEFRETE, 'S')) then
        v_contador := 0;
     END IF;

     ntotal := nTOTAL + v_contador;
  

     -- TRATANDO IMPRESSAO DE CTRC
     IF (NVL(:NEW.CON_CONHECIMENTO_DIGITADO, 'S') <>
        NVL(:OLD.CON_CONHECIMENTO_DIGITADO, 'S')) THEN
        v_contador := 0;
     END IF;
     
     ntotal := nTOTAL + v_contador;

     IF :NEW.CON_CONHECIMENTO_PLACA IS NOT NULL THEN
        v_contador := 0;
     END IF;
     
     ntotal := nTOTAL + v_contador;

     IF (NVL(:NEW.CON_FATURA_CODIGO, 'S') <> NVL(:OLD.CON_FATURA_CODIGO, 'S')) OR
        (NVL(:NEW.CON_FATURA_CICLO, 'S') <> NVL(:OLD.CON_FATURA_CICLO, 'S')) OR
        (NVL(:NEW.GLB_ROTA_CODIGOFILIALIMP, 'S') <>
         NVL(:OLD.GLB_ROTA_CODIGOFILIALIMP, 'S')) THEN
        v_contador := 0;
     END IF;

     ntotal := nTOTAL + v_contador;

/*
      IF NVL(:NEW.con_conhecimento_dtrecebimento, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtrecebimento, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dttransf, '01/01/1900') <> NVL(:OLD.con_conhecimento_dttransf, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtchegmatriz, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtchegmatriz, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtfimcarga, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtfimcarga, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtinicarga, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtinicarga, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtnfe, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtnfe, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtgravcheckin, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtgravcheckin, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtcheckin, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtcheckin, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtenvseg, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtenvseg, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtchegcelula, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtchegcelula, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtenvedi, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtenvedi, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtchegalmox, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtchegalmox, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtsaidacelula, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtsaidacelula, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_vencimento, '01/01/1900') <> NVL(:OLD.con_conhecimento_vencimento, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtalteracao, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtalteracao, '01/01/1900') OR
         NVL(:NEW.con_conhecimento_dtvencindeniz, '01/01/1900') <> NVL(:OLD.con_conhecimento_dtvencindeniz, '01/01/1900') THEN
        v_contador := 0;
      END IF;
*/

     ntotal := nTOTAL + v_contador;

--  if :new.glb_rota_codigo = '197' and trunc(sysdate) = '14/03/2009' then
    -- liverado hoje com autorizacao do Gilberto vide email enviado pelo wesley
  if :new.glb_rota_codigo = '193' and trunc(sysdate) = '24/02/2010' then
    -- liverado hoje com autorizacao do Sirlano, inclusão de uma NOTA FISCAL serie A2
    v_contador := 0;
  end if;
       ntotal := nTOTAL + v_contador;


  IF TRIM(UPPER(V_PROGRAM)) = 'PRJ_BAIXA_OCORRENCIA.EXE'   AND NOT DELETING THEN
    v_contador := 0;
  END IF;   
         ntotal := nTOTAL + v_contador;


  -- PROBLEMA NO FATURAMENTO (NAO E POSSIVEL INSERIR CONHECIMENTOS)
  IF (nTOTAL < 0) THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'ESTE DOCUMENTO N?O PODE SER INSERIDO/ALTERADO,' ||
                            CHR(10) || 'DEVIDO A CONTABILIDADE REF.: ' ||
                            TO_CHAR(:NEW.CON_CONHECIMENTO_DTEMBARQUE,
                                    'YYYYMM') || ' JA ESTA FECHADA');
  END IF;
  end if;
  END IF;
END;
/
