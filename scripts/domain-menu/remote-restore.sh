#!/bin/bash
# Restore website data from a remote backup archive.
# Usage: remote-restore.sh DOMAIN REMOTE_ARCHIVE

set -e

# Use sudo for privileged operations when not executed as root
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

DOMAIN="$1"
REMOTE_ARCHIVE="$2"

if [ -z "$DOMAIN" ] || [ -z "$REMOTE_ARCHIVE" ]; then
    echo "Usage: $0 DOMAIN REMOTE_ARCHIVE"
    exit 1
fi

TMP_ZIP="/tmp/${DOMAIN}-backup.zip"

# Copy the remote archive to a temporary location
scp "$REMOTE_ARCHIVE" "$TMP_ZIP"

# Ensure target directory exists
$SUDO mkdir -p "/var/www/$DOMAIN"

# Extract the archive into the domain directory
$SUDO unzip -o "$TMP_ZIP" -d "/var/www/$DOMAIN"

# Fix permissions
$SUDO chown -R www-data:www-data "/var/www/$DOMAIN"

# Clean up temporary file
rm -f "$TMP_ZIP"

echo "Restoration complete for $DOMAIN"
