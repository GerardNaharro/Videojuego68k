; =============================================================================
; TITLE    : SOUNDS MANAGEMENT
; AUTHOR   : GERARD NAHARRO AND LUCAS ORTIZ
; HISTORY  : 28-12-2020 - CREATION
; =============================================================================



;-----------------------------------------------------------
SNDINIT
;INITIALIZES SOUNDS
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L D0-D3/A1-A2,-(A7)
            LEA     .AUDLIST,A2
            CLR     D1
            MOVE.B  #0,D1
            MOVE.B  #6,D2
            MOVE.B  #71,D0
.HERE       ADDQ.W  #1,D1
            MOVE.L  (A2)+,D3
            MOVE.L  D3,A1
            TRAP    #15
            DBRA    D2,.HERE
            MOVEM.L (A7)+,D0-D3/A1-A2
            RTS

.AUDLIST    DC.L    .SHOOT,.JUMP,.INTRO,.MOBDEAD,.GAMEOVER,.CHARDEAD,.NEXTLEVEL,0            
.SHOOT      DC.B    'SND/SHOOT.WAV',0
.JUMP       DC.B    'SND/JUMP.WAV',0
.INTRO      DC.B    'SND/INTRO.WAV',0
.MOBDEAD    DC.B    'SND/MOBDEAD.WAV',0
.GAMEOVER   DC.B    'SND/GAMEOVER.WAV',0
.CHARDEAD   DC.B    'SND/CHARDEAD.WAV',0
.NEXTLEVEL  DC.B    'SND/NEXTLEVEL.WAV',0
            DS.W    0

            
            

;-----------------------------------------------------------
SHOTSND
;PLAYS SHOOTING SOUND
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L  D0-D1,-(A7)
            MOVE.B   #1,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS
            
;-----------------------------------------------------------
JUMPSND
;PLAYS SHOOTING SOUND
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L  D0-D1,-(A7)
            MOVE.B   #2,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS
            
;-----------------------------------------------------------
INTROSND
;PLAYS SHOOTING SOUND
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L  D0-D1,-(A7)
            MOVE.B   #3,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS    

;-----------------------------------------------------------
MOBDSND
;PLAYS MOB DEAD SOUND
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L  D0-D1,-(A7)
            MOVE.B   #4,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS

;-----------------------------------------------------------
GOVERSND
;PLAYS GAME OVER SOUND
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L  D0-D1,-(A7)
            MOVE.B   #5,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS   

;-----------------------------------------------------------
CHARDSND
;PLAYS CHARDEAD SOUND
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L  D0-D1,-(A7)
            MOVE.B   #6,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS 

;-----------------------------------------------------------
NXTLVSND
;PLAYS NEXT LEVEL SOUND
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
            MOVEM.L  D0-D1,-(A7)
            MOVE.B   #7,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
            RTS            








*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
