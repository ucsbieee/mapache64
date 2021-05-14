
; ===== labels ===== ;

zero_initialized = $70
vram_initialized = $71

person_xp       = $72
person_yp       = $73


; ===== interrupts ===== ;

reset:
        stz zero_initialized
        stz vram_initialized
        rts


do_logic:
        lda zero_initialized
        bne .exit
        jsr zero_initialize
.exit
        rts


fill_vram:
        lda vram_initialized
        bne .exit
        jsr vram_initialize
.exit
        stp             ; run once
        rts


; ===== logic ===== ;

zero_initialize:
        lda #128
        sta person_xp   ; person_xp = 128
        sta person_yp   ; person_yp = 128

        lda #1
        sta zero_initialized    ; set zero_initialized to true
        rts


; ===== vram ===== ;

vram_initialize:
        lda #16
        sta INT8_I1

        ; load in NORMAL sprite to PMF
        ldlab16 ADDRESS16_1, NORMAL
        ldlab16 ADDRESS16_2, _PMF1
        jsr transfer_mem

        ; load in LOOPING_UP sprite to PMF
        ldlab16 ADDRESS16_1, LOOKING_UP
        ldlab16 ADDRESS16_2, _PMF1+16
        jsr transfer_mem

        ; set character position in OMB
        lda person_xp
        sta _OBM+0
        lda person_yp
        sta _OBM+1
        stz _OBM+2
        lda #%110
        sta _OBM+3

        lda #1
        sta vram_initialized    ; set vram_initialized to true
        rts


; patterns
        .org $8100
NORMAL:
        .db %00001010, %10100000
        .db %00101111, %11111000
        .db %00101111, %11111000
        .db %10110111, %11011110
        .db %10110111, %11011110
        .db %10111111, %11111110
        .db %00101111, %11111000
        .db %00001010, %10100000

LOOKING_UP:
        .db %00001010, %10100000
        .db %00101111, %11111000
        .db %00101111, %11111000
        .db %10111111, %11111110
        .db %10110111, %11011110
        .db %10110111, %11011110
        .db %00101111, %11111000
        .db %00001010, %10100000
