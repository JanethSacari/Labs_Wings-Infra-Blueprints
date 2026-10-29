# Hello Acme (Node.js)

A small Node.js HTTP app that serves a `Hello Acme!` page and a `/healthz`
endpoint. It is ready to import from Git in the OpenShift web console.

## Required container image

**Base image:** `registry.access.redhat.com/ubi9/nodejs-22-minimal:latest`

This image is set in the `FROM` line of the Dockerfile. The OpenShift cluster
must be able to pull it from `registry.access.redhat.com`. In **Import from
Git**, choose the **Dockerfile** builder so OpenShift uses this Dockerfile;
do not select a different Source-to-Image builder image.

## Import from Git

1. In the OpenShift console, select the target project and choose
   **Developer > +Add > Import from Git**.
2. Enter the repository URL:
   `https://github.com/JanethSacari/Labs_Wings-Infra-Blueprints.git`
3. Set the Git **Context dir** to `openshift/node-hello-acme`.
4. Select the **Dockerfile** builder and use `Dockerfile` as the Dockerfile
   path.
5. Set the application name to `node-hello-acme`, then create the application.
6. Wait for the build and deployment. If the import flow does not create a
   Route, expose the generated Service using **Networking > Routes**.

The application listens on `0.0.0.0:8080`, which allows the OpenShift Service
to reach it. The `/healthz` endpoint returns `ok`.

## Run locally

Requires Node.js 18 or later:

```sh
npm start
```

Open `http://localhost:8080` to see the greeting.

## Deploy with OpenShift Templates

From `openshift/templates`, process and apply the Hello Acme build template:

```sh
oc process -f node-hello-acme-build-template.yaml \
  -p repoUrl=https://github.com/JanethSacari/Labs_Wings-Infra-Blueprints.git \
  | oc apply -f -

oc start-build node-hello-acme --follow
```

After the build completes, create the Deployment, Service, and Route. Replace
the example host with a hostname under your cluster's ingress domain:

```sh
oc process -f node-hello-acme-application-template.yaml \
  -p host=node-hello-acme.apps.example.com \
  | oc apply -f -
```
