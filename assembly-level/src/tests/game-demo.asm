

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
person_yp               = $88


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
        jsr getInput
        rts

fill_vram:
        lda vram_initialized
        bne .exit
        jsr vram_initialize
.exit
        stp
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

person_initialize:
        lda #128
        sta person_xp   ; person_xp = 128
        sta person_yp   ; person_yp = 128
        rts

; ====================== ;
; ======== VRAM ======== ;
; ====================== ;


vram_initialize:
        jsr clear_OBM

        ; load in NORMAL sprite to PMF
        ldlab16 ADDRESS16_1, NORMAL_P
        ldlab16 ADDRESS16_2, NORMAL_S
        lda #16
        sta INT8_I1
        jsr transfer_mem

        ; load in LOOPING_UP sprite to PMF
        ldlab16 ADDRESS16_1, LOOKING_UP_P
        ldlab16 ADDRESS16_2, LOOKING_UP_S
        jsr transfer_mem

        ; set character position in OMB
        lda person_xp
        sta PERSON_O+0
        lda person_yp
        sta PERSON_O+1
        stz PERSON_O+2
        lda #%110
        sta PERSON_O+3

        ; set vram_initialized to true
        lda #1
        sta vram_initialized
        rts


clear_OBM:
        lda #255
        ldlab16 ADDRESS16_1, _OBM
        ldy #0
.loop
        iny
        sta (ADDRESS16_1),Y
        iny
        iny
        iny
        bne .loop

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
