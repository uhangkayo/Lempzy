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

# Install PHP
install_php() {
     # Get OS Version
     OS_VERSION=$(lsb_release -rs)
     if [[ "${OS_VERSION}" == "10" ]]; then
          echo "${grn}Installing PHP ...${end}"
          apt install php7.3-fpm php-mysql -y
          apt install php7.3-common php7.3-zip php7.3-curl php7.3-xml php7.3-xmlrpc php7.3-json php7.3-mysql php7.3-pdo php7.3-gd php7.3-imagick php7.3-ldap php7.3-imap php7.3-mbstring php7.3-intl php7.3-cli php7.3-recode php7.3-tidy php7.3-bcmath php7.3-opcache -y
          echo ""
          sleep 1

     elif [[ "${OS_VERSION}" == "11" ]]; then
          echo "${grn}Installing PHP ...${end}"
          echo ""
          sleep 3
          apt install php7.4-fpm php-mysql -y
          apt-get install php7.4 php7.4-common php7.4-gd php7.4-mysql php7.4-imap php7.4-cli php7.4-cgi php-pear mcrypt imagemagick libruby php7.4-curl php7.4-intl php7.4-pspell php7.4-sqlite3 php7.4-tidy php7.4-xmlrpc php7.4-xsl memcached php-memcache php-imagick php7.4-zip php7.4-mbstring memcached php7.4-soap php7.4-fpm php7.4-opcache php-apcu -y
          echo ""
          sleep 1

     elif [[ "${OS_VERSION}" == "18.04" ]]; then
          echo "${grn}Installing PHP ...${end}"
          apt-get install software-properties-common
          add-apt-repository -y ppa:ondrej/php
          apt update
          apt install php7.3-fpm php-mysql -y
          apt install php7.3-common php7.3-zip php7.3-curl php7.3-xml php7.3-xmlrpc php7.3-json php7.3-mysql php7.3-pdo php7.3-gd php7.3-imagick php7.3-ldap php7.3-imap php7.3-mbstring php7.3-intl php7.3-cli php7.3-recode php7.3-tidy php7.3-bcmath php7.3-opcache -y
          apt-get purge php8.* -y
          apt-get autoclean
          apt-get autoremove -y
          echo ""
          sleep 1

     elif [[ "${OS_VERSION}" == "20.04" ]]; then
          echo "${grn}Installing PHP ...${end}"
          echo ""
          sleep 3
          apt install php7.4-fpm php-mysql -y
          apt-get install php7.4 php7.4-common php7.4-gd php7.4-mysql php7.4-imap php7.4-cli php7.4-cgi php-pear mcrypt imagemagick libruby php7.4-curl php7.4-intl php7.4-pspell php7.4-sqlite3 php7.4-tidy php7.4-xmlrpc php7.4-xsl memcached php-memcache php-imagick php7.4-zip php7.4-mbstring memcached php7.4-soap php7.4-fpm php7.4-opcache php-apcu -y
          echo ""
          sleep 1

     elif [[ "${OS_VERSION}" == "22.04" ]]; then
          echo "${grn}Installing PHP ...${end}"
          echo ""
          sleep 3
          apt install php8.1-fpm php-mysql -y
          apt-get install php8.1 php8.1-common php8.1-gd php8.1-mysql php8.1-imap php8.1-cli php8.1-cgi php-pear mcrypt imagemagick libruby php8.1-curl php8.1-intl php8.1-pspell php8.1-sqlite3 php8.1-tidy php8.1-xmlrpc php8.1-xsl memcached php-memcache php-imagick php8.1-zip php8.1-mbstring memcached php8.1-soap php8.1-fpm php8.1-opcache php-apcu -y
          echo ""
          sleep 1

     elif [[ "${OS_VERSION}" == "22.10" ]]; then
          echo "${grn}Installing PHP ...${end}"
          echo ""
          sleep 3
          apt install php8.1-fpm php-mysql -y
          apt-get install php8.1 php8.1-common php8.1-gd php8.1-mysql php8.1-imap php8.1-cli php8.1-cgi php-pear mcrypt imagemagick libruby php8.1-curl php8.1-intl php8.1-pspell php8.1-sqlite3 php8.1-tidy php8.1-xmlrpc php8.1-xsl memcached php-memcache php-imagick php8.1-zip php8.1-mbstring memcached php8.1-soap php8.1-fpm php8.1-opcache php-apcu -y
          echo ""
          sleep 1

     elif [[ "${OS_VERSION}" == "12" ]]; then
          # Debian 12 (bookworm) ships with PHP 8.2 by default.
          echo "${grn}Installing PHP ...${end}"
          echo ""
          sleep 3
          apt install php8.2-fpm php-mysql -y
          # Install common PHP 8.2 extensions.  These package names follow the
          # `php8.2-*` naming convention.
          apt-get install php8.2 php8.2-common php8.2-gd php8.2-mysql php8.2-imap php8.2-cli php8.2-cgi php-pear mcrypt imagemagick libruby php8.2-curl php8.2-intl php8.2-pspell php8.2-sqlite3 php8.2-tidy php8.2-xmlrpc php8.2-xsl memcached php-memcache php-imagick php8.2-zip php8.2-mbstring memcached php8.2-soap php8.2-fpm php8.2-opcache php-apcu -y
          echo ""
          sleep 1

     elif [[ "${OS_VERSION}" == "13" ]] || [[ "${OS_VERSION}" == "24.04" ]]; then
          # Debian 13 and Ubuntu 24.04 are expected to ship with PHP 8.3.  Use
          # version‑specific packages to ensure the correct version is installed.
          echo "${grn}Installing PHP ...${end}"
          echo ""
          sleep 3
          apt install php8.3-fpm php-mysql -y
          apt-get install php8.3 php8.3-common php8.3-gd php8.3-mysql php8.3-imap php8.3-cli php8.3-cgi php-pear mcrypt imagemagick libruby php8.3-curl php8.3-intl php8.3-pspell php8.3-sqlite3 php8.3-tidy php8.3-xmlrpc php8.3-xsl memcached php-memcache php-imagick php8.3-zip php8.3-mbstring memcached php8.3-soap php8.3-fpm php8.3-opcache php-apcu -y
          echo ""
          sleep 1

     else
          echo -e "${red}Sorry, this script is designed for DEBIAN (10, 11, 12, 13) and UBUNTU (18.04, 20.04, 22.04, 22.10, 24.04)${end}"
          exit 1
     fi
}

