// Programa   : BRWCALTOTALES
// Fecha/Hora : 01/03/2020 10:31:40
// Propósito  : Calcular Totales del Browse
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oBrw,lRefresh,aTotales,lEsp)
  LOCAL oCol,I,cFooter,cPicture,aLine,cTotal
  LOCAL nLen    :=0,lSubTotal,aData
 
  IF !ValType(oBrw)="O"
     RETURN .F.
  ENDIF

  // busca sub-Total para removerlo
  // JN 16/08/2023
  IF !__objHasMsg( oBrw, "nColSubTotal") 
    __objAddData(oBrw,"nColSubTotal")
    __objSendMsg(oBrw,"nColSubTotal",0)
  ENDIF

  IF oBrw:nColSubTotal>0

    aData:=ACLONE(oBrw:aArrayData)

    ADEPURA(aData,{|a,n| "Sub-Total"$a[oBrw:nColSubTotal]})

    DEFAULT aTotales:=ATOTALES(aData)

  ENDIF


  DEFAULT lRefresh:=.F.,;
          aTotales:=ATOTALES(oBrw:aArrayData),;
          lEsp    :=.T.


  FOR I=2 TO LEN(oBrw:aCols)

     oCol    :=oBrw:aCols[I]
     cFooter :=oCol:cFooter
     cPicture:=oCol:cEditPicture

     // Formula para el Total
     IF !__objHasMsg( oCol, "cTotal")
         __objAddData( oCol, "cTotal")
         oCol:cTotal:=""
     ENDIF
  
     IF !Empty(oCol:cTotal)
        aTotales[I]:=0
        cTotal  :=STRTRAN(oCol:cTotal,"[","aTotales[")
        aTotales[I]:=MacroEje(cTotal)
     ENDIF

  NEXT I

   aLine:=ATAIL(oBrw:aArrayData)

   FOR I=2 TO LEN(oBrw:aCols)

     oCol    :=oBrw:aCols[I]
     cFooter :=oCol:cFooter
     cPicture:=oCol:cEditPicture

     // Formula para el Total
     IF !__objHasMsg( oCol, "cTotal")
         __objAddData( oCol, "cTotal")
         oCol:cTotal:=""
     ENDIF

     IF !__objHasMsg( oCol, "lAvg")
         __objAddData( oCol, "lAvg")
         oCol:lAvg:=.F.
     ENDIF

     DEFAULT oCol:lAvg:=.F.


     // Calcula Elementos Diferentes que Cero
     IF oCol:lAvg
       nLen:=0
       AEVAL(oBrw:aArrayData,{|a,n| nLen:=nLen+ IF(a[I]=0,0,1)})
     ENDIF

     IF oCol:lTotal
        aTotales[I]:=aLine[I]
     ENDIF

// ? I,aTotales[I],oCol:lAvg

     IF (!Empty(cPicture) .AND. (!Empty(cFooter) .OR. oCol:lAvg)) .AND. ISDIGIT(RIGHT(cFooter,1))

       IF lEsp  
         oCol:cFooter:=FDP(aTotales[I]/IF(oCol:lAvg,nLen,1),cPicture)
       ELSE
         oCol:cFooter:=TRANF(aTotales[I]/IF(oCol:lAvg,nLen,1),cPicture)
       ENDIF

     ENDIF

     IF !Empty(cFooter) .AND. Empty(cPicture) .AND. ISDIGIT(RIGHT(cFooter,1))

       IF lEsp 
         oCol:cFooter:=FDP(aTotales[I]/IF(oCol:lAvg,nLen,1),"999,999,999,999,999.99")
       ELSE
         oCol:cFooter:=TRANF(aTotales[I]/IF(oCol:lAvg,nLen,1),"999,999,999,999,999.99")
       ENDIF

     ENDIF

   NEXT I

   IF ValType(oCol)="O" .AND. ValType(oBrw:aArrayData)="A"
     oCol    :=oBrw:aCols[1]
     oCol:cFooter:="#"+LSTR(LEN(oBrw:aArrayData))
   ENDIF

   IF lRefresh

     oBrw:Refresh(.T.)

 
  ELSE

     oBrw:RefreshFooters()
 
   ENDIF

RETURN .T.
// EOF
