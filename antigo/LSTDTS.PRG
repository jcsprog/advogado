*------------------------------------------------------------------------------*
Procedure LSTDTS
*------------------------------------------------------------------------------*
#include "winprint.ch"
PUBLIC PAG:=0,LH:=0,nopt:=0

PARAMETERS LIBERA

LiberacaoGSK(LIBERA)
if ADM==0
   MSGINFO("Sem Liberação de Modulos")
   return
endif

DEFINE WINDOW FRLF_2 ;
       AT 0,0			;
	    WIDTH 300		;
		 HEIGHT 170    ;
		 TITLE 'Relatorio de Processos';
		 MODAL
		                                     
       @ 10,10 LABEL L_opcao ;
                     VALUE 'Datas'    ;
                     WIDTH 80           
 
       @ 30,10 LISTBOX T_Opcao;
                OF FRLF_2 ;
                WIDTH 120 height 40  ;
					 items {"Programada","Fatal"}

       @ 10,150 LABEL Dtrel  ;
                     VALUE 'Data Informada';
                     WIDTH 120                     

       @ 30,150 DATEPICKER VDTF

       @ 110,50 BUTTON Btn_Salvar OF FRLF_2;
                       CAPTION '&Confirma'  ;
                       ACTION FRLDATAS(FRLF_2.T_OPCAO.VALUE,FRLF_2.VDTF.VALUE)   ;       
                       WIDTH 80 HEIGHT 27   ;
                       TOOLTIP "Confirma Impressão" ;
                    FLAT

       @ 110,170 BUTTON Btn_Cancelar OF FRLF_2;
		                 CAPTION '&Cancelar'		;
 			              ACTION FRLF_2.RELEASE		;       
 			              WIDTH 80 HEIGHT 27		;
		                 TOOLTIP "Cancelar Operação"	;
			           FLAT

	END WINDOW

   CENTER WINDOW FRLF_2

   ACTIVATE WINDOW FRLF_2
   
Return 

************************************
PROCEDURE FRLDATAS
PARAMETERS NOPT,DTF
************************************
Local dirimp:=GetCurrentFolder(), PAG, LIN

TITULOIMP:="RELATORIO DE PROCESSOS"
 
INIT PRINTSYS
IF HBPRNERROR > 0
   RETURN NIL
ENDIF
SET UNITS ROWCOL // MM ROWCOL
SELECT BY DIALOG PREVIEW

// Definição das fontes.
define font "ft06" name "times new roman" size 06
define font "ft10" name "times new roman" size 10
define font "ft12" name "times new roman" size 12 //bold=negrita
define font "ft14" name "times new roman" size 14
define font "ft18" name "times new roman" size 18

// Definição das Linhas.
define pen "p0" style PS_SOLID width 1 color 0x000000
define pen "p1" style PS_DOT width 1 color 0xFF0000
define pen "p2" style PS_NULL

set page orientation DMORIENT_LANDSCAPE papersize DMPAPER_LEGAL font "ft10"
start doc name TituloImp
start page
   
PAG:=0
LH:=0

select pen "p0"
IF NOPT = 1
 	PROCES->(DBSETORDER(2))
   SET SOFTSEEK ON
   PROCES->(DBSEEK(DTOS(DTF)))
   SET SOFTSEEK OFF
   DO WHILE PROCES->(!EOF()) .AND. PROCES->DTPROGRAM = DTF
      IMPDT()
      PROCES->(DBSKIP())
   ENDDO   	
ELSE
	PROCES->(DBSETORDER(3))
   SET SOFTSEEK ON
   PROCES->(DBSEEK(DTOS(DTF)))
   SET SOFTSEEK OFF
   DO WHILE PROCES->(!EOF()) .AND. PROCES->DTFATAL = DTF
      IMPDT()
      PROCES->(DBSKIP())
   ENDDO   	
ENDIF	
end page
end doc
release printsys
SetCurrentFolder(dirimp)
FRLF_2.RELEASE		      
RETURN NIL

