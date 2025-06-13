IMAGE_NAME ?= at-sre-challenge
IMAGE_TAG ?= latest
K8S_FILES = ./kubernetes
TLS_KEY_FILE := tls.key
TLS_CERT_FILE := tls.crt
CLUSTER_NAME ?= at-sre-challenge-cluster
HOST ?= at-sre-challenge.local

.PHONY: all build load deploy clean setup-cluster teardown-cluster run-docker run-app deps generate-tls

# Default target that runs the full deployment process
all: deploy

# Build Docker image
build:
	@echo "--- Building Docker image: $(IMAGE_NAME):$(IMAGE_TAG) ---"
	docker build -t at-sre-challenge .

# Target to load the image into kind
load: build
	@echo "--- Loading image into kind cluster ---"
	kind load docker-image --name $(CLUSTER_NAME) $(IMAGE_NAME):$(IMAGE_TAG)

generate-tls: $(TLS_KEY_FILE) $(TLS_CERT_FILE)

$(TLS_KEY_FILE) $(TLS_CERT_FILE):
	@echo "--- Generating self-signed TLS certificate ---"
	@openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	  -keyout $(K8S_FILES)/$(TLS_KEY_FILE) \
	  -out $(K8S_FILES)/$(TLS_CERT_FILE) \
	  -subj "/CN=$(HOST)"

# Target to deploy to Kubernetes
deploy: load generate-tls
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

# Creates the kind cluster and installs the NGINX ingress controller
setup-cluster:
	@echo "--- Creating kind cluster with ingress-ready node ---"
	@kind create cluster --config=kubernetes/kind-cluster-config.yaml
	@echo "--- Installing NGINX Ingress Controller for kind ---"
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@echo "--- Waiting for Ingress controller to be ready... ---"
	@kubectl wait --namespace ingress-nginx \
	  --for=condition=available deployment/ingress-nginx-controller \
	  --timeout=120s
	@echo "--- Waiting for Admission Webhook endpoint to be ready... ---"
	@kubectl wait --namespace ingress-nginx \
	  --for=condition=ready pod \
	  --selector=app.kubernetes.io/component=controller \
	  --timeout=120s
	@echo "--- Cluster setup complete! ---"

teardown-cluster:
	@echo "--- Deleting kind cluster ---"
	@kind delete cluster --name $(CLUSTER_NAME)
