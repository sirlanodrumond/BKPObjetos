create or replace package pkg_arm_NotaPesagem is

  -- Author  : Fabiano 'Goes
  -- Created : 06/09/2013 14:48:19
  
  -- Public type declarations
  TYPE T_CURSOR IS REF CURSOR; 
  

  cAmbiente  CHAR(3) := 'TDV';
  
  
  -- Public constant declarations
  Empty CONSTANT CHAR(1) := '';
    
  --Constants para serem utilizados como retorno para as procedures.
  Status_Normal  CONSTANT CHAR(1) := 'N'; -- Normal
  Status_Erro    CONSTANT CHAR(1) := 'E'; -- Erro
  Status_Warning CONSTANT CHAR(1) := 'W'; -- Warning
   
  --BOOLEANO COMO CHAR
  BOOLEAN_SIM CONSTANT CHAR(1) := 'S';
  BOOLEAN_NAO CONSTANT CHAR(1) := 'N'; 
  
  FUNCTION FN_NOTACARREG(P_NOTA      IN T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                         P_REMETENTE IN T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE) RETURN CHAR;
                         
  FUNCTION FN_NOTACARREG2(P_NOTA     IN T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                         P_REMETENTE IN T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                         P_CHAVE     IN T_ARM_NOTA.ARM_NOTA_CHAVENFE%Type) RETURN CHAR; 
                         
  Procedure Sp_ValidaLeitura_NF2(pNotaNumero    In  t_arm_nota.arm_nota_numero%type,
                                pNotaCGCCPFRem In  t_arm_nota.glb_cliente_cgccpfremetente%Type,
                                pChaveNFE      In  t_arm_nota.arm_nota_chavenfe%Type,
                                pStatus  Out Char,
                                pMessage Out Varchar2);                                                     
                                     
  procedure sp_GetNota(pNotaNum  in  varchar2,
                       pNotaCnpj in  varchar2,
                       pCursor   Out Types.cursorType,
                       pStatus   out char,
                       pMessage  out varchar2);   
                       
  Procedure Sp_Insert_NotaPesagem(pXmlIn   In  Varchar2,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2);     
                                  
  Procedure Sp_Insert_NotaPesagemItem(pXmlIn In Varchar2,
                                      pStatus Out Char,
                                      pMessage Out Varchar2);      
                                      
  Procedure Sp_ValidaLeitura_NF(pXmlIn   In  Varchar2,
                                pStatus  Out Char,
                                pMessage Out Varchar2);
                                
  Procedure Sp_Delete_NotaPesagemItem(pXmlIn In Varchar2,
                                      pStatus Out Char,
                                      pMessage Out Varchar2);      
                                      
  Procedure Sp_Update_FinalizaNotaPesagem(pXmlIn   In  Varchar2,
                                          pStatus  Out Char,
                                          pMessage Out Varchar2);   

Procedure Sp_Update_FinalizaNotaPesagem2(pUsuario In  Varchar2,
                                         pArmNotaNumero In Varchar2,
                                         pRemetente In Varchar2,
                                         pChaveNfe In Varchar2,
                                         pPeso In Varchar2,
                                         pStatus  Out Char,
                                         pMessage Out Varchar2);
                                          
  Procedure Sp_Get_DadosFilialBalanca(pRota    In  Varchar2,
                                      pArmazem In  Varchar2,
                                      pDescricaoRota In  Varchar2,
                                      pCursor  out Types.cursorType,
                                      pStatus  Out Char,
                                      pMessage Out Varchar2);   
                                       
  Procedure Sp_insert_FilialBalanca(pXmlIn   In  Varchar2,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2);
  
  Procedure Sp_Arm_InserePessagemSorter(pJSVolumes in clob,
                                        pStatus    out char,
                                        pMessage   out clob);   
  
  procedure Sp_Update_NotaPesagem(pNotaPesagem In t_Arm_Notapesagem%RowType);                                                                                                                                                                                                                                   

  Procedure Sp_AtualizaPesoSorter(pNotaSequencia in tdvadm.t_arm_nota.arm_nota_sequencia%type);
 
end pkg_arm_NotaPesagem;

 
/
create or replace package body pkg_arm_NotaPesagem is

  vClienteInformado tdvadm.t_arm_coleta.arm_coleta_dtclienteinformado%type;
  vPesoInf          varchar2(100);

  FUNCTION FN_NOTACARREG(P_NOTA      IN T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                         P_REMETENTE IN T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE)
    RETURN CHAR 
  IS
    V_COUNT NUMBER;
    V_DATA  VARCHAR2(10);
  BEGIN
   /**************************************************************************************** 
   * ROTINA           : FN_NOTACARREG                                                      *
   * PROGRAMA         : Peso Balanca                                                       *
   * ANALISTA         : Fabiano Goes                                                       *
   * DESENVOLVEDOR    : Fabiano Goes                                                       *
   * DATA DE CRIACAO  : 09/10/2009                                                         *
   * BANCO            : ORACLE-TDP                                                         *
   * EXECUTADO POR    : prj_pesobalanca.exe                                                *
   * ALIMENTA         :                                                                    * 
   * FUNCINALIDADE    : verificar se uma nota ja pertence a um carregamento.               *
   * ATUALIZA         :                                                                    *
   * PARTICULARIDADES :                                                                    *          
   * PARAM. OBRIGAT.  : P_NOTA = numero dad nota, P_REMETENTE = CNPJ DO REMETENTE DA NOTA. *
   *****************************************************************************************/

    V_COUNT := 0;
    BEGIN
   
        SELECT USU_PERFIL_PARAT
          INTO V_DATA
          FROM T_USU_PERFIL P
         WHERE P.USU_PERFIL_CODIGO = 'DATENOTA'    ;
        
        IF V_DATA IS NULL THEN
           V_DATA := '30';
        END IF;
      
        SELECT COUNT(*)
          INTO V_COUNT
          FROM T_ARM_NOTA            N01,
               T_ARM_EMBALAGEM       EM1,
               T_ARM_CARGADET        DET1,
               T_ARM_CARREGAMENTODET CDET1
         WHERE N01.ARM_NOTA_NUMERO = DET1.ARM_NOTA_NUMERO
           AND N01.ARM_NOTA_SEQUENCIA = DET1.ARM_NOTA_SEQUENCIA
           AND EM1.ARM_EMBALAGEM_NUMERO = DET1.ARM_EMBALAGEM_NUMERO
           AND EM1.ARM_EMBALAGEM_FLAG = DET1.ARM_EMBALAGEM_FLAG
           AND EM1.ARM_EMBALAGEM_SEQUENCIA = DET1.ARM_EMBALAGEM_SEQUENCIA
           AND EM1.ARM_EMBALAGEM_NUMERO = CDET1.ARM_EMBALAGEM_NUMERO
           AND EM1.ARM_EMBALAGEM_FLAG = CDET1.ARM_EMBALAGEM_FLAG
           AND EM1.ARM_EMBALAGEM_SEQUENCIA = CDET1.ARM_EMBALAGEM_SEQUENCIA
           AND EM1.ARM_CARREGAMENTO_CODIGO = CDET1.ARM_CARREGAMENTO_CODIGO
              --AND N01.ARM_NOTA_NUMERO = NO.ARM_NOTA_NUMERO
              --AND N01.ARM_NOTA_SEQUENCIA = NO.ARM_NOTA_SEQUENCIA
           AND N01.ARM_NOTA_NUMERO = P_NOTA            
           AND N01.GLB_CLIENTE_CGCCPFREMETENTE = P_REMETENTE
           AND N01.ARM_NOTA_DTINCLUSAO >= (SYSDATE-V_DATA)
           AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_COUNT := 0;
    END;

    RETURN V_COUNT;
  END FN_NOTACARREG;
  
  FUNCTION FN_NOTACARREG2(P_NOTA     IN T_ARM_NOTA.ARM_NOTA_NUMERO%TYPE,
                          P_REMETENTE IN T_ARM_NOTA.GLB_CLIENTE_CGCCPFREMETENTE%TYPE,
                          P_CHAVE     IN T_ARM_NOTA.ARM_NOTA_CHAVENFE%Type)
    RETURN CHAR 
  IS
    V_COUNT NUMBER;
    V_DATA  VARCHAR2(10);
  BEGIN
   /**************************************************************************************** 
   * ROTINA           : FN_NOTACARREG                                                      *
   * PROGRAMA         : Peso Balanca                                                       *
   * ANALISTA         : Fabiano Goes                                                       *
   * DESENVOLVEDOR    : Fabiano Goes                                                       *
   * DATA DE CRIACAO  : 09/10/2009                                                         *
   * BANCO            : ORACLE-TDP                                                         *
   * EXECUTADO POR    : prj_pesobalanca.exe                                                *
   * ALIMENTA         :                                                                    * 
   * FUNCINALIDADE    : verificar se uma nota ja pertence a um carregamento.               *
   * ATUALIZA         :                                                                    *
   * PARTICULARIDADES :                                                                    *          
   * PARAM. OBRIGAT.  : P_NOTA = numero dad nota, P_REMETENTE = CNPJ DO REMETENTE DA NOTA. *
   *****************************************************************************************/

    V_COUNT := 0;
    BEGIN
   
        SELECT USU_PERFIL_PARAT
          INTO V_DATA
          FROM T_USU_PERFIL P
         WHERE P.USU_PERFIL_CODIGO = 'DATENOTA'    ;
        
        IF V_DATA IS NULL THEN
           V_DATA := '30';
        END IF;
      
        SELECT COUNT(*)
          INTO V_COUNT
          FROM T_ARM_NOTA            N01,
               T_ARM_EMBALAGEM       EM1,
               T_ARM_CARGADET        DET1,
               T_ARM_CARREGAMENTODET CDET1
         WHERE N01.ARM_NOTA_NUMERO = DET1.ARM_NOTA_NUMERO
           AND N01.ARM_NOTA_SEQUENCIA = DET1.ARM_NOTA_SEQUENCIA
           AND EM1.ARM_EMBALAGEM_NUMERO = DET1.ARM_EMBALAGEM_NUMERO
           AND EM1.ARM_EMBALAGEM_FLAG = DET1.ARM_EMBALAGEM_FLAG
           AND EM1.ARM_EMBALAGEM_SEQUENCIA = DET1.ARM_EMBALAGEM_SEQUENCIA
           AND EM1.ARM_EMBALAGEM_NUMERO = CDET1.ARM_EMBALAGEM_NUMERO
           AND EM1.ARM_EMBALAGEM_FLAG = CDET1.ARM_EMBALAGEM_FLAG
           AND EM1.ARM_EMBALAGEM_SEQUENCIA = CDET1.ARM_EMBALAGEM_SEQUENCIA
           AND EM1.ARM_CARREGAMENTO_CODIGO = CDET1.ARM_CARREGAMENTO_CODIGO
              --AND N01.ARM_NOTA_NUMERO = NO.ARM_NOTA_NUMERO
              --AND N01.ARM_NOTA_SEQUENCIA = NO.ARM_NOTA_SEQUENCIA
           AND N01.ARM_NOTA_NUMERO = P_NOTA            
           AND N01.GLB_CLIENTE_CGCCPFREMETENTE = P_REMETENTE
           -- Inclusao da Chave!!!
           AND N01.ARM_NOTA_CHAVENFE = P_CHAVE
           AND N01.ARM_NOTA_DTINCLUSAO >= (SYSDATE-V_DATA)
           AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_COUNT := 0;
    END;

    RETURN V_COUNT;
  END FN_NOTACARREG2;                               

  Procedure Sp_ValidaLeitura_NF2(pNotaNumero    In  t_arm_nota.arm_nota_numero%type,
                                pNotaCGCCPFRem In  t_arm_nota.glb_cliente_cgccpfremetente%Type,
                                pChaveNFE      In  t_arm_nota.arm_nota_chavenfe%Type,
                                pStatus  Out Char,
                                pMessage Out Varchar2)
  As
  vCountNFCarreg Integer;
  vCountNFCtrc Integer;
  vCount Integer;  
  Begin
     Begin
         SELECT Count(*)      
           INTO vCount                                                          
           FROM T_ARM_NOTA N                                                       
          WHERE N.ARM_NOTA_NUMERO = pNotaNumero                                 
            AND LPAD(N.GLB_CLIENTE_CGCCPFREMETENTE, 14) = pNotaCGCCPFRem
            AND NVL(N.ARM_NOTA_CHAVENFE,'x') = nvl(pChaveNFE,'x');
         
         if vCount <= 0 then
           pStatus := 'E';
           pMessage := 'Nota: '||pNotaNumero||Chr(13)||
                       'CNPJ: '||pNotaCGCCPFRem||Chr(13)||
                       'Chave de Acesso: '||pChaveNFE;
           Return;
         End if;   
         
         pStatus := 'N';
