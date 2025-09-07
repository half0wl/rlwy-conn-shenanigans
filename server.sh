#!/bin/bash
while true; do
  nc -l -p 5432 &
  NC_PID=$!
  sleep 0.1
  kill -9 $NC_PID 2>/dev/null
  sleep $((2 + RANDOM % 3))
done
