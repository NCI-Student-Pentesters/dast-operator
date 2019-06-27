# Build the manager binary
FROM golang:1.12.5 as builder

WORKDIR /workspace
# Copy the go source
COPY cmd/dast-operator cmd/
COPY api/ api/
COPY controllers/ controllers/
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum


# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o dast-operator ./cmd/...

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:latest
WORKDIR /
COPY --from=builder /workspace/dast-operator .
ENTRYPOINT ["/dast-operator"]
