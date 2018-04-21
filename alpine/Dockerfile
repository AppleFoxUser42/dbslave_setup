FROM alpine:latest

RUN apk update && apk add mysql-client 

COPY ../entrypoint/setup-slave.sh /usr/local/bin/
COPY ../entrypoint/wait-for-it.sh /usr/local/bin/

ENTRYPOINT ["setup-slave.sh"]
