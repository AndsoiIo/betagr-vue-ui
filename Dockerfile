FROM node:alpine
RUN apk add --no-cache bash
RUN npm install -g @vue/cli
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
VOLUME ["/app"]
RUN npm install
EXPOSE 8080
CMD ["npm", "run", "serve"]