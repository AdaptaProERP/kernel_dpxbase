// Programa   : MYSQL_TEST
// Fecha/Hora : 24/06/2023 06:14:14
// Prop�sito  :
// Creado Por :
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
   LOCAL _MycIp    :=ENCRIPT("192.168.10.13",.T.)
   LOCAL _MycPass  :=ENCRIPT("root",.T.)
   LOCAL _MycLoging:=ENCRIPT("root",.T.)
   LOCAL _MySqlPort:=3306
   LOCAL cFileMem  :="MYSQL_TEST.MEM"

   SAVE TO (cFileMem) ALL LIKE _My*

RETURN
