// Programa   : 
// Fecha/Hora : 20/04/2023 20:34:26
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   local oPanel1, oPanel2, oPanel3, oPanel4
   local nLeftPos   := 200
   local nRightPos  := oDp:aCoors[3]-160 // ScreenWidth() - 200
   local nMiddlePos := oDp:aCoors[4]-200 // ScreenHeight() - 200 
   LOCAL oMemu

   DpMdi("Splitters H layout","oMdi",,,oMenu)
   oMdi:Windows(0,0,600,1010,.T.) // Maximizado

   oMdi:oVSplitL:=NIL
   oMdi:oHSplitC:=NIL
   oMdi:oVSplitR:=NIL

   oMdi:oPanel1 = TPanel():New( 0, 0, oMdi:oWnd:nHeight, nLeftPos - 5, oMdi:oWnd )

     
   oMdi:oPanel2 = TPanel():New( 0, nLeftPos + 1, nMiddlePos - 1, nRightPos - 1,oMdi:oWnd )
   oMdi:oPanel3 = TPanel():New( nMiddlePos + 4, nLeftPos + 1, oMdi:oWnd:nHeight, nRightPos - 1, oMdi:oWnd )
   oMdi:oPanel4 = TPanel():New( 0, nRightPos + 5, oMdi:oWnd:nHeight, oMdi:oWnd:nWidth, oMdi:oWnd )


   @ 50,100 BITMAP oMdi:oImage1 FILENAME "bitmaps_textil\chemisse_Espalda.bmp" PIXEL;
           SIZE 150,170 OF oMdi:oPanel4 DESIGN

   oMdi:oImage1:bRClicked:={|| MsgMemo("coloque aqui las características Espalda")}
   oMdi:oImage1:lDesign  :=.t.

   @ 50,50 BITMAP oMdi:oImage2 FILENAME "bitmaps_textil\chemisse_manga.bmp" PIXEL;
           SIZE 50,50 OF oMdi:oPanel4 DESIGN

   oMdi:oImage2:bRClicked:={|| MsgMemo("coloque aqui las características de la Manga Izquierda")}
   oMdi:oImage2:lDesign  :=.t.

   @ 50,240 BITMAP oMdi:oImage3 FILENAME "bitmaps_textil\chemisse_manga.bmp" PIXEL;
           SIZE 50,50 OF oMdi:oPanel4 DESIGN

   oMdi:oImage3:bRClicked:={|| MsgMemo("coloque aqui las características de la Manga Derecha")}
   oMdi:oImage3:lDesign  :=.t.


   // Frontal


   @ 50,100 BITMAP oMdi:oImageA FILENAME "bitmaps_textil\chemisse_Espalda.bmp" PIXEL;
           SIZE 150,170 OF oMdi:oPanel2 DESIGN

   oMdi:oImageA:bRClicked:={|| MsgMemo("coloque aqui las características Espalda")}
   oMdi:oImageA:lDesign  :=.t.

   @ 50,50 BITMAP oMdi:oImageB FILENAME "bitmaps_textil\chemisse_manga.bmp" PIXEL;
           SIZE 50,50 OF oMdi:oPanel2 DESIGN

   oMdi:oImageB:bRClicked:={|| MsgMemo("coloque aqui las características de la Manga Izquierda")}
   oMdi:oImageB:lDesign  :=.t.

   @ 50,240 BITMAP oMdi:oImageC FILENAME "bitmaps_textil\chemisse_manga.bmp" PIXEL;
           SIZE 50,50 OF oMdi:oPanel2 DESIGN

   oMdi:oImageC:bRClicked:={|| MsgMemo("coloque aqui las características de la Manga Derecha")}
   oMdi:oImageC:lDesign  :=.t.


   oMdi:oPanel1:SetColor( 0,16771797) // "W/R" )
   oMdi:oPanel2:SetColor( 0,oDp:nGris2) // "W/G" )
   oMdi:oPanel3:SetColor( 0,65535 ) // "W/B" )
   oMdi:oPanel4:SetColor( 0, 33023) // "W/BG" )
   
   oMdi:oPanel1:bLClicked = { || MsgInfo( "Panel1" ) }
   oMdi:oPanel2:bLClicked = { || MsgInfo( "Panel2" ) }
   oMdi:oPanel3:bLClicked = { || MsgInfo( "Panel3" ) }
   oMdi:oPanel4:bLClicked = { || MsgInfo( "Panel4" ) }

   @ nMiddlePos, nLeftPos + 1 SPLITTER oMdi:oHSplitC ;
              HORIZONTAL ;
              PREVIOUS CONTROLS oMdi:oVSplitL, oMdi:oPanel2 ;
              HINDS CONTROLS oMdi:oPanel3, oMdi:oVSplitR ;
              TOP MARGIN 80 ;
              BOTTOM MARGIN 80 ;
              SIZE nRightPos - nLeftPos - 2, 4 PIXEL ;
              OF oMdi:oWnd ;
              STYLE

   @  0, nLeftPos - 5 SPLITTER oMdi:oVSplitL ;
              VERTICAL ;
              PREVIOUS CONTROLS oMdi:oPanel1 ; 
              HINDS CONTROLS oMdi:oPanel2, oMdi:oHSplitC, oMdi:oPanel3 ;
              LEFT MARGIN 80 ;
              RIGHT MARGIN 80 ;
              SIZE 4, oDp:aCoors[4]-200 PIXEL ;
              OF oMdi:oWnd ;
              STYLE

   @  0, nRightPos SPLITTER oMdi:oVSplitR ;
             VERTICAL ;
             PREVIOUS CONTROLS oMdi:oPanel2, oMdi:oHSplitC, oMdi:oPanel3 ;
             HINDS CONTROLS oMdi:oPanel4 ;
             LEFT MARGIN 80 ;
             RIGHT MARGIN 80 ;
             SIZE 4, oDp:aCoors[3] PIXEL ;
             OF oMdi:oWnd ;
             STYLE

   oMdi:Activate()

   oMdi:oImage1:lDesign  :=.t.


   oMdi:oWnd:bResized:={||oMdi:oVSplitL:AdjLeft(), oMdi:oVSplitR:Adjust(),;
                          oMdi:oPanel3:nHeight := oMdi:oWnd:nHeight - oMdi:oHSplitC:nBottom}


RETURN NIL
// EOF
