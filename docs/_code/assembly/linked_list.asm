
; ===== Labels ===== ;

zp_pointer      = $1e

HeadPointer     = $2000
IPointer        = $2002

; ===== Constants ===== ;

value           .= $ee


; ===== Macro Definitions ===== ;

ldadr   .macro ptr              ; load address from pointer to zp
        lda ptr+1
        sta zp_pointer+1
        lda ptr
        sta zp_pointer
        .endm


; ===== Program Start ===== ;

        .org $8000

; initialize HeadPointer and IPointer
        lda #$12
        sta HeadPointer+1
        lda #$34
        sta HeadPointer         ; linked list head pointer now has address $1234

        lda HeadPointer+1
        sta IPointer+1
        lda HeadPointer
        sta IPointer            ; copy Head pointer into Index pointer


; loop through all nodes in linked list and set all values to #value
loop:
        ldadr IPointer
        lda #value
        sta (zp_pointer)        ; set value of node to #value

        ldx #2
        lda (zp_pointer,X)
        sta IPointer+1
        dex
        lda (zp_pointer,X)
        sta IPointer            ; set IPointer to next pointer
        
        lda IPointer+1
        ora IPointer
        bne loop                ; while ( IPointer != 0 ), repeat
