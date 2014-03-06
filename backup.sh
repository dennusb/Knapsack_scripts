#!/bin/bash
datum=`eval date +%Y%m%d`
curl=$(curl -XPOST "http://localhost:9200/_export?path=/etc/elasticsearch/backups/$datum.tar.gz" -s)
if [[ $curl == *true* ]]; then
        echo "Back-up started"
else
        echo -e "\e[31mSomething has gone wrong. Does the file already exist?\e[39m"
        echo $curl
        exit
fi


puntjes="."
files=`find /etc/elasticsearch/backups/ -type f -mtime +2 -exec ls {} \; | wc -l`
if [ "$files" -ne "0" ]; then
        echo "Removing these back-ups"
        find /etc/elasticsearch/backups/ -type f -mtime +2 -exec ls {} \;
        find /etc/elasticsearch/backups/ -type f -mtime +2 -exec rm {} \;
else
        echo "No old back-ups to remove"
fi


echo -e "\e[5mCreating back-up at location /etc/elasticsearch/backups/$datum.tar.gz\e[25m"
while :
do

        content=$(wget 'http://localhost:9200/_export/state' -q -O -)
        if [ "$content" != "{\"exports\":[]}" ]; then
                puntjes=" $puntjes ."
                echo -ne "."
        else
                echo "Back-up finished!"
        exit
        fi
sleep 3
done