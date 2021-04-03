#!/bin/bash

PATH_TO="/home/ariestaheart/Sisop/soal-shift-sisop-modul-1-C04-2021/soal3"
current_date=`date +'%d-%m-%Y'`

echo "[!] Current date : $current_date"

mkdir "${PATH_TO}/$current_date"

download_neko(){
    neko_host="https://loremflickr.com"
    neko_endpoint=`curl -s -i "https://loremflickr.com/320/240/kitten" | grep "location" | awk -F ': ' '{print $2}' | tr -d '\r'`
    neko_to_download="${neko_host}${neko_endpoint}"
    neko_filename=`echo "$neko_endpoint" | awk -F '/' '{print $4}'`

    echo "Download : $neko_to_download"
    wget $neko_to_download -P "${PATH_TO}/$current_date"

    echo "Download : $neko_to_download">>"${PATH_TO}/${current_date}/Foto.log"

    if [[ $(cat "${PATH_TO}/${current_date}/Foto.log" | grep -c "${neko_to_download}") -gt 1 ]]; then
        # Kalau kucingnya udah kedownload, maka hapus lagi kucingnya
        rm "${PATH_TO}/$current_date/$neko_filename"
    else
        # Kalau kucingnya belum kedownload, maka tinggal ganti nama aja
        neko_number=`ls "${PATH_TO}/$current_date" | grep -c "Koleksi"`
        neko_number=`echo "$neko_number + 1" | tr -d $'\r' | bc -l`

        if [ 1 -eq "$(echo "${neko_number} < 10" | bc)" ]
        then
            neko_number="0${neko_number}"
        fi
        
        neko_save_file_name="Koleksi_${neko_number}.jpg"

        # echo $neko_save_file_name
        mv "${PATH_TO}/$current_date/$neko_filename" "${PATH_TO}/$current_date/$neko_save_file_name"
    fi
}

>"${PATH_TO}/${current_date}/Foto.log"
for ((num=1; num<=23; num=num+1))
do
    download_neko
done
