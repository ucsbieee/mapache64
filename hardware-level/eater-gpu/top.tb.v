
/* top.tb.v */

`include "modules/top.v"

`timescale 1us/1ns


module top_tb ();

// 10 MHz clock
reg clk = 1;
always #0.05 clk = ~clk;

reg rst;
wire [1:0] r,g,b;

top_m top (
    .clk(clk),
    .rst(rst),
    .r(r), .g(g), .b(b)
);


initial begin
$dumpfile( "dump.vcd" );
$dumpvars( 0, top );
//\\ =========================== \\//
rst = 1;
#1
rst = 0;

#16582

//\\ =========================== \\//
$finish;
end

endmodule
