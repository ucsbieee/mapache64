
/* gpu.v */


`default_nettype none

`include "gpu-counters.v"
`include "pattern-hflipper.v"

`include "../parameters.v"

`timescale `TIMESCALE

module gpu_m (
    input                           clk, // 12.5875 MHz
    input                           rst,

    // DVI output
    output wire               [1:0] r, g, b,
    output wire                     hsync, vsync,

    // VRAM interface
    input                     [7:0] data,
    input    [`VRAM_ADDR_WIDTH-1:0] address,
    input                           cs
);


    wire [7:0] xp, yp;
    wire hvisible, vvisible, visible;

    gpu_counters_m gpu_counters (
        clk, rst,
        xp, hvisible, hsync,
        yp, vvisible, vsync,
        visible
    );

    wire [4:0] ntbl_r = yp[7:3];
    wire [2:0] tile_y = yp[2:0];

    // Pattern Memory Foreground    https://arcade.ucsbieee.org/guides/gpu/#Pattern-Memory
    reg [7:0]   PMF     [ 511:0];

    `define PMF_LINE(PMFA,PATTERN_Y)            { PMF[ {5'(PMFA), 3'(PATTERN_Y), 1'b0} ], PMF[ {5'(PMFA), 3'(PATTERN_Y), 1'b1} ] }
    // -------------------------

    // Pattern Memory Background    https://arcade.ucsbieee.org/guides/gpu/#Pattern-Memory
    reg [7:0]   PMB     [ 511:0];

    `define PMB_LINE(PMBA,PATTERN_Y)            { PMB[ {5'(PMBA), 3'(PATTERN_Y), 1'b0} ], PMB[ {5'(PMBA), 3'(PATTERN_Y), 1'b1} ] }
    // -------------------------

    // Nametable                    https://arcade.ucsbieee.org/guides/gpu/#Nametable
    reg [7:0]   NTBL    [1023:0];

    `define NTBL_COLORS                         NTBL[960]
    `define NTBL_COLOR_0                        `NTBL_COLORS[2:0]
    `define NTBL_COLOR_1                        `NTBL_COLORS[5:3]
    `define NTBL_TILE(R,C)                      NTBL[ {5'(R), 5'(C)} ]
    `define NTBL_TILE_COLORSELECT(R,C)          `NTBL_TILE(R,C)[7]
    `define NTBL_TILE_HFLIP(R,C)                `NTBL_TILE(R,C)[6]
    `define NTBL_TILE_VFLIP(R,C)                `NTBL_TILE(R,C)[5]
    `define NTBL_TILE_PMBA(R,C)                 `NTBL_TILE(R,C)[4:0]
    // -------------------------

    // Object Memory                https://arcade.ucsbieee.org/guides/gpu/#Object-Memory
    reg [7:0]   OBM     [ 255:0];

    `define OBM_OBJECT_XP(OBMA)                 OBM[ {6'(OBMA), 2'd0} ]
    `define OBM_OBJECT_YP(OBMA)                 OBM[ {6'(OBMA), 2'd1} ]
    `define OBM_OBJECT_HFLIP(OBMA)              OBM[ {6'(OBMA), 2'd2} ][6]
    `define OBM_OBJECT_VFLIP(OBMA)              OBM[ {6'(OBMA), 2'd2} ][5]
    `define OBM_OBJECT_PMFA(OBMA)               OBM[ {6'(OBMA), 2'd2} ][4:0]
    `define OBM_OBJECT_COLOR(OBMA)              OBM[ {6'(OBMA), 2'd3} ][2:0]
    // -------------------------

    // Background Scanline Memory
    wire [18:0] BSM [31:0];
    // -------------------------

    // Send Nametable+PMB to BSM
    wire [2:0] ntbl_color0 = `NTBL_COLOR_0;
    wire [2:0] ntbl_color1 = `NTBL_COLOR_1;

    genvar i;
    generate
        // for all columns
        for ( i = 0; i < 32; i = i+1 ) begin : fill_BSM

            // find BSM color
            wire color_select = `NTBL_TILE_COLORSELECT(ntbl_r,i);
            wire [2:0] color = color_select ? ntbl_color1 : ntbl_color0;
            assign BSM[i][18:16] = color;

            // PMB address
            wire [4:0] pmba = `NTBL_TILE_PMBA(ntbl_r,i);

            // get flip states
            wire vflip = `NTBL_TILE_VFLIP(ntbl_r,i);
            wire hflip = `NTBL_TILE_HFLIP(ntbl_r,i);

            // get vflipped address
            wire [2:0] vflipped_tile_y = vflip ? (7-tile_y) : tile_y;

            // get flipped line
            wire [15:0] line;
            pattern_hflipper_m hflipper (
                `PMB_LINE( pmba, vflipped_tile_y ),
                hflip,
                line
            );
            assign BSM[i][15:0] = line;

        end
    endgenerate


    // load test VRAM
    initial begin
        $readmemb( `TEST_PMF, PMF, 0, 511 );
        $readmemb( `TEST_PMB, PMB, 0, 511 );
        $readmemh( `TEST_NTBL, NTBL, 0, 1023 );
        $readmemh( `TEST_OBM, OBM, 0, 255 );
    end

endmodule
