FROM postgres:9.3

RUN echo "Asia/Yekaterinburg" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    postgresql-plperl-9.3 \
    python-software-properties \
    software-properties-common \
    postgresql-9.3-pgq3 \
    skytools3 \
    skytools3-ticker \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN echo "plperl.on_init = 'use utf8; use re; package utf8; require \"utf8_heavy.pl\";'" >> /usr/share/postgresql/postgresql.conf.sample

COPY initdb.sh /docker-entrypoint-initdb.d/

COPY init-pg-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["init-pg-entrypoint.sh"]
CMD ["postgres"]
