#!/bin/bash

set -e

# Colours
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

MARIADB_VERSION=${MARIADB_VERSION:-10.11}

# Install MariaDB server
install_mariadb() {
     echo "${grn}Installing MariaDB ${MARIADB_VERSION} ...${end}"
     echo ""
     sleep 3
     apt-get update
     echo ""
     sleep 1
}

# Run
install_mariadb
