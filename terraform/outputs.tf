output "site_url" {
  description = "Public HTTPS URL once applied."
  value       = "https://${var.domain_name}/"
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_distribution_id" {
  description = "Distribution ID (for cache invalidations in CI)."
  value       = aws_cloudfront_distribution.site.id
}

output "bucket_name" {
  description = "S3 content bucket to sync the built site into."
  value       = aws_s3_bucket.site.id
}

output "publish_command" {
  description = "How CI ships the built site."
  value       = "aws s3 sync ./site s3://${aws_s3_bucket.site.id}/ --delete && aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.site.id} --paths '/*'"
}
