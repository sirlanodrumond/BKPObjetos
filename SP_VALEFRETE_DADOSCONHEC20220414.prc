CREATE OR REPLACE PROCEDURE SP_VALEFRETE_DADOSCONHEC
(P_CONHECCOD       IN CHAR,
 P_CONHECSERIE     IN CHAR,
 P_CONHECROTA      IN CHAR,
 P_VIAGEM          IN OUT  T_CON_CONHECIMENTO.CON_VIAGEM_NUMERO%TYPE,
 P_VIAGEMROTA      IN OUT  T_CON_CONHECIMENTO.GLB_ROTA_CODIGOVIAGEM%TYPE,
 P_KM              IN OUT  T_CON_CONHECIMENTO.CON_CONHECIMENTO_KILOMETRAGEM%TYPE,
 P_QTDEENTREGA     IN OUT  T_CON_CONHECIMENTO.CON_CONHECIMENTO_QTDEENTREGA%TYPE,
 P_CLIENTEREM      IN OUT  T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE,
 P_LOCALORIGEM     IN OUT  T_GLB_LOCALIDADE.GLB_LOCALIDADE_DESCRICAO%TYPE,
 P_ESTORIGEM       IN OUT  T_GLB_LOCALIDADE.GLB_ESTADO_CODIGO%TYPE,
 P_CLIENTEDEST     IN OUT  T_GLB_CLIENTE.GLB_CLIENTE_RAZAOSOCIAL%TYPE,
 P_LOCALDEST       IN OUT  T_GLB_LOCALIDADE.GLB_LOCALIDADE_DESCRICAO%TYPE,
 P_ESTDEST         IN OUT  T_GLB_LOCALIDADE.GLB_ESTADO_CODIGO%TYPE,
 P_CUSTCARRET      IN OUT  T_PRG_PROGCARGADET.PRG_PROGCARGADET_CUSTCARRET%TYPE,
 P_TPVALOR         IN OUT  T_PRG_PROGCARGADET.PRG_PROGCARGADET_TPVALOR%TYPE,
 P_PESO            IN OUT  T_PRG_PROGCARGADET.PRG_PROGCARGADET_PESO%TYPE,
 P_ADIANTAM        IN OUT  T_PRG_PROGCARGADET.PRG_PROGCARGADET_ADIANTAMENTO%TYPE,
 P_RETORNO         IN OUT  CHAR,
 P_MOTORISTA       IN OUT  T_FRT_MOTORISTA.FRT_MOTORISTA_NOME%TYPE,
 P_FROTA           IN OUT  T_CON_VIAGEM.FRT_CONJVEICULO_CODIGO%TYPE,
 P_MOTCGCCPF       IN OUT  T_FRT_MOTORISTA.FRT_MOTORISTA_CODIGO%TYPE,
 P_CARRET          IN OUT  T_CAR_CARRETEIRO.CAR_CARRETEIRO_NOME%TYPE,
 P_PLACA           IN OUT  T_CAR_CARRETEIRO.CAR_VEICULO_PLACA%TYPE,
 P_CARRETCGCCPF    IN OUT  T_CAR_CARRETEIRO.CAR_CARRETEIRO_CPFCODIGO%TYPE,
 P_CARRETSAQUE     IN OUT  T_CAR_CARRETEIRO.CAR_CARRETEIRO_SAQUE%TYPE,
 P_VEICSAQUE       IN OUT  T_CAR_CARRETEIRO.CAR_VEICULO_SAQUE%TYPE,
 P_LOCALORIGEMCOD  IN OUT  T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE,
 P_LOCALDESTCOD    IN OUT  T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE) 
