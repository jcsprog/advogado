#include "MiniGUI.ch"
#include "winprint.ch"
#ifndef __XHARBOUR__
#include "hbcompat.ch"
#endif
#define BM_WIDTH     1
#define BM_HEIGHT    2
******** jcssoft - 
Static lGridFreeze := .t.
Static CONTROLES   := .t.

MEMVAR _BLUE,_YELLOW,_BLACK,_ROSA,_BLUE3
MEMVAR _BLUE2,_YELLOW2,_BLUE5,_VERDE

REQUEST descend
    
FUNCTION MAIN
      SET DELETED ON
      SET CENTURY ON
      SET EXCLUSIVE OFF
      SET DATE BRIT
      SET EPOCH TO 1920
      SET CENTURY ON
      SET DATE FORMAT TO "DD/MM/YYYY"
      SET LANGUAGE TO PORTUGUESE      
      Set Navigation Extended 
      SET ShowDetailError ON
      SET BROWSESYNC ON
      DBCOMMITALL()
     
	   ARQPRINC() 
		VUSUARIO:=""     
   
	   PUBLIC _BLUE:={0,0,255},_YELLOW:={255,255,200},_BLACK:={0,0,0},_ROSA:={255,200,200},_BLUE3:={211,237,250}
      PUBLIC _BLUE2:={0,128,255},_YELLOW2:={255,255,225},_BLUE5:={ 0 , 0 ,255},_VERDE:={0,128,128}
	   PUBLIC ATsm:={"Sim","Nao"},OPERA := "",EMPRESA:=SPACE(30),IMPDV:=1,PAG:=0,LH:=0,nopt:=0
	   PUBLIC cas_n, cas_var, cas_lbl, m_col
      PUBLIC c_txt_back  := {255, 255,   0}
      PUBLIC c_txt_color := {255, 255, 255}
      PUBLIC c_lbl_back  := {0, 255, 255}
      PUBLIC c_lbl_color := {0, 255, 255}
      PUBLIC CINCL:=.F.,CALTE:=.F.,CEXCL:=.F.,CIMPR:=.F.,ADM:=.F.,CCLIEMP:=0

		USE ARQEMP ALIAS EMP NEW SHARED
   	IF SUBSTR(EMP->DESCR,1,5) # "G S K"
		   MSGINFO("JCSoft - Cel.(11) 7378-8895","Sistema Danificado !!")
	      DBCLOSEALL()
	      EXIT PROGRAM
	   ENDIF   
		EMPRESA:=EMP->DESCR
		VNOMEMP:=EMP->DESCR
		USE
     
