// Testing FiveWin splitter controls

#include "DPXBASE.ch"
#include "Splitter.ch"

FUNCTION Main()
   LOCAL cTitle:="Testing the Splitter controls"

   DpMDI(cTitle,"oMdi","TESTSLPLITTER6.EDT",NIL)

   oMdi:Windows(0,0,600,1000,.T.) // Maximizado

   oMdi:cInfo:="Lee las indicaciones que he puesto al final de cada " + ;
                "programa fuente." + CRLF + "R.Avenda±o."

   oMdi:oMenu:=NIL
   oMdi:oBmp :=NIL
   oMdi:oSay1:=NIL
   oMdi:oSay2:=NIL
   oMdi:oSay3:=NIL
   oMdi:oSay4:=NIL
   oMdi:oCursorHand:=NIL


   oMdi:oVSplit1:=NIL
   oMdi:oVSplit2:=NIL
   oMdi:oHSplit1:=NIL
   oMdi:oHSplit2:=NIL

   @ 0,0     SAY oMdi:oSay1 PROMPT "Control 1" SIZE 100,205 PIXEL BORDER COLOR CLR_WHITE, CLR_BLUE   OF oMdi:oWnd
   @ 0,105   SAY oMdi:oSay2 PROMPT "Control 2" SIZE 205,100 PIXEL BORDER COLOR CLR_WHITE, CLR_RED    OF oMdi:oWnd
   @ 210,0   SAY oMdi:oSay3 PROMPT "Control 3" SIZE 205,100 PIXEL BORDER COLOR CLR_BLACK, CLR_YELLOW OF oMdi:oWnd
   @ 105,210 SAY oMdi:oSay4 PROMPT "Control 4" SIZE 100,205 PIXEL BORDER COLOR CLR_WHITE, CLR_GREEN  OF oMdi:oWnd

   @ 105,105 BITMAP oMdi:oBmp SIZE 100,100 PIXEL FILE "BITMAPS\LOGO.BMP" ADJUST OF oMdi:oWnd


   @ 205,0  SPLITTER oMdi:oHSplit1 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oMdi:oSay1, oMdi:oVSplit2, oMdi:oBmp ;
            HINDS CONTROLS oMdi:oSay3 ;
            TOP MARGIN oHSplit2:nFirst + oHSplit2:nWidth + 1 ;
            BOTTOM MARGIN 10 ;
            SIZE 205, 4 PIXEL ;
            OF oMdi:oWnd ;
            COLOR CLR_RED

  @ 105,205 SPLITTER oMdi:oVSplit1 ;
            VERTICAL ;
            PREVIOUS CONTROLS oMdi:oSay3, oMdi:oHSplit1, oMdi:oBmp ;
            HINDS CONTROLS oMdi:oSay4 ;
            LEFT MARGIN oMdi:oVSplit2:nFirst + oMdi:oVSplit2:nWidth + 1 ;
            RIGHT MARGIN 10 ;
            SIZE 4, 205  PIXEL ;
            OF oMdi:oWnd ;
            COLOR CLR_BLUE

  @ 100,105 SPLITTER oMdi:oHSplit2 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oMdi:oSay2 ;
            HINDS CONTROLS oMdi:oSay4, oMdi:oVSplit1, oMdi:oBmp ;
            TOP MARGIN 10 ;
            BOTTOM MARGIN oMdi:oHSplit1:nLast + oMdi:oHSplit1:nWidth + 1 ;
            SIZE 205, 4 PIXEL ;
            OF oMdi:oWnd ;
            COLOR CLR_YELLOW

  @ 0,100  SPLITTER oMdi:oVSplit2 ;
            VERTICAL ;
            PREVIOUS CONTROLS oMdi:oSay1 ;
            HINDS CONTROLS oMdi:oSay2, oMdi:oHSplit2, oMdi:oBmp ;
            LEFT MARGIN 10 ;
            RIGHT MARGIN oMdi:oVSplit1:nLast + oMdi:oVSplit1:nWidth + 1 ;
            SIZE 4, 205  PIXEL ;
            OF oMdi:oWnd ;
            COLOR CLR_GREEN

  oMdi:oHSplit1:aPrevCtrols := { oMdi:oSay1, oMdi:oVSplit2, oMdi:oBmp }

 /* esta asignaci¾n es necesaria por que cuando se definio oHSplit1
     oVSplit2 no estaba definido aun.                                
 */

  oMdi:Activate({|| oMdi:INICIO()})

