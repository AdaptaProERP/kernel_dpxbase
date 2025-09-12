// Programa   : TESTSPLITTER1
// Fecha/Hora : 28/04/2023 21:46:52
// Propósito  : SPLITTER2
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()

   local cTitle := "Testing the Splitter controls"
   local cText

   CLOSE ALL

   SELECT A
   USE DATADBF\DPREPORTES.DBF

   DpMDI(cTitle,"oMdi","TESTSLPLITTER2.EDT",NIL)

   oMdi:cText:=""
   oMdi:Windows(0,0,800,800,.T.) // Maximizado

   @ 20,20 LISTBOX oMdi:oLbx FIELDS SIZE 200,300 PIXEL OF oMdi:oWnd ;
           ON CHANGE oMdi:cText := A->REP_FUENTE

   @ 20,225 GET oMdi:oGet VAR oMdi:cText TEXT SIZE 300,300 PIXEL OF oMdi:oWnd

   oMdi:oLbx:bChange:={|| oMdi:cText := A->REP_FUENTE,oMdi:oGet:Refresh() }

   @ 20, 220  SPLITTER oMdi:oSplit ;
              VERTICAL ;
              PREVIOUS CONTROLS oMdi:oLbx ;
              HINDS CONTROLS oMdi:oGet ;
              LEFT MARGIN 100 ;
              RIGHT MARGIN 140 ;
              SIZE 4, 300  PIXEL ;
              OF oMdi:oWnd ;
              _3DLOOK ;
              UPDATE

  oMdi:oWnd:oClient := oMdi:oSplit

  oMdi:Activate({||oMdi:INICIO()})

RETURN .T.
FUNCTION INICIO()

//  oMdi:oWnd:bResized:={|| oMdi:oSplit:AdjClient() }
//  Eval( oMdi:oWnd:bResized )

RETURN
