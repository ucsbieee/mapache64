
`ifdef LINTER
    `include "hardware-level/rtl/top/rtl/top.sv"
    `include "hardware-level/rtl/top/synth/boards/cmod_a7/clk_mmcm.vh"
    `include "hardware-level/rtl/misc/clk_divider.v"
`endif

module cmod_a7 (
    input               sysclk,
    input         [1:0] btn,
    output wire   [1:0] led,
    output wire   [2:0] led_rgbB,

    inout
                pio14,                  pio17,  pio18,
        pio19,  pio20,  pio21,  pio22,  pio23,
    input
                pio02,  pio03,
                                        pio29,  pio30,
        pio31,  pio32,  pio33,  pio34,  pio35,  pio36,
        pio37,  pio38,  pio39,  pio40,  pio41,  pio42,
        pio43,  pio44,  pio45,
    output wire
        pio01,                  pio04,  pio05,  pio06,
        pio07,  pio08,  pio09,  pio10,  pio11,  pio12,
        pio13,
                pio26,  pio27,  pio28,
                                pio46,  pio47,  pio48

    //     pio01,  pio02,  pio03,  pio04,  pio05,  pio06,
    //     pio07,  pio08,  pio09,  pio10,  pio11,  pio12,
    //     pio13,  pio14,                  pio17,  pio18,
    //     pio19,  pio20,  pio21,  pio22,  pio23,
    //             pio26,  pio27,  pio28,  pio29,  pio30,
    //     pio31,  pio32,  pio33,  pio34,  pio35,  pio36,
    //     pio37,  pio38,  pio39,  pio40,  pio41,  pio42,
    //     pio43,  pio44,  pio45,  pio46,  pio47,  pio48,
);

    // internal
    wire clk_12_5875;
    wire clk_8;
    wire cpu_clk;
    wire gpu_clk;
    wire fpga_data_enable;

    wire controller_clk_in, controller_clk_out_enable;


    // inout
    wire [7:0] data, data_in, data_out;
    assign data = fpga_data_enable ? data_out : data_in;


    // input
    wire        rst;
    wire [15:0] cpu_address;
    wire        write_enable_B;

    wire        controller_1_data_in_B;
    wire        controller_2_data_in_B;

    assign  rst             = btn[0];
    assign  cpu_address     = {pio30,pio31,pio32,pio33,pio34,pio35,pio36,pio37,pio38,pio39,pio40,pio41,pio42,pio43,pio44,pio45};
    assign  data_in         = {pio14,pio17,pio18,pio19,pio20,pio21,pio22,pio23};
    assign  write_enable_B  = pio29;

    assign  controller_1_data_in_B  = pio03;
    assign  controller_2_data_in_B  = pio02;


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

    wire        controller_latch;

    assign pio23 = fpga_data_enable ? data_out[0] : {1'bz};
    assign pio22 = fpga_data_enable ? data_out[1] : {1'bz};
    assign pio21 = fpga_data_enable ? data_out[2] : {1'bz};
    assign pio20 = fpga_data_enable ? data_out[3] : {1'bz};
    assign pio19 = fpga_data_enable ? data_out[4] : {1'bz};
    assign pio18 = fpga_data_enable ? data_out[5] : {1'bz};
    assign pio17 = fpga_data_enable ? data_out[6] : {1'bz};
    assign pio14 = fpga_data_enable ? data_out[7] : {1'bz};

    assign pio46 = ram_OE_B;
    assign pio47 = SELECT_ram_B;
    assign pio48 = SELECT_rom_B;
    assign pio28 = vblank_irq_B;

    assign pio12 = r[1];
    assign pio13 = r[0];
    assign pio10 = g[1];
    assign pio11 = g[0];
    assign pio08 = b[1];
    assign pio09 = b[0];
    assign pio07 = hsync;
    assign pio06 = vsync;

    assign pio26 = ~rst;
    assign pio27 = cpu_clk;

    assign pio04 = controller_latch;
    assign pio05 = controller_clk_out_enable & controller_clk_in;

    assign pio01 = fpga_data_enable;


    // unused
    wire [7:0] controller_1_buttons_out, controller_2_buttons_out;

    // module
    top_m top (
        clk_12_5875, cpu_clk, rst,
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

    clk_mmcm_m clk_src (
        clk_12_5875,
        clk_8,
        rst,
        sysclk
    );

    clk_divider_m #(8,4) cpu_clk_divider (
        clk_8, rst,
        cpu_clk
    );

    clk_divider_m #(8,0.5) controller_clk_divider (
        clk_8, rst,
        controller_clk_in
    );

    assign gpu_clk = clk_12_5875;


    assign led[0] = ( cpu_address == 16'hb006 );


endmodule
