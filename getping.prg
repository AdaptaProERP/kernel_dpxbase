// Programa   : GETPING
// Fecha/Hora : 23/06/2023 06:05:49
// Propósito  : Obtiene los datos del ping.exe
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cUrl,lSay)
   LOCAL cFileBat:="RUNPING.BAT"
   LOCAL cMemo   :="TEMP\PING"+LSTR(SECONDS())+".TXT"

   DEFAULT cUrl:="adaptaproyectoserp.com.veX",;
           lSay:=.F.

   DPWRITE(cFileBat,"PING "+cUrl+" > "+cMemo)

   IF lSay
      MsgRun("Validando Ping "+cUrl,"Por Favor Espere",{||WAITRUN(cFileBat,0)})
   ELSE
      WAITRUN(cFileBat,0)
   ENDIF

   cMemo:=ALLTRIM(MEMOREAD(cMemo))

//  ? cFileBat,MemoRead(cMemo)

RETURN cMemo
// EOF
