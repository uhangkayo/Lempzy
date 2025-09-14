Domain Menu

## One-Click Migrate

`oneclick-migrate.sh` will:

1. Ask for the domain name on the current server.
2. Ask for the remote SSH username and server (IP or hostname).
3. Archive `/var/www/<domain>` and dump `database_<domain>` with `mysqldump`.
4. Transfer the archive to the destination server via `scp` and trigger `remote-restore.sh` over `ssh`.

The destination server must allow SSH access for the provided user and have MySQL/MariaDB installed. The script copies `remote-restore.sh` automatically; it extracts the archive and imports the database into `database_<domain>`.

The restore script uses `sudo` for privileged operations when the remote user is not root, so ensure the SSH user has passwordless sudo rights.
