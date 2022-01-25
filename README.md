# Mapache 64

6502 Arcade Machine
- Repository: [github.com/ucsbieee/mapache64](https://github.com/ucsbieee/mapache64)
- Website: [mapache64.ucsbieee.org](https://mapache64.ucsbieee.org)
- Discord Server: [discord.ucsbieee.org](http://discord.ucsbieee.org)

## Description and Motivation

UCSB IEEE is working on a large project named "Mapache 64" for which we are building an arcade machine based on the 6502 microprocessor. (i.e. <ins>no microcontrollers!</ins>) It only uses the 6502 microprocessor, ROM and RAM ICs, and an FPGA implementing a custom GPU.

The UCSB ECE curriculum gives lots of opportunities to practice using microcontrollers (*ECE 5, ECE 153ab, ECE 189abc*). However, there are no classes that give practice in building systems from a microprocessor. Therefore, this club project is meant to fill that gap in experience.

Also, having an arcade machine in the lab would look awesome. ;)

## Current State

The hardware prototype has been finished on breadboards. It works with the [Cmod A7-35T](https://digilent.com/reference/programmable-logic/cmod-a7/start) [Artix-7](https://www.xilinx.com/products/silicon-devices/fpga/artix-7.html) development board. All peripherals (*GPU, ROM, RAM, VGA port, controller ports*) work. Our next step is writing the games and creating a custom PCB.

We have configured the [`cc65`](https://cc65.github.io) C compiler so that we can more easily write the games in C instead of 6502 assembly.

Video screen:

<img src="docs/_media/physical/picture.jpg" width=50% height=50%>

The breadboard circuit with a Cmod A7:

<img src="docs/_media/physical/cmod.jpg" width=50% height=50%>

---

## Project Overview

There are three different levels to Mapache 64 development: high level, assembly level, and hardware level.

|                Area                         |              Relevant Skills              | Description                                                      |
|:-------------------------------------------:|:-----------------------------------------:|------------------------------------------------------------------|
|     [High Level](#high-level-resources)     |            cs8,16<br>JavaScript           | Designing emulators and game ideas in JavaScript as a reference. |
| [Assembly Level](#assembly-level-resources) | cs64,154<br>ece154a<br>6502&nbsp;Assembly | Writing the firmware in C and assembly.                          |
| [Hardware Level](#hardware-level-resources) |      cs154<br>ece152a,154a<br>Verilog     | Writing RTL for the Artix-7 and designing the PCB(s).            |

---

## Assembly Level Resources

### Assembly Guides/References Used

* [Ben Eater 6502 Computer Video Series](https://www.youtube.com/watch?v=LnzuMJLZRdU&list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH)

### Assembly Tools/Libraries Used

* [cc65](https://cc65.github.io) compiler
* [py65](https://github.com/mnaberez/py65) 6502 simulator

---

## Hardware Level Resources

### Datasheets

* [W65C02S](https://westerndesigncenter.com/wdc/documentation/w65c02s.pdf) Microprocessor
* [AT28C256](http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf) 32kB EEPROM
* [AS6C62256](https://www.alliancememory.com/wp-content/uploads/pdf/AS6C62256.pdf) 32kB SRAM
* [Cmod A7](https://digilent.com/reference/programmable-logic/cmod-a7/reference-manual) FPGA board
* [Nexys A7](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual) FPGA board
* [VESA, 640x480 @ 60 Hz Video Timing](http://www.tinyvga.com/vga-timing/640x480@60Hz) guide

### Hardware Guides/References Used

* [VGA Documentation](http://www.tinyvga.com)
* [Ben Eater VGA](https://youtu.be/uqY3FMuMuRo)

### Hardware Libraries/Tools Used

* [FuseSoC](https://github.com/olofk/fusesoc) HDL build tool
* [Icarus Verilog](http://iverilog.icarus.com) HDL implementation
* [Vivado ML Enterprise](https://www.xilinx.com/products/design-tools/vivado.html) HDL IDE
* [Nexys A7-100T](https://store.digilentinc.com/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum) FPGA board

---

## Miscellaneous Resources

* [NES PPU Explanation](https://www.youtube.com/watch?v=-THeUXqR3zY&list=PLrOv9FMX8xJHqMvSGB_9G9nZZ_4IgteYf&index=5)
