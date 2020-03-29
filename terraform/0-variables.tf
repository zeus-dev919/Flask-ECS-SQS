variable "aws_region" {
  description = "The AWS region which is used"
  type        = string
  default     = "eu-west-1"
}

variable "app_port" {
  description = "Port on which application is running"
  type        = number
  default     = 5008
}

variable "app_image" {
  description = "Docker image to run in ECS"
  type        = string
  default     = "szymcio32/flask-app:latest"
}

variable "user_pool_name" {
  description = "Name of the Cognito user pool used by flask app"
  type        = string
  default     = "flask_app"
}

variable "user_pool_client_name" {
  description = "Name of the Cognito user pool client used by flask app"
  type        = string
  default     = "flask_app"
}

variable "sqs_name" {
  description = "Name of the SQS used by flask app"
  type        = string
  default     = "flask_app"
}

variable "log_group_name" {
  description = "Name of the log group name used by flask app"
  type        = string
  default     = "/ecs/flask_app"
}

variable "lambda_triggered_by_queue_name" {
  description = "Name of the lambda function which is trigerred by queue"
  type        = string
  default     = "triggered_by_queue"
}

variable "whitelist" {
  description = "Allowed CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}