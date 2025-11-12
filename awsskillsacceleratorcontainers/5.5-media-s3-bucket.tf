resource "aws_s3_bucket" "cms_media_storage_bucket" {
  bucket = "${local.project_name}-media-storage-bucket"


}

resource "aws_s3_bucket_ownership_controls" "cms_media_bucket_acls" {
  bucket = aws_s3_bucket.cms_media_storage_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred" # or "ObjectWriter"
  }
}

resource "aws_ssm_parameter" "cms_media_bucket_database_name" {
  depends_on = [module.ks_database]
  name       = "${local.ssm_parameter_name_prefix}/cms/bucket"
  type       = "String"
  value      = aws_s3_bucket.cms_media_storage_bucket.bucket
}

resource "aws_ssm_parameter" "aws_region" {
  depends_on = [module.ks_database]
  name       = "${local.ssm_parameter_name_prefix}/region"
  type       = "String"
  value      = data.aws_region.current.region
}
