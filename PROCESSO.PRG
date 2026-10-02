#Include "minigui.ch"

function CDSPROCES
PARAMETERS LIBERA

LiberacaoGSK(LIBERA)

  	Public Nuevo := .F.

	DEFINE WINDOW PRC_2;
	           AT 0,0 ;
              WIDTH GetDesktopWidth();
              HEIGHT GetDesktopHeight()-60 ; 
	           TITLE 'Controle Geral de Processos' 	;
				  ICON "TUTOR";
				  CHILD ;
		        ON MAXIMIZE ThisWindow.Center ;
		        FONT 'ARIAL' SIZE 10;		
		        ON INIT ( DesactivPRC(), ActualizarPRC() )   

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 80,35 FLAT BORDER

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
				ACTION ( if(!CINCL,VERLIBERA(1),(Nuevo := .T., NuevoPRC(), NIL )))

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( if(!CALTE,VERLIBERA(2),(PRC->(TREG()) ,ActualizarPRC(), Nil )))

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION if(!CEXCL,VERLIBERA(3),EliminarPRC() )

			BUTTON PAGAMENTO 	;
				CAPTION '&Pagamentos';
				PICTURE 'receber' ;
            ACTION PGTOS(PRC->CPF,PRC->NPROCE,4)

   		BUTTON ANDAMENTO 	;
				CAPTION '&Andamento';
				PICTURE 'anda' ;
            ACTION ANDAME(PRC->CPF,PRC->NPROCE,3) 

   		BUTTON PRAZO 	;
				CAPTION '&Prazos';
				PICTURE 'acesso' ;
				ACTION PRAZOS(PRC->CPF,PRC->NPROCE,6) 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION PRC_2.release 

		END TOOLBAR

            @ 56,10 BROWSE Browse_1	;
		        	     WIDTH 500 		;
                    HEIGHT 190      ; 
			           HEADERS {'NºProcesso','Nome/Razão Social','CPF/CNPJ'};
		        	     WIDTHS {130,230,130 }			;
                    FONT "Arial" SIZE 09 ;
			           WORKAREA PRC			;
                    FIELDS {'PRC->NPROCE','if(CLI->(DBSEEK(PRC->CPF)),CLI->DESCR,"Não Encontrado")','PRC->CPF'} ;
                    ON CHANGE ActualizarPRC() ;
			           ON DBLCLICK ( ActivarPRC() , If (PRC->(!TREG()) , DesactivPRC() , Nil ) ) 

                     @ 70,530 LABEL L_nproce;
                              VALUE 'Processo';
						          	WIDTH 90           ;
                              HEIGHT 30           

                     @ 70,790 LABEL L_CPF;
                              VALUE 'Cpf/Cnpj';
						          	WIDTH 80      ;
                              HEIGHT 30           
 
                     @100,530 LABEL L_NOME;
                              VALUE 'Nome';
                              WIDTH 80    ;
                              HEIGHT 30           
                              
                     @130,530 LABEL L_forum;
                              VALUE 'Forum';
                              WIDTH 80    ;
                              HEIGHT 30           

                     @160,530 LABEL L_vara;
                              VALUE 'Vara';
                              WIDTH 80    ;
                              HEIGHT 30           

                     @190,530 LABEL L_DESCR;
                              VALUE 'Descrição';
                              WIDTH 80    ;
                              HEIGHT 30     

					     @ 70,600 TEXTBOX N_PROCE;
                             OF PRC_2 ;         		              
                             WIDTH 170; 
									  MAXLENGTH 35 ;                             								
     							     ON ENTER (Checa_Proc(),PRC_2.N_CPF.SETFOCUS)
    							     
				    	  @ 70,850 TEXTBOX N_CPF                     ;
                             WIDTH 180                         ;
                             TOOLTIP "Digite o CPF/CNPJ para PESQUISA" ;
                             FONT "MS SANS SERIF" SIZE 11 BOLD;
                             BACKCOLOR _YELLOW2 FONTCOLOR _VERDE  ;
                             MAXLENGTH 19 UPPERCASE                ;
                             ON GOTFOCUS This.BackColor:= _BLUE3  ;
                             ON LOSTFOCUS This.BackColor:=_YELLOW2;
                             ON CHANGE { || DADOSCLI() } 

                    @100,850 Grid BROWSE_F ;
		            	       WIDTH 450 		;
                            HEIGHT 140      ; 
			                   HEADERS { 'CPF/CNPJ' , 'Nome/Razao Social'}	;
			                   WIDTHS { 130,310};
						          ON CHANGE ( PEGACLI()) 	

                    @100,600 TEXTBOX N_NOME ;
                             WIDTH 230   ;
                             MAXLENGTH 30 ;
                             ON ENTER (PRC_2.N_FORUM.SETFOCUS)

                    @130,600 TEXTBOX N_FORUM ;
                             WIDTH 150 ;
                             MAXLENGTH 30;
                             ON ENTER (PRC_2.N_VARA.SETFOCUS)

                    @160,600 TEXTBOX N_VARA ;
                             WIDTH 90     ;
                             MAXLENGTH 10 ;
                             ON ENTER (PRC_2.N_DESCR.SETFOCUS)

                    @190,600 TEXTBOX N_DESCR;
                             WIDTH 230;
                             MAXLENGTH 30
                             
                    @280,010 FRAME Frame_P ;
                             CAPTION  "Pagamentos" ;
									  WIDTH 420 ;
									  HEIGHT 370 ;
									  FONT 'ARIAL' SIZE 14
									  
                    @330,030 LABEL P_vltp;
                              VALUE "Valor Total R$ ";
                              WIDTH 110           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09
  	                           
                     @330,120 TEXTBOX T_VLTP;
						            OF PRC_2 ;
						            WIDTH 70    
                              
                    @330,200 LABEL P_entra ;
                              VALUE "Entrada ";
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09

                     @330,270 TEXTBOX T_ENTRA;
						            OF PRC_2 ;
						            WIDTH 20    
  	                           
                    @360,030 LABEL P_vlent ;
                              VALUE "R$ Entrada ";
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09

                    @360,120 TEXTBOX T_VLENT;
						            OF PRC_2 ;
						            WIDTH 70    
  	                           
                    @360,200 LABEL P_parc ;
                              VALUE "NºParcelas";
                              WIDTH 80           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09

                    @360,270 TEXTBOX T_PARC;
						            OF PRC_2 ;
						            WIDTH 30    

                    @330,320 LABEL P_dtpc ;
                              VALUE "Dt.Parcelas ";
                              WIDTH 100           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 09

                    @360,320 TEXTBOX T_DTPC;
						            OF PRC_2 ;
						            WIDTH 80    
  	                           
                    @400,030 LABEL Grid_P ;
                              VALUE "Controle de Parcelas";
                              WIDTH 400           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 14  	                           

					      @430,030 Grid Parcelas_P ;
		            	         WIDTH 340 		;
                              HEIGHT 130      ; 
			                     HEADERS { 'Parcela' , 'Data Parcela','Valor da Parcela'};	
			                     WIDTHS { 90,110,140}
                     
                     @280,450 FRAME Frame_A ;
                             CAPTION  "Andamentos" ;
									  WIDTH 400 ;
									  HEIGHT 370 ;
									  FONT 'ARIAL' SIZE 14
									  
                    @400,460 LABEL Grid_A ;
                              VALUE "Controle de Andamento";
                              WIDTH 400           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 14 
  	                           
					      @430,460 Grid Parcelas_A ;
		            	         WIDTH 360 		;
                              HEIGHT 130      ; 
                 			      HEADERS { 'Dt.Andamento' , 'Obs.(1)','Obs.(2)','Obs.(3)','Obs.(4)' }	;
			                     WIDTHS { 90,100,100,100,100}

                     @280,820 FRAME Frame_Z ;
                             CAPTION  "   Prazos" ;
									  WIDTH 600 ;
									  HEIGHT 370 ;
									  FONT 'ARIAL' SIZE 14
									  
                     @400,860 LABEL Grid_Z ;
                              VALUE "Controle de Prazos";
                              WIDTH 400           ;
                              HEIGHT 30           ;
  	                           FONT 'Arial' SIZE 14 
  	                           
					      @430,860 Grid Parcelas_Z ;
		            	         WIDTH 460 		;
                              HEIGHT 130      ; 
                 			      HEADERS { 'Dt.Publicação','Publicação','Dt.Fatal','Obs.','RC','Dt.Recurso','Recurso' } ;
			                     WIDTHS {80,100,100,100,100,100,100}
                             
                    @230,600 BUTTON Btn_SPROCES Of PRC_2        ;
                              CAPTION '&Salvar Processo'             ;
                              ACTION AceptarPRC() ;
                              WIDTH 110 HEIGHT 25         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Processo" ;
                            FLAT

                    @230,740 BUTTON Btn_CPROCES Of PRC_2        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarPRC() ;
		                        WIDTH 090 HEIGHT 25		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                   FLAT
                
	END WINDOW

   PRC_2.Browse_1.SetFocus
		
	CENTER WINDOW PRC_2

	ACTIVATE WINDOW PRC_2

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivPRC
*------------------------------------------------------------------------------*
PRC_2.Browse_1.Enabled :=.T.
PRC_2.BROWSE_F.Enabled :=.F.
PRC_2.N_PROCE.Enabled :=.F.
PRC_2.N_CPF.Enabled :=.F.
PRC_2.N_NOME.Enabled :=.F.
PRC_2.N_FORUM.Enabled :=.F.
PRC_2.N_VARA.Enabled :=.F.
PRC_2.N_DESCR.Enabled :=.F.
PRC_2.Btn_CPROCES.Enabled:=.F.
PRC_2.Btn_SPROCES.Enabled:=.F.
PRC_2.ToolBar_1.Enabled:=.T.
PRC_2.Browse_1.SetFocus
PRC_2.Parcelas_P.Enabled:=.T.
PRC_2.Parcelas_A.Enabled:=.T.
PRC_2.Parcelas_Z.Enabled:=.T.
PRC_2.T_VLTP.Enabled:=.F.
PRC_2.T_ENTRA.Enabled:=.F.
PRC_2.T_VLENT.Enabled:=.F.
PRC_2.T_PARC.Enabled:=.F.
PRC_2.T_DTPC.ENABLED:=.F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarPRC
*------------------------------------------------------------------------------*
PRC_2.Browse_1.Enabled :=.F.
PRC_2.ToolBar_1.Enabled:=.F.
if Nuevo == .T.
   PRC_2.N_CPF.Enabled    :=.T.
   PRC_2.N_PROCE.Enabled  :=.T.
   PRC_2.N_PROCE.SETFOCUS
