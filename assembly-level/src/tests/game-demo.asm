

; ====================== ;
; ======= Labels ======= ;
; ====================== ;


; === Misc. === ;

vram_initialized        = $80


; === Input === ;

start_pedge             = $81
start_value             = $82
A_pedge                 = $83
A_value                 = $84
left_value              = $85
right_value             = $86


; === Person === ;

person_xp               = $87
person_xv               = $89
person_yp               = $8b
person_yv               = $8d

; constants
horizonal_speed         = %0000000001110000     ; 1.7
person_xp_initial       = %0010000000000000     ; 128
person_yp_initial       = %0010000000000000     ; 128


; === VRAM Labels === ;

PERSON_O                = _OBM+0

NORMAL_S                = _PMF1+0
LOOKING_UP_S            = _PMF1+16





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

        stz vram_initialized
        jsr person_initialize
        rts





do_logic:
        ; update start_pedge, A_pedge, left_value, right_value
        jsr getInput

        ; if start was pressed, reset
        lda start_pedge
        beq .dont_reset
        jsr reset
        rts
.dont_reset:

        ; if a was pressed, jump
        lda A_pedge
        beq .dont_jump
        jsr person_jump
.dont_jump:

        ; if left was pressed, go left
        lda left_value
        beq .dont_go_left
        cp16 person_xv, person_xv
        ldlab16 horizonal_speed, Q9_6_I2
        jsr addQ9_6
        cp16 Q9_6_O, person_xv
.dont_go_left:

        ; if right was pressed, go right
        lda right_value
        beq .dont_go_right
        cp16 person_xv, Q9_6_I1
        ldlab16 horizonal_speed, Q9_6_I2
        jsr subQ9_6
        cp16 Q9_6_O, person_xv
.dont_go_right:

        ; move person
        jsr person_advance

        rts





fill_vram:
        lda vram_initialized
        bne .after_vram_initialized
        jsr vram_initialize
.after_vram_initialized:

        jsr person_draw
.exit:
        stp
        rts





; ====================== ;
; ======== Logic ======= ;
; ====================== ;

getInput:
        ; start_pedge
        lda start_value
        eor #1
        sta INT8_G1     ; !start_value
        c1START
        and INT8_G1
        sta start_pedge

        ; start_value
        c1START
        sta start_value

        ; A_pedge
        lda A_value
        eor #1
        sta INT8_G1
        c1A
        and INT8_G1
        sta A_pedge

        ; A_value
        c1A
        sta A_value

        ; left_value
        c1LEFT
        sta left_value

        ; right_value
        c1RIGHT
        sta right_value

        rts





person_initialize:
        lda #128
        ldlab16 person_xp_initial, person_xp
        ldlab16 person_yp_initial, person_yp
        ldlab16 $0000, person_xv
        ldlab16 $0000, person_yv
        rts





person_jump:
        ; TO DO
        rts





person_advance:
        ; TO DO
        rts





; ====================== ;
; ======== VRAM ======== ;
; ====================== ;

vram_initialize:
        jsr clear_OBM

        ; load in NORMAL sprite to PMF
        ldlab16 NORMAL_P, ADDRESS16_1
        ldlab16 NORMAL_S, ADDRESS16_2
        lda #16
        sta INT8_I1
        jsr transfer_mem

        ; load in LOOPING_UP sprite to PMF
        ldlab16 LOOKING_UP_P, ADDRESS16_1
        ldlab16 LOOKING_UP_S, ADDRESS16_2
        jsr transfer_mem

        ; set character position in OMB
        stz PERSON_O+2
        lda #%110
        sta PERSON_O+3

        ; set vram_initialized to true
        lda #1
        sta vram_initialized
        rts





clear_OBM:
        lda #255
        ldlab16 _OBM, ADDRESS16_1
        ldy #0
.loop
        iny
        sta (ADDRESS16_1),Y
        iny
        iny
        iny
        bne .loop

        rts





person_draw:
        ; load person_xp
        cp16 person_xp, Q9_6_I1
        jsr Q9_6_to_SINT8
        cp8 INT8_O, PERSON_O

        ; load person_yp
        cp16 person_yp, Q9_6_I1
        jsr Q9_6_to_SINT8
        cp8 INT8_O, PERSON_O+1

        rts





; ======== Patterns ======== ;

NORMAL_P:
        .db %00001010, %10100000
        .db %00101111, %11111000
        .db %00101111, %11111000
        .db %10110111, %11011110
        .db %10110111, %11011110
        .db %10111111, %11111110
        .db %00101111, %11111000
        .db %00001010, %10100000

LOOKING_UP_P:
        .db %00001010, %10100000
        .db %00101111, %11111000
        .db %00101111, %11111000
        .db %10111111, %11111110
        .db %10110111, %11011110
        .db %10110111, %11011110
        .db %00101111, %11111000
        .db %00001010, %10100000
