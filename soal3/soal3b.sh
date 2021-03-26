#!/bin/bash 

currDir=`pwd`
DATE=$(date '+%d-%m-%Y')
if [ ! -d $currDir/$DATE ]; then
	mkdir $currDir/$DATE
fi

for ((num=1; num<=23; num=num+1))
do
    if [ $num -lt 10 ]
    then
        wget https://loremflickr.com/320/240/kitten -O $currDir/Koleksi_0$num.jpg -a Foto.log
    else
        wget https://loremflickr.com/320/240/kitten -O $currDir/Koleksi_$num.jpg -a Foto.log
    fi
done

find $currDir -type f -name "*.jpg" -exec mv {} $currDir/$DATE \;
find $currDir -type f -name "*.log" -exec mv {} $currDir/$DATE \;
