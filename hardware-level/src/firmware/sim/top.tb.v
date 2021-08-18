
`ifndef __UCSBIEEE__FIRMWARE__SIM__TOP_TB_V
`define __UCSBIEEE__FIRMWARE__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `undef LINTER
    `include "../rtl/firmware.v"
`endif


module top_tb_m ();


reg [13:0] address;
wire [7:0] data;
wire SELECT_firmware = 1;

firmware_m fw (
    address, data, SELECT_firmware
);

/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
//\\ =========================== \\//

for ( address = 0; address < 64; address = address+1 ) #1;

//\\ =========================== \\//
$finish ;
end

endmodule


`endif
