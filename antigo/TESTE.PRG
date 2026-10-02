#Include "minigui.ch"

function CDSPROCES

  	Public Nuevo := .F.

	DEFINE WINDOW PRC_2;
	           AT 0,0 ;
              WIDTH GetDesktopWidth() ;
              HEIGHT GetDesktopHeight() ; 
	           TITLE 'Controle Geral de Processos' 	;
				  ICON "TUTOR";
				  CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        FONT 'ARIAL' SIZE 10;		
		        ON INIT ( AbrirPRC(),DesactivPRC())

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( PRC->(dBGoTop()) , PRC_2.Browse_1.Value := PRC->(RecNo() ) )

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( PRC->(dBSkip ( -1 )) , PRC_2.Browse_1.Value := PRC->(RecNo() ) )

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( PRC->(dBSkip (1)) , if (PRC->(Eof()) , PRC->(DbGoBottom()) , Nil ) , PRC_2.Browse_1.Value := PRC->(RecNo() ) )

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( PRC->(dBGoBottom ()) , PRC_2.Browse_1.Value := PRC->(RecNo() ))  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarPRC()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoPRC() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( PRC->(TREG()) , ActivarPRC() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarPRC() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION PRC_2.release 

		END TOOLBAR

            @ 56,10 BROWSE Browse_1	;
		        	     WIDTH 330 		;
                    HEIGHT 190      ; 
			           HEADERS {'Processo','Solicitação','Nome Cliente'};
		        	     WIDTHS {80,70,170 }			;
                    FONT "Arial" SIZE 09 ;
			           WORKAREA PRC			;
                    FIELDS {'PRC->NPROCE','DTOC(PRC->DTSOLIC)','PRC->NOME'} ;
                    ON CHANGE ActualizarPRC() ;
			           ON DBLCLICK ( ActivarPRC() , If (PRC->(!TREG()) , DesactivPRC() , Nil ) ) 

                     @ 70,350 LABEL L_DTSOL;
                              VALUE 'Solicitação';
						          	WIDTH 90           ;
                              HEIGHT 30           

                     @ 70,580 LABEL L_CPF;
                              VALUE 'Nº CPF';
						          	WIDTH 60      ;
                              HEIGHT 30           
 
                     @ 100,350 LABEL L_NOME;
                              VALUE 'Nome';
                              WIDTH 80           ;
                              HEIGHT 30           

                     @ 130,350 LABEL L_PROC;
                              VALUE 'Nº Processo';
						          	WIDTH 90      ;
                              HEIGHT 30           
 
                     @ 130,640 LABEL L_COMAR;
                              VALUE 'Comarca';
                              WIDTH 80           ;
                              HEIGHT 30           

                     @ 160,350 LABEL L_DTPRO;
                              VALUE 'Programada';
						          	WIDTH 100 ;
                              HEIGHT 30           
 
                     @ 160,640 LABEL L_DTFATL;
                              VALUE 'Fatal';
                              WIDTH 80           ;
                              HEIGHT 30           

                     @ 190,350 LABEL L_DTSOLAC;
                              VALUE 'Solicitação RH';
                              WIDTH 120       ;
                              HEIGHT 30           

                     @ 190,640 LABEL L_DTREM;
                              VALUE 'Remessa';
                              WIDTH 80           ;
                              HEIGHT 30        
										   
                     @ 220,350 LABEL L_SOLIC;
                              VALUE 'Solicitante';
                              WIDTH 100           ;
                              HEIGHT 30           


                     DEFINE DATEPICKER DTSOLIC
                           ROW 70
                           COL 450
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                           TOOLTIP 'Para Desmarcar Tecle Espaço' 
                    END DATEPICKER

					     @ 70,640 TEXTBOX CPF;
                             OF PRC_2 ;         		              
                             WIDTH 130  ;                              								
					 		        INPUTMASK  '999.999.999-99';
     							     ON ENTER (PRC_2.NOME.SETFOCUS)

					     @ 100,450 TEXTBOX NOME;
                             OF PRC_2 ;         		              
                             WIDTH 300 ;
     							     ON ENTER (PRC_2.NPROCE.SETFOCUS)

					     @ 130,450 TEXTBOX NPROCE;
                             OF PRC_2 ;         		              
                             WIDTH 150 ;
   					 		     MAXLENGTH 20 ;
									  ON ENTER (PRC_2.COMARCA.SETFOCUS)

					     @ 130,710 TEXTBOX COMARCA;
                             OF PRC_2 ;         		              
                             WIDTH 150 ;
									  ON ENTER (PRC_2.DTPROGRAMA.SETFOCUS)                               								

                    DEFINE DATEPICKER DTPROGRAMA
                           ROW 160
                           COL 450
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                    END DATEPICKER

                    DEFINE DATEPICKER DTFATAL
                           ROW 160
                           COL 710
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                    END DATEPICKER

                   DEFINE DATEPICKER DTSOLCLI
                           ROW 190
                           COL 450
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                    END DATEPICKER

                    DEFINE DATEPICKER DTREM
                           ROW 190
                           COL 710
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                    END DATEPICKER

  			    	     @ 220,450 COMBOBOX SOLICITAN;
     			                 ITEMSOURCE SOLICT->NOMESOL;	
					  		        VALUESOURCE SOLICT->CDSOLI;
  							        WIDTH 280 HEIGHT 100 ;
  							        ON ENTER (PRC_2.DTRECPC.SETFOCUS)

                     DEFINE FRAME Frame_1
                            ROW    250
                            COL    010
                            WIDTH  310
                            HEIGHT 230
                            FONTNAME "Arial"
                            FONTSIZE 14
                            FONTBOLD .F.
                            FONTITALIC .F.
                            FONTUNDERLINE .F.
                            FONTSTRIKEOUT .F.
                            CAPTION "Recursos : Deferido ou Indeferido"
                            BACKCOLOR NIL
                            FONTCOLOR NIL
                            OPAQUE .T.
                     END FRAME

                     @ 280,020 LABEL L_Defe;
                              VALUE 'Deferido';
                              WIDTH 060           ;
                              HEIGHT 30           

                     @ 280,070 LISTBOX deferido;
		                      WIDTH 50 height 20  ;
							       items {"Sim","Não"}   

                     @ 280,130 LABEL L_inde;
                              VALUE 'Indeferido';
                              WIDTH 80          ;
                              HEIGHT 30           

                     @ 280,190 LISTBOX indeferido;
		                      WIDTH 50 height 20  ;
							       items {"Sim","Não"}   

                     @ 310,020 LABEL L_dtrec;
                              VALUE 'Data';
                              WIDTH 070   ;
                              HEIGHT 30           

                     DEFINE DATEPICKER DTREC
                           ROW 310
                           COL 060
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                           TOOLTIP 'Para Desmarcar Tecle Espaço' 
                    END DATEPICKER
									                   
                    @ 340,020 LABEL L_sit;
                              VALUE 'Situação';
                              WIDTH 090   ;
                              HEIGHT 30           

               	  @ 340,080 EDITBOX txtrec ;
                     			WIDTH 230 ;
                     			HEIGHT 130

                     DEFINE FRAME Frame_2
                            ROW    250
                            COL    350
                            WIDTH  310
                            HEIGHT 230
                            FONTNAME "Arial"
                            FONTSIZE 14
                            FONTBOLD .F.
                            FONTITALIC .F.
                            FONTUNDERLINE .F.
                            FONTSTRIKEOUT .F.
                            CAPTION "Liquidação de Sentença"
                            BACKCOLOR NIL
                            FONTCOLOR NIL
                            OPAQUE .T.
                     END FRAME

                     @ 280,360 LABEL L_liqui;
                              VALUE 'Liquidado';
                              WIDTH 060           ;
                              HEIGHT 30           

                     @ 280,420 LISTBOX liquidado;
		                      WIDTH 50 height 20  ;
							       items {"Sim","Não"}   

                     @ 280,500 LABEL L_lacordo;
                              VALUE 'Acordo';
                              WIDTH 80          ;
                              HEIGHT 30           

                     @ 280,550 LISTBOX acordo;
		                      WIDTH 50 height 20  ;
							       items {"Sim","Não"}   
						       
                     @ 310,360 LABEL L_dtac;
                              VALUE 'Data';
                              WIDTH 070   ;
                              HEIGHT 30           

                     DEFINE DATEPICKER DTACORD
                           ROW 310
                           COL 420
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                           TOOLTIP 'Para Desmarcar Tecle Espaço' 
                     END DATEPICKER

                     @ 310,550 LABEL L_porc;
                              VALUE '( % )';
                              WIDTH 070   ;
                              HEIGHT 30           

   					   @ 310,590 TEXTBOX porcen;
   						         WIDTH 50    ;
                              numeric inputmask '999' 
                     
                     @ 340,360 LABEL L_VLAC;
                              VALUE 'R$ Acordo';
                              WIDTH 070   ;
                              HEIGHT 30           

   					   @ 340,430 TEXTBOX vlacordo;
   						         WIDTH 80    ;
                              numeric inputmask '9999999.99' 

                     @ 340,520 LABEL L_parce;
                              VALUE 'Parcelado';
                              WIDTH 80          ;
                              HEIGHT 30           

                     @ 340,590 LISTBOX parcela;
		                      WIDTH 50 height 20  ;
							       items {"Sim","Não"}   

                     @ 370,360 LABEL L_qtep;
                              VALUE 'Qte.Parc.';
                              WIDTH 060   ;
                              HEIGHT 30           

   					   @ 370,420 TEXTBOX qteparc;
   						         WIDTH 30    ;
                              numeric inputmask '999' 

                     @ 370,460 LABEL L_dtsi;
                              VALUE 'Dt.Sinal';
                              WIDTH 070   ;
                              HEIGHT 30           

                     DEFINE DATEPICKER DTSILNAL
                           ROW 370
                           COL 520
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                           TOOLTIP 'Para Desmarcar Tecle Espaço' 
                     END DATEPICKER

                     @ 400,360 LABEL L_VLSIN;
                              VALUE 'R$ Sinal';
                              WIDTH 070   ;
                              HEIGHT 30           

   					   @ 400,420 TEXTBOX vlsinal;
   						         WIDTH 90    ;
                              numeric inputmask '9999999.99' 

                     DEFINE FRAME Frame_3
                            ROW    250
                            COL    670
                            WIDTH  310
                            HEIGHT 230
                            FONTNAME "Arial"
                            FONTSIZE 14
                            FONTBOLD .F.
                            FONTITALIC .F.
                            FONTUNDERLINE .F.
                            FONTSTRIKEOUT .F.
                            CAPTION "Andamento Processual"
                            BACKCOLOR NIL
                            FONTCOLOR NIL
                            OPAQUE .T.
                     END FRAME

/*
                    @ 645,350 BUTTON Btn_SavProcess Of PRC_2        ;
                              CAPTION '&Salvar Empresa'             ;
                              ACTION GRAVACONTROLE() ;
                              WIDTH 120 HEIGHT 24         ;
                              FONT "Arial" SIZE 09         ;
                            FLAT
*/

                     @ 680,480 BUTTON Btn_SPROCES Of PRC_2        ;
                              CAPTION '&Salvar Solicitação'             ;
                              ACTION AceptarPRC() ;
                              WIDTH 200 HEIGHT 25         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                     @ 680,750 BUTTON Btn_CPROCES Of PRC_2        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarPRC() ;
		                        WIDTH 80 HEIGHT 25		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                FLAT
	END WINDOW

   PRC_2.Browse_1.SetFocus
		
	CENTER WINDOW PRC_2

	ACTIVATE WINDOW PRC_2

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AbrirPRC
*------------------------------------------------------------------------------*
//USE UNIDADE ALIAS UNID INDEX IDUNI1,IDUNI2 NEW SHARED
//USE CONTROLE ALIAS CTRP INDEX IDCTRP1,IDCTRP2 NEW SHARED
//USE SOLICITA ALIAS SOLICT INDEX IDSOLT1,IDSOLT2 NEW SHARED
//USE PROCESSO alias prc index IDPROC1,IDPROC2,IDPROC3,IDPROC4 NEW SHARED
PRC_2.Browse_1.Value := PRC->(RecNo())
RETURN
*------------------------------------------------------------------------------*
PROCEDURE DesactivPRC
*------------------------------------------------------------------------------*
PRC_2.Browse_1.Enabled :=.T.
PRC_2.DTSOLIC.Enabled :=.F.
PRC_2.CPF.Enabled :=.F.
PRC_2.NOME.Enabled :=.F.
PRC_2.NPROCE.Enabled :=.F.
PRC_2.COMARCA.Enabled :=.F.
PRC_2.DTPROGRAMA.Enabled :=.F.
PRC_2.DTFATAL.ENABLED:=.F.
PRC_2.DTREM.Enabled :=.F.
PRC_2.DTSOLCLI.Enabled :=.F.
PRC_2.SOLICITAN.Enabled :=.F.
PRC_2.Btn_CPROCES.Enabled:=.F.
PRC_2.Btn_SPROCES.Enabled:=.F.
PRC_2.ToolBar_1.Enabled:=.T.
PRC_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarPRC
*------------------------------------------------------------------------------*
PRC_2.Browse_1.Enabled :=.F.
PRC_2.ToolBar_1.Enabled:=.F.
If Nuevo == .T.
   PRC_2.DTSOLIC.Enabled :=.T.
   PRC_2.CPF.Enabled :=.T.
   PRC_2.NPROCE.Enabled :=.T.
ENDIF
PRC_2.NOME.Enabled :=.T.
PRC_2.COMARCA.Enabled :=.T.
PRC_2.DTPROGRAMA.ENABLED:=.T.
PRC_2.DTFATAL.ENABLED:=.T.
PRC_2.DTREM.Enabled :=.T.
PRC_2.DTSOLCLI.Enabled :=.T.
PRC_2.SOLICITAN.Enabled :=.T.
PRC_2.Btn_CPROCES.Enabled:=.T.
PRC_2.Btn_SPROCES.Enabled:=.T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarPRC
*------------------------------------------------------------------------------*
DesactivPRC()
ActualizarPRC()
PRC->(DBUNLOCK())
Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarPRC
*------------------------------------------------------------------------------*
DesactivPRC()
If Nuevo == .T.
   PRC->(DbAppend())
	Nuevo := .F.
ENDIF	
PRC->DTSOLIC  :=PRC_2.DTSOLIC.VALUE
PRC->CPF      :=PRC_2.CPF.VALUE     
PRC->NOME     :=PRC_2.NOME.VALUE    
PRC->NPROCE   :=PRC_2.NPROCE.VALUE
PRC->COMARCA  :=PRC_2.COMARCA.VALUE 
PRC->DTPROGRAM:=PRC_2.DTPROGRAMA.VALUE
PRC->DTFATAL  :=PRC_2.DTFATAL.VALUE
PRC->DTSOLCLI :=PRC_2.DTSOLCLI.VALUE
PRC->SOLICIT  :=PRC_2.SOLICITAN.VALUE 
PRC->DTREM    :=PRC_2.DTREM.VALUE 
PRC->UNIDADE   := 0 
PRC->FORMA     := 0   
PRC->STATUS    := space(3)  
PRC->DTREM     := ctod("")   
PRC->RDEF      := space(1)    
PRC->RIND      := space(1)    
PRC->DTREC     := ctod("")   
PRC->OBSREC    := ""  
PRC->LIQUID    := space(1)  
PRC->DTACORD   := ctod("") 
PRC->ACORDO    := space(1)  
PRC->VLACORDO  := 0
PRC->PARCELA   := space(1) 
PRC->QTEPARC   := 0 
PRC->DTSINAL   := ctod("") 
PRC->VLSINAL   := 0 
PRC->PORCE     := 0   
PRC_2.Browse_1.Refresh
If Nuevo == .T.
   PRC_2.Browse_1.Value := PRC->(RecNo())
EndIf
PRC->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizarPRC()
*------------------------------------------------------------------------------*
PRC->(Dbgoto(RecNo()))                             
PRC_2.DTSOLIC.VALUE   :=PRC->DTSOLIC
PRC_2.CPF.VALUE       :=PRC->CPF
PRC_2.NOME.VALUE      :=PRC->NOME
PRC_2.NPROCE.VALUE    :=PRC->NPROCE
PRC_2.COMARCA.VALUE   :=PRC->COMARCA
PRC_2.DTPROGRAMA.VALUE:=PRC->DTPROGRAM
PRC_2.DTFATAL.VALUE   :=PRC->DTFATAL
PRC_2.DTSOLCLI.VALUE  :=PRC->DTSOLCLI
PRC_2.SOLICITAN.VALUE :=PRC->SOLICIT  
SOLICT->( DBSETORDER(1),DBSEEK(PRC->SOLICIT) )  
PRC_2.SOLICITAN.VALUE :=SOLICT->(RECNO())  
SOLICT->( DBSETORDER(2))
PRC_2.DTREM.VALUE     :=PRC->DTREM
Return
*------------------------------------------------------------------------------*
Procedure BuscarPRC
*------------------------------------------------------------------------------*
Local nOption:=0

  nOption:=MsgOptions(,,"Users.Bmp" , {"&Codigo","&Descrição"}, 1, 20 )
  
  if nOption = 1
     PRC->(dbsetorder(1))
	  Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo ' , 'Pesquisa' ) ) )
	  BUSCAR := VAL(BUSCAR)
     If PRC->(DbSeek(buscar))
	     PRC_2.Browse_1.Value := PRC->(RecNo())
	  Else
        MsgExclamation('Nao encontrado registro')
	  EndIf
  elseIF nOPTION=2
     PRC->(dbsetorder(2))
     Buscar := AllTrim (  InputBox( 'Informe Descrição ' , 'Pesquisa' ) )
	  SET SOFTSEEK ON
     PRC->(DbSeek(buscar))
	  PRC_2.Browse_1.Value := PRC->(RecNo())
	  SET SOFTSEEK OFF
  endif 			  

Return

*------------------------------------------------------------------------------*
PROCEDURE NuevoPRC()
*------------------------------------------------------------------------------*
PRC_2.DTSOLIC.VALUE :=Ctod('  /  /    ')
PRC_2.CPF.VALUE     :=SPACE(15)
PRC_2.NOME.VALUE    :=SPACE(40)
PRC_2.NPROCE.VALUE:=SPACE(20)
PRC_2.COMARCA.VALUE :=SPACE(30)
PRC_2.DTPROGRAMA.VALUE:=Ctod('  /  /    ')
PRC_2.DTSOLCLI.VALUE:=Ctod('  /  /    ')
PRC_2.DTREM.VALUE:=Ctod('  /  /    ')
PRC_2.SOLICITAN.VALUE :=SPACE(03)
ActivarPRC()
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarPRC
*------------------------------------------------------------------------------*
If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')
	If PRC->(TREG())
		PRC->(dbdelete())
		PRC->(dbgotop()) 
		PRC->(DBUNLOCK())
      PRC_2.Browse_1.Value := PRC->(RecNo())
		ActualizarPRC()
	EndIf
EndIf
Return

****************************
PROCEDURE VERIFICA
****************************
RETURN IF(CTRP->DTENVIO=CTOD([]),.T.,.F.)

