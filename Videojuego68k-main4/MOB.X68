*-----------------------------------------------------------
* Title      : MOB MANAGEMENT(AGENT)
* AUTHOR     :  GERARD NAHARRO AND LUCAS ORTIZ
* COMMENTS   :  MOB VAR.
*                (A0)=X
*               2(A0)=Y
*               4(A0)=INITIAL X
*               6(A0)=BACKWARD(1)/FORWARD(0)
* Description:
*-----------------------------------------------------------
;----------------------------------------------------------
MOBINIT
;INITIALIZES THE MOB 
;
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;----------------------------------------------------------
            MOVEM.L  D1-D2,-(A7)       ;STACK REGISTER
            MOVE.W   (MOBY),D1
            MOVE.W   D1,2(A0)
            MOVE.W   (MOBX),D2
            MOVE.W   D2,(A0)
            MOVE.W   D2,4(A0)        ;STORING INITIAL X
            CLR      6(A0)           ;SET 0 / GOING FORWARD
            MOVEM.L  (A7)+,D1-D2     ;STORE REGISTER
            RTS
            
;----------------------------------------------------------
MOBUPDS
;UPDATES THE MOB IN A SHORT WAY
;
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;----------------------------------------------------------
            MOVEM.L  D1-D5,-(A7)            ;STACK REGISTER
            
            MOVE.W  (CHARX),D4              ;LEFT CHAR X
            MOVE.W  (CHARY),D5              ;UPPER CHAR Y
            ADD.W   #CHARBODY,D4            ;RIGHT CHAR X
            ADD.W   #CHARBODY-2,D5          ;NEAR BOTTOM CHAR Y TO CHECK IF FALLING ON TOP OF A MOB
            MOVE.W  (A0),D3                 ;MOB LEFT X
            MOVE.W  2(A0),D1                ;MOB UPPER Y
            CMP.W   D5,D1
            BLE     .BETWEEN1
            BRA     .UPDATE
            
.BETWEEN1   ADD.W   #MOBLINE,D1
            CMP.W   D5,D1
            BGE     .BETWEEN2
            BRA     .UPDATE
            
.BETWEEN2   CMP.W   D4,D3
            BLE     .BETWEEN3               ;HITTING LEFT?
            BRA     .RIGHT                  ;HITTING RIGHT?

.BETWEEN3   ADD.W   #MOBLINE,D3
            CMP.W   D4,D3
            BGE     .BETWEEN4               ;HITTING LEFT
            BRA     .RIGHT            

.BETWEEN4   SUBQ.B  #1,D6                   ;HIT
            CMP.B   #0,D6                   ;DEAD == GOVER
            BEQ     .NOLIFES
            MOVE.W  #32,(CHARX)             ;GO TO SPAWN
            MOVE.W  #416,(CHARY)            ;GO TO SPAWN
            JSR     CHARDSND
            BRA     .UPDATE
            
.RIGHT      ;D3 MOB LEFT X
            ;D4 RIGHT CHAR X
            SUB.W   #MOBLINE,D3
            SUB.W   #CHARBODY,D4
            CMP.W   D4,D3
            BLE     .RIGHT2
            BRA     .UPDATE

.RIGHT2     ADD.W   #MOBLINE,D3             ;RIGHT MOB X
            CMP.W   D4,D3
            BGE     .BETWEEN4
            BRA     .UPDATE    
            
.NOLIFES    MOVE.W  #STAGOVER,(STANEXT)
            MOVEM.L  (A7)+,D1-D5            ;STORE REGISTER
            RTS            
            
            
.UPDATE     CMPI.W  #1,6(A0)                ;ONCE REACHED 
            BEQ     .VUELTA
            MOVE.W  4(A0),D2
            ADD.W   #100,D2                 ;OBTAIN MAX. DISTANCE
            MOVE.W  (A0),D3             
            CMP.W   D2,D3
            BEQ     .AVOLVER
            ADDQ.W  #MOBSPEED,(A0)          ;X=X+2
.END        
            MOVEM.L  (A7)+,D1-D5            ;STORE REGISTER
            RTS
.VUELTA     MOVE.W  4(A0),D2
            MOVE.W  (A0),D3
            CMP.W   D2,D3
            BEQ     .DEVUELTA
            SUB.W   #MOBSPEED,(A0)          ;X=X-2
            BRA     .END
