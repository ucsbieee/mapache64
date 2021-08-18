
`ifdef LINTER
    `include "../../../rtl/top.v"
    `include "../../misc/clk_100_TO_clk_PARAM.v"
    `include "../../misc/clk_100_TO_clk_12_5875.vh"
`endif

module cmod_a7 (
    input
        sysclk,
                pio02,  pio03,  pio04,  pio05,  pio06,
        pio07,  pio08,  pio09,  pio10,  pio11,  pio12,
        pio13,  pio14,                  pio17,  pio18,
        pio19,  pio20,  pio21,
    inout
                                pio22,  pio23,
                pio26,  pio27,  pio28,  pio29,  pio30,
        pio31,
    output wire
                                pio34,  pio35,  pio36,
                pio38,  pio39,  pio40,  pio41,  pio42,
        pio43,  pio44,  pio45,  pio46
);



    // internal
    wire fpga_data_enable;



    // inout
    wire [7:0] data, data_in, data_out;
    assign data = fpga_data_enable ? data_out : data_in;



    // input
    wire        clk_12_5875;
    wire        clk_PARAM;
    wire        rst;
    wire [15:0] cpu_address;
    wire        write_enable_B;

    assign  clk_12_5875     = sysclk;
    wire controller_2_data_in_B;

        // modified Cmod A7 to have a 100 MHz Oscillator
    clk_100_TO_clk_12_5875_m clk_100_TO_clk_12_5875 (
        clk_12_5875,
        sysclk

    assign  rst             = pio02;
    assign  cpu_address     = {pio21,pio20,pio19,pio18,pio17,pio14,pio13,pio12,pio11,pio10,pio09,pio08,pio07,pio06,pio05,pio04};
    assign  data_in         = {pio31,pio30,pio29,pio28,pio27,pio26,pio23,pio22};
    assign  write_enable_B  = pio03;

    clk_100_TO_clk_PARAM_m #(0.05) clk_100_TO_clk_PARAM (
        clk_PARAM,
        sysclk


    // output
    wire        SELECT_ram_B;
    wire        ram_OE_B;
    wire        SELECT_rom_B;
    wire        vblank_irq_B;

    wire  [1:0] r;
    wire  [1:0] g;
    wire  [1:0] b;
    wire        hsync;
    wire        vsync;

    assign pio31 = fpga_data_enable ? data_out[7] : {1'bz};
    assign pio30 = fpga_data_enable ? data_out[6] : {1'bz};
    assign pio29 = fpga_data_enable ? data_out[5] : {1'bz};
    assign pio28 = fpga_data_enable ? data_out[4] : {1'bz};
    assign pio27 = fpga_data_enable ? data_out[3] : {1'bz};
    assign pio26 = fpga_data_enable ? data_out[2] : {1'bz};
    assign pio23 = fpga_data_enable ? data_out[1] : {1'bz};
    assign pio22 = fpga_data_enable ? data_out[0] : {1'bz};

    assign pio34            = SELECT_ram_B;
    assign pio35            = ram_OE_B;
    assign pio36            = SELECT_rom_B;
    assign pio38            = vblank_irq_B;

    assign {pio39,pio40}    = r;
    assign {pio41,pio42}    = g;
    assign {pio43,pio44}    = b;
    assign pio45            = hsync;
    assign pio46            = vsync;



    // unused
    wire [14:0] output_address;
    wire        SELECT_controller;



    // module
    top_m #(12) top (
        clk_12_5875, rst,
        cpu_address,
        data_in,
        data_out,
        fpga_data_enable,
        write_enable_B,

        output_address,
        SELECT_ram_B,
        ram_OE_B,
        SELECT_rom_B,
        SELECT_controller,
        vblank_irq_B,

        r, g, b,
        hsync, vsync
    );



endmodule
