CREATE OR REPLACE PACKAGE PKG_SCH_PROCEDURES IS
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
   
Procedure sp_ARM_NOTASARMAZENS ;
Procedure sp_arm_ReajustaTabela ;
Procedure sp_cad_frete;

/*
BEGIN
   BLOCO DE INSTRUCOES
EXCEPTION
  WHEN DUP_VAL_ON_INDEX  THEN       -- ORA-00001   You attempted to create a duplicate value in a field restricted by a unique index.
  WHEN TIMEOUT_ON_RESOURCE  THEN    -- ORA-00051 	A resource timed out, took too long.
  WHEN TRANSACTION_BACKED_OUT  THEN -- ORA-00061 	The remote portion of a transaction has rolled back.
  WHEN INVALID_CURSOR  THEN         -- ORA-01001 	The cursor does not yet exist. The cursor must be OPENed before any FETCH cursor or CLOSE cursor operation.
  WHEN NOT_LOGGED_ON  THEN          -- ORA-01012 	You are not logged on.
  WHEN LOGIN_DENIED  THEN           -- ORA-01017 	Invalid username/password.
  WHEN NO_DATA_FOUND  THEN          -- ORA-01403 	No data was returned
  WHEN TOO_MANY_ROWS  THEN          -- ORA-01422 	You tried to execute a SELECT INTO statement and more than one row was returned.
  WHEN ZERO_DIVIDE  THEN            -- ORA-01476 	Divide by zero error.
  WHEN INVALID_NUMBER  THEN         -- ORA-01722 	Converting a string to a number was unsuccessful.
  WHEN STORAGE_ERROR  THEN          -- ORA-06500 	Out of memory.
  WHEN PROGRAM_ERROR  THEN          -- ORA-06501 	
  WHEN VALUE_ERROR  THEN            -- ORA-06502 	You tried to perform an operation and there was a error on a conversion, truncation, or invalid constraining of numeric or character data.
  WHEN ROWTYPE_MISMATCH  THEN       -- ORA-06504 	 
  WHEN CURSOR_ALREADY_OPEN  THEN    -- ORA-06511 	The cursor is already open.
  WHEN ACCESS_INTO_NULL  THEN       -- ORA-06530 	 
  WHEN COLLECTION_IS_NULL  THEN     -- ORA-06531    
  WHEN OTHERS THEN
END;

*/

                                    

END PKG_SCH_PROCEDURES;

 
/
CREATE OR REPLACE PACKAGE BODY PKG_SCH_PROCEDURES AS


procedure sp_ARM_NOTASARMAZENS
As
   hora date := sysdate;
   vHora char(2);
   cMsg varchar2(1000);
   tpNotasArmazem TDVADM.V_ARM_NOTASARMAZENS_ONLINE%Rowtype;
   vAuxiliar integer := 0;
begin
   Begin

      cMsg := 'Inicio - ' || to_char(hora,'DD/MM/YYYY HH24:MI:SS') || CHR(10);
--      If trunc(sysdate) = '19/02/2021' Then
--         delete tdvadm.v_arm_notasarmazens;
--         commit;
--      End If;   
      vHora := to_char(sysdate,'HH24');
      delete tdvadm.v_arm_notasarmazens x;
