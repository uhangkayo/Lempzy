#!/bin/bash

# Restore a domain's web files from a remote source.
# The actual transfer of files should leave a directory
# named after the domain in the current working directory.
# This script moves that directory into /var/www after
# confirming that it will not overwrite existing data.

set -e

# Require running as root for moving into /var/www
if [ "$(whoami)" != 'root' ]; then
    echo "You have no permission to run $0 as non-root user. Use sudo"
    exit 1
fi

domain="$1"

if [ -z "$domain" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Ensure we are working with a directory named after the domain
if [ ! -d "$domain" ]; then
    echo "Directory '$domain' not found in current location."
    exit 1
fi

# Check if the domain already exists in /var/www
if [ -e "/var/www/$domain" ]; then
    read -p "/var/www/$domain already exists. Overwrite? [y/N]: " confirm
    case "$confirm" in
        [yY][eE][sS]|[yY])
            echo "Overwriting existing directory..."
            rm -rf "/var/www/$domain"
            ;;
        *)
            echo "Aborted. No changes made."
            exit 1
            ;;
    esac
fi

mv "$domain" /var/www/

echo "Domain restored to /var/www/$domain"
