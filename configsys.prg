// Programa   : CONFIGSYS
// Fecha/Hora : 26/06/2005 23:04:58
// Propósito  : Privilegios para Ventas
// Creado Por : Juan Navas
// Llamado por: DPMENUPRIV
// Aplicación : Administración
// Tabla      : DATASET

#INCLUDE "DPXBASE.CH"


PROCE MAIN(cAll)
  LOCAL oBtn,oFont,oGrp,oData
  LOCAL oCursor,oBar,oBtn

  DEFAULT cAll:="ALL"

  EJECUTAR("CONFIGSYSLOAD")


  IF Type("oConfigSys")="O" .AND. oConfigSys:oWnd:hWnd>0
      oConfigSys:oWnd:Restore()
      RETURN .F.
  ENDIF

  oData  :=DATACNF("CONFIGSYS",cAll)
  
  DPEDIT():New("Configuación del Sistema","CONFIGSYS.EDT","oConfigSys",.T.)

  oConfigSys:lDownLoad   :=oData:Get("lDownLoad"   ,oDp:lDownLoad   )
  oConfigSys:lDownLocal  :=oData:Get("lDownLocal"  ,oDp:lDownLocal  )
  oConfigSys:lRecompilar :=oData:Get("lRecompilar" ,oDp:lRecompilar )
  oConfigSys:lDownPerson :=oData:Get("lDownPerson" ,oDp:lDownPerson )
  oConfigSys:lVerIncIntF :=oData:Get("lVerIncIntF" ,oDp:lVerIncIntF )
  oConfigSys:nBitMaps    :=oData:Get("nBitMaps"    ,oDp:nBitMaps    )
  oConfigSys:cIpEm       :=oData:Get("cIpEm"       ,oDp:cIpEm       )
  oConfigSys:lMultiple   :=oData:Get("lMultiple"   ,oDp:lMultiple   )
  oConfigSys:lSaveSqlFile:=oData:Get("lSaveSqlFile",oDp:lSaveSqlFile)
  oConfigSys:lInterprete :=oData:Get("lInterprete" ,oDp:lInterprete )
  oConfigSys:cSrvReplica :=oData:Get("cSrvReplica" ,oDp:cSrvReplica )

  oConfigSys:cIpEm      :=PADR(oConfigSys:cIpEm,20)

  oConfigSys:nGris       :=oData:Get("nGris" ,oDp:nGris )
  oConfigSys:nGris2      :=oData:Get("nGris2",oDp:nGris2 )
  oConfigSys:cAll        :=cAll

  oData:End(.F.)

  oConfigSys:lMsgBar  :=.F.

  @ 2,02 CHECKBOX oConfigSys:lDownLoad    PROMPT ANSITOOEM("Descargar Actualizaciones del Sistema") SIZE NIL,10
  @ 3,02 CHECKBOX oConfigSys:lDownLocal   PROMPT ANSITOOEM("Recuperar Descarga local de Actualizaciones") SIZE NIL,10
  @ 4,02 CHECKBOX oConfigSys:lDownPerson  PROMPT ANSITOOEM("Recuperar Personalizaciones")  SIZE NIL,10
  @ 5,02 CHECKBOX oConfigSys:lRecompilar  PROMPT ANSITOOEM("Recompilar Programas Fuentes") SIZE NIL,10
  @ 6,02 CHECKBOX oConfigSys:lVerIncIntF  PROMPT ANSITOOEM("Mostrar Incidencias de Integridad") SIZE NIL,10
  @ 6,02 CHECKBOX oConfigSys:lMultiple    PROMPT ANSITOOEM("Ejecución Multiple del Sistema") SIZE NIL,10
  @ 7,02 CHECKBOX oConfigSys:lSaveSqlFile PROMPT ANSITOOEM("Guardar Sentencia SQL en Disco") SIZE NIL,10
  @ 8,02 CHECKBOX oConfigSys:lInterprete  PROMPT ANSITOOEM("Ejecución en modo Interprete") SIZE NIL,10

  @ 6.5,1 SAY oConfigSys:oColor PROMPT "Color Barras" SIZE 100,10 COLOR NIL,oDp:nGris

  @ 8.2,1 BMPGET oConfigSys:oGris VAR oConfigSys:nGris NAME "BITMAPS\COLORS.BMP";
                                 SIZE 50,10;
                                 ACTION (oConfigSys:oColor:SelColor(),;
                                         oConfigSys:oGris:VarPut(oConfigSys:oColor:nClrPane,.T.),oConfigSys:CLRVALID());
                                 VALID oConfigSys:CLRVALID();
                                 WHEN .T.


  @ 8,1 SAY oConfigSys:oColor2 PROMPT "Color Formulario" SIZE 100,10 COLOR NIL,oDp:nGris2

  @ 10,1 BMPGET oConfigSys:oGris2 VAR oConfigSys:nGris2 NAME "BITMAPS\COLORS.BMP";
                                   SIZE 50,10;
                                   ACTION (oConfigSys:oColor2:SelColor(),;
                                           oConfigSys:oGris2:VarPut(oConfigSys:oColor2:nClrPane,.T.),oConfigSys:CLRVALID());
                                   VALID oConfigSys:CLRVALID();
                                   WHEN .T.


  @ 2,34 RADIO oConfigSys:oRadio VAR oConfigSys:nBitMaps;
         ITEMS ANSITOOEM("Clásico"),"Caricatura","Minimalista";
         SIZE 60,12;
         COLOR NIL,oDp:nGris;
         ON CHANGE (oConfigSys:VERBOTONES())

  @ 07,10 SAY "Dirección Ip eManager"
  @ 12.2,1 GET oConfigSys:oIpEm VAR oConfigSys:cIpEm;
                                   SIZE 50,10;
                                   WHEN .T.

  oConfigSys:oIpEm:cToolTip:="Dirección IP o Dominio Intranet de eManager"


  @ 12.0, 1.0 GROUP oConfigSys:oGroup TO 13,6 PROMPT "Servidor con Replicación";
                      FONT oFont


  @ 12,06 BMPGET oConfigSys:oSrvReplica VAR oConfigSys:cSrvReplica;
                 VALID oConfigSys:EMPCODSER();
                 NAME "BITMAPS\FIND22.BMP"; 
                 ACTION (oDpLbx:=DpLbx("DPSERVERBD",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,oConfigSys:oSrvReplica,oConfigSys:oWnd),;
                       oDpLbx:GetValue("SBD_CODIGO",oConfigSys:oSrvReplica)); 
                 WHEN .T.;
                 SIZE 28,10

   @ 12,17 SAY oConfigSys:oSerNombre ;
           PROMPT SQLGET("DPSERVERBD","SBD_DESCRI","SBD_CODIGO"+GetWhere("=",oConfigSys:cSrvReplica)) ;
           SIZE 120,09

  DEFINE CURSOR oCursor HAND

  DEFINE BUTTONBAR oConfigSys:oBar SIZE 52-15,60-15 OF oConfigSys:oWnd 3D CURSOR oCursor

  oBar:=oConfigSys:oBar

  DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -12 BOLD

  DEFINE BUTTON oBtn;
        OF oConfigSys:oBar;
        NOBORDER;
        FONT oFont;
        FILENAME oDp:cPathBitMaps+"XSAVE.BMP",NIL,"BITMAPS\XSAVEG.BMP";
        ACTION oConfigSys:CONFIGSAVE()

  oConfigSys:oBtnSave:=oBtn


  DEFINE BUTTON oBtn;
         OF oBar;
         NOBORDER;
         FONT oFont;
         FILENAME oDp:cPathBitMaps+"DATABASE.BMP";
         ACTION EJECUTAR("EXPORTPERSONALIZ")

  oBtn:cToolTip:="Gestionar Personalizaciones"

  DEFINE BUTTON oBtn;
        OF oBar;
        NOBORDER;
        FONT oFont;
        FILENAME oDp:cPathBitMaps+"XBROWSE.BMP",NIL,"BITMAPS\XBROWSEG.BMP";
        ACTION EJECUTAR("BRDIRDIRAPL")

 oBtn:cToolTip:="Visualizar Registros de Componentes Descargados desde AdaptaPro Server"
        
 DEFINE BUTTON oBtn;
        OF oBar;
        NOBORDER;
        FONT oFont;
        FILENAME oDp:cPathBitMaps+"XDELETE.BMP",NIL,"BITMAPS\XDELETEG.BMP";
        ACTION oConfigSys:DELDIRAPL()

 oBtn:cToolTip:="Remover Registro de Componentes Descargados desde AdaptaPro Server"

 DEFINE BUTTON oBtn;
        OF oBar;
        NOBORDER;
        FONT oFont;
        FILENAME oDp:cPathBitMaps+"OPTIONS.BMP",NIL,oDp:cPathBitMaps+"OPTIONSG.BMP";
        ACTION EJECUTAR("DPAPLOPCXCAM")

 oBtn:cToolTip:="Opciones y Colores por Campos"


 DEFINE BUTTON oBtn;
        OF oBar;
        NOBORDER;
        FONT oFont;
        FILENAME oDp:cPathBitMaps+"DOWNLOAD.BMP";
        ACTION EJECUTAR("DPSVRDOWN") 

 oBtn:cToolTip:="Descargar Actualizaciones del Sistema"




 DEFINE BUTTON oBtn;
        OF oBar;
        NOBORDER;
        FONT oFont;
        FILENAME oDp:cPathBitMaps+"IMPORTAR.BMP",NIL,oDp:cPathBitMaps+"IMPORTG.BMP";
        ACTION EJECUTAR("CONFIG",.F.)

 oBtn:cToolTip:="Opciones para Importar datos desde Versión Anterior"

                    

 DEFINE BUTTON oBtn;
         OF oBar;
         NOBORDER;
         FONT oFont;
         FILENAME oDp:cPathBitMaps+"MENU.BMP";
         ACTION EJECUTAR("CONFIG")

  oBtn:cToolTip:="Opciones para Gestionar Datos"
                                                                            

 DEFINE BUTTON oBtn;
        OF oBar;
        NOBORDER;
        FONT oFont;
        FILENAME oDp:cPathBitMaps+"XSALIR.BMP";
        ACTION oConfigSys:Close()

 IF ValType(oBar)="O"

   oBar:SetColor(CLR_BLACK,oDp:nGris)

   AEVAL(oBar:aControls,{|o,n|o:Refresh(.T.),o:SetColor(NIL,oDp:nGris)})
 

   oConfigSys:CLRVALID()

 ELSE

 ENDIF

 oConfigSys:Activate()