/*   Retirado em 05/06/2014 so n?o podera ser pesao se n?o tiver CTe
         SELECT Count(*)      
           INTO vCountNFCarreg                                                          
           FROM T_ARM_NOTA N,                                                                
                T_ARM_CARGADET CD,                                                           
                T_ARM_EMBALAGEM E                                                            
          WHERE N.ARM_NOTA_NUMERO = pNotaNumero                                 
            AND LPAD(N.GLB_CLIENTE_CGCCPFREMETENTE, 14) = pNotaCGCCPFRem    
            AND N.GLB_CLIENTE_CGCCPFREMETENTE = CD.GLB_CLIENTE_CGCCPFREMETENTE               
            AND N.ARM_NOTA_CHAVENFE = pChaveNFE                          
            AND N.ARM_NOTA_NUMERO = CD.ARM_NOTA_NUMERO                                       
            AND E.ARM_EMBALAGEM_NUMERO = CD.ARM_EMBALAGEM_NUMERO                             
            AND E.ARM_EMBALAGEM_FLAG = CD.ARM_EMBALAGEM_FLAG                                 
            AND E.ARM_EMBALAGEM_SEQUENCIA = CD.ARM_EMBALAGEM_SEQUENCIA                       
            AND E.ARM_CARREGAMENTO_CODIGO IS NULL;                                            
            --And n.arm_nota_dtinclusao =  (Select Max(nf_max.arm_nota_dtinclusao)             
            --                                From t_arm_nota nf_max                           
            --                                where nf_max.arm_nota_numero             = n.arm_nota_numero
            --                                  and nf_max.glb_cliente_cgccpfremetente = n.glb_cliente_cgccpfremetente);


          If vCountNFCarreg = 0 then             
             pStatus := 'W';
             pMessage := ' - Nota encontra-se com Carregamento!';
          End if;           
*/          
          SELECT COUNT(*) 
            INTO vCountNFCtrc
            FROM T_ARM_NOTA N
           WHERE 0=0
             AND N.ARM_NOTA_NUMERO = pNotaNumero                 
             AND LPAD(N.GLB_CLIENTE_CGCCPFREMETENTE, 14) = pNotaCGCCPFRem
             AND NVL(N.ARM_NOTA_CHAVENFE,'x') = nvl(pChaveNFE,'x')
             AND N.CON_CONHECIMENTO_CODIGO IS NULL; 
           
          If vCountNFCtrc = 0 then 
             pStatus := 'E';
             pMessage := pMessage || CHR(13) ||' - Nota possui CTRC.';
          End if;  
          
          if pStatus = 'N' then
              pMessage := 'Nota OK';
          end if;                
                                            
     Exception
       When Others Then
         pStatus := Status_Erro;
         pMessage := sqlerrm;
     End;
  End Sp_ValidaLeitura_NF2;                               

  Function Fn_XmlToT_Arm_Nota_Pesagem(pXmlIn In Varchar2) return t_Arm_Notapesagem%RowType
  As
  vResult t_Arm_Notapesagem%RowType;
  Begin
     insert into tdvadm.t_glb_sql s
     values (pXmlIn,sysdate,'Fn_XmlToT_Arm_Nota_Pesagem','TESTE BALANCA');
     commit;
        -- Colocamos o replace para trocar as virulas por ponto
      -- nas casas decimais.
      Select extractvalue(Value(V), 'Input/NotaNumero'),
             extractvalue(Value(V), 'Input/NotaCGCCPFRemetente'),
             extractvalue(Value(V), 'Input/NotaQtdeVolume'),
             extractvalue(Value(V), 'Input/UsuarioImprimiu'),
             replace(extractvalue(Value(V), 'Input/NotaPeso'),',','.'),
             replace(extractvalue(Value(V), 'Input/QtdeVolume'),',','.'),
             replace(extractvalue(Value(V), 'Input/PesoTotal'),',','.'),
             extractvalue(Value(V), 'Input/DataImprimiu'),
             extractvalue(Value(V), 'Input/Codigo'),
             extractvalue(Value(V), 'Input/NotaSequencia'),
             extractvalue(Value(V), 'Input/NotaChaveNFE'),
             -- Thiago - 26/09/2019 - Inclusão de campos(ChaveEtiquetaSAP, OrigemNota) para tabela SAP
             extractvalue(Value(V), 'Input/ChaveEtiquetaSAP'),
             extractvalue(Value(V), 'Input/OrigemNota')
            into vResult.Arm_Nota_Numero,
                 vResult.Glb_Cliente_Cgccpfremetente,
                 vResult.Arm_Nota_Qtdvolume,
                 vResult.Usu_Usuario_Codigoimprimiu,
                 vResult.Arm_Nota_Peso,
                 vResult.Arm_Notapesagem_Qtdvolume,
                 vResult.Arm_Notapesagem_Pesototal,
                 vResult.Arm_Notapesagem_Dtimprimiu,                 
                 vResult.Arm_Notapesagem_Cod,
                 vResult.Arm_Nota_Sequencia,
                 vResult.Arm_Nota_Chavenfe,
                 -- Thiago - 26/09/2019 - Inclusão de campos(ChaveEtiquetaSAP, OrigemNota) para tabela SAP
                 vResult.Arm_Notapesagem_Chave_Etiqueta,
                 vResult.Arm_Notapesagem_Origem_Nota
           From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;     
      Return vResult;
  End Fn_XmlToT_Arm_Nota_Pesagem;
  
  Function Fn_XmlToT_Arm_Nota_PesagemItem(pXmlIn In Varchar2) return t_Arm_Notapesagemitem%RowType
  As
  vResult tdvadm.t_Arm_Notapesagemitem%RowType;
  Begin
    /* Modelo
<Parametros>
   <Input>
      <NotaPesagem>
         <NotaNumero>15466</NotaNumero>
         <NotaCGCCPFRemetente>02036483000290</NotaCGCCPFRemetente>
         <NotaSequencia>2988658</NotaSequencia>
         <NotaChaveNFE>41180402036483000290550030000154661657195099</NotaChaveNFE>
      </NotaPesagem>
      <ItemPeso>0.76</ItemPeso>
      <UsuarioPesou>jsantos</UsuarioPesou>
      <ItemSeq>0</ItemSeq>
      -- Ver a origem nota Sirlano 18/11/2021
      <OrigemNota></OrigemNota>
      <ItemAltura></ItemAltura>
      <ItemLargura></ItemLargura>
      <ItemComprimento></ItemComprimento>
   </Input>
</Parametros>
    */
     insert into tdvadm.t_glb_sql s
     values (pXmlIn,sysdate,'Fn_XmlToT_Arm_Nota_PesagemItem','TESTE BALANCA');
     commit;
 
      Select extractvalue(Value(V), 'Input/NotaPesagem/NotaNumero'),
             extractvalue(Value(V), 'Input/NotaPesagem/NotaCGCCPFRemetente'),
             extractvalue(Value(V), 'Input/NotaPesagem/NotaSequencia'),
             extractvalue(Value(V), 'Input/NotaPesagem/NotaChaveNFE'),
             extractvalue(Value(V), 'Input/ItemPeso'),             
             extractvalue(Value(V), 'Input/UsuarioPesou'),
             extractvalue(Value(V), 'Input/ItemSeq'),
             -- extractvalue(Value(V), 'Input/OrigemNota'), -- Ver a origem nota Sirlano 18/11/2021
             extractvalue(Value(V), 'Input/ItemAltura'),
             extractvalue(Value(V), 'Input/ItemLargura'),
             extractvalue(Value(V), 'Input/ItemComprimento')   
            into vResult.Arm_Notapessagem_Numero,
                 vResult.Glb_Cliente_Cgccpfremetente,
                 vResult.Arm_Nota_Sequencia,
                 vResult.Arm_Nota_Chavenfe,
                 vResult.Arm_Notapesagemitem_Peso,
                 vResult.Usu_Usuario_Codigopesou,
                 vResult.Arm_Notapesagemitem_Seq,
                 -- Ver a origem nota Sirlano 18/11/2021
                 vResult.arm_notapesagemitem_altura,
                 vResult.arm_notapesagemitem_largura, 
                 vResult.arm_notapesagemitem_comprimento 
           From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/Parametros/Input '))) V;
      Return vResult;
  End Fn_XmlToT_Arm_Nota_PesagemItem;     
  
  Function Fn_ExistNotaPesagem(pNotaNumero    In t_Arm_Notapesagem.Arm_Nota_Numero%Type,
                               pNotaCGCCPFRem In t_Arm_Notapesagem.Glb_Cliente_Cgccpfremetente%Type,
                               pserie         In tdvadm.t_arm_nota.arm_nota_serie%type,
                               pChave         In tdvadm.t_arm_nota.arm_nota_chavenfe%type)
 Return Char
  As
  vCount Integer;
  plistaparams        glbadm.pkg_listas.tlistausuparametros;
  vAMBIENTE_SAP     tdvadm.t_usu_perfil.usu_perfil_parat%type;
  Begin         
      if cAmbiente = 'SAP' then
        
         SELECT COUNT(*) 
           Into vCount
           FROM T_ARM_NOTAPESAGEM_SAP p
           WHERE p.arm_nota_chavenfe = pChave;
  --            and ARM_NOTA_NUMERO = pNotaNumero                   
  --            AND GLB_CLIENTE_CGCCPFREMETENTE = pNotaCGCCPFRem
      else  
                                            
        SELECT COUNT(*) 
           Into vCount
           FROM T_ARM_NOTAPESAGEM p
           WHERE p.arm_nota_chavenfe = pChave;
  --            and ARM_NOTA_NUMERO = pNotaNumero                   
  --            AND GLB_CLIENTE_CGCCPFREMETENTE = pNotaCGCCPFRem
      end if;
      If vCount > 0 then
        Return 'S';
      else
        Return 'N';
      End if;            
  End Fn_ExistNotaPesagem;                                
  
  procedure sp_GetNota(pNotaNum  in  varchar2, -- '037964'      
                       pNotaCnpj in  varchar2, -- '01402461000153' 
                       pCursor   Out Types.cursorType,
                       pStatus   out char,
                       pMessage  out varchar2)
  is
  begin
    pStatus  := pkg_arm_NotaPesagem.Status_Normal;
    pMessage := pkg_arm_NotaPesagem.Empty;
    
    begin
      Open pCursor For
        SELECT N.ARM_NOTA_NUMERO NOTA,                                                      
               LPAD(N.GLB_CLIENTE_CGCCPFREMETENTE, 14) CNPJ,                                
               N.ARM_NOTA_QTDVOLUME VOLUME,                                                 
               N.ARM_NOTA_PESO PESO,                                                        
               C.GLB_CLIENTE_RAZAOSOCIAL REMETENTE
          FROM T_ARM_NOTA N,                                                                
               T_GLB_CLIENTE C                                                              
         WHERE N.ARM_NOTA_NUMERO = pNotaNum                              
           AND LPAD(N.GLB_CLIENTE_CGCCPFREMETENTE, 14) = pNotaCnpj    
           AND RPAD(N.GLB_CLIENTE_CGCCPFREMETENTE, 20) = C.GLB_CLIENTE_CGCCPFCODIGO   
           
           AND N.ARM_NOTA_SEQUENCIA = (SELECT MAX(NN.ARM_NOTA_SEQUENCIA)
                                          FROM T_ARM_NOTA NN
                                          WHERE NN.ARM_NOTA_NUMERO = N.ARM_NOTA_NUMERO
                                            AND LPAD(NN.GLB_CLIENTE_CGCCPFREMETENTE, 14) = LPAD(N.GLB_CLIENTE_CGCCPFREMETENTE, 14));
          
       --Insert Into Dropme d (x,a) values('Nota: ' || pNotaNum || ', CNPJ: ' || pNotaCnpj, 'NOTA_PESAGEMCOMMIT;  
         
    
    exception when others then
      pStatus  := pkg_arm_NotaPesagem.Status_Erro;
      pMessage := 'Erro: ao localizar Nota - '||sqlerrm;    
    end;
    
  end sp_GetNota;                                                

  Procedure Sp_AtualizaPeso_T_Arm_Nota(pNotaPesagem In t_Arm_NotapesagemItem%RowType)
  As
  Begin
       -- Thiago - 26/09/2019 - Inclusão de lógica para ler Origem da nota
       -- Sirlano - 18/11/2021 -  Ajustando para a variavel
       if nvl(cAmbiente,'TDV') = 'SAP' then
         
           UPDATE tdvadm.T_ARM_NOTA N
              SET N.ARM_NOTA_PESOBALANCA = ( SELECT SUM(Nvl(I.ARM_NOTAPESAGEMITEM_PESO,0))                        
                                                FROM tdvadm.T_ARM_NOTAPESAGEMITEM_SAP I                                
                                                --WHERE I.ARM_NOTAPESAGEM_NUMERO =      
                                                --  AND I.GLB_CLIENTE_CGCCPFREMETENTE =    
                                                Where 0 = 0
                                                  and i.arm_notapesagemitem_seq = pNotaPesagem.arm_nota_sequencia)
    --                                              and I.ARM_NOTA_CHAVENFE = pNotaPesagem.Arm_Nota_Chavenfe )
              WHERE 0=0
                --And N.ARM_NOTA_NUMERO = pNotaPesagem.Arm_Nota_Numero
                --And N.GLB_CLIENTE_CGCCPFREMETENTE = pNotaPesagem.Glb_Cliente_Cgccpfremetente;
                and n.arm_nota_sequencia = pNotaPesagem.arm_nota_sequencia;
    --            And N.ARM_NOTA_CHAVENFE = pNotaPesagem.Arm_Nota_Chavenfe;
       else
          
          UPDATE tdvadm.T_ARM_NOTA N
              SET N.ARM_NOTA_PESOBALANCA = ( SELECT SUM(Nvl(I.ARM_NOTAPESAGEMITEM_PESO,0))                        
                                                FROM tdvadm.T_ARM_NOTAPESAGEMITEM I                                
                                                --WHERE I.ARM_NOTAPESAGEM_NUMERO =      
                                                --  AND I.GLB_CLIENTE_CGCCPFREMETENTE =    
                                                Where 0 = 0
                                                  and i.arm_nota_sequencia = pNotaPesagem.arm_nota_sequencia)
    --                                              and I.ARM_NOTA_CHAVENFE = pNotaPesagem.Arm_Nota_Chavenfe )
              WHERE 0=0
                --And N.ARM_NOTA_NUMERO = pNotaPesagem.Arm_Nota_Numero
                --And N.GLB_CLIENTE_CGCCPFREMETENTE = pNotaPesagem.Glb_Cliente_Cgccpfremetente;
                and n.arm_nota_sequencia = pNotaPesagem.arm_nota_sequencia;
    --            And N.ARM_NOTA_CHAVENFE = pNotaPesagem.Arm_Nota_Chavenfe;
       end if;
  End Sp_AtualizaPeso_T_Arm_Nota;

  procedure Sp_Update_NotaPesagem(pNotaPesagem In t_Arm_Notapesagem%RowType)
  As
  vPesoTotal t_Arm_Notapesagem.Arm_Notapesagem_Pesototal%Type;
  Begin
      cAmbiente := 'TDV';       
      -- Thiago - 26/09/2019 - Inclusão de lógica para ler Origem da nota    
      IF nvl(pNotaPesagem.Arm_Notapesagem_Origem_Nota,'TDV') = 'SAP' Then
          cAmbiente := 'SAP';
          
          SELECT SUM(I.ARM_NOTAPESAGEMITEM_PESO)
              Into vPesoTotal
              FROM tdvadm.T_ARM_NOTAPESAGEMITEM_SAP I  
              Where 0 = 0
                and i.arm_nota_numero = pNotaPesagem.Arm_Nota_Numero
                and I.GLB_CLIENTE_CGCCPFREMETENTE = pNotaPesagem.Glb_Cliente_Cgccpfremetente;
              
          UPDATE T_ARM_NOTAPESAGEM_SAP i
           SET ARM_NOTAPESAGEM_QTDVOLUME    = pNotaPesagem.Arm_Notapesagem_Qtdvolume,    
               ARM_NOTAPESAGEM_PESOTOTAL    = vPesoTotal               
          WHERE 0 = 0
            and i.arm_nota_numero = pNotaPesagem.arm_nota_numero
            and i.glb_cliente_cgccpfremetente = pNotaPesagem.Glb_Cliente_Cgccpfremetente;
      ElsIf nvl(pNotaPesagem.Arm_Notapesagem_Origem_Nota,'TDV') = 'TDV' Then
          cAmbiente := 'TDV';
          
          SELECT SUM(I.ARM_NOTAPESAGEMITEM_PESO)
              Into vPesoTotal
              FROM tdvadm.T_ARM_NOTAPESAGEMITEM I                                
              --WHERE I.ARM_NOTAPESAGEM_NUMERO =        
              --  AND I.GLB_CLIENTE_CGCCPFREMETENTE =   
              Where 0 = 0
                and i.arm_nota_sequencia = pNotaPesagem.arm_nota_sequencia
                and I.ARM_NOTA_CHAVENFE = pNotaPesagem.Arm_Nota_Chavenfe;
              
          UPDATE T_ARM_NOTAPESAGEM i
           SET --ARM_NOTA_QTDVOLUME           = pNotaPesagem.Arm_Nota_Qtdvolume,       
               --USU_USUARIO_CODIGOIMPRIMIU   = pNotaPesagem.Usu_Usuario_Codigoimprimiu,   
               --ARM_NOTA_PESO                = pNotaPesagem.Arm_Nota_Peso,                             
               ARM_NOTAPESAGEM_QTDVOLUME    = pNotaPesagem.Arm_Notapesagem_Qtdvolume,    
               ARM_NOTAPESAGEM_PESOTOTAL    = vPesoTotal
               --ARM_NOTA_CHAVENFE            = pNotaPesagem.Arm_Nota_Chavenfe,              
               --ARM_NOTA_SEQUENCIA           = pNotaPesagem.Arm_Nota_Sequencia       
          WHERE 0 = 0
            and i.arm_nota_sequencia = pNotaPesagem.arm_nota_sequencia;

          --  and ARM_NOTA_CHAVENFE  = pNotaPesagem.Arm_Nota_Chavenfe
          -- ARM_NOTA_NUMERO = pNotaPesagem.Arm_Nota_Numero                           
          --  AND GLB_CLIENTE_CGCCPFREMETENTE = pNotaPesagem.Glb_Cliente_Cgccpfremetente;           
          --  AND ARM_NOTA_SEQUENCIA = ' + IntToStr(Self.NotaSequencia)+'                      
          --  AND ARM_NOTA_CHAVENFE  = ' + QuotedStr(Self.ChaveNFE)+'  
      end If;        
  End Sp_Update_NotaPesagem;

  Procedure Sp_Insert_NotaPesagem(pXmlIn   In  Varchar2,
                                  pStatus  Out Char,
                                  pMessage Out Varchar2)
   /* modelo
<Parametros>
   <Input>
      <NotaNumero>15466</NotaNumero>
      <NotaCGCCPFRemetente>02036483000290</NotaCGCCPFRemetente>
      <NotaQtdeVolume>2</NotaQtdeVolume>
      <UsuarioImprimiu></UsuarioImprimiu>
      <NotaPeso>287</NotaPeso>
      <QtdeVolume>2</QtdeVolume>
      <PesoTotal>287</PesoTotal>
      <DataImprimiu>30/12/1899</DataImprimiu>
      <Codigo>-1</Codigo>
      <NotaSequencia>2988658</NotaSequencia>
      <NotaChaveNFE>41180402036483000290550030000154661657195099</NotaChaveNFE>
      <Items>
      </Items>
   </Input>
</Parametros>

  */
  As


  vAuxiliar  integer;
  vSerieNota tdvadm.t_arm_nota.arm_nota_serie%type;
  vNotaPesagem t_Arm_Notapesagem%RowType;
  Begin

    vClienteInformado := null;
    cAmbiente := 'TDV';
    Begin

       insert into tdvadm.t_glb_sql s
       values (pXmlIn,sysdate,'Sp_Insert_NotaPesagem','TESTE BALANCA');
       commit;
       vNotaPesagem := Fn_XmlToT_Arm_Nota_Pesagem(pXmlIn);

