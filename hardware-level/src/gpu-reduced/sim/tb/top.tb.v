
`ifndef __UCSBIEEE__GPU_OPTIMIZED__SIM__TB__TOP_TB_V
`define __UCSBIEEE__GPU_OPTIMIZED__SIM__TB__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "../../rtl/gpu.v"
    `include "../../rtl/headers/parameters.vh"
    `include "../headers/timing.vh"
    `include "../tests/fill_vram.v"
`endif

`timescale `TIMESCALE

module top_tb_m #(
    parameter TEST = 0
) ();

reg clk_12_5875 = 1;
always #( `GPU_CLK_PERIOD / 2 ) clk_12_5875 = ~clk_12_5875;

reg rst;
wire [1:0] r, g, b;
wire hsync, vsync;

wire [7:0] data;
reg [`VRAM_ADDR_WIDTH-1:0] address;
reg write_enable;

wire vblank_irq;
wire SELECT_in_vblank;
wire SELECT_clr_vblank_irq;

generate
    if ( TEST ) begin : using_fill_vram_m

        wire [7:0] data_fill_vram;
        wire [`VRAM_ADDR_WIDTH-1:0] address_fill_vram;
        wire write_enable_fill_vram;

        wire fill_vram_in_progress;

        gpu_m gpu (
            clk_12_5875, (fill_vram_in_progress|rst),
            r,g,b, hsync, vsync,
            data_fill_vram, address_fill_vram, write_enable_fill_vram,
            SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
        );

        fill_vram_m fill_vram (
            clk_12_5875, rst,
            data_fill_vram, address_fill_vram, write_enable_fill_vram,
            fill_vram_in_progress
        );

        /* Test */
        initial begin
        $dumpfile( "dump.fst" );
        $dumpvars();
        $timeformat( -3, 6, "ms", 0);
        //\\ =========================== \\//

        rst = 1;
        #( `GPU_CLK_PERIOD );
        rst = 0;

        #( 0.022 )

        //\\ =========================== \\//
        $finish ;
        end

    end else begin : manual

        reg [7:0] data_out;
        assign data = data_out;

        gpu_m gpu (
            clk_12_5875, rst,
            r,g,b, hsync, vsync,
            data, address, write_enable,
            SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
        );

        /* Test */
        initial begin
        $dumpfile( "dump.fst" );
        $dumpvars();
        $timeformat( -3, 6, "ms", 0);
        //\\ =========================== \\//

        rst = 1;
        write_enable = 1;

        // pmf
        address = 12'h000;
        data_out = 8'b0000_1111;
        #( `GPU_CLK_PERIOD );
        address = 12'h001;
        #( `GPU_CLK_PERIOD );
        address = 12'h002;
        #( `GPU_CLK_PERIOD );
        address = 12'h003;
        #( `GPU_CLK_PERIOD );
        address = 12'h004;
        #( `GPU_CLK_PERIOD );
        address = 12'h005;
        #( `GPU_CLK_PERIOD );
        address = 12'h006;
        #( `GPU_CLK_PERIOD );
        address = 12'h007;
        #( `GPU_CLK_PERIOD );

        // obm x
        address = 12'h800;
        data_out = 8'b0000_1111;
        #( `GPU_CLK_PERIOD );

        // obm y
        address = 12'h801;
        data_out = 8'b0000_1111;
        #( `GPU_CLK_PERIOD );

        // obm pmfa
        address = 12'h802;
        data_out = 8'b0000_0000;
        #( `GPU_CLK_PERIOD );

        // obm color
        address = 12'h803;
        data_out = 8'b0000_0111;
        #( `GPU_CLK_PERIOD );

        write_enable = 0;
        rst = 0;

        #( 0.02 )

        //\\ =========================== \\//
        $finish ;
        end

    end
endgenerate

endmodule


`endif
