
/* ram.v */


module ram_m
# (
    parameter   DATA_WIDTH  = 8     ,
    parameter   ADDR_WIDTH  = 15
) (
    input  [ADDR_WIDTH-1:0] address , // Address input
    inout  [DATA_WIDTH-1:0] data    , // Data I/O
    input                   WE      , // Write Enable
    input                   OE        // Output Enable
);

    parameter DEPTH = ( 1 << ADDR_WIDTH );

    // main memory
    reg [DATA_WIDTH-1:0] MEM [0:DEPTH-1];


    // data is MEM[address] only when output is enabled
    assign data = ( OE ) ? MEM[address] : 'bz ;

    // handle write
    always @ * begin
        // if WE, MEM[address] = data
        if ( WE )
            MEM[address] <= data;
        // if WE and OE, display "ERROR"
        if ( WE & OE )
            $display( "RAM ERROR: OE and WE both active" );
    end


    // load ram.dat into mem
    initial $readmemh( "data/ram.dat", MEM );

    // // Make MEM values visible in GTKWave
    // integer i;
    // initial begin
    //     for ( i = 0; i < 20; i = i+1 )
    //         $dumpvars( 0, MEM[i] );
    // end


endmodule
