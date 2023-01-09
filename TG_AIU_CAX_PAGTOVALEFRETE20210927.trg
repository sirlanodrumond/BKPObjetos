CREATE OR REPLACE TRIGGER TG_AIU_CAX_PAGTOVALEFRETE
AFTER INSERT OR UPDATE ON TDVADM.T_CAX_MOVIMENTO
REFERENCING OLD AS old NEW AS new
FOR EACH ROW

DECLARE
  S_SALDO               number;
  V_PEDAGIO             NUMBER;
  V_QTDCANC             INTEGER;
  V_DOC                 T_ACC_VALES.ACC_VALES_NUMERO%TYPE;
  V_CTRC                T_CON_CONHECIMENTO.CON_CONHECIMENTO_CODIGO%TYPE;
  V_SAQUE               T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
  vMenorSaqueValido     T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
  vMaiorSaqueValido     T_CON_VALEFRETE.CON_VALEFRETE_SAQUE%TYPE;
  vSubCategoria         T_CON_VALEFRETE.Con_Subcatvalefrete_Codigo%type;
  V_SERIE               T_CON_CONHECIMENTO.CON_CONHECIMENTO_SERIE%type;
  V_SEQ                 T_CON_VALEFRETEDET.CON_VALEFRETEDET_SEQ%TYPE;
  V_CONTADOR            NUMBER; -- quantidade total de imagens
  V_QTDEIMG             INTEGER;
  V_QTDCOMPRF           INTEGER;
  v_QTDSEMCHEKIN        INTEGER;
  V_QTDCOMPRV           INTEGER;
  V_CONTADORSD          NUMBER; -- quantidade de CTRC sem data
  V_CONTADORREC         number; -- quantidade de imagens recusadas
  V_CONTADORNAPROV      number; -- quantidade de imagens nao aprovadas
  V_ROTASCANER          NUMBER := 0;
  vTerminal             V_GLB_AMBIENTE.terminal%type;
  V_PROGRAM             V_GLB_AMBIENTE.PROGRAM%TYPE;
  v_Ip                  V_GLB_AMBIENTE.ip_address%TYPE;
  v_frota               t_con_valefrete.frt_conjveiculo_codigo%TYPE;
  V_VAZIO               T_CON_VALEFRETE.FRT_MOVVAZIO_NUMERO%TYPE;
  vValor                Number;
  vRecebimento          Date;
  vRotaCaixa            Char(3);
  vBoletimCaixa         Date;
  vCxSequencia          t_cax_movimento.cax_movimento_sequencia%type;
  vLocal                varchar2(15) := 'Declaracao';
  camposalt             CLOB;
  v_usuario             tdvadm.v_glb_ambiente.os_user%type;
  vAuxiliarn            number;
  vAuxiliarT            varchar2(10);
  vEstadia              integer;
  vQtdeEntregas         integer;
BEGIN

camposalt := '';

select a.os_user,
       A.terminal,
       A.PROGRAM
  into v_usuario,
       vTerminal,
       V_PROGRAM
  from v_glb_ambiente a;


