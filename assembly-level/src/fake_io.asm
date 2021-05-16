
        .org _IN_VBLANK
        .byte 1

        .org _CLR_VBLANK_IRQ
        .byte 0

        .org CONTROLLER_1
        .byte %01000001

        .org CONTROLLER_2
        .byte %01000001
