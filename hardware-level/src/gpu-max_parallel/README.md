
<!-- hardware-level/src/gpu-max_parallel/README.md -->

# GPU

Repository: <https://github.com/ucsbieee/arcade/tree/main/hardware-level/src/gpu-max_parallel>

## About

This is a draft of the GPU described in [GPU](https://arcade.ucsbieee.org/guides/gpu/).

## Required tools

* [FuseSoC](https://github.com/olofk/fusesoc) ([installation](https://fusesoc.readthedocs.io/en/stable/user/installation.html))
* [Icarus Verilog](http://iverilog.icarus.com/) ([installation](https://iverilog.fandom.com/wiki/Installation_Guide))
* [Vivado ML Enterprise](https://www.xilinx.com/products/design-tools/vivado.html) ([installation](https://www.xilinx.com/support/download.html))
* [Nexys A7-100T](https://store.digilentinc.com/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum/)

## Usage

To initialize the FuseSoC core:

```bash
fusesoc library add gpu ${arcade_location}/hardware-level/src/gpu-max_parallel --sync-type=local
```

To simulate in Icarus Verilog:

```bash
fusesoc run --target sim ucsbieee:arcade:gpu_max_parallel
```

To synthesize for Nexys A7-100T:

```bash
fusesoc run --target nexys_a7 ucsbieee:arcade:gpu_max_parallel
```
