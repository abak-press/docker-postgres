FROM postgres:9.6

RUN echo "Asia/Yekaterinburg" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    postgresql-plperl-9.6 \
    software-properties-common \
    postgresql-9.6-pgq3 \
    skytools3 \
    skytools3-ticker \
    libpq-dev \
    postgresql-server-dev-9.6 \
    postgresql-common \
    wget \
    unzip \
    make \
    build-essential \
    libssl-dev \
    libkrb5-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ARG PG_PATHMAN_VER=1.4.14
ARG PG_JOBMON_VER=1.3.3
ARG PG_PARTMAN_VER=3.1.0

RUN wget https://github.com/omniti-labs/pg_jobmon/archive/v${PG_JOBMON_VER}.zip \
    && unzip v${PG_JOBMON_VER}.zip \
    && make -C pg_jobmon-${PG_JOBMON_VER} \
    && make NO_BGW=1 install -C pg_jobmon-${PG_JOBMON_VER} \
    && rm v${PG_JOBMON_VER}.zip \
    && rm -rf pg_jobmon-${PG_JOBMON_VER} && \

  wget https://github.com/keithf4/pg_partman/archive/v${PG_PARTMAN_VER}.zip \
    && unzip v${PG_PARTMAN_VER}.zip \
    && make -C pg_partman-${PG_PARTMAN_VER} \
    && make install -C pg_partman-${PG_PARTMAN_VER} \
    && rm v${PG_PARTMAN_VER}.zip \
    && rm -rf pg_partman-${PG_PARTMAN_VER} && \

  wget https://github.com/postgrespro/pg_pathman/archive/${PG_PATHMAN_VER}.zip \
    && unzip ${PG_PATHMAN_VER}.zip \
    && make -C pg_pathman-${PG_PATHMAN_VER} install USE_PGXS=1 \
    && rm ${PG_PATHMAN_VER}.zip \
    && rm -rf pg_pathman-${PG_PATHMAN_VER}

# Configure
RUN echo "listen_addresses = '*'" >> /usr/share/postgresql/9.6/postgresql.conf.sample && \
  echo "shared_preload_libraries='pg_pathman'" >> /usr/share/postgresql/9.6/postgresql.conf.sample && \
  echo "plperl.on_init = 'use utf8; use re; package utf8; require \"utf8_heavy.pl\";'" >> /usr/share/postgresql/9.6/postgresql.conf.sample

# Cleanup
RUN apt-get purge -y build-essential \
  make \
  wget \
  unzip

ENV PATH /usr/bin:$PATH
COPY initdb.sh /docker-entrypoint-initdb.d/
