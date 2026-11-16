#!/bin/bash

SERVER="192.168.1.100"
PORT=22

if nc -z -w 3 "$SERVER" "$PORT"; then
    echo "SSH Port is OPEN"
else
    echo "SSH Port is CLOSED"
fi
