// Programa   : BRWFIND
// Fecha/Hora : 18/09/2004 00:36:51
// Propósito  : Ejecutar la Búsqueda
// Creado Por : Juan Navas
// Llamado por: BRWSETFIND
// Aplicación : Todas
// Tabla      : Todas

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oCol,uValue,nLastKey,nRecord,oLbx,aCols)
   LOCAL oBrw,nAt:=0,aValue:={},nContar:=0,nCol,cCero,I
   LOCAL uValue2:=uValue

   DEFAULT nRecord:=0

   IF ValType(oCol)!="O" .OR. Empty(uValue)
      RETURN NIL
   ENDIF

   oBrw:=oCol:oBrw

   IF ValType(oBrw)!="O"
      RETURN NIL
   ENDIF

   // Seguir Búscando
   IF ValType(nLastKey)="N" .AND. nLastKey=43 
      nRecord:=oBrw:nArrayAt
   ENDIF

   oBrw:cSeek:=uValue // Buscador
   nCol:=oCol:oBrw:nColSel

   IF ValType(uValue)!="C" 

     nAt :=ASCAN(oCol:oBrw:aArrayData,{|a,n| a[nCol]=uValue .AND. n>nRecord })

   ELSE

     // Busquedas en Char

     cCero:=ALLTRIM(uValue)
     cCero:=REPLI("0",LEN(uValue)-Len(cCero))+cCero

     AADD(aValue,uValue)
     AADD(aValue,UPPE(uValue))
     AADD(aValue,LOWER(uValue))
     AADD(aValue,ALLTRIM(uValue))
     AADD(aValue,cCero)

     uValue:=ALLTRIM(uValue)

     // Búsqueda Incremental
     FOR I=LEN(uValue) TO 1 STEP -1
        AADD(aValue,LEFT(uValue,I))
     NEXT I

     // Búsqueda Incremental
     FOR I=LEN(uValue) TO 1 STEP -1
        AADD(aValue,LEFT(UPPE(uValue),I))
     NEXT I

     WHILE nAt=0 

       nContar++
       uValue :=aValue[nContar]
       nAt    :=ASCAN(oBrw:aArrayData,{|a,n| (a[nCol]=uValue .OR. UPPE(a[nCol])=UPPE(uValue)) .AND. n>nRecord})

       IF nContar>=LEN(aValue)
          EXIT
       ENDIF

     ENDDO

     // Búsqueda Secuencial
     nContar:=0


     WHILE nAt=0 

       nContar++
       uValue :=aValue[nContar]
       nAt    :=ASCAN(oBrw:aArrayData,{|a,n|(uValue$a[nCol] .OR. UPPE(uValue)$UPPE(a[nCol])) .AND. n>nRecord})

       IF nContar>=LEN(aValue)
          EXIT
       ENDIF

     ENDDO

   ENDIF

   IF nAt>0
      oBrw:nArrayAt:=nAt
      oBrw:Refresh(.T.) 
      oBrw:nArrayAt:=nAt
      oDp:aBrwFind:={oCol,nAt,uValue2}

      AEVAL(oBrw:aCols,{|o,n|o:nEditType:=0})
//    JN 26/01/2015
//      oBrw:CARGO:=ACLONE(oDp:aBrwFind)
   ENDIF


? LEN(aCols)
   IF ValType(aCols)="A"

ViewArray(aCols)


      FOR I=1 TO LEN(aCols)
         oBrw:aCols[I]:nEditType  :=aCols[I,1]
         oBrw:aCols[I]:bOnPostEdit:=aCols[I,2]
      NEXT I

   ENDIF
   
RETURN .T.
