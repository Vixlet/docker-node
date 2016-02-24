# Node Docker Image

[![Build Status](https://travis-ci.org/Vixlet/docker-node.svg?branch=master)](https://travis-ci.org/Vixlet/docker-node)

A configurable Docker container for running Node; designed for use with AWS ElasticBeanstalk! :P


## Table of Contents
- [Overview](#overview)
- [Base Docker Image](#basedockerimage)
- [Usage](#usage)
    + [Run in background](#runinbackground)
    + [Run interactively](#runinteractively)
    + [Run with custom container commands](#runwithcustomcontainercommands)
    + [Hooking into container pre-start](#hookingintocontainerprestart)
    + [Bypassing auto-pre-installation](#bypassingautopreinstallation)
    + [Environment variables](#environmentvariables)
- [License](#license)


## Overview
This is a minimal Docker image for running Node in a customizable manner, by making use of a bash script with hooks as the container's entrypoint. This container supports arbitrary methods of starting your node process, as well as auto-pre-installation of npm dependencies prior to startup. It's meant primarily as a workaround for AWS ElasticBeanstalk's lack of a way to specify a `run` command for a Docker container, and is intended for the nodejs app to be included via a docker-mounted directory to `/var/app`.


## Base Docker Image
- [node:0.10.42](https://registry.hub.docker.com/u/library/node/)
    + [Node Official Dockerfile](https://github.com/joyent/docker-node/blob/master/0.10/Dockerfile)
- [node:0.12.10](https://registry.hub.docker.com/u/library/node/)
    + [Node Official Dockerfile](https://github.com/joyent/docker-node/blob/master/0.12/Dockerfile)
- [node:4.3.1](https://registry.hub.docker.com/u/library/node/)
    + [Node Official Dockerfile](https://github.com/joyent/docker-node/blob/master/4.3/Dockerfile)
- [node:5.7.0](https://registry.hub.docker.com/u/library/node/)
    + [Node Official Dockerfile](https://github.com/joyent/docker-node/blob/master/5.7/Dockerfile)


## Usage
1. If you haven't already, install [Docker](https://www.docker.com/)
2. Pull the [latest stable automated build](https://registry.hub.docker.com/u/vixlet/node/) from [DockerHub](https://registry.hub.docker.com/u/):
    `docker pull vixlet/node:stable`
3. Run!

### Run in background
```sh
docker run -d \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    --name "vixlet-node-example" \
    vixlet/node:latest
```

### Run interactively
```sh
docker run -it --rm \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    --name "vixlet-node-example" \
    vixlet/node:latest
```

### Run with custom container commands
```sh
#### START WITH A CUSTOM NPM SCRIPT
docker run -it --rm \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    --name "vixlet-node-example" \
    vixlet/node:latest \
    npm run my-custom-start-script

#### START WITH ANY ARBITRARY COMMAND
docker run -it --rm \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    --name "vixlet-node-example" \
    vixlet/node:latest \
    /bin/bash
```

### Hooking into container pre-start
A custom pre-start script can be provided to handle any tasks prior to the container starting. To use a pre-start script, include an executable file in your application named **`docker-prestart.sh`**.

> _Alternatively, you can use an arbitrarily-named pre-start script by defining the environment variable `CONTAINER_PRESTART`._

### Bypassing auto-pre-installation
Setting the environment variable `CONTAINER_PREINSTALL` to `"skip"` will bypass the npm installation step of the container entrypoint script.


## Environment variables
| Variable Name | Default Value | Description |
| ------------- | ------------- | ----------- |
| **`CONTAINER_PREINSTALL`** | `"npm install --production --no-bin-links"` | Command used to install npm dependencies; set to `"skip"` to bypass installation step |
| **`CONTAINER_PRESTART`** | `"/var/app/docker-prestart.sh"` | Command to run prior to starting container; skipped automatically if script isn't present |


## License
ISC © 2014, 2015, 2016 [Vixlet CA LLC](http://www.vixlet.com/)
