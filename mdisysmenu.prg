// Programa   : MDISYSMENU
// Fecha/Hora : 10/06/2003 01:21:56
// Prop¥sito  : Presentar Sysmenu
// Creado Por :
// Llamado por:
// Aplicaci¥n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

FUNCTION MAIN(oWnd,oMdi)
   LOCAL oSysMenu,bBlq1,bBlq2,bBlq3,bBlq4,bBlq5,bBlq6,bBlq7,bBlq8,bBlq9,bBlq10,bBlq11,bBlq12,bBlqVs
   LOCAL bBlqB2,cFile
   LOCAL bBlqF


   IF (oWnd=NIL) 

/*
      IF !oWnd=NIL   
         EJECUTAR("MDISYSMENUBRW",oWnd,oMdi)
      ENDIF
*/
      RETURN NIL
   ENDIF

//  oDp:lDpXbase:=.F.

   ISPCPRG()

   IF (oWnd=NIL)
      // .OR. !oDp:lDpXbase) 
      RETURN NIL
   ENDIF

   IF !__objHasMsg( oMdi, "lBarDef" )
      __objAddData( oMdi, "lBarDef")
      oMdi:lBarDef:=.F.
   ENDIF

   IF !__objHasMsg( oMdi, "oDlg" )
      __objAddData( oMdi, "oDlg")
      oMdi:oDlg:=oMdi
   ENDIF

   IF !__objHasMsg( oMdi, "lMdi" )
      __objAddData( oMdi, "lMdi")
      oMdi:lMdi:=.T.
   ENDIF

   IF !__objHasMsg( oMdi, "oBrw2" )
      __objAddData( oMdi, "oBrw2")
      oMdi:oBrw2:=NIL
   ENDIF


   DEFAULT oMdi:lBarDef:=.F.

   DEFAULT oMdi:oBrw2:=NIL

   PUBLICO("oMdi",oMdi)

   cFile:="DP\TEMP\"+oMdi:cScript+".SQL"

   IF FILE(cFile)

   ENDIF

   bBlq1:=[oMdi:End(),DPXBASEEDIT(3,"]+oMdi:cScript+[")]
   bBlq1:=BloqueCod(bBlq1)

   bBlqVs:=[oMdi:End(),EJECUTAR("RUNVSCODE","]+oMdi:cScript+[")]
   bBlqVs:=BloqueCod(bBlqVs)

   bBlq4:={||EJECUTAR("INSPECT",oMdi)}

   bBlq5 :={||EJECUTAR("BRWEDITCOL",oMdi)}

   IF ValType(oMdi:oBrw2)="O"
     bBlqB2:={||EJECUTAR("BRWEDITCOL",oMdi,oMdi:oBrw2,"2")}
   ENDIF

   bBlq6:={||EJECUTAR("BRWEDITSQL"  ,oMdi,.F.)}
   bBlq7:={||EJECUTAR("BRWEDITSQL"  ,oMdi,.T.)}
   bBlqF:={||EJECUTAR("BRWCAMPOSOPC",oMdi,.T.)}

// {||EJECUTAR("BRWCAMPOSOPC",oMdi,.T.)}


//   bBlq8:={||oMdi:lDesign:=.T.,DlgDesing(oMdi:oBar,.T.,.T.,oMdi)}

   bBlq8:={|oMdi|RunMacro("oMdi:lDesign:=.T.,DlgDesing(oMdi:oBar,.T.,.T.,oMdi)",oMdi)}


   bBlq10:={|oMdi|RunMacro("oMdi:lDesign:=.T.,SelControl(oMdi:oBar,oMdi)",oMdi)}

// bBlq8:={|oMdi|RunMacro("MensajeErr(oMdi:ClassName())",oMdi)}
// EVAL(bBlq8,oMdi)
// RETURN .T.

   bBlq9:=[oMdi:End(),EJECUTAR("SETCOLORDPGRIS","]+oMdi:cScript+["),DPXBASEEDIT(3,"]+oMdi:cScript+[")]
   bBlq9:=BloqueCod(bBlq9)

   bBlq10:={|oMdi|RunMacro("oMdi:lDesign:=.T.,SelControl(oMdi:oBar,oMdi)",oMdi)}
   bBlq10:=BloqueCod(bBlq10)

   bBlq12:=[oMdi:End(),EJECUTAR("SETTEXTBTN","]+oMdi:cScript+["),DPXBASEEDIT(3,"]+oMdi:cScript+[")]
   bBlq12:=BloqueCod(bBlq12)



   REDEFINE SYSMENU oSysMenu OF oWnd
   
   SEPARATOR

