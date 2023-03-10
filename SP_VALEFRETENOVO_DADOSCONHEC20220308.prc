CREATE OR REPLACE PROCEDURE SP_VALEFRETENOVO_DADOSCONHEC(P_CONHECCOD      IN CHAR,
                                                           P_CONHECSERIE    IN CHAR,
                                                           P_CONHECROTA     IN CHAR,
                                                           P_VIAGEM         IN OUT T_CON_VIAGEM.CON_VIAGEM_NUMERO%TYPE,
                                                           P_VIAGEMROTA     IN OUT T_CON_VIAGEM.GLB_ROTA_CODIGOVIAGEM%TYPE,
                                                           P_KM             IN OUT T_CON_CONHECIMENTO.CON_CONHECIMENTO_KILOMETRAGEM%TYPE,
                                                           P_QTDEENTREGA    IN OUT T_CON_CONHECIMENTO.CON_CONHECIMENTO_QTDEENTREGA%TYPE,
                                                           P_CLIENTEREM     IN OUT T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE,
                                                           P_LOCALORIGEM    IN OUT T_GLB_LOCALIDADE.GLB_LOCALIDADE_DESCRICAO%TYPE,
                                                           P_ESTORIGEM      IN OUT T_GLB_LOCALIDADE.GLB_ESTADO_CODIGO%TYPE,
                                                           P_CLIENTEDEST    IN OUT T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE,
                                                           P_LOCALDEST      IN OUT T_GLB_LOCALIDADE.GLB_LOCALIDADE_DESCRICAO%TYPE,
                                                           P_ESTDEST        IN OUT T_GLB_LOCALIDADE.GLB_ESTADO_CODIGO%TYPE,
                                                           P_CUSTCARRET     IN OUT T_PRG_PROGCARGADET.PRG_PROGCARGADET_CUSTCARRET%TYPE,
                                                           P_TPVALOR        IN OUT T_PRG_PROGCARGADET.PRG_PROGCARGADET_TPVALOR%TYPE,
                                                           P_PESO           IN OUT T_PRG_PROGCARGADET.PRG_PROGCARGADET_PESO%TYPE,
                                                           P_ADIANTAM       IN OUT T_PRG_PROGCARGADET.PRG_PROGCARGADET_ADIANTAMENTO%TYPE,
                                                           P_RETORNO        IN OUT CHAR,
                                                           P_MOTORISTA      IN OUT T_FRT_MOTORISTA.FRT_MOTORISTA_NOME%TYPE,
                                                           P_FROTA          IN OUT T_CON_VIAGEM.FRT_CONJVEICULO_CODIGO%TYPE,
                                                           P_MOTCGCCPF      IN OUT T_FRT_MOTORISTA.FRT_MOTORISTA_CODIGO%TYPE,
                                                           P_CARRET         IN OUT T_CAR_CARRETEIRO.CAR_CARRETEIRO_NOME%TYPE,
                                                           P_PLACA          IN OUT T_CAR_CARRETEIRO.CAR_VEICULO_PLACA%TYPE,
                                                           P_CARRETCGCCPF   IN OUT T_CAR_CARRETEIRO.CAR_CARRETEIRO_CPFCODIGO%TYPE,
                                                           P_CARRETSAQUE    IN OUT T_CAR_CARRETEIRO.CAR_CARRETEIRO_SAQUE%TYPE,
                                                           P_VEICSAQUE      IN OUT T_CAR_CARRETEIRO.CAR_VEICULO_SAQUE%TYPE,
                                                           P_LOCALORIGEMCOD IN OUT T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE,
                                                           P_LOCALDESTCOD   IN OUT T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE,
                                                           P_DTEMBARQUE     IN OUT T_CON_CONHECIMENTO.CON_CONHECIMENTO_DTEMBARQUE%TYPE) AS
  V_CLIENTEREM    T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  V_LOCALORIGEM   T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_CLIENTEDEST   T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  V_LOCALDEST     T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_PROGCARGA     T_PRG_PROGCARGADET.PRG_PROGCARGA_CODIGO%TYPE;
  V_PROGCARGSEQ   T_PRG_PROGCARGADET.PRG_PROGCARGADET_SEQUENCIA%TYPE;
  V_PROGCARGRT    T_PRG_PROGCARGADET.GLB_ROTA_CODIGO%TYPE;
  V_PLACA         T_CON_CONHECIMENTO.CON_CONHECIMENTO_PLACA%TYPE;
  V_VERIFICAFROTA T_CON_CONHECIMENTO.CON_CONHECIMENTO_PLACA%TYPE;
  V_EMBARQUE      T_CON_CONHECIMENTO.CON_CONHECIMENTO_DTEMBARQUE%TYPE;
  v_Serie         T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  v_rota_Especial Char(3);
  V_SAQUE         NUMBER;
  V_CONHECCOD     T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_CONHECSERIE   T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%TYPE;
  V_CONHECROTA    T_CON_CONHECIMENTO.GLB_ROTA_CODIGO%TYPE;

  V_SAQUE1 NUMBER;
  V_MSERIE CHAR(2);
  V_PLACAVF       T_CON_CONHECIMENTO.CON_CONHECIMENTO_PLACA%TYPE;
