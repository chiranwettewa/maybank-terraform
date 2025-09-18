output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket
}


output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
}