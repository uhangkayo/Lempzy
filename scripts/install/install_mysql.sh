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

MYSQL_VERSION=${MYSQL_VERSION:-8.0}

install_mysql() {
     echo "${grn}Installing MySQL ${MYSQL_VERSION} ...${end}"
     echo ""
     sleep 3
     apt-get update
     apt-get install -y mysql-server-${MYSQL_VERSION}
     echo ""
     sleep 1
}

install_mysql
