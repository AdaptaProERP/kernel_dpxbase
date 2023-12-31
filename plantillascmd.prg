// Programa   : PLANTILLASCMD
// Fecha/Hora : 09/09/2005 14:37:22
// Propósito  : Inspeccionar Objetos
// Creado Por : Juan Navas
// Llamado por: DpXbase
// Aplicación : Todas
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oMemo,cFileCmd)
   LOCAL aData:={},oFont,oFontB,oCol,I,cTexto,cFile,U,nAt,cLine,lMdi:=.T.
   LOCAL aCoors:=GetCoors( GetDesktopWindow() )
   LOCAL cDir  :="CMD\"
   LOCAL aFiles:=DIRECTORY(cDir+"*.TXT"),cMemo:="",aLine:={}
   LOCAL cNameVar:=""
   LOCAL cTitle:="Comandos Predefinidos"

   FOR I=1 TO LEN(aFiles)

      cFile:=cDir+aFiles[I,1]
      cMemo:=MEMOREAD(cFile)
      aLine:=_VECTOR(cMemo,"*")

      IF LEN(aLine)>2

         FOR U=3 TO LEN(aLine)
             aLine[2]:=aLine[2]+"*"+aLine[U]
         NEXT U

      ENDIF

//      AEVAL(aLine,{|a,n| aLine[n]:=STRTRAN(a,CHR(13),""),;
//                         aLine[n]:=ALLTRIM(aLine[n])      })

      AEVAL(aLine,{|a,n| aLine[n]:=ALLTRIM(aLine[n])      })


      AADD(aData,ACLONE(aLine))

   NEXT I

   IF ValType(oMemo)="O"
      cTexto  :=oMemo:GetText()
      lMdi    :=.T.
      nAt     :=AT("DpMdi"+"(",cTexto)

      IF nAt=0
         nAt :=AT("DPEDIT():New",cTexto)
         lMdi:=.F.
      ENDIF

      cLine   :=SUBS(cTexto,nAt,250)
      nAt     :=RAT(")",cLine)
      cLine   :=LEFT(cLine,nAt)
      aLine   :=_VECTOR(cLine,",")

      IF lMdi
        cNameVar:=IF(LEN(aLine)>1,aLine[2],"")
      ELSE
        cNameVar:=IF(LEN(aLine)>1,aLine[3],"")
      ENDIF

      cNameVar:=STRTRAN(cNameVar,["],"")
   ENDIF

//? cNameVar,"cNameVar"
// ViewArray(aData)
// return 

   DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -12 
   DEFINE FONT oFontB NAME "Tahoma"   SIZE 0, -12 BOLD

//   AADD(aData,{"TDPEDIT","Formulario Ventana"})
//   AADD(aData,{"TMDI"   ,"Formulario MDI"})
//   AADD(aData,{"TTABLE" ,"Cursores SQL"})
//   FOR I=1 TO LEN(aData)
//      cFile :="DP\CONTROLS\"+aData[I,1]+".TXT"
//      cTexto:=MemoRead(cFile)
//      AADD(aData[I],cTexto)
//   NEXT I

   VERDATA(aData,"Controles")

RETURN NIL


FUNCTION VERDATA(aData,cTitle)
   LOCAL oBrw,oCol,aTotal:={}
   LOCAL oFont,oFontB
   LOCAL aCoors:=GetCoors( GetDesktopWindow() )

   cTitle:="Comandos Predefinidos"

   DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -12 
   DEFINE FONT oFontB NAME "Tahoma"   SIZE 0, -12 BOLD

   DpMdi(cTitle,"oMdiCmd","MDI.EDT")

   oMdiCmd:Windows(0,0,aCoors[3]-150,aCoors[4]-10,.T.) // Maximizado

   oMdiCmd:lTmdi    :=.T.
   oMdiCmd:lMaximize:=.F.
   oMdiCmd:oMemo    :=oMemo
   oMdiCmd:cNameVar :=cNameVar

   oMdiCmd:oBrw:=TXBrowse():New( IF(oMdiCmd:lTmdi,oMdiCmd:oWnd,oMdiCmd:oDlg ))
   oMdiCmd:oBrw:SetArray( aData, .F. )
   oMdiCmd:oBrw:SetFont(oFontB)

   oMdiCmd:oBrw:lFooter     := .T.
   oMdiCmd:oBrw:lHScroll    := .T.
   oMdiCmd:oBrw:nHeaderLines:= 1
   oMdiCmd:oBrw:nDataLines  := 2
   oMdiCmd:oBrw:nFooterLines:= 1
   oMdiCmd:nFondo1:=oMdiCmd:nClrPane1
   oMdiCmd:nFondo2:=oMdiCmd:nClrPane2

   oMdiCmd:aData            :=ACLONE(aData)
  oMdiCmd:nClrText :=0
  oMdiCmd:nClrPane1:=16771797
  oMdiCmd:nClrPane2:=16764831

   AEVAL(oMdiCmd:oBrw:aCols,{|oCol|oCol:oHeaderFont:=oFontB})
  
   oCol:=oMdiCmd:oBrw:aCols[1]
   oCol:cHeader      :='Control'
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oMdiCmd:oBrw:aArrayData ) } 
   oCol:nWidth       := 120

   oCol:=oMdiCmd:oBrw:aCols[2]
   oCol:cHeader      :='Nombre'
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oMdiCmd:oBrw:aArrayData ) } 
   oCol:nWidth       := 180

   oCol:bStrData     :={|cData|cData:= oMdiCmd:oBrw:aArrayData[oMdiCmd:oBrw:nArrayAt,2],;
                               STRTRAN(cData,CHR(13),"")}

