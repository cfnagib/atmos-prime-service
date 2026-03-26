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
      image     = "cfnagib/atmos-prime-service:latest" # Matches Docker Hub image
      essential = true
      portMappings = [
        {
          # UPDATED: Changed from 80 to 8000 to match the actual FastAPI app port
          container_port = 8000
          host_port      = 8000
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
    # UPDATED: Changed from private_subnet to public_subnet to match the new vpc.tf naming
    subnets          = [aws_subnet.public_subnet.id]
    security_groups  = [aws_security_group.api_sg.id]
    
    # Keeping this false as a security best practice for restricted access
    assign_public_ip = false
  }
}