Define window Form_10 ;
       At 0, 0 ;
       WIDTH GetDesktopWidth() ;
       HEIGHT GetDesktopHeight()-30; 
       Title EMPRESA ;
       MAIN ;
       Icon 'gsk';
       FONT 'ARIAL' SIZE 11 ;      
	    ON INIT	( SENHA(), FORM_10.STATUSBAR.ITEM(2):="Usuario :"+VUSUARIO )    // CASO NECESSITE REORGANIZAR SEM INICIAR INIBIR ESTA LINHA
		 		     	   	   	  
       DEFINE BKGBRUSH newBrush PATTERN IN Form_10 BITMAP GSK.BMP

  Define main menu

      Popup 'Cadastros'
        Item 'Empresa            ' Action EMP(7) IMAGE 'BORRAR' MESSAGE "Cadastro da Empresa"
        Separator
        Item 'Clientes           ' Action CLIE(8) IMAGE 'Clientes' MESSAGE "Cadastro de Clientes"
        Separator
        Item 'Empresas Clientes  ' Action EMPCLIE(9) IMAGE "check" MESSAGE 'Empresas Que Possuem Processos de Clientes'
        Separator        
        Item 'Fim' Action EXIT PROGRAM Image 'br_no'
      End Popup

      Popup 'Processos Diarios'
            Item '&Processos         ' Action CDSPROCES(6) IMAGE 'contactos' MESSAGE "Controle Geral de Processos"
      end popup

      Popup 'Relatorios'
        Item "&Processo" Action ImpProc(7) IMAGE "check" MESSAGE "Relat�rio Dados dos Processos"
        Item "&Pagamentos" Action LSTGTO(7) IMAGE "INFO" MESSAGE "Relat�rio Pagamentos"
        
        Popup 'Prazos' 
               ITEM 'Data Publica��o' Action LSTGTO(2) IMAGE "Free" MESSAGE "Relat�rio com as datas Publica��es"
               ITEM 'Data Fatal' Action teste(2,10) IMAGE "info" MESSAGE "Relat�rio com as datas Fatais "
               ITEM 'Data Recurso' Action teste(3,10) IMAGE "check" MESSAGE "Relat�rio de Recusos realizados do processo"
  		  end popup
        
      End Popup

      Popup 'Utilitarios'
      
        Popup 'Senhas Usuarios ' 
               ITEM 'Inclus�o ' Action USUARIOS(1,7) IMAGE "Free" MESSAGE "Criar Usuario e Libera��o"
               ITEM 'Altera��o' Action USUARIOS(2,7) IMAGE "info" MESSAGE "Alterar Libera��es do Sistema"
               ITEM 'Exclus�o' Action USUARIOS(3,7) IMAGE "check" MESSAGE "Exclus�o de Usuario e Suas Libera��es"
               ITEM 'Troca de Senha' Action USUARIOS(4,7) IMAGE "br_no" MESSAGE "Troca de Senha"
  		  end popup
  		  
        Item 'Reorganizacao   ' Action REORGANIZA(7) IMAGE "info" MESSAGE "Reorganiza��o de Arquivos Atualiza��o de Indices"
        Separator
        Item 'Backup/Restaura��o' Action BACKUPJCS(7) IMAGE "check" MESSAGE "Backup Geral do Sistema / Restaura��o do Sistema"
      End Popup                                                   

   End Menu

		DEFINE STATUSBAR FONT 'MS Sans Serif' SIZE 9 
			STATUSITEM ""
			STATUSITEM "Usuario:" WIDTH 300
			STATUSITEM "Vers�o 1.00" WIDTH 80
			STATUSITEM 'JCSoft Sistemas - Cel:(11)7378-8895' WIDTH 200
			CLOCK WIDTH 85
			DATE 
		END STATUSBAR

      FORM_10.STATUSBAR.ITEM(2):="Usuario: " + VUSUARIO

End Window

Center window Form_10
Activate window Form_10

Return

#include "EMPRESA.PRG"
#include "SENHA.PRG"
#include "PROCESSO.PRG"
#include "INDICE.PRG"
#include "JCSBACK.PRG"
#include "LSTDTS.PRG"
#include "CLIENTE.PRG"
#include "LSTGERAL.PRG"
#include "PAGAMENTO.PRG"
#include "ANDAMENTO.PRG"
#include "PRAZO.PRG"
#include "USUARIOS.PRG"
#include "RLTPROC.PRG"
#include "EMPCLI.PRG"
*/
                 
************************
PROCEDURE ARQPRINC
************************
****CRIA INDICES MATRIZES
IF !FILE("IDJCS1.NTX")
   USE JCSARQ EXCLUSIVE
   INDEX ON NOMEU+STR(COD,5) TO IDJCS1
   INDEX ON SENHAU+STR(COD,5) TO IDJCS2
   USE

   USE LANINDI EXCLUSIVE
   INDEX ON STR(COD,5)+APELIDO+NINDE TO IDLINDC 
   USE

   USE INDICES EXCLUSIVE
   INDEX ON STR(COD,5)+APELIDO TO IDINDIC 
	USE

   DBCLOSEALL()
   
ENDIF   
RETURN NIL

**********************************
PROCEDURE LiberacaoGSK
**********************************
PARAMETERS LIBGSK
IF JCS->(DBSEEK(VUsuario+STR(LIBGSK,5)))
   CINCL:=JCS->INCLU
	CALTE:=JCS->ALTEU 
	CEXCL:=JCS->EXCLU 
	CIMPR:=JCS->IMPRU
	ADM  :=JCS->ADM
ENDIF
RETURN NIL

*****************************
PROCEDURE VERLIBERA(x_info)
*****************************
DO CASE 
   CASE x_info==1 // CINCL=.F.
        MSGINFO("Sem Libera��o p/ Inclus�o!!","Libera��o de Modulos")
	CASE x_info==2 // CALTE=.F.
        MSGINFO("Sem Libera��o p/ Altera��o!!","Libera��o de Modulos")
	CASE x_info==3 // CEXCL=.F.
        MSGINFO("Sem Libera��o p/ Exclus�o!!","Libera��o de Modulos")
	CASE x_info==4 // CIMPR=.F.
        MSGINFO("Sem Libera��o p/ Impress�o!!","Libera��o de Modulos")
	CASE x_info==5 // ADM=.F.
        MSGINFO("Sem Libera��o como ADMINISTRADOR","Libera��o de Modulos")     
