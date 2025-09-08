#!/bin/bash
while true; do
  PIPE=$(mktemp -u)
  mkfifo $PIPE

  nc -l -p 5432 <$PIPE | (
    read -n 8

    # pg proto
    # 1. AuthenticationOk (R)
    echo -ne '\x52\x00\x00\x00\x08\x00\x00\x00\x00'

    # 2. ParameterStatus messages (S) server_version
    echo -ne '\x53\x00\x00\x00\x1a\x73\x65\x72\x76\x65\x72\x5f\x76\x65\x72\x73\x69\x6f\x6e\x00\x31\x34\x2e\x30\x00'

    # 3. BackendKeyData (K)
    echo -ne '\x4b\x00\x00\x00\x0c\x00\x00\x00\x01\x00\x00\x00\x02'

    # 4. ReadyForQuery (Z) ready for queries
    echo -ne '\x5a\x00\x00\x00\x05\x49'

    # keepalive
    sleep 2
  ) >$PIPE &

  PROCESS_PID=$!
  wait $PROCESS_PID
  pkill -9 -P $$ nc 2>/dev/null # rst it
  rm -f $PIPE
  sleep 1
done
