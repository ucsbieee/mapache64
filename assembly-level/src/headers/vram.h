
// Declare all types and variables associated with modifying VRAM

// For more details, see: https://mapache64.ucsbieee.org/guides/gpu/
#ifndef __VRAM_H
#define __VRAM_H

#include "int.h"



// 8x8px pattern
typedef uint8_t pattern_t[16];

// Data for each tile in the NTBL
typedef uint8_t tile_t;

// Data for each character in the TXBL
typedef uint8_t char_tile_t;

// The two usable colors the background tiles
typedef uint8_t background_palette_t;

// Defines the placement and coloring of a single sprite
typedef struct object_s {
    uint8_t x; // Pixels from the left of the screen
    uint8_t y; // Pixels from the top of the screen
    uint8_t pattern_config; // Sprite transform and pattern memory index
    uint8_t color; // RGB color
} object_t;



extern pattern_t PMF[32]; // Pattern Memory Foreground

extern pattern_t PMB[32]; // Pattern Memory Background

extern tile_t NTBL[30][32]; // NameTaBLe
extern background_palette_t background_palette;

extern object_t OBM[64]; // OBject Memory

extern tile_t TXBL[30][32]; // TeXt taBLe



// Char tile masks
#define CHAR_VALUE_MASK         ((uint8_t)0x7f)

// Tile masks
#define COLOR_SELECT_MASK       ((uint8_t)0x80)
#define HFLIP_MASK              ((uint8_t)0x40)
#define VFLIP_MASK              ((uint8_t)0x20)
#define PATTERN_ADDRESS_MASK    ((uint8_t)0x1f)

// Color masks
#define BLACK_C_MASK     ((uint8_t)0x0)
#define BLUE_C_MASK      ((uint8_t)0x1)
#define GREEN_C_MASK     ((uint8_t)0x2)
#define CYAN_C_MASK      ((uint8_t)0x3)
#define RED_C_MASK       ((uint8_t)0x4)
#define MAGENTA_C_MASK   ((uint8_t)0x5)
#define YELLOW_C_MASK    ((uint8_t)0x6)
#define WHITE_C_MASK     ((uint8_t)0x7)

// Default color masks
#define BLACK_C0_MASK    (BLACK_C_MASK   << 0)
#define BLUE_C0_MASK     (BLUE_C_MASK    << 0)
#define GREEN_C0_MASK    (GREEN_C_MASK   << 0)
#define CYAN_C0_MASK     (CYAN_C_MASK    << 0)
#define RED_C0_MASK      (RED_C_MASK     << 0)
#define MAGENTA_C0_MASK  (MAGENTA_C_MASK << 0)
#define YELLOW_C0_MASK   (YELLOW_C_MASK  << 0)
#define WHITE_C0_MASK    (WHITE_C_MASK   << 0)
// Alt color masks
#define BLACK_C1_MASK    (BLACK_C_MASK   << 3)
#define BLUE_C1_MASK     (BLUE_C_MASK    << 3)
#define GREEN_C1_MASK    (GREEN_C_MASK   << 3)
#define CYAN_C1_MASK     (CYAN_C_MASK    << 3)
#define RED_C1_MASK      (RED_C_MASK     << 3)
#define MAGENTA_C1_MASK  (MAGENTA_C_MASK << 3)
#define YELLOW_C1_MASK   (YELLOW_C_MASK  << 3)
#define WHITE_C1_MASK    (WHITE_C_MASK   << 3)



#endif
