
/* background.v */

module background (
    input   logic                       cpu_clk,

    // video timing input
    input   logic [7:0]                 display_x_i, display_y_i,

    // video output
    output  logic [1:0]                 r_o, g_o, b_o,

    // VRAM interface
    input   mapache64::data_t           vram_wdata_i,
    output  mapache64::data_t           vram_rdata_o,
    input   mapache64::vram_address_t   vram_address_i,
    input   logic                       vram_wen_i,
    input   logic                       SELECT_pmb_i, SELECT_ntbl_i
);

    // ======== VRAM ======== \\

    // Background Pattern Memory (https://mapache64.ucsbieee.org/guides/gpu/#Pattern-Memory)
    // 1 2-word read port
    // 1 1-word read port
    mapache64::data_t PMB[512];

    `define pmb_line(PMBA, Y) (16'({ \
        PMB[ {5'(PMBA), 3'(Y), 1'b0} ], \
        PMB[ {5'(PMBA), 3'(Y), 1'b1} ] \
    }))

    // Nametable (https://mapache64.ucsbieee.org/guides/gpu/#Nametable)
    mapache64::data_t NTBL[1024];
    // 2 1-word read port
    // 1 1-word read port (color)

    `define ntbl_tile(R, C) (mapache64::ntbl_tile_t'( \
        NTBL[ {5'(R), 5'(C)} ] \
    ))
    `define ntbl_colors (6'(NTBL[ 960 ]))



    // ======== VRAM Interface ======== \\

    wire [8:0] pmb_address = 9'(vram_address_i - 12'h200);
    wire [9:0] ntbl_address = 10'(vram_address_i - 12'h400);

    // read from vram
    assign vram_rdata_o =
        SELECT_pmb_i  ? PMB[ pmb_address ]    :
        SELECT_ntbl_i ? NTBL[ ntbl_address ]  :
        'x;

    // write to vram
    always_ff @(negedge cpu_clk) begin : write_to_vram
        if ( vram_wen_i ) begin
            if ( SELECT_pmb_i )
                PMB[ pmb_address ] <= vram_wdata_i;
            if ( SELECT_ntbl_i )
                NTBL[ ntbl_address ] <= vram_wdata_i;
        end
    end



    // ======== Display ======== \\

    wire [4:0] display_row  = display_y_i[7:3];
    wire [2:0] display_inty = display_y_i[2:0];
    wire [4:0] display_col  = display_x_i[7:3];
    wire [2:0] display_intx = display_x_i[2:0];

    // Read from NTBL
    mapache64::ntbl_tile_t display_tile;
    assign display_tile = `ntbl_tile(display_row, display_col);

    // Find color
    logic [2:0] ntbl_color1, ntbl_color0;
    assign {ntbl_color1,ntbl_color0} = `ntbl_colors;
    wire [2:0] display_color = display_tile.colorselect ? ntbl_color1 : ntbl_color0;

    // get (flipped) addresses into pattern
    wire [2:0] display_pattern_y = display_tile.vflip ? (3'h7-display_inty) : display_inty;
    wire [2:0] display_pattern_x = display_tile.hflip ? (3'h7-display_intx) : display_intx;

    // Read from PMB
    logic [15:0] display_line;
    assign display_line = `pmb_line( display_tile.pmba, display_pattern_y );

    // Find lightness
    wire [1:0] display_lightness = display_line[ {(3'h7-display_pattern_x),1'b0} +: 2 ];

    // Display rgb
    assign r_o = display_lightness & {2{display_color[2]}};
    assign g_o = display_lightness & {2{display_color[1]}};
    assign b_o = display_lightness & {2{display_color[0]}};



    // ======== Debug ======== \\

    `ifdef SIM
    generate
        for ( genvar ntbl_r_GEN = 0; ntbl_r_GEN < 30; ntbl_r_GEN++ ) begin : ntbl_row
            for ( genvar ntbl_c_GEN = 0; ntbl_c_GEN < 32; ntbl_c_GEN++ ) begin : ntbl_column
                mapache64::ntbl_tile_t tile;
                assign tile = `ntbl_tile(ntbl_r_GEN,ntbl_c_GEN);
            end
        end
    endgenerate
    generate for ( genvar pattern_GEN = 0; pattern_GEN < 32; pattern_GEN++ ) begin : pattern
        logic [15:0] line0; assign line0 = `pmb_line(pattern_GEN,3'd0);
        logic [15:0] line1; assign line1 = `pmb_line(pattern_GEN,3'd1);
        logic [15:0] line2; assign line2 = `pmb_line(pattern_GEN,3'd2);
        logic [15:0] line3; assign line3 = `pmb_line(pattern_GEN,3'd3);
        logic [15:0] line4; assign line4 = `pmb_line(pattern_GEN,3'd4);
        logic [15:0] line5; assign line5 = `pmb_line(pattern_GEN,3'd5);
        logic [15:0] line6; assign line6 = `pmb_line(pattern_GEN,3'd6);
        logic [15:0] line7; assign line7 = `pmb_line(pattern_GEN,3'd7);
    end endgenerate
    `endif


endmodule
