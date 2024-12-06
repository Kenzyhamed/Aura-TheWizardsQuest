        processor 6502

; TODO: we have used CMP after LDA throughout the code. since LDA sets the condition - we don't need to use CMP after. this needs to be changed. 
; NOTE: PARTIALLY FIXED
; KERNEL routines
CHROUT = $ffd2  
CLRCHN = $ffcc
HOME = $ffba
GETIN = $FFE4  
SCREEN_COLOR_ADDRESS = $900F 

; Define boundaries for screen position high byte
SCREEN_MIN_HI = $1E   ; Starting high byte for display memory
SCREEN_MAX_HI = $1F   ; Adjust to fit your screen's high byte range

JUMP_COUNTER = $0230         ; Tracks how high the character has jumped-X
JUMPRU_COUNTER=$0250
DIAGONAL = $0240    

; screen addresses
SCREEN_START = $1E00 	; Start of screen memory in VIC-20
SCREEN_START_SECOND_ROW = $1E16 	; Start of screen memory in VIC-20
SCREEN_WIDTH = 22       ; VIC-20 screen width (22 columns)
SCREEN_HEIGHT = 23      ; VIC-20 screen height (23 rows)
COLOR_MEM = $9600  
COLOR_MEM_SECOND_ROW = $9616       
NEXT_COLOR_MEM = $96FF
VIC_CHAR_REG = $9005

BORDER_CHAR = 18
BORDER_COLOR = 6
HAT_COLOR = 0
PLATFORM_COLOR = 3
TITLE_HAT_COLOR = 2
YELLOW = 7
DANGER_PLATFORM_COLOR =2

TITLE_HAT_CROSSES_CHAR = $56
TITLE_HAT_CHAR = $66
GEM_CHAR = $04

DATA_START_LOCATION = $1C00

; addresses to store counts/variables
COUNT_FOR_LOOP = $0003
COLOR_FOR_LOOP = $0004
COUNTER = $0005
USE_NEXT_COLOR_MEMORY =  $0006
SOUND_COUNTER = $0008 
SOUND_LOOP_COUNT = $0009
LEVEL_COUNTER = $000A
DIRECTION = $000B
HI_OR_LO = $000D
INTERRUPT_COUNTER = $000E
INTERRUPT_COUNTER2 = $0013

; this is a screen memory address to that the count shows on the screen 
GEMS_COLLECTED = $1E15
GEMS_COLLECTED_COLOR = $9615

; screen memory variables
SCREEN_POS_LO   = $00   ; Low byte of screen memory address
SCREEN_POS_HI   = $01   ; High byte of screen memory address
COLOR_POS_LO    = $02   ; Low byte of color memory address
COLOR_POS_HI    = $03   ; High byte of color memory address
TEMP_SCREEN_POS_LO   = $04   ; Low byte of screen memory address
TEMP_SCREEN_POS_HI   = $05   ; High byte of screen memory address
ZP_SRC_ADDR_LO = $06  ; Zero-page address for low byte
ZP_SRC_ADDR_HI = $07  ; Zero-page address for high byte
DATA_CHAR = $08 
DATA_COLOR = $09
LOCATION_FOR_DATA_LOAD = $000C

SCREEN_POS_LO2 = $0f
SCREEN_POS_HI2 = $10
COLOR_POS_LO2 = $11
COLOR_POS_HI2 = $12

; repeated variables
; TODO: add variables for all our custom characters

        org $1001    ; Starting memory location

        include "stub.s"

; This is the data for inital text on the screen it says 
; AURA:THE WIZARDS QUEST  
; 
; SHAHZILL NAVEED
; MUTEEBA JAMAL
; KENZY HAMED
; 2024

; PRESS A TO START GAME
msg:
        HEX 0d 41 55 52 41 3A 54 48 45 20 57 49 5A 41 52 44 53 20 51 55 45 53 54 0D 53 48 41 48 5A 49 4C 4C 20 4E 41 56 45 45 44 0A 0D 4D 55 54 45 45 42 41 20 4A 41 4D 41 4C 0A 0D 4B 45 4E 5A 59 20 48 41 4D 45 44 0A 0D 32 30 32 34 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 20 20 20 50 52 45 53 53 20 41 20 54 4F 20 50 4C 41 59 00 ;This is the data for inital text on the screen - Aura the Wizards qust, Muteba Jamal, Shahzill Naveed, Kenzy Hamed


CHAR:
        dc.b %00011100
        dc.b %00011010
        dc.b %00111000
        dc.b %00111000
        dc.b %01111100
        dc.b %01111100
        dc.b %01111110
        dc.b %11111111

CHAR_RIGHT:
        ;org CHAR_RIGHT_LOCATION
        dc.b %00111000
        dc.b %01011000
        dc.b %00011100
        dc.b %00011100
        dc.b %00111100
        dc.b %00111110
        dc.b %01111110
        dc.b %11111111

NORMAL_PLATFORM:
        ;org NORAML_PLATFORM_LOCATION
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000

DANGER_PLATFORM:
        ;org DANGER_PLATFORM_LOCATION

        dc.b %00100010
        dc.b %01110111
        dc.b %11111111
        dc.b %11111111
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
      ;  dc.b %00010000
       ; dc.b %00111000
        ;dc.b %00111000
        ;dc.b %01111100
        ;dc.b %01111100
        ;dc.b %11111111
        ;dc.b %11111111
        ;dc.b %00000000

BLANK_SPACE:
        ;org BLANK_SPACE_LOCATION
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000

GEM:
        ;org GEM_LOCATION
        dc.b %00001000
        dc.b %00011100
        dc.b %00111110
        dc.b %01111111
        dc.b %00111110
        dc.b %00011100
        dc.b %00001000
        dc.b %00000000

ZERO:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %01111110
        dc.b %01000010
        dc.b %01000010
        dc.b %01000010
        dc.b %01000010
        dc.b %01111110
        dc.b %00000000

ONE:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %00111000
        dc.b %01011000
        dc.b %00011000
        dc.b %00011000
        dc.b %00011000
        dc.b %01111110
        dc.b %00000000

TWO:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %01111100
        dc.b %01000010
        dc.b %00000100
        dc.b %00001000
        dc.b %00010000
        dc.b %01111110
        dc.b %00000000

THREE:
        ;org GEM_LOCATION
        dc.b %00000000
        dc.b %01111100
        dc.b %01000010
        dc.b %00001100
        dc.b %00001100
        dc.b %01000010
        dc.b %01111100
        dc.b %00000000

DEAD_CHAR:
        ;org DEAD_CHAR_LOCATION
        dc.b %10000001
        dc.b %01000010
        dc.b %00100100
        dc.b %00011000
        dc.b %00011000
        dc.b %00100100
        dc.b %01000010
        dc.b %10000001

DOOR:
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111

DOOR_HANDLE:
        dc.b %10011111
        dc.b %10011111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111
        dc.b %11111111

HAT_FALLING_LEFT: 
        ; squish
        dc.b %00000000
        dc.b %00000000
        dc.b %00001110
        dc.b %00011000
        dc.b %00111000
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

HAT_FALLING_RIGHT:
       ; squish
        dc.b %00000000
        dc.b %00000000
        dc.b %01110000
        dc.b %00011000
        dc.b %00011100
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

HAT_FALLING:
        dc.b %10010001
        dc.b %10010001
        dc.b %10010001
        dc.b %00011000
        dc.b %00111000
        dc.b %00111100
        dc.b %01111110
        dc.b %11111111

FIRST_PORTAL:
        dc.b %00011000
        dc.b %00111100
        dc.b %01100110
        dc.b %01100110
        dc.b %01100110
        dc.b %00111100
        dc.b %00011000
        dc.b %00000000