--       raise_application_error(-20011,pXmlIn);
    Exception
      When Others Then
--        insert into t_glb_sql values(pXmlIn, sysdate, 'pesagem','pesagem');
        pStatus := Status_Erro;
        pMessage := 'Erro ao Converter XmlIn: '||sqlerrm;
        Return;
    End;
    
        Begin
           select en.DT_GRAVACAO,
--                  replace(tdvadm.fn_querystring(en.PAYLOAD_ENVIO,'"RealWeight"',':',','),'"','')
                  JSON_VALUE(en.PAYLOAD_ENVIO, '$.RealWeight')
              into vClienteInformado,
                   vPesoInf
           from tdvadm.v_eventos_nimbi en,
                tdvadm.t_arm_nota an
           where en.arm_coleta_ncompra = an.arm_coleta_ncompra
              and en.arm_coleta_ciclo = an.arm_coleta_ciclo
              and an.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
              and an.glb_cliente_cgccpfremetente = trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente)
              and nvl(an.arm_nota_chavenfe,'x') = nvl(vNotaPesagem.Arm_Nota_Chavenfe,'x')
             and en.COD_EVENTO = 3;
        Exception
          When NO_DATA_FOUND Then
              vPesoInf := '0';
              vClienteInformado := null;
            
        End;

         If ( vClienteInformado Is not Null )   Then
            
            If sysdate >= to_date('11/01/2021','dd/mm/yyyy') Then
            pStatus := Status_Erro;
            pMessage := 'Cliente 1 Informado em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Nota não pode ser mais pesada';          
            return;             
            End If;              
         
         End If; 
    
    
    Begin
        -- **************** Thiago - 10/10/2019 **************** --
        -- Verifica a origem para gravar na tabela correta       --
        -- alteração para integração SAP                         --
        if vNotaPesagem.Arm_Notapesagem_Origem_Nota = 'SAP' then
            cAmbiente := 'SAP';
            Select count(*)
              into vAuxiliar
            from tdvadm.t_arm_notapesagem_sap np
            where np.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
              and np.glb_cliente_cgccpfremetente = trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente)
              and nvl(np.arm_nota_chavenfe,'x') = nvl(vNotaPesagem.Arm_Nota_Chavenfe,'x')
              and np.arm_notapesagem_status = 'NL';
        else
            cAmbiente := 'TDV';
            Select count(*)
              into vAuxiliar
            from tdvadm.t_arm_notapesagem np
            where np.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
              and np.glb_cliente_cgccpfremetente = trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente)
              and nvl(np.arm_nota_chavenfe,'x') = nvl(vNotaPesagem.Arm_Nota_Chavenfe,'x')
              and np.arm_notapesagem_status = 'NL';
        end if;
        If vAuxiliar = 0 Then
           if Fn_ExistNotaPesagem(vNotaPesagem.Arm_Nota_Numero, 
                                  vNotaPesagem.Glb_Cliente_Cgccpfremetente,
                                  vSerieNota,
                                  vNotaPesagem.Arm_Nota_Chavenfe) = BOOLEAN_SIM then
                Sp_Update_NotaPesagem(vNotaPesagem);
                pMessage := 'Nota Pesagem atualizado com sucesso!'; 
            Else          
                -- **************** Thiago - 10/10/2019 **************** --
                -- Verifica a origem para gravar na tabela correta       --
                -- alteração para integração SAP                         --
                if vNotaPesagem.Arm_Notapesagem_Origem_Nota = 'SAP' then
                   cAmbiente := 'SAP';  
                   Insert Into tdvadm.t_arm_notapesagem_sap 
                   values (vNotaPesagem.arm_nota_numero,
                           vNotaPesagem.glb_cliente_cgccpfremetente,
                           vNotaPesagem.arm_nota_serie,
                           vNotaPesagem.arm_nota_qtdvolume,
                           vNotaPesagem.usu_usuario_codigoimprimiu,
                           vNotaPesagem.arm_nota_peso,
                           vNotaPesagem.arm_notapesagem_qtdvolume,
                           vNotaPesagem.arm_notapesagem_pesototal,
                           vNotaPesagem.arm_notapesagem_dtimprimiu,
                           vNotaPesagem.arm_nota_sequencia,
                           vNotaPesagem.arm_nota_chavenfe,
                           vNotaPesagem.arm_notapesagem_status,
                           vNotaPesagem.arm_notapesagem_obs,
                           vNotaPesagem.chave_etiqueta,
                           vNotaPesagem.arm_notapesagem_chave_etiqueta,
                           vNotaPesagem.arm_notapesagem_origem_nota,
                           vNotaPesagem.arm_notapesagem_flagenvia,
                           vNotaPesagem.arm_notapesagem_dtenvia,
                           vNotaPesagem.arm_notapesagem_jsonenvio,
                           vNotaPesagem.arm_notapesagem_jsonretorno,
                           vNotaPesagem.arm_notapesagem_idsap,
                           vNotaPesagem.arm_notapesagem_statusretorno,
                           vNotaPesagem.arm_notapesagem_cod,
                           vNotaPesagem.arm_notapesagem_finalizou,
                           vNotaPesagem.arm_notapesagem_dtfinalizou);
                   pMessage := 'Nota Pesagem inserido com sucesso!';          
                   
                Else
                   cAmbiente := 'TDV';
                   
                   Insert Into tdvadm.t_arm_notapesagem values vNotaPesagem;
                   pMessage := 'Nota Pesagem inserido com sucesso!';  
                   
                end if;
            end if;        
        Else
           pMessage := 'Nota Liberada de Pesagem. Pesagem nao inserida!';          
        end If;
        pStatus := Status_Normal;      
        Commit;
    Exception
      When Others Then
        Rollback;
        pStatus := Status_Erro;
        pMessage := sqlerrm;        
    End;  
    
  End Sp_Insert_NotaPesagem;

  Procedure Sp_Insert_NotaPesagemItem(pXmlIn In Varchar2,
                                      pStatus Out Char,
                                      pMessage Out Varchar2)
    /* modelo

<Parametros>
   <Input>
      <NotaPesagem>
         <NotaNumero>15466</NotaNumero>
         <NotaCGCCPFRemetente>02036483000290</NotaCGCCPFRemetente>
         <NotaSequencia>2988658</NotaSequencia>
         <NotaChaveNFE>41180402036483000290550030000154661657195099</NotaChaveNFE>
      </NotaPesagem>
      <ItemPeso>287</ItemPeso>
      <UsuarioPesou>jsantos</UsuarioPesou>
      <ItemSeq>0</ItemSeq>
      <ItemAltura></ItemAltura>
      <ItemLargura></ItemLargura>
      <ItemComprimento></ItemComprimento>
   </Input>
</Parametros>

    
    */
  As
  vNotaPesagemItem t_arm_notapesagemitem%RowType;
  vClienteInformado tdvadm.t_arm_coleta.arm_coleta_dtclienteinformado%type;
  vArmazemTexto     varchar2(100);
  vArmazem          varchar2(100);
  vTexto            varchar2(2000);
  vCliente          varchar2(100);
  vASN              varchar2(100);
  vPesoAnterior     number;
  vPesoAtual        number;
  vAuxiliar         varchar2(100);
  vPesoInf          varchar2(100);
  vJanela           varchar2(50);
  vIncoterms        tdvadm.t_col_asn.col_asn_incoterms%type;
  vContador         number;
  vColeta           tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo            tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
  vContrato         tdvadm.t_slf_contrato.slf_contrato_codigo%type;
  vExistePesItem    integer;
 
  Begin
       insert into tdvadm.t_glb_sql s
       values (pXmlIn,sysdate,'Sp_Insert_NotaPesagemItem','TESTE BALANCA');
       commit;

       vNotaPesagemItem := Fn_XmlToT_Arm_Nota_PesagemItem(pXmlIn); 
       vPesoAtual := 0;
       select  sum(pi.arm_notapesagemitem_peso)
         into vPesoAtual
       from tdvadm.t_arm_notapesagemitem pi
       where pi.arm_nota_sequencia = vNotaPesagemItem.Arm_Nota_Sequencia;

       vPesoAtual :=  nvl(vPesoAtual,0) + nvl(vNotaPesagemItem.Arm_Notapesagemitem_Peso,0);

        Begin 
        select x.arm_armazem_codigo, 
               co.arm_coleta_dtclienteinformado,
               a.arm_armazem_codigo || '-' || a.arm_armazem_descricao,
               x.arm_nota_pesobalanca,
               x.slf_contrato_codigo || '-' || cl.glb_cliente_razaosocial Cliente,
               co.xml_coleta_numero,
               to_char(jc.arm_janelacons_dtinicio,'dd/mm/yyyy hh24:mi:ss') || ' as ' || to_char(jc.arm_janelacons_dtfim,'dd/mm/yyyy hh24:mi:ss'),
               (select distinct asn.incoterms
                from tdvadm.v_col_asnaceite asn
                where asn.ASNNUMERO = co.xml_coleta_numero ) incoterms,
                co.arm_coleta_ncompra,
                co.arm_coleta_ciclo
          into vArmazem, 
               vClienteInformado,
               vArmazemTexto,
               vPesoAnterior,
               vCliente,
               vASN,
               vJanela,
               vIncoterms,
               vColeta,
               vCiclo
        from tdvadm.t_arm_nota x,
             tdvadm.t_arm_coleta co,
             tdvadm.t_arm_armazem a,
             tdvadm.t_glb_cliente cl,
             tdvadm.t_arm_janelacons jc
        where x.arm_nota_numero = vNotaPesagemItem.Arm_Notapessagem_Numero
        and x.glb_cliente_cgccpfremetente = trim(vNotaPesagemItem.Glb_Cliente_Cgccpfremetente)
        and nvl(x.arm_nota_chavenfe,'x') = nvl(vNotaPesagemItem.Arm_Nota_Chavenfe,nvl(x.arm_nota_chavenfe,'x'))
        and x.arm_coleta_ncompra = co.arm_coleta_ncompra
        and x.arm_coleta_ciclo = co.arm_coleta_ciclo
        and x.arm_armazem_codigo = a.arm_armazem_codigo
        and x.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo (+)
        and x.arm_janelacons_sequencia = jc.arm_janelacons_sequencia (+);


        Begin
           select en.DT_GRAVACAO,
