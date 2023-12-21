 # Create ECS Task Definition FRONTEND
resource "aws_ecs_task_definition" "td_frontend" {
  family                   = "${var.vpc_name}-Frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "2048"

  container_definitions = jsonencode([
    {
      name  = "${var.vpc_name}-Frontend",
      image = var.frontend_image_url,
      portMappings = [
        {
          containerPort = var.frontend_port,
          hostPort      = var.frontend_port,
        },
      ],
    },
  ])
}

# Create ECS Service - FRONTEND
resource "aws_ecs_service" "ecs_frontend" {
  name            = "${var.vpc_name}_ecs_frontend"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.td_frontend.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  
  network_configuration {
    subnets = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.sg_frontend.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "${var.vpc_name}-Frontend"
    container_port   = var.frontend_port
  }
}

# Create security group for Frontend
resource "aws_security_group" "sg_frontend" {
  vpc_id = aws_vpc.alex_vpc.id
  ingress {
   from_port   = var.frontend_port
   to_port     = var.frontend_port
   protocol    = "tcp"
   cidr_blocks = [aws_subnet.subnet-1.cidr_block, aws_subnet.subnet-2.cidr_block]
   description = "Open frontend port for local subnets"
 }
  egress {    
    description      = "Outbound rules"
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}