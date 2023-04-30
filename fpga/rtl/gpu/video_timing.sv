
/* video-timing.v */

module video_timing (
    input               clk_12_5875,
    input               rst,

    output  logic       hsync_o, vsync_o,

    output  logic [9:0] hcounter_o, vcounter_o,
    output  logic       visible_o,

    output  logic       writable_o
);

    logic [9:0] hcounter_d, hcounter_q, vcounter_d, vcounter_q;
    assign hcounter_o = hcounter_q;
    assign vcounter_o = vcounter_q;

    initial begin
        hcounter_q = 10'b0;
        vcounter_q = 10'b0;
    end

    logic hvisible, vvisible;

    assign visible_o = hvisible & vvisible;

    assign hvisible = (hcounter_q < 10'd320) && !rst;
    assign hsync_o = ~((10'd328 <= hcounter_q) && (hcounter_q < 10'd376) && !rst);

    assign vvisible = (vcounter_q < 10'd480) && !rst;
    assign vsync_o = ~((10'd490 <= vcounter_q) && (vcounter_q < 10'd492) && !rst);


    assign hcounter_d =
        ( hcounter_q == 10'd399 ) ? 0         :
        hcounter_q + 10'd1;

    assign vcounter_d =
        ( hcounter_q != 10'd399 ) ? vcounter_q  :
        ( vcounter_q == 10'd524 ) ? 10'd0       :
        vcounter_q + 10'd1;


    assign writable_o = ~vvisible;


    always_ff @(posedge clk_12_5875) begin
        if ( rst ) begin
            hcounter_q <= 10'b0;
            vcounter_q <= 10'b0;
        end else begin
            hcounter_q <= hcounter_d;
            vcounter_q <= vcounter_d;
        end

        `ifdef SIM
        if ( vcounter_q != 10'd0 && vcounter_d == 10'd0 ) begin
            $display( "Next frame: [Time=%0t]", $realtime );
        end
        `endif

    end

endmodule
