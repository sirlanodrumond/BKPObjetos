create or replace procedure SP_ALTERASITUNOTA
   as
  vContador integer := 0;
  vAuxiliar integer;
  vMessage  clob;
  vStatus   char(1);
  vDtFechamentoJan date := sysdate;
  vChave    tdvadm.t_edi_integra.edi_integra_protocolo%type;
  vOrigem   rmadm.t_glb_benasserec.glb_benasserec_origem%type;
  TYPE T_CURSOR IS REF CURSOR;
  vCursor T_CURSOR;
  vLinha1       pkg_glb_SqlCursor.tpString1024;
  vLinha2       pkg_glb_SqlCursor.tpString1024;

begin
  
-- Esta PROCEDURE e para rodar somente no TDH
--  return;
   
  vMessage := empty_clob;
  for c_msgp in (select br.glb_benasserec_chave chave,
                        i.edi_integra_planilha Planilha,
                        br.glb_benasserec_origem origem,
                        i.edi_integra_col02 Acao,
                        i.edi_integra_col03 Nota,
                        i.edi_integra_col04 CNPJ,
                        i.edi_integra_col05 COLETA,
                        i.edi_integra_col06 CICLO,
                        i.edi_integra_col07 ASN,
                        i.edi_integra_col08 contrato,
                        i.edi_integra_col09 vigencia,
                        nvl(i.edi_integra_col10,0) percentual,
                        i.rowid
                 from rmadm.t_glb_benasserec br,
                      tdvadm.t_edi_integra i
                 where 0 = 0
                  and br.glb_benasserec_gravacao >= sysdate -3
                  and br.glb_benasserec_chave = i.edi_integra_protocolo(+) 
                  --and br.glb_benasserec_assunto = 'MSG=ALTERASITUNOTA'
                  AND UPPER(BR.GLB_BENASSEREC_FILEANEXO) LIKE '%.XLS%'
                  AND I.EDI_INTEGRA_COL01 = 'DADOS'
                  and i.edi_integra_protocolo = '2186559'
                  AND i.edi_integra_col02 NOT IN ('ACAO','ACOES')
--                  AND I.EDI_INTEGRA_PROCESSADO IS NULL
                 ORDER BY I.EDI_INTEGRA_PROTOCOLO,I.EDI_INTEGRA_SEQUENCIA)
  Loop

     vContador := vContador + 1;
     vChave    := c_msgp.chave;
     vOrigem   := c_msgp.origem;
     vMessage := empty_clob;
     vStatus := 'N';
  If c_msgp.acao = 'Sirlano' Then
     vChave := vChave;
  ElsIf c_msgp.acao in ('MUDAVIGENCIA') Then
     vContador := 0;
     -- Atualizando as Tabelas
     for c_msg in (select ta.slf_tabela_codigo,
                          ta.slf_tabela_saque,
                          ta.slf_tabela_vigencia
                   from tdvadm.t_slf_tabela ta
                   where ta.slf_tabela_contrato = c_msgp.contrato 
                     and nvl(ta.slf_tabela_status,'N') = 'N'
                     and ta.slf_tabela_saque = (select max(ta1.slf_tabela_saque)
                                                from tdvadm.t_slf_tabela ta1
                                                where ta1.slf_tabela_codigo = ta.slf_tabela_codigo
                                                  and nvl(ta1.slf_tabela_status,'N') = 'N'))
     Loop 
        vContador := 1;
        If c_msgp.vigencia is null Then
           vStatus := 'E';
           vMessage := vMessage ||  'Data nao pode ser nula ' || chr(10);
        ElsIf length(trim(c_msgp.vigencia)) < 10 Then
           vStatus := 'E';
           vMessage := vMessage ||  'Formato invalido da Data ' || chr(10);
        ElsIf to_date(substr(c_msgp.vigencia,1,10),'DD/MM/YYYY') < trunc(sysdate) Then
           vStatus := 'E';
           vMessage := vMessage ||  'Maior Vigencia menor que ' || to_char(sysdate,'DD/MM/YYYY') || chr(10);
        ElsIf trunc(c_msg.slf_tabela_vigencia) = trunc(sysdate) Then
           vStatus := 'E';
           vMessage := vMessage ||  'Maior Vigencia menor que ' || to_char(sysdate,'DD/MM/YYYY') || chr(10);
        ElsIf trunc(c_msg.slf_tabela_vigencia) > trunc(sysdate) Then
           update tdvadm.t_slf_tabela ta
             set ta.slf_tabela_vigencia = c_msgp.vigencia
           where ta.slf_tabela_codigo = c_msg.slf_tabela_codigo
             and ta.slf_tabela_saque = c_msg.slf_tabela_saque;
           vContador := sql%rowcount;
           vStatus := 'N';
           vMessage := vMessage || 'TAB - ' || c_msg.slf_tabela_codigo || '-' || c_msg.slf_tabela_saque || ' - Atualizada ' || chr(10);
        End If;
     End loop;
     If vContador = 0 Then
        vStatus := 'E';
        vMessage := vMessage || 'TAB nao localizada para CONTRATO ' || c_msgp.contrato  || chr(10);
     End If;
     -- Atualizando os Pedagios
     -- Fazer
  ElsIf c_msgp.acao in ('INICI ALIZA') Then
        -- Inicializa Nota
        for c_msg in (select distinct 
                                      an.arm_nota_numero,
                                      an.glb_cliente_cgccpfremetente,
                                      an.glb_embalagem_codigo,
                                      an.arm_nota_sequencia,
                                      an.arm_janelacons_sequencia
                      from tdvadm.t_arm_nota@database_tdx an
                      where an.arm_nota_numero = c_msgp.nota
                        and an.glb_cliente_cgccpfremetente = c_msgp.cnpj
                    )
         Loop
            update tdvadm.t_arm_nota@database_tdx an
              set an.arm_movimento_datanfentrada = trunc(sysdate),
                  an.arm_nota_dtrecebimento      = trunc(sysdate),
                  an.arm_nota_dtinclusao         = trunc(sysdate),
                  an.arm_nota_dtetiqueta         = null,
                  an.arm_janelacons_sequencia    = null
            where an.arm_nota_sequencia = c_msg.arm_nota_sequencia;
           vAuxiliar := sql%rowcount;
           vStatus := 'N';
           vMessage :='Inicializada com Sucesso ';
         End Loop;
         commit;
  ElsIf c_msgp.acao in ('FECHAJANELA') Then
        -- Fecha Janela
        for c_msg in (select distinct 
      --                                an.arm_nota_numero,
      --                                an.glb_cliente_cgccpfremetente,
      --                                an.glb_embalagem_codigo,
      --                                an.arm_nota_sequencia,
                                      an.arm_janelacons_sequencia
                      from tdvadm.t_arm_nota@database_tdx an
                      where an.arm_nota_numero = c_msgp.nota
                        and an.glb_cliente_cgccpfremetente = c_msgp.cnpj
                     )
         Loop
           update tdvadm.t_arm_janelacons@database_tdx j
             set j.arm_janelacons_dtfim =  vDtFechamentoJan
           where j.arm_janelacons_sequencia = c_msg.arm_janelacons_sequencia;
           vAuxiliar := sql%rowcount;
           vStatus := 'N';
           vMessage := 'Fechada Sem erro horario ' || vDtFechamentoJan;
         End Loop
         commit;
   
  ElsIf c_msgp.acao in ('EXCLUINOTA') Then
        -- Fecha Janela
        for c_msg in (select distinct 
                             an.arm_nota_numero,
                             an.glb_cliente_cgccpfremetente,
                             an.glb_embalagem_codigo,
                             an.arm_nota_sequencia,
                             an.arm_janelacons_sequencia
                      from tdvadm.t_arm_nota@database_tdx an
                      where an.arm_nota_numero = c_msgp.nota
                        and an.glb_cliente_cgccpfremetente = c_msgp.cnpj
                     )
         Loop
            vMessage := null;
            vStatus  := 'N';
            pkg_hd_utilitario.SP_EXCLUI_NOTA_NOVO@database_tdx(pNOTA      => c_msg.arm_nota_numero,
                                                               pCNPJ      => c_msg.glb_cliente_cgccpfremetente,
                                                               pTipo      => 'TODOS',
                                                               pSEQUENCIA => c_msg.arm_nota_sequencia,
                                                               pMessage   => vMessage,
                                                               pStatus    => vStatus);

           vAuxiliar := sql%rowcount;
           vStatus := 'N';
           vMessage := 'Excluida com Sucesso ';
         End Loop
         commit;
   
  End If;

  dbms_output.put_line('Registros Procesados ' || vContador);
   
   update tdvadm.t_edi_integra i
     set i.edi_integra_processado = sysdate,
         i.edi_integra_critica = substr(vStatus || '-' || vMessage,1,2000)
   where i.rowid = c_msgp.rowid;
   vAuxiliar := sql%rowcount;
   commit;   
  End Loop; 
  
  
         pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
       pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
       
       open vCursor for select br.glb_benasserec_chave chave,
                        i.edi_integra_col02 Acao,
                        i.edi_integra_col03 Nota,
                        i.edi_integra_col04 CNPJ,
                        i.edi_integra_col05 COLETA,
                        i.edi_integra_col06 CICLO,
                        i.edi_integra_col07 ASN,
                        i.edi_integra_col08 contrato,
                        i.edi_integra_col09 vigencia,
                        nvl(i.edi_integra_col10,0) percentual,
                        i.edi_integra_critica Critica
                 from rmadm.t_glb_benasserec br,
                      tdvadm.t_edi_integra i
                 where 0 = 0
                  and br.glb_benasserec_gravacao >= sysdate -3
                  and br.glb_benasserec_chave = i.edi_integra_protocolo(+)
                  and  br.glb_benasserec_chave = vChave
                  AND I.EDI_INTEGRA_COL01 = 'DADOS'
                  AND i.edi_integra_col02 NOT IN ('ACOES')
                 ORDER BY I.EDI_INTEGRA_PROTOCOLO,I.EDI_INTEGRA_SEQUENCIA;
       
       pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha2);
       for i in 1 .. vLinha2.count loop
          if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
             vMessage := vMessage || vLinha2(i);
          Else
             vMessage := vMessage || vLinha2(i) || chr(10);
          End if;
       End loop; 


       
       --envio o e-mail com os dados recuperados.
       wservice.pkg_glb_email.SP_ENVIAEMAIL('USUARIOS',
                                             vMessage,
                                             'aut-e@dellavolpe.com.br',
                                             'sirlanodrumond@gmail.com'
                                           --  vOrigem || ';sirlano.drumond@dellavolpe.com.br'
                                             );

end SP_ALTERASITUNOTA;
/
