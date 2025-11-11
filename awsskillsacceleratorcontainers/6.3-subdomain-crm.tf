/*
 *  Private Hosted Zone DNS names
 */
resource "aws_route53_record" "crm_cname_record" {
  zone_id = aws_route53_zone.ks_route53_public_hosted_zone.zone_id
  name    = "cms.siba.${aws_route53_zone.ks_route53_public_hosted_zone.name}"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = false
  }
}