AS
  V_CLIENTEREM  T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  V_LOCALORIGEM T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_CLIENTEDEST T_GLB_CLIENTE.GLB_CLIENTE_CGCCPFCODIGO%TYPE;
  V_LOCALDEST   T_GLB_LOCALIDADE.GLB_LOCALIDADE_CODIGO%TYPE;
  V_VIAGEM      T_CON_VIAGEM.CON_VIAGEM_NUMERO%TYPE; 
  V_VIAGEMROTA  T_CON_CONHECIMENTO.GLB_ROTA_CODIGOVIAGEM%TYPE;
  v_DTVALEFRETE TDVADM.T_CON_VALEFRETE.CON_VALEFRETE_DATAEMISSAO%TYPE;
  
--  V_SAQUE1 NUMBER;
--  V_MSERIE CHAR(2);
BEGIN
P_RETORNO := '1';
  -- 08/03/2022 Sirlano
  -- Pegando a Data do Vale de Frete para auxiliar nas pesquisas
  SELECT MAX(VF.CON_VALEFRETE_DATAEMISSAO)
     INTO v_DTVALEFRETE
  FROM TDVADM.T_CON_VALEFRETE VF
  WHERE VF.CON_CONHECIMENTO_CODIGO = P_CONHECCOD
    AND VF.CON_CONHECIMENTO_SERIE  = P_CONHECSERIE
    AND VF.GLB_ROTA_CODIGO         = P_CONHECROTA;
  If nvl(v_DTVALEFRETE,to_date('01/01/1900','dd/mm/yyyy')) < trunc(sysdate) Then
     v_DTVALEFRETE := trunc(sysdate);
  End If;
  begin
       
      SELECT CON_CONHECIMENTO_QTDEENTREGA,
             GLB_CLIENTE_CGCCPFREMETENTE,
             GLB_CLIENTE_CGCCPFDESTINATARIO,
             CON_VIAGEM_NUMERO,
             GLB_ROTA_CODIGOVIAGEM,
             GLB_LOCALIDADE_CODIGOORIGEM,
             GLB_LOCALIDADE_CODIGODESTINO,
             NVL(CON_CONHECIMENTO_KILOMETRAGEM,0)
        INTO P_QTDEENTREGA,
             V_CLIENTEREM,
             V_CLIENTEDEST,
             V_VIAGEM, --P_VIAGEM,
             V_VIAGEMROTA, --P_VIAGEMROTA,
             V_LOCALORIGEM,
             V_LOCALDEST,
             P_KM
        FROM T_CON_CONHECIMENTO
       WHERE CON_CONHECIMENTO_CODIGO = P_CONHECCOD
