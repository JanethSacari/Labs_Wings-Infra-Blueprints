# Docker Strategy with Import from Git

This lab uses the OpenShift web console's **Import from Git** flow. The Git
context contains a `Dockerfile` at its root. The Docker strategy runs a
multi-stage build: Go source is compiled in the builder stage, and only the
resulting executable is copied into the smaller runtime image.

Unlike `../docker-binary-build`, this flow does not require compiling or
committing a binary before starting the OpenShift build. The binary is
generated inside the Docker build from the checked-out Git source.

## Import using the web console

1. Open the OpenShift console and select the target project.
2. In the **Developer** perspective, select **+Add > Import from Git**.
3. Enter the repository URL:
   `https://github.com/JanethSacari/Labs_Wings-Infra-Blueprints.git`
4. Expand the advanced Git options and set the **Context dir** to
   `openshift/docker-git-import`.
5. Confirm the detected builder is **Dockerfile** and the Dockerfile path is
   `Dockerfile`. This path is relative to the context directory.
6. Set the application name to `go-git-import-app`, keep the default build and
   deployment settings, and create the application.
7. Wait for the build and deployment. If the wizard does not create a Route,
   expose the generated Service from **Networking > Routes**.

The important setting is the context directory. The repository root does not
contain this lab's Dockerfile; the Dockerfile is at the root of the selected
context directory.

## Expected result

The build checks out Git, uses `openshift/docker-git-import` as its context,
and uses the Docker strategy. The multi-stage Dockerfile compiles
`src/main.go` and packages the executable into an Alpine runtime image. The
server listens on port 8080.

Use the generated Route URL to check `/` for a JSON response and `/healthz`
for `ok`.

## Rebuild after a Git change

Change `src/main.go` and push the change to the selected branch. Start a new
build from **Builds > Builds** (or use the build's Git webhook integration).
The build checks out the updated Git revision and recompiles the binary inside
the Dockerfile build. The resulting image is deployed through the
ImageStream/deployment configuration created by the import workflow.

## Compare with the binary-input lab

- This lab: **Import from Git** + Dockerfile at the context root; compilation
  happens inside the Docker build.
- `../docker-binary-build`: compile a binary separately, then upload the
  `binaries/` directory with `oc start-build --from-dir`.
