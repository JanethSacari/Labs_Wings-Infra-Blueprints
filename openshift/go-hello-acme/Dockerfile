FROM golang:1.24-alpine AS builder

WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build \
    -trimpath \
    -ldflags="-s -w" \
    -o /out/server \
    .

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

WORKDIR /app
COPY --from=builder /out/server /app/server
USER 1001
EXPOSE 8080
ENV PORT=8080

ENTRYPOINT ["/app/server"]
