
`ifdef LINTER
    `include "hardware-level/rtl/controller_interface/rtl/controller.sv"
    `include "hardware-level/rtl/top/rtl/top.v"
    `include "hardware-level/rtl/misc/clk_mask.v"
    `include "hardware-level/rtl/top/synth/boards/nexys_a7/clk_mmcm.vh"
`endif

module nexys_a7 (
    input               CLK100MHZ,
    input               CPU_RESETN,

    input               JA_01, JA_02, JA_03, JA_04, JA_07, JA_08, JA_09, JA_10,
    input               JB_01, JB_02, JB_03, JB_04, JB_07, JB_08, JB_09, JB_10,
    inout               JC_01, JC_02, JC_03, JC_04, JC_07, JC_08, JC_09, JC_10,
    output wire         JD_01, JD_02,        JD_04, JD_07, JD_08, JD_09,
    input                             JD_03,

    output wire   [3:0] VGA_R,
    output wire   [3:0] VGA_G,
    output wire   [3:0] VGA_B,
    output wire         VGA_HS,
    output wire         VGA_VS,

    input               BTNC, BTNU, BTNL, BTNR, BTND,
    input        [15:0] SW,
    output wire  [15:0] LED
);


    // internal
    wire clk_12_5875;
    wire clk_5;
    wire cpu_clk_enable;
    wire fpga_data_enable;

    wire controller_clk_in_enable, controller_clk_out_enable;
    wire controller_latch;
    wire controller_1_data_in_B;


    // inout
    wire [7:0] data, data_in, data_out;
    assign data = fpga_data_enable ? data_out : data_in;



    // input
    wire        rst;
    wire [15:0] cpu_address;
    wire        write_enable_B;

    assign  rst             = ~CPU_RESETN;
    assign  cpu_address     = {JB_10,JB_09,JB_08,JB_07,JB_04,JB_03,JB_02,JB_01,JA_10,JA_09,JA_08,JA_07,JA_04,JA_03,JA_02,JA_01};
    assign  data_in         = {JC_10,JC_09,JC_08,JC_07,JC_04,JC_03,JC_02,JC_01};
    assign  write_enable_B  = JD_03;

    wire [7:0] buttons;
    assign buttons = {BTNC, 1'b0, 1'b0, 1'b0, BTNU, BTND, BTNL, BTNR};


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

    wire  [7:0] controller_1_buttons_out;
    wire  [7:0] controller_2_buttons_out;

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
    assign  JD_04    = clk_5 && cpu_clk_enable;

    // switch 0 controls led output
    assign LED =
        ( SW == 16'h0 ) ? cpu_address                           :
        ( SW == 16'h1 ) ? {8'b0, data}                          :
        ( SW == 16'h2 ) ? {buttons, controller_1_buttons_out}   :
        16'h0;


    // unused
    wire controller_2_data_in_B = 1'b1;


    // module
    top_m #(2) top (
        clk_12_5875, clk_5, cpu_clk_enable, rst,
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

        controller_clk_in_enable,
        controller_clk_out_enable,
        controller_latch,
        controller_1_data_in_B,
        controller_2_data_in_B,
        controller_1_buttons_out,
        controller_2_buttons_out
    );

    clk_mmcm_m clk_src (
        clk_12_5875,
        clk_5,
        rst,
        CLK100MHZ
    );

    clk_mask_m #(5) clk_mask (
        clk_5, rst,
        cpu_clk_enable
    );

    clk_mask_m #(10) controller_clk_mask (
        clk_5, rst,
        controller_clk_in_enable
    );

    controller_m #(1'b1) controller (
        ~buttons,
        clk_5,
        controller_clk_out_enable,
        controller_latch,
        controller_1_data_in_B
    );


endmodule
