###################
# Cloudwatch logs
###################
resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.name}-loggroup"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(
  {
    "Name" = "${var.name}-loggroup"
  }
  )
}

