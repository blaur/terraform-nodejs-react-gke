# Introduction
This project is a simple example of how to deploy a node backend and react frontend on GKE using terraform.

The infrastructure consists of the following
- GKE cluster running auto-pilot
- Cloud Storage for assets
- Cloud SQL Postgress
- Backend and frontend workloads
- Ingress for both workloads

## Backend
Simple node backend using TypeScript. It expose a GraphQL API using Apollo which use Cloud SQL (and TypeORM) for persistence. 

Build your docker image. The terraform will define the URL pattern for the image in the container registry (google_container_registry_image -> stooks-gke-${var.env}) which wil lbe output as the project name.

`docker build . -t gcr.io/${PROJECT_ID}/{project_name}:v1`
`gcloud builds submit --tag gcr.io/${PROJECT_ID}/{project_name}:v1 .`

# Frontend
Simple react frontend using TypeScript. It communicates with the backend using GraphQL. As with the backend, the terraform defines will output the image url to use.

`docker build . -t gcr.io/${PROJECT_ID}/{project_name}-frontend:v1`
`gcloud builds submit --tag gcr.io/${PROJECT_ID}/{project_name}-frontend:v1 .`

# Deployment

## Requirements
1. Create a Google Cloud Project
2. Enable all the necessary Google Cloud APIs such as compute, container registry, cloud sql and so on.

## How-to Deploy to GKE

In the project directory, you can run:

1. Install all necessary tools: terraform, gcloud and kubectl
2. Authenticate with Google Cloud: gcloud auth application-default login
3. Create the infrastructure with terraform: 
    - `cd terraform/dev && terraform init && terraform apply`
4. Follow the guides for Frontend and Backend above to build and push docker images.
    - `cd apps/frontend and apps/backend`
    - `docker build -t gcr.io/${PROJECT_ID}/.....:v1 .`
    - `gcloud docker -- push gcr.io/${PROJECT_ID}/......`
5. Authenticate kubectl: `gcloud container clusters get-credentials $(terraform output cluster_name) --zone=$(terraform output cluster_zone)`

### Deploy backend
1. Render Kubernetes config template: terraform output k8s_rendered_template_backend > backendk8s.yml
2. Update Kubernetes resources: kubectl apply -f backendk8s.yml
3. Get direct ip address with: kubectl get ingress stooks-gke-dev-ingress

### Deploy frontend 
1. Render Kubernetes config template: terraform output k8s_rendered_template_frontend > frontendk8s.yml
2. Update Kubernetes resources: kubectl apply -f frontendk8s.yml
3. Get direct ip address with: kubectl get ingress stooks-gke-dev-frontend-ingress

To get direct IP addresses:
1. kubectl get ingress stooks-gke-dev-ingress
2. kubectl get ingress stooks-gke-frontend-dev

## Inspiration

Inspired by examples https://github.com/hashicorp/learn-terraform-provision-gke-cluster and https://github.com/epiphone/gke-terraform-example.