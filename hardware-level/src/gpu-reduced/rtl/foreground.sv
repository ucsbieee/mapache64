
/* foreground.v */

`ifndef __UCSBIEEE__GPU_REDUCED__RTL__FOREGROUND_SV
`define __UCSBIEEE__GPU_REDUCED__RTL__FOREGROUND_SV


`ifdef LINTER
    `include "pattern-hflipper.v"
    `include "headers/parameters.vh"
    `include "../fusesoc/fusesoc_libraries/e4tham_ffs/rtl/ffs.v"
`endif


module foreground_m #(
    parameter NUM_OBJECTS = 64
) (
    input                           clk, // 12.5875 MHz
    input                           rst,

    // video timing input
    input                     [7:0] xp, yp,
    input                           writable,

    // video output
    output wire               [1:0] r, g, b,
    output wire                     valid,

    // VRAM interface
    input                     [7:0] data_in,
    input    [`VRAM_ADDR_WIDTH-1:0] address,
    input                           write_enable
);

    // Pattern Memory Foreground    https://arcade.ucsbieee.org/guides/gpu/#Pattern-Memory
    reg [7:0]   PMF     [ 511:0];

    `define PMF_LINE(PMFA,PATTERN_Y)            { PMF[ {$unsigned(5'(PMFA)), $unsigned(3'(PATTERN_Y)), 1'b0} ], PMF[ {$unsigned(5'(PMFA)), $unsigned(3'(PATTERN_Y)), 1'b1} ] }
    // -------------------------

    // Object Memory                https://arcade.ucsbieee.org/guides/gpu/#Object-Memory
    reg [7:0]   OBM     [ 255:0];

    `define OBM_OBJECT(OBMA)                    { OBM[ {$unsigned(6'(OBMA)), 2'd0} ], OBM[ {$unsigned(6'(OBMA)), 2'd1} ], OBM[ {$unsigned(6'(OBMA)), 2'd2} ], OBM[ {$unsigned(6'(OBMA)), 2'd3} ] }
    `define OBM_OBJECT_XP(OBMA)                 OBM[ {$unsigned(6'(OBMA)), 2'd0} ]
    `define OBM_OBJECT_YP(OBMA)                 OBM[ {$unsigned(6'(OBMA)), 2'd1} ]
    `define OBM_OBJECT_HFLIP(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd2} ][6]
    `define OBM_OBJECT_VFLIP(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd2} ][5]
    `define OBM_OBJECT_PMFA(OBMA)               OBM[ {$unsigned(6'(OBMA)), 2'd2} ][4:0]
    `define OBM_OBJECT_COLOR(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd3} ][2:0]
    // -------------------------

    wire in_pmf = ( address >= 12'h000 && address < 12'h200 );
    wire in_obm = ( address >= 12'h800 && address < 12'h900 );

    always_ff @ ( posedge clk ) begin : write_to_vram
        if ( write_enable && writable ) begin
            if ( in_pmf )
                PMF[ address - 12'h000 ] <= data_in;
            if ( in_obm )
                OBM[ address - 12'h800 ] <= data_in;
        end
    end

    wire [5:0] obma = 6'b0;

    wire [1:0] r_collection [NUM_OBJECTS-1:0];
    wire [1:0] b_collection [NUM_OBJECTS-1:0];
    wire [1:0] g_collection [NUM_OBJECTS-1:0];
    wire [NUM_OBJECTS-1:0] valid_collection;

    generate for ( genvar obma_GEN = 0; obma_GEN < NUM_OBJECTS; obma_GEN = obma_GEN+1 ) begin : object

        // object position on screen
        wire [7:0] object_xp = `OBM_OBJECT_XP(obma_GEN);
        wire [7:0] object_yp = `OBM_OBJECT_YP(obma_GEN);

        // pixel location within object
        wire [2:0] in_object_xp = xp[2:0] - object_xp[2:0];
        wire [2:0] in_object_yp = yp[2:0] - object_yp[2:0];

        // object color, sprite, and flip modifiers
        wire [2:0] color = `OBM_OBJECT_COLOR(obma_GEN);
        wire [4:0] pmfa = `OBM_OBJECT_PMFA(obma_GEN);
        wire hflip = `OBM_OBJECT_HFLIP(obma_GEN);
        wire vflip = `OBM_OBJECT_VFLIP(obma_GEN);

        // get vertical position in sprite
        wire [2:0] in_sprite_yp = vflip ? (3'd7-in_object_yp) : in_object_yp;

        // get object scanline line
        wire [15:0] line;
        pattern_hflipper_m pmf_hflipper (
            `PMF_LINE( pmfa, in_sprite_yp ),
            hflip,
            line
        );

        // if the video timing counter is at the location of the object
        wire counter_at_object = ( object_xp <= xp && {1'b0, xp} < {1'b0, object_xp} + 9'd8 ) && ( object_yp <= yp && yp < object_yp + 8'd8 );
        // value of pixel not including color
        wire [1:0] current_pixel = line[ {3'd7-in_object_xp, 1'b0} +: 2 ] & {2{counter_at_object}};
        // whether the current pixel is transparent
        wire transparent = ( current_pixel == 2'b0 );

        // colors of current pixel
        wire [1:0] object_r = current_pixel & {2{color[2]}};
        wire [1:0] object_g = current_pixel & {2{color[1]}};
        wire [1:0] object_b = current_pixel & {2{color[0]}};
        wire current_pixel_valid = counter_at_object && !transparent;

        // send to collection arrays
        assign r_collection[obma_GEN]       = object_r;
        assign b_collection[obma_GEN]       = object_b;
        assign g_collection[obma_GEN]       = object_g;
        assign valid_collection[obma_GEN]   = current_pixel_valid;

    end endgenerate

    // run Find First Set on valid bits
    wire [$clog2((NUM_OBJECTS>=2)?NUM_OBJECTS:2)-1:0] top_object;
    // https://github.com/E4tHam/find_first_set/blob/main/rtl/ffs.v
    ffs_m #(NUM_OBJECTS) ffs (
        valid_collection,
        valid,
        top_object
    );

    assign r = r_collection[top_object];
    assign g = g_collection[top_object];
    assign b = b_collection[top_object];


    //======================================\\
    `ifdef SIM
    generate for ( genvar pattern_GEN = 0; pattern_GEN < 32; pattern_GEN = pattern_GEN+1 ) begin : pattern
        wire [15:0] line0 = `PMF_LINE(pattern_GEN,3'd0);
        wire [15:0] line1 = `PMF_LINE(pattern_GEN,3'd1);
        wire [15:0] line2 = `PMF_LINE(pattern_GEN,3'd2);
        wire [15:0] line3 = `PMF_LINE(pattern_GEN,3'd3);
        wire [15:0] line4 = `PMF_LINE(pattern_GEN,3'd4);
        wire [15:0] line5 = `PMF_LINE(pattern_GEN,3'd5);
        wire [15:0] line6 = `PMF_LINE(pattern_GEN,3'd6);
        wire [15:0] line7 = `PMF_LINE(pattern_GEN,3'd7);
    end endgenerate
    `endif
    //======================================\\

endmodule


`endif
