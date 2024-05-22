#!/usr/bin/bash
# Keepalive Script By BaseDCaTx

function keepalive() {
    while true; do
        killProxy
        python2 proxy.py 8080
        sleep 300
    done
}

trap xd SIGINT

function xd() {
    echo -e "Trapped XD"
    $cScreen=$(screen -ls | grep Attached | awk '{print $1}' | awk '[.]' '{print $2}')
    screen -S $cScreen -X quit
    exit 1
}

function killProxy() {
    pids=$(lsof -t - :8080)
        if [-z $pids ] ; then 
            for $pid in $pids; do
                kill $pid
            done
        fi
}