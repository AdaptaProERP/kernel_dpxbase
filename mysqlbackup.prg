// Programa   : MYSQLBACKUP 
// Fecha/Hora : 19/11/2005 12:11:43
// Propósito  : Realizar Backup con Mysql
// Creado Por : Juan Navas
// Llamado por: DPMENU
// Aplicación : Definiciones
// Tabla      : TODAS

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cBd)
  LOCAL aData,nCuantos:=0,oData,cWhere:=""
  LOCAL I,oFontBrw,oBrw,oCol,oFont,oFontB
  LOCAL aCoors:=GetCoors( GetDesktopWindow() )
  LOCAL cTitle:="Realizar Respaldos de Base de Datos MySQL"
  LOCAL cFileMem:="MYSQL.MEM"
  LOCAL _MycPass:="",_MycLoging:=""

  IF Type("oMySqlB")="O" .AND. oMySqlB:oWnd:hWnd>0
     RETURN EJECUTAR("BRRUNNEW",oMySqlB,GetScript())
  ENDIF
   
  IF FILE(cFileMem)

     REST FROM (cFileMem) ADDI

     _MycPass  :=ENCRIPT(_MycPass  ,.F.)
     _MycLoging:=ENCRIPT(_MycLoging,.F.)

  ENDIF

  lMkDir("respaldo")

  oDp:lExcluye:=.F.

  IF !Empty(cBd)
     cBd:=ALLTRIM(cBd)
     cWhere:=" WHERE EMP_BD"+GetWhere("=",cBd)
  ENDIF

  aData:=ASQL("SELECT EMP_CODIGO,EMP_NOMBRE,EMP_BD,EMP_FCHRES,EMP_HORRES,EMP_SELRES FROM DPEMPRESA "+cWhere+" ORDER BY CONCAT(EMP_FCHRES,EMP_HORRES,EMP_SELRES) DESC ")

  nCuantos:=LEN(aData)

  DEFINE FONT oFontBrw NAME "Tahoma" SIZE 0,-12

  oData:=DATACONFIG("CONFIG","RESPALDO")
  oData:End(.F.)

  DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -12 
  DEFINE FONT oFontB NAME "Tahoma"   SIZE 0, -12 BOLD

  DpMdi(cTitle,"oMySqlB","MYSQLBACKUP.EDT")
  oMySqlB:Windows(0,0,aCoors[3]-160,MIN(780,aCoors[4]-10),.T.) // Maximizado

  oMySqlB:cPath  :=oData:Get("PATH"  ,CURDRIVE()+":\"+CurDir()+"\respaldo\")
  oMySqlB:dFchRes:=oData:Get("FCHRES",CTOD(""))
  oMySqlB:cHorRes:=oData:Get("HORRES",CTOD(""))
  oMySqlB:lSelRes:=oData:Get("SELRES",.T.     )
  oMySqlB:cPath  :=STRTRAN(oMySqlB:cPath,"\"+"\","\")
  oMySqlB:cPath  :=STRTRAN(oMySqlB:cPath,"\"+"\","\")
  oMySqlB:cPath  :=PADR(oMySqlB:cPath,120)

  IF Empty(cBd)
    AADD(aData,{"SYS", oDp:cDpSys ,oDp:cDsnConfig,oMySqlB:dFchRes,oMySqlB:cHorRes,oMySqlB:lSelRes})
  ELSE
    aData[1,6]:=.T.
  ENDIF

  oMySqlB:nRecord   :=0
  oMySqlB:lStruct   :=.T.  // No Incluye Estructura de Datos
  oMySqlB:cMemo     :=" mysqldump.exe requiere usuario y clave con permiso para ejecutar generación de respaldos"
  oMySqlB:lMsgBar   :=.F.
  oMySqlB:lAutoClose:=.F.
  oMySqlB:lBarDef   :=.T.
  oMySqlB:lVistas   :=.T.
  oMySqlB:lIntRef   :=.T.
  oMySqlB:cMemoBack :=""     

  oMySqlB:cLogin:=_MycLoging
  oMySqlB:cPass :=_MycPass  

  oMySqlB:nClrText :=CLR_HBLUE
  oMySqlB:nClrText1:=2039583

  oMySqlB:cOut   :=""
  oMySqlB:lMsgRun:=.T.
  oMySqlB:lRunOk :=.F.
  oMySqlB:aFiles :={} // Respaldo con todos los SQL
  oMySqlB:nCuantos:=LEN(aData)

  oMySqlB:oBrw:=TXBrowse():New( oMySqlB:oWnd )
  oBrw:=oMySqlB:oBrw

  oBrw:SetArray( aData )
  oBrw:SetFont(oFontBrw)

  oBrw:lFastEdit:= .T.
  oBrw:lHScroll := .F.
  oBrw:nFreeze  := 3

  oCol:=oBrw:aCols[1]
  oCol:cHeader:="Código"
  oCol:bLDClickData:={||oMySqlB:PrgSelect(oMySqlB)}

  oCol:=oBrw:aCols[2]
  oCol:cHeader:="Empresa"
  oCol:nWidth:=300
  oCol:bLDClickData:={||oMySqlB:PrgSelect(oMySqlB)}

  oCol:=oBrw:aCols[3]
  oCol:cHeader:= "Base de Datos"
  oCol:nWidth:= 180
  oCol:bLDClickData:={||oMySqlB:PrgSelect(oMySqlB)}

  oCol:=oBrw:aCols[4]
  oCol:cHeader:="Fecha"
  oCol:nWidth:=160
  oCol:bLDClickData:={||oMySqlB:PrgSelect(oMySqlB)}

  oCol:=oBrw:aCols[6]
  oCol:cHeader:="Ok"
  oCol:nWidth:= 25
  oCol:AddBmpFile("BITMAPS\checkverde.bmp")
  oCol:AddBmpFile("BITMAPS\checkrojo.bmp")

  oCol:bBmpData:={||oBrw:=oMySqlB:oBrw,IIF(oBrw:aArrayData[oBrw:nArrayAt,6],1,2) }
  oCol:nDataStyle:=oCol:DefStyle( AL_LEFT, .F.)
  oCol:bLDClickData:={||oMySqlB:PrgSelect(oMySqlB)}
  oCol:bLClickHeader:={|nRow,nCol,nKey,oCol|oMySqlB:ChangeAllImp(oMySqlB,nRow,nCol,nKey,oCol,.T.)}
  oCol:bStrData     :={||""}

  oBrw:bClrStd:={|oBrw|oBrw:=oMySqlB:oBrw,nAt:=oBrw:nArrayAt, { iif( oBrw:aArrayData[nAt,6], oMySqlB:nClrText ,  oMySqlB:nClrText1 ),;
                                               iif( oBrw:nArrayAt%2=0, oMySqlB:nClrPane1 ,  oMySqlB:nClrPane2  ) } }

  oBrw:bClrSel:={|oBrw|oBrw:=oMySqlB:oBrw,{65535,16733011}}

  oBrw:bClrHeader := {|| {0,oDp:nGrid_ClrPaneH}}
  oBrw:bClrFooter := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

  oMySqlB:oBrw:CreateFromCode()
  oMySqlB:bValid   :={|| EJECUTAR("BRWSAVEPAR",oMySqlB)}
  oMySqlB:BRWRESTOREPAR()

  oMySqlB:oWnd:oClient := oMySqlB:oBrw

  oMySqlB:oFocus:=oBrw
  oMySqlB:Activate({||oMySqlB:NMCONBAR(oMySqlB)})

RETURN oMySqlB

// Coloca la Barra de Botones
FUNCTION NMCONBAR(oMySqlB)
  LOCAL oCursor,oBar,oBtn,oFont,oCol,nDif
  LOCAL nWidth :=0 // Ancho Calculado segœn Columnas
  LOCAL nHeight:=0 // Alto
  LOCAL nLines :=0 // Lineas
  LOCAL oDlg   :=oMySqlB:oWnd

  DEFINE FONT oFont NAME "Tahoma" SIZE 0,-10 BOLD

  DEFINE CURSOR oCursor HAND
  DEFINE BUTTONBAR oBar SIZE 80,170+60 OF oDlg 3D CURSOR oCursor

  DEFINE BUTTON oMySqlB:oBtnRun OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\RUN.BMP";
         TOP PROMPT "Ejecutar"; 
         ACTION oMySqlB:RunBackup(oMySqlB)

  oMySqlB:oBtnRun:cToolTip:="Iniciar Respaldo de Datos"

/*
  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\SELECT.BMP";
         ACTION oMySqlB:SelectAll(oMySqlB)

  oBtn:cToolTip:="Seleccionar Todas las Bases de Datos"
*/
  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\XFIND.BMP";
         TOP PROMPT "Buscar"; 
         ACTION EJECUTAR("BRWSETFIND",oMySqlB:oBrw)

  oBtn:cToolTip:="Buscar Base de Datos"


  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\FILTRAR.BMP";
          TOP PROMPT "Filtrar"; 
          MENU EJECUTAR("BRBTNMENUFILTER",oMySqlB:oBrw,oMySqlB);
          ACTION EJECUTAR("BRWSETFILTER",oMySqlB:oBrw)

  oBtn:cToolTip:="Filtrar Registros"


  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\xTOP.BMP";
         TOP PROMPT "Inicio" FONT oFont; 
         ACTION (oMySqlB:oBrw:GoTop(),oMySqlB:oBrw:Setfocus())

  oBtn:cToolTip:="Primera Base de Datos"

  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\xFIN.BMP";
         TOP PROMPT "Ultimo"; 
         ACTION (oMySqlB:oBrw:GoBottom(),oMySqlB:oBrw:Setfocus())

  oBtn:cToolTip:="Ultima Base de Datos"

  DEFINE BUTTON oBtn OF oBar NOBORDER FONT oFont FILENAME "BITMAPS\XSALIR.BMP";
         TOP PROMPT "Cerrar"; 
         ACTION oMySqlB:Close()

  oBtn:cToolTip:="Cerrar Formulario"

  AEVAL(oBar:aControls,{|o,n|o:cMsg:=o:cToolTip})

  oMySqlB:oBrw:SetColor(0,oDp:nClrPane1)

  oBar:SetColor(CLR_BLACK,oDp:nGris)

  AEVAL(oBar:aControls,{|o,n|o:SetColor(CLR_BLACK,oDp:nGris)})

  oMySqlB:SETBTNBAR(45+10,45+10,oBar)

  @ 10,1 SAY "Carpeta Destino" FONT oFont 
  @ 11.5,1 SAY oMySqlB:oDB PROMPT PADR("Proceso",40)

  @ 12,01 METER oMySqlB:oMeterR VAR oMySqlB:nRecord

  @ 12,1 BMPGET oMySqlB:oPath VAR oMySqlB:cPath NAME "BITMAPS\FOLDER5.BMP";
                              ACTION (cDir:=cGetDir(oMySqlB:cPath),;
                              IIF(!EMPTY(cDir),oMySqlB:oPath:VarPut(PADR(cDir,60),.t.),NIL))

  oMySqlB:oPath:cToolTip:="Carpeta Destino del Respaldo, Presione F6 para Seleccionar"

  @ 02,40 GET oMySqlB:oMemo VAR  oMySqlB:cMemo MULTILINE READONLY SIZE 100,100

  @ 1,1 CHECKBOX oMySqlB:oStruct VAR oMySqlB:lStruct PROMPT "Incluye Estructura"

  @ 3,0 CHECKBOX oMySqlB:oVistas VAR oMySqlB:lVistas PROMPT "Incluir Vistas"

  @ 3,0 CHECKBOX oMySqlB:oIntRef VAR oMySqlB:lIntRef PROMPT "Integridad Referencial"

  oMySqlB:oIntRef:cToolTip:="Remover Integredad Referencial"+CRLF+"Seran Removidas de la Base de Datos"

  oMySqlB:oVistas:cToolTip:="Excluir las Vistas"+CRLF+"Seran Removidas de la Base de Datos"

  BMPGETBTN(oMySqlB:oPath) // ,nil,13)

  oMySqlB:oStruct:cToolTip:="Sin estructura el Respaldo es optimo"+CRLF+"sólo será recuperado en Base de datos que si estructura"

  oBar:SetColor(CLR_BLACK,oDp:nGris2)


RETURN .T.

// Seleccionar Concepto
FUNCTION PrgSelect(oMySqlB)
  LOCAL oBrw:=oMySqlB:oBrw
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
FUNCTION RunBackup(oMySqlB)
  LOCAL aSelect:={},cSql,oData,I
  LOCAL nT1  :=Seconds(),cFileZip:=ALLTRIM(oMySqlB:cPath)+"respaldo.zip"
  LOCAL cFile,oTable,cBin:="mysql\mysqldump.exe"

  IF !FILE(cBin)
    MsgMemo(cBin+" no existe","Programa necesario para realizar respaldos")
    RETURN .F.
  ENDIF

  oData:=DATACONFIG("CONFIG","RESPALDO")
  oData:Set("cLogin",oMySqlB:cLogin)
  oData:Set("cPass" ,oMySqlB:cPass )
  oData:Save()
  oData:End()

  oMySqlB:oMeterR:SetTotal(LEN(oMySqlB:oBrw:aArrayData))
  oMySqlB:cMemo :=""
  oMySqlB:cNo   :=""
  oMySqlB:cSi   :=""
  oMySqlB:aFiles:={}

  FOR I:=1 TO LEN(oMySqlB:oBrw:aArrayData)

    oMySqlB:oMeterR:Set(I)

    IF oMySqlB:oBrw:aArrayData[I,6]

      oMySqlB:oDB:SetText("Base de Datos: "+oMySqlB:oBrw:aArrayData[I,3])
      oMySqlB:MYSQLBACK(ALLTRIM(oMySqlB:cPath),ALLTRIM(oMySqlB:oBrw:aArrayData[I,3]))

      cFile:=ALLTRIM(oMySqlB:cPath)+"\"+ALLTRIM(oMySqlB:oBrw:aArrayData[I,3])+".TXT"

      SQLUPDATE("DPEMPRESA",{"EMP_FCHRES","EMP_HORRES","EMP_SELRES"                ,"EMP_FILRES"},;
                            {oDp:dFecha  ,oDp:cHora   ,oMySqlB:oBrw:aArrayData[I,6],oMySqlB:oBrw:aArrayData[I,3]},;
                            "EMP_CODIGO"+GetWhere("=",oMySqlB:oBrw:aArrayData[I,1]))

      oTable:=OpenTable("SELECT * FROM DPEMPRESA WHERE EMP_CODIGO"+GetWhere("=",oMySqlB:oBrw:aArrayData[I,1]),.T.)

      IF oTable:RecCount()>0
         oTable:CTOTXT(cFile)
      ENDIF

      oTable:End()

//:CTOTXT(cFile)

    ENDIF

  NEXT I

  IF !Empty(oMySqlB:cNo)

    oMySqlB:lRunOk :=.F.
    MensajeErr("Revise Login y PassWord"+CRLF+oMySqlB:cNo)

  ELSE

    CursorWait()

    oMySqlB:cMemo:=oMySqlB:cMemo+CRLF+" Creando "+cFileZip
    oMySqlB:oMemo:Refresh(.T.)

    cFileZip:=ALLTRIM(oMySqlB:cPath)+"\respaldo.zip"

    MsgRun("Creando Respalgo General "+cFileZip,"Por favor Espere",{||;
            HB_ZipFile( cFileZip, oMySqlB:aFiles, 9,,.T., NIL, .F., .F. )})

    SysRefresh(.T.)

    oMySqlB:lRunOk:=.T.

// ? oMySqlB:cMemoBack,"oMySqlB:cMemoBack"

    FERASE("respaldo.bat")

    DPWRITE("respaldo.bat",oMySqlB:cMemoBack+CRLF+ cFileNoPath(GetModuleFileName( GetInstance() ))+" PKZIPRESPALDO")

    IF oMySqlB:lMsgRun 
      MensajeInfo(CRLF+oMySqlB:cSi,"RESPALDO EXITOSO...")
    ENDIF

   

  ENDIF


  // Ultima base de datos es CONFIG
  IF oMySqlB:oBrw:aArrayData[LEN(oMySqlB:oBrw:aArrayData),6]

     oData:=DATACONFIG("CONFIG","RESPALDO")

     oData:Set("PATH"  ,oMySqlB:cPath  )
     oData:Set("FCHRES",oMySqlB:dFchRes)
     oData:Set("HORRES",oMySqlB:cHorRes)
     oData:Set("SELRES",.T.            )
     oData:Save()
     oData:End()

  ELSE

     oData:=DATACONFIG("CONFIG","RESPALDO")

     oData:Set("PATH"  ,oMySqlB:cPath  )
     oData:Save()
     oData:End()


  ENDIF

  CursorArrow()

  IF oMySqlB:lAutoClose
    oMySqlB:Close()
  ENDIF

RETURN NIL

// Iniciar Exportar Programas
FUNCTION EXPORTRUN(oEdit)
  LOCAL cFileDbf,oData,oCursor,cError:=""

  ? "AQUI DEBE GRABAR LA ULTIMA FECHA DE RESPALDOS"
RETURN .T.

// Cambiar Modulo
FUNCTION PRGCHANGE(oMySqlB)
  LOCAL aData,I
RETURN .T.

FUNCTION COPYMODULO(oMySqlB,cModulo)
RETURN aData

// Seleccionar Todos los Programas de la Lista
FUNCTION SelectAll(oMySqlB)
  LOCAL I,nCol:=5,nCuantos:=0,lSelect:=.T.

  lSelect:=!oMySqlB:oBrw:aArrayData[1,5]

  FOR I=1 TO LEN(oMySqlB:oBrw:aArrayData)
    oMySqlB:oBrw:aArrayData[I,5]:=lSelect
  NEXT I
   
  oMySqlB:oBrw:Refresh(.T.)
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
   LOCAL cFileZip,aFiles,cLog
  
   CursorWait()

   cPath:=cPath+IIF(RIGHT(cPath,1)="\","","\")
   cOut :=cPath+cDB+".SQL"

   IF !Empty(oMySqlB:cOut)
     cOut :=cPath+oMySqlB:cOut
   ENDIF

   LMKDIR(cPath)

   IF !oMySqlB:lVistas
     EJECUTAR("DROPALLVIEW",cDB)
   ENDIF

   IF !oMySqlB:lIntRef 
     EJECUTAR("DPDROPALL_FK",cDB)
   ENDIF

/*
   cComand:="MYSQL\mysqldump --opt "+;
            " --add-drop-database "+;
            " --host="+oDp:cIp+" "+;
            " --port="+LSTR(oDp:nPort)+" "+;
            "-B "+cDB+;
            " -e "+;
            " -f "+;
            IF(Empty(oMySqlB:cPass),""," --password="+ALLTRIM(oMySqlB:cPass))+;
            " --user="+ALLTRIM(oMySqlB:cLogin)+IIF(!oMySqlB:lStruct," -t ","")+" -e > "+cOut
*/

   cComand:="MYSQL\mysqldump -C --opt "+CRLF+;
            " --add-drop-database  "+CRLF+;
            " --single-transaction "+CRLF+;
            " --skip-lock-tables   "+CRLF+;
            " --lock-tables=false  "+CRLF+;
            " --host="+oDp:cIp+" "  +CRLF+;
            " --port="+LSTR(oDp:nPort)+" "+CRLF+;
            " --default-character-set=utf8 "+CRLF+;
            " --max_allowed_packet=512M "+CRLF+;
            "-B "+cDB+;
            " -e "+;
            " -f "+;
            IF(Empty(oMySqlB:cPass),""," --password="+ALLTRIM(oMySqlB:cPass))+;
            " --user="+ALLTRIM(oMySqlB:cLogin)+IIF(!oMySqlB:lStruct," -t ","")+" -e > "+cOut

   ferase(cOut)

   IF file(cOut)
      oMySqlB:oMemo:Append(" Archivo "+cOut+" Abierto")
      RETURN .F.
   ENDIF

   oMySqlB:cMemo:=oMySqlB:cMemo+IIF(Empty(oMySqlB:cMemo),"",CRLF)+cComand

   IF !Empty(oMySqlB:cPass)
    oMySqlB:cMemo:=STRTRAN(oMySqlB:cMemo,"--password="+ALLTRIM(oMySqlB:cPass),"--password=****")
   ENDIF

   oMySqlB:oMemo:Refresh(.T.)

   cComand:=STRTRAN(cComand,CRLF,"") 

// MsgMemo(cBat+CRLF+cComand,"AQUI")

   DPWRITE(cBat,cComand)
 
   CursorWait()

   MsgRun("Respaldando "+cDB,"Por favor espere",{|| WaitRun(cBat,0)})

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

// ? cBat,"cBat",cLog,cOut
//   ViewArray(aDir,,,.F.)

   aFiles:={}

   IF !file(cOut) 

     AUDITAR("PROC" , NIL ,"Respaldo","No Creado en "+cDB)
     oMySqlB:cMemo:=oMySqlB:cMemo+CRLF+" Respaldo no Creado en "+cOut+CRLF+cLog
     oMySqlB:cNo  :=oMySqlB:cNo  +IIF(Empty(oMySqlB:cNo), "", CRLF)+;
                    "Respaldo "+cDB+" no Creado en "+cOut

   ELSE

     AUDITAR("PROC" , NIL ,"Repaldo","Creado en "+cDB+" > "+STRTRAN(cOut,"\","/") )
     oMySqlB:cMemo:=oMySqlB:cMemo+CRLF+" Respaldo Creado en "+cOut
     oMySqlB:cSi  :=oMySqlB:cSi  +IIF(Empty(oMySqlB:cSi), "", CRLF)+;
                    "Respaldo "+cDB+" Creado Exitosamente en "+cOut

     // Comprime el Archivo
     AADD(oMySqlB:aFiles,cOut)

     cFileZip:=STRTRAN(Lower(cOut),".sql",".zip")

     AADD(aFiles,cOut)

     oMySqlB:cMemo:=oMySqlB:cMemo+CRLF+" Creando "+cFileZip

     HB_ZipFile( cFileZip, aFiles, 9,,.T., NIL, .F., .F. )


     oMySqlB:cMemoBack:=oMySqlB:cMemoBack+IF(Empty(oMySqlB:cMemoBack),"",CRLF)+cComand

//? oMySqlB:cMemoBack

   ENDIF

   oMySqlB:cMemo:=oMySqlB:cMemo+CRLF
   oMySqlB:oMemo:Refresh(.T.)
   SysRefresh()

RETURN .T.

FUNCTION BRWRESTOREPAR()
RETURN EJECUTAR("BRWRESTOREPAR",oMySqlB)
// EOF
	 
