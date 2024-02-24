#!/bin/bash

# This script will be executed while the container is starting.

USERID=${USERID:-"$(id -u)"}
GROUPID=${GROUPID:-"$(id -g)"}

# change the ownership of the home directory
if [[ ${USERID} != "$(id -u)" || ${GROUPID} != "$(id -g)" ]]; then
    for file in "/home/$(id -un)"/.[!.]* "/home/$(id -un)"/*; do
        sudo chown "${USERID}":"${GROUPID}" "${file}"
    done
    sudo chown "${USERID}":"${GROUPID}" "/home/$(id -un)"
fi

# configure the GID of the user in container to match the host system
if [[ ${GROUPID} != "$(id -g)" ]]; then
    if [[ $(getent group "${GROUPID}") == "" ]]; then
        sudo groupmod -g "${GROUPID}" "$(id -gn)"
    else
        sudo usermod -aG "$(getent group "${GROUPID}" | cut -d: -f1)" "$(id -un)"
        sudo usermod -g "$(getent group "${GROUPID}" | cut -d: -f1)" "$(id -un)"
    fi
fi

# configure the UID of the user in container to match the host system
if [[ ${USERID} != "" && ${USERID} != "$(id -u)" ]]; then
    sudo usermod -u "${USERID}" "$(id -un)"
fi

# create a file to indicate this script has finished
touch /docker/start.sh.done

# keep the container running
tail -f /dev/null
