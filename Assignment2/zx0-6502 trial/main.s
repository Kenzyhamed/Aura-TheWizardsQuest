	processor 6502
	org $1001                   

	include "stub.s"  
start:
    jsr full_decomp               ; Jump to decompression routine
display_loop:
    jsr display_screen            ; Continuously jump to the display routine
    jmp display_loop              ; Jump back to display_loop for infinite looping

out_addr=$1E00

; Include the Decompression 
     include "zx0-6502.asm"          

; Compressed data
comp_data:
    .incbin "TitleScreen.zx0"     


; Display Screen Routine
display_screen:
    ldx #$00                      
    lda #$1E                      
    sta $02                       
display_inner_loop:
    lda out_addr,x               
    sta ($02),y                  
    iny                           
    bne display_inner_loop              
    inx                           
    cpx #$FA                      
    bne display_inner_loop              

    rts                           