else
   PRC_2.N_FORUM.setfocus
endif
PRC_2.N_FORUM.Enabled  :=.t.
PRC_2.N_VARA.Enabled   :=.t.
PRC_2.N_DESCR.Enabled  :=.t.
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
PRC->CPF      :=PRC_2.N_CPF.VALUE     
PRC->NPROCE   :=PRC_2.N_PROCE.VALUE
PRC->FORUM    :=PRC_2.N_FORUM.VALUE 
PRC->VARA     :=PRC_2.N_VARA.VALUE
PRC->DESCRICAO:=PRC_2.N_DESCR.VALUE
PRC_2.Browse_1.Refresh
If Nuevo == .T.
   PRC_2.Browse_1.Value := PRC->(RecNo())
EndIf
PRC->(DBUNLOCK())
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActualizarPRC()
*------------------------------------------------------------------------------*
PRC->(Dbgoto(PRC->(RecNo())))                             
PRC_2.N_PROCE.VALUE :=PRC->NPROCE
PRC_2.N_CPF.VALUE   :=PRC->CPF
PRC_2.N_NOME.VALUE  :=if(cli->(DBSEEK(PRC->CPF)),CLI->DESCR,"Não Encontrado")     
PRC_2.N_FORUM.value :=PRC->FORUM
PRC_2.N_VARA.value  :=PRC->VARA
PRC_2.N_DESCR.value :=PRC->DESCRICAO

