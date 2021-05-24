
        .org _IN_VBLANK
        .byte 1

        .org _CLR_VBLANK_IRQ
        .byte 0

        .org CONTROLLER_1
;              select
;              |start
;              ||right
;              |||left
;              ||||down
;              |||||up
;              ||||||b
;              |||||||a
        .byte %00010000

        .org CONTROLLER_2
;              select
;              |start
;              ||right
;              |||left
;              ||||down
;              |||||up
;              ||||||b
;              |||||||a
        .byte %00000000
