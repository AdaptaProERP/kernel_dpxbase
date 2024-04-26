// Programa   : INSTALLSERVICEPACK
// Fecha/Hora : 26/04/2024 20:46:47
// Prop�sito  : Descargar y Ejecutar programa de instalaci�n
// Creado Por : Juan Navas
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL cFileBin:="adpv60_prod_reinstall_pack_diccionariodedatos.exe"
  LOCAL cDir    :="bin\"
  LOCAL cUrl    :=oDp:cUrlDownLoad+"descargas/"+cFileBin
  LOCAL cSaveAs :=oDp:cBin+"bin\"+cFileBin

  IF !EJECUTAR("DPMDICANT",NIL,.T.)
     RETURN .F.
  ENDIF

  IF !MsgNoYes("Desea Descargar Programa de Actualizaci�n Service Pack")
     RETURN .F.
  ENDIF

  ferase(cSaveAs)
  URLDownLoad(cUrl, cSaveAs)

  IF file(cSaveAs)
     SHELLEXECUTE(oDp:oFrameDp:hWND,"open",cSaveAs)
     EJECUTAR("DPFIN",.T.)
  ENDIF

RETURN .T.
// EOF
