#!/usr/bin/env bash


psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL

-- auto explain for analyse all queries and inside functions
LOAD 'auto_explain';
SET auto_explain.log_min_duration = 0;
SET auto_explain.log_analyze = true;

EOSQL
