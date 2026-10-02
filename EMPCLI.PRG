#Include "minigui.ch"

PROCEDURE empclie
PARAMETERS LIBERA

LiberacaoGSK(LIBERA)

  	Public Nuevo := .F.

	DEFINE WINDOW EMPCLI_2;
	           AT 0,0 ;
 				  WIDTH 660				;
              HEIGHT 350    ;
	           TITLE 'Cadastro de Empresas & Clientes' 	;
				  ICON "TUTOR";
				  CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        FONT 'ARIAL' SIZE 9;		
		        ON INIT ( DesactivEMPCLI()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( EMPC->(dBGoTop()) , EMPCLI_2.Browse_1.Value := EMPC->(RecNo() ) )

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( EMPC->(dBSkip ( -1 )) , EMPCLI_2.Browse_1.Value := EMPC->(RecNo() ) )

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( EMPC->(dBSkip (1)) , if (EMPC->(Eof()) , DbGoBottom() , Nil ) , EMPCLI_2.Browse_1.Value := EMPC->(RecNo() ) )

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( EMPC->(dBGoBottom ()) , EMPCLI_2.Browse_1.Value := EMPC->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarEMPCLI()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION if(!CINCL,VERLIBERA(1),(Nuevo := .T.,NuevoEMPCLI(), NIL ))

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION if(!CALTE,VERLIBERA(2),(CLI->(TREG()) ,ActivarEMPCLI(), Nil ))
				
			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION if(!CEXCL,VERLIBERA(3),EliminarEMPCLI())

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION if(!CIMPR,VERLIBERA(4),ImprimirEMPCLI() ) 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION EMPCLI_2.release 

		END TOOLBAR

            @ 56,10 BROWSE Browse_1				;
		        	     WIDTH 230  				;
                    HEIGHT 250                            ; 
			           HEADERS { 'Codigo' , 'Descrição' }	;
		        	     WIDTHS { 60, 180 }			;
			           WORKAREA EMPC			;
                    FIELDS { 'EMPC->EMPCLI' , 'EMPC->EMPDESCR' } ;
			           ON CHANGE ActualizarEMPCLI() ;
			           ON DBLCLICK ( ActivarEMPCLI() , If (EMPC->(!TREG()) , DesactivEMPCLI() , Nil ) )
		
                     @ 70,260 LABEL L_CODPRO;
                              VALUE 'Codigo';
						          	WIDTH 80           ;
                              HEIGHT 30           ;
	                           FONT 'Arial' SIZE 09	
 
                     @ 100,260 LABEL L_DESPRO;
                              VALUE 'Descrição';
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09
                                                         
                     @ 70,340 TEXTBOX T_EMPCLI    ;
                              WIDTH 60           ;
                              NUMERIC INPUTMASK "99999" 
							 
                     @ 100,340 TEXTBOX T_EMPDESCR;
                             OF EMPCLI_2 ;
		                       WIDTH 200			;
                             TOOLTIP 'Descrição' ;
                             MAXLENGTH 15 ;
                             UPPERCASE         
       
                     @ 130,340 BUTTON Btn_SEMPCLI Of EMPCLI_2        ;
                              CAPTION '&Salvar'             ;
                              ACTION AceptarEMPCLI() ;
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                     @ 130,500 BUTTON Btn_CEMPCLI Of EMPCLI_2        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarEMPCLI() ;
		                        WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                FLAT

	END WINDOW

   EMPCLI_2.Browse_1.SetFocus
		
	CENTER WINDOW EMPCLI_2

	ACTIVATE WINDOW EMPCLI_2

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivEMPCLI
*------------------------------------------------------------------------------*
EMPCLI_2.Browse_1.Enabled :=.T.
EMPCLI_2.T_EMPCLI.Enabled :=.F.
EMPCLI_2.T_EMPDESCR.Enabled :=.F.
EMPCLI_2.Btn_CEMPCLI.Enabled:=.F.
EMPCLI_2.Btn_SEMPCLI.Enabled:=.F.
EMPCLI_2.ToolBar_1.Enabled:=.T.
EMPCLI_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarEMPCLI
*------------------------------------------------------------------------------*
EMPCLI_2.Browse_1.Enabled :=.F.
EMPCLI_2.ToolBar_1.Enabled:=.F.
EMPCLI_2.T_EMPDESCR.Enabled :=.T.
EMPCLI_2.Btn_CEMPCLI.Enabled:=.T.
EMPCLI_2.Btn_SEMPCLI.Enabled:=.T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarEMPCLI
*------------------------------------------------------------------------------*
DesactivEMPCLI()
ActualizarEMPCLI()
EMPC->(DBUNLOCK())
Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarEMPCLI
*------------------------------------------------------------------------------*
DesactivEMPCLI()
If Nuevo == .T.
   EMPC->(DbAppend())
	Nuevo := .F.
ENDIF		
EMPC->EMPCLI  := EMPCLI_2.T_EMPCLI.VALUE
EMPC->EMPDESCR:= EMPCLI_2.T_EMPDESCR.VALUE
EMPCLI_2.Browse_1.Refresh
EMPC->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizarEMPCLI()
*------------------------------------------------------------------------------*
EMPC->(DBSETORDER(1))
EMPC->(DbSeek(str(EMPC->EMPCLI,3)))
EMPCLI_2.T_EMPCLI.VALUE := EMPC->EMPCLI
EMPCLI_2.T_EMPDESCR.VALUE := EMPC->EMPDESCR
EMPC->(DBSETORDER(2)) 
Return

*------------------------------------------------------------------------------*
Procedure BuscarEMPCLI
*------------------------------------------------------------------------------*
Local nOption:=0

  nOption:=MsgOptions(,,"Users.Bmp" , {"&Codigo","&Descrição"}, 1, 20 )
  
  if nOption = 1
     EMPC->(dbsetorder(1))
	  Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo ' , 'Pesquisa' ) ) )
	  BUSCAR := VAL(BUSCAR)
     If EMPC->(DbSeek(STR(buscar,3)))
	     EMPCLI_2.Browse_1.Value := EMPC->(RecNo())
	  Else
        MsgExclamation('Nao encontrado registro')
	  EndIf
  elseIF nOPTION=2
     EMPC->(dbsetorder(2))
     Buscar := AllTrim (  InputBox( 'Informe Descrição ' , 'Pesquisa' ) )
	  SET SOFTSEEK ON
     EMPC->(DbSeek(buscar))
	  EMPCLI_2.Browse_1.Value := EMPC->(RecNo())
	  SET SOFTSEEK OFF
  endif 			  
  EMPC->(dbsetorder(1))

Return


*------------------------------------------------------------------------------*
PROCEDURE NuevoEMPCLI()
*------------------------------------------------------------------------------*
LOCAL ANTPRO:=0
EMPC->(DBSETORDER(1))
DO WHILE !EMPC->(EOF())
   ANTPRO:=EMPC->EMPCLI
   EMPC->(DBSKIP())
ENDDO
ANTPRO:=ANTPRO+1 
EMPCLI_2.T_EMPCLI.VALUE:=ANTPRO
EMPCLI_2.T_EMPDESCR.VALUE:=space(15)
ActivarEMPCLI()
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarEMPCLI
*------------------------------------------------------------------------------*
If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')
	If EMPC->(TREG())
		EMPC->(dbdelete())
		EMPC->(dbgotop()) 
		EMPC->(DBUNLOCK())
      EMPCLI_2.Browse_1.Value := EMPC->(RecNo())
		ActualizarEMPCLI()
	EndIf
EndIf
Return
*------------------------------------------------------------------------------*
Procedure ImprimirEMPCLI()
*------------------------------------------------------------------------------*
Local RecEMPCLI

	RecEMPCLI := EMPC->(RecNo())

	EMPC->(DBGOTOP())
	
	DO REPORT								;
		TITLE 'Cadastro Empresas & Clientes';
            HEADERS  {'',''} , {'Codigo','Descricao'};
            FIELDS   {'EMPC->EMPCLI','EMPC->EMPDESCR'};
		WIDTHS   {5,30} 						;
		TOTALS   {.F.,.F.}					;
		WORKAREA EMPC		;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							

	Select EMPC
	
	EMPC->(DbGoTo(RecEMPCLI))
	
Return
