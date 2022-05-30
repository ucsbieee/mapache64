
`ifndef __UCSBIEEE__POWER_ON_RST_V
`define __UCSBIEEE__POWER_ON_RST_V


module power_on_rst #(
    parameter COUNT = 100
) (
    input       clk,
    output wire rst
);

reg [$clog2(COUNT):0] counter = COUNT;

always @ (posedge clk)
    if (counter != 0)
        counter <= counter-1;

assign rst = (counter != 0);

endmodule

`endif