BEGIN
  who_called_me2;
  v_Rota_Especial := '033';

  /** Fabiano - 13/11/2009
  --  OBS: pra resolver o problema no Valefrete que sempre dava "Motorista n?o Cadastrado",
  --       quando categoria Bonus e Avulso.
  --       agora todos os selects usar?o como parametro o CTRC, s?rie, rota passado por parametro.  
    BEGIN
    SELECT VC.CON_CONHECIMENTO_CODIGO,
           VC.CON_CONHECIMENTO_SERIE,
           VC.GLB_ROTA_CODIGO
      INTO V_CONHECCOD, V_CONHECSERIE, V_CONHECROTA
      FROM T_CON_VFRETECONHEC VC
     WHERE VC.CON_VALEFRETE_CODIGO = P_CONHECCOD
       AND VC.CON_VALEFRETE_SERIE = P_CONHECSERIE
       AND VC.GLB_ROTA_CODIGOVALEFRETE = P_CONHECROTA
       AND VC.GLB_ROTA_CODIGOVALEFRETE = VC.GLB_ROTA_CODIGO
       AND VC.CON_VALEFRETE_SAQUE =
           (SELECT MAX(VC2.CON_VALEFRETE_SAQUE)
              FROM T_CON_VFRETECONHEC VC2
             WHERE VC2.CON_VALEFRETE_CODIGO = VC.CON_VALEFRETE_CODIGO
               AND VC2.CON_VALEFRETE_SERIE = VC.CON_VALEFRETE_SERIE
               AND VC2.GLB_ROTA_CODIGOVALEFRETE =
                   VC.GLB_ROTA_CODIGOVALEFRETE)
       AND ROWNUM = 1;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_CONHECCOD   := P_CONHECCOD;
      V_CONHECSERIE := P_CONHECSERIE;
      V_CONHECROTA  := P_CONHECROTA;
  END; **/
  V_CONHECCOD   := P_CONHECCOD;
  V_CONHECSERIE := P_CONHECSERIE;
  V_CONHECROTA  := P_CONHECROTA;
