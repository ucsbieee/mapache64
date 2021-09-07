
`ifndef __UCSBIEEE__CONTROLLER_INTERFACE__SIM__TOP_TB_V
`define __UCSBIEEE__CONTROLLER_INTERFACE__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "hardware-level/rtl/controller_interface/rtl/controller_interface.sv"
    `include "hardware-level/rtl/controller_interface/rtl/controller.sv"
    `include "hardware-level/rtl/misc/timing.v"
`endif

`timescale `TIMESCALE

module top_tb_m ();

reg clk_1 = 1;
always #( `CPU_CLK_PERIOD / 2 ) clk_1 = ~clk_1;
wire clk_enable = 1;

reg start;
reg rst = 0;

wire controller_1_data_B;
wire controller_2_data_B;
wire controller_clk_enable;
wire controller_clk = ( clk_1 && controller_clk_enable );
wire controller_latch;

wire [7:0] controller_1_buttons_out;
wire [7:0] controller_2_buttons_out;

controller_interface_m #(2) controller_interface (
    clk_1, clk_enable, rst,
    start,

    controller_clk_enable,
    controller_latch,

    {controller_2_data_B,controller_1_data_B},

    {controller_2_buttons_out,controller_1_buttons_out}
);

reg [7:0] controller_1_buttons_in, controller_2_buttons_in;

controller_m controller_1 (
    ~controller_1_buttons_in,
    controller_clk,
    controller_clk_enable,
    controller_latch,
    controller_1_data_B
);

controller_m controller_2 (
    ~controller_2_buttons_in,
    controller_clk,
    controller_clk_enable,
    controller_latch,
    controller_2_data_B
);

/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
//\\ =========================== \\//

controller_1_buttons_in = 8'b11111110;
controller_2_buttons_in = 8'b01111111;
start = 0;
#( `CPU_CLK_PERIOD );

start = 1;
#( 9 * `CPU_CLK_PERIOD );

start = 0;
#( 8 * `CPU_CLK_PERIOD );

//\\ =========================== \\//
$finish ;
end

endmodule


`endif
