
module firmware (
    input   mapache64::firmware_address_t   address_i,
    output  mapache64::data_t               data_o,
    input   logic                           SELECT_firmware_i,
    input   logic                           SELECT_vectors_i
);

    mapache64::data_t firmware_mem [mapache64::FirmwareSize-1:0];
    mapache64::data_t vector_mem [5:0];

    wire [2:0] vector_address = ( 3'(address_i) - 3'h2 );

    assign data_o =
        SELECT_firmware_i   ? firmware_mem[address_i]       :
        SELECT_vectors_i    ? vector_mem[vector_address]    :
        'x;

    initial $readmemh( "firmware.mem", firmware_mem, 0, mapache64::FirmwareSize-1 );
    initial $readmemh( "vectors.mem", vector_mem, 0, 5 );

    `ifdef SIM
    generate for ( genvar i_GEN = 0; i_GEN < mapache64::FirmwareSize; i_GEN = i_GEN+1 ) begin : rom_byte
        mapache64::data_t data; assign data = firmware_mem[ i_GEN ];
    end endgenerate
    mapache64::address_t nmi_address; assign nmi_address = {vector_mem[1],vector_mem[0]};
    mapache64::address_t rst_address; assign rst_address = {vector_mem[3],vector_mem[2]};
    mapache64::address_t irq_address; assign irq_address = {vector_mem[5],vector_mem[4]};
    `endif

endmodule
