###################
# storage-gateway.tf
###################

terraform {
  backend "s3" {}
}

// Get activation key from storage gateway instance
data "external" "activation_key" {
  program = ["/bin/bash", "./get_activation_key.sh"]

  query = {
    IPADDR = var.gateway_ip,
    REGION = "eu-central-1",
  }
}

// data.external.jenkins_api_crumb.result.key

// Create new Storage Gateway
resource "aws_storagegateway_gateway" "example" {
  //gateway_ip_address = var.gateway_ip
  activation_key   = data.external.activation_key.result.key
  gateway_name     = "example"
  gateway_timezone = "GMT"
  gateway_type     = "FILE_S3"

/*
  # There is no Storage Gateway API for reading gateway_ip_address
  lifecycle {
    ignore_changes = ["gateway_ip_address"]
  }
*/
}

data "aws_storagegateway_local_disk" "example" {
  disk_path   = var.cache_volume_disk_path
  gateway_arn = aws_storagegateway_gateway.example.arn
}

resource "aws_storagegateway_cache" "example" {
  disk_id     = data.aws_storagegateway_local_disk.example.id
  gateway_arn = aws_storagegateway_gateway.example.arn
}

// Use IP address or activation key of storage-gateway-instance as variable input


// CloudWatch log group





