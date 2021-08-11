
module clk_100_TO_clk_1_m (
    output wire clk_1,
    input clk_100
);

    reg [6:0] counter;

    assign clk_1 = ( counter <= 7'd50 );

    initial counter = 7'd1;


    always @ ( posedge clk_100 ) begin
        if ( counter < 100 )
            counter <= counter + 1;
        else
            counter <= 7'd1;
    end

endmodule
