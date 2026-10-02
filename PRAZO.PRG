#Include "minigui.ch"

PROCEDURE PRAZOS
PARAMETERS x_cpf,x_proc,LIBERA

LiberacaoGSK(LIBERA)

  	Public Nuevo := .F.

	DEFINE WINDOW PRAZO_2;   
	           AT 0,0 ;
 				  WIDTH 930				;
              HEIGHT 410   ;                                     
	           TITLE "P R A Z O S ->"+x_proc	;
				  ICON "TUTOR";
				  MODAL ;
		        ON INIT ( DesactivPRAZO(),ActualizarPRAZO()) ;
		        BACKCOLOR {0, 255, 255}

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( PRA->(dBGoTop()) , PRAZO_2.Browse_1.Value := PRA->(RecNo() ) )

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( PRA->(dBSkip ( -1 )) , PRAZO_2.Browse_1.Value := PRA->(RecNo() ) )

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( PRA->(dBSkip (1)) , if (PRA->(Eof()) , PRA->(DbGoBottom()) , Nil ) , PRAZO_2.Browse_1.Value := PRA->(RecNo() ) )

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( PRA->(dBGoBottom ()) , PRAZO_2.Browse_1.Value := PRA->(RecNo()) )  SEPARATOR 

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( if(!CINCL,VERLIBERA(1),(Nuevo := .T., NuevoPRAZO(), NIL )))

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( if(!CALTE,VERLIBERA(2),(PRA->(TREG()) ,ActivarPRAZO(), Nil )))

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION if(!CEXCL,VERLIBERA(3),EliminarPRAZO() )

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION PRAZO_2.release 

		END TOOLBAR

            @ 56,10 BROWSE Browse_1				;
		        	     WIDTH 300  				;
                    HEIGHT 250                            ; 
			           HEADERS { 'Publicação' , 'Publicação','Dt.Fatal' }	;
		        	     WIDTHS { 100, 180, 180 }			;
			           WORKAREA PRA			;
                    FIELDS { 'PRA->DTPUBLI' , 'PRA->PUBLICA','PRA->DTFATAL' } ;
			           ON CHANGE ActualizarPRAZO() ;
			           ON DBLCLICK ( ActivarPRAZO() , If (PRA->(!TREG()) , DesactivPRAZO() , Nil ) )

                     @ 70,320 LABEL L_dtand;
                              VALUE 'Dt.Publicação';
						          	WIDTH 80           ;
                              HEIGHT 30           ;
	                           FONT 'Arial' SIZE 09	;
										backcolor c_lbl_color
 
                     @ 100,320 LABEL L_dtpub;
                              VALUE 'Publicação';
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
										backcolor c_lbl_color
  	                           
                     @ 130,320 LABEL L_fatal;
                              VALUE 'Dt.Fatal';
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
										backcolor c_lbl_color  	                           
  	                           
                     @ 160,320 LABEL L_OBS1;
                              VALUE 'Observações';
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09;
										backcolor c_lbl_color  
  	                           
  	                  @ 190,320 LABEL L_recu;
                              VALUE 'Recurso';
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
										backcolor c_lbl_color             
										  
						   @ 220,320 LABEL L_dtrec;
                              VALUE 'Dt.Recurso';
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09	;
										backcolor c_lbl_color
										  
							@ 250,320 LABEL L_nrecu;
                              VALUE 'Recurso';
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09	;
										backcolor c_lbl_color		  			  	                           

                     @ 070,400 DATEPICKER T_DTPUB 
                                                         
                     @ 100,400 TEXTBOX T_PUBLIC   ;
                              WIDTH 500           ;
                              MAXLENGTH 80 

                     @ 130,400 DATEPICKER T_DTFATAL 
                                   
                     @ 160,400 TEXTBOX T_AOBS1   ;
                              WIDTH 500          ;
                              MAXLENGTH 80 
                             
                     @ 190,400 LISTBOX T_RECSN;
                             OF FRAZO_2 ;
                             WIDTH 70 height 20  ;
					              items {"Sim","Não"}

                     @ 220,400 DATEPICKER T_DTREC
							 
                     @ 250,400 TEXTBOX T_RECNOME   ;
                              WIDTH 500           ;
                              MAXLENGTH 80 
       
                     @ 300,340 BUTTON Btn_SPRAZO Of PRAZO_2        ;
                              CAPTION '&Salvar'             ;
                              ACTION AceptarPRAZO() ;
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                     @ 300,500 BUTTON Btn_CPRAZO Of PRAZO_2        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarPRAZO() ;
		                        WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar"	;
			                FLAT

	END WINDOW

   PRAZO_2.Browse_1.SetFocus
		
	CENTER WINDOW PRAZO_2

	ACTIVATE WINDOW PRAZO_2

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivPRAZO
*------------------------------------------------------------------------------*
PRAZO_2.Browse_1.Enabled :=.T.
PRAZO_2.T_DTPUB.Enabled :=.F.
PRAZO_2.T_PUBLIC.Enabled :=.F.
PRAZO_2.T_DTFATAL.Enabled :=.F.
PRAZO_2.T_AOBS1.Enabled :=.F.
PRAZO_2.T_RECSN.Enabled :=.F.
PRAZO_2.T_DTREC.Enabled :=.F.
PRAZO_2.T_RECNOME.Enabled :=.F.
PRAZO_2.Btn_CPRAZO.Enabled:=.F.
PRAZO_2.Btn_SPRAZO.Enabled:=.F.
PRAZO_2.ToolBar_1.Enabled:=.T.
PRAZO_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarPRAZO
*------------------------------------------------------------------------------*
PRAZO_2.Browse_1.Enabled :=.F.
PRAZO_2.ToolBar_1.Enabled:=.T.
PRAZO_2.T_DTPUB.Enabled :=.T.
PRAZO_2.T_PUBLIC.Enabled :=.T.
PRAZO_2.T_DTFATAL.Enabled :=.T.
PRAZO_2.T_AOBS1.Enabled :=.T.
PRAZO_2.T_RECSN.Enabled :=.T.
PRAZO_2.T_DTREC.Enabled :=.T.
PRAZO_2.T_RECNOME.Enabled :=.T.
PRAZO_2.Btn_CPRAZO.Enabled:=.T.
PRAZO_2.Btn_SPRAZO.Enabled:=.T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarPRAZO
*------------------------------------------------------------------------------*
DesactivPRAZO()
ActualizarPRAZO()
PRA->(DBUNLOCK())
Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarPRAZO
*------------------------------------------------------------------------------*
DesactivPRAZO()
If Nuevo == .T.
   PRA->(DbAppend())
	Nuevo := .F.
