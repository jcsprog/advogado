#include "winprint.ch"
*------------------------------------------------------------------------------*
Procedure LSTGRL
*------------------------------------------------------------------------------*
Local dirimp:=GetCurrentFolder()

PARAMETERS LIBERA

LiberacaoGSK(LIBERA)
if ADM==0
   MSGINFO("Sem Liberação de Modulos")
   return
endif

If MsgYesNo ('Confirma Impressão ?','Relatório')

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
  PROCES->(DBSETORDER(1))
  DO WHILE PROCES->(!EOF()) 
      IMPDT()
      PROCES->(DBSKIP())
  ENDDO   	

  end page
  end doc
  release printsys
  SetCurrentFolder(dirimp)
endif  
RETURN NIL

 