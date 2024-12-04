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

BORDER_CHAR = 18
BORDER_COLOR = 4
HAT_COLOR = 0

DATA_START_LOCATION = $1C00

; addresses to store counts/variables
COUNT_FOR_LOOP = $0003
COLOR_FOR_LOOP = $0004
COUNTER = $0005
USE_NEXT_COLOR_MEMORY =  $0006
SOUND_COUNTER = $0008 
SOUND_LOOP_COUNT = $0009
LEVEL_COUNTER = $000A
DIRECTION = $000B

; this is a screen memory address to that the count shows on the screen 
GEMS_COLLECTED = $1E15

; screen memory variables
SCREEN_POS_LO   = $00   ; Low byte of screen memory address
SCREEN_POS_HI   = $01   ; High byte of screen memory address
COLOR_POS_LO    = $02   ; Low byte of color memory address
COLOR_POS_HI    = $03   ; High byte of color memory address
TEMP_SCREEN_POS_LO   = $04   ; Low byte of screen memory address
TEMP_SCREEN_POS_HI   = $05   ; High byte of screen memory address
ZP_SRC_ADDR_LO = $06  ; Zero-page address for low byte
ZP_SRC_ADDR_HI = $07  ; Zero-page address for high byte
PLATFORM_CHAR = $08 
PLATFORM_COLOR = $09
LOCATION_FOR_DATA_LOAD = $000C

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
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00100010
        dc.b %01110111
        dc.b %11111111
        dc.b %11111111
      ;  dc.b %00010000
       ; dc.b %00111000
        ;dc.b %00111000
        ;dc.b %01111100
        ;dc.b %01111100
        ;dc.b %11111111
        ;dc.b %11111111
        ;dc.b %00000000

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

HAT_FALLING_LEFT: 
        ; squish
        dc.b %00000000
        dc.b %00000000
        dc.b %00001110
        dc.b %00011000
        dc.b %00111000
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

HAT_FALLING_RIGHT:
       ; squish
        dc.b %00000000
        dc.b %00000000
        dc.b %01110000
        dc.b %00011000
        dc.b %00011100
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

HAT_FALLING:
        dc.b %10010001
        dc.b %10010001
        dc.b %10010001
        dc.b %00011000
        dc.b %00111000
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

FIRST_PORTAL:
        dc.b %00000000
        dc.b %00001000
        dc.b %00011100
        dc.b %00100010
        dc.b %01000001
        dc.b %01000010
        dc.b %00011100
        dc.b %00001000

SECOND_PORTAL:
        dc.b %00000000
        dc.b %00001000
        dc.b %00011100
        dc.b %00100010
        dc.b %01000001
        dc.b %01000010
        dc.b %00011100
        dc.b %00001000

BRICK:
        dc.b %11111101
        dc.b %11111101
        dc.b %01111000
        dc.b %00000000
        dc.b %11110111
        dc.b %11101111
        dc.b %00000111
        dc.b %01111000

        ; this one was rlly good
     ;   dc.b %11111001
     ;   dc.b %11111101
     ;   dc.b %11111000
     ;   dc.b %00000000
     ;   dc.b %11101111
     ;   dc.b %11101111
     ;   dc.b %00000000
     ;   dc.b %11111100 
       ; dc.b %00000010
       ; dc.b %00000010
       ; dc.b %00000010
       ; dc.b %11111111
       ; dc.b %00010000
       ; dc.b %00010000
       ; dc.b %11111111
       ; dc.b %00000010
       ; dc.b %11111110
        ;dc.b %00000001
        ;dc.b %00000001
        ;dc.b %11111110
        ;dc.b %01000000
        ;dc.b %10000000
        ;dc.b %01111111
        ;dc.b %10000000

       ; dc.b %01001001
       ; dc.b %01001001
       ; dc.b %11111111
       ; dc.b %10010010
       ; dc.b %10010010
       ; dc.b %11111111
       ; dc.b %00100100
       ; dc.b %00100100

;--------------------------------------- LEVEL 1 DATA ---------------------------

; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM_LVL_1:
    .byte  $44, $1E, $06, $FF

