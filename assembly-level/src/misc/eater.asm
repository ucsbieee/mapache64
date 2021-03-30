; https://youtu.be/oO8_2JJV0B4

        .org $8000      ; ROM takes up address $8000 - $ffff

; === Entrypoint === ;
entrypoint:

        lda #$ff
        sta $6002       ; set 6522 PA to output

        lda #$55        ; alternating bits
        sta $6000       ; send to 6522

loop:
        ror             ; rotate bits
        sta $6000       ; send to 6522

        jmp loop        ; continue rotating


; === Set Entrypoint === ;

        .org $fffc      ;
        .word entrypoint; 6502 expects entrypoint address at fffc
        .word $0000     ; padding
