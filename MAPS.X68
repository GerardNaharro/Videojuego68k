; =============================================================================
; TITLE    : MAPS MANAGEMENT
; AUTHOR   : GERARD NAHARRO 
; HISTORY  : 18-12-2020 - CREATION
; =============================================================================



;-----------------------------------------------------------
MAP1MATD
;DRAWS THE FIRST MAP FOLLOWING "SCREEN1" MATRIX
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

            MOVEM.L A0/D0-D4,-(A7) ;STACK REGISTERS
            
            MOVE.B  #80,D0         ;SET PEN COLOR
            MOVE.L  #$00000000,D1
            TRAP    #15
            
            MOVE.B  #81,D0         ;SET FILL COLOR
            MOVE.L  #$00FFFF00,D1
            TRAP    #15
            
            LEA     SCREEN1,A0
            MOVE.W  #19,D3  
            MOVE.W  #14,D4  
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #0,D1
            MOVE.W  #0,D2
.LOOP        
           
            BRA     .PAINT
.HERE
            
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,D0-D4/A0 ;STORE REGISTERS
            RTS
            
.PAINT           

            CMP.B   #0,(A0)+
            BGT     .DO
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,A0/D0-D4 ;STORE REGISTERS
            RTS
            
.DO 
            MOVEM.L D1-D4,-(A7)   
            MOVE.W  #87,D0
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            LSL.W   #$05,D1
            LSL.W   #$05,D2
            ADDQ.W  #1,D3
            LSL.W   #5,D3
            SUBQ.W  #1,D3
            ADDQ.W  #1,D4
            LSL.W   #5,D4
            SUBQ.W  #1,D4
            TRAP    #15
            MOVEM.L (A7)+,D1-D4
            BRA     .HERE




;-----------------------------------------------------------
MAP2MATD
;DRAWS THE SECOND MAP FOLLOWING "SCREEN2" MATRIX
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

            MOVEM.L A0/D0-D4,-(A7) ;STACK REGISTERS
            
            MOVE.B  #80,D0          ;SET PEN COLOR
            MOVE.L  #$00000000,D1
            TRAP    #15
            
            MOVE.B  #81,D0          ;SET FILL COLOR
            MOVE.L  #$00000080,D1
            TRAP    #15
            
            LEA     SCREEN2,A0
            MOVE.W  #19,D3  
            MOVE.W  #14,D4  
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #0,D1
            MOVE.W  #0,D2
.LOOP        
           
            BRA     .PAINT
.HERE
            
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,D0-D4/A0 ;STORE REGISTERS
            RTS
            
.PAINT           

            CMP.B   #0,(A0)+
            BGT     .DO
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,A0/D0-D4 ;STORE REGISTERS
            RTS
            
.DO 
            MOVEM.L     D1-D4,-(A7)   
            MOVE.W  #87,D0
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            LSL.W   #$05,D1
            LSL.W   #$05,D2
            ADDQ.W  #1,D3
            LSL.W   #5,D3
            SUBQ.W  #1,D3
            ADDQ.W  #1,D4
            LSL.W   #5,D4
            SUBQ.W  #1,D4
            TRAP    #15
            MOVEM.L (A7)+,D1-D4
            BRA     .HERE



;-----------------------------------------------------------
MAP3MATD
;DRAWS THE THIRD MAP FOLLOWING "SCREEN3" MATRIX
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

            MOVEM.L A0/D0-D4,-(A7) ;STACK REGISTERS
            
            MOVE.B  #80,D0          ;SET PEN COLOR
            MOVE.L  #$00000000,D1
            TRAP    #15
            
            MOVE.B  #81,D0          ;SET FILL COLOR
            MOVE.L  #$0000FF00,D1
            TRAP    #15
            
            LEA     SCREEN3,A0
            MOVE.W  #19,D3  
            MOVE.W  #14,D4  
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #0,D1
            MOVE.W  #0,D2
.LOOP        
           
            BRA     .PAINT
.HERE
            
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,D0-D4/A0 ;STORE REGISTERS
            RTS
            
.PAINT           

            CMP.B   #0,(A0)+
            BGT     .DO
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,A0/D0-D4 ;STORE REGISTERS
            RTS
            
