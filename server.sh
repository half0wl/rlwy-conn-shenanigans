#!/bin/bash
while true; do
  python3 -c '
import socket
import struct
import time
import sys

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind(("0.0.0.0", 5432))
server.listen(1)

print("waiting for conn", file=sys.stderr)
conn, addr = server.accept()
print(f"conn from {addr}", file=sys.stderr)

try:
    # Read startup message
    data = conn.recv(1024)
    if data:
        # AuthenticationOk
        conn.send(b"\x52\x00\x00\x00\x08\x00\x00\x00\x00")
        # ParameterStatus - server_version
        conn.send(b"\x53\x00\x00\x00\x1a\x73\x65\x72\x76\x65\x72\x5f\x76\x65\x72\x73\x69\x6f\x6e\x00\x31\x34\x2e\x30\x00")
        # BackendKeyData
        conn.send(b"\x4b\x00\x00\x00\x0c\x00\x00\x00\x01\x00\x00\x00\x02")
        # ReadyForQuery
        conn.send(b"\x5a\x00\x00\x00\x05\x49")
        # Force flush
        conn.sendall(b"")
        time.sleep(2)
finally:
    # Abruptly close to cause RST
    conn.close()
    server.close()
    sys.exit(0)
' 2>/dev/null &

  PID=$!

  sleep 2.5
  kill -9 $PID 2>/dev/null
  wait $PID 2>/dev/null

  sleep 1
done
