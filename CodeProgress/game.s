        processor 6502

; TODO: we have used CMP after LDA throughout the code. since LDA sets the condition - we don't need to use CMP after. this needs to be changed. 
; NOTE: PARTIALLY FIXED
; KERNEL routines
CHROUT = $ffd2  
CLRCHN = $ffcc
HOME = $ffba
GETIN = $FFE4      

; Define boundaries for screen position high byte
SCREEN_MIN_HI = $1E   ; Starting high byte for display memory
SCREEN_MAX_HI = $1F   ; Adjust to fit your screen's high byte range

 
JUMP_COUNTER = $0230         ; Tracks how high the character has jumped-X
JUMPRU_COUNTER=$0250
DIAGONAL = $0240    

; screen addresses
SCREEN_START = $1E00 	; Start of screen memory in VIC-20
SCREEN_WIDTH = 22       ; VIC-20 screen width (22 columns)
SCREEN_HEIGHT = 23      ; VIC-20 screen height (23 rows)
COLOR_MEM = $9600       ; 
NEXT_COLOR_MEM = $96FF
VIC_CHAR_REG = $9005

BORDER_CHAR = $DF

; these are the addresses for our custom character set
CHAR_LOCATION = $1C00
NORAML_PLATFORM_LOCATION = $1C08
DANGER_PLATFORM_LOCATION = $1C10
BLANK_SPACE_LOCATION = $1C18
GEM_LOCATION = $1C20
ZERO_LOCATION = $1C28
ONE_LOCATION = $1C30
TWO_LOCATION = $1C38
THREE_LOCATION = $1C40
DEAD_CHAR_LOCATION = $1C48
DOOR_LOCATION = $1C50
DOOR_HANDLE_LOCATION = $1C58
CHAR_RIGHT_LOCATION = #$1C60

; addresses to store counts/variables
COUNT_FOR_LOOP = $0003
COLOR_FOR_LOOP = $0004
COUNTER = $0005
USE_NEXT_COLOR_MEMORY =  $0006
SOUND_COUNTER = $0008 
SOUND_LOOP_COUNT = $0009
LEVEL_COUNTER = $000A

; this is a screen memory address to that the count shows on the screen 
GEMS_COLLECTED = $1E15

; screen memory variables
SCREEN_POS_LO   = $00   ; Low byte of screen memory address
SCREEN_POS_HI   = $01   ; High byte of screen memory address
COLOR_POS_LO    = $02   ; Low byte of color memory address
COLOR_POS_HI    = $03   ; High byte of color memory address
TEMP_SCREEN_POS_LO   = $04   ; Low byte of screen memory address
TEMP_SCREEN_POS_HI   = $05   ; High byte of screen memory address

; repeated variables
; TODO: add variables for all our custom characters

        org $1001    ; Starting memory location

        include "stub.s"

; This is the data for inital text on the screen it says 
; AURA:THE WIZARDS QUEST  
; 
; SHAHZILL NAVEED
; MUTEEBA JAMAL
; KENZY HAMED
; 2024
msg:
        HEX 41 55 52 41 3A 54 48 45 20 57 49 5A 41 52 44 53 20 51 55 45 53 54 0D 53 48 41 48 5A 49 4C 4C 20 4E 41 56 45 45 44 0A 0D 4D 55 54 45 45 42 41 20 4A 41 4D 41 4C 0A 0D 4B 45 4E 5A 59 20 48 41 4D 45 44 0A 0D 32 30 32 34 0D 00

; these are the values for the hat characters that need to be stored in the screen memory
hatChar: 
        HEX 20 A6 0D 20 7A 20 A6 0D 20 A6 0D 20 7A 20 A6 0D 20 A6 0D 20 A6 0D 20 7A 20 A6 20 7A 0D 20 A6 0D 20 A6 20 7A 0D 20 76 0D 20 A6 0D 20 A6 20 7A 0D 20 50 52 45 53 20 41 20 54 4F 20 50 4C 41 59 00 

; this is the number of times the character in hatChar, at the same index, needs to be repeated on the screen
hatCharCount: 
        HEX 0A 01 01 02 01 06 03 01 08 05 01 04 01 02 07 01 06 09 01 06 09 01 02 01 02 0B 04 01 01 05 0B 01 05 0B 02 01 01 04 0D 01 03 0F 01 03 0F 02 01 02 03 01 01 01 02 01 01 01 01 01 01 01 01 01 01 01

; these are the coLor values for the titlescreen that need to be stored in the color memory
colorValues:
        HEX 00 04 07 04 07 04 07 04 07 04 07 04 07 00 FF

; this is the number of times the color in colorValues, at the same index, needs to be repeated in the color memory
countValues:
        HEX 8D 0F 07 27 02 3D 02 10 07 23 1D 27 01 29 FF 

CHAR:
        ;org CHAR_LOCATION
        dc.b %00011100
        dc.b %00011010
        dc.b %00111000
        dc.b %00111000
        dc.b %01111100
        dc.b %01111100
        dc.b %01111110
        dc.b %11111111

CHAR_RIGHT:
        ;org CHAR_RIGHT_LOCATION
        dc.b %00111000
        dc.b %01011000
        dc.b %00011100
        dc.b %00011100
        dc.b %00111100
        dc.b %00111110
        dc.b %01111110
        dc.b %11111111

NORMAL_PLATFORM:
        ;org NORAML_PLATFORM_LOCATION
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000

