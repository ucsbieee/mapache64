
`ifdef LINTER
    `include "../../../rtl/top.v"
    `include "modules/clk_100_TO_clk_1.v"
`endif

module nexys_a7 (
    input CLK100MHZ,
    input CPU_RESETN,
    input
        JA_1, JA_2, JA_3, JA_4, JA_7, JA_8, JA_9, JA_10,
        JB_1, JB_2, JB_3, JB_4, JB_7, JB_8, JB_9, JB_10,
    inout
        JC_1, JC_2, JC_3, JC_4, JC_7, JC_8, JC_9, JC_10,
    output wire
        JD_1, JD_2, JD_4, JD_7, JD_8, JD_9,
    input
        JD_3,
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
    wire        fpga_data_enable;



    // inout
    wire  [7:0] data, data_in, data_out;



    // input
    wire        clk_12_5875;
    wire        rst;
    wire [15:0] cpu_address;
    wire        write_enable_B;

    clk_100_TO_clk_12_5875_m clk_100_TO_clk_12_5875 (
        clk_12_5875,
        CLK100MHZ
    );

    clk_100_TO_clk_1_m clk_100_TO_clk_1 (
        clk_1,
        CLK100MHZ
    );

    assign  rst             = ~CPU_RESETN;
    assign  cpu_address     = {JB_10,JB_9,JB_8,JB_7,JB_4,JB_3,JB_2,JB_1,JA_10,JA_9,JA_8,JA_7,JA_4,JA_3,JA_2,JA_1};
    assign  data_in         = {JC_10,JC_9,JC_8,JC_7,JC_4,JC_3,JC_2,JC_1};
    assign  data            = fpga_data_enable ? data_out : data_in;
    assign  write_enable_B  = JD_3;



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

    assign {JC_10,JC_9,JC_8,JC_7,JC_4,JC_3,JC_2,JC_1}
                            = fpga_data_enable ? data_out : {8{1'bz}};

    assign JC_10            = fpga_data_enable ? data_out[7] : {1'bz};
    assign JC_9             = fpga_data_enable ? data_out[6] : {1'bz};
    assign JC_8             = fpga_data_enable ? data_out[5] : {1'bz};
    assign JC_7             = fpga_data_enable ? data_out[4] : {1'bz};
    assign JC_4             = fpga_data_enable ? data_out[3] : {1'bz};
    assign JC_3             = fpga_data_enable ? data_out[2] : {1'bz};
    assign JC_2             = fpga_data_enable ? data_out[1] : {1'bz};
    assign JC_1             = fpga_data_enable ? data_out[0] : {1'bz};

    assign  JD_7            = SELECT_ram_B;
    assign  JD_8            = ram_OE_B;
    assign  JD_9            = SELECT_rom_B;
    assign  JD_2            = vblank_irq_B;
    assign  JD_1            = ~rst;
    assign  JD_4            = cpu_clk;

    assign VGA_R = {r, 2'b0};
    assign VGA_G = {g, 2'b0};
    assign VGA_B = {b, 2'b0};
    assign VGA_HS = hsync;
    assign VGA_VS = vsync;

    // switch 0 controls led output
    assign LED = SW[0] ? cpu_address : {8'b0, data};
    // switch 1 controls cpu clock source
    assign cpu_clk = SW[1] ? clk_1 : BTNC;



    // unused
    wire [14:0] output_address;
    wire        SELECT_controller;


    top_m #(32) top (
        clk_12_5875, rst,
        cpu_address,
        data_in,
        data_out,
        fpga_data_enable,
        write_enable_B,

        output_address,
        SELECT_ram_B,
        SELECT_rom_B,
        SELECT_controller,
        vblank_irq_B,

        r, g, b,
        hsync, vsync
    );

    assign ram_OE_B = ~( write_enable_B && !SELECT_ram_B );


endmodule
