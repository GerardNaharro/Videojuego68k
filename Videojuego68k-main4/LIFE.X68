*-----------------------------------------------------------
* Title      : LIFE MANAGEMENT
* Written by : GERARD NAHARRO AND LUCAS ORTIZ
* Date       :
* Description: 29-12-2020 - CREATION
*-----------------------------------------------------------


;-----------------------------------------------------------
LIFEINIT
;INITIALIZE THE CHARACTER'S LIFE
;INPUT      -   NONE
;OUTPUT     -   D6.B WITH THE NUMBER OF RESTANT HITS
;MODIFIES   -   D6.B   
;-----------------------------------------------------------

            MOVE.B #3,D6        ;3 LIFES
            RTS
            
            
;-----------------------------------------------------------
LIFEUPD
;UPDATES THE CHARACTER'S LIFE
;INPUT      -   NONE
;OUTPUT     -   D6.B WITH THE NUMBER OF RESTANT HITS
;MODIFIES   -   D6.B   
;-----------------------------------------------------------

            RTS
            
            
            
;-----------------------------------------------------------
LIFEPLOT
;PLOTS THE CHARACTER'S LIFE
;INPUT      -   NONE
;OUTPUT     -   NONE
;MODIFIES   -   NONE   
;-----------------------------------------------------------

            ;PAINT ALL THE FULL HEARTS
            MOVEM.L D0-D7/A0-A1,-(A7)      ;STACK REGISTERS
            SUBQ.B  #1,D6                  ;-1 FOR THE DBRA
            LEA HEART,A0
            MOVE.W #601,D3                 ;X WHERE TO STOP PAINTING
            MOVE.W #19,D4                  ;Y WHERE TO STOP PAINTING

            CLR.L D1
            CLR.L D2
            MOVE.W #589,D1                 ;X WHERE TO START PAINTING
            CLR.L D5
            MOVE.W D1,D5                   ;COPY THE INITIAL X
            MOVE.W #9,D2                   ;Y WHERE TO STOP PAINTING

.LOOP        
           
            BRA .COLOR                     ;GET THE COLOR
.HERE
            MOVE.W #82,D0
            TRAP #15                       ;PAINT
            ADDQ.W #1,D1                   ;NEXT X PIXEL
            CMP.W D3,D1                    ;IF NOT THE FINAL X PIXEL CONTINUE
            BLE .LOOP
            ADDQ.W #1,D2                   ;NEXT Y PIXEL
            CLR.L D1            
            MOVE.W D5,D1                   ;INITIAL X PIXEL
            CMP.W D4,D2                    ;IF NOT THE FINAL Y PIXEL CONTINUE
            BLE .LOOP            
            ADD.W #17,D3                   ;NEXT HEART FINAL X
            ADD.W #17,D1                   ;NEXT HEART INITIAL X
            MOVE.W D1,D5                   ;COPY THE INITIAL X
            MOVE.W #9,D2                   ;NEXT HEART INITIAL Y
            LEA HEART,A0
            DBRA D6, .LOOP
            MOVE.B #3,D7                   ;CHECK IF THERE ARE ANY EMPTY HEARTS (DAMAGED)
            SUB.B D6,D7
            TST.B D7
            BGT .BROKEN                     ;PAINT THEM
            MOVEM.L (A7)+,D0-D7/A0-A1     ;STORE REGISTERS
            RTS
            
.COLOR
            MOVE.L D1,-(A7)
            MOVE.L (A0)+,D1
            MOVE.W #80,D0
            TRAP #15
            MOVE.L (A7)+,D1
            BRA .HERE




.BROKEN     SUBQ.B #1,D7
            LEA BRKHEART,A0

.LOOP2        
           
            BRA .COLOR2
.HERE2
            MOVE.W #82,D0
            TRAP #15
            ADDQ.W #1,D1
            CMP.W D3,D1
            BLE .LOOP2
            ADDQ.W #1,D2
            CLR.L D1
            
            MOVE.W D5,D1

            CMP.W D4,D2
            BLE .LOOP2
            
            ADD.W #17,D3
            ADD.W #17,D1
            MOVE.W D1,D5
            MOVE.W #9,D2
            LEA BRKHEART,A0
            DBRA D7, .LOOP2
            MOVEM.L (A7)+,D0-D7/A0-A1     ;STORE REGISTERS
            RTS
            
