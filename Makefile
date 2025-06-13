IMAGE_NAME ?= at-sre-challenge
IMAGE_TAG ?= latest
K8S_FILES = ./kubernetes

.PHONY: all build load deploy clean

# Default target that runs the full deployment process
all: deploy

# Build Docker image
build:
	@echo "--- Building Docker image: $(IMAGE_NAME):$(IMAGE_TAG) ---"
	docker build -t at-sre-challenge .

# Target to load the image into kind
load: build
	@echo "--- Loading image into kind cluster ---"
	kind load docker-image $(IMAGE_NAME):$(IMAGE_TAG)

# Target to deploy to Kubernetes
deploy: load
	@echo "--- Applying Kubernetes manifests ---"
	kubectl apply -k $(K8S_FILES)

# Target to delete Kubernetes resources
clean:
	@echo "--- Deleting Kubernetes resources ---"
	kubectl delete -k $(K8S_FILES)

# Run Docker container
run-docker:
	@echo "--- Running app via docker ---"
	docker run -p 3000:3000 at-sre-challenge

# Install dependencies
deps:
	@echo "--- Installing dependencies ---"
	go mod download

# Run the application
run-app:
	@echo "--- Running app locally ---"
	go run src/main.go
