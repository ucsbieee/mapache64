
module controller_interface #(
    parameter NUM_CONTROLLERS = 2
) (
    input   logic                               clk,
    input   logic                               rst,
    input   logic                               start_fetch_i,  // synchronous, must be held for less than 10 clk cycles

    output  logic                               clk_en_o,
    output  logic                               latch_o,

    input   logic [NUM_CONTROLLERS-1:0]         serial_LIST_ni,

    output  logic [NUM_CONTROLLERS-1:0][7:0]    data_LIST_o
);

    typedef enum logic [1:0] {
        WAIT,
        LATCH,
        LATCH_DONE,
        READ
    } state_t;

    state_t                             state_d,            state_q;
    logic                               latch_d,            latch_q;
    logic [NUM_CONTROLLERS-1:0][7:0]    data_LIST_d,        data_LIST_q;
    logic [3:0]                         num_bits_left_d,    num_bits_left_q;
    logic                               latch_timer_d,      latch_timer_q;

    wire has_bits_left = (num_bits_left_q != '0);
    assign latch_o =  latch_q;
    assign data_LIST_o = data_LIST_q;
    assign clk_en_o = (has_bits_left || latch_o);

    // state machine, latch timing
    always_comb begin
        num_bits_left_d = num_bits_left_q;
        latch_d = latch_q;
        state_d = state_q;
        latch_timer_d = latch_timer_q;
        case ( state_q )
            WAIT: begin
                if ( start_fetch_i ) begin
                    latch_d = 1;
                    state_d = LATCH;
                    latch_timer_d = 1;
                end
            end
            LATCH: begin
                if ( latch_timer_q == 0 ) begin
                    state_d = LATCH_DONE;
                    latch_d = 0;
                end else begin
                    latch_timer_d = latch_timer_q - 1;
                end
            end
            LATCH_DONE: begin
                num_bits_left_d = 4'd8;
                state_d = READ;
            end
            READ: begin
                if ( has_bits_left ) begin
                    num_bits_left_d = num_bits_left_q - 1;
                end else begin
                    state_d = WAIT;
                end
            end
        endcase
    end

    always_ff @(negedge clk) begin
        if ( rst ) begin
            num_bits_left_q <= 4'b0;
            latch_q <= 1'b0;
            state_q <= WAIT;
            latch_timer_q <= 0;
        end else begin
            num_bits_left_q <= num_bits_left_d;
            latch_q <= latch_d;
            state_q <= state_d;
            latch_timer_q <= latch_timer_d;
        end
    end

    // controller-specific updates
    generate for ( genvar controller_GEN = 1; controller_GEN <= NUM_CONTROLLERS; controller_GEN = controller_GEN+1 ) begin : controller
    logic [7:0] shift_register_d, shift_register_q;
    always_comb begin
        data_LIST_d[controller_GEN-1] = data_LIST_q[controller_GEN-1];
        shift_register_d = shift_register_q;
        if ( state_q == WAIT ) begin
            data_LIST_d[controller_GEN-1] = shift_register_q;
        end else if ( has_bits_left ) begin
            shift_register_d = {shift_register_q[6:0], ~serial_LIST_ni[controller_GEN-1]};
        end
    end
    always_ff @(posedge clk) begin
        if ( rst ) begin
            shift_register_q <= 8'b0;
            data_LIST_q[controller_GEN-1] <= '0;
        end else begin
            shift_register_q <= shift_register_d;
            data_LIST_q[controller_GEN-1] <= data_LIST_d[controller_GEN-1];
        end
    end
    `ifdef SIM
    logic controller_serial_n; assign controller_serial_n = serial_LIST_ni[controller_GEN-1];
    logic [7:0] controller_data; assign controller_data = data_LIST_q[controller_GEN-1];
    `endif
    end endgenerate

endmodule
