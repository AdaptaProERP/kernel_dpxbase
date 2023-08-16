// Programa   : BTNBARFIND
// Fecha/Hora : 15/11/2018 15:18:39
// Propósito  : Agregar Botón de Búsqueda desde la Barra de Botones
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL nLin:=0,oFont,oFontG
   LOCAL oBtn:=NIL

   DEFINE FONT oFont  NAME "Tahoma" SIZE 0, -12 BOLD
   DEFINE FONT oFontG NAME "Tahoma" SIZE 0, -10

   AEVAL(oDp:oFrameDp:oBar:aControls,{|o,n|nLin:=nLin+IF("TXB"$o:ClassName(),o:nWidth(),0) })

   DEFAULT oDp:oGetFind:=NIL,;
           oDp:cGetFind:=SPACE(120),;
           oDp:oBtnFind:=NIL


   IF !oDp:oGetFind=NIL 
       oDp:oGetFind:End()
       oDp:oBtnFind:End()
       oDp:oGetFind:=NIL
   ENDIF

   IF oDp:oGetFind=NIL 

      @ 13,nLin+32 BMPGET oDp:oGetFind VAR oDp:cGetFind;
                   ACTION EJECUTAR("BTNBARFINDHIS");
                   OF oDp:oFrameDp:oBar SIZE 170,18 PIXEL FONT oFontG

      @ 01,nLin+32 BUTTON oDp:oBtnFind;
           PROMPT " Buscar Opción >> ";
           ACTION EJECUTAR("BTNBARFINDRUN");
           WHEN !Empty(oDp:cGetFind);
           OF oDp:oFrameDp:oBar SIZE 170,16 PIXEL FONT oFont

      oDp:oGetFind:cToolTip:="Buscar Opciones de Ejecución "
      oDp:oGetFind:bKeyDown:={|nKey| oDp:oGetFind:ForWhen(.T.), IF(nKey=13,EJECUTAR("BTNBARFINDRUN"),NIL)}

   ENDIF

//   oDp:oSayFind:Move(01,nLin+32)
   oDp:oGetFind:Move(19-.5,nLin+34)

   oDp:oBtnFind:ForWhen(.T.)
   oDp:oGetFind:Refresh(.T.)
   oDp:oBtnFind:Refresh(.T.)

   IF oBtn=NIL

     oBtn:=BMPGETBTN(oDp:oFrameDp:oBar)

     IF ValType(oBtn)="O"
       oBtn:Move(17,nLin+34+oDp:oGetFind:nWidth())
       oBtn:bWhen:={||.T.} 
       oBtn:ForWhen(.T.)
     ENDIF

   ENDIF

//   oDp:oSayFind:Refresh(.T.)
  
RETURN
