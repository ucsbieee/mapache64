
; file assembles to 32761 bytes (the maximum amount)

        .repeat 32760
        nop
        .endr

reset:
do_logic:
fill_vram:
        rts
