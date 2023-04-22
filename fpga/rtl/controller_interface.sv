
`ifndef __UCSBIEEE__CONTROLLER_INTERFACE__RTL__CONTROLLER_INTERFACE_V
`define __UCSBIEEE__CONTROLLER_INTERFACE__RTL__CONTROLLER_INTERFACE_V


module controller_interface_m #(
    parameter NUM_CONTROLLERS = 2
) (
    input                                   clk_in,
    input                                   rst,
    input                                   start_fetch,    // synchronous, must be held for less than 10 clk cycles

    output wire                             clk_out_enable,
    output reg                              latch,

    input             [NUM_CONTROLLERS-1:0] data_B_LIST,

    output reg    [(8*NUM_CONTROLLERS)-1:0] buttons_out_LIST
);

    `define CONTROLLER_DATA_B(CONTROLLER)       data_B_LIST[(CONTROLLER)]
    `define CONTROLLER_BUTTONS_OUT(CONTROLLER)  buttons_out_LIST[(8*(CONTROLLER))+:8]

    reg [1:0] state;
    `define STATE_WAIT          2'h0
    `define STATE_LATCH         2'h1
    `define STATE_LATCH_DONE    2'h2
    `define STATE_READ          2'h3
    initial state = `STATE_WAIT;


    reg [3:0] num_bits_left;
    initial num_bits_left = 4'b0;
    wire has_bits_left = (num_bits_left != 4'b0);

    assign clk_out_enable = (has_bits_left || latch);

    reg latch_timer;
    initial latch_timer = 0;

    // state machine, latch timing
    always_ff @ ( negedge clk_in ) begin
        if ( rst ) begin
            latch <= 1'b0;
            state <= `STATE_WAIT;
            num_bits_left <= 4'b0;
            latch_timer <= 0;
        end else begin
            case ( state )
                `STATE_WAIT: begin
                    if ( start_fetch ) begin
                        latch <= 1'b1;
                        state <= `STATE_LATCH;
                        latch_timer <= ~0;
                    end
                end
                `STATE_LATCH: begin
                    if ( latch_timer == 0 ) begin
                        state <= `STATE_LATCH_DONE;
                        latch <= 1'b0;
                    end else begin
                        latch_timer <= latch_timer - 1;
                    end
                end
                `STATE_LATCH_DONE: begin
                    num_bits_left <= 4'd8;
                    state <= `STATE_READ;
                end
                `STATE_READ: begin
                    if ( has_bits_left ) begin
                        num_bits_left <= num_bits_left-4'b1;
                    end else begin
                        state <= `STATE_WAIT;
                    end
                end
            endcase
        end
    end


    // controller-specific updates
    generate for ( genvar controller_GEN = 1; controller_GEN <= NUM_CONTROLLERS; controller_GEN = controller_GEN+1 ) begin : controller
    reg [7:0] register;
    always_ff @ ( posedge clk_in ) begin
        if ( rst ) begin
            register <= 8'b0;
        end
        else if ( state == `STATE_WAIT ) begin
            `CONTROLLER_BUTTONS_OUT(controller_GEN-1) <= register;
        end
        else if ( has_bits_left ) begin
            register <= {register[6:0], ~`CONTROLLER_DATA_B(controller_GEN-1)};
        end
    end
    `ifdef SIM
    wire        controller_data_B       = `CONTROLLER_DATA_B(controller_GEN-1);
    wire  [7:0] controller_buttons_out  = `CONTROLLER_BUTTONS_OUT(controller_GEN-1);
    `endif
    end endgenerate


endmodule

`endif
