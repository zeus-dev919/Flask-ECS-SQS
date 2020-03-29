resource "aws_cloudwatch_log_group" "flask_app" {
  name = var.log_group_name
}

resource "aws_cloudwatch_log_group" "lambda_triggered_by_queue" {
  name = "/aws/lambda/${var.lambda_triggered_by_queue_name}"
}