.DO 
            MOVEM.L D1-D4,-(A7)   
            MOVE.W  #87,D0
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            LSL.W   #$05,D1
            LSL.W   #$05,D2
            ADDQ.W  #1,D3
            LSL.W   #5,D3
            SUBQ.W  #1,D3
            ADDQ.W  #1,D4
            LSL.W   #5,D4
            SUBQ.W  #1,D4
            TRAP    #15
            MOVEM.L (A7)+,D1-D4
            BRA     .HERE

;-----------------------------------------------------------
MAP4MATD
;DRAWS THE FOURTH MAP FOLLOWING "SCREEN4" MATRIX
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

            MOVEM.L A0/D0-D4,-(A7) ;STACK REGISTERS
            
            MOVE.B  #80,D0          ;SET PEN COLOR
            MOVE.L  #$00000000,D1
            TRAP    #15
            
            MOVE.B  #81,D0          ;SET FILL COLOR
            MOVE.L  #$0000FFFF,D1
            TRAP    #15
            
            LEA     SCREEN4,A0
            MOVE.W  #19,D3  
            MOVE.W  #14,D4  
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #0,D1
            MOVE.W  #0,D2
.LOOP        
           
            BRA     .PAINT
.HERE
            
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,D0-D4/A0 ;STORE REGISTERS
            RTS
            
.PAINT           

            CMP.B   #0,(A0)+
            BGT     .DO
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,A0/D0-D4 ;STORE REGISTERS
            RTS
            
.DO 
            MOVEM.L D1-D4,-(A7)   
            MOVE.W  #87,D0
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            LSL.W   #$05,D1
            LSL.W   #$05,D2
            ADDQ.W  #1,D3
            LSL.W   #5,D3
            SUBQ.W  #1,D3
            ADDQ.W  #1,D4
            LSL.W   #5,D4
            SUBQ.W  #1,D4
            TRAP    #15
            MOVEM.L (A7)+,D1-D4
            BRA     .HERE


;-----------------------------------------------------------
MAP5MATD
;DRAWS THE FIVTH MAP FOLLOWING "SCREEN5" MATRIX
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

            MOVEM.L A0/D0-D4,-(A7) ;STACK REGISTERS
            
            MOVE.B  #80,D0          ;SET PEN COLOR
            MOVE.L  #$0,D1
            TRAP    #15
            
            MOVE.B  #81,D0          ;SET FILL COLOR
            MOVE.L  #$003D00FF,D1
            TRAP    #15
            
            LEA     SCREEN5,A0
            MOVE.W  #19,D3  
            MOVE.W  #14,D4  
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #0,D1
            MOVE.W  #0,D2
.LOOP        
           
            BRA     .PAINT
.HERE
            
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,D0-D4/A0 ;STORE REGISTERS
            RTS
            
.PAINT           

            CMP.B   #0,(A0)+
            BGT     .DO
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,A0/D0-D4 ;STORE REGISTERS
            RTS
            
.DO 
            MOVEM.L D1-D4,-(A7)   
            MOVE.W  #87,D0
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            LSL.W   #$05,D1
            LSL.W   #$05,D2
            ADDQ.W  #1,D3
            LSL.W   #5,D3
            SUBQ.W  #1,D3
            ADDQ.W  #1,D4
            LSL.W   #5,D4
            SUBQ.W  #1,D4
            TRAP    #15
            MOVEM.L (A7)+,D1-D4
            BRA     .HERE


;-----------------------------------------------------------
MAP6MATD
;DRAWS THE SIXTH MAP FOLLOWING "SCREEN6" MATRIX
;INPUT      -   NONE          
;OUTPUT     -   NONE
;MODIFIES   -   NONE
;-----------------------------------------------------------

            MOVEM.L A0/D0-D4,-(A7) ;STACK REGISTERS
            
            MOVE.B  #80,D0          ;SET PEN COLOR
            MOVE.L  #$00E5E5E5,D1
            TRAP    #15
            
            MOVE.B  #81,D0          ;SET FILL COLOR
            MOVE.L  #$00FFFFFF,D1
            TRAP    #15
            
            LEA     SCREEN6,A0
            MOVE.W  #19,D3  
            MOVE.W  #14,D4  
            CLR.L   D1
            CLR.L   D2
            MOVE.W  #0,D1
            MOVE.W  #0,D2
