
/* background.v */

module background (
    input   logic                       cpu_clk,

    // video timing input
    input   logic [7:0]                 current_x_i, current_y_i,

    // video output
    output  logic [1:0]                 r_o, g_o, b_o,

    // VRAM interface
    input   mapache64::data_t           data_i,
    output  mapache64::data_t           data_o,
    input   mapache64::vram_address_t   vram_address_i,
    input   logic                       wen_i,
    input   logic                       SELECT_pmb_i, SELECT_ntbl_i
);

    wire [4:0] ntbl_r       = current_y_i[7:3];
    wire [2:0] in_tile_x    = current_x_i[2:0];
    wire [4:0] ntbl_c       = current_x_i[7:3];
    wire [2:0] in_tile_y    = current_y_i[2:0];


    // Pattern Memory Background    https://mapache64.ucsbieee.org/guides/gpu/#Pattern-Memory
    mapache64::data_t PMB [ 511:0];

    `define PMB_LINE(PMBA,PATTERN_Y)            { PMB[ {$unsigned(5'(PMBA)), $unsigned(3'(PATTERN_Y)), 1'b0} ], PMB[ {$unsigned(5'(PMBA)), $unsigned(3'(PATTERN_Y)), 1'b1} ] }
    // -------------------------

    // Nametable                    https://mapache64.ucsbieee.org/guides/gpu/#Nametable
    mapache64::data_t NTBL [1023:0];

    `define NTBL_COLORS                         NTBL[960]
    `define NTBL_COLOR_0                        `NTBL_COLORS[2:0]
    `define NTBL_COLOR_1                        `NTBL_COLORS[5:3]
    `define NTBL_TILE(R,C)                      NTBL[ {$unsigned(5'(R)), $unsigned(5'(C))} ]
    `define NTBL_TILE_COLORSELECT(R,C)          `NTBL_TILE(R,C)[7]
    `define NTBL_TILE_HFLIP(R,C)                `NTBL_TILE(R,C)[6]
    `define NTBL_TILE_VFLIP(R,C)                `NTBL_TILE(R,C)[5]
    `define NTBL_TILE_PMBA(R,C)                 `NTBL_TILE(R,C)[4:0]
    // -------------------------

    wire [8:0] pmb_address = 9'(vram_address_i - 12'h200);
    wire [9:0] ntbl_address = 10'(vram_address_i - 12'h400);

    // read from vram
    assign data_o =
        SELECT_pmb_i  ? PMB[ pmb_address ]    :
        SELECT_ntbl_i ? NTBL[ ntbl_address ]  :
        {8{1'bz}};

    // write to vram
    always_ff @(negedge cpu_clk) begin : write_to_vram
        if ( wen_i ) begin
            if ( SELECT_pmb_i )
                PMB[ pmb_address ] <= data_i;
            if ( SELECT_ntbl_i )
                NTBL[ ntbl_address ] <= data_i;
        end
    end

    // Send Nametable+PMB to BSM
    wire [2:0] ntbl_color0 = `NTBL_COLOR_0;
    wire [2:0] ntbl_color1 = `NTBL_COLOR_1;



    // find BSM color
    wire color_select = `NTBL_TILE_COLORSELECT(ntbl_r,ntbl_c);
    wire [2:0] color = color_select ? ntbl_color1 : ntbl_color0;

    // PMB address
    wire [4:0] pmba = `NTBL_TILE_PMBA(ntbl_r,ntbl_c);

    // get flip states
    wire hflip = `NTBL_TILE_HFLIP(ntbl_r,ntbl_c);
    wire vflip = `NTBL_TILE_VFLIP(ntbl_r,ntbl_c);

    // get vflipped address
    wire [2:0] in_pattern_y = vflip ? (3'h7-in_tile_y) : in_tile_y;
    wire [2:0] in_pattern_x = hflip ? (3'h7-in_tile_x) : in_tile_x;

    // get flipped line of pixels to draw
    wire [15:0] line = `PMB_LINE( pmba, in_pattern_y );

    wire [1:0] current_pixel = line[ {(3'h7-in_pattern_x),1'b0} +: 2 ];
    assign r_o = current_pixel & {2{color[2]}};
    assign g_o = current_pixel & {2{color[1]}};
    assign b_o = current_pixel & {2{color[0]}};


    //======================================\\
    `ifdef SIM
    generate
        for ( genvar ntbl_r_GEN = 0; ntbl_r_GEN < 30; ntbl_r_GEN = ntbl_r_GEN+1 ) begin : ntbl_row
            for ( genvar ntbl_c_GEN = 0; ntbl_c_GEN < 32; ntbl_c_GEN = ntbl_c_GEN+1 ) begin : ntbl_column
                wire colorselect = `NTBL_TILE_COLORSELECT(ntbl_r_GEN,ntbl_c_GEN);
                wire hflip = `NTBL_TILE_HFLIP(ntbl_r_GEN,ntbl_c_GEN);
                wire vflip = `NTBL_TILE_VFLIP(ntbl_r_GEN,ntbl_c_GEN);
                wire [4:0] pmba = `NTBL_TILE_PMBA(ntbl_r_GEN,ntbl_c_GEN);
            end
        end
    endgenerate
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
