    processor 6502
    org $1001                   

start:
    jsr basic_stub                ; Jump to the BASIC stub routine 
    jsr full_decomp               ; Jump to decompression routine
    jsr display_screen            ; Jump to routine to display 
 
    rts                           

out_addr=$2000

; Include the Decompression 
     include "zx0-6502-3.asm"          

; Compressed data
comp_data:
    .incbin "TitleScreen.zx0"     


; Display Screen Routine
display_screen:
    ldx #$00                      
    lda #$1E                      
    sta $02                       
display_loop:
    lda out_addr,x               
    sta ($02),y                  
    iny                           
    bne display_loop              
    inx                           
    cpx #$FA                      
    bne display_loop              

    rts                           


basic_stub:
    .include "stub.s"            
