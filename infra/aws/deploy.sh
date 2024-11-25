#!/bin/bash

# Configurações
AWS_REGION="us-east-1"
ECR_REPO_NAME="firecrawl"
CLUSTER_NAME="firecrawl-cluster"

# Login no ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com

# Build e push das imagens
docker build -t $ECR_REPO_NAME-api ./apps/api
docker build -t $ECR_REPO_NAME-playwright ./apps/playwright-service

docker tag $ECR_REPO_NAME-api:latest $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME-api:latest
docker tag $ECR_REPO_NAME-playwright:latest $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME-playwright:latest

docker push $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME-api:latest
docker push $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME-playwright:latest

# Atualizar serviço ECS
aws ecs update-service --cluster $CLUSTER_NAME --service firecrawl-service --force-new-deployment 