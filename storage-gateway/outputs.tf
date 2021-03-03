###################
# outputs.tf
###################

output "storage_gateway_id" {
  value = aws_storagegateway_gateway.this.id
}

output "storage_gateway_arn" {
  value = aws_storagegateway_gateway.this.arn
}

output "disk_id" {
  value = data.aws_storagegateway_local_disk.this.disk_id
}

output "storage_cache_id" {
  value = aws_storagegateway_cache.this.id
}