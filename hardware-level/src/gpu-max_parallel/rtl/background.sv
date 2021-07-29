
/* background.v */


`ifdef INCLUDE
    `include "pattern-hflipper.v"
    `include "headers/parameters.vh"
`endif


module background_m (
    input                           clk, // 12.5875 MHz
    input                           rst,

    // video timing input
    input                     [7:0] xp, yp,
    input                           visible,
    input                           writable,

    // video output
    output wire               [1:0] r, g, b,

    // VRAM interface
    input                     [7:0] data,
    input                  [12-1:0] address
);

    wire [4:0] ntbl_r = yp[7:3];
    wire [2:0] tile_y = yp[2:0];


    // Pattern Memory Background    https://arcade.ucsbieee.org/guides/gpu/#Pattern-Memory
    reg [7:0]   PMB     [ 511:0];

    `define PMB_LINE(PMBA,PATTERN_Y)            { PMB[ {$unsigned(5'(PMBA)), $unsigned(3'(PATTERN_Y)), 1'b0} ], PMB[ {$unsigned(5'(PMBA)), $unsigned(3'(PATTERN_Y)), 1'b1} ] }
    // -------------------------

    // Nametable                    https://arcade.ucsbieee.org/guides/gpu/#Nametable
    reg [7:0]   NTBL    [1023:0];

    `define NTBL_COLORS                         NTBL[960]
    `define NTBL_COLOR_0                        `NTBL_COLORS[2:0]
    `define NTBL_COLOR_1                        `NTBL_COLORS[5:3]
    `define NTBL_TILE(R,C)                      NTBL[ {$unsigned(5'(R)), $unsigned(5'(C))} ]
    `define NTBL_TILE_COLORSELECT(R,C)          `NTBL_TILE(R,C)[7]
    `define NTBL_TILE_HFLIP(R,C)                `NTBL_TILE(R,C)[6]
    `define NTBL_TILE_VFLIP(R,C)                `NTBL_TILE(R,C)[5]
    `define NTBL_TILE_PMBA(R,C)                 `NTBL_TILE(R,C)[4:0]
    // -------------------------

    // Background Scanline Memory
    wire [18:0] BSM [31:0];

    `define BSM_TILE(NTBL_C)                    BSM[ $unsigned(5'(NTBL_C)) ]
    `define BSM_LINE(NTBL_C)                    `BSM_TILE(NTBL_C)[15:0]
    `define BSM_COLOR(NTBL_C)                   `BSM_TILE(NTBL_C)[18:16]
    `define BSM_PIXEL(NTBL_C,XP)                `BSM_TILE(NTBL_C)[ {3'd7-$unsigned(3'(XP)), 1'b0} +:2 ]
    // -------------------------

    // Send Nametable+PMB to BSM
    wire [2:0] ntbl_color0 = `NTBL_COLOR_0;
    wire [2:0] ntbl_color1 = `NTBL_COLOR_1;

    generate
        // for all columns
        for ( genvar ntbl_c_GEN = 0; ntbl_c_GEN < 32; ntbl_c_GEN = ntbl_c_GEN+1 ) begin : fill_BSM

            // find BSM color
            wire color_select = `NTBL_TILE_COLORSELECT(ntbl_r,ntbl_c_GEN);
            wire [2:0] color = color_select ? ntbl_color1 : ntbl_color0;
            assign `BSM_COLOR(ntbl_c_GEN) = color;

            // PMB address
            wire [4:0] pmba = `NTBL_TILE_PMBA(ntbl_r,ntbl_c_GEN);

            // get flip states
            wire hflip = `NTBL_TILE_HFLIP(ntbl_r,ntbl_c_GEN);
            wire vflip = `NTBL_TILE_VFLIP(ntbl_r,ntbl_c_GEN);

            // get vflipped address
            wire [2:0] vflipped_tile_y = vflip ? (7-tile_y) : tile_y;

            // get flipped line
            wire [15:0] line;
            pattern_hflipper_m pmb_hflipper (
                `PMB_LINE( pmba, vflipped_tile_y ),
                hflip,
                line
            );
            assign `BSM_LINE(ntbl_c_GEN) = line;

        end
    endgenerate

    wire [1:0] current_pixel = `BSM_PIXEL( xp[7:3], xp[2:0] );
    wire [2:0] current_color = `BSM_COLOR( xp[7:3] );
    assign r = current_pixel & {2{current_color[2]}};
    assign g = current_pixel & {2{current_color[1]}};
    assign b = current_pixel & {2{current_color[0]}};


    //======================================\\
    `ifdef TEST
    initial begin
        `NTBL_COLOR_0 = 3'b011;
        `NTBL_COLOR_1 = 3'b110;

        `PMB_LINE( 5'd0, 3'd0 ) = 16'b00_01_00_10_00_11_00_01;
        `PMB_LINE( 5'd0, 3'd1 ) = 16'b01_00_10_00_11_00_01_00;
        `PMB_LINE( 5'd0, 3'd2 ) = 16'b00_10_00_11_00_01_00_11;
        `PMB_LINE( 5'd0, 3'd3 ) = 16'b10_00_11_00_01_00_11_00;
        `PMB_LINE( 5'd0, 3'd4 ) = 16'b00_11_00_01_00_11_00_10;
        `PMB_LINE( 5'd0, 3'd5 ) = 16'b11_00_01_00_11_00_10_00;
        `PMB_LINE( 5'd0, 3'd6 ) = 16'b00_01_00_11_00_10_00_01;
        `PMB_LINE( 5'd0, 3'd7 ) = 16'b01_00_11_00_10_00_01_00;

        `PMB_LINE( 5'd1, 3'd0 ) = 16'b11_00_11_00_11_00_11_00;
        `PMB_LINE( 5'd1, 3'd1 ) = 16'b11_00_11_00_11_00_11_00;
        `PMB_LINE( 5'd1, 3'd2 ) = 16'b11_00_11_00_11_00_11_00;
        `PMB_LINE( 5'd1, 3'd3 ) = 16'b11_00_11_00_11_00_11_00;
        `PMB_LINE( 5'd1, 3'd4 ) = 16'b11_00_11_00_11_00_11_00;
        `PMB_LINE( 5'd1, 3'd5 ) = 16'b11_00_11_00_11_00_11_00;
        `PMB_LINE( 5'd1, 3'd6 ) = 16'b11_00_11_00_11_00_11_00;
        `PMB_LINE( 5'd1, 3'd7 ) = 16'b11_00_11_00_11_00_11_00;

        `PMB_LINE( 5'd2, 3'd0 ) = 16'b00_01_10_11_11_10_01_00;
        `PMB_LINE( 5'd2, 3'd1 ) = 16'b00_01_10_11_11_10_01_00;
        `PMB_LINE( 5'd2, 3'd2 ) = 16'b00_01_10_11_11_10_01_00;
        `PMB_LINE( 5'd2, 3'd3 ) = 16'b00_01_10_11_11_10_01_00;
        `PMB_LINE( 5'd2, 3'd4 ) = 16'b00_01_10_11_11_10_01_00;
        `PMB_LINE( 5'd2, 3'd5 ) = 16'b00_01_10_11_11_10_01_00;
        `PMB_LINE( 5'd2, 3'd6 ) = 16'b00_01_10_11_11_10_01_00;
        `PMB_LINE( 5'd2, 3'd7 ) = 16'b00_01_10_11_11_10_01_00;
    end
    `endif
    generate
        for ( genvar ntbl_r_GEN = 0; ntbl_r_GEN < 30; ntbl_r_GEN = ntbl_r_GEN+1 ) begin : ntbl_row
            for ( genvar ntbl_c_GEN = 0; ntbl_c_GEN < 32; ntbl_c_GEN = ntbl_c_GEN+1 ) begin : ntbl_column
                `ifdef SIM
                wire colorselect = `NTBL_TILE_COLORSELECT(ntbl_r_GEN,ntbl_c_GEN);
                wire hflip = `NTBL_TILE_HFLIP(ntbl_r_GEN,ntbl_c_GEN);
                wire vflip = `NTBL_TILE_VFLIP(ntbl_r_GEN,ntbl_c_GEN);
                wire [4:0] pmba = `NTBL_TILE_PMBA(ntbl_r_GEN,ntbl_c_GEN);
                `endif
                `ifdef TEST
                initial begin
                    `NTBL_TILE_COLORSELECT(ntbl_r_GEN,ntbl_c_GEN) = ntbl_r_GEN & 1'b1;
                    `NTBL_TILE_HFLIP(ntbl_r_GEN,ntbl_c_GEN) = 1'b0;
                    `NTBL_TILE_VFLIP(ntbl_r_GEN,ntbl_c_GEN) = 1'b0;
                    if ( ntbl_r_GEN == 0 || ntbl_r_GEN == 29 || ntbl_c_GEN == 0 || ntbl_c_GEN == 31 )
                        `NTBL_TILE_PMBA(ntbl_r_GEN,ntbl_c_GEN) = 5'd1;
                    else
                        `NTBL_TILE_PMBA(ntbl_r_GEN,ntbl_c_GEN) = 5'd0;
                end
                `endif
            end
        end
    endgenerate
    `ifdef SIM
    generate for ( genvar pattern_GEN = 0; pattern_GEN < 32; pattern_GEN = pattern_GEN+1 ) begin : pattern
        wire [15:0] line0 = `PMB_LINE(pattern_GEN,3'd0);
        wire [15:0] line1 = `PMB_LINE(pattern_GEN,3'd1);
        wire [15:0] line2 = `PMB_LINE(pattern_GEN,3'd2);
        wire [15:0] line3 = `PMB_LINE(pattern_GEN,3'd3);
        wire [15:0] line4 = `PMB_LINE(pattern_GEN,3'd4);
        wire [15:0] line5 = `PMB_LINE(pattern_GEN,3'd5);
        wire [15:0] line6 = `PMB_LINE(pattern_GEN,3'd6);
        wire [15:0] line7 = `PMB_LINE(pattern_GEN,3'd7);
    end endgenerate
    `endif
    //======================================\\


endmodule
