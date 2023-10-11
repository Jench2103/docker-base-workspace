# Docker Base Workspace
A dockerized [Ubuntu 20.04](https://hub.docker.com/_/ubuntu/) workspace template with [Python 3.8](https://packages.ubuntu.com/focal/python3.8) installed.

## Table of Contents <!-- omit in toc -->
- [Quick Reference](#quick-reference)
- [User Guides](#user-guides)
    - [Using Pre-built Images without Modification](#using-pre-built-images-without-modification)
    - [Using as a Base Image](#using-as-a-base-image)
    - [Build Images from Source Code](#build-images-from-source-code)
    - [Build Images and Push to DockerHub](#build-images-and-push-to-dockerhub)
    - [Common Instructions](#common-instructions)
- [Create Your Own Docker Workspace](#create-your-own-docker-workspace)
    - [File Structure](#file-structure)
    - [User Account in Container](#user-account-in-container)
    - [Install Packages](#install-packages)
    - [Uses of the Scripts in the Workspace](#uses-of-the-scripts-in-the-workspace)

## Quick Reference
- GitHub: https://github.com/Jench2103/docker-base-workspace
- Docker Hub: https://hub.docker.com/r/jench2103/docker-base-workspace

## User Guides
In the GitHub repo, there is a script `run` which can help you manage the worspace easily. Note that if you are working on Windows systems, use the following commands in Bash-like shells such as [Git Bash](https://git-scm.com/download/win).

```shell
$ git clone https://github.com/Jench2103/docker-base-workspace.git

$ cd /path/to/docker-base-workspace
$ bash run

    This script will help you manage the Docker Base Workspace.
    You can execute this script with the following options.

    pull            : pull the latest official image from DockerHub
    build           : build a new image on this machine
    build-registry  : build images with specified platforms and push to DockerHub
    start           : pull and enter the workspace
    stop            : stop and exit the workspace
    prune           : remove the docker image
    repull          : remove the existing image and pull the latest one to apply new changes
    rebuild         : remove the existing image and build a new one to apply new changes
```

### Using Pre-built Images without Modification
```shell
$ bash run start
```

Use this command to close and remove a running container.
```shell
$ bash run stop
```

### Using as a Base Image
Import this image into your dockerfile with the following statement.
```dockerfile
FROM jench2103/docker-base-workspace
```

### Build Images from Source Code
```shell
$ bash run build
```

To remove an existing image for further rebuilding, use the following command. Note that this command will stop existing containers before removing images.
```shell
$ bash run prune
```

### Build Images and Push to DockerHub
```shell
$ bash run build-registry
```

### Common Instructions
- The `bash run start` command can perform different tasks for you depending on the actual situation.
    - First execution: Pull the Docker image, create a container, and enter the terminal.
    - Image exists but no running container: Create a container and enter the terminal.
    - Container is running: Enter the terminal.
- Users can put all permanent files in `~/projects` of the workspace, which is mounted to `docker-base-workspace/projects` on the host machine.
- The container won't be stopped after type `exit` in the last terminal of the workspace. Users should also use `bash run stop` command on the host machine to stop and remove the container.

## Create Your Own Docker Workspace
This repository is a GitHub template. Feel free to create your own Docker Workspace repository by clicking the `Use this template` button, then customize the setup and configurations to meet your requirements according to the following descriptions. For the detail about GitHub template, see [Creating a repository from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template).

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

### User Account in Container
- The User ID (UID) and Group ID (GID) of the default user in the container will be synchronized as host operating system.
- The User Name will be synchronized only if the image is built by your own machine.
- The Group Name would not be synchronized because some operating systems (e.g. MS Windows) does not have this information.

### Install Packages
- System packages: Customize the `apt-get install` commands in [`Dockerfile`](https://github.com/Jench2103/docker-base-workspace/blob/main/Dockerfile). Use flag `-qq` to make installation processes quiet and assume `yes` for questions by default.
- Python packages: Add package names (and versions) into [`config/requirements.txt`](https://github.com/Jench2103/docker-base-workspace/blob/main/config/requirements.txt).

### Uses of the Scripts in the Workspace
- [`scripts/start.sh`](https://github.com/Jench2103/docker-base-workspace/blob/main/scripts/start.sh): Execute when the container start, should be blocked before reach the end.
- [`scripts/login.sh`](https://github.com/Jench2103/docker-base-workspace/blob/main/scripts/login.sh): Execute whenever the user start new bash terminals, must make sure it can reach the end.
- [`scripts/startup.sh`](https://github.com/Jench2103/docker-base-workspace/blob/main/scripts/startup.sh): Execute when the user type 'startup' anywhere in the container.
