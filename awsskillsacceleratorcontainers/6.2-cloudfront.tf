# module "cloudfront" {
#   source  = "terraform-aws-modules/cloudfront/aws"
#   version = "5.0.1"

#   /* 
#    *    Subdomain
#    */
#   aliases = [
#     aws_route53_zone.ks_route53_public_hosted_zone.name
#   ]


#   /* 
#    *    Basic defaults
#    */
#   enabled      = true
#   staging      = false
#   http_version = "http2and3"
#   comment      = "CloudFront Distribution for CDP."
# }