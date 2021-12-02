; Simulates activity in the memory segment associated with the game controllers
.segment "IO"

.export _IN_VBLANK, _CLR_VBLANK_IRQ, _CONTROLLER_1, _CONTROLLER_2

_IN_VBLANK:
        .byte 1 ; simulation purposes only

_CLR_VBLANK_IRQ:
        .byte 0

_CONTROLLER_1:
;              a
;              |b
;              ||select
;              |||start
;              ||||up
;              |||||down
;              ||||||left
;              |||||||right
        .byte %0000000

_CONTROLLER_2:
;              a
;              |b
;              ||select
;              |||start
;              ||||up
;              |||||down
;              ||||||left
;              |||||||right
        .byte %00000000
