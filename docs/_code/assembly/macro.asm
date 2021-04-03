; copy byte at src to dst
cp8     .macro src, dst
        lda src
        sta dst
        .endm