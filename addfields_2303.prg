// Programa   : ADDFIELDS_2303
// Fecha/Hora : 18/01/2021 11:03:42
// Propósito  : Agregar Campos en Release 22_10
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(lDown,lDelete)
  LOCAL cId   :="ADDFIELD2303_07" // Ultimo Release en Construcción para Evita Solicitar Revisión de las Tablas0
  LOCAL cWhere,cSql,I,cCodigo,cDescri,lRun
  LOCAL oDb   :=OpenOdbc(oDp:cDsnData)
  LOCAL cWhere,oTable,oData
  LOCAL aFields:={}
  LOCAL cCodigo,cDescri,cSql,lRun
  LOCAL cFile  :="ADD\"+cId+"_"+oDp:cDsnData+".ADD"
  LOCAL aFields:={}

  DEFAULT lDown  :=.F.,;
          lDelete:=.F.

  // Si ya existe y no es descarga, devuelva

  IF ISPCPRG() .OR. lDelete

     FERASE(cFile)

  ELSE

    IF FILE(cFile) .AND. lDown
      RETURN .T.
    ENDIF

    oData:=DATASET(cId,"ALL")

    IF oData:Get(cId,"")<>cId 
      oData:End()
    ELSE
      oData:End()
      RETURN
    ENDIF

  ENDIF

  MSGRUNVIEW("Actualizando Base de Datos R:23.03")

  EJECUTAR("DPTRIGGERSDELA")

  cSql:=" SET FOREIGN_KEY_CHECKS = 0"
  oDb:Execute(cSql)

  EJECUTAR("DPCAMPOSADD","DPTRANSP","TRA_PAIS"  ,"C",035,0,"Pais")
  EJECUTAR("DPCAMPOSADD","DPTRANSP","TRA_ESTADO","C",035,0,"Estado")
  EJECUTAR("DPCAMPOSADD","DPTRANSP","TRA_CIUDAD","C",035,0,"Estado")
  EJECUTAR("DPCAMPOSADD","DPTRANSP","TRA_TIPO"  ,"C",025,0,"Tipo")     // Encomienda, 
  EJECUTAR("DPCAMPOSADD","DPTRANSP","TRA_GRUPO" ,"C",035,0,"Grupo")    // MRW,TEALCA
  EJECUTAR("DPCAMPOSADD","DPTRANSP","TRA_TELEFO","C",250,0,"Teléfono") // Telefono
  EJECUTAR("DPCAMPOSADD","DPTRANSP","TRA_GPS"   ,"C",250,0,"GPS")      // GPS

  EJECUTAR("DPCAMPOSADD","DPDOCCLIDIR","DIR_TRADES","C",006,0,"Transporte Destino")  // GPS
  EJECUTAR("DPCAMPOSADD","DPDOCCLIDIR","DIR_GUIA"  ,"C",020,0,"Número de Guia")  
  EJECUTAR("DPCAMPOSADD","DPDOCCLIDIR","DIR_FLEDIV","N",019,2,"Monto Flete en Divisa")  

  EJECUTAR("DPDOCPROFIX") // 09/10/2023 Activa documentos vinculados con Pagos
  EJECUTAR("SETDOC_MTODIV")

