
<!-- fpga/README.md -->

# FPGA

Repository: <https://github.com/ucsbieee/mapache64/tree/main/fpga/>

## RTL

This is the RTL for Mapache 64. It consists of the following modules:

* Address Bus
  * Sets chip enable nets according to the current address value.
* Controller Interface
  * Reads the controller values. (SIPO)
* Firmware ROM
  * The firmware from the assebmly level is stored in RAM.
  * The 65c02 vectors are also stored here.
* GPU
  * Implementation of this description: [GPU](https://mapache64.ucsbieee.org/guides/gpu/).
  * Foreground module and background module.

## Required tools

* [FuseSoC](https://github.com/olofk/fusesoc)
* [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)
* [Vivado ML Enterprise](https://www.xilinx.com/products/design-tools/vivado.html)
* [Cmod A7-35T](https://store.digilentinc.com/cmod-a7-breadboardable-artix-7-fpga-module/)

## Usage

```bash
# setup
cd fpga
./rom/get_firmware.sh
./rom/get_font.sh
fusesoc library add ucsbieee_mapache64_top . --sync-type=local
fusesoc library add nes_controller_interface https://github.com/sifferman/nes_controller_interface --sync-type=git

# Lint with Verilator
fusesoc run --target lint ucsbieee:mapache64:top
# Simulate with Icarus
fusesoc run --target sim --tool icarus ucsbieee:mapache64:top
# Simulate with Verilator
fusesoc run --target sim --tool verilator ucsbieee:mapache64:top
# Synthesize for the Cmod-A7
fusesoc run --target cmod_a7 ucsbieee:mapache64:top
```

Cmod-A7 SPI Flash: `mx25l3273f`