ENDCASE
RETURN NIL	

************************
procedure teste
************************
msgbox("Em Fase de Cria��o")
return nil

FUNCTION TREG

TREGCOR:=SETCOLOR()
PRIVATE LIN,COL
LIN := ROW()
COL := COL()
*
IF RLOCK()
   RETURN (.T.) && Travado
ENDIF
*
MSGINFO("REGISTRO EM MANUTENCAO - Tentando Novo Acesso, <ESC> Interrompe")
DO WHILE LASTKEY() # 27 && Tentar Ate Travamento ou Digitacao <ESC>
   IF !RLOCK()
      MSGINFO("Registro Em Manuten��o Tentando Acesso !!! ")
      RETURN(.F.)
   ELSEIF RLOCK()
      RETURN (.T.) && Travado
   ENDIF
   INKEY(.5)
ENDDO
RETURN (.F.)


/*
 * MsgOptions([cText], [cTitle], [cImage], aOptions, [nDefaultOption], [nSeconds])
*/

Function MsgOptions(cText, cTitle, cImage, aOptions, nDefaultOption, nSeconds )
   Local nItem:=0, nBtnWidth:=0, aBtn:=Array(Len(aOptions)), aImgInfo
   Local nBtnPosX:=10, nBtnPosY:=85, cOption:=""

   Default cText           To "SELECIONE UMA OP��O"
   Default cTitle          To "P E S Q U I S A "
   Default cImage          To ""
   Default nDefaultOption  To 1
   Default nSeconds        To 0

   DEFINE FONT _Font_Options FONTNAME "MS Sans Serif" SIZE 11

   //Calcular anchura m�xima de un bot�n para igualarlos todos
   For nItem:=1 To Len(aOptions)
      aOptions[nItem]:=Alltrim(aOptions[nItem])
      nBtnWidth:=Max( GetTextWidth(, aOptions[nItem], GetFontHandle("_Font_Options")), nBtnWidth )
   Next
   nBtnWidth+=5

   DEFINE WINDOW _Options  ;
      AT 0,0               ;
      WIDTH (Len(aOptions)*(10+nBtnWidth))+15 ;
      HEIGHT 155           ;
      TITLE cTitle         ;
      ICON "BUSCAR.ICO"      ;
      MODAL                ;
      NOSIZE               ;
      ON RELEASE IF( IsControlDefined( Timer_1, _Options ), _Options.Timer_1.Release, )

      ON KEY ESCAPE ACTION _Options.Release

      If !Empty(cImage)
         aImgInfo := BmpSize(cImage)
         If !Empty(aImgInfo [BM_WIDTH])
           @ 20, 10 IMAGE _Image PICTURE (cImage) WIDTH aImgInfo [BM_WIDTH] HEIGHT aImgInfo [BM_HEIGHT]
           @ 40, 55 LABEL _Label VALUE cText WIDTH (Len(aOptions)*(10+nBtnWidth))-50 HEIGHT 30 ;
             TRANSPARENT CENTERALIGN FONT "_Font_Options"
         Endif
      Else
           @ 40, 10 LABEL _Label VALUE cText WIDTH (Len(aOptions)*(10+nBtnWidth))-10 HEIGHT 30 ;
             TRANSPARENT CENTERALIGN FONT "_Font_Options"
      Endif

      For nItem:=1 To Len(aOptions)
         aBtn[nItem]:="_Btn_"+Ltrim(Str(nItem))
         cOption:=aBtn[nItem]
         @ nBtnPosY, nBtnPosX BUTTON &cOption CAPTION aOptions[nItem] WIDTH nBtnWidth HEIGHT 25 FONT "_Font_Options" ;
                   ACTION ( cOption:=GetProperty("_Options", This.Name, "Caption"), _Options.Release )
         nBtnPosX+=nBtnWidth+10
      Next

      DoMethod("_Options", aBtn[nDefaultOption], "SetFocus")

      If nSeconds>0
         DEFINE TIMER Timer_1 Interval nSeconds*1000  ;
                ACTION ( cOption:=aOptions[nDefaultOption], _Options.Release )
      Endif

   END WINDOW

   CENTER WINDOW _Options

   ACTIVATE WINDOW _Options

   RELEASE FONT _Font_Options

