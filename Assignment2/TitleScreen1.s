; this is our title screen. we loaded the hex values to write all the required info
; (title, names, year) and draw a wizards hat. we are using the CHROUT routine to put these on the screen.
; we stored all the color data in another HEX variable.
; since the counter maxes out at 255 we have another color memory address variable that starts at 38400 + 255
; so we can starts from 0 again and continue updating the color memory

        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
CLRCHN = $ffcc
HOME = $ffba

SCREEN_MEM = $1E00
COLOR_MEM = $9600
NEXT_COLOR_MEM = $96FF

COUNT_FOR_LOOP = $0003
COLOR_FOR_LOOP = $0004
COUNTER = $0005
USE_NEXT_COLOR_MEMORY =  $0006


ZP_SRC_ADDR_LO = $07  ; Zero-page address for low byte
ZP_SRC_ADDR_HI = $08  ; Zero-page address for high byte

PLATFORM_CHAR = $09 
PLATFORM_COLOR = $0A

SCREEN_POS_LO   = $0B   ; Low byte of screen memory address
SCREEN_POS_HI   = $0C   ; High byte of screen memory address
COLOR_POS_LO    = $0D   ; Low byte of color memory address
COLOR_POS_HI    = $0E   ; High byte of color memory address

        org $1001    ; Starting memory location

        include "stub.s"

msg:
        HEX 41 55 52 41 3A 54 48 45 20 57 49 5A 41 52 44 53 20 51 55 45 53 54 0D 53 48 41 48 5A 49 4C 4C 20 4E 41 56 45 45 44 0A 0D 4D 55 54 45 45 42 41 20 4A 41 4D 41 4C 0A 0D 4B 45 4E 5A 59 20 48 41 4D 45 44 0A 0D 32 30 32 34 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 20 20 20 50 52 45 53 53 20 41 20 54 4F 20 50 4C 41 59 00 ;This is the data for inital text on the screen - Aura the Wizards qust, Muteba Jamal, Shahzill Naveed, Kenzy Hamed

hatChar: 
 ;       HEX 20 A6 0D 20 7A 20 A6 0D 20 A6 0D 20 7A 20 A6 0D 20 A6 0D 20 A6 0D 20 7A 20 A6 20 7A 0D 20 A6 0D 20 A6 20 7A 0D 20 76 0D 20 A6 0D 20 A6 20 7A 0D 20 50 52 45 53 20 41 20 54 4F 20 50 4C 41 59 00 ; these are the values for the hat characters that need to be stored in the screen memory

hatCharCount: 
  ;      HEX 0A 01 01 02 01 06 03 01 08 05 01 04 01 02 07 01 06 09 01 06 09 01 02 01 02 0B 04 01 01 05 0B 01 05 0B 02 01 01 04 0D 01 03 0F 01 03 0F 02 01 02 03 01 01 01 02 01 01 01 01 01 01 01 01 01 01 01 ; this is the number of times the character in hatChar at the sam eindex needs to be repeated on the screen

colorValues:
   ;     HEX 00 04 07 04 07 04 07 04 07 04 07 04 07 00 FF ; these are the coor values that need to be stored in the screen mem

countValues:
    ;    HEX 8D 0F 07 27 02 3D 02 10 07 23 1D 27 01 29 FF ; this is the number of times the color in the colorvalues at the same index needs to be repeated in the color memory

;--------------------------------------- TITLE_SCREEN_HAT DATA ---------------------------

TITLE_SCREEN_HAT:
        .byte $8e, $1E, $1, $A3, $1e, $03, $b8, $1e, $05, $cd, $1e, $07, $e2, $1e, $09, $f8, $1e, $08, $00, $1f, $01, $0d, $1f, $0b, $23, $1f, $0b, $39, $1f, $0b, $63, $1f, $0f, $79, $1f, $0f, $ff; 

TITLE_SCREEN_HAT_CROSSES:
        .byte $4e, $1f, $0D, $ff

TITLE_SCREEN_TABLE:
    .word TITLE_SCREEN_HAT
    .word TITLE_SCREEN_HAT_CROSSES

; our program starts here
start:
        JMP clear_screen

clear_screen:
        LDA #$93
        JSR CHROUT
        JSR CLRCHN

title_screen:
        LDX #0                ; Initialize index to read msg   

        ; TEST 
        JMP print_section_one

print_section_one:
        LDA msg,X ;Load character

        CMP #$00 ;Is it 00
        BEQ reset_x 

        JSR print
        JMP print_section_one

