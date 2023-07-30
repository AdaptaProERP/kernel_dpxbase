// Programa   : MYSQLCHKCONN
// Fecha/Hora : 30/07/2023 08:28:18
// Propósito  : Validar el tiempo INACTIVO de la base de datos, evitar MySQL lo desconecte
// Creado Por : Juan Navas
// Llamado por: TMYTABLE
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(lRun,lSay,aDataBase)
  LOCAL I,oCon,aLine:={}
  LOCAL cText:="" 

  DEFAULT lRun     :=.F.,;
          lSay     :=.F.,;
          aDataBase:=MyGetDataBases()

  FOR I=1 TO LEN(aDataBase)

   oCon:=aDataBase[I,2]:oConnect

   IF oCon:nTimeMax>0 .AND. ABS(Seconds()-oCon:nSeconds) >= (oCon:nTimeMax) .OR. lRun

     MsgRun("ReConectando con BD "+ aDataBase[I,1])
     CLOSEODBC(aDataBase[I,1],.F.)
     MyOpenDataBase(aDataBase[I,1],.F.):oConnect:ReConnect()

   ENDIF

   aDataBase[I,2]:oConnect:nSeconds:=Seconds()

  NEXT I

RETURN .T.
// EOF
