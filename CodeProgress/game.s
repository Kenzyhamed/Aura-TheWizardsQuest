; this is our title screen. we loaded the hex values to write all the required info
; (title, names, year) and draw a wizards hat. we are using the CHROUT routine to put these on the screen.
; we stored all the color data in another HEX variable.
; since the counter maxes out at 255 we have another color memory address variable that starts at 38400 + 255
; so we can starts from 0 again and continue updating the color memory

        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
CLRCHN = $ffcc
HOME = $ffba
GETIN = $FFE4      ; Address for GETIN

; Define boundaries for screen position high byte
SCREEN_MIN_HI = $1E   ; Starting high byte for display memory
SCREEN_MAX_HI = $1F   ; Adjust to fit your screen's high byte range

SCREEN_MEM = $1E00
COLOR_MEM = $9600
NEXT_COLOR_MEM = $96FF


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


VIC_CHAR_REG = $9005


COUNT_FOR_LOOP = $0003
COLOR_FOR_LOOP = $0004
COUNTER = $0005
USE_NEXT_COLOR_MEMORY =  $0006
GEM_COUNTER = $0007
SOUND_COUNTER = $0008 
SOUND_LOOP_COUNT = $0009

GEMS_COLLECTED = $1E15


SCREEN_POS_LO   = $00   ; Low byte of screen memory address
SCREEN_POS_HI   = $01   ; High byte of screen memory address
COLOR_POS_LO    = $02   ; Low byte of color memory address
COLOR_POS_HI    = $03   ; High byte of color memory address
TEMP_SCREEN_POS_LO   = $04   ; Low byte of screen memory address
TEMP_SCREEN_POS_HI   = $05   ; High byte of screen memory address

SCREEN_START = $1E00 	; Start of screen memory in VIC-20
SCREEN_WIDTH = 22       ; VIC-20 screen width (22 columns)
SCREEN_HEIGHT = 23      ; VIC-20 screen height (23 rows)
COLOR_START = $9600     ; Color memory start    

        org $1001    ; Starting memory location

        include "stub.s"

msg:
        HEX 41 55 52 41 3A 54 48 45 20 57 49 5A 41 52 44 53 20 51 55 45 53 54 0D 53 48 41 48 5A 49 4C 4C 20 4E 41 56 45 45 44 0A 0D 4D 55 54 45 45 42 41 20 4A 41 4D 41 4C 0A 0D 4B 45 4E 5A 59 20 48 41 4D 45 44 0A 0D 32 30 32 34 0D 00

hatChar: 
        HEX 20 A6 0D 20 7A 20 A6 0D 20 A6 0D 20 7A 20 A6 0D 20 A6 0D 20 A6 0D 20 7A 20 A6 20 7A 0D 20 A6 0D 20 A6 20 7A 0D 20 76 0D 20 A6 0D 20 A6 20 7A 0D 20 50 52 45 53 20 41 20 54 4F 20 50 4C 41 59 00 

hatCharCount: 
        HEX 0A 01 01 02 01 06 03 01 08 05 01 04 01 02 07 01 06 09 01 06 09 01 02 01 02 0B 04 01 01 05 0B 01 05 0B 02 01 01 04 0D 01 03 0F 01 03 0F 02 01 02 03 01 01 01 02 01 01 01 01 01 01 01 01 01 01 01

colorValues:
        HEX 00 04 07 04 07 04 07 04 07 04 07 04 07 00 FF

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



; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM:
    .byte  $63, $1F, $64, $1F, $65, $1F, $46, $1E, $47, $1E, $48, $1E, $49, $1E, $85, $1E, $86, $1E, $87, $1E, $88, $1E, $8A, $1E, $8B, $1E, $8C, $1E, $8D, $1E, $8E, $1E, $8F, $1E, $90, $1E, $91, $1E, $29, $1F, $2A, $1F, $2B, $1F, $2C, $1F, $2D, $1F, $2E, $1F, $ff  ; Low byte ($20), High byte ($1E)

