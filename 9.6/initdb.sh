#!/bin/bash -e

psql -v ON_ERROR_STOP=1 --username postgres template1 <<-EOSQL
CREATE EXTENSION hstore;
CREATE EXTENSION pg_trgm;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE EXTENSION hstore;
CREATE EXTENSION pg_trgm;
EOSQL
