###################
# Outputs
###################

output "eks_cluster_id" {
  value = data.aws_eks_cluster.cluster.id
}

output "eks_cluster_name" {
  value = data.aws_eks_cluster.cluster.name
}

