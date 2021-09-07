
`ifndef __UCSBIEEE__ADDRESS_BUS__RTL__ADDRESS_BUS_V
`define __UCSBIEEE__ADDRESS_BUS__RTL__ADDRESS_BUS_V


`define __INCBOUND(LEFT,SRC,RIGHT)   ( LEFT <= SRC && SRC <= RIGHT )

module address_bus_m (
    input [15:0] cpu_address,

    output wire SELECT_ram,
    output wire SELECT_vram,
    output wire SELECT_firmware,
    output wire SELECT_rom,
    output wire SELECT_vectors,

    output wire SELECT_in_vblank,
    output wire SELECT_clr_vblank_irq,
    output wire SELECT_controller_1,
    output wire SELECT_controller_2
);



    // memory
    assign SELECT_ram       = `__INCBOUND(16'h0000,cpu_address,16'h36ff);

    assign SELECT_vram      = `__INCBOUND(16'h3700,cpu_address,16'h3fff);

    assign SELECT_firmware  = `__INCBOUND(16'h4000,cpu_address,16'h6fff);

    assign SELECT_rom       = `__INCBOUND(16'h8000,cpu_address,16'hfff9);

    assign SELECT_vectors   = `__INCBOUND(16'hfffa,cpu_address,16'hffff);



    // IO
    assign SELECT_in_vblank         = ( cpu_address == 16'h7000 );

    assign SELECT_clr_vblank_irq    = ( cpu_address == 16'h7001 );

    assign SELECT_controller_1      = ( cpu_address == 16'h7002 );
    assign SELECT_controller_2      = ( cpu_address == 16'h7003 );




endmodule


`undef __INCBOUND
`endif
