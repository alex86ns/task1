# Create virtual private cloud
resource "aws_vpc" "alex_vpc" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block = var.cloud_subnet
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

# Create subnet - 1
resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.alex_vpc.id
  cidr_block              = var.subnet1
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "${var.vpc_name}-subnet-1"
  }
}

# Create subnet - 2
resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.alex_vpc.id
  cidr_block              = var.subnet2
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
  tags = {
    Name = "${var.vpc_name}-subnet-2"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.alex_vpc.id
}

# Create main route table
resource "aws_route_table" "route_main" {
 vpc_id = aws_vpc.alex_vpc.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.ig.id
 }
}

# Associate route with subnet - 1
resource "aws_route_table_association" "route_subnet_1" {
 subnet_id      = aws_subnet.subnet-1.id
 route_table_id = aws_route_table.route_main.id
}

# Associate route with subnet - 2
resource "aws_route_table_association" "route_subnet_2" {
 subnet_id      = aws_subnet.subnet-2.id
 route_table_id = aws_route_table.route_main.id
}