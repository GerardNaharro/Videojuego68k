*-----------------------------------------------------------
* Title      : MOB MANAGEMENT(AGENT)
* AUTHOR     :  Gerard y Lucas
* COMMENTS   :  MOB VAR.
*               (A0)=XVECTOR
*               2(A0)=YVECTOR 
* Description:
*-----------------------------------------------------------
;----------------------------------------------------------
MOBINIT
;INITIALIZE AN ENEMY/MOB
;----------------------------------------------------------
*            MOVE.W #MOBX,(A0)         ;Por ahora es constante, porque no  
*            MOVE.W #MOBY,2(A0)        ; sabia como hacer que accediese a
*                                      ; un DC, mañana sigo. 

            MOVEM.L  D1-D2,-(A7)     ;STACK REGISTER
            MOVE.W   #113,(MOBY)
            MOVE.W   (MOBY),D1
            MOVE.W   D1,2(A0)
            MOVE.W   #62,(MOBX)
            MOVE.W   (MOBX),D2
            MOVE.W   D2,(A0)
            MOVEM.L  (A7)+,D1-D2     ;STORE REGISTER
            RTS
            
;----------------------------------------------------------

MOBUPD
;----------------------------------------------------------
            CMPI.W  #1,(VOLVER)             ;ONCE REACHED 
            BEQ  .VUELTA
            CMP.W  #124,(A0)
            BEQ  .AVOLVER
            ADDQ.W #MOBSPEED,(A0)           ;XVECTOR=XVECTOR+2
.END            
            RTS
.VUELTA     CMPI.W  #52,(A0)
            BEQ  .DEVUELTA
            SUB.W   #MOBSPEED,(A0)          ;XVECTOR=XVECTOR-2
            BRA     .END
.DEVUELTA   MOVE.W  #0,(VOLVER)
            BRA     .END            
.AVOLVER    MOVE.W  #1,(VOLVER)            
            BRA     .END            
;----------------------------------------------------------

MOBPLOT
;----------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            MOVE.B  #80,D0
            MOVE.L  #MOBPCOL,D1
            TRAP    #15
            ADDQ.B  #1,D0
            MOVE.L  #MOBFCOL,D1
            TRAP    #15
            MOVE.W (A0),D1
            MOVE.W 2(A0),D2
            MOVE.W D1,D3
            MOVE.W D2,D4
            SUB.W  #MOBLINE/2,D1
            SUB.W  #MOBLINE/2,D2
            ADD.W  #MOBLINE/2,D3
            ADD.W  #MOBLINE/2,D4
            MOVE.B #87,D0
            TRAP    #15               ;Draw square
            MOVEM.L (A7)+,D0-D4
            RTS
*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