.LOOP        
           
            BRA     .PAINT
.HERE
            
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,D0-D4/A0 ;STORE REGISTERS
            RTS
            
.PAINT           

            CMP.B   #0,(A0)+
            BGT     .DO
            ADDQ.W  #1,D1
            CMP.W   D3,D1
            BLE     .LOOP
            ADDQ.W  #1,D2
            CLR.L   D1
            MOVE.W  #0,D1
            CMP.W   D4,D2
            BLE     .LOOP
            MOVEM.L (A7)+,A0/D0-D4 ;STORE REGISTERS
            RTS
            
.DO 
            MOVEM.L D1-D4,-(A7)   
            MOVE.W  #87,D0
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            LSL.W   #$05,D1
            LSL.W   #$05,D2
            ADDQ.W  #1,D3
            LSL.W   #5,D3
            SUBQ.W  #1,D3
            ADDQ.W  #1,D4
            LSL.W   #5,D4
            SUBQ.W  #1,D4
            TRAP    #15
            MOVEM.L (A7)+,D1-D4
            BRA     .HERE



;-----------------------------------------------------------
GETNXTL
;GETS IF THE NEXT LEFT BLOCK IS FREE OR NOT
;INPUT      -   NONE          
;OUTPUT     -   D5.W==FF CAN MOVE
;MODIFIES   -   NONE
;-----------------------------------------------------------


            MOVEM.L A1/D3-D4,-(A7)  ; STACK REGISTERS
            
            MOVE.W  (MAPCUR),D3
            CMP.W   #1,D3
            BEQ     .MAP1
            CMP.W   #2,D3
            BEQ     .MAP2
            CMP.W   #3,D3
            BEQ     .MAP3
            CMP.W   #4,D3
            BEQ     .MAP4
            CMP.W   #5,D3
            BEQ     .MAP5
            CMP.W   #6,D3
            BEQ     .MAP6

.MAP1       LEA     SCREEN1,A1
            BRA     .HERE
.MAP2       LEA     SCREEN2,A1
            BRA     .HERE
.MAP3       LEA     SCREEN3,A1
            BRA     .HERE
.MAP4       LEA     SCREEN4,A1
            BRA     .HERE
.MAP5       LEA     SCREEN5,A1
            BRA     .HERE
.MAP6       LEA     SCREEN6,A1
            BRA     .HERE       
            
.HERE       CLR.L   D4
            CLR.L   D5
            MOVE.W (CHARX),D4       ; LEFT X
            MOVE.W (CHARY),D5       ; UPPER Y
            SUB.W   #CHARSPED,D4    ; NEXT LEFT X IF MOVED
            LSR     #5,D5           ; R==D1
            LSR     #5,D4           ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5          ; R*20==D1
            ADD.W   D4,D5           ; C+R*20==D1
            ADD.W   D5,A1           ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B  (A1),D5         ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            
            CMP.W   #1,D3
            BEQ     .MAP11
            CMP.W   #2,D3
            BEQ     .MAP22
            CMP.W   #3,D3
            BEQ     .MAP33
            CMP.W   #4,D3
            BEQ     .MAP44
            CMP.W   #5,D3
            BEQ     .MAP55
            CMP.W   #6,D3
            BEQ     .MAP66
            

.MAP11      LEA     SCREEN1,A1
            BRA     .HERE2
.MAP22      LEA     SCREEN2,A1
            BRA     .HERE2
.MAP33      LEA     SCREEN3,A1
            BRA     .HERE2
.MAP44      LEA     SCREEN4,A1
            BRA     .HERE2
.MAP55      LEA     SCREEN5,A1
            BRA     .HERE2
.MAP66      LEA     SCREEN6,A1
            BRA     .HERE2  

