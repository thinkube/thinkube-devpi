# DevPi Deployment

This repository contains the configuration for deploying DevPi using:
- Dockerfile for DevPi containerization
- Argo Workflows with Kaniko for container building
- ArgoCD for continuous deployment

## Components

- `dockerfile/` - Contains the DevPi Dockerfile
- `k8s/` - Kubernetes manifests for deployment
- `workflows/` - Argo Workflow for container building

## CI/CD Process

1. Argo Workflow builds the DevPi container image
2. After successful build, the workflow updates the image tag in the kustomization.yaml
3. ArgoCD detects the changes to the repository and automatically deploys the updated application
