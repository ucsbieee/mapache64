
; ===== Devices ===== ;

; VRAM

_PMF1           = $3700 ; Pattern Memory Foreground page1
_PMF2           = $3800 ; Pattern Memory Foreground page2
_PMB1           = $3900 ; Pattern Memory Background page1
_PMB2           = $3a00 ; Pattern Memory Background page2
_NTBL1          = $3b00 ; Nametable page1
_NTBL2          = $3c00 ; Nametable page2
_NTBL3          = $3d00 ; Nametable page3
_NTBL4          = $3e00 ; Nametable page4
_NTBL_COLORS    = $3ec0 ; Nametable Colors
_OBM            = $3f00 ; Object Memory

_FIRMWARE_START = $4000

_ROM_START      = $8000

; ===== Zero Page ===== ;

INT8_G1         = $00   ; 1 byte
INT8_G2         = $01   ; 1 byte
INT8_G3         = $02   ; 1 byte
INT8_G4         = $03   ; 1 byte
INT8_G5         = $04   ; 1 byte
INT8_I1         = $05   ; 1 byte
INT8_I2         = $06   ; 1 byte
INT8_O          = $07   ; 1 byte

INT16_G1        = $08   ; 2 bytes
INT16_G2        = $0a   ; 2 bytes
INT16_G3        = $0c   ; 2 bytes
INT16_G4        = $0e   ; 2 bytes
INT16_G5        = $10   ; 2 bytes
INT16_I1        = $12   ; 2 bytes
INT16_I2        = $14   ; 2 bytes
INT16_O         = $16   ; 2 bytes

Q9_6_G1         = $18   ; 2 bytes
Q9_6_G2         = $1a   ; 2 bytes
Q9_6_G3         = $1c   ; 2 bytes
Q9_6_G4         = $1e   ; 2 bytes
Q9_6_G5         = $20   ; 2 bytes
Q9_6_I1         = $22   ; 2 bytes
Q9_6_I2         = $24   ; 2 bytes
Q9_6_O          = $26   ; 2 bytes

ADDRESS16_1     = $28   ; 2 bytes
ADDRESS16_2     = $2a   ; 2 bytes
ADDRESS16_3     = $2c   ; 2 bytes
ADDRESS16_4     = $2e   ; 2 bytes

FRAME           = $30   ; 3 bytes

; ===== IO ===== ;

_IO_START       = $7000
_IN_VBLANK      = $7000 ; 1 byte
_CLR_VBLANK_IRQ = $7001 ; 1 byte
