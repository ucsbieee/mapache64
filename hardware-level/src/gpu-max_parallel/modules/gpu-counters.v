
/* gpu-counters.v */


module gpu_counters_m (
    input               clk, // 12.5875 MHz
    input               rst,

    output reg    [9:0] hcounter,
    output reg          hvisible,
    output reg          hsync,

    output reg    [9:0] vcounter,
    output reg          vvisible,
    output reg          vsync
);

    always @ * begin
        if ( rst ) begin
            hcounter    = 0;
            hvisible    = 0;
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


    always @ ( posedge clk ) begin
        hcounter <= hcounter_next;
        vcounter <= vcounter_next;
        if ( vcounter != 0 && vcounter_next == 0 ) begin
            $display( "Next frame: [Time=%0t]", $realtime );
        end
    end

endmodule