.HERE2      CLR.L   D4
            CLR.L   D5
            MOVE.W  (CHARX),D4       ; LEFT X
            MOVE.W  (CHARY),D5       ; UPPER Y
            ADD.W   #CHARBODY-2,D5
            SUB.W   #CHARSPED,D4     ; NEXT LEFT X IF MOVED
            LSR     #5,D5            ; R==D1
            LSR     #5,D4            ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5           ; R*20==D1
            ADD.W   D4,D5            ; C+R*20==D1
            ADD.W   D5,A1            ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B  (A1),D5          ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            MOVE.W  #$FF,D5
            

.OBSTACLE   MOVEM.L (A7)+,A1/D3-D4
            RTS
 



;-----------------------------------------------------------
GETNXTR
;GETS IF THE NEXT RIGHT BLOCK IS FREE OR NOT
;INPUT      -   NONE          
;OUTPUT     -   D5.W==FF CAN MOVE
;MODIFIES   -   NONE
;-----------------------------------------------------------


            MOVEM.L A1/D3-D4,-(A7)  ; STACK REGISTERS
            
*            LEA SCREEN1,A1
            
            MOVE.W  (MAPCUR),D3
            CMP.W   #1,D3
            BEQ     .MAP1
            CMP.W   #2,D3
            BEQ     .MAP2
            CMP.W   #3,D3
            BEQ     .MAP3
            CMP.W   #4,D3
            BEQ     .MAP4
            CMP.W   #5,D3
            BEQ     .MAP5
            CMP.W   #6,D3
            BEQ     .MAP6

.MAP1       LEA     SCREEN1,A1
            BRA     .HERE
.MAP2       LEA     SCREEN2,A1
            BRA     .HERE
.MAP3       LEA     SCREEN3,A1
            BRA     .HERE
.MAP4       LEA     SCREEN4,A1
            BRA     .HERE
.MAP5       LEA     SCREEN5,A1
            BRA     .HERE
.MAP6       LEA     SCREEN6,A1
            BRA     .HERE    
            
.HERE       CLR.L   D4
            CLR.L   D5
            MOVE.W (CHARX),D4                    ; LEFT X
            MOVE.W (CHARY),D5                    ; UPPER Y
            ADD.W   #CHARSPED+CHARBODY-1,D4      ; NEXT RIGHT X IF MOVED
            LSR     #5,D5                        ; R==D1
            LSR     #5,D4                        ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5                       ; R*20==D1
            ADD.W   D4,D5                        ; C+R*20==D1
            ADD.W   D5,A1                        ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B (A1),D5                       ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE

            CMP.W   #1,D3
            BEQ     .MAP11
            CMP.W   #2,D3
            BEQ     .MAP22
            CMP.W   #3,D3
            BEQ     .MAP33
            CMP.W   #4,D3
            BEQ     .MAP44
            CMP.W   #5,D3
            BEQ     .MAP55
            CMP.W   #6,D3
            BEQ     .MAP66
            

.MAP11      LEA     SCREEN1,A1
            BRA     .HERE1
.MAP22      LEA     SCREEN2,A1
            BRA     .HERE1
.MAP33      LEA     SCREEN3,A1
            BRA     .HERE1
.MAP44      LEA     SCREEN4,A1
            BRA     .HERE1
.MAP55      LEA     SCREEN5,A1
            BRA     .HERE1
.MAP66      LEA     SCREEN6,A1
            BRA     .HERE1
            
               
            
.HERE1      CLR.L   D4
            CLR.L   D5
            MOVE.W  (CHARX),D4                   ; LEFT X
            MOVE.W  (CHARY),D5                   ; UPPER Y
            ADD.W   #CHARBODY-2,D5               ;BOTTOM Y
            ADD.W   #CHARSPED+CHARBODY-1,D4      ; NEXT RIGHT X IF MOVED
            LSR     #5,D5                        ; R==D1
            LSR     #5,D4                        ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5                       ; R*20==D1
            ADD.W   D4,D5                        ; C+R*20==D1
            ADD.W   D5,A1                        ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B  (A1),D5                      ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            MOVE.W  #$FF,D5
            

.OBSTACLE   MOVEM.L (A7)+,A1/D3-D4
            RTS


