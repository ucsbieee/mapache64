
# Makefile #


# === Variables === #

# File extensions
IN_EXTEN	= asm
OUT_EXTEN	= bin

# VASM Config
VASM_PATH	= vasm6502/
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



# === Targets === #

bad-syntax:
	@echo "[Error: Bad Syntax] - Correct usage is \"make <filename>.${OUT_EXTEN}\"."

%.${OUT_EXTEN}: *.${IN_EXTEN}
	rm -fv $@
	${VASM} ${VASM_FLAGS} -o $*.${OUT_EXTEN} $*.${IN_EXTEN}

clean:
	rm -fv *.${OUT_EXTEN}
	rm -fv **/*.${OUT_EXTEN}
