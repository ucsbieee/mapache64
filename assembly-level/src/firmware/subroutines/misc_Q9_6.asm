

; converts Q9_6_I1 to INT8_O
Q9_6_to_SINT8:
        pha

        cp8 Q9_6_I1, INT8_G1
        cp8 Q9_6_I1+1, INT8_O

        rol INT8_G1
        rol INT8_O
        rol INT8_G1
        rol INT8_O

        pla
        rts



; converts Q9_6_I1 to INT16_O
Q9_6_to_SINT16:
        pha


        ; MSB
        bit Q9_6_I1+1

        ; sign extend
        bmi .negative
.positive:
        lda #%00000000
        bra .sign_done
.negative:
        lda #%11111110
.sign_done:
        sta INT16_O+1

        ; add 1 if 6th bit is set
        lda #%01000000
        bit Q9_6_I1+1
        beq .last_bit_handled
        inc INT16_O+1
.last_bit_handled:

        ; LSB
        cp8 Q9_6_I1, INT8_G1
        cp8 Q9_6_I1+1, INT16_O

        rol INT8_G1
        rol INT16_O
        rol INT8_G1
        rol INT16_O


        pla
        rts
