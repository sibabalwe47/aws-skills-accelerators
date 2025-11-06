resource "aws_route53_zone" "ks_route53_public_hosted_zone" {
  name = "awsmasterscircle.co.za"
}

resource "aws_route53_record" "ks_route53_a_record_default_ip" {
  zone_id = aws_route53_zone.ks_route53_public_hosted_zone.zone_id
  name    = aws_route53_zone.ks_route53_public_hosted_zone.name
  type    = "A"
  ttl     = "600"
  records = ["169.239.219.58"]
}