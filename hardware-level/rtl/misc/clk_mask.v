
// https://www.desmos.com/calculator/gkyjx8cpny
module clk_mask_m #(
    parameter PERIOD = 1
) (
    input       clk_in, rst,
    output wire clk_mask
);

    reg [$clog2(PERIOD):0] counter;

    assign clk_mask = ( counter == 0 );

    initial counter = 0;

    always @ ( negedge clk_in ) begin
        if ( rst ) begin
            counter <= 1;
        end
        else if ( counter < PERIOD-1 )
            counter <= counter + 1;
        else
            counter <= 0;
    end

endmodule