SECOND_PORTAL:
        dc.b %00011000
        dc.b %00111100
        dc.b %01100110
        dc.b %01100110
        dc.b %01100110
        dc.b %00111100
        dc.b %00011000
        dc.b %00000000

BRICK:
        dc.b %11111101
        dc.b %11111101
        dc.b %01111000
        dc.b %00000000
        dc.b %11110111
        dc.b %11101111
        dc.b %00000111
        dc.b %01111000

        ; this one was rlly good
     ;   dc.b %11111001
     ;   dc.b %11111101
     ;   dc.b %11111000
     ;   dc.b %00000000
     ;   dc.b %11101111
     ;   dc.b %11101111
     ;   dc.b %00000000
     ;   dc.b %11111100 
       ; dc.b %00000010
       ; dc.b %00000010
       ; dc.b %00000010
       ; dc.b %11111111
       ; dc.b %00010000
       ; dc.b %00010000
       ; dc.b %11111111
       ; dc.b %00000010
       ; dc.b %11111110
        ;dc.b %00000001
        ;dc.b %00000001
        ;dc.b %11111110
        ;dc.b %01000000
        ;dc.b %10000000
        ;dc.b %01111111
        ;dc.b %10000000

       ; dc.b %01001001
       ; dc.b %01001001
       ; dc.b %11111111
       ; dc.b %10010010
       ; dc.b %10010010
       ; dc.b %11111111
       ; dc.b %00100100
       ; dc.b %00100100

DISAPPEARING_CHAR_1:
        dc.b %00000000
        dc.b %00000000
        dc.b %00010000
        dc.b %00111000
        dc.b %00111100
        dc.b %01111110
        dc.b %00000000
        dc.b %00000000

DISAPPEARING_CHAR_2:
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00010000
        dc.b %00111000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000

;--------------------------------------- TITLE_SCREEN_HAT DATA ---------------------------

TITLE_SCREEN_HAT:
        .byte $8e, $1E, $1, $A3, $1e, $03, $b8, $1e, $05, $cd, $1e, $07, $e2, $1e, $09, $f8, $1e, $08, $00, $1f, $01, $0d, $1f, $0b, $23, $1f, $0b, $39, $1f, $0b, $63, $1f, $0f, $79, $1f, $0f, $ff; 

TITLE_SCREEN_HAT_CROSSES:
        .byte $4e, $1f, $0D, $ff


;--------------------------------------- GAME DATA  ---------------------------
;--------------------------------------- LEVEL 1 ---------------------------
FIRST_PORTAL_LVL_1:
    .byte $fe
GEM_ADDRESS_LVL_1:
    .byte $D0, $1F, $DA, $1F, $DF, $1F, $ff
SECOND_PORTAL_LVL_1:
    .byte $fe
SPAWN_ADDRESS_LVL_1:
    .byte $DD, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_1:
    .byte $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_1:
    .byte $ff

;--------------------------------------- LEVEL 2 ---------------------------
FIRST_PORTAL_LVL_2:
    .byte $fe
GEM_ADDRESS_LVL_2:
    .byte $0D, $1F, $D0, $1F, $DF, $1F, $ff
SECOND_PORTAL_LVL_2:
    .byte $fe
SPAWN_ADDRESS_LVL_2:
    .byte $10, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_2:
    .byte $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_2:
    .byte $22, $1F, $5, $ff

;--------------------------------------- LEVEL 3 ---------------------------
FIRST_PORTAL_LVL_3:
    .byte $fe
GEM_ADDRESS_LVL_3:
    .byte $33, $1E, $E7, $1E, $4E, $1F, $ff
SECOND_PORTAL_LVL_3:
    .byte $fe
SPAWN_ADDRESS_LVL_3:
    .byte $30, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_3:
    .byte $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_3:
    .byte $46, $1E, $4, $FA, $1E, $4, $64, $1F, $4, $ff

;--------------------------------------- LEVEL 4 ---------------------------
FIRST_PORTAL_LVL_4:
    .byte $fe
GEM_ADDRESS_LVL_4:
    .byte $3A, $1E, $E6, $1E, $DE, $1F, $ff
SECOND_PORTAL_LVL_4:
    .byte $fe
SPAWN_ADDRESS_LVL_4:
    .byte $37, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_4:
    .byte $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_4:
    .byte $4D, $1E, $4, $67, $1F, $4, $ff

;--------------------------------------- LEVEL 5 ---------------------------
FIRST_PORTAL_LVL_5:
    .byte $fe
GEM_ADDRESS_LVL_5:
    .byte $37, $1F, $DF, $1F, $E1, $1F, $ff
SECOND_PORTAL_LVL_5:
    .byte $fe
SPAWN_ADDRESS_LVL_5:
    .byte $36, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_5:
    .byte $64, $1F, $3, $96, $1F, $3, $C8, $1F, $3, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_5:
    .byte $4C, $1F, $2, $7D, $1F, $3, $AF, $1F, $3, $ff

;--------------------------------------- LEVEL 6 ---------------------------
FIRST_PORTAL_LVL_6:
    .byte $fe
GEM_ADDRESS_LVL_6:
    .byte $79, $1E, $81, $1F, $DF, $1F, $ff
SECOND_PORTAL_LVL_6:
    .byte $fe
SPAWN_ADDRESS_LVL_6:
    .byte $77, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_6:
    .byte $E1, $1E, $3, $6B, $1F, $3, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_6:
    .byte $8D, $1E, $4, $51, $1F, $3, $95, $1F, $3, $ff

;--------------------------------------- LEVEL 7 ---------------------------
FIRST_PORTAL_LVL_7:
    .byte $CD, $1E
GEM_ADDRESS_LVL_7:
    .byte $D0, $1E, $D0, $1F, $DB, $1F, $ff
SECOND_PORTAL_LVL_7:
    .byte $D8, $1F
SPAWN_ADDRESS_LVL_7:
    .byte $D4, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_7:
    .byte $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_7:
    .byte $E1, $1E, $6, $ff

;--------------------------------------- LEVEL 8 ---------------------------
FIRST_PORTAL_LVL_8:
    .byte $A7, $1E
GEM_ADDRESS_LVL_8:
    .byte $A3, $1E, $AA, $1E, $D0, $1F, $ff
SECOND_PORTAL_LVL_8:
    .byte $DD, $1F
SPAWN_ADDRESS_LVL_8:
    .byte $DA, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_8:
    .byte $39, $1F, $5, $44, $1F, $4, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_8:
    .byte $B8, $1E, $9, $ff

;--------------------------------------- LEVEL 9 ---------------------------
FIRST_PORTAL_LVL_9:
    .byte $A7, $1E
GEM_ADDRESS_LVL_9:
    .byte $AA, $1E, $25, $1F, $D5, $1F, $ff
SECOND_PORTAL_LVL_9:
    .byte $29, $1F
SPAWN_ADDRESS_LVL_9:
    .byte $27, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_9:
    .byte $E0, $1E, $4, $81, $1F, $4, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_9:
    .byte $B8, $1E, $9, $3A, $1F, $6, $ff

;--------------------------------------- LEVEL 10 ---------------------------
FIRST_PORTAL_LVL_10:
    .byte $5A, $1E
GEM_ADDRESS_LVL_10:
    .byte $B7, $1E, $78, $1F, $DD, $1F, $ff
SECOND_PORTAL_LVL_10:
    .byte $D9, $1F
SPAWN_ADDRESS_LVL_10:
    .byte $D6, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_10:
    .byte $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_10:
    .byte $70, $1E, $2, $88, $1E, $1, $9F, $1E, $1, $B6, $1E, $1, $CD, $1E, $1, $8D, $1F, $2, $ff

