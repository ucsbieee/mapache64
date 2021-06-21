
# Makefile #

###############################################################################

# TOOL INPUT
EXE	= top
DUMP	= dump.vcd
WAVES	= waves.gtkw

# OUTPUT
IMAGE	= screen.png

###############################################################################

# TOOLS
COMPILER	= iverilog
SIMULATOR	= vvp
VIEWER		= gtkwave
PYTHON		= python
VCD_TO_PNG	= ../../tools/vcd_to_png/vcd_to_png.py

# TOOL OPTIONS
COFLAGS	= -g2012 -I modules/
SFLAGS	=


###############################################################################


#MAKE DIRECTIVES
all: clean ${EXE}

${EXE} : ${EXE}.tb.v
	${COMPILER} ${COFLAGS} -o $@ $^

run: ${EXE}
	${SIMULATOR} ${SFLAGS} $^

png:
	${PYTHON} ${VCD_TO_PNG} ${DUMP} ${IMAGE}

display: ${EXE}
	${VIEWER} ${WAVES} || ${VIEWER} ${DUMP} &

clean:
	rm -f ${EXE} ${DUMP}
