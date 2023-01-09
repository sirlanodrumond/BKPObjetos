create or replace procedure SP_ALTERAROWID
   as
  vContador integer := 0;
  vAuxiliar integer;
  vAchou    integer;
  vMessage  clob;
  vStatus   char(1);
  vVlrAntINI varchar2(30);
  vVlrAntFIM varchar2(30);
  vVlrAtuINI varchar2(30);
  vVlrAtuFIM varchar2(30);
  
  
  vDtFechamentoJan date := sysdate;
  vPercentual  number;
  vChave    tdvadm.t_edi_integra.edi_integra_protocolo%type;
  vOrigem   rmadm.t_glb_benasserec.glb_benasserec_origem%type;
  TYPE T_CURSOR IS REF CURSOR;
  vCursor T_CURSOR;
  vLinha1       pkg_glb_SqlCursor.tpString1024;
  vLinha2       pkg_glb_SqlCursor.tpString1024;

begin

   for c_msg in (select distinct br.glb_benasserec_chave protocolo,
                                 upper(i.edi_integra_col01) arquivo,
                                 i.edi_integra_col03 valor
                 from rmadm.t_glb_benasserec br,
                      tdvadm.t_edi_integraCSV i
                 where 0 = 0
                   and br.glb_benasserec_gravacao >= sysdate -3
                   and upper(br.glb_benasserec_fileanexo) = upper(i.edi_integra_col01(+)) 
                   and br.glb_benasserec_assunto = 'MSG=ALTERAROWID'
                   AND UPPER(BR.GLB_BENASSEREC_FILEANEXO) LIKE '%.CSV%'
--                   AND I.EDI_INTEGRA_COL02 <> 'DADOS'
                   --and i.edi_integra_protocolo = '2186559'
--                   AND i.edi_integra_col02 IN ('VERSAO')
                   AND br.glb_benasserec_status = 'OK'
                   and 0 = (select count(*)
                            from tdvadm.t_edi_integra ii
                            where ii.edi_integra_protocolo = br.glb_benasserec_chave)
                  order by 1)
  Loop
