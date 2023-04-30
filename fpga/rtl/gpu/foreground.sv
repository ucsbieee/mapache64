
/* foreground.v */

module foreground #(
    parameter NUM_OBJECTS = 64
) (
    input   logic                       gpu_clk,
    input   logic                       cpu_clk,
    input   logic                       rst,

    input   logic                       prefetch_start_i,
    input   logic [7:0]                 prefetch_y_i,

    // video timing input
    input   logic [7:0]                 display_x_i, display_y_i,

    // video output
    output  logic [1:0]                 r_o, g_o, b_o,
    output  logic                       valid_o,

    // VRAM interface
    input   mapache64::data_t           vram_wdata_i,
    output  mapache64::data_t           vram_rdata_o,
    input   mapache64::vram_address_t   vram_address_i,
    input   logic                       vram_wen_i,
    input   logic                       SELECT_pmf_i, SELECT_obm_i
);

    // ======== VRAM ======== \\

    // Pattern Memory Foreground (https://mapache64.ucsbieee.org/guides/gpu/#Pattern-Memory)
    mapache64::data_t PMF[512];

    function automatic logic [15:0] pmf_line(logic [4:0] pmfa, logic [2:0] y);
        logic [7:0] left, right;
        left = PMF[ {pmfa, y, 1'b0} ];
        right = PMF[ {pmfa, y, 1'b1} ];
        return {left, right};
    endfunction

    // Object Memory (https://mapache64.ucsbieee.org/guides/gpu/#Object-Memory)
    mapache64::data_t OBM[256];

    function automatic mapache64::obm_object_t obm_object(logic [5:0] obma);
        logic [7:0] x, y, conf, color;
        x = OBM[ {obma, 2'd0} ];
        y = OBM[ {obma, 2'd1} ];
        conf = OBM[ {obma, 2'd2} ];
        color = OBM[ {obma, 2'd3} ];
        return {x, y, conf, color};
    endfunction



    // ======== VRAM Interface ======== \\

    wire [8:0] pmf_address = 9'(vram_address_i - 12'h000);
    wire [7:0] obm_address = 8'(vram_address_i - 12'h800);

    // read from vram
    assign vram_rdata_o =
        SELECT_pmf_i  ? PMF[ pmf_address ]    :
        SELECT_obm_i  ? OBM[ obm_address ]    :
        'x;

    // write to vram
    always_ff @(negedge cpu_clk) begin : write_to_vram
        if ( vram_wen_i ) begin
            if ( SELECT_pmf_i )
                PMF[ pmf_address ] <= vram_wdata_i;
            if ( SELECT_obm_i )
                OBM[ obm_address ] <= vram_wdata_i;
        end
    end



    // ======== Prefetch ======== \\

    typedef enum logic [1:0] {
        DONE,
        CLEAR,
        LOAD_OBJECTS
    } state_t;

    state_t state_d, state_q;

    localparam NUM_OBS = 2;

    logic [$clog2(NUM_OBS)-1:0] scanline_to_replace_d, scanline_to_replace_q;
    logic [$clog2(NUM_OBJECTS)-1:0] object_load_counter_d, object_load_counter_q;

    mapache64::pixel_t obs_pixels[NUM_OBS];
    logic [NUM_OBS-1:0] obs_ready;
    logic [NUM_OBS-1:0] obs_clear_start;
    logic [NUM_OBS-1:0] obs_load_start;

    mapache64::obm_object_t obs_load_object;
    assign obs_load_object = obm_object(object_load_counter_q);

    always_comb begin

        scanline_to_replace_d = scanline_to_replace_q;
        state_d = state_q;
        object_load_counter_d = object_load_counter_q;

        obs_clear_start = '0;
        obs_load_start = '0;

        case (state_q)
            DONE: begin
                if (prefetch_start_i) begin
                    // increment scanline and y
                    scanline_to_replace_d = (scanline_to_replace_q==(NUM_OBS-1)) ? '0 : scanline_to_replace_q+1;
                    // begin clear
                    state_d = CLEAR;
                    obs_clear_start[scanline_to_replace_d] = 1;
                end
            end
            CLEAR: begin
                if (obs_ready[scanline_to_replace_q]) begin
                    state_d = LOAD_OBJECTS;
                    obs_load_start[scanline_to_replace_q] = 1;
                    object_load_counter_d = NUM_OBJECTS-1;
                end
            end
            LOAD_OBJECTS: begin
                if (obs_ready[scanline_to_replace_q]) begin
                    if (object_load_counter_q==0) begin
                        state_d = DONE;
                    end else begin
                        obs_load_start[scanline_to_replace_q] = 1;
                        object_load_counter_d = object_load_counter_q-1;
                    end
                end
            end
            default: state_d = DONE;
        endcase
    end

    always_ff @(posedge gpu_clk) begin
        if (rst) begin
            scanline_to_replace_q <= '0;
            object_load_counter_q <= '0;
            state_q <= DONE;
        end else begin
            scanline_to_replace_q <= scanline_to_replace_d;
            object_load_counter_q <= object_load_counter_d;
            state_q <= state_d;
        end
    end

    // Load lightness from obs_load_object, intx, inty
    logic [2:0] obs_load_intx[NUM_OBS];
    logic [2:0] obs_load_inty[NUM_OBS];
    logic [1:0] obs_load_lightness;

    // Get (flipped) addresses into pattern
    wire [2:0] obs_pattern_inty = obs_load_object.vflip ? (3'h7-obs_load_inty[scanline_to_replace_q]) : obs_load_inty[scanline_to_replace_q];
    wire [2:0] obs_pattern_intx = obs_load_object.hflip ? (3'h7-obs_load_intx[scanline_to_replace_q]) : obs_load_intx[scanline_to_replace_q];

    // Read from PMF
    wire [15:0] obs_pmf_line = pmf_line( obs_load_object.pmfa, obs_pattern_inty );

    // Find lightness
    assign obs_load_lightness = obs_pmf_line[ {(3'h7-obs_pattern_intx),1'b0} +: 2 ];

    generate for (genvar scanline_GEN = 0; scanline_GEN < NUM_OBS; scanline_GEN++) begin : scanline
        object_scanline obs (
            .gpu_clk(gpu_clk),
            .ready_o(obs_ready[scanline_GEN]),
            .clear_start_i(obs_clear_start[scanline_GEN]),
            .new_y_i(prefetch_y_i),
            .load_start_i(obs_load_start[scanline_GEN]),
            .load_object_i(obs_load_object),
            .load_intx_o(obs_load_intx[scanline_GEN]),
            .load_inty_o(obs_load_inty[scanline_GEN]),
            .load_lightness_i(obs_load_lightness),
            .display_x_i(display_x_i),
            .display_y_i(display_y_i),
            .pixel_o(obs_pixels[scanline_GEN])
        );
    end endgenerate



    // ======== Display ======== \\

    always_comb begin
        valid_o = 0;
        r_o = 'x;
        g_o = 'x;
        b_o = 'x;
        for (integer i = 0; i < NUM_OBS; i++) begin : display
            if (obs_pixels[i][4:3] != 0) begin
                valid_o = 1;
                r_o = obs_pixels[i][4:3] & {2{obs_pixels[i][2]}};
                g_o = obs_pixels[i][4:3] & {2{obs_pixels[i][1]}};
                b_o = obs_pixels[i][4:3] & {2{obs_pixels[i][0]}};
            end
        end
    end



    // ======== Debug ======== \\

    // dump object values
    `ifdef SIM
    generate for ( genvar i = 0; i < NUM_OBJECTS; i++ ) begin : object
        initial OBM[{6'(i),2'b0}+1] = 8'hff;
        mapache64::obm_object_t object;
        assign object = obm_object(6'(i));
    end endgenerate
    always @(negedge gpu_clk) begin
        if (prefetch_start_i && state_q!=DONE)
            $warning("Failed to prefetch of y=%d because prefetch unit is busy", prefetch_y_i);
    end
    `endif

endmodule
