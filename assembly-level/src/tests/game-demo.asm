

; ====================== ;
; ======= Labels ======= ;
; ====================== ;

; === Input === ;

start_pedge     = $80
start_value     = $81
A_pedge         = $82
A_value         = $83
left_value      = $84
right_value     = $85


; ====================== ;
; ===== Interrupts ===== ;
; ====================== ;

reset:
        stz start_pedge
        stz start_value
        stz A_pedge
        stz A_value
        stz left_value
        stz right_value
        rts

do_logic:
        jsr getInput
        stp
        rts

fill_vram:
        rts

; ====================== ;
; ======== Logic ======= ;
; ====================== ;

getInput:
        lda start_value
        eor #1
        sta INT8_G1     ; !start_value
        c1START
        and INT8_G1
        sta start_pedge

        c1START
        sta start_value

        lda A_value
        eor #1
        sta INT8_G1
        c1A
        and INT8_G1
        sta A_pedge

        c1A
        sta A_value

        c1LEFT
        sta left_value

        c1RIGHT
        sta right_value

        rts
