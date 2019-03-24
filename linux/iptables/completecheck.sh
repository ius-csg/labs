#!/usr/bin/env bash
# This script judges completion of the iptables lab via cURL
# See the lab manual for more details
if [[ -n "$(command -v curl)" && -n "$(command -v nc)" ]]; then
    if [[ $# -eq 1 && $1 =~ [0-9.] ]]; then
        echo 'Checking connection every 10 seconds...'
        while [ true ]; do
            sleep 10
            curl -I -s $1 --connect-timeout 5 > /dev/null
            if [[ $? -eq 28 ]]; then #Timeout
                nc -z -w5 $1 8080 # Can I connect to any ports at all?
                if [[ $? -eq 0 ]]; then # Yes!
                  echo 'Lab complete. Connection blocked to port 80'
                  exit
                else # No!
                  echo 'Lab complete. Connection blocked to server'
                  exit
                fi
            fi
            if [[ $? -eq 35 ]]; then # TCP reset
                echo 'Lab complete. Connection rejected with TCP reset!'
                exit
            fi
        done
    else
        echo 'Please include ONLY THE IP of the webserver as an argument'
        exit 2
    fi
else
    echo 'You must have curl and netcat (nc) installed and in your path to run this script!'
    exit 1
fi
