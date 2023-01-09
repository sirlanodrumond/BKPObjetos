create or replace package pkg_slf_percurso is

  TYPE T_CURSOR IS REF CURSOR;

   -- Cadastra percursos novos das notas
  procedure Sp_slf_CadastraPercurso;

  procedure Sp_Slf_AtualizaKm;

   -- Cadastra percursos novos das coletas
  procedure Sp_slf_CadastraPercursoColeta;

  procedure Sp_slf_CadastraPercurso2(pOrigem in char,
                                     pDestino in Char);
  
  Procedure sp_slf_informaPercurso(pGrupo   in char,
                                   pDias    in number,
                                   pStatus  out char,
                                   pMessage out clob);
   procedure sp_atu_percursocontrato;
 
   PROCEDURE SP_ATU_PEDAGIOPERNOVO;
   
   Procedure sp_cad_permesa;
    
end pkg_slf_percurso;

 
/
create or replace package body pkg_slf_percurso is

   -- Cadastra percursos novos das notas e das solicitacoes de veiculos
   -- T_ARM_NOTA
   -- V_FCF_SOLVEIC
   procedure Sp_slf_CadastraPercurso as
      
      -- Local variables here
       vIbgeOrigem              tdvadm.t_glb_localidade.glb_localidade_codigo%type;
       vUfOrigem                tdvadm.t_glb_estado.glb_estado_codigo%type;
       vCidadeOrigem            ibge.v_glb_ibge.nomeex%type;
       vIbgeDestino             tdvadm.t_glb_localidade.glb_localidade_codigo%type;
       vUfDestino               tdvadm.t_glb_estado.glb_estado_codigo%type;
       vCidadeDestino           ibge.v_glb_ibge.nomeex%type;
       vStatus                  char(1);
       vMessage                 varchar2(4000);
      
   begin
      -- Test statements here
      
      for p_cursor in (select distinct kk.arm_nota_localcoletal,
                              kk.arm_nota_localentregal,
                              'NOTA' origem
                       from tdvadm.t_arm_nota kk
                       where trunc(kk.arm_nota_dtinclusao) between trunc(sysdate-60) and trunc(sysdate)
                         and kk.arm_nota_localcoletal is not null
                         and (select count(*)
                              from tdvadm.t_slf_percurso ll
                              where ( ll.slf_percurso_codigo = trim(kk.arm_nota_localcoletal) || trim(kk.arm_nota_localentregal)) 
                                 or (ll.slf_percurso_km <= 0) )= 0
                       union
                       select distinct sv.origemLOSO,
                              sv.destinoLOSO,
                              'SOLVEIC' origem
                       from tdvadm.v_fcf_solveic sv
                       where trunc(sv.FCF_SOLVEIC_DTCONTR) between trunc(sysdate-60) and trunc(sysdate)
                         and (select count(*)
                              from tdvadm.t_slf_percurso ll
                              where ( ll.slf_percurso_codigo = trim(sv.origemLOSO) || trim(sv.destinoLOSO)) 
                                 or (ll.slf_percurso_km <= 0) )= 0 )
      loop
        
         begin
        
         -- Busca de informações da localidade de Origem
         select lo.glb_localidade_codigoibge,
                ib.ufsigla,
                ib.nomeex
           into vIbgeOrigem,
                vUfOrigem,
                vCidadeOrigem
           from tdvadm.t_glb_localidade lo,
                ibge.v_glb_ibge ib
          where lo.glb_localidade_codigo     = P_CURSOR.ARM_NOTA_LOCALCOLETAL
            and lo.glb_localidade_codigoibge = ib.codmun;
        
         -- Busca de informações da localidade de Destino
         select lo.glb_localidade_codigoibge,
                ib.ufsigla,
                ib.nomeex
           into vIbgeDestino,
                vUfDestino,
                vCidadeDestino
           from tdvadm.t_glb_localidade lo,
                ibge.v_glb_ibge ib
          where lo.glb_localidade_codigo     = P_CURSOR.ARM_NOTA_LOCALENTREGAL
            and lo.glb_localidade_codigoibge = ib.codmun;
         
         
         -- inclusão do percurso
         Begin  
             insert into tdvadm.t_slf_percurso(slf_percurso_codigo,
                                               slf_percuso_descricao,
                                               glb_localidade_codigoorigem,
                                               glb_localidade_codigodestino,
                                               slf_percurso_km,
                                               usu_usuario_codigo,
                                               slf_percurso_datacadastro,
                                               slf_percurso_kmtdv,
                                               glb_localidade_codigoorigemi,
                                               glb_localidade_codigodestinoi,
                                               slf_percurso_flagcons)
                                        values(trim(p_cursor.arm_nota_localcoletal)||trim(p_cursor.arm_nota_localentregal),
                                               substr(vUfOrigem||'-'||vCidadeOrigem||' | '||vUfDestino||'-'||vCidadeDestino,1,50),
                                               p_cursor.arm_nota_localcoletal,
                                               p_cursor.arm_nota_localentregal,
                                               null,
                                               'jsantos',
                                               sysdate,
                                               null,
                                               vIbgeOrigem,
                                               vIbgeDestino,
                                               'N');
         exception
           When DUP_VAL_ON_INDEX Then
              update tdvadm.t_slf_percurso s
                set s.slf_percurso_flagcons = 'N'
              where s.slf_percurso_codigo = trim(p_cursor.arm_nota_localcoletal)||trim(p_cursor.arm_nota_localentregal);
           End;
         
         exception when others then
           vStatus  := 'E'; 
           vMessage := sqlerrm;
           wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao cadastrar percurso. As.: ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),
                                                'Percurso.: '||trim(p_cursor.arm_nota_localcoletal)||trim(p_cursor.arm_nota_localentregal)||
                                                'Hora : ' || to_char(sysdate,'hh24:mi:ss') ||
                                                'Erro.: '||vMessage || CHR(10) ||
                                                'Rotinas envolvidas: ' || dbms_utility.format_call_stack,                                                
                                                'analisedb@dellavolpe.com.br',
                                                'ksouza@dellavolpe.com.br;grp.hd@dellavolpe.com.br',
                                                'klaytonhpr@gmail.com;brunokiko91@gmail.com',
                                                'sirlanodrumond@gmail.com');
           
         end;                  
      
      end loop;   
      
      vStatus  := 'N'; 
      vMessage := 'Processamento Normal!';                  
      
      commit;

   end Sp_slf_CadastraPercurso;

   procedure Sp_Slf_AtualizaKm as
     vStatus                  char(1);
     vMessage                 varchar2(4000);
   begin
     
     begin
       
      -- Cursor com os percursos que precisam ser atualizados.
      for p_curso in (select distinct ll.slf_percurso_codigo
                        from tdvadm.t_arm_nota kk,
                             tdvadm.t_slf_percurso ll
                       where trunc(kk.arm_nota_dtinclusao) between trunc(sysdate-10) and trunc(sysdate)
                         and kk.arm_nota_localcoletal  is not null
                         and kk.arm_nota_localcoletal  = ll.glb_localidade_codigoorigem
                         and kk.arm_nota_localentregal = ll.glb_localidade_codigodestino
                         and ll.slf_percurso_xml       is null
                         and ll.slf_percurso_flagcons  = 'S'
                         
                  union
                      
                      select distinct ll.slf_percurso_codigo
                        from tdvadm.t_arm_nota kk,
                             tdvadm.t_slf_percurso ll
                       where trunc(kk.arm_nota_dtinclusao) between trunc(sysdate-10) and trunc(sysdate)
                         and kk.arm_nota_localcoletal  is not null
                         and kk.arm_nota_localcoletal  = ll.glb_localidade_codigoorigem
                         and kk.arm_nota_localentregal = ll.glb_localidade_codigodestino
                         and  ll.slf_percurso_km       = 0
                         and ll.slf_percurso_flagcons  = 'S')
      loop
         
        -- update para que o serviço se consutla de KM seja sencibilizado.        
        update tdvadm.t_slf_percurso ll
           set ll.slf_percurso_flagcons      = 'N',
               ll.slf_percurso_dtatualizacao = null
         where ll.slf_percurso_codigo      = p_curso.slf_percurso_codigo;        
        
      end loop;
       
      vStatus  := 'N'; 
      vMessage := 'Processamento Normal!';            
      
     exception when others then
           vStatus  := 'E'; 
           vMessage := sqlerrm;
           wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao atualizar percurso. As.: ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),
                                                'Hora : ' || to_char(sysdate,'hh24:mi:ss') ||
                                                ' Erro.: '||vMessage,
                                                'analisedb@dellavolpe.com.br',
                                                'ksouza@dellavolpe.com.br;grp.hd@dellavolpe.com.br',
                                                'klaytonhpr@gmail.com;brunokiko91@gmail.com',
                                                'sirlanodrumond@gmail.com');
           
     end;
     
     commit;
            
   end Sp_Slf_AtualizaKm;    
   
   -- Cadastra percursos novos das coletas
   procedure Sp_slf_CadastraPercursoColeta as
   
   vIbgeOrigem              tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vUfOrigem                tdvadm.t_glb_estado.glb_estado_codigo%type;
   vCidadeOrigem            ibge.v_glb_ibge.nomeex%type;
   vIbgeDestino             tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vUfDestino               tdvadm.t_glb_estado.glb_estado_codigo%type;
   vCidadeDestino           ibge.v_glb_ibge.nomeex%type;
   vStatus                  char(1);
   vMessage                 varchar2(4000);
   
   begin
     
      for p_cursor in (select distinct cr.glb_localidade_codigo       ren_localidade,
                                       ldv.glb_localidade_codigo      filial_localidade
                         from tdvadm.t_arm_coleta k,
                              tdvadm.t_arm_armazem ar,
                              tdvadm.t_arm_coletaorigem o,
                              tdvadm.t_glb_cliente c,
                              tdvadm.t_glb_cliend cr,
                              tdvadm.t_glb_localidade lo,
                              tdvadm.t_glb_localidade ldv
                         where trunc(k.arm_coleta_dtimp)        between trunc(sysdate-15) and trunc(sysdate)
                           and o.arm_coletaorigem_cod           = k.arm_coletaorigem_cod
                           and k.arm_coleta_cnpjpagadorferete   is not null
                           and k.arm_coleta_cnpjpagadorferete   = c.glb_cliente_cgccpfcodigo
                           and k.glb_cliente_cgccpfcodigocoleta = cr.glb_cliente_cgccpfcodigo
                           and k.glb_tpcliend_codigocoleta      = cr.glb_tpcliend_codigo
                           and cr.glb_localidade_codigo         = lo.glb_localidade_codigo
                           and k.arm_armazem_codigo             = ar.arm_armazem_codigo
                           and ar.glb_localidade_codigo         = ldv.glb_localidade_codigo
                           -- Se cobra coleta o sacado
                           and ( select count(*)
                                  from tdvadm.t_glb_clientecontrato c,
                                       tdvadm.t_slf_clientecargas cc
                                 where c.slf_contrato_codigo = cc.slf_contrato_codigo
                                   and cc.slf_clientecargas_ativo = 'S'
                                   and cc.slf_clientecargas_cobracoleta = 'S'     
                                   and c.glb_cliente_cgccpfcodigo = k.arm_coleta_cnpjpagadorferete) > 0
                           -- Se não existe percurso        
                           and  (select count(*)
                                   from tdvadm.t_slf_percurso pp
                                  where pp.glb_localidade_codigoorigem = cr.glb_localidade_codigo
                                    and pp.glb_localidade_codigodestino = ldv.glb_localidade_codigo) = 0)
      loop
        
         begin
        
         -- Busca de informações da localidade de Origem
         select lo.glb_localidade_codigoibge,
                ib.ufsigla,
                ib.nomeex
           into vIbgeOrigem,
                vUfOrigem,
                vCidadeOrigem
           from tdvadm.t_glb_localidade lo,
                ibge.v_glb_ibge ib
          where lo.glb_localidade_codigo     = P_CURSOR.REN_LOCALIDADE
            and lo.glb_localidade_codigoibge = ib.codmun;
        
         -- Busca de informações da localidade de Destino
         select lo.glb_localidade_codigoibge,
                ib.ufsigla,
                ib.nomeex
           into vIbgeDestino,
                vUfDestino,
                vCidadeDestino
           from tdvadm.t_glb_localidade lo,
                ibge.v_glb_ibge ib
          where lo.glb_localidade_codigo     = P_CURSOR.FILIAL_LOCALIDADE
            and lo.glb_localidade_codigoibge = ib.codmun;
         
         
         -- inclusão do percurso
         insert into tdvadm.t_slf_percurso(slf_percurso_codigo,
                                           slf_percuso_descricao,
                                           glb_localidade_codigoorigem,
                                           glb_localidade_codigodestino,
                                           slf_percurso_km,
                                           usu_usuario_codigo,
                                           slf_percurso_datacadastro,
                                           slf_percurso_kmtdv,
                                           glb_localidade_codigoorigemi,
                                           glb_localidade_codigodestinoi,
                                           slf_percurso_flagcons)
                                    values(trim(p_cursor.ren_localidade)||trim(p_cursor.filial_localidade),
                                           substr(vUfOrigem||'-'||vCidadeOrigem||' | '||vUfDestino||'-'||vCidadeDestino,1,50),
                                           p_cursor.ren_localidade,
                                           p_cursor.filial_localidade,
                                           null,
                                           'jsantos',
                                           sysdate,
                                           null,
                                           vIbgeOrigem,
                                           vIbgeDestino,
                                           'N');
         
         exception when others then
           vStatus  := 'E'; 
           vMessage := sqlerrm;

           wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao cadastrar percurso. As.: ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),
                                                'Percurso.: '||trim(p_cursor.ren_localidade)||trim(p_cursor.filial_localidade) ||
                                                'Hora : ' || to_char(sysdate,'hh24:mi:ss') ||
                                                'Erro.: ' || vMessage || chr(10) ||
                                                'Rotinas envolvidas: ' || dbms_utility.format_call_stack,
                                                'analisedb@dellavolpe.com.br',
                                                'ksouza@dellavolpe.com.br;grp.hd@dellavolpe.com.br',
                                                'klaytonhpr@gmail.com;brunokiko91@gmail.com',
                                                'sirlanodrumond@gmail.com');
           
         end;                  
      
      end loop;   
      
      vStatus  := 'N'; 
      vMessage := 'Processamento Normal!';                  
      
      commit;

   end Sp_slf_CadastraPercursoColeta;
   
   procedure Sp_slf_CadastraPercurso2(pOrigem in char,
                                      pDestino in Char)  
    as
   
   vIbgeOrigem              tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vUfOrigem                tdvadm.t_glb_estado.glb_estado_codigo%type;
   vCidadeOrigem            ibge.v_glb_ibge.nomeex%type;
   vIbgeDestino             tdvadm.t_glb_localidade.glb_localidade_codigo%type;
   vUfDestino               tdvadm.t_glb_estado.glb_estado_codigo%type;
   vCidadeDestino           ibge.v_glb_ibge.nomeex%type;
   vStatus                  char(1);
   vMessage                 varchar2(4000);
   begin
     
        
         begin
        
         -- Busca de informações da localidade de Origem
         select lo.glb_localidade_codigoibge,
                ib.ufsigla,
                ib.nomeex
           into vIbgeOrigem,
                vUfOrigem,
                vCidadeOrigem
           from tdvadm.t_glb_localidade lo,
                ibge.v_glb_ibge ib
          where lo.glb_localidade_codigo     = pOrigem
            and lo.glb_localidade_codigoibge = ib.codmun;
        
         -- Busca de informações da localidade de Destino
         select lo.glb_localidade_codigoibge,
                ib.ufsigla,
                ib.nomeex
           into vIbgeDestino,
                vUfDestino,
                vCidadeDestino
           from tdvadm.t_glb_localidade lo,
                ibge.v_glb_ibge ib
          where lo.glb_localidade_codigo     = pDestino
            and lo.glb_localidade_codigoibge = ib.codmun;
         
         
         -- inclusão do percurso
         insert into tdvadm.t_slf_percurso(slf_percurso_codigo,
                                           slf_percuso_descricao,
                                           glb_localidade_codigoorigem,
                                           glb_localidade_codigodestino,
                                           slf_percurso_km,
                                           usu_usuario_codigo,
                                           slf_percurso_datacadastro,
                                           slf_percurso_kmtdv,
                                           glb_localidade_codigoorigemi,
                                           glb_localidade_codigodestinoi,
                                           slf_percurso_flagcons)
                                    values(trim(pOrigem)||trim(pDestino),
                                           substr(vUfOrigem||'-'||vCidadeOrigem||' | '||vUfDestino||'-'||vCidadeDestino,1,50),
                                           pOrigem,
                                           pDestino,
                                           null,
                                           'jsantos',
                                           sysdate,
                                           null,
                                           vIbgeOrigem,
                                           vIbgeDestino,
                                           'N');
         
         exception when others then
           vStatus  := 'E'; 
           vMessage := sqlerrm;

           wservice.pkg_glb_email.SP_ENVIAEMAIL('Erro ao cadastrar percurso(Sp_slf_CadastraPercurso2). As.: ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),
                                                'Percurso.: '||trim(pOrigem)||trim(pDestino)||
                                                'Hora : ' || to_char(sysdate,'hh24:mi:ss') ||
                                                'Erro.: '||vMessage || CHR(10) ||
                                                'Rotinas envolvidas: ' || dbms_utility.format_call_stack,
                                                'analisedb@dellavolpe.com.br',
                                                'ksouza@dellavolpe.com.br;grp.hd@dellavolpe.com.br',
                                                'klaytonhpr@gmail.com;brunokiko91@gmail.com',
                                                'sirlanodrumond@dellavolpe.com.br');
           
         end;                  
      
      
      vStatus  := 'N'; 
      vMessage := 'Processamento Normal!';                  
      

   end Sp_slf_CadastraPercurso2;

   
   Procedure sp_slf_informaPercurso(pGrupo   in char,
                                    pDias    in number,
                                    pStatus  out char,
                                    pMessage out clob)

     As
     vLinha1       pkg_glb_SqlCursor.tpString1024;
     vCursor       pkg_slf_percurso.T_CURSOR;
     vAuxiliar     number;
     vTempo        number := 0.0625; -- 1 Hora e 30 minutos


