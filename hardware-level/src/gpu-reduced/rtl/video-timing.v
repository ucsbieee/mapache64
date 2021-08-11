
/* video-timing.v */

`ifndef __UCSBIEEE__GPU_REDUCED__RTL__VIDEO_TIMING_V
`define __UCSBIEEE__GPU_REDUCED__RTL__VIDEO_TIMING_V


module video_timing_m (
    input               clk, // 12.5875 MHz
    input               rst,

    output wire         hsync, vsync,

    output reg    [9:0] hcounter, vcounter,
    output wire         visible,

    output wire         writable
);

    wire hvisible, vvisible;

    assign visible = hvisible & vvisible;

    assign hvisible = (10'd0 <= hcounter) && (hcounter < 10'd320) && !rst;
    assign hsync = ~((10'd328 <= hcounter) && (hcounter < 10'd376) && !rst);

    assign vvisible = (10'd0 <= vcounter) && (vcounter < 10'd480) && !rst;
    assign vsync = ~((10'd490 <= vcounter) && (vcounter < 10'd492) && !rst);


    wire [9:0] hcounter_next =
        ( hcounter == 10'd399 ) ? 0         :
        hcounter + 10'd1;

    wire [9:0] vcounter_next =
        ( hcounter != 10'd399 ) ? vcounter  :
        ( vcounter == 10'd524 ) ? 10'd0     :
        vcounter + 10'd1;


    assign writable = ~vvisible;


    always @ ( posedge clk ) begin
        if ( rst ) begin
            hcounter <= 10'b0;
            vcounter <= 10'b0;
        end else begin
            hcounter <= hcounter_next;
            vcounter <= vcounter_next;
        end

        `ifdef SIM
        if ( vcounter != 10'd0 && vcounter_next == 10'd0 ) begin
            $display( "Next frame: [Time=%0t]", $realtime );
        end
        `endif

    end

endmodule


`endif
