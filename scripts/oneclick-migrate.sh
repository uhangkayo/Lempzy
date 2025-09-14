#!/bin/bash

# Ensure required commands are available
for cmd in mysqldump scp ssh; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd is required but not installed." >&2
    exit 1
  fi
done

# Expect domain name as first argument
if [[ -z "$1" ]]; then
  echo "Usage: $0 <domain>" >&2
  exit 1
fi

domainClear2="$1"
db="database_${domainClear2}"

# Verify database exists before dumping
if ! mysql -e "SHOW DATABASES LIKE '${db}'" | grep -q "${db}"; then
  echo "Error: Database '${db}' does not exist." >&2
  exit 1
fi

# Perform database dump (additional migration steps may follow)
mysqldump "${db}" > "${db}.sql"
# ... additional migration logic goes here ...
