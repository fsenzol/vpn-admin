#!/bin/bash

PYURL="https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz"
PY="Python-2.7.18.tgz"
PYFOLDER="Python-2.7.18"
PROXYURL="https://raw.githubusercontent.com/januda-ui/DRAGON-VPS-MANAGER/main/Modulos/proxy.py"
FILENAME=$(basename "$0")

function setup() {
    apt install gcc g++ clang nano nvim lua5.3 screen -y
    clear
}

function installPY() {
    wget "$PYURL" -O "$PY"
    if [ -f "$PY" ]; then
        tar -xvf "$PY"
        cd "$PYFOLDER" || exit
        ./configure
        make && make install
        clear
    else
        echo "Python Not Found!"
    fi

    if command -v "python2" > /dev/null; then
        clear
        echo "Python2 Is Installed!"
        sleep 2
        clear
    else
        clear
        echo "Something went wrong!"
    fi
}

function installTCP() {
    wget "$PROXYURL" -O "proxy.py"
    if [ -f "proxy.py" ]; then
        clear
        echo "Installing Proxy...!"
        sleep 2
        pON=$(lsof -t -i :8080)
        if [ -n "$pON" ]; then
            clear
            echo "Proxy Detected! LOL BRO"
            sleep 2
            exit 1
        fi
    else
        mkdir /etc/basedcat/
        sed -i 's/^MSG='\'''\''/MSG="Captain BaseDCaTx"/' 'proxy.py'
        mv proxy.py /etc/basedcat/
        clear
        echo "Installations Done!"
        bash /etc/basedcat/proxy.py 8080 &
        clear
        if ! lsof -t -i :8080 > /dev/null; then
            echo -e "Proxy started on port: 8080"
        else
            echo "Proxy Not Started! LOL"
        fi
        sleep 3
        clear
    fi
}

function cleanup() {
    rm "$FILENAME"
    echo "All processes Done! :)"
    exit 1
}

function launchKeep() {
    clear
    echo "Enabling Keepalive..."
    sleep 2
    wget "https://raw.githubusercontent.com/fsenzol/fsenzol-vps-manager/main/keepalive.sh?token=GHSAT0AAAAAACSUFY5H6AS3WMPQDU2DJCF6ZSN2BBQ" -O "keepalive.sh"
    if [ -f "keepalive.sh" ]; then
        mv keepalive.sh /etc/basedcat/
        clear
    fi
    screen -S keep
    cd /etc/basedcat/ || exit
    chmod +x keepalive.sh
    bash keepalive.sh &
}

function start() {
    num=-1
    while true; do
        clear
        echo -e "Script By BaseDCaTx\n\n1. Install TCP\n2. Install Keepalive\n3. Install All\n4. Quit\n\nSelect: "
        read -r num

        if [[ ! "$num" =~ ^[0-9]+$ ]]; then
            clear
            echo "Invalid Input....! \n"
            sleep 1
            continue
        fi

        if [[ "$num" -lt 1 || "$num" -gt 3 ]]; then
            clear
            echo "Input out of range....! \n"
            sleep 1
            continue
        else
            break
        fi
    done

    if [ "$num" -eq 1 ]; then
        setup
        installPY
        installTCP
    elif [ "$num" -eq 2 ]; then
        launchKeep
        cleanup
    elif [ "$num" -eq 3 ]; then
        setup
        installPY
        installTCP
        launchKeep
        cleanup
    elif [ "$num" -eq 4 ]; then
        exit 1
        cleanup
    else
        echo " LoL Bro! "
        exit 1
    fi
}

start
