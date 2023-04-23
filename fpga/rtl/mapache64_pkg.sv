
/* verilator lint_save */
/* verilator lint_off DECLFILENAME */
package mapache64;
/* verilator lint_off UNUSEDPARAM */

    localparam FirmwareSize = 14'h2000;
    localparam FirmwareAddrWidth = $clog2(FirmwareSize);

    localparam VramSize  = 12'h900;
    localparam VramAddrWidth = 12;

    parameter GpuForegroundNumObjects = 64;

    localparam ClkGpuFreq = 12587500;
    localparam ClkGpuPeriod = 1.0s/ClkGpuFreq;

    localparam ClkCpuFreq = 1000000;
    localparam ClkCpuPeriod = 1.0s/ClkCpuFreq;

    typedef logic [15:0] address_t;
    typedef logic [FirmwareAddrWidth-1:0] firmware_address_t;
    typedef logic [VramAddrWidth-1:0] vram_address_t;
    typedef logic [7:0] data_t;

    function automatic logic in_bounds (input address_t left, src, right);
        return
        /* verilator lint_save */
        /* verilator lint_off UNSIGNED */
            (left <= src)
        /* verilator lint_restore */
            &&
        /* verilator lint_save */
        /* verilator lint_off CMPCONST */
            (src <= right)
        /* verilator lint_restore */
        ;
    endfunction

endpackage
/* verilator lint_restore */