--                  replace(tdvadm.fn_querystring(en.PAYLOAD_ENVIO,'"RealWeight"',':',','),'"','')
                  JSON_VALUE(en.PAYLOAD_ENVIO, '$.RealWeight')
              into vClienteInformado,
                   vPesoInf
           from tdvadm.v_eventos_nimbi en
           where en.NM_ASN = vASN
             and en.COD_EVENTO = 3;
        Exception
          When NO_DATA_FOUND Then
              vPesoInf := '0';
            
        End;

        If vClienteInformado Is null Then
        Begin  
             
          select co.arm_coleta_dtfechamento
            into vClienteInformado
          from tdvadm.t_arm_coleta co
          where co.arm_coleta_ncompra = vColeta
            and co.arm_coleta_ciclo = vCiclo;
             
        exception
            When NO_DATA_FOUND Then
               vClienteInformado := null;
        End;  
        End If;
         If ( vClienteInformado Is not Null ) and ( vASN is not null ) and ( vPesoInf is not null )  Then
            
            vPesoAnterior := to_number(vPesoInf);
            

            If vPesoAnterior <> vPesoAtual Then
            
                vTexto := 'Nota ' || vNotaPesagemItem.Arm_Notapessagem_Numero || chr(10) ||
                          'CNPJ ' || vNotaPesagemItem.Glb_Cliente_Cgccpfremetente || chr(10) ||
                          'Armazem ' || vArmazemTexto || chr(10) ||
                          'Usuario ' || vNotaPesagemItem.Usu_Usuario_Codigopesou || chr(10) ||
                          'Contrato ' || vCliente || chr(10) ||
                          'ASN ' || vASN || chr(10) ||
                          'INCOTERMS ' || vIncoterms || chr(10) ||
                          'Cli Informado ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Peso ' || vAuxiliar /*tdvadm.f_mascara_valor(vPesoAnterior,10,0)*/ || chr(10) || 
                          'Dt Pesagem '   || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')           || ' Peso ' || tdvadm.f_mascara_valor(vPesoAtual,10,0)    || chr(10) ||
                          'Janela ' || vJanela || chr(10) || chr(10) ||
                          'Sp_Insert_NotaPesagemItem';

/* Sirlano Retirado em 13/05/2021
                           wservice.pkg_glb_email.SP_ENVIAEMAIL('PESAGEM DE NOTA APOS CLIENTE INFORMADO',
                                                                 vTexto,
                                                                'aut-e@dellav/olpe.com.br',
                                                                'sirlano.drumond@dellavolpe.com.br');
*/
            End If;
            If sysdate >= to_date('11/01/2021','dd/mm/yyyy') Then
            pStatus := Status_Erro;
            pMessage := 'Cliente 2 Informado em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Nota não pode ser mais pesada';          
            return;             
            End If;
         
         End If; 
        
        exception
          When NO_DATA_FOUND Then
             raise_application_error(-20004,chr(10) || vNotaPesagemItem.Usu_Usuario_Codigopesou || chr(10) || vNotaPesagemItem.Arm_Notapessagem_Numero || chr(10) || vNotaPesagemItem.Glb_Cliente_Cgccpfremetente || chr(10) );
          End;  




      Begin
           Sp_ValidaLeitura_NF2(vNotaPesagemItem.Arm_Notapessagem_Numero,
                                vNotaPesagemItem.Glb_Cliente_Cgccpfremetente,
                                vNotaPesagemItem.Arm_Nota_Chavenfe,
                                pStatus,
                                pMessage);
           if pStatus != Status_Normal then
               Raise_Application_Error(-20001, pMessage);
           end if; 

        If vClienteInformado Is not null Then
          pStatus := Status_Erro;
          If to_number(vPesoInf) > 0 Then
             pMessage := 'Cliente Informado em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Nota n?o pode ser mais pesada';          
          Else   
             pMessage := 'Coleta Fechada em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Nota n?o pode ser mais pesada';          
          End If;
          Return;
        End If;

        Select count(*)
          into vContador
        from t_arm_notapesagem np
        where np.arm_nota_numero = vNotaPesagemItem.Arm_Notapessagem_Numero
          and np.glb_cliente_cgccpfremetente = trim(vNotaPesagemItem.Glb_Cliente_Cgccpfremetente)
          and nvl(np.arm_nota_chavenfe,'x') = nvl(vNotaPesagemItem.Arm_Nota_Chavenfe,nvl(np.arm_nota_chavenfe,'x'))
          and np.arm_notapesagem_status = 'NL';   
          
         
        select no.slf_contrato_codigo
          into vContrato
          from tdvadm.t_arm_nota no
          where no.arm_nota_numero = vNotaPesagemItem.Arm_Notapessagem_Numero
          and no.glb_cliente_cgccpfremetente = trim(vNotaPesagemItem.Glb_Cliente_Cgccpfremetente)
          and nvl(no.arm_nota_chavenfe,'x') = nvl(vNotaPesagemItem.Arm_Nota_Chavenfe,nvl(no.arm_nota_chavenfe,'x'));
          
        select count(*)
        into vAuxiliar
        from tdvadm.t_slf_clienteregras cc
       where cc.slf_contrato_codigo = vContrato
         and cc.slf_clienteregras_ativo = 'S'
         and cc.slf_clienteregras_pcobranca = 'PB';
       
       If vContador > 0 and vAuxiliar > 0 Then
          pStatus := Status_Erro;
          pMessage := 'Nota Liberada, não pode ser mais pesada';          
          Return;
       End If;
       
       if (trim(vNotaPesagemItem.Usu_Usuario_Codigopesou) <> 'sorter') then
           
           -- Pega a sequencia da NotaItem   
           SELECT Nvl(MAX(I.ARM_NOTAPESAGEMITEM_SEQ),0)+1 SEQ
              Into vNotaPesagemItem.Arm_Notapesagemitem_Seq
              FROM T_ARM_NOTAPESAGEMITEM I                                                        
              --WHERE I.ARM_NOTAPESAGEM_NUMERO =          
              --AND I.GLB_CLIENTE_CGCCPFREMETENTE = 
              Where I.ARM_NOTA_CHAVENFE = vNotaPesagemItem.Arm_Nota_Chavenfe;   
                                  
           vNotaPesagemItem.Arm_Notapesagemitem_Dtinclusao := Sysdate;     
           -- Insere o Item/Volume da Nota  
           Insert Into t_Arm_Notapesagemitem values vNotaPesagemItem;
           -- Atualiza do peso da T_Arm_Nota...
           Sp_AtualizaPeso_T_Arm_Nota(vNotaPesagemItem);
           
       else
           -- Contador que indica se aquele Item ja foi pesado
           select count(*)
             into vExistePesItem
             from tdvadm.t_arm_notapesagemitem l
            where l.glb_cliente_cgccpfremetente = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
              and l.arm_notapesagemitem_seq     = vNotaPesagemItem.Arm_Notapesagemitem_Seq
              and l.arm_nota_sequencia          = vNotaPesagemItem.Arm_Nota_Sequencia;
           
           if (vExistePesItem = 0) then
             
             vNotaPesagemItem.Arm_Notapesagemitem_Dtinclusao := Sysdate;     
             -- Insere o Item/Volume da Nota  
             Insert Into t_Arm_Notapesagemitem values vNotaPesagemItem;
             -- Atualiza do peso da T_Arm_Nota...
            -- Sp_AtualizaPeso_T_Arm_Nota(vNotaPesagemItem);
           
           end if;
           
       end if;    
           
           pStatus  := Status_Normal;
           pMessage := 'Item Adicionado com sucesso!!!';           
           Commit;
      Exception
        When Others Then
          Rollback;
          pStatus := Status_Erro;
          pMessage := sqlerrm;          
      End;             
                                                         
  End Sp_Insert_NotaPesagemItem;                                      

  Procedure Sp_Delete_NotaPesagemItem(pXmlIn In Varchar2,
                                      pStatus Out Char,
                                      pMessage Out Varchar2)
  As
  vNotaPesagemItem t_arm_notapesagemitem%RowType;
  vVolTotalPesagem Integer;
  vPesoTotalPesagem t_arm_notapesagem.arm_notapesagem_pesototal%Type;
  vASN              varchar2(100);
  vClienteInformado tdvadm.t_arm_coleta.arm_coleta_dtclienteinformado%type;
  vAuxiliar         varchar2(100);
  vColeta           tdvadm.t_arm_coleta.arm_coleta_ncompra%type;
  vCiclo            tdvadm.t_arm_coleta.arm_coleta_ciclo%type;
  Begin
    Begin

       insert into tdvadm.t_glb_sql s
       values (pXmlIn,sysdate,'Sp_Delete_NotaPesagemItem','TESTE BALANCA');
       commit;


        vNotaPesagemItem := Fn_XmlToT_Arm_Nota_PesagemItem(pXmlIn); 

        select an.xml_notalinha_numdoc,
               an.arm_coleta_ncompra,
               an.arm_coleta_ciclo,
               co.arm_coleta_dtfechamento
          into vASN,
               vColeta,
               vCiclo,
               vClienteInformado
        from tdvadm.t_arm_nota an,
             tdvadm.t_arm_coleta co
        where an.arm_coleta_ncompra = co.arm_coleta_ncompra
          and an.arm_coleta_ciclo   = co.arm_coleta_ciclo
          and an.arm_nota_sequencia = vNotaPesagemItem.Arm_Nota_Sequencia;
          

      vAuxiliar := '0';
      Begin
           select en.DT_GRAVACAO,
