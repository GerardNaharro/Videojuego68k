; =============================================================================
; TITLE    : GAME CONSTANTS
; AUTHOR   : GERARD NAHARRO AND LUCAS ORTIZ
; HISTORY  :
; =============================================================================

;----------CHARACTER RELATED CONSTANTS-----------------------------------------

CHARBODY    EQU     31           ;CHARACTER DIMENSIONS
CHARPCOL    EQU     $00000000    ;CHARACTER PEN COLOR
EYESIZE     EQU     1            ;CHARACTER'S EYE SIZE
CHARSPED    EQU     4            ;CHARACTER'S MOVE SPEED
FLOOR       EQU     439          ;FLOOR POSITION RELATED TO CHARACTER
CHARJUMP    EQU     38           ;CHARACTER JUMPING
PINK        EQU     $00FF00FF    ;CHARACTER PINK COLOR
BLUE        EQU     $00FFFF00    ;CHARACTER BLUE COLOR

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
STAMAP2     EQU     3            ;GAME SECOND MAP
STAMAP3     EQU     4            ;GAME THIRD MAP
STAMAP4     EQU     5            ;GAME FOURTH MAP
STAWIN      EQU     6            ;GAME WON STATE
STAMAP5     EQU     7            ;GAME FIFTH MAP
STAMAP6     EQU     8            ;GAME SIXTH MAP
STACCS      EQU     9            ;GAME COLOR SELECTOR
;------------------------------------------------------------------------------

; --- MOB RELATED CONSTANTS ---------------------------------------------------

MOBID    EQU    2                 ;MOB IDENTIFIER
MOBLINE  EQU    30                ;MOD DIMENSIONS
MOBSPEED EQU    2                 ;MOB SPEED
MOBPCOL  EQU    $00FF0000         ;MOB PEN COLOR
MOBFCOL  EQU    $000000FF         ;MOB FILL COLOR
;-------------------------------------------------------------------------------












*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
