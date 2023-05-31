
set top top
set name ucsbieee_mapache64_top_1.0.0

yosys -import
plugin -i systemverilog

yosys -import

read_verilog ../../sv2v/build/sv2v.v

synth -top top
write_json synth.json
