// Programa   : BCVINPC
// Fecha/Hora : 14/08/2014 20:22:21
// Propósito  : Descargar Indice nacional de precios al consumidor
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(l_IPC,oLbx,lAuto)
  LOCAL oData,oFontG,oFontT
  LOCAL cDir  :="C:\Documents and Settings\Administrador\Mis documentos\Downloads\"
  LOCAL cTitle,cUrl
  LOCAL aCoors:=GetCoors( GetDesktopWindow() )


  DEFAULT l_IPC:=.F.,;
          lAuto:=.F.

  IF Empty(oDp:hDllRtf) // Carga RTF
     oDp:hDLLRtf := LoadLibrary( "Riched20.dll" )
  ENDIF

  // Determinar Ultima fecha del IPC/INPC
  DEFAULT oDp:bFchIpc:={|dFecha|dFecha:=SQLGET("DPIPC","CONCAT(IPC_ANO,IPC_MES)","IPC_TASA>0 ORDER BY CONCAT(IPC_ANO,IPC_MES) DESC LIMIT 1"),;
                              dFecha  :=CTOD("01/"+RIGHT(dFecha,2)+"/"+LEFT(dFecha,4)),dFecha}

  DEFAULT oDp:bFchInpc:={|dFecha|dFecha:=SQLGET("DPIPC","CONCAT(IPC_ANO,IPC_MES)","IPC_INPC>0 ORDER BY CONCAT(IPC_ANO,IPC_MES) DESC LIMIT 1"),;
                              dFecha  :=CTOD("01/"+RIGHT(dFecha,2)+"/"+LEFT(dFecha,4)),dFecha}


  // https://www.bcv.org.ve/sites/default/files/precios_consumidor/4_5_7_0.xls

  IF !l_IPC
    cTitle:="Indice Nacional de Precios al Consumidos [INPC] del B.C.V"
    //cUrl  :="http://www.bcv.org.ve/sites/default/files/precios_consumidor/4_5_7_indice_y_variaciones_mensuales_serie_desde_dic_2007_2.xls"
    // cUrl  :="https://www.bcv.org.ve/sites/default/files/precios_consumidor/4_5_7_indice_y_variaciones_mensuales_serie_desde_dic_2007.xls"
    cUrl :="https://www.bcv.org.ve/sites/default/files/precios_consumidor/4_5_7_0.xls"
  ELSE
    cUrl  :="https://www.bcv.org.ve/excel/4_1_7.xls"
    cTitle:="Indice de Precios al Consumidos [IPC] del B.C.V"
  ENDIF

  IF lAuto 
     DESCARGARIPC(cUrl,cDir,NIL,l_IPC,.F.)
     RETURN .F.
  ENDIF

  oData:=DATASET("PATH"+IIF(l_IPC,"IPC","INPC_2021"))
  oData:End()

  DEFINE FONT oFontG NAME "Tahoma"   SIZE 0, -14

  DEFINE FONT oFontT NAME "Courier New"   SIZE 0, -14

  DpMdi("Descargar "+cTitle,"oFrmBCVIPC","BCVINPC.edt")

  oFrmBCVIPC:Windows(0,0,aCoors[3]-160,MIN(800,aCoors[4]-10),.T.) // Maximizado
 
  oFrmBCVIPC:nCantid:=0
  oFrmBCVIPC:oLbx   :=oLbx
  oFrmBCVIPC:nRecord:=0
  oFrmBCVIPC:l_IPC  :=l_IPC
  oFrmBCVIPC:oMeterT:=NIL
  oFrmBCVIPC:oMeterR:=NIL
  oFrmBCVIPC:cDir   :=PADR(oData:Get("CPATH",cDir),180)     
  oFrmBCVIPC:cUrl   :=PADR(oData:Get("CURL" ,cUrl),180)
  oFrmBCVIPC:cDir   :=STRTRAN(oFrmBCVIPC:cDir  ,"\\","\")
  oFrmBCVIPC:nIpc   :=SQLGET([DPIPC],[IPC_TASA,CONCAT(IPC_ANO,"-",IPC_MES)],[1=1 ORDER BY CONCAT(IPC_ANO,IPC_MES) DESC LIMIT 1])
  oFrmBCVIPC:cIpcMax:=DPSQLROW(2)
  oFrmBCVIPC:lAuto  :=lAuto
  oFrmBCVIPC:lView  :=.F.
  oFrmBCVIPC:cMemo  :=""

  @ 10,0 RICHEDIT oFrmBCVIPC:oMemo VAR oFrmBCVIPC:cMemo OF oFrmBCVIPC:oWnd HSCROLL  FONT oFontT


  oFrmBCVIPC:oWnd:oClient := oFrmBCVIPC:oMemo


  oFrmBCVIPC:Activate({|| oFrmBCVIPC:ViewDatBar()})

RETURN NIL

/*
// Barra de Botones
*/
FUNCTION ViewDatBar()
   LOCAL oCursor,oBar,oBtn,oFont,oCol

   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 52,60 OF oFrmBCVIPC:oDlg 3D CURSOR oCursor

   DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -11 BOLD

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\RUN.BMP";
          TOP PROMPT "Ejecutar"; 
          ACTION oFrmBCVIPC:DESCARGARIPC(oFrmBCVIPC:cUrl,oFrmBCVIPC:cDir,NIL,oFrmBCVIPC:l_IPC,oFrmBCVIPC:lView,oFrmBCVIPC:oMeterR,.T.)

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          TOP PROMPT "Explorar"; 
          FILENAME "BITMAPS\EXCEL.BMP";
          ACTION oFrmBCVIPC:DESCARGARIPC(NIL,NIL,NIL,NIL,.T.)


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XSALIR.BMP";
          TOP PROMPT "Cerrar"; 
          ACTION oFrmBCVIPC:Close()

  AEVAL(oBar:aControls,{|o,n|o:SetColor(CLR_BLACK,oDp:nGris)})

  oBar:SetColor(CLR_BLACK,oDp:nGris)

  IF !oFrmBCVIPC:l_IPC
     @ .1,35 SAY" Actualizado "+DTOC(EVAL(oDp:bFchInpc)) OF oBar SIZE 250,20 BORDER  COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  ELSE
     @ .1,35 SAY" Actualizado "+DTOC(EVAL(oDp:bFchIpc)) OF oBar SIZE 250,20 BORDER  COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  ENDIF

  oBar:SetSize(0,130,.T.)

  @ 082,15 GET oFrmBCVIPC:oUrl VAR oFrmBCVIPC:cUrl OF oBar SIZE 700,20 PIXEL FONT oFont 
  @ 104,15 METER oFrmBCVIPC:oMeterR VAR oFrmBCVIPC:nRecord OF oBar SIZE 700,20 PIXEL FONT oFont;
           COLOR oDp:nClrLabelText,oDp:nClrLabelPane

//  @ 04,01 SAY "Lectura:"
//  @ 04,12 SAY oFrmBCVIPC:oLectura PROMPT SPACE(40)

  @ 060,16 SAY " Dirección de Descarga URL" OF oBar SIZE 700,20 PIXEL BORDER FONT oFont;
           COLOR oDp:nClrLabelText,oDp:nClrLabelPane


RETURN .T.


FUNCTION DESCARGARIPC(cUrl,cDir,nIni,l_IPC,lView,oMeter,lLbx)
   LOCAL cFile,aFiles:={},nT1:=SECONDS()
   LOCAL oExcel,nLin:=1,nCol:=1,cValue,aData:={},I,nT1:=SECONDS(),nT2:=0,aFilesNo:={},nAt
   LOCAL cCol1,cCol2,cCol3,cCol4,nVacio:=0,cAno:="",nAt,oTable,cWhere
   LOCAL aMeses:={"ENE","FEB","MAR","ABR","MAY","JUN","JUL","AGO","SEP","OCT","NOV","DIC"}
   LOCAL cMask :=""
   LOCAL oData,nMes:=0

   DEFAULT cUrl  :=ALLTRIM(oFrmBCVIPC:cUrl),;
           cDir  :=ALLTRIM(oFrmBCVIPC:cDir),;
           lView :=.F.,;
           l_IPC :=oFrmBCVIPC:l_IPC,;
           nIni  :=1,;
           lLbx  :=.F.

   cUrl :=ALLTRIM(cUrl)
   cDir :=ALLTRIM(cDir)
   cFile:=cFileName(STRTRAN(cUrl,"/","\"))
   cMask:=cDir+IIF(RIGHT(cDir,1)="\","","\")+cFileNoExt(cFile)+"*.XLS"

   oData:=DATASET("PATH"+IIF(oFrmBCVIPC:l_IPC,"IPC","INPC"))
   oData:Set("CPATH",cDir)
   oData:Set("CURL" ,oFrmBCVIPC:cUrl)
   oData:End()

   // Elimina todos los Archivos
   aFilesNo:=DIRECTORY(cMask)
   cFile   :=oDp:cBin+"temp\"+cFileName(STRTRAN(cUrl,"/","\"))
 
   ferase(cFile)

   IF !oMeter=NIL

      oFrmBCVIPC:oMemo:SetText("Descargando "+cUrl)

   ELSE

     IF oDp:oMsgRun<>NIL
        oDp:oMsgRun:FRMTEXT("Descargando "+cUrl)
     ENDIF

   ENDIF

   URLDownloadToFile(0,cUrl,cFile,0,0 )

   IF !FILE(cFile)
      MsgMemo("Archivo "+cFile+" no fue descargado")
      RETURN .F.
   ENDIF

   IF lView
     SHELLEXECUTE(oDp:oFrameDp:hWND,"open",cFile)
     RETURN .T.
   ENDIF

   oExcel := TExcelScript():New()
   oExcel:Open( cFile )

   SET DECI TO 6 
   nLin:= nIni

   WHILE nVacio<6

    nlin++
    nCol++
    uValue:=SPACE(100)
    cCol1:=oExcel:Get( nLin , 1 ,@cValue )
    cCol2:=oExcel:Get( nLin , 2 ,@cValue )
    cCol3:=oExcel:Get( nLin , 3 ,@cValue )

    IF Empty(cCol1)

       nVacio++

    ELSE

       nVacio:=0
       cCol1 :=CTOO(cCol1,"C")
       cCol1 :=STRTRAN(cCol1,"(*)","")

       IF ISALLDIGIT(cCol1)

         cAno:=cCol1

       ELSE

         cCol1:=UPPE(LEFT(cCol1,3))
         nMes :=ASCAN(aMeses,cCol1)


         IF nMes>0
            // ASCAN(aMeses,cCol1)>0
           AADD(aData,{cAno,cCol1,cCol2,cCol3,nMes})
         ENDIF

       ENDIF

    ENDIF

  ENDDO

  oExcel:End()
 
  SysRefresh(.T.)

  IF !oMeter=NIL
    oFrmBCVIPC:oMeterR:Settotal(LEN(aData))
  ENDIF

  SQLDELETE("DPIPC","IPC_ANO"+GetWhere("=","")+" OR IPC_ANO IS NULL")
  EJECUTAR("UNIQUETABLAS","DPIPC","IPC_ANO,IPC_MES")

  FOR I=1 TO LEN(aData)

     IF !oMeter=NIL
       oFrmBCVIPC:oMeterR:Set(I)
       oFrmBCVIPC:oMemo:Append(LSTR(I)+"/"+LSTR(LEN(aData))+" "+CTOO(aData[I,1],"C")+"/"+CTOO(aData[I,3],"C")+CRLF)

       SysRefresh(.T.)
       // oFrmBCVIPC:oLectura:SetText(LSTR(I)+"/"+LSTR(LEN(aData)))

     ELSE

       IF I%10=0 .AND. oDp:oMsgRun<>NIL
          oDp:oMsgRun:FRMTEXT("INPC="+LSTR(I)+"/"+LSTR(LEN(aData))+" "+CTOO(aData[I,1],"C")+"/"+CTOO(aData[I,3],"C"))
       ENDIF

     ENDIF

     cAno  :=aData[I,1]
     nAt   :=aData[I,5] // ASCAN(aMeses,{|a,n| a=aData[I,2]})
     nAt   :=STRZERO(nAt,2)
     cWhere:="IPC_ANO"+GetWhere("=",aData[I,1])+" AND "+;
             "IPC_MES"+GetWhere("=",nAt       )

     oTable:=OpenTable("SELECT * FROM DPIPC WHERE "+cWhere,.T.)
     oTable:lAuditar:=.F.

     IF oTable:RecCount()=0
        oTable:AppendBlank()
        oTable:cWhere:=""
     ENDIF

     oTable:Replace("IPC_ANO",cAno)
     oTable:Replace("IPC_MES",nAt )

     IF l_IPC
       oTable:Replace("IPC_IPC" ,aData[I,3]) // Ajuste Fiscal
     ELSE
       oTable:Replace("IPC_INPC",aData[I,3]) // Ajuste Financiero
     ENDIF

     oTable:Replace("IPC_TASA",aData[I,4]) // Ajuste Financiero
     oTable:Commit(oTable:cWhere)
     oTable:End(.T.)

  NEXT 

  oDp:aIpc:=NIL

  SysRefresh(.T.)

  IF !oMeter=NIL

    oFrmBCVIPC:oMemo:Append("Proceso Concluido"+CRLF)

    IF oFrmBCVIPC:lAuto
      oFrmBCVIPC:Close()
      RETURN .F.
    ENDIF

  ENDIF

  IF lLbx

    IF oFrmBCVIPC:lAuto
      oFrmBCVIPC:Close()
      RETURN .F.
    ENDIF

    IF oFrmBCVIPC:oLbx=NIL
      DPLBX("DPIPC.LBX")
    ELSE
      oFrmBCVIPC:oLbx:RELOAD()
    ENDIF

  ENDIF

RETURN LEN(aData)>0
// EOF
