create or replace package pkg_acc_vales is


/********************************************************************************************************************/
/*                                          RELAÇÃO DE FUNÇÕES PÚBLICAS                                             */
/********************************************************************************************************************/ 
  

/********************************************************************************************************************/
/*                                          RELAÇÃO DE PROCEDUREA PÚBLICAS                                          */
/********************************************************************************************************************/ 
--Procedure utilizada para gerar o arquivo XML de Carga Inicial
Procedure SP_GET_CARGAINICIAL( pParamsEntrada  In Varchar2,
                               pStatus         Out Char,
                               pMessage        Out Varchar2,
                               pParamsSaida    Out Clob
                             );  
                             
--Procedure utilizada para gerar XML para preencher Grid do Formulário de Consulta.
Procedure SP_PSQ_AUXILIAR( pParamsEntrada  In Varchar2,
                            pStatus         Out Char,
                               pMessage        Out Varchar2,
                               pParamsSaida    Out Clob
                             );

--Procedure utilizada para gerar Arquivo XML com a pesquisa de vales. 
Procedure SP_PSQ_Vales( pParamsEntrada  In Varchar2,
                        pStatus         Out Char,
                        pMessage        Out Varchar2,
                        pParamsSaida    Out Clob
                      );
                             
--Procedure utilizada efetuar a Inserção de novos vales.
Procedure SP_Set_Vales( pParamsEntrada  In Varchar2,
                        pStatus         Out Char,
                        pMessage        Out Varchar2,
                        pParamsSaida    Out Clob
                      );

--Procedure utilizada para flegar a data de impressão de um Vale
Procedure sp_set_DtImpressaoVale( pParamsEntrada   In Varchar2,
                                  pStatus          Out Char,
                                  pMessage         Out Varchar
                                );  


procedure sp_ExcluirVales( pAcao    in char,
                           pData    in Date, 
                           pStatus  out char,
                           pMessage out varchar2
                         );                                             
                       
       
end pkg_acc_vales;

 
/
create or replace package body pkg_acc_vales Is

/**************************************************************************************************************************/
/*                              CONSTANTES PRIVADAS UTILIZADAS POR ESSA APLICACAO                                         */
/**************************************************************************************************************************/
--Tipos de Consulta
ConsRota       constant     char(01) := 'R';
ConsMotorista  Constant     Char(01) := 'M';
ConsCaixa      Constant     Char(01) := 'C';

--Tipos de Filtro
fltCodigo      Constant     Char(01) := 'c';
fltDescricao   Constant     Char(01) := 'd';
fltTudo        Constant     Char(01) := 't';

--tipo com o nome da aplicação
cAplicacao  Constant Char(10) := 'acctblvale';

          

/**************************************************************************************************************************/
/*                                 TIPOS PRIVADOS UTILIZADOS POR ESSA APLICACAO                                           */
/**************************************************************************************************************************/
--Tipo que será utilizado como estrutura do XML / Cursor de Consulta Auxiliar.
Type tCursorPSQAuxiliar Is Record ( Codigo               Varchar2(20),
                                    Descricao            Varchar(100)
                                   );

--Tipo que será utilizado como estruturo do XML / CURSOR de Consulta de Vales.
Type tCursorVales Is Record( vale_numero         tdvadm.t_acc_vales.acc_vales_numero%Type,          -- Number(06)
                             motorista_codigo    tdvadm.t_acc_vales.frt_motorista_codigo%Type,      -- char(06)
                             motorista_nome      tdvadm.t_frt_motorista.frt_motorista_nome%Type,    -- varchar2(50) 
                             vale_dataGrav       tdvadm.t_acc_vales.acc_vales_datagrav%Type,        -- Date
                             vale_dataVale       tdvadm.t_acc_vales.acc_vales_data%Type,            -- Date
                             vale_valor          tdvadm.t_acc_vales.acc_vales_valor%Type,           -- Numeric(14,2)
                             vale_desinencia     tdvadm.t_acc_vales.acc_vales_flagpess%Type,        -- char(02)
                             caixa_opCodigo      tdvadm.t_cax_operacao.cax_operacao_codigo%Type,    -- char(04)
                             caixa_opDescr       tdvadm.t_cax_operacao.cax_operacao_descricao%Type, -- Varchar2(50)
                             vale_observacao     tdvadm.t_acc_vales.acc_vales_observacao%Type,      -- Varchar2(255)
                             rota_codigo         tdvadm.t_glb_rota.glb_rota_codigo%Type,            -- char(03) 
                             rota_descricao      tdvadm.t_glb_rota.glb_rota_descricao%Type,         -- Varchar2(50)
                             rota_operCodigo     tdvadm.t_glb_rota.glb_rota_codigo%Type,            -- Char(03)
                             rota_operDesc       tdvadm.t_glb_rota.glb_rota_descricao%Type,         -- Varchar2(50)
                             usuCriou_codigo     tdvadm.t_usu_usuario.usu_usuario_codigo%Type,      --char(10)  
                             usuCriou_nome       tdvadm.t_usu_usuario.usu_usuario_nome%Type,        --Varchar2(50) 
                             flag_permissao      Char(1),
                             caixa_boletim       tdvadm.t_acc_vales.cax_boletim_data%Type,          --Date
                             caixa_movSeq        tdvadm.t_acc_vales.cax_movimento_sequencia%Type,    --number(8)  
                             caixa_rota          tdvadm.t_acc_vales.glb_rota_codigocax%type,
                             acc_numero          tdvadm.t_acc_vales.acc_acontas_numero%Type,
                             acc_ciclo           tdvadm.t_acc_vales.acc_contas_ciclo%Type
                           );   
                            
/********************************************************************************************************************/
/*                                          RELAÇÃO DE FUNÇÕES PRIVADAS                                             */
/********************************************************************************************************************/ 
----------------------------------------------------------------------------------------------------------------------
-- Função utilizada para Gerar arquivo XML da Consulta Auxiliar                                                     --
----------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_PSQAuxiliar( pDados    tCursorPSQAuxiliar,
                              pLinha    Integer,
                              pTabela   Char Default 'Consulta'
                            ) Return  pkg_glb_common.tRetornoFunc Is
  --Variável do tipo de Linha da Tabela Auxiliar de XML, 
  vLinhaXml   t_tmp_auxiliarxml%Rowtype;
  
  --Variável utilizada apenas para montar a linha do XML
  vXmlInsert Varchar2(32000) := '';
  
  --Variável que será utilizada como retorno da função
  vRetorno  pkg_glb_common.tRetornoFunc;
Begin
  --Limpo as variáveis que serão utilizadas durante o processamento.
  vRetorno.Status := '';
  vRetorno.Message := '';  


  --Caso o valor de linha seja maior que zero
  If pLinha > 0 Then
    vXmlInsert := vXmlInsert || '<row num=§'  || Trim( to_char(pLinha) )  || '§ >';
    vXmlInsert := vXmlInsert || '<codigo>'    || Trim( pDados.Codigo )    || '</codigo>';
    vXmlInsert := vXmlInsert || '<descricao>' || Trim( pkg_glb_common.FN_LIMPA_CAMPO( pDados.Descricao ) ) || '</descricao>';
    vXmlInsert := vXmlInsert || '</row>';
  Else
    --Caso a variável de linha seja zero, envia uma linha zerada.
    vXmlInsert := vXmlInsert || '<row num=§0§>';
    vXmlInsert := vXmlInsert || '<codigo />'   ;
    vXmlInsert := vXmlInsert || '<descricao />';
    vXmlInsert := vXmlInsert || '</row>'       ;
  End If;
  
  Begin
    --Popula a variável utilizada para inserção
    vLinhaXml.Tmp_Auxiliarxml_Linha   := pLinha;
    vLinhaXml.Tmp_Auxiliarxml_Tabnome := pTabela;
    vLinhaXml.Tmp_Auxiliarxml_Conteudo := vXmlInsert;
    
    --Faz o insert na tabela temporária.
    Insert Into t_tmp_auxiliarxml Values vLinhaXml;
    Commit;
    
    --Seto as Variáveis de retorno.
    vRetorno.Status := pkg_glb_common.Status_Nomal;
    vRetorno.Message := '';
    
  Exception
    --Caso ocorra algum erro, Seto a variável como erro, e gero mensagem 
    When Others Then
      vRetorno.Status := pkg_glb_common.Status_Erro;
      vRetorno.Message := 'Erro ao tentar gerar arquivo XML.' || chr(13) || sqlerrm || chr(13) || dbms_utility.format_call_stack;
  End;  
  
  --Devolvo a variável preenchida.
  return vRetorno;
  
End FNP_Xml_PSQAuxiliar;

----------------------------------------------------------------------------------------------------------------------
-- Função utilizada para Gerar arquivo XML da Consulta de vales                                                     --
----------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_Vales( pDados     tCursorVales,
                        pLinha     Integer,
                        pTabela    Char   Default  'ConsVale'
                       ) 
                       Return pkg_glb_common.tRetornoFunc Is

 --Variável que será utilizada como retornor da função.
 vRetorno  pkg_glb_common.tRetornoFunc;
 
 --Variáve que sera utilizada para montar o arquivo XML
 vXmlRetorno   Varchar2(10000) := '';
 
 --Variável do tipo de linha que será utilizada para facilitar o insert.
 vLinhaXml   t_tmp_auxiliarxml%Rowtype;


 
 
Begin
  --Limpa a variável as variáveis que serão utilizadas na função.
  vRetorno.Status := '';
  vRetorno.Message := '';
  
  --Caso a linha seja maior que zero.
  If pLinha > 0 Then
    --populo a variável de retorno com o conteudo do paramentro passado
    vXmlRetorno := vXmlRetorno || '<row num=§'         ||   Trim( to_char(pLinha) )                                 || '§ >'                ;
    vXmlRetorno := vXmlRetorno || '<vale_numero>'      ||   Trim( to_char(pDados.vale_numero))                      || '</vale_numero>'     ;
    vXmlRetorno := vXmlRetorno || '<motorista_codigo>' ||   pDados.motorista_codigo                                 || '</motorista_codigo>';
    vXmlRetorno := vXmlRetorno || '<motorista_nome>'   ||   pkg_glb_common.FN_LIMPA_CAMPO( pDados.motorista_nome )  || '</motorista_nome>'  ; 
    vXmlRetorno := vXmlRetorno || '<vale_dataGrav>'    ||   Trim( to_char( pDados.vale_dataGrav, 'dd/mm/yyyy'))     || '</vale_dataGrav>'   ;
    vXmlRetorno := vXmlRetorno || '<vale_dataVale>'    ||   Trim( to_char( pDados.vale_dataVale, 'dd/mm/yyyy'))     || '</vale_dataVale>'   ;
    vXmlRetorno := vXmlRetorno || '<vale_valor>'       ||   Trim( to_char( pDados.vale_valor ))                     || '</vale_valor>'      ;
    vXmlRetorno := vXmlRetorno || '<vale_desinencia>'  ||   pDados.vale_desinencia                                  || '</vale_desinencia>' ;
    vXmlRetorno := vXmlRetorno || '<caixa_opCodigo>'   ||   pDados.caixa_opCodigo                                   || '</caixa_opCodigo>'  ;
    vXmlRetorno := vXmlRetorno || '<caixa_opDescr>'    ||   pkg_glb_common.FN_LIMPA_CAMPO(pDados.caixa_opDescr)     || '</caixa_opDescr>'   ;
    vXmlRetorno := vXmlRetorno || '<vale_observacao>'  ||   pkg_glb_common.FN_LIMPA_CAMPO(pDados.vale_observacao)   || '</vale_observacao>' ;
    vXmlRetorno := vXmlRetorno || '<vale_Caixa>'       ||   pDados.caixa_rota || '-' || Trim( to_char( pDados.caixa_boletim, 'dd/mm/yyyy'))  || '</vale_Caixa>' ;
    vXmlRetorno := vXmlRetorno || '<rota_codigo>'      ||   pDados.rota_codigo                                      || '</rota_codigo>'     ; 
    vXmlRetorno := vXmlRetorno || '<rota_descricao>'   ||   pkg_glb_common.FN_LIMPA_CAMPO( pDados.rota_descricao )  || '</rota_descricao>'  ;
    vXmlRetorno := vXmlRetorno || '<rota_operCodigo>'  ||   pDados.rota_operCodigo                                  || '</rota_operCodigo>' ;
    vXmlRetorno := vXmlRetorno || '<rota_operDesc>'    ||   pkg_glb_common.FN_LIMPA_CAMPO( pDados.rota_operDesc )   || '</rota_operDesc>'   ;
    vXmlRetorno := vXmlRetorno || '<usuCriou_codigo>'  ||   pDados.usuCriou_codigo                                  || '</usuCriou_codigo>' ;
    vXmlRetorno := vXmlRetorno || '<usuCriou_nome>'    ||   pkg_glb_common.FN_LIMPA_CAMPO(pDados.usuCriou_nome)     || '</usuCriou_nome>'   ;
    vXmlRetorno := vXmlRetorno || '<flag_permissao>'   ||   pDados.flag_permissao                                   || '</flag_permissao>'  ;

    vXmlRetorno := vXmlRetorno || '<caixa_boletim>'   ||   to_char(pDados.caixa_boletim, 'DD/MM/YYYY')                                    || '</caixa_boletim>'  ;
    vXmlRetorno := vXmlRetorno || '<caixa_movSeq>'   ||   TO_CHAR(pDados.caixa_movSeq)                                     || '</caixa_movSeq>'  ;

    vXmlRetorno := vXmlRetorno || '<acc_numero>'   ||   Trim(pDados.acc_numero)                                     || '</acc_numero>'  ;
    vXmlRetorno := vXmlRetorno || '<acc_ciclo>'    ||   Trim(pDados.acc_ciclo)                                     || '</acc_ciclo>'  ;


