FROM kalilinux/kali

ENV PG_HOST=postgres PG_PORT=5432 PG_USER=postgres PG_PASSWORD=msf PG_DATABASE=msf

RUN apt-get update \
 && apt-get install -y armitage

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
