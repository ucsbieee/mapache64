
; will loop on reset
_handle_reset:
pause1: jmp pause1

; will loop on nmi
_handle_nmi:
pause2: jmp pause2

; will loop on irq
_handle_irq:
pause3: jmp pause3
