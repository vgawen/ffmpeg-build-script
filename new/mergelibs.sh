#!/bin/sh

#  mergelibs.sh
#  
#
#  Created by dd on 1/21/24.
#  

dir1=$1
dir2=$2
destdir=$3
echo $dir1
echo $dir2
echo $destdir

execute() {
  echo "$ $*"

  OUTPUT=$("$@" 2>&1)

  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    echo "$OUTPUT"
    echo ""
    echo "Failed to Execute $*" >&2
    exit 1
  fi
}

if [ ! -d "$dir1" ] || [ ! -d "$dir2" ] || [ ! -d "$destdir" ]; then
    echo "wrong params"
    exit
fi

for file1 in $dir1/*; do
    if [ -f "$file1" ] && [ ! -L "$file1" ] && [ $(echo "$file1" | grep '\.dylib$') ]; then
        filename=$(basename $file1)
        echo $file1
        
        file2="$dir2/$filename"
        outputfile="$destdir/$filename"
        echo $file2
        echo $outputfile
        if [ -f "$file2" ]; then
            execute lipo "$file1" "$file2" -create -output "$outputfile"
        else
            cp -p "$file1" "$outputfile"
            echo "no arm64 - $file1"
        fi
        
    fi
done

