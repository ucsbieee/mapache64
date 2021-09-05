
// https://www.desmos.com/calculator/gkyjx8cpny
module clk_100_TO_clk_PARAM_m #(
    parameter FREQ_MHz = 1.0
) (
    output wire clk_out,
    input clk_100
);

    localparam COUNTER_RESET = $rtoi( 100.0 / FREQ_MHz );
    localparam ACTUAL_FREQ_MHz = 100.0 / COUNTER_RESET;

    reg [$clog2(COUNTER_RESET):0] counter;

    assign clk_out = ( counter <= $rtoi( COUNTER_RESET / 2.0 ) );

    initial counter = 1;

    always @ ( posedge clk_100 ) begin
        if ( counter < COUNTER_RESET )
            counter <= counter + 1;
        else
            counter <= 1;
    end

endmodule
