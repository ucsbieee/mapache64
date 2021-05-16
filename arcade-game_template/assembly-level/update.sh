#!/usr/bin/env bash

# Files to download
Dependencies="
firmware/header.asm
firmware/interrupts.asm
firmware/subroutines/add.asm
firmware/subroutines/divide.asm
firmware/subroutines/multiply.asm
firmware/subroutines/subtract.asm
firmware/subroutines/transfer_mem.asm
fake_io.asm
labels.asm
macros.asm
options.asm
rom.asm
arcade.asm
"

ASSEMBLY_SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Assembly src directory: $ASSEMBLY_SRC_DIR"

DEPENDENCY_DIR=$ASSEMBLY_SRC_DIR"/dependencies"
echo "Dependency directory: $DEPENDENCY_DIR"

# Download all files from ucsbieee/arcade/main/assembly-level/src
for file in $Dependencies; do
    path=$DEPENDENCY_DIR"/"`dirname $file`
    filename=`basename $file`
    mkdir -pv ${path}
    curl -LJO https://raw.githubusercontent.com/ucsbieee/arcade/main/assembly-level/src/$file
    mv $filename $path/$filename
    echo "Downloaded $filename to $path"
done
