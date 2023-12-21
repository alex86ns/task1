# Create RDS Aurora PostgreSQL instance
resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.vpc_name}-aurora-cluster"
  engine_mode             = "serverless"
  engine                  = "aurora-postgresql"
  master_username         = var.postgres_user
  master_password         = var.postgres_password
  database_name           = var.postgres_name
  vpc_security_group_ids  = [aws_security_group.sg_rds.id]
  availability_zones      = ["eu-central-1a", "eu-central-1b"]
  skip_final_snapshot = true
  db_subnet_group_name =  aws_db_subnet_group.subnet_group.name
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.vpc_name}_subnet-group"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
}

# Create security group for RDS
resource "aws_security_group" "sg_rds" {
  vpc_id = aws_vpc.alex_vpc.id
  ingress {
   from_port   = var.postgres_port
   to_port     = var.postgres_port
   protocol    = "tcp"
   cidr_blocks = [aws_subnet.subnet-1.cidr_block, aws_subnet.subnet-2.cidr_block]
   description = "Open postgres port for local subnets"
 }
}