#!/bin/bash

set -eo pipefail
shopt -s nullglob

if [[ "${1:0:1}" = '-' ]]; then
    set -- asterisk "$@"
fi

chown -R asterisk:asterisk /var/lib/asterisk/db
chown -R asterisk:asterisk /var/log/asterisk
chown -R asterisk:asterisk /var/spool/asterisk

if [[ "${1}" = "asterisk" ]]; then
    if [[ "$(id -u)" = "0" ]]; then
        exec gosu asterisk "$@"
    fi

    exec asterisk "$@"
fi

exec "$@"
