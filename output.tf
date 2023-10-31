output "db_host" {
  value = module.RDS-Module.db_host
}


output "load_balancer_dns" {
  value = module.RDS-Module.load_balancer_dns
}

output "updated_object_content" {
  value = aws_s3_object.env_file.content
}