// Programa   : GRIDSETITEM
// Fecha/Hora : 21/08/2023 05:50:56
// Propósito  : Asigna Items en columna del GRID
// GRIDSETITEM(oGrid,cFields,aItems) Agrega lista de opciones en el formulario de tipo Grid (Grilla).
// 1. Si la lista tienen 1 elemento, lo asigna por valor en la columna y
//    desactiva la edición de la columna.
// 2. Si la lista esta vacia, activa el modo de edición de la columna.
// 3. Si la lista no está vacia, prepara la columna para la selección de la
//    lista.
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oGrid,cField,aItems,aItemsData)
   LOCAL oCol

   IF oGrid=NIL
      RETURN NIL
   ENDIF

   DEFAULT aItemsData:=aItems

   oCol:=oGrid:GetCol(cField,.F.)

   IF Empty(aItems) .OR. LEN(aItems)=1
      oGrid:oBrw:aCols[oCol:nCol]:aEditListTxt  :=NIL
      oGrid:oBrw:aCols[oCol:nCol]:aEditListBound:=NIL
      oCol:nEditType:=Empty(aItems)
      oCol:bWhen    :=IF(Empty(aItems),".T.",".F.")
   ENDIF

   IF LEN(aItems)=1

      oGrid:Set(cField,aItems[1],.T.)
      oCol:nEditType:=1
      RETURN oCol

   ENDIF

   IF oCol=NIL
      RETURN NIL
   ENDIF

   // Modificar, si está vacio asume el primer Item
   IF Empty(oGrid:Get(cField))
     oGrid:Set(cField,aItems[1],.T.)
   ENDIF

   oGrid:oBrw:aCols[oCol:nCol]:aEditListTxt  :=ACLONE(aItems)
   oGrid:oBrw:aCols[oCol:nCol]:aEditListBound:=ACLONE(aItemsData)
   oCol:bWhen    :=".T."
   oCol:nEditType:=EDIT_LISTBOX
   oCol:lAutoList:=.T.
   
RETURN oCol
//
