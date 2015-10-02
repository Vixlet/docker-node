# Source image
FROM  node:0.10.40

# Increate system ulimit
COPY  ./limits.conf /etc/security/limits.conf

# Install nodemon, supervisor, and forever
RUN  npm i -g nodemon supervisor forever

# Copy start-up script
COPY  ./start.sh /start.sh

# Set working directory
WORKDIR  /var/app

# Set default start command
ENV  DOCKER_START_CMD npm

# Set default start arguments
ENV  DOCKER_START_ARGS start

# Start the container
CMD  /start.sh \
     && echo "Starting Node (via \`${DOCKER_START_CMD} ${DOCKER_START_ARGS}\`)..." \
     && exec ${DOCKER_START_CMD} ${DOCKER_START_ARGS}
