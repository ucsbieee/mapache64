
; NMI (disabled)
_handle_nmi:
        rti



; reset
_handle_reset:
        sei                     ; disble irq by default

        ; confirm that firmware is correct
        ldlab16 _FIRMWARE_START, ADDRESS16_1
        ldlab16 _ROM_START, ADDRESS16_2
        jsr strcmp
        beq .continue
        stp
.continue:

        ;  reset frame counter
        lda #$ff
        sta FRAME
        sta FRAME+1
        sta FRAME+2
        sta FRAME+3

        ; game reset
        jsr reset

_next_frame:    ; handle frame timing
        inc_mem FRAME, 4        ; increment frame count
        jsr do_logic            ; do non-vram logic

        wai                     ; wait for interrupt
        cli                     ; enable irq (irq is immediately handled)
        jsr fill_vram           ; enter fill_vram with interrupts on
        sei                     ; disble irq
        jmp _next_frame         ; repeat



; IRQ
_handle_irq:
_vblank_irq:    ; wait for vblank; clear irq and return
        pha

.check_if_in_vblank:
        stz _CLR_VBLANK_IRQ     ; clear interrupt
        lda _IN_VBLANK
        bne .in_vblank          ; if in vblank, return
        wai                     ; otherwise,    wait for next interrupt,
        jmp .check_if_in_vblank ;               check if in vblank again

.in_vblank:
        pla
        rti
