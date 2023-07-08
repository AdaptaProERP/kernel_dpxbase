// Programa   : DPEMPRESA
// Fecha/Hora : 18/08/2004 00:21:16
// Propósito  : Incluir/Modificar DPEMPRESA
// Creado Por : DpXbase
// Llamado por: DPEMPRESA.LBX
// Aplicación : Nómina                                  
// Tabla      : DPEMPRESA

#INCLUDE "DPXBASE.CH"
#INCLUDE "TSBUTTON.CH"
#INCLUDE "IMAGE.CH"

FUNCTION DPEMPRESA(nOption,cCodigo,lDialog,cBDORG,cBDDES,lSelect,oLbx)
  LOCAL oBtn,oTable,oGet,oFont,oFontB,oFontG
  LOCAL cTitle,cSql,cFile,cExcluye:=""
  LOCAL nClrText
  LOCAL cTitle:="Empresas"
  LOCAL aItems1:=GETOPTIONS("DPEMPRESA","EMP_TIPFCH")
  LOCAL cCodSer:=EJECUTAR("DPSERVERBDCERO")

  IF Empty(aItems1)
     AADD(aItems1,"Servidor")
  ENDIF

  cExcluye:="EMP_CODIGO,;
             EMP_NOMBRE,;
             EMP_FECHAI,;
             EMP_FECHAF,;
             EMP_BD,;
             EMP_DSN,;
             EMP_LOGIN,;
             EMP_CLAVE,;
             EMP_REGCLA"

  DEFAULT cBDORG :="",;
          cBDDES :=""

  DEFAULT cCodigo:="1234",;
          lDialog:=.F.,;
          lSelect:=.F.

  IF ValType(oLbx)="O"
      oLbx:oWnd:End()
  ENDIF

  DEFAULT nOption:=1

  nOption:=IIF(nOption=0,2,nOption) 

  DEFINE FONT oFont  NAME "Tahoma" SIZE 0, -10 BOLD
  DEFINE FONT oFontB NAME "Tahoma" SIZE 0, -12 BOLD ITALIC
  DEFINE FONT oFontG NAME "Tahoma" SIZE 0, -11

  nClrText:=10485760 // Color del texto

  IF nOption=1 // Incluir
    cSql     :=[SELECT * FROM DPEMPRESA WHERE ]+BuildConcat("EMP_CODIGO")+GetWhere("=",cCodigo)+[]
    cTitle   :=" Incluir {oDp:DPEMPRESA}"
  ELSE 
    cSql     :=[SELECT * FROM DPEMPRESA WHERE ]+BuildConcat("EMP_CODIGO")+GetWhere("=",cCodigo)+[]
    cTitle   :=IIF(nOption=2,"Consultar","Modificar")+" {oDp:DPEMPRESA}"
  ENDIF

  IF !Empty(cBDORG)
    cBDORG   :=ALLTRIM(cBDORG)
    cTitle   :=cTitle+" [ Desde BD: "+cBDORG+" ]" 
  ENDIF

  oTable   :=OpenTable(cSql,"WHERE"$cSql) // nOption!=1)

  IF nOption=1 .AND. oTable:RecCount()=0 // Genera Cursor Vacio
     oTable:End()
     cSql     :=[SELECT * FROM DPEMPRESA]
     oTable   :=OpenTable(cSql,.F.) // nOption!=1)
  ENDIF

  oTable:cPrimary:="EMP_CODIGO" // Clave de Validación de Registro

  oEMPRESA:=DPEDIT():New(cTitle,"DPEMPRESA.edt","oEMPRESA" , .F. ,lDialog )

  oEMPRESA:nOption  :=nOption
  oEMPRESA:SetTable( oTable , .F. ) // Asocia la tabla <cTabla> con el formulario oEMPRESA
  oEMPRESA:SetScript("DPEMPRESA")        // Asigna Funciones DpXbase como Metodos de oEMPRESA
  oEMPRESA:SetDefault()       // Asume valores standar por Defecto, CANCEL,PRESAVE,POSTSAVE,ORDERBY

  oEMPRESA:cBDORG :=ALLTRIM(cBDORG)
  oEMPRESA:cBDDES :=ALLTRIM(cBDDES)
  oEMPRESA:lSelect:=lSelect

  IF oEMPRESA:nOption=1 // Incluir en caso de ser Incremental
     // oEMPRESA:RepeatGet(NIL,"EMP_CODIGO") // Repetir Valores
     oEMPRESA:EMP_CODIGO:=oEMPRESA:Incremental("EMP_CODIGO",.T.)
     oEMPRESA:EMP_ACTIVA:=.T.
     oEMPRESA:EMP_FECHAI:=oDp:dFchInicio
     oEMPRESA:EMP_TIPFCH:="Servidor"
     oEMPRESA:EMP_CODSER:=cCodSer
     // AutoIncremental 
  ENDIF

  oEMPRESA:lMaestras:=.F.
  oEMPRESA:lCxC     :=.F.
  oEMPRESA:lCxP     :=.F.

  IF Empty(oEMPRESA:EMP_TIPFCH)
     oEMPRESA:EMP_TIPFCH:="Servidor"
  ENDIF

  oEMPRESA:nOption:=IIF(oEMPRESA:nOption=2,0,oEMPRESA:nOption)

  //Tablas Relacionadas con los Controles del Formulario

  oEMPRESA:CreateWindow()       // Presenta la Ventana

  // Opciones del Formulario

  

  @ 1.0, 1.0 GROUP oEMPRESA:oGroup TO 6,6 PROMPT "Identificación";
                      FONT oFontG

  //
  // Campo : EMP_CODIGO
  // Uso   : Número                                  
  //
  @ 1.0, 1.0 GET oEMPRESA:oEMP_CODIGO  VAR oEMPRESA:EMP_CODIGO;
                 VALID CERO(oEMPRESA:EMP_CODIGO) .AND.; 
                 (oDp:lExcluye:=.F.,oEMPRESA:ValUnique(oEMPRESA:EMP_CODIGO)) .AND. ;
                 oEMPRESA:EMPSETDSN(oEMPRESA:EMP_CODIGO);
                 WHEN (AccessField("DPEMPRESA","EMP_CODIGO",oEMPRESA:nOption);
                       .AND. oEMPRESA:nOption!=0);
                 FONT oFontG

    oEMPRESA:oEMP_CODIGO:cMsg    :="Número"
    oEMPRESA:oEMP_CODIGO:cToolTip:="Número"

  @ oEMPRESA:oEMP_CODIGO:nTop-08,oEMPRESA:oEMP_CODIGO:nLeft SAY "Número" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_NOMBRE
  // Uso   : Nombre                                  
  //
  @ 2.8, 1.0 GET oEMPRESA:oEMP_NOMBRE;
             VAR oEMPRESA:EMP_NOMBRE ;
             VALID (oEMPRESA:EMPSETDSN(oEMPRESA:EMP_CODIGO) .AND. !VACIO(oEMPRESA:EMP_NOMBRE,NIL));
             WHEN (AccessField("DPEMPRESA","EMP_NOMBRE",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
             FONT oFontG

    oEMPRESA:oEMP_NOMBRE:cMsg    :="Nombre"
    oEMPRESA:oEMP_NOMBRE:cToolTip:="Nombre"

  @ oEMPRESA:oEMP_NOMBRE:nTop-08,oEMPRESA:oEMP_NOMBRE:nLeft SAY "Nombre" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_FECHAI
  // Uso   : Fecha de Inicio                         
  //
  @ 4.6, 1.0 BMPGET oEMPRESA:oEMP_FECHAI  VAR oEMPRESA:EMP_FECHAI  PICTURE "99/99/9999";
             NAME "BITMAPS\Calendar.bmp";
             VALID oEMPRESA:CALCULAFINMES();
             ACTION LbxDate(oEMPRESA:oEMP_FECHAI,oEMPRESA:EMP_FECHAI);
                    WHEN (AccessField("DPEMPRESA","EMP_FECHAI",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

    oEMPRESA:oEMP_FECHAI:cMsg    :="Fecha de Inicio"
    oEMPRESA:oEMP_FECHAI:cToolTip:="Fecha de Inicio"

  @ oEMPRESA:oEMP_FECHAI:nTop-08,oEMPRESA:oEMP_FECHAI:nLeft SAY "Fecha de Inicio" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_FECHAF
  // Uso   : Fecha de Cierre                         
  //
  @ 6.4, 1.0 BMPGET oEMPRESA:oEMP_FECHAF  VAR oEMPRESA:EMP_FECHAF  PICTURE "99/99/9999";
          NAME "BITMAPS\Calendar.bmp";
          ACTION LbxDate(oEMPRESA:oEMP_FECHAF,oEMPRESA:EMP_FECHAF);
                    WHEN (AccessField("DPEMPRESA","EMP_FECHAF",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

    oEMPRESA:oEMP_FECHAF:cMsg    :="Fecha de Cierre"
    oEMPRESA:oEMP_FECHAF:cToolTip:="Fecha de Cierre"

  @ oEMPRESA:oEMP_FECHAF:nTop-08,oEMPRESA:oEMP_FECHAF:nLeft SAY "Fecha de Cierre" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 

  @ 8.2, 1.0 GROUP oEMPRESA:oGroup TO 13.2,6 PROMPT "Base de Datos";
                      FONT oFontG

  //
  // Campo : EMP_BD    
  // Uso   : Base de Datos o Ruta                    
  //
  @ 8.2, 1.0 BMPGET  oEMPRESA:oEMP_BD      VAR oEMPRESA:EMP_BD;
             VALID oEMPRESA:ValUnique(oEMPRESA:EMP_BD    );
                   .AND. !VACIO(oEMPRESA:EMP_BD,NIL);
                    NAME "BITMAPS\DATABASE2.bmp";
                    ACTION oEMPRESA:VERBD(oEMPRESA:oEMP_BD);
                    WHEN (AccessField("DPEMPRESA","EMP_BD",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

/*
  //
  // Campo : EMP_BD    
  // Uso   : Base de Datos o Ruta                    
  //
  @ 8.2, 1.0 GET  oEMPRESA:oEMP_BD      VAR oEMPRESA:EMP_BD      VALID oEMPRESA:ValUnique(oEMPRESA:EMP_BD    );
                   .AND. !VACIO(oEMPRESA:EMP_BD,NIL);
                    WHEN (AccessField("DPEMPRESA","EMP_BD",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG
*/

    oEMPRESA:oEMP_BD    :cMsg    :="Base de Datos o Ruta"
    oEMPRESA:oEMP_BD    :cToolTip:="Base de Datos o Ruta"

  @ oEMPRESA:oEMP_BD    :nTop-08,oEMPRESA:oEMP_BD    :nLeft SAY "Base de Datos o Ruta" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_DSN   
  // Uso   : DSN de Datos                            
  //
  @ 10.0, 1.0 GET oEMPRESA:oEMP_DSN     VAR oEMPRESA:EMP_DSN;
                   VALID oEMPRESA:VALEMPDSN() .AND. oEMPRESA:ValUnique(oEMPRESA:EMP_DSN);
                    WHEN (AccessField("DPEMPRESA","EMP_DSN",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

    oEMPRESA:oEMP_DSN   :cMsg    :="DSN de Datos"
    oEMPRESA:oEMP_DSN   :cToolTip:="DSN de Datos"

  @ oEMPRESA:oEMP_DSN   :nTop-08,oEMPRESA:oEMP_DSN   :nLeft SAY "DSN de Datos" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_LOGIN 
  // Uso   : Login                                   
  //
  @ 1.0,15.0 GET oEMPRESA:oEMP_LOGIN   VAR oEMPRESA:EMP_LOGIN  ;
                    WHEN (AccessField("DPEMPRESA","EMP_LOGIN",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

    oEMPRESA:oEMP_LOGIN :cMsg    :="Login"
    oEMPRESA:oEMP_LOGIN :cToolTip:="Login"

  @ oEMPRESA:oEMP_LOGIN :nTop-08,oEMPRESA:oEMP_LOGIN :nLeft SAY "Login" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_CLAVE 
  // Uso   : Clave                                   
  //
  @ 2.8,15.0 GET oEMPRESA:oEMP_CLAVE   VAR oEMPRESA:EMP_CLAVE  ;
                    WHEN (AccessField("DPEMPRESA","EMP_CLAVE",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

    oEMPRESA:oEMP_CLAVE :cMsg    :="Clave"
    oEMPRESA:oEMP_CLAVE :cToolTip:="Clave"

  @ oEMPRESA:oEMP_CLAVE :nTop-08,oEMPRESA:oEMP_CLAVE :nLeft SAY "Clave" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_REGCLA
  // Uso   : Requiere Clave                          
  //
  @ 4.6,15.0 CHECKBOX oEMPRESA:oEMP_REGCLA  VAR oEMPRESA:EMP_REGCLA  PROMPT ANSITOOEM("Requiere Clave");
                    WHEN (AccessField("DPEMPRESA","EMP_REGCLA",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                     FONT oFont COLOR nClrText,NIL SIZE 124,10

    oEMPRESA:oEMP_REGCLA:cMsg    :="Requiere Clave"
    oEMPRESA:oEMP_REGCLA:cToolTip:="Requiere Clave"


  //
  // Campo : EMP_ACTIVA
  // Uso   : Empresa Activa                       
  //
  @ 4.6,15.0 CHECKBOX oEMPRESA:oEMP_ACTIVA  VAR oEMPRESA:EMP_ACTIVA  PROMPT ANSITOOEM("Empresa Activa");
                    WHEN (AccessField("DPEMPRESA","EMP_ACTIVA",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                     FONT oFont COLOR nClrText,NIL SIZE 124,10

    oEMPRESA:oEMP_ACTIVA:cMsg    :="Empresa Activa"
    oEMPRESA:oEMP_ACTIVA:cToolTip:="Empresa Activa"


  //
  // Campo : EMP_EMANAG
  // Uso   : Acceso desde eManager                  
  //
  @ 4.6,15.0 CHECKBOX oEMPRESA:oEMP_EMANAG  VAR oEMPRESA:EMP_EMANAG  PROMPT ANSITOOEM("Acceso desde eManager");
                    WHEN (AccessField("DPEMPRESA","EMP_EMANAG",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                     FONT oFont COLOR nClrText,NIL SIZE 124,10

    oEMPRESA:oEMP_EMANAG:cMsg    :="Acceso desde eManager"
    oEMPRESA:oEMP_EMANAG:cToolTip:="Acceso desde eManager"


  //
  // Campo : lMaestras
  // Uso   : Empresa Activa                       
  //
  @ 4.6,15.0 CHECKBOX oEMPRESA:oMaestras  VAR oEMPRESA:lMaestras  PROMPT ANSITOOEM("Sólo Tablas Maestras");
                      WHEN !Empty(oEMPRESA:cBDORG);
                      FONT oFont COLOR nClrText,NIL SIZE 124,10

  oEMPRESA:oMaestras:cMsg    :="Solo Tablas Maestras"
  oEMPRESA:oMaestras:cToolTip:="Sólo Tablas Maestras"

  //
  // Campo : lCxC
  // Uso   : Empresa Activa                       
  //
  @ 4.6,15.0 CHECKBOX oEMPRESA:oCxC  VAR oEMPRESA:lCxC  PROMPT ANSITOOEM("Exportar CxC");
                      WHEN !Empty(oEMPRESA:cBDORG) .AND. oEMPRESA:lMaestras .AND. oDp:cType="SGE";
                      FONT oFont COLOR nClrText,NIL SIZE 124,10

  oEMPRESA:oCxC:cMsg    :="Exportar CxC"
  oEMPRESA:oCxC:cToolTip:="Exportar CxC"

  //
  // Campo : lCxP
  // Uso   : Clonar CxP

  @ 4.6,15.0 CHECKBOX oEMPRESA:oCxP  VAR oEMPRESA:lCxP  PROMPT ANSITOOEM("Exportar CxP");
                      WHEN !Empty(oEMPRESA:cBDORG) .AND. oEMPRESA:lMaestras .AND. oDp:cType="SGE";
                      FONT oFont COLOR nClrText,NIL SIZE 124,10

  oEMPRESA:oCxP:cMsg    :="Exportar CxP"
  oEMPRESA:oCxP:cToolTip:="Exportar CxP"

  //
  // Campo : EMP_TIPFCH
  // Uso   : Lista de Versiones                      
  //
  @ 10, 20 COMBOBOX oEMPRESA:oEMP_TIPFCH VAR oEMPRESA:EMP_TIPFCH ITEMS aItems1;
                      WHEN AccessField("DPEMPRESA","EMP_TIPFCH",oEMPRESA:nOption)  ;
                      FONT oFontG

  ComboIni(oEMPRESA:oEMP_TIPFCH)

  oEMPRESA:oEMP_TIPFCH:cMsg    :="Tipo de Fecha"
  oEMPRESA:oEMP_TIPFCH:cToolTip:="Tipo de Fecha"

  @ oEMPRESA:oEMP_TIPFCH:nTop-08,oEMPRESA:oEMP_TIPFCH:nLeft SAY "Tipo de Fecha" PIXEL;
                                   SIZE NIL,7 FONT oFont COLOR nClrText,NIL 



  //
  // Campo : EMP_FCHULT
  // Uso   : Fecha de Inicio                         
  //
  @ 10, 25 BMPGET oEMPRESA:oEMP_FCHULT  VAR oEMPRESA:EMP_FCHULT  PICTURE "99/99/9999";
           NAME "BITMAPS\Calendar.bmp";
           ACTION LbxDate(oEMPRESA:oEMP_FCHULT,oEMPRESA:EMP_FCHULT);
                  WHEN (AccessField("DPEMPRESA","EMP_FCHULT",oEMPRESA:nOption);
                        .AND. oEMPRESA:nOption!=0 .AND. oDp:nVersion>=5);
                  FONT oFontG

  oEMPRESA:oEMP_FCHULT:cMsg    :="Fecha de Inicio"
  oEMPRESA:oEMP_FCHULT:cToolTip:="Fecha de Inicio"

  @ oEMPRESA:oEMP_FCHULT:nTop-08,oEMPRESA:oEMP_FCHULT:nLeft SAY "Ultima Fecha" PIXEL;
                                 SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  @ 12.0, 1.0 GROUP oEMPRESA:oGroup TO 13,6 PROMPT "Servidor Externo para Intercambio de Datos";
                      FONT oFontG


  @ 12,06 BMPGET oEMPRESA:oEMP_CODSER VAR oEMPRESA:EMP_CODSER;
                 VALID oEMPRESA:EMPCODSER();
                 NAME "BITMAPS\FIND22.BMP"; 
                 ACTION (oDpLbx:=DpLbx("DPSERVERBD",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,oEMPRESA:oEMP_CODSER,oEMPRESA:oWnd),;
                       oDpLbx:GetValue("SBD_CODIGO",oEMPRESA:oEMP_CODSER)); 
                 WHEN (AccessField("DPEMPRESA","SBD_CODIGO",oEMPRESA:nOption));
                 SIZE 28,10

   @ 12,17 SAY oEMPRESA:oSerNombre ;
           PROMPT SQLGET("DPSERVERBD","SBD_DESCRI","SBD_CODIGO"+GetWhere("=",oEMPRESA:EMP_CODSER)) ;
           SIZE 120,09

  //
  // Campo : EMP_RIF 
  // Uso   : RIF de la empresa                                  
  //
  @ 10,15 GET oEMPRESA:oEMP_RIF   VAR oEMPRESA:EMP_RIF  ;
              WHEN (AccessField("DPEMPRESA","EMP_RIF",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

  oEMPRESA:oEMP_RIF :cMsg    :=oDp:cNit
  oEMPRESA:oEMP_RIF :cToolTip:=oDp:cNit

  @ oEMPRESA:oEMP_RIF :nTop-08,oEMPRESA:oEMP_RIF :nLeft SAY oDp:cNit PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 


  //
  // Campo : EMP_EMPIDD 
  // Uso   : Clave para Seguridad de Transferencia de Datos                               
  //

  @ 12,30 GET oEMPRESA:oEMP_EMPIDD   VAR oEMPRESA:EMP_EMPIDD  ;
              WHEN (AccessField("DPEMPRESA","EMP_EMPIDD",oEMPRESA:nOption);
                    .AND. oEMPRESA:nOption!=0);
                    FONT oFontG

  oEMPRESA:oEMP_EMPIDD :cMsg    :="Clave para Seguridad de Transferencia de Datos"
  oEMPRESA:oEMP_EMPIDD :cToolTip:=oEMPRESA:oEMP_EMPIDD :cMsg

  @ oEMPRESA:oEMP_EMPIDD :nTop-08,oEMPRESA:oEMP_EMPIDD :nLeft SAY "Clave" PIXEL;
                            SIZE NIL,7 FONT oFont COLOR nClrText,NIL 

  oEMPRESA:Activate({||oEMPRESA:EMPINICIO()})

  STORE NIL TO oTable,oGet,oFont,oGetB,oFontG

RETURN oEMPRESA

FUNCTION EMPINICIO()
   LOCAL oBar,oBtn,oFont,oCol,nDif,oCursor,nLin:=0
   LOCAL nWidth :=0 // Ancho Calculado seg£n Columnas
   LOCAL nHeight:=0 // Alto
   LOCAL nLines :=0 // Lineas
   LOCAL oDlg:=oEMPRESA:oDlg

   oDlg:=oEMPRESA:oDlg

   IF oEMPRESA:lDialog
     oEMPRESA:oDlg:Move(120,0)
   ENDIF
   
   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 52-15,60-15 OF oEMPRESA:oDlg 3D CURSOR oCursor

   IF oBar=NIL
      RETURN NIL
   ENDIF

   oEMPRESA:oBar:=oBar

   IF oEMPRESA:nOption=1 .OR. oEMPRESA:nOption=3

     DEFINE BUTTON oBtn;
            OF oBar;
            NOBORDER;
            FONT oFont;
            FILENAME "BITMAPS\XSAVE.BMP";
            ACTION oEMPRESA:Save()

     oBtn:cToolTip:="Guadar"


     DEFINE BUTTON oBtn;
            OF oBar;
            NOBORDER;
            FONT oFont;
            FILENAME "BITMAPS\DATABASE.BMP";
            ACTION oEMPRESA:VERBD(oEMPRESA:oBtnEmp)

     oBtn:cToolTip:="Visualizar Lista de Bases de Datos"
     oEMPRESA:oBtnEmp:=oBtn


     DEFINE BUTTON oBtn;
            OF oBar;
            NOBORDER;
            FONT oFont;
            FILENAME "BITMAPS\XCANCEL.BMP";
            ACTION (oEMPRESA:Cancel()) CANCEL

     oBtn:cToolTip:="Cancelar"


   ELSE


     DEFINE BUTTON oBtn;
            OF oBar;
            NOBORDER;
            FONT oFont;
            FILENAME "BITMAPS\XSALIR.BMP";
            ACTION (oEMPRESA:Cancel()) CANCEL

   ENDIF
 
   IF ValType(oBar)="O"

      oBar:SetColor(CLR_BLACK,oDp:nGris)
      AEVAL(oEMPRESA:oBar:aControls,{|o,n|o:SetColor(CLR_BLACK,oDp:nGris),nLin:=nLin+o:nWidth()})

      IF !Empty(oEMPRESA:cBDORG)

        DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -12  BOLD

        @ 02,nLin+40  SAY " Origen "              OF oBar BORDER SIZE 66,20 COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFont SIZE 80,20 PIXEL RIGHT
        @ 02,nLin+102	 SAY " "+oEMPRESA:cBDORG+" "+ALLTRIM(SQLGET("DPEMPRESA","EMP_NOMBRE","EMP_BD"+GetWhere("=",oEMPRESA:cBDORG)))+" " OF oBar BORDER SIZE 310,20 COLOR oDp:nClrYellowText,oDp:nClrYellow   FONT oFont SIZE 80,20 PIXEL 

      ENDIF

      oBar:Refresh(.T.)


   ENDIF

RETURN .T.

/*
// Carga de Datos, para Incluir
*/
FUNCTION LOAD()

  IF oEMPRESA:nOption=1 // Incluir en caso de ser Incremental
     oEMPRESA:EMP_CODIGO:=SQLINCREMENTAL("DPEMPRESA","EMP_CODIGO")
     oEMPRESA:oEMP_CODIGO:VarPut(oEMPRESA:EMP_CODIGO,.T.)
     // AutoIncremental 
  ENDIF

RETURN .T.
/*
// Ejecuta Cancelar
*/
FUNCTION CANCEL()
RETURN .T.


/*
// Ejecución PreGrabar
*/
FUNCTION PRESAVE()
  LOCAL lResp:=.T.
  LOCAL oTable,nCuantos

  lResp:=oEMPRESA:ValUnique(oEMPRESA:EMP_DSN   )

  IF !lResp
     oEMPRESA:oEMP_CODIGO:MsgErr("Registro "+CTOO(oEMPRESA:EMP_DSN),"Ya Existe")
     RETURN .F.
  ENDIF

  IF Empty(oEMPRESA:EMP_CODIGO)
     oEMPRESA:oEMP_CODIGO:MsgErr("Código no debe estar Vacio ","Dato Inválido")
     RETURN .F.
  ENDIF

  IF Empty(oEMPRESA:EMP_NOMBRE)
     oEMPRESA:oEMP_NOMBRE:MsgErr("Nombre no debe estar Vacio ","Dato Inválido")
     RETURN .F.
  ENDIF

  IF Empty(oEMPRESA:EMP_BD)
     oEMPRESA:oEMP_BD:MsgErr("Es Necesario el Nombre de la Base de Datos","Dato Inválido")
     oEMPRESA:EMPSETDSN(oEMPRESA:EMP_CODIGO)
     RETURN .F.
  ENDIF

  // Asumen el Contenido del DSN
  IF Empty(oEMPRESA:EMP_DSN)
     oEMPRESA:EMP_DSN:=oEMPRESA:EMP_BD
  ENDIF

  IF Empty(oEmpresa:EMP_MYSQLV)
    oEmpresa:EMP_MYSQLV:=EJECUTAR("MYSQLVERSION")
  ENDIF

  oTable:=OpenTable("SELECT COUNT(*) AS CUANTOS FROM DPUSUARIOS",.T.)
  nCuantos:=oTable:FieldGet(1)
  oTable:End()

//  IF oEMPRESA:lSelect
//      oEMPRESA:POSTSAVE()
//  ENDIF

/*
  IF nCuantos>0 .AND. MsgNoYes("Desea Otorgar accesos a los Usuarios")
     EJECUTAR("DPUSUXEMP",oEMPRESA:EMP_CODIGO)
  ENDIF
*/
RETURN .T.


/*
// Ejecución despues de Grabar
*/
FUNCTION POSTSAVE()
  LOCAL oTable,cWhere,cMin
  LOCAL lFind:=.F.


  lFind:=(oDp:oMySqlCon:ExistDb( UPPER(ALLTRIM(oEMPRESA:EMP_BD))) .OR.  oDp:oMySqlCon:ExistDb( LOWER(ALLTRIM(oEMPRESA:EMP_BD))))

  /*
  // Asigna el Permiso para el usuario que lo diseño. JN 02/01/2016
  */

  EJECUTAR("FCH_EJER")

  oDp:cTipFch :=SQLGET("DPEMPRESA","EMP_TIPFCH,EMP_FCHULT","EMP_CODIGO"+GetWhere("=",oDp:cEmpCod))

  IF !Empty(oEMPRESA:cBDORG)
     EJECUTAR("DPEMPRESADUPLICA",oEMPRESA:cBDORG,oEMPRESA:EMP_BD,.F.,NIL,NIL,oEMPRESA:lMaestras,oEMPRESA:lCxC,oEMPRESA:lCxP)
  ENDIF

  IF oEMPRESA:nOption=1 .AND. Empty(oEMPRESA:cBDORG) .AND. !lFind

     // cMin    :=SQLGETMIN("DPEMPRESA","EMP_CODIGO")
     // oEMPRESA:cBDORG:=ALLTRIM(SQLGET("DPEMPRESA","EMP_BD","EMP_CODIGO"+GetWhere("=",cMin)))
     // 6/5/2023 Crear la empresa desde MYSQL.EXE
     IF Empty(oEMPRESA:cBDORG)
        EJECUTAR("DPCREABDFROMSCRIPT",NIL,ALLTRIM(oEMPRESA:EMP_BD))
     ELSE
       oEMPRESA:cBDORG:=oDp:cDsnData // 24/01/2023 debe tomar la empresa que esta en ejecucion para asumir la misma estructura
       EJECUTAR("DPEMPRESADUPLICA",oEMPRESA:cBDORG,oEMPRESA:EMP_BD,.F.,.T.,NIL,oEMPRESA:lMaestras,oEMPRESA:lCxC,oEMPRESA:lCxP)
     ENDIF

  ENDIF

  EJECUTAR("DPEMPUSUARIOASG","DPEMPRESA",oEMPRESA:EMP_CODIGO)
 
  // 02/05/2023 Seleccionar la empresa desde crear empresa

  IF oEMPRESA:lSelect
     oEMPRESA:nOption:=3 // debe cerrar el formulario
// ? "antes de dprunempnew"
     EJECUTAR("DPRUNEMPNEW",oEMPRESA:EMP_CODIGO,.T.,.T.,.F.,NIL,.F.,.F.,oEMPRESA)
  ELSE
     EJECUTAR("DPUSUXEMP",oEMPRESA:EMP_CODIGO)
  ENDIF

RETURN .T.

FUNCTION ONCLOSE()
RETURN .T.

/*
// Asigna DSN
*/
FUNCTION EMPSETDSN(cCodEmp)
  LOCAL nLen:=LEN(oEMPRESA:oEMP_BD)
  LOCAL cV  :="V"+STRZERO(oDp:nVersion*10,2)+"_"

  IF oEMPRESA:nOption=1 .AND. Empty(oEMPRESA:cBDDES)
     oEMPRESA:oEMP_BD:VARPUT(PADR(oDp:cTipProd+cV+cCodEmp,nLen) ,.T.)
     oEMPRESA:oEMP_DSN:VARPUT(PADR(oDp:cTipProd+cCodEmp,nLen),.T.)
     oEMPRESA:oEMP_FECHAI:VARPUT(CTOD("01/01/"+STRZERO(YEAR(oDp:dFecha),4)),.T.)
     oEMPRESA:oEMP_FECHAF:VARPUT(CTOD("31/12/"+STRZERO(YEAR(oDp:dFecha),4)),.T.)
  ENDIF

RETURN .T.

FUNCTION CALCULAFINMES()
   LOCAL I,dFecha:=FCHFINMES(oEMPRESA:EMP_FECHAI)

   FOR I=1 TO 11
      dFecha:=FCHFINMES(dFecha)+1
   NEXT I

   dFecha:=FCHFINMES(dFecha)

   oEMPRESA:oEMP_FECHAF:VarPut(dFecha,.T.)

RETURN .T.

FUNCTION EMPCODSER()

  LOCAL lResp:=.T.

  lResp:=!Empty(SQLGET("DPSERVERBD","SBD_DESCRI","SBD_CODIGO"+GetWhere("=",oEMPRESA:EMP_CODSER)))

  oEMPRESA:oSerNombre:Refresh(.T.)

  IF !lResp
    oEMPRESA:oEMP_CODSER:KeyBoard(VK_F6)
  ENDIF

RETURN lResp

/*
// Ver las Bases de Datos
*/
FUNCTION VERBD(oControl)
  LOCAL nLen  :=LEN(oEMPRESA:EMP_BD)
  LOCAL x     :=MySqlStart()
  LOCAL cLista:=EJECUTAR("MYSQLLISTBD",oControl,oEMPRESA:EMP_BD,"")

  IF "GET"$oControl:ClassName() .AND. !Empty(cLista)
     oControl:VarPut(PADR(cLista,nLen),.T.)
     oEMPRESA:oEMP_DSN:VarPut(oEMPRESA:EMP_BD,.T.)
  ENDIF

RETURN cLista

FUNCTION VALEMPDSN()

  IF Empty(oEMPRESA:EMP_DSN) .AND. !Empty(oEMPRESA:EMP_BD)
     oEMPRESA:oEMP_DSN:VarPut(oEMPRESA:EMP_BD,.T.)
  ENDIF

RETURN .T.
/*
<LISTA:@Grupo01:N:GROUP:N:N:N:Identificación,EMP_CODIGO:Y:GET:N:N:Y:Número,EMP_NOMBRE:N:GET:N:N:Y:Nombre,EMP_FECHAI:N:BMPGET:N:N:Y:Fecha de Inicio
,EMP_FECHAF:N:BMPGET:N:N:Y:Fecha de Cierre,@Grupo02:N:GROUP:N:N:N:Base de Datos,EMP_BD:Y:GET:N:N:N:Base de Datos o Ruta,EMP_DSN:Y:GET:N:N:N:DSN de Datos
,EMP_LOGIN:N:GET:N:N:Y:Login,EMP_CLAVE:N:GET:N:N:Y:Clave,EMP_REGCLA:N:CHECKBOX:N:N:Y:Requiere Clave>
*/
