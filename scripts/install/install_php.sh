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

SUPPORTED_PHP_VERSIONS=("7.2" "7.3" "7.4" "8.1" "8.2" "8.3" "8.4")

is_supported_version() {
     local version="$1"
     shift
     for supported in "$@"; do
          if [[ "$supported" == "$version" ]]; then
               return 0
          fi
     done
     return 1
}

detect_os_metadata() {
     if [[ -r /etc/os-release ]]; then
          # shellcheck disable=SC1091
          . /etc/os-release
          OS_ID=${ID,,}
          OS_CODENAME=${VERSION_CODENAME:-}
     fi

     if command -v lsb_release >/dev/null 2>&1; then
          [[ -z ${OS_ID:-} ]] && OS_ID=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
          [[ -z ${OS_CODENAME:-} ]] && OS_CODENAME=$(lsb_release -cs)
     fi

     if [[ -z ${OS_ID:-} ]]; then
          return 1
     fi

     export OS_ID OS_CODENAME
     return 0
}

ensure_php_repository() {
     detect_os_metadata || {
          echo -e "${red}Unable to detect the operating system. Cannot configure PHP repository.${end}"
          exit 1
     }

     if [[ "$OS_ID" == "debian" ]]; then
          apt-get install -y ca-certificates apt-transport-https curl gnupg lsb-release
          [[ -z ${OS_CODENAME:-} ]] && OS_CODENAME=$(lsb_release -cs)
          if [[ -z ${OS_CODENAME:-} ]]; then
               echo -e "${red}Unable to determine Debian codename for PHP repository.${end}"
               exit 1
          fi
          local sury_list="/etc/apt/sources.list.d/sury-php.list"
          if [[ ! -f "$sury_list" ]]; then
               mkdir -p /usr/share/keyrings
               curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury-php.gpg
               echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ ${OS_CODENAME} main" > "$sury_list"
          fi
     elif [[ "$OS_ID" == "ubuntu" ]]; then
          apt-get install -y software-properties-common ca-certificates curl
          if ! grep -Rq "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
               add-apt-repository -y ppa:ondrej/php
          fi
     else
          echo -e "${red}Unsupported distribution: ${OS_ID}. Cannot configure PHP repository.${end}"
          exit 1
     fi
}

if ! is_supported_version "$PHP_VERSION" "${SUPPORTED_PHP_VERSIONS[@]}"; then
     echo -e "${red}Unsupported PHP version. Supported versions are: ${SUPPORTED_PHP_VERSIONS[*]}.${end}"
     exit 1
fi

install_php() {
     echo "${grn}Installing PHP ${PHP_VERSION} ...${end}"
     echo ""
     sleep 3
     ensure_php_repository
     apt-get update

     local -a php_packages=("php${PHP_VERSION}-fpm" "php${PHP_VERSION}-mysql" "php${PHP_VERSION}")
     local -a optional_modules=("common" "zip" "curl" "xml" "xmlrpc" "mbstring" "gd" "imap" "cli" "bcmath" "intl" "opcache")
     local package

     for module in "${optional_modules[@]}"; do
          package="php${PHP_VERSION}-${module}"
          if apt-cache show "$package" >/dev/null 2>&1; then
               php_packages+=("$package")
          else
               echo "${yel}Package ${package} is not available in the configured repositories and will be skipped.${end}"
          fi
     done

     apt-get install -y "${php_packages[@]}"
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
