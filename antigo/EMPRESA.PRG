#Include "minigui.ch"
#define BLUE { 0, 0, 128 }

PROCEDURE EMP()
PARAMETERS LIBERA
LiberacaoGSK(LIBERA)
if adm==0
   MSGINFO("Sem Liberação de Modulos")
   return
endif

        i := 0
   	
        DEFINE WINDOW form_2 ;
	         	AT 0,0			;
	         	WIDTH 630		;
		         HEIGHT 320                   	;
		         TITLE 'Cadastro da Empresa'		;
 				   CHILD ;
		         ON MAXIMIZE ThisWindow.Center ;
				   ON INIT ( AbrirEmp() ) 
                                    
                @ 10,10 LABEL Label_Codigo ;
                        VALUE 'Codigo'    ;
                        WIDTH 60           

                @ 40,10 LABEL Label_Nome   ;
                        VALUE 'Nome '   ;
                        WIDTH 60                     

	             @ 70,10 LABEL Label_Endereco	;
  		                  VALUE 'Endereço'		;
                        WIDTH 60                    

                @100,10 LABEL Label_Bairro ;
                        VALUE 'Bairro'      ;
                        WIDTH 60                   

                @100,230 LABEL Label_Cidade ;
                        VALUE 'Cidade'      ;
                        WIDTH 60                   

	             @100,440 LABEL Label_Cep		;
		                  VALUE 'Cep'		;
                        WIDTH 29                         

                @130,10 LABEL Label_CGC ;
                        VALUE 'CGC'              ;
                        WIDTH 60                 

                @130,345 LABEL Label_ESTADO        ;
                        VALUE 'Estado'              ;
                        WIDTH 45                           

	             @160,10 LABEL Label_Fone1	;
                        VALUE 'TeleFone'            ;
                        WIDTH 60                        

	             @190,10 LABEL Label_Email	;
		                  VALUE 'e-mail'		;
                        WIDTH 60                 

	             @ 10,70 TEXTBOX T_Codigo ;
		                  WIDTH 40			;
                        ON ENTER Form_2.T_Nome.SetFocus

                @ 40,70 TEXTBOX T_Nome          ; 
                        OF Form_2         ;
                        WIDTH 300         ;
                        MAXLENGTH 30        ;
                        UPPERCASE         ;
                        ON ENTER Form_2.T_Endereco.SetFocus

                @ 70,70 TEXTBOX T_Endereco	;
                        OF Form_2          ;
	                     WIDTH 350		;
                        MAXLENGTH 40        ;
                        UPPERCASE ;
                        ON ENTER Form_2.T_BAIRRO.SetFocus

                @100,70 TEXTBOX T_BAIRRO   ;
                        OF Form_2          ; 
                        WIDTH 150         ;
                        MAXLENGTH 20    ;
                        ON ENTER Form_2.T_CIDADE.SetFocus
                 
                @100,290 TEXTBOX T_CIDADE  ;
                        OF Form_2          ; 
                        WIDTH 130         ;
                        MAXLENGTH 20    ;
                        ON ENTER Form_2.T_Cep.SetFocus

                @100,480 TEXTBOX T_Cep   ;
                         OF Form_2             ; 
                         INPUTMASK '99999-999' ;
                         ON ENTER Form_2.T_CGC.SetFocus

                @130,70 TEXTBOX T_CGC ;
                        OF Form_2         ;
                        WIDTH 250         ;
                        MAXLENGTH 18 ;
                        ON ENTER Form_2.T_Estado.SetFocus

                @130,390 TEXTBOX T_Estado	;
		                  OF Form_2		;
		                  WIDTH 30		;
                        MAXLENGTH 02 ;
                        ON ENTER Form_2.T_Fone1.SetFocus

                @160,70 TEXTBOX T_Fone1   ;
                        OF Form_2 ;
                        WIDTH 110         ;
                        MAXLENGTH "(99) 9999-9999" 

                @190,70 TEXTBOX T_Email ;
	                     OF Form_2		;
		                  WIDTH 400		;
		                  MAXLENGTH 40	

	             @ 240,300 BUTTON Btn_Salvar Of Form_2	;
                        CAPTION '&Salvar'             ;
                        ACTION Salvar_Registro()            ;       
                        WIDTH 80 HEIGHT 27         ;
                        FONT "Arial" SIZE 09          ;
                        TOOLTIP "Salvar Registro" ;
                     FLAT

	             @ 240,450  BUTTON Btn_Cancelar Of Form_2	;
		                  CAPTION '&Cancelar'		;
			               ACTION Sair_do_Form2()		;       
 			               WIDTH 80 HEIGHT 27		;
		                  TOOLTIP "Cancelar Operação"	;
			            FLAT

	END WINDOW

   CENTER WINDOW   Form_2
   
	ACTIVATE WINDOW Form_2
Return 

Procedure AbrirEmp
           Form_2.T_Codigo.ENABLED := .F.
           Form_2.T_Nome.ENABLED   := .F.
           Form_2.T_Codigo.Value  := EMP->CODIGO 
           Form_2.T_Nome.Value    := EMP->DESCR  
           Form_2.T_Endereco.Value:= EMP->END
           Form_2.T_Fone1.Value   := EMP->TEL    
           Form_2.T_Cep.Value     := EMP->CEP    
           Form_2.T_Cidade.Value  := EMP->CIDADE 
           Form_2.T_Estado.Value  := EMP->UF
           Form_2.T_cgc.Value    := EMP->CGC   
           Form_2.T_Email.Value   := EMP->IES    
           Form_2.T_BAIRRO.Value  := EMP->BAIRRO 
           Form_2.T_Codigo.ENABLED:=.F. 
           Form_2.T_Nome.ENABLED  :=.F.
return nil

Procedure Salvar_Registro
        if ADM==1
           MSGINFO("Sem Liberação !!","Apenas Administrador")
           RETURN NIL
        ENDIF
        IF EMP->(TREG())
           EMP->CODIGO := Form_2.T_Codigo.Value
           EMP->DESCR  := Form_2.T_Nome.Value
           EMP->END    := Form_2.T_Endereco.Value
           EMP->TEL    := Form_2.T_Fone1.Value
           EMP->CEP    := Form_2.T_Cep.Value 
           EMP->CIDADE := Form_2.T_Cidade.Value 
           EMP->UF     := Form_2.T_Estado.Value
           EMP->CGC    := Form_2.T_cgc.Value 
           EMP->IES    := Form_2.T_Email.Value 
           EMP->BAIRRO := Form_2.T_BAIRRO.Value 
           EMP->(DBUnlock())
           MsgInfo( "Registo Alterado!!" )
        EndIf

        Form_2.Release 
        Return 


Function Sair_do_Form2()
        Form_2.Release
        Return 

*/


