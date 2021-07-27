
/* foreground.v */


`ifdef INCLUDE
    `include "pattern-hflipper.v"
    `include "headers/parameters.vh"
`endif


module foreground_m (
    input                           clk, // 12.5875 MHz
    input                           rst,

    // video timing input
    input                     [7:0] xp, yp,
    input                           visible,
    input                           writable,

    // video output
    output wire               [1:0] r, g, b,
    output wire                     valid,

    // VRAM interface
    input                     [7:0] data,
    input    [`VRAM_ADDR_WIDTH-1:0] address
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

    wire [5:0] obma = 6'b0;

    `ifdef TEST
    initial begin
        `PMF_LINE( 5'd0, 3'd0 ) = 16'b11_11_11_11_11_11_11_11;
        `PMF_LINE( 5'd0, 3'd1 ) = 16'b11_00_00_00_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd2 ) = 16'b11_00_00_00_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd3 ) = 16'b11_00_00_00_00_10_10_11;
        `PMF_LINE( 5'd0, 3'd4 ) = 16'b11_10_10_00_00_10_10_11;
        `PMF_LINE( 5'd0, 3'd5 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd6 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd7 ) = 16'b11_11_11_11_11_11_11_11;


        `OBM_OBJECT(6'b0) = {8'd128, 8'd128, 1'bx,1'b0,1'b0,5'b0, {5{1'bx}},3'b111};

        // `OBM_OBJECT_XP(6'b0) = 8'd128;
        // `OBM_OBJECT_YP(6'b0) = 8'd128;

        // `OBM_OBJECT_HFLIP(6'b0) = 1'b0;
        // `OBM_OBJECT_VFLIP(6'b0) = 1'b0;

        // `OBM_OBJECT_PMFA(6'b0) = 5'd0;

        // `OBM_OBJECT_COLOR(6'b0) = 3'b111;
    end
    `endif

    wire [7:0] object_xp = `OBM_OBJECT_XP(obma);
    wire [7:0] object_yp = `OBM_OBJECT_YP(obma);

    wire [2:0] sprite_x = xp[2:0] - object_xp[2:0];
    wire [2:0] sprite_y = yp[2:0] - object_yp[2:0];

    wire [2:0] color = `OBM_OBJECT_COLOR(obma);

    wire [4:0] pmfa = `OBM_OBJECT_PMFA(obma);

    wire hflip = `OBM_OBJECT_HFLIP(obma);
    wire vflip = `OBM_OBJECT_VFLIP(obma);

    wire [2:0] vflipped_sprite_y = vflip ? (3'd7-sprite_y) : sprite_y;

    wire [15:0] line;
    pattern_hflipper_m pmf_hflipper (
        `PMF_LINE( pmfa, vflipped_sprite_y ),
        hflip,
        line
    );

    wire counter_at_object = ( object_xp <= xp && {1'b0, xp} < {1'b0, object_xp} + 9'd8 ) && ( object_yp <= yp && yp < object_yp + 8'd8 );
    wire transparent = ( current_pixel == 2'b0 );
    wire [1:0] current_pixel = line[ {3'd7-sprite_x, 1'b0} +: 2 ] & {2{counter_at_object}};

    assign r = current_pixel & {2{color[2]}};
    assign g = current_pixel & {2{color[1]}};
    assign b = current_pixel & {2{color[0]}};

    assign valid = counter_at_object && !transparent;

endmodule
