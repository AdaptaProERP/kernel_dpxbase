// Programa   : TESTXLSTOARRAY
// Fecha/Hora : 24/08/2023 21:49:00
// Propósito  : Importar contenido de archivo en excel hacia arreglo
// Creado Por : Juan Navas
// Archivo Origen https://github.com/AdaptaProERP/kernel_dpxbase/blob/main/LIBRO.xlsx
// Utilización clase 
// texcelscript : https://github.com/AdaptaProERP/kernel_source/blob/main/TEXCELS.PRG
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cFile,nIni,nMaxCol)
  LOCAL aLine,aData:={},uData,oExcel,nLine,nMaxExp:=30,nIniCol:=0,nAt 
  LOCAL nCol,cValue,nVacios:=0

/*
  DEFAULT cFile  :=oDp:cBin+"EJEMPLO\LIBRO.XLSX",;
          nIni   :=3,;
          nMaxCol:=8
*/

  DEFAULT cFile:=cGetFile32( "*.XLSX", "Archivo excel", nil, nil, .F., NIL, NIL )  

  IF !FILE(cFile)
     MsgMemo("Archivo "+cFile+" no Existe")
     RETURN {}
  ENDIF

  CursorWait()

  oExcel := TExcelScript():New()
  oExcel:Open( cFile )

  IF nIni=NIL

    // Buscamos la primera Linea con Datos, en las primeras 10 columnas
    nLine:=1
    nAt  :=0

    WHILE nAt=0

      aLine:=ARRAY(nMaxExp)
      AEVAL(aLine,{|a,nCol,cValue| cValue:=SPACE(200),aLine[nCol]:=oExcel:Get( nLine , nCol ,@cValue ) })
      nAt:=ASCAN(aLine,{|a,n| !Empty(a)})

      IF nAt=0
        nLine++
      ENDIF

    ENDDO

    // Aqui Buscamos el ancho de la columna 

    nMaxCol:=0
    AEVAL(aLine,{|a,n| nMaxCol:=nMaxCol+IF(Empty(a),0,1) })
    nIniCol:=nAt
    nIni   :=nLine // la primera Linea es Encabezado

  ELSE

    nLine:=nIni

  ENDIF

  WHILE .T.

     aLine:=ARRAY(nMaxCol)

     AEVAL(aLine,{|a,nCol,cValue| cValue:=SPACE(200),aLine[nCol]:=oExcel:Get( nLine , nCol ,@cValue ) })

     IF Empty(aLine[1]) 

        IF nVacios++>1
           EXIT
        ENDIF

     ENDIF
  
     nLine++

     IF nLine%10=0
        SysRefresh(.T.)
        CursorWait()
     ENDIF

     AADD(aData,ACLONE(aLine))

  ENDDO

  oExcel:End(.F.)

ViewArray(aData)

RETURN aData
// EOF
