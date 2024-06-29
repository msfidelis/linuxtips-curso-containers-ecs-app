#!/bin/bash

## STEP 1 - CI

### Lint 

go install mvdan.cc/gofumpt@latest
gofumpt -l -w .

### Go Test

go test -v ./...

###  Build 

docker build -t app . 

### 

GIT_COMMIT_HASH=$(git rev-parse --short HEAD)

echo $GIT_COMMIT_HASH