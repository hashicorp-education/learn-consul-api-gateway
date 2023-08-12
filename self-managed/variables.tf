variable "cluster_id" {
  type        = string
  description = "The name of your HCP Consul cluster"
  default     = "learn-apigw"
}

variable "vpc_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-west-2"
}

variable "consul_version" {
  type        = string
  description = "The HCP Consul version"
  default     = "v1.16.0"
}
