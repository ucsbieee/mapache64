
package mapache64;

    localparam FirmwareSize = 14'h2000;

    localparam VramSize  = 12'h900;
    localparam VramAddrWidth = 12;

    parameter GpuForegroundNumObjects = 64;

    localparam ClkGpuFreq = 12587500;
    localparam ClkGpuPeriod = 1.0s/ClkGpuFreq;

    localparam ClkCpuFreq = 1000000;
    localparam ClkCpuPeriod = 1.0s/ClkCpuFreq;

endpackage
