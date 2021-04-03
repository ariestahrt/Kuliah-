#!/bin/bash

PATH_TO="/home/ariestaheart/Sisop/soal-shift-sisop-modul-1-C04-2021/soal3"
cd PATH_TO
password=`date +'%m%d%Y'`

for d in */ ; do
    zip -r -P "$password" Koleksi.zip . -i "$d*"
    rm -rf "$d"
done