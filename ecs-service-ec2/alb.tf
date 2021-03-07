###################
# ALB
###################
locals {
  target_groups = ["primary", "secondary"]
}

resource "aws_lb_listener_rule" "routing" {
  listener_arn = var.http_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_alb_target_group.target-group.0.arn
        weight = 100
      }

      target_group {
        arn    = aws_alb_target_group.target-group.1.arn
        weight = 0
      }

      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

  condition {
    host_header {
      values = [var.routing_url]
    }
  }
}

resource "aws_alb_target_group" "target-group" {
  count = length(local.target_groups)
  name  = "${var.name}-tg-${element(local.target_groups, count.index)}"

  port        = var.http_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  // TODO: Make configurable with defaults
  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "2"
    interval            = "150"
    matcher             = "200-299"
    path                = var.health_check_uri
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "120"
  }

  tags = {
    Name = "${var.name}-tg-${element(local.target_groups, count.index)}"
  }
}

