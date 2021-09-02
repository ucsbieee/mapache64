
`ifndef __UCSBIEEE__ADDRESS_BUS__SIM__TOP_TB_V
`define __UCSBIEEE__ADDRESS_BUS__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "hardware-level/src/address_bus/rtl/address_bus.v"
`endif


module top_tb_m ();

reg [15:0] cpu_address;

wire SELECT_ram;
wire SELECT_vram;
wire SELECT_firmware;
wire SELECT_rom;

wire SELECT_in_vblank;
wire SELECT_clr_vblank_irq;
wire SELECT_controller_1;
wire SELECT_controller_2;

address_bus_m address_bus (
    cpu_address,

    SELECT_ram,
    SELECT_vram,
    SELECT_firmware,
    SELECT_rom,

    SELECT_in_vblank,
    SELECT_clr_vblank_irq,
    SELECT_controller_1,
    SELECT_controller_2
);


/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
//\\ =========================== \\//

cpu_address = 16'h0000; #1
cpu_address = 16'h36ff; #1

cpu_address = 16'h3700; #1
cpu_address = 16'h3fff; #1

cpu_address = 16'h4000; #1
cpu_address = 16'h6fff; #1

cpu_address = 16'h8000; #1
cpu_address = 16'hffff; #1

cpu_address = 16'h7000; #1
cpu_address = 16'h7001; #1

cpu_address = 16'h7002; #1
cpu_address = 16'h7003; #1


//\\ =========================== \\//
$finish ;
end

endmodule


`endif
