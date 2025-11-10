[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": 0,
    "memory": 512,
    "essential": ${essential},
    "portMappings": ${portMappings},
    "secrets": ${secrets},
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
        "awslogs-group": "${loggroup}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]