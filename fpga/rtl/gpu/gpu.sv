
module gpu #(
    parameter FOREGROUND_NUM_OBJECTS = 64
) (
    input   logic                       gpu_clk,
    input   logic                       cpu_clk,
    input   logic                       rst,

    // video output
    output logic [1:0]                  r_o, g_o, b_o,
    output logic                        hsync_o, vsync_o,
    output logic                        controller_start_fetch_o,

    // VRAM interface
    input   mapache64::data_t           data_i,
    output  mapache64::data_t           data_o,
    input   mapache64::vram_address_t   vram_address_i,
    input   logic                       wen_i,
    input   logic                       SELECT_vram_i,
    input   logic                       SELECT_pmf_i,
    input   logic                       SELECT_pmb_i,
    input   logic                       SELECT_ntbl_i,
    input   logic                       SELECT_obm_i,
    input   logic                       SELECT_txbl_i,

    input   logic                       SELECT_in_vblank_i,
    input   logic                       SELECT_clr_vblank_irq_i,
    output  logic                       vblank_irq_o
);

    // for vblank irw
    wire writable;

    // data out
    mapache64::data_t text_data, foreground_data, background_data;
    assign data_o =
        (SELECT_in_vblank_i)            ? {7'b0,writable}   :
        (SELECT_txbl_i)                 ? text_data         :
        (SELECT_pmf_i||SELECT_obm_i)    ? foreground_data   :
        (SELECT_pmb_i||SELECT_ntbl_i)   ? background_data   :
        'x;

    // for vblank irw
    reg writable_prev;
    initial writable_prev = 0;

    always_ff @(posedge gpu_clk) begin
        if ( wen_i && SELECT_clr_vblank_irq_i )
            vblank_irq_o <= 0;
        else if ( rst || (writable_prev != writable) )
            vblank_irq_o <= 1;
        writable_prev <= writable;
    end


    wire [8:0] next_x, next_y;
    wire [9:0] hcounter, vcounter;
    wire visible, foreground_valid;

    logic prefetch_start;
    logic [7:0] prefetch_y;
    always_comb begin
        prefetch_start = 0;
        prefetch_y = 'x;
        if (hcounter==0) begin
            if (vcounter==523) begin
                prefetch_start = 1;
                prefetch_y = 0;
            end else if (vcounter < 10'd478 && vcounter[0]==0) begin
                prefetch_start = 1;
                prefetch_y = vcounter[8:1]+1;
            end
        end
    end

    wire text_color, text_valid;
    wire [1:0] foreground_r, foreground_g, foreground_b;
    wire [1:0] background_r, background_g, background_b;

    wire drawing = visible && (next_x < 256) && (next_y < 240);

   logic [1:0] r_d, r_q, g_d, g_q, b_d, b_q;
   assign r_o = r_q;
   assign g_o = g_q;
   assign b_o = b_q;

    assign {r_d, g_d, b_d} =
        !drawing            ? '0                                        :
        text_valid          ? {6{text_color}}                           :
        foreground_valid    ? {foreground_r,foreground_g,foreground_b}  :
        {background_r,background_g,background_b};

    always @(posedge gpu_clk) begin
        r_q <= r_d;
        g_q <= g_d;
        b_q <= b_d;
    end

    assign next_x = hcounter[8:0] - 9'd31;
    assign next_y = vcounter[9:1];

    video_timing video_timing (
        .clk_12_5875(gpu_clk),
        .rst(rst),

        .hsync_o(hsync_o),
        .vsync_o(vsync_o),

        .hcounter_o(hcounter),
        .vcounter_o(vcounter),
        .visible_o(visible),

        .writable_o(writable)
    );

    assign controller_start_fetch_o = ( hcounter < 10'h20 ) && ( vcounter == 10'b0 );

    wire vram_wen = wen_i; // should be anding with "writable", but oh well!

    text text (
        .cpu_clk(cpu_clk),

        .display_x_i(8'(next_x)),
        .display_y_i(8'(next_y)),

        .display_color_o(text_color),
        .display_valid_o(text_valid),

        .vram_wdata_i(data_i),
        .vram_rdata_o(text_data),
        .vram_address_i(vram_address_i),
        .vram_wen_i(vram_wen),
        .SELECT_txbl_i(SELECT_txbl_i)
    );

    foreground #(
        .NUM_OBJECTS(FOREGROUND_NUM_OBJECTS)
    ) foreground (
        .gpu_clk(gpu_clk),
        .cpu_clk(cpu_clk),
        .rst(rst),

        .prefetch_start_i(prefetch_start),
        .prefetch_y_i(prefetch_y),

        .display_x_i(8'(next_x)),
        .display_y_i(8'(next_y)),

        .r_o(foreground_r),
        .g_o(foreground_g),
        .b_o(foreground_b),
        .valid_o(foreground_valid),

        .vram_wdata_i(data_i),
        .vram_rdata_o(foreground_data),
        .vram_address_i(vram_address_i),
        .vram_wen_i(vram_wen),
        .SELECT_pmf_i(SELECT_pmf_i),
        .SELECT_obm_i(SELECT_obm_i)
    );

    background background (
        .cpu_clk(cpu_clk),

        .display_x_i(8'(next_x)),
        .display_y_i(8'(next_y)),

        .r_o(background_r),
        .g_o(background_g),
        .b_o(background_b),

        .vram_wdata_i(data_i),
        .vram_rdata_o(background_data),
        .vram_address_i(vram_address_i),
        .vram_wen_i(vram_wen),
        .SELECT_pmb_i(SELECT_pmb_i),
        .SELECT_ntbl_i(SELECT_ntbl_i)
    );

endmodule
