#!/bin/bash
datum=`eval date +%Y%m%d`
folder="$1"

if [ $1 == "-h" ]; then
        echo -e "Usage : <script> <backupfolder>.\nPlease don't use a trailing slash at the end of the folder"
        exit
fi

if [[ $folder == "" ]]; then
        echo "\e[31m$(date) The folder parameter has not been passed with the script. Please provide a back-up path\e[39m"
		exit
fi

touch "$folder"/"state.txt"
echo "Running" > "$folder"/"state.txt"

curl=$(curl -XPOST "http://localhost:9200/_export?path=$folder/$datum.tar.gz" -s)

if [[ $curl == *true* ]]; then
        echo "Back-up started"
else
        echo -e "\e[31m $(date) Something has gone wrong. Does the file already exist?\e[39m"
        echo $curl
        exit
fi

files=`find "$folder/" -type f -mtime +2 -exec ls {} \; | wc -l`
if [ "$files" -ne "0" ]; then
        echo "Removing these back-ups"
        find "$folder/" -type f -mtime +2 -exec ls {} \;
        find "$folder/" -type f -mtime +2 -exec rm {} \;
else
        echo "No old back-ups to remove"
fi

echo -e "\e[5mCreating back-up at location "$folder"/$datum.tar.gz\e[25m"
while :
do
        content=$(wget 'http://localhost:9200/_export/state' -q -O -)
        if [ "$content" != "{\"exports\":[]}" ]; then
                echo -ne "."
        else
                echo "Back-up finished!"
				rm "$folder/state.txt"
        exit
        fi
sleep 3
done