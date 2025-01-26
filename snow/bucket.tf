resource "random_string" "bucket_suffix" {
  special = false
  upper   = false
  length  = 5
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.name-prefix}-${var.project}-${random_string.bucket_suffix.id}"
  force_destroy = true

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-bucket-${random_string.bucket_suffix.id}"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [ aws_s3_bucket.lambda_bucket ]
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"

  depends_on = [ aws_s3_bucket_ownership_controls.example ]
}
