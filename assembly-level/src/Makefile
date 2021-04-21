
# Makefile #


# === Variables === #

# File extensions
IN_EXTEN	= asm
OUT_EXTEN	= bin

# Target
MAIN		= arcade

# VASM Config
VASM_PATH	= ../tools/assembler/vasm6502/
VASM_FLAGS	= -Fbin -dotdir -wdc02

# Path of VASM depends on User OS
VASM =
ifeq (${OS},Windows_NT)
# If Windows
	VASM = ${VASM_PATH}win/win10/vasm6502_oldstyle
else
	UNAME_S := ${shell uname -s}
	ifeq (${UNAME_S},Darwin)
# If MacOS
		VASM = ${VASM_PATH}mac/vasm6502_oldstyle
	endif
	ifeq (${UNAME_S},Linux)
# If Linux
		VASM = ${VASM_PATH}linux/vasm6502_oldstyle
	endif
endif

# Dump Dir
DUMP_PATH	= dump/

# === Targets === #

all: clean arcade dump

arcade:
	mkdir -p ${DUMP_PATH}
	${VASM} ${VASM_FLAGS} -o ${DUMP_PATH}${MAIN}.${OUT_EXTEN} ${MAIN}.${IN_EXTEN}

dump: arcade
	mkdir -p ${DUMP_PATH}
	py65mon < py65.in

clean:
	rm -f ${MAIN}.${OUT_EXTEN}
	rm -rf ${DUMP_PATH}
