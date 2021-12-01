
; ====================== ;
; ======= Header ======= ;
; ====================== ;

        .byte "Draw Demo\n"
        .byte "You should see 64 objects.\n"
        .byte 0


; ====================== ;
; ======= Labels ======= ;
; ====================== ;


; === Person === ;

person_xp               = $87
person_xv               = $89
person_yp               = $8b
person_yv               = $8d

; constants
person_xp_initial       = %0010000000000000     ; 128
person_yp_initial       = %0010000000000000     ; 128



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
        jsr person_initialize
        rts





;==========================;
        .org do_logic
;==========================;
        rts





;==========================;
        .org fill_vram
;==========================;
        jsr vram_initialize

STOP:
        stp     ; Stop

        rts





; ====================== ;
; ======== Logic ======= ;
; ====================== ;






person_initialize:
        ldlab16 person_xp_initial, person_xp
        ldlab16 person_yp_initial, person_yp
        ldlab16 $0000, person_xv
        ldlab16 $0000, person_yv
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

.object_i       .set 0
        .repeat 64
.object         .set _OBM + .object_i*4
.object_x       .set (.object_i << 3) & $ff
.object_y       .set (.object_i/32)*8
        ; set flip-modifiers and pattern
        lda #0|NORMAL_PMFA
        sta .object+2

        ; set color
        lda #%110
        sta .object+3

        ; load person_xp
        lda #0|.object_x
        sta .object

        ; load person_yp
        lda #0|.object_y
        sta .object+1

.object_i       .set .object_i+1
        .endr
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
