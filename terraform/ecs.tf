# 1. ECS Cluster Definition
resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# 2. CloudWatch Log Group for Application Monitoring
# DESIGN CHOICE: Centralized Logging
# Retention is set to 7 days to balance between visibility and cost-efficiency 
# during the initial phases of the space logistics platform.
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

# 3. ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = var.project_name
  network_mode             = "awsvpc" # Required for Fargate to assign unique ENIs to each pod
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  # DESIGN CHOICE: AWS Fargate (Serverless Compute)
  # I opted for Fargate to eliminate the overhead of managing EC2 instances. 
  # This ensures the focus remains on the prime-service logic and security 
  # rather than OS patching or host-level maintenance.
  container_definitions = jsonencode([
    {
      name      = "prime-service-app"
      image     = "cfnagib/atmos-prime-service:latest"
      essential = true
      portMappings = [
        {
          container_port = 8000
          host_port      = 8000
          protocol       = "tcp"
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

# 4. ECS Service
resource "aws_ecs_service" "app_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_subnet.id] # Place in subnet with VPN connectivity
    security_groups  = [aws_security_group.api_sg.id] # Using the restricted SG from vpc.tf
    assign_public_ip = true # Still reachable only via VPN due to SG constraints
  }
}