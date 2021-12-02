
; copy memory with length INT8_I1 from ADDRESS16_1 to ADDRESS16_2
transfer_mem:
        pha

        ldy #0
.loop:
        lda (ADDRESS16_1),Y
        sta (ADDRESS16_2),Y

        iny                     ; loop back if not at length
        cpy INT8_I1
        bne .loop

        pla
        rts