--if lower(trim(v_usuario)) <> 'roliveira' then

  if not (
           ( ( :new.cax_movimento_contabil is null ) and ( :old.cax_movimento_contabil  is not null ) )
           or
           ( ( :new.CAX_MOVIMENTO_DTTRANS is null ) and ( :old.CAX_MOVIMENTO_DTTRANS  is not null ) )


         ) then

    -- VERIFICA O PROGRAMA QUE ESTA FAZENDO A OPERAÇAO.
    vLocal := 'inicioA';
    vAuxiliarT := :new.cax_operacao_codigo;
    SELECT AM.PROGRAM,
           am.ip_address
      INTO V_PROGRAM,
           v_Ip
      FROM V_GLB_AMBIENTE AM;

     If ( :new.CAX_MOVIMENTO_DOCUMENTO = '450004' ) Then
         v_Ip := v_Ip;
     End If;



  if :new.GLB_ROTA_CODIGO_CCUST <> :old.GLB_ROTA_CODIGO_CCUST then
    camposalt := camposalt || 'cax_movimento_contabil';
  end if;

  if :new.GLB_ROTA_CODIGO_REFERENCIA <> :old.GLB_ROTA_CODIGO_REFERENCIA then
    camposalt := camposalt || 'GLB_ROTA_CODIGO_REFERENCIA';
  end if;

  if :new.GLB_ROTA_CODIGO_OPERACAO <> :old.GLB_ROTA_CODIGO_OPERACAO then
    camposalt := camposalt || 'GLB_ROTA_CODIGO_OPERACAO';
  end if;

  if :new.CAX_TELEFONE_DDD <> :old.CAX_TELEFONE_DDD then
    camposalt := camposalt || 'CAX_TELEFONE_DDD';
  end if;

  if :new.CAX_OPERACAO_CODIGO <> :old.CAX_OPERACAO_CODIGO then
    camposalt := camposalt || 'CAX_OPERACAO_CODIGO';
  end if;

  if :new.CAX_TELEFONE_NUMERO <> :old.CAX_TELEFONE_NUMERO then
    camposalt := camposalt || 'CAX_TELEFONE_NUMERO';
  end if;

  if :new.FRT_CONJVEICULO_CODIGO <> :old.FRT_CONJVEICULO_CODIGO then
    camposalt := camposalt || 'FRT_CONJVEICULO_CODIGO';
  end if;

  if :new.CAX_TEELFONE_ANO <> :old.CAX_TEELFONE_ANO then
    camposalt := camposalt || 'CAX_TEELFONE_ANO';
  end if;

  if :new.CAX_MOVIMENTO_DOCUMENTO <> :old.CAX_MOVIMENTO_DOCUMENTO then
    camposalt := camposalt || 'CAX_MOVIMENTO_DOCUMENTO';
  end if;

  if :new.CAX_MOVIMENTO_CGCCPF <> :old.CAX_MOVIMENTO_CGCCPF then
    camposalt := camposalt || 'CAX_MOVIMENTO_CGCCPF';
  end if;

  if :new.CAX_MOVIMENTO_FAVORECIDO <> :old.CAX_MOVIMENTO_FAVORECIDO then
    camposalt := camposalt || 'CAX_MOVIMENTO_FAVORECIDO';
  end if;

  if :new.CAX_MOVIMENTO_SERIE <> :old.CAX_MOVIMENTO_SERIE then
    camposalt := camposalt || 'CAX_MOVIMENTO_SERIE';
  end if;

  if :new.CAX_MOVIMENTO_HISTORICO <> :old.CAX_MOVIMENTO_HISTORICO then
    camposalt := camposalt || 'CAX_MOVIMENTO_HISTORICO';
  end if;

  if :new.CAX_MOVIMENTO_VALOR <> :old.CAX_MOVIMENTO_VALOR then
    camposalt := camposalt || 'CAX_MOVIMENTO_VALOR';
  end if;

  if :new.CAX_MOVIMENTO_FREND <> :old.CAX_MOVIMENTO_FREND then
    camposalt := camposalt || 'CAX_MOVIMENTO_FREND';
  end if;

  if :new.CAX_MOVIMENTO_CONTABIL <> :old.CAX_MOVIMENTO_CONTABIL then
    camposalt := camposalt || 'CAX_MOVIMENTO_CONTABIL';
  end if;

  if :new.CAX_MOVIMENTO_USUARIO <> :old.CAX_MOVIMENTO_USUARIO then
    camposalt := camposalt || 'CAX_MOVIMENTO_USUARIO';
  end if;

  if :new.CAX_MOVIMENTO_DTTRANS <> :old.CAX_MOVIMENTO_DTTRANS then
    camposalt := camposalt || 'CAX_MOVIMENTO_DTTRANS';
  end if;

  if :new.CAX_MOVIMENTO_DOCCOMPLEMENTO <> :old.CAX_MOVIMENTO_DOCCOMPLEMENTO then
    camposalt := camposalt || 'CAX_MOVIMENTO_DOCCOMPLEMENTO';
  end if;

  if :new.CAX_MOVIMENTO_DTGRAVACAO <> :old.CAX_MOVIMENTO_DTGRAVACAO then
    camposalt := camposalt || 'CAX_MOVIMENTO_DTGRAVACAO';
  end if;

  if :new.CAX_MOVIMENTO_DATANF <> :old.CAX_MOVIMENTO_DATANF then
    camposalt := camposalt || 'CAX_MOVIMENTO_DATANF';
  end if;

  if :new.CAX_MOVIMENTO_DTCONC <> :old.CAX_MOVIMENTO_DTCONC then
    camposalt := camposalt || 'CAX_MOVIMENTO_DTCONC';
  end if;

    -- DAR ERROR SE O VALE FRETE JA FOI PAGO EM OUTRA ROTA
    -- JOGO A CHAVE DO CAIXA NO VALE DE FRETE
    -- 28/02/2003 - GILES
    -- ALTERADA EM 17/03/2004 - GILES

  --if not  (( :new.cax_movimento_dtconc is null ) and ( :old.cax_movimento_dtconc is not null )) then


    IF ((:NEW.CAX_OPERACAO_CODIGO = '1002') OR
       (:NEW.CAX_OPERACAO_CODIGO  = '2001') OR -- FRETE
       (:NEW.CAX_OPERACAO_CODIGO  = '2201') OR -- FRETE ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO  = '2002') OR -- ADIANTAMENTO PAGO
       (:NEW.CAX_OPERACAO_CODIGO  = '2203') OR -- ADIANTAMENTO FRETE ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO  = '2205') OR -- ADIANTAMENTO Frota
       (:NEW.CAX_OPERACAO_CODIGO  = '2948') OR -- ADIANTAMENTO Frota ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO  = '2227') OR -- PEDAGIO cartao
       (:NEW.CAX_OPERACAO_CODIGO  = '2112') OR -- REFORCO
       (:NEW.CAX_OPERACAO_CODIGO  = '2416') OR -- FRETE 'JB'
       (:NEW.CAX_OPERACAO_CODIGO  = '2328') OR -- PEDAGIO
       (:NEW.CAX_OPERACAO_CODIGO  = '2470')) THEN
      -- VAZIO
      V_CTRC := :NEW.CAX_OPERACAO_CODIGO;
      V_CTRC  := lpad(TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO),6,'0');
      V_SERIE := TRIM(:NEW.CAX_MOVIMENTO_SERIE);
      V_SAQUE := TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO);

     BEGIN
      if V_saque is null Then
         select vf.con_valefrete_saque
            into V_SAQUE
         from t_con_valefrete vf
         where vf.con_conhecimento_codigo =  V_CTRC
           and vf.con_conhecimento_serie = V_SERIE
           and vf.glb_rota_codigo  = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           and ( vf.con_valefrete_frete = :new.cax_movimento_valor
              or vf.con_valefrete_pedagio = :new.cax_movimento_valor
              or vf.con_valefrete_adiantamento = :new.cax_movimento_valor );
      End if;
      EXCEPTION
        when others then
     -- if :NEW.cax_operacao_codigo = '2167' Then
         RAISE_APPLICATION_ERROR(-20015,'Documento não existe-' || Sqlerrm);
      end;

    elsif :NEW.cax_operacao_codigo = '2167' THEN -- vales pagos
      V_DOC := TO_NUMBER(:NEW.CAX_MOVIMENTO_DOCUMENTO);
    END IF;


      IF (:NEW.CAX_OPERACAO_CODIGO in ('2205', -- Adiantamento Frota
                                       '2948') -- Adiantamento Frota Eletronico
         ) Then 

        SELECT trim(v.con_valefrete_placa),
               V.FRT_MOVVAZIO_NUMERO
          INTO V_FROTA        ,
               V_VAZIO
        FROM T_CON_VALEFRETE v
        WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
          AND CON_CONHECIMENTO_SERIE = V_SERIE
          AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
          AND CON_VALEFRETE_SAQUE = V_SAQUE;
         IF v_frota <> :NEW.FRT_CONJVEICULO_CODIGO THEN
            RAISE_APPLICATION_ERROR(-20001,'O FROTA DO VALE FRETE -> ' || v_frota  || ' É DIFERENTE DO FROTA DO CAIXA -> ' || :NEW.FRT_CONJVEICULO_CODIGO  );
         END IF;
     END IF;

     IF (:NEW.CAX_OPERACAO_CODIGO = '2001') OR -- FRETE
        (:NEW.CAX_OPERACAO_CODIGO = '2201') OR -- FRETE ELETRONICO
        (:NEW.CAX_OPERACAO_CODIGO = '2227') OR -- PEDAGIO cartao
        (:NEW.CAX_OPERACAO_CODIGO = '2203') OR -- ADIANTAMENTO FRETE ELETRONICO
        (:NEW.CAX_OPERACAO_CODIGO = '2002') THEN -- ADIANTAMENTO PAGO

        BEGIN
        SELECT trim(v.con_valefrete_placa)
          INTO v_frota
        FROM T_CON_VALEFRETE v
        WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
          AND CON_CONHECIMENTO_SERIE = V_SERIE
          AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
          AND CON_VALEFRETE_SAQUE = V_SAQUE;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_FROTA := '999';
        END;

        IF nvl(v_frota,'null') = 'null' THEN

            BEGIN
            SELECT trim(v.frt_conjveiculo_codigo)
              INTO v_frota
            FROM T_CON_VALEFRETE v
            WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
              AND CON_CONHECIMENTO_SERIE = V_SERIE
              AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
              AND CON_VALEFRETE_SAQUE = V_SAQUE;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                V_FROTA := '999';
            END;

        END IF;



       IF  substr(v_frota,1,3) = '000' THEN
          RAISE_APPLICATION_ERROR(-20002,
                                  'O VALE FRETE É DE FROTA, USE OUTRA OPERACÃO!' ||
                                  '   ' || TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO) || '-' ||
                                  :NEW.CAX_MOVIMENTO_SERIE || '-' ||
                                  TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO) || '-' ||
                                  :NEW.GLB_ROTA_CODIGO_REFERENCIA);
       ELSIF substr(v_frota,1,3) = '999' THEN
          RAISE_APPLICATION_ERROR(-20003,
                                  'O VALE FRETE NÃO EXISTE!' ||
                                  '   ' || TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO) || '-' ||
                                  :NEW.CAX_MOVIMENTO_SERIE || '-' ||
                                  TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO) || '-' ||
                                  :NEW.GLB_ROTA_CODIGO_REFERENCIA);

       END IF;




     END IF;









    IF ((:NEW.CAX_OPERACAO_CODIGO = '2001') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2201') OR -- FRETE ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO = '1002') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2112') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2416') or
       (:NEW.CAX_OPERACAO_CODIGO = '2002') OR -- ADIANTAMENTO Frota
       (:NEW.CAX_OPERACAO_CODIGO = '2203') OR -- ADIANTAMENTO FRETE ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO = '2227') OR -- PEDAGIO cartao
       (:NEW.CAX_OPERACAO_CODIGO = '2205') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2948') OR -- Adiantamento Frota Eletronico
       (:NEW.CAX_OPERACAO_CODIGO = '2328') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2470')) THEN
      -- FRETE
      SELECT COUNT(*)
        INTO V_QTDCANC
        FROM T_CON_VALEFRETE
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND CON_VALEFRETE_STATUS = 'C';

      IF V_QTDCANC >= 1 THEN
        RAISE_APPLICATION_ERROR(-20004,
                                'O VALE FRETE deste documento esta CANCELADO!' ||
                                '   ' || TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO) || '-' ||
                                :NEW.CAX_MOVIMENTO_SERIE || '-' ||
                                TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO) || '-' ||
                                :NEW.GLB_ROTA_CODIGO_REFERENCIA);
      END IF;
    END IF;
    IF ((:NEW.CAX_OPERACAO_CODIGO = '2001') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2227') OR -- PEDAGIO cartao
       (:NEW.CAX_OPERACAO_CODIGO = '2203') OR -- Adiantamento
       (:NEW.CAX_OPERACAO_CODIGO = '2201') OR -- FRETE ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO = '2416')) THEN
      -- FRETE

      SELECT COUNT(*)
        INTO V_QTDCANC
        FROM T_CON_VALEFRETE
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND CON_VALEFRETE_STATUS = 'C';
      IF V_QTDCANC >= 1 THEN
        RAISE_APPLICATION_ERROR(-20005,
                                'O VALE FRETE deste documento esta CANCELADO!' ||
                                '   ' || TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO) || '-' ||
                                :NEW.CAX_MOVIMENTO_SERIE || '-' ||
                                TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO) || '-' ||
                                :NEW.GLB_ROTA_CODIGO_REFERENCIA);
      END IF;

      vLocal := 'Update 1';

      UPDATE T_CON_VALEFRETE
         SET CAX_BOLETIM_DATA        = :NEW.CAX_BOLETIM_DATA,
             CAX_MOVIMENTO_SEQUENCIA = :NEW.CAX_MOVIMENTO_SEQUENCIA,
             GLB_ROTA_CODIGOCX       = :NEW.GLB_ROTA_CODIGO
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE;

      vLocal := 'Update 2';
      UPDATE T_CON_VALEFRETE
         SET CON_VALEFRETE_IMPRESSO  = 'S'
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND NVL(CON_VALEFRETE_IMPRESSO,'N')  <> 'S';


    END IF;

    IF ((:NEW.CAX_OPERACAO_CODIGO = '2002') OR
        (:NEW.CAX_OPERACAO_CODIGO = '2203') OR -- ADIANTAMENTO FRETE ELETRONICO
        (:NEW.CAX_OPERACAO_CODIGO = '2205') OR 
        (:NEW.CAX_OPERACAO_CODIGO = '2948')
       ) THEN
      -- ADIANTAMENTO
      -- ADIANTAMENTO Frota


      IF (( :NEW.CAX_OPERACAO_CODIGO = '2002' ) OR
         (:NEW.CAX_OPERACAO_CODIGO  = '2203' ))  -- ADIANTAMENTO FRETE ELETRONICO
        THEN
          vLocal := 'Update 3';

          UPDATE T_CON_VALEFRETE
             SET CAX_BOLETIM_DATA        = :NEW.CAX_BOLETIM_DATA,
                 CAX_MOVIMENTO_SEQUENCIA = :NEW.CAX_MOVIMENTO_SEQUENCIA,
                 GLB_ROTA_CODIGOCX       = :NEW.GLB_ROTA_CODIGO
           WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
             AND CON_CONHECIMENTO_SERIE = V_SERIE
             AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
             AND CON_VALEFRETE_SAQUE = V_SAQUE;
      ELSE
          vLocal := 'Update 4';

          UPDATE T_CON_VALEFRETE V
             SET CAX_BOLETIM_DATA        = :NEW.CAX_BOLETIM_DATA,
                 CAX_MOVIMENTO_SEQUENCIA = :NEW.CAX_MOVIMENTO_SEQUENCIA,
                 GLB_ROTA_CODIGOCX       = :NEW.GLB_ROTA_CODIGO,
                 V.ACC_ACONTAS_TPDOC     = 'VALEFRETE',
                 V.CON_VALEFRETE_DATARECEBIMENTO = :NEW.CAX_BOLETIM_DATA
           WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
             AND CON_CONHECIMENTO_SERIE = V_SERIE
             AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
             AND CON_VALEFRETE_SAQUE = V_SAQUE;

          vLocal := 'Update 5';
           UPDATE T_FRT_MOVVAZIO MV
             SET MV.FRT_MOVVAZIO_DATARECEBIMENTO = :NEW.CAX_BOLETIM_DATA
           WHERE MV.FRT_MOVVAZIO_NUMERO = V_VAZIO
             AND MV.FRT_MOVVAZIO_DATARECEBIMENTO IS NULL;
      END IF;

      vLocal := 'Update ¨6';
      UPDATE T_CON_VALEFRETE
         SET CON_VALEFRETE_IMPRESSO  = 'S'
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND NVL(CON_VALEFRETE_IMPRESSO,'N')  <> 'S';


    END IF;

    IF (:NEW.CAX_OPERACAO_CODIGO = '2112') THEN
      -- REFORCO
      /*
       SELECT nvl(T1.CON_VALEFRETEDET_SEQ,0)
         INTO V_SEQ
         FROM T_CON_VALEFRETEDET T1
        WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
          AND CON_CONHECIMENTO_SERIE  = V_SERIE
          AND GLB_ROTA_CODIGO         = :NEW.GLB_ROTA_CODIGO_REFERENCIA
          AND CON_VALEFRETE_SAQUE     = V_SAQUE;
      */
          vLocal := 'Update 7';

      UPDATE T_CON_VALEFRETE
         SET CON_CONHECIMENTO_CODIGOCH = V_CTRC,
             CON_CONHECIMENTO_SERIECH  = V_SERIE,
             GLB_ROTA_CODIGOCH         = :NEW.GLB_ROTA_CODIGO_REFERENCIA,
             CON_VALEFRETE_SAQUECH     = V_SAQUE,
             CON_VALEFRETEDET_SEQ      = V_SEQ
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE;

          vLocal := 'Update 8';
      UPDATE T_CON_VALEFRETE
         SET CON_VALEFRETE_IMPRESSO  = 'S'
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND NVL(CON_VALEFRETE_IMPRESSO,'N')  <> 'S';
    END IF;

    IF (:NEW.CAX_OPERACAO_CODIGO = '2001') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2201') -- FRETE ELETRONICO
     THEN
      -- QUANDO ESTIVER DIGITANDO UM FRETE PAGO A CARRETEIRO
      -- ATUALIZA O VALEFRETE CORRESPONDENTE
      SELECT COUNT(*)
        INTO V_QTDCANC
        FROM T_CON_VALEFRETE
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND CON_VALEFRETE_STATUS = 'C';
      IF V_QTDCANC >= 1 THEN
        RAISE_APPLICATION_ERROR(-20006,
                                'O VALE FRETE deste documento esta CANCELADO!' ||
                                '   ' || TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO) || '-' ||
                                :NEW.CAX_MOVIMENTO_SERIE || '-' ||
                                TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO) || '-' ||
                                :NEW.GLB_ROTA_CODIGO_REFERENCIA);
      END IF;
          vLocal := 'Update 9';
      UPDATE T_CON_VFRETECONHEC
         SET CON_VFRETECONHEC_SALDO = 'S'
       WHERE CON_VALEFRETE_CODIGO = V_CTRC
         AND CON_VALEFRETE_SERIE = V_SERIE
         AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE;
      SELECT SUM(NVL(B.CON_VALEFRETE_PEDAGIO, 0))
        INTO V_PEDAGIO
        FROM T_CON_VALEFRETE B
       WHERE B.CON_CONHECIMENTO_CODIGO = V_CTRC
         AND B.CON_CONHECIMENTO_SERIE = V_SERIE
         AND B.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND B.CON_VALEFRETE_SAQUE = V_SAQUE;
      IF V_PEDAGIO = 0 THEN

          vLocal := 'Update 10';
        UPDATE T_CON_VFRETECONHEC
           SET CON_VFRETECONHEC_PEDAGIO   = 'S',
               CON_VFRETECONHEC_RECALCULA = 'S'
         WHERE CON_VALEFRETE_CODIGO = V_CTRC
           AND CON_VALEFRETE_SERIE = V_SERIE
           AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           AND CON_VALEFRETE_SAQUE = V_SAQUE;
      ELSE
        SELECT COUNT(*)
          INTO S_SALDO
          FROM T_CON_VFRETECONHEC
         WHERE CON_VALEFRETE_CODIGO = V_CTRC
           AND CON_VALEFRETE_SERIE = V_SERIE
           AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           AND CON_VALEFRETE_SAQUE = V_SAQUE
           AND CON_VFRETECONHEC_PEDAGIO = 'S';
        IF S_SALDO > 0 THEN
          vLocal := 'Update 11';
          UPDATE T_CON_VFRETECONHEC
             SET CON_VFRETECONHEC_RECALCULA = 'S'
           WHERE CON_VALEFRETE_CODIGO = V_CTRC
             AND CON_VALEFRETE_SERIE = V_SERIE
             AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
             AND CON_VALEFRETE_SAQUE = V_SAQUE;
        END IF;
      END IF;
    END IF;
    -- QUANDO ESTIVER DIGITANDO UM PEDAGIO
    -- ATUALIZA O VALEFRETE CORRESPONDENTE
    -- DEPOIS DE HERDADA A CHAVE, PASSO O
    -- RECALCULA PARA 'S'
    -- 28/02/2003 - GILES
    IF :NEW.CAX_OPERACAO_CODIGO = '2328' THEN
      SELECT COUNT(*)
        INTO V_QTDCANC
        FROM T_CON_VALEFRETE
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND CON_VALEFRETE_STATUS = 'C';
      IF V_QTDCANC >= 1 THEN
        RAISE_APPLICATION_ERROR(-20007,
                                'O VALE FRETE deste documento esta CANCELADO!' ||
                                '   ' || TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO) || '-' ||
                                :NEW.CAX_MOVIMENTO_SERIE || '-' ||
                                TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO) || '-' ||
                                :NEW.GLB_ROTA_CODIGO_REFERENCIA);
      END IF;
      vLocal := 'Update 12';

      UPDATE T_CON_VFRETECONHEC
         SET CON_VFRETECONHEC_PEDAGIO = 'S'
       WHERE CON_VALEFRETE_CODIGO = V_CTRC
         AND CON_VALEFRETE_SERIE = V_SERIE
         AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE;
      SELECT COUNT(*)
        INTO S_SALDO
        FROM T_CON_VFRETECONHEC
       WHERE CON_VALEFRETE_CODIGO = V_CTRC
         AND CON_VALEFRETE_SERIE = V_SERIE
         AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         AND CON_VFRETECONHEC_SALDO = 'S';
      IF S_SALDO > 0 THEN
        vLocal := 'Update 13';
        UPDATE T_CON_VFRETECONHEC
           SET CON_VFRETECONHEC_RECALCULA = 'S'
         WHERE CON_VALEFRETE_CODIGO = V_CTRC
           AND CON_VALEFRETE_SERIE = V_SERIE
           AND GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           AND CON_VALEFRETE_SAQUE = V_SAQUE;
      END IF;
    END IF;
    -- SE ESTIVER DIGITANDO UM DOCUMENTO VF NESSAS OPERAC?ES
    -- COLOCO O VF COMO 'IMPRESSO'
    -- GILES 06/05/2004
    IF ((:NEW.CAX_OPERACAO_CODIGO = '1002') OR
       (:NEW.CAX_OPERACAO_CODIGO = '2001') OR -- FRETE
       (:NEW.CAX_OPERACAO_CODIGO = '2201') OR -- FRETE ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO = '2002') OR -- ADIANTAMENTO PAGO
       (:NEW.CAX_OPERACAO_CODIGO = '2203') OR -- ADIANTAMENTO FRETE ELETRONICO
       (:NEW.CAX_OPERACAO_CODIGO = '2205') OR -- ADIANTAMENTO Frota
       (:NEW.CAX_OPERACAO_CODIGO = '2948') OR -- ADIANTAMENTO Frota Eletronico
       (:NEW.CAX_OPERACAO_CODIGO = '2227') OR -- PEDAGIO cartao
       (:NEW.CAX_OPERACAO_CODIGO = '2328') OR -- PEDAGIO
       (:NEW.CAX_OPERACAO_CODIGO = '2416') OR -- FRETE 'JB'
       (:NEW.CAX_OPERACAO_CODIGO = '2470')) THEN
      -- VAZIO
      vLocal := 'Update 14';
      UPDATE T_CON_VALEFRETE
         SET CON_VALEFRETE_IMPRESSO = 'S'
       WHERE CON_CONHECIMENTO_CODIGO = V_CTRC
         AND CON_CONHECIMENTO_SERIE = V_SERIE
         AND GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
         AND CON_VALEFRETE_SAQUE = V_SAQUE
         and nvl(trim(CON_VALEFRETE_IMPRESSO), 'N') <> 'S';
    END IF;
  -- Adiantamento para o Frota
  if :new.cax_operacao_codigo = '2205' Then
      V_CTRC  := lpad(TRIM(:NEW.CAX_MOVIMENTO_DOCUMENTO),6,'0');
      V_SERIE := TRIM(:NEW.CAX_MOVIMENTO_SERIE);
      V_SAQUE := TRIM(:NEW.CAX_MOVIMENTO_DOCCOMPLEMENTO);

         select min(vf.con_valefrete_saque),
                max(vf.con_valefrete_saque)
            into vMenorSaqueValido,
                 vMaiorSaqueValido
         from t_con_valefrete vf
         where vf.con_conhecimento_codigo =  V_CTRC
           and vf.con_conhecimento_serie = V_SERIE
           and vf.glb_rota_codigo  = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           and vf.con_valefrete_status is null
           and vf.con_catvalefrete_codigo in (pkg_con_valefrete.CatTBonusManifesto,
                                              pkg_con_valefrete.CatTBonusCTRC);


      if V_saque is null Then
         select min(vf.con_valefrete_saque)
            into vMenorSaqueValido
         from t_con_valefrete vf
         where vf.con_conhecimento_codigo =  V_CTRC
           and vf.con_conhecimento_serie = V_SERIE
           and vf.glb_rota_codigo  = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           and vf.con_valefrete_status is null;
      Else
         vMenorSaqueValido :=  V_SAQUE;
      End if;

      -- Se não for o menor saque valido verifica se e troca de Motorista
      if trim(:new.cax_movimento_doccomplemento) <> vMenorSaqueValido Then

         select nvl(vf.con_subcatvalefrete_codigo,'00')
            into vSubCategoria
         from t_con_valefrete vf
         where vf.con_conhecimento_codigo =  V_CTRC
           and vf.con_conhecimento_serie = V_SERIE
           and vf.glb_rota_codigo  = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           and vf.con_valefrete_saque = V_SAQUE
           and vf.con_valefrete_status is null;
     Else
        vSubCategoria := '00';
          IF ( PKG_CON_VALEFRETE.vInsereOp2948 = 'N' ) and 
             ( :new.cax_operacao_codigo = '2948' )
           Then
             raise_application_error(-20010,'Esta operação não pode ser Digitada');
          End If; 
          
     End If;


  End If;

  -- antes de 07/10/2014
  IF ( :NEW.CAX_OPERACAO_CODIGO = '2001' ) OR
     ( :NEW.CAX_OPERACAO_CODIGO = '2201' ) OR
