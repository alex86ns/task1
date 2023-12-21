# Create ECS Task Definition BACKEND
resource "aws_ecs_task_definition" "td_backend" {
  family                   = "${var.vpc_name}-Backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "2048"

  container_definitions = jsonencode([
    {
      name  = "${var.vpc_name}-Backend",
      image = var.backend_image_url,

      portMappings = [
        {
          containerPort = var.backend_port,
          hostPort      = var.backend_port,
        },
      ],
      
      environment = [
        {
          name  = "POSTGRES_NAME",
          value = var.postgres_name,
        },
        {
          name  = "POSTGRES_USER",
          value = var.postgres_user,
        },
        {
          name  = "POSTGRES_PASSWORD",
          value = var.postgres_password,
        },
        {
          name  = "POSTGRES_HOST",
          value = "${aws_rds_cluster.aurora.endpoint}",
        },
        {
          name  = "POSTGRES_PORT",
          value = var.postgres_port,
        },
      ],
      
      command = ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:${var.backend_port}",]
    },
  ])
}

# Create ECS Service - Backend
resource "aws_ecs_service" "ecs_backend" {
  name            = "${var.vpc_name}_ecs_backend"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.td_backend.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = true
    subnets = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
    security_groups = [aws_security_group.sg_backend.id]
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    container_name   = "${var.vpc_name}-Backend"
    container_port   = var.backend_port
  }
}

# Create security group for Backend
resource "aws_security_group" "sg_backend" {
  vpc_id = aws_vpc.alex_vpc.id
  ingress {
   from_port   = var.backend_port
   to_port     = var.backend_port
   protocol    = "tcp"
   cidr_blocks = [aws_subnet.subnet-1.cidr_block, aws_subnet.subnet-2.cidr_block]
   description = "Open backend port for local subnets"
 }
  egress {    
    description      = "Outbound rules"
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}