; in this program we experimented with different sound effects for our game

	processor 6502

CHROUT = $ffd2      
CLRCHN = $ffcc       
HOME = $ffba        
SCREEN_WIDTH =  2000    
GETIN = $FFE4


        org $1001    ; Starting memory location

        include "stub.s"

COUNTER = $1003  ; Reserve 1 byte of memory for a counter
LOOP_COUNT = $1004

msg:
	HEX 50 52 45 53 53 20 4B 45 59 20 46 4F 52 20 53 4F 55 4E 44 0D 0D 41 3A 20 44 45 41 54 48 20  20 0D 0A 42 3A 20 4A 55 4D 50 20  20 0D 0A 43 3A 20 50 4F 52 54 41 4C 20  20 0D 0A 44 3A 20 47 45 4D 20 43 4F 4C 4C 45 43 54 49 4F 4E 20  20 0D 00
;program starts here
start:
	LDA #$01
	STA COUNTER
	LDA #$00             ; Initialize LOOP_COUNT to 0
	STA LOOP_COUNT

	LDX #0                 ; Initialize index
        JSR clear_screen

	JSR print_intro_msg

clear_screen:
        LDA #$20               ; Load space character (ASCII 32)
        STA $1E00,X            ; Store at screen memory
        INX                    ; Increment index
        CPX SCREEN_WIDTH             ; Compare with total screen size (40 columns * 25 rows = $1C00)
        BNE clear_screen       ; Loop until the entire screen is cleared
        RTS

print_intro_msg:
        LDX #0                ; Initialize index

print_char:
        LDA msg,X ;Load character

        CMP #$00 ;Is it 00
        BEQ get_input ;If yes move on to get input

        JSR CHROUT ;Print character

        INX ;Increment index

        JMP print_char ;Repeat

get_input:
	JSR GETIN
        
	CMP #'A
	BEQ sound_dead
        
	CMP #'B	
	BEQ sound_jump
        
	CMP #'C 
        BEQ sound_portal

	CMP #'D
	BEQ sound_collect_gem

	JMP get_input	

loop:
 ; increment the counter
	LDA COUNTER
        INC COUNTER

        CMP #$02	
	BNE loop

	LDA LOOP_COUNT       ; Load LOOP_COUNT
	INC LOOP_COUNT       ; Increment LOOP_COUNT
	
	CMP #$01             ; Compare LOOP_COUNT with 1
	BNE loop        ; If LOOP_COUNT isn't 1, loop again

	RTS

sound_dead:	
        LDA #$05 	; want to set volume to 5
        STA $900E	; memory location for setting volumne

	;LDA #'D
	;JSR CHROUT

	JSR c_note
   	
     	JSR d_note
	
	JSR c_note
	
	JSR d_note
	;JSR d_note
	;JSR e_note
	
	JMP sound_off

sound_jump:
	LDA #$05        ; want to set volume to 5
        STA $900E       ; memory location for setting volumne

        ;LDA #'J
        ;JSR CHROUT

	JSR g_note
	JSR g_note 

        JMP sound_off


sound_portal:
	LDA #$05        ; want to set volume to 5
        STA $900E       ; memory location for setting volumne

        ;LDA #'P
        ;JSR CHROUT

        JSR white_noise
        JSR white_noise

        JMP sound_off

sound_collect_gem:
	LDA #$05
	STA $900E       ; memory location for setting volumne

        ;LDA #'G
        ;JSR CHROUT

	LDA #$D7       
        STA $900B 
	LDA #$EE       
        STA $900C      ; Store the value in memory address 36874 ($90B in hex)
        JSR loop
	JSR loop
	
;        JSR high_c_note

	
	LDA #$00
        STA $900C
	STA $900B

        JMP sound_off

white_noise:
	LDA #$F0       
        STA $900D      ; Store the value in memory address 36874 ($90B in hex)
        JSR loop

        LDA #$00
        STA $900D
	
	RTS
g_note:
        LDA #$EB       
        STA $900A       ; Store the value in memory address 36874 ($90B in hex)
        JSR loop

        LDA #$00
        STA $900A

        RTS

c_note:
	LDA #$87        
        STA $900A       ; Store the value in memory address 36874 ($90B in hex)
	JSR loop
	
	LDA #$00
        STA $900A
	
	RTS

d_note:
	LDA #$93
        STA $900A
	JSR loop

	LDA #$00
        STA $900A

	RTS

e_note:
        LDA #$9F      
        STA $900A      
	JSR loop

	LDA #$00
        STA $900A

        RTS

high_c_note:
        LDA #$F0      
        STA $900C
        JSR loop

        LDA #$00
        STA $900C

        RTS


sound_off:
	LDA #$00
        STA $900E
	
	JMP get_input
