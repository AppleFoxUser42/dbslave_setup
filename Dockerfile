FROM percona:latest

COPY setup-slave.sh /usr/local/bin/
COPY wait-for-it.sh /usr/local/bin/

ENTRYPOINT ["/bin/bash"]
CMD ["setup-slave.sh"]
