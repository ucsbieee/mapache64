
/* pattern-hflipper.v */


module pattern_hflipper_m (
    input        [15:0] in,
    input               hflip,
    output wire  [15:0] out
);

    assign out = ( hflip ) ? {
            in[ 1: 0], in[ 3: 2], in[ 5: 4], in[ 7: 6],
            in[ 9: 8], in[11:10], in[13:12], in[15:14]
        } : in;

endmodule
