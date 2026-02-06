output "s3_bucket_name" {
  description = "Nome do bucket S3 usado como backend"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3 usado como backend"
  value       = aws_s3_bucket.terraform_state.arn
}