RETURN .t.

FUNCTION VERBOTONES()

  IF oConfigSys:oBar=NIL
     RETURN .T.
  ENDIF

  IF oConfigSys:nBitMaps=1
    oDp:cPathBitMaps:=oDp:cPathExe+"BITMAPS\"
  ELSE
    oDp:cPathBitMaps:=oDp:cPathExe+"BITMAPS"+LSTR(oConfigSys:nBitMaps-1)+"\"
  ENDIF

  oConfigSys:oBar:End()


RETURN .T.

/*
// Barra de Botones
*/
FUNCTION ViewDatBar()

 oConfigSys:CLRVALID()

RETURN .T.


FUNCTION CONFIGSAVE()
  LOCAL oData  :=DATACNF("CONFIGSYS","ALL")

  oData:Set("lDownLoad"  ,oConfigSys:lDownLoad  )
  oData:Set("lDownLocal" ,oConfigSys:lDownLocal )
  oData:Set("lDownPerson",oConfigSys:lDownPerson)
  oData:Set("lRecompilar",oConfigSys:lRecompilar)
  oData:Set("lVerIncIntF",oConfigSys:lVerIncIntF)
  oData:Set("nGris"      ,oConfigSys:nGris      )
  oData:Set("nGris2"     ,oConfigSys:nGris2     )
  oData:Set("nBitMaps"   ,oConfigSys:nBitMaps   )
  oData:Set("cIpEm"      ,oConfigSys:cIpEm      )
  oData:Set("lMultiple"  ,oConfigSys:lMultiple  ) 
  oData:Set("lInterprete",oConfigSys:lInterprete)
  oData:Set("cSrvReplica",oConfigSys:cSrvReplica)

  oData:Save(.T.)
  oData:End(.F.)

  oConfigSys:Close()

  EJECUTAR("CONFIGSYSLOAD")


