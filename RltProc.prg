#Include "minigui.ch"

*------------------------------------------------------------------------------*
Procedure ImpProc()
*------------------------------------------------------------------------------*
local nOption:=0
local buscar:=space(35)
Local dirimp:=GetCurrentFolder()
Request HB_CODEPAGE_PT850

PARAMETERS LIBERA

LiberacaoGSK(LIBERA)
if ADM==0
   MSGINFO("Sem Liberação de Modulos")
   return
endif

nOption:=MsgOptions("Selecione","Opções de Impressão","Users",{"&Sintecico","&Analitico","Cancela"},1,30,60)

do case
   case nOption==3
        RETURN NIL  
   case nOption==1 
   	  PRC->(DBGOTOP())
	
	     DO REPORT								;
		  TITLE EMPRESA+'| Cadastro de Processos'	;
              HEADERS  {'','','','','',''} , {'N.Processo','Cpf/Cnpj','Cliente/Razão Social','Forum','Vara'};
              FIELDS   {'PRC->NPROCE','PRC->CPF','if(CLI->(dbseek(PRC->CPF)),CLI->DESCR,"")','PRC->FORUM','PRC->VARA'};
		  WIDTHS   {35,15,15,10,10} 		;
		  TOTALS   {.F.,.F.,.F.,.F.,.F.};
		  WORKAREA PRC		;
		  LPP 50								;
		  CPL 80								;
		  LMARGIN 5							;
		  PREVIEW ;							
        LANDSCAPE
	     Select PRC
												
   case nOption==2

        Buscar := Upper ( AllTrim ( InputBox( 'Informe N.Processo' , 'Para Impressão' ) ) )
        
        PRC->(DBSETORDER(1))
 	     if .not. prc->(dbseek(buscar))  
 	        msgbox(buscar,len(buscar))
		     msginfo("Não Encontrado Processo! Verifique")
		     return nil
		  endif
		   
        IF nOption == 2             
								 
           TITULOIMP:="Rl. Analitico Processos"

           PAG:=0                          
           Lh:=0                           
 
           INIT PRINTSYS
           SELECT BY DIALOG PREVIEW

           IF HBPRNERROR>0
              release printsys
              SetCurrentFolder(dirimp)
              return nil
           ENDIF

           HB_SETCODEPAGE( "PT850" )

           SET UNITS MM
           // Definição das fontes.
           define font "ft08" name "times new roman" size 08
           define font "ft10" name "times new roman" size 10
           define font "ft12" name "times new roman" size 12 //bold=negrita
           define font "ft14" name "times new roman" size 14
           define font "ft18" name "times new roman" size 18

           // Definição das Linhas.
           define pen "p0" style PS_SOLID width 1 color 0x000000
           define pen "p1" style PS_DOT width 1 color 0xFF0000
           define pen "p2" style PS_NULL

           //set page orientation DMORIENT_PORTRAIT papersize DMPAPER_A4 font "ft10"
           set page orientation DMORIENT_LANDSCAPE papersize DMPAPER_A4 font "ft10"
           start doc name TituloImp
           start page
   
           PAG:=0                      
           LH:=0                       

           select font "ft12"
           select pen "p0"                                    
        	  DO WHILE PRC->(!EOF())  
              V_NPROCE:=PRC->NPROCE 
              V_CPF:=PRC->CPF       
		   
              IF LH > 260 .OR. PAG=0
                 IF PAG<>0
                    end page
                    start page
                 ENDIF
                 PAG++
                 LH:=10
                 select font "ft14"
                 @ LH,05 SAY EMPRESA TO PRINT
                 LH+=10
                 @ LH,55 SAY "Analitico do Processo" TO PRINT 
                 select font "ft12"
 	              LH+=10
                 @ LH,05 SAY "Processo  :"+V_NPROCE TO PRINT
		           @ LH,65 SAY "Cpf/Cgc :"+V_CPF TO PRINT
		           LH+=5
		           @ LH,05 SAY "Nome      :" + if(CLI->(dbseek(V_CPF)),CLI->DESCR,"") TO PRINT
		           LH+=5
		           @ LH,05 SAY "Forum     :" + PRC->FORUM to print
		           lh+=5
		           @ LH,05 SAY "Vara      :" + PRC->VARA to print
		           lh+=5
		           @ lh,05 say "Descrição :" + PRC->DESCRICAO to print
                 LH+=5
                 @ LH,05 say replic("=",90) to print
                 lh+=5
              ENDIF

				  if CTRP->(Dbseek(PRC->NPROCE))
                 select font "ft14"
                 @ LH,05 SAY "Pagamentos" TO PRINT
                 select font "ft12"
                 LH+=5
                 @ LH,005 SAY "Valor Total R$ " + TRANSFORM(CTRP->NVLT,"@E 999,999.99") TO PRINT
                 @ LH,051 SAY "Entrada : " + IF(CTRP->ENTRADA=="1","Sim","Não") TO PRINT
                 @ LH,080 SAY "R$ Entrada" + TRANSFORM(CTRP->NVLENTRA,"@E 999,999.99") TO PRINT
                 LH+=5
                 if CTRP->NQTP>0
                    @ LH,04,LH+5,20 RECTANGLE
                    @ LH,20,LH+5,59 RECTANGLE
                    @ LH,59,LH+5,90 RECTANGLE
                    @ lh,05 say "Parcela" to print
                    @ lh,21 say "Dt.Pagamento" to print
                    @ lh,60 say "R$ Parcela " to print
                    lh+=5
                    if LANP->(DBSEEK(PRC->NPROCE))
                       do while LANP->(!EOF()) .and. LANP->NPROCE==PRC->NPROCE
                          @ LH,04,LH+5,20 RECTANGLE
                          @ LH,20,LH+5,59 RECTANGLE
                          @ LH,59,LH+5,90 RECTANGLE
                          @ lh,05 say STRZERO(LANP->NPARC,3) to print
                          @ lh,26 say dtoc(LANP->DTPGTO) to print
                          @ lh,66 say TRANSFORM(LANP->NVLPC,"@E 999,999.99") to print
                          lh+=5
		                    LANP->(dBskip())
                       enddo
                    endif
                 endif  
				  endif
				
				  LH+=10
				  	  
				  IF AND->(DBSEEK(PRC->NPROCE))
                 select font "ft14"
                 @ LH,05 SAY "Andamentos" TO PRINT
                 select font "ft12"
                 lh+=5
                 @ LH,04,LH+5,30 RECTANGLE
                 @ LH,30,LH+5,120 RECTANGLE
                 @ LH,120,LH+5,210 RECTANGLE
                 @ LH,210,LH+5,290 RECTANGLE
                 //@ LH,240,LH+5,300 RECTANGLE
                 @ lh,05 say "Dt.Andamento" to print
                 @ lh,31 say "Obs (1)" to print
                 @ lh,121 say "Obs (2)" to print
                 @ lh,211 say "Obs (3)" to print
                 //@ lh,241 say "Obs (4)" to print
                 lh+=5

                 do while AND->(!EOF()) .and. AND->NPROCE==PRC->NPROCE

                    @ LH,04,LH+5,30 RECTANGLE
                    @ LH,30,LH+5,120 RECTANGLE
                    @ LH,120,LH+5,210 RECTANGLE
                    @ LH,210,LH+5,290 RECTANGLE
                    //@ LH,240,LH+5,300 RECTANGLE
                       
				   	  @ lh,05 say dtoc(AND->DTANDA) to print
					     @ lh,31 say AND->AOBS1 to print
						  @ lh,121 say AND->AOBS2 to print
						  @ lh,211 say AND->AOBS3 to print
						  //@ lh,241 say AND->AOBS4 TO print
						  lh+=5          
		              AND->(dBskip())
                 enddo
              endif
               
				  LH+=10	
					  		
				  IF PRA->(DBSEEK(PRC->NPROCE))
                 select font "ft14"
                 @ LH,05 SAY "Prazos" TO PRINT
                 select font "ft12"
                 lh+=5
                 @ LH,04,LH+5,30 RECTANGLE
                 @ LH,30,LH+5,100 RECTANGLE
                 @ LH,100,LH+5,125 RECTANGLE
                 @ LH,125,LH+5,200 RECTANGLE
                 @ LH,200,LH+5,210 RECTANGLE
                 @ LH,210,LH+5,235 RECTANGLE
                 @ LH,235,LH+5,290 RECTANGLE
                      
				     @ lh,005 say "Dt.Publicação" to print
					  @ lh,031 say "Publicação" to print
					  @ lh,101 say "Dt.Fatal" to print
					  @ lh,126 say "Obs." to print
					  @ lh,201 say "RC" TO print
					  @ lh,211 say "Dt.Recurso" TO print
					  @ lh,236 say "Recurso" TO print
					  lh+=5          
                    
                 do while PRA->(!EOF()) .and. PRA->NPROCE==PRC->NPROCE
                    @ LH,04,LH+5,35 RECTANGLE
                    @ LH,30,LH+5,100 RECTANGLE
                    @ LH,100,LH+5,125 RECTANGLE
                    @ LH,125,LH+5,200 RECTANGLE
                    @ LH,200,LH+5,210 RECTANGLE
                    @ LH,210,LH+5,235 RECTANGLE
                    @ LH,235,LH+5,290 RECTANGLE
                 
                    @ lh,005 say dtoc(PRA->DTPUBLI) to print
						  @ lh,031 say PRA->PUBLICA to print 
						  @ lh,101 say dtoc(PRA->DTFATAL) to print
						  @ lh,126 say PRA->POBS1 to print 
						  @ lh,201 say if(PRA->RECURSO='1','Sim','Não') to print
						  @ lh,213 say dtoc(PRA->DTREC) to print
						  @ lh,236 say PRA->NRECURSO TO print     
						  lh+=5    
		              PRA->(dBskip())
   				  enddo
				  endif
              PRC->(DBskip())
           ENDDO
           end page
           end doc
           release printsys
           SetCurrentFolder(dirimp)
        endif   
