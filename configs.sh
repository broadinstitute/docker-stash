#!/bin/bash

set -e

SETENV='/opt/atlassian/stash/bin/setenv.sh'
SERVER_XML='/opt/atlassian/stash/conf/server.xml'

export JAVA_XMS="${JAVA_XMS:-512m}"
export JAVA_XMX="${JAVA_XMX:-1024m}"

sed -e "s/^JVM_MINIMUM_MEMORY=.*$/JVM_MINIMUM_MEMORY=\"${JAVA_XMS}\"/;s/^JVM_MAXIMUM_MEMORY=.*$/JVM_MAXIMUM_MEMORY=\"${JAVA_XMX}\"/" "${SETENV}.orig" > "$SETENV"

xmlstarlet c14n --without-comments ${SERVER_XML}.orig | \
    xmlstarlet ed \
        -i '/Server/Service/Connector[1]' -t attr -n 'scheme' -v 'http' \
        -i '/Server/Service/Connector[1]' -t attr -n 'proxyName' -v "${PROXY_NAME}" \
        -i '/Server/Service/Connector[1]' -t attr -n 'proxyPort' -v "${PROXY_PORT}" | \
    xmlstarlet fo -s 2 > $SERVER_XML