.DEVUELTA   MOVE.W  #0,6(A0)
            BRA     .END            
.AVOLVER    MOVE.W  #1,6(A0)            
            BRA     .END            
;----------------------------------------------------------
MOBUPDM
;UPDATES THE MOB IN A MEDIUM WAY
;
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;----------------------------------------------------------
             MOVEM.L  D1-D5,-(A7)            ;STACK REGISTER
            
            MOVE.W  (CHARX),D4              ;LEFT CHAR X
            MOVE.W  (CHARY),D5              ;UPPER CHAR Y
            ADD.W   #CHARBODY,D4            ;RIGHT CHAR X
            ADD.W   #CHARBODY-2,D5          ;NEAR BOTTOM CHAR Y TO CHECK IF FALLING ON TOP OF A MOB
            MOVE.W  (A0),D3                 ;MOB LEFT X
            MOVE.W  2(A0),D1                ;MOB UPPER Y
            CMP.W   D5,D1
            BLE     .BETWEEN1
            BRA     .UPDATE
            
.BETWEEN1   ADD.W   #MOBLINE,D1
            CMP.W   D5,D1
            BGE     .BETWEEN2
            BRA     .UPDATE
            
.BETWEEN2   CMP.W   D4,D3
            BLE     .BETWEEN3               ;HITTING LEFT?
            BRA     .RIGHT                  ;HITTING RIGHT?

.BETWEEN3   ADD.W   #MOBLINE,D3
            CMP.W   D4,D3
            BGE     .BETWEEN4               ;HITTING LEFT
            BRA     .RIGHT            

.BETWEEN4   SUBQ.B  #1,D6                   ;HIT
            CMP.B   #0,D6                   ;DEAD == GOVER
            BEQ     .NOLIFES
            MOVE.W  #32,(CHARX)             ;GO TO SPAWN
            MOVE.W  #416,(CHARY)            ;GO TO SPAWN
            JSR     CHARDSND
            BRA     .UPDATE
            
.RIGHT      ;D3 MOB LEFT X
            ;D4 RIGHT CHAR X
            SUB.W   #MOBLINE,D3
            SUB.W   #CHARBODY,D4
            CMP.W   D4,D3
            BLE     .RIGHT2
            BRA     .UPDATE

.RIGHT2     ADD.W   #MOBLINE,D3             ;RIGHT MOB X
            CMP.W   D4,D3
            BGE     .BETWEEN4
            BRA     .UPDATE    
            
.NOLIFES    MOVE.W  #STAGOVER,(STANEXT)
            MOVEM.L  (A7)+,D1-D5            ;STORE REGISTER
            RTS            
            
            
.UPDATE     CMPI.W  #1,6(A0)                ;ONCE REACHED 
            BEQ     .VUELTA
            MOVE.W  4(A0),D2
            ADD.W   #200,D2                 ;OBTAIN MAX. DISTANCE
            MOVE.W  (A0),D3             
            CMP.W   D2,D3
            BEQ     .AVOLVER
            ADDQ.W  #MOBSPEED,(A0)          ;X=X+2
.END        
            MOVEM.L  (A7)+,D1-D5            ;STORE REGISTER
            RTS
.VUELTA     MOVE.W  4(A0),D2
            MOVE.W  (A0),D3
            CMP.W   D2,D3
            BEQ     .DEVUELTA
            SUB.W   #MOBSPEED,(A0)          ;X=X-2
            BRA     .END
.DEVUELTA   MOVE.W  #0,6(A0)
            BRA     .END            
.AVOLVER    MOVE.W  #1,6(A0)            
            BRA     .END             
;----------------------------------------------------------
MOBUPDL
;UPDATES THE MOB IN A LONG WAY
;
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;----------------------------------------------------------
            MOVEM.L  D1-D5,-(A7)            ;STACK REGISTER
            
            MOVE.W  (CHARX),D4              ;LEFT CHAR X
            MOVE.W  (CHARY),D5              ;UPPER CHAR Y
            ADD.W   #CHARBODY,D4            ;RIGHT CHAR X
            ADD.W   #CHARBODY-2,D5          ;NEAR BOTTOM CHAR Y TO CHECK IF FALLING ON TOP OF A MOB
            MOVE.W  (A0),D3                 ;MOB LEFT X
            MOVE.W  2(A0),D1                ;MOB UPPER Y
            CMP.W   D5,D1
            BLE     .BETWEEN1
            BRA     .UPDATE
            
