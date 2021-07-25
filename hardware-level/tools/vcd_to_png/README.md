
<!-- README.md -->

# VCD to PNG

## Purpose

This will convert the VCD output of a simulated GPU to a PNG.

## Usage

Run with `python vcd_to_png.py {DUMP}.vcd {OUT}.png`.

Be sure the VCD file has the following nets:

```plain
top_tb.top.clk
top_tb.top.r[1:0]
top_tb.top.g[1:0]
top_tb.top.b[1:0]
top_tb.top.hsync
```

(Performance is poor. Could take several minutes depending on size of VCD file.)

## References

* read_vcd comes from [Matthew Dupree](https://iea.ece.ucsb.edu/people/matthew-dupree)