Return Ascan(aOptions,Alltrim(cOption))

/*
 * MsgLogo(cImage, [nSeconds])
*/

Function MsgLogo( cImage, nSeconds, lRound )

Local aImgInfo:=GetImageSize(cImage), width, height

Default nSeconds To 5, lRound To .F.

   If .Not. IsWindowDefined( _Logo ) .And. .Not. Empty( aImgInfo [BM_WIDTH] )

      width :=aImgInfo [BM_WIDTH]+GetBorderWidth()
      height:=aImgInfo [BM_HEIGHT]+GetBorderHeight()

      DEFINE WINDOW _Logo   ;
         AT 0,0             ;
         WIDTH width        ;
         HEIGHT height      ;
         CHILD TOPMOST      ;
         NOCAPTION          ;
         ON SIZE (_Logo.Width:=width, _Logo.Height:=height) ;
         ON MOUSECLICK _Logo.Release

         @ 0, 0 IMAGE _Image PICTURE (cImage) WIDTH aImgInfo [BM_WIDTH] HEIGHT aImgInfo [BM_HEIGHT]

         DEFINE TIMER Timer_1 INTERVAL nSeconds*1000 ACTION _Logo.Release

      END WINDOW

      If lRound
         SET REGION OF _Logo ROUNDRECT 68,68,width,height
      Endif

      CENTER WINDOW _Logo

      ACTIVATE WINDOW _Logo

   Else
      MsgInfo("No se ha podido llevar a cabo la operaci�n", "Error")
   Endif

Return Nil

*-------------------------------------------------------------
Static Function GetImageSize( cImagePath )
*-------------------------------------------------------------
Local ObjImage, aRetArr:={0,0}

   If FILE( GetStartUpFolder() + '\ximage.dll' )

	objImage := CreateObject( "XStandard.Image" )

	if objImage:Load( cImagePath ) == .T.
		aRetArr[1] := objImage:Width
		aRetArr[2] := objImage:Height
	endif

	objImage := NIL

   Endif

Return aRetArr

*-------------------------------------------------------------
Static Function UnRegXImage()
*-------------------------------------------------------------

	If FILE( GetStartUpFolder() + '\ximage.dll' )
		EXECUTE FILE "regsvr32" PARAMETERS "/u /s XImage.dll" HIDE
	Endif

Return Nil

/*
 * MsgDesktop([cText], [cTitle], [cImage], [lFlash])
*/

Function PegaValorDaColuna( xObj, xForm, nCol)
	 Local nPos := GetProperty ( xForm , xObj , 'Value' )
	 Local aRet := GetProperty ( xForm , xObj , 'Item' , nPos )
Return aRet[nCol]	

FUNCTION OPAQ
PARAMETERS ARQ,MOD
IF .NOT. RIGHT(ARQ,3) = 'DBF'
   ARQ:=ARQ+".DBF"
ENDIF
IF .NOT.FILE(ARQ)
   TONE(500,3)
   MSGINFO("Arquivo "+"("+ARQ+")"+" Inexistente !!!")
   RETURN (.F.)
ENDIF
IF MOD = 1
   USE &ARQ. EXCLUSIVE
   IF NETERR()
      MSGINFO("Abertura Exclusiva "+"("+ARQ+")"+" Negada !!!")
      RETURN (.F.)
   ENDIF
ELSE
   USE &ARQ.
   IF NETERR()
      MSGINFO("Abertura Compartilhada "+"("+ARQ+")"+" Negada !!!")
      RETURN (.F.)
   ENDIF
ENDIF
RETURN (.T.)

FUNCTION MESES
PARAMETERS VDTAD
M:=SUBSTR(DTOC(VDTAD),4,2)
VINIC:=IF(M="01","JANEIRO",IF(M="02","FEVEREIRO",IF(M="03","MARCO",IF(M="04","ABRIL",IF(M="05","MAIO"," ")))))
IF VINIC=" "
   VINIC:=IF(M="06","JUNHO",IF(M="07","JULHO",IF(M="08","AGOSTO",IF(M="09","SETEMBRO",IF(M="10","OUTUBRO",IF(M="11","NOVEMBRO",IF(M="12","DEZEMBRO"," ")))))))