; Define the starting address in an array
START_ADDRESS_COLOR_NORMAL_PLATFORM:
    .byte  $63, $97, $64, $97, $65, $97, $46, $96, $47, $96, $48, $96, $49, $96, $85, $96, $86, $96, $87, $96, $88, $96, $8A, $96, $8B, $96, $8C, $96, $8D, $96, $8E, $96, $8F, $96, $90, $96, $91, $96, $29, $97, $2A, $97, $2B, $97, $2C, $97, $2D, $97, $2E, $97, $ff  ; Low byte ($20), High byte ($1E)

START_ADDRESS_DANGER_PLATFORM:
    .byte $3D, $1F, $3E, $1F ,$45, $1F, $46, $1F, $47, $1F, $8B, $1E, $62, $1F, $ff  ; Low byte ($20), High byte ($1E)

; Define the starting address in an array
START_ADDRESS_COLOR_DANGER_PLATFORM:
    .byte $3D, $97, $3E, $97, $45, $97, $46, $97, $47, $97, $8B, $96, $62, $97, $ff  ; Low byte ($20), High byte ($1E)

; Define the starting address in an array
START_ADDRESS_GEM:
    .byte $30, $1E, $D0, $1F, $E0, $1F, $ff 

START_ADDRESS_COLOR_GEM:
    .byte $30, $96, $D0, $97, $E0, $97, $ff 

SPAWN_ADDRESS:
    .byte $31, $1E ; Low byte ($20), High byte ($1E)

; Define the starting address in an array
SPAWN_ADDRESS_COLOR:
    .byte $31, $96 ; Low byte ($20), High byte ($1E)

GEM_ADDRESS:
        .byte $33, $1E, $D0, $1F, $E0, $1F, $ff

GEM_ADDRESS_COLOR:
        .byte $33, $96, $D0, $97, $E0, $97, $ff

DOOR_ADDRESS:
        .byte $CC, $1F, $ff

DOOR_COLOR_ADDRESS:
        .byte $CC, $97, $ff

DOOR_BOTTOM_ADDRESS:
        .byte $E2, $1F, $ff

DOOR_BOTTOM_COLOR_ADDRESS:
        .byte $E2, $97, $ff

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
        LDX #0                ; Initialize index to read msg    
        JMP print_section_one

print_section_one:
        LDA msg,X ;Load character

        CMP #$00 ;Is it 00
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
        JSR GETIN

        CMP #'A
        BEQ start_level
        BNE wait_for_input



; ----------------------------------- SCREEN CLEAR AFTER INPUT ON TITLE SCREEN -----------------------------------

start_level:
	lda #$93
	jsr CHROUT	 ; Clear the screen
        LDA #$ff                  ; Load low byte (0xF5)
        sta VIC_CHAR_REG 

        LDA #$05                ; setting the gem counter to zero
	sta GEM_COUNTER
        lda GEM_COUNTER
	STA GEMS_COLLECTED

        LDA #$01
	STA SOUND_COUNTER
	LDA #$00             ; Initialize LOOP_COUNT to 0
	STA SOUND_LOOP_COUNT

; --------------------------------------------- BORDER CODE ---------------------------------------------------
        
; Set up the top border
        lda #$DF         ; Character to represent the border
        ldx #SCREEN_WIDTH  ; Number of characters to print
        ldy #0           ; Start at the first screen memory location

draw_top_border:

    	lda #$DF	
    	sta SCREEN_START,y    ; Store at the location
	lda #$00    	      ; Black color for the memory address
	sta COLOR_START,y
    	iny                   ; Increment Y to move to the next screen position
    	dex                   ; Decrement X (count down the number of characters)
    	bne draw_top_border    ; Check if the x is 0
	
;Draw the side borders
    	ldx #SCREEN_HEIGHT-1    ; Number of visible rows (23 rows for VIC-20)
	lda #<SCREEN_START      ; Load the low byte of the screen start address
        sta SCREEN_POS_LO       
        lda #>SCREEN_START      ; Load the high byte of the screen start address
        sta SCREEN_POS_HI       
	lda #<COLOR_START       ; Load the low byte of the color start address
        sta COLOR_POS_LO        
        lda #>COLOR_START       ; Load the high byte of the color start address
        sta COLOR_POS_HI        