.BETWEEN1   ADD.W   #MOBLINE,D1
            CMP.W   D5,D1
            BGE     .BETWEEN2
            BRA     .UPDATE
            
.BETWEEN2   CMP.W   D4,D3
            BLE     .BETWEEN3               ;HITTING LEFT?
            BRA     .RIGHT                  ;HITTING RIGHT?

.BETWEEN3   ADD.W   #MOBLINE,D3
            CMP.W   D4,D3
            BGE     .BETWEEN4               ;HITTING LEFT
            BRA     .RIGHT            

.BETWEEN4   SUBQ.B  #1,D6                   ;HIT
            CMP.B   #0,D6                   ;DEAD == GOVER
            BEQ     .NOLIFES
            MOVE.W  #32,(CHARX)             ;GO TO SPAWN
            MOVE.W  #416,(CHARY)            ;GO TO SPAWN
            JSR     CHARDSND
            BRA     .UPDATE
            
.RIGHT      ;D3 MOB LEFT X
            ;D4 RIGHT CHAR X
            SUB.W   #MOBLINE,D3
            SUB.W   #CHARBODY,D4
            CMP.W   D4,D3
            BLE     .RIGHT2
            BRA     .UPDATE

.RIGHT2     ADD.W   #MOBLINE,D3             ;RIGHT MOB X
            CMP.W   D4,D3
            BGE     .BETWEEN4
            BRA     .UPDATE    
            
.NOLIFES    MOVE.W  #STAGOVER,(STANEXT)
            MOVEM.L  (A7)+,D1-D5            ;STORE REGISTER
            RTS            
            
            
.UPDATE     CMPI.W  #1,6(A0)                ;ONCE REACHED 
            BEQ     .VUELTA
            MOVE.W  4(A0),D2
            ADD.W   #260,D2                 ;OBTAIN MAX. DISTANCE
            MOVE.W  (A0),D3             
            CMP.W   D2,D3
            BEQ     .AVOLVER
            ADDQ.W  #MOBSPEED,(A0)          ;X=X+2
.END        
            MOVEM.L  (A7)+,D1-D5            ;STORE REGISTER
            RTS
.VUELTA     MOVE.W  4(A0),D2
            MOVE.W  (A0),D3
            CMP.W   D2,D3
            BEQ     .DEVUELTA
            SUB.W   #MOBSPEED,(A0)          ;X=X-2
            BRA     .END
.DEVUELTA   MOVE.W  #0,6(A0)
            BRA     .END            
.AVOLVER    MOVE.W  #1,6(A0)            
            BRA     .END             
;----------------------------------------------------------

MOBPLOT
;----------------------------------------------------------
            MOVEM.L     D0-D4,-(A7)
            MOVE.B      #80,D0
            MOVE.L      #MOBPCOL,D1
            TRAP        #15
            ADDQ.B      #1,D0
            MOVE.L      #MOBFCOL,D1
            TRAP        #15
            MOVE.W      (A0),D1
            MOVE.W      2(A0),D2
            MOVE.W      D1,D3
            MOVE.W      D2,D4
            ADD.W       #MOBLINE,D3
            ADD.W       #MOBLINE,D4
            MOVE.B      #87,D0
            TRAP        #15               ;DRAW SQUARE
            MOVE.B      #80,D0
            MOVE.L      #00000000,D1      ;PEN COLOR BLACK
            TRAP        #15
            ADDQ.B      #1,D0
            MOVE.L      #00000000,D1      ;FILL COLOR BLACK
            TRAP        #15
            
            ;LEFT EYE
            MOVE.B  #81,D0
            MOVE.L  #$00FFFFFF,D1
            TRAP    #15
            MOVE.W  (A0),D1        ;LEFT X
            MOVE.W  2(A0),D2       ;UPPER Y
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
            MOVE.W  (A0),D1        ;LEFT X
            MOVE.W  2(A0),D2       ;UPPER Y
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
            MOVE.W  (A0),D1        ;LEFT X
            MOVE.W  2(A0),D2       ;UPPER Y

            ADD.W   #5,D1
            ADD.W   #15,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #6,D4
            ADD.W   #20,D3
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L     (A7)+,D0-D4
            RTS
            
            
            










*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