DANGER_PLATFORM:
        ;org DANGER_PLATFORM_LOCATION
        dc.b %00010000
        dc.b %00111000
        dc.b %00111000
        dc.b %01111100
        dc.b %01111100
        dc.b %11111111
        dc.b %11111111
        dc.b %00000000

BLANK_SPACE:
        ;org BLANK_SPACE_LOCATION
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000

GEM:
        ;org GEM_LOCATION
        dc.b %00001000
        dc.b %00011100
        dc.b %00111110
        dc.b %01111111
        dc.b %00111110
        dc.b %00011100
        dc.b %00001000
        dc.b %00000000

ZERO:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %01111110
        dc.b %01000010
        dc.b %01000010
        dc.b %01000010
        dc.b %01000010
        dc.b %01111110
        dc.b %00000000

ONE:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %00111000
        dc.b %01011000
        dc.b %00011000
        dc.b %00011000
        dc.b %00011000
        dc.b %01111110
        dc.b %00000000

TWO:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %01111100
        dc.b %01000010
        dc.b %00000100
        dc.b %00001000
        dc.b %00010000
        dc.b %01111110
        dc.b %00000000

THREE:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %01111100
        dc.b %01000010
        dc.b %00001100
        dc.b %00001100
        dc.b %01000010
        dc.b %01111100
        dc.b %00000000

DEAD_CHAR:
        ;org DEAD_CHAR_LOCATION
        dc.b %10000001
        dc.b %01000010
        dc.b %00100100
        dc.b %00011000
        dc.b %00011000
        dc.b %00100100
        dc.b %01000010
        dc.b %10000001

DOOR:
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111

DOOR_HANDLE:
        dc.b %10011111
        dc.b %10011111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111

CURRENT_NORMAL_ADDR:
    .word 0x0000   ; Reserve 2 bytes for storing a 16-bit address

CURRENT_COLOR_ADDR:
    .word 0x0000   ; Reserve 2 bytes for storing a 16-bit address

TEMP_ADDR:
    .byte 0x00     ; First byte of the 16-bit address
    .byte 0x00     ; Second byte of the 16-bit address

;--------------------------------------- LEVEL 1 DATA ---------------------------

; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM:
    .byte  $25, $1E, $07, $FF, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff


START_ADDRESS_DANGER_PLATFORM:
    .byte  $45, $1F, $03, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,$ff ,$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

SPAWN_ADDRESS:
    .byte $D5, $1F ; Low byte ($20), High byte ($1E)

GEM_ADDRESS:
        .byte $D1, $1F, $D0, $1F, $E0, $1F, $ff

DOOR_ADDRESS:
        .byte $CC, $1F, $ff

DOOR_COLOR_ADDRESS:
        .byte $CC, $97, $ff

DOOR_BOTTOM_ADDRESS:
        .byte $E2, $1F, $ff

DOOR_BOTTOM_COLOR_ADDRESS:
        .byte $E2, $97, $ff

;--------------------------------------- LEVEL 2 DATA ---------------------------

; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM_LVL_2:
    .byte $27, $1F, $09, $ff 


SPAWN_ADDRESS_LVL_2:
    .byte $20, $1E ; Low byte ($20), High byte ($1E)


GEM_ADDRESS_LVL_2:
        .byte $11, $1F, $D0, $1F, $E0, $1F, $ff

;--------------------------------------- LEVEL 3 DATA ---------------------------

; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM_LVL_3:
    .byte $37, $1E, $03, $ff 


SPAWN_ADDRESS_LVL_3:
    .byte $20, $1E ; Low byte ($20), High byte ($1E)

GEM_ADDRESS_LVL_3:
        .byte $11, $1F, $D0, $1F, $E0, $1F, $ff



START_ADDRESS_NORMAL_PLATFORM_TABLE:
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_2
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_3


SPAWN_ADDRESS_TABLE:
    .word SPAWN_ADDRESS_LVL_2
    .word SPAWN_ADDRESS_LVL_3




; our program starts here
start:
        JMP clear_screen         

clear_screen:
        LDA #$93
        JSR CHROUT
        JSR CLRCHN

; ----------------------------------- COPY CHAR DATA CODE -----------------------------------

        ldx #$00 
copy_char_data:
        lda CHAR,x              
        sta CHAR_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_char_data  
        ldx #$00

copy_char_right_data:
        lda CHAR_RIGHT,x              
        sta CHAR_RIGHT_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_char_right_data 
        ldx #$00

copy_normal_data:
        lda NORMAL_PLATFORM,x              
        sta NORAML_PLATFORM_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_normal_data 
        ldx #$00
        
copy_danger_data:
        lda DANGER_PLATFORM,x              
        sta DANGER_PLATFORM_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_danger_data
        ldx #$00

copy_blank_data:
        lda BLANK_SPACE,x              
        sta BLANK_SPACE_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_blank_data
        ldx #$00

copy_gem_data:
        lda GEM,x              
        sta GEM_LOCATION,x     
        inx                    
        cpx #8
        bne copy_gem_data
        ldx #$00

copy_zero_data:
        lda ZERO,x              
        sta ZERO_LOCATION,x     
        inx                    
        cpx #8
        bne copy_zero_data
        ldx #$00

copy_one_data:
        lda ONE,x              
        sta ONE_LOCATION,x     
        inx                    
        cpx #8
        bne copy_one_data
        ldx #$00

