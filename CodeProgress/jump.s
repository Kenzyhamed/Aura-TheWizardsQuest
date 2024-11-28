jumpup:
        
        ; Initialize jump
        ldx #$03               
        stx JUMP_COUNTER
        jmp jump_in_progress  
jumpright:
        ; Initialize jump
        ldx #$02     ;vertical           
        stx JUMPRU_COUNTER
        ldx #$01     ;vertical           
        stx DIAGONAL
        jmp jumpright_in_progress            
;----jump right with new movement pattern----
jumpright_in_progress:
        jsr erease           ; Erase character at the current position
        ; Handle first upward movement (up by two steps)
        lda JUMPRU_COUNTER       
        cmp #$00             ; Check if upward movement is complete
        beq diagonal_right
        jmp handle_upward
       
diagonal_right:      
        ; Handle diagonal up-right movement
        lda DIAGONAL    
        cmp #$01
        beq handle_up_right

        ; Handle diagonal down-right movement
        cmp #$00
        beq handle_down_right
handle_upward:
        dec JUMPRU_COUNTER
        ; Move up one row
        lda SCREEN_POS_LO     
        sec
        sbc #SCREEN_WIDTH    ; Move up one row
        sta SCREEN_POS_LO     
        bcs no_high_byte_change_up

        dec SCREEN_POS_HI    ; Adjust high byte if moving up crosses boundary

no_high_byte_change_up:

        jsr draw_jump
        jmp jumpright_in_progress

handle_up_right:
        dec DIAGONAL
        jsr erease  
        ; Move up one row
        lda SCREEN_POS_LO     
        sec
        sbc #SCREEN_WIDTH    ; Move up one row
        sta SCREEN_POS_LO     
        bcs continue

        dec SCREEN_POS_HI    ; Adjust high byte if moving up crosses boundary
continue:
        CLC
        ldy #$00

        inc SCREEN_POS_LO   
        bcc no_high_byte_change_up_right

        dec SCREEN_POS_HI    ; Adjust high byte if moving up crosses boundary
        jsr no_high_byte_change_up_right
no_high_byte_change_up_right:
        jsr draw_jump
        jmp diagonal_right
handle_down_right:
        inc DIAGONAL

        ; Move down one row and right one column
        jsr erease       
        lda SCREEN_POS_LO      
        clc                 
        adc #SCREEN_WIDTH      
        sta SCREEN_POS_LO     
        bcc continue_down
        inc SCREEN_POS_HI        
continue_down:
        CLC
        ldy #$00

        inc SCREEN_POS_LO     
        bcc no_high_byte_change_down_right

        inc SCREEN_POS_HI    ; Adjust high byte if moving down crosses boundary


no_high_byte_change_down_right:
        jsr draw_jump
apply_gravity_right:
        lda JUMPRU_COUNTER
        cmp #$02             ; Check if the jump has returned to the ground
        beq end
        jsr erease
        lda SCREEN_POS_LO      
        clc
        adc #SCREEN_WIDTH    ; Move down one row
        sta SCREEN_POS_LO      
        bcc no_high_byte_change_final_down

        inc SCREEN_POS_HI    ; Adjust high byte if moving down crosses boundary
   
no_high_byte_change_final_down:
        inc JUMPRU_COUNTER
        
        jsr draw_jump
        jmp apply_gravity_right
end:
   jmp loop  
;----end of jump right----
  
jump_in_progress:
        jsr erease
        lda JUMP_COUNTER       
        cmp #$00
        beq apply_gravity 

        lda SCREEN_POS_LO     
        sec                    
        sbc #SCREEN_WIDTH      
        sta SCREEN_POS_LO      
        bcs no_high_byte_change

        dec SCREEN_POS_HI      
no_high_byte_change:

        dec JUMP_COUNTER 
        jsr draw_jump ;TODO move the character on screen up with a smooth delay   
        jsr check_gem_left   
        jmp jump_in_progress             
apply_gravity:
        jsr erease       
        lda SCREEN_POS_LO      
        clc                 
        adc #SCREEN_WIDTH      
        sta SCREEN_POS_LO     
        bcc no_high_byte_change_down 
        inc SCREEN_POS_HI     
no_high_byte_change_down:
        inc JUMP_COUNTER 
        jsr draw_jump 
        jsr check_gem_left 
        lda JUMP_COUNTER       
        cmp #$03
        bne apply_gravity  
go_back:
        jmp loop             
draw_jump:
    ldy #$00
    LDA #$00               ; Character code for the player
    JSR draw_platform      ; Draw character on screen
    jsr color_char
    JSR delay_jump          ; Add delay for visibility
    RTS
delay_jump:
    LDX #$20         ; Outer loop count (tune this value for the desired pace)
OuterLoop:
    LDY #$FF         ; Inner loop count
InnerLoop:
    DEY              ; Decrement Y
    BNE InnerLoop    ; If Y is not zero, keep looping
    DEX              ; Decrement X
    BNE OuterLoop    ; If X is not zero, keep looping
    RTS              ; Return from subroutine
erease:
    ldy #$00
    LDA #$03              
    JSR draw_platform     
    RTS