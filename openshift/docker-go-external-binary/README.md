# Go Application with an External Binary Dependency

This lab builds a Go HTTP application in a `golang:1.24-alpine` image and
requires a separate Linux executable, `runtime-helper`. The helper is built
into the sibling directory `openshift/docker-go-external-binary-assets`,
outside this application folder. The native OpenShift binary build uploads
the parent `openshift/` directory as its build context. The Dockerfile copies
the helper from that sibling directory into the image, and the application
runs it for requests to `/`. The Docker build fails if the external file is
missing; if it cannot be executed at runtime, `/` returns HTTP 503 with an
error in the container logs.

The helper source is kept under `tools/runtime-helper`, but its compiled
executable is a build input generated separately by `scripts/build-helper.sh`.
The default output directory is `../docker-go-external-binary-assets`, relative
to this lab. You can pass another directory as the script's first argument,
but it must be under the `openshift/` build context and match the path in the
Dockerfile.

## Requirements

- Go 1.22 or later installed locally.
- OpenShift CLI (`oc`) logged into a project where you can create an
  application and start builds.
- Build the helper for the same CPU architecture as the Docker image runtime.

## Create the binary build and upload the context

From this directory, compile the helper into the sibling assets folder:

```sh
sh scripts/build-helper.sh
```

Create an OpenShift application configured for a Docker binary build:

```sh
oc new-app --name=go-external-binary-app --strategy=docker --binary
```

Set the Dockerfile path relative to the build context root, then upload the
parent `openshift/` directory. This context contains both the application
folder and its sibling external-binaries folder:

```sh
oc patch bc/go-external-binary-app --type=merge \
  -p '{"spec":{"strategy":{"dockerStrategy":{"dockerfilePath":"docker-go-external-binary/Dockerfile"}}}}'
oc start-build go-external-binary-app --from-dir=.. --follow
```

The Dockerfile explicitly declares the external input with
`COPY docker-go-external-binary-assets/runtime-helper ...`. If that file has
not been generated, the build fails at the `COPY` instruction. The `--from-dir`
path is relative to the current directory, so run these commands from
`openshift/docker-go-external-binary`.

## Run and check

`oc new-app` creates the application resources. Wait for its deployment and
find the generated Service or Route:

```sh
oc get builds
oc get pods,services,routes
```

On the application's URL, `/healthz` returns `ok` and `/` invokes the external
binary and returns a JSON response containing its output.

## What this demonstrates

- The application itself is compiled in the Docker build using the Go
  toolchain in the image.
- A separate executable is generated outside that Docker build and is
  kept in a folder outside the application folder and included through the
  native OpenShift binary build context.
- The executable is a required Docker build input and a runtime dependency of
  the application.
- This example keeps the Go toolchain in the final image for clarity; a
  production image would typically use a multi-stage build and a smaller
  runtime base.
