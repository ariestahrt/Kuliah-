#!/bin/bash

'''
Praktikum Modul 1
Sistem Operasi 2021

Kelompok C04

I Kadek Agus Ariesta Putra  05111940000105
Muhammad Arif Faizin        05111940000060
Ahmad Lamaul Farid          05111940000134

SOAL 1
'''

# Arraylist untuk menyimpan data
error_msg_list=()
error_msg_count=()

user_list=()
user_list_error_count=()
user_list_info_count=()

while read line; do
    username=$(echo "$line" | grep -o -P '(?<=\().*(?=\))')
    is_info=$(echo $line | grep -c "INFO")

    jenis="ERROR"
    if [[ is_info -gt 0 ]]; then
        jenis="INFO"
    fi

    pesan=$(echo $line | grep -oP "${jenis}\s*\K.*(?= \(${username}\))")

    # Check dulu usernya udah ada apa belum di array user_list
    index_user=0
    user_sudah_ada=0
    for item in "${user_list[@]}"; do
        if [[ $username == $item ]]; then
            user_sudah_ada=1
            break
        fi
        index_user=$(($index_user+1))
    done

    # Kalau belum ada masukin ke array
    if [[ $user_sudah_ada == 0 ]]; then
        user_list+=("$username")
        user_list_error_count[index_user]=0
        user_list_info_count[index_user]=0
    fi
    
    if [[ $jenis == "ERROR" ]]; then
        # Simpan total error ke user_list_error_count
        user_list_error_count[index_user]=$((${user_list_error_count[$index_user]}+1))

        index=0
        sudah_ada=0
        # Menghitung semua error dan pesannya muncul berapa kali
        for item in "${error_msg_list[@]}"; do
            if [[ $pesan == $item ]]; then
                sudah_ada=1
                break
            fi
            index=$(($index+1))
        done
        
        if [[ $sudah_ada == 1 ]]; then
            # Sudah ada
            error_msg_count[index]=$((${error_msg_count[$index]}+1))
        else
            # Belum Ada
            error_msg_list+=("$pesan")
            error_msg_count[index]=$((${error_msg_count[$index]}+1))
        fi
    else
        # echo "TEST"
        user_list_info_count[index_user]=$((${user_list_info_count[$index_user]}+1))
    fi

done <syslog.log

# B Menampilkan semua error dan pesannya muncul berapa kali

echo "Error,Count" > error_message.csv

for ((i = 0; i < ${#error_msg_list[@]}; i=i+1)) do
    echo "${error_msg_list[$i]},${error_msg_count[$i]}" >> error_message.csv
    echo -n "${error_msg_list[$i]} : "
    echo "${error_msg_count[$i]}"
done

# C Menampilkan total error dan info setiap user

echo "Username,INFO,ERROR" > user_statistic.csv

for ((i = 0; i < ${#user_list[@]}; i=i+1)) do
    echo "${user_list[$i]},${user_list_info_count[$i]},${user_list_error_count[$i]}" >> user_statistic.csv
    echo "username : ${user_list[$i]} | INFO : ${user_list_info_count[$i]} | ERROR : ${user_list_error_count[$i]}"
done
