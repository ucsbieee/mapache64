
/* object_scanline.sv */

module object_scanline (
    input   logic                   gpu_clk,
    input   logic                   rst,

    output  logic                   ready_o,

    input   logic                   clear_start_i,
    input   logic [7:0]             new_y_i,

    input   logic                   load_start_i,
    input   mapache64::obm_object_t load_object_i,
    output  logic [2:0]             load_intx_o, load_inty_o,
    input   logic [1:0]             load_lightness_i,

    input   logic [7:0]             display_x_i, display_y_i,
    output  mapache64::pixel_t      pixel_o
);

    logic [7:0] obs_y_d, obs_y_q;

    // ======== Internal VRAM ======== \\

    // Object Scanline Memory
    logic [4:0] OBSM[256];
    // 1 1-word read port

    logic               obsm_wen;
    logic [7:0]         obsm_waddr;
    mapache64::pixel_t  obsm_wdata;



    // ======== Load Internal VRAM ======== \\

    typedef enum logic [1:0] {
        WAIT,
        CLEAR,
        OBJECT_LOAD
    } state_t;
    state_t state_d, state_q;

    logic [7:0] clear_counter_d, clear_counter_q;
    logic [2:0] intx_counter_d, intx_counter_q;

    assign load_intx_o = intx_counter_q;
    assign load_inty_o = 3'(obs_y_q - load_object_i.y);

    always_comb begin
        obs_y_d = obs_y_q;
        state_d = state_q;
        clear_counter_d = '0;
        intx_counter_d = '0;

        obsm_wen = 0;
        obsm_waddr = '0;
        obsm_wdata = '0;
        ready_o = 0;

        case (state_q)
            WAIT: begin
                ready_o = 1;
                if (clear_start_i) begin
                    obs_y_d = new_y_i;
                    state_d = CLEAR;
                    clear_counter_d = '0;
                end else if (load_start_i) begin
                    state_d = OBJECT_LOAD;
                    intx_counter_d = '0;
                end
            end
            CLEAR: begin
                obsm_wen = 1;
                obsm_waddr = 8'(clear_counter_q);
                obsm_wdata = '0;
                if (clear_counter_q != 8'hff) begin
                    clear_counter_d = clear_counter_q+1;
                end else begin
                    state_d = WAIT;
                end
            end
            OBJECT_LOAD: begin
                if (obs_y_q >= load_object_i.y && obs_y_q <= (load_object_i.y+7)) begin
                    obsm_wen = (load_lightness_i != 0); // check for transparency
                    obsm_waddr = load_object_i.x + 8'(intx_counter_q);
                    obsm_wdata = {load_lightness_i, load_object_i.color};
                    if (intx_counter_q < 7 && obsm_waddr < 255) begin
                        intx_counter_d = intx_counter_q+1;
                    end else begin
                        state_d = WAIT;
                        ready_o = 1;
                        if (clear_start_i) begin
                            obs_y_d = new_y_i;
                            state_d = CLEAR;
                        end else if (load_start_i) begin
                            state_d = OBJECT_LOAD;
                        end
                    end
                end else begin
                    state_d = WAIT;
                end
            end
            default: state_d = WAIT;
        endcase
    end

    always_ff @(posedge gpu_clk) begin
        if (rst) begin
            state_q <= WAIT;
        end else begin
            state_q <= state_d;
        end
    end
    always_ff @(posedge gpu_clk) begin
        obs_y_q <= obs_y_d;
        clear_counter_q <= clear_counter_d;
        intx_counter_q <= intx_counter_d;
    end
    always_ff @(posedge gpu_clk) begin
        if (obsm_wen) begin
            OBSM[8'(obsm_waddr)] <= obsm_wdata;
        end
    end



    // ======== Display ======== \\

    wire display_obse_valid = (obs_y_q == display_y_i) && (state_q != CLEAR);

    assign pixel_o = display_obse_valid ? OBSM[display_x_i] : '0;



    // ======== Debug ======== \\

    `ifdef SIM
    generate for ( genvar i = 0; i < 256; i++ ) begin : pixel
        mapache64::pixel_t pixel;
        assign pixel = OBSM[i];
    end endgenerate
    `endif

endmodule
