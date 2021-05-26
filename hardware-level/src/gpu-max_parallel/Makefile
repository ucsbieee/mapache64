
# Makefile #

###############################################################################

# TOOL INPUT
EXE	= top
DUMP	= dump.vcd
WAVES	= waves.gtkw

###############################################################################

# TOOLS
COMPILER	= iverilog
SIMULATOR	= vvp
VIEWER		= gtkwave

# TOOL OPTIONS
COFLAGS	=
SFLAGS	=


###############################################################################


#MAKE DIRECTIVES
all: clean ${EXE}

${EXE} : ${EXE}.tb.v
	${COMPILER} ${COFLAGS} -o $@ $^

run: ${EXE}
	${SIMULATOR} ${SFLAGS} $^

display: ${EXE}
	${VIEWER} ${WAVES} || ${VIEWER} ${DUMP} &

clean:
	rm -f ${EXE} ${DUMP}
