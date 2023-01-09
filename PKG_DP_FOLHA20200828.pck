CREATE OR REPLACE PACKAGE PKG_DP_FOLHA IS
/***************************************************************************************************
 * ROTINA           :
 * PROGRAMA         :
 * ANALISTA         :
 * DESENVOLVEDOR    :
 * DATA DE CRIACAO  :
 * BANCO            :
 * EXECUTADO POR    :
 * ALIMENTA         :
 * FUNCINALIDADE    :
 * ATUALIZA         :
 * PARTICULARIDADES :                                           
 * PARAM. OBRIGAT.  :
 *                                                                                                  *
 ****************************************************************************************************/
  TYPE T_CURSOR IS REF CURSOR;
  STATUS_NORMAL         CONSTANT CHAR(1)      := 'N';
  STATUS_ERRO           CONSTANT CHAR(1)      := 'E';
  
 
 /* Typo utilizado como base para utilização dos Paramentros                                                                 */
 Type TpMODELO  is RECORD (CAMPO1         char(10),
                           CAMPO2         number(6));
                           
     PROCEDURE SP_GERAARQFOLHA(P_REFERENCIA IN CHAR,
                                                P_DIA IN CHAR,
                                                P_FOLHA IN CHAR, -- 1 - Mensal
                                                                 -- 2 - Adiantamento
                                                                 -- 3 - Adiantamento 13
                                                                 -- 4 - Parcela Final 13
                                                                 -- 5 - Vale Transporte
                                                                 -- 6 - Pensao Normal
                                                                 -- 7 - Pensao 13
                                                                 -- 8 - Acordo MP
                                                P_TIPO IN CHAR, -- (P)revia (F)echamento
                                                P_ERRO OUT varchar2,
                                                P_MENSAGEM out varchar2,
                                                C_FOLHABB OUT TYPES.cursorType,
                                                C_FOLHABBT OUT TYPES.cursorType,
                                                C_FAVBB OUT TYPES.cursorType,
                                                C_FAVBBT OUT TYPES.cursorType,
                                                C_FOLHAHS OUT TYPES.cursorType,
                                                C_FOLHAHST OUT TYPES.cursorType);

    procedure sp_getfolhas(P_TIPO   IN CHAR,
                           c_folhas out TYPES.cursorType);
                                                
     PROCEDURE SP_GERAARQFOLHABB(P_REFERENCIA IN CHAR,
                                                  P_DIA IN CHAR,
                                                  P_FOLHA IN CHAR, -- 1 - Mensal
                                                                   -- 2 - Adiantamento
                                                                   -- 3 - Adiantamento 13
                                                                   -- 4 - Parcela Final 13
                                                                   -- 5 - Vale Transporte
                                                                   -- 8 - Acordo MP
                                                  P_TIPO IN CHAR, -- (P)revia (F)echamento (FAV) Favorecidos
                                                  P_ERRO OUT VARCHAR2,
                                                  P_MENSAGEM OUT VARCHAR2,
                                                  C_FOLHA OUT TYPES.cursorType);
                                                  
                
     PROCEDURE SP_GERAARQFOLHAHSBC(P_REFERENCIA IN CHAR,
                                                    P_DIACREDITO IN CHAR,
                                                    P_FOLHA IN CHAR, -- 1 - Mensal
                                                                     -- 2 - Adiantamento
                                                                     -- 3 - Adiantamento 13
                                                                     -- 4 - Parcela Final 13
                                                                     -- 5 - vale Transporte
                                                                     -- 6 - Pensoes
                                                                     -- 8 - Acordo MP
                                                    P_TIPO IN CHAR,  -- (P)revia (F)echamento         
                                                    P_ERRO OUT VARCHAR2,
                                                    P_MENSAGEM OUT VARCHAR2,        
                                                    C_FOLHA OUT TYPES.cursorType);                                  
     
       
     PROCEDURE SP_TRANSFERE_ACERTO_FPW (P_MES IN CHAR,
                                        P_ANO IN CHAR,
                                        P_VAL IN CHAR,
                                        P_ERRO OUT VARCHAR2,
                                        P_MENSAGEM OUT VARCHAR2);

    PROCEDURE SP_TRANSFERE_ACERTO_FPW (P_MES IN CHAR,
                                       P_ANO IN CHAR,
                                       P_VAL IN CHAR,
                                       P_ACAO IN CHAR DEFAULT 'G', -- (G)ERAR OU (R)EGERAR
                                       P_CURSOR OUT T_CURSOR,
                                       P_ERRO OUT VARCHAR2,
                                       P_MENSAGEM OUT VARCHAR2);
                                        
                                        
     
     
     PROCEDURE SP_RELATORIO_DP(P_USUARIO    in Char,
                               P_RELATORIO  in Char,
                               P_REFERENCIA in Char,
                               P_VALORDP    in Number,
                               P_ERRO OUT varchar2,
                               P_MENSAGEM OUT varchar2);     
                                            
                                            
     PROCEDURE SP_CPG_GERATITULOS_PARCELAS(P_TIPO       IN CHAR,
                                                        P_TP_PROCESS IN CHAR,
                                                        P_MATRICULAS IN CHAR,
                                                        P_VENCIMENTO IN CHAR,
                                                        P_MESREF     IN CHAR,
                                                        P_CURSOR     OUT TYPES.CURSORTYPE); 
      
     
     
     FUNCTION FN_GETMATRICULAS(P_MATRICULA IN VARCHAR2)RETURN VARCHAR2  ;                                                  

                                                                                                                        

  END PKG_DP_FOLHA;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_DP_FOLHA AS

vacodevent constant integer := 10990;

FUNCTION FN_GETMATRICULAS(P_MATRICULA IN VARCHAR2)RETURN VARCHAR2 IS
X                  INTEGER;
vs_matricula  VARCHAR2(1000);
v_caracter         CHAR(1);
v_varsql     VARCHAR2(400);

BEGIN
  x       := 1;

 WHILE LENGTH(trim(P_MATRICULA)) > X loop

   v_caracter := SUBSTR(trim(P_MATRICULA), x, 1);
    
    IF v_caracter = ';' THEN
      IF length(vs_matricula) <> 0 THEN
         v_varsql := v_varsql||' '||vs_matricula||' ,';
       END IF;

       vs_matricula:= '';
       ELSE
      vs_matricula := vs_matricula || v_caracter;
    END IF;
    x := x + 1;
  end loop;

RETURN '('||substr(v_varsql,1,(length(v_varsql)-1))||')';

END FN_GETMATRICULAS;

procedure sp_getfolhas(P_TIPO   IN CHAR,
                       c_folhas out TYPES.cursorType)
  as
  Begin
    
    
    IF P_TIPO = 'N' THEN 
       open C_FOLHAS  FOR
            SELECT '1'  tipo, 'Mensal'              Folha from dual union
            SELECT '2'  tipo, 'Adiantamento'        Folha from dual union
            SELECT '3'  tipo, 'Adiantamento 13'     Folha from dual union
            SELECT '4'  tipo, 'Parcela Final 13'    Folha from dual union
            SELECT '5'  tipo, 'Vale Transporte'     Folha from dual union
            SELECT '6'  tipo, 'Pensao Normal'       Folha from dual union
            SELECT '7'  tipo, 'Pensao 13'           Folha from dual union
            SELECT '8'  tipo, 'MP Acordo'           Folha from dual union
            SELECT '9'  tipo, 'MP Diferença'        Folha from dual
            order by 1;
          
    ELSIF P_TIPO = 'L' THEN      
      open C_FOLHAS FOR      
            SELECT 'Q'  tipo, 'Quinzenal'           Folha from dual union
            SELECT 'F'  tipo, 'Folha'               Folha from dual union     
            SELECT 'P'  tipo, 'Pensão'              Folha from dual union
            SELECT 'L'  tipo, 'P.L.R'               Folha from dual union
            SELECT 'E'  tipo, 'Estagiarios'         Folha from dual union
            SELECT 'A'  tipo, 'Adiantamento 13º'    Folha from dual union
            SELECT 'D'  tipo, 'Parcela final 13º'   Folha from dual
            order by 2;
    END IF;       

  End;

  PROCEDURE SP_GERAARQFOLHA(P_REFERENCIA      IN CHAR,
                            P_DIA             IN CHAR,
                            P_FOLHA           IN CHAR, -- 1 - Mensal
                                             -- 2 - Adiantamento
                                             -- 3 - Adiantamento 13
                                             -- 4 - Parcela Final 13
                                             -- 5 - Vale Transporte
                                             -- 6 - Pensao Normal
                                             -- 7 - Pensao 13
                                             -- 8 - Acordo MP
                            P_TIPO           IN CHAR,  -- (P)revia (F)echamento
                            P_ERRO           OUT varchar2,
                            P_MENSAGEM       out varchar2,
                            C_FOLHABB        OUT TYPES.cursorType,
                            C_FOLHABBT       OUT TYPES.cursorType,
                            C_FAVBB          OUT TYPES.cursorType,
                            C_FAVBBT         OUT TYPES.cursorType,
                            C_FOLHAHS        OUT TYPES.cursorType,
                            C_FOLHAHST       OUT TYPES.cursorType


    )
    AS
    /*
    C_FOLHABB  TYPES.cursorType;
    C_FOLHABBT TYPES.cursorType;
    C_FOLHAHS  TYPES.cursorType;
    C_FOLHAHST TYPES.cursorType;
    */

    vString varchar2(200);
    BEGIN
      
      
--    raise_application_error(-20001,vString);
    
    vString:= 'P_REFERENCIA ' || P_REFERENCIA || ' '||   
              'P_DIA '        || P_DIA        || ' '||      
              'P_FOLHA '      || P_FOLHA      || ' '||     
              'P_TIPO '       || P_TIPO       || ' '||
              'P_ERRO '       || P_ERRO       || ' '||
              'P_MENSAGEM '   || P_MENSAGEM;
     
     INSERT INTO T_GLB_SQL
       (GLB_SQL_INSTRUCAO,
        GLB_SQL_DTGRAVACAO,
        GLB_SQL_PROGRAMA,
        GLB_SQL_OBSERVACAO)
     VALUES
       (vString, sysdate, 'Folha DP', '');
     
    commit;  
      
      
      sp_geraarqfolhahsbc(P_REFERENCIA,
                          P_DIA,
                          P_FOLHA,
                          P_TIPO,
                          P_ERRO,
                          P_MENSAGEM,
                          C_FOLHAHS);
                          

       open C_FOLHAHST FOR
          SELECT rpad(AA.UTI_ARQTMP_LINHA,240)
            FROM T_UTI_ARQTMP AA
           WHERE UTI_GERAARQTMP_PROC       = 'SP_GERAARQFOLHAHSBC'
             AND GLB_ROTA_CODIGO           = '010'
             AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172'
        ORDER BY UTI_ARQTMP_SEQ;

        IF P_FOLHA In ('1','2','3','4','5','8','9') THEN     
          sp_geraarqfolhabb(P_REFERENCIA,
                              P_DIA,
                              P_FOLHA,
                              P_TIPO,
                              P_ERRO,
                              P_MENSAGEM,
                              C_FOLHABB);
         

             open C_FOLHABBT FOR
              SELECT RPAD(AT.UTI_ARQTMP_LINHA,176)
                FROM T_UTI_ARQTMP AT
               WHERE UTI_GERAARQTMP_PROC = 'SP_GERAARQFOLHABB'
                 AND GLB_ROTA_CODIGO           = '010'
                 AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172'
               ORDER BY UTI_ARQTMP_SEQ;

          sp_geraarqfolhabb(P_REFERENCIA,
                              P_DIA,
                              P_FOLHA,
                              'FAV',
                              P_ERRO,
                              P_MENSAGEM,
                              C_FAVBB);                 
             
          
           open C_FAVBBT FOR
              SELECT RPAD(AT.UTI_ARQTMP_LINHA,125)
                FROM T_UTI_ARQTMP AT
               WHERE UTI_GERAARQTMP_PROC = 'SP_GERAARQFOLHABB'
                 AND GLB_ROTA_CODIGO           = '011'
                 AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172'
               ORDER BY UTI_ARQTMP_SEQ;
      end if;
       EXCEPTION 
        WHEN OTHERS THEN
          P_ERRO :='S';
          P_MENSAGEM :='Erro contato a tI :'|| SQLERRM;
        IF P_ERRO ='N' THEN
          P_MENSAGEM := 'Arquivo gerado com sucesso';          
        END IF ;
    --  END;
          
