// Programa   : DLLCRYSTALDOWNLOAD
// Fecha/Hora : 30/12/2023 09:57:36
// Propósito  : Descargar DLLCRYSTAL 
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cOut)
  LOCAL cDir    :=Lower(cFileNoExt(cFileName(oDp:cBinExe)))
  LOCAL cFile   :="dllcrystal9.zip"
  LOCAL cUrl    :=oDp:cUrlDownLoad+cDir+"/"+cFile
  LOCAL cSaveAs :=oDp:cBin+"temp\"+cFile
  LOCAL cFileDll
  
  DEFAULT cOut:=GetEnv("SystemRoot")+"\SYSTEM32"

  cFileDll:=cOut+"\CRPE32.DLL"

  ferase(cSaveAs)

  URLDownLoad(cUrl, cSaveAs)

  HB_UNZIPFILE( cSaveAs , {|| nil }, .t., NIL, cOut , NIL )

  IF FILE(cFileDll)
     MsgMemo("Archivo "+cFileDll+" Instalado Existosamente")
  ELSE
     MsgMemo("Archivo "+cFileDll+" no pudo ser Instalado","Requiere Permiso de Copiar en "+cOut)
  ENDIF

RETURN .t.
// eof
