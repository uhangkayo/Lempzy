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

detect_os_metadata() {
    if [[ -r /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        OS_ID=${ID,,}
        OS_VERSION=${VERSION_ID}
    fi

    if command -v lsb_release >/dev/null 2>&1; then
        [[ -z ${OS_ID:-} ]] && OS_ID=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
        [[ -z ${OS_VERSION:-} ]] && OS_VERSION=$(lsb_release -rs)
    fi

    if [[ -z ${OS_ID:-} ]] || [[ -z ${OS_VERSION:-} ]]; then
        return 1
    fi

    export OS_ID OS_VERSION
    return 0
}

if [[ -z ${OS_ID:-} ]] || [[ -z ${OS_VERSION:-} ]]; then
    detect_os_metadata || {
        echo -e "${red}Unable to determine the operating system. Aborting update.${end}"
        exit 1
    }
fi

# Update os
update_os() {
     echo "${grn}Starting update os ...${end}"
     echo ""
     sleep 3
     # Disable needrestart to avoid interactive prompts on supported Ubuntu versions.
     # The needrestart package may not be installed on some systems, so ignore errors.
     if [[ "${OS_VERSION}" == "22.04" ]] || [[ "${OS_VERSION}" == "22.10" ]] || [[ "${OS_VERSION}" == "24.04" ]]; then
          if [ -f /etc/needrestart/needrestart.conf ]; then
               sed -i 's/#$nrconf{restart} = '\''i'\'';/$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf || true
               sudo apt -y remove needrestart || true
          fi
     fi

     # Always update the package list
     apt update

     # Use non‑interactive upgrades on recent Debian releases to avoid prompts.
     if [[ "${OS_VERSION}" == "11" ]] || [[ "${OS_VERSION}" == "12" ]] || [[ "${OS_VERSION}" == "13" ]]; then
          sudo DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade
     else
          apt upgrade -y
     fi

     echo ""
     sleep 1
}

# Run
update_os
