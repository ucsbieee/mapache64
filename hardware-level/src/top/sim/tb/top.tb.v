
`ifndef __UCSBIEEE__TOP__SIM__TOP_TB_V
`define __UCSBIEEE__TOP__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "../../rtl/top.v"
    `include "../headers/timing.vh"
`endif

`timescale `TIMESCALE

module top_tb_m ();

reg clk_12_5875 = 1;
always #( `GPU_CLK_PERIOD / 2 ) clk_12_5875 = ~clk_12_5875;

reg             rst;
reg      [15:0] cpu_address;
wire      [7:0] data;
reg             write_enable;

wire     [14:0] output_address;
wire            SELECT_ram;
wire            SELECT_rom;
wire            SELECT_controller;

wire      [1:0] r, g, b;
wire            hsync, vsync, vblank_irq;

reg       [7:0] write_data;
assign data = write_enable ? write_data : {8{1'bz}};

top_m top (
    clk_12_5875, rst,
    cpu_address,
    data,
    write_enable,

    output_address,
    SELECT_ram,
    SELECT_rom,
    SELECT_controller,
    vblank_irq,

    r, g, b,
    hsync, vsync
);

/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
$timeformat( -3, 6, "ms", 0);
//\\ =========================== \\//

write_enable = 0;

rst = 1;
write_data = 8'hea;
write_enable = 1;
cpu_address = 16'h3700; #( `GPU_CLK_PERIOD );

write_enable = 0;
cpu_address = 16'h3fff; #( `GPU_CLK_PERIOD );
rst = 0;

cpu_address = 16'h0000; #( `GPU_CLK_PERIOD );
cpu_address = 16'h36ff; #( `GPU_CLK_PERIOD );

cpu_address = 16'h4000; #( `GPU_CLK_PERIOD );
cpu_address = 16'h4001; #( `GPU_CLK_PERIOD );
cpu_address = 16'h6fff; #( `GPU_CLK_PERIOD );

cpu_address = 16'h8000; #( `GPU_CLK_PERIOD );
cpu_address = 16'hffff; #( `GPU_CLK_PERIOD );

cpu_address = 16'h7000; #( `GPU_CLK_PERIOD );
cpu_address = 16'h7001; #( `GPU_CLK_PERIOD );

cpu_address = 16'h7002; #( `GPU_CLK_PERIOD );
cpu_address = 16'h7003; #( `GPU_CLK_PERIOD );

write_enable = 1;
cpu_address = 16'h7001; #( `GPU_CLK_PERIOD );
write_enable = 0;

@ ( vsync );

write_data = 8'h81;
write_enable = 1;
cpu_address = 16'h3900; #( `GPU_CLK_PERIOD );

#( `GPU_CLK_PERIOD );


//\\ =========================== \\//
$finish ;
end

endmodule


`endif