--     ( nvl(vSubCategoria,'00') = '10' ) OR -- Troca de Motorista
     ( ( :new.cax_operacao_codigo = '2205' ) and  ( trim(:new.cax_movimento_doccomplemento) <> vMenorSaqueValido )     )-- FRETE ELETRONICO
     THEN
        vSubCategoria :=  vSubCategoria;
  End If;

  -- apos 10/07/2014
  IF ( :NEW.CAX_OPERACAO_CODIGO = '2001' ) OR
     ( :NEW.CAX_OPERACAO_CODIGO = '2201' ) OR
--     ( ( :new.cax_operacao_codigo = '2205' ) and nvl(vSubCategoria,'00') = '10' ) OR -- Troca de Motorista
     ( ( :new.cax_operacao_codigo = '2205' ) /*and nvl(vSubCategoria,'00') <> '10'*/  and trim(:new.cax_movimento_doccomplemento) <> nvl(vMenorSaqueValido,'0') )
     THEN
        vSubCategoria :=  vSubCategoria;
  End If;
  -- apos 20/02/2015
  IF ( :NEW.CAX_OPERACAO_CODIGO = '2001' ) OR
     ( :NEW.CAX_OPERACAO_CODIGO = '2201' ) OR
--     ( ( :new.cax_operacao_codigo = '2205' ) and nvl(vSubCategoria,'00') = '10' ) OR -- Troca de Motorista
   ( ( :new.cax_operacao_codigo = '2205' ) and trim(:new.cax_movimento_doccomplemento) = nvl(vMaiorSaqueValido,'0') )
     THEN



      V_ROTASCANER := 0;
      SELECT INSTR(P.USU_PERFIL_PARAT,:NEW.GLB_ROTA_CODIGO)
         INTO V_ROTASCANER
      FROM T_USU_PERFIL p
      WHERE P.USU_PERFIL_CODIGO = 'ROTACOMIMG' ;
      -- FORÇA QUE TODAS AS ROTAS TEM SCANER
      V_ROTASCANER := 1;
      -- estes vales de frete estão liberados
      IF INSTR('285622021|285308021|285502021|285917021|286041021|006327057',V_CTRC||:NEW.GLB_ROTA_CODIGO_REFERENCIA) > 0  THEN
         V_ROTASCANER := 0;
      END IF;
      
      SELECT COUNT(*)
        INTO vEstadia
      FROM T_CON_VALEFRETE v
      WHERE V.CON_CONHECIMENTO_CODIGO = V_CTRC
        AND V.CON_CONHECIMENTO_SERIE = V_SERIE
        AND V.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
        AND V.CON_VALEFRETE_SAQUE = V_SAQUE
        AND V.CON_CATVALEFRETE_CODIGO = '17';



      -- VERIFICA SE A ROTA TEM SCANER
      IF nvl(vEstadia,0) = 0 THEN

         /************************************************************************************
         VERIFICA SE O VALE DE FRETE E DE TRANSFERENCIA. SE O DESTIONO DELE ESTA PARA UM DESTINO 
         ONDE É FILIAL
         QUANDO ACABAR A DIGITAÇÃO MANUAL RETIRAR ESTA VALIDADCAO.
         *************************************************************************************/         

         SELECT COUNT(*) TOTAL,
                SUM(DECODE(NVL(C.CON_CONHECIMENTO_ENTREGA,'01/01/1900'),'01/01/1900',1,0)) SEMDATA
           INTO V_CONTADOR,
                V_CONTADORSD
         FROM T_CON_VFRETECONHEC VFC,
              T_CON_VALEFRETE VF,
              T_CON_CONHECIMENTO C
         WHERE VFC.CON_VALEFRETE_CODIGO = V_CTRC
           AND VFC.CON_VALEFRETE_SERIE = V_SERIE
           AND VFC.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           AND VFC.CON_VALEFRETE_SAQUE = V_SAQUE
           AND VFC.CON_VALEFRETE_CODIGO = VF.CON_CONHECIMENTO_CODIGO
           AND VFC.CON_VALEFRETE_SERIE = VF.CON_CONHECIMENTO_SERIE
           AND VFC.GLB_ROTA_CODIGOVALEFRETE = VF.GLB_ROTA_CODIGO
           AND VFC.CON_VALEFRETE_SAQUE = VF.CON_VALEFRETE_SAQUE
           AND VFC.CON_CONHECIMENTO_CODIGO = C.CON_CONHECIMENTO_CODIGO
           AND VFC.CON_CONHECIMENTO_SERIE = C.CON_CONHECIMENTO_SERIE
           AND VFC.GLB_ROTA_CODIGO = C.GLB_ROTA_CODIGO
