
; ===== Devices ===== ;

; VRAM
_PMF1           = $3700
_PMF2           = $3800
_PMB1           = $3900
_PMB2           = $3a00
_NTBL1          = $3b00
_NTBL2          = $3c00
_NTBL3          = $3d00
_NTBL4          = $3e00
_NTBL_COLORS    = $3ec0
_OMB            = $3f00

_FIRMWARE_START = $4000

_VIA_START      = $7000

_ROM_START      = $8000

; ===== Zero Page ===== ;

INT8_G1         = $00
INT8_G2         = $01
INT8_G3         = $02
INT8_G4         = $03
INT8_G5         = $04
INT8_I1         = $05
INT8_I2         = $06
INT8_O          = $07

INT16_G1        = $08
INT16_G2        = $0a
INT16_G3        = $0c
INT16_G4        = $0e
INT16_G5        = $10
INT16_I1        = $12
INT16_I2        = $14
INT16_O         = $16

Q9_6_G1         = $18
Q9_6_G2         = $1a
Q9_6_G3         = $1c
Q9_6_G4         = $1e
Q9_6_G5         = $20
Q9_6_I1         = $22
Q9_6_I2         = $24
Q9_6_O          = $26

ADDRESS16_1     = $28
ADDRESS16_2     = $2a
ADDRESS16_3     = $2c
ADDRESS16_4     = $2e
