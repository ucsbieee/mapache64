
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
    output wire               [7:0] data_out,
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

    wire [11:0] pmf_address = vram_address - 12'h000;
    wire [11:0] obm_address = vram_address - 12'h800;

    // read from vram
    assign data_out =
        SELECT_pmf  ? PMF[ pmf_address ]    :
        SELECT_obm  ? OBM[ obm_address ]    :
        {8{1'bz}};

    // write to vram
    always_ff @ ( negedge cpu_clk ) begin : write_to_vram
        if ( write_enable ) begin
            if ( SELECT_pmf )
                PMF[ pmf_address ] <= data_in;
            if ( SELECT_obm )
                OBM[ obm_address ] <= data_in;
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


    wire [4:0] parsing_object_pmfa = `OBM_OBJECT_PMFA(parsing_object);
    wire parsing_object_hflip = `OBM_OBJECT_HFLIP(parsing_object);
    wire parsing_object_vflip = `OBM_OBJECT_VFLIP(parsing_object);
    wire [2:0] parsing_object_color = `OBM_OBJECT_COLOR(parsing_object);
    wire [8:0] next_y = (current_y == MAX_Y) ? 0 : current_y+1;
    wire [2:0] in_parsing_object_y = 3'(next_y - `OBM_OBJECT_Y(parsing_object));
    wire [2:0] in_parsing_object_pattern_y = parsing_object_vflip ? (3'd7-in_parsing_object_y) : in_parsing_object_y;
    wire [15:0] parsing_object_line = `PMF_LINE(parsing_object_pmfa,in_parsing_object_pattern_y);

    function automatic [5:0] get_object_pixel (
        input [2:0] in_parsing_object_x
    );
        reg [2:0] in_parsing_object_pattern_x = parsing_object_hflip ? in_parsing_object_x : (3'd7-in_parsing_object_x);
        reg [1:0] pixel_pattern = parsing_object_line[2*4'(in_parsing_object_pattern_x)+:2]; // to do: add hflip
        return {
            {2{parsing_object_color[2]}} & pixel_pattern,
            {2{parsing_object_color[1]}} & pixel_pattern,
            {2{parsing_object_color[0]}} & pixel_pattern
        };
    endfunction

    function automatic [1:0] get_object_pixel_pattern (
        input [2:0] in_parsing_object_x
    );
        reg [2:0] in_parsing_object_pattern_x = parsing_object_hflip ? in_parsing_object_x : (3'd7-in_parsing_object_x);
        return parsing_object_line[2*4'(in_parsing_object_pattern_x)+:2];
    endfunction

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
                    SCANLINE_1[i] <= 7'b0;
                else
                    SCANLINE_0[i] <= 7'b0;
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
                    (current_y < 239) &&
                    ({1'b0,`OBM_OBJECT_Y(parsing_object)} <= (current_y+9'd1)) &&
                    (({1'b0,`OBM_OBJECT_Y(parsing_object)}+9'd6) >= current_y)
                )
            ) begin
                // $display("y:%d -- %h: %b [Time=%0t]", next_y, parsing_object, parsing_object_line, $realtime);
                for (integer unsigned i = 0; i < 8; i=i+1) begin
                    // $display(" pixel: %b", get_object_pixel(i));
                    if (get_object_pixel_pattern(i) != 2'b0) begin
                        if (scanline_select)
                            SCANLINE_0[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'(i) ] <= {1'b1,get_object_pixel(i)};
                        else
                            SCANLINE_1[ {1'b0,`OBM_OBJECT_X(parsing_object)} + 9'(i) ] <= {1'b1,get_object_pixel(i)};
                    end
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

    // colors of current pixel
    wire [6:0] current_pixel = scanline_select ? SCANLINE_1[current_x] : SCANLINE_0[current_x];
    assign r = current_pixel[4+:2];
    assign g = current_pixel[2+:2];
    assign b = current_pixel[0+:2];

    assign valid = current_pixel[6];




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
