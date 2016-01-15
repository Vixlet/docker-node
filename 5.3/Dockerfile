# Source image
FROM  node:5.3.0

# Update package cache
RUN  apt-get update

# Install krb5 and gssapi_krb5
RUN  apt-get install libkrb5-dev

# Install nodemon, supervisor, and forever
RUN  npm install -g nodemon@1.8.1 forever@0.15.1

# Increate system ulimit
COPY  ./limits.conf /etc/security/limits.conf

# Copy start-up script
COPY  ./start.sh /start.sh

# Set working directory
WORKDIR  /var/app

# Start the container
ENTRYPOINT  ["/start.sh"]