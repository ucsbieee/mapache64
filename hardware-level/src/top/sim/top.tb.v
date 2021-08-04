
`ifndef __UCSBIEEE__TOP__SIM__TOP_TB_V
`define __UCSBIEEE__TOP__SIM__TOP_TB_V


`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
`endif


module top_tb_m ();



/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
//\\ =========================== \\//



//\\ =========================== \\//
$finish ;
end

endmodule


`endif
