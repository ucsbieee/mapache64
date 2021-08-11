
`ifdef LINTER
    `include "../../../rtl/top.v"
`endif

module cmod_a7 (
    input
        sysclk,
        pio2,
    input
        pio4,
        pio5,
        pio6,
        pio7,
        pio8,
        pio9,
        pio10,
        pio11,
        pio12,
        pio13,
        pio14,
        pio17,
        pio18,
        pio19,
        pio20,
        pio21,
    inout
        pio22,
        pio23,
        pio26,
        pio27,
        pio28,
        pio29,
        pio30,
        pio31,
    output wire
        pio32,
        pio34,
        pio36,
        pio38,
        pio39,
        pio40,
        pio41,
        pio42,
        pio43,
        pio44,
        pio45,
        pio46
);


    // inout
    wire  [7:0] data;


    // input
    wire        clk_12_5875;
    wire        rst;
    wire [15:0] cpu_address;
    wire        write_enable_B;

    assign  clk_12_5875     = sysclk;
    assign  rst             = pio2;
    assign  cpu_address     = {pio4,pio5,pio6,pio7,pio8,pio9,pio10,pio11,pio12,pio13,pio14,pio17,pio18,pio19,pio20,pio21};
    assign  data            = fpga_data_enable ? {8{1'bz}} : {pio22,pio23,pio26,pio27,pio28,pio29,pio30,pio31};
    assign  write_enable_B  = pio32;


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

    assign {pio22,pio23,pio26,pio27,pio28,pio29,pio30,pio31}
                            = fpga_data_enable ? data : {8{1'bz}};
    assign  pio34           = SELECT_ram_B;
    assign  pio36           = SELECT_rom_B;
    assign  pio38           = vblank_irq_B;
    assign  {pio39,pio40}   = r;
    assign  {pio41,pio42}   = g;
    assign  {pio43,pio44}   = b;
    assign  pio45           = hsync;
    assign  pio46           = vsync;


    // unused
    wire [14:0] output_address;
    wire        SELECT_controller;
    wire        fpga_data_enable;

    top_m top (
        clk_12_5875, rst,
        cpu_address,
        data,
        write_enable_B,

        output_address,
        fpga_data_enable,
        SELECT_ram_B,
        SELECT_rom_B,
        SELECT_controller,
        vblank_irq_B,

        r, g, b,
        hsync, vsync
    );

endmodule
