resource "aws_sqs_queue" "flask_app" {
  name = var.sqs_name
}