;--------------------------------------- LEVEL 11 ---------------------------
FIRST_PORTAL_LVL_11:
    .byte $52, $1F
GEM_ADDRESS_LVL_11:
    .byte $8C, $1E, $54, $1F, $DA, $1F, $ff
SECOND_PORTAL_LVL_11:
    .byte $8A, $1E
SPAWN_ADDRESS_LVL_11:
    .byte $88, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_11:
    .byte $96, $1F, $4, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_11:
    .byte $9E, $1E, $6, $64, $1F, $7, $ff

;--------------------------------------- LEVEL 12 ---------------------------
FIRST_PORTAL_LVL_12:
    .byte $D1, $1F
GEM_ADDRESS_LVL_12:
    .byte $C9, $1E, $AD, $1F, $CF, $1F, $ff
SECOND_PORTAL_LVL_12:
    .byte $C7, $1E
SPAWN_ADDRESS_LVL_12:
    .byte $30, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_12:
    .byte $FB, $1E, $3, $BE, $1F, $2, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_12:
    .byte $46, $1E, $4, $DD, $1E, $4, $C0, $1F, $6, $ff

;--------------------------------------- LEVEL 13 ---------------------------
FIRST_PORTAL_LVL_13:
    .byte $E0, $1F
GEM_ADDRESS_LVL_13:
    .byte $71, $1E, $5B, $1F, $6A, $1F, $ff
SECOND_PORTAL_LVL_13:
    .byte $52, $1E
SPAWN_ADDRESS_LVL_13:
    .byte $7C, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_13:
    .byte $05, $1F, $1, $77, $1F, $2, $97, $1F, $6, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_13:
    .byte $87, $1E, $0C, $9D, $1E, $1, $A9, $1E, $1, $B2, $1E, $2, $C8, $1E, $1, $D6, $1E, $1, $D8, $1E, $3, $F3, $1E, $2, $F6, $1E, $6, $FD, $1E, $3, $00, $1F, $2, $04, $1F, $1, $79, $1F, $5, $7F, $1F, $2, $9D, $1F, $1, $ff

;--------------------------------------- LEVEL 14 ---------------------------
FIRST_PORTAL_LVL_14:
    .byte $52, $1E
GEM_ADDRESS_LVL_14:
    .byte $54, $1E, $77, $1E, $DA, $1F, $ff
SECOND_PORTAL_LVL_14:
    .byte $75, $1E
SPAWN_ADDRESS_LVL_14:
    .byte $4B, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_14:
    .byte $E4, $1E, $2, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_14:
    .byte $59, $1E, $3, $5D, $1E, $5, $66, $1E, $5, $86, $1E, $9, $9C, $1E, $1, $B2, $1E, $1, $DD, $1E, $7, $E6, $1E, $2, $2B, $1F, $6, $3F, $1F, $3, $66, $1F, $8, $7A, $1F, $1, $7C, $1F, $1, $83, $1F, $1, $91, $1F, $1, $99, $1F, $2, $9C, $1F, $1, $B0, $1F, $2, $ff

;--------------------------------------- LEVEL 15 ---------------------------
FIRST_PORTAL_LVL_15:
    .byte $32, $1E
GEM_ADDRESS_LVL_15:
    .byte $30, $1E, $A5, $1E, $D2, $1F, $ff
SECOND_PORTAL_LVL_15:
    .byte $DD, $1F
SPAWN_ADDRESS_LVL_15:
    .byte $D7, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_15:
    .byte $38, $1F, $3, $82, $1F, $3, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_15:
    .byte $46, $1E, $4, $B8, $1E, $4, $3B, $1F, $1, $ff


;--------------------------------------- LEVEL 16 ---------------------------
FIRST_PORTAL_LVL_16:
    .byte $D3, $1F
GEM_ADDRESS_LVL_16:
    .byte $5B, $1E, $69, $1E, $97, $1F, $ff
SECOND_PORTAL_LVL_16:
    .byte $3B, $1E
SPAWN_ADDRESS_LVL_16:
    .byte $35, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_16:
    .byte $CA, $1E, $1, $E8, $1E, $1, $2D, $1F, $1, $5A, $1F, $1, $5C, $1F, $1, $B4, $1F, $1, $B6, $1F, $1, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_16:
    .byte $47, $1E, $5, $4D, $1E, $5, $71, $1E, $4, $76, $1E, $3, $7D, $1E, $5, $8C, $1E, $1, $9B, $1E, $3, $A0, $1E, $3, $BD, $1E, $3, $C3, $1E, $2, $C9, $1E, $1, $CB, $1E, $2, $E7, $1E, $1, $E9, $1E, $1, $EC, $1E, $1, $F3, $1E, $2, $04, $1F, $1, $0E, $1F, $2, $1B, $1F, $1, $2F, $1F, $1, $38, $1F, $2, $3B, $1F, $1, $3D, $1F, $1, $56, $1F, $3, $5B, $1F, $1, $5E, $1F, $1, $84, $1F, $2, $87, $1F, $3, $8F, $1F, $1, $A3, $1F, $1, $A6, $1F, $1, $AD, $1F, $6, $B5, $1F, $1, $D0, $1F, $1, $D4, $1F, $1, $DB, $1F, $1, $ff

;--------------------------------------- LEVEL 17 ---------------------------
FIRST_PORTAL_LVL_17:
    .byte $D8, $1F
GEM_ADDRESS_LVL_17:
    .byte $54, $1E, $B5, $1E, $7C, $1F, $ff
SECOND_PORTAL_LVL_17:
    .byte $52, $1E
SPAWN_ADDRESS_LVL_17:
    .byte $23, $1E
START_ADDRESS_DANGER_PLATFORM_LVL_17:
    .byte $3F, $1F, $1, $45, $1F, $3, $83, $1F, $1, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_17:
    .byte $2F, $1E, $11, $5A, $1E, $1, $5D, $1E, $5, $63, $1E, $5, $69, $1E, $2, $71, $1E, $1, $76, $1E, $2, $7D, $1E, $3, $85, $1E, $1, $97, $1E, $1, $A6, $1E, $8, $C9, $1E, $3, $E7, $1E, $1, $F4, $1E, $1, $0B, $1F, $1, $1F, $1F, $1, $21, $1F, $6, $28, $1F, $1, $40, $1F, $2, $43, $1F, $1, $61, $1F, $4, $68, $1F, $4, $84, $1F, $3, $88, $1F, $1, $8A, $1F, $1, $91, $1F, $2, $9B, $1F, $1, $9F, $1F, $1, $D5, $1F, $1, $DF, $1F, $1, $ff


;--------------------------------------- LEVEL 18 ---------------------------
FIRST_PORTAL_LVL_18:
    .byte $fe
GEM_ADDRESS_LVL_18:
    .byte $B2, $1E, $B9, $1E, $BB, $1E, $CE, $1E, $D0, $1E, $D2, $1E, $E3, $1E, $E9, $1E, $F9, $1E, $04, $1F, $10, $1F, $14, $1F, $27, $1F, $29, $1F, $3E, $1F, $94, $1F, $ff
SECOND_PORTAL_LVL_18:
    .byte $fe
SPAWN_ADDRESS_LVL_18:
    .byte $CF, $1F
START_ADDRESS_DANGER_PLATFORM_LVL_18:
    .byte $CF, $1E, $1, $D1, $1E, $1, $E4, $1E, $5, $FA, $1E, $5, $11, $1F, $3, $28, $1F, $1, $ff
