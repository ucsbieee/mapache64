
// ==================== game.c ==================== //
// Follow this file template to implement your game //
// ================================================ //

#define SIM 1 // change value depending if running simulation or not

// ================================ //
#pragma code-name ("CODE")
#pragma bss-name ("BSS")

#include <int.h>
#include <vram.h>
#include <stop.h>
#include <Q9_6.h>
#include <arcade_zero_page.h>
#include <controller.h>
#include <screen.h>

#include "patterns.h"

void reset(void) { }

void do_logic(void) { }

void fill_vram(void) {
    OBM[0].color = WHITE_C_MASK;
    OBM[0].y = 124;
    OBM[0].x = 124;
    OBM[0].pattern_config = 0;

    load_foreground_pattern(ball_pattern, 0);
}
