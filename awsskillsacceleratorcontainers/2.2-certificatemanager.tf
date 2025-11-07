/*
    Resource: Certificate Manager
    Description: Create an SSL certificate for the ALB used for routing
    backend traffic, front traffic, and DNS validation with Route53.
 */
resource "aws_acm_certificate" "ks_acm_certificate" {
  domain_name       = aws_route53_zone.ks_route53_public_hosted_zone.name
  validation_method = "DNS"
  subject_alternative_names = [
    aws_route53_zone.ks_route53_public_hosted_zone.name,
    "www.${aws_route53_zone.ks_route53_public_hosted_zone.name}",
    "*.siba.${aws_route53_zone.ks_route53_public_hosted_zone.name}"
  ]
}

resource "aws_route53_record" "ks_route53_a_record_acm_cname_records" {
  for_each = {

    for dvo in aws_acm_certificate.ks_acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.ks_route53_public_hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "ks_acm_certificate_validations" {
  certificate_arn = aws_acm_certificate.ks_acm_certificate.arn
  validation_record_fqdns = [
    for record in aws_route53_record.ks_route53_a_record_acm_cname_records : record.fqdn
  ]
}

# resource "aws_acm_certificate" "ks_acm_certificate_wanda" {
#   domain_name       = "wanda.${aws_route53_zone.ks_route53_public_hosted_zone.name}"
#   validation_method = "DNS"
#   subject_alternative_names = [
#     "*.wanda.${aws_route53_zone.ks_route53_public_hosted_zone.name}"
#   ]
# }

# resource "aws_route53_record" "ks_route53_a_record_acm_cname_records_wanda" {
#   for_each = {

#     for dvo in aws_acm_certificate.ks_acm_certificate_wanda.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.ks_route53_public_hosted_zone.zone_id
# }

# resource "aws_acm_certificate_validation" "ks_acm_certificate_validations_wanda" {
#   certificate_arn = aws_acm_certificate.ks_acm_certificate_wanda.arn
#   validation_record_fqdns = [
#     for record in aws_route53_record.ks_route53_a_record_acm_cname_records_wanda : record.fqdn
#   ]
# }