--acc_numero          tdvadm.t_acc_vales.acc_acontas_numero%Type,
--acc_ciclo           tdvadm.t_acc_vales.acc_contas_ciclo%Type

    
    vXmlRetorno := vXmlRetorno || '</row>'; 
  Else
    --Caso a linha seja zero, gerar uma linha em branco para o arquivo xml
    vXmlRetorno := vXmlRetorno || '<row num=§0§>'       ;
    vXmlRetorno := vXmlRetorno || '<vale_numero />'     ;
    vXmlRetorno := vXmlRetorno || '<motorista_codigo />';
    vXmlRetorno := vXmlRetorno || '<motorista_nome />'  ;
    vXmlRetorno := vXmlRetorno || '<vale_dataGrav />'   ;
    vXmlRetorno := vXmlRetorno || '<vale_dataVale />'   ;
    vXmlRetorno := vXmlRetorno || '<vale_valor />'      ;
    vXmlRetorno := vXmlRetorno || '<vale_desinencia />' ;
    vXmlRetorno := vXmlRetorno || '<caixa_opCodigo />'  ;
    vXmlRetorno := vXmlRetorno || '<caixa_opDescr />'   ;
    vXmlRetorno := vXmlRetorno || '<vale_observacao />' ;
    vXmlRetorno := vXmlRetorno || '<vale_Caixa />'       ;
    vXmlRetorno := vXmlRetorno || '<rota_codigo />'     ;
    vXmlRetorno := vXmlRetorno || '<rota_descricao />'  ;
    vXmlRetorno := vXmlRetorno || '<rota_operCodigo />' ;
    vXmlRetorno := vXmlRetorno || '<rota_operDesc />'   ;
    vXmlRetorno := vXmlRetorno || '<usuCriou_codigo />' ;
    vXmlRetorno := vXmlRetorno || '<usuCriou_nome />'   ;
    vXmlRetorno := vXmlRetorno || '<flag_permissao />'  ;
    vXmlRetorno := vXmlRetorno || '</row>'              ;
  End If;

  
  
  

  --Caso o valor do paramentro de linha seja maior que zero
  Begin
    --Populo a variável utilizada para inserção.
    vLinhaXml.Tmp_Auxiliarxml_Linha    := pLinha;
    vLinhaXml.Tmp_Auxiliarxml_Tabnome  := pTabela;
    vLinhaXml.Tmp_Auxiliarxml_Conteudo := vXmlRetorno;
    
    --faz o insert na tabela temporária.
    Insert Into t_tmp_auxiliarxml Values vLinhaXml;
    Commit;
    
    --Caso tenha ocorrido tudo bem na inserção, defino o retorno como normal, e sem mensam.
    vRetorno.Status := pkg_glb_common.Status_Nomal;
    vRetorno.Message := '';
    
  Exception
    When Others Then
      --Caso ocorral qualquer durante a inserção, defino o paramentro de status para negativo, e crio uma mensagem de retorno.
      vRetorno.Status := pkg_glb_common.Status_Erro;
      vRetorno.Message := 'Erro ao tentar gerar arquivo XML.' || chr(13) || sqlerrm || chr(13) || dbms_utility.format_call_stack;
  End;
  
  --devolva varia´vel preenchida.
  Return vRetorno;
  
End;                       
                           

----------------------------------------------------------------------------------------------------------------------
-- Função utilizada para definir o Sql que será utilizado no Cursor de Consulta Auxiliar.                           --
----------------------------------------------------------------------------------------------------------------------
Function FNP_SQL_PSQAuxiliar( pTpConsulta   char,
                              pTpFiltro     Char,
                              pCodConsulta  Char
                            ) return Varchar2 is

 --Variável utilizada como retorno da Função.
 vRetorno   Varchar2(32000) := '';
 
Begin
  ------------------------------------------------------------------
  -- QUANDO O TIPO DA CONSULTA FOR POR "OPERAÇÃO DE CAIXA"        --
  ------------------------------------------------------------------
  If pTpConsulta = ConsCaixa Then
    vRetorno := ' ';
    vRetorno := vRetorno || ' SELECT                           ';
    vRetorno := vRetorno || '   D.CAX_OPERACAO_CODIGO,           ';
    vRetorno := vRetorno || '   D.ACC_TPDESPESAS_DESPESA         ';
    vRetorno := vRetorno || ' FROM                             '; 
    vRetorno := vRetorno || '   T_ACC_TPDESPESAS D                 ';
    vRetorno := vRetorno || ' WHERE                            ';
    vRetorno := vRetorno || '   0=0                            ';
    
    --Verifico os tipos de filro
    --Filtro por código
    If nvl( Trim(pTpFiltro), 'R') = fltCodigo Then
      vRetorno := vRetorno || ' AND to_char(D.CAX_OPERACAO_CODIGO) = §'|| Trim(pCodConsulta) ||'§ ';
    End If;

    
    --Filtro por descricao
    If nvl( Trim(pTpFiltro), 'R') = fltDescricao Then
      vRetorno := vRetorno || '  AND upper(D.ACC_TPDESPESAS_DESPESA) LIKE §%' || Trim(upper(pCodConsulta))  || '%§ ';
    End If;
    
    --Sem Filtro
    If nvl( Trim(pTpFiltro), 'R') = fltTudo Then
      vRetorno := vRetorno || 'AND  0=0   ';
    End If;
    
     
  vRetorno := vRetorno  || 'Order By D.ACC_TPDESPESAS_DESPESA ';
  End If;
  
  ----------------------------------------------------------------
  -- QUANDO O TIPO DA CONSULTA FOR POR "MOTORISTA"              --
  ----------------------------------------------------------------
  If pTpConsulta = ConsMotorista Then
    vRetorno := vRetorno || ' SELECT                           ';
    vRetorno := vRetorno || '   FRT_MOTORISTA_CODIGO,           ';
    vRetorno := vRetorno || '   Trim(FRT_MOTORISTA_NOME)       ';
    vRetorno := vRetorno || '  FROM                            ';
    vRetorno := vRetorno || '   V_FRT_MOTORISTA2 MM             ';
    vRetorno := vRetorno || '  WHERE                           ';
    
    --Verifico os tipos de filro
    --Filtro por código
    If nvl( Trim(pTpFiltro), 'R') = fltCodigo Then
      vRetorno := vRetorno || ' MM.FRT_MOTORISTA_CODIGO like §%' || Trim(pCodConsulta)  || '%§ ';
    End If;
    
    --Filtro por descricao
    If nvl( Trim(pTpFiltro), 'R') = fltDescricao Then
      vRetorno := vRetorno || ' MM.FRT_MOTORISTA_NOME LIKE  §%' || Trim(pCodConsulta) || '%§ ';
    End If;
    
    --Sem Filtro
    If nvl( Trim(pTpFiltro), 'R') = fltTudo Then
      vRetorno := vRetorno || ' 0=0   ';
    End If;
    
    vRetorno := vRetorno || ' order by mm.FRT_MOTORISTA_NOME ';
    

  End If;
  
  ----------------------------------------------------------------
  -- QUANDO O TIPO DA CONSULTA FOR POR "ROTA"                   --
  ----------------------------------------------------------------
  If pTpConsulta = ConsRota Then
    vRetorno := vRetorno || ' SELECT                    ';
    vRetorno := vRetorno || '   rr.glb_rota_codigo,     ';
    vRetorno := vRetorno || '   rr.glb_rota_descricao   ';
    vRetorno := vRetorno || ' FROM                      ';  
    vRetorno := vRetorno || '   t_glb_rota    rr        ';
    vRetorno := vRetorno || ' WHERE                     ';    
    
    --Verifico o Tipo de filtro, 
    --Filtro por código
    If nvl( Trim(pTpFiltro), 'R') = fltCodigo Then
      vRetorno := vRetorno || '   rr.glb_rota_codigo = §' || Trim(pCodConsulta)  || '§ ';
    End If;
    
    --Filtro por descricao
    If nvl( Trim(pTpFiltro), 'R') = fltDescricao Then
      vRetorno := vRetorno || ' rr.glb_rota_deScricao  like §%'|| upper(Trim(pCodConsulta))  ||'%§   ';
    End If;
    
    --Sem Filtro
    If nvl( Trim(pTpFiltro), 'R') = fltTudo Then
      vRetorno := vRetorno || ' 0=0   ';
    End If;
    
    --Define a ordem do select.
    vRetorno := vRetorno || ' ORDER BY                  ';
    vRetorno := vRetorno || '   rr.glb_rota_codigo      ';          
  end if; 
  
  --substitui os caracteres coringas
  vRetorno := Replace(vRetorno, '§', '''');
  
  
  DBMS_OUTPUT.put_line( VrETORNO);

  --Devolvo a Variável preenchida.
  return vRetorno;
  
  
  /*
  If FlagChamada = 'ROTA' then
     Begin
        with Dtm_Vales.Q_Geral do
        begin
           close;
           sql.Clear;
           sql.add('SELECT GLB_ROTA_CODIGO CODIGO,');
           sql.add('       GLB_ROTA_DESCRICAO DESCRICAO');
           sql.add('  FROM T_GLB_ROTA');
           if R_SelGeral.ItemIndex = 0 then
              sql.add(' WHERE GLB_ROTA_CODIGO like '''+E_Codigo.Text+'%''');
           if R_SelGeral.ItemIndex = 1 then
              sql.add(' WHERE GLB_ROTA_DESCRICAO LIKE ''%'+E_Descricao.Text+'%''');
           sql.add('ORDER BY GLB_ROTA_CODIGO');
           open;
        end;
     end
     else
     begin
        if (FlagChamada = 'MOTORISTA') OR (FlagChamada = 'MOTORISTA2') Then
        begin
           with Dtm_Vales.Q_Geral do
           begin
              close;
              sql.Clear;
              sql.add('SELECT FRT_MOTORISTA_CODIGO CODIGO,');
              sql.add('       LTRIM(RTRIM(FRT_MOTORISTA_NOME))   DESCRICAO');
              sql.add('  FROM V_FRT_MOTORISTA2');
              if R_SelGeral.ItemIndex = 0 then
              begin
                 sql.add(' WHERE FRT_MOTORISTA_CODIGO like '''+E_Codigo.Text+'''');
                 //sql.add('GROUP BY LTRIM(RTRIM(FRT_MOTORISTA_NOME))');
                 sql.add('ORDER BY FRT_MOTORISTA_CODIGO');

              end;
              if R_SelGeral.ItemIndex = 1 then
              begin
                 sql.add(' WHERE FRT_MOTORISTA_NOME LIKE ''%'+E_Descricao.Text+'%''');
                 //sql.add('GROUP BY LTRIM(RTRIM(FRT_MOTORISTA_NOME))');
                 sql.add('ORDER BY LTRIM(RTRIM(FRT_MOTORISTA_NOME))');
              end;
              if R_SelGeral.ItemIndex = 2 then
              begin
                 //sql.add('GROUP BY LTRIM(RTRIM(FRT_MOTORISTA_NOME))');
                 sql.add('ORDER BY LTRIM(RTRIM(FRT_MOTORISTA_NOME))');

              end;
              open;
           end;
        end
        else
        begin
           if FlagChamada = 'CAIXA' then
           begin
             with Dtm_Vales.Q_Geral do
              begin
                 close;
                 sql.Clear;
                 sql.Add('SELECT GLB_ROTA_CODIGO_OPERACAO,');
                 sql.Add('       CAX_OPERACAO_CODIGO CODIGO,');
                 sql.Add('       CAX_OPERACAO_DESCRICAO DESCRICAO');
                 sql.Add('  FROM T_CAX_OPERACAO');
                 sql.Add('  WHERE GLB_ROTA_CODIGO_OPERACAO = ''015''');
                 if R_SelGeral.ItemIndex = 0 then
                    sql.Add(' AND CAX_OPERACAO_CODIGO like '''+E_Codigo.Text+'%''');
                 if R_SelGeral.ItemIndex = 1 then
                    sql.add(' AND CAX_OPERACAO_DESCRICAO LIKE ''%'+E_Descricao.Text+'%''');
                 sql.Add('ORDER BY CAX_OPERACAO_DESCRICAO');
                 open;
                 if RecordCount = 0 then
                 begin
                    close;
                    sql.Clear;
                    sql.Add('SELECT GLB_ROTA_CODIGO_OPERACAO,');
                    sql.Add('       CAX_OPERACAO_CODIGO CODIGO,');
                    sql.Add('       CAX_OPERACAO_DESCRICAO DESCRICAO');
                    sql.Add('  FROM T_CAX_OPERACAO');
                    sql.Add('  WHERE GLB_ROTA_CODIGO_OPERACAO = ''000''');
                    if R_SelGeral.ItemIndex = 0 then
                       sql.Add(' AND CAX_OPERACAO_CODIGO like '''+E_Codigo.Text+'%''');
                    if R_SelGeral.ItemIndex = 1 then
                       sql.add(' AND CAX_OPERACAO_DESCRICAO LIKE ''%'+E_Descricao.Text+'%''');
                    sql.Add('ORDER BY CAX_OPERACAO_DESCRICAO');
                    open;
                 end;
              end;
           end;
        end;
     end;
     while not Dtm_Vales.Q_Geral.Eof do
     begin
        Dtm_Vales.Q_Geral.Next;
    end;
     }
  
  
  
  */
End FNP_SQL_PSQAuxiliar;

----------------------------------------------------------------------------------------------------------------------
-- Função utilizada para definir o Sql que será utilizado no Cursor de Consulta de vales.                           --
----------------------------------------------------------------------------------------------------------------------
Function FNP_SQL_PSQVales( pVale_Numero      tdvadm.t_acc_vales.acc_vales_numero%Type,
                           pRota_codigo      tdvadm.t_glb_rota.glb_rota_codigo%Type,
                           pMotorista_codigo tdvadm.t_acc_vales.frt_motorista_codigo%Type,
                           pDtInicial        Varchar2,
                           pDtFinal          Varchar2,
                           pPendImpressao    Char
                           
                          ) Return Varchar2 Is
 --Variável que será utilizada como retorno da função
 vRetorno Varchar2(32000) := '';
