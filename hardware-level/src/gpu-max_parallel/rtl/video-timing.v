
/* gpu-counters.v */


// `default_nettype none

module video_timing_m (
    input               clk, // 12.5875 MHz
    input               rst,

    output reg          hsync, vsync,

    output wire   [7:0] xp, yp,
    output wire         visible,

    output wire         writable
);

    reg [9:0] hcounter, vcounter;
    reg hvisible, vvisible;

    assign visible = hvisible & vvisible;

    assign xp = visible ? hcounter[7:0] : {8{1'bx}};
    assign yp = visible ? vcounter[7:0] : {8{1'bx}};

    always @ * begin
        if ( rst ) begin
            hsync       = 0;
            vcounter    = 0;
            vvisible    = 0;
            vsync       = 0;
        end

        case ( hcounter )
            0   : hvisible  = 1;
            320 : hvisible  = 0;
            328 : hsync     = 1;
            376 : hsync     = 0;
        endcase

        case ( vcounter )
            0   : vvisible  = 1;
            480 : vvisible  = 0;
            490 : vsync     = 1;
            492 : vsync     = 0;
        endcase
    end


    wire [9:0] hcounter_next =
        ( hcounter == 399 ) ? 0         :
        hcounter + 1;

    wire [9:0] vcounter_next =
        ( hcounter != 399 ) ? vcounter  :
        ( vcounter == 524 ) ? 0         :
        vcounter + 1;


    assign writable = vvisible;


    always @ ( posedge clk ) begin
        if ( rst ) begin
            hcounter <= 10'b0;
            hvisible <= 10'b0;
        end else begin
            hcounter <= hcounter_next;
            vcounter <= vcounter_next;
        end
        `ifndef SIM
        if ( vcounter != 0 && vcounter_next == 0 ) begin
            $display( "Next frame: [Time=%0t]", $realtime );
        end
        `endif
    end

endmodule
