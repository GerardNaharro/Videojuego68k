*-----------------------------------------------------------
* TITLE      : SHOTS MANAGEMENT
* AUTHOT     : GERARD NAHARRO
* DATE       : SHOT AGENT LOCAL VARIABLES:
*               (AO) : SHOTX - WORD       
*              2(A0) : SHOTY - WORD       
*              4(A0) : INLSHOTX - WORD    
* Description: 15-12-2020 - CREATION
*-----------------------------------------------------------


;-----------------------------------------------------------
SHOTINIT
;INITIALIZE THE SHOT
;INPUT      -   NONE
;OUTPUT     -   NONE
;MODIFIES   -   NONE   
;-----------------------------------------------------------
                MOVE.L      D1,-(A7)     ;STACK REGISTER
                CLR.L       D1
                MOVE.W      (CHARX),D1
                ADD.W       #5,D1
                MOVE.W      D1,(A0)
                CLR.L       D1
                MOVE.W      (CHARY),D1
                ADD.W       #15,D1
                MOVE.W      D1,2(A0)
                MOVE.W      (CHARX),4(A0)
                MOVE.L      (A7)+,D1
                RTS
;-----------------------------------------------------------
SHOTUPD
;UPDATES THE SHOT
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
*                CMP.W 4(A0)+#MAXSHOTD, (A0)

                MOVEM.L     D0-D1,-(A7)     ;STACK REGISTER
                JSR         GETNXTRS
                CMP.W       #$FF,D5
                BNE         .STOP
                MOVE.W      4(A0),D0
                ADD.W       #SHOTMAXD,D0
                MOVE.W      (A0),D1
                CMP.W       D0,D1                
                BLT         .MOVE
.STOP           JSR         AGLKILL         ;KILL THE AGENT
                MOVEM.L     (A7)+,D0-D1     ;STORE REGISTERS
                RTS
.MOVE           ADD.W       #SHOTSPED,(A0)
                MOVEM.L     (A7)+,D0-D1     ;STORE REGISTERS
                RTS 
;-----------------------------------------------------------
SHOTLUPD
;UPDATES THE SHOT
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
*                CMP.W 4(A0)-#MAXSHOTD, (A0)

                MOVEM.L D0-D1,-(A7)     ;STACK REGISTER
                JSR         GETNXTLS
                CMP.W       #$FF,D5
                BNE         .STOP
                MOVE.W 4(A0),D0
                SUB.W #SHOTMAXD,D0
                MOVE.W (A0),D1
                CMP.W D0,D1                
                BGT .MOVE
.STOP           JSR AGLKILL             ;KILL THE AGENT
                MOVEM.L (A7)+,D0-D1     ;STORE REGISTERS
                RTS
.MOVE           SUB.W #SHOTSPED,(A0)
                MOVEM.L (A7)+,D0-D1     ;STORE REGISTERS
                RTS                                       
;-----------------------------------------------------------
SHOTPLOT
;PLOT THE SHOT
;INPUT      -   NONE
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
                MOVEM.L D0-D4,-(A7)     ;STACK REGISTER
                
                MOVE.B #80,D0           ;SET PEN COLOR TASK
                MOVE.L #SHOTCOL,D1      ;PEN COLOR
                TRAP #15
                MOVE.W (A0),D1        ;INITIAL X
                MOVE.W 2(A0),D2       ;INITIAL Y
*                MOVE.W (A0)+#SHOTLONG, D3 
                MOVE.W (A0),D3
                ADD.W #SHOTLONG,D3     ;FINAL X
                MOVE.W 2(A0),D4        ;FINAL Y
                MOVE.W #84,D0          ;PAINT LINE TASK
                TRAP #15
                
                MOVEM.L (A7)+,D0-D4     ;STORE REGISTERS

                RTS  
                
                





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
