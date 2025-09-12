// Programa   : SPLITTER_OUTLOOK_BR1
// Fecha/Hora : 28/04/2023 21:46:52
// Propósito  : SPLITTER2
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

   local cTitle := "Testing the Splitter controls"
   local cText
   LOCAL aData  :=EJECUTAR("DBFVIEWARRAY","DATADBF\DPLINK.DBF",NIL,.F.)

   CLOSE ALL

   SELECT A
   USE DATADBF\DPREPORTES.DBF

   DEFINE FONT oFont    NAME "Tahoma" SIZE 0,-14

   DpMDI(cTitle,"oMdi","TESTSLPLITTER2.EDT",NIL)

   oMdi:nAltoBrw  :=100
   oMdi:nAnchoSpl1:=120

   oMdi:cText:=""
   oMdi:Windows(0,0,800,800,.T.) // Maximizado

   @ 100, 0 OUTLOOK oMdi:oOutL ;
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
   oMdi:oBrw2:Move(0,205+oMdi:nAnchoSpl1+5,.T.)
   oMdi:oBrw2:SetSize(300,200+oMdi:nAltoBrw)

   @ 200+oMdi:nAltoBrw,205+oMdi:nAnchoSpl1  SPLITTER oMdi:oSplit ;
              VERTICAL ;
              PREVIOUS CONTROLS oMdi:oOutL ;
              HINDS CONTROLS oMdi:oBrw2 ;
              LEFT MARGIN 100 ;
              RIGHT MARGIN 140 ;
              SIZE 4, 300 PIXEL ;
              OF oMdi:oWnd ;
              _3DLOOK ;
              UPDATE

  oMdi:oWnd:oClient := oMdi:oSplit

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

//   oMdi:oWnd:bResized:={||( oMdi:oSplit:AdjLeft(), ;
//                            oMdi:oSplit:AdjRight())}
//   Eval( oMdi:oWnd:bResized )

RETURN .T.

FUNCTION SPL_ACTION()
RETURN .T.

// EOF