START_ADDRESS_DANGER_PLATFORM_LVL_1:
    .byte  $ff

SPAWN_ADDRESS_LVL_1:
    .byte $30, $1E ; Low byte ($20), High byte ($1E)

FIRST_PORTAL_LVL_1:
    .byte $fe ; Low byte ($20), High byte ($1E)

SECOND_PORTAL_LVL_1:
    .byte $fe ; Low byte ($20), High byte ($1E)

GEM_ADDRESS_LVL_1:
        .byte $1F, $1F, $CF, $1F, $D0, $1F, $ff

DOOR_TOP_ADDRESS:
        .byte $CC, $1F, $ff

DOOR_BOTTOM_ADDRESS:
        .byte $E2, $1F, $ff

;--------------------------------------- LEVEL 2 DATA ---------------------------

; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM_LVL_2:
    .byte $37, $1F, $04, $ff 

START_ADDRESS_DANGER_PLATFORM_LVL_2:
    .byte  $57, $1F, $04, $ff 


SPAWN_ADDRESS_LVL_2:
    .byte $20, $1E ; Low byte ($20), High byte ($1E)


GEM_ADDRESS_LVL_2:
        .byte $11, $1E, $D9, $1E, $D7, $1F, $ff

FIRST_PORTAL_LVL_2:
    .byte $2D, $1F ; Low byte ($20), High byte ($1E)

SECOND_PORTAL_LVL_2:
    .byte $D7, $1F ; Low byte ($20), High byte ($1E)

;--------------------------------------- LEVEL 3 DATA ---------------------------

; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM_LVL_3:
    .byte $47, $1E, $03, $ff 

START_ADDRESS_DANGER_PLATFORM_LVL_3:
    .byte  $67, $1E, $07, $87, $1F, $02, $ff 

SPAWN_ADDRESS_LVL_3:
    .byte $20, $1F ; Low byte ($20), High byte ($1E)

GEM_ADDRESS_LVL_3:
        .byte $11, $1E, $C0, $1F, $10, $1F, $ff


;--------------------------------------- LEVEL 4 DATA ---------------------------

; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM_LVL_4:
    .byte $17, $1E, $03, $ff 

START_ADDRESS_DANGER_PLATFORM_LVL_4:
    .byte  $67, $1F, $07, $87, $1F, $02, $ff 

SPAWN_ADDRESS_LVL_4:
    .byte $30, $1E ; Low byte ($20), High byte ($1E)

GEM_ADDRESS_LVL_4:
        .byte $11, $1F, $D0, $1F, $E0, $1F, $ff


START_ADDRESS_NORMAL_PLATFORM_TABLE:
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_1
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_2
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_3
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_4

START_ADDRESS_DANGER_PLATFORM_TABLE:
    .word START_ADDRESS_DANGER_PLATFORM_LVL_1
    .word START_ADDRESS_DANGER_PLATFORM_LVL_2
    .word START_ADDRESS_DANGER_PLATFORM_LVL_3
    .word START_ADDRESS_DANGER_PLATFORM_LVL_4

SPAWN_ADDRESS_TABLE:
    .word SPAWN_ADDRESS_LVL_1
    .word SPAWN_ADDRESS_LVL_2
    .word SPAWN_ADDRESS_LVL_3
    .word SPAWN_ADDRESS_LVL_4

GEM_ADDRESS_TABLE:
    .word GEM_ADDRESS_LVL_1
    .word GEM_ADDRESS_LVL_2
    .word GEM_ADDRESS_LVL_3
    .word GEM_ADDRESS_LVL_4

FIRST_PORTAL_TABLE:
    .word FIRST_PORTAL_LVL_1
    .word FIRST_PORTAL_LVL_2

SECOND_PORTAL_TABLE:
    .word SECOND_PORTAL_LVL_1
    .word SECOND_PORTAL_LVL_2

DOOR_TOP_TABLE:
    .word DOOR_TOP_ADDRESS

DOOR_BOTTOM_TABLE:
    .word DOOR_BOTTOM_ADDRESS


