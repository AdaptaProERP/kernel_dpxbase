// Programa   : SQLINSERTSUBQUERY
// Fecha/Hora : 10/09/2023 09:59:49
// Propósito  : Simplificar la implementación de SubQuery en Consultas SQL
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cSql,cSub,cLabel)

   IF Empty(cSql)

      cSql  :=" SUC_CODIGO,SUC_DESCRI,&SUB01 AS CLIENTES,SUC_EMPRES,SUC_ACTIVO"+;
              " FROM DPSUCURSAL "+;
              " GROUP BY SUC_CODIGO "+;
              " ORDER BY SUC_CODIGO "

      cLabel:="SUB01"

      cSub  :=" SELECT COUNT(*) FROM DPCLIENTES WHERE CLI_CODSUC=SUC_CODIGO"

   ENDIF

   cSub  :=ALLTRIM(cSub)
   cLabel:=IF("&"$cLabel,"","&")+cLabel

   IF !"LIMIT 1"$cSub
       cSub:=cSub+" LIMIT 1"
   ENDIF

   IF !LEFT(cSub,1)="("
      cSub:="("+cSub
   ENDIF

   IF !RIGHT(cSub,1)=")"
      cSub:=cSub+")"
   ENDIF

   cSql:=STRTRAN(cSql,cLabel,CRLF+cSub+CRLF)

RETURN  cSql
// EOF
