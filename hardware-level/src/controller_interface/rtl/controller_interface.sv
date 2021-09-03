
`ifndef __UCSBIEEE__CONTROLLER_INTERFACE__RTL__CONTROLLER_INTERFACE_V
`define __UCSBIEEE__CONTROLLER_INTERFACE__RTL__CONTROLLER_INTERFACE_V


module controller_interface_m #(
    parameter NUM_CONTROLLERS = 2
) (
    input                                   clk,
    input                                   start_fetch,    // synchronous, must be held for less than 10 clk cycles

    output wire                             controller_clk,
    output reg                              controller_latch,

    input             [NUM_CONTROLLERS-1:0] controller_data_B_LIST,

    output reg    [(8*NUM_CONTROLLERS)-1:0] controller_data_out_LIST
);

    `define CONTROLLER_DATA_B(CONTROLLER)   controller_data_B_LIST[(CONTROLLER)]
    `define CONTROLLER_DATA_OUT(CONTROLLER) controller_data_out_LIST[(8*(CONTROLLER))+:8]

    reg [1:0] state;
    `define STATE_WAIT          2'h0
    `define STATE_LATCH         2'h1
    `define STATE_LATCH_DONE    2'h2
    `define STATE_READ          2'h3
    initial state = `STATE_WAIT;

    reg [3:0] num_bits_left;
    initial num_bits_left = 4'b0;
    wire has_bits_left = (num_bits_left != 4'b0);

    wire controller_clk_enable = (4'h0 < num_bits_left && num_bits_left < 4'h8) || controller_latch;
    assign controller_clk = clk && controller_clk_enable;

    always_ff @ ( posedge clk ) begin
        if ( state == `STATE_WAIT ) begin
            if ( start_fetch ) begin
                controller_latch <= 1'b1;
                state <= `STATE_LATCH;
            end
        end
        else if ( state == `STATE_LATCH ) begin
            controller_latch <= 1'b0;
            state <= `STATE_LATCH_DONE;
        end
        else if ( state == `STATE_LATCH_DONE ) begin
            num_bits_left <= 4'h8;
            state <= `STATE_READ;
        end
        else if ( state == `STATE_READ ) begin
            if ( has_bits_left ) begin
                num_bits_left <= num_bits_left-4'b1;
            end else begin
                state <= `STATE_WAIT;
            end
        end
    end

    generate for ( genvar controller_GEN = 1; controller_GEN <= NUM_CONTROLLERS; controller_GEN = controller_GEN+1 ) begin : controller
    reg [7:0] register;
    always_ff @ ( posedge clk ) begin
        if ( state == `STATE_WAIT ) begin
            `CONTROLLER_DATA_OUT(controller_GEN-1) <= register;
        end
        else if ( has_bits_left ) begin
            register <= {register[6:0], ~`CONTROLLER_DATA_B(controller_GEN-1)};
        end
    end
    `ifdef SIM
    wire        controller_data_B   = `CONTROLLER_DATA_B(controller_GEN-1);
    wire  [7:0] controller_data_out = `CONTROLLER_DATA_OUT(controller_GEN-1);
    `endif
    end endgenerate

endmodule

`endif
