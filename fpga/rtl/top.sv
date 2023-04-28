
module top #(
    parameter FOREGROUND_NUM_OBJECTS = 64
) (
    input   logic                   gpu_clk,
    input   logic                   cpu_clk,
    input   logic                   rst,

    input   mapache64::address_t    cpu_address_i,
    input   mapache64::data_t       data_i,
    output  mapache64::data_t       data_o,
    output  logic                   fpga_data_en_o,
    input   logic                   wen_ni,

    output  logic                   SELECT_ram_no,
    output  logic                   ram_OE_no,
    output  logic                   SELECT_rom_no,

    output  logic                   vblank_irq_no,

    output  logic [1:0]             r_o, g_o, b_o,
    output  logic                   hsync_o, vsync_o,

    input   logic                   controller_clk,
    output  logic                   controller_clk_o,
    output  logic                   controller_latch_o,
    input   logic                   controller_1_serial_ni,
    input   logic                   controller_2_serial_ni,
    output  mapache64::data_t       controller_1_data_o,
    output  mapache64::data_t       controller_2_data_o
);

    // internal
    logic SELECT_vram, SELECT_pmf, SELECT_pmb, SELECT_ntbl, SELECT_obm, SELECT_txbl;
    logic SELECT_firmware, SELECT_vectors;
    logic SELECT_in_vblank, SELECT_clr_vblank_irq, SELECT_controller_1, SELECT_controller_2, controller_start_fetch;

    // inputs
    wire wen = ~wen_ni;

    // outputs
    logic SELECT_ram;
    logic SELECT_rom;
    logic vblank_irq;
    assign SELECT_ram_no = ~SELECT_ram;
    assign SELECT_rom_no = ~SELECT_rom;
    assign vblank_irq_no = ~vblank_irq;

    assign ram_OE_no = ~( !wen && SELECT_ram );
    assign fpga_data_en_o = !wen && (
        SELECT_firmware         ||
        SELECT_vram             ||
        SELECT_vectors          ||
        SELECT_in_vblank        ||
        SELECT_clr_vblank_irq   ||
        SELECT_controller_1     ||
        SELECT_controller_2
    );


    address_bus address_bus (
        .cpu_address_i(cpu_address_i),
        .SELECT_ram_o(SELECT_ram),

        .SELECT_vram_o(SELECT_vram),
        .SELECT_pmf_o(SELECT_pmf),
        .SELECT_pmb_o(SELECT_pmb),
        .SELECT_ntbl_o(SELECT_ntbl),
        .SELECT_obm_o(SELECT_obm),
        .SELECT_txbl_o(SELECT_txbl),

        .SELECT_firmware_o(SELECT_firmware),
        .SELECT_rom_o(SELECT_rom),
        .SELECT_vectors_o(SELECT_vectors),

        .SELECT_in_vblank_o(SELECT_in_vblank),
        .SELECT_clr_vblank_irq_o(SELECT_clr_vblank_irq),
        .SELECT_controller_1_o(SELECT_controller_1),
        .SELECT_controller_2_o(SELECT_controller_2)
    );



    mapache64::data_t firmware_data, gpu_data;

    assign data_o =
        SELECT_firmware     ? firmware_data         :
        SELECT_vectors      ? firmware_data         :
        SELECT_vram         ? gpu_data              :
        SELECT_in_vblank    ? gpu_data              :
        SELECT_controller_1 ? controller_1_data_o   :
        SELECT_controller_2 ? controller_2_data_o   :
        'x;


    mapache64::firmware_address_t firmware_address; assign firmware_address = 13'(cpu_address_i-16'h5000);

    firmware firmware (
        .address_i(firmware_address),
        .data_o(firmware_data),
        .SELECT_firmware_i(SELECT_firmware),
        .SELECT_vectors_i(SELECT_vectors)
    );


    mapache64::vram_address_t vram_address; assign vram_address = 12'( cpu_address_i - 16'h4000 );

    gpu #(
        .FOREGROUND_NUM_OBJECTS(FOREGROUND_NUM_OBJECTS)
    ) gpu (
        .gpu_clk(gpu_clk),
        .cpu_clk(cpu_clk),
        .rst(rst),

        .r_o(r_o),
        .g_o(g_o),
        .b_o(b_o),
        .hsync_o(hsync_o),
        .vsync_o(vsync_o),
        .controller_start_fetch_o(controller_start_fetch),

        .data_i(data_i),
        .data_o(gpu_data),
        .vram_address_i(vram_address),
        .wen_i(wen),
        .SELECT_vram_i(SELECT_vram),
        .SELECT_pmf_i(SELECT_pmf),
        .SELECT_pmb_i(SELECT_pmb),
        .SELECT_ntbl_i(SELECT_ntbl),
        .SELECT_obm_i(SELECT_obm),
        .SELECT_txbl_i(SELECT_txbl),

        .SELECT_in_vblank_i(SELECT_in_vblank),
        .SELECT_clr_vblank_irq_i(SELECT_clr_vblank_irq),
        .vblank_irq_o(vblank_irq)
    );

    controller_interface #(
        .NUM_CONTROLLERS(2),
        .LATCH_PULSE_WIDTH(2)
    ) controller_interface (
        .clk(controller_clk),
        .rst(rst),
        .start_fetch_i(controller_start_fetch),

        .clk_o(controller_clk_o),
        .latch_o(controller_latch_o),

        .serial_LIST_ni({controller_2_serial_ni,controller_1_serial_ni}),

        .data_LIST_o({controller_2_data_o,controller_1_data_o})
    );

endmodule
