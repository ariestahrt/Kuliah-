#!/bin/bash

awk -F '\t' '
BEGIN{
    proofit_percentage_rid=0;
    proofit_percentage_max=-999999;

    lowest_segment_type="none";
    lowest_segment_totaltrx=999999;

    manis_region="none";
    manis_total_profit=999999;
}

(NR>1){
    # print row_id;

    row_id=$1;
    sales=$18;
    profit=$21;
    city=$10;
    orderdate=$3;
    orderdate_year=substr(orderdate,7);

    customer_name=$7;
    customer_segment=$8;

    region=$13;

    # A
    profit_percentage=100*(profit/(sales-profit));
    if(profit_percentage >= proofit_percentage_max){
        proofit_percentage_rid=row_id;
        proofit_percentage_max=profit_percentage;
    }

    # B
    if(city == "Albuquerque" && orderdate_year == "17"){
        albuquerque17[customer_name]=1;
    }

    # C
    segment[customer_segment]++;
    
    # D
    region_proofit[region]+=profit;
}

END{
    # E
    print "Transaksi terakhir dengan profit percentage terbesar yaitu " proofit_percentage_rid " dengan persentase "proofit_percentage_max"%.\n";
    print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:";

    for(key in albuquerque17){
        print key;
    }

    for(key in segment){
        if(segment[key] <= lowest_segment_totaltrx){
            lowest_segment_type=key;
            lowest_segment_totaltrx=segment[key];
        }
    }

    print "\nTipe segmen customer yang penjualannya paling sedikit adalah " lowest_segment_type " dengan " lowest_segment_totaltrx " transaksi.\n";

    for(key in region_proofit){
        if(region_proofit[key] <= manis_total_profit){
            manis_region=key;
            manis_total_profit=region_proofit[key];
        }
    }

    print "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah " manis_region " dengan total keuntungan " manis_total_profit;
}

' Laporan-TokoShiSop.tsv > hasil.txt
