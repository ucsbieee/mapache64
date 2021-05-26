
/* delaymem.v */


`include "parameters.v"

module ram_m
# (
    parameter   DATA_WIDTH  = 8                 ,
    parameter   ADDR_WIDTH  = `VRAM_ADDR_WIDTH  ,
    parameter   DEPTH       = `VRAM_SIZE
) (
    input  [ADDR_WIDTH-1:0] address , // Address input
    inout  [DATA_WIDTH-1:0] data    , // Data I/O
    input                   we      , // Write Enable
    input                   oe      , // Output Enable
    input                   cs        // Chip Select
);


    reg [DATA_WIDTH-1:0] MEM [0:DEPTH-1] ;

    // data is output only when oe==1
    assign data =
        ( !we && oe && cs ) ? MEM[address] :
        {DATA_WIDTH{1'bz}}
    ;

    // handle reading
    always @ * begin
        // if we, MEM[address] = data
        if ( we && !oe && cs )
            MEM[address] <= data;
        // if we and oe, display "ERROR"
        if ( we && oe && cs )
            $display( "RAM ERROR: oe and we both active" );
    end


    // dump
    genvar i;
    generate
        for ( i = 0; i < DEPTH; i = i+1 ) begin
            $dumpvars( 1, MEM[i] );
        end
    endgenerate

endmodule
