#!/bin/sh -e


DIR=../db

SCRIPTS="
tbl_versions.sql
"

for SCRIPT in $SCRIPTS
do
	psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -f $DIR/$SCRIPT
done
