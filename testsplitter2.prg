// Programa   : TESTSPLITTER2
// Fecha/Hora : 28/04/2023 04:38:38
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   local cTitle := "Testing the Splitter controls"

   CLOSE ALL

   SELECT A
   USE DATADBF\DPREPORTES.DBF

   DpMDI(cTitle,"oMdi","TESTSLPLITTER2.EDT",NIL)

   oMdi:Windows(0,0,600,800,.T.) // Maximizado

   @ 0,0 LISTBOX oMdi:oLbx FIELDS SIZE 500,200 PIXEL OF oMdi:oWnd

   @ 205,0 GET oMdi:oGet VAR A->REP_PARAM TEXT SIZE 500,150 PIXEL OF oMdi:oWnd

   oMdi:oLbx:bChange:={|| oMdi:oGet:Refresh() }

   @ 200,0  SPLITTER oMdi:oSplit ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oMdi:oLbx ;
            HINDS CONTROLS oMdi:oGet ;
            TOP MARGIN 80 ;
            BOTTOM MARGIN 80 ;
            SIZE 500, 4  PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK

  oMdi:Activate({|| oMdi:INICIO()})

RETURN NIL

FUNCTION INICIO()

   oMdi:oWnd:bResized:={|| oMdi:oSplit:AdjClient() }

   Eval( oMdi:oWnd:bResized )

RETURN .T.


//----------------------------------------------------------------------------//
/*
      Con uno o varios de los method de la clase TSplitter:
             AdjClient()
             AdjTop()
             AdjLeft()
             AdjBottom()
             AdjRight()
      colocados en oWnd:bResized se consigue un ajuste automatico
      del Splitter o Splitters y de los Controles que tienen asociados,
      al cambiar el tamaño de la ventana.

      Estos metodos se llaman y funcionan de manera similar a los
      de la clase TControl, pero los he reescrito de nuevo.

      Pero si quisieramos hacer un ajuste a nuestra medida, podemos
      utilizar la clausula ON CHANGE que genera un codeblock que
      se ejecuta cada vez que cambiamos de posición el splitter.
                                                                              */
RETURN
