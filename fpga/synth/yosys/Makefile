
all: clean build/synth.json

build/%.mem:
	@mkdir -p build
	cp ../../rom/$@ $@

sv2v:
	@mkdir -p build
	cd ../sv2v && make

build/synth.json: sv2v build/firmware.mem build/vectors.mem build/pmc.mem
	cd build && yosys -l yosys.log -p 'tcl ../yosys.tcl'

clean:
	rm -rf build