copy_two_data:
        lda TWO,x              
        sta TWO_LOCATION,x     
        inx                    
        cpx #8
        bne copy_two_data
        ldx #$00

copy_three_data:
        lda THREE,x              
        sta THREE_LOCATION,x     
        inx                    
        cpx #8
        bne copy_three_data
        ldx #$00

copy_dead_char_data:
        lda DEAD_CHAR,x              
        sta DEAD_CHAR_LOCATION,x     
        inx                    
        cpx #8
        bne copy_dead_char_data
        ldx #$00

copy_door_data:
        lda DOOR,x              
        sta DOOR_LOCATION,x     
        inx                    
        cpx #8
        bne copy_door_data
        ldx #$00

copy_door_handle_data:
        lda DOOR_HANDLE,x              
        sta DOOR_HANDLE_LOCATION,x     
        inx                    
        cpx #8
        bne copy_door_handle_data
        ldx #$00

; -----------------------------------  TITLE SCREEN CODE -----------------------------------

title_screen:
        LDX #0                          ; Initialize index to read msg    
        JMP print_section_one

print_section_one:
        LDA msg,X ;Load character
        BEQ reset_x 

        JSR print
        JMP print_section_one

reset_x:
        LDX #-1

increment_x:
        INX 

char_setup:
        LDA hatCharCount,X
        STA COUNT_FOR_LOOP

        LDY #0
        LDA hatChar,X

print_section_two:
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
        BEQ wait_for_input         ; Jump to infinite loop if done

        JMP color_loop       ; Continue processing colors

use_next_color_memory:
        ; Set USE_NEXT_COLOR_MEMORY to 1 to start using NEXT_COLOR_MEM
        LDA #01
        STA USE_NEXT_COLOR_MEMORY

        LDY #00

        JMP color_loop       ; Continue with the updated memory


; ----------------------------------- WAITING FOR A TO PLAY THE GAME -----------------------------------

wait_for_input:
        LDA #$01
        STA LEVEL_COUNTER

        JSR GETIN
        JSR title_sound

        CMP #'A
        BEQ start_level
        BNE wait_for_input



; ----------------------------------- SCREEN CLEAR AFTER INPUT ON TITLE SCREEN -----------------------------------

start_level:
        JSR sound_off

	lda #$93
	jsr CHROUT	                ; Clear the screen
        LDA #$ff                        ; Load low byte (0xF5)
        sta VIC_CHAR_REG 

        LDA #$05                        ; setting the gem counter to zero
	STA GEMS_COLLECTED

        LDA #$01
	STA SOUND_COUNTER
	LDA #$00                        ; Initialize LOOP_COUNT to 0
	STA SOUND_LOOP_COUNT

; --------------------------------------------- BORDER CODE ---------------------------------------------------
; TODO: some of the border code is repetitive. we can make this a subroutine. 
; Set up the top border                     ; Character to represent the border
        ldx #SCREEN_WIDTH               ; Number of characters to print
        ldy #0  
        lda #$DF 
        sta BORDER_CHAR,y 

draw_top_border:

    	lda BORDER_CHAR  
    	sta SCREEN_START,y              ; Store at the location
	lda #$00    	                ; Black color for the memory address
	sta COLOR_MEM,y
    	iny                             ; Increment Y to move to the next screen position
    	dex                             ; Decrement X (count down the number of characters)
    	bne draw_top_border             ; Check if the x is 0
	
;Draw the side borders
        ldx #SCREEN_HEIGHT-1            ; Number of visible rows (23 rows for VIC-20)
	lda #<SCREEN_START              ; Load the low byte of the screen start address
        sta SCREEN_POS_LO       
        lda #>SCREEN_START              ; Load the high byte of the screen start address
        sta SCREEN_POS_HI       
	lda #<COLOR_MEM               ; Load the low byte of the color start address
        sta COLOR_POS_LO        
        lda #>COLOR_MEM               ; Load the high byte of the color start address
        sta COLOR_POS_HI        
;Loop to draw the side borders
draw_side_borders:
    	
	lda BORDER_CHAR                        ; Character to represent the side border
	
    	; Draw the left border at the start of the row
	ldy #0
	sta (SCREEN_POS_LO),y           ; Store border character at the leftmost column
        lda #$00                     ; Set color to black
        sta (COLOR_POS_LO),y            ; Store color at the 

        lda BORDER_CHAR                        ; Character to represent the side border
    	
	; Draw the right border, offset by 21 visible columns 
        ldy #SCREEN_WIDTH-1             ; Set Y to 21 which is the last right column
        sta (SCREEN_POS_LO),y           ; Store border character 
        lda #$00                        ; Set color to black
        sta (COLOR_POS_LO),y            ; Store color 

    	; Increment the screen position by SCREEN_WIDTH so we can go to the next row
        clc                             ; Clear carry for addition
        lda SCREEN_POS_LO
        adc #SCREEN_WIDTH               ; Add SCREEN_WIDTH to the low byte
        sta SCREEN_POS_LO               ; Store back the result
        bcc skip_high_increment         ; If carry is clear, skip incrementing the high byte
        inc SCREEN_POS_HI               ; Otherwise, increment the high byte

skip_high_increment:
        ; Increment the color memory position as well
        clc                             ; Clear carry for addition
        lda COLOR_POS_LO
        adc #SCREEN_WIDTH               ; Add SCREEN_WIDTH to the low byte of color memory
        sta COLOR_POS_LO                ; Store back the result
        bcc skip_color_high_inc         ; If carry is clear, skip incrementing the high byte
        inc COLOR_POS_HI                ; Otherwise, increment the high byte of color memory