;Loop to draw the side borders
draw_side_borders:
    	
	lda #$DF                ; Character to represent the side border
	
    	; Draw the left border at the start of the row
	ldy #0
	sta (SCREEN_POS_LO),y   ; Store border character at the leftmost column
        lda #$00                ; Set color to black
        sta (COLOR_POS_LO),y    ; Store color at the 

        lda #$DF                ; Character to represent the side border
    	
	; Draw the right border, offset by 21 visible columns 
        ldy #SCREEN_WIDTH-1     ; Set Y to 21 which is the last right column
        sta (SCREEN_POS_LO),y   ; Store border character 
        lda #$00                ; Set color to black
        sta (COLOR_POS_LO),y    ; Store color 

    	; Increment the screen position by SCREEN_WIDTH so we can go to the next row
        clc                      ; Clear carry for addition
        lda SCREEN_POS_LO
        adc #SCREEN_WIDTH        ; Add SCREEN_WIDTH to the low byte
        sta SCREEN_POS_LO        ; Store back the result
        bcc skip_high_increment  ; If carry is clear, skip incrementing the high byte
        inc SCREEN_POS_HI        ; Otherwise, increment the high byte

skip_high_increment:
        ; Increment the color memory position as well
        clc                      ; Clear carry for addition
        lda COLOR_POS_LO
        adc #SCREEN_WIDTH        ; Add SCREEN_WIDTH to the low byte of color memory
        sta COLOR_POS_LO         ; Store back the result
        bcc skip_color_high_inc  ; If carry is clear, skip incrementing the high byte
        inc COLOR_POS_HI         ; Otherwise, increment the high byte of color memory

skip_color_high_inc:
        dex                      ; Decrement row counter
        bne draw_side_borders    ; Repeat the loop for each row

; Draw the bottom border
draw_bottom_border:
        lda #$DF                ; Character to represent the border
        ldx #SCREEN_WIDTH       ; Number of characters to print in the bottom row
        ldy #0                  ; Start from the leftmost column of the last row

