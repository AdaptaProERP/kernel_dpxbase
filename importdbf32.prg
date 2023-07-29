// Programa   : IMPORTDBF32
// Fecha/Hora : 04/01/2017 14:16:52
// Propósito  : Importar desde Tablas DBF
// Creado Por : Juan Navas
// Llamado por: DPWIN32.HRB FUNCION  IMPORTDBF32
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cNumTab,cTable,cDsn,oSay,lFromDbf,lCopy,lCreaReg,lAdd,oMeter)
  LOCAL oOdbc:=OPENODBC(cDsn),aTablas:={},nStep:=0,I,lMemo
  LOCAL cFile:=cFileNoExt(cFileName(cTable))
  LOCAL aFields
  LOCAL oTable,nAt,cFileDbf
  LOCAL cFileInd:=STRTRAN(UPPE(cTable),".DBF",".IND")
  LOCAL aFieldPos:={}
  LOCAL lCrear:=.F.

  DEFAULT lFromDbf:=.F.,lCopy:=.T.,lCreaReg:=.F.

  // si esta vacio lo agrega
  DEFAULT lAdd:=.F. 

  oDp:lRunDefault:=.F. // 13/01/2018  Inactivar valores por defecto

  IF !FILE(cTable)
     MensajeErr("Tabla "+cTable+" no Existe, no puede ser importada mediante IMPORTDBF32(")
     RETURN .T.
  ENDIF

  IF lFromDbf .AND. FILE("DATADBF\DPCAMPOS.DBF")

     USE DATADBF\DPCAMPOS VIA "DBFCDX" ALIAS "DPCAMPOS"

     SET FILTER TO ALLTRIM(UPPE(DPCAMPOS->CAM_TABLE))==ALLTRIM(UPPE(cFile))

     GO TOP
     aFields:={}

     WHILE !DPCAMPOS->(EOF())
        DPCAMPOS->(AADD(aFields , {DPCAMPOS->CAM_NAME,DPCAMPOS->CAM_TYPE,DPCAMPOS->CAM_LEN,DPCAMPOS->CAM_DEC,ALLTRIM(DPCAMPOS->CAM_COMMAN)}))
        DPCAMPOS->(DBSKIP())
     ENDDO

     USE

  ENDIF

  USE
 
  USE (cTable) VIA "DBFCDX"

  IF EMPTY(ALIAS())
     ? "Archivo : "+cTable+" No pudo ser Abierto"
     USE
     Return .F.
  ENDIF

  SET FILTER TO

  IF !oOdbc:File(cFile)

     oOdbc:CreateTableDp( cFile, aFields , cFileInd )

     lCrear:=.T.

     IF (oDp:cTypeBD="MYSQL" .AND. oDp:lNativo) .AND. !oDp:oMySqlCon:Reconnect=NIL
       oDp:oMySqlCon:Reconnect()
     ENDIF

     SysRefresh()

  ENDIF

  IF oDp:cTypeDb="MYSQL"
     //  JN 10/06/2016 Innecesario cerrar la tablas MySQL MyCloseAll()
  ENDIF

  // La Toma del DBF
  aFields:=DBSTRUCT()


  IF !oOdbc:File(cFile)
     ? "Error al Crear: "+cFile,oOdbc:cQuery
     MemoWrit("ERR.SQL",oOdbc:cQuery)
  ENDIF

//ADDTABLE(cNumTab,cTable,cDsn,!oDp:cDsndConfig=cDsn)

  ADDTABLE(cNumTab,cFile,cDsn,!oDp:cDsnData=cDsn)

  aTablas:=GetTables()

 // nAt    :=ASCAN(aTablas,{|aVal| aVal[2] == ALLTRIM(cFile) })
 // ? nAt,cTable,Len(aTablas),aTablas[nAt,2],"ENCONTRADO"
 // viewarray(aTablas)
 // ? !lCrear,cFile,COUNT(cFile)>0

  IF !lCrear .AND. COUNT(cFile)>0 .AND. !lAdd // 28/07/2023
     USE
     RETURN .T.
  ENDIF

  oTable:=OpenTable(cFile,.F.,oOdbc,.F.)

  //oTable:=OpenTable(cFile,.F.,oOdbc,.F.)

  aFieldPos:=ALIAS_FIELDPOS(oTable)  // Arreglo {Table,Alias}


  IF !ValType(oTable)="O"
    ? "Error en Tabla "+cFile
    USE
    RETURN .F.
  ENDIF

  IF empty(oTable:aFields)
     ? "Error en Tabla "+cFile
     USE
     RETURN .F.
  ENDIF

  IF oTable:RecCount()>0 // Tiene Datos
     USE
     oTable:End()
     RETURN .T.
  ENDIF

  lMemo:=ASCAN(aFields,{|a,n|a[2]="M"})>0

  IF lMemo
    oTable:SetInsert(1)
  ELSE
    oTable:SetInsert(Min(RecCount(),100))
  ENDIF

  oTable:Execute("SET FOREIGN_KEY_CHECKS = 0")


  SET ORDE TO 0

  DBGOTOP()

  IIF( ValType(oSay)="O" , oSay:SetText("Importando Desde "+Lower(cFileNoPath(cTable))+" para "+Lower(cDsn)+"."+cFileNoExt(cFile)) , NIL )

  // BROWSE()
  // ? cFile
  CURSORWAIT()
  IF(ValType(oMeter)="O",oMeter:SetTotal(RECCOUNT()),NIL)

  WHILE !EOF()

// ? RECNO(),"RECNO EN IMPORTDBF32"

     VP("lCreate",.T.) // Indica que ha Creado la Estructura de DpConfig
     oTable:Append() // Blank()
     nStep++

     IF RECNO()%100=0 .AND. ValType(oSay)="O"
       oSay:SetText("Importando "+oTable:cTable+" "+LSTR(RECNO())+"/"+LSTR(RECCOUNT()))
       IF(ValType(oMeter)="O",oMeter:Set(RECNO()),NIL)
     ENDIF

     IF nStep>10
        nStep:=0
        SysRefresh()
     ELSE
        CursorWait()
     ENDIF

     IF lMemo

       AEVAL( aFieldPos,{|a,n| oTable:FieldPut(a[1],FIELDGET(a[2])) })

       oTable:lCreaRegIntRef:=lCreaReg // JN 20/12/2017, Inserta Registros de Integridad Referencial
       oTable:Commit()

     ELSE

       AEVAL( aFieldPos,{|a,n| oTable:ReplaceSpeed(otable:FieldName(a[1]),FIELDGET(a[2]),.F.) })

       oTable:CommitSpeed(.F.)

     ENDIF

     DBSKIP()

  ENDDO

  USE

   oTable:Execute("SET FOREIGN_KEY_CHECKS = 1")

  oTable:End()
  oOdbc:=NIL

RETURN NIL
// EOF
