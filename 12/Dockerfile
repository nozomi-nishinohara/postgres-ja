FROM postgres:12

RUN set -x \
    && mkdir /docker-entrypoint-initdb_original.d \
    && apt-get update -y \
    && apt-get install locales \
    && echo "ja_JP UTF-8" > /etc/locale.gen \
    && locale-gen

ENV TZ 'Asia/Tokyo'
ENV LANG ja_JP.UTF-8