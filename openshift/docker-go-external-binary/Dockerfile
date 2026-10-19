FROM golang:1.24-alpine

WORKDIR /app

COPY docker-go-external-binary/go.mod ./
COPY docker-go-external-binary/src ./src
COPY docker-go-external-binary-assets/runtime-helper /usr/local/bin/runtime-helper

RUN chmod 0555 /usr/local/bin/runtime-helper \
    && CGO_ENABLED=0 GOOS=linux go build \
        -trimpath \
        -ldflags="-s -w" \
        -o /app/server \
        ./src

USER 1001
EXPOSE 8080
ENV PORT=8080

ENTRYPOINT ["/app/server"]
