resource "aws_s3_bucket" "my_bucket" {
  bucket          = var.s3_bucket_name

  tags = {
    Name          = var.s3_bucket_name
    Environment   = "test"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "default-bucket-policy"
    status = "Enabled"

    filter {
      prefix = "tmp/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_logging" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  target_bucket = "log-access-bucket-faizan"  # change existing logging bucket name for your account
  target_prefix = "${aws_s3_bucket.my_bucket.id}/"
  }

resource "aws_s3_bucket_public_access_block" "my_bucket" {
  bucket                  = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowSSLRequestsOnly",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.my_bucket.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.my_bucket.id}"
        ],
        "Condition": {
          "Bool": {
            "aws:SecureTransport": "false"
          }
        }
      }
    ]
  }
  POLICY
}
