FROM debian:latest
RUN apt-get update && apt-get install -y netcat-openbsd bash && rm -rf /var/lib/apt/lists/*
COPY server.sh /server.sh
RUN chmod +x /server.sh
CMD ["/bin/bash", "/server.sh"]
