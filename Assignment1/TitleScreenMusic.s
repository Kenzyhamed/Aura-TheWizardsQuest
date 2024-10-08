; in this program we experimented with title screen music
; it was tricky trying to figure our which notes to use to 
; play a nice tune

        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
GETIN = $FFE4      ; Address for GETIN

        org $1001    ; Starting memory location

        include "stub.s"
COUNTER = $1003  ; Reserve 1 byte of memory for a counter
LOOP_COUNT = $1004
SCREEN_WIDTH =  2000

msg:
	HEX 54 49 54 4C 45 20 53 43 52 45 45 4E 20 4D 55 53 49 43 0D 28 50 4C 45 41 53 45 20 55 4E 4D 55 54 45 29 00

; our program starts here
start:
  	LDA #$05
        STA $900E

	LDX #0                 ; Initialize index
        JSR clear_screen

	JSR print_intro_msg

clear_screen:
        LDA #$20               ; Load space character (ASCII 32)
        STA $1E00,X            ; Store at screen memory
        INX                    ; Increment index
        CPX SCREEN_WIDTH       
        BNE clear_screen       ; Loop until the entire screen is cleared
        RTS

print_intro_msg:
        LDX #0                ; Initialize index

print_char:
        LDA msg,X ;Load character

        CMP #$00 ;Is it 00
        BEQ title_sound ;If yes move on to title_sound

        JSR CHROUT ;Print character

        INX ;Increment index

        JMP print_char ;Repeat

loop:
 ; increment the counter
        LDA COUNTER
        INC COUNTER

        CMP #$FF        
        BNE loop

        LDA LOOP_COUNT       ; Load LOOP_COUNT
        INC LOOP_COUNT       ; Increment LOOP_COUNT

        CMP #$01             ; Compare LOOP_COUNT with 30
        BNE loop        ; If LOOP_COUNT isn't 2, loop again

        RTS

title_sound:
        LDA #$05        ; want to set volume to 5
        STA $900E       ; memory location for setting volumne

        ;LDA #'T
	;JSR CHROUT

	JSR e_note
	JSR g_note
	JSR e_note
	JSR c_note
	JSR d_note

        JSR loop  
        JMP title_sound


g_note:
        LDA #$EB       ; Load the value 135 (87 in hex) into the A register
        STA $900C
        JSR loop

        LDA #$00
        STA $900C

        RTS

c_note:
        LDA #$87        ; Load the value 135 (87 in hex) into the A register
        STA $900C       ; Store the value in memory address 36874 ($90B in hex)
        JSR loop

        LDA #$00
        STA $900C

        RTS

d_note:
        LDA #$93
        STA $900C
        JSR loop

        LDA #$00
        STA $900C

        RTS

e_note:
        LDA #$9F      
        STA $900C
        JSR loop

        LDA #$00
        STA $900C

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

        JMP start
