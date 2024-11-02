
        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
CLRCHN = $ffcc
HOME = $ffba
GETIN = $FFE4      ; Address for GETIN


SCREEN_MEM = $1E00
COLOR_MEM = $9600
NEXT_COLOR_MEM = $96FF

COUNT_FOR_LOOP = $0003
COLOR_FOR_LOOP = $0004
COUNTER = $0005
USE_NEXT_COLOR_MEMORY =  $0006

NEWCHAR_LOCATION = $1100

        org $1001    ; Starting memory location

        include "stub.s"

NEWCHAR:
        org NEWCHAR_LOCATION
        dc.b %00011000
        dc.b %00100100
        dc.b %01000010
        dc.b %01111110
        dc.b %01111110
        dc.b %01000010
        dc.b %01000010
        dc.b %00000000


; our program starts here
start:
       	lda #$93
        JSR CHROUT
        JSR CLRCHN               
        
; we have this so we can debug (to be removed)
wait_for_input:
        JSR GETIN

        CMP #'A
        BEQ load_char
        BNE wait_for_input

wait_for_input2:
        JSR GETIN

        CMP #'0
        BEQ wait_for_input2 
        BNE char_screen

load_char:
        ; point VIC to use custom character set at $1000
        LDA #$FC 
        STA $9005              

char_screen:
        ; display custom character on the screen
        LDA #$00                
        STA SCREEN_MEM 


loop:
        JMP wait_for_input2                  