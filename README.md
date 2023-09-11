# Learn Consul - API Gateway

This is a companion repository to the [Control Access into the Service Mesh with Consul API Gateway](https://developer.hashicorp.com/consul/tutorials/kubernetes/kubernetes-api-gateway), containing sample configuration to:

- Set up a Consul server
    - Cloud: HCP Consul and AWS EKS Kubernetes cluster
    - Self-Managed: AWS EKS Kubernetes cluster 
- Deploy example applications (HashiCups and echo)
- Deploy Consul API Gateway
- Apply API gateway routes to enable ingress to HashiCups
- Apply API gateway routes to load balance echo services