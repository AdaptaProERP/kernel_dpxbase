// Programa   : BRWSETFILTER
// Fecha/Hora : 18/09/2004 00:11:43
// Propósito  : Establecer Búsqueda en el Browse, Activa la Búsqueda en Cualquier Columna
// Creado Por : Juan Navas
// Llamado por: Cualquier Browse
// Aplicación : Todas
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oBrw,lKey,oFrm)
  LOCAL I,oCol,bBlq,I

  DEFAULT lkey:=.T.

  IF oBrw=NIL
     RETURN .F.
  ENDIF

//  IF lKey
//    oBrw:OnKeyDown   :={|oBrwX,nKey,nFlag| IIF(nKey=107,(oDp:aBrwFind:=ACLONE(oBrwX:CARGO),;
//                                                         PUBLICO("oBrw",oBrwX)            ,;
//                                                         EJECUTAR("REPBDLISTMAS")       ),NIL) }
//  ENDIF

  // Copia los Datos del Browse
  IF Empty(oBrw:aData) 
     oBrw:aData     :=ACLONE(oBrw:aArrayData)
     oBrw:lSetFilter:=.F.
  ENDIF

  oBrw:ADD("aColsOrg",ARRAY(LEN(oBrw:aCols)))
  AEVAL(oBrw:aCols,{|oCol,n|  oBrw:aColsOrg[n]:={oCol:nEditType,oCol:bOnPostEdit} })

  oCol:=oBrw:SelectedCol()
  oCol:CARGO        :=oFrm
  oCol:nEditType    :=1
  oCol:bOnPostEdit  :={|oCol,uValue,nLastKey,nCol|oCol:nEditType:=0,oCol:bOnPostEdit:=NIL,;
                        uValue:=IIF("MULTI"$oDp:oGetFocus:ClassName(),oDp:oGetFocus:GetText(),uValue),;
                        EJECUTAR("BRWFILTER",oCol,uValue,nLastKey,oCol:CARGO,NIL,oCol:oBrw:aColsOrg)}
  
  oCol:Edit()

RETURN .T.

