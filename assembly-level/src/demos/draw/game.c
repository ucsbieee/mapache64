
// ============ draw.c ============ //
// Demo of filling the PMB and NTBL //
// ================================ //

#define SIM 1 // change value depending if running simulation or not


// ================================ //
#pragma code-name ("CODE")
#pragma bss-name ("BSS")
// Misc Code Segment

#include <int.h>
#include <vram.h>
#include <stop.h>
#include <Q9_6.h>
#include <arcade_zero_page.h>
#include <controller.h>




bool vram_initialized;




void reset() {
    vram_initialized = false;
}


void do_logic() {
    if (vram_initialized)
        stop();
}


void fill_vram() {
    uint8_t i, j;

    // init PMB
    for ( i = 0; i < 16; i+=2 ) {
        PMB[0][i+0] = 0xe4;
        PMB[0][i+1] = 0x1b;
    }

    // init NTBL
    for ( i = 0; i < 30; i+=1 )
        for ( j = 0; j < 32; j++ )
            NTBL[i][j] = (((i^j)&1)==0) ? COLOR_ALT_MASK : 0;

    background_palette = MAGENTA_C1_MASK | GREEN_C0_MASK;

    vram_initialized = true;
}
