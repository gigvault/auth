.PHONY: build test lint docker run-local clean

build:
	go build -o bin/auth ./cmd/auth

test:
	go test ./... -v

lint:
	golangci-lint run ./...

docker:
	docker build -t gigvault/auth:local .

run-local: docker
	../infra/scripts/deploy-local.sh auth

clean:
	rm -rf bin/
	go clean
