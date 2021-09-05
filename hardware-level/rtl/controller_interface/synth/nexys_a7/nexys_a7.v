
`ifdef LINTER
    `include "hardware-level/rtl/controller_interface/rtl/controller_interface.sv"
    `include "hardware-level/rtl/misc/clk_100_TO_clk_PARAM.v"
`endif

module nexys_a7 (
    input               CLK100MHZ,
    input               CPU_RESETN,

    output wire                       JD_03, JD_04,
    input                      JD_02,

    output wire  [15:0] LED
);

    wire clk_PARAM;

    clk_100_TO_clk_PARAM_m #(0.425) clk_100_TO_clk_PARAM ( // reset must be 235 for some reason...
        clk_PARAM,
        CLK100MHZ
    );

    reg [5:0] timer;
    initial timer = 0;
    always @ ( negedge clk_PARAM ) timer <= timer + 1;

    wire controller_start_fetch = ( timer < 4 );
    wire controller_clk;
    wire controller_latch;
    wire controller_data_B;
    wire [3:0] num_bits_left;

    wire [7:0] controller_buttons_out;

    assign controller_data_B = JD_02;
    assign JD_03 = controller_latch;
    assign JD_04 = controller_clk;
    assign LED = {controller_data_B,3'b0,num_bits_left,controller_buttons_out};

    controller_interface_m #(1) controller_interface (
        clk_PARAM, ~CPU_RESETN,
        controller_start_fetch,

        controller_clk,
        controller_latch,

        controller_data_B,

        controller_buttons_out
    );


endmodule
