# Create load balancer - FRONTEND
resource "aws_lb" "frontend_lb" {
  name               = "${var.vpc_name}-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [
    aws_subnet.subnet-1.id,
    aws_subnet.subnet-2.id,
  ]

  enable_deletion_protection = false
}


resource "aws_lb_listener" "frontend_lb_listener" {
 load_balancer_arn = aws_lb.frontend_lb.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.frontend_tg.arn
 }
}

resource "aws_lb_target_group" "frontend_tg" {
 name        = "${var.vpc_name}-frontend-tg"
 port        = var.frontend_port
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.alex_vpc.id

 health_check {
   path = "/"
 }
}


# Create load balancer - BACKEND
resource "aws_lb" "backend_lb" {
  name               = "${var.vpc_name}-backend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [
    aws_subnet.subnet-1.id,
    aws_subnet.subnet-2.id,
  ]

  enable_deletion_protection = false
}


resource "aws_lb_listener" "backend_lb_listener" {
 load_balancer_arn = aws_lb.backend_lb.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.backend_tg.arn
 }
}

resource "aws_lb_target_group" "backend_tg" {
 name        = "${var.vpc_name}-backend-tg"
 port        = var.backend_port
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.alex_vpc.id

 health_check {
   path = "/swagger/"
 }
}