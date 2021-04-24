
_handle_irq:
_vblank_irq:
        pha
.poll:
        lda _IN_VBLANK
        beq .poll               ; keep looping while not in vblank

        stz _CLR_VBLANK_IRQ     ; clear interrupt
        pla
        rti

_handle_reset:
_next_frame:
        sei                     ; disble irq
        jsr do_logic
        cli                     ; enable irq
        wai
        jsr fill_vram
        jmp _next_frame

_handle_nmi:
        stp
