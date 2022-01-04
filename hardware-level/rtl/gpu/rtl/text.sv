
/* background.v */

`ifndef __UCSBIEEE__GPU__RTL__TEXT_SV
`define __UCSBIEEE__GPU__RTL__TEXT_SV


`ifdef LINTER
    `include "hardware-level/rtl/gpu/rtl/vram_parameters.v"
`endif


module text_m (
    input                           gpu_clk,
    input                           cpu_clk,

    // video timing input
    input                     [7:0] current_x, current_y,

    // video output
    output wire                     color,
    output wire                     valid,

    // VRAM interface
    input                     [7:0] data_in,
    input    [`VRAM_ADDR_WIDTH-1:0] vram_address,
    input                           write_enable,
    input                           SELECT_txbl
);

    wire [4:0] txbl_r       = current_y[7:3];
    wire [2:0] in_tile_x    = current_x[2:0];
    wire [4:0] txbl_c       = current_x[7:3];
    wire [2:0] in_tile_y    = current_y[2:0];



    // Text Table
    reg [7:0]   TXBL    [1023:0];

    `define TXBL_TILE(R,C)                      TXBL[ {$unsigned(5'(R)), $unsigned(5'(C))} ]
    `define TXBL_TILE_COLORSELECT(R,C)          `TXBL_TILE(R,C)[7]
    `define TXBL_TILE_PMCA(R,C)                 `TXBL_TILE(R,C)[6:0]
    // -------------------------

    // Character Pattern Memory
    reg [7:0]  PMC      [1023:0];
    initial $readmemb( "pmc.mem", PMC, 0, 1023 );

    `define PMC_VALID(PMCA,PATTERN_X,PATTERN_Y) PMC[ {$unsigned(7'(PMCA)), $unsigned(3'(PATTERN_Y))} ][3'h7-$unsigned(3'(PATTERN_X))]
    // -------------------------

    // write to vram
    always_ff @ ( negedge cpu_clk ) begin : write_to_vram
        if ( write_enable && SELECT_txbl ) begin
            TXBL[ vram_address - 12'h900 ] <= data_in;
        end
    end

    wire [6:0] pmca = `TXBL_TILE_PMCA(txbl_r, txbl_c);

    assign color = `TXBL_TILE_COLORSELECT(txbl_r, txbl_c);
    assign valid = `PMC_VALID(pmca, in_tile_x, in_tile_y);


    //======================================\\
    `ifdef SIM
    generate
        for ( genvar txbl_r_GEN = 0; txbl_r_GEN < 30; txbl_r_GEN = txbl_r_GEN+1 ) begin : txbl_row
            for ( genvar txbl_c_GEN = 0; txbl_c_GEN < 32; txbl_c_GEN = txbl_c_GEN+1 ) begin : txbl_column
                wire colorselect = `TXBL_TILE_COLORSELECT(txbl_r_GEN,txbl_c_GEN);
                wire [4:0] pmba = `TXBL_TILE_PMCA(txbl_r_GEN,txbl_c_GEN);
            end
        end
    endgenerate
    `endif
    //======================================\\


endmodule


`endif
