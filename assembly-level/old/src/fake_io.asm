
        .org _IN_VBLANK
        .byte 1

        .org _CLR_VBLANK_IRQ
        .byte 0

        .org CONTROLLER_1
;              a
;              |b
;              ||select
;              |||start
;              ||||up
;              |||||down
;              ||||||left
;              |||||||right
        .byte %0000001

        .org CONTROLLER_2
;              a
;              |b
;              ||select
;              |||start
;              ||||up
;              |||||down
;              ||||||left
;              |||||||right
        .byte %00000000
