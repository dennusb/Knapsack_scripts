filename=$1
index=$2

curl=$(curl -XPOST "localhost:9200/$2/_import?path=$1" -s)
if [[ "$curl" == *error* ]]; then
        echo "$(date) An error ocurred. Please check the error :"
        echo $curl
else
        echo "$(date) File found! Starting the import from file $filename. Please be patient"

while :
        do
        content=$(wget 'http://localhost:9200/_import/state' -q -O -)
        if [ "$content" != "{\"imports\":[]}" ]; then
                echo -ne "."
        else
                echo "$9date) Importing into index $2 finished!"
        exit
        fi
        sleep 3
done

fi
