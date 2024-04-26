// Programa   : DPPROCESOS_TO_PRG
// Fecha/Hora : 22/04/2024 00:40:31
// Propósito  : Exportar codigo fuente para exportar 
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cDir)
  LOCAL oTable,cFile

  DEFAULT cDir:="C:\XX\"

  oTable:=OpenTable("SELECT * FROM dpprocesos "+;
                    " INNER  JOIN DPPROCESOSMEMO ON DPPROCESOS.PRC_CODIGO = DPPROCESOSMEMO.PFP_CODIGO",.T.)

  WHILE !oTable:Eof()
     cFile:=lower(cDir+"PRC_"+ALLTRIM(oTable:PRC_CODIGO)+".PRG")
     DPWRITE(cFile,oTable:PFP_MEMO)
     oTable:DbSkip()
  ENDDO

  oTable:End()

