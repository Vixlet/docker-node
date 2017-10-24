# Source image
FROM  node:8.8.0-alpine

ENV  NPM_CONFIG_LOGLEVEL warn
ENV  NPM_CONFIG_PROGRESS false
RUN  npm config set loglevel warn --global
RUN  npm config set progress false --global

RUN  mkdir /var/app

RUN  apk update

RUN  apk add --no-cache krb5-dev python gcc g++ make git tar

# Copy entrypoint script
COPY  entry.sh /entry.sh

WORKDIR  /var/app

# Start the container
ENTRYPOINT  ["/entry.sh"]
