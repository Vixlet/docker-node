# Node Docker Image

[![Build Status](https://travis-ci.org/Vixlet/docker-node.svg?branch=master)](https://travis-ci.org/Vixlet/docker-node)

A configurable Docker container for running Node; designed for use with AWS ElasticBeanstalk! :P


## Table of Contents
- [Overview](#overview)
- [Base Docker Image](#basedockerimage)
- [Container Usage](#containerusage)
    + [Run in background](#runinbackground)
    + [Run interactively](#runinteractively)
    + [Run with custom container commands](#runwithcustomcontainercommands)
    + [Run with ad-hoc commands](#runwithadhoccommands)
    + [Use as base image](#useasbaseimage)
    + [Use as base image with faster npm install](#useasbaseimagewithfasternpminstall)
    + [Hooking into container pre-start](#hookingintocontainerprestart)
- [Contributing](#contributing)
    + [Building images](#buildingimages)
    + [Specifying image versions](#specifyingimageversions)
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
- [node:5.6.0](https://registry.hub.docker.com/u/library/node/)
    + [Node Official Dockerfile](https://github.com/joyent/docker-node/blob/master/5.6/Dockerfile)


## Container Usage
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
#### INSTALL NPM DEPENDENCIES ON CONTAINER START
docker run -it --rm \
    -p 8080:8080 \
    -v $( pwd ):/var/app \
    --name "vixlet-node-example" \
    -e "CONTAINER_PRESTART=npm install --production" \
    vixlet/node:latest
```

### Run with ad-hoc commands
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

### Use as base image
```Dockerfile
FROM  vixlet/node:stable

# Install dependencies in a way which takes advantage of docker image caching,
# so these steps are skipped whenever package.json and .npmrc haven't changed
COPY  package.json /var/app/

# Be sure to include an .npmrc if you use @scoped dependencies
COPY  .npmrc /var/app/

# Run npm install, skipping devDependencies
RUN  npm install --production

# Add application source to Docker image
COPY  . /var/app/

# Expose application ports
EXPOSE  80 443
```

#### Then to run...
```sh
docker build -t "my-node-application-image" .
docker run -it --rm \
    -p 80:80 \
    -p 443:443 \
    --name "my-node-application" \
    "my-node-application-image"
```

### Use as base image with faster npm install
```Dockerfile
FROM  vixlet/node:stable

# Install dependencies outside of docker
COPY  package.json /var/app/
COPY  node_modules /var/app/node_modules

# Rebuild native bindings
RUN  npm rebuild

# Add application source to Docker image
COPY  . /var/app/

# Expose application ports
EXPOSE  80 443
```

#### Then to run...
```sh
npm install --production
docker build -t "my-node-application-image" .
docker run -it --rm \
    -p 80:80 \
    -p 443:443 \
    --name "my-node-application" \
    "my-node-application-image"
```

### Container pre-start
A custom pre-start script (or command) can be provided to handle any tasks prior to the container starting.

#### Pre-start script
To use a pre-start script, include an executable file in your application named `docker-prestart.sh`; alternatively, set `CONTAINER_PRESTART` to the path to your executable script.

#### Pre-start command
To use a pre-start command, set `CONTAINER_PRESTART` to your command; eg. `CONTAINER_PRESTART=npm install --production`


## Contributing
Contributors are welcome! If there are changes you feel should be made, please create an issue in GitHub describing the rationale behind the changes, and then submit an associated pull request.

> Note that the version directories are build artifacts! Do not change those files directly; instead, make changes in `context/` and `Dockerfile`, then run `npm run remake` to rebuild those files.

### Building images
```sh
npm run clean # <-- deletes all build artifacts (including committed files)
npm run make # <-- creates version directories w/ build context + dockerfile
npm test # <-- builds and tests all image versions locally
```

### Specifying image versions
The list of NodeJS versions used to build Docker images are specified in 2 files:

|Filename|Purpose|
|--------|-----|
|`versions.env`|Specifies the exact versions of the base `docker/node` image for a given major NodeJS version.|
|`.travis.yml`|Specified which major NodeJS versions should be built and published by TravisCI.|


## License
ISC © 2014, 2015, 2016 [Vixlet CA LLC](http://www.vixlet.com/)
