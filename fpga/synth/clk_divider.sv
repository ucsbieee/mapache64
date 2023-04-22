
// https://www.desmos.com/calculator/6ogzgfkshu
module clk_divider #(
    parameter IN_FREQ   = 1.0,
    parameter OUT_FREQ  = 1.0
) (
    input       clk_in, rst,
    output wire clk_out
);

    localparam COUNTER_RESET = $rtoi( 1.0 * IN_FREQ / OUT_FREQ );
    localparam ACTUAL_FREQ_MHz = IN_FREQ / COUNTER_RESET;

    generate
    if ( IN_FREQ == ACTUAL_FREQ_MHz ) begin

        assign clk_out = clk_in;

    end else begin

        reg [$clog2(COUNTER_RESET):0] counter;

        assign clk_out = ( counter < $rtoi( COUNTER_RESET / 2.0 ) );

        initial counter = 0;

        always_ff @(posedge clk_in) begin
            if ( rst  || counter == (COUNTER_RESET-1) )
                counter <= 0;
            else
                counter <= counter + 1;
        end

    end
    endgenerate


endmodule
