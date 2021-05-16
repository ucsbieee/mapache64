start_pedge = $80
start_value = $81
A_pedge = $82
A_value = $83
left_value = $84
right_value = $85


fill_vram:
        rts
do_logic:
        jsr getInput
        rts
reset:
        rts
getInput:
        lda start_value
        eor #1            ; !start_value
        sta INT8_G1
        c1start
        and INT8_G1  ; start_pedge
        sta start_pedge

        c1start
        sta start_value ;start_value

        lda A_value
        eor #1
        sta INT8_G1
        c1a
        and INT8_G1
        sta A_pedge

        c1a
        sta A_value

        c1left
        sta left_value

        c1right
        sta right_value

        rts
