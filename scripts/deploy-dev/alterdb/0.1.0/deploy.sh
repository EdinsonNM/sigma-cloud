#!/bin/sh -e

# scripts/deploy-dev/alterdb/0.1.0/deploy.sh

VERSION="0.1.0"

DB_SCRIPTS_DIR=${DB_SCRIPTS_DIR:-../../..}
set -a
. $DB_SCRIPTS_DIR/deploy-dev/connection.env
set +a

SCRIPTS="
$DB_SCRIPTS_DIR/db/0/1/0/tbl_users.sql
$DB_SCRIPTS_DIR/db/0/1/0/fn_get_user.sql
$DB_SCRIPTS_DIR/db/0/1/0/fn_put_user.sql
"

for SCRIPT in $SCRIPTS
do
	psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -f $SCRIPT
done

psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -c "INSERT INTO versions (ver, status) VALUES ('$VERSION', 1);"