--                  replace(tdvadm.fn_querystring(en.PAYLOAD_ENVIO,'"RealWeight"',':',','),'"','')
                  JSON_VALUE(en.PAYLOAD_ENVIO, '$.RealWeight')
              into vClienteInformado,
                   vPesoInf
           from tdvadm.v_eventos_nimbi en
           where en.NM_ASN = vASN
             and en.COD_EVENTO = 3;
             vAuxiliar := vPesoInf;
        Exception
          When NO_DATA_FOUND Then
              vPesoInf := '0';
              vClienteInformado := null;
              vAuxiliar := '0';
        End;
        
        If ( vClienteInformado Is not Null )   Then

            If sysdate >= to_date('11/01/2021','dd/mm/yyyy') Then
            pStatus := Status_Erro;
            pMessage := 'Cliente 3 Informado em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Nota não pode ser mais pesada';          
            return;             
            End If;              
         
         End If; 


        -- Sirlano 07/05/2019
        -- Tratamento se cliente informado não exclui Item
        If vClienteInformado is null Then

            -- Thiago - 26/09/2019 - Inclusão de lógica para ler Origem da nota
            if nvl(cAmbiente,'TDV') = 'SAP' then  
                
                DELETE FROM T_ARM_NOTAPESAGEMITEM_SAP 
                 WHERE arm_nota_numero              = vNotaPesagemItem.Arm_Notapessagem_Numero
                   AND GLB_CLIENTE_CGCCPFREMETENTE  = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
                   AND ARM_NOTAPESAGEMITEM_SEQ      = vNotaPesagemItem.Arm_Notapesagemitem_Seq
                   --19/11/2021 -- Verificar a chave do item da Nota para atualizar
                   --AND Arm_Notapesagem_Chave_Etiqueta = vNotaPesagemItem.Arm_Nota_Chavenfe
                   ;
                   
                -- Pega Total de volume e peso total da pegagem   
                Select count(*),
                       NVL(Sum(i.arm_notapesagemitem_peso),0)
                  into vVolTotalPesagem,
                       vPesoTotalPesagem     
                  from t_arm_notapesagemitem_SAP i
                  where i.arm_nota_numero = vNotaPesagemItem.Arm_Notapessagem_Numero
                    and i.glb_cliente_cgccpfremetente = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
                    --19/11/2021 -- Verificar a chave do item da Nota para atualizar
                    --and i.arm_notapesagem_chave_etiqueta = vNotaPesagemItem.Arm_Nota_Chavenfe
                    ;
                    
                -- Atualiza qtde de vol e pesagem total na t_arm_notaPesagem   
                Update t_arm_notapesagem np
                   set np.arm_notapesagem_qtdvolume = vVolTotalPesagem,
                       np.arm_notapesagem_pesototal = vPesoTotalPesagem
                    where np.arm_nota_numero = vNotaPesagemItem.Arm_Notapessagem_Numero
                      and np.glb_cliente_cgccpfremetente = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
                      and np.arm_nota_chavenfe = vNotaPesagemItem.Arm_Nota_Chavenfe;  
            else  
                
                DELETE FROM T_ARM_NOTAPESAGEMITEM                                                  
                 WHERE ARM_NOTAPEsSAGEM_NUMERO      = vNotaPesagemItem.Arm_Notapessagem_Numero
                   AND GLB_CLIENTE_CGCCPFREMETENTE  = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
                   AND ARM_NOTAPESAGEMITEM_SEQ      = vNotaPesagemItem.Arm_Notapesagemitem_Seq
                   AND ARM_NOTA_CHAVENFE            = vNotaPesagemItem.Arm_Nota_Chavenfe;
                   
                -- Pega Total de volume e peso total da pegagem   
                Select count(*),
                       NVL(Sum(i.arm_notapesagemitem_peso),0)
                  into vVolTotalPesagem,
                       vPesoTotalPesagem     
                  from t_arm_notapesagemitem i
                  where i.arm_notapessagem_numero = vNotaPesagemItem.Arm_Notapessagem_Numero
                    and i.glb_cliente_cgccpfremetente = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
                    and i.arm_nota_chavenfe = vNotaPesagemItem.Arm_Nota_Chavenfe;
                    
                -- Atualiza qtde de vol e pesagem total na t_arm_notaPesagem   
                Update t_arm_notapesagem np
                   set np.arm_notapesagem_qtdvolume = vVolTotalPesagem,
                       np.arm_notapesagem_pesototal = vPesoTotalPesagem
                    where np.arm_nota_numero = vNotaPesagemItem.Arm_Notapessagem_Numero
                      and np.glb_cliente_cgccpfremetente = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
                      and np.arm_nota_chavenfe = vNotaPesagemItem.Arm_Nota_Chavenfe;    
            end if;       


            -- Atualiza pesagem total na t_arm_nota                                                      
            UPDATE T_ARM_NOTA N
               SET N.ARM_NOTA_PESOBALANCA = vPesoTotalPesagem
             WHERE N.ARM_NOTA_NUMERO = vNotaPesagemItem.Arm_Notapessagem_Numero 
               AND N.GLB_CLIENTE_CGCCPFREMETENTE = vNotaPesagemItem.Glb_Cliente_Cgccpfremetente
               AND N.ARM_NOTA_CHAVENFE = vNotaPesagemItem.Arm_Nota_Chavenfe;           
            pStatus  := Status_Normal;
            pMessage := 'Volume/Item excluido com sucesso!';
            Commit;     
       Else
          pStatus := Status_Erro;
          pMessage := 'Cliente Informado em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Item não pode ser mais EXCLUIDO não pode ser mais pesada';          
       End If;      
    Exception
      When Others Then
        Rollback;
        pStatus  := Status_Erro;
        pMessage := sqlerrm;
    End;  
  End Sp_Delete_NotaPesagemItem;                                      

  Procedure Sp_ValidaLeitura_NF(pXmlIn   In  Varchar2,
                                pStatus  Out Char,
                                pMessage Out Varchar2)
  As
  vNotaPesagem t_Arm_Notapesagem%RowType;
  Begin
     Begin
         insert into tdvadm.t_glb_sql s
         values (pXmlIn,sysdate,'Sp_ValidaLeitura_NF','TESTE BALANCA');
         commit;

         vNotaPesagem := Fn_XmlToT_Arm_Nota_Pesagem(pXmlIn);
         Sp_ValidaLeitura_NF2(vNotaPesagem.Arm_Nota_Numero, 
                              vNotaPesagem.Glb_Cliente_Cgccpfremetente,
                              vNotaPesagem.Arm_Nota_Chavenfe,
                              pStatus,
                              pMessage);
                                            
     Exception
       When Others Then
         pStatus := Status_Erro;
         pMessage := sqlerrm;
     End;
  End Sp_ValidaLeitura_NF;  
  
  Procedure Sp_Update_FinalizaNotaPesagem(pXmlIn   In  Varchar2,
                                          pStatus  Out Char,
                                          pMessage Out Varchar2)
  As
  vNotaPesagem      t_Arm_Notapesagem%RowType;
  vClienteInformado tdvadm.t_arm_coleta.arm_coleta_dtclienteinformado%type;
  vArmazem          varchar2(100);
  vTexto            varchar2(2000);
  vTextoLog         VARCHAR2(2000);
  vCliente          varchar2(100);
  vJanela           varchar2(50);
  vIncoterms        tdvadm.t_col_asn.col_asn_incoterms%type;
  vASN              varchar2(100);
  vAuxiliar         integer;
  vChaveNfe         tdvadm.t_arm_nota.arm_nota_chavenfe%type;
  vSerie            tdvadm.t_arm_nota.arm_nota_serie%type; 
  vMessage Varchar2(1000);
  
  Begin
     pStatus := 'N';
     pMessage := '';            
     vClienteInformado := null;
     vArmazem := '';
     vTexto := '';
     cAmbiente := 'TDV';

         insert into tdvadm.t_glb_sql s
         values (pXmlIn,sysdate,'Sp_Update_FinalizaNotaPesagem','TESTE BALANCA');
         commit;
    
     Begin
        vNotaPesagem := Fn_XmlToT_Arm_Nota_Pesagem(pXmlIn);    


        select co.arm_coleta_dtclienteinformado,
               a.arm_armazem_codigo || '-' || a.arm_armazem_descricao,
               an.slf_contrato_codigo || '-' || cl.glb_cliente_razaosocial,
               to_char(jc.arm_janelacons_dtinicio,'dd/mm/yyyy hh24:mi:ss') || ' as ' || to_char(jc.arm_janelacons_dtfim,'dd/mm/yyyy hh24:mi:ss'),
               co.xml_coleta_numero,
               (select DISTINCT asn.incoterms
                from tdvadm.v_col_asnaceite asn
                where asn.ASNNUMERO = co.xml_coleta_numero ) incoterms,
                an.arm_nota_chavenfe,
                an.arm_nota_serie
          into vClienteInformado,
               vArmazem,
               vCliente,
               vJanela,
               vASN,
               vIncoterms,
               vChaveNfe,
               vSerie
        from tdvadm.t_arm_nota an,
             tdvadm.t_arm_coleta co,
             tdvadm.t_Arm_Armazem a,
             tdvadm.t_glb_cliente cl,
             tdvadm.t_arm_janelacons jc
        where an.arm_coleta_ncompra = co.arm_coleta_ncompra
          and an.arm_coleta_ciclo = co.arm_coleta_ciclo
          and nvl(co.arm_coleta_clienteinformado,'N') = 'S'
          and an.arm_armazem_codigo = a.arm_armazem_codigo
          and an.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
          and an.glb_cliente_cgccpfremetente = vNotaPesagem.Glb_Cliente_Cgccpfremetente
          and nvl(an.arm_nota_chavenfe,'X') = nvl(vNotaPesagem.Arm_Nota_Chavenfe,'X')
          and rpad(an.glb_cliente_cgccpfsacado,20) = cl.glb_cliente_cgccpfcodigo (+)
          and an.arm_janelacons_sequencia = jc.arm_janelacons_sequencia (+);
     Exception
       When NO_DATA_FOUND Then
          vClienteInformado := null;
          vArmazem := null;
       When Others Then
         pStatus := 'E';
         pMessage := 'Erro ao Finalizar Pesagem: ' || sqlerrm;
       End;
       

      If vASN is not null Then

      Begin
           select en.DT_GRAVACAO,
