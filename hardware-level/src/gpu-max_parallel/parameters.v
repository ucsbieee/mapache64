
`define VRAM_SIZE       12'h900
`define VRAM_ADDR_WIDTH 12

`define GPU_CLK_FREQ    12587500
`define GPU_CLK_PERIOD  ( 1.0 / `GPU_CLK_FREQ )

`timescale 1s/1fs

`define TESTING     1

`define TEST_PMF    "vram-tests/random/pmf.dat"
`define TEST_PMB    "vram-tests/random/pmb.dat"
`define TEST_NTBL   "vram-tests/random/ntbl.dat"
`define TEST_OBM    "vram-tests/random/obm.dat"
