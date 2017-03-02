#!/bin/sh -e

# scripts/deploy-dev/alterdb/0.2.0/rollback.sh

DB_SCRIPTS_DIR=${DB_SCRIPTS_DIR:-../../..}
set -a
. $DB_SCRIPTS_DIR/deploy-dev/connection.env
set +a

SCRIPTS="
$DB_SCRIPTS_DIR/db/0/1/0/000rollback000.sql
"

for SCRIPT in $SCRIPTS
do
	psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -f $SCRIPT
done