--      If c_msg.valor <> '22.6.23.0' Then
--         Update tdvadm.t_edi_integraCSV i
--           set i.edi_integra_processado = sysdate,
--               i.edi_integra_critica = 'Versao Errada Esperada ... 22.6.23.0'
--         where upper(i.edi_integra_col01) = c_msg.arquivo;       
--      Else
         insert into tdvadm.t_edi_integra
         select br.glb_benasserec_chave edi_integra_protocolo,
                rownum edi_integra_sequencia,
                'ALTERAROWID' edi_integra_cliente,
                icsv.edi_integra_col01 edi_integra_planilha,
                icsv.edi_integra_critica,
                icsv.edi_integra_processado,
                sysdate edi_integra_gravacao,
                icsv.edi_integra_col02 edi_integra_col01,
                icsv.edi_integra_col03 edi_integra_col02,
                icsv.edi_integra_col04 edi_integra_col03,
                icsv.edi_integra_col05 edi_integra_col04,
                icsv.edi_integra_col06 edi_integra_col05,
                icsv.edi_integra_col07 edi_integra_col06,
                icsv.edi_integra_col08 edi_integra_col07,
                icsv.edi_integra_col09 edi_integra_col08,
                icsv.edi_integra_col10 edi_integra_col09,
                icsv.edi_integra_col11 edi_integra_col10,
                icsv.edi_integra_col12 edi_integra_col11,
                icsv.edi_integra_col13 edi_integra_col12,
                icsv.edi_integra_col14 edi_integra_col13,
                icsv.edi_integra_col15 edi_integra_col14,
                icsv.edi_integra_col16 edi_integra_col15,
                icsv.edi_integra_col17 edi_integra_col16,
                icsv.edi_integra_col18 edi_integra_col17,
                icsv.edi_integra_col19 edi_integra_col18,
                icsv.edi_integra_col20 edi_integra_col19,
                icsv.edi_integra_col21 edi_integra_col20,
                icsv.edi_integra_col22 edi_integra_col21,
                icsv.edi_integra_col23 edi_integra_col22,
                icsv.edi_integra_col24 edi_integra_col23,
                icsv.edi_integra_col25 edi_integra_col24,
                icsv.edi_integra_col26 edi_integra_col25,
                icsv.edi_integra_col27 edi_integra_col26,
                icsv.edi_integra_col28 edi_integra_col27,
                icsv.edi_integra_col29 edi_integra_col28,
                icsv.edi_integra_col30 edi_integra_col29,
                icsv.edi_integra_col31 edi_integra_col30,
                icsv.edi_integra_col32 edi_integra_col31,
                icsv.edi_integra_col33 edi_integra_col32,
                icsv.edi_integra_col34 edi_integra_col33,
                icsv.edi_integra_col35 edi_integra_col34,
                icsv.edi_integra_col36 edi_integra_col35,
                icsv.edi_integra_col37 edi_integra_col36,
                icsv.edi_integra_col38 edi_integra_col37,
                icsv.edi_integra_col39 edi_integra_col38,
                icsv.edi_integra_col40 edi_integra_col39,
                icsv.edi_integra_col41 edi_integra_col40,
                icsv.edi_integra_col42 edi_integra_col41,
                icsv.edi_integra_col43 edi_integra_col42,
                icsv.edi_integra_col44 edi_integra_col43,
                icsv.edi_integra_col45 edi_integra_col44,
                icsv.edi_integra_col46 edi_integra_col45,
                icsv.edi_integra_col47 edi_integra_col46,
                icsv.edi_integra_col48 edi_integra_col47,
                icsv.edi_integra_col49 edi_integra_col48,
                icsv.edi_integra_col50 edi_integra_col49,
                icsv.edi_integra_col51 edi_integra_col50,
                icsv.edi_integra_col52 edi_integra_col51,
                icsv.edi_integra_col53 edi_integra_col52,
                icsv.edi_integra_col54 edi_integra_col53,
                icsv.edi_integra_col55 edi_integra_col54,
                icsv.edi_integra_col56 edi_integra_col55,
                icsv.edi_integra_col57 edi_integra_col56,
                icsv.edi_integra_col58 edi_integra_col57,
                icsv.edi_integra_col59 edi_integra_col58,
                icsv.edi_integra_col60 edi_integra_col59,
                null edi_integra_col60,
                null edi_integra_col61,
                null edi_integra_col62,
                null edi_integra_col63,
                null edi_integra_col64,
                null edi_integra_col65,
                null edi_integra_col66,
                null edi_integra_col67,
                null edi_integra_col68,
                null edi_integra_col69,
                null edi_integra_col70,
                null edi_integra_col71,
                null edi_integra_col72,
                null edi_integra_col73,
                null edi_integra_col74,
                null edi_integra_col75,
                null edi_integra_col76,
                null edi_integra_col77,
                null edi_integra_col78,
                null edi_integra_col79,
                null edi_integra_col80,
                null edi_integra_col81,
                null edi_integra_col82,
                null edi_integra_col83,
                null edi_integra_col84,
                null edi_integra_col85,
                null edi_integra_col86,
                null edi_integra_col87,
                null edi_integra_col88,
                null edi_integra_col89,
                null edi_integra_col90,
                null edi_integra_col91,
                null edi_integra_col92,
                null edi_integra_col93,
                null edi_integra_col94,
                null edi_integra_col95,
                null edi_integra_col96,
                null edi_integra_col97,
                null edi_integra_col98,
                null edi_integra_col99,
                null edi_integra_col00
         from tdvadm.t_edi_integracsv icsv,
              rmadm.t_glb_benasserec br   
         where upper(icsv.edi_integra_col01) = upper(c_msg.arquivo)
           and icsv.edi_integra_col01 = br.glb_benasserec_fileanexo;
         
