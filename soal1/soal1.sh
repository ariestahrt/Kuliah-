#!/bin/bash
IFS=$'\n'

echo "Error,Count">error_message.csv
echo "Username,INFO,ERROR">user_statistic.csv

# B -- D

for line in $(cat syslog.log | grep "ERROR" | grep -oP "ERROR\s\K.*(?=\s\()" | sort | uniq)
do
    total=$(cat syslog.log | grep -c "$line")
    echo $line,$total
done | sort -rnk 2 -t','>>error_message.csv

# C -- E
for line in $(cat syslog.log | grep -o '(.*)' | tr -d '(' | tr -d ')' | sort | uniq)
do
    error=$(cat syslog.log | grep "$line" | grep -c "ERROR")
    info=$(cat syslog.log | grep "$line" | grep -c "INFO")
    echo $line,$error,$info
done >> user_statistic.csv