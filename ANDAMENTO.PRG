#Include "minigui.ch"

PROCEDURE ANDAME
PARAMETERS x_cpf,x_proc,LIBERA

LiberacaoGSK(LIBERA)

  	Public Nuevo := .F.

	DEFINE WINDOW ANADAM_2;    
	           AT 0,0 ;
 				  WIDTH 850				;
              HEIGHT 350    ;                                     
	           TITLE "ANDAMENTO PROCESSO ->"+x_proc	;
				  ICON "TUTOR";
				  FONT 'ARIAL' SIZE 9;
				  MODAL ;
		        ON INIT ( DesactivANADAM(),ActualizarANADAM());
		        BACKCOLOR {0, 255, 255}
              
		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( AND->(dBGoTop()) , ANADAM_2.Browse_1.Value := AND->(RecNo() ) )

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( AND->(dBSkip ( -1 )) , ANADAM_2.Browse_1.Value := AND->(RecNo() ) )

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( AND->(dBSkip (1)) , if (AND->(Eof()) , AND->(DbGoBottom()) , Nil ) , ANADAM_2.Browse_1.Value := AND->(RecNo() ) )

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( AND->(dBGoBottom ()) , ANADAM_2.Browse_1.Value := AND->(RecNo()) )  SEPARATOR 

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( if(!CINCL,VERLIBERA(1),(Nuevo := .T., NuevoANADAM(), NIL )))

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( if(!CALTE,VERLIBERA(2),(AND->(TREG()) , ActivarANADAM() , Nil )))

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION if(!CEXCL,VERLIBERA(3),EliminarANADAM()) 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION ANADAM_2.release 

		END TOOLBAR

            @ 56,10 BROWSE Browse_1				;
		        	     WIDTH 300  				;
                    HEIGHT 250                            ; 
			           HEADERS { 'Dt.Andamento' , 'Observações(1)','Observações(2)','Observações(3)','Observações(3)' }	;
		        	     WIDTHS { 100, 180, 180, 180, 180 }			;
			           WORKAREA AND			;
                    FIELDS { 'AND->DTANDA' , 'AND->AOBS1','AND->AOBS2','AND->AOBS3','AND->AOBS4' } ;
			           ON CHANGE ActualizarANADAM() ;
			           ON DBLCLICK ( ActivarANADAM() , If (AND->(!TREG()) , DesactivANADAM() , Nil ) )

                     @ 70,320 LABEL L_dtand;
                              VALUE 'Dt.Andamento';
						          	WIDTH 80           ;
                              HEIGHT 30           ;
	                           FONT 'Arial' SIZE 09 ;
										backcolor c_lbl_color	
 
                     @ 100,320 LABEL L_obs1;
                              VALUE 'O b s e r v a ç õ e s';
                              WIDTH 250           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09;
										backcolor c_lbl_color

                     @ 070,400 DATEPICKER T_DTANDA  
                                                         
                     @ 130,320 TEXTBOX T_AOBS1   ;
                              WIDTH 500           ;
                              MAXLENGTH 80 
                                   
                     @ 160,320 TEXTBOX T_AOBS2   ;
                              WIDTH 500           ;
                              MAXLENGTH 80 

                     @ 190,320 TEXTBOX T_AOBS3   ;
                              WIDTH 500          ;
                              MAXLENGTH 80 

                     @ 220,320 TEXTBOX T_AOBS4   ;
                              WIDTH 500           ;
                              MAXLENGTH 80 
       
                     @ 270,340 BUTTON Btn_SANADAM Of ANADAM_2        ;
                              CAPTION '&Salvar'             ;
                              ACTION AceptarANADAM() ;
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                     @ 270,500 BUTTON Btn_CANADAM Of ANADAM_2        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarANADAM() ;
		                        WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar"	;
			                FLAT

	END WINDOW

   ANADAM_2.Browse_1.SetFocus
		
	CENTER WINDOW ANADAM_2

	ACTIVATE WINDOW ANADAM_2

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivANADAM
*------------------------------------------------------------------------------*
ANADAM_2.Browse_1.Enabled :=.T.
ANADAM_2.T_DTANDA.Enabled :=.F.
ANADAM_2.T_AOBS1.Enabled :=.F.
ANADAM_2.T_AOBS2.Enabled :=.F.
ANADAM_2.T_AOBS3.Enabled :=.F.
ANADAM_2.T_AOBS4.Enabled :=.F.
ANADAM_2.Btn_CANADAM.Enabled:=.F.
ANADAM_2.Btn_SANADAM.Enabled:=.F.
ANADAM_2.ToolBar_1.Enabled:=.T.
ANADAM_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarANADAM
*------------------------------------------------------------------------------*
ANADAM_2.Browse_1.Enabled :=.F.
ANADAM_2.ToolBar_1.Enabled:=.F.
ANADAM_2.T_DTANDA.Enabled :=.T.
ANADAM_2.T_AOBS1.Enabled :=.T.
ANADAM_2.T_AOBS2.Enabled :=.T.
ANADAM_2.T_AOBS3.Enabled :=.T.
ANADAM_2.T_AOBS4.Enabled :=.T.
ANADAM_2.Btn_CANADAM.Enabled:=.T.
ANADAM_2.Btn_SANADAM.Enabled:=.T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarANADAM
*------------------------------------------------------------------------------*
DesactivANADAM()
ActualizarANADAM()
AND->(DBUNLOCK())
Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarANADAM
*------------------------------------------------------------------------------*
DesactivANADAM()
If Nuevo == .T.
   AND->(DbAppend())
	Nuevo := .F.
ENDIF	
AND->NPROCE := x_proc
AND->CPF    := x_cpf
AND->DTANDA :=ANADAM_2.T_DTANDA.VALUE 
AND->AOBS1  :=ANADAM_2.T_AOBS1.VALUE
AND->AOBS2  :=ANADAM_2.T_AOBS2.VALUE
AND->AOBS3  :=ANADAM_2.T_AOBS3.VALUE
AND->AOBS4  :=ANADAM_2.T_AOBS4.VALUE
ANADAM_2.Browse_1.Refresh
AND->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizarANADAM()
*------------------------------------------------------------------------------*
AND->(Dbgoto(AND->(recno())))
ANADAM_2.T_DTANDA.VALUE := AND->DTANDA
ANADAM_2.T_AOBS1.VALUE  := AND->AOBS1
ANADAM_2.T_AOBS2.VALUE  := AND->AOBS2
ANADAM_2.T_AOBS3.VALUE  := AND->AOBS3
ANADAM_2.T_AOBS4.VALUE  := AND->AOBS4
Return

*------------------------------------------------------------------------------*
PROCEDURE NuevoANADAM()
*------------------------------------------------------------------------------*
ANADAM_2.T_DTANDA.VALUE := CTOD("")
ANADAM_2.T_AOBS1.VALUE  := SPACE(80)
ANADAM_2.T_AOBS2.VALUE  := SPACE(80)
ANADAM_2.T_AOBS3.VALUE  := SPACE(80)
ANADAM_2.T_AOBS4.VALUE  := SPACE(80)
ActivarANADAM()
RETURN
*------------------------------------------------------------------------------*
Procedure EliminarANADAM
*------------------------------------------------------------------------------*
If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')
	If AND->(TREG())
		AND->(dbdelete())
		AND->(dbgotop()) 
		AND->(DBUNLOCK())
      ANADAM_2.Browse_1.Value := AND->(RecNo())
		ActualizarANADAM()
	EndIf
EndIf
Return
