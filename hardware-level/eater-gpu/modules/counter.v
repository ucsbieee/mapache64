
/* counter.v */

module counter_m
# (
    parameter NUM_BITS = 8
) (
    input                       clk, rst,
    output reg   [NUM_BITS-1:0] count
);

    // sync reset
    always @ ( posedge clk ) begin
        if ( rst )
            count <= 0;
        else
            count <= count + 1;
    end

    // // async reset
    // always @ ( posedge rst ) count <= 0;
    // always @ ( posedge clk ) count += ~rst;

endmodule
