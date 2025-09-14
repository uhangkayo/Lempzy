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

# Install Memcached
install_memcached() {
     echo "${grn}Installing Memcached ...${end}"
     echo ""
     sleep 3
     apt install memcached -y
     echo ""
     sleep 1
     apt install php-memcached -y
     sleep 1

     # Get PHP Installed Version
     PHP_MAJOR_VERSION=$(php -r "echo PHP_MAJOR_VERSION;")

     # Get OS Version
     OS_VERSION=$(lsb_release -rs)

     # On distributions that use PHP 7.x as their default (Debian 10/11 and Ubuntu 18.04/20.04),
     # remove any previously installed PHP 8 packages to avoid conflicts.  Do not purge
     # PHP 8 on newer releases that intentionally ship with PHP 8 (e.g. Debian 12/13 or Ubuntu 22/24).
     if [[ "${OS_VERSION}" != "22.04" ]] && [[ "${OS_VERSION}" != "22.10" ]] && [[ "${OS_VERSION}" != "12" ]] && [[ "${OS_VERSION}" != "13" ]] && [[ "${OS_VERSION}" != "24.04" ]]; then
          if [[ "${PHP_MAJOR_VERSION}" == "8" ]]; then
               apt-get purge php8.* -y
               apt-get autoclean
               apt-get autoremove -y
          fi
     fi

     echo ""
     sleep 1
}

# Run
install_memcached
