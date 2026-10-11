FROM registry.access.redhat.com/ubi9/nodejs-22-minimal:latest

WORKDIR /opt/app
COPY --chown=1001:0 package.json index.js ./

ENV PORT=8080
EXPOSE 8080

CMD ["npm", "start"]
