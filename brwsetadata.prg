// Programa   : BRWSETADATA
// Fecha/Hora : 02/09/2023 03:16:32
// Propósito  : Copia Valores en oMdi:aData para ser restaurado con Buscar o Filtrar
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oBrw,nCol,oFrm)
  LOCAL aLine,nAt,uValue

  DEFAULT nCol:=1

  aLine :=oBrw:aArrayData[oBrw:nArrayAt]

  IF Empty(oBrw:aData) 
     CursorWait()
     oBrw:aData     :=ACLONE(oBrw:aArrayData)
     oBrw:lSetFilter:=.F.
  ENDIF

  uValue:=aLine[nCol]
  nAt   :=ASCAN(oBrw:aData,{|a,n| a[nCol]==uValue})

  IF nAt>0
    aLine:=ACLONE(oBrw:aArrayData[nAt])
    oBrw:aData[nAt]:=ACLONE(aLine)
  ENDIF


/*
  DEFAULT nAt:=oBrw:nArrayAt

  IF ValType(nAt)="N"
    aLine:=ACLONE(oBrw:aArrayData[nAt])
  ENDIF
  
  IF Empty(oBrw:aData) 
     CursorWait()
     oBrw:aData     :=ACLONE(oBrw:aArrayData)
     oBrw:lSetFilter:=.F.
  ENDIF

  IF ValType(nAt)="N"
     oBrw:aData[nAt]:=ACLONE(aLine)
  ENDIF

*/

RETURN .T.
// 