/*
   oCol:=oMdiCmd:oBrw:aCols[3]
   oCol:cHeader      :="Sintaxis"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oMdiCmd:oBrw:aArrayData ) } 
   oCol:nWidth       := 1000
   oCol:bStrData     :={||LEFT(oMdiCmd:oBrw:aArrayData[oMdiCmd:oBrw:nArrayAt,3],800)}

*/

  oMdiCmd:oBrw:aCols[1]:cFooter:=" #"+LSTR(LEN(aData))


  oMdiCmd:oBrw:bClrStd               := {|oBrw,nClrText,cEstado|oBrw:=oMdiCmd:oBrw,;
                                          oMdiCmd:nClrText,;
                                         {nClrText,iif( oBrw:nArrayAt%2=0, oMdiCmd:nFondo1, oMdiCmd:nFondo2 ) } }


  oMdiCmd:oBrw:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
  oMdiCmd:oBrw:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}


  oMdiCmd:oBrw:bLDblClick:={|oBrw|oMdiCmd:RUNCLICK() }

  oMdiCmd:oBrw:bChange:={||oMdiCmd:BRWCHANGE()}
  oMdiCmd:oBrw:CreateFromCode()
  oMdiCmd:bValid   :={|| EJECUTAR("BRWSAVEPAR",oMdiCmd)}
  oMdiCmd:BRWRESTOREPAR()

  oMdiCmd:oWnd:oClient := oMdiCmd:oBrw

  oMdiCmd:Activate({||oMdiCmd:ViewDatBar()})


RETURN .T.

/*
// Barra de Botones
*/
FUNCTION ViewDatBar()
   LOCAL oCursor,oBar,oBtn,oFont,oCol
   LOCAL oDlg:=IF(oMdiCmd:lTmdi,oMdiCmd:oWnd,oMdiCmd:oDlg)
   LOCAL nLin:=0
   LOCAL nWidth:=oMdiCmd:oBrw:nWidth()

   oMdiCmd:oBrw:GoBottom(.T.)
   oMdiCmd:oBrw:Refresh(.T.)
   
   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 52-15,60-15 OF oDlg 3D CURSOR oCursor
   DEFINE FONT oFont  NAME "Arial"   SIZE 0, -10 BOLD

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\PASTE.BMP";
          ACTION oMdiCmd:RUNCLICK()

   oBtn:cToolTip:="Copiar en ClipBoard"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\ZOOM.BMP";
          ACTION IF(oMdiCmd:oWnd:IsZoomed(),oMdiCmd:oWnd:Restore(),oMdiCmd:oWnd:Maximize())

   oBtn:cToolTip:="Maximizar"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XFIND.BMP";
          ACTION EJECUTAR("BRWSETFIND",oMdiCmd:oBrw)

   oBtn:cToolTip:="Buscar"

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\FILTRAR.BMP";
          ACTION EJECUTAR("BRWSETFILTER",oMdiCmd:oBrw)

   oBtn:cToolTip:="Filtrar Registros"

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\html.BMP";
          ACTION (EJECUTAR("BRWTOHTML",oMdiCmd:oBrw))

   oBtn:cToolTip:="Generar Archivo html"

   oMdiCmd:oBtnHtml:=oBtn

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xTOP.BMP";
          ACTION (oMdiCmd:oBrw:GoTop(),oMdiCmd:oBrw:Setfocus())

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xSIG.BMP";
          ACTION (oMdiCmd:oBrw:PageDown(),oMdiCmd:oBrw:Setfocus())

  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xANT.BMP";
          ACTION (oMdiCmd:oBrw:PageUp(),oMdiCmd:oBrw:Setfocus())

  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xFIN.BMP";
          ACTION (oMdiCmd:oBrw:GoBottom(),oMdiCmd:oBrw:Setfocus())

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XSALIR.BMP";
          ACTION oMdiCmd:Close()

  oMdiCmd:oBrw:SetColor(0,oMdiCmd:nFondo1)

  EVAL(oMdiCmd:oBrw:bChange)
 
  oBar:SetColor(CLR_BLACK,oDp:nGris)

  AEVAL(oBar:aControls,{|o,n|o:SetColor(CLR_BLACK,oDp:nGris)})

  oMdiCmd:oBar:=oBar

  AEVAL(oBar:aControls,{|o|o:ForWhen(.T.)})

RETURN .T.

/*
// Evento para presionar CLICK
*/
FUNCTION RUNCLICK()
  LOCAL cLine:=oMdiCmd:oBrw:aArrayData[oMdiCmd:oBrw:nArrayAt,2]

  IF !Empty(oMdiCmd:cNameVar)
      cLine:=STRTRAN(cLine,"<oMdiCmd>",oMdiCmd:cNameVar)
  ENDIF

  CLPCOPY(cLine)

  IF ValType(oMdiCmd:oMemo)="O"
      oMdiCmd:oMemo:Paste()
  ENDIF
//  ? CLPCOPY(cLine)
// oMdiCmd:oBrw:aArrayData[oMdiCmd:oBrw:nArrayAt,3])

   oMdiCmd:Close()
RETURN .T.


/*
// Ejecución Cambio de Linea 
*/
FUNCTION BRWCHANGE()
RETURN NIL


FUNCTION BRWRESTOREPAR()
RETURN EJECUTAR("BRWRESTOREPAR",oMdiCmd)
// EOF

