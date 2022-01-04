
.segment "FIRMWARE_CODE"

.import _FPGA_FW_HEADER, _ROM_FW_HEADER, _TXBL, _background_palette
.export verify_firmware


.proc verify_firmware
        pha
        tya
        pha

        ldy #0
loop:
        ; check if they are equal
        lda _FPGA_FW_HEADER,Y
        cmp _ROM_FW_HEADER,Y
        bne not_equal

        ; check if they are '\0'
        lda #0
        cmp _FPGA_FW_HEADER,Y
        beq exit

        ; increment address
        iny
        bne loop

too_long:
not_equal:
        jmp handle_bad_firmware

exit:
        pla
        tay
        pla
        rts
.endproc


handle_bad_firmware:
        wai
        cli
        lda #$80|'F'
        sta _TXBL
        stz _background_palette
        stp
