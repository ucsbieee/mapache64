
# Define a list of all C and Assemnbly source files
CXX_SRC = main.c
ASM_SRC =
HEADERS =


# List of PNG images used for patterns
IMAGES =


# Where the intermediate-stage Assembly/object files will be saved
BUILD_DIR = build

# Where the created binaries are stored
DUMP_DIR = dump



# ============== DO NOT EDIT BELOW THIS LINE ============== #

.PHONY: all dump run verify clean

MACHINE = mapache64

# Instruct that compilation and assembly should be done using cc65/ca65 and
# specify some required flags (https://cc65.github.io/doc/customizing.html#toc9)
AS = ca65
ASFLAGS = --cpu 65c02

CC = cc65
CFLAGS = --cpu 65c02 -t none -Oi

PYTHON = python3

CXX_BIN = $(addprefix ${BUILD_DIR}/,$(CXX_SRC:.c=.c.o))
ASM_BIN = $(addprefix ${BUILD_DIR}/,$(ASM_SRC:.s=.s.o)) ${BUILD_DIR}/backend/game_header.s.o

RESOURCE_DIR = ${BUILD_DIR}/resources
RESOURCES = $(addprefix ${RESOURCE_DIR}/,$(IMAGES:.png=.pat))

LIB_FILES = $(shell find backend/lib -type f)


# Where the flashable binaries will be saved
MEMORY_DIR = ${BUILD_DIR}/memory
MEMORY_FILES = ${MEMORY_DIR}/${MACHINE}_fw.bin ${MEMORY_DIR}/${MACHINE}_io.bin ${MEMORY_DIR}/${MACHINE}_rom.bin

DUMP_FILES = ${DUMP_DIR}/firmware.bin ${DUMP_DIR}/rom.bin ${DUMP_DIR}/vectors.bin
RUN_FILES = ${DUMP_DIR}/final.bin ${DUMP_DIR}/ram.bin ${DUMP_DIR}/vram.bin ${DUMP_DIR}/zeros.bin

# Entire address space
OUTPUT = ${DUMP_DIR}/${MACHINE}.bin

# By default (with no build target argument, i.e. `make`), build everything and
# run the py65 simulator
all: clean verify dump

dump: ${DUMP_FILES}

images: ${RESOURCES}

# Split the unified memory map into constituent memory sections
${DUMP_DIR}/firmware.bin: ${OUTPUT}
	@dd if=${OUTPUT} bs=$(shell echo "ibase=16;5000"|bc) skip=1 2> /dev/null | dd bs=$(shell echo "ibase=16;2000"|bc) count=1 2> /dev/null > $@
	@echo "Created $@"

${DUMP_DIR}/rom.bin: ${OUTPUT}
	@dd if=${OUTPUT} bs=$(shell echo "ibase=16;8000"|bc) skip=1 2> /dev/null | dd bs=$(shell echo "ibase=16;8000"|bc) count=1 2> /dev/null > $@
	@echo "Created $@"

${DUMP_DIR}/vectors.bin: ${OUTPUT}
	@dd if=${OUTPUT} bs=$(shell echo "ibase=16;FFFA"|bc) skip=1 2> /dev/null | dd bs=$(shell echo "ibase=16;6"|bc) count=1 2> /dev/null > $@
	@echo "Created $@"

${RESOURCE_DIR}/%.pat: %.png
	@mkdir -p $(dir $@)
	@${PYTHON} backend/pattern_converter.py $< $@
	@echo "Created \"$@\" from \"$<\""

# Verify newly generated firmware code matches the starter code
verify: ${DUMP_DIR}/firmware.bin
	@mkdir -p .firmware_hd_temp
	@xxd -p -c 16 backend/firmware.bin > .firmware_hd_temp/vanilla.hex
	@xxd -p -c 16 ${DUMP_DIR}/firmware.bin > .firmware_hd_temp/curr.hex
	@diff .firmware_hd_temp/vanilla.hex .firmware_hd_temp/curr.hex && echo "SUCCESS: Firmware matches"
	@rm -rf .firmware_hd_temp

# Run the simulator
run ${RUN_FILES}: ${OUTPUT} ${DUMP_DIR}/vectors.bin
	@mkdir -p ${DUMP_DIR}
	@dos2unix backend/run.sh >/dev/null 2>&1
	./backend/run.sh ${OUTPUT} ${DUMP_DIR}/vectors.bin ${DUMP_DIR}


# Combine the three binaries output by ld65 into one unified memory map for py65
${OUTPUT}: ${MEMORY_DIR}/
	@mkdir -p ${DUMP_DIR}
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=$(shell echo "ibase=16;5000"|bc) 2> /dev/null
	@cat ${MEMORY_DIR}/${MACHINE}_fw.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=$(shell echo "ibase=16;7000"|bc) 2> /dev/null
	@cat ${MEMORY_DIR}/${MACHINE}_io.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=$(shell echo "ibase=16;8000"|bc) 2> /dev/null
	@cat ${MEMORY_DIR}/${MACHINE}_rom.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=$(shell echo "ibase=16;10000"|bc) 2> /dev/null
	@echo "Created $@"

# Build the three different binaries (ROM, FPGA ROM, IO area)
${MEMORY_DIR}/: ${CXX_BIN} ${ASM_BIN}
	@rm -rf $@
	@mkdir -p build/.temp_memory
	ld65 -C backend/${MACHINE}.cfg -m ${BUILD_DIR}/build.map \
	    ${ASM_BIN} \
	    ${CXX_BIN} \
	    ${LIB_FILES} \
	    backend/${MACHINE}.lib \
	    -o build/.temp_memory/${MACHINE}
	mv build/.temp_memory $@


# Override the default/implicit *.c compilation rule to use the cc65/ca65 syntax
${BUILD_DIR}/%.c.o: %.c ${HEADERS}
	@mkdir -p $(dir $@)
	$(CC) -I backend/headers $(CFLAGS) $< -o ${BUILD_DIR}/$(<:.c=.c.s)
	$(AS) $(ASFLAGS) ${BUILD_DIR}/$(<:.c=.c.s) -o $@

# Override the default/implicit *.s assembly rule to use the ca65 syntax
${BUILD_DIR}/%.s.o: %.s ${RESOURCES}
	@mkdir -p $(dir $@)
	$(AS) --bin-include-dir ${RESOURCE_DIR} $(ASFLAGS) $< -o $@

# Purge all built files
clean:
	rm -rf ${BUILD_DIR}/ dump/
