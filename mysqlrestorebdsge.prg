// Programa   : MYSQLRESTOREBDSGE
// Fecha/Hora : 16/06/2020 12:11:43
// Propósito  : Recuperar respaldos con Mysql
// Creado Por : Juan Navas
// Llamado por: DPMENU
// Aplicación : Definiciones
// Tabla      : TODAS
// mysqldump --add-drop-database --databases -hhost -uusuario -ppassword basededatos > basededatos.sql

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cPath,cDb,cDbD)
   LOCAL cComand:="",cBat:="RUN.BAT",cOut,oData,aDir,cNo:=""
   LOCAL cFileZip,aFiles,cLog,cFile,cSay,cCodEmp
   LOCAL cWhere:=""
   LOCAL cFileMem:="MYSQL.MEM"
   LOCAL _MycPass:="",_MycLoging:="",cPass,cLogin,nT1,nAT,oDb

   REST FROM (cFileMem) ADDI

   cPass  :=ENCRIPT(_MycPass  ,.F.)
   cLogin :=ENCRIPT(_MycLoging,.F.)

   CursorWait()

   DEFAULT cPath:=oDp:cDsnData,;
           cDb  :=oDp:cDsnData,;
           cDbD :=oDp:cDsnData

//   nAt:=ASCAN(oDp:oMySqlCon:aDataBases,{|c,n| ALLTRIM(UPPER(c))==ALLTRIM(UPPER(cDb))})
//   IF nAt=0
//     oDp:oMySqlCon:CreateDB(cDB )
//   ENDIF

   IF !oDp:oMySqlCon:ExistDb(cDb)
     oDp:oMySqlCon:CreateDB(cDb)
   ENDIF


   cPath:=cPath+IIF(RIGHT(cPath,1)="\","","\")
   cOut :=cPath+cDB+".SQL"

   LMKDIR(cPath)

   cFileZip:=cPath+cDB+".ZIP"
   cFile   :=cPath+cDB+".SQL"

   nT1:=SECONDS()

   IF FILE(cFileZip)

      HB_UNZIPFILE( cFileZip , {|| nil }, .t., NIL, cPath+"\" , NIL )

   ENDIF

   IF !FILE(cFile)
      MsgMemo("Archivo SCRIPT "+cFile+" No Existe","La base de datos sera creada desde DATADBF\*.DBF")
      EJECUTAR("DPCREATEFROMDPTABLAS")
      RETURN .F.
   ENDIF

   IF !FILE("mysql\mysql.exe")
      MsgMemo("mysql\mysql.exe no Exite","La base de datos sera creada desde DATADBF\*.DBF")
      EJECUTAR("DPCREATEFROMDPTABLAS")
      RETURN .F.
   ENDIF

  
   cComand:="mysql\mysql.exe "+;
            "-u"+ALLTRIM(cLogin)+" "+;
            IF(Empty(cPass),"","-p"+ALLTRIM(cPass ))+" "+;
            " --host="+oDp:cIp+" "+;
            " --port="+LSTR(oDp:nPort)+;
            " "+cDbD+""+;
            "< "+cFile

   MemoWrit(cBat,cComand)
 
   CursorWait()

   MsgRun("Ejecutando Script "+cFile,"Creando Base de Datos "+cDbD,{|| WaitRun(cBat,0)})

   IF !ISPCPRG()
 //    ferase(cBat)
   ENDIF

   SysRefresh(.T.)

   DPWRITE("TEMP\TIME_"+cDbD+".TXT",LSTR(Seconds()-nT1)+" Segundos creando "+cDb)

   // Buscar Resultado
   aDIR:=DIRECTORY(cOut)

   cLog:=MemoRead(cOut)

   IF Empty(aDir) .OR. aDir[1,2]=0
     cLog:=MEMOREAD(cOut)
     FERASE(cOut)
   ENDIF

   SysRefresh()

   // Si la base de datos fue creada y tiene Tablas, devuelve .T. , Si devuelve .F. , Genera la creación de Tablas de manera clasica
   nAt:=ASCAN(oDp:oMySqlCon:aDataBases,{|c,n| ALLTRIM(UPPER(c))==ALLTRIM(UPPER(cDb))})

   IF nAt>0

     oDb:=OPENODBC(cDb)

     IF !Empty(oDb:GetTables())

        oDp:lChekBD:=.F.
        DPWRITE(cDb+".chk",cLog)
        RETURN .T.

     ELSE

        // EJECUTAR("SQLCREATETABLE","SQLCREATEDB",oDp:cDsnData)
        EJECUTARR("DPCREATEFROMDPTABLAS")

     ENDIF

   ENDIF

RETURN .F.
// EOF


