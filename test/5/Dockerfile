FROM  vixlet/node:${IMAGE_NODE_VERSION}
COPY  package.json /var/app/
COPY  node_modules /var/app/node_modules
RUN  npm rebuild
COPY  . /var/app/