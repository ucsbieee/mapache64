
<!-- README.md -->

# 6502 Arcade Machine

Repository: <https://github.com/ucsbieee/arcade>

Website: <https://arcade.ucsbieee.org/>

## Description

UCSB IEEE is working on a large project where we build an arcade machine based on a 6502 microproccessor. I.E. <ins>no microcontrollers!</ins> Only the 6502 microprocessor, ROM and RAM ICs, and FPGA(s).

This project will be carried out accross 2 quarters. In spring'21, we will design the hardware and write the software. In fall'21, we will build the hardware and debug as needed.

### Motivation

The UCSB ECE cirriculum gives lots of opportunities to practice using microcontrollers (ECE 5, ECE 153ab, ECE 189abc). However, there are no classes that give practice in building systems from a microprocessor. Therefore, this club project is meant to fill that gap in experience.

Also, having an arcade machine in the lab would look awesome. ;)

## How to Contribute

Anyone can help out by doing an item on the public to-do list. Each item will give a difficulty and skill-set description, so anyone from any skill level can find some item they can complete.

There will be optional weekly meetings/lectures for anyone who wants to learn more.

## Contact

Discord Server: <http://discord.ucsbieee.org/>

### Project Managers

<!-- README\tables\project-managers.tgn -->
|       Name      |     Role     |                             Discord                             |          Email          |
|:---------------:|:------------:|:---------------------------------------------------------------:|:-----------------------:|
| Ethan Sifferman | Project Lead | [@E4tHam#8319](https://discordapp.com/users/120303964448096258) | esifferman@ucsbieee.org |
|  Sammy Umezawa  |              |  [@fraps#8624](https://discordapp.com/users/260474815184502785) |  sammyumezawa@ucsb.edu  |

---

## Overview

<!-- README\tables\areas.tgn -->
Right now, we are working on software. There are three different levels of software that need to be written: high level, assembly level, and hardware level. Click the area that sounds most intersting!

|                Area               |              Relevant Skills              | Description                                                                                                                                                                |
|:---------------------------------:|:-----------------------------------------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     [High Level](#high-level)     |            cs8,16<br>JavaScript           | We will design the entire Arcade Machine with JavaScript. This involves the firmware and the games. Then the assembly-level workers will translate everything to assembly. |
| [Assembly Level](#assembly-level) | cs64,154<br>ece154a<br>6502&nbsp;Assembly | The high-level code needs to be converted to assembly. Plus, the addressable space of the 6502 needs to be designed.                                                       |
| [Hardware Level](#hardware-level) |      cs154<br>ece152a,154a<br>Verilog     | This is where hardware such as the PPU, controllers, and address bus need to be designed.                                                                                  |


### General Guides/References

* [NES PPU Explanation](https://www.youtube.com/watch?v=-THeUXqR3zY&list=PLrOv9FMX8xJHqMvSGB_9G9nZZ_4IgteYf&index=5)

---

## High Level

Nothing yet. Check back soon!

<!-- ### Software Guides/References -->

<!-- ### Software Libraries Used -->

---

## Assembly Level

### Assembly Guides/References

* [Ben Eater 6502 Computer Project](https://www.youtube.com/watch?v=LnzuMJLZRdU&list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH)

### Assembly Libraries Used

* [VASM](http://sun.hasenbraten.de/vasm)
* [STM32NES](https://github.com/jefflongo/stm32nes)

---

## Hardware Level

### Hardware Guides/References

* [VGA Documentation](http://www.tinyvga.com/)
* [GreatScott VGA](https://youtu.be/ZNunxg7o8l0)
* [Ben Eater VGA](https://youtu.be/uqY3FMuMuRo)
* [bitluni VGA](https://youtu.be/qJ68fRff5_k)

### Hardware Libraries Used

* [Verilog of MOS 6502 CPU](https://github.com/Arlet/verilog-6502)
