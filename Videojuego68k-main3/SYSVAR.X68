; =============================================================================
; TITLE    : SYSTEM VARIABLES
; AUTHOR   : ANTONI BURGUERA
; COMMENTS : NOTE THAT ALL THESE VARS ARE USED TO SHARE DATA FROM SYSTEM TO
;            USER. THUS THEY MUST NOT BE IN PROTECTED MEMORY.
;            NOTE THAT USING DMMDATA IN SUCH WAY IS A BAD IDEA, AS USER
;            APPLICATIONS CAN ALSO FREE OR CHANGE OWNERSHIP. NONETHELESS, FOR
;            THE SAKE OF THIS EXAMPLE THIS IS GOOD ENOUGH.
; HISTORY  : XX-XXX-201X - CREATION
;            11-OCT-2020 - MINOR CHANGES
; =============================================================================

; --- KEYBOARD RELATED VARIABLES ----------------------------------------------

KBDVAL      DS.B    1                       ; KEY PRESSED=1
KBDEDGE     DS.B    1                       ; KEY CHANGED=1

            DS.W    0

; --- SCREEN RELATED VARIABLES ------------------------------------------------

SCRINTCT    DS.B    1                       ; INTERRUPT COUNTER/FLAG
SCRCYCCT    DS.B    1                       ; CYCLE COUNTER
            DS.W    0
            
; --- MOUSE RELATED VARIABLES -------------------------------------------------

MSPOS
MSY         DS.W    1                       ; MOUSE Y COORDINATE
MSX         DS.W    1                       ; MOUSE X COORDINATE

; --- DYNAMIC MEMORY VARIABLES ------------------------------------------------

            ORG     (*+DMMBSIZE-1)&-DMMBSIZE ; ALIGN TO DMMBSIZE
DMMDATA     DS.B    DMMBSIZE*DMMBNUM        ; DYNAMIC MEMORY ALLOCATION SPACE
            DS.W    0                       ; JUST IN CASE (SIZE IS POW OF TWO)


*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
