
`ifdef LINTER
    `include "hardware-level/rtl/controller_interface/rtl/controller_interface.sv"
    `include "hardware-level/rtl/misc/clk_mask.v"
    `include "hardware-level/rtl/top/synth/boards/nexys_a7/clk_mmcm.vh"
`endif

module nexys_a7 (
    input               CLK100MHZ,
    input               CPU_RESETN,

    output wire                       JD_03, JD_04,
    input                      JD_02,

    output wire  [15:0] LED
);

    wire rst = ~CPU_RESETN;
    wire clk_5, clk_12_5875;
    wire controller_clk_in_enable;

    clk_mmcm_m clk_src (
        clk_12_5875,
        clk_5,
        rst,
        CLK100MHZ
    );

    clk_mask_m #(5) clk_mask (
        clk_5, rst,
        controller_clk_in_enable
    );


    reg [7:0] timer;
    initial timer = 0;
    always @ ( negedge clk_5 ) begin
        if ( rst )
            timer <= 0;
        else
            timer <= timer + 1;
    end

    wire controller_start_fetch = ( timer < 4 );
    wire controller_clk_enable;
    wire controller_clk = ( clk_5 && controller_clk_enable );
    wire controller_latch;
    wire controller_data_B;
    wire [3:0] num_bits_left;

    wire [7:0] controller_buttons_out;

    assign controller_data_B = JD_02;
    assign JD_03 = controller_latch;
    assign JD_04 = controller_clk;
    assign LED = {controller_data_B,3'b0,num_bits_left,controller_buttons_out};

    controller_interface_m #(1) controller_interface (
        clk_5, controller_clk_in_enable, ~CPU_RESETN,
        controller_start_fetch,

        controller_clk_enable,
        controller_latch,

        controller_data_B,

        controller_buttons_out
    );


endmodule
