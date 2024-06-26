#!/bin/bash

PYURL="https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz"
PY="Python-2.7.18.tgz"
PYFOLDER="Python-2.7.18"
PROXYURL="https://raw.githubusercontent.com/januda-ui/DRAGON-VPS-MANAGER/main/Modulos/proxy.py"
FILENAME=$(dirname "$(realpath "$0")")

function setup() {
    apt update &&  apt install gcc g++ clang nano neovim lua5.3 screen -y
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
        cd ~/
        rm -r $PYFOLDER
        rm $PY
        history -c
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

        mkdir /etc/basedcat/
        sed -i 's/^MSG='\'''\''/MSG="Captain BaseDCaTx"/' 'proxy.py'
        mv ~/proxy.py /etc/basedcat/
        clear
        echo "Installations Done!"
        python2 /etc/basedcat/proxy.py 8080 &
        clear

        if ! lsof -t -i :8080 > /dev/null; then
            echo -e "Proxy started on port: 8080"
        else
            echo "Proxy Not Started! LOL"
        fi
        sleep 10
        clear
    else
        clear
        echo "Proxy Not Found!" 
        sleep 2
    fi
}

function cleanup() {
    clear
    rm "$FILENAME"
    echo "All processes Done! :)"
}

function launchKeep() {
    clear
    echo "Enabling Keepalive..."
    sleep 5
    
    wget "https://raw.githubusercontent.com/fsenzol/vpn-admin/main/keepalive.sh" -O "keepalive.sh"
    if [ -f "keepalive.sh" ]; then
        mkdir /etc/basedcat
        mv keepalive.sh /etc/basedcat/
        clear
    fi


    if [[ ! -f "/etc/basedcat/proxy.py" ]] ; then
       wget "$PROXYURL" -O "proxy.py"
       mv ~/proxy.py /etc/basedcat/
       clear
    fi


    screen -S keep
    cd /etc/basedcat/ || exit
    chmod +x /etc/basedcat/keepalive.sh
    bash /etc/basedcat/keepalive.sh
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

        if [[ "$num" -lt 1 || "$num" -gt 4 ]]; then
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
        cleanup
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
        cleanup
        exit 1
    else
        echo " LoL Bro! "
        exit 1
    fi
}

start
