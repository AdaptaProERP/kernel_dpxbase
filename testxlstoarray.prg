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
  LOCAL aLine,aData:={},uData,oExcel,nLine
  LOCAL nCol,cValue

  DEFAULT cFile  :=oDp:cBin+"EJEMPLO\LIBRO.XLSX",;
          nIni   :=3,;
          nMaxCol:=8

  nLine:=nIni

  IF !FILE(cFile)
     MsgMemo("Archivo "+cFile+" no Existe")
     RETURN {}
  ENDIF

  oExcel := TExcelScript():New()
  oExcel:Open( cFile )

  WHILE .T.

     aLine:=ARRAY(nMaxCol)
     AEVAL(aLine,{|a,nCol,cValue| cValue:=SPACE(200),aLine[nCol]:=oExcel:Get( nLine , nCol ,@cValue ) })

     IF Empty(aLine[1])
        EXIT
     ENDIF
  
     nLine++
     AADD(aData,ACLONE(aLine))

  ENDDO

 oExcel:End(.F.)

ViewArray(aData)

RETURN aData
// EOF
