#Include "minigui.ch"

PROCEDURE REORGANIZA
PARAMETERS LIBERA
*/*
LiberacaoGSK(LIBERA)
if adm==0
   MSGINFO("Sem Liberação de Modulos")
   return
endif
**/
T01:=[S]
DEFINE WINDOW INDICE;
          AT 0,0 ;
    		 WIDTH 400		;
          HEIGHT 320    ;
	       TITLE 'Reorganização de Arquivos';
			 ICON "TUTOR";
			 MODAL  ;
			 FONT 'ARIAL' SIZE 11 ;
			 ON INIT ( AbrIndice() ) 
				 
             @ 020,010 LABEL TXT_1;
                       VALUE "Arquivo " ;
                       WIDTH 100    ;
                       HEIGHT 30           
	      	   	       	 								
        	    @ 060,010 LABEL TXT_2;
                       VALUE "Indice ";
                       WIDTH 100           ;
                       HEIGHT 30           

        	    @ 100,031 LABEL TXT_3;
                       VALUE "P  R  O  C  E  S  S  O";
                       WIDTH 350           ;
                       HEIGHT 30           
                       
             @ 020,070 TEXTBOX VNBASE;
                       OF INDICE;
                       WIDTH 300  
                       
             @ 060,070 TEXTBOX VINDIC ;
                       OF INDICE ;
                       WIDTH 150   

        		 @ 115,031 PROGRESSBAR Progress_1 ;
			            RANGE 0,100 ;
			            WIDTH 300 HEIGHT 26 ;
		 	            TOOLTIP "ProgressBar" 

		       @ 150,155 TEXTBOX TextBox_1 ;
		            	VALUE " 50 %" WIDTH 60 MAXLENGTH 5

		       @ 180,80 SLIDER Slider_1 ;
			            RANGE 0,100 VALUE 50 ;
			            WIDTH 200 HEIGHT 40 ;
			            ON CHANGE {||Slider_Change()}

             @ 240,100 BUTTON Btn_Salva Of indice  ;
                       CAPTION '&Confirma'             ;
                       ACTION FReorganiza() ;
                       WIDTH 080 HEIGHT 25         ;
                       TOOLTIP "Confirma Reorganização" ;
                    FLAT

             @ 240,220 BUTTON Btn_Cancela Of indice  ;
                       CAPTION '&Cancelar'		;
                       ACTION INDICE.RELEASE    ;
	 	                 WIDTH 080 HEIGHT 25		;
                       TOOLTIP "Cancelar Operação"	;
			          FLAT
			 
	END WINDOW

	INDICE.Progress_1.Value := 50

	INDICE.Progress_1.BackColor := BLUE
	INDICE.Progress_1.ForeColor := YELLOW
	INDICE.TextBox_1.Enabled := .F.
				
	CENTER WINDOW INDICE

	ACTIVATE WINDOW INDICE

RETURN
*************************************
PROCEDURE AbrIndice
*************************************
INDICE.VNBASE.ENABLED:=.T.
INDICE.VINDIC.ENABLED:=.T.
INDICE.VNBASE.VALUE:='Arquivo de Dados'
INDICE.VINDIC.VALUE:='Indices'
RETURN NIL

*************************************
PROCEDURE FReorganiza
*************************************

DBCLOSEALL()
CAMPOSID:={}

USE LANINDI ALIAS LIND INDEX IDLINDC NEW SHARED
USE INDICES ALIAS IDC INDEX IDINDIC NEW SHARED
IDC->(DBGOTOP())
DO WHILE IDC->(!EOF())
	IF LIND->(DBSEEK(STR(IDC->COD,5)))
      Do While LIND->(!EOF()) .AND. STR(LIND->COD,5) = STR(IDC->COD,5)
      	AADD(CAMPOSID,IDC->BASE+"|"+IDC->NBASE+"|"+LIND->NINDE+"|"+LIND->NCHAV)
      	LIND->(DBSKIP())
      ENDDO 	
   ENDIF	
   IDC->(DBSKIP())
ENDDO
DBCLOSEALL()
	
FOR J:=1 TO LEN(CAMPOSID)
	
    VQBASE:=ALLTRIM(SUBSTR(CAMPOSID[J],1,15)) 
    INDICE.VNBASE.VALUE:=ALLTRIM(SUBSTR(CAMPOSID[J],17,40)) // NOME DO ARQUIVO QUE APARECE NA TELA
    INDICE.VINDIC.VALUE:=ALLTRIM(SUBSTR(CAMPOSID[J],58,15)) // NOME DO INDICE A SER CRIADO
 	 VCHAVE:=ALLTRIM(SUBSTR(CAMPOSID[J],74,60)) // NOME DA CHAVE DE INDEX
    VINDIC:=ALLTRIM(SUBSTR(CAMPOSID[J],58,15)) // NOME DO INDICE A SER CRIADO

    IF OPAQ(VQBASE,1)
	 	 INDEX ON &VCHAVE TO &VINDIC
		 USE
		 OnStart()
	 ENDIF

NEXT   
MSGINFO("Reorganização Com Exito","Informação")
INDICE.RELEASE
senha()
RETURN NIL
*/

Function OnStart

	Local n, nValue, aPos

	SetWaitCursor( _HMG_MainHandle )
	SetWaitCursor( GetControlHandle( 'Btn_Salva' , 'INDICE' ) )
	SetWaitCursor( GetControlHandle( 'Progress_1' , 'INDICE' ) )
	SetWaitCursor( GetControlHandle( 'TextBox_1' , 'INDICE' ) )
	SetWaitCursor( GetControlHandle( 'Slider_1' , 'INDICE' ) )

	aPos := GetCursorPos()
	SetCursorPos( aPos[2] , aPos[1] )   // update cursor shape

	For n := 1 To 10000
		nValue := Int( n / 100)

		n := n+2
		
		INDICE.Progress_1.Value := nValue
		INDICE.TextBox_1.Value := Str(nValue,3)+" %"
		INDICE.Slider_1.Value := nValue
		If n%500 == 0
			DO EVENTS
		EndIf
	Next

	SetArrowCursor( _HMG_MainHandle )
	SetArrowCursor( GetControlHandle( 'Btn_Salva' , 'INDICE' ) )
	SetArrowCursor( GetControlHandle( 'Progress_1' , 'INDICE' ) )
	SetArrowCursor( GetControlHandle( 'TextBox_1' , 'INDICE' ) )
	SetArrowCursor( GetControlHandle( 'Slider_1' , 'INDICE' ) )

	aPos := GetCursorPos()
	SetCursorPos( aPos[2] , aPos[1] )   // update cursor shape

Return Nil

Function Slider_Change

	Local nValue := INDICE.Slider_1.Value

	INDICE.TextBox_1.Value := Str(nValue,3)+" %"

	INDICE.Progress_1.Value := nValue

Return Nil
