// Programa   : BRWGOTFOCUS
// Fecha/Hora : 07/11/2016 16:34:46
// Propósito  : Recupera Posicion del Browse
// Creado Por : Juan Navas
// Llamado por: TDPEDIT/GOTFOCUS
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oBrw,oMdi)
   LOCAL nAt,I,oFont,I

   IF oBrw=NIL 
      RETURN .F.
   ENDIF

   IF oMdi=NIL
      oMdi:=oBrw:oLbx
   ENDIF

   IF ValType(oMdi)="O" .AND. ValType(oMdi:oBar)="O"

      IF __objHasMsg(oMdi, "oFontBtn")

         oFont:=oMdi:oFontBtn

      ENDIF

      IF oFont=NIL

         DEFINE FONT oFont   NAME "Tahoma"   SIZE 0, -10 BOLD

      ENDIF

      IF __objHasMsg(oMdi,"nClrPaneBar")

         oMdi:oBar:SetColor(CLR_BLACK,oMdi:nClrPaneBar)

      ELSE

         oMdi:oBar:SetColor(CLR_BLACK,oDp:nGris)

      ENDIF

      oMdi:oBar:Refresh(.T.)

      FOR I=1 TO LEN(oMdi:oBar:aControls)

         IF "BTN"$oMdi:oBar:aControls[I]:ClassName()
            oMdi:oBar:aControls[I]:SetFont(oFont)
            oMdi:oBar:aControls[I]:ForWhen(.T.)
         ENDIF

      NEXT I

      // AEVAL(oMdi:oBar:aControls,{|oBtn,n| IF("BTN"$oBtn:ClassName(),(oBtn:SetFont(oFont),oBtn:ForWhen(.T.)),NIL)})

   ENDIF

   nAt :=oBrw:nEditCol

   // Recupera la posicion del Browse
   IF oBrw:nEditAt>0
     oBrw:nArrayAt:=oBrw:nEditAt 
     oBrw:nRowSel :=oBrw:nEditSel
   ENDIF

//   oDp:oFrameDp:SetText(LSTR(nAt)+" COLPOS")

   IF nAt>0
     // Posiciona Nuevamente la Columna
     oBrw:SelectCol(oBrw:nEditCol)
     oBrw:SetFocus()
   ENDIF

RETURN .t.
// EOF