--           and pkg_con_valefrete.FN_Get_EmbTransferencia2(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo) <> 'Transf. chekin feito';
--           and pkg_con_valefrete.FN_Get_EmbTransferencia2(vfc.con_conhecimento_codigo,vfc.con_conhecimento_serie,vfc.glb_rota_codigo) <> 'Sim';
           and nvl(vfc.con_vfreteconhec_transfchekin,'Normal') <> 'Sim';
--           AND PKG_CON_VALEFRETE.F_BUSCA_TRANSFENTREARMAZEM(VF.GLB_LOCALIDADE_CODIGODES) = 'N';



         IF V_CONTADOR > 0  THEN
           -- EXCLUI OS GRUPOS DE EXCESSÃO
            SELECT COUNT(*),
                   SUM(DECODE(NVL(CT.CON_CONHECIMENTO_ENTREGA,'01/01/1900'),'01/01/1900',1,0)) SEMDATA
              INTO V_CONTADOR,
                   V_CONTADORSD
            FROM T_CON_VFRETECONHEC VFC,
                 T_CON_VALEFRETE VF,
                 T_CON_CONHECIMENTO CT,
                 T_GLB_CLIENTE CL
            WHERE VFC.CON_VALEFRETE_CODIGO = V_CTRC
              AND VFC.CON_VALEFRETE_SERIE = V_SERIE
              AND VFC.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
              AND VFC.CON_VALEFRETE_SAQUE = V_SAQUE
              AND VFC.CON_CONHECIMENTO_CODIGO = CT.CON_CONHECIMENTO_CODIGO
              AND VFC.CON_CONHECIMENTO_SERIE  = CT.CON_CONHECIMENTO_SERIE
              AND VFC.GLB_ROTA_CODIGO         = CT.GLB_ROTA_CODIGO
              AND CT.GLB_CLIENTE_CGCCPFSACADO = CL.GLB_CLIENTE_CGCCPFCODIGO
              AND VFC.CON_VALEFRETE_CODIGO    = VF.CON_CONHECIMENTO_CODIGO
              AND VFC.CON_VALEFRETE_SERIE     = VF.CON_CONHECIMENTO_SERIE
              AND VFC.GLB_ROTA_CODIGOVALEFRETE = VF.GLB_ROTA_CODIGO
              AND VFC.CON_VALEFRETE_SAQUE      = VF.CON_VALEFRETE_SAQUE
              AND CL.GLB_CLIENTE_EXIGECOMPROVANTE  = 'S'
              AND CL.GLB_GRUPOECONOMICO_CODIGO NOT IN ('0001', -- ARCERLOMITAL
                                                       '0000') -- DELLA VOLPE
              -- LIBERADAS AS CATEGORIAS
              AND VF.CON_CATVALEFRETE_CODIGO NOT IN (pkg_con_valefrete.CatTCocaCola,
--                                                     pkg_con_valefrete.CatTColeta,  
                                                     pkg_con_valefrete.CatTEstadia) 
--              AND VFC.GLB_ROTA_CODIGOVALEFRETE < '900'
              -- colocado a pedido do Marcelo. Documentos Antigos de Junho 26/10/2011 - Sirlano
--            AND vfc.glb_rota_codigovalefrete || vfc.con_valefrete_codigo NOT IN ('461744083','460017479','460017474','033028876')
              -- autorizado pelo Gilberto liberei estes abaixo e entraremos no novo processo, são 8 saques
              -- de emitir uma nota para cada veiculo/semana no final do mes faremos uma unica nota.
              AND vfc.glb_rota_codigovalefrete || vfc.con_valefrete_codigo NOT IN ('461893444');

            IF V_CONTADOR > 0 THEN



               SELECT SUM(DECODE(nvl(CI.GLB_SUBGRUPOIMAGEM_CODIGO || ci.glb_tpimagem_codigo ,'010001'),'010001',1,0)) TOMADOR,
                      SUM(DECODE(nvl(CI.GLB_SUBGRUPOIMAGEM_CODIGO || ci.glb_tpimagem_codigo ,'010001'),'010001',0,1)) COMPROVANTEF,
                      SUM(DECODE(nvl(CI.GLB_SUBGRUPOIMAGEM_CODIGO || ci.glb_tpimagem_codigo ,'010002'),'010002',0,1)) COMPROVANTEV,
                      COUNT(*) TOTAL,
                      SUM(DECODE(NVL(CT.CON_CONHECIMENTO_ENTREGA,'01/01/1900'),'01/01/1900',1,0)) SEMDATA
                 INTO V_QTDEIMG,
                      V_QTDCOMPRV,
                      V_QTDCOMPRF,
                      V_CONTADOR,
                      V_CONTADORSD
               FROM T_GLB_COMPIMAGEM   CI,
                    T_CON_VFRETECONHEC VC,
                    T_CON_VALEFRETE    VF  ,
                    T_CON_CONHECIMENTO CT,
                    T_GLB_EMBALAGEM EB,
                    T_SLF_TABELA TA,
                    T_SLF_SOLFRETE SF,
                    T_FCF_TPCARGA TCT,
                    T_FCF_TPCARGA TCS
               WHERE VC.CON_VALEFRETE_CODIGO       = V_CTRC
                 AND VC.CON_VALEFRETE_SERIE        = V_SERIE
                 AND VC.GLB_ROTA_CODIGOVALEFRETE   = :NEW.GLB_ROTA_CODIGO_REFERENCIA
                 AND VC.CON_VALEFRETE_SAQUE        = V_SAQUE
                 AND CT.GLB_EMBALAGEM_CODIGO       = EB.GLB_EMBALAGEM_CODIGO
                 AND VC.CON_VALEFRETE_CODIGO       = VF.CON_CONHECIMENTO_CODIGO
                 AND VC.CON_VALEFRETE_SERIE        = VF.CON_CONHECIMENTO_SERIE
                 AND VC.GLB_ROTA_CODIGOVALEFRETE   = VF.GLB_ROTA_CODIGO
                 AND VC.CON_VALEFRETE_SAQUE        = VF.CON_VALEFRETE_SAQUE
                 AND VC.CON_CONHECIMENTO_CODIGO = CT.CON_CONHECIMENTO_CODIGO
                 AND VC.CON_CONHECIMENTO_SERIE  = CT.CON_CONHECIMENTO_SERIE
                 AND VC.GLB_ROTA_CODIGO         = CT.GLB_ROTA_CODIGO
                 AND CT.SLF_SOLFRETE_CODIGO        = SF.SLF_SOLFRETE_CODIGO (+)
                 AND CT.SLF_SOLFRETE_SAQUE         = SF.SLF_SOLFRETE_SAQUE (+)
                 AND SF.FCF_TPCARGA_CODIGO         = TCS.FCF_TPCARGA_CODIGO (+) 
