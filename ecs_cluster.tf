# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
   name = "${var.vpc_name}_ecs_cluster"
 }