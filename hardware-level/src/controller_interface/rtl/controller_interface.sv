
`ifndef __UCSBIEEE__CONTROLLER_INTERFACE__RTL__CONTROLLER_INTERFACE_V
`define __UCSBIEEE__CONTROLLER_INTERFACE__RTL__CONTROLLER_INTERFACE_V


module controller_interface_m (
    input               clk,
    input               start_fetch,    // synchronous, must be held for less than 10 clk cycles

    output wire         controller_clk,
    output reg          controller_latch,

    input               controller_1_data_B,
    input               controller_2_data_B,

    output reg    [7:0] controller_1_data_out,
    output reg    [7:0] controller_2_data_out
);

    reg [3:0] num_bits_left;
    initial num_bits_left = 4'd0;
    wire has_bits_left = (num_bits_left != 4'd0);

    wire controller_clk_enable = num_bits_left[2:0] != 0;
    assign controller_clk = clk && controller_clk_enable;

    reg [7:0] register_1, register_2;

    always_ff @ ( posedge clk ) begin
        if ( has_bits_left ) begin
            controller_latch <= 0;
            register_1 <= {register_1[6:0], ~controller_1_data_B};
            register_2 <= {register_2[6:0], ~controller_2_data_B};
            num_bits_left <= num_bits_left-4'd1;
        end else if ( start_fetch ) begin
            num_bits_left <= 4'd8;
            controller_latch <= 1;
        end else begin
            controller_1_data_out <= register_1;
            controller_2_data_out <= register_2;
        end
    end

endmodule

`endif
