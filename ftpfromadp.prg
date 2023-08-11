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
/*
FUNCTION FTPFROMADP(cFile,cSaveAs)
Descargar archivos desde el repositorio adaptaPro ubicado en la ruta:
http://191.96.151.60/~ftp16402
contentiene copia de las carpeta de AdaptaPro
SGEV60
DPNMWIN60

La ruta del Archivo es construida según licencia y versión en uso:
http://191.96.151.60/~ftp16402/DP"+oDp:cType+"V"+LSTR(oDp:nVersion*10)+"/"

Su utilización interna aplica cuando falta algún componente, será reemplazado
automáticamente ejemplo c:\dpsgev60\dpxbase\dpreportes.dxbx

También podrá ser descargada discrecionalmente por el usuario desde la
funcionalidad: Ejecutar comando, podrá escribir:

FTPFROMADP("dpxbase\dpreportes.dxbx"), la función devolverá .T. en el caso de
lograr descargar el archivo mediante validación del destino físico
FILE(cFileOutPut), además genera variable oDp:cUrlFileOrg para explorar el
contenido preciso del origen y validar copiándolo en el navegador.
*/
