#!/bin/sh -e

# scripts/deploy-dev/alterdb/0.2.0/rollback.sh
VERSION="0.2.0"

DB_SCRIPTS_DIR=${DB_SCRIPTS_DIR:-../../..}
set -a
. $DB_SCRIPTS_DIR/deploy-dev/connection.env
set +a

SCRIPTS="
$DB_SCRIPTS_DIR/db/0/2/0/000rollback000.sql
$DB_SCRIPTS_DIR/db/0/1/0/fn_get_user.sql
$DB_SCRIPTS_DIR/db/0/1/0/fn_put_user.sql
"

psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -c "UPDATE versions SET status=5 where ver='$VERSION';"
for SCRIPT in $SCRIPTS
do
	psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -f $SCRIPT
done
psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -c "DELETE from versions where ver='$VERSION';"
