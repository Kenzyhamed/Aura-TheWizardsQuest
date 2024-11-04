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
GEM_LOCATION = $1C5A
VIC_CHAR_REG = $9005

GEM_ONE_SCREEN_LOCATION = $1E30
GEM_ONE_COLOR_LOCATION = $9630

COUNT_FOR_LOOP = $0003
COLOR_FOR_LOOP = $0004
COUNTER = $0005
USE_NEXT_COLOR_MEMORY =  $0006
GEM_COUNTER = $0007

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
        dc.b %00111100
        dc.b %01000010
        dc.b %10100101
        dc.b %10000001
        dc.b %10100101
        dc.b %10011001
        dc.b %01000010
        dc.b %00111100

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
        dc.b %11111111

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
        dc.b %00011000
        dc.b %00011000
        dc.b %00011000
        dc.b %11111111
        dc.b %11111111
        dc.b %00011000
        dc.b %00011000
        dc.b %00011000
       


; Define the starting address in an array
START_ADDRESS_NORMAL_PLATFORM:
    .byte $62, $1F, $63, $1F, $64, $1F, $46, $1E, $47, $1E, $48, $1E, $49, $1E, $85, $1E, $86, $1E, $87, $1E, $88, $1E, $8A, $1E, $8B, $1E, $8C, $1E, $8D, $1E, $8E, $1E, $ff  ; Low byte ($20), High byte ($1E)

; Define the starting address in an array
START_ADDRESS_COLOR_NORMAL_PLATFORM:
    .byte $62, $97, $63, $97, $64, $97, $46, $96, $47, $96, $48, $96, $49, $96, $85, $96, $86, $96, $87, $96, $88, $96, $8A, $96, $8B, $96, $8C, $96, $8D, $96, $8E, $96, $ff  ; Low byte ($20), High byte ($1E)

START_ADDRESS_DANGER_PLATFORM:
    .byte $40, $1F, $41, $1F, $42, $1F, $ff  ; Low byte ($20), High byte ($1E)

; Define the starting address in an array
START_ADDRESS_COLOR_DANGER_PLATFORM:
    .byte $40, $97, $41, $97, $42, $97, $ff  ; Low byte ($20), High byte ($1E)

SPAWN_ADDRESS:
    .byte $1C, $1E ; Low byte ($20), High byte ($1E)

; Define the starting address in an array
SPAWN_ADDRESS_COLOR:
    .byte $1C, $96 ; Low byte ($20), High byte ($1E)

GEM_ADDRESS:
        .byte $21, $1E, $ff

GEM_ADDRESS_COLOR:
        .byte $5A, $96

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
        
        LDA #$02
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
        BEQ char_screen     
        STA COLOR_POS_LO       
        
        INX            
        
        ; Load the high byte of the starting address
        LDA START_ADDRESS_COLOR_DANGER_PLATFORM,x    
        STA COLOR_POS_HI      
        
        LDA #$02
        jsr color_platform

        INX

        jmp color_danger_platform


; --------------------------------------------- GEM CODE ---------------------------------------------------
place_gems:
	LDA #$5A
	
	STA GEM_ONE_SCREEN_LOCATION
	;STA GEM_TWO_SCREEN_LOCATION
	;STA GEM_THREE_SCREEN_LOCATION
	
	LDA #$07

	STA GEM_ONE_COLOR_LOCATION
	;STA GEM_TWO_COLOR_LOCATION
	;STA GEM_THREE_COLOR_LOCATION

        RTS

check_gem:
        CMP #$5A
        BEQ collect_gem_one
        RTS

collect_gem_one:
	;has it been collected?
	;LDA GEM_ONE_SCREEN_LOCATION
	;CMP #$20

	;BEQ get_input

	LDA #$20
	STA GEM_ONE_SCREEN_LOCATION

	JMP increment_gem_counter

increment_gem_counter:
	INC GEM_COUNTER
	LDA GEM_COUNTER
	
	STA GEMS_COLLECTED

	RTS

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

        jsr place_gems  

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
        jmp loop                     ; Continue the loop if no recognized key