Begin

      If pDias = 0 Then
          
          select count(*)
             into vAuxiliar
          from tdvadm.t_slf_percurso_2781910 p
          where p.slf_percurso_datacadastro >= sysdate - vTempo
          and (trim(p.glb_localidade_codigoorigemi),
               trim(p.glb_localidade_codigodestinoi)) in (select trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localcoleta,'IBC')),
                                                           trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localentrega,'IBC'))
                                                    from tdvadm.t_con_conhecimento c,
                                                         tdvadm.t_glb_cliente cl
                                                    where trunc(c.con_conhecimento_dtembarque) = trunc(sysdate) - pDias
                                                      and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                                                      and cl.glb_grupoeconomico_codigo = pGrupo
                                                      and c.con_conhecimento_localcoleta = p.glb_localidade_codigoorigem
                                                      and c.con_conhecimento_localentrega = p.glb_localidade_codigodestino
                                                      and rownum = 1);
      Else
          select count(*)
             into vAuxiliar
          from tdvadm.t_slf_percurso_2781910 p
          where trunc(p.slf_percurso_datacadastro) = trunc(sysdate) - pDias
          and (trim(p.glb_localidade_codigoorigemi),
               trim(p.glb_localidade_codigodestinoi)) in (select trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localcoleta,'IBC')),
                                                           trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localentrega,'IBC'))
                                                    from tdvadm.t_con_conhecimento c,
                                                         tdvadm.t_glb_cliente cl
                                                    where trunc(c.con_conhecimento_dtembarque) = trunc(sysdate) - pDias
                                                      and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                                                      and cl.glb_grupoeconomico_codigo = pGrupo
                                                      and c.con_conhecimento_localcoleta = p.glb_localidade_codigoorigem
                                                      and c.con_conhecimento_localentrega = p.glb_localidade_codigodestino
                                                      and rownum = 1);
      End If;
      If vAuxiliar > 0 Then                                                  
         pStatus := 'N';
      Else
         pStatus := 'W';
      End If;



   If pStatus = 'N' Then
       Begin
       If pDias = 0 Then
          open vCursor For
            select p.slf_percurso_datacadastro cadastro,
           /*       (select p1.slf_percurso_datacadastro
                 from tdvadm.t_slf_percurso p1
                 where p1.glb_localidade_codigoorigem = p.glb_localidade_codigoorigem
                   and p1.glb_localidade_codigodestino = p.glb_localidade_codigodestino) cadastrotdv,
           */       p.glb_localidade_codigoorigemi ibgeori,
                p.glb_localidade_codigodestinoi ibgedest,
                p.slf_percuso_descricao percurso,
                tdvadm.f_mascara_valor(p.slf_percurso_km,6,1) km
           /*       ,(select p1.slf_percurso_km
                 from tdvadm.t_slf_percurso p1
                 where p1.glb_localidade_codigoorigem = p.glb_localidade_codigoorigem
                   and p1.glb_localidade_codigodestino = p.glb_localidade_codigodestino) percursotdv
                ,(select c.con_conhecimento_codigo || c.con_conhecimento_serie || c.glb_rota_codigo
                 from tdvadm.t_con_conhecimento c,
                      tdvadm.t_glb_cliente cl
                 where c.con_conhecimento_dtembarque >= '08/08/2017'
                   and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                   and cl.glb_grupoeconomico_codigo = '0020'
                   and c.con_conhecimento_localcoleta = p.glb_localidade_codigoorigem
                   and c.con_conhecimento_localentrega = p.glb_localidade_codigodestino
                   and rownum = 1)       
           */from tdvadm.t_slf_percurso_2781910 p
           where p.slf_percurso_datacadastro >= sysdate - vTempo
             and (trim(p.glb_localidade_codigoorigemi),
                  trim(p.glb_localidade_codigodestinoi)) in (select trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localcoleta,'IBC')),
                                                                    trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localentrega,'IBC'))
                                                             from tdvadm.t_con_conhecimento c,
                                                                  tdvadm.t_glb_cliente cl
                                                             where trunc(c.con_conhecimento_dtembarque) = trunc(sysdate) - pDias
                                                               and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                                                               and cl.glb_grupoeconomico_codigo = pGrupo
                                                               and c.con_conhecimento_localcoleta = p.glb_localidade_codigoorigem
                                                               and c.con_conhecimento_localentrega = p.glb_localidade_codigodestino
                                                               and rownum = 1)
           order by 3,4;
        Else
          open vCursor For
            select trunc(p.slf_percurso_datacadastro) cadastro,
           /*       (select p1.slf_percurso_datacadastro
                 from tdvadm.t_slf_percurso p1
                 where p1.glb_localidade_codigoorigem = p.glb_localidade_codigoorigem
                   and p1.glb_localidade_codigodestino = p.glb_localidade_codigodestino) cadastrotdv,
           */       p.glb_localidade_codigoorigemi ibgeori,
                p.glb_localidade_codigodestinoi ibgedest,
                p.slf_percuso_descricao percurso,
                tdvadm.f_mascara_valor(p.slf_percurso_km,6,1) km
           /*       ,(select p1.slf_percurso_km
                 from tdvadm.t_slf_percurso p1
                 where p1.glb_localidade_codigoorigem = p.glb_localidade_codigoorigem
                   and p1.glb_localidade_codigodestino = p.glb_localidade_codigodestino) percursotdv
                ,(select c.con_conhecimento_codigo || c.con_conhecimento_serie || c.glb_rota_codigo
                 from tdvadm.t_con_conhecimento c,
                      tdvadm.t_glb_cliente cl
                 where c.con_conhecimento_dtembarque >= '08/08/2017'
                   and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                   and cl.glb_grupoeconomico_codigo = '0020'
                   and c.con_conhecimento_localcoleta = p.glb_localidade_codigoorigem
                   and c.con_conhecimento_localentrega = p.glb_localidade_codigodestino
                   and rownum = 1)       
           */from tdvadm.t_slf_percurso_2781910 p
           where trunc(p.slf_percurso_datacadastro) = trunc(sysdate) - pDias
             and (trim(p.glb_localidade_codigoorigemi),
                  trim(p.glb_localidade_codigodestinoi)) in (select trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localcoleta,'IBC')),
                                                                    trim(tdvadm.fn_busca_codigoibge(c.con_conhecimento_localentrega,'IBC'))
                                                             from tdvadm.t_con_conhecimento c,
                                                                  tdvadm.t_glb_cliente cl
                                                             where trunc(c.con_conhecimento_dtembarque) = trunc(sysdate) - pDias
                                                               and c.glb_cliente_cgccpfsacado = cl.glb_cliente_cgccpfcodigo
                                                               and cl.glb_grupoeconomico_codigo = pGrupo
                                                               and c.con_conhecimento_localcoleta = p.glb_localidade_codigoorigem
                                                               and c.con_conhecimento_localentrega = p.glb_localidade_codigodestino
                                                               and rownum = 1)
           order by 3,4;
        End If;         
 
      
           tdvadm.pkg_glb_SqlCursor.TiposComuns.Formato := 'H';
           tdvadm.pkg_glb_SqlCursor.TipoHederHTML.Alinhamento := 'Left';
           tdvadm.pkg_glb_SqlCursor.sp_Get_Cursor(vCursor,vLinha1);
           for i in 1 .. vLinha1.count loop
              if tdvadm.pkg_glb_SqlCursor.TiposComuns.Formato = 'H' then
                 pMessage := pMessage || vLinha1(i);
              Else
                 pMessage := pMessage || vLinha1(i) || chr(10);
              End if;
           End loop; 
        
       exception
           When OTHERS Then
              pStatus := 'E';
       End;
   End If;

