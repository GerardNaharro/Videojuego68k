; =============================================================================
; TITLE    : GAME STATE MANAGEMENT
; AUTHOR   : ANTONI BURGUERA
; HISTORY  : XX-XXX-201X - CREATION
;            11-OCT-2020 - MINOR CHANGES
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #-1,(STACUR)            ; INVALID STATE, JUST TO FORCE INIT
            MOVE.W  #0,(STANEXT)            ; INITIAL STATE
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAMAP1I,STAGOVRI,STAMAP2I,STAMAP3I,STAMAP4I,STAWONI,STAMAP5I,STAMAP6I,STACCSI
.UPDTBL     DC.L    STAINTRU,STAMAP1U,STAGOVRU,STAMAP2U,STAMAP3U,STAMAP4U,STAWONU,STAMAP5U,STAMAP6U,STACCSU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAMAP1P,STAGOVRP,STAMAP2P,STAMAP3P,STAMAP4P,STAWONP,STAMAP5P,STAMAP6P,STACCSP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS
   

         
; -----------------------------------------------------------------------------
STAINTRI
; GAME INTRO INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------       
            RTS

; -----------------------------------------------------------------------------
STAINTRU
; GAME INTRO UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR INTROSND
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STACCS,(STANEXT)
            
.END            RTS

; -----------------------------------------------------------------------------
STAINTRP
; GAME INTRO PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L  D0-D4/A0-A1,-(A7)      ;STACK REGISTERS
            LEA      BITMAP,A0
*            MOVE.W #$FF00,D1
*            MOVE.W #11,D0
*            TRAP #15
            MOVE.W  #418,D3  
            MOVE.W  #258,D4  
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #219,D1
            MOVE.W  #220,D2
.LOOP        
           
            BRA     .COLOR
.HERE
            MOVE.W  #82,D0
            TRAP    #15
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #219,D1
            CMP.W   D4,D2
            BLE     .LOOP
            BRA     .PUSH
            
.COLOR
            MOVE.L  D1,-(A7)
            MOVE.L  (A0)+,D1
            MOVE.W  #80,D0
            TRAP    #15
            MOVE.L  (A7)+,D1
            BRA     .HERE


.PUSH       BTST.B  #2,(SCRCYCCT)            ;16 CYCLES
            BEQ     .END

            MOVE.W  #((80-14)/2)<<8|25,D1    ;FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                        ;LOCATE TEXT CURSOR
            LEA     .STR0,A1                    ;STRING POINTER
            MOVE.B  #13,D0
            TRAP    #15                        ;PRINT
            
.END        MOVEM.L (A7)+,D0-D4/A0-A1
            RTS
            
             
.STR0   DC.B    'PUSH SPACE KEY',0
        DS.W    0            

;------------------------------------------------------------------------------
STACCSI
;------------------------------------------------------------------------------
           
        RTS
;------------------------------------------------------------------------------
STACCSU
;GAME COLOR SELECTOR UPDATE
;------------------------------------------------------------------------------
        MOVEM.L D0-D2,-(A7)
        MOVE.W  (MSY),D2
        MOVE.W  (MSX),D0
        CMPI.W #200,D2                    ;IF MSY<200, GO TO .END
        BLT .END
        CMPI.W #300,D2                    ;IF MSY>300, GO TO .END
        BGT .END
        CMPI.W #200,D0                    ;IF MSX<200, GO TO .END
        BLT .END
        CMPI.W #300,D0                    ;IF MSX>300, GO TO .NEXT
        BGT .NEXT
        MOVE.L #PINK,(CHARFCOL)           ;MOVE PINK TO CHARFCOL
        BRA .END1                         
.NEXT
        CMPI.W #350,D0                    ;IF MSX<350, GO TO .END
        BLT .END
        CMPI.W #450,D0                    ;IF MSX>450, GO TO .END
        BGT .END
        MOVE.L #BLUE,(CHARFCOL)           ;MOVE BLUE TO CHARFCOL
                                          
.END1
        CLR.L   D0
        CLR.L   D1
        MOVE.W  #60,D0
        TRAP    #15
        MOVE.W  #STAMAP1,(STANEXT)
            
.END            
        MOVEM.L (A7)+,D0-D2
        RTS
;------------------------------------------------------------------------------
STACCSP
;GAME COLOR SELECTOR PLOT
;------------------------------------------------------------------------------
        MOVEM.L D0-D4/A1,-(A7)
        MOVE.W  #((80-16)/2)<<8|8,D1  ;TEXT .TITLE
        MOVE.B  #11,D0
        TRAP    #15
        LEA     .TITLE,A1
        MOVE.B  #13,D0
        TRAP    #15
        MOVE.W  #((80-40)/2)<<8|10,D1 ;TEXT .TITLE2
        MOVE.B  #11,D0
        TRAP    #15
        LEA     .TITLE2,A1
        MOVE.B  #13,D0
        TRAP    #15
        MOVE.B      #80,D0            ;LEFT SQUARE
        MOVE.L      #MOBPCOL,D1
        TRAP        #15
        ADDQ.B      #1,D0
        MOVE.L      #PINK,D1
        TRAP        #15
        MOVE.W      #200,D1
        MOVE.W      #200,D2
        MOVE.W      D1,D3
        MOVE.W      D2,D4
        ADD.W       #100,D3
        ADD.W       #100,D4
        MOVE.B      #87,D0
        TRAP        #15               ;DRAW SQUARE
        MOVE.B      #80,D0
        MOVE.L      #00000000,D1      ;PEN COLOR BLACK
        TRAP        #15
        ADDQ.B      #1,D0
        MOVE.L      #00000000,D1      ;FILL COLOR BLACK
        TRAP        #15
        MOVE.B      #80,D0            ;RIGHT SQUARE
        MOVE.L      #MOBPCOL,D1
        TRAP        #15
        ADDQ.B      #1,D0
        MOVE.L      #BLUE,D1
        TRAP        #15
        MOVE.W      #350,D1
        MOVE.W      #200,D2
        MOVE.W      D1,D3
        MOVE.W      D2,D4
        ADD.W       #100,D3
        ADD.W       #100,D4
        MOVE.B      #87,D0
        TRAP        #15               ;DRAW SQUARE
        MOVE.B      #80,D0
        MOVE.L      #00000000,D1      ;PEN COLOR BLACK
        TRAP        #15
        ADDQ.B      #1,D0
        MOVE.L      #00000000,D1      ;FILL COLOR BLACK
        TRAP        #15
        MOVEM.L (A7)+,D0-D4/A1
        RTS
.TITLE  DC.B    'CHOOSE  YOUR COLOR',0
.TITLE2 DC.B    'USE THE MOUSE AND THEN PRESS LEFT CLICK ',0
        DS.W    0
;------------------------------------------------------------------------------
; -----------------------------------------------------------------------------
STAMAP1I
; MAP ONE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L   A0-A3/D0,-(A7)   ;STACK REGISTER
            JSR       LIFEINIT        ;INITIALIZE LIFES
            
            MOVE.W    #MOBID,D0       ;IF ANY ENEMYES FROM OTHER MAPS EXIST, KILL THEM
            JSR       DMMFRSTO
.LOOP       CMP.L     #0,A0           ;IF A0!=0 == FOUND
            BEQ       .SHOT           ;NOT FOUND
            JSR       AGLKILL           
            JSR       DMMNEXTO
            BRA       .LOOP
            
.SHOT       MOVE.W    #SHOTID,D0       ;IF ANY SHOTS FROM OTHER MAPS EXIST, KILL THEM
            JSR       DMMFRSTO
.LOOP2      CMP.L     #0,A0           ;IF A0!=0 == FOUND
            BEQ       .NEXT           ;NOT FOUND
            JSR       AGLKILL           
            JSR       DMMNEXTO
            BRA       .LOOP2
            
.NEXT       MOVE.W    #2,(MOBNUM)      ;THE NUM OF ENEMIES
            MOVE.W    #1,(MAPCUR)      ;THE CURRENT MAP
            JSR       CHARINIT         ;INIT CHAR  
 
            MOVE.W    #98,(MOBY)       ;LOCATE ENEMY, CREATE AGENT
            MOVE.W    #62,(MOBX)
            MOVE.W    #MOBID,D0
            LEA       MOBINIT,A1
            LEA       MOBUPDM,A2
            LEA       MOBPLOT,A3
            JSR       AGLADD           ;FIRST ENEMY
            
            
            MOVE.W    #418,(MOBY)
            MOVE.W    #305,(MOBX)
            MOVE.W    #MOBID,D0
            LEA       MOBINIT,A1
            LEA       MOBUPDL,A2
            LEA       MOBPLOT,A3
            JSR       AGLADD             ;SECOND ENEMY
            
            
            MOVEM.L   (A7)+,A0-A3/D0     ;STORE REGISTERS
            RTS

; -----------------------------------------------------------------------------
STAMAP1U
; MAP ONE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            JSR     CHARUPD
            JSR     AGLUPD
            MOVE.W  (MOBNUM),D0   ;IF NO ENEMIES LEFT
            CMP.W   #0,D0
            BEQ     .NEXTMAP1      ;GO TO NEXT MAP
            MOVE.L (A7)+,D0
            RTS
            