START_ADDRESS_NORMAL_PLATFORM_LVL_18:
    .byte $5A, $1E, $7, $63, $1E, $1, $6B, $1E, $1, $73, $1E, $1, $7A, $1E, $1, $80, $1E, $1, $89, $1E, $1, $91, $1E, $1, $95, $1E, $1, $9F, $1E, $1, $A8, $1E, $1, $AA, $1E, $1, $B5, $1E, $1, $BF, $1E, $1, $CB, $1E, $1, $D5, $1E, $1, $E1, $1E, $1, $EB, $1E, $1, $F7, $1E, $1, $01, $1F, $1, $0D, $1F, $1, $17, $1F, $1, $23, $1F, $1, $2D, $1F, $1, $ff

;--------------------------------------- GAME TABLES ---------------------------
FIRST_PORTAL_TABLE:
    .word FIRST_PORTAL_LVL_1
    .word FIRST_PORTAL_LVL_2
    .word FIRST_PORTAL_LVL_3
    .word FIRST_PORTAL_LVL_4
    .word FIRST_PORTAL_LVL_5
    .word FIRST_PORTAL_LVL_6
    .word FIRST_PORTAL_LVL_7
    .word FIRST_PORTAL_LVL_8
    .word FIRST_PORTAL_LVL_9
    .word FIRST_PORTAL_LVL_10
    .word FIRST_PORTAL_LVL_11
    .word FIRST_PORTAL_LVL_12
    .word FIRST_PORTAL_LVL_13
    .word FIRST_PORTAL_LVL_14
    .word FIRST_PORTAL_LVL_15
    .word FIRST_PORTAL_LVL_16
    .word FIRST_PORTAL_LVL_17
    .word FIRST_PORTAL_LVL_18

GEM_ADDRESS_TABLE:
    .word GEM_ADDRESS_LVL_1
    .word GEM_ADDRESS_LVL_2
    .word GEM_ADDRESS_LVL_3
    .word GEM_ADDRESS_LVL_4
    .word GEM_ADDRESS_LVL_5
    .word GEM_ADDRESS_LVL_6
    .word GEM_ADDRESS_LVL_7
    .word GEM_ADDRESS_LVL_8
    .word GEM_ADDRESS_LVL_9
    .word GEM_ADDRESS_LVL_10
    .word GEM_ADDRESS_LVL_11
    .word GEM_ADDRESS_LVL_12
    .word GEM_ADDRESS_LVL_13
    .word GEM_ADDRESS_LVL_14
    .word GEM_ADDRESS_LVL_15
    .word GEM_ADDRESS_LVL_16
    .word GEM_ADDRESS_LVL_17
    .word GEM_ADDRESS_LVL_18

SECOND_PORTAL_TABLE:
    .word SECOND_PORTAL_LVL_1
    .word SECOND_PORTAL_LVL_2
    .word SECOND_PORTAL_LVL_3
    .word SECOND_PORTAL_LVL_4
    .word SECOND_PORTAL_LVL_5
    .word SECOND_PORTAL_LVL_6
    .word SECOND_PORTAL_LVL_7
    .word SECOND_PORTAL_LVL_8
    .word SECOND_PORTAL_LVL_9
    .word SECOND_PORTAL_LVL_10
    .word SECOND_PORTAL_LVL_11
    .word SECOND_PORTAL_LVL_12
    .word SECOND_PORTAL_LVL_13
    .word SECOND_PORTAL_LVL_14
    .word SECOND_PORTAL_LVL_15
    .word SECOND_PORTAL_LVL_16
    .word SECOND_PORTAL_LVL_17
    .word SECOND_PORTAL_LVL_18

SPAWN_ADDRESS_TABLE:
    .word SPAWN_ADDRESS_LVL_1
    .word SPAWN_ADDRESS_LVL_2
    .word SPAWN_ADDRESS_LVL_3
    .word SPAWN_ADDRESS_LVL_4
    .word SPAWN_ADDRESS_LVL_5
    .word SPAWN_ADDRESS_LVL_6
    .word SPAWN_ADDRESS_LVL_7
    .word SPAWN_ADDRESS_LVL_8
    .word SPAWN_ADDRESS_LVL_9
    .word SPAWN_ADDRESS_LVL_10
    .word SPAWN_ADDRESS_LVL_11
    .word SPAWN_ADDRESS_LVL_12
    .word SPAWN_ADDRESS_LVL_13
    .word SPAWN_ADDRESS_LVL_14
    .word SPAWN_ADDRESS_LVL_15
    .word SPAWN_ADDRESS_LVL_16
    .word SPAWN_ADDRESS_LVL_17
    .word SPAWN_ADDRESS_LVL_18

START_ADDRESS_DANGER_PLATFORM_TABLE:
    .word START_ADDRESS_DANGER_PLATFORM_LVL_1
    .word START_ADDRESS_DANGER_PLATFORM_LVL_2
    .word START_ADDRESS_DANGER_PLATFORM_LVL_3
    .word START_ADDRESS_DANGER_PLATFORM_LVL_4
    .word START_ADDRESS_DANGER_PLATFORM_LVL_5
    .word START_ADDRESS_DANGER_PLATFORM_LVL_6
    .word START_ADDRESS_DANGER_PLATFORM_LVL_7
    .word START_ADDRESS_DANGER_PLATFORM_LVL_8
    .word START_ADDRESS_DANGER_PLATFORM_LVL_9
    .word START_ADDRESS_DANGER_PLATFORM_LVL_10
    .word START_ADDRESS_DANGER_PLATFORM_LVL_11
    .word START_ADDRESS_DANGER_PLATFORM_LVL_12
    .word START_ADDRESS_DANGER_PLATFORM_LVL_13
    .word START_ADDRESS_DANGER_PLATFORM_LVL_14
    .word START_ADDRESS_DANGER_PLATFORM_LVL_15
    .word START_ADDRESS_DANGER_PLATFORM_LVL_16
    .word START_ADDRESS_DANGER_PLATFORM_LVL_17
    .word START_ADDRESS_DANGER_PLATFORM_LVL_18


START_ADDRESS_NORMAL_PLATFORM_TABLE:
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_1
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_2
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_3
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_4
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_5
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_6
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_7
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_8
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_9
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_10
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_11
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_12
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_13
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_14
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_15
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_16
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_17
    .word START_ADDRESS_NORMAL_PLATFORM_LVL_18

;--------------------------------------- DATA TABLES END ---------------------------
DOOR_TOP_ADDRESS:
        .byte $CC, $1F, $ff

DOOR_BOTTOM_ADDRESS:
        .byte $E2, $1F, $ff
DOOR_TOP_TABLE:
    .word DOOR_TOP_ADDRESS

DOOR_BOTTOM_TABLE:
    .word DOOR_BOTTOM_ADDRESS

TITLE_SCREEN_TABLE:
    .word TITLE_SCREEN_HAT
    .word TITLE_SCREEN_HAT_CROSSES

; these are the addresses for our custom character set
DATA_TABLE:
    .word CHAR  
    .word NORMAL_PLATFORM
    .word DANGER_PLATFORM
    .word BLANK_SPACE
    .word GEM
    .word ZERO
    .word ONE
    .word TWO
    .word THREE
    .word DEAD_CHAR
    .word DOOR
    .word DOOR_HANDLE
    .word CHAR_RIGHT
    .word HAT_FALLING_LEFT
    .word HAT_FALLING_RIGHT
    .word HAT_FALLING
    .word FIRST_PORTAL
    .word SECOND_PORTAL
    .word BRICK
    .word DISAPPEARING_CHAR_1
    .word DISAPPEARING_CHAR_2

; our program starts here
start:
        JMP clear_screen         

clear_screen:
        LDA #$93
        JSR CHROUT
        JSR CLRCHN

        ; adjust border and background colour
        lda SCREEN_COLOR_ADDRESS
        and #%00001000  
        ora #%11100000 
        sta SCREEN_COLOR_ADDRESS
