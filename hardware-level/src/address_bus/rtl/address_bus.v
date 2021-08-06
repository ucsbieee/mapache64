
`ifndef __UCSBIEEE__ADDRESS_BUS__RTL__ADDRESS_BUS_V
`define __UCSBIEEE__ADDRESS_BUS__RTL__ADDRESS_BUS_V


`define __INCBOUND(LEFT,SRC,RIGHT)   ( LEFT <= SRC && SRC <= RIGHT )

module address_bus_m (
    input [15:0] cpu_address,

    output [14:0] output_address,

    output SELECT_ram,
    output SELECT_vram,
    output SELECT_firmware,
    output SELECT_rom,

    output SELECT_in_vblank,
    output SELECT_clr_vblank_irq,
    output SELECT_controller
);



    // memory
    assign SELECT_ram = `__INCBOUND(16'h0000,cpu_address,16'h36ff);
    wire [13:0] ram_address = cpu_address[13:0];

    assign SELECT_vram = `__INCBOUND(16'h3700,cpu_address,16'h3fff);
    wire [11:0] vram_address = ( cpu_address - 16'h3700 );

    assign SELECT_firmware = `__INCBOUND(16'h4000,cpu_address,16'h6fff);
    wire [13:0] firmware_address = cpu_address;

    assign SELECT_rom = `__INCBOUND(16'h8000,cpu_address,16'hffff);
    wire [14:0] rom_address = cpu_address[14:0];



    // IO
    assign SELECT_in_vblank = ( cpu_address == 16'h7000 );

    assign SELECT_clr_vblank_irq = ( cpu_address == 16'h7001 );

    assign SELECT_controller = `__INCBOUND(16'h7002,cpu_address,16'h7003);
    wire controller_address = cpu_address[0] & 1'b1;



    // mux
    assign output_address =
        SELECT_ram          ? {1'bz,ram_address}                :
        SELECT_vram         ? {2'bzz,vram_address}              :
        SELECT_firmware     ? {1'bz,firmware_address}           :
        SELECT_rom          ? rom_address                       :

        SELECT_controller   ? {{14{1'bz}},controller_address}   :

        {15{1'bz}};



endmodule


`undef __INCBOUND
`endif
