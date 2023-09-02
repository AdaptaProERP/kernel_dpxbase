// Programa   : BRWFILTER
// Fecha/Hora : 09/11/2014 21:48:32
// Propósito  : Aplicar Filtros en Registros
// Creado Por : Juan Navas
// Llamado por: DPLBX:SetFilter()
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oCol,uValue,nLastKey,lExact,nColOrg,aCols)
  LOCAL oBrw,aData:={},nCol,I,cLower:="",nLen,cFind:="$",aDataBrw:={}
  LOCAL uValueO:=uValue
//  LOCAL aTotales:={},cFooter,cPicture

  IF oCol=NIL 
     RETURN .T.
  ENDIF

  DEFAULT lExact:=.F.

  // oCol:oBrw:SelectedCol():nCreationOrder

  oBrw:=oCol:oBrw
  nCol:=oCol:nPos

//oCol:oBrw:SelectedCol():nCreationOrder
  nCol:=(oBrw:nColOffset+oBrw:nColSel-1)


  DEFAULT oCol:=oBrw:aCols[nCol]

  IF oDp:nVersion>=5 .AND. oCol:nColArray<>NIL
     nCol:=oCol:nColArray
  ENDOF

  IF oDp:nVersion>=5 .AND. Empty(oBrw:aData)
     oBrw:aData:=ACLONE(oBrw:aArrayData)
  ENDIF

  IF oDp:nVersion<5 .AND. Empty(oBrw:CARGO)
     oBrw:CARGO:=ACLONE(oBrw:aArrayData)
  ENDIF

  IF oDp:nVersion>=5 .AND. oBrw:lSetFilter .AND. Empty(uValue)

     oBrw:aArrayData:=ACLONE(oBrw:aData)

     // BRWCALTOTALES()
     EJECUTAR("BRWCALTOTALES",oBrw) // ()

     oBrw:Refresh(.T.)
     oBrw:lSetFilter:=.F.

     IIF(ValType(oBrw:bChange)="B",EVAL(oBrw:bChange),NIL) // JN 28/03/2023

     RETURN .F.

  ENDIF

  IF oDp:nVersion>=5 .AND. ValType(oBrw:aData[1,nCol])<>ValType(uValue)
     uValue:=CTOO(uValue,ValType(oBrw:aData[1,nCol]))
  ENDIF

  IF oDp:nVersion<5 .AND. ValType(oBrw:CARGO[1,nCol])<>ValType(uValue)
     uValue:=CTOO(uValue,ValType(oBrw:CARGO[1,nCol]))
  ENDIF

  aDataBrw:=IF(oDp:nVersion>=5,oBrw:aData,oBrw:CARGO)

  IF ValType(uValue)="C" .AND. !Empty(uValue) 

     uValue:=ALLTRIM(uValue)
     cLower:=Lower(uValue)

     IF LEFT(uValue,1)="%"
       cFind:="%"
       uValue:=SUBS(uValue,2,LEN(uValue))
       nLen  :=LEN(uValue)
       cLower:=Lower(uValue)
       AEVAL(aDataBrw,{|a,n| IF(uValue=LEFT(a[nCol],nLen) .OR. cLower=LEFT(Lower(a[ncol]),nLen),AADD(aData,a),NIL)})
     ENDIF

     IF cFind="$"
       AEVAL(aDataBrw,{|a,n| IF(uValue$a[nCol] .OR. cLower$Lower(a[ncol]),AADD(aData,a),NIL)})
     ENDIF

  ENDIF

  IF ValType(uValue)<>"C" .AND. !ValType(uValueO)="L"
     aData:={}
     AEVAL(aDataBrw,{|a,n| IF(uValue=a[nCol],AADD(aData,a),NIL)})
  ENDIF

  // 21/09/2022, busca por campos Lógicos
  IF ValType(nColOrg)="N" .AND. ValType(uValueO)="L"

     aData:={}
     AEVAL(aDataBrw,{|a,n| IF(uValueO=a[nColOrg],AADD(aData,a),NIL)})
  
     IF Empty(aData)
       MensajeErr("No hay Coincidencia con "+CTOO(uValue,"C"))
       RETURN .F.
     ENDIF

  ELSE

    IF Empty(aData) .AND. !Empty(uValue) 
       MensajeErr("No hay Coincidencia con "+CTOO(uValue,"C"))
       RETURN .F.
    ENDIF

  ENDIF

  IF !Empty(aData) 

     oBrw:aArrayData:=ACLONE(aData)
     oBrw:aCols[1]:cFooter:=" #"+LSTR(LEN(oBrw:aArrayData))

     EJECUTAR("BRWCALTOTALES",oBrw) // ()

     oBrw:Refresh(.T.)

//     oBrw:RefreshFooters()
//     IF oDp:nVersion>=6
       oBrw:lSetFilter:=.T.
//     ENDIF

  ENDIF

  IIF(ValType(oBrw:bChange)="B",EVAL(oBrw:bChange),NIL) // JN 28/03/2023

  // 01/09/2023 Restaura los Parametros de las Columnas nEditType
  IF ValType(aCols)="A"

     FOR I=1 TO LEN(aCols)
        oBrw:aCols[I]:nEditType  :=aCols[I,1]
        oBrw:aCols[I]:bOnPostEdit:=aCols[I,2]
     NEXT I

  ENDIF

RETURN .T.

/*
FUNCTION BRWCALTOTALES()
    LOCAL oCol,I,cFooter,cPicture
    LOCAL aTotales:=ATOTALES(oBrw:aArrayData)

// ViewArray(oBrw:aArrayData)
// ViewArray(aTotales)

// Recalcula los Totales

   FOR I=2 TO LEN(oBrw:aCols)

// aTotales)
    oCol    :=oBrw:aCols[I]
    cFooter :=oCol:cFooter
    cPicture:=oCol:cEditPicture

    IF !Empty(cPicture) .AND. !Empty(cFooter)
      oCol:cFooter:=FDP(aTotales[I],cPicture)
    ENDIF

    IF !Empty(cFooter)
       oCol:cFooter:=FDP(aTotales[I],"999,999,999,999.99")
    ENDIF

   NEXT I

   oBrw:RefreshFooters()

RETURN .T.
*/
// EOF

