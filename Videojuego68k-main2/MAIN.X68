; =============================================================================
; TITLE    : EXAMPLE GAME (MAIN PROGRAM)
; AUTHOR   : ANTONI BURGUERA
; HISTORY  : 10-OCT-2020 - CREATION
;            11-OCT-2020 - MINOR CHANGES
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            INCLUDE "CHARACTER.X68"         ; MAIN CHARACTER MANAGEMENT
            INCLUDE "SHOTS.X68"             ; SHOTS TO THE RIGHT MANAGEMENT
            INCLUDE "AGENTLST.X68"          ; AGENT LIST MANAGEMENT
            INCLUDE "MAPS.X68"              ; MAPS MANAGEMENT
            INCLUDE "STATES.X68"            ; STATES MANAGEMENT
            INCLUDE "SOUND.X68"             ; SOUNDS MANAGEMENT
            INCLUDE "LIFE.X68"              ; LIFE MANAGEMENT
            INCLUDE "MOB.X68"               ; MOB MANAGEMENT
            
; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT                 ; INITIALIZE SYSTEM-RELATED STUFF
            

            ; TO DO : ADD YOUR GAME INITIALIZATION HERE
            JSR STAINIT
            JSR SNDINIT
*            JSR LIFEINIT

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            
            ; TO DO : ADD YOUR GAME UPDATE HERE
            JSR STAUPD

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            ; TO DO : ADD YOUR GAME PLOT HERE
            JSR STAPLOT

            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP                   ; MAIN LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START





























*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~0~
*~Tab size~4~
