# Node Docker Image

A configurable Docker container for running Node; designed for use with AWS ElasticBeanstalk! :P


## Table of Contents
- [Overview](#overview)
- [Base Docker Image](#basedockerimage)
- [Usage](#usage)
    + [Running the container](#runningthecontainer)
    + [Configuring Nginx](#configuringnginx)
    + [Setting a script hook](#settingascripthook)
    + [Supported environment variables](#supportedenvironmentvariables)
- [License](#license)


## Overview
This is a minimal Docker image for running Node in a customizable manner, by making use of a bash script with hooks as the container's run command. The container supports multiple methods of starting node, as well as being able to bypass pre-installed node_modules directories. It's meant primarily as a workaround for AWS ElasticBeanstalk's lack of a way to specify a `run` command for a Docker container, and is designed for node content to be provided via mounted directories.


## Base Docker Image
- [node:0.10.38](https://registry.hub.docker.com/u/library/node/)
    + [Node Official Dockerfile](https://github.com/joyent/docker-node/blob/master/0.10/Dockerfile)


## Usage
1. If you haven't already, install [Docker](https://www.docker.com/)
2. Pull the [latest automated build](https://registry.hub.docker.com/u/vixlet/node/) from [DockerHub](https://registry.hub.docker.com/u/): `docker pull vixlet/node:latest`
3. Run the container!

### Running the container
```sh
### RUN CONTAINER INTERACTIVELY
docker run -it --rm \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    --name "vixlet-node-example" \
    vixlet/node:latest

### RUN CONTAINER IN THE BACKGROUND
docker run -d \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    --name "vixlet-node-example" \
    vixlet/node:latest

### RUN CONTAINER IN THE BACKGROUND FOR LOCAL DEVELOPMENT
docker run -d \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    -e "DOCKER_WATCH=on" \
    --name "vixlet-node-example" \
    vixlet/node:latest
```

### Setting a script hook
A custom pre-start script can be provided to handle any tasks prior to invoking the Node process.

To use a custom pre-start script, simply provide an executable file in your working directory named `docker-prestart.sh` (or set the `DOCKER_PRESTART_SCRIPT` environment variable to the filepath of the desired script) and the Docker container will automatically invoke it immediately prior to invoking the Node process.

### Supported environment variables
| Variable Name | Example Values | Description |
| ------------- | -------------- | ----------- |
| **`DOCKER_START_CMD`** | `"npm"` (default) | Command to start node |
| **`DOCKER_START_ARGS`** | `"start"` (default) | Arguments to pass to the start command |
| **`DOCKER_PRESTART_SCRIPT`** | `"/var/app/docker-prestart.sh"` (default) | Path to script to run immediately before node |
| **`DOCKER_PREINSTALLED`** | `""` (default) or `"bypass"` (bypass) | Should `npm install --production` be bypassed? |


## License
ISC © [Vixlet CA LLC](http://www.vixlet.com/)
