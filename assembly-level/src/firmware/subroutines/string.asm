
; compare strings at ADDRESS16_1 and ADDRESS16_2 (not preserved)
; put comparison in A
strcmp:
        ldy #0
.loop:
        ; check if they are equal
        lda (ADDRESS16_1),Y
        cmp (ADDRESS16_2),Y
        bne .exit

        ; check if they are '\0'
        lda #0
        cmp (ADDRESS16_1),Y
        beq .exit

        ; increment address
        iny
        bne .loop
.next:
        ; add 256 to address
        inc ADDRESS16_1+1
        inc ADDRESS16_2+1
        jmp strcmp
.exit:
        rts
