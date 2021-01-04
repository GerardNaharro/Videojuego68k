*-----------------------------------------------------------
* Title      : CHARACTER MANAGEMENT
* Written by : GERARD NAHARRO
* Date       :
* Description: 08-12-2020 - CREATION
*-----------------------------------------------------------

;-----------------------------------------------------------
CHARINIT
;INITIALIZE THE CHARACTER
;INPUT      -   NONE
;OUTPUT     -   NONE
;MODIFIES   -   NONE   
;-----------------------------------------------------------
                MOVE.W #32,(CHARX)
                MOVE.W #416,(CHARY)
                RTS




;-----------------------------------------------------------
CHARUPD
;UPDATES THE CHARACTER
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

                BTST.B  #KBDBITLF,(KBDVAL)   ; LEFT KEY PRESSED COMPROBATION
                BNE     .MOVEL               ; YES: MOVE LEFT
                BTST.B  #KBDBITRT,(KBDVAL)   ; RIHT KEY PRESSED COMPROBATION
                BNE     .MOVER               ; YES: MOVE RIGHT
                BTST.B  #KBDBITF1,(KBDVAL)   ; FIRE1 KEY PRESSED
                BNE     .SHOT                ; YES: SHOOT
                JSR     FALLING              ; CHECK IF IN THE AIR
                CMP.W   #$FF,D5
                BEQ     .FALL                ; FALL
                BTST.B  #KBDBITUP,(KBDVAL)   ; UP KEY PRESSED COMPROBATION
                BNE     .JUMP                ; YES: UP PRESSED
                RTS
                
.MOVEL         ;CHECK LEFT SIDE OF THE CHARACTER
               JSR      GETNXTL
               CMP.W    #$FF,D5              ; CHECK BLOCK CODE                
               BNE      .OBSTACLE            ; OBSTACLE FOUND
               SUB.W    #CHARSPED,(CHARX)    ; MOVE LEFT
*               MOVE.L (A7)+,D5
               BTST.B   #KBDBITF1,(KBDVAL)   ; FIRE1 KEY PRESSED
               BNE      .SHOTL               ; YES: SHOOT
               JSR      FALLING              ; CHECK IF IN THE AIR
               CMP.W    #$FF,D5
               BEQ      .FALL 
               BTST.B   #KBDBITUP,(KBDVAL)   ; UP KEY PRESSED COMPROBATION
               BNE      .JUMP                ; YES: UP PRESSED
               RTS
               
               
.OBSTACLE      ;DONT MOVE
*               MOVE.L (A7)+,D5
               JSR      FALLING              ; CHECK IF IN THE AIR
               CMP.W    #$FF,D5
               BEQ      .FALL
               BTST.B   #KBDBITUP,(KBDVAL)   ; UP KEY PRESSED COMPROBATION
               BNE      .JUMP                ; YES: UP PRESSED 
               RTS

.FALL          
               ADD.W    #CHARSPED-2,(CHARY)  ;FALL
               RTS


.MOVER         JSR      GETNXTR
               CMP.W    #$FF,D5              ; CHECK BLOCK CODE                
               BNE      .OBSTACLE            ; OBSTACLE FOUND
               ADD.W    #CHARSPED,(CHARX)    ; MOVE LEFT
*               MOVE.L (A7)+,D5
               BTST.B   #KBDBITF1,(KBDVAL)   ; FIRE1 KEY PRESSED
               BNE      .SHOT                ; YES: SHOOT
               JSR      FALLING              ; CHECK IF IN THE AIR
               CMP.W    #$FF,D5
               BEQ      .FALL
               BTST.B   #KBDBITUP,(KBDVAL)   ; UP KEY PRESSED COMPROBATION
               BNE      .JUMP                ; YES: UP PRESSED 
               RTS
               

.SHOT          MOVEM.L   A1-A3/D0,-(A7)     ;STACK REGISTER
               BTST.B    #1,(SCRCYCCT)      ;2 CYCLES
               BEQ      .END
               MOVE.W   #SHOTID,D0
               LEA      SHOTINIT,A1
               LEA      SHOTUPD,A2
               LEA      SHOTPLOT,A3
               JSR      AGLADD
               JSR      SHOTSND                            
