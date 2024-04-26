// Programa   : MYSQLLISTBD
// Fecha/Hora : 24/01/2019 15:30:12
// Propósito  : Lista de Bases de Datos del Servidor
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oControl,cFind,cDir)
  LOCAL oServer:=NIL
  LOCAL aDb    :=oServer:aDataBases,cBd,oBrw
  LOCAL aPoint :={}
  LOCAL cTitle :=" Base de Datos del Servidor "+oDp:cIp
  LOCAL oFont,oFontB,oBrw,oDlgList,uValue
  LOCAL nWidth:=180+160,nHeight:=400
  LOCAL nClrPane1:=16770764
  LOCAL nClrPane2:=16566954
  LOCAL nClrText :=0,aPoint
  LOCAL nHeadLine:=1,bBlq,nAlto
  LOCAL aCoors:=GetCoors( GetDesktopWindow() )
  LOCAL cFileMem

  oDp:cMySqlMem:=""
  
  DEFAULT cDir:=""

  // C:\DPSGEV60\"
  // oDp:lTracer:=.T.

  IF !Empty(cDir)

     cDir    :=ALLTRIM(cDir)
     cDir    :=cDir+IF(RIGHT(cDir,1)="\","","\")
     cFileMem:=ALLTRIM(cDir)+"MYSQL.MEM"

     IF !FILE(cFileMem)
        oControl:MsgErr("Archivo de Credenciales "+cFileMem+" no existe"+CRLF+"Cambie la Ruta o dejar Vacio el Campo Carpeta","Archivo de Credenciales")
        RETURN ""
     ENDIF

//? cFileMem,"cFileMem"

//     IF ValType(oDp:oMySqlCon)="O"
//        oDp:oMySqlCon:Close()
//        oDp:oMySqlCon:=NIL
//        MySqlStart(.T.)
//     ENDIF

     oServer:=EJECUTAR("OPENMYSQMMEM",cFileMem)

     IF oServer=NIL
        oControl:MsgErr("No fué posible Abrir la Base de Datos"+CRLF+"Según las Credenciales "+cFileMem,"Validar Credenciales")
        RETURN ""      
     ENDIF

     // oServer:=OpenOdbc(oDp:cDsnConfig):oConnect
     aDb    :=ACLONE(oServer:aDataBases)

     ADEPURA(aDb,{|a,n| "CONFIG"$UPPER(a) .OR. "schema"$(a)})

     IF oDp:cMySqlMem<>oDp:cIp
       oServer:Close()
     ENDIF

  ELSE

     oServer:=OpenOdbc(oDp:cDsnConfig):oConnect
     aDb    :=ACLONE(oServer:aDataBases)

  ENDIF

  DEFAULT cFind:=oDp:cDsnData

  //ViewArray(aDb) 
  // ADEPURA(aDb,{|a,n| "CONFIG"$UPPER(a)})
  ADEPURA(aDb,{|a,n| "CONFIG"$UPPER(a) .OR. "schema"$(a)})


  AEVAL(aDb,{|a,n| aDb[n]:={a} })



  aPoint:=IF(ValType(oControl)="O",EJECUTAR("GETAPOINT",oControl),{})

  DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -14  BOLD
  DEFINE FONT oFontB NAME "Tahoma"   SIZE 0, -14  BOLD

  IF !Empty(aPoint) 

     DEFINE DIALOG oDlgList;
            TITLE cTitle;
            PIXEL OF oControl:oWnd;
            STYLE nOr( DS_SYSMODAL, DS_MODALFRAME )

   ELSE

      DEFINE DIALOG oDlgList TITLE cTitle FROM 1,30 TO 34,70

   ENDIF

   oDlgList:lHelpIcon:=.F.

   oBrw:=TXBrowse():New( oDlgList )

   oBrw:nMarqueeStyle       := MARQSTYLE_HIGHLCELL
   oBrw:nHeaderLines        :=1 //nHeadLine

   oBrw:SetArray( aDb , .F. )
   oBrw:lHScroll            := .F.
   oBrw:oFont               :=oFont

   


   oBrw:aCols[1]:cHeader:="Base de Datos"
   oBrw:aCols[1]:nWidth :=nWidth-05
   oBrw:bClrStd := {|| {nClrText, iif( oBrw:nArrayAt%2=0, nClrPane1  ,   nClrPane2 ) } }
   oBrw:SetFont(oFont)

   oBrw:bLDblClick:={||oDp:aLine:=ACLONE(oBrw:aArrayData[oBrw:nArrayAt]),uValue:=oBrw:aArrayData[oBrw:nArrayAt,1],oDlgList:End()}
   oBrw:bClrHeader:= {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oBrw:bClrFooter:= {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oBrw:bKeyDown  := {|nkey,oBrw| IIF(nKey=107,EJECUTAR("REPBDLISTMAS",oBrw) ,NIL) }

   oBrw:CreateFromCode()
   oBrw:Refresh(.t.)
   AEVAL(oBrw:aCols,{|oCol|oCol:oHeaderFont:=oFontB})


   IF ValType(oControl)="O"

 
     ACTIVATE DIALOG oDlgList;
            ON INIT (REPBDBAR(oDlgList,oBrw,cFind),;
                     oDlgList:Move(aPoint[1] + 1, aPoint[2],nWidth+50,nHeight,.T.),;
                     oBrw:SetColor(nClrText, nClrPane1),;
                     SETALTURA(),;
                     oBrw:Move(50,0,nWidth+50,oDlgList:nHeight()-85,.t.),;
                     .F.)
   ELSE

     ACTIVATE DIALOG oDlgList ON INIT (REPBDBAR(oDlgList,oBrw,cFind),;
                     oDlgList:Move(90,0,nWidth+9+40,nHeight+25,.T.),;
                     oBrw:Move(50,0,nWidth+40,nHeight-85,.t.),;
                     oBrw:SetColor(nClrText, nClrPane1))
   ENDIF

   IF !Empty(uValue) 
     oControl:KeyBoard(13)
   ENDIF

RETURN uValue

/*
// Coloca la Barra de Botones
*/
FUNCTION REPBDBAR(oDlgList,oBrw,cFind)

   LOCAL oCursor,oBar,oBtn,oFont,oCol,nDif

/*
   AEVAL(oBrw:aCols,{|o|o:nWidth:=MIN(o:nWidth,320),nWidth:=nWidth+o:nWidth+1})

   IF nWidth<175+32
      nDif:=175+32-nWidth
      oCol:=oBrw:aCols[Len(oBrw:aCols)]
      oCol:nWidth:=oCol:nWidth+nDif
      nWidth:=nWidth+nDif
   ENDIF
*/

   IF ValType(cFind)=VALTYPE(aDb[1]) .AND. !Empty(cFind)

      oBrw:nArrayAt:=MAX( ASCAN(aDb,{|a|a=cFind } ) ,1 )

   ENDIF

   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 52-10,60-10 OF oDlgList 3D CURSOR oCursor

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XFIND.BMP";
          ACTION EJECUTAR("BRWSETFIND",oBrw,.F.)


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\FILTRAR.BMP";
          ACTION EJECUTAR("BRWSETFILTER",oBrw)

   oBtn:cToolTip:="Filtrar Registros"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\OPTIONS.BMP",NIL,"BITMAPS\OPTIONSG.BMP";
          ACTION EJECUTAR("BRWSETOPTIONS",oBrw);
          WHEN LEN(oBrw:aArrayData)>1

   oBtn:cToolTip:="Filtrar según Valores Comunes"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\html.BMP";
          ACTION EJECUTAR("BRWTOHTML",oBrw,NIL,cTitle)

   oBtn:cToolTip:="Generar Archivo html"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xTOP.BMP";
          ACTION (oBrw:GoTop(),oBrw:Setfocus())

  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xSIG.BMP";
          ACTION (oBrw:PageDown(),oBrw:Setfocus())

  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xANT.BMP";
          ACTION (oBrw:PageUp(),oBrw:Setfocus())

  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xFIN.BMP";
          ACTION (oBrw:GoBottom(),oBrw:Setfocus())

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XSALIR.BMP";
          ACTION oDlgList:End()

  AEVAL(oBar:aControls,{|o,n|o:SetColor(0,oDp:nGris)})
  oBar:SetColor(0,oDp:nGris)

/*
  nHeight:=91+60+oBrw:nRowHeight+(oBrw:nRowHeight*nLines)+1

  IF !Empty(aPoint) .AND. oDp:lFullHeight

    nDif   :=(aCoors[3]-aPoint[1])
    nHeight:=nHeight+nDif
    IF nHeight>aCoors[3]
       nHeight:=nHeight-oDlgList:nTop()
    ENDIF

  ENDIF
*/
RETURN .T.

FUNCTION SETALTURA()
  LOCAL nHeight
  LOCAL nMaxH:=GetCoors( GetDesktopWindow())[3]-50 // 1024 Maxima Capacidad del Video-Titulo-Menu-Area de Botones-Aerea de Mensajes
  LOCAL nDif // Diferencia extralimitada

  oDlgList:CoorsUpdate() // Actualiza ::nTop
  nHeight:=oDlgList:nTop+oDlgList:nHeight // Altura + Posición del Area de la Ventana MDI que Ocupa LBX
  nDif   :=nMaxH-nHeight

  // Reduce el Alto de la Ventana
  IF nDif<0
     oDlgList:SetSize(NIL,MAX(oDlgList:nHeight+nDif,110))
  ENDIF

RETURN 


// EOF
