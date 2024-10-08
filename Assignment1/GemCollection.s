; this test program is testing placing gems at certain memory locations and being able to
; collect them. when a number, 1, 2, or 3, is pressed, the corresponding gem is 
; "collected" and the counter in the top right of the screen is incremented. 
; we used a key press to simulate "collision".

   processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
GETIN = $FFE4      ; Address for GETIN
CLRCHN = $FFCC
SCREEN_MEM = $1E00

GEM_ONE_SCREEN_LOCATION = $1E1E 
GEM_ONE_COLOR_LOCATION = $961E

GEM_TWO_SCREEN_LOCATION = $1E78
GEM_TWO_COLOR_LOCATION = $9678

GEM_THREE_SCREEN_LOCATION = $1F0E
GEM_THREE_COLOR_LOCATION = $970E

GEMS_COLLECTED = $1E15

COLOR_MEM = $9600

        org $1001    ; Starting memory location

COUNTER = $1003

        include "stub.s"
msg:
        HEX 20 20 20 20 20 20 07 05 0D 13 20 03 0F 0C 0C 05 03 14 05 04 3A 30 00

; our program starts here
start:
	LDA #$93
        JSR CHROUT
        JSR CLRCHN
	
	LDA #$30
	STA COUNTER
	
	JSR counter_display
	JMP place_gems


counter_display: 
        LDX #0                ; Initialize index

print_char:
        LDA msg,X ;Load character

        CMP #$00 ;Is it 00
        BEQ return ;If yes move on to get input

        ;JSR CHROUT ;Print character
	STA SCREEN_MEM,X
	
	LDA #$00
	STA COLOR_MEM,X

        INX ;Increment index

        JMP print_char ;Repeat

return:
	RTS

place_gems:
	LDA #$5A
	
	STA GEM_ONE_SCREEN_LOCATION
	STA GEM_TWO_SCREEN_LOCATION
	STA GEM_THREE_SCREEN_LOCATION
	
	LDA #$07
	
	STA GEM_ONE_COLOR_LOCATION
	STA GEM_TWO_COLOR_LOCATION
	STA GEM_THREE_COLOR_LOCATION

	JMP get_input

get_input:
        JSR GETIN

        CMP #$00
        BEQ get_input
	
	CMP #$31
	BEQ collect_gem_one

	CMP #$32
        BEQ collect_gem_two

 	CMP #$33
        BEQ collect_gem_three

      	JMP get_input

collect_gem_one:
	;has it been collected?
	LDA GEM_ONE_SCREEN_LOCATION
	CMP #$20

	BEQ get_input

	LDA #$20
	STA GEM_ONE_SCREEN_LOCATION

	JMP increment_gem_counter

collect_gem_two:
        ;has it been collected?
        LDA GEM_TWO_SCREEN_LOCATION
        CMP #$20

        BEQ get_input

        LDA #$20
        STA GEM_TWO_SCREEN_LOCATION

        JMP increment_gem_counter

collect_gem_three:
        ;has it been collected?
        LDA GEM_THREE_SCREEN_LOCATION
        CMP #$20

        BEQ get_input

        LDA #$20
        STA GEM_THREE_SCREEN_LOCATION

        JMP increment_gem_counter

increment_gem_counter:
	INC COUNTER
	LDA COUNTER
	
	STA GEMS_COLLECTED

	JMP get_input
