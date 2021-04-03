
add8:
        pha
        clc
        lda INT8_I1
        adc INT8_I2
        sta INT16_O     ; store sum

        pla
        rts


add16:
addQ11_4:
        pha

        clc             ; clear carry
        lda INT16_I1+1
        adc INT16_I2+1
        sta INT16_O+1   ; store sum of LSBs
        lda INT16_I1
        adc INT16_I2
        sta INT16_O     ; store sum of MSB

        pla
        rts             ; return
