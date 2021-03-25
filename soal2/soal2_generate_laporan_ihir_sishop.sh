#!/bin/bash

index=0

proofit_percentage_max=-999999
proofit_percentage_rid=0

albuquerque_customer_list=()

customer_segment_totaltrx=(0 0 0)
segment_type=("Home Office" "Consumer" "Corporate")

region_total_profit=(0 0 0 0)
region_list=("Central" "East" "South" "West")

check(){
    line=$1
    row_id=$(echo $line | awk -F '\t' '{ print $1 }')
    sales=$(echo $line | awk -F '\t' '{ print $18 }')
    profit=$(echo $line | awk -F '\t' '{ print $21 }')

    city=$(echo $line | awk -F '\t' '{ print $10 }')
    orderdate=$(echo $line | awk -F '\t' '{ print $3 }')
    orderdate_year=$(echo $orderdate | awk -F '-' '{print $3}')

    customer_name=$(echo $line | awk -F '\t' '{ print $7 }')
    customer_segment=$(echo $line | awk -F '\t' '{ print $8 }')

    region=$(echo $line | awk -F '\t' '{ print $13 }')
    cost_price=`echo "$sales - $profit" | tr -d $'\r' | bc -l`
    proofit_percentage=`echo "$sales * 100 / $cost_price" | tr -d $'\r' | bc -l`

    # Mencari nilai proofit percentage maximum
    if [ 1 -eq "$(echo "${proofit_percentage} >= ${proofit_percentage_max}" | bc)" ]
    then  
        proofit_percentage_max=$proofit_percentage
        proofit_percentage_rid=$row_id
    fi

    # Check orang yg belanja thn 2017 di Albuquerque
    if [[ $orderdate_year == "17" && $city == "Albuquerque" ]]; then
        sudah_ada=0
        # Check apakah data customer sudah ada apa belum di daftar
        for item in "${albuquerque_customer_list[@]}"; do
            if [[ $customer_name == $item ]]; then
                sudah_ada=1
                break
            fi
        done

        if [[ $sudah_ada -eq 0 ]]; then
            albuquerque_customer_list+=("$customer_name")
        fi
    fi

    # Cek customer segment

    for ((i = 0; i < ${#segment_type[@]}; i=i+1)) do
        if [[ $customer_segment == ${segment_type[$i]} ]]; then
            customer_segment_totaltrx[$i]=$((${customer_segment_totaltrx[$i]}+1))
        fi
    done

    # Cek region

    for ((i = 0; i < ${#region_list[@]}; i=i+1)) do
        if [[ $region == ${region_list[$i]} ]]; then
            region_total_profit[$i]=`echo ${region_total_profit[$i]} + $profit | tr -d $'\r' | bc -l`
        fi
    done
}

IFS=$'\n'
for line in $(cat Laporan-TokoShiSop.tsv)
do
    if [[ $index -lt 1 ]]; then
        index=$(($index+1))
        continue
    fi

    echo "[!] Check line $index"
    check "$line"

    # STOP
    # if [[ $index -gt 50 ]]; then
    #     echo "Break with $index"
    #     break
    # fi

    index=$(($index+1))
done

echo "[~] Done~"

lowest_segmen_type="none"
customer_segment_totaltrx_min=999999
for ((i = 0; i < ${#segment_type[@]}; i=i+1)) do
    if [ 1 -eq "$(echo "${customer_segment_totaltrx_min} >= ${customer_segment_totaltrx[$i]}" | bc)" ]
    then
        lowest_segmen_type=${segment_type[$i]}
        customer_segment_totaltrx_min=${customer_segment_totaltrx[$i]}
    fi
done

echo -ne "Transaksi terakhir dengan profit percentage terbesar yaitu $proofit_percentage_rid dengan persentase ${proofit_percentage_max:0:6}%.\n\n">hasil.txt
echo "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:">>hasil.txt

for item in "${albuquerque_customer_list[@]}"; do
    echo $item>>hasil.txt
done

echo -ne "\n">>hasil.txt

echo -ne "Tipe segmen customer yang penjualannya paling sedikit adalah $lowest_segmen_type dengan $customer_segment_totaltrx_min transaksi.\n\n">>hasil.txt

# Manis ingin mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.

manis_region="none"
manis_total_proofit=99999
for ((i = 0; i < ${#region_list[@]}; i=i+1)) do
    if [ 1 -eq "$(echo "${manis_total_proofit} >= ${region_total_profit[$i]}" | bc)" ]
    then
        manis_region=${region_list[$i]}
        manis_total_proofit=${region_total_profit[$i]}
    fi
done

echo "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah $manis_region dengan total keuntungan $manis_total_proofit">>hasil.txt
