FROM golang:1.23-bullseye AS builder
WORKDIR /src

# Copy shared library first
COPY shared/ ./shared/

# Copy service files
COPY auth/go.mod auth/go.sum ./auth/
WORKDIR /src/auth
RUN go mod download

WORKDIR /src
COPY auth/ ./auth/
WORKDIR /src/auth
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/auth ./cmd/auth

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /out/auth /usr/local/bin/auth
COPY auth/config/ /config/
EXPOSE 8080 9090
ENTRYPOINT ["/usr/local/bin/auth"]
