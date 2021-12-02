// Define all VRAM component arrays in the proper memory segments corresponding
// to their memory map location
#include "vram.h"

#pragma bss-name ("PMF")
pattern_t PMF[32];

#pragma bss-name ("PMB")
pattern_t PMB[32];

#pragma bss-name ("NTBL")
tile_t NTBL[30][32];
background_palette_t background_palette;

#pragma bss-name ("OBM")
object_t OBM[32];
