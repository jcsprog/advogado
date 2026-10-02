#Include "minigui.ch"

Function BACKUPJCS
PARAMETERS LIBERA
LiberacaoGSK(LIBERA)
if adm==0
   MSGINFO("Sem Liberação de Modulos")
   return
endif
DEFINE WINDOW bkGSK;
          AT 0,0 ;
    		 WIDTH 400		;
          HEIGHT 320    ;
	       TITLE "Backup Sistema GSK";
			 ICON "TUTOR";
			 modal  ;
			 FONT 'ARIAL' SIZE 11 
				 
             @ 020,010 LABEL TXT_1;
                       VALUE "Arquivo " ;
                       WIDTH 100    ;
                       HEIGHT 30           

        	    @ 100,031 LABEL TXT_3;
                       VALUE "P  R  O  C  E  S  S  O";
                       WIDTH 350           ;
                       HEIGHT 30           
                      
             @ 020,070 TEXTBOX VNBASE;
                       OF bkGSK;
                       WIDTH 300  
                       
        		 @ 115,031 PROGRESSBAR Progress_1 ;
			            RANGE 0,100 ;
			            WIDTH 300 HEIGHT 26 ;
		 	            TOOLTIP "ProgressBar" 

		       @ 150,155 TEXTBOX TextBox_1 ;
		            	VALUE " 50 %" WIDTH 60 MAXLENGTH 5

		       @ 180,80 SLIDER Slider_1 ;
			            RANGE 0,100 VALUE 50 ;
			            WIDTH 200 HEIGHT 40 ;
			            ON CHANGE {||Bk_Slider_Change()}

             @ 240,100 BUTTON Btn_Salva Of bkGSK  ;
                       CAPTION '&Confirma'             ;
                       ACTION Fbackup() ;
                       WIDTH 080 HEIGHT 25         ;
                       TOOLTIP "Confirma Geração de Backup" ;
                    FLAT

             @ 240,220 BUTTON Btn_Cancela Of bkGSK  ;
                       CAPTION '&Cancelar'		;
                       ACTION bkGSK.RELEASE    ;
	 	                 WIDTH 080 HEIGHT 25		;
                       TOOLTIP "Cancelar Operação"	;
			          FLAT
			 
	END WINDOW

	bkGSK.Progress_1.Value := 50

	bkGSK.Progress_1.BackColor := BLUE
	bkGSK.Progress_1.ForeColor := YELLOW
	bkGSK.TextBox_1.Enabled := .F.
				
	CENTER WINDOW bkGSK

	ACTIVATE WINDOW bkGSK

RETURN
*************************************
PROCEDURE AbrbkGSK
*************************************
bkGSK.VNBASE.ENABLED:=.T.
bkGSK.VINDIC.ENABLED:=.T.
bkGSK.VNBASE.VALUE:='Arquivo de Dados'
bkGSK.VINDIC.VALUE:='bkGSKs'
RETURN NIL

*************************************
PROCEDURE Fbackup
*************************************
Local j
local qteArq:=adir("*.*")
Local a_Arquivos:=array(qteArq)
local c_arq:=""
local c_env:=""
local npos:=60                                                
local _Destino :="\bck"+strtran(dtoc(date()),"/")

dbcloseall()

adir("*.*",a_Arquivos)

j := GetFolder("Selecione a Pasta Envio do Backup")

// criando diretorio
//!md j+_Destino

if !empty(j)
   for i=1 to qteArq
       c_arq:=a_Arquivos[i]
       c_env:=j+"\"+c_arq

       bkGSK.VNBASE.value:=c_arq       
       copy file &c_arq to &c_env

       OnbkStart()
    
   Next
   msginfo("Backup Realizado Com Exito! ")
   dbcloseall()
   bkGSK.RELEASE
   SENHA()
   //quit
endif   
Return Nil

Function OnbkStart

	Local n, nValue, aPos

	SetWaitCursor( _HMG_MainHandle )
	SetWaitCursor( GetControlHandle( 'Btn_Salva' , 'bkGSK' ) )
	SetWaitCursor( GetControlHandle( 'Progress_1' , 'bkGSK' ) )
	SetWaitCursor( GetControlHandle( 'TextBox_1' , 'bkGSK' ) )
	SetWaitCursor( GetControlHandle( 'Slider_1' , 'bkGSK' ) )

	aPos := GetCursorPos()
	SetCursorPos( aPos[2] , aPos[1] )   // update cursor shape

	For n := 1 To 10000
		nValue := Int( n / 100)

		n := n+2
		
		bkGSK.Progress_1.Value := nValue
		bkGSK.TextBox_1.Value := Str(nValue,3)+" %"
		bkGSK.Slider_1.Value := nValue
		If n%500 == 0
			DO EVENTS
		EndIf
	Next

	SetArrowCursor( _HMG_MainHandle )
	SetArrowCursor( GetControlHandle( 'Btn_Salva' , 'bkGSK' ) )
	SetArrowCursor( GetControlHandle( 'Progress_1' , 'bkGSK' ) )
	SetArrowCursor( GetControlHandle( 'TextBox_1' , 'bkGSK' ) )
	SetArrowCursor( GetControlHandle( 'Slider_1' , 'bkGSK' ) )

	aPos := GetCursorPos()
	SetCursorPos( aPos[2] , aPos[1] )   // update cursor shape

Return Nil

Function Bk_Slider_Change

	Local nValue := bkGSK.Slider_1.Value

	bkGSK.TextBox_1.Value := Str(nValue,3)+" %"

	bkGSK.Progress_1.Value := nValue

Return Nil
