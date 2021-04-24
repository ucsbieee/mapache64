
do_logic:
        lda #$1
        sta INT8_I1
        sta INT8_I2
        jsr add8

        lda #$ff
        sta INT16_I1
        sta INT16_I2
        lda #$1
        sta INT16_I1+1
        sta INT16_I2+1
        jsr add16

        lda #$ff
        sta Q9_6_I1
        sta Q9_6_I2
        lda #$1
        sta Q9_6_I1+1
        sta Q9_6_I2+1
        jsr addQ9_6

        stp
        rts

reset:
fill_vram:
        rts
