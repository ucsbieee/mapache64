
module address_bus (
    input   mapache64::address_t    cpu_address_i,

    output  logic                   SELECT_ram_o,

    output  logic                   SELECT_vram_o,
    output  logic                   SELECT_pmf_o,
    output  logic                   SELECT_pmb_o,
    output  logic                   SELECT_ntbl_o,
    output  logic                   SELECT_obm_o,
    output  logic                   SELECT_txbl_o,

    output  logic                   SELECT_firmware_o,
    output  logic                   SELECT_rom_o,
    output  logic                   SELECT_vectors_o,

    output  logic                   SELECT_in_vblank_o,
    output  logic                   SELECT_clr_vblank_irq_o,
    output  logic                   SELECT_controller_1_o,
    output  logic                   SELECT_controller_2_o
);


    // memory
    assign SELECT_ram_o         = mapache64::in_bounds16(16'h0000,cpu_address_i,16'h3fff);

    assign SELECT_vram_o        = mapache64::in_bounds16(16'h4000,cpu_address_i,16'h4fff);
    assign SELECT_pmf_o         = mapache64::in_bounds16(16'h4000,cpu_address_i,16'h41ff);
    assign SELECT_pmb_o         = mapache64::in_bounds16(16'h4200,cpu_address_i,16'h43ff);
    assign SELECT_ntbl_o        = mapache64::in_bounds16(16'h4400,cpu_address_i,16'h47ff);
    assign SELECT_obm_o         = mapache64::in_bounds16(16'h4800,cpu_address_i,16'h48ff);
    assign SELECT_txbl_o        = mapache64::in_bounds16(16'h4900,cpu_address_i,16'h4cff);

    assign SELECT_firmware_o    = mapache64::in_bounds16(16'h5000,cpu_address_i,16'h6fff);

    assign SELECT_rom_o         = mapache64::in_bounds16(16'h8000,cpu_address_i,16'hfff9);

    assign SELECT_vectors_o     = mapache64::in_bounds16(16'hfffa,cpu_address_i,16'hffff);


    // IO
    assign SELECT_in_vblank_o       = ( cpu_address_i == 16'h7000 );

    assign SELECT_clr_vblank_irq_o  = ( cpu_address_i == 16'h7001 );

    assign SELECT_controller_1_o    = ( cpu_address_i == 16'h7002 );
    assign SELECT_controller_2_o    = ( cpu_address_i == 16'h7003 );


endmodule
