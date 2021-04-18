
add8:
        pha

        clc
        lda INT8_I1
        adc INT8_I2
        sta INT8_O      ; store sum

        pla
        rts


add16:
addQ9_6:
        pha

        clc             ; clear carry
        lda INT16_I1
        adc INT16_I2
        sta INT16_O     ; store sum of LSB
        lda INT16_I1+1
        adc INT16_I2+1
        sta INT16_O+1   ; store sum of MSBs

        pla
        rts             ; return
<<<<<<< Updated upstream
=======


addQ9_6:
        pha

        clc             ; clear carry
        lda Q9_6_I1
        adc Q9_6_I2
        sta Q9_6_O     ; store sum of LSB
        lda Q9_6_I1+1
        adc Q9_6_I2+1
        sta Q9_6_O+1   ; store sum of MSBs

        pla
        rts             ; return
>>>>>>> Stashed changes
