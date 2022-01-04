#!/usr/bin/env python3

import sys
from PIL import Image
import numpy as np
from datetime import datetime


# Errors
class BadImageFormat: pass


# MAIN
if __name__ == '__main__':

    filein = ""
    fileout = ""

    try:
        filein = sys.argv[1]
        fileout = sys.argv[2]
    except IndexError:
        print("[Argument error]: filein and fileout not given")
        exit(1)

    # Load Image
    im = Image.open(filein).convert('RGB')
    im_width, im_height = im.size
    if ( im_width != 128 or im_height != 64 ):
        print("[Image Error]: Incorrect image size")
        exit(1)
    im_data = np.asarray(im.getdata())

    outfile = open( fileout, "w" )

    outfile.write("\n// Generated from " + filein + "\n")
    outfile.write("// " + datetime.now().strftime("%m/%d/%Y %H:%M:%S") + "\n\n")

    outfile.write("// Character Pattern Memory\n")
    outfile.write("const PMC = new Uint8Array([")
    for char in range(0, 128):
        char_x_offset = (char*8) % 128
        char_y_offset = (char//16) * 8
        outfile.write("\n")
        for pattern_y in range(0, 8):
            outfile.write("    0b")
            for pattern_x in range(0, 8):
                offset = char_x_offset + pattern_x + (char_y_offset + pattern_y)*128
                pixel = im_data[offset]
                pixel_bit = (pixel[0] | pixel[2] | pixel[2]) != 0
                outfile.write(str(int(pixel_bit)))
            if (not (char == 127 and pattern_y == 7)):
                outfile.write(",")
            outfile.write("\n")
    if (char ==127):
        outfile.write("]);\n")
