#Include "minigui.ch"

FUNCTION clie
PARAMETERS LIBERA

LiberacaoGSK(LIBERA)  

   Public Nuevo := .F.
		
   Set ToolTipBalloon On
	     	    
	DEFINE WINDOW clien_2;
	           AT 0,0 ;
 				  WIDTH 1000;
              HEIGHT 530;
	           TITLE 'Cadastro Clientes'     	;
				  ICON "TUTOR";
      		  CHILD ;
     		     ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( Filtro_Emp(),DesactivarEdicion(),Actualizar()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( CLI->(dBGoTop()) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( CLI->(dBSkip ( -1 )) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( CLI->(dBSkip (1)) , if ( Eof() , CLI->(DbGoBottom()) , Nil ) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( CLI->(dBGoBottom () ), Clien_2.Browse_1.Value := CLI->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarCLI()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( if(!CINCL,VERLIBERA(1),(Nuevo := .T., Nuevo(), NIL )))

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( if(!CALTE,VERLIBERA(2),(CLI->(TREG()) , ActivarEdicion() , Nil )))

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION if(!CEXCL,VERLIBERA(3),Eliminar())

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;     
            ACTION if(!CIMPR,VERLIBERA(4),IMPCLIENTE()) 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION (Filtro_fechar(),Clien_2.release )

		END TOOLBAR

                @ 56,10 BROWSE Browse_1				;
			            WIDTH 380  				;
                     HEIGHT 360                              ; 
			            HEADERS { 'CPF/CNPJ' , 'Nome ou Razão Social','Telefone' }	;
			            WIDTHS { 130,230,300 }			;
			            WORKAREA cli			;
                     FIELDS { 'Cli->cgc','Cli->descr','CLI->TEL' } ;
			            ON CHANGE Actualizar() ;
			            ON DBLCLICK ( ActivarEdicion() , If ( ! CLI->(TREG()) , DesactivarEdicion() , Nil ) )
            
	                 @ 070,400 LABEL Label_cpf;
		                        VALUE 'CPF/CNPJ'	;
                              WIDTH 80           ;
		                        HEIGHT 30			

                    @ 070,690 LABEL Label_empc ;
                              VALUE 'Empresa '      ;
                              WIDTH 60           ;
                              HEIGHT 30           
                            
	                 @100,400 LABEL Label_Descr;
		                    VALUE 'Nome'	;
                            WIDTH 60           ;
		                    HEIGHT 30			
	         
                    @130,400 LABEL Label_End;
                            VALUE 'Endereço'              ;
                            WIDTH 60           ;
		                    HEIGHT 30		
                            
                    @160,400 LABEL Label_Bairro	;
		                    VALUE 'Bairro'		;
                            WIDTH 60                   ;
		                    HEIGHT 30			
                         
                    @160,690 LABEL Label_Cidade ;
                            VALUE 'Cidade'      ;
                            WIDTH 60           ;
                            HEIGHT 30           
                       
                    @160,900 LABEL Label_UF    ;
                            VALUE 'UF'          ;
                            WIDTH 45                    ;
		                    HEIGHT 30			
							
	                 @190,400 LABEL Label_Cep	;
		                    VALUE 'Cep'		;
                            WIDTH 60           ;
		                    HEIGHT 30				
	                    
				        @190,620 LABEL Label_Pais	;
                            VALUE 'Pais'            ;
                            WIDTH 60                    ;
		                    HEIGHT 30			
	                    
                    @190,820 LABEL Label_Tel ;
                            VALUE 'Fone'  ;
                            WIDTH 60                    ;
		                    HEIGHT 30			
    
	                 @220,400 LABEL Label_Ies	;
		                 VALUE 'Ins.Estadual'	;
                         WIDTH 150           ;
         	            HEIGHT 30				

                    @220,810 LABEL Label_TlCel;
                            VALUE 'Celular'      ;
                            WIDTH 100           ;
                            HEIGHT 30           	
                                      
                    @250,400 LABEL Label_Email;
                            VALUE 'Email'      ;
                            WIDTH 60           ;
                            HEIGHT 30          	

                    @250,810 LABEL Label_Tlfax;
                            VALUE 'Celular'      ;
                            WIDTH 100           ;
                            HEIGHT 30           	
                                         
                    @270,400 LABEL Label_Obs;
                            VALUE 'Observações ' ;
                            WIDTH 150               ;
		                      HEIGHT 30
									 
                    @ 070,470 TEXTBOX T_CGC  ;
                            OF Clien_2 ;
                            WIDTH 150 ;
                            TOOLTIP 'Informe CPF 999.999.999-99 ou CNPJ 99.999.999/9999-99'; 
                            MAXLENGTH 20   ;
                            ON ENTER ( Checa_Cli(clien_2.T_CGC.Value) )
                            
			    	     @ 070,740 COMBOBOX T_EMPCLI;
   			                 ITEMSOURCE EMPC->EMPDESCR;	
					  		        VALUESOURCE EMPC->EMPCLI;
  							        WIDTH 190 HEIGHT 130 
                     			
 		              @100,470 TEXTBOX T_Descr ;
                            OF Clien_2     ;
                            WIDTH 370       ;
                            MAXLENGTH 40   ;
                            ON ENTER clien_2.T_End.SetFocus
	         
                    @130,470 TEXTBOX T_End;
                            OF Clien_2 ;
                            WIDTH 300         ;
                            MAXLENGTH 40      ;
                            ON ENTER clien_2.T_Bairro.SetFocus
                            
	                 @160,470 TEXTBOX T_Bairro	;
                            OF Clien_2 ;
		                    WIDTH 200                    ;
                            MAXLENGTH 20       ;
                            ON ENTER clien_2.T_Cidade.SetFocus
                         
                    @160,740 TEXTBOX T_Cidade ;
                            OF Clien_2 ;
                            WIDTH 130           ;
                            MAXLENGTH 15      ;
                            ON ENTER clien_2.T_UF.SetFocus

                    @160,920 TEXTBOX T_UF    ;
                            OF Clien_2 ;
                            WIDTH 45                    ;
                            MAXLENGTH 02       ;
                            ON ENTER clien_2.T_Cep.SetFocus
	                  
					     @190,470 TEXTBOX T_Cep	;
                            INPUTMASK '99999-999';
                            ON ENTER clien_2.T_Pais.SetFocus 
							
	                 @190,650 TEXTBOX T_Pais	;
                            OF Clien_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 20        ;
                            ON ENTER clien_2.T_Tel.SetFocus
	                    
                    @190,850 TEXTBOX T_Tel ;
 	                          INPUTMASK '(99)99999-9999'
              		                  
	                 @220,470 TEXTBOX T_Ies	;
                            OF Clien_2 ;
		                     WIDTH 150           ;
                            MAXLENGTH 18       ;

                    @220,850 TEXTBOX T_TlCel;
                             INPUTMASK '(99)99999-9999'

                    @250,470 TEXTBOX T_Email;
                            OF Clien_2 ;
                            WIDTH 300           ;
                            MAXLENGTH 60       
                            
                    @250,850 TEXTBOX T_Tlfax;
                             INPUTMASK '(99)99999-9999'
                             									 
                    @290,470 TEXTBOX T_Obs1;
                            OF Clien_2 ;
                            WIDTH 500                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.T_Obs2.SetFocus                        

                    @320,470 TEXTBOX T_Obs2;
                            OF Clien_2 ;
                            WIDTH 500                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.T_Obs3.SetFocus  
 
                    @350,470 TEXTBOX T_Obs3;
                            OF Clien_2 ;
                            WIDTH 500                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.T_Obs4.SetFocus 

                    @380,470 TEXTBOX T_Obs4;
                            OF Clien_2 ;
                            WIDTH 500                    ;
                            MAXLENGTH 30     ;
                            ON ENTER clien_2.Btn_Scli.SetFocus 

	                 @430,670 BUTTON Btn_Scli Of clien_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarEdicion() ;
                          WIDTH 120 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	                 @430,840 BUTTON Btn_Ccli Of clien_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarEdicion() ;
			                  WIDTH 120 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			    FLAT

	END WINDOW

   clien_2.Browse_1.SetFocus
   
	ADD TOOLTIPICON INFO WITH MESSAGE "Preenchimento" OF clien_2
	
	CENTER WINDOW clien_2

	ACTIVATE WINDOW clien_2

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Filtro_Emp()
*------------------------------------------------------------------------------*
cli->(dbsetorder(3))
cli->(ordscope(0,str(CCLIEMP,3)))
cli->(ordscope(1,str(CCLIEMP,3)))
cli->(dbgotop())
return
*------------------------------------------------------------------------------*
PROCEDURE Filtro_fechar()
*------------------------------------------------------------------------------*
cli->(ordscope( 0, NIL )) 
cli->(ordscope( 1, NIL ))
return

*------------------------------------------------------------------------------*
PROCEDURE DesactivarEdicion
*------------------------------------------------------------------------------*
        
         Clien_2.Browse_1.Enabled:= .T.
         Clien_2.T_Descr.Enabled:=.F.
         Clien_2.T_End.Enabled:=.F.
         Clien_2.T_Tel.Enabled:=.F.
         Clien_2.T_Cep.Enabled:=.F.
         Clien_2.T_Cidade.Enabled:=.F.
         Clien_2.T_Uf.Enabled:=.F.
         Clien_2.T_CGC.Enabled:=.F.
         Clien_2.T_IES.Enabled:=.F.
         Clien_2.T_BAIRRO.Enabled:=.F.       
         Clien_2.T_PAIS.Enabled:=.F.
         clien_2.T_OBS1.Enabled:=.F.
         Clien_2.T_OBS2.Enabled:=.F.
         Clien_2.T_OBS3.Enabled:=.F.
         clien_2.T_OBS4.Enabled:=.F.
         Clien_2.T_EMAIL.Enabled:=.F.
         Clien_2.T_tlcel.Enabled:=.F.
         Clien_2.T_tlfax.Enabled:=.F.
         Clien_2.T_EMPCLI.Enabled:=.F.
         Clien_2.Btn_Ccli.Enabled:= .F.
   	   Clien_2.Btn_Scli.Enabled:= .F.

         Clien_2.ToolBar_1.Enabled:= .T.

         Clien_2.Browse_1.SetFocus
			
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarEdicion
*------------------------------------------------------------------------------*
         clien_2.Browse_1.Enabled:= .F.
	      Clien_2.ToolBar_1.Enabled:= .F.
	      Clien_2.T_Descr.Enabled:=.T.
         Clien_2.T_End.Enabled:=.T.
         Clien_2.T_Tel.Enabled:=.T.
         Clien_2.T_Cep.Enabled:=.T.
         Clien_2.T_Cidade.Enabled:=.T.
         Clien_2.T_Uf.Enabled:=.T.
         Clien_2.T_CGC.Enabled:=.T.
         Clien_2.T_IES.Enabled:=.T.
         Clien_2.T_BAIRRO.Enabled:=.T.       
         Clien_2.T_PAIS.Enabled:=.T.
         Clien_2.T_BAIRRO.Enabled:=.T.
         clien_2.T_OBS1.Enabled:=.T.
         Clien_2.T_OBS2.Enabled:=.T.
         Clien_2.T_OBS3.Enabled:=.T.
         clien_2.T_OBS4.Enabled:=.T.
         Clien_2.T_EMAIL.Enabled:=.T.
         Clien_2.T_tlcel.Enabled:=.T.
         Clien_2.T_tlfax.Enabled:=.T.
         Clien_2.T_EMPCLI.Enabled:=.T.
         Clien_2.Btn_Ccli.Enabled:= .T.
    	   Clien_2.Btn_Scli.Enabled:= .T.
    	   Clien_2.T_CGC.setfocus

RETURN NIL
*------------------------------------------------------------------------------*
PROCEDURE CancelarEdicion()
*------------------------------------------------------------------------------*

	DesactivarEdicion()

	Actualizar()

	cli->(dbunlock())

	Nuevo := .F.

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarEdicion()
*------------------------------------------------------------------------------*

DesactivarEdicion()

    If Nuevo == .T.
    	 Cli->(DbAppend())
       clien_2.Browse_1.Value := Cli->(RecNo())
		 Nuevo := .F.
	 EndIf
	  
   clien_2.Browse_1.Value := Cli->(RecNo())

      CLI->DESCR  := Clien_2.T_Descr.Value 
      CLI->END    := Clien_2.T_End.Value 
      CLI->TEL    := Clien_2.T_Tel.Value 
      CLI->CEP    := Clien_2.T_Cep.Value 
      CLI->CIDADE := Clien_2.T_Cidade.Value 
      CLI->UF     := Clien_2.T_Uf.Value 
      CLI->CGC    := Clien_2.T_CGC.Value 
      CLI->IES    := Clien_2.T_IES.Value 
      CLI->PAIS   := Clien_2.T_PAIS.Value 
      CLI->BAIRRO := Clien_2.T_BAIRRO.Value 
      CLI->OBS1   := clien_2.T_OBS1.Value 
      CLI->OBS2   := Clien_2.T_OBS2.Value 
      CLI->OBS3   := Clien_2.T_OBS3.Value 
      CLI->OBS4   := clien_2.T_OBS4.Value 
      CLI->EMAIL  := Clien_2.T_EMAIL.Value 
      CLI->TLCEL  := clien_2.T_TLCEL.Value
      CLI->FAX    := Clien_2.T_tlfax.value
      CLI->CLIEMP := Clien_2.T_EMPCLI.value

	CLI->(DBUNLOCK())
   CLI->(DBGOTO(clien_2.Browse_1.Value))
	
	Clien_2.Browse_1.Refresh

RETURN

*------------------------------------------------------------------------------*
PROCEDURE Actualizar()
*------------------------------------------------------------------------------*
         CLI->(DBGOTO(CLI->(RECNO())))
         Clien_2.T_Descr.Value   := Cli->Descr
         Clien_2.T_End.Value     := cli->end
         Clien_2.T_Tel.Value     := cli->tel
         Clien_2.T_Cep.Value     := cli->cep
         Clien_2.T_Cidade.Value  := cli->cidade
         Clien_2.T_Uf.Value      := cli->uf
         Clien_2.T_CGC.Value     := cli->cgc
         Clien_2.T_IES.Value     := cli->ies
         Clien_2.T_BAIRRO.Value  := cli->bairro       
         Clien_2.T_PAIS.Value    := cli->pais
         clien_2.T_OBS1.Value    := cli->obs1
         Clien_2.T_OBS2.Value    := cli->obs2
         Clien_2.T_OBS3.Value    := cli->obs3
         clien_2.T_OBS4.Value    := cli->obs4
         Clien_2.T_EMAIL.Value   := cli->email
         Clien_2.T_tlcel.value   := cli->TLCEL
         Clien_2.T_tlfax.value   := cli->FAX
         Clien_2.T_EMPCLI.value  := CLI->CLIEMP 
        
         EMPC->(DbSeek(str(Clien_2.T_EMPCLI.value,3)))
return

      	   
*------------------------------------------------------------------------------*
Procedure BuscarCLI
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0 

  nOption:=MsgOptions(,,"Users.Bmp" , {"&CPF","&Nome/Razao Social"}, 2, 20 )

  DO CASE
     CASE nOption = 1
          cli->(dbsetorder(1))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe CPF ou CNPJ' , 'Pesquisa' ) ) )
     CASE nOPTION=2
          cli->(dbsetorder(2))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe nome ou Razao Social' , 'Pesquisa' ) ) )
  ENDCASE 			  
         
  If .Not. Empty(Buscar)
   	SET SOFTSEEK ON
		cli->(DbSeek(Buscar))
      Clien_2.Browse_1.Value := Cli->(RecNo())
		SET SOFTSEEK OFF
	EndIf
Return


*------------------------------------------------------------------------------*
PROCEDURE Nuevo()
*------------------------------------------------------------------------------*
	      Clien_2.T_Descr.Value:=""
         Clien_2.T_End.Value := ""
         Clien_2.T_Tel.Value := ""
         Clien_2.T_Cep.Value := ""
         Clien_2.T_Cidade.Value := ""
         Clien_2.T_Uf.Value := ""
         Clien_2.T_CGC.Value := ""
         Clien_2.T_IES.Value := ""
         Clien_2.T_BAIRRO.Value := ""       
         Clien_2.T_PAIS.Value := ""
         Clien_2.T_BAIRRO.Value := ""
         clien_2.T_OBS1.Value := ""
         Clien_2.T_OBS2.Value := ""
         Clien_2.T_OBS3.Value := ""
         clien_2.T_OBS4.Value := ""
         Clien_2.T_EMAIL.Value := ""
         Clien_2.T_TLCEL.Value :=""
         Clien_2.T_TLfax.Value :=""
         ActivarEdicion()
RETURN

*------------------------------------------------------------------------------*
Procedure Eliminar
*------------------------------------------------------------------------------*
	If MsgYesNo ( "Confirma Exclusão de Cliente ?","Atenção")
		If CLI->(TREG())
			Cli->(dbdelete())
			Cli->(dbunlock())
			Cli->(dbgotop()) 
			clien_2.Browse_1.Value := Cli->(RecNo())
			Actualizar()
		EndIf
	EndIf
Return NIL

**************************************************
PROCEDURE IMPCLIENTE
**************************************************
	DO REPORT								;
        TITLE 'Cadastro de Clientes';
                HEADERS  {'','','','',''} , {'CPF/CPNJ','Razao Social','Cidade','Uf','Fone'};
                FIELDS   {'cli->cgc','cli->descr','cli->CIDADE','cli->UF','cli->tel'};
		WIDTHS   {20,30,20,5,20} 						;
		TOTALS   {.F.,.F.,.F.,.F.,.F.}					;
		WORKAREA cli						;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW		;
		LANDSCAPE					
Return


Procedure Checa_Cli()
**********************************
* verifica possibilidade de inclusão
**********************************
If cli->(DbSeek(clien_2.T_cgc.Value))
   Msginfo("CPF/CNPJ Já Cadastrado!","Verifique")
   CancelarEdicion()
EndIf   
Return NIL
