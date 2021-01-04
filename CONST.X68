; =============================================================================
; TITLE    : GAME CONSTANTS
; AUTHOR   :
; HISTORY  :
; =============================================================================

;----------CHARACTER RELATED CONSTANTS-----------------------------------------

CHARBODY    EQU     31           ;CHARACTER DIMENSIONS
CHARPCOL    EQU     $00000000    ;CHARACTER PEN COLOR
CHARFCOL    EQU     $00FF00FF    ;CHARACTER FILL COLOR
EYESIZE     EQU     1            ;CHARACTER'S EYE SIZE
CHARSPED    EQU     4            ;CHARACTER'S MOVE SPEED
FLOOR       EQU     439          ;FLOOR POSITION RELATED TO CHARACTER
CHARJUMP    EQU     38           ;CHARACTER JUMPING

;------------------------------------------------------------------------------

;----------SHOOTINGS RELATED CONSTANTS-----------------------------------------
SHOTID      EQU     1            ;SHOT IDENTIFIER
SHOTSPED    EQU     20           ;SHOTS SPEED
SHOTMAXD    EQU     300          ;SHOTS MAXIMUM DISTANCE
SHOTCOL     EQU     $0000FFFF    ;SHOT COLOR
SHOTLONG    EQU     10           ;SHOT LONGITUDE
;------------------------------------------------------------------------------

;----------STATE RELATED CONSTANTS---------------------------------------------

STAINTRO    EQU     0            ;GAME INTRO SCREEN STATE
STAMAP1     EQU     1            ;GAME FIRST MAP
STAGOVER    EQU     2            ;GAME OVER STATE

;------------------------------------------------------------------------------

; --- MOB RELATED CONSTANTS ---------------------------------------------------

MOBID    EQU    2                 ;MOB IDENTIFIER
MOBLINE  EQU    30                ;MOD DIMENSIONS
MOBSPEED EQU    2                 ;MOB SPEED
MOBPCOL  EQU    $00FF0000         ;MOB PEN COLOR
MOBFCOL  EQU    $000000FF         ;MOB FILL COLOR
*MOBY     EQU    113               ;PROVISIONAL
*MOBX     EQU    62                ;PROVISIONAL
;-------------------------------------------------------------------------------





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
