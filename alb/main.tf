###################
# ALB
###################
terraform {
  backend "s3" {}
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.6.1"

  name     = var.name
  internal = false

  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true

  vpc_id          = var.vpc_id
  subnets         = var.public_subnet_ids
  security_groups = var.security_group_ids

  access_logs = {
    enabled = var.alb_logging_enabled
    bucket  = var.alb_log_bucket_name
    prefix  = var.alb_log_location_prefix
  }

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.example.arn
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name                 = "${var.name}-tg-default"
      backend_protocol     = "HTTP"
      backend_port         = var.http_port
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 60
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 5
        timeout             = 30
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
  ]

  tags = merge(
    {
      "Name" = var.name
    }
  )
}

# Find a certificate that is issued
data "aws_acm_certificate" "example" {
  domain   = var.certificate_domain_name
  statuses = ["ISSUED"]
}


