#!/bin/bash
# Unzip : password=`date +'%m%d%Y'` && unzip -P $password Koleksi.zip && rm Koleksi.zip

password=`date +'%m%d%Y'`

for d in */ ; do
    zip -r -P "$password" Koleksi.zip . -i "$d*"
    rm -rf "$d"
done