# Configure PHP FPM
configure_php_fpm() {
     echo "${grn}Configure PHP FPM ...${end}"
     echo ""
     sleep 3

     # Get PHP Installed Version
     PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

     if [[ "${PHP_VERSION}" == "7.2" ]]; then
          sed -i "s/max_execution_time = 30/max_execution_time = 360/g" /etc/php/7.2/fpm/php.ini
          sed -i "s/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/" /etc/php/7.2/fpm/php.ini
          sed -i "s/display_errors = .*/display_errors = Off/" /etc/php/7.2/fpm/php.ini
          sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
          sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" /etc/php/7.2/fpm/php.ini
          sed -i "s/post_max_size = .*/post_max_size = 256M/" /etc/php/7.2/fpm/php.ini
          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "7.3" ]]; then
          sed -i "s/max_execution_time = 30/max_execution_time = 360/g" /etc/php/7.3/fpm/php.ini
          sed -i "s/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/" /etc/php/7.3/fpm/php.ini
          sed -i "s/display_errors = .*/display_errors = Off/" /etc/php/7.3/fpm/php.ini
          sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.3/fpm/php.ini
          sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" /etc/php/7.3/fpm/php.ini
          sed -i "s/post_max_size = .*/post_max_size = 256M/" /etc/php/7.3/fpm/php.ini
          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "7.4" ]]; then
          sed -i "s/max_execution_time = 30/max_execution_time = 360/g" /etc/php/7.4/fpm/php.ini
          sed -i "s/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/" /etc/php/7.4/fpm/php.ini
          sed -i "s/display_errors = .*/display_errors = Off/" /etc/php/7.4/fpm/php.ini
          sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini
          sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" /etc/php/7.4/fpm/php.ini
          sed -i "s/post_max_size = .*/post_max_size = 256M/" /etc/php/7.4/fpm/php.ini
          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "8.1" ]] || [[ "${PHP_VERSION}" == "8.2" ]] || [[ "${PHP_VERSION}" == "8.3" ]] || [[ "${PHP_VERSION}" == "8.4" ]]; then
          # For PHP 8.x releases we apply the same tuning settings.  Use the
          # detected minor version to build the correct path.
          PHP_CONF_DIR="/etc/php/${PHP_VERSION}/fpm/php.ini"
          sed -i "s/max_execution_time = 30/max_execution_time = 360/g" "$PHP_CONF_DIR"
          sed -i "s/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/" "$PHP_CONF_DIR"
          sed -i "s/display_errors = .*/display_errors = Off/" "$PHP_CONF_DIR"
          sed -i "s/memory_limit = .*/memory_limit = 512M/" "$PHP_CONF_DIR"
          sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" "$PHP_CONF_DIR"
          sed -i "s/post_max_size = .*/post_max_size = 256M/" "$PHP_CONF_DIR"
          echo ""
          sleep 1
     else
          echo -e "${red}Sorry, this script is designed for DEBIAN (10, 11, 12, 13) and UBUNTU (18.04, 20.04, 22.04, 22.10, 24.04)${end}"
          exit 1
     fi
}

# Run
install_php
configure_php_fpm
