resource "aws_lambda_function" "flask_app" {
  function_name = var.lambda_triggered_by_queue_name
  handler       = "triggered_by_queue.lambda_handler"
  role          = aws_iam_role.lambda_task_execution_role.arn
  runtime       = "python3.8"
  s3_bucket     = aws_s3_bucket.flask_app.bucket
  s3_key        = aws_s3_bucket_object.triggered_by_queue.key

  depends_on    = [aws_iam_role_policy_attachment.lambda_task_execution_role, aws_cloudwatch_log_group.lambda_triggered_by_queue]
}

resource "aws_lambda_event_source_mapping" "flask_app_sqs" {
  event_source_arn = aws_sqs_queue.flask_app.arn
  function_name    = var.lambda_triggered_by_queue_name
  enabled          = true
}