CTRP->(Dbseek(PRC->NPROCE))
PRC_2.T_VLTP.value := transform(CTRP->NVLT,"@E 999,999.99")   
PRC_2.T_ENTRA.value:= if(CTRP->ENTRADA="1","S","N")
PRC_2.T_VLENT.value:= transform(CTRP->NVLENTRA,"@E 999,999.99")
PRC_2.T_PARC.value := strzero(CTRP->NQTP,3)  
PRC_2.T_DTPC.value := dtoc(CTRP->DTPGTO)
DELETE ITEM ALL FROM Parcelas_P OF PRC_2
DELETE ITEM ALL FROM Parcelas_A OF PRC_2
DELETE ITEM ALL FROM Parcelas_Z OF PRC_2

if LANP->(DBSEEK(PRC->NPROCE))
   do while LANP->(!EOF()) .and. LANP->NPROCE==PRC->NPROCE
      ADD ITEM { STRZERO(LANP->NPARC,3),dtoc(LANP->DTPGTO),TRANSFORM(LANP->NVLPC,"@E 9,999.99") } TO Parcelas_P OF PRC_2          
		LANP->(dBskip())
   enddo
endif

if AND->(DBSEEK(PRC->NPROCE))
   do while AND->(!EOF()) .and. AND->NPROCE==PRC->NPROCE
      ADD ITEM { dtoc(AND->DTANDA),AND->AOBS1,AND->AOBS2,AND->AOBS3,AND->AOBS4} TO Parcelas_A OF PRC_2          
		AND->(dBskip())
   enddo
