
<!-- hardware-level/rtl/gpu-reduced/README.md -->

# GPU

Repository: <https://github.com/ucsbieee/arcade/tree/main/hardware-level/rtl/>

## About

This is the RTL for the arcade machine. It consists of the following modules:

* Address Bus
  * Sets chip enable nets according to the current address value.
* Controller Interface
  * Reads the controller values. (SIPO)
* Firmware ROM
  * The firmware from the assebmly level is stored in RAM.
  * The 65c02 vectors are also stored here.
* GPU
  * Implementation of this description: [GPU](https://arcade.ucsbieee.org/guides/gpu/).
  * Foreground module and background module.

## Required tools

* [FuseSoC](https://github.com/olofk/fusesoc) ([installation](https://fusesoc.readthedocs.io/en/stable/user/installation.html))
* [Icarus Verilog](http://iverilog.icarus.com/) ([installation](https://iverilog.fandom.com/wiki/Installation_Guide))
* [Vivado ML Enterprise](https://www.xilinx.com/products/design-tools/vivado.html) ([installation](https://www.xilinx.com/support/download.html))
* [Nexys A7-100T](https://store.digilentinc.com/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum/)
* [CMOD A7-35T](https://store.digilentinc.com/cmod-a7-breadboardable-artix-7-fpga-module/)

## Usage

To simulate in Icarus Verilog:

```bash
./top/scripts/sim.sh
```

To synthesize for Nexys A7-100T:

```bash
./top/scripts/nexys_a7.sh
```

To synthesize for CMOD A7-35T:

```bash
./top/scripts/cmod_a7.sh
```

Libraries Used:

* [E4tHam/find_first_set](https://github.com/E4tHam/find_first_set)