ENDIF
RETURN VINIC


Func  EXTENSO(nValor,nTamI)
nTam:=nTamI

aUNIDADE :={"UM",;
           "DOIS",;
           "TRES",;
           "QUATRO",;
           "CINCO",;
           "SEIS",;
           "SETE",;
           "OITO",;
           "NOVE",;
           "DEZ ",;
           "ONZE",;
           "DOZE",;
           "TREZE",;
           "QUATORZE",;
           "QUINZE",;
           "DEZESSEIS",;
           "DEZESETE",;
           "DEZOITO",;
           "DEZENOVE",}

aDEZENA :={"DEZ",;
           "VINTE",;
          "TRINTA",;
          "QUARENTA",;
          "CINQUENTA",;
          "SESSENTA",;
          "SETENTA",;
          "OITENTA",;
          "NOVENTA",;
          "CEM"}

aCENTENA :={"CENTO",;            
           "DUZENTOS",;
           "TREZENTOS",;
           "QUATROCENTOS",;
           "QUINHENTOS",;
           "SEISCENTOS",;
           "SETECENTOS",;
           "OITOCENTOS",;
           "NOVECENTOS"}
          

nLinha:=1
aExt:={}

/*

   Centena dos Bilhoes
*/

              If  Val(Subst(Str(nValor,15,2),1,3) ) > 0
                  
                  If Val(Subst(Str(nValor,15,2),1,3) ) = 1
                     
                     Anexa(Descr(1,nValor))
                     Anexa(" BILHAO ")
                     Anexa(If(Val(Subst(Str(nValor,15,2),4,9))=0," DE REAIS, ",", "))
                     
                  Else
                      
                     Anexa(Descr(1,nValor))
                     Anexa(" BILHOES ")
                     Anexa(If(Val(Subst(Str(nValor,14,2),4,9))=0," DE REAIS, ",", "))
                     
                  End

              End

/*
  Centena dos Milhoes
*/

              If  Val(Subst(Str(nValor,15,2),4,3) ) > 0
                    
                  If Val(Subst(Str(nValor,15,2),4,3) ) = 1
                     
                     Descr(4,nValor)
                     Anexa(" MILHAO")
                     Anexa(If(Val(Subst(Str(nValor,15,2),7,6))=0," DE REAIS, ",", "))
                  
                  Else
                     
                     Descr(4,nValor)
                     Anexa(" MILHOES")
                     Anexa(If(Val(Subst(Str(nValor,15,2),7,6))=0," DE REAIS, ",", "))
                  
                  End
              
              End

/*              
  
  Milhar dos Reais

*/

              If  Val(Subst(Str(nValor,15,2),7,3)) > 0
                                      
                    Descr(7,nValor)
                    Anexa(" MIL")
                    Anexa(If(Val(Subst(Str(nValor,15,2),10,3))=0," REAIS ",", "))
              
              End

/*              
  
  Centena dos Reais

*/

              If  Val(Subst(Str(nValor,15,2),10,3) ) > 0
                    
                    Descr(10,nValor)
                    Anexa(If(Val(Subst(Str(nValor,15,2),1,12))=1," REAL"," REAIS"))

              End 


/*
   Centavos
*/
              If Val((Right(Str(nValor,15,2),2) )) > 0
                 
                 If Val(Subst(Str(nValor,15,2),1,12)) > 0
                    
                    Anexa(" E ")
          
                 End

                 If  Val((Right(Str(nValor,15,2),2) )) <= 19

                    Anexa( aUnidade[Val(Right(Str(nValor,15,2),2))] )
          
                 Else
             
                    Anexa( aDezena[Val(Subst(Right(Str(nValor,15,2),2),1,1))] )
                    
                    If Val(Subst(Right(Str(nValor,15,2),2),2,1)) > 0
                       
                       Anexa(" E ")
                       Anexa( aUnidade[Val(Subst(Right(Str(nValor,15,2),2),2,1))] )
                    
                    End
                 
                 End

                 Anexa( If(Val(Subst(Str(nValor,15,2),14,2)) = 1," CENTAVO"," CENTAVOS") )
              
              End

              aExt[nLinha]:=aExt[nLinha]+")"

              Return aExt


