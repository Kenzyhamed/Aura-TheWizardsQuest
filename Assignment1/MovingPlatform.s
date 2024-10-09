; in this test project we experimented with creating our moving platforms

	processor 6502
; Memory locations

CHROUT = $ffd2       		; KERNAL routine to output a character
PLATFORM_ADDRESS_1 = $1e32      ; Starting address for the platform    
COLOR_ADDRESS_1 = $9632		; Starting color address for the platform
	org $1001    		; Starting memory location

; BASIC stub
        dc.w nextstmt
        dc.w 10
        dc.b $9e, "4109", 0
nextstmt
        dc.w 0

START:
        lda #$93
        jsr CHROUT		; Clear the screen
MoveRight:                     
	ldx #00
	ldy #05			; Move 5 places to the right

RightLoop1:
	lda #$E5                        ; Load bigger but partial block character 
        sta PLATFORM_ADDRESS_1,x        ; Store in memory
        lda #$02                        ; Load color 
        sta COLOR_ADDRESS_1,x		; Store the color in memory		 
        ;jsr Delay
	inx				; Increment to go to the next block 
	lda #$A0                        ; Load the full block character 
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                        ; Load color again
        sta COLOR_ADDRESS_1,x
	inx
        lda #$A0                        ; Load block character again
        sta PLATFORM_ADDRESS_1,x           
        lda #$02                        ; Load color again
        sta COLOR_ADDRESS_1,x
	inx
	lda #$A0                        ; Load block character again
        sta PLATFORM_ADDRESS_1,x           
        lda #$02                        ; Load color again
        sta COLOR_ADDRESS_1,x
	inx
	lda #$65                        ; Load partial block character
        sta PLATFORM_ADDRESS_1,x           
        lda #$02                        ; Load color again
        sta COLOR_ADDRESS_1,x

	jsr FourDecrements		; Decrement four times to go to the first block
	jsr CallDelay			; Delay to mask the moving 

	lda #$E1                        ; Change the first partial block character to a smaller one
        sta PLATFORM_ADDRESS_1,x           
        lda #$02                        ; Load color again
        sta COLOR_ADDRESS_1,x
	jsr FourIncrements		; Increment four times to the the last block
	lda #$61                        ; Change the last partial block character to a bigger one
        sta PLATFORM_ADDRESS_1,x           
        lda #$02                        ; Load color again
        sta COLOR_ADDRESS_1,x
	
	jsr FourDecrements
	jsr CallDelay

	 
RightLoop2:
	

        lda #$20                       ; Clear the current position (space character)
        sta PLATFORM_ADDRESS_1,x           ; Clear block from current position
        sta COLOR_ADDRESS_1,x               ; 11111111111
	jsr FourIncrements
	lda #$A0                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x           ; Move block to new position
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x          ; 222222222222222222
        dex
	dex
	dex
	
        jsr CallDelay
        dey                            ; Decrease loop counter
        bne RightLoop1                  ; Repeat until moved 3 times
	jsr FourIncrements

MoveLeft:
        ldy #5
	
LeftLoop1:

        lda #$20                       ; Clear the current position (space character)
        sta PLATFORM_ADDRESS_1,x       ; Clear block from current position
        sta COLOR_ADDRESS_1,x          
        jsr FourDecrements
        lda #$A0                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x       
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x          
        inx
        inx
        inx

        jsr CallDelay

LeftLoop2:
        lda #$E7                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x
        dex
        lda #$A0                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x
        dex
        lda #$A0                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x
        dex
        lda #$A0                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x
        dex
        lda #$67                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x
        jsr FourIncrements        

        jsr CallDelay

	lda #$61                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x
        jsr FourDecrements
        lda #$E1                       ; Load block character again
        sta PLATFORM_ADDRESS_1,x        
        lda #$02                       ; Load color again
        sta COLOR_ADDRESS_1,x

        jsr FourIncrements
        jsr CallDelay

        dey                            ; Decrease loop counter
        bne LeftLoop1                  ; Repeat until moved 5 times
	jmp MoveRight                  ; Loop back to move
FourIncrements:
	inx
	inx
	inx
	inx
	rts

FourDecrements:
	dex
	dex
	dex
	dex
	rts

CallDelay:
	txa
        jsr Delay
        jsr Delay
        jsr Delay
        jsr Delay		; Small delay between moves
        tax
	rts
Delay:                          ; Delay routine for slowing down movement
        ldx #$FF
DelayLoop:
        dex
	nop
	nop
        nop
        nop
        nop
        nop
        nop
        nop
	nop
        nop
        nop
	nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        bne DelayLoop
        rts  