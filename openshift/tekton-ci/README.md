# Tekton CI/CD for OpenShift 4.18

This example clones this repository, uses an OpenShift BuildConfig to build
`openshift/node-broken` and push the image to the internal registry, then
applies a Deployment, Service, and Route. A GitHub push event starts a
PipelineRun. Deleted-branch events are ignored. The build runs in the
OpenShift build system, not in a privileged Tekton pod.

The application is intentionally broken: `package.json` has a missing comma,
so the deployed container will fail to start. The build should succeed, while
the deploy task reports the unsuccessful rollout. Fix the exercise defects in
`openshift/node-broken` to get a healthy rollout.

## Prerequisites

- OpenShift 4.18 with the Red Hat OpenShift Pipelines Operator installed.
- A project with permission to create Tekton resources and PVCs.
- A project administrator to apply `rbac.yaml` if your account cannot create
  RoleBindings. Regular project users cannot grant roles they do not already
  hold.
- A default StorageClass that supports `ReadWriteOnce` PVCs.
- The project can pull the UBI Node.js and OpenShift CLI images.

## Install from the OpenShift web console

Select the target project first. In **Pipelines > Tasks**, create the three
Task resources from `tasks/git-clone.yaml`, `tasks/build-and-push.yaml`, and
`tasks/deploy.yaml`. Create `pipeline.yaml` from **Pipelines > Pipelines**.
Import `pvc.yaml` from **Storage > PersistentVolumeClaims** for manual runs;
push-triggered runs create a separate 1 GiB claim for each run.

Before applying `rbac.yaml` and `triggers.yaml`, replace each occurrence of
`REPLACE_WITH_PROJECT` in `rbac.yaml` with the selected project's namespace.
Import those files from **Home > Search > Import YAML**. Before applying
`triggers.yaml`, create the webhook secret from **Workloads > Secrets > Create
> Key/value secret** with name `github-webhook-secret`, key `secretToken`, and
a long random value. Use that same value when configuring the GitHub webhook.
Alternatively, create it from the CLI:

```sh
oc create secret generic github-webhook-secret \
  --from-literal=secretToken='<a-long-random-secret>'
```

The `node-broken-pipeline` ServiceAccount is bound to a project-scoped Role
with only the permissions needed to create ImageStreams and BuildConfigs,
start builds, and apply the Deployment, Service, and Route. An administrator
must apply `rbac.yaml` if your account cannot create RoleBindings. The
pipeline does not need the `system:image-builder` role or privileged SCC.
OpenShift's build system runs the image build using its standard builder
ServiceAccount and permissions.

## Run manually

From **Pipelines > Pipelines**, open `node-broken-ci` and start a run. Use:

- `repo-url`: `https://github.com/JanethSacari/Labs_Wings-Infra-Blueprints.git`
- `revision`: `main` or a commit SHA
- `image-tag`: `manual` (only the output tag, not a full image reference)
- `app-path`: `openshift/node-broken`
- Workspace `shared-data`: PVC `node-broken-workspace`
- Service account: `node-broken-pipeline`

The clone Task removes and recreates only the `repo` checkout directory inside
the workspace before cloning. You can reuse the same PVC for sequential runs;
do not attach that PVC to simultaneous PipelineRuns.

The Task steps that run `oc` use the public OpenShift CLI image
`quay.io/openshift/origin-cli:4.18`. This is separate from the application
base image in `openshift/node-broken/Dockerfile`; do not enter an application
image such as `registry.redhat.io/ubi9/nodejs-22-minimal:latest` in the
`image-tag` field. The build output is tagged automatically in the project's
internal registry.

## Configure the GitHub push webhook

1. In **Networking > Routes**, create a Route for service
   `el-node-broken-listener` (the EventListener service), using the default
   target port.
2. In the repository's **Settings > Webhooks**, add the Route URL with the
   `/` path. Set content type to `application/json`, paste the same secret
   used to create `github-webhook-secret`, and select the **push** event.
3. Save the webhook. A successful delivery creates a PipelineRun named with
   the `node-broken-push-` prefix.

The trigger uses the commit SHA from each push as both the checkout revision
and image tag. Each triggered PipelineRun gets its own temporary PVC, avoiding
source-directory collisions between concurrent pushes. Builds use one
`node-broken` BuildConfig with `Serial` run policy, so builds are queued rather
than competing for the same BuildConfig.

## Troubleshooting EventListener `Forbidden` errors

`failed to list` or `failed to watch ... forbidden` is an RBAC problem, not an
expected EventListener error. In the EventListener pod logs, note the exact
resource and the `system:serviceaccount:<project>:<name>` shown in the error.
The EventListener must run as `node-broken-event-listener`; the separate
`node-broken-pipeline` account is used by Pipeline Tasks.

In the selected project, open **User Management > RoleBindings** and confirm
that `node-broken-event-listener-pipeline-run` binds the
`node-broken-pipeline-run-creator` Role to ServiceAccount
`node-broken-event-listener` in that same project. The Role grants
`get/list/watch` on `triggers`, `triggerbindings`, and
`triggertemplates` in `triggers.tekton.dev`, and
`get/list/watch/create` on `pipelineruns.tekton.dev`. Reapply the updated
`rbac.yaml` in the project. If the error names a different resource, do not
grant broad cluster permissions: use the resource and verb from the log to
add only the required project-scoped permission.
