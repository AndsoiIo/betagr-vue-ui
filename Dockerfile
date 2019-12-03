FROM node:lts-alpine

RUN npm install -g http-server

WORKDIR /app

# copy all dependencies
COPY package*.json ./

RUN npm install

# copy all project diles to /app/
COPY . .

RUN npm run build

EXPOSE 8080
CMD [ "http-server", "dist" ]