#!/bin/bash
while true; do 
    nc -l -p 5432 -q 1 <<< ""
    sleep $((2 + RANDOM % 3))
done
