// Programa   : ISTABLEACENTOS
// Fecha/Hora : 19/03/2024 05:28:00
// Prop�sito  : Revisar si Tiene Acentos Distorcionados, originados desde recuperacion de respaldos
// https://www.indalcasa.com/programacion/html/tabla-de-codificaciones-de-caracteres-entre-ansi-utf-8-javascript-html/
// Creado Por : Juan Navas
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable,cField,lAll)
  LOCAL cWhere:="",aTablas:={}

  DEFAULT cTable:="dplibcomprasdet",;
          cField:="LBC_NUMFAC",;
          lAll  :=.T.


  IF Empty(oDp:aAcentos) 
     AADD(oDp:aAcentos,{"ó","�"})
     AADD(oDp:aAcentos,{"ía","�"})
     AADD(oDp:aAcentos,{"é","�"})
     AADD(oDp:aAcentos,{"ú","�"})
     AADD(oDp:aAcentos,{"ñ","�"})
     AADD(oDp:aAcentos,{"�"+CHR(173),"�"})
     AADD(oDp:aAcentos,{"á","�"})
     AADD(oDp:aAcentos,{"�"+CHR(226),"�"})
     AADD(oDp:aAcentos,{"Ñ","�"})
     AADD(oDp:aAcentos,{"É","�"})
     AADD(oDp:aAcentos,{"Ó","�"})
     AADD(oDp:aAcentos,{"Í","�"})
     AADD(oDp:aAcentos,{CHR(10),""})
     AADD(oDp:aAcentos,{CHR(13),""})
  ENDIF

  IF !Empty(cTable)

    AEVAL(oDp:aAcentos,{|a,n| cWhere:=cWhere + IF(Empty(cWhere),""," OR ")+;
                              cField+" LIKE "+GetWhere("","%"+a[1]+"%")})

    IF COUNT(cTable,cWhere)>0
       EJECUTAR("DPTABLAACENTOS",cTable,cField)
    ENDIF

  ENDIF

RETURN .T.
