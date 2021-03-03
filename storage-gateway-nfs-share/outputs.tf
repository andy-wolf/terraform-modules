###################
# outputs.tf
###################

output "nfs_file_share_arn" {
  value = aws_storagegateway_nfs_file_share.this.arn
}