--      commit;  
/*
      if to_number(to_char(sysdate,'HH24MMSS')) between 220000 and 235900 Then 
         delete tdvadm.v_arm_notasarmazens x;
      Else 
         delete tdvadm.v_arm_notasarmazens x 
        where ((x.coleta,
                x.ciclo) in (select h.arm_coleta_ncompra,
                                    h.arm_coleta_ciclo 
                             from tdvadm.t_arm_coletahist h 
                             where h.arm_coleta_dtgravacao >= (sysdate - (1/12))) )
          or ((x.ctrc,
               x.ctrc_serie,
               x.rota) in (select vfc.con_conhecimento_codigo,
                                  vfc.con_conhecimento_serie,
                                  vfc.glb_rota_codigo
                           from tdvadm.t_con_vfreteconhec vfc
                           where (vfc.con_valefrete_codigo,
                                  vfc.con_valefrete_serie,
                                  vfc.glb_rota_codigovalefrete,
                                  vfc.con_valefrete_saque) in (select vfh.con_conhecimento_codigo,
                                                                      vfh.con_conhecimento_serie,
                                                                      vfh.glb_rota_codigo,
                                                                      vfh.con_valefrete_saque
                                                               from tdvadm.t_con_valefretehist vfh
                                                               where vfh.arm_valefretehist_gravacao >= (sysdate - (1/12)) ) )  );
        delete tdvadm.v_arm_notasarmazens x 
        where 0 = 0
--  and x.nota = 18844
          and ( 0 < (select count(*)
                     from tdvadm.t_arm_nota an,
                           tdvadm.t_con_vfreteconhec vfc
                      where an.con_conhecimento_codigo = vfc.con_conhecimento_codigo
                        and an.con_conhecimento_serie = vfc.con_conhecimento_serie
                        and an.glb_rota_codigo = vfc.glb_rota_codigo
                        and an.arm_nota_sequencia = x.nota_sequencia) )
                  or 
                    ( nvl(x.ctrc,'XXXXXX') <> (select an.con_conhecimento_codigo
                                               from tdvadm.t_arm_nota an
                                               where an.arm_nota_sequencia = x.nota_sequencia) );


      End If;
*/
      for c_msg in (SELECT * FROM TDVADM.V_ARM_NOTASARMAZENS_ONLINE_OLD x )
      Loop
        vAuxiliar := vAuxiliar + 1;
        tpNotasArmazem.NOTA:=c_msg.NOTA; 
        tpNotasArmazem.MERCADORIA:=c_msg.MERCADORIA; 
        tpNotasArmazem.DATA_INCLUSAO:=c_msg.DATA_INCLUSAO; 
        tpNotasArmazem.NOTA_PESO:=c_msg.NOTA_PESO; 
        tpNotasArmazem.NOTA_VALOR:=c_msg.NOTA_VALOR; 
        tpNotasArmazem.NOTA_SEQUENCIA:=c_msg.NOTA_SEQUENCIA; 
        tpNotasArmazem.CFOP:=c_msg.CFOP; 
        tpNotasArmazem.CTRC:=c_msg.CTRC; 
        tpNotasArmazem.CTRC_SERIE:=c_msg.CTRC_SERIE; 
        tpNotasArmazem.VOLUME:=c_msg.VOLUME; 
        tpNotasArmazem.ROTA:=c_msg.ROTA; 
        tpNotasArmazem.CTRC_SERIE_ROTA:=c_msg.CTRC_SERIE_ROTA; 
        tpNotasArmazem.DIGITALIZOU:=c_msg.DIGITALIZOU; 
        tpNotasArmazem.REMETENTE_CNPJ:=c_msg.REMETENTE_CNPJ; 
        tpNotasArmazem.REMETENTE_RAZAO:=c_msg.REMETENTE_RAZAO; 
        tpNotasArmazem.DESTINATARIO_CNPJ:=c_msg.DESTINATARIO_CNPJ; 
        tpNotasArmazem.DESTINATARIO_RAZAO:=c_msg.DESTINATARIO_RAZAO; 
        tpNotasArmazem.DESTINATARIO_GRUPO_NOME:=c_msg.DESTINATARIO_GRUPO_NOME; 
        tpNotasArmazem.CIDADE_DESTINO:=c_msg.CIDADE_DESTINO; 
        tpNotasArmazem.ALMOX:=c_msg.ALMOX; 
        tpNotasArmazem.UF:=c_msg.UF; 
        tpNotasArmazem.ARMAZEM_ORIGEM:=c_msg.ARMAZEM_ORIGEM; 
        tpNotasArmazem.ARMAZEM_ATUAL:=c_msg.ARMAZEM_ATUAL; 
        tpNotasArmazem.COLETA:=c_msg.COLETA; 
        tpNotasArmazem.coletaocor:=c_msg.coletaocor; 
        tpNotasArmazem.PRIORIDADE:=c_msg.PRIORIDADE; 
        tpNotasArmazem.PRIORIDADE_DESCRICAO:=c_msg.PRIORIDADE_DESCRICAO; 
        tpNotasArmazem.prevagend:=c_msg.prevagend; 
        tpNotasArmazem.embarcar:=c_msg.embarcar; 
        tpNotasArmazem.status:=c_msg.status; 
        tpNotasArmazem.km:=c_msg.km; 
        tpNotasArmazem.preventrega:=c_msg.preventrega; 
        tpNotasArmazem.ENTREGACTE:=c_msg.ENTREGACTE; 
        tpNotasArmazem.COLETA_OCORRENCIA:=c_msg.COLETA_OCORRENCIA; 
        tpNotasArmazem.BAIXA_OCORRENCIA:=c_msg.BAIXA_OCORRENCIA; 
        tpNotasArmazem.chave:=c_msg.chave; 
        tpNotasArmazem.onu:=c_msg.onu; 
        tpNotasArmazem.FATCOD:=c_msg.FATCOD; 
        tpNotasArmazem.FATRT:=c_msg.FATRT; 
        tpNotasArmazem.UF_ORIGEM:=c_msg.UF_ORIGEM; 
        tpNotasArmazem.CIDADE_ORIGEM:=c_msg.CIDADE_ORIGEM; 
        tpNotasArmazem.TRANSFERENCIA:=c_msg.TRANSFERENCIA; 
        tpNotasArmazem.PEDIDO_NOTA:=c_msg.PEDIDO_NOTA; 
        tpNotasArmazem.FLAG_PRIORIZADA:=c_msg.FLAG_PRIORIZADA; 
        tpNotasArmazem.DESTINATARIO_GRUPO:=c_msg.DESTINATARIO_GRUPO; 
        tpNotasArmazem.ciclo:=c_msg.ciclo;
        begin 
           insert into tdvadm.v_arm_notasarmazens values tpNotasArmazem;
        exception When OTHERS Then 
           hora := hora;
           dbms_output.put_line('Erro Loop linha Processada '  || vAuxiliar || chr(10) || 'erro : ' || sqlerrm );
        End;
        If mod(vAuxiliar,1000) = 0 Then
           dbms_output.put_line('linha Processada '  || vAuxiliar || chr(10) || 'erro : ' || sqlerrm );
