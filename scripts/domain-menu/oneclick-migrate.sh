#!/bin/bash

# Script author: Muhamad Miguel Emmara
# One click migrate domain and database to remote server

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
domain2=$2
remote_user=$3
remote_host=$4
domainRegex="^[a-zA-Z0-9]"

# Ask the user to add domain name and remote server info
while true; do
     clear
     echo "########################### SERVER CONFIGURED BY MIGUEL EMMARA ###########################"
     echo "                              ${grn}ONE CLICK MIGRATION${end}"
     echo ""
     echo "     __                                    "
     echo "    / /   ___  ____ ___  ____  ____  __  __"
     echo "   / /   / _ \\/ __ \`__ \\/ __ \\/_  / / / / /"
     echo "  / /___/  __/ / / / / / /_/ / / /_/ /_/ /"
     echo " /_____/\\___/_/ /_/ /_/ .___/ /___/\\__, /"
     echo "                   /_/          /____/_/"
     echo ""
     echo "${grn}Press [CTRL + C] to cancel...${end}"
     echo ""
     echo "${blu}This option will migrate your domain and database to another server${end}"
     echo "Here all the domain on you server"
     echo ""
     echo "_____________"
     echo "${blu}"
     ls -I default -I phpmyadmin -I filemanager -1 /etc/nginx/sites-enabled/
     echo "${end}_____________"
     echo ""
     read -p ${grn}"Please provide domain${end}: " domain
     read -p ${grn}"Please type your domain one more time${end}: " domain2
     echo
     [ "$domain" = "$domain2" ] && break
     echo "Domain you provide does not match, please try again!"
     read -p "${grn}Press [Enter] key to continue...${end}" readEnterKey
done

until [[ $domain =~ $domainRegex ]]; do
     echo -n "Enter valid domain: "
     read domain
done

# Remote info
read -p ${grn}"Remote SSH username${end}: " remote_user
read -p ${grn}"Remote server (IP or hostname)${end}: " remote_host

# Check if domain is not there
check_domain_exist() {
     FILE=/etc/nginx/sites-available/$domain
     file2=/var/www/$domain
     if [ -f "$FILE" ] || [ -f "$file2" ]; then
          clear
     else
          echo ""
          echo "$domain does not exist, please try again"
          exit
     fi
}

# Archive domain and database
create_archive() {
     domainClear=${domain//./}
     domainClear2=${domainClear//-/}
     tmpdir=$(mktemp -d)
     mysqldump database_$domainClear2 > "$tmpdir/db.sql"
     cp -r /var/www/$domain "$tmpdir/"
     tar -czf /tmp/${domainClear2}-migrate.tar.gz -C "$tmpdir" .
     rm -rf "$tmpdir"
}

# Transfer archive and run remote restore
transfer_remote() {
     domainClear=${domain//./}
     domainClear2=${domainClear//-/}
     scp /tmp/${domainClear2}-migrate.tar.gz $remote_user@$remote_host:~/
     scp /root/Lempzy/scripts/domain-menu/remote-restore.sh $remote_user@$remote_host:~/
     ssh $remote_user@$remote_host "bash remote-restore.sh $domain ${domainClear2}-migrate.tar.gz"
     rm -f /tmp/${domainClear2}-migrate.tar.gz
}

# Run
check_domain_exist
create_archive
transfer_remote

# Success Prompt
clear
echo "Script By"
echo ""
echo "     __                                    "
echo "    / /   ___  ____ ___  ____  ____  __  __"
echo "   / /   / _ \\/ __ \`__ \\/ __ \\/_  / / / / /"
echo "  / /___/  __/ / / / / / /_/ / / /_/ /_/ /"
echo " /_____/\\___/_/ /_/ /_/ .___/ /___/\\__, /"
echo "                   /_/          /____/_/"
echo ""
echo "${blu}Migration to $remote_host completed for domain $domain${end}"

echo ""
