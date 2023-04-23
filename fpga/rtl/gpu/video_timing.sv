
/* video-timing.v */

module video_timing (
    input               clk_12_5875,
    input               rst,

    output  logic       hsync_o, vsync_o,

    output  logic [9:0] hcounter_o, vcounter_o,
    output  logic       visible_o,

    output  logic       writable_o
);

    initial begin
        hcounter_o = 10'b0;
        vcounter_o = 10'b0;
    end

    logic hvisible, vvisible;

    assign visible_o = hvisible & vvisible;

    assign hvisible = (hcounter_o < 10'd320) && !rst;
    assign hsync_o = ~((10'd328 <= hcounter_o) && (hcounter_o < 10'd376) && !rst);

    assign vvisible = (vcounter_o < 10'd480) && !rst;
    assign vsync_o = ~((10'd490 <= vcounter_o) && (vcounter_o < 10'd492) && !rst);


    wire [9:0] hcounter_next =
        ( hcounter_o == 10'd399 ) ? 0         :
        hcounter_o + 10'd1;

    wire [9:0] vcounter_next =
        ( hcounter_o != 10'd399 ) ? vcounter_o  :
        ( vcounter_o == 10'd524 ) ? 10'd0     :
        vcounter_o + 10'd1;


    assign writable_o = ~vvisible;


    always_ff @(posedge clk_12_5875) begin
        if ( rst ) begin
            hcounter_o <= 10'b0;
            vcounter_o <= 10'b0;
        end else begin
            hcounter_o <= hcounter_next;
            vcounter_o <= vcounter_next;
        end

        `ifdef SIM
        if ( vcounter_o != 10'd0 && vcounter_next == 10'd0 ) begin
            $display( "Next frame: [Time=%0t]", $realtime );
        end
        `endif

    end

endmodule
