
`ifndef __UCSBIEEE__FIRMWARE__SIM__TOP_TB_V
`define __UCSBIEEE__FIRMWARE__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "hardware-level/rtl/firmware/rtl/firmware.v"
`endif


module top_tb_m ();


reg [15:0] address;
wire [7:0] data;
reg SELECT_firmware, SELECT_vectors;

firmware_m fw (
    address[13:0], data, SELECT_firmware, SELECT_vectors
);

/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
//\\ =========================== \\//

SELECT_firmware = 1;
SELECT_vectors = 0;
for ( address = 0; address < 64; address = address+1 ) #1;

SELECT_firmware = 0;
SELECT_vectors = 1;
for ( address = 16'hfffa; address != 16'h0; address = address+1 ) #1;

//\\ =========================== \\//
$finish ;
end

endmodule


`endif