//   MenuAddItem( "&Editar Programa Fuente ["+oMdi:cScript+"]",, .F.,,bBlq1,,,,,,, .F.,,, .F. )

IF oDp:lDpXbase

   IF oDp:lTracer
     MenuAddItem( "&Inactivar Traza de Ejecución",, .F.,,{||oDp:lTracer:=!oDp:lTracer},,,,,,, .F.,,, .F. )
   ELSE
     MenuAddItem( "&Activar Traza de Ejecución",, .F.,,{||oDp:lTracer:=!oDp:lTracer},,,,,,, .F.,,, .F. )
   ENDIF

   IF oDp:lTracerSQL
     MenuAddItem( "&Inactivar Traza de SQL",, .F.,,{||oDp:lTracerSQL:=!oDp:lTracerSQL},,,,,,, .F.,,, .F. )
   ELSE
     MenuAddItem( "&Activar Traza de SQL",, .F.,,{||oDp:lTracerSQL:=!oDp:lTracerSQL},,,,,,, .F.,,, .F. )
   ENDIF

   MenuAddItem( "&Inspector ",, .F.,,bBlq4,,,,,,, .F.,,, .F. )

ENDIF

   MenuAddItem( "&Personalizar Columnas del Browse ",, .F.,,bBlq5 ,,,,,,, .F.,,, .F. )

   // IF !Empty(bBlqC)
     MenuAddItem( "&Personalizar Colores en los Campos",, .F.,,bBlqF ,,,,,,, .F.,,, .F. )
   // ENDIF

   IF !bBlqB2=NIL
     MenuAddItem( "&Personalizar Columnas del Browse [2] ",, .F.,,bBlqB2 ,,,,,,, .F.,,, .F. )
   ENDIF


   bBlq11:={||EJECUTAR("BRWSETFULLSCREEN",oMdi)}

   MenuAddItem( "&Pantalla Completa "               ,, .F.,,bBlq11,,,,,,, .F.,,, .F. )

//   IF __objHasMsg( oMdi, "cCodBrw")

     bBlq11:={||EJECUTAR("DPBRWSAVE",oMdi:oBrw,oMdi)}

     MenuAddItem( "&Guardar Consulta "               ,, .F.,,bBlq11,,,,,,, .F.,,, .F. )

     bBlq11:={||EJECUTAR("DPRUNBRWCOMP",oMdi)}

     MenuAddItem( "&Ejecutar Consulta "               ,, .F.,,bBlq11,,,,,,, .F.,,, .F. )

//   ENDIF


IF oMdi:lBarDef

   MenuAddItem( "&Activar Modo Diseño la Barra de Botones",, .F.,,bBlq8 ,,,,,,, .F.,,, .F. )
   MenuAddItem( "&Controles en la Barra de Botones"       ,, .F.,,bBlq10,,,,,,, .F.,,, .F. )



ENDIF

IF oDp:lDpXbase

   MenuAddItem( "&Copiar ClipBoard Sentencia SQL [TEMP\"+oMdi:cScript+".SQL]",, .F.,,bBlq6,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Ejecutar Sentencia SQL [TEMP\"+oMdi:cScript+".SQL]",, .F.,,bBlq7,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Implementar Definición de Colores en Programa Fuente ["+oMdi:cScript+"]",, .F.,,bBlq9,,,,,,, .F.,,, .F. )
   MenuAddItem( "Implementar &Textos  en los botones de la Barra ["+oMdi:cScript+"]",, .F.,,bBlq12,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Editar Programa Fuente VSCODE ["+oMdi:cScript+"]",, .F.,,bBlqVs,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Editar Programa Fuente ["+oMdi:cScript+"]",, .F.,,bBlq1,,,,,,, .F.,,, .F. )

ENDIF


   ENDMENU

RETURN NIL
