// Programa   : MYSQLRESTORECONFIG
// Fecha/Hora : 19/11/2005 12:11:43
// Propósito  : Recuperar respaldos con Mysql
// Creado Por : Juan Navas
// Llamado por: DPMENU
// Aplicación : Definiciones
// Tabla      : TODAS
// mysqldump --add-drop-database --databases -hhost -uusuario -ppassword basededatos > basededatos.sql

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cPath,cDb)
   LOCAL cComand:="",cBat:="RUN.BAT",cOut,oData,aDir,cNo:=""
   LOCAL cFileZip,aFiles,cLog,cFile,cSay,cCodEmp
   LOCAL cWhere:=""
   LOCAL cFileMem:="MYSQL.MEM"
   LOCAL _MycPass:="",_MycLoging:="",cPass,cLogin,nT1,nAT,oDb

   REST FROM (cFileMem) ADDI

   cPass  :=ENCRIPT(_MycPass  ,.F.)
   cLogin :=ENCRIPT(_MycLoging,.F.)

   oDp:cIp     :=ENCRIPT(_MycIp    ,.F.)
   oDp:cPass   :=ENCRIPT(_MycPass  ,.F.)
   oDp:cLogin  :=ENCRIPT(_MycLoging,.F.)
   oDp:cSqlDate:=ENCRIPT(_MySqlDate,.F.)
   oDp:nPort   :=_MySqlPort


   oDp:cSqlDate:=UPPE(oDp:cSqlDate)
   oDp:bSqlDate :={|nD,nM,nA,cFecha|nA    :=STRZERO(nA,4),;
                                    nM    :=STRZERO(nM,2),;
                                    nD    :=STRZERO(nD,2),;
                                    cFecha:=oDp:cSqlDate ,;
                                    cFecha:=STRTRAN(cFecha,"AAAA",nA),;
                                    cFecha:=STRTRAN(cFecha,"MM"  ,nM),;
                                    cFecha:=STRTRAN(cFecha,"DD"  ,nD),;
                                    cFecha}

   CursorWait()

   DEFAULT cPath:=oDp:cDsnConfig,;
           cDb  :=oDp:cDsnConfig

   oDp:lCreateConfig:=.T. // Esta creando la base de datos
  
   cPath:=cPath+IIF(RIGHT(cPath,1)="\","","\")
   cOut :=cPath+cDB+".SQL"

// ? cPath,cDb,cFileZip,"cPath,cDb,cFileZip"
//   IF !Empty(oMySqlR:cOut)
//     cOut :=cPath+oMySqlR:cOut
//   ENDIF

   IF !oDp:oMySqlCon:ExistDb(cDB )
     oDp:oMySqlCon:CreateDB(cDB )
   ENDIF

   LMKDIR(cPath)

   cFileZip:=cPath+cDB+".ZIP"
   cFile   :=cPath+cDB+".SQL"

   nT1:=SECONDS()

   IF FILE(cFileZip)

      HB_UNZIPFILE( cFileZip , {|| nil }, .t., NIL, cPath+"\" , NIL )

   ENDIF

   IF !FILE(cFile)
      EJECUTAR("SQLCREATETABLE","SQLCONFIG",oDp:cDsnConfig)
      EJECUTAR("MYSQLRESTOREBDSGE")
      RETURN .F.
   ENDIF

   IF !FILE("mysql\mysql.exe")
      MensajeErr("mysql\mysql.exe no Exite","El diccionario de Datos será creados desde DATADBF\")
      EJECUTAR("SQLCREATETABLE","SQLCONFIG",oDp:cDsnConfig)
      EJECUTAR("MYSQLRESTOREBDSGE")
      RETURN .F.
   ENDIF

   // MYSQL de 32 bits requier  la BD existente
  
   cComand:="mysql\mysql.exe "+;
               "-u"+ALLTRIM(cLogin)+" "+;
               IF(Empty(cPass),"","-p"+ALLTRIM(cPass ))+" "+;
               " --host="+oDp:cIp+" "+;
               " --port="+LSTR(oDp:nPort)+;
               " "+cDB+""+;
               "< "+cFile

   MemoWrit(cBat,cComand)
 
   CursorWait()

// ? cComand,"cComand",cBat

   MsgRun("Recuperando Script "+cFile,"Creando Base de Datos "+oDp:cDsnConfig,{|| WaitRun(cBat,0)})

// ? SECONDS()-nT1,"Segundos para Crear la BD con las tablas y vistas"

   IF !ISPCPRG()
   //   ferase(cBat)
   ENDIF

   SysRefresh(.T.)

   // Buscar Resultado
   aDIR:=DIRECTORY(cOut)

   cLog:=MemoRead(cOut)

   IF Empty(aDir) .OR. aDir[1,2]=0
     cLog:=MEMOREAD(cOut)
     FERASE(cOut)
   ENDIF

   SysRefresh()

   // Si la base de datos fue creada y tiene Tablas, devuelve .T. , Si devuelve .F. , Genera la creación de Tablas de manera clasica
   nAt:=ASCAN(oDp:oMySqlCon:aDataBases,{|c,n| ALLTRIM(UPPER(c))==ALLTRIM(UPPER(oDp:cDsnConfig))})

   IF nAt>0

     oDb:=OPENODBC(oDp:cDsnConfig)

     IF !Empty(oDb:GetTables())
        oDp:lChekBD:=.F.
        DPWRITE(oDp:cDsnConfig+".chk",cLog)
        RETURN .T.
     ELSE
        // si no creo las tablas, procede a su creación
        EJECUTAR("SQLCREATETABLE","SQLCONFIG",oDp:cDsnConfig)
        EJECUTAR("MYSQLRESTOREBDSGE")
        // EJECUTAR("IMPORTDPTABLAS") // importa todas las tablas para DPCONFIG
     ENDIF

   ENDIF


RETURN .F.
// EOF

