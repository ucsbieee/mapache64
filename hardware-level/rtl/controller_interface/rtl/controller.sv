

`ifndef __UCSBIEEE__CONTROLLER_INTERFACE__SIM__CONTROLLER_SV
`define __UCSBIEEE__CONTROLLER_INTERFACE__SIM__CONTROLLER_SV


module controller_m #(
    parameter SYNC_LATCH = 1'b0
) (
    input [7:0] buttons_B,
    input       clk,
    input       latch,
    output wire data_B
);

    reg [7:0] register; // = {a,b,select,start,up,down,left,right}

    generate if ( SYNC_LATCH ) begin

        always_ff @ ( posedge clk ) begin
            if ( latch )
                register <= buttons_B;
            if ( !latch )
                register <= {register[6:0], 1'b0};
        end

        assign data_B = register[7];

    end else begin

        always_latch begin
            if ( latch )
                register = buttons_B;
        end

        always_ff @ ( posedge clk ) begin
            if ( !latch )
                register = {register[6:0], 1'b0};
        end

        assign data_B = register[7];

    end endgenerate

endmodule


`endif
