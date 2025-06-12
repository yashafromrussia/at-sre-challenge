# Build Docker image
build:
	docker build -t at-sre-challenge .

# Run Docker container
run-docker:
	docker run -p 3000:3000 at-sre-challenge

# Install dependencies
deps:
	go mod download

# Run the application
run-app:
	go run src/main.go
