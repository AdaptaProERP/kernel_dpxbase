// Programa   : DPCAMPOSADD
// Fecha/Hora : 04/01/2016 22:10:11
// Prop�sito  : Agregar Nuevo Campo
// Creado Por : Juan Navas
// Llamado por: DPINVSETUTILIZ
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable,cField,cType,nLen,nDec,cDescri,cCmd,lCheck,uValue,cDefault)
  LOCAL aFields:={},I,oTable,cDsn,oDb,cSql

  DEFAULT cTable :="DPPRECIOTIP",;
          cField :="TPP_NUEVO",;
          cType  :="C",;
          nLen   :=20,;
          nDec   :=0,;
          cDescri:="Nuevo Campo",;
          cCmd   :="",;
          lCheck :=.T.,;
          cDefault:=""

  DEFAULT oDp:oDpSetNull:=.F.

  cDsn:=GETDSN(cTable,.F.)

  IF Empty(cDsn)
     RETURN .F.
  ENDIF

  IF cType<>"N"
     nDec:=0
  ENDIF

  IF oDp:oMsgRun<>NIL
     oDp:oMsgRun:FRMTEXT("Evaluando Tabla "+cTable+" Campo "+cField)
  ENDIF

  IF oDp:oSay<>NIL
     oDp:oSay:SetText("Evaluando Tabla "+cTable+" Campo "+cField)
  ENDIF

  IF !EJECUTAR("DBISTABLE",cDsn,cTable,.T.) 
     RETURN .F.
  ENDIF


//  oDp:oFrameDp:SetText("Evaluando Tabla "+cTable+" Campo "+cField)
//  DpMsgSetText("Evaluando Tabla "+cTable+" Campo "+cField)
//  oDp:oMsgRun:oSay:SetText(cText)

  
  IF !ISSQLFIND("DPTABLAS","TAB_NOMBRE"+GetWhere("=",cTable))

     IF !EJECUTAR("DPCREATEFROMTXT",cTable)
        RETURN .F.
     ENDIF

  ENDIF

  // IF ISFIELD(cTable,cField)
  oDb:=OpenOdbc(cDsn)

  IF EJECUTAR("ISFIELDMYSQL",oDb,cTable,cField)

     // Convierte los Valores
     IF oDp:oDpSetNull .AND. uValue<>NIL
        SQLUPDATE(cTable,cField,uValue,cField+" IS NULL ")
     ENDIF

     RETURN .F.

  ENDIF

  AADD(aFields,{cTable,cField,cType,nLen,nDec,cDescri,cCmd,cDefault})

  FOR I=1 TO LEN(aFields)

     oTable:=OpenTable("SELECT * FROM DPCAMPOS WHERE CAM_TABLE"+GetWhere("=",aFields[I,1])+" AND "+;
                                                    "CAM_NAME" +GetWhere("=",aFields[I,2]),.T.)
     IF oTable:RecCount()=0
        oTable:AppendBlank()
        oTable:cWhere:=""
        lCheck:=.T.
     ENDIF

     oTable:Replace("CAM_NUMTAB",SQLGET("DPTABLAS","TAB_NUMERO","TAB_NOMBRE"+GetWhere("=",aFields[I,1])))
     oTable:Replace("CAM_TABLE" ,aFields[I,1])
     oTable:Replace("CAM_NAME"  ,aFields[I,2])
     oTable:Replace("CAM_TYPE"  ,aFields[I,3])
     oTable:Replace("CAM_LEN"   ,aFields[I,4])
     oTable:Replace("CAM_DEC",  ,aFields[I,5])
     oTable:Replace("CAM_DESCRI",aFields[I,6])
     oTable:Replace("CAM_COMMAN",aFields[I,7])
     oTable:Replace("CAM_DEFAUL",aFields[I,8])
     oTable:Replace("CAM_AFECTA",.F. ) // aFields[I,8])


     oTable:Commit(oTable:cWhere)
     oTable:End()
  
     IF !ISFIELD(cTable,aFields[I,1]) .AND. !lCheck
       lCheck:=.T.
     ENDIF

     SQLUPDATE("DPTABLAS","TAB_FECHA",oDp:dFecha,"TAB_NOMBRE"+GetWhere("=",cTable))

  NEXT I


  IF lCheck

     EJECUTAR("DPMYSQLTABLE",cTable) // Realiza CheckTable(cTable)
     CheckTable(cTable)

     IF uValue<>NIL .AND. ISFIELD(cTable,cField)
        SQLUPDATE(cTable,cField,uValue,cField+" IS NULL ")
     ENDIF

     IF !uValue=NIL .AND. ISFIELD(cTable,cField)
       SQLUPDATE(cTable,cField,uValue,cField+" IS NULL ")
     ENDIF

  ENDIF

  SysRefresh(.T.)

  IF lCheck

     DEFAULT oDb:=OpenOdbc(cDsn)

     oDb:=OpenOdbc(cDsn)

     IF !EJECUTAR("ISFIELDMYSQL",oDb,cTable,cField)

// MsgRun("Agregando Campo "+cField+" en Tabla "+cTable)
//      DpMsgSetText("Agregando Campo "+cField+" en Tabla "+cTable)

      IF oDp:oMsgRun<>NIL
       oDp:oMsgRun:FRMTEXT("Agregando Campo "+cField+" en Tabla "+cTable)
      ENDIF

      cSql:=""

      IF cType="C"
         cSql:="ALTER TABLE "+cTable+" ADD "+cField+" VARCHAR("+LSTR(nLen)+")"
      ENDIF

      IF cType="D"
        cSql:="ALTER TABLE "+cTable+" ADD "+cField+" DATE "
      ENDIF

     IF cType="M"
        cSql:="ALTER TABLE "+cTable+" ADD "+cField+" LONGTEXT "
      ENDIF


      IF cType="L"
         cSql:="ALTER TABLE "+cTable+" ADD "+cField+" NUMERIC(1,0)"
      ENDIF

      IF cType="N"
         cSql:="ALTER TABLE "+cTable+" ADD "+cField+" NUMERIC("+LSTR(nLen)+","+LSTR(nDec)+")"
      ENDIF

      IF !Empty(cSql)
        oDb:Execute(cSql)
      ENDIF

     ENDIF

  ENDIF

  IF cType="L"
     oDp:aLogico:={}
  ENDIF
 
  IF lCheck 

     CheckTable(cTable,NIL,NIL,NIL,NIL,NIL,oDb)

/*

     MsgRun("DPMYSQLTABLE "+ cTable)

     EJECUTAR("DPMYSQLTABLE",cTable) // Realiza CheckTable(cTable)

     CheckTable(cTable)

     IF uValue<>NIL .AND. ISFIELD(cTable,cField)
        SQLUPDATE(cTable,cField,uValue,cField+" IS NULL ")
     ENDIF

     IF !uValue=NIL .AND. ISFIELD(cTable,cField)
       SQLUPDATE(cTable,cField,uValue,cField+" IS NULL ")
     ENDIF
*/

  ENDIF

  SQLUPDATE("DPTABLAS","TAB_FECHA",oDp:dFecha,"TAB_NOMBRE"+GetWhere("=",cTable))

  CursorArrow()

  SysRefresh(.T.)

RETURN .T.
// EOF