--                 AND NVL(TCS.FCF_TPCARGA_IMAGEMOBRG,'S') = 'S' 
                 AND NVL(EB.GLB_EMBALAGEM_IMAGEMOBRG,'S') = 'S' 
                 AND CT.SLF_TABELA_CODIGO          = TA.SLF_TABELA_CODIGO (+)
                 AND CT.SLF_TABELA_SAQUE           = TA.SLF_TABELA_SAQUE (+)
                 AND TA.FCF_TPCARGA_CODIGO         = TCT.FCF_TPCARGA_CODIGO (+)
                 AND NVL(TCT.FCF_TPCARGA_IMAGEMOBRG,'N') = 'S'
                 AND VC.CON_CONHECIMENTO_CODIGO    = CI.CON_CONHECIMENTO_CODIGO  (+)
                 AND VC.CON_CONHECIMENTO_SERIE     = CI.CON_CONHECIMENTO_SERIE   (+)
                 AND VC.GLB_ROTA_CODIGO            = CI.GLB_ROTA_CODIGO          (+)
                 AND 'S'                           = CI.GLB_COMPIMAGEM_ARQUIVADO (+)
--                 and '0001'                        = ci.glb_tpimagem_codigo      (+)
--                 and pkg_con_valefrete.FN_Get_EmbTransferencia2(vc.con_conhecimento_codigo,vc.con_conhecimento_serie,vc.glb_rota_codigo) <> 'Sim';
                 --Só pode solicitar imagem para as embalagens que não forem de transferência.
                 and nvl(vc.con_vfreteconhec_transfchekin,'Normal') <> 'Sim';

/*                 
                  SELECT distinct vf.con_valefrete_datacadastro cadvf,
                         vc.con_valefrete_codigo vfrete,
                         vc.con_valefrete_serie srvf,
                         vc.glb_rota_codigovalefrete rtvf,
                         vc.con_valefrete_saque sq,
                         vc.con_conhecimento_codigo cte,
                         vc.glb_rota_codigo rtcte,
                         vc.con_conhecimento_serie srcte,
                         vc.con_vfreteconhec_transfchekin transfchekin,
                         vc.arm_armazem_codigo armtransf,
                         (SELECT DISTINCT EB.ARM_EMBALAGEM_NUMERO
                          FROM TDVADM.T_ARM_NOTA AN,
                               TDVADM.T_ARM_EMBALAGEM EB,
                               TDVADM.T_ARM_ARMAZEM A
                          WHERE AN.CON_CONHECIMENTO_CODIGO = VC.CON_CONHECIMENTO_CODIGO
                            AND AN.CON_CONHECIMENTO_SERIE = VC.CON_CONHECIMENTO_SERIE
                            AND AN.GLB_ROTA_CODIGO = VC.GLB_ROTA_CODIGO
                            AND AN.ARM_EMBALAGEM_NUMERO = EB.ARM_EMBALAGEM_NUMERO
                            AND AN.ARM_EMBALAGEM_FLAG = EB.ARM_EMBALAGEM_FLAG
                            AND AN.ARM_EMBALAGEM_SEQUENCIA = EB.ARM_EMBALAGEM_SEQUENCIA
                            AND nvl(EB.ARM_ARMAZEM_CODIGO,A.ARM_ARMAZEM_CODIGO) = A.ARM_ARMAZEM_CODIGO
                            AND ROWNUM = 1) EMBALAGEM,
*/
                  SELECT sum((SELECT COUNT(distinct EB.ARM_EMBALAGEM_NUMERO)
                          FROM TDVADM.T_ARM_NOTA AN,
                               TDVADM.T_ARM_EMBALAGEM EB,
                               TDVADM.T_ARM_ARMAZEM A
                          WHERE AN.CON_CONHECIMENTO_CODIGO = VC.CON_CONHECIMENTO_CODIGO
                            AND AN.CON_CONHECIMENTO_SERIE = VC.CON_CONHECIMENTO_SERIE
                            AND AN.GLB_ROTA_CODIGO = VC.GLB_ROTA_CODIGO
                            AND AN.ARM_EMBALAGEM_NUMERO = EB.ARM_EMBALAGEM_NUMERO
                            AND AN.ARM_EMBALAGEM_FLAG = EB.ARM_EMBALAGEM_FLAG
                            AND AN.ARM_EMBALAGEM_SEQUENCIA = EB.ARM_EMBALAGEM_SEQUENCIA
                            AND EB.ARM_ARMAZEM_CODIGO = A.ARM_ARMAZEM_CODIGO
                            AND nvl(A.GLB_ROTA_CODIGO,VC.GLB_ROTA_CODIGOVALEFRETE) = VC.GLB_ROTA_CODIGOVALEFRETE)) ckeckin
                       INTO v_QTDSEMCHEKIN
                  FROM tdvadm.T_GLB_COMPIMAGEM   CI,
                       tdvadm.T_CON_VFRETECONHEC VC,
                       tdvadm.T_CON_VALEFRETE    VF  ,
                       tdvadm.T_CON_CONHECIMENTO CT,
                       tdvadm.T_GLB_EMBALAGEM EB,
                       tdvadm.T_SLF_TABELA TA,
                       tdvadm.T_SLF_SOLFRETE SF,
                       tdvadm.T_FCF_TPCARGA TCT,
                       tdvadm.T_FCF_TPCARGA TCS
                  WHERE 0 = 0
                    and VC.CON_VALEFRETE_CODIGO       = V_CTRC
                    AND VC.CON_VALEFRETE_SERIE        = V_SERIE
                    AND VC.GLB_ROTA_CODIGOVALEFRETE   = :NEW.GLB_ROTA_CODIGO_REFERENCIA
                    AND VC.CON_VALEFRETE_SAQUE        = V_SAQUE
                    AND VF.CON_VALEFRETE_FIFO         = 'S'
                    AND CT.GLB_EMBALAGEM_CODIGO       = EB.GLB_EMBALAGEM_CODIGO
                    AND VC.CON_VALEFRETE_CODIGO       = VF.CON_CONHECIMENTO_CODIGO
                    AND VC.CON_VALEFRETE_SERIE        = VF.CON_CONHECIMENTO_SERIE
                    AND VC.GLB_ROTA_CODIGOVALEFRETE   = VF.GLB_ROTA_CODIGO
                    AND VC.CON_VALEFRETE_SAQUE        = VF.CON_VALEFRETE_SAQUE
                    AND VC.CON_CONHECIMENTO_CODIGO = CT.CON_CONHECIMENTO_CODIGO
                    AND VC.CON_CONHECIMENTO_SERIE  = CT.CON_CONHECIMENTO_SERIE
                    AND VC.GLB_ROTA_CODIGO         = CT.GLB_ROTA_CODIGO
                    AND CT.SLF_SOLFRETE_CODIGO        = SF.SLF_SOLFRETE_CODIGO (+)
                    AND CT.SLF_SOLFRETE_SAQUE         = SF.SLF_SOLFRETE_SAQUE (+)
                    AND SF.FCF_TPCARGA_CODIGO         = TCS.FCF_TPCARGA_CODIGO (+)
                    AND NVL(EB.GLB_EMBALAGEM_IMAGEMOBRG,'S') = 'S'
                    AND CT.SLF_TABELA_CODIGO          = TA.SLF_TABELA_CODIGO (+)
                    AND CT.SLF_TABELA_SAQUE           = TA.SLF_TABELA_SAQUE (+)
                    AND TA.FCF_TPCARGA_CODIGO         = TCT.FCF_TPCARGA_CODIGO (+)
                    AND NVL(TCT.FCF_TPCARGA_IMAGEMOBRG,'N') = 'S'
                    AND VC.CON_CONHECIMENTO_CODIGO    = CI.CON_CONHECIMENTO_CODIGO  (+)
                    AND VC.CON_CONHECIMENTO_SERIE     = CI.CON_CONHECIMENTO_SERIE   (+)
                    AND VC.GLB_ROTA_CODIGO            = CI.GLB_ROTA_CODIGO          (+)
                    AND 'S'                           = CI.GLB_COMPIMAGEM_ARQUIVADO (+)
                    and vc.arm_armazem_codigo is not null;


                insert into t_grd_audit
                  (uti_audit_acao,
                   uti_audit_datagravacao,
                   uti_audit_valoratual,
                   uti_audit_valoranterior,
                   uti_audit_maquina,
                   uti_audit_ouser,
                   uti_audit_programa)
                values
                  ('Inserir Lancamento Caixa',
                   sysdate,
                   'V_CTRC: '||V_CTRC||' V_SERIE: '||V_SERIE||' ROTA: '||:NEW.GLB_ROTA_CODIGO_REFERENCIA||' V_SAQUE: '||V_SAQUE,
                   'V_QTDEIMG: '||V_QTDEIMG||' V_QTDCOMPRV: '||V_QTDCOMPRV||' V_QTDCOMPRF: '||V_QTDCOMPRF||' V_CONTADOR: '||V_CONTADOR || 'V_CONTADORSD: ' || V_CONTADORSD,
                   vTerminal,
                   v_usuario,
                   V_PROGRAM);
                   
                        
           
               IF ( V_QTDEIMG > 0 ) OR ( V_CONTADORSD > 0 ) or ( V_QTDCOMPRF <> V_QTDCOMPRV  ) /*or ( v_QTDSEMCHEKIN > 0 )*/  THEN
                   
                          raise_application_error(-20008,chr(10) ||
                                  '************************************************************************************' || chr(10) ||
                                  '[' || V_SAQUE || '] 1-FALTAM SCANEAR' || TO_CHAR(V_QTDEIMG,'999') || ' /' || TO_CHAR(V_CONTADOR,'999') || ' IMAGENS DE COMPROVANTES ' || CHR(10) ||
                                  'IMAGENS VIA COMPRAVANTES FRENTE' || TO_CHAR(V_QTDCOMPRF,'999') || ' /' || TO_CHAR(V_CONTADOR,'999') || CHR(10) ||
                                  'IMAGENS VIA COMPRAVANTES VERSO ' || TO_CHAR(V_QTDCOMPRV,'999') || ' /' || TO_CHAR(V_CONTADOR,'999') || CHR(10) ||
                                  'CONHECIMENTOS SEM BAIXA ' || TO_CHAR(V_CONTADORSD,'999') || CHR(10) ||
                                  '1-FALTAM EMBALAGENS SEM CHECK-IN ' || to_char(v_QTDSEMCHEKIN,'999') || chr(10) ||
                                  'PARA ESTE VALE DE FRETE - ' || ' ROTA - ' || :NEW.GLB_ROTA_CODIGO || ' - rota REFERENCIA ' || :NEW.GLB_ROTA_CODIGO_REFERENCIA || CHR(10) ||
                                  '             DUVIDAS LIGAR PARA RICARDO NO ADMINISTRATIVO (11) 2967-8551    ....' || CHR(10) ||
                                  'USE O GERDOR DE PLANILHAS RELATORIO -  CAX - Relatório de imagens ctrc no vale frete' || chr(10) ||
                                  'PROGRAMA - ' || V_PROGRAM || chr(10) ||
                                  '************************************************************************************' || chr(10));
               END IF;
               /* IF UPPER(TRIM(V_PROGRAM)) in ('PRJ_CAPFATATUALIZACONTAS.EXE','PLSQLDEV.EXE','SQLPLUS.EXE') or ( v_Ip = '192.9.200.101' ) THEN
                   V_QTDEIMG := 0;
                  END IF;
               */