; these are the addresses for our custom character set
DATA_TABLE:
    .word CHAR  
    .word NORMAL_PLATFORM
    .word DANGER_PLATFORM
    .word BLANK_SPACE
    .word GEM
    .word ZERO
    .word ONE
    .word TWO
    .word THREE
    .word DEAD_CHAR
    .word DOOR
    .word DOOR_HANDLE
    .word CHAR_RIGHT
    .word HAT_FALLING_LEFT
    .word HAT_FALLING_RIGHT
    .word HAT_FALLING
    .word FIRST_PORTAL
    .word SECOND_PORTAL
    .word BRICK

; our program starts here
start:
        JMP clear_screen         

clear_screen:
        LDA #$93
        JSR CHROUT
        JSR CLRCHN

; ----------------------------------- COPY CHAR DATA CODE -----------------------------------
        ldx #$00 
        ldy #$00

character_load_setup:
        LDA DATA_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA DATA_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page

        cpx #152
        beq title_screen

        ldy #$00

copy_data:
        LDA (ZP_SRC_ADDR_LO),y
        STA DATA_START_LOCATION,x

        inx
        iny
        cpy #8

        bne copy_data

        ; divide X by 4 and store in the accumulator
        TXA                      ; Transfer X to A
        LSR                     ; Logical shift right (divide by 2)
        LSR                     ; Logical shift right again (divide by 2)
        ; A now contains X / 4

        tay 

        jmp character_load_setup


; -----------------------------------  TITLE SCREEN CODE -----------------------------------

title_screen:
        LDX #0  
        LDY #0                          ; Initialize index to read msg    
                                ; Initialize index to read msg    
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
        JSR title_sound

        LDA #$00
        STA LEVEL_COUNTER

        LDA #$01
        STA PLATFORM_CHAR

        LDA #$03
        STA PLATFORM_COLOR

        JSR GETIN

        CMP #'A
        BEQ start_level
        BNE wait_for_input



; ----------------------------------- SCREEN CLEAR AFTER INPUT ON TITLE SCREEN -----------------------------------

start_level:
        JSR volume_off

	lda #$93
	jsr CHROUT	                ; Clear the screen

        LDA #$05                        ; setting the gem counter to zero
	STA GEMS_COLLECTED

        LDA #$01
	STA SOUND_COUNTER
	LDA #$00                        ; Initialize LOOP_COUNT to 0
	STA SOUND_LOOP_COUNT

; --------------------------------------------- BORDER CODE ---------------------------------------------------
; TODO: some of the border code is repetitive. we can make this a subroutine. 
; Set up the top border                     ; Character to represent the border
        LDA #$ff                        ; Load low byte (0xF5)
        sta VIC_CHAR_REG 
        
        ldx #SCREEN_WIDTH               ; Number of characters to print
        ldy #0  

draw_top_border:
    	lda #BORDER_CHAR  
    	sta SCREEN_START,y              ; Store at the location
	lda #BORDER_COLOR    	                ; Black color for the memory address
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
    	
	lda #BORDER_CHAR                        ; Character to represent the side border
	
    	; Draw the left border at the start of the row
	ldy #0
	sta (SCREEN_POS_LO),y           ; Store border character at the leftmost column
        lda #BORDER_COLOR                     ; Set color to black
        sta (COLOR_POS_LO),y            ; Store color at the 

        lda #BORDER_CHAR                        ; Character to represent the side border
    	
	; Draw the right border, offset by 21 visible columns 
        ldy #SCREEN_WIDTH-1             ; Set Y to 21 which is the last right column
        sta (SCREEN_POS_LO),y           ; Store border character 
        lda #BORDER_COLOR                        ; Set color to black
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
        lda #BORDER_CHAR                        ; Character to represent the border
        ldx #SCREEN_WIDTH               ; Number of characters to print in the bottom row
        ldy #0                          ; Start from the leftmost column of the last row

