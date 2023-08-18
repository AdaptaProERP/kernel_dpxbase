// Programa   : BRSUBTOTAL
// Fecha/Hora : 17/08/2023 12:28:08
// Propósito  : Incluir Sub-totales
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oBrw,nCol,oMdiFrm)
   LOCAL aData,aGroup:={},oCol,uKey,nContar:=1,aTotal:={},aNew:={},I,aLine:={},aSubTotal:={}
   LOCAL aTotalO:={}

   IF oBrw=NIL
       RETURN NIL
   ENDIF

   DEFAULT nCol:=oBrw:nColSel

   oCol:=oBrw:aCols[nCol]

   IF Empty(oBrw:aData)
      oBrw:aData:=ACLONE(oBrw:aArrayData)
   ENDIF

   aData:=ACLONE(oBrw:aArrayData)

   // busca sub-Total para removerlo
   IF !__objHasMsg( oBrw, "nColSubTotal") 
     __objAddData(oBrw,"nColSubTotal")
     __objSendMsg(oBrw,"nColSubTotal",0)
   ENDIF

   IF oBrw:nColSubTotal>0
      ADEPURA(aData,{|a,n| "Sub-Total"$a[oBrw:nColSubTotal]})
   ENDIF

   __objAddData(oBrw,"nColSubTotal")
   __objSendMsg(oBrw,"nColSubTotal",nCol)

   aData:=ASORT(aData,,, { |x, y| x[nCol] < y[nCol] })

   aLine:=ACLONE(aData[1])
   AEVAL(aLine,{|a,n| aLine[n]:=CTOEMPTY(a)})

   IF ValType(aLine[nCol])="C"
      aLine[nCol]:="Sub-Total"
   ENDIF

   WHILE nContar<=LEN(aData)

      uKey  :=aData[nContar,nCol] 
      aGroup:={}

      WHILE nContar<=LEN(aData) .AND. uKey=aData[nContar,nCol]
         AADD(aGroup,ACLONE(aData[nContar]))
         AADD(aNew  ,ACLONE(aData[nContar]))
         nContar++
      ENDDO

      aTotal:=ATOTALES(aGroup)
      
      // AADD(aNew,ACLONE(aLine))

      FOR I=1 TO LEN(aLine)
        IF ValType(aLine[I])="N"
           aLine[I]:=aTotal[I]
        ENDIF
     NEXT I

     AADD(aNew     ,ACLONE(aLine))

   ENDDO

   oBrw:aArrayData:=ACLONE(aNew)
   oBrw:nArrayAt  :=1

   oBrw:Refresh(.F.)

RETURN aData
// EOF
