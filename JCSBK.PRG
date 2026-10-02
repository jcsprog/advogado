#include <minigui.ch>

#command COMPRESS [ FILES ] <afiles> ;
		TO <zipfile> ;
		BLOCK <block>  ;
		[ LEVEL <level> ] ;
		[ <ovr: OVERWRITE> ] ;
		[ <spt: STOREPATH> ] ;
=> ;
	COMPRESSFILES ( <zipfile>, <afiles>, <level> , <block> , <.ovr.> , <.spt.> )

#command UNCOMPRESS [ FILE ] <zipfile> ;
		EXTRACTPATH <extractpath> ;
		[ BLOCK <block> ] ;
		[ <createdir: CREATEDIR> ] ;
		[ PASSWORD <password> ] ;
=> ;
	UNCOMPRESSFILES ( <zipfile> , <block> , <extractpath> )

*------------------------------------------------------------------------------*
Procedure BACKUPJCS
*------------------------------------------------------------------------------*
DMCAR:="ADV"+SUBSTR(DTOC(DATE()),1,2)+SUBSTR(DTOC(DATE()),4,2)+SUBSTR(DTOC(DATE()),7,4)+".ZIP"
DEFINE WINDOW Back_1 ;
	AT 0, 0 ;
	WIDTH 400 HEIGHT 215 ;
	TITLE "Backup" ;
	ICON "demo" ;
	MODAL ;
	ON INIT RegActiveX() ;
	ON RELEASE UnRegActiveX() ;
	FONT "Arial" SIZE 9

	DEFINE LABEL Label_2
		ROW 20
		COL 25
		WIDTH 350
		HEIGHT 20
		VALUE DMCAR
		FONTNAME "Arial" 
		FONTSIZE 11 
		FONTBOLD .T.
		TRANSPARENT .T.
		CENTERALIGN .T.
	END LABEL
	
	DEFINE BUTTON Button_1
		ROW 140
		COL 45
		WIDTH 150
		HEIGHT 30
		CAPTION "&Criação Backup"
		ACTION CreateZip()
	END BUTTON

	DEFINE BUTTON Button_2
		ROW 140
		COL 205
		WIDTH 150
		HEIGHT 28
		CAPTION "&Restauração Backup"
		ACTION UnZip()
	END BUTTON

	DEFINE PROGRESSBAR ProgressBar_1
		ROW 60
		COL 45
		WIDTH 310
		HEIGHT 30
		RANGEMIN 0
		RANGEMAX 10
		VALUE 0
		FORECOLOR {0,130,0}
	END PROGRESSBAR

	DEFINE LABEL Label_1
		ROW 100
		COL 25
		WIDTH 350
		HEIGHT 20
		VALUE ""
		FONTNAME "Arial"
		FONTSIZE 10
		TOOLTIP ""
		FONTBOLD .T.
		TRANSPARENT .T.
		CENTERALIGN .T.
	END LABEL

	ON KEY ESCAPE ACTION Back_1.Release

END WINDOW

CENTER WINDOW Back_1
ACTIVATE WINDOW Back_1

Return

*------------------------------------------------------------------------------*
Function CreateZip()
*------------------------------------------------------------------------------*
Local aDir := Directory( "*.*", "D" ), aFiles:= {}, nLen
Local cPath := CurDrive()+":\"+CurDir()+"\"

FillFiles( aFiles, aDir, cPath )

if ( nLen := Len(aFiles) ) > 0
	Back_1.ProgressBar_1.RangeMin := 1
	Back_1.ProgressBar_1.RangeMax := nLen
	MODIFY CONTROL Label_1 OF Back_1 FONTCOLOR {0,0,0}

	COMPRESS aFiles ;
		TO DMCAR ; //'Backup.Zip' ;
		BLOCK {|cFile, nPos| ProgressUpdate( nPos, cFile, .T. ) } ;
		LEVEL 9 ;
		OVERWRITE

	MODIFY CONTROL Label_1 OF Back_1 FONTCOLOR {0,0,255}
	Back_1.Label_1.Value := 'Backup Realizado Com Sucesso'
endif

Return Nil