dec_screen_hi_byte:
        dec SCREEN_POS_HI       
        lda #$ff
        sta SCREEN_POS_LO
        jmp no_high_increment_left

        
moveleft:
        jsr draw_left
        jsr color_left
        jmp loop

draw_left:
        CLC
        ldy #$00

        lda SCREEN_POS_LO,y
        cmp #$00            ; Check if SCREEN_POS_LO has underflowed to $FF
        beq dec_hi_byte_dummy  ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        dec SCREEN_POS_LO
        jmp skip_decrement_screen_hi

decremented_screen_hi:
        ;Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
        cmp #$03 
        beq inc_screen_hi_then_draw
        cmp #$20 
        beq inc_screen_hi_then_draw

        inc SCREEN_POS_LO
        inc SCREEN_POS_HI

        jmp loop

inc_screen_hi_then_draw:
        inc SCREEN_POS_HI
        jmp continue_drawing_left

skip_decrement_screen_hi:
        ;Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
        cmp #$03 
        beq continue_drawing_left
        cmp #$20 
        beq continue_drawing_left
        inc SCREEN_POS_LO
        
        jmp loop


continue_drawing_left:
        inc SCREEN_POS_LO
        lda #03 ; blank platform
        jsr draw_platform

        lda SCREEN_POS_LO,y
        cmp #$00            ; Check if SCREEN_POS_LO has underflowed to $FF
        beq dec_screen_hi_byte  ; If SCREEN_POS_LO didn't overflow, skip high byte increment

        dec SCREEN_POS_LO
        jmp no_high_increment_left

color_left:
        LDA #$ff                  ; Load low byte (0xF5)
        sta VIC_CHAR_REG 
               
        LDA SCREEN_POS_LO
        STA COLOR_POS_LO
        

        lda #00 ; blank platform
        jsr color_platform
        jmp loop


dec_hi_byte_dummy:
        dec SCREEN_POS_HI      
        lda #$ff
        sta SCREEN_POS_LO 
        jmp decremented_screen_hi

moveright:
        jsr draw_right
        jsr color_right
        jmp loop

draw_right:
        CLC
        ldy #$00

        inc SCREEN_POS_LO
        BNE skip_increment_screen_hi  ; If no carry, skip increment
        INC SCREEN_POS_HI             ; Increment COLOR_POS_HI if carry is set
        jmp incremented_screen_hi

incremented_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
        cmp #$03 
        beq dec_screen_hi_then_draw
        cmp #$20 
        beq dec_screen_hi_then_draw

        dec SCREEN_POS_LO
        dec SCREEN_POS_HI
        
        jmp loop

dec_screen_hi_then_draw:
        dec SCREEN_POS_HI
        jmp continue_drawing_right

skip_increment_screen_hi:
        ; Load value at new position and compare with blank space
        lda (SCREEN_POS_LO),y      ; Load value at new position
        cmp #$03 
        beq continue_drawing_right
        cmp #$20 
        beq continue_drawing_right
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
        LDA #$ff                  ; Load low byte (0xF5)
        sta VIC_CHAR_REG 
               
        LDA SCREEN_POS_LO
        STA COLOR_POS_LO
        
        lda #00 ; blank platform
        jsr color_platform
        jmp loop

no_high_increment_right:
        ;LDA #$00
        ;jsr draw_platform
        ;jmp color_right
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

        ldy #00
        ; Check if moving down is valid
        LDA (SCREEN_POS_LO),y ; Load the value at the new position
        CMP #02                     ; Compare with 01
        BEQ cannot_move_down       ; If equal, can't move down
        CMP #01                    ; Compare with 01
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
       
        jmp color_left


; ---------------------------- DRAW AND COLOR CODE BEING USED AT A FEW PLACES ----------------------------

draw_platform:
        STA (SCREEN_POS_LO),y    
        rts

color_platform:
        STA (COLOR_POS_LO),y    
        rts