/*
  EJECUTAR("DPCAMPOSADD","DPDOCCLI","DOC_MTODIV","N",019,2,"Monto en Divisa")  

  cSql:=[UPDATE DPDOCCLI SET DOC_MTODIV=ROUND(DOC_NETO+IF(DOC_TIPTRA="P",DOC_MTOCOM,0)/DOC_VALCAM,2) WHERE (DOC_MTODIV=0 OR DOC_MTODIV IS NULL) AND DOC_VALCAM<>1 ]
  oDb:EXECUTE(cSql)

  EJECUTAR("DPCAMPOSADD","DPDOCPRO","DOC_MTODIV","N",019,2,"Monto en Divisa")  

  cSql:=[UPDATE DPDOCPRO SET DOC_MTODIV=ROUND(DOC_NETO+IF(DOC_TIPTRA="P",DOC_MTOCOM,0)/DOC_VALCAM,2) WHERE (DOC_MTODIV=0 OR DOC_MTODIV IS NULL) AND DOC_VALCAM<>1 ]

  oDb:EXECUTE(cSql)
*/

  EJECUTAR("DPCAMPOSADD","DPTIPDOCPRO","TDC_GASCOM","L",01,0,"Gastos de Compras") 

  cSql:=[UPDATE DPTIPDOCPRO SET TDC_GASCOM=1 WHERE TDC_GASCOM IS NULL AND ]+GetWhereOr("TDC_TIPO",{"ORC","FAC","ORI"})
  oDb:EXECUTE(cSql)

  // ENLACE DOCUMENTO DEL PROVEEDOR con GASTOS DE COMPRAS
  EJECUTAR("DPCAMPOSADD","DPDOCPROGASXINV","DXI_TIPTRA","C",001,0,"Tipo de Transacción",NIL,.T.,"D",["D"])

  cSql:=[UPDATE DPDOCPROGASXINV SET DXI_TIPTRA="D" WHERE DXI_TIPTRA IS NULL ]
  oDb:EXECUTE(cSql)

  EJECUTAR("DPLINKADD"  ,"DPDOCPRO"      ,"DPDOCPROGASXINV","DOC_CODSUC,DOC_TIPDOC,DOC_CODIGO,DOC_NUMERO,DOC_TIPTRA",;
                                                            "DXI_CODSUC,DXI_TIPDOC,DXI_CODIGO,DXI_NUMERO,DXI_TIPTRA",.T.,.T.,.T.)

  EJECUTAR("DPLINKADD"  ,"DPDOCPRO"      ,"DPDOCPROGASTO","DOC_CODSUC,DOC_TIPDOC,DOC_CODIGO,DOC_NUMERO,DOC_TIPTRA",;
                                                            "DCG_CODSUC,DCG_TIPDOC,DCG_CODIGO,DCG_NUMERO,DCG_TIPTRA",.T.,.T.,.T.)

  cSql:=[UPDATE DPACTIVIDAD_E SET ACT_ACTIVO=1 WHERE ACT_ACTIVO IS NULL ]

  oDb:EXECUTE(cSql)
  IF COUNT("DPACTIVIDAD_E")=COUNT("DPACTIVIDAD_E","ACT_ACTIVO=0") 
     SQLUPDATE("DPACTIVIDAD_E","ACT_ACTIVO",.T.)
  ENDIF

  EJECUTAR("DPCAMPOSADD","DPPROVEEDOR","PRO_FCHUPD","D",008,0,"Fecha de Actualización") 

  EJECUTAR("DPCAMPOSADD","DPCBTE"     ,"CBT_CENCOS","C",010,0,"Código de Centros de Costos",NIL,.T.,oDp:cCenCos,[&oDp:cCenCos])
  EJECUTAR("DPCAMPOSADD","DPCBTE"     ,"CBT_CENGEN","L",001,0,"Centro de Costo Unico",NIL,.T.,.F.,[.F.])

  EJECUTAR("DPCAMPOSOPCADD","DPIMPRXLS","IXL_PREDEF","Asientos"   ,.T.,16744576,.T.)

  EJECUTAR("DPCAMPOSETDEF","DPDOCPRO"  ,"DOC_ORIGEN",["N"])

  oDb:EXECUTE("UPDATE DPDOCPRO SET DOC_ORIGEN"+GetWhere("=","N")+" WHERE DOC_ORIGEN"+GetWhere("="," ")+" OR DOC_ORIGEN IS NULL")


  EJECUTAR("DPDOCPRORTISETVALCAM")

  EJECUTAR("DPCAMPOSADD", "DPLIBCOMPRASDET","LBC_CODCLI","C",10,0,"Código del Cliente")
  EJECUTAR("DPCAMPOSADD", "DPLIBCOMPRASDET","LBC_ID"    ,"C",03,0,"ID del Recurso del Cliente")

  IF !EJECUTAR("ISFIELDMYSQL",oDb,"VIEW_DOCCLICXC","CXD_SALDO")
     EJECUTAR("SETDOC_MTODIV")
  ENDIF

  oData:=DATASET(cId,"ALL")
  oData:Set(cId,cId)
  oData:Save()
  oData:End()

  DPWRITE(cFile,cFile)

  cSql:=" SET FOREIGN_KEY_CHECKS = 1"
  oDb:Execute(cSql)

RETURN .T.
// EOF















