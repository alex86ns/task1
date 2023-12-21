# Create security group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.alex_vpc.id
  ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }
  egress {    
    description      = "Outbound rules"
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}