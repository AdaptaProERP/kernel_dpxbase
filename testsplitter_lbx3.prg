// Programa   : TESTSPLITTER_LBX3       
// Fecha/Hora : 20/04/2023 19:52:04
// Propósito  : TESTSPLITTER_LBX3
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL oMenu
   LOCAL cTitle := "Testing the Splitter controls"
   LOCAL cInfo  := "Lee las indicaciones que he puesto al final de cada " + ;
                   "programa fuente." + CRLF + "AdaptaPro"

   CLOSE ALL

   MENU oMenu
        MENUITEM "&Splitters"
           MENU
               MENUITEM "&Info" ACTION MsgInfo(oMdi:cInfo)
               MENUITEM "&Exit" ACTION oMdi:oWnd:End()
           ENDMENU
   ENDMENU

   DpMdi("cTitle","oMdi",,,oMenu)
   oMdi:Windows(0,0,600,1010,.T.) // Maximizado
   oMdi:cInfo:=cInfo


   SELECT 1
   USE DATADBF\DPMENU.DBF

   @ 0,0 LISTBOX oMdi:oLbx1 FIELDS SIZE 200,355 PIXEL OF oMdi:oWnd

   SELECT B
   USE DATADBF\DPPROGRA.DBF 

   @ 0,205 LISTBOX oMdi:oLbx2 FIELDS SIZE 300,200 PIXEL OF oMdi:oWnd

   @ 205,205 GET oMdi:oGet VAR B->PRG_TEXTO TEXT SIZE 300,150 PIXEL OF oMdi:oWnd

   oMdi:oLbx2:bChange:={|| oMdi:oGet:Refresh() }

   @ 200,205 SPLITTER oMdi:oHSplit ;
             HORIZONTAL ;
             PREVIOUS CONTROLS oMdi:oLbx2 ;
             HINDS CONTROLS oMdi:oGet ;
             TOP MARGIN 80 ;
             BOTTOM MARGIN 80 ;
             SIZE 300, 4  PIXEL ;
             OF oMdi:oWnd ;
             _3DLOOK

   @ 0,200   SPLITTER oMdi:oVSplit ;
             VERTICAL ;
             PREVIOUS CONTROLS oMdi:oLbx1 ;
             HINDS CONTROLS oMdi:oLbx2, oMdi:oHSplit, oMdi:oGet ;
             LEFT MARGIN 80 ;
             RIGHT MARGIN 80 ;
             SIZE 4, 355  PIXEL ;
             OF oMdi:oWnd ;
             _3DLOOK

   oMdi:Activate({||oMdi:INICIO()})

RETURN .T.

FUNCTION INICIO()
   LOCAL oCursor,oBar,oFont,oBtn

   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oMdi:oBar SIZE 45,45 OF oMdi:oWnd 3D CURSOR oCursor

   DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -10 BOLD

   DEFINE BUTTON oBtn;
          OF oMdi:oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XSALIR.BMP";
          ACTION oMdi:Close()

   oBtn:cToolTip:="Consultar Vinculos"


   oMdi:oWnd:bResized:={||( oMdi:oVSplit:AdjLeft(), ;
                            oMdi:oHSplit:AdjRight())}

   Eval( oMdi:oWnd:bResized )

RETURN .T.

//----------------------------------------------------------------------------//
/*
      Para acotar el desplazamiento máximo que puede tener un Splitter
      se utilizán las clausulas:

             [ TOP, LEFT ] MARGIN  nPixels

      que deja un mínimo de nPixels desde el borde superior o izquierdo
      de la ventana hasta el splitter ya sea Horizontal o Vertical
      reepectivamente.

             [ BOTTOM, RIGHT ] MARGIN  nPixels ;

      que deja un mínimo de nPixels desde el borde inferior o derecho
      de la ventana hasta el splitter ya sea Horizontal o Vertical
      reepectivamente.

      Es importante destacar que he hecho que la clase esplitter guarde
      estas dimensiones como Codeblocks, para poder referenciar en estas
      clausular a objetos spritters que a un no se han creado (esto será
      muy importante para no dejar que se monten dos spritters paralelos,
      ver el ejemplo TextSpl4.prg).
                                                                              */
RETURN
