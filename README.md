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

## TODOs

- [ ] Add environment overlays for different environments (dev, staging, prod)
