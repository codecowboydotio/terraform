data "archive_file" "python_lambda" {
  type = "zip"
  source_dir = "lambda_code/"
  #source_file = "lambda_code/webhook.py"
  output_path = "foo.zip"
}

resource "aws_s3_object" "python_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "foo.zip"
  source = data.archive_file.python_lambda.output_path

  etag = filemd5(data.archive_file.python_lambda.output_path)
}


resource "aws_lambda_function" "webhook_webhook" {
  #function_name = "SampleWebhook"
  function_name = "${var.name-prefix}-${var.project}-api-gw"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.python_lambda.key

  runtime = "python3.11"
  handler = "webhook.lambda_handler"

  source_code_hash = data.archive_file.python_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "webhook_webhook" {
  name = "/aws/lambda/${aws_lambda_function.webhook_webhook.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "function_name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.webhook_webhook.function_name
}
