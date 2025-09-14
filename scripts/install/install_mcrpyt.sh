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

# Install Mcrypt
install_mcrpyt() {
     echo "${grn}Installing Mcrypt ...${end}"
     echo ""
     sleep 3

     # PHP Modules folder
     MODULES=$(php -i | grep ^extension_dir | awk '{print $NF}')

     # Get PHP Installed Version
     PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

     if [[ "${PHP_VERSION}" == "7.2" ]]; then
          # PHP 7.2 support – install the 1.0.3 release of mcrypt which supports PHP 7.x.
          apt-get install php7.2-dev -y
          apt-get -y install gcc make autoconf libc-dev pkg-config libmcrypt-dev
          yes | pecl install mcrypt-1.0.3
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/7.2/fpm/php.ini
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/7.2/cli/php.ini

          # Refresh services
          RESTART_SERVICES=scripts/restart.sh
          if test -f "$RESTART_SERVICES"; then
               source $RESTART_SERVICES
          else
               echo "${red}Cannot Restart Nginx And Nginx${end}"
               exit
          fi

          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "7.3" ]]; then
          apt-get install php7.3-dev -y
          apt-get -y install gcc make autoconf libc-dev pkg-config
          apt-get -y install libmcrypt-dev
          yes | pecl install mcrypt-1.0.3
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/7.3/fpm/php.ini
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/7.3/cli/php.ini

          # Refresh Nginx And PHP
          RESTART_SERVICES=scripts/restart.sh

          if test -f "$RESTART_SERVICES"; then
               source $RESTART_SERVICES
          else
               echo "${red}Cannot Restart Nginx And Nginx${end}"
               exit
          fi

          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "7.4" ]]; then
          apt-get install php-dev libmcrypt-dev php-pear -y
          pecl channel-update pecl.php.net
          yes | pecl install channel://pecl.php.net/mcrypt-1.0.4
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/7.4/fpm/php.ini
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/7.4/cli/php.ini

          # Refresh Nginx And PHP
          RESTART_SERVICES=scripts/restart.sh

          if test -f "$RESTART_SERVICES"; then
               source $RESTART_SERVICES
          else
               echo "${red}Cannot Restart Nginx And Nginx${end}"
               exit
          fi

          echo ""
          sleep 1


     elif [[ "${PHP_VERSION}" == "8.1" ]]; then
          apt-get install php-dev libmcrypt-dev php-pear -y
          pecl channel-update pecl.php.net
          yes | pecl install channel://pecl.php.net/mcrypt-1.0.5
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.1/fpm/php.ini
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.1/cli/php.ini

          RESTART_SERVICES=scripts/restart.sh
          if test -f "$RESTART_SERVICES"; then
               source $RESTART_SERVICES
          else
               echo "${red}Cannot Restart Nginx And Nginx${end}"
               exit
          fi

          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "8.2" ]]; then
          # PHP 8.2 support requires mcrypt 1.0.6.
          apt-get install php-dev libmcrypt-dev php-pear -y
          pecl channel-update pecl.php.net
          yes | pecl install channel://pecl.php.net/mcrypt-1.0.6
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.2/fpm/php.ini
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.2/cli/php.ini

          RESTART_SERVICES=scripts/restart.sh
          if test -f "$RESTART_SERVICES"; then
               source $RESTART_SERVICES
          else
               echo "${red}Cannot Restart Nginx And Nginx${end}"
               exit
          fi

          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "8.3" ]]; then
          # PHP 8.3 support requires mcrypt 1.0.7.
          apt-get install php-dev libmcrypt-dev php-pear -y
          pecl channel-update pecl.php.net
          yes | pecl install channel://pecl.php.net/mcrypt-1.0.7
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.3/fpm/php.ini
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.3/cli/php.ini

          RESTART_SERVICES=scripts/restart.sh
          if test -f "$RESTART_SERVICES"; then
               source $RESTART_SERVICES
          else
               echo "${red}Cannot Restart Nginx And Nginx${end}"
               exit
          fi

          echo ""
          sleep 1

     elif [[ "${PHP_VERSION}" == "8.4" ]]; then
          # PHP 8.4 support requires mcrypt 1.0.9, which adds compatibility with PHP 8.4/8.5.
          apt-get install php-dev libmcrypt-dev php-pear -y
          pecl channel-update pecl.php.net
          yes | pecl install channel://pecl.php.net/mcrypt-1.0.9
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.4/fpm/php.ini
          echo "extension=$MODULES/mcrypt.so" >>/etc/php/8.4/cli/php.ini

          RESTART_SERVICES=scripts/restart.sh
          if test -f "$RESTART_SERVICES"; then
               source $RESTART_SERVICES
          else
               echo "${red}Cannot Restart Nginx And Nginx${end}"
               exit
          fi

          echo ""
          sleep 1

     else
          echo -e "${red}Sorry, this script is designed for DEBIAN (10, 11, 12, 13) and UBUNTU (18.04, 20.04, 22.04, 22.10, 24.04)${end}"
          exit 1
     fi
}

# Run
install_mcrpyt
