#!/bin/sh
set -e

LOCAL_CONFIG="/opt/fm-dx-webserver/config/config.json"

if ! [ -e "$LOCAL_CONFIG" ]; then
    cp /opt/fm-dx-webserver/config.json-example "$LOCAL_CONFIG"
fi

# Update values in configuration
jq --arg contact "$FMDX_CONTACT" \
    --arg fmdxPassword "$FMDX_ADMIN_PASSWORD" \
    --arg fmdxTunerDesc "$FMDX_TUNER_DESC" \
    --arg fmdxTunerName "$FMDX_TUNER_NAME" \
    --arg proxyIp "$FMDX_PROXY_IP" \
    --arg webserverPort "$FMDX_WEB_PORT" \
    --arg xdrdIp "$XDRD_HOST" \
    --arg xdrdPassword "$XDRD_PASSWORD" \
    --arg xdrdPort "$XDRD_TCP_PORT" \
    '.identification.contact = $contact |
    .identification.proxyIp = $proxyIp |
    .identification.tunerDesc = $fmdxTunerDesc |
    .identification.tunerName = $fmdxTunerName |
    .password.adminPass = $fmdxPassword |
    .webserver.webserverPort = $webserverPort |
    .xdrd.wirelessConnection = true |
    .xdrd.xdrdIp = $xdrdIp |
    .xdrd.xdrdPassword = $xdrdPassword |
    .xdrd.xdrdPort = $xdrdPort' \
    "$LOCAL_CONFIG" >/tmp/tmp.json && mv /tmp/tmp.json "$LOCAL_CONFIG"

exec /usr/local/bin/node index.js --config "config/$(basename "$LOCAL_CONFIG" .json)"