;-----------------------------------------------------------
GETNXTU
;GETS IF THE NEXT UPPER BLOCK IS FREE OR NOT
;INPUT      -   NONE          
;OUTPUT     -   D5.W==FF IF UPPER BLOCK IS FREE
;MODIFIES   -   NONE
;-----------------------------------------------------------


            MOVEM.L A1/D3-D4,-(A7)  ; STACK REGISTERS
            

            MOVE.W  (MAPCUR),D3
            CMP.W   #1,D3
            BEQ     .MAP1
            CMP.W   #2,D3
            BEQ     .MAP2
            CMP.W   #3,D3
            BEQ     .MAP3
            CMP.W   #4,D3
            BEQ     .MAP4
            CMP.W   #5,D3
            BEQ     .MAP5
            CMP.W   #6,D3
            BEQ     .MAP6

.MAP1       LEA     SCREEN1,A1
            BRA     .HERE
.MAP2       LEA     SCREEN2,A1
            BRA     .HERE
.MAP3       LEA     SCREEN3,A1
            BRA     .HERE
.MAP4       LEA     SCREEN4,A1
            BRA     .HERE
.MAP5       LEA     SCREEN5,A1
            BRA     .HERE
.MAP6       LEA     SCREEN6,A1
            BRA     .HERE             

.HERE       CLR.L   D4
            CLR.L   D5
            MOVE.W  (CHARX),D4          ; LEFT X
            MOVE.W  (CHARY),D5          ; UPPER Y
            SUB.W   #CHARJUMP-5,D5      ; NEXT UPPER Y IF MOVED
            LSR     #5,D5               ; R==D1
            LSR     #5,D4               ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5              ; R*20==D1
            ADD.W   D4,D5               ; C+R*20==D1
            ADD.W   D5,A1               ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B (A1),D5              ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            
       
            CMP.W   #1,D3
            BEQ     .MAP11
            CMP.W   #2,D3
            BEQ     .MAP22
            CMP.W   #3,D3
            BEQ     .MAP33
            CMP.W   #4,D3
            BEQ     .MAP44
            CMP.W   #5,D3
            BEQ     .MAP55
            CMP.W   #6,D3
            BEQ     .MAP66

.MAP11      LEA     SCREEN1,A1
            BRA     .HERE1
.MAP22      LEA     SCREEN2,A1
            BRA     .HERE1
.MAP33      LEA     SCREEN3,A1
            BRA     .HERE1
.MAP44      LEA     SCREEN4,A1
            BRA     .HERE1
.MAP55      LEA     SCREEN5,A1
            BRA     .HERE1
.MAP66      LEA     SCREEN6,A1
            BRA     .HERE1
            

.HERE1      CLR.L   D4
            CLR.L   D5
            MOVE.W  (CHARX),D4          ; LEFT X
            ADD.W   #CHARBODY,D4        ; RIGHT X
            MOVE.W  (CHARY),D5          ; UPPER Y
            SUB.W   #CHARJUMP-5,D5      ; NEXT UPPER Y IF MOVED
            LSR     #5,D5               ; R==D1
            LSR     #5,D4               ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5              ; R*20==D1
            ADD.W   D4,D5               ; C+R*20==D1
            ADD.W   D5,A1               ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B  (A1),D5             ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            MOVE.W  #$FF,D5

.OBSTACLE   MOVEM.L (A7)+,A1/D3-D4
            RTS           

;-----------------------------------------------------------
FALLING
;CHECKS IF CHARACTER IS FALLING OR NOT
;INPUT      -   NONE          
;OUTPUT     -   D5.W==FF IF IN THE AIR
;MODIFIES   -   NONE
;-----------------------------------------------------------

            MOVEM.L A1/D3-D4,-(A7)  ; STACK REGISTERS
            
            MOVE.W  (MAPCUR),D3
            CMP.W   #1,D3
            BEQ     .MAP1
            CMP.W   #2,D3
            BEQ     .MAP2
            CMP.W   #3,D3
            BEQ     .MAP3
            CMP.W   #4,D3
            BEQ     .MAP4
            CMP.W   #5,D3
            BEQ     .MAP5
            CMP.W   #6,D3
            BEQ     .MAP6

