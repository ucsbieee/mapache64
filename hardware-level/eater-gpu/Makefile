
# Makefile #

###############################################################################

# TOOL INPUT
EXE = top
DUMP = dump.vcd

###############################################################################

# TOOLS
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave
# TOOL OPTIONS
COFLAGS = -g2012
SFLAGS =


###############################################################################


#MAKE DIRECTIVES
all: clean ${EXE}

${EXE} : ${EXE}.tb.v
	$(COMPILER) ${COFLAGS} -o $@ $^

run: $(EXE)
	$(SIMULATOR) $(SFLAGS) $^

display: $(EXE)
	$(VIEWER) $(DUMP) &

clean:
	rm -f $(EXE) $(DUMP)
