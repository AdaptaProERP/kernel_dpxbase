// Programa   : MENUADAPTAPRO
// Fecha/Hora : 01/08/2017 09:30:03
// Propósito  : Ejecutar desde el Menú las Opciones directas desde AdaptaPro
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oMenu)
   LOCAL oItem

//   IF oMenu=NIL
//      RETURN NIL
//  ENDIF

   // Funciones del Usuario 
   DEFAULT oDp:lEservice:=.T. 

   EJECUTAR("MENUFONT")

   oDp:oFontMenu:=NIL

   C5MENUITEM oDp:oItemOficina PROMPT " Oficina Virtual ";
              ACCELERATOR ACC_CONTROL,ASC("M");
              FONT   oDp:oFontMenu


   C5MENU COLOR    oDp:nMenuItemClrText, oDp:nMenuItemClrPane;
          COLORSEL oDp:nMenuItemSelText, oDp:nMenuItemSelPane;
          COLORBOX oDp:nMenuBoxClrText ;
          FONT   oDp:oFontMenu;
          HEIGHT oDp:nMenuHeight; 
          LOGO oDp:cBmpMacros ;
          LOGOCOLOR oDp:nMenuMainClrText

   IF Empty(GETLLAVE_DATA("LIC_NUMERO")) .OR. .T.

     C5MENUITEM oItem PROMPT "Activar Licencia ";
                FONT   oDp:oFontMenu;
                ACTION ACTIVAR_LICENCIA()

     C5SEPARATOR

     C5MENUITEM oItem PROMPT "Afiliación eManager en AdaptaPro Server ";
                FONT   oDp:oFontMenu;
                ACTION EJECUTAR("EMANAGER")

     C5MENUITEM oItem PROMPT "Actualizar eManager ";
                ACTION EJECUTAR("DPEMMENU");
                FONT   oDp:oFontMenu;
                WHEN !Empty(oDp:nIdEmanager)

IF oDp:cType="SGE"
/*
     C5MENUITEM oItem PROMPT "Actualizar ePedidos ";
                ACTION EJECUTAR("EMANAGERMNU");
                FONT   oDp:oFontMenu;
                WHEN !Empty(oDp:nIdEmanager)
*/
ENDIF

     C5SEPARATOR
 
   ENDIF



   C5MENUITEM oItem PROMPT "Solicitud Asistencia Virtual ";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPREGSOPORTE",1,nil,NIL,"Asistencia")

   C5MENUITEM oItem PROMPT "Registro de Incidencia";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPREGSOPORTE",1,nil,NIL,"Incidencia")


   C5MENUITEM oItem PROMPT "Solicitud de Mejoras";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPREGSOPORTE",1,nil,NIL,"Mejoras")

   C5MENUITEM oItem PROMPT "Solicitud de Cambios Regulatorios";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPREGSOPORTE",1,nil,NIL,"Cambio Regulatorio")

   C5SEPARATOR

   C5MENUITEM oItem PROMPT "Histórico de Solicitud Asistencia Virtual [eService]";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("LBXREGSOPORTE")


   C5MENUITEM oItem PROMPT "Subir Registros de Soporte";
              FILE "bitmaps\upload2.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPREGSOPORTEUPLOAD")

   IF !ISADPSERVERLOCAL()

     C5MENUITEM oItem PROMPT "Descargar Respuestas de Soporte";
                FILE "bitmaps\download2.bmp";
                FONT   oDp:oFontMenu;
                ACTION EJECUTAR("BRDPREGSOPORTE")

   ELSE

     C5MENUITEM oItem PROMPT "Descargar Solicitudes de Soporte";
                FILE "bitmaps\download2.bmp";
                FONT   oDp:oFontMenu;
                ACTION EJECUTAR("BRDPREGSOPORTE")

   ENDIF

   C5SEPARATOR

   C5MENUITEM oItem PROMPT "Activar Traza de Ejecución para detectar Incidencias";
              FILE "bitmaps\auditoria2.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("TRACER")

   C5SEPARATOR

   C5MENUITEM oItem PROMPT "Proyectos de Implementación";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION MsgAlert("AQUI ES");
              WHEN .F.

   C5MENUITEM oItem PROMPT "Descargar Datos para Demostrativos";
              ACTION EJECUTAR("DATADEMO");
              FONT   oDp:oFontMenu;
              WHEN .T.


   C5MENUITEM oItem PROMPT "Descargar y Comprar Add-On del Sistema";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPADDONSHOP");
              WHEN .F.

/*
   C5MENUITEM oItem PROMPT "Activar Licencia";
              FILE "bitmaps\eservice.bmp";
              ACTION ACTIVAR_LICENCIA();
              WHEN .F.
*/
   C5MENUITEM oItem PROMPT "Extender Licencia";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION MsgAlert("AQUI ES");
              WHEN .F.

   C5MENUITEM oItem PROMPT "Evalúenos para mejorar Nuestros Productos y Servicios";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION DPEVALUENOS() 

   C5MENUITEM oItem PROMPT "Boletín de Novedades del Sistema";
              FILE "bitmaps\eservice.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("BRNOTRELEASE") 

   C5MENUITEM oItem PROMPT "Descargar Actualización del Sistema";
              FILE "bitmaps\download2.bmp";
              FONT   oDp:oFontMenu;
              WHEN oDp:lDownLoad;
              ACTION DPSVRDOWN()

   C5MENUITEM oItem PROMPT "Descargar y Ejecutar ServicePack";
              FILE "bitmaps\download2.bmp";
              FONT   oDp:oFontMenu;
              WHEN oDp:lDownLoad;
              ACTION EJECUTAR("INSTALLSERVICEPACK")


   C5SEPARATOR

   C5MENUITEM oItem PROMPT "Descargar Personalizaciones del Sistema";
              FILE "bitmaps\download2.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPAPTGETPERSONALIZA");
              WHEN oDp:lDownPerson

/*
   C5MENUITEM oItem PROMPT "Actualización Local Sistema";
              FILE "bitmaps\download2.bmp";
              ACTION EJECUTAR("DPAPLDIRGET");
              WHEN oDp:lDownLocal
*/
   C5MENUITEM oItem PROMPT "Actualización Local del Sistema";
              FILE "bitmaps\download2.bmp";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("DPSVRDOWNLOCAL");
              WHEN oDp:lDownLocal

/*
// 28/11/2022 
   C5SEPARATOR
 
   C5MENUITEM oItem PROMPT "Exportar y Transacciones hacia AdaptaPro Server";
              ACTION EJECUTAR("DPMODSOLRUN2")

   C5SEPARATOR
*/

   C5MENUITEM oItem PROMPT "Datos de la Licencia";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("VERDATLIC")

   C5MENUITEM oItem PROMPT "Exclusivo Aliados Comerciales";
              FONT   oDp:oFontMenu;
              ACTION EJECUTAR("OVLOGIN") ;
              WHEN "TEST"$oDp:cCodApl .OR. ISPCPRG()



   C5ENDMENU                                                                                         

RETURN NIL
// EOF