.MAP1       LEA     SCREEN1,A1
            BRA     .HERE
.MAP2       LEA     SCREEN2,A1
            BRA     .HERE
.MAP3       LEA     SCREEN3,A1
            BRA     .HERE            
.MAP4       LEA     SCREEN4,A1
            BRA     .HERE
.MAP5       LEA     SCREEN5,A1
            BRA     .HERE
.MAP6       LEA     SCREEN6,A1
            BRA     .HERE 

.HERE       CLR     D4
            CLR     D5
            MOVE.W (CHARX),D4           ; LEFT X
            MOVE.W (CHARY),D5           ; UPPER Y
            ADD.W   #CHARBODY,D5        ; BOTTOM Y
            
            LSR     #5,D5               ; R==D1
            LSR     #5,D4               ; C==D0
            ;TO ACCES THE MATRISX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5              ; R*20==D1
            ADD.W   D4,D5               ; C+R*20==D1
            ADD.W   D5,A1               ; SCREEN+R+C*20==D1
            CLR     D5
            MOVE.B (A1),D5              ; SCREEN+R+C*20==D1           
            CMP.B   #0,D5
            BGT     .OBSTACLE
            
            
            CMP.W   #1,D3
            BEQ     .MAP11
            CMP.W   #2,D3
            BEQ     .MAP22
            CMP.W   #3,D3
            BEQ     .MAP33
            CMP.W   #4,D3
            BEQ     .MAP44
            CMP.W   #5,D3
            BEQ     .MAP55
            CMP.W   #6,D3
            BEQ     .MAP66

.MAP11      LEA     SCREEN1,A1
            BRA     .HERE1
.MAP22      LEA     SCREEN2,A1
            BRA     .HERE1
.MAP33      LEA     SCREEN3,A1
            BRA     .HERE1
.MAP44      LEA     SCREEN4,A1
            BRA     .HERE1
.MAP55      LEA     SCREEN5,A1
            BRA     .HERE1
.MAP66      LEA     SCREEN6,A1
            BRA     .HERE1            

.HERE1      MOVE.W  (CHARX),D4          ; LEFT X
            ADD.W   #CHARBODY,D4        ; RIGHT X
            MOVE.W  (CHARY),D5          ; UPPER Y
            ADD.W   #CHARBODY,D5        ; BOTTOM Y
            
            LSR     #5,D5               ; R==D1
            LSR     #5,D4               ; C==D0
            ; TO ACCES THE MATRIX SCREEN[R][C]
            ; DO SCREEN+C+R*20
            MULU.W  #20,D5              ; R*20==D1
            ADD.W   D4,D5               ; C+R*20==D1
            ADD.W   D5,A1               ; SCREEN+R+C*20==D1
            CLR     D5
            MOVE.B  (A1),D5             ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            MOVE.W  #$FF,D5
            
         
.OBSTACLE   MOVEM.L (A7)+,A1/D3-D4  ; STACK REGISTERS
            RTS  



;-----------------------------------------------------------
GETNXTRS
;GETS IF THE NEXT RIGHT BLOCK IS FREE OR NOT FOR THE SHOT
;               (AO) : SHOTX - WORD       
;              2(A0) : SHOTY - WORD 
;INPUT      -   NONE          
;OUTPUT     -   D5.W==FF CAN MOVE
;MODIFIES   -   NONE
;-----------------------------------------------------------


            MOVEM.L A1/D3-D4,-(A7)  ; STACK REGISTERS
            
            
            MOVE.W  (MAPCUR),D3
            CMP.W   #1,D3
            BEQ     .MAP1
            CMP.W   #2,D3
            BEQ     .MAP2
            CMP.W   #3,D3
            BEQ     .MAP3
            CMP.W   #4,D3
            BEQ     .MAP4
            CMP.W   #5,D3
            BEQ     .MAP5
            CMP.W   #6,D3
            BEQ     .MAP6

.MAP1       LEA     SCREEN1,A1
            BRA     .HERE
.MAP2       LEA     SCREEN2,A1
            BRA     .HERE
.MAP3       LEA     SCREEN3,A1
            BRA     .HERE
