#!/bin/bash

# Script author: Muhamad Miguel Emmara
# Script site: https://www.miguelemmara.me
# Lempzy - One Click LEMP Server Stack Installation Script
#--------------------------------------------------
# Installation List:
# Nginx
# MariaDB (We will use MariaDB as our database)
# PHP
# UFW Firewall
# Memcached
# FASTCGI_CACHE
# IONCUBE
# MCRYPT
# HTOP
# NETSTAT
# OPEN SSL
# AB BENCHMARKING TOOL
# ZIP AND UNZIP
# FFMPEG AND IMAGEMAGICK
# CURL
# GIT
# COMPOSER
#--------------------------------------------------

set -e

# Colours
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

# Detect the operating system version.  In addition to the historical
# releases that Lempzy supported (Debian 10/11 and Ubuntu 18.04/20.04/22.04/22.10),
# we now support newer Debian (12 and 13) and Ubuntu (24.04) releases.
OS_VERSION=$(lsb_release -rs)

# Reject unsupported versions early.  Note that we treat Debian releases as
# integer strings (e.g. "12") and Ubuntu releases as dotted strings
# (e.g. "24.04").  If your version isn't recognised here, the installer
# will abort with a friendly message.  Update this list when adding
# support for new distributions.
if [[ "${OS_VERSION}" != "10" ]] && [[ "${OS_VERSION}" != "11" ]] && \
   [[ "${OS_VERSION}" != "12" ]] && [[ "${OS_VERSION}" != "13" ]] && \
   [[ "${OS_VERSION}" != "18.04" ]] && [[ "${OS_VERSION}" != "20.04" ]] && \
   [[ "${OS_VERSION}" != "22.04" ]] && [[ "${OS_VERSION}" != "22.10" ]] && \
   [[ "${OS_VERSION}" != "24.04" ]]; then
     echo -e "${red}Sorry, this script is designed for DEBIAN (10, 11, 12, 13) and UBUNTU (18.04, 20.04, 22.04, 22.10, 24.04)${end}"
     exit 1
fi

# To ensure script run as root
if [ "$EUID" -ne 0 ]; then
     echo "${red}Please run this script as root user${end}"
     exit 1
fi

### Greetings
clear
echo ""
echo "******************************************************************************************"
echo " *   *    *****     ***     *   *    *****    *        *****    *****     ***     *   * "
echo " *   *      *      *   *    *   *    *        *          *      *        *   *    *   * "
echo " ** **      *      *        *   *    *        *          *      *        *        *   * "
echo " * * *      *      * ***    *   *    ****     *          *      ****     *        ***** "
echo " *   *      *      *   *    *   *    *        *          *      *        *        *   * "
echo " *   *      *      *   *    *   *    *        *          *      *        *   *    *   * "
echo " *   *    *****     ***      ***     *****    *****      *      *****     ***     *   * "
echo "******************************************************************************************"
echo ""

# Prompt for component versions and selections
read -p "Enter desired PHP version (e.g. 8.2) [default: 8.2]: " PHP_VERSION
PHP_VERSION=${PHP_VERSION:-8.2}
export PHP_VERSION

read -p "Choose database engine (mariadb/mysql) [mariadb]: " DB_ENGINE
DB_ENGINE=${DB_ENGINE,,}
DB_ENGINE=${DB_ENGINE:-mariadb}
if [[ "$DB_ENGINE" == "mysql" ]]; then
    read -p "Enter MySQL version (e.g. 8.0) [default: 8.0]: " MYSQL_VERSION
    MYSQL_VERSION=${MYSQL_VERSION:-8.0}
    export MYSQL_VERSION
else
    read -p "Enter MariaDB version (e.g. 10.11) [default: 10.11]: " MARIADB_VERSION
    MARIADB_VERSION=${MARIADB_VERSION:-10.11}
    export MARIADB_VERSION
fi