endcase		         
RETURN NIL                   

Return  

*************************************************
******* Processos por periodos **.*.*.*.*.*.*.*.*
*************************************************
#Include "minigui.ch"

PROCEDURE LSTGTO
PARAMETERS tipo_rl,LIBERA
LiberacaoGSK(LIBERA)
if ADM==0
   MSGINFO("Sem Liberação de Modulos")
   return
endif

DEFINE WINDOW PRCIP_2 ;
       AT 0,0			;
	    WIDTH 300		;
		 HEIGHT 180    ;
		 TITLE 'Relatório de Pagamentos';
		 MODAL
		                                     
       @ 10,10 LABEL Dtinicio ;
                     VALUE 'Data Inicial'    ;
                     WIDTH 100           
 
       @ 10,150 LABEL Dtfinal  ;
                     VALUE 'Data Final'   ;
                     WIDTH 100                     

       @ 30,10 DATEPICKER VDTI                                   

       @ 30,150 DATEPICKER VDTF

       @ 80,50 BUTTON Btn_Salvar OF PRCIP_2;
                       CAPTION '&Confirma'             ;
                       ACTION (escolher_rel(tipo_rl) )        ;       
                       WIDTH 80 HEIGHT 27         ;
                       TOOLTIP "Confirma Impressão" ;
                    FLAT

       @ 80,170 BUTTON Btn_Cancelar OF PRCIP_2;
		                 CAPTION '&Cancelar'		;
 			              ACTION PRCIP_2.RELEASE		;       
 			              WIDTH 80 HEIGHT 27		;
		                 TOOLTIP "Cancelar Operação"	;
			           FLAT

	END WINDOW

   CENTER WINDOW PRCIP_2

   ACTIVATE WINDOW PRCIP_2
   
