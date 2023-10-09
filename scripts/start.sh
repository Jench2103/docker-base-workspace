#!/bin/bash

# This script will be executed while the container is starting.

# change the ownership of the home directory
sudo chown -R "${USERID}":"${GROUPID}" "/home/$(id -un)"

# configure the GID of the user in container to match the host system
if [[ ${GROUPID} != "" && ${GROUPID} != "$(id -g)" ]]; then
    sudo groupmod -g "${GROUPID}" "$(id -gn)"
fi

# configure the UID of the user in container to match the host system
if [[ ${USERID} != "" && ${USERID} != "$(id -u)" ]]; then
    sudo usermod -u "${USERID}" "$(id -un)"
fi

# keep the container running
tail -f /dev/null