.COLOR2
            MOVE.L D1,-(A7)
            MOVE.L (A0)+,D1
            MOVE.W #80,D0
            TRAP #15
            MOVE.L (A7)+,D1
            BRA .HERE2


            
            
            
            
            
HEART  DC.L    $00003,$005017,$005039,$000038,$002024,$002013,$00007,$001013,$001038
       DC.L    $000040,$000034,$005025,$00007,$000012,$007024,$00573d8b,$0063469c,$00674f97
       DC.L    $000026,$004021,$000027,$00613da7,$006c43bd,$00633fab,$000031,$00e81b,$004036
       DC.L    $00604692,$00684e9c,$00ffe0ff,$00fed8ff,$006038af,$000049,$00653cb6,$00642fcc,$006228d4
       DC.L    $006229d2,$00643bb5,$000016,$000039,$005f419a,$00ffe1ff,$00fdd9ff,$006230c4,$006b34d7
       DC.L    $005e28c7,$006028cd,$006324de,$005f1de0,$00601fe0,$006536c2,$006021,$00302d,$00604694
       DC.L    $00ffdaff,$006737c5,$006024d6,$005c1cda,$00692ae4,$006323e0,$006624e8,$006625e6,$006328d7
       DC.L    $00653bb8,$00101a,$000016,$000024,$006645a6,$006030be,$00692be3,$00641fec,$005e1ae3
       DC.L    $006321e5,$005c1cda,$00632ad3,$006638c0,$000039,$000012,$00213,$0010e,$000023
       DC.L    $005d3aa2,$00682eda,$005c17e4,$006823ef,$006525e3,$00672fd6,$006136b5,$00002d,$003017
       DC.L    $00208,$00260,$00010,$0010e,$005030,$005e30b9,$00682cde,$006424e1,$006026d2
       DC.L    $006338b7,$000035,$002014,$00000,$00120,$00020,$00340,$00000,$000014
       DC.L    $001038,$00643ab7,$00612ec6,$006235ba,$000030,$000014,$00007,$00000,$00010
       DC.L    $00675,$00010,$00010,$009510,$00001c,$00002e,$006342a3,$00503d,$000015
       DC.L    $00003,$00001,$00001,$00001,$00003,$00326,$00206,$00007,$0000a
       DC.L    $0010e,$002011,$0000e,$00007,$00003,$00000,$00001,$00007  



BRKHEART  DC.L    $00333,$00111,$00111,$00000,$00000,$00000,$00222,$00000,$00222
          DC.L    $00000,$00555,$00000,$00222,$00000,$00222,$005e5e5e,$00646464,$00656565
          DC.L    $00000,$00000,$00333,$00646464,$00646464,$00636363,$00000,$00000,$00000
          DC.L    $00696969,$00ffffff,$00ffffff,$00ffffff,$00ffffff,$00000,$00fcfcfc,$00ffffff,$00ffffff
          DC.L    $00fdfdfd,$00636363,$00999,$00000,$00616161,$00fafafa,$00fafafa,$00fafafa,$00ffffff
          DC.L    $00f9f9f9,$00ffffff,$00ffffff,$00fdfdfd,$00fefefe,$00666666,$00000,$00000,$00666666
          DC.L    $00ffffff,$00ffffff,$00fcfcfc,$00fafafa,$00ffffff,$00fdfdfd,$00fbfbfb,$00ffffff,$00ffffff
          DC.L    $00666666,$00555,$00777,$00000,$00696969,$00fefefe,$00ffffff,$00ffffff,$00fdfdfd
          DC.L    $00fdfdfd,$00ffffff,$00ffffff,$00616161,$00000,$00000,$00000,$00888,$00000
          DC.L    $00666666,$00fcfcfc,$00ffffff,$00f8f8f8,$00ffffff,$00ffffff,$005d5d5d,$00444,$00444
          DC.L    $00000,$00111,$00222,$00000,$00666,$00636363,$00fdfdfd,$00ffffff,$00fcfcfc
          DC.L    $00636363,$00222,$00000,$00000,$00444,$00333,$00000,$00000,$00555
          DC.L    $00000,$005e5e5e,$00ffffff,$00636363,$00000,$00000,$00000,$00000,$00000
          DC.L    $00000,$00444,$00000,$00000,$00000,$00eee,$005f5f5f,$00666,$00000
          DC.L    $00000,$00000,$00000,$00000,$00000,$00777,$00111,$00000,$00888
          DC.L    $00000,$00777,$00000,$00000,$00000,$00000,$00000,$00000



         



*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
