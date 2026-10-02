#Include "minigui.ch"

function PGTOS
PARAMETERS x_cpf,x_proc,LIBERA

LiberacaoGSK(LIBERA)

   Public a_pgto:={}
   
	DEFINE WINDOW PGTO_2;
	           AT 0,0 ;
 				  WIDTH 800				;
              HEIGHT 420    ;
	           TITLE 'PAGAMENTO PROCESSO ->'+x_proc 	;
				  ICON "TUTOR";
				  FONT 'ARIAL' SIZE 09;
				  MODAL ;
				  ON INIT ( AbrirPgto(), DesactivPGTO());
				  BACKCOLOR {0, 255, 255}

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( if(!CINCL,VERLIBERA(1),(Nuevo := .T., NuevoPGTO(), NIL )))

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( if(!CALTE,VERLIBERA(2),(CTRP->(TREG()) ,ActivarPGTO(), Nil )))

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION if(!CEXCL,VERLIBERA(3),EliminarPGTO())

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION PGTO_2.release 

		END TOOLBAR

                     @ 70,030 LABEL L_proce;
                              VALUE "Nº Processo :"+x_proc  ;
						          	WIDTH 200           ;
                              HEIGHT 30           ;
	                           FONT 'Arial' SIZE 09	;
	                           backcolor c_lbl_color

                     @ 100,030 LABEL L_cpf;
                              VALUE "CPF/CNPJ    :"+x_cpf;
                              WIDTH 200           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
  	                           backcolor c_lbl_color
  	                           
                     @ 130,030 LABEL L_vltp;
                              VALUE "Valor Total R$";
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
  	                           backcolor c_lbl_color
  	                           
                     @ 160,030 LABEL L_entra ;
                              VALUE "Entrada";
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
  	                           backcolor c_lbl_color
  	                           
                     @ 190,030 LABEL L_vlent ;
                              VALUE "R$ Entrada";
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
  	                           backcolor c_lbl_color
  	                           
                     @ 220,030 LABEL L_parc ;
                              VALUE "Nº Parcelas";
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
  	                           backcolor c_lbl_color

                     @ 250,030 LABEL L_dtpc ;
                              VALUE "Dt.Parcelas";
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09 ;
  	                           backcolor c_lbl_color

                     @ 90,320 LABEL L_Grid_P ;
                              VALUE "Controle de Parcelas";
                              WIDTH 400           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 14 ;
  	                           backcolor c_lbl_color
					
               		@ 120,320 GRID Parcelas_P ;
                        	  WIDTH 430 ; 
			                    HEIGHT 130 ; 	
 		                       HEADERS { 'Parcela' , 'Data Parcela','Valor da Parcela','Situação','Recno'};	
	                          WIDTHS { 80 ,120 ,120, 100,10} ;
	                          TOOLTIP "Para Alterar ou Excluir Lançamentos, Clik no Mesmo" ;
									  ON DBLCLICK ( ALTERALANCP() ) ;
									  JUSTIFY { BROWSE_JTFY_RIGHT,BROWSE_JTFY_RIGHT, BROWSE_JTFY_RIGHT,BROWSE_JTFY_LEFT } 

                     @ 130,130 TEXTBOX T_VLTP;
						            OF PGTO_2 ;
						            WIDTH 70    ;
                              numeric inputmask '9999999.99' ;
						   	      ON ENTER PGTO_2.T_ENTRA.SetFocus
                                                         
                     @ 160,130 LISTBOX T_ENTRA;
                              OF PGTO_2 ;
		                        WIDTH 80 height 20  ;
							         items {"Sim","Não"}  

                     @ 190,130 TEXTBOX T_VLENT;
						            OF PGTO_2 ;
						            WIDTH 70    ;
                              numeric inputmask '9999999.99' ;
						   	      ON ENTER PGTO_2.T_PARC.SetFocus

                     @ 220,130 TEXTBOX T_PARC;
						            OF PGTO_2 ;
						            WIDTH 70    ;
                              numeric inputmask '999' ;
						   	      ON ENTER (ctrParcelas(), PGTO_2.T_DTPC.SetFocus)

                     @ 250,130 DATEPICKER T_DTPC 

                     @ 300,130 BUTTON Btn_SPGTO Of PGTO_2        ;
                              CAPTION '&Salvar Pagamento'             ;
                              ACTION AceptarPGTO() ;
                              WIDTH 150 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Pagamento" ;
                            FLAT

                     @ 300,300 BUTTON Btn_CPGTO Of PGTO_2        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarPGTO() ;
		                        WIDTH 150 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                FLAT

	END WINDOW
   	
	CENTER WINDOW PGTO_2

	ACTIVATE WINDOW PGTO_2

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AbrirPgto()
*------------------------------------------------------------------------------*
if CTRP->(Dbseek(x_proc))
   ActualizarPGTO()
endif
return
   
