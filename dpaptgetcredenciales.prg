// Programa   : DPAPTGETCREDENCIALES
// Fecha/Hora : 21/06/2023 14:14:17
// Propósito  : Introduce, número del RIF y Licencia obtiene las credenciales de las base de datos desde AdaptaPro
// Creado Por : Juan Navas
// Llamado por: DPSETVAR
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL lFrame:=ValType(oDp:oFrameDp)="O",cAdpExe

   IF !ValType(oDp:oFrameDp)="O"
      DPFRAMEDP()
   ELSE
      XMAIN2(lFrame)
   ENDIF

   IF !lFrame

     oDp:oFrameDp:End()
     oDp:oFrameDp:=NIL

     SETMYSQLMEM()

     cAdpExe:=LOWER(GetModuleFileName( GetInstance() ))

     WINEXEC(cAdpExe)

   ENDIF

RETURN .T.

FUNCTION XMAIN2(lFrame)
   LOCAL cLicencia:=SPACE(34)
   LOCAL cRif:=SPACE(12)

   WsaStartUp()

   oDp:lDialog:=.T.

   EJECUTAR("GETLICENSE")

   cRif     :=IF(Empty(oDp:cLic_Rif),cRif     ,oDp:cLic_Rif)
   cLicencia:=IF(Empty(oDp:cLic_Num),cLicencia,oDp:cLic_Num)

   oFrm:=DPEDIT():New("Obtener Credenciales de la Base de Datos para Conectarse con el Servidor Local","DPAPTGETCREDENCIALES.edt","oFrm",.T.,oDp:lDialog)

   oFrm:cRif      :=cRif
   oFrm:cLicencia :=PADR(cLicencia,34)  // "10000615M1002NGL5101949",24) // SPACE(24)
   oFrm:cMemo     :="Obtienes los datos de tu Servidor local, obtenidos cuando fué activada la licencia."+CRLF
   oFrm:LIC_SRVIP :=""
   oFrm:LIC_NUMERO:=""
   oFrm:cDb       :=oDp:cDsnConfig
   oFrm:cIp       :=""
   oFrm:cLogin    :=""
   oFrm:cPass     :=""
   oFrm:nPort     :=0
   oFrm:lError    :=.F.
   oFrm:lResp     :=.F.
   oFrm:lFrame    :=lFrame

   @ 5,01 SAY "Rif "      RIGHT
   @ 6,01 SAY "Licencia " RIGHT

   @ 5,06 GET oFrm:oRif      VAR oFrm:cRif        UPDATE;
          VALID (oFrm:oBtnSave:ForWhen(.T.),.T.)

   @ 6,06 GET oFrm:oLicencia VAR oFrm:cLicencia   UPDATE

   @ 7,06 BUTTON oFrm:oBtn PROMPT ">";
          ACTION EVAL(oFrm:oBtnSave:bAction);
          WHEN !Empty(oFrm:cRif) UPDATE


   @ 10,06 GET oFrm:oMemo VAR oFrm:cMemo MEMO READONLY

   oFrm:Activate({||oFrm:oDlg:Move(100,0),BOTBARGENUMLIC()})

   IF !oFrm:lResp .AND. !oFrm:lFrame
      oDp:oFrameDp:End()
   ENDIF

RETURN oFrm:lResp