End sp_slf_informaPercurso;
   
   
Procedure sp_atu_percursocontrato as
/* ATUALIZA OS PEDAGIOS PESQUISADOS NAS TABELAS DE CONTRATO */
  -- Local variables here
  i integer;
  vOrigem    tdvadm.t_arm_nota.arm_nota_localcoletal%type;
  vDestino   tdvadm.t_arm_nota.arm_nota_localentregal%type;
  vOrigemi   tdvadm.t_arm_nota.arm_nota_localcoletai%type;
  vDestinoi  tdvadm.t_arm_nota.arm_nota_localentregai%type;
  vVeiculo   tdvadm.t_fcf_tpveiculo.fcf_tpveiculo_codigo%type;
  vCarga     tdvadm.t_fcf_tpcarga.fcf_tpcarga_codigo%type;
  vTabela    tdvadm.t_slf_clienteregras.slf_clienteregras_tabkm%type;
  tpPercurso tdvadm.t_slf_percurso%rowType;
  tpPedagio  tdvadm.t_slf_clienteped%rowType;
  vAuxiliar  number;
  vMsg       varchar2(1000);
 vVlrPedPer  number;
 vErro      varchar2(1000);
 vValorPed  number;
begin
  -- Test statements here
  i := 0;
  FOR C_MSG IN (SELECT DISTINCT --AN.ARM_NOTA_DTINCLUSAO,
                       AN.ARM_NOTA_LOCALCOLETAL,
                       AN.ARM_NOTA_LOCALCOLETAI,
                       AN.ARM_NOTA_LOCALENTREGAL,
                       AN.ARM_NOTA_LOCALENTREGAI,
                       CC.SLF_CLIENTEregras_TABKM,
                       CO.FCF_TPVEICULO_CODIGO,
                       CO.FCF_TPCARGA_CODIGO
                FROM TDVADM.T_ARM_NOTA AN,
                     TDVADM.t_Slf_Clienteregras CC,
                     TDVADM.T_ARM_COLETA CO
                WHERE AN.ARM_NOTA_DTINCLUSAO >= SYSDATE - 10
                  AND AN.SLF_CONTRATO_CODIGO = CC.SLF_CONTRATO_CODIGO (+)
                  AND AN.ARM_COLETA_NCOMPRA = CO.ARM_COLETA_NCOMPRA (+)
                  AND AN.ARM_COLETA_CICLO = CO.ARM_COLETA_CICLO (+)
                  AND CC.SLF_CLIENTEregras_ATIVO =  'S'
--                  and AN.CON_CONHECIMENTO_CODIGO IN ('877070')
--                  AND CC.SLF_CLIENTECARGAS_TABKM = '2781910'
--                  and AN.ARM_NOTA_LOCALCOLETAI = '3503208'
--                  and AN.ARM_NOTA_LOCALENTREGAI = '3530102'
                  AND ( ( 0 = DECODE(CC.SLF_CLIENTEregras_TABKM,'2781910'     ,(SELECT COUNT(*)
                                                                                FROM TDVADM.T_SLF_PERCURSO_2781910 P
                                                                                WHERE P.GLB_LOCALIDADE_CODIGOORIGEMI = AN.ARM_NOTA_LOCALCOLETAI
                                                                                  AND P.GLB_LOCALIDADE_CODIGODESTINOI = AN.ARM_NOTA_LOCALENTREGAI),
                                                                '82795'       ,(SELECT COUNT(*)
                                                                                FROM TDVADM.T_SLF_PERCURSO_82795 P
                                                                                WHERE P.GLB_LOCALIDADE_CODIGOORIGEMI = AN.ARM_NOTA_LOCALCOLETAI
                                                                                  AND P.GLB_LOCALIDADE_CODIGODESTINOI = AN.ARM_NOTA_LOCALENTREGAI),
                                                                '91566'       ,(SELECT COUNT(*)
                                                                                FROM TDVADM.T_SLF_PERCURSO_91566 P
                                                                                WHERE P.GLB_LOCALIDADE_CODIGOORIGEMI = AN.ARM_NOTA_LOCALCOLETAI
                                                                                  AND P.GLB_LOCALIDADE_CODIGODESTINOI = AN.ARM_NOTA_LOCALENTREGAI),
                                                                'C2018010119' ,(SELECT COUNT(*)
                                                                                FROM TDVADM.T_SLF_PERCURSO_C2018010119 P
                                                                                WHERE P.GLB_LOCALIDADE_CODIGOORIGEMI = AN.ARM_NOTA_LOCALCOLETAI
                                                                                  AND P.GLB_LOCALIDADE_CODIGODESTINOI = AN.ARM_NOTA_LOCALENTREGAI), 1) )
                       or (0 = DECODE(CC.SLF_CLIENTEregras_TABKM,'C2018010119',(SELECT COUNT(*)
                                                                                  FROM TDVADM.t_Slf_Clienteped cp
                                                                                  WHERE cP.Glb_Localidade_Codigooriib = AN.ARM_NOTA_LOCALCOLETAI
                                                                                    AND cp.glb_localidade_codigodesib = AN.ARM_NOTA_LOCALENTREGAI
                                                                                    and cp.slf_contrato_codigo = an.slf_contrato_codigo
                                                                                    and cp.fcf_tpcarga_codigo = decode(co.fcf_tpcarga_codigo,'11','01',co.fcf_tpcarga_codigo)
                                                                                    and cp.fcf_tpveiculo_codigo = co.fcf_tpveiculo_codigo),1  ) ))
               )
   Loop
      vTabela   := c_msg.slf_clienteregras_tabkm;
      vOrigem   := c_msg.arm_nota_localcoletal;
      vDestino  := c_msg.arm_nota_localentregal;
      vOrigemi  := c_msg.arm_nota_localcoletai;
      vDestinoi := c_msg.arm_nota_localentregai;
      vVeiculo  := c_msg.fcf_tpveiculo_codigo;
      vCarga    := c_msg.fcf_tpcarga_codigo;
      Begin
        select *
          into tpPercurso
        From tdvadm.t_slf_percurso p
        where p.slf_percurso_codigo = trim(vOrigem) || trim(vDestino)
