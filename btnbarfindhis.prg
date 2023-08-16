// Programa   : BTNBARFINDHIS          
// Fecha/Hora : 21/02/2022 06:48:09
// Propósito  : Presentar Opciones Según Historial en DPAUDITORIA
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL aData,cSql,cTitle:="Opciones de Ejecución Registradas",cWhere_:=NIL

   cSql :=[SELECT  AUD_CLAVE, AUD_SCLAVE,AUD_TCLAVE,AUD_CCLAVE,1 AS LOGICO FROM  dpauditoria WHERE AUD_USUARI]+GetWhere("=",oDp:cUsuario)+[ AND AUD_TIPO="BUSB" GROUP BY AUD_CLAVE,AUD_SCLAVE,AUD_TCLAVE,AUD_CCLAVE ORDER BY COUNT(*) DESC ]
   aData:=ASQL(cSql)

   IF Empty(aData)
      RETURN EJECUTAR("BTNBARFINDRUN")
   ENDIF

   EJECUTAR("BTNBARFINDVIEW",aData,cTitle,cWhere_)

RETURN .T.
// EOF
