create or replace package pkg_veicdisp Is

--Procedure utilizada como ancoragem para conexões com o DBExpress
Procedure SP_ExecuteDBX( pXmlin In Varchar2,
                         pXmlOut Out  Clob
                        );

Procedure SP_Get_Excecao( pParamsEntrada  in varchar2,
                          pStatus         out char,
                          pMessage        out varchar2,
                          pParamsSaida    out cLob
                        ) ;                        

--Função utilizada para devolver relação de motorista a partir de uma placa
Function Fn_Get_DadosMotorista( pPlaca In Char,
                                pMessage Out Varchar2,
                                pXmlDados Out Varchar2 
                               ) Return Boolean;                               
                               
-- Função utilizada para recuperar dados de motorista a partir de uma placa                                                   --
Function FN_Get_DadosMotor( pPlaca_Codigo In Char,
                            pUsuario In tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                            pAplicacao In tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type,
                            pRota In tdvadm.t_glb_rota.glb_rota_codigo%Type,
                            pMessage Out Varchar2,
                            pXmlOut Out Varchar2
                           ) Return Boolean;                               



--Procedure utilizada para buscar dados de um motorista a partir de uma placa
procedure sp_get_DadosMotor( pParamsEntrada  in varchar2,
                             pStatus         out char,
                             pMessage        out varchar2,
                             pParamsSaida    out cLob
                            );
                            
-- @Official                            
procedure sp_get_DadosMotor_( pParamsEntrada  in varchar2,
                             pStatus         out char,
                             pMessage        out varchar2,
                             pParamsSaida    out cLob
                            );                            



end pkg_veicdisp;

 
/
create or replace package body pkg_veicdisp Is
 --Variáveis internas utilizadas para administrar Exceções.
 vEx_ParamsEntrada Exception;
 vEx_AbrirCursor Exception;
  

--Tipos utilizados em fetchs de Cursores
Type tDadosMotor is Record ( Motorista_Nome   varchar2(50),
                             Motorista_CPF    varchar2(20),
                             Motorista_Saque  char(04),
                             Veiculo_placa    char(07),
                             Veiculo_Saque    char(04)
                           );

--Tipo Utilizada como estrutura do Cursor de Bloqueios / Alertas TDV
type tBloqAlertTDV is record ( Mensagem      varchar2(500),
                               Placa         varchar2(10)      
                              ); 

--Tipo utilizado como estrutura para o cursor de Exceção
Type tExcecao is record ( Localidade varchar2(100),
                          Valor number,
                          Desinencia varchar2(10)
                         ); 
                          

---------------------------------------------------------------------------------------------------------------------
--Procedure utilizada como ancoragem para conexões com o DBExpress                                                 --
---------------------------------------------------------------------------------------------------------------------
Procedure SP_ExecuteDBX( pXmlIn in  Varchar2,
                         pXmlOut Out Clob
                        ) As

 --Váriável utilizada para recuperar os paramentros do XML
 vProcName varchar2(60);
 vPackageName varchar2(60);

 --Variável utilizada para armazenar o comando.
 vCommand varchar2(5000);
 
 --Variáveis Auxiliares que serão utilizadas na execução de procedures
 vStatus char(01);
 vMessage varchar2(5000);                        
                         
Begin
  --Inicilizao as variáveis que serão utilizadas nessa procedure.
  vProcName:= '';
  vCommand := '';
  vStatus := '';
  vMessage := '';
  

  
  Begin
    --Recupero o nome da procedure e package que será utilizada 
    vProcName := pkg_glb_common.FN_getParams_Xml(pXmlIn, 'procedure_name');
    vPackageName := pkg_glb_common.FN_getParams_Xml(pXmlIn, 'package_name');
    
    --verifico se foi passado o nome de algum package
    if (trim(nvl(vPackageName, 'R')) <> 'R') then
      --concateno o nome_do_package + ' . ' + nome_da_procedure
      vProcName := Trim(vPackageName) || '.' || Trim(vProcName);
    end if;
        
    --Monto o comando que será utilizado na execução da procedure
    vCommand := ' begin  ' || Trim(vProcName) || '( :pXmlEntrada, :Status, :Message, :pXmlRetorno); end; ';

    --Executo o comando propriamente dito, passando os paramentros. 
    execute immediate  vCommand  using in pXmlIn, in out vStatus, in out vMessage, in out pXmlOut;
  End;

End SP_ExecuteDBX;                        
                         

---------------------------------------------------------------------------------------------------------------------                        
-- Função utilizada para gerar arquivo XML                                                                         --
---------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_BloqAlertTDV( pLinha   integer,
                               pDados   tBloqAlertTDV
                              ) return varchar2 is 
  --Variável utilizada como retorno da função                  
  vRetorno   varchar2(10000);
Begin
  --Inicializa a variável 
  vRetorno := '';
      
  --Caso o paramentro pLinha seja maior que zero, gera uma linha do arquivo XML
  if pLinha > 0 then
    vRetorno := vRetorno || '<row num=§' ||  Trim(to_char(pLinha))      || '§ > ';
    vRetorno := vRetorno || '<placa>'    ||  Trim(pDados.Placa)         || '</placa>'   ;
    vRetorno := vRetorno || '<mensagem>' ||  Trim(tdvadm.pkg_glb_common.FN_LIMPA_CAMPO(pDados.Mensagem))      || '</mensagem>';
    vRetorno := vRetorno || '</row>';
  end if;
      
  --Caso o paramentro pLinha seja igual a zero, gera uma linha em branco.
  if pLinha = 0 then
    vRetorno := vRetorno || '<row num=§1§>' ;
    vRetorno := vRetorno || '<placa />'     ;
    vRetorno := vRetorno || '<mensagem />'  ;
    vRetorno := vRetorno || '</row>';
  end if;
      
  --Retorna a variáve preenchida 
  return vRetorno;
  
end FNP_Xml_BloqAlertTDV;

--Função privada utlizada para definir o XML de retorno.
                              
                           
                           
--------------------------------------------------------------------------------------------------------------------------------
-- Função privada utilizada para gerar SQL de consulta de Dados de Motorista a partir de uma placa                            --
--------------------------------------------------------------------------------------------------------------------------------
Function FNP_SQL_DadosMotor( pPlaca_Codigo  char) return varchar2 as
 --Variáveis utilizadas para montar o SQL
 vSqlFrota   varchar2(10000);
 vSqlAgreg   varchar2(10000);
 vSqlCarrFrota Varchar2(1000); 
 
 --Variável utilizada como retorno da função
 vRetorno Varchar2(20000);
