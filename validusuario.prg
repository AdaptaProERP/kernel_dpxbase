// Programa   : VALIDUSUARIO
// Fecha/Hora : 30/07/2023 07:49:03
// Propósito  : Validar el Ingreso del Usuario desde formulario LOGIN/PASS
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oForm,lButton)
   LOCAL cLogin:=ALLTRIM(oForm:oUsuario:VarGet())
   LOCAL cPass :=ALLTRIM(oForm:oPass:VarGet())
   LOCAL oTable,lFound,cField,I,dFecha
   LOCAL cAmIni,cAmFin,cPmIni,cPmFin,cWhere
   LOCAL aSemana:={"DOMINGO","LUNES","MARTES","MIERCOLES","JUEVES","VIERNES","SABADO","DOMINGO"}
   LOCAL cDb    :=GETDSN("DPUSUARIOS")
   LOCAL cLoginE:=""
   LOCAL cPassE :=""

   // JN 4/4/2018 Validar Usuario Dormido
   IF .t. // oForm:nTimeMax>0 .AND. ABS(Seconds()-oForm:nSeconds) >= (oForm:nTimeMax)
     MYSQLCHKCONN() // Validar la Apertura de la BD Usuarios Dormidos
   ENDIF
   // JN 15/12/2022

   MySqlStart(.T.)

// ? "VALID USUARIO",GetProce()

   IF cDb=oDp:cDsnData
      SQLUPDATE("DPTABLAS","TAB_DSN",".CONFIGURACION","TAB_NOMBRE"+getWhere("=","DPUSUARIOS"))
      LOADTABLAS(.T.)
   ENDIF

   IF !ISFIELD("DPUSUARIOS","OPE_ENCRIP")
      // EJECUTAR("TXTTOTABLAS","DPUSUARIOS.TXT")
      EJECUTAR("DPCAMPOSADD","DPUSUARIOS","OPE_ENCRIP" ,"L",01,0,"Encriptado")
      SQLUPDATE("DPUSUARIOS","OPE_ENCRIP",.F.,"OPE_ENCRIP IS NULL")
   ENDIF

   IF ISFIELD("DPUSUARIOS","OPE_ALLPC")
      SQLUPDATE("DPUSUARIOS","OPE_ALLPC" ,.T.     ,"OPE_ALLPC  IS NULL")
   ENDIF

   DEFAULT lButton:=.F. 
   // Presionado

   IF oForm:oPass:nLastKey=38 // Subir
       RETURN .T.
   ENDIF

   // jn 06/07/2013
   oDp:oMySqlCon:ReConnect()

   IF UPPE(ALLTRIM(cLogin))="*DATAPRO*" .OR. UPPE(ALLTRIM(cPass))="*DATAPRO*"

      DPWRITE("DP\DPLOGIN.DP",ENCRIPT(DTOC(oDp:dFecha+5),.T.))

      oForm:oUsuario:MsgErr(MI("Usuario no Encontrado",336))

      RETURN .F.

   ENDIF

   IF UPPE(ALLTRIM(cLogin))="*CLAVE*" .OR. UPPE(ALLTRIM(cPass))="*CLAVE*"
      DPWRITE("DP\DPLOGIN.DP",ENCRIPT(DTOC(oDp:dFecha+8),.T.))
      oForm:oUsuario:MsgErr(MI("Usuario no Encontrado",336))
      RETURN .F.
   ENDIF

   dFecha:=MemoRead("DP\DPLOGIN.DP")

   IF !Empty(dFecha)

      dFecha:=CTOD(ENCRIPT(dFecha,.F.))

      IF dFecha>=oDp:dFecha

         FERASE("DP\DPLOGIN.DP")

         oTable:=OpenTable("DPCONFIG",.T.)
         oTable:Replace("CON_INVDEL","")
         oTable:Replace("CON_DPSIS" ,"")
         oTable:Replace("CON_FECHAI",CTOD(""))
         oTable:Commit("1=1")
         oTable:End()

      ENDIF

   ENDIF

   cWhere:="WHERE OPE_NUMERO"+GetWhere("=",EJECUTAR("GETUSERNCRIP",cLogin,cPass))

