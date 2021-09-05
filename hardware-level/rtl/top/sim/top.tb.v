
`ifndef __UCSBIEEE__TOP__SIM__TOP_TB_V
`define __UCSBIEEE__TOP__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "hardware-level/rtl/top/rtl/top.v"
    `include "hardware-level/rtl/misc/timing.v"
    `include "hardware-level/rtl/controller_interface/rtl/controller.sv"
`endif

`timescale `TIMESCALE

module top_tb_m ();

reg clk_12_5875 = 1;
always #( `GPU_CLK_PERIOD / 2 ) clk_12_5875 = ~clk_12_5875;
reg clk_1 = 1;
always #( `CPU_CLK_PERIOD / 2 ) clk_1 = ~clk_1;

reg             rst;
reg      [15:0] cpu_address;
wire      [7:0] data, data_in, data_out;
wire            fpga_data_enable;
reg             write_enable_B;

wire            SELECT_ram_B;
wire            ram_OE_B;
wire            SELECT_rom_B;
wire            SELECT_controller_1;
wire            SELECT_controller_2;

wire            vblank_irq_B;

wire      [1:0] r, g, b;
wire            hsync, vsync;

wire            controller_clk;
wire            controller_latch;
wire            controller_1_data_in_B;
wire            controller_2_data_in_B;
wire      [7:0] controller_1_buttons_out;
wire      [7:0] controller_2_buttons_out;

reg       [7:0] write_data;
assign data_in = write_data;
assign data = write_enable_B ? data_out : data_in;


top_m top (
    clk_12_5875, clk_1, rst,
    cpu_address,
    data_in,
    data_out,
    fpga_data_enable,
    write_enable_B,

    SELECT_ram_B,
    ram_OE_B,
    SELECT_rom_B,

    vblank_irq_B,

    r, g, b,
    hsync, vsync,

    controller_clk,
    controller_latch,
    controller_1_data_in_B,
    controller_2_data_in_B,
    controller_1_buttons_out,
    controller_2_buttons_out
);


reg [7:0] controller_1_buttons_in, controller_2_buttons_in;

controller_m #(1'b1) controller_1 (
    ~controller_1_buttons_in,
    controller_clk,
    controller_latch,
    controller_1_data_in_B
);

controller_m controller_2 (
    ~controller_2_buttons_in,
    controller_clk,
    controller_latch,
    controller_2_data_in_B
);


/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
$timeformat( -3, 6, "ms", 0);
//\\ =========================== \\//

controller_1_buttons_in = 8'b10001001;
controller_2_buttons_in = 8'b00100110;

write_enable_B = 0;
rst = 1;
#( `CPU_CLK_PERIOD );

cpu_address = 16'h3700;
write_data = 8'b10011001;
#( `CPU_CLK_PERIOD );

cpu_address = 16'h3701;
write_data = 8'b01000111;
#( `CPU_CLK_PERIOD );

cpu_address = 16'h3f00;
write_data = 8'h00;
#( `CPU_CLK_PERIOD );
cpu_address = 16'h3f01;
write_data = 8'h00;
#( `CPU_CLK_PERIOD );
cpu_address = 16'h3f02;
write_data = 8'bx00_00000;
#( `CPU_CLK_PERIOD );
cpu_address = 16'h3f03;
write_data = 8'bxxxxx_100;
#( `CPU_CLK_PERIOD );


cpu_address = 16'h3900;
write_data = 8'b11001100;
#( `CPU_CLK_PERIOD );
cpu_address = 16'h3901;
write_data = 8'b01010101;
#( `CPU_CLK_PERIOD );

// cpu_address = 16'h3b00;
// write_data = 8'b000_00000;
// #( `CPU_CLK_PERIOD );
cpu_address = 16'h3b01;
write_data = 8'b100_00000;
#( `CPU_CLK_PERIOD );


cpu_address = 16'h3ec0;
write_data = 8'bxx_010_101;
#( `CPU_CLK_PERIOD );


rst = 0;
write_enable_B = 1;

// @( vsync );

cpu_address = 16'h7003;
#( 16 * `CPU_CLK_PERIOD );



//\\ =========================== \\//
$finish ;
end

endmodule


`endif
