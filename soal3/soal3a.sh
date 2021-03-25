#!/bin/bash
for ((num=1; num<=23; num=num+1))
do
    if [ $num -lt 10 ]
    then
        wget https://loremflickr.com/320/240/kitten -O Koleksi_0$num.jpg -a Foto.log
    else
        wget https://loremflickr.com/320/240/kitten -O Koleksi_$num.jpg -a Foto.log
    fi
done