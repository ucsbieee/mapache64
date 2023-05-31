
all: clean build/synth.json

build/%.mem:
	@mkdir -p build
	cp ../../rom/$@ $@

build/sv2v.v:
	@mkdir -p build
	cd build && sv2v \
	--write=../$@ \
	../../../fusesoc_libraries/nes_controller_interface/rtl/nes_controller_interface.v \
	../../../rtl/mapache64_pkg.sv \
	../../../rtl/address_bus.sv \
	../../../rtl/firmware.sv \
	../../../rtl/gpu/object_scanline.sv \
	../../../rtl/gpu/foreground.sv \
	../../../rtl/gpu/background.sv \
	../../../rtl/gpu/text.sv \
	../../../rtl/gpu/video_timing.sv \
	../../../rtl/gpu/gpu.sv \
	../../../rtl/top.sv

build/synth.json: build/sv2v.v build/firmware.mem build/vectors.mem build/pmc.mem
	cd build && yosys -l yosys.log -p 'tcl ../yosys.tcl'

clean:
	rm -rf build
