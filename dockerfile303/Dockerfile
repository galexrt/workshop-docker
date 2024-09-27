# This is the first "image" we use and name it "builder"
FROM docker.io/library/golang:1.22.7-alpine3.20 AS builder
# Set the working directory
WORKDIR /usr/src/app
# Copy the code into the container
COPY . ./
# Build the code inside the container
RUN go build .

# This would be "final" image
FROM docker.io/library/alpine:3.20.3
WORKDIR /app
# Copy the built binary from the builder image inside the "final" image
COPY --from=builder /usr/src/app/dockerfile303 /usr/local/bin/
# Specify the entrypoint of the container
ENTRYPOINT ["/usr/local/bin/dockerfile303"]

# HTTP server listens on tcp port 8080.
EXPOSE 8080
