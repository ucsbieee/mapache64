
<!-- README.md -->

# 6502 Arcade Machine

Repository: <https://github.com/ucsbieee/arcade>

Website: <https://arcade.ucsbieee.org/>

## Description

UCSB IEEE is working on a large project where we build an arcade machine based on a 6502 microprocessor. I.E. <ins>no microcontrollers!</ins> Only the 6502 microprocessor, ROM and RAM ICs, and FPGA(s).

This project will be carried out across 2 quarters. In spring'21, we will design the hardware and write the software. In fall'21, we will build the hardware and debug as needed.

### Motivation

The UCSB ECE curriculum gives lots of opportunities to practice using microcontrollers (ECE 5, ECE 153ab, ECE 189abc). However, there are no classes that give practice in building systems from a microprocessor. Therefore, this club project is meant to fill that gap in experience.

Also, having an arcade machine in the lab would look awesome. ;)

## How to Contribute

Just follow [this guide](https://arcade.ucsbieee.org/guides/github/). Anyone can help out by doing an item off the [issue list](https://github.com/ucsbieee/arcade/issues). Each item has a difficulty and skill-set description, so anyone from any skill level can find some item they can complete.

There will be optional weekly meetings/lectures for anyone who wants to help/learn more.

## Contact

Discord Server: <http://discord.ucsbieee.org/>

### Project Managers

<!-- README/tables/project-managers.tgn -->
|       Name      |     Role      |                             Discord                             |          Email          |
|:---------------:|:-------------:|:---------------------------------------------------------------:|:-----------------------:|
| Ethan Sifferman | Project Lead  | [@E4tHam#8319](https://discordapp.com/users/120303964448096258) | esifferman@ucsbieee.org |

Let Ethan know if you want to be in a leadership role on this project!

---

## Overview

<!-- README/tables/areas.tgn -->
Right now, we are working on software. There are three different levels of software that need to be written: high level, assembly level, and hardware level. Click the area that sounds most interesting!

|                Area               |              Relevant Skills              | Description                                                               |
|:---------------------------------:|:-----------------------------------------:|---------------------------------------------------------------------------|
|     [High Level](#high-level)     |            cs8,16<br>JavaScript           | We will design the games in JavaScript as a reference.                    |
| [Assembly Level](#assembly-level) | cs64,154<br>ece154a<br>6502&nbsp;Assembly | We will write the firmware in assembly and convert the games to assembly. |
| [Hardware Level](#hardware-level) |      cs154<br>ece152a,154a<br>Verilog     | The GPU and address bus needs to be designed in Verilog.                  |

---

## High Level

Nothing yet. Check back soon!

<!-- ### Software Guides/References Used -->

<!-- ### Software Libraries Used -->

---

## Assembly Level

### Assembly Guides/References Used

* [65c02 Instruction Reference](http://www.obelisk.me.uk/65C02/reference.html)
* [Stephen Edwards 6502 Instruction Overview Video](https://youtu.be/WEliEAc3ZyA)
* [Ben Eater 6502 Computer Video Series](https://www.youtube.com/watch?v=LnzuMJLZRdU&list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH)

### Assembly Tools/Libraries Used

* [Daryl's Kowalski 6502 Simulator](https://sbc.rictor.org/kowalski.html)
* [VASM](http://sun.hasenbraten.de/vasm) ([Barthelmann's Page](http://www.compilers.de/vasm.html)) ([-dotdir Fix](https://www.reddit.com/r/beneater/comments/gcmonc/new_vasm_v18hneed_win32_binary/))

---

## Hardware Level

### Datasheets

* [W65C02S Microprocessor](https://westerndesigncenter.com/wdc/documentation/w65c02s.pdf)
* [W65C22S VIA](https://westerndesigncenter.com/wdc/documentation/w65c22s.pdf)
* [AT28C256 32kB EEPROM](http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf)
* [AS6C62256 32kB SRAM](https://www.alliancememory.com/wp-content/uploads/pdf/AS6C62256.pdf)
* [74LVC4245A Transceiver](https://assets.nexperia.com/documents/data-sheet/74LVC4245A.pdf)
* [iCE40 LP/HX FPGA](https://www.mouser.com/datasheet/2/225/FPGA_DS_02029_3_6_iCE40_LP_HX_Family_Data_Sheet-1022803.pdf)

### Hardware Guides/References Used

* [VGA Documentation](http://www.tinyvga.com/)
* [GreatScott VGA](https://youtu.be/ZNunxg7o8l0)
* [Ben Eater VGA](https://youtu.be/uqY3FMuMuRo)
* [bitluni VGA](https://youtu.be/qJ68fRff5_k)

### Hardware Libraries/Tools Used

* [Verilog of MOS 6502 CPU](https://github.com/Arlet/verilog-6502)
* [nextpnr -- FPGA Place and Route Tool](https://github.com/YosysHQ/nextpnr)

---

## Miscellaneous

### Other Guides/References Used

* [NES PPU Explanation](https://www.youtube.com/watch?v=-THeUXqR3zY&list=PLrOv9FMX8xJHqMvSGB_9G9nZZ_4IgteYf&index=5)
