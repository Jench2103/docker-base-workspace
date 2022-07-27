# Docker Base Workspace
A dockerized [Ubuntu 20.04](https://hub.docker.com/_/ubuntu/) base workspace with [Python 3.8](https://packages.ubuntu.com/focal/python3.8) installed.

## Table of Contents
- [User Guides](#user-guides)
- [Developer Guides](#developer-guides)
    - [File Structure](#file-structure)
    - [Install Packages](#install-packages)
    - [Uses of the Scripts in the Workspace](#uses-of-the-scripts-in-the-workspace)

## User Guides
- Use `run` to manage the Docker image and container of this workspace.
    ```
    $ bash run

        This script will help you manage the Docker Base Workspace.
        You can execute this script with the following options.

        --start     : build and enter the workspace
        --stop      : stop and exit the workspace
        --prune     : remove the docker image
        --rebuild   : remove and build a new image to apply new changes
    ```
- `bash run --start`
    - First execution: Build the Docker image, create a container, and enter the terminal.
    - Image exists but no running container: Create a container and enter the terminal.
    - Container is running: Enter the terminal.
- Users can put all permanent files in `~/projects` of the workspace, which is mounted to `docker-base-workspace/projects` on the host machine.
- The container won't be stopped after type `exit` in the last terminal of the workspace. Users should also use `bash run --stop` command on the host machine to stop and remove the container.

## Developer Guides
### File Structure
```
docker-base-workspace/
├── Dockerfile
├── config/
│   └── requirements.txt
├── run
└── scripts/
    ├── .bashrc
    ├── login.sh
    ├── start.sh
    └── startup.sh
```

### Install Packages
- System packages: Customize the `apt-get install` commands in [`Dockerfile`](Dockerfile).
- Python packages: Add packages' names (and versions) into [`config/requirements.txt`](config/requirements.txt).

### Uses of the Scripts in the Workspace
- [`scripts/start.sh`](scripts/start.sh): Execute when the container start, should be blocked before reach the end.
- [`scripts/login.sh`](scripts/login.sh): Execute whenever the user start new bash terminals, must make sure it can reach the end.
- [`scripts/startup.sh`](scripts/startup.sh): Execute when the user type 'startup' anywhere in the container.
