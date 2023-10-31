variable "username" {}
variable "password" {}

variable "instance_type" {}
#vpc module variable
variable "vpc_cidr_block" {}
variable "project_name" {}
variable "az_count" {}
variable "eb_solution_stack" {}

variable "ami_id" {}
variable "root_domain_name" {}
variable "DATABASE_NAME" {}
variable "FullRepositoryId" {}
variable "git_pat" {}


data "aws_key_pair" "bastion_key_pair" {
  filter {
    name = "tag:Name"
    values = ["ganesh"]
  }
  depends_on = [aws_key_pair.bastion_pair]
}
