// Programa   : OSDELTEMP
// Fecha/Hora : 03/11/2024 06:20:14
// Propósito  : Remueve Archivos temporales del OS
// Creado Por : Juan Navas
// Llamado por: Discresional
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cDrive,lClean)
   LOCAL cTemp:=GetEnv("LOCALAPPDATA"),aFiles:={}
   LOCAL aDir :={},I,U,cDir,cDir2,aFiles2:={}
   LOCAL cWin :=GetEnv("Windir")
   LOCAL cBin :=""
   LOCAL cFile:="OSCLEANTMP.TXT"
 
   DEFAULT cDrive:="",;
           lClean:=!Empty(cDrive)

        
   cTemp:=IF(!Empty(cTemp),cTemp+"\Temp\",cTemp)

   IF !Empty(cTemp)
      // aFiles:=DIRECTORY(cTemp+"\*.")
      aFiles:=DIRECTORY(cTemp+"*.*", "V")
   ENDIF

   AEVAL(aFiles,{|a,n| FERASE(cTemp+a[1])})

   aDir:=DIRECTORY(cTemp+"*.*", "D")

   FOR I=1 TO LEN(aDir)

     IF aDir[I,2]<>0
       FERASE(cTemp+aDir[I,1])
     ENDIF

     cDir  :=cTemp+aDir[I,1]
     ferase(cDir)

     aFiles:=DIRECTORY(cDir+"\*.*","V")

     AEVAL(aFiles,{|a,n| FERASE(cDir+"\"+a[1])})

     // Busca los subdirectorios
     FOR U=1 TO LEN(aFiles)

         cDir2  :=cDir+aFiles[U,1]
         ferase(cDir2)
         aFiles2:=DIRECTOY(cDir2+"\*.*","V")
         AEVAL(aFiles2,{|a,n| FERASE(cDir2+"\"+a[1])})
         EJECUTAR("DELDIR",cDir2)
     NEXT 

     EJECUTAR("DELDIR",cDir)

   NEXT I

   cBin:=cWin+"\SYSTEM32\cleanmgr.exe "+cDrive

   // Ejecuta limpiar disco duro
   IF lClean .AND. FILE(cBin)
      MsgRun("Ejecutando "+cBin)
      WinExec(cBin)
   ENDIF
  
   DPWRITE(cFile,DTOS(oDp:dFecha))


RETURN .T.
// EOF
