# Learn Consul - API Gateway

This is a companion repo to the [Control Access into the Service Mesh with Consul API Gateway](https://developer.hashicorp.com/consul/tutorials/kubernetes/kubernetes-api-gateway), containing sample configuration to:

- Set up a Consul server
    - Cloud: HCP Consul and AWS EKS
    - Self-Managed: Local `kind` Kubernetes cluster 
- Deploy example applications HashiCups and echo server
- Deploy Consul API Gateway
- Explore Ingress into the service mesh with HashiCups
- Explore Load Balancing with echo Ssrver