/*****************************************************************************************
VERIFICA SE O CNPJ COM A SEU DESTINO ESTA LIBERADO.
******************************************************************************************/               
                
                   SELECT NVL(SUM(DECODE(nvl(CI.GLB_SUBGRUPOIMAGEM_CODIGO || ci.glb_tpimagem_codigo ,'010001'),'010001',1,0)),0) TOMADOR,
                          NVL(SUM(DECODE(nvl(CI.GLB_SUBGRUPOIMAGEM_CODIGO || ci.glb_tpimagem_codigo ,'010001'),'010001',0,1)),0) COMPROVANTEF,
                          NVL(SUM(DECODE(nvl(CI.GLB_SUBGRUPOIMAGEM_CODIGO || ci.glb_tpimagem_codigo ,'010002'),'010002',0,1)),0) COMPROVANTEV,
                          COUNT(*) TOTAL,
                          NVL(SUM(DECODE(NVL(CT.CON_CONHECIMENTO_ENTREGA,'01/01/1900'),'01/01/1900',1,0)),0) SEMDATA
                     INTO V_QTDEIMG,
                          V_QTDCOMPRV,
                          V_QTDCOMPRF,
                          V_CONTADOR,
                          V_CONTADORSD
                   FROM T_GLB_COMPIMAGEM   CI,
                        T_CON_VFRETECONHEC VC,
                        T_CON_VALEFRETE    VF  ,
                        T_CON_CONHECIMENTO CT,
                        T_GLB_EMBALAGEM EB,
                        T_SLF_TABELA TA,
                        T_SLF_SOLFRETE SF,
                        T_FCF_TPCARGA TCT,
                        T_FCF_TPCARGA TCS
                   WHERE VC.CON_VALEFRETE_CODIGO       = V_CTRC
                     AND VC.CON_VALEFRETE_SERIE        = V_SERIE
                     AND VC.GLB_ROTA_CODIGOVALEFRETE   = :NEW.GLB_ROTA_CODIGO_REFERENCIA
                     AND VC.CON_VALEFRETE_SAQUE        = V_SAQUE
                     AND VC.CON_VALEFRETE_CODIGO       = VF.CON_CONHECIMENTO_CODIGO
                     AND VC.CON_VALEFRETE_SERIE        = VF.CON_CONHECIMENTO_SERIE
                     AND VC.GLB_ROTA_CODIGOVALEFRETE   = VF.GLB_ROTA_CODIGO
                     AND VC.CON_VALEFRETE_SAQUE        = VF.CON_VALEFRETE_SAQUE
                     AND CT.GLB_EMBALAGEM_CODIGO       = EB.GLB_EMBALAGEM_CODIGO
                     AND VC.CON_CONHECIMENTO_CODIGO    = CT.CON_CONHECIMENTO_CODIGO
                     AND VC.CON_CONHECIMENTO_SERIE     = CT.CON_CONHECIMENTO_SERIE
                     AND VC.GLB_ROTA_CODIGO            = CT.GLB_ROTA_CODIGO
                     AND CT.SLF_SOLFRETE_CODIGO        = SF.SLF_SOLFRETE_CODIGO (+)
                     AND CT.SLF_SOLFRETE_SAQUE         = SF.SLF_SOLFRETE_SAQUE (+)
                     AND SF.FCF_TPCARGA_CODIGO         = TCS.FCF_TPCARGA_CODIGO (+) 
                     AND NVL(TCS.FCF_TPCARGA_IMAGEMOBRG,'S') = 'S'
                     AND NVL(EB.GLB_EMBALAGEM_IMAGEMOBRG,'S') = 'S'
                     AND CT.SLF_TABELA_CODIGO          = TA.SLF_TABELA_CODIGO (+)
                     AND CT.SLF_TABELA_SAQUE           = TA.SLF_TABELA_SAQUE (+)
                     AND TA.FCF_TPCARGA_CODIGO         = TCT.FCF_TPCARGA_CODIGO (+)
                     AND NVL(TCT.FCF_TPCARGA_IMAGEMOBRG,'S') = 'S'
                     AND VC.CON_CONHECIMENTO_CODIGO    = CI.CON_CONHECIMENTO_CODIGO  (+)
                     AND VC.CON_CONHECIMENTO_SERIE     = CI.CON_CONHECIMENTO_SERIE   (+)
                     AND VC.GLB_ROTA_CODIGO            = CI.GLB_ROTA_CODIGO          (+)
                     AND 'S'                           = CI.GLB_COMPIMAGEM_ARQUIVADO (+)
--                     and pkg_con_valefrete.FN_Get_EmbTransferencia2(vc.con_conhecimento_codigo,vc.con_conhecimento_serie,vc.glb_rota_codigo) <> 'Sim' 
                     and nvl(VC.CON_VFRETECONHEC_TRANSFCHEKIN,'Normal') <> 'Sim'
    --                 and '0001'                        = ci.glb_tpimagem_codigo      (+)
                     and tdvadm.pkg_con_valefrete.FN_Get_CNPJLOCLIBIMAGEM(CT.GLB_CLIENTE_CGCCPFREMETENTE,
                                                                          CT.GLB_CLIENTE_CGCCPFDESTINATARIO, 
                                                                          CT.GLB_CLIENTE_CGCCPFSACADO,
                                                                          CT.GLB_LOCALIDADE_CODIGOORIGEM,
                                                                          CT.GLB_LOCALIDADE_CODIGODESTINO) = 'N';


               SELECT count(*) SEMCHECKIN
                 INTO v_QTDSEMCHEKIN
                   FROM T_GLB_COMPIMAGEM   CI,
                        T_CON_VFRETECONHEC VC,
                        T_CON_VALEFRETE    VF  ,
                        T_CON_CONHECIMENTO CT,
                        T_GLB_EMBALAGEM EB,
                        T_SLF_TABELA TA,
                        T_SLF_SOLFRETE SF,
                        T_FCF_TPCARGA TCT,
                        T_FCF_TPCARGA TCS
                   WHERE VC.CON_VALEFRETE_CODIGO       = V_CTRC
                     AND VC.CON_VALEFRETE_SERIE        = V_SERIE
                     AND VC.GLB_ROTA_CODIGOVALEFRETE   = :NEW.GLB_ROTA_CODIGO_REFERENCIA
                     AND VC.CON_VALEFRETE_SAQUE        = V_SAQUE
                     AND VC.CON_VALEFRETE_CODIGO       = VF.CON_CONHECIMENTO_CODIGO
                     AND VC.CON_VALEFRETE_SERIE        = VF.CON_CONHECIMENTO_SERIE
                     AND VC.GLB_ROTA_CODIGOVALEFRETE   = VF.GLB_ROTA_CODIGO
                     AND VC.CON_VALEFRETE_SAQUE        = VF.CON_VALEFRETE_SAQUE
                     AND CT.GLB_EMBALAGEM_CODIGO       = EB.GLB_EMBALAGEM_CODIGO
                     AND VC.CON_CONHECIMENTO_CODIGO    = CT.CON_CONHECIMENTO_CODIGO
                     AND VC.CON_CONHECIMENTO_SERIE     = CT.CON_CONHECIMENTO_SERIE
                     AND VC.GLB_ROTA_CODIGO            = CT.GLB_ROTA_CODIGO
                     AND CT.SLF_SOLFRETE_CODIGO        = SF.SLF_SOLFRETE_CODIGO (+)
                     AND CT.SLF_SOLFRETE_SAQUE         = SF.SLF_SOLFRETE_SAQUE (+)
                     AND SF.FCF_TPCARGA_CODIGO         = TCS.FCF_TPCARGA_CODIGO (+) 
                     AND NVL(TCS.FCF_TPCARGA_IMAGEMOBRG,'S') = 'S'
                     AND NVL(EB.GLB_EMBALAGEM_IMAGEMOBRG,'S') = 'S'
                     AND CT.SLF_TABELA_CODIGO          = TA.SLF_TABELA_CODIGO (+)
                     AND CT.SLF_TABELA_SAQUE           = TA.SLF_TABELA_SAQUE (+)
                     AND TA.FCF_TPCARGA_CODIGO         = TCT.FCF_TPCARGA_CODIGO (+)
                     AND NVL(TCT.FCF_TPCARGA_IMAGEMOBRG,'S') = 'S'
                     AND VC.CON_CONHECIMENTO_CODIGO    = CI.CON_CONHECIMENTO_CODIGO  (+)
                     AND VC.CON_CONHECIMENTO_SERIE     = CI.CON_CONHECIMENTO_SERIE   (+)
                     AND VC.GLB_ROTA_CODIGO            = CI.GLB_ROTA_CODIGO          (+)
                     AND 'S'                           = CI.GLB_COMPIMAGEM_ARQUIVADO (+)
--                     and pkg_con_valefrete.FN_Get_EmbTransferencia2(vc.con_conhecimento_codigo,vc.con_conhecimento_serie,vc.glb_rota_codigo) = 'Sim'
                     and nvl(VC.CON_VFRETECONHEC_TRANSFCHEKIN,'Normal') <> 'Sim'
