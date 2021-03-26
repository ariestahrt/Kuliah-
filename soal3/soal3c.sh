#!/bin/bash

current_date=`date +'%d-%m-%Y'`
yesterday_date=`date -d "yesterday" +'%d-%m-%Y'`
echo "[!] Current date : $current_date"
echo "[!] Yesterday date : $yesterday_date"

# Fungsi donlot neko

download_nekopoi(){
    host="https://loremflickr.com"
    endpoint=`curl -s -i "https://loremflickr.com/320/240/kitten" | grep "location" | awk -F ': ' '{print $2}' | tr -d '\r'`
    to_download="${host}${endpoint}"
    filename=`echo "$endpoint" | awk -F '/' '{print $4}'`

    path_save="Kucing_$current_date"

    echo "Download : $to_download"
    wget $to_download -P "$path_save"

    echo "Download : $to_download">>"$path_save/Foto.log"

    if [[ $(cat "$path_save/Foto.log" | grep -c "${to_download}") -gt 1 ]]; then
        # Kalau kucingnya udah kedownload, maka hapus lagi kucingnya
        rm "$path_save/$filename"
    else
        # Kalau kucingnya belum kedownload, maka tinggal ganti nama aja
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

# Fungsi donlot kelinci
download_kelinci(){
    host="https://loremflickr.com"
    endpoint=`curl -s -i "https://loremflickr.com/320/240/bunny" | grep "location" | awk -F ': ' '{print $2}' | tr -d '\r'`
    to_download="${host}${endpoint}"
    filename=`echo "$endpoint" | awk -F '/' '{print $4}'`

    path_save="Kelinci_$current_date"

    echo "Download : $to_download"
    wget $to_download -P "$path_save"

    echo "Download : $to_download">>"Kelinci_${current_date}/Foto.log"

    if [[ $(cat "$path_save/Foto.log" | grep -c "${to_download}") -gt 1 ]]; then
        # Kalau kelincinya udah kedownload, maka hapus lagi kucingnya
        rm "$path_save/$filename"
    else
        # Kalau kelincinya belum kedownload, maka tinggal ganti nama aja
        file_number=`ls $path_save | grep -c "Koleksi"`
        file_number=`echo "$file_number + 1" | tr -d $'\r' | bc -l`

        if [ 1 -eq "$(echo "${file_number} < 10" | bc)" ]
        then
            file_number="0${file_number}"
        fi
        
        save_file_name="Koleksi_${file_number}.jpg"

        mv "$path_save/$filename" "$path_save/$save_file_name"
    fi
}

# Get yesterday file

isyesterday_kucing=`ls -l | grep "$yesterday_date" | grep -c "Kucing"`
echo "Is Yesterday Kucing" $isyesterday_kucing

if [[ $isyesterday_kucing -eq 0 ]]; then
    if [[ ! -d "Kucing_$current_date" ]]; then
        # File not exist
        echo "[!] Making directory Kucing_$current_date"
        mkdir "Kucing_$current_date"
    else
        # File arleady exist
        echo "[!] Directory Kucing_$current_date already exist"
    fi
    # Then download neko
    for ((num=1; num<=23; num=num+1))
    do
        download_nekopoi
    done
else
    if [[ ! -d "Kelinci_$current_date" ]]; then
        # File not exist
        echo "[!] Making directory Kelinci_$current_date"
        mkdir "Kelinci_$current_date"
    else
        # File arleady exist
        echo "[!] Directory Kelinci_$current_date already exist"
    fi

    # Then download Kelinci
    for ((num=1; num<=23; num=num+1))
    do
        download_kelinci
    done
fi
