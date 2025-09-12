// Programa   : SPLITTER_OUTLOOK_BR2
// Fecha/Hora : 20/04/2023 19:52:04
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL oMenu,oFont,oBtn
   LOCAL aBtn   :={}
   LOCAL bAction:=nil
   LOCAL nAdd   :=0,I,nGroup:=0
   LOCAL cTitle := "Testing the Splitter controls"
   LOCAL aData  :=EJECUTAR("DBFVIEWARRAY","DATADBF\DPLINK.DBF",NIL,.F.)
   LOCAL aMenu  :=EJECUTAR("DBFVIEWARRAY","DATADBF\DPMENU.DBF",NIL,.F.)
   LOCAL aBotBar:=EJECUTAR("DBFVIEWARRAY","DATADBF\DPBOTBAR.DBF",NIL,.F.)
 
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

   DEFINE FONT oFont    NAME "Tahoma" SIZE 0,-14

   DpMdi("cTitle","oMdi","SPLITER3.EDT",,oMenu)
   oMdi:Windows(0,0,600,1010,.T.) // Maximizado
   oMdi:cInfo:=cInfo

   oMdi:nAltoBrw  :=100
   oMdi:nAnchoSpl1:=120

   @ 48+40-10+20+15, -1 OUTLOOK oMdi:oOutL ;
     SIZE 200+oMdi:nAnchoSpl1,355;
     PIXEL ;
     FONT oFont ;
     OF oMdi:oWnd;
     COLOR CLR_BLACK,oDp:nGris

   DEFINE GROUP OF OUTLOOK oMdi:oOutL PROMPT "&Opciones "

   AADD(aBtn,{"Uno"  ,"UPLOAD.BMP"    ,"UPLOAD"   }) 
   AADD(aBtn,{"Dos"  ,"DOWNLOAD.BMP"  ,"DOWNLOAD" }) 

   FOR I=1 TO LEN(aBtn)

      DEFINE BITMAP OF OUTLOOK oMdi:oOutL ;
             BITMAP "BITMAPS\"+aBtn[I,2];
             PROMPT aBtn[I,1];
             ACTION 1=1

      nGroup:=LEN(oMdi:oOutL:aGroup)
      oBtn:=ATAIL(oMdi:oOutL:aGroup[ nGroup, 2 ])

      bAction:=BloqueCod("oMdi:SPL_ACTION(["+aBtn[I,3]+"],["+aBtn[I,1]+"])")

      oBtn:bAction:=bAction

      oBtn:=ATAIL(oMdi:oOutL:aGroup[ nGroup, 3 ])
      oBtn:bLButtonUp:=bAction


   NEXT I

   oMdi:oBrw2:=TXBrowse():New(oMdi:oWnd)
   oMdi:oBrw2:SetArray( aData, .F. )
   oMdi:oBrw2:CreateFromCode()
   oMdi:oBrw2:Move(0,205+oMdi:nAnchoSpl1,.T.)
   oMdi:oBrw2:SetSize(300,200+oMdi:nAltoBrw)

   oMdi:oBrw3:=TXBrowse():New(oMdi:oWnd)
   oMdi:oBrw3:SetArray( aBotBar, .F. )
   oMdi:oBrw3:CreateFromCode()
   oMdi:oBrw3:Move(205+oMdi:nAltoBrw,205+oMdi:nAnchoSpl1,.T.)
   oMdi:oBrw3:SetSize(300,150,.T.)

   @ 200+oMdi:nAltoBrw,205+oMdi:nAnchoSpl1 SPLITTER oMdi:oHSplit ;
             HORIZONTAL ;
             PREVIOUS CONTROLS oMdi:oBrw2 ;
             HINDS CONTROLS oMdi:oBrw3 ;
             TOP MARGIN 80 ;
             BOTTOM MARGIN 80 ;
             SIZE 300, 4  PIXEL ;
             OF oMdi:oWnd ;
             _3DLOOK

   @ 0,200+oMdi:nAnchoSpl1   SPLITTER oMdi:oVSplit ;
             VERTICAL ;
             PREVIOUS CONTROLS oMdi:oOutL ;
             HINDS CONTROLS oMdi:oBrw2, oMdi:oHSplit, oMdi:oBrw3 ;
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

   oMdi:oBar:SetColor(0,oDp:nGris)

   AEVAL(oMdi:oBar:aControls,{|o,n| o:SetColor(0,oDp:nGris)})

   oMdi:oBar:SetSize(NIL,100,.T.)

   oMdi:oWnd:bResized:={||( oMdi:oVSplit:AdjLeft(), ;
                            oMdi:oHSplit:AdjRight())}

   Eval( oMdi:oWnd:bResized )

RETURN .T.

FUNCTION SPL_ACTION()
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

