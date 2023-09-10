// Programa   : TEST_SUBQUERY
// Fecha/Hora : 10/09/2023 10:12:55
// Propósito  : Crear consulta SQL con Sub-Consultas
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL cSql,cSub01,cSub02,aData

  cSql  :=" SELECT "+;
          " SUC_CODIGO,SUC_DESCRI,&SUB01 AS CLIENTES,&SUB02 AS BANCOS,SUC_EMPRES,SUC_ACTIVO"+;
          " FROM DPSUCURSAL "+;
          " WHERE &SUB02=0 "+;
          " GROUP BY SUC_CODIGO "+;
          " HAVING CLIENTES<2 "+;
          " ORDER BY SUC_CODIGO "

  cSub01:=" SELECT COUNT(*) FROM DPCLIENTES WHERE CLI_CODSUC=SUC_CODIGO"
  cSub02:=" SELECT COUNT(*) FROM DPCTABANCO WHERE BCO_CODSUC=SUC_CODIGO"

  cSql  :=EJECUTAR("SQLINSERTSUBQUERY",cSql,cSub01,"SUB01")
  cSql  :=EJECUTAR("SQLINSERTSUBQUERY",cSql,cSub02,"SUB02")

  aData :=ASQL(cSql)

  ViewArray(aData)

RETURN cSql
// EOF

