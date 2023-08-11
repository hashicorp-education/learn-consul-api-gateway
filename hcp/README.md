# Consul API Gateway on EKS + HCP

## Overview

Terraform will perform the following actions:
- Create VPC and HVN networks
- Peer VPC and HVN networks
- Create HCP Consul cluster
- Create EKS cluster
- Deploy Consul + API GW to EKS

You will perform these steps:
- Deploy Hashicups to EKS
- Deploy remaining API GW settings to EKS
- Verify AWS Load Balancer is created once API GW is deployed
- Verify access with Hashicups via API GW
- Clean up environment

## Steps

1. Set credential environment variables for AWS and HCP
    1. 
    ```shell
    export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY"
    export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_KEY"
    export HCP_CLIENT_ID="YOUR_HCP_CLIENT_ID"
    export HCP_CLIENT_SECRET="YOUR_HCP_SECRET"
    ```
2. Run Terraform (resource creation will take 10-15 minutes to complete)
    1. `terraform init`
    2. `terraform apply`
3. Configure terminal to communicate with your EKS cluster
    1. `aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw kubernetes_cluster_id)`
4. Install Consul
    1. `consul-k8s install -config-file=consul/values.yaml`
5. Deploy HashiCups
    1. `kubectl apply --filename hashicups/`
6. Create API Gateway and respective route resources
    1. `kubectl apply --filename api-gw/consul-api-gateway.yaml && kubectl wait --for=condition=ready gateway/api-gateway --timeout=90s && kubectl apply --filename api-gw/referencegrant.yaml && kubectl apply --filename api-gw/rbac.yaml && kubectl apply --filename api-gw/intention-apigw.yaml && kubectl apply --filename api-gw/route-frontend.yaml` 
7. Locate the external IP for your API Gateway and open it
    1. `kubectl get services`
8. The frontend is served, however the user browser needs access to the Public API to display the coffees in the HashiCups web store
9.  Expose the `public-api` via the API Gateway
    1. `kubectl apply --filename api-gw/route-api.yaml`
10. Refresh the HashiCups page, observe the HashiCups web store items
11. Clean up
    1. Remove Consul from the K8s platform and its associated external load-balancer resource
      `consul-k8s uninstall`
    2. Destroy Terraform resources
      `terraform destroy`