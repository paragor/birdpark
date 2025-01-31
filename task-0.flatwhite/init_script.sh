#!/bin/sh
set -ex

if [ "x$OWN_NETWORK" -eq "x" ]; then
  echo "OWN_NETWORK is not set"
  exit 1
fi


ip link show dummy0 || ip link add dummy0 type dummy
ip addr del "$OWN_NETWORK" dev dummy0 || echo "its ok, lets bind address"
ip addr add "$OWN_NETWORK" dev dummy0
ip link set dummy0 up

bird -c /bird.conf
exec "$@"