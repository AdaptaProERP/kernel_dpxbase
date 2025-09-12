// Programa   : TESTSPLITTER4
// Fecha/Hora : 28/04/2023 04:51:13
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL cTitle := "Testing the Splitter controls"
   LOCAL cInfo  := "Lee las indicaciones que he puesto al final de cada " + ;
                   "programa fuente." + CRLF + "R.Avendaño."
   LOCAL oMenu

   MENU oMenu
        MENUITEM "&Splitters"
           MENU
               MENUITEM "&Info" ACTION oMdi:MsgInfo(cInfo)
               MENUITEM "&Exit" ACTION oWnd:End()
           ENDMENU
   ENDMENU


   CLOSE ALL
   SELECT A
   USE DATADBF\DPREPORTES.DBF

   DpMdi("cTitle","oMdi",,,oMenu)
   oMdi:Windows(0,0,600,1010,.T.) // Maximizado
   oMdi:cInfo:=cInfo

   oMdi:oSplit1:=NIL
   oMdi:oSplit2:=NIL

   SET MESSAGE OF oMdi:oWnd TO cTitle KEYBOARD CLOCK DATE NOINSET

   @ 0,0 LISTBOX oMdi:oLbx FIELDS SIZE 200,300 PIXEL OF oMdi:oWnd

   @ 0,205 GET oMdi:oGet1 VAR A->REP_FUENTE TEXT SIZE 145,300 PIXEL OF oMdi:oWnd

   @ 0,356 GET oMdi:oGet2 VAR A->REP_PARAM TEXT SIZE 150,300 PIXEL OF oMdi:oWnd

   oMdi:oLbx:bChange:={|| oMdi:oGet1:Refresh(), oMdi:oGet2:Refresh() }

   @ 0,200   SPLITTER oMdi:oSplit1 ;
             VERTICAL ;
             PREVIOUS CONTROLS oMdi:oLbx ;
             HINDS CONTROLS oMdi:oGet1 ;
             LEFT MARGIN 80 ;
             RIGHT MARGIN oMdi:oSplit2:nLast+80 ;
             SIZE 4, 300  PIXEL ;
             OF oMdi:oWnd ;
             _3DLOOK

   @ 0,351   SPLITTER oMdi:oSplit2 ;
             VERTICAL ;
             PREVIOUS CONTROLS oMdi:oGet1 ;
             HINDS CONTROLS oMdi:oGet2 ;
             LEFT MARGIN oMdi:oSplit1:nFirst+80 ;
             RIGHT MARGIN 80 ;
             SIZE 4, 300  PIXEL ;
             OF oMdi:oWnd ;
             _3DLOOK

  oMdi:Activate() 

  oMdi:oWnd:bResized:={||( oMdi:oSplit1:AdjLeft(), ;
                           oMdi:oSplit2:AdjRight())}

  EVAL(oMdi:oWnd:bResized)

RETURN NIL

//----------------------------------------------------------------------------//
/*
      En este ejemplo de spritters paralelos es necesario evitar que
      se monten uno sobre el otro mediante las clausulas MARGIN y
      sabiendo que la clase TSplitter proporciona los Datos:
          nFirst
          nLast
      que son las distancias en pixel que hay en ese momento desde
      el splitter a los bordes de la ventana.

      Y tambien los Datos:
          nLong
          nWidth
      que son el largo y el grosor del splitter.


      Por ejemplo en un splitter vertical 'oSplit':

        +-----------------------------------------------------------+
        |                                                           |
        +-----------------------------------------------------------+
        |                   ||                                      |
        |                   ||                                      |
        |                   ||                                      |
        |                   ||                                      |
        |   oSplit:nFirst   ||             oSplit:nLast             |
        |<----------------->||<------------------------------------>|
        |                   ||                                      |
        |                   ||                                      |
        |                   ||                                      |
        |                   ||                                      |
        |                  >||< oSplit:nWidth                       |
        |                   ||                                      |
        |                   ||                                      |
        |                   ||                                      |
        |                   ||                                      |
        +-----------------------------------------------------------+

     ( ojo que nWidth es el grosor y nLong el largo ya sea splitter
      Vertical u Orizontal )

     Por lo tanto el Margen del espliter nunca a de ser menor
     que:

        'oPSplit:nFirst + oPSplit:nWidth + 1' del splitter 'oPSplit'
         paralelo por la izquierda o por arriba.

      ó

        'oPSplit:nLast + oPSplit:nWidth + 1' del splitter 'oPSplit'
         paralelo por la derecha o por abajo.

     Como clase esplitter guarda estas dimensiones como Codeblocks
     se pueden referenciar a objetos spritters que a un no se han creado.

                                                                              */
RETURN
