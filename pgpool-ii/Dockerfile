FROM centos:7.5.1804

RUN set -x \
    && yum install -y http://www.pgpool.net/yum/rpms/4.1/redhat/rhel-7-x86_64/pgpool-II-release-4.1-1.noarch.rpm \
    && yum install -y pgpool-II-pg11.x86_64 pgpool-II-pg11-debuginfo.x86_64 pgpool-II-pg11-devel.x86_64 pgpool-II-pg11-extensions.x86_64 nmap-ncat \
    && yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm postgresql11 \
    && pgpool -v

LABEL maintainer="Nozomi.Nishinohara"

COPY bashrc /root/.bashrc
COPY wait-for-it.sh /usr/bin/
COPY libutils.sh /usr/
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh \
    && chmod +x /usr/bin/wait-for-it.sh

ENV TZ 'Asia/Tokyo'
ENV LANG ja_JP.UTF-8

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "pgpool", "-n"]