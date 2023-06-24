// Programa   : BOTBARCHANGE
// Fecha/Hora : 26/06/2003 17:55:06
// PropÑsito  : Ejecutar los Cambios en Botones de Barra y Cambios de AplicaciÑn
// Creado Por : Juan Navas
// Llamado por: DPBOTBAR
// AplicaciÑn : Todas
// Tabla      : DPBOTBAR

#INCLUDE "DPXBASE.CH"

PROCE MAIN()

   Local aBotBar :={}
   Local oFrameDp:=oDp:oFrameDp   // Ventana Princial
   Local oBar    :=oFrameDp:oBar  // Barra de Botones
   Local aBarSize:={}             // Parametros y Tamaªos de los Botones, VER DPINI
   Local oHand,i

   aBarSize:=VP("aBARSIZE")

   DEFAULT aBARSIZE:={40,40,.T.,"TOP"}

   oDp:aMenuMac:={}

   aBotBar:=CARGABOTBAR()
   // Borra los Controles Viejos
   //? oBar:aControls[2]:ClassName()

   WHILE LEN(oBar:aControls)>0
     // ASCAN(oBar:aControls,{|o,n|o:ClassName()="XBUTTON"})>0
     FOR i=1 to len(oBar:aControls)
       //  IF oBar:aControls[I]:ClassName()<>"TSAY"
            oBar:aControls[I]:End()
       //  ENDIF
     NEXT I
   ENDDO

   //EJECUTAR("CONFIGSYSLOAD")
   // Agrega los Nuevos Controles
   oBar:SetColor(NIL,oDp:nGris)
   oBar:Refresh(.T.)

   DPBOTBAR(oBar,oDp:cModulo,aBotBar,aBarSize[1],aBarSize[2])

//   oBar:SetColor(NIL,oDp:nGris)
//   AEVAL(oBar:aControls,{|o,n| o:SetColor(NIL,oDp:nGris)})

   oDp:oBarSay:=NIL

   EJECUTAR("DPBARMSG")

   DPXGETPROCE(.F.) // Desactiva Traza Ejecución DpXbase

   EJECUTAR("BTNBARFIND") // Agrega el Botón de Búsqueda.

   IF Empty(oDp:cSucNombre)
     oDp:oFrameDp:SetText(oDp:cDpSys+" ["+oDp:cEmpresa+"]")
   ELSE
     oDp:oFrameDp:SetText(oDp:cDpSys+" ["+ALLTRIM(oDp:cEmpresa)+"] / "+ALLTRIM(oDp:cSucNombre))
     oDp:oItem2:SetText(oDp:cSucursal)
   ENDIF


RETURN 
// EOF

