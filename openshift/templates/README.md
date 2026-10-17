# OpenShift Template Practice

This practice exercise demonstrates how to parameterize OpenShift Templates.
Configure `repoUrl` in the build template and `host` in the application
template.

## Templates

- `build-template.yaml` creates an ImageStream and a Docker-strategy
  BuildConfig. Set `repoUrl` to the Git clone URL. The BuildConfig builds the
  `openshift/node-broken` directory from the repository.
- `application-template.yaml` creates a Deployment, Service, and Route. Set
  `host` to a hostname that belongs to the cluster's ingress domain and is
  available for this application.

The Deployment follows updates to the `nodejs-app:latest` ImageStreamTag.
The sample app in `node-broken` intentionally has an invalid `package.json`,
so the container will fail to start until that exercise defect is corrected.

## Process and apply

Replace the Git URL and route hostname with values for your environment:

```sh
oc process -f build-template.yaml \
  -p repoUrl=https://github.com/JanethSacari/Labs_Wings-Infra-Blueprints.git \
  | oc apply -f -

oc start-build nodejs-app --follow

oc process -f application-template.yaml \
  -p host=nodejs.apps.example.com \
  | oc apply -f -
```

Use an actual hostname under your cluster's apps domain, for example a name
ending in the domain shown by an existing OpenShift Route. A Route object can
be created with an explicit host even if the DNS name is not configured, but
it will not be reachable until that host resolves to the cluster ingress.

## Inspect the rendered objects

Process without applying to check parameter substitution:

```sh
oc process -f build-template.yaml -p repoUrl=https://example.com/team/app.git
oc process -f application-template.yaml -p host=nodejs.apps.example.com
```

Check that the resulting BuildConfig has
`spec.source.git.uri: https://example.com/team/app.git` and the resulting Route
has `spec.host: nodejs.apps.example.com`.

## Console workflow

In the OpenShift web console, select the target project, open **Home > Search
> Import YAML**, and import each Template file. Set the required parameters
when prompted, or use the CLI commands above to process and create the
resources. Start the build from **Builds > Builds** after creating the
BuildConfig.
