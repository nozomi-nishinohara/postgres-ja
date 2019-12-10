FROM postgres:11.5

COPY original-docker-entrypoint.sh /

RUN set -x \
    && mkdir /docker-entrypoint-initdb_original.d \
    && apt-get update -y \
    && apt-get install locales \
    && echo "ja_JP UTF-8" > /etc/locale.gen \
    && locale-gen \
    && chmod +x /original-docker-entrypoint.sh

COPY init.d/ /docker-entrypoint-initdb_original.d/

ENV TZ 'Asia/Tokyo'
ENV LANG ja_JP.UTF-8

ENTRYPOINT [ "/original-docker-entrypoint.sh" ]
CMD [ "/docker-entrypoint.sh", "postgres" ]