// Programa   : DPINCREMENTAL
// Fecha/Hora : 25/05/2017 02:09:06
// Propósito  : Incrementador
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cNumero,lZero,nMas)
   LOCAL nAt  :=0,cChar:="",nLen:=0,lOk:=.F.
   LOCAL aMask:={"-",".","*"},nPos:=0,nLenOrg:=0
   LOCAL cPreFix:=""

   DEFAULT cNumero:="00-003455",;
           lZero  :=.T.,;
           nMas   :=1

   nPos   :=ASCAN(aMask,{|a,n|nAt:=RAT(a,cNumero),nAt>0 })
   nLenOrg:=LEN(cNumero)

   IF nPos>0
     cChar  :=aMask[nPos]
     cNumero:=ALLTRIM(cNumero)
   ENDIF

   IF !Empty(cChar)
     cPreFix:=LEFT(cNumero,nAt)
     cNumero:=SUBS(cNumero,nAt+1,LEN(cNumero))
   ENDIF

// ? nPos,nLenOrg,cNumero,cChar

   nLen:=LEN(cNumero)

   WHILE nAt<=nLen

     nAt++
     cChar:=SUBS(cNumero,nAt,1)

     IF cChar>="0" .AND. cChar<="9"
        lOk:=.T.
        EXIT
     ENDIF

   ENDDO

   IF lOk

     cChar  :=LEFT(cNumero,nAt-1)
     nLen   :=LEN(cNumero)-(nAt-1)

     IF lZero
       cNumero:=cChar+STRZERO(VAL(SUBS(cNumero,nAt,LEN(cNumero)))+nMas,nLen)
     ELSE
       cNumero:=cChar+PADR(LSTR(VAL(SUBS(cNumero,nAt,LEN(cNumero)))+nMas),nLen)
     ENDIF

   ELSE

     IF lZero .AND. (Empty(cNumero) .OR. ISDIGIT(cNumero))
       cNumero:=STRZERO(VAL(cNumero)+nMas,LEN(cNumero))
     ELSE
       cNumero:=ALLTRIM(STR(VAL(cNumero)+nMas))
     ENDIF

   ENDIF

   IF ValType(cNumero)="C" .AND. ISDIGIT(cNumero) .AND. lZero
     cNumero:=STRZERO(VAL(cNumero),LEN(cNumero))
   ENDIF

   cNumero:=cPreFix+PADR(cNumero,nLenOrg)

RETURN cNumero
// EOF
