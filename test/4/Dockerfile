FROM  vixlet/node:${IMAGE_NODE_VERSION}
COPY  package.json /var/app/
RUN  npm install --production
COPY  . /var/app/