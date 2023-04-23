
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
        {8{1'bz}};

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


    wire [8:0] current_x, current_y;
    wire [8:0] next_x, next_y;
    wire [9:0] hcounter, vcounter;
    wire visible, foreground_valid;

    wire text_color, text_valid;
    wire [1:0] foreground_r, foreground_g, foreground_b;
    wire [1:0] background_r, background_g, background_b;

    wire drawing = visible && (current_x < 256) && (current_y < 240);

    assign {r_o,g_o,b_o} =
        !drawing            ? 6'b0                                      :
        text_valid          ? {6{text_color}}                           :
        foreground_valid    ? {foreground_r,foreground_g,foreground_b}  :
        {background_r,background_g,background_b};


    assign current_x = hcounter[8:0] - 9'd32;
    assign current_y = vcounter[9:1];
    assign next_x = (current_x == 511) ? (0) : (current_x+1);
    assign next_y = (current_y == 262) ? (0) : (current_y+1);

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

        .current_x_i(current_x[7:0]),
        .current_y_i(current_y[7:0]),

        .color_o(text_color),
        .valid_o(text_valid),

        .data_i(data_i),
        .data_o(text_data),
        .vram_address_i(vram_address_i),
        .wen_i(vram_wen),
        .SELECT_txbl_i(SELECT_txbl_i)
    );

    foreground #(
        .NUM_OBJECTS(FOREGROUND_NUM_OBJECTS),
        .LINE_REPEAT(2),
        .NUM_ROWS(523)
    ) foreground (
        .gpu_clk(gpu_clk),
        .cpu_clk(cpu_clk),
        .rst(rst),

        .current_x_i(current_x),
        .current_y_i(current_y),
        .next_x_i(next_x),
        .next_y_i(next_y),
        .hsync_i(hsync_o),

        .r_o(foreground_r),
        .g_o(foreground_g),
        .b_o(foreground_b),
        .valid_o(foreground_valid),

        .data_i(data_i),
        .data_o(foreground_data),
        .vram_address_i(vram_address_i),
        .wen_i(vram_wen),
        .SELECT_pmf_i(SELECT_pmf_i),
        .SELECT_obm_i(SELECT_obm_i)
    );

    background background (
        .cpu_clk(cpu_clk),

        .current_x_i(current_x[7:0]),
        .current_y_i(current_y[7:0]),

        .r_o(background_r),
        .g_o(background_g),
        .b_o(background_b),

        .data_i(data_i),
        .data_o(background_data),
        .vram_address_i(vram_address_i),
        .wen_i(vram_wen),
        .SELECT_pmb_i(SELECT_pmb_i),
        .SELECT_ntbl_i(SELECT_ntbl_i)
    );

endmodule
