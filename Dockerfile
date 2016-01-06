# Source image
FROM  node:0.10.41

# Install nodemon, supervisor, and forever
RUN  npm install -g nodemon forever

# Increate system ulimit
COPY  ./limits.conf /etc/security/limits.conf

# Copy start-up script
COPY  ./start.sh /start.sh

# Set working directory
WORKDIR  /var/app

# Start the container
ENTRYPOINT  ["/start.sh"]