/*  insert into tdvadm.t_glb_sql s 
  values 
  (null,
   sysdate,
   'SIRLANO 1' || '-' || V_CONHECCOD || '-' || V_CONHECSERIE || '-' ||V_CONHECROTA,
   P_VIAGEM         || '-' ||       
   P_VIAGEMROTA     || '-' || 
   P_KM             || '-' || 
   P_QTDEENTREGA    || '-' ||    
   P_CLIENTEREM     || '-' || 
   P_LOCALORIGEM    || '-' || 
   P_ESTORIGEM      || '-' || 
   P_CLIENTEDEST    || '-' || 
   P_LOCALDEST      || '-' || 
   P_ESTDEST        || '-' || 
   P_CUSTCARRET     || '-' || 
   P_TPVALOR        || '-' || 
   P_PESO           || '-' || 
   P_ADIANTAM       || '-' || 
   P_RETORNO        || '-' || 
   P_MOTORISTA      || '-' || 
   P_FROTA          || '-' || 
   P_MOTCGCCPF      || '-' || 
   P_CARRET         || '-' || 
   P_PLACA          || '-' || 
   P_CARRETCGCCPF   || '-' || 
   P_CARRETSAQUE    || '-' || 
   P_VEICSAQUE      || '-' || 
   P_LOCALORIGEMCOD || '-' ||  
   P_LOCALDESTCOD   || '-' || 
   P_DTEMBARQUE     ) ;
   
commit;
   */
   
   
   
   
   
   
  begin
    if v_Rota_Especial <> P_CONHECROTA then
      SELECT PRG_PROGCARGA_CODIGO,
             CON_CONHECIMENTO_QTDEENTREGA,
             PRG_PROGCARGADET_SEQUENCIA,
             GLB_ROTA_CODIGOPROGCARGADET,
             GLB_CLIENTE_CGCCPFREMETENTE,
             GLB_CLIENTE_CGCCPFDESTINATARIO,
             CON_VIAGEM_NUMERO,
             GLB_ROTA_CODIGOVIAGEM,
             GLB_LOCALIDADE_CODIGOORIGEM,
             GLB_LOCALIDADE_CODIGODESTINO,
             CON_CONHECIMENTO_KILOMETRAGEM,
             CON_CONHECIMENTO_PLACA,
             CON_CONHECIMENTO_DTEMBARQUE,
             CON_CONHECIMENTO_SERIE
        INTO V_PROGCARGA,
             P_QTDEENTREGA,
             V_PROGCARGSEQ,
             V_PROGCARGRT,
             V_CLIENTEREM,
             V_CLIENTEDEST,
             P_VIAGEM,
             P_VIAGEMROTA,
             V_LOCALORIGEM,
             V_LOCALDEST,
             P_KM,
             V_PLACA,
             V_EMBARQUE,
             V_SERIE
        FROM T_CON_CONHECIMENTO
       WHERE CON_CONHECIMENTO_CODIGO = V_CONHECCOD
         AND CON_CONHECIMENTO_SERIE = V_CONHECSERIE
         AND GLB_ROTA_CODIGO = V_CONHECROTA
         AND CON_CONHECIMENTO_FLAGCANCELADO IS NULL;
    else
      SELECT PRG_PROGCARGA_CODIGO,
             CON_CONHECIMENTO_QTDEENTREGA,
             PRG_PROGCARGADET_SEQUENCIA,
             GLB_ROTA_CODIGOPROGCARGADET,
             GLB_CLIENTE_CGCCPFREMETENTE,
             GLB_CLIENTE_CGCCPFDESTINATARIO,
             CON_VIAGEM_NUMERO,
             GLB_ROTA_CODIGOVIAGEM,
             GLB_LOCALIDADE_CODIGOORIGEM,
             GLB_LOCALIDADE_CODIGODESTINO,
             CON_CONHECIMENTO_KILOMETRAGEM,
             CON_CONHECIMENTO_PLACA,
             CON_CONHECIMENTO_DTEMBARQUE,
             CON_CONHECIMENTO_SERIE
        INTO V_PROGCARGA,
             P_QTDEENTREGA,
             V_PROGCARGSEQ,
             V_PROGCARGRT,
             V_CLIENTEREM,
             V_CLIENTEDEST,
             P_VIAGEM,
             P_VIAGEMROTA,
             V_LOCALORIGEM,
             V_LOCALDEST,
             P_KM,
             V_PLACA,
             V_EMBARQUE,
             V_SERIE
        FROM T_CON_CONHECIMENTO
       WHERE CON_CONHECIMENTO_CODIGO = V_CONHECCOD
         AND GLB_ROTA_CODIGO = V_CONHECROTA
         AND CON_CONHECIMENTO_FLAGCANCELADO IS NULL;
    end IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       Begin

          SELECT PRG_PROGCARGA_CODIGO,
                 CON_CONHECIMENTO_QTDEENTREGA,
                 PRG_PROGCARGADET_SEQUENCIA,
                 GLB_ROTA_CODIGOPROGCARGADET,
                 GLB_CLIENTE_CGCCPFREMETENTE,
                 GLB_CLIENTE_CGCCPFDESTINATARIO,
                 CON_VIAGEM_NUMERO,
                 GLB_ROTA_CODIGOVIAGEM,
                 GLB_LOCALIDADE_CODIGOORIGEM,
                 GLB_LOCALIDADE_CODIGODESTINO,
                 CON_CONHECIMENTO_KILOMETRAGEM,
                 CON_CONHECIMENTO_PLACA,
                 CON_CONHECIMENTO_DTEMBARQUE,
                 CON_CONHECIMENTO_SERIE,
                 con_conhecimento_codigo,
                 glb_rota_codigo
            INTO V_PROGCARGA,
                 P_QTDEENTREGA,
                 V_PROGCARGSEQ,
                 V_PROGCARGRT,
                 V_CLIENTEREM,
                 V_CLIENTEDEST,
                 P_VIAGEM,
                 P_VIAGEMROTA,
                 V_LOCALORIGEM,
                 V_LOCALDEST,
                 P_KM,
                 V_PLACA,
                 V_EMBARQUE,
                 V_SERIE,
                 V_CONHECCOD,
                 V_CONHECROTA
            FROM T_CON_CONHECIMENTO c
            where (c.con_conhecimento_codigo,
                   c.con_conhecimento_serie,
                   c.glb_rota_codigo) in (select vfc.con_conhecimento_codigo,
                                                 vfc.con_conhecimento_serie,
                                                 vfc.glb_rota_codigo
                                          from tdvadm.t_con_vfreteconhec vfc
                                          where vfc.con_valefrete_codigo = P_CONHECCOD 
                                            and vfc.con_valefrete_serie = P_CONHECSERIE
                                            and vfc.glb_rota_codigovalefrete = P_CONHECROTA
--                                            and vfc.con_valefrete_saque = 
                                            and vfc.con_conhecimento_codigo = c.con_conhecimento_codigo
                                            and vfc.con_conhecimento_serie = c.con_conhecimento_serie
                                            and vfc.glb_rota_codigo = c.glb_rota_codigo
                                            and rownum = 1);


       exception
         When NO_DATA_FOUND Then
           P_RETORNO := '1';
         When OTHERS Then
           P_RETORNO := '0';
       End ;
  end;
  
  -- Verifica se tem solcitacao de Veiculo
  -- Se existir uma solicita??o pega a origem e destino dela
  Begin
     select sv.origemLOSO,
            sv.destinoLOSO
        into P_LOCALORIGEMCOD,
             P_LOCALDESTCOD
  from tdvadm.v_fcf_solveic sv,
       tdvadm.t_arm_carregamento ca,
       tdvadm.t_con_conhecimento ct
  where 0 = 0