--        where p.glb_localidade_codigoorigem = vOrigem
--          and p.glb_localidade_codigodestino = vDestino
          and nvl(p.slf_percurso_km,0) > 0
--          and p.slf_percurso_flagcons = 'S'
          ;
        i:= 1;
      Exception
        When NO_DATA_FOUND then
           i := 0;
        End;     
      If i =  1 then
         vOrigemi := c_msg.arm_nota_localcoletai;
         vDestinoi := c_msg.arm_nota_localentregai;
         tpPercurso.Slf_Percurso_Datacadastro := sysdate;
         If vTabela = '2781910' Then
            select count(*)
              into vAuxiliar
            from tdvadm.t_slf_percurso_2781910 x
            where x.glb_localidade_codigoorigem = vOrigem
              and x.glb_localidade_codigodestino = vDestino;
            If vAuxiliar = 0 Then          
               insert into tdvadm.t_slf_percurso_2781910
               values tpPercurso;
            End If;
         ElsIf vTabela = '82795' Then
            select count(*)
              into vAuxiliar
            from tdvadm.t_slf_percurso_82795 x
            where x.glb_localidade_codigoorigem = vOrigem
              and x.glb_localidade_codigodestino = vDestino;
            If vAuxiliar = 0 Then          
               insert into tdvadm.t_slf_percurso_82795
               values tpPercurso;
            End If;
         ElsIf vTabela = '91566' Then
            select count(*)
              into vAuxiliar
            from tdvadm.t_slf_percurso_91566 x
            where x.glb_localidade_codigoorigem = vOrigem
              and x.glb_localidade_codigodestino = vDestino;
            If vAuxiliar = 0 Then          
               insert into tdvadm.t_slf_percurso_91566
               values tpPercurso;
            End If;
         ElsIf ( vTabela = 'C2018010119' ) /*and ( vCarga in ('33','34','38'))*/ Then
            select count(*)
              into vAuxiliar
            from tdvadm.t_slf_percurso_C2018010119 x
            where x.glb_localidade_codigoorigem = vOrigem
              and x.glb_localidade_codigodestino = vDestino;
            If vAuxiliar = 0 Then  
               Begin
                  select max(x.slf_clienteped_kmper)
                    into vAuxiliar
                  from tdvadm.t_slf_clienteped_tmp x
                  where x.glb_localidade_codigooriib = vOrigemi
                    and x.glb_localidade_codigodesib = vDestinoi;
                  tpPercurso.Slf_Percurso_Km    := vAuxiliar;
                  tpPercurso.Slf_Percurso_Kmtdv := vAuxiliar;
               exception
                 When Others Then
                     tpPercurso.Slf_Percurso_Km := tpPercurso.Slf_Percurso_Km;
               End;
               insert into tdvadm.t_slf_percurso_C2018010119
               values tpPercurso;
            End If;
            Begin
              If nvl(vVeiculo,'x  ') <> '9  ' Then
                select x.glb_grupoeconomico_codigo,
                       x.glb_cliente_cgccpfcodigo,
                       x.fcf_tpcarga_codigo,
                       x.slf_contrato_codigo,
                       x.slf_clienteped_vigencia,
                       x.slf_clienteped_ativo,
                       x.fcf_tpveiculo_codigo,
                       x.glb_localidade_codigoori,
                       x.glb_localidade_codigodes,
                       x.glb_localidade_codigooriib,
                       x.glb_localidade_codigodesib,
                       x.slf_clienteped_valor,
                       x.slf_clienteped_desinencia,
                       x.slf_clienteped_codcli,
                       x.glb_localidade_outracoletai,
                       x.glb_localidade_outraentregai
                    into tpPedagio
                from tdvadm.t_slf_clienteped_tmp x
                where x.glb_localidade_codigooriib = vOrigemi
                  and x.glb_localidade_codigodesib = vDestinoi;
                 vValorPed := tpPedagio.Slf_Clienteped_Valor;
                For c_msg in (select distinct t.fcf_tpveiculo_codigo,
                                     tv.fcf_tpveiculo_nreixos
                              from tdvadm.t_slf_cliregrasveic t,
                                   tdvadm.t_fcf_tpveiculo tv
                              where t.slf_contrato_codigo = 'C2018010119'
                                and t.fcf_tpveiculo_codigo = tv.fcf_tpveiculo_codigo
                                and t.fcf_tpveiculo_codigo <> '9  ')
                Loop
                   
                   tpPedagio.Fcf_Tpveiculo_Codigo := c_msg.fcf_tpveiculo_codigo;
                   tpPedagio.Fcf_Tpcarga_Codigo   := vCarga;
                   tpPedagio.Slf_Clienteped_Valor := vValorPed * c_msg.fcf_tpveiculo_nreixos;
                   If tpPedagio.Fcf_Tpcarga_Codigo in ('01','33','34','38') Then
                      tpPedagio.Slf_Clienteped_Desinencia := 'VL';
                   Else                     
                      tpPedagio.Slf_Clienteped_Desinencia := 'TX';
                   End If;   
                    begin
                       select count(*)
                         into vAuxiliar
                       FROM TDVADM.t_Slf_Clienteped cp
                       WHERE cP.Glb_Localidade_Codigooriib = tpPedagio.Glb_Localidade_Codigooriib
                         AND cp.glb_localidade_codigodesib = tpPedagio.Glb_Localidade_Codigodesib
                         and cp.slf_contrato_codigo = tpPedagio.Slf_Contrato_Codigo
                         and cp.fcf_tpcarga_codigo = tpPedagio.Fcf_Tpcarga_Codigo
                         and cp.fcf_tpveiculo_codigo = tpPedagio.Fcf_Tpveiculo_Codigo
                         and cp.slf_clienteped_vigencia = (select max(cp1.slf_clienteped_vigencia)
                                                           from tdvadm.t_slf_clienteped cp1
                                                           where cp1.glb_grupoeconomico_codigo = cp.glb_grupoeconomico_codigo
                                                             and cp1.glb_cliente_cgccpfcodigo = cp.glb_cliente_cgccpfcodigo
                                                             and cp1.fcf_tpcarga_codigo = cp.fcf_tpcarga_codigo
                                                             and cp1.slf_contrato_codigo = cp.slf_contrato_codigo
                                                             and cp1.glb_localidade_codigooriib = cp.glb_localidade_codigooriib
                                                             and cp1.glb_localidade_codigodesib = cp.glb_localidade_codigodesib);
                       If (vAuxiliar = 0)  and (tpPedagio.Fcf_Tpcarga_Codigo in ('01','33','34','38')) Then
                          Insert into tdvadm.t_slf_clienteped
                          values tpPedagio;
                       End If;
                    exception
                      When OTHERS Then
                        vMsg :=  sqlerrm; 
                        vAuxiliar := vAuxiliar;
                    end;                   
                End Loop;
                 
              End If;
            exception
              When OTHERS Then
                 vAuxiliar := vAuxiliar;
            End;
         End If;
      End IF;
   End Loop;
   commit;                
