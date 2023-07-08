// Programa   : DPCREABDFROMSCRIPT
// Fecha/Hora : 07/07/2023 23:43:00
// Propósito  : Crear Base de Datos desde DPSGEV60\DPSGEV60.SQL 
//              Sino está es generador desde mysqldump.exe solo estructura de datos
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cDbOrg,cDbDes)
    LOCAL cComand:="",cBat:="RUN.BAT",cOut,oData,aDir,cNo:=""
    LOCAL cFileZip,aFiles,cLog,cSay,cCodEmp
    LOCAL cDir    :="DP"+oDp:cType+"V"+STRZERO(oDp:nVersion*10,2)
    LOCAL cFileOrg:=cDir+"\"+cDir+".SQL"
    LOCAL cFileDes
    LOCAL cMemo,nAt
    LOCAL cFile   :="TEMP\MYSQL.LOG"
    LOCAL cFileMem:="MYSQL.MEM"
    LOCAL _MycPass:="",_MycLoging:="",cPass,cLogin,nT1,nAT,oDb

    REST FROM (cFileMem) ADDI

    cPass  :=ENCRIPT(_MycPass  ,.F.)
    cLogin :=ENCRIPT(_MycLoging,.F.)

    DEFAULT cDbDes:="SGEV60_TEST",;
            cDbOrg:=cDir

    cMemo   :=MEMOREAD(cFileOrg)
    nAt     :=AT(cDbOrg,cMemo)
    cMemo   :=STRTRAN(cMemo,cDbOrg,cDbDes)
    cFileDes:="TEMP\"+cDbDes+".SQL"

    DPWRITE(cFileDes,cMemo)

    IF !oDp:oMySqlCon:ExistDb(cDbDes)
      oDp:oMySqlCon:CreateDB(cDbDes)
    ENDIF

    cComand:="mysql\mysql.exe "+;
            "-u"+ALLTRIM(cLogin)+" "+;
            IF(Empty(cPass),"","-p"+ALLTRIM(cPass ))+" "+;
            " --host="+oDp:cIp+" "+;
            " --port="+LSTR(oDp:nPort)+;
            " "+cDbDes+""+;
            "< "+cFileDes

   MemoWrit(cBat,cComand)
 
   CursorWait()

   MsgRun("Ejecutando Script "+cFileDes,"Creando Base de Datos "+cDbDes,{|| WaitRun(cBat,0)})

   EJECUTAR("ADDCLONE",cDbOrg,cDbDes) // evita revisar el release

RETURN .T.
// EOF