--    AND sv.FCF_SOLVEIC_COD = ca.fcf_solveic_cod
    AND CA.FCF_VEICULODISP_CODIGO = SV.FCF_VEICULODISP_CODIGO
    AND CA.FCF_VEICULODISP_SEQUENCIA = SV.FCF_VEICULODISP_SEQUENCIA
    and ca.arm_carregamento_codigo = ct.arm_carregamento_codigo
    and ct.con_conhecimento_codigo = V_CONHECCOD
    and ct.con_conhecimento_serie = V_CONHECSERIE
    and ct.glb_rota_codigo = V_CONHECROTA;
    V_LOCALORIGEM := P_LOCALORIGEMCOD;
    V_LOCALDEST := P_LOCALDESTCOD;
  Exception
    When OTHERS Then
       P_LOCALORIGEMCOD := V_LOCALORIGEM;
       P_LOCALDESTCOD   := V_LOCALDEST;
  End;

  P_DTEMBARQUE     := V_EMBARQUE;
  IF NVL(P_RETORNO, '1') <> '0' THEN
    begin
      SELECT A.GLB_CLIENTE_RAZAOSOCIAL, B.GLB_CLIENTE_RAZAOSOCIAL
        INTO P_CLIENTEREM, P_CLIENTEDEST
        FROM T_GLB_CLIENTE A, T_GLB_CLIENTE B
       WHERE A.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTEREM
         AND B.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTEDEST;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_CLIENTEREM  := '';
        P_CLIENTEDEST := '';
    end;
    BEGIN
      SELECT SUBSTR(F_PLACACONJ(P_CONHECCOD, V_SERIE, P_CONHECROTA), 11, 7)
        INTO V_VERIFICAFROTA
        FROM DUAL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_VERIFICAFROTA := 'X';
    END;
    IF SUBSTR(V_VERIFICAFROTA, 1, 1) <> 'C' THEN
      V_PLACA := V_VERIFICAFROTA;
      UPDATE T_CON_CONHECIMENTO
         SET CON_CONHECIMENTO_PLACA = V_PLACA
       WHERE CON_CONHECIMENTO_CODIGO = P_CONHECCOD
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = P_CONHECROTA;
      COMMIT;
    END IF;
    BEGIN
      SELECT A.GLB_LOCALIDADE_DESCRICAO,
             A.GLB_ESTADO_CODIGO,
             B.GLB_LOCALIDADE_DESCRICAO,
             B.GLB_ESTADO_CODIGO
        INTO P_LOCALORIGEM, P_ESTORIGEM, P_LOCALDEST, P_ESTDEST
        FROM T_GLB_LOCALIDADE A, T_GLB_LOCALIDADE B
       WHERE A.GLB_LOCALIDADE_CODIGO = V_LOCALORIGEM
         AND B.GLB_LOCALIDADE_CODIGO = V_LOCALDEST;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_LOCALORIGEM := '';
        P_ESTORIGEM   := '';
        P_LOCALDEST   := '';
        P_ESTDEST     := '';
    end;
    P_ADIANTAM := '';
    begin
      SELECT CON_CALCVIAGEM_VALOR,
             DECODE(CON_CALCVIAGEM_DESINENCIA, 'VL ', 'U', 'T')
        INTO P_CUSTCARRET, P_TPVALOR
        FROM T_CON_CALCCONHECIMENTO
       WHERE CON_CONHECIMENTO_CODIGO = P_CONHECCOD
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = P_CONHECROTA
         AND SLF_RECCUST_CODIGO = 'I_CTCR';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_CUSTCARRET := '0';
        P_TPVALOR    := 'U';
    end;
    begin
      SELECT CON_CALCVIAGEM_VALOR
        INTO P_PESO
        FROM T_CON_CALCCONHECIMENTO
       WHERE CON_CONHECIMENTO_CODIGO = P_CONHECCOD
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = P_CONHECROTA
         AND SLF_RECCUST_CODIGO = 'I_PSCOBRAD';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_PESO := '';
    end;
    P_CARRETCGCCPF := '';
    P_CARRETSAQUE  := '';
    P_MOTCGCCPF    := '';
    P_FROTA        := '';
    BEGIN
      SELECT A.CAR_CARRETEIRO_CPFCODIGO,
             A.CAR_CARRETEIRO_SAQUE,
             A.FRT_CONJVEICULO_CODIGO,
             C.CAR_VEICULO_PLACA,
             C.CAR_CARRETEIRO_NOME,
             C.CAR_VEICULO_SAQUE,
             B.FRT_MOTORISTA_CPF,
             B.FRT_MOTORISTA_NOME
        INTO P_CARRETCGCCPF,
             P_CARRETSAQUE,
             P_FROTA,
             P_PLACA,
             P_CARRET,
             P_VEICSAQUE,
             P_MOTCGCCPF,
             P_MOTORISTA
        FROM T_CON_VIAGEM A, T_FRT_MOTORISTA B, T_CAR_CARRETEIRO C
       WHERE A.CON_VIAGEM_NUMERO = P_VIAGEM
         AND A.GLB_ROTA_CODIGOVIAGEM = P_VIAGEMROTA
         AND A.CAR_CARRETEIRO_CPFCODIGO = C.CAR_CARRETEIRO_CPFCODIGO(+)
         AND A.CAR_CARRETEIRO_SAQUE = C.CAR_CARRETEIRO_SAQUE(+)
         AND A.FRT_MOTORISTA_CODIGO = B.FRT_MOTORISTA_CODIGO(+);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_CARRETCGCCPF := NULL;
        P_CARRETSAQUE  := NULL;
        P_MOTCGCCPF    := NULL;
        P_FROTA        := NULL;
        P_PLACA        := NULL;
    END;
    IF P_PLACA IS NULL THEN
      P_PLACA := TRIM(V_PLACA);
    END IF;
    if ((P_CARRETCGCCPF IS NULL) and (P_MOTCGCCPF IS NULL)) Then
      BEGIN
        SELECT TRIM(FRT_CONJVEICULO_CODIGO),
               TRIM(FRT_MOTORISTA_CPF),
               trim(FRT_MOTORISTA_NOME)
          INTO P_FROTA, P_MOTCGCCPF, P_MOTORISTA
          FROM V_FRT_CONJUNTO
         WHERE FRT_CONJVEICULO_CODIGO = P_PLACA
           AND trunc(FRT_CONJUNTO_DTINICIAL) <= trunc(V_EMBARQUE)
           AND trunc(FRT_CONJUNTO_DTFINAL) >= trunc(V_EMBARQUE);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT TRIM(A.CAR_CARRETEIRO_CPFCODIGO),
                   TRIM(A.CAR_CARRETEIRO_SAQUE)
              INTO P_CARRETCGCCPF, P_CARRETSAQUE
              FROM T_CAR_CARRETEIRO A
             WHERE A.CAR_VEICULO_PLACA = P_PLACA
               AND A.CAR_VEICULO_SAQUE =
                   (SELECT MAX(B.CAR_VEICULO_SAQUE)
                      FROM T_CAR_CARRETEIRO B
                     WHERE B.CAR_CARRETEIRO_CPFCODIGO =
                           A.CAR_CARRETEIRO_CPFCODIGO
                       AND B.CAR_VEICULO_PLACA = A.CAR_VEICULO_PLACA)
               AND A.CAR_CARRETEIRO_SAQUE =
                   (SELECT MAX(B.CAR_CARRETEIRO_SAQUE)
                      FROM T_CAR_CARRETEIRO B
                     WHERE B.CAR_CARRETEIRO_CPFCODIGO =
                           A.CAR_CARRETEIRO_CPFCODIGO
                       AND B.CAR_VEICULO_PLACA = A.CAR_VEICULO_PLACA)
               AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              P_CARRETCGCCPF := '';
              P_CARRETSAQUE  := '';
              P_MOTCGCCPF    := '';
              P_FROTA        := '';
          END;
      END;
    END IF;
  END IF;
     
        
   
  
    -- FABIANO: 14/12/2009
    -- DEVIDO PROBLEMAS AO INSERIR VF VARIAS VIAGENS QUE N?O LISTAVA O CONHECIMENTO PRINCIPAL
    -- USEI ESTA LOGICA PARA PODER PEGAR A PLACA DO VF CASO A PLACA ESTEJA COMO SLT0001
    -- BUSCO A PLACA DO SAQUE 1 DO VF: P_CONHECCOD DA MAIOR SERIE.
    IF P_PLACA = 'SLT0001' THEN
      
      BEGIN
        SELECT MAX(V1.CON_CONHECIMENTO_SERIE)
          INTO V_MSERIE
          FROM T_CON_VALEFRETE V1
           WHERE V1.CON_CONHECIMENTO_CODIGO = P_CONHECCOD
             AND V1.GLB_ROTA_CODIGO = P_CONHECROTA;      
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_MSERIE := P_CONHECSERIE;
      END;
      
      V_SAQUE1 := 0;            
      BEGIN                            
        SELECT COUNT(*)
          INTO V_SAQUE1
          FROM T_CON_VALEFRETE V2
         WHERE V2.CON_CONHECIMENTO_CODIGO = P_CONHECCOD
           AND V2.CON_CONHECIMENTO_SERIE = V_MSERIE
           AND V2.GLB_ROTA_CODIGO = P_CONHECROTA  ;
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_SAQUE1 := 0;
      END;
          
      IF V_SAQUE1 > 0 THEN
        BEGIN
          SELECT V3.CON_VALEFRETE_PLACA
            INTO P_PLACA
            FROM T_CON_VALEFRETE V3
           WHERE V3.CON_CONHECIMENTO_CODIGO = P_CONHECCOD
             AND V3.GLB_ROTA_CODIGO = P_CONHECROTA
             AND V3.CON_CONHECIMENTO_SERIE = V_MSERIE
             AND V3.CON_VALEFRETE_SAQUE = 1;               
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            P_PLACA := 'SLT0001';         
        END;
      END IF;  
         
    END IF;
    -- END-- FABIANO: 14/12/2009    
  
      -- FABIANO - 04/01/2010 
      BEGIN
        SELECT VF.CON_VALEFRETE_PLACA
          INTO V_PLACAVF
          FROM T_CON_VALEFRETE VF
         WHERE VF.CON_CONHECIMENTO_CODIGO = P_CONHECCOD
           AND VF.CON_CONHECIMENTO_SERIE = P_CONHECSERIE
           AND VF.GLB_ROTA_CODIGO = P_CONHECROTA
           AND VF.CON_VALEFRETE_SAQUE = (SELECT MIN(VF2.CON_VALEFRETE_SAQUE)
                                           FROM T_CON_VALEFRETE VF2
                                          WHERE VF2.CON_CONHECIMENTO_CODIGO = VF.CON_CONHECIMENTO_CODIGO
                                            AND VF2.CON_CONHECIMENTO_SERIE = VF.CON_CONHECIMENTO_SERIE
                                            AND VF2.GLB_ROTA_CODIGO = VF.GLB_ROTA_CODIGO);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_PLACAVF := NULL;         
      END;  
        
      IF V_PLACAVF IS NOT NULL THEN
         IF P_PLACA <> V_PLACAVF THEN
            P_PLACA := V_PLACAVF;
         END IF;
         
      END IF;
  
  
