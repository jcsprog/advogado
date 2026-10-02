#Include "minigui.ch"

PROCEDURE UNIDADE

  	Public Nuevo := .F.

	DEFINE WINDOW UNID_2;
	           AT 0,0 ;
 				  WIDTH 660				;
              HEIGHT 350    ;
	           TITLE 'Cadastro de Unidade' 	;
				  ICON "TUTOR";
				  CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        FONT 'ARIAL' SIZE 9;		
		        ON INIT ( AbrirUNID(),DesactivUNID()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( UNID->(dBGoTop()) , UNID_2.Browse_1.Value := UNID->(RecNo() ) )

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( UNID->(dBSkip ( -1 )) , UNID_2.Browse_1.Value := UNID->(RecNo() ) )

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( UNID->(dBSkip (1)) , if (UNID->(Eof()) , UNID->(DbGoBottom()) , Nil ) , UNID_2.Browse_1.Value := UNID->(RecNo() ) )

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( UNID->(dBGoBottom ()) , UNID_2.Browse_1.Value := UNID->(RecNo() ))  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarUNID()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoUNID() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( UNID->(TREG()) , ActivarUNID() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarUNID() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirUNID() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
                ACTION UNID_2.release 

		END TOOLBAR

            @ 56,10 BROWSE Browse_1				;
		        	     WIDTH 230  				;
                    HEIGHT 250                            ; 
			           HEADERS { 'Codigo' , 'Descrição Unidade' }	;
		        	     WIDTHS { 60, 180 }			;
			           WORKAREA UNID			;
                    FIELDS { 'UNID->CDUNI' , 'UNID->DSUNI' } ;
			           ON CHANGE ActualizarUNID() ;
			           ON DBLCLICK ( ActivarUNID() , If (UNID->(!TREG()) , DesactivUNID() , Nil ) )
		
                     @ 70,260 LABEL Label_CODPRO;
                              VALUE 'Codigo';
						          	WIDTH 80           ;
                              HEIGHT 30           ;
	                           FONT 'Arial' SIZE 09	
 
                     @ 100,260 LABEL Label_DESPRO;
                              VALUE 'Descrição';
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09
                                                         
                     @ 70,340 TEXTBOX T_CDUNI    ;
                              WIDTH 60           ;
                              NUMERIC INPUTMASK "99999" 
							 
                     @ 100,340 TEXTBOX T_DSUNI;
                             OF UNID_2 ;
		                       WIDTH 200			;
                             TOOLTIP 'Descrição da Unidade' ;
                             MAXLENGTH 10 ;
                             UPPERCASE         
       
                     @ 130,340 BUTTON Btn_SUNID Of UNID_2        ;
                              CAPTION '&Salvar'             ;
                              ACTION AceptarUNID() ;
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                     @ 130,500 BUTTON Btn_CUNID Of UNID_2        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarUNID() ;
		                        WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                FLAT

	END WINDOW

   UNID_2.Browse_1.SetFocus
		
	CENTER WINDOW UNID_2

	ACTIVATE WINDOW UNID_2

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AbrirUNID
*------------------------------------------------------------------------------*
*USE UNIDADE ALIAS UNID INDEX IDUNI1,IDUNI2 NEW SHARED
UNID->(dbsetorder(2))
*UNID->(DBGOTOP())
UNID_2.Browse_1.Value := UNID->(RecNo())
RETURN
*------------------------------------------------------------------------------*
PROCEDURE DesactivUNID
*------------------------------------------------------------------------------*
UNID_2.Browse_1.Enabled :=.T.
UNID_2.T_CDUNI.Enabled  :=.F.
UNID_2.T_DSUNI.Enabled  :=.F.
UNID_2.Btn_CUNID.Enabled:=.F.
UNID_2.Btn_SUNID.Enabled:=.F.
UNID_2.ToolBar_1.Enabled:=.T.
UNID_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarUNID
*------------------------------------------------------------------------------*
UNID_2.Browse_1.Enabled :=.F.
UNID_2.ToolBar_1.Enabled:=.F.
UNID_2.T_CDUNI.Enabled  :=.F.
UNID_2.T_DSUNI.Enabled  :=.T.
UNID_2.Btn_CUNID.Enabled:=.T.
UNID_2.Btn_SUNID.Enabled:=.T.
UNID_2.T_DSUNI.SETFOCUS
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarUNID
*------------------------------------------------------------------------------*
DesactivUNID()
ActualizarUNID()
UNID->(DBUNLOCK())
Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarUNID
*------------------------------------------------------------------------------*
DesactivUNID()
If Nuevo == .T.
   UNID->(DbAppend())
	Nuevo := .F.
ENDIF		
UNID->CDUNI  := UNID_2.T_CDUNI.VALUE
UNID->DSUNI  := UNID_2.T_DSUNI.VALUE
UNID_2.Browse_1.Refresh
If Nuevo == .T.
   UNID_2.Browse_1.Value := UNID->(RecNo())
EndIf
UNID->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizarUNID()
*------------------------------------------------------------------------------*
UNID->(DBSETORDER(1))
UNID->(DbSeek(str(UNID->CDUNI,5)))
UNID_2.T_CDUNI.VALUE  := UNID->CDUNI
UNID_2.T_DSUNI.VALUE  := UNID->DSUNI
UNID->(DBSETORDER(2)) 
Return

*------------------------------------------------------------------------------*
Procedure BuscarUNID
*------------------------------------------------------------------------------*
Local nOption:=0

  nOption:=MsgOptions(,,"Users.Bmp" , {"&Codigo","&Descrição"}, 1, 20 )
  
  if nOption = 1
     UNID->(dbsetorder(1))
	  Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo ' , 'Pesquisa' ) ) )
	  BUSCAR := VAL(BUSCAR)
     If UNID->(DbSeek(STR(buscar,5)))
	     UNID_2.Browse_1.Value := UNID->(RecNo())
	  Else
        MsgExclamation('Nao encontrado registro')
	  EndIf
  elseIF nOPTION=2
     UNID->(dbsetorder(2))
     Buscar := AllTrim (InputBox( 'Informe Descrição ' , 'Pesquisa' ) )
	  SET SOFTSEEK ON
     UNID->(DbSeek(buscar))
	  UNID_2.Browse_1.Value := UNID->(RecNo())
     SET SOFTSEEK OFF
  endif 			  

Return


*------------------------------------------------------------------------------*
PROCEDURE NuevoUNID()
*------------------------------------------------------------------------------*
LOCAL ANTPRO:=0
UNID->(DBSETORDER(1))
DO WHILE !UNID->(EOF())
   ANTPRO:=UNID->CDUNI
   UNID->(DBSKIP())
ENDDO
ANTPRO:=ANTPRO+1 
UNID_2.T_CDUNI.VALUE:=ANTPRO
UNID_2.T_DSUNI.VALUE:=space(30)
UNID->(DBSETORDER(2))
ActivarUNID()
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarUNID
*------------------------------------------------------------------------------*
If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')
	If UNID->(TREG())
		UNID->(dbdelete())
		UNID->(dbgotop()) 
		UNID->(DBUNLOCK())
      UNID_2.Browse_1.Value := UNID->(RecNo())
		ActualizarUNID()
	EndIf
EndIf
Return
*------------------------------------------------------------------------------*
Procedure ImprimirUNID()
*------------------------------------------------------------------------------*
Local RecUNID

	RecUNID := UNID->(RecNo())

	UNID->(DBGOTOP())
	
	DO REPORT;
		TITLE 'Cadastro de Unidades';
      HEADERS  {'',''} , {'Codigo','Descricao do Unidade'};
      FIELDS   {'UNID->CDUNI','UNID->DSUNI'};
		WIDTHS   {5,20} 						;
		TOTALS   {.F.,.F.}					;
		WORKAREA UNID		;
		LPP      55								;
		CPL      77								;
		LMARGIN  3								;
		TMARGIN  3								;
		PAPERSIZE DMPAPER_A4 							;
		PREVIEW									; 

	Select UNID
	
	UNID->(DbGoTo(RecUNID))
	
Return
