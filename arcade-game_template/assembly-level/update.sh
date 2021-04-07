#!/bin/sh


# Will be macros.asm, firmware.asm, etc...
Dependencies="misc/eater.asm"

mkdir -v dependencies

# Download all files from ucsbieee/arcade/main/assembly-level/src
for file in $Dependencies; do
    path="dependencies/"`dirname $file`
    filename=`basename $file`
    mkdir -pv ${path}
    curl -LJO https://raw.githubusercontent.com/ucsbieee/arcade/main/assembly-level/src/$file
    mv $filename $path/$filename
done
