
`ifdef LINTER
    `include "../../../rtl/top.v"
    `include "modules/clk_100_TO_clk_PARAM.v"
`endif

module nexys_a7 (
    input CLK100MHZ,
    input CPU_RESETN,
    input
        JA_01, JA_02, JA_03, JA_04, JA_07, JA_08, JA_09, JA_10,
        JB_01, JB_02, JB_03, JB_04, JB_07, JB_08, JB_09, JB_10,
    inout
        JC_01, JC_02, JC_03, JC_04, JC_07, JC_08, JC_09, JC_10,
    output wire
        JD_01, JD_02, JD_04, JD_07, JD_08, JD_09,
    input
        JD_03,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire VGA_HS,
    output wire VGA_VS,

    output wire [15:0] LED,
    input [15:0] SW,
    input BTNC
);


    // internal
    wire fpga_data_enable;



    // inout
    wire [7:0] data, data_in, data_out;
    assign data = fpga_data_enable ? data_out : data_in;



    // input
    wire        clk_12_5875;
    wire        rst;
    wire [15:0] cpu_address;
    wire        write_enable_B;

    wire        clk_cpu;

    clk_100_TO_clk_12_5875_m clk_100_TO_clk_12_5875 (
        clk_12_5875,
        CLK100MHZ
    );

    assign  rst             = ~CPU_RESETN;
    assign  cpu_address     = {JB_10,JB_09,JB_08,JB_07,JB_04,JB_03,JB_02,JB_01,JA_10,JA_09,JA_08,JA_07,JA_04,JA_03,JA_02,JA_01};
    assign  data_in         = {JC_10,JC_09,JC_08,JC_07,JC_04,JC_03,JC_02,JC_01};
    assign  write_enable_B  = JD_03;

    clk_100_TO_clk_PARAM_m #(0.05) clk_100_TO_clk_PARAM (
        clk_cpu,
        CLK100MHZ
    );


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

    wire        cpu_clk;

    assign  JC_01   = fpga_data_enable ? data_out[0] : {1'bz};
    assign  JC_02   = fpga_data_enable ? data_out[1] : {1'bz};
    assign  JC_03   = fpga_data_enable ? data_out[2] : {1'bz};
    assign  JC_04   = fpga_data_enable ? data_out[3] : {1'bz};
    assign  JC_07   = fpga_data_enable ? data_out[4] : {1'bz};
    assign  JC_08   = fpga_data_enable ? data_out[5] : {1'bz};
    assign  JC_09   = fpga_data_enable ? data_out[6] : {1'bz};
    assign  JC_10   = fpga_data_enable ? data_out[7] : {1'bz};

    assign  JD_07    = SELECT_ram_B;
    assign  JD_08    = ram_OE_B;
    assign  JD_09    = SELECT_rom_B;
    assign  JD_02    = vblank_irq_B;

    assign  VGA_R   = {r, 2'b0};
    assign  VGA_G   = {g, 2'b0};
    assign  VGA_B   = {b, 2'b0};
    assign  VGA_HS  = hsync;
    assign  VGA_VS  = vsync;

    assign  JD_01    = ~rst;
    assign  JD_04    = cpu_clk;

    // switch 0 controls led output
    assign LED = SW[0] ? cpu_address : {8'b0, data};
    // switch 1 controls cpu clock source
    assign cpu_clk = SW[1] ? clk_cpu : BTNC;



    // unused
    wire [14:0] output_address;
    wire        SELECT_controller;



    // module
    top_m #(16) top (
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
