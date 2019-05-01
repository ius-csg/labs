#!/usr/bin/env python
import requests, sys, re, time, base64
# This script judges completion of the iptables lab with requests
# See the lab manual for details
re.I = True
if len(sys.argv) > 1:
    if not bool(re.match("^http://", sys.argv[1])): # URL must have http://
       sys.argv[1] =  'http://' + sys.argv[1]
    print('Checking connection every 10 seconds...')
    timeschecked = 0
    while True:
        time.sleep(10)
        try:
            requests.head(sys.argv[1], timeout=5)
        except requests.Timeout: # Request timeout for TCP/80
            try:
                requests.head(sys.argv[1] + ':8080', timeout=5) # Can we reach TCP/8080?
            except requests.Timeout: # No!
                print('Lab probably complete: Connection blocked to server or webserver is down')
                exit()
            else: # Yes!
                print('Lab complete: Connection blocked to port 80')
                exit()
        except requests.ConnectionError: #Connection rejected or other error
            print('Failure: Connection to server was rejected or failed without DROP')
            print('Reset your rules with iptables -F & iptables -P INPUT ACCEPT and try again')
            exit()
        else:
            timeschecked += 1
            if timeschecked > 29: #Stop cheating!
                print(base64.b64decode(b"SGludDogVHJ5IHVzaW5nIHRoZSBpcHRhYmxlcyAtLWRwb3J0IGFuZCAtcyBmbGFncwo=").decode().rstrip())
                timeschecked = -100
else:
    print('A command-line arguement with the URL of the webserver is required!')
    exit(1)
