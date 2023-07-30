// Programa   : OPENTABLEPAG2
// Fecha/Hora : 24/12/2018 03:48:11
// Propósito  : Devolver oTable Paginado
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cSql,nPag,cText,oDb,nTotal,oSay,oMeter)
  LOCAL cPag
  LOCAL aPag :={}
  LOCAL oTable,nDesde:=0,nT1:=SECONDS()

  DEFAULT cSql:=" SELECT MOV_CODSUC,MOV_CODALM,MOV_CODIGO,"+;       
                " SUM(MOV_CANTID*MOV_CXUND*MOV_CONTAB) AS MOV_EXICON,"+;
                " SUM(MOV_CANTID*MOV_CXUND*MOV_FISICO) AS MOV_EXIFIS, "+;
                " SUM(MOV_CANTID*MOV_CXUND*MOV_LOGICO) AS MOV_EXILOG "+;
                " FROM DPMOVINV   "+;
                " WHERE MOV_INVACT<>0  AND (MOV_CONTAB<>0 OR MOV_FISICO<>0 OR MOV_LOGICO<>0) "+; 
                " GROUP BY MOV_CODSUC,MOV_CODALM,MOV_CODIGO "+;           
                " ORDER BY MOV_CODSUC,MOV_CODALM,MOV_CODIGO "

  DEFAULT nPag  :=100,;
          cText :="",;
          nTotal:=0

  IF nTotal>0 .AND. ValType(oMeter)="O"
     oMeter:SetTotal(nTotal)
  ENDIF

  WHILE .T.

     CursorWait()
 
     IF ValType(oSay)="O"

        IF nTotal=0
          oSay:SetText(cText+" Reg: "+LSTR(nDesde)+","+LSTR(nPag))
        ELSE
          oSay:SetText(cText+" Reg: "+LSTR(LEN(aPag))+"/"+LSTR(nTotal)+","+LSTR(nPag))
        ENDIF
     ELSE
        MsgRun(cText+" Reg: "+LSTR(nDesde)+","+LSTR(nPag))
     ENDIF
     
     cPag  :=cSql+" LIMIT "+LSTR(nDesde)+","+LSTR(nPag)
     oTable:=OpenTable(cPag,.T.)
     SysRefresh(.T.)

     AEVAL(oTable:aDataFill,{|a,n| AADD(aPag,a)})

     IF nTotal>0 .AND. ValType(oMeter)="O"
        oMeter:Set(LEN(aPag))
     ENDIF

     IF oTable:RecCount()=0 
        EXIT
     ENDIF

     oTable:End()

     nDesde:=nDesde+nPag

  ENDDO

// ViewArray(aPag)  
// ? nDesde,"nDesde"

  IF nDesde>0
     oTable:aDataFill:=aPag
  ENDIF

//  oTable:Browse()
  oTable:Gotop()

RETURN oTable
// EOF
