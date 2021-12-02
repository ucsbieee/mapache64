
# Arcade Software

## Getting Started

Run `make` to create a `template` directory.

## Demos

There are demonstrations of how to get started in the `demos` directory.

To build one, cd into `demos` and run `make DEMO=${INSERT_DESIRED_DEMO_DIRECTORY_HERE}`, ex `make DEMO=pattern`. It will create `template` with the contents of the demo.

## Creating a Game

1. Copy `template` to your desired location and cd into it
2. Edit `game_header.txt`, `game.c`, and the top section of the `Makefile`
3. Run `make verify` to ensure that your code compiles and does not break the firmware
4. Test your code
   1. Install ucsbieee/py65mon from <https://github.com/ucsbieee/py65>
   2. Run `make run`
   3. Open `dump/vram.bin` in [the VRAM dump viewer](https://arcade.ucsbieee.org/tools/vram-dump-viewer) to see what would be rendered to the screen
5. Flash your code
   1. Run `make dump`
   2. Connect the [TL866II Plus Programmer](http://www.xgecu.com/en/TL866_main.html) and insert the AT28C256 EEPROM.
   3. Run `minipro -p AT28C256 -w dump/rom.bin`

## Required Tools

Software:

* [ucsbieee/py65](https://github.com/ucsbieee/py65)
* [cc65](https://cc65.github.io/)

Hardware:

* [TL866II Plus Programmer](http://www.xgecu.com/en/TL866_main.html)
* [AT28C256 EEPROM](https://www.jameco.com/webapp/wcs/stores/servlet/ProductDisplay?catalogId=10001&freeText=74843&langId=-1&storeId=10001&productId=74843&avad=234285_b2546e029&source=Avantlink)