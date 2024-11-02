
        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
CLRCHN = $ffcc


SCREEN_MEM = $1E00
COLOR_MEM = $9600

CHAR_LOCATION = $1C00
PLATFORM_LOCATION = $1c08
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

PLATFORM:
        org PLATFORM_LOCATION
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %11111111
        dc.b %11111111
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000


; our program starts here
start:
       	lda #$93
        JSR CHROUT
        JSR CLRCHN          

load_char:
        ; point VIC to use custom character set
        lda #$FF
        sta VIC_CHAR_REG          

char_screen:
        ; display custom character on the screen
        LDA #$00  
        STA SCREEN_MEM
       	LDA #$00
        STA COLOR_MEM

        LDX #3 

        ; display platform on the screen
        LDA #$01
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

loop:
        JMP loop                  