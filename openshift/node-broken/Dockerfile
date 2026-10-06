FROM registry.access.redhat.com/ubi9/nodejs-22

WORKDIR /app
COPY package.json server.js ./
EXPOSE 8080

CMD ["npm", "start"]
