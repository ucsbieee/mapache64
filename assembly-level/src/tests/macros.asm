
do_logic:
        ; cp8
        lda #$ee
        sta INT8_G1
        cp8 INT8_G1, INT8_G2

        ; cp16
        lda #$12
        sta INT16_G1
        lda #$34
        sta INT16_G1+1
        cp16 INT16_G1, INT16_G2

        ; swp8
        swp8 INT16_G1, INT16_G1+1

        ; swp16
        swp16 INT16_G1, INT16_G2

        stp
        rts

reset:
fill_vram:
        rts
