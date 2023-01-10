#!/bin/bash

# This script will be executed while the container is starting.

# configure the UID and GID of the user in container to match the host system
if [[ ${USERID} != "" && ${USERID} != "$(id -u)" ]]; then
    # change the owner and permission of volume folders
    sudo chown -R "${USERID}":"${GROUPID}" "/home/$(id -un)/.ssh"
    sudo chmod 755 "/home/$(id -un)/.ssh" && sudo chmod 644 "/home/$(id -un)/.ssh"/*
    [[ -f "/home/$(id -un)/.ssh/id_rsa" ]] && sudo chmod 600 "/home/$(id -un)/.ssh/id_rsa"
    sudo chown "${USERID}":"${GROUPID}" "/home/$(id -un)/.vscode-server" && sudo chmod 755 "/home/$(id -un)/.vscode-server"
    sudo chown "${USERID}":"${GROUPID}" "/home/$(id -un)/projects" && sudo chmod 755 "/home/$(id -un)/projects"

    # change the owner of home directory
    sudo chown "${USERID}":"${GROUPID}" "/home/$(id -un)"
    sudo chown "${USERID}":"${GROUPID}" "/home/$(id -un)/.bash_logout" "/home/$(id -un)/.bashrc" "/home/$(id -un)/.profile"

    sudo sed -i s/"user:x:1000:1000::"/"user:x:${USERID}:${GROUPID}::"/g "/etc/passwd"
else
    # change owner and permission of volume folders
    sudo chown -R "$(id -u)":"$(id -g)" "/home/$(id -un)/.ssh"
    chmod 755 "/home/$(id -un)/.ssh" && chmod 644 "/home/$(id -un)/.ssh"/*
    [[ -f "/home/$(id -un)/.ssh/id_rsa" ]] && chmod 600 "/home/$(id -un)/.ssh/id_rsa"
    sudo chown "$(id -u)":"$(id -g)" "/home/$(id -un)/.vscode-server" && chmod 755 "/home/$(id -un)/.vscode-server"
    sudo chown "$(id -u)":"$(id -g)" "/home/$(id -un)/projects" && chmod 755 "/home/$(id -un)/projects"
fi

# keep the container running
tail -f /dev/null
