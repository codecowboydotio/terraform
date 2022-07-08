resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.name-prefix}-${var.project}"
  force_destroy = true

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-bucket"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}
