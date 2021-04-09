
/* gpu.v */

`include "modules/counter.v"

module gpu_m
(
    input           clk, rst    ,
    output   [14:0] vram_addr   ,
    input     [7:0] vram_data   ,
    output    [1:0] r, g, b     ,
    output          visible     ,
    output reg      hsync, vsync
);

    // horizontal timer
    wire hcounter_clk;
    wire hcounter_rst;
    wire [8:0] hcounter_count;
    counter_m #( .NUM_BITS(9) ) hcounter (
        .clk(hcounter_clk),
        .rst(hcounter_rst),
        .count(hcounter_count)
    );

    // vertical timer
    wire vcounter_clk;
    wire vcounter_rst;
    wire [9:0] vcounter_count;
    counter_m #( .NUM_BITS(10) ) vcounter (
        .clk(vcounter_clk),
        .rst(vcounter_rst),
        .count(vcounter_count)
    );

    // other timing states
    reg vvisible, hvisible;
    wire [6:0] xp, yp;





    // counter increment timings
    assign hcounter_clk = clk;
    assign vcounter_clk = ( hcounter_count == 0 );

    // timing resets
    assign hcounter_rst = rst ? 1 : ( hcounter_count == 263 );
    assign vcounter_rst = rst ? 1 : ( vcounter_count == 627 );


    // horizontal timing state assignments
    always @ ( posedge hcounter_clk or hcounter_count ) begin
        case ( hcounter_count )
            0   : hvisible <= 1;
            200 : hvisible <= 0;
            210 : hsync    <= 1;
            242 : hsync    <= 0;
        endcase
    end

    // vertical timing state assignments
    always @ ( posedge vcounter_clk or vcounter_count ) begin
        case ( vcounter_count )
            0   : vvisible <= 1;
            600 : vvisible <= 0;
            601 : vsync    <= 1;
            605 : vsync    <= 0;
        endcase
    end

    // reset
    always @ ( negedge rst ) begin
        hvisible    <= 1;
        hsync       <= 0;
        vvisible    <= 1;
        vsync       <= 0;
    end


    // vram
    assign visible = (hvisible & vvisible & ~rst);

    assign xp = hcounter_count[7:1];
    assign yp = vcounter_count[9:3];

    assign vram_addr = { yp, xp };

    assign r = vram_data[5:4];
    assign g = vram_data[3:2];
    assign b = vram_data[1:0];


endmodule