ENDIF	
PRA->NPROCE := x_proc
PRA->CPF    := x_cpf
PRA->DTPUBLI  := PRAZO_2.T_DTPUB.VALUE
PRA->PUBLICA  := PRAZO_2.T_PUBLIC.VALUE
PRA->DTFATAL  := PRAZO_2.T_DTFATAL.VALUE
PRA->POBS1    := PRAZO_2.T_AOBS1.VALUE 
PRA->RECURSO  := str(PRAZO_2.T_RECSN.VALUE,1)
PRA->DTREC    := PRAZO_2.T_DTREC.VALUE  
PRA->NRECURSO := PRAZO_2.T_RECNOME.VALUE
PRAZO_2.Browse_1.Refresh
PRA->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizarPRAZO()
*------------------------------------------------------------------------------*
PRA->(Dbgoto(PRA->(recno())))
PRAZO_2.T_DTPUB.VALUE := PRA->DTPUBLI
PRAZO_2.T_PUBLIC.VALUE:= PRA->PUBLICA
PRAZO_2.T_DTFATAL.VALUE:=PRA->DTFATAL
PRAZO_2.T_AOBS1.VALUE:=PRA->POBS1
PRAZO_2.T_RECSN.VALUE:=val(PRA->RECURSO)
PRAZO_2.T_DTREC.VALUE := PRA->DTREC
PRAZO_2.T_RECNOME.VALUE:=PRA->NRECURSO
Return

*------------------------------------------------------------------------------*
PROCEDURE NuevoPRAZO()
*------------------------------------------------------------------------------*
PRAZO_2.T_DTPUB.VALUE := ctod('')
PRAZO_2.T_PUBLIC.VALUE:= space(100)
PRAZO_2.T_DTFATAL.VALUE:=ctod('')
PRAZO_2.T_AOBS1.VALUE:=space(80)
PRAZO_2.T_RECSN.VALUE:=space(01)
PRAZO_2.T_DTREC.VALUE := ctod("")
PRAZO_2.T_RECNOME.VALUE:=space(100)
ActivarPRAZO()
RETURN
*------------------------------------------------------------------------------*
Procedure EliminarPRAZO
*------------------------------------------------------------------------------*
If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')
	If PRA->(TREG())
		PRA->(dbdelete())
		PRA->(dbgotop()) 
		PRA->(DBUNLOCK())
      PRAZO_2.Browse_1.Value := PRA->(RecNo())
		ActualizarPRAZO()
	EndIf
EndIf
Return
