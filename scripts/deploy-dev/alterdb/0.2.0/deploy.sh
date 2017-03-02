#!/bin/sh -e

# scripts/deploy-dev/alterdb/0.2.0/deploy.sh

VERSION="0.2.0"

DB_SCRIPTS_DIR=${DB_SCRIPTS_DIR:-../../..}
set -a
. $DB_SCRIPTS_DIR/deploy-dev/connection.env
set +a

SCRIPTS="
$DB_SCRIPTS_DIR/db/0/2/0/alter_users.sql
$DB_SCRIPTS_DIR/db/0/2/0/fn_put_user.sql
$DB_SCRIPTS_DIR/db/0/2/0/fn_get_user.sql
$DB_SCRIPTS_DIR/db/0/2/0/tbl_privileged.sql
$DB_SCRIPTS_DIR/db/0/2/0/fn_put_privilege.sql
$DB_SCRIPTS_DIR/db/0/2/0/fn_get_privilege.sql
"

psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -c "INSERT INTO versions (ver, status) VALUES ('$VERSION', 0);"

for SCRIPT in $SCRIPTS
do
	psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -f $SCRIPT
done

psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -c "UPDATE versions SET status=1 where ver='$VERSION';"
