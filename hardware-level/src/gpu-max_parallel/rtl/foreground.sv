
/* foreground.v */


`ifdef INCLUDE
    `include "pattern-hflipper.v"
    `include "headers/parameters.vh"
    `include "../fusesoc/fusesoc_libraries/e4tham_ffs/rtl/ffs.v"
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

    `define NUM_OBJECTS 7'd64
    wire [1:0] r_collection [`NUM_OBJECTS-1:0];
    wire [1:0] b_collection [`NUM_OBJECTS-1:0];
    wire [1:0] g_collection [`NUM_OBJECTS-1:0];
    wire [`NUM_OBJECTS-1:0] valid_collection;

    generate for ( genvar obma_GEN = 0; obma_GEN < `NUM_OBJECTS; obma_GEN = obma_GEN+1 ) begin : object

        `ifdef TEST
        if (obma_GEN >= 24)
            initial `OBM_OBJECT_YP(obma_GEN) = 8'hff;
        `endif

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
    reg [$clog2(`NUM_OBJECTS)-1:0] top_object;
    // https://github.com/E4tHam/find_first_set/blob/main/rtl/ffs.v
    ffs_m #(`NUM_OBJECTS) ffs (
        valid_collection,
        valid,
        top_object
    );

    assign r = r_collection[top_object];
    assign g = g_collection[top_object];
    assign b = b_collection[top_object];


    //======================================\\
    `ifdef TEST
    initial begin
        `PMF_LINE( 5'd0, 3'd0 ) = 16'b11_11_11_11_11_11_11_11;
        `PMF_LINE( 5'd0, 3'd1 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd2 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd3 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd4 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd5 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd6 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd0, 3'd7 ) = 16'b11_11_11_11_11_11_11_11;

        `PMF_LINE( 5'd1, 3'd0 ) = 16'b11_11_11_11_11_11_11_11;
        `PMF_LINE( 5'd1, 3'd1 ) = 16'b11_00_00_00_10_10_10_11;
        `PMF_LINE( 5'd1, 3'd2 ) = 16'b11_00_00_00_10_10_10_11;
        `PMF_LINE( 5'd1, 3'd3 ) = 16'b11_00_00_00_00_10_10_11;
        `PMF_LINE( 5'd1, 3'd4 ) = 16'b11_10_10_00_00_10_10_11;
        `PMF_LINE( 5'd1, 3'd5 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd1, 3'd6 ) = 16'b11_10_10_10_10_10_10_11;
        `PMF_LINE( 5'd1, 3'd7 ) = 16'b11_11_11_11_11_11_11_11;


        `OBM_OBJECT(6'd00) = {8'd129, 8'd150, 1'bx,1'b0,1'b0,5'b1, {5{1'bx}},3'd0};
        `OBM_OBJECT(6'd01) = {8'd120, 8'd153, 1'bx,1'b0,1'b1,5'b1, {5{1'bx}},3'd1};
        `OBM_OBJECT(6'd02) = {8'd101, 8'd157, 1'bx,1'b1,1'b0,5'b1, {5{1'bx}},3'd2};
        `OBM_OBJECT(6'd03) = {8'd136, 8'd152, 1'bx,1'b1,1'b1,5'b1, {5{1'bx}},3'd3};
        `OBM_OBJECT(6'd04) = {8'd141, 8'd111, 1'bx,1'b0,1'b0,5'b1, {5{1'bx}},3'd4};
        `OBM_OBJECT(6'd05) = {8'd121, 8'd149, 1'bx,1'b0,1'b1,5'b1, {5{1'bx}},3'd5};
        `OBM_OBJECT(6'd06) = {8'd117, 8'd156, 1'bx,1'b1,1'b0,5'b1, {5{1'bx}},3'd6};
        `OBM_OBJECT(6'd07) = {8'd157, 8'd160, 1'bx,1'b1,1'b1,5'b1, {5{1'bx}},3'd7};
        `OBM_OBJECT(6'd08) = {8'd155, 8'd154, 1'bx,1'b0,1'b0,5'b1, {5{1'bx}},3'd0};
        `OBM_OBJECT(6'd09) = {8'd155, 8'd121, 1'bx,1'b0,1'b1,5'b1, {5{1'bx}},3'd1};
        `OBM_OBJECT(6'd10) = {8'd136, 8'd138, 1'bx,1'b1,1'b0,5'b1, {5{1'bx}},3'd2};
        `OBM_OBJECT(6'd11) = {8'd124, 8'd105, 1'bx,1'b1,1'b1,5'b1, {5{1'bx}},3'd3};
        `OBM_OBJECT(6'd12) = {8'd109, 8'd152, 1'bx,1'b0,1'b0,5'b1, {5{1'bx}},3'd4};
        `OBM_OBJECT(6'd13) = {8'd132, 8'd160, 1'bx,1'b0,1'b1,5'b1, {5{1'bx}},3'd5};
        `OBM_OBJECT(6'd14) = {8'd132, 8'd119, 1'bx,1'b1,1'b0,5'b1, {5{1'bx}},3'd6};
        `OBM_OBJECT(6'd15) = {8'd132, 8'd157, 1'bx,1'b1,1'b1,5'b1, {5{1'bx}},3'd7};
        `OBM_OBJECT(6'd16) = {8'd148, 8'd154, 1'bx,1'b0,1'b0,5'b1, {5{1'bx}},3'd0};
        `OBM_OBJECT(6'd17) = {8'd123, 8'd146, 1'bx,1'b0,1'b1,5'b1, {5{1'bx}},3'd1};
        `OBM_OBJECT(6'd18) = {8'd117, 8'd128, 1'bx,1'b1,1'b0,5'b1, {5{1'bx}},3'd2};
        `OBM_OBJECT(6'd19) = {8'd111, 8'd127, 1'bx,1'b1,1'b1,5'b1, {5{1'bx}},3'd3};
        `OBM_OBJECT(6'd20) = {8'd140, 8'd106, 1'bx,1'b0,1'b0,5'b1, {5{1'bx}},3'd4};
        `OBM_OBJECT(6'd21) = {8'd121, 8'd124, 1'bx,1'b0,1'b1,5'b1, {5{1'bx}},3'd5};
        `OBM_OBJECT(6'd22) = {8'd105, 8'd121, 1'bx,1'b1,1'b0,5'b1, {5{1'bx}},3'd6};
        `OBM_OBJECT(6'd23) = {8'd110, 8'd136, 1'bx,1'b1,1'b1,5'b1, {5{1'bx}},3'd7};
    end
    `endif
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
