*-----------------------------------------------------------
* TITLE      : SHOTS MANAGEMENT: IT IS AN AGENT
* AUTHOT     : GERARD NAHARRO AND LUCAS ORTIZ
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
;UPDATES THE RIGHT SHOT
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

                MOVEM.L     D0-D5,-(A7)     ;STACK REGISTER 
                                                                                                                                                                                                                      
                JSR         GETNXTRS
                CMP.W       #$FF,D5
                BNE         .STOP
                       
        
                MOVE.W      (A0),D4         ;SHOT X
                MOVE.W      2(A0),D5        ;SHOT Y
                MOVE.L      A0,-(A7)        ;STACK SHOT VALUES
                MOVE.W      #MOBID,D0
                JSR         DMMFRSTO
.LOOP           CMP.L       #0,A0           ;IF A0!=0 == FOUND
                BEQ         .NEXT           ;NOT FOUND
                MOVE.W      8(A0),D1        ;MOB LEFT X
                MOVE.W      10(A0),D2       ;MOB UPPER Y
*                ADD.W       #MOBLINE,D1     ;MOB RIGHT X
                MOVE.W      D2,D3
                ADD.W       #MOBLINE,D3     ;MOB BOTTOM Y
               
                CMP.W       D2,D5
                BGE         .BETWEEN1            
                JSR         DMMNEXTO
                BRA         .LOOP
                
.BETWEEN1       CMP.W       D3,D5
                BLE         .BETWEEN2               
                JSR         DMMNEXTO
                BRA         .LOOP
                
.BETWEEN2       CMP.W       D4,D1
                BLE         .TRYKILL                              
                JSR         DMMNEXTO
                BRA         .LOOP
 
.TRYKILL        ADD.W       #MOBLINE,D1     ;MOB RIGHT X
                CMP.W       D4,D1
                BGE         .KILLMOB
                JSR         DMMNEXTO
                BRA         .LOOP 
 
.KILLMOB        JSR         AGLKILL         ;KILL MOB
                JSR         MOBDSND
                SUBQ.W      #1,(MOBNUM)     ;SUB MOB NUMBER
                MOVE.L      (A7)+,A0        ;STORE SHOT VALUES
                JSR         AGLKILL         ;KILL SHOT
                MOVEM.L     (A7)+,D0-D5     ;STORE REGISTERS
                RTS
                
.NEXT           MOVE.L      (A7)+,A0        ;STORE SHOT VALUES
                MOVE.W      4(A0),D0
                ADD.W       #SHOTMAXD,D0
                MOVE.W      (A0),D1
                CMP.W       D0,D1                
                BLT         .MOVE
                
.STOP           JSR         AGLKILL         ;KILL THE AGENT
                MOVEM.L     (A7)+,D0-D5     ;STORE REGISTERS
                RTS
.MOVE           ADD.W       #SHOTSPED,(A0)
                MOVEM.L     (A7)+,D0-D5     ;STORE REGISTERS
                RTS 
;-----------------------------------------------------------
SHOTLUPD
;UPDATES THE LEFT SHOT
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

                MOVEM.L     D0-D5,-(A7)     ;STACK REGISTER 
                                                                                                                                                                                                                      
                JSR         GETNXTLS
                CMP.W       #$FF,D5
                BNE         .STOP
                       
        
                MOVE.W      (A0),D4         ;SHOT X
                MOVE.W      2(A0),D5        ;SHOT Y
                MOVE.L      A0,-(A7)        ;STACK SHOT VALUES
                MOVE.W      #MOBID,D0
                JSR         DMMFRSTO
.LOOP           CMP.L       #0,A0           ;IF A0!=0 == FOUND
                BEQ         .NEXT           ;NOT FOUND
                MOVE.W      8(A0),D1        ;MOB LEFT X
                MOVE.W      10(A0),D2       ;MOB UPPER Y
                ADD.W       #MOBLINE,D1     ;MOB RIGHT X
                MOVE.W      D2,D3
                ADD.W       #MOBLINE,D3     ;MOB BOTTOM Y
               
                CMP.W       D2,D5
                BGE         .BETWEEN1            
                JSR         DMMNEXTO
                BRA         .LOOP
                
                
.BETWEEN1       CMP.W       D3,D5
                BLE         .BETWEEN2               
                JSR         DMMNEXTO
                BRA         .LOOP
                
.BETWEEN2       CMP.W       D4,D1
                BGE         .TRYKILL                              
                JSR         DMMNEXTO
                BRA         .LOOP
                
                
.TRYKILL        SUB.W       #MOBLINE,D1
                CMP.W       D4,D1
                BLE         .KILLMOB
                JSR         DMMNEXTO
                BRA         .LOOP                 
 
.KILLMOB        JSR         AGLKILL         ;KILL MOB
                JSR         MOBDSND         ;KILL MOB SOUND
                SUBQ.W      #1,(MOBNUM)     ;SUB MOB NUMBER
                MOVE.L      (A7)+,A0        ;STORE SHOT VALUES
                JSR         AGLKILL         ;KILL SHOT
                MOVEM.L     (A7)+,D0-D5     ;STORE REGISTERS
                RTS
                
.NEXT           MOVE.L      (A7)+,A0        ;STORE SHOT VALUES
                MOVE.W      4(A0),D0
                ADD.W       #SHOTMAXD,D0
                MOVE.W      (A0),D1
                CMP.W       D0,D1                
                BLT         .MOVE
                
.STOP           JSR         AGLKILL         ;KILL THE AGENT
                MOVEM.L     (A7)+,D0-D5     ;STORE REGISTERS
                RTS
.MOVE           SUB.W       #SHOTSPED,(A0)
                MOVEM.L     (A7)+,D0-D5     ;STORE REGISTERS
                RTS                                        
;-----------------------------------------------------------
SHOTPLOT
;PLOT THE SHOT
;INPUT      -   NONE
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------
                MOVEM.L     D0-D4,-(A7)     ;STACK REGISTER
                
                MOVE.B      #80,D0           ;SET PEN COLOR TASK
                MOVE.L      #SHOTCOL,D1      ;PEN COLOR
                TRAP        #15
                MOVE.W      (A0),D1        ;INITIAL X
                MOVE.W      2(A0),D2       ;INITIAL Y
*                MOVE.W (A0)+#SHOTLONG, D3 
                MOVE.W      (A0),D3
                ADD.W       #SHOTLONG,D3     ;FINAL X
                MOVE.W      2(A0),D4        ;FINAL Y
                MOVE.W      #84,D0          ;PAINT LINE TASK
                TRAP        #15
                
                MOVEM.L     (A7)+,D0-D4     ;STORE REGISTERS

                RTS  
                
                
















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