confirm_step() {
    while true; do
        read -r -p "$1 [y/n]: " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

run_step() {
    local action="$1"
    local script_path="$2"
    if test -f "$script_path"; then
        if confirm_step "Proceed with $action?"; then
            source "$script_path"
            cd && cd Lempzy
        else
            echo "Skipping $action"
        fi
    else
        echo "${red}Cannot $action${end}"
        exit 1
    fi
}

# Run installation steps with confirmations
run_step "Update OS" scripts/install/update_os.sh
run_step "Install UFW Firewall" scripts/install/install_firewall.sh
if [[ "$DB_ENGINE" == "mysql" ]]; then
    run_step "Install MySQL" scripts/install/install_mysql.sh
else
    run_step "Install MariaDB" scripts/install/install_mariadb.sh
fi
run_step "Install PHP" scripts/install/install_php.sh
run_step "Install Nginx" scripts/install/install_nginx.sh
run_step "Install Memcached" scripts/install/install_memcached.sh
run_step "Install Ioncube" scripts/install/install_ioncube.sh
run_step "Install Mcrypt" scripts/install/install_mcrpyt.sh
run_step "Install HTOP" scripts/install/install_htop.sh
run_step "Install Netstat" scripts/install/install_netstat.sh
run_step "Install OpenSSL" scripts/install/install_openssl.sh
run_step "Install AB BENCHMARKING TOOL" scripts/install/install_ab.sh
run_step "Install ZIP AND UNZIP" scripts/install/install_zips.sh
run_step "Install FFMPEG and IMAGEMAGICK" scripts/install/install_ffmpeg.sh
run_step "Install Git And Curl" scripts/install/install_git.sh
run_step "Install Composer" scripts/install/install_composer.sh

# Change Login Greeting
change_login_greetings() {
    echo "${grn}Change Login Greeting ...${end}"
    echo ""
    sleep 3

cd ~
cat > .bashrc << EOF
echo "########################### SERVER CONFIGURED BY LEMPZY ###########################"
echo " ######################## FULL INSTRUCTIONS GO TO MIGUELEMMARA.ME ####################### "
echo ""
echo "     __                                    "
echo "    / /   ___  ____ ___  ____  ____  __  __"
echo "   / /   / _ \/ __ \\\`__ \/ __ \/_  / / / / /"
echo "  / /___/  __/ / / / / / /_/ / / /_/ /_/ /"
echo " /_____/\___/_/ /_/ /_/ .___/ /___/\__, /"
echo "                   /_/          /____/_/"
echo ""
./lempzy.sh
EOF

    echo ""
    cd && cd Lempzy
    sleep 1
}

change_login_greetings

# Menu Script Permission Setting
cp scripts/lempzy.sh /root
dos2unix /root/lempzy.sh
chmod +x /root/lempzy.sh

# Success Prompt
clear
echo "Lemzpy - LEMP Auto Installer BY Miguel Emmara $(date)"
echo "******************************************************************************************"
echo "              *   *    *****    *         ***      ***     *   *    ***** 	"
echo "              *   *    *        *        *   *    *   *    *   *    *		"
echo "              *   *    *        *        *        *   *    ** **    *		"
echo "              *   *    ****     *        *        *   *    * * *    ****	"
echo "              * * *    *        *        *        *   *    *   *    *		"
echo "              * * *    *        *        *   *    *   *    *   *    *		"
echo "               * *     *****    *****     ***      ***     *   *    *****	"
echo ""

echo "		                  *****     ***	"
echo "			      	    *      *   *	"
echo "			      	    *      *   *	"
echo "			      	    *      *   *	"
echo "			      	    *      *   *	"
echo "			      	    *      *   *	"
echo "			      	    *       ***	"
echo ""

echo " *   *    *****     ***     *   *    *****    *        *****    *****     ***     *   * "
echo " *   *      *      *   *    *   *    *        *          *      *        *   *    *   * "
echo " ** **      *      *        *   *    *        *          *      *        *        *   * "
echo " * * *      *      * ***    *   *    ****     *          *      ****     *        ***** "
echo " *   *      *      *   *    *   *    *        *          *      *        *        *   * "
echo " *   *      *      *   *    *   *    *        *          *      *        *   *    *   * "
echo " *   *    *****     ***      ***     *****    *****      *      *****     ***     *   * "
echo "*************** OPEN MENU BY TYPING ${grn}./lempzy.sh${end} IN ROOT DIRECTORY ************************"
echo ""

exit
