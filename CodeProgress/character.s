
        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
CLRCHN = $ffcc


SCREEN_MEM = $1E00
COLOR_MEM = $9600

CHAR_LOCATION = $1C00
VIC_CHAR_REG = $9005

        org $1001    ; Starting memory location

        include "stub.s"

msg:
	HEX 50 52 45 53 53 20 41 20 54 4F 20 53 54 41 52 54 0D 00

CHAR:
        org CHAR_LOCATION
        dc.b %00111100
        dc.b %01000010
        dc.b %10100101
        dc.b %10000001
        dc.b %10100101
        dc.b %10011001
        dc.b %01000010
        dc.b %00111100


; our program starts here
start:
       	lda #$93
        JSR CHROUT
        JSR CLRCHN

print_intro_msg:
	LDX #0                ; Initialize index

print_char:
	LDA msg,X ;Load character
 
	CMP #$00 ;Is it 00
	BEQ load_char ;If yes move on to get input

	JSR CHROUT ;Print character
	
	INX ;Increment index
	
	JMP print_char ;Repeat             

load_char:
        ; point VIC to use custom character set
        LDA #$FF
        STA $9005              

char_screen:
        ; display custom character on the screen
        LDA #$00          
        STA SCREEN_MEM

       	LDA #$00
        STA COLOR_MEM

loop:
        JMP loop                  