// Programa   : DOWNLOADSERVICEPACKP
// Fecha/Hora : 02/11/2023 15:46:01
// Prop�sito  : Descargar el programa que hace la actualizaci�n
// Creado Por : Juan Navas
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oMemo)
   LOCAL cUrl,cSaveAs
   LOCAL aFiles:={},I,aZip:={},cFileZip
   LOCAL nT1 :=SECONDS(),cPing,cIp:="191.96.151.60"
   LOCAL cDir:=Lower(cFileNoExt(cFileName(oDp:cBinExe)))


   CursorWait()

   IF(ValType(oMemo)="O",oMemo:Append("Validando Conexi�n con "+cIp+CRLF),NIL)

   cPing:=EJECUTAR("GETPING",cIp,.F.)

   IF "NO PUDO"$UPPER(cPing)

     IF ValType(oMemo)="O"
        oMemo:Append("No hay Conexi�n con "+cIp+CRLF)
     ELSE
        MsgMemo("No hay Conexi�n con "+cIP)
     ENDIF

     RETURN .F.

   ENDIF

   ShutDownScr("downloadservicepack")
   AADD(aFiles,"downloadservicepack.dxbx")

   IF(ValType(oMemo)="O",oMemo:Append("Descargando "+CRLF),NIL)
   IF(ValType(oMemo)="O",oMemo:Append("-----------"+CRLF),NIL)

   FOR I=1 TO LEN(aFiles)

    cUrl   :="http://191.96.151.60/~ftp16402/"+cDir+"/"+aFiles[I]
    cSaveAs:=oDp:cBin+"temp\"+aFiles[I]

    IF(ValType(oMemo)="O",oMemo:Append(" "+aFiles[I]+CRLF),NIL)

    CursorWait()
    ferase(cSaveAs)
    URLDownLoad(cUrl, cSaveAs)

    IF FILE(cSaveAs) .AND. cFileExt(cSaveAs)=".ZIP"
      AADD(aZip,cSaveAs)
    ENDIF

    SysRefresh(.T.)

   NEXT I

RETURN .T.
// EOF