draw_bottom_loop:
	lda #$DF
        sta (SCREEN_POS_LO),y   ; Store the border character in each column
        lda #$00                ; Set color to black
        sta (COLOR_POS_LO),y    ; Store color in the same column

        iny                     ; Increment Y to move to the next column
        dex                     ; Decrement the X counter
        bne draw_bottom_loop    ; Continue until X = 0`


; --------------------------------------------- PLATFORM PRINTING CODE ---------------------------------------------------

        ldx #$00
        ldy #$00

print_normal_platform:
        ; Load the starting address into A
        LDA START_ADDRESS_NORMAL_PLATFORM,x 
        CMP #$FF    
        BEQ goto_color_normal_platform  
        STA SCREEN_POS_LO        

        INX

        ; Load the high byte of the starting address
        LDA START_ADDRESS_NORMAL_PLATFORM,x    
        STA SCREEN_POS_HI        

        LDA #$01
        jsr draw_platform

        INX
              
        JMP print_normal_platform

goto_color_normal_platform:
        ldx #$00

color_normal_platform:
        ; Load the starting address into A
        LDA START_ADDRESS_COLOR_NORMAL_PLATFORM,x  
        CMP #$FF       
        BEQ goto_print_danger_platform   
        STA COLOR_POS_LO       
        
        INX            
        
        ; Load the high byte of the starting address
        LDA START_ADDRESS_COLOR_NORMAL_PLATFORM,x    
        STA COLOR_POS_HI      
        
        LDA #$06
        jsr color_platform

        INX

        jmp color_normal_platform

goto_print_danger_platform:
        ldx #$00

print_danger_platform:
        ; Load the starting address into A
        LDA START_ADDRESS_DANGER_PLATFORM,x 
        CMP #$FF       
        BEQ goto_color_danger_platform  
        STA SCREEN_POS_LO        

        INX

        ; Load the high byte of the starting address
        LDA START_ADDRESS_DANGER_PLATFORM,x    
        STA SCREEN_POS_HI        

        LDA #$02
        jsr draw_platform

        INX
              
        JMP print_danger_platform

goto_color_danger_platform:
        ldx #$00

color_danger_platform:
        ; Load the starting address into A
        LDA START_ADDRESS_COLOR_DANGER_PLATFORM,x 
        CMP #$FF 
        BEQ goto_print_gem     
        STA COLOR_POS_LO       
        
        INX            
        
        ; Load the high byte of the starting address
        LDA START_ADDRESS_COLOR_DANGER_PLATFORM,x    
        STA COLOR_POS_HI      
        
        LDA #$02
        jsr color_platform

        INX

        jmp color_danger_platform

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

goto_color_gem:
        ldx #$00

color_gem:
        ; Load the starting address into A
        LDA GEM_ADDRESS_COLOR,x 
        CMP #$FF 
        BEQ goto_print_door_top   
        STA COLOR_POS_LO       
        
        INX            
        
        ; Load the high byte of the starting address
        LDA GEM_ADDRESS_COLOR,x    
        STA COLOR_POS_HI      
        
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
	INC GEM_COUNTER
	LDA GEM_COUNTER
	
	STA GEMS_COLLECTED

	JMP continue_drawing_left
        
increment_gem_counter_hi_left:
	INC GEM_COUNTER
	LDA GEM_COUNTER
	
	STA GEMS_COLLECTED

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
	INC GEM_COUNTER
	LDA GEM_COUNTER
	
	STA GEMS_COLLECTED

	JMP continue_drawing_right
        
increment_gem_counter_hi_right:
        ; TODO: instead of using this counter, we should load the value from GEMS_COLLECTED and increment that
	INC GEM_COUNTER 
	LDA GEM_COUNTER
	
	STA GEMS_COLLECTED

	JMP dec_screen_hi_then_draw
; --------------------------------------------- SPAWNING CODE ---------------------------------------------------
        
char_screen:
; point VIC to use custom character set
        LDA #$ff                  ; Load low byte (0xF5)
        sta VIC_CHAR_REG 

        ldx #$00

        LDA SPAWN_ADDRESS_COLOR,x 
        STA COLOR_POS_LO        

        INX     
        
        ; Load the high byte of the starting address
        LDA SPAWN_ADDRESS_COLOR,x   
        STA COLOR_POS_HI      

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
	sta GEM_COUNTER
        lda GEM_COUNTER
	STA GEMS_COLLECTED

        LDX #$00
        jmp loop

; --------------------------------------------- DOOR TO NEXT LEVEL CODE ---------------------------------------------------
return:
    RTS                 ; Early return if A is not zero

load_new_level:
        ; TODO: replace this with the code to load the next level. this is for proof of concept.
        JMP start_level

can_go_to_next_level:       
        cmp #$0B 
        BNE return
        
        LDA GEMS_COLLECTED
        
        ; have all 3 gems been collected?
        CMP #$08
        BEQ load_new_level
        RTS
; --------------------------------------------- MOVE CODE ---------------------------------------------------

loop:
        CLC
        jsr GETIN                    ; Get key input
        cmp #$00                     ; Check if no key was pressed
        beq loop                     ; If no key, continue loop
        cmp #'J                     ; Check if 'J' was pressed (move left)
        beq moveleft
        cmp #'L                     ; Check if 'L' was pressed (move right)
        beq moveright
        cmp #'R                     ; Check if 'L' was pressed (move right)
        jmp start_level
        jmp loop                     ; Continue the loop if no recognized key

moveright:
        jsr draw_right
        jsr color_char
        jmp loop
        
moveleft:
        jsr draw_left
        jsr color_char
        jmp loop

draw_left:
        CLC
        ldy #$00

        lda SCREEN_POS_LO,y
        cmp #$00            ; Check if SCREEN_POS_LO has underflowed to $FF
        beq dec_hi_byte_dummy  ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        dec SCREEN_POS_LO
        jmp skip_decrement_screen_hi

dec_hi_byte_dummy:
        dec SCREEN_POS_HI      
        lda #$ff
        sta SCREEN_POS_LO 
        jmp decremented_screen_hi

decremented_screen_hi:
        ;Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
        JSR check_gem_hi_increment_left ; check if we have encountered a gem
        JSR can_go_to_next_level ; check if we have encountered a door
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

goto_start_level:
        ldy #$00
        jsr DelayLoop
        jmp start_level
        
continue_drawing_left:
        inc SCREEN_POS_LO
        lda #03 ; blank platform
        jsr draw_platform

        lda SCREEN_POS_LO,y
        cmp #$00            ; Check if SCREEN_POS_LO has underflowed to $FF
        beq dec_screen_hi_byte  ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        dec SCREEN_POS_LO
        jmp no_high_increment_left

color_char:
        LDA #$ff                  ; Load low byte (0xF5)
        sta VIC_CHAR_REG 
               
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
        
        TYA            ; Transfer Y to A
        TAX
        ldy #$00
        
        lda #00 ; blank platform
        jsr color_platform

        TXA
        CMP #$01       ; Compare A with $02
        BEQ goto_start_level
        jmp loop

char_died_horizontal:
        LDA #$09                    ; Load the character code for the blank platform
        jsr draw_platform          ; Draw the blank character at the reverted position
        ldy #01
        jmp color_char

incremented_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
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
        LDA #$96          ; Store it in COLOR_POS_HI
        STA COLOR_POS_HI                   ; Compare with 1E
        jmp continue_color                        ; Return from the subroutine

set_color_hi_97:
        LDA #$97          ; Store it in COLOR_POS_HI
        STA COLOR_POS_HI                   ; Compare with 1E
        jmp continue_color                        ; Return from the subroutine

draw_right:
        CLC
        ldy #$00

        inc SCREEN_POS_LO
        BNE skip_increment_screen_hi  ; If no carry, skip increment
        INC SCREEN_POS_HI             ; Increment COLOR_POS_HI if carry is set
        jmp incremented_screen_hi

dec_screen_hi_then_draw:
        dec SCREEN_POS_HI
        jmp continue_drawing_right

dec_screen_hi_then_die:
        dec SCREEN_POS_HI       
        jmp char_died_horizontal

skip_increment_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position

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
        lda #00
        jsr draw_platform
        jmp color_right

color_right:
        LDA #$FF                  ; Load low byte (e.g., character code for a specific color)
        STA VIC_CHAR_REG          ; Store in the VIC character register

        ; Check the high byte of SCREEN_POS_HI to set COLOR_POS_HI accordingly
        LDA SCREEN_POS_HI         ; Load the high byte of the screen position
        CMP #$1E                   ; Compare with 1E
        BEQ set_color_hi_96        ; If equal, set COLOR_POS_HI to 96
        CMP #$1F                   ; Compare with 1F
        BEQ set_color_hi_97        ; If equal, set COLOR_POS_HI to 97
        JMP continue_color

no_high_increment_right:
        jmp check_under

no_high_increment_left:
        jmp check_under

check_under:
        LDA #$ff                  ; Load low byte (0xF5)
        sta VIC_CHAR_REG 
        
        LDA SCREEN_POS_LO         ; Load the low byte into the accumulator
        STA TEMP_SCREEN_POS_LO

        LDA SCREEN_POS_LO         ; Load the low byte into the accumulator
        CLC                         ; Clear carry for addition
        ADC #$16                   ; Add 0x16 (22 in decimal) to move one block down
        STA SCREEN_POS_LO          ; Update SCREEN_POS_LO to the new position

        BCC check_under_no_carry     ; Branch if there is no carry (no high byte increment)
        inc SCREEN_POS_HI
        jmp check_under_no_carry

check_under_no_carry:

        ldy #00
        ; Check if moving down is valid
        LDA (SCREEN_POS_LO),y ; Load the value at the new position
        CMP #02                     ; Compare with 01
        BEQ char_died       ; If equal, can't move down
        CMP #01                    ; Compare with 01
        BEQ cannot_move_down       ; If equal, can't move down     
        CMP #$DF                    ; Compare with 01
        BEQ cannot_move_down       ; If equal, can't move down

        inx

        ; Draw the character at the new position
        LDA #00   ; Load the character code to be drawn
        jsr draw_platform           ; Draw the character at the new position
        jmp check_under


cannot_move_down:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO

        LDA #00                    ; Load the character code for the blank platform
        jsr draw_platform          ; Draw the blank character at the reverted position
       
        jmp color_char

char_died:
        SEC                  ; Set the carry to prepare for subtraction
        LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
        SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
        STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO

        JSR sound_dead

        LDA #$09                    ; Load the character code for the blank platform
        jsr draw_platform          ; Draw the blank character at the reverted position
        ldy #01
        jmp color_char



; ---------------------------- SOUND EFFECTS ----------------------------

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
