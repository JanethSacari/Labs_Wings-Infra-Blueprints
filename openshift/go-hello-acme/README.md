# Hello Acme (Go)

A small Go HTTP application that serves a `Hello Acme!` page and a `/healthz`
endpoint. It is ready to import from Git in the OpenShift web console.

## Required container image

The Dockerfile uses `golang:1.24-alpine` to compile the application and
`registry.access.redhat.com/ubi9/ubi-minimal:latest` as its runtime image.
The OpenShift cluster must be able to pull both images. The final image runs
as user `1001`.

## Import from Git

1. In the OpenShift console, select the target project and choose
   **Developer > +Add > Import from Git**.
2. Enter the repository URL:
   `https://github.com/JanethSacari/Labs_Wings-Infra-Blueprints.git`
3. Set the Git **Context dir** to `openshift/go-hello-acme`.
4. Select the **Dockerfile** builder and use `Dockerfile` as the Dockerfile
   path.
5. Set the application name to `go-hello-acme`, then create the application.
6. Wait for the build and deployment. If the import flow does not create a
   Route, expose the generated Service using **Networking > Routes**.

The application listens on `0.0.0.0:8080`, which allows the OpenShift Service
to reach it. The `/healthz` endpoint returns `ok`.

## Run locally

Requires Go 1.24 or later:

```sh
go test ./...
go run .
```

Open `http://localhost:8080` to see the greeting.
