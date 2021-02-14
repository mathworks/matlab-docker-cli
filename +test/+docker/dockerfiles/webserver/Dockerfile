# Copyright 2021 The MathWorks, Inc.
FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "docker-node-test.js" ]