#!/bin/bash

# Script author: Muhamad Miguel Emmara
# Restore domain and database from migrated archive

set -e

# Colours
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

# Check if you are root
if [ "$(whoami)" != 'root' ]; then
     echo "You have no permission to run $0 as non-root user. Use sudo"
     exit 1
fi

# Variables
domain=$1
archive=$2

domainClear=${domain//./}
domainClear2=${domainClear//-/}

DB_CLIENT=$(command -v mysql || command -v mariadb)
if [ -z "$DB_CLIENT" ]; then
     echo "mysql or mariadb client not found. Please install a database client first."
     exit 1
fi

tmpdir=$(mktemp -d)
tar -xzf "$archive" -C "$tmpdir"

mv "$tmpdir/$domain" /var/www/
chown -R www-data:www-data /var/www/$domain

$DB_CLIENT <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS database_$domainClear2;
MYSQL_SCRIPT

$DB_CLIENT database_$domainClear2 < "$tmpdir/db.sql"

rm -rf "$tmpdir" "$archive"

# Success Prompt
echo "Script By"
echo ""
echo "     __                                    "
echo "    / /   ___  ____ ___  ____  ____  __  __"
echo "   / /   / _ \\/ __ \`__ \\/ __ \\/_  / / / / /"
echo "  / /___/  __/ / / / / / /_/ / / /_/ /_/ /"
echo " /_____/\\___/_/ /_/ /_/ .___/ /___/\\__, /"
echo "                   /_/          /____/_/"
echo ""
echo "${blu}Restore completed for domain $domain${end}"

echo ""