Static Func Descr(nPos,nValor)                       
     
          If  Val(Subst(Str(nValor,15,2),nPos,1)) != 0 

              If Val(Subst(Str(nValor,15,2),nPos,3)) = 100

                 Anexa(aDezena[10])
        
              Else

                 Anexa(aCentena[Val(Subst(Str(nValor,15,2),nPos,1))])
        
              End

              If Val(Subst(Str(nValor,15,2),++nPos,2)) != 0
           
                 Anexa(" E ")
        
              End            
        
              --nPos
     
          End
                    
          If Val(Subst(Str(nValor,15,2),++nPos,2)) != 0

             If Val(Subst(Str(nValor,15,2),nPos,2)) <= 19

                Anexa(aUnidade[Val(Subst(Str(nValor,15,2),nPos,2))])
              
             Else

                Anexa(aDezena[Val(Subst(Str(nValor,15,2),nPos,1))])
           
                If Val(Subst(Str(nValor,15,2),++nPos,1)) != 0

                   Anexa(" E ")
                   Anexa(aUnidade[Val(Subst(Str(nValor,15,2),nPos,1))])
                
                End

             End
          
          End

     Return 


Static Proc Anexa(cLinha)
           
       If !Empty(aExt)
          
          If Len(aExt[nLinha])+Len(cLinha) > nTam

             ++nLinha
             
             AADD(aExt,clinha)

          Else
             
             aExt[nLinha]:=aExt[nlinha]+cLinha
          
          End
       
       Else

          AADD(aExt,"("+clinha)
       
       End   
     
       Return


Func Protecao(dDataI,dDataF)
     
     LOCAL dAux

     If dDataf != NIL
        dAux := dDataI
        
     Else

        dDataf := dDataI
        dAux   := dDataI
        
     End

     Do while dAux <= dDataf

        If Prot->( DBSeek(dAux) )
              
           If Prot->Status
                 
              If Prot->Tipo = "P" .And. AllTrim(cUsuario)=Prot->User
                    
                 Return .T.
               
              End
              
              ALERT("Acesso nao permitido, Data protegida.")
              Return .F.
              
           End
           
        End

     dAux := dAux +1
     End
     
     Return .T.


FUNCTION Shadow( nTop, nLeft, nBottom, nRight )
   LOCAL nShadowLen, cShadow

   cShadow := SAVESCREEN( nTop, nLeft, nBottom, nRight )
   nShadowLen := LEN(cShadow)
   
   RESTSCREEN( nTop, nLeft, nBottom, nRight,;
               TRANSFORM(cShadow, REPLICATE("X" + CHR(7), nShadowLen)))
   RETURN (.T.)

//////////////////////////////
// This function prints the entire file in one call to PrintFileRaw()
FUNCTION WinPrintRaw(cPrinter,cFileName,cDocumentName)
//////////////////////////////
  LOCAL nPrn:= -1, cMess:= "WinPrintRaw(): "

  IF !EMPTY(cFilename)
    IF (nPrn := PrintFileRaw(cPrinter,cFileName,cDocumentName)) < 0
      DO CASE
      CASE nPrn = -1
        Alert(cMess+"Parametros Informados Est�o Incorretos")
      CASE nPrn = -2
        Alert(cMess+"WINAPI OpenPrinter() Falhou")
      CASE nPrn = -3
        Alert(cMess+"WINAPI StartDocPrinter() Falhou")
      CASE nPrn = -4
        Alert(cMess+"WINAPI StartPagePrinter() Falhou")
      CASE nPrn = -5
        Alert(cMess+"WINAPI malloc() Sem Memoria Falhou")
      CASE nPrn = -6
        Alert(cMess+"WINAPI CreateFile() N�o Criado Falhou"+cFileName+" N�o Encontrado?")
      ENDCASE
    ENDIF
  ENDIF

RETURN(nPrn)

#pragma BEGINDUMP

#undef UNICODE

#include <windows.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"

#define MAX_FILE_NAME 1024
#define BIG_BUFFER (1024*32)

