#!/bin/sh
set -e
exec  /opt/xdrd/xdrd -s "/dev/ttyUSB0" -t "${XDRD_TCP_PORT}" -p "${XDRD_PASSWORD}"
