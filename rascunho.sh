#!/bin/bash

set -e

AWS_ACCOUNT="181560427716"

export AWS_PAGER=""


APP_NAME="app-linuxtip"
CLUSTER_NAME="linuxtips-ecs-cluster"

echo "CI DA APLICAÇÃO"

## STEP 1 - CI
cd app/ 

### Lint 
echo "APP - LINT"
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.59.1
golangci-lint run ./...  -E errcheck

### Go Test
echo "APP - TEST"
go test -v ./...


cd ../terraform

echo "CI DO TERRAFORM"

### Terraform fmt check 
echo "TERRAFORM - FMT"
terraform fmt --recursive --check

### Terraform validate
echo "TERRAFORM - VALIDATE"
terraform validate

echo "CI FINALIZADO"


## STEP 2 - Build da App
echo "BUILD DA APLICACAO"
cd ../app


echo "BUILD DA IMAGEM"

### Bump Tag
GIT_COMMIT_HASH=$(git rev-parse --short HEAD)
echo $GIT_COMMIT_HASH

### Login no ECR
echo "LOGIN NO ECR"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

###  Build 
echo "DOCKER BUILD"
docker build -t app . 

### CRIAR REPOSITORIO NO ECS CASO NÃO EXISTA
REPOSITORY_NAME="linuxtips/$APP_NAME"

echo $REPOSITORY_NAME

set +e

# Verificar se o repositório já existe
REPO_EXISTS=$(aws ecr describe-repositories --repository-names $REPOSITORY_NAME 2>&1);

echo $REPO_EXISTS

if [[ $REPO_EXISTS == *"RepositoryNotFoundException"* ]]; then
  echo "Repositório $REPOSITORY_NAME não encontrado. Criando..."
  
  # Criar o repositório
  aws ecr create-repository --repository-name $REPOSITORY_NAME
  
  if [ $? -eq 0 ]; then
    echo "Repositório $REPOSITORY_NAME criado com sucesso."
  else
    echo "Falha ao criar o repositório $REPOSITORY_NAME."
    exit 1
  fi
else
  echo "Repositório $REPOSITORY_NAME já existe."
fi

set -e

###  Tag
docker tag app:latest $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/$REPOSITORY_NAME:$GIT_COMMIT_HASH
docker push $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/$REPOSITORY_NAME:$GIT_COMMIT_HASH


echo "DEPLOY"

cd ../terraform

REPOSITORY_TAG=$AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/$REPOSITORY_NAME:$GIT_COMMIT_HASH

echo "TERRAFORM INIT"
terraform init -backend-config=environment/dev/backend.tfvars

echo "TERRAFORM PLAN"
terraform plan -var-file=environment/dev/terraform.tfvars -var container_image=$REPOSITORY_TAG

echo "TERRAFORM APPLY"
terraform apply --auto-approve -var-file=environment/dev/terraform.tfvars -var container_image=$REPOSITORY_TAG


echo "ECS WAIT DEPLOY"

aws ecs wait services-stable --cluster $CLUSTER_NAME --services $APP_NAME