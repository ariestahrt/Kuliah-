#!/bin/bash

current_date=`date +'%d-%m-%Y'`

echo "[!] Current date : $current_date"

if [[ ! -d "$current_date" ]]; then
    # File not exist
    echo "[!] Making directory $current_date"
    mkdir "$current_date"
else
    # File arleady exist
    echo "[!] Directory $current_date already exist"
fi

download_nekopoi(){
    neko_host="https://loremflickr.com"
    neko_endpoint=`curl -s -i "https://loremflickr.com/320/240/kitten" | grep "location" | awk -F ': ' '{print $2}' | tr -d '\r'`
    neko_to_download="${neko_host}${neko_endpoint}"
    neko_filename=`echo "$neko_endpoint" | awk -F '/' '{print $4}'`

    echo "Download : $neko_to_download"
    wget $neko_to_download -P "$current_date"

    echo "Download : $neko_to_download">>"${current_date}/Foto.log"

    if [[ $(cat "${current_date}/Foto.log" | grep -c "${neko_to_download}") -gt 1 ]]; then
        # Kalau kucingnya udah kedownload, maka hapus lagi kucingnya
        rm "$current_date/$neko_filename"
    else
        # Kalau kucingnya belum kedownload, maka tinggal ganti nama aja
        neko_number=`ls $current_date | grep -c "Koleksi"`
        neko_number=`echo "$neko_number + 1" | tr -d $'\r' | bc -l`

        if [ 1 -eq "$(echo "${neko_number} < 10" | bc)" ]
        then
            neko_number="0${neko_number}"
        fi
        
        neko_save_file_name="Koleksi_${neko_number}.jpg"

        # echo $neko_save_file_name
        mv "$current_date/$neko_filename" "$current_date/$neko_save_file_name"
    fi
}

for ((num=1; num<=23; num=num+1))
do
    download_nekopoi
done
