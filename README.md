# thinkube-devpi

The container image for the DevPI server in Thinkube: the private Python
package index that holds the platform's own packages, such as `tk-llm`, so
notebooks and apps can install them with pip.

## What it does

- `dockerfile/Dockerfile`: Python 3.12 with `devpi-server` 6.20.1,
  `devpi-web` 5.1.0 and `devpi-client` 7.3.0, data in `/data/devpi`,
  port 3141.
- `dockerfile/scripts/entrypoint.sh`: initialises the server directory on
  first start, creates a persistent secret file, and starts `devpi-server`.
  It reads these variables, which the deployment sets:
  - `DEVPISERVER_SERVERDIR`: the data directory.
  - `DEVPI_OUTSIDE_URL`: the public URL, passed as `--outside-url`.
  - `DEVPI_TRUSTED_PROXY`: passed as `--trusted-proxy`.
  - `DEVPI_EXTRA_ARGS`: further `devpi-server` options, such as
    `--request-timeout`, so a setting does not need a new image.

## How it reaches a user

This repository is part of [Thinkube](https://github.com/thinkube/thinkube).
It is not deployed on its own. The Thinkube installer runs the core DevPI
playbook, `ansible/40_thinkube/core/devpi/10_deploy.yaml` in the thinkube
repository. That playbook clones this repository, builds
`dockerfile/Dockerfile` with podman, pushes the image to Harbor and deploys
it. The Kubernetes manifests come from that playbook, not from this
repository.

## Working on it

Build the image from the repository root, as the playbook does:

```bash
podman build -f dockerfile/Dockerfile -t devpi:dev .
```

## License

Apache-2.0
