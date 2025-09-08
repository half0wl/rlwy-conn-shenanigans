FROM debian:latest
RUN apt-get update && apt-get install -y python3 bash && rm -rf /var/lib/apt/lists/*
COPY server.sh /server.sh
RUN chmod +x /server.sh
EXPOSE 5432
CMD ["/bin/bash", "/server.sh"]
