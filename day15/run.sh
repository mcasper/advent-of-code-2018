#!/bin/bash

set -eou pipefail

go test
go vet
~/code/gocode/bin/golint -set_exit_status main.go
~/code/gocode/bin/goimports -w main.go
go run main.go
