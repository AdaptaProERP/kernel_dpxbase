// Programa   : MYSQLRESTORE
// Fecha/Hora : 19/11/2005 12:11:43
// Propósito  : Realizar Backup con Mysql
// Creado Por : Juan Navas
// Llamado por: DPMENU
// Aplicación : Definiciones
// Tabla      : TODAS

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL aData:={},nCuantos:=0,oData
  LOCAL I,oFontBrw,oBrw,oCol,oFont,oFontB
  LOCAL aCoors:=GetCoors( GetDesktopWindow() )
  LOCAL cTitle:="Recuperación de Respaldos mediante MYSQL.EXE"
  LOCAL cFileMem:="MYSQL.MEM"
  LOCAL _MycPass:="",_MycLoging:=""
  LOCAL cMask:="*.SQL"
   
  IF FILE(cFileMem)

     REST FROM (cFileMem) ADDI

     _MycPass  :=ENCRIPT(_MycPass  ,.F.)
     _MycLoging:=ENCRIPT(_MycLoging,.F.)

  ENDIF

 //  aData:=ASQL("SELECT EMP_CODIGO,EMP_NOMBRE,EMP_BD,EMP_FCHRES,EMP_HORRES,EMP_SELRES FROM DPEMPRESA ORDER BY CONCAT(EMP_FCHRES,EMP_HORRES,EMP_SELRES) DESC ")

  nCuantos:=LEN(aData)

  DEFINE FONT oFontBrw NAME "Verdana" SIZE 0,-12

  oData:=DATACONFIG("CONFIG","RESPALDO")
  oData:End(.F.)

  DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -12 
  DEFINE FONT oFontB NAME "Tahoma"   SIZE 0, -12 BOLD

  DpMdi(cTitle,"oMySqlR","MYSQLRESTORE.EDT")
  oMySqlR:Windows(0,0,aCoors[3]-160,MIN(780,aCoors[4]-10),.T.) // Maximizado

  oMySqlR:cPath  :=oData:Get("PATH"  ,CURDRIVE()+":\"+CurDir()+"\respaldo\")

  oMySqlR:dFchRes:=oData:Get("FCHRES",CTOD(""))
  oMySqlR:cHorRes:=oData:Get("HORRES",CTOD(""))
  oMySqlR:lSelRes:=oData:Get("SELRES",.T.     )
  oMySqlR:cPath  :=STRTRAN(oMySqlR:cPath,"\"+"\","\")
  oMySqlR:cPath  :=STRTRAN(oMySqlR:cPath,"\"+"\","\")
  oMySqlR:cPath  :=PADR(oMySqlR:cPath,120)
  oMySqlR:cMask  :=oData:Get("MASK"  ,cMask   )

  oMySqlR:nClrPane1:=16765606
  oMySqlR:nClrPane2:=16744448

  oMySqlR:nClrText :=0
  oMySqlR:nClrText1:=CLR_HBLUE

  aData:=oMySqlR:LEERDIR(ALLTRIM(oMySqlR:cPath)+"\"+oMySqlR:cMask)

//  AADD(aData,{"SYS", oDp:cDpSys ,oDp:cDsnConfig,oMySqlR:dFchRes,oMySqlR:cHorRes,oMySqlR:lSelRes})

  oMySqlR:nRecord   :=0
  oMySqlR:lZip      :=!(".SQL"$oMySqlR:cMask)  // No Incluye Estructura de Datos
  oMySqlR:cMemo     :=" MYSQL.EXE Requiere Usuario y Clave de la Base de Datos "+CRLF+;
                      " La base de datos destino será removida en el caso de existir, con el objetivo de asegurar"+;
                      " la restauración exitosa. Es necesario hacer respaldo de las bases de Datos Actual "
  oMySqlR:lMsgBar   :=.F.
  oMySqlR:lAutoClose:=.F.
  oMySqlR:lBarDef   :=.T.
  oMySqlR:lBmpGetBtn:=.T.

  oMySqlR:cLogin:=_MycLoging
  oMySqlR:cPass :=_MycPass  

  oMySqlR:cOut   :=""
  oMySqlR:lMsgRun:=.T.
  oMySqlR:lRunOk :=.F.
  oMySqlR:aFiles :={} // Respaldo con todos los SQL
  oMySqlR:nCuantos:=LEN(aData)

  oMySqlR:oBrw:=TXBrowse():New( oMySqlR:oWnd )
  oBrw:=oMySqlR:oBrw

  oBrw:SetArray( aData )
  oBrw:SetFont(oFontBrw)

  oBrw:lFastEdit:= .T.
  oBrw:lHScroll := .F.
  oBrw:nFreeze  := 3

  oCol:=oBrw:aCols[1]
  oCol:cHeader     :="Archivo"
  oCol:bLDClickData:={||oMySqlR:PrgSelect(oMySqlR)}
  oCol:nWidth      :=300

  oCol:=oBrw:aCols[2]
  oCol:cHeader      :='Tamaño'
  oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oMySqlR:oBrw:aArrayData ) } 
  oCol:nWidth       := 136
  oCol:nDataStrAlign:= AL_RIGHT 
  oCol:nHeadStrAlign:= AL_RIGHT 
  oCol:nFootStrAlign:= AL_RIGHT 
  oCol:cEditPicture :='9,999,999,999'
  oCol:bStrData     :={|nMonto,oCol|nMonto:= oMySqlR:oBrw:aArrayData[oMySqlR:oBrw:nArrayAt,2],;
                                    oCol  := oMySqlR:oBrw:aCols[2],;
                                    FDP(nMonto,oCol:cEditPicture)}
  oCol:cFooter     :=FDP(aTotal[2],oCol:cEditPicture)
  oCol:bLDClickData:={||oMySqlR:PrgSelect(oMySqlR)}


  oCol:=oBrw:aCols[3]
  oCol:cHeader:="Fecha"
  oCol:nWidth:=70
  oCol:bLDClickData:={||oMySqlR:PrgSelect(oMySqlR)}

  oCol:=oBrw:aCols[4]
  oCol:cHeader:="Hora"
  oCol:nWidth:=70
  oCol:bLDClickData:={||oMySqlR:PrgSelect(oMySqlR)}

  oCol:=oBrw:aCols[5]
  oCol:cHeader:="Comentarios"
  oCol:nWidth:=70
  oCol:bLDClickData:={||oMySqlR:PrgSelect(oMySqlR)}


  oCol:=oBrw:aCols[6]
  oCol:cHeader:="Ok"
  oCol:nWidth:= 25
  oCol:AddBmpFile("BITMAPS\xCheckOn.bmp")
  oCol:AddBmpFile("BITMAPS\xCheckOff.bmp")
  oCol:bBmpData:={||oBrw:=oMySqlR:oBrw,IIF(oBrw:aArrayData[oBrw:nArrayAt,6],1,2) }
  oCol:nDataStyle:=oCol:DefStyle( AL_LEFT, .F.)
  oCol:bLDClickData:={||oMySqlR:PrgSelect(oMySqlR)}
  oCol:bLClickHeader:={|nRow,nCol,nKey,oCol|oMySqlR:ChangeAllImp(oMySqlR,nRow,nCol,nKey,oCol,.T.)}

  oBrw:bClrStd:={|oBrw|oBrw:=oMySqlR:oBrw,nAt:=oBrw:nArrayAt, { iif( oBrw:aArrayData[nAt,6], oMySqlR:nClrText1,  oMySqlR:nClrText ),;
                                               iif( oBrw:nArrayAt%2=0, oMySqlR:nClrPane1 ,  oMySqlR:nClrPane2  ) } }

//  oBrw:bClrSel:={|oBrw|oBrw:=oMySqlR:oBrw,{65535,16733011}}

 
  oMySqlR:bValid   :={|| EJECUTAR("BRWSAVEPAR",oMySqlR)}

  oBrw:bClrHeader := {|| {0,oDp:nGrid_ClrPaneH}}
  oBrw:bClrFooter := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

  oMySqlR:oWnd:oClient := oMySqlR:oBrw

  oMySqlR:oBrw:CreateFromCode()

  oMySqlR:BRWRESTOREPAR()
 

  oMySqlR:oFocus:=oBrw
  oMySqlR:Activate({||oMySqlR:NMCONBAR(oMySqlR)})

  BMPGETBTN(oMySqlR:oBar) // Path)


RETURN oMySqlR

// Coloca la Barra de Botones
FUNCTION NMCONBAR(oMySqlR)
  LOCAL oCursor,oBar,oBtn,oFont,oCol,nDif
  LOCAL nWidth :=0 // Ancho Calculado segœn Columnas
  LOCAL nHeight:=0 // Alto
  LOCAL nLines :=0 // Lineas
  LOCAL oDlg   :=oMySqlR:oWnd

  DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -12 

  DEFINE CURSOR oCursor HAND
  DEFINE BUTTONBAR oBar SIZE 80,170+80 OF oDlg 3D CURSOR oCursor

  DEFINE BUTTON oMySqlR:oBtnRun OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\RUN.BMP";
         ACTION oMySqlR:RunRestore(oMySqlR)

  oMySqlR:oBtnRun:cToolTip:="Iniciar Respaldo de Datos"

  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\SELECT.BMP";
         ACTION oMySqlR:SelectAll(oMySqlR)

  oBtn:cToolTip:="Seleccionar Todas las Bases de Datos"

  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\XFIND.BMP";
         ACTION EJECUTAR("BRWSETFIND",oMySqlR:oBrw)

  oBtn:cToolTip:="Buscar Base de Datos"


  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\FILTRAR.BMP";
          MENU EJECUTAR("BRBTNMENUFILTER",oMySqlR:oBrw,oMySqlR);
          ACTION EJECUTAR("BRWSETFILTER",oMySqlR:oBrw)

  oBtn:cToolTip:="Filtrar Registros"


  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\xTOP.BMP";
         ACTION (oMySqlR:oBrw:GoTop(),oMySqlR:oBrw:Setfocus())

  oBtn:cToolTip:="Primera Base de Datos"


  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\xFIN.BMP";
         ACTION (oMySqlR:oBrw:GoBottom(),oMySqlR:oBrw:Setfocus())

  oBtn:cToolTip:="Ultima Base de Datos"

  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\XSALIR.BMP";
         ACTION oMySqlR:Close()

  oBtn:cToolTip:="Cerrar Formulario"

  AEVAL(oBar:aControls,{|o,n|o:cMsg:=o:cToolTip})

  oMySqlR:oBrw:SetColor(0,oDp:nClrPane1)

  oBar:SetColor(CLR_BLACK,oDp:nGris)

  AEVAL(oBar:aControls,{|o,n|o:SetColor(CLR_BLACK,oDp:nGris)})

  oMySqlR:SETBTNBAR(45,45,oBar)

  @ 10,1 SAY "Carpeta Origen" FONT oFont
  @ 11,1 SAY oMySqlR:oDB PROMPT PADR("Proceso",40) FONT oFont

  @ 12,01 METER oMySqlR:oMeterR VAR oMySqlR:nRecord FONT oFont

  @ 02.5,1 BMPGET oMySqlR:oPath VAR oMySqlR:cPath NAME "BITMAPS\FOLDER5.BMP";
                              ACTION (cDir:=cGetDir(oMySqlR:cPath),;
                              IIF(!EMPTY(cDir),oMySqlR:oPath:VarPut(PADR(cDir,60),.t.),NIL));
                              VALID (oMySqlR:cMask:=ALLTRIM(oMySqlR:cPath)+"\"+IF(oMySqlR:lZip,"*.ZIP","*.SQL"),;
                                     oMySqlR:LEERDIR(oMySqlR:cMask,oMySqlR:oBrw),;
                                     oMySqlR:CAMBIARDIR()) FONT oFont

  oMySqlR:oPath:cToolTip:="Carpeta Origen	 del Respaldo, Presione F6 para Seleccionar"

  @ 02,40 GET oMySqlR:oMemo VAR  oMySqlR:cMemo MULTILINE READONLY SIZE 100,100

  @ 1,1 CHECKBOX oMySqlR:oZip VAR oMySqlR:lZip PROMPT "Archivos Comprimidos *.ZIP";
        ON CHANGE (oMySqlR:cMask:=ALLTRIM(oMySqlR:cPath)+"\"+IF(oMySqlR:lZip,"*.ZIP","*.SQL"),;
                   oMySqlR:LEERDIR(oMySqlR:cMask,oMySqlR:oBrw))

  oMySqlR:oZip:cToolTip:="Seleccione Archivos Comprimidos *.ZIP"+CRLF+""

  oBar:SetColor(CLR_BLACK,oDp:nGris2)

RETURN .T.

// Seleccionar Concepto
FUNCTION PrgSelect(oMySqlR)
  LOCAL oBrw:=oMySqlR:oBrw
  LOCAL nArrayAt,nRowSel,nAt:=0,nCuantos:=0
  LOCAL lSelect
  LOCAL nCol:=6
  LOCAL lSelect

  IF ValType(oBrw)!="O"
    RETURN .F.
  ENDIF

  nArrayAt:=oBrw:nArrayAt
  nRowSel :=oBrw:nRowSel
  lSelect :=oBrw:aArrayData[nArrayAt,nCol]

  oBrw:aArrayData[oBrw:nArrayAt,nCol]:=!lSelect
  oBrw:RefreshCurrent()

RETURN .T.

// Exportar Programas
FUNCTION RunRestore(oMySqlR)
  LOCAL aSelect:={},cSql,oData,cWhere,I
  LOCAL nT1:=Seconds(),cFileZip:=ALLTRIM(oMySqlR:cPath)+"respaldo.zip"

  oData:=DATACONFIG("CONFIG","RESPALDO")
  oData:Set("cLogin",oMySqlR:cLogin)
  oData:Set("cPass" ,oMySqlR:cPass )
  oData:Set("PATH"  ,oMySqlR:cPath  )
  oData:Save()
  oData:End()

  oMySqlR:oMeterR:SetTotal(LEN(oMySqlR:oBrw:aArrayData))
  oMySqlR:cMemo :=""
  oMySqlR:cNo   :=""
  oMySqlR:cSi   :=""
  oMySqlR:aFiles:={}

  oMySqlR:oMemo:SetText("Iniciando Proceso")

  FOR I:=1 TO LEN(oMySqlR:oBrw:aArrayData)

    oMySqlR:oMeterR:Set(I)

    IF oMySqlR:oBrw:aArrayData[I,6]

      oMySqlR:oDB:SetText("Base de Datos: "+oMySqlR:oBrw:aArrayData[I,1])
      oMySqlR:MYSQLBACK(ALLTRIM(oMySqlR:cPath),ALLTRIM(oMySqlR:oBrw:aArrayData[I,1]))


    ENDIF

  NEXT I

  IF !Empty(oMySqlR:cNo)

    oMySqlR:lRunOk :=.F.
    MensajeErr("Revise Login y PassWord"+CRLF+oMySqlR:cNo)

  ELSE

    CursorWait()

    oMySqlR:cMemo:=oMySqlR:cMemo+CRLF+" Creando "+cFileZip
    oMySqlR:oMemo:Refresh(.T.)

    SysRefresh(.T.)

    oMySqlR:lRunOk:=.T.

    IF oMySqlR:lMsgRun 
      MensajeInfo(CRLF+oMySqlR:cSi,"Recuperación Existosa...")
    ENDIF

  ENDIF

  CursorArrow()

  IF oMySqlR:lAutoClose
    oMySqlR:Close()
  ENDIF

RETURN NIL

// Iniciar Exportar Programas
FUNCTION EXPORTRUN(oEdit)
  LOCAL cFileDbf,oData,oCursor,cError:=""

  ? "AQUI DEBE GRABAR LA ULTIMA FECHA DE RESPALDOS"
RETURN .T.

// Cambiar Modulo
FUNCTION PRGCHANGE(oMySqlR)
  LOCAL aData,I
RETURN .T.

FUNCTION COPYMODULO(oMySqlR,cModulo)
RETURN aData

// Seleccionar Todos los Programas de la Lista
FUNCTION SelectAll(oMySqlR)
  LOCAL I,nCol:=5,nCuantos:=0,lSelect:=.T.

  lSelect:=!oMySqlR:oBrw:aArrayData[1,5]

  FOR I=1 TO LEN(oMySqlR:oBrw:aArrayData)
    oMySqlR:oBrw:aArrayData[I,5]:=lSelect
  NEXT I
   
  oMySqlR:oBrw:Refresh(.T.)
RETURN .T.

// Selecciona o Desmarca a Todos
FUNCTION ChangeAllImp(oFrm)
  LOCAL oBrw:=oFrm:oBrw
  LOCAL lSelect:=!oBrw:aArrayData[1,6]

  AEVAL(oBrw:aArrayData,{|a,n|oBrw:aArrayData[n,6]:=lSelect})

  oBrw:Refresh(.T.)
RETURN .T.

// Realiza el Backup
FUNCTION MYSQLBACK(cPath,cDB)
   LOCAL cComand:="",cBat:="RUN.BAT",cOut,oData,aDir,cNo:=""
   LOCAL cFileZip,aFiles,cLog,cFile,cSay,cCodEmp
   LOCAL cWhere:=""
   LOCAL oConfig:=OpenOdbc(oDp:cDsnConfig)
   LOCAL cDbName

   CursorWait()

   cPath:=cPath+IIF(RIGHT(cPath,1)="\","","\")
   cOut :=cPath+cDB+".SQL"

   IF !Empty(oMySqlR:cOut)
     cOut :=cPath+oMySqlR:cOut
   ENDIF

   LMKDIR(cPath)

//   cComand:="MYSQL\mysqldump --opt "+;
//                        " --host="+oDp:cIp+" "+;
//            "-B "+cDB+" --password="+ALLTRIM(oMySqlR:cPass)+;
//            " --user="+ALLTRIM(oMySqlR:cLogin)+IIF(!oMySqlR:lZip," -t ","")+" -e > "+cOut


   cFileZip:=cPath+cDB
   cFile   :=cPath+cDB

// ? cFileZip,FILE(cFileZip)

   IF ".ZIP"$UPPER(cFileZip)

      cFile:=oDp:cBin+"TEMP\"

      oMySqlR:oMemo:Append("Descomprimiendo "+cFileZip+" en "+cFile+CRLF)

      HB_UNZIPFILE( cFileZip , {|| nil }, .t., NIL, "TEMP\" , NIL )

      cFile:=oDp:cBin+"TEMP\"+cFileNoExt(cDB)+".SQL"

      cComand:="mysql\mysql.exe "+;
               "-u"+ALLTRIM(oMySqlR:cLogin)+" "+;
               IF(Empty(oMySqlR:cPass),"","-p"+ALLTRIM(oMySqlR:cPass ))+" "+;
               " --host="+oDp:cIp+" "+;
               "< "+cFile

   ELSE


      cComand:="mysql\mysql.exe "+;
               "-u"+ALLTRIM(oMySqlR:cLogin)+" "+;
               IF(Empty(oMySqlR:cPass),"","-p"+ALLTRIM(oMySqlR:cPass ))+" "+;
               " --host="+oDp:cIp+" "+;
               "< "+cPath+cDB

   ENDIF

   cSay:=STRTRAN(cComand,oMySqlR:cLogin,"****")
   cSay:=STRTRAN(cComand,oMySqlR:cPass ,"****")

   oMySqlR:oMemo:Append(cSay+CRLF)

   oMySqlR:cMemo:=oMySqlR:cMemo+IIF(Empty(oMySqlR:cMemo),"",CRLF)+cComand

//   IF !Empty(oMySqlR:cPass)
//    oMySqlR:cMemo:=STRTRAN(oMySqlR:cMemo,"--password="+ALLTRIM(oMySqlR:cPass),"--password=****")
//   ENDIF
//   oMySqlR:oMemo:Refresh(.T.)

   MemoWrit(cBat,cComand)
 
   CursorWait()

   cDbName:=cFileNoExt(cDB)
// no remueve la base de datos
//   oConfig:EXECUTE([DROP DATABASE IF EXISTS ]+UPPER(cDbName))
//   oConfig:EXECUTE([DROP DATABASE IF EXISTS ]+LOWER(cDbName))

   oConfig:End()

   MsgRun("Recuperando Respaldo "+cDbName,"Por favor espere",{|| WaitRun(cBat,0)})

   cDB   :=cFileNoPath(cDB)
   cDB   :=cFileNoExt(cDB)

   cWhere:="EMP_BD"+GetWhere("=",cDB)
  

   IF !ISSQLFIND("DPEMPRESA",cWhere)

      cCodEmp:=SQLINCREMENTAL("DPEMPRESA","EMP_CODIGO")

      IF Empty(cCodEmp)
         cCodEmp:=RIGHT(STRTRAN(TIME(),":",""),4)
      ENDIF

      cWhere:="EMP_CODIGO"+GetWhere("=",cCodEmp)

      EJECUTAR("CREATERECORD","DPEMPRESA",{"EMP_CODIGO","EMP_NOMBRE","EMP_BD","EMP_ACTIVA" },;
                                          {cCodEmp     ,cDB         ,cDB     ,.T.          },;
               NIL,.T.,cWhere)

      EJECUTAR("DPEMPUSUARIOASG","DPEMPRESA",cCodEmp)

   ENDIF

//      SQLUPDATE("DPEMPRESA",{"EMP_FCHRES","EMP_HORRES","EMP_SELRES"},;
//                            {oDp:dFecha,oDp:cHora,oMySqlR:oBrw:aArrayData[I,6]},;
//                            "EMP_CODIGO"+GetWhere("=",oMySqlR:oBrw:aArrayData[I,1]))

   IF !ISPCPRG()
     ferase(cBat)
   ENDIF

   SysRefresh(.T.)

   // Buscar Resultado
   aDIR:=DIRECTORY(cOut)

   cLog:=MemoRead(cOut)

   IF Empty(aDir) .OR. aDir[1,2]=0
     cLog:=MEMOREAD(cOut)
     FERASE(cOut)
   ENDIF

   aFiles:={}


   IF !file(cOut) .AND. .F.

     AUDITAR("PROC" , NIL ,"Recuperación","No Recuperado en "+cDB)
     oMySqlR:cMemo:=oMySqlR:cMemo+CRLF+" Respaldo no Recuperado en "+cOut+CRLF+cLog
     oMySqlR:cNo  :=oMySqlR:cNo  +IIF(Empty(oMySqlR:cNo), "", CRLF)+;
                    "Respaldo "+cDB+" no Recuperado en "+cOut

   ELSE

     AUDITAR("PROC" , NIL ,"Repaldo","Recuperado en "+cDB+" > "+STRTRAN(cOut,"\","/") )
     oMySqlR:cMemo:=oMySqlR:cMemo+CRLF+" Respaldo Recuperado en "+cOut
     oMySqlR:cSi  :=oMySqlR:cSi  +IIF(Empty(oMySqlR:cSi), "", CRLF)+;
                    "Respaldo "+cDB+" Recuperado Exitosamente en "+cOut

   ENDIF

   SysRefresh()

RETURN .T.

FUNCTION BRWRESTOREPAR()
RETURN EJECUTAR("BRWRESTOREPAR",oMySqlR)

FUNCTION LEERDIR(cMask,oBrw)
  LOCAL aData:=DIRECTORY(cMask),cFile,I
  LOCAL cDir :=cFilePath(cMask),cName:="",oTable

  FOR I=1 TO LEN(aData)

     cName:=""
     cFile:=cDir+cFileNoExt(aData[I,1])+".TXT"

     oTable:=EJECUTAR("TXTTOTABLE",cFile)

     IF oTable=NIL
        cName:=oTable:EMP_NOMBRE+" "+CTOO(oTable:EMP_FCHULT,"C")
     ENDIF

     aData[I,5]:=cName

     AADD(aData[I],.F.)

  NEXT I

  IF Empty(aData)
    AADD(aData,{"",0,CTOD(""),"","",.F.})
  ENDIF

  IF ValType(oBrw)="O"
     oBrw:aArrayData:=ACLONE(aData)
     oBrw:Refresh(.T.)
     oBrw:Gotop()
  ENDIF

RETURN aData

FUNCTION CAMBIARDIR()
  
   IF Empty(oMySqlR:oBrw:aArrayData[1,1]) .AND. ".SQL"$UPPER(oMySqlR:cMask)
     oMySqlR:lZip:=.T.
     EVAL(oMySqlR:oZip:bChange)
   ENDIF

   IF Empty(oMySqlR:oBrw:aArrayData[1,1]) .AND. ".ZIP"$UPPER(oMySqlR:cMask)
     oMySqlR:lZip:=.F.
     EVAL(oMySqlR:oZip:bChange)
   ENDIF

RETURN .T.
// EOF

