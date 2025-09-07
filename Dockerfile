COPY server.sh /server.sh
RUN chmod +x /server.sh
CMD ["/server.sh"]
