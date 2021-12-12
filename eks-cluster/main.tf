terraform {
  backend "s3" {}
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>17.24.0"

  cluster_name    = var.name
  cluster_version = "1.21"
  subnets         = var.private_subnets

  vpc_id = var.vpc_id

  node_groups = {
    first = {
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1

      instance_type = "m5.large"
    }
  }

  write_kubeconfig   = true
  kubeconfig_output_path = "./"
}