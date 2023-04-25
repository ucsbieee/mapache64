
`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

module top_tb ();

reg clk_12_5875 = 1;
always #( mapache64::ClkGpuPeriod / 2 ) clk_12_5875 <= ~clk_12_5875;
reg clk_1 = 1;
always #( mapache64::ClkCpuPeriod / 2 ) clk_1 <= ~clk_1;

wire                cpu_clk_enable;
reg                 rst;
mapache64::address_t cpu_address;
mapache64::data_t   data, data_in, data_out;
wire                fpga_data_enable;
reg                 wen_n;

wire                SELECT_ram_B;
wire                ram_OE_B;
wire                SELECT_rom_B;
wire                SELECT_controller_1;
wire                SELECT_controller_2;

wire                vblank_irq_B;

wire [1:0]          r, g, b;
wire                hsync, vsync;

wire                controller_clk_in;
wire                controller_clk_out;
wire                controller_latch;
wire                controller_1_data_in_B;
wire                controller_2_data_in_B;
mapache64::data_t   controller_1_buttons_out;
mapache64::data_t   controller_2_buttons_out;

reg       [7:0] write_data;
assign data_in = write_data;
assign data = fpga_data_enable ? data_out : data_in;

assign controller_clk_in = clk_1;

top #(mapache64::GpuForegroundNumObjects) top (
    clk_12_5875, clk_1, rst,

    cpu_address,
    data_in,
    data_out,
    fpga_data_enable,
    wen_n,

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


mapache64::data_t controller_1_buttons_in, controller_2_buttons_in;

controller #(1'b1) controller_1 (
    ~controller_1_buttons_in,
    controller_clk_out,
    controller_latch,
    controller_1_data_in_B
);

controller #(1'b1) controller_2 (
    ~controller_2_buttons_in,
    controller_clk_out,
    controller_latch,
    controller_2_data_in_B
);


/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
$timeformat( -3, 6, "ms", 0);
//\\ =========================== \\//

rst = 1;
#( 2*mapache64::ClkCpuPeriod );
rst = 0;

controller_1_buttons_in = 8'b01111111;
controller_2_buttons_in = 8'b11111110;

@(negedge vsync);

@(posedge clk_1);
wen_n = 0;
@(posedge clk_1);




// pmf
@(posedge clk_1);
for ( reg [7:0] i = 0; i < 16; i=i+1 ) begin
    cpu_address = {8'h40,i};
    write_data = i;
    @(posedge clk_1);
end

// x
cpu_address = 16'h4800;
write_data = 8'b0;
@(posedge clk_1);
// y
cpu_address = 16'h4801;
write_data = 8'b0;
@(posedge clk_1);
// pmfa
cpu_address = 16'h4802;
write_data = 8'b0;
@(posedge clk_1);
// color
cpu_address = 16'h4803;
write_data = 8'b111;
@(posedge clk_1);

// x
cpu_address = 16'h4810;
write_data = 8'h8;
@(posedge clk_1);
// y
cpu_address = 16'h4811;
write_data = 8'b0;
@(posedge clk_1);
// pmfa
cpu_address = 16'h4812;
write_data = 8'b1100000;
@(posedge clk_1);
// color
cpu_address = 16'h4813;
write_data = 8'b111;
@(posedge clk_1);

wen_n = 1;
@(posedge clk_1);

cpu_address = 16'h4810;
@(posedge clk_1);

@(negedge vsync);


//\\ =========================== \\//
$finish ;
end

endmodule