; ----------------------------------- COPY CHAR DATA CODE -----------------------------------
        ldx #$00 
        ldy #$00

character_load_setup:
        LDA DATA_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA DATA_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page

        cpx #168
        beq title_screen

        ldy #$00

copy_data:
        LDA (ZP_SRC_ADDR_LO),y
        STA DATA_START_LOCATION,x

        inx
        iny
        cpy #8

        bne copy_data

        ; divide X by 4 and store in the accumulator
        TXA                      ; Transfer X to A
        LSR                     ; Logical shift right (divide by 2)
        LSR                     ; Logical shift right again (divide by 2)
        ; A now contains X / 4

        tay 

        jmp character_load_setup


; -----------------------------------  TITLE SCREEN CODE -----------------------------------

title_screen:
        LDX #0  
print_section_one:
        lda #$90
        JSR CHROUT ;Print character

        LDA msg,X ;Load character
        BEQ goto_load_hat 

        JSR CHROUT ;Print character
        
        INX
        JMP print_section_one

goto_load_hat:
       jmp load_hat     
; ----------------------------------- WAITING FOR A TO PLAY THE GAME -----------------------------------

wait_for_input:
        JSR title_sound

        LDA #$00
        STA LEVEL_COUNTER

        LDA #$01
        STA DATA_CHAR

        LDA #PLATFORM_COLOR
        STA DATA_COLOR

        JSR GETIN

        CMP #'A
        BEQ start_level
        BNE wait_for_input



; ----------------------------------- SCREEN CLEAR AFTER INPUT ON TITLE SCREEN -----------------------------------

start_level:
        JSR volume_off

	lda #$93
	jsr CHROUT	                ; Clear the screen

        LDA #$05                        ; setting the gem counter to zero
	STA GEMS_COLLECTED

        LDA #$01
	STA SOUND_COUNTER
        
	LDA #$00                        ; Initialize LOOP_COUNT to 0
	STA SOUND_LOOP_COUNT
        STA INTERRUPT_COUNTER            ; Load counter value
        STA INTERRUPT_COUNTER2

        LDA #$ff                        ; Load low byte (0xF5)
        sta VIC_CHAR_REG         
; --------------------------------------------- BORDER CODE ---------------------------------------------------
; Set up the top border                     ; Character to represent the border
        ldx #SCREEN_WIDTH               ; Number of characters to print
        ldy #0  

        lda #<SCREEN_START              ; Load the low byte of the screen start address
        sta SCREEN_POS_LO2       
        lda #>SCREEN_START              ; Load the high byte of the screen start address
        sta SCREEN_POS_HI2       
	lda #<COLOR_MEM               ; Load the low byte of the color start address
        sta COLOR_POS_LO2        
        lda #>COLOR_MEM               ; Load the high byte of the color start address
        sta COLOR_POS_HI2     
        
draw_top_border:
    	 ; Now draw the border
        jsr load_and_color_border
 
    	iny                             ; Increment Y to move to the next screen position
    	dex                             ; Decrement X (count down the number of characters)
    	bne draw_top_border             ; Check if the x is 0

        ; need this to print bottom border
        ldx #SCREEN_HEIGHT-1            ; Number of visible rows (23 rows for VIC-20)
        
;Loop to draw the side borders
draw_side_borders:
    	; Draw the left border at the start of the row
	ldy #0
	jsr load_and_color_border

	; Draw the right border, offset by 21 visible columns 
        ldy #SCREEN_WIDTH-1             ; Set Y to 21 which is the last right column
        jsr load_and_color_border

    	; Increment the screen position by SCREEN_WIDTH so we can go to the next row
        clc                             ; Clear carry for addition
        lda SCREEN_POS_LO2
        adc #SCREEN_WIDTH               ; Add SCREEN_WIDTH to the low byte
        sta SCREEN_POS_LO2               ; Store back the result
        bcc skip_high_increment         ; If carry is clear, skip incrementing the high byte
        inc SCREEN_POS_HI2               ; Otherwise, increment the high byte

skip_high_increment:
        ; Increment the color memory position as well
        clc                             ; Clear carry for addition
        lda COLOR_POS_LO2
        adc #SCREEN_WIDTH               ; Add SCREEN_WIDTH to the low byte of color memory
        sta COLOR_POS_LO2                ; Store back the result
        bcc skip_color_high_inc         ; If carry is clear, skip incrementing the high byte
        inc COLOR_POS_HI2                ; Otherwise, increment the high byte of color memory

skip_color_high_inc:
        dex                             ; Decrement row counter
        bne draw_side_borders           ; Repeat the loop for each row

; Draw the bottom border
draw_bottom_border:
        ldx #SCREEN_WIDTH               ; Number of characters to print in the bottom row
        ldy #0                          ; Start from the leftmost column of the last row

draw_bottom_loop:
	jsr load_and_color_border

        iny                             ; Increment Y to move to the next column
        dex                             ; Decrement the X counter
        bne draw_bottom_loop            ; Continue until X = 0

        lda #<SCREEN_START_SECOND_ROW              ; Load the low byte of the screen start address
        sta SCREEN_POS_LO2      
        lda #>SCREEN_START_SECOND_ROW              ; Load the high byte of the screen start address
        sta SCREEN_POS_HI2      
	lda #<COLOR_MEM_SECOND_ROW               ; Load the low byte of the color start address
        sta COLOR_POS_LO2        
        lda #>COLOR_MEM_SECOND_ROW               ; Load the high byte of the color start address
        sta COLOR_POS_HI2   
; --------------------------------------------- PLATFORM PRINTING CODE ---------------------------------------------------

start_printing_platforms:
        ldx #$00
        LDA DATA_CHAR
        CMP #$02
        BEQ load_danger_platform
        
load_normal_platform:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA START_ADDRESS_NORMAL_PLATFORM_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA START_ADDRESS_NORMAL_PLATFORM_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #PLATFORM_COLOR
        STA DATA_COLOR
        jmp load_print_platform

load_hat:
        ldy #0
        LDA #TITLE_HAT_COLOR
        STA DATA_COLOR

        LDA #TITLE_HAT_CHAR
        STA DATA_CHAR
        jmp continue_load_title_screen

load_danger_platform:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA START_ADDRESS_DANGER_PLATFORM_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA START_ADDRESS_DANGER_PLATFORM_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #DANGER_PLATFORM_COLOR
        STA DATA_COLOR
        jmp load_print_platform

load_cross:
        ldy #2
        LDA #YELLOW
        STA DATA_COLOR

        LDA #TITLE_HAT_CROSSES_CHAR
        STA DATA_CHAR

continue_load_title_screen:
        LDA TITLE_SCREEN_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA TITLE_SCREEN_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00

load_print_platform:
        LDA (ZP_SRC_ADDR_LO),y
        CMP #$FF                       ; FF indicates the end of the byte array
        BEQ goto_color_platform  
        STA SCREEN_POS_LO               ; Load the low byte of the platform start address
        INY

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        STA SCREEN_POS_HI  

        INY
        LDA (ZP_SRC_ADDR_LO),y    
        STA COUNT_FOR_LOOP              ; Number of platforms to print
        INY
        
        JMP print_platform

print_platform:
        TYA
        TAX
        LDY #$00
        LDA DATA_CHAR                        ; Set platform identifier (or color)
        STA (SCREEN_POS_LO),y                ; Call subroutine to draw the platform
        TXA
        TAY

        DEC COUNT_FOR_LOOP              ; Decrement COUNT_FOR_LOOP by 1
        BNE inc_screen_lo_then_draw      ; If COUNT_FOR_LOOP is not zero, draw another platform

        JMP load_print_platform 

inc_screen_lo_then_draw:
        INC SCREEN_POS_LO
        JMP print_platform

color_is_96:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_platform    
        
