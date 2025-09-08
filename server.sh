#!/bin/bash
while true; do
  (
    {
      dd bs=1 count=100 2>/dev/null

      # pg handshake proto
      # 1. AuthenticationOk (R)
      printf '\x52\x00\x00\x00\x08\x00\x00\x00\x00'

      # 2. ParameterStatus - server_version
      printf '\x53\x00\x00\x00\x1a\x73\x65\x72\x76\x65\x72\x5f\x76\x65\x72\x73\x69\x6f\x6e\x00\x31\x34\x2e\x30\x00'

      # 3. BackendKeyData (K)
      printf '\x4b\x00\x00\x00\x0c\x00\x00\x00\x01\x00\x00\x00\x02'

      # 4. ReadyForQuery (Z) - Idle transaction state
      printf '\x5a\x00\x00\x00\x05\x49'

      sleep 2
    } | nc -l -p 5432 -q 0
  ) &

  PID=$!

  sleep 2.1
  kill -9 $PID 2>/dev/null # RST

  sleep 1
done
