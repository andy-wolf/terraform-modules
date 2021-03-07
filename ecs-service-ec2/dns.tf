###################
# Route53
###################
data "aws_elb_hosted_zone_id" "main" {}

data "aws_route53_zone" "this" {
  name = var.domain_name
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.id
  name    = "${var.ecs_service_name}.${data.aws_route53_zone.this.name}"
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = true
  }
}
