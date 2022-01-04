
/* foreground.v */

`ifndef __UCSBIEEE__GPU__RTL__FOREGROUND_SV
`define __UCSBIEEE__GPU__RTL__FOREGROUND_SV


`ifdef LINTER
    `include "hardware-level/rtl/gpu/rtl/vram_parameters.v"
    `include "hardware-level/rtl/misc/ffs.vh"
`endif


module foreground_m #(
    parameter NUM_OBJECTS   = 64,
    parameter LINE_REPEAT   = 2,
    parameter NUM_ROWS      = 523
) (
    input                           gpu_clk,
    input                           cpu_clk,
    input                           rst,

    // video timing input
    input                     [8:0] current_x, current_y,
    input                           hsync,

    // video output
    output wire               [1:0] r, g, b,
    output wire                     valid,

    // VRAM interface
    input                     [7:0] data_in,
    input    [`VRAM_ADDR_WIDTH-1:0] vram_address,
    input                           write_enable,
    input                           SELECT_pmf, SELECT_obm
);

    localparam MAX_Y = $rtoi($ceil((1.0 * NUM_ROWS)/LINE_REPEAT));

    // Pattern Memory Foreground    https://arcade.ucsbieee.org/guides/gpu/#Pattern-Memory
    reg [7:0]   PMF     [ 511:0];

    `define PMF_LINE(PMFA,PATTERN_Y)            { PMF[ {$unsigned(5'(PMFA)), $unsigned(3'(PATTERN_Y)), 1'b0} ], PMF[ {$unsigned(5'(PMFA)), $unsigned(3'(PATTERN_Y)), 1'b1} ] }
    // -------------------------

    // Object Memory                https://arcade.ucsbieee.org/guides/gpu/#Object-Memory
    reg [7:0]   OBM     [ 255:0];

    `define OBM_OBJECT(OBMA)                    { OBM[ {$unsigned(6'(OBMA)), 2'd0} ], OBM[ {$unsigned(6'(OBMA)), 2'd1} ], OBM[ {$unsigned(6'(OBMA)), 2'd2} ], OBM[ {$unsigned(6'(OBMA)), 2'd3} ] }
    `define OBM_OBJECT_X(OBMA)                  OBM[ {$unsigned(6'(OBMA)), 2'd0} ]
    `define OBM_OBJECT_Y(OBMA)                  OBM[ {$unsigned(6'(OBMA)), 2'd1} ]
    `define OBM_OBJECT_HFLIP(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd2} ][6]
    `define OBM_OBJECT_VFLIP(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd2} ][5]
    `define OBM_OBJECT_PMFA(OBMA)               OBM[ {$unsigned(6'(OBMA)), 2'd2} ][4:0]
    `define OBM_OBJECT_COLOR(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd3} ][2:0]
    // -------------------------



    // write to vram
    always_ff @ ( negedge cpu_clk ) begin : write_to_vram
        if ( write_enable ) begin
            if ( SELECT_pmf )
                PMF[ vram_address - 12'h000 ] <= data_in;
            if ( SELECT_obm )
                OBM[ vram_address - 12'h800 ] <= data_in;
        end
    end




    // dump object values
    `ifdef SIM
    generate for ( genvar i = 0; i < NUM_OBJECTS; i++ ) begin : object
        initial `OBM_OBJECT_Y(i) = 8'hff;
        wire [7:0] object_x = `OBM_OBJECT_X(i);
        wire [7:0] object_y = `OBM_OBJECT_Y(i);
        wire [2:0] color = `OBM_OBJECT_COLOR(i);
        wire [4:0] pmfa = `OBM_OBJECT_PMFA(i);
        wire hflip = `OBM_OBJECT_HFLIP(i);
        wire vflip = `OBM_OBJECT_VFLIP(i);
    end endgenerate
    `endif





    // scanline memory
    // two scanline arrays that alternate every other row
    reg scanline_select;
    initial scanline_select = 0;

    reg [6:0]   SCANLINE_0  [256+8-1:0];
    reg [6:0]   SCANLINE_1  [256+8-1:0];

    `ifdef SIM
    generate for ( genvar i = 0; i < 256; i=i+1 ) begin : scanline_x
        wire [6:0] this_obma = scanline_select ? SCANLINE_1[i] : SCANLINE_0[i];
        wire [6:0] next_obma = scanline_select ? SCANLINE_0[i] : SCANLINE_1[i];
    end endgenerate
    `endif




    // index of the object that is currently being loaded to the scanline array
    wire [6:0] parsing_object = ( current_x < NUM_OBJECTS ) ? ( (NUM_OBJECTS-1) - current_x ) : {7{1'bx}};

    // selected scanline is for the next line
    reg this_is_next;
    initial this_is_next = 0;

    // on the next clock cycle, swap next scanline with current scanline
    wire transfer_next_to_this;




    // procedural block for writing to scanline memory
    always_ff @ ( posedge gpu_clk ) begin

        // if we need to swap the scanline arrays
        if (transfer_next_to_this) begin
            // make next scanline this scanline
            scanline_select <= ~scanline_select;
            // wait until hsync before transferring again
            this_is_next <= 1;
            // reset next scanline
            for ( integer i = 0; i < 256; i=i+1 ) begin
                if (scanline_select)
                    SCANLINE_1[i] <= 7'h40;
                else
                    SCANLINE_0[i] <= 7'h40;
            end

        end
        // for current_x=[0 ... NUM_OBJECTS-1], parsing_object = current_x
        else if ( current_x < NUM_OBJECTS ) begin
            // selected scanline is currently being drawn
            this_is_next <= 0;
            if (
                // if just before top scanline and the object is at the top
                (`OBM_OBJECT_Y(parsing_object) == 0 && current_y == MAX_Y)
                || ( // or if Y overlaps the parsing object
                    ({1'b0,`OBM_OBJECT_Y(parsing_object)} <= (current_y+9'd1)) &&
                    (({1'b0,`OBM_OBJECT_Y(parsing_object)}+9'd6) >= current_y)
                )
            ) begin
                // update next scanline
                if (scanline_select) begin
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd0 ] <= parsing_object;
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd1 ] <= parsing_object;
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd2 ] <= parsing_object;
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd3 ] <= parsing_object;
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd4 ] <= parsing_object;
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd5 ] <= parsing_object;
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd6 ] <= parsing_object;
                    SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd7 ] <= parsing_object;
                end else begin
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd0 ] <= parsing_object;
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd1 ] <= parsing_object;
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd2 ] <= parsing_object;
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd3 ] <= parsing_object;
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd4 ] <= parsing_object;
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd5 ] <= parsing_object;
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd6 ] <= parsing_object;
                    SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'd7 ] <= parsing_object;
                end
            end

        end
    end




    // calculate transfer_next_to_this
    generate
        if (LINE_REPEAT == 1) begin
            initial $error("LINE_REPEAT of 1 not supported.");
            // assign transfer_next_to_this = (!this_is_next) && (~hsync);
        end else begin
            // make a counter with period LINE_REPEAT
            // when counter == 0, transfer_next_to_this <= 1
            reg [$clog2(LINE_REPEAT)-1:0] repeat_counter;
            reg incremented_repeat_counter = 0;
            initial begin
                repeat_counter = 0;
                incremented_repeat_counter = LINE_REPEAT-1;
            end
            always_ff @ ( posedge gpu_clk ) begin
                // increment counter
                if (~hsync) begin
                    incremented_repeat_counter <= 0;
                end
                else if ((!incremented_repeat_counter) && (hsync)) begin
                    if (current_y == MAX_Y-1) begin
                        repeat_counter <= 0;
                    end else if ((repeat_counter == 0) || (current_y == MAX_Y)) begin
                        repeat_counter <= LINE_REPEAT-1;
                    end else begin
                        repeat_counter <= repeat_counter-1;
                    end
                    incremented_repeat_counter <= 1;
                end
            end
            assign transfer_next_to_this = (!this_is_next) && (~hsync) && (repeat_counter == 0);
        end
    endgenerate




    // given calculated scanline, find the current pixel value

    wire [6:0] obma = scanline_select ? SCANLINE_1[current_x] : SCANLINE_0[current_x];

    // object position on screen
    wire [7:0] object_x = `OBM_OBJECT_X(obma);
    wire [7:0] object_y = `OBM_OBJECT_Y(obma);

    // pixel location within object
    wire [2:0] in_object_y = current_y[2:0] - object_y[2:0];
    wire [2:0] in_object_x = current_x[2:0] - object_x[2:0];

    // object color, sprite, and flip modifiers
    wire [2:0] color = `OBM_OBJECT_COLOR(obma);
    wire [4:0] pmfa = `OBM_OBJECT_PMFA(obma);
    wire hflip = `OBM_OBJECT_HFLIP(obma);
    wire vflip = `OBM_OBJECT_VFLIP(obma);

    // get vertical position in sprite
    wire [2:0] in_pattern_y = vflip ? (3'd7-in_object_y) : in_object_y;
    wire [2:0] in_pattern_x = hflip ? (3'd7-in_object_x) : in_object_x;

    // get object scanline line
    wire [15:0] line = `PMF_LINE( pmfa, in_pattern_y );

    // if the video timing counter is at the location of the object
    wire [1:0] current_pixel = line[ {3'h7-in_pattern_x, 1'b0} +: 2 ];
    // whether the current pixel is transparent
    wire transparent = ( current_pixel == 2'b0 );

    // colors of current pixel
    assign r = current_pixel & {2{color[2]}};
    assign g = current_pixel & {2{color[1]}};
    assign b = current_pixel & {2{color[0]}};

    assign valid = (obma != 7'h40) && !transparent;




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
