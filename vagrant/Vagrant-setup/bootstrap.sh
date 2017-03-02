#!/bin/bash -e

# GUEST IP
GUEST_IP=192.168.88.88

# Hosts files
HOSTS=/etc/hosts

# Edit the following to change the name of the database user that will be created:
PGUSER=node
PGPASSWORD=node8088
PGDATABASE=sigmacloud

# Node version duh
NODE_VER=7.x

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=9.6

# Edit the following to change the name of the database that is created (defaults to the user name)

FQDN=sigmacloud.io.local

# TODO: change the print usage text
###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your NODEJS environment has been setup"
  echo "  Host: $GUEST_IP  [ $FQDN ]"
  echo "  Guest IP: $GUEST_IP"
  echo "    added:   \"$FQDN   $GUEST_IP\"   to /etc/hosts"
  echo ""
  echo "  NodeJS v:$NODE_VER"
  echo ""
  echo "  Port: 5432"
  echo "  Database: $PGDATABASE"
  echo "  Username: $PGUSER"
  echo "  Password: $PGPASSWORD"
  echo ""
  echo "Admin access to postgres user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo "  PGUSER=$PGUSER PGPASSWORD=$PGPASSWORD psql -h localhost $PGDATABASE"
  echo ""
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$PGUSER:$PGPASSWORD@*:5432/$PGDATABASE"
  echo ""
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$PGUSER PGPASSWORD=$PGPASSWORD psql -h localhost -p 5432 $PGDATABASE"
  echo ""
  echo "  Getting into the box (terminal):"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
}

export DEBIAN_FRONTEND=noninteractive

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

chown vagrant /etc/hosts
echo "$GUEST_IP   local.qhacemos" >> /etc/hosts

PG_REPO_APT_SOURCE=/etc/apt/sources.list.d/pgdg.list
if [ ! -f "$PG_REPO_APT_SOURCE" ]
then
  # Add PG apt repo:
  echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > "$PG_REPO_APT_SOURCE"

  # Add PGDG repo key:
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
fi

# update / upgrade
apt-get update
#apt-get -y upgrade #too slow - instead, keep the virtual box up-to-date

# get gyp dependency for binary versions (faster)
apt-get -y install build-essential
apt-get -y install python
#apt-get install python-setuptools
apt-get -y install gyp

# install node
#apt-get -y install curl
curl -sL "https://deb.nodesource.com/setup_$NODE_VER" | sudo -E bash -
sudo apt-get install -y nodejs

#Install node-inspector package for debugging
npm install -g node-inspector

# install git
sudo apt-get -y install git


# Install standard version of postgresql
#apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"

# Install dev version of postgresql to support debugging
apt-get -y install "postgresql-server-dev-$PG_VERSION"  "postgresql-contrib-$PG_VERSION"

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"


# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"


# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"


# We need to add password aouth for $PGUSER before other aouth configs.
match='# "local" is for Unix domain socket connections only'
insert="local    all             $PGUSER                           md5"
sed -i "s/$match/$match\n$insert/" $PG_HBA


# Restart so that all new config is loaded:
service postgresql restart

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $PGUSER WITH PASSWORD '$PGPASSWORD';

-- Create the database:
CREATE DATABASE $PGDATABASE WITH OWNER $PGUSER;


-- auto explain for analyse all queries and inside functions
LOAD 'auto_explain';
SET auto_explain.log_min_duration = 0;
SET auto_explain.log_analyze = true;

EOF



# dependencies for postgis
sudo apt-get -y install libxml2-dev
sudo apt-get -y install libgeos-dev
sudo apt-get -y install binutils libproj-dev gdal-bin

# more dependencies for postgis (whew)
wget http://download.osgeo.org/gdal/1.11.2/gdal-1.11.2.tar.gz
tar xzf gdal-1.11.2.tar.gz
cd gdal-1.11.2
./configure
make # Go get some coffee, this takes a while.
sudo make install
cd ..

# get and make and install postgis
wget http://download.osgeo.org/postgis/source/postgis-2.3.2.tar.gz
tar xvfz  postgis-2.3.2.tar.gz
cd postgis-2.3.2
./configure
make
sudo make install
cd ..




cat << EOF | su - postgres -c psql

-- Enable PostGIS (includes raster)
CREATE EXTENSION postgis;
-- Enable Topology
CREATE EXTENSION postgis_topology;
-- fuzzy matching needed for Tiger
CREATE EXTENSION fuzzystrmatch;
-- rule based standardizer
CREATE EXTENSION address_standardizer;
-- example rule data set
CREATE EXTENSION address_standardizer_data_us;
-- Enable US Tiger Geocoder
CREATE EXTENSION postgis_tiger_geocoder;

EOF

# Restart PostgreSQL for good measure
service postgresql restart


# db deploy scripts
echo "deploy base db with sample data"
# db base deploy version 0.1.0
#cd /home/vagrant/quehacemos/scripts/deploy-dev
#chmod a+x deploy.sh
#mkdir -p log
#./deploy.sh 2> log/deploydb.log



# Tag the provision time:
date > "$PROVISIONED_ON"

echo "Successfully created NODE.JS 5 dev virtual machine with Postgres"
echo ""
print_db_usage
