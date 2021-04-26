
; NMI (disabled)

_handle_nmi:
        rti



; reset

_handle_reset:
        lda #$ff
        sta FRAME
        sta FRAME+1
        sta FRAME+2
        jsr reset
_next_frame:    ; handle frame timing
        sei                     ; disble irq
        inc_mem FRAME, 3        ; set frame to next value
        jsr do_logic            ; do non-vram logic

        cli                     ; enable irq
        wai                     ; wait for draw irq
        jsr fill_vram           ; fill vram while in vblank
        jmp _next_frame         ; repeat



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
