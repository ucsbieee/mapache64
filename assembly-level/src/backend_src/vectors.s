; ---------------------------------------------------------------------------
; vectors.s
; ---------------------------------------------------------------------------
;
; Defines the interrupt vector table.

.import _handle_nmi, _handle_reset, _handle_irq
.import _game_reset, _do_logic, _fill_vram
.export GAME_RESET_VECTOR, DO_LOGIC_VECTOR, FILL_VRAM_VECTOR

.segment  "GAMEVECTORS"

GAME_RESET_VECTOR:
.addr      _game_reset
DO_LOGIC_VECTOR:
.addr      _do_logic
FILL_VRAM_VECTOR:
.addr      _fill_vram


.segment  "VECTORS"

.addr      _handle_nmi
.addr      _handle_reset
.addr      _handle_irq
