// Programa   : WhatsAppSend
// Fecha/Hora : 19/11/2023 04:40:11
// https://forums.fivetechsupport.com/viewtopic.php?f=6&t=43787&start=30
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cPhone,cMsg,aAttach)

   DEFAULT cPhone :="+58 412-0905509",;
           cMsg   :="Hola Patricia buen día, hoy "+dtoc(oDp:dFecha)+" hora"+TIME()+", soy AdaptaPro,"+CRLF+"ahora podrá envia comunicados y facturas desde AdaptaPro"+CRLF+"*Buen día,funcionalidad implementada*",;
           aAttach:={oDp:cBin+"bitmaps\datapro.bmp"}

   SendToWhatsApp( cPhone, cMsg, aAttach )

RETURN NIL

FUNCTION SendToWhatsApp( cPhone, cMsg, aAttach )
   LOCAL oShell, hBmp
   LOCAL aSend := {},I

   FOR I=1 TO LEN(aAttach)

      hBmp:=NViewLib32( aAttach[I], 1 )

      IF !Empty(hBmp) .AND. .F.
        AAdd( aSend, hBmp )
      ELSE
        AAdd( aSend, CRLF +aAttach[I])
      ENDIF

   NEXT I

   cMsg  := StrTran( cMsg, CRLF, "%0D%0A" )

   oShell := CreateObject( "WScript.Shell" )
   ShellExecute( 0, "Open", "whatsapp://send?phone="+cPhone+"&text="+cMsg )
   SysWait( 0.5 )

/*
// Nos falta implementar las imágenes
   AEval( aSend, {|u| CopyClipBoard(u),;
                      SysWait( 1 ),;
                      oShell:SendKeys( "^v" ),;
                      SysWait( 1 ) })

   oShell:SendKeys("~")
*/
   oShell:SendKeys("~")
   oShell:SendKeys("~")


RETURN
// EOF