FUNCTION BOTBARGENUMLIC()
   LOCAL oCursor,oBar,oBtn,oFont,oCol
   LOCAL oDlg:=oFrm:oDlg

   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 52-15+14+10-0,60-15+10 OF oDlg 3D CURSOR oCursor

   DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -10 BOLD

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\download.bmp",NIL,"BITMAPS\downloadg.bmp";
          TOP PROMPT "Descargar";
          WHEN !Empty(oFrm:cRif+oFrm:cLicencia); 
          ACTION  oFrm:LEERLICENCIA()

   oFrm:oBtnSave:=oBtn
   oBtn:cToolTip:="Descargar Credenciales"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\RUN.BMP",NIL,"BITMAPS\RUNG.BMP";
          TOP PROMPT "Validar";
          WHEN !Empty(oFrm:LIC_SRVIP); 
          ACTION  oFrm:VALIDARCONEXION()

   oFrm:oBtnValid:=oBtn
   oBtn:cToolTip:="Valida la Conexión con el Servidor Local"

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          TOP PROMPT "Cerrar";
          FILENAME "BITMAPS\XSALIR.BMP";
          ACTION (oFrm:lResp:=.F.,;
                  oFrm:Close())

   oBtn:cToolTip:="Salir sin Activar"
   oBar:SetColor(CLR_BLACK,oDp:nGris)

   AEVAL(oBar:aControls,{|o,n|o:SetColor(CLR_BLACK,oDp:nGris)})

RETURN .T.
/*
//
*/
FUNCTION LEERLICENCIA()
   LOCAL aLine:={},cIpVal,oDb

   CursorWait()

   oFrm:oMemo:Append("Conectando con AdaptaPro Server.."+CRLF)

   aLine:=GETCRENDECIALESLIC(oFrm,oFrm:cRif,oFrm:cLicencia)

   IF !Empty(oDp:cMsgErr)
      oFrm:oMemo:Append(oDp:cMsgErr+CRLF)
      RETURN .F.
   ENDIF

   IF !Empty(oFrm:LIC_NUMERO)
      oFrm:oLicencia:VarPut(oFrm:LIC_NUMERO,.T.)
   ENDIF

   IF Empty(aLine)
      MsgMemo("Rif "+oFrm:cRif+" no tiene Licencias Registradas")
      RETURN .F.
   ENDIF

   IF !Empty(oFrm:LIC_SRVIP) 

      oFrm:oMemo:Append("IP del Servidor local "+ALLTRIM(oFrm:LIC_SRVIP)+CRLF)
      oFrm:oMemo:Append("Puerto "+ALLTRIM(oFrm:LIC_SRVPOR)+CRLF)

      oFrm:oBtnValid:ForWhen(.t.)

      oFrm:cIp   :=ALLTRIM(oFrm:LIC_SRVIP )
      oFrm:cLogin:=ALLTRIM(oFrm:LIC_SRVLOG)
      oFrm:cPass :=ALLTRIM(oFrm:LIC_SRVLOG)
      oFrm:nPort :=_MySqlPort

      oFrm:VALIDARCONEXION()

   ELSE

     oFrm:oRif:MsgErr("Licencia no posee credenciales del Servidor de la base de datos","Licencia "+oFrm:LIC_NUMERO)
  
   ENDIF

  
RETURN .T.

FUNCION VALIDARCONEXION()
   LOCAL _MycIp,_MycPass,_MycLoging,_MySqlDate:=oDp:cSqlDate,_MySqlPort
   LOCAL cFileMem:="MYSQL.MEM"
   LOCAL oDb,cRif:=oFrm:cRif,cMemoP:=""
 
   oFrm:oMemo:Append("Generando credenciales  "+CRLF)
