
// `ifndef SIM
//     `ERROR__SIM_undefined
//     exit
// `endif

module gpu_tb;

logic clk_12_5875 = 1;
always #( mapache64::ClkGpuPeriod / 2 ) clk_12_5875 <= ~clk_12_5875;
logic clk_1 = 1;
always #( mapache64::ClkCpuPeriod / 2 ) clk_1 <= ~clk_1;
logic rst = 1;


gpu #(
    .FOREGROUND_NUM_OBJECTS(64)
) gpu (
    .gpu_clk(clk_12_5875),
    .cpu_clk(clk_1),
    .rst(rst),

    // video output
    .r_o(), .g_o(), .b_o(),
    .hsync_o(), .vsync_o(),
    .controller_start_fetch_o(),

    // VRAM interface
    .data_i('x),
    .data_o(),
    .vram_address_i('x),
    .wen_i('0),
    .SELECT_vram_i('0),
    .SELECT_pmf_i('0),
    .SELECT_pmb_i('0),
    .SELECT_ntbl_i('0),
    .SELECT_obm_i('0),
    .SELECT_txbl_i('0),

    .SELECT_in_vblank_i('0),
    .SELECT_clr_vblank_irq_i('0),
    .vblank_irq_o()
);

string tests[$] = '{
    "obs_stress",
    "random_blue_black",
    "random_green_cyan",
    "random_red_magenta",
    "random_yellow_white"
};
string dump_filename, image_filename;
integer file;
byte vram ['h1000];
integer failures = 0;

import "DPI-C" function int gpugold_load_png(string filename);
import "DPI-C" function byte gpugold_pixel(byte unsigned x, byte unsigned y);
import "DPI-C" function void gpugold_add_difference(byte unsigned x, byte unsigned y, byte unsigned pixel);
import "DPI-C" function byte gpugold_save_difference(string filename);

/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
$timeformat( -3, 6, "ms", 0);
//\\ =========================== \\//

rst = 1;
@(posedge clk_1);
@(posedge clk_1);
rst = 0;

foreach (tests[i]) begin

    $display("Running test \"%s\"", tests[i]);

    dump_filename = $sformatf("vram_dumps/%s.bin", tests[i]);

    // Open the files
    file = $fopen(dump_filename, "rb");
    if (!file) begin
        $display("Error opening file: %s", dump_filename);
        $fatal;
    end
    image_filename = $sformatf("gold_images/%s.png", tests[i]);
    if (gpugold_load_png(image_filename)) begin
        $fatal;
    end

    // Load the dump file into VRAM
    $fread(vram, file);
    $fclose(file);
    gpu.foreground.PMF  = vram['h000:'h1ff];
    gpu.background.PMB  = vram['h200:'h3ff];
    gpu.background.NTBL = vram['h400:'h7ff];
    gpu.foreground.OBM  = vram['h800:'h8ff];
    gpu.text.TXBL       = vram['h900:'hcff];

    // Run for 1 frame
    @(negedge gpu.vsync_o);
    failures = gpugold_save_difference($sformatf("%s_diff.png", tests[i]));
    if (failures) begin
        $display("Failures in test \"%s\": %0d", tests[i], failures);
        $fatal;
    end else begin
        $display("Passed test \"%s\"", tests[i]);
    end
end
//\\ =========================== \\//
$finish;
end

always @(negedge clk_12_5875) begin : check_pixel
    automatic logic [5:0] expected_pixel = gpugold_pixel(gpu.x_d, gpu.y_d);
    automatic logic [5:0] received_pixel = {gpu.r_d, gpu.g_d, gpu.b_d};
    if (!rst && gpu.drawing) begin
        assert (expected_pixel === received_pixel)
        else begin
            $display(
                "Failed (%0d,%0d) %0t: expected=%b received=%b text_valid=%b foreground_valid=%b ",
                gpu.x_d, gpu.y_d, $realtime, expected_pixel, received_pixel, gpu.text_valid, gpu.foreground_valid
            );
            gpugold_add_difference(gpu.x_d, gpu.y_d, received_pixel);
        end
    end
end

endmodule
