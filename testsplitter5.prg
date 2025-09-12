// Testing FiveWin splitter controls
// TESTSPLITTER6   
#include "DPXBASE.ch"


//----------------------------------------------------------------------------//

function Main()
   local oMenu
   local cTitle := "Testing the Splitter controls"
   local cInfo  := "Lee las indicaciones que he puesto al final de cada " + ;
                   "programa fuente." + CRLF + "R.Avendaño."

   MENU oMenu
        MENUITEM "&Splitters"
           MENU
               MENUITEM "&Info" ACTION MsgInfo(oMdi:cInfo)
               MENUITEM "&Exit" ACTION oMdi:oWnd:End()
           ENDMENU
   ENDMENU

  
   DpMDI(cTitle,"oMdi","TESTSLPLITTER5.EDT",NIL)

   oMdi:Windows(0,0,600,1000,.T.) // Maximizado

   oMdi:cInfo:=cInfo

   DEFINE BUTTONBAR oMdi:oBar SIZE 26,29 _3DLOOK TOP WINDOW oMdi:oWnd
   DEFINE BUTTON FILE "EXIT.BMP" TOOLTIP "Exit" ACTION oMdi:oWnd:End() BUTTONBAR oMdi:oBar 

// NOBORDER

   SET MESSAGE OF oMdi:oWnd TO cTitle KEYBOARD CLOCK DATE NOINSET

   @ 30,0 SAY oMdi:oSay PROMPT "Multiples splitters" SIZE 130,100 PIXEL COLOR CLR_YELLOW,CLR_GREEN BORDER OF oMdi:oWnd

   @ 135,0 BUTTON oMdi:oBtn PROMPT "&Splitters ok" SIZE 130, 95 PIXEL ACTION MsgInfo("Splitters FiveWin") OF oMdi:oWnd

   @ 236, 0 BITMAP oMdi:oBmp SIZE 130,94 PIXEL FILE "..\bitmaps\FIVEWIN.BMP" ADJUST OF oMdi:oWnd

   CLOSE ALL
   SELECT A
   USE DATADBF\DPREPORTES.DBF

   @ 30,135 LISTBOX oMdi:oLbx1 FIELDS SIZE 215,150 PIXEL OF oMdi:oWnd

   @ 30,355 GET oMdi:oGet1 VAR A->REP_FUENTE TEXT SIZE 230,149 PIXEL OF oMdi:oWnd

   oMdi:oLbx1:bChange:={|| oMdi:oGet1:Refresh() }

   SELECT B
   USE DATADBF\DPPROGRA.DBF

   @ 185,135 LISTBOX oMdi:oLbx2 FIELDS SIZE 245,145 PIXEL OF oMdi:oWnd

   @ 185,385 GET oMdi:oGet2 VAR B->PRG_TEXTO TEXT SIZE 200,144 PIXEL OF oMdi:oWnd

   oMdi:oLbx2:bChange:={|| oMdi:oGet2:Refresh() }

   @ 130,0  SPLITTER oMdi:oHSplit1 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oMdi:oSay ;
            HINDS CONTROLS oMdi:oBtn ;
            TOP MARGIN 80 ;
            BOTTOM MARGIN oMdi:oHSplit2:nLast + 50 ;
            SIZE 130, 4 PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK ;
            UPDATE

   @ 231,0  SPLITTER oMdi:oHSplit2 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oMdi:oBtn NO ADJUST ;
            HINDS CONTROLS oMdi:oBmp ;
            TOP MARGIN oMdi:oHSplit1:nFirst + 50 ;
            BOTTOM MARGIN 80 ;
            SIZE 130, 4 PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK ;
            UPDATE

  @ 30,350  SPLITTER oMdi:oVSplit1 ;
            VERTICAL ;
            PREVIOUS CONTROLS oMdi:oLbx1 ;
            HINDS CONTROLS oMdi:oGet1 ;
            LEFT MARGIN oMdi:oVSplit3:nFirst + 50 ;
            RIGHT MARGIN 80 ;
            SIZE 4, 150  PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK

  @ 185,380 SPLITTER oMdi:oVSplit2 ;
            VERTICAL ;
            PREVIOUS CONTROLS oMdi:oLbx2 ;
            HINDS CONTROLS oMdi:oGet2 ;
            LEFT MARGIN oMdi:oVSplit3:nFirst + 50 ;
            RIGHT MARGIN 80 ;
            SIZE 4, 145  PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK

  @ 180,135 SPLITTER oMdi:oHSplit3 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oMdi:oLbx1, oMdi:oVSplit1, oMdi:oGet1 ;
            HINDS CONTROLS oMdi:oLbx2, oMdi:oVSplit2, oMdi:oGet2 ;
            TOP MARGIN 80 ;
            BOTTOM MARGIN 80 ;
            SIZE 450, 4 PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK ;
            UPDATE

   @ 30,130 SPLITTER oMdi:oVSplit3 ;
            VERTICAL ;
            PREVIOUS CONTROLS oMdi:oSay, oMdi:oHSplit1, oMdi:oBtn, oMdi:oHSplit2, oMdi:oBmp ;
            HINDS CONTROLS oMdi:oLbx1, oMdi:oHSplit3, oMdi:oLbx2 ;
            LEFT MARGIN 80 ;
            RIGHT MARGIN MAX( oMdi:oVSplit1:nLast, oMdi:oVSplit2:nLast ) + 50 ;
            SIZE 4, 300  PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK


  oMdi:Activate({||nil})

  oMdi:oWnd:bResized:={|| oMdi:oVSplit3:AdjClient(), ;
                          oMdi:oHSplit3:AdjRight(), ;
                          oMdi:oHSplit1:Adjust( .t., .f., .t., .f. ), ;
                          oMdi:oHSplit2:Adjust( .f., .t., .t., .f. ), ;
                          oMdi:oVSplit1:Adjust( .t., .f., .f., .t. ), ;
                          oMdi:oVSplit2:Adjust( .f., .t., .f., .t. )  }

  EVAL(oMdi:oWnd:bResized)

return nil

//----------------------------------------------------------------------------//
/*
      En una combinación de splitters tan complicada como esta
      es necesario ir definiendo primero los que menos controles
      tienen y despues los que mas, acordandose de indicar
      como controles los splitters que parten de ellos.

      Para que los controles se autoajusten a la ventana y solo
      en los lados que se desea se debe utilizar el metodo:

         Adjust( lTop, lBottom, lLeft, lRight )

      Si se quiere dejar un splitter sin posibilidad de movimiento
      ni que su cursor cambie a dole fleha, simplemente poner el
      dato 'lStatic' a .t.

      Importante: Al utilizar una barra de botones si vamos situando
                  esta en distintos laterales de la ventana, los
                  splitters y sus controles se ajustan perfectamente,
                  pero si no se pintan bien es debido a un bug en
                  la clase TBar.
                  Yo lo soluciono ocultando los controles, moviendo
                  la barra y volviendo a mostrarlos, con los
                  metodos Hide y Show.
                                                                              */
