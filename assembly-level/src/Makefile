# Instruct that compilation and assembly should be done using cc65/ca65 and
# specify some required flags (https://cc65.github.io/doc/customizing.html#toc9)
AS = ca65
ASFLAGS = --cpu 65c02

CC = cc65
CFLAGS = --cpu 65c02 -t none -O

# Where the intermediate-stage Assembly/object files will be saved
BUILD_DIR = build
DUMP_DIR = dump

# Unknown usage
BIN_PREFIX =

# Define a list of all C and Assemnbly source files, as well as the location to
# save the assembled object files
CXX_SRC = vram.c Q9_6.c
CXX_BIN = $(addprefix ${BUILD_DIR}/o/${BIN_PREFIX},$(CXX_SRC:.c=.o))

ASM_SRC = crt0.s vectors.s io.s fw_headers.s stop.s arcade_zero_page.s reset.s verify_firmware.s
ASM_BIN = $(addprefix ${BUILD_DIR}/o/${BIN_PREFIX},$(ASM_SRC:.s=.o))

# List of files in the for_template directory
FOR_TEMPLATE_FILES_IN = $(shell find for_template -type f)
FOR_TEMPLATE_FILES_OUT = $(subst for_template/, template/, $(FOR_TEMPLATE_FILES_IN))

# Path to a template cc65 linker library
SUPERVISION_LIB = /usr/share/cc65/lib/supervision.lib

# Previx name for all flashable binary files
MACHINE = arcade

.PHONY: all template clean

# By default (with no build target argument, i.e. `make`), build the template
# and set it up in a new directory
all: clean template

template: template/backend/firmware.bin

template/%: for_template/%
	@mkdir -p $(dir $@)
	cp -r $< $@

template/backend/headers/: $(shell find headers -type f)
	@mkdir -p template
	cp -r headers/ $@

template/backend/lib/: ${CXX_BIN} ${ASM_BIN}
	@mkdir -p template
	cp -r ${BUILD_DIR}/o/ $@

template/backend/arcade.lib: ${BUILD_DIR}/arcade.lib
	@mkdir -p template
	cp -r ${BUILD_DIR}/arcade.lib $@

template/backend/arcade.cfg: arcade.cfg
	@mkdir -p template
	cp -r arcade.cfg $@

template/backend/firmware.bin: ${FOR_TEMPLATE_FILES_OUT} template/backend/headers/ template/backend/lib/ template/backend/arcade.lib template/backend/arcade.cfg
# TO DO: Fix template/Makefile clock skew
	@sleep 1
	make -C template/ dump &&\
	cp template/${DUMP_DIR}/firmware.bin $@ &&\
	make -C template/ clean


# Create the arcade machine libraries
${BUILD_DIR}/arcade.lib:
	@mkdir -p ${BUILD_DIR}
	cp ${SUPERVISION_LIB} $@


# Compile .c source files
${BUILD_DIR}/o/${BIN_PREFIX}%.o: backend_src/%.c $(shell find headers -type f)
	@mkdir -p ${BUILD_DIR}/s
	$(CC) -I headers $(CFLAGS) $< -o ${BUILD_DIR}/s/$(notdir $(<:.c=.s))
	@mkdir -p ${BUILD_DIR}/o
	$(AS) $(ASFLAGS) ${BUILD_DIR}/s/$(notdir $(<:.c=.s)) -o $@

# Compile .s source files
${BUILD_DIR}/o/${BIN_PREFIX}%.o: backend_src/%.s
	@mkdir -p ${BUILD_DIR}/o
	$(AS) $(ASFLAGS) $^ -o $@

# Purge all built files
clean:
	rm -rf ${BUILD_DIR} template