--      End If;  
   End Loop;
   
  vMessage := empty_clob;
  for c_msgp in (select br.glb_benasserec_chave chave,
                        i.edi_integra_planilha Planilha,
                        br.glb_benasserec_origem origem,
                        i.edi_integra_col01 CodVerba,
                        substr(i.edi_integra_col03,2) codROWID,
                        i.edi_integra_col04 VlrAntINI,
                        i.edi_integra_col05 VlrAntFIM,
                        i.edi_integra_col06 VlrAtuINI,
                        i.edi_integra_col07 VlrAtuFIM,
                        i.rowid
                 from rmadm.t_glb_benasserec br,
                      tdvadm.t_edi_integra i
                 where 0 = 0
                  and br.glb_benasserec_gravacao >= sysdate -1
                  and upper(br.glb_benasserec_chave) = upper(i.edi_integra_protocolo(+)) 
                  and br.glb_benasserec_assunto = 'MSG=ALTERAROWID'
                  AND I.EDI_INTEGRA_PROCESSADO IS NULL
                  AND UPPER(BR.GLB_BENASSEREC_FILEANEXO) LIKE '%.CSV%'
--                  AND I.EDI_INTEGRA_COL01 = 'DADOS'
                  --and i.edi_integra_protocolo = '2186559'
--                  AND i.edi_integra_col02 NOT IN ('ACAO','ACOES')
                 ORDER BY 1,2)
  Loop

     vContador := vContador + 1;
     vChave    := c_msgp.chave;
     vOrigem   := c_msgp.origem;
     
     vVlrAntINI := replace(c_msgp.vlrantini,'R','');
     vVlrAntINI := replace(vVlrAntINI,'$','');
     vVlrAntINI := replace(vVlrAntINI,'.','');
     vVlrAntINI := replace(vVlrAntINI,',','.');
     vVlrAntINI := replace(vVlrAntINI,'-','');
     vVlrAntINI := nvl(trim(vVlrAntINI),'0');

     vVlrAntFIM := replace(c_msgp.vlrantfim,'R','');
     vVlrAntFIM := replace(vVlrAntFIM,'$','');
     vVlrAntFIM := replace(vVlrAntFIM,'.','');
     vVlrAntFIM := replace(vVlrAntFIM,',','.');
     vVlrAntFIM := replace(vVlrAntFIM,'-','');
     vVlrAntFIM := nvl(trim(vVlrAntFIM),'0');

     vVlrAtuINI := replace(c_msgp.vlrantfim,'R','');
     vVlrAtuINI := replace(vVlrAtuINI,'$','');
     vVlrAtuINI := replace(vVlrAtuINI,'.','');
     vVlrAtuINI := replace(vVlrAtuINI,',','.');
     vVlrAtuINI := replace(vVlrAtuINI,'-','');
     vVlrAtuINI := nvl(trim(vVlrAtuINI),'0');

     vVlrAtuFIM := replace(c_msgp.vlrantfim,'R','');
     vVlrAtuFIM := replace(vVlrAtuFIM,'$','');
     vVlrAtuFIM := replace(vVlrAtuFIM,'.','');
     vVlrAtuFIM := replace(vVlrAtuFIM,',','.');
     vVlrAtuFIM := replace(vVlrAtuFIM,'-','');
     vVlrAtuFIM := nvl(trim(vVlrAtuFIM),'0');

     
     
     
     vMessage := empty_clob;
     vStatus := 'N';
     If c_msgp.CodVerba = 'Sirlano' Then
        vChave := vChave;
     ElsIf c_msgp.CodVerba in ('D_FRPSVO',
                               'D_PD',
                               'D_ADVL') Then
        Begin
           Update tdvadm.t_slf_calcfretekm km
             set km.slf_calcfretekm_valor = c_msgp.vlratuini
           Where km.rowid = c_msgp.codrowid
             and km.slf_calcfretekm_valor = c_msgp.vlrantini;

           If sql%rowcount = 0 Then
              vStatus := 'N';
              vMessage := vMessage ||  'Registro nao Atualizado </br>' || chr(10);
           Else   
              vStatus := 'N';
              vMessage := null;
           End If;
        exception
        When OTHERS Then
           Begin
              update tdvadm.t_slf_clienteped p
                set.slf_clienteped_valor = vVlvVlrAtuINI;
           Exception
              When OTHERS Then
 

                 vStatus := 'E';
                 
              end;
           vStatus := 'E';
           vMessage := vMessage ||  'Erro Reajustando </br>' || ' erro : ' || sqlerrm || '</br>'  || chr(10);
        End;
                           
    
     End If;
     
     dbms_output.put_line('Registros Procesados ' || vContador);
   
     update tdvadm.t_edi_integra i
       set i.edi_integra_processado = sysdate,
           i.edi_integra_critica = substr(trim(vMessage),1,2000)
     where i.rowid = c_msgp.rowid;
     vAuxiliar := sql%rowcount;
     commit;   
  End Loop; 
  
  
         pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
       pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
       
       open vCursor for select br.glb_benasserec_chave chave,
                        i.edi_integra_col01 Verba,
--                        i.edi_integra_col03 ,
                        i.edi_integra_col03 ValorAntINI,
                        i.edi_integra_col04 ValorAntFIM,
                        i.edi_integra_col05 ValorAtuINI,
                        i.edi_integra_col06 ValorAtuFIM,
                        i.edi_integra_critica Critica
                 from rmadm.t_glb_benasserec br,
                      tdvadm.t_edi_integra i
                 where 0 = 0
                  and br.glb_benasserec_gravacao >= sysdate -3
                  and br.glb_benasserec_chave = i.edi_integra_protocolo(+)
                  and  br.glb_benasserec_chave = vChave
                  and i.edi_integra_critica is not null
--                 == AND I.EDI_INTEGRA_COL01 = 'DADOS'
--                  AND i.edi_integra_col02 NOT IN ('ACOES')
                 ORDER BY I.EDI_INTEGRA_PROTOCOLO,I.EDI_INTEGRA_SEQUENCIA;
       
       If vCursor%rowcount > 0 Then
          pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha2);
          for i in 1 .. vLinha2.count loop
             if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                vMessage := vMessage || vLinha2(i);
             Else
                vMessage := vMessage || vLinha2(i) || '</br>' || chr(10);
             End if;
          End loop; 


       
          --envio o e-mail com os dados recuperados.
          wservice.pkg_glb_email.SP_ENVIAEMAIL('ALTERA ROWID',
                                                vMessage,
                                                'aut-e@dellavolpe.com.br',
                                                vOrigem || ';sirlano.drumond@dellavolpe.com.br'
                                               );
      End If; 
end SP_ALTERAROWID;
/