--                  replace(tdvadm.fn_querystring(en.PAYLOAD_ENVIO,'"RealWeight"',':',','),'"','')
                  JSON_VALUE(en.PAYLOAD_ENVIO, '$.RealWeight')
              into vClienteInformado,
                   vPesoInf
           from tdvadm.v_eventos_nimbi en
           where en.NM_ASN = vASN
             and en.COD_EVENTO = 3;
        Exception
          When NO_DATA_FOUND Then
              vPesoInf := '0';
              vClienteInformado := null;
        End;
        End If;
         If ( vClienteInformado Is not Null )   Then
            
            If sysdate >= to_date('11/01/2021','dd/mm/yyyy') Then
            pStatus := Status_Erro;
            pMessage := 'Cliente 4 Informado em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Nota não pode ser mais pesada';          
            return;             
            End If;
         
         End If; 



       
       
     If vClienteInformado Is not Null Then
        vTexto := 'Nota ' || vNotaPesagem.Arm_Nota_Numero || chr(10) ||
                  'CNPJ ' || vNotaPesagem.Glb_Cliente_Cgccpfremetente || chr(10) ||
                  'Armazem ' || vArmazem || chr(10) ||
                  'Usuario ' || vNotaPesagem.Usu_Usuario_Codigoimprimiu || chr(10) ||
                  'Contrato ' || vCliente || chr(10) ||
                  'Cli Informado ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || chr(10) ||
                  'ASN ' || vASN || chr(10) ||
                  'INCOTERMS ' || vIncoterms || chr(10) ||
                  'Dt Pesagem ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || chr(10) || 
                  'Janela ' || vJanela || chr(10) || chr(10) ||
                  'Sp_Update_FinalizaNotaPesagem';

        vTextoLog := vNotaPesagem.Arm_Nota_Numero || '|' || 
                     vNotaPesagem.Glb_Cliente_Cgccpfremetente || '|' || 
                     vArmazem || '|' || 
                     vNotaPesagem.Usu_Usuario_Codigoimprimiu || '|' || 
                     vCliente || '|' || 
                     vASN || '|' || 
                     vIncoterms || '|' || 
                     to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || '|' || 
                     to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '|' ||
                     vJanela;
                  
        INSERT INTO TDVADM.T_GRD_AUDIT A
        VALUES ('VALE','TIAGO','T_ARM_NOTAPESAGEM','UPDATE',NULL,vTextoLog,SYSDATE,'VALE','VALE','Sp_Update_FinalizaNotaPesagem');
 
/* Sirlano Retirado em 13/05/2021
       wservice.pkg_glb_email.SP_ENVIAEMAIL('PESAGEM DE NOTA APOS CLIENTE INFORMADO',
                                             vTexto,
                                             'aut-e@dellavolpe.com.br',
                                             'grp.notarepesada@dellavolpe.com.br');
*/       
     End If; 

     Begin
        -- Thiago - 26/09/2019 - Verificação origem da nota       
        If vNotaPesagem.Arm_Notapesagem_Origem_Nota = 'SAP' Then
          cAmbiente := 'SAP';
          
          Select count(*)
            into vAuxiliar
          from t_arm_notapesagem_sap np
          where np.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
            and np.glb_cliente_cgccpfremetente = trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente)
            and nvl(np.arm_nota_chavenfe,'x') = nvl(vChaveNfe,nvl(np.arm_nota_chavenfe,'x'))
            and ( ( np.arm_notapesagem_status = 'NL' ) or ( nvl(np.arm_notapesagem_finalizou,'N') = 'S' ) );
            
        else
          cAmbiente := 'TDV';
          
          Select count(*)
            into vAuxiliar
          from t_arm_notapesagem np
          where np.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
            and np.glb_cliente_cgccpfremetente = trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente)
            and nvl(np.arm_nota_chavenfe,'x') = nvl(vChaveNfe,nvl(np.arm_nota_chavenfe,'x'))
            and ( ( np.arm_notapesagem_status = 'NL' ) or ( nvl(np.arm_notapesagem_finalizou,'N') = 'S' ) );
            
        end if;
        
        If vAuxiliar = 0 then
            -- Thiago - 26/09/2019 - Verificação origem da nota       
            If vNotaPesagem.Arm_Notapesagem_Origem_Nota = 'SAP' Then
              cAmbiente := 'SAP'; 
              Update tdvadm.t_arm_notapesagem_sap np
               set np.usu_usuario_codigoimprimiu = trim(vNotaPesagem.Usu_Usuario_Codigoimprimiu),
                   np.arm_notapesagem_dtimprimiu = sysdate,
                   np.arm_notapesagem_status = 'NP',
                   np.arm_notapesagem_obs = 'Pesagem Finalizada com Sucesso',
                   np.arm_notapesagem_finalizou = 'S',
                   np.arm_notapesagem_dtfinalizou = sysdate
              where np.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
                and np.glb_cliente_cgccpfremetente = trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente)
                and nvl(np.arm_nota_chavenfe,'x') = nvl(vChaveNfe,nvl(np.arm_nota_chavenfe,'x'))
                and nvl(np.arm_notapesagem_finalizou,'N') = 'N';
                
            else
              cAmbiente := 'TDV';
               
              Update tdvadm.t_arm_notapesagem np
               set np.usu_usuario_codigoimprimiu = trim(vNotaPesagem.Usu_Usuario_Codigoimprimiu),
                   np.arm_notapesagem_dtimprimiu = sysdate,
                   np.arm_notapesagem_status = 'NP',
                   np.arm_notapesagem_obs = 'Pesagem Finalizada com Sucesso',
                   np.arm_notapesagem_finalizou = 'S',
                   np.arm_notapesagem_dtfinalizou = sysdate
              where np.arm_nota_numero = vNotaPesagem.Arm_Nota_Numero
                and np.glb_cliente_cgccpfremetente = trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente)
                and nvl(np.arm_nota_chavenfe,'x') = nvl(vChaveNfe,nvl(np.arm_nota_chavenfe,'x'))
                and nvl(np.arm_notapesagem_finalizou,'N') = 'N';
                
              end if;
                  
              pStatus := 'N';
              pMessage := 'Pesagem Finalizada com sucesso!';
              pkg_slf_contrato.SP_INFORMACLIENTE(vNotaPesagem.Arm_Nota_Numero, 
                                                 trim(vNotaPesagem.Glb_Cliente_Cgccpfremetente), 
                                                 vSerie, 
                                                 substr(vArmazem,1,2) ,
                                                 trim(vNotaPesagem.Usu_Usuario_Codigoimprimiu),
                                                 'P', 
                                                 pStatus, 
                                                 vMessage);
        Else
          select count(*)
            into vAuxiliar 
          from TDVADM.T_ARM_LIBERANOTA n
          where n.arm_liberanota_chavenfe = vChaveNfe;
          If vAuxiliar = 0 Then
              pStatus := 'E';
              pMessage := 'Nota Liberada não pode ser mais Pesada!';
          End If;
          
        End If;                  
    Exception
      When Others Then
        Rollback;
        pStatus := 'E';
        pMessage := 'Erro ao Finalizar Pesagem: F10 ' || sqlerrm;
    End;          
          
  End Sp_Update_FinalizaNotaPesagem;
  
Procedure Sp_Update_FinalizaNotaPesagem2(pUsuario In  Varchar2,
                                         pArmNotaNumero In Varchar2,
                                         pRemetente In Varchar2,
                                         pChaveNfe In Varchar2,
                                         pPeso In Varchar2,
                                         pStatus  Out Char,
                                         pMessage Out Varchar2)
  As
  vNotaPesagem t_Arm_Notapesagem%RowType;
  vArmazem t_arm_nota.arm_armazem_codigo%type;
  vSerie   t_arm_nota.arm_nota_serie%type;
  vStatus Char;
  vMessage Varchar2(1000);
  vAuxiliar number;
  vPeso  varchar2(15);

  vClienteInformado tdvadm.t_arm_coleta.arm_coleta_dtclienteinformado%type;
  vArmazemTexto     varchar2(100);
  vTexto            varchar2(2000);
  vTextoLog         varchar2(2000);
  vPesoAnterior     tdvadm.t_arm_nota.arm_nota_pesobalanca%type;
  vCliente          varchar2(100);
  vAsn              varchar2(100);
  vJanela           varchar2(50);
  vPesoInformado    number;
  vIncoterms        tdvadm.t_col_asn.col_asn_incoterms%type;
  vChaveNfe         tdvadm.t_arm_nota.arm_nota_chavenfe%type;
  vTeste            char(1);
  
  Begin
     vClienteInformado := null;
     vArmazemTexto := '';
     vTexto := '';

--     If pPeso = '0' Then
--       pStatus := 'E';
--       pMessage := 'Foi enviado peso ZERADO!';
--     End If;
     
     vPeso := trim(replace(upper(pPeso),'KG',''));
     
  
     Begin
       
        Begin 
        vTeste := '1';
        select x.arm_armazem_codigo, 
               x.arm_nota_serie,
               co.arm_coleta_dtclienteinformado,
               a.arm_armazem_codigo || '-' || a.arm_armazem_descricao,
               x.arm_nota_pesobalanca,
               x.slf_contrato_codigo || '-' || cl.glb_cliente_razaosocial Cliente,
               co.xml_coleta_numero,
               '   as   ',
--               to_char(jc.arm_janelacons_dtinicio,'dd/mm/yyyy hh24:mi:ss') || ' as ' || to_char(jc.arm_janelacons_dtfim,'dd/mm/yyyy hh24:mi:ss'),
               (select DISTINCT asn.incoterms
                from tdvadm.v_col_asnaceite asn
                where asn.ASNNUMERO = co.xml_coleta_numero ) incoterms,
                x.arm_nota_chavenfe
          into vArmazem, 
               vSerie,
               vClienteInformado,
               vArmazemTexto,
               vPesoAnterior,
               vCliente,
               vASN,
               vJanela,
               vIncoterms,
               vChaveNfe
        from tdvadm.t_arm_nota x,
             tdvadm.t_arm_coleta co,
             tdvadm.t_arm_armazem a,
             tdvadm.t_glb_cliente cl,
             tdvadm.t_arm_janelacons jc
        where x.arm_nota_numero = pArmNotaNumero
        and x.glb_cliente_cgccpfremetente = trim(pRemetente)
        and nvl(x.arm_nota_chavenfe,'x') = nvl(pChaveNfe,nvl(x.arm_nota_chavenfe,'x'))
        and x.arm_coleta_ncompra = co.arm_coleta_ncompra
        and x.arm_coleta_ciclo = co.arm_coleta_ciclo
        and x.arm_armazem_codigo = a.arm_armazem_codigo
        and x.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo (+)
        and x.arm_janelacons_sequencia = jc.arm_janelacons_sequencia (+);

      If vASN is not null Then

      Begin
           select en.DT_GRAVACAO,