*******************************
PROCEDURE IMPDT
*******************************
   IF LH > 48 .OR. PAG=0
      IF PAG<>0
         end page
         start page
      ENDIF
      PAG++
      LH:=1
      select font "ft14"
      @ LH,01 SAY EMP->DESCR+SPACE(20)+DTOC(DATE()) TO PRINT
      LH+=2
      @ ++LH,01 SAY "Relatorio de Processos" TO PRINT
      LH++
      IF NOPT>0
         LH++
         @ ++LH,01 SAY "Referente Data "+IF(NOPT=1,"Programada :","Fatal :")+DTOC(FRLF_2.VDTF.VALUE) TO PRINT
   	   LH++
   	ENDIF   
      select font "ft10"

      @ LH,00,LH+1,17 RECTANGLE
      @ LH,17,LH+1,26 RECTANGLE
      @ LH,26,LH+1,56 RECTANGLE
      @ LH,56,LH+1,96 RECTANGLE
      @ LH,96,LH+1,116 RECTANGLE
      @ LH,116,LH+1,144 RECTANGLE
      @ LH,144,LH+1,159 RECTANGLE
      @ LH,159,LH+1,174 RECTANGLE
      @ LH,174,LH+1,189 RECTANGLE
      @ LH,189,LH+1,200 RECTANGLE
      @ LH,200,LH+1,220 RECTANGLE

      @ LH,01 SAY "Dt.Solicitação" TO PRINT
	   @ LH,18 SAY "Unid." TO PRINT
      @ LH,27 SAY "Nº Processo" TO PRINT
      @ LH,57 SAY "Nome do Cliente" TO PRINT
      @ LH,97 SAY "Nº CPF " TO PRINT
      @ LH,117 SAY "Comarca" TO PRINT
      @ LH,145 SAY "Programada" TO PRINT
      @ LH,160 SAY "Data Fatal" TO PRINT
      @ LH,175 SAY "Solic.Cliente" TO PRINT
      @ LH,190 SAY "Solic." TO PRINT
      @ LH,201 SAY "F.Solicitação" TO PRINT
		LH++
	Else
      @ LH,00,LH+1,17 RECTANGLE
      @ LH,17,LH+1,26 RECTANGLE
      @ LH,26,LH+1,56 RECTANGLE
      @ LH,56,LH+1,96 RECTANGLE
      @ LH,96,LH+1,116 RECTANGLE
      @ LH,116,LH+1,144 RECTANGLE
      @ LH,144,LH+1,159 RECTANGLE
      @ LH,159,LH+1,174 RECTANGLE
      @ LH,174,LH+1,189 RECTANGLE
      @ LH,189,LH+1,200 RECTANGLE
      @ LH,200,LH+1,220 RECTANGLE

      @ LH,01 SAY "Dt.Solicitação" TO PRINT
	   @ LH,18 SAY "Unid." TO PRINT
      @ LH,27 SAY "Nº Processo" TO PRINT
      @ LH,57 SAY "Nome do Cliente" TO PRINT
      @ LH,97 SAY "Nº CPF " TO PRINT
      @ LH,117 SAY "Comarca" TO PRINT
      @ LH,145 SAY "Programada" TO PRINT
      @ LH,160 SAY "Data Fatal" TO PRINT
      @ LH,175 SAY "Solic.Cliente" TO PRINT
      @ LH,190 SAY "Solic." TO PRINT
      @ LH,201 SAY "F.Solicitação" TO PRINT
		LH++
	ENDIF	 

   @ LH,00,LH+1,17 RECTANGLE
   @ LH,17,LH+1,26 RECTANGLE
   @ LH,26,LH+1,56 RECTANGLE
   @ LH,56,LH+1,96 RECTANGLE
   @ LH,96,LH+1,116 RECTANGLE
   @ LH,116,LH+1,144 RECTANGLE
   @ LH,144,LH+1,159 RECTANGLE
   @ LH,159,LH+1,174 RECTANGLE
   @ LH,174,LH+1,189 RECTANGLE
   @ LH,189,LH+1,200 RECTANGLE
   @ LH,200,LH+1,220 RECTANGLE

   @ LH,01 SAY PROCES->DTSOLIC TO PRINT
	@ LH,18 SAY IF(UNID->(DBSEEK(STR(PROCES->UNIDADE,5))),UNID->DSUNI,SPACE(05)) TO PRINT
   @ LH,27 SAY PROCES->NPROCE TO PRINT
   @ LH,57 SAY PROCES->NOME TO PRINT
   @ LH,97 SAY PROCES->CPF TO PRINT
   @ LH,117 SAY PROCES->COMARCA TO PRINT
   @ LH,145 SAY PROCES->DTPROGRAM TO PRINT
   @ LH,160 SAY PROCES->DTFATAL TO PRINT
   @ LH,175 SAY PROCES->DTSOLCLI TO PRINT
   @ LH,190 SAY PROCES->SOLICIT TO PRINT
  	FSL->(DBSETORDER(1))
   @ LH,201 SAY IF(FSL->(DBSEEK(STR(PROCES->FORMA,5))),FSL->DSFORM,SPACE(05)) TO PRINT

   LH+=2
   CTRP->(DBSETORDER(1))
   CTRP->(DBGOTOP())
   IF CTRP->(DbSeek(PROCES->CPF))
      @ LH,17,LH+1,56 RECTANGLE
      @ LH,56,LH+1,96 RECTANGLE
      @ LH,96,LH+1,116 RECTANGLE
      @ LH,116,LH+1,144 RECTANGLE
      @ LH,144,LH+1,159 RECTANGLE
      @ LH,159,LH+1,174 RECTANGLE

      @ LH,18 SAY "Empresa" TO PRINT
      @ LH,57 SAY "Contrato" TO PRINT
      @ LH,97 SAY "Data Recebimento" TO PRINT
      @ LH,117 SAY "Forma Recebimento" TO PRINT
      @ LH,145 SAY "Data Envio" TO PRINT
      @ LH,160 SAY "Data Reenvio" TO PRINT
		LH++
      Do While CTRP->(!EOF()) .AND. CTRP->CPF = PROCES->CPF
         @ LH,17,LH+1,56 RECTANGLE
         @ LH,56,LH+1,96 RECTANGLE
         @ LH,96,LH+1,116 RECTANGLE
         @ LH,116,LH+1,144 RECTANGLE
         @ LH,144,LH+1,159 RECTANGLE
         @ LH,159,LH+1,174 RECTANGLE

			@ LH,18 SAY CTRP->EMPRESA TO PRINT
			@ LH,57 SAY CTRP->CONTRATO TO PRINT
         @ LH,97 SAY CTRP->DTRECEB
       	FRMR->(DBSETORDER(1))
         @ LH,117 SAY IF(FRMR->(DBSEEK(STR(CTRP->FORMARC,5))),FRMR->NOMEREC,SPACE(05)) TO PRINT
      	@ LH,145 SAY CTRP->DTENVIO TO PRINT
         @ LH,160 SAY CTRP->DTREENV TO PRINT
         LH++
         CTRP->(DBSKIP())
		ENDDO
   ENDIF
	LH++
RETURN 