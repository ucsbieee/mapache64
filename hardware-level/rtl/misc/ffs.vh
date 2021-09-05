
`ifndef __E4THAM__FFS_VH
`define __E4THAM__FFS_VH

`define __E4THAM__FFS__GET_DEPTH(PARAM)     $clog2( (PARAM>=2) ? PARAM : 2 )


module ffs_m #(
    parameter INPUT_WIDTH   = 8,
    parameter SIDE          = 1'b0
) (
    input            [((INPUT_WIDTH>=1)?INPUT_WIDTH:1)-1:0] in,
    output                                                  valid,
    output   [(`__E4THAM__FFS__GET_DEPTH(INPUT_WIDTH))-1:0] out
);

endmodule

`undef __E4THAM__FFS__GET_DEPTH
`endif