end sp_atu_percursocontrato;  


PROCEDURE SP_ATU_PEDAGIOPERNOVO
As
  i integer;
  vTempo number := -3;
  tpFretecar tdvadm.t_fcf_fretecar%rowtype;
begin

   for c_msg in (select ped.slf_percurso_codigo,'Begin ' || chr(10) || 'tdvadm.pkg_cfe_frete.SP_SET_SOLICITAPED(''' || trim(ped.glb_localidade_codigoorigem) || ''',''' || trim(ped.glb_localidade_codigodestino) || ''',''00000'');' || chr(10) || 'End;' script
                 from tdvadm.t_slf_percurso ped,
                      tdvadm.t_fcf_fretecar fc
                 where 0 = 0
--                   and ped.slf_percurso_codigo like '%1410035860%'
                   and ped.glb_localidade_codigoorigem = fc.fcf_fretecar_origem
                   and ped.glb_localidade_codigodestino = fc.fcf_fretecar_destino
                   and nvl(fc.fcf_fretecar_pedagio,0) = 0
                   and 0 = (select count(*)
                            from tdvadm.t_slf_percursoped cp
                            where cp.slf_percursoped_codigo = ped.slf_percurso_codigo))
    loop
      Begin
         execute immediate(c_msg.script);
       exception 
         When OTHERS Then
           vTempo := vTempo;
         End ;
      
    End Loop;


  -- sysdate  + glbadm.PKG_Glb_DateUtil.fn_CalculaIntervalo(2,'M')
   update tdvadm.t_slf_percursoped ped
     set ped.slf_percursoped_reprocessa = 'S'
   where ped.slf_percursoped_codigo in (select distinct pp.slf_percursoped_codigo
                                        from tdvadm.v_fcf_solveic sv,
                                             tdvadm.t_slf_percursoped pp,
                                             tdvadm.t_slf_percurso p
                                        where 0 = 0
                                          and trunc(sv.fcf_solveic_dtsoli) >= trunc(sysdate) - 10
                                          and sv.origemLOSO  = p.glb_localidade_codigoorigem
                                          and sv.destinoLOSO = p.glb_localidade_codigodestino 
                                          and p.slf_percurso_codigo = pp.slf_percursoped_codigo 
                                          and pp.glb_localidade_codigopasspor = '00000' 
                                          and (  nvl(pp.slf_percursoped_atualizacao,to_date('01/01/1900','dd/mm/yyyy')) <= add_months(trunc(sysdate),vTempo) 
                                           and pp.slf_percursoped_reprocessa = 'N' ));

  update tdvadm.t_slf_percursoped ped1
    set ped1.slf_percursoped_reprocessa ='M'
  where ped1.slf_percursoped_reprocessa = 'N'
    and ped1.rowid in (select ped.rowid
                       from tdvadm.t_slf_percursoped ped,
                          tdvadm.t_fcf_fretecar fc
                     where 0 = 0
                       and ped.slf_percursoped_codigo = trim(fc.fcf_fretecar_origem) || trim(fc.fcf_fretecar_destino)
                     --  and ped.slf_percursoped_codigo = '1854068515'
                       and fc.fcf_fretecar_dtcadastro >= sysdate - 60
                       and ped.slf_percursoped_reprocessa = 'N'
                       and nvl(fc.fcf_fretecar_pedagio,0) = 0 
--                       and nvl(ped.slf_percursoped_valoreixo,0) <> 0
                       );

                                           
   for c_msg in (select distinct sv.origemLOSO,
                        sv.destinoLOSO,
                        sv.origemIBSO,
                        sv.destinoIBSO,
                        sv.FCF_VEICULODISP_CODIGO,
                        pp.slf_percursoped_valoreixo valoreixo,
                        pp.slf_percursoped_reprocessa reprocessa,
                        pp.slf_percursoped_atualizacao atualizacao,
                        fcf_veiculodisp_flagvirtual flagvirtual,
                        pp.rowid
                 from tdvadm.v_fcf_solveic sv,
                      tdvadm.t_slf_percurso p,
                      tdvadm.t_slf_percursoped pp
                 where 0 = 0
                   and trunc(sv.fcf_solveic_dtsoli) >= trunc(sysdate) - 10 
                   and sv.origemLOSO = p.glb_localidade_codigoorigem 
                   and sv.destinoLOSO = p.glb_localidade_codigodestino  
                   and p.slf_percurso_codigo = pp.slf_percursoped_codigo  
                   and pp.glb_localidade_codigopasspor = '00000' 
                   and ( (  nvl(pp.slf_percursoped_atualizacao,to_date('01/01/1900','dd/mm/yyyy')) >= add_months(trunc(sysdate),vTempo) 
                           and pp.slf_percursoped_reprocessa = 'N' )  or (pp.slf_percursoped_reprocessa in ('M','S','A','E') ))
                 )
   Loop
      If c_msg.reprocessa = 'M' Then
         for c_msg1 in (select fc.rowid,
                               fc.fcf_fretecar_pedagio,
                               fc.fcf_fretecar_pedagio / tv.fcf_tpveiculo_nreixos valoreixo,
                               tv.fcf_tpveiculo_nreixos nreixos
                        from tdvadm.t_fcf_fretecar fc,
                             tdvadm.t_fcf_tpveiculo tv
                        where fc.fcf_tpveiculo_codigo = tv.fcf_tpveiculo_codigo
                          and tv.fcf_tpveiculo_nreixos > 0
                          and fc.fcf_fretecar_origem = c_msg.origemloso
                          and fc.fcf_fretecar_destino = c_msg.destinoloso)
         Loop
            If c_msg1.valoreixo <> c_msg.valoreixo Then
               -- Pega os Dados
               select *
                 into tpFretecar
               from tdvadm.t_fcf_fretecar fc
               where fc.rowid = c_msg1.rowid;
               -- Exclui o registro
               delete tdvadm.t_fcf_fretecar fc
               where fc.rowid = c_msg1.rowid;
               tpFretecar.Fcf_Fretecar_Vigencia   := trunc(sysdate);
               tpFretecar.Fcf_Fretecar_Altpedagio := trunc(sysdate);
               tpFretecar.Fcf_Fretecar_Pedagio    := c_msg.valoreixo * c_msg1.nreixos;
               tpFretecar.Usu_Usuario_Codigo      := 'sistema';
               tpFretecar.Fcf_Fretecar_Rowid      := null;
               Insert into tdvadm.t_fcf_fretecar fc
               values tpFretecar;
            End If;
         End Loop;
         Update tdvadm.t_slf_percursoped pp
           set pp.slf_percursoped_reprocessa = 'N'
         where pp.rowid = c_msg.rowid;
      End If;
   End Loop;
   commit;
end SP_ATU_PEDAGIOPERNOVO;
  

Procedure sp_cad_permesa
As 
   tpFrete tdvadm.t_fcf_fretecar%rowtype;
   vAuxiliar number;
begin
    -- 'ALTERAÇAO PERCURSO'
    For c_msg in (select f.glb_localidade_origem fcf_fretecar_origem,
                   f.glb_localidade_destino fcf_fretecar_destino,
                   tdvadm.fn_busca_codigoibge(f.glb_localidade_origem,'IBC') fcf_fretecar_origemi,
                   tdvadm.fn_busca_codigoibge(f.glb_localidade_destino,'IBC') fcf_fretecar_destinoi,
                   f.fcf_tpveiculo_codigo,
                   'LO' fcf_fretecar_tpfrete,
                   '00' fcf_tpcarga_codigo,
                   substr(f.cad_frete_usualterastatus,1,10) cad_frete_usualterastatus,
                   f.cad_frete_vlraprovado,
                   'VL' fcf_fretecar_desinencia
            from tdvadm.t_cad_frete f
            where 0 = 0
              --and f.fcf_fretecar_rowid is null
              and TRUNC(f.cad_frete_dtaltstatus) >= TRUNC(sysdate) 
              and f.cad_frete_solicitacao = 'ALTERAÇAO PERCURSO'
              and f.cad_frete_status = 'AP'
              and 0 < (select count(*)
                       from tdvadm.t_fcf_fretecar fc
                       where trim(TDVADM.FN_BUSCA_CODIGOIBGE(fc.fcf_fretecar_origem,'IBC')) = trim(TDVADM.FN_BUSCA_CODIGOIBGE(f.glb_localidade_origem,'IBC'))
                         and trim(TDVADM.FN_BUSCA_CODIGOIBGE(fc.fcf_fretecar_destino,'IBC')) = trim(TDVADM.FN_BUSCA_CODIGOIBGE(f.glb_localidade_destino,'IBC'))
                         and fc.fcf_tpveiculo_codigo = f.fcf_tpveiculo_codigo
                         AND FC.FCF_FRETECAR_VALOR <> F.Cad_Frete_Vlraprovado))
    loop
      delete tdvadm.t_fcf_fretecar fc
      where fc.fcf_fretecar_origem = c_msg.fcf_fretecar_origem
        and fc.fcf_fretecar_destino = c_msg.fcf_fretecar_destino
        and fc.fcf_tpveiculo_codigo = c_msg.fcf_tpveiculo_codigo
        and fc.fcf_tpcarga_codigo = c_msg.fcf_tpcarga_codigo;

        tpFrete.fcf_fretecar_origem := c_msg.fcf_fretecar_origem ;
        tpFrete.fcf_fretecar_destino := c_msg.fcf_fretecar_destino ;
        tpFrete.fcf_fretecar_tpfrete := c_msg.fcf_fretecar_tpfrete ;
        tpFrete.fcf_tpveiculo_codigo := c_msg.fcf_tpveiculo_codigo ;
        tpFrete.fcf_tpcarga_codigo := c_msg.fcf_tpcarga_codigo ;
        tpFrete.fcf_fretecar_valor := c_msg.cad_frete_vlraprovado ;
        tpFrete.fcf_fretecar_desinencia := c_msg.fcf_fretecar_desinencia ;
        tpFrete.fcf_fretecar_vigencia := trunc(sysdate) ;
        tpFrete.usu_usuario_cadastro := 'sistema' ;
        tpFrete.usu_usuario_alterou := c_msg.cad_frete_usualterastatus;
        tpFrete.fcf_fretecar_dtcadastro := trunc(sysdate) ;
        tpFrete.fcf_fretecar_dtalteracao := null ;
        tpFrete.fcf_fretecar_pedagio := 0 ;
        tpFrete.fcf_fretecar_altpedagio := null ;
        tpFrete.usu_usuario_codigo := 'sistema' ;
        tpFrete.fcf_fretecar_km := 0 ;
        tpFrete.fcf_fretecar_origemi := c_msg.fcf_fretecar_origemi ;
        tpFrete.fcf_fretecar_destinoi := c_msg.fcf_fretecar_destinoi ;
        tpFrete.fcf_fretecar_rowid := null ;
        tpFrete.fcf_fretecar_pednofrete := 'N' ;
        tpFrete.fcf_fretecar_altkm := null;
        Begin
          select p.slf_percurso_km
            into tpFrete.Fcf_Fretecar_Km
          from tdvadm.t_slf_percurso p
          where p.glb_localidade_codigoorigem = tpFrete.Fcf_Fretecar_Origem
            and p.glb_localidade_codigodestino = tpFrete.Fcf_Fretecar_Destino;
        exception
        When NO_DATA_FOUND Then
            tpFrete.Fcf_Fretecar_Km := 0;
        When OTHERS Then
            tpFrete.Fcf_Fretecar_Km := 0;
        End;
        insert into tdvadm.t_Fcf_Fretecar values tpFrete;
        update tdvadm.t_slf_percurso p
          set p.slf_percurso_flagcons = 'S'
        where tdvadm.fn_busca_codigoibge(p.glb_localidade_codigoorigem,'IBC') = tpFrete.fcf_fretecar_origemi
          and tdvadm.fn_busca_codigoibge(p.glb_localidade_codigodestino,'IBC') = tpFrete.Fcf_Fretecar_Destinoi;  
    End Loop;
    -- 'NOVO PERCURSO'
    For c_msg in (select f.glb_localidade_origem,
                   f.glb_localidade_destino,
                   f.fcf_tpveiculo_codigo,
                   f.cad_frete_vlraprovado,
                   f.usu_usuario_codigo,
                   f.cad_frete_km
            from tdvadm.t_cad_frete f
            where f.fcf_fretecar_rowid is null
              and f.cad_frete_data >= sysdate -20
              and f.cad_frete_solicitacao = 'NOVO PERCURSO'
              and f.cad_frete_status = 'AP'
              and 0 = (select count(*)
                       from tdvadm.t_fcf_fretecar fc
                       where trim(fc.fcf_fretecar_origem) = trim(f.glb_localidade_origem)
                         and trim(fc.fcf_fretecar_destino) = trim(f.glb_localidade_destino)
                         and fc.fcf_tpveiculo_codigo = f.fcf_tpveiculo_codigo))
    Loop
                  
        tpFrete.Fcf_Fretecar_Origem      := c_msg.glb_localidade_origem;
        tpFrete.Fcf_Fretecar_Destino     := c_msg.glb_localidade_destino;
        tpFrete.Fcf_Fretecar_Tpfrete     := 'LO';
        tpFrete.Fcf_Tpveiculo_Codigo     := c_msg.fcf_tpveiculo_codigo;
        tpFrete.Fcf_Tpcarga_Codigo       := '00';
        tpFrete.Fcf_Fretecar_Valor       := c_msg.cad_frete_vlraprovado;
        tpFrete.Fcf_Fretecar_Desinencia  := 'U';
        tpFrete.Fcf_Fretecar_Vigencia    := trunc(sysdate);
        tpFrete.Usu_Usuario_Cadastro     := 'jsantos';
        tpFrete.Usu_Usuario_Alterou      := null;
        tpFrete.Fcf_Fretecar_Dtcadastro  := sysdate;
        tpFrete.Fcf_Fretecar_Dtalteracao := null;
        tpFrete.Fcf_Fretecar_Pedagio     := 0;
        tpFrete.Fcf_Fretecar_Altpedagio  := null;
        tpFrete.Usu_Usuario_Codigo       := c_msg.usu_usuario_codigo;
        tpFrete.Fcf_Fretecar_Km          := c_msg.cad_frete_km;
        tpFrete.Fcf_Fretecar_Origemi     := null;
        tpFrete.Fcf_Fretecar_Destinoi    := null;
        tpFrete.Fcf_Fretecar_Rowid       := null;
        tpFrete.Fcf_Fretecar_Pednofrete  := 'N';
        select count(*),
         max(p.slf_percurso_km)
        into vAuxiliar,
         tpFrete.Fcf_Fretecar_Km
        from tdvadm.t_slf_percurso p
        where p.glb_localidade_codigoorigem = tpFrete.Fcf_Fretecar_Origem
        and p.glb_localidade_codigodestino = tpFrete.Fcf_Fretecar_Destino;
        If vAuxiliar = 0 Then
        tdvadm.pkg_slf_percurso.Sp_slf_CadastraPercurso2(tpFrete.Fcf_Fretecar_Origem,tpFrete.Fcf_Fretecar_Destino);
        End If;
        If nvl(tpFrete.Fcf_Fretecar_Km,0) = 0 Then
        Begin
            select p.slf_percurso_km
              into tpFrete.Fcf_Fretecar_Km
            from tdvadm.t_slf_percurso p
            where p.glb_localidade_codigoorigem = tpFrete.Fcf_Fretecar_Origem
              and p.glb_localidade_codigodestino = tpFrete.Fcf_Fretecar_Destino;
        exception
          When NO_DATA_FOUND Then
              tpFrete.Fcf_Fretecar_Km := 0;
          When OTHERS Then
              tpFrete.Fcf_Fretecar_Km := 0;
          End;
        End If;
        If ( nvl(tpFrete.Fcf_Fretecar_Km,0) > 0 ) and ( vAuxiliar > 0 ) Then
        insert into tdvadm.t_fcf_fretecar values tpFrete;
        commit;
        End If;
    End Loop;
    -- 'ALTERAÇAO VF'
    For c_msg in (select f.fcf_solveic_cod,
                           sv.fcf_veiculodisp_codigo,
                           sv.fcf_veiculodisp_sequencia,
                           sv.fcf_solveic_valorfrete,
                           f.cad_frete_vlraprovado,
                           f.cad_frete_codigo,
                           f.cad_frete_data,
                           f.cad_frete_novovalor_ajudante 
                    from tdvadm.t_cad_frete f,
                         tdvadm.t_fcf_solveic sv
                    where 0 = 0
--                      and f.fcf_fretecar_rowid is null
                      and f.cad_frete_data >= sysdate - 2
                      and f.cad_frete_solicitacao = 'ALTERAÇAO VF'
                      and f.cad_frete_status = 'AP'
                      and f.fcf_solveic_cod = sv.fcf_solveic_cod
                      and 0 < (select count(*)
                               from tdvadm.t_fcf_solveic sv1
                               where sv1.fcf_solveic_cod = sv.fcf_solveic_cod
                                 and nvl(sv1.fcf_solveic_acrescimo,0) = 0)
                      and 0 = (select count(*)
                               from tdvadm.t_con_valefrete vf
                               where vf.fcf_veiculodisp_codigo = sv.fcf_veiculodisp_codigo
                                 and vf.fcf_veiculodisp_sequencia = sv.fcf_veiculodisp_sequencia))
      loop
         
          update tdvadm.t_fcf_solveic sv
            set sv.fcf_solveic_acrescimo = c_msg.cad_frete_vlraprovado - c_msg.fcf_solveic_valorfrete
          where sv.fcf_solveic_cod = c_msg.fcf_solveic_cod;
          vAuxiliar := sql%rowcount;
          If c_msg.fcf_veiculodisp_codigo is not null Then
              update tdvadm.t_fcf_veiculodisp vd
               set vd.fcf_veiculodisp_acrescimo  = c_msg.cad_frete_vlraprovado - c_msg.fcf_solveic_valorfrete
              where vd.fcf_veiculodisp_codigo = c_msg.fcf_veiculodisp_codigo
               and vd.fcf_veiculodisp_sequencia = c_msg.fcf_veiculodisp_sequencia;
             vAuxiliar := sql%rowcount;
          End If;
          
          -- Thiago - 29/12/2020 - Inclusão de acréscimo na fretecarmemo
		      update tdvadm.t_fcf_fretecarmemo m
		        set m.fcf_fretecarmemo_acrescimo = c_msg.cad_frete_vlraprovado - c_msg.fcf_solveic_valorfrete,
                m.fcf_fretecarmemo_dtcadfrete = nvl(c_msg.cad_frete_data, '01/01/1900'),
                m.fcf_fretecarmemo_ajudante = c_msg.cad_frete_novovalor_ajudante,
                m.cad_frete_codigo = c_msg.cad_frete_codigo
		      where m.fcf_solveic_cod = c_msg.fcf_solveic_cod; 
            
          commit; 
    End Loop;
    
    
    tdvadm.pkg_slf_percurso.SP_ATU_PEDAGIOPERNOVO;

end sp_cad_permesa;   
   

end pkg_slf_percurso;
/
