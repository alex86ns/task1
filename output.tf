# Output Frontend Service URL
output "frontend_service_url" {
  value = aws_lb.frontend_lb.dns_name
}

# Output Backend Service URL
output "backend_service_url" {
  value = aws_lb.backend_lb.dns_name
}

# Output RDS Service URL
output "rds_service_url" {
  value = aws_rds_cluster.aurora.endpoint
}