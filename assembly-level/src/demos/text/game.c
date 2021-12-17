
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

char text[] = "\
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore\
et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi uta\
liquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cill\
um dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa q\
ui officia deserunt mollit anim id est laborum.\
";

void reset(void) { }

void do_logic(void) { }

void fill_vram(void) {
    uint8_t i, j;
    uint16_t x = 0;

    for (i = 0; i < 30; i++)
        for (j = 0; j < 32; j++) {
            TXBL[i][j] = text[x] | COLOR_SELECT_MASK;
            if (text[x] != 0)
                x++;
        }
    stop();

}
