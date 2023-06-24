// Programa   : CONFIGSYSLOAD
// Fecha/Hora : 26/06/2005 23:04:58
// Propósito  : Carga los Privilegios del Systema
// Creado Por : Juan Navas
// Llamado por: DPMENUPRIV
// Aplicación : Administración
// Tabla      : DATASET

#INCLUDE "DPXBASE.CH"


PROCE MAIN()
  LOCAL oBtn,oFont,oGrp,oData,oIni,oTable
  LOCAL cField,cTable,oDb:=OpenOdbc(oDp:cDsnConfig),cSql
  LOCAL cFile:="DP\DPCONFIGSYS.INI"
  LOCAL cDir:="RELEASE_INSTALL\"
  LOCAL _MycIp,_MycPass,_MycLoging,_MySqlDate:=oDp:cSqlDate,_MySqlPort,cFileMem:="MYSQLPLANB.MEM"

  DEFAULT oDp:lDownLoad   :=.T.,;
          oDp:lDownLocal  :=.T.,;
          oDp:lDownPerson :=.T.,;
          oDp:lRecompilar :=.T.,;
          oDp:lVerIncIntF :=.T.,;
          oDp:lMultiple   :=.F.,;
          oDp:lSaveSqlFile:=.T.,;
          oDp:lInterprete :=.F.,;
          oDp:cSrvReplica :="" 

  DEFAULT oDp:oFrameDp:=oDp:oFrameDp2

  oDp:nGris            :=16775408
  oDp:nLbxClrHeaderPane:=16776441
  oDp:nLbxClrHeaderText:=0
  oDp:nLbxClrHeaderPane:=oDp:nGrid_ClrPaneH
  oDp:nRecSelColor     := 11856126

  oDp:nClrGroup        := 14643200

  oDp:cIpEm            :=SPACE(20)

  oDp:nClrDPCLIENTES :=15102720
  oDp:nClrDPPROVEEDOR:=4227072

//  oDp:nClrPane1:=16774636
//  oDp:nClrPane2:=16769476

  

  oDp:nClrText :=0

//  COLOR oDp:nClrYellowText,oDp:nClrYellow

  oDp:nClrYellow    :=CLR_YELLOW
  oDp:nClrYellowText:=0

  oDp:nClrLabelPane:=16751415
  oDp:nClrLabelText:=16777215

  // COLOR oDp:nClrLabelText,oDp:nClrLabelPane


  oDp:nGrid_ClrPane1:=16775408
  oDp:nGrid_ClrPane2:=16770764
  oDp:nGrid_ClrPaneH:=14742524 // 12578047
  oDp:nGrid_ClrTextH:=CLR_BLACK


//  oDp:nClrPane1:=16773345
//  oDp:nClrPane2:=16769217
//  oDp:nClrPane1:=16774636
//  oDp:nClrPane2:=16771797

 oDp:nClrPane1:=16775408 
 oDp:nClrPane2:=16771797


  oDp:nMenuItemSelPane :=12972026
  oDp:nMenuItemClrPane :=16775666

  // Aun no se aperturado la conexion con MySQL, si necesita importar los datos, debe copiar mysql.mem desde la version anterior y abrir la base de datos,
  IF !ValType(oDp:oMySqlCon)="O"
     RETURN .T.
  ENDIF

 
  IF !EJECUTAR("DBISTABLE",oDp:cDsnConfig,"DPDATACNF",.F.)
     EJECUTAR("MYSQLRESTORECONFIG")
  ENDIF

  // Descomprimir release*.zip
  // ? "AQUI DEBE INICIAR DESCOMPRESION",cDir
  EJECUTAR("DOWNLOADRELEASE",NIL,.T.,cDir)

  IF FILE("DATADBF\DPTABLAS.DBF") .AND. !EJECUTAR("DBISTABLE",oDp:cDsnConfig,"DPDATACNF",.F.)
    EJECUTAR("IMPORTDPTABLAS")
    RETURN .F.
  ENDIF

  IF FILE("DATADBF\DPTABLAS.DBF") .AND. !EJECUTAR("DBISTABLE",oDp:cDsnConfig,"DPTABLAS",.F.)
    EJECUTAR("IMPORTDPTABLAS")
    RETURN .F.
  ENDIF


  cField:="OPC_COLOR"
  cTable:="DPCAMPOSOP"

  IF FILE("DATADBF\DPTABLAS.DBF") .AND. EJECUTAR("DBISTABLE",oDb,cTable,.T.)

     IF !EJECUTAR("ISFIELDMYSQL",oDb,cTable,cField)

       cSql:="ALTER TABLE "+cTable+" ADD "+cField+" NUMERIC(10)"
       oDb:Execute(cSql)

       cSql:="UPDATE "+cTable+" SET "+cField+GetWhere("=",0)
       oDb:Execute(cSql)

     ENDIF
    

  ENDIF

  oData  :=DATACNF("CONFIGSYS","ALL")

  IF oData=NIL
     RETURN .F.
  ENDIF

