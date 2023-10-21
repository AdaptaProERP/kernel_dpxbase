// Programa   : SETTEXTBTN
// Fecha/Hora : 14/10/2023 07:15:36
// Propósito  : Asingarle Texto a los Botones en los Browse
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cCodPrg)
    LOCAL cMemo,nAt,nAt2,cBtn,cFileScr,cFileDxB,nAt,cText:="",cVar:=""

    DEFAULT cCodPrg:="BRASIENTOSCOM"

    cCodPrg :=ALLTRIM(cCodPrg)
    cFileScr:="SCRIPT\"+ALLTRIM(cCodPrg)+".SCR"
    cFileDxB:="DPXBASE\"+ALLTRIM(cCodPrg)+".dxbx"

    cMemo:=SQLGET(oDp:cDpProgra,"PRG_TEXTO","PRG_CODIGO"+GetWhere("=",cCodPrg))

    cMemo:=SETBTNTEXT("XSAVE.BMP"            ,"Grabar")
    cMemo:=SETBTNTEXT("BRWMENU.BMP"          ,"Menú")
    cMemo:=SETBTNTEXT("XFIND.BMP"            ,"Buscar")
    cMemo:=SETBTNTEXT("XEDIT.BMP"            ,"Editar")
    cMemo:=SETBTNTEXT("XDELETE.BMP"          ,"Eliminar")
    cMemo:=SETBTNTEXT("FILTRAR.BMP"          ,"Filtrar")
    cMemo:=SETBTNTEXT("PRODUCTO.BMP"         ,"Producto")
    cMemo:=SETBTNTEXT("XBROWSE.BMP"          ,"Detalles")
    cMemo:=SETBTNTEXT("VENDEDOR.BMP"         ,"Vendedor")
    cMemo:=SETBTNTEXT("GRAPH.BMP"            ,"Gráficas")
    cMemo:=SETBTNTEXT("OPTIONS.BMP"          ,"Opciones")
    cMemo:=SETBTNTEXT("REFRESH.BMP"          ,"Refrescar")
    cMemo:=SETBTNTEXT("CRYSTAL.BMP"          ,"Crystal")
    cMemo:=SETBTNTEXT("recibodivisa.BMP"     ,"Recibo")
    cMemo:=SETBTNTEXT("CLIENTE.BMP"          ,"Cliente")
    cMemo:=SETBTNTEXT("VIEW.BMP"             ,"Consulta")
    cMemo:=SETBTNTEXT("documentocxc.BMP"     ,"CxC")
    cMemo:=SETBTNTEXT("MENUTRANSACCIONES.BMP","Transacc.")
    cMemo:=SETBTNTEXT("PRECIOS.BMP"          ,"Precio")
    cMemo:=SETBTNTEXT("EXCEL.BMP"            ,"Excel")
    cMemo:=SETBTNTEXT("html.BMP"             ,"Html")
    cMemo:=SETBTNTEXT("PREVIEW.BMP"          ,"Preview")
    cMemo:=SETBTNTEXT("XPRINT.BMP"           ,"Imprimir")
    cMemo:=SETBTNTEXT("xTOP.BMP"             ,"Primero")
    cMemo:=SETBTNTEXT("xSIG.BMP"             ,"Avance")
    cMemo:=SETBTNTEXT("xANT.BMP"             ,"Anterior")
    cMemo:=SETBTNTEXT("xFIN.BMP"             ,"Ultimo")
    cMemo:=SETBTNTEXT("XSALIR.BMP"           ,"Cerrar")

    // Agregamos el Alto de la Barra de botones

    IF !"DEFINE BUTTONBAR oBar SIZE oDp:nBtnWidth"$cMemo

      nAt:=AT("DEFINE BUTTONBAR",cMemo)

      IF nAt>0
         cMemo:=LEFT(cMemo,nAt-1)+[IF !oDp:lBtnText ]+CRLF+SPACE(5)+SUBS(cMemo,nAt,LEN(cMemo))
      ENDIF
  
      nAt:=AT("3D CURSOR oCursor",cMemo)

      IF nAt>0

         cMemo:=LEFT(cMemo,nAt+16)+CRLF+[   ELSE ]+CRLF+;
                [     DEFINE BUTTONBAR oBar SIZE oDp:nBtnWidth,oDp:nBarnHeight+6 OF oDlg 3D CURSOR oCursor ]+CRLF+;
                [   ENDIF ]+CRLF+;
                SUBS(cMemo,nAt+17,LEN(cMemo))

      ENDIF

    ENDIF

    nAt:=AT(":Close()",cMemo)

    IF nAt>0

      cVar:=SUBS(cMemo,nAt-20,40)
      nAt :=AT(":",cVar)
      cVar:=LEFT(cVar,nAt-1)
      nAt :=AT(" ",cVar)
      cVar:=ALLTRIM(SUBS(cVar,nAt,LEN(cVar)))

    ENDIF

    nAt:=AT(" DEFINE BUTTON ",cMemo)

    IF !Empty(cVar) .AND. nAt>0 .AND. ![oBrw:oLbx]$cMemo
   
      cMemo:=LEFT(cMemo,nAt)+;
             cVar+[:oFontBtn   :=oFont    ]+CRLF+;
             [   ]+cVar+[:nClrPaneBar:=oDp:nGris]+CRLF+;
             [   ]+cVar+[:oBrw:oLbx  :=]+cVar   +CRLF+;
             []+CRLF+SUBS(cMemo,nAt,LEN(cMemo))


    ENDIF


    SQLUPDATE(oDp:cDpProgra,"PRG_TEXTO",cMemo,"PRG_CODIGO"+GetWhere("=",cCodPrg))

    DPWRITE(cFileScr,cMemo)

//    WinExec(  GetWinDir()+ "\NOTEPAD.EXE "+cFileScr)
   
    FERASE(cFileDxB)
    EJECUTAR(cCodPrg)

RETURN

FUNCTION SETBTNTEXT(cBtnFind,cBtnText)
    LOCAL cBtn,nAt,nAt2,cBtnRun:=[  TOP PROMPT "]+cBtnText+["; ]

    cBtnFind:="BITMAPS\"+cBtnFind
    nAt     :=AT(cBtnFind,cMemo)

    IF nAt>0

      cBtn:=SUBS(cMemo,nAt,LEN(cMemo))
      nAt2:=AT(" ACTION ",cBtn)

      // Agrega la intruccion en caso de no existir
      IF !cBtnRun$cMemo

        cMemo:=LEFT(cMemo,nAt+nAt2-1)+;
               cBtnRun+CRLF+SPACE(13)+;
               " ACTION "+SUBS(cMemo,nAt+nAt2+6,LEN(cMemo))

      ENDIF

    ENDIF

RETURN cMemo
// EOF

