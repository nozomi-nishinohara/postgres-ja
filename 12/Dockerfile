FROM postgres:12

ENV DEBIAN_FRONTEND noninteractive

LABEL maintainer="Nozomi.Nishinohara"

COPY original-docker-entrypoint.sh /
COPY bashrc /root/.bashrc
COPY wait-for-it.sh /usr/

RUN set -x \
    && mkdir /docker-entrypoint-initdb_original.d \
    && apt-get update -y \
    && apt-get install locales netcat \
    && echo "ja_JP UTF-8" > /etc/locale.gen \
    && locale-gen \
    && chmod +x /original-docker-entrypoint.sh \
    && chmod +x /usr/wait-for-it.sh

COPY init.d/ /docker-entrypoint-initdb_original.d/
COPY libutils.sh /usr/

ENV TZ 'Asia/Tokyo'
ENV LANG ja_JP.UTF-8

ENTRYPOINT [ "/original-docker-entrypoint.sh" ]
CMD [ "/docker-entrypoint.sh", "postgres" ]