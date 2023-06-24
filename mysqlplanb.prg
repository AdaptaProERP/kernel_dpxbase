// Programa   : MYSQLPLANB
// Fecha/Hora : 24/06/2023 03:19:09
// Propósito  : Validar IP en Servidor A y Servidor B
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL _MycIp:="",_MycPass:="",_MycLoging:="",_MySqlDate:="",_MySqlPort:=0
  LOCAL cFileMem :="MYSQL.MEM"
  LOCAL cFileMemB:="MYSQLPLANB.MEM"
  LOCAL cIp:="",cIpB,cMemoP,lConectaA:=.F.,lConectaB:=.F.,lError:=.T.
  LOCAL oDb

  IF !FILE(cFileMem)
     RETURN .T.
  ENDIF

  // No tiene PLANB
  IF !FILE(cFileMemB)
     RETURN .T.
  ENDIF

  REST FROM (cFileMem) ADDI

  cIp:=ENCRIPT(_MycIp    ,.F.)

  IF !("127.0.0.1"$cIp)

     MsgRun("Validando IP "+cIp,"Por Favor Espere",{||cMemoP:=EJECUTAR("GETPING",cIp) })

     IF !("TTL"$UPPER(cMemop))
       MsgMemo(cMemoP,"No hay Respuesta PING del Servidor "+cIp)
       lConectaA:=.F.
     ELSE
       lConectaA:=.T.
     ENDIF

  ELSE

     RETURN .T.

  ENDIF

  IF !lConectaA

    REST FROM (cFileMemB) ADDI

    cIpB      :=ENCRIPT(_MycIp    ,.F.)
    _MycPass  :=ENCRIPT(_MycPass  ,.F.)
    _MycLoging:=ENCRIPT(_MycLoging,.F.)

    // cIpB      :=GetHostByName(cIpB)

    IF MsgNoYes("No hay Respuesta PING del Servidor "+cIp,"Desea Conectarse con el Servidor Alternativo "+cIpB)

        MsgRun("Validando IP "+cIpB,"Por Favor Espere",{||cMemoP:=EJECUTAR("GETPING",cIpB) })

        IF !("TTL"$UPPER(cMemop))
           MsgMemo(cMemoP,"No hay Respuesta PING del Servidor "+cIpB)
           lConectaB:=.F.
        ELSE
           lConectaB:=.T.
        ENDIF

        IF lConectaB

          oDb:=DPMYSQLBD(oDp:cDsnConfig,cIpB,_MycLoging,_MycPass,_MySqlPort,lError,.F.,.F.,.F.)

          IF oDb=NIL

             MsgMemo("No fué Posible Conectarse con la Base de Datos "+cIpB,oDp:cDpSys+" Será Cerrado")
             SALIR()

           ELSE

             MsgMemo("Será utilizada la conexión con el Servidor "+cIpB+CRLF+"en sustitución del Servidor "+cIp," Conexión Exitosa con el Servidor Alterantivo")

             FERASE(cFileMem)
             COPY FILE (cFileMemB) TO (cFileMem)
             FERASE(cFileMemB) // ya no es necesario 
  
           ENDIF

        ENDIF

    ENDIF

  ENDIF

RETURN .T.
// EOF