*------------------------------------------------------------------------------*
PROCEDURE DesactivPGTO
*------------------------------------------------------------------------------*
PGTO_2.T_VLTP.Enabled   :=.F.
PGTO_2.T_ENTRA.Enabled  :=.F. 
PGTO_2.T_VLENT.Enabled  :=.F. 
PGTO_2.T_PARC.Enabled   :=.F.
PGTO_2.T_DTPC.Enabled   :=.F.                                                        
PGTO_2.Btn_CPGTO.Enabled:=.F.
PGTO_2.Btn_SPGTO.Enabled:=.F.
PGTO_2.ToolBar_1.Enabled:=.T.
PGTO_2.Parcelas_P.Enabled:=.F.
a_pgto:={}
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarPGTO
*------------------------------------------------------------------------------*
PGTO_2.ToolBar_1.Enabled:=.F.
PGTO_2.T_VLTP.Enabled   :=.T.
PGTO_2.T_ENTRA.Enabled  :=.T. 
PGTO_2.T_VLENT.Enabled  :=.T. 
PGTO_2.T_PARC.Enabled   :=.T.
PGTO_2.T_DTPC.Enabled   :=.T.
PGTO_2.Parcelas_P.Enabled:=.T.                                                        
PGTO_2.Btn_CPGTO.Enabled:=.T.
PGTO_2.Btn_SPGTO.Enabled:=.T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarPGTO
*------------------------------------------------------------------------------*
DesactivPGTO()
ActualizarPGTO()
CTRP->(DBUNLOCK())
Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarPGTO
*------------------------------------------------------------------------------*
DesactivPGTO()
If Nuevo == .T.
   CTRP->(DbAppend())
	Nuevo := .F.
ENDIF	
CTRP->NPROCE   := X_PROC 
CTRP->CPF      := X_CPF    
CTRP->NVLT     := PGTO_2.T_VLTP.VALUE   
CTRP->ENTRADA  := str(PGTO_2.T_ENTRA.VALUE,1)
CTRP->NVLENTRA := PGTO_2.T_VLENT.VALUE
CTRP->NQTP     := PGTO_2.T_PARC.VALUE 
CTRP->DTPGTO   := PGTO_2.T_DTPC.VALUE
CTRP->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizarPGTO()
*------------------------------------------------------------------------------*
CTRP->(Dbseek(x_proc))
X_PROC := CTRP->NPROCE 
X_CPF  := CTRP->CPF           
PGTO_2.T_VLTP.VALUE := CTRP->NVLT   
PGTO_2.T_ENTRA.VALUE:= val(CTRP->ENTRADA)
PGTO_2.T_VLENT.VALUE:= CTRP->NVLENTRA
PGTO_2.T_PARC.VALUE := CTRP->NQTP  
PGTO_2.T_DTPC.VALUE := CTRP->DTPGTO

DELETE ITEM ALL FROM Parcelas_P OF PGTO_2
if LANP->(DBSEEK(X_PROC))
   do while LANP->(!EOF()) .and. LANP->NPROCE==X_PROC
      ADD ITEM { STRZERO(LANP->NPARC,3),dtoc(LANP->DTPGTO),TRANSFORM(LANP->NVLPC,"@E 9,999.99"),if(LANP->CPGTO=="1","Sim","Não"),STR(LANP->(RECNO()),10) } TO Parcelas_P OF PGTO_2          
		LANP->(dBskip())
   enddo
endif
PGTO_2.Parcelas_P.Refresh	 
Return

*------------------------------------------------------------------------------*
PROCEDURE NuevoPGTO()
*------------------------------------------------------------------------------*
PGTO_2.T_VLTP.VALUE := 0.00   
PGTO_2.T_ENTRA.VALUE:= space(01)
PGTO_2.T_VLENT.VALUE:= 0.00
PGTO_2.T_PARC.VALUE := 0 
ActivarPGTO()
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarPGTO
*------------------------------------------------------------------------------*
If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')
	If CTRP->(TREG())
		CTRP->(dbdelete())
		CTRP->(dbgotop()) 
		CTRP->(DBUNLOCK())
		if LANP->(DBSEEK(X_PROC))
         do while LANP->(!EOF()) .and. LANP->NPROCE==X_PROC
         	LANP->(TREG())
		      LANP->(dbdelete())
		      LANP->(DBUNLOCK())
		      LANP->(dBskip())
         enddo
      endif
		ActualizarPGTO()
	EndIf
