[
  {
    "name": "${container_name}",
    "image": "${container_image}",
    "cpu": ${container_cpu},
    "memory": ${container_memory},
    "memoryReservation": ${container_memory_reservation},
    "networkMode":"awsvpc",
    "essential": ${essential},
    "startTimeout": ${start_timeout},
    "stopTimeout": ${stop_timeout},
    "logConfiguration":{
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${awslogs_region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": ${portMappings},
    "environment": ${environment},
    "secrets": ${secrets},
    "mountPoints": ${mountPoints}
  }
]

