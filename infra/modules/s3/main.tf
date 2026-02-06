resource "aws_s3_bucket" "process_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "process-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "process_bucket" {
  bucket = aws_s3_bucket.process_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "process_bucket" {
  bucket = aws_s3_bucket.process_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