--                  replace(tdvadm.fn_querystring(en.PAYLOAD_ENVIO,'"RealWeight"',':',','),'"','')
                  JSON_VALUE(en.PAYLOAD_ENVIO, '$.RealWeight')
              into vClienteInformado,
                   vPesoInf
           from tdvadm.v_eventos_nimbi en
           where en.NM_ASN = vASN
             and en.COD_EVENTO = 3;
        Exception
          When NO_DATA_FOUND Then
              vPesoInf := '0';
              vClienteInformado := null;
        End;
        End If;
         If ( vClienteInformado Is not Null )   Then

            If sysdate >= to_date('11/01/2021','dd/mm/yyyy') Then
            pStatus := Status_Erro;
            pMessage := 'Cliente 5 Informado em ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Nota não pode ser mais pesada';          
            return;             
            End If;              
         
         End If; 



         If ( vClienteInformado Is not Null ) and ( trim(nvl(vPeso,'0')) <> '0' ) Then

            Begin
               select replace(tdvadm.fn_querystring(en.PAYLOAD_ENVIO,'"RealWeight"',':',','),'"','')
                  into vPesoInformado
               from tdvadm.v_eventos_nimbi en
               where en.NM_ASN = vASN
                 and en.COD_EVENTO = 3;
             exception
                When NO_DATA_FOUND Then
                   vPesoInformado := 0;
             End;  
             
             vTeste := '2';
             select np.arm_notapesagem_pesototal
               into vPesoAnterior
             from tdvadm.t_arm_notapesagem np
             where np.arm_nota_numero = pArmNotaNumero
               and np.glb_cliente_cgccpfremetente = trim(pRemetente)
               and nvl(np.arm_nota_chavenfe,'x') = nvl(pChaveNfe,nvl(pChaveNfe,'x'));


            vTexto := 'Nota ' || pArmNotaNumero || chr(10) ||
                      'CNPJ ' || pRemetente || chr(10) ||
                      'Armazem ' || vArmazemTexto || chr(10) ||
                      'Usuario ' || pUsuario || chr(10) ||
                      'Contrato ' || vCliente || chr(10) ||
                      'ASN ' || vASN || chr(10) ||
                      'INCOTERMS ' || vIncoterms || chr(10) ||
                      'Cli Informado ' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || ' Peso ' || tdvadm.f_mascara_valor(vPesoInformado,10,0) || chr(10) || 
                      'Dt Pesagem '   || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')           || ' Peso ' || tdvadm.f_mascara_valor(vPesoAnterior,10,0)         || chr(10) || chr(10) ||
                      'Janela ' || vJanela || chr(10) ||
                      'Sp_Update_FinalizaNotaPesagem2';
                      
            vTextoLog := pArmNotaNumero || '|' || pRemetente || '|' || vArmazemTexto || '|' || pUsuario || '|' || vCliente || '|' || vASN || '|' || vIncoterms || '|' || to_char(vClienteInformado,'dd/mm/yyyy hh24:mi:ss') || '|' || tdvadm.f_mascara_valor(vPesoInformado,10,0) || '|' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '|' || tdvadm.f_mascara_valor(vPesoAnterior,10,0) || '|' || vJanela;
            
            Begin          
             vTeste := '3';              
/* Sirlano Retirado em 13/05/2021
            If trim(vPesoInformado) <> Trim(vPesoAnterior) Then
                      
--               INSERT INTO TDVADM.T_GRD_AUDIT A
--               VALUES ('VALE','TIAGO','T_ARM_NOTAPESAGEM','UPDATE',NULL,vTextoLog,SYSDATE,'VALE','VALE','Sp_Update_FinalizaNotaPesagem2');
               

               wservice.pkg_glb_email.SP_ENVIAEMAIL('PESAGEM DE NOTA APOS CLIENTE INFORMADO',
                                                    vTexto,
                                                    'aut-e@dellavolpe.com.br',
                                                    'grp.notarepesada@dellavolpe.com.br');

            End If;
*/            
            Exception 
              When OTHERS Then
                  vTexto := vTexto || chr(10) || sqlerrm;
--                  wservice.pkg_glb_email.SP_ENVIAEMAIL('ERRO - PESAGEM DE NOTA APOS CLIENTE INFORMADO',
--                                                       vTexto,
 --                                                      'aut-e@dellavolpe.com.br',
 --                                                      'sdrumond@dellavolpe.com.br');
                
              End;  
         
         
         End If; 
        
        exception
          When NO_DATA_FOUND Then
             raise_application_error(-20004,vTeste || chr(10) || pUsuario || chr(10) || pArmNotaNumero || chr(10) || pRemetente || chr(10) || pChaveNfe || chr(10) );
          End;  

        vTeste := '4';         
        Select count(*)
          into vAuxiliar
        from tdvadm.t_arm_notapesagem np
        where np.arm_nota_numero = pArmNotaNumero
          and np.glb_cliente_cgccpfremetente = trim(pRemetente)
          and nvl(np.arm_nota_chavenfe,'x') = nvl(pChaveNfe,nvl(np.arm_nota_chavenfe,'x'))
          and ( ( np.arm_notapesagem_status = 'NL' ) or ( nvl(np.arm_notapesagem_finalizou,'N') = 'S' ) );

        vTeste := '5';
        If vAuxiliar = 0 then
            Update tdvadm.t_arm_notapesagem np
               set np.usu_usuario_codigoimprimiu = trim(pUsuario),
                   np.arm_notapesagem_dtimprimiu = sysdate,
                   np.arm_notapesagem_status = 'NP',
                   np.arm_notapesagem_obs = 'Pesagem Finalizada com Sucesso',
                   np.arm_notapesagem_finalizou = 'S',
                   np.arm_notapesagem_dtfinalizou = sysdate
              where np.arm_nota_numero = pArmNotaNumero
                and np.glb_cliente_cgccpfremetente = trim(pRemetente)
                and nvl(np.arm_nota_chavenfe,'x') = nvl(pChaveNfe,nvl(np.arm_nota_chavenfe,'x'))
                and nvl(np.arm_notapesagem_finalizou,'N') = 'N';

            -- Thiago - 29/09/2019 - Replicado update para gravar na tabela referente ao SAP    
            Update tdvadm.t_arm_notapesagem_SAP np
               set np.usu_usuario_codigoimprimiu = trim(pUsuario),
                   np.arm_notapesagem_dtimprimiu = sysdate,
                   np.arm_notapesagem_status = 'NF',
                   np.arm_notapesagem_obs = 'Pesagem Finalizada com Sucesso',
                   np.arm_notapesagem_finalizou = 'S',
                   np.arm_notapesagem_dtfinalizou = sysdate
              where np.arm_nota_numero = pArmNotaNumero
                and np.glb_cliente_cgccpfremetente = trim(pRemetente)
                and nvl(np.arm_nota_chavenfe,'x') = nvl(pChaveNfe,nvl(np.arm_nota_chavenfe,'x'))
                and nvl(np.arm_notapesagem_finalizou,'N') = 'N';    

              vTeste := '6';                  
              pStatus := 'N';
              pMessage := 'Pesagem Finalizada com sucesso 2!';
              pkg_slf_contrato.SP_INFORMACLIENTE(pArmNotaNumero, 
                                                 trim(pRemetente), 
                                                 vSerie, 
                                                 vArmazem ,
                                                 trim(pUsuario),
                                                 'P', 
                                                 pStatus, 
                                                 vMessage);
        Else
            select count(*)
              into vAuxiliar 
            from TDVADM.T_ARM_LIBERANOTA n
            where n.arm_liberanota_chavenfe = vChaveNfe;
            If vAuxiliar = 0 Then
                pStatus := 'E';
                pMessage := 'Nota Liberada não pode ser mais Pesada 55';
            End If;
        End If;                  
        pMessage := pMessage || chr(10) || vMessage;        
        Commit;   
                      
    Exception
      When Others Then
        Rollback;
        pStatus := 'E';
        pMessage := vTeste;
