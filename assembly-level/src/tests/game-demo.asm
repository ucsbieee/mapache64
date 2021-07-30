

; ====================== ;
; ======= Labels ======= ;
; ====================== ;


; === Misc. === ;

vram_initialized        = $80

ground                  = %0011100000000000     ; 224
gravity                 = %0000000000010100     ; 0.3125
weakgravity             = %0000000000000100     ; 0.0625


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
person_xp_initial       = %0010000000000000     ; 128
person_yp_initial       = %0010000000000000     ; 128

jump_strength           = %0000000101000000     ; 5
walljump_strength       = %0000001010000000     ; 10

horizonal_speed         = %0000000001110000     ; 1.75
gnd_horizonal_deccel    = %0000000001100000     ; 1.5
air_horizonal_deccel    = %0000000000001001     ; 1.4065


; === VRAM Labels === ;

; objects
PERSON_O                = _OBM+0

; PMF addresses
NORMAL_PMFA             = 0
LOOKING_UP_PMFA         = 1

; sprite addresses
NORMAL_S                = _PMF1 + NORMAL_PMFA * 16
LOOKING_UP_S            = _PMF1 + LOOKING_UP_PMFA * 16

; PMB addresses
BLACK_PMBA              = 0
DARK_GRAY_PMBA          = 1
LIGHT_GRAY_PMBA         = 2
WHITE_PMBA              = 3

; tile addresses
BLACK_T                 = _PMB1 + BLACK_PMBA * 16
DARK_GRAY_T             = _PMB1 + DARK_GRAY_PMBA * 16
LIGHT_GRAY_T            = _PMB1 + LIGHT_GRAY_PMBA * 16
WHITE_T                 = _PMB1 + WHITE_PMBA * 16





; ====================== ;
; ===== Interrupts ===== ;
; ====================== ;

;==========================;
        .org reset
;==========================;

        stz start_pedge
        stz start_value
        stz A_pedge
        stz A_value
        stz left_value
        stz right_value

        stz vram_initialized
        jsr person_initialize
        rts





;==========================;
        .org do_logic
;==========================;

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





;==========================;
        .org fill_vram
;==========================;

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
        cp16 person_yp Q9_6_I1
        cp16 ground Q9_6_I2
        jsr subQ9_6
        ; TO DO

        rts





person_advance:
        ; TO DO
        rts





; ====================== ;
; ======== VRAM ======== ;
; ====================== ;

vram_initialize:

        ; initialize each section of VRAM
        jsr pmf_initialize
        jsr pmb_initialize
        jsr ntbl_initialize
        jsr obm_initialize

        ; set vram_initialized to true
        lda #1
        sta vram_initialized
        rts




; set all object y positions to 0xff
obm_clear:
        ldlab16 _OBM, ADDRESS16_1
        lda #$ff
        ldy #0
.loop
        iny
        sta (ADDRESS16_1),Y
        iny
        iny
        iny
        bne .loop

        rts

obm_initialize:
        ; reset OBM
        jsr obm_clear

        ; set flip-modifiers and pattern
        lda #0|NORMAL_PMFA
        sta PERSON_O+2

        ; set color
        lda #%110
        sta PERSON_O+3

        rts





pmf_initialize:
        ; sprites are 16 bytes
        lda #16
        sta INT8_I1

        ; load NORMAL sprite
        ldlab16 NORMAL_P, ADDRESS16_1
        ldlab16 NORMAL_S, ADDRESS16_2
        jsr transfer_mem

        ; load LOOPING_UP sprite
        ldlab16 LOOKING_UP_P, ADDRESS16_1
        ldlab16 LOOKING_UP_S, ADDRESS16_2
        jsr transfer_mem

        rts





pmb_initialize:
        ; tiles are 16 bytes
        lda #16
        sta INT8_I1

        ; load BLACK tile
        ldlab16 BLACK_P, ADDRESS16_1
        ldlab16 BLACK_T, ADDRESS16_2
        jsr transfer_mem

        ; load DARK_GRAY tile
        ldlab16 DARK_GRAY_P, ADDRESS16_1
        ldlab16 DARK_GRAY_T, ADDRESS16_2
        jsr transfer_mem

        ; load LIGHT_GRAY tile
        ldlab16 LIGHT_GRAY_P, ADDRESS16_1
        ldlab16 LIGHT_GRAY_T, ADDRESS16_2
        jsr transfer_mem

        ; load WHITE tile
        ldlab16 WHITE_P, ADDRESS16_1
        ldlab16 WHITE_T, ADDRESS16_2
        jsr transfer_mem

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





ntbl_initialize:
        ; set colors
        lda #0|CYAN_C0|GREEN_C1
        sta _NTBL_COLORS

        ; load in scanlines
        ; scalines are 32 bytes
        lda #32
        sta INT8_I1
        ; set up incrementing by 32
        ldlab16 32, INT16_I2
        ldlab16 _NTBL1, INT16_O


        ; sky
        ldlab16 SKY_SCANLINE, ADDRESS16_1
        lda #28
        sta INT8_G1
.sky_loop:
        ; copy sky scanline to nametable
        cp16 INT16_O, ADDRESS16_2
        jsr transfer_mem

        ; calculate next NTBL address
        cp16 INT16_O, INT16_I1
        jsr add16

        dec INT8_G1
        bne .sky_loop


        ; ground
        ldlab16 GROUND_SCANLINE, ADDRESS16_1
        lda #2
        sta INT8_G1
.ground_loop:
        ; copy sky scanline to nametable
        cp16 INT16_O, ADDRESS16_2
        jsr transfer_mem

        ; calculate next NTBL address
        cp16 INT16_O, INT16_I1
        jsr add16

        dec INT8_G1
        bne .ground_loop


        rts





; ======== Patterns ======== ;

PATTERN_START:

BLACK_P:
        .db $00, $00
        .db $00, $00
        .db $00, $00
        .db $00, $00
        .db $00, $00
        .db $00, $00
        .db $00, $00
        .db $00, $00

DARK_GRAY_P:
        .db $55, $55
        .db $55, $55
        .db $55, $55
        .db $55, $55
        .db $55, $55
        .db $55, $55
        .db $55, $55
        .db $55, $55

LIGHT_GRAY_P:
        .db $aa, $aa
        .db $aa, $aa
        .db $aa, $aa
        .db $aa, $aa
        .db $aa, $aa
        .db $aa, $aa
        .db $aa, $aa
        .db $aa, $aa

WHITE_P:
        .db $ff, $ff
        .db $ff, $ff
        .db $ff, $ff
        .db $ff, $ff
        .db $ff, $ff
        .db $ff, $ff
        .db $ff, $ff
        .db $ff, $ff

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


; ======== Nametable Data ======== ;

SKY_SCANLINE:
        .repeat 32
        .db WHITE_PMBA
        .endr

GROUND_SCANLINE:
        .repeat 32
        .db LIGHT_GRAY_PMBA | COLOR_ALT
        .endr