--                     and '0001'                        = ci.glb_tpimagem_codigo      (+)
                     and tdvadm.pkg_con_valefrete.FN_Get_CNPJLOCLIBIMAGEM(CT.GLB_CLIENTE_CGCCPFREMETENTE,
                                                                          CT.GLB_CLIENTE_CGCCPFDESTINATARIO, 
                                                                          CT.GLB_CLIENTE_CGCCPFSACADO,
                                                                          CT.GLB_LOCALIDADE_CODIGOORIGEM,
                                                                          CT.GLB_LOCALIDADE_CODIGODESTINO) = 'N';
                   


                    IF ( V_QTDEIMG > 0 ) OR ( V_CONTADORSD > 0 ) or ( V_QTDCOMPRF <> V_QTDCOMPRV  ) /*or ( v_QTDSEMCHEKIN > 0 )*/THEN
                         raise_application_error(-20008,chr(10) ||
                              '************************************************************************************' || chr(10) ||
                              '[' || V_SAQUE || '] 2-FALTAM SCANEAR' || TO_CHAR(V_QTDEIMG,'999') || ' /' || TO_CHAR(V_CONTADOR,'999') || ' IMAGENS DE COMPROVANTES ' || CHR(10) ||
                              'IMAGENS VIA COMPRAVANTES FRENTE' || TO_CHAR(V_QTDCOMPRF,'999') || ' /' || TO_CHAR(V_CONTADOR,'999') || CHR(10) ||
                              'IMAGENS VIA COMPRAVANTES VERSO ' || TO_CHAR(V_QTDCOMPRV,'999') || ' /' || TO_CHAR(V_CONTADOR,'999') || CHR(10) ||
                              'CONHECIMENTOS SEM BAIXA ' || TO_CHAR(V_CONTADORSD,'999') || CHR(10) ||
                              '2-FALTAM EMBALAGENS SEM CHECK-IN ' || to_char(v_QTDSEMCHEKIN,'999') || chr(10) ||
                              'PARA ESTE VALE DE FRETE - ' || ' ROTA - ' || :NEW.GLB_ROTA_CODIGO || ' - rota REFERENCIA ' || :NEW.GLB_ROTA_CODIGO_REFERENCIA || CHR(10) ||
                              '             DUVIDAS LIGAR PARA RICARDO NO ADMINISTRATIVO (11) 2967-8551    ....' || CHR(10) ||
                              'USE O GERDOR DE PLANILHAS RELATORIO -  CAX - Relatório de imagens ctrc no vale frete' || chr(10) ||
                              'PROGRAMA - ' || V_PROGRAM || chr(10) ||
                              '************************************************************************************' || chr(10));
                  END IF;
                   
                    -- VERIFICA SE O CNPJ/DESTINO ESTÃO LIBERADOS
         
            END IF; -- VERIFICA SE EXITE UM GRUPO NA EXCESSAO OU CATEGORIA DE VALE DE FRETE
         END IF; -- VERIFICA SE É VALE DE FRETE DE TRANSFERENCIA

         /**********************************************************/
         /*   controle de outros comprovantes a partir desta linha */
         /**********************************************************/
         
            SELECT COUNT(*),
                   SUM(DECODE(NVL(CT.CON_CONHECIMENTO_ENTREGA,'01/01/1900'),'01/01/1900',1,0)) SEMDATA
              INTO V_CONTADOR,
                   V_CONTADORSD
            FROM T_CON_VFRETECONHEC VFC,
                 T_CON_VALEFRETE VF,
                 T_CON_CONHECIMENTO CT,
                 T_GLB_CLIENTE CL
            WHERE VFC.CON_VALEFRETE_CODIGO = V_CTRC
              AND VFC.CON_VALEFRETE_SERIE = V_SERIE
              AND VFC.GLB_ROTA_CODIGOVALEFRETE = :NEW.GLB_ROTA_CODIGO_REFERENCIA
              AND VFC.CON_VALEFRETE_SAQUE = V_SAQUE
              AND VFC.CON_CONHECIMENTO_CODIGO = CT.CON_CONHECIMENTO_CODIGO
              AND VFC.CON_CONHECIMENTO_SERIE  = CT.CON_CONHECIMENTO_SERIE
              AND VFC.GLB_ROTA_CODIGO         = CT.GLB_ROTA_CODIGO
              AND CT.GLB_CLIENTE_CGCCPFSACADO = CL.GLB_CLIENTE_CGCCPFCODIGO
              AND VFC.CON_VALEFRETE_CODIGO    = VF.CON_CONHECIMENTO_CODIGO
              AND VFC.CON_VALEFRETE_SERIE     = VF.CON_CONHECIMENTO_SERIE
              AND VFC.GLB_ROTA_CODIGOVALEFRETE = VF.GLB_ROTA_CODIGO
              AND VFC.CON_VALEFRETE_SAQUE      = VF.CON_VALEFRETE_SAQUE
--              AND CL.GLB_CLIENTE_EXIGECOMPROVANTE  = 'S'
              AND CL.GLB_GRUPOECONOMICO_CODIGO  IN ('0547')  -- OTIS
--              AND VFC.GLB_ROTA_CODIGOVALEFRETE < '900'
              ;
              
              

              /*
              -- LIBERADAS AS CATEGORIAS
              AND VF.CON_CATVALEFRETE_CODIGO NOT IN (pkg_con_valefrete.CatTCocaCola, 
                                                     pkg_con_valefrete.CatTEstadia, 
                                                     pkg_con_valefrete.CatTColeta) 
              -- colocado a pedido do Marcelo. Documentos Antigos de Junho 26/10/2011 - Sirlano
--            AND vfc.glb_rota_codigovalefrete || vfc.con_valefrete_codigo NOT IN ('461744083','460017479','460017474','033028876')
              -- autorizado pelo Gilberto liberei estes abaixo e entraremos no novo processo, são 8 saques
              -- de emitir uma nota para cada veiculo/semana no final do mes faremos uma unica nota.
              AND vfc.glb_rota_codigovalefrete || vfc.con_valefrete_codigo NOT IN ('461893444');


*/

      IF V_CONTADOR > 0 THEN
        select  count(*),
                sum(decode(nvl(vi.glb_vfimagem_arquivado,'N'),'S',1,0)),
                sum(decode(nvl(vi.usu_usuario_codigoconf,vi.usu_usuario_codigocriou),vi.usu_usuario_codigocriou,0,1))
           into V_QTDEIMG,
                V_CONTADORREC,
                V_CONTADORNAPROV
         from tdvadm.t_glb_vfimagem vi
         WHERE Vi.Con_Conhecimento_Codigo = V_CTRC
           AND Vi.Con_Conhecimento_Serie  = V_SERIE
           AND Vi.GLB_ROTA_CODIGO         = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           AND Vi.Glb_Grupoimagem_Codigo  = '11'
           AND Vi.CON_VALEFRETE_SAQUE     = V_SAQUE;
           
           if( V_QTDEIMG < 4 )  or -- Quantidade
             ( V_CONTADORNAPROV < 4 ) or -- Autorizado
             ( V_QTDEIMG <> V_CONTADORREC  )  Then -- Recebido
             raise_application_error(-20008,chr(10) ||
              '*********************************' || chr(10) ||
              '*********************************' || chr(10) ||
              '[' || V_SAQUE || ']       OUTROS COMPROVANTES       ' || chr(10) ||
              '* Limite Mínimo de Documentos (4) ' || CHR(10) ||
              '* Encontrados: (' || V_QTDEIMG || ')' || CHR(10) ||
              '* Aprovados: (' || V_CONTADORNAPROV || ')' || CHR(10) || CHR(10) ||
              'Procurar a Ingred do Faturamento ' || CHR(10) ||
              '(11) 2967-8595                   ' || chr(10) ||
              '*********************************' || chr(10) ||
              '*********************************' );
           End If;
          End If;
      ELSE -- ElseEstadia

        select sum(vd.fcf_veiculodisp_qtdeentregas)
          into vQtdeEntregas
        from t_con_valefrete vf,
             t_fcf_veiculodisp vd
        where vf.fcf_veiculodisp_codigo = vd.fcf_veiculodisp_codigo
          and vf.fcf_veiculodisp_sequencia = vd.fcf_veiculodisp_sequencia     
          and Vf.Con_Conhecimento_Codigo       = V_CTRC
          AND Vf.Con_Conhecimento_Serie        = V_SERIE
          AND VF.Con_Valefrete_Saque           = V_SAQUE
          AND Vf.GLB_ROTA_CODIGO   = :NEW.GLB_ROTA_CODIGO_REFERENCIA;
        
        vQtdeEntregas := nvl(vQtdeEntregas,0);   
        if vQtdeEntregas = 0 Then
           vQtdeEntregas := 1;
        End If; 

         select count(*),
                sum(decode(nvl(vi.glb_vfimagem_arquivado,'N'),'R',1,0)),
                sum(decode(nvl(vi.usu_usuario_codigoconf,'sirlano'),'sirlano',1,0))
           into V_QTDEIMG,
                V_CONTADORREC,
                V_CONTADORNAPROV
         from tdvadm.t_glb_vfimagem vi
         WHERE Vi.Con_Conhecimento_Codigo       = V_CTRC
           AND Vi.Con_Conhecimento_Serie        = V_SERIE
           AND Vi.GLB_ROTA_CODIGO   = :NEW.GLB_ROTA_CODIGO_REFERENCIA
           AND Vi.Glb_Grupoimagem_Codigo = '10'
           AND Vi.CON_VALEFRETE_SAQUE        = V_SAQUE;

         V_QTDEIMG := nvl(V_QTDEIMG,0); 
         V_CONTADORREC := nvl(V_CONTADORREC,0);
         V_CONTADORNAPROV := nvl(V_CONTADORNAPROV,0);
         

         if ( V_QTDEIMG < vQtdeEntregas ) or
            ( V_CONTADORREC > 0 or V_CONTADORNAPROV > 0 )  
--           and ( trunc(sysdate) > to_date('12/01/2015','dd/mm/yyyy'))
          Then
             raise_application_error(-20008,chr(10) ||
                                          '**********************************************************' || chr(10) ||
                                          '[' || V_SAQUE || ']TOTAL DE ENTREGAS                :' || TO_CHAR(vQtdeEntregas,'999') || CHR(10) ||
                                          'TOTAL DE IMAGENS                 :' || TO_CHAR(V_QTDEIMG,'999') || CHR(10) ||
                                          'TOTAL DE IMAGENS RECUSADAS       :' || TO_CHAR(V_CONTADORREC,'999') || CHR(10) ||
                                          'TOTAL DE IMAGENS NÃO AUTORIZADAS :' || TO_CHAR(V_CONTADORNAPROV,'999') || CHR(10) ||
                                          'DUVIDAS LIGAR PARA O FATURAMENTO (11) 2967-8718    ....' || CHR(10) ||
                                          'USE O GERDOR DE PLANILHAS RELATORIO ' || CHR(10) ||
                                          'CAX - Relatório de imagens de Estadia Vale Frete ' || chr(10) ||
                                          'PROGRAMA - ' || V_PROGRAM || chr(10) ||
                                          '**********************************************************' || chr(10));
            
         End If;
      END IF; -- FIM DO TESTE SE E ESTADIA OU NAO

  END IF;

  IF :NEW.cax_operacao_codigo = '2167' THEN -- vales pagos

     Begin
     Select va.acc_vales_valor,
            va.acc_vales_datarecebimento,
            va.glb_rota_codigocax,
            va.cax_boletim_data,
            va.cax_movimento_sequencia
       Into vValor,
            vRecebimento,
            vRotaCaixa,
            vBoletimCaixa,
            vCxSequencia
     From T_ACC_VALES VA
     WHERE VA.ACC_VALES_NUMERO = V_DOC
       AND VA.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA;
