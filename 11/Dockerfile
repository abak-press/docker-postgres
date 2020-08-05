FROM postgres:11

RUN echo "Asia/Yekaterinburg" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    postgresql-plperl-11 \
    software-properties-common \
    postgresql-11-pgq3 \
    skytools3 \
    skytools3-ticker \
    libpq-dev \
    postgresql-server-dev-11 \
    postgresql-common \
    wget \
    make \
    build-essential \
    libssl-dev \
    libkrb5-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ARG PG_PATHMAN_VER=1.5.8
ARG PG_JOBMON_VER=1.4.0
ARG PG_PARTMAN_VER=4.2.2
ARG PG_RUM_VER=1.3.6

RUN wget https://github.com/keithf4/pg_jobmon/archive/v${PG_JOBMON_VER}.tar.gz \
    && tar -xzvf v${PG_JOBMON_VER}.tar.gz \
    && make -C pg_jobmon-${PG_JOBMON_VER} \
    && make NO_BGW=1 install -C pg_jobmon-${PG_JOBMON_VER} \
    && rm v${PG_JOBMON_VER}.tar.gz \
    && rm -rf pg_jobmon-${PG_JOBMON_VER} && \

  wget https://github.com/keithf4/pg_partman/archive/v${PG_PARTMAN_VER}.tar.gz \
    && tar -xzvf v${PG_PARTMAN_VER}.tar.gz \
    && make -C pg_partman-${PG_PARTMAN_VER} \
    && make install -C pg_partman-${PG_PARTMAN_VER} \
    && rm v${PG_PARTMAN_VER}.tar.gz \
    && rm -rf pg_partman-${PG_PARTMAN_VER} && \

  wget https://github.com/postgrespro/pg_pathman/archive/${PG_PATHMAN_VER}.tar.gz \
    && tar -xzvf ${PG_PATHMAN_VER}.tar.gz \
    && make -C pg_pathman-${PG_PATHMAN_VER} install USE_PGXS=1 \
    && rm ${PG_PATHMAN_VER}.tar.gz \
    && rm -rf pg_pathman-${PG_PATHMAN_VER}

RUN  wget https://github.com/postgrespro/rum/archive/${PG_RUM_VER}.tar.gz \
    && tar -xzvf ${PG_RUM_VER}.tar.gz\
    && make -C rum-${PG_RUM_VER} install USE_PGXS=1 \
    && rm ${PG_RUM_VER}.tar.gz \
    && rm -rf rum-${PG_RUM_VER}

# Configure
RUN echo "listen_addresses = '*'" >> /usr/share/postgresql/11/postgresql.conf.sample && \
  echo "shared_preload_libraries='pg_pathman'" >> /usr/share/postgresql/11/postgresql.conf.sample && \
  echo "plperl.on_init = 'use utf8; use re; package utf8; require \"utf8_heavy.pl\";'" >> /usr/share/postgresql/11/postgresql.conf.sample

# Cleanup
RUN apt-get purge -y build-essential \
  make \
  wget

ENV PATH /usr/bin:$PATH
COPY initdb.sh /docker-entrypoint-initdb.d/
