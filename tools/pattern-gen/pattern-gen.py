#!python

import getopt, sys, enum
from PIL import Image
import numpy as np

# Options
options = "f:p:d:a:"
long_options = ["file:","platform:", "destination:", "address:"]

# Option states
filename = ""
platform = ""
destination = ""
pma = -1

# Errors
class BadImageFormat: pass

# Variables
pattern = []
outfile = None

# Handle Platforms
def handle_JavaScript():
    if pma == -1:
        print("[ERROR]: No pattern memory address given.")
        exit(1)
    for i in range(16):
        outfile.write( destination + "[" )
        if (pma == 0 and i < 10 ) or (pma == 6 and i < 4):
            outfile.write(" ")
        outfile.write( str(i+(16*pma)) )
        outfile.write( "] = 0b"+pattern[i]+";" )
        if ( i & 1 ):
            outfile.write( "\n" )
        else:
            outfile.write( " " )

def handle_Assembly():
    # [ To Do ]
    # Convert "pattern" to correct format for assembly
    # print(pattern)
    # Write to outfile with outfile.write("")
    print("[ERROR]: Not yet suppoted.")
    exit(1)

# Read Options
try:
    arguments, values = getopt.getopt(sys.argv[1:], options, long_options)
    for currentarg, currentvalue in arguments:
        if currentarg in ("-f","--file"):
            filename = currentvalue
        elif currentarg in ("-p","--platform"):
            platform = currentvalue
        elif currentarg in ("-d","--destination"):
            destination = currentvalue
        elif currentarg in ("-a","--address"):
            pma = int(currentvalue)

except getopt.error as err:
    print( str(err) )

# Chunks List
# https://www.geeksforgeeks.org/break-list-chunks-size-n-python/
def divide_chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]




# MAIN

# Load Image
im = Image.open(filename).convert('RGB')
im_width, im_height = im.size
if ( im_width != 8 or im_height != 8 ):
    im_error = BadImageFormat()
    raise err
im_data = np.asarray(im.getdata())
pixels = []
for p0, p1, p2 in im_data:
    shade = p0 | p1 | p2
    if shade == 255:
        pixels.append("11")
    elif shade == 127:
        pixels.append("10")
    elif shade == 63:
        pixels.append("01")
    else:
        pixels.append("00")
pixel_bytes = list(divide_chunks(pixels, 4))
for p0, p1, p2, p3 in pixel_bytes:
    pattern.append( p0+p1+p2+p3 )

print("Image decomposition:")
print(pattern)

# Load File
outfile = open( filename+".out", "w" )

# Handle Platforms
if   ( platform == "JavaScript" ):
    handle_JavaScript()
elif ( platform == "Assembly" ):
    handle_Assembly()
else:
    print( "[ERROR]: Unexpected platform." )
