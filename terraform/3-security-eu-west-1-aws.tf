resource "aws_security_group" "flask_app" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.flask_app.id

  ingress {
    description = "Custom TCP"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.whitelist
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "flaskEcsPolicies"
  description        = "Allows ECS tasks to call AWS services on your behalf"
  assume_role_policy = file("${path.module}/policies/ecs-assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "cognito_power_user" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}

resource "aws_iam_role_policy_attachment" "sqs_full_access" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ECSTaskExecution"
  description        = "Allows ECS tasks to call AWS services on your behalf"
  assume_role_policy = file("${path.module}/policies/ecs-assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "lambda_task_execution_role" {
  name               = "LambdaTaskExecution"
  description        = "Allows Lambda functions to call AWS services on your behalf"
  assume_role_policy = file("${path.module}/policies/lambda-assume-role-policy.json")
}

resource "aws_iam_policy" "lambda_services_policy" {
  policy      = file("${path.module}/policies/lambda-services-acess-policy.json")
  description = "IAM policy for AWS services from a lambda"
}

resource "aws_iam_role_policy_attachment" "lambda_task_execution_role" {
  role       = aws_iam_role.lambda_task_execution_role.name
  policy_arn = aws_iam_policy.lambda_services_policy.arn
}