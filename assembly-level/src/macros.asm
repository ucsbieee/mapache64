
; All macros must be added both for VASM and Kowalski's.
; Note, they have slightly different syntax.

; NP means registers are Not Preserved

; ====================== ;
; ===== Kowalski's ===== ;
; ====================== ;
        .if __KOWALSKI__
; ====================== ;

; ===== Missing from Kowalski's ===== ;

; stop
stp     .macro
        .byte $db
        .endm

; wait for interrupt
wai     .macro
        .byte $cb
        .endm

; ===== General ===== ;

; copy byte at src to dst
cp8NP   .macro src, dst
        lda src
        sta dst
        .endm

; copy byte at src to dst
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

; copy word at src to dst
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

; swap bytes at t1 and t2
swp8    .macro t1, t2
        pha
        swp8NP t1, t2
        pla
        .endm

; swap words at t1 and t2
swp16NP .macro t1, t2
        swp8NP t1+1, t2+1
        swp8NP t1, t2
        .endm

; swap words at t1 and t2
swp16   .macro t1, t2
        pha
        swp16NP t1, t2
        pla
        .endm

; increment memory with specified size
inc_mem .macro address, length
.i      .set 0
        .repeat length
        inc address+.i
        bne .end_inc
.i      .set .i+1
        .endr
.end_inc:
        .endm


; ====================== ;
        .endif
; ====================== ;
; ======== VASM ======== ;
; ====================== ;
        .if __VASM__
; ====================== ;

; ===== General ===== ;

; copy byte at src to dst
cp8NP   .macro src, dst
        lda \src
        sta \dst
        .endm

; copy byte at src to dst
cp8     .macro src, dst
        pha
        cp8NP \src, \dst
        pla
        .endm

; copy word at src to dst
cp16NP  .macro src, dst
        cp8NP \src+1, \dst+1    ; copy LSB
        cp8NP \src, \dst        ; COPY MSB
        .endm

; copy word at src to dst
cp16    .macro src, dst
        pha
        cp16NP \src, \dst
        pla
        .endm

; swap bytes at t1 and t2
swp8NP  .macro t1, t2
        lda \t1
        pha             ; stack.push( t1 )
        lda \t2
        sta \t1         ; t1 <= t2
        pla
        sta \t2         ; t2 <= stack.pull()
        .endm

; swap bytes at t1 and t2
swp8    .macro t1, t2
        pha
        swp8NP \t1, \t2
        pla
        .endm

; swap words at t1 and t2
swp16NP .macro t1, t2
        swp8NP \t1+1, \t2+1
        swp8NP \t1, \t2
        .endm

; swap words at t1 and t2
swp16   .macro t1, t2
        pha
        swp16NP \t1, \t2
        pla
        .endm

; increment memory with specified size
inc_mem .macro address, length
.endinc .set .endinc\@
.i      .set \address
        .repeat \length
        inc .i
        bne .endinc
.i      .set .i+1
        .endr
.endinc\@:
        .endm


; ====================== ;
        .endif
