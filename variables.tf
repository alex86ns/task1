# AWS Key ID
variable "aws_access_key_id" {
  default   = ""
  sensitive = true
}

# AWS Secret Access Key
variable "aws_secret_access_key" {
  default   = ""
  sensitive = true
}

# AWS Subnets
variable "cloud_subnet" {
  default   = "10.21.0.0/16"
}

variable "subnet1" {
  default   = "10.21.1.0/24"
}

variable "subnet2" {
  default   = "10.21.2.0/24"
}

variable "backend_port" {
  type = number
  default   = 8000
}

variable "frontend_port" {
  type = number
  default   = 80
}

variable "frontend_image_url" {
  default   = "docker.io/micic/vortexwest:frontend"
}


variable "backend_image_url" {
  default   = "docker.io/micic/vortexwest:backend"
}

#Environment variables
variable "postgres_name" {
  type        = string
  default     = "postgres"
}

variable "postgres_user" {
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  type        = string
  default     = "v2PR90BLsmjASzE"
  sensitive = true
}

variable "postgres_port" {
  default     = "5432"
}

# VPC name
variable "vpc_name" {
  type        = string
  default     = "test"
}