#!/bin/bash

# SETUP INICIAL
set -e

export AWS_ACCOUNT="181560427716"
export AWS_PAGER=""
export APP_NAME="linuxtips-app"


# CI DA APP

echo "APP - CI"

cd app/

echo "APP - LINT"
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.59.1
golangci-lint run ./... -E errcheck


echo "APP - TEST"
go test -v ./...

# CI DO TERRAFORM 

echo "TERRAFORM - CI"

cd ../terraform

echo "TERRAFORM - FORMAT CHECK"
terraform fmt --recursive --check

echo "TERRAFORM - VALIDATE"
terraform validate


# BUILD APP 

cd ../app

echo "BUILD - BUMP DE VERSAO"

GIT_COMMIT_HASH=$(git rev-parse --short HEAD)

# PUBLISH APP


# APPLY DO TERRAFORM - CD
