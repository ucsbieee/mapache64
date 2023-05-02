
module cmod_a7 (
    input               sysclk,
    input         [1:0] btn,
    output wire   [1:0] led,
    output wire   [2:0] led_rgbB,

    inout
        pio01,  pio02,  pio03,  pio04,  pio05,  pio06,
        pio07,  pio08,  pio09,  pio10,  pio11,  pio12,
        pio13,  pio14,                  pio17,  pio18,
        pio19,  pio20,  pio21,  pio22,  pio23,
                pio26,  pio27,  pio28,  pio29,  pio30,
        pio31,  pio32,  pio33,  pio34,  pio35,  pio36,
        pio37,  pio38,  pio39,  pio40,  pio41,  pio42,
        pio43,  pio44,  pio45,  pio46,  pio47,  pio48
);

    // internal
    wire clk_12_5875;
    wire clk_8;
    wire cpu_clk;
    wire gpu_clk;
    wire fpga_data_enable;

    wire controller_clk_in, controller_clk_out;


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
    assign  cpu_address     = {pio20,pio21,pio22,pio23,pio35,pio36,pio37,pio38,pio39,pio40,pio41,pio42,pio43,pio44,pio45,pio46};
    assign  data_in         = {pio19,pio18,pio17,pio14,pio13,pio12,pio11,pio10};
    assign  write_enable_B  = pio06;

    assign  controller_1_data_in_B  = pio03;
    assign  controller_2_data_in_B  = pio04;


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

    assign pio10 = fpga_data_enable ? data_out[0] : {1'bz};
    assign pio11 = fpga_data_enable ? data_out[1] : {1'bz};
    assign pio12 = fpga_data_enable ? data_out[2] : {1'bz};
    assign pio13 = fpga_data_enable ? data_out[3] : {1'bz};
    assign pio14 = fpga_data_enable ? data_out[4] : {1'bz};
    assign pio17 = fpga_data_enable ? data_out[5] : {1'bz};
    assign pio18 = fpga_data_enable ? data_out[6] : {1'bz};
    assign pio19 = fpga_data_enable ? data_out[7] : {1'bz};

    assign pio09 = ram_OE_B;
    assign pio08 = SELECT_ram_B;
    assign pio47 = SELECT_rom_B;
    assign pio05 = vblank_irq_B;

    assign pio28 = r[1];
    assign pio27 = r[0];
    assign pio30 = g[1];
    assign pio29 = g[0];
    assign pio32 = b[1];
    assign pio31 = b[0];
    assign pio33 = hsync;
    assign pio34 = vsync;

    assign pio48 = ~rst;
    assign pio07 = cpu_clk;

    assign pio02 = controller_latch;
    assign pio01 = controller_clk_out;

    assign pio26 = fpga_data_enable; // select expansion


    // unused
    wire [7:0] controller_1_buttons_out, controller_2_buttons_out;

    // module
    top #(
        .FOREGROUND_NUM_OBJECTS(mapache64::GpuForegroundNumObjects)
    ) top (
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
        controller_clk_out,
        controller_latch,
        controller_1_data_in_B,
        controller_2_data_in_B,
        controller_1_buttons_out,
        controller_2_buttons_out
    );

    clk_mmcm clk_src (
        clk_12_5875,
        clk_8,
        rst,
        sysclk
    );

    clk_divider #(8,4) cpu_clk_divider (
        clk_8, rst,
        cpu_clk
    );

    clk_divider #(8,0.5) controller_clk_divider (
        clk_8, rst,
        controller_clk_in
    );

    assign gpu_clk = clk_12_5875;


    assign led[0] = ( cpu_address == 16'hb006 );


endmodule
