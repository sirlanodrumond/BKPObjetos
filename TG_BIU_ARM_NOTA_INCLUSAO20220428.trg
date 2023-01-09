CREATE OR REPLACE TRIGGER TG_BIU_ARM_NOTA_INCLUSAO
  BEFORE INSERT OR UPDATE ON TDVADM.T_ARM_NOTA
  FOR EACH ROW
  
  
DECLARE 
  V_CONTADOR INTEGER;
  V_OCORRENCIA TDVADM.T_ARM_COLETA.ARM_COLETAOCOR_CODIGO%TYPE;
  V_FECHACOLETA TDVADM.T_ARM_COLETAOCOR.ARM_COLETAOCOR_FINALIZA%TYPE;
  V_PESOBALANCA TDVADM.T_ARM_NOTA.ARM_NOTA_PESOBALANCA%TYPE;
  vFechaColeta  tdvadm.t_glb_cliente.glb_cliente_fechacoleta%type;
  vDataColeta   date;
BEGIN
--  who_called_me2;
 
 /* IF NVL(:NEW.ARM_COLETA_NCOMPRA,'0') = '0' THEN
  RAISE_APPLICATION_ERROR(-20001,''||CHR(13)||''||CHR(13)||'DIGITE O NUMERO DA COLETA PARA A NOTA: '||:NEW.ARM_NOTA_NUMERO||' CNPJ: '||:NEW.GLB_CLIENTE_CGCCPFREMETENTE);
  END IF;*/

  -- coloca como nao ate que seja definido quais contratos usaram
  -- 05/11/2020
  -- Sirlano  
  :new.arm_nota_qtdelimit := 'N';

  if nvl(:new.arm_nota_pesobalanca,0) = 0 Then
    :new.arm_nota_pesobalanca := :new.arm_nota_peso;
  End If;
  -- 28/04/2022 - Sirlano
  -- Começando a usar o Peso CUBADO
  if nvl(:new.arm_movimento_pesocubado,0) = 0 Then
    :new.arm_movimento_pesocubado := :new.arm_nota_peso;
  End If;




  IF :NEW.ARM_NOTA_FLAGPGTO in ('P','R') THEN
     :NEW.GLB_CLIENTE_CGCCPFSACADO := :NEW.GLB_CLIENTE_CGCCPFREMETENTE;
     :NEW.GLB_TPCLIEND_CODSACADO := :NEW.GLB_TPCLIEND_CODREMETENTE;
  ELSIF :NEW.ARM_NOTA_FLAGPGTO in ('A','D') THEN
     :NEW.GLB_CLIENTE_CGCCPFSACADO := :NEW.GLB_CLIENTE_CGCCPFDESTINATARIO;
     :NEW.GLB_TPCLIEND_CODSACADO := :NEW.GLB_TPCLIEND_CODDESTINATARIO;
     
/*    
  UPDATE T_GLB_CLIENTE CL
  SET CL.ARM_ARMAZEM_CODIGO = :NEW.ARM_ARMAZEM_CODIGO
  WHERE CL.GLB_CLIENTE_CGCCPFCODIGO = rpad(:NEW.GLB_CLIENTE_CGCCPFREMETENTE,20);
*/
  /*POR N?O TERMOS IDENTIFICADO O MOTIVO DE AS VEZES GRAVAR NO BANCO SEM A FLAGPAGTO FOI COLOCADO ESSA PARTE PORPS*/
