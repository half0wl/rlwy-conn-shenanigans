#!/bin/bash
while true; do
  (
    echo -ne '\x52\x00\x00\x00\x08\x00\x00\x00\x00' | nc -l -p 5432 -q 0 &
    NC_PID=$!
    sleep 0.5
    kill -9 $NC_PID 2>/dev/null # rst
  )
  sleep 1
done