print_section_two2:
        LDA msg2,X ;Load character

        CMP #$00 ;Is it 00
        BEQ inf_loop 

        JSR print
        JMP print_section_two2

reset_x:
        jmp load_hat
        LDX #-1

increment_x:
        INX 

char_setup:
        LDA hatCharCount,X
        STA COUNT_FOR_LOOP

        LDY #0
        LDA hatChar,X

print_section_two:
        CMP #$00 ;Is it 00
        BEQ color_screen ;If yes move on to coloring the screen

        JSR CHROUT

        INY 
        CPY COUNT_FOR_LOOP
        BEQ increment_x
        
        JMP print_section_two

print:
        JSR CHROUT ;Print character
	INX
        RTS
        
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


start_printing_platforms:
        ldx #$00
        LDA PLATFORM_CHAR
       ; CMP #$02
       ; BEQ load_danger_platform
     
        
load_hat:
        ldy #0
        LDA #4
        STA PLATFORM_COLOR

        LDA #$66
        STA PLATFORM_CHAR
        jmp continue_load_title_screen

; Set up for printing danger platforms
goto_check_platform:
        LDA PLATFORM_CHAR
        ;CMP #$02
       ; BEQ goto_print_gem
        cmp #$66
        beq load_cross

        cmp #$56
        beq test
       ; CMP #$01
      ;  BEQ jmp_to_start_printing_platforms_after_02

test:
        ldx #0
        jmp print_section_two2
load_cross:
        ldy #2
        LDA #$7
        STA PLATFORM_COLOR

        LDA #$56
        STA PLATFORM_CHAR

continue_load_title_screen:
        LDA TITLE_SCREEN_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA TITLE_SCREEN_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        jmp load_print_platform

load_print_platform:
        LDA (ZP_SRC_ADDR_LO),y
        CMP #$FF                       ; FF indicates the end of the byte array
        BEQ goto_color_platform  
        STA SCREEN_POS_LO               ; Load the low byte of the platform start address
        INY

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        STA SCREEN_POS_HI  

        INY
        LDA (ZP_SRC_ADDR_LO),y    
        STA COUNT_FOR_LOOP              ; Number of platforms to print
        INY
        
        JMP print_platform

print_platform:
        TYA
        TAX
        LDY #$00
        LDA PLATFORM_CHAR                        ; Set platform identifier (or color)
        JSR draw_platform               ; Call subroutine to draw the platform
        TXA
        TAY

        DEC COUNT_FOR_LOOP              ; Decrement COUNT_FOR_LOOP by 1
        BNE inc_screen_lo_then_draw      ; If COUNT_FOR_LOOP is not zero, draw another platform

        JMP load_print_platform 

inc_screen_lo_then_draw:
        INC SCREEN_POS_LO
        JMP print_platform

color_is_96:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_platform    
        

goto_color_platform:
        ldy #$00            

load_color_platform:
        LDA (ZP_SRC_ADDR_LO),y  
        CMP #$FF                        ; Check if we've reached the end of color data
       
        ;;;; RED FLAG
        BEQ goto_check_platform  ; Branch if at the end of color data

        STA COLOR_POS_LO                 ; Load the low byte of the color start address
        INY                              ; Move to the next byte in the array

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        CMP #$1E
        BEQ color_is_96                ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI

continue_color_platform:      
        INY
        LDA (ZP_SRC_ADDR_LO),y   ; Number of platforms to color
        STA COLOR_FOR_LOOP
        INY
        
        JMP color_platform_loop

color_platform_loop:
        TYA
        TAX
        LDY #$00
        LDA PLATFORM_COLOR                         ; Load color value (modify as needed)
        JSR color_platform               ; Apply color to platform
        TXA
        TAY
        
        DEC COLOR_FOR_LOOP         ; Decrement the platform color counter
        BNE inc_color_lo_then_draw        ; If not zero, continue coloring next platform
        
        JMP load_color_platform   ; If zero, go back to load the next color start address

inc_color_lo_then_draw:
        INC COLOR_POS_LO
        JMP color_platform_loop

draw_platform:
        STA (SCREEN_POS_LO),y    
        rts

color_platform:
        STA (COLOR_POS_LO),y    
        rts



jmp_to_start_printing_platforms_after_02:
        LDY #$00
        LDA #$02
        STA PLATFORM_CHAR
        jmp start_printing_platforms
