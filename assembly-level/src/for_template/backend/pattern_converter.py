#!/usr/bin/env python3

import sys
from PIL import Image
import numpy as np


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
    if ( im_width != 8 or im_height != 8 ):
        print("[Image Error]: Incorrect image size")
        exit(1)
    im_data = np.asarray(im.getdata())
    pixels = ""
    for p0, p1, p2 in im_data:
        shade = p0 | p1 | p2
        if shade == 0xff:
            pixels += "11"
        elif shade >= 0x7f:
            pixels += "10"
        elif shade >= 0x3f:
            pixels += "01"
        else:
            pixels += "00"

    # array of binary strings
    binary_string__of_bytes = [pixels[i:i+8] for i in range(0, len(pixels), 8)]

    data = bytearray([int(binary_string__of_bytes[i],2) for i in range(0,16)])

    # Load File
    outfile = open( fileout, "wb" )
    outfile.write(data)
