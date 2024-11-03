// Programa   : DROPDATABASE
// Fecha/Hora : 03/11/2024 05:21:04
// Propósito  : Remover la base de Datos
// Creado Por : Juan Navas
// Llamado por: DPEMPRESA.LBX o desde que se genera el ERROR
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cDb,lRespaldo)
   LOCAL cSql,aTables:={}
   LOCAL oConfig:=OpenOdbc(oDp:cDsnConfig)
   LOCAL oDb

   DEFAULT cDb:="sgev60_0001",;
           lRespaldo:=.T.

// DestroyDB

   oDp:oMySqlCon:ReConnect()

   IF !oDp:oMySqlCon:ExistDb(cDb)
      MsgMemo(cDb+" no está creada")
      RETURN .F.
   ENDIF

   oDb:=OpenOdbc(cDb)

//   oDb:DestroyDB(cDb)
//   cSql:="DROP DATABASE "+cDb

? oConfig:ClassName(),oDb:ClassName()
   aTables:=oDb:GetTables()

ViewArray(aTables)

// ? oDb:ExistDb(cDb)
//   oDb:EXECUTE(cDb)

RETURN .T.
// EOF
