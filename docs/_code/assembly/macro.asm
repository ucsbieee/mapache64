
; ===== Macro Definitions ===== ;

nop3:   .macro      ; macro definition to nop three times
        nop
        nop
        nop
        .endm       ; end macro definition


; ===== Program Start ===== ;

        .org $8000  ; set program start to address $8000

        nop         ; run one nop
        nop3        ; run three nops
