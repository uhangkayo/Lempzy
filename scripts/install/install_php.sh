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

PHP_VERSION=${PHP_VERSION:-8.2}

install_php() {
     echo "${grn}Installing PHP ${PHP_VERSION} ...${end}"
     echo ""
     sleep 3
     apt-get update
     apt-get install -y php${PHP_VERSION}-fpm php${PHP_VERSION}-mysql
     apt-get install -y php${PHP_VERSION} php${PHP_VERSION}-common php${PHP_VERSION}-zip php${PHP_VERSION}-curl \
          php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-mbstring php${PHP_VERSION}-gd \
          php${PHP_VERSION}-imap php${PHP_VERSION}-cli php${PHP_VERSION}-bcmath php${PHP_VERSION}-intl \
          php${PHP_VERSION}-opcache
     echo ""
     sleep 1
}

configure_php_fpm() {
     echo "${grn}Configure PHP FPM ...${end}"
     echo ""
     sleep 3
     PHP_CONF_DIR="/etc/php/${PHP_VERSION}/fpm/php.ini"
     sed -i "s/max_execution_time = 30/max_execution_time = 360/g" "$PHP_CONF_DIR"
     sed -i "s/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/" "$PHP_CONF_DIR"
     sed -i "s/display_errors = .*/display_errors = Off/" "$PHP_CONF_DIR"
     sed -i "s/memory_limit = .*/memory_limit = 512M/" "$PHP_CONF_DIR"
     sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" "$PHP_CONF_DIR"
     sed -i "s/post_max_size = .*/post_max_size = 256M/" "$PHP_CONF_DIR"
     echo ""
     sleep 1
}

install_php
configure_php_fpm