goto_color_platform:
        ldy #$00            

load_color_platform:
        LDA (ZP_SRC_ADDR_LO),y  
        CMP #$FF                        ; Check if we've reached the end of color data
        BEQ goto_check_platform  ; Branch if at the end of color data
        
        STA COLOR_POS_LO                 ; Load the low byte of the color start address
        INY                              ; Move to the next byte in the array

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        CMP #$1E
        BEQ color_is_96                ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI

continue_color_platform:      
        INY
        LDA (ZP_SRC_ADDR_LO),y   ; Number of platforms to color
        STA COLOR_FOR_LOOP
        INY
        
        JMP color_platform_loop

color_platform_loop:
        TYA
        TAX
        LDY #$00
        LDA DATA_COLOR                         ; Load color value (modify as needed)
        STA (COLOR_POS_LO),y               ; Apply color to platform
        TXA
        TAY
        
        DEC COLOR_FOR_LOOP         ; Decrement the platform color counter
        BNE inc_color_lo_then_draw        ; If not zero, continue coloring next platform
        
        JMP load_color_platform   ; If zero, go back to load the next color start address

inc_color_lo_then_draw:
        INC COLOR_POS_LO
        JMP color_platform_loop

; Set up for printing danger platforms

jmp_to_load_cross:
        jmp load_cross

jmp_to_wait_for_input:
        jmp wait_for_input

goto_check_platform:
        LDA DATA_CHAR
        
        CMP #$02
        BEQ goto_print_gem
        
        cmp #$66
        beq jmp_to_load_cross

        cmp #$56
        beq jmp_to_wait_for_input
        
jmp_to_start_printing_platforms_after_02:
        LDY #$00
        LDA #$02
        STA DATA_CHAR
        jmp start_printing_platforms

        
goto_print_gem:
        ldx #$00
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA GEM_ADDRESS_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA GEM_ADDRESS_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page

        ldy #$00  

print_gem:
        ; Load the starting address into A
        LDA (ZP_SRC_ADDR_LO),y
        CMP #$FF       
        BEQ goto_color_gem  
        STA SCREEN_POS_LO        

        INY

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        STA SCREEN_POS_HI        

        TYA
        TAX
        LDY #$00
        LDA #GEM_CHAR                    
        STA (SCREEN_POS_LO),y                
        TXA
        TAY

        INY
              
        JMP print_gem

color_is_96_gem:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_gem  

goto_color_gem:
        ldy #$00

color_gem:
        ; Load the starting address into A
        LDA (ZP_SRC_ADDR_LO),y  
        CMP #$FF 
        BEQ spawn_portal_door   
        STA COLOR_POS_LO       
        
        INY            
        
        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y 
        CMP #$1E
        BEQ color_is_96_gem               ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI     

continue_color_gem:
        TYA
        TAX
        LDY #$00
        LDA #YELLOW     ; Load color value (modify as needed)
        STA (COLOR_POS_LO),y               ; Apply color to platform
        TXA
        TAY

        INY

        jmp color_gem

; --------------------------------------------- SPAWNING PORTAL DOOR CODE ---------------------------------------------------
spawn_portal_door:
        ldx #$00
        LDA DATA_CHAR
        CMP #16
        BEQ goto_load_second_portal_spawn
        CMP #17
        BEQ load_door_top
        CMP #10
        BEQ load_door_bottom
        CMP #11
        BEQ load_spawn
        jsr load_first_portal
        jmp char_screen
        
jmp_spawn_portal_door:
        jmp spawn_portal_door
load_first_portal:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA FIRST_PORTAL_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA FIRST_PORTAL_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #$04
        STA DATA_COLOR
        LDA #16
        STA DATA_CHAR,y
        
        LDA (ZP_SRC_ADDR_LO),Y
        CMP #$FE
        BEQ jmp_spawn_portal_door
        rts

load_door_top:
        LDY #$00

      ; Load source address from table
        LDA DOOR_TOP_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA DOOR_TOP_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDA #$05
        STA DATA_COLOR
        LDA #10
        STA DATA_CHAR,y

        LDA (ZP_SRC_ADDR_LO),Y
        CMP #$FE
        BEQ jmp_spawn_portal_door
        jmp char_screen

load_door_bottom:
        LDY #$00

      ; Load source address from table
        LDA DOOR_BOTTOM_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA DOOR_BOTTOM_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDA #11
        STA DATA_CHAR,y
        jmp char_screen

goto_load_second_portal_spawn:
        jsr load_second_portal
        jmp char_screen

load_second_portal:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA SECOND_PORTAL_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA SECOND_PORTAL_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #$06
        STA DATA_COLOR
        LDA #17
        STA DATA_CHAR
        rts

load_spawn:
        LDA LEVEL_COUNTER   ; Load the value at LEVEL_COUNTER into the accumulator
        TAY                 ; Transfer the accumulator's value into the Y register

      ; Load source address from table
        LDA SPAWN_ADDRESS_TABLE,Y
        STA ZP_SRC_ADDR_LO            ; Store low byte in zero page
        LDA SPAWN_ADDRESS_TABLE+1,Y
        STA ZP_SRC_ADDR_HI            ; Store high byte in zero page  

        LDY #$00
        LDA #HAT_COLOR
        STA DATA_COLOR
        LDA #$00
        STA DATA_CHAR
        jmp char_screen

char_screen:
        LDA (ZP_SRC_ADDR_LO),y
        STA COLOR_POS_LO        

        INY    
        
        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y   
        CMP #$1E
        BEQ color_is_96_spawn               ; Store in high byte register
        LDA #$97
        STA COLOR_POS_HI  

continue_color_spawn:
        LDY #$00
        LDA DATA_COLOR
        STA (COLOR_POS_LO),y
       
        ldy #$00

        ; Load the starting address into A
        LDA (ZP_SRC_ADDR_LO),y       
        STA SCREEN_POS_LO        
      
        INY

        ; Load the high byte of the starting address
        LDA (ZP_SRC_ADDR_LO),y    
        STA SCREEN_POS_HI        

        LDY #$00
        LDA DATA_CHAR                       ; Set platform identifier (or color)
        STA (SCREEN_POS_LO),y                ; Call subroutine to draw the platform


        LDA DATA_CHAR
        CMP #$00
        BNE goto_spawn_portal_door

      	LDA #$05
	STA GEMS_COLLECTED

        LDA #02
        STA GEMS_COLLECTED_COLOR

        LDA LEVEL_COUNTER
        cmp #34
        beq end_screen

        LDX #$00
        LDY #$00
        jmp loop

end_screen:
       ldy #17
       lda #00
       sta (SCREEN_POS_LO),y
       lda #07
       sta (COLOR_POS_LO),y
       ldy #18
       lda #00
       sta (SCREEN_POS_LO),y
       lda #03
       sta (COLOR_POS_LO),y
       LDY #$00
       jmp loop

; spawning code prints the character at the spawn location
color_is_96_spawn:
        LDA #$96
        STA COLOR_POS_HI
        jmp continue_color_spawn 
goto_spawn_portal_door:
        jmp spawn_portal_door

; --------------------------------------------- DOOR TO NEXT LEVEL CODE ---------------------------------------------------
return:
    RTS                 ; Early return if A is not zero

check_door:
        cmp #11 
        BNE return
        TAX
        LDA GEMS_COLLECTED
        
        ; have all 3 gems been collected?
        CMP #$08
        BEQ goto_load_new_level
        TXA
        RTS

goto_load_new_level:
        jmp load_new_level


; --------------------------------------------- GEM CODE ---------------------------------------------------
check_gem:
        CMP #$04
        BEQ increment_gem_counter
        RTS

