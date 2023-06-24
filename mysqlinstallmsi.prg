// Programa   : MYSQLINSTALLMSI
// Fecha/Hora : 12/05/2019 01:09:43
// Propósito  : Ejecutar Instalación de MySql 
// Creado Por : Juan Navas
// Llamado por: MYSQL.MEM
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
 LOCAL cDir  :=Lower(cFilePath(GetModuleFileName( GetInstance() )))+"mysqlinstall\"
 LOCAL aFiles:=DIRECTORY(cDir+"*.MSI")
 LOCAL cFile
 // LOCAL cUrl  :="https://cdn.mysql.com//Downloads/MySQL-5.5/mysql-5.5.62-win32.msi"  Sin acceso por bloqueo Venezuela
 LOCAL cUrl  :="http://191.96.151.60/~ftp16402/descargas/terceros/mysql-5.5.62-win32.msi"
 LOCAL cIpD  :="191.96.151.60"  // Ip del Servidor AdaptaPro
 LOCAL cMemoP:="" // Respuesta del PING

 cDir :=Lower(cFilePath(GetModuleFileName( GetInstance() )))+"mysqlinstall\"

 DEFAULT oDp:oFrameDp:=NIL

 IF oDp:cIp<>"127.0.0.1" .AND. !Empty(oDp:cIp)
    RETURN .T.
 ENDIF

 lMkDir(cDir)

 // Debe Descargar el Instalador de MySql
 IF Empty(aFiles)

    MsgRun("Validando IP "+cIpD,"Por Favor Espere",{||cMemoP:=EJECUTAR("GETPING",cIpD) })

    IF !("TTL"$UPPER(cMemop))
      MsgMemo(cMemoP,"No fué posible Validar Conexión con "+cIpD)
      RETURN .F.
    ENDIF

    IF !MsgNoYes(cUrl+" en "+cDir,"Desea Descargar MySQL")
       RETURN .F.
    ENDIF

    MsgRun(cUrl,"Descargando Instalador de MySql,Por Favor Espere",{||URLDownLoad(cUrl,cDir+"mysql-5.5.62-win32.msi")})

    SysRefresh(.T.)
    aFiles:=DIRECTORY(cDir+"*.MSI")

 ENDIF

 IF Empty(aFiles)
    RETURN .F.
 ENDIF

// ASORT(aFiles,,, { |x, y| a[3]<a[3] })
 cFile:=cDir+aFiles[1,1]

 IF !MsgNoYes("Programa "+cFile,"Ejecutar Instalador de MySQL")
    RETURN .F.
 ENDIF

 IF oDp:oFrameDp=NIL 
   SHELLEXECUTE(NIL,"open",cFile)
 ELSE
   SHELLEXECUTE(oDp:oFrameDp:hWND,"open",cFile)
 ENDIF

RETURN .T.
// EOF

