data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "random_string" "cluster_id" {
  length  = 6
  special = false
  upper   = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = local.cluster_id
  cluster_version = "1.26"

  cluster_addons = {
    aws-ebs-csi-driver = { most_recent = true }
  }

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    # Needed by the aws-ebs-csi-driver
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    ]
  }

  eks_managed_node_groups = {
    one = {
      name = "apigw-node"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 3
    }
  }

  node_security_group_additional_rules = {

    # Allow all outgoing communication
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    # allow from any
    ingress_all = {
      description      = "allow ingress from any"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

# Uninstalls consul resources (API Gateway controller, Consul-UI, and AWS ELB, and removes associated AWS resources)
# on terraform destroy
resource "null_resource" "kubernetes_consul_resources" {
  provisioner "local-exec" {
    when    = destroy
    # This command attempts to uninstall consul resources only if they are present
    command = "kubectl get svc/consul-ui --namespace consul && kubectl delete svc/consul-ui --namespace consul || true; kubectl get svc/api-gateway --namespace consul && kubectl delete svc/api-gateway --namespace consul || true"
  }
  depends_on = [module.eks]
}
