; De-compressor for ZX0 files
; ---------------------------
;
; Decompress ZX0 data (6502 optimized format), optimized for
; minimal size - 148 bytes.
;
; Compress with:
;    zx0 -2 input.bin output.zx0
;
; (c) 2022 DMSC
; Code under MIT license, see LICENSE file.


ZP = $00

offset = ZP+0
ZX0_src = ZP+2
ZX0_dst = ZP+4
bitr = ZP+6
elias_h = ZP+7
pntr = ZP+8


            ; Initial values for offset, source, destination and bitr
zx0_ini_block:
            .byte $00, $00, <comp_data, >comp_data, <out_addr, >out_addr, $80

;--------------------------------------------------
; Decompress ZX0 data (6502 optimized format)

full_decomp:
              ; Get initialization block
              ldy #7

copy_init:    lda zx0_ini_block-1,y
              sta offset-1,y
              dey
              bne copy_init

; Decode literal: Ccopy next N bytes from compressed file
;    Elias(length)  byte[1]  byte[2]  ...  byte[N]
decode_literal
              jsr   get_elias

cop0:         jsr   get_byte
              jsr   put_byte

              bne   cop0
              dec   elias_h
              bpl   cop0

              asl   bitr
              bcs   dzx0s_new_offset

; Copy from last offset (repeat N bytes from last offset)
;    Elias(length)
              jsr   get_elias_carry ; Use "_carry" as C already = 0, it is a little faster.
dzx0s_copy:
              lda   ZX0_dst
              sbc   offset  ; C=0 from get_elias
              sta   pntr
              lda   ZX0_dst+1
              sbc   offset+1
              sta   pntr+1

cop1:
              lda   (pntr),y
              inc   pntr
              bne   label1
              inc   pntr+1
label1:       jsr   put_byte

              bne   cop1
              dec   elias_h
              bpl   cop1

              asl   bitr
              bcc   decode_literal

; Copy from new offset (repeat N bytes from new offset)
;    Elias(MSB(offset))  LSB(offset)  Elias(length-1)
dzx0s_new_offset:
              ; Read elias code
              jsr   get_elias
              beq   exit  ; Read a $FF, signals the end
              dex
              stx   offset+1
              ; Get low part of offset, a literal 7 bits
              jsr   get_byte
              ; Divide by 2
              lsr   offset+1
              ror   
              sta   offset

              ; Store the extra bit of offset to our bit reserve,
              ; to be read by get_elias. Last bit stays in carry.
              ror   bitr
              ; And get the copy length.
              ; NOTE: can't jump to the copy because we need to increment
              ;       the length by 1, this is 8 extra bytes...
              jsr   get_elias_carry

label2:       inx
              bne   label3
              inc   elias_h
label3:       bne   dzx0s_copy

; Read an elias-gamma interlaced code.
; ------------------------------------
get_elias:
              clc
get_elias_carry:
              ; Initialize return value to #1
              lda   #1
              sty   elias_h
elias_loop:
              ; Get one bit - use ROL to allow injecting one bit at start
              rol   bitr
              bne   label4
              ; Read new bit from stream
              tax
              jsr   get_byte
              ;sec   ; not needed, C=1 guaranteed from last bit
              rol   
              sta   bitr
              txa
label4:
              bcs   elias_get

              ; Got 1, stop reading
              tax
exit:         rts

elias_get:     ; Read next data bit to LEN
              asl   bitr
              rol   
              rol   elias_h
              bcc   elias_loop

get_byte:
              lda   (ZX0_src),y
              inc   ZX0_src
              bne   label5
              inc   ZX0_src+1
label5:       rts

put_byte:
              sta   (ZX0_dst),y
              inc   ZX0_dst
              bne   label6
              inc   ZX0_dst+1
label6:       dex
              rts

