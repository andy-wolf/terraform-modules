###################
# storage-gateway.tf
###################

terraform {
  backend "s3" {}
}

resource "aws_storagegateway_gateway" "this" {
  gateway_ip_address = var.gateway_ip
  gateway_name     = "storage-gateway"
  gateway_timezone = "GMT"
  gateway_type     = "FILE_S3"

  cloudwatch_log_group_arn = aws_cloudwatch_log_group.storage_gateway.arn

  # There is no Storage Gateway API for reading gateway_ip_address
  lifecycle {
    ignore_changes = [gateway_ip_address]
  }
}

data "aws_storagegateway_local_disk" "this" {
  disk_node   = var.cache_volume_disk_path
  gateway_arn = aws_storagegateway_gateway.this.arn
}

resource "aws_storagegateway_cache" "this" {
  disk_id     = data.aws_storagegateway_local_disk.this.disk_id
  gateway_arn = aws_storagegateway_gateway.this.arn
}

resource "aws_cloudwatch_log_group" "storage_gateway" {
  name = "storage-gateway-log-group"
}