*------------------------------------------------------------------------------*
Function ProgressUpdate( nPos , cFile , lShowFileName )
*------------------------------------------------------------------------------*

	Default lShowFileName := .F.

	Back_1.ProgressBar_1.Value := nPos
	Back_1.Label_1.Value := cFileNoPath( cFile )

	if lShowFileName
		INKEY(.5)
	endif

Return Nil

*------------------------------------------------------------------------------*
Function UnZip()
*------------------------------------------------------------------------------*
Local cCurDir := GetCurrentFolder(), cArchive

cArchive := Getfile ( { {'Zip Files','*.ZIP'} } , 'Open File' , cCurDir , .f. , .t. )

if !Empty(cArchive)
	Back_1.ProgressBar_1.RangeMin := 0
	Back_1.ProgressBar_1.RangeMax := GetFilesCountInZip( cArchive )
	MODIFY CONTROL Label_1 OF Back_1 FONTCOLOR {0,0,0}

	UNCOMPRESS cArchive ;
		EXTRACTPATH cCurDir + "\BackUp" ;
		BLOCK {|cFile, nPos| ProgressUpdate( nPos, cFile, .T. ) } ;
		CREATEDIR

	MODIFY CONTROL Label_1 OF Back_1 FONTCOLOR {0,0,255}
	Back_1.Label_1.Value := 'Restauração Com Exito'
endif

Return Nil

*------------------------------------------------------------------------------*
Function FillFiles( aFiles, cDir, cPath )
*------------------------------------------------------------------------------*
  Local aSubDir, cItem

  FOR cItem :=1 TO LEN(cDir)
    IF cDir[cItem][5] <> "D"
      AADD( aFiles, cPath+cDir[cItem][1] )
    ELSEIF cDir[cItem][1] <> "." .AND. cDir[cItem][1] <> ".."
      aSubDir := DIRECTORY( cPath+cDir[cItem][1]+"\*.*", "D" )
      aFiles:=FillFiles( aFiles, aSubdir, cPath+cDir[cItem][1]+"\" )
    ENDIF
  NEXT

Return aFiles

*------------------------------------------------------------------------------*
Function GETFILESCOUNTINZIP ( zipfile )
*------------------------------------------------------------------------------*
Local ObjZip
Local Count

	objZip := CreateObject( "XStandard.Zip" )

	Count := objZip:Contents(zipfile):Count

Return Count

*------------------------------------------------------------------------------*
PROCEDURE UNCOMPRESSFILES ( zipfile , block , extractpath )
*------------------------------------------------------------------------------*
Local ObjZip
Local Count
Local objItem
Local i

	objZip := CreateObject( "XStandard.Zip" )

	Count := objZip:Contents(zipfile):Count 

	For i := 1 To Count

		objItem := objZip:Contents(zipfile):Item(i) 

		if valtype (block) = 'B'
			Eval ( block , objItem:Name , i )     
		endif

		objZip:UnPack( zipfile , extractpath , objItem:Name )

	Next i

RETURN

*------------------------------------------------------------------------------*
PROCEDURE COMPRESSFILES ( zipfile , afiles , level , block , ovr , lStorePath )
*------------------------------------------------------------------------------*
LOCAL oZip
LOCAL i

	oZip := CreateObject( "XStandard.Zip" )

	if ovr == .t.
		if file (zipfile)
			delete file (zipfile)
		endif
	endif

	For i := 1 To Len (afiles)
		Eval ( block , aFiles [i] , i )     
		oZip:Pack( afiles [i] , zipfile , lStorePath , , level )
	Next i

RETURN

*------------------------------------------------------------------------------*
PROCEDURE RegActiveX()
*------------------------------------------------------------------------------*

	if file ( GetStartUpFolder() + '\xzip.dll')
		EXECUTE FILE "regsvr32" PARAMETERS "/s XZip.dll" HIDE
	endif

RETURN

*------------------------------------------------------------------------------*
PROCEDURE UnRegActiveX()
*------------------------------------------------------------------------------*

	if file ( GetStartUpFolder() + '\xzip.dll')
		EXECUTE FILE "regsvr32" PARAMETERS "/u /s XZip.dll" HIDE
	endif

RETURN
