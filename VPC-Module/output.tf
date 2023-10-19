output "vpc" {
  value = aws_vpc.vpc.id
}

output "public_subnet" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = toset([aws_subnet.private[0].id, aws_subnet.private[1].id])
}


output "private_subnet" {
  value = aws_subnet.private[*].id
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

output "elastic_beanstalk_sg" {
  value = aws_security_group.elastic_beanstalk_sg.id
}

output "rds_sg" {
  value = [aws_security_group.rds_sg.id]
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}