Return 

*------------------------------------------------------------------------------*
Procedure escolher_rel(tipo_rl)
*------------------------------------------------------------------------------*
Do case
   case tipo_rl==1
        PGTOLSTG()
   case tipo_rl==2
	     msgbox("Teste impressao 2")
Endcase
return
		      
PROCEDURE PGTOLSTG()
#include "winprint.ch"

Local dirimp:=GetCurrentFolder()
LOCAL VDTI:=PRCIP_2.VDTI.VALUE
LOCAL VDTF:=PRCIP_2.VDTF.VALUE
Local nOption:=1
PAG:=0
Lh:=0
Request HB_CODEPAGE_PT850

nOption:=MsgOptions("Selecione","Opções de Impressão","Users",{"&A Vencer","&Geral","Cancela"},1,30,60)

do case
   case nOption==3
        RETURN NIL  
   case nOption==1 // a vencer e nao pagos
        X_PGTO:="2"
   case nOption==2
        X_PGTO:="12"
endcase		         
 
LANP->(DBSETORDER(2))
								 
TITULOIMP:="Relatório de Pagamentos"
 
INIT PRINTSYS
SELECT BY DIALOG PREVIEW

IF HBPRNERROR>0
   release printsys
   SetCurrentFolder(dirimp)
   return nil
ENDIF

HB_SETCODEPAGE( "PT850" )

