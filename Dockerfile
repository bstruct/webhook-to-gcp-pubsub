# Use a node 16 base image
ARG NODE_VERSION=16
FROM node:${NODE_VERSION}-alpine as build

WORKDIR /usr/app

COPY . .
RUN npm install
RUN npm test
RUN npm run-script build

FROM node:${NODE_VERSION}-alpine

WORKDIR /usr/app

COPY --from=build /usr/app/dist/src/ /usr/app/
RUN npm install @google-cloud/pubsub
RUN npm install @grpc/grpc-js

ENTRYPOINT node /usr/app/server.js