--       and va.cax_movimento_sequencia <> :new.cax_movimento_sequencia
--       and va.cax_boletim_data <> :new.cax_boletim_data;
     Exception
       When NO_DATA_FOUND Then
          vValor := -1;
          vRecebimento := Null;
       When  Others Then
          vValor := -9;
          vRecebimento := Null;
       End;

     If ( :new.glb_rota_codigo = vRotaCaixa ) and
        ( :new.cax_boletim_data = vBoletimCaixa ) and 
        ( :new.cax_movimento_sequencia = vCxSequencia )  Then
        -- Igaulei a mesma variavel somente para não dar erro no IF
        vCxSequencia := vCxSequencia;
     ElsIf vValor = -1 Then
        raise_application_error(-20009, 'Vale/Rota ' || to_char(v_doc) || '-' || :new.glb_rota_codigo_referencia || ' Não Existe! Favor Verificar? ' || chr(13) );
     Elsif vValor = -9 Then
        raise_application_error(-20010, 'Vale/Rota ' || to_char(v_doc) || '-' || :new.glb_rota_codigo_referencia || ' Ocorreu erro! Inofrme TI ' || chr(10) || TRIM(SQLERRM) );
     Elsif vValor <> :NEW.CAX_MOVIMENTO_VALOR Then
        raise_application_error(-20011,  'Vale/Rota ' || to_char(v_doc) || '-' || :new.glb_rota_codigo_referencia || ' Valor diferente do expresso no Vale!' );
     Elsif vBoletimCaixa is not null    Then
        raise_application_error(-20012, 'Vale/Rota ' || to_char(v_doc) || '-' || :new.glb_rota_codigo_referencia || ' Vale ja Pago no Caixa! ROTA - ' || vRotaCaixa || '- Dia -' || to_char(vBoletimCaixa) || '-' || TRIM(camposalt));
  --   Elsif ( ( vRecebimento is not null )  and ( :new.glb_rota_codigo <> '022' ) ) Then
  --      raise_application_error(-20001, 'Vale/Rota ' || to_char(v_doc) || '-' || :new.glb_rota_codigo_referencia || ' Vale ja Recebido no Acerto no dia ' || to_char(vRecebimento,'dd/mm/yyyy') );
     Else

       If trunc(Sysdate) > to_date('25/03/2012','dd/mm/yyyy') Then

           vLocal := 'Update 15';
           UPDATE T_ACC_VALES VA
           SET VA.ACC_VALES_DATARECEBIMENTO = :NEW.CAX_BOLETIM_DATA,
               va.cax_boletim_data = :NEW.CAX_BOLETIM_DATA,
               va.cax_movimento_sequencia = :New.cax_movimento_sequencia,
               va.glb_rota_codigocax  = :new.glb_rota_codigo,
               va.acc_vales_impressao = 'S'
           WHERE VA.ACC_VALES_NUMERO = V_DOC
             AND VA.GLB_ROTA_CODIGO = :NEW.GLB_ROTA_CODIGO_REFERENCIA
             AND VA.ACC_VALES_VALOR <= :NEW.CAX_MOVIMENTO_VALOR;
      --       and VA.ACC_VALES_DATARECEBIMENTO is null;

             If SQL%ROWCOUNT = 0 Then
                raise_application_error(-20013,'Vale/Rota ' || to_char(v_doc) || '-' || :new.glb_rota_codigo_referencia || ' Não foi possivel dar o Recebimento favor Verificar');
             End If;

        Else

           If vRecebimento Is Not Null Then
             vLocal := 'Update 16';
               UPDATE T_ACC_VALES VA
               SET va.cax_boletim_data = :NEW.CAX_BOLETIM_DATA,
                   va.cax_movimento_sequencia = :New.cax_movimento_sequencia,
                   va.glb_rota_codigocax  = :new.glb_rota_codigo,
                   va.acc_vales_impressao = 'S'
               WHERE VA.ACC_VALES_NUMERO = V_DOC
                 AND TRIM(VA.GLB_ROTA_CODIGO) = :NEW.GLB_ROTA_CODIGO_REFERENCIA
                 AND VA.ACC_VALES_VALOR <= :NEW.CAX_MOVIMENTO_VALOR;
           Else

               vLocal := 'Update 17';
               UPDATE T_ACC_VALES VA
               SET VA.ACC_VALES_DATARECEBIMENTO = :NEW.CAX_BOLETIM_DATA,
                   va.cax_boletim_data = :NEW.CAX_BOLETIM_DATA,
                   va.cax_movimento_sequencia = :New.cax_movimento_sequencia,
                   va.glb_rota_codigocax  = :new.glb_rota_codigo,
                   va.acc_vales_impressao = 'S'
               WHERE VA.ACC_VALES_NUMERO = V_DOC
                 AND TRIM(VA.GLB_ROTA_CODIGO) = :NEW.GLB_ROTA_CODIGO_REFERENCIA
                 AND VA.ACC_VALES_VALOR <= :NEW.CAX_MOVIMENTO_VALOR;

           End If;
             If SQL%ROWCOUNT = 0 Then
                raise_application_error(-20014,'Vale/Rota ' || to_char(v_doc) || '-' || :new.glb_rota_codigo_referencia || ' Não foi possivel dar o Recebimento favor Verificar');
             End If;

        End If;
     End If;
  END IF;

  end if;
--end if;
  exception
    when others then
      if :NEW.cax_operacao_codigo = '2167' Then
         RAISE_APPLICATION_ERROR(-20015,vLocal || '-' || Sqlerrm);
      Else
  --       if ( ( V_PROGRAM <> 'plsqldev.exe' ) and ( trunc(sysdate) = '17/08/2012') ) then
         -- datas usadas para contabilizar os Fretes Eletronicos pagos no mes 06 e 07

         if ( v_Ip <> '192.9.200.101' ) AND ( v_Ip <> '192.9.200.158' ) then

         IF ( ( :NEW.CAX_BOLETIM_DATA <> '30/06/2012') or ( :NEW.CAX_BOLETIM_DATA <> '29/07/2012') ) and 
            ( tdvadm.pkg_ctb_caixa.vFinalizandoVFemAberto = 'N' )  THEN
--         raise_application_error(-20016,sqlerrm);
         raise_application_error(-20016, 'posicao - ' || vLocal || ' Programa - '  || V_PROGRAM ||  CHR(10) ||
                                  'VF: ' || v_ctrc || '-' || V_SERIE || '-' || V_SAQUE || '-' || :NEW.GLB_ROTA_CODIGO_REFERENCIA || CHR(10) ||
                                  'Vazio: ' || V_VAZIO ||
                                  ' Operacao      ' || :new.cax_operacao_codigo || chr(10) ||
                                  ' Valor         ' || :new.cax_movimento_valor || chr(10) ||
                                  ' Data Boletim  ' || :NEW.CAX_BOLETIM_DATA || ' Seq Caixa     ' || :NEW.CAX_MOVIMENTO_SEQUENCIA ||
                                  ' Rota Caixa    ' || :NEW.GLB_ROTA_CODIGO  || CHR(10) ||
                              /*
                                                              ||' UPDATE T_CON_VALEFRETE ' || CHR(10)
                                                              ||' SET CAX_BOLETIM_DATA = '||  :NEW.CAX_BOLETIM_DATA || CHR(10)
                                                              ||'     CAX_MOVIMENTO_SEQUENCIA =' || :NEW.CAX_MOVIMENTO_SEQUENCIA || CHR(10)
                                                              ||'     GLB_ROTA_CODIGOCX = ' ||  :NEW.GLB_ROTA_CODIGO || CHR(10)
                                                              ||'   WHERE CON_CONHECIMENTO_CODIGO = ' || V_CTRC || CHR(10)
                                                              ||'      AND CON_CONHECIMENTO_SERIE = ' || V_SERIE || CHR(10)
                                                              ||'     AND GLB_ROTA_CODIGO (RECEBE ROTA RECEITA    =  ' || :NEW.GLB_ROTA_CODIGO_REFERENCIA || CHR(10)
                                                              ||'     AND CON_VALEFRETE_SAQUE =  ' || V_SAQUE || CHR(10)
                                                              */
                                   'Local : ' || vLocal || chr(10) ||
                                   'Erro: ' || sqlerrm);
  --          end if;
         END IF;
         End if;
    end if;


        Begin
        select count(*)
          into vAuxiliarn
        from t_cax_operacao o
        where o.cax_operacao_codigo = :new.cax_operacao_codigo
          and o.glb_rota_codigo_operacao = :new.glb_rota_codigo_operacao
          and o.cax_operacao_ativa = 'S'
          and trunc(o.cax_operacao_validade) >= trunc(sysdate)
          and o.cax_operacao_valefrete = 'S';
        exception
          when OTHERS Then
             vAuxiliarn := 0;
          End;
        if vAuxiliarn > 0 Then
           -- operacoes de saida Adiantamento
           if instr(:new.glb_rota_codigo_operacao,pkg_ctb_caixa.vOperacaoAdiantamento) > 0 Then
               if pkg_con_valefrete.fn_DiarioBordoEmitido(trim(:new.cax_movimento_documento),
                                                          :new.cax_movimento_serie,
                                                          :new.glb_rota_codigo_referencia,
                                                          trim(:new.cax_movimento_doccomplemento )) = 'N' Then
                  raise_application_error(-20001,'DIARIO DE BORDO NAO EMITIDO! EMISSÃO OBRIGATORIA.');
               End If;
           End If;
           IF instr(:new.glb_rota_codigo_operacao,pkg_ctb_caixa.vOperacaoSaldo) > 0 Then
               -- Ver com o Klayton qul rotina usaremos para verificar se receemos o diario
               if pkg_con_valefrete.fn_DiarioBordoRecebido(trim(:new.cax_movimento_documento),
                                                          :new.cax_movimento_serie,
                                                          :new.glb_rota_codigo_referencia,
                                                          trim(:new.cax_movimento_doccomplemento )) = 'N' Then
                  raise_application_error(-20001,'DIARIO DE BORDO NAO TRANSMITIDO! TRANSMISSÃO OBRIGATORIA.');
               End If;

           End If;
        End If;



END;
/