--           commit;
        End If;
--        commit;
      End Loop;
      commit;
 Exception
 When OTHERS Then
 rollback; 
 dbms_output.put_line('Erro 1 Exception linha Processada '  || vAuxiliar || chr(10) || 'erro : ' || sqlerrm );
 hora := sysdate;
 cMsg := cMsg || 'Final - ' || to_char(hora,'DD/MM/YYYY HH24:MI:SS') || CHR(10) || 'erro : ' || sqlerrm || chr(10);
 wservice.pkg_glb_email.SP_ENVIAEMAIL('ATUALIZACAO NOTAS ARMAZEM 1',cMsg,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
 End;
Exception
 When OTHERS Then
 rollback; hora := sysdate;
 dbms_output.put_line('Erro 2 Exceptionlinha Processada '  || vAuxiliar || chr(10) || 'erro : ' || sqlerrm );
 cMsg := cMsg || 'Primiro Begin - ' || chr(10) || 'Final - ' || to_char(hora,'DD/MM/YYYY HH24:MI:SS') || CHR(10) || 'erro : ' || sqlerrm || chr(10);
 wservice.pkg_glb_email.SP_ENVIAEMAIL('ATUALIZACAO NOTAS ARMAZEM 2',cMsg,'aut-e@dellavolpe.com.br','sirlano.drumond@dellavolpe.com.br');
End;

Procedure sp_arm_ReajustaTabela 
  As
     vLinha integer := 0;
  Begin
     update tdvadm.t_usu_perfil p
       set p.usu_perfil_parat = 'S'
     where 0 = 0
       and p.USU_PERFIL_CODIGO IN ('ACESSOABACTRC','ACESSOABACARREG');
     commit;

      
  exception
     When OTHERS Then
       dbms_output.put_line('Erro - Linha ' || vLinha || chr(10) || sqlerrm); 
   
  End;


Procedure sp_cad_frete
  As
  i integer;
  tpFretecar   tdvadm.t_fcf_fretecar%rowtype;
  vMessage     tdvadm.t_edi_integra.edi_integra_critica%type;
  vInsere      char(1) := 'N';
  vHistorico   char(1) := 'N';
  pCorpoEmail  rmadm.t_glb_benasserec.glb_benasserec_corpo%type;
  vCursor      PKG_EDI_PLANILHA.T_CURSOR;
  vLinha       pkg_glb_SqlCursor.tpString1024;
  vVigencia    tdvadm.t_fcf_fretecar.fcf_fretecar_vigencia%type;       
begin
  pCorpoEmail := Empty_clob;
  
  for c_msg in (select *
                from rmadm.t_glb_benasserec br
                where br.glb_benasserec_assunto = 'MSG=CADFRETE'
                  and br.glb_benasserec_status = 'OK'
                  and 0 < (select count(*)
                           from tdvadm.t_edi_integra i
                           where i.edi_integra_protocolo = br.glb_benasserec_chave
                             and i.edi_integra_col01 is not null 
                             and i.edi_integra_processado is null)
       )
     Loop     
  
        For c_msg1 in (select p.fcf_fretecar_origem,
                              p.fcf_fretecar_destino,
                              p.fcf_fretecar_tpfrete,
                              p.fcf_tpveiculo_codigo,
                              p.fcf_tpcarga_codigo,
                              p.fcf_fretecar_valor,
                              p.fcf_fretecar_desinencia,
                              p.fcf_fretecar_vigencia,
                              p.usu_usuario_cadastro,
                              p.usu_usuario_alterou,
                              p.fcf_fretecar_dtcadastro,
                              p.fcf_fretecar_dtalteracao,
                              p.fcf_fretecar_pedagio,
                              p.fcf_fretecar_altpedagio,
                              p.usu_usuario_codigo,
                              p.fcf_fretecar_km,
                              trim(tdvadm.fn_busca_codigoibge(p.fcf_fretecar_origem,'IBC')) fcf_fretecar_origemi,
                              trim(tdvadm.fn_busca_codigoibge(p.fcf_fretecar_destino,'IBC')) fcf_fretecar_destinoi,
                              p.fcf_fretecar_rowid,
                              p.fcf_fretecar_pednofrete,
                              p.FCF_FRETECAR_ALTKM,
                              p.fcf_fretecar_passandopor,
                              trim(tdvadm.fn_busca_codigoibge(p.fcf_fretecar_passandopor,'IBC')) fcf_fretecar_passandopori,
                              p.descorigem,
                              p.descdestino,
                              p.passandopor,
                              p.descveiculo,
                              p.integra_rowid
                        from tdvadm.v_fcf_fretecar_protocolo p
                       where p.protocolo = c_msg.glb_benasserec_chave)
        Loop
            
           vInsere     := 'S';
           vHistorico  := 'N';
           
           tpFretecar.Fcf_Fretecar_Origem       := c_msg1.Fcf_Fretecar_Origem;     
           tpFretecar.Fcf_Fretecar_Destino      := c_msg1.Fcf_Fretecar_Destino;     
           tpFretecar.Fcf_Fretecar_Tpfrete      := 'LO';     
           tpFretecar.Fcf_Tpveiculo_Codigo      := c_msg1.Fcf_Tpveiculo_Codigo;     
           tpFretecar.Fcf_Tpcarga_Codigo        := '00';       
           tpFretecar.Fcf_Fretecar_Valor        := c_msg1.Fcf_Fretecar_Valor;       
           tpFretecar.Fcf_Fretecar_Desinencia   := c_msg1.Fcf_Fretecar_Desinencia;  
           tpFretecar.Fcf_Fretecar_Vigencia     := c_msg1.Fcf_Fretecar_Vigencia;    
           tpFretecar.Usu_Usuario_Cadastro      := c_msg1.Usu_Usuario_Cadastro;     
           tpFretecar.Usu_Usuario_Alterou       := c_msg1.Usu_Usuario_Alterou;      
           tpFretecar.Fcf_Fretecar_Dtcadastro   := c_msg1.Fcf_Fretecar_Dtcadastro;  
           tpFretecar.Fcf_Fretecar_Dtalteracao  := c_msg1.Fcf_Fretecar_Dtalteracao; 
           tpFretecar.Fcf_Fretecar_Pedagio      := c_msg1.Fcf_Fretecar_Pedagio;     
           tpFretecar.Fcf_Fretecar_Altpedagio   := c_msg1.Fcf_Fretecar_Altpedagio;  
           tpFretecar.Usu_Usuario_Codigo        := c_msg1.Usu_Usuario_Codigo;       
           tpFretecar.Fcf_Fretecar_Km           := c_msg1.Fcf_Fretecar_Km;          
           tpFretecar.Fcf_Fretecar_Origemi      := c_msg1.Fcf_Fretecar_Origemi;     
           tpFretecar.Fcf_Fretecar_Destinoi     := c_msg1.Fcf_Fretecar_Destinoi;    
           tpFretecar.Fcf_Fretecar_Rowid        := c_msg1.Fcf_Fretecar_Rowid;       
           tpFretecar.Fcf_Fretecar_Pednofrete   := c_msg1.Fcf_Fretecar_Pednofrete;  
           tpFretecar.Fcf_Fretecar_Altkm        := c_msg1.Fcf_Fretecar_Altkm;       
           tpFretecar.Fcf_Fretecar_Passandopor  := c_msg1.Fcf_Fretecar_Passandopor; 
           tpFretecar.Fcf_Fretecar_Passandopori := c_msg1.Fcf_Fretecar_Passandopori;

           If tpFretecar.fcf_fretecar_vigencia > trunc(sysdate) Then
              vMessage :=  vMessage || 'Vigencia FUTURA ' || to_char(tpFretecar.fcf_fretecar_vigencia,'DD/MM/YYYY') || chr(10);
           End If;
           
           If c_msg1.descveiculo is null Then
              vMessage := vMessage || 'Verifique Codugo do Veiculo ' || c_msg1.fcf_tpveiculo_codigo || chr(10);
              vInsere := 'N';
           End If;

           Begin
              select fc.fcf_fretecar_vigencia
                into vVigencia
              from tdvadm.t_fcf_fretecar fc
              where fc.FCF_FRETECAR_ORIGEM      = tpFretecar.FCF_FRETECAR_ORIGEM       
                and fc.FCF_FRETECAR_DESTINO     = tpFretecar.FCF_FRETECAR_DESTINO     
                and fc.FCF_FRETECAR_PASSANDOPOR = tpFretecar.FCF_FRETECAR_PASSANDOPOR 
                and fc.FCF_FRETECAR_TPFRETE     = tpFretecar.FCF_FRETECAR_TPFRETE     
                and fc.FCF_TPVEICULO_CODIGO     = tpFretecar.FCF_TPVEICULO_CODIGO     
                and fc.FCF_TPCARGA_CODIGO       = tpFretecar.FCF_TPCARGA_CODIGO;
           Exception
             When NO_DATA_FOUND Then
                 vVigencia := to_date('01/01/1900','dd/mm/yyyy');
             End;
           
           If vVigencia = to_date('01/01/1900','dd/mm/yyyy') Then
             vMessage := vMessage || 'Frete Cadastrado';
             vInsere := 'S';
           ElsIf vVigencia = tpFretecar.Fcf_Fretecar_Vigencia Then
             vMessage := vMessage || 'Registro ja existe, GERE UMA NOVA VIGENCIA';
             vInsere := 'N';
           ElsIf vVigencia > tpFretecar.Fcf_Fretecar_Vigencia Then
             vMessage := vMessage || 'Existe Vigencia maior que ' || to_char(vVigencia,'DD/MM/YYYY') || ', GERE UMA NOVA VIGENCIA';
             vInsere := 'N';
           ElsIf vVigencia < tpFretecar.Fcf_Fretecar_Vigencia Then
             vMessage := vMessage || 'Frete alterado';
             vHistorico := 'S';
             vInsere := 'S';
           End If;    
           
        
           update tdvadm.t_edi_integra i
             set i.edi_integra_processado = sysdate,
                 i.edi_integra_critica = vMessage
           where i.rowid = c_msg1.integra_rowid
             and i.edi_integra_protocolo = c_msg.glb_benasserec_chave
             and i.edi_integra_col01 is not null;

           vMessage := null; 
           
           If vHistorico = 'S' Then
              delete tdvadm.t_fcf_fretecar fc
              where fc.FCF_FRETECAR_ORIGEM      = tpFretecar.FCF_FRETECAR_ORIGEM       
                and fc.FCF_FRETECAR_DESTINO     = tpFretecar.FCF_FRETECAR_DESTINO     
                and fc.FCF_FRETECAR_PASSANDOPOR = tpFretecar.FCF_FRETECAR_PASSANDOPOR 
                and fc.FCF_FRETECAR_TPFRETE     = tpFretecar.FCF_FRETECAR_TPFRETE     
                and fc.FCF_TPVEICULO_CODIGO     = tpFretecar.FCF_TPVEICULO_CODIGO     
                and fc.FCF_TPCARGA_CODIGO       = tpFretecar.FCF_TPCARGA_CODIGO;
           End If;

           If vInsere = 'S' Then
              insert into tdvadm.t_fcf_fretecar
              values  tpFretecar;
           End If;
        End Loop;

             /******************************************************/
             /**     LOOP PARA MONTAR O E-MAIL DE RETORNO         **/
             /******************************************************/
             begin
               
               open vCursor FOR SELECT p.fcf_fretecar_vigencia Vigencia,
                                       p.descorigem origem,
                                       p.descdestino destino,
                                       p.passandopor passandopor,
                                       p.descveiculo veiculo,
                                       p.fcf_fretecar_valor valor,
                                       p.fcf_fretecar_pedagio pedagio,
                                       p.Critica
                                  from tdvadm.v_fcf_fretecar_protocolo p
                                  where p.protocolo = c_msg.glb_benasserec_chave;

               pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
               pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
               pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha);
   
               pCorpoEmail := pCorpoemail ||  'CRITICAS VINCULAÇÃO DE CVA Id: '|| c_msg.glb_benasserec_chave ||' <br />';

               for i in 1 .. vLinha.count loop
                  if pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                     pCorpoEmail := pCorpoEmail || vLinha(i);
                  Else
                     pCorpoEmail := pCorpoEmail || vLinha(i) || chr(10);
                  End if;
               End loop;
               
             end;
             COMMIT;

             wservice.pkg_glb_email.SP_ENVIAEMAIL(P_ASSUNTO => 'CADASTRO DE FRETE',
                                                  P_TEXTO   => pCorpoemail,
                                                  P_ORIGEM  => 'aut-e@dellavolpe.com.br',
                                                  P_DESTINO =>  c_msg.glb_benasserec_origem,
                                                  P_COPIA   => 'sirlano.drumond@dellavolpe.com.br',
                                                  P_COPIA2  => null);

            pCorpoemail := empty_clob;


    End Loop;
    commit;
     

  
end;
  


END PKG_SCH_PROCEDURES;
/
