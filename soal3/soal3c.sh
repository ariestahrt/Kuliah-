#!/bin/bash

current_date=`date +'%d-%m-%Y'`
yesterday_date=`date -d "yesterday" +'%d-%m-%Y'`
echo "[!] Current date : $current_date"
echo "[!] Yesterday date : $yesterday_date"

# Fungsi donlot

download_foto(){
    animal=$1
    hewan=$2
    mkdir "${hewan}_$current_date"

    host="https://loremflickr.com"
    endpoint=`curl -s -i "https://loremflickr.com/320/240/${animal}" | grep "location" | awk -F ': ' '{print $2}' | tr -d '\r'`
    to_download="${host}${endpoint}"
    filename=`echo "$endpoint" | awk -F '/' '{print $4}'`

    path_save="${hewan}_$current_date"

    echo "Download : $to_download"
    wget $to_download -P "$path_save"

    echo "Download : $to_download">>"$path_save/Foto.log"

    if [[ $(cat "$path_save/Foto.log" | grep -c "${to_download}") -gt 1 ]]; then
        # Kalau hewannya udah kedownload, maka hapus lagi hewannya
        rm "$path_save/$filename"
    else
        # Kalau hewannya belum kedownload, maka tinggal ganti nama aja
        file_number=`ls $path_save | grep -c "Koleksi"`
        file_number=`echo "$file_number + 1" | tr -d $'\r' | bc -l`

        if [ 1 -eq "$(echo "${file_number} < 10" | bc)" ]
        then
            file_number="0${file_number}"
        fi
        
        save_file_name="Koleksi_${file_number}.jpg"

        # echo $save_file_name
        mv "$path_save/$filename" "$path_save/$save_file_name"
    fi
}

# Get yesterday file

isyesterday_kucing=`ls -l | grep "$yesterday_date" | grep -c "Kucing"`

if [[ $isyesterday_kucing -eq 0 ]]; then
    # Then download neko
    for ((num=1; num<=23; num=num+1))
    do
        download_foto "kitten" "Kucing"
    done
else
    # Then download neko
    for ((num=1; num<=23; num=num+1))
    do
        download_foto "bunny" "Kelinci"
    done
fi
