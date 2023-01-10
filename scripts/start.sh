#!/bin/bash

# This script will be executed while the container is starting.

# change owner and permission of volume folders
sudo chown -R "$(id -u)":"$(id -g)" "/home/$(id -un)/.ssh"
chmod 755 "/home/$(id -un)/.ssh" && chmod 644 "/home/$(id -un)/.ssh"/*
[[ -f "/home/$(id -un)/.ssh/id_rsa" ]] && chmod 600 "/home/$(id -un)/.ssh/id_rsa"
sudo chown "$(id -u)":"$(id -g)" "/home/$(id -un)/.vscode-server" && chmod 755 "/home/$(id -un)/.vscode-server"
sudo chown "$(id -u)":"$(id -g)" "/home/$(id -un)/projects" && chmod 755 "/home/$(id -un)/projects"

# keep the container running
tail -f /dev/null
