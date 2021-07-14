from typing import List

from read_vcd import read_clocked_vcd
from read_vcd import read_vcd

import numpy as np
np.set_printoptions(threshold=np.inf)

import itertools as IT
from PIL import Image

TOP_MODULE_NAME = 'top_tb.top'
SIGNAL_NAMES = ['r','g','b','hsync']
CLOCK_NAME = 'clk'

signal_paths = ["{}.{}".format(TOP_MODULE_NAME,signal_name) for signal_name in SIGNAL_NAMES]
clock_path = "{}.{}".format(TOP_MODULE_NAME,CLOCK_NAME)

if __name__=="__main__":
    import sys
    from pathlib import Path
    if len(sys.argv) != 3:
        print("USAGE: {} dump.vcd out.png".format(sys.argv[0]))
    else:
        vcd_path = sys.argv[1]
        print("Loading \"{}\"...".format(str(vcd_path)))
        r,g,b,hsync = read_clocked_vcd(vcd_path,signal_paths,clock_path)
        print("Finished loading.")

        print("Creating PNG...")
        linestart = []
        lineend = []

        i = 0
        while True:
            try:
                if hsync[i] == 1:
                    lineend.append(i)
                    while hsync[i] == 1:
                        i += 1
                    linestart.append(i)
                i += 1
            except IndexError:
                break

        while lineend[0] < linestart[0]:
            lineend.pop(0)
        while len(linestart) < len(lineend):
            len(lineend).pop()

        image_array = []

        i = 0
        rgb_array = np.stack( (r,g,b), axis=1 ) * 64
        while i < len(lineend):
            row = rgb_array[linestart[i]:lineend[i]]
            image_array.append(row)
            i += 1

        image = Image.fromarray(np.uint8(image_array))
        print("Finished creating PNG.")
        image.save(str(sys.argv[2]))
        print("Saved output as \"{}\".".format(str(sys.argv[2])))
