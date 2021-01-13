; =============================================================================
; TITLE    : GAME VARIABLES
; AUTHOR   : GERARD NAHARRO AND LUCAS ORTIZ
; HISTORY  :
; =============================================================================

;---------- CHARACTER RELATED VARIABLES----------------------------------------
CHARX       DS.W    1                       ;CHARACTER X COORDINATE
CHARY       DS.W    1                       ;CHARACTER Y COORDINATE
EYELX       DS.W    1                       ;CHARACTER'S LEFT EYE X
EYERX       DS.W    1                       ;CHARACTER'S RIGHT EYE X
EYELY       DS.W    1                       ;CHARACTER'S LEFT EYE Y
EYERY       DS.W    1                       ;CHARACTER'S RIGHT EYE Y
CHARFCOL    DS.L    1                       ;CHARACTER'S FILL COLOR
; --- STATE MANAGEMENT VARIABLES ----------------------------------------------

STACUR      DS.W    1                       ; CURRENT STATE
STANEXT     DS.W    1                       ; NEXT STATE


;------MOB VAR-------------------------------------------
VOLVER  DS.W    1                           ;GOING FORWARD OR BACKWARD      
MOBNUM  DS.W    1                           ;MOB NUMBER
MOBY    DS.W    1                           ;MOB Y COORDINATE
MOBX    DS.W    1                           ;MOB X COORDINATE

; --- MAP MANAGEMENT VARIABLES ----------------------------------------------

MAPCUR  DS.W    1                           ;CURRENT MAP





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
