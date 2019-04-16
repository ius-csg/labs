#!/usr/bin/env bash
# This script judges completion of the iptables lab via cURL
# See the lab manual for more details
if [[ -n "$(command -v curl)" && -n "$(command -v nc)" ]]; then
    if [[ $# -eq 1 && $1 =~ [0-9.] ]]; then
        echo 'Checking connection every 10 seconds...'
        timeschecked=0
        while [ true ]; do
            sleep 10
            curl -I -s $1 --connect-timeout 5 > /dev/null
            timeschecked=$((timeschecked++))
            if [[ $? -eq 28 ]]; then #Timeout
                curl -I -s $1:8080 --connect-timeout 5 > /dev/null # Can I connect to any ports at all?
                if [[ $? -eq 0 ]]; then # Yes!
                  echo 'Lab complete. Connection blocked to port 80'
                  exit
                else # No!
                  echo 'Lab complete. Connection blocked to server'
                  exit
                fi
            fi    
            if [[ timeschecked > 29 ]]; then # Please don't make me change this. Just do the lab.
                echo "SGludDogVHJ5IHVzaW5nIHRoZSBpcHRhYmxlcyAtLWRwb3J0IGFuZCAtcyBmbGFncwo=" | base64 -d
                timeschecked=-100 # Don't show the message again for a while
            fi
        done
    else
        (>&2 echo 'Please include ONLY THE IP of the webserver as an argument')
        exit 2
    fi
else
    (>&2 echo 'You must have curl installed and in your path to run this script!')
    exit 1
fi
