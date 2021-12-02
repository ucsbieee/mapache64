; ---------------------------------------------------------------------------
; crt0.s
; ---------------------------------------------------------------------------
;
; Startup code for cc65 (Single Board Computer version)



; ========= Helper Macros ========= ;

; increment memory with length
.macro  inc_mem         address, length

        .if length = 1
        inc address
        .exitmacro
        .endif

        .local end_inc
        inc address
        bne end_inc            ; increment next if overflow occurred

        inc_mem {address+1}, {length-1}

end_inc:
        .endmacro





; ========= Code ========= ;


.export _handle_reset, _handle_irq, _handle_nmi
.import GAME_RESET_VECTOR, DO_LOGIC_VECTOR, FILL_VRAM_VECTOR
.import _CLR_VBLANK_IRQ, _IN_VBLANK

.import verify_firmware

.export __STARTUP__ : absolute = 1

.importzp _FRAME

.segment "STARTUP"


; NMI (disabled)
_handle_nmi:
        rti



; reset, program entry point
_handle_reset:


        sei                     ; disble irq by default
        ldx #$ff                ; Initialize stack pointer to $01ff
        txs
        cld                     ; Clear decimal mode

        ;  reset frame counter
        lda #$ff
        sta _FRAME
        sta _FRAME+1
        sta _FRAME+2
        sta _FRAME+3

        ; verify firmware is correct
        jsr verify_firmware

        ; game reset
        jsr jump_to_game_reset

; game loop
next_frame:    ; handle frame timing
        inc_mem {_FRAME}, {4}   ; increment frame count
        jsr jump_to_do_logic    ; do non-vram logic

        wai                     ; wait for interrupt
        cli                     ; enable irq (irq is immediately handled)
        jsr jump_to_fill_vram   ; enter fill_vram with interrupts on
        sei                     ; disble irq
        jmp next_frame          ; repeat




; IRQ
_handle_irq:
_vblank_irq:    ; wait for vblank; clear irq and return
        pha

check_if_in_vblank:
        stz _CLR_VBLANK_IRQ     ; clear interrupt
        lda _IN_VBLANK
        bne in_vblank           ; if in vblank, return
        wai                     ; otherwise,    wait for next interrupt,
        jmp check_if_in_vblank  ;               check if in vblank again

in_vblank:
        pla
        rti



jump_to_game_reset:
        jmp (GAME_RESET_VECTOR)
jump_to_do_logic:
        jmp (DO_LOGIC_VECTOR)
jump_to_fill_vram:
        jmp (FILL_VRAM_VECTOR)