increment_gem_counter:
        LDX GEMS_COLLECTED
        INX
	STX GEMS_COLLECTED
        JSR sound_collect_gem
        rts

left_or_right:
        lda DIRECTION
        beq collected_gem_on_left

        ; default to right
        lda HI_OR_LO
        rts
       ; beq goto_continue_drawing_right
        ;jmp dec_screen_hi_then_draw

collected_gem_on_left:
        lda HI_OR_LO
        ;beq goto_continue_drawing_left
        rts
        ;jmp inc_screen_hi_then_draw  
; --------------------------------------------- MOVE CODE ---------------------------------------------------

loop:
        LDA INTERRUPT_COUNTER            
        INC INTERRUPT_COUNTER     
        LDA INTERRUPT_COUNTER
        CMP #$ff              
        BCC no_trigger
        JSR trigger_falling_ceiling
no_trigger:
        CLC        
        jsr GETIN                    ; Get key input
        beq loop                     ; If no key, continue loop
        cmp #'A                     ; Check if 'J' was pressed (move left)
        beq moveleft
        cmp #'D                     ; Check if 'L' was pressed (move right)
        beq moveright
        cmp #'R                     ; Check if 'R' was pressed (reset the level)
        beq goto_start_level
        cmp #'X                    
        beq skip_level

        jmp loop                     ; Continue the loop if no recognized key

skip_level:
        jmp load_new_level

goto_start_level:
       jmp start_level

moveright:
        lda #$01
        sta DIRECTION
        jsr check_and_move
        jmp loop
        
moveleft:
        lda #$FF
        sta DIRECTION
        jsr check_and_move
        jmp loop

save_current_position:
    LDA SCREEN_POS_LO         
    STA TEMP_SCREEN_POS_LO
    LDA SCREEN_POS_HI         
    STA TEMP_SCREEN_POS_HI
    rts

; ----------------------- PORTAL CODE ------------------------------
draw_char_after_portal_hit:
       jsr load_portal_pos

       CPX #$01
       BEQ spawn_on_right
       
       CPX #$00
       BEQ check_spawn_left_or_right

load_portal_pos:
       LDA (ZP_SRC_ADDR_LO),y
       STA SCREEN_POS_LO

       iny 

       LDA (ZP_SRC_ADDR_LO),y
       STA SCREEN_POS_HI

       jsr set_color_pos

       rts

spawn_on_right:
        ; need to increment color and screen
        inc SCREEN_POS_LO
        inc COLOR_POS_LO

        jsr check_under
    
    ; Update the character's position
    jmp bounce_animation

check_spawn_left_or_right:
        lda DIRECTION
        bmi spawn_on_left ; moving left
        jmp spawn_on_right 

spawn_on_left:
        dec SCREEN_POS_LO
        dec COLOR_POS_LO

        jsr check_under
    
    ; Update the character's position
    jmp bounce_animation

portal_animation:
       LDA #19
       STA (SCREEN_POS_LO),y

       jsr triple_delay

       LDA #20
       STA (SCREEN_POS_LO),y

       jsr triple_delay

       rts

first_portal:
       jsr invalid_move
       
       jsr portal_animation
       LDA #$03
       STA (SCREEN_POS_LO),y

       jsr load_second_portal
       ldx #$01
       jmp draw_char_after_portal_hit

second_portal:
       jsr invalid_move
       
       jsr portal_animation
       LDA #$03

       STA (SCREEN_POS_LO),y
       jsr load_first_portal

       ldx #$00
       jmp draw_char_after_portal_hit
; ----------------------- PORTAL CODE END ------------------------------

