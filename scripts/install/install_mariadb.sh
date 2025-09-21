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
    if [[ -z ${OS_ID:-} ]] || [[ -z ${OS_VERSION:-} ]]; then
        if [[ -r /etc/os-release ]]; then
            # shellcheck disable=SC1091
            . /etc/os-release
            OS_ID=${OS_ID:-${ID,,}}
            OS_VERSION=${OS_VERSION:-${VERSION_ID}}
            OS_CODENAME=${OS_CODENAME:-${VERSION_CODENAME:-}}
        fi

        if command -v lsb_release >/dev/null 2>&1; then
            [[ -z ${OS_ID:-} ]] && OS_ID=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
            [[ -z ${OS_VERSION:-} ]] && OS_VERSION=$(lsb_release -rs)
            [[ -z ${OS_CODENAME:-} ]] && OS_CODENAME=$(lsb_release -cs)
        fi
    fi

    [[ -n ${OS_ID:-} && -n ${OS_VERSION:-} ]]
}

determine_supported_mariadb_versions() {
    local -n _versions_ref=$1
    local -n _default_ref=$2
    local os_id="${OS_ID:-}"
    local os_version="${OS_VERSION:-}"

    case "$os_id" in
        debian)
            case "$os_version" in
                10)
                    _versions_ref=("10.6")
                    _default_ref="10.6"
                    ;;
                11)
                    _versions_ref=("10.6" "10.11" "11.4")
                    _default_ref="10.11"
                    ;;
                12)
                    _versions_ref=("10.6" "10.11" "11.4")
                    _default_ref="10.11"
                    ;;
                13)
                    _versions_ref=("11.4" "11.8")
                    _default_ref="11.4"
                    ;;
                *)
                    _versions_ref=("10.11")
                    _default_ref="10.11"
                    ;;
            esac
            ;;
        ubuntu)
            case "$os_version" in
                18.04)
                    _versions_ref=("10.6")
                    _default_ref="10.6"
                    ;;
                20.04)
                    _versions_ref=("10.6" "10.11")
                    _default_ref="10.11"
                    ;;
                22.04|22.10)
                    _versions_ref=("10.6" "10.11" "11.4")
                    _default_ref="10.11"
                    ;;
                24.04)
                    _versions_ref=("11.4" "11.8")
                    _default_ref="11.4"
                    ;;
                *)
                    _versions_ref=("10.11")
                    _default_ref="10.11"
                    ;;
            esac
            ;;
        *)
            _versions_ref=("10.11")
            _default_ref="10.11"
            ;;
    esac
}

is_supported_version() {
    local version="$1"
    shift
    for supported in "$@"; do
        if [[ "$version" == "$supported" ]]; then
            return 0
        fi
    done
    return 1
}

SUPPORTED_MARIADB_VERSIONS_ARR=()
if [[ -n ${SUPPORTED_MARIADB_VERSIONS:-} ]]; then
    read -r -a SUPPORTED_MARIADB_VERSIONS_ARR <<< "$SUPPORTED_MARIADB_VERSIONS"
fi

DEFAULT_MARIADB_VERSION_DETECTED=""

if [[ ${#SUPPORTED_MARIADB_VERSIONS_ARR[@]} -eq 0 ]]; then
    if ! detect_os_metadata; then
        echo "# [error] Unable to determine the operating system to validate the requested MariaDB version." >&2
        exit 1
    fi
    determine_supported_mariadb_versions SUPPORTED_MARIADB_VERSIONS_ARR DEFAULT_MARIADB_VERSION_DETECTED
fi

if [[ ${#SUPPORTED_MARIADB_VERSIONS_ARR[@]} -eq 0 ]]; then
    SUPPORTED_MARIADB_VERSIONS_ARR=("10.11")
    DEFAULT_MARIADB_VERSION_DETECTED="10.11"
fi

if [[ -z ${DEFAULT_MARIADB_VERSION:-} ]]; then
    if [[ -n ${DEFAULT_MARIADB_VERSION_DETECTED:-} ]]; then
        DEFAULT_MARIADB_VERSION="$DEFAULT_MARIADB_VERSION_DETECTED"
    else
        DEFAULT_MARIADB_VERSION="${SUPPORTED_MARIADB_VERSIONS_ARR[0]}"
    fi
fi

if [[ -z ${MARIADB_VERSION:-} ]]; then
    MARIADB_VERSION="$DEFAULT_MARIADB_VERSION"
fi

if ! is_supported_version "$MARIADB_VERSION" "${SUPPORTED_MARIADB_VERSIONS_ARR[@]}"; then
    SUPPORTED_MARIADB_VERSIONS_PRETTY=$(printf '%s, ' "${SUPPORTED_MARIADB_VERSIONS_ARR[@]}")
    SUPPORTED_MARIADB_VERSIONS_PRETTY=${SUPPORTED_MARIADB_VERSIONS_PRETTY%, }
    if [[ -n ${OS_ID:-} && -n ${OS_VERSION:-} ]]; then
        echo "# [error] MariaDB Server version ${MARIADB_VERSION} is not available for ${OS_ID^} ${OS_VERSION}." >&2
        echo "#         Supported MariaDB versions for this OS: ${SUPPORTED_MARIADB_VERSIONS_PRETTY}." >&2
    else
        echo "# [error] MariaDB Server version ${MARIADB_VERSION} is not supported by this installer." >&2
        echo "#         Supported MariaDB versions: ${SUPPORTED_MARIADB_VERSIONS_PRETTY}." >&2
    fi
    exit 1
fi

# Install MariaDB server
install_mariadb() {
    echo "${grn}Installing MariaDB ${MARIADB_VERSION} ...${end}"
    echo ""
    sleep 3
    apt-get update
    apt-get install -y curl gnupg
    curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash -s -- --mariadb-server-version="mariadb-${MARIADB_VERSION}" --skip-maxscale --skip-tools
    apt-get update
    apt-get install -y mariadb-server
    echo ""
    sleep 1
}

# Run
install_mariadb
