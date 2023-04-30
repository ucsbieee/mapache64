
// Definition of VRAM segments
#include "vram.h"

#pragma bss-name ("PMF")
pattern_t PMF[32];

#pragma bss-name ("PMB")
pattern_t PMB[32];

#pragma bss-name ("NTBL")
tile_t NTBL[30][32];
background_palette_t background_palette;

#pragma bss-name ("OBM")
object_t OBM[64];

#pragma bss-name ("TXBL")
tile_t TXBL[30][32];