SET UNITS MM
// Definição das fontes.
define font "ft08" name "times new roman" size 08
define font "ft10" name "times new roman" size 10
define font "ft12" name "times new roman" size 12 //bold=negrita
define font "ft14" name "times new roman" size 14
define font "ft18" name "times new roman" size 18

// Definição das Linhas.
define pen "p0" style PS_SOLID width 1 color 0x000000
define pen "p1" style PS_DOT width 1 color 0xFF0000
define pen "p2" style PS_NULL

set page orientation DMORIENT_PORTRAIT papersize DMPAPER_A4 font "ft10"
//set page orientation DMORIENT_LANDSCAPE papersize DMPAPER_A4 font "ft10"
start doc name TituloImp
start page
   
PAG:=0
LH:=0

select font "ft12"
select pen "p0"
IF nOption == 1
	PRC->(DBGOTOP())
	DO WHILE PRC->(!EOF()) 
      V_NPROCE:=PRC->NPROCE
      V_CPF:=PRC->CPF
      A_PGTO:={}

		LANP->(DBGOTOP())
      SET SOFTSEEK ON
      LANP->(DBSEEK(V_NPROCE+DTOS(VDTI)))
      SET SOFTSEEK OFF
      DO WHILE LANP->(!EOF()) .and. LANP->NPROCE = V_NPROCE .and. DTOS(LANP->DTPGTO) <= DTOS(VDTF)
         
         IF LANP->NPROCE = V_NPROCE .and. DTOS(LANP->DTPGTO) >= DTOS(VDTI) .and. DTOS(LANP->DTPGTO) <= DTOS(VDTF) .and. LANP->CPGTO $ X_PGTO 

            AADD(A_PGTO,{DTOC(LANP->DTPGTO),STR(LANP->NPARC,03),TRANSFORM(LANP->NVLPC,"@E 999,999.99"),if(LANP->CPGTO="1","Sim","Não")})
            
         ENDIF
         LANP->(DBSKIP())
      ENDDO

		IF LEN(A_PGTO)>0
		
         IF LH > 260 .OR. PAG=0
            IF PAG<>0
               end page
               start page
            ENDIF
            PAG++
            LH:=10
            select font "ft14"
            @ LH,05 SAY EMPRESA TO PRINT
            LH+=10
            @ LH,70 SAY "Relatorio de Pagamentos" TO PRINT
	         LH+=10
	    	   @ LH,05 SAY "Periodo de :"+dtoc(vdti)+" a "+dtoc(vdtf) TO PRINT 
            select font "ft12"
            LH+=10
         ENDIF

         @ LH,05 SAY "Processo :"+V_NPROCE TO PRINT
		   @ LH,55 SAY "Cpf/Cgc :"+V_CPF TO PRINT
		   LH+=5
		   @ LH,05 SAY "Nome :"+if(CLI->(dbseek(V_CPF)),CLI->DESCR,"") TO PRINT
         LH+=5

         @ LH,04,LH+5,50 RECTANGLE
         @ LH,50,LH+5,79 RECTANGLE
         @ LH,79,LH+5,109 RECTANGLE
         @ LH,109,LH+5,135 RECTANGLE
     
         @ LH,05 SAY "Data Pgto" TO PRINT
         @ LH,51 SAY "Parcela" TO PRINT
         @ LH,80 SAY "R$ Valor" TO PRINT
         @ LH,110 SAY "Pgto(s/N)" TO PRINT
		
		   LH+=5
		   FOR X:=1 TO LEN(A_PGTO)
             @ LH,04,LH+5,50 RECTANGLE
             @ LH,50,LH+5,79 RECTANGLE
             @ LH,79,LH+5,109 RECTANGLE
             @ LH,109,LH+5,135 RECTANGLE

             @ LH,05 SAY A_PGTO[X][1] TO PRINT
             @ LH,51 SAY A_PGTO[X][2] TO PRINT
             @ LH,80 SAY A_PGTO[X][3] TO PRINT
             @ LH,110 SAY A_PGTO[X][4] TO PRINT
		  	    LH+=5   
          NEXT
       
          LH+=5
       ENDIF   
       PRC->(DBskip())
   ENDDO
endif
end page
end doc
release printsys
SetCurrentFolder(dirimp)
PRCIP_2.BTN_SALVAR.ENABLED:=.T.
PRCIP_2.RELEASE
LANP->(DBSETORDER(1))
RETURN NIL                   