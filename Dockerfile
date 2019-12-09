FROM node:lts-alpine

RUN apk add --no-cache bash

RUN npm install -g http-server

WORKDIR /app

# copy all dependencies
COPY package*.json ./

RUN npm install

# copy all project diles to /app/
COPY . .

EXPOSE 8080
CMD []