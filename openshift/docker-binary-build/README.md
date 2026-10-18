# Docker Strategy with Binary Build Input

This lab builds and deploys a small Go HTTP server. The Go executable is
compiled locally into `binaries/server`, then uploaded to an OpenShift
BuildConfig configured with `source.type: Binary` and `strategy.type: Docker`.
The Dockerfile is embedded in the BuildConfig and copies the uploaded binary
into a UBI minimal runtime image.

This demonstrates two distinct steps:

1. Compile the application into a Linux binary in the separate `binaries/`
   directory.
2. Upload that directory as binary build input; OpenShift's Docker strategy
   packages the binary into a container image and pushes it to an ImageStream.

No privileged Tekton pod or external image registry is used.

## Requirements

- OpenShift 4.18 with permission to create ImageStreams, BuildConfigs,
  Deployments, Services, and Routes.
- The OpenShift cluster can pull `registry.access.redhat.com/ubi9/ubi-minimal:9.6`.
- Go 1.22 or later installed locally.
- The local build machine uses the same CPU architecture as the OpenShift
  cluster build/runtime nodes (for example, `linux/amd64`).

## Build the binary

From this directory:

```sh
sh scripts/build-binary.sh
file binaries/server
```

The generated executable is ignored by Git. Re-run the script after changing
`src/main.go`.

## Create the OpenShift build

Select the target project, then create the ImageStream and BuildConfig:

```sh
oc apply -f buildconfig.yaml
```

Upload the contents of the separate binary directory and follow the build:

```sh
oc start-build go-binary-app --from-dir=binaries --follow
```

`--from-dir` makes the contents of `binaries/` the binary build input. The
uploaded context contains `server`, which the inline Dockerfile copies into
the runtime image.

## Deploy and expose the application

```sh
oc apply -f deployment.yaml
oc rollout status deployment/go-binary-app
oc get route go-binary-app
```

The Deployment references the `go-binary-app:latest` ImageStreamTag and has
an image change trigger, so subsequent successful builds update the
Deployment. Open the Route URL; `/healthz` should return `ok` and `/` should
return a JSON response.

## Practice prompts

- Inspect the BuildConfig and identify its source type, strategy, and inline
  Dockerfile.
- Change the executable name in `scripts/build-binary.sh` and update the
  Dockerfile's `COPY` and `ENTRYPOINT` consistently.
- Change a response in `src/main.go`, rebuild the binary, start another
  binary build, and observe the Deployment update.
- Check the BuildConfig's latest build logs and the resulting ImageStreamTag.
