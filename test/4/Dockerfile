FROM  vixlet/node:${NODE_VERSION}
COPY  package.json /var/app/
RUN  npm install --production
COPY  . /var/app/