draw_bottom_loop:
	lda #BORDER_CHAR
        sta (SCREEN_POS_LO),y           ; Store the border character in each column
        lda #BORDER_COLOR                    ; Set color to black
        sta (COLOR_POS_LO),y            ; Store color in the same column

        iny                             ; Increment Y to move to the next column
        dex                             ; Decrement the X counter
        bne draw_bottom_loop            ; Continue until X = 0`


; --------------------------------------------- PLATFORM PRINTING CODE ---------------------------------------------------

start_printing_platforms:
        ldx #$00
        LDA PLATFORM_CHAR
        CMP #$02
        BEQ load_danger_platform
        
load_normal_platform:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA START_ADDRESS_NORMAL_PLATFORM_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA START_ADDRESS_NORMAL_PLATFORM_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #$03
        STA PLATFORM_COLOR
        jmp load_print_platform

load_danger_platform:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA START_ADDRESS_DANGER_PLATFORM_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA START_ADDRESS_DANGER_PLATFORM_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #$02
        STA PLATFORM_COLOR
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

; Set up for printing danger platforms
goto_check_platform:
        LDA PLATFORM_CHAR
        CMP #$01
        BEQ jmp_to_start_printing_platforms_after_02
        CMP #$02
        BEQ goto_print_gem

jmp_to_start_printing_platforms_after_02:
        LDY #$00
        LDA #$02
        STA PLATFORM_CHAR
        jmp start_printing_platforms

        
goto_print_gem:
        ldx #$00
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA GEM_ADDRESS_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA GEM_ADDRESS_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page

        ldy #$00  

print_gem:
        ; Load the starting address into A
        LDA (ZP_SRC_ADDR_LO),y
        CMP #$FF       
        BEQ goto_color_gem  
        STA SCREEN_POS_LO        

        INY

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        STA SCREEN_POS_HI        

        TYA
        TAX
        LDY #$00
        LDA #$04                        ; Load color value (modify as needed)
        JSR draw_platform               ; Apply color to platform
        TXA
        TAY

        INY
              
        JMP print_gem

color_is_96_gem:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_gem  

goto_color_gem:
        ldy #$00

color_gem:
        ; Load the starting address into A
        LDA (ZP_SRC_ADDR_LO),y  
        CMP #$FF 
        BEQ spawn_portal_door   
        STA COLOR_POS_LO       
        
        INY            
        
        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y 
        CMP #$1E
        BEQ color_is_96_gem               ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI     

continue_color_gem:
        TYA
        TAX
        LDY #$00
        LDA #$07                        ; Load color value (modify as needed)
        JSR color_platform               ; Apply color to platform
        TXA
        TAY

        INY

        jmp color_gem


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
        JSR sound_collect_gem_with_delay 

	JMP continue_drawing_left
        
increment_gem_counter_hi_left:
	LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED
        JSR sound_collect_gem_with_delay

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
        JSR sound_collect_gem_with_delay

	JMP continue_drawing_right
        
increment_gem_counter_hi_right:
        ; TODO: instead of using this counter, we should load the value from GEMS_COLLECTED and increment that
	LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED

        JSR sound_collect_gem_with_delay

	JMP dec_screen_hi_then_draw
; --------------------------------------------- SPAWNING PORTAL DOOR CODE ---------------------------------------------------
spawn_portal_door:
        ldx #$00
        LDA PLATFORM_CHAR
        CMP #16
        BEQ goto_load_second_portal_spawn
        CMP #17
        BEQ load_door_top
        CMP #10
        BEQ load_door_bottom
        CMP #11
        BEQ load_spawn
        jsr load_first_portal
        jmp char_screen
        
jmp_spawn_portal_door:
        jmp spawn_portal_door
load_first_portal:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA FIRST_PORTAL_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA FIRST_PORTAL_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #$04
        STA PLATFORM_COLOR
        LDA #16
        STA PLATFORM_CHAR,y
        
        LDA (ZP_SRC_ADDR_LO),Y
        CMP #$FE
        BEQ jmp_spawn_portal_door
        rts

load_door_top:
        LDY #$00

      ; Load source address from table
        LDA DOOR_TOP_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA DOOR_TOP_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDA #$05
        STA PLATFORM_COLOR
        LDA #10
        STA PLATFORM_CHAR,y

        LDA (ZP_SRC_ADDR_LO),Y
        CMP #$FE
        BEQ jmp_spawn_portal_door
        jmp char_screen

load_door_bottom:
        LDY #$00

      ; Load source address from table
        LDA DOOR_BOTTOM_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA DOOR_BOTTOM_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDA #11
        STA PLATFORM_CHAR,y
        jmp char_screen

goto_load_second_portal_spawn:
        jsr load_second_portal
        jmp char_screen

load_second_portal:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA SECOND_PORTAL_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA SECOND_PORTAL_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #$06
        STA PLATFORM_COLOR
        LDA #17
        STA PLATFORM_CHAR
        rts

load_spawn:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA SPAWN_ADDRESS_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA SPAWN_ADDRESS_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #HAT_COLOR
        STA PLATFORM_COLOR
        LDA #$00
        STA PLATFORM_CHAR
        jmp char_screen

char_screen:
        LDA (ZP_SRC_ADDR_LO),y
        STA COLOR_POS_LO        

        INY    
        
        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y   
        CMP #$1E
        BEQ color_is_96_spawn               ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI  

continue_color_spawn:
        LDY #$00
        LDA PLATFORM_COLOR
        jsr color_platform
       
        ldy #$00

        ; Load the starting address into A
        LDA (ZP_SRC_ADDR_LO),y       
        STA SCREEN_POS_LO        
      
        INY

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        STA SCREEN_POS_HI        

        LDY #$00
        LDA PLATFORM_CHAR                       ; Set platform identifier (or color)
        JSR draw_platform               ; Call subroutine to draw the platform


        LDA PLATFORM_CHAR
        CMP #$00
        BNE goto_spawn_portal_door

      	LDA #$05
	STA GEMS_COLLECTED

        LDX #$00
        LDY #$00
        jmp loop
; spawning code prints the character at the spawn location
color_is_96_spawn:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_spawn 
goto_spawn_portal_door:
        jmp spawn_portal_door

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

        jmp loop                     ; Continue the loop if no recognized key

goto_start_level:
        jmp start_level

moveright:
        lda #$01
        sta DIRECTION
        jsr draw_right
        jmp loop
        
moveleft:
        lda #$00
        sta DIRECTION
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
        cmp #16 
        beq goto_inc_lo_then_first_portal_hit
        cmp #17
        beq goto_inc_lo_then_second_portal_hit

        inc SCREEN_POS_LO
        inc SCREEN_POS_HI

        jmp loop
        
inc_screen_hi_then_draw:
        inc SCREEN_POS_HI
        jmp continue_drawing_left

skip_decrement_screen_hi:
        ;Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
        
        JSR can_go_to_next_level ; check if we have encountered a door
        JSR check_gem_left
        cmp #$03 
        beq continue_drawing_left
        cmp #$20 
        beq continue_drawing_left       
        cmp #16 
        beq goto_inc_lo_then_first_portal_hit
        cmp #17
        beq goto_inc_lo_then_second_portal_hit

        inc SCREEN_POS_LO
        
        jmp loop

goto_inc_lo_then_first_portal_hit:
        inc SCREEN_POS_LO
        jmp first_portal_hit

goto_inc_lo_hi_then_first_portal_hit:
        inc SCREEN_POS_LO
        inc SCREEN_POS_HI
        jmp first_portal_hit

goto_inc_lo_then_second_portal_hit:
        inc SCREEN_POS_LO
        jmp second_portal_hit

goto_inc_lo_hi_then_second_portal_hit:
        inc SCREEN_POS_LO
        inc SCREEN_POS_HI
        jmp second_portal_hit  

continue_drawing_left:
        inc SCREEN_POS_LO
        lda #03 ; blank platform
        jsr draw_platform

        lda SCREEN_POS_LO,y
        beq dec_screen_hi_byte  ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        dec SCREEN_POS_LO
        jmp no_high_increment_left

incremented_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      
        JSR check_gem_right
        JSR can_go_to_next_level

        cmp #$03 
        beq dec_screen_hi_then_draw
        cmp #$20 
        beq dec_screen_hi_then_draw
        cmp #16 
        beq goto_dec_lo_hi_then_first_portal_hit
        cmp #17 
        beq goto_dec_lo_hi_then_second_portal_hit

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
        rts              

set_color_hi_97:
        LDA #$97          
        STA COLOR_POS_HI                   
        rts                      

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


skip_increment_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      

        JSR check_gem_right
        JSR can_go_to_next_level
        
        cmp #$03 
        beq continue_drawing_right
        cmp #$20 
        beq continue_drawing_right
        cmp #16 
        beq goto_dec_lo_then_first_portal_hit
        cmp #17
        beq goto_dec_lo_then_second_portal_hit

        dec SCREEN_POS_LO
        
        jmp loop

goto_dec_lo_then_first_portal_hit:
        dec SCREEN_POS_LO
        jmp first_portal_hit

goto_dec_lo_hi_then_first_portal_hit:
        dec SCREEN_POS_LO
        dec SCREEN_POS_HI
        jmp first_portal_hit

goto_dec_lo_then_second_portal_hit:
        dec SCREEN_POS_LO
        jmp second_portal_hit

goto_dec_lo_hi_then_second_portal_hit:
        dec SCREEN_POS_LO
        dec SCREEN_POS_HI
        jmp second_portal_hit

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

        ; Check the high byte of SCREEN_POS_HI to set COLOR_POS_HI accordingly
        LDA SCREEN_POS_HI          ; Load the high byte of the screen position
        CMP #$1E                   ; Compare with 1E
        BEQ set_color_hi_96        ; If equal, set COLOR_POS_HI to 96
        CMP #$1F                   ; Compare with 1F
        BEQ set_color_hi_97        ; If equal, set COLOR_POS_HI to 97

        lda #HAT_COLOR
        jsr color_platform

        JMP loop

no_high_increment_right:
        LDX #$00
        jmp check_under_right

no_high_increment_left:
        LDX #$00
        jmp check_under_left
        
check_under_right:        
        LDA SCREEN_POS_LO         
        STA TEMP_SCREEN_POS_LO

        LDA SCREEN_POS_LO         ; Load the low byte into the accumulator
        CLC                        ; Clear carry for addition
        ADC #$16                   ; Add 0x16 (22 in decimal) to move one block down
        STA SCREEN_POS_LO          ; Update SCREEN_POS_LO to the new position
        STA COLOR_POS_LO

        BCC check_under_no_carry_right     ; Branch if there is no carry (no high byte increment)
       
        inc SCREEN_POS_HI
        inc COLOR_POS_HI

        jmp check_under_no_carry_right

goto_increment_gem_then_continue_right_fall:
        LDA #15
        jsr draw_platform
        LDA #00
        jsr color_platform
        jsr sound_collect_gem
        TXA
        LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED  
        TAX
        jmp continue_check_under_no_carry_right

check_under_no_carry_right:
        jsr volume_off_all
        ldy #00
        ; Check if moving down is valid
        LDA (SCREEN_POS_LO),y ; Load the value at the new position
        CMP #02                     
        BEQ char_died           
        CMP #01                    
        BEQ cannot_move_down_right            
        CMP #BORDER_CHAR                   
        BEQ cannot_move_down_right       
        CMP #04
        BEQ goto_increment_gem_then_continue_right_fall
            

continue_check_under_no_carry_right:

        inx

        ; Draw the character at the new position
        jsr fall_animation
        
        jmp check_under_right

cannot_move_down_right:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO
        STA COLOR_POS_LO

        jmp bounce_animation

bounce_animation:
        jsr handle_load_bounce_hat 
        jsr draw_platform
        
        LDA #HAT_COLOR
        jsr color_platform

        jsr jiffy_delay_fast
        jsr jiffy_delay_fast

        jsr handle_load_hat
        jsr draw_platform 
        
        jmp loop

turn_sound_off:
        jsr volume_off_all

handle_load_bounce_hat:
        lda DIRECTION
        beq load_right_bounce

        ; load left bounce if not equal        
        lda #14
        rts

load_right_bounce:
        lda #13
        rts

handle_load_hat:
        lda DIRECTION
        beq load_right_hat
        
        ; load left hat if not equal
        lda #12
        rts

load_right_hat:
        lda #00
        rts

check_under_left:       
        LDA SCREEN_POS_LO         
        STA TEMP_SCREEN_POS_LO

        LDA SCREEN_POS_LO         
        CLC                         
        ADC #$16                   
        STA SCREEN_POS_LO          
        STA COLOR_POS_LO

        BCC check_under_no_carry_left    
        inc SCREEN_POS_HI
        inc COLOR_POS_HI
        jmp check_under_no_carry_left

char_died:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO
        STA COLOR_POS_LO    ; Store the result back into SCREEN_POS_LO

        LDA #$09                    ; Load the character code for the blank platform
        jsr draw_platform          ; Draw the blank character at the reverted position
        
        LDA #HAT_COLOR
        jsr color_platform          

        jmp goto_start_level_after_dying

goto_start_level_after_dying:
        JSR sound_dead
        ldy #$00
        jsr DelayLoop
        jmp start_level

goto_increment_gem_then_continue_left_fall:
        jsr sound_collect_gem
        TXA
        LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED  
        TAX
        jmp continue_check_under_no_carry_left

check_under_no_carry_left:
        jsr volume_off_all
        inx
        ldy #00
        ; Check if moving down is valid
        LDA (SCREEN_POS_LO),y ; Load the value at the new position
        CMP #02                     
        BEQ char_died      
        CMP #01                    
        BEQ cannot_move_down_left          
        CMP #BORDER_CHAR                   
        BEQ cannot_move_down_left  
        CMP #04
        BEQ goto_increment_gem_then_continue_left_fall

continue_check_under_no_carry_left:
        ; Draw the character at the new position
        jsr fall_animation
        jmp check_under_left

cannot_move_down_left:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO
        STA COLOR_POS_LO

        jmp bounce_animation

jiffy_delay_fast:
        TXA
        jsr DelayLoop2
        TAX
        rts
    ; Calculate target jiffy time
   ; LDA $A2            ; Low byte of current jiffy clock
   ; CLC
   ; ADC #$04           ; Add a small delay (2 jiffies)
   ; STA DELAY_LOW      ; Store target low byte
   ; LDA $A3            ; High byte of current jiffy clock
   ; ADC #$00           ; Carry over to high byte if necessary
   ; STA DELAY_HIGH     ; Store target high byte

.wait:
    ; Wait until the jiffy clock reaches or exceeds the target time
   ; LDA $A2            ; Current low byte
   ; CMP DELAY_LOW      ; Compare with target low byte
   ; LDA $A3            ; Current high byte
   ; SBC DELAY_HIGH     ; Subtract target high byte
   ; BCC .wait          ; If not reached, loop

    ;RTS

fall_animation:
        LDA #15
        jsr draw_platform
        
        LDA #HAT_COLOR
        jsr color_platform

        jsr jiffy_delay_fast

        LDA #03
        jsr draw_platform 

        LDA #HAT_COLOR
        jsr color_platform

        rts


first_portal_hit:
        LDA #$03
        jsr draw_platform

        jsr goto_load_second_portal
        ldx #$01
        jmp draw_char_after_portal_hit

second_portal_hit:
        LDA #$03
        jsr draw_platform
        jsr goto_load_first_portal
        ldx #$00
        jmp draw_char_after_portal_hit 

goto_load_second_portal:
        jmp load_second_portal

goto_load_first_portal:
        jmp load_first_portal

draw_char_after_portal_hit:

        LDA (ZP_SRC_ADDR_LO),y
        STA COLOR_POS_LO 
        CPX #$01
        BEQ goto_inc_color_pos
        CPX #$00
        BEQ check_direction_color

continue_portal_movement
        INY    
        
        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y   
        CMP #$1E
        BEQ color_is_96_portal               ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI  

continue_portal_movement_2:
        ldy #$00

        ; Load the starting address into A
        LDA (ZP_SRC_ADDR_LO),y       
        STA SCREEN_POS_LO        
        CPX #$01
        BEQ goto_inc_screen_pos
        CPX #$00
        BEQ check_direction_screen

continue_portal_movement_3:
        INY

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        STA SCREEN_POS_HI        

        LDX #$00
        LDY #$00
        jmp no_high_increment_right

; spawning code prints the character at the spawn location
color_is_96_portal:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_portal_movement_2

goto_inc_color_pos:
        inc COLOR_POS_LO
        jmp continue_portal_movement

goto_inc_screen_pos:
        inc SCREEN_POS_LO
        jmp continue_portal_movement_3

check_direction_color:
        LDA DIRECTION
        CMP #$00
        BEQ goto_dec_color_pos
        jmp goto_inc_color_pos
        jmp continue_portal_movement

goto_dec_color_pos:
        dec COLOR_POS_LO
        jmp continue_portal_movement

check_direction_screen:
        LDA DIRECTION
        CMP #$00
        BEQ goto_dec_screen_pos
        jmp goto_inc_screen_pos

goto_dec_screen_pos:
        dec SCREEN_POS_LO
        jmp continue_portal_movement_3


; ---------------------------- SOUND EFFECTS ----------------------------
title_sound:
	jsr set_volume

        jsr play_f_highest_octave
        jsr speakers_off

        jsr play_f_highest_octave
        JSR triple_delay_speakers_off

        jsr play_b_highest_octave
        jsr speakers_off

        jsr play_f_highest_octave
        JSR double_triple_delay
        jsr speakers_off

        jsr play_b_highest_octave
        JSR double_triple_delay
        JSR triple_delay_speakers_off

        jsr play_f_highest_octave
        JSR triple_delay_speakers_off

        jsr play_b_highest_octave
        jsr speakers_off

        JSR triple_delay

        RTS

sound_portal:
        jsr set_volume

        LDA #$F0       ; wb #241
        STA $900D      

        ; TODO: do we want to turn the sound off once weve travelled thru to the other side?
        jsr speakers_off
        jsr volume_off

	RTS


sound_dead:	
        jsr set_volume

	JSR play_c_note_low_octave
     	JSR play_d_note_low_octave
        JSR play_c_note_low_octave

        jsr volume_off
        RTS

sound_collect_gem:
        jsr set_volume
        ; Play C#
        LDA #241
        STA $900C

        rts

sound_collect_gem_with_delay:
        jsr sound_collect_gem
        jsr speakers_off
        jsr volume_off
        rts

play_f_highest_octave:
        LDA #163
        STA $900C       
        RTS

play_b_highest_octave:
        LDA #191
        STA $900C 
        RTS

play_c_note_low_octave:
	LDA #$87        
        STA $900A   

        JSR speakers_off
	RTS

; TODO: if we dont use this anywhere else then we can put it into the sound_dead method
play_d_note_low_octave:
	LDA #$93
        STA $900A
	JSR speakers_off
	RTS

set_volume:
        LDA #10
        STA $900E       
        RTS

triple_delay_speakers_off:
        JSR triple_delay
        jsr speakers_off
        rts

volume_off:
	LDA #$00
        STA $900E
	
	RTS

volume_off_all:
	jsr volume_off
        STA $900A
        STA $900C
        STA $900D

	RTS

speakers_off:
        JSR triple_delay

	LDA #$00
        STA $900A
        STA $900C
        STA $900D

        JSR triple_delay
	
	RTS
; ---------------------------- DRAW AND COLOR CODE BEING USED AT A FEW PLACES ----------------------------

draw_platform:
        STA (SCREEN_POS_LO),y    
        rts

color_platform:
        STA (COLOR_POS_LO),y    
        rts

triple_delay:
        JSR DelayLoop2
        JSR DelayLoop2
        JSR DelayLoop2
        RTS

double_triple_delay:
        JSR triple_delay
        JSR triple_delay
        RTS

DelayLoop:
        LDX #$FF                  ; Set up outer loop counter
        jmp DelayLoopX

DelayLoop2:
        LDX #$09                  ; Set up outer loop counter
        jmp DelayLoopX
             
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
    INC LEVEL_COUNTER       ; Increment the level counter
    INC LEVEL_COUNTER
    LDA #$01
    STA PLATFORM_CHAR
    jmp start_level