// ? oData:ClassName()
 
  oDp:lDownLoad   :=oData:Get("lDownLoad"  ,.T.)
  oDp:lDownLocal  :=oData:Get("lDownLocal" ,.T.)
  oDp:lDownPerson :=oData:Get("lDownPerson",.T.) // Descarga Personalizaciones
  oDp:lRecompilar :=oData:Get("lRecompilar",.F.)
  oDp:lVerIncIntF :=oData:Get("lVerIncIntF",.F.)
  oDp:lMultiple   :=oData:Get("lMultiple"   ,oDp:lMultiple   )
  oDp:lSaveSqlFile:=oData:Get("lSaveSqlFile",oDp:lSaveSqlFile)
  oDp:lInterprete :=oData:Get("lInterprete" ,oDp:lInterprete )
  oDp:cSrvReplica :=oData:Get("cSrvReplica" ,oDp:cSrvReplica ) // Código del Servicio de Replicación

  oDp:nBitMaps   :=oData:Get("nBitMaps"   ,1  ) // Estandar
  oDp:cIpEm      :=oData:Get("cIpEm"      ,SPACE(20))
  oDp:cIpEm      :=ALLTRIM(oDp:cIpEm)

  oDp:nGris      :=oData:Get("nGris" ,oDp:nGris )
  oDp:nGris2     :=oData:Get("nGris2",oDp:nGris )

  IF oDp:nBitMaps=1 .OR. Empty(oDp:nBitMaps)
    oDp:cPathBitMaps:=oDp:cPathExe+"BITMAPS\"
  ELSE
    oDp:cPathBitMaps:=oDp:cPathExe+"BITMAPS"+LSTR(oDp:nBitMaps-1)+"\"
  ENDIF

  oData:End(.F.)
  
  oDp:nLbxClrHeaderPane:=oDp:nGrid_ClrPaneH
  oDp:nLbxClrHeaderText:=NIL

  // AutoRegistros de Soporte
  oDp:lServerDown:=.T. // Descargar desde DPAPTGET
  oDp:lRegSopAuto:=.F. 

  INI oIni File (cFile)

  oIni:Set( "Config", "nGris"  , oDp:nGris )
  oIni:Set( "Config", "nGris2" , oDp:nGris2 )

  // Evita sea ejecuta en nueva instancia
  IF !oDp:lMultiple
     SetMultiple(.F.)
  ENDIF

  IF !Empty(oDp:cSrvReplica) 

     // Guardar Credenciales de la base de datos
     oTable:=OpenTable("SELECT SBD_ACTIVO,SBD_DOMINI,SBD_CLAVE,SBD_USUARI,SBD_PUERTO FROM DPSERVERBD WHERE SBD_CODIGO"+GetWhere("=",oDp:cSrvReplica))

     IF oTable:SBD_ACTIVO

       _MycIp    :=ENCRIPT(ALLTRIM(oTable:SBD_DOMINI),.T.)
       _MycPass  :=ENCRIPT(ALLTRIM(oTable:SBD_CLAVE ),.T.)
       _MycLoging:=ENCRIPT(ALLTRIM(oTable:SBD_USUARI),.T.)
       _MySqlPort:=oTable:SBD_PUERTO

       SAVE TO (cFileMem) ALL LIKE _My*

     ELSE

       FERASE(cFileMem)

     ENDIF

     oTable:End()

  ELSE

     FERASE(cFileMem)

  ENDIF

  //? "oConfigSys:cSrvReplica","oConfigSys:cSrvReplica, CONFIGSYSLOAD",oConfigSys:cSrvReplica
 
RETURN .T.
// EOF
