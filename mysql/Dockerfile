ARG SQL_VERSION=5.7
FROM mysql:${SQL_VERSION}

COPY entrypoint/setup-slave.sh /usr/local/bin/
COPY entrypoint/wait-for-it.sh /usr/local/bin/

ENTRYPOINT [“setup-slave.sh”]
