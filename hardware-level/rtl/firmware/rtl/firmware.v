
`ifndef __UCSBIEEE__FIRMWARE__RTL__FIRMWARE_V
`define __UCSBIEEE__FIRMWARE__RTL__FIRMWARE_V


`define __FIRMWARE_SIZE 14'h2000

module firmware_m (
    input        [$clog2(`__FIRMWARE_SIZE)-1:0] address,
    output wire                           [7:0] data_out,
    input                                       SELECT_firmware,
    input                                       SELECT_vectors
);

    reg [7:0] firmware_mem [`__FIRMWARE_SIZE-1:0];
    reg [7:0] vector_mem [5:0];

    wire [2:0] vector_address = ( address[2:0] - 3'h2 );

    assign data_out =
        SELECT_firmware ? firmware_mem[address]         :
        SELECT_vectors  ? vector_mem[vector_address]    :
        {8{1'bz}};

    initial $readmemh( "firmware.mem", firmware_mem, 0, `__FIRMWARE_SIZE-1 );
    initial $readmemh( "vectors.mem", vector_mem, 0, 5 );

    `ifdef SIM
    generate for ( genvar i_GEN = 0; i_GEN < `__FIRMWARE_SIZE; i_GEN = i_GEN+1 ) begin : rom_byte
        wire [7:0] data_out = firmware_mem[ i_GEN ];
    end endgenerate
    wire [15:0] nmi_address = {vector_mem[1],vector_mem[0]};
    wire [15:0] rst_address = {vector_mem[3],vector_mem[2]};
    wire [15:0] irq_address = {vector_mem[5],vector_mem[4]};
    `endif

endmodule

`undef __FIRMWARE_SIZE
`endif