begin
  --inicializa as variáveis utilizada nessa função.
  vSqlFrota := '';
  vSqlAgreg := '';
  vRetorno := '';
  vSqlCarrFrota := '';

  --Monta o SQL para busca de frota.
  vSqlFrota := ' SELECT                                                  '
            || '  MO.FRT_MOTORISTA_NOME        Motorista_Nome,           '
            || '  MO.FRT_MOTORISTA_CPF         Motorista_CPF,            '
            || '  § §                          Motorista_Saque,          '
            || '  §' || pPlaca_Codigo || '§    Veiculo_placa,            '
            || '  § §                          Veiculo_Saque             '
            || 'FROM                                                     '
            || '  T_FRT_CONJUNTO    CV,                                  '
            || '  T_FRT_MOTORISTA   MO                                   '
            || ' WHERE                                                   '
            || '   MO.FRT_MOTORISTA_CODIGO = CV.FRT_MOTORISTA_CODIGO     '
            || '   AND CV.FRT_CONJVEICULO_CODIGO =  §' || pPlaca_Codigo || '§ ' ;


  --Monta o Sql para busca de Carreteiro.
  vSqlAgreg := ' Select                                                  ' 
            || '   carret.car_carreteiro_nome      Motorista_Nome,       '
            || '   carret.car_carreteiro_cpfcodigo Motorista_CPF,        '
            || '   carret.car_carreteiro_saque     Motorista_Saque,      '
            || '   VEIC.CAR_VEICULO_PLACA          Veiculo_placa,        '
            || '   VEIC.CAR_VEICULO_SAQUE          Veiculo_Saque         ' 
            || ' From                                                    '
            || '   tdvadm.t_car_carreteiro carret,                       '
            || '   tdvadm.t_car_veiculo  veic                            '
            || ' Where                                                   '
            || '   veic.car_veiculo_placa = carret.car_veiculo_placa     '
            || '   And veic.car_veiculo_saque = carret.car_veiculo_saque '
            || '   And veic.car_veiculo_placa = §' || pPlaca_Codigo || '§ '
            || '   And VEIC.CAR_VEICULO_SAQUE = ( Select Max(subveic.car_veiculo_saque) From T_CAR_VEICULO SubVeic '
            || '                                  Where subVeic.Car_Veiculo_Placa = veic.car_veiculo_placa         '
            || '                                 )                        '  
            || '  And carret.car_carreteiro_saque = ( Select Max(subcarret.car_carreteiro_saque) From t_car_carreteiro subCarret '
            || '                                      Where subcarret.car_carreteiro_cpfcodigo = carret.car_carreteiro_cpfcodigo '
            || '                                    )   ';   
                         
  vSqlCarrFrota :=  ' Select                                              '
                 || '   marca.frt_marmodveic_marca || marca.frt_marmodveic_modelo, '
                 || ' §00000000000§,                                                         '
                 || ' § §,                                                         '
                 || '  §' || pPlaca_Codigo || '§    Veiculo_placa,                 '                  
                 || ' § § Veiculo_Saque                                            '
                 || 'From                                                          '
                 || '     t_frt_veiculo Veiculo,                                   '  
                 || '     t_frt_marmodveic marca                                   '
                 || 'Where                                                         '  
                 || ' Veiculo.Frt_Marmodveic_Codigo = marca.frt_marmodveic_codigo '
                 || ' And veiculo.frt_veiculo_placa = §' || pPlaca_Codigo || '§ ' ;

                         

  --                                                             

  --Retorna as variáveis preenchidas e unidas.
  vRetorno := REPLACE(vSqlFrota || ' union ' || vSqlAgreg || ' union ' || vSqlCarrFrota, '§', '''');
  
  DBMS_OUTPUT.put_line( vRetorno );
  
  --devolve a variável preenchida e tratada.
  Return vRetorno;

end FNP_SQL_DadosMotor;

--------------------------------------------------------------------------------------------------------------------------------
-- @Official --> Incluído para receber a placa da carreta.
-- Diego Lirio
-- Função privada utilizada para gerar SQL de consulta de Dados de Motorista a partir de uma placa                            --
--------------------------------------------------------------------------------------------------------------------------------
Function FN_SQL_DadosMotor( pPlaca_Codigo  char, pPlaca_Carreta in Char) return varchar2 as
 --Variáveis utilizadas para montar o SQL
 vSqlFrota   varchar2(10000);
 vSqlAgreg   varchar2(10000);
 vSqlCarrFrota Varchar2(1000); 
 
 --Variável utilizada como retorno da função
 vRetorno Varchar2(20000);
begin
  --inicializa as variáveis utilizada nessa função.
  vSqlFrota := '';
  vSqlAgreg := '';
  vRetorno := '';
  vSqlCarrFrota := '';

  --Monta o SQL para busca de frota.
  vSqlFrota := ' SELECT                                                  '
            || '  MO.FRT_MOTORISTA_NOME        Motorista_Nome,           '
            || '  MO.FRT_MOTORISTA_CPF         Motorista_CPF,            '
            || '  § §                          Motorista_Saque,          '
            || '  §' || pPlaca_Codigo || '§    Veiculo_placa,            '
            || '  § §                          Veiculo_Saque             '
            || 'FROM                                                     '
            || '  T_FRT_CONJUNTO    CV,                                  '
            || '  T_FRT_MOTORISTA   MO                                   '
            || ' WHERE                                                   '
            || '   MO.FRT_MOTORISTA_CODIGO = CV.FRT_MOTORISTA_CODIGO     '
            || '   AND CV.FRT_CONJVEICULO_CODIGO =  §' || pPlaca_Codigo || '§ ' ;


  --Monta o Sql para busca de Carreteiro.
  vSqlAgreg := ' Select                                                  ' 
            || '   carret.car_carreteiro_nome      Motorista_Nome,       '
            || '   carret.car_carreteiro_cpfcodigo Motorista_CPF,        '
            || '   carret.car_carreteiro_saque     Motorista_Saque,      '
            || '   VEIC.CAR_VEICULO_PLACA          Veiculo_placa,        '
            || '   VEIC.CAR_VEICULO_SAQUE          Veiculo_Saque         ' 
            || ' From                                                    '
            || '   tdvadm.t_car_carreteiro carret,                       '
            || '   tdvadm.t_car_veiculo  veic                            '
            || ' Where                                                   '
            || '   veic.car_veiculo_placa = carret.car_veiculo_placa     '
            || '   And veic.car_veiculo_saque = carret.car_veiculo_saque '
            || '   And veic.car_veiculo_placa = §' || pPlaca_Codigo || '§ ';
      if (nvl(pPlaca_Carreta, '-1') != '-1')/* and (pPlaca_Carreta != '') */ then
         vSqlAgreg := vSqlAgreg || '   And veic.car_veiculo_carreta_placa = §' || pPlaca_Carreta || '§ ';
      else
      vSqlAgreg := vSqlAgreg || '   And VEIC.CAR_VEICULO_SAQUE = ( Select Max(subveic.car_veiculo_saque) From T_CAR_VEICULO SubVeic '
            || '                                  Where subVeic.Car_Veiculo_Placa = veic.car_veiculo_placa         '
            || '                                 )                        '  
            || '  And carret.car_carreteiro_saque = ( Select Max(subcarret.car_carreteiro_saque) From t_car_carreteiro subCarret '
            || '                                      Where subcarret.car_carreteiro_cpfcodigo = carret.car_carreteiro_cpfcodigo '
            || '                                    )   ';   
      end if;
      --vSqlAgreg := vSqlAgreg || '   And veic.car_veiculo_carreta_placa = §' || pPlaca_Carreta || '§ ';
                         
  vSqlCarrFrota :=  ' Select                                              '
                 || '   marca.frt_marmodveic_marca || marca.frt_marmodveic_modelo, '
                 || ' §00000000000§,                                                         '
                 || ' § §,                                                         '
                 || '  §' || pPlaca_Codigo || '§    Veiculo_placa,                 '                  
                 || ' § § Veiculo_Saque                                            '
                 || 'From                                                          '
                 || '     t_frt_veiculo Veiculo,                                   '  
                 || '     t_frt_marmodveic marca                                   '
                 || 'Where                                                         '  
                 || ' Veiculo.Frt_Marmodveic_Codigo = marca.frt_marmodveic_codigo '
                 || ' And veiculo.frt_veiculo_placa = §' || pPlaca_Codigo || '§ ' ;

                         

  --                                                             

  --Retorna as variáveis preenchidas e unidas.
  vRetorno := REPLACE(vSqlFrota || ' union ' || vSqlAgreg || ' union ' || vSqlCarrFrota, '§', '''');
  
  DBMS_OUTPUT.put_line( vRetorno );
  
  --devolve a variável preenchida e tratada.
  Return vRetorno;
 
end FN_SQL_DadosMotor;

--------------------------------------------------------------------------------------------------------------------------------
--Função Privada utilizada para gerar uma linha do Arquivo Xml de retorno para a consulta de Dados de Motorista               --
--------------------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_DadosMotor( pDadosMotor tDadosMotor,
                             pLinha Integer
                           ) Return Varchar2 Is
 --Variável que será utilizada como retorno da função.
 vRetorno Varchar2(10000);
 --Variável utilizada para limpar os campos possiveis de acentos.
 vNomeMotorista tdvadm.t_car_carreteiro.car_carreteiro_nome%Type;
Begin
  --Inicializa a variável
  vRetorno := '';
  
  --Verifico se a Linha passada é maior que zero.
  If ( pLinha > 0 ) Then
    --Limpo campos possíveis de acentos
    vNomeMotorista := pkg_glb_common.FN_LIMPA_CAMPO(pDadosMotor.Motorista_Nome);
    
    --Preenche linha XML.
    vRetorno := '<row num=§'           || Trim(to_char(pLinha))             || '§ > '               ||
                   '<Motorista_Nome>'  || Trim(vNomeMotorista )             || '</Motorista_Nome>'  || 
                   '<Motorista_CPF>'   || Trim(pDadosMotor.Motorista_CPF)   || '</Motorista_CPF>'   || 
                   '<Motorista_Saque>' || Trim(pDadosMotor.Motorista_Saque) || '</Motorista_Saque>' || 
                   '<Veiculo_placa>'   || Trim(pDadosMotor.Veiculo_placa)   || '</Veiculo_placa>'   || 
                   '<Veiculo_Saque>'   || Trim(pDadosMotor.Veiculo_Saque)   || '</Veiculo_Saque>'   ||
                 '</row>';  
  End If;
  
  --caso o paramentro de linha tenha valor zerado 
  If ( pLinha = 0 )  Then
    --Preenche uma linha Xml sem dados.    
    vRetorno := '<row num=§0§ > '       ||
                   '<Motorista_Nome>VEICULO NAO CADASTRADO</Motorista_Nome>'  ||  
                   '<Motorista_CPF>00000000000</Motorista_CPF>'   ||  
                   '<Motorista_Saque />' ||  
                   '<Veiculo_placa />'   ||  
                   '<Veiculo_Saque />'   || 
                 '</row>';  
  End If;
  
  --substitui os caracteres coringas.
  vRetorno := Replace(vRetorno, '§', '''');
  
  --devolve a variável preenchida.
  Return vRetorno;
  
End FNP_Xml_DadosMotor;                             


--------------------------------------------------------------------------------------------------------------------------------
-- Função Privada utilizada para gerar uma linha do Arquivo Xml de retorno para a consulta de Dados de Motorista.             --
--------------------------------------------------------------------------------------------------------------------------------
Function FNP_Xml_DadosMotor( pDadosMotor      tDadosMotor,
                             pLinha           integer,
                             pIdValid_Cod     Char,
                             pIdValid_Rota    Char,
                             pIdValid_Status  Varchar2
                            ) return varchar2 as
 --Variável que será utilizada no retorno da função.
 vRetorno  varchar2(10000);                            
begin
  --Inicializa as variáveis que serão utilizadas nessa função.
  vRetorno := '';
  
  --Caso a linha seja passada Zerada, crio uma linha de xml sem conteúdo.
  if pLinha = 0 then
    vRetorno :=    '<row num=§0§ >'                       
                || '<Motorista_Nome />'     
                || '<Motorista_CPF />'      
                || '<Motorista_Saque />'    
                || '<Veiculo_placa />'      
                || '<Veiculo_Saque />'      
                || '<con_freteoper_id />'     
                || '<con_freteoper_rota />' 
                || '<status_id />'                   
                || '</row>';              
                
  end if;
  
  --Caso o paramentro pLinha seja maior que zero, gero uma linha de Xml com os dados passados.
  if pLinha > 0 then
    vRetorno :=    '<row num=§'           || Trim(to_char(pLinha))                  || '§ >'            
                || '<Motorista_Nome>'     || Trim(pkg_glb_common.FN_LIMPA_CAMPO( pDadosMotor.Motorista_Nome)) || ' - ' || Trim(pDadosMotor.Motorista_Saque)    || '</Motorista_Nome>'
                || '<Motorista_CPF>'      || Trim(pDadosMotor.Motorista_CPF)        || '</Motorista_CPF>'
                || '<Motorista_Saque>'    || Trim(pDadosMotor.Motorista_Saque)      || '</Motorista_Saque>'
                || '<Veiculo_placa>'      || Trim(pDadosMotor.Veiculo_placa)        || '</Veiculo_placa>'
                || '<Veiculo_Saque>'      || Trim(pDadosMotor.Veiculo_Saque)        || '</Veiculo_Saque>'
                || '<con_freteoper_id>'   || Trim(pIdValid_Cod)                     || '</con_freteoper_id>'  
                || '<con_freteoper_rota>' || Trim( pIdValid_Rota)                   || '</con_freteoper_rota>'
                || '<status_id>'          || Trim(pIdValid_Status)                  || '</status_id>'         
                || '</row>';                
  end if;
  --Retorno Variável preenchida.
  return  vRetorno;
  
end FNP_XML_DadosMotor; 

                            
--------------------------------------------------------------------------------------------------------------------------------
-- Função utilizada para devolver relação de motorista a partir de uma placa                                                  --
--------------------------------------------------------------------------------------------------------------------------------
Function Fn_Get_DadosMotorista( pPlaca In Char,
                                pMessage Out Varchar2,
                                pXmlDados Out Varchar2 
                              ) Return Boolean Is
  --Variável cursor utilizada para receber o Sql das Placas.
  vCursor pkg_glb_common.T_CURSOR;
  
  --Variável de do tipo tDadosMotor, utilizada para facilitar a extração dos dados do Cursor.
  vDadosMotor tDadosMotor;
  
  --Variável que será utilizadada para montar o arquivo Xml.
  vXmlRetorno Varchar2(30000);
  
  --variável utilizada para definir linha do xml de retorno
  vLinha Integer;
  
  VtESTE Varchar2(5000);
                              
Begin
  --inicializa as variáveis utilizadas nessa função
  vXmlRetorno := '';
  vLinha := 0;
  
  Begin
    Begin
      --abro o cursor passando a placa como paramentro para a função FNP_SQL_DadosMotor
      Open vCursor For FNP_SQL_DadosMotor(pPlaca);
      
      VtESTE := FNP_SQL_DadosMotor(pPlaca);

    Exception
      --caso ocorra algum erro dutante a abertura d cursor
      When Others Then
        Raise vEx_AbrirCursor;
    End;
    
    --enro em loop para percorrer o o cursor.
    Loop
      --utilizo o fetch para recuperar a linha do Cursor.
      Fetch vCursor Into vDadosMotor;
      
      --Garanto a saida do loop ao final do cursor.
      Exit When vCursor%Notfound;
      
      --incremento a variável de linha
      vLinha := vLinha +1;
      
      --monto linha a linha o Xml de veiculos.
      pXmlDados := pXmlDados || FNP_Xml_DadosMotor( vDadosMotor, vLinha);
    End Loop;
    
    --Fecho ao cursor de dados Motorista.
    Close vCursor;
    
    --Caso a variável de vLinha esteja com valor zerado 
    If ( vLinha = 0 ) Then
      --monto uma linha do xml sem dados para garantir que não vai dar erro no frontEnd;
      pXmlDados := FNP_Xml_DadosMotor( vDadosMotor, vLinha);
    End If;
       
    --seto a mensagem para fazia e o retorno para verdadeiro.
    pMessage:= '';
    Return True;

  Exception 
    --Erro ao abrir o cursor 
    When vEx_AbrirCursor Then
      Return False;
      
    --caso ocorra algum erro não esperado.
    When Others Then
      pMessage := 'Erro: ' || Sqlerrm;
      Return False;
  End;
End Fn_Get_DadosMotorista;  

--------------------------------------------------------------------------------------------------------------------------------
-- Função utilizada para recuperar dados de motorista a partir de uma placa                                                   --
--------------------------------------------------------------------------------------------------------------------------------
Function FN_Get_DadosMotor( pPlaca_Codigo In Char,
                            pUsuario In tdvadm.t_usu_usuario.usu_usuario_codigo%Type,
                            pAplicacao In tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%Type,
                            pRota In tdvadm.t_glb_rota.glb_rota_codigo%Type,
                            pMessage Out Varchar2,
                            pXmlOut Out Varchar2
                           ) Return Boolean Is
                           
 --Variáveis utilizadas para executar a procedure responsável por trazer o Id de validação
 vCnpjProp         tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%Type;
 vIdValid_Codigo   tdvadm.t_con_freteoper.con_freteoper_id%Type;
 vIdValid_Rota     tdvadm.t_con_freteoper.con_freteoper_rota%Type;
 vFlagId           Char(01);
 vIdValid_Status   Varchar2(10);
 
 --Variável do tipo cursor.
 vCursor tdvadm.pkg_glb_common.T_CURSOR;

 --Variável com a mesma estrutura do Cursor para facilitar o fetch
 vTpCursor  tDadosMotor;
 
 vStatus Char(01);
 
 vLinhaXml Integer;
 
 
  --Variáveis XML
  vXmlDadosMotor  varchar2(30000);
                           
Begin
  vLinhaXml := 0;
  
  Begin
    --Abro o cursor utilizando o sql gerado atraves da função fnp_sql_DadosMotor.
    open vCursor for  FNP_SQL_DadosMotor( Trim(pPlaca_Codigo) );
    
    Loop
      --Fetch para acessar os dados linha a linha
      fetch vCursor into vTpCursor;
      
      --Para garantir que vai sair do loop ao final do cursor.
      exit when vCursor%notfound;
      
      --Caso a placa não seja de um frota,
      If ( SubStr( Trim(vTpCursor.Veiculo_placa), 1, 2) != '00') Then
        -- Busco o Proprietário desse Veículo.
        Begin
          Select 
            prop.car_proprietario_cgccpfcodigo
          Into
            vCnpjProp  
          From 
            t_car_proprietario prop,
            t_car_veiculo      veiculo
          Where
            0=0
            And prop.car_proprietario_cgccpfcodigo = veiculo.car_proprietario_cgccpfcodigo
            And veiculo.car_veiculo_placa = vTpCursor.Veiculo_placa
            And veiculo.car_veiculo_saque = ( Select max(veic.car_veiculo_saque) From t_car_veiculo veic
                                              Where veic.car_veiculo_placa = vTpCursor.Veiculo_placa
                                            );  
          
        Exception
          --Caso não encontre nnhum regisro
          When no_data_found Then
            pMessage := 'Proprietario não encontrado';
            Return False;
            
          --Caso ocorra algum erro na busca.
          When Others Then
            pMessage := 'Erro ao tentar localizar proprietário';
            Return False;  
        End;
      
      End If;  
      
      
       --Executo a procedure que vai retornar um id Válido,
      Begin
        tdvadm.pkg_cfe_frete.sp_get_idValidacao( 1, 
                                                 Trim(vCnpjProp),
                                                 Trim(vTpCursor.Motorista_CPF),
                                                 Trim(vTpCursor.Motorista_Saque),
                                                 Trim(vTpCursor.Veiculo_placa),
                                                 Trim(vTpCursor.Veiculo_Saque),
                                                 vIdValid_Codigo,
                                                 vIdValid_Rota,
                                                 vFlagId,
                                                 vStatus,
                                                 pMessage
                                               ); 
        --Verifico se a procedure foi processada corretamente
        If vStatus <> pkg_glb_common.Status_Nomal Then
          --Como foi passado os paramentros de saida para a execução, simplesmente finalizo.
          Return False;
        End If;
        
      Exception
        --Caso ocorra algum erro durante a execução da procedure. retorno o erro e encerro o processamento
        When Others Then
          
          pMessage := 'Erro: ' || Sqlerrm;
          Return False;
      End;
      
      --incrementa a variável de linha
      vLinhaXml := vLinhaXml +1;
      
      --Começo a montar o arquivo Xml utilizando a função FNP_XML_DADOSMOTOR
      vXmlDadosMotor := vXmlDadosMotor || FNP_XML_DadosMotor( vTpCursor, vLinhaXml, 
                                                              to_char(vIdValid_Codigo),  
                                                              vIdValid_Rota,
                                                              Trim( pkg_cfe_frete.FN_GET_IDVALIDO(vIdValid_Codigo, vIdValid_Rota) )
                                                             );
    end loop;

    --Fecho o cursor apos o loop;
    close vCursor;
    
    --Caso o cursor tenha sido aberto sem registro crio um arquivo XML em branco
    if vLinhaXml = 0 then
      vXmlDadosMotor := vXmlDadosMotor || FNP_XML_DadosMotor( vTpCursor, vLinhaXml, '', '', '');
    end if;
      
      pXmlOut:=  vXmlDadosMotor;
      pMessage := '';
      Return True;
    
    
  Exception
    
    When Others Then
      pMessage := 'Erro ao recuperar dados do Veiculo. ' || chr(10) ||
                  'Rotina: pkg_veicdisp.fn_get_dadosmotor(); ' || chr(10) ||
                  'Erro ora: ' || Sqlerrm;
      Return False;            
  End;
  
End FN_Get_DadosMotor;                             
                            

--------------------------------------------------------------------------------------------------------------------------------
-- PROCEDURE UTILIZADA PARA BUSCAR DADOS DE UM MOTORISTA A PARTIR DE UMA PLACA                                                --
--------------------------------------------------------------------------------------------------------------------------------
procedure sp_get_DadosMotor( pParamsEntrada  in varchar2,
                             pStatus         out char,
                             pMessage        out varchar2,
                             pParamsSaida    out cLob
                            ) is

  --Variáveis básicas de sistemas
  vUsuario       tdvadm.t_usu_usuario.usu_usuario_codigo%type;
  vAplicacao     tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type;
  vRota          tdvadm.t_glb_rota.glb_rota_codigo%type;
  
  --Variável utilizada para recuperar a placa do veiculo.
  vPlaca_Codigo  tdvadm.t_car_veiculo.car_veiculo_placa%Type;
  
  --Variável cursor, utilizada para percorrer o SQL
  vCursor  pkg_glb_common.T_CURSOR;
  
  --Variável de controle que vai definir a linha do arquivo Xml.
  vLinhaXml integer;
  
  --Variável com a mesma estrutura do Cursor para facilitar o fetch
  vTpCursor  tDadosMotor;
  
  --Variáveis utilizadas para executar a procedure responsável por trazer o Id de validação
  vCnpjProp         tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%Type;
  vIdValid_Codigo   tdvadm.t_con_freteoper.con_freteoper_id%Type;
  vIdValid_Rota     tdvadm.t_con_freteoper.con_freteoper_rota%Type;
  vFlagId           Char(01);
  vIdValid_Status   Varchar2(10);

  vStatus Char(01);
  vMessage  Varchar2(1000);
  
  
  
  --Variáveis XML
  vXmlDadosMotor  varchar2(30000);
  vXmlRetorno     cLob;
  
  
  
Begin
  If pkg_glb_common.FN_getParams_Xml( lower(pParamsEntrada), 'usuario') = 'jsantos2' Then
    pMessage := pParamsEntrada;
    pStatus := 'W';
    Return;
  End If;

  --Inicializo as variáveis que serão utilizados nessa procedure.
  vUsuario := '';
  vAplicacao := '';
  vRota := '';
  
  vPlaca_Codigo := '';

  vCnpjProp := '';
  vIdValid_Codigo := 0;  
  vIdValid_Rota   := '';
  vIdValid_Status := '';
  vFlagId := '';
  
  vStatus  := '';
  vMessage := '';

  vLinhaXml := 0;
  vXmlDadosMotor := '';
  vXmlRetorno := empty_clob();
  
  
  --Recupero os valores que foram passados por paramentros.
  vUsuario      := pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'usuario');
  vAplicacao    := pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'aplicacao');
  vRota         := pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'rota');
  vPlaca_Codigo := Trim(upper(pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'placa_codigo')));
  --vPlaca_Carreta := Trim(upper(pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'placa_carreta')));
  
  begin

    --Abro o cursor utilizando o sql gerado atraves da função fnp_sql_DadosMotor.
    open vCursor for  FNP_SQL_DadosMotor( Trim(vPlaca_Codigo) );
    
    --Entro em laço para percorrer o cursor.
    loop
      
      --Fetch para acessar os dados linha a linha
      fetch vCursor into vTpCursor;
      
      --Para garantir que vai sair do loop ao final do cursor.
      exit when vCursor%notfound;
      
      
      --Caso a placa não seja de um frota,
      If ( SubStr( Trim(vTpCursor.Veiculo_placa), 1, 2) != '00') Then
        -- Busco o Proprietário desse Veículo.
        Begin
          Select 
            prop.car_proprietario_cgccpfcodigo
          Into
            vCnpjProp  
          From 
            t_car_proprietario prop,
            t_car_veiculo      veiculo
          Where
            0=0
            And prop.car_proprietario_cgccpfcodigo = veiculo.car_proprietario_cgccpfcodigo
            And veiculo.car_veiculo_placa = vTpCursor.Veiculo_placa
            And veiculo.car_veiculo_saque = ( Select max(veic.car_veiculo_saque) From t_car_veiculo veic
                                              Where veic.car_veiculo_placa = vTpCursor.Veiculo_placa
                                            );  
          
        Exception
          --Caso não encontre nnhum regisro
          When no_data_found Then
            pStatus := pkg_glb_common.Status_Erro;
            pMessage := 'Proprietario não encontrado';
            Return;
            
          --Caso ocorra algum erro na busca.
          When Others Then
            pStatus := pkg_glb_common.Status_Erro;
            pMessage := 'Erro ao tentar localizar proprietário';
            Return;  
        End;
      
      End If;
      
      
      --Executo a procedure que vai retornar um id Válido,
      Begin
        tdvadm.pkg_cfe_frete.sp_get_idValidacao( 1, 
                                                 Trim(vCnpjProp),
                                                 Trim(vTpCursor.Motorista_CPF),
                                                 Trim(vTpCursor.Motorista_Saque),
                                                 Trim(vTpCursor.Veiculo_placa),
                                                 Trim(vTpCursor.Veiculo_Saque),
                                                 vIdValid_Codigo,
                                                 vIdValid_Rota,
                                                 vFlagId,
                                                 pStatus,
                                                 pMessage
                                               ); 
        --Verifico se a procedure foi processada corretamente
        If pStatus <> pkg_glb_common.Status_Nomal Then
          --Como foi passado os paramentros de saida para a execução, simplesmente finalizo.
          Return;
        End If;
        
      Exception
        --Caso ocorra algum erro durante a execução da procedure. retorno o erro e encerro o processamento
        When Others Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage := 'Erro: ' || Sqlerrm;
          Return;
      End;   
      
      --incremento a variável de linha
      vLinhaXml := vLinhaXml +1;
      
      --Começo a montar o arquivo Xml utilizando a função FNP_XML_DADOSMOTOR
      vXmlDadosMotor := vXmlDadosMotor || FNP_XML_DadosMotor( vTpCursor, vLinhaXml, 
                                                              to_char(vIdValid_Codigo),  
                                                              vIdValid_Rota,
                                                              Trim( pkg_cfe_frete.FN_GET_IDVALIDO(vIdValid_Codigo, vIdValid_Rota) )
                                                             );
    end loop;

    --Fecho o cursor apos o loop;
    close vCursor;
    
    --Caso o cursor tenha sido aberto sem registro crio um arquivo XML em branco
    if vLinhaXml = 0 then
      vXmlDadosMotor := vXmlDadosMotor || FNP_XML_DadosMotor( vTpCursor, vLinhaXml, '', '', '');
    end if;
    
  --Monta o arquivo propriamente dito.
  vXmlRetorno := vXmlRetorno || '<Parametros><Output><status>n</status><message /><Tables>';
  vXmlretorno := vXmlRetorno || '<Table name=#dadosMotorista#><ROWSET>' || vXmlDadosMotor || '</ROWSET></Table>';
  vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
  
  vXmlRetorno := REPLACE( vXmlRetorno, '§', '''');
  vXmlRetorno := REPLACE( vXmlRetorno, '#', '"');
  
  pStatus := PKG_GLB_COMMON.Status_Nomal;
  pMessage := '';
  pParamsSaida := vXmlRetorno;
  
  exception
    when others then
      --Caso ocorra algum erro durante o processo de abertura / tratamento do cursor.      
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar abir / Tratar cursor com dados de motorista.' || sqlerrm;
      return;
  end;  

end;

--------------------------------------------------------------------------------------------------------------------------------
-- Official
-- PROCEDURE UTILIZADA PARA BUSCAR DADOS DE UM MOTORISTA A PARTIR DE UMA PLACA                                                --
--------------------------------------------------------------------------------------------------------------------------------
procedure sp_get_DadosMotor_( pParamsEntrada  in varchar2,
                             pStatus         out char,
                             pMessage        out varchar2,
                             pParamsSaida    out cLob
                            ) is

  --Variáveis básicas de sistemas
  vUsuario       tdvadm.t_usu_usuario.usu_usuario_codigo%type;
  vAplicacao     tdvadm.t_usu_aplicacao.usu_aplicacao_codigo%type;
  vRota          tdvadm.t_glb_rota.glb_rota_codigo%type;
  
  --Variável utilizada para recuperar a placa do veiculo.
  vPlaca_Codigo  tdvadm.t_car_veiculo.car_veiculo_placa%Type;
  
  -- Var pega a placa do carreteiro
  vPlaca_Carreta  tdvadm.t_car_veiculo.car_veiculo_carreta_placa%Type;
  
  --Variável cursor, utilizada para percorrer o SQL
  vCursor  pkg_glb_common.T_CURSOR;
  
  --Variável de controle que vai definir a linha do arquivo Xml.
  vLinhaXml integer;
  
  --Variável com a mesma estrutura do Cursor para facilitar o fetch
  vTpCursor  tDadosMotor;
  
  --Variáveis utilizadas para executar a procedure responsável por trazer o Id de validação
  vCnpjProp         tdvadm.t_car_proprietario.car_proprietario_cgccpfcodigo%Type;
  vIdValid_Codigo   tdvadm.t_con_freteoper.con_freteoper_id%Type;
  vIdValid_Rota     tdvadm.t_con_freteoper.con_freteoper_rota%Type;
  vFlagId           Char(01);
  vIdValid_Status   Varchar2(10);

  vStatus Char(01);
  vMessage  Varchar2(1000);
  
  
  
  --Variáveis XML
  vXmlDadosMotor  varchar2(30000);
  vXmlRetorno     cLob;
  
  
  
Begin
  Begin
    If pkg_glb_common.FN_getParams_Xml( lower(pParamsEntrada), 'usuario') = 'jsantos2' Then
      pMessage := pParamsEntrada;
      pStatus := 'W';
      Return;
    End If;
  Exception When Others Then 
      pMessage := sqlerrm;
      pStatus := 'E';
      Return;    
  End;
  --Inicializo as variáveis que serão utilizados nessa procedure.
  vUsuario := '';
  vAplicacao := '';
  vRota := '';
  
  vPlaca_Codigo := '';

  vCnpjProp := '';
  vIdValid_Codigo := 0;  
  vIdValid_Rota   := '';
  vIdValid_Status := '';
  vFlagId := '';
  
  vStatus  := '';
  vMessage := '';

  vLinhaXml := 0;
  vXmlDadosMotor := '';
  vXmlRetorno := empty_clob();
  
  
  --Recupero os valores que foram passados por paramentros.
  vUsuario      := pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'usuario');
  vAplicacao    := pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'aplicacao');
  vRota         := pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'rota');
  vPlaca_Codigo := Trim(upper(pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'placa_codigo')));
  vPlaca_Carreta := Trim(upper(pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'placa_carreta')));
  
  begin

    --Abro o cursor utilizando o sql gerado atraves da função fnp_sql_DadosMotor.
    open vCursor for  FN_SQL_DadosMotor( Trim(vPlaca_Codigo), Trim(vPlaca_Carreta) );
    
    --Entro em laço para percorrer o cursor.
    loop
      
      --Fetch para acessar os dados linha a linha
      fetch vCursor into vTpCursor;
      
      --Para garantir que vai sair do loop ao final do cursor.
      exit when vCursor%notfound;
      
      
      --Caso a placa não seja de um frota,
      If ( SubStr( Trim(vTpCursor.Veiculo_placa), 1, 2) != '00') Then

        -- Busco o Proprietário desse Veículo.
        -- DIEGO LIRIO
        -- ANALIZAR SE BUSCA COM A PLACA DA CARRETA TBM ??????????
        Begin
          Select 
            prop.car_proprietario_cgccpfcodigo
          Into
            vCnpjProp  
          From 
            t_car_proprietario prop,
            t_car_veiculo      veiculo
          Where
            0=0
            And prop.car_proprietario_cgccpfcodigo = veiculo.car_proprietario_cgccpfcodigo
            And veiculo.car_veiculo_placa = vTpCursor.Veiculo_placa
            And veiculo.car_veiculo_saque = ( Select max(veic.car_veiculo_saque) From t_car_veiculo veic
                                              Where veic.car_veiculo_placa = vTpCursor.Veiculo_placa
                                            );  
          
        Exception
          --Caso não encontre nnhum regisro
          When no_data_found Then
            pStatus := pkg_glb_common.Status_Erro;
            pMessage := 'Proprietario não encontrado';
            Return;
            
          --Caso ocorra algum erro na busca.
          When Others Then
            pStatus := pkg_glb_common.Status_Erro;
            pMessage := 'Erro ao tentar localizar proprietário';
            Return;  
        End;
      
      End If;
      
      
      --Executo a procedure que vai retornar um id Válido,
      Begin
        tdvadm.pkg_cfe_frete.sp_get_idValidacao( 1, 
                                                 Trim(vCnpjProp),
                                                 Trim(vTpCursor.Motorista_CPF),
                                                 Trim(vTpCursor.Motorista_Saque),
                                                 Trim(vTpCursor.Veiculo_placa),
                                                 Trim(vTpCursor.Veiculo_Saque),
                                                 vIdValid_Codigo,
                                                 vIdValid_Rota,
                                                 vFlagId,
                                                 pStatus,
                                                 pMessage
                                               ); 
        --Verifico se a procedure foi processada corretamente
        If pStatus <> pkg_glb_common.Status_Nomal Then
          --Como foi passado os paramentros de saida para a execução, simplesmente finalizo.
          Return;
        End If;
        
      Exception
        --Caso ocorra algum erro durante a execução da procedure. retorno o erro e encerro o processamento
        When Others Then
          pStatus := pkg_glb_common.Status_Erro;
          pMessage := 'Erro: ' || Sqlerrm;
          Return;
      End;   
      
      --incremento a variável de linha
      vLinhaXml := vLinhaXml +1;
      
      --Começo a montar o arquivo Xml utilizando a função FNP_XML_DADOSMOTOR
      vXmlDadosMotor := vXmlDadosMotor || FNP_XML_DadosMotor( vTpCursor, vLinhaXml, 
                                                              to_char(vIdValid_Codigo),  
                                                              vIdValid_Rota,
                                                              Trim( pkg_cfe_frete.FN_GET_IDVALIDO(vIdValid_Codigo, vIdValid_Rota) )
                                                             );
    end loop;

    --Fecho o cursor apos o loop;
    close vCursor;
    
    --Caso o cursor tenha sido aberto sem registro crio um arquivo XML em branco
    if vLinhaXml = 0 then
      vXmlDadosMotor := vXmlDadosMotor || FNP_XML_DadosMotor( vTpCursor, vLinhaXml, '', '', '');
    end if;
    
  --Monta o arquivo propriamente dito.
  vXmlRetorno := vXmlRetorno || '<Parametros><Output><status>n</status><message /><Tables>';
  vXmlretorno := vXmlRetorno || '<Table name=#dadosMotorista#><ROWSET>' || vXmlDadosMotor || '</ROWSET></Table>';
  vXmlRetorno := vXmlRetorno || '</Tables></Output></Parametros>'; 
  
  vXmlRetorno := REPLACE( vXmlRetorno, '§', '''');
  vXmlRetorno := REPLACE( vXmlRetorno, '#', '"');
  
  vXmlRetorno := replace(vXmlRetorno, 'ROWSET', 'RowSet');
  vXmlRetorno := replace(vXmlRetorno, 'Output', 'OutPut');
  
  pStatus := PKG_GLB_COMMON.Status_Nomal;
  pMessage := '';
  pParamsSaida := vXmlRetorno;
  
  exception
    when others then
      --Caso ocorra algum erro durante o processo de abertura / tratamento do cursor.      
      pStatus := pkg_glb_common.Status_Erro;
      pMessage := 'Erro ao tentar abir / Tratar cursor com dados de motorista.' || sqlerrm;
      return;
  end;  

end;

--------------------------------------------------------------------------------------------------------------------------------
-- Procedure utilizada para buscar Exceção                                                                                    -- 
--------------------------------------------------------------------------------------------------------------------------------
Procedure SP_Get_Excecao( pParamsEntrada  in varchar2,
                          pStatus         out char,
                          pMessage        out varchar2,
                          pParamsSaida    out cLob
                        ) As
 --Variáveis utilizada para recuperar valores passados por paramentros.
 vSolicitacao_codigo tdvadm.t_fcf_solveic.fcf_solveic_cod%Type;
 vTpVeiculo tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%Type;
 
 --Variável utilizada para somar os valores de particularidades.
 vValorParticular number;
 
 vLoc  Varchar2(50);
 vValor Number;
 vValorExcecao Number;
 vValorParticularidade Number;
 vDesinencia Char(03);
 
 --variável de controle
 vControl Integer;
Begin
  vControl := 0;
  vValorParticular := 0;
  vValorParticularidade := 0;
  vValorExcecao := 0;
  vValor := 0;

  
  vSolicitacao_codigo := pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'solicitacao_codigo');
  vTpVeiculo := lpad(pkg_glb_common.FN_getParams_Xml( pParamsEntrada, 'veiculo_tipo'), 2, '0');
  
  --Busco Valores de particularidade.
  for vPartCursor in ( Select 
                            part.fcf_particularidade_valor
                          from 
                            t_fcf_particularidade part,
                            t_fcf_solveicpart  solpart
                          where
                            part.fcf_particularidade_cod = solpart.fcf_particularidade_cod
                            and solpart.fcf_solveic_cod = vSolicitacao_codigo
                         )
                         loop
                           vValorParticular := vValorParticular +  vPartCursor.Fcf_Particularidade_Valor;
                           -- Thiago - 22/02/2020 - Acrescentando valor para tag nova de Particularidade
                           vValorParticularidade := vValorParticularidade +  vPartCursor.Fcf_Particularidade_Valor;
                         end loop;   

  
  For vCursor In ( SELECT LO.GLB_ESTADO_CODIGO || '-' || LO.GLB_LOCALIDADE_DESCRICAO Localidade,      
                             FE.FCF_FRETECAR_VALOR,                                          
                             FE.FCF_FRETECAR_DESINENCIA Desinencia                                    
                      FROM T_FCF_FRETECAREXC FE,                                             
                           T_GLB_LOCALIDADE LO                                               
                      WHERE (FE.FCF_FRETECAR_LOCALIDADE IN (SELECT SD.GLB_LOCALIDADE_CODIGO  
                                                           FROM T_FCF_SOLVEICDEST SD         
                                                           WHERE SD.FCF_SOLVEIC_COD = vSolicitacao_codigo)
                         OR FE.FCF_FRETECAR_LOCALIDADE IN (SELECT SO.GLB_LOCALIDADE_CODIGO
                                                           FROM T_FCF_SOLVEICORIG SO
                                                           WHERE SO.FCF_SOLVEIC_COD = vSolicitacao_codigo) )
                        AND FE.FCF_TPVEICULO_CODIGO = 1                                       
                        AND FE.FCF_TPCARGA_CODIGO = '00'

                        AND FE.FCF_FRETECAR_LOCALIDADE = LO.GLB_LOCALIDADE_CODIGO             
                        AND FE.FCF_FRETECAR_VIGENCIA = (SELECT MAX(FE1.FCF_FRETECAR_VIGENCIA) 
                                                        FROM T_FCF_FRETECAREXC FE1            
                                                        WHERE FE1.FCF_FRETECAR_LOCALIDADE = FE.FCF_FRETECAR_LOCALIDADE 
                                                          AND FE1.FCF_FRETECAR_TPFRETE = FE.FCF_FRETECAR_TPFRETE       
                                                          AND FE1.FCF_TPVEICULO_CODIGO = FE.FCF_TPVEICULO_CODIGO       
                                                          AND FE1.FCF_TPCARGA_CODIGO = FE.FCF_TPCARGA_CODIGO)          
                    )
                    Loop
                      vControl := vControl +1;
                      
                      -- Thiago - 22/02/2020 - Acrescentando valor para tag nova de Exceçao
                      vValorExcecao := vValorExcecao + vCursor.Fcf_Fretecar_Valor;
                      
                      If vControl > 1 Then
                        vValor := vValor + vCursor.Fcf_Fretecar_Valor;
                      Else
                        vValor := vcursor.fcf_fretecar_valor;
                      End If;  
                      
                      
                      vloc := pkg_glb_common.FN_LIMPA_CAMPO(vCursor.Localidade);
                      vDesinencia := vCursor.Desinencia;    
                      
                    End Loop; 
                    
                    vValor := vValor + vValorParticular;                                     


  pparamssaida := pparamssaida || '<parametros><output>';
  pparamssaida := pparamssaida || '<status>N</status><message></message>';
  pparamssaida := pparamssaida || '<tables><table name="tabexcecao"><rowset><row num="1">';
  pparamssaida := pparamssaida || '<localidade>' || vloc || '</localidade>';
  pparamssaida := pparamssaida || '<valor>' || trim(to_char(vvalor)) || '</valor>' ;
  pparamssaida := pparamssaida || '<valorparticularidade>' || trim(to_char(vValorParticularidade)) || '</valorparticularidade>' ;  
  pparamssaida := pparamssaida || '<valorexcecao>' || trim(to_char(vValorExcecao)) || '</valorexcecao>' ;  
  pparamssaida := pparamssaida || '<desinencia>' || vdesinencia || '</desinencia>';
  pparamssaida := pparamssaida || '</row></rowset></table></tables>';
  pparamssaida := pparamssaida || '</output></parametros>'; 
  pstatus := pkg_glb_common.status_nomal;
  pMessage := '';
  

End SP_Get_Excecao;                                                


end pkg_veicdisp;
/
