
; variables
zero_initilized = $70
vram_initilized = $71

person_xp       = $72
person_yp       = $73

_16:       .byte 16


; code

reset:
        stz zero_initilized
        stz vram_initilized
        rts

do_logic:
        lda zero_initilized
        beq zero_initilize
        rts

fill_vram:
        lda vram_initilized
        beq vram_initilize
        rts

zero_initilize:
        lda #128
        sta person_xp   ; person_xp = 128
        sta person_yp   ; person_yp = 128
        lda #1
        sta zero_initilized     ; set zero_initilized to true
        rts

vram_initilize:
        rts


; patterns

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
