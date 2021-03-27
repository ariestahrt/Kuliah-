#!/bin/bash
# Unzip : unzip -P {PWD} Koleksi.zip

password=`date +'%m%d%Y'`

for d in */ ; do
    echo "$d"
    zip -r -P "$password" Koleksi.zip . -i "$d*"
    rm -rf "$d"
done