END SP_GERAARQFOLHA;

    
    PROCEDURE SP_GERAARQFOLHABB(P_REFERENCIA IN CHAR,
                                                  P_DIA IN CHAR,
                                                  P_FOLHA IN CHAR, -- 1 - Mensal
                                                                   -- 2 - Adiantamento
                                                                   -- 3 - Adiantamento 13
                                                                   -- 4 - Parcela Final 13
                                                                   -- 5 - Vale Transporte
                                                                   -- 6 - Pensao Normal
                                                                   -- 7 - Pensao 13
                                                                   -- 8 - Acordo MP
                                                                   -- 9 - Diferença MP
                                                  P_TIPO IN CHAR, -- (P)revia (F)echamento (FAV) Favorecidos
                                                  P_ERRO OUT VARCHAR2,
                                                  P_MENSAGEM OUT VARCHAR2,
                                                  C_FOLHA OUT TYPES.cursorType)





    AS                                                             
    --  achou              CHAR(1);                                   
    nSEQUENCIA         NUMBER;                                     
    nNUMEROARQUIVO     NUMBER;
    nVALORTOTAL        number;
    sIDREGISTRO        char(300); 
    sIDINTERCAMBIO     CHAR(10);
    sAgencia           char(5);
    sConta             char(12);
    sSelect            varchar2(2000);
    cMatricula         fpw.funciona.fumatfunc%TYPE;
    cNome              fpw.funciona.FUNOMFUNC%type;
    cCPF               fpw.funciona.FUCPF%type;
    cBanco             fpw.funciona.FUCODBCOPG%type;
    cAgencia           FPW.BANCOSAG.BADESAGENC%type;
    cConta             fpw.funciona.FUCCORPAG%type;
    cValor             fpw.valmes.VAVALEVENT%type;
    cBancoDesc         FPW.BANCOS.BCDESBANCO%type;




    BEGIN
      begin
         
      P_ERRO:='N';

       sSelect :=           'SELECT F.FUNOMFUNC NOME, ';
       sSelect := sSelect || '       F.FUMATFUNC MATRICULA,';
       sSelect := sSelect || '       F.FUCPF CPF, ';
       sSelect := sSelect || '       F.FUCODBCOPG BANCO, ';
       sSelect := sSelect || '       BA.BADESAGENC AGENCIA, ';
       sSelect := sSelect || '       REPLACE(fn_limpa_numero(F.FUCCORPAG),'' '','''') CONTA, ';
       sSelect := sSelect || '       SUM(VM.VAVALEVENT) VALOR, ';
       sSelect := sSelect || '       B.BCDESBANCO BANCODESC ';
       sSelect := sSelect || 'FROM FPW.VALMES VM, ';
       sSelect := sSelect || '     FPW.FUNCIONA F, ';
       sSelect := sSelect || '     FPW.BANCOS B, ';
       sSelect := sSelect || '     FPW.BANCOSAG BA, ';
       sSelect := sSelect || '     FPW.SITUACAO S ';

       IF    P_FOLHA = 1 THEN
         sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (1, 9, 15) '; -- FOLHA NORMAL
   --       sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (12, 1, 9) '; -- FOLHA NORMAL
       ELSIF P_FOLHA = 2 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (13 ,6) '; -- FOLHA ADIANTAMENTO
       ELSIF P_FOLHA = 3 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (3) '; -- ADIANTAMENTO 13
       ELSIF P_FOLHA = 7 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (7) '; -- Pensao 13
       ELSIF P_FOLHA = 4 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (4) '; -- PARCELA FINAL 13
       ELSIF P_FOLHA = 8 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (20) '; -- ACORDO MP
       ELSIF P_FOLHA = 9 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (25) ';  -- Diferença MP
       END IF;   
       sSelect := sSelect || '  AND VM.VACODEVENT = ' || vacodevent ;

       if trunc(sysdate) = '19/03/2013' then
          sSelect := sSelect || '  AND f.fucodcargo in (64,1,553,231) ';
          sSelect := sSelect || '  AND f.fucodlot <> 30011099 ';
       end if;

       sSelect := sSelect || '  AND F.FUCODEMP = S.STCODEMP ';
       sSelect := sSelect || '  AND F.FUCODSITU = S.STCODSITU ';
       sSelect := sSelect || '  AND VM.VACODEMP = F.FUCODEMP ';
       sSelect := sSelect || '  AND VM.VAMATFUNC = F.FUMATFUNC ';
       sSelect := sSelect || '  AND VM.VADTREFER = ' || P_REFERENCIA ;
       sSelect := sSelect || '  AND F.FUCODBCOPG = B.BCCODBANCO ';
       sSelect := sSelect || '  AND F.FUCODBCOPG = BA.BACODBANCO ';
       sSelect := sSelect || '  AND F.FUCODAGEPG = BA.BACODAGENC ';
       sSelect := sSelect || '  AND B.BCDESBANCO LIKE ''%BRASIL%'' ';  
       sSelect := sSelect || 'GROUP BY F.FUNOMFUNC, ';
       sSelect := sSelect || '         F.FUMATFUNC, ';
       sSelect := sSelect || '         F.FUCPF, ';
       sSelect := sSelect || '         F.FUCODBCOPG, ';
       sSelect := sSelect || '         BA.BADESAGENC, ';
       sSelect := sSelect || '         REPLACE(fn_limpa_numero(F.FUCCORPAG),'' '',''''), ';
       sSelect := sSelect || '         B.BCDESBANCO ';
       
       
       insert into dropme(x,l) values('TesteDP',sSelect); commit; 
         
      OPEN C_FOLHA FOR TRIM(sSelect);
      
      

    if substr(P_TIPO,1,1) = 'F' then
       DELETE T_UTI_ARQTMP
        WHERE UTI_GERAARQTMP_PROC       = 'SP_GERAARQFOLHABB'
          AND GLB_ROTA_CODIGO           = DECODE(P_TIPO,'FAV','011','010')
          AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172';
     end if;   
           
    --   ACHOU := 'N'; -- ESTA VARIAVEL RECEBE SIM QDO S?O ACHADOS CONHECIMENTOS
       /*PEGAR O NUMERO DE ARQUIVO GERADOS PARA AQUELE CGC*/
       BEGIN
          SELECT COUNT(DISTINCT(UTI_CONTROLEENVIO_ARQUIVO)) + 1 
            INTO nNUMEROARQUIVO
            FROM T_UTI_CONTROLEENVIO
           WHERE  GLB_CLIENTE_CGCCPFREMETENTE = '61139432000172';
           IF nNUMEROARQUIVO = 1000 THEN
              nNUMEROARQUIVO := 1;
           END IF;
       END; 
       sIDINTERCAMBIO := 'FOLHA' || LPAD(nNUMEROARQUIVO,4,'0');

       
       /*CABECALHO DE INTERCAMBIO REGISTRO 000*/
       BEGIN
       SELECT MAX(NVL(TO_NUMBER(UTI_ARQTMP_SEQ),0)) + 1
         INTO nSequencia 
         FROM T_UTI_ARQTMP 
        WHERE UTI_GERAARQTMP_PROC       = 'SP_GERAARQFOLHABB'
        -- A SEQUENCIA SERA INDEPENDENTE DE ROTA, POIS SERAO GERADOS ARQUIVOS COM AS ROTAS MISTURADAS
          AND GLB_ROTA_CODIGO           = DECODE(P_TIPO,'FAV','011','010')  
          AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172';
          If  nvl(nSequencia,0) = 0 then
                  nSequencia := 1;
          End If; 
          EXCEPTION WHEN NO_DATA_FOUND THEN 
              nSequencia := 1;        
       END;      
       nVALORTOTAL := 0;

       BEGIN
      loop
        fetch C_FOLHA
          into cNome, cMatricula, cCPF,cBanco,cAgencia, cConta,  cValor, cBancoDesc ;
        exit when C_FOLHA%notfound;

       sAgencia := lpad(trim(cAGENCIA),5,'0');
       sConta := lpad(trim(cCONTA),12,'0');
          IF P_TIPO <> 'FAV' THEN   
             sIDREGISTRO       := RPAD(cNOME,30) ||
                                  '1' || 
                                  lpad(cCPF,14,'0') ||
                                  trim(to_char(to_date(p_dia,'dd/mm/yyyy'),'DDMMYYYY')) || 
                                  LPAD(cVALOR * 100,15) ||
                                  rpad(' ',20) ||
                                  '01' ||
                                  '  ' ||
                                  '30' ||
                                  '001' || sAgencia || Sconta  ||
                                  ' ' ||
                                  rpad(' ',30) ||
                                  rpad(' ',20) ||
                                  rpad(' ',2) ||
                                  rpad(' ',2) ;
                                  nVALORTOTAL := nVALORTOTAL + cVALOR;
                                   nSEQUENCIA := nSEQUENCIA + 1;

             INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                      UTI_GERAARQTMP_PROC,
                                      GLB_ROTA_CODIGO,
                                      GLB_CLIENTE_CGCCPFCODIGO,
                                      UTI_ARQTMP_LINHA,
                                      UTI_ARQTMP_ARQUIVO)
                               VALUES(nSequencia,
                                     'SP_GERAARQFOLHABB',
                                      DECODE(P_TIPO,'FAV','011','010'),
                                      '61139432000172',
                                      sIDREGISTRO,
                                      sIDINTERCAMBIO);
          ELSE
            
             sIDREGISTRO       := RPAD(cNOME,30) ||
                                  '1' || 
                                  lpad(cCPF,14,'0') ||
                                  '001' || sAgencia || Sconta  ||
                                  rpad(' ',30) ||
                                  rpad(' ',20) ||
                                  rpad(' ',8) ||
                                  rpad(' ',2) ;
                                   nSEQUENCIA := nSEQUENCIA + 1;

             INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                      UTI_GERAARQTMP_PROC,
                                      GLB_ROTA_CODIGO,
                                      GLB_CLIENTE_CGCCPFCODIGO,
                                      UTI_ARQTMP_LINHA,
                                      UTI_ARQTMP_ARQUIVO)
                               VALUES(nSequencia,
                                     'SP_GERAARQFOLHABB',
                                      DECODE(P_TIPO,'FAV','011','010'),
                                      '61139432000172',
                                      sIDREGISTRO,
                                      sIDINTERCAMBIO);
        end if;                             

          --EXIT WHEN C_CONHECIMENTO%NOTFOUND;
       END LOOP;
       END;
       
       if substr(P_TIPO,1,1) = 'F' then
         
       insert into T_UTI_CONTROLEENVIO
       values
         (sIDINTERCAMBIO,
          P_FOLHA,
          '61139432000172',
          P_REFERENCIA,
          SUBSTR(P_DIA, 1, 2),
          DECODE(P_TIPO, 'FAV', '011', '010'),
          SYSDATE,
          SYSDATE);
       
       commit;
       
       end if;
       
        CLOSE C_FOLHA;
        OPEN C_FOLHA FOR TRIM(sSelect);
       
      
   -- End If;   
    IF P_ERRO ='N' THEN
          P_MENSAGEM :='Arquivo gerado com sucesso';-- || SQLERRM;          
    END IF ;
       
       
    EXCEPTION WHEN OTHERS THEN
      begin
          P_ERRO :='S';
          P_MENSAGEM :='Erro ao Executar pkg_dp_folha.SP_GERAARQFOLHABB. Erro: '|| dbms_utility.format_error_backtrace;
      end;    
    end;      
          
          
          
          
    END SP_GERAARQFOLHABB;
    

  /*  SELECT F.FUNOMFUNC NOME,
           F.FUCPF CPF,
           F.FUCODBCOPG BANCO,
           BA.BADESAGENC AGENCIA,
           REPLACE(fn_limpa_numero(F.FUCCORPAG),' ','') CONTA,
           SUM(VM.VAVALEVENT) VALOR,
           B.BCDESBANCO BANCODESC
    FROM FPW.VALMES VM,
         FPW.FUNCIONA F,
         FPW.BANCOS B,
         FPW.BANCOSAG BA
    WHERE VM.VACODFOLHA IN (13 ,6) ?? -- FOLHA ADIANTAMENTO
      AND VM.VACODEVENT = 10030
      AND VM.VACODEMP = F.FUCODEMP
      AND VM.VAMATFUNC = F.FUMATFUNC
      AND VM.VADTREFER = '&referencia'
      AND F.FUCODBCOPG = B.BCCODBANCO
      AND F.FUCODBCOPG = BA.BACODBANCO
      AND F.FUCODAGEPG = BA.BACODAGENC
      AND B.BCDESBANCO LIKE '%BRASIL%'  
    GROUP BY F.FUNOMFUNC,
             F.FUCPF,
             F.FUCODBCOPG,
             BA.BADESAGENC,
             REPLACE(fn_limpa_numero(F.FUCCORPAG),' ',''),
             B.BCDESBANCO


     delete T_UTI_CONTROLEENVIO
     where GLB_CLIENTE_CGCCPFREMETENTE = '61139432000172'
       and UTI_CONTROLEENVIO_ARQUIVO = '';
     exec SP_GERAARQFOLHABB('201010','06','1');
     set linesize 176;
     set pagesize 0;
     spool C:\PRISCILA\BB1012.TXT;
     select substr(UTI_ARQTMP_LINHA,1,176)
     from T_UTI_ARQTMP
     where UTI_GERAARQTMP_PROC = 'SP_GERAARQFOLHABB'
       AND GLB_ROTA_CODIGO           = '010'
       AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172'
     order by UTI_ARQTMP_SEQ;
     spool off;*/
     
     


    PROCEDURE SP_GERAARQFOLHAHSBC(P_REFERENCIA     IN CHAR,
                                  P_DIACREDITO     IN CHAR,
                                  P_FOLHA          IN CHAR, -- 1 - Mensal
                                                   -- 2 - Adiantamento
                                                   -- 3 - Adiantamento 13
                                                   -- 4 - Parcela Final 13
                                                   -- 5 - vale Transporte
                                                   -- 6 - Pensao Normal
                                                   -- 7 - Pensao 13
                                                   -- 8 - Acordo MP
                                                   -- 9 - Diferença MP
                                  P_TIPO           IN CHAR,  -- (P)revia (F)echamento  
                                  P_ERRO           OUT VARCHAR2,
                                  P_MENSAGEM       OUT VARCHAR2,              
                                  C_FOLHA          OUT TYPES.cursorType)
    AS
    --C_FOLHA TYPES.cursorType;
    achou              CHAR(1);
    nSEQUENCIA         NUMBER;
    nNUMEROARQUIVO     NUMBER;
    nVALORTOTAL        number;
    sIDREGISTRO        char(300); 
    sIDINTERCAMBIO     CHAR(10);
    sAgencia           char(5);
    sConta             char(12);
    sSelect            varchar2(2000);
    sSelect2           varchar2(2000);
    cMatricula         fpw.funciona.fumatfunc%TYPE;
    cNome              fpw.funciona.FUNOMFUNC%type;
    cCPF               fpw.funciona.FUCPF%type;
    cBanco             fpw.funciona.FUCODBCOPG%type;
    cAgencia           FPW.BANCOSAG.BACODAGENC%type;
    cConta             fpw.funciona.FUCCORPAG%type;
    cValor             fpw.valmes.VAVALEVENT%type;
    cBancoDesc         FPW.BANCOS.BCDESBANCO%type;
    vFolha             Char(1);
    vString            varchar2(2000);


    BEGIN
     
    vString:= 'P_REFERENCIA =' ||P_REFERENCIA||
              ' P_DIACREDITO=' ||P_DIACREDITO||
              ' P_FOLHA     =' ||P_FOLHA     ||
              ' P_TIPO      =' ||P_TIPO;
    
    
    
     INSERT INTO T_GLB_SQL
       (GLB_SQL_INSTRUCAO,
        GLB_SQL_DTGRAVACAO,
        GLB_SQL_PROGRAMA,
        GLB_SQL_OBSERVACAO)
     VALUES
       (vString, sysdate, 'Folha DP', '');
     
    commit;            
    
     P_ERRO:='N';
    IF P_FOLHA not in ('6','7') THEN  
       sSelect :=            'SELECT lPAD(F.FUMATFUNC,9,''0'') MATRICULA,';
       sSelect := sSelect || '       F.FUNOMFUNC NOME, ';
       sSelect := sSelect || '       F.FUCPF CPF, ';
       sSelect := sSelect || '       SUBSTR(B.BCDESBANCO,1,3) BANCO, ';
       sSelect := sSelect || '       BA.BACODAGENC AGENCIA, ';
       sSelect := sSelect || '       REPLACE(fn_limpa_numero(F.FUCCORPAG),'' '','''') CONTA, ';
       IF P_FOLHA = 5 THEN
          sSelect := sSelect || '       SUM(EF.EFVALEVENT) VALOR, ';
       ELSE   
          sSelect := sSelect || '       SUM(VM.VAVALEVENT) VALOR, ';
       END IF;
       sSelect := sSelect || '       B.BCDESBANCO BANCODESC ';


       IF P_FOLHA = 5 THEN
          sSelect := sSelect || 'FROM FPW.EVEFUNC EF, ';
       ELSE
          sSelect := sSelect || 'FROM FPW.VALMES VM, ';
       END IF; 
       
       sSelect := sSelect || '     FPW.FUNCIONA F, ';
       sSelect := sSelect || '     FPW.BANCOS B, ';
       sSelect := sSelect || '     FPW.BANCOSAG BA, ';
       sSelect := sSelect || '     FPW.SITUACAO S ';


       IF    P_FOLHA = 1 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (1, 9, 15) '; -- FOLHA NORMAL
     --     sSelect := sSelect || '  AND F.FUMATFUNC IN (30001947,30001953,30001969,30002072,30002077,30002162,30002297,30002299,30002506,30002507,30002508,30002687,30002688,30002709,30002713,30002716,30002904,30002906,30003061,30003068,30003113,30003240,30003348,30003441,30003541,30003858,30003933,30004132,30004146,30004446,30004471,30004476,30004508,30004509,30004510,30004571,30005058,30005493,30005498,30005500,30005502,30005504,30005505,30005506,30006000,30006001,30006288,30006388,30006398,30006401,30006403,30006404,30006405,30006406,30006407,30006410,30006412,30006413,30006443,30006445,30006557,30006563,30006652,30006714,30006716,30006720,30006723,30006726,30006728,30006729,30006734,30006968,30006971,30007009,30007068,30007107,30007113,30007165,30007214,30007215,30007216,30007221,30007270,30007271,30007272,30007294,30007300,30007304,30007307)';
       ELSIF P_FOLHA = 2 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (13 ,6) '; -- FOLHA ADIANTAMENTO
       ELSIF P_FOLHA = 3 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (3) '; -- ADIANTAMENTO 13
       ELSIF P_FOLHA = 4 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (4) '; -- PARCELA FINAL 13   
       ELSIF P_FOLHA = 8 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (20) '; -- ACORDO MP
       ELSIF P_FOLHA = 9 THEN
          sSelect := sSelect || 'WHERE VM.VACODFOLHA IN (25) '; --Diferença MP
       END IF; 
         
       IF P_FOLHA = '5' THEN
          sSelect := sSelect || 'WHERE EF.EFCODEVENT = ' || '16035'; --Antiga 24080
          sSelect := sSelect || '  AND S.STTIPOSITU in (' || PKG_GLB_COMMON.fn_QuotedStr('N') || ',' || PKG_GLB_COMMON.fn_QuotedStr('F') || ')';
       ELSE
          sSelect := sSelect || '  AND VM.VACODEVENT = ' || vacodevent;
       END IF;  

       if trunc(sysdate) = '19/03/2013' then
          sSelect := sSelect || '  AND f.fucodcargo in (64,1,553,231) ';
          sSelect := sSelect || '  AND f.fucodlot <> 30011099 ';
       end if;
       
       IF P_FOLHA = '5' THEN
          sSelect := sSelect || '  AND EF.EFCODEMP = F.FUCODEMP ';
          sSelect := sSelect || '  AND EF.EFMATFUNC = F.FUMATFUNC ';
          sSelect := sSelect || '  AND ' || P_REFERENCIA || ' BETWEEN EF.EFDTINIC AND EF.EFDTFINAL ';
       ELSE
          sSelect := sSelect || '  AND VM.VACODEMP = F.FUCODEMP ';
          sSelect := sSelect || '  AND VM.VAMATFUNC = F.FUMATFUNC ';
          sSelect := sSelect || '  AND VM.VADTREFER = ' || P_REFERENCIA ;
       END IF;

       sSelect := sSelect || '  AND F.FUCODEMP = S.STCODEMP ';
       sSelect := sSelect || '  AND F.FUCODSITU = S.STCODSITU ';
       sSelect := sSelect || '  AND F.FUCODBCOPG = B.BCCODBANCO ';
       sSelect := sSelect || '  AND F.FUCODBCOPG = BA.BACODBANCO ';
       sSelect := sSelect || '  AND F.FUCODAGEPG = BA.BACODAGENC ';
       sSelect := sSelect || '  AND B.BCDESBANCO LIKE ''%HSBC%'' ';  
       sSelect := sSelect || 'GROUP BY lPAD(F.FUMATFUNC,9,''0''),';
       sSelect := sSelect || '         F.FUNOMFUNC, ';
       sSelect := sSelect || '         F.FUCPF, ';
       sSelect := sSelect || '         F.FUCODBCOPG, ';
       sSelect := sSelect || '         BA.BACODAGENC, ';
       sSelect := sSelect || '         REPLACE(fn_limpa_numero(F.FUCCORPAG),'' '',''''), ';
       sSelect := sSelect || '         B.BCDESBANCO ';
    ELSIF P_FOLHA IN ('6','7') THEN

       sSelect :=            'SELECT  distinct ';
    --   sSelect := sSelect || '       L.LOCODLOT LOTACAO,';
    --   sSelect := sSelect || '       L.LODESCLOT DESCLOT,';
       sSelect := sSelect || '       lPAD(F.FUMATFUNC,9,''0'') MATRICULA,';
    --   sSelect := sSelect || '       F.FUNOMFUNC FUNCIONARIO,';
       sSelect := sSelect || '       P.PENOMPENSI FAVORECIDO,';
       sSelect := sSelect || '       P.PECPFPENSI cpf, ';   
    --   sSelect := sSelect || '       (SELECT A.AFVALOR';
    --   sSelect := sSelect || '       FROM FPW.ATRIBFUN A';
    --   sSelect := sSelect || '       WHERE F.FUCODEMP = A.AFCODEMP';
    --   sSelect := sSelect || '       AND F.FUMATFUNC = A.AFMATFUNC';
    --   sSelect := sSelect || '       AND A.AFCODATRIB = 8) ATRIB,';
    --   sSelect := sSelect || '       E.EVDESRESUM EVENTO,';
       sSelect := sSelect || '       SUBSTR(B.BCDESBANCO,1,3) BANCO,';
       sSelect := sSelect || '       P.PECODAGENC AGENCIA,';
       sSelect := sSelect || '       REPLACE(fn_limpa_numero(P.PECONTCORR),'' '','''') CONTA, ';
       sSelect := sSelect || '       SUM(M.VAVALEVENT) VALOR, ';
       sSelect := sSelect || '       B.BCDESBANCO BANCODESC ';
    --   sSelect := sSelect || '       M.VADTREFER REFERENCIA,';
    --   sSelect := sSelect || '       M.VACODFOLHA FOLHA,';
    --   sSelect := sSelect || '       FO.FODESCOMPL DESFOLHA,';
       sSelect := sSelect || 'FROM FPW.VALANO M,';  -- EVENTOS DOS FUNCIONARIOS DO MES
       sSelect := sSelect || '     V_FPW_PENSIONSITAS P,'; -- VIEW COM OS BENEFICIARIOS DE PENSAO
       sSelect := sSelect || '     FPW.FUNCIONA F,'; -- TABELA DE FUNCIONARIOS
       sSelect := sSelect || '     FPW.FOLHAS FO,'; -- TABELA DE TIPOS DE FOLHA DE PAGAMENTO
       sSelect := sSelect || '     FPW.EVENTOS E,'; -- TABELA DE EVENTOS
       sSelect := sSelect || '     FPW.LOTACOES L,'; -- TABELA DE LOTAC?ES
       sSelect := sSelect || '     FPW.BANCOS B, ';
       sSelect := sSelect || '     FPW.SITUACAO SI ';
       sSelect := sSelect || 'WHERE M.VACODEMP = P.PECODEMP ';
       sSelect := sSelect || '  AND M.VAMATFUNC = P.PEMATFUNC ';
       sSelect := sSelect || '  AND M.VACODEVENT = P.EVENTO ';
       sSelect := sSelect || '  AND M.VACODEMP = FO.FOCODEMP ';
       sSelect := sSelect || '  AND M.VACODFOLHA = FO.FOCODFOLHA ';
       sSelect := sSelect || '  AND M.VACODEMP = F.FUCODEMP ';
       sSelect := sSelect || '  AND M.VAMATFUNC = F.FUMATFUNC ';
       sSelect := sSelect || '  AND F.FUCODEMP = L.LOCODEMP ';
       sSelect := sSelect || '  AND F.FUCODLOT = L.LOCODLOT ';
       sSelect := sSelect || '  AND P.PECODBANCO = B.BCCODBANCO ';
       sSelect := sSelect || '  AND NVL(P.PECPFPENSI,0) > 0 ';
       sSelect := sSelect || '  AND P.PECODBANCO not in (2,399) ';
       --sSelect := sSelect || '  AND F.FUMATFUNC NOT IN (''900000002'',''900000003'',''900000001'',''460000065'',''010005092'',''010005388'',''030003713'',''030007789'',''030002463'',''010005084'',''010005084'',''030009107'',''010006379'') ';   
       IF P_FOLHA = '6' THEN
          sSelect := sSelect || '  AND M.VACODFOLHA IN (1, 15) ';
          --sSelect := sSelect || '  AND P.PEMATFUNC NOT IN (10006020,630000085)';
          sSelect := sSelect || '  AND M.VADTREFER = '||P_REFERENCIA;
       ELSIF P_FOLHA = '7' THEN
          sSelect := sSelect || '  AND M.VACODFOLHA IN (4) ';
       ELSIF P_FOLHA = '8' THEN
          sSelect := sSelect || '  and M.VACODFOLHA IN (20) '; -- ACORDO MP
       ELSIF P_FOLHA = '9' THEN
          sSelect := sSelect || '  and M.VACODFOLHA IN (25) ';
       END IF;   
       sSelect := sSelect || '  AND M.VACODEVENT = E.EVCODEVENT ';
       sSelect := sSelect || '  AND SI.STCODSITU = F.FUCODSITU ';
       sSelect := sSelect || '  AND SI.STTIPOSITU <> ''R''';
       sSelect := sSelect || '  group by     F.FUMATFUNC,  ';
       sSelect := sSelect || '               P.PENOMPENSI, ';
       sSelect := sSelect || '               P.PECPFPENSI, ';
       sSelect := sSelect || '               B.BCDESBANCO, ';
       sSelect := sSelect || '               P.PECODAGENC, ';
       sSelect := sSelect || '               REPLACE(fn_limpa_numero(P.PECONTCORR), '' '', '''') ,';
       sSelect := sSelect || '               B.BCDESBANCO';
       sSelect := sSelect || '  order by lPAD(F.FUMATFUNC,9,''0'')';
    END IF;
    
    INSERT INTO T_GLB_SQL
      (GLB_SQL_INSTRUCAO, GLB_SQL_DTGRAVACAO, GLB_SQL_PROGRAMA)
    VALUES
      (sSelect, SYSDATE, 'TESTE FPW'); commit;
    
    OPEN C_FOLHA FOR TRIM(sSelect);

    
   
    if P_TIPO = 'F' then
       DELETE T_UTI_ARQTMP
        WHERE UTI_GERAARQTMP_PROC       = 'SP_GERAARQFOLHAHSBC'
          AND GLB_ROTA_CODIGO           = '010'
          AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172';
       ACHOU := 'N'; -- ESTA VARIAVEL RECEBE SIM QDO S?O ACHADOS CONHECIMENTOS
       /*PEGAR O NUMERO DE ARQUIVO GERADOS PARA AQUELE CGC*/
       BEGIN
          SELECT COUNT(DISTINCT(UTI_CONTROLEENVIO_ARQUIVO)) + 1 
            INTO nNUMEROARQUIVO
            FROM T_UTI_CONTROLEENVIO
           WHERE  GLB_CLIENTE_CGCCPFREMETENTE = '61139432000172';
           IF nNUMEROARQUIVO = 1000 THEN
              nNUMEROARQUIVO := 1;
           END IF;
       END; 
       sIDINTERCAMBIO := 'FOLHA' || LPAD(nNUMEROARQUIVO,4,'0');
       
       /*CABECALHO DE INTERCAMBIO REGISTRO 000*/
       BEGIN
       SELECT MAX(NVL(TO_NUMBER(UTI_ARQTMP_SEQ),0)) + 1
         INTO nSequencia 
         FROM T_UTI_ARQTMP 
        WHERE UTI_GERAARQTMP_PROC       = 'SP_GERAARQFOLHAHSBC'
        -- A SEQUENCIA SERA INDEPENDENTE DE ROTA, POIS SERAO GERADOS ARQUIVOS COM AS ROTAS MISTURADAS
          AND GLB_ROTA_CODIGO           = '010'  
          AND GLB_CLIENTE_CGCCPFCODIGO  = '61139432000172';
          If  nvl(nSequencia,0) = 0 then
                  nSequencia := 1;
          End If; 
          EXCEPTION WHEN NO_DATA_FOUND THEN 
              nSequencia := 1;        
       END;      
       sIDREGISTRO       := '399' || 
                            LPAD(nNUMEROARQUIVO,4,'0') || 
                            '0' ||
                            RPAD(' ',9) ||
                            '2' || 
                            '61139432000172' ||
                            '541184' ||
                            RPAD(' ',14) ||
                            '01027' ||
                            RPAD(' ',1) ||
                            '000000047001' ||
                            '5' ||
                            ' ' ||
                            'TRANSPORTES DELLA VOLPE S/A   ' ||
                            'HSBC BANK BRASIL S/A - BANCO M' ||
                            RPAD(' ',10) ||
                            '1' ||
                            TRIM(TO_CHAR(SYSDATE,'DDMMYYYY')) ||
                            TRIM(TO_CHAR(SYSDATE,'HH24MMSS')) ||
                            TRIM(TO_CHAR(NSEQUENCIA,'000000')) ||
                            '020' ||
                            '01600' ||
                            'CPG' ||
                            'Y2K' ||
                            RPAD(' ',14) ||
                            RPAD(' ',49) ;
       -- GRAVAR NA TABELA TEMPORARIA
       INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                UTI_GERAARQTMP_PROC,
                                GLB_ROTA_CODIGO,
                                GLB_CLIENTE_CGCCPFCODIGO,
                                UTI_ARQTMP_LINHA,
                                UTI_ARQTMP_ARQUIVO)
                         VALUES(nSequencia - 1,
                               'SP_GERAARQFOLHAHSBC',
                                '010',
                                '61139432000172',
                                sIDREGISTRO,
                                sIDINTERCAMBIO);
       nSequencia := nSequencia + 1;

       sIDREGISTRO       := '399' || 
                            LPAD(nNUMEROARQUIVO,4,'0') || 
                            '1' ||
                            'C' ;
             IF P_FOLHA In ('1','2','3','4','5','8','9') THEN
                  -- pagamento de salario
                  -- credito conta corrente
                  sIDREGISTRO := trim(sIDREGISTRO) || '31' || 
                                                      '01' ;  
             ELSIF P_FOLHA In ('6','7') THEN                  
                  -- pagamento de Aposentadoria / pensao
                  -- credito conta corrente             
                  sIDREGISTRO := trim(sIDREGISTRO)  || '90' || 
                                                       '03' ;  
             END IF;
       sIDREGISTRO := trim(sIDREGISTRO)  || '020' ||
                                      RPAD(' ',1) ||
                                              '2' || 
                                 '61139432000172' ||
                                         '541184' ||
                                     RPAD(' ',14) ||
                                          '01027' ||
                                      RPAD(' ',1) ||
                                   '000000047001' ||
                                              '5' ||
                                              ' ' ||
                 'TRANSPORTES DELLA VOLPE S/A   ' ||
                                     RPAD(' ',40) || -- MENSAGEM PARA O FUNCIONARIO
                            RPAD('RUA LIDICE',30) ||
                                          '00022' ||
                                     RPAD(' ',15) ||
                             RPAD('SAO PAULO',20) ||
                                  RPAD('02174',5) ||
                                    RPAD('010',3) ||
                                     RPAD('SP',2) ||
                                              'S' ||
                                        RPAD(' ',17);
                            
       INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                UTI_GERAARQTMP_PROC,
                                GLB_ROTA_CODIGO,
                                GLB_CLIENTE_CGCCPFCODIGO,
                                UTI_ARQTMP_LINHA,
                                UTI_ARQTMP_ARQUIVO)
                         VALUES(nSequencia,
                               'SP_GERAARQFOLHAHSBC',
                                '010',
                                '61139432000172',
                                sIDREGISTRO,
                                sIDINTERCAMBIO);
                            
      nSequencia := nSequencia + 1;

       nVALORTOTAL := 0;
       vFolha := P_FOLHA;
       
       -- se tiver que mudar a folha usar codigo acima de 6
       If P_DIACREDITO = '22/01/2015' Then
          vFolha := 'K';
       End If;   
       

       BEGIN
      loop
        fetch C_FOLHA
          into cMatricula,cNome, cCPF,cBanco,cAgencia, cConta,  cValor, cBancoDesc ;
        exit when C_FOLHA%notfound;

    -- inserindo tipo A
       sIDREGISTRO       := '399' || 
                            LPAD(nNUMEROARQUIVO,4,'0') || 
                            '3' ||
                            TRIM(TO_CHAR(nSEQUENCIA-2,'00000')) ||
                            'A' ||
                            '0' ||
                            '00' ||
                            '018' ||
                            LPAD(trim(cBanco),3,'0') ||
                            LPAD(trim(cAGENCIA),5,'0') ||
                            ' ' ||
                            LPAD(trim(cCONTA),13,'0') ||
                            ' ' ||
                            RPAD(cNOME,30) ||
--                            LPAD(P_REFERENCIA || trim(vFOLHA) ||cmATRICULA,16,'0') ||
                            LPAD(P_REFERENCIA || trim('9') ||cmATRICULA,16,'0') ||
                            RPAD(' ',4) ||
                            trim(to_char(to_date(P_DIACREDITO,'dd/mm/yyyy'),'DDMMYYYY')) || 
                            'R$ ' ||
                            RPAD(' ',17) ||
                            LPAD(cVALOR * 100,13,'0') ||
                            RPAD(' ',1) ||
                            RPAD(' ',30) ||
                            RPAD(' ',12) ||
                            RPAD(' ',40) ||
                            RPAD(' ',2) ||
                            RPAD(' ',5) ;

             IF P_FOLHA In ('1','2','3','4','5','8','9') THEN
               -- finalidade
                  sIDREGISTRO := trim(sIDREGISTRO)  || RPAD(' ',2) ;  
             ELSIF P_FOLHA In ('6','7') THEN                        
               -- finalidade do DOC Credito em conta corrente        
                  sIDREGISTRO := trim(sIDREGISTRO)  || '01' ;        
             END IF;               

       sIDREGISTRO := trim(sIDREGISTRO)  || RPAD(' ',3) ||
                                            RPAD(' ',1) ||
                                            RPAD(' ',10);

                            nVALORTOTAL := nVALORTOTAL + cVALOR;
                             nSEQUENCIA := nSEQUENCIA + 1;

       INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                UTI_GERAARQTMP_PROC,
                                GLB_ROTA_CODIGO,
                                GLB_CLIENTE_CGCCPFCODIGO,
                                UTI_ARQTMP_LINHA,
                                UTI_ARQTMP_ARQUIVO)
                         VALUES(nSequencia,
                               'SP_GERAARQFOLHAHSBC',
                                '010',
                                '61139432000172',
                                sIDREGISTRO,
                                sIDINTERCAMBIO);
    -- inserindo tipo B

       sIDREGISTRO       := '399' || 
                            LPAD(nNUMEROARQUIVO,4,'0') || 
                            '3' ||
                            TRIM(TO_CHAR(nSEQUENCIA-2,'00000')) ||
                            'B' ||
                            RPAD(' ',3) ||
                            '1' ||
                            LPAD(trim(cCPF),14,'0') ||
                            RPAD(' ',30) ||
                            RPAD(' ',5) ||
                            RPAD(' ',15) ||
                            RPAD(' ',15) ||
                            RPAD(' ',20) ||
                            RPAD(' ',5) ||
                            RPAD(' ',3) ||
                            RPAD(' ',2) ||
                            RPAD(' ',113);
                            nVALORTOTAL := nVALORTOTAL + cVALOR;
                             nSEQUENCIA := nSEQUENCIA + 1;

       INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                UTI_GERAARQTMP_PROC,
                                GLB_ROTA_CODIGO,
                                GLB_CLIENTE_CGCCPFCODIGO,
                                UTI_ARQTMP_LINHA,
                                UTI_ARQTMP_ARQUIVO)
                         VALUES(nSequencia,
                               'SP_GERAARQFOLHAHSBC',
                                '010',
                                '61139432000172',
                                sIDREGISTRO,
                                sIDINTERCAMBIO);




          --EXIT WHEN C_CONHECIMENTO%NOTFOUND;
       END LOOP;
       END;

      CLOSE C_FOLHA;
      OPEN C_FOLHA FOR TRIM(sSelect);

       
       BEGIN
      loop
        fetch C_FOLHA
          into cMatricula,cNome, cCPF,cBanco,cAgencia, cConta,  cValor, cBancoDesc ;
        exit when C_FOLHA%notfound;


          --EXIT WHEN C_CONHECIMENTO%NOTFOUND;
       END LOOP;
       END;


       sIDREGISTRO       := '399' || 
                            LPAD(nNUMEROARQUIVO,4,'0') || 
                            '5' ||
                            rpad(' ',9) ||
                            lpad(TRIM(TO_CHAR(nSEQUENCIA - 1)),6,'0') ||
                            rpad(' ',3) ||
                            trim(lpad(nVALORTOTAL*100,15,'0')) ||
                            rpad(' ',199);

                            nSEQUENCIA := nSEQUENCIA + 1;
                                  
       INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                UTI_GERAARQTMP_PROC,
                                GLB_ROTA_CODIGO,
                                GLB_CLIENTE_CGCCPFCODIGO,
                                UTI_ARQTMP_LINHA,
                                UTI_ARQTMP_ARQUIVO)
                         VALUES(nSequencia,
                               'SP_GERAARQFOLHAHSBC',
                                '010',
                                '61139432000172',
                                sIDREGISTRO,
                                sIDINTERCAMBIO);
                             nSEQUENCIA := nSEQUENCIA + 1;

       sIDREGISTRO       := '399' || 
                            '9999' || 
                            '9' ||
                            rpad(' ',9) ||
                            '000001' ||
                            lpad(trim(TO_CHAR(nSEQUENCIA-1)),6,'0') ||
                            rpad(' ',211) ;

                            nSEQUENCIA := nSEQUENCIA + 1;
                                 
       INSERT INTO T_UTI_ARQTMP(UTI_ARQTMP_SEQ,
                                UTI_GERAARQTMP_PROC,
                                GLB_ROTA_CODIGO,
                                GLB_CLIENTE_CGCCPFCODIGO,
                                UTI_ARQTMP_LINHA,
                                UTI_ARQTMP_ARQUIVO)
                         VALUES(nSequencia,
                               'SP_GERAARQFOLHAHSBC',
                                '010',
                                '61139432000172',
                                sIDREGISTRO,
                                sIDINTERCAMBIO);

         commit;
         CLOSE C_FOLHA;
         OPEN C_FOLHA FOR TRIM(sSelect);
    end if;
 if P_ERRO ='N' THEN
    P_MENSAGEM :='Arquivo gerado com sucesso';
    END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
    P_ERRO:='S';
    P_MENSAGEM :='Erro contate a TI' || SQLERRM;   




    END SP_GERAARQFOLHAHSBC;
    /*
     delete T_UTI_CONTROLEENVIO
     where GLB_CLIENTE_CGCCPFREMETENTE = '34274233026675'
       and UTI_CONTROLEENVIO_ARQUIVO = ''
     exec SP_GERAARQFOLHABB('34274233026675','030')
     spool c:\PRISCILA\HS1012.txt;
     set linesize 240;
     set linesize 240;
     set pagesize 0;
     select SUBSTR(UTI_ARQTMP_LINHA,1,240)
     from T_UTI_ARQTMP
     where UTI_GERAARQTMP_PROC = 'SP_GERAARQFOLHAHSBC'
     order by UTI_ARQTMP_SEQ;
     spool off;

    */

PROCEDURE SP_TRANSFERE_ACERTO_FPW (P_MES IN CHAR,
                                   P_ANO IN CHAR,
                                   P_VAL IN CHAR,
                                   P_ERRO OUT VARCHAR2,
                                   P_MENSAGEM OUT VARCHAR2)
AS

  VT_VALOR     NUMBER;
  VT_VALES     NUMBER;
  VT_DIFERENCA NUMBER;
  VT_LINHA     VARCHAR2(100);

  CURSOR CMOTORISTA IS
  SELECT M.FRT_MOTORISTA_CODIGO CODIGO,
         M.FRT_MOTORISTA_NOME NOME,
         M.FRT_MOTORISTA_MATRICULA MATRICULA
    FROM T_FRT_MOTORISTA M
   WHERE NVL(FRT_MOTORISTA_COMISSAO,'N') = 'S'
     AND FRT_MOTORISTA_CODIGO IS NOT NULL;
    
BEGIN
  
  P_ERRO := 'N';

  -- EXCLUI PROCESSAMENTOS ANTERIORES DA MESMA REFERENCIA

  DELETE T_ACC_TRANSFPW
  WHERE substr(ACC_TRANSFPW_LINHA,18,6) = P_ANO||P_MES;
  COMMIT;

/*
FOR rMOTORISTA in cMOTORISTA LOOP
    SELECT NVL(SUM(ACC_ACONTAS_VALOR_RECEITA),0) INTO VT_VALOR
      FROM T_ACC_ACONTAS
     WHERE FRT_MOTORISTA_CODIGO = rMOTORISTA.CODIGO
       AND ACC_ACONTAS_REFERENCIA = P_MES||P_ANO;
*/

FOR rMOTORISTA in cMOTORISTA LOOP

  BEGIN
    SELECT --TMP_RPT_TEXTO1 MATRICULA,
           --TMP_RPT_TEXTO2 NOME,
           NVL(TMP_RPT_VALOR1,0) RECEITA,
           --TMP_RPT_VALOR2 COMISSAO,
           NVL(TMP_RPT_VALOR3,0) DIFERENCA,
           NVL(TMP_RPT_VALOR4,0) VALES
      INTO VT_VALOR,
           VT_DIFERENCA,
           VT_VALES
      FROM T_TMP_RPT 
     WHERE TMP_RPT_RELATORIO    = 'C:\TDVSIS\accontas\rpt_dp1.rpt'
       AND TMP_RPT_USUARIO      = 'TDVADM'
       AND TRIM(TMP_RPT_TEXTO1) = TRIM(rMOTORISTA.CODIGO)
       AND TRIM(TMP_RPT_TEXTO3) = P_MES||P_ANO;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    VT_VALES     := 0;
    VT_VALOR     := 0;
    VT_DIFERENCA := 0;
    VT_LINHA     := '';
    END;    

  -- ATRIBUI VALOR MINIMO QUANDO HOUVER

  IF NVL(VT_VALOR,0) = 0 THEN
    VT_VALOR := TO_NUMBER(P_VAL)* 100;
  ELSE
    VT_VALOR := VT_VALOR * 100;
    END IF;
    
  VT_VALES     := VT_VALES * 100;

  VT_DIFERENCA := VT_DIFERENCA * 100;

  IF NVL(VT_VALOR,0) > 0 THEN    
    VT_LINHA := '001'||
                LPAD(RMOTORISTA.MATRICULA,9,'0')||
                '16005'||
                P_ANO||
                P_MES||
                P_ANO||
                P_MES||                    
                LTRIM(TO_CHAR(NVL(VT_VALOR,0),'000000000000000'))||'0000';
    INSERT INTO T_ACC_TRANSFPW VALUES(VT_LINHA,SYSDATE);
    END IF;

  IF NVL(VT_DIFERENCA,0) < 0 THEN
    VT_LINHA := '001'||
                LPAD(RMOTORISTA.MATRICULA,9,'0')||
                '08040'||
                P_ANO||
                P_MES||
                P_ANO||
                P_MES||                    
                LTRIM(TO_CHAR(( NVL(VT_DIFERENCA,0) * -1),'000000000000000'))|| '0000';
    INSERT INTO T_ACC_TRANSFPW VALUES(VT_LINHA,SYSDATE);
    
    IF NVL(VT_VALES,0) > 0  THEN
      VT_LINHA := '001'||
                  lpad(rMOTORISTA.MATRICULA,9,'0')||
                  '01085'||
                  P_ANO||
                  P_MES||
                  P_ANO||
                  P_MES||                    
                  LTRIM(TO_CHAR(nvl(VT_VALES,0),'000000000000000'))|| '0000';
      INSERT INTO T_ACC_TRANSFPW VALUES(VT_LINHA,sysdate);
      END IF;
  ELSE
    IF NVL(VT_DIFERENCA,0) + NVL(VT_VALES,0) > 0 THEN   
      VT_LINHA := '001'||
                  LPAD(RMOTORISTA.MATRICULA,9,'0')||
                  '01085'||
                  P_ANO||
                  P_MES||
                  P_ANO||
                  P_MES||                    
                  LTRIM(TO_CHAR((NVL(VT_DIFERENCA,0) + NVL(VT_VALES,0)),'000000000000000'))|| '0000';

      INSERT INTO T_ACC_TRANSFPW VALUES(VT_LINHA,SYSDATE);
      END IF;  
    END IF;

  UPDATE T_ACC_VALES 
     SET ACC_VALES_FLAGENVDP = 'S',
         ACC_VALES_DTENVDEP = SYSDATE
   WHERE ACC_ACONTAS_NUMERO   =  '22222222'
     AND ACC_VALES_FLAGENVDP IS NULL
     AND FRT_MOTORISTA_CODIGO = RMOTORISTA.CODIGO;

  END LOOP;

  COMMIT;
  
  IF P_ERRO ='N' THEN
    P_MENSAGEM :='Arquivo gerado com sucesso';-- || SQLERRM;          
    END IF ;
  EXCEPTION WHEN OTHERS THEN
  -- RAISE_APPLICATION_ERROR(-20001, VT_LINHA || '-' || SQLERRM);
    P_ERRO :='S';
    P_MENSAGEM :='Erro contato a TI :'|| SQLERRM;

  END SP_TRANSFERE_ACERTO_FPW;

PROCEDURE SP_TRANSFERE_ACERTO_FPW (P_MES IN CHAR,
                                   P_ANO IN CHAR,
                                   P_VAL IN CHAR,
                                   P_ACAO IN CHAR DEFAULT 'G', -- (G)ERAR OU (R)EGERAR
                                   P_CURSOR OUT T_CURSOR,
                                   P_ERRO OUT VARCHAR2,
                                   P_MENSAGEM OUT VARCHAR2) as
  BEGIN
    IF NVL(P_ACAO,'G') = 'G' THEN
      PKG_DP_FOLHA.SP_TRANSFERE_ACERTO_FPW(P_MES,
                                           P_ANO,
                                           P_VAL,
                                           P_ERRO,
                                           P_MENSAGEM);
       ELSE
         P_ERRO := PKG_GLB_COMMON.STATUS_NOMAL;
         END IF;                                       

    IF P_ERRO = PKG_GLB_COMMON.STATUS_NOMAL THEN
      OPEN P_CURSOR FOR SELECT DISTINCT 
                                     SUBSTR(S.ACC_TRANSFPW_LINHA,13,5) EVENTO,
                                     S.ACC_TRANSFPW_LINHA LINHA
                                FROM T_ACC_TRANSFPW S
                               WHERE 0 = 0
                                 AND SUBSTR(S.ACC_TRANSFPW_LINHA,18,6) = P_ANO || P_MES;
       END IF;                       
     
     END SP_TRANSFERE_ACERTO_FPW;                                       

PROCEDURE SP_RELATORIO_DP(P_USUARIO    in Char,
                          P_RELATORIO  in Char,
                          P_REFERENCIA in Char,
                          P_VALORDP    in Number,
                          P_ERRO out varchar2,
                          P_MENSAGEM out varchar2) as
  FLAG      Varchar2(5);
  RECEITA   Number := 0;
  COMISSAO  Number := 0;
  DIFERENCA Number := 0;
  VALE      Number := 0;
  SOMA      Number := 0;
  OUTROS    NUMBER := 0;

  Cursor C_DADOS is
    Select distinct A.FRT_MOTORISTA_CODIGO,
                    A.FRT_MOTORISTA_NOME,
                    B.FRT_CONJVEICULO_CODIGO,
                    '1' fucodsitu
      From V_FRT_MOTORISTA A, T_FRT_CONJUNTO B, fpw.FUNCIONA C
     Where A.FRT_MOTORISTA_CODIGO = B.FRT_MOTORISTA_CODIGO(+)
       And A.FRT_MOTORISTA_CODIGO =
           substr(C.FUMATFUNC, (length(C.FUMATFUNC) - 3), 4)
       And A.FRT_MOTORISTA_COMISSAO = 'S'
       and c.fucodcargo in (SELECT C.CACODCARGO 
                            FROM FPW.CARGOS C 
                            WHERE C.CACBO in ('782510','782310'))
       And 0 < (select count(*)
                  from fpw.situacao s
                 where s.stcodsitu = C.FUCODSITU
                   and s.sttipositu in ('A', 'N', 'F'))
          -- VERIFICAR COM jARBAS DEPOIS SOBRA AS LOTAC?ES OU CODIGOS DOS MOTORISTAS
          -- 22/12/2008
          --      And c.fucodlot in ('10015010','30034017','160160016')
       and c.fucodcargo not in ('629')
       and c.fumatfunc not in ('900000004')
       AND A.FRT_MOTORISTA_CODIGO NOT IN ('5471'); --RETIRAR DEPOIS
  R_DADOS C_DADOS%Rowtype;
Begin
  --Limpa dados de execuc?es anteriores do usuario
  P_ERRO :='N';

  Delete T_TMP_RPT
   Where TMP_RPT_USUARIO = P_USUARIO
     And TMP_RPT_RELATORIO = P_RELATORIO;
  COMMIT;
  For R_DADOS in C_DADOS Loop
    --INSERE NA VARIAVEL A RECEITA, COMISS?O E DIFERENCA DO ACERTO
  
    Select Nvl(SUM(ACC_ACONTAS_VALOR_RECEITA), 0),
           Nvl(SUM(ACC_ACONTAS_VALOR_COMISSAO), 0),
           Nvl(SUM(ACC_ACONTAS_DIFERENCA), 0)
      Into RECEITA, COMISSAO, DIFERENCA
      From T_ACC_ACONTAS
     Where FRT_MOTORISTA_CODIGO(+) = R_DADOS.FRT_MOTORISTA_CODIGO
       And ACC_ACONTAS_REFERENCIA(+) = P_REFERENCIA;
  
    --INSERE NA VARIAVEL O VALOR DE VALES RETIRADOS (P/ ACERTO NO DP)
  
IF (R_DADOS.FRT_MOTORISTA_CODIGO = '6308') OR (R_DADOS.FRT_MOTORISTA_CODIGO = '4189') THEN
   VALE := VALE;
END IF;  
  
    Select Nvl(SUM(ACC_VALES_VALOR), 0)
      Into VALE
      From T_ACC_VALES
     Where FRT_MOTORISTA_CODIGO = R_DADOS.FRT_MOTORISTA_CODIGO
          -- retirado pois o motorista pode fazer vales apos o fechamento 
          -- ficando a referencia errada se for considerado o mes e ano da data 
          -- do recebimento (28/05/2001) sirlano
          --And to_char(ACC_VALES_DATARECEBIMENTO, 'MMYYYY') = P_referencia
       And ACC_VALES_FLAGENVDP is null
       And ACC_CONTAS_CICLO = '0'
       And ACC_ACONTAS_NUMERO = '22222222';
  
    SOMA := RECEITA + COMISSAO + DIFERENCA + VALE;
    If RECEITA <= 0 Then
      RECEITA := P_VALORDP;
    End If;
  
    -- GILES - 29/12/2004
    -- COLUNA QUE SOMARA AS VERBAS QUE CONSTAM NO VALEFRETE "COMPLEMENTO"
  
    SELECT NVL(SUM(B.CON_VALEFRETE_ESTADIA), 0) +
           NVL(SUM(B.CON_VALEFRETE_OUTROS), 0) +
           NVL(SUM(B.CON_VALEFRETE_VALORESTIVA), 0) +
           NVL(SUM(B.CON_VALEFRETE_ENLONAMENTO), 0)
      INTO OUTROS
      FROM T_ACC_ACONTAS A, T_CON_VALEFRETE B
     WHERE A.FRT_MOTORISTA_CODIGO(+) = R_DADOS.FRT_MOTORISTA_CODIGO
       AND A.ACC_ACONTAS_REFERENCIA(+) = P_REFERENCIA
       AND B.CON_CATVALEFRETE_CODIGO = '05'
       AND A.ACC_ACONTAS_NUMERO = B.ACC_ACONTAS_NUMERO
       AND A.ACC_CONTAS_CICLO = B.ACC_CONTAS_CICLO;
  
    Insert into T_TMP_RPT
      (TMP_RPT_USUARIO,
       TMP_RPT_RELATORIO,
       TMP_RPT_TEXTO1,
       TMP_RPT_TEXTO2,
       TMP_RPT_VALOR1,
       TMP_RPT_VALOR2,
       TMP_RPT_VALOR3,
       TMP_RPT_VALOR4,
       TMP_RPT_VALOR5,
       TMP_RPT_VALOR6,
       TMP_RPT_texto3,
       TMP_RPT_VALOR7)
    Values
      (P_USUARIO,
       P_RELATORIO,
       R_DADOS.FRT_MOTORISTA_CODIGO,
       R_DADOS.FRT_MOTORISTA_NOME,
       RECEITA,
       COMISSAO,
       DIFERENCA,
       VALE,
       SOMA,
       R_DADOS.FUCODSITU,
       P_REFERENCIA,
       OUTROS);
  End Loop;
  Commit;
  IF P_ERRO ='N' THEN
  P_MENSAGEM :='Relátorio Gerado com sucesso';
  END IF; 
  EXCEPTION
           WHEN OTHERS THEN
              P_ERRO := 'S';
              P_MENSAGEM := 'Informe a TI erro : ' || SQLERRM;
         
End SP_RELATORIO_DP;


PROCEDURE SP_CPG_GERATITULOS_PARCELAS(P_TIPO       IN CHAR,
                                      P_TP_PROCESS IN CHAR,
                                      P_MATRICULAS IN CHAR,
                                      P_VENCIMENTO IN CHAR,
                                      P_MESREF     IN CHAR,
                                      P_CURSOR     OUT TYPES.CURSORTYPE)IS
   P_VLRTOTAL     NUMBER;
   TEMP_          NUMBER;
   CURSOR_        INTEGER;
   LOTACAO        VARCHAR2(3000);
   DESCLOT        VARCHAR2(3000);
   MATRICULA      VARCHAR2(3000);
   FUNCIONARIO    VARCHAR2(3000);
   FAVORECEIDO    VARCHAR2(3000);
   ATRIB          VARCHAR2(3000);
   EVENTO         VARCHAR2(3000);
   VALOR          VARCHAR2(3000);
   REFERENCIA     VARCHAR2(3000);
   FOLHA          VARCHAR2(3000);
   DESFOLHA       VARCHAR2(3000);
   BANCO          VARCHAR2(3000);
   AGENCIA        VARCHAR2(3000);
   CONTA          VARCHAR2(3000);
   ORDER_BY       VARCHAR2(300);
   SELECT_        VARCHAR2(30000);
   MATRICULA_     VARCHAR2(30000);
   MESREFERENCIA_ VARCHAR2(30000);
   V_BODYMAIL     VARCHAR2(30000);
   P_TITULO       VARCHAR(100);
   P_TITDROP      VARCHAR(100);
   P_DESPESA      VARCHAR(8);
   P_PARCELAS     VARCHAR(200);
   P_PQTDE        VARCHAR(100);
   P_OBS          VARCHAR(200);
   P_VERIFICA     BOOLEAN;
   P_RELACAO_N_V  UTL_FILE.FILE_TYPE;
   vTIPO          char(1);
-- ROTINA CRIADA PARA PAGAMENTO DOS FUNCIONARIOS DA FOLHA QUE N?O RECEBEM EM CONTA.
-- IMPORTO ESSAS QUANTIAS E GERO UM TITULO A PAGAR NO CPG.
-- KLAYTON AGOSTO DE 2008.
  

-- ALTERADO PARA ENVIAR OS EVENTOS N?O CONTABILIZAVEIS
-- 29-09-2008 - ROBERTO PARIZ.
/*
TIPO POSSIVEIS

     Q = Adiantamento Quinzenal (0251)   
     F = Folha                  (0252)           
     P = Pens?es                (0253)           
     L = P.L.R                  (0254)
     E = Estagiarios            (0255)     
     A = Adiantamento 13º       (0256)
     D = Parcela Final 13º      (0257)      

*/
BEGIN

     vTIPO             := P_TIPO;
     MATRICULA_        := P_MATRICULAS;
     MESREFERENCIA_    :=' AND M.VADTREFER = '|| P_MESREF;
     V_BODYMAIL        :='FOI CRIADO UM TITULO DE PREVISÃO PARA ';
     P_VERIFICA        := FALSE;


IF vTIPO = 'Q' THEN

   ORDER_BY:=' ORDER BY F.FUNOMFUNC';
   P_OBS:='PAGAMENTO DE QUINZENA';
--   P_OBS:='PAGAMENTO DA 2ºPARCELA DO DECIMO TERCEIRO';
   V_BODYMAIL := V_BODYMAIL ||P_OBS||', ';
   P_DESPESA := '0251';
   SELECT_:='SELECT
                   L.LOCODLOT LOTACAO           ,
                   L.LODESCLOT DESCLOT          ,
                   F.FUMATFUNC MATRICULA        ,
                   F.FUNOMFUNC FUNCIONARIO      ,
                   F.FUNOMFUNC FAVORECEIDO      ,
                   (SELECT A.AFVALOR
                    FROM FPW.ATRIBFUN A
                    WHERE F.FUCODEMP = A.AFCODEMP
                    AND F.FUMATFUNC = A.AFMATFUNC
                    AND A.AFCODATRIB = 8) ATRIB ,
                   --E.EVDESRESUM EVENTO          ,
                   M.VAVALEVENT VALOR           ,
                   M.VADTREFER REFERENCIA       ,
                   M.VACODFOLHA FOLHA           ,
                   FO.FODESCOMPL DESFOLHA       ,
                   F.FUCODBCOPG BANCO           ,
                   F.FUCODAGEPG AGENCIA         ,
                   F.FUCCORPAG CONTA
            FROM
                   FPW.VALMES M                 ,
                   FPW.FUNCIONA F               ,
                   FPW.FOLHAS FO                ,
                   FPW.EVENTOS E                ,
                   FPW.LOTACOES L
           WHERE
                   M.VACODEMP = FO.FOCODEMP
             AND   M.VACODFOLHA = FO.FOCODFOLHA
             AND   M.VACODEMP = F.FUCODEMP
             AND   M.VAMATFUNC = F.FUMATFUNC
             AND   F.FUCODEMP = L.LOCODEMP
             AND   F.FUCODLOT = L.LOCODLOT
             AND   M.VACODFOLHA IN (6,13) -- ADIANTAMENTO
             AND   M.VACODEVENT = E.EVCODEVENT
             AND   M.VACODEVENT = ' || vacodevent || '
             AND   ''SIM'' = (SELECT A.AFVALOR
                            FROM FPW.ATRIBFUN A
                            WHERE F.FUCODEMP = A.AFCODEMP
                            AND F.FUMATFUNC = A.AFMATFUNC
                            AND A.AFCODATRIB = 8)
             AND  SUBSTR(LPAD(F.FUCODLOT,9,''0''),1,3) IN (''010'')
             AND  F.FUMATFUNC NOT IN (''900000002'',''900000003'',''900000001'',''460000065'',''010005092'',''010005388'',''030003713'',''030007789'',''030002463'',''010005084'',''010005084'',''030009107'')
           /*AND   F.FUMATFUNC IN*/';


 ELSIF vTIPO = 'F' THEN
   
   ORDER_BY:=' ORDER BY F.FUNOMFUNC';
 P_OBS:='PAGAMENTO DA FOLHA';
 --P_OBS:='PAGAMENTO DA 1º PARCELA DO DECIMO TERCEIRO';
-- P_OBS:= 'PAGAMENTO PLR';
-- P_OBS:='PAGAMENTO DA PARCELA FINAL DE 13 SALARIO';
   V_BODYMAIL := V_BODYMAIL ||P_OBS||', ';
   P_DESPESA := '0252';
   SELECT_:='SELECT
                   LPAD(F.FUCODLOT,9,''0'') LOTACAO,
                   L.LODESCLOT DESCLOT,
                   F.FUMATFUNC MATRICULA,
                   F.FUNOMFUNC FUNCIONARIO,
                   F.FUNOMFUNC FAVORECEIDO,
                   (SELECT A.AFVALOR
                    FROM FPW.ATRIBFUN A
                    WHERE F.FUCODEMP = A.AFCODEMP
                    AND F.FUMATFUNC = A.AFMATFUNC
                    AND A.AFCODATRIB = 8) ATRIB,
                   --E.EVDESRESUM EVENTO,
                   M.VAVALEVENT VALOR,
                   M.VADTREFER REFERENCIA,
                   M.VACODFOLHA FOLHA,
                   FO.FODESCOMPL DESFOLHA,
                   F.FUCODBCOPG BANCO,
                   F.FUCODAGEPG AGENCIA,
                   F.FUCCORPAG CONTA
            FROM
                   FPW.VALMES M,
                   FPW.FUNCIONA F,
                   FPW.FOLHAS FO,
                   FPW.EVENTOS E,
                   FPW.LOTACOES L
           WHERE
                   M.VACODEMP = FO.FOCODEMP
             AND   M.VACODFOLHA = FO.FOCODFOLHA
             AND   M.VACODEMP = F.FUCODEMP
             AND   M.VAMATFUNC = F.FUMATFUNC
             AND   F.FUCODEMP = L.LOCODEMP
             AND   F.FUCODLOT = L.LOCODLOT
             AND   M.VACODFOLHA in (1) -- PAGAMENTO
             AND   M.VACODEVENT = E.EVCODEVENT
             AND   M.VACODEVENT = ' || vacodevent || '
             AND   ''SIM'' = (SELECT A.AFVALOR
                              FROM FPW.ATRIBFUN A
                              WHERE F.FUCODEMP = A.AFCODEMP
                              AND F.FUMATFUNC = A.AFMATFUNC
                              AND A.AFCODATRIB = 8)
             AND F.FUCODBCOPG IN (2,399)
             AND F.FUMATFUNC NOT IN (30004749)
             AND ( SUBSTR(LPAD(F.FUCODLOT,9,''0''),1,3) IN (''010'',''365'',''045'',''157'',''160'')
               or f.fucodcargo = 64  )';

--             AND F.FUMATFUNC IN (''10006080'',''10006093'')';

ELSIF vTIPO = 'L' THEN
   
   ORDER_BY:=' ORDER BY F.FUNOMFUNC';
   P_OBS:='PAGAMENTO DE PLR';
   V_BODYMAIL := V_BODYMAIL ||P_OBS||', ';
   P_DESPESA := '0254';
   SELECT_:='SELECT
                   F.FUCODLOT LOTACAO,
                   L.LODESCLOT DESCLOT,
                   F.FUMATFUNC MATRICULA,
                   F.FUNOMFUNC FUNCIONARIO,
                   F.FUNOMFUNC FAVORECEIDO,
                   (SELECT A.AFVALOR
                    FROM FPW.ATRIBFUN A
                    WHERE F.FUCODEMP = A.AFCODEMP
                    AND F.FUMATFUNC = A.AFMATFUNC
                    AND A.AFCODATRIB = 8) ATRIB,
                   --E.EVDESRESUM EVENTO,
                   M.VAVALEVENT VALOR,
                   M.VADTREFER REFERENCIA,
                   M.VACODFOLHA FOLHA,
                   FO.FODESCOMPL DESFOLHA,
                   F.FUCODBCOPG BANCO,
                   F.FUCODAGEPG AGENCIA,
                   F.FUCCORPAG CONTA
            FROM
                   FPW.VALMES M,
                   FPW.FUNCIONA F,
                   FPW.FOLHAS FO,
                   FPW.EVENTOS E,
                   FPW.LOTACOES L
           WHERE
                   M.VACODEMP = FO.FOCODEMP
             AND   M.VACODFOLHA = FO.FOCODFOLHA
             AND   M.VACODEMP = F.FUCODEMP
             AND   M.VAMATFUNC = F.FUMATFUNC
             AND   F.FUCODEMP = L.LOCODEMP
             AND   F.FUCODLOT = L.LOCODLOT
             AND   M.VACODFOLHA = 9 -- PLR
             AND   M.VACODEVENT = E.EVCODEVENT
             AND   M.VACODEVENT = ' || vacodevent || '
             AND   ''SIM'' = (SELECT A.AFVALOR
                              FROM FPW.ATRIBFUN A
                              WHERE F.FUCODEMP = A.AFCODEMP
                              AND F.FUMATFUNC = A.AFMATFUNC
                              AND A.AFCODATRIB = 8)
             AND  SUBSTR(LPAD(F.FUCODLOT,9,''0''),1,3) IN (''010'',''024'')
             AND  F.FUMATFUNC NOT IN (''900000002'',''900000003'',''900000001'')';



ELSIF vTIPO = 'E' THEN
   
   ORDER_BY:=' ORDER BY F.FUNOMFUNC';
   P_OBS:='PAGAMENTO DE ESTAGIARIOS';
   V_BODYMAIL := V_BODYMAIL ||P_OBS||', ';
   P_DESPESA := '0255';
   SELECT_:='SELECT
                   F.FUCODLOT LOTACAO,
                   L.LODESCLOT DESCLOT,
                   F.FUMATFUNC MATRICULA,
                   F.FUNOMFUNC FUNCIONARIO,
                   F.FUNOMFUNC FAVORECEIDO,
                   (SELECT A.AFVALOR
                    FROM FPW.ATRIBFUN A
                    WHERE F.FUCODEMP = A.AFCODEMP
                    AND F.FUMATFUNC = A.AFMATFUNC
                    AND A.AFCODATRIB = 8) ATRIB,
                   --E.EVDESRESUM EVENTO,
                   M.VAVALEVENT VALOR,
                   M.VADTREFER REFERENCIA,
                   M.VACODFOLHA FOLHA,
                   FO.FODESCOMPL DESFOLHA,
                   F.FUCODBCOPG BANCO,
                   F.FUCODAGEPG AGENCIA,
                   F.FUCCORPAG CONTA
            FROM
                   FPW.VALMES M,
                   FPW.FUNCIONA F,
                   FPW.FOLHAS FO,
                   FPW.EVENTOS E,
                   FPW.LOTACOES L
           WHERE
                   M.VACODEMP = FO.FOCODEMP
             AND   M.VACODFOLHA = FO.FOCODFOLHA
             AND   M.VACODEMP = F.FUCODEMP
             AND   M.VAMATFUNC = F.FUMATFUNC
             AND   F.FUCODEMP = L.LOCODEMP
             AND   F.FUCODLOT = L.LOCODLOT
             AND   M.VACODFOLHA = 12 -- ESTAGIARIOS  /*(12-Estagiarios mensal, 13-Estagiarios quinzenal)*/
             AND   M.VACODEVENT = E.EVCODEVENT
             AND   M.VACODEVENT = ' || vacodevent || '
             AND   ''SIM'' = (SELECT A.AFVALOR
                              FROM FPW.ATRIBFUN A
                              WHERE F.FUCODEMP = A.AFCODEMP
                              AND F.FUMATFUNC = A.AFMATFUNC
                              AND A.AFCODATRIB = 8)
             AND  SUBSTR(LPAD(F.FUCODLOT,9,''0''),1,3) IN (''010'')';


 ELSIF vTIPO = 'P' THEN
  --AND M.VACODFOLHA NOT IN (5,2)
   P_OBS:='PAGAMENTO DE PENSÃO, PARCELA FINAL DECIMO TERCEIRO SALARIO';
   V_BODYMAIL := V_BODYMAIL ||P_OBS||', ';
   ORDER_BY:=' ORDER BY P.PENOMPENSI';
   P_DESPESA := '0253';
   

  SELECT_:='SELECT  DISTINCT             
                    L.LOCODLOT LOTACAO,
                    L.LODESCLOT DESCLOT,
                    F.FUMATFUNC MATRICULA,
                    F.FUNOMFUNC FUNCIONARIO,
                    P.PENOMPENSI FAVORECIDO,
                    (SELECT A.AFVALOR
                    FROM FPW.ATRIBFUN A
                    WHERE F.FUCODEMP = A.AFCODEMP
                    AND F.FUMATFUNC = A.AFMATFUNC
                    AND A.AFCODATRIB = 8) ATRIB,
                    --E.EVDESRESUM EVENTO,
                    M.VAVALEVENT VALOR,
                    M.VADTREFER REFERENCIA,
                    M.VACODFOLHA FOLHA,
                    FO.FODESCOMPL DESFOLHA,
                    F.FUCODBCOPG BANCO,
                    F.FUCODAGEPG AGENCIA,
                    F.FUCCORPAG CONTA
               FROM FPW.VALANO M,  -- EVENTOS DOS FUNCIONARIOS DO MES
                    V_FPW_PENSIONSITAS P, -- VIEW COM OS BENEFICIARIOS DE PENSAO
                    FPW.FUNCIONA F, -- TABELA DE FUNCIONARIOS
                    FPW.FOLHAS FO, -- TABELA DE TIPOS DE FOLHA DE PAGAMENTO
                    FPW.EVENTOS E, -- TABELA DE EVENTOS
                    FPW.LOTACOES L, -- TABELA DE LOTAC?ES
                    FPW.SITUACAO SI
              WHERE M.VACODEMP = P.PECODEMP
              AND M.VAMATFUNC = P.PEMATFUNC
              AND M.VACODEVENT = P.EVENTO
              AND M.VACODEMP = FO.FOCODEMP
              AND M.VACODFOLHA = FO.FOCODFOLHA
              AND M.VACODEMP = F.FUCODEMP
              AND M.VAMATFUNC = F.FUMATFUNC
              AND F.FUCODEMP = L.LOCODEMP
              AND F.FUCODLOT = L.LOCODLOT
             -- AND ( nvl(P.PECODBANCO,2) IN (2,399)
           --     OR nvl(P.PECPFPENSI,0) = 0 )
              AND M.VACODFOLHA IN (1)
           --   AND M.VACODFOLHA IN (3) 
              AND M.VACODEVENT = E.EVCODEVENT
              AND SI.STCODSITU = F.FUCODSITU
              AND SI.STTIPOSITU <> ''R''     
             AND F.FUMATFUNC IN '||FN_GETMATRICULAS(P_MATRICULAS);
                   
/*open P_CURSOR for

SELECT tt.cpg_titulos_numtit,
       tt.cpg_titulos_vltotal
LT_CPG_TITULOS TT
WHERE TT.GLB_FORNECEDOR_CGCCPF = '61139432000177'
and tt.cpg_titulos_dtemissao= (select max(t.cpg_titulos_dtemissao)
                               from t_cpg_titulos t
                               where t.glb_fornecedor_cgccpf='61139432000177'); */         


              
ELSIF vTIPO = 'A' THEN
ORDER_BY:=' ORDER BY F.FUNOMFUNC';
P_OBS:='PAGAMENTO DA 1º PARCELA DO DECIMO TERCEIRO';
   V_BODYMAIL := V_BODYMAIL ||P_OBS||', ';
   P_DESPESA := '0256';
   
   
   SELECT_:='SELECT
                   LPAD(F.FUCODLOT,9,''0'') LOTACAO,
                   L.LODESCLOT DESCLOT,
                   F.FUMATFUNC MATRICULA,
                   F.FUNOMFUNC FUNCIONARIO,
                   F.FUNOMFUNC FAVORECEIDO,
                   (SELECT A.AFVALOR
                    FROM FPW.ATRIBFUN A
                    WHERE F.FUCODEMP = A.AFCODEMP
                    AND F.FUMATFUNC = A.AFMATFUNC
                    AND A.AFCODATRIB = 8) ATRIB,
                   --E.EVDESRESUM EVENTO,
                   M.VAVALEVENT VALOR,
                   M.VADTREFER REFERENCIA,
                   M.VACODFOLHA FOLHA,
                   FO.FODESCOMPL DESFOLHA,
                   F.FUCODBCOPG BANCO,
                   F.FUCODAGEPG AGENCIA,
                   F.FUCCORPAG CONTA
            FROM
                   FPW.VALMES M,
                   FPW.FUNCIONA F,
                   FPW.FOLHAS FO,
                   FPW.EVENTOS E,
                   FPW.LOTACOES L
           WHERE
                   M.VACODEMP = FO.FOCODEMP
             AND   M.VACODFOLHA = FO.FOCODFOLHA
             AND   M.VACODEMP = F.FUCODEMP
             AND   M.VAMATFUNC = F.FUMATFUNC
             AND   F.FUCODEMP = L.LOCODEMP
             AND   F.FUCODLOT = L.LOCODLOT
             AND   M.VACODFOLHA = 4 -- pr 13 ADIANTAMENTO
             AND   M.VACODEVENT = E.EVCODEVENT
             AND   M.VACODEVENT = ' || vacodevent || '
             AND   ''SIM'' = (SELECT A.AFVALOR
                              FROM FPW.ATRIBFUN A
                              WHERE F.FUCODEMP = A.AFCODEMP
                              AND F.FUMATFUNC = A.AFMATFUNC
                              AND A.AFCODATRIB = 8)
             AND F.FUCODBCOPG IN (2,399)
             AND F.FUMATFUNC NOT IN (30004749)
             AND ( SUBSTR(LPAD(F.FUCODLOT,9,''0''),1,3) IN (''010'',''365'',''045'',''157'')
               or f.fucodcargo = 64  )';
               
               
ELSIF vTIPO = 'D' THEN
ORDER_BY:=' ORDER BY F.FUNOMFUNC';
P_OBS:='PAGAMENTO DA PARCELA FINAL DE 13 SALARIO';
V_BODYMAIL := V_BODYMAIL ||P_OBS||', ';
P_DESPESA := '0257';
SELECT_:='SELECT
                   LPAD(F.FUCODLOT,9,''0'') LOTACAO,
                   L.LODESCLOT DESCLOT,
                   F.FUMATFUNC MATRICULA,
                   F.FUNOMFUNC FUNCIONARIO,
                   F.FUNOMFUNC FAVORECEIDO,
                   (SELECT A.AFVALOR
                    FROM FPW.ATRIBFUN A
                    WHERE F.FUCODEMP = A.AFCODEMP
                    AND F.FUMATFUNC = A.AFMATFUNC
                    AND A.AFCODATRIB = 8) ATRIB,
                   --E.EVDESRESUM EVENTO,
                   M.VAVALEVENT VALOR,
                   M.VADTREFER REFERENCIA,
                   M.VACODFOLHA FOLHA,
                   FO.FODESCOMPL DESFOLHA,
                   F.FUCODBCOPG BANCO,
                   F.FUCODAGEPG AGENCIA,
                   F.FUCCORPAG CONTA
            FROM
                   FPW.VALMES M,
                   FPW.FUNCIONA F,
                   FPW.FOLHAS FO,
                   FPW.EVENTOS E,
                   FPW.LOTACOES L
           WHERE
                   M.VACODEMP = FO.FOCODEMP
             AND   M.VACODFOLHA = FO.FOCODFOLHA
             AND   M.VACODEMP = F.FUCODEMP
             AND   M.VAMATFUNC = F.FUMATFUNC
             AND   F.FUCODEMP = L.LOCODEMP
             AND   F.FUCODLOT = L.LOCODLOT
             AND   M.VACODFOLHA = 3 -- pr 13 PARCELA FINAL
             AND   M.VACODEVENT = E.EVCODEVENT
             AND   M.VACODEVENT = ' || vacodevent || '  
             AND   ''SIM'' = (SELECT A.AFVALOR
                              FROM FPW.ATRIBFUN A
                              WHERE F.FUCODEMP = A.AFCODEMP
                              AND F.FUMATFUNC = A.AFMATFUNC
                              AND A.AFCODATRIB = 8)
             AND F.FUCODBCOPG IN (2,399)
             AND F.FUMATFUNC NOT IN (30004749)
             AND ( SUBSTR(LPAD(F.FUCODLOT,9,''0''),1,3) IN (''010'',''365'',''045'',''157'')
               or f.fucodcargo = 64  )';
               
END IF;


           Insert into dropme(a,l) values('PensãoDP',SELECT_|| MESREFERENCIA_||ORDER_BY);
           commit;


      
       CURSOR_ := DBMS_SQL.OPEN_CURSOR;
       DBMS_SQL.PARSE(CURSOR_, SELECT_ /*|| MATRICULA_*/|| MESREFERENCIA_||ORDER_BY, DBMS_SQL.V7);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 1,  LOTACAO,     300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 2,  DESCLOT,     300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 3,  MATRICULA,   300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 4,  FUNCIONARIO, 300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 5,  FAVORECEIDO, 300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 6,  ATRIB,       300);
       --DBMS_SQL.DEFINE_COLUMN(CURSOR_, 7,  EVENTO,      300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 7,  VALOR,       300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 8,  REFERENCIA,  300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 9, FOLHA,       300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 10, DESFOLHA,    300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 11, BANCO,       300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 12, AGENCIA,     300);
       DBMS_SQL.DEFINE_COLUMN(CURSOR_, 13, CONTA,       300);
       TEMP_    := DBMS_SQL.EXECUTE(CURSOR_);
 --      P_CURSOR := DBMS_SQL.EXECUTE(CURSOR_); 


      P_VLRTOTAL:='0';
      P_PARCELAS:='0';
      P_PQTDE   :='0';

      BEGIN
             SELECT TT.CPG_TITULOS_NUMTIT
               INTO P_TITDROP
               FROM T_CPG_TITULOS TT
              WHERE TT.GLB_FORNECEDOR_CGCCPF = '61139432000177'
                AND TT.CPG_TITULOS_PREVISAO = 'S'
                AND TO_CHAR(TT.CPG_TITULOS_COMPETENCIA, 'YYYYMM') = P_MESREF;
      EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    P_TITDROP := '999999';
      END;

  -- P_PQTDE:=P_PQTDE+1;
   LOOP
      IF DBMS_SQL.FETCH_ROWS(CURSOR_) = 0 THEN
      EXIT;
      ELSE



      IF P_PQTDE = 0 THEN
      IF P_TITDROP <> '999999' THEN

                DELETE FROM T_CPG_TITPARCELAS TIT
                 WHERE TIT.GLB_FORNECEDOR_CGCCPF = '61139432000177'
                   AND TIT.CPG_TITULOS_NUMTIT = P_TITDROP;


                DELETE FROM T_CPG_TITULOS TT
                 WHERE TT.GLB_FORNECEDOR_CGCCPF = '61139432000177'
                   AND TT.CPG_TITULOS_NUMTIT = P_TITDROP;

      END IF;
      END IF;


      IF P_PQTDE = 0 THEN

       SELECT NVL(MAX(TT.CPG_TITULOS_NUMTIT),0) + 1
       INTO P_TITULO
       FROM T_CPG_TITULOS TT
       WHERE TT.GLB_FORNECEDOR_CGCCPF = '61139432000177';

      V_BODYMAIL := V_BODYMAIL ||'NUMERO:   '||P_TITULO||'.'||CHR(13)||CHR(10)||CHR(13)||'COM PARCELAS PARA OS SEGUINTES FAVORECIDOS:';
      V_BODYMAIL := V_BODYMAIL ||CHR(10)||CHR(13)||RPAD('FAVORECIDO',50)||RPAD('VALOR',5);
      V_BODYMAIL := V_BODYMAIL ||CHR(10)||CHR(13)||CHR(09);

      INSERT INTO T_CPG_TITULOS(CPG_TITULOS_NUMTIT       ,
                                CPG_TITULOS_DTEMISSAO    ,
                                GLB_FORNECEDOR_CGCCPF    ,
                                CPG_DESPESAS_CODIGO      ,
                                GLB_CENTROCUSTO_CUSTO    ,
                                GLB_ROTA_CODIGOEMPRESA   ,
                                CPG_TITULOS_VLTOTAL      ,
                                USU_USUARIO_CODIGO       ,
                                CPG_TITULOS_FLAGTPLANC   ,
                                CPG_TITULOS_OBS          ,
                                CPG_SITUACAO_CODIGO      ,
                                GLB_ROTA_CODIGO_OPERACAO ,
                                CAX_OPERACAO_CODIGO      ,
                                GLB_CENTROCUSTO_RESPONS  ,
                                CPG_TITULOS_SALDOATUAL   ,
                                CPG_TITULOS_NUMPARC      ,
                                CPG_TITULOS_VLRPARC      ,
                                CPG_TITULOS_DIAUTIL      ,
                                CPG_TITULOS_MENSAL       ,
                                CPG_TITULOS_DIARIO       ,
                                CPG_TITULOS_PREVISAO     ,
                                CPG_TITULOS_EMCHEQUE     ,
                                CPG_TITULOS_DESCFORNEC   ,
                                CPG_TITULOS_DTEMISSAOFAT ,
                                CPG_TITULOS_TIPOTITULO   ,
                                CPG_TIPOPREVISAO_CODIGO  ,
                                CPG_TPPAGTO_CODIGO       ,
                                GLB_ROTA_CODIGOCCUSTO    ,
                                GLB_ROTA_CODIGOCRESP     ,
                                CPG_TITULOS_DTCADASTRO   ,
                                CPG_TITULOS_COMPETENCIA  ,
                                CPG_TITULOS_DATACTB      ,
                                CPG_TITULOS_CREDITO)
                         VALUES(
                                P_TITULO                 ,
                                TRUNC(SYSDATE)           ,
                               '61139432000177'          ,
                                P_DESPESA                ,
                                '1100'                   ,
                                '021'                    ,
                                P_VLRTOTAL               ,
                                'JSANTOS'                ,
                                ''                       ,
                                P_OBS                    ,
                                '0000'                   ,
                                '021'                    ,
                                '2064'                   ,
                                '1100'                   ,
                                P_VLRTOTAL               ,
                                P_PARCELAS               ,
                                ''                       ,
                                ''                       ,
                                ''                       ,
                                ''                       ,
                                'S'                      ,
                                'S'                      ,
                                ''                       ,
                                P_VENCIMENTO             ,
                                'N'                      ,
                                ''                       ,
                                '003'                    ,
                                ''                       ,
                                ''                       ,
                                TRUNC(SYSDATE)             ,
                                '01'||'/'||SUBSTR(P_MESREF, 5, 2)||'/'||SUBSTR(P_MESREF, 0, 4),
                                ''                       ,
                                '');
                                COMMIT;
          END IF;


          P_PQTDE:=P_PQTDE+1;
          P_VERIFICA:= TRUE;

          DBMS_SQL.COLUMN_VALUE(CURSOR_, 1,  LOTACAO);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 2,  DESCLOT);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 3,  MATRICULA);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 4,  FUNCIONARIO);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 5,  FAVORECEIDO);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 6,  ATRIB);
--          DBMS_SQL.COLUMN_VALUE(CURSOR_, 7,  EVENTO);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 7,  VALOR);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 8,  REFERENCIA);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 9, FOLHA);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 10, DESFOLHA);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 11, BANCO);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 12, AGENCIA);
          DBMS_SQL.COLUMN_VALUE(CURSOR_, 13, CONTA);



          INSERT INTO T_CPG_TITPARCELAS( CPG_TITULOS_NUMTIT    ,
                                     CPG_TITPARCELAS_PARCELA   ,
                                     CPG_SITUACAO_CODIGO       ,
                                     GLB_ROTA_CODIGOEMPRESA    ,
                                     GLB_FORNECEDOR_CGCCPF     ,
                                     CPG_TIPOMOVIMENTO_CODIGO  ,
                                     CPG_TITPARCELAS_PAGFINAL  ,
                                     CPG_TITPARCELAS_VALOR     ,
                                     CPG_TITPARCELAS_DTVENC    ,
                                     CPG_TITPARCELAS_OBS       ,
                                     CPG_TITPARCELAS_IMPCHEQUE   ,
                                     CPG_TIPOMOVIMENTO_DESCRICAO ,
                                     CPG_TITPARCELAS_PREVISAO    ,
                                     CPG_TITPARCELAS_DTVENCCALC  ,
                                     CPG_TPPAGTO_CODIGO          ,
                                     CPG_TITPARCELAS_SALDO       ,
                                     CPG_TITPARCELAS_PAGO        ,
                                     CPG_TITPARCELAS_ACRESCIMO   ,
                                     CPG_TITPARCELAS_DESCONTO    ,
                                     CPG_TITPARCELAS_NOMINAL)
                            VALUES
                                     (
                                     P_TITULO                    ,
                                     P_PQTDE                     ,
                                     '0000'                      ,
                                     '021'                       ,
                                     '61139432000177'            ,
                                     '0000'                      ,
                                     ''                          ,
                                     TRIM(VALOR)                 ,
                                     P_VENCIMENTO                ,
                                     ''                          ,
                                     'N'                         ,
                                     ''                          ,
                                     ''                          ,
                                     ''                          ,
                                     '003'                       ,
                                     TRIM(VALOR)                 ,
                                     ''                          ,
                                     ''                          ,
                                     ''                          ,
                                     FAVORECEIDO);

         P_VLRTOTAL:=P_VLRTOTAL+TO_NUMBER(VALOR);
 
         VALOR := TO_CHAR(TO_NUMBER(VALOR), '9990.00');
         V_BODYMAIL := V_BODYMAIL||RPAD(FAVORECEIDO,50)||CHR(9)||LPAD(TRIM(VALOR),15)||';'||CHR(13)||CHR(10);
         
         COMMIT;
      END IF;
   END LOOP;
   

     IF P_VERIFICA = TRUE THEN

             UPDATE T_CPG_TITULOS TT
               SET TT.CPG_TITULOS_NUMPARC = P_PQTDE,
                   TT.CPG_TITULOS_VLTOTAL = P_VLRTOTAL,
                   TT.CPG_TITULOS_SALDOATUAL = P_VLRTOTAL
             WHERE TT.CPG_TITULOS_NUMTIT = P_TITULO AND
                   TT.GLB_FORNECEDOR_CGCCPF = '61139432000177';
             COMMIT;
                   
        /*P_RELACAO_N_V:= UTL_FILE.FOPEN('/ORACLE_UTL_FILE_DIR', 'RELACAO_NOME_VALOR.TXT', 'W');
             
        UTL_FILE.PUT_LINE(P_RELACAO_N_V, V_BODYMAIL);
        
         UTL_FILE.FCLOSE(P_RELACAO_N_V);*/
        
       V_BODYMAIL := V_BODYMAIL||CHR(13)||CHR(10)||'VALOR TOTAL DAS PARCELAS:                  '|| P_VLRTOTAL;
        
       --SP_ENVIAEMAIL_ORACLE(P_OBS,V_BODYMAIL,'tdv.operacao@dellavolpe.com.br','tdv.ctspagar@dellavolpe.com.br','tdv.gerenciadp@dellavolpe.com.br','tdv.ti02@dellavolpe.com.br');
       
        
             /*SP_ENVIAMAIL('SEQ',
                          'TDV.TI02@DELLAVOLPE.COM.BR;  TDV.CTSPAGAR@DELLAVOLPE.COM.BR; TDV.DPSP@DELLAVOLPE.COM.BR',
                          'INCLUS?O DE TITULOS',
                          'RELAC?O DE BENEFICIADOS E VALORES EN ANEXO.');*/
/*OPEN P_CURSOR FOR 
                        
SELECT tt.cpg_titulos_numtit,
       tt.cpg_titulos_vltotal
FROM T_CPG_TITULOS TT,
     FPW.SITUACAO SI
WHERE TT.GLB_FORNECEDOR_CGCCPF = '61139432000177'
AND SI.STTIPOSITU <> 'R'
and tt.cpg_titulos_dtemissao= (select max(t.cpg_titulos_dtemissao)
                               from t_cpg_titulos t
                               where t.glb_fornecedor_cgccpf='61139432000177');   */                       
                          
OPEN P_CURSOR FOR

sELECT  tp.cpg_titparcelas_nominal NOMINAL,
        tp.cpg_titulos_numtit TITULO,
        tp.cpg_titparcelas_valor VALOR
FROM t_cpg_titparcelas tp
WHERE Tp.GLB_FORNECEDOR_CGCCPF = '61139432000177'
  AND TP.CPG_TITULOS_NUMTIT    = P_TITULO;
  
--and tp.cpg_titparcelas_dtvenc  = (select max (t.cpg_titparcelas_dtvenc)
--                               from t_cpg_titparcelas t
--                               where t.glb_fornecedor_cgccpf='61139432000177');


   /*   SELECT TT.Cpg_Titparcelas_Nominal NOME,
             tt.cpg_titparcelas_valor VALOR,
             ff.fumatfunc          MATRICULA
        FROM T_CPG_TITPARCELAS TT,
             fpw.funciona   ff,
             FPW.SITUACAO SI
        WHERE TT.CPG_TITULOS_NUMTIT    = P_TITULO
        AND TT.CPG_TITPARCELAS_NOMINAL = FF.FUNOMFUNC
         AND TT.GLB_FORNECEDOR_CGCCPF  = '61139432000177'
         and ff.fucodsitu              = si.stcodsitu
         AND SI.STTIPOSITU             <> 'R'; */
                           
     ELSIF P_VERIFICA = FALSE THEN

             DELETE FROM T_CPG_TITULOS TT
             WHERE TT.CPG_TITULOS_NUMTIT =P_TITULO AND
                   TT.GLB_FORNECEDOR_CGCCPF = '61139432000177';
             COMMIT;

     END IF;

     DBMS_SQL.CLOSE_CURSOR(CURSOR_);
     
     IF P_TP_PROCESS <> 'F' THEN
        
        DELETE FROM T_CPG_TITPARCELAS TIT
         WHERE TIT.GLB_FORNECEDOR_CGCCPF = '61139432000177'
           AND TIT.CPG_TITULOS_NUMTIT = P_TITULO;


        DELETE FROM T_CPG_TITULOS TT
         WHERE TT.GLB_FORNECEDOR_CGCCPF = '61139432000177'
           AND TT.CPG_TITULOS_NUMTIT = P_TITULO;
                   
     END IF;
       
END SP_CPG_GERATITULOS_PARCELAS;

END PKG_DP_FOLHA;
/
