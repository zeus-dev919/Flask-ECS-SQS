data "archive_file" "lambda_triggered_by_queue" {
  type        = "zip"
  source_file = "${path.module}/lambdas/triggered_by_queue.py"
  output_path = "${path.module}/lambdas/triggered_by_queue.zip"
}

resource "aws_s3_bucket" "flask_app" {
  bucket = "flask-app-python-app-aws"
  region = var.aws_region
}

resource "aws_s3_bucket_object" "triggered_by_queue" {
  bucket  = aws_s3_bucket.flask_app.bucket
  key     = "triggered_by_queue.zip"
  source  = "${path.module}/${data.archive_file.lambda_triggered_by_queue.output_path}"
}