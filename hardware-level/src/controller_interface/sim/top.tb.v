
`ifndef __UCSBIEEE__CONTROLLER_INTERFACE__SIM__TOP_TB_V
`define __UCSBIEEE__CONTROLLER_INTERFACE__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `undef LINTER
    `include "../rtl/controller_interface.sv"
    `include "../rtl/controller.sv"
    `include "timing.vh"
`endif

`timescale `TIMESCALE

module top_tb_m ();

reg clk_1 = 1;
always #( `CPU_CLK_PERIOD / 2 ) clk_1 = ~clk_1;


reg start;

wire controller_1_data_B;
wire controller_2_data_B;
wire controller_clk;
wire controller_latch;

wire [7:0] controller_1_data_out;
wire [7:0] controller_2_data_out;


controller_interface_m controller_interface (
    clk_1,
    start,

    controller_clk,
    controller_latch,

    controller_1_data_B,
    controller_2_data_B,

    controller_1_data_out,
    controller_2_data_out
);

reg [7:0] controller_1_buttons, controller_2_buttons;
wire [7:0] controller_1_buttons_B = ~controller_1_buttons;
wire [7:0] controller_2_buttons_B = ~controller_2_buttons;

controller_m controller_1 (
    controller_1_buttons_B,
    controller_clk,
    controller_latch,
    controller_1_data_B
);

controller_m controller_2 (
    controller_2_buttons_B,
    controller_clk,
    controller_latch,
    controller_2_data_B
);

/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
//\\ =========================== \\//

controller_1_buttons = 8'b11111110;
controller_2_buttons = 8'b01111111;
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
