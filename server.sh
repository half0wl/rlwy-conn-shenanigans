#!/bin/bash
while true; do echo "" | nc -l -p 5432 -c "sleep $((2 + RANDOM % 3))" -q 0; done
