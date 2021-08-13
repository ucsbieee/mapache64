
; NMI (disabled)
_handle_nmi:
        rti



; reset
_handle_reset:
        sei                     ; disble irq by default
        lda #$ff
        sta FRAME
        sta FRAME+1
        sta FRAME+2
        sta FRAME+3
        jsr reset
_next_frame:    ; handle frame timing
        inc_mem FRAME, 4        ; increment frame count
        jsr do_logic            ; do non-vram logic

        wai                     ; wait for interrupt
        cli                     ; enable irq (irq is immediately handled)
        jsr fill_vram           ; fill vram while in vblank
        sei                     ; disble irq
        jmp _next_frame         ; repeat



; IRQ
_handle_irq:
_vblank_irq:    ; wait for vblank; clear irq and return
        pha

.check_if_in_vblank:
        lda _IN_VBLANK
        bne .in_vblank          ; if in vblank, return
        stz _CLR_VBLANK_IRQ     ; otherwise, clear interrupt,
        wai                     ;   wait for next interrupt
        jmp .check_if_in_vblank ;   and check again

.in_vblank:
        stz _CLR_VBLANK_IRQ     ; clear interrupt
        pla
        rti
