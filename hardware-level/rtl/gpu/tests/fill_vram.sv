
`ifndef __UCSBIEEE__GPU__TESTS__FILL_VRAM_SV
`define __UCSBIEEE__GPU__TESTS__FILL_VRAM_SV


`ifdef LINTER
    `include "hardware-level/rtl/gpu/rtl/vram_parameters.v"
    `include "hardware-level/rtl/gpu/rtl/gpu.v"
`endif

module fill_vram_m (
    input                               clk_12_5875,
    input                               start,

    output reg                    [7:0] data,
    output reg   [`VRAM_ADDR_WIDTH-1:0] address,
    output wire                         write_enable,

    output reg                          in_progress
);

    assign write_enable = in_progress;

    always_ff @ ( posedge clk_12_5875 ) begin : increment_address
        if ( start ) begin
            address = 12'b0;
            in_progress = 12'b1;
        end else if ( in_progress && (address < `VRAM_SIZE-1) ) begin
            address = address+1;
            in_progress = 12'b1;
        end else begin
            address = 12'b0;
            in_progress = 12'b0;
        end
    end



    wire in_pmf = ( address >= 12'h000 && address < 12'h200 );
    wire [11:0] pmfa = address;

    wire in_pmb = ( address >= 12'h200 && address < 12'h400 );
    wire [11:0] pmba = address - 12'h200;

    wire in_ntbl = ( address >= 12'h400 && address < 12'h800 );
    wire [11:0] ntbla = address - 12'h400;

    wire in_obm = ( address >= 12'h800 && address < 12'h900 );
    wire [11:0] obma = address - 12'h800;

    always_comb begin : set_data
        if ( in_ntbl ) begin
            if ( ntbla == 12'h3c0 ) // ntbl colors
                data = 8'bxx_101_010;
            else
                data = { 1'(ntbla&1'b1), 1'b0, 1'b0, 5'(ntbla&12'h001) };
        end
        else if ( in_pmb ) begin
            case ( pmba )
                12'h000: data = 8'b00_01_00_10; 12'h001: data = 8'b00_11_00_01;
                12'h002: data = 8'b01_00_10_00; 12'h003: data = 8'b11_00_01_00;
                12'h004: data = 8'b00_10_00_11; 12'h005: data = 8'b00_01_00_11;
                12'h006: data = 8'b10_00_11_00; 12'h007: data = 8'b01_00_11_00;
                12'h008: data = 8'b00_11_00_01; 12'h009: data = 8'b00_11_00_10;
                12'h00a: data = 8'b11_00_01_00; 12'h00b: data = 8'b11_00_10_00;
                12'h00c: data = 8'b00_01_00_11; 12'h00d: data = 8'b00_10_00_01;
                12'h00e: data = 8'b01_00_11_00; 12'h00f: data = 8'b10_00_01_00;

                11'h010: data = 8'b11_00_11_00; 12'h011: data = 8'b11_00_11_00;
                12'h012: data = 8'b11_00_11_00; 12'h013: data = 8'b11_00_11_00;
                12'h014: data = 8'b11_00_11_00; 12'h015: data = 8'b11_00_11_00;
                12'h016: data = 8'b11_00_11_00; 12'h017: data = 8'b11_00_11_00;
                12'h018: data = 8'b11_00_11_00; 12'h019: data = 8'b11_00_11_00;
                12'h01a: data = 8'b11_00_11_00; 12'h01b: data = 8'b11_00_11_00;
                12'h01c: data = 8'b11_00_11_00; 12'h01d: data = 8'b11_00_11_00;
                12'h01e: data = 8'b11_00_11_00; 12'h01f: data = 8'b11_00_11_00;
                default: data = 8'b0;
            endcase
        end else if ( in_pmf ) begin
            case ( pmfa )
                12'h000: data = 8'b11_11_11_11; 12'h001: data = 8'b11_11_11_11;
                12'h002: data = 8'b11_10_10_10; 12'h003: data = 8'b10_10_10_11;
                12'h004: data = 8'b11_10_10_10; 12'h005: data = 8'b10_10_10_11;
                12'h006: data = 8'b11_10_10_10; 12'h007: data = 8'b10_10_10_11;
                12'h008: data = 8'b11_10_10_10; 12'h009: data = 8'b10_10_10_11;
                12'h00a: data = 8'b11_10_10_10; 12'h00b: data = 8'b10_10_10_11;
                12'h00c: data = 8'b11_10_10_10; 12'h00d: data = 8'b10_10_10_11;
                12'h00e: data = 8'b11_11_11_11; 12'h00f: data = 8'b11_11_11_11;
                default: data = 8'b0;
            endcase
        end else if ( in_obm ) begin
            case ( obma )
                12'h000: data = 8'd129;
                12'h001: data = 8'd110;
                12'h002: data = 8'bx_0_0_00000;
                12'h003: data = 8'bxxxxx_110;
                default: data = 8'hff;
            endcase
        end else begin
            data = 8'b0;
        end
    end

endmodule


`endif
