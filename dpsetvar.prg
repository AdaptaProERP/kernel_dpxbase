// Programa   : DPSETVAR	
// Fecha/Hora : 16/08/2020 09:40:40
// Propósito  : Asignación de Variables oDp:<cName> Desde el Arranque del Sistema
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL cFile:="DP\DPCONFIGSYS.INI"
   LOCAL oIni
   LOCAL aFiles:={}
   LOCAL cFileCli:="CLIENTE\CLIENTE.TXT"
   
   oDp:lConfig   :=.F. // no ha sido ejecutado DPLOADCNF
   oDp:cRecTrib  :="Recaudador Tributario"
   oDp:aLogico   :={} // DPLOADCNF debera evaluarlo si esta vacio lo recarga
   oDp:aCamposOpc:={}

   oDp:lDropAllView:=.F. // No debe remover todas las vista, solo en caso de ser solicitada directamente, su valor será redefinido en DPINI


   oDp:nGris       :=15724527
   oDp:nGris2      :=16774636  

   oDp:lMsgOff :=.F. // Apaga 
   oDp:cMsgFile:=""  // Archivo LOG contentivo de los mensajes
   oDp:oMemo   :=NIL


   IF FILE(cFile)

     INI oIni File (cFile)

     oDp:nGris :=oIni:Get( "Config", "nGris"  , oDp:nGris )
     oDp:nGris2:=oIni:Get( "Config", "nGris2" , oDp:nGris2)

   ENDIF

   IF FILE(cFileCli) .AND. !FILE("MYSQL.MEM")
      EJECUTAR("DPAPTGETCREDENCIALES") // Solicita Numero de la Licencia para obtener las credenciales desde el Servidor
   ENDIF

RETURN .T.
// EOF
