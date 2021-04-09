
/* top.v */


`include "modules/gpu.v"
`include "modules/ram.v"

module top_m (
    input           clk, rst    ,
    output    [1:0] r, g, b
);

    reg WE = 0;
    wire [14:0] vram_addr;
    wire [7:0] vram_data;
    wire [1:0] gpu_r, gpu_g, gpu_b;
    wire visible;
    wire hsync, vsync;


    ram_m vram (
        .address( vram_addr ),
        .data( vram_data ),
        .WE( WE ),
        .OE( visible )
    );

    gpu_m gpu (
        .clk( clk ), .rst( rst ),
        .vram_addr( vram_addr ),
        .vram_data( vram_data ),
        .r( gpu_r ), .g( gpu_g ), .b( gpu_b ),
        .visible( visible ),
        .hsync( hsync ), .vsync( vsync )
    );


    // tie rgb low if outside visible area
    assign r = visible ? gpu_r : 0;
    assign g = visible ? gpu_g : 0;
    assign b = visible ? gpu_b : 0;


endmodule
