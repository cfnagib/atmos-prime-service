# 1. ECS Cluster Definition
resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# 2. CloudWatch Log Group for Application Monitoring
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

# 3. ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = var.project_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "prime-service-app"
      image     = "cfnagib/atmos-prime-service:latest" # Ensure this matches your Docker Hub image
      essential = true
      portMappings = [
        {
          container_port = 80
          host_port      = 80
        }
      ]
      logConfiguration = {
        log_driver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# 4. ECS Service to manage the container lifecycle
resource "aws_ecs_service" "main_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_subnet.id]
    security_groups  = [aws_security_group.api_sg.id]
    assign_public_ip = false # Security requirement: No direct public access
  }
}