--         AND CON_CONHECIMENTO_SERIE = P_CONHECSERIE
         AND instr(decode(P_CONHECROTA,'157',';A2;'||P_CONHECSERIE,P_CONHECSERIE),CON_CONHECIMENTO_SERIE ) > 0
         AND GLB_ROTA_CODIGO         = P_CONHECROTA
         -- 08/03/2022 Sirlano
         and CON_CONHECIMENTO_DTEMBARQUE >= (v_DTVALEFRETE - 90);
    EXCEPTION WHEN NO_DATA_FOUND THEN
      Begin

      SELECT c.CON_CONHECIMENTO_QTDEENTREGA,
             c.GLB_CLIENTE_CGCCPFREMETENTE,
             c.GLB_CLIENTE_CGCCPFDESTINATARIO,
             c.CON_VIAGEM_NUMERO,
             c.GLB_ROTA_CODIGOVIAGEM,
             c.GLB_LOCALIDADE_CODIGOORIGEM,
             GLB_LOCALIDADE_CODIGODESTINO,
             NVL(c.CON_CONHECIMENTO_KILOMETRAGEM,0)
        INTO P_QTDEENTREGA,
             V_CLIENTEREM,
             V_CLIENTEDEST,
             V_VIAGEM, --P_VIAGEM,
             V_VIAGEMROTA, --P_VIAGEMROTA,
             V_LOCALORIGEM,
             V_LOCALDEST,
             P_KM
        FROM T_CON_CONHECIMENTO c
       WHERE (c.CON_CONHECIMENTO_CODIGO,
              c.con_conhecimento_serie,
              c.glb_rota_codigo) = (select vfc.con_conhecimento_codigo,
                                            vfc.con_conhecimento_serie,
                                            vfc.glb_rota_codigo
                                     from tdvadm.t_con_vfreteconhec vfc
                                     where vfc.con_valefrete_codigo = P_CONHECCOD
                                       and vfc.con_valefrete_serie = P_CONHECSERIE
                                       and vfc.glb_rota_codigovalefrete = P_CONHECROTA
                                       and rownum = 1);
      Exception
        When NO_DATA_FOUND Then
           P_RETORNO := '0';
        End;
    end;
    
    P_VIAGEM          := V_VIAGEM;
    P_VIAGEMROTA      := V_VIAGEMROTA;
    
    P_LOCALORIGEMCOD  := V_LOCALORIGEM ;
    P_LOCALDESTCOD    := V_LOCALDEST ;
    IF P_RETORNO <> 0 THEN
    begin
      SELECT A.GLB_CLIENTE_RAZAOSOCIAL,
             B.GLB_CLIENTE_RAZAOSOCIAL
        INTO P_CLIENTEREM,
             P_CLIENTEDEST
        FROM T_GLB_CLIENTE A,
             T_GLB_CLIENTE B
       WHERE A.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTEREM
         AND B.GLB_CLIENTE_CGCCPFCODIGO = V_CLIENTEDEST;
       EXCEPTION WHEN NO_DATA_FOUND THEN
             P_CLIENTEREM := '';
             P_CLIENTEDEST := '';
      end;
    begin
      SELECT A.GLB_LOCALIDADE_DESCRICAO,
             A.GLB_ESTADO_CODIGO,
             B.GLB_LOCALIDADE_DESCRICAO,
             B.GLB_ESTADO_CODIGO
        INTO P_LOCALORIGEM,
             P_ESTORIGEM,
             P_LOCALDEST,
             P_ESTDEST
        FROM T_GLB_LOCALIDADE A,
             T_GLB_LOCALIDADE B
       WHERE A.GLB_LOCALIDADE_CODIGO = V_LOCALORIGEM
         AND B.GLB_LOCALIDADE_CODIGO = V_LOCALDEST;
      EXCEPTION WHEN NO_DATA_FOUND THEN
             P_LOCALORIGEM := '';
             P_ESTORIGEM := '';
             P_LOCALDEST := '';
             P_ESTDEST := '';
      end;
    P_ADIANTAM := '';
    begin
      SELECT CON_CALCVIAGEM_VALOR,
             CON_CALCVIAGEM_DESINENCIA
        INTO P_CUSTCARRET,
             P_TPVALOR
      FROM T_CON_CALCCONHECIMENTO
      WHERE CON_CONHECIMENTO_CODIGO = P_CONHECCOD
--         AND CON_CONHECIMENTO_SERIE = P_CONHECSERIE
                  AND instr(decode(P_CONHECROTA,'157',';A2;'||P_CONHECSERIE,P_CONHECSERIE),CON_CONHECIMENTO_SERIE ) > 0
        AND GLB_ROTA_CODIGO         = P_CONHECROTA
        AND SLF_RECCUST_CODIGO      = 'I_CTCR';
     EXCEPTION WHEN NO_DATA_FOUND THEN
           P_CUSTCARRET := '';
           P_TPVALOR := '';
      end;
    begin
      SELECT CON_CALCVIAGEM_VALOR
        INTO P_PESO
      FROM T_CON_CALCCONHECIMENTO
      WHERE CON_CONHECIMENTO_CODIGO = P_CONHECCOD