endif

if PRA->(DBSEEK(PRC->NPROCE))
   do while PRA->(!EOF()) .and. PRA->NPROCE==PRC->NPROCE
      ADD ITEM { dtoc(PRA->DTPUBLI),PRA->PUBLICA,dtoc(PRA->DTFATAL),PRA->POBS1,if(PRA->RECURSO='1','Sim','Não'),dtoc(PRA->DTREC),PRA->NRECURSO} TO Parcelas_Z OF PRC_2          
		PRA->(dBskip())
   enddo
endif

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
PRC_2.N_CPF.VALUE   :=SPACE(19)
PRC_2.N_NOME.VALUE  :=SPACE(30)
PRC_2.N_PROCE.VALUE :=SPACE(35)
PRC_2.N_FORUM.value :=SPACE(30)
PRC_2.N_VARA.value  :=SPACE(10)
PRC_2.N_DESCR.value :=SPACE(30)
PRC_2.BROWSE_F.Enabled :=.T.
ActivarPRC()
RETURN

*------------------------------------------------------------------------------*
Procedure EliminarPRC
*------------------------------------------------------------------------------*
If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')
	If PRC->(TREG())
		PRC->(dbdelete())
		PRC->(DBUNLOCK())
		PRC->(dbgotop()) 
      PRC_2.Browse_1.Value := PRC->(RecNo())
		ActualizarPRC()
	EndIf
EndIf
Return

Procedure Checa_Proc()
**********************************
* verifica possibilidade de inclusão
**********************************
If prc->(DbSeek(PRC_2.N_PROCE.VALUE))
   Msginfo("N.Processo Já Cadastrado!","Verifique")
   CancelarPRC()
EndIf   
Return NIL

*------------------------------------------------------------------------------*
PROCEDURE PEGACLI()
*------------------------------------------------------------------------------*
PRC_2.N_CPF.Value:=PegaValorDaColuna( "BROWSE_F" , "PRC_2" , 1 )
PRC_2.N_NOME.VALUE:=PegaValorDaColuna( "BROWSE_F" , "PRC_2" , 2 ) 
if cli->(dbseek(PRC_2.N_CPF.Value))
   PRC_2.N_NOME.VALUE:=cli->descr
endif   
//ACTUACLI()
Return NIL

Function DadosCli()
Local cPesq := Upper(AllTrim( PRC_2.N_CPF.VALUE ))
Local nTamanhoNomeParaPESQUISA		:= Len(cPesq)
Local nQuantRegistrosProcessados	:= 0
Local nQuantMaximaDeRegistrosNoGRID	:= 70
Local cCAMPO := "CGC"

CLI->(DBSETORDER(1))

*** Efetua PESQUISA no Arquivo para posicionar no primeiro registro que satisfaça a condição
CLI->(DBSeek( cPesq ))

*** Exclui todos os registros do GRID
DELETE ITEM ALL FROM BROWSE_F OF PRC_2

*** Entra no Laço (While ) até que encontre o fim do arquivo
DO WHILE CLI->(!Eof())
   *** Se o Substr do apelido for igual à variavel cPesq ( Conteúdo do campo TXTPESQUISA)
   If Substr( CLI->&cCAMPO,1,nTamanhoNomeParaPESQUISA) == cPesq
      *** Acumula contador
      nQuantRegistrosProcessados += 1
      *** Se a quantidade de resgistros lidos atingiu o limite de registros definidos para o GRID sai do laço/While
      if nQuantRegistrosProcessados > nQuantMaximaDeRegistrosNoGRID
         EXIT
      EndIf
      *** Adiciona registro no GRID
      ADD ITEM { CLI->CGC,CLI->DESCR} TO BROWSE_F OF PRC_2
      *** Se o Substr de Apelido estiver fora da faixa de PESQUISA, abandona o laço
  ElseIf Substr( CLI->&cCAMPO,1,nTamanhoNomeParaPESQUISA) > cPesq
     EXIT
  Endif
  ** Pula para Próximo registro
  CLI->(DBSkip())
ENDDO

Return Nil 

