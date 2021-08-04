
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

    assign hvisible = (0 <= hcounter) && (hcounter < 320) && !rst;
    assign hsync = ~((328 <= hcounter) && (hcounter < 376) && !rst);

    assign vvisible = (0 <= vcounter) && (vcounter < 480) && !rst;
    assign vsync = ~((490 <= vcounter) && (vcounter < 492) && !rst);


    wire [9:0] hcounter_next =
        ( hcounter == 399 ) ? 0         :
        hcounter + 1;

    wire [9:0] vcounter_next =
        ( hcounter != 399 ) ? vcounter  :
        ( vcounter == 524 ) ? 0         :
        vcounter + 1;


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
        if ( vcounter != 0 && vcounter_next == 0 ) begin
            $display( "Next frame: [Time=%0t]", $realtime );
        end
        `endif
    end

endmodule


`endif
