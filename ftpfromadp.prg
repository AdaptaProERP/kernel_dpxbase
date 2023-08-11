// Programa   : FTPFROMADP
// Fecha/Hora : 11/08/2023 04:08:42
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cFile,cSaveAs)
  LOCAL cDir:="http://191.96.151.60/~ftp16402/DP"+oDp:cType+"V"+LSTR(oDp:nVersion*10)+"/"
  LOCAL cUrl
  LOCAL cDirD

  DEFAULT cFile  :="DPXBASE\AAA.DXBX",;
          cDirD  :=cFilePath(cFile),;
          cSaveAs:=oDp:cBin+cFile

  cUrl   :=LOWER(cDir+cFile)
  cUrl   :=STRTRAN(cUrl,"\","/")
  cSaveAs:=lower(cSaveAs)

  ferase(cSaveAs) // Elimina el Destino

  URLDownLoad(cUrl, cSaveAs)

  oDp:cUrlFileOrg:=cUrl // Copia en Memoria del Archivo Origen
// ? CLPCOPY(cUrl),cSaveAs,FILE(cSaveAs)

RETURN FILE(cSaveAs)
// EOF
