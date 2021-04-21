#!bash

DUMP_PATH=dump/

py65mon <<EOF
mpu 65C02
load ${DUMP_PATH}arcade.bin
goto 8000
save ${DUMP_PATH}zero.bin 0000 00ff
save ${DUMP_PATH}vram.bin 3700 3fff
save ${DUMP_PATH}ram.bin  0000 3fff
quit
EOF
