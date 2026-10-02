#include "MiniGUI.ch"

**** senhas -
FUNCTION SENHA

         VSenha    := SPACE(08)
			VUSUARIO  := SPACE(30)
         GG        := 0
         T01       := [N]
         
         DBCLOSEALL()
         USE JCSARQ ALIAS JCS INDEX IDJCS1 SHARED NEW

         DEFINE WINDOW Jcs_1 ;
	        	    AT 0,12 ;
                WIDTH 340  ;
                HEIGHT 220 ;
				    TITLE EMPRESA ;
	    			 ICON "CADEADO" ;
                MODAL NOSIZE NOSYSMENU ;
					 BACKCOLOR BLUE ;
	             ON INIT ( AbrirSenha()) 


///		 DEFINE BKGBRUSH newBrush PATTERN IN Jcs_1 BITMAP CIEC1.bmp
		
					 @ 10,08 LABEL Label_Usuario  ;
                        VALUE 'Usuario'      ;
                        WIDTH 60             ;
                        HEIGHT 	30          ;
						      FONT "Arial" SIZE 12;
					      	BACKCOLOR BLUE ;
                        FONTCOLOR WHITE BOLD

                @ 40,10 LABEL Label_Senha    ;
                        VALUE 'Senha'        ;
                        WIDTH 60             ;
                        HEIGHT 30            ;
					      	FONT "Arial" SIZE 12;
                        BACKCOLOR BLUE ;
                        FONTCOLOR WHITE BOLD

                @ 10,70 TEXTBOX T_Usuario    ;
                        OF Jcs_1       ;
                        WIDTH 200            ;
                        MAXLENGTH 30 ;
                        UPPERCASE  ;
                        TOOLTIP 'Nome do Usuario' 
						
				    @ 40,70 TEXTBOX T_SENHA	;
                        PASSWORD		;                         
                        FONT "Arial" SIZE 09	;             
                        TOOLTIP "Senha de Acesso";
      			         MAXLENGTH 05	;
			               UPPERCASE		;
			               ON ENTER VERIFICA_SENHA()	

               @ 090,50 LABEL T_ABRI  ;
                        VALUE 'Inicializando Arquivos Aguarde !!';
                        WIDTH 300   ;
                        HEIGHT 20   ;
					      	FONT "Arial" SIZE 13 ;
					      	BACKCOLOR BLUE ;
                        FONTCOLOR WHITE BOLD

          		@ 110,18 PROGRESSBAR Progress_1 ;
		                 RANGE 0,100 ;
               		  WIDTH 300 HEIGHT 23 ;
               		  TOOLTIP "ProgressBar"

               @ 150,080 BUTTON Btn_Salvar Of Jcs_1     ;
                         CAPTION 'Verifica'             ;
                         ACTION Verifica_Senha()       ;       
                         WIDTH 80 HEIGHT 25         ;
                         FONT "Arial" SIZE 09          ;
                         TOOLTIP "Verifica Senha" ;
                      FLAT

                @150,180 BUTTON Btn_Cancelar Of Jcs_1 ;
                         CAPTION '&Cancelar'		;
       		             ACTION  EXIT PROGRAM ;					     
                         WIDTH 80 HEIGHT 25		;
		                   FONT "Arial" SIZE 09		;
                         TOOLTIP "Cancela"	;
		                FLAT

	END WINDOW
	
	Jcs_1.Progress_1.Value := 30
	
   CENTER WINDOW Jcs_1

   ACTIVATE WINDOW Jcs_1
   
Return nil

**********************
PROCEDURE AbrirSenha
**********************
Jcs_1.T_Usuario.ENABLED:=.T.
Jcs_1.T_SENHA.ENABLED:=.T.
Jcs_1.T_Usuario.Value:=SPACE(30)
Jcs_1.T_SENHA.Value:=SPACE(08)
Jcs_1.T_Usuario.SETFOCUS
RETURN

FUNCTION Verifica_Senha

       LOCAL CTRSENHA:=0       
   
       IF JCS->(DBSEEK(UPPER(Jcs_1.T_Usuario.Value)))
          IF !ALLTRIM(JCS->SENHAU) == ALLTRIM(Jcs_1.T_SENHA.Value)
             MsgInfo ("Senha Nao Confere!")
             GG++
             CTRSENHA++
			 ENDIF
          IF !ALLTRIM(JCS->NOMEU) == ALLTRIM(UPPER(Jcs_1.T_Usuario.Value))
             MsgInfo ("Usuario Nao Confere!")
             GG++
             CTRSENHA++
          ENDIF   
          IF GG>3
             MsgInfo ("Sistema CANCELADO !!!!!")
             dbcloseall()
             EXIT PROGRAM 
          ENDIF   
          IF CTRSENHA == 0
             VUSUARIO:=JCS->NOMEU
             OPERA:=JCS->NOMEU
             ADM:=JCS->ADM
             CCLIEMP:=JCS->CLIEMP
             ABERTURA_ARQ()
             JCS_1.RELEASE
		    ENDIF
       ELSE
          gg++
          MsgInfo ("Usuario/Senha Nao Conferem!","Verifique") 
       ENDIF

RETURN NIL

PROCEDURE ABERTURA_ARQ
USE LANINDI ALIAS LIND INDEX IDLINDC NEW SHARED
USE INDICES ALIAS IDC INDEX IDINDIC NEW SHARED
IDC->(DBGOTOP())
Do While IDC->(!EOF())  
	ARQUIVO:=ALLTRIM(IDC->BASE)
  	APELIDO:=ALLTRIM(IDC->APELIDO)

   Use &ARQUIVO Alias &APELIDO new shared
	IF LIND->(DBSEEK(STR(IDC->COD,5)))
      Do While LIND->(!EOF()) .AND. STR(LIND->COD,5) = STR(IDC->COD,5)
	      INDICE :=ALLTRIM(LIND->NINDE)
         &APELIDO->(DBSetIndex( '&INDICE')) 
         IF T01="S"
            OnAbrea()
         ENDIF   
			LIND->(DBSKIP())
		ENDDO
   ENDIF
	
	IDC->(DBSKIP())
	
ENDDO	
OnAbrea()
RETURN NIL


Function OnAbrea

	Local n, nValue, aPos

	SetWaitCursor( _HMG_MainHandle )
	SetWaitCursor( GetControlHandle( 'Progress_1' , 'Jcs_1' ) )

	aPos := GetCursorPos()
	SetCursorPos( aPos[2] , aPos[1] )   // update cursor shape

	For n := 1 To 14000 
		nValue := Int( n / 100 )
		//n := n+3
		Jcs_1.Progress_1.Value := nValue
		If n%500 == 0

			DO EVENTS

		EndIf
	Next

	SetArrowCursor( _HMG_MainHandle )
	SetArrowCursor( GetControlHandle( 'Progress_1' , 'Jcs_1' ) )

	aPos := GetCursorPos()
	SetCursorPos( aPos[2] , aPos[1] )   // update cursor shape

Return Nil
