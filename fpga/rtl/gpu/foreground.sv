
/* foreground.v */

module foreground #(
    parameter NUM_OBJECTS   = 64,
    parameter LINE_REPEAT   = 2,
    parameter NUM_ROWS      = 523
) (
    input   logic                       gpu_clk,
    input   logic                       cpu_clk,
    input   logic                       rst,

    // video timing input
    input   logic [8:0]                 current_x_i, current_y_i,
    input   logic [8:0]                 next_x_i, next_y_i,
    input   logic                       hsync_i,

    // video output
    output  logic [1:0]                 r_o, g_o, b_o,
    output  logic                       valid_o,

    // VRAM interface
    input   mapache64::data_t           data_i,
    output  mapache64::data_t           data_o,
    input   mapache64::vram_address_t   vram_address_i,
    input   logic                       wen_i,
    input   logic                       SELECT_pmf_i, SELECT_obm_i
);

    localparam MAX_Y = $rtoi($ceil((1.0 * NUM_ROWS)/LINE_REPEAT));

    // Pattern Memory Foreground    https://mapache64.ucsbieee.org/guides/gpu/#Pattern-Memory
    mapache64::data_t PMF [511:0];

    `define PMF_LINE(PMFA,PATTERN_Y)            { PMF[ {$unsigned(5'(PMFA)), $unsigned(3'(PATTERN_Y)), 1'b0} ], PMF[ {$unsigned(5'(PMFA)), $unsigned(3'(PATTERN_Y)), 1'b1} ] }
    // -------------------------

    // Object Memory                https://mapache64.ucsbieee.org/guides/gpu/#Object-Memory
    mapache64::data_t OBM [255:0];

    `define OBM_OBJECT(OBMA)                    { OBM[ {$unsigned(6'(OBMA)), 2'd0} ], OBM[ {$unsigned(6'(OBMA)), 2'd1} ], OBM[ {$unsigned(6'(OBMA)), 2'd2} ], OBM[ {$unsigned(6'(OBMA)), 2'd3} ] }
    `define OBM_OBJECT_X(OBMA)                  OBM[ {$unsigned(6'(OBMA)), 2'd0} ]
    `define OBM_OBJECT_Y(OBMA)                  OBM[ {$unsigned(6'(OBMA)), 2'd1} ]
    `define OBM_OBJECT_HFLIP(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd2} ][6]
    `define OBM_OBJECT_VFLIP(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd2} ][5]
    `define OBM_OBJECT_PMFA(OBMA)               OBM[ {$unsigned(6'(OBMA)), 2'd2} ][4:0]
    `define OBM_OBJECT_COLOR(OBMA)              OBM[ {$unsigned(6'(OBMA)), 2'd3} ][2:0]
    // -------------------------

    wire [8:0] pmf_address = 9'(vram_address_i - 12'h000);
    wire [7:0] obm_address = 8'(vram_address_i - 12'h800);

    // read from vram
    assign data_o =
        SELECT_pmf_i  ? PMF[ pmf_address ]    :
        SELECT_obm_i  ? OBM[ obm_address ]    :
        {8{1'bz}};

    // write to vram
    always_ff @(negedge cpu_clk) begin : write_to_vram
        if ( wen_i ) begin
            if ( SELECT_pmf_i )
                PMF[ pmf_address ] <= data_i;
            if ( SELECT_obm_i )
                OBM[ obm_address ] <= data_i;
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

    reg [4:0] SCANLINE_0 [256+8-1:0];
    reg [4:0] SCANLINE_1 [256+8-1:0];
    // pprgb

    `ifdef SIM
    generate for ( genvar i = 0; i < 256; i=i+1 ) begin : scanline_x
        wire [4:0] this_pixel = scanline_select ? SCANLINE_1[i] : SCANLINE_0[i];
        wire [4:0] next_pixel = scanline_select ? SCANLINE_0[i] : SCANLINE_1[i];
    end endgenerate
    `endif




    // index of the object that is currently being loaded to the scanline array
    wire [5:0] parsing_object = ( current_x_i < 9'(NUM_OBJECTS) ) ? 6'( 9'(NUM_OBJECTS-1) - current_x_i ) : {6{1'bx}};

    // selected scanline is for the next line
    reg this_is_next;
    initial this_is_next = 0;

    // on the next clock cycle, swap next scanline with current scanline
    wire transfer_next_to_this;


    wire [4:0] parsing_object_pmfa = `OBM_OBJECT_PMFA(parsing_object);
    wire parsing_object_hflip = `OBM_OBJECT_HFLIP(parsing_object);
    wire parsing_object_vflip = `OBM_OBJECT_VFLIP(parsing_object);
    wire [7:0] parsing_object_x = `OBM_OBJECT_X(parsing_object);
    wire [7:0] parsing_object_y = `OBM_OBJECT_Y(parsing_object);
    wire [2:0] parsing_object_color = `OBM_OBJECT_COLOR(parsing_object);
    wire [2:0] in_parsing_object_y = 3'(next_y_i - parsing_object_y);
    wire [2:0] in_parsing_object_pattern_y = parsing_object_vflip ? (3'd7-in_parsing_object_y) : in_parsing_object_y;
    wire [15:0] parsing_object_unflipped_line = `PMF_LINE(parsing_object_pmfa,in_parsing_object_pattern_y);
    wire [15:0] parsing_object_line;
    generate for ( genvar i = 0; i < 8; i=i+1 ) begin
        assign parsing_object_line[{3'(i),1'b0}+:2] = parsing_object_hflip ? parsing_object_unflipped_line[{3'h7-3'(i),1'b0}+:2] : parsing_object_unflipped_line[{3'(i),1'b0}+:2];
    end endgenerate

    typedef reg [$clog2(LINE_REPEAT)-1:0] repeat_counter_t;
    repeat_counter_t repeat_counter;

    // invert scanline_select
    always_ff @(posedge gpu_clk) begin
        if (rst) begin
            scanline_select <= 0;
            this_is_next <= 0;
        end else if (transfer_next_to_this) begin
            // if scanline arrays need to be swapped
            // make next scanline this scanline
            scanline_select <= ~scanline_select;
            // wait until hsync before transferring again
            this_is_next <= 1;
        end
        else if ( next_x_i == 0 ) begin
            // selected scanline is currently being drawn
            this_is_next <= 0;
        end
    end



    // whether parsing_object should be loaded to the next scanline
    wire to_fill_scanline =
        ( repeat_counter == 0 ) &&
        ( current_x_i < NUM_OBJECTS ) &&
        ( next_y_i <= 239 ) &&
        ( next_y_i >= 9'(parsing_object_y) ) &&
        ( next_y_i <= (9'(parsing_object_y)+9'd7) );



    // procedural blocks for writing to scanline memory
    always_ff @(posedge gpu_clk) begin
        // reset previous pixel
        if ( (~scanline_select) && (repeat_counter == 0) )
            SCANLINE_0[current_x_i] <= 5'b0;
        // load 8 px of parsing_object_line
        for (integer unsigned i = 0; i < 8; i=i+1) begin
            // load pattern
            if ( (scanline_select) && (to_fill_scanline) && (parsing_object_line[{3'h7-3'(i),1'b0}+:2] != 2'b0) )
                SCANLINE_0[ parsing_object_x + 9'(i) ] <= {parsing_object_line[{3'h7-3'(i),1'b0}+:2],parsing_object_color};
            // fix hazard if (parsing_object_x + 9'(i)) == current_x_i)
            else if ( (~scanline_select) && (repeat_counter == 0) && ((parsing_object_x + 9'(i)) == current_x_i) )
                SCANLINE_0[ parsing_object_x + 9'(i) ] <= 5'b0;
            // else do nothing
            else
                SCANLINE_0[ parsing_object_x + 9'(i) ] <= SCANLINE_0[ parsing_object_x + 9'(i) ];
        end
    end
    always_ff @(posedge gpu_clk) begin
        // reset previous pixel
        if ( (scanline_select) && (repeat_counter == 0) )
            SCANLINE_1[current_x_i] <= 5'b0;
        // load 8 px of parsing_object_line
        for (integer unsigned i = 0; i < 8; i=i+1) begin
            // load pattern
            if ( (~scanline_select) && (to_fill_scanline) && (parsing_object_line[{3'h7-3'(i),1'b0}+:2] != 2'b0) )
                SCANLINE_1[ parsing_object_x + 9'(i) ] <= {parsing_object_line[{3'h7-3'(i),1'b0}+:2],parsing_object_color};
            // fix hazard if (parsing_object_x + 9'(i)) == current_x_i)
            else if ( (scanline_select) && (repeat_counter == 0) && ((parsing_object_x + 9'(i)) == current_x_i) )
                SCANLINE_1[ parsing_object_x + 9'(i) ] <= 5'b0;
            // else do nothing
            else
                SCANLINE_1[ parsing_object_x + 9'(i) ] <= SCANLINE_1[ parsing_object_x + 9'(i) ];
        end
    end



    // implement repeat_counter and calculate transfer_next_to_this
    generate
        if (LINE_REPEAT == 1) begin
            initial $error("LINE_REPEAT of 1 not supported.");
            // assign transfer_next_to_this = (!this_is_next) && (~hsync_i);
        end else begin
            // make repeat_counter a counter with period LINE_REPEAT
            // when counter == 0, transfer_next_to_this <= 1
            reg incremented_repeat_counter = 0;
            initial begin
                repeat_counter = repeat_counter_t'(LINE_REPEAT-1);
                incremented_repeat_counter = 0;
            end
            always_ff @(posedge gpu_clk) begin
                // increment counter
                if (~hsync_i) begin
                    incremented_repeat_counter <= 0;
                end
                else if ((!incremented_repeat_counter) && (hsync_i)) begin
                    if (next_y_i == 9'(MAX_Y))
                        repeat_counter <= 0;
                    else if (repeat_counter == 0)
                        repeat_counter <= repeat_counter_t'(LINE_REPEAT-1);
                    else
                        repeat_counter <= repeat_counter-1;
                    incremented_repeat_counter <= 1;
                end
            end
            assign transfer_next_to_this = (!this_is_next) && (~hsync_i) && (repeat_counter == 0);
        end
    endgenerate



    // get color of current pixel
    wire [4:0] current_pixel = scanline_select ? SCANLINE_1[current_x_i] : SCANLINE_0[current_x_i];
    assign r_o = current_pixel[4:3] & {2{current_pixel[2]}};
    assign g_o = current_pixel[4:3] & {2{current_pixel[1]}};
    assign b_o = current_pixel[4:3] & {2{current_pixel[0]}};

    assign valid_o = (current_pixel[4:3] != 2'b0);




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
