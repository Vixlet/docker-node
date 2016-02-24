# Source image
FROM  node:${NODE_VERSION}

# Update package cache
RUN  apt-get update

# Install krb5 and gssapi_krb5
RUN  apt-get install libkrb5-dev

# Restrict npm install duration to just a single eon...
RUN  npm config set loglevel warn --global
RUN  npm config set progress false --global

# Increate system ulimit
COPY  ./limits.conf /etc/security/limits.conf

# Copy entrypoint script
COPY  ./entry.sh /entry.sh

# Set working directory
WORKDIR  /var/app

# Start the container
ENTRYPOINT  ["/entry.sh"]