check_and_move:
    ; Input:
    ;   - DIRECTION: Direction offset (e.g., #$16 for down, #$F0 for up)
    ;   - SCREEN_POS_LO/SCREEN_POS_HI: Current position
    ; Output:
    ;   - Updates SCREEN_POS_LO/SCREEN_POS_HI if valid move
    ;   - Handles obstacles, gems, hazards, and invalid moves
    ;   - May jump to other routines for specific actions (e.g., `char_died`)

    ; Save the current position
    jsr save_current_position

    ; Calculate the new position by applying DIRECTION
    LDA SCREEN_POS_LO
    CLC                        ; Clear carry for addition/subtraction
    ADC DIRECTION              ; Add the direction offset stored in DIRECTION
    STA SCREEN_POS_LO          ; Update the low byte

    ; Check for wraparound (low byte went from FF -> 00 or 00 -> FF)
    LDA TEMP_SCREEN_POS_LO     ; Load the original low byte
    CMP SCREEN_POS_LO          ; Compare original with updated
    BCC handle_increment       ; If updated < original, it wrapped forward (FF -> 00)
    BCS handle_decrement_check ; If updated > original, it wrapped backward (00 -> FF)

    ; If no wraparound, continue as normal
    JMP no_carry

handle_increment:
    ; check if TEMP_SCREEN_POS_LO is 00
    cmp #$ff
    BNE no_carry               ; Skip increment if not $1E

    lda SCREEN_POS_HI
    cmp #$1F
    beq no_carry

    ; Increment the high byte if wrapping forward (FF -> 00)
    INC SCREEN_POS_HI          ; Increment high byte
    JMP no_carry

handle_decrement_check:
    ; Decrement the high byte only if wrapping backward (00 -> FF)
    LDA TEMP_SCREEN_POS_LO     ; Load original low byte
    CMP #$00                   ; Was the original low byte 00?
    BNE no_carry               ; If not 00, no need to decrement

    ; Proceed with decrement
    LDA SCREEN_POS_HI
    CMP #$1F                   ; Decrement only if high byte is $1F
    BNE no_carry               ; Skip decrement if not $1F
    DEC SCREEN_POS_HI          ; Decrement high byte

no_carry:
    ; Load the character at the new position
    LDY #$00
    LDA (SCREEN_POS_LO),Y 

    jsr check_gem
    jsr check_door

    CMP #$02                  ; fire platform 
    BEQ char_died
    
    CMP #BORDER_CHAR              
    BEQ invalid_move

    CMP #01             
    BEQ invalid_move

    cmp #$0b                    ; door handle char
    beq invalid_move

    cmp #16                    
    beq first_portal
 
    cmp #17                     
    beq second_portal

    cmp #00                    
    beq game_done

    JMP update_position
game_done:
        jsr invalid_move
        ldy #00
        LDA #04
        STA (COLOR_POS_LO),y
        jmp game_done

check_under:
    ; Input:
    ;   - SCREEN_POS_LO: Current screen position low byte
    ;   - SCREEN_POS_HI: Current screen position high byte
    ;   - A: Action offset (16 for down, -16 for up, etc.)
    ; Output:
    ;   - Updates SCREEN_POS_LO and SCREEN_POS_HI for valid moves
    ;   - Handles gems, deaths, and bounces
    ;   - Jumps to appropriate routines for special cases

    jsr save_current_position

    ; Move down by 0x16
    LDA SCREEN_POS_LO
    CLC
    ADC #$16                  ; Add offset to go down one block
    STA SCREEN_POS_LO         ; Update the low byte
    BCC check_under_no_carry  ; Branch if no carry

    ; Handle carry for the high byte, only increment if SCREEN_POS_HI is $1E
    INC SCREEN_POS_HI          ; Increment the high byte

check_under_no_carry:
    LDY #$00
    LDA (SCREEN_POS_LO),Y 

    CMP #$01                 ;  platform 
    BEQ invalid_move

    CMP #$02                  ; fire platform 
    BEQ char_died
    
    CMP #BORDER_CHAR              
    BEQ invalid_move

    cmp #$0b                    ; door handle char
    beq invalid_move

    jsr check_gem
    jsr fall_animation

    jmp check_under

fall_animation:
       jsr set_color_pos

       LDA #15
       STA (SCREEN_POS_LO),y
      
       LDA #HAT_COLOR
       STA (COLOR_POS_LO),y

       jsr jiffy_delay_fast

       LDA #03
       STA (SCREEN_POS_LO),y 

       LDA #HAT_COLOR
       STA (COLOR_POS_LO),y
       
       jsr volume_off_all

       rts

update_position:
    ; first remove from previous position 
    LDA #03
    STA (TEMP_SCREEN_POS_LO),y 
    ;LDA #HAT_COLOR
    ;STA (COLOR_POS_LO),y

    jsr check_under
    
    ; Update the character's position
    jmp bounce_animation

invalid_move:
    ; Restore original position
    LDA TEMP_SCREEN_POS_LO
    STA SCREEN_POS_LO
    LDA TEMP_SCREEN_POS_HI
    STA SCREEN_POS_HI
    RTS                       ; Return without updating position

char_died:
       SEC                  ; Set the carry to prepare for subtraction
       LDA SCREEN_POS_LO    ; Load the low byte into the accumulator
       SBC #$16             ; Subtract 0x16 (22 in decimal) from the accumulator
       STA SCREEN_POS_LO    ; Store the result back into SCREEN_POS_LO
       STA COLOR_POS_LO    ; Store the result back into SCREEN_POS_LO


       LDA #$09                    ; Load the character code for the blank platform
       STA (SCREEN_POS_LO),y           ; Draw the blank character at the reverted position
      
       LDA #HAT_COLOR
       STA (COLOR_POS_LO),y    

       JSR sound_dead
       ldy #$00
       jsr DelayLoop
       jmp start_level  
                      
set_color_pos:
        lda SCREEN_POS_LO
        sta COLOR_POS_LO

        lda SCREEN_POS_HI
        cmp #$1E
        beq dont_increment_color_hi

        lda #$97
        sta COLOR_POS_HI

        rts

dont_increment_color_hi:
        lda #$96
        sta COLOR_POS_HI
        rts

bounce_animation:
        jsr set_color_pos

        jsr handle_load_bounce_hat 
        STA (SCREEN_POS_LO),y 
        
        LDA #HAT_COLOR
        STA (COLOR_POS_LO),y

        jsr jiffy_delay_fast
        jsr jiffy_delay_fast

        jsr handle_load_hat
        STA (SCREEN_POS_LO),y  

        jsr volume_off_all
        
        jmp loop
        
handle_load_bounce_hat:
        lda DIRECTION
        BMI load_left_bounce          ; If negative (e.g., moving left)
        ; load right bounce if not negative        
        lda #14
        rts

load_left_bounce:
        lda #13
        rts
        
handle_load_hat:
        lda DIRECTION
        BMI load_left_hat
        ; load right hat if not negative
        lda #12
        rts

load_left_hat:
        lda #00
        rts

; ---------------------------- SOUND EFFECTS ----------------------------
title_sound:
	jsr set_volume

        jsr play_f_highest_octave
        jsr speakers_off

        jsr play_f_highest_octave
        JSR triple_delay_speakers_off

        jsr play_b_highest_octave
        jsr speakers_off

        jsr play_f_highest_octave
        JSR double_triple_delay
        jsr speakers_off

        jsr play_b_highest_octave
        JSR double_triple_delay
        JSR triple_delay_speakers_off

        jsr play_f_highest_octave
        JSR triple_delay_speakers_off

        jsr play_b_highest_octave
        jsr speakers_off

        JSR triple_delay

        RTS

sound_portal:
        jsr set_volume

        LDA #$F0       ; wb #241
        STA $900D      

        ; TODO: do we want to turn the sound off once weve travelled thru to the other side?
        jsr speakers_off
        jsr volume_off

	RTS


sound_dead:	
        jsr set_volume

	JSR play_c_note_low_octave
     	JSR play_d_note_low_octave
        JSR play_c_note_low_octave

        jsr volume_off
        RTS

sound_collect_gem:
        jsr set_volume
        ; Play C#
        LDA #241
        STA $900C

        rts

sound_collect_gem_with_delay:
        jsr sound_collect_gem
        jsr speakers_off
        jsr volume_off
        rts

play_f_highest_octave:
        LDA #163
        STA $900C       
        RTS

play_b_highest_octave:
        LDA #191
        STA $900C 
        RTS

play_c_note_low_octave:
	LDA #$87        
        STA $900A   

        JSR speakers_off
	RTS

; TODO: if we dont use this anywhere else then we can put it into the sound_dead method
play_d_note_low_octave:
	LDA #$93
        STA $900A
	JSR speakers_off
	RTS

set_volume:
        LDA #10
        STA $900E       
        RTS

triple_delay_speakers_off:
        JSR triple_delay
        jsr speakers_off
        rts

volume_off:
	LDA #$00
        STA $900E
	
	RTS

volume_off_all:
	jsr volume_off
        STA $900A
        STA $900C
        STA $900D

	RTS

speakers_off:
        JSR triple_delay

	LDA #$00
        STA $900A
        STA $900C
        STA $900D

        JSR triple_delay
	
	RTS
; ---------------------------- DRAW AND COLOR CODE BEING USED AT A FEW PLACES ----------------------------
triple_delay:
        JSR DelayLoop2
        JSR DelayLoop2
        JSR DelayLoop2
        RTS

double_triple_delay:
        JSR triple_delay
        JSR triple_delay
        RTS

DelayLoop:
        LDX #$FF                  ; Set up outer loop counter
        jmp DelayLoopX

DelayLoop2:
        LDX #$09                  ; Set up outer loop counter
        jmp DelayLoopX
             
DelayLoopX:
        LDY #$FF                  ; Set up inner loop counter

DelayLoopY:
        DEY       
        NOP 
        NOP
        NOP
        NOP 
        NOP
        NOP  
        BNE DelayLoopY            ; If Y is not zero, branch back to DelayLoopY

        DEX 
        NOP 
        NOP
        NOP
        NOP 
        NOP
        NOP 

        BNE DelayLoopX            ; If X is not zero, branch back to DelayLoopX
        RTS

jiffy_delay_fast:
        TXA
        jsr DelayLoop2
        TAX
        rts
; ---------------------------------------- LOAD NEW LEVEL -------------------------
; this whole routine needs to be opimized. right now we have seperate methods for each level but in the future we should find a way to 
; call these setup levels using an offset

load_new_level:
    INC LEVEL_COUNTER       ; Increment the level counter
    INC LEVEL_COUNTER
    LDA #$01
    STA DATA_CHAR
    jmp start_level

trigger_falling_ceiling:
    inc INTERRUPT_COUNTER2
    lda INTERRUPT_COUNTER2
    cmp #$d0
    bne no_trigger2
    jsr init_draw_falling_ceiling

    RTS              

no_trigger2:
    jmp no_trigger

init_draw_falling_ceiling:  
        LDY #0                 
        LDx #0                
draw_falling_ceiling:
    jsr load_and_color_border

    inc SCREEN_POS_LO2
    inc COLOR_POS_LO2 
    bne continue_draw_falling_ceiling
    
    lda SCREEN_POS_HI2
    cmp #$1F
    beq jump_to_start_level

    inc SCREEN_POS_HI2
    inc COLOR_POS_HI2         
    
continue_draw_falling_ceiling: 
    inx   
    CPx #22
    BNE draw_falling_ceiling
    rts

jump_to_start_level:
        jmp start_level

load_and_color_border:
        lda #BORDER_CHAR          ; Load the border character
        sta (SCREEN_POS_LO2),y     ; Store the character at the current screen position (using Y as the offset)

        lda #BORDER_COLOR         ; Load the border color code
        sta (COLOR_POS_LO2),y      ; Store the color at the current color memory position

        rts



