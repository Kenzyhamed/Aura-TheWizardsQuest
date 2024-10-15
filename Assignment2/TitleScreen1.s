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

COUNT_FOR_LOOP = $1003
COLOR_FOR_LOOP = $1004
COUNTER = $1005
USE_NEXT_COLOR_MEMORY =  $1006

        org $1001    ; Starting memory location

        include "stub.s"

msg:
        HEX 41 55 52 41 3A 54 48 45 20 57 49 5A 41 52 44 53 20 51 55 45 53 54 0D 53 48 41 48 5A 49 4C 4C 20 4E 41 56 45 45 44 0A 0D 4D 55 54 45 45 42 41 20 4A 41 4D 41 4C 0A 0D 4B 45 4E 5A 59 20 48 41 4D 45 44 0A 0D 32 30 32 34 0D 20 20 20 20 20 20 20 20 20 20 A6 0D 20 20 7A 20 20 20 20 20 20 A6 A6 A6 0D 20 20 20 20 20 20 20 20 A6 A6 A6 A6 A6 0D 20 20 20 20 7A 20 20 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 00

msg2:
        HEX 20 20 7A 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 20 20 7A 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 20 20 20 20 76 76 76 76 76 76 76 76 76 76 76 76 76 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 0D 20 20 20 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 A6 20 20 7A 0D 0D 20 20 20 50 52 45 53 53 20 41 20 54 4F 20 50 4C 41 59 00

colorValues:
        HEX 00 04 07 04 07 04 07 04 07 04 07 04 07 00 FF

countValues:
        HEX 8D 0F 07 27 02 3D 02 10 07 23 1D 27 01 29 FF 

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
        BEQ reset_x 

        JSR CHROUT ;Print character

        INX ;Increment index

        JMP print_section_one ;Repeat

; reset x and print the next section
reset_x:
        LDX #0
        JMP print_section_two

print_section_two:
        LDA msg2,X 

        CMP #$00 ;Is it 00
        BEQ color_screen ;If yes move on to coloring the screen

        JSR CHROUT ;Print character
	
	INX

        JMP print_section_two ;Repeat

color_screen:
        LDX #-1         ; load the index for the color / count we want
        JMP next_color
 

color_loop:
        LDA USE_NEXT_COLOR_MEMORY  ; Check if USE_NEXT_COLOR_MEMORY is set to 01
        CMP #$01  
        BEQ higher_color_memory ; If 01, go to higher color memory

        ; default case, lower color memory
        
lower_color_memory:
        LDA COLOR_FOR_LOOP   ; Load the color
        STA COLOR_MEM,Y      ; Store the color in COLOR_MEM

        ; increment counter
        JMP increment_counter


higher_color_memory:
        LDA COLOR_FOR_LOOP   
        STA NEXT_COLOR_MEM,Y 

        ; increment counter
        JMP increment_counter

increment_counter:
        INY                  ; Increment Y for next memory location
        
        CPY #$FF
        BEQ use_next_color_memory

        INC COUNTER
        LDA COUNTER

        CMP COUNT_FOR_LOOP   ; compare counter with count for this color
        BEQ next_color       ; if counter matches, move to next color

        BNE color_loop

next_color:
        INX                 ; Move to the next color

        ; Reset the counter
        LDA #00
        STA COUNTER

        ; Load the next color and count values
        LDA countValues,X
        STA COUNT_FOR_LOOP

        LDA colorValues,X
        STA COLOR_FOR_LOOP

        CMP #$FF             ; Check if it's the end marker (FF)
        BEQ inf_loop         ; Jump to infinite loop if done

        JMP color_loop       ; Continue processing colors

use_next_color_memory:
        ; Set USE_NEXT_COLOR_MEMORY to 1 to start using NEXT_COLOR_MEM
        LDA #01
        STA USE_NEXT_COLOR_MEMORY

        LDY #00

        JMP color_loop       ; Continue with the updated memory

inf_loop:
        JMP inf_loop         ; Infinite loop (exit point)
