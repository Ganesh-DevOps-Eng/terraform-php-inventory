output "my_key_pair" {
  value = aws_key_pair.my_key_pair.key_name
}

output "db_host" {
  value = aws_db_instance.rds.endpoint
}

output "mysql_host" {
  value = aws_db_instance.rds.endpoint
}

output "load_balancer_dns" {
  value = aws_lb.eb_lb.dns_name
}

output "app_url" {
  value = aws_elastic_beanstalk_environment.eb_env.endpoint_url
}