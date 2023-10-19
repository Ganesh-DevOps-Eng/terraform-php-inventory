variable "vpc_cidr_block" {}
variable "project_name" {}
variable "az_count" {}

variable "rds_sg" {
  type    = set(string)
  default = []
}