.MAP4       LEA     SCREEN4,A1
            BRA     .HERE
.MAP5       LEA     SCREEN5,A1
            BRA     .HERE
.MAP6       LEA     SCREEN6,A1
            BRA     .HERE             
            
.HERE       CLR.L   D4
            CLR.L   D5
            MOVE.W  (A0),D4             ; LEFT X
            MOVE.W  2(A0),D5            ; UPPER Y
            ADD.W   #SHOTSPED,D4        ; NEXT RIGHT X IF MOVED
            LSR     #5,D5               ; R==D1
            LSR     #5,D4               ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5              ; R*20==D1
            ADD.W   D4,D5               ; C+R*20==D1
            ADD.W   D5,A1               ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B  (A1),D5             ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            MOVE.W  #$FF,D5

.OBSTACLE   MOVEM.L (A7)+,A1/D3-D4
            RTS

;-----------------------------------------------------------
GETNXTLS
;GETS IF THE NEXT LEFT BLOCK IS FREE OR NOT FOR THE SHOT
;               (AO) : SHOTX - WORD       
;              2(A0) : SHOTY - WORD 
;INPUT      -   NONE          
;OUTPUT     -   D5.W==FF CAN MOVE
;MODIFIES   -   NONE
;-----------------------------------------------------------


            MOVEM.L A1/D3-D4,-(A7)  ; STACK REGISTERS
            

            MOVE.W  (MAPCUR),D3
            CMP.W   #1,D3
            BEQ     .MAP1
            CMP.W   #2,D3
            BEQ     .MAP2
            CMP.W   #3,D3
            BEQ     .MAP3
            CMP.W   #4,D3
            BEQ     .MAP4
            CMP.W   #5,D3
            BEQ     .MAP5
            CMP.W   #6,D3
            BEQ     .MAP6

.MAP1       LEA     SCREEN1,A1
            BRA     .HERE
.MAP2       LEA     SCREEN2,A1
            BRA     .HERE
.MAP3       LEA     SCREEN3,A1
            BRA     .HERE
.MAP4       LEA     SCREEN4,A1
            BRA     .HERE
.MAP5       LEA     SCREEN5,A1
            BRA     .HERE
.MAP6       LEA     SCREEN6,A1
            BRA     .HERE             

.HERE       CLR.L   D4
            CLR.L   D5
            MOVE.W  (A0),D4             ; LEFT X
            MOVE.W  2(A0),D5            ; UPPER Y
            SUB.W   #SHOTSPED,D4        ; NEXT RIGHT X IF MOVED
            LSR     #5,D5               ; R==D1
            LSR     #5,D4               ; C==D0
            ;TO ACCES THE MATRIX SCREEN[R][C]
            ; SCREEN+C+R*20
            MULU.W  #20,D5              ; R*20==D1
            ADD.W   D4,D5               ; C+R*20==D1
            ADD.W   D5,A1               ; SCREEN+R+C*20==D1
            CLR.L   D5
            MOVE.B  (A1),D5             ; SCREEN+R+C*20==D1
            CMP.B   #0,D5
            BGT     .OBSTACLE
            MOVE.W  #$FF,D5

.OBSTACLE   MOVEM.L (A7)+,A1/D3-D4
            RTS


























;-------MAPS------------------------------------------------


        
SCREEN1 DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1        
      
          
        
SCREEN2 DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
        DC.B 1,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1
        DC.B 1,1,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1
        DC.B 1,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1
        DC.B 1,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1        

       

SCREEN3 DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,1,1,0,0,1,1,1,1,1,1,1,0,0,0,0,1
        DC.B 1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,0,0,1,0,0,1,1,0,1,1,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
        DC.B 1,0,0,0,1,0,1,0,1,0,1,1,1,0,1,0,0,1,1,1
        DC.B 1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1
        DC.B 1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1


        
        

SCREEN4 DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        
        
SCREEN5 DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1
        DC.B 1,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1
        DC.B 1,0,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1        



SCREEN6 DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,1
        DC.B 1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,1,0,0,1,1,0,0,1,0,0,1,1,0,0,0,1
        DC.B 1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1
        DC.B 1,0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        DC.B 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 














*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