skip_color_high_inc:
        dex                             ; Decrement row counter
        bne draw_side_borders           ; Repeat the loop for each row

; Draw the bottom border
draw_bottom_border:
        lda BORDER_CHAR                        ; Character to represent the border
        ldx #SCREEN_WIDTH               ; Number of characters to print in the bottom row
        ldy #0                          ; Start from the leftmost column of the last row

draw_bottom_loop:
	lda BORDER_CHAR
        sta (SCREEN_POS_LO),y           ; Store the border character in each column
        lda #$00                       ; Set color to black
        sta (COLOR_POS_LO),y            ; Store color in the same column

        iny                             ; Increment Y to move to the next column
        dex                             ; Decrement the X counter
        bne draw_bottom_loop            ; Continue until X = 0`


; --------------------------------------------- PLATFORM PRINTING CODE ---------------------------------------------------
        ldx #$00
        ldy #$00

load_print_normal_platform:
        LDA START_ADDRESS_NORMAL_PLATFORM,x
        CMP #$FF                       ; FF indicates the end of the byte array
        BEQ goto_color_normal_platform  
        STA SCREEN_POS_LO               ; Load the low byte of the platform start address
        INX

        ; Load the high byte of the starting address
        LDA START_ADDRESS_NORMAL_PLATFORM,x    
        STA SCREEN_POS_HI  

        INX
        LDA START_ADDRESS_NORMAL_PLATFORM,x    
        STA COUNT_FOR_LOOP              ; Number of platforms to print
        INX
        
        JMP print_normal_platform

print_normal_platform:
        LDA #$01                        ; Set platform identifier (or color)
        JSR draw_platform               ; Call subroutine to draw the platform

        DEC COUNT_FOR_LOOP              ; Decrement COUNT_FOR_LOOP by 1
        BNE inc_screen_lo_then_draw_normal       ; If COUNT_FOR_LOOP is not zero, draw another platform

        JMP load_print_normal_platform 

inc_screen_lo_then_draw_normal:
        INC SCREEN_POS_LO
        JMP print_normal_platform

color_is_96:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_normal_platform    
        

goto_color_normal_platform:
        ldx #$00            

load_color_normal_platform:
        LDA START_ADDRESS_NORMAL_PLATFORM,x  
        CMP #$FF                        ; Check if we've reached the end of color data
        BEQ goto_print_danger_platform  ; Branch if at the end of color data
        
        STA COLOR_POS_LO                 ; Load the low byte of the color start address
        INX                              ; Move to the next byte in the array

        ; Load the high byte of the starting address
        LDA START_ADDRESS_NORMAL_PLATFORM,x    
        CMP #$1E
        BEQ color_is_96                ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI

continue_color_normal_platform:      
        INX
        LDA START_ADDRESS_NORMAL_PLATFORM,x    ; Number of platforms to color
        STA COLOR_FOR_LOOP
        INX
        
        JMP color_normal_platform

color_normal_platform:
        LDA #$03                         ; Load color value (modify as needed)
        JSR color_platform               ; Apply color to platform
        
        DEC COLOR_FOR_LOOP         ; Decrement the platform color counter
        BNE inc_color_lo_then_draw_normal        ; If not zero, continue coloring next platform
        
        JMP load_color_normal_platform   ; If zero, go back to load the next color start address

inc_color_lo_then_draw_normal:
        INC COLOR_POS_LO
        JMP color_normal_platform

; Set up for printing danger platforms
goto_print_danger_platform:
        LDX #$00                       ; Reset X index for the danger platform array

load_print_danger_platform:
        LDA START_ADDRESS_DANGER_PLATFORM,x   ; Load the starting address
        CMP #$FF                              ; Check for the end of the danger platform data
        BEQ goto_color_danger_platform        ; If end, go to color the danger platforms

        STA SCREEN_POS_LO                     ; Load the low byte of the platform start address
        INX                                   ; Increment to the high byte

        LDA START_ADDRESS_DANGER_PLATFORM,x   ; Load high byte of start address
        STA SCREEN_POS_HI                     ; Set high byte for screen position

        INX                                   ; Move to platform count
        LDA START_ADDRESS_DANGER_PLATFORM,x   ; Load platform count for danger platforms
        STA COUNT_FOR_LOOP                    ; Store the count for drawing platforms

        INX                                   ; Increment to next item
        JMP print_danger_platform       ; Jump to start drawing

print_danger_platform:
        LDA #$02                              ; Set platform identifier for "danger platform"
        JSR draw_platform                     ; Call subroutine to draw the danger platform

        DEC COUNT_FOR_LOOP                    ; Decrement the platform count
        BNE inc_screen_lo_then_draw_danger    ; If count is not zero, draw another platform

        JMP load_print_danger_platform             ; Load the next danger platform if available

inc_screen_lo_then_draw_danger:
        INC SCREEN_POS_LO                     ; Increment screen position low byte
        JMP print_danger_platform        ; Continue drawing danger platforms

color_is_96_danger:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_danger_platform   

; Set up for coloring danger platforms
goto_color_danger_platform:
        LDX #$00                              ; Reset X index for color data

load_color_danger_platform:
        LDA START_ADDRESS_DANGER_PLATFORM,x  ; Load low byte of color address
        CMP #$FF                                   ; Check for the end of color data
        BEQ goto_print_gem                         ; If end, move to next game element

        STA COLOR_POS_LO                            ; Store the low byte of color address
        INX                                        ; Move to the high byte

        LDA START_ADDRESS_DANGER_PLATFORM,x  ; Load high byte of color address
        CMP #$1E
        BEQ color_is_96_danger                ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI

continue_color_danger_platform:
        INX                                        ; Move to color count
        LDA START_ADDRESS_DANGER_PLATFORM,x  ; Load color count
        STA COLOR_FOR_LOOP                         ; Store the count for applying colors

        INX                                        ; Increment index
        JMP color_danger_platform_loop             ; Start applying color

color_danger_platform_loop:
        LDA #$03                                   ; Set color value for danger platforms (adjust as needed)
        JSR color_platform                         ; Apply color

        DEC COLOR_FOR_LOOP                         ; Decrement the color counter
        BNE inc_color_lo_then_draw_danger          ; If not zero, color the next platform

        JMP load_color_danger_platform             ; Load next color data if available

inc_color_lo_then_draw_danger:
        INC COLOR_POS_LO                           ; Increment color position low byte
        JMP color_danger_platform_loop             ; Continue coloring danger platforms


goto_print_gem:
        ldx #$00

print_gem:
        ; Load the starting address into A
        LDA GEM_ADDRESS,x 
        CMP #$FF       
        BEQ goto_color_gem  
        STA SCREEN_POS_LO        

        INX

        ; Load the high byte of the starting address
        LDA GEM_ADDRESS,x    
        STA SCREEN_POS_HI        

        LDA #$04
        jsr draw_platform

        INX
              
        JMP print_gem

color_is_96_gem:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_gem  

goto_color_gem:
        ldx #$00

color_gem:
        ; Load the starting address into A
        LDA GEM_ADDRESS,x 
        CMP #$FF 
        BEQ goto_print_door_top   
        STA COLOR_POS_LO       
        
        INX            
        
        ; Load the high byte of the starting address
        LDA GEM_ADDRESS,x
        CMP #$1E
        BEQ color_is_96_gem               ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI     

continue_color_gem:
        LDA #$07
        jsr color_platform

        INX

        jmp color_gem


goto_print_door_top:
        ldx #$00

print_door_top:
        ; Load the starting address into A
        LDA DOOR_ADDRESS,x 
        CMP #$FF       
        BEQ goto_color_door_top
        STA SCREEN_POS_LO        

        INX

        ; Load the high byte of the starting address
        LDA DOOR_ADDRESS,x    
        STA SCREEN_POS_HI        

        LDA #$0A
        jsr draw_platform

        INX
              
        JMP print_door_top

goto_color_door_top:
        ldx #$00

color_door_top:
        ; Load the starting address into A
        LDA DOOR_COLOR_ADDRESS,x 
        CMP #$FF 
        BEQ goto_print_door_bottom     
        STA COLOR_POS_LO       
        
        INX            
        
        ; Load the high byte of the starting address
        LDA DOOR_COLOR_ADDRESS,x    
        STA COLOR_POS_HI      
        
        LDA #$05
        jsr color_platform

        INX

        jmp color_door_top

goto_print_door_bottom:
        ldx #$00

print_door_bottom:
        ; Load the starting address into A
        LDA DOOR_BOTTOM_ADDRESS,x 
        CMP #$FF       
        BEQ goto_color_door_bottom
        STA SCREEN_POS_LO        

        INX

        ; Load the high byte of the starting address
        LDA DOOR_BOTTOM_ADDRESS,x    
        STA SCREEN_POS_HI        

        LDA #$0B
        jsr draw_platform

        INX
              
        JMP print_door_bottom

goto_color_door_bottom:
        ldx #$00

color_door_bottom:
        ; Load the starting address into A
        LDA DOOR_BOTTOM_COLOR_ADDRESS,x 
        CMP #$FF 
        BEQ char_screen     
        STA COLOR_POS_LO       
        
        INX            
        
        ; Load the high byte of the starting address
        LDA DOOR_BOTTOM_COLOR_ADDRESS,x    
        STA COLOR_POS_HI      
        
        LDA #$05
        jsr color_platform

        INX

        jmp color_door_bottom

; --------------------------------------------- GEM CODE ---------------------------------------------------

check_gem_left:
        CMP #$04
        BEQ increment_gem_counter_left
        RTS

check_gem_hi_increment_left:
        CMP #$04
        BEQ increment_gem_counter_hi_left
        RTS

increment_gem_counter_left:
        LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED

        ; TODO: playing the sound before the gem has been collected feels unnatural. we will need to refactor this code so the sound can be played after
        ;JSR sound_collect_gem 

	JMP continue_drawing_left
        
increment_gem_counter_hi_left:
	LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED
        ;JSR sound_collect_gem

	JMP inc_screen_hi_then_draw

check_gem_right:
        CMP #$04
        BEQ increment_gem_counter_right
        RTS

check_gem_hi_increment_right:
        CMP #$04
        BEQ increment_gem_counter_hi_right
        RTS

increment_gem_counter_right:
	LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED
       ; JSR sound_collect_gem

	JMP continue_drawing_right
        
increment_gem_counter_hi_right:
        ; TODO: instead of using this counter, we should load the value from GEMS_COLLECTED and increment that
	LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED

        ;JSR sound_collect_gem

	JMP dec_screen_hi_then_draw
; --------------------------------------------- SPAWNING CODE ---------------------------------------------------
; spawning code prints the character at the spawn location
color_is_96_spawn:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_spawn  
char_screen:
; point VIC to use custom character set
        LDA #$ff                  
        sta VIC_CHAR_REG 

        ldx #$00

        LDA SPAWN_ADDRESS,x 
        STA COLOR_POS_LO        

        INX     
        
        ; Load the high byte of the starting address
        LDA SPAWN_ADDRESS,x   
        CMP #$1E
        BEQ color_is_96_spawn               ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI  

continue_color_spawn:
        LDA #$00
        jsr color_platform
        ldx #$00

        ; Load the starting address into A
        LDA SPAWN_ADDRESS,x       
        STA SCREEN_POS_LO        
      
        INX

        ; Load the high byte of the starting address
        LDA SPAWN_ADDRESS,x    
        STA SCREEN_POS_HI        

        LDA #$00
        jsr draw_platform


      	LDA #$05
	STA GEMS_COLLECTED

        LDX #$00
        jmp loop

; --------------------------------------------- DOOR TO NEXT LEVEL CODE ---------------------------------------------------
return:
    RTS                 ; Early return if A is not zero

can_go_to_next_level:       
        cmp #$0B 
        BNE return
        
        LDA GEMS_COLLECTED
        
        ; have all 3 gems been collected?
        CMP #$08
        BEQ goto_load_new_level
        RTS

goto_load_new_level:
        jmp load_new_level
; --------------------------------------------- MOVE CODE ---------------------------------------------------

; this loop waits for the input from the 
loop:
        CLC
        jsr GETIN                    ; Get key input
        beq loop                     ; If no key, continue loop
        cmp #'J                     ; Check if 'J' was pressed (move left)
        beq moveleft
        cmp #'L                     ; Check if 'L' was pressed (move right)
        beq moveright
        cmp #'R                     ; Check if 'R' was pressed (reset the level)
        beq goto_start_level
        cmp #'M                     ; Check if 'J' was pressed (move left)
        ;beq goto_jumpright

        jmp loop                     ; Continue the loop if no recognized key

goto_start_level:
        jmp start_level

moveright:
        jsr draw_right
        jmp loop
        
moveleft:
        jsr draw_left
        jmp loop

draw_left:
        CLC
        ldy #$00

        lda SCREEN_POS_LO,y
        beq dec_hi_byte_dummy   ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        dec SCREEN_POS_LO
        jmp skip_decrement_screen_hi

dec_hi_byte_dummy:
        dec SCREEN_POS_HI      
        lda #$ff
        sta SCREEN_POS_LO 
        jmp decremented_screen_hi

decremented_screen_hi:
        ;Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y           ; Load value at new position
        JSR check_gem_hi_increment_left ; check if we have encountered a gem
        JSR can_go_to_next_level        ; check if we have encountered a door
        cmp #$03 
        beq inc_screen_hi_then_draw
        cmp #$20 
        beq inc_screen_hi_then_draw
        cmp #$02 
        beq inc_screen_hi_then_die

        inc SCREEN_POS_LO
        inc SCREEN_POS_HI

        jmp loop
        
inc_screen_hi_then_draw:
        inc SCREEN_POS_HI
        jmp continue_drawing_left

inc_screen_hi_then_die:
        inc SCREEN_POS_HI
        jmp char_died_horizontal

skip_decrement_screen_hi:
        ;Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
        
        JSR can_go_to_next_level ; check if we have encountered a door
        JSR check_gem_left
        cmp #$03 
        beq continue_drawing_left
        cmp #$20 
        beq continue_drawing_left
        cmp #$02 
        beq char_died_horizontal
        inc SCREEN_POS_LO
        
        jmp loop

goto_start_level_after_dying:
        JSR sound_dead
        ldy #$00
        jsr DelayLoop
        jmp start_level
        
continue_drawing_left:
        inc SCREEN_POS_LO
        lda #03 ; blank platform
        jsr draw_platform

        lda SCREEN_POS_LO,y
        beq dec_screen_hi_byte  ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        dec SCREEN_POS_LO
        jmp no_high_increment_left

color_char:
        LDA SCREEN_POS_LO
        STA COLOR_POS_LO
        
        ; Check the high byte of SCREEN_POS_HI to set COLOR_POS_HI accordingly
        LDA SCREEN_POS_HI         ; Load the high byte of the screen position
        CMP #$1E                   ; Compare with 1E
        BEQ set_color_hi_96        ; If equal, set COLOR_POS_HI to 96
        CMP #$1F                   ; Compare with 1F
        BEQ set_color_hi_97        ; If equal, set COLOR_POS_HI to 97

        JMP continue_color

continue_color:
        LDA SCREEN_POS_LO         ; Load the low byte of the screen position
        STA COLOR_POS_LO          ; Store the low byte in COLOR_POS_LO
        
        TYA                             
        TAX
        ldy #$00
        
        lda #00 ; blank platform
        jsr color_platform

        TXA
        CMP #$01       
        BEQ goto_start_level_after_dying
        jmp loop

char_died_horizontal:
        LDA #$09                    
        jsr draw_platform          
        ldy #01
        jmp color_char

incremented_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      
        JSR check_gem_right
        JSR can_go_to_next_level

        cmp #$03 
        beq dec_screen_hi_then_draw
        cmp #$20 
        beq dec_screen_hi_then_draw
        cmp #$02 
        beq dec_screen_hi_then_die

        dec SCREEN_POS_LO
        dec SCREEN_POS_HI
        
        jmp loop
        
dec_screen_hi_byte:
        dec SCREEN_POS_HI       
        lda #$ff
        sta SCREEN_POS_LO
        jmp no_high_increment_left

set_color_hi_96:
        LDA #$96                       
        STA COLOR_POS_HI                
        jmp continue_color              

set_color_hi_97:
        LDA #$97          
        STA COLOR_POS_HI                   
        jmp continue_color                        

draw_right:
        CLC
        ldy #$00

        inc SCREEN_POS_LO
        BNE skip_increment_screen_hi  
        INC SCREEN_POS_HI             
        jmp incremented_screen_hi

dec_screen_hi_then_draw:
        dec SCREEN_POS_HI
        jmp continue_drawing_right

dec_screen_hi_then_die:
        dec SCREEN_POS_HI       
        jmp char_died_horizontal

skip_increment_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      

        JSR check_gem_right
        JSR can_go_to_next_level
        
        cmp #$03 
        beq continue_drawing_right
        cmp #$20 
        beq continue_drawing_right
        cmp #$02 
        beq char_died_horizontal
        dec SCREEN_POS_LO
        
        jmp loop

continue_drawing_right:
        dec SCREEN_POS_LO
        
        lda #03
        jsr draw_platform
        inc SCREEN_POS_LO
        BNE no_high_increment_right  ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        ; If carry is set, increment the high byte
        INC SCREEN_POS_HI
        lda #12
        jsr draw_platform
        jmp color_right

color_right:
        LDA #$FF                  
        STA VIC_CHAR_REG          

        ; Check the high byte of SCREEN_POS_HI to set COLOR_POS_HI accordingly
        LDA SCREEN_POS_HI          ; Load the high byte of the screen position
        CMP #$1E                   ; Compare with 1E
        BEQ set_color_hi_96        ; If equal, set COLOR_POS_HI to 96
        CMP #$1F                   ; Compare with 1F
        BEQ set_color_hi_97        ; If equal, set COLOR_POS_HI to 97
        JMP continue_color

no_high_increment_right:
        jmp check_under_right

no_high_increment_left:
        jmp check_under_left

check_under_right:        
        LDA SCREEN_POS_LO         
        STA TEMP_SCREEN_POS_LO

        LDA SCREEN_POS_LO         ; Load the low byte into the accumulator
        CLC                        ; Clear carry for addition
        ADC #$16                   ; Add 0x16 (22 in decimal) to move one block down
        STA SCREEN_POS_LO          ; Update SCREEN_POS_LO to the new position

        BCC check_under_no_carry_right     ; Branch if there is no carry (no high byte increment)
        inc SCREEN_POS_HI
        jmp check_under_no_carry_right

check_under_no_carry_right:

        ldy #00
        ; Check if moving down is valid
        LDA (SCREEN_POS_LO),y ; Load the value at the new position
        CMP #02                     
        BEQ char_died           
        CMP #01                    
        BEQ cannot_move_down_right            
        CMP BORDER_CHAR                   
        BEQ cannot_move_down_right       

        inx

        ; Draw the character at the new position
        LDA #00   
        jsr draw_platform           
        jmp check_under_right

check_under_left:
        LDA #$ff                 
        sta VIC_CHAR_REG 
        
        LDA SCREEN_POS_LO         
        STA TEMP_SCREEN_POS_LO

        LDA SCREEN_POS_LO         
        CLC                         
        ADC #$16                   
        STA SCREEN_POS_LO          

        BCC check_under_no_carry_left    
        inc SCREEN_POS_HI
        jmp check_under_no_carry_left

check_under_no_carry_left:

        ldy #00
        ; Check if moving down is valid
        LDA (SCREEN_POS_LO),y ; Load the value at the new position
        CMP #02                     
        BEQ char_died      
        CMP #01                    
        BEQ cannot_move_down_left          
        CMP BORDER_CHAR                   
        BEQ cannot_move_down_left       

        inx

        ; Draw the character at the new position
        LDA #00   
        jsr draw_platform           
        jmp check_under_left


cannot_move_down_right:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO

        LDA #12                   
        jsr draw_platform          
       
        jmp color_char

cannot_move_down_left:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO

        LDA #00                  
        jsr draw_platform         
       
        jmp color_char

char_died:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO

        LDA #$09                    ; Load the character code for the blank platform
        jsr draw_platform          ; Draw the blank character at the reverted position
        
        ldy #01
        jmp color_char



; ---------------------------- SOUND EFFECTS ----------------------------
title_sound:
        ; TODO: this needs to be improved. this doesn't sound good so it's been commented out for now.
        ;LDA #$05        ; want to set volume to 5
        ;STA $900E       ; memory location for setting volumne

	;JSR e_note
        ;JSR delay_sound  
        ;JSR sound_off

	;JSR g_note
        ;JSR delay_sound  
        ;JSR sound_off

	;JSR d_note
        ;JSR delay_sound  
        ;JSR sound_off

        RTS

sound_dead:	
        LDA #$05 	; want to set volume to 5
        STA $900E	; memory location for setting volumne

	;LDA #'D
	;JSR CHROUT

	JSR c_note
   	
     	JSR d_note
	
	;JSR c_note
	
	;JSR d_note
	
	JMP sound_off

sound_collect_gem:
        ; TODO: this needs to be improved. this doesn't sound good so it's been commented out for now.

	LDA #$05
	STA $900E       ; memory location for setting volumne

	LDA #$D7       
        STA $900B 
	LDA #$EE       
        STA $900C      ; Store the value in memory address 36874 ($90B in hex)
        JSR delay_sound
        JSR delay_sound
	
	LDA #$00
        STA $900C
	STA $900B

        JMP sound_off

c_note:
	LDA #$87        
        STA $900A       ; Store the value in memory address 36874 ($90B in hex)
	JSR delay_sound
	
	LDA #$00
        STA $900A
	
	RTS

d_note:
	LDA #$93
        STA $900A
	JSR delay_sound

	LDA #$00
        STA $900A

	RTS

e_note:
        LDA #$9F      
        STA $900C
        JSR loop

        LDA #$00
        STA $900C

        RTS

g_note:
        LDA #$EB       ; Load the value 135 (87 in hex) into the A register
        STA $900C
        JSR loop

        LDA #$00
        STA $900C

        RTS

delay_sound:
 ; increment the counter
	LDA SOUND_COUNTER
        INC SOUND_COUNTER

        CMP #$02	
	BNE delay_sound

	LDA SOUND_LOOP_COUNT       ; Load LOOP_COUNT
	INC SOUND_LOOP_COUNT       ; Increment LOOP_COUNT
	
	CMP #$01             ; Compare LOOP_COUNT with 1
	BNE delay_sound        ; If LOOP_COUNT isn't 1, loop again

	RTS

sound_off:
	LDA #$00
        STA $900E
	
	RTS
; ---------------------------- DRAW AND COLOR CODE BEING USED AT A FEW PLACES ----------------------------

draw_platform:
        STA (SCREEN_POS_LO),y    
        rts

color_platform:
        STA (COLOR_POS_LO),y    
        rts

DelayLoop:
        LDX #$FF                  ; Set up outer loop counter
DelayLoopX:
        LDY #$FF                  ; Set up inner loop counter

DelayLoopY:
        DEY       
        NOP 
        NOP
        NOP
        NOP 
        NOP
        NOP  
        BNE DelayLoopY            ; If Y is not zero, branch back to DelayLoopY

        DEX 
        NOP 
        NOP
        NOP
        NOP 
        NOP
        NOP 

        BNE DelayLoopX            ; If X is not zero, branch back to DelayLoopX
        RTS

; ---------------------------------------- LOAD NEW LEVEL -------------------------
; this whole routine needs to be opimized. right now we have seperate methods for each level but in the future we should find a way to 
; call these setup levels using an offset

load_new_level:
    ldx #$00               ; Reset X register
    ;INC LEVEL_COUNTER       ; Increment the level counter
    LDA LEVEL_COUNTER
    CMP #$05                ; Check if we're beyond the last level
    BEQ goto_jmp_start_level    ; If so, go back to start
    JSR copy_level_data   ; Otherwise, copy level data
    JMP start_level         ; Continue to the start level

; Copy subroutine
copy_level_data:
    LDA LEVEL_COUNTER            ; Load the current level number (index for the table)
    TAY                          ; Store the level number in Y register for indexing

    ; Copy Normal Platform Data
    LDA START_ADDRESS_NORMAL_PLATFORM_TABLE,Y  ; Load base address of current level's normal platform data
    STA TEMP_ADDR               ; Store it in a temporary address (low byte)
    LDA START_ADDRESS_NORMAL_PLATFORM_TABLE+1,Y  ; Load the high byte of the address
    STA TEMP_ADDR+1             ; Store it in TEMP_ADDR+1 (high byte)

    ; Dereference TEMP_ADDR to get the start address
    LDA TEMP_ADDR               ; Load low byte of address from TEMP_ADDR
    STA CURRENT_NORMAL_ADDR     ; Store it in CURRENT_NORMAL_ADDR (low byte)
    LDA TEMP_ADDR+1             ; Load high byte of address from TEMP_ADDR+1
    STA CURRENT_NORMAL_ADDR+1   ; Store it in CURRENT_NORMAL_ADDR (high byte)

    ; Dereference TEMP_ADDR to get the start address
    LDA TEMP_ADDR               ; Load low byte of address from TEMP_ADDR
    STA CURRENT_COLOR_ADDR      ; Store it in CURRENT_COLOR_ADDR (low byte)
    LDA TEMP_ADDR+1             ; Load high byte of address from TEMP_ADDR+1
    STA CURRENT_COLOR_ADDR+1    ; Store it in CURRENT_COLOR_ADDR (high byte)

    ; Copy Normal Platform Data to the destination array
    LDX #0                       ; Start at the first byte of the destination array
copy_normal_loop:
        
    LDA CURRENT_NORMAL_ADDR,X    ; Load data from the current level's normal platform
    STA START_ADDRESS_NORMAL_PLATFORM,X  ; Store data in the destination array
                             ; Increment index
    LDA CURRENT_NORMAL_ADDR,X    ; Check if we've reached the end of the data (use FF as the end marker)
    CMP #$FF                     ; If it’s $FF, we're done
    BEQ finish_copy      ; Jump to color platform copy routine
        INX 

    JMP finish_copy       ; Otherwise, continue copying normal platform data

finish_copy:
    RTS                          ; Return from subroutine


goto_jmp_start_level:
    ldy #$00
    ldx #$00
    jsr DelayLoop
    jmp start_level
