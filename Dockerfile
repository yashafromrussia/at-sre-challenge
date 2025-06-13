FROM golang:1.24.4-alpine AS builder

WORKDIR /app

# Install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the application source code
COPY src/ .
RUN CGO_ENABLED=0 go build -o main .

# Create a minimal image for the final application
FROM gcr.io/distroless/static-debian12

COPY --from=builder /app/main /app/main

CMD ["/app/main"]
