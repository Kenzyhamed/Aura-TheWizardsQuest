
        processor 6502

CHROUT = $ffd2       ; KERNAL routine to output a character
CLRCHN = $ffcc
GETIN = $FFE4      


SCREEN_MEM = $1E00
COLOR_MEM = $9600

DELAY_COUNTER = $0008 
DELAY_LOOP_COUNT = $0009

CHAR_LOCATION = $1C00
PLATFORM_LOCATION = $1c08
HAT_LOCATION = $1c10
HAT_FALLING_1_LOCATION = $1c18
HAT_FALLING_2_LOCATION = $1c20
HAT_FALLING_3_LOCATION = $1c28

VIC_CHAR_REG = $9005

        org $1001    ; Starting memory location

        include "stub.s"

msg:
	HEX 50 52 45 53 53 20 41 20 54 4F 20 53 54 41 52 54 0D 00

CHAR:
       ; org CHAR_LOCATION
        dc.b %00111100
        dc.b %01000010
        dc.b %10100101
        dc.b %10000001
        dc.b %10100101
        dc.b %10011001
        dc.b %01000010
        dc.b %00111100

HAT:
        ;org CHAR_LOCATION
        dc.b %00011100
        dc.b %00011010
        dc.b %00111000
        dc.b %00111000
        dc.b %01111100
        dc.b %01111100
        dc.b %01111110
        dc.b %11111111

HAT_FALLING_1:
        ;org CHAR_LOCATION
        dc.b %00001110
        dc.b %00011000
        dc.b %00011000
        dc.b %00111000
        dc.b %00111100
        dc.b %01111100
        dc.b %01111110
        dc.b %11111111

HAT_FALLING_2:
        ;org CHAR_LOCATION
        dc.b %00001000
        dc.b %00001000
        dc.b %00011000
        dc.b %00011000
        dc.b %00111100
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

HAT_FALLING_3:
        ;org CHAR_LOCATION
        dc.b %00010000
        dc.b %00011000
        dc.b %00111000
        dc.b %00111000
        dc.b %00111000
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

PLATFORM:
       ; org PLATFORM_LOCATION
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %11111111
        dc.b %11111111
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000


; our program starts here
start:
       	lda #$93
        JSR CHROUT
        JSR CLRCHN

        LDA #$01
	STA DELAY_COUNTER
	LDA #$00                        ; Initialize LOOP_COUNT to 0
	STA DELAY_LOOP_COUNT

        ; copy CHAR data to $1c00
        ldx #0                   
copy_char_data:
        lda CHAR,x              
        sta CHAR_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_char_data       

        ; copy PLATFORM data to $1c08
        ldx #0

copy_hat_data:
        lda HAT,x              
        sta HAT_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_hat_data       

        ; copy PLATFORM data to $1c08
        ldx #0

copy_hat_falling_1_data:
        lda HAT_FALLING_1,x              
        sta HAT_FALLING_1_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_hat_falling_1_data       

        ; copy PLATFORM data to $1c08
        ldx #0

copy_hat_falling_2_data:
        lda HAT_FALLING_2,x              
        sta HAT_FALLING_2_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_hat_falling_2_data       

        ; copy PLATFORM data to $1c08
        ldx #0

copy_hat_falling_3_data:
        lda HAT_FALLING_3,x              
        sta HAT_FALLING_3_LOCATION,x     
        inx                    
        cpx #8                  
        bne copy_hat_falling_3_data       

        ; copy PLATFORM data to $1c08
        ldx #0

copy_platform_data:
        lda PLATFORM,x         
        sta PLATFORM_LOCATION,x 
        inx                   
        cpx #8             
        bne copy_platform_data  

        jmp load_char                   

load_char:
        ; point VIC to use custom character set
        lda #$FF
        sta VIC_CHAR_REG          

char_screen:
        ; display custom character on the screen
        LDA #$00  
        STA SCREEN_MEM
       	LDA #$00
        STA COLOR_MEM

        LDX #3 

        ; display platform on the screen
        LDA #$01
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

        LDX #5 

        ; display falling hat on the screen
        LDA #$02
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

        LDX #7

        ; display falling hat on the screen
        LDA #$03
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

        LDX #9

        ; display falling hat on the screen
        LDA #$04
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

         LDX #11

        ; display falling hat on the screen
        LDA #$05
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

        JMP loop

load_one:
        LDX #13

        ; display falling hat on the screen
        LDA #$02
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

        RTS

load_two:
        LDX #13

        ; display falling hat on the screen
        LDA #$03
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

        RTS

load_three:
        LDX #13

        ; display falling hat on the screen
        LDA #$04
        STA SCREEN_MEM,X
        LDA #$00
        STA COLOR_MEM,X

        RTS

fall_animation:
    JSR load_one
    JSR jiffy_delay_fast   ; Faster jiffy-based delay
    JSR load_two
    JSR jiffy_delay_fast
    
    JSR load_three
    JSR jiffy_delay_fast
    JSR jiffy_delay_fast
    JSR jiffy_delay_fast
    JSR jiffy_delay_fast
    JSR jiffy_delay_fast

    JSR load_one
    JSR jiffy_delay_fast   ; Faster jiffy-based delay

    JMP loop

jiffy_delay_fast:
    ; Calculate target jiffy time
    LDA $A2            ; Low byte of current jiffy clock
    CLC
    ADC #$04           ; Add a small delay (2 jiffies)
    STA DELAY_LOW      ; Store target low byte
    LDA $A3            ; High byte of current jiffy clock
    ADC #$00           ; Carry over to high byte if necessary
    STA DELAY_HIGH     ; Store target high byte

.wait:
    ; Wait until the jiffy clock reaches or exceeds the target time
    LDA $A2            ; Current low byte
    CMP DELAY_LOW      ; Compare with target low byte
    LDA $A3            ; Current high byte
    SBC DELAY_HIGH     ; Subtract target high byte
    BCC .wait          ; If not reached, loop

    RTS

loop:
        JMP wait_for_input

wait_for_input:
        JSR GETIN

        CMP #'A
        BEQ fall_animation
        BNE wait_for_input

; Variables for delay storage
DELAY_LOW   = $FC  ; Temporary storage for low byte of delay
DELAY_HIGH  = $FD  ; Temporary storage for high byte of delay