Begin
  vRetorno := vRetorno || ' SELECT                                                                           '; 
  vRetorno := vRetorno || '   vale.ACC_VALES_NUMERO,                                                         ';
  vRetorno := vRetorno || '   vale.FRT_MOTORISTA_CODIGO,                                                     ';
  vRetorno := vRetorno || '   motorista.FRT_MOTORISTA_NOME,                                                  ';
  vRetorno := vRetorno || '   vale.acc_vales_datagrav,                                                       ';
  vRetorno := vRetorno || '   vale.acc_vales_data,                                                           ';
  vRetorno := vRetorno || '   vale.acc_vales_valor,                                                          ';
  vRetorno := vRetorno || '   vale.acc_vales_flagpess,                                                       ';
  vRetorno := vRetorno || '   vale.cax_operacao_codigo,                                                      ';
  vRetorno := vRetorno || '   caixa.cax_operacao_descricao,                                                  ';
  vRetorno := vRetorno || '   vale.acc_vales_observacao,                                                     ';
  vRetorno := vRetorno || '   rota.glb_rota_codigo,                                                          ';
  vRetorno := vRetorno || '   rota.glb_rota_descricao,                                                       ';
  vRetorno := vRetorno || '   rotaOperacao.Glb_Rota_Codigo,                                                  ';
  vRetorno := vRetorno || '   rotaOperacao.Glb_Rota_Descricao,                                               ';
  vRetorno := vRetorno || '   usuario.usu_usuario_codigo,                                                    ';
  vRetorno := vRetorno || '   usuario.usu_usuario_nome,                                                      ';

  vRetorno := vRetorno || '   Decode(Nvl(vale.CAX_MOVIMENTO_SEQUENCIA, -1), -1, §S§, §N§),                    ';
  vRetorno := vRetorno || '   vale.CAX_BOLETIM_DATA,                                                          ';  
  vRetorno := vRetorno || '   vale.CAX_MOVIMENTO_SEQUENCIA,                                                    ';  
  vRetorno := vRetorno || '   vale.GLB_ROTA_CODIGOCAX,                                                        ';
  vRetorno := vRetorno || '   vale.acc_acontas_numero,                                                    ';  
  vRetorno := vRetorno || '   vale.acc_contas_ciclo                                                    ';  

  vRetorno := vRetorno || ' FROM                                                                             ';
  vRetorno := vRetorno || '   T_ACC_VALES       vale,                                                        ';
  vRetorno := vRetorno || '   v_frt_motorista2   motorista,                                                   ';
  vRetorno := vRetorno || '   t_cax_operacao    caixa,                                                       ';
  vRetorno := vRetorno || '   t_glb_rota        rotaOperacao,                                                ';
  vRetorno := vRetorno || '   t_glb_rota        rota,                                                        ';
  vRetorno := vRetorno || '   t_usu_usuario     usuario                                                      ';
  vRetorno := vRetorno || ' WHERE                                                                            ';
  vRetorno := vRetorno || '   ACC_VALES_NUMERO IS NOT Null                                                   ';
  vRetorno := vRetorno || '   And Trim(vale.Frt_Motorista_Codigo) = Trim(motorista.FRT_MOTORISTA_CODIGO(+))  ';
  vRetorno := vRetorno || '   And vale.glb_rota_codigo_operacao = caixa.glb_rota_codigo_operacao(+)             ';
  vRetorno := vRetorno || '   And vale.cax_operacao_codigo = caixa.cax_operacao_codigo(+)                       ';
  vRetorno := vRetorno || '   And vale.glb_rota_codigo_operacao = rotaOperacao.Glb_Rota_Codigo(+)               ';
  vRetorno := vRetorno || '   And vale.glb_rota_codigo = rota.glb_rota_codigo                                ';
  vRetorno := vRetorno || '   And vale.acc_vales_usucriou = usuario.usu_usuario_codigo                       ';
--  vRetorno := vRetorno || '   And trunc( vale.ACC_VALES_DATA ) >= trunc(sysdate) - 120                        ';

  If ( nvl(Trim(pPendImpressao), 'R') <> 'R' ) Then 
    vRetorno := vRetorno || '   and nvl(Trim(acc_vales_impressao), §N§) = §' || Trim( pPendImpressao ) || '§             ';              
  End If;  
  
  --Verifico se foi passados algum paramento para gerar filtro.
  If nvl(pVale_Numero, 1) <> 1 Then
    vRetorno := vRetorno || ' AND vale.ACC_VALES_NUMERO = ' || pVale_Numero || '  ';
  End If;
  
  If nvl(Trim(pRota_codigo), 'R') <> 'R' and ( nvl(Trim(pRota_codigo), 'R') <> '010' ) Then
    vRetorno := vRetorno || ' AND vale.GLB_ROTA_CODIGO = §'|| Trim( pRota_codigo )  ||'§ ';
  End If;
  
  If nvl( Trim(pMotorista_codigo), 'R') <> 'R' Then
    vRetorno := vRetorno || ' AND vale.FRT_MOTORISTA_CODIGO = §'|| Trim( pMotorista_codigo ) ||'§ ';
  End If;
  -- para não retornar todos os vales limitador de data
  vRetorno := vRetorno || ' and trunc( vale.ACC_VALES_DATA ) >= to_date(§' || Trim('01/01/2007') || '§, §dd/mm/yyyy§ ) ';
  
  If ( nvl( Trim(pDtInicial), '30/12/1899' ) <> '30/12/1899' ) Then 
    vRetorno := vRetorno || ' and trunc( vale.ACC_VALES_DATA ) >= to_date(§' || Trim( pDtInicial ) || '§, §dd/mm/yyyy§ ) ';
  End If;
  
  If ( nvl( Trim(pDtFinal), '30/12/1899' ) <> '30/12/1899' ) Then  
    vRetorno := vRetorno || ' and trunc( vale.ACC_VALES_DATA ) <= to_date(§' || Trim( pDtFinal )   || '§, §dd/mm/yyyy§ ) ';
  End If;
  
