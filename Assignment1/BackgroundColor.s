; in this test program we tested changing the background colour of the vic 20 

	processor 6502
; Memory locations

CHROUT = $ffd2       ; KERNAL routine to output a character
BACKGROUND_COLOR_ADDRESS = $900F    ; Backgrounf color address    
	org $1001    ; Starting memory location

; BASIC stub
        dc.w nextstmt
        dc.w 10
        dc.b $9e, "4109", 0
nextstmt
        dc.w 0

START:
	lda #$93
	jsr CHROUT	 		; Clear the screen
        
	
	lda #$00			; Load the color black
	sta BACKGROUND_COLOR_ADDRESS	; Store it in the memory

infinite_loop:
        jmp infinite_loop