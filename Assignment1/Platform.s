; in this test project we experimented with creating a basic platform on the screen

	processor 6502
; Memory locations

CHROUT = $ffd2       ; KERNAL routine to output a character
SCREEN_START = $1E00    ; Start of screen memory in VIC-20
SCREEN_WIDTH = 22       ; VIC-20 screen width (22 columns)
SCREEN_START_HI = $1E       ; High byte of screen memory start address ($1E00)
COLOR_START     = $9600     ; Start of color memory in VIC-20

TEMP_COLOR_LO = $02         ; Variable to hold the low byte of the color memory address
TEMP_COLOR_HI = $03         ; Variable to hold the high byte of the color memory address
TEMP_LO  = $00              ; Variable to hold the low byte of an address
TEMP_HI  = $01              ; Variable to hold the high byte of an address
PLATFORM_COLOR  = $02       ; Color code for the platform 
PLATFORM_CHAR = $A0     ; Character to represent the platform     
	org $1001    ; Starting memory location

; BASIC stub
        dc.w nextstmt
        dc.w 10
        dc.b $9e, "4109", 0
nextstmt
        dc.w 0

START:
	lda #$93
	jsr CHROUT	 	    ; Clear the screen
       	
	; Calculate the starting address for the middle row (Row 11)
    	lda #SCREEN_WIDTH          
    	clc
    	adc #SCREEN_WIDTH * 11 + 10 ; Add 11 rows * SCREEN_WIDTH to A + 10 columns
    	sta TEMP_LO                 ; Store the low byte of the screen address
    	lda #SCREEN_START_HI        ; Load the high byte of the screen memory start
    	adc #0                      
    	sta TEMP_HI                 ; Store the high byte of the screen address

    	; Calculate the starting address in color memory for row 11
    	lda #SCREEN_WIDTH           
    	clc
    	adc #SCREEN_WIDTH * 11 + 10 ; Add 11 rows * SCREEN_WIDTH to A + 10 columns
    	sta TEMP_COLOR_LO           ; Store the low byte of the color memory address
    	lda #$96                    ; High byte of color memory start
    	adc #0                      
    	sta TEMP_COLOR_HI           ; Store the high byte of the color memory address

    	ldx #4                      ; Platform length
    	
draw_platform:
    	lda #PLATFORM_CHAR     ; Load the platform character
    	sta (TEMP_LO),y        ; Store the platform character at calculated address
    	; Set the color for the platform character
    	lda #PLATFORM_COLOR         ; Load the color
    	sta (TEMP_COLOR_LO),y       ; Store the color in color memory 
	iny                    ; Move to the next column 
    	dex                    
    	bne draw_platform       ; Repeat until all blocks are drawn

infinite_loop:
        jmp infinite_loop