# Source image
FROM  node:4.3.1

# Update package cache
RUN  apt-get update

# Install krb5 and gssapi_krb5
RUN  apt-get install libkrb5-dev

# Clean apt-get cache to reduce image size
RUN  apt-get clean

# Restrict npm install duration to just a single eon...
ENV  NPM_CONFIG_LOGLEVEL warn
RUN  npm config set progress=false --global

# Increate system ulimit
COPY  limits.conf /etc/security/limits.conf

# Copy entrypoint script
COPY  entry.sh /entry.sh

# Set working directory
WORKDIR  /var/app

# Start the container
ENTRYPOINT  ["/entry.sh"]