/*
  ACTIVATE WINDOW oWndChild ;
     ON RESIZE ( oHSplit1:AdjLeft(), ;
                 oVSplit1:AdjBottom(), ;
                 oHSplit2:AdjRight(), ;
                 oVSplit2:AdjTop() ) ;
     ON INIT Eval( oWndChild:bResized )
*/
return nil

FUNCTION INICIO()

   oMdi:oWnd:bResized:={||( oMdi:oHSplit1:AdjLeft(), ;
                            oMdi:oVSplit1:AdjBottom(), ;
                            oMdi:oHSplit2:AdjRight(), ;
                            oMdi:oVSplit2:AdjTop() ) }


   Eval( oMdi:oWnd:bResized )


RETURN .T.

//----------------------------------------------------------------------------//

function DlgCreate()

  local oDlg

  local oLbx, oGet

  local oSplit

  DEFINE DIALOG oDlg SIZE 400, 300 WINDOW oWnd ;
         TITLE "Dialog Splitter"

  SELECT 1
  USE EJEMPLO1.DBF

  @ 5,5 LISTBOX oLbx FIELDS SIZE 80,120 PIXEL OF oDlg

  @ 5,90 GET oGet VAR EJEMPLO1->SINTAX TEXT SIZE 102,119 PIXEL OF oDlg

  oLbx:bChange:={|| oGet:Refresh() }

  @ 5, 85  SPLITTER oSplit ;
           VERTICAL ;
           PREVIOUS CONTROLS oLbx ;
           HINDS CONTROLS oGet ;
           LEFT MARGIN 100 ;
           RIGHT MARGIN 120 ;
           SIZE 4, 120  PIXEL ;
           OF oDlg ;
           _3DLOOK

 @ 130,80 BUTTON "&Cerrar" SIZE 42,11 PIXEL ACTION oDlg:End() OF oDlg

 ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//

function DlgResource()

  local oDlg

  local oGet1, oGet2, oGet3

  local oSplit

  local cVar1:=SPACE(255), cVar2:=SPACE(255), cVar3:=SPACE(255)

  DEFINE DIALOG oDlg RESOURCE "TEST_SPLITTER" OF oWnd

  REDEFINE GET oGet1 VAR cVar1 TEXT ID 101 OF oDlg
  REDEFINE GET oGet2 VAR cVar2 TEXT ID 103 OF oDlg
  REDEFINE GET oGet3 VAR cVar3 TEXT ID 104 OF oDlg

  REDEFINE SPLITTER oSplit ID 102 ;
           HORIZONTAL ;
           PREVIOUS CONTROLS oGet1 ;
           HINDS CONTROLS oGet2, oGet3 ;
           TOP MARGIN 20 ;
           BOTTOM MARGIN 60 ;
           OF oDlg ;
           ON CHANGE MsgBeep() ;
           _3DLOOK

  REDEFINE BUTTON ID 201 OF oDlg ACTION oSplit:SetPosition(39)
  REDEFINE BUTTON ID 202 OF oDlg ACTION oSplit:SetPosition(82)
  REDEFINE BUTTON ID 203 OF oDlg ACTION oSplit:SetPosition(124)

  REDEFINE BUTTON ID 1 OF oDlg ACTION oDlg:End()

  ACTIVATE DIALOG oDlg

return nil

