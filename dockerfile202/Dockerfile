# Official golang image where the "workspace" (GOPATH) is configured to be at `/go`
FROM docker.io/library/golang:1.22.7
# Set the working directory
WORKDIR /usr/src/app
# Copy the code into the container
COPY . ./
# Build the code inside the container
RUN go build .
# Specify the entrypoint of the container
ENTRYPOINT ["/usr/src/app/dockerfile202"]

# HTTP server listens on tcp port 8080.
EXPOSE 8080
