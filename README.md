# at-sre-challenge

This repository contains the code for the SRE challenge at AirTasker.

## Rationale

The project is designed to be simple and straightforward, focusing on the core functionality of the
service. The use of Go allows for a lightweight and efficient application, while the choice of chi
as the router provides a clean and idiomatic way to handle HTTP requests.

I've made the decision to use `kind` for local Kubernetes development as it allows for a quick
setup of a Kubernetes cluster with NGINX ingress. This is particularly useful for testing the
application in an environment that closely resembles production.

I'm also using a self-signed TLS certificate for local development. In a production environment, I
would likely use `cert-manager` or another solution to manage TLS certificates, ensuring that the
application is secure and compliant with best practices.

The Makefile provides a convenient way to manage the build, deployment, and cleanup processes,
allowing for a smooth development experience. It also includes targets for generating TLS certificates,
cluster setup, and teardown.

Lastly, I'm using Kustomize to manage Kubernetes manifests, which allows for easy customization
of the deployment configuration without duplicating YAML files. This is particularly useful for
managing different environments (e.g., development, staging, production) with minimal overhead.
However, I haven't implemented environment overlays yet, which is a TODO for future work. We could
use Helm, but for this task it seemed like overkill, and Kustomize is sufficient for our needs.

## Running the project

The project can be run in three different ways: locally, in Docker, or in Kubernetes. Below are the
instructions for each method.

### Prerequisites

This project was developed and tested on macOS, but it should work on any Unix-like system.

Before running the project, ensure you have the following tools installed:
- Go (version 1.24.4 or later)
- Docker
- `kubectl` (for managing Kubernetes resources)
- `kind` (for local Kubernetes development)
- `make` (for running Makefile targets)
- `openssl` (for generating TLS certificates)

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

#### Demonstrating Load Balancing

To verify that traffic is being distributed across both pods, you can use `curl` with the verbose
flag (`-v`) and observe the `X-Served-By` header in the response. You will see the header value
change between different pod hostnames on subsequent requests.

```bash
curl -k -v https://at-sre-challenge.local
```

## TODOs

- [ ] Add environment overlays for different environments (dev, staging, prod)
- [ ] Use `cert-manager` for managing TLS certificates in production