.NEXTMAP1   MOVE.W  #STAMAP2,(STANEXT)
            MOVE.L (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
STAMAP1P
; MAP ONE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
    JSR MAP1MATD
    JSR CHARPLOT
    JSR AGLPLOT
    JSR LIFEPLOT
        RTS  

; -----------------------------------------------------------------------------
STAMAP2I
; MAP TWO INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W   #3,(MOBNUM)
            MOVE.W   #2,(MAPCUR)
            MOVEM.L   A0-A3/D0,-(A7)     ;STACK REGISTER
            
            MOVE.W    #SHOTID,D0       ;IF ANY SHOTS FROM OTHER MAPS EXIST, KILL THEM
            JSR       DMMFRSTO
.LOOP       CMP.L     #0,A0           ;IF A0!=0 == FOUND
            BEQ       .NEXT           ;NOT FOUND
            JSR       AGLKILL           
            JSR       DMMNEXTO
            BRA       .LOOP
            
.NEXT       JSR CHARINIT
            
            MOVE.W   #34,(MOBY)
            MOVE.W   #300,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDL,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;FIRST ENEMY
            
            
            MOVE.W   #418,(MOBY)
            MOVE.W   #360,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDM,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;SECOND ENEMY
            
            MOVE.W   #130,(MOBY)
            MOVE.W   #355,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;THIRD ENEMY
            
            MOVEM.L  (A7)+,A0-A3/D0     ;STORE REGISTERS
            
            RTS

; -----------------------------------------------------------------------------
STAMAP2U
; MAP TWO UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     CHARUPD
            JSR     AGLUPD
            CMP.W   #0,(MOBNUM)   ;IF NO ENEMIES LEFT 
            BEQ     .NEXTMAP2     ;GO TO NEXT MAP
            RTS
.NEXTMAP2   MOVE.W  #STAMAP3,(STANEXT)
            RTS  

; -----------------------------------------------------------------------------
STAMAP2P
; MAP TWO PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
            JSR MAP2MATD
            JSR CHARPLOT
            JSR AGLPLOT
            JSR LIFEPLOT
                RTS



; -----------------------------------------------------------------------------
STAMAP3I
; MAP THREE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W   #3,(MOBNUM)
            MOVE.W   #3,(MAPCUR)
            MOVEM.L   A0-A3/D0,-(A7)     ;STACK REGISTER
            
            MOVE.W    #SHOTID,D0       ;IF ANY SHOTS FROM OTHER MAPS EXIST, KILL THEM
            JSR       DMMFRSTO
.LOOP       CMP.L     #0,A0           ;IF A0!=0 == FOUND
            BEQ       .NEXT           ;NOT FOUND
            JSR       AGLKILL           
            JSR       DMMNEXTO
            BRA       .LOOP
            
.NEXT       JSR CHARINIT
            
            MOVE.W   #226,(MOBY)
            MOVE.W   #63,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;FIRST ENEMY
            
            
            MOVE.W   #386,(MOBY)
            MOVE.W   #192,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDL,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;SECOND ENEMY
            
            MOVE.W   #130,(MOBY)
            MOVE.W   #250,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDM,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;THIRD ENEMY
            
            MOVEM.L  (A7)+,A0-A3/D0     ;STORE REGISTERS
            
            RTS

; -----------------------------------------------------------------------------
STAMAP3U
; MAP THREE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     CHARUPD
            JSR     AGLUPD
            CMP.W   #0,(MOBNUM)   ;IF NO ENEMIES LEFT 
            BEQ     .NEXTMAP3     ;GO TO NEXT MAP
            RTS
.NEXTMAP3   MOVE.W  #STAMAP4,(STANEXT)
            RTS  

; -----------------------------------------------------------------------------
STAMAP3P
; MAP THREE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
    JSR MAP3MATD
    JSR CHARPLOT
    JSR AGLPLOT
    JSR LIFEPLOT
        RTS





; -----------------------------------------------------------------------------
STAMAP4I
; MAP FOUR INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W   #3,(MOBNUM)
            MOVE.W   #4,(MAPCUR)
            MOVEM.L   A0-A3/D0,-(A7)     ;STACK REGISTER
            
            MOVE.W    #SHOTID,D0       ;IF ANY SHOTS FROM OTHER MAPS EXIST, KILL THEM
            JSR       DMMFRSTO
.LOOP       CMP.L     #0,A0           ;IF A0!=0 == FOUND
            BEQ       .NEXT           ;NOT FOUND
            JSR       AGLKILL           
            JSR       DMMNEXTO
            BRA       .LOOP
            
.NEXT       JSR CHARINIT
            
            MOVE.W   #354,(MOBY)
            MOVE.W   #475,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;FIRST ENEMY
            
            
            MOVE.W   #418,(MOBY)
            MOVE.W   #97,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;SECOND ENEMY
            
            MOVE.W   #34,(MOBY)
            MOVE.W   #32,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDL,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;THIRD ENEMY
            
            MOVEM.L  (A7)+,A0-A3/D0     ;STORE REGISTERS
            
            RTS

; -----------------------------------------------------------------------------
STAMAP4U
; MAP FOUR UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     CHARUPD
            JSR     AGLUPD
            CMP.W   #0,(MOBNUM)   ;IF NO ENEMIES LEFT 
            BEQ     .NEXTMAP4     ;GO TO NEXT MAP
            RTS
.NEXTMAP4   MOVE.W  #STAMAP5,(STANEXT)
            RTS  

; -----------------------------------------------------------------------------
STAMAP4P
; MAP FOUR PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
    JSR MAP4MATD
    JSR CHARPLOT
    JSR AGLPLOT
    JSR LIFEPLOT
        RTS



; -----------------------------------------------------------------------------
STAMAP5I
; MAP FIVE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W   #4,(MOBNUM)
            MOVE.W   #5,(MAPCUR)
            MOVEM.L   A0-A3/D0,-(A7)     ;STACK REGISTER
            
            MOVE.W    #SHOTID,D0       ;IF ANY SHOTS FROM OTHER MAPS EXIST, KILL THEM
            JSR       DMMFRSTO
.LOOP       CMP.L     #0,A0           ;IF A0!=0 == FOUND
            BEQ       .NEXT           ;NOT FOUND
            JSR       AGLKILL           
            JSR       DMMNEXTO
            BRA       .LOOP
            
.NEXT       JSR CHARINIT
            
            MOVE.W   #418,(MOBY)
            MOVE.W   #97,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;FIRST ENEMY
            
            
            MOVE.W   #130,(MOBY)
            MOVE.W   #32,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;SECOND ENEMY
            
            MOVE.W   #162,(MOBY)
            MOVE.W   #384,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;THIRD ENEMY
            
            MOVE.W   #66,(MOBY)
            MOVE.W   #416,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDS,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;FOURTH ENEMY
            
            MOVEM.L  (A7)+,A0-A3/D0     ;STORE REGISTERS
            
            RTS

; -----------------------------------------------------------------------------
STAMAP5U
; MAP FIVE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     CHARUPD
            JSR     AGLUPD
            CMP.W   #0,(MOBNUM)   ;IF NO ENEMIES LEFT 
            BEQ     .NEXTMAP5     ;GO TO NEXT MAP
            RTS
.NEXTMAP5   MOVE.W  #STAMAP6,(STANEXT)
            RTS  

; -----------------------------------------------------------------------------
STAMAP5P
; MAP FIVE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
    JSR MAP5MATD
    JSR CHARPLOT
    JSR AGLPLOT
    JSR LIFEPLOT
        RTS



; -----------------------------------------------------------------------------
STAMAP6I
; MAP SIX INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W   #1,(MOBNUM)
            MOVE.W   #6,(MAPCUR)
            MOVEM.L   A0-A3/D0,-(A7)     ;STACK REGISTER
            
            MOVE.W    #SHOTID,D0       ;IF ANY SHOTS FROM OTHER MAPS EXIST, KILL THEM
            JSR       DMMFRSTO
.LOOP       CMP.L     #0,A0           ;IF A0!=0 == FOUND
            BEQ       .NEXT           ;NOT FOUND
            JSR       AGLKILL           
            JSR       DMMNEXTO
            BRA       .LOOP
            
.NEXT       JSR CHARINIT
            
            MOVE.W   #418,(MOBY)
            MOVE.W   #330,(MOBX)
            MOVE.W   #MOBID,D0
            LEA      MOBINIT,A1
            LEA      MOBUPDM,A2
            LEA      MOBPLOT,A3
            JSR      AGLADD             ;FIRST ENEMY
            
            
            MOVEM.L  (A7)+,A0-A3/D0     ;STORE REGISTERS
            
            RTS

; -----------------------------------------------------------------------------
STAMAP6U
; MAP SIX UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     CHARUPD
            JSR     AGLUPD
            CMP.W   #0,(MOBNUM)   ;IF NO ENEMIES LEFT 
            BEQ     .NEXTMAP6     ;GO TO NEXT MAP
            RTS
.NEXTMAP6   MOVE.W  #STAWIN,(STANEXT)
            RTS  

; -----------------------------------------------------------------------------
STAMAP6P
; MAP SIX PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
    JSR MAP6MATD
    JSR CHARPLOT
    JSR AGLPLOT
    JSR LIFEPLOT
        RTS      
            
; -----------------------------------------------------------------------------
STAGOVRI
; GAME OVER INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     GOVERSND
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAINTRO,(STANEXT)
            RTS
.END              
            RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0/A1,-(A7)            ;STACK REGISTERS
            MOVE.B      #80,D0
            MOVE.L      #0,D1                   ;PEN COLOR BLACK
            TRAP        #15
            ADDQ.B      #1,D0
            MOVE.L      #0,D1                   ;FILL COLOR BLACK
            TRAP        #15
            MOVE.W #((80-10)/2)<<8|10,D1    ;FIRST TEXT COORDINATES
            MOVE.B #11,D0
            TRAP #15                        ;LOCATE TEXT CURSOR
            LEA .STR0,A1                    ;STRING POINTER
            MOVE.B #13,D0
            TRAP #15                        ;PRINT
            
            MOVE.W #((80-26)/2)<<8|12,D1    ;FIRST TEXT COORDINATES
            MOVE.B #11,D0
            TRAP #15                        ;LOCATE TEXT CURSOR
            LEA .STR1,A1                    ;STRING POINTER
            MOVE.B #13,D0
            TRAP #15                        ;PRINT
            
            BTST.B #3,(SCRCYCCT)            ;16 CYCLES
            BEQ .END
            
            MOVE.W #((80-14)/2)<<8|25,D1    ;FIRST TEXT COORDINATES
            MOVE.B #11,D0
            TRAP #15                        ;LOCATE TEXT CURSOR
            LEA .STR2,A1                    ;STRING POINTER
            MOVE.B #13,D0
            TRAP #15 
            
.END        MOVEM.L  (A7)+,D0/A1            ;STORE REGISTERS
            RTS
.STR0   DC.B    'GAME  OVER',0
.STR1   DC.B    'YOU DIDN',39,'T  SAVE THE WORLD',0
.STR2   DC.B    'PUSH SPACE KEY',0
        DS.W    0            
            
            




; -----------------------------------------------------------------------------
STAWONI
; GAME WON INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAWONU
; GAME WON UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     NXTLVSND
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAINTRO,(STANEXT)
            RTS
.END              
            RTS

; -----------------------------------------------------------------------------
STAWONP
; GAME WON PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L     D0-D1/A1,-(A7)          ;STACK REGISTERS
            MOVE.B      #80,D0
            MOVE.L      #0,D1                   ;PEN COLOR BLACK
            TRAP        #15
            ADDQ.B      #1,D0
            MOVE.L      #0,D1                   ;FILL COLOR BLACK
            TRAP        #15
            CLR.L       D1
            MOVE.W      #((80-14)/2)<<8|10,D1   ;FIRST TEXT COORDINATES
            MOVE.B      #11,D0
            TRAP        #15                     ;LOCATE TEXT CURSOR
            LEA         .STR0,A1                ;STRING POINTER
            MOVE.B      #13,D0
            TRAP        #15                     ;PRINT
            
            MOVE.W      #((80-20)/2)<<8|12,D1   ;FIRST TEXT COORDINATES
            MOVE.B      #11,D0
            TRAP        #15                     ;LOCATE TEXT CURSOR
            LEA         .STR1,A1                ;STRING POINTER
            MOVE.B      #13,D0
            TRAP        #15                     ;PRINT
            
            BTST.B      #3,(SCRCYCCT)           ;16 CYCLES
            BEQ         .END
            
            MOVE.W      #((80-14)/2)<<8|25,D1   ;FIRST TEXT COORDINATES
            MOVE.B      #11,D0
            TRAP        #15                     ;LOCATE TEXT CURSOR
            LEA         .STR2,A1                ;STRING POINTER
            MOVE.B      #13,D0
            TRAP        #15 
            
.END        MOVEM.L     (A7)+,D0-D1/A1          ;STORE REGISTERS
            RTS
.STR0   DC.B    'GAME  FINISHED',0
.STR1   DC.B    'YOU SAVED  THE WORLD',0
.STR2   DC.B    'PUSH SPACE KEY',0
        DS.W    0





BITMAP
    DC.L    $00025,$00003,$00058,$00001,$00d02,$00900,$00245,$00013,$00013
    DC.L    $00022,$00031,$00010,$00032,$00097,$00022,$00222,$00111,$00111
    DC.L    $00111,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00111,$00111,$00000,$00201,$00010,$00050,$00050
    DC.L    $00604,$00709,$00006,$00014,$00065,$00010,$00d08,$00c04,$00b01
    DC.L    $00500,$00020,$00040,$00050,$00040,$00104,$00406,$00d0a,$00635
    DC.L    $00050,$000a0,$00020,$00222,$00203,$00001,$00032,$00020,$00023
    DC.L    $00000,$00422,$00010,$00060,$00020,$0036a,$00004,$00408,$00004
    DC.L    $00010,$00096,$00010,$00213,$00c28,$00503,$00001,$00043,$00023
    DC.L    $00000,$00040,$00031,$00406,$00507,$00604,$00311,$00043,$00001
    DC.L    $00b09,$00c06,$001104,$00901,$00009,$00007,$00020,$00010,$0001e
    DC.L    $00009,$00060,$00060,$00770,$00440,$00022,$00006,$0004b,$0002b
    DC.L    $00009,$0010a,$00503,$00501,$00222,$00001,$00014,$00003,$00501
    DC.L    $00c44,$00710,$00340,$00010,$00069,$00008,$0070f,$00c07,$00e01
    DC.L    $001060,$00430,$00020,$00030,$00050,$00060,$00090,$00190,$00410
    DC.L    $00b17,$00b06,$00904,$00941,$00150,$00020,$00020,$00340,$00520
    DC.L    $00c30,$00940,$00010,$00020,$00267,$00011,$00010,$00020,$00030
    DC.L    $00030,$00065,$00001,$00011,$00020,$00040,$00060,$00700,$00900
    DC.L    $00724,$00000,$00460,$00050,$00050,$00350,$00204,$00207,$00007
    DC.L    $00004,$00020,$00041,$00400,$00540,$00050,$00090,$00080,$00050
    DC.L    $00010,$00001,$00503,$00201,$00031,$00050,$00510,$00c00,$00d20
    DC.L    $00630,$00052,$00020,$00003,$00203,$00003,$00000,$00010,$00020
    DC.L    $00020,$00020,$00058,$00003,$00005,$00127f,$0024611,$0026513,$001c514
    DC.L    $0016617,$0017c1c,$00707,$001a710,$00201017,$00435,$00001,$00000,$00000
    DC.L    $00111,$00111,$00111,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00111,$00111,$00000,$00635,$00010
    DC.L    $00050,$00690,$001bc14,$0014010,$0019718,$0012612,$00b5a,$0019d13,$001b210
    DC.L    $0024716,$001a5e,$00e36,$00010,$002a3,$00050,$00050,$00104,$00406
    DC.L    $00a05,$00502,$00040,$00091,$00c79,$001ba13,$0018411,$00162f,$00167f
    DC.L    $00112a,$00151d,$0020d16,$0019b11,$00712,$00010,$00032,$00305,$0011610
    DC.L    $0018613,$001b916,$001a1016,$00b49,$00159f,$00176f,$001d713,$0017611,$00504
    DC.L    $00001,$00546,$00000,$00181,$00020,$00608,$00607,$00401,$00000
    DC.L    $00000,$00203,$001a815,$0020715,$0020810,$001e912,$0014717,$0011815,$0015f14
    DC.L    $0011d12,$001010,$00008,$00183,$005a0,$00940,$00830,$00001,$000a11
    DC.L    $00004,$00004,$00008,$00206,$00201218,$00189d,$00127a,$0016f14,$0010711
    DC.L    $0014913,$001ba15,$00155c,$0018ac,$0016bd,$0015e11,$00f8f,$00e512,$0050a
    DC.L    $00100b,$00e04,$00520,$00580,$00010,$00032,$00020,$00030,$006b0
    DC.L    $00660,$001ce12,$00162f,$002371b,$001f316,$001408,$001248,$0017c14,$0013810
    DC.L    $001007,$001e9c,$001832,$0021f10,$001169,$0014c13,$0013812,$00f2a,$001cd11
    DC.L    $001bdf,$0016bd,$0013ad,$0017914,$00f1d,$0018712,$001ab13,$0017f10,$00c76
    DC.L    $00e98,$00400,$00102,$00000,$00030,$00030,$00140,$00a54,$001aa15
    DC.L    $001a718,$0018617,$0012513,$00c6b,$0015cf,$00183c,$001c7f,$001288,$00f85
    DC.L    $001257,$00144b,$0016510,$001b714,$0020515,$0018411,$0096f,$00cbf,$001bad
    DC.L    $0023df,$001445,$00700,$00000,$00056,$00003,$00203,$00001,$00000
    DC.L    $00010,$00020,$00010,$00010,$00055,$00026,$0011812,$002cf1f,$004ad27
    DC.L    $004f325,$004912b,$004832e,$004422c,$004bc33,$003c01d,$003a820,$0025e1c,$00534c53
    DC.L    $00242424,$00010,$00111,$00111,$00111,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00111,$00111,$00000
    DC.L    $00213,$00000,$00793,$0015dd,$002bb1c,$0033522,$0039b28,$0033823,$002e71d
    DC.L    $003281f,$003b824,$003331d,$002b718,$003a2730,$00292628,$00020,$00050,$00060
    DC.L    $00023,$00204,$00903,$00700,$00020,$00bbb,$0026a17,$003681f,$0041625
    DC.L    $0044729,$0040623,$0041724,$0047927,$003d31f,$003391b,$0022a14,$00201b1d,$00324
    DC.L    $0017712,$00301021,$003aa22,$0036018,$0032117,$003cf22,$003ac22,$003571e,$003461d
    DC.L    $002d81c,$002d1a23,$0014d12,$00104,$00001,$00030,$00010,$00605,$00707
    DC.L    $00333,$00675,$00fdd,$0020151d,$002591c,$0027117,$002e717,$002c416,$0030923
    DC.L    $002a51f,$002771a,$0029f21,$001c91e,$00e411,$00c76,$00720,$001370,$00c00
    DC.L    $00003,$00004,$00203,$00502,$001d181a,$00251a1d,$002c111a,$002db16,$002fd18
    DC.L    $002fb1b,$0029217,$002a31c,$002fb23,$002b921,$002871c,$002eb1f,$0026415,$00341425
    DC.L    $001f316,$001c716,$0015510,$00401,$00072,$00030,$00201,$00706,$00403
    DC.L    $00400,$00900,$001b9a,$002881b,$0037b2a,$0035025,$004072e,$003ea28,$0037622
    DC.L    $0037828,$0037626,$003a421,$003f821,$003fd1f,$003d1122,$002b51b,$002c721,$002d21d
    DC.L    $0036721,$003a91f,$0037418,$003cd23,$0038a21,$0036422,$003b627,$004192c,$0038422
    DC.L    $003ad27,$0024717,$00927,$00032,$00088,$00011,$00030,$004b4,$00292421
    DC.L    $002c181d,$002d61b,$003221f,$0039725,$003bb27,$003171e,$003df25,$003f823,$003e420
    DC.L    $003e924,$003d823,$0042825,$0044827,$0044428,$0045529,$004462a,$003a526,$0033102b
    DC.L    $0029921,$003271c,$003d1023,$0026815,$001a710,$00904,$00403,$00403,$00201
    DC.L    $00012,$00000,$00010,$00010,$00210,$00210,$00020,$00102,$00251320
    DC.L    $0042112d,$00882d5a,$0095215c,$009c2569,$008d175e,$00942066,$0096286a,$00b74e87,$0093436e
    DC.L    $0023012,$008a7a85,$008e8b8d,$00031,$00111,$00111,$00111,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00111
    DC.L    $00111,$00000,$00003,$00435,$00c95,$00271318,$00501d39,$00833d66,$00782a59
    DC.L    $00782857,$00833761,$008b3f69,$008f3e6b,$00924971,$0056233e,$003d202f,$009b9499,$00131816
    DC.L    $00050,$00060,$00043,$00003,$00802,$00b02,$00643,$00201218,$00481530
    DC.L    $008a3c65,$007d2053,$0088215a,$00b24e82,$00ae497c,$00a53e71,$00a54b76,$0083405f,$003081a
    DC.L    $006c5f67,$00787077,$00371d2d,$004f1f37,$009c4f71,$00a2476e,$00943d63,$007c294f,$008b3a61
    DC.L    $008c3f65,$008a4167,$006a324f,$00341726,$00675b61,$00204,$00324,$00010,$00220
    DC.L    $00746,$00001,$00010,$00010,$00231c1f,$00281421,$00774f68,$008c5674,$00b77a96
    DC.L    $00a76582,$00773257,$0078355a,$006a284b,$00693351,$002eb25,$00574453,$001b1314,$00c60
    DC.L    $00c00,$00c00,$00203,$0075b,$00b68,$00500,$005e5656,$00392427,$003dc1a
    DC.L    $007b3a4f,$008b475e,$00823b56,$008e4163,$00873a60,$008b456e,$008e4c76,$007c3560,$008b446c
    DC.L    $00af668c,$008c4b6b,$00572741,$00351526,$0018712,$00102,$00084,$00042,$00203
    DC.L    $00704,$00504,$00703,$001ce10,$00543943,$003fe2e,$00955180,$00a2518a,$00993f7b
    DC.L    $00953d72,$008f386a,$00862b62,$0082285d,$008a2e5f,$00751b46,$00661235,$005ab2c,$0064193f
    DC.L    $006d234d,$008d3d68,$009d4a71,$0080284c,$007c2448,$006b173a,$00802a52,$007d2455,$00771b50
    DC.L    $0075184f,$00751b50,$007c2c5b,$004d1637,$00251723,$00389,$00003,$00066,$00020
    DC.L    $00242823,$007c7070,$0029712,$007d3e5e,$0082335e,$008e3b68,$0085325f,$0074274d,$0077284f
    DC.L    $00842b57,$00812352,$00903164,$00852357,$00841f56,$0089235a,$00851f56,$00811b52,$00801b52
    DC.L    $00771b4e,$00702251,$006e234f,$0077234d,$006e2446,$003ab25,$0027b1e,$00d09,$00706
    DC.L    $00403,$00200,$00011,$00020,$00120,$00320,$00520,$00610,$00050
    DC.L    $00201,$0029f1f,$00521236,$00b94181,$00d1398c,$00d93a98,$00c72388,$00c42387,$00ce3592
    DC.L    $00fd70c1,$00b24381,$003001b,$00644d5c,$00a49fa1,$00222621,$00120,$00111,$00111
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00111,$00111,$00000,$00003,$00435,$00f77,$002ed1b,$007e355d
    DC.L    $00c8649e,$00ab3a7d,$00b33c80,$00b03a7b,$00ca5796,$00ac3879,$00a9447c,$007a355a,$001f0c
    DC.L    $00998c94,$00434644,$00040,$00050,$00043,$00012,$00712,$00b11,$00d55
    DC.L    $00301421,$005a1137,$00aa407b,$00ae2a76,$00d6499a,$00ff74c1,$00de549c,$00dc5097,$00e46aa6
    DC.L    $00ce749f,$003e722,$00756370,$00c3b8c2,$004e2e41,$007c3c5a,$00cb6190,$00ce4f86,$00c0447a
    DC.L    $00b13970,$00bb467f,$00b4457d,$00bb578b,$00994e74,$0028214,$00807179,$001c141e,$00548
    DC.L    $00210,$00550,$00010,$00021,$00010,$00161616,$004b3d48,$003e1d32,$00af779a
    DC.L    $00d286af,$00ee96be,$00c06089,$00bd5a88,$00ce6a9a,$00ca6194,$00a7507c,$003fe2a,$00715d6a
    DC.L    $004e4d4f,$00040,$00830,$00832,$00237,$00005,$00003,$0010bc,$007b7570
    DC.L    $00298c,$00924358,$00b2496a,$00cb5f83,$00c6537b,$00cb4d7e,$00bd3e75,$00bd4984,$00c65293
    DC.L    $00c1488c,$00db5fa1,$00f27ab5,$00b44b7c,$00691f43,$00481a31,$0048323e,$00003,$00013
    DC.L    $00013,$00003,$00003,$00126,$00437,$003e3336,$00755868,$0051153e,$00e38dc9
    DC.L    $00ec80c9,$00c04694,$00aa2c74,$00b5337a,$00be357f,$00b52b73,$00b62d71,$009e1854,$009d1e51
    DC.L    $0088e3e,$00971f55,$00a93168,$00d4578f,$00bb3c70,$0092f41,$00971746,$00981b4d,$00af3369
    DC.L    $00b33472,$00b33277,$00b12e77,$00a72971,$00a73477,$00671546,$0028c20,$00005,$0024c
    DC.L    $00004,$00088,$00717171,$00755f64,$003da1e,$00b25c86,$00ad4078,$00b43f7c,$00a02966
    DC.L    $00982761,$009f2e67,$00b53c79,$00b02f72,$00cc418b,$00b82873,$00b0266e,$00b93278,$00b73076
    DC.L    $00ae276b,$00ac2367,$00a72064,$00a01a5c,$00a62160,$00a7215d,$008e1f51,$004992c,$002e1128
    DC.L    $00f613,$00006,$00201,$00200,$00010,$00030,$00120,$00520,$00610
    DC.L    $00700,$00292,$00400,$002791c,$005b133e,$00bc3682,$00d4298b,$00dd2796,$00db2296
    DC.L    $00de279a,$00d42593,$00e340a2,$00ae2e7b,$003e026,$004e3246,$00a6a1a2,$00434742,$00120
    DC.L    $00111,$00111,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00111,$00111,$00000,$00045,$00001,$0018bd
    DC.L    $0030617,$008d3465,$00c74d93,$00b7297c,$00c73288,$00dc489c,$00ce3b8d,$00b9297b,$00b43a80
    DC.L    $00802c5c,$002f01a,$00978691,$00646666,$00020,$00040,$00032,$00012,$00621
    DC.L    $00700,$00e35,$00361223,$0062c3c,$00be4088,$00da3e9c,$00ec44a7,$00e6409f,$00df3c97
    DC.L    $00fe5db3,$00df529b,$00d76fa4,$004ab2b,$006a5766,$00b2a8b4,$00452137,$006d2549,$00b73d73
    DC.L    $00ca3676,$00c93476,$00cc397d,$00c2327a,$00bf387e,$00c84e8e,$009d4371,$00220e,$008f8088
    DC.L    $003e363d,$00201,$00630,$00410,$00010,$00888,$00724,$003f3038,$00634459
    DC.L    $00451333,$00dd92c0,$00e285b8,$00ec81b2,$00e172a4,$00d96c9d,$00e072a6,$00d6639c,$00c36392
    DC.L    $003441e,$00685863,$00585c5d,$00096,$00010,$00643,$00317,$00006,$00406
    DC.L    $0062585e,$00a09494,$002805,$0092304e,$00c2426c,$00cc4876,$00d34a7d,$00bf2d64,$00bb2a68
    DC.L    $00be3b7e,$00c03b84,$00d34092,$00e04699,$00e64e9a,$00d24e90,$00882956,$005a1c3a,$007a5869
    DC.L    $00f1c,$00b811,$00004,$00012,$00043,$00010,$00001,$004e474a,$00674758
    DC.L    $0054f3c,$00ea86c8,$00d252a4,$00c2338a,$00b41e72,$00bc2172,$00d02d82,$00c01e70,$00c22470
    DC.L    $00b31e60,$00a1154b,$0097f43,$00a41f57,$00c54079,$00e25b93,$00a0164c,$008d333,$009d1545
    DC.L    $00a62153,$00ac2760,$00a7195e,$00a2125d,$00a51262,$00a71769,$00a82471,$006733f,$00421530
    DC.L    $002e1c29,$00c0b,$00b1d,$00015,$007c7779,$006f515c,$0048b25,$00b95083,$00a82667
    DC.L    $00a61962,$00a0105b,$00b32970,$00c84187,$00d2448f,$00bb2977,$00bd2578,$00af176a,$00b72573
    DC.L    $00c73a83,$00be3377,$00ac2165,$00aa1c61,$00ac1b60,$00b11962,$00b61a61,$00b0155a,$009d1d58
    DC.L    $005b123a,$003b1832,$00211724,$0075b,$00a57,$00723,$00020,$00030,$00020
    DC.L    $00520,$00700,$00900,$00030,$00500,$002ac1f,$005b1240,$00be3688,$00cf248e
    DC.L    $00de299c,$00e228a2,$00dd239d,$00e02fa4,$00cc248e,$00b43083,$003a023,$003e2337,$009e9899
    DC.L    $00494d47,$00120,$00111,$00111,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00111,$00111,$00000,$00010
    DC.L    $00000,$001ace,$003681b,$008c2a60,$00be3586,$00c82987,$00d4288e,$00dc3194,$00eb43a4
    DC.L    $00c52180,$00bc3182,$0086255d,$002c012,$00917d8a,$00676767,$00120,$00020,$00032
    DC.L    $00021,$00230,$00500,$00a23,$0035f25,$0066841,$00a51c70,$00b0872,$00c2e7f
    DC.L    $00c51580,$00b046a,$00c6207f,$00da489a,$00de73ac,$003e020,$005d4e5c,$00a5a2ab,$0048283b
    DC.L    $006e264a,$00d2528d,$00e0448b,$00dd3e88,$00dd3c8a,$00ec4a9c,$00c72c7d,$00c1377f,$00ae4a7e
    DC.L    $0024012,$00887e84,$003e373c,$00500,$00f85,$00c61,$0016ee,$0019bf,$0023916
    DC.L    $004a2037,$003101a,$005f1442,$00e081ba,$00e478b3,$00de6ba4,$00dc6da1,$00ca6a99,$00bd6190
    DC.L    $00a34274,$009a4b74,$00361125,$00585057,$00555e61,$00020,$00253,$00200,$00505
    DC.L    $0011713,$001eb1c,$004a3244,$00341c26,$002e0e,$008f284e,$00a01d4f,$00b1295d,$00c94074
    DC.L    $00b3295f,$00ad2c65,$00ac3a79,$00aa317b,$00ce398f,$00de3b97,$00d42e87,$00cc3886,$009d2c66
    DC.L    $004501d,$005b213d,$00391025,$002771a,$0022e1a,$00843,$00040,$00040,$00020
    DC.L    $004d4a46,$005f414e,$00641c47,$00e073b7,$00b72e82,$00c9318a,$00d2368b,$00d23082,$00d42e81
    DC.L    $00be1b6c,$00c02a70,$00a71f59,$00941846,$00932149,$00a73864,$00c75786,$00cd5c88,$008e1b46
    DC.L    $0087163b,$008e1d42,$0082153c,$00982858,$00ab2f6b,$00b32e74,$00c33784,$00cb418f,$00b53582
    DC.L    $0061037,$003f01f,$0042122a,$003061d,$0021414,$0041363e,$00b2a6ac,$0062414f,$004fb2a
    DC.L    $00b8437c,$00b6256f,$00b61b6c,$00b91d71,$00c62f7e,$00de4a98,$00d74194,$00bb297b,$00b42d79
    DC.L    $00a6266d,$00b1397a,$00bc4a86,$00ae3d76,$00a13167,$00a3326b,$00a8306b,$00a82062,$00af2164
    DC.L    $00af1f60,$00a52c66,$0060173f,$002e520,$002e1424,$0022111a,$001df13,$0010ab,$00042
    DC.L    $00020,$00010,$00310,$00601,$00700,$00370,$00500,$002c1023,$004fa37
    DC.L    $00c74396,$00d72f99,$00e335a7,$00d32297,$00d7279e,$00f144b6,$00d52f9a,$00bb398c,$0045432
    DC.L    $00321a2c,$00999495,$00434741,$00120,$00111,$00111,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00111,$00111
    DC.L    $00000,$00021,$00222,$001024,$003ba20,$00851e57,$00c33588,$00d52d92,$00ca1381
    DC.L    $00d9238f,$00e9359e,$00d62a90,$00c02c84,$008d2761,$003401a,$0087737f,$00656565,$00310
    DC.L    $00010,$00012,$00032,$00150,$00220,$00823,$0035e27,$005c038,$009df68
    DC.L    $00b6979,$00ba078,$00c1a7d,$00b9b77,$00b196e,$00a21265,$0090215f,$003c01e,$00665a66
    DC.L    $00a4a4aa,$003f2134,$00722a4e,$00c94b86,$00dc418b,$00ec4c98,$00cf2c7d,$00d92d85,$00e53e95
    DC.L    $00dd4695,$009c3169,$0026012,$00797777,$00333333,$00532,$00732,$00700,$0028191d
    DC.L    $00351724,$006d3951,$00793056,$00842b5d,$00a8427c,$00d664a4,$00d25a9b,$00e96fab,$00e579ad
    DC.L    $0080325b,$00601d42,$005e1840,$004e1633,$00170a,$006a6567,$0050575a,$00025,$00275
    DC.L    $00422,$00221b22,$00301d2e,$00401736,$00582648,$00663652,$00864664,$00bf5786,$00b03168
    DC.L    $009a1449,$00b02f62,$00962251,$0072c3c,$005fa3e,$0073f50,$00b92b7e,$00f64fac,$00ef3e9f
    DC.L    $00ef4ba3,$00c03a82,$00871f56,$0077284f,$00763a58,$00592641,$00331122,$001a1010,$00050
    DC.L    $00080,$000a0,$00404138,$00634851,$006e254d,$00d767a7,$00b4287b,$00b4186f,$00c6267a
    DC.L    $00d33081,$00cd2879,$00b21761,$00af2866,$007da3b,$0062629,$0056623,$00651938,$006a1e3e
    DC.L    $00621433,$005031f,$005271d,$005381e,$005cf2a,$0055022,$0076f42,$00b13979,$00cd4990
    DC.L    $00ba3480,$00a62973,$007ee4e,$00721744,$00621537,$00753251,$003331b,$00503c48,$00b8a9b1
    DC.L    $005e3d4c,$004b726,$00a62e68,$00c6317b,$00d23488,$00d5348a,$00be2276,$00d3398a,$00d53a8f
    DC.L    $00cc3f8e,$008d1c5f,$0066940,$005b737,$005ff3a,$005bc33,$00601237,$0067183f,$006be3b
    DC.L    $00ac3770,$00ab2966,$00aa2361,$00b63f76,$0083315b,$004e1431,$005c293d,$00522938,$002f1620
    DC.L    $001bf15,$00657,$00010,$00000,$00422,$00612,$00500,$00230,$00832
    DC.L    $0023c1b,$00561741,$00d85bab,$00db40a3,$00d738a0,$00dd3ea6,$00ef4fb9,$00ed4eb6,$00e045a8
    DC.L    $00c34898,$0039028,$00251221,$009a9897,$0043483f,$00010,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00111,$00011,$00020,$00020,$001377,$0033518,$0086235b,$00cb3f93
    DC.L    $00cf288f,$00d31f8e,$00d61f8e,$00ce1986,$00c81a85,$00bb2680,$00831c59,$0030016,$0085747f
    DC.L    $00656565,$00400,$00413,$00023,$00010,$00060,$00030,$00644,$00341026
    DC.L    $005f03c,$00ad1e7a,$00c31385,$00c9c85,$00bd87b,$00bac78,$00b9157a,$00a7196c,$007cf4d
    DC.L    $003d020,$00635862,$00a5a7a8,$00412735,$00652242,$00ca528c,$00d5438b,$00c22a75,$00bf2070
    DC.L    $00db2d85,$00f749a1,$00fe5faf,$00c15089,$00210d,$00787f7a,$0025332d,$00030,$00021
    DC.L    $001c1518,$004d3541,$0046162e,$00b6638a,$00c85e93,$00e56aac,$00f16fb6,$00cd478f,$00cf4b8e
    DC.L    $00c64883,$00c05d8b,$003d423,$001b011,$0021217,$0029101e,$00524347,$00999394,$0046444a
    DC.L    $00005,$00387,$00000,$005e575e,$0026920,$00b5729f,$00fda9df,$00ffb3e2,$00ffbeee
    DC.L    $00f28cc3,$00c3528b,$00911549,$009b2958,$006a1639,$0036017,$0020014,$003301e,$00a01d66
    DC.L    $00d52d86,$00e0298b,$00ff4daf,$00ff71c5,$00f26eb4,$00d270a4,$00e49bc3,$00b2799a,$00391329
    DC.L    $003e2f33,$00320,$00030,$00040,$0040433a,$0060494e,$0062183c,$00c04f8b,$00b12271
    DC.L    $00b01468,$00c82979,$00c72975,$00c4256f,$00b12162,$008f1b50,$004d01e,$00290b,$0027914
    DC.L    $0025817,$0025a1a,$0024716,$0029e18,$00381e24,$002d1117,$002b914,$00270a,$004301e
    DC.L    $00a03a71,$00c54b8b,$00b02f74,$00ac2f75,$00a93171,$00931f54,$008b224f,$008e3059,$0052f2e
    DC.L    $00452a3a,$00ac9ea9,$00634453,$0045523,$00a6336c,$00af1e68,$00d73d90,$00de4296,$00c42a7b
    DC.L    $00dd4696,$00da4295,$00ac2c74,$0051233,$0025014,$002a31c,$002961a,$0028716,$00220e
    DC.L    $00210d,$0038018,$009d3e6a,$00a32d62,$00a6275f,$00b0366c,$00a84573,$00b35c82,$00b86280
    DC.L    $00954d64,$004a1e2f,$002c1622,$00108f,$00003,$00435,$00222,$00533,$00400
    DC.L    $00890,$00500,$001b916,$005d244b,$00e770bb,$00f55fbd,$00d53f9c,$00d03a97,$00eb55b2
    DC.L    $00ea54b1,$00f35bba,$00ca539e,$0038128,$002b1a27,$008e8f8d,$0041493f,$00010,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00111,$00011,$00020,$00010,$001399,$0035b1c
    DC.L    $008c2e64,$00c84294,$00d03094,$00de319f,$00dc2b99,$00c51481,$00bf147e,$00ae1b75,$007b1751
    DC.L    $0032018,$008c7b84,$00636462,$00500,$00413,$00025,$00010,$00060,$00030
    DC.L    $00533,$00341026,$006bb47,$00b82881,$00c81889,$00cf1089,$00c81183,$00c71782,$00c11c7e
    DC.L    $00a9196c,$00992d68,$003f020,$00675b61,$00adabab,$00412433,$00733050,$00d36099,$00c7397e
    DC.L    $00b6266e,$00bf2572,$00d3267c,$00e5368d,$00f653a4,$00c14c85,$00250d,$00798079,$003f4e46
    DC.L    $00020,$00548,$00493744,$006b455b,$0051f32,$00bc5489,$00e163a5,$00fd72bc,$00d44691
    DC.L    $00c0367d,$00c3407f,$00bc447b,$00a34a72,$003171e,$0031232f,$006b636a,$00999495,$00aca5a2
    DC.L    $00a8a0a0,$001e161d,$00406,$00403,$002e272c,$00867481,$002d11e,$00b1568e,$00d968ac
    DC.L    $00ed7fbf,$00f085c3,$00db75af,$00d76fa6,$00c45183,$009c3961,$00652640,$002b61a,$00482f43
    DC.L    $0026013,$0087114c,$00cb2c7c,$00e2318e,$00e43293,$00ec469f,$00f567b4,$00d366a4,$00ef9dce
    DC.L    $00c182aa,$003e102d,$00755b69,$00104a,$00aaa,$00042,$00555751,$00685156,$005172b
    DC.L    $00a73670,$00b2216f,$00a8b5c,$00c32572,$00ca2e75,$00c3276e,$00a51958,$00942a59,$004001b
    DC.L    $00523943,$00828080,$0076747a,$0075757b,$007c7b7f,$00878688,$00828583,$00848281,$00786d70
    DC.L    $004b2c3b,$0034015,$00892a5c,$00be4582,$00b43073,$00b53479,$00e361a2,$00a21e5a,$008ef46
    DC.L    $008a1c4c,$0058a2f,$004d2f42,$00aa9fa9,$005a414f,$0041724,$00922359,$00ab1d64,$00c12a7a
    DC.L    $00c52b7c,$00b92271,$00d6408c,$00de4594,$00a12668,$003b022,$00392133,$007f717c,$00867f84
    DC.L    $00756e71,$006c6164,$0036232c,$00260e,$008e3c5f,$009b2f5d,$009c2356,$00b2366c,$00af3c6e
    DC.L    $00aa3a69,$00962650,$00741438,$00541431,$003a1328,$002e1424,$00c07,$00504,$00635
    DC.L    $00533,$00000,$00220,$00500,$0019815,$00592348,$00e26cb5,$00fe68c1,$00e04ea0
    DC.L    $00de4d9b,$00dc4a98,$00e14e9e,$00ee57ad,$00c64e95,$0037124,$00291b26,$008d8e8c,$00444b44
    DC.L    $00010,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00111,$00011,$00010,$00010
    DC.L    $001096,$002d917,$008d3767,$00c34892,$00c5328e,$00d13096,$00d22d96,$00d22a94,$00d33197
    DC.L    $00ac2178,$00781952,$002e016,$00897b81,$0060645f,$00400,$00413,$00025,$00011
    DC.L    $00050,$00030,$00533,$00341125,$0069841,$00be2d82,$00d72590,$00e02194,$00e12694
    DC.L    $00e43198,$00e13797,$00c83587,$00b74682,$0043022,$006b5960,$00b2aaaa,$00482434,$00772f53
    DC.L    $00c7538e,$00b62b6f,$00b92e71,$00c32f77,$00d82e80,$00dd2f83,$00e63f90,$00bb407a,$002d010
    DC.L    $00807c77,$009e9f9b,$00201b1d,$0025c1a,$0060364f,$0039021,$005dc3b,$00de6aab,$00f671ba
    DC.L    $00f66ab7,$00ce4891,$00c64987,$00bc4a80,$00b54b7a,$00974a6c,$002ef1e,$00555052,$00b4b7b5
    DC.L    $00848680,$007b7870,$00524946,$00271a22,$0015412,$0022917,$004f2f40,$00512a43,$003601d
    DC.L    $00a23678,$00d14d9a,$00ce4795,$00d3559d,$00a93e7c,$00ac4a7e,$00dd76a3,$00b66181,$00471729
    DC.L    $003f2630,$0084747b,$003c1224,$00851f49,$00c93d7c,$00d9408f,$00e14199,$00d3338b,$00df4fa1
    DC.L    $00ec7dc1,$00ffb0e8,$00bc72a2,$003201d,$005a2c49,$00402136,$0018917,$00342c36,$00b0aeae
    DC.L    $005d444e,$004d026,$0097225f,$00a0e5c,$00b71769,$00ca2977,$00db3b83,$00d6367e,$00ad205f
    DC.L    $008f2756,$003c019,$005e4951,$00b0b1af,$00abacb0,$00a9acb0,$00adb2b5,$00aab0af,$00a3ada7
    DC.L    $00a6ada8,$009d989a,$00725564,$0047326,$00801d4f,$00ab2968,$00d14388,$00c7397e,$00b92b70
    DC.L    $00a7195a,$0090744,$008b1349,$005b52d,$004d2f42,$00a79fa9,$0056424e,$003c722,$00972e61
    DC.L    $00a92064,$00a91863,$00ad1967,$00c6317b,$00d33c85,$00cf3681,$00af3571,$003901b,$00654d59
    DC.L    $00c2b9bc,$00a6a4a4,$00acafad,$00989695,$00594c4e,$00293f,$007e314d,$0099315a,$00962152
    DC.L    $00a72b61,$00a7285f,$00a22259,$00941249,$008c1748,$0062c34,$0040121,$0047142f,$00351024
    DC.L    $0023f1c,$0016c12,$00001,$00000,$00740,$00b56,$0021101d,$00551f44,$00d65ea5
    DC.L    $00e953a7,$00e3509a,$00e55499,$00d44388,$00dc4791,$00d13589,$00b63a80,$0036020,$0023161e
    DC.L    $00949593,$00444b44,$00010,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00111,$00011
    DC.L    $00010,$00231,$001096,$00242d,$008d3e6a,$00c55498,$00bf368a,$00bb2382,$00cb2e8f
    DC.L    $00ea4dae,$00f459ba,$00b83285,$007e235a,$002b014,$0083777d,$00626661,$00200,$00413
    DC.L    $00025,$00011,$00040,$00120,$00723,$00351024,$006663c,$00c8388a,$00e7369d
    DC.L    $00ec2d9c,$00e32993,$00e22e93,$00e43694,$00d13a8a,$00bc4a86,$0044022,$006e565e,$00b2a5a7
    DC.L    $00512739,$0073264c,$00b13a77,$00b2266d,$00c13777,$00c7367a,$00ec4896,$00df3385,$00bd1869
    DC.L    $00921751,$002906,$00948281,$00776265,$002d917,$0060203e,$00691a43,$006c1344,$008d265f
    DC.L    $00e265ad,$00e059a7,$00c8428e,$00bb4384,$00933062,$00842e56,$007b2d52,$00612a43,$00152b
    DC.L    $00696c6a,$00909891,$00050,$00230,$00500,$00695a62,$002f1326,$00582540,$00571636
    DC.L    $004a32b,$0063a3c,$00971d63,$00cd4091,$00c53588,$00d14d99,$008f2963,$00711e4b,$00873558
    DC.L    $00723248,$00200b,$00423537,$009e9696,$002d1319,$0054b25,$00882350,$008e205b,$00971c66
    DC.L    $00a81c6f,$00b62e80,$00e474bc,$00fa99d9,$00c0619a,$0061a3c,$005bd3c,$004f1238,$003e1534
    DC.L    $00311b2e,$00b3a8b0,$00624352,$004f029,$00931e5b,$00b2216f,$00cd3081,$00e44692,$00df408a
    DC.L    $00df3d85,$00b22465,$00943060,$003c01e,$0077626a,$00a4a5a3,$00252728,$0014171b,$00171b1c
    DC.L    $00171f1e,$00412c,$0068716e,$00b5b2b4,$00755a6a,$0037016,$007f1a4d,$009d1a59,$00c02f74
    DC.L    $00b8296e,$00a31459,$00a51157,$009df50,$009e1f57,$005e52d,$00462939,$00a8a1a8,$0057464f
    DC.L    $003861e,$009a3162,$00a21c5e,$00b0236c,$00bc2b76,$00d5438b,$00cd377d,$00be276d,$00bc4179
    DC.L    $003e11b,$00624a52,$008e8386,$00865,$006a706b,$00afb5b0,$00666261,$0020810,$0053182d
    DC.L    $006d1f3e,$006d153d,$007d1445,$00991c54,$00a51a57,$00a81958,$00a7215d,$00811347,$005d22f
    DC.L    $005e1137,$00501432,$0033f20,$00121c,$00201,$00032,$00500,$00703,$0017614
    DC.L    $00581f46,$00df62ac,$00d73c91,$00e54f95,$00e24e8e,$00df4a8a,$00db4287,$00c22072,$00a9276e
    DC.L    $003701f,$00291c24,$00949593,$00404641,$00010,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00111,$00111,$00001,$00333,$0011a7,$0025510,$0091456e,$00cb609e,$00c2428f
    DC.L    $00bc2d82,$00d6419b,$00f059b6,$00ff6ac7,$00cf4f9e,$00893166,$0028014,$00877d83,$00616762
    DC.L    $00200,$00222,$00025,$00003,$00031,$00010,$00723,$00351122,$0069a3d
    DC.L    $00ce428f,$00ec3fa1,$00eb2f99,$00de258b,$00d82588,$00dc2e8c,$00cf3888,$00b84682,$0043020
    DC.L    $00715660,$00b5a4a8,$0054243c,$00792752,$00b93b7c,$00bb2b73,$00c43878,$00ba2b6a,$00d73a84
    DC.L    $00d02e7c,$00c62979,$00a22864,$00330d,$009a787f,$00683243,$00631332,$00d66093,$00e962a0
    DC.L    $00d2508f,$00d75699,$00e15ba7,$00d4539e,$00c54e92,$00aa4a80,$0040023,$00220d,$0023013
    DC.L    $001f817,$00302f33,$00a1aaa7,$00525f57,$00040,$005d6,$001d1e1c,$008c7e89,$0037d26
    DC.L    $009f4672,$00bc4d83,$00ba4b83,$00ab3673,$00a32168,$00b02673,$00ca3d8e,$00ba3e84,$006a1345
    DC.L    $0030015,$00230a,$002fe1c,$0037292d,$00787977,$009ea49f,$00696662,$002b1019,$0025011
    DC.L    $002601a,$0034023,$007384d,$00b73d8b,$00ff90dd,$00ff90d9,$00c7468b,$00cb488b,$00c14989
    DC.L    $00b44f87,$00a65f8a,$002e01d,$009c8391,$006c4859,$004d027,$00ad3c76,$00d64d97,$00c5317f
    DC.L    $00e34b96,$00c32872,$00c1206b,$00a01356,$009b3c6f,$003701d,$007b636d,$00464140,$00401
    DC.L    $00405,$00003,$00001,$00030,$00010,$00908c91,$00806477,$003f01f,$007b164a
    DC.L    $00a82665,$00d24489,$00c43c7e,$00a01559,$00a21358,$00a5185b,$00a92863,$006262f,$00442737
    DC.L    $00a9a3a8,$00594950,$003541a,$008b2352,$00991453,$00be317a,$00cc3d86,$00b7266b,$00a81559
    DC.L    $00c83176,$00c44981,$004451f,$00553a44,$0020e15,$00a14,$00010,$008b928f,$008d908e
    DC.L    $00453e41,$001e610,$001e0d,$001b0e,$0033019,$00871b4f,$00a41b59,$00b0195e,$00a4f53
    DC.L    $0097f4f,$00941b55,$009a2d5e,$00853056,$00501c34,$001b1f,$00c6b,$00001,$00a06
    DC.L    $00904,$001b71a,$00672d56,$00f373c0,$00dc3d93,$00f65fa5,$00f661a0,$00dd4481,$00d5387b
    DC.L    $00c62073,$00a01c63,$003801e,$00392a32,$0090918f,$00424843,$00010,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00111,$00102,$00104,$00201,$00f85,$002bc15,$008e466a
    DC.L    $00c76099,$00c3478d,$00c23a88,$00de4ea1,$00ea57ac,$00ff73cb,$00f779c5,$00994476,$00210f
    DC.L    $00888186,$005b625d,$00010,$00231,$00023,$00003,$00031,$00200,$00612
    DC.L    $00331122,$0063839,$00c13b84,$00da3390,$00da268b,$00d82588,$00d92a8b,$00df3693,$00d94396
    DC.L    $00bb4988,$0040021,$00735764,$00b9a4ac,$004d1c38,$007e2858,$00ca468c,$00bc2771,$00bc2f6e
    DC.L    $00bf3271,$00ca347a,$00c22a76,$00c53080,$009e2666,$0038013,$00a07481,$0074334d,$0070e38
    DC.L    $00ea5597,$00e33b87,$00f457a1,$00e04d97,$00df519e,$00ca4790,$00c04e8a,$00a44f7b,$002f419
    DC.L    $0032212c,$006e626e,$00807a85,$00a4a7ab,$00a1a7a6,$00111815,$00020,$00030,$002c2e2e
    DC.L    $009d8f9a,$0038723,$00a03169,$00c73d84,$00c03b81,$00a9256b,$00a32063,$00981359,$00bc337d
    DC.L    $00af397a,$0058e38,$002c219,$006a5460,$0071676d,$00a49fa1,$00b4b7b5,$00b9c0b9,$00a7aba5
    DC.L    $00928f8b,$00716a6f,$004a3c4e,$0027021,$00933270,$00ff8fd8,$00ff91e0,$00fd83d1,$00ca3988
    DC.L    $00d9418d,$00ce3d88,$00d85ba0,$00b55b90,$003301c,$00a28797,$00654354,$0060153b,$00dd72aa
    DC.L    $00d25196,$00c73782,$00c33179,$00b11660,$00b1d5a,$00a7165b,$008e2960,$003701d,$00725d65
    DC.L    $00454140,$00401,$00403,$0095a,$00546,$00010,$002d3231,$00ada6ad,$00846679
    DC.L    $004001f,$007b1447,$00a11f5e,$00c33679,$00c23c7e,$00a01a5c,$00a7195e,$00a5185b,$00a92561
    DC.L    $0066831,$004c2a3b,$00aba4a9,$0059474e,$0037418,$009f3262,$00b62e6e,$00a91d64,$00c1347d
    DC.L    $00d34588,$00bd2d6e,$00cb367a,$00c24a81,$0045824,$00563c49,$001b811,$00503,$00010
    DC.L    $0068716e,$00b2b9b6,$008f9290,$00797275,$00594e56,$00281e2b,$0022015,$0082204e,$009b124f
    DC.L    $00a5e53,$00a234d,$00a7a54,$00a51256,$009d1753,$00891c4c,$0052e2d,$001b08,$00b08
    DC.L    $00001,$00a05,$00d08,$001d61c,$005e214d,$00e05dad,$00d3338b,$00eb549a,$00e75291
    DC.L    $00d03774,$00de3f85,$00d72e84,$00a7216a,$003901f,$003d2d38,$00969494,$00464a45,$00010
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00111,$00102,$00105,$00403,$00f55
    DC.L    $002de17,$00874263,$00c56195,$00bd4586,$00b9347d,$00cc3f8e,$00e858aa,$00ff73c8,$00ff8dd7
    DC.L    $00a65485,$00200e,$00807a7f,$0059635d,$00020,$00240,$00023,$00011,$00022
    DC.L    $00200,$00422,$002f1222,$0060b38,$00b7387d,$00c72a81,$00ca1f81,$00cf2585,$00d22c8b
    DC.L    $00d83493,$00d24295,$00b84a8c,$0041024,$006e5462,$00b8a4b0,$004e1c3c,$00751b50,$00bf3982
    DC.L    $00b91f6e,$00b02160,$00bb2f6c,$00be2f74,$00d0408b,$00d4499a,$00a02f72,$0033011,$004d2033
    DC.L    $0038220,$005c132,$00dc418c,$00f33d91,$00d62a7c,$00dd3c8a,$00f059a8,$00e15aa0,$00db649b
    DC.L    $00b55e82,$0031e18,$00645e5f,$00afafb5,$0091939b,$008e8d91,$003c393b,$00304,$00657
    DC.L    $00032,$00302f31,$00948993,$002f01d,$009f296a,$00d34193,$00a31b69,$00a12169,$009c2161
    DC.L    $00961957,$00a42063,$00a5346e,$00521033,$00391c2c,$009a969b,$00aeb4b3,$00928f91,$00645e5f
    DC.L    $00403b38,$00797671,$00989990,$00a8a7a3,$00948d94,$0033a25,$0074e45,$00ef72b8,$00fb88d7
    DC.L    $00ff9dee,$00dc4ea1,$00cd3386,$00e44a9b,$00bf3981,$009d3f76,$003601f,$00967f8d,$005c4250
    DC.L    $00682747,$00e281b3,$00c14688,$00e75da5,$00c43378,$00b3175e,$00c21763,$00c4266d,$0092215b
    DC.L    $0043022,$007c6a71,$002e342f,$00777,$00546,$00201,$00dac,$00d1211,$00656767
    DC.L    $00766b73,$004e2b3f,$004001a,$007d1145,$009a1553,$00b82a6b,$00c43d7b,$00a82362,$00a61b5f
    DC.L    $00a5185b,$00ac2662,$006b933,$00502b3b,$00aea3a6,$005d474c,$003c419,$00ae3e6e,$00c03474
    DC.L    $00e0549b,$00f669b2,$00cf4488,$00c6387b,$00d54488,$00b54077,$003711e,$004d3b48,$0012612
    DC.L    $00339,$00022,$00d1a18,$00818883,$0092918d,$00ada6a3,$009d9595,$004e484d,$0021010
    DC.L    $007d1a42,$00991048,$00a0b4d,$00acd57,$00ad251,$00ab04e,$00a7a4d,$0098194d,$00681639
    DC.L    $00220c,$00904,$00001,$00704,$00e0c,$001f91c,$00531740,$00d353a2,$00e2429c
    DC.L    $00ed549f,$00db4587,$00cd3675,$00f55d9e,$00e04792,$00af3575,$003b221,$00372631,$009c999b
    DC.L    $00424543,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00111,$00102,$00004
    DC.L    $00605,$00e67,$002cf18,$00864261,$00ce6b9b,$00bf4a83,$00ac2a6b,$00b72d74,$00ee60ad
    DC.L    $00f764b8,$00fa7cc4,$00ae5a8a,$001f0e,$007a7479,$005f6963,$00020,$00240,$00041
    DC.L    $00010,$00031,$00010,$00222,$002f1124,$0063e40,$00b83b83,$00c82e87,$00cd2687
    DC.L    $00cf2d8d,$00d23090,$00da3596,$00d8429b,$00b74287,$0047028,$00644d5c,$00b5a5b0,$00572646
    DC.L    $0065d42,$00aa206d,$00be2074,$00ba246a,$00b82869,$00b2226a,$00d3438e,$00ce4192,$00ae347b
    DC.L    $006b1341,$0053a30,$0050030,$00972565,$00e13587,$00ec2b82,$00ea3786,$00d1337a,$00b12f70
    DC.L    $00a83b73,$00a4446d,$0089455e,$001603,$007a7b79,$00898c90,$0059e,$00405,$00403
    DC.L    $00927,$00401,$00000,$00333032,$0089808a,$0037724,$00931f60,$00b1206f,$00a7206e
    DC.L    $00a7276e,$00951955,$00a2245f,$00b12b6d,$00a1326a,$00521635,$00311a28,$00b3b5b6,$005d6564
    DC.L    $00857,$00500,$00a00,$00d94,$00030,$006c6e68,$00afa9ae,$003b132c,$0077f44
    DC.L    $00e965ab,$00e66cba,$00fe82d4,$00e45bad,$00d13e90,$00f458ac,$00e459a3,$00ad4b81,$003e224
    DC.L    $0098818f,$00533a48,$00652745,$00e88ab9,$00c85090,$00fc74bc,$00dc4c94,$00a4953,$00be1662
    DC.L    $00b31a5f,$00a5326b,$003f01d,$00736266,$00424942,$00000,$00001,$001d1a1c,$00867f82
    DC.L    $002a1c20,$001f7f,$003391b,$0043321,$0063732,$00881449,$009c1750,$00ab1f5c,$00ab235d
    DC.L    $00a61d5b,$00a2175b,$00a41b5f,$00ae2c69,$006a935,$004d2739,$00b0a2a8,$005f474f,$004051a
    DC.L    $00ac3a69,$00d84b8a,$00f96db4,$00d84c93,$00bd3073,$00cf4184,$00b22467,$00a33369,$003401b
    DC.L    $004d3b48,$0017f1a,$00006,$00013,$00020,$00061,$00220,$008f8984,$00aaa2a2
    DC.L    $005f595e,$0028415,$0089264e,$00aa235b,$009ec4d,$00a7852,$00b4757,$00bbd5b,$00bb185c
    DC.L    $00991348,$0061d30,$00270f,$00b04,$00012,$00607,$00707,$0023d1f,$005b2046
    DC.L    $00e063ab,$00e64aa1,$00eb4fa3,$00e44b96,$00d74282,$00ec639b,$00ff91c9,$00c46794,$003421a
    DC.L    $00301c28,$009a969c,$00404445,$00011,$00111,$00000,$00000,$00000,$00010
    DC.L    $00000,$00010,$00000,$00000,$00000,$00000,$00000,$00000,$00111
    DC.L    $00111,$00000,$00435,$00b68,$0025b18,$007f3b5a,$00ac4a76,$00b04070,$00c2467c
    DC.L    $00ce4988,$00db4c95,$00e24a9d,$00dd5aa3,$00913d6d,$0025014,$00746e73,$00606a64,$00030
    DC.L    $00130,$00050,$00040,$00040,$00030,$00133,$002ef24,$0061945,$00bc3a8d
    DC.L    $00c72b8a,$00c21c81,$00bc1b81,$00ba187e,$00c3167e,$00be1a79,$00ae2972,$004c026,$006a5362
    DC.L    $00b1a9b0,$004a2039,$0063f3f,$00ba307d,$00c22078,$00b81b6b,$00c62d78,$00be2570,$00d13784
    DC.L    $00c3297c,$00d44294,$00d6549b,$00dc5aa1,$00da4998,$00d63287,$00ee2d84,$00fb3587,$00d11e63
    DC.L    $00b3275d,$004a022,$00220e,$00280d,$002009,$00322729,$00a1a1a1,$004a494b,$00015
    DC.L    $00459,$00001,$00621,$00500,$00834,$00332e30,$008c858c,$002c41d,$00871d52
    DC.L    $00971153,$00a32868,$009e215f,$00a41e5a,$00b72b6a,$00a2175b,$00992864,$004df33,$0042283a
    DC.L    $007a737a,$00001,$00324,$00a88,$00943,$00410,$00371,$00f10e,$009e96a0
    DC.L    $003c132f,$00973168,$00f772b8,$00dc56a2,$00ee67b5,$00e963af,$00d34794,$00ed53a6,$00e85aa5
    DC.L    $00a0386d,$004001f,$009f8494,$00533848,$005d1839,$00d975a5,$00e76bad,$00e85da7,$00b3226d
    DC.L    $0094049,$00b62066,$00c63e7e,$00a1396e,$003c01b,$00786568,$0032332a,$00200,$00203
    DC.L    $00777378,$00918188,$00290d,$007c334d,$00b65079,$009d2758,$00ab2f65,$00ae2e65,$00a61d53
    DC.L    $00b4285d,$00b4285e,$00ab1c5a,$00a4165b,$009c175d,$00a82f6c,$005b331,$004e2a42,$00aea0ab
    DC.L    $005c434d,$004491e,$00962251,$00b52664,$00df5295,$00cd3f84,$00cd3b7c,$00ae1c5d,$00b72c70
    DC.L    $00a1326a,$003e420,$004b333f,$0017c16,$00005,$00003,$00021,$00010,$00754
    DC.L    $00322d2c,$00b3aaad,$00675c66,$0024013,$006cc35,$00a9275e,$00b9296a,$00be246b,$00b91a64
    DC.L    $00c6276d,$00c9306f,$009e1f52,$005ef30,$00270f,$00e05,$00200,$00006,$00809
    DC.L    $001d615,$00602347,$00dc62a8,$00ec50a7,$00e4429a,$00e44496,$00d64183,$00eb699e,$00ffa7d4
    DC.L    $00e194b6,$003891f,$002e1622,$008e8a90,$0046494d,$00012,$00111,$00000,$00000
    DC.L    $00000,$00010,$00010,$00010,$00010,$00010,$00000,$00000,$00000
    DC.L    $00111,$00111,$00111,$00200,$00200,$00c9b,$0022816,$00965172,$00cf6e9a
    DC.L    $00c95d8b,$00de6899,$00e665a0,$00ce4387,$00e851a1,$00e661aa,$008e3966,$00230e,$007e747a
    DC.L    $00606661,$00120,$00320,$00040,$00030,$00050,$00030,$00444,$0032e24
    DC.L    $0067949,$00b83088,$00d53696,$00c21d7f,$00ba1e83,$00cf2e94,$00d02189,$00d73190,$00b32e77
    DC.L    $005302f,$00665461,$00aca8ad,$004d283c,$005ee39,$00af2975,$00cb2e85,$00af1367,$00bc2372
    DC.L    $00c22a75,$00bd2571,$00c1267b,$00d73e94,$00d74397,$00e549a0,$00d72d8d,$00dc2383,$00e01a72
    DC.L    $00e4226f,$00c51656,$009b1948,$0034018,$00412c3b,$00634b57,$007c6a71,$00a19ea0,$00a1a3a3
    DC.L    $00181314,$00201,$00467,$00134,$00230,$00540,$00501,$002c2729,$00908990
    DC.L    $002e71d,$0082194a,$0097104e,$009f205d,$00a42360,$00a81c59,$00ae1c5d,$00a61a61,$00952261
    DC.L    $004c732,$0047253d,$00998b96,$00dac,$00503,$00816,$00802,$00501,$00501
    DC.L    $002f2a2c,$00b7a8b6,$00421431,$0089235a,$00f167ae,$00f35fad,$00f861b1,$00ff83d0,$00f564b2
    DC.L    $00ee52a6,$00cf4089,$009a3164,$004101d,$00967b8b,$005d4050,$0056c2e,$00a73c6d,$00a22263
    DC.L    $00b42671,$00a51462,$00b3226d,$00d34689,$00cd4f8a,$00a44173,$0036015,$0080696e,$00716d68
    DC.L    $00816,$00d6d,$00aca4ae,$0089717d,$0036012,$00943458,$00ae2a5f,$00bc2967,$00d24381
    DC.L    $00bf366e,$00b02a5e,$00bd386a,$00af265a,$00a31752,$00b82d70,$00af2c6f,$00b94783,$0062113e
    DC.L    $00401e36,$00b2a1ae,$005d4350,$003e21a,$008e1a49,$00b72866,$00d5488b,$00c03275,$00c32d6f
    DC.L    $00c22c6e,$00b4266b,$00ae3d76,$003a019,$005b3f4c,$001be16,$00003,$002aa,$00053
    DC.L    $00052,$00010,$00242222,$00aba5aa,$006c606c,$0023014,$0069a36,$00aa2b62,$00b82c6b
    DC.L    $00c02b6f,$00af185e,$00be256a,$00c62f6e,$00a72a5c,$00641939,$00210d,$00904,$00001
    DC.L    $00005,$00206,$0025b1b,$0058183c,$00ea6eb4,$00e4449e,$00e13692,$00d93184,$00f45ea0
    DC.L    $00e8689f,$00ff9ac7,$00e094b6,$003ba1e,$00351a24,$00958b91,$00464547,$00102,$00102
    DC.L    $00001,$00001,$00001,$00001,$00001,$00001,$00001,$00001,$00001
    DC.L    $00001,$00001,$00102,$00302,$00501,$00500,$00700,$0012b10,$0021616
    DC.L    $00ab668b,$00ec90bf,$00de78a8,$00f384b8,$00ff86c2,$00cb478a,$00e04e9c,$00e05ca2,$00933c68
    DC.L    $002b011,$0089777e,$00676362,$00500,$00601,$00421,$00010,$00030,$00020
    DC.L    $00b33,$0037e23,$0066440,$00c63c90,$00ed4da7,$00d52f8e,$00ca2e8d,$00e347a6,$00ec41a3
    DC.L    $00eb4ea5,$00ae397e,$004602a,$00665863,$00aaa9ab,$00462637,$006b224a,$00bd4088,$00bc277d
    DC.L    $00b01d6f,$00b01f6d,$00b42671,$00be307d,$00c5368b,$00d6479e,$00da4a9d,$00d84399,$00dd419f
    DC.L    $00c7207d,$00d1186e,$00e22a76,$00c01958,$008df40,$0035018,$004a2d44,$008d7080,$00816b77
    DC.L    $00a09fa1,$007a7f7d,$00400,$00832,$00613,$00000,$00010,$00394,$00000
    DC.L    $002b252a,$009a8f99,$003341e,$00871348,$00a71556,$00a41a5a,$00a41c5c,$00ad1f60,$00ae2063
    DC.L    $00a51a64,$00a93276,$00621142,$002b01a,$0083727d,$00675d63,$00301c29,$00321b2a,$00311b2d
    DC.L    $003d2837,$002f1b28,$00877380,$007a6072,$003201a,$0092295c,$00c93b7e,$00c82576,$00eb4096
    DC.L    $00ff63b9,$00e14096,$00c72279,$00a4135d,$00892255,$003f11f,$00957e8d,$00634957,$0057c2c
    DC.L    $009e3161,$00a62463,$00bd3079,$00b0226d,$00de519a,$00d24888,$00ba3d75,$008f2959,$004501f
    DC.L    $004d2d38,$00928789,$002f232f,$004f4250,$008e7e8f,$00452538,$0043321,$0084244d,$00a5245f
    DC.L    $00c63475,$00cf3d7e,$00bc316e,$00b33668,$00b33b6b,$00a6295b,$0098184f,$00cb4783,$00bc3e79
    DC.L    $00be5286,$00611239,$00512d43,$00b6a5b0,$00614552,$004261e,$00a12c5d,$00b42564,$00cc3f82
    DC.L    $00cc3b80,$00c12b6d,$00cb3375,$00c73478,$00ad366d,$0046320,$00502f3d,$0019c14,$00003
    DC.L    $00020,$00040,$00062,$00040,$001e2321,$00a2a1a3,$00675d69,$002c51b,$00822951
    DC.L    $00be447a,$00b32c6a,$00ae1d61,$00ae1560,$00c0236d,$00c72c6f,$00b13269,$006c2246,$001a0d
    DC.L    $00307,$00024,$00004,$00107,$0022917,$0068254a,$00e86bb3,$00e949a3,$00de2e8b
    DC.L    $00d82b81,$00da4186,$00c9477e,$00f38ab7,$00d586a7,$003ca1c,$0030151e,$009d9295,$00474545
    DC.L    $00302,$00302,$00201,$00201,$00001,$00001,$00001,$00001,$00001
    DC.L    $00001,$00001,$00001,$00201,$00302,$00502,$00501,$00500,$00500
    DC.L    $00109e,$002281a,$00a35c87,$00ec8cc2,$00dd72aa,$00e976af,$00f679b7,$00e45da1,$00de4d98
    DC.L    $00ce4c8d,$00913b65,$002f012,$008b767e,$00676162,$00503,$00604,$00612,$00010
    DC.L    $00030,$00010,$00b41,$0037f21,$0072144b,$00c74390,$00c92e83,$00c92981,$00c53189
    DC.L    $00ce3c94,$00f154ae,$00ea5aac,$00a43b7a,$0038022,$00665961,$00afaaab,$00462534,$00712b50
    DC.L    $00bd468b,$00a6186b,$00be2f7e,$00ae206d,$0099f5c,$00bf3886,$00b62d83,$00be338b,$00d94a9f
    DC.L    $00d8459a,$00dc45a2,$00ca2783,$00d72176,$00e22a76,$00c81c5e,$009ae44,$0059028,$0046525
    DC.L    $003e01b,$002d011,$00362a30,$00676866,$00830,$00b33,$00912,$00533,$00020
    DC.L    $00063,$00000,$00322c31,$009d8f9a,$002f017,$00881046,$00ad1759,$0098a4d,$0098d50
    DC.L    $00aa1d60,$00b72970,$00a91c6b,$00bc3e86,$007f1e56,$003c01d,$003441e,$003bc26,$004ac30
    DC.L    $0059133c,$004dc39,$004ab35,$0055183c,$0042726,$0042c29,$003d017,$00a63365,$00d74284
    DC.L    $00d22575,$00ef3b94,$00f246a4,$00c8217e,$00d22880,$00b7236b,$00841e4e,$0035017,$0092808d
    DC.L    $005b4452,$0057d2b,$00bf5280,$00aa2865,$00c4367b,$00ee64ac,$00e65da1,$00c33c7a,$00ac3066
    DC.L    $00ba4d7e,$006092f,$0039015,$003781e,$0037c27,$0035928,$002f01e,$003c021,$005532d
    DC.L    $00942b5e,$00c43f7e,$00d13d83,$00b82869,$00ac2b64,$00a33863,$008d3057,$0081244b,$00701039
    DC.L    $008f2d59,$00bb5c88,$00a35279,$004d1330,$003c2331,$00b6a7af,$00593f4c,$004d102a,$00c54f82
    DC.L    $00ba2869,$00b6256a,$00c63278,$00bd2769,$00b41e60,$00d13c80,$00a93269,$003f01c,$00593d4a
    DC.L    $001af17,$00001,$00097,$00060,$00040,$00030,$00282b29,$00ada8aa,$00655763
    DC.L    $0026013,$0081254e,$00a92d61,$009ae4d,$0099349,$00b21461,$00c1206c,$00c3246a,$00b22f68
    DC.L    $006c2147,$00160e,$00009,$00014,$00014,$00004,$0023c1a,$006c2e52,$00ea70b7
    DC.L    $00e849a5,$00e63493,$00e4348d,$00df468b,$00c43f77,$00ef7dac,$00d57fa1,$003db1d,$002c151a
    DC.L    $009b9394,$00494746,$00601,$00602,$00401,$00401,$00401,$00401,$00201
    DC.L    $00201,$00302,$00201,$00401,$00401,$00401,$00502,$00602,$00501
    DC.L    $00540,$00231,$0075b,$001f51c,$007f3565,$00c65f9c,$00b94483,$00ba3a7b,$00cf4789
    DC.L    $00f162a7,$00e24e96,$00ce4d8a,$0088355b,$00270c,$00887a7e,$00626262,$00203,$00305
    DC.L    $00213,$00000,$00030,$00020,$00851,$00311320,$005fe3f,$00b13c81,$00b52a74
    DC.L    $00cf3e8c,$00bc3989,$00a52675,$00d952a2,$00e96cb6,$00953772,$0039022,$0069565f,$00b4a7a9
    DC.L    $004f2838,$00651a40,$00a12b6c,$00a51867,$00b72674,$00af216e,$00a01663,$00c43d8d,$00bd358d
    DC.L    $00b72d85,$00c5368b,$00cc378d,$00cf328d,$00e33894,$00ee3089,$00e62274,$00e3246d,$00c31457
    DC.L    $00a7144e,$008ed40,$00b0365f,$00913755,$00262e,$00847c7d,$001c1414,$00700,$00912
    DC.L    $00401,$00032,$00032,$00001,$00352e33,$00968893,$0030018,$0090184e,$00a2b50
    DC.L    $0093449,$0099d54,$00a71d64,$00b32570,$00b21f73,$00ad2371,$00901656,$0083174c,$007c1449
    DC.L    $00891953,$00a21963,$00ac1c6e,$00b82e82,$00aa2777,$00b03378,$00a9366f,$00cc6997,$00c9608d
    DC.L    $00c44075,$00cf3576,$00df3080,$00f7449f,$00ff66c5,$00d0318f,$00eb4199,$00d03982,$007d1949
    DC.L    $0030014,$00958792,$00584450,$004e420,$00ad3e6a,$00b22f68,$009e1252,$00e960a4,$00e15b9d
    DC.L    $00ad2965,$00a72b5f,$00dd6d9d,$00a23664,$00982857,$007ef41,$00811950,$008b245d,$00a0356e
    DC.L    $0095265e,$00b8457e,$00b53876,$00cf4188,$00c6377c,$00aa2361,$0073535,$0041015,$002d0e
    DC.L    $002a0f,$0028010,$00200d,$002a31c,$002871c,$00120c,$00645d64,$00aaa4a9,$00614953
    DC.L    $0045620,$00ca5086,$00c52c71,$00b51d66,$00c83079,$00c73274,$00b31f5f,$00bf2d6e,$00a23065
    DC.L    $0030016,$0051404b,$00f7e,$00524,$00010,$00010,$00cd9,$00410,$00201818
    DC.L    $00b6a7ab,$00725b69,$002d017,$00791741,$00931146,$009b747,$00add55,$00b6f5e,$00c11867
    DC.L    $00bc155e,$00a81e58,$0066143e,$00190e,$0030b,$00006,$00037,$00204,$0021f1c
    DC.L    $005f274a,$00ea74bb,$00db3d9b,$00e43596,$00eb3e98,$00ff7cc2,$00d9518b,$00e26597,$00cb6b8f
    DC.L    $003881a,$002d1c20,$00938f8e,$00494844,$00501,$00601,$00401,$00400,$00401
    DC.L    $00400,$00201,$00200,$00302,$00311,$00502,$00400,$00401,$00501
    DC.L    $00602,$00501,$00210,$00010,$0075b,$0027d25,$007e3367,$00cb61a3,$00c74c90
    DC.L    $00c74288,$00c53a7e,$00dc4d92,$00d74389,$00e365a0,$00914565,$001e06,$00867b7e,$00656466
    DC.L    $00203,$00305,$00023,$00010,$00030,$00040,$00771,$002d141e,$004b02c
    DC.L    $008b1d5d,$009a155b,$00b82e76,$00c0418c,$00bd418d,$00cc4a97,$00bf4990,$00973c74,$0038021
    DC.L    $00705761,$00baa7aa,$00502435,$0066193e,$00a32b6c,$00a41865,$00a91964,$00af1f6a,$00b92f7c
    DC.L    $00c1398b,$00de56ae,$00d750a6,$00b83181,$00ba2d7e,$00c73086,$00d12982,$00e42881,$00eb267c
    DC.L    $00ea2777,$00c4752,$00bed52,$00b3d4a,$00bc2056,$00a32e55,$0031010,$009e8d96,$00615659
    DC.L    $00500,$00401,$00001,$00032,$00043,$00201,$00322b30,$00958590,$003eb26
    DC.L    $00a32d62,$009e94d,$009bc51,$0097b52,$00b1246d,$00b0226f,$00b61e77,$00ad196d,$00ab2468
    DC.L    $00a62562,$0093f52,$00a2e5c,$00c21472,$00d31c84,$00c2127d,$00c31b7e,$00b41369,$00d24186
    DC.L    $00cc5086,$00db5e90,$00d94781,$00ca2568,$00d82475,$00de2b86,$00ff61c1,$00f759b7,$00dd338b
    DC.L    $00c02a70,$00761341,$0035119,$00958a92,$005c4b54,$004811b,$0082153c,$009a184f,$00a51958
    DC.L    $00d44d8b,$00d34e8c,$00a8265d,$00b93c6e,$00b94776,$009a2556,$009a124c,$0098a4d,$00a61c64
    DC.L    $00a51c66,$00bb2e77,$00be3279,$00c23b7f,$00bd337a,$00c93883,$00b92b72,$00b63671,$006a832
    DC.L    $0043e22,$00654a53,$005b474c,$0056484e,$004e434b,$00483f49,$00605b64,$008d8d93,$00b1b5b6
    DC.L    $00a2a0a0,$00513943,$004dd2a,$00b83d75,$00ba1e65,$00c92b77,$00d93e89,$00c42f73,$00c23070
    DC.L    $00b31f5f,$00942055,$003aa24,$00463843,$00181017,$00835,$00500,$00500,$00410
    DC.L    $00720,$0044393b,$00b9a6af,$00745969,$0032019,$0073113d,$008eb44,$00a2a4c,$00b0b54
    DC.L    $00b8d5b,$00bb105e,$00b5d54,$009b114b,$0061e35,$001d0f,$0080c,$00007,$00501
    DC.L    $00927,$0010410,$005d2e4f,$00e572bb,$00de45a2,$00d22a8b,$00f24ca7,$00ff73bb,$00d04582
    DC.L    $00dd5186,$00bd5279,$0033718,$00221b1e,$008c908b,$00454b46,$00120,$00310,$00200
    DC.L    $00200,$00000,$00010,$00000,$00010,$00111,$00120,$00111,$00010
    DC.L    $00000,$00120,$00111,$00310,$00830,$00500,$00e912,$0024721,$0080346a
    DC.L    $00ce63a8,$00bd458c,$00c8468d,$00de579d,$00db5094,$00d4478a,$00e670a5,$009d5371,$001f07
    DC.L    $00887a80,$00676466,$00403,$00302,$00022,$00010,$00040,$00040,$00780
    DC.L    $002d151d,$004a32b,$00891d58,$009d1458,$00a5155d,$00b02771,$00c63f8d,$00d14795,$00bf428a
    DC.L    $009e3d76,$003701d,$00765865,$00bfa8ad,$004f1f31,$006a1b42,$00ac3272,$00a71966,$00ad1d68
    DC.L    $00ac1c67,$00ba2e7b,$00ae2576,$00ce459b,$00de5bac,$00be448b,$00b3377d,$00c9418f,$00c0257a
    DC.L    $00d6267f,$00f0348d,$00f33a90,$00d31c6c,$00b944f,$00b4548,$00c5225a,$009b1c49,$0036015
    DC.L    $00715769,$0082717c,$00211a1f,$00cef,$00043,$00001,$00045,$00201,$00322b30
    DC.L    $00978890,$0041f27,$00a63567,$00a41455,$009ed52,$0097650,$00aa1964,$00b72272,$00be1f7b
    DC.L    $00ce3289,$00c1387c,$00a01d5c,$00a51b63,$00a3a5f,$00c91a7c,$00c7f7b,$00c2f7c,$00b9f75
    DC.L    $00b7136b,$00af1861,$00e05d96,$00c64074,$00d63a76,$00e13478,$00ee3284,$00d41c76,$00c92382
    DC.L    $00e3429e,$00d72e84,$00b21f63,$00761440,$003811a,$0090838b,$005e4d56,$0048219,$0080163b
    DC.L    $00a22356,$00ae245e,$00be3972,$00b63169,$00b12b60,$00961849,$008d1a46,$00972455,$008fd4a
    DC.L    $00a51b62,$00bb2d7a,$00b92877,$00b5216f,$00d33f8b,$00bd2e77,$00bb2e77,$00d44391,$00b22870
    DC.L    $009b235e,$0056025,$0058283a,$009c858a,$00988b8d,$00958d8d,$00a7a2a1,$00ada8a9,$00acabad
    DC.L    $00a3a5a6,$00adb0ae,$00aca7a6,$005e4650,$0047a26,$00ae366d,$00a7c56,$00c2216f,$00c92b77
    DC.L    $00af1a5e,$00be2a6a,$00b92162,$00951c4f,$0034016,$004b3a43,$0019f15,$00400,$0011cb
    DC.L    $00540,$00020,$00020,$00726c71,$009a8996,$0060435a,$0037022,$00751244,$0094124f
    DC.L    $00a6f55,$00b0d58,$00b8e5a,$00b3d54,$00ade4e,$00931146,$0063e34,$00240f,$00b0a
    DC.L    $00008,$00901,$00d39,$0014a16,$0054294a,$00f789d1,$00e048a7,$00d63193,$00ff5cb7
    DC.L    $00f869b2,$00c53c7a,$00d9487f,$00a6365e,$003391b,$00211e20,$00939896,$00414843,$00020
    DC.L    $00120,$00010,$00010,$00010,$00010,$00010,$00010,$00020,$00020
    DC.L    $00020,$00020,$00010,$00020,$00020,$00120,$00a30,$00700,$0011913
    DC.L    $001f21b,$00904579,$00e278bd,$00cc549b,$00e060a8,$00ed69af,$00f46eb0,$00e6619f,$00d26292
    DC.L    $008f4a65,$00220c,$008c7b84,$00655f64,$00401,$00311,$00031,$00020,$00040
    DC.L    $00040,$00780,$002d151d,$004e72f,$00851954,$009384c,$00a1a53,$00a3125d,$00ae1d6c
    DC.L    $00bc2a7c,$00b22e7a,$00993571,$003b01f,$00735463,$00bea6ae,$0053243a,$0059c32,$00931b5b
    DC.L    $00b12670,$00ab1d68,$00a91b66,$00b42a77,$00b42b7c,$00ac2476,$00c54995,$00bc5592,$00a14079
    DC.L    $009e3274,$00b73681,$00ca297f,$00d5257f,$00fa47a2,$00f64398,$00b7351,$00ba94e,$00d0235f
    DC.L    $00c13165,$0056023,$002d010,$0041f27,$003d1929,$00261a20,$00222424,$00022,$00055
    DC.L    $00001,$00342d30,$0097878e,$0034317,$009b2d5d,$00ac1d5c,$00ad185c,$00b11962,$00a2a56
    DC.L    $00c02576,$00c82581,$00d93d94,$00a22164,$0088144f,$008b1a56,$008f185c,$009a1162,$00a91a71
    DC.L    $00a41971,$00a41e71,$00b03379,$008d1954,$00b54a7b,$00a93564,$00b8225d,$00e0357a,$00e12a7b
    DC.L    $00d41d75,$00cf2683,$00ec47a2,$00c92376,$00a11054,$0072103c,$003b21b,$00988991,$00635158
    DC.L    $003e010,$00862043,$00971a4b,$00ae285d,$00bc366b,$00bd376b,$009e1548,$0089938,$0084113c
    DC.L    $00821944,$0082194c,$00a63670,$00a5286d,$00b63079,$00bb2e77,$00bb2d74,$00c1337a,$00b82972
    DC.L    $00b3216f,$00b72c76,$00a52a68,$0067533,$003b014,$0032714,$002a812,$002b1619,$008c8380
    DC.L    $007e7d79,$001f2220,$00bec,$00373834,$00ada8a7,$005d444e,$0046925,$00a32b62,$00a4c55
    DC.L    $00b2115f,$00b31561,$00bf296b,$00ba2765,$00c32767,$009f2456,$003c31c,$004f3c45,$0015b11
    DC.L    $00613,$00400,$001a1817,$00818684,$00292628,$0024e1a,$003091f,$003501d,$004301f
    DC.L    $007fc45,$0098d50,$00a6e57,$00b81b65,$00a61455,$0098104a,$0094164a,$007d1943,$00531330
    DC.L    $001c0b,$00706,$00004,$00b00,$00901,$001b101a,$00512746,$00ee82ca,$00f15dbb
    DC.L    $00ea49ab,$00f455b1,$00ff78c2,$00d95492,$00c73a73,$009e305a,$0025011,$00272328,$009ea0a0
    DC.L    $00404543,$00010,$00897,$00010,$00010,$00453,$00010,$00231,$00010
    DC.L    $00010,$00675,$00010,$00010,$00010,$00253,$00042,$00010,$00800
    DC.L    $00901,$0016f16,$001f31a,$008b4274,$00f28acb,$00d45da2,$00d959a0,$00e461a4,$00cc4a89
    DC.L    $00c54580,$00b84c7a,$00793851,$001d08,$00897784,$00686067,$00500,$00510,$00261
    DC.L    $00020,$00030,$00020,$00bb5,$002c131d,$004932c,$00851856,$009ab50,$00abd59
    DC.L    $00ae1463,$00b01669,$00c72b82,$00b12977,$00902966,$003601d,$00735868,$00bba8b1,$00482137
    DC.L    $0051a32,$00911d5e,$00a8226b,$009a145d,$00b12b74,$00b62f7b,$00ab2371,$00a62171,$008e1d61
    DC.L    $0052636,$003e22b,$003c02b,$006bd4d,$00c03586,$00d32d88,$00eb3d9b,$00fe4ea7,$00ba958
    DC.L    $00c11055,$00da2464,$00d82e68,$00a5164d,$00a52a5c,$00992953,$006b1533,$0033714,$00796a6e
    DC.L    $001c1f23,$00011,$00001,$00332e2f,$00998a8e,$0038618,$00a33362,$00c12e6c,$00bf2265
    DC.L    $00cf2d75,$00be1a67,$00b81364,$00c11b76,$00bf2b7f,$0075846,$0044022,$003401a,$0028013
    DC.L    $0039025,$0036025,$0037028,$002901c,$0031223,$002e01d,$002a016,$004b125,$009a1e54
    DC.L    $00e14487,$00d62979,$00da2980,$00ea4099,$00f34ea5,$00b31062,$0093548,$0073d3c,$003b11a
    DC.L    $0098858e,$00665159,$003f013,$00791838,$00921c47,$00a72456,$00c43c70,$00b32a5d,$0099c3d
    DC.L    $00941340,$008d1d45,$005b327,$0039019,$004582a,$005c432,$00b0487d,$00fa89c2,$00ed72ac
    DC.L    $00bf3a79,$00cc3e83,$00cf3887,$00c02c7a,$00a41f65,$0087124b,$007f1d47,$00852e50,$007a2a49
    DC.L    $0039013,$004d363a,$001310c,$00010,$00253,$00010,$009c9796,$005c444c,$0043622
    DC.L    $00982057,$00ba226b,$00d0307c,$00c0236d,$00b92464,$00c93672,$00c62b68,$00a22858,$003b21b
    DC.L    $00493843,$0012b12,$00001,$00400,$00787273,$009b9295,$001f4e,$005b1d35,$0071193d
    DC.L    $007e1040,$0092124d,$00a11054,$00a4953,$00b31561,$00ae2367,$0073c3f,$004b023,$0039018
    DC.L    $003461d,$001f414,$0020151f,$00003,$00023,$00a23,$00701,$0018a15,$00643555
    DC.L    $00ef81c9,$00fa64c1,$00f453b5,$00e74aa5,$00f56fb8,$00ff93d1,$00bf3c75,$009c3360,$0038a21
    DC.L    $003d2f3a,$00a1979d,$00484344,$00501,$00200,$00612,$00644,$00400,$00200
    DC.L    $00834,$00422,$00834,$00200,$00200,$00333,$00222,$00000,$00000
    DC.L    $00200,$00903,$00905,$00628,$001b216,$009c5782,$00db7ab3,$00ef7dbd,$00da5ea0
    DC.L    $00d85a9b,$00df639f,$00d45991,$00bd5683,$00793a54,$002a616,$00836d7f,$00756975,$00501
    DC.L    $00732,$00000,$00577,$00000,$00422,$00610,$00321524,$004802d,$008c1c5c
    DC.L    $009b74f,$00b0c59,$00adc5c,$00abd61,$00c62a7f,$00b9317f,$008f2b65,$0039021,$00725868
    DC.L    $00b1a0ab,$0049223b,$0054c36,$008c1859,$009f1864,$0099145d,$00a8236c,$00b22876,$00b02876
    DC.L    $00ab2472,$00881d5c,$0029016,$002a722,$0026020,$0048034,$00ad327c,$00cb3288,$00cc2782
    DC.L    $00ec429a,$00c61a68,$00bba4f,$00d31a5a,$00d21b58,$00bf1654,$00be245f,$00cf4378,$009f345b
    DC.L    $002f08,$0098808a,$00646066,$00014,$00001,$002a2828,$00958789,$0039818,$00ae446d
    DC.L    $00cf417c,$00d3397a,$00cc2b71,$00d42c78,$00c01668,$00ba136a,$00a51665,$005d239,$002b017
    DC.L    $00442a38,$003c2e34,$003b2a37,$003c2d3b,$00392c3a,$00362c39,$00333039,$002b262f,$00352536
    DC.L    $00230e,$007ef43,$00c63175,$00c92573,$00ff58ab,$00dd348a,$00ba1769,$00ba1969,$009e1356
    DC.L    $007a1443,$003b01a,$0098828e,$006a535b,$0040014,$00751835,$007962e,$009f1d4c,$00cf4777
    DC.L    $009be3f,$0099b38,$008eb36,$00952a51,$004701a,$002a515,$001c0c,$003f11f,$00ad5a81
    DC.L    $00c96a96,$00c85b8b,$00d95d93,$00cc4080,$00d73d8a,$00c22978,$00a71d65,$009f1d5c,$00a82f62
    DC.L    $00a3305c,$0094234f,$005b626,$0053313c,$00a45,$00201,$00000,$00150,$009b9695
    DC.L    $00705961,$003c01b,$00a83067,$00b21b61,$00b71965,$00bb1f66,$00bd2a68,$00c2306a,$00bc2661
    DC.L    $009f2555,$003d31c,$00563f4d,$0017c16,$00605,$00501,$00a89ca2,$008c7b86,$0029113
    DC.L    $00832f51,$00972450,$0095b45,$00aa1253,$00ace55,$00b2135d,$00b71f68,$00a42765,$005af35
    DC.L    $0027014,$00573d4d,$006e606b,$00817a81,$00363537,$00032,$00010,$00333,$00501
    DC.L    $001fb17,$00642b4c,$00fd89cf,$00f45dba,$00fa55b7,$00dd3e9a,$00e35da6,$00ff9fdc,$00e471aa
    DC.L    $00a64774,$003a01d,$00411f30,$009f818e,$00b49ca6,$00382931,$0013810,$0016911,$00f4c
    DC.L    $00136e,$00116e,$00114c,$00f4c,$00103b,$0016b13,$00127f,$0012a11,$00f7e
    DC.L    $00171017,$00f8f,$0016e15,$0012711,$00504,$002b2c30,$002d1c29,$008e5175,$00eb90c1
    DC.L    $00e176ae,$00dc66a1,$00e26aa4,$00d15a91,$00d76097,$00d674a0,$00975872,$0022010,$007a5e75
    DC.L    $00ac99ac,$00493e48,$00504,$0011f15,$0074d,$0012a14,$00d2c,$0054454d,$00684258
    DC.L    $004f033,$00942063,$00ac145d,$00b2854,$00b1a59,$00b41363,$00d4398a,$00b53079,$009f3f75
    DC.L    $003701d,$00715866,$00b6a5b0,$004f2740,$0052733,$008e1559,$009f1360,$00ad2370,$00ad2370
    DC.L    $00ad1d6f,$00ae1e70,$00ab216e,$008b215c,$0026014,$00594657,$003d1d36,$004352d,$009b306e
    DC.L    $00c93f8c,$00be257a,$00cc297e,$00d9317d,$00bde52,$00d41e5e,$00d21d5a,$00bc1050,$00b41855
    DC.L    $00bd326b,$00a13b65,$003751d,$006b5462,$0094828f,$001df1a,$00c8d,$006e696b,$0096898b
    DC.L    $0036b1a,$009f3e66,$00b8366d,$00bf2d6d,$00d2377c,$00d02f7a,$00d02978,$00d0277d,$00a91d6a
    DC.L    $0052334,$003e1731,$009f8a92,$00aaa0a0,$00a59fa0,$00a6a1a2,$00a19c9d,$00a8a9a7,$009ba29f
    DC.L    $00959a99,$007e7480,$003dd29,$0073539,$00bd286c,$00c11f6d,$00e84192,$00ff5caa,$00c32270
    DC.L    $00b51666,$00a61d61,$00811b4b,$003e01b,$009d8591,$006b535d,$003d010,$006e112e,$008d1a41
    DC.L    $008dc39,$0097103e,$0095a36,$009df3c,$00961640,$00881e45,$004401a,$00492b36,$00361f27
    DC.L    $0033014,$00c07896,$00cd7c9d,$00ac4b73,$00bc4474,$00d84e88,$00c62c73,$00b81f6a,$00a3175e
    DC.L    $00a21d5c,$00b12d62,$00ae2b5d,$009c194c,$0063026,$005b2e41,$00453840,$0017e18,$00161217
    DC.L    $008dc,$00a09e9e,$00543f48,$0045822,$00aa3268,$00ad1759,$00a8e55,$00bc2368,$00c3336e
    DC.L    $00bf3067,$00be2f66,$00a7325f,$003c017,$00624051,$008c7885,$00b06,$0074636c,$00b2a1ac
    DC.L    $00634e5d,$002a017,$00883058,$00a42d60,$009c104d,$00a61052,$00a094e,$00b52266,$00b6296c
    DC.L    $0096275b,$00531330,$00432532,$00b0a5ad,$00adaaac,$00777575,$00200,$00754,$00320
    DC.L    $00010,$00613,$0025b18,$0058183b,$00f57dc4,$00ed52ad,$00ea43a4,$00df3e9a,$00ea61ab
    DC.L    $00ff92d2,$00ffbdf7,$00bd6190,$0048024,$0034015,$003d71e,$0040f23,$0039e23,$002e618
    DC.L    $003181d,$002e618,$003d1429,$0034c1e,$002f61b,$00391123,$0038f24,$002c416,$00371025
    DC.L    $002e81a,$002e91d,$0029516,$002eb1f,$002aa1b,$001c212,$003a2c38,$00a3a4a8,$002b2028
    DC.L    $00885870,$00ffb6da,$00d47ba6,$00de7bab,$00ef8abd,$00d36a9d,$00ab3f73,$00c46591,$00793754
    DC.L    $002a010,$002d01e,$00411534,$00481e35,$002c318,$0034e24,$002f821,$0038f2a,$002f51e
    DC.L    $003af24,$002f012,$0068a43,$00b6397f,$00aa1057,$00b0b54,$00a5950,$00b82870,$00b7357c
    DC.L    $00ce619f,$00a65783,$003411d,$006e5962,$00baa7b0,$004c223b,$004f22e,$00951a5e,$00a41362
    DC.L    $00ab1c6b,$00af1d6f,$00ac186c,$00b01c70,$00b52877,$008b225b,$0026015,$007d7078,$00422b3a
    DC.L    $003ee2b,$009d4c7b,$00b64987,$00aa2d73,$00a91c65,$00cc3378,$00cb2768,$00c41755,$00cf225e
    DC.L    $00ab643,$00a6e49,$00c63d73,$00b94d7b,$003d01c,$0025012,$0045172e,$003e1c2d,$0030202b
    DC.L    $009e989d,$008f8487,$0034d1c,$00ab5377,$00c64f82,$00ba3573,$00c93b7e,$00ca347a,$00f959a5
    DC.L    $00d1297c,$00b1276f,$0059e3c,$0036162e,$00beb0b6,$008e8a89,$00656363,$0062605f,$006e6d69
    DC.L    $00626660,$005a625b,$00a1a6a4,$00a59da7,$003c112c,$00972e61,$00de5093,$00aaf5a,$00ca2977
    DC.L    $00ba1d67,$00c22771,$00ac125f,$00a92064,$007f1b4b,$003a01a,$009c8593,$006a525c,$003d011
    DC.L    $00761634,$008e1a3f,$008cc36,$0090935,$008e531,$009f153f,$00971943,$008c244d,$003f019
    DC.L    $00584149,$0056484c,$002a515,$00a46d86,$00cc8da7,$00e897b8,$00d0668f,$00d15286,$00df4d8e
    DC.L    $00c73177,$00a91e61,$009e1957,$009d1a4d,$00a11a4a,$00a0174b,$0079431,$0040019,$0044182f
    DC.L    $00482337,$0022b19,$00635d62,$00b8b3b5,$005d4851,$0041720,$00a32e5f,$00ae1a5a,$00a4f53
    DC.L    $00ba2666,$00c4356e,$00bd2f64,$00be3065,$00a22856,$0053124,$0030012,$004e1f35,$004c1f32
    DC.L    $004d1f32,$00491a30,$002b018,$003501a,$008c2957,$00af3369,$00af2362,$00a81b5a,$00a21d5b
    DC.L    $00b73e78,$00ac3c72,$008d355d,$003c91d,$00483139,$006c6a6a,$00191e1c,$00984,$00720
    DC.L    $00500,$00720,$00010,$00b47,$0027914,$005c1738,$00cf5399,$00e447a1,$00d32b8b
    DC.L    $00df3c97,$00e557a2,$00ee73b3,$00ffb7f1,$00ce6a9e,$008c325d,$008f3b5e,$00a65576,$009e4d6e
    DC.L    $00a95175,$00a0466a,$008e335a,$00842a4e,$00862b52,$00771d41,$0072173e,$0067d31,$006e133a
    DC.L    $0068e32,$0070173e,$00883054,$00822b51,$00a34f72,$009e496f,$00782e50,$003c924,$00503545
    DC.L    $00b3b0b2,$002f2a2b,$00331220,$0067364c,$005e233f,$00642043,$00ac638b,$00e493c0,$00de82b3
    DC.L    $00da7fac,$00ba6f8f,$00a35d7c,$00994b74,$00953e6a,$00841e4d,$00962c5b,$00831d4c,$00842050
    DC.L    $008c2858,$00bc5a88,$00a95078,$008f2f5e,$00aa3679,$00a01a63,$00a6c53,$00a0849,$00991754
    DC.L    $006b038,$0057339,$00611e4b,$00471031,$0028116,$00776368,$00b9a3a8,$0056283f,$006c1b48
    DC.L    $00b6397e,$00bf297c,$00b01a6e,$00b71e74,$00b31671,$00b11972,$00bf2f81,$00891e57,$0025011
    DC.L    $007f7477,$00615059,$00150c,$00411330,$004cd35,$00661546,$00841d56,$009e1d5a,$00c53472
    DC.L    $00cc326d,$00a8b44,$00af194e,$00ae1e52,$00c64173,$00ee76a6,$00a13a67,$00a44871,$00a55174
    DC.L    $007f3f5c,$001a0f,$006e636d,$00978b91,$0027412,$00a55376,$00d86b9c,$00ce5893,$00c64889
    DC.L    $00d24b8f,$00f461ab,$00d53283,$00bc3077,$0060143e,$003c1c34,$008d8590,$007b10,$00005
    DC.L    $0087b,$00001,$00010,$009ca,$00323232,$009d95a0,$003f1832,$008e2f61,$00d25091
    DC.L    $00b4226a,$009814a,$00a11356,$00ad1e63,$00af1763,$00aa2369,$007a1749,$0035017,$00988491
    DC.L    $0068505a,$004a51a,$008d2947,$0084b31,$008fd36,$0097133c,$0097113b,$00a21e47,$009b214a
    DC.L    $00942e57,$003c018,$00604d56,$005e5a5f,$00e0b,$00361a2e,$004f283e,$00692f4b,$006c183b
    DC.L    $00d46795,$00dc5894,$00b62869,$009f1856,$00a8285f,$009d214f,$009b1d47,$00a51e4e,$0091f3e
    DC.L    $007da36,$006ea34,$006d183e,$0042521,$004c323f,$00b6a8ae,$00563e48,$003e61d,$00a23261
    DC.L    $00ab1f5a,$009d104f,$00b92a68,$00cc3b72,$00c63569,$00c43468,$00a62355,$00871c47,$0069c33
    DC.L    $0067d30,$006f1435,$006cb2d,$0062325,$00651134,$0082264f,$00a93265,$00b6316a,$00b6306c
    DC.L    $009c2159,$00791545,$0061f39,$004a629,$0040b26,$0029513,$001eaf,$00000,$00010
    DC.L    $00540,$00941,$00700,$00700,$00444,$00901,$002ff1a,$00591435,$00b23378
    DC.L    $00ce308a,$00cb2584,$00d02d88,$00e2519c,$00f26eb0,$00fface9,$00f184bc,$00ca608f,$00cf6691
    DC.L    $00d16b94,$00d56a95,$00e16c9d,$00c2497c,$00ac3064,$00ab2f63,$009c2054,$00a3275b,$00ac3064
    DC.L    $0089d41,$0088c40,$00971e51,$008b1245,$00b63f72,$00d76194,$00e771a4,$00b64073,$008d2a58
    DC.L    $004dd30,$00452538,$00a7a2a3,$0091938d,$00503d40,$0028813,$0027010,$00220b,$0080496a
    DC.L    $00fab6df,$00e18dbd,$00d87fab,$00c67399,$00f19cc2,$00d06c9c,$00cd5891,$00cc4583,$00cb3b7c
    DC.L    $00bc2f72,$00b02568,$00c2377b,$00eb66a5,$00f57db4,$00e36aa4,$00d04a93,$00aa1866,$00b81d62
    DC.L    $00bd2d68,$00a43163,$0052029,$0027016,$002201c,$002d1125,$00644e5a,$00a59999,$00bba8ab
    DC.L    $004c2136,$00691a45,$00b3377d,$00bf2b7f,$00ba2379,$00b91e79,$00ae1271,$00a6f6c,$00b62a7d
    DC.L    $0088215a,$0027011,$00807879,$009f9699,$00584b53,$002f1b28,$002981d,$0029013,$005dc39
    DC.L    $00a02d66,$00ad2664,$00ca3a75,$0092037,$00b72b5a,$00ba3560,$00b1315b,$00e56896,$00ca4e82
    DC.L    $00d65e94,$00da6d9b,$00a25073,$0028218,$005c4e5a,$0090838b,$002fb1b,$00ad5a80,$00d2669a
    DC.L    $00ca5c96,$00b64480,$00ca4f91,$00b73076,$00d23383,$00b52c70,$0054831,$0043273b,$00484750
    DC.L    $00004,$00428,$00203,$00746,$00897,$00010,$00422,$007b737d,$00401d37
    DC.L    $007e2858,$00dd62a0,$00d4428a,$00c83079,$00b22467,$00b5266b,$00b21a66,$00ab246a,$00751648
    DC.L    $003401a,$00978694,$00654f5b,$004e61c,$00932b4a,$008cf36,$0084029,$0083028,$0097153e
    DC.L    $00a72750,$009e2851,$0098355d,$003d019,$0064515a,$00959798,$004e4a55,$001c1222,$001a718
    DC.L    $001c0b,$0037011,$00c96991,$00ff82b9,$00d24683,$00aa1f5c,$00a41f57,$00911543,$009a1e4a
    DC.L    $00ae2656,$00a4164b,$00a51851,$0090e45,$0099285a,$00641439,$004b2738,$00b7a6af,$005f4751
    DC.L    $0047f24,$00a83c67,$00af2860,$00a41b58,$00bd336d,$00ca3a6e,$00bd2d5e,$00bc2f62,$00ae295b
    DC.L    $00a42b5d,$00871544,$00992652,$00931d48,$009c1e48,$00961c45,$008d224d,$00ab3d6d,$00a01e55
    DC.L    $00a41a54,$00b22f68,$00a8396b,$0063143b,$002c013,$00371226,$00462c39,$00715961,$00433539
    DC.L    $00000,$003a7,$00786,$00410,$00740,$00b84,$00d24,$00e01,$00331520
    DC.L    $00531030,$00b13277,$00c1217b,$00ca2985,$00bf2279,$00e24d97,$00e25598,$00ec69a8,$00cd528c
    DC.L    $00c34c7f,$00e16b9b,$00c34b7b,$00b83d6f,$00b7336f,$00a92260,$00b42b69,$00bb3270,$0095c4a
    DC.L    $00a01755,$00ae2563,$0099104e,$008f644,$0090947,$008f846,$00b02b69,$00ff81bf,$00c2407d
    DC.L    $00a52360,$00992d62,$0050d34,$003b1c31,$009a9b99,$00a5afa3,$00b9b0ac,$00ae999b,$008f727b
    DC.L    $0029516,$00734661,$00f3b6dc,$00ee9dcc,$00c56b99,$00c06890,$00eb8db6,$00dc6da1,$00be3c7b
    DC.L    $00cd3c86,$00d53c8b,$00b82373,$00aa1467,$00c52b7c,$00cb3581,$00cc4184,$00e45c9e,$00b62373
    DC.L    $00bf2574,$00ce3072,$00b82a5f,$00b24671,$004701e,$004e2740,$00807383,$0096939c,$009ea0a1
    DC.L    $00a4a59c,$00beb2b0,$004b2537,$0057f39,$009f2b70,$00b02477,$00af1b73,$00a9126f,$00a91272
    DC.L    $009f106d,$00a82477,$00892a63,$00200c,$00807b7a,$00b6b4b4,$00aaaaaa,$00a29d9e,$0098878b
    DC.L    $00481b2e,$005d1133,$00d5659b,$00b62f6d,$00b52966,$00b2265c,$00a01c45,$009d1f42,$00b43c5f
    DC.L    $00dc638f,$00cb4a83,$00c54380,$00e86ca2,$00bf618a,$002801a,$00625263,$00837580,$0027113
    DC.L    $00ae557d,$00df6fa5,$00e476b0,$00d466a1,$00db69a9,$00bf4085,$00d9418d,$00be3a7d,$005c133b
    DC.L    $003f2434,$004b504f,$00030,$00a65,$00700,$00740,$00020,$00230,$00ba6
    DC.L    $007a737a,$00412237,$00782954,$00cb538e,$00e95298,$00d3307b,$00c4286f,$00bc246d,$00ba1d6d
    DC.L    $00ae276d,$00741849,$003101d,$00978896,$00644e5a,$004c117,$008a1b3b,$008872e,$0084028
    DC.L    $008db34,$008052d,$00a0264e,$009d2b53,$00b15078,$003f019,$006b5459,$00aeafab,$0091989b
    DC.L    $008d9098,$006f6771,$003c1f2e,$0042820,$00a94f73,$00dc5e92,$00cf3c7a,$00b21b5a,$00ad1a56
    DC.L    $00a21c50,$00b02b5d,$00bb2960,$00b01754,$00ae195b,$009d1353,$00961e58,$005952f,$004d293f
    DC.L    $00b5a7b2,$005a424c,$0039215,$00ad3f69,$00b62e62,$00ab265e,$00bb3268,$00b9295d,$00a41546
    DC.L    $009f184a,$009c1b4e,$009f2054,$009c2054,$008c1143,$00921546,$008ca39,$0085937,$00962959
    DC.L    $00a33466,$00b22d65,$00af245d,$00a6245b,$00a73b69,$00581230,$00532c3c,$00ac979f,$00b3a8aa
    DC.L    $00a4969a,$0012be,$00167,$00020,$00020,$008db,$00010,$00020,$00c01
    DC.L    $001104,$002c111b,$004f1833,$00a74079,$00b23279,$00b1307b,$00aa2a71,$00c04381,$00bd457c
    DC.L    $00c35187,$00dc6fa0,$00d16895,$00cb658e,$00b74f78,$00ba4e7c,$00b24173,$00ad386f,$00b9447b
    DC.L    $00b9447b,$008e174e,$00941d54,$00911a51,$00911a51,$009b265d,$00aa356c,$00a02b62,$00b34177
    DC.L    $00ce5c92,$00af3d73,$00ac3c72,$00983a69,$0046f30,$00331c2b,$00959896,$00828b81,$0036322d
    DC.L    $007e716f,$00af9ba0,$002c121f,$006c485e,$00d3a3c0,$00edadd1,$00e69dc3,$00c57b9d,$00d484a9
    DC.L    $00cc6d9a,$00aa3b71,$00b93f7f,$00bc3d82,$00be4187,$00a8286f,$00b32f76,$00ad2c6f,$00c44c86
    DC.L    $00cd5891,$00b53779,$00a82667,$00af2d62,$00bf4b76,$00873051,$0037015,$00725565,$00b1a9b3
    DC.L    $007c8386,$0027322f,$001a1e18,$008f8787,$00492c3b,$0050193a,$008c346a,$00912468,$009f2b71
    DC.L    $00941e67,$00992572,$008d1e68,$00862264,$007c3361,$00170a,$008c8788,$008d8f8f,$00292e2c
    DC.L    $00696a66,$00aea4a4,$00694954,$0048e26,$00ae557d,$00912657,$00a13264,$00ba4b77,$009d3455
    DC.L    $008f2c46,$009f405b,$00c9678b,$00cb5e8f,$00b14377,$00da73a0,$00f6a9cb,$003a162e,$00514250
    DC.L    $008a7a85,$0028617,$00a3597b,$00c96f9a,$00e088b6,$00ffb5e5,$00da83b5,$00d070a6,$00e571ac
    DC.L    $00c55d92,$004f1433,$003f2836,$00424745,$00050,$00500,$00700,$00330,$00020
    DC.L    $00771,$00410,$007a7479,$003e2434,$004be30,$00ab4d7c,$00c44981,$00a31d59,$00a01f5a
    DC.L    $00a0205b,$00b2306f,$00a4356d,$006a1e47,$002a019,$00938492,$00614d59,$0041216,$00721731
    DC.L    $0073829,$007dd2f,$0073a2b,$007d1838,$00852444,$00a14869,$00ab5c7d,$0038017,$00715e61
    DC.L    $0082837f,$0028302f,$007e8588,$00aca8ae,$00604a56,$0032617,$00914a65,$00ab456f,$00ae3567
    DC.L    $00a12256,$00af3264,$00ae3c6b,$00b03f6b,$00b33667,$00b7386c,$00b93e76,$00b13f75,$00a03d6d
    DC.L    $00581034,$004a2a3d,$00af9faa,$00624a54,$003ab1b,$00943b5c,$009b2d57,$00942853,$009d2e5a
    DC.L    $009f2c54,$00952249,$008c2148,$00861e47,$00891d4b,$00932a57,$00962d58,$00821a43,$008d2249
    DC.L    $00882147,$00953a61,$0092365f,$00a53866,$00b13f6e,$009f345f,$00a95274,$00521a2f,$005d3f4a
    DC.L    $00a6989a,$00514c4b,$002c2326,$00201,$00167,$00020,$00010,$00020,$00010
    DC.L    $00054,$00c04,$00c03,$0028131c,$0029718,$004b1532,$005a173c,$005a153a,$00591338
    DC.L    $0061193d,$00621e3d,$00652241,$00672744,$00652b44,$00642c43,$00622a41,$00622840,$0061213e
    DC.L    $005e1c39,$00611f3c,$005c1a37,$004ca27,$0049724,$004ec29,$004b926,$00551330,$00561431
    DC.L    $00581633,$00591936,$005b1b38,$005d1d3a,$005e1e3b,$00532139,$0021915,$00362f32,$009b9b9b
    DC.L    $00232422,$00a65,$00700,$00564b4e,$0045353c,$002c1622,$005a404e,$00603e4f,$006d465b
    DC.L    $00593143,$00562b40,$005a2840,$00561c38,$005e1b3b,$00621d3e,$00621c40,$005b1539,$0055f33
    DC.L    $0055f33,$00591635,$005d1a39,$00621c40,$00621b3c,$0053d2b,$005c1b34,$00471428,$00210c
    DC.L    $00856b78,$00998c94,$00cef,$00032,$00000,$00372e31,$004d3945,$002aa1d,$0040132e
    DC.L    $004c1536,$004d1336,$004282b,$004a1137,$0041e30,$0040122f,$002761b,$001a815,$00a0999e
    DC.L    $00383739,$00000,$00200,$00504849,$0069575e,$0021310,$00471a2d,$0046122a,$00531a33
    DC.L    $00551b33,$0051182d,$004d1528,$00541b30,$00622840,$00682b47,$00612743,$006a3b51,$005e3c4d
    DC.L    $00162f,$005c4e59,$0095868e,$001f915,$00422031,$005a3146,$00643d52,$00724b61,$00623b51
    DC.L    $006f435a,$0075425d,$0062344b,$001b0c,$005b4c54,$00525252,$00020,$00342,$00200
    DC.L    $00564,$00120,$00754,$00400,$00857e83,$0041303b,$0023112,$0053243a,$00561b37
    DC.L    $004b926,$0053112e,$0047522,$0050e2b,$00581e37,$003d1227,$0021413,$00998893,$00725f68
    DC.L    $00220d,$0034515,$003c417,$0040317,$0040317,$004161a,$0045e21,$00512133,$004b2132
    DC.L    $001e2f,$00837b7c,$001d1e1c,$00001,$00131214,$009a9398,$007a6972,$001b0c,$00441d2d
    DC.L    $00542037,$00561933,$00551330,$00551330,$00551630,$005a1933,$005c1634,$005a1432,$005f203a
    DC.L    $004c122b,$00542037,$002e416,$004c323f,$00b9a4ad,$006d555f,$00242d,$004b192b,$004af24
    DC.L    $0046b20,$004df25,$00531329,$00521327,$004bd23,$0045a1f,$004a1028,$0048e26,$0046d22
    DC.L    $0044b20,$0048d22,$004b1025,$004c1429,$004f172c,$0052162e,$0052162e,$0042a1f,$004d1d2f
    DC.L    $00230d,$004c333d,$0027121a,$00b01,$00501,$00000,$00000,$00010,$00000
    DC.L    $00000,$00000,$00000,$00128e,$00903,$001ab13,$00594551,$00442b39,$00301624
    DC.L    $0028819,$002a819,$0027314,$0027113,$0026213,$0023211,$0020110,$001e2f,$001b1e
    DC.L    $001b2c,$001e2f,$001f1e,$0025714,$0028a17,$0026815,$002bd1a,$00331522,$00331522
    DC.L    $002df1c,$002bd1a,$0028a17,$0025714,$0023512,$0023512,$0024613,$0020812,$00262021
    DC.L    $006e6f6d,$00a5a5a5,$001f1d1d,$00866,$00400,$00a36,$00766d70,$0044383e,$0026181e
    DC.L    $00e04,$001006,$00160c,$00150b,$00191d,$0020613,$001f1e,$0023512,$0025714
    DC.L    $0023413,$0022312,$0024514,$0025615,$0026716,$00210f,$0029817,$0026716,$0027b18
    DC.L    $002e1622,$005a4750,$00ad9ca5,$006a6066,$00000,$00466,$00201,$002d262b,$008c7f87
    DC.L    $0044333e,$00301927,$002e1523,$0029f1d,$002f1624,$002a1321,$00281421,$00261621,$0033262e
    DC.L    $0070656d,$00948e93,$00111012,$00000,$00222,$00161113,$0091888b,$004f4349,$00322229
    DC.L    $00311c25,$0022a14,$0028f19,$002ae1b,$0023714,$0020110,$0021211,$0021211,$001a0e
    DC.L    $00112a,$00106c,$003e333b,$009a8e94,$00ab9ea6,$0064585e,$00251820,$00137d,$00904
    DC.L    $00903,$00b04,$001139,$00d06,$001df15,$00473840,$009a8e94,$00424040,$00364
    DC.L    $00586,$00010,$00000,$00000,$00524,$00401,$0080797e,$00887c82,$003b2a33
    DC.L    $0025121b,$0024c18,$002bf1c,$00341623,$00361823,$00371924,$002d121b,$00472f39,$00715f66
    DC.L    $00c0b1b9,$009b8f95,$004e3f47,$003d2b32,$0039202a,$003c1f28,$003e1e29,$00381b24,$002c131d
    DC.L    $0028131b,$003e2d36,$005d5359,$00767676,$00799,$00aaa,$00201,$006f686b,$00a1979d
    DC.L    $004e4046,$002b1821,$001fa13,$0023b15,$0028c19,$002ac19,$0026716,$0026514,$0027615
    DC.L    $0026716,$001809,$00271018,$0038232c,$004f3d44,$00ac9ba4,$00c2b4ba,$0095848d,$0049373e
    DC.L    $00331b25,$00301820,$002f141e,$0032151e,$00341621,$0033161f,$0030151f,$0030151e,$002c131d
    DC.L    $002d151d,$002f1620,$00301820,$0030151f,$002c111a,$0028d17,$0026b14,$0023a14,$0024c14
    DC.L    $00371f29,$0039242c,$0064515a,$00615158,$00b04,$00804,$00201,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00102,$00524,$00401,$00595257
    DC.L    $00bfb2ba,$00b5a5b0,$009a8895,$0094808d,$009b8492,$0099838f,$0097818d,$0094818a,$00918089
    DC.L    $00908288,$00918389,$008f8389,$008f828a,$008d8088,$008e8189,$0090838b,$0092858d,$00958890
    DC.L    $00978a92,$00978a92,$009a8d95,$00978a92,$0093868e,$0090838b,$008e8189,$008f828a,$0090838b
    DC.L    $008f858b,$00a19f9f,$00afb2b0,$00656767,$00222,$00000,$00977,$00401,$006d6669
    DC.L    $00c5bbc1,$00998f95,$0094868c,$0082747a,$008e7d86,$00918089,$00917e87,$008f7e87,$008f8088
    DC.L    $008e8189,$008f828a,$008e838d,$0090858f,$00918690,$0092848f,$008f818c,$00968691,$0095868e
    DC.L    $00958890,$00998f95,$00979196,$00abaaac,$00a2a4a5,$00222726,$00010,$00586,$00444
    DC.L    $00946,$007c7376,$00c1b3b9,$00ab9aa3,$009a8692,$009c8894,$00a08c98,$0093828d,$009d8e96
    DC.L    $00a4979f,$009f989d,$00c5bec3,$00726f71,$00010,$00074,$00042,$00555,$005e5c5c
    DC.L    $00c2bdbf,$00a39c9f,$0090848a,$0097898f,$009c8e94,$00a08f98,$009d8c95,$00958590,$0091818c
    DC.L    $008f7f8a,$008d8088,$008c8288,$008f888b,$00b0a9ae,$00aea5a8,$00a59ba1,$00b9b0b3,$00a69ca2
    DC.L    $008a8184,$00867c82,$008b8285,$008d8187,$0083787b,$008c8086,$009d9295,$00b5a9af,$009b9295
    DC.L    $0013ef,$00010,$00342,$00010,$00000,$00222,$00879,$00413,$00292426
    DC.L    $00b5aeb1,$00b1a7ad,$00978b91,$00918089,$00a08d96,$00a28d96,$009e8992,$0098868d,$009f9094
    DC.L    $00b1a5ab,$00ada6a9,$009e9a9f,$00adaaac,$00ada9ae,$00a49da0,$009e9298,$00a39498,$00a39198
    DC.L    $009d8c90,$00a2949a,$009e9598,$009f999e,$00bfbec0,$00535857,$00041,$00275,$00000
    DC.L    $00313131,$00aca9ab,$00a19c9e,$00998f95,$0091858b,$00988a90,$009c8d95,$009c8b94,$00988792
    DC.L    $0095848f,$0095848f,$0096878f,$0090868c,$00979294,$00a5a1a6,$00b2b1b3,$007f8084,$006c6e6f
    DC.L    $00b2b1b5,$00a6a5a7,$00918b90,$00958e91,$00978d93,$00988d90,$00978b91,$00988d90,$00988e94
    DC.L    $00999093,$00938c91,$00938e90,$00948d92,$00948d90,$00958b91,$0092898c,$0090868c,$008e8588
    DC.L    $0090868c,$00938c8f,$00908a8f,$00a7a4a6,$00a8a7ab,$00202223,$00003,$00489,$00000
    DC.L    $00000,$00000,$00000,$00000,$00000,$00000,$00000,$00030,$006b9
    DC.L    $00022,$00324,$004e4a4f,$005c565b,$00948c93,$00a29aa1,$009e939b,$009e939b,$009f949c
    DC.L    $009f959b,$009d969b,$009c9799,$009c9799,$00999698,$009a9799,$00989799,$00959496,$00959496
    DC.L    $00989799,$0099989a,$00979698,$00989799,$00949395,$00949395,$00949395,$00959496,$00969597
    DC.L    $00969597,$00979698,$00979698,$00575959,$004a4d4b,$00cee,$00011,$00555,$00000
    DC.L    $00635,$00c9b,$00514b50,$00676065,$00a2989e,$009e949a,$009c9096,$009e9298,$00a3969e
    DC.L    $00a1979d,$009b959a,$00969597,$00959498,$00929397,$00939498,$00949599,$00959498,$00969297
    DC.L    $0099959a,$009a969b,$009a969b,$00989799,$00797d7e,$00545c5b,$002e3937,$00020,$006d8
    DC.L    $00020,$00142,$00200,$00c78,$00584f52,$006b5f65,$00a0949a,$00a1929a,$00a2959d
    DC.L    $00a1949c,$00a0969c,$009a9398,$006c6769,$00585355,$00ddd,$00042,$00020,$00031
    DC.L    $00010,$00586,$004b4b4b,$005c5a5a,$009f9a9b,$00999496,$00989395,$00989395,$009a9597
    DC.L    $009a969b,$009a969b,$00989499,$00989499,$009f9c9e,$006f6d6d,$00565153,$004b4647,$002b2628
    DC.L    $00595455,$00595456,$009a9596,$00979294,$009b9697,$009d9699,$009a9495,$00a39c9f,$00787273
    DC.L    $00575053,$00201a1b,$00400,$00200,$00310,$00342,$00111,$00111,$00435
    DC.L    $00001,$00435,$003f3c3e,$00534f54,$008c868b,$00a79da3,$009c9298,$00978a92,$00a3979d
    DC.L    $009f9699,$00888283,$005a5759,$002f3131,$0059a,$001f2524,$004b4f50,$00696b6b,$00999698
    DC.L    $009e9899,$00a1989b,$00989091,$009f9a9c,$008e8e8e,$00575b5c,$00474d4c,$003a7,$00020
    DC.L    $00052,$005a8,$00010,$00343636,$00595959,$00868484,$009b989a,$009c9799,$009a9597
    DC.L    $009b9698,$009c969b,$009c969b,$009b959a,$00979398,$009e9d9f,$007f8483,$004f5455,$003b4342
    DC.L    $00011,$00064,$00323a3a,$004a5251,$00898d8e,$00929494,$0099989a,$00989898,$00969597
    DC.L    $00989898,$0099989a,$00969898,$00949899,$00939897,$00929697,$00939595,$00939596,$00969696
    DC.L    $00989799,$00999999,$00979698,$00989a9a,$007d8182,$00545a59,$002c3434,$00010,$00077
    DC.L    $00010,$00000,$00000,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00030,$00030,$00074,$00052,$00032,$00001,$00121317,$0056a,$00a9d
    DC.L    $00bac,$00bac,$00bbb,$00bbb,$008aa,$00688,$00577,$00577,$00688
    DC.L    $00577,$00466,$00799,$00799,$00688,$009bb,$00799,$00799,$009bb
    DC.L    $00acc,$00acc,$00acc,$009bb,$009bb,$00021,$00010,$00010,$00010
    DC.L    $00133,$00011,$00444,$00111,$00413,$00201,$00c79,$00fac,$00b68
    DC.L    $00d8a,$00e8d,$00613,$00bbb,$006ba,$0059a,$0059a,$006ab,$006ab
    DC.L    $009bc,$00bde,$00324,$00bbb,$00ccc,$00bdd,$00276,$00020,$00020
    DC.L    $00093,$00040,$00061,$00372,$00342,$00421,$00200,$00501,$00b68
    DC.L    $00109e,$00c6b,$00c6b,$00835,$00fce,$00200,$00200,$00675,$00020
    DC.L    $00183,$00394,$00020,$00372,$00697,$00010,$00cdb,$00eee,$00799
    DC.L    $00466,$00498,$006bc,$006bc,$003bb,$004a9,$00688,$00897,$00200
    DC.L    $00200,$00533,$00200,$00644,$00643,$00151313,$00ca9,$00866,$00976
    DC.L    $00161112,$00400,$00400,$00621,$00732,$00976,$00200,$00200,$00000
    DC.L    $00000,$00022,$00011,$00000,$00000,$00001,$00546,$0098a,$00ebd
    DC.L    $00fb10,$00c9b,$00dbb,$00453,$00010,$00074,$00075,$00020,$00010
    DC.L    $00020,$00cee,$00564,$00caa,$00976,$00bdd,$00c11f,$00010,$00063
    DC.L    $00020,$00030,$00020,$00020,$004a5,$00010,$00475,$00253,$00dff
    DC.L    $009bb,$00688,$00799,$007bc,$009de,$007bc,$005a9,$005a9,$00386
    DC.L    $00021,$00020,$00064,$00020,$00020,$00052,$00021,$00475,$008aa
    DC.L    $007a8,$00799,$007ca,$007cb,$003a7,$00398,$004b8,$005ba,$006b9
    DC.L    $006ba,$007a8,$00688,$00586,$00bdd,$00386,$00387,$00020,$00010
    DC.L    $00096,$00020,$00054,$00000,$00000,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00050,$00040,$00030,$00030,$00043,$00043,$00001
    DC.L    $00034,$00001,$00001,$00010,$00010,$00010,$00010,$00010,$00010
    DC.L    $00031,$00031,$00031,$00020,$00010,$00010,$00010,$00010,$00010
    DC.L    $00010,$00010,$00010,$00010,$00010,$00010,$00010,$00043,$00054
    DC.L    $00165,$00010,$00000,$00133,$00000,$00000,$00001,$00102,$00201
    DC.L    $00a79,$00201,$00201,$00746,$00333,$00000,$00010,$00010,$00010
    DC.L    $00010,$00010,$00010,$00010,$00333,$00000,$00010,$00010,$00020
    DC.L    $002b8,$00082,$00030,$00030,$00030,$00020,$00020,$00675,$00010
    DC.L    $00533,$00644,$00302,$00302,$00201,$00302,$00555,$00333,$00010
    DC.L    $00010,$00040,$00020,$00020,$00030,$00020,$00020,$00142,$00010
    DC.L    $00010,$00010,$00020,$00020,$00010,$00020,$00020,$00020,$00031
    DC.L    $00010,$00342,$00231,$00010,$00cdb,$00010,$00564,$00010,$00010
    DC.L    $00453,$00010,$00200,$00754,$00976,$00200,$00400,$00621,$00200
    DC.L    $00200,$00333,$00022,$00133,$00165,$00498,$00010,$00267,$00001
    DC.L    $00012,$00023,$00001,$00000,$00000,$00010,$00030,$00020,$00030
    DC.L    $00030,$00096,$00020,$00020,$00010,$00453,$00031,$00010,$00020
    DC.L    $00020,$00030,$00020,$00020,$00050,$00020,$00030,$00020,$00010
    DC.L    $00010,$00010,$00010,$00020,$00020,$00010,$00010,$00010,$00010
    DC.L    $00053,$00020,$00052,$00041,$00085,$00020,$00074,$00020,$00020
    DC.L    $00010,$00010,$00010,$00010,$00010,$00020,$00020,$00020,$00020
    DC.L    $00020,$00030,$00010,$00010,$00010,$00010,$00010,$00386,$00020
    DC.L    $00020,$00085,$00020,$00030,$00020,$00000,$00000,$00000,$00000
    DC.L    $00000,$00000,$00000,$00000



























*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
