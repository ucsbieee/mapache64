
module controller_interface #(
    parameter NUM_CONTROLLERS = 2
) (
    input   logic                           clk,
    input   logic                           rst,
    input   logic                           start_fetch_i,  // synchronous, must be held for less than 10 clk cycles

    output  logic                           clk_en_o,
    output  logic                           latch_o,

    input   logic [NUM_CONTROLLERS-1:0]     serial_LIST_ni,

    output  logic [(8*NUM_CONTROLLERS)-1:0] data_LIST_o
);

    `define CONTROLLER_SERIAL_N(CONTROLLER) serial_LIST_ni[(CONTROLLER)]
    `define CONTROLLER_DATA(CONTROLLER)     data_LIST_o[(8*(CONTROLLER))+:8]

    typedef enum logic [1:0] {
        WAIT,
        LATCH,
        LATCH_DONE,
        READ
    } state_t;
    state_t state;


    logic [3:0] num_bits_left;
    wire has_bits_left = (num_bits_left != '0);

    assign clk_en_o = (has_bits_left || latch_o);

    logic latch_timer;

    // state machine, latch timing
    always_ff @(negedge clk) begin
        if ( rst ) begin
            latch_o <= 1'b0;
            state <= WAIT;
            num_bits_left <= 4'b0;
            latch_timer <= 0;
        end else begin
            case ( state )
                WAIT: begin
                    if ( start_fetch_i ) begin
                        latch_o <= 1'b1;
                        state <= LATCH;
                        latch_timer <= 1;
                    end
                end
                LATCH: begin
                    if ( latch_timer == 0 ) begin
                        state <= LATCH_DONE;
                        latch_o <= 0;
                    end else begin
                        latch_timer <= latch_timer - 1;
                    end
                end
                LATCH_DONE: begin
                    num_bits_left <= 4'd8;
                    state <= READ;
                end
                READ: begin
                    if ( has_bits_left ) begin
                        num_bits_left <= num_bits_left-4'b1;
                    end else begin
                        state <= WAIT;
                    end
                end
            endcase
        end
    end


    // controller-specific updates
    generate for ( genvar controller_GEN = 1; controller_GEN <= NUM_CONTROLLERS; controller_GEN = controller_GEN+1 ) begin : controller
    mapache64::data_t shift_register;
    always_ff @(posedge clk) begin
        if ( rst ) begin
            shift_register <= 8'b0;
        end
        else if ( state == WAIT ) begin
            `CONTROLLER_DATA(controller_GEN-1) <= shift_register;
        end
        else if ( has_bits_left ) begin
            shift_register <= {shift_register[6:0], ~`CONTROLLER_SERIAL_N(controller_GEN-1)};
        end
    end
    `ifdef SIM
    logic controller_serial_n; assign controller_serial_n = `CONTROLLER_SERIAL_N(controller_GEN-1);
    mapache64::data_t controller_data; assign controller_data = `CONTROLLER_DATA(controller_GEN-1);
    `endif
    end endgenerate

    `undef CONTROLLER_SERIAL_N
    `undef CONTROLLER_DATA

endmodule