HB_FUNC ( ENUMPRINTERS )
{
  UCHAR *Result ;
  DWORD x, Flags = PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS ;
  LPSTR Name = NULL ;
  DWORD Level = 5 ;
  PRINTER_INFO_5 *pPrinterEnum, *pFree;
  PRINTER_INFO_4 *pPrinterEnum4, *pFree4;
  DWORD cbBuf  ;
  DWORD BytesNeeded=0 ;
  DWORD NumOfPrinters=0 ;
  OSVERSIONINFO osvi ;  //  altered to check Windows Version
  osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
  GetVersionEx (&osvi);
  if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
  {
    Level = 4 ;
    EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum4,0,&BytesNeeded,&NumOfPrinters) ;
    if (BytesNeeded > 0)
    {
      Result = (UCHAR *) hb_xgrab(BytesNeeded) ;
      *Result = '\0' ;
      pFree4 = pPrinterEnum4 = (PRINTER_INFO_4 *)  hb_xgrab(BytesNeeded) ;
      cbBuf = BytesNeeded ;
      if (EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum4,cbBuf,&BytesNeeded,&NumOfPrinters))
      {
        for (x=0 ; x < NumOfPrinters ; x++, pPrinterEnum4++ )
        {
          strcat(Result,pPrinterEnum4->pPrinterName) ;
          strcat(Result,";") ;
        }
      }
      hb_retc(Result) ;
      hb_xfree(Result) ;
      hb_xfree(pFree4) ;
    }
    else
      hb_retc("") ;
  }
  else
   {
    EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum,0,&BytesNeeded,&NumOfPrinters) ;
    if (BytesNeeded > 0)
    {
      Result = (UCHAR *) hb_xgrab(BytesNeeded) ;
      *Result = '\0' ;
      pFree = pPrinterEnum = (PRINTER_INFO_5 *)  hb_xgrab(BytesNeeded) ;
      cbBuf = BytesNeeded ;
      if (EnumPrinters(Flags,Name,Level,(LPBYTE) pPrinterEnum,cbBuf,&BytesNeeded,&NumOfPrinters))
      {
        for (x=0 ; x < NumOfPrinters ; x++, pPrinterEnum++ )
        {
          strcat(Result,pPrinterEnum->pPrinterName) ;
          strcat(Result,";") ;
        }
      }
      hb_retc(Result) ;
      hb_xfree(Result) ;
      hb_xfree(pFree) ;
    }
    else
      hb_retc("") ;
  }
}

HB_FUNC( WINDEFAULTPRINTER )
{
  DWORD x, y ;
  UCHAR lpReturnedString[MAX_FILE_NAME] ;
  x = GetProfileString("windows","device","",lpReturnedString,MAX_FILE_NAME-1);
  y = 0 ;
  while ( y < x && lpReturnedString[y] != ',' )
    y++ ;
  hb_retclen(lpReturnedString,y) ;
}

HB_FUNC( PRINTFILERAW )
{
  UCHAR  printBuffer[BIG_BUFFER], *cPrinterName, *cFileName, *cDocName ;
  HANDLE  hPrinter, hFile ;
  DOC_INFO_1 DocInfo ;
  DWORD nRead, nWritten, rVal = -1 ;
/*
  if (ISCHAR(1) && ISCHAR(2))
  {
    cPrinterName= (UCHAR*)hb_parc(1) ;
    cFileName= (UCHAR*)hb_parc(2) ;
    if ( OpenPrinter(cPrinterName, &hPrinter, NULL) != 0 )
    {
      DocInfo.pDocName = (UCHAR*)hb_parc(3) ;
      DocInfo.pOutputFile = NULL ;
      DocInfo.pDatatype = "RAW" ;
      if ( StartDocPrinter(hPrinter,1,(char *) &DocInfo) != 0 )
      {
        if ( StartPagePrinter(hPrinter) != 0 )
        {
          hFile = CreateFile(cFileName,GENERIC_READ,0,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL)   ;
          if (hFile != INVALID_HANDLE_VALUE )
           {
            while (ReadFile(hFile, printBuffer, BIG_BUFFER, &nRead, NULL) && (nRead > 0))
            {
              if (printBuffer[nRead-1] == 26 )
                nRead-- ; // Skip the EOF() character
              WritePrinter(hPrinter, printBuffer, nRead, &nWritten) ;
            }
            rVal = 1 ;
            CloseHandle(hFile) ;
          }
          else
            rVal= -6 ;
          EndPagePrinter(hPrinter) ;  // 28/11/2001 10:16
        }
        else
          rVal = -4 ;
        EndDocPrinter(hPrinter);
      }
      else
        rVal= -3 ;
      ClosePrinter(hPrinter) ;
    }
    else
      rVal= -2 ;
  }
*/
  hb_retnl(rVal) ;
}

#pragma ENDUMP
