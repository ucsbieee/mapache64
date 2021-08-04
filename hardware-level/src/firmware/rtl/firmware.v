
`ifndef __UCSBIEEE__FIRMWARE__RTL__FIRMWARE_V
`define __UCSBIEEE__FIRMWARE__RTL__FIRMWARE_V


`define __FIRMWARE_SIZE 14'h3000

module firmware_m (
    input        [$clog2(`__FIRMWARE_SIZE)-1:0] address,
    output wire                           [7:0] data
);

    reg [7:0] mem [`__FIRMWARE_SIZE-1:0];

    assign data = mem[address];

    initial $readmemh( "firmware.mem", mem, 0, `__FIRMWARE_SIZE-1 );

    `ifdef SIM
    generate for ( genvar i_GEN = 0; i_GEN < `__FIRMWARE_SIZE; i_GEN = i_GEN+1 ) begin : rom_byte
        wire [7:0] data = mem[ i_GEN ];
    end endgenerate
    `endif

endmodule


`endif
