; this is our title screen. we loaded the hex values to write all the required info
; (title, names, year) and draw a wizards hat. we are using the CHROUT routine to put these on the screen.
; we stored all the color data in another HEX variable.
; since the counter maxes out at 255 we have another color memory address variable that starts at 38400 + 255
; so we can starts from 0 again and continue updating the color memory

        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
GETIN = $FFE4      ; Address for GETIN
CLRCHN = $ffcc
HOME = $ffba

SCREEN_MEM = $1E00
COLOR_MEM = $9600
NEXT_COLOR_MEM = $96FF
BACKGROUND_COLOR_ADDRESS = $900F    ; Background color address 

        org $1001    ; Starting memory location

        include "stub.s"

msg:
        HEX 41 55 52 41 3A 54 48 45 20 57 49 5A 41 52 44 53 20 51 55 45 53 54 0D 53 48 41 48 5A 49 4C 4C 20 4E 41 56 45 45 44 0A 0D 4D 55 54 45 45 42 41 20 4A 41 4D 41 4C 0A 0D 4B 45 4E 5A 59 20 48 41 4D 45 44 0A 0D 32 30 32 34 0D 20 20 20 20 20 20 20 20 20 20 A6 0D 20 20 7A 20 20 20 20 20 20 A6 A6 A6 0D 20 20 20 20 20 20 20 20 A6 A6 A6 A6 A6 0D 20 20 20 20 7A 20 20 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 00

msg2:
        HEX 20 20 7A 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 20 20 7A 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 20 20 20 20 76 76 76 76 76 76 76 76 76 76 76 76 76 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 0D 20 20 20 50 52 45 53 53 20 41 20 54 4F 20 50 4C 41 59 00

colors:
        HEX 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 01 01 01 01 01 01 01 00 00 00 00 00 00 00 01 00 00 00 00 00 01 01 01 01 01 01 01 01 01 00 00 00 00 00 01 00 00 00 00 00 01 01 01 01 01 01 01 01 01 01 01 00 00 00 00 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 04 01 01 01 01 01 01 01 01 01 01 01 01 01 07 01 01 01 01 01 01 04 04 04 08
colors2:
        HEX 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 04 04 04 04 04 01 01 01 01 01 01 01 01 01 01 01 01 01 07 01 01 04 04 04 04 04 04 04 01 01 01 01 01 01 01 01 01 01 01 01 01 01 04 04 04 04 04 04 04 04 04 01 01 01 01 01 01 01 01 01 01 01 01 01 04 04 04 04 04 04 04 04 04 01 01 01 01 01 01 01 01 01 07 01 01 04 04 04 04 04 04 04 04 04 04 04 01 01 01 01 07 01 01 01 01 01 01 04 04 04 04 04 04 04 04 04 04 04 01 01 01 01 01 01 01 01 01 01 01 04 04 04 04 04 04 04 04 04 04 04 01 01 07 01 01 01 01 01 01 01 07 07 07 07 07 08
colors3:
        HEX 07 07 07 07 07 07 07 07 01 01 01 01 01 01 01 01 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 01 01 01 01 01 01 01 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 01 01 07 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 01 01 01 08

; our program starts here
start:
        JSR clear_screen
        lda #$00                ; Load the color black
        sta BACKGROUND_COLOR_ADDRESS    ; Store it in the memory
        JMP title_screen

clear_screen:
        LDA #$93
        JSR CHROUT
        JSR CLRCHN

title_screen:
        LDX #0                ; Initialize index to read msg    
        JMP print_section_one

print_section_one:
        LDA msg,X ;Load character

        CMP #$00 ;Is it 00
        BEQ reset_x ;If yes move on to get input

        JSR CHROUT ;Print character

        INX ;Increment index

        JMP print_section_one ;Repeat

colour_memory_black:
        Lda #$04
        Sta COLOR_MEM,Y
        INX ;Increment index
        INY

        JMP print_section_one

reset_x:
        LDX #0

        JMP print_section_two

print_section_two:
        LDA msg2,X ;Load character

        CMP #$00 ;Is it 00
        BEQ color_screen ;If yes move on to get input

        JSR CHROUT ;Print character
	
	INX

        JMP print_section_two ;Repeat

color_screen:
        LDX #0
        LDY #0

        JMP color
color:
        LDA colors,X
        CMP #$08 	; using 08 to move on
        BEQ cont_color_screen

	Sta COLOR_MEM,Y

        INX
        INY

        JMP color

cont_color_screen:
        LDX #0
        JMP color2

color2:
        LDA colors2,X
        CMP #$08        ; using 08 to move on
        BEQ inf_loop

        Sta COLOR_MEM,Y

        INX
        INY

        CPY #$FF               ; Compare Y to 255
        BEQ use_next_color_mem

        JMP color2

use_next_color_mem:
        LDY #0

color3:
        LDA colors2,X
        CMP #$08
        BEQ cont_color_screen_2

        Sta NEXT_COLOR_MEM,Y

        INX
        INY

        JMP color3

cont_color_screen_2:
        LDX #0
        JMP color4

color4:
        LDA colors3,X
        CMP #$08
        BEQ inf_loop

        Sta NEXT_COLOR_MEM,Y

        INX
        INY

        JMP color4

inf_loop:
        JMP inf_loop
