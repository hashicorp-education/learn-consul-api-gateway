module "aws_hcp_consul" {
  source  = "hashicorp/hcp-consul/aws"
  version = "~> 0.8.8"

  hvn                = hcp_hvn.main
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = concat(module.vpc.public_subnets, module.vpc.database_subnets)
  route_table_ids    = concat(module.vpc.public_route_table_ids, module.vpc.database_route_table_ids)
  security_group_ids = [module.eks.cluster_primary_security_group_id]
}

resource "random_string" "cluster_id" {
  length  = 6
  special = false
  upper   = false
}

resource "hcp_consul_cluster" "main" {
  cluster_id         = local.cluster_id
  hvn_id             = hcp_hvn.main.hvn_id
  public_endpoint    = true
  tier               = var.consul_tier
  min_consul_version = var.consul_version
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = hcp_consul_cluster.main.id
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

# resource "local_file" "consul-helm-values" {
#   filename = "yamls/consul-helm-values.yaml"
#   content  = templatefile("template/consul.tpl", {
#       datacenter       = hcp_consul_cluster.main.datacenter,
#       consul_hosts     = hcp_consul_cluster.main.consul_private_endpoint_url,
#       cluster_id       = hcp_consul_cluster.main.datacenter,
#       k8s_api_endpoint = module.eks.cluster_endpoint,
#       consul_version   = substr(hcp_consul_cluster.main.consul_version, 1, -1),
#       api_gateway_version = var.api_gateway_version,
#     }
#   )
# }

# resource "local_file" "hcp-consul-secrets" {
#   filename = "yamls/consul-secrets.yaml"
#   content  = templatefile("template/consul.tpl", {
#       name       = hcp_consul_cluster.main.datacenter
#       namespace = "consul"
#       bootstrapToken = hcp_consul_cluster_root_token.token.secret_id
#       caCert = base64decode(hcp_consul_cluster.main.consul_ca_file)
#       gossipEncryptionKey = jsondecode(base64decode(hcp_consul_cluster.main.consul_config_file))["encrypt"]
#     }
#   )
# }
