# at-sre-challenge

This repository contains the code for the SRE challenge at AirTasker.

The project is using Go for the simple backend service. This allows us to have a lightweight Docker
image, and less importantly for this challenge, an efficient and performant service.

We're using chi as the HTTP router, which is a lightweight and idiomatic router for Go.

## Running the project

### Locally

To run the project locally, you need to have Go installed. You can then run the following commands:

```bash
make deps
make run-app
```

### In Docker
To run the project in Docker, you need to have Docker installed. You can then build and run the
Docker image with the following commands:

```bash
make build
make run-docker
```

### In Kubernetes
To run the project in Kubernetes, you need to have a Kubernetes cluster and NGINX ingress set up.
You can use `kind` to create a local cluster. The following commands will set up the cluster, deploy
NGINX ingress, deploy the application, and expose it via an Ingress:

```bash
make setup-cluster
make deploy
```

To clean up the resources, you can run:

```bash
make clean
make teardown-cluster
```

Optionally, if you already have a kind cluster set up, you can skip the `setup-cluster` step and just run:

```bash
make deploy
```

To access the application, you can add an entry to your `/etc/hosts` file:

```bash
127.0.0.1 at-sre-challenge.local
```

## TODOs

- [ ] Add environment overlays for different environments (dev, staging, prod)
