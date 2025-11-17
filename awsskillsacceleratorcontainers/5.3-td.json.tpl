[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": 0,
    "memoryReservation": 768,
    "memory": 1024,
    "essential": ${essential},
    "portMappings": ${portMappings},
    "environment": ${environment},
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