
module text (
    input   logic                       cpu_clk,

    // video timing input
    input   logic [7:0]                 current_x_i, current_y_i,

    // video output
    output  logic                       color_o,
    output  logic                       valid_o,

    // VRAM interface
    input   mapache64::data_t           data_i,
    output  mapache64::data_t           data_o,
    input   mapache64::vram_address_t   vram_address_i,
    input   logic                       wen_i,
    input   logic                       SELECT_txbl_i
);

    wire [4:0] txbl_r       = current_y_i[7:3];
    wire [2:0] in_tile_x    = current_x_i[2:0];
    wire [4:0] txbl_c       = current_x_i[7:3];
    wire [2:0] in_tile_y    = current_y_i[2:0];



    // Text Table
    mapache64::data_t TXBL [1023:0];

    `define TXBL_TILE(R,C)                      TXBL[ {$unsigned(5'(R)), $unsigned(5'(C))} ]
    `define TXBL_TILE_COLORSELECT(R,C)          `TXBL_TILE(R,C)[7]
    `define TXBL_TILE_PMCA(R,C)                 `TXBL_TILE(R,C)[6:0]
    // -------------------------

    // Character Pattern Memory
    mapache64::data_t PMC [1023:0];
    initial $readmemb( "pmc.mem", PMC, 0, 1023 );

    `define PMC_VALID(PMCA,PATTERN_X,PATTERN_Y) PMC[ {$unsigned(7'(PMCA)), $unsigned(3'(PATTERN_Y))} ][3'h7-$unsigned(3'(PATTERN_X))]
    // -------------------------

    wire [9:0] txbl_address = 10'(vram_address_i - 12'h900);

    // read from vram
    assign data_o =
        SELECT_txbl_i ? TXBL[ txbl_address ]  :
        {8{1'bz}};

    // write to vram
    always_ff @(negedge cpu_clk) begin : write_to_vram
        if ( wen_i && SELECT_txbl_i ) begin
            TXBL[ txbl_address ] <= data_i;
        end
    end

    wire [6:0] pmca = `TXBL_TILE_PMCA(txbl_r, txbl_c);

    assign color_o = `TXBL_TILE_COLORSELECT(txbl_r, txbl_c);
    assign valid_o = `PMC_VALID(pmca, in_tile_x, in_tile_y);


    //======================================\\
    `ifdef SIM
    initial for (integer i = 0; i < 1024; i=i+1)  TXBL[i] = 0;
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