.END           MOVEM.L  (A7)+,A1-A3/D0     ;STORE REGISTERS
               JSR      FALLING            ; CHECK IF IN THE AIR
               CMP.W    #$FF,D5
               BEQ      .FALL
               BTST.B  #KBDBITUP,(KBDVAL)   ; UP KEY PRESSED COMPROBATION
               BNE     .JUMP                ; YES: UP PRESSED
               RTS
               
.SHOTL         MOVEM.L  A1-A3/D0,-(A7)     ;STACK REGISTER
               BTST.B   #1,(SCRCYCCT)      ;16 CYCLES
               BEQ      .ENDL
               MOVE.W   #SHOTID,D0
               LEA      SHOTINIT,A1
               LEA      SHOTLUPD,A2
               LEA      SHOTPLOT,A3
               JSR      AGLADD
               JSR      SHOTSND                            
.ENDL          MOVEM.L  (A7)+,A1-A3/D0     ;STORE REGISTERS
               JSR      FALLING            ; CHECK IF IN THE AIR
               CMP.W    #$FF,D5
               BEQ      .FALL
               BTST.B  #KBDBITUP,(KBDVAL)   ; UP KEY PRESSED COMPROBATION
               BNE     .JUMP                ; YES: UP PRESSED
               RTS 

.JUMP          JSR      GETNXTU
               CMP.W    #$FF,D5                 ; CHECK BLOCK CODE                
               BNE      .NOJUMP                 ; OBSTACLE FOUND
               JSR      JUMPSND
               SUB.W    #CHARJUMP,(CHARY)       ; JUMP
*               MOVE.L (A7)+,D5
               JSR      FALLING                 ; CHECK IF IN THE AIR
               CMP.W    #$FF,D5
               BEQ      .FALL 
               RTS

.NOJUMP        RTS               
                           

;-----------------------------------------------------------
CHARPLOT
;PLOT THE CHARACTER
;INPUT      -   NONE
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
                MOVEM.L D0-D4,-(A7)     ;STACK REGISTER                               
                
                
                MOVE.B  #80,D0           ;SET PEN COLOR TASK
                MOVE.L  #CHARPCOL,D1     ;PEN COLOR
                TRAP    #15
                MOVE.B  #81,D0           ;SET FILL COLOR TASK
                MOVE.L  #CHARFCOL,D1     ;FILL COLOR
                TRAP    #15
                
                MOVE.W  (CHARX),D1       ;LEFT X
                MOVE.W  (CHARY),D2       ;UPPER Y
                MOVE.W  D1,D3            
                MOVE.W  D2,D4                
                ADD.W   #CHARBODY,D3     ;RIGHT X
                ADD.W   #CHARBODY,D4     ;LOWER Y
                MOVE.W  #87,D0           ;PAINT RECTANGLE TASK
                TRAP    #15
                
                ;LEFT EYE
                MOVE.B  #81,D0
                MOVE.L  #$00FFFFFF,D1
                TRAP    #15
                MOVE.W  (CHARX),D1       ;LEFT X
                MOVE.W  (CHARY),D2       ;UPPER Y
                ADD.W   #5,D1
                ADD.W   #5,D2
                MOVE.W  D1,D3            
                MOVE.W  D2,D4
                ADD.W   #5,D3
                ADD.W   #5,D4
                MOVE.B  #87,D0
                TRAP    #15
                ADD.W   #3,D1
                ADD.W   #3,D2
                MOVE.B  #82,D0
                TRAP    #15
                
                ;RIGHT EYE
                MOVE.W  (CHARX),D1       ;LEFT X
                MOVE.W  (CHARY),D2       ;UPPER Y
                ADD.W   #20,D1
                ADD.W   #5,D2
                MOVE.W  D1,D3            
                MOVE.W  D2,D4
                ADD.W   #5,D3
                ADD.W   #5,D4
                MOVE.B  #87,D0
                TRAP    #15
                ADD.W   #3,D1
                ADD.W   #3,D2
                MOVE.B  #82,D0
                TRAP    #15
                
                ;MOUTH
                MOVE.W  (CHARX),D1       ;LEFT X
                MOVE.W  (CHARY),D2       ;UPPER Y

                ADD.W   #5,D1
                ADD.W   #15,D2
                MOVE.W  D1,D3
                MOVE.W  D2,D4
                ADD.W   #6,D4
                ADD.W   #20,D3
                MOVE.B  #87,D0
                TRAP    #15
            
                
                MOVEM.L (A7)+,D0-D4     ;STORE REGISTERS
                
                RTS  


        























*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
