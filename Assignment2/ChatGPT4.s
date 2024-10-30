        processor 6502

CHROUT = $FFD2            ; KERNAL routine to output a character
CLRCHN = $FFCC            ; Clear screen routine
SCREEN_MEM = $1E00
COLOR_MEM = $9600
NEXT_COLOR_MEM = $96FF
BACKGROUND_COLOR_ADDRESS = $900F

        org $1001                 ; Starting memory location
        include "stub.s"

msg:
    HEX 41 55 52 41 3A 54 48 45 20 57 49 5A 41 52 44 53 20 51 55 45 53 54 0D 53 48 41 48 5A 49 4C 4C 20 4E 41 56 45 45 44 0A 0D 4D 55 54 45 45 42 41 20 4A 41 4D 41 4C 0A 0D 4B 45 4E 5A 59 20 48 41 4D 45 44 0A 0D 32 30 32 34 0D 00
msg2:
    HEX 20 20 7A 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 20 20 7A 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 20 20 20 20 76 76 76 76 76 76 76 76 76 76 76 76 76 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 0D 20 20 20 50 52 45 53 53 20 41 20 54 4F 20 50 4C 41 59 00

colors:
    HEX 01 01 01 01 01 04 01 01 04 08

start:
    JSR clear_screen
    LDA #$00
    STA BACKGROUND_COLOR_ADDRESS
    JMP title_screen

clear_screen:
    LDA #$93
    JSR CHROUT
    JSR CLRCHN
    RTS

title_screen:
    LDX #0
    JSR print_text
    LDX #0
    JSR print_text_2
    JSR color_screen
    JMP inf_loop

print_text:
    LDA msg,X
    BEQ reset_x
    JSR CHROUT
    INX
    JMP print_text

reset_x:
    RTS

print_text_2:
    LDA msg2,X
    BEQ color_screen
    JSR CHROUT
    INX
    JMP print_text_2

color_screen:
    LDX #0
    LDY #0
    JSR color_update
    RTS

color_update:
    LDA colors,X
    STA COLOR_MEM,Y
    INX
    INY
    CPY #$FF
    BNE color_update
    RTS

inf_loop:
    JMP inf_loop
