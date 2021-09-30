
; This is the main file for assembly. Run all assembly code through this file.
; > Set your tool in "options.asm"
; > Set the src for your rom in "rom.asm"

; ====== options ====== ;
        .include "options.asm"

        .if __VASM__ && __KOWALSKI__
        .error "Cannot select both VASM and Kowalski"
        .endif
        .if !__VASM__ && !__KOWALSKI__
        .error "Must select either VASM or Kowalski"
        .endif

        ; VASM settings
        .if __VASM__
        .endif

        ; Kowalski settings
        .if __KOWALSKI__
        .opt Proc65c02, CaseSensitive, SwapBin
        .endif

; ====== labels ====== ;
        .include "macros.asm"
        .include "labels.asm"

; ====== start ====== ;
        .org 0

; ====== RAM ====== ;
        .include "zero_page.asm"

; ====== firmware ====== ;
        .org _FIRMWARE_START
        .include "firmware/header.asm"

        .include "firmware/interrupts.asm"

        .include "firmware/subroutines/add.asm"
        .include "firmware/subroutines/subtract.asm"
        .include "firmware/subroutines/multiply.asm"
        .include "firmware/subroutines/divide.asm"
        .include "firmware/subroutines/Q9_6.asm"
        .include "firmware/subroutines/transfer_mem.asm"
        .include "firmware/subroutines/string.asm"

; ====== IO ====== ;
        .org _IO_START

        .include "fake_io.asm"

; ====== ROM ====== ;
        .org _ROM_START
        .include "firmware/header.asm"

        .include "rom.asm"
        stp

        ; set 65c02 vector locations
        .org $fffa
        .word _handle_nmi
        .word _handle_reset
        .word _handle_irq