--        pMessage := 'Erro ao Finalizar Pesagem: F10 ' || vPesoAnterior || '-' || vPeso || '-' || sqlerrm;
    End;          
          
  End Sp_Update_FinalizaNotaPesagem2;

  
  Procedure Sp_Get_DadosFilialBalanca(pRota    In  Varchar2,
                                      pArmazem In  Varchar2,
                                      pDescricaoRota In  Varchar2,
                                      pCursor  out Types.cursorType,
                                      pStatus  Out Char,
                                      pMessage Out Varchar2) As
  Begin
    Begin
      if nvl(pRota, 'R') != 'R'then
        
         Open pCursor For  select *
                           from t_glb_filialbalanca c
                           where c.glb_rota_codigo = pRota
                           order by c.glb_filialbalanca_codigo;
         pStatus := 'N';
         pMessage := '';   
                                                                          
          
      elsif nvl(pArmazem,'A') != 'A' then
        Open pCursor For  select c.*
                            from t_arm_armazem e,
                                 t_glb_filialbalanca c
                            where e.glb_rota_codigo = c.glb_rota_codigo
                              and e.arm_armazem_codigo= pArmazem
                              order by c.glb_filialbalanca_codigo; 
                              
         pStatus := 'N';
         pMessage := '';
                                                                          
      elsif nvl(pDescricaoRota, 'D') != 'D' then
          Open pCursor For select ca.*
                            from t_glb_rota ta,
                                t_glb_filialbalanca ca
                           where ca.glb_rota_codigo = ta.glb_rota_codigo
                            and instr(lower(ta.glb_rota_descricao),lower(pDescricaoRota)) > 0
                            order by ca.glb_filialbalanca_codigo;
      
         pStatus := 'N';
         pMessage := '';                                    
      else
        pStatus := 'E';
        pMessage := 'Nenhum parametro de entrada informado';
      end if;
       
    Exception
      When Others Then
        Rollback;
        pStatus := 'E';
        pMessage := 'Erro ao Buscar dados da Balanca: ' || sqlerrm;
    End;          
          
  End Sp_Get_DadosFilialBalanca;
  
  Procedure Sp_insert_FilialBalanca(pXmlIn   In  Varchar2,
                                    pStatus  Out Char,
                                    pMessage Out Varchar2) As
                                    
  /*
 <filialBalanca>
      <codigo>1</codigo>
      <rota>010</rota>
      <marcaBalanca>Toledo 3.000kg</marcaBalanca>
      <marcaModulo>Toledo 3.000kg</marcaModulo>
      <modBalanca>Toledo 3.000kg</modBalanca>
      <modModulo>Toledo 3.000kg</modModulo>
      <piniLeitura>2</piniLeitura>
      <sizeLeitura>6</sizeLeitura>
      <porta>COM1</porta>
      <velocidade>9600</velocidade>
      <dataBits>8</dataBits>
      <stopBits>1</stopBits>
      <paridade>odd</paridade>
      <online>-1</online>
      <countEstavel>4</countEstavel>
      <timerOnline>1000</timerOnline>
      <timerEstabil>1000</timerEstabil>
      <obs>Toledo 3.000kg</obs>
      <startOnShow>-1</startOnShow>
      <notaPini>1</notaPini>
      <notaSize>8</notaSize>
      <cnpjPini>9</cnpjPini>
      <cnpjSize>14</cnpjSize>
      <capacidade>3000</capacidade>
      <ativa>S</ativa>
      <pesoMinimo>1</pesoMinimo>
      <charStart>p</charStart>
      <arredondar>S</arredondar>
      <casaDecimal>1</casaDecimal>
</filialBalanca>*/
  vFilialBalanca t_glb_filialbalanca%rowtype;
  Begin
    Begin

         insert into tdvadm.t_glb_sql s
         values (pXmlIn,sysdate,'Sp_insert_FilialBalanca','TESTE BALANCA');
         commit;
       
      Select extractvalue(Value(V), '/filialBalanca/codigo'),           
             extractvalue(Value(V), '/filialBalanca/rota'),           
             extractvalue(Value(V), '/filialBalanca/marcaBalanca'),   
             extractvalue(Value(V), '/filialBalanca/marcaModulo'),    
             extractvalue(Value(V), '/filialBalanca/modBalanca'),     
             extractvalue(Value(V), '/filialBalanca/modModulo'),      
             extractvalue(Value(V), '/filialBalanca/piniLeitura'),    
             extractvalue(Value(V), '/filialBalanca/sizeLeitura'),    
             extractvalue(Value(V), '/filialBalanca/porta'),          
             extractvalue(Value(V), '/filialBalanca/velocidade'),     
             extractvalue(Value(V), '/filialBalanca/dataBits'),       
             extractvalue(Value(V), '/filialBalanca/stopBits'),       
             extractvalue(Value(V), '/filialBalanca/paridade'),       
             extractvalue(Value(V), '/filialBalanca/online'),         
             extractvalue(Value(V), '/filialBalanca/countEstavel'),   
             extractvalue(Value(V), '/filialBalanca/timerOnline'),    
             extractvalue(Value(V), '/filialBalanca/timerEstabil'),   
             extractvalue(Value(V), '/filialBalanca/obs'),            
             extractvalue(Value(V), '/filialBalanca/startOnShow'),    
             extractvalue(Value(V), '/filialBalanca/notaSize'),       
             extractvalue(Value(V), '/filialBalanca/notaPini'),       
             extractvalue(Value(V), '/filialBalanca/cnpjPini'),       
             extractvalue(Value(V), '/filialBalanca/cnpjSize'),       
             extractvalue(Value(V), '/filialBalanca/capacidade'),     
             extractvalue(Value(V), '/filialBalanca/ativa'),          
             extractvalue(Value(V), '/filialBalanca/pesoMinimo'),     
             extractvalue(Value(V), '/filialBalanca/charStart'),      
             extractvalue(Value(V), '/filialBalanca/arredondar'),     
             extractvalue(Value(V), '/filialBalanca/casaDecimal')     
       
       into vFilialBalanca
       From  TABLE(XMLSequence(Extract(xmltype.createxml(pXmlIn), '/filialBalanca'))) V;  
       
       insert into t_glb_filialbalanca values vFilialBalanca;
       
       pStatus := 'N';
       pMessage := '';
    Exception
      When Others Then
        Rollback;
        pStatus := 'E';
        pMessage := 'Erro ao Inserir Balanca' || sqlerrm;
    End;
    
 end Sp_insert_FilialBalanca;                                                                    
  
  Procedure Sp_Arm_InserePessagemSorter(pJSVolumes in clob,
                                        pStatus    out char,
                                        pMessage   out clob)As
  vArmNotaSequencia tdvadm.t_arm_nota.arm_nota_sequencia%type;
  vCnpjRemetente    tdvadm.t_arm_nota.glb_cliente_cgccpfremetente%type;
  vNumeroNF         tdvadm.t_arm_nota.arm_nota_numero%type;
  vParametro        varchar2(2000);
  vStatus           char(1);
  vMessagem         varchar(2000);
  vNotaQtdeVolume   tdvadm.t_arm_nota.arm_nota_qtdvolume%type;
  vPesagemItemCount Integer;
  vChaveNota        tdvadm.t_arm_nota.arm_nota_chavenfe%type;
  vSerieNf          tdvadm.t_arm_nota.arm_nota_serie%type;
  vPesaDecimal      char(1);
  vPesoNotaTotal    number(19,2);
  vNotaPesagem      Integer;
  vXmlIn            Varchar2(2000);
  Begin
    vPesaDecimal := 'N';

         insert into tdvadm.t_glb_sql s
         values (pJSVolumes,sysdate,'Sp_Arm_InserePessagemSorter','TESTE BALANCA');
         commit;
                                           
    Begin     
          
      FOR rec IN ( select j.nf,
                          j.numVolume,
                          j.peso,
                          j.altura,
                          j.largura,
                          j.comprimento,
                          j.rampa,
                          j.usuario,
                          j.dataFinalizacao,
                          j.dataInclusao
                     from json_table(pJSVolumes,'$[*]' COLUMNS 
                      nf              varchar2(44) PATH '$.nf',
                      numVolume       varchar2(35) PATH '$.numVolume',
                      peso            varchar2(20) PATH '$.peso',
                      altura          varchar2(20) PATH '$.altura',
                      largura         varchar2(20) PATH '$.largura',
                      comprimento     varchar2(20) PATH '$.comprimento',
                      rampa           varchar2(20) PATH '$.rampa',
                      usuario         varchar2(20) PATH '$.usuario',
                      dataFinalizacao varchar2(20) PATH '$.dataFinalizacao',
                      dataInclusao    varchar2(20) PATH '$.dataInclusao'
                     ) j  
                   ) 
      LOOP
        
        begin
          
        
        dbms_output.put_line (rec.nf||','||rec.numVolume||','||rec.peso||','||rec.altura);
        
        --Analise pela Chafe NFe
        if (length(rec.nf) > 7) then 
           -- Pega o numero da sequencia da nota.
           select k.arm_nota_sequencia,
                  k.glb_cliente_cgccpfremetente,
                  k.arm_nota_numero,
                  k.arm_nota_qtdvolume, 
                  k.arm_nota_chavenfe,
                  k.arm_nota_serie
             into vArmNotaSequencia,
                  vCnpjRemetente,
                  vNumeroNF,
                  vNotaQtdeVolume,
                  vChaveNota,
                  vSerieNf
             from tdvadm.t_arm_nota k
            where k.arm_nota_chavenfe    = rec.nf
              and k.arm_embalagem_numero = substr(rec.numvolume,-7);
           
       --Analise pela a Sequencia
       else
         
           -- Pega o numero da sequencia da nota.
           select k.arm_nota_sequencia,
                k.glb_cliente_cgccpfremetente,
                k.arm_nota_numero,
                k.arm_nota_qtdvolume, 
                k.arm_nota_chavenfe,
                k.arm_nota_serie
           into vArmNotaSequencia,
                vCnpjRemetente,
                vNumeroNF,
                vNotaQtdeVolume,
                vChaveNota,
                vSerieNf
           from tdvadm.t_arm_nota k
          where k.arm_nota_sequencia    = rec.nf
            and k.arm_embalagem_numero = substr(rec.numvolume,-7);
         
       end if;
         
        -- Contador t_arm_nota_pessagem
        select count(*)
          into vNotaPesagem 
          from tdvadm.t_arm_notapesagem n
        where n.arm_nota_sequencia = vArmNotaSequencia;
        
          
        vNotaPesagem := nvl(vNotaPesagem, 0);
        

        
        -- insere o peso do item
        vParametro:= '<Parametros>
                        <Input>
                           <NotaPesagem>
                              <NotaNumero>'         ||vNumeroNF                             || '</NotaNumero>
                              <NotaCGCCPFRemetente>'||trim(vCnpjRemetente)                  || '</NotaCGCCPFRemetente>
                              <NotaSequencia>'      ||vArmNotaSequencia                     || '</NotaSequencia>
                              <NotaChaveNFE>'       ||vChaveNota                            || '</NotaChaveNFE>
                           </NotaPesagem>
                           <ItemPeso>'              ||rec.peso                              || '</ItemPeso>
                           <UsuarioPesou>sorter</UsuarioPesou>
                           <ItemSeq>'               ||to_number(substr(rec.numvolume,23,3)) || '</ItemSeq>
                           <ItemAltura>'            ||rec.altura/100                        || '</ItemAltura>
                           <ItemLargura>'           ||rec.Largura/100                       || '</ItemLargura>
                           <ItemComprimento>'       ||rec.Comprimento/100                   || '</ItemComprimento>
                        </Input>
                      </Parametros>';
      
      
      

      tdvadm.pkg_arm_notapesagem.Sp_Insert_NotaPesagemItem(vParametro,
                                                           vStatus,
                                                           vMessagem);
      
      if (vStatus = 'N') then
        
        select count(*) 
          into vPesagemItemCount 
          from tdvadm.t_arm_notapesagemitem i
         where i.arm_nota_sequencia = vArmNotaSequencia;

        if (vNotaQtdeVolume = vPesagemItemCount) then
           
            -- fn_buscadecpesagem retorna:
            -- S - Pesa com casas dedimais
            -- N - Não pesa com casas decimais                               
            vPesaDecimal := tdvadm.pkg_slf_contrato.fn_buscadecpesagem('011', 
                                                                       vNumeroNF,
                                                                       vCnpjRemetente,
                                                                       vSerieNf,
                                                                       'N');
                                                                       
                                                                                   
            -- select para pegar total pesado na tabela do item        
            select DECODE(vPesaDecimal,'S', ROUND(sum(nvl(i.arm_notapesagemitem_peso, 0)),1),
                                       '1', ROUND(sum(nvl(i.arm_notapesagemitem_peso, 0)),1),  
                                            ROUND(sum(nvl(i.arm_notapesagemitem_peso, 0))))
              into vPesoNotaTotal 
              from tdvadm.t_arm_notapesagemitem i
             where i.arm_nota_sequencia = vArmNotaSequencia;    
            
            -- Klayton em 14/05/2021
            -- No aredondadmento o peso pode ser menos que 499 gramas o round aredonda para baixo.
            -- Essa segurança abaixo é para evitar a notas fiquem com o peso zerado.
            if (vPesoNotaTotal = 0) then
              
              vPesoNotaTotal := 1;
              
            end if;   
            
            vXmlIn := '<Parametros> 
                       <Input>
                           <NotaNumero>' || vNumeroNF || '</NotaNumero>
                           <NotaCGCCPFRemetente>' || vCnpjRemetente || '</NotaCGCCPFRemetente>
                           <NotaQtdeVolume>' || vNotaQtdeVolume || '</NotaQtdeVolume>
                           <UsuarioImprimiu></UsuarioImprimiu>
                           <NotaPeso>'|| vPesoNotaTotal ||'</NotaPeso>
                           <QtdeVolume>' || vNotaQtdeVolume || '</QtdeVolume>
                           <PesoTotal>'|| vPesoNotaTotal ||'</PesoTotal>
                           <DataImprimiu>30/12/1899</DataImprimiu>
                           <Codigo>-1</Codigo>
                           <NotaSequencia>' || vArmNotaSequencia || '</NotaSequencia>
                           <NotaChaveNFE>' || vChaveNota || '</NotaChaveNFE>
                           <Items>
                           </Items>
                      </Input>
                      </Parametros>';
                      
                      
            -- Insere o registro na T_Arm_Notapessagem
            Sp_Insert_NotaPesagem(vXmlIn,
                                  vStatus,
                                  vMessagem);
                                  
                       
            -- Atualizo o peso da da T_arm_nota                               
            Sp_AtualizaPesoSorter(trim(vArmNotaSequencia));
                       
            
            -- Finaliza a pessagem = F11
            Sp_Update_FinalizaNotaPesagem2('sorter',
                                           vNumeroNF,
                                           vCnpjRemetente,
                                           vChaveNota,
                                           vPesoNotaTotal,
                                           vStatus ,
                                           vMessagem);

                                            
        end if;
        
      end if;
        
      
      

      
      Exception when Others then
       
      dbms_output.put_line('Erro.:'||rec.nf||'-'||vStatus||'-'||vMessagem); 
     
      End;
      
      
      END LOOP;
            
      pStatus    := 'N'; 
      pMessage   := 'Processamento Normal!';
    
    Exception when Others then
      
      pStatus    := 'E'; 
      pMessage   := 'Erro.: '||dbms_utility.format_error_stack;
      
         insert into tdvadm.t_glb_sql(glb_sql_instrucao,glb_sql_dtgravacao,glb_sql_programa) 
         values(pJSVolumes,sysdate, 'invent');
         commit;
   
    End;
            
  End Sp_Arm_InserePessagemSorter;
  
  Procedure Sp_AtualizaPesoSorter(pNotaSequencia in tdvadm.t_arm_nota.arm_nota_sequencia%type)
  As
  Begin
    
       update tdvadm.t_arm_nota n
          set n.arm_nota_pesobalanca = ( select k.arm_nota_peso
                                           from tdvadm.t_arm_notapesagem k
                                          where k.arm_nota_sequencia = pnotasequencia )
          where 0=0
            and n.arm_nota_sequencia = pnotasequencia;

  End Sp_AtualizaPesoSorter;
  
begin
     execute immediate ( ' ALTER SESSION set NLS_DATE_FORMAT = "DD/MM/YYYY" '   ||
                                          ' NLS_LANGUAGE = AMERICAN '          ||
                                          ' NLS_TERRITORY = AMERICA  '         ||
                                          ' NLS_DUAL_CURRENCY = WE8ISO8859P1 ' ||
                                          ' NLS_NUMERIC_CHARACTERS = ".," ' );
end pkg_arm_NotaPesagem;
/