/*  ELSIF (:NEW.ARM_NOTA_FLAGPGTO <> 'P') OR (:NEW.ARM_NOTA_FLAGPGTO <> 'A') OR (:NEW.ARM_NOTA_FLAGPGTO <> 'O')THEN
     RAISE_APPLICATION_ERROR(-20002,'NOTA '||:NEW.ARM_NOTA_NUMERO||' CNPJ '||:NEW.GLB_CLIENTE_CGCCPFREMETENTE||' NOVO: ' ||:NEW.ARM_NOTA_FLAGPGTO|| ' VELHO: ' ||:OLD.ARM_NOTA_FLAGPGTO||' N?O FOI POSSIVEL IDENTIFICAR QUEM PAGA O FRETE!' ||CHR(13)||
                              'REMETENTE, DESTINATARIO OU OUTROS. '||CHR(13)||
                              'TENTE DIGITAR OU ALTERAR A NOTA NOVAMENTE!');
*/  
    ELSE
        IF :NEW.ARM_NOTA_FLAGPGTO <> 'O' THEN
        select count(*)
          INTO V_CONTADOR
        from t_xml_nota xn
        where xn.xml_nota_nf = :NEW.arm_nota_numero
          and xn.glb_cliente_cgccpfremetente = rpad(:NEW.glb_cliente_cgccpfremetente,20);
        IF V_CONTADOR > 0 THEN
           :NEW.GLB_CLIENTE_CGCCPFSACADO := :NEW.GLB_CLIENTE_CGCCPFDESTINATARIO;
           :NEW.GLB_TPCLIEND_CODSACADO := :NEW.GLB_TPCLIEND_CODDESTINATARIO;
           :NEW.ARM_NOTA_FLAGPGTO := 'A';
     
        END IF;
        END IF;
  END IF;  

  :NEW.GLB_CLIENTE_CGCCPFREMETENTE    := Trim(:NEW.GLB_CLIENTE_CGCCPFREMETENTE);
  :NEW.GLB_CLIENTE_CGCCPFSACADO       := Trim(:NEW.GLB_CLIENTE_CGCCPFSACADO);
  :NEW.GLB_CLIENTE_CGCCPFDESTINATARIO := Trim(:NEW.GLB_CLIENTE_CGCCPFDESTINATARIO);
  

  begin
    select nvl(cl.glb_cliente_fechacoleta,'C')
      into vFechaColeta
    from t_glb_cliente cl   
    where cl.glb_cliente_cgccpfcodigo = rpad(:NEW.GLB_TPCLIEND_CODSACADO,20);
  exception
  when OTHERS Then 
     -- Caso ocorra algum erro fecha no CTe
     vFechaColeta := 'C';
  End;
  
  
  -- PEGA O PESO BALANÇA QUANDO NAO EXISTE
   BEGIN
     SELECT AP.ARM_NOTA_PESO
       INTO V_PESOBALANCA
     FROM T_ARM_NOTAPESAGEM AP
     WHERE AP.ARM_NOTA_NUMERO = :NEW.arm_nota_numero
       AND AP.GLB_CLIENTE_CGCCPFREMETENTE = rpad(:NEW.glb_cliente_cgccpfremetente,20);
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       V_PESOBALANCA := 0;
     WHEN TOO_MANY_ROWS THEN 
       V_PESOBALANCA := 0;
   END;    
  
   IF V_PESOBALANCA > 0 THEN
      :NEW.ARM_NOTA_PESOBALANCA := V_PESOBALANCA;
   ELSE   
      IF ((:NEW.ARM_NOTA_PESO > 5000) and (INSERTING) AND (NVL(:NEW.ARM_NOTA_PESOBALANCA,0) = 0)) THEN
        :NEW.ARM_NOTA_PESOBALANCA := :NEW.ARM_NOTA_PESO;
      END IF; 
   END IF;   
   
  IF (TRIM(TO_CHAR(:NEW.ARM_NOTA_ONU)) = :NEW.GLB_MERCADORIA_CODIGO)
    OR  (TRIM(TO_CHAR(:NEW.ARM_NOTA_ONU)) = :NEW.GLB_EMBALAGEM_CODIGO) THEN
  
       :NEW.ARM_NOTA_ONU := NULL;
  END IF;     
  
  IF :NEW.ARM_NOTA_ONU = 0 THEN 
  :NEW.ARM_NOTA_ONU := NULL; 
  END IF;
  
  /*Verifica se a coleta que esta sendo vinculada foi baixada*/
  IF :NEW.ARM_COLETA_NCOMPRA IS NOT NULL THEN
  BEGIN
  SELECT COL.ARM_COLETAOCOR_CODIGO,
         OC.ARM_COLETAOCOR_FINALIZA
    INTO V_OCORRENCIA,
         V_FECHACOLETA
    FROM T_ARM_COLETA COL,
         T_ARM_COLETAOCOR OC
   WHERE COL.ARM_COLETA_NCOMPRA = :NEW.ARM_COLETA_NCOMPRA
     and col.arm_coleta_ciclo = :new.arm_coleta_ciclo
     AND COL.ARM_COLETAOCOR_CODIGO = OC.ARM_COLETAOCOR_CODIGO (+);
     
   V_CONTADOR := 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    V_OCORRENCIA := NULL;
    V_CONTADOR := 0;
  END; 
  
  /*Caso não tenha sido baixada ele baixa*/
    IF ((V_CONTADOR > 0) AND 
        (vFechaColeta = 'N') AND
       ((V_OCORRENCIA IS NULL) OR (V_FECHACOLETA = 'N') )) THEN  -- se a ocorrencia fecha a coleta

       if vFechaColeta = 'N' then -- se a Coleta e fechada por entrada de NOTA
         
         vDataColeta := sysdate;
          UPDATE T_ARM_COLETA COL
             SET COL.ARM_COLETAOCOR_CODIGO = '54', -- DECODE(COL.ARM_COLETA_TPCOMPRA, 'FCA', '09', '01')
                 col.arm_coleta_dtfechamento = nvl(col.arm_coleta_dtfechamento,vDataColeta) 
          WHERE COL.ARM_COLETA_NCOMPRA = :NEW.ARM_COLETA_NCOMPRA
            and col.arm_coleta_ciclo = :new.arm_coleta_ciclo;
          If sql%Rowcount > 0 Then
             update tdvadm.t_col_asn asn
                set asn.col_asn_dtrealcoleta = nvl(asn.col_asn_dtrealcoleta,vDataColeta)
             WHERE asn.ARM_COLETA_NCOMPRA = :NEW.ARM_COLETA_NCOMPRA
               and asn.arm_coleta_ciclo = :new.arm_coleta_ciclo;
                
          End If;
       End If;     
       
    END IF;
  END IF;


-- Atualiza o controle de Janela
  -- Se foi colocado um numero de CTe
  if :new.con_conhecimento_codigo is not null and :old.con_conhecimento_codigo is null Then
     update t_arm_janelacons jc
       set jc.arm_janelacons_qtdectenfs = nvl(jc.arm_janelacons_qtdectenfs,0) + 1
     Where jc.arm_janelacons_sequencia = :new.arm_janelacons_sequencia;
  -- retirando um codigo de CTe
  ElsIf :new.con_conhecimento_codigo is null and :old.con_conhecimento_codigo is not null Then
     update t_arm_janelacons jc
       set jc.arm_janelacons_qtdectenfs = nvl(jc.arm_janelacons_qtdectenfs,0) - 1
     Where jc.arm_janelacons_sequencia = :new.arm_janelacons_sequencia;
  End If;
   
--ELSE 
-- RAISE_APPLICATION_ERROR(-20001,:NEW.ARM_NOTA_PESOBALANCA || 'PESO BALANCA IGUAL AO NUMERO DE CFOP');
--END IF;
  
END;
/
