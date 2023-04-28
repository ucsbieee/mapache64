
/* verilator lint_save */
/* verilator lint_off DECLFILENAME */
package mapache64;
/* verilator lint_off UNUSEDPARAM */

    localparam FirmwareSize = 14'h2000;
    localparam FirmwareAddrWidth = $clog2(FirmwareSize);

    localparam VramSize  = 12'h900;
    localparam VramAddrWidth = 12;

    parameter GpuForegroundNumObjects = 64;

    localparam ClkGpuFreq = 12587500.0;
    localparam ClkGpuPeriod = 1.0s/ClkGpuFreq;

    localparam ClkCpuFreq = 1000000.0;
    localparam ClkCpuPeriod = 1.0s/ClkCpuFreq;

    typedef logic [15:0] address_t;
    typedef logic [FirmwareAddrWidth-1:0] firmware_address_t;
    typedef logic [VramAddrWidth-1:0] vram_address_t;
    typedef logic [7:0] data_t;

    function automatic logic [7:0] reverse8(logic [7:0] data);
        logic [7:0] result;
        for (integer i = 0; i < 8; i++) begin
            result[i] = data[7-i];
        end
        return result;
    endfunction

    function automatic logic in_bounds16(logic [15:0] left, src, right);
        return (left <= src) && (src <= right);
    endfunction


    typedef struct packed {
        logic       colorselect;
        logic [6:0] pmca;
    } txbl_tile_t;

endpackage
/* verilator lint_restore */