EndIf                                                                                                           
Return
*------------------------------------------------------------------------------*
Procedure ctrParcelas
*------------------------------------------------------------------------------*
local d_dtpgto:=PGTO_2.T_DTPC.VALUE
local n_vlparc:=round(((PGTO_2.T_VLTP.VALUE-PGTO_2.T_VLENT.VALUE)/PGTO_2.T_PARC.VALUE),2)
if PGTO_2.T_PARC.VALUE>0
   If MsgYesNo ('Confirma Criação de Parcelas ?','ATENÇÃO')
      DELETE ITEM ALL FROM Parcelas_P OF PGTO_2
      for x:=1 to PGTO_2.T_PARC.VALUE
          LANP->(DbAppend())
          LANP->NPROCE := x_proc
          LANP->CPF    := x_cpf  
          LANP->NPARC  := x
          LANP->NVLPC  := n_vlparc
          LANP->DTPGTO := d_dtpgto+=30
          LANP->CPGTO  := "2"
          ADD ITEM { STRZERO(x,3),dtoc(d_dtpgto+=30),TRANSFORM(n_vlparc,"@E 9,999.99"),space(01),STR(LANP->(RECNO()),10) } TO Parcelas_P OF PGTO_2          
      next
	endif
	PGTO_2.Parcelas_P.Refresh	 
endif
return 	

*-----------------------
Procedure ALTERALANCP	
*-----------------------
Public chave:=0

CHAVE:=VAL(PegaValorDaColuna( "Parcelas_P" , "PGTO_2" , 5 ))

	DEFINE WINDOW ctrl_l ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 290 ;
		TITLE 'Atualização Lançamento de Pagamentos' ;
		modal ;
		ON INIT ( Abrir_lnc())

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION (LANP->(TREG()),Ativacao_pgto())

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION PGTO_eliminar() 

			BUTTON CERRAR 	;
				CAPTION '&Retorna'	;
				PICTURE 'cerrar' ;
            ACTION ctrl_l.release 

		END TOOLBAR

      @ 70,010 LABEL L_Parc;
               VALUE 'Parcela ';
		       	WIDTH 90           ;
               HEIGHT 30           

      @100,010 LABEL L_valorp;
               VALUE 'R$ Valor';
					WIDTH 80      ;
               HEIGHT 30           
 
      @130,010 LABEL L_dtpg;
               VALUE 'Dt.Pgto';
               WIDTH 80    ;
               HEIGHT 30           
                              
      @160,010 LABEL L_sn;
               VALUE 'Pago ';
               WIDTH 80    ;
               HEIGHT 30           

      @ 70,070 TEXTBOX P_Parc;
               OF ctrl_l ;         		              
               WIDTH 50 

      @100,070 TEXTBOX P_vlpc;
               OF ctrl_l ;         		              
               WIDTH 100 ;
               NUMERIC INPUTMASK '999999.99'
					
		@130,070 DATEPICKER P_dtpg
		
      @160,070 LISTBOX P_sn;
               OF ctrl_l ;
		         WIDTH 80 height 20  ;
		         items {"Sim","Não"}  

      @ 200,100 BUTTON Btn_SPGTO Of ctrl_l        ;
                CAPTION '&Salvar'             ;
                ACTION Salva_PGTO() ;
                WIDTH 80 HEIGHT 27         ;
                FONT "Arial" SIZE 09          ;
                TOOLTIP "Salvar Pagamento" ;
              FLAT

      @ 200,200 BUTTON Btn_CPGTO Of PGTO_2        ;
                CAPTION '&Retorna'		;
                ACTION (LANP->(DBUNLOCK()),ctrl_l.release) ;
	             WIDTH 80 HEIGHT 27		;
                FONT "Arial" SIZE 09		;
                TOOLTIP "Retornar Operação"	;
	           FLAT
 	END WINDOW

	CENTER WINDOW ctrl_l

	ACTIVATE WINDOW ctrl_l

Return Nil

*-----------------------
Procedure Abrir_lnc	
*-----------------------
ctrl_l.P_Parc.enabled:=.f.
ctrl_l.P_vlpc.enabled:=.f. 
ctrl_l.P_dtpg.enabled:=.f. 
ctrl_l.P_sn.enabled  :=.f.

LANP->(DBGOTO(CHAVE))
ctrl_l.P_Parc.value := str(LANP->NPARC,3)  
ctrl_l.P_vlpc.value := LANP->NVLPC 
ctrl_l.P_dtpg.value := LANP->DTPGTO 
ctrl_l.P_sn.value   := val(LANP->CPGTO)
return
	       
*-----------------------
Procedure Ativacao_pgto	
*-----------------------
ctrl_l.P_Parc.enabled:=.t.
ctrl_l.P_vlpc.enabled:=.t. 
ctrl_l.P_dtpg.enabled:=.t. 
ctrl_l.P_sn.enabled  :=.t.
return

*-----------------------
Procedure Salva_PGTO
*-----------------------
LANP->NVLPC := ctrl_l.P_vlpc.value 
LANP->DTPGTO:= ctrl_l.P_dtpg.value
LANP->CPGTO := str(ctrl_l.P_sn.value,1)   
LANP->(DBUNLOCK())
ctrl_l.release
RETURN

*-----------------------
Procedure PGTO_eliminar
*-----------------------
LANP->(DBGOTO(CHAVE))
LANP->(TREG())
LANP->(DBDELETE())
LANP->(DBUNLOCK())
ctrl_l.release
RETURN

