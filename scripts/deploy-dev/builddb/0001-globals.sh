#!/bin/sh -e


DIR=../db

SCRIPTS="
gbl_functions.sql
"

for SCRIPT in $SCRIPTS
do
	psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} -a -f $DIR/$SCRIPT
done