RETURN .T.

FUNCTION CLRVALID()

  oConfigSys:oDlg:SetColor(NIL,oConfigSys:nGris2)
  oConfigSys:oBar:SetColor(NIL,oConfigSys:nGris)

  AEVAL(oConfigSys:oBar:aControls,{|o,n|o:SetColor(NIL,oConfigSys:nGris)})
  AEVAL(oConfigSys:oDlg:aControls,{|o,n|o:SetColor(NIL,oConfigSys:nGris2)})

  oConfigSys:oBar:Refresh(.T.)
  oConfigSys:oDlg:Refresh(.T.)


  oConfigSys:oBar:SetColor(NIL,oConfigSys:nGris)

  AEVAL(oDp:oBar:aControls,{|o,n|o:SetColor(NIL,oConfigSys:nGris)})


RETURN .T.

FUNCTION DELDIRAPL()
RETURN EJECUTAR("DELDIRAPL")
/*

 LOCAL cSql,oDb:=OpenOdbc(oDp:cDsnConfig)

 IF !MsgNoYes("Desea Remover Registros de Componentes Descargados y Diccionario de Datos")
    RETURN .F.
 ENDIF   

 IF COUNT("DPDIRAPL")>0
   OpenTable("SELECT * FROM DPDIRAPL",.T.):CTODBF("DATADBF\DPDIRAPL.DBF")
 ENDIF

 SQLDELETE("DPDIRAPL")
 SQLDELETE("DPDIRAPLPAG")
 SQLDELETE("DPPCLOGDIRAPL")

 IF COUNT("DPDIRAPLPAG")>0
   OpenTable("SELECT * FROM DPDIRAPLPAG",.T.):CTODBF("DATADBF\DPDIRAPLPAG.DBF")
 ENDIF

 EJECUTAR("DBISTABLE",oDp:cDsnConfig,"DPMYPROGRA",.T.)
// EJECUTAR("DPCAMPOSADD" ,"DPPROGRA"  ,"PRG_LLAVE","C",250,0,"Llave del Desarrollador")
// EJECUTAR("DPCAMPOSADD" ,"DPMYPROGRA","PRG_LLAVE","C",250,0,"Llave del Desarrollador")

 cSql:="INSERT INTO DPMYPROGRA SELECT * FROM DPPROGRA"

 oDb:Execute(cSql)

 IF !ISPCPRG() .AND. COUNT("DPMYPROGRA")>0 
   SQLDELETE("DPMYPROGRA")
 ENDIF

 EJECUTAR("DPDELDICCDAT",.T.)

 MsgMemo("Proceso Concluido")

*/
RETURN .T.

FUNCTION EMPCODSER()

  LOCAL lResp:=.T.

  lResp:=!Empty(SQLGET("DPSERVERBD","SBD_DESCRI","SBD_CODIGO"+GetWhere("=",oConfigSys:cSrvReplica)))

  oConfigSys:oSerNombre:Refresh(.T.)

  IF !lResp
    oConfigSys:ocSrvReplica:KeyBoard(VK_F6)
  ENDIF

RETURN lResp

// EOF


