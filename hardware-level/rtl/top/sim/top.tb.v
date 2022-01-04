
`ifndef __UCSBIEEE__TOP__SIM__TOP_TB_V
`define __UCSBIEEE__TOP__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "hardware-level/rtl/top/rtl/top.sv"
    `include "hardware-level/rtl/misc/timing.v"
    `include "hardware-level/rtl/controller_interface/rtl/controller.sv"
`endif

`timescale `TIMESCALE

module top_tb_m ();

reg clk_12_5875 = 1;
always #( `GPU_CLK_PERIOD / 2 ) clk_12_5875 = ~clk_12_5875;
reg clk_1 = 1;
always #( `CPU_CLK_PERIOD / 2 ) clk_1 = ~clk_1;

wire            cpu_clk_enable;
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

wire            controller_clk_in;
wire            controller_clk_out_enable;
wire            controller_latch;
wire            controller_1_data_in_B;
wire            controller_2_data_in_B;
wire      [7:0] controller_1_buttons_out;
wire      [7:0] controller_2_buttons_out;

reg       [7:0] write_data;
assign data_in = write_data;
assign data = fpga_data_enable ? data_out : data_in;

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

    controller_clk_in,
    controller_clk_out_enable,
    controller_latch,
    controller_1_data_in_B,
    controller_2_data_in_B,
    controller_1_buttons_out,
    controller_2_buttons_out
);


reg [7:0] controller_1_buttons_in, controller_2_buttons_in;

controller_m #(1'b1) controller_1 (
    ~controller_1_buttons_in,
    controller_clk_in,
    controller_latch,
    controller_1_data_in_B
);

controller_m controller_2 (
    ~controller_2_buttons_in,
    controller_clk_in,
    controller_latch,
    controller_2_data_in_B
);


/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
$timeformat( -3, 6, "ms", 0);
//\\ =========================== \\//

rst = 1;
#( 2*`CPU_CLK_PERIOD );
rst = 0;

@(negedge vsync);

@(posedge clk_1);
write_enable_B = 0;

// txbl
@(posedge clk_1);
cpu_address = 16'h4900;
write_data = 8'b0;
@(posedge clk_1);
cpu_address = 16'h4901;
write_data = 8'h41; // A

// pmf
@(posedge clk_1);
for ( reg [7:0] i = 0; i < 16; i=i+1 ) begin
    cpu_address = {8'h40,i};
    write_data = i;
    @(posedge clk_1);
end
// x
cpu_address = 16'h4800;
write_data = 8'b0;
// y
@(posedge clk_1);
cpu_address = 16'h4801;
write_data = 8'b0;
// pmfa
@(posedge clk_1);
cpu_address = 16'h4802;
write_data = 8'b0;
// color
@(posedge clk_1);
cpu_address = 16'h4803;
write_data = 8'b111;

@(negedge vsync);


//\\ =========================== \\//
$finish ;
end

endmodule


`endif