/*    insert into tdvadm.t_glb_sql s 
  values 
  (null,
   sysdate,
   'SIRLANO 2' || '-' || V_CONHECCOD || '-' || V_CONHECSERIE || '-' ||V_CONHECROTA,
   P_VIAGEM         || '-' ||       
   P_VIAGEMROTA     || '-' || 
   P_KM             || '-' || 
   P_QTDEENTREGA    || '-' ||    
   P_CLIENTEREM     || '-' || 
   P_LOCALORIGEM    || '-' || 
   P_ESTORIGEM      || '-' || 
   P_CLIENTEDEST    || '-' || 
   P_LOCALDEST      || '-' || 
   P_ESTDEST        || '-' || 
   P_CUSTCARRET     || '-' || 
   P_TPVALOR        || '-' || 
   P_PESO           || '-' || 
   P_ADIANTAM       || '-' || 
   P_RETORNO        || '-' || 
   P_MOTORISTA      || '-' || 
   P_FROTA          || '-' || 
   P_MOTCGCCPF      || '-' || 
   P_CARRET         || '-' || 
   P_PLACA          || '-' || 
   P_CARRETCGCCPF   || '-' || 
   P_CARRETSAQUE    || '-' || 
   P_VEICSAQUE      || '-' || 
   P_LOCALORIGEMCOD || '-' ||  
   P_LOCALDESTCOD   || '-' || 
   P_DTEMBARQUE     ) ;*/
commit;
  
  
END;

 
/
