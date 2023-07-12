// Programa   : DPAUDELIMODTAB
// Fecha/Hora : 01/11/2014 23:51:06
// Propósito  : Registrar Eliminación y Modificación en Tablas
// Creado Por : Juan Navas
// Llamado por: TTABLE, COMMIT()
// Aplicación : 
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oTable,cKey,cPrimary)
   LOCAL I,cMemo:="",cField,uValue,uValueOld,cOption,n,cTable,nLen
   LOCAL cTableAud:="",nAt

   DEFAULT cPrimary:=oTable:cPrimary

   // conexion remota no hace auditoria

   IF !__objHasMsg( oTable, "lDicc")
       __objAddData( oTable,"lDicc")
      oTable:lDicc:=.T.
   ENDIF

   IF !__objHasMsg( oTable, "lAuditar")
       __objAddData( oTable,"lAuditar")
      oTable:lAuditar:=.T.
   ENDIF


   IF !oTable:lDicc .OR. oTable:oOdbc:lRemote
     RETURN .F.
   ENDIF

   IF !oTable:lAuditar
     RETURN .F.
   ENDIF

   cTable  :=oTable:cTable
   cPrimary:=oTable:cPrimary


   // Auditoria genera incidencia por recursividad
   IF "AUD"$UPPER(cTable)
      RETURN .F.
   ENDIF

//   ? cTable,"cTable"
//   RETURN .F.

   IF Empty(cPrimary)
      cPrimary:=EJECUTAR("GETPRIMARY",oTable:cTable)
   ENDIF

   IF Empty(cPrimary)
      RETURN .F.
   ENDIF

   DEFAULT cKey:=oTable:cWhere

   nAt:=AT("GROUP BY",cKey)

   IF nAt>0
      cKey:=LEFT(cKey,nAt-1)
   ENDIF

if !Empty(oTable:aRecClone)

   FOR n=1 TO LEN(oTable:aFields)

       cField   :=oTable:aFields[n,1] 
       uValue   :=oTable:FieldGet(cField)
       uValueOld:=NIL

       IF !Empty(oTable:aRecClone)
          uValueOld:=oTable:aRecClone[n,2]
       ENDIF

       IF Empty(uValueOld)
          uValueOld:=oTable:aBuffers[n,1]
       ENDIF

       IF ValType(uValueOld)="C" .AND. !oTable:aFields[n,2]="M"
          uValueOld:=ALLTRIM(LEFT(uValueOld,oTable:aFields[n,3]))
       ENDIF

       // Resuelve Campos ComboBox mediante clase TSCROLLGET JN 28/08/2014
       IF oTable:aFields[n,2]="C" .AND. ValType(uValue)="C"
          uValue   :=ALLTRIM(LEFT(uValue,oTable:aFields[n,3]))
       ENDIF

       IF oTable:aFields[n,2]="M"
          uValue   :=ALLTRIM(uValue,oTable:aFields[n,3])
       ENDIF

       IF (ValType(uValue)=ValType(uValueOld)) .AND. !(uValue==uValueOld) 
          uValue:=cField+"="+CTOO(uValueOld,"C")+CHR(9)+" "+CTOO(uValue,"C")
          cMemo:=cMemo+IF(Empty(cMemo),"",CRLF)+uValue
       ENDIF

   NEXT 

ENDIF

   // Incluir

   IF Empty(oTable:cWhere) .AND. Empty(cMemo)

      FOR n=1 TO LEN(oTable:aFields)

        cField   :=oTable:aFields[n,1] 
        uValue   :=oTable:FieldGet(cField)

        // Resuelve Campos ComboBox mediante clase TSCROLLGET JN 28/08/2014
        IF oTable:aFields[n,2]="C" .AND. ValType(uValue)="C"
          uValue   :=ALLTRIM(LEFT(uValue,oTable:aFields[n,3]))
        ENDIF

        IF oTable:aFields[n,2]="M"
          uValue   :=ALLTRIM(uValue,oTable:aFields[n,3])
        ENDIF

        IF !Empty(uValue)
           uValue:=cField+"="+CTOO(uValue,"C")
          cMemo:=cMemo+IF(Empty(cMemo),"",CRLF)+uValue
        ENDIF

      NEXT I

   ENDIF

   cTableAud:=EJECUTAR("GETTABLE_AUD",cTable)

   IF !Empty(cMemo)

      oTable:=OpenTable("SELECT * FROM "+cTableAud,.F.)

      oTable:lAuditar:=.F. // 04/05/2023
      oTable:AppendBlank()
      oTable:Replace("AEM_TABLA" ,cTable       )
      oTable:Replace("AEM_CLAVE" ,cPrimary     )
      oTable:Replace("AEM_KEY"   ,cKey         )
      oTable:Replace("AEM_OPCION","M"          )
      oTable:Replace("AEM_FECHA" ,DPFECHA()    )
      oTable:Replace("AEM_HORA"  ,DPHORA()     )
      oTable:Replace("AEM_MEMO"  ,cMemo        )
      oTable:Replace("AEM_ESTACI",oDp:cPcName  )
      oTable:Replace("AEM_IP"    ,oDp:cIpLocal )
      oTable:Replace("AEM_USUARI",oDp:cUsuario )
      oTable:Commit()
      oTable:End()

   ENDIF

RETURN .T.

FUNCTION REGELIMINAR(oTable)
  LOCAL cMemo:="",I,lClose:=.F.

  IF oTable=NIL
    oTable:=OpenTable("SELECT * FROM "+cTable+ " WHERE "+cKey+GetWhere("=",cPrimary),.T.) 
    lClose:=.T.
  ENDIF

  FOR I=1 TO oTable:Fcount()

      cMemo:=cMemo + IF(Empty(cMemo), "", CRLF )+;
             oTable:FieldName(I)+"="+CTOO(oTable:FieldGet(I),"C")

  NEXT I

  IF lClose
    oTable:End()
  ENDIF
  
RETURN cMemo
// EOF


