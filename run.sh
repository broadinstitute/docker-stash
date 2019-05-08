#!/bin/bash

if [ -z "${PROXY_NAME}" ]; then
    export PROXY_NAME='stash'
fi

if [ -z "${PROXY_PORT}" ]; then
    export PROXY_PORT='80'
fi

# Configs to mess with
/usr/local/bin/configs.sh

RETCODE=$?
if [ $RETCODE -ne 0 ]; then
    echo "Unable to setup config files"
    exit $RETCODE
fi

exec /opt/atlassian/stash/bin/start-stash.sh -fg 2>&1
