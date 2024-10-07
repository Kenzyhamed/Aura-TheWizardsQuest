    processor 6502
; KERNAL addresses
CHROUT  = $FFD2          ; Output character
SCREEN  = $1E00          ; VIC-20 screen memory start 
GETIN   = $FFE4          ; Get keyboard input
CLRCHN = $FFCC
HOME = $FFBA
COLOR = $9600 

XPOS = $FB               ; Memory location to track X position 

    org $1001            

; BASIC stub to automatically run the program
    dc.w nextstmt            
    dc.w 10                  
    dc.b $9e,"4109", 0       
nextstmt:
    dc.w 0                 

; Start of assembly program
mainloop:
    jsr clearscreen          ; Clear the screen at the start
    ldx #10                  ; Set X to 10 
    stx XPOS                 ; Store initial X position into XPOS memory

displayletter:
    ldx XPOS                 ; Load the current X position from memory
    lda #$01                 ; Load screen code for 'A' 
    sta SCREEN,x             ; Store 'A' at position X in screen memory
    lda #$06                 ; Load color code for blue
    sta COLOR,x              ; Set the color to blue at the same position
loop:
    jsr GETIN               ; Get key input
    cmp #$00                ; Check if no key was pressed
    beq loop                ; If no key, continue loop
    cmp #'J                ; Check if 'J' was pressed (move left)
    beq moveleft
    cmp #'L                ; Check if 'L' was pressed (move right)
    beq moveright
    jmp loop                ; Continue the loop if no recognized key

clearscreen:
    lda #$93 
    jsr CHROUT
    jsr CLRCHN
    jsr HOME
    rts

moveleft:
    ldx XPOS                 ; Load current X position
    cpx #0                  ; Check if already at leftmost position
    beq loop                ; If at the left edge, don't move

    lda #$20                ; Blank space to erase current position
    sta SCREEN,x            ; Erase current position
    dex                     ; Move left (decrement X)
    stx XPOS                ; Store updated X position in memory
    lda #$01                ; Reload screen code for 'A'
    sta SCREEN,x            ; Place character at new position
    lda #$06                ; Set color to blue
    sta COLOR,x             ; Set color at the new position
    jmp loop                ; Go back to the main loop

moveright:
    ldx XPOS                 ; Load current X position
    cpx #21                 ; Check if at the rightmost position 
    beq loop                ; If at the right edge, don't move

    lda #$20                ; Blank space to erase current position
    sta SCREEN,x            ; Erase current position
    inx                     ; Move right (increment X)
    stx XPOS                ; Store updated X position in memory
    lda #$01                ; Reload screen code for 'A'
    sta SCREEN,x            ; Place character at new position
    lda #$06                ; Set color to blue
    sta COLOR,x             ; Set color at the new position
    jmp loop                ; Go back to the main loop

