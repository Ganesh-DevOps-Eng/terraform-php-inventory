variable "username" {}
variable "password" {}
variable "eb_solution_stack" {}

variable "instance_type" {}
#vpc module variable
variable "vpc_cidr_block" {}
variable "project_name" {}
variable "az_count" {}


#CICD-Module

variable "region" {}
variable "FullRepositoryId" {} #update
variable "s3_location" {}
variable "ConnectionArn" {}
variable "BranchName" {}
variable "git_pat" {}
variable "ami_id" {}
variable "root_domain_name" {}
variable "DATABASE_NAME" {}