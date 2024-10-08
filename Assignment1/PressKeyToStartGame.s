; here we experimented with prassing "A" to start the game
; when you press "A" it clears the screen and displays a message
; we are expecting to load the level data when "A" is pressed

	processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
GETIN = $FFE4      ; Address for GETIN
CLRCHN = $ffcc
SETLFS = $ffba

SCREEN_WIDTH = 2000

        org $1001    ; Starting memory location

        include "stub.s"

        ; Define the string to print
msg:
	HEX 50 52 45 53 53 20 41 20 54 4F 20 53 54 41 52 54 0D 00

play_msg:
	HEX 48 45 4C 50 20 41 55 52 41 20 43 4F 4C 4C 45 43 54 20 41 4C 4C 20 54 48 45 20 47 45 4D 53 00

; our program starts here
start:
	LDX #0                 ; Initialize index
	JSR clear_screen
	JMP print_intro_msg

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
	BEQ wait_for_input ;If yes move on to get input

	JSR CHROUT ;Print character
	
	INX ;Increment index
	
	JMP print_char ;Repeat

wait_for_input:
        JSR GETIN

        CMP #'A
        BEQ start_game
        BNE wait_for_input

start_game:
	LDX #0                 ; Initialize index
        JSR clear_screen
	LDX #0                ; Initialize index

print_char_game:
        LDA play_msg,X ;Load character

        CMP #$00 ;Is it 00
        BEQ inf_loop ;If yes move on to get input

        JSR CHROUT ;Print character

        INX ;Increment index

        JMP print_char_game ;Repeat

inf_loop: 
	JMP inf_loop
