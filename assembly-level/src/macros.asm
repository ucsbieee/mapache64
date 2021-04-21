
; NP means registers are Not Preserved

; stop
        .if __KOWALSKI__
stp     .macro
        .byte $db
        .endm
        .endif

; copy byte at src to dst
cp8NP   .macro src, dst
        lda src
        sta dst
        .endm

cp8     .macro src, dst
        pha
        cp8NP src, dst
        pla
        .endm

; copy word at src to dst
cp16NP  .macro src, dst
        cp8NP src+1, dst+1 ; copy LSB
        cp8NP src, dst     ; COPY MSB
        .endm

cp16    .macro src, dst
        pha
        cp16NP src, dst
        pla
        .endm

; swap bytes at t1 and t2
swp8NP  .macro t1, t2
        lda t1
        pha             ; stack.push( t1 )
        lda t2
        sta t1          ; t1 <= t2
        pla
        sta t2          ; t2 <= stack.pull()
        .endm

swp8    .macro t1, t2
        pha
        sw8NP t1, t2
        pla
        .endm

; swap words at t1 and t2
swpNP   .macro t1, t2
        swp8NP t1+1, t2+1
        swp8NP t1, t2
        .endm

swp16   .macro t1, t2
        pha
        swp16NP t1, t2
        pla
        .endm
