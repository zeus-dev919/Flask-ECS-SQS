resource "aws_ecs_cluster" "flask_app" {
  name = "FlaskAppCluster"
}

resource "aws_ecs_task_definition" "flask_app" {
  family                   = "flask_app"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "0.5GB"
  cpu                      = "0.25 vCPU"
  container_definitions    = templatefile("${path.module}/task-definitions/flask_app.json.tpl", {
                                         app_image      = var.app_image,
                                         app_port       = var.app_port,
                                         aws_region     = var.aws_region,
                                         log_group_name = var.log_group_name
                                         })
}

resource "aws_ecs_service" "flask_app" {
  name            = "flask_app"
  cluster         = aws_ecs_cluster.flask_app.id
  task_definition = aws_ecs_task_definition.flask_app.id
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.flask_app.id]
    subnets          = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
    assign_public_ip = true
  }
}