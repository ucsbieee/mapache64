
; NMI (disabled)

_handle_nmi:
        rti



; reset

_handle_reset:
        jsr reset
_next_frame:    ; handle frame timing
        sei                     ; disble irq
        jsr do_logic
        cli                     ; enable irq
        wai
        jsr fill_vram
        jmp _next_frame



; IRQ

_handle_irq:
_vblank_irq:    ; wait for vblank; clear irq and return
        pha
.poll:
        lda _IN_VBLANK
        beq .poll               ; keep looping while not in vblank

        stz _CLR_VBLANK_IRQ     ; clear interrupt
        pla
        rti
