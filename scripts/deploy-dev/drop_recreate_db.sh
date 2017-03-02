#!/bin/sh -e
APP_DB_USER=node
APP_DB_NAME=$APP_DB_USER


cat << EOF | su - postgres -c psql

DROP DATABASE IF EXISTS $APP_DB_NAME;

-- Create the database:
CREATE DATABASE $APP_DB_NAME WITH OWNER $APP_DB_USER;

EOF
