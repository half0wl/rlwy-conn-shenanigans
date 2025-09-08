#!/bin/bash
while true; do
  nc -l -p 5432 &
  NC_PID=$!
  kill -9 $NC_PID 2>/dev/null
done
