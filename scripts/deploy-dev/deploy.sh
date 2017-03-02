#!/bin/sh -e

set -a
. ./connection.env
set +a
export DB_SCRIPTS_DIR=${DB_SCRIPTS_DIR:-..}

echo "run builddb scripts"
for f in `ls builddb/* -v`; do
	case "$f" in
		*.sh)  echo "$0: running $f"; . "$f" ;;
		*.sql) echo "$0: running $f"; psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} < "$f" && echo ;;
		*)     echo "$0: ignoring $f" ;;
	esac
	echo
done

echo "run alterdb scripts"
for g in `ls alterdb/*/deploy.sh -v`; do
	case "$g" in
		*.sh)  echo "$0: running $g"; . "$g" ;;
		*.sql) echo "$0: running $g"; psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} < "$g" && echo ;;
		*)     echo "$0: ignoring $g" ;;
	esac
	echo
done

echo "run insertdb scripts"
for h in insertdb/*; do
	case "$h" in
		*.sh)  echo "$0: running $h"; . "$h" ;;
		*.sql) echo "$0: running $h"; psql ${HOST_CONNECTION} -U ${PGUSER} -d ${DBNAME} < "$h" && echo ;;
		*)     echo "$0: ignoring $h" ;;
	esac
	echo
done