--         AND CON_CONHECIMENTO_SERIE = P_CONHECSERIE
                 AND instr(decode(P_CONHECROTA,'157',';A2;'||P_CONHECSERIE,P_CONHECSERIE),CON_CONHECIMENTO_SERIE ) > 0
        AND GLB_ROTA_CODIGO         = P_CONHECROTA
        AND SLF_RECCUST_CODIGO      = 'I_PSCOBRAD';
     EXCEPTION WHEN NO_DATA_FOUND THEN
           P_PESO := '';
      end;
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
            FROM T_CON_VIAGEM A,
                 T_FRT_MOTORISTA B,
                 T_CAR_CARRETEIRO C
           WHERE A.CON_VIAGEM_NUMERO = V_VIAGEM
             AND A.GLB_ROTA_CODIGOVIAGEM = V_VIAGEMROTA
             AND A.CAR_CARRETEIRO_CPFCODIGO = C.CAR_CARRETEIRO_CPFCODIGO(+)
             AND A.CAR_CARRETEIRO_SAQUE = C.CAR_CARRETEIRO_SAQUE(+)
             AND A.FRT_MOTORISTA_CODIGO = B.FRT_MOTORISTA_CODIGO(+);

           If P_MOTCGCCPF Is Null And P_CARRETCGCCPF Is Null Then   
                SELECT CA.CAR_CARRETEIRO_CPFCODIGO,
                       CA.CAR_CARRETEIRO_SAQUE,
                       DECODE(SUBSTR(CT.CON_CONHECIMENTO_PLACA,1,3),'000',CT.CON_CONHECIMENTO_PLACA,Null) FRT_CONJVEICULO_CODIGO,
                       CA.CAR_VEICULO_PLACA,
                       CA.CAR_CARRETEIRO_NOME,
                       CA.CAR_VEICULO_SAQUE,
                       '' FRT_MOTORISTA_CPF,
                       'CTRC SEM REG. TABELA VIAGEM' FRT_MOTORISTA_NOME
                  INTO P_CARRETCGCCPF,
                       P_CARRETSAQUE,
                       P_FROTA,
                       P_PLACA,
                       P_CARRET,
                       P_VEICSAQUE,
                       P_MOTCGCCPF,
                       P_MOTORISTA
                  FROM T_CON_CONHECIMENTO CT,
                       T_CAR_CARRETEIRO CA
                 WHERE CT.CON_CONHECIMENTO_CODIGO = '027396'
                   And CT.CON_CONHECIMENTO_SERIE  = 'A1'
                   And CT.GLB_ROTA_CODIGO         = '033'
                   And TRIM(CT.CON_CONHECIMENTO_PLACA) = CA.CAR_VEICULO_PLACA (+)
                   And CA.CAR_VEICULO_SAQUE = (Select Max(CA1.CAR_VEICULO_SAQUE)
                                               From T_CAR_CARRETEIRO CA1 
                                               Where CA1.CAR_VEICULO_PLACA = CA.CAR_VEICULO_PLACA)
                   And CA.CAR_CARRETEIRO_DTCADASTRO = (Select Max(CA1.CAR_CARRETEIRO_DTCADASTRO)
                                                       From T_CAR_CARRETEIRO CA1 
                                                       Where CA1.CAR_VEICULO_PLACA = CA.CAR_VEICULO_PLACA);
               End If;  
            Exception
              When NO_DATA_FOUND Then
                P_CARRETCGCCPF := '';
                P_CARRETSAQUE  := '';
                P_FROTA        := '';
                P_PLACA        := '';
                P_CARRET       := '';
                P_VEICSAQUE    := '';
                P_MOTCGCCPF    := '';
                P_MOTORISTA    := 'NAO ENCONTRADO';
              When TOO_MANY_ROWS Then
                P_CARRETCGCCPF := '';
                P_CARRETSAQUE  := '';
                P_FROTA        := '';
                P_PLACA        := '';
                P_CARRET       := '';
                P_VEICSAQUE    := '';
                P_MOTCGCCPF    := '';
                P_MOTORISTA    := 'ENCONTROU MAIS DE UM MOTORISTA PARA PLACA';
            End;    
            

    END IF;

    IF P_PLACA IS NULL THEN
       P_PLACA := P_FROTA;
    END IF;   

    
END;



 
/
