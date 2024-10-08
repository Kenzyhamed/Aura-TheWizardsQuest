; in this test program we experiemented with creating the border for our game. 
; we stored the address of the graphic we want to use in the correct screen memory address

	processor 6502
; Memory locations

CHROUT = $ffd2       ; KERNAL routine to output a character
SCREEN_POS_LO   = $00   ; Low byte of screen memory address
SCREEN_POS_HI   = $01   ; High byte of screen memory address
COLOR_POS_LO    = $02   ; Low byte of color memory address
COLOR_POS_HI    = $03   ; High byte of color memory address
SCREEN_START = $1E00 	; Start of screen memory in VIC-20
SCREEN_WIDTH = 22       ; VIC-20 screen width (22 columns)
SCREEN_HEIGHT = 23      ; VIC-20 screen height (23 rows)
COLOR_START = $9600     ; Color memory start    
	org $1001    ; Starting memory location

; BASIC stub
        dc.w nextstmt
        dc.w 10
        dc.b $9e, "4109", 0
nextstmt
        dc.w 0

START:
	lda #$93
	jsr CHROUT	 ; Clear the screen
        

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
	
;Draw the side borders, taking into account 44 addresses per row
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

infinite_loop:
        jmp infinite_loop
