
module text (
    input   logic                       cpu_clk,

    // video timing input
    input   logic [7:0]                 display_x_i, display_y_i,

    // video output
    output  logic                       display_color_o,
    output  logic                       display_valid_o,

    // VRAM interface
    input   mapache64::data_t           vram_wdata_i,
    output  mapache64::data_t           vram_rdata_o,
    input   mapache64::vram_address_t   vram_address_i,
    input   logic                       vram_wen_i,
    input   logic                       SELECT_txbl_i
);

    // ======== VRAM ======== \\

    // Text Table (https://mapache64.ucsbieee.org/guides/gpu/#Text-Table)
    mapache64::data_t TXBL[1024];

    function automatic mapache64::txbl_tile_t txbl_tile(logic [4:0] r, c);
        return TXBL[ {r, c} ];
    endfunction

    // Character Pattern Memory
    mapache64::data_t PMC[1024];
    initial $readmemb( "pmc.mem", PMC, 0, 1023 );

    function automatic logic pmc_valid(logic [6:0] pmca, logic [2:0] y, logic [2:0] x);
        mapache64::data_t pmc_line = PMC[ {pmca, y} ];
        return pmc_line[3'd7-x];
    endfunction



    // ======== VRAM Interface ======== \\

    wire [9:0] txbl_address = 10'(vram_address_i - 12'h900);

    // read from vram
    assign vram_rdata_o =
        SELECT_txbl_i ? TXBL[ txbl_address ]  :
        'x;

    // write to vram
    always_ff @(negedge cpu_clk) begin : write_to_vram
        if ( vram_wen_i && SELECT_txbl_i ) begin
            TXBL[ txbl_address ] <= vram_wdata_i;
        end
    end



    // ======== Display ======== \\

    wire [4:0] display_row  = display_y_i[7:3];
    wire [2:0] display_inty = display_y_i[2:0];
    wire [4:0] display_col  = display_x_i[7:3];
    wire [2:0] display_intx = display_x_i[2:0];

    mapache64::txbl_tile_t display_tile;
    assign display_tile = txbl_tile(display_row,display_col);

    assign display_color_o = display_tile.colorselect;
    assign display_valid_o = pmc_valid(display_tile.pmca, display_inty, display_intx);



    // ======== Debug ======== \\

    `ifdef SIM
    initial for (integer i = 0; i < 1024; i=i+1)  TXBL[i] = 0;
    generate
        for ( genvar txbl_row_GEN = 0; txbl_row_GEN < 30; txbl_row_GEN = txbl_row_GEN+1 ) begin : txbl_row
            for ( genvar txbl_col_GEN = 0; txbl_col_GEN < 32; txbl_col_GEN = txbl_col_GEN+1 ) begin : txbl_column
                mapache64::txbl_tile_t tile;
                assign tile = txbl_tile(txbl_row_GEN, txbl_col_GEN);
            end
        end
    endgenerate
    `endif


endmodule
