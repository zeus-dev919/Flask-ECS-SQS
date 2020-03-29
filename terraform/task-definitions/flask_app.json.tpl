${jsonencode(
    [
      {
        "name": "flask_app",
        "image": "${app_image}",
        "essential": true,
        "portMappings": [
          {
            "containerPort": "${app_port}",
            "hostPort": "${app_port}"
          }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-region": "${aws_region}",
                "awslogs-group": "${log_group_name}",
                "awslogs-stream-prefix": "ecs"
            }
        }
      }
    ]
)}