// ? cWhere,GetProce(),ErrorSys(.T.)

   oDp:aExcluye:={}

   oTable:=OpenTable("SELECT * FROM DPUSUARIOS "+cWhere,.T.)

 // ? "AQUI ES OPENTABLE LUEGO DE LA VALIDACION "

   lFound:=(oTable:RecCount()>0)

   IF lFound .AND. !oTable:OPE_ACTIVO .AND. !EJECUTAR("USINACTIVO",oTable:OPE_NUMERO)
      oTable:End()
      oForm:oUsuario:MsgErr(MI("Usuario",322)+" "+oTable:OPE_NUMERO+" "+MI("Inactivo",337))
      RETURN .F.
   ENDIF

   IF lFound

      oDp:cUsuario:=oTable:OPE_NUMERO

      cLoginE:=OPE_NOMBRE()
      cPassE :=OPE_CLAVE()

      IF !ALLTRIM(cLoginE)==ALLTRIM(cLogin) .OR. !ALLTRIM(cPassE)==ALLTRIM(cPass)
         lFound:=.F.
      ENDIF

   ENDIF

   IF !lFound

      oTable:End()
      oForm:nIntento:=oForm:nIntento+1

      IF oForm:nIntento>=3
         oForm:oUsuario:MsgErr(oDp:cDpSys+MI(" serï¿½ Cerrado ",332),MI("Usuario no Admitido ",338))
         oForm:Close()
         RETURN .F.
      ENDIF

      oForm:oUsuario:MsgErr(MI("Usuario",322)+" "+cLogin+" "+MI("y Clave no Encontrado, revise tecla mayúscula/minúscula",339)+CRLF+"DB:"+cDb+"/ "+MI("Servidor:",300,"MYSQL")+oDp:cIp,MI("Intento",340)+" "+LSTR(oForm:nIntento)+"/3")

      RETURN .F.

   ELSE


      cField:=LEFT(aSemana[DOW(oDP:dFecha)],6)

      IF !oTable:FieldGet("OPE_"+cFIELD) // Dia, no Autorizado
        oTable:End()
        oForm:oUsuario:MsgErr(MI("Usuario no Está Autorizado para Acceder el día",341)+" "+UPPE(CSEMANA(oDP:dFecha)))
        RETURN .F.
/*

        oDp:aHorario:={"00:00","00:00","00:00","00:00",.F.}

        oDp:cMapaTab  :=""
        oDp:cMapaMnu  :=""
*/

      ELSE

        cField:=LEFT(cField,3)

        cAmIni:="OPE_"+cField+"AIN"
        cAmFin:="OPE_"+cField+"AFI"
        cPmIni:="OPE_"+cField+"PIN"
        cPmFin:="OPE_"+cField+"PFI"

        oDp:aHorario:={oTable:FieldGet(cAmIni),;
                       oTable:FieldGet(cAmFin),;
                       oTable:FieldGet(cPmIni),;
                       oTable:FieldGet(cPmFin),.T.}

       oDp:cUsuario  :=oTable:OPE_NUMERO // Nï¿½mero del Usuario
       oDp:cUsNombre :=OPE_NOMBRE(oDp:cUsuario) // Nï¿½mero del Usuario
       oDp:cMapaTab  :=oTable:OPE_MAPTAB   // Cï¿½digo del Mapa por Archivo
       oDp:cMapaMnu  :=oTable:OPE_MAPMNU   // Cï¿½digo del Mapa por Menï¿½
       oDp:cClave    :=oTable:OPE_CLAVE
       oDp:lUsEncript:=CTOO(oTable:OPE_ENCRIP,"L")   // Usuarios Encriptados

       IF oDp:lUsEncript
         oDp:cUsNombre :=ENCRIPT(oTable:OPE_NOMBRE,.F.)
       ENDIF

       oTable:End()

       oDp:aMapaTab  :={} // Mapa de Opciones x Tabla
       oDp:aMapaMnu  :={} // Mapa de Opciones por Menï¿½

      ENDIF

      REV_HORA(.T.) // Revisa la Hora del Usuario

      LEEMAPAS()

      IF ValType(oDp:oItemUs)="O"
        oDp:oItemUs:SetText("[U:"+oDp:cUsuario+"]") //  +oDp:cUsNombre)
      ENDIF

   ENDIF

   // Acceso desde Otro PC
   cWhere:="EXU_CODUSU"+GetWhere("=",oDp:cUsuario)+" AND "+;
           "EXU_TABLA" +GetWhere("=","DPPCLOG"   )+" AND "+;
           "EXU_CODIGO"+GetWhere("=",oDp:cPcName )+" AND "+;
           "EXU_SELECT"+GetWhere("=",.T.         )

   oTable:End()

   IF !oTable:OPE_ALLPC .AND. COUNT("DPEMPUSUARIO",cWhere)=0
     DPWRITE("TEMP\DPUSUARIOS.SQL",oDp:cSql)
     MensajeErr("Usuario ["+oDp:cUsuario+" "+oDp:cUsNombre+"] "+MI("no Tiene Permiso para Acceder al PC",342)+" "+oDp:cIpLocal)
     RETURN .F.
   ENDIF

   IF !lFound

      oForm:oPass:lPassWord:=.F.
      oForm:oPass:VarPut(SPACE(oForm:nLenPass),.T.) // Lo Pone Vacio
      oForm:oPass:lPassWord:=.T.

      DpFocus(oForm:oUsuario)
      EVAL(oForm:bAceptar,.F.)

      Return .T.

   ELSE

      EVAL(oForm:bAceptar,.T.)
      oForm:Close()

   ENDIF

RETURN lFound
// EOF
