#!/bin/bash

mkdir -p ./dumps 

function main () {
    file=dumps/res$(date +%s)
    date +"%Y-%m-%d %T" > ./${file}.txt 2>/dev/null
    echo $@ | xxd -p -r | hexdump -C >> ./${file}.txt 2>/dev/null
    text2pcap ./${file}.txt ./${file}.pcap 2>/dev/null && rm -vf ./${file}.txt &>/dev/null
    dump=`tshark -r ./${file}.pcap -V | jq  --raw-input .`
    if [ 0 -ne `echo ${dump} | grep -v 'Protocols in frame: eth:ethertype:data' | wc -l` ];
    then
        echo ${dump} | jq --slurp . 
    else
        rm -vf ./${file}.pcap &>/dev/null
    fi
}

main $@