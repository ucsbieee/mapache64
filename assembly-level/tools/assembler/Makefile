
# Makefile #


# === Variables === #

# File extensions
IN_EXTEN	= asm
OUT_EXTEN	= bin

# VASM Config
VASM		=
VASM_FLAGS	= -Fbin -dotdir

# Path of VASM depends on User OS
ifeq (${OS},Windows_NT)
	# If Windows
	VASM = vasm6502/win/win10/vasm6502_oldstyle
else
	UNAME_S := ${shell uname -s}
	ifeq (${UNAME_S},Darwin)
		# If MacOS
		VASM = vasm6502/mac/vasm6502_oldstyle
	endif
	ifeq (${UNAME_S},Linux)
		# If Linux
		VASM = vasm6502/linux/vasm6502_oldstyle
	endif
endif



# === Targets === #

bad-syntax:
	@echo "[Error: Bad Syntax] - Correct usage is \"make <filename>.${OUT_EXTEN}\"."

%.${OUT_EXTEN}: %.${IN_EXTEN}
	rm -fv $@
	${VASM} ${VASM_FLAGS} -o $*.${OUT_EXTEN} $^

clean:
	rm -fv *.${OUT_EXTEN}
	rm -fv **/*.${OUT_EXTEN}
