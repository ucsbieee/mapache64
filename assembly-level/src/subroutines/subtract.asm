
sub8:
        pha

        sec
        lda INT8_I1
        sbc INT8_I2
        sta INT8_O      ; store difference

        pla
        rts


sub16:
        pha

        sec
        lda INT16_I1
        sbc INT16_I2
        sta INT16_O     ; store difference  of LSB
        lda INT16_I1+1
        sbc INT16_I2+1
        sta INT16_O+1   ; store difference of MSBs

        pla
        rts


subQ9_6:
        pha

        sec
        lda Q9_6_I1
        sbc Q9_6_I2
        sta Q9_6_O     ; store difference of LSB
        lda Q9_6_I1+1
        sbc Q9_6_I2+1
        sta Q9_6_O+1   ; store difference of MSBs

        pla
        rts