// oFrm:oMemo:Append("Validando Conección con Servidor local "+oFrm:cIp+CRLF)
   oFrm:oMemo:Append("Ejecutando PING "+oFrm:LIC_SRVIP+CRLF)
   cMemoP:=EJECUTAR("GETPING",oFrm:LIC_SRVIP)

   oFrm:oMemo:Append(cMemoP+CRLF)

   IF !"AGOTA"$UPPER(cMemoP)
      oFrm:oMemo:Append("Conectando con BD "+oFrm:LIC_SRVIP+CRLF)
      oDb:=DPMYSQLBD(oFrm:cDb,oFrm:cIp,oFrm:cLogin,oFrm:cPass,oFrm:nPort,oFrm:lError,.F.,.F.,.F.)
   ENDIF

   IF ValType(oDb)="O"

     _MycIp    :=ENCRIPT(ALLTRIM(oFrm:LIC_SRVIP ),.T.)
     _MycPass  :=ENCRIPT(ALLTRIM(oFrm:LIC_SRVLOG),.T.)
     _MycLoging:=ENCRIPT(ALLTRIM(oFrm:LIC_SRVCLA),.T.)
     _MySqlDate:=ENCRIPT(oDp:cSqlDate,.T.)
     _MySqlPort:=VAL(oFrm:LIC_SRVPOR)

     SAVE TO (cFileMem) ALL LIKE _My*

     oFrm:lResp:=.T.

   ELSE

     oFrm:oRif:VarPut(cRif,.T.)

     oFrm:oMemo:Append("No fué posible conectarse con el Servidor local"+ALLTRIM(oFrm:LIC_SRVIP)+CRLF)
     oFrm:oMemo:Append("Revise en el servidor:"+CRLF)
     oFrm:oMemo:Append("1. Esté encendido"+CRLF)
     oFrm:oMemo:Append("2. Esté conectado en la red "+CRLF)
     oFrm:oMemo:Append("3. Realice la apertura del puerto "+ALLTRIM(oFrm:LIC_SRVPOR)+CRLF)

   ENDIF

RETURN .T.

FUNCTION DPFRAMEDP()
  LOCAL oIco,lSalir	

  oDp:aCoors:=GetCoors( GetDesktopWindow() )
  oDp:lConfig:=.T.

  DEFAULT lSalir:=.T.

  oDp:lSetDialog:=.F.
  oDp:oDbServer :=NIL

  SET DATE FREN
  SET MULTIPLE ON
  SET CENTURY ON

  HRBLOAD("MYSQL.HRB")

  IF oDp:lNativo
     oDp:cTypeBD:="MYSQL"
  ENDIF

  IF ValType(oDp:oFrameDp)="O"
     lSalir:=.F.
  ENDIF

  oDp:lSalir:=lSalir

  DEFAULT oDp:cEmpCod:=STRZERO(1,4)

  DEFINE ICON oIco FILE "bitmaps\dp.ico"

  oDp:oIco:=oIco

  DEFINE WINDOW oDp:oFrameDp MDI TITLE oDp:cDpSys ;
         VSCROLL HSCROLL COLOR NIL,16579836;
         MENU CONFIGMENU();
         ICON oIco 

  ACTIVATE WINDOW oDp:oFrameDp MAXIMIZED ON INIT XMAIN2(.F.)

RETURN .T. 

FUNCTION CONFIGMENU()
  Local oMenu,oFontB

  DEFINE FONT oFontB NAME "Tahoma"   SIZE 0, -16 BOLD 
 
  MENU oMenu FONT oFontB

     MENUITEM "&Opciones" 

     MENU

        MENUITEM "Salir" ACTION oDp:oFrameDp:End()

     ENDMENU
   
  ENDMENU

RETURN oMenu

FUNCTION SETMYSQLMEM()
   LOCAL _MycIp:="127.0.0.1",_MycPass:="root",_MycLoging:="root",_MySqlDate:=oDp:cSqlDate,_MySqlPort:=3306
   LOCAL cFileMem:="MYSQL.MEM"

    _MycIp    :=ENCRIPT(_MycIp    ,.T.)
    _MycPass  :=ENCRIPT(_MycPass  ,.T.)
    _MycLoging:=ENCRIPT(_MycLoging,.T.)
    _MySqlDate:=ENCRIPT(oDp:cSqlDate,.T.)

    IF MsgNoYes("Desea Crear Credenciales para Conexión con este PC")

       SAVE TO (cFileMem) ALL LIKE _My*

    ELSE

       MensajeErr(oDp:cDpSys+" será Cerrado","Actividad Concluida")
       oDp:oFrameDp:End()
  
       CANCEL
       
    ENDIF

RETURN NIL
// EOF
