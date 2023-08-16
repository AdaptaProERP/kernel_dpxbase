// Programa   : BTNBARFINDRUN
// Fecha/Hora : 15/11/2018 15:41:27
// Propósito  : Buscar desde la barra de Menú
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cFind)
  LOCAL aFind:={},aData,cSql

  IF !Empty(cFind)
     oDp:cGetFind:=PADR(cFind,250)
     oDp:oGetFind:VarPut(oDp:cGetFind,.T.)
     oDp:oGetFind:KeyBoard(CHR(13))
     RETURN .F.
  ENDIF

  DEFAULT cFind:=UPPER(ALLTRIM(oDp:cGetFind))

  IF Empty(cFind)
     //Empty(oDp:cGetFind)
     RETURN .F.
  ENDIF

  EJECUTAR("DBISTABLE",oDp:cDsnConfig,"VIEW_DPMENUAPL",.T.)

  EJECUTAR("BRDPMENU",NIL,NIL,NIL,NIL,NIL,NIL,.T.)
  aData:=oDp:aData
//ViewArray(aData)

  ADEPURA(aData,{|a,n| !cFind$UPPER(a[1])})

  AEVAL(aData,{|a,n| AADD(aFind,{a[1],"Menú",a[2],a[6],a[5],ALLTRIM(a[7])})})

  aData:=EJECUTAR("BRDPBRW",NIL,NIL,NIL,NIL,NIL,NIL,.T.)

  ADEPURA(aData,{|a,n| !cFind$UPPER(a[1])})

  AEVAL(aData,{|a,n| AADD(aFind,{a[1],"Browse",a[2],"Browse","",[EJECUTAR("BRWRUN",]+GetWhere("",a[4])+")"})})

  aData:=ASQL("SELECT PRC_DESCRI,PRC_CLASIF,PRC_CODIGO FROM DPPROCESOS  WHERE PRC_ACTIVO=1 AND PRC_DESCRI LIKE "+GetWhere("","%"+cFind+"%")+" ORDER BY PRC_CODIGO")

  AEVAL(aData,{|a,n| AADD(aFind,{a[1],"Procesos",a[2],"P.Automático","",[EJECUTAR("DPPROCESOSRUN",]+GetWhere("",a[3])+")"})})

  aData  :=ASQL(" SELECT REP_DESCRI,GRR_DESCRI,REP_CODIGO FROM DPREPORTES INNER JOIN DPGRUREP ON REP_GRUPO=GRR_CODIGO AND GRR_CODIGO"+GetWhere("<>","00000031")+" WHERE REP_DESCRI LIKE "+GetWhere("","%"+cFind+"%")+" ORDER BY REP_CODIGO")

// ViewArray(aData)

  AEVAL(aData,{|a,n| AADD(aFind,{a[1],"Informes",a[2],"Informes","",[REPORTE(]+GetWhere("",a[3])+")"})})


  // ADD-ON
  aData:=ASQL([SELECT ADD_DESCRI,"Macros" AS CLASIFICA,ADD_CODIGO FROM DPADDON  WHERE ADD_ACTIVO=1 AND ADD_DESCRI LIKE ]+GetWhere("","%"+cFind+"%")+" ORDER BY ADD_CODIGO")
  AEVAL(aData,{|a,n| AADD(aFind,{a[1],"PlugIn",a[2],"Macros","",[EJECUTAR("DPADDON_RUNMENU",]+GetWhere("",a[3])+")"})})

  // Opciones del ADD-ON
  aData:=ASQL([SELECT SMN_SUBOPC,SMN_DESCRI,SMN_PROGRA FROM DPSUBMENU WHERE SMN_TIPO="A" AND SMN_SUBOPC LIKE ]+GetWhere("","%"+cFind+"%")+" ORDER BY SMN_ID")
//ViewArray(aData)
  AEVAL(aData,{|a,n| AADD(aFind,{a[1],"PlugIn",a[2],"Macros","",[EJECUTAR("DPADDON_RUNMENU",]+GetWhere("",a[3])+","+GetWhere("",a[1])+")"})})

  // Opciones de Consulta y Menú
  aData:=ASQL([SELECT SMN_SUBOPC,SMN_DESCRI,SMN_PROGRA,SMN_TIPO,SMN_TABLA FROM DPSUBMENU WHERE (SMN_TIPO="C" OR SMN_TIPO="S") AND SMN_SUBOPC LIKE ]+GetWhere("","%"+cFind+"%")+" ORDER BY SMN_ID")
  AEVAL(aData,{|a,n| AADD(aFind,{a[1],a[4],a[2],a[4],"",[EJECUTAR("DPADDON_RUNMENU",]+GetWhere("",a[3])+","+GetWhere("",a[1])+","+GetWhere("",a[4])+","+GetWhere("",a[5])+")"})})

  AEVAL(aFind,{|a,n| aFind[n,2]:=IF(LEFT(ALLTRIM(a[2]),1)="C","Consulta",aFind[n,2]),;
                     aFind[n,2]:=IF(LEFT(ALLTRIM(a[2]),1)="S","Sub-Menú",aFind[n,2])})

// ViewArray(aData)
// ViewArray(aFind)

  IF Empty(aFind)
     oDp:oGetFind:MsgErr("No encontrado","Procesos de Ejecución",180,110)
     RETURN .F.
  ENDIF

//  RUNMDI("BTNBARFINDVIEW","oMNUFIND",aFind,"Opciones de Ejecución","")
// ViewArray(aFind)

  aData:={}

  AEVAL(aFind,{|a,n| AADD(aData,{a[1],a[2],a[3],a[6],".T."})})

  aFind:=aData

  EJECUTAR("BTNBARFINDVIEW",aFind,"Opciones de Ejecución","")


RETURN .T.
// EOF

