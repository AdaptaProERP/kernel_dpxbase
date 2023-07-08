// Programa   : ADDCLONE
// Fecha/Hora : 03/05/2023 11:49:25
// Propósito  : Clonar archivos *.ADD desde una empresa hacia Otra
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cDbOrg,cDbDes)
  LOCAL aFiles:={},cDir,I,cFileDes

  DEFAULT cDbOrg:=oDp:cDsnData,;
          cDbDes:="sgev60_0007"

  cDir:="ADD\*_"+cDbOrg+".ADD"

  aFiles:=DIRECTORY(cDir)
  FOR I=1 TO LEN(aFiles)

     cFileDes:="add\"+lower(aFiles[I,1])
     cFileDes:=STRTRAN(cFileDes,lower(cDbOrg),cDbDes)

     copy file("add\"+lower(aFiles[I,1])) TO (cFileDes)

  NEXT I

// ViewArray(aFiles)

RETURN NIL
// EOF