--   vRetorno := vRetorno || ' order by Vale.Acc_Vales_Data,Vale.Acc_Vales_Numero ';

  --Substitui os caracteres coringas.
  vRetorno :=  Replace( vRetorno, '§', '''');
  
  dbms_output.put_line(vRetorno);
  
  --Devolve a variável preenchida.
  Return vRetorno;
  
  
End FNP_SQL_PSQVales;  


Function fn_VerificaCxAcertoFechado(pVale_Numero    t_acc_vales.acc_vales_numero%Type,
                                    pVale_Rota      t_glb_rota.glb_rota_codigo%Type )
       return char is
   vDataCxFechAcerto date;
   vDataVale  date;
Begin
   
  select P.USU_PERFIL_PARAD1
    into vDataCxFechAcerto
  from tdvadm.t_usu_perfil p
  where p.usu_aplicacao_codigo = 'caxmvtmovt'
    AND P.USU_PERFIL_CODIGO = 'REFFECHAMENTOCAX' || TDVADM.PKG_CTB_CAIXA.fn_get_CaixaAcertoContas;

 select v.acc_vales_data
   into vDataVale
 from tdvadm.t_acc_vales v
 where v.acc_vales_numero = pVale_Numero
   and v.glb_rota_codigo = pVale_Rota;
  
 If vDataVale > vDataCxFechAcerto Then
    -- Caixa do Acerto aberto para a Data
    Return 'N';
 Else
   -- Caixa Fechado para a Data
   Return 'S';
 End If; 

  
End fn_VerificaCxAcertoFechado;       
       

Function fn_VerificaValeemCx(pVale_Numero    t_acc_vales.acc_vales_numero%Type,
                             pVale_Rota      t_glb_rota.glb_rota_codigo%Type )
       return char is
   vAuxiliar number;
Begin
   
 select count(*)
   into vAuxiliar
 from tdvadm.t_acc_vales v
 where v.acc_vales_numero = pVale_Numero
   and v.glb_rota_codigo = pVale_Rota
   and v.cax_boletim_data is null;
  
 If vAuxiliar = 1 Then
    -- Vale nao lancado em caixa
    Return 'N';
 Else
   -- Vale ja esta em caixa
   Return 'S';
 End If; 

  
End fn_VerificaValeemCx;       


Function fn_VerificaValeemAcerto(pVale_Numero    t_acc_vales.acc_vales_numero%Type,
                                 pVale_Rota      t_glb_rota.glb_rota_codigo%Type )
       return char is
   vAuxiliar number;
Begin
   
 select count(*)
   into vAuxiliar
 from tdvadm.t_acc_vales v
 where v.acc_vales_numero = pVale_Numero
   and v.glb_rota_codigo = pVale_Rota
   and v.acc_acontas_numero is not null;
  
 If vAuxiliar = 1 Then
    -- Vale em Acerto de Contas
    Return 'S';
 Else
   -- Vale Sem Acerto
   Return 'N';
 End If; 

  
End fn_VerificaValeemAcerto;       


Function fn_VerificaValeemCxAberto(pVale_Numero    t_acc_vales.acc_vales_numero%Type,
                                   pVale_Rota      t_glb_rota.glb_rota_codigo%Type )
       return char is
   vAuxiliar char(2);
Begin
   
--Begin
 select tdvadm.pkg_ctb_caixa.fn_get_CaixaAberto(v.glb_rota_codigocax,v.cax_boletim_data)
   into vAuxiliar
 from tdvadm.t_acc_vales v
 where v.acc_vales_numero = pVale_Numero
   and v.glb_rota_codigo = pVale_Rota;
--   and v.cax_boletim_data is null;
--Exception
--  WHEN NO_DATA_FOUND Then
    
--  End ;
    
 If vAuxiliar in ('A','R','N','E') Then
    -- Vale em Caixa Aberto
    Return 'S';
 Else
    -- Vale em Caixa Fechado
   Return 'N';
 End If; 

--
  
End fn_VerificaValeemCxAberto;       






----------------------------------------------------------------------------------------------------------------------
-- Função Privada utilizada para excluir um registro da Tabela de Vales                                             --
----------------------------------------------------------------------------------------------------------------------
Function FNP_DEL_Vales( pVale_Numero    t_acc_vales.acc_vales_numero%Type,
                        pVale_Rota      t_glb_rota.glb_rota_codigo%Type,
                        pPermExcluir    Char,
                        pPermExcluirImp Integer Default '-1'
                       ) Return pkg_glb_common.tRetornoFunc Is

--Variável que será utilizada como retorno da função.
 vRetorno  pkg_glb_common.tRetornoFunc; 
 vValeCaixaAcerto  char(1); 
 vValeCaixaFilial  char(1);
 vCaixaAcertoFechado char(1);
 vValeemCaixa char(1);  
 vValeemAcerto char(1); 
 vCaxAberto  char(1); 
 
 vCaixaRota    tdvadm.t_cax_movimento.glb_rota_codigo%type;
 vCaixaBoletim tdvadm.t_cax_movimento.cax_boletim_data%type;
 vCaixaSeq     tdvadm.t_cax_movimento.cax_movimento_sequencia%type;
 
 vPermExcluir char(1) ;  
 vPermExcluirImp number;      
 vExcluiuVale    number;
 vExcluiuCax     number; 
 vAuxiliar       number;     
Begin
  --Limpo as variáveis que serão utilizadas nessa função;
  vRetorno.Status := '';
  vRetorno.Message := '';
  vRetorno.Controle := 0;
  
 vPermExcluir    := pPermExcluir;
 vPermExcluirImp := pPermExcluirImp;     
  
  
  vCaixaAcertoFechado := fn_VerificaCxAcertoFechado(pVale_Numero,pVale_Rota);
  vCaxAberto          := fn_VerificaValeemCxAberto(pVale_Numero,pVale_Rota);
  vValeemAcerto       := fn_VerificaValeemAcerto(pVale_Numero,pVale_Rota);

  begin
     -- sirlano 19/11/2021
     -- Estava usando a referencia e nao a rota no select
     select count(*)
       into vAuxiliar
     From tdvadm.t_cax_movimento m
     where m.glb_rota_codigo_referencia = pVale_Rota
       and m.cax_movimento_documento = lpad(pVale_Numero,6,'0')
       and m.glb_rota_codigo = '015' ;
  exception
     When OTHERS Then
        raise_application_error(-20001,'Vale ' || lpad(pVale_Numero,6,'0') || '- Rota ' || pVale_Rota || chr(10) || sqlerrm);
     End;
    
  If vAuxiliar > 0 Then
     vValeCaixaAcerto := 'S';
  Else
     vValeCaixaAcerto := 'N';
     vCaixaAcertoFechado := 'N';
  End If;
  
  Begin
  select count(*)
    into vAuxiliar
  From tdvadm.t_cax_movimento m
  where m.glb_rota_codigo_referencia = pVale_Rota
    and m.cax_movimento_documento = lpad(pVale_Numero,6,'0')
    and m.glb_rota_codigo = pVale_Rota ;
  exception
     When OTHERS Then
        raise_application_error(-20001,'Vale ' || lpad(pVale_Numero,6,'0') || '- Rota ' || pVale_Rota || chr(10) || sqlerrm);
     End;
    
  If vAuxiliar > 0 Then
     vValeCaixaFilial := 'S';
  Else
     vValeCaixaFilial := 'N';
     vCaixaAcertoFechado := 'N';
 --    vCaxAberto  := 'N';
  End If;
  
  
  
  -- Sirlano / Alison
  -- 01/07/2021
  If vValeCaixaAcerto = 'S' Then
     vPermExcluir := 'N';
  ElsIf vCaixaAcertoFechado = 'S' Then
     vPermExcluir := 'N';
  ElsIf vValeemAcerto = 'S' Then
      vPermExcluir := 'N';
  ElsIf ( vCaxAberto = 'S') and 
      ( vValeemAcerto = 'N' ) Then
     vPermExcluir := 'S';
     vPermExcluirImp := - 60;
  Else
     vPermExcluir := 'N';
  End If;
  
  --Primeiro verifico se o Usuario possui permissão para excluir o VALE.
  If vPermExcluir <> 'S' Then
    vRetorno.Status := pkg_glb_common.Status_Erro;
    vRetorno.Message := 'Você não tem permissão para excluír vales' || '- CX ACERTO ABERTO-' || vCaixaAcertoFechado ||
                                                                       '- CX FILIAL ABERTO ' ||vCaxAberto ||
                                                                       '- DT ACERTO ABERTA ' ||vValeemAcerto ||
                                                                       '- VALE ROTA 015    ' || vValeCaixaAcerto;
  End If;
  
  --Se o usuario tenha permissão de excluir um Vale.
  If vPermExcluir = 'S' Then
    
    --Verifico se foi passado um número de vale
    If nvl(pVale_Numero, 0) <> 0 Then 
            Begin
                Select vale.glb_rota_codigocax,
                       vale.cax_boletim_data,
                       vale.cax_movimento_sequencia
                  Into vCaixaRota,
                       vCaixaBoletim,
                       vCaixaSeq
                  From tdvadm.t_acc_vales vale
                 Where 0 = 0
                   And vale.acc_vales_numero = pVale_Numero
                   And vale.glb_rota_codigo = pVale_Rota;
                 vRetorno.Controle := 1;
             exception
               When NO_DATA_FOUND Then
                 vRetorno.Controle := 0;
               End ;
            --protejo o bloco de exclusão
             Begin
                


                -- Excluo o registro 
                Delete 
                  From tdvadm.t_acc_vales  vale
                Where
                  0=0
                  And vale.acc_vales_numero = pVale_Numero 
                  And vale.glb_rota_codigo = pVale_Rota;
                  
                vExcluiuVale := sql%rowcount;

                If  vExcluiuVale = 0 Then
                   vRetorno.Status  := tdvadm.pkg_glb_common.Status_Erro;
                   vRetorno.Message := 'Vale não Encontrado para Exclusao. ' || pVale_Numero || '-' || pVale_Rota;
                   rollback; 
                   return vRetorno;             
                end If;
                
              If vValeCaixaFilial = 'S' Then
                    delete tdvadm.t_cax_movimento m
                    where m.glb_rota_codigo         = vCaixaRota
                      and m.cax_boletim_data        = vCaixaBoletim
                      and m.cax_movimento_sequencia = vCaixaSeq;
                 
                      vExcluiuCax := sql%rowcount;  
                    If vExcluiuCax = 0 Then
                         vRetorno.Status  := tdvadm.pkg_glb_common.Status_Erro;
                         vRetorno.Message := 'Lancamento de Caixa não encontrado para Exclusao. Vale ' || pVale_Numero || '-' || pVale_Rota;
                         rollback; 
                          return vRetorno;             
                     end If;
                 End If;             
                  
                Commit;
                
                --preenche as variáveis de retono.
                vRetorno.Status  := pkg_glb_common.Status_Nomal;
                vRetorno.Message := 'Vale Excluído com sucesso';
                
              Exception
                When Others Then
                  --caso ocorra algum erro durante a exclusão do registro.
                  vRetorno.Status := 'W';
                  vRetorno.Message := 'Não foi possivel excluír o registro Vale ' || pVale_Numero || '-' || pVale_Rota || chr(13) || 
                                       Sqlerrm                              || chr(13) || 
                                       dbms_utility.format_call_stack;
              End;  
    Else
      vRetorno.Status := pkg_glb_common.Status_Erro;
      vRetorno.Message := 'Nenhum vale passado para excluisão';  
    End If;
  Else

  If ( vCaixaAcertoFechado = 'S' ) Then
      vRetorno.Status := pkg_glb_common.Status_Erro;
      vRetorno.Message := vRetorno.Message || chr(13) || 'Acerto de Contas fechado para a Data';  
  End If;


  If ( vCaxAberto = 'S') Then
      vRetorno.Status := pkg_glb_common.Status_Erro;
      vRetorno.Message := vRetorno.Message || chr(13) || 'Caixa Aberto, Fechar antes.';  
  End If;


  If ( vValeemAcerto = 'S' ) Then
      vRetorno.Status := pkg_glb_common.Status_Erro;
      vRetorno.Message := vRetorno.Message || chr(13) || 'Vale esta em Acerto.';  
  End If;
  
  
  End If;

  -- Devolvo a variável preenchida.
  Return vRetorno;
  
End FNP_DEL_Vales;     


----------------------------------------------------------------------------------------------------------------------
-- Função utilizada para incluir ou Atualizar um vale.                                                             --
----------------------------------------------------------------------------------------------------------------------
Function FNP_INS_Vales( pVale_numero       t_acc_vales.acc_vales_numero%Type,
                        pVale_data         t_acc_vales.acc_vales_data%Type,
                        pMotorista_codigo  t_acc_vales.frt_motorista_codigo%Type,
                        pVale_valor        t_acc_vales.acc_vales_valor%Type,
                        pDesinencia        t_acc_vales.acc_vales_flagpess%Type,
                        pCaixa_codigo      t_acc_vales.cax_operacao_codigo%Type,
                        pRota_codigo       t_glb_rota.glb_rota_codigo%Type,
                        pVale_obs          t_acc_vales.acc_vales_observacao%Type,
                        pParamsEdicao      Char,
                        pUsuario           t_usu_usuario.usu_usuario_codigo%Type,
                        pRotaUsuario       t_glb_rota.glb_rota_codigo%Type,
                        pAplicacao         t_usu_aplicacao.usu_aplicacao_codigo%Type
                      ) Return pkg_glb_common.tRetornoFunc Is 

 --Variável utilizada como retorno da função.
 vRetorno   pkg_glb_common.tRetornoFunc;
 
 --Variável utilizada para facilitar a inserção.
 vLinha  t_acc_vales%Rowtype;
 
 --Variáveis que serão utilizadas para recuperar valor de saldo e limite
 vSaldo       t_frt_motorista.frt_motorista_saldocredito%Type;
 vLimite      t_frt_motorista.frt_motorista_limitecredito%Type;
 vNomeMotor   t_frt_motorista.frt_motorista_nome%Type;

-- dia 27/02 
 --Variável do tipo de rota de operação
 vGlg_RotaOperacao tdvadm.t_acc_vales.glb_rota_codigo_operacao%Type;
 vTpOperacao   tdvadm.t_acc_vales.acc_tpdespesa_codigo%Type; 
Begin
  --Limpo todas variáveis que serão utilizadas nessa função
  vRetorno.Controle := 0;
  vRetorno.Status := '';
  vRetorno.Message := '';
  vGlg_RotaOperacao := '';
  vTpOperacao := 0; 
  
  Begin
  if to_date(pVale_data,'dd/mm/yyyy') < trunc(sysdate) Then
     vRetorno.Status := 'E';
     vRetorno.Message := 'Data do Vale não pode ser MENOR QUE HOJE, Entre em contato com Acerto de Contas';
     Return vRetorno;
  End If;
  Exception
    When OTHERS Then
       vRetorno.Status := 'E';
       vRetorno.Message := 'Problemas na Data do Vale ' || pVale_data || '-' || sqlerrm;
       Return vRetorno;
      
    End;
    
  --Caso a desinência seja "Não pessoal, obrigatório a indicação de uma conta.
  If nvl(pDesinencia, 'R') = 'N' Then
    If (nvl(pCaixa_codigo, 'O') = 'O' ) Then
      vRetorno.Status := 'W';
      vRetorno.Message := 'Quando o Vale não for pessoal, obrigatório a indicação de uma conta de despesa';
      Return vRetorno;
    Else
      Begin
       --busco o código da operacao + a rota de operação
        Select 
          tpdesp.glb_rota_codigo_operacao,
          tpdesp.acc_tpdespesas_codigo
        Into
          vGlg_RotaOperacao,
          vTpOperacao
        From 
          t_acc_tpdespesas tpdesp
        Where
          tpDesp.Cax_Operacao_Codigo = to_number(pCaixa_codigo)
          and rownum = 1;
          
      Exception
        When no_data_found Then
          raise_application_error(-20001, 'Erro ao buscar dados da operação.');
      End;
        
    End If;
  End If; 
  
  
  If nvl(pDesinencia, 'R') = 'S' Then 
     vGlg_RotaOperacao := '';
     vTpOperacao  := Null;
  End If;
  
   
  
   
     

  
  --Caso não seja passado a desinencia, lança erro.
  If nvl(pDesinencia, 'R') = 'R' Then 
    vRetorno.Status := pkg_glb_common.Status_Erro;
    vRetorno.Message := 'Vale sem desinência';
    Return vRetorno;
  End If;
  
  --vou verificar se o número do vale foi passado
  If ( nvl(pVale_numero, 0) <> 0 ) Then

    --Caso o usuario não tenha permissão para Edição devolve informação de recusa
    if ( pParamsEdicao = 'S' ) Then
      
      --Verifico se na tabela tem um registro com o número do vale.
      Select 
        Count(*) Into vRetorno.Controle
      From 
        t_acc_vales vale
      Where
        0=0
        And vale.acc_vales_numero = pVale_numero
        And nvl(vale.CAX_MOVIMENTO_SEQUENCIA, -1) = -1
        And nvl(vale.acc_vales_impressao, 'N') = 'N';
        
      --Caso não enconre o vale, é porque já entrou no acerto.
      If vRetorno.Controle = 0 Then
        vRetorno.Status := pkg_glb_common.Status_Erro;
        vRetorno.Message := 'Vale Número:' || pVale_numero || ' não pode ser atualizado. '|| chr(13) ||
                            'Vale já impresso';
                            
        Return vRetorno;                    
                            
                            
      End If;
      
      --Caso encontre o registro, atualiza o registro.
      If vRetorno.Controle > 0 Then
        Begin
          --Atualiza o registro propriamente dito.
          Update t_acc_vales vale
            Set 
              vale.acc_vales_data         = pVale_data,
              vale.frt_motorista_codigo   = pMotorista_codigo,
              vale.acc_vales_valor        = pVale_valor,
              vale.acc_vales_flagpess     = pDesinencia,
              vale.cax_operacao_codigo    = pCaixa_codigo,
              
              vale.glb_rota_codigo        = pRota_codigo,
              vale.acc_vales_observacao   = pVale_obs,
              vale.acc_vales_usuautorizou = pUsuario
          Where
            0=0
            And vale.acc_vales_numero = pVale_numero;
          
          Commit;
          
          --Lança a mensagem de atualização com sucesso.
          vRetorno.Status := pkg_glb_common.Status_Nomal;
          vRetorno.Message := 'Vale '|| pVale_numero || ' atualizado com sucesso.';
          vRetorno.Controle:= pVale_numero;
            
        Exception
          --Caso ocorra algum erro duraante a atualização gera mensagem de erro.
          When Others Then
            vRetorno.Status := pkg_glb_common.Status_Erro;
            vRetorno.Message := 'Erro durante a atualização do Vale ' || pVale_numero;
        End;  
      End If;
    Else
      --Caso o usuario não tenha permissão para edição, gera mensagem de erro.
      vRetorno.Status := pkg_glb_common.Status_Erro;
      vRetorno.Message := 'Usuario não possui permissão para atualizar Vale';
    End If;
  End If;
  
  --Caso o numero do vale, não seja passado quer dizer que é uma inserção.

/*  If ( nvl(pVale_numero, 0) = 0 ) Then
    --Consulta o limite do Motorista.
    SELECT 
      FRT_MOTORISTA_NOME,
      FRT_MOTORISTA_LIMITECREDITO,
      FRT_MOTORISTA_SALDOCREDITO
    Into
      vNomeMotor,
      vLimite,
      vSaldo
    FROM 
      V_FRT_MOTORISTA2
    WHERE 
      FRT_MOTORISTA_CODIGO = pMotorista_codigo;
      
      
    --verifico se o Motorista possui limite para emissão do vale.
    If ( vSaldo  < pVale_valor ) Then
      vRetorno.Message := 'O motorista ' || vNomeMotor || ' não possui saldo para esse vale.' || chr(13) ||
                          'O saldo ficará devedor em R$ ' || to_char( (vSaldo - pVale_valor), '999g999d99');
    End If;*/
    
    Begin
      --Busco o numero para o Vale.
      Select 
        Max(vale.acc_vales_numero) + 1 
      Into 
        vLinha.Acc_Vales_Numero  
      From 
        tdvadm.t_acc_vales vale;
        
       
      
      
      
      vLinha.Acc_Vales_Datagrav   := Sysdate;
      vLinha.Acc_Vales_Data       := pVale_data;
      vLinha.Frt_Motorista_Codigo := pMotorista_codigo;
      vLinha.Acc_Vales_Valor      := pVale_valor;
      vLinha.Acc_Vales_Flagpess   := pDesinencia;
--      vLinha.Cax_Operacao_Codigo  := pCaixa_codigo;
      vLinha.Glb_Rota_Codigo_Operacao := vGlg_RotaOperacao;
      vLinha.Cax_Operacao_Codigo  := pCaixa_codigo;
      vLinha.Acc_Tpdespesa_Codigo :=  vTpOperacao;      
      
      
      vLinha.Glb_Rota_Codigo      := pRota_codigo;
      vLinha.Acc_Vales_Observacao := pVale_obs;
      vLinha.Acc_Vales_Usucriou   := pUsuario;
      vLinha.Acc_Vales_Impressao  := 'N';
      
      If lower(trim(pAplicacao)) = 'monitvales' Then
        vLinha.Acc_Vales_Usuautorizou := pUsuario;
        vLinha.Acc_Vales_Dtautorizou  := Sysdate;
        vLinha.Acc_Vales_Vlautorizado := pVale_valor;

        
      End If;
  --    vLinha.Glb_Rota_Codigo_Operacao := pRotaUsuario;
      
      --executa a inserção propriamente dito.
      Insert Into t_acc_vales Values vLinha;
      Commit;
      
  --    Update t_frt_motorista  motor
  --     Set motor.frt_motorista_saldocredito = motor.frt_motorista_saldocredito - pVale_valor
  --    Where
  --      motor.frt_motorista_codigo = pMotorista_codigo; 
        
      vRetorno.Status := pkg_glb_common.Status_Nomal;
      vRetorno.Controle := vLinha.Acc_Vales_Numero;
            
    Exception
      When Others Then
        vRetorno.Status := pkg_glb_common.Status_Erro;
        vRetorno.Message := 'Erro ao criar o vale.' || chr(13) || Sqlerrm;
    End;    
    
    
/*  End If;*/
  
  
  
  
 --Devolve a variável preenchida.
 Return vRetorno; 
End;                        
                        
                               

/********************************************************************************************************************/
/*                                          RELAÇÃO DE FUNÇÕES PÚBLICAS                                             */
/********************************************************************************************************************/ 

/********************************************************************************************************************/
/*                                          RELAÇÃO DE PROCEDUREA PÚBLICAS                                          */
/********************************************************************************************************************/
 
----------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para gerar o arquivo XML de Carga Inicial                                                    --
----------------------------------------------------------------------------------------------------------------------
Procedure SP_GET_CARGAINICIAL( pParamsEntrada  In Varchar2,
                               pStatus         Out Char,
                               pMessage        Out Varchar2,
                               pParamsSaida    Out Clob
                             ) As

 --Variáveis utilizadas para recuperar valores passados como paramentro.
 vUsuario    tdvadm.t_usu_usuario.usu_usuario_codigo%Type := '';
 vRota       tdvadm.t_glb_rota.glb_rota_codigo%Type := '';
 vAplicacao  tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type := '';   
 
 --Variável que será utilizada para buscar os paramentros dessa aplicação
 vTabParamentros   glbadm.pkg_glb_auxiliar.tArrayParams;
 
 --Variáveis utilizadas para gerar arquivo XML
 vXmlParamentros   Clob;
 vXmlRetorno       Clob;
 
 vParamsAdd  glbadm.pkg_glb_auxiliar.tParametros;
                           
Begin

 Begin  

    vUsuario   := 'jsantos'; --pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'usuario');
    vRota      := '010'; --pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'rota'); 
    vAplicacao := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'aplicacao');

    /*
     --Utilizo um Select Para poder pegar os valores passados por paramentros.
      Begin
        Select 
           extractvalue(value(field), 'input/aplicacao'),
           extractvalue(value(field), 'input/usuario'),
           extractvalue(value(field), 'input/rota')
         Into 
           vAplicacao,
           vUsuario,
           vRota 
         from 
           Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/parametros/inputs/input'))) field;  
      Exception
        When Others Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage := 'Erro ao tentar buscar paramentros de execução' || chr(13) || dbms_utility.format_call_stack;
          Return;
      End;
      
      */
      
      
      --Rodo a Procedure que vai no banco buscar todos os paramentros da Aplicação mais os paramentros globais.
      glbadm.pkg_glb_auxiliar.sp_Cursor_Params( vUsuario, vAplicacao, vRota, vTabParamentros);
      
      --Corro o array de Paramentros para buscar os paramentros utilizados.
      For i In vTabParamentros.first .. vTabParamentros.last Loop
        
        --Parametro MENSAGEM: deve ser exibido na carga do sistema.
        If vTabParamentros(i).PERFIL = 'MENSAGEM'        Then  vXmlParamentros := vXmlParamentros || glbadm.pkg_glb_auxiliar.fn_getLinhaXmlParams(vTabParamentros(i), i);  End If;
        
      End Loop;

      
      
      --Monta o arquivo propriamente dito.
      vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
      vXmlretorno := vXmlRetorno || '<Table name=#listaParametros#><ROWSET>' || vXmlParamentros || '</ROWSET></Table>';
      vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
       
      --Substitui os carecteres "CORINGAS"
      vXmlRetorno := Replace(vXmlRetorno, '#', '"');
      vXmlRetorno := Replace(vXmlRetorno, '§', '''');  

      --Retorno da procedure.
      pStatus := pkg_glb_common.Status_Nomal;
      pMessage := '';
      pParamsSaida := vXmlRetorno;
   Exception
     When Others Then
       pStatus := 'E';
       pMessage := sqlerrm;
   End;      
  
End SP_GET_CARGAINICIAL;

----------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para gerar XML para para preencher Grid do Formulário de Consulta.                           --
----------------------------------------------------------------------------------------------------------------------  
Procedure SP_PSQ_AUXILIAR( pParamsEntrada  In Varchar2,
                           pStatus         Out Char,
                           pMessage        Out Varchar2,
                           pParamsSaida    Out Clob
                          ) As

  
 --Variável do tipo cursor que receberá o SQL gerado
 vCursor     pkg_glb_common.T_CURSOR; 
 
 --Variavel de controle de linha 
 vLinha  Integer := 0;
 
 --Variável utilizada para receber os valores do Cursor através do fetch.
 vValCursor    tCursorPSQAuxiliar;
 
 --Variável utilizada para receber resultado de funções.
 vRetFunc pkg_glb_common.tRetornoFunc;
 
 --Variáveis que serão utilizadas para administrar o Arquivo XML
 vXmlConsulta Clob;
 vXmlRetorno  Clob;
 
 --Variáveis utilizadas para recuperar os valores passados por paramentro
 vUsuario     t_usu_usuario.usu_usuario_codigo%Type := '';
 vRota        t_glb_rota.glb_rota_codigo%Type := '';
 vAplicacao   t_usu_aplicacao.usu_aplicacao_codigo%Type := '';
 vTpConsulta  Char(01) := '';
 vTpFiltro    Char(01) := '';
 vCodBusca    Varchar2(20) := '';
  
Begin

/*  pStatus := 'W';
  pMessage := pParamsEntrada;
  return;*/


  --Utilizo um Select Para poder pegar os valores passados por paramentros.
  Begin
    Select 
       extractvalue(value(field), 'input/usuario'),
       extractvalue(value(field), 'input/rota'),
       extractvalue(value(field), 'input/aplicacao'),
       extractvalue(value(field), 'input/tpConsulta'),
       extractvalue(value(field), 'input/tpFiltro'),
       extractvalue(value(field), 'input/codBusca')
     Into 
       vUsuario,
       vRota,
       vAplicacao,
       vTpConsulta,
       vTpFiltro,
       vCodBusca   
     from 
       Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/parametros/inputs/input'))) field;  
  Exception
    When Others Then
      --Caso ocorra algum erro na extração dos paramentros do arquivo XML, encerro o processamento
      --e mostro mensagem gerada de erro.
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar buscar paramentros de execução' || chr(13) || dbms_utility.format_call_stack;
      Return;
  End;
  
  --abro o cursor passando o Select Gerado a partir das condições solicitadas pelo FrontEnd
  Open vCursor For FNP_SQL_PSQAuxiliar( vTpConsulta, vTpFiltro, vCodBusca );
  
  --Entro em laço para percorrer o cursor. 
  Loop
    --Transfere os valores da linha do cursor para as variáveis.
    Fetch vCursor Into vValCursor;
    
    --Garante a saida do laço ao final do cursor.
    Exit When vCursor%Notfound;
    
    --Incremento a variável de linha
    vLinha := vLinha + 1;
    
    --Rodo a função que vai gerar o XML da consulta
    vRetFunc := FNP_Xml_PSQAuxiliar( vValCursor, vLinha);
    
    --Caso o resultado seja diferente de normal, encerra o processamento e devolve a mensagem gerada na função
    If vRetFunc.Status <> pkg_glb_common.Status_Nomal Then
      pStatus := vRetFunc.Status;
      pMessage := vRetFunc.Message;
      Return;
    End If;
  End Loop;
  
  --Caso o cursor retorne Sem registro, monto um arquivo XML em branco.
  If vLinha = 0 Then
    vRetFunc := FNP_Xml_PSQAuxiliar( vValCursor, 0);
  End If;
  
  
  --Crio um cursor para trazer os valores de consulta 
  For vCursorConsulta In ( Select 
                             w.tmp_auxiliarxml_conteudo
                           From 
                             t_tmp_auxiliarxml w
                           Where
                             Trim( w.tmp_auxiliarxml_tabnome ) = 'Consulta'
                           Order By
                             w.tmp_auxiliarxml_linha
                         ) Loop
                             vXmlConsulta := vXmlConsulta || vCursorConsulta.Tmp_Auxiliarxml_Conteudo || chr(13);
                           End Loop;
                           

  --Monta o arquivo propriamente dito.
  vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
  vXmlretorno := vXmlRetorno || '<Table name=#tabConsulta#><ROWSET>' || vXmlConsulta || '</ROWSET></Table>';
  vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
  --Substitui os carecteres "CORINGAS"
  vXmlRetorno := Replace(vXmlRetorno, '#', '"');
  vXmlRetorno := Replace(vXmlRetorno, '§', '''');  

  --Retorno da procedure.
  pStatus := pkg_glb_common.Status_Nomal;
  pMessage := '';
  pParamsSaida := vXmlRetorno;
  
  
End; 

----------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para gerar Arquivo XML com a pesquisa de vales. 
----------------------------------------------------------------------------------------------------------------------
Procedure SP_PSQ_Vales( pParamsEntrada  In Varchar2,
                        pStatus         Out Char,
                        pMessage        Out Varchar2,
                        pParamsSaida    Out Clob
                      ) As

 --Variável utilizadas para recuperar valores passados por paramentros (XML).
  vUsuario           tdvadm.t_usu_usuario.usu_usuario_codigo%Type :='';
  vRota              tdvadm.t_glb_rota.glb_rota_codigo%Type := '';
  vAplicacao         tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type := '';
  vVale_numero       tdvadm.t_acc_vales.acc_vales_numero%Type;
  vVale_rota         tdvadm.t_glb_rota.glb_rota_codigo%Type:= '';
  vVale_morotista    tdvadm.t_acc_vales.frt_motorista_codigo%Type := '';
  vVale_dtIncial     Varchar2(10) := '';
  vVale_dtFinal      Varchar2(10) := '';
  vValePendente      Char(01) := '';
  
  --variável do tipo cursor que receberá o Sql gerado.
  vCursorVale        pkg_glb_common.T_CURSOR;
  
  --Variável que receberá os valores dos cursores.
  vDadosCursor   tCursorVales;
  
  --Variável inteira, que será utilizada para controlar a linha do arquivo XML.
  vLinhaXml  Integer := 0;
  
  --Variável utilizada para retorno de funções.
  vRetornoFunc   pkg_glb_common.tRetornoFunc;
  
  --Variáveis utilizada para gerar o XML de retorno.
  vXmlConsVale Clob;
  vXmlRetorno  Clob;
                      
Begin

  --Utilizo um Select Para poder pegar os valores passados por paramentros.
  Begin
    Select 
       extractvalue(value(field),      'input/usuario'),
       extractvalue(value(field),      'input/rota'),
       extractvalue(value(field),      'input/aplicacao'),
       extractvalue(value(field),      'input/vale_numero'),
       extractvalue(value(field),      'input/vale_rota'),
       extractvalue(value(field),      'input/vale_morotista'),
       extractvalue(value(field),      'input/vale_dtIncial'),
       extractvalue(value(field),      'input/vale_dtFinal'),
       Trim(extractvalue(value(field), 'input/vale_pend'))
     Into 
       vUsuario,
       vRota,
       vAplicacao,
       vVale_numero,
       vVale_rota,
       vVale_morotista,
       vVale_dtIncial,
       vVale_dtFinal,
       vValePendente    
     from 
       Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/parametros/inputs/input'))) field;  
  Exception
    When Others Then
      --Caso ocorra algum erro na extração dos paramentros do arquivo XML, encerro o processamento
      --e mostro mensagem gerada de erro.
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar buscar paramentros de execução' || Sqlerrm;
     Return;
  End;
  
  
  if   ( trim(vRota) <> '010' ) then
  
  If (( trim(nvl(vVale_rota, vRota)) <> trim(vRota) ) And ( Trim(vAplicacao) = 'acctblvale' )  ) Then
    pStatus := 'W';
    pMessage := 'Você só pode buscar vales da rota: ' || vRota;
    Return;
  End If;
  
  end if;
  
  --Passo para o cusor o sql gerado.
  Open vCursorVale For FNP_SQL_PSQVales( vVale_numero, 
                                         vRota,
                                         vVale_morotista,
                                         vVale_dtIncial,
                                         vVale_dtFinal,
                                         vValePendente
                                       );
  
  --entro em loop para poder percorrer o cursor.
  Loop
    --utilizo o fetch para transferir os valores do cursor para as variáveis.
    Fetch vCursorVale Into vDadosCursor;
    
    
    --Garante a saida do laço ao final do cursor.                           
    Exit When vCursorVale%Notfound;
    
    --Incremento a variável de linha para o XML 
    vLinhaXml := vLinhaXml +1;
    
    --rodo a função que vai gerar o arquivo XML de retorno 
    vRetornoFunc := FNP_Xml_Vales( vDadosCursor, vLinhaXml);
    
    --Caso ocorra algum erro durante o processo de criação do arquivo XML.
    --encerro o processamento e devolvo a mensagem criada dentro da função.
    If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal Then
      pStatus := vRetornoFunc.Status;
      pMessage := vRetornoFunc.Message;
      Return;
    End If;
  End Loop;                                       
  
  --Caso o retorno do cursor tenha sido zerado, gero um XML em branco apenas para não ter problema com o FRONTEND.
  If vLinhaXml  = 0  Then
    vRetornoFunc := FNP_Xml_Vales( vDadosCursor, vLinhaXml);
    
    --Caso ocorral algum erro, em trazer um arquivo em branco., encerro o processmaneto.
    If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal Then
      pStatus := vRetornoFunc.Status;
      pMessage := vRetornoFunc.Message;
      Return;
    End If;
  End If;
  
  --Busco o arquivo XML, que foi incluido na tabela auxiliar de XML.
   
  --Crio um cursor para trazer os valores de consulta 
  For vCursorConsulta In ( Select 
                             w.tmp_auxiliarxml_conteudo
                           From 
                             t_tmp_auxiliarxml w
                           Where
                             Trim( w.tmp_auxiliarxml_tabnome ) = 'ConsVale'
                           Order By
                             w.tmp_auxiliarxml_linha
                         ) Loop
                             vXmlConsVale := vXmlConsVale || vCursorConsulta.Tmp_Auxiliarxml_Conteudo || chr(13);
                           End Loop;
                           

  --Monta o arquivo propriamente dito.
  vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
  vXmlretorno := vXmlRetorno || '<Table name=#ConsVale#><ROWSET>' ||  vXmlConsVale || '</ROWSET></Table>';
  vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
  --Substitui os carecteres "CORINGAS"
  vXmlRetorno := Replace(vXmlRetorno, '#', '"');
  vXmlRetorno := Replace(vXmlRetorno, '§', '''');  

  --Retorno da procedure.
  pStatus := pkg_glb_common.Status_Nomal;
  pMessage := '';
  pParamsSaida := vXmlRetorno;
  
                                       
  
  
  pStatus := 'N';
  pMessage := '';
  Return;

End SP_PSQ_Vales;
      
----------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada efetuar a Inserção de novos vales.                                                           --
----------------------------------------------------------------------------------------------------------------------
Procedure SP_Set_Vales( pParamsEntrada  In Varchar2,
                        pStatus         Out Char,
                        pMessage        Out Varchar2,
                        pParamsSaida    Out Clob
                      ) As

 --Variáveis que serão utilizadas para recuperar valores passados por paramentros "XML"
 vUsuario             t_usu_usuario.usu_usuario_codigo%Type;       -- Char(10)
 vRota                t_glb_rota.glb_rota_codigo%Type;             -- Char(03)  
 vAplicacao           t_usu_aplicacao.usu_aplicacao_codigo%Type;   -- Char(10)
 
 vVale_numero         t_acc_vales.acc_vales_numero%Type;           -- Number(06) 
 vVale_data           t_acc_vales.acc_vales_data%Type;             -- Date
 vMotorista_codigo    t_acc_vales.frt_motorista_codigo%Type;       -- Char(06)
 vVale_valor          t_acc_vales.acc_vales_valor%Type;            -- Number(14,02)
 vDesinencia          t_acc_vales.acc_vales_flagpess%Type;         -- Char(01)
 vCaixa_codigo        t_acc_vales.cax_operacao_codigo%Type;        -- Char(04) 
 vRota_codigo         t_glb_rota.glb_rota_codigo%Type;             -- Char(03)
 vVale_obs            t_acc_vales.acc_vales_observacao%Type;       -- Varchar2(255) 
 vAcao                Char(01);  
 
 --Variável que será utilizada para buscar os paramentros dessa aplicação
 vTabParamentros   glbadm.pkg_glb_auxiliar.tArrayParams;
 
 --Variáveis utilizadas para recuperar Parametros de permissões
 vDELETE_VALE     Char(01) := '';
 vDELETE_VALE_IMP INTEGER  := -1;
 vEDIT_VALE       Char(01) := '';
 vESTORNA_VALE    char(01) := 'N';
 vAuxiliar        number;
 vAuxiliarT       varchar2(20);
 tpCaxia          tdvadm.t_cax_movimento%rowtype;
 
 -- Variável utilizada para receber retorno de funções;
 vRetornoFunc  pkg_glb_common.tRetornoFunc;

 --Variável utilizada para 
 vCursor  pkg_glb_common.T_CURSOR;
 
 --Variável que receberá os valores dos cursores.
 vDadosCursor   tCursorVales;
 
 
 --Variáveis utilizada para tratar XML
 vXmlVale    Clob;
 vXmlRetorno Clob;
                
                      
Begin
  vRetornoFunc.Status := 'N';
  vRetornoFunc.Message := '';
   --Utilizo um Select Para poder pegar os valores passados por paramentros.
  Begin
    Select 
       extractvalue(value(field), 'input/usuario'),
       extractvalue(value(field), 'input/rota'),
       extractvalue(value(field), 'input/aplicacao'),
       extractvalue(value(field), 'input/vale_numero'),
       extractvalue(value(field), 'input/vale_data'),
       extractvalue(value(field), 'input/motorista_codigo'),
       Replace( Replace( extractvalue(value(field), 'input/vale_valor'), '.', ''), ',', '.') ,
       extractvalue(value(field), 'input/desinencia'),
       extractvalue(value(field), 'input/caixa_codigo'),
       extractvalue(value(field), 'input/rota_codigo'),
       extractvalue(value(field), 'input/vale_obs'),
       extractvalue(value(field), 'input/acao')
     Into 
        vUsuario,
        vRota,
        vAplicacao,
        vVale_numero,
        vVale_data,
        vMotorista_codigo,
        vVale_valor,
        vDesinencia,
        vCaixa_codigo,
        vRota_codigo,
        vVale_obs,
        vAcao              
        
     from 
       Table(xmlsequence( Extract(xmltype.createXml(pParamsEntrada) , '/parametros/inputs/input'))) field;  
  Exception
    When Others Then
      --Caso ocorra algum erro na extração dos paramentros do arquivo XML, encerro o processamento
      --e mostro mensagem gerada de erro.
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar buscar paramentros de execução';
     Return;
  End;

/*  If vUsuario = 'vgcaetano' Then 
     insert into tdvadm.t_Glb_Sql values (pParamsEntrada,sysdate,'VALES','Vinicius VALES');
     commit;
     raise_application_error(-20001,'Pasei aqui com o Usuario ' || vUsuario);
  End If;   
*/ 
/* 
  if vVale_numero = '111059' then
    pStatus := 'W';
    pMessage := pParamsEntrada;
    return;
  end if;
  */
 
  --antes de tomar qualquer decisão Rodo a Procedure que vai no banco buscar todos os paramentros da Aplicação
  glbadm.pkg_glb_auxiliar.sp_Cursor_Params( vUsuario, vAplicacao, vRota, vTabParamentros);
  
  For i In vTabParamentros.First .. vTabParamentros.Last Loop

    --Permissão para deletar vale
    If vTabParamentros(i).PERFIL = 'DELETE_VALE' Then  
      vDELETE_VALE := Trim(vTabParamentros(i).TEXTO); 
    End If;

    --Permissão para deletar vale
    If vTabParamentros(i).PERFIL = 'EXCL_VALES_IMPRESS' Then  
      vDELETE_VALE_IMP := Nvl(vTabParamentros(i).NUMERICO1,-1); 
    End If;    
    
    --Permissão para ditar Vale.
    If vTabParamentros(i).PERFIL = 'EDIT_VALE' Then  
      vEDIT_VALE   := Trim(vTabParamentros(i).TEXTO); 
    End If;
    
    If vTabParamentros(i).PERFIL = 'ESTORNA_VALE' Then  
      vDELETE_VALE := Trim(vTabParamentros(i).TEXTO); 
      vESTORNA_VALE := Trim(vTabParamentros(i).TEXTO); 
    End If;
    
    
  End Loop;
  
  --Caso seja uma ação de Exclusão
  If vAcao = 'D' Then
    --Executa a função responsável por realizar a exclusão do Vale.
    vRetornoFunc := FNP_DEL_Vales( vVale_numero, vRota_codigo, vDELETE_VALE, vDELETE_VALE_IMP);
    
    --Caso tenha ocorrido algum erro durante a execução, interrompe o processamento e mostra
    -- mensagem na tela.
    If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal Then
      pStatus := vRetornoFunc.Status;
      pMessage := vRetornoFunc.Message;
      Return;
    Else
      pMessage := vRetornoFunc.Message;  
    End If;
    
  --Caso seja uma ação de Inserção / Atualização
  ElsIf vAcao = 'I' Then

    --Executa a função responsável por realizar a inserção do registro.
    vRetornoFunc := FNP_INS_Vales( vVale_numero,
                                   vVale_data,
                                   vMotorista_codigo,
                                   vVale_valor,
                                   vDesinencia,
                                   vCaixa_codigo,
                                   vRota_codigo,
                                   vVale_obs,
                                   vEDIT_VALE,
                                   vUsuario,
                                   vRota,
                                   vAplicacao
                                 ); 
      
    --Caso tenha ocorrido algum erro, interrompe a inserção e mostra mensagem gerada na tela.
    If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal Then
      pStatus := vRetornoFunc.Status;
      pMessage := vRetornoFunc.Message;
      Return;
    Else
      vVale_numero := vRetornoFunc.Controle;  
      pMessage := vRetornoFunc.Message;
    End If;                                
  
  -- Usando para Estornar o Vale
  ElsIf vAcao = 'E' Then  
  
       If vESTORNA_VALE = 'N' Then 
          vRetornoFunc.Status := 'E';
          vRetornoFunc.Message := 'Voce não Tem AUTORIZACAO para ESTORNAR vales';
          pStatus := vRetornoFunc.Status;
          pMessage := vRetornoFunc.Message;
          Return;
       End If;
       
       
       -- Verifica se O Vale Ja esta em Acerto
       Begin
          Select v.acc_acontas_numero
            into vAuxiliar
          from tdvadm.t_Acc_Vales v
          where v.acc_vales_numero = vVale_numero
            and v.glb_rota_codigo = vRota_codigo
            and v.acc_acontas_numero is not null;
       exception
         When NO_DATA_FOUND Then
             vAuxiliar := 0;
         When OTHERS Then
             vRetornoFunc.Status := 'E';
             vRetornoFunc.Message := 'Ocorreu Erro No Estorno passe para TI. erro :[' || sqlerrm || ']';
             pStatus := vRetornoFunc.Status;
             pMessage := vRetornoFunc.Message;
             Return;
         End;
       If vAuxiliar <> 0 Then 
          vRetornoFunc.Status := 'E';
          vRetornoFunc.Message := 'Vale Esta no Acerto [' || To_char(vAuxiliar) || '] Não pode ser ESTORNADO';
          pStatus := vRetornoFunc.Status;
          pMessage := vRetornoFunc.Message;
          Return;
       End If; 
       
       -- Verifica se o Vale ja foi transferido 
       Select count(*)
         into vAuxiliar
       from tdvadm.t_cax_movimento m
       where m.glb_rota_codigo = '015'
         and m.cax_operacao_codigo = '1127'
         and m.cax_movimento_documento = vVale_numero
         and m.glb_rota_codigo_referencia = vRota_codigo
         and m.cax_movimento_valor = vVale_valor;
         
       If vAuxiliar = 0 Then 
          vRetornoFunc.Status := 'E';
          vRetornoFunc.Message := 'Vale Não foi Transferido para o ACERTO! Pode ser EXCLUIDO';
          pStatus := vRetornoFunc.Status;
          pMessage := vRetornoFunc.Message;
          Return;
       End If; 
       
       -- Verifica se o Vale ja em Acerto 
       Select count(*)
         into vAuxiliar
       from tdvadm.t_cax_movimento m
       where m.glb_rota_codigo = '015'
         and m.cax_operacao_codigo = '2600'
         and m.cax_movimento_documento = vVale_numero
         and m.cax_movimento_valor = vVale_valor;
         
       If vAuxiliar <> 0 Then 
          vRetornoFunc.Status := 'E';
          vRetornoFunc.Message := 'Vale Ja esta em Acerto Fechado!';
          pStatus := vRetornoFunc.Status;
          pMessage := vRetornoFunc.Message;
          Return;
       End If; 
       
       -- Estorna do CAXIA DA 015
       select *
         into tpCaxia
       from tdvadm.t_cax_movimento m 
       where m.glb_rota_codigo = '015'
         and m.cax_operacao_codigo = '1127'
         and m.cax_movimento_documento = vVale_numero
         and m.glb_rota_codigo_referencia = vRota_codigo
         and m.cax_movimento_valor = vVale_valor;
       
        select max(m.cax_boletim_data)
          into tpCaxia.Cax_Boletim_Data
        from tdvadm.t_cax_movimento m,
             TDVADM.t_Cax_Boletim B
        where m.glb_rota_codigo = '015'
          AND M.GLB_ROTA_CODIGO = B.GLB_ROTA_CODIGO
          AND M.CAX_BOLETIM_DATA = B.CAX_BOLETIM_DATA
          AND B.CAX_BOLETIM_STATUS <> 'F';

        select count(*)
           into vAuxiliar
        from tdvadm.t_cax_boletim bo
        where bo.glb_rota_codigo = '015'
          and bo.cax_boletim_data = tpCaxia.Cax_Boletim_Data
          and bo.cax_boletim_status <> 'F';
        
        if vAuxiliar =  0 Then
           rollback;
           vRetornoFunc.Status := 'E';
           vRetornoFunc.Message := 'Não Existe Caixa Aberto na Filial 015. Solocitar Abertura!';
           pStatus := vRetornoFunc.Status;
           pMessage := vRetornoFunc.Message;
           Return;
        End If;  

        Select Max(nvl(m.cax_movimento_sequencia,0))
          into tpCaxia.Cax_Movimento_Sequencia
        from tdvadm.t_cax_movimento m
        where m.glb_rota_codigo = '015'
          and m.cax_boletim_data = tpCaxia.Cax_Boletim_Data;
        
        tpCaxia.Cax_Movimento_Sequencia := nvl(tpCaxia.Cax_Movimento_Sequencia,0) + 1;
        tpCaxia.Cax_Operacao_Codigo := '2412';
        tpCaxia.Glb_Rota_Codigo_Operacao := '000';         
        
        insert into t_cax_movimento m values tpCaxia;
         
        -- Estorna do CAIXA DA FILIAL

       select v.glb_rota_codigocax,
              v.cax_boletim_data,
              v.cax_movimento_sequencia
         into tpCaxia.Glb_Rota_Codigo,
              tpCaxia.Cax_Boletim_Data,
              tpCaxia.Cax_Movimento_Sequencia
       from tdvadm.t_acc_vales v
       where v.acc_vales_numero = vVale_numero
         and v.glb_rota_codigo = vRota_codigo;
       

       select *
         into tpCaxia
       from tdvadm.t_cax_movimento m 
       where m.glb_rota_codigo = tpCaxia.Glb_Rota_Codigo
         and m.cax_boletim_data = tpCaxia.Cax_Boletim_Data
         and m.cax_movimento_sequencia = tpCaxia.Cax_Movimento_Sequencia;
       
        Begin
        select max(m.cax_boletim_data)
          into tpCaxia.Cax_Boletim_Data
        from tdvadm.t_cax_boletim m
        where m.glb_rota_codigo = tpCaxia.Glb_Rota_Codigo
          and m.cax_boletim_status in ('A','R','E');
        Exception
          When NO_DATA_FOUND Then
             rollback;
             vRetornoFunc.Status := 'E';
             vRetornoFunc.Message := 'Não Existe Caixa Aberto na Filial. Solocitar Abertura!';
             pStatus := vRetornoFunc.Status;
             pMessage := vRetornoFunc.Message;
             Return;
          End ; 
          
        Select Max(nvl(m.cax_movimento_sequencia,0))
          into tpCaxia.Cax_Movimento_Sequencia
        from tdvadm.t_cax_movimento m
        where m.glb_rota_codigo = tpCaxia.Glb_Rota_Codigo
          and m.cax_boletim_data = tpCaxia.Cax_Boletim_Data;
        
        tpCaxia.Cax_Movimento_Sequencia := nvl(tpCaxia.Cax_Movimento_Sequencia,0) + 1;
        tpCaxia.Cax_Operacao_Codigo := '1267';
        tpCaxia.Glb_Rota_Codigo_Operacao := '000';         
        
        insert into t_cax_movimento m values tpCaxia;
        

        update tdvadm.t_acc_vales v
          set v.acc_acontas_numero = 11111111,
              v.acc_contas_ciclo = 0
        where v.acc_vales_numero = vVale_numero
          and v.glb_rota_codigo = vRota_codigo;

        If vRetornoFunc.Status <> 'E' Then
           Commit;
           vRetornoFunc.Status := 'N';
           vRetornoFunc.Message := 'Vale estornado com Sucesso...';
           pStatus := vRetornoFunc.Status;
           pMessage := vRetornoFunc.Message;
        Else
          rollback;
        End If;
        return;
        




   
  End If;
  
  

  ----   DEVOLVE UM XML COM AS ALTERAÇÕES REALIZADAS.  ----
  --Se for "Ação 
  If vAcao = 'I' Then
    If ( nvl(vVale_numero, 0) = 0 ) Then
      pStatus := 'W';
      pMessage:= 'Dados Insuficiente para gerar um vale';
      Return;
    End If;
  
    --Chama o cursor passando o numero do Vale "Criado ou alterado".
    Open vCursor For FNP_SQL_PSQVales(vVale_numero, '', '', '', '', '' );
    
    Loop
      --utilizo o fetch para transferir os valores do cursor para as variáveis.
      Fetch vCursor Into vDadosCursor;
      
      
      --Garante a saida do laço ao final do cursor.                           
      Exit When vCursor%Notfound;
      
      --rodo a função que vai gerar o arquivo XML de retorno 
      vRetornoFunc := FNP_Xml_Vales( vDadosCursor, 1);
      
      --Caso ocorra algum erro durante o processo de criação do arquivo XML.
      --encerro o processamento e devolvo a mensagem criada dentro da função.
      If vRetornoFunc.Status <> pkg_glb_common.Status_Nomal Then
        pStatus := vRetornoFunc.Status;
        pMessage := vRetornoFunc.Message;
        Return;
      End If;
    End Loop; 
  
 End If;     
 
 If vAcao = 'D' Then
   vRetornoFunc := FNP_Xml_Vales( vDadosCursor, 0);
 End If;
  
  
  --Crio um cursor para trazer os valores de consulta 
  For vRetorno In ( Select 
                       w.tmp_auxiliarxml_conteudo
                     From 
                       t_tmp_auxiliarxml w
                     Where
                       Trim( w.tmp_auxiliarxml_tabnome ) = 'ConsVale'
                     Order By
                        w.tmp_auxiliarxml_linha
                    )  Loop
                         vXmlVale := vXmlVale || Trim(vRetorno.Tmp_Auxiliarxml_Conteudo) || chr(13);
                       End Loop;
                       
                       
                           

  --Monta o arquivo propriamente dito.
  vXmlRetorno := vXmlRetorno || '<Parametros><Output><Tables>';
  vXmlretorno := vXmlRetorno || '<Table name=#ConsVale#><ROWSET>' || vXmlVale || '</ROWSET></Table>';
  vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
   
  --Substitui os carecteres "CORINGAS"
  vXmlRetorno := Replace(vXmlRetorno, '#', '"');
  vXmlRetorno := Replace(vXmlRetorno, '§', '''');  

  --Retorno da procedure.
  pStatus := pkg_glb_common.Status_Nomal;
  pParamsSaida := vXmlRetorno;                
  
End;     

--Procedure utilizada para flegar a data de impressão de um Vale
Procedure sp_set_DtImpressaoVale( pParamsEntrada   In Varchar2,
                                  pStatus          Out Char,
                                  pMessage         Out Varchar
                                ) Is 
 --Variáveis utilizadas para recuperar os valores que foram passados por paramentros.
 vUsuario             t_usu_usuario.usu_usuario_codigo%Type;       -- Char(10)
 vRota_Usuario        t_glb_rota.glb_rota_codigo%Type;             -- Char(03)  
 vAplicacao           t_usu_aplicacao.usu_aplicacao_codigo%Type;   -- Char(10)
 
 vVale_numero         t_acc_vales.acc_vales_numero%Type;           -- Number(06) 
 vVale_rota           t_glb_rota.glb_rota_codigo%Type;             -- Char(03)

 tpCaixa              tdvadm.t_cax_movimento%rowtype; 

 --Variável de controle.
 vCount Integer;
 vCaixaAcertoFechado char(1);
 vValeemCaixa char(1);
 vCaxUsar varchar2(10);
 vCriaCax char(2);
 vStatus char(1);
 vMessage varchar2(20000);
                                  
Begin
  vUsuario      := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'usuario'); 
  vRota_Usuario := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'rota');
  vAplicacao    := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'aplicacao');    
  vVale_numero  := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'vale_numero');
  vVale_rota    := pkg_glb_common.FN_getParams_Xml(pParamsEntrada, 'vale_rota');
  Begin
    
    Select Count(*) Into vCount
    From t_acc_vales  vale
    Where
      vale.acc_vales_numero = vVale_numero
      And vale.glb_rota_codigo = vVale_rota;
      
    If vCount > 0 Then
    
      vCaixaAcertoFechado := fn_VerificaCxAcertoFechado(vVale_numero,vVale_rota);
      vValeemCaixa := fn_VerificaValeemCx(vVale_numero,vVale_rota);
      
         
      If vCaixaAcertoFechado = 'N' and vValeemCaixa = 'N' Then
        
         tpCaixa.GLB_ROTA_CODIGO_REFERENCIA	  := vVale_rota;
         tpCaixa.CAX_MOVIMENTO_FREND          := 'N';
         tpCaixa.CAX_MOVIMENTO_USUARIO	      := vUsuario;
         tpCaixa.CAX_MOVIMENTO_DTGRAVACAO     := sysdate;
         tpCaixa.CAX_MOVIMENTO_ORIGEM         := null;

         select r.glb_rota_caixa
           into tpCaixa.GLB_ROTA_CODIGO
         from tdvadm.t_glb_rota r
         where r.glb_rota_codigo = vVale_rota;

         tpCaixa.CAX_OPERACAO_CODIGO      := '2167';
         tpCaixa.GLB_ROTA_CODIGO_OPERACAO := '000';



         Select lpad(vale.acc_vales_numero,6,'0'),
                vale.acc_vales_data,
                c.frt_conjveiculo_codigo,
                m.frt_motorista_cpf,
                m.frt_motorista_nome,
                vale.acc_vales_valor
            into tpCaixa.CAX_MOVIMENTO_DOCUMENTO,
                 tpCaixa.CAX_BOLETIM_DATA,
                 tpCaixa.FRT_CONJVEICULO_CODIGO,
                 tpCaixa.CAX_MOVIMENTO_CGCCPF,
                 tpCaixa.CAX_MOVIMENTO_FAVORECIDO,
                 tpCaixa.CAX_MOVIMENTO_VALOR
         From tdvadm.t_acc_vales vale,
              tdvadm.t_frt_conjunto c,
              tdvadm.t_Frt_Motorista m
         Where vale.acc_vales_numero = vVale_numero
           And vale.glb_rota_codigo = vVale_rota
           and vale.frt_motorista_codigo = m.frt_motorista_codigo
           and vale.frt_motorista_codigo = c.frt_motorista_codigo (+);
        
         tpCaixa.CAX_MOVIMENTO_DATANF	:= tpCaixa.CAX_BOLETIM_DATA;
   
         If TO_NUMBER(to_char(sysdate,'hh24MM')) > 1530 Then
            tpCaixa.CAX_BOLETIM_DATA := tpCaixa.CAX_BOLETIM_DATA + 1;
            tdvadm.pkg_ctb_caixa.sp_set_AbreCaixa(tpCaixa.GLB_ROTA_CODIGO,
                                                  tpCaixa.CAX_BOLETIM_DATA,
                                                  vStatus,
                                                  vMessage);
         End If;                                        
        If tdvadm.pkg_ctb_caixa.fn_get_CaixaAberto(tpCaixa.GLB_ROTA_CODIGO,
                                                   tpCaixa.CAX_BOLETIM_DATA) not in  ('A', -- Aberto
                                                                                      'R', -- Re-Aberto 
                                                                                      'E') Then -- Eletronico
           pStatus := tdvadm.pkg_glb_common.Status_Erro;
           pMessage := 'Abrir Caixa com Data Igual ou maior a ' || to_char(tpCaixa.CAX_BOLETIM_DATA,'dd/mm/yyyy');  

        Else

             vCaxUsar := tdvadm.pkg_ctb_caixa.fn_get_QualCaixaUsar(tpCaixa.GLB_ROTA_CODIGO,
                                                                   tpCaixa.CAX_BOLETIM_DATA,
                                                                   vCriaCax);

             If vCaxUsar = 'ERRO' Then
                pStatus := tdvadm.pkg_glb_common.Status_Erro;
                pMessage := 'Abrir Caixa com Data Igual ou maior a ' || to_char(tpCaixa.CAX_BOLETIM_DATA,'dd/mm/yyyy');  
             Else                                                        
                 If to_date(vCaxUsar,'dd/mm/yyyy') < tpCaixa.CAX_BOLETIM_DATA Then
                    pStatus := tdvadm.pkg_glb_common.Status_Erro;
                    pMessage := 'Abrir Caixa com Data Igual ou maior a ' || to_char(tpCaixa.CAX_BOLETIM_DATA,'dd/mm/yyyy');  
                 Else       
                    tdvadm.pkg_ctb_caixa.sp_set_InsereMovimento(tpCaixa,pStatus,pMessage);
                    If pStatus = tdvadm.pkg_glb_common.Status_Nomal Then
                     
                       Update tdvadm.t_acc_vales w
                          Set w.acc_vales_impressao = 'S',
                              w.acc_vales_dtimpressao = Sysdate,
                              w.acc_vales_usuimprimiu = vUsuario,
                              w.cax_boletim_data      = tpCaixa.Cax_Boletim_Data,
                              w.glb_rota_codigocax    = tpCaixa.Glb_Rota_Codigo,
                              w.cax_movimento_sequencia = tpCaixa.Cax_Movimento_Sequencia
                       Where w.acc_vales_numero = vVale_numero
                         And w.glb_rota_codigo = vVale_rota;
                
                 Commit;  
                    
                    End If; 
                 End If;
             End If;
         End If;
      Else
         pStatus := tdvadm.pkg_glb_common.Status_Erro;
         If vCaixaAcertoFechado = 'S' Then
            pMessage := 'Acerto de Contas Fechado para esta Data';  
         End If;

         If vValeemCaixa = 'S' Then
               pMessage := pMessage || '-' || 'Vale Ja lancado no Caixa';  
         End If;

      End If;
            
          
    End If;
    
  Exception
    When Others Then
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao atualizar data de impressao' || chr(13) || Sqlerrm;   
  End;
End sp_set_DtImpressaoVale;  
  
/*
<parametros>
  <inputs>
     <input>
       <usuario>jsantos</usuario>
       <aplicacao>acctblvale</aplicacao>
       <rota>010</rota>
       <vale_numero>109302</vale_numero>
       <vale_rota>197</vale_rota>
     </input>
   </inputs>
 </parametros>
*/
  


function fnp_Sql_ValesSemImpres( pData date, pQtdeDias integer ) return varchar2 as
 --variável que será utilizada como retorno da função
 vRetorno   varchar2(3000);
begin
  --Inicializo as variáveis que serão utilizadas nessa procedure.
  vRetorno := '';
  
  --Crio um SQL que vai gerar um cursor com todos os vales emitidos a mais de "X" dias e não impresso.
  vRetorno := vRetorno || ' select                                                   ';
  vRetorno := vRetorno || '   vale.acc_vales_numero,                                 ';
  vRetorno := vRetorno || '   vale.glb_rota_codigo,                                  ';
  vRetorno := vRetorno || '   vale.Acc_Vales_Datagrav                                ';
  vRetorno := vRetorno || ' from                                                     ';
  vRetorno := vRetorno || '   t_acc_vales  vale                                      ';
  vRetorno := vRetorno || ' where                                                    ';
  vRetorno := vRetorno || '   0=0                                                    ';
  vRetorno := vRetorno || '  and trunc(vale.acc_vales_datagrav) >=  §01/03/2012§     ';
  vRetorno := vRetorno || '  and Trunc(vale.acc_vales_datagrav) <= Trunc(to_date(§' || pData || '§, §dd/mm/yyyy§) - ' || to_char(pQtdeDias) ||'  )  '; 
  vRetorno := vRetorno || '  and nvl(vale.acc_vales_impressao, §N§) <> §S§           ';
  vRetorno := vRetorno || '  and vale.acc_vales_dtimpressao is null                  ';
  vRetorno := vRetorno || '  and vale.ACC_ACONTAS_NUMERO        is null              ';
  vRetorno := vRetorno || '  and vale.CAX_BOLETIM_DATA          is null              ';
  vRetorno := vRetorno || '  and vale.CAX_MOVIMENTO_SEQUENCIA   is null              ';
  vRetorno := vRetorno || '  order by Trunc(vale.acc_vales_datagrav) desc            ';
  
  --substituo os caracteres coringas.
  vRetorno := replace(vRetorno, '§', '''');
  
  insert into dropme (x,l) values('select exc caixa',vRetorno);
  
  --retorna a variável preenchida.
  return vRetorno;
  
end fnp_Sql_ValesSemImpres;

function FNP_SQL_ValesImpSemCx( pData date, pQtdeDias integer ) return varchar2 as 
 --variável que será utilizada como retorno da função
 vRetorno   varchar2(3000);
begin
  --Inicializo as variáveis que serão utilizadas nessa procedure.
  vRetorno := '';
  
  --Crio um SQL que vai gerar um cursor com todos os vales emitidos a mais de "X" dias e não impresso.
  vRetorno := vRetorno || ' select                                                   ';
  vRetorno := vRetorno || '   vale.acc_vales_numero,                                 ';
  vRetorno := vRetorno || '   vale.glb_rota_codigo,                                  ';
  vRetorno := vRetorno || '   vale.Acc_Vales_Datagrav                                ';  
  vRetorno := vRetorno || ' from                                                     ';
  vRetorno := vRetorno || '   t_acc_vales  vale                                      ';
  vRetorno := vRetorno || ' where                                                    ';
  vRetorno := vRetorno || '   0=0                                                    ';
  vRetorno := vRetorno || '  and trunc(vale.acc_vales_datagrav) >=  §01/03/2012§     ';
  vRetorno := vRetorno || '     and nvl(vale.acc_vales_impressao, §N§) = §S§         ';
  vRetorno := vRetorno || '   and vale.acc_vales_dtimpressao is not null             ';
  vRetorno := vRetorno || '   and nvl(vale.cax_movimento_sequencia, 0) = 0           ';
  vRetorno := vRetorno || '   and vale.cax_boletim_data is null                      ';
  vRetorno := vRetorno || '  and Trunc(vale.acc_vales_datagrav) <= Trunc(to_date(§' || pData || '§, §dd/mm/yyyy§) -' || to_char(pQtdeDias) ||' )  '; 
  vRetorno := vRetorno || '  order by Trunc(vale.acc_vales_datagrav) desc            ';
  
  --substituo os caracteres coringas.
  vRetorno := replace(vRetorno, '§', ''''); 
  
  insert into dropme (x,l) values('select exc caixa2',vRetorno);
  
  --retorna a variável preenchida.
  return vRetorno;
end  FNP_SQL_ValesImpSemCx; 

----------------------------------------------------------------------------------------------------------------------
--Procedure que será utilizada para excluir os vales, a partir de um SQL definido por outra função.
----------------------------------------------------------------------------------------------------------------------
procedure sp_ExcluirVales( pAcao    in char,
                           pData    in Date, 
                           pStatus  out char,
                           pMessage out varchar2
                         ) as
 --Variável do tipo cursor, utilizada para buscar vales
 vCursor  tdvadm.pkg_glb_common.T_CURSOR;
 
 --Variáveis utilizada para recuperar a chave do cursor.
 vVales_Numero    t_acc_vales.acc_vales_numero%type;
 vVales_Rota      t_acc_vales.glb_rota_codigo%type;
 vVales_DtEmisssao t_acc_vales.acc_vales_datagrav%type;
 vDadosUsuario     v_glb_ambiente%rowtype;
 vValeDados        t_acc_vales%rowtype;
 
 --Variável de controle 
 vControl integer;
 
 --Variável que será utilizada para registrar log de exclusão do Vale.
 vLinhaLog   tdvadm.t_log_system%rowtype;
 vString     varchar2(2000);
 
 
 
                       
begin
 --Inicializar as variáveis que serão utilizadas nessa procedure.
 vVales_Numero := '';
 vVales_Rota := '';
 vControl := 0;
 

 vLinhaLog.Usu_Aplicacao_Codigo := 'acctblvale';
 vLinhaLog.Log_System_Datahora := sysdate;
 
 
 
 

 begin
 
    --verifico qual a acção que deverá ser realizada
    -- VLN = Vales não Impressos
    -- VLI = Vales Impressos.
    begin
      if pAcao = 'VLN' then
        open vCursor for fnp_Sql_ValesSemImpres( pData, 5);
        
        --Registra Log para exclusão de vales não impressos.
        vLinhaLog.Log_Macro_Codigo := 'Excl_vales_n_impres';
        vLinhalog.Log_System_Campochave := 'Vales Não Impressos';
      end if;  
      
      if pAcao = 'VLI' then
        open vCursor for FNP_SQL_ValesImpSemCx( pData, 15); 
        
        --Registra log para exclusão de vales Impressos e não pagos.
        vLinhaLog.Log_Macro_Codigo := 'Excl_vales_impress';
        vLinhalog.Log_System_Campochave := 'Vales impressos e não pagos';
      end if;
      
    Exception
      --caso ocorra algum erro na abertura dos cursors
      when others then
        raise_application_error(-20001, 'Erro ao tentar a abrir o cursor de vales' || chr(13) || sqlerrm);
    end;  
    
    --entro em loop para correr o cursor.
    loop
      --utilizo o fetch para recuperar os valores do cursor.
      fetch vCursor into vVales_Numero, 
                         vVales_Rota,
                         vVales_DtEmisssao;
      
      --garantir a saida do loop ao final do cursor
      exit when vCursor%notfound;
      
      --Incremento a variável de controle
      vControl := vControl +1;
      
      --Registra as informações de LOG.
      vLinhaLog.Usu_Aplicacao_Codigo := 'acctblvale';
      vLinhalog.Log_System_Datahora := sysdate;
      vLinhaLog.Log_System_Message := Trim(to_char(vVales_Numero))                   || '|' || --Numero do Vale
                                      Trim(vVales_Rota)                              || '|' || --Rota do Vale
                                      Trim(to_char(vVales_DtEmisssao, 'DD/MM/YYYY')) || '|' || --Data de Emissao
                                      Trim(to_char(SYSDATE, 'DD/MM/YYYY'))           || '|' ;   --Data da Exclusão
      
      begin
        
         select *   
         into vDadosUsuario
         from v_glb_ambiente te;
         
         vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'UsuExclusao: ' || vDadosUsuario.os_user; 
               
      
        --capturo dados do vale para jogar na menssagem do Log
        select *
        into vValeDados
        from tdvadm.t_acc_vales es
        where es.acc_vales_numero= vVales_Numero
        and es.glb_rota_codigo= vVales_Rota;
        
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_NUMERO: '           || vValeDados.ACC_VALES_NUMERO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'GLB_ROTA_CODIGO_OPERACAO: '   || vValeDados.GLB_ROTA_CODIGO_OPERACAO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_CONTAS_CICLO: '           || vValeDados.ACC_CONTAS_CICLO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'CAX_OPERACAO_CODIGO: '        || vValeDados.CAX_OPERACAO_CODIGO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_DATA: '             || vValeDados.ACC_VALES_DATA;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_VALOR: '            || vValeDados.ACC_VALES_VALOR;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_ACONTAS_NUMERO: '         || vValeDados.ACC_ACONTAS_NUMERO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'GLB_ROTA_CODIGO: '            || vValeDados.GLB_ROTA_CODIGO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_DATAGRAV: '         || vValeDados.ACC_VALES_DATAGRAV;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_FLAGPESS: '         || vValeDados.ACC_VALES_FLAGPESS;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'FRT_MOTORISTA_CODIGO: '       || vValeDados.FRT_MOTORISTA_CODIGO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_OBSERVACAO: '       || vValeDados.ACC_VALES_OBSERVACAO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_DATARECEBIMENTO: '  || vValeDados.ACC_VALES_DATARECEBIMENTO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_FLAGENVDP: '        || vValeDados.ACC_VALES_FLAGENVDP;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_AUTORIZADO: '       || vValeDados.ACC_VALES_AUTORIZADO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_USUAUTORIZOU: '     || vValeDados.ACC_VALES_USUAUTORIZOU;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_DTAUTORIZOU: '      || vValeDados.ACC_VALES_DTAUTORIZOU;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_VLAUTORIZADO: '     || vValeDados.ACC_VALES_VLAUTORIZADO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_TPDESPESA_CODIGO: '       || vValeDados.ACC_TPDESPESA_CODIGO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_USUCRIOU: '         || vValeDados.ACC_VALES_USUCRIOU;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_USUALTEROU: '       || vValeDados.ACC_VALES_USUALTEROU;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'GLB_ROTA_CODIGOCAX: '         || vValeDados.GLB_ROTA_CODIGOCAX;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'CAX_BOLETIM_DATA: '           || vValeDados.CAX_BOLETIM_DATA;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'CAX_MOVIMENTO_SEQUENCIA: '    || vValeDados.CAX_MOVIMENTO_SEQUENCIA;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_IMPRESSAO: '        || vValeDados.ACC_VALES_IMPRESSAO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_DTIMPRESSAO: '      || vValeDados.ACC_VALES_DTIMPRESSAO;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_USUIMPRIMIU: '      || vValeDados.ACC_VALES_USUIMPRIMIU;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'ACC_VALES_DTENVDEP: '         || vValeDados.ACC_VALES_DTENVDEP;
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'DATA DA EXCLUSAO '            || sysdate;        
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'pAcao:  '                     || pAcao;                                                                                                            
        --Excluo o registro.
        delete t_acc_vales  v
        where v.acc_vales_numero = vVales_Numero
          and v.glb_rota_codigo = vVales_Rota;
        
        --Registra o log como informação  
        vLinhaLog.Log_Tipo_Codigo := 'I';
        vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'OK|';
        
        
        
        
    
       --colocado por Lucas para descobrir qual rotina está processando esse 	
/*       if(lower(trim(vDadosUsuario.os_user)) = 'oracle')then
       
            FOR P_CURSOR IN ( SELECT *
                              FROM V_GLB_AMBIENTE)
            LOOP
              vString :=' TERMINAL'      ||' - '|| P_CURSOR.TERMINAL                  ||CHR(13)||
              '  LANGUAGE'              ||' - '|| P_CURSOR.LANGUAGE                  ||CHR(13)||
              '  SESSIONID'             ||' - '|| P_CURSOR.SESSIONID                 ||CHR(13)||
              '  INSTANCE'              ||' - '|| P_CURSOR.INSTANCE                  ||CHR(13)||
              '  ENTRYID'               ||' - '|| P_CURSOR.ENTRYID                   ||CHR(13)||
              '  ISDBA'                 ||' - '|| P_CURSOR.ISDBA                     ||CHR(13)||
              '  NLS_TERRITORY'         ||' - '|| P_CURSOR.NLS_TERRITORY             ||CHR(13)||
              '  NLS_CURRENCY'          ||' - '|| P_CURSOR.NLS_CURRENCY              ||CHR(13)||
              '  NLS_CALENDAR'          ||' - '|| P_CURSOR.NLS_CALENDAR              ||CHR(13)||
              '  NLS_DATE_FORMAT'       ||' - '|| P_CURSOR.NLS_DATE_FORMAT           ||CHR(13)||
              '  NLS_DATE_LANGUAGE'     ||' - '|| P_CURSOR.NLS_DATE_LANGUAGE         ||CHR(13)||
              '  NLS_SORT'              ||' - '|| P_CURSOR.NLS_SORT                  ||CHR(13)||
              '  CURRENT_USER'          ||' - '|| P_CURSOR.CURRENT_USER              ||CHR(13)||
              '  CURRENT_USERID'        ||' - '|| P_CURSOR.CURRENT_USERID            ||CHR(13)||
              '  SESSION_USER'          ||' - '|| P_CURSOR.SESSION_USER              ||CHR(13)||
              '  SESSION_USERID'        ||' - '|| P_CURSOR.SESSION_USERID            ||CHR(13)||
              '  PROXY_USER'            ||' - '|| P_CURSOR.PROXY_USER                ||CHR(13)||
              '  PROXY_USERID'          ||' - '|| P_CURSOR.PROXY_USERID              ||CHR(13)||
              '  DB_DOMAIN'             ||' - '|| P_CURSOR.DB_DOMAIN                 ||CHR(13)||
              '  DB_NAME'               ||' - '|| P_CURSOR.DB_NAME                   ||CHR(13)||
              '  HOST'                  ||' - '|| P_CURSOR.HOST                      ||CHR(13)||
              '  OS_USER'               ||' - '|| P_CURSOR.OS_USER                   ||CHR(13)||
              '  EXTERNAL_NAME'         ||' - '|| P_CURSOR.EXTERNAL_NAME             ||CHR(13)||
              '  IP_ADDRESS'            ||' - '|| P_CURSOR.IP_ADDRESS                ||CHR(13)||
              '  NETWORK_PROTOCOL'      ||' - '|| P_CURSOR.NETWORK_PROTOCOL          ||CHR(13)||
              '  BG_JOB_ID'             ||' - '|| P_CURSOR.BG_JOB_ID                 ||CHR(13)||
              '  FG_JOB_ID'             ||' - '|| P_CURSOR.FG_JOB_ID                 ||CHR(13)||
              '  AUTHENTICATION_TYPE'   ||' - '|| P_CURSOR.AUTHENTICATION_TYPE       ||CHR(13)||
              '  AUTHENTICATION_DATA'   ||' - '|| P_CURSOR.AUTHENTICATION_DATA       ||CHR(13)||
              '  CURRENT_SQL'           ||' - '|| P_CURSOR.CURRENT_SQL               ||CHR(13)||
              '  CLIENT_IDENTIFIER'     ||' - '||P_CURSOR.CLIENT_IDENTIFIER          ||CHR(13)||
              '  GLOBAL_CONTEXT_MEMORY' ||' - '||P_CURSOR.GLOBAL_CONTEXT_MEMORY      ||CHR(13)||
              '  AUDITCURSORID'         ||' - '||P_CURSOR.AUDITCURSORID              ||CHR(13)||
              '  CLIENT_INFO'           ||' - '||P_CURSOR.CLIENT_INFO                ||CHR(13)||
              '  CURRENT_SCHEMA'        ||' - '||P_CURSOR.CURRENT_SCHEMA             ||CHR(13)||
              '  CURRENT_SCHEMAID'      ||' - '||P_CURSOR.CURRENT_SCHEMAID           ||CHR(13)||
              '  LANG'                  ||' - '||P_CURSOR.LANG                       ||CHR(13)||
              '  PROGRAM'               ||' - '||P_CURSOR.PROGRAM                    ||CHR(13)||
              '  SID'                   ||' - '||P_CURSOR.SID                        ||CHR(13)||
              '  SERIAL#'               ||' - '||P_CURSOR.SERIAL#                    ||CHR(13)||
              '  LOGON_TIME'            ||' - '||P_CURSOR.LOGON_TIME                 ||CHR(13)||
              '  BANCO'                 ||' - '||P_CURSOR.BANCO                      ||CHR(13)||
              '  PL_SQL'                ||' - '||P_CURSOR.PL_SQL                     ||CHR(13)||
              '  CORE'                  ||' - '||P_CURSOR.CORE                       ||CHR(13)||
              '  TNS'                   ||' - '||P_CURSOR.TNS                        ||CHR(13)||
              '  LISTENER'              ||' - '||P_CURSOR.LISTENER                   ||CHR(13)||
              '  VERIFICA'              ||' - '||P_CURSOR.VERIFICA                   ||CHR(13)||
              '  DATA'                  ||' - '||P_CURSOR.DATA;                        
              END LOOP;
              
              vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || CHR(13) ||' Rotina Inesperada: Dados V_GLB_AMBIENTE '||vString;
                                              
               
                                                                       
       else*/
--         vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || 'UsuExclusao: ' || vDadosUsuario.os_user; 
--       end if;   
        
        --Insere o registro de log
        insert into t_log_system values vLinhaLog;
        
        commit;
      Exception
        --Caso ocorra algum erro durante a exclusão do vale
        when others then
          --registra o log de erro.
          vLinhaLog.Log_Tipo_Codigo := 'E';
          vLinhaLog.Log_System_Message := vLinhaLog.Log_System_Message || sqlerrm || '|';
          
          insert into t_log_system values vLinhaLog;
          commit;
           
          Raise_application_error(-20001, 'Erro ao excluir o Vale: ' || vVales_Numero || ' na rota ' || vVales_Rota || chr(13) || sqlerrm);
      end;   
    end loop;
    
    --fechar o cursor
    close vCursor;
    
    --Chegando até aqui, é porque não ocorreu nenhum erro.
    pStatus := pkg_glb_common.Status_Nomal;
    pMessage := 'Foram Excluidos ' || Trim(to_char( vControl ) ) || ' Vales. Rotina "pkg_acc_vales.sp_ExcluirVales"';
  Exception
   --caso ocorra algum erro durante o processo, mostro a mensagem gerada.
   when others then
     pStatus := pkg_glb_common.Status_Erro;
     pMessage := sqlerrm; 
  end;
end sp_ExcluirVales;                              
  
                              


                  
                              



end pkg_acc_vales;
/
